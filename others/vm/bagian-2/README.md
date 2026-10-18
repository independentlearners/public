# Fase 2 — QEMU/KVM Murni (Tanpa libvirt)

## Overview Fase 2

**Estimasi:** 2 minggu  
**Prasyarat:** Fase 1 lulus  
**Sifat:** Fondasi tingkat rendah; wajib sebelum libvirt.

### Tujuan Fase
- Memahami VM sebagai **proses QEMU** di userspace.
- Menguasai `qemu-system-x86_64`, `qemu-img`, virtio, OVMF, swtpm, dan QMP.
- Mampu menjalankan, mematikan, dan menginspeksi VM tanpa perantara libvirt.
- Memahami debugging dan tracing dasar QEMU.

### Daftar Isi Fase
1. Modul 2.1 — Boot VM Pertama dari CLI
2. Modul 2.2 — `qemu-img`: create, convert, inspect
3. Modul 2.3 — Perangkat Virtio vs Emulasi
4. Modul 2.4 — UEFI OVMF + vTPM dengan swtpm
5. Modul 2.5 — Kontrol Runtime via QMP

### Audit Kurikulum untuk Fase 2
Kurikulum asli sudah baik, tetapi ada beberapa topik yang belum eksplisit dan akan saya tambahkan secara bertahap:
- **QEMU tracing dan debug:** `-d`, `-D`, `-trace`, `-monitor`, `-qmp`.
- **Analisis performa dasar:** perbandingan `-enable-kvm` vs TCG, `-cpu host`, `-machine q35`, virtio vs emulasi.
- **Manajemen proses QEMU:** `-pidfile`, `-daemonize`, `-name`, `-uuid`.
- **Serial console dan boot parameter:** `console=ttyS0`, `-append`, `-nographic`.

Topik-topik ini akan disisipkan pada modul yang relevan tanpa mengubah urutan utama.

### Peta Fase 2

```
+-------------------+     +-------------------+     +-------------------+
|   Modul 2.1       |     |   Modul 2.2       |     |   Modul 2.3       |
| Boot VM Pertama   |---->| qemu-img          |---->| Virtio vs Emulasi |
+-------------------+     +-------------------+     +-------------------+
          |                         |                         |
          v                         v                         v
+-------------------+     +-------------------+     +-------------------+
|   Modul 2.4       |     |   Modul 2.5       |     |   Proyek Fase 2   |
| OVMF + swtpm      |---->| QMP               |---->| VM lengkap        |
+-------------------+     +-------------------+     +-------------------+
```

---

# Modul 2.1 — Boot VM Pertama dari CLI

<details>
  <summary>📃 Daftar Isi</summary>

---

## Mini-Daftar Isi Modul 2.1
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Boot & Arsitektur QEMU-KVM
6. Audit Kurikulum: Tambahan Tracing, Debug, dan Performa Dasar
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

</details>

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah langkah pertama Anda menjalankan VM **tanpa libvirt**. Di sini Anda berinteraksi langsung dengan `qemu-system-x86_64`. Anda akan membuat disk virtual, mengunduh ISO Arch Linux, dan menjalankan VM dengan akselerasi KVM, serial console, serta jaringan user-mode.

**Peran:** Modul ini membangun intuisi bahwa VM hanyalah sebuah proses userspace yang menggunakan `/dev/kvm`. Semua fase berikutnya—libvirt, XML, storage, networking—pada akhirnya akan memanggil QEMU dengan flag-flag serupa. Memahami QEMU murni berarti Anda memahami apa yang sebenarnya terjadi di balik layar.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **QEMU sebagai proses userspace:** QEMU bukan kernel. Ia adalah program biasa yang membuka `/dev/kvm`, meminta kernel membuat VM, dan menjalankan vCPU.
- **KVM sebagai akselerator:** Tanpa KVM, QEMU harus mengemulasi setiap instruksi (TCG). Dengan KVM, instruksi guest dijalankan langsung oleh CPU fisik.
- **Guest, host, vCPU:** Host adalah Arch Linux Anda. Guest adalah sistem di dalam VM. vCPU adalah CPU virtual yang dipetakan ke thread QEMU.
- **Serial console:** Karena headless, kita tidak menggunakan VGA. Kita mengarahkan console guest ke serial port, lalu QEMU meneruskannya ke terminal Anda.
- **User-mode networking (SLIRP):** QEMU menyediakan jaringan NAT sederhana tanpa konfigurasi host. Guest bisa keluar, tetapi tidak bisa diakses dari luar secara default.
- **Virtio:** Perangkat paravirtualisasi yang efisien. Untuk boot pertama, kita gunakan virtio untuk disk dan jaringan.
- **Filosofi:** Kontrol eksplisit. Setiap flag adalah keputusan. Tidak ada GUI yang menyembunyikan detail.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **QEMU** | Emulator dan virtualizer open-source. | `qemu-system-x86_64`. |
| **KVM** | Kernel-based Virtual Machine. | `/dev/kvm`. |
| **vCPU** | CPU virtual. | Dipetakan ke thread QEMU. |
| **Guest** | Sistem operasi di dalam VM. | Arch Linux di VM. |
| **Host** | Sistem yang menjalankan QEMU. | Arch Linux Anda. |
| **qcow2** | Format disk virtual QEMU. | Mendukung snapshot, kompresi, enkripsi. |
| **Virtio** | Standar paravirtualisasi. | `virtio-blk`, `virtio-net`. |
| **SLIRP** | User-mode networking stack di QEMU. | NAT tanpa konfigurasi host. |
| **Serial console** | Console via port serial. | `ttyS0`. |
| **stdio** | Standard input/output. | `-nographic` mengarahkan ke stdio. |
| **QEMU Monitor** | Console kontrol QEMU. | `Ctrl-A c` saat `-nographic`. |
| **QMP** | QEMU Machine Protocol. | JSON via socket. |
| **TCG** | Tiny Code Generator; emulasi penuh. | Tanpa KVM. |
| **-enable-kvm** | Flag untuk mengaktifkan KVM. | Wajib untuk performa. |
| **-cpu host** | Gunakan fitur CPU host. | Performa terbaik. |
| **-machine q35** | Chipset modern (PCIe). | Direkomendasikan. |
| **-drive** | Menambahkan disk. | `if=virtio`. |
| **-netdev** | Menambahkan backend jaringan. | `user,id=net0`. |
| **-device** | Menambahkan perangkat virtual. | `virtio-net-pci`. |
| **-nographic** | Tanpa grafis; serial ke stdio. | Default untuk headless. |
| **-append** | Kernel command line. | Hanya untuk direct kernel boot. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Membuat Disk Virtual

```bash
qemu-img create -f qcow2 arch.qcow2 20G
```

**Penjelasan kata demi kata:**
- `qemu-img`: alat manajemen image disk QEMU.
- `create`: buat image baru.
- `-f qcow2`: format image. `qcow2` adalah format QEMU yang mendukung fitur lanjutan.
- `arch.qcow2`: nama file image.
- `20G`: ukuran maksimum. File tidak langsung 20 GB; hanya tumbuh sesuai penggunaan.

**Mengapa qcow2?** Karena mendukung snapshot, backing file, enkripsi, dan kompresi. Untuk VM produksi, ini standar.

### 4.2. Mengunduh ISO Arch Linux

```bash
curl -LO https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso
curl -LO https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso.sig
```

**Penjelasan:**
- `curl`: alat transfer data.
- `-L`: ikuti redirect.
- `-O`: simpan dengan nama asli.
- `.sig`: signature untuk verifikasi. Sebaiknya verifikasi dengan `gpg`.

Verifikasi:
```bash
gpg --keyserver-options auto-key-retrieve --verify archlinux-x86_64.iso.sig archlinux-x86_64.iso
```

### 4.3. Menjalankan VM Pertama

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 2 \
  -m 2G \
  -name arch-vm \
  -drive file=arch.qcow2,if=virtio,format=qcow2 \
  -cdrom archlinux-x86_64.iso \
  -boot order=d \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -device virtio-rng-pci \
  -nographic
```

**Penjelasan kata demi kata:**
- `qemu-system-x86_64`: emulator untuk arsitektur x86_64.
- `\`: line continuation.
- `-enable-kvm`: aktifkan akselerasi KVM. Tanpa ini, QEMU memakai TCG yang lambat.
- `-machine q35,accel=kvm`: pilih mesin `q35` (chipset modern, PCIe) dan akselerator KVM.
- `-cpu host`: gunakan model CPU host, sehingga guest melihat fitur CPU fisik.
- `-smp 2`: dua vCPU.
- `-m 2G`: memori guest 2 GB.
- `-name arch-vm`: nama VM (muncul di monitor/QMP).
- `-drive file=arch.qcow2,if=virtio,format=qcow2`: tambahkan disk. `if=virtio` berarti gunakan driver virtio-blk. `format=qcow2` eksplisit.
- `-cdrom archlinux-x86_64.iso`: pasang ISO sebagai CD-ROM.
- `-boot order=d`: boot dari CD-ROM terlebih dahulu.
- `-netdev user,id=net0`: backend jaringan user-mode (SLIRP) dengan ID `net0`.
- `-device virtio-net-pci,netdev=net0`: pasang NIC virtio yang terhubung ke `net0`.
- `-device virtio-rng-pci`: perangkat random number generator virtio. Membantu entropi guest.
- `-nographic`: nonaktifkan grafis; arahkan serial dan monitor ke stdio.

**Setelah boot:** Pada menu boot Arch ISO, tekan `e` untuk edit entry, tambahkan `console=ttyS0` di akhir baris `linux`, lalu boot. Ini agar output kernel muncul di serial console.

### 4.4. Keluar dari QEMU

- `Ctrl-A x` untuk keluar paksa.
- `Ctrl-A c` untuk masuk ke QEMU Monitor.
- Di monitor: `quit` untuk keluar, `info status` untuk status.

### 4.5. Contoh dengan Direct Kernel Boot (Opsional)

Jika Anda ingin boot kernel langsung tanpa bootloader:
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 1G \
  -kernel /boot/vmlinuz-linux \
  -initrd /boot/initramfs-linux.img \
  -append "root=/dev/vda1 console=ttyS0" \
  -drive file=arch.qcow2,if=virtio \
  -nographic
```
Ini berguna untuk debugging kernel.

---

## 5. Diagram Alur Boot & Arsitektur QEMU-KVM

### 5.1. Arsitektur QEMU-KVM

```
+-------------------------------------------------------------+
|                        Userspace                            |
|  +-------------------+  +-------------------+               |
|  |   QEMU process    |  |   qemu-img        |               |
|  |  vCPU threads     |  |   (manajemen disk)|               |
|  |  device models    |  +-------------------+               |
|  +-------------------+                                      |
+-------------------------------------------------------------+
|                        Kernel                               |
|  +-------------------+  +-------------------+               |
|  |   KVM module      |  |   VFIO, vhost     |               |
|  |   /dev/kvm        |  |                   |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        Hardware                             |
|  CPU VT-x/AMD-V, IOMMU, RAM, Disk, NIC                      |
+-------------------------------------------------------------+
```

**Penjelasan:**
- QEMU berjalan sebagai proses userspace dengan thread vCPU.
- QEMU membuka `/dev/kvm` dan mengirim ioctl untuk membuat VM.
- KVM memanfaatkan VT-x/AMD-V untuk menjalankan instruksi guest secara native.
- Perangkat virtual (disk, NIC) ditangani QEMU, sebagian bisa diakselerasi (vhost, virtio).

### 5.2. Alur Boot VM

```
+-------------------+
|   QEMU start      |
+-------------------+
          |
          v
+-------------------+
|   Firmware        |  (SeaBIOS default, atau OVMF)
+-------------------+
          |
          v
+-------------------+
|   Bootloader      |  (dari CD-ROM)
+-------------------+
          |
          v
+-------------------+
|   Kernel Linux    |  (guest)
+-------------------+
          |
          v
+-------------------+
|   initramfs       |
+-------------------+
          |
          v
+-------------------+
|   systemd/init    |
+-------------------+
          |
          v
+-------------------+
|   Login prompt    |  (serial console)
+-------------------+
```

**Penjelasan:**
- QEMU memulai firmware (SeaBIOS atau OVMF).
- Firmware mencari boot device sesuai `-boot order`.
- Bootloader ISO Arch dimuat.
- Kernel guest dijalankan, output diarahkan ke `ttyS0`.
- Setelah init, Anda mendapatkan prompt login di terminal.

---

## 6. Audit Kurikulum: Tambahan Tracing, Debug, dan Performa Dasar

Kurikulum asli belum membahas tracing dan debug. Saya tambahkan di sini karena sangat berguna saat boot pertama gagal.

### 6.1. QEMU Debug dengan `-d`

```bash
qemu-system-x86_64 ... -d cpu_reset,guest_errors -D /tmp/qemu.log
```

- `-d`: daftar item debug. Contoh: `cpu_reset`, `int`, `guest_errors`, `mmu`, `in_asm`, `out_asm`.
- `-D /tmp/qemu.log`: file log. Tanpa `-D`, log ke stderr.

**Kegunaan:** Melihat reset CPU, error guest, atau instruksi yang dieksekusi.

### 6.2. Tracing dengan `-trace`

```bash
qemu-system-x86_64 ... -trace events=/tmp/trace-events
```

File `trace-events` berisi:
```
enable=*
```
Atau lebih spesifik:
```
enable=kvm_*
enable=virtio_*
```

**Kegunaan:** Melacak event internal QEMU, seperti operasi KVM, virtio, dan I/O.

### 6.3. QEMU Monitor

Saat `-nographic`, tekan `Ctrl-A c` untuk masuk monitor. Perintah:
- `info status`: status VM.
- `info cpus`: info vCPU.
- `info block`: info disk.
- `info network`: info jaringan.
- `quit`: keluar.

### 6.4. Performa Dasar

- **TCG vs KVM:** Tanpa `-enable-kvm`, QEMU memakai TCG. Sangat lambat. Selalu gunakan KVM jika tersedia.
- **`-cpu host` vs `-cpu qemu64`:** `host` memberikan fitur CPU fisik, meningkatkan performa dan kompatibilitas.
- **`-machine q35` vs `i440fx`:** `q35` lebih modern, mendukung PCIe, dan lebih baik untuk passthrough.
- **Virtio vs emulasi:** `if=virtio` dan `virtio-net-pci` jauh lebih cepat daripada `ide` atau `e1000`.
- **`-smp` dan `-m`:** Sesuaikan dengan resource host. Jangan overcommit berlebihan.

---

## 7. Hubungan dengan Modul Lain

- **Modul 2.2:** Anda akan belajar `qemu-img` lebih dalam: convert, inspect, resize.
- **Modul 2.3:** Virtio vs emulasi akan dibahas detail. Di sini Anda sudah memakai virtio.
- **Modul 2.4:** OVMF dan swtpm akan menggantikan SeaBIOS dan menambah vTPM.
- **Modul 2.5:** QMP akan menggantikan monitor interaktif untuk otomasi.
- **Fase 3:** libvirt akan memanggil QEMU dengan flag serupa, tetapi dikelola melalui XML.
- **Fase 5:** Networking akan melampaui SLIRP: bridge, macvtap, isolated.
- **Fase 6:** Keamanan akan menambah seccomp, cgroups, dan enkripsi.

---

## 8. Referensi Lengkap

- **QEMU Documentation** — https://www.qemu.org/documentation/
- **QEMU Invocation** — https://www.qemu.org/docs/master/system/invocation.html
- **QEMU gdb usage / debugging** — https://www.qemu.org/docs/master/system/gdb.html
- **QEMU tracing** — https://www.qemu.org/docs/master/devel/tracing.html
- **Arch Wiki: QEMU** — https://wiki.archlinux.org/title/QEMU
- **Arch Wiki: KVM** — https://wiki.archlinux.org/title/KVM
- **qemu-img** — https://www.qemu.org/docs/master/tools/qemu-img.html
- **Virtio** — https://www.linux-kvm.org/page/Virtio
- **SLIRP** — https://wiki.qemu.org/Documentation/Networking
- **QEMU Monitor** — https://www.qemu.org/docs/master/system/monitor.html
- **QEMU QMP** — https://www.qemu.org/docs/master/interop/qmp-spec.html

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan `-enable-kvm`** jika `/dev/kvm` tersedia.
2. **Gunakan `-machine q35`** untuk VM modern.
3. **Gunakan `-cpu host`** untuk performa terbaik.
4. **Gunakan virtio** untuk disk dan jaringan.
5. **Tambahkan `virtio-rng-pci`** untuk entropi.
6. **Gunakan `-name` dan `-uuid`** untuk identifikasi.
7. **Simpan log debug** dengan `-D`.
8. **Gunakan `-pidfile`** untuk melacak PID QEMU.
9. **Untuk VM jangka panjang, pertimbangkan `-daemonize`** dan akses via VNC/serial socket.
10. **Jangan lupa `console=ttyS0`** saat boot ISO agar serial console berfungsi.
11. **Verifikasi ISO** dengan GPG sebelum digunakan.
12. **Gunakan `-snapshot`** jika ingin VM ephemeral (perubahan tidak disimpan).
13. **Batasi resource** dengan `-smp` dan `-m` yang wajar.
14. **Gunakan `-no-reboot`** saat debugging agar QEMU keluar saat guest reboot.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `Could not access KVM kernel module: No such file or directory` | `/dev/kvm` tidak ada atau modul belum dimuat. | Cek Fase 1. `modprobe kvm_intel` atau `kvm_amd`. |
| `Permission denied` saat membuka `/dev/kvm` | User tidak di grup `kvm`. | `sudo usermod -aG kvm $USER`, re-login. |
| VM sangat lambat | Tidak memakai `-enable-kvm` atau `-cpu host`. | Tambahkan `-enable-kvm -cpu host`. |
| Boot dari CD tidak terjadi | `-boot order=d` tidak ada atau ISO tidak terbaca. | Pastikan `-cdrom` dan `-boot order=d`. |
| Serial console kosong | Guest tidak diarahkan ke `ttyS0`. | Tambahkan `console=ttyS0` di kernel cmdline saat boot ISO. |
| `-nographic` tidak menampilkan apa-apa | Output guest ke VGA, bukan serial. | Gunakan `-serial mon:stdio -display none` dan pastikan guest pakai `console=ttyS0`. |
| Jaringan tidak berfungsi | `-netdev` atau `-device` salah. | Pastikan `-netdev user,id=net0` dan `-device virtio-net-pci,netdev=net0`. |
| `qemu-img: command not found` | Paket QEMU belum terinstal. | `sudo pacman -S qemu-full`. |
| Disk tidak cukup | Ukuran qcow2 terlalu kecil. | Buat ulang dengan ukuran lebih besar; atau resize. |
| `Could not open 'arch.qcow2': No such file or directory` | File disk belum dibuat. | `qemu-img create -f qcow2 arch.qcow2 20G`. |
| `Failed to initialize KVM: Invalid argument` | KVM tidak kompatibel dengan parameter. | Coba tanpa `-cpu host`, atau periksa `dmesg`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- VM boot ke ISO Arch dan menampilkan prompt.
- Anda bisa login sebagai `root` (ISO Arch default).
- `ip a` di guest menunjukkan interface `ens3` atau `enp0s3` dengan IP dari SLIRP.
- `ping -c 3 archlinux.org` berhasil.
- Anda bisa mematikan VM dengan `poweroff` atau `Ctrl-A x`.
- `qemu-img info arch.qcow2` menunjukkan format `qcow2` dan ukuran virtual 20G.

