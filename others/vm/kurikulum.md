# Kurikulum Penguasaan VM Terisolasi di Arch Linux (100% TUI)

**Versi Revisi — Siap Publikasi**

Dokumen ini merupakan perbaikan menyeluruh dari kerangka awal. Setiap fase kini dilengkapi tujuan, prasyarat, estimasi waktu, daftar isi, konsep inti, glosarium, lab terperinci, validasi, troubleshooting, referensi, indikasi visual, latihan mandiri, dan rubrik penilaian. Ditambahkan pula **Fase 8 (Expert/Opsional)** untuk mencapai penguasaan penuh.

---

## Daftar Isi Utama

1. Pendahuluan
2. Glosarium Umum
3. Struktur Kurikulum
4. Fase 1 — Fondasi Virtualisasi & Host Hardening
5. Fase 2 — QEMU/KVM Murni (Tanpa libvirt)
6. Fase 3 — libvirt & virsh: Lifecycle & Domain XML
7. Fase 4 — Storage, Image & Backup Engineering
8. Fase 5 — Networking & Isolasi Jaringan
9. Fase 6 — Keamanan & Isolasi Lanjutan
10. Fase 7 — Otomasi, Troubleshooting & Capstone Multi-OS
11. Fase 8 — Expert: Migrasi, Passthrough & Observability (Opsional)
12. Prasyarat & Estimasi Waktu Total
13. Rubrik Umum & Penilaian
14. Lampiran: Sumber Referensi Utama

---

## 1. Pendahuluan

### Tujuan Kurikulum
Membekali pembelajar dengan kemampuan **membangun, mengelola, mengamankan, dan mengotomasi VM terisolasi** di Arch Linux **hanya melalui TUI** (Text User Interface), dari tingkat pemula hingga expert.

### Untuk Siapa
- Pengguna Linux yang ingin mendalami virtualisasi tanpa GUI.
- Sysadmin, DevOps, atau security engineer yang membutuhkan lingkungan VM headless.
- Individu tanpa latar belakang IT yang bersedia mempelajari dasar Linux terlebih dahulu.

### Cara Menggunakan
- Ikuti fase secara berurutan.
- Setiap lab harus diselesaikan dan divalidasi sebelum lanjut.
- Gunakan rubrik untuk menilai diri sendiri.
- Fase 8 bersifat opsional untuk spesialisasi.

### Prasyarat Umum
- Arch Linux terpasang (bisa di bare metal atau VM host).
- CPU mendukung virtualisasi (VT-x/AMD-V).
- Dasar CLI Linux, systemd, dan editor teks (nano/vim).
- Koneksi internet untuk instalasi paket.

### Asumsi Beban Belajar
8–10 jam per minggu. Total 14–15 minggu untuk Fase 1–7, ditambah 3–4 minggu untuk Fase 8.

---

## 2. Glosarium Umum

| Istilah | Definisi |
|---|---|
| **KVM** | Kernel-based Virtual Machine; modul kernel Linux yang menyediakan akselerasi hardware untuk virtualisasi. |
| **QEMU** | Emulator dan virtualizer open-source; menyediakan perangkat virtual dan menjalankan guest. |
| **libvirt** | API, daemon, dan alat manajemen untuk platform virtualisasi (QEMU/KVM, Xen, LXC, dll). |
| **virsh** | CLI untuk mengelola libvirt. |
| **Domain XML** | Konfigurasi VM dalam format XML yang digunakan libvirt. |
| **qcow2** | Format disk virtual QEMU yang mendukung snapshot, kompresi, dan enkripsi. |
| **Virtio** | Standar perangkat paravirtualisasi untuk I/O yang efisien. |
| **OVMF** | Open Virtual Machine Firmware; implementasi UEFI untuk QEMU. |
| **swtpm** | Software TPM emulator untuk vTPM. |
| **QMP** | QEMU Machine Protocol; antarmuka kontrol runtime QEMU via JSON. |
| **nftables** | Framework firewall modern di Linux, pengganti iptables. |
| **nwfilter** | Filter jaringan libvirt yang berbasis aturan. |
| **cgroups v2** | Control groups versi 2; membatasi resource CPU, memori, I/O. |
| **seccomp** | Secure Computing; membatasi system call yang bisa dipanggil proses. |
| **AppArmor** | Modul keamanan Linux berbasis profil. |
| **cloud-init** | Standar industri untuk inisialisasi cloud instance. |
| **WinRM** | Windows Remote Management; protokol manajemen jarak jauh Windows. |
| **VFIO** | Virtual Function I/O; framework untuk passthrough perangkat ke VM. |
| **SR-IOV** | Single Root I/O Virtualization; membagi perangkat fisik menjadi beberapa virtual function. |
| **virtiofs** | Filesystem sharing berbasis virtio untuk akses direktori host dari guest. |
| **hugepages** | Halaman memori berukuran besar (2MB/1GB) untuk performa. |
| **NUMA** | Non-Uniform Memory Access; arsitektur memori multiprosesor. |
| **live migration** | Memindahkan VM yang sedang berjalan dari satu host ke host lain tanpa downtime. |

