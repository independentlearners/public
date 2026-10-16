## Motivasi Awal

Selamat! Anda telah menuntaskan Fase 2 — QEMU/KVM murni. Anda kini berdiri di ambang pintu **libvirt**, jembatan yang mengubah kekacauan flag QEMU menjadi **abstraksi terkelola**. Di Fase 3 ini, Anda akan belajar mengendalikan VM bukan lagi dengan mengetik puluhan argumen, melainkan melalui **XML deklaratif** dan **perintah `virsh`** yang ringkas. Inilah saatnya Anda naik dari “tukang ketik QEMU” menjadi **arsitek infrastruktur virtual**. Tetap semangat, karena di sinilah fondasi otomasi, keamanan, dan skalabilitas dimulai.

---

## Audit Kurikulum Fase 3

Sebelum masuk ke materi, saya melakukan audit terhadap `kurikulum.md` dan `README.md` Fase 2. Berikut temuan dan rekomendasi penyesuaian:

### Kesesuaian Prasyarat
- Fase 3 membutuhkan **Fase 2 lulus**. Sudah tepat.
- Prasyarat tambahan: **dasar XML** perlu ditekankan. Kurikulum sudah menyebut, tetapi belum ada modul khusus XML. Saya akan menyisipkan **pengenalan XML** di awal Modul 3.2.

### Topik yang Perlu Ditambahkan
Kurikulum Fase 3 saat ini mencakup:
1. `virt-install` Headless
2. Anatomi Domain XML
3. Lifecycle
4. Storage Pool & Volume
5. Monitoring

Namun ada beberapa topik penting yang **belum eksplisit** dan akan saya tambahkan secara bertahap:
- **XML Namespace dan Schema** — memahami `xmlns:qemu`, validasi dengan `virt-xml-validate`.
- **virt-xml** — alat untuk mengedit XML secara terprogram.
- **Console & Serial Access** — `virsh console`, `virsh ttyconsole`.
- **Manajemen Resource dengan `virsh`** — `domblklist`, `domiflist`, `dommemstat`.
- **Autostart & Boot Order** — `virsh autostart`, `<boot order='1'/>`.
- **Snapshot Dasar** — `virsh snapshot-create-as`, meskipun lebih dalam di Fase 4.
- **Migrasi Offline** — `virsh migrate --offline` (pengantar ke Fase 8).
- **Backup XML** — `virsh dumpxml` dan `virsh define`.
- **Hooks** — pengantar ke Fase 7, tetapi disebut di sini sebagai eksplorasi.
- **Keamanan Dasar** — `virsh edit` dengan validasi, menghindari kesalahan XML.

### Potensi Lonjakan
- Modul 3.4 (Storage Pool) langsung membahas pool, padahal di Fase 2 Anda sudah menggunakan `qemu-img`. Ini baik, tetapi perlu jembatan: **dari qcow2 manual ke volume libvirt**.
- Modul 3.5 (Monitoring) bisa diperluas dengan `virt-top`, `domstats`, dan **`virsh domcontrol`**.

### Rekomendasi Struktur Baru Fase 3
1. Modul 3.1 — `virt-install` Headless
2. Modul 3.2 — Anatomi Domain XML + Validasi
3. Modul 3.3 — Lifecycle: start, suspend, save/restore, autostart
4. Modul 3.4 — Storage Pool & Volume
5. Modul 3.5 — Monitoring & Diagnostik
6. Modul 3.6 — (Tambahan) Konsol, Serial, dan Akses Headless
7. Modul 3.7 — (Tambahan) Backup & Restore XML

Saya akan mulai dari **Modul 3.1** dan secara bertahap melanjutkan sesuai konfirmasi Anda.

---

## Mini-Daftar Isi Fase 3

<details>
  <summary>📃 Daftar Isi</summary>

---


1. **Modul 3.1 — `virt-install` Headless**
   - 1.1 Deskripsi Konkret & Peran
   - 1.2 Konsep Kunci & Filosofi
   - 1.3 Terminologi Esensial
   - 1.4 Sintaks Dasar & Penjelasan Kata demi Kata
   - 1.5 Diagram Alur `virt-install`
   - 1.6 Audit Kurikulum: Tambahan Opsi `virt-install`
   - 1.7 Hubungan dengan Modul Lain
   - 1.8 Referensi Lengkap
   - 1.9 Tips & Praktik Terbaik
   - 1.10 Potensi Kesalahan Umum & Solusi
   - 1.11 Validasi & Troubleshooting
   - 1.12 Latihan Mandiri

2. Modul 3.2 — Anatomi Domain XML
3. Modul 3.3 — Lifecycle
4. Modul 3.4 — Storage Pool & Volume
5. Modul 3.5 — Monitoring & Diagnostik
6. Modul 3.6 — Konsol, Serial, dan Akses Headless
7. Modul 3.7 — Backup & Restore XML

</details>

---

# Modul 3.1 — `virt-install` Headless

## 1. Deskripsi Konkret & Peran dalam Kurikulum

`virt-install` adalah **pintu masuk resmi** ke dunia libvirt. Ia adalah alat baris perintah yang menghasilkan **domain XML** secara otomatis berdasarkan opsi yang Anda berikan, lalu memanggil libvirt untuk membuat dan menjalankan VM. Jika di Fase 2 Anda merakit VM dengan puluhan flag QEMU, di sini Anda cukup memberikan parameter tingkat tinggi seperti `--name`, `--memory`, `--vcpus`, `--disk`, dan `--cdrom`.

**Peran dalam kurikulum:** Modul ini adalah **jembatan** dari QEMU murni ke libvirt. Anda akan memahami bahwa `virt-install` sebenarnya hanyalah pembungkus yang menghasilkan XML dan memanggil `virsh define` + `virsh start`. Setelah menguasai modul ini, Anda akan siap membaca dan memodifikasi XML secara manual di Modul 3.2.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **Deklaratif vs Imperatif:** QEMU murni bersifat imperatif (Anda mengetik perintah satu per satu). libvirt bersifat deklaratif (Anda mendefinisikan keadaan yang diinginkan dalam XML, libvirt yang mewujudkannya).
- **Abstraksi:** `virt-install` menyembunyikan kompleksitas flag QEMU. Anda tidak perlu tahu `-device virtio-net-pci`; cukup `--network network=default,model=virtio`.
- **Sumber Kebenaran Tunggal:** XML adalah sumber kebenaran. `virt-install` hanya alat bantu untuk menghasilkan XML awal. Setelah VM dibuat, Anda bisa mengedit XML dengan `virsh edit`.
- **Headless First:** Karena kita berada di lingkungan TUI, `virt-install` mendukung `--graphics none` dan `--console pty,target_type=serial`. Ini memaksa instalasi melalui serial console.
- **Filosofi:** Otomasi dan reproduksibilitas. Dengan menyimpan perintah `virt-install` dalam skrip, Anda bisa membangun ulang VM yang sama kapan saja.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **virt-install** | Alat CLI untuk membuat VM baru di libvirt. | `virt-install --name ...`. |
| **Domain** | Istilah libvirt untuk VM. | `virsh list --all`. |
| **XML** | Format konfigurasi domain. | `virsh dumpxml`. |
| **`--name`** | Nama unik VM. | `arch-vm`. |
| **`--memory`** | Memori dalam MiB. | `1024`. |
| **`--vcpus`** | Jumlah vCPU. | `2`. |
| **`--disk`** | Disk virtual. | `size=10,format=qcow2`. |
| **`--cdrom`** | ISO instalasi. | `arch.iso`. |
| **`--os-variant`** | Optimasi untuk OS tertentu. | `archlinux`, `win10`. |
| **`--graphics`** | Mode grafis. | `none` untuk headless. |
| **`--console`** | Konsol serial. | `pty,target_type=serial`. |
| **`--network`** | Jaringan. | `network=default,model=virtio`. |
| **`--location`** | URL atau path ke instalasi. | `https://...`. |
| **`--extra-args`** | Argumen kernel tambahan. | `console=ttyS0`. |
| **`--import`** | Impor disk yang sudah ada. | Tanpa instalasi. |
| **`--boot`** | Opsi boot. | `hd,cdrom`. |
| **`--noreboot`** | Jangan reboot setelah instalasi. | Untuk debugging. |
| **`--wait`** | Tunggu hingga instalasi selesai. | `-1` untuk tidak menunggu. |
| **`--noautoconsole`** | Jangan buka konsol otomatis. | Untuk skrip. |
| **`--print-xml`** | Cetak XML tanpa membuat VM. | Untuk inspeksi. |
| **`--dry-run`** | Simulasi tanpa eksekusi. | Untuk validasi. |
| **`--check`** | Cek apakah VM bisa dibuat. | `--check all=off`. |
| **`--keymap`** | Layout keyboard. | `en-us`. |
| **`--sound`** | Perangkat suara. | `none` untuk headless. |
| **`--hostdev`** | Passthrough perangkat. | Fase 8. |
| **`--filesystem`** | Berbagi direktori. | `source=/host/share,target=share`. |
| **`--controller`** | Menambah controller. | `type=scsi,model=virtio-scsi`. |
| **`--redirdev`** | Redirect perangkat USB. | Jarang di headless. |
| **`--memballoon`** | Balloon device. | `model=virtio`. |
| **`--rng`** | Random number generator. | `device=/dev/urandom`. |
| **`--tpm`** | TPM virtual. | `backend=emulator,model=tpm-tis`. |
| **`--panic`** | Perilaku saat panic. | `default`. |
| **`--cpu`** | Model CPU. | `host`, `host-passthrough`. |
| **`--numatune`** | NUMA tuning. | Fase 8. |
| **`--cputune`** | CPU pinning. | Fase 8. |
| **`--metadata`** | Metadata domain. | `name=...,uuid=...`. |
| **`--qemu-commandline`** | Argumen QEMU tambahan. | Untuk flag yang belum didukung. |

---

## 4. Sintaks Dasar & Penjelasan Kata demi Kata

### 4.1. Perintah Dasar `virt-install`

```bash
virt-install \
  --name arch-vm \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10,format=qcow2 \
  --cdrom /var/lib/libvirt/images/archlinux-x86_64.iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --import
```

**Penjelasan kata demi kata:**

- `virt-install`: perintah utama.
- `\`: line continuation (agar mudah dibaca).
- `--name arch-vm`: nama domain. Harus unik di antara VM yang ada.
- `--memory 1024`: memori guest dalam MiB. 1024 MiB = 1 GiB.
- `--vcpus 2`: jumlah vCPU.
- `--disk size=10,format=qcow2`: buat disk baru berukuran 10 GiB dengan format qcow2. libvirt akan menempatkannya di storage pool default (biasanya `/var/lib/libvirt/images`).
- `--cdrom /path/to/archlinux.iso`: pasang ISO sebagai CD-ROM. Ini juga menambahkan boot order ke CD-ROM.
- `--os-variant archlinux`: optimasi untuk Arch Linux. libvirt menyesuaikan driver, model perangkat, dan fitur.
- `--graphics none`: tidak ada grafis. Wajib untuk headless murni.
- `--console pty,target_type=serial`: tambahkan konsol serial. `pty` berarti pseudo-terminal; `target_type=serial` berarti konsol serial.
- `--network network=default,model=virtio`: gunakan jaringan libvirt `default` (biasanya NAT) dengan model NIC `virtio`.
- `--import`: **penting!** Ini memberi tahu `virt-install` bahwa disk sudah berisi OS dan tidak perlu instalasi. Jika Anda ingin instalasi dari ISO, hilangkan `--import` dan tambahkan `--location` atau biarkan `--cdrom` memicu instalasi.

**Catatan:** Untuk instalasi dari ISO, Anda biasanya **tidak** menggunakan `--import`. Contoh di atas dengan `--import` adalah untuk VM yang disk-nya sudah terinstal. Untuk instalasi baru, gunakan:

```bash
virt-install \
  --name arch-vm \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10,format=qcow2 \
  --cdrom /var/lib/libvirt/images/archlinux-x86_64.iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio
```

Tanpa `--import`, `virt-install` akan boot dari CD-ROM dan membuka konsol serial untuk instalasi.

### 4.2. Opsi Tambahan yang Sering Digunakan

```bash
--extra-args "console=ttyS0,115200n8"
```
- `--extra-args`: argumen kernel tambahan. Untuk Arch ISO, ini memastikan output ke serial console. `console=ttyS0` adalah perangkat serial pertama. `115200n8` adalah baud rate 115200, no parity, 8 data bits.

```bash
--boot hd,cdrom
```
- `--boot`: urutan boot. `hd` lalu `cdrom`. Bisa juga `cdrom,hd`.

```bash
--noreboot
```
- Jangan reboot setelah instalasi selesai. Berguna untuk debugging.

```bash
--noautoconsole
```
- Jangan otomatis membuka konsol setelah VM dibuat. Berguna untuk skrip.

```bash
--wait -1
```
- `--wait -1`: tunggu tanpa batas hingga instalasi selesai. Jika tidak, `virt-install` akan keluar setelah VM dibuat.

```bash
--print-xml
```
- Cetak XML yang akan dihasilkan tanpa benar-benar membuat VM. Sangat berguna untuk belajar.

```bash
--dry-run
```
- Simulasi tanpa eksekusi.

```bash
--check all=off
```
- Nonaktifkan pengecekan prasyarat. Berguna jika Anda yakin.

### 4.3. Contoh dengan `--print-xml`

```bash
virt-install \
  --name test-vm \
  --memory 512 \
  --vcpus 1 \
  --disk size=5 \
  --cdrom /path/to/iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --print-xml
```

**Output:** XML lengkap yang akan digunakan libvirt. Ini adalah cara terbaik untuk memahami hubungan antara opsi `virt-install` dan XML.

### 4.4. Contoh dengan `--import` untuk Disk yang Sudah Ada

```bash
virt-install \
  --name existing-vm \
  --memory 2048 \
  --vcpus 2 \
  --disk /var/lib/libvirt/images/existing.qcow2,format=qcow2 \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --import
```

- `--disk /path/to/existing.qcow2,format=qcow2`: gunakan disk yang sudah ada. Tanpa `size=`.
- `--import`: langsung boot dari disk, bukan dari CD-ROM.

### 4.5. Menambahkan vTPM dan UEFI

```bash
virt-install \
  --name secure-vm \
  --memory 2048 \
  --vcpus 2 \
  --disk size=20,format=qcow2 \
  --cdrom /path/to/win11.iso \
  --os-variant win11 \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --boot uefi \
  --tpm backend=emulator,model=tpm-tis,version=2.0 \
  --features smm=on
```

- `--boot uefi`: gunakan UEFI (OVMF) sebagai firmware.
- `--tpm backend=emulator,model=tpm-tis,version=2.0`: tambahkan vTPM 2.0.
- `--features smm=on`: aktifkan System Management Mode, diperlukan untuk Secure Boot.

### 4.6. Menambahkan Virtio RNG dan Balloon

```bash
--rng /dev/urandom \
--memballoon model=virtio
```

- `--rng /dev/urandom`: sumber entropi dari host.
- `--memballoon model=virtio`: balloon device untuk manajemen memori.

### 4.7. Menambahkan Controller Virtio-SCSI

```bash
--controller type=scsi,model=virtio-scsi \
--disk size=10,format=qcow2,bus=scsi
```

- `--controller type=scsi,model=virtio-scsi`: tambahkan controller Virtio-SCSI.
- `--disk ...,bus=scsi`: hubungkan disk ke controller SCSI.

---

## 5. Diagram Alur `virt-install`

```
+-------------------+
|   Perintah        |
|   virt-install    |
+-------------------+
          |
          v
+-------------------+
|   Parsing opsi    |
|   (argparse)      |
+-------------------+
          |
          v
+-------------------+
|   Generate XML    |
|   domain          |
+-------------------+
          |
          v
+-------------------+
|   Validasi XML    |
|   (virt-xml-validate)
+-------------------+
          |
          v
+-------------------+
|   Panggil libvirt |
|   (virsh define)  |
+-------------------+
          |
          v
+-------------------+
|   Simpan XML ke   |
|   /etc/libvirt/qemu/
+-------------------+
          |
          v
+-------------------+
|   Start VM        |
|   (virsh start)   |
+-------------------+
          |
          v
+-------------------+
|   Buka konsol     |
|   (jika tidak     |
|    --noautoconsole)
+-------------------+
```

**Penjelasan:**
- `virt-install` mem-parsing opsi, menghasilkan XML, memvalidasi, mendefinisikan domain ke libvirt, menyimpan XML, dan menjalankan VM.
- Jika `--print-xml`, berhenti setelah generate XML.
- Jika `--dry-run`, berhenti setelah validasi.

---

## 6. Audit Kurikulum: Tambahan Opsi `virt-install`

Kurikulum asli hanya menyebut:
```bash
virt-install --name arch-vm --memory 1024 --vcpus 2 --disk size=10 --cdrom arch.iso --os-variant archlinux --graphics none --console pty,target_type=serial
```

Saya menambahkan opsi-opsi penting berikut yang belum disebut:

1. **`--print-xml`** — untuk belajar XML yang dihasilkan.
2. **`--dry-run`** — simulasi tanpa eksekusi.
3. **`--import`** — untuk disk yang sudah ada.
4. **`--boot uefi`** — untuk UEFI.
5. **`--tpm`** — untuk vTPM.
6. **`--features smm=on`** — untuk Secure Boot.
7. **`--rng`** — untuk entropi.
8. **`--memballoon`** — untuk balloon.
9. **`--controller`** — untuk Virtio-SCSI.
10. **`--extra-args`** — untuk argumen kernel.
11. **`--noreboot`** — untuk debugging.
12. **`--noautoconsole`** — untuk skrip.
13. **`--wait`** — untuk menunggu instalasi.
14. **`--check`** — untuk validasi.
15. **`--metadata`** — untuk metadata.
16. **`--qemu-commandline`** — untuk flag QEMU yang belum didukung.
17. **`--keymap`** — untuk layout keyboard.
18. **`--sound none`** — untuk headless.
19. **`--hostdev`** — pengantar Fase 8.
20. **`--filesystem`** — pengantar virtiofs.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.1, dengan lab tambahan untuk `--print-xml`, `--import`, UEFI, dan vTPM.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.2 (Anatomi Domain XML):** `virt-install` menghasilkan XML. Anda akan belajar membaca dan memodifikasinya.
- **Modul 3.3 (Lifecycle):** Setelah VM dibuat, Anda akan mengelola siklus hidupnya dengan `virsh`.
- **Modul 3.4 (Storage Pool):** `--disk size=10` menggunakan storage pool default. Anda akan belajar membuat pool kustom.
- **Modul 3.5 (Monitoring):** Setelah VM berjalan, Anda akan memantau dengan `virt-top` dan `domstats`.
- **Fase 4 (Storage & Backup):** `virt-install` adalah awal; clone, snapshot, dan backup akan melibatkan XML dan disk.
- **Fase 5 (Networking):** `--network network=default` adalah jaringan NAT sederhana. Fase 5 akan membahas bridge, macvtap, dan isolasi.
- **Fase 6 (Keamanan):** `--tpm`, `--boot uefi`, dan `--features smm=on` adalah fondasi Secure Boot dan vTPM.
- **Fase 7 (Otomasi):** `virt-install` dalam skrip Bash adalah awal otomasi. Fase 7 akan memperdalam dengan cloud-init dan hooks.

---

## 8. Referensi Lengkap

- **virt-install man page** — https://libvirt.org/manpages/virt-install.html
- **libvirt Documentation** — https://libvirt.org/docs.html
- **libvirt Domain XML Format** — https://libvirt.org/formatdomain.html
- **libvirt Storage Management** — https://libvirt.org/storage.html
- **libvirt Networking** — https://libvirt.org/formatnetwork.html
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt
- **Arch Wiki: QEMU** — https://wiki.archlinux.org/title/QEMU
- **virt-install examples** — https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/creating-virtual-machines-with-virt-install_configuring-and-managing-virtualization
- **libvirt XML Schema** — https://libvirt.org/schemas/domain/1.0/domain.rng
- **virt-xml-validate** — https://libvirt.org/manpages/virt-xml-validate.html

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan `--os-variant`.** libvirt akan mengoptimalkan perangkat dan driver.
2. **Gunakan `--graphics none` dan `--console pty,target_type=serial`** untuk headless.
3. **Tambahkan `--extra-args "console=ttyS0"`** untuk ISO yang tidak otomatis mengarahkan output ke serial.
4. **Gunakan `--print-xml`** untuk memahami XML yang dihasilkan sebelum benar-benar membuat VM.
5. **Gunakan `--dry-run`** untuk memvalidasi perintah tanpa eksekusi.
6. **Gunakan `--noautoconsole`** dalam skrip agar tidak membuka konsol.
7. **Gunakan `--wait -1`** jika Anda ingin menunggu instalasi selesai.
8. **Simpan perintah `virt-install` dalam skrip** untuk reproduksibilitas.
9. **Gunakan `--import`** untuk disk yang sudah ada.
10. **Untuk UEFI, gunakan `--boot uefi`** dan pastikan OVMF terinstal.
11. **Untuk vTPM, gunakan `--tpm backend=emulator,model=tpm-tis,version=2.0`**.
12. **Untuk Secure Boot, tambahkan `--features smm=on`**.
13. **Gunakan `--rng /dev/urandom`** untuk entropi.
14. **Gunakan `--memballoon model=virtio`** untuk manajemen memori dinamis.
15. **Gunakan `--controller type=scsi,model=virtio-scsi`** jika memerlukan banyak disk.
16. **Hindari `--sound`** di headless; gunakan `--sound none`.
17. **Gunakan `--keymap en-us`** jika keyboard tidak sesuai.
18. **Gunakan `--metadata`** untuk menambahkan informasi seperti judul, deskripsi, atau UUID kustom.
19. **Gunakan `--qemu-commandline`** hanya jika opsi belum didukung `virt-install`.
20. **Selalu validasi XML dengan `virt-xml-validate`** setelah mengedit manual.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `ERROR: Guest name is required` | `--name` tidak diberikan. | Tambahkan `--name`. |
| `ERROR: Memory is required` | `--memory` tidak diberikan. | Tambahkan `--memory`. |
| `ERROR: Disk is required` | `--disk` tidak diberikan. | Tambahkan `--disk`. |
| `ERROR: No install method specified` | Tidak ada `--cdrom`, `--location`, atau `--import`. | Tambahkan salah satu. |
| `ERROR: Unsupported os-variant` | `--os-variant` salah atau tidak dikenal. | Gunakan `--os-variant list` untuk melihat daftar. |
| `ERROR: Unable to open X display` | `--graphics none` tidak diberikan. | Tambahkan `--graphics none`. |
| `ERROR: Console not available` | `--console` tidak diberikan. | Tambahkan `--console pty,target_type=serial`. |
| `ERROR: Network not found` | `--network network=default` tetapi network default tidak aktif. | Jalankan `virsh net-start default` dan `virsh net-autostart default`. |
| `ERROR: Storage pool not found` | `--disk size=10` tetapi pool default tidak ada. | Buat pool default: `virsh pool-define-as default dir --target /var/lib/libvirt/images`. |
| `ERROR: Permission denied` | User tidak di grup `libvirt`. | `sudo usermod -aG libvirt $USER`, logout/login. |
| `ERROR: KVM not available` | `/dev/kvm` tidak ada atau tidak bisa diakses. | Cek Fase 1. Pastikan modul KVM dimuat. |
| `ERROR: Unable to connect to libvirt` | libvirt daemon tidak berjalan. | `sudo systemctl start virtqemud.socket`. |
| `ERROR: XML error` | XML yang dihasilkan tidak valid. | Gunakan `--print-xml` dan validasi dengan `virt-xml-validate`. |
| `ERROR: tpm-tis not supported` | QEMU atau libvirt terlalu tua. | Update QEMU dan libvirt. |
| `ERROR: UEFI not found` | OVMF tidak terinstal. | `sudo pacman -S edk2-ovmf`. |
| `ERROR: SMM not supported` | QEMU tidak mendukung SMM. | Update QEMU. |
| VM tidak mau boot dari CD | Boot order salah. | Tambahkan `--boot cdrom,hd`. |
| Konsol kosong | Guest tidak mengarahkan output ke serial. | Tambahkan `--extra-args "console=ttyS0"`. |
| Instalasi selesai tetapi tidak reboot | `--noreboot` digunakan. | Hapus `--noreboot` atau reboot manual. |
| `virt-install` hang | Menunggu konsol. | Gunakan `--noautoconsole` atau `--wait -1`. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virt-install` selesai tanpa error.
- `virsh list --all` menampilkan VM dengan status `running` atau `shut off`.
- `virsh dumpxml arch-vm` menampilkan XML yang sesuai.
- `virsh console arch-vm` berhasil terhubung ke serial console.
- Di guest, `ip a` menunjukkan interface `ens3` atau `enp0s3` dengan IP dari DHCP.
- `virsh domblklist arch-vm` menampilkan disk.
- `virsh domiflist arch-vm` menampilkan interface jaringan.
- `virsh dominfo arch-vm` menampilkan informasi CPU, memori, dan status.

**Troubleshooting:**
- Jika `virt-install` gagal, baca pesan error dengan cermat.
- Gunakan `--print-xml` untuk melihat XML yang dihasilkan.
- Gunakan `--dry-run` untuk simulasi.
- Cek log libvirt: `journalctl -u virtqemud -f`.
- Cek log QEMU: `/var/log/libvirt/qemu/arch-vm.log`.
- Jika konsol tidak muncul, cek `--console` dan `--extra-args`.
- Jika jaringan tidak berfungsi, cek `virsh net-list --all`.
- Jika storage pool tidak ada, buat dengan `virsh pool-define-as`.
- Jika permission ditolak, cek grup `libvirt` dan polkit.
- Jika KVM tidak tersedia, cek `/dev/kvm` dan modul kernel.
- Untuk debugging XML, gunakan `virt-xml-validate`.
- Untuk melihat XML yang sedang berjalan, `virsh dumpxml arch-vm`.
- Untuk mengedit XML, `virsh edit arch-vm`.

---

## 12. Latihan Mandiri

1. Jalankan `virt-install --print-xml` untuk VM dengan nama `test-vm`, memori 512 MiB, 1 vCPU, disk 5 GiB, CD-ROM ISO Arch, OS variant `archlinux`, graphics none, console serial, network default. Simpan XML-nya.
2. Validasi XML dengan `virt-xml-validate`.
3. Buat VM sebenarnya dengan perintah yang sama (tanpa `--print-xml`). Gunakan `--noautoconsole`.
4. Hubungkan ke konsol dengan `virsh console test-vm`. Instal Arch Linux minimal.
5. Setelah instalasi, reboot. Cek `virsh list --all`.
6. Gunakan `virsh domblklist`, `virsh domiflist`, `virsh dominfo` untuk memeriksa VM.
7. Edit XML dengan `virsh edit test-vm`. Tambahkan `--rng` dan `--memballoon` jika belum ada. Simpan.
8. Restart VM dengan `virsh destroy` lalu `virsh start`.
9. Buat VM baru dengan `--import` dari disk yang sudah ada.
10. Buat VM dengan UEFI dan vTPM: `--boot uefi --tpm backend=emulator,model=tpm-tis,version=2.0 --features smm=on`.
11. Buat VM dengan Virtio-SCSI: `--controller type=scsi,model=virtio-scsi --disk size=10,bus=scsi`.
12. Tulis ringkasan: apa perbedaan `--import` dan tanpa `--import`, kapan menggunakan `--print-xml`, dan bagaimana `virt-install` berhubungan dengan XML.

---

## Penutup Modul 3.1

Anda kini menguasai `virt-install`, pintu masuk ke libvirt. Anda telah belajar membuat VM headless dengan berbagai opsi, menghasilkan XML, dan memvalidasinya. Ini adalah fondasi untuk Modul 3.2, di mana Anda akan membedah XML secara manual dan memahami setiap elemennya.

---

## Motivasi Berenergi

Ingatlah: setiap baris XML yang Anda tulis adalah **kontrak** dengan hypervisor. Setiap opsi `virt-install` adalah **jembatan** antara niat Anda dan realitas virtual. Di Fase 3 ini, Anda bukan lagi sekadar pengguna; Anda adalah **pengendali**. Teruslah berevolusi, karena di balik setiap VM yang berjalan, ada seorang arsitek yang memahami lapisan demi lapisan. Selamat belajar, dan jangan berhenti di satu perintah!

---

## Mini-Daftar Isi Modul 3.2

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Arsitektur XML Domain & Pohon Elemen
6. Audit Kurikulum: Tambahan Namespace, Schema, virt-xml, Metadata, UUID
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Domain XML** adalah format konfigurasi deklaratif yang digunakan libvirt untuk mendefinisikan sebuah VM (disebut **domain** dalam terminologi libvirt). File XML ini disimpan di `/etc/libvirt/qemu/<nama>.xml` untuk domain system, atau `~/.config/libvirt/qemu/<nama>.xml` untuk domain session. Ia berisi **semua** yang dibutuhkan libvirt dan QEMU untuk menjalankan VM: CPU, memori, firmware, disk, jaringan, perangkat, grafik, keamanan, dan lainnya.

**Peran dalam kurikulum:** Modul ini adalah **inti** dari Fase 3. Semua modul setelahnya — lifecycle, storage, monitoring, networking, keamanan, otomasi — beroperasi pada XML ini. `virt-install` di Modul 3.1 hanya menghasilkan XML; setelah itu, XML menjadi **sumber kebenaran tunggal**. Menguasai XML berarti Anda bisa memodifikasi VM secara presisi tanpa bergantung pada alat pembungkus. Ini juga fondasi untuk memahami **domain XML** di Fase 6 (keamanan), **network XML** di Fase 5, dan **storage pool XML** di Fase 4.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. XML sebagai Kontrak Deklaratif

Berbeda dengan QEMU murni di mana Anda memberikan perintah imperatif (flag demi flag), XML adalah **deklarasi keadaan yang diinginkan**. Anda tidak mengatakan "buat disk virtio-blk dengan cache none", Anda mendeklarasikan:

```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2' cache='none'/>
  <source file='/var/lib/libvirt/images/disk.qcow2'/>
  <target dev='vda' bus='virtio'/>
</disk>
```

libvirt akan menerjemahkan deklarasi ini menjadi flag QEMU yang sesuai. Jika Anda mengubah XML, libvirt akan **mengubah konfigurasi VM** saat restart (atau saat runtime, untuk perubahan tertentu).

### 2.2. Sumber Kebenaran Tunggal (Single Source of Truth)

XML adalah **satu-satunya sumber kebenaran**. Apa yang ada di XML adalah apa yang dijalankan. `virsh dumpxml` membaca dari libvirt (bukan dari file), tetapi libvirt menyimpan XML yang sama. Ketika Anda `virsh edit`, Anda mengedit XML dan libvirt memvalidasi serta menerapkannya.

**Konsekuensi:** Jangan pernah mengedit file XML langsung dengan `vim` saat libvirt berjalan. Gunakan `virsh edit` yang memvalidasi XML. Untuk mengedit tanpa membuka editor, gunakan `virsh dumpxml > file.xml`, edit, lalu `virsh define file.xml`.

### 2.3. Namespace XML

XML domain libvirt menggunakan **namespace** untuk membedakan elemen libvirt standar dari elemen khusus QEMU:

```xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
```

- `xmlns:qemu`: namespace untuk elemen `<qemu:...>`. Ini adalah **escape hatch** untuk opsi QEMU yang belum didukung libvirt secara native.
- Contoh: `<qemu:commandline>` untuk menambahkan argumen QEMU kustom.

**Filosofi:** libvirt berusaha menjadi portabel, tetapi mengakui bahwa QEMU memiliki fitur unik. Namespace QEMU memungkinkan akses ke fitur tersebut tanpa merusak portabilitas.

### 2.4. Schema dan Validasi

XML domain divalidasi terhadap **RelaxNG schema** yang disediakan libvirt:

```
/usr/share/libvirt/schemas/domain.rng
```

Setiap versi libvirt memiliki schema sendiri. Validasi memastikan XML sesuai dengan apa yang libvirt harapkan. Alat validasi: `virt-xml-validate`.

### 2.5. UUID: Identitas Unik Domain

Setiap domain memiliki **UUID** (Universally Unique Identifier) yang unik. Ini adalah identitas permanen VM, berbeda dari nama yang bisa diubah. UUID digunakan untuk referensi internal, migrasi, dan manajemen.

Format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

Contoh: `f1e2d3c4-b5a6-9788-1234-567890abcdef`

Jika Anda tidak menentukan UUID, libvirt akan menghasilkan secara acak. Anda bisa menentukannya dengan `--uuid` di `virt-install` atau `<uuid>` di XML.

### 2.6. Metadata: Anotasi untuk Manusia

Sejak libvirt 1.1.1, XML mendukung **metadata** untuk menambahkan informasi kustom:

```xml
<metadata>
  <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
    <libosinfo:os id="http://archlinux.org/archlinux/rolling"/>
  </libosinfo:libosinfo>
  <myapp:custom xmlns:myapp="http://example.com/myapp">
    <myapp:owner>admin</myapp:owner>
  </myapp:custom>
</metadata>
```

Metadata tidak memengaruhi perilaku VM, tetapi berguna untuk otomasi, pelabelan, dan manajemen.

### 2.7. Filosofi

