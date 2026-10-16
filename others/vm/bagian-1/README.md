## Audit Awal Kurikulum

Sebelum masuk ke materi, hasil audit kurikulum ini sudah sangat baik: terstruktur, memiliki lab, validasi, troubleshooting, referensi, dan rubrik. Namun, ada beberapa hal yang bisa diperdalam atau ditambahkan agar benar-benar komprehensif dan tidak meloncat:

1. **Fase 1** belum menyentuh aspek *host hardening* tingkat lanjut: microcode, mitigasi CPU (Spectre/Meltdown), `auditd`, `AIDE`, `systemd-cryptenroll`, TPM host, Secure Boot host, dan kernel command line hardening.
2. **Fase 2** belum membahas QEMU tracing, `-trace`, `-d`, dan analisis performa dasar.
3. **Fase 3** belum membahas `virsh` event loop, `virsh qemu-monitor-command`, dan interaksi langsung dengan QMP via libvirt.
4. **Fase 4** belum membahas `qemu-img amend`, `qemu-img rebase`, dan manajemen backing chain yang kompleks.
5. **Fase 5** belum membahas IPv6, DNS, DHCP, SLAAC, `nftables` untuk forwarding/NAT, conntrack, dan `firewalld`/`ufw` sebagai alternatif.
6. **Fase 6** belum membahas `landlock`, `seccomp` profiling, `cgroups v2` delegation, user namespaces, idmapped mounts, dan `systemd` sandboxing untuk QEMU.
7. **Fase 7** belum membahas `packer`, `terraform`, `ansible` untuk provisioning, dan `virt-builder`.
8. **Fase 8** belum membahas vGPU, mediated devices, vDPA, DPDK, SR-IOV VF, PTP, real-time, CPU isolation (`isolcpus`, `nohz_full`, `rcu_nocbs`), dan observability dengan eBPF.

Kita akan memasukkan tambahan-tambahan ini secara bertahap saat membahas modul terkait, sambil tetap mengacu pada kurikulum asli. Sekarang, mari kita mulai dari bagian paling awal.

---

# Fase 1 — Fondasi Virtualisasi & Host Hardening

## Overview Fase 1

Fase ini adalah fondasi mutlak. Tanpa pemahaman yang benar tentang hardware, kernel, dan daemon virtualisasi, semua fase berikutnya akan rapuh. Fase ini menekankan **headless**, **minimalis**, dan **keamanan**. Anda akan belajar mengaudit hardware, menginstal stack virtualisasi tanpa GUI, mengaktifkan daemon libvirt dengan socket activation, mengakses `virsh` sebagai non-root, dan menerapkan baseline firewall `nftables`.

**Estimasi:** 1 minggu (8–10 jam).

**Prasyarat:** Arch Linux terpasang, akses root/sudo, dasar CLI & systemd.



<details>
  <summary>📃 Daftar Isi Fase 1*</summary>

---

1. Modul 1.1 — Audit Hardware & Kernel
2. Modul 1.2 — Instalasi Stack Headless Minimal
3. Modul 1.3 — Daemon libvirt & Systemd Socket Activation
4. Modul 1.4 — Akses virsh Non-Root via Polkit & Grup
5. Modul 1.5 — Baseline nftables Host
6. Proyek Fase 1
7. Rubrik Fase 1

</details>

---

## Modul 1.1 — Audit Hardware & Kernel

### Struktur Pembelajaran Internal (Mini-Daftar Isi)
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Inisialisasi KVM
6. Hubungan dengan Modul Lain
7. Referensi Lengkap
8. Tips & Praktik Terbaik
9. Potensi Kesalahan Umum & Solusi
10. Validasi & Troubleshooting (diperluas)
11. Latihan Mandiri

---

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah gerbang pertama. Anda akan memeriksa apakah CPU mendukung virtualisasi hardware (VT-x/AMD-V), apakah IOMMU aktif (VT-d/AMD-Vi), apakah modul kernel KVM termuat, dan apakah device node `/dev/kvm` tersedia dengan permission yang benar. Ini penting karena tanpa dukungan hardware, virtualisasi akan berjalan lambat (emulasi penuh) atau tidak bisa dilakukan sama sekali. Selain itu, IOMMU diperlukan untuk isolasi perangkat dan passthrough di Fase 8. Modul ini juga memperkenalkan `virt-host-validate`, alat validasi dari libvirt yang akan sering digunakan.

**Peran:** Menjamin bahwa host siap secara hardware dan kernel sebelum instalasi paket. Ini mencegah frustrasi di modul berikutnya.

---

### 2. Konsep Kunci & Filosofi Mendalam

- **Virtualisasi Hardware:** CPU modern memiliki ekstensi khusus yang memungkinkan hypervisor menjalankan instruksi guest secara langsung (near-native). Intel menyebutnya VT-x (Virtualization Technology for x86), AMD menyebutnya AMD-V (AMD Virtualization). Tanpa ini, QEMU harus mengemulasi setiap instruksi, yang sangat lambat.
- **IOMMU:** Input-Output Memory Management Unit adalah unit yang menerjemahkan alamat memori untuk perangkat I/O. Ini memungkinkan isolasi DMA (Direct Memory Access) sehingga perangkat fisik dapat di-passthrough ke VM dengan aman. Intel menyebutnya VT-d (Virtualization Technology for Directed I/O), AMD menyebutnya AMD-Vi.
- **KVM:** Kernel-based Virtual Machine adalah modul kernel Linux yang menyediakan infrastruktur virtualisasi. Ia mengubah kernel Linux menjadi hypervisor. QEMU berinteraksi dengan KVM melalui `/dev/kvm` untuk menjalankan vCPU.
- **Modul Kernel:** Potongan kode yang dapat dimuat ke kernel saat runtime. `kvm`, `kvm_intel`, `kvm_amd` adalah modul yang relevan.
- **Device Node:** File khusus di `/dev` yang merepresentasikan perangkat. `/dev/kvm` adalah antarmuka ke KVM.
- **Filosofi:** Kontrol penuh melalui CLI, minimalis, dan aman. Audit dulu, baru instalasi. Jangan asal pasang.

---

### 3. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **VT-x** | Ekstensi virtualisasi Intel. | Flag CPU: `vmx`. |
| **AMD-V** | Ekstensi virtualisasi AMD. | Flag CPU: `svm`. |
| **IOMMU** | Unit manajemen memori untuk I/O. | Intel VT-d, AMD-Vi. |
| **DMA** | Direct Memory Access; perangkat mengakses memori tanpa CPU. | Rentan jika tidak diisolasi. |
| **KVM** | Kernel-based Virtual Machine. | Modul: `kvm`, `kvm_intel`, `kvm_amd`. |
| **QEMU** | Emulator dan virtualizer. | Proses userspace. |
| **dmesg** | Buffer pesan kernel. | `dmesg | grep -i iommu`. |
| **lsmod** | List modul kernel. | `lsmod | grep kvm`. |
| **lscpu** | Menampilkan info CPU. | `lscpu | grep -E 'vmx|svm'`. |
| **/dev/kvm** | Device node untuk KVM. | Permission `crw-rw----`. |
| **virt-host-validate** | Alat validasi host libvirt. | `virt-host-validate qemu`. |

---

### 4. Sintaks Dasar / Contoh Implementasi Inti

Berikut adalah perintah-perintah dari Lab L1.1, dengan penjelasan kata demi kata.

#### Perintah 1: Cek flag CPU
```bash
lscpu | grep -E 'vmx|svm'
```
- `lscpu`: perintah untuk menampilkan informasi arsitektur CPU.
- `|`: pipe; mengalirkan output `lscpu` ke `grep`.
- `grep`: mencari baris yang cocok dengan pola.
- `-E`: menggunakan extended regular expression, sehingga `|` berfungsi sebagai OR.
- `'vmx|svm'`: pola; `vmx` untuk Intel VT-x, `svm` untuk AMD-V.
- **Output yang diharapkan:** Baris `Flags: ... vmx ...` atau `... svm ...`. Jika muncul, CPU mendukung virtualisasi hardware.

#### Perintah 2: Cek IOMMU
```bash
dmesg | grep -i -e DMAR -e IOMMU
```
- `dmesg`: menampilkan pesan kernel (ring buffer).
- `|`: pipe.
- `grep`: filter.
- `-i`: case-insensitive.
- `-e DMAR`: pola untuk DMA Remapping (Intel).
- `-e IOMMU`: pola untuk IOMMU (umum/AMD).
- **Output yang diharapkan:** Pesan seperti `DMAR: IOMMU enabled` atau `AMD-Vi: Interrupt remapping enabled`. Jika tidak muncul, IOMMU mungkin belum diaktifkan di BIOS/UEFI atau kernel cmdline.

#### Perintah 3: Cek modul KVM
```bash
lsmod | grep kvm
```
- `lsmod`: menampilkan daftar modul kernel yang sedang dimuat.
- `|`: pipe.
- `grep kvm`: filter baris yang mengandung `kvm`.
- **Output yang diharapkan:** `kvm`, `kvm_intel` (Intel) atau `kvm_amd` (AMD). Jika hanya `kvm` tanpa yang spesifik, mungkin modul vendor belum dimuat.

#### Perintah 4: Cek /dev/kvm
```bash
ls -l /dev/kvm
```
- `ls -l`: list file dengan format panjang (permission, owner, group, ukuran, tanggal, nama).
- `/dev/kvm`: path device node.
- **Output yang diharapkan:** `crw-rw---- 1 root kvm 10, 232 ... /dev/kvm`. `c` berarti character device. Permission `rw` untuk root dan group `kvm`. Jika tidak ada, berarti KVM tidak aktif atau device node belum dibuat.

#### Perintah 5: Validasi host (setelah instalasi libvirt)
```bash
virt-host-validate qemu
```
- `virt-host-validate`: alat dari paket `libvirt` untuk memeriksa apakah host siap untuk virtualisasi.
- `qemu`: target driver yang diperiksa.
- **Output yang diharapkan:** Serangkaian `PASS` atau `FAIL`. Idealnya semua `PASS`. Jika ada `FAIL`, ikuti saran perbaikan.

---

### 5. Diagram Alur Inisialisasi KVM

```
+-------------------+       +-------------------+       +-------------------+
|   Userspace       |       |   Kernel          |       |   Hardware        |
|   (QEMU)          |       |   (Linux)         |       |   (CPU)           |
+-------------------+       +-------------------+       +-------------------+
          |                           |                           |
          |  ioctl(/dev/kvm)          |                           |
          |-------------------------->|                           |
          |                           |  kvm_intel/kvm_amd        |
          |                           |-------------------------->|
          |                           |                           |  VT-x/AMD-V
          |                           |                           |  (VMCS/VMCB)
          |                           |<--------------------------|
          |<--------------------------|                           |
          |  menjalankan vCPU         |                           |
          |                           |                           |
```

**Penjelasan:**
- QEMU membuka `/dev/kvm` dan mengirim ioctl untuk membuat VM dan vCPU.
- Kernel memuat modul `kvm` dan `kvm_intel`/`kvm_amd`.
- Modul berinteraksi dengan fitur hardware VT-x/AMD-V melalui struktur data seperti VMCS (Intel) atau VMCB (AMD).
- Hardware menjalankan instruksi guest secara native.

---

### 6. Hubungan dengan Modul Lain

- **Modul 1.2:** Setelah audit, Anda akan menginstal paket yang diperlukan. Jika audit gagal, instalasi tidak akan berguna.
- **Fase 2:** Pemahaman tentang `/dev/kvm` dan modul KVM krusial saat menjalankan QEMU murni dengan `-enable-kvm`.
- **Fase 6:** IOMMU akan menjadi prasyarat untuk isolasi perangkat dan passthrough.
- **Fase 8:** VFIO/IOMMU passthrough membutuhkan IOMMU yang aktif dan terkonfigurasi.

---

### 7. Referensi Lengkap

- **Arch Wiki: KVM** — https://wiki.archlinux.org/title/KVM
- **Arch Wiki: PCI passthrough via OVMF** — https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
- **Linux Kernel Documentation: KVM** — https://www.kernel.org/doc/html/latest/virt/kvm/index.html
- **Linux Kernel Documentation: IOMMU** — https://www.kernel.org/doc/html/latest/driver-api/iommu.html
- **libvirt: virt-host-validate** — https://libvirt.org/manpages/virt-host-validate.html
- **Intel VT-x** — https://www.intel.com/content/www/us/en/virtualization/virtualization-technology/intel-virtualization-technology.html
- **AMD-V** — https://www.amd.com/en/technologies/virtualization