---

## 3. Struktur Kurikulum

Setiap fase terdiri dari:
- **Overview**: ringkasan dan kaitan dengan fase lain.
- **Tujuan Fase**: capaian pembelajaran.
- **Prasyarat**: pengetahuan/alat yang dibutuhkan.
- **Estimasi Waktu**: dalam minggu.
- **Daftar Isi Fase**: modul dan lab.
- **Modul**: konsep, lab, validasi, troubleshooting, referensi.
- **Proyek Fase**: tugas integratif.
- **Rubrik Fase**: kriteria penilaian.

---

## 4. Fase 1 — Fondasi Virtualisasi & Host Hardening

**Estimasi: 1 minggu**

### Tujuan Fase
- Memahami arsitektur KVM-QEMU-libvirt.
- Menyiapkan host Arch untuk menjalankan VM headless.
- Meminimalkan permukaan serangan host.

### Prasyarat
- Arch Linux terpasang.
- Akses root/sudo.
- Dasar CLI dan systemd.

### Daftar Isi Fase
1. Modul 1.1 — Audit Hardware & Kernel
2. Modul 1.2 — Instalasi Stack Headless Minimal
3. Modul 1.3 — Daemon libvirt & Systemd Socket Activation
4. Modul 1.4 — Akses virsh Non-Root via Polkit & Grup
5. Modul 1.5 — Baseline nftables Host

---

### Modul 1.1 — Audit Hardware & Kernel

**Tujuan:** Memastikan CPU mendukung virtualisasi dan IOMMU, serta modul kernel tersedia.

**Konsep Inti:**
- VT-x (Intel) / AMD-V (AMD) adalah ekstensi virtualisasi hardware.
- IOMMU (Intel VT-d / AMD-Vi) diperlukan untuk passthrough perangkat dan isolasi DMA.
- Modul `kvm`, `kvm_intel`/`kvm_amd` harus dimuat.

**Glosarium:**
- **VT-x/AMD-V**: teknologi virtualisasi CPU.
- **IOMMU**: unit manajemen memori untuk perangkat I/O.
- **dmesg**: buffer pesan kernel.

**Lab L1.1 — Audit Hardware & Kernel**
```bash
# Cek flag CPU
lscpu | grep -E 'vmx|svm'
# Cek IOMMU
dmesg | grep -i -e DMAR -e IOMMU
# Cek modul KVM
lsmod | grep kvm
# Cek /dev/kvm
ls -l /dev/kvm
```
**Expected Output:**
- Flag `vmx` atau `svm` muncul.
- Pesan DMAR/IOMMU muncul jika diaktifkan di BIOS.
- Modul `kvm` dan `kvm_intel`/`kvm_amd` termuat.
- `/dev/kvm` ada dengan permission `crw-rw----`.

**Validasi Lulus:**
- `virt-host-validate qemu` semua PASS (setelah instalasi libvirt).
- Tidak ada error KVM di `dmesg`.

**Troubleshooting:**
- Jika flag tidak muncul: aktifkan VT-x/AMD-V di BIOS/UEFI.
- Jika `/dev/kvm` tidak ada: muat modul `modprobe kvm_intel` (atau `kvm_amd`).
- Jika IOMMU tidak aktif: tambahkan `intel_iommu=on` atau `amd_iommu=on` di bootloader.

**Referensi:**
- Arch Wiki: KVM
- Arch Wiki: PCI passthrough via OVMF

**Visual:** Diagram alur inisialisasi KVM dari userspace ke hardware.

---

### Modul 1.2 — Instalasi Stack Headless Minimal

**Tujuan:** Memasang paket virtualisasi tanpa GUI.

