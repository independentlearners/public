## **[Fase 3: Mahir (Advanced)][0]**

Sekarang kita akan mendalami **Fase 3: Mahir (Advanced)**, yang akan berfokus pada **_Booting_ Sistem Terenkripsi dengan LUKS dan LVM**.

---

<details>
  <summary>📃 Daftar Isi</summary>

#### **Struktur Pembelajaran Internal**

- **Deskripsi Konkret & Peran dalam Kurikulum**
- **Konsep Kunci & Filosofi Mendalam**
  - Pentingnya Enkripsi _Full-Disk_
  - Peran LUKS dan LVM
  - Peran Penting _Initramfs_
- **Terminologi Esensial & Penjelasan Detil**
  - **LUKS (Linux Unified Key Setup)**
  - **LVM (Logical Volume Manager)**
  - **_Initramfs_ (_initial RAM filesystem_)**
  - **_Kernel Parameter_**
  - **_Hooks_**
- **Alur Kerja & Visualisasi**
  - **Diagram Alur _Boot_ Sistem Terenkripsi**
- **Sintaks Dasar / Contoh Implementasi Inti**
  - **Langkah 1: Membuat Partisi LUKS**
  - **Langkah 2: Mengonfigurasi _Initramfs_**
  - **Langkah 3: Menambahkan Parameter _Kernel_**
- **Hubungan dengan Modul Lain**
- **Tips dan Praktik Terbaik**
- **Potensi Kesalahan Umum & Solusi**
- **Sumber Referensi Lengkap**

</details>

---

### **Modul 3: _Booting_ Sistem Terenkripsi dengan LUKS dan LVM**

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah lompatan besar menuju tingkat keahlian. Anda tidak hanya akan memuat _kernel_ seperti biasa, tetapi juga akan memuat sebuah sistem operasi yang tersembunyi di balik lapisan enkripsi. Perannya dalam kurikulum adalah untuk menggabungkan pemahaman Anda dari modul sebelumnya (_firmware_, _bootloader_) dengan tantangan keamanan modern. Anda akan belajar bagaimana sistem _boot_ dapat bekerja dengan **enkripsi _full-disk_** untuk melindungi data sensitif.

### **Konsep Kunci & Filosofi Mendalam**

Ketika sistem Anda tidak dienkripsi, _bootloader_ dapat langsung mengakses dan memuat _kernel_ dari partisi yang ada. Namun, ketika sistem terenkripsi, _kernel_ dan seluruh sistem _file_ tidak dapat dibaca hingga Anda memberikan kata sandi atau kunci. Lalu, bagaimana komputer bisa meminta kata sandi jika _kernel_ (yang berisi program untuk meminta kata sandi) belum dimuat?

Inilah masalah yang diselesaikan oleh tiga komponen kunci: **LUKS**, **LVM**, dan **_initramfs_**.

- **Pentingnya Enkripsi _Full-Disk_**
  - **Filosofi:** Perlindungan data Anda dari akses fisik yang tidak sah. Jika laptop Anda dicuri, tanpa enkripsi, data di _hard disk_ dapat diakses dengan mudah. Dengan enkripsi, data Anda hanyalah sebuah "gumpalan" data yang tidak dapat dibaca tanpa kunci dekripsi.
- **Peran LUKS dan LVM**
  - **LUKS** adalah lapisan enkripsi yang membungkus seluruh partisi atau _hard disk_. Filosofinya adalah menyediakan _header_ standar yang menyimpan semua informasi enkripsi, sehingga Anda dapat dengan mudah menambahkan, mengubah, atau menghapus _passphrase_. Ia tidak menyimpan data Anda secara acak, melainkan dalam "wadah" yang terorganisir.
  - **LVM** berfungsi sebagai manajer volume yang fleksibel. Filosofinya adalah memisahkan antara struktur fisik (partisi) dan struktur logis (volume). Ini memungkinkan Anda untuk mengubah ukuran partisi, menambahkan _disk_ baru, atau membuat _snapshot_ sistem dengan sangat mudah, bahkan setelah enkripsi. LVM sering digunakan bersama LUKS untuk mengelola _layout_ partisi yang lebih kompleks.
