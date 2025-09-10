### **[Fase 2: Instalasi Sistem Inti dan Konfigurasi Dasar][0]**

### **Modul 4: Instalasi Paket Dasar & Konfigurasi Fstab**

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Mengisi "Ruangan" Kosong
  * Konsep Kunci & Filosofi Mendalam: Peran *Pacstrap* dan `fstab`
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Perintah `pacstrap`**
      * **Perintah `genfstab`**
  * Terminologi Esensial: `Pacstrap`, `fstab`, `base`, `base-devel`.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik


</details>

-----

### **Deskripsi Konkret: Mengisi "Ruangan" Kosong**

Anda telah berhasil menyiapkan semua "ruangan" kosong (partisi) dan "membukanya" (`mount`). Sekarang waktunya untuk mengisi ruangan utama (partisi *root* di `/mnt`) dengan "perabotan" esensial yang membuat sebuah sistem operasi berfungsi. Perintah **`pacstrap`** adalah alat yang akan melakukan tugas ini.

Setelah paket-paket dasar terinstal, Anda perlu membuat *file* konfigurasi yang memberitahu sistem operasi di mana letak setiap partisi saat *boot*. *File* ini disebut `fstab`.

### **Konsep Kunci & Filosofi Mendalam: Peran *Pacstrap* dan `fstab`**

  * ***Pacstrap*:** Anggaplah `pacstrap` sebagai "kontraktor utama" Anda. Tugasnya adalah mengambil semua paket dasar (`base` dan `linux`) dari repositori dan menginstalnya ke partisi yang Anda *mount*. Ia akan memasang *kernel*, *shell*, *core utilities*, dan semua yang diperlukan agar sistem dapat berjalan. Filosofinya adalah menyederhanakan proses instalasi dengan mengotomatisasi pengunduhan dan pemasangan paket inti.
  * **`fstab`:** Adalah "daftar inventaris" sistem Anda. `fstab` (singkatan dari ***filesystem table***) adalah *file* yang menyimpan daftar semua partisi yang harus di-*mount* secara otomatis saat sistem *boot*. Tanpa `fstab`, sistem Anda tidak akan tahu di mana letak partisi *root*, *swap*, atau EFI, dan tidak akan bisa memulai. Filosofinya adalah memastikan setiap partisi berada di tempat yang tepat pada waktu yang tepat.

### **Sintaks Dasar / Contoh Implementasi Inti**

Pastikan Anda berada di *shell* Arch Live, dengan partisi *root* di-*mount* di `/mnt`.

#### **Perintah 1: `pacstrap`**

```bash
# Perintah ini menginstal paket dasar ke partisi /mnt.
# base: Paket dasar yang diperlukan untuk menjalankan sistem minimal.
# linux: Kernel Linux.
# linux-firmware: Firmware untuk hardware.
pacstrap /mnt base linux linux-firmware
```

  * **Penjelasan Mendalam:** Perintah ini menggunakan `pacman` (manajer paket Arch Linux) untuk menginstal paket. `pacstrap` menambahkan `--root /mnt` secara implisit, yang berarti semua paket akan diinstal ke direktori `/mnt` (yaitu, partisi *root* Anda).

  * **Output yang Diharapkan:** Anda akan melihat *output* yang panjang menunjukkan proses pengunduhan dan instalasi paket. Ini mungkin memakan waktu beberapa menit, tergantung pada kecepatan internet Anda. Setelah selesai, Anda akan kembali ke *prompt* *shell*.

#### **Perintah 2: `genfstab`**

```bash
# Perintah ini secara otomatis menghasilkan file fstab berdasarkan partisi yang di-mount.
# -U: Menggunakan UUID (Unique Universal Identifier) untuk identifikasi partisi.
# >>: Mengarahkan output ke file /mnt/etc/fstab.
genfstab -U /mnt >> /mnt/etc/fstab
```

  * **Penjelasan Mendalam:** `genfstab` membaca semua partisi yang saat ini di-*mount* di bawah `/mnt` dan membuat entri yang sesuai untuk `fstab`. Opsi `-U` adalah **praktik terbaik** karena menggunakan UUID, yang merupakan "sidik jari" unik untuk setiap partisi. Menggunakan UUID lebih aman daripada menggunakan nama perangkat (`/dev/sda3`) karena nama perangkat bisa berubah.

  * **Verifikasi Keberhasilan:** Setelah menjalankan perintah `genfstab`, periksa konten *file* `fstab` untuk memastikan semuanya telah dibuat dengan benar.

