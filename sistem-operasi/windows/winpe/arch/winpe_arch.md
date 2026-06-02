# WinPE Internal pada Manjaro Linux
## Panduan Teknis Komprehensif — Berbasis Kasus Nyata

> **Tentang Dokumen Ini**
> Seluruh perintah, output, kesalahan, dan koreksi dalam dokumen ini diambil dari sesi terminal nyata pada sistem yang berhasil menyelesaikan proses secara penuh. Setiap kesalahan yang terjadi selama proses didokumentasikan bersama analisis penyebabnya agar pembaca dapat menghindari jebakan yang sama.

---

## Daftar Isi

```
Bagian 1  — Arsitektur, Konsep Dasar, dan Tujuan
Bagian 2  — Persyaratan Sistem, Paket, dan Media
Bagian 3  — Analisis Disk dan Pemilihan Partisi
Bagian 4  — Persiapan Partisi FAT32
Bagian 5  — Mount ISO Windows dan Verifikasi Struktur
Bagian 6  — Pembuatan WinPE Minimal
             → Analisis Kesalahan Nyata: rsync -avh pada FAT32
             → Solusi: rsync --no-owner --no-group
Bagian 7  — Pembuatan WinPE Installer Penuh
             → Batasan FAT32 dan install.wim
             → Analisis Kesalahan: wimlib-imaex (typo)
             → Split WIM dengan wimlib-imagex
Bagian 8  — Integrasi dengan GRUB (Chainloading)
Bagian 9  — Entry UEFI Langsung via efibootmgr
             → Analisis Kesalahan: --part X (invalid numeric value)
Bagian 10 — Konversi ke ISO Bootable dan Integrasi Ventoy
Bagian 11 — Pemeliharaan dan Pembaruan WinPE
Bagian 12 — Kustomisasi WinPE Lanjutan
Bagian 13 — Troubleshooting Sistematis dan Referensi Kesalahan Nyata
Bagian 14 — Referensi Arsitektur dan Teknologi
```

---

# Bagian 1 — Arsitektur, Konsep Dasar, dan Tujuan

## Apa Itu WinPE?

WinPE (Windows Preinstallation Environment) adalah sistem operasi Windows minimal yang dirancang untuk berjalan langsung dari RAM. WinPE bukan Windows penuh — ia tidak memiliki desktop normal, Store, atau driver lengkap. Namun ia memiliki semua yang dibutuhkan untuk:

- Recovery sistem Windows
- Instalasi Windows baru
- Deployment image ke banyak mesin
- Perbaikan bootloader
- Backup dan restore disk
- Troubleshooting tingkat rendah

## Hubungan WinPE dengan ISO Windows

ISO Windows standar sudah mengandung WinPE secara internal. Strukturnya:

```
Win11_24H2_English_x64.iso
├── autorun.inf
├── bootmgr
├── bootmgr.efi
├── setup.exe
├── boot/
├── efi/
└── sources/
    ├── boot.wim      ← INI adalah WinPE
    └── install.wim   ← INI adalah Windows yang akan dipasang
```

`boot.wim` adalah image WinPE yang dimuat ke RAM saat boot. `install.wim` adalah image sistem Windows yang akan disalin ke disk saat instalasi. Keduanya adalah hal yang berbeda.

## Alur Boot WinPE

```
Firmware UEFI
      ↓
Boot Manager (grubx64.efi atau bootx64.efi)
      ↓
BCD (Boot Configuration Data)
      ↓
boot.wim dimuat ke RAM
      ↓
Windows PE berjalan
      ↓  [jika installer penuh]
Windows Setup menemukan install.swm/install.wim
      ↓
Windows diinstal ke disk
```

## WinPE Minimal vs WinPE Installer Penuh

| Aspek | WinPE Minimal | WinPE Installer Penuh |
|---|---|---|
| File utama | `boot.wim` | `boot.wim` + `install.swm` |
| Ukuran | ~500 MB – 1.5 GB | ~5–8 GB |
| Recovery & CMD | ✅ | ✅ |
| Instalasi Windows | ❌ | ✅ |

## Tujuan Dokumentasi Ini

Membangun WinPE Internal yang tersimpan di partisi NVMe terpisah, dapat diakses dari:

1. **GRUB** — Chainloading dari menu boot Manjaro
2. **UEFI Firmware** — Entry langsung di NVRAM
3. **ISO Portabel** — Dapat dijalankan dari Ventoy atau komputer lain

Sistem nyata yang digunakan selama proses:

```text
Distribusi  : Manjaro Linux
Bootloader  : GRUB
Firmware    : UEFI
Tabel Part. : GPT
Storage     : NVMe SSD (nvme0n1)
Partisi WinPE: /dev/nvme0n1p7 (FAT32, 8 GB)
```

## Mengapa Tidak Menggunakan Flashdisk?

Partisi internal memiliki keunggulan signifikan:
- **Selalu tersedia** — tidak perlu flashdisk terlepas
- **Boot lebih cepat** — NVMe jauh lebih cepat dari USB
- **Aman** — partisi terpisah tidak mengganggu Windows maupun Linux
- **Dapat dijadikan ISO kapan saja** — untuk dipindahkan ke perangkat lain

---

# Bagian 2 — Persyaratan Sistem, Paket, dan Media

## Persyaratan Sistem

Dokumentasi ini dirancang untuk:

```text
Linux (Arch, Manjaro, EndeavourOS, CachyOS, atau turunannya)
Firmware UEFI (bukan Legacy BIOS)
GPT Partition Table (bukan MBR)
```

Verifikasi firmware:
```bash
test -d /sys/firmware/efi && echo "UEFI — OK" || echo "Legacy BIOS — Tidak Kompatibel"
```

Verifikasi tabel partisi:
```bash
sudo fdisk -l | grep "Disklabel type"
# Harus: Disklabel type: gpt
```

## Persyaratan Paket

Install seluruh dependensi berikut:

```bash
sudo pacman -S --needed \
  dosfstools \
  wimlib \
  7zip \
  grub \
  efibootmgr \
  mtools \
  ntfs-3g \
  xorriso \
  tree
```

Verifikasi instalasi:
```bash
for pkg in dosfstools wimlib 7zip grub efibootmgr xorriso; do
    pacman -Q $pkg && echo "OK: $pkg" || echo "HILANG: $pkg"
done
```

Fungsi masing-masing paket:

| Paket | Fungsi dalam Proyek |
|---|---|
| `dosfstools` | `mkfs.fat -F32` — format partisi FAT32 |
| `wimlib` | `wimlib-imagex split` — memecah install.wim |
| `7zip` | Memeriksa dan mengekstrak isi ISO |
| `grub` | Chainloading WinPE dari menu boot |
| `efibootmgr` | Membuat entry WinPE di NVRAM UEFI |
| `xorriso` | Membuat ISO bootable dari partisi WinPE |
| `mtools` | Operasi filesystem FAT tanpa mount |

