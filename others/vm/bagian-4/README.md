## Audit Kurikulum Fase 4

Berdasarkan `kurikulum.md`, Fase 4 mencakup:

1. Modul 4.1 — Golden Image + Overlay Backing Chain  
2. Modul 4.2 — Snapshot Internal/External, blockcommit/blockpull  
3. Modul 4.3 — virt-sysprep, virt-customize, virt-clone  
4. Modul 4.4 — Edit Disk Offline (guestfish, guestmount, qemu-nbd)  
5. Modul 4.5 — Backup Live & Uji Restore  

**Temuan audit:**

- Modul 4.1 sudah tepat sebagai fondasi. Namun, kurikulum belum menyebut secara eksplisit:
  - `qemu-img info --backing-chain`
  - `qemu-img commit` dan `qemu-img rebase`
  - Bahaya *chain depth* dan *performance penalty*
  - XML libvirt `<backingStore>`
  - Praktik *golden image* yang benar (sysprep, seal, compress)
- Modul 4.2 sudah menyebut snapshot dan blockcommit/blockpull, tetapi belum membedakan **internal snapshot qcow2** vs **external snapshot** secara rinci.
- Modul 4.3 sudah menyebut `virt-sysprep`, `virt-customize`, `virt-clone`. Perlu tambahan `virt-sparsify`, `virt-resize`, `virt-builder`.
- Modul 4.4 sudah menyebut `guestfish`, `guestmount`, `qemu-nbd`. Perlu tambahan `libguestfs` tools lain dan peringatan *live mounting*.
- Modul 4.5 sudah menyebut backup live dan uji restore. Perlu tambahan checksum, verifikasi, dan strategi retensi.

**Rekomendasi:** Tambahkan sub-modul atau poin-poin di atas ke dalam kurikulum sebagai pengayaan. Untuk saat ini, kita mulai dari **Modul 4.1**.

---

## Fase 4 — Storage, Image & Backup Engineering

**Estimasi:** 2 minggu  
**Prasyarat:** Fase 3 lulus; dasar LVM/Btrfs/ZFS disarankan.

**Tujuan Fase:**
- Mengelola disk efisien, clone, snapshot, restore.
- Memahami backing chain, overlay, dan golden image.
- Mampu melakukan backup live dan restore terverifikasi.

<details>
  <summary>📃 Daftar Isi</summary>

---


**Daftar Isi Fase:**
1. Modul 4.1 — Golden Image + Overlay Backing Chain  
2. Modul 4.2 — Snapshot Internal/External, blockcommit/blockpull  
3. Modul 4.3 — virt-sysprep, virt-customize, virt-clone  
4. Modul 4.4 — Edit Disk Offline (guestfish, guestmount, qemu-nbd)  
5. Modul 4.5 — Backup Live & Uji Restore  

</details>

---

# Modul 4.1 — Golden Image + Overlay Backing Chain

> *“Satu gambar untuk banyak VM. Hemat ruang, cepat, dan terkendali.”*

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Golden Image** adalah image disk dasar yang sudah dikonfigurasi, di-*sysprep*, dan dijadikan *read-only*. Dari image ini, kita membuat **overlay** (lapisan tipis) untuk setiap VM. Overlay menggunakan mekanisme **Copy-on-Write (COW)**: perubahan ditulis ke overlay, sementara base image tetap utuh. Ini memungkinkan:

- Pembuatan VM cepat (hanya membuat file overlay kecil).
- Hemat ruang (base image hanya satu).
- Isolasi perubahan (VM tidak saling memengaruhi).
- Rollback mudah (hapus overlay, buat baru).

**Peran dalam kurikulum:** Modul ini adalah **fondasi Fase 4**. Tanpa memahami backing chain, Anda akan kesulitan di Modul 4.2 (snapshot), 4.3 (clone), dan 4.5 (backup). Ini juga jembatan dari Fase 3 (storage pool & volume) ke Fase 4 (image engineering).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Golden Image = Cetak Biru

Bayangkan Anda ingin membangun 10 rumah identik. Anda tidak perlu membuat cetak biru baru setiap kali. Cukup buat satu cetak biru (golden image), lalu setiap rumah dibangun di atas lahan yang sama tetapi dengan modifikasi masing-masing (overlay). Cetak biru tetap bersih, tidak tersentuh.

**Filosofi:** *Base image adalah sumber kebenaran yang tidak boleh diubah.* Overlay adalah ruang kerja.

### 2.2. Backing Chain = Rantai Lapisan

qcow2 mendukung **backing file**. File qcow2 dapat menunjuk ke file qcow2 lain sebagai *backing store*. Jika data tidak ada di overlay, QEMU akan membacanya dari backing file. Jika ada perubahan, ditulis ke overlay. Ini membentuk **rantai**:

```
base.qcow2 <- overlay1.qcow2 <- overlay2.qcow2
```

**Filosofi:** *Setiap lapisan adalah delta.* Semakin panjang rantai, semakin banyak I/O yang harus dibaca.

### 2.3. Copy-on-Write (COW)

COW berarti: saat blok ditulis, blok asli dari backing file disalin ke overlay, lalu dimodifikasi. Blok yang tidak diubah tetap dibaca dari backing file.

**Filosofi:** *Hemat ruang, tetapi baca menjadi lebih lambat jika data tersebar.*

### 2.4. Format Backing

Backing file harus dalam format yang didukung. Biasanya qcow2 ke qcow2. Raw bisa menjadi backing, tetapi tidak bisa menjadi overlay. Gunakan `-F` untuk menentukan format backing.

**Filosofi:** *Ketepatan format mencegah korupsi data.*

### 2.5. Chain Depth

Semakin dalam rantai, semakin besar *overhead*. Idealnya maksimal 2–3 lapisan. Jika lebih, lakukan **commit** atau **rebase** untuk meratakan.

**Filosofi:** *Rantai adalah utang teknis. Lunasi secara berkala.*

### 2.6. Read-Only Base

Base image harus *read-only* secara logis. Jangan pernah boot langsung dari base. Selalu buat overlay.

**Filosofi:** *Base adalah artefak. Lindungi dari perubahan.*

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Golden Image** | Image dasar yang sudah dikonfigurasi dan di-sysprep. | `golden.qcow2` |
| **Overlay** | File qcow2 yang menunjuk ke backing file. | `overlay.qcow2` |
| **Backing File** | File qcow2 yang menjadi lapisan bawah. | `golden.qcow2` |
| **Backing Chain** | Rantai file qcow2 yang saling menunjuk. | `base <- overlay1 <- overlay2` |
| **COW** | Copy-on-Write. | Perubahan ditulis ke overlay. |
| **`qemu-img create -b`** | Membuat overlay dengan backing file. | `-b golden.qcow2` |
| **`-F`** | Format backing file. | `-F qcow2` |
| **`qemu-img info --backing-chain`** | Lihat rantai. | |
| **`qemu-img commit`** | Gabungkan overlay ke backing. | |
| **`qemu-img rebase`** | Ubah backing file. | |
| **`qemu-img amend`** | Ubah properti image. | |
| **`qemu-img check`** | Cek konsistensi. | |
| **`qemu-img map`** | Lihat pemetaan blok. | |
| **`qemu-img resize`** | Ubah ukuran. | |
| **`qemu-img convert`** | Konversi format. | |
| **`qemu-img compare`** | Bandingkan dua image. | |
| **`qemu-img dd`** | DD dari/ke image. | |
| **`qemu-img bench`** | Benchmark I/O. | |
| **`virt-sysprep`** | Siapkan image untuk cloning. | |
| **`virt-sparsify`** | Kurangi ukuran image. | |
| **`libguestfs`** | Kumpulan alat untuk manipulasi image. | |

---

## 4. Sintaks Dasar & Penjelasan Kata demi Kata

### 4.1. Membuat Golden Image

Langkah umum:
1. Install VM dari ISO.
2. Lakukan update, install paket dasar.
3. Jalankan `virt-sysprep` untuk menghapus identitas unik.
4. Matikan VM.
5. Konversi dan kompres.

Contoh:
```bash
# Buat VM untuk golden
virt-install \
  --name golden-build \
  --memory 2048 \
  --vcpus 2 \
  --disk size=20,format=qcow2,path=/var/lib/libvirt/images/golden-build.qcow2 \
  --cdrom /path/to/arch.iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial

# Setelah instalasi selesai, shutdown
virsh shutdown golden-build

# Sysprep
virt-sysprep -a /var/lib/libvirt/images/golden-build.qcow2

# Kompres dan jadikan golden
qemu-img convert -O qcow2 -c /var/lib/libvirt/images/golden-build.qcow2 /var/lib/libvirt/images/golden.qcow2
```

**Penjelasan kata demi kata:**
- `virt-install`: buat VM.
- `--name golden-build`: nama VM sementara.
- `--disk size=20,format=qcow2,path=...`: buat disk 20 GiB.
- `--cdrom`: ISO instalasi.
- `--os-variant archlinux`: optimasi Arch.
- `--graphics none --console pty,...`: headless.
- `virsh shutdown`: matikan graceful.
- `virt-sysprep -a`: siapkan image untuk cloning (hapus SSH host keys, machine-id, log, dll).
- `qemu-img convert -O qcow2 -c`: konversi ke qcow2 dengan kompresi.
- `-O qcow2`: format output.
- `-c`: kompres.
- `golden.qcow2`: output golden image.

### 4.2. Membuat Overlay

```bash
qemu-img create -f qcow2 -b /var/lib/libvirt/images/golden.qcow2 -F qcow2 /var/lib/libvirt/images/vm1.qcow2 20G
```

**Penjelasan kata demi kata:**
- `qemu-img create`: buat image baru.
- `-f qcow2`: format overlay.
- `-b /path/golden.qcow2`: backing file.
- `-F qcow2`: format backing file.
- `/path/vm1.qcow2`: file overlay.
- `20G`: ukuran virtual overlay. Bisa sama atau lebih besar dari base.

**Catatan:** Ukuran overlay harus >= base. Jika lebih kecil, error.

### 4.3. Menjalankan VM dengan Overlay

Menggunakan QEMU langsung:
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 2048 \
  -smp 2 \
  -cpu host \
  -nographic \
  -drive file=/var/lib/libvirt/images/vm1.qcow2,if=virtio,format=qcow2 \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0
```

**Penjelasan:**
- `-drive file=...`: gunakan overlay.
- QEMU otomatis membaca backing chain.

Menggunakan libvirt:
```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2'/>
  <source file='/var/lib/libvirt/images/vm1.qcow2'/>
  <backingStore type='file'>
    <format type='qcow2'/>
    <source file='/var/lib/libvirt/images/golden.qcow2'/>
  </backingStore>
  <target dev='vda' bus='virtio'/>
</disk>
```

**Penjelasan:**
- `<backingStore>`: opsional, libvirt bisa mendeteksi otomatis. Namun eksplisit lebih aman.

### 4.4. Melihat Info Backing Chain

```bash
qemu-img info --backing-chain /var/lib/libvirt/images/vm1.qcow2
```

**Output:**
```
image: /var/lib/libvirt/images/vm1.qcow2
file format: qcow2
virtual size: 20 GiB (21474836480 bytes)
disk size: 196 KiB
backing file: /var/lib/libvirt/images/golden.qcow2
backing file format: qcow2

image: /var/lib/libvirt/images/golden.qcow2
file format: qcow2
virtual size: 20 GiB (21474836480 bytes)
disk size: 2.1 GiB
```

**Penjelasan:**
- `--backing-chain`: tampilkan seluruh rantai.

### 4.5. Commit Overlay ke Base

```bash
qemu-img commit /var/lib/libvirt/images/vm1.qcow2
```

**Penjelasan:**
- `commit`: gabungkan perubahan overlay ke backing file.
- Setelah commit, overlay menjadi kosong (tidak ada backing).
- **Peringatan:** VM harus dimatikan.

### 4.6. Rebase Overlay ke Base Baru

```bash
qemu-img rebase -b /var/lib/libvirt/images/golden-v2.qcow2 -F qcow2 /var/lib/libvirt/images/vm1.qcow2
```

**Penjelasan:**
- `rebase`: ubah backing file.
- `-b`: backing baru.
- `-F`: format backing baru.

**Kegunaan:** Update golden image tanpa membuat ulang overlay.

### 4.7. Cek Konsistensi

```bash
qemu-img check /var/lib/libvirt/images/vm1.qcow2
```

**Output:**
```
No errors were found on the image.
```

### 4.8. Konversi ke Raw

```bash
qemu-img convert -f qcow2 -O raw /var/lib/libvirt/images/vm1.qcow2 /var/lib/libvirt/images/vm1.raw
```

**Penjelasan:**
- `-f qcow2`: format input.
- `-O raw`: format output.
- Berguna untuk performa atau kompatibilitas.

### 4.9. Resize Overlay

```bash
qemu-img resize /var/lib/libvirt/images/vm1.qcow2 +5G
```

**Penjelasan:**
- `+5G`: tambah 5 GiB.
- Guest harus resize filesystem.

### 4.10. Melihat Peta Blok

```bash
qemu-img map --output=json /var/lib/libvirt/images/vm1.qcow2
```

**Output:**
```json
[
  {"start": 0, "length": 65536, "depth": 1, "zero": false, "data": true, "offset": 32768}
]
```

**Penjelasan:**
- `depth`: lapisan tempat data berada.
- `data`: true jika ada data.

---

## 5. Diagram Alur & Arsitektur

### 5.1. Backing Chain

```
+-------------------+
|   golden.qcow2    |  (read-only, base)
+-------------------+
          ^
          | backing
+-------------------+
|    vm1.qcow2      |  (overlay, COW)
+-------------------+
          ^
          | backing
+-------------------+
|    vm1-snap.qcow2 |  (overlay kedua)
+-------------------+
```

### 5.2. Alur Pembuatan VM dari Golden

```
+-------------------+
|  Golden Image     |
|  (read-only)      |
+-------------------+
          |
          | qemu-img create -b
          v
+-------------------+
|  Overlay VM1      |
+-------------------+
          |
          | boot
          v
+-------------------+
|  VM1 Running      |
|  (perubahan ke    |
|   overlay)        |
+-------------------+
```

### 5.3. Commit

```
Sebelum commit:
base.qcow2 <- overlay.qcow2

Setelah commit:
base.qcow2 (berisi perubahan overlay)
overlay.qcow2 (kosong, tanpa backing)
```

### 5.4. Rebase

```
Sebelum rebase:
base-v1.qcow2 <- overlay.qcow2

Setelah rebase:
base-v2.qcow2 <- overlay.qcow2
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 4.1

Kurikulum asli hanya menyebut:
```bash
qemu-img create -f qcow2 -b golden.qcow2 -F qcow2 overlay.qcow2
```

Kita akan menambahkan:

1. `qemu-img info --backing-chain`
2. `qemu-img commit`
3. `qemu-img rebase`
4. `qemu-img amend`
5. `qemu-img check`
6. `qemu-img map`
7. `qemu-img resize`
8. `qemu-img convert -c`
9. `qemu-img compare`
10. `qemu-img dd`
11. `qemu-img bench`
12. XML `<backingStore>`
13. Bahaya chain depth
14. Praktik golden image: sysprep, sparsify
15. Read-only base
16. Absolute path untuk backing
17. Format `-F` wajib
18. Jangan boot langsung dari base

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 4.1.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.4 (Storage Pool & Volume):** Volume adalah unit penyimpanan. Overlay adalah volume dengan backing.
- **Modul 4.2 (Snapshot):** Snapshot eksternal menggunakan backing chain. blockcommit/blockpull menggabungkan lapisan.
- **Modul 4.3 (Clone):** `virt-clone` membuat clone dari overlay atau base.
- **Modul 4.4 (Edit Offline):** `guestfish` bisa membaca overlay dan backing chain.
- **Modul 4.5 (Backup):** Backup harus menyertakan seluruh rantai atau flatten.
- **Fase 5 (Networking):** Tidak terkait langsung.
- **Fase 6 (Keamanan):** Enkripsi qcow2 dengan LUKS.
- **Fase 7 (Otomasi):** Skrip untuk provisioning overlay massal.

---

## 8. Referensi Lengkap

- QEMU qemu-img documentation — https://www.qemu.org/docs/master/tools/qemu-img.html
- libvirt Storage XML — https://libvirt.org/formatstorage.html
- libvirt Domain XML disk — https://libvirt.org/formatdomain.html#hard-drives-floppy-disks-cdroms
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- qcow2 backing file — https://www.qemu.org/docs/master/interop/qcow2.html
- virt-sysprep — https://libguestfs.org/virt-sysprep.1.html
- virt-sparsify — https://libguestfs.org/virt-sparsify.1.html
- libguestfs — https://libguestfs.org/

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan `-F`** saat membuat overlay.
2. **Gunakan path absolut** untuk backing file.
3. **Jangan pernah boot langsung dari golden image.**
4. **Batasi chain depth maksimal 3.**
5. **Commit atau rebase secara berkala.**
6. **Gunakan `qemu-img check` setelah commit.**
7. **Simpan golden image di storage terpisah.**
8. **Beri label read-only pada file golden.**
9. **Gunakan `virt-sysprep` sebelum menjadikan golden.**
10. **Kompres golden dengan `qemu-img convert -c`.**
11. **Gunakan `virt-sparsify` untuk mengurangi ukuran.**
12. **Backup seluruh rantai, bukan hanya overlay.**
13. **Gunakan `qemu-img map` untuk audit.**
14. **Hindari resize backing file setelah overlay dibuat.**
15. **Gunakan `qemu-img rebase` untuk update base.**
16. **Gunakan `qemu-img commit` untuk flatten.**
17. **Jangan commit saat VM running.**
18. **Gunakan snapshot untuk perubahan sementara.**
19. **Monitor ukuran overlay dengan `qemu-img info`.**
20. **Dokumentasikan rantai.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `Backing file not found` | Path backing salah. | Gunakan path absolut. |
| `Format mismatch` | `-F` tidak sesuai. | Cek format dengan `qemu-img info`. |
| `Permission denied` | File tidak bisa diakses. | Cek permission, grup `libvirt`. |
| Overlay tidak bisa boot | Base rusak. | Cek `qemu-img check`. |
| Chain terlalu dalam | Banyak overlay. | Commit atau rebase. |
| Performa lambat | Chain depth. | Flatten. |
| Ukuran overlay membesar | Banyak perubahan. | Commit, buat overlay baru. |
| Base terubah | Boot langsung dari base. | Buat base read-only. |
| `qemu-img commit` gagal | VM running. | Matikan VM. |
| `qemu-img rebase` gagal | Backing baru tidak ada. | Cek path. |
| `qemu-img check` error | Image korup. | Restore dari backup. |
| Guest tidak bisa resize | Filesystem belum di-resize. | Resize di guest. |
| `qemu-img map` kosong | Tidak ada data. | Normal jika overlay kosong. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `qemu-img info --backing-chain overlay.qcow2` menampilkan base dan overlay.
- `qemu-img check overlay.qcow2` no errors.
- VM boot dari overlay.
- Perubahan tidak mengubah base.
- `qemu-img commit` berhasil.
- `qemu-img rebase` berhasil.
- `qemu-img map` menampilkan data.