- **Deklaratif > imperatif.** XML mendeklarasikan keadaan, bukan langkah-langkah.
- **Validasi ketat.** XML harus valid terhadap schema. Tidak ada ruang untuk improvisasi.
- **Namespace untuk ekstensi.** QEMU namespace memungkinkan akses ke fitur unik tanpa merusak portabilitas.
- **Metadata untuk manusia.** XML adalah untuk mesin, tetapi metadata membantu manusia.
- **Sumber kebenaran tunggal.** XML adalah satu-satunya kebenaran. Jangan ada konfigurasi di luar XML.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **Domain** | Istilah libvirt untuk VM. | `<domain type='kvm'>`. |
| **XML** | eXtensible Markup Language. | Format deklaratif. |
| **Namespace** | Ruang nama XML untuk membedakan elemen. | `xmlns:qemu`. |
| **Schema** | Definisi struktur XML. | RelaxNG `.rng`. |
| **UUID** | Universally Unique Identifier. | `f1e2d3c4-...`. |
| **Metadata** | Informasi kustom non-fungsional. | `<metadata>`. |
| **`<domain>`** | Elemen root. | Atribut `type='kvm'`. |
| **`type`** | Hypervisor. | `kvm`, `qemu`, `xen`, `lxc`. |
| **`<name>`** | Nama domain. | `arch-vm`. |
| **`<uuid>`** | UUID domain. | `f1e2...`. |
| **`<title>`** | Judul deskriptif. | `Arch Linux Dev VM`. |
| **`<description>`** | Deskripsi panjang. | Bebas teks. |
| **`<memory>`** | Memori maksimum. | `unit='MiB'`. |
| **`<currentMemory>`** | Memori saat ini. | Untuk balloon. |
| **`<vcpu>`** | Jumlah vCPU. | `placement='static'`. |
| **`<cpu>`** | Model CPU. | `mode='host-passthrough'`. |
| **`<os>`** | Firmware dan boot. | `<type arch='x86_64'>hvm</type>`. |
| **`<features>`** | Fitur CPU. | `acpi`, `apic`, `smm`. |
| **`<clock>`** | Jam guest. | `offset='utc'`. |
| **`<on_poweroff>`** | Aksi saat poweroff. | `destroy`, `restart`, `preserve`. |
| **`<on_reboot>`** | Aksi saat reboot. | `restart`, `destroy`. |
| **`<on_crash>`** | Aksi saat crash. | `destroy`, `restart`, `preserve`, `coredump-destroy`. |
| **`<devices>`** | Wadah perangkat. | Disk, NIC, console, dll. |
| **`<disk>`** | Disk virtual. | `type='file'`, `device='disk'`. |
| **`<driver>`** | Driver disk. | `name='qemu'`, `type='qcow2'`. |
| **`<source>`** | Sumber disk. | `file='/path/to/disk.qcow2'`. |
| **`<target>`** | Target disk di guest. | `dev='vda'`, `bus='virtio'`. |
| **`<interface>`** | NIC. | `type='network'`. |
| **`<mac>`** | MAC address. | `address='52:54:00:...'`. |
| **`<model>`** | Model NIC. | `type='virtio'`. |
| **`<graphics>`** | Grafis. | `type='none'` untuk headless. |
| **`<console>`** | Konsol serial. | `type='pty'`. |
| **`<serial>`** | Port serial. | `type='pty'`. |
| **`<channel>`** | Kanal komunikasi. | QGA, spice. |
| **`<controller>`** | Controller. | `type='scsi'`, `model='virtio-scsi'`. |
| **`<rng>`** | Random number generator. | `model='virtio'`. |
| **`<memballoon>`** | Balloon device. | `model='virtio'`. |
| **`<tpm>`** | TPM virtual. | `model='tpm-tis'`. |
| **`<qemu:commandline>`** | Argumen QEMU kustom. | Namespace QEMU. |
| **`<seclabel>`** | Label keamanan. | AppArmor, SELinux. |
| **`<cputune>`** | CPU pinning. | `vcpupin`. |
| **`<numatune>`** | NUMA tuning. | `memory mode='strict'`. |
| **`<memtune>`** | Memori tuning. | `hard_limit`. |
| **`<blkiotune>`** | I/O tuning. | `weight`. |
| **`<sysinfo>`** | Info sistem. | SMBIOS. |
| **`<pm>`** | Power management. | Suspend. |
| **`<resource>`** | Resource partitioning. | `partition`. |
| **`<vcpu placement>`** | Penempatan vCPU. | `static`, `auto`. |
| **`<iothreads>`** | Thread I/O. | Untuk disk. |
| **`<iothreadids>`** | ID iothread. | Eksplisit. |
| **`<defaultiothread>`** | Default iothread. | Sejak libvirt 4.10. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. XML Domain Minimal

```xml
<domain type='kvm'>
  <name>minimal-vm</name>
  <memory unit='MiB'>512</memory>
  <vcpu>1</vcpu>
  <os>
    <type arch='x86_64'>hvm</type>
  </os>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/minimal.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <graphics type='none'/>
  </devices>
</domain>
```

**Penjelasan kata demi kata:**

- `<domain type='kvm'>`: elemen root. `type='kvm'` berarti menggunakan KVM (akselerasi hardware). Nilai lain: `qemu` (TCG, emulasi penuh), `xen`, `lxc`, `bhyve`.
- `<name>minimal-vm</name>`: nama domain. Harus unik. Tidak boleh mengandung karakter khusus seperti `/`.
- `<memory unit='MiB'>512</memory>`: memori maksimum. `unit` bisa `KiB`, `MiB`, `GiB`, `bytes`. Default `KiB` jika tidak dispesifikasikan (tetapi selalu eksplisit lebih baik).
- `<vcpu>1</vcpu>`: jumlah vCPU. Bisa juga `<vcpu placement='static'>2</vcpu>`.
- `<os>`: konfigurasi firmware dan boot.
  - `<type arch='x86_64'>hvm</type>`: `arch` adalah arsitektur guest. `hvm` berarti Hardware Virtual Machine (full virtualization). Alternatif: `xen` untuk paravirtualisasi.
- `<devices>`: wadah untuk semua perangkat virtual.
  - `<emulator>/usr/bin/qemu-system-x86_64</emulator>`: path ke binary QEMU. Biasanya libvirt mengisinya otomatis.
  - `<disk type='file' device='disk'>`: perangkat disk.
    - `type='file'`: sumber adalah file. Alternatif: `block` (device blok), `dir` (direktori), `network` (NBD, RBD, iSCSI).
    - `device='disk'`: perangkat disk. Alternatif: `cdrom`, `floppy`, `lun`.
    - `<driver name='qemu' type='qcow2'/>`: driver QEMU dengan format qcow2.
    - `<source file='...'/>`: path file disk.
    - `<target dev='vda' bus='virtio'/>`: `dev='vda'` adalah nama disk di guest. `bus='virtio'` berarti Virtio-blk.
  - `<interface type='network'>`: NIC.
    - `type='network'`: gunakan jaringan libvirt.
    - `<source network='default'/>`: jaringan bernama `default`.
    - `<model type='virtio'/>`: model NIC Virtio.
  - `<console type='pty'>`: konsol serial.
    - `type='pty'`: pseudo-terminal.
    - `<target type='serial' port='0'/>`: target port serial 0.
  - `<graphics type='none'/>`: tidak ada grafis. Alternatif: `vnc`, `spice`, `sdl`, `egl-headless`.

### 4.2. XML Lengkap dengan UEFI, vTPM, Secure Boot

```xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <name>secure-vm</name>
  <uuid>f1e2d3c4-b5a6-9788-1234-567890abcdef</uuid>
  <title>Arch Linux Secure VM</title>
  <description>VM dengan UEFI, vTPM, dan Secure Boot</description>
  <memory unit='GiB'>2</memory>
  <currentMemory unit='GiB'>2</currentMemory>
  <vcpu placement='static'>2</vcpu>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>/usr/share/edk2/x64/OVMF_CODE.secboot.fd</loader>
    <nvram template='/usr/share/edk2/x64/OVMF_VARS.secboot.fd'>/var/lib/libvirt/qemu/nvram/secure-vm_VARS.fd</nvram>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <smm state='on'/>
  </features>
  <cpu mode='host-passthrough' check='none'/>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='/var/lib/libvirt/images/secure.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <controller type='scsi' model='virtio-scsi'/>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <serial type='pty'>
      <target port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
    </channel>
    <tpm model='tpm-tis'>
      <backend type='emulator' version='2.0'/>
    </tpm>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
    <memballoon model='virtio'/>
    <graphics type='none'/>
  </devices>
  <qemu:commandline>
    <qemu:arg value='-global'/>
    <qemu:arg value='driver=cfi.pflash01,property=secure,value=on'/>
  </qemu:commandline>
</domain>
```

**Penjelasan kata demi kata:**

- `xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'`: namespace QEMU untuk elemen `<qemu:...>`.
- `<uuid>f1e2d3c4-b5a6-9788-1234-567890abcdef</uuid>`: UUID eksplisit. Jika tidak ada, libvirt generate.
- `<title>Arch Linux Secure VM</title>`: judul deskriptif.
- `<description>...</description>`: deskripsi panjang.
- `<memory unit='GiB'>2</memory>`: memori maksimum 2 GiB.
- `<currentMemory unit='GiB'>2</currentMemory>`: memori saat ini. Sama dengan maksimum jika tidak ada balloon.
- `<vcpu placement='static'>2</vcpu>`: 2 vCPU, penempatan static (tidak migrasi otomatis antar NUMA node).
- `<os firmware='efi'>`: gunakan UEFI.
  - `<type arch='x86_64' machine='q35'>hvm</type>`: arsitektur x86_64, chipset q35 (PCIe).
  - `<loader readonly='yes' type='pflash'>...</loader>`: loader firmware. `readonly='yes'` untuk CODE.
  - `<nvram template='...'>...</nvram>`: NVRAM (variabel UEFI). `template` adalah sumber; path adalah tujuan.
  - `<boot dev='hd'/>`: boot dari hard disk.
- `<features>`: fitur CPU.
  - `<acpi/>`: Advanced Configuration and Power Interface.
  - `<apic/>`: Advanced Programmable Interrupt Controller.
  - `<smm state='on'/>`: System Management Mode. Diperlukan untuk Secure Boot.
- `<cpu mode='host-passthrough' check='none'/>`: CPU model sama dengan host. `check='none'` berarti tidak ada validasi fitur.
- `<clock offset='utc'/>`: jam guest menggunakan UTC.
- `<on_poweroff>destroy</on_poweroff>`: saat poweroff, hancurkan VM.
- `<on_reboot>restart</on_reboot>`: saat reboot, restart.
- `<on_crash>destroy</on_crash>`: saat crash, hancurkan.
- `<devices>`:
  - `<emulator>/usr/bin/qemu-system-x86_64</emulator>`: path QEMU.
  - `<disk>`:
    - `<driver name='qemu' type='qcow2' cache='none' io='native'/>`: `cache='none'` berarti tidak ada cache host; `io='native'` berarti Linux AIO.
    - `<source file='...'/>`: file disk.
    - `<target dev='vda' bus='virtio'/>`: Virtio-blk.
  - `<controller type='scsi' model='virtio-scsi'/>`: controller Virtio-SCSI.
  - `<interface>`: NIC Virtio.
  - `<serial type='pty'>`: serial console.
  - `<console type='pty'>`: konsol.
  - `<channel type='unix'>`: kanal komunikasi untuk QGA.
    - `<target type='virtio' name='org.qemu.guest_agent.0'/>`: nama kanal QGA.
  - `<tpm model='tpm-tis'>`: TPM virtual dengan interface TIS.
    - `<backend type='emulator' version='2.0'/>`: backend emulator (swtpm), versi 2.0.
  - `<rng model='virtio'>`: Virtio RNG.
    - `<backend model='random'>/dev/urandom</backend>`: sumber entropi.
  - `<memballoon model='virtio'/>`: balloon device.
  - `<graphics type='none'/>`: tanpa grafis.
- `<qemu:commandline>`: argumen QEMU kustom.
  - `<qemu:arg value='-global'/>`: tambahkan `-global`.
  - `<qemu:arg value='driver=cfi.pflash01,property=secure,value=on'/>`: kunci pflash untuk Secure Boot.

### 4.3. Memvalidasi XML

```bash
virt-xml-validate /etc/libvirt/qemu/secure-vm.xml
```

**Penjelasan:**
- `virt-xml-validate`: alat validasi XML libvirt.
- Argumen: path ke file XML.

**Output jika valid:** `domain.xml validates`

**Output jika tidak valid:** pesan error dengan baris dan kolom.

### 4.4. Mengedit XML dengan `virsh edit`

```bash
virsh edit secure-vm
```

**Penjelasan:**
- `virsh edit`: buka editor default (`$EDITOR`) dengan XML domain.
- Setelah disimpan, libvirt memvalidasi dan menerapkan.
- Jika validasi gagal, libvirt menolak dan membuka kembali editor.

### 4.5. Mengedit XML dengan `virt-xml`

```bash
virt-xml secure-vm --edit --memory 4096
virt-xml secure-vm --edit --vcpus 4
virt-xml secure-vm --add-device --disk size=10,format=qcow2
virt-xml secure-vm --remove-device --disk target=vdb
```

**Penjelasan:**
- `virt-xml`: alat untuk mengedit XML secara terprogram.
- `--edit`: mode edit.
- `--memory 4096`: ubah memori menjadi 4096 MiB.
- `--vcpus 4`: ubah vCPU menjadi 4.
- `--add-device`: tambah perangkat.
- `--remove-device`: hapus perangkat.

**Kegunaan:** Otomasi. Tidak perlu membuka editor interaktif.

### 4.6. Dump XML

```bash
virsh dumpxml secure-vm > secure-vm-dump.xml
```

**Penjelasan:**
- `virsh dumpxml`: cetak XML domain yang sedang berjalan.
- Redirection `>`: simpan ke file.

**Kegunaan:** Backup XML, inspeksi, atau modifikasi offline.

### 4.7. Define XML

```bash
virsh define secure-vm-dump.xml
```

**Penjelasan:**
- `virsh define`: definisikan domain dari file XML.
- Jika domain sudah ada, XML akan di-update.
- Jika belum ada, domain baru dibuat.

**Kegunaan:** Restore dari backup XML, atau membuat VM dari XML yang sudah dimodifikasi.

### 4.8. Menghapus Domain

```bash
virsh undefine secure-vm
virsh undefine secure-vm --remove-all-storage
virsh undefine secure-vm --nvram
```

**Penjelasan:**
- `virsh undefine`: hapus definisi domain.
- `--remove-all-storage`: hapus juga semua volume storage yang terkait.
- `--nvram`: hapus juga NVRAM (variabel UEFI).

**Peringatan:** `--remove-all-storage` menghapus disk! Backup dulu.

### 4.9. Melihat XML Schema

```bash
ls /usr/share/libvirt/schemas/
```

**Output:**
```
domain.rng
domaincaps.rng
network.rng
nwfilter.rng
storagepool.rng
storagevol.rng
...
```

**Kegunaan:** Untuk memahami struktur XML yang valid.

### 4.10. Menggunakan `xmlstarlet` untuk Manipulasi XML

```bash
xmlstarlet sel -t -v "//domain/name" secure-vm.xml
xmlstarlet ed -u "//domain/memory" -v "4096" secure-vm.xml > new.xml
```

**Penjelasan:**
- `xmlstarlet`: alat XML generik.
- `sel -t -v "//domain/name"`: pilih nilai `name`.
- `ed -u "//domain/memory" -v "4096"`: update `memory` menjadi 4096.

**Kegunaan:** Manipulasi XML di luar libvirt.

---

## 5. Diagram Arsitektur XML Domain & Pohon Elemen

### 5.1. Pohon Elemen XML Domain

```
<domain>
 ├── <name>
 ├── <uuid>
 ├── <title>
 ├── <description>
 ├── <memory>
 ├── <currentMemory>
 ├── <vcpu>
 ├── <iothreads>
 ├── <iothreadids>
 ├── <defaultiothread>
 ├── <os>
 │    ├── <type>
 │    ├── <loader>
 │    ├── <nvram>
 │    ├── <boot>
 │    └── <bootmenu>
 ├── <features>
 │    ├── <acpi>
 │    ├── <apic>
 │    ├── <smm>
 │    ├── <hyperv>
 │    └── <kvm>
 ├── <cpu>
 │    ├── <model>
 │    ├── <feature>
 │    ├── <topology>
 │    └── <numa>
 ├── <clock>
 ├── <on_poweroff>
 ├── <on_reboot>
 ├── <on_crash>
 ├── <pm>
 ├── <devices>
 │    ├── <emulator>
 │    ├── <disk>
 │    │    ├── <driver>
 │    │    ├── <source>
 │    │    ├── <target>
 │    │    └── <readonly>
 │    ├── <controller>
 │    ├── <interface>
 │    │    ├── <source>
 │    │    ├── <mac>
 │    │    ├── <model>
 │    │    └── <driver>
 │    ├── <serial>
 │    ├── <console>
 │    ├── <channel>
 │    ├── <graphics>
 │    ├── <video>
 │    ├── <rng>
 │    ├── <memballoon>
 │    ├── <tpm>
 │    ├── <filesystem>
 │    ├── <hostdev>
 │    └── <redirdev>
 ├── <cputune>
 ├── <numatune>
 ├── <memtune>
 ├── <blkiotune>
 ├── <seclabel>
 ├── <metadata>
 └── <qemu:commandline>
```

### 5.2. Alur Validasi XML

```
+-------------------+
|   XML Domain      |
+-------------------+
          |
          v
+-------------------+
|   Parse XML       |
+-------------------+
          |
          v
+-------------------+
|   Validasi        |
|   terhadap        |
|   domain.rng      |
+-------------------+
          |
     +----+----+
     |         |
     v         v
  Valid     Tidak Valid
     |         |
     v         v
+---------+ +-------------+
| Terapkan| | Tolak,      |
| ke      | | tampilkan   |
| libvirt | | error       |
+---------+ +-------------+
```

### 5.3. Hubungan XML dengan QEMU

```
+-------------------+
|   Domain XML      |
|   (libvirt)       |
+-------------------+
          |
          v
+-------------------+
|   libvirt         |
|   menerjemahkan   |
|   ke flag QEMU    |
+-------------------+
          |
          v
+-------------------+
|   QEMU process    |
|   (userspace)     |
+-------------------+
          |
          v
+-------------------+
|   KVM             |
|   (/dev/kvm)      |
+-------------------+
          |
          v
+-------------------+
|   VM (guest)      |
+-------------------+
```

**Penjelasan:**
- XML adalah deklarasi tingkat tinggi.
- libvirt menerjemahkan XML menjadi flag QEMU.
- QEMU menjalankan VM dengan bantuan KVM.

---

## 6. Audit Kurikulum: Tambahan Namespace, Schema, virt-xml, Metadata, UUID

Kurikulum asli menyebut:
```bash
virsh dumpxml arch-vm > arch-vm.xml
virsh edit arch-vm
```

Saya menambahkan:

1. **Namespace XML** — `xmlns:qemu`, `xmlns:libosinfo`. Penting untuk akses fitur QEMU unik.
2. **Schema RelaxNG** — `domain.rng`. Untuk validasi dan pemahaman struktur.
3. **`virt-xml-validate`** — alat validasi.
4. **`virt-xml`** — alat edit terprogram.
5. **Metadata** — `<metadata>`, `<libosinfo:...>`, kustom.
6. **UUID** — identitas unik domain.
7. **Title dan Description** — anotasi manusia.
8. **`virsh define`** — restore dari XML.
9. **`virsh undefine`** — hapus domain, dengan opsi `--remove-all-storage` dan `--nvram`.
10. **`xmlstarlet`** — manipulasi XML generik.
11. **`<qemu:commandline>`** — escape hatch untuk opsi QEMU.
12. **`<qemu:override>`** — override properti perangkat.
13. **`<qemu:capabilities>`** — capability QEMU.
14. **`<qemu:deprecation>`** — deprecation warning.
15. **`<seclabel>`** — label keamanan (AppArmor, SELinux).
16. **`<sysinfo>`** — SMBIOS.
17. **`<pm>`** — power management.
18. **`<resource>`** — resource partitioning.
19. **`<iothreads>`** — thread I/O.
20. **`<defaultiothread>`** — default iothread.
21. **`<cputune>`** — CPU pinning.
22. **`<numatune>`** — NUMA tuning.
23. **`<memtune>`** — memori tuning.
24. **`<blkiotune>`** — I/O tuning.
25. **`<vcpu placement>`** — penempatan vCPU.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.2, dengan lab tambahan untuk validasi, `virt-xml`, dan metadata.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.1 (`virt-install`):** `virt-install` menghasilkan XML. Modul ini membedah XML tersebut.
- **Modul 3.3 (Lifecycle):** Setelah XML didefinisikan, lifecycle menggunakan `virsh start`, `virsh suspend`, dll.
- **Modul 3.4 (Storage Pool):** XML disk merujuk ke storage pool dan volume.
- **Modul 3.5 (Monitoring):** XML mendefinisikan perangkat yang akan dimonitor.
- **Modul 3.6 (Konsol):** XML mendefinisikan `<console>` dan `<serial>`.
- **Modul 3.7 (Backup XML):** XML adalah yang di-backup.
- **Fase 4 (Storage & Backup):** XML disk, driver, dan backing chain.
- **Fase 5 (Networking):** XML `<interface>` dan network XML.
- **Fase 6 (Keamanan):** XML `<seclabel>`, `<tpm>`, `<features smm>`, `<loader>`.
- **Fase 7 (Otomasi):** XML dihasilkan dan dimodifikasi oleh skrip.
- **Fase 8 (Expert):** XML `<hostdev>`, `<numatune>`, `<cputune>`, `<iothreads>`.

---

## 8. Referensi Lengkap

- **libvirt Domain XML Format** — https://libvirt.org/formatdomain.html
- **libvirt XML Schema** — https://libvirt.org/schemas/domain/1.0/domain.rng
- **libvirt XML Validation** — https://libvirt.org/manpages/virt-xml-validate.html
- **virt-xml man page** — https://libvirt.org/manpages/virt-xml.html
- **virsh man page** — https://libvirt.org/manpages/virsh.html
- **libvirt Metadata** — https://libvirt.org/formatdomain.html#metadata
- **libvirt QEMU Namespace** — https://libvirt.org/formatdomain.html#qemu-namespace
- **libvirt CPU Tuning** — https://libvirt.org/formatdomain.html#cpu-tuning
- **libvirt NUMA Tuning** — https://libvirt.org/formatdomain.html#numa-node-tuning
- **libvirt Memory Tuning** — https://libvirt.org/formatdomain.html#memory-tuning
- **libvirt Block I/O Tuning** — https://libvirt.org/formatdomain.html#block-i-o-tuning
- **libvirt Security Label** — https://libvirt.org/formatdomain.html#security-label
- **libvirt TPM** — https://libvirt.org/formatdomain.html#tpm-device
- **libvirt RNG** — https://libvirt.org/formatdomain.html#random-number-generator-device
- **libvirt Balloon** — https://libvirt.org/formatdomain.html#memory-balloon-device
- **libvirt Channel** — https://libvirt.org/formatdomain.html#channel
- **libvirt Console** — https://libvirt.org/formatdomain.html#console
- **libvirt Serial** — https://libvirt.org/formatdomain.html#serial-port
- **libvirt Graphics** — https://libvirt.org/formatdomain.html#graphical-framebuffers
- **libvirt Video** — https://libvirt.org/formatdomain.html#video-devices
- **libvirt Filesystem** — https://libvirt.org/formatdomain.html#filesystems
- **libvirt Hostdev** — https://libvirt.org/formatdomain.html#host-device-assignment
- **libvirt Redirdev** — https://libvirt.org/formatdomain.html#redirected-devices
- **libvirt Controller** — https://libvirt.org/formatdomain.html#controllers
- **libvirt Disk** — https://libvirt.org/formatdomain.html#hard-drives-floppy-disks-cdroms
- **libvirt Interface** — https://libvirt.org/formatdomain.html#network-interfaces
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt

---

## 9. Tips & Praktik Terbaik

1. **Selalu validasi XML** dengan `virt-xml-validate` sebelum `virsh define`.
2. **Gunakan `virsh edit`**, jangan edit file XML langsung.
3. **Backup XML** dengan `virsh dumpxml` sebelum mengedit.
4. **Gunakan `--print-xml`** di `virt-install` untuk belajar.
5. **Gunakan `virt-xml`** untuk edit terprogram.
6. **Eksplisitkan `unit`** di `<memory>`, `<currentMemory>`, dll.
7. **Gunakan `host-passthrough`** untuk CPU jika tidak perlu migrasi.
8. **Gunakan `host-model`** untuk CPU jika perlu migrasi.
9. **Gunakan `q35`** untuk chipset modern.
10. **Gunakan `virtio`** untuk disk dan jaringan.
11. **Gunakan `cache='none'` dan `io='native'`** untuk performa disk.
12. **Tambahkan `<rng>`** untuk entropi.
13. **Tambahkan `<memballoon>`** untuk manajemen memori.
14. **Tambahkan `<channel>` QGA** untuk komunikasi host-guest.
15. **Gunakan `<metadata>`** untuk anotasi.
16. **Gunakan UUID eksplisit** untuk identitas stabil.
17. **Gunakan `<title>` dan `<description>`** untuk dokumentasi.
18. **Gunakan `<seclabel>`** untuk keamanan.
19. **Hindari `<qemu:commandline>`** jika ada padanan native.
20. **Gunakan `<qemu:override>`** untuk override properti perangkat.
21. **Selalu reboot atau restart VM** setelah mengubah XML yang memerlukan restart.
22. **Perhatikan kompatibilitas** XML dengan versi libvirt.
23. **Gunakan `virsh dumpxml --inactive`** untuk melihat XML yang tersimpan.
24. **Gunakan `virsh dumpxml --security-info`** untuk melihat label keamanan.
25. **Gunakan `virsh dumpxml --update-cpu`** untuk melihat CPU yang di-update.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `XML error: unknown tag` | Elemen tidak dikenal. | Validasi dengan `virt-xml-validate`. |
| `XML error: missing required attribute` | Atribut wajib tidak ada. | Baca schema, tambahkan atribut. |
| `XML error: invalid value` | Nilai tidak valid. | Cek dokumentasi untuk nilai yang valid. |
| `XML error: duplicate name` | Nama domain sudah ada. | Gunakan nama lain atau `virsh undefine`. |
| `XML error: UUID conflict` | UUID sudah digunakan. | Hapus UUID atau gunakan UUID lain. |
| `virsh define` gagal | XML tidak valid. | Validasi dulu. |
| `virsh edit` gagal | XML tidak valid. | Perbaiki error, simpan lagi. |
| VM tidak mau start | XML valid tetapi ada masalah runtime. | Cek log QEMU: `/var/log/libvirt/qemu/<name>.log`. |
| Disk tidak ditemukan | Path di `<source file='...'/>` salah. | Cek path, pastikan file ada. |
| Network tidak ditemukan | Nama network di `<source network='...'/>` salah. | Cek `virsh net-list --all`. |
| UEFI tidak boot | `<loader>` atau `<nvram>` salah. | Cek path OVMF, pastikan `readonly='yes'`. |
| vTPM tidak terdeteksi | `<tpm>` salah atau swtpm tidak berjalan. | Cek `virsh dumpxml`, cek `ps aux | grep swtpm`. |
| Secure Boot tidak aktif | `<smm state='on'/>` tidak ada, atau kunci belum di-enroll. | Tambahkan `<smm>`, enroll kunci. |
| `<qemu:commandline>` diabaikan | Namespace QEMU tidak dideklarasikan. | Tambahkan `xmlns:qemu='...'` di `<domain>`. |
| `<qemu:commandline>` error | Argumen QEMU tidak valid. | Cek log QEMU. |
| Metadata tidak muncul | Metadata tidak didukung versi libvirt. | Update libvirt. |
| `virsh undefine` gagal | Domain masih berjalan. | `virsh destroy` dulu. |
| `virsh undefine --remove-all-storage` menghapus disk | Opsi terlalu agresif. | Backup dulu, atau hindari opsi ini. |
| `virsh undefine --nvram` tidak menghapus NVRAM | Path NVRAM salah. | Cek `<nvram>`. |
| XML terlalu besar | Banyak elemen. | Gunakan `virt-xml` untuk edit selektif. |
| Perubahan XML tidak diterapkan | VM masih berjalan dengan XML lama. | Restart VM atau gunakan `virsh update-device`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virt-xml-validate /etc/libvirt/qemu/secure-vm.xml` mengembalikan `domain.xml validates`.
- `virsh dumpxml secure-vm` menampilkan XML yang sesuai.
- `virsh edit secure-vm` berhasil membuka dan menyimpan.
- `virt-xml secure-vm --edit --memory 4096` berhasil.
- `virsh define secure-vm-dump.xml` berhasil.
- `virsh undefine secure-vm` berhasil.
- VM berjalan dengan konfigurasi yang sesuai.

**Troubleshooting:**
- Jika validasi gagal: baca pesan error, perbaiki baris yang disebutkan.
- Jika `virsh edit` gagal: cek `$EDITOR`, coba `EDITOR=vim virsh edit`.
- Jika `virsh define` gagal: validasi dulu, cek log libvirt.
- Jika VM tidak start: cek `journalctl -u virtqemud`, `/var/log/libvirt/qemu/<name>.log`.
- Jika XML tidak sesuai: gunakan `virsh dumpxml --inactive` untuk melihat XML tersimpan.
- Jika metadata hilang: cek versi libvirt, update jika perlu.
- Jika namespace QEMU error: cek `xmlns:qemu`, pastikan URL benar.
- Jika `virt-xml` gagal: cek versi, coba `virt-xml --help`.
- Jika XML terlalu kompleks: pecah menjadi bagian-bagian, validasi setiap bagian.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk melihat schema: `xmllint --relaxng /usr/share/libvirt/schemas/domain.rng file.xml`.
- Untuk memformat XML: `xmllint --format file.xml`.

---

## 12. Latihan Mandiri

1. Dump XML VM yang sudah ada: `virsh dumpxml arch-vm > arch-vm.xml`.
2. Buka XML dengan editor teks. Identifikasi setiap elemen.
3. Validasi dengan `virt-xml-validate arch-vm.xml`.
4. Ubah memori menjadi 4096 MiB dengan `virt-xml`. Define ulang.
5. Ubah vCPU menjadi 4 dengan `virt-xml`. Define ulang.
6. Tambahkan `<title>` dan `<description>` dengan `virsh edit`.
7. Tambahkan `<metadata>` kustom. Define ulang.
8. Tambahkan UUID eksplisit. Define ulang.
9. Tambahkan `<rng>` dan `<memballoon>` jika belum ada.
10. Tambahkan `<channel>` QGA.
11. Tambahkan `<tpm>` vTPM 2.0.
12. Ubah `<os firmware='efi'>` dan tambahkan `<loader>` dan `<nvram>`.
13. Tambahkan `<features><smm state='on'/></features>`.
14. Tambahkan `<qemu:commandline>` untuk `-global`.
15. Validasi XML setelah setiap perubahan.
16. Restart VM dan cek apakah perubahan diterapkan.
17. Backup XML dengan `virsh dumpxml`.
18. Hapus VM dengan `virsh undefine --nvram`.
19. Restore VM dari XML backup dengan `virsh define`.
20. Tulis ringkasan: apa perbedaan `virsh edit` dan `virt-xml`, kapan menggunakan masing-masing, dan bagaimana XML berhubungan dengan QEMU.

---

## 13. Penutup Modul 3.2

Anda kini menguasai **anatomi Domain XML** — jantung dari libvirt. Anda bisa membaca, menulis, memvalidasi, dan memodifikasi XML dengan percaya diri. Anda memahami namespace QEMU, metadata, UUID, dan bagaimana XML diterjemahkan menjadi flag QEMU. Ini adalah keterampilan yang akan Anda gunakan di setiap fase berikutnya.

---

## Motivasi Berenergi

XML bukan sekadar file konfigurasi; ia adalah **peta jalan** dari setiap VM yang Anda bangun. Setiap elemen adalah keputusan, setiap atribut adalah kontrol. Dengan menguasai XML, Anda tidak lagi bergantung pada alat; Anda **berbicara langsung dengan hypervisor**. Teruslah berevolusi, karena di balik setiap `<domain>` ada seorang arsitek yang memahami lapisan terdalam dari virtualisasi. Selamat belajar, dan jangan pernah berhenti membedah!

---

## Mini-Daftar Isi Modul 3.3

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Siklus Hidup VM & Arsitektur State Machine
6. Audit Kurikulum: Tambahan `domstate`, `domjobinfo`, `save/restore`, `managedsave`, Hooks
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Lifecycle** dalam libvirt adalah **siklus hidup domain**: dari saat didefinisikan (defined) hingga dihapus (undefined). Setiap VM melewati serangkaian **state** yang dikelola oleh libvirt: `shut off`, `running`, `paused`, `saved`, `crashed`, `pmsuspended`, dan lainnya. `virsh` menyediakan perintah untuk **transisi** antar state ini: `start`, `shutdown`, `destroy`, `suspend`, `resume`, `save`, `restore`, `managedsave`, `autostart`, dan lain-lain.

**Peran dalam kurikulum:** Modul ini adalah **inti operasional** Fase 3. Setelah Anda bisa membuat dan mendefinisikan VM (Modul 3.1 dan 3.2), Anda harus bisa **mengoperasikannya**. Lifecycle adalah fondasi untuk:
- **Modul 3.4 (Storage):** snapshot dan blockcommit memerlukan VM dalam state tertentu.
- **Modul 3.5 (Monitoring):** `domstats` hanya berfungsi saat VM running.
- **Fase 4 (Backup):** `save` dan `restore` adalah teknik backup dasar.
- **Fase 6 (Keamanan):** `destroy` vs `shutdown` memiliki implikasi keamanan.
- **Fase 7 (Otomasi):** skrip lifecycle untuk start/stop massal.
- **Fase 8 (Migrasi):** live migration memerlukan pemahaman state VM.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. State Machine VM

libvirt mendefinisikan **state machine** yang ketat untuk domain. State utama:

| State | Deskripsi | Transisi |
|---|---|---|
| **undefined** | Domain tidak terdefinisi. | `virsh define`. |
| **shut off** | Domain terdefinisi tetapi tidak berjalan. | `virsh start`. |
| **running** | Domain berjalan. | `virsh shutdown`, `destroy`, `suspend`, `save`. |
| **paused** | Domain dijeda (vCPU berhenti). | `virsh resume`. |
| **saved** | Domain disimpan ke disk. | `virsh restore`. |
| **crashed** | Domain crash. | `virsh destroy` atau `start`. |
| **pmsuspended** | Domain suspend via ACPI. | `virsh dompmwakeup`. |
| **shutting down** | Domain sedang shutdown. | Otomatis ke `shut off`. |
| **dying** | Domain sedang dihancurkan. | Otomatis ke `shut off`. |

**Filosofi:** State machine memastikan konsistensi. Anda tidak bisa `resume` VM yang `shut off`. Anda tidak bisa `save` VM yang `paused` tanpa resume dulu (kecuali dengan `--paused`).

### 2.2. Graceful vs Forceful

- **Graceful:** `virsh shutdown` mengirim sinyal ACPI ke guest. Guest bisa menolak atau memproses dengan tertib. Ini seperti menekan tombol power di PC.
- **Forceful:** `virsh destroy` mematikan VM secara paksa, seperti mencabut kabel listrik. Data bisa hilang, filesystem bisa korup.

**Filosofi:** Selalu utamakan graceful. Gunakan forceful hanya jika graceful gagal atau VM hang.

### 2.3. Save/Restore vs Suspend/Resume

- **Suspend/Resume:** VM dijeda di **memori**. vCPU berhenti, tetapi proses QEMU tetap berjalan. Memori tetap dialokasikan. Resume instan.
- **Save/Restore:** VM **disimpan ke disk**. Proses QEMU berhenti. Memori ditulis ke file. Restore memuat kembali dari file. Memori host dibebaskan.

**Filosofi:** Suspend untuk jeda singkat. Save untuk jeda panjang atau untuk membebaskan resource host.

### 2.4. Managedsave: Save Otomatis

`virsh managedsave` adalah save yang **dikelola libvirt**. Saat host shutdown, libvirt bisa otomatis menyimpan VM yang berjalan ke disk. Saat host boot, VM otomatis di-restore. Ini adalah fitur **persistence** untuk VM.

**Filosofi:** Managedsave memungkinkan VM "bertahan" melintasi reboot host. Berguna untuk workstation atau VM pengembangan.

### 2.5. Autostart: VM yang Selalu Hidup

`virsh autostart` menandai VM untuk **otomatis start** saat host boot. Ini adalah fitur **high availability** sederhana.

**Filosofi:** Autostart memastikan layanan VM selalu tersedia. Namun, tidak ada retry atau health check; untuk itu, gunakan systemd atau manajemen tingkat lanjut.

### 2.6. Lifecycle Hooks

libvirt menyediakan **hooks** yang dijalankan pada event lifecycle: `/etc/libvirt/hooks/qemu`. Hook bisa menjalankan skrip saat VM start, stop, migrate, dll.

**Filosofi:** Hooks memungkinkan integrasi dengan sistem lain: setup network, mount storage, notifikasi, audit, dll.

### 2.7. Filosofi Keseluruhan

- **State adalah kontrak.** Setiap state memiliki arti. Jangan paksa transisi yang tidak valid.
- **Graceful > forceful.** Selalu coba graceful dulu.
- **Persistence adalah kunci.** Managedsave dan autostart membuat VM "hidup" melintasi reboot host.
- **Hooks adalah ekstensi.** Gunakan untuk integrasi, bukan untuk logika inti.
- **Observability.** Gunakan `domstate`, `domjobinfo`, `domstats` untuk memantau.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **Domain** | VM dalam terminologi libvirt. | `virsh list --all`. |
| **State** | Kondisi domain. | `running`, `paused`, `shut off`. |
| **Lifecycle** | Siklus hidup domain. | Define → start → stop → undefine. |
| **`virsh start`** | Mulai domain. | Dari `shut off` ke `running`. |
| **`virsh shutdown`** | Shutdown graceful. | Kirim ACPI. |
| **`virsh destroy`** | Hentikan paksa. | Seperti cabut listrik. |
| **`virsh reboot`** | Reboot graceful. | Kirim ACPI reboot. |
| **`virsh reset`** | Reset paksa. | Seperti tombol reset. |
| **`virsh suspend`** | Jeda domain. | vCPU berhenti. |
| **`virsh resume`** | Lanjutkan domain. | Dari `paused` ke `running`. |
| **`virsh save`** | Simpan state ke file. | Memori + device state. |
| **`virsh restore`** | Muat state dari file. | Dari `saved` ke `running`. |
| **`virsh managedsave`** | Save yang dikelola libvirt. | Otomatis saat host shutdown. |
| **`virsh managedsave-remove`** | Hapus managedsave state. | Paksa boot baru. |
| **`virsh autostart`** | Tandai untuk autostart. | Saat host boot. |
| **`virsh autostart --disable`** | Nonaktifkan autostart. | |
| **`virsh domstate`** | Lihat state domain. | `running`, `paused`. |
| **`virsh domjobinfo`** | Info job yang berjalan. | Save, restore, migrate. |
| **`virsh domjobabort`** | Batalkan job. | |
| **`virsh domblklist`** | Daftar disk. | |
| **`virsh domiflist`** | Daftar interface. | |
| **`virsh dominfo`** | Info domain. | CPU, memori, state. |
| **`virsh domcontrol`** | Status kontrol domain. | `ok`, `error`. |
| **`virsh domstats`** | Statistik domain. | CPU, memori, I/O. |
| **`virsh list`** | Daftar domain. | `--all`, `--inactive`. |
| **`virsh list --all`** | Semua domain. | Termasuk yang shut off. |
| **`virsh list --inactive`** | Domain yang tidak aktif. | |
| **`virsh list --state-running`** | Domain yang running. | |
| **`virsh list --state-paused`** | Domain yang paused. | |
| **`virsh list --state-shutoff`** | Domain yang shut off. | |
| **`virsh list --state-crashed`** | Domain yang crashed. | |
| **`virsh list --state-pmsuspended`** | Domain yang pmsuspended. | |
| **`virsh list --autostart`** | Domain dengan autostart. | |
| **`virsh list --no-autostart`** | Domain tanpa autostart. | |
| **ACPI** | Advanced Configuration and Power Interface. | Untuk shutdown graceful. |
| **APIC** | Advanced Programmable Interrupt Controller. | |
| **Hook** | Skrip yang dijalankan pada event. | `/etc/libvirt/hooks/qemu`. |
| **Managedsave** | Save otomatis. | Untuk persistence. |
| **PMSUSPEND** | Suspend via ACPI. | `virsh dompmsuspend`. |
| **PMWAKEUP** | Bangunkan dari PMSUSPEND. | `virsh dompmwakeup`. |
| **Job** | Operasi asinkron. | Save, restore, migrate. |
| **`--paused`** | Mulai dalam keadaan paused. | Untuk debugging. |
| **`--force`** | Paksa operasi. | Untuk shutdown/destroy. |
| **`--bypass-cache`** | Lewati cache host. | Untuk save/restore. |
| **`--verbose`** | Output detail. | Untuk debugging. |
| **`--domain`** | Nama domain. | |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Melihat State Domain

```bash
virsh list --all
virsh list --all --table
virsh domstate arch-vm
virsh domstate arch-vm --reason
```

**Penjelasan kata demi kata:**
- `virsh list --all`: daftar semua domain, termasuk yang tidak aktif.
- `virsh list --all --table`: format tabel lebih rapi.
- `virsh domstate arch-vm`: lihat state domain `arch-vm`.
- `virsh domstate arch-vm --reason`: lihat state beserta alasannya (mis. `shutdown` karena `guest-shutdown`).

**Output `virsh list --all`:**
```
 Id   Name        State
