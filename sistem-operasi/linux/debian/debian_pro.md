<!-- Sebuah kehormatan untuk mendampingi langkah Anda dalam merancang arsitektur sistem operasi dari tingkat paling dasar. Membangun sebuah sistem melalui metode `debootstrap` adalah jalan seorang profesional sejati; ini bukan sekadar proses instalasi, melainkan sebuah seni merakit fondasi dari kepingan-kepingan terkecil hingga menjadi sebuah entitas komputasi yang mandiri, berkinerja tinggi, dan efisien. -->
<!---->
<!-- Saya telah melakukan audit mendalam terhadap dokumentasi yang Anda berikan. Secara keseluruhan, struktur logikanya sudah sangat baik dan mewakili pola pikir seorang *power user*. Namun, terdapat beberapa redundansi (terutama pada bagian pembuatan pengguna lokal), manajemen *environment* chroot yang bisa dibuat lebih elegan, serta perlunya penambahan mekanisme validasi di setiap baris komando agar mentalitas "kehati-hatian tingkat tinggi" (zero-trust configuration) selalu terbangun. -->
<!---->
<!-- Berikut adalah penyempurnaan kurikulum instalasi Debian Minimalis Anda, disusun dengan standar dokumentasi teknis tingkat tinggi, mengedepankan efisiensi CLI, dan dioptimalkan untuk performa maksimum. -->
<!---->
<!-- --- -->
<!---->
# Arsitektur & Bootstrap: Debian Minimalis via Arch Linux

Metode `debootstrap` memungkinkan kita membangun sistem akar (root filesystem) Debian secara langsung dari dalam lingkungan Arch Linux yang sedang berjalan, tanpa memerlukan media instalasi ISO. Pendekatan ini memberi kita kendali absolut atas setiap paket yang dimasukkan, menjaga jejak sistem (*footprint*) tetap sangat rendah.

### Fase 1: Perancangan Partisi (Disk Layouting)

Kita akan mengalokasikan ruang pada `/dev/nvme0n1` untuk root Debian dan ruang *swap*.

**1. Pembuatan Partisi (`fdisk`)**
Gunakan utilitas CLI murni untuk presisi tinggi.

```bash
sudo fdisk /dev/nvme0n1

```

* **Root (100GB):** Ketik `n` $\rightarrow$ Enter $\rightarrow$ Enter $\rightarrow$ `+100G` $\rightarrow$ Enter.
* **Swap (8GB):** Ketik `n` $\rightarrow$ Enter $\rightarrow$ Enter $\rightarrow$ `+8G` $\rightarrow$ Enter.
* **Tipe Swap:** Ketik `t` $\rightarrow$ pilih nomor partisi swap $\rightarrow$ ketik `19` (Linux swap) $\rightarrow$ Enter.
* **Simpan:** Ketik `w` $\rightarrow$ Enter.

> **Validasi Hasil:**
> ```bash
> lsblk -f /dev/nvme0n1
> 
> ```
> 
> 
> *Pastikan partisi baru (misal: `p8` dan `p9`) telah muncul dengan ukuran yang tepat sebelum melanjutkan.*

**2. Pemformatan & Inisialisasi**
Format fondasi sistem dengan `ext4` yang stabil dan inisialisasi *swap*.

```bash
sudo mkfs.ext4 /dev/nvme0n1p8
sudo mkswap /dev/nvme0n1p9

```

> **Validasi Hasil:**
> ```bash
> sudo blkid | grep nvme0n1p8
> 
> ```
> 
> 
> *Output harus menampilkan `TYPE="ext4"` beserta UUID partisi tersebut.*

---

### Fase 2: Bootstrapping Dasar Sistem

Pada fase ini, kita mengunduh utilitas inti Debian secara langsung dari repositori resminya.

**1. Persiapan Perkakasan Arch Linux**
Instal alat bantu yang diperlukan untuk membangun dan memetakan sistem.