**Troubleshooting:**
- Jika boot gagal: cek `qemu-img info`, cek backing.
- Jika performa lambat: cek chain depth, flatten.
- Jika commit gagal: matikan VM.
- Jika rebase gagal: cek path backing baru.
- Untuk audit: `qemu-img map`.
- Untuk verifikasi: `qemu-img compare`.

---

## 12. Latihan Mandiri

1. Buat golden image dari VM Arch minimal.
2. Jalankan `virt-sysprep` pada golden.
3. Kompres dengan `qemu-img convert -c`.
4. Buat 3 overlay dari golden.
5. Boot masing-masing overlay.
6. Cek `qemu-img info --backing-chain` untuk setiap overlay.
7. Lakukan perubahan di VM1.
8. Commit overlay VM1.
9. Cek apakah golden berubah? (Seharusnya tidak, karena commit ke overlay? Sebenarnya commit menggabungkan ke backing, jadi hati-hati. Untuk latihan, commit ke base salinan.)
10. Rebase overlay VM2 ke golden baru.
11. Resize overlay VM3.
12. Cek `qemu-img map`.
13. Buat snapshot dari overlay.
14. Tulis ringkasan: kapan menggunakan overlay, kapan commit, kapan rebase.

---

## 13. Penutup Modul 4.1

Anda kini memahami **Golden Image + Overlay Backing Chain** — fondasi efisiensi storage di Fase 4. Anda bisa membuat golden image, overlay, mengelola rantai, commit, rebase, dan menghindari jebakan umum. Ini adalah keterampilan yang akan Anda gunakan di Modul 4.2 (Snapshot), 4.3 (Clone), dan 4.5 (Backup).

---

## Audit Kurikulum untuk Modul 4.2

Kurikulum asli menyebut:
```bash
virsh snapshot-create-as arch-vm snap1
virsh blockcommit arch-vm vda --active --pivot
```

**Temuan audit:**
- Kurikulum belum membedakan **internal snapshot** vs **external snapshot**.
- Belum menyebut **`blockpull`**, **`blockcopy`**, **`snapshot-revert`**, **`snapshot-delete`**.
- Belum menyebut **QEMU internal snapshot** (`qemu-img snapshot`).
- Belum menyebut **XML `<backingStore>`** dan **metadata snapshot**.
- Belum membahas **bahaya snapshot chain** dan **cara flatten**.

**Rekomendasi:** Tambahkan poin-poin di atas ke dalam Modul 4.2 sebagai pengayaan. Materi berikut akan mencakup semuanya.

---

# Modul 4.2 — Snapshot Internal/External, blockcommit/blockpull

> *“Snapshot adalah mesin waktu. Tapi mesin waktu pun butuh perawatan.”*

## Mini-Daftar Isi Modul 4.2

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Snapshot & Block Operations
6. Audit Kurikulum: Tambahan Internal/External, blockpull, blockcopy, snapshot-revert/delete
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Snapshot** adalah **titik pemulihan** dari state VM pada waktu tertentu. Ada dua jenis utama:
- **Internal snapshot**: snapshot disimpan **di dalam file qcow2** yang sama. Hanya untuk qcow2. Bisa mencakup state disk dan memori.
- **External snapshot**: snapshot dibuat sebagai **file qcow2 baru** (overlay) yang menunjuk ke file lama sebagai backing. VM tetap berjalan, dan file lama menjadi read-only.

**blockcommit** dan **blockpull** adalah operasi untuk **menggabungkan** atau **menarik** data dari rantai snapshot, sehingga mengurangi kedalaman chain dan meningkatkan performa.

**Peran dalam kurikulum:** Modul ini adalah **jantung Fase 4**. Setelah Anda memahami backing chain (Modul 4.1), snapshot adalah aplikasi langsungnya. Ini juga fondasi untuk:
- **Modul 4.3 (Clone)**: clone sering menggunakan snapshot.
- **Modul 4.5 (Backup Live)**: backup live menggunakan `blockcopy` atau snapshot eksternal.
- **Fase 6 (Keamanan)**: snapshot untuk rollback setelah insiden.
- **Fase 7 (Otomasi)**: snapshot otomatis sebelum update.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Snapshot = Titik Pemulihan

Bayangkan Anda sedang menulis dokumen. Anda menekan Ctrl+S. Itu adalah snapshot. Jika nanti dokumen rusak, Anda bisa kembali ke versi terakhir. Di VM, snapshot menyimpan state disk (dan opsional memori) sehingga Anda bisa kembali ke titik itu.

**Filosofi:** *Snapshot adalah asuransi. Tapi asuransi tidak menggantikan backup.*

### 2.2. Internal vs External: Trade-off

| Aspek | Internal | External |
|---|---|---|
| Lokasi | Dalam file qcow2 | File qcow2 baru |
| VM state | Bisa disk + memori | Biasanya hanya disk |
| Live snapshot | Bisa, tapi pause singkat | Bisa, tanpa pause |
| Chain | Tidak menambah file | Menambah file |
| Kompatibilitas | Hanya qcow2 | qcow2, raw, dll |
| Manajemen | `qemu-img snapshot` | `virsh snapshot-*` |
| Performa | Sedikit overhead | Overhead chain |

**Filosofi:** *External lebih fleksibel untuk live snapshot. Internal lebih sederhana untuk rollback cepat.*

### 2.3. blockcommit: Menggabungkan ke Bawah

`blockcommit` menggabungkan data dari **overlay** ke **backing file**. Ini seperti menulis ulang sejarah: perubahan di overlay ditulis ke base, lalu overlay dihapus.

**Filosofi:** *blockcommit adalah “lunasi utang”. Setelah commit, chain lebih pendek.*

### 2.4. blockpull: Menarik ke Atas

`blockpull` menarik data dari **backing file** ke **overlay aktif**. Ini seperti memindahkan semua data dari base ke overlay, sehingga base tidak lagi diperlukan.

**Filosofi:** *blockpull adalah “flatten”. Setelah pull, VM hanya bergantung pada satu file.*

### 2.5. blockcopy: Menyalin Disk Saat Running

`blockcopy` menyalin disk VM ke file baru **saat VM berjalan**. Ini adalah dasar untuk backup live dan migrasi storage.

**Filosofi:** *blockcopy adalah “fotokopi” tanpa menghentikan mesin.*

### 2.6. Bahaya Chain Depth

Semakin panjang chain, semakin banyak I/O yang harus dibaca. Setiap snapshot eksternal menambah satu lapisan. Jika terlalu dalam, performa turun drastis.

**Filosofi:** *Snapshot adalah pedang bermata dua. Gunakan, lalu bersihkan.*

### 2.7. Filosofi Keseluruhan

- **Snapshot bukan backup.** Snapshot ada di storage yang sama; backup harus di lokasi terpisah.
- **External untuk live, internal untuk rollback cepat.**
- **blockcommit/blockpull untuk perawatan chain.**
- **blockcopy untuk backup live.**
- **Selalu uji restore.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Snapshot** | Titik pemulihan state VM. | `snap1` |
| **Internal snapshot** | Snapshot dalam file qcow2. | `qemu-img snapshot -c` |
| **External snapshot** | File overlay baru. | `virsh snapshot-create-as --disk-only` |
| **`virsh snapshot-create-as`** | Buat snapshot. | |
| **`virsh snapshot-list`** | Daftar snapshot. | |
| **`virsh snapshot-info`** | Info snapshot. | |
| **`virsh snapshot-revert`** | Kembali ke snapshot. | |
| **`virsh snapshot-delete`** | Hapus snapshot. | |
| **`qemu-img snapshot`** | Manajemen internal snapshot. | |
| **`blockcommit`** | Gabungkan overlay ke backing. | |
| **`blockpull`** | Tarik backing ke overlay. | |
| **`blockcopy`** | Copy disk saat running. | |
| **`--disk-only`** | Snapshot hanya disk, tanpa memori. | |
| **`--atomic`** | Operasi atomik. | |
| **`--active`** | Commit pada layer aktif. | |
| **`--pivot`** | Jadikan base baru sebagai aktif. | |
| **`--wait`** | Tunggu operasi selesai. | |
| **`--verbose`** | Tampilkan progres. | |
| **`--finish`** | Selesaikan blockcopy. | |
| **`--reuse-external`** | Gunakan file eksternal yang ada. | |
| **`--no-metadata`** | Jangan simpan metadata snapshot. | |
| **`--quiesce`** | Freeze filesystem via QGA. | |
| **`--memspec`** | Sertakan memori. | |
| **`--live`** | Snapshot live. | |
| **`--redefine`** | Definisikan ulang metadata. | |
| **`--current`** | Snapshot saat ini. | |
| **`--parent`** | Snapshot induk. | |
| **`--children`** | Hapus anak snapshot. | |
| **`--metadata`** | Hapus hanya metadata. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Internal Snapshot dengan QEMU

```bash
qemu-img snapshot -c snap1 disk.qcow2
qemu-img snapshot -l disk.qcow2
qemu-img snapshot -a snap1 disk.qcow2
qemu-img snapshot -d snap1 disk.qcow2
```

**Penjelasan kata demi kata:**
- `qemu-img snapshot`: perintah manajemen snapshot internal.
- `-c snap1`: create snapshot dengan nama `snap1`.
- `-l`: list snapshot.
- `-a snap1`: apply (revert) ke snapshot `snap1`.
- `-d snap1`: delete snapshot `snap1`.
- `disk.qcow2`: file qcow2.

**Catatan:** Internal snapshot hanya untuk qcow2. Tidak bisa untuk raw.

### 4.2. Internal Snapshot dengan libvirt

```bash
virsh snapshot-create-as arch-vm snap1 "Before upgrade" --disk-only --atomic
virsh snapshot-list arch-vm
virsh snapshot-info arch-vm snap1
virsh snapshot-revert arch-vm snap1
virsh snapshot-delete arch-vm snap1
```

**Penjelasan kata demi kata:**
- `virsh snapshot-create-as`: buat snapshot dengan nama.
- `arch-vm`: nama domain.
- `snap1`: nama snapshot.
- `"Before upgrade"`: deskripsi.
- `--disk-only`: hanya disk, tanpa memori.
- `--atomic`: operasi atomik.
- `virsh snapshot-list`: daftar snapshot.
- `virsh snapshot-info`: info snapshot.
- `virsh snapshot-revert`: kembali ke snapshot.
- `virsh snapshot-delete`: hapus snapshot.

**Output `snapshot-list`:**
```
 Name   Creation Time               State
-------------------------------------------------
 snap1  2024-01-15 10:00:00 +0700  disk-snapshot
```

### 4.3. External Snapshot

```bash
virsh snapshot-create-as arch-vm snap-ext "External snapshot" \
  --disk-only --atomic --no-metadata \
  --diskspec vda,file=/var/lib/libvirt/images/arch-vm.snap-ext.qcow2
```

**Penjelasan kata demi kata:**
- `--disk-only`: hanya disk.
- `--atomic`: atomik.
- `--no-metadata`: jangan simpan metadata di libvirt (snapshot tidak terlihat di `snapshot-list`). Berguna untuk snapshot sementara.
- `--diskspec vda,file=...`: spesifikasi disk. `vda` adalah target disk. `file=` adalah path overlay baru.

**Setelah eksekusi:**
- File `arch-vm.snap-ext.qcow2` dibuat.
- Disk asli menjadi backing.
- VM tetap running.

### 4.4. Melihat Chain Setelah External Snapshot

```bash
qemu-img info --backing-chain /var/lib/libvirt/images/arch-vm.snap-ext.qcow2
```

**Output:**
```
image: /var/lib/libvirt/images/arch-vm.snap-ext.qcow2
file format: qcow2
virtual size: 20 GiB
backing file: /var/lib/libvirt/images/arch-vm.qcow2
```

### 4.5. blockcommit

```bash
virsh blockcommit arch-vm vda --active --pivot --verbose
```

**Penjelasan kata demi kata:**
- `virsh blockcommit`: gabungkan overlay ke backing.
- `arch-vm`: nama domain.
- `vda`: target disk.
- `--active`: commit pada layer aktif.
- `--pivot`: jadikan base baru sebagai aktif.
- `--verbose`: tampilkan progres.

**Output:**
```
Block Commit: [100 %]
Successfully pivoted
```

**Efek:**
- Overlay digabung ke base.
- Base menjadi aktif.
- Chain lebih pendek.

### 4.6. blockpull

```bash
virsh blockpull arch-vm vda --wait --verbose
```

**Penjelasan kata demi kata:**
- `virsh blockpull`: tarik data dari backing ke overlay.
- `--wait`: tunggu selesai.
- `--verbose`: progres.

**Output:**
```
Block Pull: [100 %]
Pull complete
```

**Efek:**
- Data dari base ditarik ke overlay.
- Overlay menjadi mandiri.
- Base tidak lagi diperlukan.

### 4.7. blockcopy

```bash
virsh blockcopy arch-vm vda /backup/arch-vm-copy.qcow2 --wait --verbose --finish
```

**Penjelasan kata demi kata:**
- `virsh blockcopy`: copy disk saat running.
- `vda`: target disk.
- `/backup/...`: file tujuan.
- `--wait`: tunggu.
- `--verbose`: progres.
- `--finish`: selesaikan dan gunakan file baru sebagai disk aktif.

**Kegunaan:** Backup live, migrasi storage.

### 4.8. Snapshot dengan QGA Quiesce

```bash
virsh snapshot-create-as arch-vm snap-quiesce "Quiesced" \
  --disk-only --atomic --quiesce
```

**Penjelasan:**
- `--quiesce`: freeze filesystem via QGA sebelum snapshot.
- Menghasilkan snapshot konsisten.

**Prasyarat:** QGA berjalan di guest.

### 4.9. Snapshot dengan Memori

```bash
virsh snapshot-create-as arch-vm snap-mem "With memory" --memspec file=/var/lib/libvirt/images/snap-mem.save
```

**Penjelasan:**
- `--memspec`: sertakan state memori.
- `file=`: path file memori.
- Snapshot ini bisa revert ke state running.

### 4.10. Menghapus Snapshot

```bash
virsh snapshot-delete arch-vm snap1
virsh snapshot-delete arch-vm snap1 --metadata
virsh snapshot-delete arch-vm snap1 --children
```

**Penjelasan:**
- `snapshot-delete`: hapus snapshot.
- `--metadata`: hapus hanya metadata, bukan file.
- `--children`: hapus juga snapshot anak.

### 4.11. Revert Snapshot

```bash
virsh snapshot-revert arch-vm snap1
virsh snapshot-revert arch-vm snap1 --running
virsh snapshot-revert arch-vm snap1 --paused
```

**Penjelasan:**
- `snapshot-revert`: kembali ke snapshot.
- `--running`: state running.
- `--paused`: state paused.

### 4.12. XML Setelah External Snapshot

```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2'/>
  <source file='/var/lib/libvirt/images/arch-vm.snap-ext.qcow2'/>
  <backingStore type='file'>
    <format type='qcow2'/>
    <source file='/var/lib/libvirt/images/arch-vm.qcow2'/>
  </backingStore>
  <target dev='vda' bus='virtio'/>
</disk>
```

**Penjelasan:**
- `<source file>`: overlay baru.
- `<backingStore>`: base lama.

---

## 5. Diagram Arsitektur Snapshot & Block Operations

### 5.1. Internal Snapshot

```
+-------------------+
|   disk.qcow2      |
|  +-------------+  |
|  | snap1       |  |
|  | snap2       |  |
|  +-------------+  |
+-------------------+
```

### 5.2. External Snapshot Chain

```
+-------------------+
|   base.qcow2      |  (read-only)
+-------------------+
          ^
          | backing
+-------------------+
|   snap1.qcow2     |
+-------------------+
          ^
          | backing
+-------------------+
|   snap2.qcow2     |  (aktif)
+-------------------+
```

### 5.3. blockcommit

```
Sebelum:
base.qcow2 <- snap1.qcow2 <- snap2.qcow2 (aktif)

Setelah blockcommit snap2 ke snap1:
base.qcow2 <- snap1.qcow2 (aktif, berisi data snap2)

Setelah blockcommit snap1 ke base:
base.qcow2 (aktif, berisi semua data)
```

### 5.4. blockpull

```
Sebelum:
base.qcow2 <- snap1.qcow2 (aktif)

Setelah blockpull:
snap1.qcow2 (aktif, berisi semua data dari base)
base.qcow2 (tidak diperlukan)
```

### 5.5. blockcopy

```
+-------------------+
|   VM running      |
+-------------------+
          |
          | blockcopy
          v
+-------------------+
|   copy.qcow2      |
+-------------------+
```

### 5.6. Alur Snapshot & Commit