--------------------------------
 1    arch-vm     running
 -    test-vm     shut off
```

**Output `virsh domstate arch-vm`:**
```
running
```

**Output `virsh domstate arch-vm --reason`:**
```
running (reason: unknown)
```

### 4.2. Memulai Domain

```bash
virsh start arch-vm
virsh start arch-vm --console
virsh start arch-vm --paused
virsh start arch-vm --autodestroy
```

**Penjelasan kata demi kata:**
- `virsh start`: perintah untuk memulai domain.
- `arch-vm`: nama domain.
- `--console`: buka konsol setelah start (interaktif).
- `--paused`: mulai dalam keadaan paused. Berguna untuk debugging atau untuk menyiapkan environment sebelum VM benar-benar berjalan.
- `--autodestroy`: hancurkan VM otomatis saat klien virsh keluar. Berguna untuk VM sementara.

**Output:**
```
Domain 'arch-vm' started
```

### 4.3. Shutdown Graceful

```bash
virsh shutdown arch-vm
virsh shutdown arch-vm --mode acpi
virsh shutdown arch-vm --mode agent
virsh shutdown arch-vm --mode initctl
virsh shutdown arch-vm --mode signal
virsh shutdown arch-vm --mode paravirt
```

**Penjelasan kata demi kata:**
- `virsh shutdown`: kirim sinyal shutdown ke guest.
- `--mode acpi`: gunakan ACPI (default). Guest harus mendukung ACPI.
- `--mode agent`: gunakan QEMU Guest Agent. Guest harus menjalankan `qemu-guest-agent`.
- `--mode initctl`: gunakan `initctl` via QGA.
- `--mode signal`: kirim sinyal ke init process.
- `--mode paravirt`: gunakan paravirtualisasi shutdown (untuk Xen).

**Output:**
```
Domain 'arch-vm' is being shutdown
```

**Catatan:** `shutdown` hanya **meminta** guest untuk shutdown. Guest bisa menolak atau lambat. Gunakan `--force` untuk memaksa setelah timeout.

### 4.4. Destroy (Forceful)

```bash
virsh destroy arch-vm
virsh destroy arch-vm --graceful
```

**Penjelasan kata demi kata:**
- `virsh destroy`: hentikan VM secara paksa.
- `--graceful`: coba graceful dulu, lalu paksa jika gagal.

**Output:**
```
Domain 'arch-vm' destroyed
```

**Peringatan:** `destroy` seperti mencabut listrik. Data bisa hilang. Gunakan hanya jika `shutdown` gagal.

### 4.5. Reboot dan Reset

```bash
virsh reboot arch-vm
virsh reboot arch-vm --mode acpi
virsh reset arch-vm
```

**Penjelasan kata demi kata:**
- `virsh reboot`: kirim sinyal reboot graceful.
- `--mode acpi`: gunakan ACPI.
- `virsh reset`: reset paksa, seperti tombol reset.

**Output:**
```
Domain 'arch-vm' is being rebooted
```

### 4.6. Suspend dan Resume

```bash
virsh suspend arch-vm
virsh resume arch-vm
```

**Penjelasan kata demi kata:**
- `virsh suspend`: jeda domain. vCPU berhenti, memori tetap dialokasikan.
- `virsh resume`: lanjutkan domain dari `paused`.

**Output:**
```
Domain 'arch-vm' suspended
Domain 'arch-vm' resumed
```

**Catatan:** Suspend bukan save. Proses QEMU tetap berjalan. Memori host tetap terpakai.

### 4.7. Save dan Restore

```bash
virsh save arch-vm /var/lib/libvirt/save/arch-vm.save
virsh save arch-vm /var/lib/libvirt/save/arch-vm.save --verbose
virsh save arch-vm /var/lib/libvirt/save/arch-vm.save --bypass-cache
virsh restore /var/lib/libvirt/save/arch-vm.save
virsh restore /var/lib/libvirt/save/arch-vm.save --running
virsh restore /var/lib/libvirt/save/arch-vm.save --paused
```

**Penjelasan kata demi kata:**
- `virsh save`: simpan state VM ke file. VM berhenti setelah save.
- `arch-vm`: nama domain.
- `/path/to/save`: path file save. Harus writable.
- `--verbose`: tampilkan progres.
- `--bypass-cache`: lewati cache host. Lebih lambat tetapi lebih aman untuk data besar.
- `virsh restore`: muat state VM dari file.
- `--running`: mulai dalam keadaan running (default).
- `--paused`: mulai dalam keadaan paused.

**Output:**
```
Domain 'arch-vm' saved
```

**Setelah save:**
```
 Id   Name        State
--------------------------------
 -    arch-vm     shut off
```

**Setelah restore:**
```
Domain restored from /var/lib/libvirt/save/arch-vm.save
```

**Kegunaan:**
- Save untuk memindahkan VM ke host lain (offline migration).
- Save untuk membebaskan memori host.
- Save untuk debugging.

### 4.8. Managedsave

```bash
virsh managedsave arch-vm
virsh managedsave arch-vm --verbose
virsh managedsave-remove arch-vm
```

**Penjelasan kata demi kata:**
- `virsh managedsave`: simpan state VM ke lokasi yang dikelola libvirt. VM berhenti.
- `--verbose`: tampilkan progres.
- `virsh managedsave-remove`: hapus state managedsave. VM akan boot baru saat start berikutnya.

**Output:**
```
Domain 'arch-vm' state saved by libvirt
```

**Kegunaan:**
- Saat host shutdown, libvirt bisa otomatis managedsave VM.
- Saat host boot, VM otomatis restore.
- Untuk mengaktifkan, gunakan hook atau konfigurasi libvirt.

**Catatan:** Managedsave disimpan di `/var/lib/libvirt/qemu/save/`.

### 4.9. Autostart

```bash
virsh autostart arch-vm
virsh autostart arch-vm --disable
virsh list --autostart
virsh list --no-autostart
```

**Penjelasan kata demi kata:**
- `virsh autostart`: tandai domain untuk autostart saat host boot.
- `--disable`: nonaktifkan autostart.
- `virsh list --autostart`: daftar domain dengan autostart.
- `virsh list --no-autostart`: daftar domain tanpa autostart.

**Output:**
```
Domain 'arch-vm' marked as autostarted
```

**Mekanisme:** libvirt membuat symlink di `/etc/libvirt/qemu/autostart/`.

### 4.10. Informasi Domain

```bash
virsh dominfo arch-vm
virsh domstate arch-vm
virsh domcontrol arch-vm
virsh domblklist arch-vm
virsh domiflist arch-vm
virsh domjobinfo arch-vm
```

**Penjelasan kata demi kata:**
- `virsh dominfo`: info domain: ID, nama, UUID, OS, state, CPU, memori.
- `virsh domstate`: state domain.
- `virsh domcontrol`: status kontrol domain: `ok`, `error`, `initializing`.
- `virsh domblklist`: daftar disk.
- `virsh domiflist`: daftar interface jaringan.
- `virsh domjobinfo`: info job yang sedang berjalan (save, restore, migrate).

**Output `virsh dominfo arch-vm`:**
```
Id:             1
Name:           arch-vm
UUID:           f1e2d3c4-b5a6-9788-1234-567890abcdef
OS Type:        hvm
State:          running
CPU(s):         2
CPU time:       123.4s
Max memory:     2097152 KiB
Used memory:    2097152 KiB
Persistent:     yes
Autostart:      disable
Managed save:   no
Security model: apparmor
Security DOI:   0
```

### 4.11. Job: Operasi Asinkron

```bash
virsh domjobinfo arch-vm
virsh domjobabort arch-vm
```

**Penjelasan kata demi kata:**
- `virsh domjobinfo`: lihat job yang berjalan. Berguna saat save/restore/migrate.
- `virsh domjobabort`: batalkan job.

**Output `virsh domjobinfo arch-vm`:**
```
Job type:         Unbounded
Time elapsed:     1234 ms
Data processed:   123.4 MiB
Data remaining:   0 B
Data total:       123.4 MiB
Memory processed: 123.4 MiB
Memory remaining: 0 B
Memory total:     123.4 MiB
```

### 4.12. PM Suspend/Wakeup

```bash
virsh dompmsuspend arch-vm --target mem
virsh dompmsuspend arch-vm --target disk
virsh dompmwakeup arch-vm
```

**Penjelasan kata demi kata:**
- `virsh dompmsuspend`: suspend via ACPI.
- `--target mem`: suspend ke RAM (S3).
- `--target disk`: suspend ke disk (S4, hibernasi).
- `virsh dompmwakeup`: bangunkan dari PM suspend.

**Catatan:** Guest harus mendukung ACPI suspend.

### 4.13. Contoh Skrip Lifecycle

```bash
#!/bin/bash
VM="arch-vm"
SAVE_DIR="/var/lib/libvirt/save"

case "$1" in
  start)
    virsh start "$VM"
    ;;
  stop)
    virsh shutdown "$VM"
    # tunggu maksimal 60 detik
    for i in {1..60}; do
      state=$(virsh domstate "$VM")
      [ "$state" = "shut off" ] && break
      sleep 1
    done
    # jika masih running, destroy
    if [ "$(virsh domstate "$VM")" != "shut off" ]; then
      virsh destroy "$VM"
    fi
    ;;
  save)
    virsh save "$VM" "$SAVE_DIR/$VM.save"
    ;;
  restore)
    virsh restore "$SAVE_DIR/$VM.save"
    ;;
  status)
    virsh domstate "$VM"
    ;;
  *)
    echo "Usage: $0 {start|stop|save|restore|status}"
    exit 1
    ;;
esac
```

**Penjelasan:**
- `case "$1"`: switch berdasarkan argumen pertama.
- `start`: mulai VM.
- `stop`: shutdown graceful, tunggu 60 detik, jika belum mati, destroy.
- `save`: simpan state.
- `restore`: muat state.
- `status`: lihat state.

### 4.14. Hooks Lifecycle

```bash
sudo mkdir -p /etc/libvirt/hooks
sudo tee /etc/libvirt/hooks/qemu <<'EOF'
#!/bin/bash
VM_NAME="$1"
VM_OP="$2"
VM_SUB_OP="$3"

case "$VM_OP" in
  start)
    logger -t libvirt-hook "VM $VM_NAME starting"
    ;;
  started)
    logger -t libvirt-hook "VM $VM_NAME started"
    ;;
  stopped)
    logger -t libvirt-hook "VM $VM_NAME stopped"
    ;;
  release)
    logger -t libvirt-hook "VM $VM_NAME releasing resources"
    ;;
esac
EOF
sudo chmod +x /etc/libvirt/hooks/qemu
```

**Penjelasan kata demi kata:**
- `/etc/libvirt/hooks/qemu`: lokasi hook untuk QEMU.
- `$1`: nama VM.
- `$2`: operasi (`start`, `started`, `stopped`, `release`, `migrate`, dll).
- `$3`: sub-operasi (opsional).
- `logger`: tulis ke syslog.
- `chmod +x`: buat executable.

**Kegunaan:** Integrasi dengan sistem lain: setup network, mount storage, notifikasi.

---

## 5. Diagram Siklus Hidup VM & Arsitektur State Machine

### 5.1. State Machine Domain

```
                    +-------------+
                    |  undefined  |
                    +-------------+
                          |
                          | virsh define
                          v
                    +-------------+
         +--------->|  shut off   |<---------+
         |          +-------------+          |
         |                |                  |
         | virsh start    | virsh start      | virsh destroy
         |                v                  |
         |          +-------------+          |
         |          |   running   |----------+
         |          +-------------+          |
         |           |    |    |              |
         |  suspend  |    |    | save         |
         |           v    |    v              |
         |    +---------+ | +---------+       |
         |    | paused  | | | saved   |       |
         |    +---------+ | +---------+       |
         |         |      |      |            |
         |  resume |      |      | restore    |
         |         v      |      v            |
         |    +---------+ | +---------+       |
         +----| running |<+ | running |       |
              +---------+   +---------+       |
                                               |
              +-------------+                  |
              |  crashed    |------------------+
              +-------------+
                    ^
                    | crash
                    |
              +-------------+
              |   running   |
              +-------------+
```

### 5.2. Alur Shutdown Graceful

```
+-------------------+
|  virsh shutdown   |
+-------------------+
          |
          v
+-------------------+
|  libvirt kirim    |
|  ACPI signal ke   |
|  guest            |
+-------------------+
          |
          v
+-------------------+
|  Guest menerima   |
|  ACPI event       |
+-------------------+
          |
          v
+-------------------+
|  Guest shutdown   |
|  OS (systemd)     |
+-------------------+
          |
          v
+-------------------+
|  QEMU keluar      |
+-------------------+
          |
          v
+-------------------+
|  Domain state:    |
|  shut off         |
+-------------------+
```

### 5.3. Alur Save/Restore

```
+-------------------+
|  virsh save       |
+-------------------+
          |
          v
+-------------------+
|  QEMU hentikan    |
|  vCPU             |
+-------------------+
          |
          v
+-------------------+
|  Tulis memori     |
|  + device state   |
|  ke file          |
+-------------------+
          |
          v
+-------------------+
|  QEMU keluar      |
+-------------------+
          |
          v
+-------------------+
|  Domain state:    |
|  shut off         |
+-------------------+
          |
          | virsh restore
          v
+-------------------+
|  QEMU start       |
+-------------------+
          |
          v
+-------------------+
|  Baca memori      |
|  + device state   |
|  dari file        |
+-------------------+
          |
          v
+-------------------+
|  vCPU lanjut      |
|  dari titik save  |
+-------------------+
          |
          v
+-------------------+
|  Domain state:    |
|  running          |
+-------------------+
```

### 5.4. Alur Managedsave

```
+-------------------+
|  Host shutdown    |
+-------------------+
          |
          v
+-------------------+
|  libvirt hook     |
|  atau konfigurasi |
+-------------------+
          |
          v
+-------------------+
|  managedsave      |
|  otomatis         |
+-------------------+
          |
          v
+-------------------+
|  State disimpan   |
|  di              |
|  /var/lib/libvirt |
|  /qemu/save/      |
+-------------------+
          |
          v
+-------------------+
|  Host boot        |
+-------------------+
          |
          v
+-------------------+
|  libvirt restore  |
|  otomatis         |
+-------------------+
          |
          v
+-------------------+
|  VM running       |
|  dari state       |
|  terakhir         |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan `domstate`, `domjobinfo`, `save/restore`, `managedsave`, Hooks

Kurikulum asli menyebut:
```bash
virsh start arch-vm
virsh suspend arch-vm
virsh resume arch-vm
virsh save arch-vm state.save
virsh restore state.save
virsh autostart arch-vm
```

Saya menambahkan:

1. **`virsh domstate --reason`** — lihat alasan state.
2. **`virsh domcontrol`** — status kontrol domain.
3. **`virsh domjobinfo`** — info job asinkron.
4. **`virsh domjobabort`** — batalkan job.
5. **`virsh shutdown --mode`** — berbagai mode shutdown (acpi, agent, initctl, signal, paravirt).
6. **`virsh destroy --graceful`** — graceful destroy.
7. **`virsh reboot --mode`** — mode reboot.
8. **`virsh reset`** — reset paksa.
9. **`virsh save --verbose`** — progres save.
10. **`virsh save --bypass-cache`** — lewati cache.
11. **`virsh restore --running`** — restore ke running.
12. **`virsh restore --paused`** — restore ke paused.
13. **`virsh managedsave`** — save otomatis.
14. **`virsh managedsave-remove`** — hapus managedsave.
15. **`virsh dompmsuspend`** — PM suspend.
16. **`virsh dompmwakeup`** — PM wakeup.
17. **`virsh list --state-*`** — filter berdasarkan state.
18. **`virsh list --autostart`** — filter autostart.
19. **`virsh list --no-autostart`** — filter tanpa autostart.
20. **Hooks lifecycle** — `/etc/libvirt/hooks/qemu`.
21. **Skrip lifecycle** — contoh Bash untuk start/stop/save/restore.
22. **`virsh start --paused`** — mulai dalam paused.
23. **`virsh start --autodestroy`** — hancurkan saat klien keluar.
24. **`virsh start --console`** — buka konsol.
25. **`virsh dominfo`** — info lengkap.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.3, dengan lab tambahan untuk save/restore, managedsave, dan hooks.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.1 (`virt-install`):** `virt-install` membuat VM dan menjalankannya. Modul ini mengelola lifecycle setelahnya.
- **Modul 3.2 (XML):** XML mendefinisikan VM. Lifecycle mengubah state VM.
- **Modul 3.4 (Storage):** Snapshot dan blockcommit memerlukan VM dalam state tertentu.
- **Modul 3.5 (Monitoring):** `domstats` hanya berfungsi saat VM running.
- **Modul 3.6 (Konsol):** Konsol tersedia saat VM running.
- **Modul 3.7 (Backup XML):** XML adalah yang di-backup. Lifecycle memengaruhi kapan backup bisa dilakukan.
- **Fase 4 (Storage & Backup):** `save`/`restore` adalah teknik backup dasar. Snapshot memerlukan lifecycle.
- **Fase 5 (Networking):** Network berubah saat VM start/stop.
- **Fase 6 (Keamanan):** `destroy` vs `shutdown` memiliki implikasi keamanan. Hooks untuk audit.
- **Fase 7 (Otomasi):** Skrip lifecycle untuk start/stop massal.
- **Fase 8 (Migrasi):** Live migration memerlukan pemahaman state VM.

---

## 8. Referensi Lengkap

- **virsh man page** — https://libvirt.org/manpages/virsh.html
- **libvirt Domain Lifecycle** — https://libvirt.org/formatdomain.html#element-lifecycle
- **libvirt Hooks** — https://libvirt.org/hooks.html
- **libvirt managedsave** — https://libvirt.org/manpages/virsh.html#managedsave
- **libvirt domstate** — https://libvirt.org/manpages/virsh.html#domstate
- **libvirt domjobinfo** — https://libvirt.org/manpages/virsh.html#domjobinfo
- **libvirt domcontrol** — https://libvirt.org/manpages/virsh.html#domcontrol
- **libvirt dompmsuspend** — https://libvirt.org/manpages/virsh.html#dompmsuspend
- **libvirt dompmwakeup** — https://libvirt.org/manpages/virsh.html#dompmwakeup
- **libvirt autostart** — https://libvirt.org/manpages/virsh.html#autostart
- **libvirt save** — https://libvirt.org/manpages/virsh.html#save
- **libvirt restore** — https://libvirt.org/manpages/virsh.html#restore
- **libvirt shutdown** — https://libvirt.org/manpages/virsh.html#shutdown
- **libvirt destroy** — https://libvirt.org/manpages/virsh.html#destroy
- **libvirt reboot** — https://libvirt.org/manpages/virsh.html#reboot
- **libvirt reset** — https://libvirt.org/manpages/virsh.html#reset
- **libvirt suspend** — https://libvirt.org/manpages/virsh.html#suspend
- **libvirt resume** — https://libvirt.org/manpages/virsh.html#resume
- **libvirt dominfo** — https://libvirt.org/manpages/virsh.html#dominfo
- **libvirt domblklist** — https://libvirt.org/manpages/virsh.html#domblklist
- **libvirt domiflist** — https://libvirt.org/manpages/virsh.html#domiflist
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt
- **QEMU Guest Agent** — https://wiki.qemu.org/Features/QAPI/GuestAgent

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan `shutdown` graceful.** Gunakan `destroy` hanya jika terpaksa.
2. **Gunakan `--mode agent`** jika QGA berjalan di guest. Lebih andal.
3. **Gunakan `--mode acpi`** sebagai fallback.
4. **Tunggu shutdown selesai** dengan loop `domstate`.
5. **Gunakan `save` untuk memindahkan VM** ke host lain (offline).
6. **Gunakan `managedsave` untuk persistence** melintasi reboot host.
7. **Gunakan `autostart` untuk VM yang harus selalu hidup.**
8. **Gunakan `domstate --reason` untuk debugging.**
9. **Gunakan `domjobinfo` untuk memantau save/restore/migrate.**
10. **Gunakan `domjobabort` untuk membatalkan job yang hang.**
11. **Gunakan `--verbose` untuk melihat progres save/restore.**
12. **Gunakan `--bypass-cache` untuk data besar.**
13. **Gunakan `restore --paused` untuk debugging.**
14. **Gunakan `start --paused` untuk debugging.**
15. **Gunakan hooks untuk integrasi** dengan sistem lain.
16. **Log hooks ke syslog** untuk audit.
17. **Jangan gunakan `destroy` saat disk sedang ditulis.** Risiko korupsi.
18. **Backup XML sebelum mengubah lifecycle.**
19. **Gunakan `virsh list --all` untuk melihat semua VM.**
20. **Gunakan `virsh list --state-running` untuk filter.**
21. **Gunakan `virsh list --autostart` untuk melihat VM autostart.**
22. **Gunakan `virsh dominfo` untuk info lengkap.**
23. **Gunakan `virsh domblklist` dan `domiflist` untuk inspeksi.**
24. **Gunakan `virsh domstats` untuk statistik.**
25. **Gunakan `virsh domcontrol` untuk status kontrol.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `error: Failed to start domain` | XML tidak valid atau resource tidak cukup. | Validasi XML, cek resource host. |
| `error: Domain is already active` | VM sudah running. | `virsh list` untuk cek. |
| `error: Domain is not running` | VM belum start. | `virsh start`. |
| `shutdown` tidak berhasil | Guest tidak mendukung ACPI atau hang. | Gunakan `--mode agent` atau `destroy`. |
| `destroy` tidak berhasil | QEMU hang. | `kill -9` PID QEMU, atau `virsh destroy --graceful`. |
| `save` gagal | Disk penuh atau permission. | Cek space, cek permission. |
| `restore` gagal | File save korup atau tidak kompatibel. | Cek file, cek versi QEMU. |
| `managedsave` gagal | State sudah ada atau permission. | `managedsave-remove` dulu. |
| `autostart` gagal | Permission atau domain tidak persistent. | Cek permission `/etc/libvirt/qemu/autostart/`. |
| `dompmsuspend` gagal | Guest tidak mendukung ACPI suspend. | Cek `dmesg` di guest. |
| `dompmwakeup` gagal | Guest tidak dalam PM suspend. | Cek `domstate`. |
| Hook tidak berjalan | Hook tidak executable atau path salah. | `chmod +x`, cek path. |
| Hook error | Skrip hook error. | Cek `journalctl`, log syslog. |
| `domjobinfo` kosong | Tidak ada job. | Normal jika tidak ada save/restore/migrate. |
| `domjobabort` gagal | Tidak ada job. | Cek `domjobinfo`. |
| VM tidak autostart | Autostart tidak diaktifkan. | `virsh autostart`. |
| VM autostart tetapi gagal | XML tidak valid atau resource tidak cukup. | Cek log. |
| `virsh start` hang | Menunggu resource. | Cek `domstate`, cek log. |
| `virsh shutdown` hang | Guest tidak merespons. | Tunggu timeout, atau `destroy`. |
| `restore` mengubah state | VM berjalan dari state terakhir. | Gunakan `--paused` untuk debugging. |
| `save` lambat | Memori besar. | Gunakan `--bypass-cache`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh list --all` menampilkan VM dengan state yang benar.
- `virsh start arch-vm` berhasil.
- `virsh domstate arch-vm` menampilkan `running`.
- `virsh shutdown arch-vm` berhasil, VM shutdown graceful.
- `virsh destroy arch-vm` berhasil, VM mati paksa.
- `virsh suspend arch-vm` berhasil, VM paused.
- `virsh resume arch-vm` berhasil, VM running.
- `virsh save arch-vm /tmp/arch.save` berhasil.
- `virsh restore /tmp/arch.save` berhasil.
- `virsh managedsave arch-vm` berhasil.
- `virsh managedsave-remove arch-vm` berhasil.
- `virsh autostart arch-vm` berhasil.
- `virsh autostart arch-vm --disable` berhasil.
- `virsh domjobinfo arch-vm` menampilkan info job.
- `virsh dompmsuspend arch-vm --target mem` berhasil.
- `virsh dompmwakeup arch-vm` berhasil.
- Hook berjalan dan log tercatat.

**Troubleshooting:**
- Jika `start` gagal: cek `journalctl -u virtqemud`, `/var/log/libvirt/qemu/<name>.log`.
- Jika `shutdown` gagal: cek QGA, cek ACPI di guest.
- Jika `save` gagal: cek space, cek permission.
- Jika `restore` gagal: cek file save, cek versi QEMU.
- Jika `managedsave` gagal: cek state, `managedsave-remove`.
- Jika `autostart` gagal: cek permission, cek XML.
- Jika hook gagal: cek `journalctl`, cek executable.
- Jika `domjobinfo` kosong: normal jika tidak ada job.
- Jika VM hang: `virsh destroy`, atau `kill -9`.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk melihat log QEMU: `/var/log/libvirt/qemu/<name>.log`.
- Untuk melihat log libvirt: `journalctl -u virtqemud`.
- Untuk melihat state: `virsh domstate --reason`.
- Untuk melihat kontrol: `virsh domcontrol`.
- Untuk melihat statistik: `virsh domstats`.

---

## 12. Latihan Mandiri

1. Lihat semua VM: `virsh list --all`.
2. Lihat state VM: `virsh domstate arch-vm`.
3. Lihat state dengan alasan: `virsh domstate arch-vm --reason`.
4. Start VM: `virsh start arch-vm`.
5. Lihat state: `virsh domstate arch-vm`.
6. Shutdown graceful: `virsh shutdown arch-vm`.
7. Tunggu hingga shut off, cek state.
8. Start lagi, lalu suspend: `virsh suspend arch-vm`.
9. Resume: `virsh resume arch-vm`.
10. Save: `virsh save arch-vm /tmp/arch.save --verbose`.
11. Restore: `virsh restore /tmp/arch.save`.
12. Managedsave: `virsh managedsave arch-vm`.
13. Start lagi, cek apakah restore dari managedsave.
14. Managedsave-remove: `virsh managedsave-remove arch-vm`.
15. Start lagi, cek apakah boot baru.
16. Autostart: `virsh autostart arch-vm`.
17. Cek: `virsh list --autostart`.
18. Disable autostart: `virsh autostart arch-vm --disable`.
19. Buat hook `/etc/libvirt/hooks/qemu` yang log start/stop.
20. Start dan stop VM, cek log hook di `journalctl`.
21. Buat skrip lifecycle Bash untuk start/stop/save/restore.
22. Uji skrip dengan VM.
23. Tulis ringkasan: kapan menggunakan `shutdown` vs `destroy`, kapan `save` vs `suspend`, dan bagaimana `managedsave` bekerja.

---

## 13. Penutup Modul 3.3

Anda kini menguasai **lifecycle VM** — dari start, shutdown, suspend, save, restore, hingga autostart dan hooks. Anda bisa mengendalikan VM dengan presisi, memilih antara graceful dan forceful, serta mengintegrasikan lifecycle dengan sistem lain melalui hooks. Ini adalah fondasi untuk modul berikutnya: **Storage Pool & Volume**, di mana Anda akan mengelola disk yang menjadi "bahan bakar" VM.

---

## Motivasi Berenergi

Setiap VM adalah **entitas hidup** yang melewati siklus: lahir, berjalan, beristirahat, dan mati. Dengan menguasai lifecycle, Anda bukan lagi sekadar pengguna; Anda adalah **penjaga siklus hidup**. Anda tahu kapan harus graceful, kapan harus tegas, dan kapan harus menyimpan keadaan. Teruslah berevolusi, karena di balik setiap `virsh start` ada seorang operator yang memahami ritme virtualisasi. Selamat belajar, dan jangan pernah berhenti mengendalikan!

---

## Motivasi Awal

Selamat! Anda kini menguasai **lifecycle VM** — Anda bisa menghidupkan, menjeda, menyimpan, dan memulihkan VM dengan presisi seorang operator berpengalaman. Namun, setiap VM membutuhkan **bahan bakar**: disk. Di Modul 3.4 ini, Anda akan mempelajari **Storage Pool & Volume** — abstraksi libvirt untuk mengelola penyimpanan. Inilah saatnya Anda berhenti membuat `qcow2` secara manual dengan `qemu-img` dan mulai mengelolanya melalui **API terpadu** yang bisa diotomasi, diaudit, dan diskalakan. Anda akan belajar bahwa storage bukan sekadar file, melainkan **lapisan abstraksi** yang memisahkan "apa yang diinginkan VM" dari "bagaimana host menyimpannya". Tetap fokus, karena di sinilah fondasi Fase 4 (Backup Engineering) dimulai.

---

## Mini-Daftar Isi Modul 3.4

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Arsitektur Storage Pool & Volume
6. Audit Kurikulum: Tambahan ZFS, LVM, iSCSI, RBD, NFS, Gluster, dan Volume XML
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Storage Pool** dalam libvirt adalah **abstraksi penyimpanan** — sebuah wadah yang mendefinisikan *di mana* dan *bagaimana* volume disimpan. **Volume** adalah **unit penyimpanan individual** yang dialokasikan dari pool, yang kemudian di-attach ke VM sebagai disk. Dengan abstraksi ini, libvirt memisahkan **penyediaan storage** (pool) dari **konsumsi storage** (volume yang di-attach ke domain).

**Peran dalam kurikulum:** Modul ini adalah **jembatan** antara `qemu-img` (Fase 2) dan manajemen storage tingkat lanjut (Fase 4). Di Fase 2, Anda membuat `qcow2` secara manual dan menunjuk path-nya langsung di flag QEMU. Di sini, Anda akan belajar bahwa libvirt mengelola path tersebut melalui pool dan volume, sehingga:
- Anda bisa **mengganti backend** (dari direktori ke LVM, ZFS, iSCSI) tanpa mengubah XML domain secara drastis.
- Anda bisa **mengotomasi** pembuatan, penghapusan, dan snapshot volume.
- Anda bisa **memonitor** penggunaan storage secara terpusat.
- Anda bisa **mengintegrasikan** dengan sistem backup dan replikasi.

**Tanpa penguasaan storage pool, Anda tidak akan bisa** melakukan clone efisien, snapshot berbasis storage, backup inkremental, atau migrasi storage di Fase 4 dan 8.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Abstraksi Storage: Pool vs Volume

Bayangkan sebuah **lemari arsip**:
- **Pool** adalah lemari itu sendiri — bisa berupa rak kayu (direktori), laci besi (LVM), atau gudang eksternal (iSCSI).
- **Volume** adalah **map** di dalam lemari — file individual yang bisa diambil dan diletakkan.

libvirt tidak peduli apakah pool itu direktori biasa, LVM volume group, ZFS dataset, atau iSCSI target. Yang penting adalah **antarmuka**: pool menyediakan volume, volume bisa di-attach ke domain. Ini adalah **polimorfisme storage**.

**Filosofi:** *Storage adalah sumber daya yang dikelola, bukan file yang ditunjuk.* Dengan mengabstraksi, libvirt memungkinkan portabilitas, otomasi, dan audit.

### 2.2. Jenis-jenis Pool

libvirt mendukung berbagai **tipe pool**:

| Tipe | Deskripsi | Contoh Penggunaan |
|---|---|---|
| **dir** | Direktori filesystem. | Default, paling sederhana. |
| **logical** | LVM volume group. | Performa tinggi, snapshot LVM. |
| **disk** | Disk fisik (partisi). | Untuk volume langsung. |
| **fs** | Filesystem yang di-mount. | Pre-formatted filesystem. |
| **netfs** | Network filesystem (NFS, CIFS). | Storage terpusat. |
| **iscsi** | iSCSI target. | SAN, storage jaringan. |
| **scsi** | SCSI host adapter. | Untuk HBA. |
| **mpath** | Multipath device. | High availability storage. |
| **rbd** | RADOS Block Device (Ceph). | Cloud, cluster. |
| **sheepdog** | Sheepdog distributed storage. | Cluster. |
| **gluster** | GlusterFS. | Distributed filesystem. |
| **zfs** | ZFS pool. | Snapshot, kompresi, checksum. |
| **vstorage** | Virtuozzo Storage. | Spesifik Virtuozzo. |

**Filosofi:** Setiap tipe pool memiliki **trade-off**: kesederhanaan (dir), performa (logical, zfs), skalabilitas (rbd, gluster), atau integrasi jaringan (netfs, iscsi). Memilih pool berarti memilih **strategi storage**.

### 2.3. Volume: Format dan Alokasi

Volume memiliki **format** (qcow2, raw, vmdk) dan **alokasi** (thin, thick). libvirt mendukung:
- **qcow2**: default, fitur lengkap, thin provisioning.
- **raw**: performa maksimal, tidak ada fitur lanjutan.
- **vmdk**, **vdi**, **vpc**, **vhdx**: untuk kompatibilitas.

**Alokasi:**
- **Thin**: file tumbuh sesuai kebutuhan. Hemat ruang.
- **Thick**: file dialokasikan penuh. Performa lebih baik.

**Filosofi:** Format adalah **kontrak** dengan guest dan host. Volume adalah **unit alokasi** yang bisa di-clone, di-snapshot, dan di-backup.

### 2.4. Pool Lifecycle

Pool melewati state:
1. **Defined**: pool terdefinisi tetapi belum aktif.
2. **Built**: pool sudah dibuat (mis. direktori dibuat, LVM VG dibuat).
3. **Started**: pool aktif dan bisa menyediakan volume.
4. **Autostart**: pool otomatis start saat host boot.
5. **Destroyed**: pool dihentikan.
6. **Undefined**: pool dihapus definisinya.

**Filosofi:** Pool harus **started** sebelum volume bisa dibuat. Pool harus **autostart** untuk memastikan VM bisa boot setelah host reboot.

### 2.5. Volume Lifecycle

Volume melewati state:
1. **Created**: volume dibuat dari pool.
2. **Attached**: volume di-attach ke domain.
3. **Cloned**: volume di-clone.
4. **Resized**: volume diubah ukurannya.
5. **Deleted**: volume dihapus.

**Filosofi:** Volume adalah **sumber daya yang dialokasikan**. Harus ada manajemen siklus hidup untuk mencegah kebocoran storage.

### 2.6. Hubungan dengan `qemu-img`

libvirt **menggunakan `qemu-img` di balik layar** untuk membuat, mengonversi, dan mengelola volume. Ketika Anda `virsh vol-create-as --format qcow2`, libvirt memanggil `qemu-img create`. Ketika Anda `virsh vol-clone`, libvirt memanggil `qemu-img convert` atau `qemu-img create -b`.

**Filosofi:** libvirt adalah **orkestrator**; `qemu-img` adalah **alat**. Memahami keduanya memungkinkan Anda melakukan hal-hal yang tidak bisa dilakukan libvirt sendiri.

### 2.7. Filosofi Keseluruhan

- **Abstraksi adalah kekuatan.** Pool/volume memisahkan penyediaan dari konsumsi.
- **Portabilitas.** Ganti backend tanpa mengubah XML domain.
- **Otomasi.** Semua operasi bisa dilakukan via `virsh` atau API.
- **Audit.** Pool dan volume bisa di-list, di-info, dan di-monitor.
- **Integrasi.** Pool bisa berupa direktori, LVM, ZFS, iSCSI, Ceph, dll.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **Storage Pool** | Wadah penyimpanan. | `default`, `mypool`. |
| **Volume** | Unit penyimpanan di pool. | `disk.qcow2`. |
| **`virsh pool-list`** | Daftar pool. | `--all`, `--inactive`. |
| **`virsh pool-define-as`** | Definisikan pool. | `dir`, `logical`, `zfs`, dll. |
| **`virsh pool-build`** | Buat pool. | Buat direktori, VG, dll. |
| **`virsh pool-start`** | Aktifkan pool. | |
| **`virsh pool-autostart`** | Autostart pool. | |
| **`virsh pool-destroy`** | Hentikan pool. | |
| **`virsh pool-undefine`** | Hapus definisi pool. | |
| **`virsh pool-delete`** | Hapus isi pool. | Hati-hati! |
| **`virsh pool-info`** | Info pool. | Kapasitas, alokasi, tersedia. |
| **`virsh pool-dumpxml`** | XML pool. | |
| **`virsh pool-edit`** | Edit XML pool. | |
| **`virsh pool-refresh`** | Refresh daftar volume. | |
| **`virsh vol-list`** | Daftar volume di pool. | |
| **`virsh vol-create-as`** | Buat volume. | `--format qcow2`, `--capacity`. |
| **`virsh vol-create`** | Buat volume dari XML. | |
| **`virsh vol-clone`** | Clone volume. | |
| **`virsh vol-delete`** | Hapus volume. | |
| **`virsh vol-wipe`** | Hapus data volume. | Zero, random, dll. |
| **`virsh vol-resize`** | Ubah ukuran volume. | |
| **`virsh vol-info`** | Info volume. | Kapasitas, alokasi, format. |
| **`virsh vol-dumpxml`** | XML volume. | |
| **`virsh vol-path`** | Path volume. | |
| **`virsh vol-name`** | Nama volume. | |
| **`virsh vol-key`** | Key volume. | |
| **`virsh vol-upload`** | Upload data ke volume. | |
| **`virsh vol-download`** | Download data dari volume. | |
| **`virsh find-storage-pool-sources-as`** | Cari pool. | |
| **`virsh find-storage-pool-sources`** | Cari pool. | |
| **`dir`** | Pool direktori. | Default. |
| **`logical`** | Pool LVM. | |
| **`zfs`** | Pool ZFS. | |
| **`rbd`** | Pool Ceph RBD. | |
| **`netfs`** | Pool network filesystem. | NFS, CIFS. |
| **`iscsi`** | Pool iSCSI. | |
| **`gluster`** | Pool GlusterFS. | |
| **`mpath`** | Pool multipath. | |
| **`scsi`** | Pool SCSI. | |
| **`disk`** | Pool disk. | |
| **`fs`** | Pool filesystem. | |
| **`sheepdog`** | Pool Sheepdog. | |
| **`vstorage`** | Pool Virtuozzo. | |
| **Capacity** | Kapasitas total. | |
| **Allocation** | Alokasi terpakai. | |
| **Available** | Kapasitas tersedia. | |
| **Thin provisioning** | Alokasi dinamis. | qcow2 default. |
| **Thick provisioning** | Alokasi penuh. | raw, preallocation. |
| **Backing store** | Backing file. | Untuk overlay. |
| **Clone** | Salinan volume. | Bisa full atau linked. |
| **Snapshot** | Titik pemulihan. | Fase 4. |
| **Wipe** | Hapus data. | Zero, random, dll. |
| **Refresh** | Perbarui daftar volume. | Setelah perubahan manual. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Melihat Pool yang Ada

```bash
virsh pool-list --all
virsh pool-list --all --details
virsh pool-info default
virsh pool-dumpxml default
```

**Penjelasan kata demi kata:**
- `virsh pool-list --all`: daftar semua pool, termasuk yang tidak aktif.
- `--details`: tampilkan detail (autostart, persistent, state).
- `virsh pool-info default`: info pool `default`.
- `virsh pool-dumpxml default`: XML pool.

**Output `virsh pool-list --all`:**
```
 Name      State    Autostart