## Persyaratan Media

1. **ISO Windows** — Windows 10 atau Windows 11:
   ```text
   Win11_24H2_English_x64.iso  (~6.2 GB)
   Win10_22H2_English_x64v1.iso
   ```

2. **Partisi FAT32 kosong** — minimal 8 GB untuk installer penuh:
   ```text
   Partisi nyata yang digunakan: /dev/nvme0n1p7 (8 GB, FAT32)
   ```

> ⚠️ **Penting**: Jika partisi belum berformat FAT32, akan diformat pada Bagian 4. Pastikan tidak ada data penting di dalamnya sebelum melanjutkan.

---

# Bagian 3 — Analisis Disk dan Pemilihan Partisi

## Output Aktual `lsblk -f`

Output berikut diambil dari sistem nyata sebelum proses dimulai:

```text
NAME                                          FSTYPE      FSVER LABEL                   UUID                 FSAVAIL FSUSE% MOUNTPOINTS
loop0                                         udf         1.02  CCCOMA_X64FRE_EN-US_DV9 e1cf40004d532055           0   100% /mnt/winiso
sda
└─sda1                                        exfat       1.0   data                    7281-0BBC             769,2G    17% /srv/data
sdb
├─sdb1                                        exfat       1.0   Ventoy                  7211-5F23              22,1G    24% /run/media/superuser/Ventoy
└─sdb2                                        vfat        FAT16 VTOYEFI                 EA6C-95B2               4,5M    86% /run/media/superuser/VTOYEFI
nvme0n1
├─nvme0n1p1                                   ntfs                                      ECA2E689A2E6581A
├─nvme0n1p2                                   crypto_LUKS 1                             d68f7470-...
│ └─luks-d68f7470-...                         ext4        1.0   manjaroot               bbb72ffe-...     94,3G    31% /
├─nvme0n1p3                                   vfat        FAT32 EFIBOOT                 BC93-16D6            987,9M     3% /boot/efi
├─nvme0n1p4                                   crypto_LUKS 1                             1d5212de-...
│ └─luks-1d5212de-...                         swap        1     manjaswap               e8a064c1-...             [SWAP]
├─nvme0n1p5                                   ext4        1.0                           6a72ac8a-...
├─nvme0n1p6                                   swap        1                             2783fd51-...
└─nvme0n1p7                                   vfat        FAT32                         5F77-3B4B           7,4G     7% /mnt/winpe
```

## Analisis Partisi Kritis

**`nvme0n1p3` — EFI System Partition**
```text
Label : EFIBOOT
FS    : FAT32
Mount : /boot/efi
Isi   : EFI/Microsoft/, EFI/Manjaro/
```
Ini adalah partisi boot kritis bersama. JANGAN meletakkan WinPE di sini. Kesalahan dapat menyebabkan Windows dan Manjaro keduanya tidak dapat boot.

**`nvme0n1p7` — Target WinPE**
```text
UUID  : 5F77-3B4B
FS    : FAT32
Size  : 8.0 GB
```
Partisi ini dipilih sebagai media WinPE karena: kosong, sudah FAT32, terpisah dari EFI utama, dan ukurannya mencukupi untuk installer penuh.

## Mengapa FAT32?

UEFI Specification (UEFI 2.x) mewajibkan firmware mendukung FAT12, FAT16, dan FAT32. Hampir semua firmware boot menggunakan FAT32. Ini bukan pilihan teknis — ini **syarat** UEFI.

Namun FAT32 memiliki satu batasan kritis yang akan menjadi masalah utama:

> **Maksimum ukuran satu file pada FAT32: 4 GiB − 1 byte (≈ 4.29 GB)**

File `install.wim` dari ISO Windows 11 modern berukuran **4.7 GB** — melampaui batas ini. Ini adalah sumber masalah pertama yang akan kita hadapi dan selesaikan di Bagian 7.

---

# Bagian 4 — Persiapan Partisi FAT32

## Membuat Mount Point

```bash
sudo mkdir -p /mnt/winpe
```

## Format Partisi (Jika Diperlukan)

Jika partisi belum FAT32, atau jika perlu dimulai dari kondisi bersih (clean slate), format sekarang:

```bash
sudo mkfs.fat -F32 /dev/nvme0n1p7
```

Output yang diharapkan:
```text
mkfs.fat 4.2 (2021-01-31)
```

> **Kapan harus format ulang?** Jika pada tahap berikutnya terjadi kesalahan yang mengotori partisi (seperti partial copy, interrupted transfer), solusi paling bersih adalah unmount → format ulang → remount → ulangi. Ini terbukti lebih efisien daripada mencoba membersihkan file satu per satu.

## Mount Partisi

```bash
sudo mount /dev/nvme0n1p7 /mnt/winpe
```

Verifikasi:
```bash
findmnt /mnt/winpe
# TARGET     SOURCE         FSTYPE OPTIONS
# /mnt/winpe /dev/nvme0n1p7 vfat   rw,relatime,...
```

```bash
df -h /mnt/winpe
# Sistem Berkas  Besar   Isi  Sisa Isi% Dipasang di
# /dev/nvme0n1p7  8,0G  4,0K  8,0G   1% /mnt/winpe
```

Catat UUID partisi untuk digunakan pada konfigurasi GRUB:
```bash
lsblk -f /dev/nvme0n1p7
# nvme0n1p7 vfat FAT32 5F77-3B4B 7,4G 7% /mnt/winpe
```
**UUID sistem nyata: `5F77-3B4B`** — nilai ini akan digunakan berulang kali.

---

# Bagian 5 — Mount ISO Windows dan Verifikasi Struktur

## Mount ISO sebagai Loop Device

```bash
sudo mkdir -p /mnt/winiso

sudo mount -o loop \
  "/srv/data/OS/Win11_24H2_English_x64.iso" \
  /mnt/winiso
```

Output yang diharapkan:
```text
mount: /mnt/winiso: WARNING: source write-protected, mounted read-only.
```

Pesan `WARNING: source write-protected` adalah **normal** — ISO memang bersifat read-only. Ini bukan error.

Verifikasi struktur ISO:
```bash
ls /mnt/winiso
# autorun.inf  boot  bootmgr  bootmgr.efi  efi  setup.exe  sources  support
```

Verifikasi file-file kritis ada:
```bash
ls -lh /mnt/winiso/sources/boot.wim /mnt/winiso/sources/install.wim
# -r-xr-xr-x 1 nobody nobody 652M ... sources/boot.wim
# -r-xr-xr-x 1 nobody nobody 4,7G ... sources/install.wim
```

> **Penting**: Ukuran `install.wim` sebesar 4.7 GB melebihi batas FAT32 (4 GB). File ini **tidak dapat** disalin langsung ke partisi FAT32. Penanganannya akan dijelaskan di Bagian 7.