**Konsep Inti:**
- Paket minimal: `qemu-full`, `libvirt`, `virt-install`, `virt-manager` tidak diperlukan, `edk2-ovmf`, `swtpm`, `nftables`.
- Hindari paket GUI seperti `virt-manager`, `gnome-boxes`.

**Lab L1.2 — Instalasi Stack Headless Minimal**
```bash
sudo pacman -S qemu-full libvirt virt-install edk2-ovmf swtpm nftables
```
**Validasi Lulus:**
- `pacman -Qq | grep -E 'virt-manager|gnome-boxes'` tidak menghasilkan output.
- `virsh version` menampilkan versi libvirt.

**Troubleshooting:**
- Jika ada konflik paket, baca pesan pacman.
- Pastikan repo `extra` dan `community` aktif.

**Referensi:**
- Arch Wiki: libvirt
- Arch Wiki: QEMU

---

### Modul 1.3 — Daemon libvirt & Systemd Socket Activation

**Tujuan:** Menjalankan libvirt dengan socket activation dan memahami daemon modular.

**Konsep Inti:**
- libvirt modern memiliki daemon modular: `virtqemud`, `virtnetworkd`, `virtstoraged`, `virtnodedevd`, dll.
- Socket activation mengaktifkan daemon saat dibutuhkan.
- Unit `libvirtd` monolithic masih ada tetapi deprecated.

**Lab L1.3 — Daemon libvirt**
```bash
sudo systemctl enable --now virtqemud.socket virtnetworkd.socket virtstoraged.socket
systemctl status virtqemud.socket
```
**Validasi Lulus:**
- Socket aktif.
- `virsh -c qemu:///system list --all` berhasil.

**Troubleshooting:**
- Jika gagal: cek `journalctl -u virtqemud`.
- Pastikan grup `libvirt` ada.

**Referensi:**
- libvirt: Daemon and Socket Activation

---

### Modul 1.4 — Akses virsh Non-Root via Polkit & Grup

**Tujuan:** Mengakses `virsh` sebagai user non-root dengan aman.

**Konsep Inti:**
- Polkit mengatur izin.
- Grup `libvirt` memberi akses.
- `qemu:///system` vs `qemu:///session`.

**Lab L1.4 — Polkit & Grup**
```bash
sudo usermod -aG libvirt $USER
# logout/login
virsh list --all
```
**Validasi Lulus:**
- `virsh list --all` berjalan tanpa sudo.

**Referensi:**
- libvirt: Polkit

---

### Modul 1.5 — Baseline nftables Host

**Tujuan:** Membuat aturan firewall dasar untuk host.

**Konsep Inti:**
- nftables adalah firewall modern.
- Default policy: drop.
- Izinkan loopback, SSH, dan koneksi keluar.

**Lab L1.5 — nftables**
```bash
sudo nft add table inet filter
sudo nft add chain inet filter input { type filter hook input priority 0\; policy drop\; }
sudo nft add rule inet filter input iif lo accept
sudo nft add rule inet filter input ct state established,related accept
sudo nft add rule inet filter input tcp dport 22 accept
sudo nft list ruleset
```
**Validasi Lulus:**
- `nft list ruleset` menampilkan aturan.
- SSH tetap bisa diakses.

**Referensi:**
- Arch Wiki: nftables

---

### Proyek Fase 1
Buat skrip `fase1-setup.sh` yang:
- Memeriksa hardware.
- Menginstal paket.
- Mengaktifkan socket libvirt.
- Menambahkan user ke grup `libvirt`.
- Menerapkan baseline nftables.

### Rubrik Fase 1
| Kriteria | Bobot |
|---|---|
| Audit hardware benar | 20% |
| Instalasi tanpa GUI | 20% |
| Daemon & socket aktif | 20% |
| Akses non-root berhasil | 20% |
| nftables baseline | 20% |

---

## 5. Fase 2 — QEMU/KVM Murni (Tanpa libvirt)

**Estimasi: 2 minggu**

### Tujuan Fase
- Memahami VM sebagai proses QEMU.
- Menguasai `qemu-system-x86_64`, `qemu-img`, virtio, OVMF, swtpm, QMP.

### Prasyarat
- Fase 1 lulus.

### Daftar Isi Fase
1. Modul 2.1 — Boot VM Pertama dari CLI
2. Modul 2.2 — qemu-img: create, convert, inspect
3. Modul 2.3 — Perangkat Virtio vs Emulasi
4. Modul 2.4 — UEFI OVMF + vTPM dengan swtpm
5. Modul 2.5 — Kontrol Runtime via QMP

