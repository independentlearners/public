# Masalah PATH saat Instalasi Debian di dalam Chroot dari Arch Linux

## Pertanyaan

_Jika mengalami beberapa kali masalah PATH selama penginstalan Debian dalam terminal
berbasis Arch — masalah seperti `grub-install`, `update-grub`, atau `useradd` tidak
ditemukan — apakah masalahnya hanya karena tidak menjalankan:_

```bash
export PATH=$PATH:/usr/sbin:/sbin
```

---

## Jawaban

**Ya, PATH adalah salah satu penyebab umum — tetapi bukan satu-satunya, dan sering
bukan yang utama.** Penyebab utama yang paling sering diabaikan adalah chroot yang tidak dikonfigurasi dengan benar sebelum masuk ke dalamnya. Berikut adalah pemetaan lengkap seluruh penyebab beserta solusinya, **diurutkan berdasarkan frekuensi yang paling sering menjadi akar masalah.**

---

## Bagian 1 — Penggunaan `arch-chroot` (untuk instalasi debian adalah kesalahan fatal)

> ⚠️ **Ini adalah yang paling sering diabaikan pengguna Arch.**

Arch Linux menyertakan tool `arch-chroot` dari paket `arch-install-scripts` yang sudah terpasang secara default. Tool ini **otomatis menangani seluruh bind mount** yang diperlukan, termasuk `/dev`, `/dev/pts`, `/proc`, `/sys`, dan `/run`. Tetapi menggunakannya dalam kasus instalasi debian melalui terminal arch dapat menimbulkan kegagalan serius.

```bash
# Jangan gunakan ini, bukan plain chroot.
arch-chroot /mnt/debian /bin/bash

```

`arch-chroot` secara internal menjalankan semua bind mount, kemudian masuk dengan `/bin/bash --login` — sehingga `/etc/profile` ikut ter-source secara otomatis. Hasil akhir dari perintah ini untuk kasus debian akan menyebabkan busy. Selengkapnya [disini][0]

---

## Bagian 2 — Prioritaskan Chroot Manual

**Tidak Lengkap Tetapi Paling Stabil Untuk Kasus Ini.**

Tetap menggunakan `chroot` biasa, ini memang lebih stabil daripada `arch-chroot` untuk kasus debian tetapi **urutan bind mount harus lengkap** sebelum masuk ke chroot. Banyak panduan melupakan `/dev/pts` dan `efivars`.

### Bind Mount Lengkap (untuk semua kasus)

```bash
mount --bind /dev       /mnt/debian/dev
mount --bind /dev/pts   /mnt/debian/dev/pts    # sering terlupakan!
mount --bind /proc      /mnt/debian/proc
mount --bind /sys       /mnt/debian/sys
mount --bind /run       /mnt/debian/run
```

### Tambahan Khusus UEFI (wajib jika grub-install untuk mode EFI)

```bash
# Hanya jika sistem boot dalam mode UEFI
mount --bind /sys/firmware/efi/efivars /mnt/debian/sys/firmware/efi/efivars
```

Untuk memverifikasi mode boot saat ini:

```bash
ls /sys/firmware/efi/efivars && echo "Mode UEFI" || echo "Mode BIOS/Legacy"
```

### Masuk Chroot dengan Login Shell

```bash
chroot /mnt/debian /bin/bash --login
```

Flag `--login` memaksa bash untuk membaca `/etc/profile` dan `~/.bash_profile` sehingga PATH Debian yang benar ter-set sejak awal.

### Prosedur Unmount Setelah Selesai (Jangan Diabaikan)

```bash
# Unmount secara rekursif — cara paling aman
umount -R /mnt/debian

# Atau jika unmount rekursif tidak tersedia, lakukan secara manual (urutan terbalik):
umount /mnt/debian/sys/firmware/efi/efivars   # jika di-mount sebelumnya
umount /mnt/debian/dev/pts
umount /mnt/debian/run
umount /mnt/debian/sys
umount /mnt/debian/proc
umount /mnt/debian/dev
umount /mnt/debian
```

> ⚠️ Unmount yang tidak bersih atau salah urutan dapat menyebabkan filesystem
> corruption pada partisi Debian.