- **Peran Penting _Initramfs_**
  - **Filosofi:** _Initramfs_ adalah "pintu gerbang sementara" menuju sistem terenkripsi. Sebelum _kernel_ dapat menemukan dan memuat sistem _file_ utama, ia harus memiliki akses ke alat-alat yang diperlukan untuk mendekripsi _disk_. _Initramfs_ menyediakan lingkungan minimalis di RAM yang berisi semua program dan _driver_ yang dibutuhkan untuk melakukan tugas tersebut, seperti program `cryptsetup` dan _driver_ LVM. Tanpa _initramfs_, _kernel_ akan "tersesat" dan tidak dapat menemukan sistem _file_ yang terenkripsi.

### **Terminologi Esensial & Penjelasan Detil**

- **LUKS (Linux Unified Key Setup)**

  - **Definisi:** Standar enkripsi _disk_ yang digunakan di Linux. Ini adalah implementasi dari **_dm-crypt_**, lapisan enkripsi yang ada di _kernel_.
  - **Fungsi:** Mengenkripsi seluruh partisi atau volume logis dan menyediakan _key slot_ untuk menyimpan beberapa kunci atau kata sandi.

- **LVM (Logical Volume Manager)**

  - **Definisi:** Sebuah sistem yang memungkinkan manajemen ruang _disk_ secara fleksibel, tidak terbatas pada partisi fisik.
  - **Fungsi:** Mengelompokkan partisi fisik menjadi _volume group_ dan kemudian membaginya menjadi _logical volume_ yang dapat diubah ukurannya secara dinamis.

- **_Initramfs_ (_initial RAM filesystem_)**

  - **Definisi:** Sebuah _filesystem_ terkompresi yang dimuat ke RAM saat _booting_.
  - **Fungsi:** Bertindak sebagai jembatan dari _bootloader_ ke _kernel_ yang berjalan. Ini berisi _binary_ penting seperti `cryptsetup` untuk mendekripsi _root filesystem_ dan `lvm` untuk mengelola volume.

- **_Kernel Parameter_**

  - **Definisi:** Argumen atau instruksi yang diberikan kepada _kernel_ saat dimuat.
  - **Fungsi:** Digunakan untuk memberi tahu _kernel_ informasi penting, seperti lokasi _root filesystem_ (`root=/dev/sdXn`) atau, dalam kasus ini, lokasi perangkat yang terenkripsi (`cryptdevice=/dev/sdXn:mycrypt`).

- **_Hooks_**

  - **Definisi:** Skrip yang dijalankan oleh _initramfs_ saat proses _boot_.
  - **Fungsi:** Pada Arch Linux, _initramfs_ dibuat menggunakan `mkinitcpio`. _Hooks_ seperti `encrypt` dan `lvm2` yang ditambahkan ke _file_ konfigurasi akan menyertakan semua program yang diperlukan ke dalam _initramfs_ untuk menangani enkripsi dan LVM.

### **Alur Kerja & Visualisasi**

Memahami alur _booting_ dengan enkripsi akan sangat menguatkan pemahaman Anda.

**Diagram Alur _Boot_ Sistem Terenkripsi (UEFI/GPT/LUKS)**