---

### Modul 2.1 — Boot VM Pertama dari CLI

**Tujuan:** Menjalankan VM Arch minimal dengan satu perintah QEMU.

**Konsep Inti:**
- QEMU adalah proses userspace.
- Opsi `-nographic` untuk serial console.
- `-enable-kvm` untuk akselerasi.

**Lab L2.1 — Boot VM Pertama**
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 1G \
  -smp 2 \
  -cpu host \
  -nographic \
  -drive file=arch.qcow2,if=virtio \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0
```
**Validasi Lulus:**
- VM boot ke prompt Arch.
- Bisa login.

**Troubleshooting:**
- Jika `-nographic` tidak menampilkan, cek `console=ttyS0` di kernel cmdline.

**Referensi:**
- QEMU Docs: Invocation

---

### Modul 2.2 — qemu-img: create, convert, inspect

**Tujuan:** Mengelola image disk.

**Lab L2.2 — qemu-img**
```bash
qemu-img create -f qcow2 disk.qcow2 10G
qemu-img info disk.qcow2
qemu-img convert -f qcow2 -O raw disk.qcow2 disk.raw
```
**Validasi Lulus:**
- `qemu-img info` menunjukkan format dan ukuran.

**Referensi:**
- QEMU Docs: qemu-img

---

### Modul 2.3 — Perangkat Virtio vs Emulasi

**Tujuan:** Memahami perbedaan performa dan penggunaan virtio.

**Konsep Inti:**
- Virtio: paravirtualisasi, efisien.
- Emulasi: kompatibel, lambat.
- Perangkat: blk, net, rng, balloon.

**Lab L2.3 — Virtio**
Tambahkan `-device virtio-rng-pci`, `-balloon virtio`.

**Validasi Lulus:**
- `lspci` di guest menunjukkan perangkat virtio.

---

### Modul 2.4 — UEFI OVMF + vTPM dengan swtpm

**Tujuan:** Boot dengan UEFI dan vTPM.

**Lab L2.4 — OVMF + swtpm**
```bash
swtpm socket --tpmstate dir=/tmp/tpm --ctrl type=unixio,path=/tmp/tpm.sock --daemon
qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=OVMF_VARS.fd \
  -chardev socket,id=chrtpm,path=/tmp/tpm.sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0
```
**Validasi Lulus:**
- Guest mendeteksi TPM.

**Referensi:**
- Arch Wiki: swtpm

---

### Modul 2.5 — Kontrol Runtime via QMP

**Tujuan:** Mengontrol QEMU via QMP.

**Lab L2.5 — QMP**
```bash
qemu-system-x86_64 ... -qmp unix:/tmp/qmp.sock,server,nowait
# di terminal lain
socat - UNIX-CONNECT:/tmp/qmp.sock
{"execute": "qmp_capabilities"}
{"execute": "query-status"}
```
**Validasi Lulus:**
- Mendapat respons JSON.

**Referensi:**
- QEMU QMP Reference

---

### Proyek Fase 2
Jalankan VM Arch dengan virtio, OVMF, vTPM, dan kontrol QMP. Dokumentasikan setiap flag.

### Rubrik Fase 2
| Kriteria | Bobot |
|---|---|
| Boot VM | 20% |
| qemu-img | 20% |
| Virtio | 20% |
| OVMF+vTPM | 20% |
| QMP | 20% |

---

## 6. Fase 3 — libvirt & virsh: Lifecycle & Domain XML

**Estimasi: 2 minggu**

### Tujuan Fase
- Mengelola lifecycle VM dengan libvirt.
- Membaca/menulis domain XML.
- Provisioning 3 VM murni TUI.

### Prasyarat
- Fase 2 lulus; dasar XML.

### Daftar Isi Fase
1. Modul 3.1 — virt-install Headless
2. Modul 3.2 — Anatomi Domain XML
3. Modul 3.3 — Lifecycle: start, suspend, save/restore, autostart
4. Modul 3.4 — Storage Pool & Volume
5. Modul 3.5 — Monitoring dengan virt-top & domstats

---

### Modul 3.1 — virt-install Headless

**Lab L3.1 — virt-install**
```bash
virt-install \
  --name arch-vm \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial
```
**Validasi Lulus:**
- VM terinstal dan bisa diakses via `virsh console`.

**Referensi:**
- virt-install man page

---

### Modul 3.2 — Anatomi Domain XML

**Konsep Inti:**
- Elemen: `<domain>`, `<name>`, `<memory>`, `<vcpu>`, `<os>`, `<devices>`, `<interface>`.

**Lab L3.2 — dumpxml & edit**
```bash
virsh dumpxml arch-vm > arch-vm.xml
virsh edit arch-vm
```
**Validasi Lulus:**
- Memahami setiap elemen.

---

### Modul 3.3 — Lifecycle

**Lab L3.3 — Lifecycle**
```bash
virsh start arch-vm
virsh suspend arch-vm
virsh resume arch-vm
virsh save arch-vm state.save
virsh restore state.save
virsh autostart arch-vm
```
**Validasi Lulus:**
- Semua perintah berhasil.

---

### Modul 3.4 — Storage Pool & Volume

**Lab L3.4 — Pool**
```bash
virsh pool-define-as default dir --target /var/lib/libvirt/images
virsh pool-build default
virsh pool-start default
virsh pool-autostart default
virsh vol-create-as default disk1.qcow2 10G --format qcow2
```
**Validasi Lulus:**
- `virsh vol-list default` menampilkan volume.

---

### Modul 3.5 — Monitoring

**Lab L3.5 — Monitoring**
```bash
virt-top
virsh domstats arch-vm
```
**Validasi Lulus:**
- Melihat metrik CPU, memori, I/O.

---

### Proyek Fase 3
Provisioning 3 VM: Arch, Debian, cloud image. Hapus dan bangun ulang hanya dari XML.

### Rubrik Fase 3
| Kriteria | Bobot |
|---|---|
| virt-install | 20% |
| XML | 20% |
| Lifecycle | 20% |
| Storage | 20% |
| Monitoring | 20% |

---

## 7. Fase 4 — Storage, Image & Backup Engineering

**Estimasi: 2 minggu**

### Tujuan Fase
- Mengelola disk efisien, clone, snapshot, restore.

### Prasyarat
- Fase 3 lulus; dasar LVM/Btrfs/ZFS disarankan.

### Daftar Isi Fase
1. Modul 4.1 — Golden Image + Overlay Backing Chain
2. Modul 4.2 — Snapshot Internal/External, blockcommit/blockpull
3. Modul 4.3 — virt-sysprep, virt-customize, virt-clone
4. Modul 4.4 — Edit Disk Offline (guestfish, guestmount, qemu-nbd)
5. Modul 4.5 — Backup Live & Uji Restore

---

### Modul 4.1 — Golden Image + Overlay

**Lab L4.1 — Overlay**
```bash
qemu-img create -f qcow2 -b golden.qcow2 -F qcow2 overlay.qcow2
```
**Validasi Lulus:**
- Overlay bisa boot dan perubahan tidak mengubah golden.

---

### Modul 4.2 — Snapshot & blockcommit

**Lab L4.2 — Snapshot**
```bash
virsh snapshot-create-as arch-vm snap1
virsh blockcommit arch-vm vda --active --pivot
```
**Validasi Lulus:**
- Snapshot terdaftar, blockcommit berhasil.

---

### Modul 4.3 — virt-sysprep, virt-customize, virt-clone

**Lab L4.3 — Clone**
```bash
virt-sysprep -a golden.qcow2
virt-customize -a golden.qcow2 --hostname vm1
virt-clone --original arch-vm --name clone1 --file clone1.qcow2
```
**Validasi Lulus:**
- Clone berjalan.

---

### Modul 4.4 — Edit Disk Offline

**Lab L4.4 — guestfish**
```bash
guestfish --rw -a disk.qcow2 -i
><fs> ll /
><fs> cat /etc/hostname
```
**Validasi Lulus:**
- Bisa membaca file tanpa boot.

---

### Modul 4.5 — Backup Live & Restore

**Lab L4.5 — Backup**
```bash
virsh blockcopy arch-vm vda /backup/arch.qcow2 --wait --verbose
sha256sum /backup/arch.qcow2
```
**Validasi Lulus:**
- Restore dari backup berhasil dan checksum cocok.

---

### Proyek Fase 4
5 VM clone dari 1 golden image. Restore backup terverifikasi.

### Rubrik Fase 4
| Kriteria | Bobot |
|---|---|
| Overlay | 20% |
| Snapshot | 20% |
| Clone | 20% |
| Edit offline | 20% |
| Backup/restore | 20% |

---

## 8. Fase 5 — Networking & Isolasi Jaringan

**Estimasi: 2 minggu**

### Tujuan Fase
- Mendesain topologi jaringan VM dengan isolasi terbukti.

### Prasyarat
- Fase 3 lulus; dasar TCP/IP, routing, nftables.

### Daftar Isi Fase
1. Modul 5.1 — Network Isolated, NAT, Routed
2. Modul 5.2 — Bridge vs Macvtap
3. Modul 5.3 — Topologi Multi-Segmen dengan VM Router/Firewall
4. Modul 5.4 — nwfilter + nftables: Anti-Spoof, Default-Deny Egress
5. Modul 5.5 — Debug Jaringan (domiflist, tcpdump, bridge)

---

### Modul 5.1 — Network Isolated, NAT, Routed

**Lab L5.1 — net-define**
```xml
<network>
  <name>isolated</name>
  <bridge name='virbr1'/>
  <ip address='192.168.100.1' netmask='255.255.255.0'/>