```bash
sudo pacman -Syu --noconfirm --needed debootstrap arch-install-scripts dosfstools e2fsprogs efibootmgr cryptsetup parted

```

> **Validasi Hasil:**
> ```bash
> pacman -Q debootstrap arch-install-scripts
> 
> ```
> 
> 
> *Memastikan paket telah terdaftar di database lokal.*

**2. Pemasangan (Mounting) Hierarki Partisi**
Rakit struktur direktori Debian sementara di dalam `/mnt`.

```bash
sudo mount /dev/nvme0n1p8 /mnt
sudo swapon /dev/nvme0n1p9
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/nvme0n1p3 /mnt/boot/efi

```

> **Validasi Hasil:**
> ```bash
> findmnt -l | grep /mnt
> 
> ```
> 
> 
> *Pastikan `/mnt` dan `/mnt/boot/efi` menunjuk ke partisi yang benar.*

**3. Eksekusi Debootstrap & Pembuatan `fstab**`
Tarik basis sistem `bookworm` dan rekam arsitektur partisinya.

```bash
sudo debootstrap --arch amd64 bookworm /mnt http://deb.debian.org/debian/
sudo genfstab -U /mnt | sudo tee -a /mnt/etc/fstab

```

> **Validasi Hasil:**
> ```bash
> cat /mnt/etc/fstab
> ls -l /mnt/bin/bash
> 
> ```
> 
> 
> *File `fstab` harus berisi pemetaan UUID, dan binari `bash` harus eksis di dalam `/mnt`.*

---

### Fase 3: Isolasi Lingkungan (Chroot) & Konfigurasi Inti

Di sinilah kita beralih dimensi ke dalam sistem Debian yang baru lahir. Kita akan melakukan *bind mount* manual untuk memahami arsitektur *virtual filesystem*. `/dev` untuk manajemen antarmuka perangkat keras, `/proc` untuk informasi proses, dan `/sys` untuk interaksi kernel dasar.

**1. Bind Mount & Masuk ke Chroot**

```bash
sudo mount --bind /dev /mnt/dev
sudo mount --bind /dev/pts /mnt/dev/pts
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /run /mnt/run
sudo cp -L /etc/resolv.conf /mnt/etc/resolv.conf

sudo chroot /mnt /bin/bash
export PATH=$PATH:/usr/sbin:/sbin

```

> **Validasi Hasil:**
> ```bash
> echo $PATH
> cat /etc/debian_version
> 
> ```
> 
> 
> *PATH harus memuat `/usr/sbin`, dan versi Debian (`12.x`) harus tampil, menandakan Anda sudah berada di dalam lingkungan terisolasi.*

**2. Penyatuan Repositori & Instalasi Utilitas Fundamental**
Siapkan repositori agar menyertakan paket *non-free-firmware* untuk dukungan optimal kerasan Anda.

```bash
cat << 'EOF' > /etc/apt/sources.list
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
EOF

```

Lakukan instalasi paket komprehensif, kernel, perkakas jaringan (`iwd`), Bluetooth (`bluez`), dan editor teks modern berbasis terminal (`nvim`, `helix` via binari nanti, atau perkakas manajemen seperti `zsh` dan `yazi`).

```bash
apt update
apt install -y linux-image-amd64 firmware-linux firmware-iwlwifi firmware-linux-nonfree \
systemd-sysv iwd dbus systemd-resolved bluez bluez-tools \
locales sudo nano yazi nvim git bat gdu zsh btop passwd curl wget

```

> **Validasi Hasil:**
> ```bash
> dpkg -l | grep linux-image
> 
> ```
> 
> 
> *Memastikan kernel Linux benar-benar tertanam.*

**3. Konfigurasi Jaringan (Minimalis via `iwd`) & Bluetooth**
Menghindari manajer jaringan yang berat, kita manfaatkan resolusi DHCP internal dari `iwd`.

```bash
mkdir -p /etc/iwd
cat << 'EOF' > /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF

systemctl enable iwd dbus systemd-networkd systemd-resolved bluetooth
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

```