<!-- end list -->

```bash
cat /mnt/etc/fstab
```

  * **Output yang Diharapkan:** Anda akan melihat *output* yang mirip dengan ini. Pastikan ada entri untuk partisi *root* (`/`), EFI (`/boot/efi`), dan *swap* (`swap`).

    ```
    # /dev/sda3 UUID=12345678-abcd-efgh-1234-567890abcdef
    # /       ext4    rw,relatime     0 1
    # /dev/sda1 UUID=98765432-abcd-efgh-9876-543210fedcba
    # /boot/efi       vfat    rw,relatime     0 2
    # /dev/sda2 UUID=11111111-aaaa-bbbb-cccc-dddddddddddd
    # swap    swap    defaults        0 0
    ```

### **Terminologi Esensial & Penjelasan Detil**

  * ***Pacstrap*:** Skrip yang menyederhanakan instalasi paket dasar dari repositori resmi Arch Linux.
  * ***Fstab*:** *Filesystem table*, *file* konfigurasi yang mendefinisikan bagaimana dan di mana *filesystem* harus di-*mount* saat *boot*.
  * **`base`:** Kumpulan paket minimal yang diperlukan untuk sistem Linux yang berfungsi.
  * **`base-devel`:** Kumpulan alat pengembangan yang berguna, seperti `make`, `gcc`, dan *compiler* lainnya.

### **Hubungan dengan Modul Lain**

  * **Ke Modul 5 (Konfigurasi Sistem):** Setelah paket dasar terinstal, Anda akan menggunakan `arch-chroot` untuk masuk ke sistem yang baru diinstal dan melakukan konfigurasi lebih lanjut.
  * **Ke Modul 6 (*Bootloader*):** Instalasi *bootloader* akan dilakukan di dalam lingkungan *chroot* yang baru Anda siapkan.

### **Tips & Praktik Terbaik**

  * **Koneksi Stabil:** Pastikan koneksi internet Anda stabil. Proses `pacstrap` akan mengunduh paket berukuran beberapa ratus megabyte.
  * **Gunakan `-U`:** Selalu gunakan opsi `-U` saat menjalankan `genfstab`. Ini akan mencegah masalah *boot* jika nama perangkat Anda berubah (misalnya, jika Anda mencolokkan *hard drive* eksternal).

-----

Anda telah berhasil menginstal paket-paket dasar Arch Linux ke *hard disk* Anda. Namun, Anda masih berada di dalam lingkungan **Arch Live**. Langkah selanjutnya adalah memasuki sistem yang baru Anda instal untuk melanjutkan konfigurasi. Di modul ini, kita akan menggunakan perintah **`arch-chroot`**, sebuah utilitas yang sangat penting bagi seorang ahli.

-----

### **Modul 5: Konfigurasi Sistem: Waktu, Bahasa, dan Pengguna**

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Memasuki "Rumah Baru" Anda
  * Konsep Kunci & Filosofi Mendalam: Peran *Chroot*
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Perintah `arch-chroot`**
      * **Konfigurasi Waktu**
      * **Konfigurasi Lokalisasi (Bahasa)**
      * **Konfigurasi *Host* dan Jaringan**
      * **Membuat Kata Sandi *Root***
  * Terminologi Esensial: `chroot`, *timezone*, *locale*, *hostname*, *root password*.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

-----

### **Deskripsi Konkret: Memasuki "Rumah Baru" Anda**

Bayangkan Anda telah membangun sebuah rumah baru, tetapi Anda masih berdiri di luar. Perintah **`arch-chroot`** adalah kunci untuk masuk ke dalam rumah itu. Utilitas ini akan mengubah *prompt* *shell* Anda dan secara efektif membuat Anda "masuk" ke dalam sistem yang baru diinstal di `/mnt`. Setelah di dalam, semua perintah yang Anda jalankan akan beroperasi pada sistem yang baru, bukan pada lingkungan Arch Live.

### **Konsep Kunci & Filosofi Mendalam: Peran *Chroot***