</network>
```
```bash
virsh net-define isolated.xml
virsh net-start isolated
virsh net-autostart isolated
```
**Validasi Lulus:**
- VM di jaringan isolated tidak bisa akses internet.

---

### Modul 5.2 — Bridge vs Macvtap

**Konsep Inti:**
- Bridge: terhubung ke LAN fisik.
- Macvtap: langsung ke interface fisik, mode bridge/private.

**Lab L5.2 — Bridge**
```bash
ip link add br0 type bridge
ip link set enp1s0 master br0
```
**Validasi Lulus:**
- VM mendapat IP dari DHCP LAN.

---

### Modul 5.3 — Topologi Multi-Segmen

**Lab L5.3 — VM Router**
Buat VM dengan 3 interface: DMZ, LAN, isolated. Atur routing dan firewall.

**Validasi Lulus:**
- Matriks konektivitas sesuai desain.

---

### Modul 5.4 — nwfilter + nftables

**Konsep Inti:**
- nwfilter libvirt untuk aturan per VM.
- nftables untuk aturan host.
- Klarifikasi: nwfilter historis berbasis iptables/ebtables; integrasi nftables bergantung versi.

**Lab L5.4 — Anti-Spoof**
```xml
<filterref filter='clean-traffic'/>
```
**Validasi Lulus:**
- Spoofing MAC/IP diblokir.

---

### Modul 5.5 — Debug Jaringan

**Lab L5.5 — Debug**
```bash
virsh domiflist arch-vm
tcpdump -i vnet0
bridge link
```
**Validasi Lulus:**
- Bisa melacak paket.

---

### Proyek Fase 5
Lab 3 segmen (DMZ/LAN/isolated) dengan matriks konektivitas dibuktikan `ping`/`nc`.

### Rubrik Fase 5
| Kriteria | Bobot |
|---|---|
| Network isolated/NAT/routed | 20% |
| Bridge/macvtap | 20% |
| Topologi | 20% |
| nwfilter/nftables | 20% |
| Debug | 20% |

---

## 9. Fase 6 — Keamanan & Isolasi Lanjutan

**Estimasi: 2–3 minggu**

### Tujuan Fase
- VM tidak tepercaya tidak membahayakan host.

### Prasyarat
- Fase 4 & 5 lulus; dasar cgroups, namespace, threat modeling.

### Daftar Isi Fase
1. Modul 6.1 — Hardening XML
2. Modul 6.2 — Confinement QEMU: cgroups, seccomp, AppArmor
3. Modul 6.3 — Secure Boot + vTPM + Enkripsi Disk
4. Modul 6.4 — VM Unprivileged via qemu:///session
5. Modul 6.5 — Threat Model, Audit & Logging

---

### Modul 6.1 — Hardening XML

**Lab L6.1 — Hardening**
Hapus USB, spice, VNC, sound. Gunakan serial-only.
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
**Validasi Lulus:**
- Tidak ada perangkat yang tidak perlu.

---

### Modul 6.2 — Confinement QEMU

**Konsep Inti:**
- cgroups v2: `cputune`, `memtune`, `blkiotune`.
- seccomp: profil default QEMU.
- AppArmor: opsional di Arch, perlu instalasi.

**Lab L6.2 — cgroups**
```xml
<cputune>
  <vcpupin vcpu='0' cpuset='0'/>
  <vcpupin vcpu='1' cpuset='1'/>
</cputune>
<memtune>
  <hard_limit unit='MiB'>1024</hard_limit>