```
┌──────────────────────────┐
│     UEFI Firmware        │
│    (Mulai Proses Boot)   │
└──────────┬───────────────┘
           │
┌──────────▼───────────────┐
│     Bootloader (GRUB/    │─────────┐
│     systemd-boot)        │         │
└──────────┬───────────────┘         ▼
           │                     Membaca Partisi ESP
           │                     & file konfigurasi bootloader
┌──────────▼───────────────┐
│     Memuat Kernel &      │─────────┐
│     Initramfs            │         │
└──────────┬───────────────┘         ▼
           │                     Kernel dimuat ke RAM, bersamaan dengan
           │                     initramfs yang berisi hooks 'encrypt' & 'lvm2'
┌──────────▼───────────────┐
│  _Initramfs_ mengambil   │─────────┐
│  alih dan meminta kata   │         │
│  sandi untuk LUKS        │         │
└──────────┬───────────────┘         ▼
           │                     Proses 'hook' dari mkinitcpio di initramfs
           │                     menjalankan cryptsetup.
┌──────────▼───────────────┐
│      LUKS Dekripsi       │─────────┐
│     Partition/Volume     │         │
└──────────┬───────────────┘         ▼
           │                     Setelah kata sandi benar, disk fisik terbuka.
           │
┌──────────▼───────────────┐
│     Mounting Sistem      │─────────┐
│     File Utama           │         │
└──────────┬───────────────┘         ▼
           │                     LVM mengelola volume logis.
           │                     Kernel akhirnya dapat mount root filesystem.
┌──────────▼───────────────┐
│     Sistem Operasi       │
│      Dimuat Sempurna     │
└──────────────────────────┘
```

### **Sintaks Dasar / Contoh Implementasi Inti**

Berikut adalah contoh langkah demi langkah yang perlu Anda lakukan untuk sistem **Arch Linux** yang ingin dienkripsi.

#### **Langkah 1: Membuat Partisi LUKS**

Ini dilakukan sebelum instalasi sistem _file_ (`ext4`, `btrfs`, dsb.).

```bash
# Sintaks: cryptsetup luksFormat [perangkat]
# Contoh: enkripsi partisi /dev/sda2
sudo cryptsetup luksFormat /dev/sda2
```

Setelah itu, buka "wadah" LUKS yang terenkripsi.

```bash
# Sintaks: cryptsetup open [perangkat] [nama-mapping]
# Contoh: Buka partisi sda2 dan beri nama 'mycrypt'
sudo cryptsetup open /dev/sda2 mycrypt
```

Setelah langkah ini, Anda akan memiliki perangkat baru di `/dev/mapper/mycrypt` yang dapat Anda gunakan seperti partisi biasa. Anda bisa membuat partisi LVM di atasnya atau langsung memformatnya.

#### **Langkah 2: Mengonfigurasi _Initramfs_**

_Initramfs_ perlu tahu bahwa ia harus membuka perangkat terenkripsi saat _boot_. Di Arch Linux, ini dilakukan dengan mengedit _file_ `/etc/mkinitcpio.conf`.

```bash
# Buka file konfigurasi mkinitcpio
sudo vim /etc/mkinitcpio.conf
```

Cari baris `HOOKS` dan tambahkan `encrypt` dan `lvm2` (jika menggunakan LVM) ke dalamnya. Pastikan urutannya benar: `keyboard` dan `block` harus ada sebelum `encrypt`.

```bash
HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems fsck)
```

Setelah mengedit, buat ulang _initramfs_ agar perubahan diterapkan.

```bash
# Perintah untuk membuat ulang semua file initramfs
sudo mkinitcpio -P
```

#### **Langkah 3: Menambahkan Parameter _Kernel_**

_Bootloader_ perlu diberi tahu lokasi perangkat yang terenkripsi. Anda harus menambahkan parameter `cryptdevice` ke konfigurasi _bootloader_ Anda.

- **Untuk GRUB:** Edit `/etc/default/grub` dan tambahkan ke `GRUB_CMDLINE_LINUX_DEFAULT`.

  ```bash
  # Sintaks: cryptdevice=[perangkat-luks]:[nama-mapping-luks]
  GRUB_CMDLINE_LINUX_DEFAULT="... quiet cryptdevice=/dev/sda2:mycrypt"
  ```

  Jangan lupa menjalankan `sudo grub-mkconfig -o /boot/grub/grub.cfg` setelahnya.