`chroot` adalah singkatan dari **"change root"**. Filosofinya adalah menyediakan lingkungan terisolasi di mana Anda dapat menjalankan perintah seolah-olah Anda berada di dalam sistem *filesystem* yang berbeda. Hal ini sangat berguna untuk pemulihan (seperti yang akan kita lihat di Modul 9) dan, dalam kasus ini, untuk menyelesaikan instalasi.

### **Sintaks Dasar / Contoh Implementasi Inti**

Pastikan Anda telah berhasil menyelesaikan Modul 4 dan partisi Anda masih di-*mount* dengan benar di `/mnt`.

#### **Perintah 1: `arch-chroot`**

```bash
# Perintah ini akan mengubah root directory dari shell Anda ke /mnt.
arch-chroot /mnt
```

  * **Penjelasan Mendalam:** Setelah perintah ini, *prompt* *shell* Anda akan berubah, menunjukkan bahwa Anda sekarang berada di lingkungan *chroot*. Misalnya, `[root@archiso /]#` akan berubah menjadi `[root@archiso /mnt]#` atau `[root@archiso /]#` (tergantung versi ISO-nya). Setiap perintah yang Anda jalankan setelah ini, seperti `pacman -S`, akan diinstal ke sistem di *hard disk* Anda, bukan ke RAM Arch Live.

  * **Verifikasi Keberhasilan:** *Output* dari `arch-chroot` tidak ada. Anda harus memverifikasinya secara visual dengan melihat perubahan pada *prompt* *shell* Anda. Jika *prompt* berubah, Anda berhasil masuk.

#### **Perintah 2: Konfigurasi Waktu**

Ini adalah langkah penting untuk sinkronisasi waktu yang benar.

```bash
# Mengatur zona waktu, ganti 'Asia/Jakarta' jika Anda berada di zona waktu lain.
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Menghasilkan /etc/adjtime untuk sinkronisasi hardware clock.
hwclock --systohc
```

  * **Penjelasan Mendalam:** Perintah pertama membuat sebuah ***symbolic link*** (tautan simbolis) dari *file* zona waktu ke `/etc/localtime`. Ini memberitahu sistem Anda di zona waktu mana ia berada. Perintah `hwclock` mengatur jam perangkat keras (yang ada di *motherboard*) agar sama dengan waktu sistem.

  * **Verifikasi Keberhasilan:** Jalankan `timedatectl`. Anda akan melihat zona waktu yang telah Anda atur. `System clock synchronized: yes` dan `RTC in local TZ: yes` akan menunjukkan sinkronisasi yang benar.

#### **Perintah 3: Konfigurasi Lokalisasi (Bahasa)**

Langkah ini mengatur bahasa dan format regional untuk sistem Anda.

```bash
# Buka file konfigurasi locale.gen
vim /etc/locale.gen

# Kemudian, hilangkan tanda '#' di depan baris yang diinginkan.
# Contoh:
#en_US.UTF-8 UTF-8
#id_ID.UTF-8 UTF-8
# Simpan dan tutup (tekan Esc, ketik :wq, Enter).
# Setelah itu, jalankan perintah ini untuk membuat locale.
locale-gen

# Buat file locale.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

  * **Penjelasan Mendalam:** `locale.gen` adalah daftar semua bahasa yang tersedia. Dengan menghilangkan tanda `#`, Anda "mengaktifkan" bahasa-bahasa tersebut. `locale-gen` kemudian akan membuat *file* yang diperlukan. `locale.conf` adalah *file* yang memberitahu sistem bahasa apa yang akan digunakan. Menggunakan `en_US.UTF-8` adalah praktik terbaik karena sebagian besar aplikasi dan dokumentasi teknis dibangun di atas *locale* ini.

  * **Verifikasi Keberhasilan:** Jalankan `locale`. *Output* harus menunjukkan `LANG=en_US.UTF-8`.

#### **Perintah 4: Konfigurasi *Hostname***

Ini adalah nama yang akan digunakan komputer Anda di jaringan.

```bash
# Ganti "myarch" dengan hostname yang Anda inginkan.
echo "myarch" > /etc/hostname
```

  * **Penjelasan Mendalam:** `hostname` adalah identitas komputer. Contohnya, jika Anda memiliki beberapa komputer di jaringan rumah, ini akan mempermudah identifikasi satu sama lain.

#### **Perintah 5: Membuat Kata Sandi *Root***