**Troubleshooting:**
- Jika KVM tidak tersedia: `ls -l /dev/kvm`, `lsmod | grep kvm`.
- Jika serial tidak muncul: coba `-serial mon:stdio -display none` dan tambahkan `console=ttyS0`.
- Jika jaringan gagal: cek `ip a` di guest; coba `dhcpcd` atau `systemd-networkd`.
- Jika QEMU crash: lihat log dengan `-D /tmp/qemu.log -d guest_errors`.
- Jika ingin keluar dari QEMU yang hang: `Ctrl-A x`.
- Untuk melihat QEMU Monitor: `Ctrl-A c`, lalu `info status`.

---

## 12. Latihan Mandiri

1. Buat disk `latihan.qcow2` ukuran 15G.
2. Unduh ISO Arch dan verifikasi signature.
3. Jalankan QEMU dengan `-enable-kvm`, `-cpu host`, `-machine q35`, `-smp 2`, `-m 2G`, disk virtio, CD-ROM ISO, jaringan user-mode, dan `-nographic`.
4. Saat boot menu, edit entry dan tambahkan `console=ttyS0`. Boot.
5. Login ke ISO, cek `ip a`, `ping -c 3 archlinux.org`.
6. Jalankan `qemu-img info latihan.qcow2`.
7. Keluar dari QEMU dengan `Ctrl-A x`.
8. Jalankan lagi QEMU tanpa ISO (`-boot order=c`) dan pastikan mencoba boot dari disk (meskipun belum ada OS).
9. Tambahkan `-d guest_errors -D /tmp/qemu.log`, jalankan, dan periksa log.
10. Jelaskan dengan kata-kata sendiri fungsi setiap flag yang Anda gunakan.

---

## Penutup Modul 2.1

Ini adalah fondasi yang akan membuat Anda memahami apa yang libvirt lakukan di balik layar. Pada modul berikutnya, kita akan mendalami `qemu-img` untuk manajemen image disk: create, convert, inspect, resize, dan amend.

---

# Modul 2.2 — `qemu-img`: create, convert, inspect

## Mini-Daftar Isi Modul 2.2
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Arsitektur Image & Backing Chain
6. Audit Kurikulum: Tambahan `amend`, `rebase`, `resize`, `map`, `dd`, `check`, `compare`, `bitmap`
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

`qemu-img` adalah utilitas baris perintah yang menjadi **tulang punggung manajemen image disk virtual**. Ia mampu membuat, mengonversi, memeriksa, mengubah ukuran, dan memanipulasi image tanpa harus menjalankan VM. Di dunia virtualisasi headless, `qemu-img` adalah pengganti "Disk Management" di GUI.

Modul ini memperluas pemahaman Anda tentang image disk: bukan sekadar file besar, tetapi struktur berlapis dengan metadata, header, dan (opsional) backing chain. Kemampuan menguasai `qemu-img` adalah prasyarat mutlak untuk Fase 4 (Storage & Backup Engineering), di mana Anda akan membangun golden image, snapshot, clone, dan backup.

**Peran dalam kurikulum:** Jika Modul 2.1 mengajarkan Anda menjalankan VM, Modul 2.2 mengajarkan Anda **mengelola bahan bakar VM** (disk). Tanpa penguasaan `qemu-img`, Anda tidak akan bisa melakukan overlay, snapshot, atau migrasi di fase-fase lanjut.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **Image adalah file:** Di level paling dasar, image disk virtual hanyalah file biasa di filesystem host. Namun, ia memiliki **format internal** (header, tabel alokasi, metadata) yang menentukan bagaimana guest melihatnya sebagai disk.
- **Format vs Isi:** Ada dua lapisan yang harus dibedakan dengan tegas. **Format** (mis. `qcow2`, `raw`, `vmdk`, `vdi`) adalah bagaimana data disimpan di host. **Isi** adalah apa yang dilihat guest (mis. ext4, NTFS, LVM). `qemu-img` bekerja pada level format, bukan isi. Untuk mengedit isi, gunakan `libguestfs` (Fase 4).
- **qcow2 sebagai format utama:** qcow2 (QEMU Copy-On-Write versi 2) mendukung:
  - **Backing file** (overlay): file kecil yang membaca dari file induk.
  - **Snapshot internal**: snapshot di dalam file yang sama.
  - **Kompresi**: data dikompresi dengan zlib/zstd.
  - **Enkripsi**: LUKS atau AES.
  - **Alokasi dinamis**: file tumbuh sesuai kebutuhan.
- **raw sebagai format dasar:** Format `raw` adalah data mentah tanpa header. Guest melihatnya sebagai disk, tetapi tidak ada fitur lanjutan. Cocok untuk performa maksimal, tetapi tidak fleksibel.
- **Backing chain:** Rantai file yang saling mereferensikan. Overlay membaca dari backing file jika blok belum dimodifikasi (copy-on-write). Ini adalah dasar snapshot dan clone efisien.
- **Filosofi:** Format adalah **kontrak**. Memilih format berarti memilih fitur, performa, dan kompatibilitas. Selalu pahami trade-off sebelum memilih. Prinsipnya: *qcow2 untuk fleksibilitas, raw untuk performa, dan backing chain untuk efisiensi ruang.*

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **qemu-img** | Utilitas manajemen image QEMU. | `qemu-img create ...`. |
| **Image** | File disk virtual. | `disk.qcow2`. |
| **Format** | Cara data disimpan. | `qcow2`, `raw`, `vmdk`, `vdi`, `vpc`, `vhdx`. |
| **Probe** | Deteksi otomatis format. | `qemu-img info` tanpa `-f`. |
| **Backing file** | File induk untuk overlay. | `-b base.qcow2`. |
| **Backing chain** | Rantai backing file. | `base -> overlay1 -> overlay2`. |
| **Overlay** | Image yang membaca dari backing file. | `qemu-img create -b base.qcow2 -F qcow2 ov.qcow2`. |
| **Copy-on-Write (CoW)** | Teknik menulis hanya saat berubah. | Blok baru ditulis ke overlay. |
| **Cluster** | Unit alokasi di qcow2. | Default 64 KiB. |
| **Preallocation** | Mengalokasikan ruang di muka. | `-o preallocation=metadata`. |
| **Compatibility** | Tingkat kompatibilitas qcow2. | `0.10` atau `1.1`. |
| **Lazy refcounts** | Refcount tidak diperbarui saat runtime. | `-o lazy_refcounts=on`. |
| **Compression** | Kompresi data. | `-c` saat convert. |
| **Encryption** | Enkripsi image. | `-o encrypt.format=luks`. |
| **Bitmap** | Peta perubahan blok. | Untuk backup inkremental. |
| **Snapshot** | Titik pemulihan. | Internal atau eksternal. |
| **Resize** | Mengubah ukuran virtual. | `qemu-img resize`. |
| **Amend** | Mengubah opsi format. | `qemu-img amend`. |
| **Rebase** | Mengubah backing file. | `qemu-img rebase`. |
| **Map** | Memetakan blok image. | `qemu-img map`. |
| **dd** | Menyalin data mentah dari/ke image. | `qemu-img dd`. |
| **Check** | Memeriksa konsistensi. | `qemu-img check`. |
| **Compare** | Membandingkan dua image. | `qemu-img compare`. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Membuat Image: `qemu-img create`

```bash
qemu-img create -f qcow2 disk.qcow2 10G
```

**Penjelasan kata demi kata:**
- `qemu-img`: utilitas.
- `create`: subcommand untuk membuat image baru.
- `-f qcow2`: **format** image. `-f` = format. Wajib eksplisit untuk menghindari tebakan.
- `disk.qcow2`: nama file image yang akan dibuat.
- `10G`: ukuran **virtual** disk. Guest akan melihat disk 10 GB, tetapi file fisik hanya tumbuh sesuai pemakaian.

**Mengapa eksplisit `-f`?** QEMU bisa menebak format dari ekstensi, tetapi tebakan bisa salah. Selalu eksplisit untuk mencegah korupsi.

### 4.2. Opsi Tambahan saat Create

```bash
qemu-img create -f qcow2 -o preallocation=metadata,lazy_refcounts=on,cluster_size=64k disk.qcow2 10G
```

**Penjelasan kata demi kata:**
- `-o`: opsi tambahan untuk format. Berupa daftar `key=value` dipisahkan koma.
- `preallocation=metadata`: alokasikan metadata di awal, mempercepat operasi tulis pertama.
  - Nilai lain: `off` (default), `metadata`, `falloc`, `full`.
  - `full`: file langsung sebesar ukuran virtual (tidak dinamis). Berguna untuk performa.
- `lazy_refcounts=on`: refcount tidak diperbarui setiap saat, hanya saat flush. Meningkatkan performa, tetapi perlu `qemu-img check` jika crash.
- `cluster_size=64k`: ukuran cluster. Default 64 KiB. Bisa 4k–2M. Cluster besar = lebih sedikit overhead, cluster kecil = lebih granular.

**Peringatan:** Opsi harus didukung versi QEMU Anda. Cek dengan `qemu-img --help` atau dokumentasi.

### 4.3. Melihat Informasi Image: `qemu-img info`

```bash
qemu-img info disk.qcow2
```

**Penjelasan:**
- `info`: subcommand untuk menampilkan metadata image.
- `disk.qcow2`: file yang diperiksa.

**Output yang diharapkan:**
```
image: disk.qcow2
file format: qcow2
virtual size: 10 GiB (10737418240 bytes)
disk size: 196 KiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
```

**Penjelasan output:**
- `file format`: format yang terdeteksi.
- `virtual size`: ukuran yang dilihat guest.
- `disk size`: ukuran fisik file di host.
- `cluster_size`: ukuran cluster.
- `compat`: tingkat kompatibilitas.
- `corrupt`: apakah image terdeteksi korup.

Untuk output JSON (berguna untuk scripting):
```bash
qemu-img info --output=json disk.qcow2
```

### 4.4. Konversi Format: `qemu-img convert`

```bash
qemu-img convert -f qcow2 -O raw disk.qcow2 disk.raw
```

**Penjelasan kata demi kata:**
- `convert`: subcommand konversi.
- `-f qcow2`: format **sumber**. `-f` = from.
- `-O raw`: format **tujuan**. `-O` = output.
- `disk.qcow2`: file sumber.
- `disk.raw`: file tujuan.

**Mengapa konversi?** Migrasi antar platform (qcow2 → vmdk untuk VMware), atau optimasi performa (qcow2 → raw). Konversi juga bisa **memadatkan** image yang memiliki backing chain.

### 4.5. Konversi dengan Kompresi

```bash
qemu-img convert -f qcow2 -O qcow2 -c disk.qcow2 disk-compressed.qcow2
```

- `-c`: aktifkan kompresi. Hanya berlaku untuk format target yang mendukung (qcow2, vmdk).

### 4.6. Konversi dengan Backing File (Overlay)

```bash
qemu-img create -f qcow2 -b base.qcow2 -F qcow2 overlay.qcow2
```

**Penjelasan kata demi kata:**
- `-b base.qcow2`: backing file. Overlay akan membaca dari `base.qcow2`.
- `-F qcow2`: format backing file. Wajib jika backing file bukan format default (raw). Jika backing file raw, `-F raw` opsional.
- `overlay.qcow2`: file overlay. Awalnya kosong; hanya berisi metadata.

**Cara kerja:** Saat guest membaca blok yang belum ada di overlay, QEMU membaca dari `base.qcow2`. Saat guest menulis, blok ditulis ke overlay (copy-on-write). Base tetap tidak berubah.

### 4.7. Mengubah Ukuran: `qemu-img resize`

```bash
qemu-img resize disk.qcow2 +5G
```

- `resize`: subcommand ubah ukuran.
- `+5G`: tambah 5 GB dari ukuran saat ini. Bisa juga `-5G` (perkecil) atau `10G` (set absolut).
- **Peringatan:** Memperkecil berbahaya jika ada data di area yang dipotong. Guest harus di-resize filesystem-nya setelahnya.

### 4.8. Mengubah Opsi Format: `qemu-img amend`

```bash
qemu-img amend -f qcow2 -o lazy_refcounts=on disk.qcow2
```

- `amend`: subcommand untuk mengubah opsi format.
- `-o lazy_refcounts=on`: opsi yang diubah.

**Kegunaan:** Mengubah opsi tanpa harus convert ulang. Tidak semua opsi bisa diubah.

### 4.9. Mengubah Backing File: `qemu-img rebase`

```bash
qemu-img rebase -f qcow2 -b new_base.qcow2 -F qcow2 overlay.qcow2
```

- `rebase`: subcommand untuk mengubah backing file.
- `-b new_base.qcow2`: backing file baru.
- `-F qcow2`: format backing baru.
- Mode default: `safe`, yang memverifikasi blok. Mode `unsafe` lebih cepat tapi berisiko.

### 4.10. Memeriksa Konsistensi: `qemu-img check`

```bash
qemu-img check disk.qcow2
```

- `check`: subcommand untuk memverifikasi integritas image.
- Output: daftar error, leak, atau korupsi. Jika bersih, akan menampilkan "No errors were found on the image."

Opsi perbaikan:
```bash
qemu-img check -r all disk.qcow2
```
- `-r all`: repair semua error yang bisa diperbaiki.

### 4.11. Memetakan Blok: `qemu-img map`

```bash
qemu-img map --output=json disk.qcow2
```

- `map`: subcommand untuk menampilkan peta alokasi blok.
- `--output=json`: format JSON.
- Berguna untuk melihat blok mana yang dialokasikan dan di mana (di overlay atau backing).

### 4.12. Membandingkan Dua Image: `qemu-img compare`

```bash
qemu-img compare disk1.qcow2 disk2.qcow2
```

- `compare`: subcommand untuk membandingkan konten.
- Output: "Images are identical" atau daftar perbedaan.
- Berguna setelah backup untuk verifikasi.

### 4.13. Menyalin Data Mentah: `qemu-img dd`

```bash
qemu-img dd if=disk.qcow2 of=/dev/sdb bs=4M
```

- `dd`: subcommand untuk menyalin data mentah.
- `if=`: input file.
- `of=`: output file atau device.
- `bs=4M`: block size.

**Kegunaan:** Menulis image ke USB, atau membaca image dari device fisik.

### 4.14. Bitmap untuk Backup Inkremental

```bash
qemu-img bitmap --add disk.qcow2 backup0
qemu-img bitmap --merge backup0 backup1 disk.qcow2
qemu-img bitmap --remove disk.qcow2 backup0
```

- `bitmap --add`: menambahkan bitmap bernama `backup0`.
- `bitmap --merge`: menggabungkan bitmap.
- `bitmap --remove`: menghapus bitmap.

**Kegunaan:** Melacak blok yang berubah sejak snapshot terakhir, untuk backup inkremental efisien.

---

## 5. Diagram Arsitektur Image & Backing Chain

### 5.1. Struktur Internal qcow2

```
+-------------------------------------------------------+
|              Header (1 cluster)                       |
|  magic: QFI\xfb | version | backing_file_offset       |
|  backing_file_size | cluster_bits | size (virtual)    |
|  crypt_method | l1_size | l1_table_offset             |
|  refcount_table_offset | refcount_table_clusters      |
|  nb_snapshots | snapshots_offset                      |
+-------------------------------------------------------+
|              Refcount Table                           |
|  (menunjuk ke refcount blocks)                        |
+-------------------------------------------------------+
|              Refcount Blocks                          |
|  (menghitung referensi tiap cluster)                  |
+-------------------------------------------------------+
|              L1 Table                                 |
|  (menunjuk ke L2 table)                               |
+-------------------------------------------------------+
|              L2 Table                                 |
|  (menunjuk ke data cluster)                           |
+-------------------------------------------------------+
|              Data Clusters                            |
|  (data guest, bisa dikompresi/dienkripsi)             |
+-------------------------------------------------------+
|              Snapshot Table (opsional)                |
+-------------------------------------------------------+
```

**Penjelasan:**
- **Header:** menyimpan metadata global: versi, ukuran virtual, offset ke tabel lain.
- **Refcount Table/Blocks:** menghitung berapa kali tiap cluster direferensikan. Diperlukan untuk snapshot.
- **L1 Table:** level 1 dari pemetaan. Menunjuk ke L2 table.
- **L2 Table:** level 2. Menunjuk ke data cluster.
- **Data Clusters:** tempat data guest sebenarnya.
- **Snapshot Table:** metadata untuk snapshot internal.

### 5.2. Backing Chain

```
+------------------+
|   base.qcow2     |  <- Golden image, read-only
|  (10 GB virtual) |
+------------------+
         ^
         | backing
         |
+------------------+
|  overlay1.qcow2  |  <- Perubahan VM1
|  (10 GB virtual) |
+------------------+
         ^
         | backing
         |
+------------------+
|  overlay2.qcow2  |  <- Perubahan VM2
|  (10 GB virtual) |
+------------------+
```

**Penjelasan:**
- `base.qcow2` adalah golden image. Tidak diubah.
- `overlay1.qcow2` membaca dari `base.qcow2`. Perubahan VM1 ditulis di sini.
- `overlay2.qcow2` membaca dari `base.qcow2`. Perubahan VM2 ditulis di sini.
- Keuntungan: hemat ruang. Hanya blok yang berubah yang dialokasikan di overlay.
- Kerugian: bergantung pada base. Jika base hilang, overlay tidak bisa boot.

