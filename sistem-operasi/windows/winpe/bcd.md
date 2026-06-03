# Dokumentasi Lengkap Recovery Windows Boot Manager pada Multi-Boot Manjaro + Arch + Windows (UEFI/GPT)

## Ringkasan Kasus

Konfigurasi sistem:

| Komponen           | Keterangan            |
| ------------------ | --------------------- |
| Firmware           | UEFI                  |
| Partisi EFI        | `nvme0n1p3`           |
| Label EFI          | `EFIBOOT`             |
| UUID EFI           | `BC93-16D6`           |
| Ukuran EFI         | ±1 GB                 |
| Boot Manager Utama | GRUB Manjaro          |
| OS 1               | Manjaro (LUKS + ext4) |
| OS 2               | Arch Linux            |
| OS 3               | Windows               |
| Tabel Partisi      | GPT                   |

Arsitektur awal:

```text
UEFI
 └─ GRUB Manjaro
     ├─ Manjaro
     ├─ Arch Linux
     └─ Windows
```

Boot manager Manjaro bertugas sebagai titik masuk seluruh sistem operasi.

---

# Gejala Awal

Windows menghilang dari menu boot.

Tujuan:

1. Memulihkan entri Windows.
2. Tidak menghapus entri Manjaro.
3. Tidak menghapus entri Arch.
4. Tetap menggunakan GRUB Manjaro sebagai boot manager utama.

---

# Pemeriksaan EFI Partition

Perintah:

```bash
lsblk -f
```

Hasil penting:

```text
nvme0n1p3  vfat FAT32 EFIBOOT BC93-16D6
```

Partisi EFI:

```text
/dev/nvme0n1p3
```

Mountpoint:

```text
/boot/efi
```

---

# Pemeriksaan UEFI Entry

Perintah:

```bash
efibootmgr -v
```

Hasil:

```text
Boot0000 Windows Boot Manager
Boot0001 manjaro
```

Temuan:

Windows sebenarnya masih terdaftar di NVRAM UEFI.

Path yang digunakan:

```text
\EFI\MICROSOFT\BOOT\BOOTMGFW.EFI
```

Kesimpulan:

* Entry UEFI Windows tidak hilang.
* NVRAM masih sehat.
* Firmware masih mengenali Windows.

---

# Pemeriksaan Struktur EFI

Perintah:

```bash
ls /boot/efi/EFI
```

Hasil:

```text
manjaro
Microsof
Microsoft
```

Temuan:

Terdapat dua direktori:

```text
EFI/Microsoft
EFI/Microsof
```

Direktori tersebut merupakan hasil recovery manual sebelumnya.

---

# Pemeriksaan File Windows EFI

Perintah:

```bash
tree -a /boot/efi/EFI/Microsoft
```

Ditemukan:

```text
bootmgfw.efi
bootmgr.efi
BCD
memtest.efi
CIPolicies
...
```

Struktur terlihat lengkap.

---

# Verifikasi bootmgfw.efi

Perintah:

```bash
file /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
```

Hasil:

```text
PE32+ executable for EFI (application), x86-64
```

Kesimpulan:

File EFI Windows valid.

---

# Pemeriksaan OS Prober

Perintah:

```bash
grep OS_PROBER /etc/default/grub
```

Hasil:

```text
GRUB_DISABLE_OS_PROBER=false
```

Artinya:

```text
os-prober aktif
```

---

# Pemeriksaan Deteksi Sistem Operasi

Perintah:

```bash
os-prober
```

Hasil:

```text
/dev/nvme0n1p3@/efi/Microsoft/Boot/bootmgfw.efi:Windows Boot Manager:Windows:efi

/dev/nvme0n1p5:Arch Linux:Arch:linux
```

Kesimpulan:

GRUB dapat mendeteksi:

* Windows
* Arch Linux

---

# Regenerasi Konfigurasi GRUB

Perintah:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Hasil:

```text
Found Windows Boot Manager
Found Arch Linux
```

Kesimpulan:

GRUB bekerja normal.

---

# Penambahan Chainloader Manual

File:

```bash
/etc/grub.d/40_custom
```

Isi:

```bash
menuentry "Windows Boot Manager" {
    insmod part_gpt
    insmod fat
    search --fs-uuid --no-floppy BC93-16D6 --set=root
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

UUID:

```text
BC93-16D6
```

Kemudian:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

---

# Pemeriksaan Entri GRUB

Perintah:

```bash
grep "menuentry '" /boot/grub/grub.cfg
```

Hasil:

```text
Manjaro Linux
Windows Boot Manager
Arch Linux
UEFI Firmware Settings
```

Kesimpulan:

Menu Windows sudah berhasil masuk ke GRUB.

---

# Error Saat Boot Windows

Saat memilih Windows muncul:

```text
Windows Boot Manager

File:
\EFI\Microsoft\Boot\BCD

Status:
0xc000000f

Info:
The Boot Configuration Data for your PC is missing or contains errors.
```

---

# Analisis Error

Alur boot Windows:

```text
UEFI
 ↓
bootmgfw.efi
 ↓
BCD
 ↓
winload.efi
 ↓
ntoskrnl.exe
 ↓