---

### 8. Tips & Praktik Terbaik

- **Aktifkan VT-x/AMD-V dan IOMMU di BIOS/UEFI.** Ini langkah pertama yang paling sering terlupakan.
- **Update microcode CPU.** Di Arch: `sudo pacman -S intel-ucode` atau `amd-ucode`, lalu update bootloader.
- **Gunakan kernel cmdline untuk IOMMU.** Tambahkan `intel_iommu=on` atau `amd_iommu=on` jika perlu. Untuk passthrough, tambahkan `iommu=pt`.
- **Cek `journalctl -k`** untuk pesan kernel yang lebih lengkap.
- **Gunakan `cpuid`** untuk melihat flag CPU secara detail: `cpuid | grep -i vmx`.
- **Pastikan Secure Boot tidak menghalangi.** Beberapa modul kernel mungkin tidak ditandatangani; namun KVM biasanya aman.
- **Simpan hasil audit** ke file: `lscpu > audit-cpu.txt`, `dmesg > audit-dmesg.txt`.

---

### 9. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Flag `vmx`/`svm` tidak muncul | Virtualisasi dinonaktifkan di BIOS/UEFI | Masuk BIOS/UEFI, aktifkan Intel VT-x/AMD-V |
| `dmesg` tidak menampilkan IOMMU | IOMMU belum diaktifkan di BIOS atau kernel cmdline | Aktifkan VT-d/AMD-Vi di BIOS, tambahkan `intel_iommu=on` atau `amd_iommu=on` |
| `/dev/kvm` tidak ada | Modul KVM tidak dimuat | `sudo modprobe kvm_intel` atau `kvm_amd`; cek `dmesg` untuk error |
| Permission `/dev/kvm` salah | User tidak berada di grup `kvm` | `sudo usermod -aG kvm $USER`, logout/login |
| `virt-host-validate` gagal | Berbagai alasan | Baca pesan error, biasanya tentang IOMMU, modul, atau permission |

---

### 10. Validasi & Troubleshooting (Diperluas)

**Validasi Lulus:**
- `lscpu | grep -E 'vmx|svm'` menghasilkan output.
- `dmesg | grep -i -e DMAR -e IOMMU` menghasilkan output (jika IOMMU diaktifkan).
- `lsmod | grep kvm` menampilkan `kvm` dan `kvm_intel`/`kvm_amd`.
- `ls -l /dev/kvm` menunjukkan permission `crw-rw----` dan group `kvm`.
- `virt-host-validate qemu` semua `PASS`.

**Troubleshooting Tambahan:**
- Jika `virt-host-validate` gagal pada IOMMU: pastikan `intel_iommu=on` atau `amd_iommu=on` ada di `/proc/cmdline`. Cek dengan `cat /proc/cmdline`.
- Jika modul tidak dimuat otomatis: tambahkan ke `/etc/modules-load.d/kvm.conf`.
- Jika `/dev/kvm` permission tidak sesuai: buat aturan udev atau tambahkan user ke grup `kvm`.
- Untuk melihat apakah CPU mendukung IOMMU: `dmesg | grep -i "DMAR"` atau `dmesg | grep -i "AMD-Vi"`.

---

### 11. Latihan Mandiri

1. Jalankan semua perintah audit dan simpan outputnya ke file `audit-host.txt`.
2. Bandingkan hasil `lscpu` dengan spesifikasi CPU Anda.
3. Jika IOMMU belum aktif, coba aktifkan di BIOS dan kernel cmdline, lalu reboot dan verifikasi.
4. Jalankan `virt-host-validate qemu` dan catat setiap `FAIL`. Cari solusinya di Arch Wiki.
5. Buat diagram alur inisialisasi KVM dengan tangan Anda sendiri (atau ASCII) dan jelaskan setiap langkah.

---

# Modul 1.2 — Instalasi Stack Headless Minimal

## Mini-Daftar Isi Modul 1.2
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Arsitektur Stack Virtualisasi Headless
6. Audit Kurikulum: Paket yang Hilang atau Perlu Ditambahkan
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah langkah eksekusi pertama setelah audit hardware. Di sini Anda akan memasang seluruh paket yang dibutuhkan untuk menjalankan VM secara headless (tanpa GUI) di Arch Linux. Paket yang dipasang mencakup:

- **QEMU** sebagai emulator dan virtualizer.
- **libvirt** sebagai API, daemon, dan alat manajemen.
- **virt-install** sebagai CLI provisioning VM.
- **edk2-ovmf** sebagai firmware UEFI.
- **swtpm** sebagai emulator TPM virtual.
- **nftables** sebagai firewall host.

Modul ini juga menekankan **minimalisme**: tidak memasang `virt-manager`, `gnome-boxes`, atau alat GUI lain yang memperbesar permukaan serangan dan menambah dependensi. Prinsipnya: kendali penuh via terminal, isolasi kuat, dan efisiensi resource.

**Peran:** Menyediakan semua binari dan library yang akan digunakan di Fase 2 hingga Fase 8. Tanpa instalasi yang benar, `virsh`, `qemu-system-x86_64`, `virt-install`, dan `nft` tidak akan tersedia.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **Headless:** Sistem berjalan tanpa server grafis (X11/Wayland). Semua interaksi melalui terminal, SSH, atau serial console. Keuntungan: resource lebih kecil, permukaan serangan lebih sempit, dan otomasi lebih mudah.
- **Minimalis:** Hanya pasang paket yang benar-benar diperlukan. Setiap paket tambahan adalah potensi bug dan celah keamanan.
- **Modular:** libvirt modern dipecah menjadi daemon-daemon kecil (`virtqemud`, `virtnetworkd`, `virtstoraged`, dll.) yang diaktifkan sesuai kebutuhan melalui socket activation.
- **Kontrol:** CLI memberikan kontrol granular. Anda dapat melihat setiap flag, setiap file konfigurasi, dan setiap proses.
- **Filosofi Arch:** `pacman` adalah package manager yang sederhana, cepat, dan transparan. Anda bertanggung jawab penuh atas sistem Anda.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **pacman** | Package manager Arch Linux. | `sudo pacman -S paket`. |
| **Repositori** | Kumpulan paket yang dikelola resmi. | `core`, `extra`, `multilib`. |
| **qemu-full** | Paket QEMU lengkap dengan semua target emulasi dan alat. | Termasuk `qemu-img`, `qemu-nbd`, dll. |
| **libvirt** | API, daemon, dan alat manajemen virtualisasi. | Menyediakan `virsh`, `virt-host-validate`. |
| **virt-install** | CLI untuk membuat dan menginstal VM. | Bagian dari paket `virt-install`. |
| **edk2-ovmf** | Firmware UEFI open-source untuk QEMU. | File: `OVMF_CODE.fd`, `OVMF_VARS.fd`. |
| **swtpm** | Software TPM emulator. | Menyediakan vTPM untuk guest. |
| **nftables** | Framework firewall modern Linux. | Menggantikan iptables, ip6tables, arptables, ebtables. |
| **GUI** | Graphical User Interface. | `virt-manager`, `gnome-boxes`, `virt-viewer`. |
| **Headless** | Tanpa GUI. | Hanya terminal. |
| **Socket activation** | Systemd mengaktifkan daemon saat ada koneksi ke socket. | `virtqemud.socket`. |
| **Dependency** | Paket lain yang dibutuhkan agar suatu paket berfungsi. | `libvirt` butuh `qemu`, `dnsmasq`, dll. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Update Sistem Terlebih Dahulu

```bash
sudo pacman -Syu
```

**Penjelasan kata demi kata:**
- `sudo`: SuperUser DO. Menjalankan perintah sebagai root.
- `pacman`: Package Manager Arch Linux.
- `-S`: Sync. Sinkronisasi database paket dengan repositori.
- `-y`: Refresh. Memperbarui database paket.
- `-u`: Upgrade. Memperbarui semua paket yang sudah terinstal ke versi terbaru.
- **Mengapa?** Di Arch, melakukan instalasi tanpa update penuh dapat menyebabkan *partial upgrade* yang berisiko merusak sistem. Selalu `-Syu` sebelum instalasi baru.

### 4.2. Instalasi Paket Utama

```bash
sudo pacman -S qemu-full libvirt virt-install edk2-ovmf swtpm nftables
```

**Penjelasan kata demi kata:**
- `sudo`: jalankan sebagai root.
- `pacman`: package manager.
- `-S`: Sync/install. Menginstal paket dari repositori.
- `qemu-full`: paket QEMU lengkap. Berisi emulator untuk berbagai arsitektur, `qemu-img`, `qemu-nbd`, `qemu-system-x86_64`, dan alat lainnya. Jika Anda ingin lebih minimal, bisa gunakan `qemu-base` + `qemu-system-x86_64`, tetapi untuk pembelajaran, `qemu-full` menyediakan semua yang diperlukan.
- `libvirt`: API, daemon, dan alat manajemen. Menyediakan `virsh`, `virt-host-validate`, library `libvirt.so`, dan daemon modular.
- `virt-install`: CLI untuk provisioning VM. Menyediakan `virt-install`, `virt-clone`, dan alat terkait.
- `edk2-ovmf`: firmware UEFI untuk QEMU. Menyediakan file `OVMF_CODE.fd` dan `OVMF_VARS.fd` di `/usr/share/edk2/x64/`.
- `swtpm`: Software TPM emulator. Menyediakan `swtpm` dan `swtpm_setup`.
- `nftables`: firewall modern. Menyediakan `nft` dan service `nftables`.

**Catatan:** `pacman` akan menanyakan konfirmasi. Tekan `Y` lalu Enter. Jika ada konflik paket, baca pesan dengan cermat.

### 4.3. Opsional: Instalasi dengan `--needed`

```bash
sudo pacman -S --needed qemu-full libvirt virt-install edk2-ovmf swtpm nftables
```

- `--needed`: hanya instal paket yang belum terinstal. Menghindari reinstalasi paket yang sudah ada. Berguna untuk idempotensi.

### 4.4. Verifikasi Tidak Ada GUI yang Terinstal

```bash
pacman -Qq | grep -E 'virt-manager|gnome-boxes'
```

**Penjelasan kata demi kata:**
- `pacman`: package manager.
- `-Q`: Query. Menanyakan database paket lokal.
- `-q`: Quiet. Hanya menampilkan nama paket, tanpa versi.
- `|`: pipe. Mengalirkan output ke perintah berikutnya.
- `grep`: mencari pola.
- `-E`: Extended regex. Memungkinkan penggunaan `|` sebagai OR.
- `'virt-manager|gnome-boxes'`: pola yang dicari.
- **Output yang diharapkan:** Tidak ada output. Jika ada output, berarti paket GUI terinstal. Hapus dengan:
  ```bash
  sudo pacman -Rns virt-manager gnome-boxes
  ```
  - `-R`: Remove.
  - `-n`: Nosave. Hapus file konfigurasi.
  - `-s`: Recursive. Hapus dependensi yang tidak lagi diperlukan.

### 4.5. Cek Versi Klien

```bash
virsh --version
virt-install --version
qemu-system-x86_64 --version
nft --version
```

**Penjelasan:**
- `virsh --version`: menampilkan versi klien `virsh`. Tidak perlu daemon berjalan.
- `virt-install --version`: versi `virt-install`.
- `qemu-system-x86_64 --version`: versi QEMU untuk target x86_64.
- `nft --version`: versi nftables.
- **Catatan:** `virsh version` (tanpa `--`) akan mencoba terhubung ke hypervisor. Karena daemon libvirt belum dijalankan di modul ini, perintah itu bisa gagal. Gunakan `virsh --version` untuk sementara.

---

## 5. Diagram Arsitektur Stack Virtualisasi Headless