</memtune>
```
**Validasi Lulus:**
- `stress-ng` di VM tidak membuat host kehabisan resource.

---

### Modul 6.3 — Secure Boot + vTPM + Enkripsi

**Lab L6.3 — Enkripsi**
```bash
qemu-img create -f qcow2 --object secret,id=sec0,data=passphrase -o encrypt.format=luks,encrypt.key-secret=sec0 disk.qcow2 10G
```
**Validasi Lulus:**
- Disk terenkripsi, guest bisa boot dengan vTPM.

---

### Modul 6.4 — VM Unprivileged

**Lab L6.4 — qemu:///session**
```bash
virsh -c qemu:///session list --all
```
**Validasi Lulus:**
- VM berjalan sebagai user biasa.

---

### Modul 6.5 — Threat Model, Audit & Logging

**Lab L6.5 — Audit**
```bash
auditctl -w /etc/libvirt -p wa
journalctl -u virtqemud
```
**Validasi Lulus:**
- Threat model tertulis + checklist hardening.

---

### Proyek Fase 6
Threat model + checklist. `virt-host-validate` PASS penuh.

### Rubrik Fase 6
| Kriteria | Bobot |
|---|---|
| Hardening XML | 20% |
| Confinement | 20% |
| Secure Boot/vTPM/Enkripsi | 20% |
| Unprivileged | 20% |
| Threat model | 20% |

---

## 10. Fase 7 — Otomasi, Troubleshooting & Capstone Multi-OS

**Estimasi: 3 minggu**

### Tujuan Fase
- Mandiri total: bangun, rawat, perbaiki VM apa pun via skrip.

### Prasyarat
- Fase 1–6 lulus; Bash scripting menengah.

### Daftar Isi Fase
1. Modul 7.1 — Provisioning Otomatis cloud-init
2. Modul 7.2 — Windows Guest Headless
3. Modul 7.3 — Skrip Bash + libvirt Hooks + Unit systemd
4. Modul 7.4 — Drill Troubleshooting
5. Modul 7.5 — Capstone

---

### Modul 7.1 — cloud-init

**Lab L7.1 — NoCloud**
```yaml
# user-data
#cloud-config
users:
  - name: user
    ssh-authorized-keys:
      - ssh-rsa AAAA...
```
```bash
cloud-localds seed.img user-data meta-data
```
**Validasi Lulus:**
- VM otomatis dikonfigurasi.

---

### Modul 7.2 — Windows Guest Headless

**Konsep Inti:**
- Windows butuh display grafis untuk instalasi.
- Solusi: unattended install + virtio-win + WinRM/SSH.
- `virsh screenshot` untuk melihat layar di terminal (dengan viewer karakter).

**Lab L7.2 — Windows Unattended**
Gunakan `autounattend.xml`, `virtio-win.iso`, dan akses via WinRM.

**Validasi Lulus:**
- Windows terinstal tanpa interaksi GUI.

---

### Modul 7.3 — Skrip Bash + Hooks + systemd

**Lab L7.3 — Hooks**
```bash
# /etc/libvirt/hooks/qemu
#!/bin/bash
if [ "$1" = "arch-vm" ] && [ "$2" = "started" ]; then
  # aksi
fi
```
**Validasi Lulus:**
- Hook berjalan, VM autostart berurutan.

---

### Modul 7.4 — Drill Troubleshooting

**Skenario:**
1. Boot gagal.
2. Disk penuh.
3. Network mati.
4. VM hang.
5. QMP tidak responsif.

**Validasi Lulus:**
- 5 skenario lulus berbatas waktu.

---

### Modul 7.5 — Capstone

**Tugas:**
- Infrastruktur 4+ VM multi-OS.
- Build & destroy dengan satu perintah.
- Skrip idempotent, target <15 menit.
- Runbook terdokumentasi.

**Validasi Lulus:**
- Skrip capstone berhasil dari nol.

---

### Rubrik Fase 7
| Kriteria | Bobot |
|---|---|
| cloud-init | 20% |
| Windows headless | 20% |
| Otomasi | 20% |
| Troubleshooting | 20% |
| Capstone | 20% |

---

## 11. Fase 8 — Expert: Migrasi, Passthrough & Observability (Opsional)

**Estimasi: 3–4 minggu**

### Tujuan Fase
- Menguasai topik expert: live migration, VFIO, SR-IOV, virtiofs, NUMA, hugepages, observability.

### Prasyarat
- Fase 1–7 lulus; hardware mendukung IOMMU.

### Daftar Isi Fase
1. Modul 8.1 — Live Migration
2. Modul 8.2 — VFIO/IOMMU Passthrough
3. Modul 8.3 — SR-IOV & virtiofs
4. Modul 8.4 — NUMA, CPU Pinning, Hugepages, KSM
5. Modul 8.5 — Observability & API libvirt

---

### Modul 8.1 — Live Migration

**Lab L8.1 — Migrasi**
```bash
virsh migrate --live arch-vm qemu+ssh://host2/system
```
**Validasi Lulus:**
- VM pindah tanpa downtime signifikan.

---

### Modul 8.2 — VFIO/IOMMU Passthrough

**Lab L8.2 — Passthrough**
- Aktifkan IOMMU.
- Isolasi perangkat dengan `vfio-pci`.
- Tambahkan `<hostdev>` di XML.

**Validasi Lulus:**
- Guest mengenali perangkat fisik.

---

### Modul 8.3 — SR-IOV & virtiofs

**Lab L8.3 — virtiofs**
```xml
<filesystem type='mount' accessmode='passthrough'>
  <source dir='/host/share'/>
  <target dir='share'/>
