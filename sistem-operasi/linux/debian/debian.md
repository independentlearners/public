# Debian Minimalis

Untuk menginstal Debian secara minimalis langsung dari terminal Arch Linux tanpa mengunduh file ISO, kita akan menggunakan metode **`debootstrap`**. Metode ini adalah cara standar untuk melakukan bootstrap (membangun sistem dasar) distro turunan Debian/Ubuntu dari distro Linux lain.

Berdasarkan output `fdisk -l` kita, akhir partisi kita berada di sektor `1485271039`, sedangkan total sektor NVMe adalah `2000409264`. Ini berarti kita memiliki sisa ruang kosong sekitar **245 GiB** di bagian akhir disk, yang sangat aman untuk mengambil 100GB (Root) dan 8GB (Swap).

Berikut adalah panduan langkah demi langkah tingkat *superuser* untuk mengeksekusinya:

---

### Fase 1: Pembuatan Partisi & Pemformatan (Di Arch Linux)

Buka terminal Arch Linux Kita dan masuk sebagai root.

**1. Membuat Partisi Baru Menggunakan `fdisk`**

```bash
sudo fdisk /dev/nvme0n1

```

Di dalam prompt interaktif `fdisk`, lakukan langkah berikut secara berurutan:

* Ketik **`n`** (New partition) $\rightarrow$ Tekan Enter (Pilih nomor default `8`) $\rightarrow$ Tekan Enter (First sector default) $\rightarrow$ Ketik **`+100G`** (Last sector) $\rightarrow$ Tekan Enter. *(Ini untuk Root Debian)*
* Ketik **`n`** (New partition) $\rightarrow$ Tekan Enter (Pilih nomor default `9`) $\rightarrow$ Tekan Enter (First sector default) $\rightarrow$ Ketik **`+8G`** (Last sector) $\rightarrow$ Tekan Enter. *(Ini untuk Swap Debian)*
* Ubah tipe partisi swap: Ketik **`t`** $\rightarrow$ Masukkan nomor partisi **`9`** $\rightarrow$ Masukkan kode tipe partisi swap (Ketik **`19`** jika GPT, atau ketik `L` untuk list dan cari `Linux swap`).
* Ketik **`w`** untuk menyimpan perubahan ke disk dan keluar.

**2. Memformat Partisi Baru**
Format partisi root (`p8`) dengan filesystem `ext4` dan inisialisasi partisi swap (`p9`):

```bash
sudo mkfs.ext4 /dev/nvme0n1p8
sudo mkswap /dev/nvme0n1p9

```

**3. Jika tidak ada `fdisk` gunakan `cfdisk`:**

```bash
lsblk -f
NAME        FSTYPE      FSVER LABEL   UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda
└─sda1      exfat       1.0   data    7281-0BBC                             769.2G    17% /srv/data
nvme0n1
├─nvme0n1p1 ntfs                      ECA2E689A2E6581A
├─nvme0n1p2 crypto_LUKS 1             d68f7470-bcc0-42b1-a992-472268831b1b
├─nvme0n1p3 vfat        FAT32 EFIBOOT BC93-16D6
├─nvme0n1p4 crypto_LUKS 1             1d5212de-280d-4ea9-9d72-9c6fc25a5427
├─nvme0n1p5 ext4        1.0           6a72ac8a-12e1-432d-a716-744e666643f4   79.8G    32% /
├─nvme0n1p6 swap        1             2783fd51-fead-43a5-87c7-a648f3627c91                [SWAP]
└─nvme0n1p7 vfat        FAT32         4886-2E94
sudo cfdisk /dev/nvme0n1
Syncing disks.
lsblk -f
NAME        FSTYPE      FSVER LABEL   UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda
└─sda1      exfat       1.0   data    7281-0BBC                             769.2G    17% /srv/data
nvme0n1
├─nvme0n1p1 ntfs                      ECA2E689A2E6581A
├─nvme0n1p2 crypto_LUKS 1             d68f7470-bcc0-42b1-a992-472268831b1b
├─nvme0n1p3 vfat        FAT32 EFIBOOT BC93-16D6
├─nvme0n1p4 crypto_LUKS 1             1d5212de-280d-4ea9-9d72-9c6fc25a5427
├─nvme0n1p5 ext4        1.0           6a72ac8a-12e1-432d-a716-744e666643f4   79.8G    32% /
├─nvme0n1p6 swap        1             2783fd51-fead-43a5-87c7-a648f3627c91                [SWAP]
├─nvme0n1p7 vfat        FAT32         4886-2E94
├─nvme0n1p8 ext4        1.0           c1239153-f408-4172-8e29-011d89398e16
└─nvme0n1p9 swap        1             87c23d0d-5c7a-4d88-8a62-2a3e8381d4d8

```