```
+-------------------------------------------------------------+
|                        Userspace Tools                      |
|  virsh  |  virt-install  |  qemu-system-x86_64  |  qemu-img  |
+-------------------------------------------------------------+
|                           libvirt                           |
|  API  |  Daemon modular: virtqemud, virtnetworkd, ...       |
+-------------------------------------------------------------+
|                            QEMU                             |
|  Emulator & virtualizer, device models, QMP                 |
+-------------------------------------------------------------+
|                            KVM                              |
|  /dev/kvm, modul kernel kvm_intel/kvm_amd                   |
+-------------------------------------------------------------+
|                         Hardware                            |
|  CPU VT-x/AMD-V, IOMMU, RAM, Disk, NIC                      |
+-------------------------------------------------------------+

Firmware & TPM:
+-------------------+   +-------------------+
|   edk2-ovmf       |   |      swtpm        |
|  OVMF_CODE.fd     |   |  emulator TPM     |
|  OVMF_VARS.fd     |   |                   |
+-------------------+   +-------------------+

Firewall:
+-------------------+
|     nftables      |
|  nft, ruleset     |
+-------------------+
```

**Penjelasan:**
- Lapisan bawah adalah hardware.
- KVM adalah modul kernel yang memanfaatkan fitur hardware.
- QEMU adalah proses userspace yang berinteraksi dengan KVM.
- libvirt mengelola QEMU melalui API dan daemon.
- Userspace tools adalah CLI yang Anda gunakan sehari-hari.
- Firmware dan TPM adalah komponen pendukung untuk VM modern.
- nftables adalah firewall host yang terpisah dari stack virtualisasi.

---

## 6. Audit Kurikulum: Paket yang Hilang atau Perlu Ditambahkan

Setelah membaca seluruh kurikulum, ada beberapa paket yang disebutkan di fase lanjut tetapi tidak ada di daftar instalasi Fase 1. Sebaiknya Anda menginstalnya sekarang atau saat memasuki fase terkait.

| Paket | Digunakan di | Alasan |
|---|---|---|
| **libguestfs** | Fase 4 (guestfish, guestmount, virt-sysprep, virt-customize) | Alat untuk mengedit disk offline. |
| **virt-top** | Fase 3 (monitoring) | Monitoring VM secara real-time. |
| **python-libvirt** | Fase 8 (API libvirt) | Binding Python untuk libvirt. |
| **audit** | Fase 6 (audit & logging) | Audit sistem. |
| **dnsmasq** | Fase 5 (jaringan libvirt) | DHCP/DNS untuk network libvirt. Biasanya dependensi libvirt, tapi pastikan. |
| **iptables-nft** | Fase 5 (kompatibilitas) | libvirt mungkin membutuhkan untuk beberapa fitur. |
| **ebtables** | Fase 5 (nwfilter) | Beberapa filter MAC. |
| **swtpm-tools** | Fase 2 | Alat tambahan swtpm. |
| **ovmf** | Sudah tercakup di edk2-ovmf | — |

**Rekomendasi:** Instal `libguestfs` dan `virt-top` sekarang agar tidak lupa:
```bash
sudo pacman -S libguestfs virt-top python-libvirt audit dnsmasq
```
Catatan: `libguestfs` mungkin membutuhkan kernel dan modul tambahan. Pastikan Anda membaca pesan pacman.

---

## 7. Hubungan dengan Modul Lain

- **Modul 1.3:** Setelah paket terinstal, Anda akan mengaktifkan daemon libvirt dengan socket activation.
- **Modul 1.4:** Anda akan menambahkan user ke grup `libvirt` dan mengakses `virsh` non-root.
- **Modul 1.5:** `nftables` akan dikonfigurasi sebagai baseline firewall.
- **Fase 2:** QEMU murni akan menggunakan `qemu-system-x86_64`, `qemu-img`, dan `swtpm`.
- **Fase 3:** `libvirt` dan `virt-install` akan menjadi tulang punggung.
- **Fase 4:** `libguestfs` akan digunakan untuk edit disk offline.
- **Fase 6:** `audit` akan digunakan untuk logging.
- **Fase 8:** `python-libvirt` akan digunakan untuk API.

---

## 8. Referensi Lengkap

- **Arch Wiki: pacman** — https://wiki.archlinux.org/title/pacman
- **Arch Wiki: QEMU** — https://wiki.archlinux.org/title/QEMU
- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/libvirt
- **Arch Wiki: OVMF** — https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface
- **Arch Wiki: swtpm** — https://wiki.archlinux.org/title/Trusted_Platform_Module
- **Arch Wiki: nftables** — https://wiki.archlinux.org/title/Nftables
- **Arch Wiki: libguestfs** — https://wiki.archlinux.org/title/Libguestfs
- **QEMU Documentation** — https://www.qemu.org/documentation/
- **libvirt Documentation** — https://libvirt.org/docs.html
- **nftables Wiki** — https://wiki.nftables.org/

---

## 9. Tips & Praktik Terbaik

1. **Selalu `pacman -Syu` sebelum instalasi.** Ini mencegah partial upgrade.
2. **Gunakan `--needed`** untuk idempotensi.
3. **Periksa paket sebelum instalasi:** `pacman -Si qemu-full` untuk melihat info.
4. **Lihat file yang disediakan paket:** `pacman -Ql libvirt | grep bin` untuk melihat binari.
5. **Cari paket:** `pacman -Ss virtualisasi`.
6. **Hindari GUI.** Jika Anda membutuhkan viewer grafis, gunakan `virt-viewer` hanya saat benar-benar perlu, lalu hapus.
7. **Simpan daftar paket eksplisit:** `pacman -Qe > packages.txt`.
8. **Gunakan `pacman -Qo /usr/bin/virsh`** untuk mengetahui paket pemilik file.
9. **Baca pesan pacman.** Kadang ada peringatan tentang konfigurasi atau dependensi opsional.
10. **Pertimbangkan `qemu-base`** jika Anda ingin lebih minimal. Ganti `qemu-full` dengan `qemu-base` dan `qemu-system-x86_64` jika paket terpisah tersedia.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `error: target not found: qemu-full` | Repositori belum di-refresh atau paket tidak ada. | Jalankan `sudo pacman -Syu`. Pastikan repo `extra` aktif di `/etc/pacman.conf`. |
| Konflik paket `iptables` vs `nftables` | Keduanya menyediakan firewall. | Arch modern menggunakan `iptables-nft`. Jika ada konflik, baca pesan dan pilih `iptables-nft`. |
| `virsh: command not found` | `libvirt` belum terinstal atau PATH salah. | Instal `libvirt`. Cek `pacman -Ql libvirt | grep virsh`. |
| `virt-install: command not found` | Paket `virt-install` belum terinstal. | `sudo pacman -S virt-install`. |
| `swtpm: command not found` | Paket `swtpm` belum terinstal. | `sudo pacman -S swtpm`. |
| `nft: command not found` | Paket `nftables` belum terinstal. | `sudo pacman -S nftables`. |
| `virsh version` gagal connect | Daemon libvirt belum berjalan. | Gunakan `virsh --version` untuk sementara, atau lanjut ke Modul 1.3. |
| `libguestfs` gagal build | Butuh modul kernel atau konfigurasi. | Baca pesan error. Pastikan `linux` headers terinstal. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `pacman -Qq | grep -E 'virt-manager|gnome-boxes'` tidak menghasilkan output.
- `virsh --version` menampilkan versi.
- `virt-install --version` menampilkan versi.
- `qemu-system-x86_64 --version` menampilkan versi.
- `nft --version` menampilkan versi.
- `swtpm --version` menampilkan versi.
- `ls /usr/share/edk2/x64/` menampilkan `OVMF_CODE.fd` dan `OVMF_VARS.fd`.

**Troubleshooting:**
- Jika `pacman` lambat: ganti mirror dengan `reflector`.
- Jika keyring error: `sudo pacman -Sy archlinux-keyring`.
- Jika paket tidak ditemukan: pastikan repo `extra` tidak dikomentari di `/etc/pacman.conf`.
- Jika ingin menghapus GUI yang tidak sengaja terinstal: `sudo pacman -Rns virt-manager gnome-boxes virt-viewer`.
- Jika `libguestfs` bermasalah: cek `libguestfs-test-tool`.

---

## 12. Latihan Mandiri

1. Jalankan `sudo pacman -Syu` dan catat paket yang di-upgrade.
2. Instal semua paket di Modul 1.2. Simpan output ke `instalasi-fase1.txt`.
3. Verifikasi tidak ada GUI dengan `pacman -Qq | grep -E 'virt-manager|gnome-boxes'`.
4. Cek versi semua alat: `virsh --version`, `virt-install --version`, `qemu-system-x86_64 --version`, `nft --version`, `swtpm --version`.
5. Cari lokasi `OVMF_CODE.fd`: `find /usr -name OVMF_CODE.fd 2>/dev/null`.
6. Instal paket tambahan yang direkomendasikan: `libguestfs`, `virt-top`, `python-libvirt`, `audit`, `dnsmasq`.
7. Buat daftar paket eksplisit: `pacman -Qe > packages-eksplisit.txt`.
8. Jelaskan dengan kata-kata sendiri mengapa `virt-manager` dihindari.

---

# Modul 1.3 — Daemon libvirt & Systemd Socket Activation

## Mini-Daftar Isi Modul 1.3
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Socket Activation & Arsitektur Daemon Modular
6. Audit Kurikulum: Daemon dan Socket yang Perlu Ditambahkan
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah jembatan antara instalasi paket dan penggunaan `virsh`. Setelah paket `libvirt` terpasang, Anda harus mengaktifkan daemon yang akan melayani permintaan manajemen VM. libvirt modern tidak lagi menggunakan satu daemon monolitik `libvirtd` sebagai default, melainkan serangkaian daemon modular yang diaktifkan sesuai kebutuhan melalui **systemd socket activation**.

Dalam modul ini, Anda akan:
- Mengaktifkan socket untuk daemon QEMU (`virtqemud`), jaringan (`virtnetworkd`), dan penyimpanan (`virtstoraged`).
- Memahami cara kerja socket activation.
- Memverifikasi bahwa daemon berjalan dan dapat diakses.
- Menguji koneksi `virsh` ke `qemu:///system`.

**Peran:** Tanpa daemon yang aktif, `virsh` tidak bisa terhubung ke hypervisor. Modul ini memastikan bahwa layanan dasar libvirt siap sebelum Anda mengelola VM di Fase 3 dan seterusnya.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **Daemon:** Proses latar belakang yang berjalan tanpa interaksi langsung dengan pengguna. Di libvirt, daemon melayani permintaan API dari klien seperti `virsh`.
- **Socket Activation:** Mekanisme systemd di mana systemd membuka socket (file khusus untuk komunikasi) dan menunggu koneksi. Ketika ada klien yang terhubung, systemd baru menjalankan service (daemon) yang sesuai. Keuntungan: daemon tidak perlu berjalan terus-menerus, menghemat resource, dan mengurangi permukaan serangan.
- **Modularitas:** libvirt memecah fungsionalitasnya menjadi daemon-daemon kecil yang masing-masing menangani driver tertentu. Ini berbeda dengan model monolitik `libvirtd` yang menangani semua. Modularitas memudahkan isolasi, debugging, dan pembatasan privilege.
- **Depresiasi Monolitik:** `libvirtd` masih ada untuk kompatibilitas, tetapi dianggap deprecated. Pengguna baru disarankan menggunakan daemon modular.
- **Filosofi:** Kontrol penuh, minimalis, dan aman. Socket activation memungkinkan Anda hanya mengaktifkan apa yang diperlukan. Setiap daemon berjalan dengan hak akses seminimal mungkin.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **systemd** | Sistem init dan manajer layanan di Linux modern. | `systemctl`. |
| **Unit** | Konfigurasi untuk systemd. Bisa berupa service, socket, target, dll. | `virtqemud.socket`. |
| **Socket** | Endpoint komunikasi. Di systemd, socket unit memungkinkan socket activation. | `/run/libvirt/virtqemud-sock`. |
| **Socket Activation** | Systemd membuka socket dan menjalankan service saat ada koneksi. | `virtqemud.socket` memicu `virtqemud.service`. |
| **Daemon** | Proses latar belakang. | `virtqemud`, `virtnetworkd`. |
| **virtqemud** | Daemon libvirt untuk driver QEMU/KVM. | Menangani lifecycle VM. |
| **virtnetworkd** | Daemon libvirt untuk driver jaringan virtual. | Menangani network libvirt. |
| **virtstoraged** | Daemon libvirt untuk driver penyimpanan. | Menangani storage pool dan volume. |
| **virtnodedevd** | Daemon libvirt untuk driver perangkat host. | Menangani node device. |
| **virtsecretd** | Daemon libvirt untuk driver secret. | Menangani secret (mis. untuk enkripsi). |
| **virtinterfaced** | Daemon libvirt untuk driver antarmuka host. | Menangani interface host. |
| **virtproxyd** | Daemon proxy untuk akses remote. | Menangani koneksi remote. |
| **virtlogd** | Daemon logging libvirt. | Menangani log VM. |
| **virtlockd** | Daemon locking libvirt. | Menangani lock disk. |
| **qemu:///system** | URI koneksi libvirt untuk VM sistem (root). | `virsh -c qemu:///system`. |
| **qemu:///session** | URI koneksi libvirt untuk VM user. | `virsh -c qemu:///session`. |
| **journalctl** | Alat untuk melihat log systemd. | `journalctl -u virtqemud`. |
| **ss** | Socket statistics. | `ss -xl | grep libvirt`. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Aktifkan Socket untuk Daemon QEMU, Network, dan Storage

