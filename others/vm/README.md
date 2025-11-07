# Virtual Machine

Di Arch Linux, ada cukup banyak **Virtual Machine (VM) platform** yang bisa digunakan, dan hampir semuanya berjalan dengan sangat baik karena kernel Arch yang selalu mutakhir serta mendukung KVM (Kernel-based Virtual Machine) secara native.
Namun, masing-masing VM punya *filosofi desain*, *kinerja*, dan *tujuan penggunaan* yang berbeda.

Mari kita bedah secara terstruktur dan mendalam:

---

## 🧩 1. QEMU + KVM (Kernel-based Virtual Machine)

**Bahasa pemrograman:** C
**Lisensi:** GPLv2
**Dibangun di atas:** Kernel Linux (dengan modul `kvm` aktif)

### Gambaran:

QEMU adalah mesin virtual lintas arsitektur, sedangkan KVM adalah ekstensi kernel untuk mempercepat virtualisasi dengan CPU Intel VT-x/AMD-V. Di Arch, keduanya biasa dikombinasikan menjadi **QEMU-KVM**.

### Keunggulan:

* **Performa native**: mendekati bare-metal dengan akselerasi hardware.
* **Sangat fleksibel**: mendukung arsitektur x86, ARM, RISC-V, MIPS, dan PowerPC.
* **Integrasi kuat** dengan libvirt, virt-manager, GNOME Boxes, dan `virt-install`.
* Cocok untuk server, desktop, bahkan embedded systems.

### Kekurangan:

* Konfigurasi manual cukup kompleks jika tanpa frontend (harus menulis argumen panjang QEMU).
* Antarmuka CLI cukup teknis bagi pengguna baru.

### Untuk memodifikasi:

* Harus paham konsep virtualisasi kernel (`/dev/kvm`, `qemu-system-x86_64`, `libvirt` XML).
* Pengalaman disarankan dalam bahasa C, shell scripting, dan konsep kernel module.

---

## 🖥️ 2. VirtualBox (oleh Oracle)

**Bahasa pemrograman:** C++
**Lisensi:** GPLv2 untuk edisi open source (OSE), dan PUEL untuk versi binary Oracle.
**Dependensi utama:** Qt (untuk GUI), DKMS (untuk kernel module rebuild otomatis).

### Gambaran:

VirtualBox adalah VM yang populer karena GUI-nya mudah dan multiplatform (Windows, macOS, Linux).

### Keunggulan:

* GUI ramah pengguna, cocok untuk pemula.
* Mendukung drag-and-drop file antar host–guest.
* Snapshot dan cloning cepat.
* Tersedia ekstensi untuk USB 3.0, clipboard sharing, dsb.

### Kekurangan:

* Performa di bawah QEMU/KVM.
* Sering bermasalah setelah pembaruan kernel di Arch (modul `vboxdrv` perlu di-rebuild).
* Tidak efisien untuk server headless.

### Untuk memodifikasi:

* Pahami C++ dan Qt jika ingin membangun dari source.
* Butuh pengalaman dengan modul kernel (driver vboxdrv, vboxnetflt).

---

## 🧮 3. VMware Workstation / Player

**Bahasa pemrograman:** C, C++
**Lisensi:** Proprietary (berbayar untuk Workstation, gratis untuk Player)
**Kompatibilitas tinggi:** Windows dan Linux.

### Gambaran:

VMware terkenal dengan kestabilan dan performa di level enterprise.

### Keunggulan:

* Integrasi solid dengan berbagai OS guest (fitur VMware Tools).
* Snapshot dan cloning profesional.
* Performa grafis (OpenGL, DirectX) lebih tinggi dibanding VirtualBox.
* Cocok untuk keperluan pengujian multi-OS enterprise.

### Kekurangan:

* Tidak open source.
* Instalasi di Arch kadang perlu patch manual.
* Tidak cocok untuk integrasi otomatis via script seperti QEMU.

### Untuk memodifikasi:

* Hampir tidak bisa, karena kode sumber tidak terbuka.

---

## 💻 4. GNOME Boxes

**Bahasa pemrograman:** C, Vala
**Backend:** libvirt + QEMU/KVM
**Lisensi:** GPLv3

### Gambaran:

Antarmuka virtualisasi sederhana untuk pengguna GNOME. Sebenarnya hanyalah *frontend* dari libvirt/QEMU.

### Keunggulan:

* GUI sangat sederhana.
* Terintegrasi dengan baik dalam lingkungan GNOME.
* Otomatis menggunakan akselerasi hardware.

### Kekurangan:

* Fitur terbatas (tidak bisa kustomisasi kernel argumen).
* Tidak cocok untuk eksperimen kompleks.

### Untuk memodifikasi:

* Harus memahami Vala (bahasa turunan dari C yang digunakan GNOME) dan DBus.

---

## ⚙️ 5. Virt-Manager (Virtual Machine Manager)

**Bahasa pemrograman:** Python + GTK
**Backend:** libvirt + QEMU/KVM
**Lisensi:** GPLv2

### Gambaran:

GUI yang lebih teknis dan lengkap dibanding GNOME Boxes. Sering digunakan administrator sistem profesional.

### Keunggulan:

* Bisa membuat, mengedit, dan mengelola VM via antarmuka grafis dan CLI (`virsh`).
* Menyimpan konfigurasi dalam XML → mudah diotomasi atau dikloning.
* Sangat stabil di Arch Linux.

### Kekurangan:

* GUI agak berat dibanding Boxes.
* Sedikit membingungkan untuk pemula.

### Untuk memodifikasi:

* Pahami Python dan API `libvirt`.
* Konsep domain XML, storage pool, dan network bridge perlu dikuasai.

---

## 🧱 6. Docker (bukan VM penuh tapi container)

**Bahasa pemrograman:** Go
**Lisensi:** Apache 2.0

### Gambaran:

Bukan virtual machine sungguhan, tapi *containerization system* — memisahkan lingkungan aplikasi dalam ruang pengguna (user space) dengan kernel yang sama.

### Keunggulan:

* Sangat ringan, cepat, dan ideal untuk aplikasi terisolasi.
* Integrasi kuat dengan CI/CD pipeline dan DevOps.
* Mendukung image reproducible dengan `Dockerfile`.

### Kekurangan:

* Bukan hypervisor → tidak cocok untuk sistem operasi lengkap.
* Isolasi kernel lebih lemah dibanding VM tradisional.

### Untuk memodifikasi:

* Pahami bahasa Go, namespace Linux, cgroups, dan overlay filesystem.

---

## 🪶 7. LXC / LXD (Linux Containers)

**Bahasa pemrograman:** C (LXC), Go (LXD)
**Lisensi:** Apache 2.0

### Gambaran:

Mirip Docker, tetapi lebih mendekati VM tradisional. Setiap container seperti “mini Linux” dengan sistem init sendiri.

### Keunggulan:

* Performa sangat cepat.
* Mendukung sistem init (systemd, OpenRC) di dalam container.
* Cocok untuk eksperimen server dan pengujian ringan.

### Kekurangan:

* Sedikit lebih kompleks dibanding Docker.
* Dokumentasi kurang populer dibanding QEMU atau VirtualBox.

---

## 🪐 Ringkasan Perbandingan

| VM / Container | Kecepatan | Fleksibilitas | GUI     | Kemudahan Konfigurasi  | Lisensi     | Ideal Untuk                       |
| -------------- | --------- | ------------- | ------- | ---------------------- | ----------- | --------------------------------- |
| QEMU + KVM     | ★★★★★     | ★★★★★         | CLI/GUI | Sulit (tanpa frontend) | GPLv2       | Virtualisasi penuh, OS testing    |
| Virt-Manager   | ★★★★★     | ★★★★☆         | GUI     | Mudah                  | GPLv2       | Pengguna teknis & admin sistem    |
| GNOME Boxes    | ★★★★☆     | ★★☆☆☆         | GUI     | Sangat mudah           | GPLv3       | Pemula, penggunaan kasual         |
| VirtualBox     | ★★★☆☆     | ★★★☆☆         | GUI     | Mudah                  | GPLv2/PUEL  | Pengguna desktop biasa            |
| VMware         | ★★★★☆     | ★★★☆☆         | GUI     | Sedang                 | Proprietary | Enterprise dan profesional        |
| Docker         | ★★★★★     | ★★★☆☆         | CLI     | Mudah                  | Apache 2.0  | Developer aplikasi                |
| LXC/LXD        | ★★★★★     | ★★★★☆         | CLI     | Sedang                 | Apache 2.0  | Admin server dan pengujian ringan |

---

Jika kamu ingin **membangun atau memodifikasi sistem VM sendiri**, maka **QEMU + KVM + libvirt** adalah fondasi yang paling tepat.
Ia **sepenuhnya open source**, bisa diintegrasikan ke dalam TUI buatanmu sendiri, dan dapat dikendalikan lewat bahasa apapun (Python, C, Lua, bahkan Dart dengan binding FFI).

---