---

### Fase 2: Mempersiapkan Environment & Debootstrap

**1. Install Tools Debootstrap di Arch Linux**

```bash
sudo pacman -Syu --noconfirm --needed debootstrap \
arch-install-scripts \
dosfstools \
e2fsprogs \
efibootmgr \
cryptsetup \
parted
```

*(Catatan: `arch-install-scripts` kita butuhkan untuk menggunakan perintah `genfstab` dan `arch-chroot` yang jauh lebih praktis).*

**2. Mount Partisi Target**
Pasang partisi root Debian ke `/mnt`, aktifkan swap, dan pasang partisi EFI bersama (`p3`):

```bash
sudo mount /dev/nvme0n1p8 /mnt
sudo swapon /dev/nvme0n1p9

# Buat direktori EFI dan mount partisi EFI Manjaro (p3)
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/nvme0n1p3 /mnt/boot/efi

```

**3. Jalankan Debootstrap untuk Mengunduh Sistem Dasar Debian**
Kita akan menginstal Debian versi stabil terbaru (Debian 12 Bookworm):

```bash
sudo debootstrap --arch amd64 bookworm /mnt http://deb.debian.org/debian/

```

Proses ini akan langsung mengunduh paket-paket dasar minimal (seperti `apt`, `dpkg`, `bash`, dll.) langsung dari mirror resmi Debian ke dalam direktori `/mnt`.

**4. Generate File `/etc/fstab`**
Gunakan utilitas Arch untuk membuat mapping UUID partisi secara otomatis ke Debian:

```bash
sudo genfstab -U /mnt | sudo tee -a /mnt/etc/fstab

```

*Verifikasi fstab dengan `cat /mnt/etc/fstab` untuk memastikan partisi `/`, `/boot/efi`, dan `swap` Debian sudah terdaftar dengan benar.*

---

### Fase 3: Konfigurasi Sistem Debian (Masuk via Chroot)

Sekarang kita akan masuk ke dalam sistem Debian yang baru saja di-bootstrap menggunakan `chroot`. Sekaligus untuk mengatur jaringan menggunakan **iwd** (`iwctl`) dan koneksi **Bluetooth** pada instalasi Debian minimal melalui terminal Arch Linux menggunakan `sudo chroot` (bukan `arch-chroot`), Kita harus melakukan proses *bind mount* pada *filesystem virtual* secara manual terlebih dahulu. Langkah terperinci penyelesaiannya:

##### Langkah 1: Mempersiapkan Lingkungan Chroot Manual di Arch Linux

Karena disini tidak menggunakan `arch-chroot` (yang secara otomatis menangani *mounting*), Kita harus mengaitkan direktori sistem utama Arch Linux ke dalam direktori Debian Kita agar perintah seperti `apt` dan `systemctl` di dalam chroot dapat mengenali perangkat keras dan berjalan dengan normal.

Asumsikan partisi Debian minimal Kita saat ini di-mount di direktori `/mnt` pada Arch Linux Kita. Cara ini juga untuk menghindari `E: Can not write log (Is /dev/pts mounted?)`. Jalankan perintah berikut di terminal Arch Linux:


```bash

# BACA INI:
# Jika mountpoint berada didalam dir /mnt seperti /mnt/debian maka :
# sudo chroot /mnt/debian /bin/bash dan semua bind juga harus melakukan hal yang sama

# 1. Lakukan bind mount filesystem virtual yang dibutuhkan oleh sistem
sudo mount --bind /dev /mnt/dev
sudo mount --bind /dev/pts /mnt/dev/pts
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /run  /mnt/run

# 2. Salin konfigurasi DNS (resolv.conf) dari Arch Linux ke Debian
# Ini wajib agar lingkungan chroot Kita memiliki koneksi internet untuk mengunduh paket
sudo cp -L /etc/resolv.conf /mnt/etc/resolv.conf

# 3. Masuk ke dalam sistem Debian menggunakan chroot standar
sudo chroot /mnt /bin/bash
# 4. Pastikan untuk menjalankan minimal sekali saja dalam chroot
export PATH=$PATH:/usr/sbin:/sbin

```