```bash
sudo systemctl enable --now virtqemud.socket virtnetworkd.socket virtstoraged.socket
```

**Penjelasan kata demi kata:**
- `sudo`: jalankan sebagai root.
- `systemctl`: kontrol systemd.
- `enable`: aktifkan unit agar dijalankan saat boot. Membuat symlink di `/etc/systemd/system/sockets.target.wants/` atau target terkait.
- `--now`: langsung jalankan unit sekarang juga, bukan hanya saat boot berikutnya.
- `virtqemud.socket`: socket unit untuk daemon QEMU. Ketika ada koneksi ke socket ini, systemd akan menjalankan `virtqemud.service`.
- `virtnetworkd.socket`: socket untuk daemon jaringan libvirt.
- `virtstoraged.socket`: socket untuk daemon penyimpanan libvirt.

**Mengapa tiga ini?** Untuk operasi dasar VM (membuat, menjalankan, menghentikan) dan manajemen jaringan serta storage yang paling umum. Modul selanjutnya akan menambahkan socket lain jika diperlukan.

### 4.2. Cek Status Socket

```bash
systemctl status virtqemud.socket
```

**Penjelasan:**
- `systemctl status`: menampilkan status unit.
- `virtqemud.socket`: unit socket yang dicek.
- **Output yang diharapkan:** `Active: active (listening)` dan `Listen: /run/libvirt/virtqemud-sock (Stream)`. Ini berarti socket siap menerima koneksi.

### 4.3. Lihat Semua Unit Socket dan Service libvirt

```bash
systemctl list-units --type=socket 'virt*'
systemctl list-units --type=service 'virt*'
```

**Penjelasan:**
- `systemctl list-units`: daftar unit yang sedang aktif.
- `--type=socket`: filter hanya unit socket.
- `'virt*'`: pola nama unit yang diawali `virt`.
- `--type=service`: filter hanya unit service.
- **Tujuan:** Melihat unit mana yang aktif dan mana yang belum.

### 4.4. Lihat Socket yang Terbuka

```bash
ss -xl | grep libvirt
```

**Penjelasan:**
- `ss`: socket statistics, pengganti `netstat`.
- `-x`: tampilkan UNIX domain socket.
- `-l`: tampilkan socket yang listening.
- `| grep libvirt`: filter yang mengandung `libvirt`.
- **Output yang diharapkan:** Baris seperti `/run/libvirt/virtqemud-sock`, `/run/libvirt/virtnetworkd-sock`, dll. Ini membuktikan socket benar-benar terbuka.

### 4.5. Uji Koneksi virsh

```bash
virsh -c qemu:///system list --all
```

**Penjelasan kata demi kata:**
- `virsh`: CLI libvirt.
- `-c qemu:///system`: menentukan koneksi ke hypervisor QEMU untuk sistem (root). `qemu:///system` berarti libvirt mengelola VM sistem dengan hak akses root. Ini berbeda dengan `qemu:///session` yang berjalan sebagai user.
- `list`: perintah untuk menampilkan daftar domain (VM).
- `--all`: tampilkan semua VM, termasuk yang tidak berjalan.
- **Output yang diharapkan:** Tabel dengan kolom `Id`, `Name`, `State`. Jika belum ada VM, hanya header. Jika muncul error koneksi, berarti daemon belum siap.

### 4.6. Cek URI Koneksi

```bash
virsh -c qemu:///system uri
```

**Penjelasan:**
- `uri`: perintah untuk menampilkan URI koneksi yang sedang digunakan.
- **Output:** `qemu:///system`.

### 4.7. Cek Versi libvirt dan Hypervisor

```bash
virsh -c qemu:///system version
```

**Penjelasan:**
- `version`: menampilkan versi libvirt dan hypervisor.
- **Output:** Menampilkan versi libvirt, versi QEMU, dan informasi lain. Ini membuktikan koneksi berhasil.

---

## 5. Diagram Alur Socket Activation & Arsitektur Daemon Modular

### 5.1. Alur Socket Activation

```
+-------------+         +---------------------+         +-------------------+
|   Klien     |         |      systemd        |         |   Daemon libvirt  |
|  (virsh)    |         |                     |         |   (virtqemud)     |
+-------------+         +---------------------+         +-------------------+
       |                           |                           |
       | 1. connect ke socket      |                           |
       |-------------------------->|                           |
       |                           | 2. socket listening       |
       |                           |    (sudah dibuka)         |
       |                           |                           |
       |                           | 3. terima koneksi         |
       |                           |-------------------------->|
       |                           |                           | 4. daemon start
       |                           |                           |    (jika belum)
       |                           |<--------------------------|
       | 5. komunikasi             |                           |
       |<------------------------->|<------------------------->|
       |                           |                           |
```

**Penjelasan:**
- systemd membuka socket sejak boot (karena `enable`).
- Klien `virsh` terhubung ke socket.
- systemd mendeteksi koneksi dan menjalankan `virtqemud.service` jika belum berjalan.
- Daemon mengambil alih socket dan melayani klien.
- Setelah idle, daemon bisa dimatikan lagi (tergantung konfigurasi), dan socket tetap terbuka untuk koneksi berikutnya.

### 5.2. Arsitektur Daemon Modular libvirt

```
+-------------------------------------------------------------+
|                        libvirt API                          |
+-------------------------------------------------------------+
|  virtqemud  |  virtnetworkd  |  virtstoraged  |  virtnodedevd |
|  (QEMU)     |  (Network)     |  (Storage)     |  (Node Device)|
+-------------------------------------------------------------+
|  virtsecretd |  virtinterfaced |  virtproxyd   |  virtlogd    |
|  (Secret)    |  (Interface)    |  (Proxy)      |  (Logging)   |
+-------------------------------------------------------------+
|  virtlockd   |  ...            |  ...          |  ...         |
|  (Locking)   |                 |               |              |
+-------------------------------------------------------------+
```

**Penjelasan:**
- Setiap daemon menangani driver tertentu.
- `virtqemud` adalah yang paling penting untuk QEMU/KVM.
- `virtnetworkd` mengelola network virtual.
- `virtstoraged` mengelola storage pool.
- `virtnodedevd` mengelola perangkat host.
- `virtsecretd` mengelola secret.
- `virtinterfaced` mengelola antarmuka host.
- `virtproxyd` adalah proxy untuk akses remote (bisa digunakan oleh `virsh` remote).
- `virtlogd` dan `virtlockd` adalah daemon pendukung.

---

## 6. Audit Kurikulum: Daemon dan Socket yang Perlu Ditambahkan

Kurikulum asli hanya menyebutkan tiga socket: `virtqemud.socket`, `virtnetworkd.socket`, `virtstoraged.socket`. Untuk kelengkapan dan kesiapan Fase 3–8, saya merekomendasikan menambahkan socket berikut:

| Socket | Daemon | Kegunaan |
|---|---|---|
| `virtnodedevd.socket` | `virtnodedevd` | Manajemen node device (PCI, USB). Diperlukan untuk passthrough di Fase 8. |
| `virtsecretd.socket` | `virtsecretd` | Manajemen secret (enkripsi disk, kredensial). Diperlukan untuk Fase 6. |
| `virtinterfaced.socket` | `virtinterfaced` | Manajemen interface host. Berguna untuk bridge/macvtap. |
| `virtproxyd.socket` | `virtproxyd` | Proxy untuk akses remote. Diperlukan jika Anda mengelola dari jarak jauh. |
| `virtlogd.socket` | `virtlogd` | Logging VM. Sangat berguna untuk troubleshooting. |
| `virtlockd.socket` | `virtlockd` | Locking disk. Mencegah korupsi saat VM diakses bersamaan. |

**Rekomendasi:** Aktifkan semua socket modular yang relevan sekarang:
```bash
sudo systemctl enable --now \
  virtqemud.socket \
  virtnetworkd.socket \
  virtstoraged.socket \
  virtnodedevd.socket \
  virtsecretd.socket \
  virtinterfaced.socket \
  virtproxyd.socket \
  virtlogd.socket \
  virtlockd.socket
```
Catatan: Beberapa socket mungkin tidak tersedia di semua versi libvirt. Jika ada yang error, lewati dan sesuaikan.

**Peringatan:** Jika `libvirtd.socket` atau `libvirtd.service` aktif, nonaktifkan untuk menghindari konflik:
```bash
sudo systemctl disable --now libvirtd.socket libvirtd.service
```
Ini karena `libvirtd` monolitik dapat bertabrakan dengan daemon modular.

---

## 7. Hubungan dengan Modul Lain

- **Modul 1.4:** Setelah socket aktif, Anda akan menambahkan user ke grup `libvirt` dan mengakses `virsh` non-root. Polkit akan mengatur izin.
- **Modul 1.5:** `nftables` akan dikonfigurasi. Tidak terkait langsung, tetapi tetap bagian dari host hardening.
- **Fase 3:** `virsh` dan `virt-install` akan menggunakan daemon yang aktif di modul ini untuk mengelola VM.
- **Fase 4:** `virtstoraged` akan menangani storage pool dan volume.
- **Fase 5:** `virtnetworkd` akan menangani network virtual.
- **Fase 6:** `virtsecretd` akan menangani secret untuk enkripsi.
- **Fase 8:** `virtnodedevd` akan menangani node device untuk passthrough.

---

## 8. Referensi Lengkap

- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/libvirt
- **libvirt: Daemon and Socket Activation** — https://libvirt.org/daemons.html
- **libvirt: Modular Daemons** — https://libvirt.org/daemons.html#modular-daemons
- **systemd: Socket Activation** — https://www.freedesktop.org/software/systemd/man/systemd.socket.html
- **systemd: systemctl** — https://www.freedesktop.org/software/systemd/man/systemctl.html
- **libvirt: Connection URIs** — https://libvirt.org/uri.html
- **libvirt: virsh** — https://libvirt.org/manpages/virsh.html
- **Arch Wiki: systemd** — https://wiki.archlinux.org/title/systemd

---

## 9. Tips & Praktik Terbaik