---

# Bagian 6 — Pembuatan WinPE Minimal

## Struktur Target

Setelah tahap ini selesai, `mnt/winpe` harus berisi:

```text
/mnt/winpe
├── boot/
│   ├── bcd
│   ├── boot.sdi
│   ├── bootfix.bin
│   ├── fonts/
│   └── resources/
├── bootmgr
├── efi/
│   ├── boot/
│   │   └── bootx64.efi   ← EFI loader utama
│   └── microsoft/
│       └── boot/
│           ├── bcd
│           └── ...
└── sources/
    └── boot.wim          ← WinPE image
```

Ini adalah konfigurasi WinPE Minimal — cukup untuk recovery, CMD, diskpart, dan deployment dasar. Belum dapat menginstal Windows.

---

## ⚠️ Analisis Kesalahan Nyata: rsync -avh pada FAT32

Pada percobaan pertama, perintah berikut dijalankan:

```bash
# PERCOBAAN PERTAMA — SALAH
sudo rsync -avh \
  /mnt/winiso/boot \
  /mnt/winiso/efi \
  /mnt/winiso/sources \
  /mnt/winiso/bootmgr \
  /mnt/winpe/
```

**Flag `-a` (archive)** adalah kombinasi dari `-rlptgoD`, yang termasuk `-p` (preserve permissions), `-g` (preserve group), dan `-o` (preserve owner). Pada FAT32, operasi `chown` tidak didukung sama sekali.

Akibatnya, ribuan error seperti ini muncul:
```text
rsync: [generator] chown "/mnt/winpe/boot" failed: Operation not permitted (1)
rsync: [generator] chown "/mnt/winpe/boot/en-us" failed: Operation not permitted (1)
rsync: [generator] chown "/mnt/winpe/efi" failed: Operation not permitted (1)
rsync: [receiver] chown "/mnt/winpe/.bootmgr.gWdDZO" failed: Operation not permitted (1)
...
```

Dan karena `sources/` ikut disertakan dalam argumen rsync, install.wim (4.7 GB) juga dicoba disalin, menghasilkan:
```text
rsync: [receiver] write failed on "/mnt/winpe/sources/install.wim": File too large (27)
rsync error: error in file IO (code 11) at receiver.c(401) [receiver=3.4.3]
rsync: [sender] write error: Broken pipe (32)
```

**Percobaan kedua dilakukan sebagai root (`sudo -i`)** — hasilnya identik. Error bukan masalah privilege, melainkan ketidakcocokan tipe filesystem.

Setelah dua kali percobaan gagal, partisi dalam kondisi kotor (partial copy):
```bash
du -sh /mnt/winpe
# 582M    /mnt/winpe  ← terdapat file parsial yang tidak lengkap
```

Meski banyak file berhasil tersalin, `install.wim` gagal sempurna dan sources directory dalam kondisi tidak valid. Lanjut dengan keadaan ini berbahaya.

**Solusi: format ulang dan mulai bersih.**

```bash
sudo umount /mnt/winpe
sudo mkfs.fat -F32 /dev/nvme0n1p7
sudo mount /dev/nvme0n1p7 /mnt/winpe
```

---

## Perintah rsync yang Benar

Kunci perbaikan: gunakan `--no-owner --no-group` dan **jangan sertakan direktori `sources/`** dalam argumen rsync (sources ditangani secara terpisah).

```bash
sudo rsync -rltDvh \
  --no-owner \
  --no-group \
  /mnt/winiso/boot \
  /mnt/winiso/efi \
  /mnt/winiso/bootmgr \
  /mnt/winpe/
```

**Penjelasan flag:**

| Flag | Fungsi |
|---|---|
| `-r` | Rekursif (traverse subdirektori) |
| `-l` | Salin symbolic links sebagai links |
| `-t` | Preserve timestamps |
| `-D` | Preserve device files dan special files |
| `-v` | Verbose output |
| `-h` | Human-readable sizes |
| `--no-owner` | Jangan coba set ownership (kritis untuk FAT32) |
| `--no-group` | Jangan coba set group (kritis untuk FAT32) |

Output yang benar — bersih tanpa error:
```text
sending incremental file list
bootmgr
boot/
boot/bcd
boot/boot.sdi
boot/bootfix.bin
boot/bootsect.exe
boot/etfsboot.com
boot/memtest.exe
boot/en-us/
boot/en-us/bootsect.exe.mui
boot/fonts/
boot/fonts/chs_boot.ttf
...
efi/
efi/boot/
efi/boot/bootx64.efi
efi/microsoft/
efi/microsoft/boot/
efi/microsoft/boot/bcd
...

sent 44,41M bytes  received 1,32K bytes  88,82M bytes/sec
total size is 44,39M  speedup is 1,00
```

Tidak ada baris `chown failed`, tidak ada `File too large`. Transfer bersih sempurna.

## Membuat Direktori Sources dan Menyalin boot.wim

```bash
sudo mkdir -p /mnt/winpe/sources

sudo cp \
  /mnt/winiso/sources/boot.wim \
  /mnt/winpe/sources/
```

Verifikasi:
```bash
ls -lh /mnt/winpe/sources/boot.wim
# -rwxr-xr-x 1 root root 652M ... boot.wim

find /mnt/winpe -iname bootx64.efi
# /mnt/winpe/efi/boot/bootx64.efi
```

Kedua file kritis di atas **harus ada** sebelum lanjut. Jika `bootx64.efi` tidak ditemukan, WinPE tidak akan pernah bisa boot.

---

# Bagian 7 — Pembuatan WinPE Installer Penuh

## Batasan FAT32 dan Realita install.wim

```bash
ls -lh /mnt/winiso/sources/install.wim
# -r-xr-xr-x 1 nobody nobody 4,7G Sep 6 2024 install.wim
```

FAT32 hanya mendukung maksimum **4 GiB − 1 byte** per file. File `install.wim` sebesar 4.7 GB tidak dapat disalin langsung ke FAT32 dalam bentuk apapun.

Jika dipaksa, hasilnya:
```text
rsync error: error in file IO (code 11) ...
File too large (27)
```

Solusinya adalah **Split WIM** — memecah `install.wim` menjadi beberapa bagian yang masing-masing di bawah batas FAT32.

---

## ⚠️ Analisis Kesalahan Nyata: Typo `wimlib-imaex`

Pada percobaan pertama, terjadi typo pada nama perintah:

```bash
# SALAH — typo pada nama binary
sudo wimlib-imaex split \
  /mnt/winiso/sources/install.wim \
  /mnt/winpe/sources/install.swm 3500
```

Output:
```text
sudo: wimlib-imaex: perintah tidak ditemukan
```

Nama binary yang benar adalah **`wimlib-imagex`** (dengan `g` sebelum `e`). Perbedaan satu huruf ini mudah terlewat saat mengetik cepat.