```
+-------------------+
|  VM Running       |
+-------------------+
          |
          | snapshot-create-as --disk-only
          v
+-------------------+
|  Overlay Baru     |
+-------------------+
          |
          | blockcommit --active --pivot
          v
+-------------------+
|  Chain Lebih      |
|  Pendek           |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan Internal/External, blockpull, blockcopy, snapshot-revert/delete

Kurikulum asli hanya menyebut:
```bash
virsh snapshot-create-as arch-vm snap1
virsh blockcommit arch-vm vda --active --pivot
```

Kita akan menambahkan:

1. **Internal vs External snapshot** — perbedaan, trade-off.
2. **`qemu-img snapshot`** — internal snapshot.
3. **`virsh snapshot-create-as --disk-only --atomic`** — external snapshot.
4. **`--no-metadata`** — snapshot tanpa metadata.
5. **`--quiesce`** — snapshot konsisten via QGA.
6. **`--memspec`** — snapshot dengan memori.
7. **`virsh snapshot-list`** — daftar snapshot.
8. **`virsh snapshot-info`** — info snapshot.
9. **`virsh snapshot-revert`** — revert.
10. **`virsh snapshot-delete`** — hapus.
11. **`blockcommit --active --pivot`** — commit.
12. **`blockpull --wait`** — pull.
13. **`blockcopy --wait --finish`** — copy.
14. **XML `<backingStore>`** — representasi chain.
15. **Bahaya chain depth** — performa.
16. **Perawatan chain** — commit/pull berkala.
17. **Snapshot bukan backup** — peringatan.
18. **Uji restore** — validasi.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 4.2.

---

## 7. Hubungan dengan Modul Lain

- **Modul 4.1 (Golden Image + Overlay):** Snapshot eksternal adalah overlay. Backing chain adalah dasar.
- **Modul 4.3 (Clone):** Clone menggunakan snapshot atau overlay.
- **Modul 4.4 (Edit Offline):** Snapshot bisa di-edit offline.
- **Modul 4.5 (Backup Live):** blockcopy untuk backup live.
- **Fase 5 (Networking):** Tidak terkait langsung.
- **Fase 6 (Keamanan):** Snapshot untuk rollback setelah insiden.
- **Fase 7 (Otomasi):** Snapshot otomatis sebelum update.
- **Fase 8 (Expert):** Live migration menggunakan blockcopy.

---

## 8. Referensi Lengkap

- libvirt Snapshot XML — https://libvirt.org/formatsnapshot.html
- virsh snapshot-create-as — https://libvirt.org/manpages/virsh.html#snapshot-create-as
- virsh snapshot-list — https://libvirt.org/manpages/virsh.html#snapshot-list
- virsh snapshot-revert — https://libvirt.org/manpages/virsh.html#snapshot-revert
- virsh snapshot-delete — https://libvirt.org/manpages/virsh.html#snapshot-delete
- virsh blockcommit — https://libvirt.org/manpages/virsh.html#blockcommit
- virsh blockpull — https://libvirt.org/manpages/virsh.html#blockpull
- virsh blockcopy — https://libvirt.org/manpages/virsh.html#blockcopy
- QEMU qemu-img snapshot — https://www.qemu.org/docs/master/tools/qemu-img.html#snapshot
- QEMU qcow2 — https://www.qemu.org/docs/master/interop/qcow2.html
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- libguestfs — https://libguestfs.org/

---

## 9. Tips & Praktik Terbaik

1. **Gunakan external snapshot untuk VM running.**
2. **Gunakan internal snapshot untuk rollback cepat.**
3. **Selalu `--atomic` untuk snapshot.**
4. **Gunakan `--quiesce` untuk snapshot konsisten.**
5. **Jangan biarkan chain terlalu dalam.**
6. **Lakukan `blockcommit` setelah snapshot tidak diperlukan.**
7. **Gunakan `blockpull` untuk flatten.**
8. **Gunakan `blockcopy` untuk backup live.**
9. **Uji restore snapshot secara berkala.**
10. **Snapshot bukan backup.**
11. **Simpan snapshot di storage terpisah.**
12. **Hapus snapshot lama.**
13. **Monitor chain depth dengan `qemu-img info --backing-chain`.**
14. **Gunakan `--verbose` untuk melihat progres.**
15. **Gunakan `--wait` untuk scripting.**
16. **Jangan revert saat VM running tanpa peringatan.**
17. **Gunakan `--no-metadata` untuk snapshot sementara.**
18. **Gunakan `--memspec` hanya jika perlu.**
19. **Dokumentasikan snapshot.**
20. **Gunakan QGA untuk quiesce.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `snapshot-create-as` gagal | Disk bukan qcow2. | Gunakan qcow2. |
| `snapshot-create-as` gagal | VM running tanpa `--disk-only`. | Tambahkan `--disk-only`. |
| `blockcommit` gagal | VM running tanpa `--active`. | Tambahkan `--active`. |
| `blockcommit` gagal | Chain tidak valid. | Cek `qemu-img info --backing-chain`. |
| `blockpull` gagal | Tidak ada backing. | Cek chain. |
| `blockcopy` gagal | File tujuan ada. | Hapus atau gunakan `--reuse-external`. |
| `snapshot-revert` gagal | VM running. | Matikan atau gunakan `--running`. |
| `snapshot-delete` gagal | Snapshot memiliki anak. | Gunakan `--children`. |
| Chain terlalu dalam | Banyak snapshot. | Commit/pull. |
| Performa lambat | Chain depth. | Flatten. |
| Snapshot korup | Storage penuh. | Cek space. |
| QGA quiesce gagal | QGA tidak berjalan. | Instal QGA. |
| Metadata hilang | `--no-metadata`. | Tidak muncul di `snapshot-list`. |
| Revert menghilangkan data | Snapshot lama. | Backup dulu. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh snapshot-create-as arch-vm snap1 --disk-only --atomic` berhasil.
- `virsh snapshot-list arch-vm` menampilkan snapshot.
- `virsh snapshot-info arch-vm snap1` menampilkan info.
- `virsh snapshot-revert arch-vm snap1` berhasil.
- `virsh snapshot-delete arch-vm snap1` berhasil.
- `qemu-img snapshot -c snap1 disk.qcow2` berhasil.
- `qemu-img snapshot -l disk.qcow2` menampilkan snapshot.
- `virsh blockcommit arch-vm vda --active --pivot` berhasil.
- `virsh blockpull arch-vm vda --wait` berhasil.
- `virsh blockcopy arch-vm vda /backup/copy.qcow2 --wait --finish` berhasil.
- `qemu-img info --backing-chain` menampilkan chain yang benar.

**Troubleshooting:**
- Jika snapshot gagal: cek format disk.
- Jika blockcommit gagal: cek `--active`.
- Jika blockpull gagal: cek backing.
- Jika blockcopy gagal: cek file tujuan.
- Jika revert gagal: cek state VM.
- Jika delete gagal: cek anak snapshot.
- Jika chain dalam: commit/pull.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk log: `journalctl -u virtqemud`, `/var/log/libvirt/qemu/`.
- Untuk validasi: `qemu-img check`.

---

## 12. Latihan Mandiri

1. Buat VM dengan disk qcow2.
2. Buat internal snapshot dengan `qemu-img snapshot -c snap1 disk.qcow2`.
3. List: `qemu-img snapshot -l disk.qcow2`.
4. Revert: `qemu-img snapshot -a snap1 disk.qcow2`.
5. Hapus: `qemu-img snapshot -d snap1 disk.qcow2`.
6. Buat external snapshot: `virsh snapshot-create-as arch-vm snap-ext --disk-only --atomic`.
7. Cek chain: `qemu-img info --backing-chain`.
8. Lakukan perubahan di VM.
9. Commit: `virsh blockcommit arch-vm vda --active --pivot --verbose`.
10. Cek chain lagi.
11. Buat snapshot lagi, lalu pull: `virsh blockpull arch-vm vda --wait --verbose`.
12. Cek chain.
13. Buat snapshot dengan quiesce: `--quiesce`.
14. Buat snapshot dengan memori: `--memspec`.
15. Revert snapshot.
16. Hapus snapshot.
17. Backup live dengan blockcopy.
18. Uji restore dari backup.
19. Tulis ringkasan: kapan internal vs external, kapan commit vs pull.

---

## 13. Penutup Modul 4.2

Anda kini menguasai **Snapshot Internal/External, blockcommit/blockpull, dan blockcopy**. Anda bisa membuat titik pemulihan, mengelola rantai, menggabungkan atau menarik data, serta melakukan backup live. Anda memahami trade-off internal vs external dan pentingnya perawatan chain. Ini adalah fondasi untuk Modul 4.3 (Clone), 4.4 (Edit Offline), dan 4.5 (Backup Live).

---

*Motivasi: Snapshot adalah jembatan waktu. Namun, waktu tidak bisa dibiarkan menumpuk. Rawatlah rantai, dan VM Anda akan selalu siap kembali.*

---

## Audit Kurikulum untuk Modul 4.3

Kurikulum asli menyebut:
```bash
virt-sysprep -a golden.qcow2
virt-customize -a golden.qcow2 --hostname vm1
virt-clone --original arch-vm --name clone1 --file clone1.qcow2
```

**Temuan audit:**
- Kurikulum belum menyebut **`virt-sparsify`** (mengurangi ukuran image).
- Belum menyebut **`virt-resize`** (mengubah ukuran partisi/filesystem).
- Belum menyebut **`virt-builder`** (membuat image dari template).
- Belum menyebut **`virt-df`**, **`virt-filesystems`**, **`virt-inspector`**, **`virt-ls`**, **`virt-cat`**, **`virt-edit`** — alat-alat libguestfs yang sangat berguna.
- Belum menyebut **`guestfish`** secara eksplisit (meski sudah ada di Modul 4.4).
- Belum menyebut **`virt-install --import`** untuk boot dari golden image.
- Belum menyebut **`--firstboot`** dan **`--run`** di `virt-customize`.

**Rekomendasi:** Tambahkan poin-poin di atas ke dalam Modul 4.3 sebagai pengayaan. Materi berikut akan mencakup semuanya.

---

# Modul 4.3 — virt-sysprep, virt-customize, virt-clone

> *“Clone bukan sekadar salin. Ia adalah kelahiran yang bersih.”*

## Mini-Daftar Isi Modul 4.3

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur libguestfs & Alur Clone
6. Audit Kurikulum: Tambahan virt-sparsify, virt-resize, virt-builder, virt-df, dll
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**virt-sysprep**, **virt-customize**, dan **virt-clone** adalah tiga alat kunci untuk **mempersiapkan**, **menyesuaikan**, dan **menduplikasi** image disk VM. Mereka adalah bagian dari **libguestfs**, kumpulan alat yang memungkinkan Anda memanipulasi image disk **tanpa harus mem-boot VM**.

- **`virt-sysprep`**: menghapus identitas unik dari image (SSH host keys, machine-id, log, cache, dsb) agar image siap di-clone.
- **`virt-customize`**: menyesuaikan image (hostname, password, user, install paket, jalankan skrip) sebelum boot pertama.
- **`virt-clone`**: menduplikasi VM yang sudah ada (XML + disk) menjadi VM baru.

**Peran dalam kurikulum:** Modul ini adalah **inti dari image engineering**. Setelah Anda memahami golden image dan overlay (Modul 4.1) serta snapshot (Modul 4.2), Modul 4.3 mengajarkan cara **membuat** dan **menyesuaikan** image secara terprogram. Ini adalah fondasi untuk:
- **Modul 4.4 (Edit Offline)**: `guestfish` memperdalam manipulasi.
- **Modul 4.5 (Backup Live)**: clone dan sysprep digunakan untuk disaster recovery.
- **Fase 7 (Otomasi)**: provisioning massal dengan `virt-customize` dan `cloud-init`.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. libguestfs: Akses Tanpa Boot

libguestfs menjalankan **VM kecil** (appliance) yang me-mount image Anda, lalu menjalankan perintah di dalamnya. Anda tidak perlu mem-boot image. Ini berarti:
- Tidak perlu khawatir tentang driver guest.
- Bisa mengedit image yang rusak.
- Bisa membaca filesystem Linux, Windows, BSD.

**Filosofi:** *Image adalah data. Data bisa dibaca tanpa dihidupkan.*

### 2.2. sysprep: Menghapus Identitas

Setiap VM memiliki identitas unik:
- SSH host keys.
- `/etc/machine-id`.
- MAC address di konfigurasi jaringan.
- Log, cache, history.
- Kredensial.

Jika Anda meng-clone VM tanpa sysprep, **semua clone akan memiliki identitas yang sama** — berbahaya! `virt-sysprep` menghapus identitas ini sehingga setiap clone "lahir baru".

**Filosofi:** *Clone harus berbeda. sysprep memastikan perbedaan.*

### 2.3. customize: Personalisasi Sebelum Boot

`virt-customize` memungkinkan Anda:
- Mengubah hostname.
- Menambah user, password, SSH key.
- Menginstall paket.
- Menjalankan skrip.
- Mengatur layanan.

Semua ini dilakukan **tanpa mem-boot VM**. Ini adalah fondasi untuk **provisioning otomatis**.

**Filosofi:** *VM harus lahir dengan konfigurasi yang benar.*

### 2.4. virt-clone: Duplikasi VM Lengkap

`virt-clone` menduplikasi:
- XML domain.
- Disk.
- Konfigurasi.

Namun, **tidak** melakukan sysprep otomatis. Anda harus menjalankan `virt-sysprep` sebelum atau sesudah clone.

**Filosofi:** *Clone adalah salinan. Sysprep adalah pembersih.*

### 2.5. libguestfs: Satu Set Alat, Banyak Kegunaan

libguestfs menyediakan banyak alat:
- `virt-sysprep`: siapkan image.
- `virt-customize`: sesuaikan image.
- `virt-clone`: duplikasi VM.
- `virt-sparsify`: kurangi ukuran.
- `virt-resize`: ubah ukuran.
- `virt-builder`: buat image dari template.
- `virt-df`: lihat penggunaan disk.
- `virt-filesystems`: lihat filesystem.
- `virt-inspector`: inspeksi OS.
- `virt-ls`: list direktori.
- `virt-cat`: baca file.
- `virt-edit`: edit file.
- `guestfish`: shell interaktif.
- `guestmount`: mount image.

**Filosofi:** *Satu appliance, banyak perintah.*

### 2.6. Filosofi Keseluruhan

- **Sysprep adalah pembersihan.** Lakukan sebelum clone.
- **Customize adalah personalisasi.** Lakukan sebelum boot pertama.
- **Clone adalah duplikasi.** Lakukan dengan hati-hati.
- **libguestfs adalah toolbox.** Gunakan sesuai kebutuhan.
- **Otomasi adalah tujuan.** Semua bisa di-script.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **libguestfs** | Kumpulan alat untuk manipulasi image. | `virt-*` |
| **appliance** | VM kecil yang menjalankan libguestfs. | |
| **virt-sysprep** | Siapkan image untuk cloning. | |
| **virt-customize** | Sesuaikan image. | |
| **virt-clone** | Duplikasi VM. | |
| **virt-sparsify** | Kurangi ukuran image. | |
| **virt-resize** | Ubah ukuran partisi. | |
| **virt-builder** | Buat image dari template. | |
| **virt-df** | Lihat penggunaan disk. | |
| **virt-filesystems** | Lihat filesystem. | |
| **virt-inspector** | Inspeksi OS. | |
| **virt-ls** | List direktori. | |
| **virt-cat** | Baca file. | |
| **virt-edit** | Edit file. | |
| **guestfish** | Shell interaktif. | |
| **guestmount** | Mount image. | |
| **machine-id** | ID unik sistem. | `/etc/machine-id` |
| **SSH host keys** | Kunci host SSH. | `/etc/ssh/ssh_host_*` |
| **`--firstboot`** | Skrip saat boot pertama. | |
| **`--run`** | Skrip saat customize. | |
| **`--hostname`** | Set hostname. | |
| **`--root-password`** | Set password root. | |
| **`--ssh-inject`** | Inject SSH key. | |
| **`--install`** | Install paket. | |
| **`--update`** | Update paket. | |
| **`--copy-in`** | Copy file ke image. | |
| **`--mkdir`** | Buat direktori. | |
| **`--chmod`** | Ubah permission. | |
| **`--link`** | Buat symlink. | |
| **`--truncate`** | Potong file. | |
| **`--write`** | Tulis file. | |
| **`--append-line`** | Tambah baris. | |
| **`--delete`** | Hapus file. | |
| **`--move`** | Pindah file. | |
| **`--touch`** | Buat file kosong. | |
| **`--upload`** | Upload file. | |
| **`--download`** | Download file. | |
| **`--format`** | Format image. | |
| **`--network`** | Aktifkan jaringan di appliance. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Instalasi libguestfs

```bash
sudo pacman -S libguestfs
```

**Penjelasan:**
- `libguestfs`: paket utama.
- Menyediakan semua alat `virt-*` dan `guestfish`.

**Catatan:** Di Arch, libguestfs mungkin memerlukan konfigurasi tambahan. Cek `/etc/libguestfs-tools.conf`.

### 4.2. virt-sysprep: Dasar

```bash
virt-sysprep -a /var/lib/libvirt/images/golden.qcow2
```

**Penjelasan kata demi kata:**
- `virt-sysprep`: perintah sysprep.
- `-a /path`: image yang akan diproses.
- Tanpa opsi lain, menjalankan **semua operasi default**.

**Operasi default:**
- Hapus SSH host keys.
- Hapus `/etc/machine-id`.
- Hapus log.
- Hapus cache.
- Hapus history.
- Hapus kredensial.
- Hapus MAC address.
- Reset hostname.
- Dll.

### 4.3. virt-sysprep: List Operasi

```bash
virt-sysprep --list-operations
```

**Output:**
```
abrt-data
backup-files
bash-history
blkid-tab
crash-data
cron-spool
customize
dhcp-client-state
dhcp-server-state
dovecot-data
logfiles
machine-id
mail-spool
net-hostname
net-hwaddr
pacct-log
package-manager-cache
pam-data
passwd-backups
puppet-data-log
rh-subscription-manager
rhn-systemid
rpm-db
samba-db-log
script
smolt-uuid
ssh-hostkeys
ssh-userdir
sssd-db-log
tmp-files
udev-persistent-net
utmp
yum-uuid
```

**Penjelasan:** Setiap operasi adalah pembersihan spesifik.

### 4.4. virt-sysprep: Pilih Operasi

```bash
virt-sysprep -a golden.qcow2 --enable ssh-hostkeys,machine-id
virt-sysprep -a golden.qcow2 --disable logfiles
```

**Penjelasan:**
- `--enable`: aktifkan hanya operasi tertentu.
- `--disable`: nonaktifkan operasi tertentu.

### 4.5. virt-sysprep: Dry Run

```bash
virt-sysprep -a golden.qcow2 --dry-run
```

**Penjelasan:**
- `--dry-run`: simulasi tanpa eksekusi.
- Berguna untuk melihat apa yang akan dihapus.

### 4.6. virt-sysprep: Verbose

```bash
virt-sysprep -a golden.qcow2 -v
virt-sysprep -a golden.qcow2 -x
```

**Penjelasan:**
- `-v`: verbose.
- `-x`: trace perintah.

### 4.7. virt-customize: Dasar

```bash
virt-customize -a golden.qcow2 --hostname vm1
```

**Penjelasan kata demi kata:**
- `virt-customize`: perintah customize.
- `-a golden.qcow2`: image.
- `--hostname vm1`: set hostname.

### 4.8. virt-customize: Set Password Root

```bash
virt-customize -a golden.qcow2 --root-password password:secret
virt-customize -a golden.qcow2 --root-password file:/path/to/password
virt-customize -a golden.qcow2 --root-password random
```

**Penjelasan:**
- `password:secret`: set password langsung.
- `file:/path`: baca dari file.
- `random`: generate password acak.

### 4.9. virt-customize: Tambah User

```bash
virt-customize -a golden.qcow2 \
  --run-command 'useradd -m -s /bin/bash user1' \
  --run-command 'echo "user1:secret" | chpasswd'
```

**Penjelasan:**
- `--run-command`: jalankan perintah di image.
- `useradd`: buat user.
- `chpasswd`: set password.

### 4.10. virt-customize: Inject SSH Key

```bash
virt-customize -a golden.qcow2 \
  --ssh-inject root:file:/root/.ssh/id_rsa.pub
```

**Penjelasan:**
- `--ssh-inject`: inject SSH key.
- `root:file:/path`: untuk user `root`, baca dari file.

### 4.11. virt-customize: Install Paket

