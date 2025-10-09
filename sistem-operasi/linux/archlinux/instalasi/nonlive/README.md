## 🧩 Pendahuluan

Instalasi **Arch Linux dari sistem Manjaro** tanpa menggunakan media USB atau mode live merupakan pendekatan profesional yang umum dilakukan oleh administrator sistem dan pengguna lanjutan.

Metode ini memanfaatkan *arch-install-scripts* dan utilitas sistem Manjaro untuk melakukan *bootstrap* sistem Arch secara langsung ke partisi target. Jika anda memiliki pemahaman yang mendalam mengenai struktur hirarki direktori sistem maka sangat di rekomendasikan untuk mengikuti panduan ini untuk meningkatkan pemahaman bagaimana sebuah sistem operasi dibangun dari dasar. Pemahaman anda terkait struktur sangat di anjurkan walaupun tidak wajib.

Pendekatan ini memungkinkan pengguna:

* Menghindari kebutuhan pembuatan media instalasi eksternal.
* Memahami secara menyeluruh hubungan antara *mount point*, *kernel*, *bootloader*, dan *fstab*.
* Melatih kontrol penuh terhadap struktur sistem file Linux, terutama ketika bekerja pada lingkungan multi-boot (misalnya Manjaro dan Windows 11).

---

### 🎯 Tujuan

Tujuan dokumentasi ini adalah:

1. Menjelaskan langkah-langkah praktis instalasi Arch Linux dari sistem Manjaro secara langsung.
2. Menyertakan contoh kasus nyata dari proses instalasi yang **gagal**, lalu menganalisis penyebab serta solusi yang tepat berdasarkan **log aktual**.
3. Menyediakan referensi komprehensif untuk setiap perintah terminal yang digunakan—meliputi fungsi, argumen, opsi, direktori yang terlibat, dan dampak sistemik dari perintah tersebut.
4. Menjadi dokumen pembelajaran berjenjang yang bisa diikuti oleh pengguna pemula hingga profesional tanpa kehilangan konteks praktis.

---

### 🧱 Ruang Lingkup

Dokumentasi ini membahas:

* Proses pemasangan Arch Linux dari Manjaro (tanpa USB atau mode live). Hasil akhir, sistem operasi arch yang independent yang perlu masuk melalui booting, bukan sistem virtual yang berdiri diatas sistem operasi manapapun. 
* Studi kasus berbasis log nyata, hasil, dan kesalahan saat proses berlangsung.
* Penjelasan mendalam mengenai setiap perintah, opsi, dan file sistem yang terlibat.
* Analisis mendalam terhadap kesalahan `genfstab` dan kasus tumpang tindih kernel antara Manjaro dan Arch.
* Prinsip terbaik (best practices) untuk sistem multi-boot UEFI (Windows + Manjaro + Arch).

Tidak termasuk:

* Instalasi dari media USB, ISO, atau PXE.
* Proses pasca-instalasi lanjutan (desktop environment, driver grafis, dsb.).

---

## 🧩 Analisis Lingkungan Sistem Dan Persiapan Wajib Sebelum Mulai

Sebelum melakukan instalasi, penting untuk memahami **lingkungan host** tempat proses berlangsung.
Dalam konteks ini, Manjaro digunakan sebagai host dengan bootloader GRUB yang telah mengelola dua sistem operasi: **Windows 11** dan **Manjaro (Linux 6.12)**. Perintah yang digunakan untuk memeriksa konfigurasi partisi dan filesystem adalah:
1. **Cadangkan data penting** (dokumen, konfigurasi, snapshot Btrfs, atau image file ESP) jalankan berikut:

   ```bash
   sudo cp -a /boot/efi ~/backup-efi-$(date +%F).tar
   sudo cp /etc/fstab ~/fstab.bak.$(date +%F)
   ```

2. **Pastikan ada ruang kosong** untuk membuat partisi Arch — **jangan** resize NTFS/Windows dari Linux tanpa tahu risikonya; lebih aman resize dari Windows atau siapkan live media jika belum ada ruang kosong.