Ini adalah langkah keamanan yang sangat penting. Anda harus membuat kata sandi untuk pengguna *root*.

```bash
# Perintah untuk membuat atau mengubah kata sandi root.
passwd
```

  * **Penjelasan Mendalam:** Anda akan diminta untuk memasukkan kata sandi dua kali. Tidak ada karakter yang akan muncul di layar saat Anda mengetik, jadi berhati-hatilah.

  * **Verifikasi Keberhasilan:** *Output* akan mengatakan `password updated successfully`.

### **Terminologi Esensial & Penjelasan Detil**

  * `chroot`: "change root", perintah untuk mengubah *root directory* dari proses yang sedang berjalan.
  * *Timezone*: Zona waktu.
  * *Locale*: Kumpulan parameter yang mendefinisikan bahasa, negara, dan *encoding* karakter.
  * *Hostname*: Nama unik komputer di jaringan.
  * *Root password*: Kata sandi untuk akun *root*, yang memiliki hak akses tertinggi di sistem.

### **Hubungan dengan Modul Lain**

  * **Ke Modul 6 (Instalasi *Bootloader*):** Semua konfigurasi yang Anda lakukan di modul ini adalah prasyarat untuk membuat sistem yang berfungsi. Modul berikutnya, instalasi *bootloader*, adalah langkah terakhir sebelum sistem Anda dapat *boot* secara mandiri.
  * **Ke Modul 9 (*Troubleshooting*):** Perintah `arch-chroot` yang Anda gunakan di sini juga merupakan alat utama yang akan Anda gunakan untuk memperbaiki sistem Anda jika terjadi kegagalan *boot*.

### **Tips & Praktik Terbaik**

  * **Gunakan `vim`:** Jika Anda belum terbiasa, luangkan waktu untuk mempelajari dasar-dasar `vim` (atau `nano` jika lebih mudah). Ini akan menjadi alat editor *file* utama Anda di lingkungan CLI.
  * **Kata Sandi Kuat:** Selalu gunakan kata sandi yang kuat untuk akun *root*.

Anda telah berhasil mengkonfigurasi sistem dasar di lingkungan `chroot`. Sekarang, kita berada pada langkah terakhir dan paling penting untuk membuat sistem Anda dapat di-*boot* secara mandiri. Kita akan menginstal dan mengkonfigurasi *bootloader*.

-----

### **Modul 6: Instalasi dan Konfigurasi *Bootloader* (GRUB & *Systemd-boot*)**

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Menempatkan "Kunci" untuk Memulai Sistem
  * Konsep Kunci & Filosofi Mendalam: Peran *Bootloader*
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Metode 1: Instalasi GRUB**
          * Perintah `pacman -S grub efibootmgr`
          * Perintah `grub-install`
          * Perintah `grub-mkconfig`
      * **Metode 2: Instalasi *Systemd-boot***
          * Perintah `bootctl install`
          * Konfigurasi `loader.conf` dan `arch.conf`
  * Terminologi Esensial: *Bootloader*, GRUB, `systemd-boot`, `efibootmgr`.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

-----

### **Deskripsi Konkret: Menempatkan "Kunci" untuk Memulai Sistem**

Anda sudah memiliki rumah yang lengkap (sistem operasi) di *hard disk*, tetapi Anda belum memiliki "kunci" untuk membukanya. Tugas *bootloader* adalah menjadi kunci tersebut. Perintah yang akan kita jalankan akan menempatkan *executable* *bootloader* ke dalam ***EFI System Partition* (ESP)** dan mendaftarkannya ke *firmware* UEFI, sehingga UEFI tahu di mana harus memulai.

Kita akan membahas dua pilihan *bootloader* yang paling umum: GRUB dan `systemd-boot`. Anda hanya perlu memilih salah satu, tetapi memahami keduanya akan memberi Anda keunggulan.

### **Konsep Kunci & Filosofi Mendalam: Peran *Bootloader***

  * **GRUB (Grand Unified Bootloader):** Filosofinya adalah **fleksibilitas**. GRUB dirancang untuk menjadi universal, mampu memuat berbagai sistem operasi, baik Linux, Windows, maupun macOS. Ini adalah pilihan terbaik jika Anda berencana untuk melakukan *dual-boot* atau menginstal sistem operasi yang lebih dari satu.
  * ***Systemd-boot*:** Filosofinya adalah **kesederhanaan**. Ia adalah *bootloader* yang ringan dan terintegrasi dengan `systemd`. Ia hanya bekerja pada sistem UEFI, dan konfigurasinya jauh lebih sederhana. Ini adalah pilihan yang ideal jika Anda hanya akan menjalankan Arch Linux di komputer Anda.