1. **Gunakan `systemctl list-sockets 'virt*'`** untuk melihat semua socket libvirt dan statusnya.
2. **Gunakan `systemctl list-units --type=service 'virt*'`** untuk melihat service yang berjalan.
3. **Jika ingin daemon selalu berjalan (tidak socket-activated),** Anda bisa mengaktifkan service-nya langsung, tetapi ini boros resource. Biarkan socket activation.
4. **Periksa log dengan `journalctl -u virtqemud -f`** saat troubleshooting.
5. **Gunakan `virsh -c qemu:///system uri`** untuk memastikan URI benar.
6. **Hindari menjalankan `virsh` sebagai root langsung.** Lebih baik tambahkan user ke grup `libvirt` (Modul 1.4).
7. **Jika menggunakan akses remote, aktifkan `virtproxyd.socket`** dan konfigurasi TLS/SSH.
8. **Simpan status socket:** `systemctl list-sockets > sockets.txt`.
9. **Jangan aktifkan `libvirtd` dan daemon modular secara bersamaan.** Pilih salah satu; modular lebih disarankan.
10. **Untuk VM user (`qemu:///session`),** socket yang digunakan berbeda. Modul 1.4 akan membahas.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `virsh -c qemu:///system list --all` gagal connect | Socket belum aktif atau daemon belum berjalan. | `systemctl status virtqemud.socket`. Pastikan `active (listening)`. |
| `error: Failed to connect socket to '/run/libvirt/virtqemud-sock': No such file or directory` | Socket belum dibuat. | `sudo systemctl enable --now virtqemud.socket`. |
| `error: Failed to connect socket to '/run/libvirt/virtqemud-sock': Permission denied` | User tidak punya akses ke socket. | Tambahkan user ke grup `libvirt` (Modul 1.4). |
| `systemctl status virtqemud.socket` menunjukkan `inactive (dead)` | Socket tidak diaktifkan. | `sudo systemctl enable --now virtqemud.socket`. |
| Konflik antara `libvirtd` dan daemon modular | Keduanya aktif. | `sudo systemctl disable --now libvirtd.socket libvirtd.service`. |
| `virtnetworkd.socket` tidak ada | Versi libvirt terlalu lama atau paket tidak lengkap. | Update libvirt. Cek `pacman -Ql libvirt | grep virtnetworkd`. |
| `virsh` tidak ditemukan | Paket libvirt belum terinstal. | `sudo pacman -S libvirt`. |
| Socket ada tapi daemon tidak mau start | Konfigurasi salah atau dependensi hilang. | `journalctl -u virtqemud -xe`. Baca error. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `systemctl status virtqemud.socket` menunjukkan `active (listening)`.
- `systemctl status virtnetworkd.socket` menunjukkan `active (listening)`.
- `systemctl status virtstoraged.socket` menunjukkan `active (listening)`.
- `ss -xl | grep libvirt` menampilkan socket yang terbuka.
- `virsh -c qemu:///system list --all` berhasil tanpa error.
- `virsh -c qemu:///system uri` menampilkan `qemu:///system`.
- `virsh -c qemu:///system version` menampilkan versi.

**Troubleshooting:**
- Jika socket tidak ada: `systemctl list-unit-files 'virt*'` untuk melihat unit yang tersedia.
- Jika daemon gagal start: `journalctl -u virtqemud -b --no-pager` untuk melihat log sejak boot.
- Jika permission denied: cek `ls -l /run/libvirt/virtqemud-sock`. Group harus `libvirt` dan permission `srwxrwx---`. Tambahkan user ke grup `libvirt`.
- Jika `virsh` masih gagal: coba `sudo virsh -c qemu:///system list --all`. Jika berhasil sebagai root, masalahnya di permission user.
- Jika ingin mereset: `sudo systemctl restart virtqemud.socket`.
- Untuk melihat semua log libvirt: `journalctl -u 'virt*' --since today`.

---

## 12. Latihan Mandiri

1. Aktifkan tiga socket utama: `virtqemud.socket`, `virtnetworkd.socket`, `virtstoraged.socket`.
2. Cek status masing-masing dengan `systemctl status`.
3. Aktifkan socket tambahan yang direkomendasikan: `virtnodedevd.socket`, `virtsecretd.socket`, `virtinterfaced.socket`, `virtproxyd.socket`, `virtlogd.socket`, `virtlockd.socket`.
4. Jalankan `systemctl list-sockets 'virt*'` dan catat semua socket yang aktif.
5. Jalankan `ss -xl | grep libvirt` dan catat socket yang terbuka.
6. Uji `virsh -c qemu:///system list --all`. Jika gagal, baca error dan atasi.
7. Jalankan `virsh -c qemu:///system version` dan catat versi libvirt dan QEMU.
8. Cek apakah `libvirtd` aktif: `systemctl status libvirtd`. Jika aktif, nonaktifkan.
9. Buat file `catatan-daemon-libvirt.txt` yang berisi daftar daemon, socket, dan fungsinya.
10. Jelaskan dengan kata-kata sendiri apa itu socket activation dan mengapa libvirt beralih ke daemon modular.

---

# Modul 1.4 — Akses virsh Non-Root via Polkit & Grup

## Mini-Daftar Isi Modul 1.4
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Akses Non-Root & Polkit
6. Audit Kurikulum: Hal yang Perlu Ditambahkan
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Setelah daemon libvirt aktif, langkah berikutnya adalah memastikan Anda dapat mengelola VM **tanpa harus menjadi root** setiap saat. Ini penting untuk keamanan, kenyamanan, dan audit. Ada dua jalur utama:

1. **Koneksi sistem (`qemu:///system`)**: VM dikelola oleh libvirt sebagai layanan sistem. Untuk mengaksesnya sebagai user biasa, Anda biasanya perlu menjadi anggota grup `libvirt`, dan otorisasi tambahan diatur oleh **Polkit**.
2. **Koneksi sesi (`qemu:///session`)**: VM berjalan di bawah akun user Anda sendiri. Tidak memerlukan grup `libvirt` atau Polkit, tetapi memiliki keterbatasan (misalnya, tidak bisa mengelola jaringan sistem, storage pool sistem, atau perangkat host tertentu).

Modul ini berfokus pada jalur pertama, karena itulah yang digunakan di sebagian besar Fase 3–8. Anda akan:
- Menambahkan user ke grup `libvirt`.
- Memahami peran Polkit dalam otorisasi.
- Menguji akses `virsh` non-root.
- Membedakan `qemu:///system` dan `qemu:///session`.
- Memahami risiko keamanan grup `libvirt`.

**Peran:** Tanpa akses non-root yang benar, Anda akan terus menggunakan `sudo virsh` yang merepotkan dan berisiko. Modul ini membuka pintu menuju pengelolaan VM yang aman dan efisien.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **Prinsip Least Privilege:** User seharusnya hanya memiliki hak yang benar-benar diperlukan. Namun, mengelola VM sistem adalah tugas yang sangat powerful. Grup `libvirt` pada dasarnya setara dengan root untuk urusan virtualisasi. Karena itu, keanggotaan grup ini harus dijaga ketat.
- **Polkit (PolicyKit):** Kerangka otorisasi di Linux yang memungkinkan aplikasi non-root meminta izin untuk operasi tertentu. Polkit mendefinisikan *action* (misalnya `org.libvirt.unix.manage`) dan aturan siapa yang boleh melakukan action tersebut. Polkit bukan pengganti sudo; ia bekerja pada level API/D-Bus.
- **Grup `libvirt`:** Grup sistem yang diberikan akses ke socket libvirt. Socket `/run/libvirt/virtqemud-sock` biasanya dimiliki oleh `root:libvirt` dengan permission `srwxrwx---`. Artinya, hanya root dan anggota grup `libvirt` yang bisa terhubung.
- **Socket vs Polkit:** Ada dua lapis:
  1. **Akses socket:** apakah user bisa terhubung ke socket libvirt? Ditentukan oleh permission file socket dan keanggotaan grup.
  2. **Otorisasi Polkit:** setelah terhubung, apakah user boleh melakukan operasi tertentu (misalnya membuat VM, mengubah konfigurasi)? Ditentukan oleh aturan Polkit.
- **qemu:///system vs qemu:///session:**
  - `system`: daemon libvirt sistem, VM dikelola sebagai layanan, akses melalui socket sistem, otorisasi Polkit.
  - `session`: daemon/libvirt user, VM berjalan sebagai user, tidak perlu grup `libvirt`, tetapi tidak bisa mengakses resource sistem secara penuh.
- **Filosofi:** Kontrol via CLI, isolasi, dan audit. Gunakan grup `libvirt` hanya jika perlu. Untuk isolasi maksimal, pertimbangkan `qemu:///session`.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **Polkit** | Framework otorisasi Linux. | `pkaction`, `pkcheck`, `polkit.addRule`. |
| **Action** | Operasi yang dilindungi Polkit. | `org.libvirt.unix.manage`. |
| **Rule** | Aturan Polkit dalam JavaScript. | `/etc/polkit-1/rules.d/49-libvirt.rules`. |
| **Grup `libvirt`** | Grup sistem untuk akses socket libvirt. | `sudo usermod -aG libvirt $USER`. |
| **Grup `kvm`** | Grup untuk akses `/dev/kvm`. | Diperlukan untuk `qemu:///session`. |
| **`qemu:///system`** | Koneksi libvirt sistem. | VM dikelola oleh daemon sistem. |
| **`qemu:///session`** | Koneksi libvirt sesi user. | VM berjalan sebagai user. |
| **Socket** | Endpoint komunikasi UNIX. | `/run/libvirt/virtqemud-sock`. |
| **`srwxrwx---`** | Permission socket: socket, rwx untuk owner, rwx untuk group, none untuk others. | `s` = socket. |
| **`newgrp`** | Mengubah group ID efektif di shell saat ini. | `newgrp libvirt`. |
| **`id`** | Menampilkan identitas user dan grup. | `id -nG`. |
| **`pkaction`** | Menampilkan daftar action Polkit. | `pkaction --verbose --action-id ...`. |
| **`pkcheck`** | Menguji otorisasi Polkit. | `pkcheck --action-id ... --process $$`. |
| **`polkit.addRule`** | Fungsi JavaScript untuk menambah aturan Polkit. | Di file `.rules`. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Tambahkan User ke Grup `libvirt`

```bash
sudo usermod -aG libvirt $USER
```

**Penjelasan kata demi kata:**
- `sudo`: jalankan sebagai root.
- `usermod`: perintah untuk memodifikasi akun user.
- `-a`: append. Menambahkan grup tanpa menghapus keanggotaan grup lain.
- `-G`: supplementary groups. Menentukan grup tambahan.
- `libvirt`: nama grup yang ditambahkan.
- `$USER`: variabel lingkungan yang berisi nama user saat ini.
- **Efek:** User ditambahkan ke grup `libvirt` di `/etc/group`. Perubahan ini **tidak langsung berlaku** pada sesi yang sedang berjalan.

**Catatan Penting:** Jika Anda juga berencana menggunakan `qemu:///session`, tambahkan user ke grup `kvm`:
```bash
sudo usermod -aG kvm $USER
```
Karena `/dev/kvm` biasanya dimiliki `root:kvm` dengan permission `crw-rw----`.

### 4.2. Verifikasi Keanggotaan Grup

```bash
id -nG
```

**Penjelasan:**
- `id`: menampilkan identitas user.
- `-n`: names, bukan numeric.
- `-G`: semua group ID.
- **Output:** Daftar grup yang diikuti user, misalnya `wheel libvirt kvm`. Jika `libvirt` belum muncul, berarti perubahan belum diterapkan di sesi ini.

### 4.3. Terapkan Keanggotaan Grup Baru

Ada beberapa cara:
- **Logout dan login ulang** (paling bersih).
- **Gunakan `newgrp`** untuk shell saat ini:
  ```bash
  newgrp libvirt
  ```
  - `newgrp`: menjalankan shell baru dengan grup primer `libvirt`. Namun, ini hanya untuk shell tersebut. Untuk sesi grafis atau systemd user, tetap perlu re-login.
- **Untuk SSH:** putuskan koneksi dan sambung ulang.
- **Untuk sesi systemd user:** `loginctl terminate-user $USER` lalu login lagi.

### 4.4. Uji Akses `virsh` Non-Root

```bash
virsh -c qemu:///system list --all
```

**Penjelasan kata demi kata:**
- `virsh`: CLI libvirt.
- `-c qemu:///system`: koneksi ke hypervisor QEMU sistem.
- `list`: menampilkan daftar domain.
- `--all`: semua domain, termasuk yang tidak berjalan.
- **Output yang diharapkan:** Tabel dengan header `Id Name State`. Jika kosong, hanya header. Jika error `Permission denied`, berarti grup atau Polkit belum benar.

### 4.5. Uji Koneksi Sesi

```bash
virsh -c qemu:///session list --all
```

**Penjelasan:**
- `qemu:///session`: koneksi sesi user. Tidak perlu grup `libvirt` atau Polkit.
- **Output:** Sama seperti di atas. Jika belum ada VM, kosong.
- **Catatan:** VM di `session` tidak terlihat di `system`, dan sebaliknya.

### 4.6. Periksa Permission Socket

```bash
ls -l /run/libvirt/virtqemud-sock
```

**Penjelasan:**
- `ls -l`: format panjang.
- `/run/libvirt/virtqemud-sock`: socket untuk `virtqemud`.
- **Output yang diharapkan:** `srwxrwx--- 1 root libvirt 0 ... /run/libvirt/virtqemud-sock`. Perhatikan `s` di awal (socket), owner `root`, group `libvirt`, permission `rwx` untuk owner dan group, `---` untuk others.
- Jika group bukan `libvirt` atau permission berbeda, Anda mungkin perlu menyesuaikan.