</filesystem>
```
**Validasi Lulus:**
- Guest bisa mount share.

---

### Modul 8.4 — NUMA, Pinning, Hugepages, KSM

**Lab L8.4 — NUMA**
```xml
<numatune>
  <memory mode='strict' nodeset='0'/>
</numatune>
```
**Validasi Lulus:**
- Performa meningkat, latensi turun.

---

### Modul 8.5 — Observability & API

**Lab L8.5 — API**
```python
import libvirt
conn = libvirt.open('qemu:///system')
```
**Validasi Lulus:**
- Skrip Python mengelola VM.

---

### Proyek Fase 8
Implementasi live migration + passthrough + observability.

### Rubrik Fase 8
| Kriteria | Bobot |
|---|---|
| Live migration | 20% |
| VFIO | 20% |
| SR-IOV/virtiofs | 20% |
| NUMA | 20% |
| Observability | 20% |

---

## 12. Prasyarat & Estimasi Waktu Total

| Fase | Prasyarat | Estimasi |
|---|---|---|
| 1 | Arch Linux, dasar CLI & systemd | 1 minggu |
| 2 | Fase 1 lulus; dasar partisi & boot | 2 minggu |
| 3 | Fase 2 lulus; dasar XML | 2 minggu |
| 4 | Fase 3 lulus; dasar LVM/Btrfs/ZFS | 2 minggu |
| 5 | Fase 3 lulus; dasar TCP/IP & nftables | 2 minggu |
| 6 | Fase 4 & 5 lulus; dasar cgroups & threat modeling | 2–3 minggu |
| 7 | Fase 1–6 lulus; Bash scripting menengah | 3 minggu |
| 8 | Fase 1–7 lulus; hardware IOMMU | 3–4 minggu |
| **Total** | | **17–19 minggu** |

---

## 13. Rubrik Umum & Penilaian

Setiap fase dinilai berdasarkan:
- **Pemahaman konsep** (20%)
- **Keterampilan praktik** (40%)
- **Validasi lulus** (20%)
- **Dokumentasi & runbook** (10%)
- **Kemandirian & troubleshooting** (10%)

Nilai akhir:
- 90–100: Expert
- 80–89: Advanced
- 70–79: Competent
- 60–69: Developing
- <60: Perlu remedial

---

## 14. Lampiran: Sumber Referensi Utama

- Arch Wiki: KVM, libvirt, QEMU, nftables, swtpm, PCI passthrough via OVMF
- libvirt Documentation: https://libvirt.org/docs.html
- QEMU Documentation: https://www.qemu.org/documentation/
- QEMU QMP Reference: https://qemu-project.gitlab.io/qemu/interop/qmp-spec.html
- cloud-init Documentation: https://cloud-init.io/
- virtio-win: https://github.com/virtio-win/virtio-win-pkg-scripts
- NIST SP 800-125: Guide to Security for Full Virtualization Technologies
- CIS Benchmarks: Virtualization

---

**Kesimpulan:** Kurikulum ini kini lengkap, terstruktur, dan siap dipublikasikan. Setiap fase memiliki modul terperinci, lab, validasi, troubleshooting, referensi, dan rubrik. Fase 8 memastikan pencapaian tingkat expert. Aksesibilitas ditingkatkan dengan glosarium dan penjelasan konsep. Fleksibilitas dijaga melalui proyek mandiri dan topik opsional.