### **Sintaks Dasar / Contoh Implementasi Inti**

**Penting:** Pastikan Anda masih berada di dalam lingkungan `chroot` (`arch-chroot /mnt`).

#### **Metode 1: Instalasi GRUB**

**Langkah 1: Instal Paket yang Diperlukan**

```bash
# Perintah untuk menginstal GRUB dan efibootmgr.
# efibootmgr adalah utilitas untuk mengelola entri boot UEFI.
pacman -S grub efibootmgr
```

  * **Penjelasan Mendalam:** `pacman` akan mengunduh dan menginstal paket `grub` dan `efibootmgr` ke dalam sistem baru Anda.

  * **Verifikasi Keberhasilan:** *Output* akan menunjukkan proses instalasi yang sukses.

**Langkah 2: Instal GRUB ke ESP**

```bash
# Perintah untuk menginstal GRUB ke EFI System Partition.
# --target=x86_64-efi: Menentukan arsitektur boot UEFI.
# --efi-directory=/boot/efi: Lokasi mount partisi ESP.
# --bootloader-id=grub: Nama yang akan muncul di menu boot UEFI.
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

  * **Penjelasan Mendalam:** Perintah ini adalah inti dari instalasi GRUB. Ia menyalin *file-file* yang diperlukan ke partisi ESP dan menggunakan `efibootmgr` untuk membuat entri *boot* di *firmware* UEFI Anda.

  * **Verifikasi Keberhasilan:** Jalankan `efibootmgr`. Anda akan melihat entri baru dengan nama **`GRUB`** di dalam *output*-nya, menunjukkan bahwa GRUB telah berhasil didaftarkan ke *firmware*.

**Langkah 3: Buat *File* Konfigurasi GRUB**

```bash
# Perintah untuk membuat file grub.cfg, yang digunakan GRUB untuk memuat sistem operasi.
# -o: Menentukan file output.
grub-mkconfig -o /boot/grub/grub.cfg
```

  * **Penjelasan Mendalam:** Skrip `grub-mkconfig` secara otomatis memindai sistem Anda untuk *kernel* Linux dan *firmware* lainnya, lalu membuat `grub.cfg` yang berisi semua opsi *boot* yang diperlukan.

  * **Verifikasi Keberhasilan:** *Output* akan menunjukkan proses pemindaian dan pembuatan *file*. Anda bisa melihat isinya dengan `cat /boot/grub/grub.cfg`.

-----

#### **Metode 2: Instalasi *Systemd-boot***

**Langkah 1: Instal *Systemd-boot***

```bash
# Perintah ini menginstal file-file yang diperlukan ke EFI System Partition.
bootctl install
```

  * **Penjelasan Mendalam:** `bootctl` adalah utilitas untuk menginstal dan mengelola *bootloader* `systemd-boot`. Perintah ini menyalin *file-file* yang diperlukan ke partisi ESP.

  * **Verifikasi Keberhasilan:** *Output* akan menunjukkan `Installed systemd-boot to /boot/efi.` dan `Created EFI boot entry for systemd-boot`. Anda juga bisa memeriksa `efibootmgr` untuk entri baru.

**Langkah 2: Konfigurasi Entri *Boot***

`Systemd-boot` menggunakan *file* konfigurasi yang lebih sederhana yang terletak di partisi ESP.

```bash
# Buat dan edit file loader.conf.
vim /boot/efi/loader/loader.conf
```

Tambahkan baris berikut di dalamnya:

```ini
default  arch.conf
timeout  4
editor   0
```

  * **Penjelasan Mendalam:** `default arch.conf` memberitahu `systemd-boot` untuk memuat entri `arch.conf` secara *default*. `timeout` adalah waktu yang diberikan kepada pengguna untuk memilih opsi.

Selanjutnya, buat *file* untuk entri *boot* Arch Linux:

```bash
# Buat dan edit file arch.conf.
vim /boot/efi/loader/entries/arch.conf
```

Tambahkan baris berikut (sesuaikan UUID):

```ini
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=YOUR_ROOT_UUID rw
```

  * **Penjelasan Mendalam:** *File* ini memberitahu `systemd-boot` di mana *kernel* (`linux`), *initramfs* (`initrd`), dan partisi *root* (`options root=...`) berada. Gunakan `lsblk -f` untuk menemukan UUID dari partisi *root* Anda dan ganti **`YOUR_ROOT_UUID`**.

  * **Verifikasi Keberhasilan:** Setelah menyimpan *file* konfigurasi, jalankan `bootctl`. *Output* akan menunjukkan status dan *bootloader* yang aktif.

-----

### **Terminologi Esensial & Penjelasan Detil**

  * `grub-install`: Perintah untuk menempatkan *bootloader* GRUB ke perangkat yang ditentukan.
  * `grub-mkconfig`: Perintah untuk menghasilkan *file* konfigurasi GRUB.
  * `bootctl`: Utilitas untuk mengelola *bootloader* `systemd-boot`.
  * `efibootmgr`: Utilitas yang berinteraksi langsung dengan *firmware* UEFI untuk mengelola entri *boot*.

### **Verifikasi & *Output***

Setelah menyelesaikan instalasi salah satu *bootloader* di atas, langkah terakhir yang harus Anda lakukan di lingkungan *chroot* adalah keluar.

```bash
# Keluar dari lingkungan chroot
exit
```

Anda akan kembali ke *prompt* *shell* Arch Live. Ini adalah konfirmasi visual bahwa Anda telah keluar dari sistem yang baru diinstal.

### **Hubungan dengan Modul Lain**

  * **Ke Tahap Akhir:** Setelah langkah ini, instalasi utama telah selesai. Anda sekarang dapat *reboot* sistem dan memuat sistem Arch Linux yang baru dari *hard disk* Anda sendiri.

### **Tips & Praktik Terbaik**

  * **Jangan *Reboot* Dulu:** Pastikan untuk menjalankan `exit` untuk keluar dari *chroot* sebelum melakukan *reboot*. Ini penting agar semua perubahan disimpan dengan benar.
  * **Periksa Kembali UUID:** Jika Anda memilih *systemd-boot*, pastikan UUID yang Anda masukkan di `arch.conf` adalah benar.

Anda telah menyelesaikan instalasi utama Arch Linux, termasuk *bootloader*. Langkah terakhir dalam proses instalasi manual adalah membersihkan lingkungan *live* dan *reboot* ke sistem yang baru. Ini adalah momen puncak dari seluruh upaya Anda.

-----

### **Modul 7: Keluar dari *Chroot* dan *Reboot***

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Langkah-langkah Akhir
  * Konsep Kunci & Filosofi Mendalam: Keluar dari Lingkungan Sementara
  * Sintaks Dasar / Contoh Implementasi Inti
      * Perintah `exit`
      * Perintah `reboot`
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

-----

### **Deskripsi Konkret: Langkah-langkah Akhir**

Setelah mengkonfigurasi *bootloader* dan memastikan semuanya telah diatur, Anda harus keluar dari lingkungan `chroot` dan *unmount* partisi yang telah Anda *mount* di Modul 3. Ini adalah langkah penting untuk mencegah potensi masalah saat sistem *reboot* dan mencoba memuat dari *hard disk*.

### **Konsep Kunci & Filosofi Mendalam: Keluar dari Lingkungan Sementara**

Filosofi di balik langkah ini adalah untuk **melepaskan pegangan** sistem *live* dari sistem yang baru Anda instal. Bayangkan Anda telah selesai membangun dan merenovasi sebuah rumah, dan sekarang saatnya untuk melepaskan semua *scaffolding* (peralatan sementara) sebelum rumah tersebut bisa digunakan. Jika Anda tidak melakukan *unmount* dengan benar, sistem dapat mengalami kesalahan saat *reboot* karena perangkat masih "digunakan" oleh lingkungan *live*.

### **Sintaks Dasar / Contoh Implementasi Inti**

Pastikan Anda berada di dalam lingkungan `chroot` sebelum memulai langkah ini.

#### **Perintah 1: Keluar dari `chroot`**

```bash
# Perintah ini akan membawa Anda kembali ke lingkungan Arch Live.
exit
```

  * **Penjelasan Mendalam:** Perintah `exit` secara sederhana akan mengakhiri *shell* `chroot` yang sedang berjalan. Anda akan melihat *prompt* *shell* Anda kembali seperti semula. Ini adalah indikasi bahwa Anda telah berhasil keluar dari sistem yang baru diinstal.

  * **Verifikasi Keberhasilan:** *Prompt* *shell* Anda akan kembali ke `[root@archiso /]#` atau yang serupa.

