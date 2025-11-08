
# Peta Pembelajaran Lengkap: Menguasai Sistem Virtualisasi di Arch Linux — dari Dasar sampai Mahir

<!--
Semangat — ini peta pembelajaran terstruktur, praktis, dan lengkap agar Anda **memahami konsep**, **menguasai alat**, dan **mampu memodifikasi** komponen utama (terutama **QEMU** dan **libvirt**) sebagai pengembang. Setiap bagian disertai identitas teknologi (bahasa pembangun), prasyarat, bahan/rujukan resmi, tujuan pembelajaran, serta langkah-langkah praktikum yang dapat langsung Anda kerjakan di Arch Linux.
-->
> Catatan: untuk referensi teknis utama saya gunakan dokumentasi resmi dan Arch Wiki (sumber paling relevan untuk praktik di Arch). Sumber-sumber penting dicantumkan di akhir tiap seksi. ([wiki.archlinux.org][1])

---

# 1. Gambaran Umum & Tujuan Pembelajaran

**Tujuan akhir:** Anda mampu menjalankan host Arch Linux yang optimal untuk virtualisasi (KVM/QEMU), mengelola VM lewat libvirt/virt-manager dan virsh, melakukan PCI/VFIO passthrough, serta membaca/kontribusi kode QEMU atau libvirt (build & patch).

Kompetensi yang diperoleh:

* Konsep virtualisasi (full virtualization vs containerization, paravirtualization).
* Instalasi, konfigurasi, dan optimasi QEMU/KVM/libvirt di Arch.
* Virtual networking, storage, device passthrough (VFIO).
* Build, debug, dan kontribusi kode QEMU / libvirt (C, build system, pengujian).
* Automasi & integrasi (Python/libvirt bindings, shell scripts, systemd).

Referensi ringkas: Arch Wiki — QEMU & KVM; QEMU docs; libvirt docs; PCI passthrough guide. ([wiki.archlinux.org][1])

---

# 2. Identitas Teknologi Inti (singkat, untuk tiap alat)

Saya sertakan nama, bahasa pembangun, lisensi, dan persyaratan dasar untuk *mengembangkan atau memodifikasinya*.

1. **QEMU**

   * **Bahasa:** C. ([qemu.org][2])
   * **Lisensi:** Open source (GPL/dual-licensing beberapa bagian).
   * **Untuk memodifikasi:** paham C, Git, Meson/Make build system, device model (hw/), QEMU Object Model (QOM), QMP (QEMU Machine Protocol), alat debugging (gdb, valgrind). Rujukan pengembang: QEMU developer docs. ([qemu.org][3])

2. **KVM (Kernel-based Virtual Machine)**

   * **Bahasa:** C (bagian kernel). ([docs.kernel.org][4])
   * **Lisensi:** GPL (kernel).
   * **Untuk memodifikasi:** pemahaman kernel Linux (modul kernel, kvm API), perangkat keras virtualisasi (VT-x/AMD-V), tools kernel (perf, /dev/kvm), kemampuan membangun kernel dan modul.

3. **libvirt**

   * **Bahasa:** C untuk core; *bindings tersedia* untuk Python, Go, Perl, dll. ([libvirt.org][5])
   * **Lisensi:** Open source (GPL/other OSS licenses).
   * **Untuk memodifikasi:** paham C (core), XML domain format, API libvirt, serta kemampuan membuat binding atau client apps (Python sangat umum). Rujukan build & contributor docs. ([libvirt.org][6])

4. **virt-manager**

   * **Bahasa:** Python + GTK. ([wiki.archlinux.org][7])
   * **Untuk memodifikasi:** Python, GTK, libvirt API.

5. **VFIO & PCI Passthrough (IOMMU)**

   * **Bahasa:** Kernel C, user-space scripts/config.
   * **Untuk memodifikasi:** pemahaman IOMMU, vfio-pci, grup IOMMU, systemd/initramfs config. Arch Wiki PCI passthrough sangat praktis. ([wiki.archlinux.org][8])

---

# 3. Prasyarat & Persiapan Lingkungan (Alat & Paket di Arch)

Prasyarat pengetahuan: Linux dasar, shell, Git, pemrograman (C minimal), konsep jaringan, file systems.

Instalasi paket (daftar umum; sesuaikan kebutuhan):

```
sudo pacman -Syu qemu libvirt virt-manager edk2-ovmf dnsmasq bridge-utils ebtables virt-viewer \
             ovmf seabios swtpm
```

(Sesuaikan paket tambahan: `libvirt-daemon`, `libvirt-daemon-driver-qemu`, `virt-install`, `iproute2`, `iptables`/`nftables`.)
Rujukan instalasi dan konfigurasi Arch: QEMU & KVM pages di ArchWiki. ([wiki.archlinux.org][1])