3. **Peralatan yang kita butuhkan pada Manjaro (host)**:

   ```bash
   # periksa karena biasanya sudah banyak yang terintstal
   pacman -Q arch-install-scripts gptfdisk dosfstools e2fsprogs btrfs-progs lvm2 cryptsetup grub efibootmgr os-prober
   # jika banyak yang belum sebaiknya instal langsung semuanya
   sudo pacman -Syu --noconfirm arch-install-scripts gptfdisk dosfstools e2fsprogs btrfs-progs lvm2 cryptsetup grub efibootmgr os-prober --needed
   ```

   (paket relevan; pilih sesuai kebutuhan: `cryptsetup` bila ingin LUKS).
   Metode memasang Arch dari Linux dipanduan oleh ArchWiki: install dari sistem Linux yang sedang berjalan. | wiki.archlinux.org

---

### 🧩 Pemeriksaan Struktur Disk dan Persiapan Audit Sistem Awal Dan Deskripsi Perintah:

Sebelum menoreh langkah pertama, ada baiknya memahami pepatah lama dunia sistem: *“Jangan melangkah ke dalam sistem sebelum tahu di mana pijakannya.”* Maka tahap pertama ialah melakukan audit terhadap seluruh perangkat penyimpanan agar tak tersesat di antara partisi yang sudah ada.

## `lsblk -f`

Perintah ini berarti *list block devices*—menampilkan semua perangkat penyimpanan beserta sistem berkasnya, label, UUID, dan lokasi mount. Opsi `-f` memperluas tampilan agar menampilkan *filesystem* dan *UUID*.

* Perintah `lsblk` (list block devices): menampilkan daftar perangkat blok seperti hard disk, SSD, dan partisi.
* Opsi `-f` (`--fs`): menampilkan informasi sistem berkas (filesystem), label, dan UUID.
* Dokumentasi bantuan:

  ```bash
  lsblk --help # Bantuan umum
  man lsblk # Buku panduan
  ```

```zsh
lsblk -f
# Partisi sebelum di eksekusi

NAME                     FSTYPE FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                                 
└─sda1                   exfat  1.0   data      7F11-LLBT                                           
nvme0n1                                                                                             
├─nvme0n1p1              ntfs                   EOA2W680A2E6581A                                    
├─nvme0n1p2              crypto 1               af80df85b-8fw1-g21f-a540-45g434g43gt                
│ └─luks-fq23rr34-4k34-2342-j32i-h4h12o34h23h
│                        swap   1     manjaswap bc3ca451e-f383-4929-b611-43jl3k4j4lj               [SWAP]
├─nvme0n1p3              vfat   FAT32 manjaboot BC93-16D6                               444M    57% /boot/efi
└─nvme0n1p4              crypto 1               69a45589-c712-4532-b7d4-6pp45p2o4i5p                
  └─luks-32l13216-c712-4532-b7d4-2345kj245555
                         ext4   1.0   manjaroot d45j1l34-6b5d-4325-9e8c-513jh4lhb4ik  258,3G     6% /
```

#### 🔍 Analisis:

* `nvme0n1p1` → Partisi Root Windows (`EOA2W680A2E6581A` milik Windows).
* `nvme0n1p3` → Partisi EFI Manjaro (`/boot/efi` milik Manjaro, label `manjaboot`). Kita akan menggunakan partisi ini untuk menginstall arch
* `nvme0n1p4` → Root filesystem Manjaro (`/`).

### 🧭 1.2 Menentukan Target Instalasi

Setelah memastikan struktur disk, langkah selanjutnya adalah membuat partisi baru. Dalam contoh ini, kita akan menghasilkan `nvme0n1p5` yang akan dijadikan *root* (`/`), dan `nvme0n1p6` sebagai *swap*. Jalankan:

```bash
sudo cfdisk /dev/nvme0n1
```

`cfdisk` adalah **program partisi berbasis TUI (Text User Interface)** yang digunakan untuk membuat, menghapus, mengubah, atau mengatur partisi di dalam sebuah perangkat penyimpanan (seperti HDD, SSD, atau NVMe).