---------------------------------
 default   active   yes
```

**Output `virsh pool-info default`:**
```
Name:           default
UUID:           f1e2d3c4-b5a6-9788-1234-567890abcdef
State:          running
Persistent:     yes
Autostart:      yes
Capacity:       100.00 GiB
Allocation:     20.00 GiB
Available:      80.00 GiB
```

**Output `virsh pool-dumpxml default`:**
```xml
<pool type='dir'>
  <name>default</name>
  <uuid>f1e2d3c4-b5a6-9788-1234-567890abcdef</uuid>
  <capacity unit='bytes'>107374182400</capacity>
  <allocation unit='bytes'>21474836480</allocation>
  <available unit='bytes'>85899345920</available>
  <source>
  </source>
  <target>
    <path>/var/lib/libvirt/images</path>
    <permissions>
      <mode>0711</mode>
      <owner>0</owner>
      <group>0</group>
    </permissions>
  </target>
</pool>
```

**Penjelasan XML:**
- `<pool type='dir'>`: tipe pool direktori.
- `<name>default</name>`: nama pool.
- `<uuid>`: UUID pool.
- `<capacity>`, `<allocation>`, `<available>`: kapasitas dalam bytes.
- `<source>`: sumber pool (kosong untuk dir).
- `<target>`: target pool.
  - `<path>/var/lib/libvirt/images</path>`: path direktori.
  - `<permissions>`: permission direktori.

### 4.2. Membuat Pool Direktori

```bash
virsh pool-define-as mypool dir --target /var/lib/libvirt/images/mypool
virsh pool-build mypool
virsh pool-start mypool
virsh pool-autostart mypool
```

**Penjelasan kata demi kata:**
- `virsh pool-define-as`: definisikan pool baru.
- `mypool`: nama pool.
- `dir`: tipe pool (direktori).
- `--target /path`: path direktori.
- `virsh pool-build`: buat direktori jika belum ada.
- `virsh pool-start`: aktifkan pool.
- `virsh pool-autostart`: tandai untuk autostart.

**Output:**
```
Pool mypool defined
Pool mypool built
Pool mypool started
Pool mypool marked as autostarted
```

### 4.3. Membuat Pool LVM

```bash
virsh pool-define-as vgpool logical --source-name vg0 --target /dev/vg0
virsh pool-build vgpool
virsh pool-start vgpool
virsh pool-autostart vgpool
```

**Penjelasan kata demi kata:**
- `logical`: tipe pool LVM.
- `--source-name vg0`: nama volume group.
- `--target /dev/vg0`: path device VG.

**Prasyarat:** Volume group `vg0` harus sudah ada (`vgcreate vg0 /dev/sdb1`).

### 4.4. Membuat Pool ZFS

```bash
virsh pool-define-as zfspool zfs --source-name tank --target /tank
virsh pool-start zfspool
virsh pool-autostart zfspool
```

**Penjelasan kata demi kata:**
- `zfs`: tipe pool ZFS.
- `--source-name tank`: nama ZFS pool.
- `--target /tank`: mount point.

**Prasyarat:** ZFS pool `tank` harus sudah ada (`zpool create tank /dev/sdb`).

### 4.5. Membuat Pool iSCSI

```bash
virsh pool-define-as iscsipool iscsi \
  --source-host 192.168.1.100 \
  --source-dev iqn.2024-01.com.example:target0 \
  --target /dev/disk/by-path
virsh pool-start iscsipool
virsh pool-autostart iscsipool
```

**Penjelasan kata demi kata:**
- `iscsi`: tipe pool iSCSI.
- `--source-host`: IP atau hostname target iSCSI.
- `--source-dev`: IQN target.
- `--target`: path device di host.

### 4.6. Melihat Volume di Pool

```bash
virsh vol-list default
virsh vol-info arch.qcow2 default
virsh vol-dumpxml arch.qcow2 default
virsh vol-path arch.qcow2 default
```

**Penjelasan kata demi kata:**
- `virsh vol-list default`: daftar volume di pool `default`.
- `virsh vol-info`: info volume.
- `virsh vol-dumpxml`: XML volume.
- `virsh vol-path`: path lengkap volume.

**Output `virsh vol-list default`:**
```
 Name              Path
-----------------------------------------
 arch.qcow2        /var/lib/libvirt/images/arch.qcow2
 test.qcow2        /var/lib/libvirt/images/test.qcow2
```

**Output `virsh vol-info arch.qcow2 default`:**
```
Name:           arch.qcow2
Type:           file
Capacity:       10.00 GiB
Allocation:     2.00 GiB
```

**Output `virsh vol-dumpxml arch.qcow2 default`:**
```xml
<volume type='file'>
  <name>arch.qcow2</name>
  <key>/var/lib/libvirt/images/arch.qcow2</key>
  <source>
  </source>
  <capacity unit='bytes'>10737418240</capacity>
  <allocation unit='bytes'>2147483648</allocation>
  <target>
    <path>/var/lib/libvirt/images/arch.qcow2</path>
    <format type='qcow2'/>
    <permissions>
      <mode>0644</mode>
      <owner>0</owner>
      <group>0</group>
    </permissions>
  </target>
</volume>
```

### 4.7. Membuat Volume

```bash
virsh vol-create-as default newdisk.qcow2 10G --format qcow2
virsh vol-create-as default rawdisk.raw 10G --format raw
virsh vol-create-as default prealloc.qcow2 10G --format qcow2 --allocation 10G
virsh vol-create-as default backed.qcow2 10G --format qcow2 --backing-vol base.qcow2 --backing-vol-format qcow2
```

**Penjelasan kata demi kata:**
- `virsh vol-create-as`: buat volume baru.
- `default`: nama pool.
- `newdisk.qcow2`: nama volume.
- `10G`: kapasitas.
- `--format qcow2`: format volume.
- `--allocation 10G`: alokasi penuh (thick provisioning).
- `--backing-vol base.qcow2`: backing file untuk overlay.
- `--backing-vol-format qcow2`: format backing file.

**Output:**
```
Vol newdisk.qcow2 created
```

### 4.8. Clone Volume

```bash
virsh vol-clone --pool default arch.qcow2 arch-clone.qcow2
virsh vol-clone --pool default arch.qcow2 arch-clone.qcow2 --prealloc-metadata
```

**Penjelasan kata demi kata:**
- `virsh vol-clone`: clone volume.
- `--pool default`: pool sumber.
- `arch.qcow2`: volume sumber.
- `arch-clone.qcow2`: volume tujuan.
- `--prealloc-metadata`: prealloc metadata untuk performa.

**Output:**
```
Vol arch-clone.qcow2 cloned from arch.qcow2
```

**Kegunaan:** Clone efisien dengan qcow2. libvirt menggunakan `qemu-img convert` atau `qemu-img create -b`.

### 4.9. Resize Volume

```bash
virsh vol-resize arch.qcow2 20G --pool default
virsh vol-resize arch.qcow2 +5G --pool default
virsh vol-resize arch.qcow2 15G --pool default --shrink
```

**Penjelasan kata demi kata:**
- `virsh vol-resize`: ubah ukuran volume.
- `20G`: ukuran baru absolut.
- `+5G`: tambah 5G dari ukuran saat ini.
- `--shrink`: izinkan memperkecil (hati-hati!).

**Output:**
```
Size of volume 'arch.qcow2' successfully changed to 20G
```

**Peringatan:** Memperkecil berbahaya jika ada data. Guest harus di-resize filesystem-nya.

### 4.10. Hapus Volume

```bash
virsh vol-delete arch-clone.qcow2 --pool default
virsh vol-wipe arch-clone.qcow2 --pool default --algorithm zero
virsh vol-wipe arch-clone.qcow2 --pool default --algorithm random
```

**Penjelasan kata demi kata:**
- `virsh vol-delete`: hapus volume.
- `virsh vol-wipe`: hapus data volume (overwrite).
- `--algorithm zero`: tulis nol.
- `--algorithm random`: tulis data acak.

**Output:**
```
Vol arch-clone.qcow2 deleted
Vol arch-clone.qcow2 wiped
```

### 4.11. Upload/Download Volume

```bash
virsh vol-upload --pool default --vol newdisk.qcow2 /path/to/local.img
virsh vol-download --pool default --vol newdisk.qcow2 /path/to/local.img
```

**Penjelasan kata demi kata:**
- `virsh vol-upload`: upload data ke volume.
- `virsh vol-download`: download data dari volume.

**Kegunaan:** Import/export image tanpa `qemu-img`.

### 4.12. Pool dari XML

```xml
<pool type='dir'>
  <name>mypool</name>
  <target>
    <path>/var/lib/libvirt/images/mypool</path>
  </target>
</pool>
```

```bash
virsh pool-define mypool.xml
virsh pool-build mypool
virsh pool-start mypool
virsh pool-autostart mypool
```

**Penjelasan:**
- `virsh pool-define`: definisikan pool dari XML.
- XML minimal untuk pool direktori.

### 4.13. Volume dari XML

```xml
<volume type='file'>
  <name>newdisk.qcow2</name>
  <capacity unit='GiB'>10</capacity>
  <target>
    <format type='qcow2'/>
  </target>
</volume>
```

```bash
virsh vol-create default newdisk.xml
```

**Penjelasan:**
- `virsh vol-create`: buat volume dari XML.
- XML mendefinisikan nama, kapasitas, format.

### 4.14. Refresh Pool

```bash
virsh pool-refresh default
```

**Penjelasan:**
- `virsh pool-refresh`: perbarui daftar volume di pool.
- Berguna setelah menambah/menghapus file volume secara manual.

### 4.15. Hapus Pool

```bash
virsh pool-destroy mypool
virsh pool-undefine mypool
virsh pool-delete mypool
```

**Penjelasan kata demi kata:**
- `virsh pool-destroy`: hentikan pool.
- `virsh pool-undefine`: hapus definisi pool.
- `virsh pool-delete`: hapus isi pool (direktori, VG, dll).

**Peringatan:** `pool-delete` menghapus data! Backup dulu.

---

## 5. Diagram Arsitektur Storage Pool & Volume

### 5.1. Arsitektur Pool dan Volume

```
+-------------------------------------------------------------+
|                        libvirt                              |
|  +-------------------+  +-------------------+               |
|  |   Storage Pool    |  |   Storage Pool    |               |
|  |   (dir)           |  |   (logical)       |               |
|  |  /var/lib/...     |  |   vg0             |               |
|  +-------------------+  +-------------------+               |
|         |                        |                          |
|         v                        v                          |
|  +-------------------+  +-------------------+               |
|  |   Volume          |  |   Volume          |               |
|  |   arch.qcow2      |  |   lv0             |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        QEMU                                 |
|  +-------------------+  +-------------------+               |
|  |   Disk virtio     |  |   Disk virtio     |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        Guest                                |
|  +-------------------+  +-------------------+               |
|  |   /dev/vda        |  |   /dev/vdb        |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
```

### 5.2. Alur Pembuatan Volume

```
+-------------------+
|  virsh vol-create |
+-------------------+
          |
          v
+-------------------+
|  libvirt cek pool |
+-------------------+
          |
          v
+-------------------+
|  libvirt panggil  |
|  qemu-img create  |
+-------------------+
          |
          v
+-------------------+
|  File volume      |
|  dibuat           |
+-------------------+
          |
          v
+-------------------+
|  libvirt refresh  |
|  daftar volume    |
+-------------------+
          |
          v
+-------------------+
|  Volume siap      |
|  di-attach ke VM  |
+-------------------+
```

### 5.3. Alur Clone Volume

```
+-------------------+
|  virsh vol-clone  |
+-------------------+
          |
          v
+-------------------+
|  libvirt cek      |
|  volume sumber    |
+-------------------+
          |
          v
+-------------------+
|  qemu-img convert |
|  atau create -b   |
+-------------------+
          |
          v
+-------------------+
|  Volume clone     |
|  dibuat           |
+-------------------+
          |
          v
+-------------------+
|  libvirt refresh  |
+-------------------+
```

### 5.4. Hierarki Pool dan Volume

```
+-------------------+
|   Host            |
+-------------------+
          |
          v
+-------------------+
|   Storage Pool    |
|   (dir, logical,  |
|    zfs, rbd, ...) |
+-------------------+
          |
          v
+-------------------+
|   Volume          |
|   (qcow2, raw,    |
|    vmdk, ...)     |
+-------------------+
          |
          v
+-------------------+
|   Domain          |
|   (VM)            |
+-------------------+
          |
          v
+-------------------+
|   Guest           |
|   (/dev/vda, ...) |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan ZFS, LVM, iSCSI, RBD, NFS, Gluster, dan Volume XML

Kurikulum asli menyebut:
```bash
virsh pool-define-as default dir --target /var/lib/libvirt/images
virsh pool-build default
virsh pool-start default
virsh pool-autostart default
virsh vol-create-as default disk1.qcow2 10G --format qcow2
Validasi: virsh vol-list default menampilkan volume.
```

Saya menambahkan:

1. **Pool LVM (`logical`)** — performa tinggi, snapshot LVM.
2. **Pool ZFS (`zfs`)** — snapshot, kompresi, checksum.
3. **Pool iSCSI (`iscsi`)** — SAN, storage jaringan.
4. **Pool RBD (`rbd`)** — Ceph, cloud.
5. **Pool NFS (`netfs`)** — storage terpusat.
6. **Pool Gluster (`gluster`)** — distributed filesystem.
7. **Pool Multipath (`mpath`)** — high availability.
8. **Pool SCSI (`scsi`)** — HBA.
9. **Pool Disk (`disk`)** — disk fisik.
10. **Pool FS (`fs`)** — filesystem pre-formatted.
11. **Volume XML** — `<volume>`, `<capacity>`, `<allocation>`, `<target>`, `<format>`, `<backingStore>`.
12. **`virsh vol-create`** — buat volume dari XML.
13. **`virsh vol-clone`** — clone volume.
14. **`virsh vol-resize`** — resize volume.
15. **`virsh vol-wipe`** — wipe volume.
16. **`virsh vol-upload`/`vol-download`** — upload/download.
17. **`virsh vol-path`** — path volume.
18. **`virsh vol-key`** — key volume.
19. **`virsh vol-name`** — nama volume.
20. **`virsh pool-refresh`** — refresh pool.
21. **`virsh pool-delete`** — hapus isi pool.
22. **`virsh pool-edit`** — edit XML pool.
23. **`virsh pool-dumpxml`** — XML pool.
24. **`virsh find-storage-pool-sources-as`** — cari pool.
25. **Backing store** — `--backing-vol`, `--backing-vol-format`.
26. **Preallocation** — `--allocation`, `--prealloc-metadata`.
27. **Thin vs thick** — alokasi.
28. **Snapshot storage** — pengantar Fase 4.
29. **Pool permissions** — `<permissions>`.
30. **Pool source** — `<source>` untuk netfs, iscsi, rbd.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.4, dengan lab tambahan untuk LVM, ZFS, dan iSCSI.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.1 (`virt-install`):** `--disk size=10` membuat volume di pool default.
- **Modul 3.2 (XML):** XML disk merujuk ke volume via `<source file='...'/>` atau `<source volume='...'/>`.
- **Modul 3.3 (Lifecycle):** Pool harus started sebelum VM bisa start.
- **Modul 3.5 (Monitoring):** `domstats` dan `pool-info` untuk monitoring storage.
- **Modul 3.6 (Konsol):** Tidak terkait langsung.
- **Modul 3.7 (Backup XML):** XML pool dan volume harus di-backup.
- **Fase 4 (Storage & Backup):** Snapshot, clone, blockcommit, blockpull. Modul ini adalah fondasi.
- **Fase 5 (Networking):** Netfs, iSCSI, RBD untuk storage jaringan.
- **Fase 6 (Keamanan):** Enkripsi volume, permission pool.
- **Fase 7 (Otomasi):** Skrip untuk provisioning storage.
- **Fase 8 (Expert):** Migrasi storage, replikasi, Ceph, Gluster.

---

## 8. Referensi Lengkap