Checklist hardware:

* CPU dengan VT-x / AMD-V.
* IOMMU (untuk passthrough) — aktifkan di BIOS/UEFI.
* Cukup RAM & storage, SSD direkomendasikan untuk VM performa tinggi.

---

# 4. Kurikulum Terperinci (Modul — Dari Dasar ke Mahir)

Setiap modul berisi tujuan, keterampilan, latihan praktikum, dan sumber belajar.

---

## Modul A — Konsep Dasar Virtualisasi (1–2 minggu)

**Tujuan:** Memahami perbedaan hypervisor tipe 1/2, container, paravirtualization, virtio.

**Materi & Aktivitas:**

* Teori virtualisasi, arsitektur host vs guest.
* Praktik: jalankan container (Docker) vs VM (QEMU) — bandingkan resource.
* Baca: Pengantar QEMU & KVM. ([qemu.org][9])

**Output:** Laporan singkat perbedaan container vs VM + benchmark sederhana (start time, memory).

---

## Modul B — Menyiapkan Host Arch untuk Virtualisasi (1 minggu)

**Tujuan:** Instalasi & konfigurasi dasar: enable libvirt service, koneksi pengguna ke group `libvirt`/`kvm`.

**Langkah praktikum:**

1. Install paket (lihat bagian 3).
2. Enable & start libvirt:

   ```
   sudo systemctl enable --now libvirtd
   sudo systemctl enable --now virtlogd
   ```
3. Tambah user ke `libvirt`/`kvm` group.
4. Cek KVM:

   ```
   lsmod | grep kvm
   sudo dmesg | grep -i kvm
   ```

Referensi: ArchWiki KVM & QEMU. ([wiki.archlinux.org][10])

---

## Modul C — Membuat VM Dasar & Manajemen dengan libvirt (2 minggu)

**Tujuan:** Buat VM dari cloud image (qcow2), gunakan `virt-install`, `virsh`, virt-manager.

**Praktikum:**

* Unduh cloud image (mis. Arch cloud / Ubuntu cloud).
* Buat storage pool, network default (NAT), dan VM:

  ```
  virt-install --name vm1 --ram 2048 --vcpus 2 --disk path=/var/lib/libvirt/images/vm1.qcow2,size=10 \
               --os-type linux --import --network network=default --graphics none
  ```
* Eksperimen: snapshot, cloning, migrate (jika ada host kedua).

**Belajar file:** Domain XML libvirt (struktur untuk modifikasi manual). ([libvirt.org][11])

---

## Modul D — Virtual Networking & Storage (2 minggu)

**Tujuan:** Memahami bridge, macvtap, NAT, virtual NIC (virtio), storage backend (qcow2, raw, LVM, Ceph).

**Latihan:**

* Buat bridge network manual (`ip link`, `brctl` atau `iproute2`).
* Uji performance virtio-net vs e1000.
* Buat volume LVM dan gunakan sebagai disk VM; bandingkan performa `qcow2` vs `raw`.

Sumber: Arch Wiki networking & QEMU docs (virtio). ([wiki.archlinux.org][1])

---

## Modul E — Performa & Tuning (2 minggu)

**Tujuan:** Optimisasi CPU pinning, hugepages, IO tuning, cache modes, NUMA.

**Latihan:**

* Konfigurasi `vcpupin`, `cputune`, `numatune` di domain XML.
* Aktifkan hugepages (`/proc/meminfo`), sesuaikan `qemu` arguments.
* Ukur dengan `perf`, `iostat`, `virt-top`.

Rujukan performa QEMU/KVM dan Arch tuning notes. ([wiki.archlinux.org][1])

---

## Modul F — PCI Passthrough / VFIO (3–4 minggu)

**Tujuan:** Lakukan GPU atau device passthrough menggunakan VFIO dan OVMF (UEFI guest).

**Langkah praktikum (high-level):**

1. Aktifkan IOMMU di kernel (tambahkan `intel_iommu=on` atau `amd_iommu=on` di kernel cmdline).
2. Identifikasi device `lspci -nn`.
3. Bind device ke `vfio-pci` (via modprobe.d / initramfs).
4. Konfigurasi libvirt domain untuk passthrough (attach `hostdev` dengan vendor:device id).
5. Gunakan OVMF (edk2-ovmf) untuk UEFI guest. ([wiki.archlinux.org][8])

**Catatan:** Passthrough menuntut hardware & BIOS mendukung IOMMU dan isolasi grup IOMMU.

---

## Modul G — Keamanan & Isolasi (2 minggu)

**Tujuan:** Pelajari sVirt (SELinux), AppArmor, dan best practices (no unnecessary shared folders, minimal device exposure).