- **Untuk _Systemd-boot_:** Edit _file_ `arch.conf` di partisi ESP Anda.

  ```bash
  # Lokasi: /boot/efi/loader/entries/arch.conf
  # Sintaks: cryptdevice=[perangkat-luks]:[nama-mapping-luks]

  options root="LABEL=Arch_Root" rw cryptdevice=/dev/sda2:mycrypt
  ```

### **Hubungan dengan Modul Lain**

- **Ke Modul 2 (_Bootloader_):** Modul ini adalah kelanjutan dari Modul 2. Semua konfigurasi yang Anda lakukan di sini (menambahkan _kernel parameter_) bergantung pada pemahaman Anda tentang cara kerja dan _file_ konfigurasi _bootloader_ yang berbeda.
- **Ke Modul 4 (_Troubleshooting_):** Jika Anda gagal dalam mengonfigurasi `mkinitcpio.conf` atau `GRUB_CMDLINE_LINUX_DEFAULT`, sistem Anda akan gagal _boot_. Kemampuan untuk mengenali kesalahan _kernel_ dan memperbaikinya adalah inti dari modul _troubleshooting_ berikutnya.

### **Tips dan Praktik Terbaik**

- **Selalu Backup Header LUKS:** _Header_ LUKS yang menyimpan kunci enkripsi sangat penting. Jika rusak, data Anda tidak dapat dipulihkan. Gunakan perintah `sudo cryptsetup luksHeaderBackup /dev/sdXn --header-backup-file <file>` untuk membuat _backup_.
- **Pahami Urutan _Hooks_:** Urutan _hooks_ di `mkinitcpio.conf` itu penting. `block` harus sebelum `encrypt` karena `encrypt` perlu akses ke perangkat _block_. Demikian pula, `lvm2` harus setelah `encrypt` karena LVM beroperasi di atas _device mapper_ yang dibuat oleh LUKS.

### **Potensi Kesalahan Umum & Solusi**

- **Masalah:** Saat _booting_, Anda melihat pesan `ERROR: device not found`.
  - **Penyebab:** Kesalahan _typo_ pada _kernel parameter_ `cryptdevice` atau `UUID` yang salah.
  - **Solusi:** Periksa kembali _file_ konfigurasi _bootloader_ Anda. Pastikan nama perangkat (`/dev/sda2`) atau UUID yang Anda gunakan benar. Anda dapat menggunakan `lsblk -f` untuk memeriksa nama perangkat dan `blkid` untuk memeriksa UUID.
- **Masalah:** Layar kosong atau _hang_ saat _booting_ setelah memasukkan kata sandi.
  - **Penyebab:** _Hooks_ `lvm2` atau `encrypt` tidak ditambahkan dengan benar ke `/etc/mkinitcpio.conf`, atau _initramfs_ belum dibuat ulang.
  - **Solusi:** _Boot_ dari _live_ USB, lakukan `chroot` ke sistem Anda, perbaiki `mkinitcpio.conf`, dan jalankan `sudo mkinitcpio -P` lagi.

### **Sumber Referensi Lengkap**

- **ArchWiki:**
  - [Dm-crypt/Encrypting an entire system](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system) - Panduan paling komprehensif untuk enkripsi _full-disk_ di Arch Linux.
  - [LVM](https://wiki.archlinux.org/title/LVM) - Panduan penggunaan LVM.
- **Dokumentasi Resmi:**
  - [`cryptsetup` man page](<https://man.archlinux.org/man/cryptsetup.8%5D(https://man.archlinux.org/man/cryptsetup.8)>) - Halaman _manual_ resmi untuk `cryptsetup`.
  - [`mkinitcpio` man page](<https://man.archlinux.org/man/mkinitcpio.8%5D(https://man.archlinux.org/man/mkinitcpio.8)>) - Halaman _manual_ untuk `mkinitcpio`.

Kita telah menyelesaikan pendalaman untuk **Fase 3, Modul 3**. Ini adalah modul yang sangat penting untuk mencapai tingkat keahlian.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