- **libvirt Storage Management** — https://libvirt.org/storage.html
- **libvirt Storage Pool XML** — https://libvirt.org/formatstorage.html
- **libvirt Storage Volume XML** — https://libvirt.org/formatstorage.html#storage-volume
- **virsh man page** — https://libvirt.org/manpages/virsh.html
- **libvirt pool-define-as** — https://libvirt.org/manpages/virsh.html#pool-define-as
- **libvirt vol-create-as** — https://libvirt.org/manpages/virsh.html#vol-create-as
- **libvirt vol-clone** — https://libvirt.org/manpages/virsh.html#vol-clone
- **libvirt vol-resize** — https://libvirt.org/manpages/virsh.html#vol-resize
- **libvirt vol-wipe** — https://libvirt.org/manpages/virsh.html#vol-wipe
- **libvirt vol-upload** — https://libvirt.org/manpages/virsh.html#vol-upload
- **libvirt vol-download** — https://libvirt.org/manpages/virsh.html#vol-download
- **libvirt pool-refresh** — https://libvirt.org/manpages/virsh.html#pool-refresh
- **libvirt pool-delete** — https://libvirt.org/manpages/virsh.html#pool-delete
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt
- **Arch Wiki: LVM** — https://wiki.archlinux.org/title/LVM
- **Arch Wiki: ZFS** — https://wiki.archlinux.org/title/ZFS
- **Arch Wiki: iSCSI** — https://wiki.archlinux.org/title/ISCSI
- **Arch Wiki: NFS** — https://wiki.archlinux.org/title/NFS
- **Arch Wiki: Ceph** — https://wiki.archlinux.org/title/Ceph
- **QEMU qemu-img** — https://www.qemu.org/docs/master/tools/qemu-img.html
- **libvirt Storage Backends** — https://libvirt.org/storage.html#StorageBackendDir

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan pool** daripada path langsung. Portabilitas dan otomasi.
2. **Gunakan pool `dir`** untuk kesederhanaan. Cocok untuk development.
3. **Gunakan pool `logical` (LVM)** untuk performa dan snapshot LVM.
4. **Gunakan pool `zfs`** untuk snapshot, kompresi, dan checksum.
5. **Gunakan pool `netfs`** untuk storage terpusat (NFS).
6. **Gunakan pool `iscsi`** untuk SAN.
7. **Gunakan pool `rbd`** untuk Ceph.
8. **Selalu `pool-build`** sebelum `pool-start`.
9. **Selalu `pool-autostart`** untuk VM yang harus boot setelah host reboot.
10. **Gunakan `--format qcow2`** untuk fleksibilitas.
11. **Gunakan `--format raw`** untuk performa.
12. **Gunakan `--allocation`** untuk thick provisioning.
13. **Gunakan `--prealloc-metadata`** untuk performa qcow2.
14. **Gunakan `vol-clone`** untuk clone efisien.
15. **Gunakan `vol-resize`** dengan hati-hati. Jangan shrink tanpa backup.
16. **Gunakan `vol-wipe`** sebelum menghapus volume sensitif.
17. **Gunakan `vol-upload`/`vol-download`** untuk import/export.
18. **Gunakan `pool-refresh`** setelah perubahan manual.
19. **Backup XML pool dan volume.**
20. **Monitor kapasitas pool** dengan `pool-info`.
21. **Gunakan `pool-delete`** dengan hati-hati. Menghapus data!
22. **Gunakan `vol-path`** untuk scripting.
23. **Gunakan `vol-key`** untuk referensi unik.
24. **Gunakan `find-storage-pool-sources-as`** untuk discovery.
25. **Integrasikan dengan backup** di Fase 4.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `Pool not found` | Pool belum didefinisikan. | `virsh pool-define-as`. |
| `Pool already exists` | Nama pool sudah ada. | Gunakan nama lain atau `pool-undefine`. |
| `Pool is not running` | Pool belum start. | `virsh pool-start`. |
| `Pool is not persistent` | Pool tidak persistent. | Definisikan ulang dengan `pool-define-as`. |
| `Cannot build pool` | Direktori sudah ada atau permission. | Cek path, permission. |
| `Cannot start pool` | Sumber tidak tersedia. | Cek mount, VG, ZFS pool. |
| `Volume not found` | Volume belum dibuat. | `virsh vol-create-as`. |
| `Volume already exists` | Nama volume sudah ada. | Gunakan nama lain atau `vol-delete`. |
| `Cannot create volume` | Pool tidak running atau space tidak cukup. | Cek `pool-info`, cek space. |
| `Cannot clone volume` | Volume sumber tidak ada atau format tidak didukung. | Cek `vol-info`. |
| `Cannot resize volume` | Volume sedang digunakan atau format tidak mendukung. | Matikan VM, cek format. |
| `Cannot delete volume` | Volume sedang digunakan. | Matikan VM, detach disk. |
| `Cannot wipe volume` | Volume sedang digunakan. | Matikan VM. |
| `Pool refresh gagal` | Permission atau path salah. | Cek permission, cek path. |
| `Pool delete gagal` | Pool masih running. | `pool-destroy` dulu. |
| `Pool autostart gagal` | Permission. | Cek permission `/etc/libvirt/storage/autostart/`. |
| `Volume tidak muncul di vol-list` | Pool belum di-refresh. | `virsh pool-refresh`. |
| `Backing store tidak ditemukan` | Path backing salah. | Cek path, gunakan absolut. |
| `Format tidak didukung` | Format tidak dikenal. | Cek `qemu-img --help`. |
| `Permission denied` | User tidak di grup `libvirt`. | `usermod -aG libvirt $USER`. |
| `Storage pool already in use` | Pool sedang digunakan VM. | Matikan VM. |
| `Cannot undefine pool` | Pool masih running. | `pool-destroy` dulu. |
| `LVM VG not found` | VG belum dibuat. | `vgcreate`. |
| `ZFS pool not found` | ZFS pool belum dibuat. | `zpool create`. |
| `iSCSI target not found` | Target tidak tersedia. | Cek network, cek target. |
| `NFS mount failed` | NFS server tidak tersedia. | Cek mount manual. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh pool-list --all` menampilkan pool `default` dan `mypool`.
- `virsh pool-info default` menampilkan kapasitas, alokasi, tersedia.
- `virsh pool-dumpxml default` menampilkan XML pool.
- `virsh vol-list default` menampilkan volume.
- `virsh vol-info arch.qcow2 default` menampilkan info volume.
- `virsh vol-create-as default test.qcow2 5G --format qcow2` berhasil.
- `virsh vol-clone --pool default test.qcow2 test-clone.qcow2` berhasil.
- `virsh vol-resize test.qcow2 10G --pool default` berhasil.
- `virsh vol-delete test-clone.qcow2 --pool default` berhasil.
- `virsh pool-refresh default` berhasil.
- `virsh pool-destroy mypool` berhasil.
- `virsh pool-undefine mypool` berhasil.
- VM bisa menggunakan volume dari pool.
- `virsh domblklist arch-vm` menampilkan volume.

**Troubleshooting:**
- Jika pool tidak ditemukan: `virsh pool-list --all`.
- Jika pool tidak running: `virsh pool-start`.
- Jika volume tidak muncul: `virsh pool-refresh`.
- Jika volume tidak bisa dibuat: cek `pool-info`, cek space.
- Jika volume tidak bisa di-attach: cek XML disk, cek path.
- Jika pool LVM gagal: cek `vgs`, `pvs`, `lvs`.
- Jika pool ZFS gagal: cek `zpool status`, `zfs list`.
- Jika pool iSCSI gagal: cek `iscsiadm -m session`, cek network.
- Jika pool NFS gagal: cek `mount`, cek network.
- Jika permission ditolak: cek grup `libvirt`, cek permission path.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk melihat log libvirt: `journalctl -u virtstoraged`.
- Untuk melihat log QEMU: `/var/log/libvirt/qemu/<name>.log`.
- Untuk melihat XML: `virsh pool-dumpxml`, `virsh vol-dumpxml`.
- Untuk validasi XML: `virt-xml-validate`.
- Untuk melihat schema: `/usr/share/libvirt/schemas/storagepool.rng`, `storagevol.rng`.

---

## 12. Latihan Mandiri

1. Lihat pool yang ada: `virsh pool-list --all`.
2. Lihat info pool default: `virsh pool-info default`.
3. Lihat XML pool default: `virsh pool-dumpxml default`.
4. Buat pool direktori baru: `virsh pool-define-as mypool dir --target /var/lib/libvirt/images/mypool`.
5. Build pool: `virsh pool-build mypool`.
6. Start pool: `virsh pool-start mypool`.
7. Autostart pool: `virsh pool-autostart mypool`.
8. Lihat pool: `virsh pool-list --all`.
9. Buat volume di mypool: `virsh vol-create-as mypool disk1.qcow2 10G --format qcow2`.
10. Lihat volume: `virsh vol-list mypool`.
11. Lihat info volume: `virsh vol-info disk1.qcow2 mypool`.
12. Clone volume: `virsh vol-clone --pool mypool disk1.qcow2 disk1-clone.qcow2`.
13. Resize volume: `virsh vol-resize disk1.qcow2 15G --pool mypool`.
14. Lihat info volume setelah resize.
15. Hapus volume clone: `virsh vol-delete disk1-clone.qcow2 --pool mypool`.
16. Wipe volume: `virsh vol-wipe disk1.qcow2 --pool mypool --algorithm zero`.
17. Upload file ke volume: `virsh vol-upload --pool mypool --vol disk1.qcow2 /path/to/local.img`.
18. Download file dari volume: `virsh vol-download --pool mypool --vol disk1.qcow2 /path/to/local.img`.
19. Refresh pool: `virsh pool-refresh mypool`.
20. Destroy pool: `virsh pool-destroy mypool`.
21. Undefine pool: `virsh pool-undefine mypool`.
22. Delete pool: `virsh pool-delete mypool` (hati-hati!).
23. Buat pool LVM: `virsh pool-define-as vgpool logical --source-name vg0 --target /dev/vg0`.
24. Buat pool ZFS: `virsh pool-define-as zfspool zfs --source-name tank --target /tank`.
25. Buat pool iSCSI: `virsh pool-define-as iscsipool iscsi --source-host 192.168.1.100 --source-dev iqn.2024-01.com.example:target0 --target /dev/disk/by-path`.
26. Tulis ringkasan: kapan menggunakan pool dir vs LVM vs ZFS vs iSCSI, dan bagaimana pool/volume berhubungan dengan `qemu-img`.

---

## 13. Penutup Modul 3.4

Anda kini menguasai **Storage Pool & Volume** — abstraksi libvirt untuk mengelola penyimpanan. Anda bisa membuat pool dari berbagai backend (dir, LVM, ZFS, iSCSI, NFS, RBD, Gluster), membuat volume, clone, resize, wipe, upload/download, dan menghapus. Anda memahami bagaimana libvirt menggunakan `qemu-img` di balik layar dan bagaimana pool/volume berhubungan dengan XML domain. Ini adalah fondasi untuk **Modul 3.5 — Monitoring & Diagnostik**, di mana Anda akan memantau penggunaan resource VM dan storage.

---

## Motivasi Berenergi

Storage adalah **bahan bakar** virtualisasi. Tanpa pengelolaan yang baik, VM Anda akan kelaparan atau kelebihan beban. Dengan menguasai pool dan volume, Anda bukan lagi sekadar pengguna yang menunjuk path; Anda adalah **arsitek penyimpanan** yang memahami lapisan abstraksi, trade-off backend, dan siklus hidup volume. Teruslah berevolusi, karena di balik setiap `virsh vol-create-as` ada seorang insinyur yang memahami bahwa storage bukan sekadar file, melainkan **sumber daya yang dikelola**. Selamat belajar, dan jangan pernah berhenti mengabstraksi!

---

## Motivasi Awal

Selamat! Anda kini menguasai **Storage Pool & Volume** — bahan bakar virtualisasi. Namun, membangun VM tanpa **mata dan telinga** sama seperti menerbangkan pesawat tanpa instrumen. Di Modul 3.5 ini, Anda akan mempelajari **Monitoring & Diagnostik** — seni mengamati, mengukur, dan mendiagnosis VM. Anda akan belajar membaca statistik runtime, melacak penggunaan CPU/memori/I/O, dan men-diagnosis masalah sebelum menjadi bencana. Inilah keterampilan yang membedakan **operator reaktif** (yang hanya tahu sesuatu rusak setelah crash) dari **operator proaktif** (yang tahu sesuatu akan rusak sebelum terjadi). Tetap fokus, karena di sini Anda akan menjadi **dokter** bagi setiap VM Anda.

---

## Mini-Daftar Isi Modul 3.5

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Arsitektur Monitoring & Alur Data Statistik
6. Audit Kurikulum: Tambahan `domstats`, `virt-top`, `domblkinfo`, `domifstat`, `dommemstat`, `vcpupin`, Tracing
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Monitoring & Diagnostik** dalam libvirt adalah kumpulan alat dan API untuk **mengamati state runtime** domain: penggunaan CPU, alokasi memori, I/O disk, I/O jaringan, state vCPU, dan kesehatan keseluruhan. Alat utama meliputi:
- **`virsh domstats`** — statistik terstruktur (XML/JSON) untuk domain.
- **`virsh dominfo`** — info statis domain.
- **`virsh domblkinfo`** — info disk (kapasitas, alokasi, fisik).
- **`virsh domifstat`** — statistik interface jaringan.
- **`virsh dommemstat`** — statistik memori.
- **`virsh vcpuinfo`** — info vCPU.
- **`virsh cpu-stats`** — statistik CPU.
- **`virsh domblkstat`** — statistik I/O disk.
- **`virsh domiflist`** / **`domblklist`** — daftar perangkat.
- **`virt-top`** — alat interaktif mirip `top` untuk VM.
- **`vhostmd`** — daemon monitoring host untuk guest.
- **`libvirt API`** — `virConnectGetAllDomainStats`.

**Peran dalam kurikulum:** Modul ini adalah **fondasi observability**. Setelah Anda bisa membuat (3.1), mengonfigurasi (3.2), menjalankan (3.3), dan menyimpan (3.4) VM, Anda harus bisa **mengamati perilakunya**. Ini adalah prasyarat untuk:
- **Fase 4 (Backup):** Memastikan VM idle sebelum snapshot.
- **Fase 6 (Keamanan):** Deteksi anomali.
- **Fase 7 (Otomasi):** Trigger otomatis berdasarkan metrik.
- **Fase 8 (Expert):** Observability tingkat lanjut, tracing, dan profiling.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Observability: Tiga Pilar

Observability modern terdiri dari tiga pilar:
1. **Metrics (Metrik):** Angka time-series. Contoh: CPU%, memori used, disk IOPS.
2. **Logs (Log):** Catatan kejadian diskrit. Contoh: `journalctl -u virtqemud`, `/var/log/libvirt/qemu/<name>.log`.
3. **Traces (Jejak):** Alur eksekusi lintas komponen. Contoh: `perf`, `ftrace`, `qemu-trace`.

libvirt menyediakan **metrics** via `domstats`, **logs** via file log, dan **traces** via integrasi dengan `perf` dan `ftrace`.

**Filosofi:** *"You can't manage what you can't measure."* — Peter Drucker. Monitoring bukan opsional; ia adalah bagian dari operasi.

### 2.2. Sumber Statistik: QEMU vs Guest

libvirt mengambil statistik dari **dua sumber**:
- **Host (QEMU):** Informasi dari proses QEMU: jumlah vCPU, memori yang dialokasikan, I/O disk, I/O jaringan. Ini adalah **view host**.
- **Guest (QGA):** Informasi dari dalam guest via QEMU Guest Agent: penggunaan CPU guest, memori guest, filesystem, proses. Ini adalah **view guest**.

**Filosofi:** Host view adalah **kebenaran resource**. Guest view adalah **kebenaran aplikasi**. Keduanya diperlukan untuk gambaran lengkap.

### 2.3. `domstats`: Statistik Terstruktur

`virsh domstats` adalah **permata** monitoring libvirt. Ia mengembalikan statistik dalam format terstruktur (XML/JSON) yang bisa di-parse oleh skrip. Setiap **grup statistik** memiliki prefix:
- `state.` — state domain.
- `cpu.` — statistik CPU.
- `balloon.` — statistik balloon.
- `vcpu.` — statistik vCPU.
- `interface.` — statistik jaringan.
- `block.` — statistik disk.
- `perf.` — statistik performa (perf events).
- `iothread.` — statistik iothread.
- `memory.` — statistik memori.
- `dirtyrate.` — dirty rate.

**Filosofi:** Statistik terstruktur memungkinkan **otomasi** dan **integrasi** dengan sistem monitoring (Prometheus, Grafana, Nagios).

### 2.4. `virt-top`: Alat Interaktif

`virt-top` adalah alat interaktif seperti `top` tetapi untuk VM. Ia menampilkan:
- Penggunaan CPU per VM.
- Penggunaan memori per VM.
- I/O disk per VM.
- I/O jaringan per VM.

**Filosofi:** Untuk **eksplorasi** dan **debugging cepat**, alat interaktif lebih baik daripada parsing statistik.

### 2.5. Statistik Per-vCPU vs Agregat

- **Agregat:** Total penggunaan CPU untuk semua vCPU. Berguna untuk gambaran umum.
- **Per-vCPU:** Penggunaan CPU per vCPU. Berguna untuk mendeteksi **imbalance** (satu vCPU sibuk, yang lain idle).

**Filosofi:** Imbalance adalah tanda **bottleneck** atau **aplikasi single-threaded**. Per-vCPU statistik mengungkap masalah yang tidak terlihat di agregat.

### 2.6. Statistik Blok dan Jaringan

- **Blok:** `rd_req`, `rd_bytes`, `wr_req`, `wr_bytes`, `flush_req`, `flush_total_times`. Berguna untuk mendeteksi **I/O bottleneck**.
- **Jaringan:** `rx_bytes`, `rx_packets`, `rx_errs`, `rx_drop`, `tx_bytes`, `tx_packets`, `tx_errs`, `tx_drop`. Berguna untuk mendeteksi **network bottleneck** dan **packet loss**.

**Filosofi:** Statistik adalah **jejak digital** dari perilaku VM. Membacanya adalah seni.

### 2.7. Tracing dan Profiling

- **`perf kvm`:** Profiling VM dari host.
- **`perf top`:** Live profiling.
- **`perf record`:** Rekam profil.
- **`ftrace`:** Trace kernel events.
- **`qemu-trace`:** Trace event QEMU.

**Filosofi:** Tracing adalah **mikroskop**. Ketika statistik tidak cukup, tracing mengungkap **apa yang sebenarnya terjadi**.

### 2.8. Filosofi Keseluruhan

- **Measure everything.** Jangan berasumsi.
- **Automate monitoring.** Skrip dan integrasi.
- **Correlate.** Hubungkan host view dan guest view.
- **Alert on anomaly.** Jangan hanya log; trigger aksi.
- **Trace when needed.** Tracing adalah alat debugging, bukan monitoring rutin.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **Monitoring** | Pengamatan berkelanjutan. | Metrik, log, trace. |
| **Diagnostik** | Analisis masalah. | Debugging, tracing. |
| **Metrics** | Angka time-series. | CPU%, memori. |
| **Logs** | Catatan kejadian. | `journalctl`, file log. |
| **Traces** | Jejak eksekusi. | `perf`, `ftrace`. |
| **`domstats`** | Statistik terstruktur. | `virsh domstats`. |
| **`dominfo`** | Info statis domain. | `virsh dominfo`. |
| **`domblkinfo`** | Info disk. | `virsh domblkinfo`. |
| **`domblkstat`** | Statistik I/O disk. | `virsh domblkstat`. |
| **`domifstat`** | Statistik jaringan. | `virsh domifstat`. |
| **`dommemstat`** | Statistik memori. | `virsh dommemstat`. |
| **`vcpuinfo`** | Info vCPU. | `virsh vcpuinfo`. |
| **`cpu-stats`** | Statistik CPU. | `virsh cpu-stats`. |
| **`virt-top`** | Alat interaktif. | Seperti `top`. |
| **`vhostmd`** | Daemon monitoring. | Untuk guest. |
| **`perf`** | Profiler Linux. | `perf kvm`. |
| **`ftrace`** | Kernel tracer. | `/sys/kernel/debug/tracing`. |
| **`qemu-trace`** | Trace event QEMU. | `-trace`. |
| **QGA** | QEMU Guest Agent. | View guest. |
| **Balloon** | Manajemen memori. | `dommemstat`. |
| **vCPU** | CPU virtual. | `vcpuinfo`. |
| **iothread** | Thread I/O. | `iothread.` stats. |
| **Dirty rate** | Laju perubahan memori. | Migrasi. |
| **Prometheus** | Sistem monitoring. | `libvirt_exporter`. |
| **Grafana** | Visualisasi. | Dashboard. |
| **Nagios** | Monitoring. | Plugin. |
| **Collectd** | Daemon metrik. | Plugin libvirt. |
| **Telegraf** | Agent metrik. | Input libvirt. |
| **`libvirt_exporter`** | Exporter Prometheus. | Untuk libvirt. |
| **`kvm_exporter`** | Exporter KVM. | Untuk QEMU. |
| **SNMP** | Protokol monitoring. | Untuk perangkat. |
| **Cacti** | Monitoring grafis. | Historis. |
| **Zabbix** | Monitoring. | Template libvirt. |
| **`sar`** | System Activity Reporter. | Historis. |
| **`iostat`** | Statistik I/O. | Host. |
| **`vmstat`** | Statistik VM host. | Host. |
| **`mpstat`** | Statistik CPU. | Host. |
| **`pidstat`** | Statistik proses. | QEMU. |
| **`turbostat`** | Statistik CPU power. | Host. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. `virsh dominfo` — Info Statis Domain

```bash
virsh dominfo arch-vm
```

**Penjelasan kata demi kata:**
- `virsh dominfo`: perintah info domain.
- `arch-vm`: nama domain.

**Output:**
```
Id:             1
Name:           arch-vm
UUID:           f1e2d3c4-b5a6-9788-1234-567890abcdef
OS Type:        hvm
State:          running
CPU(s):         2
CPU time:       123.4s
Max memory:     2097152 KiB
Used memory:    2097152 KiB
Persistent:     yes
Autostart:      disable
Managed save:   no
Security model: apparmor
Security DOI:   0
```

**Penjelasan output:**
- `Id`: ID runtime. Berubah setiap start.
- `Name`: nama domain.
- `UUID`: identitas permanen.
- `OS Type`: `hvm` untuk full virtualization.
- `State`: state domain.
- `CPU(s)`: jumlah vCPU.
- `CPU time`: total waktu CPU yang digunakan.
- `Max memory`: memori maksimum (KiB).
- `Used memory`: memori yang digunakan saat ini.
- `Persistent`: apakah XML tersimpan.
- `Autostart`: apakah autostart diaktifkan.
- `Managed save`: apakah ada managedsave state.
- `Security model`: model keamanan (apparmor, selinux).

### 4.2. `virsh domstats` — Statistik Terstruktur

```bash
virsh domstats arch-vm
virsh domstats arch-vm --state --cpu-total --balloon --vcpu --interface --block --perf --iothread --memory --dirtyrate
virsh domstats --all
virsh domstats --list-active
virsh domstats arch-vm --raw
```

**Penjelasan kata demi kata:**
- `virsh domstats`: statistik domain.
- `arch-vm`: nama domain.
- `--state`: statistik state.
- `--cpu-total`: statistik CPU total.
- `--balloon`: statistik balloon.
- `--vcpu`: statistik per-vCPU.
- `--interface`: statistik jaringan.
- `--block`: statistik disk.
- `--perf`: statistik perf events.
- `--iothread`: statistik iothread.
- `--memory`: statistik memori.
- `--dirtyrate`: dirty rate.
- `--all`: semua domain.
- `--list-active`: domain aktif.
- `--raw`: output mentah.

**Output `virsh domstats arch-vm`:**
```
Domain: 'arch-vm'
  state.state=1
  state.reason=1
  cpu.time=1234567890
  cpu.user=1000000000
  cpu.system=234567890
  balloon.current=2097152
  balloon.maximum=2097152
  balloon.swap_in=0
  balloon.swap_out=0
  balloon.major_fault=0
  balloon.minor_fault=0
  balloon.unused=0
  balloon.available=2097152
  balloon.usable=2097152
  vcpu.0.state=1
  vcpu.0.time=617283945
  vcpu.0.wait=0
  vcpu.1.state=1
  vcpu.1.time=617283945
  vcpu.1.wait=0
  net.count=1
  net.0.name=ens3
  net.0.rx.bytes=1234567
  net.0.rx.pkts=1234
  net.0.rx.errs=0
  net.0.rx.drop=0
  net.0.tx.bytes=7654321
  net.0.tx.pkts=4321
  net.0.tx.errs=0
  net.0.tx.drop=0
  block.count=1
  block.0.name=vda
  block.0.path=/var/lib/libvirt/images/arch.qcow2
  block.0.rd.reqs=1234
  block.0.rd.bytes=12345678
  block.0.rd.times=123456789
  block.0.wr.reqs=5678
  block.0.wr.bytes=87654321
  block.0.wr.times=987654321
  block.0.fl.reqs=100
  block.0.fl.times=1000000
  block.0.allocation=2147483648
  block.0.capacity=10737418240
  block.0.physical=2147483648
```

**Penjelasan output:**
- `state.state=1`: state domain (1 = running).
- `state.reason=1`: alasan state.
- `cpu.time`: total waktu CPU dalam nanodetik.
- `cpu.user`: waktu CPU di userspace.
- `cpu.system`: waktu CPU di kernel.
- `balloon.current`: memori saat ini.
- `balloon.maximum`: memori maksimum.
- `balloon.swap_in`/`swap_out`: swap.
- `balloon.major_fault`/`minor_fault`: page faults.
- `balloon.unused`: memori tidak terpakai di guest.
- `balloon.available`: memori tersedia.
- `balloon.usable`: memori yang bisa digunakan.
- `vcpu.N.state`: state vCPU (1 = running).
- `vcpu.N.time`: waktu CPU vCPU.
- `vcpu.N.wait`: waktu tunggu vCPU.
- `net.count`: jumlah interface.
- `net.N.name`: nama interface.
- `net.N.rx.bytes`: byte diterima.
- `net.N.rx.pkts`: paket diterima.
- `net.N.rx.errs`: error diterima.
- `net.N.rx.drop`: paket drop diterima.
- `net.N.tx.bytes`: byte dikirim.
- `net.N.tx.pkts`: paket dikirim.
- `net.N.tx.errs`: error dikirim.
- `net.N.tx.drop`: paket drop dikirim.
- `block.count`: jumlah disk.
- `block.N.name`: nama disk.
- `block.N.path`: path disk.
- `block.N.rd.reqs`: jumlah request baca.
- `block.N.rd.bytes`: byte dibaca.
- `block.N.rd.times`: waktu baca.
- `block.N.wr.reqs`: jumlah request tulis.
- `block.N.wr.bytes`: byte ditulis.
- `block.N.wr.times`: waktu tulis.
- `block.N.fl.reqs`: jumlah flush.
- `block.N.fl.times`: waktu flush.
- `block.N.allocation`: alokasi fisik.
- `block.N.capacity`: kapasitas virtual.
- `block.N.physical`: ukuran fisik.

### 4.3. Output JSON

```bash
virsh domstats arch-vm --state --cpu-total --balloon --vcpu --interface --block
virsh domstats arch-vm --state --cpu-total --balloon --vcpu --interface --block 2>/dev/null | jq .
```

**Penjelasan:**
- `jq`: alat parsing JSON.
- Output JSON memudahkan parsing dengan skrip.

### 4.4. `virsh domblkinfo` — Info Disk

```bash
virsh domblkinfo arch-vm vda
virsh domblkinfo arch-vm vda --human
```

**Penjelasan kata demi kata:**
- `virsh domblkinfo`: info blok (disk).
- `arch-vm`: nama domain.
- `vda`: target disk.
- `--human`: format manusiawi.

**Output:**
```
Capacity:       10737418240
Allocation:     2147483648
Physical:       2147483648
```

**Penjelasan:**
- `Capacity`: kapasitas virtual (bytes).
- `Allocation`: alokasi fisik (bytes).
- `Physical`: ukuran fisik (bytes).

### 4.5. `virsh domblkstat` — Statistik I/O Disk

```bash
virsh domblkstat arch-vm vda
```

**Penjelasan:**
- `virsh domblkstat`: statistik blok.
- `arch-vm`: nama domain.
- `vda`: target disk.

**Output:**
```
vda rd_req 1234
vda rd_bytes 12345678
vda rd_total_times 123456789
vda wr_req 5678
vda wr_bytes 87654321
vda wr_total_times 987654321
vda flush_req 100
vda flush_total_times 1000000
```

**Penjelasan:**
- `rd_req`: jumlah request baca.
- `rd_bytes`: byte dibaca.
- `rd_total_times`: total waktu baca (nanodetik).
- `wr_req`: jumlah request tulis.
- `wr_bytes`: byte ditulis.
- `wr_total_times`: total waktu tulis.
- `flush_req`: jumlah flush.
- `flush_total_times`: total waktu flush.

### 4.6. `virsh domifstat` — Statistik Jaringan

```bash
virsh domifstat arch-vm ens3
virsh domiflist arch-vm
```

**Penjelasan:**
- `virsh domifstat`: statistik interface.
- `arch-vm`: nama domain.
- `ens3`: nama interface di guest.
- `virsh domiflist`: daftar interface.

**Output `virsh domifstat`:**
```
ens3 rx_bytes 1234567
ens3 rx_packets 1234
ens3 rx_errs 0
ens3 rx_drop 0
ens3 tx_bytes 7654321
ens3 tx_packets 4321
ens3 tx_errs 0
ens3 tx_drop 0
```

### 4.7. `virsh dommemstat` — Statistik Memori

```bash
virsh dommemstat arch-vm
virsh dommemstat arch-vm --period 5
virsh dommemstat arch-vm --live
```

**Penjelasan:**
- `virsh dommemstat`: statistik memori.
- `arch-vm`: nama domain.
- `--period 5`: periode 5 detik.
- `--live`: statistik live.

**Output:**
```
actual 2097152
swap_in 0
swap_out 0
major_fault 0
minor_fault 0
unused 0
available 2097152
usable 2097152
```

**Penjelasan:**
- `actual`: memori aktual (KiB).
- `swap_in`/`swap_out`: swap.
- `major_fault`/`minor_fault`: page faults.
- `unused`: memori tidak terpakai.
- `available`: memori tersedia.
- `usable`: memori yang bisa digunakan.

### 4.8. `virsh vcpuinfo` — Info vCPU

```bash
virsh vcpuinfo arch-vm
virsh vcpuinfo arch-vm --pretty
```

**Penjelasan:**
- `virsh vcpuinfo`: info vCPU.
- `arch-vm`: nama domain.
- `--pretty`: format rapi.

**Output:**
```
VCPU:           0
CPU:            0
State:          running
CPU time:       617.3s
CPU Affinity:   yyyyyyyy

VCPU:           1
CPU:            1
State:          running
CPU time:       617.3s
CPU Affinity:   yyyyyyyy
```

**Penjelasan:**
- `VCPU`: nomor vCPU.
- `CPU`: CPU fisik tempat vCPU berjalan.
- `State`: state vCPU.
- `CPU time`: waktu CPU.
- `CPU Affinity`: afinitas CPU.

### 4.9. `virsh cpu-stats` — Statistik CPU

```bash
virsh cpu-stats arch-vm
virsh cpu-stats arch-vm --total
virsh cpu-stats arch-vm --start 0 --count 2
```

**Penjelasan:**
- `virsh cpu-stats`: statistik CPU.
- `--total`: total saja.
- `--start 0 --count 2`: mulai dari vCPU 0, sebanyak 2.

**Output:**
```
CPU0:
        cpu_time            617.3s
CPU1:
        cpu_time            617.3s
Total:
        cpu_time            1234.6s
        user_time           1000.0s
        system_time         234.6s
```

### 4.10. `virt-top` — Alat Interaktif

```bash
virt-top
virt-top -d 2
virt-top -o cpu
virt-top -o mem
virt-top -o time
virt-top -o net
virt-top -o block
```

**Penjelasan kata demi kata:**
- `virt-top`: alat interaktif.
- `-d 2`: delay 2 detik.
- `-o cpu`: urutkan berdasarkan CPU.
- `-o mem`: urutkan berdasarkan memori.
- `-o time`: urutkan berdasarkan waktu.
- `-o net`: urutkan berdasarkan jaringan.
- `-o block`: urutkan berdasarkan blok.

**Output:**
```
virt-top 10:23:45 x86_64 2 CPU, 4096 MHz, 16384 MB
1 domains, 1 active, 1 running, 0 sleeping, 0 paused, 0 inactive
Mem: 16384 MB total, 12288 MB used, 4096 MB free
CPU: 25.0% used, 75.0% idle

  ID S RDRQ WRRQ RXBY TXBY %CPU %MEM TIME NAME
   1 r   10   20  1MB  2MB  5.0  12.5 1234 arch-vm
```

**Penjelasan kolom:**
- `ID`: ID domain.
- `S`: state (`r` = running).
- `RDRQ`: read request.
- `WRRQ`: write request.
- `RXBY`: RX bytes.
- `TXBY`: TX bytes.
- `%CPU`: penggunaan CPU.
- `%MEM`: penggunaan memori.
- `TIME`: waktu CPU.
- `NAME`: nama domain.

**Tombol interaktif:**
- `q`: keluar.
- `h`: help.
- `1`: tampilkan per-vCPU.
- `d`: ubah delay.
- `s`: ubah sort.

### 4.11. `virsh domstats --perf` — Perf Events

```bash
virsh domstats arch-vm --perf
```

**Output:**
```
Domain: 'arch-vm'
  perf.cmt=0
  perf.mbmlt=0
  perf.cache_misses=12345
  perf.cache_references=67890
  perf.instructions=1234567
  perf.cpu_cycles=2345678
  perf.branch_instructions=3456789
  perf.branch_misses=4567890
  perf.bus_cycles=5678901
  perf.stalled_cycles_frontend=6789012
  perf.stalled_cycles_backend=7890123
  perf.ref_cpu_cycles=8901234
  perf.cpu_clock=9012345
  perf.task_clock=123456
  perf.context_switches=234567
  perf.cpu_migrations=345678
  perf.page_faults=456789
  perf.page_faults_min=567890
  perf.page_faults_maj=678901
  perf.alignment_faults=789012
  perf.emulation_faults=890123
```

**Penjelasan:** Perf events memberikan insight tingkat rendah: cache misses, branch misses, stalled cycles.

### 4.12. Tracing dengan `perf kvm`

```bash
sudo perf kvm stat live
sudo perf kvm stat record
sudo perf kvm top
```

**Penjelasan kata demi kata:**
- `perf kvm`: perf untuk KVM.
- `stat live`: statistik live.
- `stat record`: rekam statistik.
- `top`: live profiling.

**Output `perf kvm stat live`:**
```
Analyze events for all VMs, all VCPUs:

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time

                 MSR_WR        1234    25.00%    10.00%      1.23us     10.00us      2.34us
                 EPT_VIOLATION  5678    50.00%    40.00%      2.34us     20.00us      4.56us
                 IO_INSTRUCTION  789    10.00%     5.00%      1.00us      5.00us      2.00us
```

**Penjelasan:** Menunjukkan penyebab VM exit. Berguna untuk mendeteksi bottleneck.

### 4.13. Tracing dengan `ftrace`

```bash
sudo mount -t tracefs nodev /sys/kernel/tracing
cd /sys/kernel/tracing
echo 1 > events/kvm/enable
cat trace_pipe
```

**Penjelasan:**
- `tracefs`: filesystem untuk tracing.
- `events/kvm/enable`: aktifkan event KVM.
- `trace_pipe`: baca trace.

### 4.14. Tracing QEMU

```bash
qemu-system-x86_64 ... -trace events=/tmp/trace-events
```

File `/tmp/trace-events`:
```
enable=*
enable=kvm_*
enable=virtio_*
```

### 4.15. Log Libvirt

```bash
journalctl -u virtqemud
journalctl -u virtqemud -f
journalctl -u virtqemud --since "1 hour ago"
```

**Penjelasan:**
- `journalctl -u virtqemud`: log daemon libvirt.
- `-f`: follow.
- `--since`: filter waktu.

### 4.16. Log QEMU

```bash
tail -f /var/log/libvirt/qemu/arch-vm.log
```

**Penjelasan:**
- Log QEMU untuk domain.
- Berisi output QEMU: error, warning, info.

### 4.17. Log Guest via QGA

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-info"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-network-get-interfaces"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-get-fsinfo"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-get-memory-block-info"}'
```

**Penjelasan:**
- `virsh qemu-agent-command`: kirim perintah ke QGA.
- `guest-info`: info agen.
- `guest-network-get-interfaces`: info jaringan.
- `guest-get-fsinfo`: info filesystem.
- `guest-get-memory-block-info`: info memori.

**Output `guest-info`:**
```json
{
  "return": {
    "version": "7.2.0",
    "supported_commands": [...]
  }
}
```

### 4.18. Skrip Monitoring Sederhana

```bash
#!/bin/bash
VM="arch-vm"
INTERVAL=5

while true; do
  clear
  echo "=== $(date) ==="
  virsh domstats "$VM" --state --cpu-total --balloon --vcpu --interface --block | grep -E 'state|cpu\.|balloon\.|vcpu\.|net\.|block\.'
  sleep "$INTERVAL"
done
```

**Penjelasan:**
- Loop tak terbatas.
- Setiap 5 detik, ambil statistik.
- Tampilkan dengan `grep`.

### 4.19. Integrasi dengan Prometheus

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'libvirt'
    static_configs:
      - targets: ['localhost:9177']
```

Jalankan `libvirt_exporter`:
```bash
libvirt_exporter --libvirt.uri=qemu:///system --web.listen-address=:9177
```

**Penjelasan:**
- `libvirt_exporter`: exporter Prometheus untuk libvirt.
- `--libvirt.uri`: URI libvirt.
- `--web.listen-address`: alamat listen.

### 4.20. Integrasi dengan Grafana

Setelah Prometheus mengumpulkan metrik, Grafana bisa memvisualisasikan dengan dashboard libvirt.

### 4.21. `sar` dan `iostat` untuk Host

```bash
sar -u 1 10
iostat -x 1 10
vmstat 1 10
mpstat -P ALL 1 10
pidstat -p $(cat /var/run/libvirt/qemu/arch-vm.pid) 1 10
```

**Penjelasan:**
- `sar -u`: statistik CPU host.
- `iostat -x`: statistik I/O host.
- `vmstat`: statistik memori host.
- `mpstat -P ALL`: statistik per-CPU.
- `pidstat -p <pid>`: statistik proses QEMU.

### 4.22. `vhostmd` untuk Guest

`vhostmd` adalah daemon yang menyediakan metrik host ke guest. Guest bisa membaca `/dev/vhostmd` atau `vm-dump-metrics`.

```bash
sudo systemctl start vhostmd
sudo systemctl enable vhostmd
```

Di guest:
```bash
vm-dump-metrics
```

**Output:**
```
<metrics>
  <metric type="string" context="host">
    <name>hostname</name>
    <value>host1</value>
  </metric>
  <metric type="int64" context="host">
    <name>cpu_usage</name>
    <value>25</value>
  </metric>
</metrics>
```

---

## 5. Diagram Arsitektur Monitoring & Alur Data Statistik

### 5.1. Arsitektur Monitoring

```
+-------------------------------------------------------------+
|                        Guest                                |
|  +-------------------+  +-------------------+               |
|  |   QGA             |  |   Aplikasi        |               |
|  |   (agent)         |  |   (proses)        |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        QEMU                                 |
|  +-------------------+  +-------------------+               |
|  |   Statistik       |  |   QMP             |               |
|  |   (runtime)       |  |   (QGA channel)   |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        libvirt                              |
|  +-------------------+  +-------------------+               |
|  |   domstats        |  |   API             |               |
|  |   (metrics)       |  |   (observability) |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        Alat Monitoring                      |
|  +-------------------+  +-------------------+               |
|  |   virsh           |  |   virt-top        |               |
|  |   (CLI)           |  |   (interaktif)    |               |
|  +-------------------+  +-------------------+               |
|  +-------------------+  +-------------------+               |
|  |   Prometheus      |  |   Grafana         |               |
|  |   (metrics)       |  |   (visualisasi)   |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
```

### 5.2. Alur Statistik

```
+-------------------+
|  Aplikasi Guest   |
+-------------------+
          |
          v
+-------------------+
|  Kernel Guest     |
+-------------------+
          |
          v
+-------------------+
|  QEMU             |
|  (statistik)      |
+-------------------+
          |
          v
+-------------------+
|  libvirt          |
|  (domstats)       |
+-------------------+
          |
          v
+-------------------+
|  virsh / API      |
+-------------------+
          |
          v
+-------------------+
|  Alat Monitoring  |
+-------------------+
```

### 5.3. Tiga Pilar Observability

```
+-------------------+
|   Metrics         |
|   (domstats)      |
+-------------------+
          |
          v
+-------------------+
|   Logs            |
|   (journalctl,    |
|    log QEMU)      |
+-------------------+
          |
          v
+-------------------+
|   Traces          |
|   (perf, ftrace)  |
+-------------------+
          |
          v
+-------------------+
|   Observability   |
|   Lengkap         |
+-------------------+
```

### 5.4. Alur Perf KVM

```
+-------------------+
|  VM Exit          |
+-------------------+
          |
          v
+-------------------+
|  perf kvm         |
|  (record)         |
+-------------------+
          |
          v
+-------------------+
|  Analisis         |
|  (stat, top)      |
+-------------------+
          |
          v
+-------------------+
|  Identifikasi     |
|  Bottleneck       |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan `domstats`, `virt-top`, `domblkinfo`, `domifstat`, `dommemstat`, `vcpupin`, Tracing

Kurikulum asli menyebut:
```bash
virt-top
virsh domstats arch-vm
Validasi: Melihat metrik CPU, memori, I/O.
```

Saya menambahkan:

1. **`virsh dominfo`** — info statis domain.
2. **`virsh domstats`** dengan semua grup: state, cpu-total, balloon, vcpu, interface, block, perf, iothread, memory, dirtyrate.
3. **`virsh domblkinfo`** — info disk (capacity, allocation, physical).
4. **`virsh domblkstat`** — statistik I/O disk (rd_req, wr_req, flush).
5. **`virsh domifstat`** — statistik jaringan (rx_bytes, tx_bytes, errs, drop).
6. **`virsh dommemstat`** — statistik memori (actual, swap, faults).
7. **`virsh vcpuinfo`** — info vCPU (CPU, state, time, affinity).
8. **`virsh cpu-stats`** — statistik CPU (total, per-vCPU).
9. **`virsh domstats --perf`** — perf events (cache misses, branch misses, stalled cycles).
10. **`perf kvm stat live`** — analisis VM exit live.
11. **`perf kvm stat record`** — rekam statistik.
12. **`perf kvm top`** — live profiling.
13. **`ftrace`** — kernel tracing (events/kvm).
14. **`qemu-trace`** — trace event QEMU.
15. **`journalctl -u virtqemud`** — log libvirt.
16. **`/var/log/libvirt/qemu/<name>.log`** — log QEMU.
17. **`virsh qemu-agent-command`** — QGA command.
18. **`vhostmd`** — daemon monitoring untuk guest.
19. **`vm-dump-metrics`** — dump metrik di guest.
20. **Prometheus + `libvirt_exporter`** — integrasi monitoring.
21. **Grafana** — visualisasi.
22. **`sar`, `iostat`, `vmstat`, `mpstat`, `pidstat`** — alat host.
23. **Skrip monitoring** — loop Bash untuk statistik.
24. **`virsh domstats --raw`** — output mentah.
25. **`virsh domstats --all`** — semua domain.
26. **`virsh domstats --list-active`** — domain aktif.
27. **JSON output** — `jq` untuk parsing.
28. **`virsh domstats --dirtyrate`** — dirty rate (untuk migrasi).
29. **`virsh domstats --iothread`** — statistik iothread.
30. **`virsh domstats --memory`** — statistik memori detail.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.5, dengan lab tambahan untuk `domstats` JSON, `perf kvm`, dan integrasi Prometheus.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.1 (`virt-install`):** VM dibuat. Monitoring untuk memastikan berjalan.
- **Modul 3.2 (XML):** XML mendefinisikan perangkat yang akan dimonitor.
- **Modul 3.3 (Lifecycle):** Monitoring berjalan saat VM running.
- **Modul 3.4 (Storage):** `domblkinfo` dan `domblkstat` untuk monitoring storage.
- **Modul 3.6 (Konsol):** Konsol untuk debugging interaktif.
- **Modul 3.7 (Backup XML):** Monitoring untuk memastikan VM idle sebelum backup.
- **Fase 4 (Storage & Backup):** Monitoring I/O untuk snapshot.
- **Fase 5 (Networking):** `domifstat` untuk monitoring jaringan.
- **Fase 6 (Keamanan):** Deteksi anomali.
- **Fase 7 (Otomasi):** Trigger berdasarkan metrik.
- **Fase 8 (Expert):** Observability tingkat lanjut, tracing, profiling.

---

## 8. Referensi Lengkap

- **virsh man page** — https://libvirt.org/manpages/virsh.html
- **libvirt domstats** — https://libvirt.org/manpages/virsh.html#domstats
- **libvirt dominfo** — https://libvirt.org/manpages/virsh.html#dominfo
- **libvirt domblkinfo** — https://libvirt.org/manpages/virsh.html#domblkinfo
- **libvirt domblkstat** — https://libvirt.org/manpages/virsh.html#domblkstat
- **libvirt domifstat** — https://libvirt.org/manpages/virsh.html#domifstat
- **libvirt dommemstat** — https://libvirt.org/manpages/virsh.html#dommemstat
- **libvirt vcpuinfo** — https://libvirt.org/manpages/virsh.html#vcpuinfo
- **libvirt cpu-stats** — https://libvirt.org/manpages/virsh.html#cpu-stats
- **libvirt qemu-agent-command** — https://libvirt.org/manpages/virsh.html#qemu-agent-command
- **libvirt API** — https://libvirt.org/html/libvirt-libvirt-domain.html
- **libvirt Monitoring** — https://libvirt.org/formatdomain.html#monitoring
- **virt-top** — https://people.redhat.com/~rjones/virt-top/
- **perf kvm** — https://www.linux-kvm.org/page/Perf_events
- **ftrace** — https://www.kernel.org/doc/html/latest/trace/ftrace.html
- **QEMU trace** — https://www.qemu.org/docs/master/devel/tracing.html
- **vhostmd** — https://github.com/vhostmd/vhostmd
- **libvirt_exporter** — https://github.com/kumina/libvirt_exporter
- **Prometheus** — https://prometheus.io/docs/
- **Grafana** — https://grafana.com/docs/
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt
- **Arch Wiki: Performance** — https://wiki.archlinux.org/title/Improving_performance

---

## 9. Tips & Praktik Terbaik

1. **Gunakan `domstats` untuk otomasi.** Output terstruktur, mudah di-parse.
2. **Gunakan `virt-top` untuk eksplorasi cepat.**
3. **Gunakan `--human` untuk output yang mudah dibaca.**
4. **Gunakan `--raw` untuk scripting.**
5. **Gunakan JSON output dengan `jq`** untuk parsing.
6. **Monitor per-vCPU** untuk mendeteksi imbalance.
7. **Monitor `vcpu.N.wait`** untuk mendeteksi contention.
8. **Monitor `block.N.rd.times`** untuk mendeteksi I/O bottleneck.
9. **Monitor `net.N.rx.errs` dan `tx.errs`** untuk mendeteksi network error.
10. **Monitor `balloon.unused`** untuk mendeteksi overcommit.
11. **Gunakan `perf kvm stat live`** untuk mendeteksi VM exit.
12. **Gunakan `ftrace`** untuk tracing kernel.
13. **Gunakan `qemu-trace`** untuk tracing QEMU.
14. **Gunakan `journalctl -u virtqemud`** untuk log libvirt.
15. **Gunakan `/var/log/libvirt/qemu/<name>.log`** untuk log QEMU.
16. **Gunakan QGA** untuk view guest.
17. **Gunakan `vhostmd`** untuk metrik host di guest.
18. **Integrasikan dengan Prometheus** untuk monitoring historis.
19. **Integrasikan dengan Grafana** untuk visualisasi.
20. **Gunakan `sar`, `iostat`, `vmstat`** untuk host.
21. **Gunakan `pidstat`** untuk proses QEMU.
22. **Simpan log** untuk audit.
23. **Set baseline** untuk deteksi anomali.
24. **Alert** pada threshold.
25. **Automate** dengan skrip dan cron.
26. **Gunakan `domstats --all`** untuk semua VM.
27. **Gunakan `domstats --list-active`** untuk VM aktif.
28. **Gunakan `domstats --dirtyrate`** untuk migrasi.
29. **Gunakan `domstats --iothread`** untuk tuning.
30. **Selalu validasi** dengan data dari guest.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `domstats` kosong | VM tidak running. | Start VM. |
| `domstats` error | Domain tidak ditemukan. | Cek nama domain. |
| `domblkinfo` error | Target disk salah. | Cek `domblklist`. |
| `domifstat` error | Interface salah. | Cek `domiflist`. |
| `dommemstat` kosong | Balloon tidak aktif. | Tambahkan `<memballoon>`. |
| `vcpuinfo` error | Domain tidak running. | Start VM. |
| `cpu-stats` error | Domain tidak running. | Start VM. |
| `virt-top` error | libvirt tidak berjalan. | Start libvirt. |
| `perf kvm` error | Permission. | Jalankan dengan `sudo`. |
| `perf kvm` kosong | Tidak ada VM exit. | Normal jika idle. |
| `ftrace` error | Tracefs tidak di-mount. | `mount -t tracefs`. |
| `qemu-agent-command` error | QGA tidak berjalan. | Instal dan jalankan QGA di guest. |
| `qemu-agent-command` timeout | Guest hang. | Cek VM. |
| Log QEMU kosong | VM tidak menghasilkan log. | Normal jika tidak ada error. |
| Log libvirt besar | Banyak event. | Rotasi log. |
| `vhostmd` error | Tidak terinstal. | Instal `vhostmd`. |
| Prometheus tidak scrape | Exporter tidak berjalan. | Jalankan exporter. |
| Grafana tidak menampilkan | Datasource salah. | Cek datasource. |
| `sar` error | Paket `sysstat` tidak terinstal. | Instal `sysstat`. |
| `iostat` error | Paket tidak terinstal. | Instal `sysstat`. |
| `pidstat` error | PID QEMU salah. | Cek PID dengan `virsh domid`. |
| Statistik tidak akurat | Cache. | Refresh, tunggu interval. |
| Per-vCPU imbalance | Aplikasi single-threaded. | Pin vCPU, optimasi. |
| I/O bottleneck | Disk lambat. | Upgrade storage, gunakan cache. |
| Network bottleneck | Jaringan lambat. | Upgrade NIC, gunakan vhost. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh dominfo arch-vm` menampilkan info domain.
- `virsh domstats arch-vm` menampilkan statistik.
- `virsh domstats arch-vm --state --cpu-total --balloon --vcpu` menampilkan subset.
- `virsh domblkinfo arch-vm vda` menampilkan info disk.
- `virsh domblkstat arch-vm vda` menampilkan statistik I/O.
- `virsh domifstat arch-vm ens3` menampilkan statistik jaringan.
- `virsh dommemstat arch-vm` menampilkan statistik memori.
- `virsh vcpuinfo arch-vm` menampilkan info vCPU.
- `virsh cpu-stats arch-vm` menampilkan statistik CPU.
- `virt-top` berjalan dan menampilkan VM.
- `virsh domstats arch-vm --perf` menampilkan perf events.
- `sudo perf kvm stat live` menampilkan VM exit.
- `journalctl -u virtqemud` menampilkan log.
- `/var/log/libvirt/qemu/arch-vm.log` ada.
- `virsh qemu-agent-command arch-vm '{"execute":"guest-info"}'` berhasil.

**Troubleshooting:**
- Jika `domstats` kosong: cek `virsh list`.
- Jika `domblkinfo` error: cek `domblklist`.
- Jika `domifstat` error: cek `domiflist`.
- Jika `dommemstat` kosong: cek `<memballoon>` di XML.
- Jika `perf kvm` error: jalankan dengan `sudo`.
- Jika `ftrace` error: mount tracefs.
- Jika QGA error: cek QGA di guest.
- Jika log tidak ada: cek permission, cek path.
- Jika `virt-top` error: cek libvirt, cek terminal.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk tracing: `perf`, `ftrace`, `qemu-trace`.
- Untuk log: `journalctl`, `/var/log/libvirt/`.
- Untuk host: `sar`, `iostat`, `vmstat`, `mpstat`, `pidstat`.
- Untuk integrasi: Prometheus, Grafana, Telegraf.

---

## 12. Latihan Mandiri

1. Jalankan `virsh dominfo arch-vm`. Catat CPU time, memori.
2. Jalankan `virsh domstats arch-vm`. Identifikasi setiap grup.
3. Jalankan `virsh domstats arch-vm --state --cpu-total --balloon --vcpu --interface --block`. Simpan output.
4. Jalankan `virsh domstats arch-vm` dengan output JSON. Parse dengan `jq`.
5. Jalankan `virsh domblkinfo arch-vm vda --human`. Catat capacity, allocation.
6. Jalankan `virsh domblkstat arch-vm vda`. Catat rd_req, wr_req.
7. Jalankan `virsh domifstat arch-vm ens3`. Catat rx_bytes, tx_bytes.
8. Jalankan `virsh dommemstat arch-vm`. Catat actual, available.
9. Jalankan `virsh vcpuinfo arch-vm`. Catat CPU time per vCPU.
10. Jalankan `virsh cpu-stats arch-vm --total`. Catat total.
11. Jalankan `virt-top`. Amati metrik live. Tekan `1` untuk per-vCPU.
12. Jalankan `virsh domstats arch-vm --perf`. Catat cache_misses, branch_misses.
13. Jalankan `sudo perf kvm stat live` saat VM sibuk. Catat VM exit.
14. Jalankan `journalctl -u virtqemud -f` di terminal lain. Amati log.
15. `tail -f /var/log/libvirt/qemu/arch-vm.log`. Amati log QEMU.
16. Jalankan `virsh qemu-agent-command arch-vm '{"execute":"guest-info"}'`. Catat versi QGA.
17. Instal `vhostmd` di host, jalankan di guest, dump metrik.
18. Integrasikan dengan Prometheus: jalankan `libvirt_exporter`, scrape.
19. Buat skrip Bash monitoring loop.
20. Tulis ringkasan: kapan menggunakan `domstats` vs `virt-top`, kapan `perf` vs `ftrace`, dan bagaimana monitoring berhubungan dengan otomasi.

---

## 13. Penutup Modul 3.5

Anda kini menguasai **Monitoring & Diagnostik** — mata dan telinga virtualisasi. Anda bisa membaca statistik runtime, melacak penggunaan CPU/memori/I/O, men-diagnosis masalah, dan mengintegrasikan dengan sistem monitoring eksternal. Anda memahami tiga pilar observability: metrics, logs, traces. Ini adalah fondasi untuk **Modul 3.6 — Konsol, Serial, dan Akses Headless**, di mana Anda akan belajar mengakses VM secara interaktif tanpa GUI.

---

## Motivasi Berenergi

Monitoring bukan tentang **melihat** — ia tentang **memahami**. Setiap angka dalam `domstats` adalah cerita; setiap VM exit dalam `perf kvm` adalah petunjuk; setiap baris log adalah jejak. Dengan menguasai monitoring, Anda bukan lagi operator yang bereaksi; Anda adalah **detektif** yang mengantisipasi. Teruslah berevolusi, karena di balik setiap metrik ada seorang insinyur yang memahami bahwa **yang tak terukur tak terkelola**. Selamat belajar, dan jangan pernah berhenti mengamati!

---

## Motivasi Awal

Selamat! Anda kini memiliki **mata dan telinga** untuk mengamati VM. Namun, observasi pasif tidak cukup — terkadang Anda harus **masuk ke dalam** VM, berbicara langsung dengan sistem di dalamnya, dan mengendalikannya tanpa GUI. Di Modul 3.6 ini, Anda akan mempelajari **Konsol, Serial, dan Akses Headless** — seni berkomunikasi dengan VM melalui terminal. Inilah yang membedakan **operator jarak jauh** dari **pengguna lokal**. Anda akan belajar bagaimana terhubung ke VM yang tidak memiliki layar, bagaimana mengirim perintah melalui konsol serial, dan bagaimana mengakses VM seolah-olah Anda duduk di depannya. Tetap fokus, karena di sini Anda akan menjadi **jembatan** antara dunia host dan dunia guest.

---

## Mini-Daftar Isi Modul 3.6

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Konsol & Arsitektur Serial
6. Audit Kurikulum: Tambahan `virsh console`, `virsh ttyconsole`, `virsh serial`, `virsh screenshot`, `virt-viewer`, QGA Exec, SPICE, VNC Headless
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Konsol, Serial, dan Akses Headless** adalah kumpulan teknik dan alat untuk **berinteraksi dengan VM tanpa antarmuka grafis**. Ini mencakup:
- **Konsol serial (`virsh console`)** — koneksi ke port serial guest, biasanya `ttyS0`.
- **TTY console (`virsh ttyconsole`)** — koneksi ke pseudo-terminal QEMU.
- **Serial console via socket** — untuk akses dari skrip.
- **QEMU Guest Agent (QGA)** — eksekusi perintah di guest via QMP.
- **`virsh screenshot`** — ambil screenshot VM (untuk headless dengan display).
- **VNC/SPICE headless** — grafis tanpa X11 di host.
- **`virt-viewer`/`virt-manager --connect`** — viewer grafis (opsional).
- **QGA `guest-exec`** — eksekusi perintah di guest.
- **QGA `guest-file-*`** — baca/tulis file di guest.
- **QGA `guest-shutdown`** — shutdown via agent.

**Peran dalam kurikulum:** Modul ini adalah **jembatan akses**. Setelah Anda bisa membuat (3.1), mengonfigurasi (3.2), menjalankan (3.3), menyimpan (3.4), dan memonitor (3.5) VM, Anda harus bisa **berinteraksi** dengannya. Ini adalah prasyarat untuk:
- **Fase 4 (Backup):** Freeze filesystem via QGA sebelum snapshot.
- **Fase 5 (Networking):** Debug jaringan dari dalam guest.
- **Fase 6 (Keamanan):** Audit guest via QGA.
- **Fase 7 (Otomasi):** Eksekusi perintah di guest via QGA.
- **Fase 8 (Expert):** Akses ke VM tanpa jaringan.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Headless = Tanpa GUI, Bukan Tanpa Akses

**Headless** berarti host tidak memiliki GUI (X11, Wayland). Namun, VM tetap memerlukan **cara akses**:
- **Serial console** — akses teks via `ttyS0`.
- **VNC/SPICE** — akses grafis via protokol jaringan.
- **QGA** — akses programatik via QMP.
- **SSH** — akses jaringan (jika guest punya IP).

**Filosofi:** Headless bukan berarti "tanpa interaksi", melainkan "interaksi tanpa layar fisik".

### 2.2. Serial Console: Jalur Utama Headless

**Serial console** adalah jalur komunikasi teks antara host dan guest melalui port serial virtual. Di Linux, port serial pertama adalah `ttyS0`. Dengan mengonfigurasi kernel guest untuk mengirim output ke `ttyS0`, Anda bisa melihat boot log dan login prompt melalui `virsh console`.

**Mengapa serial?**
- Tidak memerlukan grafis.
- Bekerja di lingkungan TUI murni.
- Bisa di-script dan di-log.
- Bekerja bahkan saat jaringan mati.

**Filosofi:** Serial adalah **jalur penyelamat**. Ketika semua gagal, serial tetap ada.

### 2.3. Konfigurasi Guest untuk Serial Console

Agar serial console berfungsi, guest harus:
1. Memiliki driver serial (`8250`, `serial_core`).
2. Mengaktifkan console di kernel cmdline: `console=ttyS0,115200n8`.
3. Menjalankan getty di `ttyS0` (untuk login prompt).
4. Memiliki `/etc/securetty` yang mengizinkan `ttyS0` (untuk root login).

**Filosofi:** Serial console adalah **kontrak** antara host dan guest. Keduanya harus "sepakat" untuk berkomunikasi.

### 2.4. QEMU Guest Agent (QGA): Akses Programatik

QGA adalah **daemon** yang berjalan di guest dan berkomunikasi dengan QEMU via **virtio-serial**. QGA memungkinkan host untuk:
- Menjalankan perintah (`guest-exec`).
- Membaca/menulis file (`guest-file-read`, `guest-file-write`).
- Shutdown/reboot (`guest-shutdown`).
- Freeze filesystem (`guest-fsfreeze-freeze`, `guest-fsfreeze-thaw`).
- Melihat info jaringan (`guest-network-get-interfaces`).
- Melihat info filesystem (`guest-get-fsinfo`).
- Melihat proses (`guest-exec-status`).

**Filosofi:** QGA adalah **mata dan tangan** host di dalam guest. Ia memungkinkan otomasi tingkat tinggi dan integrasi dengan sistem manajemen.

### 2.5. VNC/SPICE: Grafis Tanpa X11

**VNC (Virtual Network Computing)** dan **SPICE (Simple Protocol for Independent Computing Environments)** memungkinkan akses grafis ke VM melalui jaringan. Host tidak perlu X11; klien VNC/SPICE bisa berjalan di mesin lain.

**Filosofi:** Grafis bukan berarti GUI host. VNC/SPICE memisahkan **display** dari **host**.

### 2.6. QGA vs SSH

- **SSH:** Membutuhkan jaringan dan kredensial. Berfungsi di guest yang sudah boot.
- **QGA:** Membutuhkan virtio-serial. Berfungsi bahkan saat jaringan mati.
- **QGA lebih rendah level**, lebih cocok untuk otomasi.
- **SSH lebih tinggi level**, lebih cocok untuk interaksi manusia.

**Filosofi:** Gunakan SSH untuk interaksi manusia; gunakan QGA untuk otomasi dan manajemen.

### 2.7. Console vs Serial vs TTY

- **Console:** Istilah umum untuk antarmuka teks.
- **Serial:** Port serial fisik/virtual (`ttyS0`).
- **TTY:** Terminal virtual (`/dev/pts/N`).

Di libvirt:
- `<serial type='pty'>` — serial port.
- `<console type='pty'>` — console.
- `<channel type='unix'>` — QGA.
- `<graphics type='vnc'>` — VNC.
- `<graphics type='spice'>` — SPICE.

### 2.8. Filosofi Keseluruhan

- **Headless bukan tanpa akses.** Ada banyak jalur: serial, QGA, VNC/SPICE.
- **Serial adalah jalur penyelamat.** Selalu konfigurasi.
- **QGA adalah otomasi.** Gunakan untuk scripting.
- **VNC/SPICE adalah grafis.** Untuk instalasi OS grafis.
- **Setiap jalur memiliki trade-off.** Serial (teks, sederhana), QGA (programatik), VNC (grafis, jaringan).

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **Console** | Antarmuka teks. | `virsh console`. |
| **Serial** | Port serial. | `ttyS0`. |
| **TTY** | Terminal virtual. | `/dev/pts/N`. |
| **PTY** | Pseudo-terminal. | `<serial type='pty'>`. |
| **`virsh console`** | Koneksi ke console serial. | `virsh console arch-vm`. |
| **`virsh ttyconsole`** | Koneksi ke TTY console. | |
| **`virsh serial`** | Lihat serial device. | |
| **`virsh screenshot`** | Screenshot VM. | PPM. |
| **VNC** | Virtual Network Computing. | Port 5900+. |
| **SPICE** | Simple Protocol for Independent Computing. | Port 5900+. |
| **`virt-viewer`** | Viewer grafis. | VNC/SPICE. |
| **`virt-manager`** | Manager grafis. | Opsional. |
| **QGA** | QEMU Guest Agent. | `qemu-ga`. |
| **`guest-exec`** | Eksekusi perintah via QGA. | |
| **`guest-file-read`** | Baca file via QGA. | |
| **`guest-file-write`** | Tulis file via QGA. | |
| **`guest-fsfreeze-freeze`** | Freeze filesystem. | Untuk snapshot konsisten. |
| **`guest-fsfreeze-thaw`** | Thaw filesystem. | Setelah snapshot. |
| **`guest-shutdown`** | Shutdown via QGA. | |
| **`guest-network-get-interfaces`** | Info jaringan. | |
| **`guest-get-fsinfo`** | Info filesystem. | |
| **`guest-info`** | Info QGA. | |
| **`org.qemu.guest_agent.0`** | Nama kanal QGA. | |
| **virtio-serial** | Bus virtio untuk serial. | |
| **`ttyS0`** | Port serial pertama. | |
| **`console=ttyS0`** | Kernel cmdline. | |
| **`115200n8`** | Baud rate serial. | |
| **`/etc/securetty`** | Daftar TTY untuk root. | |
| **`getty`** | Program login. | |
| **`systemd-getty-generator`** | Generator getty. | |
| **`serial-getty@ttyS0`** | Service getty serial. | |
| **`virsh send-key`** | Kirim tombol. | |
| **`virsh send-process-signal`** | Kirim sinyal. | |
| **`virsh qemu-agent-command`** | Kirim QGA command. | |
| **`virsh qemu-monitor-command`** | Kirim QMP command. | |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Konfigurasi XML untuk Serial Console

```xml
<devices>
  <serial type='pty'>
    <target port='0'/>
  </serial>
  <console type='pty'>
    <target type='serial' port='0'/>
  </console>
</devices>
```

**Penjelasan kata demi kata:**
- `<serial type='pty'>`: port serial dengan backend PTY.
  - `type='pty'`: pseudo-terminal. Alternatif: `unix` (socket), `tcp`, `file`, `pipe`.
  - `<target port='0'/>`: nomor port serial. Port 0 = `ttyS0`.
- `<console type='pty'>`: console dengan backend PTY.
  - `<target type='serial' port='0'/>`: hubungkan console ke serial port 0.

**Filosofi:** `<serial>` menyediakan **perangkat** serial. `<console>` menyediakan **antarmuka** untuk mengaksesnya. Keduanya diperlukan.

### 4.2. Menambahkan Serial Console ke XML yang Ada

```bash
virsh edit arch-vm
```

Tambahkan di dalam `<devices>`:

```xml
<serial type='pty'>
  <target port='0'/>
</serial>
<console type='pty'>
  <target type='serial' port='0'/>
</console>
```

Simpan. Restart VM.

### 4.3. Menghubungkan ke Console dengan `virsh console`

```bash
virsh console arch-vm
virsh console arch-vm --force
virsh console arch-vm --safe
```

**Penjelasan kata demi kata:**
- `virsh console`: perintah untuk terhubung ke console serial.
- `arch-vm`: nama domain.
- `--force`: paksa koneksi meskipun console sudah terhubung.
- `--safe`: aman (tidak mengganggu konsol lain).

**Output:**
```
Connected to domain 'arch-vm'
Escape character is ^] (Ctrl + ])
```

**Setelah terhubung:**
- Anda melihat output serial dari guest.
- Tekan `Enter` beberapa kali untuk memunculkan prompt login.
- Untuk keluar, tekan `Ctrl + ]`.

**Peringatan:** `virsh console` hanya bisa terhubung ke **satu** klien pada satu waktu. Jika sudah terhubung, gunakan `--force` untuk mengambil alih.

### 4.4. Konfigurasi Guest untuk Login via Serial

Di guest, pastikan:
1. Kernel cmdline memiliki `console=ttyS0,115200n8`.
2. `/etc/securetty` memiliki `ttyS0`.
3. Getty berjalan di `ttyS0`.

Di Arch Linux:
```bash
sudo systemctl enable serial-getty@ttyS0.service
sudo systemctl start serial-getty@ttyS0.service
```

**Penjelasan kata demi kata:**
- `systemctl enable`: aktifkan service untuk boot.
- `serial-getty@ttyS0.service`: service getty untuk `ttyS0`.
- `systemctl start`: jalankan sekarang.

Cek:
```bash
systemctl status serial-getty@ttyS0.service
```

**Output:**
```
● serial-getty@ttyS0.service - Serial Getty on ttyS0
     Loaded: loaded (/usr/lib/systemd/system/serial-getty@.service; enabled; preset: enabled)
     Active: active (running)
```

### 4.5. Kernel Cmdline untuk Serial

Jika VM di-boot dengan GRUB:
```
linux /vmlinuz-linux root=/dev/vda1 console=ttyS0,115200n8
```

Jika VM di-boot dengan systemd-boot:
```
options root=/dev/vda1 console=ttyS0,115200n8
```

Jika VM di-boot dengan kernel langsung (QEMU):
```bash
qemu-system-x86_64 ... -append "root=/dev/vda1 console=ttyS0,115200n8"
```

**Penjelasan kata demi kata:**
- `console=ttyS0`: arahkan console kernel ke `ttyS0`.
- `115200n8`: baud rate 115200, no parity, 8 data bits.

### 4.6. `virsh ttyconsole` — Lihat Path TTY

```bash
virsh ttyconsole arch-vm
```

**Output:**
```
/dev/pts/3
```

**Penjelasan:**
- `virsh ttyconsole`: lihat path TTY console.
- Output: path ke PTY di host.
- Kegunaan: untuk scripting, mis. `socat` ke PTY.

### 4.7. `virsh serial` — Lihat Info Serial

```bash
virsh serial arch-vm
```

**Output:**
```
/dev/pts/3
```

**Penjelasan:**
- `virsh serial`: lihat info serial device.

### 4.8. Akses Serial via `socat`

```bash
socat - UNIX-CONNECT:/var/lib/libvirt/qemu/arch-vm.serial0
```

Atau via PTY:
```bash
socat - /dev/pts/3
```

**Penjelasan:**
- `socat`: relay.
- `UNIX-CONNECT`: koneksi ke UNIX socket.
- `arch-vm.serial0`: socket serial untuk domain.

**Kegunaan:** Akses serial dari skrip.

### 4.9. Serial ke Socket UNIX

Ubah XML:

```xml
<serial type='unix'>
  <source mode='bind' path='/tmp/arch-vm.serial.sock'/>
  <target port='0'/>
</serial>
```

**Penjelasan:**
- `type='unix'`: gunakan UNIX socket.
- `mode='bind'`: QEMU bind ke socket.
- `path='/tmp/arch-vm.serial.sock'`: path socket.

Restart VM. Akses:
```bash
socat - UNIX-CONNECT:/tmp/arch-vm.serial.sock
```

### 4.10. Serial ke File

```xml
<serial type='file'>
  <source path='/var/log/libvirt/qemu/arch-vm-serial.log'/>
  <target port='0'/>
</serial>
```

**Penjelasan:**
- `type='file'`: tulis output serial ke file.
- `path=...`: path file log.

**Kegunaan:** Log serial untuk audit.

### 4.11. QEMU Guest Agent (QGA) — Konfigurasi

Di XML:

```xml
<devices>
  <channel type='unix'>
    <source mode='bind' path='/var/lib/libvirt/qemu/org.qemu.guest_agent.0'/>
    <target type='virtio' name='org.qemu.guest_agent.0'/>
  </channel>
</devices>
```

**Penjelasan kata demi kata:**
- `<channel type='unix'>`: kanal komunikasi.
- `<source mode='bind' path='...'/>`: socket UNIX.
- `<target type='virtio' name='org.qemu.guest_agent.0'/>`: nama kanal. Guest akan melihat `/dev/virtio-ports/org.qemu.guest_agent.0`.

### 4.12. Menjalankan QGA di Guest

Di guest:
```bash
sudo pacman -S qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

**Penjelasan:**
- `qemu-guest-agent`: paket QGA.
- `systemctl enable --now`: aktifkan dan jalankan.

Cek:
```bash
systemctl status qemu-guest-agent
ls -l /dev/virtio-ports/
```

**Output:**
```
/dev/virtio-ports/org.qemu.guest_agent.0
```

### 4.13. `virsh qemu-agent-command` — Kirim Perintah ke QGA

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-info"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-network-get-interfaces"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-get-fsinfo"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-get-memory-block-info"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-get-osinfo"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-get-time"}'
```

**Penjelasan kata demi kata:**
- `virsh qemu-agent-command`: kirim perintah QGA.
- `arch-vm`: nama domain.
- `{"execute":"guest-info"}`: perintah JSON.

**Output `guest-info`:**
```json
{
  "return": {
    "version": "8.1.0",
    "supported_commands": [
      {"name": "guest-info", "success-response": true},
      {"name": "guest-shutdown", "success-response": false},
      ...
    ]
  }
}
```

**Output `guest-network-get-interfaces`:**
```json
{
  "return": [
    {
      "name": "lo",
      "hardware-address": "00:00:00:00:00:00",
      "ip-addresses": [
        {"ip-address": "127.0.0.1", "ip-address-type": "ipv4", "prefix": 8}
      ]
    },
    {
      "name": "ens3",
      "hardware-address": "52:54:00:12:34:56",
      "ip-addresses": [
        {"ip-address": "192.168.122.10", "ip-address-type": "ipv4", "prefix": 24}
      ]
    }
  ]
}
```

### 4.14. QGA `guest-exec` — Eksekusi Perintah di Guest

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-exec","arguments":{"path":"/bin/ls","arg":["-la","/"],"capture-output":true}}'
```

**Penjelasan kata demi kata:**
- `guest-exec`: eksekusi perintah.
- `path`: path binary.
- `arg`: argumen.
- `capture-output`: tangkap output.

**Output:**
```json
{
  "return": {
    "pid": 1234
  }
}
```

Untuk melihat output, gunakan `guest-exec-status`:
```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-exec-status","arguments":{"pid":1234}}'
```

**Output:**
```json
{
  "return": {
    "exited": true,
    "exitcode": 0,
    "out-data": "dG90YWwgMjAK...",
    "err-data": ""
  }
}
```

**Catatan:** `out-data` dan `err-data` adalah **base64-encoded**. Decode dengan:
```bash
echo "dG90YWwgMjAK..." | base64 -d
```

### 4.15. QGA `guest-shutdown` — Shutdown via QGA

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-shutdown"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-shutdown","arguments":{"mode":"halt"}}'
virsh qemu-agent-command arch-vm '{"execute":"guest-shutdown","arguments":{"mode":"powerdown"}}'
virsh qemu-agent-command arch-vm '{"execute":"guest-shutdown","arguments":{"mode":"reboot"}}'
```

**Penjelasan:**
- `mode: halt`: halt sistem.
- `mode: powerdown`: poweroff.
- `mode: reboot`: reboot.

### 4.16. QGA `guest-fsfreeze-freeze` dan `guest-fsfreeze-thaw`

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-fsfreeze-freeze"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-fsfreeze-status"}'
virsh qemu-agent-command arch-vm '{"execute":"guest-fsfreeze-thaw"}'
```

**Penjelasan:**
- `guest-fsfreeze-freeze`: freeze semua filesystem (untuk snapshot konsisten).
- `guest-fsfreeze-status`: cek status.
- `guest-fsfreeze-thaw`: thaw.

**Kegunaan:** Snapshot konsisten di Fase 4.

### 4.17. QGA `guest-file-read` dan `guest-file-write`

```bash
virsh qemu-agent-command arch-vm '{"execute":"guest-file-open","arguments":{"path":"/etc/hostname","mode":"r"}}'
# Output: {"return": 1000}
virsh qemu-agent-command arch-vm '{"execute":"guest-file-read","arguments":{"handle":1000,"count":1024}}'
virsh qemu-agent-command arch-vm '{"execute":"guest-file-close","arguments":{"handle":1000}}'
```

**Penjelasan:**
- `guest-file-open`: buka file, dapat handle.
- `guest-file-read`: baca file.
- `guest-file-close`: tutup file.

**Output `guest-file-read`:**
```json
{
  "return": {
    "count": 10,
    "buf-b64": "YXJjaC12bQo="
  }
}
```

Decode:
```bash
echo "YXJjaC12bQo=" | base64 -d
# Output: arch-vm
```

### 4.18. `virsh screenshot` — Screenshot VM

```bash
virsh screenshot arch-vm /tmp/screen.ppm
virsh screenshot arch-vm /tmp/screen.ppm --screen 0
```

**Penjelasan kata demi kata:**
- `virsh screenshot`: ambil screenshot.
- `arch-vm`: nama domain.
- `/tmp/screen.ppm`: output file (format PPM).
- `--screen 0`: nomor layar.

**Kegunaan:** Melihat tampilan grafis VM tanpa VNC.

**Konversi PPM ke PNG:**
```bash
convert /tmp/screen.ppm /tmp/screen.png
```

**Catatan:** `virsh screenshot` memerlukan **perangkat display** (VGA, virtio-gpu). Untuk headless murni tanpa display, screenshot tidak berfungsi.