### 4.7. Periksa Action Polkit

```bash
pkaction --verbose --action-id org.libvirt.unix.manage
```

**Penjelasan:**
- `pkaction`: alat Polkit untuk melihat action.
- `--verbose`: tampilkan detail.
- `--action-id org.libvirt.unix.manage`: action untuk manajemen libvirt.
- **Output:** Deskripsi, vendor, dan implicit authorizations. Anda akan melihat apakah action ini diizinkan untuk `auth_admin`, `yes`, dll.

### 4.8. Uji Otorisasi Polkit

```bash
pkcheck --action-id org.libvirt.unix.manage --process $$
```

**Penjelasan:**
- `pkcheck`: menguji otorisasi.
- `--action-id org.libvirt.unix.manage`: action yang diuji.
- `--process $$`: proses yang diuji adalah shell saat ini (`$$` adalah PID shell).
- **Output:** Jika diizinkan, tidak ada output dan exit code 0. Jika tidak, pesan error.

### 4.9. (Opsional) Buat Aturan Polkit Kustom

Buat file `/etc/polkit-1/rules.d/49-libvirt-custom.rules`:
```javascript
polkit.addRule(function(action, subject) {
    if (action.id == "org.libvirt.unix.manage" &&
        subject.isInGroup("libvirt")) {
        return polkit.Result.YES;
    }
});
```

**Penjelasan sintaks JavaScript:**
- `polkit.addRule`: fungsi untuk menambahkan aturan.
- `function(action, subject)`: callback yang dipanggil saat ada permintaan otorisasi.
- `action.id`: ID action, misalnya `org.libvirt.unix.manage`.
- `subject.isInGroup("libvirt")`: cek apakah subjek (user) anggota grup `libvirt`.
- `polkit.Result.YES`: izinkan tanpa autentikasi.
- **Catatan:** Aturan default libvirt biasanya sudah mengizinkan grup `libvirt`. File kustom ini berguna jika Anda ingin membatasi lebih ketat atau menambahkan user tertentu.

---

## 5. Diagram Alur Akses Non-Root & Polkit

### 5.1. Alur Akses `qemu:///system`

```
+-------------+     +----------------+     +---------------------+
| User (budi) |     | Grup libvirt   |     | Socket              |
| groups:     |---->| (keanggotaan)  |---->| root:libvirt        |
| libvirt     |     |                |     | srwxrwx---          |
+-------------+     +----------------+     +---------------------+
        |                                           |
        | 1. virsh -c qemu:///system                |
        |------------------------------------------>|
        |                                           |
        | 2. Terhubung ke socket                    |
        |                                           |
        | 3. Polkit memeriksa action                |
        |    org.libvirt.unix.manage                |
        |                                           |
        | 4. Jika diizinkan, operasi dijalankan     |
        |<------------------------------------------|
```

**Penjelasan:**
- User harus anggota grup `libvirt` agar bisa mengakses socket.
- Setelah terhubung, Polkit memeriksa apakah user boleh melakukan action tertentu.
- Jika Polkit mengizinkan, libvirt menjalankan operasi.

### 5.2. Perbedaan `system` vs `session`

```
+---------------------+         +---------------------+
| qemu:///system      |         | qemu:///session     |
+---------------------+         +---------------------+
| Daemon sistem       |         | Daemon/user libvirt |
| Socket sistem       |         | Socket user         |
| Butuh grup libvirt  |         | Tidak butuh grup    |
| Polkit otorisasi    |         | Tidak ada Polkit    |
| VM sebagai layanan  |         | VM sebagai user     |
| Akses resource host |         | Terbatas            |
+---------------------+         +---------------------+
```

**Penjelasan:**
- `system` lebih powerful, tetapi membutuhkan keanggotaan grup dan otorisasi.
- `session` lebih terisolasi, tetapi tidak bisa mengelola resource sistem.

---

## 6. Audit Kurikulum: Hal yang Perlu Ditambahkan

Kurikulum asli hanya menyebutkan:
```bash
sudo usermod -aG libvirt $USER
# logout/login
virsh list --all
```

Saya menambahkan beberapa poin penting yang sering terlewat:

1. **Perbedaan `qemu:///system` dan `qemu:///session`** — krusial untuk memahami kapan perlu grup dan kapan tidak.
2. **Grup `kvm`** — untuk `qemu:///session`, user perlu akses `/dev/kvm`.
3. **Polkit** — bukan hanya grup, tetapi juga action `org.libvirt.unix.manage`.
4. **Permission socket** — memastikan socket dimiliki `root:libvirt`.
5. **Risiko keamanan grup `libvirt`** — keanggotaan grup ini sangat powerful, hampir setara root untuk virtualisasi.
6. **Aturan Polkit kustom** — untuk membatasi atau memperluas akses.
7. **`newgrp` vs re-login** — cara menerapkan keanggotaan grup.
8. **`pkaction` dan `pkcheck`** — alat untuk audit Polkit.
9. **Remote access** — jika mengelola dari jarak jauh, `virtproxyd` dan SSH/TLS perlu dipertimbangkan.
10. **Audit log** — `journalctl` untuk melihat percobaan akses.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 1.4 atau sebagai modul tambahan “Akses dan Otorisasi Lanjutan”.

---

## 7. Hubungan dengan Modul Lain

- **Modul 1.3:** Socket dan daemon harus aktif sebelum modul ini. Modul ini melengkapi akses.
- **Modul 1.5:** `nftables` tidak terkait langsung, tetapi tetap bagian dari host hardening.
- **Fase 3:** `virsh` dan `virt-install` akan digunakan sebagai non-root. Tanpa modul ini, Anda akan terus memakai `sudo`.
- **Fase 6:** Isolasi dan keamanan. Memahami Polkit dan grup `libvirt` penting untuk threat modeling.
- **Fase 8:** Remote migration dan API. Akses non-root dan Polkit akan relevan.

---

## 8. Referensi Lengkap

- **Arch Wiki: libvirt** — https://wiki.archlinux.org/title/libvirt
- **libvirt: Polkit** — https://libvirt.org/auth.html#polkit
- **libvirt: Connection URIs** — https://libvirt.org/uri.html
- **Polkit Manual** — https://www.freedesktop.org/software/polkit/docs/latest/
- **polkit(8)** — https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html
- **pkaction(1)** — https://www.freedesktop.org/software/polkit/docs/latest/pkaction.1.html
- **pkcheck(1)** — https://www.freedesktop.org/software/polkit/docs/latest/pkcheck.1.html
- **Arch Wiki: Users and groups** — https://wiki.archlinux.org/title/Users_and_groups
- **Arch Wiki: Polkit** — https://wiki.archlinux.org/title/Polkit
- **libvirt: Access Control** — https://libvirt.org/acl.html

---

## 9. Tips & Praktik Terbaik

1. **Gunakan `qemu:///session` untuk isolasi maksimal.** Jika Anda tidak perlu resource sistem, ini lebih aman.
2. **Jangan tambahkan user ke grup `libvirt` tanpa alasan.** Grup ini sangat powerful.
3. **Gunakan Polkit untuk membatasi akses.** Jangan hanya mengandalkan grup.
4. **Audit keanggotaan grup secara berkala:** `getent group libvirt`.
5. **Gunakan `newgrp` untuk uji cepat, tetapi re-login untuk permanen.**
6. **Periksa permission socket:** `ls -l /run/libvirt/virtqemud-sock`.
7. **Gunakan `virsh -c qemu:///system` secara eksplisit.** Jangan mengandalkan default yang bisa berubah.
8. **Untuk remote, gunakan SSH tunneling:** `virsh -c qemu+ssh://user@host/system`.
9. **Simpan aturan Polkit di `/etc/polkit-1/rules.d/`** dengan prioritas angka rendah (mis. `49-`).
10. **Baca log Polkit:** `journalctl -u polkit` atau `journalctl | grep polkit`.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `virsh -c qemu:///system list` → `Permission denied` | User belum masuk grup `libvirt` atau belum re-login. | `sudo usermod -aG libvirt $USER`, logout/login, atau `newgrp libvirt`. |
| `error: Failed to connect socket to '/run/libvirt/virtqemud-sock': Permission denied` | Permission socket bukan `root:libvirt` atau user tidak di grup. | `ls -l /run/libvirt/virtqemud-sock`. Pastikan group `libvirt`. |
| `virsh` sebagai non-root berhasil, tetapi operasi tertentu gagal | Polkit membatasi action. | Cek `pkaction --verbose --action-id org.libvirt.unix.manage`. Buat aturan kustom jika perlu. |
| `qemu:///session` gagal akses `/dev/kvm` | User tidak di grup `kvm`. | `sudo usermod -aG kvm $USER`, re-login. |
| `newgrp libvirt` tidak mengubah grup di terminal lain | `newgrp` hanya berlaku di shell saat ini. | Logout/login atau buka terminal baru setelah re-login. |
| Polkit rule tidak berfungsi | File rule salah nama, salah lokasi, atau syntax error. | Pastikan file di `/etc/polkit-1/rules.d/` dengan ekstensi `.rules`. Cek `journalctl -u polkit`. |
| `pkcheck` mengembalikan error | Action tidak ada atau user tidak berhak. | Cek `pkaction --verbose --action-id ...`. |
| Grup `libvirt` tidak ada | Paket libvirt belum terinstal atau user/group belum dibuat. | `sudo pacman -S libvirt`. Cek `getent group libvirt`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `id -nG` menampilkan `libvirt` (dan `kvm` jika digunakan).
- `ls -l /run/libvirt/virtqemud-sock` menunjukkan `root:libvirt` dan permission `srwxrwx---`.
- `virsh -c qemu:///system list --all` berhasil tanpa `sudo`.
- `virsh -c qemu:///session list --all` berhasil tanpa `sudo`.
- `pkaction --verbose --action-id org.libvirt.unix.manage` menampilkan action.
- `pkcheck --action-id org.libvirt.unix.manage --process $$` mengembalikan exit code 0 (jika diizinkan).

**Troubleshooting:**
- Jika `virsh` masih gagal: coba `sudo virsh -c qemu:///system list --all`. Jika berhasil sebagai root, masalahnya di permission user.
- Jika socket permission salah: `sudo chown root:libvirt /run/libvirt/virtqemud-sock && sudo chmod 0770 /run/libvirt/virtqemud-sock`. Namun, ini biasanya diatur otomatis oleh systemd.
- Jika Polkit tidak ada: `sudo pacman -S polkit`.
- Jika aturan Polkit kustom tidak diterapkan: pastikan file memiliki permission 644 dan dimiliki root. `sudo chmod 644 /etc/polkit-1/rules.d/49-libvirt-custom.rules`.
- Untuk melihat log Polkit: `journalctl -u polkit --since today`.
- Untuk melihat log libvirt: `journalctl -u virtqemud --since today`.

---

## 12. Latihan Mandiri

1. Tambahkan user Anda ke grup `libvirt` dan `kvm`.
2. Verifikasi dengan `id -nG`.
3. Logout/login atau gunakan `newgrp libvirt`.
4. Uji `virsh -c qemu:///system list --all` tanpa sudo.
5. Uji `virsh -c qemu:///session list --all` tanpa sudo.
6. Periksa permission socket `virtqemud-sock`.
7. Jalankan `pkaction --verbose --action-id org.libvirt.unix.manage` dan catat outputnya.
8. Buat aturan Polkit kustom yang mengizinkan hanya user tertentu (misalnya user Anda) untuk `org.libvirt.unix.manage`. Uji dengan `pkcheck`.
9. Jelaskan dengan kata-kata sendiri perbedaan `qemu:///system` dan `qemu:///session`.
10. Buat catatan tentang risiko keamanan grup `libvirt` dan kapan sebaiknya menggunakan `qemu:///session`.

---

Berikutnya kita akan membangun firewall host yang kuat, aman, dan menjadi fondasi sebelum VM berjalan.

---

# Modul 1.5 — Baseline nftables Host