Perintah ini termasuk dalam paket **util-linux** dan bekerja sebagai antarmuka yang lebih “ramah mata” dibandingkan `fdisk`, meski sebenarnya mereka menggunakan pustaka dan fungsi yang sama di belakang layar.

`cfdisk` menampilkan tabel partisi secara interaktif, memungkinkan pengguna untuk memilih opsi dengan keyboard (↑ ↓ ← → dan Enter) tanpa mengetik perintah manual seperti di `fdisk`. Kita juga dapat menggunakan `j`, `k` jika anda terbiasa dengan navigasi vim.

---

* **Paket sumber:** `util-linux`
* **Dibangun di atas:** Sistem pemanggilan kernel Linux (`ioctl` dan `libblkid`) untuk berinteraksi langsung dengan tabel partisi perangkat.
* **Format tabel partisi yang didukung:**

  * **MBR (DOS)** — tabel partisi klasik hingga 2 TB.
  * **GPT (GUID Partition Table)** — untuk disk modern dengan ukuran >2 TB dan dukungan UEFI. Dalam kasus ini kita akan menggunakan **GPT.**

Pastikan kamu tahu betul **mana perangkat target** yang akan dipartisi, karena `cfdisk` akan menulis langsung ke tabel partisinya.
Kesalahan di sini berarti kehilangan seluruh isi disk.

---

Kita akan disambut dengan tampilan seperti tabel:

```
Device      Boot  Start     End       Sectors   Size   Type
/dev/nvme0n1p1         2048      1050623   1048576   512M   EFI System
/dev/nvme0n1p2         ...       ...       ...       ...    Linux filesystem
```

Navigasi:

* ↑ ↓ → ← untuk berpindah
* [New] untuk membuat partisi baru. Pilih **free** untuk penyimpanan yang belum dialokasikan.
* [Delete] untuk menghapus
* [Type] untuk memilih tipe partisi (mis. EFI, Linux swap, Linux filesystem, dsb.) ambil **Linux filesystem** untuk root dan **Linux swap** jika dibutuhkan. 
* [Write] untuk menyimpan hasil
* [Quit] untuk keluar

---

#### **Langkah 4: Simpan tabel partisi**

Setelah selesai, pilih opsi **[Write]**, kemudian ketik `yes` saat diminta konfirmasi.
Ini akan memperbarui tabel partisi di disk.
Setelah keluar, sebaiknya jalankan:

```bash
sudo partprobe /dev/nvme0n1
```
Ini dilakukan agar kernel memuat ulang tabel partisi yang baru meskipun umumnya menggunakan cfdisk sudah cukup. Terkadang ketika `lsblk -f` tidak menampilkan hasil dari pembuatan partisi baru, maka perintah seperti ini yang perlu dijalankan.

### 🧱 1.4 Verifikasi Setelah Partisi

Untuk memastikan hasilnya tersimpan dengan benar, jalankan kembali `lsblk -f`

```bash
# Contoh hasil eksekusi:

NAME                     FSTYPE FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                                 
└─sda1                   exfat  1.0   data      7F11-LLBT                                           
nvme0n1                                                                                             
├─nvme0n1p1              ntfs                   EOA2W680A2E6581A                                    
├─nvme0n1p2              crypto 1               af80df85b-8fw1-g21f-a540-45g434g43gt                
│ └─luks-fq23rr34-4k34-2342-j32i-h4h12o34h23h
│                        swap   1     manjaswap bc3ca451e-f383-4929-b611-43jl3k4j4lj               [SWAP]
├─nvme0n1p3              vfat   FAT32 manjaboot BC93-16D6                               444M    57% /boot/efi
├─nvme0n1p4              crypto 1               69a45589-c712-4532-b7d4-6pp45p2o4i5p                
│ └─luks-32l13216-c712-4532-b7d4-2345kj245555
│                        ext4   1.0   manjaroot d45j1l34-6b5d-4325-9e8c-513jh4lhb4ik  258,3G     6% /
├─nvme0n1p5                                   ext4        1.0   50461cb0-d882-4c6a-ba5d-a5e8acf785ce                
└─nvme0n1p6                                   swap        1     46274aff-bc2e-45fd-9a0a-a428f3395888 
```
Pastikan bahwa `nvme0n1p5` dan `nvme0n1p6` sudah terdaftar dengan jenis yang diharapkan (ext4 dan swap). Bila masih belum diformat, kolom **FSTYPE** mungkin kosong—itu akan diurus pada tahap berikutnya.

