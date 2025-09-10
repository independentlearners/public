### **[Fase 3: Mengembangkan Sistem dan Menuju Tingkat Ahli][0]**

### **Modul 8: Instalasi & Konfigurasi Lingkungan Minimalis (Sway Window Manager)**

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Membangun Antarmuka Pengguna
  * Konsep Kunci & Filosofi Mendalam: Filosofi Wayland dan Sway
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Langkah 1: Instalasi Paket Dasar Wayland dan Sway**
      * **Langkah 2: Konfigurasi Jaringan & Pengguna**
      * **Langkah 3: Konfigurasi *Display* dan *Font***
      * **Langkah 4: Konfigurasi Sway**
      * **Langkah 5: Menginstal Aplikasi Esensial CLI**
  * Terminologi Esensial: Wayland, Sway, WLROOTS, X11, i3.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

</details>

-----

### **Deskripsi Konkret: Membangun Antarmuka Pengguna**

Sekarang sistem dasar Anda sudah terpasang. Ketika Anda *login*, Anda hanya akan melihat *shell* atau baris perintah. Tidak ada jendela, tidak ada *mouse*, tidak ada ikon. Modul ini akan membimbing Anda untuk membangun antarmuka pengguna (`user interface`) yang minimalis dan efisien sesuai dengan filosofi Anda. Kita akan menggunakan **Wayland** sebagai server tampilan modern, dengan **Sway** sebagai *window manager*.

### **Konsep Kunci & Filosofi Mendalam: Filosofi Wayland dan Sway**

  * **Wayland:** Ini adalah protokol server tampilan yang dirancang untuk menggantikan X11 yang sudah tua. Filosofinya adalah **keamanan, kesederhanaan, dan efisiensi**. Dengan Wayland, setiap aplikasi terisolasi dari yang lain, yang mengurangi risiko keamanan. Ini juga memberikan pengalaman yang lebih mulus dan bebas *screen-tearing*.
  * **Sway:** Sway adalah ***compositor*** Wayland yang kompatibel dengan i3. Filosofinya adalah **manajemen jendela yang fleksibel dan berbasis *keyboard***. Sway adalah ***tiling window manager*** yang berarti ia secara otomatis mengatur jendela dalam tata letak non-tumpang tindih yang optimal. Dengan Sway, Anda akan mengontrol semua jendela dengan *keyboard*, yang sangat ideal untuk produktivitas.

### **Sintaks Dasar / Contoh Implementasi Inti**

**Penting:** Anda sekarang harus berada di dalam sistem Arch Linux yang telah Anda instal dan *login* sebagai *root* atau pengguna lain yang memiliki akses `sudo`.

#### **Langkah 1: Instalasi Paket Dasar Wayland dan Sway**

```bash
# Perintah ini menginstal paket-paket esensial untuk Wayland dan Sway
pacman -S sway swaylock swayidle dmenu
```

  * **Penjelasan Mendalam:**

      * `sway`: Paket utama untuk *window manager*.
      * `swaylock`: Untuk mengunci layar dengan aman.
      * `swayidle`: Untuk mengunci atau mematikan layar secara otomatis setelah tidak aktif.
      * `dmenu`: Peluncur aplikasi minimalis yang akan Anda gunakan untuk meluncurkan program.

  * **Verifikasi Keberhasilan:** Jalankan `pacman -Qs sway`. Jika paket-paket yang diinstal muncul, berarti instalasi berhasil.

#### **Langkah 2: Konfigurasi Jaringan & Pengguna**

Jika Anda menggunakan WiFi, Anda perlu menginstal dan mengkonfigurasi `NetworkManager` atau `iwd`.

```bash
# Menginstal NetworkManager dan nm-applet
pacman -S networkmanager network-manager-applet
# Mengaktifkan layanan NetworkManager
systemctl enable --now NetworkManager
```

  * **Penjelasan Mendalam:** `NetworkManager` adalah layanan yang akan mengelola koneksi jaringan Anda secara otomatis, baik kabel maupun nirkabel.

  * **Verifikasi Keberhasilan:** Jalankan `nmcli device`. Jika Anda melihat perangkat jaringan Anda dengan status `connected`, itu berarti koneksi jaringan Anda berhasil.