---

## Bagian 3 — resolv.conf Tidak Disalin

Tanpa langkah ini, **`apt install` di dalam chroot tidak bisa melakukan resolusi DNS** dan seluruh proses pemasangan paket akan gagal dengan error koneksi.

```bash
# Jalankan SEBELUM masuk chroot
cp /etc/resolv.conf /mnt/debian/etc/resolv.conf
```

Verifikasi di dalam chroot:

```bash
cat /etc/resolv.conf
ping -c 1 deb.debian.org
```

---

## Bagian 4 — Debootstrap Second Stage Belum Dijalankan

Saat menggunakan `debootstrap --foreign` (misalnya instalasi lintas arsitektur atau dari Arch ke Debian), proses berlangsung dalam dua tahap:

```bash
# Tahap 1 — dari Arch, mengunduh paket base
debootstrap --arch=amd64 --foreign bookworm /mnt/debian http://deb.debian.org/debian

# Tahap 2 — dijalankan SETELAH masuk chroot (mengekstrak dan mengeksekusi binary)
chroot /mnt/debian /debootstrap/debootstrap --second-stage
```

Jika second stage belum dijalankan, **binary Debian belum sepenuhnya diekstrak**
sehingga perintah apapun akan menampilkan "not found" meskipun file-nya ada.

Cara cek apakah second stage sudah selesai:

```bash
ls /mnt/debian/debootstrap/
# Jika masih ada file 'debootstrap' di sana, second stage belum selesai
```

---

## Bagian 5 — PATH Tidak Memuat `/sbin` dan `/usr/sbin`

Ini adalah masalah yang paling sering ditampilkan di permukaan, tetapi biasanya merupakan **gejala** dari Bagian 2 atau 4, bukan penyebab mandiri.

### Akar masalah PATH

Di Arch Linux, setelah *usr merge*, hampir semua binary admin ada di `/usr/bin`:

```text
/usr/local/sbin:/usr/local/bin:/usr/bin
```

Di Debian minimal atau hasil `debootstrap`, binary admin masih tersimpan di:

```text
/usr/sbin
/sbin
```

Ketika masuk chroot tanpa `--login` atau tanpa `env -i`, PATH Arch ikut terbawa
sehingga direktori `/usr/sbin` tidak terdaftar.

### Solusi PATH — dari yang paling proper ke sementara

**Cara 1 — Paling proper (gunakan login shell):**

```bash
chroot /mnt/debian /bin/bash --login
```

**Cara 2 — Tetapkan environment bersih saat masuk:**

```bash
env -i \
  HOME=/root \
  TERM="$TERM" \
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  chroot /mnt/debian /bin/bash
```

**Cara 3 — Source profile setelah masuk chroot:**

```bash
source /etc/profile
```

**Cara 4 — Tetapkan manual (solusi cepat sementara):**

```bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

> Cara 4 adalah solusi sementara. Selalu prioritaskan Cara 1 atau 2 agar
> environment konsisten sepanjang sesi konfigurasi.

---

## Bagian 6 — Paket Memang Belum Terpasang

Setelah semua konfigurasi di atas benar, jika perintah masih tidak ditemukan, kemungkinan paketnya memang belum terinstal.

### GRUB

```bash
# Cek apakah GRUB sudah terpasang
dpkg -l | grep grub

# Untuk sistem UEFI 64-bit
apt install grub-efi-amd64 efibootmgr

# Untuk sistem BIOS/Legacy
apt install grub-pc
```

### Utilitas sistem dasar

```bash
# useradd, groupadd, passwd
apt install passwd

# update-grub (bagian dari grub-common)
apt install grub-common