* `nvme0n1p5` → Partisi yang disiapkan untuk Arch Linux (`archroot`).
* `nvme0n1p6` → Partisi swap untuk Arch.

---

⚙️ **Catatan Teknis:**

* **sda1** Hardisk eksternal berformat *exFAT* dengan label `data`. Biasanya digunakan sebagai media cadangan atau transfer.
* **nvme0n1** adalah disk utama NVMe. Setiap partisi (`p1`–`p6`) merepresentasikan sistem berbeda:

  * **p1 (NTFS)**: partisi Windows EFI atau sistem file Windows.
  * **p2 (crypto_LUKS)**: partisi terenkripsi LUKS yang memuat area swap milik Manjaro.
  * **p3 (vfat FAT32)**: partisi boot milik Manjaro yang terpasang di `/boot/efi`.
  * **p4 (crypto_LUKS)**: partisi root Manjaro (`/`).
  * **p5 (ext4)**: akan digunakan untuk *root Arch Linux*.
  * **p6 (swap)**: disiapkan untuk area pertukaran (*swap*) Arch Linux.

Setiap kolom memiliki arti penting:

* **NAME** → nama perangkat dan urutan partisi pada disk.
* **FSTYPE/FSVER** → jenis sistem berkas (ext4, vfat, ntfs, dll.).
* **LABEL** → nama yang diberikan pengguna atau sistem untuk menandai jenisnya.
* **UUID** → identitas unik universal; digunakan oleh fstab dan GRUB untuk mengenali partisi.
* **FSAVAIL/FSUSE%** → kapasitas tersisa dan penggunaan partisi.
* **MOUNTPOINTS** → lokasi pemasangan saat ini di sistem yang sedang berjalan.

---

## 🧩 Pembuatan Filesystem & Penjelasan Konseptual

Berikutnya jalankan perintah:

```bash
sudo mkfs.ext4 /dev/nvme0n1p5
sudo mkswap /dev/nvme0n1p6
```
```bash
# output :
mke2fs 1.47.3 (8-Jul-2025)
/dev/nvme0n1p5 contains a ext4 file system labelled 'archroot'
        created on Tue Oct  7 16:01:00 2025
Proceed anyway? (y,N) y # tekan y untuk melanjutkan!

Discarding device blocks: selesai                        
Creating filesystem with 26619801 4k blocks and 4425194 inodes
Filesystem UUID: gr24525-rfq4-fr24-ac28-063916175421
Cadangan superblok disimpan di blok: 
        22662, 98304, 444840, 229376, 669966, 223712, 331345, 3301802, 2351242, 
        4096000, 2435555, 11239424, 20480000, 23887222

Allocating group tables: selesai                        
Menulis tabel inode: selesai                        
Membuat jurnal (131072 blok): selesai
Menulis superblok dan informasi akuntasi sistem berkas: selesai

mkswap: /dev/nvme0n1p6: warning: wiping old swap signature.
Setting up swapspace version 1, size = 16 GiB (17179865088 bytes)
tidak terdapat label, UUID=11e72438-04ac-4877-9f7f-df2f8t63597f

# cek hasilnya
lsblk -f
```
Disinilah letak pemformatan yang sesungguhnya dimana hasil lognya akan terlihat sebagai berikut:
```zsh
# output :
NAME                                          FSTYPE      FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
...
├─nvme0n1p5                                   ext4        1.0             44441444-fff2-hhhh-22k2-46j916179015
└─nvme0n1p6                                   swap        1               11e72438-04ac-4877-9f7f-df2f8t63597f
```