Selanjutnya, buat pengguna standar:

```bash
# Membuat pengguna baru, ganti 'username' dengan nama pilihan Anda.
useradd -mG wheel,audio,video,storage,input username
# Mengatur kata sandi untuk pengguna baru
passwd username
# Tambahkan 'wheel' ke sudoers
pacman -S sudo
visudo
# Hilangkan komentar pada baris ini, simpan & keluar:
# %wheel ALL=(ALL:ALL) ALL
```

  * **Penjelasan Mendalam:** Membuat pengguna non-*root* adalah **praktik keamanan terbaik**. Baris `useradd` akan membuat pengguna baru dengan hak akses ke grup-grup esensial.

  * **Verifikasi Keberhasilan:** Coba beralih ke pengguna baru Anda dengan `su - username`. Jika berhasil, Anda akan berada di *prompt* *shell* pengguna baru Anda.

#### **Langkah 3: Konfigurasi *Display* dan *Font***

Anda perlu menginstal *font* dan *compositor* untuk tampilan yang optimal.

```bash
# Menginstal font dan xorg-xwayland
# xorg-xwayland: Untuk menjalankan aplikasi X11 di lingkungan Wayland
pacman -S ttf-dejavu xorg-xwayland
```

  * **Penjelasan Mendalam:** `ttf-dejavu` adalah *font* yang umum digunakan di Linux. `xorg-xwayland` penting untuk menjalankan aplikasi yang tidak mendukung Wayland secara *native*.

  * **Verifikasi Keberhasilan:** Anda tidak akan melihat *output* visual sekarang, tetapi *font* ini akan tersedia ketika Anda meluncurkan Sway.

#### **Langkah 4: Konfigurasi Sway**

Sway menggunakan *file* konfigurasi yang mirip dengan i3. *File* ini harus disalin ke direktori pengguna Anda.

```bash
# Beralih ke pengguna yang baru Anda buat
su - username
# Salin file konfigurasi bawaan Sway
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/
# Buka dan edit file konfigurasi tersebut
vim ~/.config/sway/config
```

Di dalam *file* konfigurasi, Anda dapat menyesuaikan banyak hal. Ini adalah jantung dari Sway.

#### **Langkah 5: Menginstal Aplikasi Esensial CLI**

Lingkungan CLI Anda tidak akan lengkap tanpa beberapa alat yang kuat.

```bash
# Menginstal Neovim (editor teks), ranger (file manager), mpv (pemutar video), dan cmus (pemutar audio).
pacman -S neovim ranger mpv cmus
```

  * **Penjelasan Mendalam:** Ini adalah aplikasi yang sangat kuat dan ringan, semuanya berbasis CLI. `ranger` adalah pengelola *file* versi konsol, dan `mpv` adalah pemutar video minimalis yang bisa dioperasikan dari terminal. `cmus` adalah pemutar musik CLI yang sangat cepat dan ringan.

  * **Verifikasi Keberhasilan:** Setelah instalasi, Anda dapat mengetik `ranger` atau `mpv` untuk melihat antarmuka CLI mereka.

### **Verifikasi & *Output***

Setelah menyelesaikan semua langkah, Anda dapat keluar dari *shell* pengguna dan kembali ke *root*, lalu *reboot* sistem.

```bash
exit
reboot
```

Setelah *reboot*, *login* sebagai pengguna yang baru Anda buat. Lalu, jalankan Sway.

```bash
# Perintah untuk menjalankan Sway
sway
```

Jika semuanya berhasil, Anda akan melihat antarmuka Sway yang minimalis.

### **Hubungan dengan Modul Lain**

  * **Ke Modul 9 (*Troubleshooting*):** Jika Anda tidak dapat menjalankan Sway, atau ada yang salah, Anda akan menggunakan keterampilan *troubleshooting* yang akan kita pelajari di modul berikutnya.
  * **Ke Modul 10 (Skenario Lanjutan):** Setelah Anda mahir dengan Sway, Anda bisa mulai menyesuaikan *file* konfigurasi lebih dalam, menginstal *utility* CLI lain, dan membuat skrip untuk mengotomatisasi tugas.