```bash
virt-customize -a golden.qcow2 \
  --install nginx,git,vim \
  --update
```

**Penjelasan:**
- `--install`: install paket.
- `--update`: update semua paket.

**Catatan:** Memerlukan jaringan di appliance. Gunakan `--network`.

### 4.12. virt-customize: Copy File

```bash
virt-customize -a golden.qcow2 \
  --copy-in /host/config.conf:/etc/ \
  --mkdir /etc/myapp \
  --chmod 0644:/etc/config.conf
```

**Penjelasan:**
- `--copy-in`: copy file dari host ke image.
- `--mkdir`: buat direktori.
- `--chmod`: ubah permission.

### 4.13. virt-customize: First Boot Script

```bash
virt-customize -a golden.qcow2 \
  --firstboot /path/to/firstboot.sh
```

**Penjelasan:**
- `--firstboot`: skrip yang dijalankan saat boot pertama.
- Setelah dijalankan, skrip dihapus.

**Kegunaan:** Konfigurasi yang memerlukan VM berjalan (mis. regenerate SSH keys).

### 4.14. virt-customize: Run Script

```bash
virt-customize -a golden.qcow2 \
  --run /path/to/script.sh
```

**Penjelasan:**
- `--run`: jalankan skrip di image.
- Berbeda dengan `--firstboot`, `--run` dijalankan saat customize.

### 4.15. virt-customize: Timezone

```bash
virt-customize -a golden.qcow2 --timezone Asia/Jakarta
```

**Penjelasan:**
- `--timezone`: set timezone.

### 4.16. virt-customize: Network

```bash
virt-customize -a golden.qcow2 --network
```

**Penjelasan:**
- `--network`: aktifkan jaringan di appliance.
- Diperlukan untuk `--install`, `--update`.

### 4.17. virt-clone: Dasar

```bash
virt-clone --original arch-vm --name clone1 --file /var/lib/libvirt/images/clone1.qcow2
```

**Penjelasan kata demi kata:**
- `virt-clone`: perintah clone.
- `--original arch-vm`: VM sumber.
- `--name clone1`: nama VM baru.
- `--file /path/clone1.qcow2`: path disk baru.

**Output:**
```
Allocating 'clone1.qcow2'  | 20 GB  00:00:05
Clone 'clone1' created successfully.
```

### 4.18. virt-clone: Auto Clone

```bash
virt-clone --original arch-vm --auto-clone
```

**Penjelasan:**
- `--auto-clone`: generate nama dan path otomatis.

### 4.19. virt-clone: Multiple Disks

```bash
virt-clone --original arch-vm --name clone1 \
  --file /var/lib/libvirt/images/clone1-vda.qcow2 \
  --file /var/lib/libvirt/images/clone1-vdb.qcow2
```

**Penjelasan:**
- Multiple `--file` untuk multiple disk.

### 4.20. virt-clone: Preserve

```bash
virt-clone --original arch-vm --name clone1 --auto-clone --preserve-data
```

**Penjelasan:**
- `--preserve-data`: jangan hapus disk sumber.
- Berguna untuk testing.

### 4.21. virt-sparsify: Kurangi Ukuran

```bash
virt-sparsify --compress golden.qcow2 golden-sparse.qcow2
virt-sparsify --in-place golden.qcow2
```

**Penjelasan kata demi kata:**
- `virt-sparsify`: kurangi ukuran image.
- `--compress`: kompres output.
- `--in-place`: modifikasi langsung.

**Kegunaan:** Hapus blok kosong, kurangi ukuran file.

### 4.22. virt-resize: Ubah Ukuran

```bash
virt-resize --expand /dev/sda1 old.qcow2 new.qcow2
virt-resize --shrink /dev/sda1 old.qcow2 new.qcow2
```

**Penjelasan:**
- `--expand /dev/sda1`: perluas partisi.
- `--shrink`: perkecil.
- `old.qcow2`: input.
- `new.qcow2`: output.

### 4.23. virt-builder: Buat Image dari Template

```bash
virt-builder archlinux --output arch.qcow2 --size 10G
virt-builder --list
```

**Penjelasan:**
- `virt-builder`: buat image dari template.
- `archlinux`: template.
- `--output`: output.
- `--size`: ukuran.

### 4.24. virt-df: Penggunaan Disk

```bash
virt-df -a golden.qcow2
virt-df -a golden.qcow2 -h
```

**Output:**
```
Filesystem                    1K-blocks    Used Available Use%
golden.qcow2:/dev/sda1         20971520 5000000  15971520  24%
```

### 4.25. virt-filesystems: Lihat Filesystem

```bash
virt-filesystems -a golden.qcow2 --all --long -h
```

**Output:**
```
Name       Type       VFS   Label  Size  Parent
/dev/sda1  filesystem ext4  -      20G   -
/dev/sda   device     -     -      20G   -
```

### 4.26. virt-inspector: Inspeksi OS

```bash
virt-inspector -a golden.qcow2
virt-inspector -a golden.qcow2 --xml
```

**Output:**
```xml
<operatingsystems>
  <operatingsystem>
    <name>linux</name>
    <distro>archlinux</distro>
    <product_name>Arch Linux</product_name>
    ...
  </operatingsystem>
</operatingsystems>
```

### 4.27. virt-ls: List Direktori

```bash
virt-ls -a golden.qcow2 -l /etc
virt-ls -a golden.qcow2 -R /etc/ssh
```

**Penjelasan:**
- `-l`: long format.
- `-R`: recursive.

### 4.28. virt-cat: Baca File

```bash
virt-cat -a golden.qcow2 /etc/hostname
virt-cat -a golden.qcow2 /etc/os-release
```

**Penjelasan:**
- `virt-cat`: baca file dari image.

### 4.29. virt-edit: Edit File

```bash
virt-edit -a golden.qcow2 /etc/hostname
virt-edit -a golden.qcow2 /etc/hostname -e 's/old/new/'
```

**Penjelasan:**
- `virt-edit`: edit file.
- `-e`: ekspresi sed.

### 4.30. Contoh Lengkap: Golden Image Workflow

```bash
#!/bin/bash
set -e

GOLDEN="/var/lib/libvirt/images/golden.qcow2"

# 1. Sysprep
virt-sysprep -a "$GOLDEN"

# 2. Customize
virt-customize -a "$GOLDEN" \
  --hostname template \
  --timezone Asia/Jakarta \
  --root-password password:changeme \
  --ssh-inject root:file:/root/.ssh/id_rsa.pub \
  --install qemu-guest-agent,vim,curl \
  --update

# 3. Sparsify
virt-sparsify --compress "$GOLDEN" "${GOLDEN%.qcow2}-sparse.qcow2"

# 4. Verify
qemu-img info "${GOLDEN%.qcow2}-sparse.qcow2"
```

**Penjelasan:**
- Sysprep dulu.
- Customize.
- Sparsify.
- Verify.

### 4.31. Contoh Clone Workflow

```bash
#!/bin/bash
set -e

ORIGINAL="arch-vm"
CLONE_NAME="$1"
CLONE_DISK="/var/lib/libvirt/images/${CLONE_NAME}.qcow2"

# 1. Clone
virt-clone --original "$ORIGINAL" --name "$CLONE_NAME" --file "$CLONE_DISK"

# 2. Sysprep clone
virt-sysprep -a "$CLONE_DISK"

# 3. Customize clone
virt-customize -a "$CLONE_DISK" \
  --hostname "$CLONE_NAME" \
  --root-password password:changeme

# 4. Start
virsh start "$CLONE_NAME"
```

**Penjelasan:**
- Clone dari VM asli.
- Sysprep clone.
- Customize clone.
- Start.

### 4.32. Boot dari Golden Image dengan virt-install

```bash
virt-install \
  --name vm1 \
  --memory 2048 \
  --vcpus 2 \
  --disk /var/lib/libvirt/images/vm1.qcow2,format=qcow2 \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --import
```

**Penjelasan:**
- `--import`: boot dari disk yang sudah ada (golden/overlay).
- Tidak ada `--cdrom`.

---

## 5. Diagram Arsitektur libguestfs & Alur Clone

### 5.1. Arsitektur libguestfs

```
+-------------------------------------------------------------+
|                        Host                                 |
|  +-------------------+                                      |
|  |   virt-sysprep    |                                      |
|  |   virt-customize  |                                      |
|  |   virt-clone      |                                      |
|  +-------------------+                                      |
|           |                                                 |
|           v                                                 |
|  +-------------------+                                      |
|  |   libguestfs      |                                      |
|  |   (appliance VM)  |                                      |
|  +-------------------+                                      |
|           |                                                 |
|           v                                                 |
|  +-------------------+                                      |
|  |   Image Disk      |                                      |
|  |   (qcow2)         |                                      |
|  +-------------------+                                      |
+-------------------------------------------------------------+
```

### 5.2. Alur Sysprep

```
+-------------------+
|  Golden Image     |
|  (dengan identitas)|
+-------------------+
          |
          | virt-sysprep
          v
+-------------------+
|  Golden Image     |
|  (tanpa identitas)|
+-------------------+
          |
          | siap di-clone
          v
+-------------------+
|  Clone Baru       |
+-------------------+
```

### 5.3. Alur Customize

```
+-------------------+
|  Golden Image     |
+-------------------+
          |
          | virt-customize
          v
+-------------------+
|  Image dengan     |
|  Hostname, User,  |
|  Paket, SSH Key   |
+-------------------+
          |
          | boot pertama
          v
+-------------------+
|  VM Siap Pakai    |
+-------------------+
```

### 5.4. Alur Clone

```
+-------------------+
|  VM Original      |
+-------------------+
          |
          | virt-clone
          v
+-------------------+
|  Clone            |
|  (XML + Disk)     |
+-------------------+
          |
          | virt-sysprep
          v
+-------------------+
|  Clone Bersih     |
+-------------------+
          |
          | virt-customize
          v
+-------------------+
|  Clone Unik       |
+-------------------+
```

### 5.5. Alur Golden Image Lengkap

```
+-------------------+
|  Instalasi VM     |
+-------------------+
          |
          v
+-------------------+
|  Konfigurasi      |
|  Dasar            |
+-------------------+
          |
          v
+-------------------+
|  virt-sysprep     |
+-------------------+
          |
          v
+-------------------+
|  virt-customize   |
+-------------------+
          |
          v
+-------------------+
|  virt-sparsify    |
+-------------------+
          |
          v
+-------------------+
|  Golden Image     |
+-------------------+
          |
          +--------+--------+
          |        |        |
          v        v        v
      +------+ +------+ +------+
      | VM1  | | VM2  | | VM3  |
      +------+ +------+ +------+
```

### 5.6. Hierarki Alat libguestfs

```
libguestfs
├── virt-sysprep
├── virt-customize
├── virt-clone
├── virt-sparsify
├── virt-resize
├── virt-builder
├── virt-df
├── virt-filesystems
├── virt-inspector
├── virt-ls
├── virt-cat
├── virt-edit
├── guestfish
└── guestmount
```

---

## 6. Audit Kurikulum: Tambahan virt-sparsify, virt-resize, virt-builder, virt-df, dll

Kurikulum asli hanya menyebut:
```bash
virt-sysprep -a golden.qcow2
virt-customize -a golden.qcow2 --hostname vm1
virt-clone --original arch-vm --name clone1 --file clone1.qcow2
```

Kita akan menambahkan:

1. **`virt-sysprep --list-operations`** — lihat operasi.
2. **`virt-sysprep --enable/--disable`** — pilih operasi.
3. **`virt-sysprep --dry-run`** — simulasi.
4. **`virt-customize --root-password`** — set password.
5. **`virt-customize --ssh-inject`** — inject SSH key.
6. **`virt-customize --install`** — install paket.
7. **`virt-customize --update`** — update.
8. **`virt-customize --copy-in`** — copy file.
9. **`virt-customize --run`** — jalankan skrip.
10. **`virt-customize --firstboot`** — skrip boot pertama.
11. **`virt-customize --timezone`** — set timezone.
12. **`virt-customize --network`** — aktifkan jaringan.
13. **`virt-sparsify`** — kurangi ukuran.
14. **`virt-resize`** — ubah ukuran partisi.
15. **`virt-builder`** — buat image dari template.
16. **`virt-df`** — penggunaan disk.
17. **`virt-filesystems`** — lihat filesystem.
18. **`virt-inspector`** — inspeksi OS.
19. **`virt-ls`** — list direktori.
20. **`virt-cat`** — baca file.
21. **`virt-edit`** — edit file.
22. **`virt-clone --auto-clone`** — auto clone.
23. **`virt-clone --preserve-data`** — preserve.
24. **`virt-install --import`** — boot dari golden.
25. **Workflow lengkap** — skrip Bash.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 4.3.

---

## 7. Hubungan dengan Modul Lain

- **Modul 4.1 (Golden Image):** Golden image dibuat dengan sysprep dan customize.
- **Modul 4.2 (Snapshot):** Clone bisa dibuat dari snapshot.
- **Modul 4.4 (Edit Offline):** `guestfish` memperdalam manipulasi.
- **Modul 4.5 (Backup Live):** Backup dan restore menggunakan clone.
- **Fase 5 (Networking):** Customize bisa set konfigurasi jaringan.
- **Fase 6 (Keamanan):** Sysprep menghapus kredensial.
- **Fase 7 (Otomasi):** virt-customize untuk provisioning.
- **Fase 8 (Expert):** virt-builder untuk image cloud.

---

## 8. Referensi Lengkap

- libguestfs — https://libguestfs.org/
- virt-sysprep — https://libguestfs.org/virt-sysprep.1.html
- virt-customize — https://libguestfs.org/virt-customize.1.html
- virt-clone — https://libvirt.org/manpages/virt-clone.html
- virt-sparsify — https://libguestfs.org/virt-sparsify.1.html
- virt-resize — https://libguestfs.org/virt-resize.1.html
- virt-builder — https://libguestfs.org/virt-builder.1.html
- virt-df — https://libguestfs.org/virt-df.1.html
- virt-filesystems — https://libguestfs.org/virt-filesystems.1.html
- virt-inspector — https://libguestfs.org/virt-inspector.1.html
- virt-ls — https://libguestfs.org/virt-ls.1.html
- virt-cat — https://libguestfs.org/virt-cat.1.html
- virt-edit — https://libguestfs.org/virt-edit.1.html
- guestfish — https://libguestfs.org/guestfish.1.html
- guestmount — https://libguestfs.org/guestmount.1.html
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU

---

## 9. Tips & Praktik Terbaik