* `mkfs.ext4` membuat filesystem ext4 pada `/dev/nvme0n1p5` dan menghasilkan UUID `44441444-fff2-hhhh-22k2-46j916179015`.
* `mkswap` menulis signature swap baru pada `/dev/nvme0n1p6` dan swap mendapatkan UUID `11e72438-04ac-4877-9f7f-df2f8t63597f`.
* `lsblk -f` sekarang menunjukkan `nvme0n1p5` bertipe `ext4` dan `nvme0n1p6` sebagai `swap`.

---

### 🧱 Penjelasan praktis dari apa yang dilakukan

#### a) `mkfs.ext4 /dev/nvme0n1p5`

* Membuat struktur filesystem ext4 pada partisi `/dev/nvme0n1p5`. Bila sebuah filesystem lama ada, prompt akan menanyakan apakah akan melanjutkan (`Proceed anyway?`) — pada log, dijawab `y` sehingga semua metadata lama dibuang dan filesystem baru dibuat.
* Output penting! `Filesystem UUID` (digunakan untuk fstab & GRUB) dan daftar backup superblock.
* Help `mkfs.ext4 --help` atau `man mke2fs` / `man mkfs.ext4`.

#### b) `mkswap /dev/nvme0n1p6`

* Menulis signature swap di partisi, menyiapkan metadata swap termasuk UUID. Peringatan `wiping old swap signature` berarti partisi sebelumnya pernah digunakan sebagai swap; ini aman karena mkswap menulis ulang header swap.
* Output penting menampilkan ukuran swap (16 GiB) dan UUID swap.
* Help `mkswap --help` atau `man mkswap`.

#### c) `lsblk -f`

* Verifikasi hasil — pastikan `FSTYPE` dan `UUID` terisi. Ini juga memastikan tidak ada kesalahan penulisan atau mount yang tak diinginkan.

---

### ⚙️ Penjelasan konseptual internal `mkfs.ext4` (intinya — supaya paham apa yang terjadi)

`mkfs.ext4` (alias `mke2fs` saat memformat ext2/3/4) bukan sekadar “membuat folder root”; ia menstrukturkan disk menjadi bagian-bagian yang dipakai kernel/OS untuk menyimpan file secara efisien. Komponen utama yang dibuat:

1. **Superblock**

   * Menyimpan metadata global filesystem (jumlah inode, jumlah block, block size, versi fitur ext4, mount count, UUID filesystem, dsb).
   * Superblock utama berada di blok pertama, tetapi cadangannya disimpan di lokasi-lokasi lain (backup superblocks) — log menampilkan list blok backup.
   * Jika superblock korup, bisa dipulihkan dari salah satu backup.

2. **Block group descriptor & group tables**

   * Disk dibagi menjadi block groups (untuk memperkecil fragmentasi dan mempercepat alokasi).
   * Setiap grup memiliki tabel yang men-track free blocks, free inodes, dan lokasi inode tables.

3. **Inode table**

   * Inode adalah struktur metadata setiap file (pemilik, mode/permission, timestamps, pointer ke block data).
   * `mke2fs` mengalokasikan dan menulis tabel inode awal sesuai jumlah inode yang dihitung (lihat log: "6553600 inodes").

4. **Journaling**

   * ext4 menggunakan jurnal untuk konsistensi metadata (mencegah corrupt saat crash).
   * Pada log terlihat pembuatan journal: "Membuat jurnal (131072 blok)". Ukuran journal dipilih berdasarkan ukuran FS / opsi default.

5. **Reserved blocks & feature flags**

   * Beberapa blok disisihkan untuk root (default 5%) agar sistem tidak langsung penuh dan admin masih bisa memperbaiki FS.
   * Fitur ext4 (extent, flex_bg, dir_index,64bit) bisa diaktifkan; `mkfs.ext4` memilih fitur yang cocok sesuai ukuran.