### 5.3. Alur Baca/Tulis pada Overlay

```
Guest baca blok X
        |
        v
+------------------+
| Cek overlay      |
+------------------+
        |
   +----+----+
   |         |
   v         v
Ada di   Tidak ada
overlay   di overlay
   |         |
   v         v
Baca    Baca dari
overlay backing file
```

**Penjelasan:**
- Baca: cek overlay dulu; jika tidak ada, baca dari backing.
- Tulis: selalu tulis ke overlay. Backing tidak pernah diubah.

---

## 6. Audit Kurikulum: Tambahan `amend`, `rebase`, `resize`, `map`, `dd`, `check`, `compare`, `bitmap`

Kurikulum asli hanya menyebut:
```bash
qemu-img create -f qcow2 disk.qcow2 10G
qemu-img info disk.qcow2
qemu-img convert -f qcow2 -O raw disk.qcow2 disk.raw
```

Saya menambahkan:

1. **`qemu-img amend`** — mengubah opsi format tanpa convert ulang. Penting untuk tuning performa.
2. **`qemu-img rebase`** — mengubah backing file. Krusial saat memindahkan overlay ke base baru.
3. **`qemu-img resize`** — mengubah ukuran virtual. Sering diperlukan saat disk guest penuh.
4. **`qemu-img map`** — memetakan blok. Berguna untuk audit alokasi dan debugging.
5. **`qemu-img dd`** — menyalin data mentah. Diperlukan untuk migrasi ke device fisik.
6. **`qemu-img check`** — memeriksa integritas. Wajib setelah crash atau lazy refcounts.
7. **`qemu-img compare`** — membandingkan image. Verifikasi backup.
8. **`qemu-img bitmap`** — bitmap untuk backup inkremental. Fondasi untuk Fase 4 dan 7.

**Rekomendasi:** Tambahkan subcommand ini ke kurikulum sebagai bagian dari Modul 2.2, dengan penekanan pada `amend`, `rebase`, `resize`, `check`, dan `bitmap`.

---

## 7. Hubungan dengan Modul Lain

- **Modul 2.1:** Anda membuat `arch.qcow2`. Modul ini memperdalam cara mengelolanya.
- **Modul 2.3:** Virtio vs emulasi. Format disk tidak berubah, tetapi cara QEMU mengaksesnya berubah.
- **Modul 2.4:** OVMF + swtpm. Disk tetap qcow2, tetapi firmware dan TPM ditambahkan.
- **Fase 3:** libvirt akan mengelola storage pool dan volume. `qemu-img` tetap digunakan di balik layar.
- **Fase 4:** Storage & Backup Engineering. `qemu-img` adalah alat utama untuk snapshot, clone, overlay, dan backup.
- **Fase 6:** Enkripsi disk. `qemu-img create -o encrypt.format=luks`.
- **Fase 8:** Live migration. `qemu-img` digunakan untuk memindahkan disk.

---

## 8. Referensi Lengkap

- **qemu-img Documentation** — https://www.qemu.org/docs/master/tools/qemu-img.html
- **QEMU Image Format (qcow2)** — https://www.qemu.org/docs/master/interop/qcow2.html
- **QEMU Block Layer** — https://www.qemu.org/docs/master/devel/block.html
- **Arch Wiki: QEMU** — https://wiki.archlinux.org/title/QEMU
- **qcow2 specification** — https://gitlab.com/qemu-project/qemu/-/blob/master/docs/interop/qcow2.txt
- **libvirt: Storage Management** — https://libvirt.org/storage.html
- **qemu-img man page** — https://manpages.debian.org/bookworm/qemu-utils/qemu-img.1.en.html
- **qcow2 vs raw performance** — https://www.linux-kvm.org/page/Qcow2
- **Snapshot dan backing chain** — https://www.qemu.org/docs/master/system/images.html

---

## 9. Tips & Praktik Terbaik

1. **Selalu eksplisit `-f` dan `-O`.** Jangan biarkan QEMU menebak format.
2. **Gunakan `qemu-img info --output=json`** untuk scripting.
3. **Preallocation `metadata`** untuk VM produksi: lebih cepat, tetapi tidak boros.
4. **Preallocation `full`** untuk performa maksimal, tetapi boros ruang.
5. **Hindari `lazy_refcounts=on`** jika host sering crash; risiko korupsi lebih tinggi.
6. **Gunakan `qemu-img check`** setelah crash atau sebelum backup penting.
7. **Backup base image** sebelum membuat overlay.
8. **Jangan edit base image** saat overlay aktif.
9. **Gunakan `qemu-img convert -c`** untuk arsip jangka panjang; hemat ruang.
10. **Untuk migrasi ke cloud**, convert ke format yang didukung (raw, qcow2).
11. **Gunakan `qemu-img map`** untuk melihat fragmentasi dan alokasi.
12. **Gunakan `qemu-img compare`** untuk verifikasi backup.
13. **Gunakan bitmap** untuk backup inkremental efisien.
14. **Selalu unmount atau matikan VM** sebelum resize atau amend.
15. **Simpan checksum** (`sha256sum`) image untuk verifikasi.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `qemu-img: Could not open 'disk.qcow2': No such file or directory` | File belum dibuat. | `qemu-img create -f qcow2 disk.qcow2 10G`. |
| `qemu-img: Could not open 'disk.qcow2': Permission denied` | User tidak punya akses. | Cek permission file dan direktori. |
| `qemu-img: Invalid parameter 'preallocation'` | Versi QEMU tidak mendukung opsi. | Cek `qemu-img --help` atau update QEMU. |
| `qemu-img: Could not open backing file` | Backing file hilang atau path salah. | Pastikan backing file ada di path yang benar (relatif terhadap overlay atau absolut). |
| `qemu-img: Backing file format doesn't match` | `-F` salah atau tidak diberikan. | Tambahkan `-F qcow2` (atau format yang sesuai). |
| `qemu-img check` melaporkan error | Image korup. | `qemu-img check -r all disk.qcow2`. Jika gagal, restore dari backup. |
| `qemu-img resize` gagal | VM masih berjalan atau image terenkripsi. | Matikan VM. Untuk enkripsi, resize dengan hati-hati. |
| `qemu-img convert` lambat | Image besar, tanpa kompresi. | Gunakan `-c` atau `-W` (out-of-order writes). |
| `qemu-img rebase` gagal | Mode `safe` memverifikasi blok; bisa lambat. | Gunakan `-u` (unsafe) jika yakin, tetapi berisiko. |
| Overlay tidak bisa boot setelah base dipindah | Path backing file berubah. | `qemu-img rebase -b new_base.qcow2 -F qcow2 overlay.qcow2`. |
| `qemu-img compare` melaporkan perbedaan | Image memang berbeda. | Cek apakah perbedaan signifikan; gunakan `qemu-img map` untuk investigasi. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `qemu-img create -f qcow2 disk.qcow2 10G` berhasil.
- `qemu-img info disk.qcow2` menampilkan format `qcow2` dan virtual size 10 GiB.
- `qemu-img convert -f qcow2 -O raw disk.qcow2 disk.raw` berhasil.
- `qemu-img info disk.raw` menampilkan format `raw`.
- `qemu-img create -f qcow2 -b base.qcow2 -F qcow2 overlay.qcow2` berhasil.
- `qemu-img info overlay.qcow2` menampilkan backing file `base.qcow2`.
- `qemu-img check overlay.qcow2` melaporkan "No errors were found."
- `qemu-img map --output=json disk.qcow2` menampilkan peta blok.
- `qemu-img compare disk.qcow2 disk.qcow2` melaporkan "Images are identical."
- `qemu-img resize disk.qcow2 +5G` berhasil dan `qemu-img info` menunjukkan 15 GiB.

**Troubleshooting:**
- Jika `qemu-img` tidak ditemukan: `sudo pacman -S qemu-full`.
- Jika image korup: `qemu-img check -r all`. Jika masih gagal, restore.
- Jika backing file hilang: buat ulang atau rebase.
- Jika convert lambat: gunakan `-W` untuk out-of-order writes, atau `-c` untuk kompresi.
- Jika ingin melihat semua opsi: `qemu-img --help`.
- Untuk melihat format yang didukung: `qemu-img --help | grep -A 20 "Supported formats"`.
- Untuk debugging: `qemu-img info --output=json` dan `qemu-img map`.

---

## 12. Latihan Mandiri

1. Buat image `base.qcow2` ukuran 10G dengan preallocation `metadata`.
2. Buat overlay `ov1.qcow2` dengan backing `base.qcow2`.
3. Buat overlay `ov2.qcow2` dengan backing `base.qcow2`.
4. Jalankan `qemu-img info` pada ketiganya. Catat perbedaan `disk size`.
5. Konversi `base.qcow2` ke `raw` dan ke `vmdk`. Bandingkan ukuran.
6. Konversi dengan kompresi: `qemu-img convert -c -O qcow2 base.qcow2 base-comp.qcow2`.
7. Resize `base.qcow2` menjadi 20G. Cek `qemu-img info`.
8. Amend `base.qcow2` untuk mengaktifkan `lazy_refcounts`.
9. Rebase `ov1.qcow2` ke `base-comp.qcow2`.
10. Jalankan `qemu-img check` pada semua image.
11. Gunakan `qemu-img map --output=json` pada `ov1.qcow2` dan jelaskan outputnya.
12. Gunakan `qemu-img compare` untuk membandingkan `base.qcow2` dan `ov1.qcow2`.
13. Buat bitmap pada `base.qcow2`: `qemu-img bitmap --add base.qcow2 backup0`.
14. Tuliskan ringkasan: kapan menggunakan `qcow2`, kapan `raw`, dan mengapa backing chain penting.

---

## Penutup Modul 2.2

Anda kini menguasai `qemu-img` secara menyeluruh: dari create, convert, inspect, hingga amend, rebase, resize, check, compare, map, dd, dan bitmap. Ini adalah fondasi yang akan Anda gunakan terus-menerus di Fase 4 dan seterusnya.

# Modul 2.3 — Perangkat Virtio vs Emulasi

## Mini-Daftar Isi Modul 2.3
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Arsitektur Virtio vs Emulasi & Alur I/O
6. Audit Kurikulum: Tambahan vhost, vhost-user, Multi-Queue, MSI-X, ioeventfd/irqfd
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menjelaskan **perbedaan mendasar antara perangkat virtual yang diemulasi sepenuhnya** (seperti `e1000` NIC, `IDE` disk, `VGA` kartu grafis) dan **perangkat paravirtualisasi Virtio** yang dirancang khusus untuk lingkungan virtual. Anda akan memahami mengapa Virtio menjadi standar de facto di KVM, bagaimana ia bekerja, dan bagaimana mengonfigurasinya di QEMU murni.

**Peran dalam kurikulum:** Virtio adalah fondasi performa virtualisasi. Semua fase lanjut (libvirt, storage, networking, passthrough) akan menggunakan Virtio. Tanpa pemahaman ini, Anda akan memakai emulasi yang lambat, tidak sadar mengapa VM terasa berat, dan tidak bisa mengoptimalkan Fase 4–8. Virtio juga menjadi prasyarat untuk memahami **vhost**, **vhost-user**, **vDPA**, dan **DPDK** di Fase 8.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Emulasi Penuh (Full Emulation)

Ketika guest berinteraksi dengan perangkat yang diemulasi, QEMU harus **menafsirkan setiap akses register** yang dilakukan guest. Misalnya, guest menulis ke register NIC `e1000` untuk mengirim paket. QEMU menangkap write tersebut, menerjemahkannya menjadi operasi jaringan, lalu mengirimkan interrupt ke guest. Setiap operasi melewati **batas VM exit** (guest → host → guest), yang mahal.

**Ciri-ciri:**
- Kompatibel dengan driver bawaan OS (guest tidak perlu driver khusus).
- Setiap I/O memicu VM exit dan emulasi per-register.
- Overhead tinggi, terutama untuk I/O intensif (disk, jaringan).

### 2.2. Paravirtualisasi (Virtio)

Virtio adalah **standar paravirtualisasi** di mana guest dan host **sepakat** tentang antarmuka komunikasi. Guest menggunakan **driver Virtio** (sudah ada di kernel Linux modern) yang tahu bahwa ia berjalan di VM. Komunikasi dilakukan melalui **shared memory ring buffer** (virtqueue), sehingga host dan guest bisa bertukar data tanpa harus mensimulasikan perangkat keras.

**Ciri-ciri:**
- Guest **harus** memiliki driver Virtio (Linux kernel punya built-in).
- Komunikasi efisien: ring buffer di memori bersama.
- Interrupt (MSI-X) dan notifikasi ringan.
- Perangkat Virtio: `virtio-blk`, `virtio-scsi`, `virtio-net`, `virtio-rng`, `virtio-balloon`, `virtio-fs`, `virtio-gpu`, `virtio-input`, `virtio-serial`, `virtio-vsock`.

### 2.3. Virtqueue: Jantung Virtio

Virtqueue adalah **ring buffer** yang dibagi antara guest dan host. Terdiri dari:
- **Descriptor Table**: metadata untuk setiap buffer (alamat, panjang, flag).
- **Available Ring**: guest memberi tahu host bahwa ada buffer baru.
- **Used Ring**: host memberi tahu guest bahwa buffer sudah diproses.

Guest menulis descriptor dan menambahkan ke available ring. Host memproses, lalu menambahkan ke used ring. Guest menerima interrupt (jika diaktifkan) atau melakukan polling.

### 2.4. Virtio Modern vs Legacy

- **Legacy (0.9.5)**: antarmuka PCI lama. Digunakan oleh kernel lama.
- **Modern (1.0+)**: antarmuka PCI modern dengan kapabilitas PCI. Default di QEMU modern. Mendukung MSI-X, multi-queue, dan fitur lanjutan.
- QEMU mendukung kedua mode. Gunakan `disable-legacy=on` untuk memaksa modern.

### 2.5. Filosofi

- **Paravirtualisasi lebih cepat dari emulasi** karena menghilangkan simulasi register.
- **Standar terbuka** (Virtio dispesifikasikan oleh OASIS) memastikan interoperabilitas.
- **Driver guest adalah kunci**: tanpa driver, Virtio tidak berfungsi.
- **Optimasi lebih lanjut**: vhost, vhost-user, multi-queue, ioeventfd/irqfd, VFIO, vDPA.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **Emulasi** | Simulasi perangkat keras secara penuh. | `e1000`, `IDE`, `VGA`. |
| **Paravirtualisasi** | Antarmuka khusus untuk VM. | Virtio. |
| **Virtio** | Standar paravirtualisasi. | OASIS spec. |
| **Virtqueue** | Ring buffer komunikasi guest-host. | Descriptor, available, used. |
| **Descriptor** | Metadata buffer di virtqueue. | Alamat, panjang, flag. |
| **Available Ring** | Guest → host notification. | Guest menandai buffer baru. |
| **Used Ring** | Host → guest notification. | Host menandai buffer selesai. |
| **Kick** | Notifikasi guest → host. | `virtio_queue_notify`. |
| **Interrupt** | Notifikasi host → guest. | MSI-X, INTx. |
| **MSI-X** | Message Signaled Interrupts extended. | Interrupt modern. |
| **INTx** | Interrupt legacy (PCI). | Lebih lambat dari MSI-X. |
| **vhost** | Akselerasi Virtio di kernel. | `vhost-net`, `vhost-scsi`, `vhost-blk`. |
| **vhost-user** | Virtio di userspace (DPDK). | Untuk performa tinggi. |
| **vDPA** | vHost Data Path Acceleration. | Hardware dengan datapath Virtio. |
| **Multi-Queue** | Beberapa virtqueue untuk paralelisme. | `queues=N`. |
| **ioeventfd** | Notifikasi tanpa keluar dari KVM. | Mengurangi VM exit. |
| **irqfd** | Interrupt injection tanpa keluar dari KVM. | Mengurangi VM exit. |
| **Virtio-blk** | Driver blok Virtio. | Disk. |
| **Virtio-scsi** | Driver SCSI Virtio. | Disk dengan fitur SCSI. |
| **Virtio-net** | Driver jaringan Virtio. | NIC. |
| **Virtio-rng** | Random number generator. | Entropi. |
| **Virtio-balloon** | Manajemen memori dinamis. | Mengembalikan memori ke host. |
| **Virtio-fs** | Filesystem sharing. | Berbagi direktori host. |
| **Virtio-serial** | Port serial Virtio. | Console, komunikasi. |
| **Virtio-vsock** | Socket Virtio. | Komunikasi host-guest. |
| **Virtio-gpu** | GPU paravirtual. | Grafis terakselerasi. |
| **Virtio-input** | Input paravirtual. | Keyboard, mouse. |
| **vIOMMU** | IOMMU virtual untuk guest. | Isolasi DMA guest. |
| **Packed Ring** | Virtqueue format baru (1.1). | Lebih efisien. |
| **Split Ring** | Virtqueue format lama. | Default. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Perbandingan Disk: Virtio-blk vs IDE

**IDE (emulasi):**
```bash
qemu-system-x86_64 \
  -enable-kvm -cpu host -m 2G \
  -drive file=disk.qcow2,if=ide,format=qcow2 \
  -nographic
```

- `if=ide`: emulasi controller IDE. Kompatibel luas, tetapi setiap I/O melewati emulasi penuh.

**Virtio-blk (paravirtual):**
```bash
qemu-system-x86_64 \
  -enable-kvm -cpu host -m 2G \
  -drive file=disk.qcow2,if=virtio,format=qcow2 \
  -nographic
```

- `if=virtio`: gunakan driver `virtio-blk`. Jauh lebih cepat.

**Virtio-scsi (paravirtual, lebih fleksibel):**
```bash
qemu-system-x86_64 \
  -enable-kvm -cpu host -m 2G \
  -device virtio-scsi-pci,id=scsi0 \
  -drive file=disk.qcow2,if=none,id=drive0,format=qcow2 \
  -device scsi-hd,drive=drive0,bus=scsi0.0 \
  -nographic
```

**Penjelasan kata demi kata:**
- `-device virtio-scsi-pci,id=scsi0`: tambahkan controller Virtio-SCSI.
- `-drive file=disk.qcow2,if=none,id=drive0,format=qcow2`: definisikan disk tanpa menghubungkan ke controller.
- `-device scsi-hd,drive=drive0,bus=scsi0.0`: hubungkan disk ke controller Virtio-SCSI.