**Topik:** sVirt integration via libvirt, udev rules, cgroup tuning. Rujukan libvirt security docs.

---

## Modul H — Build & Modifikasi QEMU (4–6 minggu)

**Tujuan:** Bisa meng-compile QEMU dari source, menavigasi kode, menambahkan device sederhana, dan mengirim patch.

**Langkah praktikum:**

1. Siapkan build deps (lihat QEMU build-environment docs). ([qemu.org][12])
2. Clone repo:

   ```
   git clone https://git.qemu.org/qemu.git
   cd qemu
   ./configure --target-list=x86_64-softmmu
   make -j$(nproc)
   ```

   (Catatan: QEMU sekarang menggunakan Meson/Ninja di versi terbaru; ikuti build docs). ([qemu.org][13])
3. Pelajari struktur `hw/` (device models) dan QOM (QEMU Object Model).
4. Tambah device sederhana (contoh: virtual sensor) → compile → jalankan VM dengan device baru.
5. Gunakan QMP untuk scripting kontrol QEMU.

**Kontribusi:** Baca panduan kontribusi QEMU (mailing list patch workflow, coding style). ([wiki.qemu.org][14])

---

## Modul I — Build & Modifikasi libvirt (3–5 minggu)

**Tujuan:** Build libvirt dari source, pahami driver QEMU, domain lifecycle, dan penanganan API.

**Langkah praktikum:**

1. Clone libvirt, ikuti instruksi compiling. ([libvirt.org][15])
2. Pelajari kode driver QEMU (`src/qemu`), modul daemon.
3. Buat patch kecil: mis. logging improvement, uji unit tests, kirim PR sesuai panduan proyek.
4. Pelajari binding Python: buat skrip untuk buat/modifikasi domain XML.

---

## Modul J — Debugging & Tooling Lanjutan (3 minggu)

**Tujuan:** Debug guest/host crashes, trace performance, dan mengumpulkan laporan bug yang berguna.

**Alat & Teknik:**

* `gdb` attach ke qemu process / qemu-system-x86_64.
* `perf`, `ftrace`, `systemtap`.
* Reproduksi minimal: image kecil, arguments minimal.
* Menulis patch dengan test case, dan mengirim patch sesuai kontributor docs. ([qemu.org][3])

---

# 5. Rencana Projek Praktik (3 proyek bertahap)

1. **Proyek 1 (Dasar):** Host Arch dengan 3 VM (server, desktop, CI runner) + dokumentasi setup (Network & Storage).
2. **Proyek 2 (Intermediate):** Automasi provisioning VM dengan libvirt + Python script dan integrasi ke systemd. Tes snapshot & migrate.
3. **Proyek 3 (Advanced):** Implementasi GPU passthrough + modifikasi QEMU untuk menambahkan device paravirtual sederhana; buat patch dan kirim ke mailing list dev QEMU/libvirt.

---

# 6. Tools & Bahasa yang Harus Dikuasai (prioritas)

* **Wajib:** C (QEMU, kernel), Shell scripting (bash), Git, systemd, XML (libvirt domain), Meson/Ninja atau autotools, make.
* **Sangat berguna:** Python (libvirt bindings, virt-manager), perf/gdb/valgrind, networking tools (ip, bridge), LVM, QMP (JSON over socket).
* **Opsional/Modern:** Go (untuk beberapa tooling), Rust (jika Anda tertarik membangun tooling baru), Lua (jika membuat plugin/skrip internal).

---

# 7. Cara Belajar & Praktik Efektif (metode)

* **Prinsip 70/30:** 70% praktek (lab), 30% baca dokumentasi & kode.
* **Catatan harian:** dokumentasikan langkah, perintah, error dan solusinya (berguna saat debugging dan kontribusi).
* **Kontribusi kecil dulu:** dokumentasi, contoh konfigurasi, lalu code patches.
* **Gunakan VM snapshot** sebelum eksperimen berisiko (kernel tweak, passthrough).

---

# 8. Sumber Rujukan Utama (penting — silakan baca berurutan)

* ArchWiki — QEMU (setup & tips khusus Arch). ([wiki.archlinux.org][1])
* ArchWiki — KVM (penjelasan kernel & enablement). ([wiki.archlinux.org][10])
* QEMU documentation (user & developer). ([qemu.org][2])
* libvirt official docs & manual pages (API, domain XML, contributor). ([libvirt.org][6])
* ArchWiki — PCI passthrough / OVMF (VFIO examples). ([wiki.archlinux.org][8])
* QEMU developer / contributing guides (code style, patch workflow). ([qemu.org][3])

---

# 9. Checklist Praktis untuk 90 Hari Pertama (roadmap singkat)