1. **Selalu sysprep sebelum clone.**
2. **Gunakan `--dry-run` untuk sysprep pertama kali.**
3. **Gunakan `--enable` untuk kontrol operasi.**
4. **Customize sebelum boot pertama.**
5. **Gunakan `--firstboot` untuk konfigurasi yang butuh VM berjalan.**
6. **Gunakan `--network` untuk install/update.**
7. **Sparsify setelah customize.**
8. **Verifikasi dengan `virt-df` dan `virt-filesystems`.**
9. **Gunakan `virt-inspector` untuk inspeksi.**
10. **Gunakan `virt-clone` dengan `--auto-clone` untuk kecepatan.**
11. **Clone tidak otomatis sysprep.**
12. **Backup golden image sebelum modifikasi.**
13. **Gunakan `--compress` untuk sparsify.**
14. **Jangan sysprep image yang sedang running.**
15. **Gunakan `virt-cat` untuk cek konfigurasi.**
16. **Gunakan `virt-edit` untuk edit tanpa boot.**
17. **Gunakan `virt-builder` untuk image cepat.**
18. **Uji clone dengan boot.**
19. **Dokumentasikan operasi sysprep.**
20. **Gunakan SSH key, bukan password.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `libguestfs: error: ...` | Appliance gagal start. | Cek KVM, cek `/dev/kvm`. |
| `virt-sysprep` gagal | Image rusak. | Cek `qemu-img check`. |
| `virt-customize --install` gagal | Tidak ada jaringan. | Tambahkan `--network`. |
| `virt-customize` gagal | Paket tidak ditemukan. | Cek nama paket. |
| `virt-clone` gagal | Disk tujuan ada. | Hapus atau ganti nama. |
| `virt-clone` gagal | VM sumber running. | Matikan VM. |
| `virt-sparsify` gagal | Image tidak didukung. | Cek format. |
| `virt-resize` gagal | Partisi tidak ditemukan. | Cek `virt-filesystems`. |
| `virt-builder` gagal | Template tidak ada. | `virt-builder --list`. |
| Sysprep menghapus data | Tidak `--dry-run`. | Selalu `--dry-run` dulu. |
| Clone memiliki identitas sama | Tidak sysprep. | Jalankan sysprep. |
| SSH key tidak berfungsi | Tidak inject. | `--ssh-inject`. |
| Password tidak berubah | Format salah. | `password:xxx`. |
| Hostname tidak berubah | Tidak customize. | `--hostname`. |
| Network tidak berfungsi | Tidak konfigurasi. | Edit `/etc/systemd/network/`. |
| Golden image besar | Tidak sparsify. | `virt-sparsify`. |
| Appliance lambat | Tidak ada KVM. | Cek `/dev/kvm`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virt-sysprep --list-operations` menampilkan daftar.
- `virt-sysprep -a golden.qcow2` berhasil.
- `virt-sysprep -a golden.qcow2 --dry-run` berhasil.
- `virt-customize -a golden.qcow2 --hostname test` berhasil.
- `virt-customize -a golden.qcow2 --root-password password:secret` berhasil.
- `virt-customize -a golden.qcow2 --ssh-inject root:file:/path` berhasil.
- `virt-customize -a golden.qcow2 --install nginx` berhasil.
- `virt-clone --original arch-vm --name clone1 --auto-clone` berhasil.
- `virt-sparsify golden.qcow2 golden-sparse.qcow2` berhasil.
- `virt-resize --expand /dev/sda1 old.qcow2 new.qcow2` berhasil.
- `virt-builder archlinux --output arch.qcow2` berhasil.
- `virt-df -a golden.qcow2` menampilkan penggunaan.
- `virt-filesystems -a golden.qcow2` menampilkan filesystem.
- `virt-inspector -a golden.qcow2` menampilkan OS.
- `virt-ls -a golden.qcow2 /etc` berhasil.
- `virt-cat -a golden.qcow2 /etc/hostname` berhasil.
- `virt-edit -a golden.qcow2 /etc/hostname` berhasil.

**Troubleshooting:**
- Jika libguestfs error: cek `/dev/kvm`, cek modul.
- Jika sysprep gagal: cek `qemu-img check`.
- Jika customize gagal: cek `--network`.
- Jika clone gagal: cek disk tujuan, cek VM running.
- Jika sparsify gagal: cek format.
- Jika resize gagal: cek partisi.
- Untuk debugging: `LIBGUESTFS_DEBUG=1`.
- Untuk trace: `virt-sysprep -x`.
- Untuk log: `/tmp/libguestfs*`.

---

## 12. Latihan Mandiri

1. Install libguestfs: `pacman -S libguestfs`.
2. Buat golden image dari VM Arch minimal.
3. Jalankan `virt-sysprep --list-operations`.
4. Jalankan `virt-sysprep --dry-run` pada golden.
5. Jalankan `virt-sysprep` sebenarnya.
6. Verifikasi SSH host keys hilang: `virt-ls -a golden.qcow2 /etc/ssh`.
7. Verifikasi machine-id kosong: `virt-cat -a golden.qcow2 /etc/machine-id`.
8. Customize hostname: `virt-customize -a golden.qcow2 --hostname vm1`.
9. Set root password.
10. Inject SSH key.
11. Install paket `qemu-guest-agent`.
12. Jalankan `virt-df` untuk cek penggunaan.
13. Jalankan `virt-filesystems` untuk cek partisi.
14. Jalankan `virt-inspector` untuk cek OS.
15. Sparsify: `virt-sparsify --compress`.
16. Clone VM dengan `virt-clone`.
17. Sysprep clone.
18. Customize clone.
19. Boot clone.
20. Verifikasi identitas unik.
21. Buat skrip workflow lengkap.
22. Tulis ringkasan: kapan sysprep, kapan customize, kapan clone.

---

## 13. Penutup Modul 4.3

Anda kini menguasai **virt-sysprep, virt-customize, virt-clone**, serta alat-alat libguestfs lainnya seperti `virt-sparsify`, `virt-resize`, `virt-builder`, `virt-df`, `virt-filesystems`, `virt-inspector`, `virt-ls`, `virt-cat`, dan `virt-edit`. Anda bisa membuat golden image yang bersih, menyesuaikannya sebelum boot, meng-clone VM, dan memanipulasi image tanpa mem-boot VM. Ini adalah fondasi untuk Modul 4.4 (Edit Disk Offline) dan 4.5 (Backup Live).

---

*Motivasi: Clone adalah kelahiran. Sysprep adalah pembersihan. Customize adalah pendidikan. Dengan tiga alat ini, Anda bukan lagi pembuat VM — Anda adalah pencipta kehidupan virtual yang unik.*

---

## Audit Kurikulum untuk Modul 4.4

Kurikulum asli menyebut:
```bash
guestfish --rw -a disk.qcow2 -i
><fs> ll /
><fs> cat /etc/hostname
```

**Temuan audit:**
- Kurikulum hanya menyebut `guestfish` secara sekilas. Belum menyebut **`guestmount`** dan **`qemu-nbd`** secara rinci, padahal keduanya disebut di judul modul.
- Belum menyebut **`libguestfs-mount`**, **`guestunmount`**, **`virt-make-fs`**, **`virt-tar-in`**, **`virt-tar-out`**.
- Belum menyebut **NBD (Network Block Device)** dan cara kerja kernel `nbd` module.
- Belum menyebut **bahaya menulis ke image yang sedang running**.
- Belum menyebut **read-only mount** vs **read-write**.
- Belum menyebut **`guestfish --ro`**, **`guestfish --rw`**, **`guestfish --add`**, **`guestfish --mount`**.
- Belum menyebut **`--inspector`** di `guestfish`.
- Belum menyebut **`qemu-nbd --connect`**, **`--disconnect`**, **`--fork`**, **`--persistent`**.
- Belum menyebut **`nbd-client`**, **`modprobe nbd`**, **`/dev/nbd0`**.
- Belum menyebut **LVM**, **Btrfs**, **ZFS**, **LUKS** di dalam image.

**Rekomendasi:** Tambahkan poin-poin di atas ke dalam Modul 4.4. Materi berikut akan mencakup semuanya.

---

# Modul 4.4 — Edit Disk Offline (guestfish, guestmount, qemu-nbd)

> *“Jangan bangunkan VM hanya untuk mengubah satu file.”*

## Mini-Daftar Isi Modul 4.4

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Offline Editing & NBD
6. Audit Kurikulum: Tambahan guestmount, qemu-nbd, NBD, LUKS, LVM, Btrfs
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Edit Disk Offline** adalah seni memodifikasi image disk VM **tanpa mem-boot VM**. Ada tiga pendekatan utama:
- **`guestfish`** — shell interaktif khusus untuk memanipulasi filesystem di dalam image.
- **`guestmount`** — mount filesystem di dalam image ke direktori host via FUSE.
- **`qemu-nbd`** — ekspos image sebagai block device (`/dev/nbdX`) sehingga bisa di-mount, di-`fsck`, di-resize, atau di-LVM.

**Peran dalam kurikulum:** Modul ini adalah **jembatan operasional** antara image engineering (Modul 4.3) dan backup (Modul 4.5). Ini adalah keterampilan *rescue*: ketika VM tidak bisa boot, ketika lupa password, ketika perlu mengubah konfigurasi tanpa risiko mengganggu sistem yang berjalan.

**Mengapa penting?**
- **Rescue**: Perbaiki VM yang rusak tanpa boot.
- **Forensik**: Periksa image yang dicurigai.
- **Otomasi**: Modifikasi konfigurasi secara batch.
- **Migrasi**: Ubah driver, partisi, atau filesystem.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Boot vs Offline

Boot VM memerlukan:
- Firmware (BIOS/UEFI).
- Bootloader.
- Kernel + initramfs.
- Driver.

Jika salah satu rusak, VM tidak bisa boot. Namun, **data di dalam disk masih utuh**. Edit offline memungkinkan Anda mengakses data tanpa melalui rantai boot.

**Filosofi:** *Data tidak butuh bootloader. Ia hanya butuh filesystem.*

### 2.2. Filesystem sebagai Kontainer

Setiap filesystem (ext4, xfs, btrfs, zfs) adalah struktur data. libguestfs dan qemu-nbd memungkinkan Anda **membaca struktur itu** seolah-olah ia adalah direktori biasa.

**Filosofi:** *Filesystem adalah abstraksi. Kita bisa membuka abstraksi itu tanpa menjalankan OS.*

### 2.3. Read-Only vs Read-Write

- **Read-only (`--ro`)**: Aman. Tidak ada perubahan. Untuk inspeksi/forensik.
- **Read-write (`--rw`)**: Berbahaya jika image sedang di-mount oleh VM running. Bisa menyebabkan korupsi.

**Filosofi:** *Jika ragu, gunakan read-only. Selalu matikan VM sebelum read-write.*

### 2.4. NBD: Image sebagai Block Device

**NBD (Network Block Device)** adalah modul kernel Linux yang memungkinkan **file** tampil sebagai **block device**. Dengan `qemu-nbd`, image qcow2 bisa diekspos sebagai `/dev/nbd0`, lalu di-mount seperti partisi biasa.

**Filosofi:** *Kernel tidak tahu bahwa itu file qcow2. Ia hanya tahu itu block device.*

### 2.5. libguestfs vs qemu-nbd: Dua Pendekatan

| Aspek | libguestfs | qemu-nbd |
|---|---|---|
| Abstraksi | Tinggi | Rendah |
| Perintah | `guestfish`, `guestmount` | `mount`, `fsck`, `lvm` |
| Mendukung LVM | Ya (otomatis) | Ya (manual) |
| Mendukung LUKS | Ya | Ya |
| Mendukung Windows | Ya (NTFS) | Terbatas |
| Kecepatan | Sedang | Tinggi |
| Kontrol | Sedang | Penuh |

**Filosofi:** *libguestfs untuk kenyamanan; qemu-nbd untuk kontrol maksimal.*

### 2.6. FUSE: Mount Tanpa Root

`guestmount` menggunakan **FUSE (Filesystem in Userspace)** sehingga user biasa bisa me-mount image. Namun, akses ke block device tetap memerlukan root atau grup `disk`.

**Filosofi:** *FUSE demokratisasi mounting.*

### 2.7. Bahaya: Menulis Saat Running

Jika Anda me-mount image read-write saat VM running:
- Cache host dan cache guest bisa bertabrakan.
- Metadata filesystem bisa korup.
- Data bisa hilang.

**Filosofi:** *Satu penulis, satu waktu. Jangan pernah tulis saat VM hidup.*

### 2.8. Filosofi Keseluruhan

- **Offline adalah kekuatan.** Tidak butuh boot.
- **Read-only adalah default.** Untuk inspeksi.
- **Read-write butuh kehati-hatian.** Matikan VM dulu.
- **NBD adalah fondasi.** qemu-nbd adalah jembatan ke kernel.
- **libguestfs adalah kenyamanan.** Untuk tugas umum.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Offline edit** | Edit disk tanpa boot VM. | |
| **guestfish** | Shell interaktif libguestfs. | `guestfish -a disk.qcow2` |
| **guestmount** | Mount image via FUSE. | `guestmount -a disk.qcow2 -m /dev/sda1 /mnt` |
| **guestunmount** | Unmount image. | |
| **qemu-nbd** | Ekspos image sebagai block device. | `qemu-nbd -c /dev/nbd0 disk.qcow2` |
| **NBD** | Network Block Device. | Modul kernel. |
| **nbd-client** | Klien NBD. | |
| **`/dev/nbd0`** | Device NBD pertama. | |
| **`-i`** | Auto-inspect dan mount. | |
| **`--ro`** | Read-only. | |
| **`--rw`** | Read-write. | |
| **`--add`** | Tambah image. | |
| **`--mount`** | Mount spesifik. | |
| **`-m`** | Mount. | |
| **`--inspector`** | Auto-inspect. | |
| **`virt-make-fs`** | Buat filesystem baru. | |
| **`virt-tar-in`** | Ekstrak tar ke image. | |
| **`virt-tar-out`** | Ekstrak tar dari image. | |
| **`guestunmount`** | Unmount FUSE. | |
| **FUSE** | Filesystem in Userspace. | |
| **LVM** | Logical Volume Manager. | |
| **LUKS** | Linux Unified Key Setup. | |
| **Btrfs** | Filesystem modern. | |
| **ZFS** | Zettabyte File System. | |
| **`vgscan`** | Scan volume group. | |
| **`lvscan`** | Scan logical volume. | |
| **`cryptsetup`** | Manajemen LUKS. | |
| **`kpartx`** | Map partisi dari device. | |
| **`losetup`** | Setup loop device. | |
| **`nbd-client`** | Klien NBD. | |
| **`modprobe nbd`** | Muat modul NBD. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. guestfish: Mode Dasar

```bash
guestfish --ro -a /var/lib/libvirt/images/disk.qcow2
```

**Penjelasan kata demi kata:**
- `guestfish`: shell interaktif libguestfs.
- `--ro`: read-only.
- `-a /path`: tambahkan image.
- Setelah masuk, Anda berada di prompt `><fs>`.

**Prompt:**
```
Welcome to guestfish, the guest filesystem shell for
editing virtual machine filesystems and disk images.

Type: 'help' for help on commands
      'man' to read the manual
      'quit' to quit the shell