**Mengapa Virtio-SCSI?** Mendukung lebih banyak perangkat per controller, TRIM, dan fitur SCSI. Cocok untuk VM dengan banyak disk.

### 4.2. Perbandingan Jaringan: e1000 vs Virtio-net

**e1000 (emulasi):**
```bash
-netdev user,id=net0 \
-device e1000,netdev=net0
```

- `e1000`: emulasi NIC Intel 82540EM. Driver bawaan di hampir semua OS.

**Virtio-net (paravirtual):**
```bash
-netdev user,id=net0 \
-device virtio-net-pci,netdev=net0
```

- `virtio-net-pci`: NIC Virtio. Jauh lebih cepat.

**Virtio-net dengan multi-queue:**
```bash
-netdev user,id=net0,queues=4 \
-device virtio-net-pci,netdev=net0,mq=on,vectors=10
```

- `queues=4`: backend menyediakan 4 queue.
- `mq=on`: aktifkan multi-queue.
- `vectors=10`: jumlah interrupt vector (2 + 2×queue, untuk MSI-X).

**Virtio-net dengan vhost (akselerasi kernel):**
```bash
-netdev tap,id=net0,ifname=tap0,script=no,downscript=no,vhost=on \
-device virtio-net-pci,netdev=net0
```

- `vhost=on`: gunakan `vhost-net` di kernel untuk datapath, mengurangi beban QEMU userspace.
- `tap`: backend TAP (bukan user-mode SLIRP). Memerlukan konfigurasi bridge di host.

### 4.3. Menambahkan Virtio-rng

```bash
-device virtio-rng-pci
```

- Menyediakan `/dev/hwrng` di guest, mengambil entropi dari host.
- Sangat penting untuk VM yang baru boot: mempercepat inisialisasi kriptografi.

### 4.4. Menambahkan Virtio-balloon

```bash
-device virtio-balloon-pci,id=balloon0
```

- Memungkinkan host mengklaim kembali memori guest yang tidak terpakai.
- Di guest, driver `virtio_balloon` mengelola.
- Kontrol via QMP: `balloon` command.

### 4.5. Menambahkan Virtio-serial

```bash
-device virtio-serial-pci \
-chardev socket,id=char0,path=/tmp/virtio-serial.sock,server=on,wait=off \
-device virtserialport,chardev=char0,name=org.example.port0
```

- `virtio-serial-pci`: controller.
- `virtserialport`: port yang bisa diakses guest via `/dev/virtio-ports/org.example.port0`.

### 4.6. Menambahkan Virtio-fs (Shared Filesystem)

```bash
-device vhost-user-fs-pci,chardev=char0,tag=myfs \
-chardev socket,id=char0,path=/tmp/vhost-fs.sock
```

- `vhost-user-fs-pci`: perangkat Virtio-fs.
- `tag=myfs`: tag yang digunakan guest untuk mount.
- Memerlukan daemon `virtiofsd` di host.

**Menjalankan virtiofsd:**
```bash
virtiofsd --socket-path=/tmp/vhost-fs.sock --shared-dir=/host/share
```

- `--shared-dir`: direktori host yang dibagikan.

Di guest:
```bash
mount -t virtiofs myfs /mnt
```

### 4.7. Virtio-vsock

```bash
-device vhost-vsock-pci,guest-cid=3
```

- `guest-cid=3`: Context ID untuk guest.
- Guest bisa berkomunikasi dengan host via `AF_VSOCK`.

### 4.8. Memeriksa Perangkat Virtio di Guest

```bash
lspci | grep -i virtio
```

**Output yang diharapkan:**
```
00:01.0 Ethernet controller: Red Hat, Inc. Virtio network device
00:02.0 SCSI storage controller: Red Hat, Inc. Virtio block device
00:03.0 SCSI storage controller: Red Hat, Inc. Virtio SCSI
00:04.0 Unclassified device [00ff]: Red Hat, Inc. Virtio RNG
00:05.0 Unclassified device [00ff]: Red Hat, Inc. Virtio memory balloon
```

**Cek driver:**
```bash
lsmod | grep virtio
```

**Output:**
```
virtio_net
virtio_blk
virtio_scsi
virtio_pci
virtio_ring
virtio
```

**Cek disk:**
```bash
lsblk
```

**Output:**
```
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    254:0    0  10G  0 disk
└─vda1 254:1    0  10G  0 part /
```

- `vda`: Virtio disk A. `vdb` untuk disk kedua.

**Cek NIC:**
```bash
ip link show
```

**Output:**
```
1: lo: ...
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
```

- `ens3` atau `enp0s3`: nama interface Virtio-net.

### 4.9. Benchmark Sederhana di Guest

```bash
# Disk: dd
dd if=/dev/zero of=/tmp/test bs=1M count=1024 oflag=direct

# Network: iperf3
iperf3 -c <host-ip>
```

Bandingkan antara IDE dan Virtio-blk, atau e1000 dan Virtio-net. Perbedaannya bisa 5–10×.

---

## 5. Diagram Arsitektur Virtio vs Emulasi & Alur I/O

### 5.1. Alur I/O Emulasi (IDE)

```
Guest driver (IDE)
       |
       | tulis register (in/out)
       v
+------------------+
| VM Exit          |  <- CPU keluar dari mode guest
+------------------+
       |
       v
+------------------+
| QEMU userspace   |
| emulasi register |
+------------------+
       |
       v
+------------------+
| Host filesystem  |
| atau backend     |
+------------------+
       |
       v
+------------------+
| Interrupt ke     |
| guest            |
+------------------+
       |
       v
Guest driver lanjut
```

**Penjelasan:**
- Setiap akses I/O memicu VM exit.
- QEMU menafsirkan register satu per satu.
- Overhead besar karena konteks switch.

### 5.2. Alur I/O Virtio (virtio-blk)

```
Guest driver (virtio-blk)
       |
       | isi descriptor, tambah ke available ring
       v
+------------------+
| Virtqueue        |  <- shared memory
| (guest-host)     |
+------------------+
       |
       | kick (ioeventfd)
       v
+------------------+
| QEMU / vhost     |
| proses virtqueue |
+------------------+
       |
       v
+------------------+
| Host filesystem  |
+------------------+
       |
       | interrupt (irqfd)
       v
+------------------+
| Used ring        |
+------------------+
       |
       v
Guest driver selesai
```

**Penjelasan:**
- Guest menulis descriptor ke virtqueue tanpa VM exit (kecuali kick).
- Host memproses virtqueue secara batch.
- Dengan `ioeventfd` dan `irqfd`, kick dan interrupt tidak memicu VM exit.
- Jauh lebih efisien.

### 5.3. Virtio dengan vhost

```
Guest driver
     |
     v
+------------------+
| Virtqueue        |
+------------------+
     |
     | kick
     v
+------------------+
| vhost di kernel  |  <- langsung akses virtqueue
+------------------+
     |
     v
+------------------+
| Host backend     |
+------------------+
     |
     | interrupt
     v
Guest driver selesai
```

**Penjelasan:**
- `vhost` memindahkan pemrosesan virtqueue dari userspace QEMU ke kernel.
- Mengurangi context switch dan overhead.
- Untuk jaringan: `vhost-net`. Untuk SCSI: `vhost-scsi`. Untuk blok: `vhost-blk` (eksperimental).

---

## 6. Audit Kurikulum: Tambahan vhost, vhost-user, Multi-Queue, MSI-X, ioeventfd/irqfd

Kurikulum asli hanya menyebut:
```bash
Tambahkan -device virtio-rng-pci, -balloon virtio.
Validasi: lspci di guest menunjukkan perangkat virtio.
```

Saya menambahkan:

1. **vhost-net** — akselerasi jaringan di kernel. Wajib untuk performa jaringan tinggi.
2. **vhost-scsi** — akselerasi SCSI di kernel.
3. **vhost-blk** — akselerasi blok (eksperimental).
4. **vhost-user** — Virtio di userspace (DPDK, OVS-DPDK). Untuk performa ekstrem.
5. **vDPA** — perangkat keras dengan datapath Virtio.
6. **Multi-Queue** — beberapa virtqueue untuk paralelisme.
7. **MSI-X** — interrupt modern. Mengurangi latency.
8. **ioeventfd/irqfd** — mengurangi VM exit.
9. **Packed Ring** — format virtqueue baru (Virtio 1.1). Lebih efisien.
10. **vIOMMU** — IOMMU virtual untuk guest. Isolasi DMA.
11. **Virtio-fs** — sharing filesystem. Alternatif 9p dan NFS.
12. **Virtio-vsock** — komunikasi host-guest tanpa jaringan.
13. **Virtio-gpu** — grafis paravirtual.
14. **Virtio-input** — input paravirtual.
15. **Virtio-serial** — port serial Virtio.
16. **Benchmark** — cara mengukur performa Virtio vs emulasi.
17. **Profil QEMU** — `perf`, `perf kvm`, `perf top` untuk analisis.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 2.3, dengan lab tambahan untuk benchmark dan profiling.

---

## 7. Hubungan dengan Modul Lain

- **Modul 2.1:** Anda sudah memakai Virtio-blk dan Virtio-net. Modul ini menjelaskan mengapa.
- **Modul 2.2:** Format disk qcow2 tetap sama; Virtio hanya mengubah cara QEMU mengaksesnya.
- **Modul 2.4:** OVMF + swtpm tetap kompatibel dengan Virtio.
- **Modul 2.5:** QMP digunakan untuk mengelola Virtio-balloon, Virtio-net multi-queue, dll.
- **Fase 3:** libvirt XML menggunakan `<driver name='qemu' type='qcow2'/>` dan `<model type='virtio'/>`.
- **Fase 4:** Virtio-blk vs Virtio-scsi memengaruhi strategi storage.
- **Fase 5:** Virtio-net + vhost + tap + bridge adalah fondasi networking.
- **Fase 6:** vIOMMU dan isolasi DMA.
- **Fase 8:** vhost-user, vDPA, DPDK, SR-IOV.

---

## 8. Referensi Lengkap

- **Virtio Specification (OASIS)** — https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.html
- **QEMU Virtio Devices** — https://www.qemu.org/docs/master/system/devices/virtio-net.html
- **QEMU virtio-blk** — https://www.qemu.org/docs/master/system/devices/virtio-blk.html
- **QEMU virtio-scsi** — https://www.qemu.org/docs/master/system/devices/virtio-scsi.html
- **QEMU virtio-net** — https://www.qemu.org/docs/master/system/devices/virtio-net.html
- **QEMU virtio-rng** — https://www.qemu.org/docs/master/system/devices/virtio-rng.html
- **QEMU virtio-balloon** — https://www.qemu.org/docs/master/system/devices/virtio-balloon.html
- **QEMU virtio-fs** — https://www.qemu.org/docs/master/interop/virtiofs.html
- **QEMU virtio-vsock** — https://www.qemu.org/docs/master/system/devices/virtio-vsock.html
- **vhost-net** — https://www.kernel.org/doc/Documentation/virtual/kvm/vhost-net.txt
- **vhost-user** — https://wiki.qemu.org/Features/VhostUser
- **vDPA** — https://www.kernel.org/doc/html/latest/vdpa/index.html
- **Linux Virtio drivers** — https://www.kernel.org/doc/html/latest/driver-api/virtio/index.html
- **Arch Wiki: QEMU** — https://wiki.archlinux.org/title/QEMU
- **libvirt: Virtio devices** — https://libvirt.org/formatdomain.html#devices
- **Multi-Queue Virtio** — https://www.linux-kvm.org/page/Multiqueue
- **Packed Ring** — https://www.redhat.com/en/blog/introduction-virtio-packed-ring
- **MSI-X** — https://wiki.osdev.org/PCI#MSI-X
- **Performance tuning** — https://www.linux-kvm.org/page/Tuning_KVM

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan Virtio** untuk disk dan jaringan di VM Linux modern.
2. **Gunakan Virtio-scsi** jika Anda memerlukan banyak disk, TRIM, atau fitur SCSI.
3. **Aktifkan MSI-X** secara default. Virtio modern sudah memakai MSI-X.
4. **Gunakan vhost-net** untuk jaringan performa tinggi.
5. **Aktifkan multi-queue** untuk NIC Virtio jika guest memiliki banyak vCPU.
6. **Gunakan `virtio-rng-pci`** untuk entropi. Sangat penting untuk VM yang baru boot.
7. **Gunakan `virtio-balloon-pci`** untuk manajemen memori dinamis. Overcommit host.
8. **Jangan lupa driver guest.** Windows membutuhkan `virtio-win`. Linux modern sudah built-in.
9. **Untuk Windows**, gunakan `virtio-win.iso` saat instalasi, atau injeksi via `virt-customize`.
10. **Hindari e1000 dan IDE** untuk VM produksi. Hanya gunakan untuk kompatibilitas OS lama.
11. **Gunakan Virtio-fs** untuk sharing direktori host, menggantikan 9p yang lambat.
12. **Gunakan Virtio-vsock** untuk komunikasi host-guest yang cepat, tanpa jaringan.
13. **Benchmark** sebelum dan sesudah perubahan. Jangan mengandalkan asumsi.
14. **Profil dengan `perf`** untuk melihat di mana overhead terjadi.
15. **Selalu update QEMU** untuk mendapatkan fitur Virtio terbaru.
16. **Perhatikan kompatibilitas guest.** Kernel lama mungkin tidak mendukung Virtio 1.0; gunakan `disable-legacy=off` untuk fallback.
17. **Gunakan packed ring** jika guest dan host mendukung (Virtio 1.1+).

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Guest tidak melihat disk Virtio | Driver `virtio_blk` atau `virtio_pci` tidak ada. | Pastikan kernel guest mendukung Virtio. Untuk Windows, install `virtio-win`. |
| Disk Virtio tidak bisa boot | Bootloader tidak menemukan disk, atau driver tidak di initramfs. | Rebuild initramfs dengan `virtio_blk`, `virtio_pci`, `virtio_scsi`. |
| Network Virtio tidak muncul | Driver `virtio_net` tidak ada. | Cek `lsmod | grep virtio`. Untuk Windows, install driver. |
| vhost-net tidak aktif | Modul `vhost_net` belum dimuat. | `sudo modprobe vhost_net`. |
| Multi-queue tidak berfungsi | Guest driver tidak mendukung, atau queue tidak dikonfigurasi. | Pastikan `mq=on` dan `vectors` cukup. Cek `ethtool -L` di guest. |
| Virtio-fs gagal mount | `virtiofsd` tidak berjalan, atau tag salah. | Pastikan `virtiofsd` berjalan. Cek tag di guest. |
| Virtio-balloon tidak mengembalikan memori | Driver guest tidak aktif, atau QMP tidak dipanggil. | Cek `lsmod | grep virtio_balloon`. Gunakan `balloon` via QMP. |
| Performa Virtio tidak sesuai harapan | Backend lambat, atau MSI-X tidak aktif. | Cek `lspci -vv` di guest untuk MSI-X. Gunakan vhost. |
| Guest crash setelah menambahkan Virtio | Driver tidak kompatibel. | Update kernel guest. Coba `disable-legacy=on` atau `disable-modern=on`. |
| Windows tidak mengenali Virtio | Driver belum diinstal. | Gunakan `virtio-win.iso` saat instalasi. |
| Virtio-scsi tidak mendeteksi disk | Disk tidak terhubung ke controller. | Pastikan `-device scsi-hd,drive=...,bus=scsi0.0`. |
| Virtio-net drop paket | Queue tidak cukup, atau backend lambat. | Tambah queue, aktifkan vhost, cek `ethtool -S`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `lspci | grep -i virtio` di guest menampilkan perangkat Virtio.
- `lsmod | grep virtio` menampilkan modul yang dimuat.
- `lsblk` menampilkan disk `vda` atau `sda` (Virtio-scsi).
- `ip link` menampilkan interface `ens3` atau `enp0s3`.
- Benchmark disk Virtio-blk > 500 MB/s (di host modern).
- Benchmark jaringan Virtio-net > 1 Gbps (dengan vhost).
- `ethtool -L ens3` menampilkan multiple queues (jika multi-queue aktif).
- `cat /sys/class/net/ens3/device/msi_irqs/*` menunjukkan MSI-X aktif.

**Troubleshooting:**
- Jika disk Virtio tidak muncul: cek `dmesg | grep virtio`.
- Jika jaringan tidak muncul: cek `dmesg | grep virtio_net`.
- Jika vhost tidak aktif: `lsmod | grep vhost`. `modprobe vhost_net`.
- Jika multi-queue tidak berfungsi: `ethtool -l ens3` untuk melihat queue.
- Jika performa rendah: `perf kvm stat live` di host.
- Jika Virtio-fs gagal: cek log `virtiofsd`.
- Jika Virtio-vsock gagal: cek `dmesg | grep vsock`.
- Untuk debugging QEMU: `-trace events=/tmp/trace-events` dengan `enable=virtio_*`.
- Untuk melihat virtqueue: `qemu-monitor-command` atau QMP `query-virtio`.

---

## 12. Latihan Mandiri

1. Jalankan VM dengan disk IDE dan benchmark dengan `dd`. Catat hasilnya.
2. Jalankan VM yang sama dengan disk Virtio-blk dan benchmark. Bandingkan.
3. Jalankan VM dengan Virtio-scsi dan benchmark. Bandingkan dengan Virtio-blk.
4. Jalankan VM dengan NIC e1000 dan benchmark dengan `iperf3`. Catat hasilnya.
5. Jalankan VM dengan NIC Virtio-net dan benchmark. Bandingkan.
6. Aktifkan vhost-net dan benchmark lagi. Bandingkan.
7. Aktifkan multi-queue (4 queue) dan benchmark dengan `iperf3 -P 4`. Bandingkan.
8. Tambahkan `virtio-rng-pci` dan cek `cat /dev/hwrng | od -An -tx1 | head`.
9. Tambahkan `virtio-balloon-pci` dan gunakan QMP untuk mengubah memori guest.
10. Tambahkan `virtio-serial-pci` dan komunikasikan host-guest via port.
11. Coba Virtio-fs: jalankan `virtiofsd`, mount di guest, dan uji baca/tulis.
12. Coba Virtio-vsock: komunikasi host-guest via `socat`.
13. Profil dengan `perf kvm stat live` saat benchmark.
14. Tulis ringkasan: kapan menggunakan Virtio-blk vs Virtio-scsi, kapan vhost, kapan multi-queue.

---

## Penutup Modul 2.3