*Sekarang Kita berada di dalam terminal Debian dasar.*

Laptop seperti Asus Vivobook membutuhkan firmware *non-free* agar kartu Wi-Fi dan Bluetooth (seperti Intel atau Atheros) dapat dikenali saat sistem melakukan proses booting mandiri.

**1. Atur Repositori Paket Resmi Debian**
Buka atau buat file `/etc/apt/sources.list`:

```bash
nano /etc/apt/sources.list

```

Masukkan baris repositori berikut (termasuk komponen `non-free-firmware` untuk driver hardware laptop Asus Vivobook Kita):

```text
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware

```

Simpan (Ctrl+O, Enter) dan keluar (Ctrl+X).

**2. Update & Install Kernel, Firmware, serta peralatan dan Konfigurasi Jaringan Berbasis `iwd` (`iwctl`)**
Untuk membuat Debian minimal tetap ringan tanpa perlu memasang manajer jaringan besar (seperti `NetworkManager` atau `dhcpcd`), kita akan memanfaatkan **fitur DHCP internal bawaan `iwd`**.

  - 1. **Instal paket `iwd`, `dbus`, bersama firmware Wi-Fi dan peralatan yang kita inginkan:**
  - Paket `dbus` sangat krusial karena perintah `iwctl` berkomunikasi dengan layanan latar belakang `iwd` melaluinya.
  - Sistem debootstrap murni juga belum memiliki kernel Linux. Kita harus menginstalnya secara manual bersama dengan paket lain yang kita butuhkan:

  ```bash
  cat /etc/debian_version
  ls /boot
  ls /etc/fstab
  
  # Perbarui basis data paket Debian Kita di dalam chroot
  apt update
  apt install linux-image-amd64 firmware-linux systemd-sysv \
  network-manager systemd-resolved locales sudo nano yazi nvim git iwd bat gdu zsh btop \
  dbus firmware-iwlwifi firmware-linux-nonfree -y

  dpkg -l | grep linux-image
  # output:
  # update-initramfs: Generating
  # menunjukkan paket kernel sudah terinstal.

  ```
  *(Catatan: Sesuaikan `firmware-iwlwifi` jika laptop Kita menggunakan kartu Wi-Fi non-Intel, misalnya `firmware-atheros`). Tetapi jika  `intel`, langsung ke pengaktifan layanan jaringan*
 > - 2. **Konfigurasi DHCP Internal `iwd`:**
 >  - Buat atau edit file konfigurasi utama `iwd` agar ia otomatis meminta alamat IP (DHCP) setelah Kita terhubung ke Wi-Fi via `iwctl`:
 >  ```bash
 >  mkdir -p /etc/iwd
 >  nano /etc/iwd/main.conf
 >  ```
 >
 >
 >  Masukkan baris konfigurasi berikut ke dalam file tersebut:
 >  ```ini
 >  [General]
 >  EnableNetworkConfiguration=true
 >  ```
 >  *Simpan file dengan menekan `Ctrl+O`, `Enter`, lalu keluar dengan `Ctrl+X`.*

  - 3. **Aktifkan Layanan Jaringan:**
  Aktifkan layanan agar langsung berjalan otomatis saat Debian di-boot:

```bash
```


  ```bash
  systemctl enable iwd
  systemctl enable dbus
  systemctl enable systemd-networkd
  systemctl enable systemd-resolved 
  ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

  # Uji hasil:
  ping 1.1.1.1
  ping google.com
  ```

---

##### Langkah 4: Instalasi dan Konfigurasi Bluetooth

  - 1. **Instal paket Bluetooth resmi (`bluez`) dan perkakas CLI-nya:**
  ```bash
  apt install bluez bluez-tools
  
  ```


 - 2. **Aktifkan Layanan Bluetooth:**
  ```bash
  systemctl enable bluetooth
  
  ```