---

## Perintah Split WIM yang Benar

```bash
sudo wimlib-imagex split \
  /mnt/winiso/sources/install.wim \
  /mnt/winpe/sources/install.swm \
  3500
```

**Penjelasan parameter:**
- `split` — subcommand untuk memecah WIM
- Argumen ke-1 — path WIM sumber (dari ISO, read-only)
- Argumen ke-2 — path output bagian pertama (ekstensi `.swm`)
- `3500` — ukuran maksimum tiap bagian dalam **megabyte** (3500 MB = ~3.4 GB, di bawah batas FAT32)

Output sukses:
```text
Splitting WIM: 4737 MiB of 4737 MiB (100%) written, part 2 of 2
Finished splitting "/mnt/winiso/sources/install.wim"
```

Hasilnya adalah dua file:
```text
/mnt/winpe/sources/install.swm    (~3.5 GB)
/mnt/winpe/sources/install2.swm   (~1.2 GB)
```

Verifikasi:
```bash
ls -lh /mnt/winpe/sources/
# boot.wim
# install.swm
# install2.swm
```

## Mengapa SWM Tetap Berfungsi untuk Instalasi?

Windows Setup (`setup.exe`) memiliki mekanisme built-in untuk menggabungkan file `.swm` secara virtual saat instalasi. Installer mencari `install.swm`, kemudian secara otomatis menemukan `install2.swm`, `install3.swm`, dst. Tidak perlu merge manual sebelum digunakan.

---

## Struktur Akhir WinPE Installer Penuh

Setelah seluruh langkah Bagian 6 dan 7 selesai, jalankan:

```bash
du -sh /mnt/winpe
# 5,2G    /mnt/winpe
```

```bash
ls /mnt/winpe/
# boot  bootmgr  efi  sources
```

Verifikasi struktur lengkap dengan `tree`:
```
/mnt/winpe/
├── boot/
│   ├── bcd
│   ├── boot.sdi
│   ├── bootfix.bin
│   ├── bootsect.exe
│   ├── en-us/
│   │   └── bootsect.exe.mui
│   ├── etfsboot.com
│   ├── fonts/
│   │   ├── chs_boot.ttf ... (20 file font)
│   ├── memtest.exe
│   └── resources/
│       ├── bootres.dll
│       └── bootres_hci.dll
├── bootmgr
├── efi/
│   ├── boot/
│   │   └── bootx64.efi
│   └── microsoft/
│       └── boot/
│           ├── bcd
│           ├── boot.stl
│           ├── cdboot.efi
│           ├── cdboot_noprompt.efi
│           ├── cipolicies/active/ (3 file .cip)
│           ├── efisys.bin
│           ├── efisys_noprompt.bin
│           ├── fonts/ (20 file font)
│           ├── memtest.efi
│           ├── resources/
│           └── winsipolicy.p7b
└── sources/
    ├── boot.wim
    ├── install.swm
    └── install2.swm
```

Ini adalah struktur final yang berhasil pada sistem nyata.

---

# Bagian 8 — Integrasi dengan GRUB (Chainloading)

## Konsep Chainloading

GRUB tidak memahami format boot Windows secara native. Yang dilakukan GRUB adalah **chainloading** — meneruskan kontrol eksekusi ke `bootx64.efi` milik Microsoft, yang kemudian menangani seluruh proses boot Windows.

Alur:
```
GRUB
  ↓ chainloader /efi/boot/bootx64.efi
bootx64.efi (Windows Boot Manager)
  ↓
BCD
  ↓
boot.wim → Windows PE
```

## Backup Konfigurasi GRUB

Sebelum mengubah apapun:

```bash
sudo cp /etc/grub.d/40_custom /etc/grub.d/40_custom.bak
```

## Menambahkan Entry WinPE

Edit file konfigurasi GRUB custom:

```bash
sudo nvim /etc/grub.d/40_custom
```

Tambahkan blok berikut:

```grub
menuentry "Windows PE Internal" {
    insmod part_gpt
    insmod fat

    search --fs-uuid --set=root 5F77-3B4B

    chainloader /efi/boot/bootx64.efi
}
```

**Penjelasan baris per baris:**

```
insmod part_gpt
```
Memuat modul GRUB untuk membaca GPT partition table.

```
insmod fat
```
Memuat modul GRUB untuk membaca filesystem FAT/FAT32.

```
search --fs-uuid --set=root 5F77-3B4B
```
Mencari partisi berdasarkan UUID dan menetapkannya sebagai `root`. Keuntungan metode UUID: tidak bergantung pada nomor partisi. Jika `nvme0n1p7` berubah menjadi `nvme0n1p8` di kemudian hari, GRUB tetap menemukan partisi yang benar. Ganti `5F77-3B4B` dengan UUID aktual dari sistem Anda (hasil `lsblk -f`).

```
chainloader /efi/boot/bootx64.efi
```
Meneruskan boot ke Windows Boot Manager.

## Regenerasi GRUB dan Verifikasi

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Output aktual dari sistem nyata:
```text
Menghasilkan berkas konfigurasi grub ...
Ditemukan image linux: /boot/vmlinuz-6.12-x86_64
Ditemukan image initrd: /boot/intel-ucode.img /boot/amd-ucode.img /boot/initramfs-6.12-x86_64.img
Peringatan: os-prober akan dieksekusi untuk mendeteksi partisi bootable lainnya.
Ditemukan Windows Boot Manager pada /dev/nvme0n1p3@/efi/Microsoft/Boot/bootmgfw.efi
Ditemukan Arch Linux pada /dev/nvme0n1p5
Menambahkan entri menu boot untuk Pengaturan Firmware UEFI...
Found memtest86+ image: /boot/memtest86+/memtest.bin
Found memtest86+ EFI image: /boot/memtest86+/memtest.efi
selesai
```

Verifikasi entry masuk ke konfigurasi final:
```bash
grep "Windows PE Internal" /boot/grub/grub.cfg
# menuentry 'Windows PE Internal' ...
```

## Catatan tentang os-prober

Saat menjalankan `os-prober` tanpa root:
```bash
os-prober
# unshare failed: Operation not permitted
# ERROR: you must be root
# rm: tidak dapat menghapus '/var/lib/os-prober/labels': Ijin ditolak
```

`os-prober` **membutuhkan root**. Selalu gunakan:
```bash
sudo os-prober
# /dev/nvme0n1p3@/efi/Microsoft/Boot/bootmgfw.efi:Windows Boot Manager:Windows:efi
# /dev/nvme0n1p5:Arch Linux:Arch:linux
```

## Sinkronisasi Buffer ke Disk

Sebelum reboot:
```bash
sync
```

Perintah ini memastikan semua data dalam buffer kernel ditulis ke disk fisik. Tidak ada output — itu normal.