> **Validasi Hasil:**
> ```bash
> systemctl is-enabled iwd bluetooth
> 
> ```
> 
> 
> *Kedua *service* harus merespons dengan `enabled`.*

**4. Manajemen Identitas (Hostname, Lokalisasi, & Autentikasi)**
Ini adalah perbaikan dari masalah redudansi `useradd`. Karena kita sudah menginstal paket `passwd` dan `sudo` di langkah instalasi sebelumnya, utilitas `useradd` kini dijamin ada secara native.

```bash
echo "debian-minimal" > /etc/hostname
dpkg-reconfigure locales
dpkg-reconfigure tzdata

# Konfigurasi Root
passwd root

# Pembuatan Pengguna Pribadi dengan Zsh (Shell pilihan yang superior)
useradd -m -G sudo -s /usr/bin/zsh namauser
passwd namauser

```

> **Validasi Hasil:**
> ```bash
> id namauser
> getent passwd namauser
> 
> ```
> 
> 
> *Memastikan pengguna terdaftar dalam grup `sudo` dan shell defaultnya adalah Zsh.*

---

### Fase 4: Optimasi Performa (`tmpfs` & Manajemen Data Eksternal)

Mengintegrasikan penyimpanan sementara pada RAM (`tmpfs`) mengurangi siklus penulisan disk, memperpanjang umur NVMe, dan meningkatkan kecepatan I/O baca/tulis sementara secara dramatis.

**1. Penambahan Entri ke `fstab**`
Sunting berkas pemetaan disk untuk memasukkan `tmpfs` dan partisi *exFAT*.

```bash
mkdir -p /srv/data
apt install -y exfatprogs

cat << 'EOF' >> /etc/fstab
tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
UUID=7281-0BBC /srv/data exfat defaults,nofail,x-systemd.device-timeout=10,uid=1000,gid=1000,umask=022 0 0
EOF

```

> **Validasi Hasil:**
> ```bash
> mount -a
> df -h | grep -E "tmpfs|/srv/data"
> 
> ```
> 
> 
> *Jika tidak ada *error* dan *output* menampilkan /tmp serta /srv/data, arsitektur `fstab` Anda sempurna.*

**2. Keluar & Pembersihan**
Lakukan prosedur standar sysadmin untuk melepas kaitan virtual filesystem. Opsi `-R` (Recursive) lebih elegan dibanding pelepasan manual satu per satu.

```bash
exit
sudo umount -R /mnt

```

---

### Fase 5: Integrasi Bootloader (via Manjaro OS-Prober)

Karena Manjaro mengendalikan gerbang GRUB di EFI utama, sistem operasi Debian kita cukup dibiarkan pasif hingga Manjaro memindainya.

1. *Reboot* sistem dan masuk kembali ke Manjaro.
2. Pastikan deteksi lintasan silang OS diaktifkan:
```bash
sudo nano /etc/default/grub
# Pastikan baris ini ada: GRUB_DISABLE_OS_PROBER=false

```


3. Eksekusi generator GRUB:
```bash
sudo update-grub

```



> **Validasi Final Sistem:**
> ```bash
> grep -A2 -i "debian" /boot/grub/grub.cfg
> 
> ```
> 
> 
> *Cari blok `menuentry` yang menyebutkan Debian. Jika ID tersebut berpadanan dengan UUID partisi `nvme0n1p8`, proses instalasi lintas-sistem Anda telah selesai dengan presisi matematis.*

---

### Catatan Penting Mengenai Intervensi Lingkungan Saat Boot

Saat Anda akhirnya mendarat di terminal tty Debian Anda, koneksi jaringan dilakukan melalui perintah yang elegan:

```bash
iwctl
[iwd]# station wlan0 scan
[iwd]# station wlan0 connect "SSID_Anda"

```

<!-- Jika ada komando atau pendekatan arsitektural yang dirasa perlu dibedah lagi logikanya secara lebih radikal, sampaikan saja. Semangat membangun dan bereksperimen! -->