### 4.19. VNC Headless

XML:
```xml
<graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>
  <listen type='address' address='127.0.0.1'/>
</graphics>
```

**Penjelasan kata demi kata:**
- `<graphics type='vnc'>`: grafis VNC.
- `port='-1'`: port otomatis.
- `autoport='yes'`: pilih port otomatis.
- `listen='127.0.0.1'`: listen di localhost.
- `<listen type='address' address='127.0.0.1'/>`: alamat listen.

Cek port:
```bash
virsh domdisplay arch-vm
```

**Output:**
```
vnc://127.0.0.1:5900
```

Akses dari host:
```bash
vncviewer 127.0.0.1:5900
```

Atau dari mesin lain via SSH tunnel:
```bash
ssh -L 5900:127.0.0.1:5900 user@host
vncviewer 127.0.0.1:5900
```

### 4.20. SPICE Headless

XML:
```xml
<graphics type='spice' autoport='yes' listen='127.0.0.1'>
  <listen type='address' address='127.0.0.1'/>
</graphics>
```

**Penjelasan:**
- `<graphics type='spice'>`: grafis SPICE.
- SPICE lebih baik dari VNC untuk VM modern: audio, USB redirection, multiple monitors.

### 4.21. `virt-viewer` — Viewer Grafis

```bash
virt-viewer --connect qemu:///system arch-vm
virt-viewer --connect qemu+ssh://host/system arch-vm
```

**Penjelasan:**
- `virt-viewer`: viewer grafis untuk VNC/SPICE.
- `--connect`: URI libvirt.

**Catatan:** `virt-viewer` memerlukan X11/Wayland di host. Untuk headless murni, gunakan VNC client dari mesin lain.

### 4.22. `virsh send-key` — Kirim Tombol

```bash
virsh send-key arch-vm KEY_LEFTCTRL KEY_LEFTALT KEY_DELETE
virsh send-key arch-vm --codeset linux KEY_A
virsh send-key arch-vm --holdtime 100 KEY_A
```

**Penjelasan kata demi kata:**
- `virsh send-key`: kirim tombol ke VM.
- `KEY_LEFTCTRL`, `KEY_LEFTALT`, `KEY_DELETE`: kode tombol.
- `--codeset linux`: codeset Linux.
- `--holdtime 100`: tahan 100 ms.

**Kegunaan:** Kirim Ctrl+Alt+Del untuk reboot.

### 4.23. `virsh send-process-signal` — Kirim Sinyal

```bash
virsh send-process-signal arch-vm 1234 SIGTERM
```

**Penjelasan:**
- `virsh send-process-signal`: kirim sinyal ke proses di guest.
- `1234`: PID di guest.
- `SIGTERM`: sinyal.

**Catatan:** Memerlukan QGA.

### 4.24. Contoh Skrip QGA

```bash
#!/bin/bash
VM="arch-vm"

qga() {
  virsh qemu-agent-command "$VM" "$1"
}

echo "=== Guest Info ==="
qga '{"execute":"guest-info"}' | jq '.return.version'

echo "=== Network Interfaces ==="
qga '{"execute":"guest-network-get-interfaces"}' | jq '.return[] | {name, ip: .["ip-addresses"]}'

echo "=== Filesystem Info ==="
qga '{"execute":"guest-get-fsinfo"}' | jq '.return[] | {name, mountpoint, type}'

echo "=== OS Info ==="
qga '{"execute":"guest-get-osinfo"}' | jq '.return'
```

**Penjelasan:**
- Fungsi `qga` membungkus `virsh qemu-agent-command`.
- `jq` untuk parsing JSON.
- Menampilkan info guest.

### 4.25. Contoh QGA Exec dengan Output

```bash
#!/bin/bash
VM="arch-vm"

result=$(virsh qemu-agent-command "$VM" '{"execute":"guest-exec","arguments":{"path":"/bin/echo","arg":["hello"],"capture-output":true}}')
pid=$(echo "$result" | jq -r '.return.pid')

sleep 1

status=$(virsh qemu-agent-command "$VM" "{\"execute\":\"guest-exec-status\",\"arguments\":{\"pid\":$pid}}")
out=$(echo "$status" | jq -r '.return["out-data"]')
echo "$out" | base64 -d
```

**Penjelasan:**
- Jalankan `echo hello` di guest.
- Dapatkan PID.
- Tunggu 1 detik.
- Ambil status.
- Decode output base64.

### 4.26. Konfigurasi `console=ttyS0` di GRUB

Di guest, edit `/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"
```

Regenerate:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Penjelasan:**
- `console=tty0`: console utama di VGA.
- `console=ttyS0,115200n8`: console tambahan di serial.
- Output muncul di keduanya.

### 4.27. Konfigurasi `console=ttyS0` di systemd-boot

Edit `/boot/loader/entries/arch.conf`:
```
options root=/dev/vda1 console=ttyS0,115200n8
```

### 4.28. Getty Serial di Guest

```bash
sudo systemctl enable serial-getty@ttyS0.service
sudo systemctl start serial-getty@ttyS0.service
```

Atau, jika menggunakan `systemd-getty-generator`, getty otomatis dibuat jika `console=ttyS0` ada di kernel cmdline.

### 4.29. Login Root via Serial

Pastikan `/etc/securetty` memiliki:
```
ttyS0
```

Jika tidak ada, tambahkan:
```bash
echo "ttyS0" | sudo tee -a /etc/securetty
```

**Peringatan:** Root login via serial kurang aman. Gunakan user biasa.

### 4.30. Contoh Lengkap: Akses Headless ke VM

```bash
# 1. Pastikan XML memiliki serial dan console
virsh dumpxml arch-vm | grep -A2 serial
virsh dumpxml arch-vm | grep -A2 console

# 2. Pastikan QGA berjalan di guest
virsh qemu-agent-command arch-vm '{"execute":"guest-info"}' | jq .

# 3. Koneksi ke console serial
virsh console arch-vm

# 4. Jika console sudah terhubung, gunakan --force
virsh console arch-vm --force

# 5. Keluar: Ctrl + ]
```

---

## 5. Diagram Alur Konsol & Arsitektur Serial

### 5.1. Arsitektur Serial Console

```
+-------------------------------------------------------------+
|                        Guest                                |
|  +-------------------+  +-------------------+               |
|  |   Kernel          |  |   Getty           |               |
|  |   console=ttyS0   |  |   serial-getty    |               |
|  +-------------------+  +-------------------+               |
|           |                       |                         |
|           v                       v                         |
|  +-------------------+  +-------------------+               |
|  |   ttyS0           |  |   /dev/ttyS0      |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        QEMU                                 |
|  +-------------------+  +-------------------+               |
|  |   Serial device   |  |   PTY / socket    |               |
|  |   (ttyS0)         |  |                   |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        libvirt                              |
|  +-------------------+  +-------------------+               |
|  |   <serial>        |  |   <console>       |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        Host                                 |
|  +-------------------+  +-------------------+               |
|  |   virsh console   |  |   socat           |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
```

### 5.2. Alur `virsh console`

```
+-------------------+
|  virsh console    |
+-------------------+
          |
          v
+-------------------+
|  libvirt cari     |
|  console device   |
+-------------------+
          |
          v
+-------------------+
|  Buka PTY /       |
|  socket           |
+-------------------+
          |
          v
+-------------------+
|  Relay stdin/stdout |
|  ke PTY           |
+-------------------+
          |
          v
+-------------------+
|  QEMU serial      |
|  device           |
+-------------------+
          |
          v
+-------------------+
|  Guest ttyS0      |
+-------------------+
```

### 5.3. Arsitektur QGA

```
+-------------------------------------------------------------+
|                        Guest                                |
|  +-------------------+  +-------------------+               |
|  |   qemu-ga         |  |   /dev/virtio-    |               |
|  |   (daemon)        |  |   ports/org.qemu. |               |
|  |                   |  |   guest_agent.0   |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        QEMU                                 |
|  +-------------------+  +-------------------+               |
|  |   virtio-serial   |  |   chardev socket  |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        libvirt                              |
|  +-------------------+  +-------------------+               |
|  |   <channel>       |  |   qemu-agent-     |               |
|  |                   |  |   command         |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        Host                                 |
|  +-------------------+  +-------------------+               |
|  |   virsh qemu-     |  |   Skrip           |               |
|  |   agent-command   |  |                   |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
```

### 5.4. Alur QGA Exec

```
+-------------------+
|  Host             |
|  guest-exec       |
+-------------------+
          |
          v
+-------------------+
|  QEMU             |
|  (virtio-serial)  |
+-------------------+
          |
          v
+-------------------+
|  qemu-ga          |
|  (guest)          |
+-------------------+
          |
          v
+-------------------+
|  Fork/exec        |
|  perintah          |
+-------------------+
          |
          v
+-------------------+
|  Capture output   |
+-------------------+
          |
          v
+-------------------+
|  Return PID       |
+-------------------+
          |
          v
+-------------------+
|  guest-exec-      |
|  status           |
+-------------------+
          |
          v
+-------------------+
|  Return output    |
|  (base64)         |
+-------------------+
```

### 5.5. Perbandingan Akses

```
+-------------------+  +-------------------+  +-------------------+
|  Serial Console   |  |  QGA              |  |  VNC/SPICE        |
|  (virsh console)  |  |  (qemu-agent)     |  |  (grafis)         |
+-------------------+  +-------------------+  +-------------------+
|  Teks             |  |  Programatik      |  |  Grafis           |
|  Boot log         |  |  Exec, file, net  |  |  Desktop          |
|  Login prompt     |  |  Otomasi          |  |  Instalasi OS     |
|  Rescue           |  |  Manajemen        |  |  GUI              |
+-------------------+  +-------------------+  +-------------------+
          |                     |                      |
          v                     v                      v
+-------------------+  +-------------------+  +-------------------+
|  PTY / socket     |  |  virtio-serial    |  |  TCP port         |
+-------------------+  +-------------------+  +-------------------+
```

---

## 6. Audit Kurikulum: Tambahan `virsh console`, `virsh ttyconsole`, `virsh serial`, `virsh screenshot`, `virt-viewer`, QGA Exec, SPICE, VNC Headless

Kurikulum asli hanya menyebut:
```bash
--graphics none
--console pty,target_type=serial
virsh console arch-vm
```

Saya menambahkan:

1. **`virsh console`** — koneksi ke serial console.
2. **`virsh console --force`** — paksa koneksi.
3. **`virsh console --safe`** — koneksi aman.
4. **`virsh ttyconsole`** — lihat path TTY.
5. **`virsh serial`** — lihat info serial.
6. **Serial via UNIX socket** — untuk scripting.
7. **Serial via file** — untuk logging.
8. **Serial via TCP** — untuk akses jaringan.
9. **Konfigurasi guest** — `console=ttyS0`, `serial-getty`, `/etc/securetty`.
10. **QGA** — konfigurasi, instalasi, penggunaan.
11. **`virsh qemu-agent-command`** — kirim perintah QGA.
12. **QGA `guest-info`** — info agen.
13. **QGA `guest-network-get-interfaces`** — info jaringan.
14. **QGA `guest-get-fsinfo`** — info filesystem.
15. **QGA `guest-get-osinfo`** — info OS.
16. **QGA `guest-get-time`** — waktu guest.
17. **QGA `guest-exec`** — eksekusi perintah.
18. **QGA `guest-exec-status`** — status eksekusi.
19. **QGA `guest-shutdown`** — shutdown via QGA.
20. **QGA `guest-fsfreeze-freeze`** — freeze filesystem.
21. **QGA `guest-fsfreeze-thaw`** — thaw filesystem.
22. **QGA `guest-file-open`/`read`/`write`/`close`** — akses file.
23. **`virsh screenshot`** — screenshot VM.
24. **VNC headless** — konfigurasi dan akses.
25. **SPICE headless** — konfigurasi dan akses.
26. **`virt-viewer`** — viewer grafis.
27. **`virsh send-key`** — kirim tombol.
28. **`virsh send-process-signal`** — kirim sinyal.
29. **SSH tunnel** — untuk akses VNC/SPICE jarak jauh.
30. **Skrip QGA** — Bash + jq.
31. **Base64 decode** — untuk output QGA.
32. **`virsh domdisplay`** — lihat alamat display.
33. **QGA `guest-set-time`** — set waktu.
34. **QGA `guest-suspend-*`** — suspend via QGA.
35. **QGA `guest-fstrim`** — trim filesystem.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.6, dengan lab tambahan untuk QGA exec, QGA file, dan VNC/SPICE headless.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.1 (`virt-install`):** `--graphics none --console pty,target_type=serial` adalah awal.
- **Modul 3.2 (XML):** `<serial>`, `<console>`, `<channel>`, `<graphics>` didefinisikan di XML.
- **Modul 3.3 (Lifecycle):** Konsol tersedia saat VM running.
- **Modul 3.4 (Storage):** QGA `guest-fsfreeze-freeze` untuk snapshot konsisten.
- **Modul 3.5 (Monitoring):** QGA `guest-network-get-interfaces` untuk info jaringan.
- **Modul 3.7 (Backup XML):** XML adalah yang di-backup, termasuk serial/console/channel.
- **Fase 4 (Backup):** QGA freeze untuk snapshot konsisten.
- **Fase 5 (Networking):** Debug jaringan via konsol.
- **Fase 6 (Keamanan):** Audit guest via QGA.
- **Fase 7 (Otomasi):** QGA exec untuk provisioning.
- **Fase 8 (Expert):** Akses ke VM tanpa jaringan.

---

## 8. Referensi Lengkap

- **virsh man page** — https://libvirt.org/manpages/virsh.html
- **libvirt console** — https://libvirt.org/manpages/virsh.html#console
- **libvirt ttyconsole** — https://libvirt.org/manpages/virsh.html#ttyconsole
- **libvirt serial** — https://libvirt.org/manpages/virsh.html#serial
- **libvirt screenshot** — https://libvirt.org/manpages/virsh.html#screenshot
- **libvirt qemu-agent-command** — https://libvirt.org/manpages/virsh.html#qemu-agent-command
- **libvirt send-key** — https://libvirt.org/manpages/virsh.html#send-key
- **libvirt send-process-signal** — https://libvirt.org/manpages/virsh.html#send-process-signal
- **libvirt domdisplay** — https://libvirt.org/manpages/virsh.html#domdisplay
- **libvirt formatdomain serial** — https://libvirt.org/formatdomain.html#serial-port
- **libvirt formatdomain console** — https://libvirt.org/formatdomain.html#console
- **libvirt formatdomain channel** — https://libvirt.org/formatdomain.html#channel
- **libvirt formatdomain graphics** — https://libvirt.org/formatdomain.html#graphical-framebuffers
- **QEMU Guest Agent** — https://wiki.qemu.org/Features/QAPI/GuestAgent
- **QGA Protocol** — https://www.qemu.org/docs/master/interop/qemu-ga.html
- **QGA Commands** — https://www.qemu.org/docs/master/interop/qemu-ga-ref.html
- **virt-viewer** — https://virt-manager.org/
- **SPICE** — https://www.spice-space.org/
- **VNC** — https://www.realvnc.com/
- **Arch Wiki: QEMU Guest Agent** — https://wiki.archlinux.org/title/QEMU#QEMU_Guest_Agent
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt
- **Arch Wiki: VNC** — https://wiki.archlinux.org/title/VNC
- **Arch Wiki: SPICE** — https://wiki.archlinux.org/title/SPICE

---

## 9. Tips & Praktik Terbaik

1. **Selalu konfigurasi serial console** di setiap VM headless.
2. **Tambahkan `console=ttyS0,115200n8`** di kernel cmdline guest.
3. **Aktifkan `serial-getty@ttyS0`** di guest.
4. **Tambahkan `ttyS0` ke `/etc/securetty`** jika perlu root login.
5. **Gunakan `virsh console --force`** jika console sudah terhubung.
6. **Keluar dari console dengan `Ctrl + ]`**, bukan `Ctrl + C`.
7. **Gunakan serial via UNIX socket** untuk scripting.
8. **Gunakan serial via file** untuk logging boot.
9. **Instal QGA** di setiap VM modern.
10. **Gunakan QGA `guest-exec`** untuk otomasi.
11. **Gunakan QGA `guest-fsfreeze-freeze`** sebelum snapshot.
12. **Gunakan QGA `guest-network-get-interfaces`** untuk info jaringan.
13. **Gunakan QGA `guest-get-fsinfo`** untuk info filesystem.
14. **Gunakan `jq`** untuk parsing output QGA.
15. **Decode base64** untuk output QGA exec.
16. **Gunakan VNC/SPICE** untuk instalasi OS grafis.
17. **Bind VNC/SPICE ke localhost**, akses via SSH tunnel.
18. **Gunakan `virsh domdisplay`** untuk melihat alamat display.
19. **Gunakan `virsh screenshot`** untuk melihat tampilan tanpa VNC.
20. **Gunakan `virsh send-key`** untuk kirim tombol.
21. **Gunakan `virsh send-process-signal`** untuk kirim sinyal.
22. **Batasi akses serial** dengan permission.
23. **Log serial** untuk audit.
24. **Gunakan SSH untuk interaksi manusia**, QGA untuk otomasi.
25. **Uji akses headless** sebelum production.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `virsh console` tidak menampilkan apa-apa | Guest tidak mengarahkan output ke serial. | Tambahkan `console=ttyS0` di kernel cmdline. |
| `virsh console` hang | Console sudah terhubung klien lain. | Gunakan `--force`. |
| `virsh console` error | XML tidak memiliki `<serial>` atau `<console>`. | Tambahkan di XML. |
| Login prompt tidak muncul | Getty tidak berjalan di `ttyS0`. | `systemctl enable serial-getty@ttyS0`. |
| Root login ditolak | `ttyS0` tidak ada di `/etc/securetty`. | Tambahkan `ttyS0`. |
| Boot log tidak muncul di serial | Kernel tidak mengarahkan console ke serial. | Tambahkan `console=ttyS0` di cmdline. |
| QGA tidak terdeteksi | QGA tidak berjalan di guest. | Instal dan jalankan `qemu-guest-agent`. |
| `qemu-agent-command` error | QGA tidak terdeteksi atau kanal salah. | Cek XML `<channel>`, cek `/dev/virtio-ports/`. |
| QGA `guest-exec` gagal | Path binary salah atau permission. | Cek path, cek permission. |
| QGA `guest-exec` timeout | Perintah hang. | Cek `guest-exec-status`. |
| QGA output base64 tidak terbaca | Perlu decode. | `base64 -d`. |
| QGA `guest-file-read` error | Handle salah. | Cek `guest-file-open`. |
| QGA `guest-fsfreeze-freeze` gagal | Filesystem sedang sibuk. | Coba lagi, atau tunggu. |
| `virsh screenshot` error | Tidak ada display. | Tambahkan `<graphics>` atau `<video>`. |
| VNC tidak bisa diakses | Bind ke localhost. | Gunakan SSH tunnel. |
| VNC port tidak diketahui | Autoport. | `virsh domdisplay`. |
| SPICE tidak bisa diakses | Bind ke localhost. | Gunakan SSH tunnel. |
| `virt-viewer` error | X11 tidak tersedia. | Gunakan VNC client dari mesin lain. |
| `virsh send-key` tidak berfungsi | Guest tidak menerima input. | Cek driver keyboard. |
| `virsh send-process-signal` error | QGA tidak berjalan. | Instal QGA. |
| Serial output terpotong | Baud rate salah. | Gunakan `115200n8`. |
| Serial login lambat | Baud rate rendah. | Tingkatkan baud rate. |
| QGA channel tidak muncul | virtio-serial tidak ada. | Tambahkan `<controller type='virtio-serial'/>`. |
| Multiple console conflict | Dua konsol terhubung. | Gunakan `--force`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh console arch-vm` berhasil terhubung.
- Output serial menampilkan boot log dan login prompt.
- `virsh ttyconsole arch-vm` menampilkan path PTY.
- `virsh serial arch-vm` menampilkan info serial.
- `virsh qemu-agent-command arch-vm '{"execute":"guest-info"}'` berhasil.
- `virsh qemu-agent-command arch-vm '{"execute":"guest-network-get-interfaces"}'` berhasil.
- `virsh qemu-agent-command arch-vm '{"execute":"guest-get-fsinfo"}'` berhasil.
- `virsh qemu-agent-command arch-vm '{"execute":"guest-exec","arguments":{"path":"/bin/echo","arg":["hello"],"capture-output":true}}'` berhasil.
- `virsh qemu-agent-command arch-vm '{"execute":"guest-fsfreeze-freeze"}'` berhasil.
- `virsh screenshot arch-vm /tmp/screen.ppm` berhasil (jika ada display).
- `virsh domdisplay arch-vm` menampilkan alamat VNC/SPICE.
- VNC/SPICE bisa diakses via SSH tunnel.
- `virsh send-key arch-vm KEY_LEFTCTRL KEY_LEFTALT KEY_DELETE` berhasil.

**Troubleshooting:**
- Jika serial kosong: cek XML, cek kernel cmdline, cek getty.
- Jika QGA error: cek XML `<channel>`, cek `/dev/virtio-ports/`, cek service QGA.
- Jika QGA exec gagal: cek path, cek permission, cek output.
- Jika QGA file gagal: cek handle, cek path.
- Jika screenshot gagal: cek `<graphics>`, cek `<video>`.
- Jika VNC tidak bisa: cek bind address, cek firewall, gunakan SSH tunnel.
- Jika SPICE tidak bisa: cek bind address, cek firewall.
- Jika `virt-viewer` error: cek X11, gunakan VNC client lain.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk log QEMU: `/var/log/libvirt/qemu/<name>.log`.
- Untuk log libvirt: `journalctl -u virtqemud`.
- Untuk log QGA di guest: `journalctl -u qemu-guest-agent`.
- Untuk test serial: `socat - UNIX-CONNECT:/path/to/socket`.

---

## 12. Latihan Mandiri

1. Lihat XML VM: `virsh dumpxml arch-vm`. Identifikasi `<serial>`, `<console>`, `<channel>`.
2. Jika belum ada, tambahkan `<serial>` dan `<console>` dengan `virsh edit`.
3. Restart VM: `virsh destroy arch-vm && virsh start arch-vm`.
4. Cek `virsh ttyconsole arch-vm`.
5. Koneksi ke console: `virsh console arch-vm`.
6. Tekan `Enter`, lihat login prompt.
7. Keluar: `Ctrl + ]`.
8. Jika console sudah terhubung, gunakan `--force`.
9. Di guest, aktifkan `serial-getty@ttyS0`: `systemctl enable --now serial-getty@ttyS0`.
10. Tambahkan `ttyS0` ke `/etc/securetty`.
11. Install QGA: `pacman -S qemu-guest-agent`.
12. Aktifkan QGA: `systemctl enable --now qemu-guest-agent`.
13. Cek: `ls /dev/virtio-ports/`.
14. Dari host: `virsh qemu-agent-command arch-vm '{"execute":"guest-info"}'`.
15. Ambil info jaringan: `guest-network-get-interfaces`.
16. Ambil info filesystem: `guest-get-fsinfo`.
17. Jalankan perintah: `guest-exec` dengan `/bin/echo`.
18. Ambil output: `guest-exec-status`, decode base64.
19. Freeze filesystem: `guest-fsfreeze-freeze`.
20. Thaw: `guest-fsfreeze-thaw`.
21. Baca file: `guest-file-open`, `guest-file-read`, `guest-file-close`.
22. Tambahkan `<graphics type='vnc'>` di XML. Restart.
23. Cek: `virsh domdisplay arch-vm`.
24. Akses VNC via SSH tunnel.
25. Ambil screenshot: `virsh screenshot arch-vm /tmp/screen.ppm`.
26. Kirim Ctrl+Alt+Del: `virsh send-key arch-vm KEY_LEFTCTRL KEY_LEFTALT KEY_DELETE`.
27. Buat skrip Bash untuk QGA exec.
28. Tulis ringkasan: kapan menggunakan serial vs QGA vs VNC, dan bagaimana masing-masing berhubungan dengan headless.

---

## 13. Penutup Modul 3.6

Anda kini menguasai **Konsol, Serial, dan Akses Headless** — jembatan antara host dan guest. Anda bisa terhubung ke VM tanpa GUI melalui serial console, mengakses guest secara programatik via QGA, dan mengakses grafis via VNC/SPICE. Anda memahami konfigurasi guest untuk serial login, cara menggunakan QGA untuk eksekusi perintah dan manajemen file, serta cara mengambil screenshot dan mengirim tombol. Ini adalah fondasi untuk **Modul 3.7 — Backup & Restore XML**, di mana Anda akan belajar menyimpan dan memulihkan konfigurasi VM.

---

## Motivasi Berenergi

Headless bukan berarti **tanpa akses**; ia berarti **akses yang lebih dalam**. Setiap kali Anda mengetik `virsh console`, Anda sedang menjalin jembatan antara dua dunia. Setiap kali Anda mengirim perintah QGA, Anda sedang memperluas jangkauan Anda ke dalam guest. Dengan menguasai akses headless, Anda bukan lagi terbatas pada layar; Anda adalah **penjelajah** yang bisa masuk ke mana saja, kapan saja, tanpa GUI. Teruslah berevolusi, karena di balik setiap `virsh console` ada seorang operator yang memahami bahwa **akses adalah kekuatan**. Selamat belajar, dan jangan pernah berhenti menjembatani!

---

## Motivasi Awal

Selamat! Anda kini bisa **masuk ke dalam** VM melalui serial, QGA, dan VNC/SPICE. Namun, semua akses itu tidak berarti apa-apa jika **konfigurasi VM hilang** karena lupa di-backup. Di Modul 3.7 ini — modul terakhir Fase 3 — Anda akan mempelajari **Backup & Restore XML**: seni menyimpan "cetak biru" VM Anda agar bisa dibangun ulang kapan saja, di mana saja. XML adalah **nyawa** dari setiap VM; tanpanya, disk qcow2 hanyalah file besar tanpa makna. Anda akan belajar bagaimana mendefinisikan ulang VM dari XML, bagaimana mengelola XML dengan aman, bagaimana mengotomasi backup, dan bagaimana memulihkan VM di host lain. Tetap fokus, karena di sini Anda akan menjadi **penjaga warisan** virtualisasi.

---

## Mini-Daftar Isi Modul 3.7

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Backup & Restore XML
6. Audit Kurikulum: Tambahan Versioning, Checksum, GPG, Git, Otomasi, NVRAM, Pool XML, Network XML
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri
13. Penutup Modul & Fase 3

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Backup & Restore XML** adalah proses **menyimpan**, **memvalidasi**, **mengelola versi**, dan **memulihkan** konfigurasi XML dari domain libvirt, storage pool, dan network. XML adalah **metadata** yang mendefinisikan:
- Perangkat VM (CPU, memori, disk, jaringan, konsol, vTPM).
- Firmware (BIOS, UEFI, loader, NVRAM).
- Keamanan (seclabel, tpm, features).
- Resource tuning (cputune, memtune, numatune).
- Metadata (title, description, custom).

Tanpa XML, Anda hanya memiliki **disk** — tetapi tidak tahu bagaimana cara menyalakannya. XML adalah **resep** yang mengubah file disk menjadi VM yang berjalan.

**Peran dalam kurikulum:** Modul ini adalah **penutup Fase 3** dan **fondasi Fase 4 (Backup Engineering)**. Di Fase 4, Anda akan mem-backup **disk** (qcow2), tetapi tanpa XML, backup disk tidak lengkap. Modul ini memastikan Anda bisa:
- **Backup** XML untuk setiap VM.
- **Restore** VM dari XML di host yang sama atau berbeda.
- **Versioning** XML dengan Git.
- **Enkripsi** XML dengan GPG.
- **Otomasi** backup XML dengan skrip dan systemd.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. XML adalah Sumber Kebenaran

Anda sudah mempelajari di Modul 3.2 bahwa XML adalah **single source of truth**. Di sini, konsep itu diperluas: XML adalah **artefak yang harus dilindungi**. Jika XML hilang, Anda kehilangan:
- Konfigurasi perangkat.
- UUID domain.
- Path disk.
- Konfigurasi jaringan.
- Firmware dan NVRAM.
- Metadata dan tuning.

**Filosofi:** *"Backup XML = backup identitas VM."*

### 2.2. Dua Jenis XML: Aktif dan Inaktif

libvirt menyimpan XML dalam dua bentuk:
- **Aktif (`--inactive`)**: XML yang tersimpan di `/etc/libvirt/qemu/<name>.xml`. Ini yang di-`define`.
- **Live (`--live`)**: XML yang sedang berjalan. Bisa berbeda dari XML inaktif jika ada perubahan runtime.

**`virsh dumpxml`** secara default mengembalikan XML **live** (jika VM running) atau **inaktif** (jika VM shut off). Untuk konsistensi, gunakan **`--inactive`** saat backup.

**Filosofi:** Backup XML **inaktif** untuk reproduksibilitas. Backup XML **live** untuk audit runtime.

### 2.3. XML Bergantung pada Sumber Daya Eksternal

XML **tidak mandiri**. Ia merujuk ke:
- **Disk**: path file qcow2, volume pool, LVM LV, iSCSI target.
- **Network**: nama network libvirt (`default`, `isolated`).
- **Storage Pool**: nama pool.
- **Firmware**: path OVMF (`/usr/share/edk2/x64/OVMF_CODE.fd`).
- **NVRAM**: path file NVRAM.
- **TPM**: state swtpm.
- **QGA**: socket.

**Konsekuensi:** Backup XML **harus disertai** dengan backup:
- Pool XML (`virsh pool-dumpxml`).
- Network XML (`virsh net-dumpxml`).
- NVRAM (`/var/lib/libvirt/qemu/nvram/<name>_VARS.fd`).
- State vTPM (`/var/lib/libvirt/tpm/<name>/`).
- Disk (Fase 4).

**Filosofi:** *"Backup XML tanpa backup resource = backup tidak lengkap."*

### 2.4. Restore XML: Definisi vs Import

Ada dua cara memulihkan XML:
- **`virsh define <file.xml>`**: definisikan domain dari XML. Ini **tidak** menyalin disk; disk harus sudah ada di path yang sama.
- **`virsh create <file.xml>`**: buat domain **transient** (tidak persistent) dari XML. Hilang saat VM shut off.

**Filosofi:** `define` untuk VM **persistent**. `create` untuk VM **sementara**.

### 2.5. UUID dan Nama: Identitas Domain

- **Nama**: identifier manusia. Bisa diubah dengan `virsh domrename`.
- **UUID**: identifier mesin. Permanen. Digunakan untuk migrasi, referensi, dan audit.

Saat restore di host lain:
- Jika UUID sama, libvirt menolak (konflik).
- Solusi: hapus UUID dari XML (libvirt generate baru), atau ubah UUID.
- Untuk migrasi, UUID **harus** dipertahankan.

**Filosofi:** UUID adalah **identitas sejati**. Nama hanya label.

### 2.6. Versioning XML dengan Git

XML adalah **teks** — cocok untuk **version control**. Dengan Git, Anda bisa:
- Melacak perubahan XML dari waktu ke waktu.
- Rollback ke versi sebelumnya.
- Diff antara dua versi.
- Branch untuk eksperimen.

**Filosofi:** *"XML adalah kode. Perlakukan seperti kode."*

### 2.7. Enkripsi XML dengan GPG

XML bisa mengandung **informasi sensitif**:
- Path disk.
- UUID.
- Kredensial iSCSI.
- Kunci TPM (tidak langsung, tetapi referensi).

Enkripsi dengan **GPG** melindungi XML dari akses tidak sah.

**Filosofi:** *"XML adalah dokumen. Lindungi seperti dokumen."*

### 2.8. Filosofi Keseluruhan

- **XML adalah identitas.** Backup XML = backup VM.
- **XML bergantung pada resource.** Backup harus lengkap.
- **XML adalah teks.** Versioning dan enkripsi.
- **XML adalah kontrak.** Restore harus memenuhi kontrak.
- **Otomasi adalah kunci.** Backup manual tidak skalabel.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **XML** | Konfigurasi domain/pool/network. | `<domain>`, `<pool>`, `<network>`. |
| **`virsh dumpxml`** | Ekspor XML domain. | `> file.xml`. |
| **`virsh define`** | Definisikan domain dari XML. | Persistent. |
| **`virsh create`** | Buat domain transient dari XML. | Hilang saat shut off. |
| **`virsh undefine`** | Hapus definisi domain. | `--keep-nvram`. |
| **`virsh domrename`** | Ubah nama domain. | Bisa juga dengan `virsh domrename`. |
| **`virsh edit`** | Edit XML domain. | Validasi otomatis. |
| **`virt-xml-validate`** | Validasi XML. | Terhadap schema. |
| **`virsh pool-dumpxml`** | Ekspor XML pool. | |
| **`virsh pool-define`** | Definisikan pool dari XML. | |
| **`virsh net-dumpxml`** | Ekspor XML network. | |
| **`virsh net-define`** | Definisikan network dari XML. | |
| **NVRAM** | Variabel UEFI. | `/var/lib/libvirt/qemu/nvram/<name>_VARS.fd`. |
| **swtpm state** | State vTPM. | `/var/lib/libvirt/tpm/<name>/`. |
| **UUID** | Identitas unik domain. | |
| **Versioning** | Manajemen versi. | Git. |
| **Checksum** | Verifikasi integritas. | SHA256. |
| **GPG** | Enkripsi dan signature. | `gpg --encrypt`. |
| **Git** | Version control. | `git init`, `git commit`. |
| **Ansible** | Otomasi konfigurasi. | Playbook. |
| **Puppet** | Manajemen konfigurasi. | Manifest. |
| **Chef** | Manajemen konfigurasi. | Recipe. |
| **SaltStack** | Manajemen konfigurasi. | State. |
| **Terraform** | Infrastructure as Code. | Provider libvirt. |
| **`virsh save`** | Save state VM (memori + device). | Bukan XML. |
| **`virsh restore`** | Restore state VM. | |
| **`virsh managedsave`** | Save otomatis. | |
| **`virsh backup-begin`** | Backup block. | Fase 4. |
| **`virsh blockcopy`** | Copy disk. | Fase 4. |
| **Golden image** | Image dasar. | Fase 4. |
| **Clone** | Salinan VM. | `virt-clone`. |
| **Snapshot** | Titik pemulihan. | Fase 4. |
| **Metadata** | Info kustom di XML. | `<metadata>`. |
| **Title** | Judul domain. | `<title>`. |
| **Description** | Deskripsi domain. | `<description>`. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Backup XML Domain (Inaktif)

```bash
virsh dumpxml arch-vm --inactive > /backup/xml/arch-vm.xml
```

**Penjelasan kata demi kata:**
- `virsh dumpxml`: ekspor XML domain.
- `arch-vm`: nama domain.
- `--inactive`: ekspor XML inaktif (tersimpan), bukan live.
- `> /backup/xml/arch-vm.xml`: redirect ke file.

**Kegunaan:** Backup XML untuk restorasi.

**Catatan:** Untuk VM running, XML live bisa berbeda (mis. disk yang di-hotplug). Gunakan `--inactive` untuk konsistensi.

### 4.2. Backup XML Domain (Live)

```bash
virsh dumpxml arch-vm > /backup/xml/arch-vm-live.xml
```

**Penjelasan:**
- Tanpa `--inactive`, `dumpxml` mengembalikan XML live jika VM running.
- Berguna untuk audit runtime.

### 4.3. Backup XML dengan Security Info

```bash
virsh dumpxml arch-vm --inactive --security-info > /backup/xml/arch-vm-secure.xml
```

**Penjelasan kata demi kata:**
- `--security-info`: sertakan label keamanan (AppArmor, SELinux).
- Berguna untuk audit keamanan.

### 4.4. Backup XML dengan Update CPU

```bash
virsh dumpxml arch-vm --inactive --update-cpu > /backup/xml/arch-vm-cpu.xml
```

**Penjelasan:**
- `--update-cpu`: perbarui CPU model sesuai host saat ini.
- Berguna jika host berubah.

### 4.5. Restore XML Domain

```bash
virsh define /backup/xml/arch-vm.xml
```

**Penjelasan kata demi kata:**
- `virsh define`: definisikan domain dari XML.
- Path ke file XML.
- Jika domain sudah ada, XML akan di-update.
- Jika belum ada, domain baru dibuat.

**Output:**
```
Domain 'arch-vm' defined from /backup/xml/arch-vm.xml
```

**Catatan:** Disk **harus** ada di path yang sama seperti di XML. Jika tidak, VM tidak bisa start.

### 4.6. Restore dengan UUID Baru

```bash
# Edit XML, hapus atau ubah UUID
sed -i '/<uuid>/d' /backup/xml/arch-vm.xml
virsh define /backup/xml/arch-vm.xml
```

**Penjelasan:**
- `sed -i '/<uuid>/d'`: hapus baris UUID.
- `virsh define`: definisikan ulang; libvirt generate UUID baru.

**Kegunaan:** Restore di host yang sama tanpa konflik UUID.

### 4.7. Restore dengan Nama Baru

```bash
# Edit XML, ubah nama
sed -i 's/<name>arch-vm<\/name>/<name>arch-vm-clone<\/name>/' /backup/xml/arch-vm.xml
# Hapus UUID
sed -i '/<uuid>/d' /backup/xml/arch-vm.xml
virsh define /backup/xml/arch-vm.xml
```

**Penjelasan:**
- Ubah `<name>`.
- Hapus `<uuid>`.
- Define ulang.

### 4.8. Backup XML Pool

```bash
virsh pool-dumpxml default > /backup/xml/pool-default.xml
virsh pool-dumpxml mypool > /backup/xml/pool-mypool.xml
```

**Penjelasan:**
- `virsh pool-dumpxml`: ekspor XML pool.
- Simpan ke file.

### 4.9. Restore XML Pool

```bash
virsh pool-define /backup/xml/pool-default.xml
virsh pool-build default
virsh pool-start default
virsh pool-autostart default
```

**Penjelasan:**
- `virsh pool-define`: definisikan pool dari XML.
- `virsh pool-build`: buat direktori/VG.
- `virsh pool-start`: aktifkan.
- `virsh pool-autostart`: autostart.

### 4.10. Backup XML Network

```bash
virsh net-dumpxml default > /backup/xml/net-default.xml
virsh net-dumpxml isolated > /backup/xml/net-isolated.xml
```

**Penjelasan:**
- `virsh net-dumpxml`: ekspor XML network.
- Simpan ke file.

### 4.11. Restore XML Network

```bash
virsh net-define /backup/xml/net-default.xml
virsh net-start default
virsh net-autostart default
```

**Penjelasan:**
- `virsh net-define`: definisikan network dari XML.
- `virsh net-start`: aktifkan.
- `virsh net-autostart`: autostart.

### 4.12. Backup NVRAM (UEFI VARS)

```bash
cp /var/lib/libvirt/qemu/nvram/arch-vm_VARS.fd /backup/nvram/
```

**Penjelasan kata demi kata:**
- `cp`: copy.
- Sumber: NVRAM file.
- Tujuan: direktori backup.

**Penting:** NVRAM berisi variabel UEFI (boot order, Secure Boot keys). Tanpa NVRAM, VM UEFI tidak bisa boot dengan konfigurasi yang sama.

### 4.13. Restore NVRAM

```bash
cp /backup/nvram/arch-vm_VARS.fd /var/lib/libvirt/qemu/nvram/
```

**Peringatan:** Lakukan saat VM **shut off**. Jika VM running, NVRAM mungkin terkunci.

### 4.14. Backup State vTPM

```bash
tar czf /backup/tpm/arch-vm-tpm.tar.gz -C /var/lib/libvirt/tpm arch-vm
```

**Penjelasan kata demi kata:**
- `tar czf`: buat arsip gzip.
- `/backup/tpm/arch-vm-tpm.tar.gz`: file arsip.
- `-C /var/lib/libvirt/tpm`: pindah ke direktori.
- `arch-vm`: direktori state vTPM.

### 4.15. Restore State vTPM

```bash
tar xzf /backup/tpm/arch-vm-tpm.tar.gz -C /var/lib/libvirt/tpm
```

**Peringatan:** Lakukan saat VM **shut off** dan swtpm **tidak berjalan**.

### 4.16. Backup Lengkap dengan Skrip

```bash
#!/bin/bash
VM="arch-vm"
BACKUP_DIR="/backup/vm/$VM"
DATE=$(date +%Y%m%d-%H%M%S)