---

# Bagian 9 — Entry UEFI Langsung via efibootmgr

## Dua Metode Boot WinPE

| Metode | Jalur | Keunggulan | Kelemahan |
|---|---|---|---|
| GRUB Chainloading | UEFI → GRUB → WinPE | Stabil, mudah dikelola, tidak menyentuh NVRAM | Melewati GRUB |
| efibootmgr | UEFI → WinPE langsung | Boot langsung tanpa GRUB | Beberapa firmware buggy |

Metode GRUB sudah cukup dan terbukti lebih stabil. Metode efibootmgr bersifat opsional.

## Kondisi UEFI Boot Entry Aktual

Sebelum membuat entry baru, lihat kondisi existing:

```bash
sudo efibootmgr -v
```

Output aktual dari sistem:
```text
BootCurrent: 0001
Timeout: 1 seconds
BootOrder: 0001,0002,0000
Boot0000* Windows Boot Manager  HD(3,GPT,f0e82881,...)/\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI...
Boot0001* manjaro                HD(3,GPT,f0e82881,...)/\EFI\MANJARO\GRUBX64.EFI
Boot0002* UEFI: USB DISK 2.0 PMAP...
```

Sistem saat ini booting ke `Boot0001` (manjaro GRUB) secara default.

---

## ⚠️ Analisis Kesalahan Nyata: `--part X`

Saat mencoba membuat entry UEFI, perintah berikut dijalankan:

```bash
# SALAH — X bukan angka yang valid
sudo efibootmgr \
  --create \
  --disk /dev/nvme0n1 \
  --part X \
  --label "WinPE" \
  --loader '\EFI\Boot\bootx64.efi'
```

Output:
```text
invalid numeric value X
```

**Analisis:** Parameter `--part` mengharapkan **nomor partisi integer** (1, 2, 3, dst.), bukan placeholder huruf. `X` pada contoh di atas dimasukkan secara literal tanpa mengganti dengan nomor partisi aktual.

**Hal kritis yang perlu dipahami:** Karena perintah ini gagal **sebelum** menyentuh NVRAM, **tidak ada perubahan yang terjadi** pada firmware. Tidak perlu rollback, tidak perlu membersihkan entry, tidak perlu tindakan pemulihan apapun. Verifikasi dengan:

```bash
sudo efibootmgr
# Hasilnya identik dengan sebelum perintah gagal
```

---

## Perintah efibootmgr yang Benar

Pada sistem nyata, `nvme0n1p7` berarti disk `nvme0n1` dan nomor partisi `7`:

```bash
sudo efibootmgr \
  --create \
  --disk /dev/nvme0n1 \
  --part 7 \
  --label "WinPE" \
  --loader '\EFI\Boot\bootx64.efi'
```

**Penjelasan parameter:**

| Parameter | Nilai | Keterangan |
|---|---|---|
| `--create` | — | Buat entry baru di NVRAM |
| `--disk` | `/dev/nvme0n1` | Disk (tanpa nomor partisi) |
| `--part` | `7` | Nomor partisi (integer!) |
| `--label` | `"WinPE"` | Label yang tampil di firmware UI |
| `--loader` | `'\EFI\Boot\bootx64.efi'` | Path EFI loader menggunakan **backslash** Windows |

