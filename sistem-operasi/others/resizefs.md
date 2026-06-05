# Dokumentasi Lengkap: Penambahan Kapasitas Root Debian dan Swap dari Arch Linux

## Tujuan

Mengubah ukuran partisi Debian:

| Partisi                   | Sebelum | Sesudah |
| ------------------------- | ------- | ------- |
| `nvme0n1p8` (Root Debian) | ±50 GiB | 100 GiB |
| `nvme0n1p9` (Swap Debian) | 8 GiB   | 16 GiB  |

Operasi dilakukan dari Arch Linux tanpa masuk ke Debian.

---

# Kondisi Awal

Partisi Debian:

```text
nvme0n1p8 ext4  UUID=dd3c3ad4-daae-43c6-84ac-6119577cc1f1
nvme0n1p9 swap  UUID=528717ff-4078-4782-a168-6519170b0465
```

Terdapat ruang kosong (Unallocated Space / Free Space) setelah `nvme0n1p9`.

Target:

* Menambah root Debian menjadi 100 GiB.
* Menambah swap menjadi 16 GiB.

---

# Analisis Awal

Pertanyaan pertama:

> Apakah perlu chroot atau mount dahulu?

Jawaban:

Tidak perlu.

Alasan:

* Resize partisi dilakukan pada level tabel partisi.
* Resize filesystem dilakukan langsung pada device block.
* Chroot hanya diperlukan jika harus memperbaiki sistem Debian dari dalam.
* Mount hanya diperlukan untuk mengubah file konfigurasi seperti `/etc/fstab`.

---

# Pemeriksaan Awal

Memastikan tata letak partisi:

```bash
lsblk -f
```

Output penting:

```text
nvme0n1p8 ext4
nvme0n1p9 swap
```

Swap Debian tidak sedang aktif karena yang aktif adalah:

```text
nvme0n1p6 [SWAP]
```

Maka aman untuk dimodifikasi.

---

# Tahap 1: Menghapus Swap Lama

Masuk ke:

```bash
sudo cfdisk /dev/nvme0n1
```

Di dalam cfdisk:

1. Pilih `nvme0n1p9`
2. Pilih `Delete`
3. Simpan perubahan dengan `Write`
4. Ketik:

```text
yes
```

5. Keluar dengan `Quit`

Hasil:

```text
p9 dihapus
free space muncul setelah p8
```

---

# Tahap 2: Memperbesar Root Debian

Masih di:

```bash
sudo cfdisk /dev/nvme0n1
```

Langkah:

1. Pilih `nvme0n1p8`
2. Pilih `Resize`
3. Tambahkan ruang kosong yang tersedia
4. Simpan:

```text
Write
yes
Quit
```

---

# Tahap 3: Meminta Kernel Membaca Tabel Partisi Baru

Menjalankan:

```bash
sudo partprobe /dev/nvme0n1
```

Tujuan:

* Memuat ulang partition table tanpa reboot.

---

# Tahap 4: Memeriksa Integritas Filesystem

Menjalankan:

```bash
sudo e2fsck -f /dev/nvme0n1p8
```

Output:

```text
Pass 1
Pass 2
Pass 3
Pass 4
Pass 5
```

Filesystem dinyatakan sehat.

---

# Tahap 5: Memperbesar Filesystem ext4

Menjalankan:

```bash
sudo resize2fs /dev/nvme0n1p8
```

Output:

```text
The filesystem on /dev/nvme0n1p8 is now 26214400 (4k) blocks long.
```

Artinya filesystem berhasil diperbesar mengikuti ukuran partisi baru.

---

# Verifikasi Resize

Menjalankan:

```bash
sudo dumpe2fs -h /dev/nvme0n1p8 | grep -E "Block count|Block size"
```

Output:

```text
Block count: 26214400
Block size: 4096
```

Perhitungan:

```text
26214400 × 4096
= 107374182400 byte
≈ 100 GiB
```

Kesimpulan:

```text
Root Debian berhasil menjadi 100 GiB
```

---

# Tahap 6: Memastikan Ukuran Partisi

Menjalankan:

```bash
lsblk -l
```

Output penting:

```text
nvme0n1p8 100G
nvme0n1p9 16G
```

---

# Tahap 7: Membuat Ulang Swap

Awalnya mencoba:

```bash
sudo swapon /dev/nvme0n1p9
```

Hasil:

```text
swapon: read swap header failed
```

Penyebab:

Partisi baru belum memiliki signature swap.

---

# Solusi

Menjalankan:

```bash
sudo mkswap /dev/nvme0n1p9
```

Output pertama:

```text
UUID=f377e198-c72f-4e0e-b4bc-02e28927c351
```

Kemudian dijalankan kembali:

```bash
sudo mkswap /dev/nvme0n1p9
```

Output:

```text
warning: wiping old swap signature
UUID=84026a85-1c69-4e4f-9706-7abebb659b8f
```

UUID final:

```text
84026a85-1c69-4e4f-9706-7abebb659b8f
```

---

# Tahap 8: Memperbarui fstab Debian

Mount root Debian:

```bash
sudo mount /dev/nvme0n1p8 /mnt
```

Edit:

```bash
sudo nvim /mnt/etc/fstab
```

Mengganti UUID swap lama:

```text
528717ff-4078-4782-a168-6519170b0465
```

menjadi:

```text
84026a85-1c69-4e4f-9706-7abebb659b8f
```

Simpan perubahan.

---

# Tahap 9: Melepas Mount

```bash
sudo umount -R /mnt
```

Verifikasi:

```bash
lsblk -f
```

Output:

```text
nvme0n1p8 ext4
nvme0n1p9 swap UUID=84026a85-1c69-4e4f-9706-7abebb659b8f
```

---

# Tahap 10: Boot ke Debian

Sistem Debian berhasil boot.

Tidak ada:

```text
Emergency Mode
Kernel Panic
Filesystem Error
Swap Error
```

---

# Verifikasi di Debian

Menjalankan:

```bash
swapon --show
```

dan:

```bash
free -h
```

Hasil:

```text
Swap berubah dari 8 GiB menjadi 16 GiB
```

Menjalankan:

```bash
df -h /
```

Hasil:

```text
Root menjadi 100 GiB
```

---

# Ringkasan Perintah yang Digunakan

## Melihat Partisi

```bash
lsblk -f
lsblk -l
```

## Mengubah Tabel Partisi

```bash
sudo cfdisk /dev/nvme0n1
```

## Reload Partition Table

```bash
sudo partprobe /dev/nvme0n1
```

## Memeriksa Filesystem

```bash
sudo e2fsck -f /dev/nvme0n1p8
```

## Resize ext4

```bash
sudo resize2fs /dev/nvme0n1p8
```

## Membuat Swap

```bash
sudo mkswap /dev/nvme0n1p9
```

## Aktivasi Swap

```bash
sudo swapon /dev/nvme0n1p9
```

## Memeriksa UUID

```bash
sudo blkid /dev/nvme0n1p9
```

## Mount Debian

```bash
sudo mount /dev/nvme0n1p8 /mnt
```

## Edit fstab

```bash
sudo nvim /mnt/etc/fstab
```

## Unmount

```bash
sudo umount -R /mnt
```

---

# Konsep yang Dipelajari

### Administrasi Disk

* GPT Partition Table
* PARTUUID
* UUID
* Free Space
* Unallocated Space

### Filesystem

* ext4
* e2fsck
* resize2fs

### Swap

* mkswap
* swapon
* swap header
* UUID swap

### Recovery dan Maintenance Linux

* Modifikasi sistem lain dari Arch Linux
* Mount root sistem lain
* Edit `fstab` tanpa chroot
* Resize filesystem secara offline

---

# Hasil Akhir

```text
Debian berhasil boot normal.

nvme0n1p8 (Root Debian)
→ 100 GiB

nvme0n1p9 (Swap Debian)
→ 16 GiB

UUID swap diperbarui di fstab.

Filesystem ext4 berhasil diperbesar.

Tidak ada kehilangan data.

Tidak diperlukan chroot.

Operasi selesai dengan sukses.
```