### **Tips & Praktik Terbaik**

  * **Perlengkapan Awal:** Sebelum *reboot*, pastikan Anda sudah menginstal aplikasi terminal seperti `alacritty` atau `foot`, karena Sway membutuhkan terminal untuk dapat berinteraksi.
  * **Beralih Pengguna:** Selalu kerjakan konfigurasi pribadi di bawah pengguna standar Anda, bukan *root*, untuk alasan keamanan.

Anda telah menyelesaikan instalasi lingkungan Sway dan aplikasi CLI esensial. Ini adalah langkah besar. Sekarang, Anda memiliki sistem Arch Linux yang berfungsi penuh, minimalis, dan siap untuk digunakan. Namun, sebagai seorang ahli, penting untuk memiliki rencana cadangan.

Modul ini akan membekali Anda dengan keterampilan paling berharga: ***troubleshooting***. Memahami cara memperbaiki masalah saat sistem gagal *boot* adalah apa yang membedakan pengguna biasa dari seorang profesional.

-----

### **Modul 9: *Boot* *Recovery* dan *Troubleshooting***

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Memecahkan Masalah
  * Konsep Kunci & Filosofi Mendalam: Pendekatan Diagnostik
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Langkah 1: Identifikasi Gejala Masalah**
      * **Langkah 2: Gunakan Lingkungan *Live***
      * **Langkah 3: Mengakses Sistem yang Rusak dengan *Chroot***
      * **Langkah 4: Contoh Kasus: Memperbaiki *Bootloader***
      * **Langkah 5: Memperbaiki `fstab` yang Rusak**
  * Terminologi Esensial: *Journalctl*, *Kernel Panic*, *Emergency Shell*, `arch-chroot`.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

-----

### **Deskripsi Konkret: Memecahkan Masalah**

Anggaplah modul ini sebagai "kotak peralatan" Anda. Di dunia nyata, sistem bisa gagal *boot* karena berbagai alasan: pembaruan yang gagal, konfigurasi yang salah, atau kerusakan *file* sistem. Dengan modul ini, Anda akan belajar bagaimana mendiagnosis masalah, menemukan akarnya, dan memperbaikinya.

### **Konsep Kunci & Filosofi Mendalam: Pendekatan Diagnostik**

Filosofi utama dari *troubleshooting* adalah **diagnostik sistematis**. Jangan panik atau menebak-nebak. Mulailah dengan menganalisis gejala, lalu gunakan alat yang tepat untuk mengisolasi masalah, dan akhirnya terapkan solusi yang terukur. Ini adalah keterampilan yang tidak lekang oleh waktu dan berlaku untuk setiap sistem, tidak hanya Linux.

### **Sintaks Dasar / Contoh Implementasi Inti**

Kita akan menyimulasikan skenario *troubleshooting* paling umum.

#### **Langkah 1: Identifikasi Gejala Masalah**

Sistem Anda gagal *boot* dan menampilkan salah satu dari pesan berikut:

  * ***Kernel Panic*:** Layar penuh dengan teks yang menunjukkan kesalahan fatal pada *kernel*.
      * **Arti:** Ini seringkali berarti masalah pada `initramfs` atau *kernel* itu sendiri.
  * **`ERROR: device not found`:** *Bootloader* Anda tidak dapat menemukan partisi *root* atau *swap*.
      * **Arti:** Masalah biasanya pada *file* konfigurasi *bootloader* (`grub.cfg`, `loader.conf`) atau `fstab`.

#### **Langkah 2: Gunakan Lingkungan *Live***

Karena sistem Anda tidak dapat *boot*, Anda harus menggunakan "pintu belakang" untuk masuk.

  * **Masukkan USB Instalasi Arch Live Anda** dan *boot* kembali darinya.
  * **Jalankan `lsblk`** untuk mengidentifikasi partisi *root* dan ESP Anda.
  * ***Mount* partisi *root*** ke `/mnt` dan partisi ESP ke `/mnt/boot/efi`. (Lihat kembali Modul 3 untuk langkah ini).