> **Penting:** Path loader menggunakan backslash (`\`), bukan forward slash Linux. UEFI menggunakan konvensi path Windows untuk EFI loader.

Verifikasi entry berhasil dibuat:
```bash
sudo efibootmgr -v
# Boot0003* WinPE  HD(7,GPT,...)/File(\EFI\Boot\bootx64.efi)
```

## Operasi efibootmgr Tambahan

**Hapus entry (jika tidak diperlukan):**
```bash
sudo efibootmgr -b 0003 -B
# -b  : pilih Boot ID
# -B  : hapus entry tersebut
```

**Ubah urutan boot:**
```bash
sudo efibootmgr --bootorder 0003,0001,0000
# WinPE → Manjaro → Windows
```

**Boot satu kali saja (tanpa mengubah urutan permanen):**
```bash
sudo efibootmgr --bootnext 0003
# Boot berikutnya: WinPE, setelah itu kembali ke BootOrder normal
```

---

# Bagian 10 — Konversi ke ISO Bootable dan Integrasi Ventoy

## Mengapa ISO dan Bukan Sekadar ZIP/TAR?

Banyak pengguna mencoba mengarsipkan WinPE dengan `zip` atau `tar`. Hasilnya tidak bootable karena UEFI firmware membutuhkan format khusus:

```
ISO 9660 + El Torito (boot catalog) + UEFI EFI System Image
```

Format ZIP dan TAR tidak memiliki struktur ini. Hanya tool khusus seperti `xorriso` yang dapat membuat ISO bootable yang benar.

## Verifikasi Prasyarat

Pastikan kondisi partisi WinPE sudah benar sebelum membuat ISO:

```bash
# Loader EFI harus ada
find /mnt/winpe -iname bootx64.efi
# → /mnt/winpe/efi/boot/bootx64.efi

# boot.wim harus ada
ls -lh /mnt/winpe/sources/boot.wim

# Installer harus ada (jika WinPE penuh)
ls -lh /mnt/winpe/sources/install*.swm

# Verifikasi xorriso tersedia
xorriso --version
```

## Membuat ISO UEFI Bootable

```bash
cd /srv/data/OS

sudo xorriso \
  -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid WINPE_CUSTOM \
  -eltorito-alt-boot \
  -e efi/boot/bootx64.efi \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  -o winpe-custom.iso \
  /mnt/winpe
```

**Penjelasan parameter kritis:**

| Parameter | Fungsi |
|---|---|
| `-iso-level 3` | Mendukung nama file panjang dan file besar |
| `-volid WINPE_CUSTOM` | Label volume ISO (maks 32 karakter, huruf besar) |
| `-e efi/boot/bootx64.efi` | Definisikan EFI boot image |
| `-no-emul-boot` | Mode non-emulasi (diperlukan untuk UEFI) |
| `-isohybrid-gpt-basdat` | Tambahkan GPT header agar kompatibel Ventoy/modern UEFI |

Verifikasi ISO berhasil dibuat:
```bash
ls -lh /srv/data/OS/winpe-custom.iso
# -rw-r--r-- 1 root root 5,4G ... winpe-custom.iso
```

## Verifikasi Isi ISO

```bash
# Mount untuk verifikasi
sudo mkdir -p /mnt/testiso
sudo mount -o loop /srv/data/OS/winpe-custom.iso /mnt/testiso

tree -L 2 /mnt/testiso
# Harus identik dengan /mnt/winpe

# Setelah verifikasi
sudo umount /mnt/testiso
```

## Pengujian dengan QEMU (Sebelum Reboot Fisik)

```bash
qemu-system-x86_64 \
  -m 4096 \
  -enable-kvm \
  -bios /usr/share/edk2/x64/OVMF.fd \
  -cdrom /srv/data/OS/winpe-custom.iso
```

Jika muncul logo Windows diikuti loading circle, WinPE berhasil boot dari ISO.

## Integrasi dengan Ventoy

Pada sistem nyata, Ventoy terdeteksi sebagai:
```text
/run/media/superuser/Ventoy
```

Cukup salin ISO:
```bash
cp /srv/data/OS/winpe-custom.iso \
   /run/media/superuser/Ventoy/
```

Boot dari Ventoy → pilih `winpe-custom.iso` → WinPE berjalan.

```
Ventoy
  ↓
winpe-custom.iso
  ↓
bootx64.efi
  ↓
boot.wim → Windows PE
```

---

# Bagian 11 — Pemeliharaan dan Pembaruan WinPE

## Kapan WinPE Perlu Diperbarui?

- Saat Microsoft merilis ISO Windows baru (24H2 → 25H2)
- Saat `install.wim` perlu diperbarui ke edisi yang lebih baru
- Saat `boot.wim` perlu patch keamanan atau driver update

Kabar baiknya: **partisi `/dev/nvme0n1p7` tidak perlu diformat ulang**. Hanya kontennya yang diperbarui.

## Backup Sebelum Update

```bash
sudo rsync -aHAX \
  /mnt/winpe/ \
  /srv/data/backup/winpe-backup-$(date +%Y%m%d)/
```

## Prosedur Update

```bash
# 1. Mount ISO baru
sudo mount -o loop /srv/data/OS/Win11_25H2_English_x64.iso /mnt/winiso-new

# 2. Update boot.wim (backup dulu)
sudo mv /mnt/winpe/sources/boot.wim /mnt/winpe/sources/boot.wim.old
sudo cp /mnt/winiso-new/sources/boot.wim /mnt/winpe/sources/

# 3. Hapus SWM lama, split ulang install.wim baru
sudo rm -f /mnt/winpe/sources/install*.swm
sudo wimlib-imagex split \
  /mnt/winiso-new/sources/install.wim \
  /mnt/winpe/sources/install.swm \
  3500

# 4. Hapus boot.wim.old setelah verifikasi berhasil
sudo rm -f /mnt/winpe/sources/boot.wim.old

# 5. Rebuild ISO
rm -f /srv/data/OS/winpe-custom.iso
sudo xorriso -as mkisofs \
  -iso-level 3 -full-iso9660-filenames \
  -volid WINPE_CUSTOM \
  -eltorito-alt-boot -e efi/boot/bootx64.efi \
  -no-emul-boot -isohybrid-gpt-basdat \
  -o /srv/data/OS/winpe-custom.iso \
  /mnt/winpe

# 6. Tidak perlu update GRUB (UUID tidak berubah)
```

## Checklist Audit Sebelum Digunakan

```bash
# Loader ada
find /mnt/winpe -iname bootx64.efi && echo "✅ bootx64.efi OK"

# WinPE ada
ls /mnt/winpe/sources/boot.wim && echo "✅ boot.wim OK"

# Installer ada
ls /mnt/winpe/sources/install*.swm && echo "✅ install.swm OK"

# Entry GRUB valid
grep "Windows PE Internal" /boot/grub/grub.cfg && echo "✅ GRUB entry OK"

# Entry UEFI valid (jika digunakan)
sudo efibootmgr | grep -i winpe && echo "✅ UEFI entry OK"

# ISO ada
ls -lh /srv/data/OS/winpe-custom.iso && echo "✅ ISO OK"
```

---

# Bagian 12 — Kustomisasi WinPE Lanjutan

## Mengapa Mengustomisasi boot.wim?

WinPE standar dari ISO Microsoft mungkin tidak memiliki:
- Driver NVMe tertentu atau RAID controller baru
- Driver WiFi atau LAN tertentu
- Tool recovery pihak ketiga
- Script otomatis untuk deployment
- Branding organisasi

## Melihat Isi boot.wim

```bash
wimlib-imagex info /mnt/winpe/sources/boot.wim
```

Output tipikal:
```text
Index 1
Name: Microsoft Windows PE (amd64)
...

Index 2
Name: Microsoft Windows Setup (amd64)
...
```

| Index | Fungsi |
|---|---|
| 1 | WinPE environment (CMD, recovery) |
| 2 | Windows Setup (installer) |

Modifikasi umumnya dilakukan pada Index 1.

## Mount boot.wim untuk Modifikasi

```bash
mkdir -p ~/winpe-work ~/winpe-mount

sudo wimlib-imagex mountrw \
  /mnt/winpe/sources/boot.wim \
  1 \
  ~/winpe-mount
```

Kini `~/winpe-mount` berisi filesystem WinPE yang dapat diedit.

## Menambahkan Driver

```bash
sudo mkdir -p ~/winpe-mount/Drivers

# Salin driver (contoh: Intel RST)
sudo cp -r ~/Downloads/intel-rst/ ~/winpe-mount/Drivers/
```

## Menambahkan Tool Recovery

```bash
sudo mkdir -p ~/winpe-mount/Tools

# Salin tool portable
sudo cp ~/tools/7z.exe ~/winpe-mount/Tools/
sudo cp ~/tools/diskgenius.exe ~/winpe-mount/Tools/
```

## Mengatur Script Autostart

WinPE menjalankan `startnet.cmd` secara otomatis saat boot:

```bash
sudo nvim ~/winpe-mount/Windows/System32/startnet.cmd
```

Contoh isi:
```cmd
@echo off
wpeinit
echo ==============================
echo Recovery Toolkit Ready
echo ==============================
cmd /k
```

## Commit Perubahan ke boot.wim

```bash
sudo wimlib-imagex unmount \
  ~/winpe-mount \
  --commit
```

Jika ingin membatalkan semua perubahan:
```bash
sudo wimlib-imagex unmount \
  ~/winpe-mount \
  --discard
```

## Jenis WinPE Kustom yang Umum

| Tipe | Konten Tambahan |
|---|---|
| Recovery Toolkit | TestDisk, PhotoRec, CrystalDiskInfo |
| Forensic Toolkit | FTK Imager, Autopsy, write-blocker tools |
| Deployment Toolkit | DISM, Sysprep, unattend.xml, network tools |
| Technician Toolkit | Semua kategori di atas |

---

# Bagian 13 — Troubleshooting Sistematis dan Referensi Kesalahan Nyata

## Filosofi Diagnostik

```
Identifikasi gejala → Verifikasi penyebab → Terapkan perbaikan → Verifikasi hasil
```

Jangan menjalankan perintah acak. Setiap perbaikan harus diikuti verifikasi.

---

## Kesalahan 1: `chown failed: Operation not permitted`

**Sumber:** rsync menggunakan flag `-a` (archive) yang mencoba preserve ownership.

**Gejala:**
```text
rsync: [generator] chown "/mnt/winpe/boot" failed: Operation not permitted (1)
```

**Penyebab:** FAT32 tidak mendukung konsep Unix ownership (`chown`, `chmod`, ACL).

**Solusi:**
```bash
sudo rsync -rltDvh --no-owner --no-group SOURCE DEST
```

**Verifikasi:**
```bash
echo $?
# 0 = sukses tanpa error
```

---

## Kesalahan 2: `File too large (27)` — install.wim

**Gejala:**
```text
rsync: [receiver] write failed on "/mnt/winpe/sources/install.wim": File too large (27)
```

**Penyebab:** `install.wim` (~4.7 GB) melebihi batas FAT32 (4 GiB − 1 byte).

**Catatan penting:** Meski rsync gagal pada `install.wim`, file-file lain yang lebih kecil sudah berhasil tersalin sebelum error terjadi. Partisi dalam kondisi parsial/kotor. Solusi paling bersih adalah **format ulang partisi** lalu ulangi dengan prosedur yang benar.

**Solusi:**
```bash
sudo umount /mnt/winpe
sudo mkfs.fat -F32 /dev/nvme0n1p7
sudo mount /dev/nvme0n1p7 /mnt/winpe

# Salin tanpa sources:
sudo rsync -rltDvh --no-owner --no-group \
  /mnt/winiso/boot /mnt/winiso/efi /mnt/winiso/bootmgr /mnt/winpe/

# Salin sources secara manual:
sudo mkdir -p /mnt/winpe/sources
sudo cp /mnt/winiso/sources/boot.wim /mnt/winpe/sources/
sudo wimlib-imagex split \
  /mnt/winiso/sources/install.wim \
  /mnt/winpe/sources/install.swm 3500
```

---

## Kesalahan 3: `sudo: wimlib-imaex: perintah tidak ditemukan`

**Gejala:**
```text
sudo: wimlib-imaex: perintah tidak ditemukan
```

**Penyebab:** Typo — huruf `g` sebelum `e` terlewat.

| Salah | Benar |
|---|---|
| `wimlib-imaex` | `wimlib-imagex` |

---

## Kesalahan 4: `invalid numeric value X`

**Gejala:**
```bash
sudo efibootmgr --create --disk /dev/nvme0n1 --part X --label "WinPE" ...
# invalid numeric value X
```

**Penyebab:** `--part X` menggunakan huruf `X` sebagai placeholder yang lupa diganti dengan nomor partisi aktual.

**Penting:** Error ini terjadi sebelum NVRAM dimodifikasi — tidak ada efek samping, tidak perlu rollback.

**Solusi:** Gunakan nomor partisi yang benar:
```bash
sudo efibootmgr --create --disk /dev/nvme0n1 --part 7 --label "WinPE" \
  --loader '\EFI\Boot\bootx64.efi'
```

---

## Kesalahan 5: `os-prober: you must be root`

**Gejala:**
```text
unshare failed: Operation not permitted
ERROR: you must be root
```

**Penyebab:** `os-prober` dijalankan tanpa `sudo`.

**Solusi:**
```bash
sudo os-prober
```

---

## Kesalahan 6: WinPE Tidak Muncul di Menu GRUB

**Gejala:** Setelah reboot, menu GRUB tidak menampilkan "Windows PE Internal".

**Langkah diagnostik:**
```bash
# Cek entry ada di 40_custom
grep -A10 "Windows PE Internal" /etc/grub.d/40_custom

# Cek entry masuk ke grub.cfg final
grep "Windows PE Internal" /boot/grub/grub.cfg
```

**Penyebab umum:** grub-mkconfig belum dijalankan setelah mengedit `40_custom`.

**Solusi:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Kesalahan 7: Boot WinPE Langsung Kembali ke GRUB

**Gejala:**
```
GRUB → pilih Windows PE Internal → kembali ke GRUB
```

**Langkah diagnostik:**
```bash
# Cek bootx64.efi ada
find /mnt/winpe -iname bootx64.efi

# Cek boot.wim ada
ls /mnt/winpe/sources/boot.wim

# Cek UUID di grub config benar
lsblk -f /dev/nvme0n1p7
grep "5F77-3B4B" /etc/grub.d/40_custom
```

**Penyebab umum:**
- `bootx64.efi` tidak ada → salin ulang dari ISO
- `boot.wim` rusak atau hilang → salin ulang dari ISO
- UUID di konfigurasi GRUB tidak sesuai dengan UUID aktual → update `40_custom` dan regenerate

---

## Kesalahan 8: Windows Setup Tidak Menemukan Installer

**Gejala:** WinPE berhasil boot, Windows Setup muncul, tetapi:
```text
No installation image found
```

**Langkah diagnostik:**
```bash
ls -lh /mnt/winpe/sources/install*.swm
# Harus ada install.swm dan install2.swm

wimlib-imagex info /mnt/winpe/sources/install.swm
# Harus menampilkan informasi image tanpa error
```

**Penyebab:** Proses split tidak selesai, atau file SWM terhapus.

**Solusi:** Lakukan split ulang:
```bash
sudo wimlib-imagex split \
  /mnt/winiso/sources/install.wim \
  /mnt/winpe/sources/install.swm 3500
```

---

## Kesalahan 9: Entry UEFI Hilang Setelah Reboot

**Gejala:** Entry WinPE yang dibuat dengan `efibootmgr` tidak lagi muncul setelah reboot.

**Penyebab:** Bug firmware pada beberapa vendor (ASUS, HP, Lenovo tertentu) yang secara otomatis menghapus entry yang dianggap tidak valid.

**Solusi:** Tetap gunakan metode GRUB Chainloading yang lebih stabil. Metode GRUB tidak menyentuh NVRAM dan tidak terpengaruh oleh bug firmware.

---

## Checklist Diagnostik Cepat

```bash
# Satu blok perintah untuk diagnosis lengkap
echo "=== Diagnostik WinPE ==="
echo ""
echo "[ Partisi ]"
lsblk -f /dev/nvme0n1p7
echo ""
echo "[ Mount Status ]"
findmnt /mnt/winpe 2>/dev/null || echo "TIDAK MOUNTED"
echo ""
echo "[ File Kritis ]"
find /mnt/winpe -iname bootx64.efi 2>/dev/null | head -1 || echo "HILANG: bootx64.efi"
ls /mnt/winpe/sources/boot.wim 2>/dev/null && echo "OK: boot.wim" || echo "HILANG: boot.wim"
ls /mnt/winpe/sources/install*.swm 2>/dev/null | head -2 || echo "HILANG: install.swm"
echo ""
echo "[ GRUB Entry ]"
grep -c "Windows PE Internal" /boot/grub/grub.cfg 2>/dev/null && echo "OK: GRUB entry ada" || echo "HILANG: GRUB entry"
```

---

# Bagian 14 — Referensi Arsitektur dan Teknologi

## Peta Arsitektur Lengkap

```
Firmware UEFI
      │
      ├─── GRUB (grubx64.efi)
      │         │
      │         ├── Manjaro/Arch Linux
      │         ├── Windows (chainload ke Windows BM)
      │         └── Windows PE Internal ─────────────────┐
      │                                                    │
      └─── Langsung (efibootmgr / BootOrder)              │
                │                                          │
                └── WinPE ←─────────────────────────────┘
                      │
                      ↓
                bootx64.efi
                      │
                      ↓
                BCD (Boot Configuration Data)
                      │
                      ↓
                boot.wim → RAM
                      │
                      ↓
                Windows PE Environment
                      │
                      ├── Recovery mode (CMD, diskpart, dll)
                      └── Setup mode
                              │
                              ↓
                        install.swm + install2.swm
                              │
                              ↓
                        Windows terinstal di disk
```

## Ringkasan Tiga Metode Akses WinPE

```
Metode 1 — Internal via GRUB:
UEFI → GRUB → chainloader bootx64.efi → WinPE

Metode 2 — Internal via UEFI langsung:
UEFI NVRAM → efibootmgr entry → bootx64.efi → WinPE

Metode 3 — ISO via Ventoy:
Ventoy → winpe-custom.iso → bootx64.efi → WinPE
```

## Teknologi yang Terlibat

| Teknologi | Peran | Implementasi |
|---|---|---|
| UEFI Firmware | Boot pertama setelah power on | C (EDK2 framework) |
| NVRAM | Penyimpanan boot order permanen | Hardware flash |
| GPT | Tabel partisi modern | Kernel Linux, libparted |
| FAT32 | Filesystem UEFI-required | dosfstools |
| GRUB | Boot manager Linux | C |
| bootx64.efi | Windows Boot Manager | Microsoft C/C++ |
| BCD | Konfigurasi boot Windows | Binary Windows format |
| boot.wim | Image WinPE | WIM format (Microsoft) |
| install.wim / .swm | Image Windows installer | WIM format |
| wimlib-imagex | Tool manajemen WIM di Linux | C (open-source) |
| xorriso | Pembuat ISO bootable | C (libisoburn) |
| Ventoy | Multi-boot ISO loader | C |
| efibootmgr | Manajemen NVRAM UEFI | C |
| rsync | Transfer file efisien | C |

## Analogi Konseptual Linux ↔ Windows

| Komponen Windows | Analogi Linux |
|---|---|
| `bootx64.efi` | `grubx64.efi` |
| BCD | `grub.cfg` |
| `boot.wim` | `initramfs + rootfs mini` |
| `install.wim` | Filesystem Linux yang sudah jadi |
| Windows PE | Live system (seperti Arch ISO) |

---

## Rangkuman Alur Kerja Final (Clean Path)

Ini adalah urutan perintah yang benar dari awal hingga akhir, tanpa kesalahan:

```bash
# ═══════════════════════════════════════════════════════
# FASE 1 — PERSIAPAN
# ═══════════════════════════════════════════════════════

# Verifikasi UEFI
test -d /sys/firmware/efi && echo "UEFI OK"

# Buat mount points
sudo mkdir -p /mnt/winpe /mnt/winiso

# Format FAT32 (clean)
sudo mkfs.fat -F32 /dev/nvme0n1p7

# Mount partisi WinPE
sudo mount /dev/nvme0n1p7 /mnt/winpe

# Mount ISO Windows
sudo mount -o loop "/srv/data/OS/Win11_24H2_English_x64.iso" /mnt/winiso


# ═══════════════════════════════════════════════════════
# FASE 2 — SALIN STRUKTUR BOOT (rsync benar)
# ═══════════════════════════════════════════════════════

sudo rsync -rltDvh --no-owner --no-group \
  /mnt/winiso/boot \
  /mnt/winiso/efi \
  /mnt/winiso/bootmgr \
  /mnt/winpe/


# ═══════════════════════════════════════════════════════
# FASE 3 — SALIN boot.wim
# ═══════════════════════════════════════════════════════

sudo mkdir -p /mnt/winpe/sources
sudo cp /mnt/winiso/sources/boot.wim /mnt/winpe/sources/


# ═══════════════════════════════════════════════════════
# FASE 4 — SPLIT install.wim (untuk WinPE Installer Penuh)
# ═══════════════════════════════════════════════════════

sudo wimlib-imagex split \
  /mnt/winiso/sources/install.wim \
  /mnt/winpe/sources/install.swm \
  3500


# ═══════════════════════════════════════════════════════
# FASE 5 — INTEGRASI GRUB
# ═══════════════════════════════════════════════════════

# UUID dari: lsblk -f /dev/nvme0n1p7
# Edit /etc/grub.d/40_custom, tambahkan:
# menuentry "Windows PE Internal" {
#     insmod part_gpt
#     insmod fat
#     search --fs-uuid --set=root 5F77-3B4B
#     chainloader /efi/boot/bootx64.efi
# }

sudo grub-mkconfig -o /boot/grub/grub.cfg

sync


# ═══════════════════════════════════════════════════════
# FASE 6 — VERIFIKASI FINAL
# ═══════════════════════════════════════════════════════

find /mnt/winpe -iname bootx64.efi
ls -lh /mnt/winpe/sources/
du -sh /mnt/winpe
grep "Windows PE Internal" /boot/grub/grub.cfg


# ═══════════════════════════════════════════════════════
# FASE 7 — BUAT ISO (opsional)
# ═══════════════════════════════════════════════════════

sudo xorriso \
  -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid WINPE_CUSTOM \
  -eltorito-alt-boot \
  -e efi/boot/bootx64.efi \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  -o /srv/data/OS/winpe-custom.iso \
  /mnt/winpe
```

---

## Kompetensi yang Diperoleh

Setelah memahami seluruh dokumentasi ini, Anda menguasai:

- Arsitektur boot UEFI modern secara menyeluruh
- Struktur internal ISO Windows (boot.wim vs install.wim)
- Batasan FAT32 dan cara mengatasinya dengan Split WIM
- Teknik rsync yang benar untuk target FAT32
- GRUB chainloading untuk boot Windows/WinPE
- Manajemen NVRAM UEFI dengan efibootmgr
- Pembuatan ISO bootable UEFI dengan xorriso
- Integrasi dengan Ventoy
- Kustomisasi WinPE dengan wimlib-imagex
- Diagnostik dan recovery dari kesalahan umum

---

*Dokumen ini berdasarkan implementasi nyata pada sistem Manjaro Linux dengan UEFI/GPT/NVMe. Seluruh output terminal adalah output asli dari sesi yang berhasil.*