6. **Backup superblock**

   * Lokasi-lokasi cadangan superblock dicetak supaya tools recovery (e2fsck, dumpe2fs) dapat memperbaiki jika superblock utama rusak.

**Perintah terkait untuk inspeksi:**

* `dumpe2fs /dev/nvme0n1p5 | less` — menampilkan superblock, group descriptor, dan opsi FS.
* `tune2fs -l /dev/nvme0n1p5` — ringkasan metadata termasuk UUID, reserved blocks, error behavior.
* `file -s /dev/nvme0n1p5` — mendeteksi signature FS pada device.

---

Inti penting dalam proses *partitioning* dan *filesystem creation* pada sistem Linux. Meskipun di *cfdisk* atau *fdisk* kamu sudah menetapkan tipe partisi sebagai “Linux filesystem” dan “Linux swap”. Kamu tetap butuh menjalankan perintah seperti:

```bash
sudo mkfs.ext4 /dev/nvme0n1p5
sudo mkswap /dev/nvme0n1p6
```

1. **Penetapan tipe partisi di cfdisk/fdisk hanya memberi label tipe, bukan membuat sistem berkas.**
   Ketika kamu memilih tipe “Linux filesystem” (kode `83`) atau “Linux swap” (kode `82`) di *cfdisk*, kamu hanya menandai *flag tipe partisi* di tabel partisi. Artinya, sistem hanya tahu “ini seharusnya digunakan untuk Linux” atau “ini swap”, tapi di dalam partisi itu sendiri belum ada struktur data sistem berkas apa pun.

   Jadi partisi `/dev/nvme0n1p5` masih berupa ruang mentah (raw space) — seperti halaman kosong tanpa format teks.

2. **`mkfs.ext4` benar-benar membuat struktur filesystem.**
   Perintah `sudo mkfs.ext4 /dev/nvme0n1p5` membangun struktur direktori, tabel inode, dan metadata khas sistem berkas ext4 di dalam partisi tersebut. Tanpa langkah ini, kernel tidak akan bisa *mount* partisi itu, karena tidak ada *filesystem signature* di sana.

   Dengan analogi sederhana:

   * `cfdisk` = membuat laci di lemari dan memberi label “Dokumen” atau “Foto”.
   * `mkfs` = benar-benar melapisi dan menata isi laci agar bisa diisi berkas.

3. **`mkswap` menulis struktur swap dan *header signature*.**
   Sama halnya, `sudo mkswap /dev/nvme0n1p6` membuat struktur khusus agar kernel mengenali partisi itu sebagai area swap. Tanpa perintah ini, partisi itu tidak akan bisa diaktifkan dengan `swapon`.

4. **Urutan logis pekerjaan partisi:**

   1. Gunakan `cfdisk` atau `fdisk` untuk membuat dan menandai partisi.
   2. Jalankan `mkfs.<tipe>` untuk partisi yang akan dipakai sebagai filesystem (ext4, xfs, btrfs, dsb).
   3. Jalankan `mkswap` untuk partisi yang akan dipakai sebagai swap.
   4. Baru nanti, *mount* partisi dan *swapon* swap-nya.

5. **Kapan tidak perlu dijalankan lagi?**
   Hanya bila partisi tersebut *sudah berisi filesystem yang ingin kamu pakai dan tidak ingin diformat ulang*. Misalnya kamu ingin mempertahankan data lama di `/home`, maka kamu cukup *mount* tanpa `mkfs`. Tapi untuk instalasi baru, selalu harus dilakukan agar sistem bersih.

Singkatnya:

* `cfdisk` hanya menandai tipe partisi.
* `mkfs` dan `mkswap` membuat isi struktur sesuai fungsinya.
* Tanpa keduanya, partisi belum siap digunakan oleh sistem.

---

### 🧩 2.4 Penjelasan konseptual `mkswap`

`mkswap` membuat "header" swap pada perangkat yang menandakan bahwa ruang itu dipakai untuk swap. Komponen penting:

1. **Swap signature/header**

   * Mirip dengan superblock pada ext4, header swap berisi informasi versi dan metadata kecil untuk mengenali perangkat swap.
   * `mkswap` menulis signature baru; pesan “wiping old swap signature” muncul ketika signature lama terdeteksi.

2. **UUID swap**

   * Swap mendapatkan UUID yang bisa digunakan di `/etc/fstab` untuk mengaktifkannya otomatis setelah boot dengan `swapon -a`.

3. **Activating swap**

   * Untuk mengaktifkan: `sudo swapon /dev/nvme0n1p6` atau `swapon --uuid 11e72438-04ac-4877-9f7f-df2f8t63597f`
   * Untuk melihat status: `swapon --show` atau `cat /proc/swaps`

**Perintah inspeksi:**

* `blkid /dev/nvme0n1p6` — menampilkan UUID swap.
* `file -s /dev/nvme0n1p6` — memeriksa signature swap.
* `swapon --show=NAME,UUID,TYPE,SIZE,USED,PRIO` — ringkasan swap aktif.

---

### 🔐 2.5 Keamanan & cadangan sebelum mem-format

* Selalu pastikan device yang dipilih benar: `lsblk`, `blkid`, dan `fdisk -l` membantu konfirmasi. Salah memilih device → kehilangan data permanen.
* Cadangkan data penting dari partisi terkait sebelum `mkfs`.
* Jika `mkfs` menemukan FS lama (seperti pada log) dan menanyakan konfirmasi, baca baik-baik. Pilih `y` hanya bila yakin.

---

### 🛠 2.6 Langkah praktis selanjutnya

Sekarang `nvme0n1p5` sudah ext4 dan `nvme0n1p6` sudah swap. Lakukan langkah-langkah berikut untuk melanjutkan instalasi:

1. **Mount root target**

```bash
sudo mkdir -p /mnt
sudo mount /dev/nvme0n1p5 /mnt
```

Verifikasi:

```bash
df -h /mnt
lsblk -f | grep nvme0n1p5
# output:
Sistem Berkas  Besar   Isi  Sisa Isi% Dipasang di
/dev/nvme0n1p5   98G  2,1M   93G   1% /mnt/archlinux
```

2. **Buat direktori boot & mount ESP**
   (dalam hal ini ESP Manjaro berada di `/dev/nvme0n1p3`)

```bash
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/nvme0n1p3 /mnt/boot/efi
df -h /mnt/boot/efi
```

---

### 1. **Apa yang kamu lakukan dengan perintah ini**

```
sudo mount /dev/nvme0n1p3 /mnt/boot/efi
```

Artinya: kita **memasang (mount)** partisi EFI System Partition (ESP) ke direktori `/mnt/boot/efi` dari sistem Arch yang sedang kamu instal.

Jadi nanti, ketika kamu menjalankan `arch-chroot` dan menginstal *bootloader* (misalnya GRUB atau systemd-boot), bootloader Arch akan menulis file `.efi` di partisi yang sama tempat Windows dan Manjaro juga menaruh file boot mereka.

Contohnya:

```
/mnt/boot/efi/EFI/Microsoft/Boot/bootmgfw.efi   ← milik Windows  
/mnt/boot/efi/EFI/Manjaro/grubx64.efi           ← milik Manjaro  
/mnt/boot/efi/EFI/Arch/grubx64.efi              ← nanti milik Arch Linux  
```

---

### 2. **Hasil dari perintah `df -h /mnt/boot/efi`**

Keluaran biasanya:

```
Sistem Berkas  Besar   Isi  Sisa Isi% Dipasang di
/dev/nvme0n1p3 1022M  596M  427M  59% /mnt/boot/efi
```

Artinya:

* Partisi EFI (`nvme0n1p3`) berukuran sekitar **1 GiB (1022 MB)**.
* Sudah terpakai 596 MB (oleh Windows dan Manjaro).
* Masih tersisa 427 MB ruang kosong — sangat cukup untuk Arch Linux (bootloader EFI biasanya hanya butuh beberapa megabyte saja).