Anda kini memahami perbedaan mendasar antara emulasi dan paravirtualisasi, mengapa Virtio lebih cepat, dan bagaimana mengonfigurasi berbagai perangkat Virtio di QEMU murni. Ini adalah fondasi performa yang akan Anda gunakan di seluruh fase berikutnya.

# Modul 2.4 — UEFI OVMF + vTPM dengan swtpm

## Mini-Daftar Isi Modul 2.4
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Boot UEFI + vTPM & Arsitektur Firmware
6. Audit Kurikulum: Tambahan Secure Boot, SMM, Measured Boot, Attestation, TPM2 Tools
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memperkenalkan dua komponen firmware dan keamanan yang menjadi standar di virtualisasi modern:

1. **OVMF (Open Virtual Machine Firmware)** — implementasi **UEFI** (Unified Extensible Firmware Interface) untuk QEMU. Menggantikan firmware legacy **SeaBIOS** (BIOS 16-bit). UEFI modern mendukung partisi GPT, Secure Boot, driver grafis, network boot, dan bootloader modern.

2. **swtpm** — emulator **TPM** (Trusted Platform Module) berbasis software. Menyediakan **vTPM** (virtual TPM) untuk guest, sehingga guest bisa menggunakan fitur keamanan yang membutuhkan TPM: BitLocker, measured boot, remote attestation, enkripsi disk dengan TPM, dan Windows 11.

**Peran dalam kurikulum:** Modul ini adalah pintu masuk ke keamanan firmware dan perangkat keras virtual. Tanpa OVMF, Anda tidak bisa menjalankan Windows 11 (yang mewajibkan UEFI + Secure Boot + TPM 2.0). Tanpa vTPM, Anda tidak bisa menguji enkripsi disk berbasis TPM atau measured boot. Modul ini juga menjadi fondasi untuk **Fase 6** (Secure Boot + vTPM + Enkripsi Disk) dan **Fase 8** (attestation, measured boot).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. BIOS Legacy vs UEFI

**BIOS (Basic Input/Output System)** adalah firmware legacy yang sudah berusia puluhan tahun. Keterbatasannya:
- Hanya mendukung partisi MBR (maksimal 2 TB).
- Mode 16-bit, akses I/O terbatas.
- Tidak ada Secure Boot.
- Tidak ada driver modern.
- Boot proses sederhana: baca MBR, jalankan bootloader.

**UEFI** adalah pengganti modern:
- Mendukung partisi GPT (hingga 9.4 ZB).
- Mode 32/64-bit, akses penuh ke perangkat.
- Secure Boot: verifikasi signature bootloader dan kernel.
- Driver network, storage, dan grafis.
- Boot manager terintegrasi.
- Mendukung measured boot dengan TPM.

**SeaBIOS** adalah implementasi BIOS legacy untuk QEMU. **OVMF** adalah implementasi UEFI (berbasis EDK II) untuk QEMU.

### 2.2. OVMF: Dua File, Dua Peran

OVMF terdiri dari dua file utama:

- **OVMF_CODE.fd**: kode firmware yang **read-only**. Berisi driver, protokol, dan logika UEFI. Tidak boleh dimodifikasi.
- **OVMF_VARS.fd**: variabel UEFI yang **read-write**. Berisi pengaturan boot, Secure Boot keys, timeout, dan variabel lain. Setiap VM harus memiliki salinan sendiri.

**Mengapa dipisah?** Karena kode firmware sama untuk semua VM, tetapi variabel berbeda. Dengan memisahkan, Anda bisa berbagi `OVMF_CODE.fd` (read-only) dan memberi setiap VM `OVMF_VARS.fd` sendiri (writeable).

### 2.3. Secure Boot

Secure Boot adalah fitur UEFI yang memverifikasi **signature kriptografis** dari setiap komponen boot: bootloader, kernel, dan driver. Jika signature tidak valid, boot ditolak.

**Rantai kepercayaan:**
```
PK (Platform Key)
  └── KEK (Key Exchange Key)
        └── db (Signature Database)
              └── Bootloader (shim, grub, systemd-boot)
                    └── Kernel
```

- **PK**: kunci root. Biasanya dimiliki OEM.
- **KEK**: kunci untuk mengelola db dan dbx.
- **db**: daftar sertifikat/hash yang diizinkan.
- **dbx**: daftar yang dilarang.

**Setup Mode vs User Mode:**
- **Setup Mode**: tidak ada PK. Anda bisa enroll kunci sendiri.
- **User Mode**: PK terpasang. Secure Boot aktif dan memverifikasi.

**OVMF dan Secure Boot:** OVMF memiliki varian `OVMF_CODE.secboot.fd` yang mendukung Secure Boot. Untuk mengaktifkan, Anda perlu:
1. Gunakan `OVMF_CODE.secboot.fd`.
2. Enroll kunci (PK, KEK, db) via UEFI shell atau `virt-firmware`.
3. Boot dengan SMM (System Management Mode) untuk keamanan penuh.

### 2.4. TPM dan vTPM

**TPM (Trusted Platform Module)** adalah chip keamanan yang menyimpan kunci kriptografis dan mengukur integritas sistem. Fitur utama:
- **PCR (Platform Configuration Registers)**: register yang menyimpan hash pengukuran boot.
- **Sealed Storage**: menyegel data agar hanya bisa dibuka jika PCR sesuai.
- **Attestation**: membuktikan konfigurasi sistem ke pihak ketiga.
- **Random Number Generation**: sumber entropi.

**TPM 1.2 vs TPM 2.0:** TPM 2.0 adalah standar modern. Mendukung algoritma lebih banyak (SHA-256, ECC), hierarki kunci, dan lebih fleksibel. Windows 11 mewajibkan TPM 2.0.

**swtpm (Software TPM):** Emulator TPM yang berjalan di userspace. Menyediakan vTPM untuk guest tanpa memerlukan hardware TPM. Mendukung TPM 1.2 dan 2.0.

**Cara kerja:**
- `swtpm` berjalan sebagai proses terpisah di host.
- Berkomunikasi dengan QEMU via UNIX socket.
- QEMU menyediakan perangkat TPM virtual ke guest (`tpm-tis` atau `tpm-crb`).
- Guest melihat TPM sebagai perangkat `/dev/tpm0` dan `/dev/tpmrm0`.

**State vTPM:** Disimpan di direktori (`--tpmstate dir=/path`). Harus **persisten** agar kunci dan PCR tetap ada antar reboot. Jika state hilang, data yang disegel tidak bisa dibuka.

### 2.5. Filosofi

- **Firmware adalah fondasi keamanan.** Tanpa firmware yang benar, semua lapisan di atasnya rapuh.
- **UEFI + Secure Boot + TPM adalah trio keamanan modern.** Mereka bekerja bersama: UEFI mengukur komponen ke TPM, Secure Boot memverifikasi signature, TPM menyegel kunci.
- **vTPM memungkinkan pengujian keamanan tanpa hardware.** Anda bisa menguji BitLocker, measured boot, dan attestation di VM.
- **State vTPM harus dijaga.** Kehilangan state = kehilangan kunci.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **UEFI** | Unified Extensible Firmware Interface. | Pengganti BIOS. |
| **OVMF** | Open Virtual Machine Firmware. | Implementasi UEFI untuk QEMU. |
| **EDK II** | EFI Development Kit II. | Basis OVMF. |
| **SeaBIOS** | BIOS legacy untuk QEMU. | Default QEMU. |
| **pflash** | Parallel flash memory. | Tempat OVMF disimpan. |
| **OVMF_CODE.fd** | Kode firmware read-only. | `/usr/share/edk2/x64/OVMF_CODE.fd`. |
| **OVMF_VARS.fd** | Variabel UEFI read-write. | Salinan per VM. |
| **Secure Boot** | Verifikasi signature boot. | `OVMF_CODE.secboot.fd`. |
| **PK** | Platform Key. | Kunci root Secure Boot. |
| **KEK** | Key Exchange Key. | Mengelola db/dbx. |
| **db** | Signature Database. | Daftar yang diizinkan. |
| **dbx** | Forbidden Signature Database. | Daftar yang dilarang. |
| **Setup Mode** | Tidak ada PK. | Bisa enroll kunci. |
| **User Mode** | PK terpasang. | Secure Boot aktif. |
| **SMM** | System Management Mode. | Mode CPU khusus untuk firmware. |
| **TPM** | Trusted Platform Module. | Chip keamanan. |
| **TPM 1.2** | Versi lama. | SHA-1. |
| **TPM 2.0** | Versi modern. | SHA-256, ECC. |
| **vTPM** | Virtual TPM. | Emulasi TPM. |
| **swtpm** | Software TPM emulator. | Proses userspace. |
| **PCR** | Platform Configuration Register. | Menyimpan hash pengukuran. |
| **Measured Boot** | Pengukuran boot ke PCR. | Setiap komponen di-hash. |
| **Attestation** | Bukti konfigurasi. | Remote attestation. |
| **Sealed Storage** | Data tersegel ke PCR. | Hanya bisa dibuka jika PCR cocok. |
| **tpm-tis** | TPM Interface Specification. | Perangkat TPM virtual. |
| **tpm-crb** | Command Response Buffer. | Perangkat TPM modern. |
| **swtpm_setup** | Setup awal swtpm. | Inisialisasi TPM. |
| **tpm2-tools** | Alat manipulasi TPM 2.0. | `tpm2_pcrread`. |
| **BitLocker** | Enkripsi disk Windows. | Bisa pakai TPM. |
| **systemd-cryptenroll** | Enroll kunci LUKS dengan TPM. | Linux. |
| **clevis** | Binding otomatis dengan TPM. | Red Hat. |
| **shim** | Bootloader penandatangan. | Untuk Secure Boot. |
| **MOK** | Machine Owner Key. | Kunci kustom Secure Boot. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Memeriksa Ketersediaan OVMF

```bash
ls -l /usr/share/edk2/x64/
```

**Penjelasan kata demi kata:**
- `ls -l`: daftar file dengan format panjang.
- `/usr/share/edk2/x64/`: direktori OVMF di Arch Linux.

**Output yang diharapkan:**
```
OVMF_CODE.fd
OVMF_CODE.secboot.fd
OVMF_VARS.fd
OVMF_VARS.secboot.fd
```

- `OVMF_CODE.fd`: firmware UEFI tanpa Secure Boot.
- `OVMF_CODE.secboot.fd`: firmware UEFI dengan dukungan Secure Boot.
- `OVMF_VARS.fd`: template variabel UEFI.
- `OVMF_VARS.secboot.fd`: template variabel dengan kunci Secure Boot default (opsional).

Jika tidak ada, instal:
```bash
sudo pacman -S edk2-ovmf
```

### 4.2. Menyalin OVMF_VARS untuk VM

```bash
cp /usr/share/edk2/x64/OVMF_VARS.fd /var/lib/libvirt/images/arch-vm_VARS.fd
```

**Penjelasan:**
- `cp`: copy.
- Sumber: template variabel UEFI.
- Tujuan: salinan khusus untuk VM. Setiap VM **wajib** memiliki salinan sendiri.
- **Mengapa?** Karena variabel UEFI (boot order, Secure Boot keys) berbeda per VM. Jika semua VM berbagi satu `OVMF_VARS.fd`, perubahan di satu VM akan memengaruhi yang lain.

### 4.3. Menjalankan QEMU dengan OVMF

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 2 \
  -m 2G \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/var/lib/libvirt/images/arch-vm_VARS.fd \
  -drive file=arch.qcow2,if=virtio,format=qcow2 \
  -cdrom archlinux-x86_64.iso \
  -boot order=d \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -device virtio-rng-pci \
  -nographic
```

**Penjelasan kata demi kata:**
- `-drive if=pflash,format=raw,readonly=on,file=OVMF_CODE.fd`:
  - `if=pflash`: gunakan interface **pflash** (parallel flash). OVMF harus diakses melalui pflash, bukan IDE/virtio.
  - `format=raw`: OVMF adalah file raw (bukan qcow2).
  - `readonly=on`: kode firmware read-only.
  - `file=...`: path ke `OVMF_CODE.fd`.
- `-drive if=pflash,format=raw,file=OVMF_VARS.fd`:
  - Variabel UEFI read-write. **Tidak** `readonly`.
  - File ini harus salinan per VM.
- Sisanya sama seperti Modul 2.1.

**Peringatan:** Urutan pflash penting. `OVMF_CODE.fd` harus pertama, `OVMF_VARS.fd` kedua.

### 4.4. Boot ke UEFI Shell

Saat boot, tekan `Esc` untuk masuk ke UEFI menu. Atau, jika tidak ada bootable device, OVMF akan masuk ke UEFI Shell secara otomatis.

Di UEFI Shell, Anda bisa:
- `map`: melihat perangkat.
- `fs0:`: pindah ke filesystem.
- `ls`: daftar file.
- `bcfg boot dump`: melihat boot entry.

### 4.5. Menyiapkan swtpm

```bash
mkdir -p /var/lib/libvirt/tpm/arch-vm
swtpm socket \
  --tpmstate dir=/var/lib/libvirt/tpm/arch-vm \
  --ctrl type=unixio,path=/var/lib/libvirt/tpm/arch-vm/swtpm.sock \
  --tpm2 \
  --daemon \
  --log file=/var/lib/libvirt/tpm/arch-vm/swtpm.log,level=1
```

**Penjelasan kata demi kata:**
- `mkdir -p`: buat direktori, termasuk parent, tanpa error jika sudah ada.
- `swtpm socket`: subcommand `socket` dari swtpm. Menjalankan swtpm sebagai server socket.
- `--tpmstate dir=...`: direktori state TPM. Berisi kunci, PCR, dan konfigurasi.
- `--ctrl type=unixio,path=...`: socket kontrol untuk komunikasi dengan QEMU. `unixio` = UNIX I/O.
- `--tpm2`: gunakan TPM 2.0 (bukan 1.2).
- `--daemon`: jalankan sebagai daemon (background).
- `--log file=...,level=1`: log ke file dengan level 1 (error). Level lebih tinggi untuk debugging.

**Output:** swtpm berjalan di background. Socket kontrol di `/var/lib/libvirt/tpm/arch-vm/swtpm.sock`.

### 4.6. Menjalankan QEMU dengan vTPM

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 2 \
  -m 2G \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/var/lib/libvirt/images/arch-vm_VARS.fd \
  -chardev socket,id=chrtpm,path=/var/lib/libvirt/tpm/arch-vm/swtpm.sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 \
  -drive file=arch.qcow2,if=virtio,format=qcow2 \
  -cdrom archlinux-x86_64.iso \
  -boot order=d \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -nographic
```

**Penjelasan kata demi kata:**
- `-chardev socket,id=chrtpm,path=...`:
  - `chardev`: backend karakter.
  - `socket`: tipe backend.
  - `id=chrtpm`: ID untuk referensi.
  - `path=...`: path ke socket swtpm.
- `-tpmdev emulator,id=tpm0,chardev=chrtpm`:
  - `tpmdev`: perangkat TPM.
  - `emulator`: tipe emulator (swtpm).
  - `id=tpm0`: ID.
  - `chardev=chrtpm`: gunakan chardev di atas.
- `-device tpm-tis,tpmdev=tpm0`:
  - `tpm-tis`: perangkat TPM dengan interface TIS.
  - `tpmdev=tpm0`: hubungkan ke TPM device.
  - Alternatif: `tpm-crb` (Command Response Buffer), lebih modern, tetapi `tpm-tis` lebih kompatibel.

### 4.7. Memverifikasi TPM di Guest

Setelah guest boot:

```bash
dmesg | grep -i tpm
```

**Output yang diharapkan:**
```
[    1.234567] tpm_tis 00:05: 2.0 TPM (device-id 0x1, rev-id 1)
```

```bash
ls -l /dev/tpm*
```

**Output:**
```
crw-rw---- 1 tss tss 10, 224 ... /dev/tpm0
crw-rw---- 1 tss tss 10, 232 ... /dev/tpmrm0
```

- `/dev/tpm0`: akses langsung ke TPM.
- `/dev/tpmrm0`: resource manager. Digunakan oleh `tpm2-tools`.

```bash
cat /sys/class/tpm/tpm0/tpm_version_major
```

**Output:**
```
2
```

### 4.8. Menggunakan tpm2-tools di Guest

Instal:
```bash
sudo pacman -S tpm2-tools
```

Baca PCR:
```bash
sudo tpm2_pcrread
```

**Output yang diharapkan:**
```
sha1:
  0 : 0x0000000000000000000000000000000000000000
  1 : 0x0000000000000000000000000000000000000000
  ...
sha256:
  0 : 0x0000000000000000000000000000000000000000000000000000000000000000
  1 : 0x0000000000000000000000000000000000000000000000000000000000000000
  ...
```

PCR 0–7 adalah untuk firmware dan boot. PCR 8–15 untuk OS. PCR 16 untuk debug. PCR 23 untuk aplikasi.

### 4.9. Contoh: Menyegel Data ke PCR

```bash
echo "secret-data" > secret.txt
sudo tpm2_createprimary -C o -c primary.ctx
sudo tpm2_create -C primary.ctx -u key.pub -r key.priv -i secret.txt
sudo tpm2_load -C primary.ctx -u key.pub -r key.priv -c key.ctx
sudo tpm2_unseal -c key.ctx
```

**Penjelasan:**
- `tpm2_createprimary`: buat primary key di hierarki owner (`-C o`).
- `tpm2_create`: buat objek (data tersegel) dengan primary key sebagai parent.
- `tpm2_load`: muat objek ke TPM.
- `tpm2_unseal`: buka segel dan tampilkan data.

**Kegunaan:** Data hanya bisa dibuka jika TPM dan PCR dalam kondisi yang sama seperti saat disegel.

### 4.10. Secure Boot dengan OVMF

Untuk mengaktifkan Secure Boot:

1. Gunakan `OVMF_CODE.secboot.fd`:
```bash
-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.secboot.fd
```

2. Gunakan `OVMF_VARS.secboot.fd` atau salinannya:
```bash
cp /usr/share/edk2/x64/OVMF_VARS.secboot.fd /var/lib/libvirt/images/arch-vm_VARS.fd
```

3. Aktifkan SMM:
```bash
-machine q35,accel=kvm,smm=on \
-global driver=cfi.pflash01,property=secure,value=on
```

**Penjelasan:**
- `smm=on`: aktifkan System Management Mode. Diperlukan untuk Secure Boot yang aman.
- `-global driver=cfi.pflash01,property=secure,value=on`: kunci pflash setelah boot.