mkdir -p "$BACKUP_DIR/$DATE"

# XML domain
virsh dumpxml "$VM" --inactive > "$BACKUP_DIR/$DATE/$VM.xml"

# XML pool
for pool in $(virsh pool-list --name); do
  virsh pool-dumpxml "$pool" > "$BACKUP_DIR/$DATE/pool-$pool.xml"
done

# XML network
for net in $(virsh net-list --name); do
  virsh net-dumpxml "$net" > "$BACKUP_DIR/$DATE/net-$net.xml"
done

# NVRAM
if [ -f "/var/lib/libvirt/qemu/nvram/${VM}_VARS.fd" ]; then
  cp "/var/lib/libvirt/qemu/nvram/${VM}_VARS.fd" "$BACKUP_DIR/$DATE/"
fi

# vTPM state
if [ -d "/var/lib/libvirt/tpm/$VM" ]; then
  tar czf "$BACKUP_DIR/$DATE/${VM}-tpm.tar.gz" -C /var/lib/libvirt/tpm "$VM"
fi

# Checksum
cd "$BACKUP_DIR/$DATE"
sha256sum * > SHA256SUMS

echo "Backup selesai: $BACKUP_DIR/$DATE"
```

**Penjelasan:**
- Buat direktori dengan timestamp.
- Backup XML domain, pool, network.
- Backup NVRAM, vTPM.
- Buat checksum.
- Log selesai.

### 4.17. Restore Lengkap dengan Skrip

```bash
#!/bin/bash
BACKUP_DIR="$1"

if [ -z "$BACKUP_DIR" ]; then
  echo "Usage: $0 <backup-dir>"
  exit 1
fi

# Verifikasi checksum
cd "$BACKUP_DIR"
sha256sum -c SHA256SUMS || exit 1

# Restore pool
for f in pool-*.xml; do
  [ -f "$f" ] || continue
  virsh pool-define "$f"
  pool=$(basename "$f" .xml | sed 's/pool-//')
  virsh pool-build "$pool" 2>/dev/null
  virsh pool-start "$pool"
  virsh pool-autostart "$pool"
done

# Restore network
for f in net-*.xml; do
  [ -f "$f" ] || continue
  virsh net-define "$f"
  net=$(basename "$f" .xml | sed 's/net-//')
  virsh net-start "$net"
  virsh net-autostart "$net"
done

# Restore NVRAM
for f in *_VARS.fd; do
  [ -f "$f" ] || continue
  cp "$f" /var/lib/libvirt/qemu/nvram/
done

# Restore vTPM
for f in *-tpm.tar.gz; do
  [ -f "$f" ] || continue
  tar xzf "$f" -C /var/lib/libvirt/tpm
done

# Restore domain
for f in *.xml; do
  case "$f" in
    pool-*|net-*) continue ;;
  esac
  virsh define "$f"
done

echo "Restore selesai."
```

**Penjelasan:**
- Verifikasi checksum.
- Restore pool, network, NVRAM, vTPM, domain.
- Urutan penting: pool → network → domain.

### 4.18. Verifikasi Integritas dengan SHA256

```bash
sha256sum /backup/xml/arch-vm.xml > /backup/xml/arch-vm.xml.sha256
sha256sum -c /backup/xml/arch-vm.xml.sha256
```

**Penjelasan:**
- `sha256sum`: buat checksum.
- `-c`: verifikasi.

### 4.19. Versioning dengan Git

```bash
mkdir -p /backup/xml-repo
cd /backup/xml-repo
git init

# Backup semua XML
for vm in $(virsh list --all --name); do
  [ -z "$vm" ] && continue
  virsh dumpxml "$vm" --inactive > "$vm.xml"
done
for pool in $(virsh pool-list --all --name); do
  [ -z "$pool" ] && continue
  virsh pool-dumpxml "$pool" > "pool-$pool.xml"
done
for net in $(virsh net-list --all --name); do
  [ -z "$net" ] && continue
  virsh net-dumpxml "$net" > "net-$net.xml"
done

git add .
git commit -m "Backup $(date +%Y-%m-%d)"
```

**Penjelasan:**
- `git init`: inisialisasi repo.
- Backup semua XML.
- `git add .`: tambahkan semua.
- `git commit`: commit dengan pesan.

### 4.20. Diff XML dengan Git

```bash
cd /backup/xml-repo
git diff HEAD~1 HEAD arch-vm.xml
```

**Penjelasan:**
- `git diff`: lihat perbedaan antara dua commit.
- Berguna untuk audit perubahan.

### 4.21. Rollback XML dengan Git

```bash
cd /backup/xml-repo
git checkout HEAD~1 -- arch-vm.xml
virsh define arch-vm.xml
```

**Penjelasan:**
- `git checkout`: ambil versi lama.
- `virsh define`: definisikan ulang.

### 4.22. Enkripsi XML dengan GPG

```bash
gpg --encrypt --recipient admin@example.com /backup/xml/arch-vm.xml
```

**Penjelasan kata demi kata:**
- `gpg --encrypt`: enkripsi.
- `--recipient`: penerima (kunci publik).
- Output: `arch-vm.xml.gpg`.

### 4.23. Dekripsi XML

```bash
gpg --decrypt /backup/xml/arch-vm.xml.gpg > /tmp/arch-vm.xml
virsh define /tmp/arch-vm.xml
```

### 4.24. Signature XML

```bash
gpg --detach-sign /backup/xml/arch-vm.xml
gpg --verify /backup/xml/arch-vm.xml.sig /backup/xml/arch-vm.xml
```

**Penjelasan:**
- `--detach-sign`: buat signature terpisah.
- `--verify`: verifikasi.

### 4.25. Otomasi dengan Systemd Timer

`/etc/systemd/system/backup-vm-xml.service`:
```ini
[Unit]
Description=Backup VM XML
After=virtqemud.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-vm-xml.sh
User=root
```

`/etc/systemd/system/backup-vm-xml.timer`:
```ini
[Unit]
Description=Backup VM XML Harian
Requires=backup-vm-xml.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Aktifkan:
```bash
sudo systemctl enable --now backup-vm-xml.timer
sudo systemctl list-timers
```

**Penjelasan:**
- `service`: jalankan skrip backup.
- `timer`: jadwalkan harian.
- `Persistent=true`: jalankan jika terlewat.

### 4.26. Otomasi dengan Cron

```bash
crontab -e
```

Tambahkan:
```
0 2 * * * /usr/local/bin/backup-vm-xml.sh
```

**Penjelasan:**
- Jalankan setiap hari pukul 02:00.

### 4.27. Restore di Host Berbeda

```bash
# Di host baru
# 1. Instal libvirt, qemu
sudo pacman -S libvirt qemu-full edk2-ovmf swtpm

# 2. Start daemon
sudo systemctl enable --now virtqemud.socket virtnetworkd.socket virtstoraged.socket

# 3. Restore pool
virsh pool-define /backup/xml/pool-default.xml
virsh pool-build default
virsh pool-start default
virsh pool-autostart default

# 4. Restore network
virsh net-define /backup/xml/net-default.xml
virsh net-start default
virsh net-autostart default

# 5. Copy disk ke path yang sesuai
cp /backup/disk/arch.qcow2 /var/lib/libvirt/images/

# 6. Copy NVRAM
mkdir -p /var/lib/libvirt/qemu/nvram
cp /backup/nvram/arch-vm_VARS.fd /var/lib/libvirt/qemu/nvram/

# 7. Restore vTPM
mkdir -p /var/lib/libvirt/tpm
tar xzf /backup/tpm/arch-vm-tpm.tar.gz -C /var/lib/libvirt/tpm

# 8. Restore domain XML
virsh define /backup/xml/arch-vm.xml

# 9. Start VM
virsh start arch-vm
```

**Penjelasan:** Urutan restore: pool → network → disk → NVRAM → vTPM → domain → start.

### 4.28. Melihat XML yang Tersimpan

```bash
ls -la /etc/libvirt/qemu/
ls -la /etc/libvirt/qemu/autostart/
ls -la /etc/libvirt/storage/
ls -la /etc/libvirt/network/
```

**Penjelasan:**
- `/etc/libvirt/qemu/`: XML domain.
- `/etc/libvirt/qemu/autostart/`: symlink autostart.
- `/etc/libvirt/storage/`: XML pool.
- `/etc/libvirt/network/`: XML network.

### 4.29. Verifikasi XML Setelah Restore

```bash
virsh list --all
virsh dominfo arch-vm
virsh dumpxml arch-vm --inactive | diff - /backup/xml/arch-vm.xml
```

**Penjelasan:**
- `virsh list --all`: cek VM terdefinisi.
- `virsh dominfo`: cek info.
- `diff`: bandingkan XML.

### 4.30. Backup Incremental dengan Git

```bash
cd /backup/xml-repo

# Update XML
virsh dumpxml arch-vm --inactive > arch-vm.xml

# Cek perubahan
git diff arch-vm.xml

# Commit jika ada perubahan
git add arch-vm.xml
git commit -m "Update arch-vm $(date +%Y-%m-%d)"
```

**Penjelasan:**
- Git hanya menyimpan **perubahan**, bukan seluruh file.
- Efisien untuk backup incremental.

### 4.31. Backup dengan Ansible

```yaml
# backup-vm-xml.yml
- hosts: kvm_hosts
  tasks:
    - name: Backup XML domain
      shell: virsh dumpxml {{ item }} --inactive > /backup/xml/{{ item }}.xml
      loop: "{{ ansible_facts.virt_domains }}"
```

**Penjelasan:**
- Playbook Ansible untuk backup multi-host.
- `loop`: iterasi domain.

### 4.32. Backup dengan Terraform

```hcl
# main.tf
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
```

**Penjelasan:**
- Terraform dengan provider libvirt.
- Infrastructure as Code.

### 4.33. Metadata untuk Backup

Tambahkan di XML:

```xml
<metadata>
  <backup:info xmlns:backup="http://example.com/backup">
    <backup:last>2024-01-15</backup:last>
    <backup:by>admin</backup:by>
    <backup:checksum>sha256:...</backup:checksum>
  </backup:info>
</metadata>
```

**Penjelasan:**
- Metadata kustom untuk tracking backup.

---

## 5. Diagram Alur Backup & Restore XML

### 5.1. Alur Backup XML

```
+-------------------+
|  VM Running       |
+-------------------+
          |
          v
+-------------------+
|  virsh dumpxml    |
|  --inactive       |
+-------------------+
          |
          v
+-------------------+
|  File XML         |
+-------------------+
          |
          +--------+--------+--------+
          |        |        |        |
          v        v        v        v
      +------+ +------+ +------+ +------+
      | SHA  | | GPG  | | Git  | | Tar  |
      | 256  | | enc  | | com  | | zip  |
      +------+ +------+ +------+ +------+
          |        |        |        |
          v        v        v        v
      +---------------------------------+
      |  Backup Storage                 |
      |  (/backup/xml, S3, NFS, dll)    |
      +---------------------------------+
```

### 5.2. Alur Restore XML

```
+-------------------+
|  Backup Storage   |
+-------------------+
          |
          v
+-------------------+
|  Verifikasi       |
|  checksum         |
+-------------------+
          |
          v
+-------------------+
|  Dekripsi (jika   |
|  terenkripsi)     |
+-------------------+
          |
          v
+-------------------+
|  Restore Pool     |
|  (pool-define)    |
+-------------------+
          |
          v
+-------------------+
|  Restore Network  |
|  (net-define)     |
+-------------------+
          |
          v
+-------------------+
|  Restore Disk     |
|  (copy qcow2)     |
+-------------------+
          |
          v
+-------------------+
|  Restore NVRAM    |
+-------------------+
          |
          v
+-------------------+
|  Restore vTPM     |
+-------------------+
          |
          v
+-------------------+
|  Restore Domain   |
|  (virsh define)   |
+-------------------+
          |
          v
+-------------------+
|  Start VM         |
+-------------------+
```

### 5.3. Hierarki Resource yang Harus Di-Backup

```
+-------------------+
|   VM (Domain)     |
|   XML             |
+-------------------+
          |
          +--------+--------+--------+--------+
          |        |        |        |        |
          v        v        v        v        v
      +------+ +------+ +------+ +------+ +------+
      | Disk | | Pool | | Net  | | NVRAM| | vTPM |
      | qcow2| | XML  | | XML  | | .fd  | | state|
      +------+ +------+ +------+ +------+ +------+
```

### 5.4. Alur Git Versioning

```
+-------------------+
|  virsh dumpxml    |
+-------------------+
          |
          v
+-------------------+
|  File XML         |
+-------------------+
          |
          v
+-------------------+
|  git add          |
+-------------------+
          |
          v
+-------------------+
|  git commit       |
+-------------------+
          |
          v
+-------------------+
|  Git Repository   |
|  (history)        |
+-------------------+
          |
          +--------+--------+
          |        |        |
          v        v        v
      +------+ +------+ +------+
      | diff | | log  | | roll |
      |      | |      | | back |
      +------+ +------+ +------+
```

### 5.5. Backup vs Restore

```
+-------------------+          +-------------------+
|   BACKUP          |          |   RESTORE         |
+-------------------+          +-------------------+
|  dumpxml          |          |  define           |
|  sha256sum        |          |  verify           |
|  gpg --encrypt    |          |  gpg --decrypt    |
|  git commit       |          |  git checkout     |
|  tar czf          |          |  tar xzf          |
+-------------------+          +-------------------+
          |                              ^
          |                              |
          +------------------------------+
                  Backup Storage
```

---

## 6. Audit Kurikulum: Tambahan Versioning, Checksum, GPG, Git, Otomasi, NVRAM, Pool XML, Network XML

Kurikulum asli hanya menyebut:
```bash
virsh dumpxml arch-vm > arch-vm.xml
virsh define arch-vm.xml
```

Saya menambahkan:

1. **`virsh dumpxml --inactive`** — XML inaktif.
2. **`virsh dumpxml --security-info`** — dengan label keamanan.
3. **`virsh dumpxml --update-cpu`** — update CPU model.
4. **`virsh define`** — restore persistent.
5. **`virsh create`** — restore transient.
6. **UUID handling** — hapus/ubah UUID untuk restore.
7. **Nama handling** — ubah nama untuk clone.
8. **Pool XML** — `virsh pool-dumpxml`, `pool-define`.
9. **Network XML** — `virsh net-dumpxml`, `net-define`.
10. **NVRAM** — backup dan restore.
11. **vTPM state** — backup dan restore.
12. **Checksum** — SHA256 untuk verifikasi.
13. **GPG** — enkripsi dan signature.
14. **Git** — versioning, diff, rollback.
15. **Skrip backup lengkap** — Bash.
16. **Skrip restore lengkap** — Bash.
17. **Systemd timer** — otomasi.
18. **Cron** — otomasi.
19. **Ansible** — otomasi multi-host.
20. **Terraform** — Infrastructure as Code.
21. **Metadata** — tracking backup.
22. **Restore di host berbeda** — urutan lengkap.
23. **Verifikasi** — diff XML.
24. **Incremental backup** — dengan Git.
25. **Backup offsite** — S3, NFS.
26. **Retensi** — kebijakan penyimpanan.
27. **Enkripsi at-rest** — LUKS untuk backup disk.
28. **Immutable backup** — WORM storage.
29. **Disaster recovery** — runbook.
30. **Audit trail** — log backup.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 3.7, dengan lab tambahan untuk Git versioning, GPG encryption, dan restore di host berbeda.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.1 (`virt-install`):** `virt-install` menghasilkan XML. Modul ini mem-backup-nya.
- **Modul 3.2 (XML):** XML adalah yang di-backup. Modul ini memperdalam.
- **Modul 3.3 (Lifecycle):** Backup XML saat VM shut off atau running.
- **Modul 3.4 (Storage):** Pool XML di-backup di sini.
- **Modul 3.5 (Monitoring):** Backup XML untuk audit.
- **Modul 3.6 (Konsol):** QGA untuk freeze sebelum backup.
- **Fase 4 (Storage & Backup):** XML + disk + NVRAM + vTPM = backup lengkap.
- **Fase 5 (Networking):** Network XML di-backup.
- **Fase 6 (Keamanan):** Enkripsi XML, seclabel, TPM.
- **Fase 7 (Otomasi):** Skrip, systemd timer, Ansible.
- **Fase 8 (Expert):** Migrasi, disaster recovery, multi-host.

---

## 8. Referensi Lengkap

- **virsh man page** — https://libvirt.org/manpages/virsh.html
- **libvirt dumpxml** — https://libvirt.org/manpages/virsh.html#dumpxml
- **libvirt define** — https://libvirt.org/manpages/virsh.html#define
- **libvirt create** — https://libvirt.org/manpages/virsh.html#create
- **libvirt pool-dumpxml** — https://libvirt.org/manpages/virsh.html#pool-dumpxml
- **libvirt pool-define** — https://libvirt.org/manpages/virsh.html#pool-define
- **libvirt net-dumpxml** — https://libvirt.org/manpages/virsh.html#net-dumpxml
- **libvirt net-define** — https://libvirt.org/manpages/virsh.html#net-define
- **libvirt domrename** — https://libvirt.org/manpages/virsh.html#domrename
- **libvirt undefine** — https://libvirt.org/manpages/virsh.html#undefine
- **libvirt XML Format** — https://libvirt.org/formatdomain.html
- **libvirt Storage XML** — https://libvirt.org/formatstorage.html
- **libvirt Network XML** — https://libvirt.org/formatnetwork.html
- **libvirt Hooks** — https://libvirt.org/hooks.html
- **Git Documentation** — https://git-scm.com/doc
- **GPG Documentation** — https://gnupg.org/documentation/
- **SHA256** — https://en.wikipedia.org/wiki/SHA-2
- **Systemd Timer** — https://www.freedesktop.org/software/systemd/man/systemd.timer.html
- **Ansible** — https://docs.ansible.com/
- **Terraform libvirt provider** — https://registry.terraform.io/providers/dmacvicar/libvirt/latest
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/Libvirt
- **Arch Wiki: Git** — https://wiki.archlinux.org/title/Git
- **Arch Wiki: GnuPG** — https://wiki.archlinux.org/title/GnuPG
- **Arch Wiki: Systemd** — https://wiki.archlinux.org/title/Systemd

---

## 9. Tips & Praktik Terbaik

1. **Selalu backup XML** sebelum mengubah konfigurasi.
2. **Gunakan `--inactive`** untuk XML yang stabil.
3. **Backup pool XML dan network XML** bersama domain XML.
4. **Backup NVRAM** untuk VM UEFI.
5. **Backup state vTPM** untuk VM dengan TPM.
6. **Gunakan SHA256** untuk verifikasi integritas.
7. **Enkripsi XML** jika mengandung informasi sensitif.
8. **Gunakan Git** untuk versioning.
9. **Commit XML** setiap kali berubah.
10. **Diff XML** untuk audit perubahan.
11. **Rollback** dengan Git jika perlu.
12. **Otomasi** dengan systemd timer atau cron.
13. **Simpan backup di lokasi terpisah** (NFS, S3).
14. **Gunakan retensi** untuk membatasi jumlah backup.
15. **Uji restore** secara berkala.
16. **Dokumentasikan** prosedur restore.
17. **Gunakan checksum** untuk verifikasi.
18. **Backup XML sebelum upgrade** libvirt/QEMU.
19. **Gunakan metadata** untuk tracking.
20. **Batasi akses** ke direktori backup.
21. **Enkripsi backup at-rest** dengan LUKS.
22. **Gunakan immutable storage** untuk backup kritis.
23. **Sertakan disk** dalam backup lengkap (Fase 4).
24. **Sertakan konfigurasi host** (libvirt, QEMU).
25. **Uji disaster recovery** secara berkala.
26. **Gunakan Ansible/Terraform** untuk skala besar.
27. **Jangan simpan backup di host yang sama.**
28. **Gunakan snapshot** sebelum backup.
29. **Dokumentasikan UUID** untuk referensi.
30. **Selalu validasi** XML setelah restore.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `virsh define` gagal | XML tidak valid. | `virt-xml-validate`. |
| UUID conflict | UUID sudah ada. | Hapus/ubah UUID. |
| Nama conflict | Nama sudah ada. | Ubah nama atau `undefine` yang lama. |
| Disk tidak ditemukan | Path disk salah. | Cek path, copy disk. |
| Pool tidak ditemukan | Pool XML tidak di-restore. | `pool-define`. |
| Network tidak ditemukan | Network XML tidak di-restore. | `net-define`. |
| NVRAM tidak ditemukan | NVRAM tidak di-backup. | Copy NVRAM. |
| vTPM gagal | State vTPM tidak di-restore. | Restore tar. |
| VM tidak start | Resource tidak lengkap. | Cek log, cek resource. |
| Backup korup | Tanpa checksum. | Gunakan SHA256. |
| XML hilang | Tidak ada backup. | Backup rutin. |
| Git conflict | Dua perubahan. | Merge manual. |
| GPG gagal | Kunci tidak ada. | Import kunci. |
| Checksum mismatch | File berubah. | Backup ulang. |
| Permission ditolak | User tidak di grup `libvirt`. | `usermod -aG libvirt`. |
| Pool build gagal | Direktori sudah ada. | Cek path. |
| Network start gagal | Bridge sudah ada. | Cek `ip link`. |
| Disk path berubah | Host berbeda. | Edit XML. |
| CPU model tidak kompatibel | Host berbeda. | `--update-cpu`, `host-model`. |
| Firmware path berbeda | Distro berbeda. | Edit XML. |
| Metadata hilang | Tidak di-backup. | Sertakan di XML. |
| Timer tidak jalan | systemd tidak reload. | `systemctl daemon-reload`. |
| Cron tidak jalan | Path salah. | Cek `crontab -l`. |
| Ansible gagal | Koneksi SSH. | Cek inventory. |
| Terraform gagal | Provider tidak terinstal. | `terraform init`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `virsh dumpxml arch-vm --inactive > /backup/xml/arch-vm.xml` berhasil.
- `virt-xml-validate /backup/xml/arch-vm.xml` mengembalikan valid.
- `virsh define /backup/xml/arch-vm.xml` berhasil.
- `virsh list --all` menampilkan VM.
- `virsh start arch-vm` berhasil.
- `virsh pool-dumpxml default > /backup/xml/pool-default.xml` berhasil.
- `virsh net-dumpxml default > /backup/xml/net-default.xml` berhasil.
- NVRAM di-backup dan di-restore.
- vTPM state di-backup dan di-restore.
- SHA256 diverifikasi.
- GPG enkripsi/dekripsi berhasil.
- Git commit dan diff berhasil.
- Skrip backup lengkap berjalan.
- Skrip restore lengkap berjalan.
- Systemd timer berjalan.
- Restore di host berbeda berhasil.
- VM start setelah restore.

**Troubleshooting:**
- Jika `virsh define` gagal: validasi XML.
- Jika UUID conflict: hapus/ubah UUID.
- Jika disk hilang: copy disk ke path yang benar.
- Jika pool gagal: `pool-define`, `pool-build`, `pool-start`.
- Jika network gagal: `net-define`, `net-start`.
- Jika NVRAM hilang: copy dari backup.
- Jika vTPM gagal: restore state.
- Jika VM tidak start: cek `journalctl`, cek log QEMU.
- Jika checksum mismatch: file korup, backup ulang.
- Jika GPG gagal: cek kunci, cek recipient.
- Jika Git conflict: merge manual.
- Jika timer tidak jalan: `systemctl daemon-reload`.
- Jika restore di host berbeda gagal: cek versi libvirt, QEMU, OVMF.
- Untuk debugging: `LIBVIRT_DEBUG=1 virsh ...`.
- Untuk log: `journalctl -u virtqemud`, `/var/log/libvirt/qemu/`.
- Untuk validasi: `virt-xml-validate`.
- Untuk diff: `diff -u`, `git diff`.

---

## 12. Latihan Mandiri

1. Backup XML VM: `virsh dumpxml arch-vm --inactive > /backup/xml/arch-vm.xml`.
2. Validasi: `virt-xml-validate /backup/xml/arch-vm.xml`.
3. Lihat isi XML. Identifikasi elemen penting.
4. Backup XML dengan `--security-info`: simpan ke file lain.
5. Backup pool XML: `virsh pool-dumpxml default > /backup/xml/pool-default.xml`.
6. Backup network XML: `virsh net-dumpxml default > /backup/xml/net-default.xml`.
7. Backup NVRAM: `cp /var/lib/libvirt/qemu/nvram/arch-vm_VARS.fd /backup/nvram/`.
8. Backup vTPM: `tar czf /backup/tpm/arch-vm-tpm.tar.gz -C /var/lib/libvirt/tpm arch-vm`.
9. Buat checksum: `sha256sum /backup/xml/*.xml > /backup/xml/SHA256SUMS`.
10. Verifikasi: `sha256sum -c /backup/xml/SHA256SUMS`.
11. Enkripsi XML: `gpg --encrypt --recipient admin@example.com /backup/xml/arch-vm.xml`.
12. Dekripsi: `gpg --decrypt /backup/xml/arch-vm.xml.gpg > /tmp/arch-vm.xml`.
13. Inisialisasi Git: `mkdir /backup/xml-repo && cd /backup/xml-repo && git init`.
14. Backup semua XML ke repo.
15. Commit: `git add . && git commit -m "Initial backup"`.
16. Ubah XML VM (mis. ubah memori dengan `virt-xml`).
17. Backup ulang, commit lagi.
18. Diff: `git diff HEAD~1 HEAD`.
19. Rollback: `git checkout HEAD~1 -- arch-vm.xml`.
20. Define ulang: `virsh define arch-vm.xml`.
21. Undefine VM: `virsh undefine arch-vm --keep-nvram`.
22. Restore dari XML: `virsh define /backup/xml/arch-vm.xml`.
23. Start VM: `virsh start arch-vm`.
24. Buat skrip backup lengkap (domain, pool, network, NVRAM, vTPM, checksum).
25. Buat skrip restore lengkap.
26. Buat systemd timer untuk backup harian.
27. Restore di host berbeda (jika ada).
28. Tulis ringkasan: apa yang harus di-backup, urutan restore, dan bagaimana otomasi.

---

## 13. Penutup Modul 3.7 & Fase 3

Anda kini menguasai **Backup & Restore XML** — penjaga warisan virtualisasi. Anda bisa mem-backup konfigurasi domain, pool, network, NVRAM, dan vTPM; memvalidasi dengan checksum dan GPG; mengelola versi dengan Git; mengotomasi dengan systemd timer dan Ansible; serta memulihkan VM di host yang sama atau berbeda. Anda memahami bahwa XML adalah **identitas** VM, dan tanpa backup, VM Anda rentan hilang.

Dengan selesainya Modul 3.7, Anda telah **menyelesaikan Fase 3 secara lengkap**. Anda sekarang memiliki:
- Kemampuan membuat VM dengan `virt-install` (3.1).
- Pemahaman mendalam tentang Domain XML (3.2).
- Penguasaan lifecycle VM (3.3).
- Kemampuan mengelola storage pool & volume (3.4).
- Kemampuan monitoring & diagnostik (3.5).
- Kemampuan akses headless via serial, QGA, VNC/SPICE (3.6).
- Kemampuan backup & restore XML (3.7).

**Proyek Fase 3:** Provisioning 3 VM (Arch, Debian, cloud image). Hapus dan bangun ulang hanya dari XML. Dokumentasikan setiap langkah, backup XML, dan restore di host berbeda.

**Rubrik Fase 3:**
| Kriteria | Bobot |
|---|---|
| `virt-install` | 20% |
| XML | 20% |
| Lifecycle | 20% |
| Storage | 20% |
| Monitoring | 20% |

---

## Motivasi Berenergi

XML adalah **nyawa** dari setiap VM. Tanpa XML, disk hanyalah file; dengan XML, disk menjadi **sistem yang hidup**. Dengan menguasai backup & restore XML, Anda bukan lagi operator yang rentan kehilangan; Anda adalah **penjaga warisan** yang tahu bahwa setiap konfigurasi layak dilindungi. Anda telah menyelesaikan Fase 3 — sebuah perjalanan dari QEMU murni ke libvirt terkelola. Sekarang, Anda siap memasuki **Fase 4 — Storage, Image & Backup Engineering**, di mana Anda akan memperdalam seni backup disk, snapshot, clone, dan disaster recovery. Teruslah berevolusi, karena di balik setiap `virsh define` ada seorang arsitek yang memahami bahwa **konfigurasi adalah warisan**. Selamat belajar, dan jangan pernah berhenti melindungi!

---

**Selamat!** Anda telah menyelesaikan **Fase 3**. Berikutnya adalah **Fase 4 — Storage, Image & Backup Engineering (Modul 4.1 — Golden Image + Overlay Backing Chain)**!


> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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