* Hari 0–7: Instal & konfigurasi host (qemu, libvirt, virt-manager). Tes VM dasar. ([wiki.archlinux.org][1])
* Minggu 2–3: Virtual networking & storage; buat automatisasi script untuk provisioning. ([qemu.org][9])
* Minggu 4–6: Performa & VFIO passthrough (jika hardware mendukung). ([wiki.archlinux.org][8])
* Bulan 2–3: Build & modifikasi QEMU/libvirt; kirim dokumentasi/pull request kecil. ([qemu.org][13])

---

# 10. Catatan Khusus bagi Anda (penyesuaian dengan preferensi)

* Karena Anda menyukai CLI/TUI: saya rekomendasikan **mengotomatiskan semua langkah** dengan skrip shell + menulis TUI (contoh: menggunakan `ncurses` di C atau Rust) untuk menjalankan operasi libvirt/qemu. Untuk integrasi libvirt via kode, **Python** + `libvirt` binding sangat cepat untuk prototyping. ([libvirt.org][6])
* Jika tujuan akhir adalah membuat tooling TUI/CLI (mis. satu binary dengan UI TUI), fondasi menggunakan **QEMU + libvirt** adalah tepat karena keduanya menyediakan API/command-line yang dapat dikendalikan dari program eksternal. ([qemu.org][2])

---

# 11. Rekomendasi Buku & Bacaan Lanjutan

* QEMU Developer Documentation (baca bagian QOM & device model). ([qemu.org][3])
* Kernel KVM API docs (kernel.org) untuk memahami struktur `kvm_run`. ([docs.kernel.org][4])
* Libvirt API docs & Domain XML reference. ([libvirt.org][6])

---

# 12. Penutup motivasional singkat

Rangkaian ini dirancang agar Anda **bermain dengan sistem** sambil terus membaca dokumentasi resmi dan kode sumber — pendekatan yang paling cepat membuat Anda mahir. Ikuti modul bertahap, catat setiap percobaan (termasuk kegagalan), dan konversi pengalaman itu menjadi dokumentasi atau patch — itu adalah nilai tambah besar dalam komunitas open source.

<!--
Saya sudah menyiapkan:

* Rencana pelajaran mingguan terperinci (dengan perintah CLI lengkap dan file contoh domain XML).
* Set contoh skrip automasi (provisioning + backup VM).
* Panduan langkah-demi-langkah untuk compile QEMU & libvirt di Arch.

Saya akan menyiapkan semua itu sekarang jika Anda ingin — saya akan buatkan paket materi lengkap (README + lab step-by-step + checklist build environment + contoh domain XML + contoh patch QEMU sederhana). Ini akan termasuk perintah `pacman`/systemd yang dapat Anda jalankan di Arch.

Semangat: Anda bisa mulai dari instalasi dasar hari ini, lalu setiap minggu kita lanjut ke modul berikutnya dan saya akan menilai progres Anda sesuai permintaan.

-->
[1]: https://wiki.archlinux.org/title/QEMU?utm_source=chatgpt.com "QEMU - ArchWiki"
[2]: https://www.qemu.org/documentation?utm_source=chatgpt.com "QEMU documentation"
[3]: https://www.qemu.org/docs/master/devel/index.html?utm_source=chatgpt.com "Developer Information — QEMU documentation"
[4]: https://docs.kernel.org/virt/kvm/index.html?utm_source=chatgpt.com "KVM"
[5]: https://libvirt.org/?utm_source=chatgpt.com "libvirt: The virtualization API"
[6]: https://libvirt.org/docs.html?utm_source=chatgpt.com "libvirt: Documentation"
[7]: https://wiki.archlinux.org/title/Virt-manager?utm_source=chatgpt.com "Virt-manager - ArchWiki"
[8]: https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF?utm_source=chatgpt.com "PCI passthrough via OVMF"
[9]: https://www.qemu.org/docs/master/system/introduction.html?utm_source=chatgpt.com "Introduction — QEMU documentation"
[10]: https://wiki.archlinux.org/title/KVM?utm_source=chatgpt.com "KVM - ArchWiki"
[11]: https://libvirt.org/formatdomain.html?utm_source=chatgpt.com "Domain XML format"
[12]: https://www.qemu.org/docs/master/devel/build-environment.html?utm_source=chatgpt.com "Setup build environment"
[13]: https://www.qemu.org/docs/master/devel/build-system.html?utm_source=chatgpt.com "The QEMU build system architecture"
[14]: https://wiki.qemu.org/Contribute?utm_source=chatgpt.com "Contribute"
[15]: https://libvirt.org/compiling.html?utm_source=chatgpt.com "libvirt Installation"