4. Boot ke UEFI menu, enroll kunci (jika belum ada). Atau gunakan `virt-firmware` untuk enroll otomatis.

### 4.11. Enroll Kunci Secure Boot dengan `virt-firmware`

```bash
sudo pacman -S virt-firmware
virt-fw-vars --input /usr/share/edk2/x64/OVMF_VARS.fd \
             --output /var/lib/libvirt/images/arch-vm_VARS.fd \
             --set-pk 12345678-1234-5678-1234-567812345678 /path/to/PK.cer \
             --add-kek 12345678-1234-5678-1234-567812345678 /path/to/KEK.cer \
             --add-db 12345678-1234-5678-1234-567812345678 /path/to/db.cer
```

**Penjelasan:**
- `virt-fw-vars`: alat untuk memanipulasi variabel UEFI.
- `--input`: template VARS.
- `--output`: file VARS yang dimodifikasi.
- `--set-pk`: set Platform Key.
- `--add-kek`: tambah Key Exchange Key.
- `--add-db`: tambah Signature Database.
- GUID: identifier unik untuk setiap kunci.

### 4.12. Melihat Status Secure Boot di Guest

```bash
mokutil --sb-state
```

**Output:**
```
SecureBoot enabled
```

Atau:
```bash
dmesg | grep -i secure
```

**Output:**
```
[    0.000000] Secure boot enabled
```

---

## 5. Diagram Alur Boot UEFI + vTPM & Arsitektur Firmware

### 5.1. Arsitektur OVMF + swtpm

```
+-------------------------------------------------------------+
|                        Guest                                |
|  Bootloader → Kernel → OS                                   |
|  (mengakses /dev/tpm0)                                      |
+-------------------------------------------------------------+
|                        QEMU                                 |
|  +-------------------+  +-------------------+               |
|  |   tpm-tis device  |  |   pflash devices  |               |
|  |                   |  |  CODE.fd / VARS.fd|               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
|                        Host                                 |
|  +-------------------+  +-------------------+               |
|  |   swtpm process   |  |   filesystem      |               |
|  |  (vTPM emulator)  |  |  (qcow2, OVMF)    |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
```

**Penjelasan:**
- Guest mengakses TPM via perangkat `tpm-tis` yang disediakan QEMU.
- QEMU meneruskan perintah TPM ke `swtpm` via socket.
- `swtpm` menyimpan state di direktori host.
- OVMF disimpan di dua file pflash: CODE (read-only) dan VARS (read-write).

### 5.2. Alur Boot UEFI

```
+-------------------+
|   Power On        |
+-------------------+
          |
          v
+-------------------+
|   OVMF (UEFI)     |  <- firmware
+-------------------+
          |
          v
+-------------------+
|   SEC Phase       |  <- Security: verifikasi awal
+-------------------+
          |
          v
+-------------------+
|   PEI Phase       |  <- Pre-EFI Initialization
+-------------------+
          |
          v
+-------------------+
|   DXE Phase       |  <- Driver Execution Environment
+-------------------+
          |
          v
+-------------------+
|   BDS Phase       |  <- Boot Device Selection
+-------------------+
          |
          v
+-------------------+
|   TSL Phase       |  <- Transient System Load
+-------------------+
          |
          v
+-------------------+
|   RT Phase        |  <- Runtime
+-------------------+
          |
          v
+-------------------+
|   Bootloader      |  <- shim, grub, systemd-boot
+-------------------+
          |
          v
+-------------------+
|   Kernel          |
+-------------------+
          |
          v
+-------------------+
|   OS              |
+-------------------+
```

**Penjelasan:**
- **SEC**: verifikasi awal, setup CPU.
- **PEI**: inisialisasi memori dan chipset.
- **DXE**: muat driver UEFI.
- **BDS**: pilih boot device.
- **TSL**: jalankan bootloader.
- **RT**: layanan runtime untuk OS.

### 5.3. Rantai Kepercayaan Secure Boot

```
+-------------------+
|   OVMF ROM        |  <- Root of Trust
+-------------------+
          |
          v
+-------------------+
|   PK              |  <- Platform Key
+-------------------+
          |
          v
+-------------------+
|   KEK             |  <- Key Exchange Key
+-------------------+
          |
          v
+-------------------+
|   db              |  <- Signature Database
+-------------------+
          |
          v
+-------------------+
|   shim / grub     |  <- Bootloader
+-------------------+
          |
          v
+-------------------+
|   Kernel          |  <- Kernel
+-------------------+
          |
          v
+-------------------+
|   initramfs       |
+-------------------+
```

**Penjelasan:**
- Setiap komponen harus ditandatangani oleh kunci yang ada di `db`.
- Jika tidak, boot ditolak.
- `shim` adalah bootloader kecil yang ditandatangani oleh Microsoft, lalu memverifikasi kernel dengan MOK (Machine Owner Key).

### 5.4. Alur vTPM

```
+-------------------+
|   Guest OS        |
|  akses /dev/tpm0  |
+-------------------+
          |
          v
+-------------------+
|   tpm-tis device  |  <- QEMU
+-------------------+
          |
          v
+-------------------+
|   chardev socket  |
+-------------------+
          |
          v
+-------------------+
|   swtpm process   |  <- Host
+-------------------+
          |
          v
+-------------------+
|   tpmstate dir    |  <- Persisten
+-------------------+
```

**Penjelasan:**
- Guest mengakses TPM via `/dev/tpm0`.
- QEMU meneruskan perintah ke `swtpm` via socket.
- `swtpm` menyimpan state di direktori.

---

## 6. Audit Kurikulum: Tambahan Secure Boot, SMM, Measured Boot, Attestation, TPM2 Tools

Kurikulum asli menyebut:
```bash
swtpm socket --tpmstate dir=/tmp/tpm --ctrl type=unixio,path=/tmp/tpm.sock --daemon
qemu-system-x86_64 ... -chardev socket,id=chrtpm,path=/tmp/tpm.sock -tpmdev emulator,id=tpm0,chardev=chrtpm -device tpm-tis,tpmdev=tpm0
Validasi: Guest mendeteksi TPM.
```

Saya menambahkan:

1. **OVMF vs SeaBIOS** — perbandingan, kapan memilih mana.
2. **OVMF_CODE.fd vs OVMF_VARS.fd** — mengapa dipisah, bagaimana menyalin.
3. **pflash** — interface khusus untuk firmware.
4. **Secure Boot** — cara mengaktifkan, enroll kunci, rantai kepercayaan.
5. **SMM** — mengapa diperlukan untuk Secure Boot yang aman.
6. **Measured Boot** — bagaimana PCR diisi, apa yang diukur.
7. **Attestation** — remote attestation, cara membuktikan konfigurasi.
8. **TPM2 Tools** — `tpm2_pcrread`, `tpm2_create`, `tpm2_unseal`, dll.
9. **Sealed Storage** — menyegel data ke PCR.
10. **State vTPM** — mengapa harus persisten, cara backup.
11. **Windows 11** — kebutuhan TPM 2.0 + Secure Boot.
12. **Linux TPM** — `systemd-cryptenroll`, `clevis`, `tpm2-tss`.
13. **BitLocker** — bagaimana TPM digunakan.
14. **TPM 1.2 vs 2.0** — perbedaan, kapan menggunakan.
15. **tpm-tis vs tpm-crb** — perbedaan interface.
16. **virt-firmware** — alat untuk memanipulasi variabel UEFI.
17. **MOK** — Machine Owner Key untuk Secure Boot kustom.
18. **shim** — bootloader penandatangan.
19. **Kernel lockdown** — mengunci kernel saat Secure Boot.
20. **Opsi `-global driver=cfi.pflash01`** — mengunci pflash.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 2.4, dengan lab tambahan untuk Secure Boot, measured boot, dan attestation.

---

## 7. Hubungan dengan Modul Lain

- **Modul 2.1:** Boot VM pertama dengan SeaBIOS. Modul ini menggantinya dengan OVMF.
- **Modul 2.2:** Disk qcow2 tetap sama. OVMF hanya mengubah firmware.
- **Modul 2.3:** Virtio tetap kompatibel dengan OVMF. Bahkan, Virtio + OVMF adalah kombinasi standar.
- **Modul 2.5:** QMP digunakan untuk mengelola vTPM (mis. `query-tpm`, `query-tpm-models`).
- **Fase 3:** libvirt XML memiliki `<os firmware='efi'>` dan `<tpm>` untuk vTPM.
- **Fase 4:** Backup harus mencakup state vTPM.
- **Fase 6:** Secure Boot + vTPM + Enkripsi Disk. Modul ini adalah fondasi.
- **Fase 8:** Attestation, measured boot, remote attestation.

---

## 8. Referensi Lengkap

- **OVMF Documentation** — https://github.com/tianocore/edk2/tree/master/OvmfPkg
- **UEFI Specification** — https://uefi.org/specifications
- **Arch Wiki: OVMF** — https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface
- **Arch Wiki: Secure Boot** — https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot
- **QEMU UEFI** — https://www.qemu.org/docs/master/system/target-i386.html
- **QEMU pflash** — https://www.qemu.org/docs/master/system/devices/pflash.html
- **QEMU TPM** — https://www.qemu.org/docs/master/system/devices/tpm.html
- **swtpm GitHub** — https://github.com/stefanberger/swtpm
- **swtpm man page** — https://github.com/stefanberger/swtpm/wiki
- **TPM 2.0 Specification** — https://trustedcomputinggroup.org/resource/tpm-library-specification/
- **tpm2-tools** — https://github.com/tpm2-software/tpm2-tools
- **tpm2-tss** — https://github.com/tpm2-software/tpm2-tss
- **Linux TPM documentation** — https://www.kernel.org/doc/html/latest/security/tpm/index.html
- **Measured Boot** — https://www.kernel.org/doc/html/latest/security/tpm/tpm_event_log.html
- **Remote Attestation** — https://tpm2-software.github.io/
- **Windows 11 requirements** — https://www.microsoft.com/en-us/windows/windows-11-specifications
- **BitLocker and TPM** — https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/
- **systemd-cryptenroll** — https://www.freedesktop.org/software/systemd/man/systemd-cryptenroll.html
- **clevis** — https://github.com/latchset/clevis
- **virt-firmware** — https://gitlab.com/kraxel/virt-firmware
- **shim** — https://github.com/rhboot/shim
- **MOK** — https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Machine_Owner_Key_(MOK)
- **SMM** — https://wiki.osdev.org/System_Management_Mode
- **Kernel lockdown** — https://www.kernel.org/doc/html/latest/security/lockdown.html

---

## 9. Tips & Praktik Terbaik

1. **Selalu salin `OVMF_VARS.fd` per VM.** Jangan berbagi.
2. **Gunakan `OVMF_CODE.fd` read-only.** Jangan pernah menulis ke CODE.
3. **Simpan state vTPM di direktori persisten.** Jangan gunakan `/tmp`.
4. **Backup state vTPM bersama disk.** Jika hilang, data tersegel hilang.
5. **Gunakan `--tpm2` untuk Windows 11 dan Linux modern.**
6. **Gunakan `tpm-tis` untuk kompatibilitas, `tpm-crb` untuk performa.**
7. **Aktifkan SMM saat menggunakan Secure Boot.**
8. **Gunakan `virt-firmware` untuk enroll kunci Secure Boot.**
9. **Verifikasi PCR setelah boot.**
10. **Gunakan `tpm2_pcrread` untuk melihat PCR.**
11. **Untuk Windows 11, pastikan TPM 2.0 + Secure Boot + UEFI.**
12. **Untuk BitLocker, simpan recovery key.**
13. **Untuk Linux, gunakan `systemd-cryptenroll` dengan TPM.**
14. **Gunakan `clevis` untuk binding otomatis.**
15. **Selalu update OVMF dan swtpm.**
16. **Gunakan `swtpm_setup` untuk inisialisasi awal.**
17. **Log swtpm dengan level yang sesuai untuk debugging.**
18. **Gunakan `qemu-img` untuk backup disk, dan `tar` untuk backup state TPM.**
19. **Gunakan `tpm2-tools` untuk eksperimen.**
20. **Untuk attestation, gunakan `tpm2_quote` dan verifikasi di pihak ketiga.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| QEMU gagal start dengan OVMF | File `OVMF_CODE.fd` tidak ditemukan atau path salah. | Cek `ls /usr/share/edk2/x64/`. Instal `edk2-ovmf`. |
| OVMF_VARS tidak bisa ditulis | File read-only atau permission salah. | Pastikan `readonly` tidak diset untuk VARS. Cek permission. |
| Guest tidak melihat TPM | swtpm tidak berjalan, atau socket salah. | Cek `ps aux | grep swtpm`. Cek `ls -l /path/to/swtpm.sock`. |
| `tpm_tis: probe failed` | Interface TPM salah atau tidak ada. | Coba `tpm-crb` atau `tpm-tis`. Cek `dmesg`. |
| PCR semua nol | Measured boot tidak aktif. | Pastikan OVMF dan bootloader mengukur. Cek `tpm2_pcrread`. |
| Secure Boot tidak aktif | `OVMF_CODE.secboot.fd` tidak digunakan, atau kunci belum di-enroll. | Gunakan `secboot` CODE, enroll kunci. Cek `mokutil --sb-state`. |
| SMM error | `smm=on` tidak diset. | Tambahkan `-machine q35,smm=on`. |
| `swtpm: Could not initialize` | State TPM korup atau permission salah. | Hapus state, jalankan `swtpm_setup`, atau perbaiki permission. |
| Data tersegel tidak bisa dibuka | PCR berubah, atau state TPM hilang. | Cek PCR, restore state TPM. |
| Windows 11 tidak bisa instal | TPM 2.0 atau Secure Boot tidak terdeteksi. | Pastikan OVMF secboot, TPM 2.0, dan SMM. |
| BitLocker meminta recovery key | PCR berubah. | Masukkan recovery key, atau update kebijakan BitLocker. |
| `tpm2_createprimary` gagal | `tpm2-tss` tidak berjalan, atau permission. | `systemctl start tpm2-abrmd` atau gunakan `/dev/tpmrm0`. |
| `virt-fw-vars` gagal | Format VARS tidak valid. | Gunakan template yang benar, atau update `virt-firmware`. |
| OVMF tidak boot dari disk | Boot order salah, atau disk tidak bootable. | Tekan `Esc` saat boot, atur boot order. |
| QEMU crash saat menggunakan vTPM | Versi QEMU atau swtpm tidak kompatibel. | Update keduanya. |
| State TPM hilang setelah reboot | State disimpan di `/tmp`. | Simpan di direktori persisten. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `ls /usr/share/edk2/x64/` menampilkan `OVMF_CODE.fd`, `OVMF_CODE.secboot.fd`, `OVMF_VARS.fd`.
- QEMU berjalan dengan OVMF dan menampilkan UEFI menu (tekan `Esc`).
- `ps aux | grep swtpm` menunjukkan swtpm berjalan.
- `ls -l /path/to/swtpm.sock` menunjukkan socket ada.
- Di guest: `dmesg | grep -i tpm` menampilkan TPM 2.0.
- Di guest: `ls /dev/tpm*` menampilkan `/dev/tpm0` dan `/dev/tpmrm0`.
- Di guest: `tpm2_pcrread` menampilkan PCR.
- Di guest: `mokutil --sb-state` menampilkan `SecureBoot enabled` (jika Secure Boot aktif).
- Setelah reboot, state TPM tetap ada (PCR sama).
- Data tersegel bisa dibuka kembali.

**Troubleshooting:**
- Jika OVMF tidak ditemukan: `sudo pacman -S edk2-ovmf`.
- Jika swtpm tidak ditemukan: `sudo pacman -S swtpm`.
- Jika TPM tidak terdeteksi: `dmesg | grep -i tpm` di guest, `journalctl -u swtpm` di host.
- Jika Secure Boot gagal: cek `OVMF_CODE.secboot.fd`, kunci, dan SMM.
- Jika PCR berubah: identifikasi apa yang berubah (bootloader, kernel, opsi boot).
- Jika data tersegel hilang: restore state TPM dari backup.
- Untuk debugging swtpm: `swtpm socket ... --log level=5`.
- Untuk debugging OVMF: gunakan `-d guest_errors -D /tmp/qemu.log`.
- Untuk melihat variabel UEFI: `virt-fw-vars --input VARS.fd --print`.
- Untuk enroll kunci: `virt-fw-vars` atau UEFI shell.
- Untuk Windows 11: pastikan TPM 2.0, Secure Boot, UEFI, dan RAM ≥ 4 GB.

---

## 12. Latihan Mandiri

1. Instal `edk2-ovmf` dan `swtpm`.
2. Salin `OVMF_VARS.fd` ke direktori VM.
3. Jalankan QEMU dengan OVMF (tanpa vTPM). Tekan `Esc`, jelajahi UEFI menu.
4. Jalankan `swtpm` dengan state di direktori persisten.
5. Jalankan QEMU dengan OVMF + vTPM. Boot ISO Arch.
6. Di guest, instal `tpm2-tools`. Jalankan `tpm2_pcrread`.
7. Catat PCR 0–7. Reboot guest. Cek apakah PCR sama.
8. Buat data tersegel dengan `tpm2_create` dan `tpm2_unseal`.
9. Reboot guest, coba buka segel. Apakah berhasil?
10. Ubah bootloader atau kernel, coba buka segel lagi. Apakah gagal?
11. Aktifkan Secure Boot dengan `OVMF_CODE.secboot.fd` + SMM.
12. Enroll kunci dengan `virt-firmware`.
13. Boot ke guest, cek `mokutil --sb-state`.
14. Coba instal Windows 11 di VM dengan OVMF + vTPM + Secure Boot.
15. Backup state vTPM dan disk. Restore ke VM baru.
16. Tulis ringkasan: kapan menggunakan OVMF, kapan vTPM, dan mengapa Secure Boot penting.

---

## Penutup Modul 2.4

Anda kini menguasai UEFI OVMF dan vTPM dengan swtpm. Anda bisa menjalankan VM modern dengan firmware UEFI, Secure Boot, dan TPM virtual. Ini adalah fondasi untuk Fase 6 (Secure Boot + vTPM + Enkripsi Disk) dan Fase 8 (attestation, measured boot).

# Modul 2.5 — Kontrol Runtime via QMP