**3. Konfigurasi Dasar Sistem (Hostname, Locale, & Password Root)**

* **Hostname:**
```bash
echo "debian" > /etc/hostname
# Periksa hasilnya
cat /etc/hostname
debian
```

* **Password Root:**
```bash
passwd root

```
Jalankan berikut untuk menunjukan bahwa sistem belum memiliki user lokal:

```bash
grep '/home' /etc/passwd
```

Output pasti kosong jika belum pernah membuatnya. Artinya saat ini hanya ada akun `root`. Jika boot sekarang maka Kita hanya bisa login sebagai root. Nanti perlu:
```bash
useradd -m -G sudo -s /bin/bash namauser
passwd namauser
```

tetapi itu bisa dilakukan setelah boot pertama juga. Atau jika anda ingin membuatnya sekarang seperti contoh berikut:

```bash
useradd -m -G sudo -s /bin/bash userdebian
passwd userdebian
```
Jika gagal dengan contoh output: `useradd: command not found` ini sangat menarik. Di Debian normal, `useradd` berasal dari paket: `passwd`

Coba cek:

```bash
which useradd
```

Jika kosong kemungkinan PATH tidak memuat /usr/sbin. Coba jalankan pengecekan:

```bash
echo $PATH
```
Jika tidak ada: `/usr/sbin`, maka jalankan:
```bash
export PATH=$PATH:/usr/sbin:/sbin

```
Lalu:

```bash
which useradd
```
Jika berhasil menampilkan output, sebaiknya buat langsung usernya sekarang:
```bash
useradd -m -G sudo -s /bin/bash namauser
passwd namauser
```


Kemudian test hasilnya:

```bash
dpkg -S $(which passwd)
```

atau:

```bash
dpkg -l passwd
```

Cek juga:

```bash
ls /usr/sbin/useradd
ls /usr/bin/passwd
```

---

###### Perbedaan dengan Arch

Di Arch:

```bash
pacstrap
```

langsung memasang paket dasar yang cukup lengkap.

Sedangkan di Debian:

```bash
debootstrap
```

sering menghasilkan sistem yang jauh lebih minimal.

Akibatnya beberapa utilitas administrasi yang biasanya dianggap "selalu ada" ternyata belum terinstal.

---

### Cara membuat user tanpa `useradd`

Kalau memang paketnya belum ada, jangan edit `/etc/passwd` manual dulu.

Lebih baik pasang paket yang benar:

```bash
apt install passwd
```

Lalu cek:

```bash
which useradd
```

harus muncul:

```text
/usr/sbin/useradd
```

Kemudian:

```bash
useradd -m -G sudo -s /bin/bash userdebian
passwd userdebian
```

---

Jika Kita mengalami beberapa kali masalah PATH mungkin seperti (`grub-install`, `update-grub` berada di `/usr/sbin`). Ada kemungkinan `useradd` sebenarnya ada, tetapi direktori `/usr/sbin` belum masuk PATH root pada chroot tersebut. Coba periksa [disini][1]

* **Locale & Waktu:**
```bash
dpkg-reconfigure locales
# (Pilih en_US.UTF-8 dan id_ID.UTF-8 jika diperlukan)

dpkg-reconfigure tzdata
# (Pilih Asia -> Jakarta)
```
---

##### Langkah 5: Keluar dan Membersihkan Mount

Setelah semua paket terinstal dan layanan telah diaktifkan, Kita harus keluar dari lingkungan chroot dan melakukan *unmount* pada direktori Arch Linux Kita secara bersih.

1. Keluar dari lingkungan chroot Debian:
```bash
exit
```

2. Di terminal Arch Linux Kita, lepaskan kaitan (*unmount*) filesystem virtual secara berurutan:
```bash
sudo umount /mnt/dev/pts
sudo umount /mnt/dev
sudo umount /mnt/proc
sudo umount /mnt/sys
```

---

### Hasil Akhir: Panduan Penggunaan di Debian Setelah Booting

Ketika Kita menyalakan laptop dan masuk ke OS Debian Minimal Kita, semua utilitas berbasis CLI/TUI sudah siap digunakan dengan metode berikut:

#### A. Menghubungkan ke Internet menggunakan `iwctl`