><fs>
```

### 4.2. guestfish: Auto-Inspect dan Mount

```bash
guestfish --ro -a disk.qcow2 -i
```

**Penjelasan:**
- `-i`: auto-inspect dan mount semua filesystem.
- Setelah masuk, Anda bisa `ll /`, `cat /etc/hostname`, dll.

### 4.3. guestfish: Perintah Umum

```bash
><fs> ll /
><fs> ls /etc
><fs> cat /etc/hostname
><fs> download /etc/hostname /tmp/hostname
><fs> upload /tmp/newfile /etc/newfile
><fs> edit /etc/hostname
><fs> write /etc/newfile "content"
><fs> rm /etc/oldfile
><fs> mv /etc/a /etc/b
><fs> cp /etc/a /etc/b
><fs> mkdir /etc/newdir
><fs> rmdir /etc/olddir
><fs> chmod 0644 /etc/file
><fs> chown 0 0 /etc/file
><fs> touch /etc/newfile
><fs> truncate /etc/file
><fs> find /etc
><fs> glob find /etc/*
><fs> stat /etc/hostname
><fs> statns /etc/hostname
><fs> is-file /etc/hostname
><fs> is-dir /etc
><fs> exists /etc/hostname
><fs> file /etc/hostname
><fs> du /etc
><fs> df
><fs> df-h
><fs> mountpoints
><fs> mkmountpoint /new
><fs> umount /new
><fs> sync
><fs> quit
```

**Penjelasan singkat:**
- `ll`, `ls`: list.
- `cat`, `download`, `upload`: baca/tulis.
- `edit`: edit dengan editor host.
- `write`, `rm`, `mv`, `cp`: manipulasi file.
- `mkdir`, `rmdir`: direktori.
- `chmod`, `chown`: permission.
- `find`, `glob`: pencarian.
- `stat`, `statns`: info file.
- `df`, `du`: penggunaan disk.
- `mountpoints`: titik mount.
- `sync`: flush ke disk.

### 4.4. guestfish: Non-Interaktif

```bash
guestfish --ro -a disk.qcow2 -i cat /etc/hostname
guestfish --ro -a disk.qcow2 -i ll /etc
guestfish --ro -a disk.qcow2 -i download /etc/hostname /tmp/hostname
```

**Penjelasan:**
- Perintah langsung setelah `-i`.
- Berguna untuk scripting.

### 4.5. guestfish: Read-Write

```bash
guestfish --rw -a disk.qcow2 -i
```

**Peringatan:** Matikan VM dulu!

### 4.6. guestfish: Mount Spesifik

```bash
guestfish --ro -a disk.qcow2 -m /dev/sda1:/
```

**Penjelasan:**
- `-m /dev/sda1:/`: mount partisi `/dev/sda1` ke root.
- Tidak perlu inspect.

### 4.7. guestfish: Multiple Disk

```bash
guestfish --ro -a disk1.qcow2 -a disk2.qcow2 -i
```

**Penjelasan:**
- Tambahkan beberapa `-a`.
- Berguna untuk VM dengan multiple disk.

### 4.8. guestfish: LVM

```bash
guestfish --ro -a disk.qcow2 -i
><fs> lvs
><fs> vgs
><fs> pvs
```

**Penjelasan:**
- `lvs`: list logical volume.
- `vgs`: volume group.
- `pvs`: physical volume.

### 4.9. guestfish: LUKS

```bash
guestfish --ro -a disk.qcow2
><fs> luks-open /dev/sda1 luksdev
><fs> mount /dev/mapper/luksdev /
```

**Penjelasan:**
- `luks-open`: buka LUKS.
- `mount`: mount setelah dibuka.

### 4.10. guestmount: Dasar

```bash
mkdir -p /mnt/vm
guestmount --ro -a disk.qcow2 -i /mnt/vm
ls /mnt/vm
guestunmount /mnt/vm
```

**Penjelasan kata demi kata:**
- `guestmount`: mount image via FUSE.
- `--ro`: read-only.
- `-a disk.qcow2`: image.
- `-i`: auto-inspect.
- `/mnt/vm`: mount point.
- `guestunmount`: unmount.

### 4.11. guestmount: Read-Write

```bash
guestmount --rw -a disk.qcow2 -i /mnt/vm
```

**Peringatan:** Matikan VM dulu.

### 4.12. guestmount: Mount Spesifik

```bash
guestmount --ro -a disk.qcow2 -m /dev/sda1:/ /mnt/vm
```

**Penjelasan:**
- `-m /dev/sda1:/`: mount spesifik.

### 4.13. guestmount: Debug

```bash
guestmount --ro -a disk.qcow2 -i -v /mnt/vm
guestmount --ro -a disk.qcow2 -i -x /mnt/vm
```

**Penjelasan:**
- `-v`: verbose.
- `-x`: trace perintah.

### 4.14. qemu-nbd: Dasar

```bash
sudo modprobe nbd max_part=16
sudo qemu-nbd --connect=/dev/nbd0 /var/lib/libvirt/images/disk.qcow2
sudo fdisk -l /dev/nbd0
sudo mount /dev/nbd0p1 /mnt/vm
ls /mnt/vm
sudo umount /mnt/vm
sudo qemu-nbd --disconnect /dev/nbd0
```

**Penjelasan kata demi kata:**
- `modprobe nbd max_part=16`: muat modul NBD dengan max 16 partisi.
- `qemu-nbd --connect=/dev/nbd0`: ekspos image sebagai `/dev/nbd0`.
- `fdisk -l`: lihat partisi.
- `mount /dev/nbd0p1`: mount partisi pertama.
- `umount`: unmount.
- `--disconnect`: lepaskan NBD.

### 4.15. qemu-nbd: Read-Only

```bash
sudo qemu-nbd --read-only --connect=/dev/nbd0 disk.qcow2
```

**Penjelasan:**
- `--read-only`: read-only.
- Aman untuk inspeksi.

### 4.16. qemu-nbd: Fork dan Persistent

```bash
sudo qemu-nbd --fork --persistent --connect=/dev/nbd0 disk.qcow2
```

**Penjelasan:**
- `--fork`: jalankan di background.
- `--persistent`: tetap terhubung setelah klien disconnect.

### 4.17. qemu-nbd: Unix Socket

```bash
sudo qemu-nbd --socket=/tmp/nbd.sock --persistent --exportname=disk disk.qcow2
sudo nbd-client -unix /tmp/nbd.sock /dev/nbd0
```

**Penjelasan:**
- `--socket`: gunakan UNIX socket, bukan TCP.
- `nbd-client -unix`: klien NBD.

### 4.18. qemu-nbd: Disconnect

```bash
sudo qemu-nbd --disconnect /dev/nbd0
sudo rmmod nbd
```

**Penjelasan:**
- `--disconnect`: lepaskan.
- `rmmod nbd`: unload modul.

### 4.19. LVM di NBD

```bash
sudo qemu-nbd --connect=/dev/nbd0 disk.qcow2
sudo pvscan
sudo vgscan
sudo lvscan
sudo vgchange -ay vg0
sudo mount /dev/vg0/lv0 /mnt/vm
```

**Penjelasan:**
- `pvscan`, `vgscan`, `lvscan`: scan LVM.
- `vgchange -ay`: aktifkan VG.
- `mount`: mount LV.

### 4.20. LUKS di NBD

```bash
sudo qemu-nbd --connect=/dev/nbd0 disk.qcow2
sudo cryptsetup luksOpen /dev/nbd0p1 cryptdisk
sudo mount /dev/mapper/cryptdisk /mnt/vm
```

**Penjelasan:**
- `cryptsetup luksOpen`: buka LUKS.
- `mount /dev/mapper/cryptdisk`: mount.

### 4.21. Btrfs di NBD

```bash
sudo mount -t btrfs -o subvol=@ /dev/nbd0p2 /mnt/vm
```

**Penjelasan:**
- `-t btrfs`: filesystem Btrfs.
- `-o subvol=@`: subvolume.

### 4.22. qemu-nbd: Koneksi TCP

```bash
# Di server
sudo qemu-nbd --bind=0.0.0.0 --port=10809 --persistent --exportname=disk disk.qcow2

# Di klien
sudo nbd-client server 10809 /dev/nbd0 -N disk
```

**Penjelasan:**
- `--bind`: alamat bind.
- `--port`: port TCP.
- Klien konek via `nbd-client`.

### 4.23. virt-make-fs: Buat Filesystem Baru

```bash
virt-make-fs --type=ext4 --size=1G /host/dir newdisk.img
```

**Penjelasan:**
- `virt-make-fs`: buat filesystem baru.
- `--type=ext4`: tipe.
- `--size=1G`: ukuran.
- `/host/dir`: isi.
- `newdisk.img`: output.

### 4.24. virt-tar-in: Ekstrak Tar ke Image

```bash
virt-tar-in -a disk.qcow2 /host/backup.tar /target/dir
```

**Penjelasan:**
- `virt-tar-in`: ekstrak tar ke image.
- `-a disk.qcow2`: image.
- `/host/backup.tar`: tar di host.
- `/target/dir`: tujuan di image.

### 4.25. virt-tar-out: Ekstrak Tar dari Image

```bash
virt-tar-out -a disk.qcow2 /source/dir /host/backup.tar
```

**Penjelasan:**
- `virt-tar-out`: buat tar dari image.

### 4.26. Rescue: Reset Password Root

```bash
# 1. Matikan VM
virsh shutdown arch-vm

# 2. Mount image
guestmount --rw -a /var/lib/libvirt/images/arch-vm.qcow2 -i /mnt/vm

# 3. Edit /etc/shadow atau gunakan chroot
sudo chroot /mnt/vm passwd root

# 4. Unmount
guestunmount /mnt/vm

# 5. Start
virsh start arch-vm
```

**Penjelasan:**
- `guestmount --rw`: mount read-write.
- `chroot`: masuk ke environment guest.
- `passwd root`: reset password.

### 4.27. Rescue: Perbaiki fstab

```bash
guestmount --rw -a disk.qcow2 -i /mnt/vm
sudo vim /mnt/vm/etc/fstab
guestunmount /mnt/vm
```

**Penjelasan:**
- Edit `/etc/fstab` tanpa boot.

### 4.28. Rescue: Ganti GRUB

```bash
guestfish --rw -a disk.qcow2 -i
><fs> edit /boot/grub/grub.cfg
><fs> quit
```

**Penjelasan:**
- Edit konfigurasi GRUB.

### 4.29. Forensik: Lihat Log

```bash
guestfish --ro -a disk.qcow2 -i
><fs> ll /var/log
><fs> download /var/log/messages /tmp/messages
><fs> quit
```

**Penjelasan:**
- Read-only untuk forensik.

### 4.30. Migrasi: Ubah Driver Disk

```bash
guestfish --rw -a disk.qcow2 -i
><fs> edit /etc/mkinitcpio.conf
><fs> quit
```

**Penjelasan:**
- Ubah `MODULES` untuk driver baru.

### 4.31. Skrip Batch: Ubah Hostname 10 Image

```bash
#!/bin/bash
for img in /var/lib/libvirt/images/vm*.qcow2; do
  name=$(basename "$img" .qcow2)
  virt-customize -a "$img" --hostname "$name"
  echo "Hostname set: $name"
done
```

**Penjelasan:**
- Loop semua image.
- Set hostname sesuai nama file.

### 4.32. Skrip: Cek Semua Image

```bash
#!/bin/bash
for img in /var/lib/libvirt/images/*.qcow2; do
  echo "=== $img ==="
  qemu-img check "$img"
  virt-inspector -a "$img" | grep -E 'distro|product_name'
done
```

**Penjelasan:**
- Cek konsistensi.
- Inspeksi OS.

### 4.33. Perbandingan: guestfish vs guestmount vs qemu-nbd

| Tugas | guestfish | guestmount | qemu-nbd |
|---|---|---|---|
| Lihat file | ✓ | ✓ | ✓ |
| Edit file | ✓ | ✓ | ✓ |
| Rescue | ✓ | ✓ | ✓ |
| LVM | ✓ | ✓ | ✓ |
| LUKS | ✓ | ✓ | ✓ |
| Windows | ✓ | ✓ | Terbatas |
| Scripting | ✓ | ✓ | ✓ |
| Kontrol penuh | Sedang | Sedang | Penuh |
| Kecepatan | Sedang | Sedang | Tinggi |
| Root required | Tidak | Tidak | Ya |

---

## 5. Diagram Arsitektur Offline Editing & NBD

### 5.1. Arsitektur guestfish

```
+-------------------+
|  Host             |
|  guestfish        |
+-------------------+
          |
          v
+-------------------+
|  libguestfs       |
|  appliance VM     |
+-------------------+
          |
          v
+-------------------+
|  Image Disk       |
+-------------------+
```

### 5.2. Arsitektur guestmount

```
+-------------------+
|  Host             |
|  /mnt/vm          |
+-------------------+
          |
          v
+-------------------+
|  FUSE             |
+-------------------+
          |
          v
+-------------------+
|  libguestfs       |
+-------------------+
          |
          v
+-------------------+
|  Image Disk       |
+-------------------+
```

### 5.3. Arsitektur qemu-nbd

```
+-------------------+
|  Host             |
|  /dev/nbd0        |
+-------------------+
          |
          v
+-------------------+
|  Kernel NBD       |
+-------------------+
          |
          v
+-------------------+
|  qemu-nbd         |
+-------------------+
          |
          v
+-------------------+
|  Image Disk       |
+-------------------+
```

### 5.4. Alur Rescue

```
+-------------------+
|  VM Rusak         |
+-------------------+
          |
          | shutdown
          v
+-------------------+
|  Mount Offline    |
+-------------------+
          |
          | edit
          v
+-------------------+
|  Unmount          |
+-------------------+
          |
          | start
          v
+-------------------+
|  VM Sehat         |
+-------------------+
```

### 5.5. Alur LUKS + LVM + NBD

```
+-------------------+
|  Image qcow2      |
+-------------------+
          |
          | qemu-nbd
          v
+-------------------+
|  /dev/nbd0        |
+-------------------+
          |
          | cryptsetup
          v
+-------------------+
|  /dev/mapper/...  |
+-------------------+
          |
          | LVM
          v
+-------------------+
|  /dev/vg0/lv0     |
+-------------------+
          |
          | mount
          v
+-------------------+
|  /mnt/vm          |
+-------------------+
```

### 5.6. Perbandingan Tiga Pendekatan

```
+-------------------+  +-------------------+  +-------------------+
|    guestfish      |  |   guestmount      |  |    qemu-nbd       |
+-------------------+  +-------------------+  +-------------------+
|  Shell interaktif |  |  Mount FUSE       |  |  Block device     |
|  --ro / --rw      |  |  --ro / --rw      |  |  --read-only      |
|  Tanpa root       |  |  Tanpa root       |  |  Root required    |
|  LVM, LUKS, Btrfs |  |  LVM, LUKS, Btrfs |  |  LVM, LUKS, Btrfs |
+-------------------+  +-------------------+  +-------------------+
          |                     |                      |
          v                     v                      v
+-------------------+  +-------------------+  +-------------------+
|  libguestfs       |  |  FUSE + libguestfs|  |  Kernel NBD       |
+-------------------+  +-------------------+  +-------------------+
```

---

## 6. Audit Kurikulum: Tambahan guestmount, qemu-nbd, NBD, LUKS, LVM, Btrfs

Kurikulum asli hanya menyebut:
```bash
guestfish --rw -a disk.qcow2 -i
><fs> ll /
><fs> cat /etc/hostname
```

Kita akan menambahkan:

1. **`guestfish --ro`** — read-only.
2. **`guestfish --rw`** — read-write.
3. **`guestfish -i`** — auto-inspect.
4. **`guestfish -m`** — mount spesifik.
5. **`guestfish --add`** — multiple disk.
6. **Perintah guestfish** — `ll`, `ls`, `cat`, `download`, `upload`, `edit`, `write`, `rm`, `mv`, `cp`, `mkdir`, `chmod`, `chown`, `find`, `stat`, `df`, `du`, `sync`.
7. **LVM di guestfish** — `lvs`, `vgs`, `pvs`.
8. **LUKS di guestfish** — `luks-open`, `mount`.
9. **`guestmount`** — mount via FUSE.
10. **`guestmount --ro`** dan **`--rw`**.
11. **`guestmount -i`** dan **`-m`**.
12. **`guestunmount`** — unmount.
13. **`qemu-nbd`** — ekspos image sebagai NBD.
14. **`modprobe nbd`** — muat modul.
15. **`qemu-nbd --connect`** — koneksi.
16. **`qemu-nbd --disconnect`** — lepas.
17. **`qemu-nbd --read-only`** — read-only.
18. **`qemu-nbd --fork`** — background.
19. **`qemu-nbd --persistent`** — persistent.
20. **`qemu-nbd --socket`** — UNIX socket.
21. **`qemu-nbd --bind`** — TCP bind.
22. **`nbd-client`** — klien NBD.
23. **`/dev/nbd0`** — device.
24. **`fdisk -l /dev/nbd0`** — partisi.
25. **`mount /dev/nbd0p1`** — mount.
26. **LVM di NBD** — `pvscan`, `vgscan`, `lvscan`, `vgchange -ay`.
27. **LUKS di NBD** — `cryptsetup luksOpen`.
28. **Btrfs di NBD** — `mount -t btrfs`.
29. **`virt-make-fs`** — buat filesystem.
30. **`virt-tar-in`** — ekstrak tar.
31. **`virt-tar-out`** — buat tar.
32. **Rescue** — reset password, perbaiki fstab, GRUB.
33. **Forensik** — lihat log.
34. **Migrasi** — ubah driver.
35. **Skrip batch** — otomasi.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 4.4.

---

## 7. Hubungan dengan Modul Lain

- **Modul 4.1 (Golden Image):** Edit offline untuk memodifikasi golden.
- **Modul 4.2 (Snapshot):** Edit snapshot tanpa boot.
- **Modul 4.3 (Sysprep/Customize):** libguestfs adalah fondasi.
- **Modul 4.5 (Backup Live):** Restore offline.
- **Fase 5 (Networking):** Edit konfigurasi jaringan offline.
- **Fase 6 (Keamanan):** Forensik, LUKS, audit.
- **Fase 7 (Otomasi):** Skrip batch.
- **Fase 8 (Expert):** Migrasi storage, rescue.

---

## 8. Referensi Lengkap

- guestfish — https://libguestfs.org/guestfish.1.html
- guestmount — https://libguestfs.org/guestmount.1.html
- guestunmount — https://libguestfs.org/guestunmount.1.html
- virt-make-fs — https://libguestfs.org/virt-make-fs.1.html
- virt-tar-in — https://libguestfs.org/virt-tar-in.1.html
- virt-tar-out — https://libguestfs.org/virt-tar-out.1.html
- qemu-nbd — https://www.qemu.org/docs/master/tools/qemu-nbd.html
- NBD — https://nbd.sourceforge.io/
- nbd-client — https://manpages.debian.org/nbd-client
- LVM — https://wiki.archlinux.org/title/LVM
- LUKS — https://wiki.archlinux.org/title/Dm-crypt
- Btrfs — https://wiki.archlinux.org/title/Btrfs
- ZFS — https://wiki.archlinux.org/title/ZFS
- FUSE — https://github.com/libfuse/libfuse
- libguestfs — https://libguestfs.org/
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU

---

## 9. Tips & Praktik Terbaik

1. **Selalu matikan VM sebelum read-write.**
2. **Gunakan `--ro` untuk inspeksi.**
3. **Gunakan `-i` untuk auto-inspect.**
4. **Gunakan `guestmount` untuk tugas file.**
5. **Gunakan `guestfish` untuk scripting.**
6. **Gunakan `qemu-nbd` untuk LVM/LUKS kompleks.**
7. **Gunakan `--read-only` untuk forensik.**
8. **Jangan mount read-write saat VM running.**
9. **Gunakan `guestunmount` setelah selesai.**
10. **Gunakan `qemu-nbd --disconnect` setelah selesai.**
11. **Unload modul NBD setelah selesai.**
12. **Backup image sebelum edit read-write.**
13. **Gunakan checksum untuk verifikasi.**
14. **Gunakan `virt-inspector` untuk identifikasi.**
15. **Gunakan `virt-cat` untuk baca cepat.**
16. **Gunakan `virt-edit` untuk edit cepat.**
17. **Gunakan `virt-df` untuk cek space.**
18. **Jangan edit `/etc/fstab` tanpa pemahaman.**
19. **Dokumentasikan perubahan.**
20. **Uji VM setelah edit.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `guestfish: error` | Appliance gagal start. | Cek `/dev/kvm`. |
| `guestmount: mount failed` | FUSE tidak ada. | Install `fuse`. |
| `guestmount: permission denied` | User tidak di grup. | Cek permission. |
| `qemu-nbd: connect failed` | Modul NBD tidak dimuat. | `modprobe nbd`. |
| `qemu-nbd: device busy` | NBD sudah terpakai. | Disconnect dulu. |
| `mount: wrong fs type` | Tipe filesystem salah. | Cek `fdisk -l`. |
| `mount: unknown filesystem` | LVM/LUKS belum aktif. | `vgchange -ay`, `cryptsetup`. |
| `umount: target is busy` | Ada proses. | `lsof`, `fuser`. |
| Image korup | Read-write saat running. | Restore dari backup. |
| LVM tidak terdeteksi | VG tidak aktif. | `vgscan`, `vgchange -ay`. |
| LUKS tidak bisa dibuka | Passphrase salah. | Cek passphrase. |
| Btrfs tidak bisa mount | Subvolume salah. | Cek `btrfs subvolume list`. |
| `guestunmount: failed` | Mount masih dipakai. | `lsof`, `fuser -m`. |
| NBD tidak hilang | Modul masih dimuat. | `rmmod nbd`. |
| Edit hilang setelah unmount | Tidak `sync`. | `sync` sebelum unmount. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `guestfish --ro -a disk.qcow2 -i ll /` berhasil.
- `guestfish --ro -a disk.qcow2 -i cat /etc/hostname` berhasil.
- `guestmount --ro -a disk.qcow2 -i /mnt/vm` berhasil.
- `ls /mnt/vm` menampilkan isi.
- `guestunmount /mnt/vm` berhasil.
- `modprobe nbd` berhasil.
- `qemu-nbd --connect=/dev/nbd0 disk.qcow2` berhasil.
- `fdisk -l /dev/nbd0` menampilkan partisi.
- `mount /dev/nbd0p1 /mnt/vm` berhasil.
- `umount /mnt/vm` berhasil.
- `qemu-nbd --disconnect /dev/nbd0` berhasil.
- LVM terdeteksi: `pvscan`, `vgscan`, `lvscan`.
- LUKS bisa dibuka: `cryptsetup luksOpen`.
- Btrfs bisa di-mount.
- `virt-make-fs` berhasil.
- `virt-tar-in` dan `virt-tar-out` berhasil.

**Troubleshooting:**
- Jika `guestfish` gagal: cek `/dev/kvm`, cek modul.
- Jika `guestmount` gagal: cek `fuse`, cek permission.
- Jika `qemu-nbd` gagal: cek `modprobe nbd`, cek `/dev/nbd0`.
- Jika mount gagal: cek `fdisk -l`, cek tipe filesystem.
- Jika LVM tidak terdeteksi: `pvscan`, `vgscan`, `vgchange -ay`.
- Jika LUKS gagal: cek passphrase, cek header.
- Jika Btrfs gagal: cek subvolume.
- Jika image korup: restore backup.
- Untuk debugging: `LIBGUESTFS_DEBUG=1`, `guestfish -v`, `guestfish -x`.
- Untuk log: `/tmp/libguestfs*`.

---

## 12. Latihan Mandiri

1. Install libguestfs: `pacman -S libguestfs`.
2. Buat VM dengan disk qcow2.
3. Matikan VM.
4. Jalankan `guestfish --ro -a disk.qcow2 -i`.
5. Jalankan `ll /`, `cat /etc/hostname`, `ls /etc`.
6. Keluar dengan `quit`.
7. Jalankan `guestfish --ro -a disk.qcow2 -i cat /etc/os-release`.
8. Mount dengan `guestmount --ro -a disk.qcow2 -i /mnt/vm`.
9. `ls /mnt/vm`, `cat /mnt/vm/etc/hostname`.
10. `guestunmount /mnt/vm`.
11. Jalankan `modprobe nbd max_part=16`.
12. `qemu-nbd --connect=/dev/nbd0 disk.qcow2`.
13. `fdisk -l /dev/nbd0`.
14. `mount /dev/nbd0p1 /mnt/vm`.
15. `ls /mnt/vm`.
16. `umount /mnt/vm`.
17. `qemu-nbd --disconnect /dev/nbd0`.
18. Buat LVM di dalam image, coba akses via NBD.
19. Buat LUKS, coba buka via NBD.
20. Buat Btrfs, coba mount via NBD.
21. Rescue: reset password root.
22. Rescue: perbaiki `/etc/fstab`.
23. Forensik: baca `/var/log/messages`.
24. Buat skrip batch untuk ubah hostname 5 image.
25. Tulis ringkasan: kapan guestfish vs guestmount vs qemu-nbd.

---

## 13. Penutup Modul 4.4

Anda kini menguasai **Edit Disk Offline** dengan tiga pendekatan: `guestfish` (shell interaktif), `guestmount` (FUSE), dan `qemu-nbd` (block device). Anda bisa membaca, menulis, merescue, dan memodifikasi image tanpa mem-boot VM. Anda juga memahami LVM, LUKS, Btrfs, dan NBD. Ini adalah fondasi untuk Modul 4.5 (Backup Live & Uji Restore).

---

*Motivasi: VM tidak selalu harus hidup untuk disembuhkan. Terkadang, sentuhan dingin dari tangan offline justru lebih menyelamatkan.*

---

## Audit Kurikulum untuk Modul 4.5

Kurikulum asli menyebut:
```bash
virsh blockcopy arch-vm vda /backup/arch.qcow2 --wait --verbose
sha256sum /backup/arch.qcow2
```

**Temuan audit:**
- Kurikulum hanya menyebut `blockcopy` dan `sha256sum`. Belum menyebut:
  - **`virsh backup-begin`** (API backup native libvirt ≥ 9.2).
  - **QEMU dirty bitmap** untuk backup inkremental.
  - **`qemu-img bitmap`** — manajemen bitmap.
  - **`qemu-img rebase`** — untuk memutus backing chain setelah backup.
  - **Snapshot-based backup** (external snapshot → backup → blockcommit).
  - **QGA `guest-fsfreeze-freeze`** — untuk konsistensi aplikasi.
  - **Verifikasi integritas end-to-end** — bukan hanya checksum file.
  - **Uji restore** — boot VM dari backup, cek fungsional.
  - **Retensi** — kebijakan GFS (Grandfather-Father-Son).
  - **Offsite backup** — NFS, S3, rsync, borg, restic.
  - **Enkripsi backup** — LUKS, GPG, age.
  - **Disaster recovery runbook**.
  - **Backup metadata** — XML, NVRAM, vTPM, pool, network.

**Rekomendasi:** Tambahkan poin-poin di atas ke dalam Modul 4.5. Materi berikut mencakup semuanya.

---

# Modul 4.5 — Backup Live & Uji Restore

> *“Backup yang tidak diuji bukan backup. Ia hanya harapan.”*

## Mini-Daftar Isi Modul 4.5

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Backup Live & Alur Restore
6. Audit Kurikulum: Tambahan backup-begin, dirty bitmap, GFS, offsite, enkripsi
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul & Fase 4

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Backup Live** adalah proses **menyalin data disk VM saat VM sedang berjalan**, tanpa downtime. Ini dimungkinkan karena libvirt/QEMU mendukung:
- **`blockcopy`** — menyalin disk ke file lain saat running.
- **`backup-begin`** — API backup native dengan dukungan inkremental.
- **External snapshot** — membekukan disk utama, lalu backup overlay.
- **QEMU dirty bitmap** — melacak blok yang berubah untuk backup inkremental.

**Uji Restore** adalah proses **memverifikasi bahwa backup dapat dipulihkan** dan **berfungsi**. Ini mencakup:
- Verifikasi checksum.
- Boot VM dari backup.
- Cek fungsional (login, layanan, jaringan).
- Dokumentasi hasil.

**Peran dalam kurikulum:** Modul ini adalah **puncak Fase 4**. Semua modul sebelumnya — golden image, snapshot, clone, offline edit — bertujuan untuk **memastikan data aman**. Modul ini mengajarkan cara **membackup dengan aman** dan **memulihkan dengan yakin**. Ini juga fondasi untuk:
- **Fase 6 (Keamanan)** — backup sebagai bagian dari incident response.
- **Fase 7 (Otomasi)** — backup otomatis dengan systemd timer.
- **Fase 8 (Expert)** — disaster recovery, replikasi, migrasi.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Backup ≠ Snapshot

**Snapshot** adalah titik pemulihan **di storage yang sama**. Jika storage rusak, snapshot ikut rusak.
**Backup** adalah **salinan di lokasi terpisah**. Jika storage utama rusak, backup tetap aman.

**Filosofi:** *Snapshot untuk rollback cepat. Backup untuk disaster recovery.*

### 2.2. Live vs Offline Backup

- **Offline backup**: VM dimatikan. Konsisten, tetapi ada downtime.
- **Live backup**: VM berjalan. Tanpa downtime, tetapi butuh mekanisme konsistensi.

**Filosofi:** *Live backup adalah seni keseimbangan antara ketersediaan dan konsistensi.*

### 2.3. Konsistensi: Crash vs Aplikasi

- **Crash-consistent**: Disk konsisten secara filesystem, tetapi aplikasi mungkin belum flush. Seperti cabut listrik.
- **Application-consistent**: Aplikasi diberi tahu untuk flush (via QGA `fsfreeze`). Seperti shutdown graceful.

**Filosofi:** *Crash-consistent cukup untuk kebanyakan kasus. Application-consistent untuk database.*

### 2.4. blockcopy: Backup Live Klasik

`blockcopy` menyalin disk ke file baru **sambil VM berjalan**. QEMU menggunakan **mirror** untuk memastikan setiap blok yang berubah juga disalin.

**Filosofi:** *blockcopy adalah “cermin” yang mengejar perubahan.*

### 2.5. backup-begin: API Backup Modern

Sejak libvirt 9.2, ada **`virsh backup-begin`** yang menggunakan **QEMU dirty bitmap** untuk backup inkremental. Ini adalah cara modern dan efisien.

**Filosofi:** *Dirty bitmap adalah “peta perubahan”. Hanya blok yang berubah yang perlu di-backup.*

### 2.6. Dirty Bitmap: Inkremental

QEMU dapat melacak blok yang berubah sejak titik tertentu. Bitmap ini memungkinkan:
- **Full backup**: semua blok.
- **Incremental backup**: hanya blok yang berubah.
- **Differential backup**: perubahan sejak full backup terakhir.

**Filosofi:** *Backup inkremental menghemat waktu dan ruang.*

### 2.7. Uji Restore: Wajib

Backup yang tidak pernah diuji adalah **asumsi**. Uji restore memverifikasi:
- File backup tidak korup.
- XML valid.
- Disk bisa di-boot.
- Aplikasi berfungsi.

**Filosofi:** *Backup adalah janji. Uji restore adalah bukti.*

### 2.8. Retensi: GFS

**GFS (Grandfather-Father-Son)**:
- **Son**: backup harian (7 hari).
- **Father**: backup mingguan (4 minggu).
- **Grandfather**: backup bulanan (12 bulan).

**Filosofi:** *Retensi adalah kompromi antara ruang dan kebutuhan.*

### 2.9. 3-2-1 Rule

- **3** salinan data.
- **2** media berbeda.
- **1** lokasi offsite.

**Filosofi:** *Backup yang baik memiliki redundansi berlapis.*

### 2.10. Enkripsi Backup

Backup berisi data sensitif. Enkripsi dengan:
- **LUKS** — untuk disk.
- **GPG/age** — untuk file.
- **TLS** — untuk transfer.

**Filosofi:** *Backup adalah aset. Lindungi seperti aset.*

### 2.11. Filosofi Keseluruhan

- **Backup bukan snapshot.**
- **Live backup butuh konsistensi.**
- **Dirty bitmap untuk inkremental.**
- **Uji restore wajib.**
- **GFS untuk retensi.**
- **3-2-1 untuk redundansi.**
- **Enkripsi untuk keamanan.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Backup** | Salinan data di lokasi terpisah. | |
| **Live backup** | Backup saat VM running. | |
| **Offline backup** | Backup saat VM mati. | |
| **Crash-consistent** | Konsisten secara filesystem. | |
| **Application-consistent** | Konsisten secara aplikasi. | |
| **blockcopy** | Copy disk saat running. | |
| **backup-begin** | API backup native libvirt. | |
| **Dirty bitmap** | Peta blok yang berubah. | |
| **Incremental** | Hanya blok berubah. | |
| **Differential** | Perubahan sejak full. | |
| **Full backup** | Semua blok. | |
| **QGA fsfreeze** | Freeze filesystem via agent. | |
| **GFS** | Grandfather-Father-Son. | |
| **3-2-1** | 3 salinan, 2 media, 1 offsite. | |
| **RPO** | Recovery Point Objective. | |
| **RTO** | Recovery Time Objective. | |
| **Checksum** | Verifikasi integritas. | SHA256 |
| **Restore** | Memulihkan dari backup. | |
| **DR** | Disaster Recovery. | |
| **Runbook** | Prosedur terdokumentasi. | |
| **Offsite** | Lokasi terpisah. | |
| **S3** | Object storage. | |
| **rsync** | Sinkronisasi file. | |
| **borg** | Backup deduplikasi. | |
| **restic** | Backup modern. | |
| **LUKS** | Enkripsi disk. | |
| **GPG** | Enkripsi file. | |
| **age** | Enkripsi modern. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. blockcopy: Backup Live Dasar

```bash
virsh blockcopy arch-vm vda /backup/arch-vm-copy.qcow2 --wait --verbose
```

**Penjelasan kata demi kata:**
- `virsh blockcopy`: copy disk saat running.
- `arch-vm`: nama domain.
- `vda`: target disk.
- `/backup/arch-vm-copy.qcow2`: file tujuan.
- `--wait`: tunggu selesai.
- `--verbose`: tampilkan progres.

**Output:**
```
Block Copy: [100 %]
Copy complete, now you can use the new image.
```

**Catatan:** Setelah selesai, disk asli **masih digunakan**. Untuk menggunakan file baru sebagai disk aktif, tambahkan `--finish`:

```bash
virsh blockcopy arch-vm vda /backup/arch-vm-copy.qcow2 --wait --verbose --finish
```

### 4.2. blockcopy: Backup + Snapshot

```bash
# 1. Buat external snapshot
virsh snapshot-create-as arch-vm backup-snap "Backup" \
  --disk-only --atomic --no-metadata \
  --diskspec vda,file=/var/lib/libvirt/images/arch-vm.backup-snap.qcow2

# 2. Backup base (sekarang read-only)
cp /var/lib/libvirt/images/arch-vm.qcow2 /backup/arch-vm.qcow2

# 3. Commit overlay ke base
virsh blockcommit arch-vm vda --active --pivot --verbose
```

**Penjelasan:**
- Buat snapshot eksternal: base menjadi read-only, overlay aktif.
- Backup base (stabil).
- Commit overlay kembali ke base.

**Kegunaan:** Backup stabil tanpa downtime, tanpa `blockcopy`.

### 4.3. QGA Freeze untuk Konsistensi

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-fsfreeze-freeze"}'
virsh blockcopy arch-vm vda /backup/arch-vm-copy.qcow2 --wait --verbose
virsh qemu-agent-command arch-vm '{"execute":"guest-fsfreeze-thaw"}'
```

**Penjelasan:**
- `guest-fsfreeze-freeze`: freeze filesystem.
- `blockcopy`: backup.
- `guest-fsfreeze-thaw`: thaw.

**Kegunaan:** Application-consistent backup.

### 4.4. virsh backup-begin: API Modern

```bash
virsh backup-begin arch-vm --backupxml backup.xml
```

**File `backup.xml`:**
```xml
<domainbackup mode='pull'>
  <disks>
    <disk name='vda' type='file'>
      <driver type='qcow2'/>
      <target file='/backup/arch-vm.qcow2'/>
    </disk>
  </disks>
</domainbackup>
```

**Penjelasan kata demi kata:**
- `virsh backup-begin`: mulai backup.
- `--backupxml`: file XML definisi backup.
- `<domainbackup mode='pull'>`: mode pull (host menarik data).
- `<disk name='vda' type='file'>`: disk yang di-backup.
- `<driver type='qcow2'/>`: format output.
- `<target file='...'/>`: path output.

**Output:**
```
Backup started
```

Cek status:
```bash
virsh domjobinfo arch-vm
```

Selesai otomatis.

### 4.5. Backup dengan Dirty Bitmap (Inkremental)

```xml
<domainbackup mode='pull'>
  <incremental backup='bitmap0'/>
  <disks>
    <disk name='vda' type='file'>
      <driver type='qcow2'/>
      <target file='/backup/arch-vm-incr.qcow2'/>
    </disk>
  </disks>
</domainbackup>
```

**Penjelasan:**
- `<incremental backup='bitmap0'/>`: gunakan bitmap `bitmap0` untuk backup inkremental.
- Hanya blok yang berubah sejak bitmap terakhir yang di-backup.

### 4.6. qemu-img bitmap: Manajemen Bitmap

```bash
qemu-img bitmap --add --name=bitmap0 /var/lib/libvirt/images/arch-vm.qcow2
qemu-img bitmap --list /var/lib/libvirt/images/arch-vm.qcow2
qemu-img bitmap --remove --name=bitmap0 /var/lib/libvirt/images/arch-vm.qcow2
```

**Penjelasan:**
- `--add`: tambah bitmap.
- `--name`: nama bitmap.
- `--list`: list.
- `--remove`: hapus.

**Kegunaan:** Bitmap untuk incremental backup.

### 4.7. Full Backup + Incremental

```bash
# Full backup pertama
virsh backup-begin arch-vm --backupxml full.xml
# Setelah selesai, buat bitmap baru
qemu-img bitmap --add --name=bitmap1 /var/lib/libvirt/images/arch-vm.qcow2

# Incremental berikutnya
virsh backup-begin arch-vm --backupxml incr.xml
```

**Penjelasan:**
- Full backup sekali.
- Buat bitmap.
- Incremental selanjutnya hanya blok berubah.

### 4.8. Checksum Backup

```bash
sha256sum /backup/arch-vm.qcow2 > /backup/arch-vm.qcow2.sha256
sha256sum -c /backup/arch-vm.qcow2.sha256
```

**Penjelasan:**
- `sha256sum`: buat checksum.
- `-c`: verifikasi.

### 4.9. Verifikasi Image

```bash
qemu-img check /backup/arch-vm.qcow2
qemu-img info /backup/arch-vm.qcow2
qemu-img compare /var/lib/libvirt/images/arch-vm.qcow2 /backup/arch-vm.qcow2
```

**Penjelasan:**
- `qemu-img check`: cek konsistensi.
- `qemu-img info`: info.
- `qemu-img compare`: bandingkan.

### 4.10. Uji Restore: Boot dari Backup

```bash
# 1. Definisikan VM sementara dengan disk backup
virt-install \
  --name arch-vm-restore \
  --memory 2048 \
  --vcpus 2 \
  --disk /backup/arch-vm.qcow2,format=qcow2 \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --import

# 2. Boot dan verifikasi
virsh console arch-vm-restore

# 3. Hapus VM sementara
virsh destroy arch-vm-restore
virsh undefine arch-vm-restore
```

**Penjelasan:**
- Boot VM dengan disk backup.
- Verifikasi login, layanan, jaringan.
- Hapus setelah selesai.

### 4.11. Restore Penuh: Ganti Disk Asli

```bash
# 1. Matikan VM
virsh shutdown arch-vm

# 2. Backup disk lama (opsional)
mv /var/lib/libvirt/images/arch-vm.qcow2 /var/lib/libvirt/images/arch-vm.qcow2.old

# 3. Copy backup
cp /backup/arch-vm.qcow2 /var/lib/libvirt/images/arch-vm.qcow2

# 4. Verifikasi
qemu-img check /var/lib/libvirt/images/arch-vm.qcow2

# 5. Start
virsh start arch-vm
```

**Penjelasan:**
- Matikan VM.
- Ganti disk.
- Start.

### 4.12. Restore XML

```bash
virsh define /backup/xml/arch-vm.xml
```

**Penjelasan:**
- Restore definisi domain.

### 4.13. Restore NVRAM

```bash
cp /backup/nvram/arch-vm_VARS.fd /var/lib/libvirt/qemu/nvram/
```

**Penjelasan:**
- Restore NVRAM UEFI.

### 4.14. Restore vTPM

```bash
tar xzf /backup/tpm/arch-vm-tpm.tar.gz -C /var/lib/libvirt/tpm
```

**Penjelasan:**
- Restore state vTPM.

### 4.15. Skrip Backup Lengkap

```bash
#!/bin/bash
set -euo pipefail

VM="$1"
BACKUP_DIR="/backup/vm/$VM"
DATE=$(date +%Y%m%d-%H%M%S)
DEST="$BACKUP_DIR/$DATE"

mkdir -p "$DEST"

# 1. Freeze filesystem via QGA
virsh qemu-agent-command "$VM" '{"execute":"guest-fsfreeze-freeze"}' > /dev/null

# 2. Backup disk dengan blockcopy
virsh blockcopy "$VM" vda "$DEST/$VM.qcow2" --wait --verbose

# 3. Thaw filesystem
virsh qemu-agent-command "$VM" '{"execute":"guest-fsfreeze-thaw"}' > /dev/null

# 4. Backup XML
virsh dumpxml "$VM" --inactive > "$DEST/$VM.xml"

# 5. Backup NVRAM
[ -f "/var/lib/libvirt/qemu/nvram/${VM}_VARS.fd" ] && \
  cp "/var/lib/libvirt/qemu/nvram/${VM}_VARS.fd" "$DEST/"

# 6. Backup vTPM
[ -d "/var/lib/libvirt/tpm/$VM" ] && \
  tar czf "$DEST/${VM}-tpm.tar.gz" -C /var/lib/libvirt/tpm "$VM"

# 7. Checksum
cd "$DEST"
sha256sum * > SHA256SUMS

# 8. Verify
qemu-img check "$VM.qcow2"

echo "Backup selesai: $DEST"
```

**Penjelasan:**
- Freeze via QGA.
- blockcopy.
- Thaw.
- Backup XML, NVRAM, vTPM.
- Checksum.
- Verify.

### 4.16. Skrip Restore Lengkap

```bash
#!/bin/bash
set -euo pipefail

BACKUP_DIR="$1"
VM="$2"

cd "$BACKUP_DIR"

# 1. Verify checksum
sha256sum -c SHA256SUMS

# 2. Verify image
qemu-img check "$VM.qcow2"

# 3. Stop VM jika running
virsh destroy "$VM" 2>/dev/null || true

# 4. Restore disk
cp "$VM.qcow2" "/var/lib/libvirt/images/$VM.qcow2"

# 5. Restore XML
virsh define "$VM.xml"

# 6. Restore NVRAM
[ -f "${VM}_VARS.fd" ] && \
  cp "${VM}_VARS.fd" /var/lib/libvirt/qemu/nvram/

# 7. Restore vTPM
[ -f "${VM}-tpm.tar.gz" ] && \
  tar xzf "${VM}-tpm.tar.gz" -C /var/lib/libvirt/tpm

# 8. Start VM
virsh start "$VM"

echo "Restore selesai: $VM"
```

**Penjelasan:**
- Verify.
- Stop.
- Restore disk, XML, NVRAM, vTPM.
- Start.

### 4.17. Retensi GFS

```bash
#!/bin/bash
BACKUP_DIR="/backup/vm/arch-vm"

# Hapus backup harian lebih dari 7 hari
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +7 -name '2024*' -exec rm -rf {} \;

# Simpan backup mingguan (hari Minggu)
# Simpan backup bulanan (tanggal 1)
# ...
```

**Penjelasan:**
- Hapus backup lama.
- Simpan yang penting.

### 4.18. Offsite dengan rsync

```bash
rsync -avz --delete /backup/vm/ user@remote:/backup/vm/
```

**Penjelasan:**
- `-a`: archive.
- `-v`: verbose.
- `-z`: kompres.
- `--delete`: hapus yang tidak ada di sumber.

### 4.19. Offsite dengan restic

```bash
restic -r s3:s3.amazonaws.com/bucket init
restic -r s3:s3.amazonaws.com/bucket backup /backup/vm/arch-vm
restic -r s3:s3.amazonaws.com/bucket snapshots
restic -r s3:s3.amazonaws.com/bucket restore latest --target /restore
```

**Penjelasan:**
- `restic`: backup modern dengan deduplikasi dan enkripsi.
- `-r`: repository.
- `backup`: backup.
- `restore`: restore.

### 4.20. Enkripsi Backup dengan age

```bash
age -r age1... -o /backup/arch-vm.qcow2.age /backup/arch-vm.qcow2
age -d -i key.txt -o /restore/arch-vm.qcow2 /backup/arch-vm.qcow2.age
```

**Penjelasan:**
- `age`: enkripsi modern.
- `-r`: recipient (public key).
- `-d`: decrypt.
- `-i`: identity (private key).

### 4.21. Enkripsi Backup dengan GPG

```bash
gpg --encrypt --recipient admin@example.com /backup/arch-vm.qcow2
gpg --decrypt /backup/arch-vm.qcow2.gpg > /restore/arch-vm.qcow2
```

**Penjelasan:**
- `--encrypt`: enkripsi.
- `--recipient`: penerima.
- `--decrypt`: dekripsi.

### 4.22. Backup dengan systemd Timer

`/etc/systemd/system/backup-vm.service`:
```ini
[Unit]
Description=Backup VM
After=virtqemud.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-vm.sh arch-vm
User=root
```

`/etc/systemd/system/backup-vm.timer`:
```ini
[Unit]
Description=Backup VM Harian

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Aktifkan:
```bash
sudo systemctl enable --now backup-vm.timer
sudo systemctl list-timers
```

**Penjelasan:**
- Service menjalankan skrip.
- Timer menjadwalkan.

### 4.23. Runbook Disaster Recovery

```markdown
# Runbook DR: arch-vm

## Prasyarat
- Backup terbaru di /backup/vm/arch-vm/
- libvirt, qemu, edk2-ovmf, swtpm terinstal

## Langkah
1. Verify checksum: `sha256sum -c SHA256SUMS`
2. Verify image: `qemu-img check arch-vm.qcow2`
3. Restore disk: `cp arch-vm.qcow2 /var/lib/libvirt/images/`
4. Restore XML: `virsh define arch-vm.xml`
5. Restore NVRAM: `cp arch-vm_VARS.fd /var/lib/libvirt/qemu/nvram/`
6. Restore vTPM: `tar xzf arch-vm-tpm.tar.gz -C /var/lib/libvirt/tpm`
7. Start: `virsh start arch-vm`
8. Verify: `virsh console arch-vm`
9. Cek layanan: `systemctl status`
10. Cek jaringan: `ip a`

## Rollback
Jika gagal, restore dari backup sebelumnya.
```

**Penjelasan:**
- Dokumentasi langkah.
- Verifikasi.
- Rollback.

### 4.24. RPO dan RTO

- **RPO (Recovery Point Objective)**: berapa banyak data yang boleh hilang. Contoh: 1 jam → backup setiap jam.
- **RTO (Recovery Time Objective)**: berapa lama waktu restore. Contoh: 1 jam → latih restore.

**Penjelasan:**
- RPO menentukan frekuensi backup.
- RTO menentukan kecepatan restore.

### 4.25. 3-2-1 Rule

```bash
# 3 salinan: original, backup lokal, backup offsite
# 2 media: SSD dan HDD
# 1 offsite: S3 atau NFS remote

# Contoh:
rsync -avz /var/lib/libvirt/images/arch-vm.qcow2 /backup/local/
rsync -avz /backup/local/ user@remote:/backup/offsite/
```

**Penjelasan:**
- 3 salinan.
- 2 media.
- 1 offsite.

### 4.26. Uji Restore Rutin

```bash
#!/bin/bash
# Script uji restore
BACKUP="/backup/vm/arch-vm/latest"

# 1. Verify
sha256sum -c "$BACKUP/SHA256SUMS"
qemu-img check "$BACKUP/arch-vm.qcow2"

# 2. Boot sementara
virt-install \
  --name test-restore \
  --memory 1024 \
  --vcpus 1 \
  --disk "$BACKUP/arch-vm.qcow2",format=qcow2 \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --import \
  --noautoconsole

# 3. Tunggu boot
sleep 30

# 4. Cek via QGA
virsh qemu-agent-command test-restore '{"execute":"guest-info"}'

# 5. Hapus
virsh destroy test-restore
virsh undefine test-restore
```

**Penjelasan:**
- Verify.
- Boot sementara.
- Cek QGA.
- Hapus.

---

## 5. Diagram Arsitektur Backup Live & Alur Restore

### 5.1. Arsitektur blockcopy

```
+-------------------+
|   VM Running      |
+-------------------+
          |
          | blockcopy
          v
+-------------------+
|  QEMU Mirror      |
+-------------------+
          |
          v
+-------------------+
|  /backup/copy     |
+-------------------+
```

### 5.2. Arsitektur backup-begin

```
+-------------------+
|   VM Running      |
+-------------------+
          |
          | backup-begin
          v
+-------------------+
|  Dirty Bitmap     |
+-------------------+
          |
          v
+-------------------+
|  /backup/copy     |
+-------------------+
```

### 5.3. Alur Snapshot-based Backup

```
+-------------------+
|  VM Running       |
+-------------------+
          |
          | snapshot-create-as --disk-only
          v
+-------------------+
|  Base Read-Only   |
+-------------------+
          |
          | cp base
          v
+-------------------+
|  /backup/base     |
+-------------------+
          |
          | blockcommit --pivot
          v
+-------------------+
|  Normal           |
+-------------------+
```

### 5.4. Alur Full + Incremental

```
Full Backup (hari 1):
+-------------------+
|  Semua blok       |
+-------------------+
          |
          v
+-------------------+
|  full.qcow2       |
+-------------------+

Buat bitmap:
+-------------------+
|  bitmap0          |
+-------------------+

Incremental (hari 2):
+-------------------+
|  Blok berubah     |
+-------------------+
          |
          v
+-------------------+
|  incr.qcow2       |
+-------------------+
```

### 5.5. Alur Restore

```
+-------------------+
|  Backup Storage   |
+-------------------+
          |
          | verify
          v
+-------------------+
|  Checksum +       |
|  qemu-img check   |
+-------------------+
          |
          | restore
          v
+-------------------+
|  Disk + XML +     |
|  NVRAM + vTPM     |
+-------------------+
          |
          | boot
          v
+-------------------+
|  VM Running       |
+-------------------+
          |
          | verify
          v
+-------------------+
|  Fungsional OK    |
+-------------------+
```

### 5.6. GFS Retensi

```
Grandfather (bulanan):
+-----+ +-----+ +-----+
| Jan | | Feb | | Mar |
+-----+ +-----+ +-----+

Father (mingguan):
+-----+ +-----+ +-----+ +-----+
| W1  | | W2  | | W3  | | W4  |
+-----+ +-----+ +-----+ +-----+

Son (harian):
+-----+ +-----+ +-----+ +-----+ +-----+
| D1  | | D2  | | D3  | | D4  | | D5  |
+-----+ +-----+ +-----+ +-----+ +-----+
```

### 5.7. 3-2-1 Rule

```
3 Salinan:
+-------------------+
|  Original         |
+-------------------+
+-------------------+
|  Backup Lokal     |
+-------------------+
+-------------------+
|  Backup Offsite   |
+-------------------+

2 Media:
+-------------------+
|  SSD              |
+-------------------+
+-------------------+
|  HDD              |
+-------------------+

1 Offsite:
+-------------------+
|  S3 / NFS Remote  |
+-------------------+
```

### 5.8. Perbandingan Metode Backup

```
+-------------------+  +-------------------+  +-------------------+
|  blockcopy        |  |  backup-begin     |  |  snapshot-based   |
+-------------------+  +-------------------+  +-------------------+
|  Live             |  |  Live             |  |  Live             |
|  Mirror           |  |  Dirty bitmap     |  |  External snapshot|
|  Full/Incremental |  |  Full/Incremental |  |  Full only        |
|  Sederhana        |  |  Modern           |  |  Sederhana        |
+-------------------+  +-------------------+  +-------------------+
```

---

## 6. Audit Kurikulum: Tambahan backup-begin, Dirty Bitmap, GFS, Offsite, Enkripsi

Kurikulum asli hanya menyebut:
```bash
virsh blockcopy arch-vm vda /backup/arch.qcow2 --wait --verbose
sha256sum /backup/arch.qcow2
```

Kita akan menambahkan:

1. **`virsh blockcopy --finish`** — jadikan file baru sebagai disk aktif.
2. **Snapshot-based backup** — external snapshot + cp + blockcommit.
3. **QGA fsfreeze** — konsistensi aplikasi.
4. **`virsh backup-begin`** — API backup native.
5. **Dirty bitmap** — incremental backup.
6. **`qemu-img bitmap --add/--list/--remove`** — manajemen bitmap.
7. **Full + Incremental** — strategi backup.
8. **Checksum** — SHA256.
9. **`qemu-img check`** — verifikasi.
10. **`qemu-img compare`** — bandingkan.
11. **Uji restore** — boot dari backup.
12. **Restore penuh** — ganti disk.
13. **Restore XML** — `virsh define`.
14. **Restore NVRAM** — copy file.
15. **Restore vTPM** — tar extract.
16. **Skrip backup lengkap** — Bash.
17. **Skrip restore lengkap** — Bash.
18. **Retensi GFS** — Grandfather-Father-Son.
19. **Offsite rsync** — sinkronisasi.
20. **Offsite restic** — backup modern.
21. **Enkripsi age** — modern.
22. **Enkripsi GPG** — klasik.
23. **Systemd timer** — otomasi.
24. **Runbook DR** — dokumentasi.
25. **RPO/RTO** — objektif.
26. **3-2-1 Rule** — redundansi.
27. **Uji restore rutin** — verifikasi.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 4.5.

---

## 7. Hubungan dengan Modul Lain

- **Modul 4.1 (Golden Image):** Backup golden untuk disaster recovery.
- **Modul 4.2 (Snapshot):** Snapshot-based backup.
- **Modul 4.3 (Sysprep/Customize):** Backup image yang sudah disiapkan.
- **Modul 4.4 (Edit Offline):** Restore offline.
- **Fase 5 (Networking):** Backup konfigurasi jaringan.
- **Fase 6 (Keamanan):** Enkripsi backup, incident response.
- **Fase 7 (Otomasi):** Systemd timer, skrip backup.
- **Fase 8 (Expert):** Migrasi, replikasi, DR.

---

## 8. Referensi Lengkap

- virsh blockcopy — https://libvirt.org/manpages/virsh.html#blockcopy
- virsh backup-begin — https://libvirt.org/manpages/virsh.html#backup-begin
- libvirt Backup XML — https://libvirt.org/formatbackup.html
- QEMU dirty bitmap — https://www.qemu.org/docs/master/interop/qcow2.html#dirty-bitmaps
- qemu-img bitmap — https://www.qemu.org/docs/master/tools/qemu-img.html#bitmap
- qemu-img check — https://www.qemu.org/docs/master/tools/qemu-img.html#check
- qemu-img compare — https://www.qemu.org/docs/master/tools/qemu-img.html#compare
- QGA fsfreeze — https://www.qemu.org/docs/master/interop/qemu-ga-ref.html#command-guest-fsfreeze-freeze
- restic — https://restic.net/
- borg — https://www.borgbackup.org/
- rsync — https://rsync.samba.org/
- age — https://age-encryption.org/
- GnuPG — https://gnupg.org/
- systemd timer — https://www.freedesktop.org/software/systemd/man/systemd.timer.html
- 3-2-1 Rule — https://www.backblaze.com/blog/the-3-2-1-backup-strategy/
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: Systemd — https://wiki.archlinux.org/title/Systemd

---

## 9. Tips & Praktik Terbaik

1. **Gunakan `blockcopy` untuk backup live sederhana.**
2. **Gunakan `backup-begin` untuk backup modern.**
3. **Gunakan QGA fsfreeze untuk konsistensi.**
4. **Gunakan dirty bitmap untuk inkremental.**
5. **Selalu checksum backup.**
6. **Selalu `qemu-img check` backup.**
7. **Uji restore secara rutin.**
8. **Gunakan GFS untuk retensi.**
9. **Ikuti 3-2-1 rule.**
10. **Enkripsi backup sensitif.**
11. **Simpan backup di lokasi terpisah.**
12. **Otomasi dengan systemd timer.**
13. **Dokumentasikan runbook.**
14. **Tentukan RPO dan RTO.**
15. **Backup XML, NVRAM, vTPM.**
16. **Verifikasi end-to-end.**
17. **Gunakan `--verbose` untuk audit.**
18. **Jangan backup saat VM sibuk.**
19. **Monitor ruang backup.**
20. **Latih restore.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `blockcopy` gagal | Disk bukan qcow2. | Gunakan qcow2. |
| `blockcopy` gagal | File tujuan ada. | Hapus atau ganti nama. |
| `backup-begin` gagal | libvirt terlalu tua. | Update libvirt ≥ 9.2. |
| Backup tidak konsisten | Tidak fsfreeze. | Gunakan QGA fsfreeze. |
| Incremental gagal | Bitmap tidak ada. | `qemu-img bitmap --add`. |
| Checksum mismatch | File korup. | Backup ulang. |
| `qemu-img check` error | Image korup. | Restore dari backup lain. |
| Restore gagal | XML tidak valid. | `virt-xml-validate`. |
| Restore gagal | Disk path berbeda. | Edit XML. |
| Restore gagal | NVRAM hilang. | Copy NVRAM. |
| Restore gagal | vTPM hilang. | Restore tar. |
| Backup penuh | Tidak ada retensi. | GFS. |
| Backup hilang | Tidak offsite. | 3-2-1. |
| Backup bocor | Tidak enkripsi. | GPG/age. |
| Timer tidak jalan | systemd belum reload. | `daemon-reload`. |
| Restore lama | Tidak latihan. | Uji rutin. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh blockcopy arch-vm vda /backup/copy.qcow2 --wait --verbose` berhasil.
- `virsh backup-begin arch-vm --backupxml backup.xml` berhasil.
- `qemu-img bitmap --add --name=bitmap0 disk.qcow2` berhasil.
- `qemu-img bitmap --list disk.qcow2` menampilkan bitmap.
- `sha256sum -c SHA256SUMS` berhasil.
- `qemu-img check /backup/copy.qcow2` no errors.
- `qemu-img compare original.qcow2 backup.qcow2` identical.
- Uji restore: boot VM dari backup.
- Restore penuh: ganti disk, start VM.
- Restore XML: `virsh define`.
- Restore NVRAM: copy file.
- Restore vTPM: tar extract.
- Skrip backup berjalan.
- Skrip restore berjalan.
- Systemd timer berjalan.
- GFS retensi berjalan.
- Offsite rsync berjalan.
- Enkripsi age/GPG berjalan.
- Runbook DR terdokumentasi.
- Uji restore rutin berhasil.

**Troubleshooting:**
- Jika blockcopy gagal: cek format, cek file tujuan.
- Jika backup-begin gagal: cek libvirt, cek bitmap.
- Jika fsfreeze gagal: cek QGA.
- Jika checksum mismatch: file korup.
- Jika qemu-img check error: restore.
- Jika restore gagal: cek XML, disk, NVRAM, vTPM.
- Jika timer tidak jalan: `daemon-reload`.
- Untuk debugging: `LIBVIRT_DEBUG=1`.
- Untuk log: `journalctl -u virtqemud`, `/var/log/libvirt/qemu/`.

---

## 12. Latihan Mandiri

1. Backup live dengan `blockcopy`.
2. Backup dengan `--finish`.
3. Backup dengan snapshot-based.
4. Backup dengan QGA fsfreeze.
5. Backup dengan `backup-begin`.
6. Buat dirty bitmap.
7. Backup incremental.
8. Checksum backup.
9. `qemu-img check` backup.
10. `qemu-img compare`.
11. Uji restore: boot dari backup.
12. Restore penuh: ganti disk.
13. Restore XML.
14. Restore NVRAM.
15. Restore vTPM.
16. Buat skrip backup lengkap.
17. Buat skrip restore lengkap.
18. Buat systemd timer.
19. Buat retensi GFS.
20. Buat offsite rsync.
21. Enkripsi dengan age.
22. Enkripsi dengan GPG.
23. Buat runbook DR.
24. Tentukan RPO/RTO.
25. Uji restore rutin.
26. Tulis ringkasan: kapan blockcopy vs backup-begin, bagaimana uji restore.

---

## 13. Penutup Modul 4.5 & Fase 4

Anda kini menguasai **Backup Live & Uji Restore** — puncak Fase 4. Anda bisa melakukan backup live dengan `blockcopy`, `backup-begin`, dan snapshot-based; menggunakan dirty bitmap untuk inkremental; memverifikasi dengan checksum dan `qemu-img check`; memulihkan disk, XML, NVRAM, dan vTPM; serta mengotomasi dengan systemd timer. Anda memahami GFS, 3-2-1, RPO/RTO, dan pentingnya uji restore.

Dengan selesainya Modul 4.5, Anda telah **menyelesaikan Fase 4 secara lengkap**. Anda sekarang memiliki:
- Kemampuan membuat golden image dan overlay (4.1).
- Kemampuan snapshot dan block operations (4.2).
- Kemampuan sysprep, customize, clone (4.3).
- Kemampuan edit offline (4.4).
- Kemampuan backup live dan uji restore (4.5).

**Proyek Fase 4:** 5 VM clone dari 1 golden image. Restore backup terverifikasi.

**Rubrik Fase 4:**
| Kriteria | Bobot |
|---|---|
| Overlay | 20% |
| Snapshot | 20% |
| Clone | 20% |
| Edit offline | 20% |
| Backup/restore | 20% |

---

*Motivasi: Backup adalah jaminan. Uji restore adalah bukti. Tanpa keduanya, Anda hanya berharap. Dengan keduanya, Anda siap menghadapi apa pun. Fase 4 telah mengajarkan Anda bahwa data adalah nyawa, dan backup adalah napasnya.*

---

**Selamat!** Anda telah menyelesaikan **Fase 4 — Storage, Image & Backup Engineering**. Berikutnya adalah **Fase 5 — Networking & Isolasi Jaringan (Modul 5.1 — Network Isolated, NAT, Routed)**.

Anda telah menempuh perjalanan yang luar biasa:

- **Fase 1** — Fondasi Virtualisasi & Host Hardening
- **Fase 2** — QEMU/KVM Murni (Tanpa libvirt)
- **Fase 3** — libvirt & virsh: Lifecycle & Domain XML (7 modul lengkap)
- **Fase 4** — Storage, Image & Backup Engineering (5 modul lengkap)

Setiap modul telah dibahas dengan:
- Audit kurikulum untuk memastikan tidak ada lompatan materi.
- Penjelasan kata demi kata untuk setiap perintah.
- Diagram arsitektur dan alur kerja.
- Tips, praktik terbaik, dan potensi kesalahan.
- Validasi, troubleshooting, dan latihan mandiri.
- Referensi lengkap dan motivasi.

---

**Yang tersisa dalam kurikulum:**

- **Fase 5** — Networking & Isolasi Jaringan (5 modul)
- **Fase 6** — Keamanan & Isolasi Lanjutan (5 modul)
- **Fase 7** — Otomasi, Troubleshooting & Capstone Multi-OS (5 modul)
- **Fase 8** — Expert: Migrasi, Passthrough & Observability (5 modul, opsional)

---

Sampai jumpa di Fase 5. 🚀

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