## Mini-Daftar Isi Modul 2.5
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur QMP & Arsitektur Komunikasi
6. Audit Kurikulum: Tambahan QGA, QMP Events, QMP Shell, libvirt qemu-monitor-command, JSON-RPC 2.0
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**QMP (QEMU Machine Protocol)** adalah protokol kontrol runtime QEMU berbasis **JSON-RPC 2.0** yang memungkinkan Anda mengelola VM yang sedang berjalan **tanpa menghentikannya**. Berbeda dengan QEMU Monitor (HMP) yang berupa teks interaktif untuk manusia, QMP dirancang untuk **otomasi mesin**: skrip, alat manajemen, dan integrasi dengan sistem lain.

Melalui QMP, Anda dapat:
- Melihat status VM (`query-status`).
- Mengambil snapshot (`savevm` via HMP, atau `blockdev-snapshot` via QMP).
- Menambah/menghapus perangkat secara live (`device_add`, `device_del`).
- Mengubah memori balloon (`balloon`).
- Melakukan migrasi (`migrate`).
- Mengambil screenshot (`screendump`).
- Mengelola blok dan jaringan.
- Menerima **event** asinkron (mis. `RESET`, `SHUTDOWN`, `STOP`).

**Peran dalam kurikulum:** QMP adalah **API kontrol runtime** QEMU. Di Fase 3, libvirt akan menggunakan QMP di balik layar untuk mengelola VM. Di Fase 7 (Otomasi), QMP memungkinkan skrip Anda mengontrol VM tanpa libvirt. Di Fase 8 (Observability), QMP menyediakan data runtime untuk monitoring. Modul ini adalah jembatan antara "VM sebagai proses" (Modul 2.1) dan "VM sebagai layanan terkelola" (Fase 3).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. JSON-RPC 2.0: Bahasa QMP

QMP menggunakan **JSON-RPC 2.0** sebagai format pesan. Setiap perintah dan respons adalah objek JSON:

**Permintaan:**
```json
{ "execute": "query-status", "id": 1 }
```

**Respons sukses:**
```json
{ "return": { "status": "running", "running": true }, "id": 1 }
```

**Respons error:**
```json
{ "error": { "class": "GenericError", "desc": "..." }, "id": 1 }
```

**Event asinkron:**
```json
{ "event": "RESET", "data": { "guest": true } }
```

- `execute`: nama perintah.
- `arguments`: parameter (opsional).
- `id`: identifier permintaan. Respons akan memiliki `id` yang sama.
- `return`: hasil sukses.
- `error`: hasil gagal.
- `event`: notifikasi asinkron (bukan respons).

### 2.2. QMP vs HMP

| Aspek | QMP | HMP |
|---|---|---|
| Format | JSON-RPC 2.0 | Teks interaktif |
| Tujuan | Otomasi, mesin | Manusia |
| Stabilitas | Stabil, terjamin | Tidak stabil, bisa berubah |
| Fitur | Lengkap | Subset QMP |
| Event | Ya | Terbatas |
| Dokumentasi | qmp-spec.html | Tidak formal |

**Filosofi:** HMP untuk eksplorasi manual, QMP untuk otomasi. HMP bisa dianggap "shell", QMP adalah "API". Bahkan, HMP dapat diakses melalui QMP via `human-monitor-command`.

### 2.3. QMP Handshake

Saat klien terhubung ke QMP, server mengirim **greeting**:
```json
{ "QMP": { "version": { "qemu": { "major": 8, "minor": 1, "micro": 0 }, "package": "" }, "capabilities": ["oob"] } }
```

Klien **harus** mengirim `qmp_capabilities` sebelum perintah lain:
```json
{ "execute": "qmp_capabilities" }
```

Respons:
```json
{ "return": {} }
```

**Mengapa?** Ini memastikan klien siap dan mencegah kompatibilitas yang tidak diinginkan. Handshake adalah kontrak protokol.

### 2.4. Mode Out-of-Band (OOB)

Capability `oob` memungkinkan perintah tertentu dieksekusi **tanpa menunggu** perintah lain selesai. Berguna untuk mengelola VM yang sedang sibuk (mis. saat migrasi). Perintah OOB harus ditandai dengan `"control": {...}`.

### 2.5. Event Asinkron

QMP mengirim **event** saat terjadi sesuatu:
- `RESET`: guest direset.
- `SHUTDOWN`: guest shutdown.
- `STOP`: guest dihentikan.
- `RESUME`: guest dilanjutkan.
- `POWERDOWN`: permintaan powerdown.
- `DEVICE_DELETED`: perangkat dihapus.
- `BLOCK_IO_ERROR`: error I/O.
- `VNC_CONNECTED`, `VNC_DISCONNECTED`: event VNC.
- `MIGRATION`: status migrasi.
- `SUSPEND`, `WAKEUP`: suspend/wakeup.

Klien harus siap menerima event kapan saja. Ini adalah inti dari QMP sebagai protokol asinkron.

### 2.6. Filosofi

- **Otomasi adalah tujuan.** QMP ada untuk mesin, bukan manusia.
- **Stabil dan terdokumentasi.** QMP tidak akan berubah sembarangan; HMP bisa.
- **Asinkron.** Event adalah warga kelas satu.
- **Terpisah dari VM.** QMP socket independen dari VM; VM bisa terus berjalan saat Anda memutuskan koneksi.
- **Jembatan ke libvirt.** libvirt menggunakan QMP untuk semua operasi runtime.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/Catatan |
|---|---|---|
| **QMP** | QEMU Machine Protocol. | JSON-RPC 2.0. |
| **JSON-RPC 2.0** | Protokol RPC berbasis JSON. | `{ "execute": ..., "id": ... }`. |
| **HMP** | Human Monitor Protocol. | Teks interaktif. |
| **Greeting** | Pesan awal dari QMP. | Berisi versi dan capability. |
| **Handshake** | Pertukaran awal. | `qmp_capabilities`. |
| **Capability** | Fitur protokol. | `oob`. |
| **OOB** | Out-of-Band. | Eksekusi tanpa menunggu. |
| **Event** | Notifikasi asinkron. | `RESET`, `SHUTDOWN`. |
| **Socket** | Endpoint komunikasi. | UNIX atau TCP. |
| **UNIX socket** | Socket berbasis file. | `/tmp/qmp.sock`. |
| **TCP socket** | Socket jaringan. | `tcp:localhost:4444`. |
| **Control** | Metadata untuk OOB. | `"control": { "runstate": "running" }`. |
| **Execute** | Field perintah. | `"execute": "query-status"`. |
| **Arguments** | Parameter perintah. | `"arguments": { ... }`. |
| **Return** | Hasil sukses. | `"return": { ... }`. |
| **Error** | Hasil gagal. | `"error": { "class": ..., "desc": ... }`. |
| **query-*** | Perintah untuk menanyakan. | `query-status`, `query-cpus`. |
| **blockdev-*** | Perintah blok. | `blockdev-add`, `blockdev-snapshot`. |
| **device_*** | Perintah perangkat. | `device_add`, `device_del`. |
| **screendump** | Screenshot. | `screendump filename=...`. |
| **human-monitor-command** | Jalankan HMP via QMP. | `{"execute": "human-monitor-command", "arguments": {"command-line": "info status"}}`. |
| **QGA** | QEMU Guest Agent. | Agen di guest. |
| **QGA socket** | Kanal komunikasi QGA. | `org.qemu.guest_agent.0`. |
| **qmp-shell** | Alat QMP interaktif. | `scripts/qmp/qmp-shell`. |
| **QMP event** | Event asinkron. | `SHUTDOWN`, `STOP`. |
| **negotiate** | Negosiasi versi. | `qmp_capabilities`. |
| **preconfig** | Mode preconfig. | Sebelum VM jalan. |
| **runstate** | Status VM. | `running`, `paused`, `shutdown`. |
| **reason** | Alasan event. | `guest-shutdown`, `host-signal`. |
| **blockdev-snapshot** | Snapshot via QMP. | Tanpa hentikan VM. |
| **block-commit** | Commit backing chain. | Menggabungkan snapshot. |
| **block-job** | Job I/O asinkron. | `blockdev-mirror`, `block-stream`. |
| **job-*** | Perintah job. | `job-pause`, `job-cancel`. |
| **migrate** | Migrasi. | `migrate`, `migrate-incoming`. |
| **balloon** | Ubah memori. | `balloon value=...`. |
| **query-migrate** | Status migrasi. | `query-migrate`. |
| **system_powerdown** | Kirim ACPI shutdown. | `system_powerdown`. |
| **system_reset** | Reset guest. | `system_reset`. |
| **system_wakeup** | Bangunkan guest. | `system_wakeup`. |
| **cont** | Lanjutkan VM. | `cont`. |
| **stop** | Hentikan VM. | `stop`. |
| **quit** | Keluar QEMU. | `quit`. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Menjalankan QEMU dengan QMP Socket

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 2 \
  -m 2G \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/var/lib/libvirt/images/arch-vm_VARS.fd \
  -drive file=arch.qcow2,if=virtio,format=qcow2 \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -device virtio-rng-pci \
  -nographic \
  -qmp unix:/tmp/qmp.sock,server=on,wait=off \
  -pidfile /tmp/qemu.pid \
  -daemonize
```

**Penjelasan kata demi kata:**
- `-qmp unix:/tmp/qmp.sock,server=on,wait=off`:
  - `-qmp`: tambahkan QMP socket.
  - `unix:/tmp/qmp.sock`: tipe UNIX socket, path `/tmp/qmp.sock`.
  - `server=on`: QEMU berperan sebagai server (menunggu klien).
  - `wait=off`: jangan blokir jika belum ada klien.
  - Alternatif: `-qmp tcp:localhost:4444,server=on,wait=off` untuk TCP.
- `-pidfile /tmp/qemu.pid`: simpan PID QEMU ke file. Berguna untuk scripting.
- `-daemonize`: jalankan QEMU sebagai daemon di background. QEMU akan fork dan parent keluar.

**Peringatan:** `-daemonize` dan `-nographic` tidak bisa bersamaan dengan mudah, karena `-nographic` mengarahkan stdio. Untuk QMP tanpa interaksi, kita bisa mengganti `-nographic` dengan `-display none -serial null` atau menyimpan serial ke socket/file.

Alternatif yang lebih bersih:
```bash
qemu-system-x86_64 \
  ... \
  -display none \
  -serial mon:stdio \
  -qmp unix:/tmp/qmp.sock,server=on,wait=off \
  -daemonize \
  -pidfile /tmp/qemu.pid
```
Namun, `-daemonize` memerlukan `-serial` yang tidak menggunakan stdio. Solusi: gunakan `-serial file:/tmp/serial.log` atau `-serial unix:/tmp/serial.sock,server=on,wait=off`.

**Contoh final yang bersih:**
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 2 \
  -m 2G \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/var/lib/libvirt/images/arch-vm_VARS.fd \
  -drive file=arch.qcow2,if=virtio,format=qcow2 \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -device virtio-rng-pci \
  -display none \
  -serial unix:/tmp/serial.sock,server=on,wait=off \
  -qmp unix:/tmp/qmp.sock,server=on,wait=off \
  -pidfile /tmp/qemu.pid \
  -daemonize
```

- `-display none`: tidak ada grafis.
- `-serial unix:/tmp/serial.sock,server=on,wait=off`: serial console ke UNIX socket.
- `-daemonize`: QEMU berjalan di background.
- `-pidfile`: simpan PID.

Untuk terhubung ke serial: `socat - UNIX-CONNECT:/tmp/serial.sock`.

### 4.2. Terhubung ke QMP dengan `socat`

```bash
socat - UNIX-CONNECT:/tmp/qmp.sock
```

**Penjelasan kata demi kata:**
- `socat`: alat relay dua arah.
- `-`: stdin/stdout.
- `UNIX-CONNECT:/tmp/qmp.sock`: koneksi ke UNIX socket.

**Setelah terhubung, Anda akan menerima greeting:**
```json
{"QMP": {"version": {"qemu": {"major": 8, "minor": 1, "micro": 0}, "package": ""}, "capabilities": ["oob"]}}
```

### 4.3. Handshake

Ketik:
```json
{"execute": "qmp_capabilities"}
```

**Respons:**
```json
{"return": {}}
```

### 4.4. Query Status

```json
{"execute": "query-status", "id": 1}
```

**Respons:**
```json
{"return": {"status": "running", "running": true}, "id": 1}
```

- `status`: `running`, `paused`, `shutdown`, `prelaunch`, `debug`.
- `running`: boolean.

### 4.5. Query CPU

```json
{"execute": "query-cpus-fast", "id": 2}
```

**Respons:**
```json
{"return": [{"cpu-index": 0, "qom-path": "/machine/unattached/device[0]", "thread-id": 12345, "target": "x86_64", "props": {"core-id": 0, "thread-id": 0, "socket-id": 0}}, ...], "id": 2}
```

### 4.6. Query Perangkat Blok

```json
{"execute": "query-block", "id": 3}
```

**Respons:**
```json
{"return": [{"device": "virtio0", "qdev": "/machine/peripheral/virtio0", "type": "unknown", "removable": false, "locked": false, "inserted": {"file": "/path/to/arch.qcow2", "node-name": "#block123", "drv": "qcow2", "ro": false, "backing_file": "..."}}], "id": 3}
```

### 4.7. Query Jaringan

```json
{"execute": "query-netdev", "id": 4}
```

**Respons:**
```json
{"return": [{"type": "user", "id": "net0"}]}
```

### 4.8. Kontrol VM: Stop, Cont, Reset, Powerdown

```json
{"execute": "stop", "id": 5}
{"execute": "cont", "id": 6}
{"execute": "system_reset", "id": 7}
{"execute": "system_powerdown", "id": 8}
```

**Penjelasan:**
- `stop`: hentikan vCPU (pause VM).
- `cont`: lanjutkan vCPU.
- `system_reset`: reset guest (seperti tombol reset).
- `system_powerdown`: kirim sinyal ACPI powerdown (guest bisa menolak).

### 4.9. Menambah Perangkat: `device_add`

```json
{"execute": "device_add", "arguments": {"driver": "virtio-net-pci", "netdev": "net1", "id": "net1dev"}, "id": 9}
```

**Penjelasan:**
- `driver`: nama driver perangkat.
- `netdev`: backend jaringan.
- `id`: ID perangkat.

**Peringatan:** Perangkat harus didukung dan backend sudah ada. Untuk network, backend harus ditambahkan dulu via `netdev_add`.

### 4.10. Menambah Backend Jaringan: `netdev_add`

```json
{"execute": "netdev_add", "arguments": {"type": "user", "id": "net1"}, "id": 10}
```

### 4.11. Menghapus Perangkat: `device_del`

```json
{"execute": "device_del", "arguments": {"id": "net1dev"}, "id": 11}
```

Setelah itu, tunggu event `DEVICE_DELETED`.

### 4.12. Balloon: Mengubah Memori

```json
{"execute": "balloon", "arguments": {"value": 1073741824}, "id": 12}
```

- `value`: jumlah byte yang ingin dipertahankan. QEMU akan meminta guest mengembalikan memori hingga mencapai nilai ini.

### 4.13. Screenshot: `screendump`

```json
{"execute": "screendump", "arguments": {"filename": "/tmp/screen.ppm"}, "id": 13}
```

- `filename`: path output. Format PPM.

**Catatan:** Screenshot berfungsi jika ada perangkat display (VGA, virtio-gpu). Untuk headless murni, gunakan VNC atau spice.

### 4.14. Snapshot Blok: `blockdev-snapshot`

```json
{"execute": "blockdev-snapshot", "arguments": {"node": "virtio0", "overlay": "overlay-node"}, "id": 14}
```

**Peringatan:** Overlay harus sudah dibuat dan dibuka dengan `blockdev-add`.

### 4.15. Block Job: `blockdev-mirror`

```json
{"execute": "blockdev-mirror", "arguments": {"job-id": "mirror0", "device": "virtio0", "target": "backup-node", "sync": "full"}, "id": 15}
```

**Penjelasan:**
- `job-id`: ID job.
- `device`: perangkat sumber.
- `target`: node tujuan.
- `sync`: `full`, `top`, `none`.

### 4.16. Query Job

```json
{"execute": "query-block-jobs", "id": 16}
```

### 4.17. Migrasi: `migrate`

```json
{"execute": "migrate", "arguments": {"uri": "tcp:host2:4444"}, "id": 17}
```

- `uri`: tujuan migrasi.

### 4.18. Query Migrasi

```json
{"execute": "query-migrate", "id": 18}
```

### 4.19. HMP via QMP: `human-monitor-command`

```json
{"execute": "human-monitor-command", "arguments": {"command-line": "info status"}, "id": 19}
```

**Respons:**
```json
{"return": "VM status: running", "id": 19}
```

**Kegunaan:** Mengakses perintah HMP yang belum ada padanannya di QMP. Berguna untuk eksplorasi.

### 4.20. Event Asinkron

QEMU akan mengirim event tanpa diminta:
```json
{"event": "RESET", "data": {"guest": true}, "timestamp": {"seconds": 1234567890, "microseconds": 123456}}
{"event": "SHUTDOWN", "data": {"guest": true, "reason": "guest-shutdown"}, "timestamp": {...}}
{"event": "STOP", "data": {}, "timestamp": {...}}
{"event": "RESUME", "data": {}, "timestamp": {...}}
```

**Perhatikan:** Event tidak memiliki `id`. Klien harus membedakan respons (dengan `id`) dan event (tanpa `id`).

### 4.21. Keluar dari QEMU: `quit`

```json
{"execute": "quit", "id": 20}
```

QEMU akan keluar. VM berhenti.

### 4.22. Skrip Bash Sederhana untuk QMP

```bash
#!/bin/bash
SOCK=/tmp/qmp.sock

send_qmp() {
    local cmd="$1"
    echo "$cmd" | socat - UNIX-CONNECT:$SOCK
}

send_qmp '{"execute": "qmp_capabilities"}'
send_qmp '{"execute": "query-status", "id": 1}'
send_qmp '{"execute": "query-cpus-fast", "id": 2}'
```

**Penjelasan:**
- Fungsi `send_qmp` mengirim perintah JSON ke socket.
- `socat` menghubungkan stdin ke socket.
- Setiap perintah diikuti newline.

**Keterbatasan:** Setiap `socat` membuka koneksi baru. QMP hanya menerima satu klien pada satu waktu. Untuk skrip yang lebih baik, gunakan Python dengan `socket` atau library `qmp`.

### 4.23. Skrip Python untuk QMP