Cukup ketik perintah ini di terminal Debian Kita untuk membuka prompt interaktif `iwd`:

```bash
iwctl

```

Di dalam prompt interaktif `[iwd]#`, jalankan perintah berikut:

```text
device list                            (Melihat nama interface Wi-Fi Kita, biasanya wlan0)
station wlan0 scan                     (Melakukan pemindaian jaringan Wi-Fi sekitar)
station wlan0 get-networks             (Menampilkan daftar SSID/Nama Wi-Fi yang tersedia)
station wlan0 connect "Nama_WiFi_Kita"  (Menghubungkan ke Wi-Fi, lalu masukkan password jika diminta)
exit                                   (Keluar dari prompt iwd)

```

*Karena fitur `EnableNetworkConfiguration=true` sudah diaktifkan, `iwd` akan otomatis melakukan proses DHCP di latar belakang sehingga Kita langsung terhubung ke internet tanpa membutuhkan dhcpcd.*

#### B. Menghubungkan Perangkat Bluetooth menggunakan `bluetoothctl`

Ketik perintah ini di terminal Debian Kita untuk mengelola Bluetooth:

```bash
bluetoothctl

```

Di dalam prompt interaktif `[bluetooth]#`, jalankan perintah ini:

```text
power on           (Menyalakan modul Bluetooth)
agent on           (Mengaktifkan agen pairing)
default-agent      (Mengatur agen default)
scan on            (Mencari perangkat terdekat, catat MAC Address perangkat Kita)
pair MAC_ADDRESS   (Melakukan paring, ganti MAC_ADDRESS dengan alamat perangkat Kita)
connect MAC_ADDRESS (Menghubungkan perangkat Bluetooth Kita)
exit               (Keluar dari bluetoothctl)

```

Sistem Debian minimal Kita kini telah sepenuhnya mandiri, memiliki fungsionalitas jaringan berbasis teks (`iwd`), dan siap digunakan untuk kebutuhan konektivitas harian.

## Fase 4: Menambahkan `tmpfs` dan hardisk khusus data

Bisa langsung ditambahkan ke `fstab` Debian, tetapi ada beberapa hal yang perlu dipahami terlebih dahulu dalam contoh berikut.

**1. Buat mount point**

Karena Debian minimal belum tentu memiliki direktori tersebut:

```bash
mkdir -p /srv/data
```

---

**Contoh semisal hasil akhir yang diinginkan**

```json
UUID=c1239153-f408-4172-8e29-011d89398e16 / ext4 rw,relatime 0 1

UUID=BC93-16D6 /boot/efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2

UUID=87c23d0d-5c7a-4d88-8a62-2a3e8381d4d8 none swap defaults 0 0

tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0

UUID=7281-0BBC /srv/data exfat defaults,nofail,x-systemd.device-timeout=10,uid=1000,gid=1000,umask=022 0 0
```

Setelah menyimpan:

```bash
sudo chroot /mnt/debian /bin/bash
mount -a
```

Jika tidak ada error, maka konfigurasi `fstab` sudah valid dan Debian akan otomatis memasang `/tmp` dan `/srv/data` saat boot.


**2. Mount `/tmp` sebagai tmpfs**

Entri:

```bash
tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
```

Artinya:

* `/tmp` berada di RAM (tmpfs).
* Isi `/tmp` hilang setelah reboot.
* Akses sangat cepat.
* Mirip perilaku `/tmp` pada banyak distro modern.

Tambahkan ke `/mnt/debian/etc/fstab`:

```fstab
tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
```

---

**3. Mount partisi data exFAT**

Partisi:

```text
/dev/sda1
UUID=7281-0BBC
```

Tambahkan:

```fstab
UUID=7281-0BBC /srv/data exfat defaults,nofail,x-systemd.device-timeout=10,uid=1000,gid=1000,umask=022 0 0
```

Tetapi ada satu hal penting.

Jika saat ini di Debian:

```text
userdebian
uid=1000
gid=1000
```

Maka:

```fstab
uid=1000,gid=1000
```

akan membuat seluruh isi `/srv/data` dimiliki oleh `userdebian`.

Jadi konfigurasi tersebut cocok digunakan juga di Debian.

---

**4. Pastikan driver exFAT terpasang**