#### **Langkah 3: Mengakses Sistem yang Rusak dengan `Chroot`**

Ini adalah langkah paling penting. Anda akan menggunakan `arch-chroot` untuk masuk ke sistem yang rusak dan menjalankan perintah perbaikan.

```bash
# Masuk ke sistem yang rusak
arch-chroot /mnt
```

Setelah masuk, *shell* Anda akan beroperasi di dalam sistem yang *broken*.

#### **Langkah 4: Contoh Kasus: Memperbaiki *Bootloader***

Anda mendapatkan pesan `ERROR: file not found` saat *boot*. Ini biasanya berarti *bootloader* menunjuk ke *kernel* atau `initramfs` yang tidak ada atau *path* yang salah.

  * **Solusi:**
    1.  Di dalam lingkungan `chroot`, pastikan `initramfs` telah dibuat.
    <!-- end list -->
    ```bash
    # Ini akan membuat ulang semua file initramfs
    mkinitcpio -P
    ```
    2.  Jika Anda menggunakan GRUB, buat ulang *file* konfigurasi.
    <!-- end list -->
    ```bash
    # Buat ulang grub.cfg
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
    3.  Jika menggunakan `systemd-boot`, periksa `arch.conf` dan pastikan `linux` dan `initrd` menunjuk ke *file* yang benar.
    <!-- end list -->
    ```bash
    # Periksa isi file konfigurasi
    cat /boot/efi/loader/entries/arch.conf
    ```

#### **Langkah 5: Memperbaiki `fstab` yang Rusak**

Anda melihat pesan `mount error` atau sistem masuk ke ***Emergency Shell***. Ini biasanya karena ada kesalahan *typo* atau UUID yang salah di *file* `/etc/fstab`.

  * **Solusi:**
    1.  Di dalam `chroot`, gunakan `lsblk -f` untuk mendapatkan UUID yang benar dari semua partisi.
    2.  Edit *file* `fstab`.
    <!-- end list -->
    ```bash
    vim /etc/fstab
    ```
    3.  Perbaiki entri yang salah menggunakan UUID yang benar.
    4.  Anda juga bisa menjalankan `genfstab -U /mnt > /mnt/etc/fstab` lagi untuk membuat *file* yang baru (meskipun ini akan menimpa semua konfigurasi yang ada).

### **Verifikasi & *Output***

Setelah melakukan perbaikan, jalankan perintah `exit` untuk keluar dari `chroot`, lalu `umount -R /mnt` dan `reboot`.

Jika perbaikan berhasil, sistem Anda akan *boot* dengan normal. Jika masih gagal, Anda harus kembali ke lingkungan *live* dan memulai proses diagnostik dari awal.

### **Hubungan dengan Modul Lain**

  * **Kurikulum Lengkap:** Modul ini adalah ringkasan praktis dari semua yang telah Anda pelajari. `arch-chroot` adalah alat utama dari Modul 5, `fstab` dari Modul 4, dan pengetahuan tentang *bootloader* dari Modul 6. Menguasai modul ini menunjukkan penguasaan total atas semua konsep sebelumnya.

### **Tips & Praktik Terbaik**

  * **Membaca *Journal*:** Saat sistem gagal, Anda bisa menggunakan `journalctl` untuk melihat *log* dari *boot* sebelumnya. `journalctl -b -1` akan menampilkan *log* dari *boot* terakhir. Ini adalah alat diagnostik yang sangat kuat.
  * **Selalu *Reboot*:** Setelah perbaikan di lingkungan `chroot`, pastikan Anda keluar dari `chroot` dan *reboot* sistem untuk menguji perbaikan.

# Selamat!

Dengan menguasai modul ini, Anda kini memiliki kepercayaan diri untuk menangani kegagalan *boot* apa pun. Anda telah menyelesaikan seluruh kurikulum ini.

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