```python
#!/usr/bin/env python3
import json
import socket

SOCK_PATH = "/tmp/qmp.sock"

def qmp_connect(path):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    greeting = json.loads(sock.recv(65536).decode())
    print("Greeting:", greeting)
    # handshake
    sock.sendall(json.dumps({"execute": "qmp_capabilities"}).encode() + b"\n")
    resp = json.loads(sock.recv(65536).decode())
    print("Handshake:", resp)
    return sock

def qmp_command(sock, cmd, args=None, cmd_id=1):
    msg = {"execute": cmd, "id": cmd_id}
    if args:
        msg["arguments"] = args
    sock.sendall(json.dumps(msg).encode() + b"\n")
    return json.loads(sock.recv(65536).decode())

if __name__ == "__main__":
    sock = qmp_connect(SOCK_PATH)
    print(qmp_command(sock, "query-status"))
    print(qmp_command(sock, "query-cpus-fast"))
    print(qmp_command(sock, "query-block"))
    sock.close()
```

**Penjelasan:**
- `socket.AF_UNIX`: UNIX socket.
- `sock.connect`: koneksi.
- `greeting`: baca greeting.
- Handshake: kirim `qmp_capabilities`.
- `qmp_command`: kirim perintah, baca respons.
- **Catatan:** Untuk produksi, gunakan library seperti `qemu.qmp` dari QEMU.

### 4.24. qmp-shell: Alat Interaktif

QEMU menyediakan `qmp-shell` di `scripts/qmp/`. Jika Anda menginstal dari source, atau paket `qemu-tools`:

```bash
qmp-shell /tmp/qmp.sock
```

**Prompt:**
```
(QEMU) query-status
{"return": {"status": "running", "running": true}}
(QEMU) query-cpus-fast
...
(QEMU) quit
```

**Kegunaan:** Eksplorasi interaktif. Tidak untuk otomasi.

### 4.25. QEMU Guest Agent (QGA)

QGA adalah agen yang berjalan **di dalam guest**, memungkinkan host menjalankan perintah di guest via QMP:
- `guest-info`: info agen.
- `guest-shutdown`: shutdown guest.
- `guest-file-read`: baca file.
- `guest-exec`: jalankan perintah.
- `guest-fsfreeze`: freeze filesystem untuk snapshot konsisten.
- `guest-network-get-interfaces`: info jaringan.

**Menjalankan QGA di QEMU:**
```bash
-chardev socket,path=/tmp/qga.sock,server=on,wait=off,id=qga0 \
-device virtio-serial \
-device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0
```

Di guest, instal `qemu-guest-agent` dan jalankan. Host bisa berkomunikasi via QMP:
```json
{"execute": "guest-info"}
```

**Peringatan:** QGA tidak sama dengan QMP. QGA adalah perintah **guest**, QMP adalah perintah **host**. QGA diakses via QMP command `guest-*`.

---

## 5. Diagram Alur QMP & Arsitektur Komunikasi

### 5.1. Arsitektur QMP

```
+-------------------+         +-------------------+
|   Klien QMP       |         |   QEMU            |
|  (Python, Bash,   |<------->|   QMP server      |
|   qmp-shell)      |  JSON   |                   |
+-------------------+         +-------------------+
        |                             |
        |                             v
        |                     +-------------------+
        |                     |   VM (guest)      |
        |                     |   vCPU, devices   |
        |                     +-------------------+
        |
        v
+-------------------+
|   Event handler   |  <- Menerima event asinkron
+-------------------+
```

**Penjelasan:**
- Klien terhubung ke QMP socket.
- QEMU memproses perintah JSON.
- VM dikontrol melalui QEMU.
- Event dikirim ke klien.

### 5.2. Alur Handshake & Perintah

```
Klien                                     QEMU
  |                                         |
  |  connect ke socket                      |
  |---------------------------------------->|
  |                                         |
  |  greeting (QMP version)                 |
  |<----------------------------------------|
  |                                         |
  |  {"execute": "qmp_capabilities"}        |
  |---------------------------------------->|
  |                                         |
  |  {"return": {}}                         |
  |<----------------------------------------|
  |                                         |
  |  {"execute": "query-status", "id": 1}   |
  |---------------------------------------->|
  |                                         |
  |  {"return": {...}, "id": 1}             |
  |<----------------------------------------|
  |                                         |
  |  event RESET (asinkron)                 |
  |<----------------------------------------|
  |                                         |
```

### 5.3. Perbedaan QMP dan HMP

```
+-------------------+         +-------------------+
|   QMP             |         |   HMP             |
|  JSON-RPC 2.0     |         |   Teks            |
|  Stabil           |         |   Tidak stabil    |
|  Event            |         |   Terbatas        |
|  Otomasi          |         |   Manual          |
+-------------------+         +-------------------+
        |                             |
        |  human-monitor-command      |
        |<----------------------------|
        |                             |
        v                             v
+-------------------------------------------------+
|                   QEMU                          |
+-------------------------------------------------+
```

---

## 6. Audit Kurikulum: Tambahan QGA, QMP Events, QMP Shell, libvirt qemu-monitor-command, JSON-RPC 2.0

Kurikulum asli menyebut:
```bash
qemu-system-x86_64 ... -qmp unix:/tmp/qmp.sock,server,nowait
# di terminal lain
socat - UNIX-CONNECT:/tmp/qmp.sock
{"execute": "qmp_capabilities"}
{"execute": "query-status"}
Validasi: Mendapat respons JSON.
```

Saya menambahkan:

1. **JSON-RPC 2.0 spec** — dasar protokol. Memahami `id`, `execute`, `arguments`, `return`, `error`.
2. **Greeting dan handshake** — wajib sebelum perintah lain.
3. **OOB capability** — untuk perintah out-of-band.
4. **Event asinkron** — RESET, SHUTDOWN, STOP, RESUME, DEVICE_DELETED, dll.
5. **query-* commands** — query-status, query-cpus-fast, query-block, query-netdev, query-migrate.
6. **Kontrol VM** — stop, cont, system_reset, system_powerdown.
7. **device_add/device_del** — hotplug perangkat.
8. **netdev_add/netdev_del** — hotplug backend jaringan.
9. **balloon** — manajemen memori.
10. **screendump** — screenshot.
11. **blockdev-snapshot, blockdev-mirror, block-commit** — operasi blok live.
12. **block-job** — job I/O asinkron.
13. **migrate** — migrasi live.
14. **human-monitor-command** — akses HMP via QMP.
15. **quit** — keluar QEMU.
16. **QEMU Guest Agent (QGA)** — agen di guest.
17. **qmp-shell** — alat interaktif.
18. **libvirt `qemu-monitor-command`** — akses QMP via libvirt.
19. **Skrip Python** — menggunakan `socket` dan `json`.
20. **Library qemu.qmp** — library resmi QEMU untuk Python.
21. **Keamanan QMP** — socket permission, autentikasi, TLS (jika TCP).
22. **QMP via TCP** — dengan `-qmp tcp:...`.
23. **QMP dengan TLS** — `-qmp tls:...`.
24. **Preconfig mode** — `-preconfig` untuk konfigurasi sebelum VM jalan.
25. **QMP dan multifd migration** — untuk migrasi paralel.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 2.5, dengan lab tambahan untuk hotplug, block job, migrasi, dan QGA.

---

## 7. Hubungan dengan Modul Lain

- **Modul 2.1:** Boot VM pertama. QMP adalah cara mengontrolnya tanpa interaksi.
- **Modul 2.2:** qemu-img. QMP bisa melakukan snapshot live tanpa hentikan VM.
- **Modul 2.3:** Virtio. QMP bisa menambah/menghapus perangkat Virtio secara live.
- **Modul 2.4:** OVMF + vTPM. QMP bisa query TPM (`query-tpm`, `query-tpm-models`).
- **Fase 3:** libvirt menggunakan QMP untuk semua operasi VM. `virsh qemu-monitor-command` adalah jembatan.
- **Fase 4:** Block job untuk backup live, snapshot, dan mirror.
- **Fase 5:** QMP untuk hotplug network.
- **Fase 6:** QMP untuk audit, query, dan kontrol keamanan.
- **Fase 7:** Otomasi dengan skrip QMP.
- **Fase 8:** Migrasi live, observability, dan API.

---

## 8. Referensi Lengkap

- **QMP Specification** — https://www.qemu.org/docs/master/interop/qmp-spec.html
- **QEMU QMP Commands** — https://www.qemu.org/docs/master/interop/qemu-qmp-ref.html
- **QEMU Monitor** — https://www.qemu.org/docs/master/system/monitor.html
- **QEMU Guest Agent** — https://www.qemu.org/docs/master/interop/qemu-ga-ref.html
- **QGA Protocol** — https://www.qemu.org/docs/master/interop/qemu-ga.html
- **qemu.qmp Python library** — https://qemu.readthedocs.io/en/latest/interop/qemu-qmp-ref.html
- **QEMU Python library** — https://gitlab.com/qemu-project/qemu/-/tree/master/python
- **qmp-shell** — https://gitlab.com/qemu-project/qemu/-/blob/master/scripts/qmp/qmp-shell
- **libvirt qemu-monitor-command** — https://libvirt.org/manpages/virsh.html#qemu-monitor-command
- **JSON-RPC 2.0** — https://www.jsonrpc.org/specification
- **Arch Wiki: QEMU** — https://wiki.archlinux.org/title/QEMU
- **libvirt: QMP** — https://libvirt.org/drvqemu.html
- **QEMU block jobs** — https://www.qemu.org/docs/master/interop/live-block-operations.html
- **QEMU migration** — https://www.qemu.org/docs/master/interop/migration.html
- **QEMU TLS** — https://www.qemu.org/docs/master/system/tls.html
- **QEMU preconfig** — https://www.qemu.org/docs/master/system/qemu-manpage.html

---

## 9. Tips & Praktik Terbaik

1. **Selalu kirim `qmp_capabilities` setelah greeting.** Tanpa itu, perintah lain ditolak.
2. **Gunakan `id` unik untuk setiap perintah.** Memudahkan korelasi respons.
3. **Siapkan handler untuk event asinkron.** Event bisa datang kapan saja.
4. **Gunakan UNIX socket** untuk keamanan. TCP hanya jika perlu, dan gunakan TLS.
5. **Batasi permission socket.** `chmod 600` dan owner yang tepat.
6. **Jangan gunakan `human-monitor-command`** untuk produksi. Gunakan QMP native.
7. **Gunakan `query-*` untuk observability.**
8. **Gunakan `device_add`/`device_del`** untuk hotplug, tetapi ingat guest harus mendukung.
9. **Gunakan `blockdev-snapshot`** untuk snapshot live tanpa hentikan VM.
10. **Gunakan `block-job`** untuk operasi blok asinkron.
11. **Gunakan QGA** untuk operasi di dalam guest: shutdown, freeze, exec.
12. **Gunakan library Python** untuk skrip yang kompleks.
13. **Log semua perintah dan respons** untuk audit.
14. **Gunakan `qmp-shell`** untuk eksplorasi interaktif.
15. **Perhatikan versi QEMU.** Beberapa perintah hanya ada di versi tertentu.
16. **Gunakan `query-commands`** untuk melihat semua perintah yang tersedia.
17. **Gunakan `query-qmp-schema`** untuk melihat skema QMP.
18. **Untuk migrasi, gunakan `migrate` dan pantau `query-migrate`.**
19. **Untuk backup, gunakan `blockdev-mirror` atau `blockdev-backup`.**
20. **Selalu tutup koneksi dengan baik.** Beberapa klien bisa menyebabkan QEMU menunggu.
21. **Gunakan `-qmp` dengan `wait=off`** untuk memulai QEMU tanpa klien.
22. **Gunakan `-pidfile`** untuk melacak PID QEMU.
23. **Gunakan `-daemonize`** untuk menjalankan QEMU di background.
24. **Backup state vTPM** sebelum migrasi atau snapshot.
25. **Untuk production, gunakan libvirt.** QMP langsung lebih cocok untuk debugging dan otomasi ringan.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `Failed to connect to socket` | QEMU tidak berjalan atau socket path salah. | Cek `ps aux | grep qemu`. Cek `ls -l /tmp/qmp.sock`. |
| `QMP capabilities not negotiated` | Belum mengirim `qmp_capabilities`. | Kirim setelah greeting. |
| `Invalid JSON` | Format JSON salah. | Validasi dengan `jq`. |
| `Command not found` | Perintah tidak ada di versi QEMU. | `query-commands` untuk melihat yang tersedia. |
| Event tidak diterima | Klien tidak menangani event. | Baca socket terus-menerus, bedakan respons dan event. |
| `device_add` gagal | Driver tidak ada atau backend belum siap. | Cek `query-pci`, `query-netdev`. Tambah backend dulu. |
| `device_del` tidak selesai | Menunggu event `DEVICE_DELETED`. | Tunggu event, atau gunakan `query-pci` untuk verifikasi. |
| `blockdev-snapshot` gagal | Node tidak ada atau overlay belum dibuka. | Cek `query-block`, `blockdev-add`. |
| `migrate` gagal | Tujuan tidak siap, atau network salah. | Cek `query-migrate`, `migrate-incoming` di tujuan. |
| `screendump` gagal | Tidak ada display. | Gunakan VNC/SPICE, atau virtio-gpu. |
| QGA tidak terdeteksi | `qemu-guest-agent` tidak jalan di guest. | Instal dan jalankan di guest. Cek `query-ga`. |
| `quit` tidak menghentikan QEMU | QEMU dalam state yang tidak bisa keluar. | Kirim `stop` dulu, lalu `quit`. Atau kill PID. |
| QMP socket permission denied | Permission file socket. | `chmod 600`, owner yang tepat. |
| `human-monitor-command` gagal | Perintah HMP tidak valid. | Cek `help` di HMP. |
| Migrasi lambat | Bandwidth terbatas. | Gunakan `migrate-set-parameters` untuk tuning. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- QEMU berjalan dengan `-qmp unix:/tmp/qmp.sock,server=on,wait=off`.
- `socat - UNIX-CONNECT:/tmp/qmp.sock` menampilkan greeting.
- Setelah `qmp_capabilities`, perintah `query-status` mengembalikan `{"return": {"status": "running", ...}}`.
- `query-cpus-fast` mengembalikan daftar vCPU.
- `query-block` mengembalikan info disk.
- `stop` menghentikan VM. `cont` melanjutkan.
- `system_powerdown` mengirim ACPI shutdown.
- Event `SHUTDOWN` diterima saat guest shutdown.
- `device_add` menambahkan perangkat. `device_del` menghapus.
- `balloon` mengubah memori.
- `screendump` menghasilkan file PPM.
- `blockdev-snapshot` membuat snapshot live.
- `migrate` memindahkan VM ke host lain.
- `human-monitor-command` menjalankan HMP.
- `quit` menghentikan QEMU.
- QGA terdeteksi dengan `guest-info`.

**Troubleshooting:**
- Jika QMP socket tidak dibuat: cek log QEMU, pastikan `-qmp` diberikan.
- Jika greeting tidak muncul: cek permission socket, coba `socat -v`.
- Jika perintah ditolak: pastikan handshake.
- Jika event tidak terlihat: pastikan klien membaca terus-menerus.
- Jika device_add gagal: cek `query-pci` untuk bus yang tersedia.
- Jika blockdev-snapshot gagal: cek `query-named-block-nodes`.
- Jika migrasi gagal: cek `query-migrate` untuk error.
- Untuk debugging: gunakan `-trace events=/tmp/trace-events` dengan `enable=qmp_*`.
- Untuk melihat semua perintah: `query-commands`.
- Untuk melihat skema: `query-qmp-schema`.
- Untuk QGA: cek `query-ga` di guest.

---

## 12. Latihan Mandiri

1. Jalankan QEMU dengan QMP socket UNIX dan `-daemonize`.
2. Terhubung dengan `socat`. Catat greeting.
3. Kirim `qmp_capabilities`. Kirim `query-status`.
4. Kirim `query-cpus-fast`, `query-block`, `query-netdev`.
5. Kirim `stop`, cek status, kirim `cont`.
6. Kirim `system_reset`, amati event `RESET`.
7. Kirim `system_powerdown`, amati event `SHUTDOWN`.
8. Tambahkan disk baru dengan `blockdev-add` dan `device_add`.
9. Hapus disk dengan `device_del`. Tunggu `DEVICE_DELETED`.
10. Buat snapshot dengan `blockdev-snapshot`.
11. Lakukan `blockdev-mirror` ke file backup.
12. Lakukan `screendump` (jika ada display).
13. Kirim `balloon` untuk mengubah memori.
14. Kirim `human-monitor-command` dengan `info status`.
15. Tulis skrip Python untuk mengirim perintah QMP.
16. Jalankan QGA di guest, akses via `guest-info`.
17. Lakukan migrasi ke host kedua (jika ada) dengan `migrate`.
18. Kirim `quit` untuk menghentikan QEMU.
19. Tulis ringkasan: kapan menggunakan QMP langsung, kapan libvirt.

---

## Penutup Modul 2.5

Anda kini menguasai QMP: protokol kontrol runtime QEMU berbasis JSON-RPC 2.0. Anda bisa mengontrol VM tanpa henti, menambah/menghapus perangkat secara live, melakukan snapshot, migrasi, dan berinteraksi dengan QGA. Ini adalah fondasi untuk Fase 3 (libvirt) dan Fase 7 (otomasi).

---

## Penutup Fase 2

Selamat! Anda telah menyelesaikan seluruh Modul 2.1 hingga 2.5. Fase 2 sudah lengkap. Anda sekarang memiliki:
- Kemampuan menjalankan VM QEMU/KVM murni.
- Penguasaan `qemu-img` untuk manajemen disk.
- Pemahaman Virtio vs emulasi.
- Kemampuan menggunakan OVMF + vTPM.
- Kemampuan mengontrol VM via QMP.

**Proyek Fase 2:** Jalankan VM Arch dengan:
- Disk Virtio-blk qcow2.
- NIC Virtio-net dengan user-mode networking.
- Firmware OVMF.
- vTPM dengan swtpm.
- QMP socket untuk kontrol.
- Dokumentasikan setiap flag, setiap file, dan setiap langkah.

**Rubrik Fase 2:**
| Kriteria | Bobot |
|---|---|
| Boot VM | 20% |
| qemu-img | 20% |
| Virtio | 20% |
| OVMF+vTPM | 20% |
| QMP | 20% |

---

# Selamat!
Anda telah menyelesaikan Fase ini

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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