Di Arch/Manjaro biasanya sudah ada.

Di Debian minimal hasil debootstrap sering belum ada.

Masuk chroot:

```bash
sudo chroot /mnt/debian /bin/bash
export PATH=$PATH:/usr/sbin:/sbin
```

Lalu:

```bash
apt install exfatprogs
```

Untuk kernel Linux 6.1 dalam contoh ini, driver exFAT sudah ada di kernel, jadi biasanya `exfatprogs` sudah cukup.

---

**5. Selesai di Sisi Debian**
Keluar dari environment chroot Debian:

```bash
exit

```

---

### Fase 5: Pendaftaran Bootloader (Melalui Manjaro)

Sesuai dengan skenario Kita, **Manjaro memegang kendali bootloader utama di `/dev/nvme0n1p3**`. Debian tidak perlu menginstal GRUB sendiri ke EFI karena akan ditangani oleh Manjaro.

1. Silakan **Reboot** laptop Kita dan masuk ke sistem **Manjaro** Kita seperti biasa.
2. Setelah masuk ke terminal Manjaro, pastikan fitur `os-prober` aktif agar GRUB Manjaro dapat mendeteksi distro lain (Debian). Buka file konfigurasi GRUB di Manjaro:
```bash
sudo nano /etc/default/grub

```


Pastikan baris berikut **tidak memiliki tanda pagar (#)** dan bernilai `false`:
```text
GRUB_DISABLE_OS_PROBER=false

```


3. Update bootloader GRUB Manjaro untuk melakukan scanning ulang pada seluruh partisi:
```bash
sudo update-grub

```


*(Atau `sudo grub-mkconfig -o /boot/grub/grub.cfg`)*

GRUB Manjaro akan mendeteksi kernel Debian baru di `/dev/nvme0n1p8`. Saat Kita melakukan restart berikutnya, menu GRUB Manjaro akan menampilkan opsi baru untuk masuk ke sistem **Debian GNU/Linux**.

---

#### Hasil yang sangat diinginkan. 🎯

Baris terpenting adalah:

```text
Ditemukan Debian GNU/Linux 12 (bookworm) pada /dev/nvme0n1p8
```

dan

```text
/dev/nvme0n1p8:Debian GNU/Linux 12 (bookworm):Debian:linux
```

Artinya:

1. `os-prober` berhasil mendeteksi Debian.
2. GRUB Manjaro berhasil mendeteksi Debian.
3. `grub-mkconfig` berhasil memasukkan entri Debian ke `/boot/grub/grub.cfg`.
4. Saat reboot nanti seharusnya menu Debian sudah muncul di GRUB Manjaro.

Gambaran struktur boot mungkin kurang lebih:

```text
UEFI
 ↓
EFI/manjaro/grubx64.efi
 ↓
GRUB Manjaro
 ├── Manjaro
 ├── Windows
 ├── Arch Linux
 └── Debian GNU/Linux 12
```

Coba jalankan berikut:
```bash
mount | grep efi
ls -l /boot/efi
ls /boot/efi/EFI

```
---

Harus muncul daftar OS yang terinstal seperti contoh:
```bash
Boot
Debian
Microsoft
manjaro
```

Sebelum reboot, disarankan memverifikasi bahwa entri Debian benar-benar masuk ke konfigurasi GRUB.

Jalankan:

```bash
grep -A20 -B5 "Debian GNU/Linux 12" /boot/grub/grub.cfg
```

atau

```bash
grep -A10 -B5 Debian /boot/grub/grub.cfg
```

Tampilkan hasilnya dalam contoh ini memastikan bahwa GRUB Manjaro mengarah ke UUID `c1239153-f408-4172-8e29-011d89398e16` (partisi Debian) dan bukan hanya chainload atau ke sesuatu yang tidak ada.

Cara Lain:

```bash
grep menuentry /boot/grub/grub.cfg | grep Debian
```

Jika muncul sesuatu seperti:

```bash
menuentry 'Debian GNU/Linux 12 (bookworm)'
```

maka konfigurasi GRUB sudah benar.

##### Dan Selamat Untuk Kita !

---

###### Halaman
[Daftar Masalah Umum Instalasi](./tabelmasalah.html)

<!-- Daftar Tautan -->

[1]: ./satu.md