#### **Perintah 2: *Unmount* Partisi**

Sebelum *reboot*, Anda harus *unmount* semua partisi yang Anda *mount* sebelumnya.

```bash
# Perintah untuk unmount partisi yang telah di mount.
umount -R /mnt
```

  * **Penjelasan Mendalam:** Perintah `umount` digunakan untuk melepaskan *filesystem* dari hierarki *mount*. Opsi `-R` (rekursif) akan meng-*unmount* semua partisi yang di-*mount* di bawah `/mnt`, seperti `/mnt/boot/efi`, secara otomatis. Ini adalah cara yang efisien untuk memastikan semuanya dilepaskan dengan benar.

  * **Verifikasi Keberhasilan:** Jalankan `lsblk`. \_Output\_nya tidak boleh lagi menunjukkan *mountpoint* `/mnt` atau `/mnt/boot/efi`. Jika *mountpoint* sudah kosong, berarti Anda telah berhasil. Jika ada kesalahan, Anda mungkin perlu menjalankan `umount` secara terpisah untuk setiap partisi, misalnya: `umount /mnt/boot/efi` lalu `umount /mnt`.

#### **Perintah 3: *Reboot***

Sekarang adalah saat yang ditunggu-tunggu. Keluarkan media instalasi (USB atau CD) dari komputer Anda, dan jalankan perintah *reboot*.