## Mini-Daftar Isi Modul 1.5
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar / Contoh Implementasi Inti (dengan penjelasan kata demi kata)
5. Diagram Alur Packet Flow & Arsitektur nftables
6. Audit Kurikulum: Hal yang Perlu Ditambahkan
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting Diperluas
12. Latihan Mandiri

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah langkah terakhir dalam Fase 1. Setelah host siap secara hardware, paket virtualisasi terinstal, daemon libvirt aktif, dan akses non-root dikonfigurasi, sekarang saatnya mengamankan **permukaan serangan** host. Firewall adalah garis pertahanan pertama. Tanpa firewall, host Anda terekspos ke seluruh jaringan.

Dalam modul ini, Anda akan:
- Memahami arsitektur `nftables` dan perbedaannya dengan `iptables`.
- Membuat **tabel**, **chain**, dan **rule** dasar.
- Menerapkan kebijakan **default deny** untuk input.
- Mengizinkan loopback, koneksi established/related, dan SSH.
- Mempersistensi aturan agar tetap ada setelah reboot.
- Memahami bagaimana `nftables` berinteraksi dengan `libvirt` dan VM.
- Menerapkan praktik terbaik keamanan firewall.

**Peran:** Firewall host adalah fondasi keamanan seluruh infrastruktur virtualisasi. Tanpa firewall, VM yang rentan bisa menjadi pintu masuk ke host. Modul ini memastikan host hanya menerima koneksi yang benar-benar diperlukan.

---

## 2. Konsep Kunci & Filosofi Mendalam

- **nftables** adalah framework klasifikasi paket modern di kernel Linux yang menggantikan `{ip,ip6,arp,eb}tables`. Ia menggunakan mesin virtual bytecode di kernel, memungkinkan evaluasi aturan yang jauh lebih efisien dan fleksibel.
- **Sintaks deklaratif:** Tidak seperti `iptables` yang prosedural, `nftables` menggunakan sintaks deklaratif yang lebih bersih dan konsisten, terinspirasi oleh `tcpdump`.
- **Tabel dan Chain sepenuhnya dapat dikonfigurasi:** Tidak ada tabel atau chain bawaan. Anda membuat semuanya sesuai kebutuhan. Ini memungkinkan manajemen independen oleh berbagai aplikasi.
- **Satu rule bisa memiliki multiple actions:** Berbeda dengan `iptables` yang hanya memiliki satu target per rule, `nftables` memungkinkan satu rule melakukan beberapa aksi sekaligus.
- **Atomic rule replacement:** Seluruh ruleset dapat diganti secara atomik dengan `nft -f`, menghindari jendela waktu tanpa aturan yang bisa terjadi pada `iptables-restore`.
- **inet family:** Memungkinkan aturan yang sama berlaku untuk IPv4 dan IPv6 sekaligus, menghilangkan duplikasi.
- **Filosofi:** Default deny, least privilege, atomic, dan terukur. Firewall harus menjadi *whitelist*, bukan *blacklist*. Hanya izinkan yang benar-benar diperlukan.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **nftables** | Framework klasifikasi paket modern di kernel Linux. | Menggantikan `iptables`. |
| **nft** | Userspace utility untuk mengelola nftables. | `nft add rule ...`. |
| **Table** | Wadah untuk chain. Setiap table memiliki address family. | `table inet filter`. |
| **Chain** | Wadah untuk rule. Bisa base chain (terhubung ke hook) atau regular chain. | `chain input`. |
| **Base Chain** | Chain yang terhubung ke Netfilter hook. | `type filter hook input priority 0; policy drop;`. |
| **Regular Chain** | Chain yang tidak terhubung ke hook, hanya bisa dipanggil dari chain lain. | `chain tcp_services`. |
| **Hook** | Titik di stack jaringan tempat chain dievaluasi. | `input`, `forward`, `output`, `prerouting`, `postrouting`. |
| **Priority** | Urutan evaluasi base chain. Semakin rendah, semakin awal. | `priority 0`, `priority -200`. |
| **Policy** | Aksi default jika tidak ada rule yang cocok. | `policy drop`, `policy accept`. |
| **Rule** | Kombinasi ekspresi (match) dan statement (action). | `tcp dport 22 accept`. |
| **Expression** | Kondisi yang harus dipenuhi. | `tcp dport 22`, `ip saddr 10.0.0.0/8`. |
| **Statement** | Aksi yang diambil. | `accept`, `drop`, `reject`, `jump`, `log`. |
| **Set** | Kumpulan elemen yang bisa direferensikan dalam rule. | `{ 22, 80, 443 }`. |
| **Named Set** | Set yang diberi nama dan bisa diupdate. | `set allowed_ports { type inet_service; elements = { 22, 80 }; }`. |
| **Map** | Struktur data yang memetakan key ke value. | `map port_map { type inet_service : verdict; }`. |
| **Verdict** | Keputusan akhir untuk paket. | `accept`, `drop`, `reject`, `queue`, `continue`. |
| **ct** | Connection tracking. | `ct state established,related accept`. |
| **inet family** | Address family untuk IPv4 dan IPv6. | `table inet filter`. |
| **ip family** | Address family untuk IPv4 saja. | `table ip nat`. |
| **ip6 family** | Address family untuk IPv6 saja. | `table ip6 filter`. |
| **nftables.service** | Systemd service untuk memuat ruleset dari file. | `systemctl enable --now nftables`. |
| **/etc/nftables.conf** | File konfigurasi default. | Ruleset dimuat saat service start. |
| **Atomic** | Seluruh ruleset diganti sekaligus. | `nft -f ruleset.nft`. |
| **Masquerade** | Source NAT otomatis. | `oifname "eth0" masquerade`. |
| **Flowtable** | Akselerasi forwarding paket. | `flowtable f { hook ingress priority 0; devices = { eth0, eth1 }; }`. |

---

## 4. Sintaks Dasar / Contoh Implementasi Inti

### 4.1. Memahami Struktur Perintah `nft`

Perintah `nft` memiliki struktur umum:
```
nft [command] [family] [table] [chain] [rule]
```

- `command`: `add`, `insert`, `delete`, `list`, `flush`, dll.
- `family`: `ip`, `ip6`, `inet`, `arp`, `bridge`.
- `table`: nama table.
- `chain`: nama chain.
- `rule`: ekspresi dan statement.

### 4.2. Membuat Table

```bash
sudo nft add table inet filter
```

**Penjelasan kata demi kata:**
- `sudo`: jalankan sebagai root.
- `nft`: userspace utility nftables.
- `add`: perintah untuk menambahkan objek.
- `table`: tipe objek yang ditambahkan.
- `inet`: address family. `inet` berarti berlaku untuk IPv4 dan IPv6.
- `filter`: nama table. Bisa apa saja, tetapi `filter` adalah konvensi umum.

**Mengapa `inet`?** Karena kita ingin aturan yang sama berlaku untuk IPv4 dan IPv6, menghindari duplikasi.

### 4.3. Membuat Base Chain untuk Input

```bash
sudo nft add chain inet filter input { type filter hook input priority 0\; policy drop\; }
```

**Penjelasan kata demi kata:**
- `add chain`: menambahkan chain.
- `inet filter`: table tujuan.
- `input`: nama chain.
- `{ ... }`: blok definisi chain.
- `type filter`: tipe chain. `filter` berarti untuk filtering paket.
- `hook input`: hook Netfilter yang terhubung. `input` berarti paket yang ditujukan ke host lokal.
- `priority 0`: prioritas evaluasi. Semakin rendah, semakin awal dievaluasi.
- `policy drop`: kebijakan default. Jika tidak ada rule yang cocok, paket **dijatuhkan**. Ini adalah **default deny**.
- `\;`: escape untuk titik koma. Dalam shell, `;` adalah pemisah perintah. `\;` memastikan `;` diteruskan ke `nft`.
- `\;` di akhir: menutup statement.

**Mengapa `policy drop`?** Ini adalah prinsip keamanan fundamental: tolak semua, izinkan yang perlu.

### 4.4. Menambahkan Rule: Loopback

```bash
sudo nft add rule inet filter input iif lo accept
```

**Penjelasan kata demi kata:**
- `add rule`: menambahkan rule.
- `inet filter input`: chain tujuan.
- `iif lo`: input interface adalah loopback (`lo`). `iif` = input interface.
- `accept`: terima paket.

**Mengapa?** Loopback digunakan untuk komunikasi internal host. Memblokirnya akan merusak banyak layanan.

### 4.5. Menambahkan Rule: Established/Related

```bash
sudo nft add rule inet filter input ct state established,related accept
```

**Penjelasan kata demi kata:**
- `ct`: connection tracking.
- `state established,related`: status koneksi. `established` berarti koneksi yang sudah terbentuk. `related` berarti koneksi terkait (mis. FTP data).
- `accept`: terima.

**Mengapa?** Ini memungkinkan respons dari koneksi yang kita inisiasi. Tanpa ini, kita tidak bisa mengakses internet.

### 4.6. Menambahkan Rule: SSH

```bash
sudo nft add rule inet filter input tcp dport 22 accept
```

**Penjelasan kata demi kata:**
- `tcp dport 22`: port tujuan TCP 22 (SSH).
- `accept`: terima.

**Peringatan:** Selalu tambahkan rule SSH **sebelum** mengubah policy menjadi `drop`. Jika tidak, Anda akan terkunci.

### 4.7. Melihat Ruleset

```bash
sudo nft list ruleset
```

**Penjelasan:**
- `list`: menampilkan.
- `ruleset`: seluruh ruleset.

**Output yang diharapkan:** Menampilkan table, chain, dan rule yang telah dibuat.

### 4.8. Menyimpan Ruleset ke File

```bash
sudo nft list ruleset > /etc/nftables.conf
```

**Penjelasan:**
- `> /etc/nftables.conf`: redirect output ke file. File ini akan dimuat oleh `nftables.service` saat boot.

**Catatan:** File `/etc/nftables.conf` biasanya sudah ada dan berisi `flush ruleset` di awal. Pastikan formatnya benar.

### 4.9. Mengaktifkan Service nftables

```bash
sudo systemctl enable --now nftables
```

**Penjelasan:**
- `enable`: aktifkan saat boot.
- `--now`: jalankan sekarang juga.
- `nftables`: service yang memuat `/etc/nftables.conf`.

### 4.10. Contoh Ruleset Lengkap (file `/etc/nftables.conf`)

```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        iif lo accept
        ct state established,related accept
        ct state invalid drop

        ip protocol icmp icmp type echo-request accept
        ip6 nexthdr icmpv6 icmpv6 type { echo-request, nd-neighbor-solicit, nd-neighbor-advert } accept

        tcp dport 22 accept

        log prefix "nftables-drop: " counter drop
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

**Penjelasan baris demi baris:**

- `#!/usr/sbin/nft -f`: shebang. Menandakan file ini dieksekusi oleh `nft` dengan opsi `-f` (file).
- `flush ruleset`: hapus semua rule yang ada. Penting untuk memastikan tidak ada sisa rule lama.
- `table inet filter { ... }`: definisi table.
- `chain input { ... }`: base chain untuk input.
- `type filter hook input priority 0; policy drop;`: base chain dengan default deny.
- `iif lo accept`: izinkan loopback.
- `ct state established,related accept`: izinkan koneksi established/related.
- `ct state invalid drop`: jatuhkan paket dengan status invalid.
- `ip protocol icmp icmp type echo-request accept`: izinkan ping IPv4.
- `ip6 nexthdr icmpv6 icmpv6 type { echo-request, nd-neighbor-solicit, nd-neighbor-advert } accept`: izinkan ICMPv6 yang diperlukan.
- `tcp dport 22 accept`: izinkan SSH.
- `log prefix "nftables-drop: " counter drop`: log paket yang akan di-drop, lalu drop.
- `chain forward { ... }`: base chain untuk forwarding. `policy drop` penting untuk mencegah host menjadi router yang tidak diinginkan.
- `chain output { ... }`: base chain untuk output. `policy accept` biasanya aman.

---

## 5. Diagram Alur Packet Flow & Arsitektur nftables

### 5.1. Alur Paket Masuk

```
Jaringan
    |
    v
+-------------------+
|   Prerouting      |  (hook prerouting)
+-------------------+
    |
    v
+-------------------+
|   Routing         |
+-------------------+
    |
    +-------------------+
    |                   |
    v                   v
+-------------------+ +-------------------+
|   Input           | |   Forward         |
|   (hook input)    | |   (hook forward)  |
+-------------------+ +-------------------+
    |                   |
    v                   v
+-------------------+ +-------------------+
|   Proses Lokal    | |   Postrouting     |
|                   | |   (hook postrouting)
+-------------------+ +-------------------+
    |                   |
    v                   v
+-------------------+ +-------------------+
|   Output          | |   Keluar          |
|   (hook output)   | |                   |
+-------------------+ +-------------------+
    |
    v
+-------------------+
|   Postrouting     |
|   (hook postrouting)
+-------------------+
    |
    v
Jaringan
```