Kita *telah melakukan titik memasang pada sebuah partisi*, tidak memodifikasi isinya. Tidak ada risiko kehilangan data atau gangguan pada Windows/Manjaro, selama kamu nanti **tidak memformat partisi ini**.

Yang perlu diingat:

* Jangan pernah jalankan `mkfs.vfat /dev/nvme0n1p3`, karena itu akan *menghapus seluruh isi EFI*, termasuk file boot Windows dan Manjaro.
* Cukup pasang (mount) dan biarkan bootloader Arch menulis foldernya sendiri di bawah `/EFI/Arch/`.

---

### 4. **Mengapa penting dilakukan**

Bootloader (baik GRUB maupun systemd-boot) butuh akses ke partisi EFI agar bisa menulis file `.efi` yang digunakan firmware UEFI saat menyalakan komputer.
Kalau partisi EFI tidak dipasang, instalasi Arch tidak akan bisa membuat *entry boot* untuk dirinya sendiri, sehingga sistem tidak bisa boot.

---

Verifikasi `lsblk -f` — harus menunjukkan `/dev/nvme0n1p3` mounted at `/mnt/boot/efi`.

3. **Aktifkan swap Arch**

```bash
sudo swapon /dev/nvme0n1p6
swapon --show
```

4. **Periksa ruang kosong pada root target**

```bash
df -h /mnt/
```

Pastikan cukup ruang sebelum `pacstrap`. Tetapi dalam kasus ini semuanya sudah aman karena kita menyediakan 100GB pada saat pembuatan partisi melalui cfdisk. Hal yang perlu diperhatikan hanyalah bahwa pada bagian ini kita perlu menetapkan titik instlasinya sesuai dengan saat kita melakukan mount sebelumnya, pastikan bahwa instalasi tepat pada titik partisi target.

5. **Bootstrap Arch (pacstrap)** — HANYA jika semua mount sudah benar:

```bash
sudo pacstrap /mnt base linux linux-firmware networkmanager
```

* Jika sudah ada `arch-install-scripts` pada Manjaro (seharusnya terpasang), `pacstrap` akan mendownload paket Arch ke `/mnt`.
* **Catatan penting:** Jangan pernah menjalankan `pacstrap` bila `/mnt` menunjuk ke ESP; periksa `mountpoint` dengan `lsblk -f` dan `df -h /mnt` sebelum lanjut.

6. **Buat fstab otomatis**
   Setelah `pacstrap` selesai:

```bash
sudo genfstab -U /mnt | sudo tee /mnt/etc/fstab
# periksa hasil:
sudo cat /mnt/etc/fstab
```
---

### 📚 2.7 Perintah bantuan & sumber daya

* `mkfs.ext4`: `man mkfs.ext4` / `man mke2fs`
* `mkswap`: `man mkswap`
* `swapon`: `man swapon`
* `lsblk`: `man lsblk`
* `blkid`: `man blkid`
* `dumpe2fs`, `tune2fs`: `man dumpe2fs`, `man tune2fs`
* ArchWiki: *Filesystem* dan *Installation guide* (rekomendasi baca untuk detail opsi `mkfs.ext4` dan `mkinitcpio`).

---

### ⚠️ 2.8 Catatan lanjutan & troubleshooting cepat

* **Jika perlu restore superblock**: gunakan `dumpe2fs` untuk menemukan backup superblock lalu `e2fsck -b <backup_block> /dev/nvme0n1p5` untuk mencoba perbaikan.
* **Jika `pacstrap` masih gagal karena ruang**: periksa mountpoint pastikan `/mnt` adalah `/dev/nvme0n1p5` bukan ESP. `df -h /mnt` harus menunjukkan ukuran sesuai partisi ext4 yang baru dibuat.
* **Jika swap tidak aktif** setelah `swapon`: cek `dmesg` untuk pesan kernel, pastikan tidak terjadi I/O error pada device.

---

## Ringkasan perintah penting dan beberpa opsional rekomended