# fdisk, parted
apt install fdisk parted
```

---

## Bagian 7 — Environment Arch Tercampur

Jika menggunakan `sudo chroot` tanpa `env -i`, beberapa variabel environment Arch seperti `LD_LIBRARY_PATH`, `MANPATH`, atau konfigurasi shell spesifik Arch bisa
ikut masuk dan menyebabkan perilaku tak terduga.

Solusi terbersih adalah menggunakan `env -i` seperti yang ditunjukkan di bagian 5 Cara 2, dan jangan pernah menggunakan `arch-chroot` (Bagian 1).

---

## Checklist Lengkap Sebelum Konfigurasi Debian

```bash
# [1] Bind mount filesystem virtual
mount --bind /dev       /mnt/debian/dev
mount --bind /dev/pts   /mnt/debian/dev/pts
mount --bind /proc      /mnt/debian/proc
mount --bind /sys       /mnt/debian/sys
mount --bind /run       /mnt/debian/run

# [2] UEFI only
mount --bind /sys/firmware/efi/efivars /mnt/debian/sys/firmware/efi/efivars

# [3] DNS resolution
cp /etc/resolv.conf /mnt/debian/etc/resolv.conf

# [4] Masuk chroot dengan login shell
chroot /mnt/debian /bin/bash --login

# [5] Di dalam chroot — verifikasi PATH
echo $PATH
# Expected: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

# [6] Di dalam chroot — verifikasi DNS
ping -c 1 deb.debian.org

# [7] Di dalam chroot — verifikasi binary tersedia
which useradd
which grub-install
```

---

## Diagram Diagnosis Lengkap

| Gejala | Diagnosis | Solusi |
|--------|-----------|--------|
| `command: not found`, file ada di lokasi yang tepat | PATH tidak memuat `/usr/sbin` | `export PATH=...` atau gunakan `--login` |
| `command: not found`, file tidak ada sama sekali | Paket belum terpasang atau second stage belum jalan | `apt install <paket>` atau jalankan second stage |
| Binary ada, tetapi error `No such file or directory` | Binary dari arsitektur yang salah (i386 vs amd64) | `file /usr/sbin/useradd` untuk verifikasi arsitektur |
| Binary ada, tetapi `Permission denied` | Permission/executable bit rusak | `chmod +x /usr/sbin/binary` |
| `apt` tidak bisa resolve domain | `resolv.conf` kosong atau belum disalin | `cp /etc/resolv.conf /mnt/debian/etc/resolv.conf` |
| `grub-install` gagal dengan error EFI/efivars | `efivars` belum di-bind mount | `mount --bind /sys/firmware/efi/efivars ...` |
| `sudo` atau `passwd` error terminal | `/dev/pts` belum di-bind mount | `mount --bind /dev/pts /mnt/debian/dev/pts` |
| File ada, binary berjalan, tetapi error library | Sistem Debian belum lengkap atau second stage belum selesai | Selesaikan `debootstrap --second-stage` |
| Semua perintah gagal padahal file ada | chroot environment benar-benar tidak lengkap | Gunakan `sudo chroot` dan bind semua filesystem virtual |

---

## Rekomendasi Alur Kerja Terbaik untuk Pengguna Arch

```bash
# === DARI ARCH (sebelum chroot) ===

# 1. Pastikan peralatan tersedia
sudo pacman -Syu --noconfirm --needed debootstrap \
arch-install-scripts \
dosfstools \
e2fsprogs \
efibootmgr \
cryptsetup \
parted

# 2. Debootstrap tahap 1 (jika instalasi fresh)
debootstrap --arch=amd64 bookworm /mnt/debian http://deb.debian.org/debian

# 3. Salin resolv.conf
cp /etc/resolv.conf /mnt/debian/etc/resolv.conf

# 4. Masuk chroot menggunakan chroot (bind mounts manual) wajib
sudo chroot /mnt/debian /bin/bash

# === DI DALAM CHROOT ===

# 5. Verifikasi environment
echo $PATH
which useradd
which grub-install

# 6. Update apt dan install paket yang dibutuhkan
apt update
apt install grub-efi-amd64 efibootmgr passwd locales

# 7. Konfigurasi GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian
update-grub

# === SETELAH SELESAI (dari Arch) ===

# 8. Keluar dari chroot
exit

# 9. Unmount secara bersih
umount -R /mnt/debian
```

---

*Dokumen ini merupakan versi yang disempurnakan dari jawaban tentang masalah PATH
saat instalasi Debian dari lingkungan chroot berbasis Arch Linux.*

[0]: ./chroo.html