**Penjelasan:**
- Paket masuk melewati `prerouting`, lalu routing.
- Jika ditujukan ke host lokal, masuk ke `input`.
- Jika diteruskan, masuk ke `forward`.
- Paket yang keluar dari host melewati `output`, lalu `postrouting`.
- Setiap hook bisa memiliki base chain dengan prioritas berbeda.

### 5.2. Arsitektur nftables

```
+-------------------------------------------------------------+
|                        nft (userspace)                      |
+-------------------------------------------------------------+
|                        libnftables                          |
+-------------------------------------------------------------+
|                        Netlink                              |
+-------------------------------------------------------------+
|                        Kernel                               |
|  +-------------------+  +-------------------+               |
|  |   Table inet      |  |   Table ip nat    |               |
|  |   filter          |  |                   |               |
|  |  +-------------+  |  |  +-------------+  |               |
|  |  | chain input |  |  |  | chain post  |  |               |
|  |  |  (hook)     |  |  |  |  (hook)     |  |               |
|  |  +-------------+  |  |  +-------------+  |               |
|  +-------------------+  +-------------------+               |
+-------------------------------------------------------------+
```

**Penjelasan:**
- `nft` adalah userspace utility.
- `libnftables` adalah library yang menangani parsing dan komunikasi.
- Netlink adalah protokol komunikasi kernel-userspace.
- Kernel menyimpan ruleset dan mengeksekusinya pada paket.

---

## 6. Audit Kurikulum: Hal yang Perlu Ditambahkan

Kurikulum asli hanya memberikan perintah dasar:
```bash
sudo nft add table inet filter
sudo nft add chain inet filter input { type filter hook input priority 0\; policy drop\; }
sudo nft add rule inet filter input iif lo accept
sudo nft add rule inet filter input ct state established,related accept
sudo nft add rule inet filter input tcp dport 22 accept
sudo nft list ruleset
```

Saya menambahkan beberapa poin penting yang sering terlewat:

1. **Persistensi:** Menyimpan ruleset ke `/etc/nftables.conf` dan mengaktifkan `nftables.service`. Tanpa ini, aturan hilang setelah reboot.
2. **Chain `forward`:** Kebijakan `drop` untuk forward, penting jika host tidak dimaksudkan sebagai router.
3. **Chain `output`:** Kebijakan `accept` biasanya aman, tetapi bisa diperketat.
4. **ICMPv6:** Wajib untuk IPv6. Tanpa ICMPv6, IPv6 tidak akan berfungsi dengan baik.
5. **Logging:** `log prefix ... counter drop` untuk audit paket yang di-drop.
6. **Interaksi dengan libvirt:** libvirt akan menambahkan aturannya sendiri (mis. untuk NAT). Jangan `flush ruleset` sembarangan setelah libvirt berjalan.
7. **Masquerade/NAT:** Untuk network libvirt, diperlukan table `ip nat` dengan chain `postrouting` dan `masquerade`. Ini biasanya ditambahkan otomatis oleh libvirt, tetapi perlu dipahami.
8. **Atomic reload:** Gunakan `nft -f /etc/nftables.conf` untuk reload atomik.
9. **Debugging:** `nft monitor`, `nft --debug`, `meta nftrace set 1`.
10. **Rate limiting:** Untuk SSH, pertimbangkan rate limiting untuk mencegah brute force.
11. **Sets dan Maps:** Untuk efisiensi, gunakan named set untuk port atau IP.
12. **Konflik dengan Docker/libvirt:** Jika menggunakan Docker atau libvirt, mereka mungkin menambahkan aturan. Pahami urutan prioritas.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 1.5 atau sebagai modul tambahan “nftables Lanjutan untuk Virtualisasi”.

---

## 7. Hubungan dengan Modul Lain

- **Modul 1.3:** Socket libvirt aktif. Setelah nftables dikonfigurasi, pastikan libvirt tetap bisa berkomunikasi.
- **Modul 1.4:** Akses non-root. Firewall tidak boleh memblokir komunikasi ke socket libvirt (biasanya UNIX socket, tidak terpengaruh).
- **Fase 3:** VM akan dibuat. libvirt akan menambahkan aturan nftables untuk network NAT. Jangan kaget jika `nft list ruleset` menunjukkan aturan tambahan.
- **Fase 5:** Networking & isolasi. nftables akan digunakan untuk forwarding, NAT, dan isolasi antar segmen.
- **Fase 6:** Keamanan lanjutan. Firewall adalah bagian dari threat model.
- **Fase 8:** Migrasi dan observability. Firewall harus mengizinkan migrasi (port 16509, 49152-49215, dll.).

---

## 8. Referensi Lengkap

- **Arch Wiki: nftables** — https://wiki.archlinux.org/title/Nftables
- **nftables Wiki** — https://wiki.nftables.org/
- **nft(8) man page** — https://manpages.ubuntu.com/manpages/noble/man8/nft.8.html
- **nftables HowTo** — https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes
- **Simple stateful firewall** — https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server
- **Ubuntu nftables documentation** — https://documentation.ubuntu.com/security/security-features/network/firewall/nftables/
- **libvirt: Firewall and network filtering** — https://libvirt.org/firewall.html
- **nftables examples** — https://github.com/somarkn99/nftables-beginners-guide
- **nftables cheat sheet** — https://www.relianoid.com/nftables-command-cheatsheet/

---

## 9. Tips & Praktik Terbaik

1. **Selalu tambahkan rule SSH sebelum mengubah policy menjadi `drop`.** Ini mencegah lockout.
2. **Gunakan `policy drop` untuk input dan forward.** Output biasanya `accept`.
3. **Simpan ruleset ke `/etc/nftables.conf` dan aktifkan service.** Jangan hanya mengandalkan rule sementara.
4. **Gunakan `nft -f` untuk reload atomik.** Menghindari jendela waktu tanpa aturan.
5. **Jangan `flush ruleset` setelah libvirt berjalan.** libvirt menambahkan aturannya sendiri. Flush akan menghapusnya.
6. **Gunakan named set untuk daftar port atau IP.** Lebih efisien dan mudah diupdate.
7. **Log paket yang di-drop dengan prefix yang jelas.** Memudahkan debugging.
8. **Pertimbangkan rate limiting untuk SSH.** `tcp dport 22 ct state new limit rate 3/minute accept`.
9. **Untuk IPv6, izinkan ICMPv6 yang diperlukan.** Tanpa itu, IPv6 tidak berfungsi.
10. **Uji dari luar host.** Jangan hanya menguji dari localhost.
11. **Gunakan `nft monitor` untuk melihat event real-time.**
12. **Baca log dengan `journalctl -k | grep nftables`.**
13. **Jika menggunakan Docker, libvirt, atau VPN, pahami aturan yang mereka tambahkan.**
14. **Backup ruleset secara berkala.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Terkunci dari SSH setelah `policy drop` | Rule SSH belum ditambahkan atau salah. | Akses via konsol fisik, perbaiki rule. Selalu tambahkan SSH sebelum drop. |
| `nft list ruleset` tidak menampilkan aturan setelah reboot | Ruleset tidak disimpan ke `/etc/nftables.conf` atau service tidak aktif. | `sudo nft list ruleset > /etc/nftables.conf`, `sudo systemctl enable --now nftables`. |
| libvirt tidak bisa membuat network NAT | nftables memblokir forwarding atau masquerade. | Periksa chain `forward` dan table `ip nat`. Pastikan libvirt bisa menambahkan aturan. |
| IPv6 tidak berfungsi | ICMPv6 diblokir. | Tambahkan rule untuk ICMPv6. |
| `nft add rule` gagal dengan error `syntax error` | Escape `\;` hilang. | Gunakan `\;` untuk titik koma dalam blok `{ }`. |
| Rule tidak berurutan dengan benar | Prioritas salah. | Periksa `priority`. Semakin rendah, semakin awal. |
| `nft flush ruleset` menghapus aturan libvirt | Flush setelah libvirt berjalan. | Jangan flush setelah libvirt berjalan. Jika perlu, restart libvirt. |
| `nftables.service` gagal start | `/etc/nftables.conf` berisi error sintaks. | Periksa file, `nft -c -f /etc/nftables.conf` untuk cek. |
| Konflik antara `iptables` dan `nftables` | Keduanya aktif. | Gunakan hanya satu. `iptables-nft` menggunakan backend nftables. |
| `ct state established,related accept` tidak bekerja | Modul `nf_conntrack` tidak dimuat. | `sudo modprobe nf_conntrack`. |

---

## 11. Validasi & Troubleshooting Diperluas

**Validasi Lulus:**
- `nft list ruleset` menampilkan table `inet filter` dengan chain `input`, `forward`, `output`.
- Chain `input` memiliki `policy drop`.
- Rule `iif lo accept`, `ct state established,related accept`, dan `tcp dport 22 accept` ada.
- `systemctl status nftables` menunjukkan `active (exited)`.
- `systemctl is-enabled nftables` menunjukkan `enabled`.
- Setelah reboot, ruleset tetap ada.
- SSH tetap bisa diakses.
- `ping` ke host dari luar (jika diizinkan) berfungsi.
- libvirt masih bisa membuat network.

**Troubleshooting:**
- Jika `nft` tidak ditemukan: `sudo pacman -S nftables`.
- Jika `nftables.service` gagal: `journalctl -u nftables -xe`.
- Jika terkunci: akses via konsol fisik, atau gunakan `nft flush ruleset` dari konsol.
- Jika libvirt network gagal: `journalctl -u virtnetworkd -xe`. Periksa apakah nftables memblokir.
- Jika ingin melihat aturan libvirt: `nft list ruleset | grep libvirt`.
- Jika ingin debugging: `nft monitor` atau `nft --debug=netlink list ruleset`.
- Untuk tracing: `meta nftrace set 1` di rule, lalu `nft monitor trace`.

---

## 12. Latihan Mandiri

1. Buat table `inet filter` dan chain `input`, `forward`, `output`.
2. Terapkan `policy drop` untuk `input` dan `forward`, `policy accept` untuk `output`.
3. Tambahkan rule loopback, established/related, invalid drop, ICMP, ICMPv6, dan SSH.
4. Tambahkan rule logging untuk paket yang di-drop.
5. Simpan ruleset ke `/etc/nftables.conf`.
6. Aktifkan `nftables.service`.
7. Reboot dan verifikasi ruleset tetap ada.
8. Uji SSH dari host lain. Pastikan bisa.
9. Uji port lain (mis. 80). Pastikan diblokir.
10. Jalankan `nft list ruleset` dan jelaskan setiap rule.
11. Buat named set untuk port yang diizinkan. Modifikasi ruleset untuk menggunakannya.
12. Buat rate limiting untuk SSH. Uji dengan `ssh` berulang.
13. Jelaskan dengan kata-kata sendiri perbedaan `drop` dan `reject`.
14. Jelaskan mengapa `policy drop` penting.

---

## Penutup Fase 1

Selamat! Anda telah menyelesaikan seluruh Modul 1.1 hingga 1.5. Fase 1 sudah lengkap. Anda sekarang memiliki:
- Host Arch yang siap secara hardware.
- Stack virtualisasi headless terinstal.
- Daemon libvirt aktif dengan socket activation.
- Akses non-root via grup dan Polkit.
- Firewall nftables yang kuat dengan default deny.

**Proyek Fase 1:** Buat skrip `fase1-setup.sh` yang mengotomasi seluruh langkah di atas. Skrip harus:
- Memeriksa hardware.
- Menginstal paket.
- Mengaktifkan socket libvirt.
- Menambahkan user ke grup `libvirt`.
- Menerapkan baseline nftables.
- Idempotent (bisa dijalankan berulang tanpa error).

**Rubrik Fase 1:**
| Kriteria | Bobot |
|---|---|
| Audit hardware benar | 20% |
| Instalasi tanpa GUI | 20% |
| Daemon & socket aktif | 20% |
| Akses non-root berhasil | 20% |
| nftables baseline | 20% |

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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