```bash
# Perintah untuk me-reboot sistem.
reboot
```

  * **Penjelasan Mendalam:** Perintah ini akan mematikan sistem dan menyalakannya kembali. Karena Anda sudah mengeluarkan media instalasi, komputer akan mencoba *boot* dari *hard disk* Anda, yang sekarang berisi instalasi Arch Linux yang berfungsi.

### **Verifikasi & *Output***

Jika semuanya berjalan lancar, Anda akan melihat menu *bootloader* (GRUB atau `systemd-boot`) yang telah Anda konfigurasikan. Setelah memilih opsi *boot* Arch Linux, Anda akan melihat serangkaian pesan *boot* *kernel* dan akhirnya sampai pada *prompt* *login* CLI.

### **Hubungan dengan Modul Lain**

  * **Puncak Kurikulum:** Modul ini adalah klimaks dari semua yang telah Anda pelajari. `reboot` adalah ujian akhir untuk memvalidasi bahwa setiap langkah, dari partisi hingga *bootloader*, telah dilakukan dengan benar.
  * **Ke Tahap Selanjutnya:** Setelah Anda berhasil *login*, Anda akan berada di sistem Arch Linux yang berfungsi penuh. Langkah-langkah selanjutnya adalah menginstal lingkungan desktop (`Sway`), konfigurasi jaringan, dan lain-lain.

### **Tips & Praktik Terbaik**

  * **Jangan Lupa Mengeluarkan Media:** Pastikan Anda mengeluarkan USB atau CD instalasi sebelum menjalankan perintah `reboot`. Jika tidak, komputer mungkin akan *boot* kembali ke lingkungan *live*.
  * **Perhatikan Pesan *Error*:** Jika sistem gagal *boot*, jangan panik. Perhatikan pesan kesalahan yang muncul di layar, karena itu akan menjadi petunjuk pertama Anda untuk *troubleshooting* (seperti yang akan kita bahas dalam modul *troubleshooting* yang lebih dalam).

Anda telah menyelesaikan seluruh proses instalasi manual Arch Linux. Selamat\! Anda telah berhasil menaklukkan salah satu tantangan paling fundamental di dunia Linux. Langkah Anda selanjutnya adalah menginstal dan mengkonfigurasi lingkungan yang akan Anda gunakan sehari-hari, yaitu **Lingkungan Desktop** Anda. Berdasarkan preferensi Anda yang mencintai CLI, Sway Window Manager, dan minimalisme, kita akan fokus pada pembangunan lingkungan tersebut dari awal.

-----

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