Windows
```

Posisi kerusakan:

```text
BCD
```

Bukan:

```text
UEFI
GRUB
bootmgfw.efi
```

Karena:

* GRUB berhasil menjalankan Windows Boot Manager.
* bootmgfw.efi berhasil berjalan.
* Error muncul ketika membaca BCD.

---

# Status Komponen

| Komponen      | Status |
| ------------- | ------ |
| EFI Partition | Sehat  |
| UEFI NVRAM    | Sehat  |
| Boot0000      | Sehat  |
| Boot0001      | Sehat  |
| GRUB          | Sehat  |
| os-prober     | Sehat  |
| bootmgfw.efi  | Sehat  |
| BCD           | Rusak  |

---

# Penyebab Kemungkinan

Karena pernah melakukan recovery manual:

```text
EFI/Microsoft
EFI/Microsof
```

Kemungkinan:

1. BCD kosong.
2. BCD milik instalasi lain.
3. GUID tidak cocok.
4. Path winload salah.
5. Device path salah.
6. Recovery tidak selesai.

---

# Solusi yang Direkomendasikan

Jangan:

```text
Reinstall Windows
Format EFI
Reinstall GRUB
```

Lakukan:

```text
Rebuild BCD
```

---

# Recovery Menggunakan WinPE

WinPE dapat digunakan.

Bahkan sangat cocok untuk kasus ini.

Persyaratan:

```text
WinPE x64
Boot Mode UEFI
```

---

# Verifikasi Mode UEFI di WinPE

Perintah:

```cmd
wpeutil UpdateBootInfo

reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType
```

Hasil:

```text
0x2 = UEFI
0x1 = Legacy
```

Harus:

```text
0x2
```

---

# Identifikasi Partisi

Masuk:

```cmd
diskpart
```

Lalu:

```cmd
list vol
```

Cari:

* EFI FAT32
* Windows NTFS

Misal:

```text
EFI      = S:
Windows  = D:
```

---

# Jika EFI Belum Memiliki Huruf

Masuk:

```cmd
select volume X
assign letter=S
exit
```

---

# Verifikasi Instalasi Windows

Perintah:

```cmd
dir D:\Windows
```

Harus muncul:

```text
System32
explorer.exe
...
```

---

# Backup BCD Lama

Opsional:

```cmd
ren S:\EFI\Microsoft\Boot\BCD BCD.bak
```

---

# Rebuild BCD

Perintah utama:

```cmd
bcdboot D:\Windows /s S: /f UEFI
```

atau jika Windows berada di C:

```cmd
bcdboot C:\Windows /s S: /f UEFI
```

Fungsi:

* Membuat ulang BCD.
* Memperbaiki GUID.
* Memperbaiki path Windows.
* Membuat konfigurasi boot baru.

Output sukses:

```text
Boot files successfully created.
```

---

# Perintah Tambahan (Opsional)

Scan instalasi:

```cmd
bootrec /scanos
```

Rebuild:

```cmd
bootrec /rebuildbcd
```

Catatan:

Pada GPT + UEFI modern:

```text
bcdboot
```

biasanya sudah cukup.

---

# Setelah Recovery

Boot kembali ke Manjaro.

Regenerasi GRUB:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Reboot:

```bash
sudo reboot
```

---

# Struktur Boot yang Diharapkan Setelah Selesai

```text
UEFI
 └─ GRUB Manjaro
     ├─ Manjaro
     ├─ Arch Linux
     └─ Windows Boot Manager
          └─ Windows
```

---

# Konsep Penting yang Dipelajari

## UEFI

Firmware modern pengganti BIOS.

---

## ESP (EFI System Partition)

Partisi FAT32 khusus bootloader.

Contoh:

```text
nvme0n1p3
```

---

## NVRAM

Menyimpan:

```text
Boot0000
Boot0001
BootXXXX
```

---

## Boot Manager Windows

File utama:

```text
bootmgfw.efi
```

---

## BCD

Boot Configuration Data.

Merupakan database boot Windows.

Dikelola oleh:

```text
bcdboot
bcdedit
bootrec
```

---

## GRUB Chainloading

GRUB tidak menjalankan Windows secara langsung.

GRUB hanya menjalankan:

```text
bootmgfw.efi
```

Kemudian Windows mengambil alih proses boot.

---

# Daftar Perintah yang Digunakan Selama Diagnosa

```bash
lsblk -f

efibootmgr -v

ls /boot/efi/EFI

tree -a /boot/efi/EFI/Microsoft

tree -a /boot/efi/EFI/Microsof

file /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi

grep OS_PROBER /etc/default/grub

os-prober

grub-mkconfig -o /boot/grub/grub.cfg

grep "menuentry '" /boot/grub/grub.cfg

grep -i "menuentry\|windows\|arch\|manjaro" /boot/grub/grub.cfg

cat /etc/grub.d/40_custom
```

---

# Referensi Resmi

* [Microsoft BCDBoot Documentation](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di?utm_source=chatgpt.com)
* [Microsoft BCD Overview](https://learn.microsoft.com/en-us/windows/client-management/bcd-overview?utm_source=chatgpt.com)
* [Microsoft WinPE Documentation](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?utm_source=chatgpt.com)
* [GNU GRUB Official Documentation](https://www.gnu.org/software/grub/manual/grub/grub.html?utm_source=chatgpt.com)
* [ArchWiki UEFI](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface?utm_source=chatgpt.com)
* [ArchWiki GRUB](https://wiki.archlinux.org/title/GRUB?utm_source=chatgpt.com)
* [ArchWiki Dual Boot with Windows](https://wiki.archlinux.org/title/Dual_boot_with_Windows?utm_source=chatgpt.com)

Kesimpulan akhir: seluruh infrastruktur boot (UEFI, EFI partition, NVRAM, GRUB, os-prober, dan `bootmgfw.efi`) telah terbukti berfungsi. Titik kerusakan yang tersisa berada pada database boot Windows (`BCD`), sehingga fokus recovery berikutnya adalah menjalankan `bcdboot` dari WinPE/Windows Recovery Environment untuk membangun ulang BCD yang valid.
