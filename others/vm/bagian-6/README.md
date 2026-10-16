> *“Keamanan bukan lapisan tambahan. Ia adalah fondasi tempat semua lapisan lain berdiri.”*

---

# Fase 6 — Keamanan & Isolasi Lanjutan

**Estimasi:** 2–3 minggu  
**Prasyarat:** Fase 4 & 5 lulus; dasar cgroups, namespace, threat modeling.  
**Tujuan Fase:**
- Memastikan VM yang tidak tepercaya tidak membahayakan host.
- Menerapkan hardening XML, confinement QEMU, Secure Boot, vTPM, enkripsi disk.
- Menjalankan VM unprivileged via `qemu:///session`.
- Menyusun threat model, audit, dan logging.

**Daftar Isi Fase 6:**
1. Modul 6.1 — Hardening XML
2. Modul 6.2 — Confinement QEMU: cgroups, seccomp, AppArmor
3. Modul 6.3 — Secure Boot + vTPM + Enkripsi Disk
4. Modul 6.4 — VM Unprivileged via qemu:///session
5. Modul 6.5 — Threat Model, Audit & Logging

---

## Audit Fase 6

Kurikulum asli sudah menyebut modul-modul utama. Namun, ada beberapa hal yang perlu ditambahkan agar Fase 6 benar-benar komprehensif:

1. **Prinsip least privilege** pada domain XML: menghapus perangkat yang tidak perlu.
2. **Security driver libvirt**: DAC, SELinux, AppArmor.
3. **Capabilities QEMU**: `capabilities` drop, `user`, `group`.
4. **Namespace**: `mount`, `pid`, `net`, `ipc`, `uts`, `user`.
5. **cgroups v2**: `cputune`, `memtune`, `blkiotune`, `devices`.
6. **seccomp**: profil default QEMU, blacklist syscall.
7. **AppArmor**: profil libvirt, `virsh domxml-from-native`, `aa-status`.
8. **Secure Boot**: OVMF, `secboot`, `q35`, `smm`.
9. **vTPM**: swtpm, TPM 2.0, measured boot.
10. **Enkripsi disk**: LUKS, qcow2 encryption, key management.
11. **VM unprivileged**: `qemu:///session`, user namespace.
12. **Threat model**: STRIDE, attack surface, trust boundary.
13. **Audit**: `auditd`, `journalctl`, `libvirt` logging.
14. **Observability**: metrics, tracing, `perf`, `bpftrace`.

Untuk Modul 6.1, kita fokus pada **Hardening XML**.

---

# Modul 6.1 — Hardening XML

## Mini-Daftar Isi Modul 6.1

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Hardening XML
6. Audit Kurikulum: Tambahan untuk Modul 6.1
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 6.1

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Hardening XML** adalah proses **mengurangi permukaan serangan** VM dengan cara menghapus atau menonaktifkan perangkat, fitur, dan antarmuka yang tidak diperlukan pada **domain XML** libvirt. Ini adalah lapisan pertahanan pertama sebelum masuk ke confinement QEMU (6.2), Secure Boot (6.3), dan VM unprivileged (6.4).

Dalam modul ini, Anda akan:
- Memahami setiap elemen XML yang berpotensi menjadi vektor serangan.
- Menghapus perangkat virtual yang tidak perlu: USB, sound, video, graphics, tablet, smartcard, redirdev, filesystem, hostdev.
- Mengganti perangkat emulasi dengan **virtio** untuk performa dan keamanan.
- Menggunakan **serial console** sebagai satu-satunya akses.
- Menerapkan **security label** DAC/AppArmor.
- Menyusun **baseline XML** yang minimal dan aman.

**Peran dalam kurikulum:** Modul ini adalah **fondasi Fase 6**. Tanpa XML yang hardened, confinement QEMU, Secure Boot, dan enkripsi disk tidak akan maksimal. Hardening XML juga terhubung ke Fase 3 (Domain XML), Fase 5 (nwfilter), dan Fase 7 (otomasi provisioning).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Permukaan Serangan = Jumlah Pintu

Setiap perangkat virtual, setiap antarmuka, setiap fitur adalah **pintu** yang bisa dimasuki penyerang. Semakin banyak pintu, semakin besar risiko. Hardening XML adalah **menutup pintu yang tidak perlu**.

**Filosofi:** *Yang tidak ada, tidak bisa diserang.*

### 2.2. Least Privilege

VM hanya boleh memiliki perangkat dan fitur yang **benar-benar diperlukan**. Tidak ada USB jika tidak perlu. Tidak ada sound jika tidak perlu. Tidak ada graphics jika hanya butuh serial console.

**Filosofi:** *Beri VM hanya apa yang ia butuhkan, tidak lebih.*

### 2.3. Default-Deny

Dalam XML, **tidak menuliskan** elemen berarti elemen itu tidak ada. Ini adalah default-deny alami. Anda hanya menambahkan elemen yang diperlukan.

**Filosofi:** *Kosong adalah aman. Tambahkan hanya dengan alasan.*

### 2.4. Virtio: Paravirtualisasi yang Efisien dan Aman

Virtio adalah standar perangkat paravirtualisasi. Ia lebih efisien daripada emulasi penuh dan memiliki permukaan serangan lebih kecil karena tidak perlu mengemulasi perangkat keras kompleks.

**Filosofi:** *Virtio adalah jalan pintas yang aman. Emulasi adalah jalan panjang yang rapuh.*

### 2.5. Serial Console: Akses Minimalis

Alih-alih VNC/SPICE, gunakan **serial console** (`-nographic` atau `virsh console`). Ini mengurangi kebutuhan graphics stack dan memperkecil permukaan serangan.

**Filosofi:** *Teks sudah cukup. Grafik adalah kemewahan yang berisiko.*

### 2.6. Security Label: DAC dan AppArmor

Libvirt dapat menerapkan **security label** pada proses QEMU. DAC (`user`, `group`) membatasi akses file. AppArmor membatasi akses system call dan file.

**Filosofi:** *Bahkan jika VM lolos, label keamanan menahannya.*

### 2.7. Firmware: UEFI vs BIOS

UEFI (OVMF) dengan Secure Boot lebih aman daripada BIOS legacy. Namun, untuk hardening XML dasar, kita bisa mulai dengan BIOS atau UEFI minimal.

**Filosofi:** *Firmware adalah akar kepercayaan. Pilih yang bisa diverifikasi.*

### 2.8. Filosofi Keseluruhan

- **Minimalis**: hanya yang perlu.
- **Virtio**: efisien dan aman.
- **Serial**: akses teks.
- **Label**: batasi proses.
- **Audit**: catat perubahan.
- **Uji**: validasi setiap penghapusan.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Domain XML** | Konfigurasi VM libvirt. | `<domain>` |
| **Hardening** | Mengurangi permukaan serangan. | |
| **Attack surface** | Total titik yang bisa diserang. | |
| **Least privilege** | Hak minimum. | |
| **Virtio** | Paravirtualisasi. | `model='virtio'` |
| **Emulasi** | Simulasi perangkat keras. | `model='e1000'` |
| **Serial console** | Console teks via serial. | `<serial type='pty'>` |
| **PTY** | Pseudo-terminal. | |
| **Graphics** | Antarmuka grafis VM. | `<graphics type='none'/>` |
| **Video** | Perangkat video virtual. | `<video><model type='none'/></video>` |
| **USB** | Universal Serial Bus. | `<controller type='usb'>` |
| **Sound** | Perangkat audio. | `<sound>` |
| **Tablet** | Perangkat input tablet. | `<input type='tablet'/>` |
| **Smartcard** | Smartcard reader. | `<smartcard>` |
| **Redirdev** | USB redirection. | `<redirdev>` |
| **Filesystem** | Shared filesystem. | `<filesystem>` |
| **Hostdev** | Passthrough perangkat host. | `<hostdev>` |
| **Memballoon** | Balloon driver memori. | `<memballoon>` |
| **RNG** | Random number generator. | `<rng>` |
| **TPM** | Trusted Platform Module. | `<tpm>` |
| **Seclabel** | Label keamanan. | `<seclabel>` |
| **DAC** | Discretionary Access Control. | `user`, `group` |
| **AppArmor** | Modul keamanan Linux. | `model='apparmor'` |
| **SELinux** | Modul keamanan Linux. | `model='selinux'` |
| **QEMU** | Emulator/virtualizer. | |
| **KVM** | Akselerasi hardware. | |
| **q35** | Chipset modern. | `machine='q35'` |
| **OVMF** | UEFI firmware. | |
| **Secure Boot** | Boot terverifikasi. | |
| **vTPM** | TPM virtual. | |
| **LUKS** | Enkripsi disk Linux. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Baseline XML Minimal

Berikut contoh domain XML yang sudah di-hardening. Bandingkan dengan XML default yang biasanya penuh perangkat.

```xml
<domain type='kvm'>
  <name>hardened-vm</name>
  <memory unit='MiB'>1024</memory>
  <currentMemory unit='MiB'>1024</currentMemory>
  <vcpu placement='static'>2</vcpu>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
  </os>

  <features>
    <acpi/>
    <apic/>
    <vmport state='off'/>
  </features>

  <cpu mode='host-passthrough' check='none'/>

  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
      <source file='/var/lib/libvirt/images/hardened-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>

    <controller type='pci' index='0' model='pcie-root'/>

    <interface type='network'>
      <source network='lan'/>
      <model type='virtio'/>
      <filterref filter='clean-traffic'/>
    </interface>

    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>

    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
    </channel>

    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>

    <memballoon model='none'/>
    <graphics type='none'/>
    <video>
      <model type='none'/>
    </video>
    <controller type='usb' index='0' model='none'/>
  </devices>

  <seclabel type='dynamic' model='dac' relabel='yes'/>
</domain>
```

**Penjelasan kata demi kata:**

- `<domain type='kvm'>` — root elemen; menggunakan KVM.
- `<name>hardened-vm</name>` — nama VM.
- `<memory unit='MiB'>1024</memory>` — memori maksimum 1024 MiB.
- `<currentMemory unit='MiB'>1024</currentMemory>` — memori saat ini.
- `<vcpu placement='static'>2</vcpu>` — 2 vCPU, statis.
- `<os>` — konfigurasi OS.
  - `<type arch='x86_64' machine='q35'>hvm</type>` — arsitektur x86_64, chipset q35, tipe hvm.
  - `<boot dev='hd'/>` — boot dari hard disk.
- `<features>` — fitur CPU.
  - `<acpi/>` — ACPI aktif.
  - `<apic/>` — APIC aktif.
  - `<vmport state='off'/>` — VMware port dimatikan (mengurangi emulasi).
- `<cpu mode='host-passthrough' check='none'/>` — CPU host passthrough.
- `<clock offset='utc'>` — jam UTC.
  - `<timer name='rtc' tickpolicy='catchup'/>` — RTC.
  - `<timer name='pit' tickpolicy='delay'/>` — PIT.
  - `<timer name='hpet' present='no'/>` — HPET dimatikan.
- `<devices>` — semua perangkat.
  - `<emulator>/usr/bin/qemu-system-x86_64</emulator>` — path QEMU.
  - `<disk type='file' device='disk'>` — disk virtual.
    - `<driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>` — driver qcow2, cache none, io native, discard unmap.
    - `<source file='...'/>` — file image.
    - `<target dev='vda' bus='virtio'/>` — target vda, bus virtio.
  - `<controller type='pci' index='0' model='pcie-root'/>` — PCIe root.
  - `<interface type='network'>` — interface jaringan.
    - `<source network='lan'/>` — jaringan lan.
    - `<model type='virtio'/>` — model virtio.
    - `<filterref filter='clean-traffic'/>` — filter anti-spoof.
  - `<serial type='pty'>` — serial console via PTY.
    - `<target type='isa-serial' port='0'/>` — target ISA serial port 0.
  - `<console type='pty'>` — console via PTY.
    - `<target type='serial' port='0'/>` — target serial port 0.
  - `<channel type='unix'>` — channel ke guest agent.
    - `<target type='virtio' name='org.qemu.guest_agent.0'/>` — nama channel.
  - `<rng model='virtio'>` — random number generator.
    - `<backend model='random'>/dev/urandom</backend>` — backend /dev/urandom.
  - `<memballoon model='none'/>` — memballoon dimatikan.
  - `<graphics type='none'/>` — tidak ada graphics.
  - `<video><model type='none'/></video>` — tidak ada video.
  - `<controller type='usb' index='0' model='none'/>` — USB controller dimatikan.
- `<seclabel type='dynamic' model='dac' relabel='yes'/>` — label DAC dinamis, relabel.

### 4.2. Sebelum vs Sesudah Hardening

**Sebelum (default):**
```xml
<devices>
  <emulator>/usr/bin/qemu-system-x86_64</emulator>
  <disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/var/lib/libvirt/images/vm.qcow2'/>
    <target dev='vda' bus='virtio'/>
  </disk>
  <controller type='usb' index='0' model='qemu-xhci'/>
  <controller type='pci' index='0' model='pcie-root'/>
  <interface type='network'>
    <source network='default'/>
    <model type='virtio'/>
  </interface>
  <serial type='pty'>
    <target type='isa-serial' port='0'/>
  </serial>
  <console type='pty'>
    <target type='serial' port='0'/>
  </console>
  <graphics type='spice' port='5900' autoport='yes'/>
  <video>
    <model type='qxl'/>
  </video>
  <sound model='ich9'/>
  <input type='tablet' bus='usb'/>
  <memballoon model='virtio'/>
</devices>
```

**Sesudah (hardened):**
```xml
<devices>
  <emulator>/usr/bin/qemu-system-x86_64</emulator>
  <disk type='file' device='disk'>
    <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
    <source file='/var/lib/libvirt/images/vm.qcow2'/>
    <target dev='vda' bus='virtio'/>
  </disk>
  <controller type='pci' index='0' model='pcie-root'/>
  <interface type='network'>
    <source network='lan'/>
    <model type='virtio'/>
    <filterref filter='clean-traffic'/>
  </interface>
  <serial type='pty'>
    <target type='isa-serial' port='0'/>
  </serial>
  <console type='pty'>
    <target type='serial' port='0'/>
  </console>
  <channel type='unix'>
    <target type='virtio' name='org.qemu.guest_agent.0'/>
  </channel>
  <rng model='virtio'>
    <backend model='random'>/dev/urandom</backend>
  </rng>
  <memballoon model='none'/>
  <graphics type='none'/>
  <video>
    <model type='none'/>
  </video>
  <controller type='usb' index='0' model='none'/>
</devices>
```

**Yang dihapus:**
- USB controller (`qemu-xhci` → `none`).
- Graphics SPICE.
- Video QXL.
- Sound ich9.
- Input tablet.
- Memballoon virtio.

**Yang ditambahkan:**
- `cache='none' io='native' discard='unmap'` pada disk.
- `filterref clean-traffic`.
- `rng virtio`.
- `channel guest agent`.
- `seclabel`.

### 4.3. Menonaktifkan Graphics dan Video

```xml
<graphics type='none'/>
<video>
  <model type='none'/>
</video>
```

**Penjelasan:**
- `<graphics type='none'/>` — tidak ada server grafis.
- `<video><model type='none'/></video>` — tidak ada perangkat video.

**Alternatif:** Jika butuh grafis minimal, gunakan `type='vnc'` dengan `listen='127.0.0.1'` dan password. Namun, untuk hardening, `none` lebih baik.

### 4.4. Menonaktifkan USB

```xml
<controller type='usb' index='0' model='none'/>
```

**Penjelasan:**
- `type='usb'` — controller USB.
- `index='0'` — indeks.
- `model='none'` — tidak ada model.

**Alternatif:** Hapus elemen `<controller type='usb'>` sama sekali.

### 4.5. Menonaktifkan Sound

Hapus elemen `<sound>` sama sekali. Tidak ada elemen `<sound model='none'/>` yang valid; cukup tidak ditulis.

### 4.6. Menonaktifkan Tablet/Input

Hapus `<input type='tablet'/>`. Jika butuh keyboard, gunakan serial console.

### 4.7. Menonaktifkan Memballoon

```xml
<memballoon model='none'/>
```

**Penjelasan:**
- `model='none'` — tidak ada balloon driver.

**Alternatif:** Hapus elemen `<memballoon>` sama sekali. Namun, `model='none'` eksplisit.

### 4.8. Disk Hardening

```xml
<driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
```

**Penjelasan:**
- `name='qemu'` — driver QEMU.
- `type='qcow2'` — format qcow2.
- `cache='none'` — tidak ada cache host; langsung ke disk.
- `io='native'` — I/O native.
- `discard='unmap'` — discard/TRIM.

**Alternatif:** `cache='writethrough'` untuk keamanan data, tetapi lebih lambat.

### 4.9. Security Label

```xml
<seclabel type='dynamic' model='dac' relabel='yes'/>
```

**Penjelasan:**
- `type='dynamic'` — label dibuat dinamis.
- `model='dac'` — Discretionary Access Control.
- `relabel='yes'` — libvirt akan mengubah label file.

**AppArmor:**
```xml
<seclabel type='dynamic' model='apparmor' relabel='yes'/>
```

**SELinux:**
```xml
<seclabel type='dynamic' model='selinux' relabel='yes'/>
```

### 4.10. CPU Hardening

```xml
<cpu mode='host-passthrough' check='none'>
  <feature policy='disable' name='vmx'/>
  <feature policy='disable' name='svm'/>
</cpu>
```

**Penjelasan:**
- `mode='host-passthrough'` — CPU host.
- `check='none'` — tidak ada pengecekan.
- `<feature policy='disable' name='vmx'/>` — nonaktifkan VT-x di guest (mencegah nested virtualization).
- `<feature policy='disable' name='svm'/>` — nonaktifkan AMD-V.

### 4.11. Menghapus Hostdev, Filesystem, Redirdev

- `<hostdev>` — passthrough perangkat host. Hapus jika tidak perlu.
- `<filesystem>` — shared folder. Hapus jika tidak perlu.
- `<redirdev>` — USB redirection. Hapus.
- `<smartcard>` — smartcard. Hapus.

### 4.12. Validasi XML

```bash
virt-xml-validate hardened-vm.xml domain
```

**Penjelasan:**
- `virt-xml-validate` — validasi XML.
- `hardened-vm.xml` — file XML.
- `domain` — tipe dokumen.

### 4.13. Menerapkan XML

```bash
virsh define hardened-vm.xml
virsh start hardened-vm
virsh dumpxml hardened-vm > hardened-vm-applied.xml
diff hardened-vm.xml hardened-vm-applied.xml
```

**Penjelasan:**
- `define` — definisikan VM.
- `start` — jalankan.
- `dumpxml` — dump XML yang diterapkan.
- `diff` — bandingkan.

### 4.14. Melihat Perangkat di Guest

```bash
lspci
lsusb
```

**Penjelasan:**
- `lspci` — daftar PCI.
- `lsusb` — daftar USB.

Pastikan tidak ada perangkat yang tidak perlu.

---

## 5. Diagram Arsitektur Hardening XML

### 5.1. Permukaan Serangan Sebelum Hardening

```
+-------------------+
|   VM              |
+-------------------+
| USB               |
| Graphics (SPICE)  |
| Video (QXL)       |
| Sound             |
| Tablet            |
| Memballoon        |
| Emulasi NIC       |
| Emulasi Disk      |
+-------------------+
          |
          v
+-------------------+
|   Host            |
+-------------------+
```

### 5.2. Permukaan Serangan Sesudah Hardening

```
+-------------------+
|   VM              |
+-------------------+
| Virtio Disk       |
| Virtio NIC        |
| Serial Console    |
| Guest Agent       |
| RNG               |
+-------------------+
          |
          v
+-------------------+
|   Host            |
+-------------------+
```

### 5.3. Alur Hardening

```
Mulai
  |
  v
Identifikasi perangkat yang tidak perlu
  |
  v
Hapus/nonaktifkan di XML
  |
  v
Ganti emulasi dengan virtio
  |
  v
Tambahkan security label
  |
  v
Validasi XML
  |
  v
Terapkan dan uji
  |
  v
Selesai
```

### 5.4. Pohon Keputusan Perangkat

```
Apakah perangkat diperlukan?
├── Tidak → Hapus/nonaktifkan
└── Ya → Apakah bisa virtio?
    ├── Ya → Gunakan virtio
    └── Tidak → Apakah bisa serial?
        ├── Ya → Gunakan serial
        └── Tidak → Gunakan emulasi minimal
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 6.1

Kurikulum asli hanya menyebut:
> Hapus USB, spice, VNC, sound. Gunakan serial-only.

Kita akan menambahkan:

1. **Baseline XML minimal** lengkap.
2. **Perbandingan sebelum/sesudah**.
3. **Disk hardening**: `cache='none'`, `io='native'`, `discard='unmap'`.
4. **CPU hardening**: disable `vmx`/`svm`.
5. **RNG virtio**.
6. **Guest agent channel**.
7. **Memballoon `none`**.
8. **USB controller `none`**.
9. **Video `none`**.
10. **Graphics `none`**.
11. **Security label DAC/AppArmor/SELinux**.
12. **Validasi XML** dengan `virt-xml-validate`.
13. **Uji perangkat di guest** dengan `lspci`, `lsusb`.
14. **Dokumentasi baseline**.
15. **Otomasi hardening** dengan skrip.
16. **Audit berkala**.
17. **Referensi ke Fase 6.2** (confinement).

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 6.1.

---

## 7. Hubungan dengan Modul Lain

- **Fase 3 (Domain XML):** Hardening XML adalah penyempurnaan domain XML.
- **Fase 5 (nwfilter):** `filterref clean-traffic` adalah bagian dari hardening.
- **Modul 6.2 (Confinement QEMU):** XML yang hardened memudahkan confinement.
- **Modul 6.3 (Secure Boot + vTPM):** XML harus mendukung OVMF dan TPM.
- **Modul 6.4 (Unprivileged):** XML yang minimal lebih mudah dijalankan sebagai user.
- **Modul 6.5 (Threat Model):** Hardening XML adalah kontrol mitigasi.
- **Fase 7 (Otomasi):** Skrip provisioning harus menerapkan hardening.
- **Fase 8 (Expert):** Observability pada VM yang hardened.

---

## 8. Referensi Lengkap

- libvirt Domain XML — https://libvirt.org/formatdomain.html
- libvirt Security — https://libvirt.org/formatdomain.html#security-label
- libvirt virt-xml-validate — https://libvirt.org/manpages/virt-xml-validate.html
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- QEMU Documentation — https://www.qemu.org/documentation/
- KVM Documentation — https://www.linux-kvm.org/page/Documents
- NIST SP 800-125 — https://csrc.nist.gov/publications/detail/sp/800-125/final
- CIS Benchmarks: Virtualization — https://www.cisecurity.org/benchmark/virtualization
- AppArmor — https://gitlab.com/apparmor/apparmor/-/wikis/home
- SELinux — https://selinuxproject.org/
- OVMF — https://github.com/tianocore/edk2
- swtpm — https://github.com/stefanberger/swtpm

---

## 9. Tips & Praktik Terbaik

1. **Mulai dari XML minimal**, tambahkan hanya yang perlu.
2. **Gunakan virtio** untuk disk, network, RNG.
3. **Gunakan serial console**, hindari graphics.
4. **Nonaktifkan USB** jika tidak perlu.
5. **Nonaktifkan sound, video, tablet**.
6. **Gunakan `cache='none'`** untuk keamanan data.
7. **Gunakan `discard='unmap'`** untuk TRIM.
8. **Tambahkan `filterref clean-traffic`**.
9. **Gunakan security label** DAC/AppArmor.
10. **Validasi XML** sebelum apply.
11. **Uji perangkat di guest**.
12. **Dokumentasikan baseline**.
13. **Audit berkala**.
14. **Otomasi dengan skrip**.
15. **Jangan gunakan `host-passthrough` tanpa disable vmx/svm**.
16. **Gunakan `q35`** untuk chipset modern.
17. **Pertimbangkan OVMF** untuk Secure Boot.
18. **Backup XML** sebelum perubahan.
19. **Gunakan `virsh edit`** dengan hati-hati.
20. **Latih troubleshooting**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| VM tidak boot | Disk driver salah. | Gunakan virtio, pastikan driver di guest. |
| Console tidak muncul | Serial tidak dikonfigurasi. | Tambahkan `<serial>` dan `<console>`. |
| Tidak bisa akses VM | Graphics dimatikan. | Gunakan `virsh console`. |
| USB tidak berfungsi | USB controller `none`. | Aktifkan jika perlu. |
| Sound tidak ada | Sound dihapus. | Tambahkan jika perlu. |
| XML tidak valid | Elemen salah. | `virt-xml-validate`. |
| Security label gagal | DAC/AppArmor tidak aktif. | Cek `aa-status`, cek permission. |
| VM lambat | Cache none. | Gunakan `writethrough` atau `writeback` jika perlu. |
| Disk tidak TRIM | `discard` tidak diset. | Tambahkan `discard='unmap'`. |
| Guest agent tidak jalan | Channel tidak ada. | Tambahkan channel. |
| RNG tidak ada | RNG dihapus. | Tambahkan RNG virtio. |
| CPU feature tidak didukung | Host tidak support. | Hapus feature. |
| Memballoon tidak jalan | `model='none'`. | Aktifkan jika perlu. |
| Network mati | Interface dihapus. | Tambahkan interface. |
| Filterref gagal | nwfilter tidak ada. | Definisikan filter. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virt-xml-validate hardened-vm.xml domain` berhasil.
- `virsh define hardened-vm.xml` berhasil.
- `virsh start hardened-vm` berhasil.
- `virsh console hardened-vm` bisa diakses.
- `virsh dumpxml hardened-vm` menunjukkan perangkat minimal.
- Di guest, `lspci` hanya menunjukkan perangkat yang perlu.
- Di guest, `lsusb` kosong atau minimal.
- Tidak ada graphics, sound, video.
- `virsh domiflist hardened-vm` menunjukkan interface.
- `virsh domblklist hardened-vm` menunjukkan disk.
- `virsh domstats hardened-vm` berjalan.
- Security label terlihat di `virsh dumpxml`.

**Troubleshooting:**
- Jika VM tidak boot: cek driver virtio di guest, cek boot order.
- Jika console tidak muncul: cek `console=ttyS0` di kernel cmdline guest.
- Jika XML tidak valid: baca error `virt-xml-validate`.
- Jika security label gagal: cek `aa-status`, cek `ls -lZ` pada image.
- Jika VM lambat: ubah cache.
- Jika network mati: cek `virsh domiflist`, cek bridge.
- Jika disk tidak terdeteksi: cek `bus='virtio'`, cek driver.
- Untuk log: `journalctl -u virtqemud`, `/var/log/libvirt/qemu/`.
- Untuk audit: `virsh dumpxml`, `diff`.

---

## 12. Latihan Mandiri

1. Dump XML VM yang ada.
2. Identifikasi perangkat yang tidak perlu.
3. Buat baseline XML minimal.
4. Hapus USB, graphics, video, sound, tablet.
5. Nonaktifkan memballoon.
6. Tambahkan RNG virtio.
7. Tambahkan guest agent channel.
8. Tambahkan filterref clean-traffic.
9. Tambahkan security label DAC.
10. Validasi XML.
11. Terapkan dan jalankan VM.
12. Uji console.
13. Uji perangkat di guest.
14. Bandingkan sebelum/sesudah.
15. Buat skrip hardening.
16. Dokumentasikan baseline.
17. Audit VM lain.
18. Buat checklist hardening.
19. Uji dengan `virt-host-validate`.
20. Tulis ringkasan: mengapa setiap perangkat dihapus.

---

## 13. Penutup Modul 6.1

Anda kini menguasai **Hardening XML** — fondasi keamanan VM di libvirt. Anda bisa membuat XML minimal, menghapus perangkat yang tidak perlu, mengganti emulasi dengan virtio, menggunakan serial console, menerapkan security label, dan memvalidasi konfigurasi. Ini adalah langkah pertama menuju **isolasi lanjutan** di Fase 6.

Modul berikutnya adalah **Modul 6.2 — Confinement QEMU: cgroups, seccomp, AppArmor**, di mana kita akan membatasi proses QEMU itu sendiri agar tidak bisa keluar dari kandangnya.

---

*Motivasi: Hardening adalah seni mengurangi. Setiap perangkat yang Anda hapus adalah pintu yang Anda tutup. Setiap fitur yang Anda nonaktifkan adalah risiko yang Anda hilangkan. Keamanan dimulai dari kesederhanaan.*

---


# Modul 6.2 — Confinement QEMU: cgroups, seccomp, AppArmor

## Mini-Daftar Isi Modul 6.2

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Confinement QEMU
6. Audit Kurikulum: Tambahan untuk Modul 6.2
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 6.2

---

> *“Kandang yang kuat tidak membuat singa lemah. Ia hanya memastikan singa tidak memangsa tuannya.”*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Confinement QEMU** adalah proses **membatasi kemampuan proses QEMU** (yang menjalankan VM) agar tidak bisa keluar dari batas yang ditentukan dan membahayakan host. Proses QEMU adalah proses userspace biasa di Linux, tetapi ia memiliki akses ke:
- **CPU & memori** (melalui KVM).
- **File image disk** (via syscall `read`/`write`).
- **Interface jaringan** (via TAP/bridge).
- **Perangkat host** (jika passthrough).
- **System call** ke kernel.

Jika VM dikompromikan melalui **guest escape** (eksploitasi QEMU, virtio, atau driver), penyerang akan mencoba:
- Membaca/menulis file di host.
- Mengakses perangkat yang tidak seharusnya.
- Menjalankan perintah di host.
- Menyebar ke VM lain.

**Confinement** adalah lapisan pertahanan yang membatasi apa yang bisa dilakukan proses QEMU **bahkan jika VM sudah dikompromikan**. Ia terdiri dari tiga pilar utama:

1. **cgroups v2** — membatasi **resource** (CPU, memori, I/O, perangkat).
2. **seccomp** — membatasi **system call** yang bisa dipanggil proses QEMU.
3. **AppArmor** (atau SELinux) — membatasi **akses file, network, dan capability**.

**Peran dalam kurikulum:** Modul ini adalah **lapisan kedua Fase 6** setelah Hardening XML (6.1). Jika Hardening XML mengurangi **permukaan serangan VM**, maka Confinement QEMU melindungi **host dari VM yang sudah dikompromikan**. Ini adalah inti dari **defense in depth**. Modul ini juga fondasi untuk:
- **Modul 6.3 (Secure Boot + vTPM + Enkripsi)**: confinement melindungi kunci enkripsi.
- **Modul 6.4 (VM Unprivileged)**: user namespace adalah bentuk confinement.
- **Modul 6.5 (Threat Model)**: confinement adalah kontrol mitigasi.
- **Fase 8 (Observability)**: memonitor resource yang dibatasi cgroups.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Confinement = Kandang Berlapis

Bayangkan QEMU sebagai **binatang buas** yang Anda pelihara. Ia berguna, tetapi bisa berbahaya. Confinement adalah **kandang berlapis**:
- **Lapisan 1 (cgroups)**: membatasi seberapa banyak ia makan (CPU, memori, I/O).
- **Lapisan 2 (seccomp)**: membatasi gerakan yang bisa ia lakukan (system call).
- **Lapisan 3 (AppArmor)**: membatasi ruang yang bisa ia jelajahi (file, network).

**Filosofi:** *Jangan percaya QEMU. Batasi dia sejak awal. Jika dia lolos, dia tetap terkurung.*

### 2.2. cgroups v2: Manajemen Resource

**cgroups** (control groups) adalah fitur kernel Linux yang mengelompokkan proses dan membatasi resource mereka. cgroups v2 adalah versi terbaru dengan **hierarki tunggal** dan **interface unified** di `/sys/fs/cgroup/`.

Setiap VM yang dijalankan libvirt memiliki **cgroup sendiri** di bawah `machine.slice`:
```
/sys/fs/cgroup/machine.slice/machine-qemu\x2d1\x2darch\\x2dvm.scope/
```

Di dalamnya ada file seperti:
- `cpu.max` — batas CPU.
- `memory.max` — batas memori.
- `io.max` — batas I/O.
- `cpuset.cpus` — CPU yang diizinkan.
- `pids.max` — jumlah proses.

**Filosofi:** *Resource adalah nyawa. Batasi nyawa VM agar host tetap hidup.*

### 2.3. seccomp: Filter System Call

**seccomp** (Secure Computing Mode) adalah fitur kernel yang memungkinkan proses **membatasi system call** yang bisa dipanggil. Setiap syscall yang tidak diizinkan akan **mengembalikan error** atau **membunuh proses**.

QEMU memiliki **profil seccomp default** yang diaktifkan libvirt. Profil ini memblokir syscall berbahaya seperti:
- `mount`, `umount` — mount filesystem.
- `reboot` — reboot host.
- `kexec_load` — load kernel baru.
- `ptrace` — debug proses lain.
- `bpf` — load BPF program.
- `userfaultfd` — manipulasi memori.
- `keyctl` — manajemen kunci kernel.
- `add_key`, `request_key` — kunci kernel.
- `perf_event_open` — akses perf.

**Filosofi:** *System call adalah pintu ke kernel. Tutup pintu yang tidak perlu.*

### 2.4. AppArmor: Profil Per-Proses

**AppArmor** adalah **Linux Security Module (LSM)** yang membatasi program berdasarkan **profil**. Profil mendefinisikan:
- File yang boleh dibaca/ditulis.
- Network yang boleh diakses.
- Capability yang boleh digunakan.
- Mount point yang boleh diakses.

Libvirt menyediakan **profil AppArmor default** untuk QEMU (`/etc/apparmor.d/abstractions/libvirt-qemu` dan `/etc/apparmor.d/usr.sbin.libvirtd`). Setiap VM mendapatkan profil dinamis yang di-generate oleh `virt-aa-helper`.

**Filosofi:** *Setiap proses punya ruang sendiri. Jangan biarkan ia keluar.*

### 2.5. SELinux: Alternatif AppArmor

**SELinux** adalah LSM lain yang lebih kompleks, berbasis **label** dan **policy**. Di Arch Linux, SELinux tidak default, tetapi bisa diinstal. Untuk konteks Arch, kita fokus pada AppArmor.

**Filosofi:** *SELinux adalah benteng. AppArmor adalah pagar. Keduanya melindungi.*

### 2.6. DAC: Discretionary Access Control

Sebelum AppArmor, ada **DAC** — kontrol akses berbasis user/group/permission. Libvirt menjalankan QEMU sebagai user `libvirt-qemu` (atau `qemu`) dan group `kvm`. File image harus dimiliki user tersebut atau bisa diakses.

**Filosofi:** *DAC adalah lapisan pertama. AppArmor adalah lapisan kedua.*

### 2.7. Namespace: Isolasi Global

**Namespace** adalah fitur kernel yang mengisolasi **view** proses terhadap sistem. Jenis namespace:
- `mnt` — mount point.
- `pid` — process ID.
- `net` — network.
- `ipc` — inter-process communication.
- `uts` — hostname/domain.
- `user` — user/group ID.
- `cgroup` — cgroup view.

QEMU menggunakan beberapa namespace untuk isolasi. `qemu:///session` menggunakan user namespace untuk menjalankan VM tanpa root.

**Filosofi:** *Namespace adalah dunia paralel. Setiap VM hidup di dunianya sendiri.*

### 2.8. Capabilities: Hak Root yang Dipotong

**Capabilities** adalah pembagian hak root menjadi unit-unit kecil (mis. `CAP_NET_ADMIN`, `CAP_SYS_ADMIN`). QEMU seharusnya **tidak memiliki capability** yang tidak perlu. Libvirt menjalankan QEMU dengan **capability drop** — hanya menyisakan yang diperlukan.

**Filosofi:** *Root adalah kumpulan hak. Potong menjadi bagian kecil.*

### 2.9. Defense in Depth

Confinement adalah **lapisan** dalam strategi defense in depth:
1. **Hardening XML** — kurangi permukaan serangan VM.
2. **cgroups** — batasi resource.
3. **seccomp** — batasi syscall.
4. **AppArmor** — batasi file/network.
5. **DAC** — batasi permission.
6. **Namespace** — isolasi view.
7. **Capabilities** — potong hak root.

Jika satu lapisan gagal, lapisan lain tetap melindungi.

**Filosofi:** *Tidak ada satu pertahanan yang cukup. Gunakan banyak.*

### 2.10. Filosofi Keseluruhan

- **Jangan percaya QEMU.**
- **Batasi resource dengan cgroups.**
- **Batasi syscall dengan seccomp.**
- **Batasi file dengan AppArmor.**
- **Batasi permission dengan DAC.**
- **Isolasi dengan namespace.**
- **Potong capability.**
- **Audit dan monitor.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Confinement** | Pembatasan proses. | |
| **cgroups v2** | Control groups versi 2. | `/sys/fs/cgroup/` |
| **cgroup controller** | Pengendali resource. | `cpu`, `memory`, `io` |
| **cpu.max** | Batas CPU. | `50000 100000` |
| **memory.max** | Batas memori. | `1073741824` |
| **io.max** | Batas I/O. | `8:0 rbps=1048576` |
| **pids.max** | Batas proses. | `100` |
| **cpuset.cpus** | CPU yang diizinkan. | `0-3` |
| **seccomp** | Secure Computing Mode. | |
| **syscall** | System call. | `read`, `write` |
| **seccomp profile** | Daftar syscall yang diizinkan. | |
| **AppArmor** | LSM berbasis profil. | |
| **profil AppArmor** | Aturan untuk program. | `/etc/apparmor.d/` |
| **aa-status** | Status AppArmor. | |
| **virt-aa-helper** | Generator profil libvirt. | |
| **SELinux** | LSM berbasis label. | |
| **DAC** | Discretionary Access Control. | |
| **MAC** | Mandatory Access Control. | |
| **namespace** | Isolasi view. | `mnt`, `pid`, `net` |
| **user namespace** | Isolasi user/group. | |
| **capability** | Hak root terpotong. | `CAP_NET_ADMIN` |
| **capsh** | Capability shell. | |
| **getpcaps** | Lihat capability proses. | |
| **libvirt-qemu** | User QEMU. | |
| **kvm** | Group KVM. | |
| **machine.slice** | Slice systemd untuk VM. | |
| **systemd-run** | Jalankan proses di cgroup. | |
| **systemd-cgls** | Lihat hierarki cgroup. | |
| **systemd-cgtop** | Monitor cgroup. | |
| **virsh domstats** | Statistik VM. | |
| **virsh schedinfo** | Info scheduler. | |
| **virsh blkdeviotune** | Tuning I/O. | |
| **virsh memtune** | Tuning memori. | |
| **virsh vcpupin** | Pin vCPU. | |
| **virsh emulatorpin** | Pin emulator. | |
| **virsh iothreadpin** | Pin iothread. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Melihat cgroup VM

```bash
systemd-cgls /machine.slice
```

**Output (contoh):**
```
├─machine.slice
│ ├─machine-qemu\x2d1\x2darch\x2dvm.scope
│ │ ├─12345 /usr/bin/qemu-system-x86_64 ...
```

**Penjelasan kata demi kata:**
- `systemd-cgls` — list cgroup.
- `/machine.slice` — slice untuk VM.
- `machine-qemu\x2d1\x2darch\x2dvm.scope` — scope VM (nama di-escape).
- `12345` — PID QEMU.
- `/usr/bin/qemu-system-x86_64 ...` — perintah QEMU.

### 4.2. Melihat Isi cgroup VM

```bash
CGROUP=/sys/fs/cgroup/machine.slice/machine-qemu\\x2d1\\x2darch\\x2dvm.scope
ls $CGROUP
cat $CGROUP/cpu.max
cat $CGROUP/memory.max
cat $CGROUP/pids.max
cat $CGROUP/cpuset.cpus
```

**Penjelasan:**
- `cpu.max` — format `quota period` (mis. `50000 100000` = 50% CPU).
- `memory.max` — batas memori dalam byte.
- `pids.max` — jumlah proses maksimum.
- `cpuset.cpus` — CPU yang diizinkan.

### 4.3. Membatasi CPU VM dengan XML

```xml
<vcpu placement='static'>2</vcpu>
<cputune>
  <vcpupin vcpu='0' cpuset='0'/>
  <vcpupin vcpu='1' cpuset='1'/>
  <emulatorpin cpuset='2-3'/>
  <shares>1024</shares>
  <period>100000</period>
  <quota>50000</quota>
</cputune>
```

**Penjelasan kata demi kata:**
- `<vcpu placement='static'>2</vcpu>` — 2 vCPU, statis.
- `<cputune>` — tuning CPU.
- `<vcpupin vcpu='0' cpuset='0'/>` — vCPU 0 di pin ke CPU 0 host.
- `<vcpupin vcpu='1' cpuset='1'/>` — vCPU 1 di pin ke CPU 1 host.
- `<emulatorpin cpuset='2-3'/>` — emulator (QEMU) di pin ke CPU 2-3.
- `<shares>1024</shares>` — bobot CPU relatif.
- `<period>100000</period>` — periode 100ms.
- `<quota>50000</quota>` — kuota 50ms (50% CPU).

### 4.4. Membatasi Memori VM

```xml
<memory unit='MiB'>2048</memory>
<currentMemory unit='MiB'>1024</currentMemory>
<memtune>
  <hard_limit unit='MiB'>2048</hard_limit>
  <soft_limit unit='MiB'>1536</soft_limit>
  <swap_hard_limit unit='MiB'>2048</swap_hard_limit>
  <min_guarantee unit='MiB'>512</min_guarantee>
</memtune>
```

**Penjelasan:**
- `<memory>` — memori maksimum.
- `<currentMemory>` — memori saat ini.
- `<memtune>` — tuning memori.
- `<hard_limit>` — batas keras.
- `<soft_limit>` — batas lunak.
- `<swap_hard_limit>` — batas swap.
- `<min_guarantee>` — jaminan minimum.

### 4.5. Membatasi I/O VM

```xml
<blkiotune>
  <weight>500</weight>
  <device>
    <path>/var/lib/libvirt/images/arch-vm.qcow2</path>
    <weight>300</weight>
  </device>
</blkiotune>
```

**Penjelasan:**
- `<blkiotune>` — tuning I/O.
- `<weight>` — bobot global.
- `<device>` — perangkat spesifik.
- `<path>` — path image.
- `<weight>` — bobot perangkat.

**I/O tuning lanjutan:**
```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2'/>
  <source file='/var/lib/libvirt/images/arch-vm.qcow2'/>
  <target dev='vda' bus='virtio'/>
  <iotune>
    <total_bytes_sec>10485760</total_bytes_sec>
    <read_bytes_sec>5242880</read_bytes_sec>
    <write_bytes_sec>5242880</write_bytes_sec>
    <total_iops_sec>1000</total_iops_sec>
  </iotune>
</disk>
```

**Penjelasan:**
- `<iotune>` — tuning I/O per disk.
- `<total_bytes_sec>` — total byte/detik.
- `<read_bytes_sec>` — baca byte/detik.
- `<write_bytes_sec>` — tulis byte/detik.
- `<total_iops_sec>` — total IOPS.

### 4.6. Melihat Konfigurasi Scheduler

```bash
virsh schedinfo arch-vm
```

**Output:**
```
Scheduler      : posix
cpu_shares     : 1024
vcpu_period    : 100000
vcpu_quota     : 50000
emulator_period: 100000
emulator_quota : 50000
global_period  : 100000
global_quota   : -1
iothread_period: 100000
iothread_quota : -1
```

**Penjelasan:**
- `cpu_shares` — bobot CPU.
- `vcpu_period` — periode vCPU.
- `vcpu_quota` — kuota vCPU.
- `emulator_*` — emulator.
- `global_*` — global.
- `iothread_*` — iothread.

**Mengubah:**
```bash
virsh schedinfo arch-vm --set vcpu_quota=25000
```

### 4.7. seccomp: Melihat Status

```bash
# Di host
grep Seccomp /proc/$(pgrep -f qemu-system-x86_64 | head -1)/status
```

**Output:**
```
Seccomp:        2
Seccomp_filters:        1
```

**Penjelasan:**
- `Seccomp: 2` — mode filter (bukan strict).
- `Seccomp_filters: 1` — jumlah filter.

### 4.8. seccomp: Konfigurasi di libvirt

Di `/etc/libvirt/qemu.conf`:
```conf
seccomp_sandbox = 1
```

**Penjelasan:**
- `seccomp_sandbox = 1` — aktifkan seccomp.
- Nilai: `0` (nonaktif), `1` (aktif), `2` (aktif dengan log).

**Alternatif:** Di XML:
```xml
<features>
  <acpi/>
  <apic/>
  <vmport state='off'/>
</features>
<seclabel type='dynamic' model='dac' relabel='yes'/>
```

### 4.9. seccomp: Profil Kustom (Lanjutan)

QEMU menerima argumen `-sandbox`:
```bash
qemu-system-x86_64 -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
```

**Penjelasan:**
- `on` — aktifkan seccomp.
- `obsolete=deny` — tolak syscall obsolete.
- `elevateprivileges=deny` — tolak elevasi.
- `spawn=deny` — tolak spawn proses.
- `resourcecontrol=deny` — tolak kontrol resource.

Di libvirt, ini diatur via `qemu.conf` atau argumen tambahan.

### 4.10. AppArmor: Cek Status

```bash
sudo aa-status
```

**Output:**
```
apparmor module is loaded.
42 profiles are loaded.
...
   /usr/bin/qemu-system-x86_64
   /usr/sbin/libvirtd
...
```

**Penjelasan:**
- `aa-status` — status AppArmor.
- Profil QEMU dan libvirtd harus ada.

### 4.11. AppArmor: Profil QEMU

```bash
ls /etc/apparmor.d/
cat /etc/apparmor.d/usr.sbin.libvirtd
cat /etc/apparmor.d/abstractions/libvirt-qemu
```

**Penjelasan:**
- Profil utama di `/etc/apparmor.d/`.
- Abstractions untuk QEMU.

### 4.12. AppArmor: Profil Dinamis VM

```bash
ls /etc/apparmor.d/libvirt/
cat /etc/apparmor.d/libvirt/libvirt-*.files
```

**Penjelasan:**
- Libvirt membuat profil dinamis per VM.
- File `.files` berisi path yang diizinkan.

### 4.13. AppArmor: Mode Profil

```bash
sudo aa-complain /usr/bin/qemu-system-x86_64
sudo aa-enforce /usr/bin/qemu-system-x86_64
```

**Penjelasan:**
- `aa-complain` — mode komplain (log saja).
- `aa-enforce` — mode enforce (blokir).

### 4.14. AppArmor: Melihat Log

```bash
sudo journalctl -k | grep apparmor
sudo dmesg | grep apparmor
```

**Penjelasan:**
- Log AppArmor di kernel log.

### 4.15. DAC: User dan Group QEMU

```bash
ps -eo user,group,pid,cmd | grep qemu
```

**Output:**
```
libvirt-qemu kvm 12345 /usr/bin/qemu-system-x86_64 ...
```

**Penjelasan:**
- User `libvirt-qemu`.
- Group `kvm`.

**Konfigurasi di `/etc/libvirt/qemu.conf`:**
```conf
user = "libvirt-qemu"
group = "kvm"
dynamic_ownership = 1
```

**Penjelasan:**
- `user` — user QEMU.
- `group` — group QEMU.
- `dynamic_ownership` — libvirt mengubah ownership file.

### 4.16. DAC: Permission File Image

```bash
ls -l /var/lib/libvirt/images/arch-vm.qcow2
```

**Output:**
```
-rw------- 1 libvirt-qemu kvm 10737418240 ... arch-vm.qcow2
```

**Penjelasan:**
- Owner `libvirt-qemu`.
- Group `kvm`.
- Permission `600` (hanya owner).

### 4.17. Namespace: Melihat Namespace QEMU

```bash
PID=$(pgrep -f qemu-system-x86_64 | head -1)
sudo ls -l /proc/$PID/ns/
```

**Output:**
```
lrwxrwxrwx ... cgroup -> 'cgroup:[4026531835]'
lrwxrwxrwx ... ipc -> 'ipc:[4026531839]'
lrwxrwxrwx ... mnt -> 'mnt:[4026531840]'
lrwxrwxrwx ... net -> 'net:[4026531992]'
lrwxrwxrwx ... pid -> 'pid:[4026531836]'
lrwxrwxrwx ... user -> 'user:[4026531837]'
lrwxrwxrwx ... uts -> 'uts:[4026531838]'
```

**Penjelasan:**
- Setiap namespace memiliki inode.
- Jika inode berbeda dari host, berarti terisolasi.

### 4.18. Capabilities: Melihat Capability QEMU

```bash
PID=$(pgrep -f qemu-system-x86_64 | head -1)
sudo getpcaps $PID
```

**Output:**
```
Capabilities for `12345': = cap_chown,cap_dac_override,... +ep
```

**Penjelasan:**
- `getpcaps` — lihat capability.
- Capability yang tersisa seharusnya minimal.

### 4.19. Capabilities: Konfigurasi di XML

```xml
<features>
  <acpi/>
  <apic/>
</features>
<seclabel type='dynamic' model='dac' relabel='yes'/>
```

**Penjelasan:**
- Libvirt secara otomatis drop capability.
- Tidak ada elemen XML langsung untuk capability; diatur oleh libvirt.

### 4.20. Memonitor Resource dengan systemd-cgtop

```bash
systemd-cgtop /machine.slice
```

**Output:**
```
Control Group                    Tasks   %CPU   Memory  Input/s Output/s
machine.slice                    5       12.3   1.5G    0B/s    0B/s
machine-qemu\x2d1\x2darch...     1       10.1   1.0G    0B/s    0B/s
```

**Penjelasan:**
- `Tasks` — jumlah proses.
- `%CPU` — penggunaan CPU.
- `Memory` — memori.
- `Input/s`, `Output/s` — I/O.

### 4.21. Memonitor dengan virsh domstats

```bash
virsh domstats arch-vm --cpu-total --memory --block --interface
```

**Output (ringkas):**
```
Domain: 'arch-vm'
  cpu.time=1234567890
  cpu.user=1234567890
  cpu.system=1234567890
  balloon.current=1048576
  balloon.maximum=1048576
  block.0.name=vda
  block.0.rd.reqs=100
  block.0.wr.reqs=200
  net.0.name=vnet0
  net.0.rx.bytes=12345
  net.0.tx.bytes=67890
```

**Penjelasan:**
- `cpu.time` — waktu CPU.
- `balloon.*` — memori.
- `block.*` — I/O disk.
- `net.*` — network.

### 4.22. Stress Test: CPU

```bash
# Di guest
stress-ng --cpu 4 --timeout 60s
# Di host
systemd-cgtop /machine.slice
```

**Penjelasan:**
- Jika cgroups bekerja, CPU VM tidak akan melebihi kuota.

### 4.23. Stress Test: Memori

```bash
# Di guest
stress-ng --vm 2 --vm-bytes 2G --timeout 60s
# Di host
cat /sys/fs/cgroup/machine.slice/machine-qemu*/memory.current
```

**Penjelasan:**
- Jika cgroups bekerja, memori VM tidak akan melebihi batas.

### 4.24. Stress Test: I/O

```bash
# Di guest
fio --name=test --rw=write --size=1G --filename=/tmp/test
# Di host
iostat -x 1
```

**Penjelasan:**
- Jika cgroups bekerja, I/O VM akan dibatasi.

### 4.25. Skrip Audit Confinement

```bash
#!/bin/bash
set -e

VM="${1:-arch-vm}"

echo "=== VM: $VM ==="

PID=$(pgrep -f "qemu-system-x86_64.*$VM" | head -1)
if [ -z "$PID" ]; then
  echo "VM tidak berjalan"
  exit 1
fi

echo "PID: $PID"

echo -e "\n=== cgroups ==="
CGROUP=$(cat /proc/$PID/cgroup | grep -o 'machine.slice.*')
echo "Cgroup: $CGROUP"
CGPATH="/sys/fs/cgroup/$CGROUP"
echo "cpu.max: $(cat $CGPATH/cpu.max 2>/dev/null || echo N/A)"
echo "memory.max: $(cat $CGPATH/memory.max 2>/dev/null || echo N/A)"
echo "pids.max: $(cat $CGPATH/pids.max 2>/dev/null || echo N/A)"

echo -e "\n=== seccomp ==="
grep Seccomp /proc/$PID/status

echo -e "\n=== AppArmor ==="
cat /proc/$PID/attr/current 2>/dev/null || echo "N/A"

echo -e "\n=== DAC ==="
ps -o user,group,pid,cmd -p $PID

echo -e "\n=== Namespace ==="
sudo ls -l /proc/$PID/ns/

echo -e "\n=== Capabilities ==="
sudo getpcaps $PID

echo -e "\n=== Resource Usage ==="
systemd-cgtop -1 /machine.slice | grep -i "$VM" || true
```

**Penjelasan:**
- Skrip mengumpulkan semua informasi confinement.

### 4.26. Contoh XML Lengkap dengan Confinement

```xml
<domain type='kvm'>
  <name>confined-vm</name>
  <memory unit='MiB'>2048</memory>
  <currentMemory unit='MiB'>1024</currentMemory>
  <vcpu placement='static'>2</vcpu>

  <cputune>
    <vcpupin vcpu='0' cpuset='0'/>
    <vcpupin vcpu='1' cpuset='1'/>
    <emulatorpin cpuset='2-3'/>
    <shares>1024</shares>
    <period>100000</period>
    <quota>50000</quota>
  </cputune>

  <memtune>
    <hard_limit unit='MiB'>2048</hard_limit>
    <soft_limit unit='MiB'>1536</soft_limit>
  </memtune>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
  </os>

  <features>
    <acpi/>
    <apic/>
    <vmport state='off'/>
  </features>

  <cpu mode='host-passthrough' check='none'>
    <feature policy='disable' name='vmx'/>
    <feature policy='disable' name='svm'/>
  </cpu>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
      <source file='/var/lib/libvirt/images/confined-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <iotune>
        <total_bytes_sec>10485760</total_bytes_sec>
        <total_iops_sec>1000</total_iops_sec>
      </iotune>
    </disk>
    <controller type='pci' index='0' model='pcie-root'/>
    <interface type='network'>
      <source network='lan'/>
      <model type='virtio'/>
      <filterref filter='clean-traffic'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
    </channel>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
    <memballoon model='none'/>
    <graphics type='none'/>
    <video>
      <model type='none'/>
    </video>
    <controller type='usb' index='0' model='none'/>
  </devices>

  <seclabel type='dynamic' model='dac' relabel='yes'/>
</domain>
```

**Penjelasan:**
- Gabungan hardening XML (6.1) + cgroups + seccomp + AppArmor + DAC.

---

## 5. Diagram Arsitektur Confinement QEMU

### 5.1. Lapisan Confinement

```
+-------------------+
|   VM (Guest)      |
+-------------------+
          |
          | (guest escape)
          v
+-------------------+
|   QEMU Process    |
+-------------------+
          |
          | Lapisan 1: seccomp (syscall)
          v
+-------------------+
|   Kernel          |
+-------------------+
          |
          | Lapisan 2: AppArmor (file/network)
          v
+-------------------+
|   Filesystem      |
+-------------------+
          |
          | Lapisan 3: DAC (permission)
          v
+-------------------+
|   Resource        |
+-------------------+
          |
          | Lapisan 4: cgroups (CPU/mem/IO)
          v
+-------------------+
|   Host            |
+-------------------+
```

### 5.2. Hierarki cgroups

```
/sys/fs/cgroup/
├── system.slice/
│   ├── sshd.service
│   └── ...
├── user.slice/
│   └── user-1000.slice/
└── machine.slice/
    ├── machine-qemu\x2d1\x2darch\x2dvm.scope/
    │   ├── cpu.max
    │   ├── memory.max
    │   ├── io.max
    │   ├── pids.max
    │   └── cgroup.procs
    └── machine-qemu\x2d2\x2ddebian\x2dvm.scope/
        └── ...
```

### 5.3. Alur seccomp

```
QEMU
  |
  | syscall (mis. mount)
  v
+-------------------+
| seccomp filter    |
+-------------------+
  |
  | Diizinkan?
  +-- Ya --> Kernel
  |
  +-- Tidak --> Error / Kill
```

### 5.4. Alur AppArmor

```
QEMU
  |
  | akses file /etc/shadow
  v
+-------------------+
| AppArmor profile  |
+-------------------+
  |
  | Diizinkan?
  +-- Ya --> Akses
  |
  +-- Tidak --> Denied + Log
```

### 5.5. Alur DAC

```
QEMU (user: libvirt-qemu)
  |
  | akses file /var/lib/libvirt/images/vm.qcow2
  v
+-------------------+
| Permission check  |
+-------------------+
  |
  | Owner? Group? Other?
  +-- Ya --> Akses
  |
  +-- Tidak --> Permission denied
```

### 5.6. Defense in Depth

```
+-------------------+
|   Hardening XML   |  (kurangi permukaan serangan)
+-------------------+
          |
          v
+-------------------+
|   seccomp         |  (batasi syscall)
+-------------------+
          |
          v
+-------------------+
|   AppArmor        |  (batasi file)
+-------------------+
          |
          v
+-------------------+
|   DAC             |  (batasi permission)
+-------------------+
          |
          v
+-------------------+
|   cgroups         |  (batasi resource)
+-------------------+
          |
          v
+-------------------+
|   Namespace       |  (isolasi view)
+-------------------+
          |
          v
+-------------------+
|   Capabilities    |  (potong hak root)
+-------------------+
```

### 5.7. Pohon Keputusan Confinement

```
Apakah VM perlu akses file host?
├── Ya → Filesystem passthrough (hati-hati)
└── Tidak → Default: tidak ada akses

Apakah VM perlu network?
├── Ya → Interface + nwfilter
└── Tidak → Tidak ada interface

Apakah VM perlu resource besar?
├── Ya → Sesuaikan cgroups
└── Tidak → Batasi default

Apakah VM perlu syscall khusus?
├── Ya → Sesuaikan seccomp
└── Tidak → Default profil
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 6.2

Kurikulum asli menyebut:
> cgroups v2: `cputune`, `memtune`, `blkiotune`.
> seccomp: profil default QEMU.
> AppArmor: opsional di Arch, perlu instalasi.

Kita akan menambahkan:

1. **cgroups v2 hierarki** — `machine.slice`.
2. **File cgroup** — `cpu.max`, `memory.max`, `io.max`, `pids.max`, `cpuset.cpus`.
3. **`cputune` lengkap** — `vcpupin`, `emulatorpin`, `iothreadpin`, `shares`, `period`, `quota`.
4. **`memtune` lengkap** — `hard_limit`, `soft_limit`, `swap_hard_limit`, `min_guarantee`.
5. **`blkiotune` lengkap** — `weight`, `device`.
6. **`iotune` per disk** — `total_bytes_sec`, `read_bytes_sec`, `write_bytes_sec`, `total_iops_sec`.
7. **`virsh schedinfo`**, **`virsh blkdeviotune`**, **`virsh memtune`**.
8. **seccomp mode** — `Seccomp: 2`, filter.
9. **`seccomp_sandbox`** di `qemu.conf`.
10. **QEMU `-sandbox`** argumen.
11. **AppArmor** — `aa-status`, `aa-complain`, `aa-enforce`.
12. **Profil AppArmor** — `/etc/apparmor.d/`, `libvirt-qemu`.
13. **Profil dinamis** — `/etc/apparmor.d/libvirt/`.
14. **DAC** — user `libvirt-qemu`, group `kvm`, `dynamic_ownership`.
15. **Namespace** — `mnt`, `pid`, `net`, `ipc`, `uts`, `user`, `cgroup`.
16. **Capabilities** — `getpcaps`, `capsh`.
17. **Monitoring** — `systemd-cgtop`, `virsh domstats`.
18. **Stress test** — `stress-ng`, `fio`.
19. **Skrip audit** confinement.
20. **Contoh XML lengkap** dengan confinement.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 6.2.

---

## 7. Hubungan dengan Modul Lain

- **Modul 6.1 (Hardening XML):** XML yang hardened memudahkan confinement.
- **Modul 6.3 (Secure Boot + vTPM):** confinement melindungi kunci enkripsi.
- **Modul 6.4 (Unprivileged):** user namespace adalah confinement.
- **Modul 6.5 (Threat Model):** confinement adalah kontrol mitigasi.
- **Fase 3 (Domain XML):** `cputune`, `memtune`, `blkiotune` adalah bagian XML.
- **Fase 5 (nwfilter):** filterref adalah bagian confinement network.
- **Fase 7 (Otomasi):** skrip harus menerapkan confinement.
- **Fase 8 (Observability):** monitoring cgroups.

---

## 8. Referensi Lengkap

- libvirt cgroups — https://libvirt.org/cgroups.html
- libvirt CPU tuning — https://libvirt.org/formatdomain.html#cpu-tuning
- libvirt Memory tuning — https://libvirt.org/formatdomain.html#memory-tuning
- libvirt Block I/O tuning — https://libvirt.org/formatdomain.html#block-i-o-tuning
- libvirt seclabel — https://libvirt.org/formatdomain.html#security-label
- libvirt QEMU seccomp — https://libvirt.org/qemu.html
- QEMU seccomp — https://wiki.qemu.org/Features/Sandbox
- QEMU sandbox — https://www.qemu.org/docs/master/system/qemu-manpage.html
- AppArmor — https://gitlab.com/apparmor/apparmor/-/wikis/home
- AppArmor libvirt — https://gitlab.com/apparmor/apparmor/-/wikis/Libvirt
- Arch Wiki: AppArmor — https://wiki.archlinux.org/title/AppArmor
- Arch Wiki: cgroups — https://wiki.archlinux.org/title/Cgroups
- Arch Wiki: systemd-cgtop — https://wiki.archlinux.org/title/Systemd-cgtop
- systemd cgroups — https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
- Linux cgroups v2 — https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html
- seccomp — https://www.kernel.org/doc/html/latest/userspace-api/seccomp_filter.html
- capabilities — https://man7.org/linux/man-pages/man7/capabilities.7.html
- namespaces — https://man7.org/linux/man-pages/man7/namespaces.7.html
- stress-ng — https://github.com/ColinIanKing/stress-ng
- fio — https://fio.readthedocs.io/
- NIST SP 800-125 — https://csrc.nist.gov/publications/detail/sp/800-125/final

---

## 9. Tips & Praktik Terbaik

1. **Aktifkan seccomp** di `qemu.conf`.
2. **Gunakan AppArmor** jika tersedia.
3. **Batasi CPU** dengan `cputune`.
4. **Batasi memori** dengan `memtune`.
5. **Batasi I/O** dengan `iotune`.
6. **Pin vCPU** untuk determinisme.
7. **Pin emulator** ke CPU terpisah.
8. **Gunakan `cache='none'`** untuk keamanan.
9. **Gunakan `discard='unmap'`** untuk TRIM.
10. **Monitor dengan `systemd-cgtop`**.
11. **Monitor dengan `virsh domstats`**.
12. **Stress test** secara berkala.
13. **Audit confinement** dengan skrip.
14. **Dokumentasikan konfigurasi**.
15. **Backup XML** sebelum perubahan.
16. **Gunakan `q35`** untuk chipset modern.
17. **Jangan gunakan `host-passthrough` tanpa disable vmx/svm**.
18. **Latih troubleshooting**.
19. **Otomasi dengan skrip**.
20. **Pantau log AppArmor**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| VM tidak start | cgroups tidak aktif. | Cek `systemd.unified_cgroup_hierarchy=1`. |
| VM lambat | quota terlalu kecil. | Sesuaikan `quota`. |
| VM OOM | `hard_limit` terlalu kecil. | Tingkatkan. |
| I/O lambat | `iotune` terlalu ketat. | Sesuaikan. |
| seccomp memblokir | Syscall diperlukan. | Sesuaikan profil. |
| AppArmor memblokir | Profil terlalu ketat. | `aa-complain` untuk debug. |
| DAC gagal | Permission file salah. | `chown libvirt-qemu:kvm`. |
| Namespace gagal | Kernel tidak support. | Cek `unshare`. |
| Capability berlebih | Konfigurasi salah. | Cek `getpcaps`. |
| `virsh schedinfo` error | VM tidak jalan. | Start VM. |
| `systemd-cgtop` kosong | Tidak ada VM. | Start VM. |
| `aa-status` error | AppArmor tidak aktif. | Install dan aktifkan. |
| `getpcaps` error | Tidak ada proses. | Cek PID. |
| Stress test gagal | Resource tidak cukup. | Sesuaikan. |
| Log penuh | Tidak ada rate limit. | Tambahkan limit. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `systemd-cgls /machine.slice` menampilkan VM.
- `cat /sys/fs/cgroup/.../cpu.max` menampilkan kuota.
- `cat /sys/fs/cgroup/.../memory.max` menampilkan batas.
- `grep Seccomp /proc/$PID/status` menampilkan `2`.
- `aa-status` menampilkan profil QEMU.
- `ps -eo user,group,pid,cmd | grep qemu` menampilkan `libvirt-qemu`.
- `ls -l /proc/$PID/ns/` menampilkan namespace.
- `getpcaps $PID` menampilkan capability minimal.
- `systemd-cgtop` menampilkan resource.
- `virsh domstats` menampilkan statistik.
- Stress test CPU tidak melebihi kuota.
- Stress test memori tidak melebihi batas.
- Stress test I/O dibatasi.

**Troubleshooting:**
- Jika VM tidak start: cek `journalctl -u virtqemud`, cek cgroups.
- Jika VM lambat: cek `virsh schedinfo`, sesuaikan quota.
- Jika OOM: cek `memory.max`, tingkatkan.
- Jika I/O lambat: cek `virsh blkdeviotune`, sesuaikan.
- Jika seccomp memblokir: cek `dmesg | grep seccomp`, sesuaikan.
- Jika AppArmor memblokir: cek `dmesg | grep apparmor`, `aa-complain`.
- Jika DAC gagal: cek `ls -l`, `chown`.
- Jika namespace gagal: cek kernel config.
- Untuk debugging: `strace -f -p $PID`, `perf`.
- Untuk log: `journalctl -u virtqemud`, `/var/log/libvirt/qemu/`.

---

## 12. Latihan Mandiri

1. Lihat cgroup VM dengan `systemd-cgls`.
2. Lihat `cpu.max`, `memory.max`, `pids.max`.
3. Tambahkan `cputune` ke XML.
4. Terapkan dan uji.
5. Tambahkan `memtune`.
6. Terapkan dan uji.
7. Tambahkan `blkiotune`.
8. Terapkan dan uji.
9. Tambahkan `iotune` per disk.
10. Terapkan dan uji.
11. Cek `virsh schedinfo`.
12. Cek `virsh domstats`.
13. Cek seccomp dengan `grep Seccomp`.
14. Cek AppArmor dengan `aa-status`.
15. Cek DAC dengan `ps`.
16. Cek namespace dengan `ls -l /proc/$PID/ns/`.
17. Cek capability dengan `getpcaps`.
18. Stress test CPU.
19. Stress test memori.
20. Stress test I/O.
21. Monitor dengan `systemd-cgtop`.
22. Buat skrip audit.
23. Dokumentasikan konfigurasi.
24. Tulis ringkasan: mengapa setiap lapisan penting.

---

## 13. Penutup Modul 6.2

Anda kini menguasai **Confinement QEMU** — seni membatasi proses QEMU agar tidak membahayakan host. Anda bisa:
- Mengonfigurasi **cgroups v2** untuk membatasi CPU, memori, I/O.
- Mengaktifkan **seccomp** untuk membatasi system call.
- Menggunakan **AppArmor** untuk membatasi akses file/network.
- Memahami **DAC**, **namespace**, dan **capabilities**.
- Memonitor resource dengan `systemd-cgtop` dan `virsh domstats`.
- Melakukan **stress test** untuk validasi.
- Mengaudit confinement dengan skrip.

Ini adalah fondasi untuk **Modul 6.3 — Secure Boot + vTPM + Enkripsi Disk**, di mana kita akan melindungi **integritas boot** dan **kerahasiaan data** VM.

---

*Motivasi: Confinement adalah kandang yang tidak terlihat. Ia tidak membatasi kekuatan, tetapi mengarahkannya. QEMU boleh kuat, asal tidak keluar dari batas. Keamanan sejati adalah ketika kekuatan dan kendali berjalan bersama.*

---

> *“Boot yang tidak terverifikasi adalah pintu terbuka. Data yang tidak terenkripsi adalah rahasia yang diteriakkan.”*

---

# Modul 6.3 — Secure Boot + vTPM + Enkripsi Disk

## Mini-Daftar Isi Modul 6.3

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Secure Boot + vTPM + Enkripsi
6. Audit Kurikulum: Tambahan untuk Modul 6.3
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 6.3

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Secure Boot**, **vTPM**, dan **Enkripsi Disk** adalah tiga pilar **kepercayaan dan kerahasiaan** VM:

- **Secure Boot**: memastikan hanya bootloader dan kernel yang **ditandatangani secara kriptografis** yang bisa dijalankan. Mencegah **bootkit** dan **rootkit** yang mencoba memuat sebelum OS.
- **vTPM (virtual Trusted Platform Module)**: menyediakan **TPM 2.0 virtual** ke guest. TPM menyimpan kunci, mengukur komponen boot (measured boot), dan mendukung **BitLocker**, **LUKS dengan TPM**, serta **remote attestation**.
- **Enkripsi Disk**: melindungi data VM **at rest** (saat disk tidak digunakan). Jika file image dicuri, data tetap aman. Bisa menggunakan **LUKS** (di dalam guest) atau **qcow2 encryption** (di level QEMU).

Ketiganya saling melengkapi:
- Secure Boot melindungi **integritas boot**.
- vTPM menyimpan **kunci dan pengukuran**.
- Enkripsi melindungi **kerahasiaan data**.

**Peran dalam kurikulum:** Modul ini adalah **lapisan ketiga Fase 6** setelah Hardening XML (6.1) dan Confinement QEMU (6.2). Jika hardening mengurangi permukaan serangan, dan confinement membatasi QEMU, maka modul ini melindungi **integritas dan kerahasiaan** VM dari serangan **offline** (mis. pencurian disk) dan **boot-level** (mis. bootkit). Ini juga fondasi untuk:
- **Modul 6.4 (VM Unprivileged)**: vTPM bisa digunakan tanpa root.
- **Modul 6.5 (Threat Model)**: Secure Boot + vTPM + Enkripsi adalah kontrol mitigasi.
- **Fase 7 (Otomasi)**: provisioning VM dengan enkripsi.
- **Fase 8 (Expert)**: measured boot, remote attestation.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Chain of Trust: Rantai Kepercayaan

Secure Boot dimulai dari **root of trust** — kunci publik yang tertanam di firmware (UEFI). Firmware memverifikasi **bootloader** (mis. GRUB, systemd-boot). Bootloader memverifikasi **kernel**. Kernel memverifikasi **module**. Setiap langkah memverifikasi langkah berikutnya.

**Filosofi:** *Kepercayaan harus dimulai dari suatu tempat. Root of trust adalah fondasi.*

### 2.2. Secure Boot: Hanya yang Ditandatangani

Secure Boot menggunakan **kunci kriptografis**:
- **PK (Platform Key)**: kunci utama.
- **KEK (Key Exchange Key)**: kunci untuk update.
- **db (Signature Database)**: kunci yang diizinkan.
- **dbx (Forbidden Signature Database)**: kunci yang dilarang.

Jika bootloader tidak ditandatangani oleh kunci di `db`, firmware akan menolak boot.

**Filosofi:** *Tanda tangan adalah segel. Tanpa segel, pintu tidak terbuka.*

### 2.3. OVMF: UEFI untuk QEMU

**OVMF** (Open Virtual Machine Firmware) adalah implementasi **UEFI** untuk QEMU. Ia mendukung Secure Boot dengan menyediakan **OVMF_CODE** (firmware) dan **OVMF_VARS** (variabel NVRAM).

**Filosofi:** *Firmware adalah akar. Pilih yang bisa diverifikasi.*

### 2.4. vTPM: TPM Virtual

**TPM** (Trusted Platform Module) adalah **chip kriptografis** yang:
- Menyimpan kunci (RSA, ECC).
- Mengukur komponen boot (PCR — Platform Configuration Register).
- Menyediakan **random number generator**.
- Mendukung **sealed storage** — data hanya bisa dibuka jika PCR cocok.

**vTPM** adalah TPM virtual yang diemulasi oleh **swtpm**. Guest melihatnya sebagai TPM 2.0 asli.

**Filosofi:** *TPM adalah jantung kepercayaan. Ia mengukur, menyimpan, dan melindungi.*

### 2.5. PCR: Platform Configuration Register

PCR adalah **register** di TPM yang menyimpan **hash** dari komponen boot. Setiap kali komponen dimuat, hash-nya di-*extend* ke PCR:
```
PCR_new = hash(PCR_old || hash(komponen))
```

PCR yang umum:
- PCR 0: firmware.
- PCR 1: konfigurasi firmware.
- PCR 2: option ROM.
- PCR 3: option ROM config.
- PCR 4: bootloader.
- PCR 5: bootloader config.
- PCR 6: command.
- PCR 7: Secure Boot state.
- PCR 8-15: OS-specific.

**Filosofi:** *PCR adalah catatan sejarah boot. Jika berubah, ada yang berubah.*

### 2.6. Measured Boot: Boot yang Terukur

**Measured boot** adalah proses **mengukur** setiap komponen boot ke PCR. Jika komponen berubah, PCR berubah. Ini memungkinkan **remote attestation** — server lain bisa memverifikasi bahwa VM boot dengan komponen yang benar.

**Filosofi:** *Yang tidak diukur, tidak bisa dipercaya.*

### 2.7. Sealed Storage: Rahasia yang Terkunci

**Sealed storage** adalah kemampuan TPM untuk **menyegel** data sehingga hanya bisa dibuka jika **PCR cocok**. Jika boot berubah (mis. bootkit), PCR berubah, dan data tidak bisa dibuka.

**Filosofi:** *Rahasia hanya untuk kondisi yang benar.*

### 2.8. Enkripsi Disk: Data at Rest

Enkripsi disk melindungi data **saat disk tidak digunakan**. Ada dua level:
- **Di dalam guest (LUKS)**: guest mengenkripsi partisinya. Kunci bisa disimpan di TPM.
- **Di level QEMU (qcow2 encryption)**: QEMU mengenkripsi file image. Kunci diberikan saat boot.

**Filosofi:** *Disk adalah buku. Enkripsi adalah kunci. Tanpa kunci, buku tidak bisa dibaca.*

### 2.9. LUKS: Linux Unified Key Setup

**LUKS** adalah standar enkripsi disk di Linux. Ia menyimpan **header** dengan metadata, dan **keyslot** dengan kunci terenkripsi. Untuk membuka, Anda memberikan passphrase atau kunci.

**Filosofi:** *LUKS adalah brankas. Header adalah kombinasi. Keyslot adalah kunci.*

### 2.10. qcow2 Encryption: Enkripsi di Level QEMU

QEMU mendukung enkripsi **qcow2** dengan **LUKS** atau **AES**. Kunci diberikan saat QEMU dijalankan. Ini melindungi file image **sebelum guest boot**.

**Filosofi:** *Enkripsi di level QEMU adalah lapisan pertama. Enkripsi di guest adalah lapisan kedua.*

### 2.11. Kombinasi: Secure Boot + vTPM + Enkripsi

Ketiganya bekerja bersama:
1. **Secure Boot** memastikan bootloader dan kernel sah.
2. **vTPM** mengukur boot dan menyimpan kunci.
3. **Enkripsi** melindungi data dengan kunci yang disegel ke PCR.

Jika boot berubah, PCR berubah, kunci tidak bisa dibuka, data tetap aman.

**Filosofi:** *Integritas + kerahasiaan = kepercayaan.*

### 2.12. Filosofi Keseluruhan

- **Root of trust** adalah fondasi.
- **Secure Boot** melindungi integritas.
- **vTPM** mengukur dan menyimpan.
- **Enkripsi** melindungi kerahasiaan.
- **Measured boot** memungkinkan attestation.
- **Sealed storage** mengikat rahasia ke kondisi.
- **Defense in depth** — jangan andalkan satu lapisan.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Secure Boot** | Boot terverifikasi. | |
| **UEFI** | Unified Extensible Firmware Interface. | |
| **OVMF** | UEFI untuk QEMU. | |
| **PK** | Platform Key. | |
| **KEK** | Key Exchange Key. | |
| **db** | Signature Database. | |
| **dbx** | Forbidden Signature Database. | |
| **TPM** | Trusted Platform Module. | |
| **vTPM** | TPM virtual. | |
| **swtpm** | Software TPM. | |
| **PCR** | Platform Configuration Register. | |
| **Measured boot** | Boot terukur. | |
| **Remote attestation** | Verifikasi jarak jauh. | |
| **Sealed storage** | Penyimpanan tersegel. | |
| **LUKS** | Linux Unified Key Setup. | |
| **qcow2 encryption** | Enkripsi qcow2. | |
| **luksFormat** | Format LUKS. | |
| **cryptsetup** | Alat LUKS. | |
| **crypttab** | Konfigurasi LUKS. | |
| **clevis** | Otomasi enkripsi. | |
| **tang** | Server kunci. | |
| **tpm2-tools** | Alat TPM 2.0. | |
| **tpm2-tss** | TPM Software Stack. | |
| **systemd-cryptenroll** | Enroll kunci ke LUKS. | |
| **OVMF_CODE** | Firmware OVMF. | |
| **OVMF_VARS** | Variabel NVRAM. | |
| **secboot** | Secure Boot. | |
| **q35** | Chipset QEMU. | |
| **SMM** | System Management Mode. | |
| **TPM 2.0** | Versi TPM. | |
| **PCR 7** | PCR untuk Secure Boot. | |
| **UKI** | Unified Kernel Image. | |
| **sbctl** | Alat Secure Boot. | |
| **sbverify** | Verifikasi签名. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Instalasi Paket

```bash
sudo pacman -S edk2-ovmf swtpm tpm2-tools tpm2-tss cryptsetup
```

**Penjelasan kata demi kata:**
- `pacman -S` — install paket.
- `edk2-ovmf` — OVMF firmware.
- `swtpm` — Software TPM.
- `tpm2-tools` — alat TPM 2.0.
- `tpm2-tss` — TPM Software Stack.
- `cryptsetup` — alat LUKS.

**Paket tambahan (opsional):**
```bash
sudo pacman -S libvirt virt-install qemu-full
```

### 4.2. Menyiapkan OVMF untuk Secure Boot

```bash
ls /usr/share/edk2/x64/
```

**Output:**
```
OVMF_CODE.fd
OVMF_CODE.secboot.fd
OVMF_VARS.fd
OVMF_VARS.secboot.fd
```

**Penjelasan:**
- `OVMF_CODE.fd` — firmware tanpa Secure Boot.
- `OVMF_CODE.secboot.fd` — firmware dengan Secure Boot.
- `OVMF_VARS.fd` — variabel NVRAM default.
- `OVMF_VARS.secboot.fd` — variabel NVRAM untuk Secure Boot.

**Copy VARS:**
```bash
cp /usr/share/edk2/x64/OVMF_VARS.secboot.fd /var/lib/libvirt/qemu/nvram/hardened-vm_VARS.fd
```

**Penjelasan:**
- Copy VARS ke lokasi yang bisa ditulis.
- Setiap VM harus punya VARS sendiri.

### 4.3. Menambahkan OVMF + Secure Boot ke XML

```xml
<os>
  <type arch='x86_64' machine='q35'>hvm</type>
  <loader readonly='yes' type='pflash'>/usr/share/edk2/x64/OVMF_CODE.secboot.fd</loader>
  <nvram>/var/lib/libvirt/qemu/nvram/hardened-vm_VARS.fd</nvram>
  <boot dev='hd'/>
</os>
<features>
  <acpi/>
  <apic/>
  <smm state='on'/>
</features>
```

**Penjelasan kata demi kata:**
- `<loader readonly='yes' type='pflash'>` — loader firmware.
- `/usr/share/edk2/x64/OVMF_CODE.secboot.fd` — path firmware Secure Boot.
- `<nvram>` — path variabel NVRAM.
- `<smm state='on'/>` — System Management Mode aktif (diperlukan untuk Secure Boot).

### 4.4. Menyiapkan swtpm

```bash
mkdir -p /var/lib/libvirt/swtpm/hardened-vm
swtpm_setup --tpmstate /var/lib/libvirt/swtpm/hardened-vm \
  --create-ek-cert \
  --create-platform-cert \
  --lock-nvram \
  --tpm2 \
  --display
```

**Penjelasan:**
- `mkdir -p` — buat direktori.
- `swtpm_setup` — setup TPM.
- `--tpmstate` — direktori state.
- `--create-ek-cert` — buat sertifikat Endorsement Key.
- `--create-platform-cert` — buat sertifikat platform.
- `--lock-nvram` — kunci NVRAM.
- `--tpm2` — TPM 2.0.
- `--display` — tampilkan info.

### 4.5. Menjalankan swtpm

```bash
swtpm socket \
  --tpmstate dir=/var/lib/libvirt/swtpm/hardened-vm \
  --ctrl type=unixio,path=/var/lib/libvirt/swtpm/hardened-vm/swtpm.sock \
  --log level=20 \
  --tpm2 \
  --daemon
```

**Penjelasan:**
- `swtpm socket` — mode socket.
- `--tpmstate dir=...` — direktori state.
- `--ctrl type=unixio,path=...` — control socket.
- `--log level=20` — log level.
- `--tpm2` — TPM 2.0.
- `--daemon` — background.

### 4.6. Menambahkan vTPM ke XML

```xml
<devices>
  <tpm model='tpm-tis'>
    <backend type='emulator' version='2.0'>
      <source path='/var/lib/libvirt/swtpm/hardened-vm/swtpm.sock'/>
    </backend>
  </tpm>
</devices>
```

**Penjelasan:**
- `<tpm model='tpm-tis'>` — TPM model TIS.
- `<backend type='emulator' version='2.0'>` — backend emulator TPM 2.0.
- `<source path='...'/>` — socket swtpm.

**Alternatif:** Libvirt bisa mengelola swtpm otomatis:
```xml
<devices>
  <tpm model='tpm-tis'>
    <backend type='emulator' version='2.0'/>
  </tpm>
</devices>
```

**Penjelasan:**
- Libvirt akan menjalankan swtpm sendiri.
- State disimpan di `/var/lib/libvirt/swtpm/<vm>/`.

### 4.7. Membuat Disk Terenkripsi dengan qcow2

```bash
qemu-img create -f qcow2 \
  --object secret,id=sec0,data=passphrase \
  -o encrypt.format=luks,encrypt.key-secret=sec0 \
  disk-encrypted.qcow2 10G
```

**Penjelasan kata demi kata:**
- `qemu-img create` — buat image.
- `-f qcow2` — format qcow2.
- `--object secret,id=sec0,data=passphrase` — objek secret dengan ID `sec0`, data `passphrase`.
- `-o encrypt.format=luks` — opsi enkripsi LUKS.
- `-o encrypt.key-secret=sec0` — gunakan secret `sec0`.
- `disk-encrypted.qcow2` — nama file.
- `10G` — ukuran.

**Alternatif dengan AES:**
```bash
qemu-img create -f qcow2 \
  --object secret,id=sec0,data=passphrase \
  -o encrypt.format=aes,encrypt.key-secret=sec0 \
  disk-encrypted.qcow2 10G
```

### 4.8. Menjalankan VM dengan Disk Terenkripsi

**Di XML:**
```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2' cache='none' io='native'/>
  <source file='/var/lib/libvirt/images/disk-encrypted.qcow2'/>
  <target dev='vda' bus='virtio'/>
  <encryption format='luks'>
    <secret type='passphrase' uuid='...'/>
  </encryption>
</disk>
```

**Penjelasan:**
- `<encryption format='luks'>` — enkripsi LUKS.
- `<secret type='passphrase' uuid='...'/>` — referensi ke secret.

**Membuat secret:**
```bash
cat > secret.xml <<EOF
<secret ephemeral='no' private='yes'>
  <description>LUKS passphrase</description>
  <usage type='volume'>
    <volume>/var/lib/libvirt/images/disk-encrypted.qcow2</volume>
  </usage>
</secret>
EOF

virsh secret-define secret.xml
virsh secret-set-value --secret <uuid> --base64 $(echo -n "passphrase" | base64)
```

**Penjelasan:**
- `secret-define` — definisikan secret.
- `secret-set-value` — set nilai.
- `--base64` — nilai base64.

### 4.9. LUKS di Dalam Guest

**Di guest:**
```bash
cryptsetup luksFormat /dev/vdb
cryptsetup luksOpen /dev/vdb encrypted
mkfs.ext4 /dev/mapper/encrypted
mount /dev/mapper/encrypted /mnt
```

**Penjelasan:**
- `luksFormat` — format LUKS.
- `luksOpen` — buka LUKS.
- `mkfs.ext4` — buat filesystem.
- `mount` — mount.

### 4.10. Enroll Kunci LUKS ke TPM

**Di guest:**
```bash
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/vdb
```

**Penjelasan:**
- `systemd-cryptenroll` — enroll kunci.
- `--tpm2-device=auto` — gunakan TPM 2.0.
- `--tpm2-pcrs=7` — ikat ke PCR 7 (Secure Boot state).
- `/dev/vdb` — perangkat LUKS.

### 4.11. Measured Boot: Melihat PCR

**Di guest:**
```bash
tpm2_pcrread
```

**Output:**
```
sha256:
  0 : 0x...
  1 : 0x...
  2 : 0x...
  3 : 0x...
  4 : 0x...
  5 : 0x...
  6 : 0x...
  7 : 0x...
```

**Penjelasan:**
- `tpm2_pcrread` — baca PCR.
- PCR 7 menunjukkan Secure Boot state.

### 4.12. Remote Attestation

**Di guest:**
```bash
tpm2_quote -c 0x81010001 -l sha256:0,1,2,3,4,5,6,7 -q $(tpm2_getrandom 16 | xxd -p) -m quote.msg -s quote.sig -o quote.pcr
```

**Penjelasan:**
- `tpm2_quote` — buat quote.
- `-c 0x81010001` — kunci attestation.
- `-l sha256:...` — PCR yang di-quote.
- `-q` — nonce.
- `-m` — output message.
- `-s` — output signature.
- `-o` — output PCR.

**Verifikasi di host:**
```bash
tpm2_checkquote -c ak.pub -m quote.msg -s quote.sig -f quote.pcr -q nonce
```

**Penjelasan:**
- `tpm2_checkquote` — verifikasi quote.

### 4.13. Secure Boot: Melihat Status

**Di guest:**
```bash
mokutil --sb-state
```

**Output:**
```
SecureBoot enabled
```

**Penjelasan:**
- `mokutil` — Machine Owner Key utility.
- `--sb-state` — status Secure Boot.

**Alternatif:**
```bash
bootctl status
```

**Output:**
```
Secure Boot: enabled
```

### 4.14. Secure Boot: Keys

```bash
sbctl status
```

**Output:**
```
Installed:      ✓ sbctl is installed
Owner GUID:     ...
Setup Mode:     ✓ Disabled
Secure Boot:    ✓ Enabled
Vendor Keys:    microsoft
```

**Penjelasan:**
- `sbctl` — alat Secure Boot.
- `status` — status.

### 4.15. Secure Boot: Enroll Keys

```bash
sbctl create-keys
sbctl enroll-keys -m
sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sbctl sign -s /boot/vmlinuz-linux
sbctl verify
```

**Penjelasan:**
- `create-keys` — buat kunci.
- `enroll-keys -m` — enroll kunci + Microsoft.
- `sign -s` — sign file.
- `verify` — verifikasi.

### 4.16. UKI: Unified Kernel Image

**Membuat UKI:**
```bash
# /etc/mkinitcpio.d/linux.preset
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"
ALL_kerneldest="/boot/vmlinuz-linux"
PRESETS=('default')
default_uki="/boot/EFI/Linux/arch-linux.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"
```

**Penjelasan:**
- `default_uki` — path UKI.
- UKI menggabungkan kernel, initramfs, cmdline.

**Build:**
```bash
mkinitcpio -P
```

### 4.17. Verifikasi Secure Boot di VM

```bash
# Di guest
dmesg | grep -i secure
journalctl -k | grep -i secure
```

**Output:**
```
[    0.000000] secureboot: Secure boot enabled
```

### 4.18. Enkripsi qcow2: Melihat Info

```bash
qemu-img info --object secret,id=sec0,data=passphrase disk-encrypted.qcow2
```

**Output:**
```
image: disk-encrypted.qcow2
file format: qcow2
virtual size: 10G
disk size: 1.2M
encrypted: yes
```

**Penjelasan:**
- `encrypted: yes` — terenkripsi.

### 4.19. Mengubah Passphrase qcow2

```bash
qemu-img amend \
  --object secret,id=old,data=oldpass \
  --object secret,id=new,data=newpass \
  -o encrypt.key-secret=new \
  disk-encrypted.qcow2
```

**Penjelasan:**
- `qemu-img amend` — ubah metadata.
- `--object secret` — secret lama dan baru.
- `-o encrypt.key-secret=new` — set kunci baru.

### 4.20. Backup Disk Terenkripsi

```bash
qemu-img convert \
  --object secret,id=sec0,data=passphrase \
  -O qcow2 \
  disk-encrypted.qcow2 \
  backup-encrypted.qcow2
```

**Penjelasan:**
- `qemu-img convert` — konversi.
- `-O qcow2` — output qcow2.
- Backup tetap terenkripsi.

### 4.21. Kombinasi Lengkap: XML

```xml
<domain type='kvm'>
  <name>secure-vm</name>
  <memory unit='MiB'>2048</memory>
  <vcpu>2</vcpu>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>/usr/share/edk2/x64/OVMF_CODE.secboot.fd</loader>
    <nvram>/var/lib/libvirt/qemu/nvram/secure-vm_VARS.fd</nvram>
    <boot dev='hd'/>
  </os>

  <features>
    <acpi/>
    <apic/>
    <smm state='on'/>
  </features>

  <cpu mode='host-passthrough' check='none'/>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='/var/lib/libvirt/images/secure-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <encryption format='luks'>
        <secret type='passphrase' uuid='...'/>
      </encryption>
    </disk>

    <controller type='pci' index='0' model='pcie-root'/>

    <interface type='network'>
      <source network='lan'/>
      <model type='virtio'/>
      <filterref filter='clean-traffic'/>
    </interface>

    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>

    <tpm model='tpm-tis'>
      <backend type='emulator' version='2.0'/>
    </tpm>

    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>

    <memballoon model='none'/>
    <graphics type='none'/>
    <video><model type='none'/></video>
    <controller type='usb' index='0' model='none'/>
  </devices>

  <seclabel type='dynamic' model='dac' relabel='yes'/>
</domain>
```

**Penjelasan:**
- Gabungan OVMF + Secure Boot + vTPM + enkripsi qcow2 + hardening.

### 4.22. Skrip Setup Secure VM

```bash
#!/bin/bash
set -e

VM="secure-vm"
VARS="/var/lib/libvirt/qemu/nvram/${VM}_VARS.fd"

# 1. Copy OVMF VARS
cp /usr/share/edk2/x64/OVMF_VARS.secboot.fd "$VARS"

# 2. Buat disk terenkripsi
qemu-img create -f qcow2 \
  --object secret,id=sec0,data=passphrase \
  -o encrypt.format=luks,encrypt.key-secret=sec0 \
  /var/lib/libvirt/images/${VM}.qcow2 10G

# 3. Definisikan secret
cat > /tmp/secret.xml <<EOF
<secret ephemeral='no' private='yes'>
  <description>LUKS passphrase for ${VM}</description>
  <usage type='volume'>
    <volume>/var/lib/libvirt/images/${VM}.qcow2</volume>
  </usage>
</secret>
EOF

virsh secret-define /tmp/secret.xml
UUID=$(virsh secret-list | grep "${VM}" | awk '{print $1}')
virsh secret-set-value --secret $UUID --base64 $(echo -n "passphrase" | base64)

# 4. Buat VM
virt-install \
  --name "$VM" \
  --memory 2048 \
  --vcpus 2 \
  --disk /var/lib/libvirt/images/${VM}.qcow2 \
  --cdrom /var/lib/libvirt/images/arch.iso \
  --os-variant archlinux \
  --boot uefi \
  --features smm=on \
  --tpm backend.type=emulator,backend.version=2.0,model=tpm-tis \
  --graphics none \
  --console pty,target_type=serial \
  --network network=lan,model=virtio \
  --noautoconsole

echo "VM $VM created."
```

**Penjelasan:**
- Skrip membuat VM dengan Secure Boot, vTPM, dan enkripsi.

### 4.23. Verifikasi Lengkap

```bash
# 1. Cek firmware
virsh dumpxml secure-vm | grep -A 2 loader

# 2. Cek TPM
virsh dumpxml secure-vm | grep -A 3 tpm

# 3. Cek enkripsi
qemu-img info --object secret,id=sec0,data=passphrase /var/lib/libvirt/images/secure-vm.qcow2

# 4. Di guest, cek Secure Boot
# mokutil --sb-state
# bootctl status

# 5. Di guest, cek TPM
# tpm2_pcrread
# dmesg | grep -i tpm

# 6. Di guest, cek LUKS
# cryptsetup status encrypted
```

---

## 5. Diagram Arsitektur Secure Boot + vTPM + Enkripsi

### 5.1. Chain of Trust

```
+-------------------+
|   UEFI Firmware   |
|   (OVMF)          |
+-------------------+
          |
          | Verifikasi签名 bootloader
          v
+-------------------+
|   Bootloader      |
|   (GRUB/systemd-boot) |
+-------------------+
          |
          | Verifikasi签名 kernel
          v
+-------------------+
|   Kernel          |
+-------------------+
          |
          | Verifikasi module
          v
+-------------------+
|   OS              |
+-------------------+
```

### 5.2. Measured Boot + vTPM

```
+-------------------+
|   Firmware        |
+-------------------+
          |
          | Extend PCR 0
          v
+-------------------+
|   Bootloader      |
+-------------------+
          |
          | Extend PCR 4
          v
+-------------------+
|   Kernel          |
+-------------------+
          |
          | Extend PCR 8-9
          v
+-------------------+
|   vTPM (swtpm)    |
|   PCR 0-23        |
+-------------------+
          |
          | Sealed storage
          v
+-------------------+
|   Kunci LUKS      |
+-------------------+
```

### 5.3. Enkripsi Disk

```
+-------------------+
|   Guest           |
+-------------------+
| /dev/vdb (LUKS)   |
+-------------------+
          |
          | cryptsetup
          v
+-------------------+
|   /dev/mapper/encrypted |
+-------------------+
          |
          | mount
          v
+-------------------+
|   /mnt            |
+-------------------+
```

```
+-------------------+
|   QEMU            |
+-------------------+
| disk.qcow2 (LUKS) |
+-------------------+
          |
          | qemu-img
          v
+-------------------+
|   File Terenkripsi|
+-------------------+
```

### 5.4. Kombinasi

```
+-------------------+
|   Secure Boot     |  (integritas)
+-------------------+
          |
          v
+-------------------+
|   vTPM            |  (pengukuran + kunci)
+-------------------+
          |
          v
+-------------------+
|   Enkripsi Disk   |  (kerahasiaan)
+-------------------+
          |
          v
+-------------------+
|   Data Aman       |
+-------------------+
```

### 5.5. Alur Boot Secure VM

```
1. OVMF memverifikasi bootloader
   ↓
2. Bootloader memverifikasi kernel
   ↓
3. Kernel memuat initramfs
   ↓
4. initramfs membuka LUKS (kunci dari TPM)
   ↓
5. TPM memverifikasi PCR
   ↓
6. Jika PCR cocok, kunci dibuka
   ↓
7. OS boot
```

### 5.6. Alur Sealed Storage

```
1. Boot normal → PCR = A
   ↓
2. Data disegel ke PCR A
   ↓
3. Boot normal lagi → PCR = A
   ↓
4. Data bisa dibuka
   ↓
5. Boot dengan bootkit → PCR = B
   ↓
6. Data tidak bisa dibuka
```

### 5.7. Pohon Keputusan Enkripsi

```
Apakah data sensitif?
├── Ya → Enkripsi
│   ├── Di guest → LUKS
│   └── Di QEMU → qcow2 encryption
└── Tidak → Tidak perlu

Apakah butuh TPM?
├── Ya → vTPM + sealed storage
└── Tidak → Passphrase manual

Apakah butuh Secure Boot?
├── Ya → OVMF +签名
└── Tidak → BIOS/UEFI biasa
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 6.3

Kurikulum asli menyebut:
> Secure Boot + vTPM + Enkripsi Disk.
> Lab: `qemu-img create -f qcow2 --object secret...`

Kita akan menambahkan:

1. **OVMF** — `OVMF_CODE.secboot.fd`, `OVMF_VARS.secboot.fd`.
2. **q35 + SMM** — diperlukan untuk Secure Boot.
3. **swtpm** — setup, socket, daemon.
4. **vTPM XML** — `<tpm model='tpm-tis'>`.
5. **PCR** — `tpm2_pcrread`.
6. **Measured boot** — extend PCR.
7. **Remote attestation** — `tpm2_quote`, `tpm2_checkquote`.
8. **Sealed storage** — `systemd-cryptenroll`.
9. **LUKS di guest** — `cryptsetup luksFormat`, `luksOpen`.
10. **qcow2 encryption** — `qemu-img create --object secret`.
11. **Secret libvirt** — `secret-define`, `secret-set-value`.
12. **Enkripsi XML** — `<encryption format='luks'>`.
13. **Mengubah passphrase** — `qemu-img amend`.
14. **Backup terenkripsi** — `qemu-img convert`.
15. **sbctl** — `create-keys`, `enroll-keys`, `sign`, `verify`.
16. **UKI** — Unified Kernel Image.
17. **mokutil** — `--sb-state`.
18. **bootctl** — `status`.
19. **Kombinasi lengkap** — XML.
20. **Skrip setup** — otomasi.
21. **Verifikasi lengkap**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 6.3.

---

## 7. Hubungan dengan Modul Lain

- **Modul 6.1 (Hardening XML):** XML hardened adalah fondasi.
- **Modul 6.2 (Confinement):** confinement melindungi QEMU yang menjalankan VM terenkripsi.
- **Modul 6.4 (Unprivileged):** vTPM bisa digunakan tanpa root.
- **Modul 6.5 (Threat Model):** Secure Boot + vTPM + Enkripsi adalah mitigasi.
- **Fase 2 (QEMU):** OVMF dan swtpm diperkenalkan.
- **Fase 3 (Domain XML):** `<os>`, `<tpm>`, `<encryption>` adalah XML.
- **Fase 4 (Storage):** enkripsi disk adalah bagian storage.
- **Fase 7 (Otomasi):** provisioning VM dengan enkripsi.
- **Fase 8 (Expert):** measured boot, remote attestation.

---

## 8. Referensi Lengkap

- libvirt Domain XML — https://libvirt.org/formatdomain.html
- libvirt TPM — https://libvirt.org/formatdomain.html#tpm-device
- libvirt Encryption — https://libvirt.org/formatdomain.html#disk-encryption
- libvirt Secrets — https://libvirt.org/formatsecret.html
- QEMU qcow2 encryption — https://qemu.readthedocs.io/en/latest/system/images.html#disk-image-encryption
- QEMU qemu-img — https://qemu.readthedocs.io/en/latest/tools/qemu-img.html
- swtpm — https://github.com/stefanberger/swtpm
- swtpm wiki — https://github.com/stefanberger/swtpm/wiki
- tpm2-tools — https://github.com/tpm2-software/tpm2-tools
- tpm2-tss — https://github.com/tpm2-software/tpm2-tss
- systemd-cryptenroll — https://www.freedesktop.org/software/systemd/man/systemd-cryptenroll.html
- cryptsetup — https://gitlab.com/cryptsetup/cryptsetup
- Arch Wiki: Secure Boot — https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot
- Arch Wiki: TPM — https://wiki.archlinux.org/title/Trusted_Platform_Module
- Arch Wiki: dm-crypt — https://wiki.archlinux.org/title/Dm-crypt
- Arch Wiki: OVMF — https://wiki.archlinux.org/title/OVMF
- sbctl — https://github.com/Foxboron/sbctl
- mokutil — https://github.com/lcp/mokutil
- bootctl — https://www.freedesktop.org/software/systemd/man/bootctl.html
- UKI — https://wiki.archlinux.org/title/Unified_kernel_image
- NIST SP 800-147 — BIOS Protection Guidelines
- NIST SP 800-155 — BIOS Integrity Measurement Guidelines
- TCG PC Client Platform Firmware Profile — https://trustedcomputinggroup.org/

---

## 9. Tips & Praktik Terbaik

1. **Gunakan OVMF `secboot`** untuk Secure Boot.
2. **Aktifkan SMM** di XML.
3. **Gunakan q35** untuk chipset modern.
4. **Gunakan swtpm** untuk vTPM.
5. **Gunakan TPM 2.0** (bukan 1.2).
6. **Enkripsi disk** dengan LUKS.
7. **Gunakan `cache='none'`** untuk keamanan.
8. **Simpan passphrase dengan aman**.
9. **Gunakan secret libvirt** untuk manajemen kunci.
10. **Backup VARS** sebelum perubahan.
11. **Backup image terenkripsi**.
12. **Uji boot** setelah perubahan.
13. **Verifikasi PCR** setelah boot.
14. **Gunakan `systemd-cryptenroll`** untuk TPM.
15. **Gunakan UKI** untuk Secure Boot.
16. **Gunakan `sbctl`** untuk manajemen kunci.
17. **Monitor log** Secure Boot.
18. **Dokumentasikan kunci**.
19. **Latih recovery** jika kunci hilang.
20. **Otomasi dengan skrip**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| VM tidak boot | OVMF tidak ditemukan. | Cek path `OVMF_CODE.secboot.fd`. |
| Secure Boot gagal | SMM tidak aktif. | Tambahkan `<smm state='on'/>`. |
| TPM tidak terdeteksi | swtpm tidak jalan. | Cek `swtpm` process. |
| PCR tidak cocok | Boot berubah. | Verifikasi komponen. |
| LUKS tidak bisa dibuka | Passphrase salah. | Cek passphrase. |
| qcow2 tidak bisa dibuka | Secret salah. | Cek secret. |
| Enkripsi gagal | Format tidak didukung. | Gunakan LUKS. |
| VM lambat | Enkripsi overhead. | Gunakan AES-NI. |
| Kunci hilang | Tidak ada backup. | Backup kunci. |
| Secret tidak ditemukan | UUID salah. | Cek `virsh secret-list`. |
| VARS corrupt | Tidak di-copy. | Copy ulang. |
| Firmware tidak update | OVMF lama. | Update paket. |
| Attestation gagal | Nonce salah. | Cek nonce. |
| UKI tidak boot |签名 salah. | Sign ulang. |
| mokutil error | Tidak ada MOK. | Enroll MOK. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virsh dumpxml secure-vm | grep loader` menampilkan `OVMF_CODE.secboot.fd`.
- `virsh dumpxml secure-vm | grep smm` menampilkan `state='on'`.
- `virsh dumpxml secure-vm | grep tpm` menampilkan `<tpm>`.
- `qemu-img info --object secret,... disk.qcow2` menampilkan `encrypted: yes`.
- Di guest, `mokutil --sb-state` menampilkan `SecureBoot enabled`.
- Di guest, `bootctl status` menampilkan `Secure Boot: enabled`.
- Di guest, `tpm2_pcrread` menampilkan PCR.
- Di guest, `dmesg | grep -i tpm` menampilkan TPM.
- Di guest, `cryptsetup status encrypted` menampilkan status.
- `systemd-cryptenroll` berhasil.
- `tpm2_quote` berhasil.
- `tpm2_checkquote` berhasil.
- `sbctl verify` berhasil.

**Troubleshooting:**
- Jika VM tidak boot: cek `journalctl -u virtqemud`, cek OVMF path.
- Jika Secure Boot gagal: cek SMM, cek签名.
- Jika TPM tidak terdeteksi: cek swtpm, cek socket.
- Jika PCR tidak cocok: cek komponen, cek boot.
- Jika LUKS gagal: cek passphrase, cek header.
- Jika qcow2 gagal: cek secret, cek format.
- Jika enkripsi lambat: cek AES-NI, cek CPU.
- Jika kunci hilang: recovery dengan backup.
- Untuk debugging: `dmesg`, `journalctl`, `tpm2_pcrread`.
- Untuk log: `/var/log/libvirt/qemu/`, `/var/log/swtpm/`.

---

## 12. Latihan Mandiri

1. Install `edk2-ovmf`, `swtpm`, `tpm2-tools`, `cryptsetup`.
2. Copy `OVMF_VARS.secboot.fd`.
3. Tambahkan OVMF + Secure Boot ke XML.
4. Aktifkan SMM.
5. Setup swtpm.
6. Tambahkan vTPM ke XML.
7. Jalankan VM.
8. Cek Secure Boot di guest.
9. Cek TPM di guest.
10. Baca PCR.
11. Buat disk qcow2 terenkripsi.
12. Definisikan secret.
13. Jalankan VM dengan disk terenkripsi.
14. Buat LUKS di guest.
15. Enroll kunci ke TPM.
16. Uji sealed storage.
17. Buat quote.
18. Verifikasi quote.
19. Buat UKI.
20. Sign UKI.
21. Verifikasi签名.
22. Backup image terenkripsi.
23. Dokumentasikan kunci.
24. Tulis ringkasan: mengapa setiap lapisan penting.

---

## 13. Penutup Modul 6.3

Anda kini menguasai **Secure Boot + vTPM + Enkripsi Disk** — tiga pilar kepercayaan dan kerahasiaan VM. Anda bisa:
- Mengonfigurasi **OVMF Secure Boot** dengan q35 + SMM.
- Menyiapkan **swtpm** untuk vTPM 2.0.
- Mengenkripsi disk dengan **LUKS** atau **qcow2 encryption**.
- Menggunakan **secret libvirt** untuk manajemen kunci.
- Membaca **PCR** dan melakukan **measured boot**.
- Melakukan **remote attestation** dengan `tpm2_quote`.
- Menggunakan **sealed storage** dengan `systemd-cryptenroll`.
- Membuat **UKI** dan menandatanganinya dengan `sbctl`.

Ini adalah fondasi untuk **Modul 6.4 — VM Unprivileged via qemu:///session**, di mana kita akan menjalankan VM tanpa hak root sama sekali.

---

*Motivasi: Kepercayaan tidak diberikan, ia dibangun. Secure Boot membangun kepercayaan dari firmware. vTPM mengukurnya. Enkripsi melindunginya. Ketiganya adalah rantai yang tidak boleh putus. Jika satu putus, yang lain menahan.*

---

> *“Hak istimewa adalah pedang bermata dua. Yang tidak memilikinya tidak bisa melukai. Yang tidak memilikinya juga tidak bisa dilukai.”*

---

# Modul 6.4 — VM Unprivileged via qemu:///session

## Mini-Daftar Isi Modul 6.4

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur VM Unprivileged
6. Audit Kurikulum: Tambahan untuk Modul 6.4
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 6.4

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**VM Unprivileged** adalah VM yang dijalankan **tanpa hak root** — baik di host maupun di dalam QEMU. Ini dicapai melalui **`qemu:///session`**, yaitu **instance libvirt per-user** yang berjalan sebagai user biasa (bukan `root` atau `libvirt-qemu`). Dalam mode ini:
- QEMU dijalankan sebagai **user yang sama** dengan yang menjalankan `virsh`.
- **Tidak ada daemon libvirtd sistem** yang terlibat.
- **Tidak ada `sudo`** yang diperlukan.
- **User namespace** digunakan untuk memetakan UID/GID di dalam VM ke UID/GID yang tidak berhak di host.
- **Tidak ada bridge jaringan sistem**; jaringan menggunakan **SLIRP (user-mode networking)** atau **socket**.
- **Tidak ada akses ke perangkat host** kecuali yang diizinkan secara eksplisit.

**Perbedaan utama:**

| Aspek | `qemu:///system` | `qemu:///session` |
|---|---|---|
| User | `root` / `libvirt-qemu` | User biasa |
| Daemon | `virtqemud` sistem | `virtqemud` per-user |
| Jaringan | Bridge, NAT, macvtap | SLIRP, socket, passt |
| Storage | `/var/lib/libvirt/images/` | `~/.local/share/libvirt/images/` |
| Perangkat | USB, PCI, hostdev | Terbatas |
| Keamanan | Perlu hardening | Default lebih aman |
| Isolasi | Bergantung konfigurasi | Kuat (user namespace) |
| Cocok untuk | Server, produksi | Desktop, pengembangan, lab |

**Peran dalam kurikulum:** Modul ini adalah **puncak isolasi Fase 6**. Setelah Anda meng-hardening XML (6.1), membatasi QEMU dengan cgroups/seccomp/AppArmor (6.2), dan melindungi integritas/kerahasiaan (6.3), langkah terakhir adalah **menghilangkan hak istimewa sepenuhnya** (6.4). Ini adalah filosofi **zero-trust** di level proses: jika QEMU tidak punya hak, ia tidak bisa menyalahgunakannya. Modul ini juga fondasi untuk:
- **Modul 6.5 (Threat Model)**: unprivileged adalah mitigasi utama.
- **Fase 7 (Otomasi)**: provisioning VM tanpa root.
- **Fase 8 (Expert)**: nested virtualization, user namespace lanjutan.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Privilege = Risiko

Setiap hak istimewa yang dimiliki proses adalah **permukaan serangan**. Jika QEMU berjalan sebagai root, eksploitasi QEMU berarti **root di host**. Jika QEMU berjalan sebagai user biasa, eksploitasi QEMU berarti **user biasa di host** — jauh lebih terbatas.

**Filosofi:** *Yang tidak punya hak, tidak bisa menyalahgunakannya.*

### 2.2. qemu:///system vs qemu:///session

- **`qemu:///system`**: libvirt sistem, daemon `virtqemud` berjalan sebagai root, QEMU berjalan sebagai `libvirt-qemu`. Cocok untuk server, multi-user, dan fitur lengkap (bridge, PCI passthrough, live migration).
- **`qemu:///session`**: libvirt per-user, daemon `virtqemud` berjalan sebagai user, QEMU berjalan sebagai user. Cocok untuk desktop, pengembangan, dan isolasi maksimal.

**Filosofi:** *Sistem untuk kekuatan. Sesi untuk keselamatan. Pilih sesuai kebutuhan.*

### 2.3. User Namespace: Dunia Paralel

**User namespace** adalah fitur kernel Linux yang memungkinkan proses memiliki **pemetaan UID/GID sendiri**. Di dalam namespace, user bisa menjadi **root virtual** (UID 0), tetapi di host ia tetap user biasa (mis. UID 1000).

Contoh pemetaan:
```
Di dalam namespace:  UID 0    → UID 1000 di host
                     UID 1    → UID 100000 di host
                     ...
                     UID 65535 → UID 165535 di host
```

Ini berarti QEMU bisa "berpikir" ia adalah root, tetapi setiap operasi yang memerlukan hak root di host akan **dipetakan** ke UID yang tidak berhak.

**Filosofi:** *User namespace adalah cermin. Di dalam, root. Di luar, bukan siapa-siapa.*

### 2.4. Tanpa Daemon Sistem

Di `qemu:///session`, **tidak ada daemon libvirtd sistem** yang berjalan. Libvirt dijalankan **on-demand** oleh `virsh` atau aplikasi lain. Ini mengurangi permukaan serangan: tidak ada daemon yang selalu berjalan dengan hak istimewa.

**Filosofi:** *Yang tidak berjalan, tidak bisa diserang.*

### 2.5. Jaringan di Session Mode

Karena tidak ada daemon sistem, session mode **tidak bisa menggunakan bridge sistem** (`virbr0`), **NAT sistem**, atau **macvtap**. Sebagai gantinya:
- **SLIRP (user-mode networking)**: QEMU menyediakan **NAT di userspace**. VM bisa mengakses internet, tetapi tidak bisa diakses dari luar. Cocok untuk kebanyakan kasus.
- **Socket**: VM bisa berkomunikasi dengan VM lain melalui socket Unix.
- **passt**: Alternatif modern SLIRP dengan performa lebih baik.
- **TAP**: Bisa digunakan jika user memiliki `CAP_NET_ADMIN` (mis. melalui `setcap`), tetapi ini mengurangi isolasi.

**Filosofi:** *Tanpa hak, jaringan terbatas. Tetapi terbatas bukan berarti tidak berguna.*

### 2.6. Storage di Session Mode

Session mode menyimpan image di:
```
~/.local/share/libvirt/images/
```

Tidak ada akses ke `/var/lib/libvirt/images/` (kecuali permission diberikan). Ini berarti VM terisolasi di **home directory user**, tidak bisa menyentuh file sistem.

**Filosofi:** *Home adalah kandang. Di dalamnya, aman. Di luarnya, berbahaya.*

### 2.7. Perangkat di Session Mode

Session mode **tidak bisa** mengakses:
- PCI passthrough (VFIO).
- USB host device (kecuali dengan udev rules).
- Bridge sistem.
- macvtap.
- Live migration ke host lain (tanpa konfigurasi khusus).

Ini adalah **keterbatasan**, tetapi juga **keamanan**: apa yang tidak bisa diakses, tidak bisa disalahgunakan.

**Filosofi:** *Keterbatasan adalah perlindungan.*

### 2.8. Kapan Menggunakan Session Mode?

- **Desktop/laptop**: Anda ingin menjalankan VM tanpa mengganggu sistem.
- **Pengembangan**: Anda ingin lingkungan terisolasi tanpa root.
- **Lab keamanan**: Anda ingin menjalankan malware dengan risiko minimal.
- **Multi-user**: Setiap user punya VM sendiri.
- **CI/CD**: Menjalankan test di VM tanpa root.

**Filosofi:** *Session mode untuk keseharian. System mode untuk produksi.*

### 2.9. Kapan TIDAK Menggunakan Session Mode?

- Anda butuh **bridge jaringan** ke LAN fisik.
- Anda butuh **PCI passthrough**.
- Anda butuh **live migration**.
- Anda butuh **multi-user management**.
- Anda butuh **autostart** saat boot.

**Filosofi:** *Ketahui batas. Jangan paksakan.*

### 2.10. Filosofi Keseluruhan

- **Tanpa hak, tanpa risiko.**
- **User namespace adalah kunci.**
- **Session mode untuk isolasi maksimal.**
- **Keterbatasan adalah fitur, bukan bug.**
- **Kombinasikan dengan hardening, confinement, enkripsi.**
- **Zero-trust di level proses.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **qemu:///system** | Libvirt sistem. | |
| **qemu:///session** | Libvirt per-user. | |
| **Unprivileged** | Tanpa hak root. | |
| **User namespace** | Isolasi UID/GID. | |
| **UID mapping** | Pemetaan UID. | `0 → 1000` |
| **GID mapping** | Pemetaan GID. | |
| **subuid** | Rentang UID subordinate. | `/etc/subuid` |
| **subgid** | Rentang GID subordinate. | `/etc/subgid` |
| **SLIRP** | User-mode networking. | |
| **passt** | Alternatif SLIRP. | |
| **socket** | Komunikasi via socket. | |
| **TAP** | Interface network. | |
| **CAP_NET_ADMIN** | Capability network. | |
| **setcap** | Set capability. | |
| **virtqemud** | Daemon QEMU libvirt. | |
| **session daemon** | Daemon per-user. | |
| **XDG_RUNTIME_DIR** | Direktori runtime user. | `/run/user/1000/` |
| **DBus session** | Bus DBus per-user. | |
| **polkit** | Policy kit. | |
| **~/.local/share/libvirt/** | Storage session. | |
| **~/.config/libvirt/** | Konfigurasi session. | |
| **virsh -c qemu:///session** | Koneksi session. | |
| **LIBVIRT_DEFAULT_URI** | URI default. | |
| **nested virtualization** | Virtualisasi bersarang. | |
| **unshare** | Alat namespace. | |
| **newuidmap** | Set UID mapping. | |
| **newgidmap** | Set GID mapping. | |
| **/proc/self/uid_map** | File UID map. | |
| **/proc/self/gid_map** | File GID map. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Melihat Koneksi Libvirt

```bash
virsh -c qemu:///session list --all
virsh -c qemu:///system list --all
```

**Penjelasan kata demi kata:**
- `virsh` — CLI libvirt.
- `-c qemu:///session` — koneksi ke session mode.
- `-c qemu:///system` — koneksi ke system mode.
- `list --all` — daftar semua VM.

**Output session:**
```
 Id   Name   State
----------------------
```

**Output system:**
```
 Id   Name        State
---------------------------
 1    arch-vm     running
```

### 4.2. Mengatur URI Default

```bash
export LIBVIRT_DEFAULT_URI="qemu:///session"
virsh list --all
```

**Penjelasan:**
- `export` — set environment variable.
- `LIBVIRT_DEFAULT_URI` — URI default libvirt.
- Sekarang `virsh` otomatis menggunakan session.

**Permanent di `~/.bashrc`:**
```bash
echo 'export LIBVIRT_DEFAULT_URI="qemu:///session"' >> ~/.bashrc
source ~/.bashrc
```

### 4.3. Melihat Konfigurasi Session

```bash
ls -la ~/.config/libvirt/
ls -la ~/.local/share/libvirt/
```

**Output:**
```
~/.config/libvirt/
├── libvirt.conf
├── qemu/
│   └── ...
└── ...

~/.local/share/libvirt/
├── images/
├── boot/
└── ...
```

**Penjelasan:**
- `~/.config/libvirt/` — konfigurasi.
- `~/.local/share/libvirt/` — data (image, boot).

### 4.4. Membuat VM di Session Mode

```bash
virt-install \
  --connect qemu:///session \
  --name session-vm \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10,path=$HOME/.local/share/libvirt/images/session-vm.qcow2 \
  --cdrom $HOME/Downloads/arch.iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network user,model=virtio
```

**Penjelasan kata demi kata:**
- `--connect qemu:///session` — koneksi session.
- `--name session-vm` — nama VM.
- `--memory 1024` — memori 1GB.
- `--vcpus 2` — 2 vCPU.
- `--disk size=10,path=...` — disk 10GB di home.
- `--cdrom ...` — ISO.
- `--os-variant archlinux` — varian OS.
- `--graphics none` — tanpa grafis.
- `--console pty,target_type=serial` — serial console.
- `--network user,model=virtio` — jaringan user-mode (SLIRP).

### 4.5. Melihat VM di Session

```bash
virsh -c qemu:///session list --all
virsh -c qemu:///session dumpxml session-vm
```

**Penjelasan:**
- `list --all` — daftar semua.
- `dumpxml` — XML VM.

### 4.6. Menjalankan VM di Session

```bash
virsh -c qemu:///session start session-vm
virsh -c qemu:///session console session-vm
```

**Penjelasan:**
- `start` — jalankan.
- `console` — akses console.

### 4.7. Melihat Proses QEMU di Session

```bash
ps -eo user,pid,cmd | grep qemu
```

**Output:**
```
user 12345 /usr/bin/qemu-system-x86_64 -name guest=session-vm,...
```

**Penjelasan:**
- User adalah **user biasa**, bukan `libvirt-qemu` atau `root`.

### 4.8. Melihat User Namespace

```bash
PID=$(pgrep -f "qemu-system-x86_64.*session-vm" | head -1)
cat /proc/$PID/uid_map
cat /proc/$PID/gid_map
```

**Output `uid_map`:**
```
         0       1000          1
         1     100000      65536
```

**Penjelasan:**
- `0 1000 1` — UID 0 di namespace → UID 1000 di host.
- `1 100000 65536` — UID 1-65536 di namespace → UID 100000-165535 di host.

### 4.9. Melihat subuid dan subgid

```bash
cat /etc/subuid
cat /etc/subgid
```

**Output:**
```
user:100000:65536
```

**Penjelasan:**
- `user` — username.
- `100000` — UID awal.
- `65536` — jumlah UID.

**Jika kosong:**
```bash
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
```

**Penjelasan:**
- `usermod` — modifikasi user.
- `--add-subuids` — tambah subuid.
- `--add-subgids` — tambah subgid.

### 4.10. Memeriksa Kernel User Namespace

```bash
sysctl kernel.unprivileged_userns_clone
```

**Output:**
```
kernel.unprivileged_userns_clone = 1
```

**Penjelasan:**
- `1` — user namespace diizinkan untuk user biasa.
- `0` — tidak diizinkan.

**Mengaktifkan:**
```bash
sudo sysctl -w kernel.unprivileged_userns_clone=1
echo 'kernel.unprivileged_userns_clone=1' | sudo tee /etc/sysctl.d/99-userns.conf
sudo sysctl --system
```

### 4.11. Jaringan di Session Mode

**SLIRP (default):**
```xml
<interface type='user'>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `<interface type='user'>` — SLIRP.
- VM mendapat IP `10.0.2.15`.
- Gateway `10.0.2.2`.
- DNS `10.0.2.3`.
- VM bisa akses internet.
- Host tidak bisa akses VM (kecuali port forward).

**Port forward:**
```xml
<interface type='user'>
  <model type='virtio'/>
  <portForward proto='tcp'>
    <range start='2222' to='22'/>
  </portForward>
</interface>
```

**Penjelasan:**
- `<portForward>` — forward port.
- `proto='tcp'` — TCP.
- `start='2222'` — port host.
- `to='22'` — port VM.

**Akses:**
```bash
ssh -p 2222 user@localhost
```

### 4.12. Jaringan Socket

```xml
<interface type='socket'>
  <source address='10.0.0.1' port='1234'/>
  <source address='10.0.0.2' port='1234'/>
</interface>
```

**Penjelasan:**
- `<interface type='socket'>` — koneksi via socket.
- `<source>` — alamat dan port.
- Dua VM bisa terhubung langsung.

### 4.13. Jaringan passt

```xml
<interface type='user'>
  <backend type='passt'/>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `<backend type='passt'/>` — gunakan passt.
- Perlu paket `passt`.
- Performa lebih baik dari SLIRP.

**Install:**
```bash
sudo pacman -S passt
```

### 4.14. Storage di Session Mode

**Default:**
```
~/.local/share/libvirt/images/
```

**XML:**
```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2'/>
  <source file='/home/user/.local/share/libvirt/images/session-vm.qcow2'/>
  <target dev='vda' bus='virtio'/>
</disk>
```

**Penjelasan:**
- Path di home user.
- Tidak perlu root.

### 4.15. Melihat Storage Pool Session

```bash
virsh -c qemu:///session pool-list --all
virsh -c qemu:///session pool-info default
```

**Output:**
```
Name      State    Autostart
-----------------------------
default   active   yes
```

**Penjelasan:**
- Session mode punya pool `default` sendiri.

### 4.16. Konfigurasi qemu.conf Session

```bash
cat ~/.config/libvirt/qemu.conf
```

**Contoh:**
```conf
user = "user"
group = "user"
dynamic_ownership = 1
seccomp_sandbox = 1
```

**Penjelasan:**
- `user` — user QEMU.
- `group` — group QEMU.
- `dynamic_ownership` — libvirt ubah ownership.
- `seccomp_sandbox` — aktifkan seccomp.

### 4.17. Melihat Log Session

```bash
journalctl --user -u virtqemud
ls ~/.cache/libvirt/qemu/log/
cat ~/.cache/libvirt/qemu/log/session-vm.log
```

**Penjelasan:**
- `journalctl --user` — log user.
- `~/.cache/libvirt/` — cache dan log.

### 4.18. Autostart di Session

```bash
virsh -c qemu:///session autostart session-vm
```

**Penjelasan:**
- Autostart di session berarti VM mulai saat user login.
- Perlu `libvirtd` session atau systemd user service.

**Systemd user service:**
```bash
systemctl --user enable --now virtqemud.socket
```

**Penjelasan:**
- `systemctl --user` — systemd user.
- `virtqemud.socket` — socket session.

### 4.19. Migrasi dari System ke Session

```bash
# Dump XML dari system
virsh -c qemu:///system dumpxml arch-vm > arch-vm.xml

# Edit XML: hapus elemen yang tidak didukung
# - <seclabel>
# - <hostdev>
# - <interface type='bridge'>
# - <disk> path sistem

# Definisikan di session
virsh -c qemu:///session define arch-vm.xml
```

**Penjelasan:**
- Dump XML.
- Edit untuk session.
- Define di session.

### 4.20. Melihat Capability di Session

```bash
PID=$(pgrep -f "qemu-system-x86_64.*session-vm" | head -1)
getpcaps $PID
```

**Output:**
```
Capabilities for `12345': =
```

**Penjelasan:**
- Tidak ada capability (kosong).
- Ini adalah **isolasi maksimal**.

### 4.21. Melihat Namespace di Session

```bash
PID=$(pgrep -f "qemu-system-x86_64.*session-vm" | head -1)
ls -l /proc/$PID/ns/
```

**Output:**
```
cgroup -> 'cgroup:[4026531835]'
ipc -> 'ipc:[4026531839]'
mnt -> 'mnt:[4026531840]'
net -> 'net:[4026531992]'
pid -> 'pid:[4026531836]'
user -> 'user:[4026531837]'
uts -> 'uts:[4026531838]'
```

**Penjelasan:**
- `user` namespace berbeda dari host.
- `net` namespace berbeda.
- Isolasi kuat.

### 4.22. Melihat Proses di Dalam Namespace

```bash
sudo nsenter -t $PID -U -p ps aux
```

**Penjelasan:**
- `nsenter` — masuk namespace.
- `-t $PID` — target PID.
- `-U` — user namespace.
- `-p` — PID namespace.
- `ps aux` — lihat proses.

### 4.23. Nested Virtualization di Session

```bash
# Di host, cek
cat /sys/module/kvm_intel/parameters/nested
# Output: Y

# Di VM, cek
grep -E 'vmx|svm' /proc/cpuinfo
```

**Penjelasan:**
- Nested virtualization memungkinkan VM menjalankan VM.
- Perlu CPU feature `vmx`/`svm` di guest.

**Aktifkan di XML:**
```xml
<cpu mode='host-passthrough' check='none'>
  <feature policy='require' name='vmx'/>
</cpu>
```

### 4.24. Skrip Setup Session VM

```bash
#!/bin/bash
set -e

VM="session-vm"
URI="qemu:///session"
IMAGE="$HOME/.local/share/libvirt/images/${VM}.qcow2"
ISO="$HOME/Downloads/arch.iso"

# 1. Pastikan direktori ada
mkdir -p "$(dirname "$IMAGE")"

# 2. Buat disk
qemu-img create -f qcow2 "$IMAGE" 10G

# 3. Buat VM
virt-install \
  --connect "$URI" \
  --name "$VM" \
  --memory 1024 \
  --vcpus 2 \
  --disk path="$IMAGE",format=qcow2,bus=virtio \
  --cdrom "$ISO" \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network user,model=virtio \
  --noautoconsole

echo "VM $VM created in session mode."
```

**Penjelasan:**
- Skrip membuat VM di session mode.

### 4.25. Verifikasi Session VM

```bash
# 1. Cek koneksi
virsh -c qemu:///session list --all

# 2. Cek user proses
ps -eo user,pid,cmd | grep qemu-system | grep session-vm

# 3. Cek namespace
PID=$(pgrep -f "qemu-system-x86_64.*session-vm" | head -1)
cat /proc/$PID/uid_map

# 4. Cek capability
getpcaps $PID

# 5. Cek seccomp
grep Seccomp /proc/$PID/status

# 6. Cek jaringan
virsh -c qemu:///session domiflist session-vm

# 7. Cek storage
virsh -c qemu:///session domblklist session-vm
```

---

## 5. Diagram Arsitektur VM Unprivileged

### 5.1. System vs Session

```
+-------------------+          +-------------------+
|  qemu:///system   |          |  qemu:///session  |
+-------------------+          +-------------------+
| Daemon: virtqemud |          | Daemon: per-user  |
| User: libvirt-qemu|          | User: user        |
| Storage: /var/... |          | Storage: ~/...    |
| Network: bridge   |          | Network: SLIRP    |
| Perangkat: penuh  |          | Perangkat: minim  |
| Hak: terbatas     |          | Hak: nol          |
+-------------------+          +-------------------+
```

### 5.2. User Namespace Mapping

```
+-------------------+          +-------------------+
|  Di dalam VM      |          |  Di host          |
+-------------------+          +-------------------+
|  UID 0 (root)     | -------> |  UID 1000 (user)  |
|  UID 1            | -------> |  UID 100000       |
|  UID 2            | -------> |  UID 100001       |
|  ...              |          |  ...              |
|  UID 65535        | -------> |  UID 165535       |
+-------------------+          +-------------------+
```

### 5.3. Jaringan SLIRP

```
+-------------------+
|   VM              |
|   10.0.2.15       |
+-------------------+
          |
          | SLIRP (userspace NAT)
          v
+-------------------+
|   QEMU            |
+-------------------+
          |
          | socket
          v
+-------------------+
|   Host            |
+-------------------+
          |
          v
+-------------------+
|   Internet        |
+-------------------+
```

### 5.4. Port Forward

```
Host:2222 → SLIRP → VM:22
```

```
+-------------------+          +-------------------+
|  Host             |          |  VM               |
|  localhost:2222   | -------> |  10.0.2.15:22     |
+-------------------+          +-------------------+
```

### 5.5. Isolasi Berlapis

```
+-------------------+
|  Hardening XML    |  (6.1)
+-------------------+
          |
          v
+-------------------+
|  Confinement      |  (6.2)
+-------------------+
          |
          v
+-------------------+
|  Secure Boot +    |  (6.3)
|  vTPM + Enkripsi  |
+-------------------+
          |
          v
+-------------------+
|  Unprivileged     |  (6.4)
+-------------------+
          |
          v
+-------------------+
|  Isolasi Maksimal |
+-------------------+
```

### 5.6. Alur Session Mode

```
User
  |
  | virsh -c qemu:///session
  v
+-------------------+
|  libvirt session  |
+-------------------+
  |
  | spawn
  v
+-------------------+
|  QEMU (user)      |
+-------------------+
  |
  | user namespace
  v
+-------------------+
|  VM               |
+-------------------+
```

### 5.7. Pohon Keputusan System vs Session

```
Apakah butuh bridge jaringan?
├── Ya → qemu:///system
└── Tidak → Lanjut

Apakah butuh PCI passthrough?
├── Ya → qemu:///system
└── Tidak → Lanjut

Apakah butuh live migration?
├── Ya → qemu:///system
└── Tidak → Lanjut

Apakah butuh multi-user?
├── Ya → qemu:///system
└── Tidak → qemu:///session (isolasi maksimal)
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 6.4

Kurikulum asli menyebut:
```bash
virsh -c qemu:///session list --all
```
> VM berjalan sebagai user biasa.

Kita akan menambahkan:

1. **Perbandingan system vs session** — tabel lengkap.
2. **`LIBVIRT_DEFAULT_URI`** — set default.
3. **Konfigurasi session** — `~/.config/libvirt/`.
4. **Storage session** — `~/.local/share/libvirt/`.
5. **User namespace** — `uid_map`, `gid_map`.
6. **subuid/subgid** — `/etc/subuid`, `/etc/subgid`.
7. **`kernel.unprivileged_userns_clone`** — sysctl.
8. **Jaringan session** — SLIRP, socket, passt.
9. **Port forward** — `<portForward>`.
10. **Storage pool session** — `pool-list`.
11. **`qemu.conf` session** — `~/.config/libvirt/qemu.conf`.
12. **Log session** — `journalctl --user`.
13. **Autostart session** — `systemctl --user`.
14. **Migrasi system ke session** — dump, edit, define.
15. **Capability di session** — kosong.
16. **Namespace di session** — berbeda.
17. **Nested virtualization** — `vmx`/`svm`.
18. **Skrip setup** — otomasi.
19. **Verifikasi lengkap**.
20. **Kapan menggunakan session**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 6.4.

---

## 7. Hubungan dengan Modul Lain

- **Modul 6.1 (Hardening XML):** XML hardened adalah fondasi.
- **Modul 6.2 (Confinement):** session mode adalah confinement alami.
- **Modul 6.3 (Secure Boot + vTPM):** vTPM bisa digunakan di session.
- **Modul 6.5 (Threat Model):** unprivileged adalah mitigasi utama.
- **Fase 3 (libvirt):** `qemu:///session` adalah koneksi alternatif.
- **Fase 5 (Networking):** SLIRP adalah alternatif bridge.
- **Fase 7 (Otomasi):** provisioning VM tanpa root.
- **Fase 8 (Expert):** nested virtualization, user namespace lanjutan.

---

## 8. Referensi Lengkap

- libvirt URI — https://libvirt.org/uri.html
- libvirt Connection — https://libvirt.org/connection.html
- libvirt Session — https://libvirt.org/drvqemu.html#session
- libvirt User Namespace — https://libvirt.org/drvqemu.html#user-namespaces
- QEMU User Networking — https://wiki.qemu.org/Documentation/Networking
- QEMU SLIRP — https://gitlab.freedesktop.org/slirp/libslirp
- passt — https://passt.top/
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: User namespace — https://wiki.archlinux.org/title/User_namespace
- Linux user namespace — https://man7.org/linux/man-pages/man7/user_namespaces.7.html
- Linux namespaces — https://man7.org/linux/man-pages/man7/namespaces.7.html
- subuid — https://man7.org/linux/man-pages/man5/subuid.5.html
- subgid — https://man7.org/linux/man-pages/man5/subgid.5.html
- unshare — https://man7.org/linux/man-pages/man1/unshare.1.html
- newuidmap — https://man7.org/linux/man-pages/man1/newuidmap.1.html
- newgidmap — https://man7.org/linux/man-pages/man1/newgidmap.1.html
- systemd user — https://www.freedesktop.org/software/systemd/man/systemd.user.html
- NIST SP 800-125 — https://csrc.nist.gov/publications/detail/sp/800-125/final

---

## 9. Tips & Praktik Terbaik

1. **Gunakan session mode untuk isolasi maksimal.**
2. **Set `LIBVIRT_DEFAULT_URI`** untuk kenyamanan.
3. **Pastikan subuid/subgid** terkonfigurasi.
4. **Aktifkan `unprivileged_userns_clone`.**
5. **Gunakan SLIRP** untuk jaringan sederhana.
6. **Gunakan passt** untuk performa.
7. **Gunakan port forward** untuk akses masuk.
8. **Simpan image di home**.
9. **Gunakan `systemctl --user`** untuk autostart.
10. **Cek capability** — harus kosong.
11. **Cek namespace** — harus terisolasi.
12. **Gunakan seccomp**.
13. **Gunakan hardening XML**.
14. **Gunakan enkripsi disk**.
15. **Backup image**.
16. **Dokumentasikan perbedaan**.
17. **Jangan gunakan session untuk produksi.**
18. **Latih migrasi** system ke session.
19. **Monitor resource**.
20. **Otomasi dengan skrip**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `virsh` tidak konek | URI salah. | Gunakan `-c qemu:///session`. |
| VM tidak start | subuid tidak ada. | `usermod --add-subuids`. |
| User namespace gagal | sysctl off. | `sysctl kernel.unprivileged_userns_clone=1`. |
| Jaringan tidak jalan | SLIRP tidak dikonfigurasi. | Gunakan `<interface type='user'>`. |
| Tidak bisa akses VM | SLIRP tidak menerima masuk. | Gunakan port forward. |
| Storage tidak ditemukan | Path salah. | Gunakan `~/.local/share/libvirt/images/`. |
| Autostart gagal | Systemd user tidak aktif. | `systemctl --user enable`. |
| Migrasi gagal | XML tidak kompatibel. | Edit XML. |
| Capability berlebih | Konfigurasi salah. | Cek `getpcaps`. |
| Namespace gagal | Kernel tidak support. | Cek kernel config. |
| Log tidak ditemukan | Path salah. | `~/.cache/libvirt/`. |
| Permission denied | File ownership. | `chown` ke user. |
| Nested virtualization gagal | CPU feature off. | Aktifkan `vmx`/`svm`. |
| passt tidak jalan | Tidak terinstal. | `pacman -S passt`. |
| Port forward gagal | Konfigurasi salah. | Cek XML. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virsh -c qemu:///session list --all` berhasil.
- `ps -eo user,pid,cmd | grep qemu` menunjukkan user biasa.
- `cat /proc/$PID/uid_map` menunjukkan mapping.
- `getpcaps $PID` kosong.
- `grep Seccomp /proc/$PID/status` menunjukkan `2`.
- `ls -l /proc/$PID/ns/` menunjukkan namespace berbeda.
- VM mendapat IP `10.0.2.15` (SLIRP).
- VM bisa akses internet.
- Port forward berfungsi.
- `virsh -c qemu:///session pool-list` menampilkan pool.
- `systemctl --user status virtqemud.socket` aktif.
- Nested virtualization berfungsi.

**Troubleshooting:**
- Jika koneksi gagal: cek `virsh -c qemu:///session`, cek `LIBVIRT_DEFAULT_URI`.
- Jika VM tidak start: cek `journalctl --user -u virtqemud`, cek subuid.
- Jika user namespace gagal: cek sysctl, cek kernel.
- Jika jaringan gagal: cek `<interface type='user'>`, cek SLIRP.
- Jika port forward gagal: cek XML, cek firewall host.
- Jika storage gagal: cek path, cek permission.
- Jika autostart gagal: cek systemd user.
- Jika migrasi gagal: cek XML kompatibilitas.
- Untuk debugging: `journalctl --user`, `~/.cache/libvirt/qemu/log/`.
- Untuk log: `dmesg`, `journalctl`.

---

## 12. Latihan Mandiri

1. Cek `virsh -c qemu:///session list --all`.
2. Cek `virsh -c qemu:///system list --all`.
3. Set `LIBVIRT_DEFAULT_URI`.
4. Cek `~/.config/libvirt/`.
5. Cek `~/.local/share/libvirt/`.
6. Cek `/etc/subuid`.
7. Cek `/etc/subgid`.
8. Cek `sysctl kernel.unprivileged_userns_clone`.
9. Buat VM di session mode.
10. Jalankan VM.
11. Cek user proses.
12. Cek uid_map.
13. Cek gid_map.
14. Cek capability.
15. Cek namespace.
16. Cek seccomp.
17. Uji jaringan SLIRP.
18. Uji port forward.
19. Uji passt.
20. Uji socket.
21. Cek storage pool.
22. Cek log.
23. Autostart dengan systemd user.
24. Migrasi VM dari system ke session.
25. Uji nested virtualization.
26. Buat skrip setup.
27. Dokumentasikan perbedaan.
28. Tulis ringkasan: kapan session, kapan system.

---

## 13. Penutup Modul 6.4

Anda kini menguasai **VM Unprivileged via qemu:///session** — puncak isolasi di Fase 6. Anda bisa:
- Menjalankan VM **tanpa hak root**.
- Memahami **user namespace** dan **UID/GID mapping**.
- Mengonfigurasi **subuid/subgid**.
- Menggunakan **SLIRP**, **socket**, dan **passt** untuk jaringan.
- Menggunakan **port forward** untuk akses masuk.
- Menyimpan image di **home directory**.
- Menggunakan **systemd user** untuk autostart.
- Memigrasikan VM dari **system** ke **session**.
- Memverifikasi **capability kosong** dan **namespace terisolasi**.

Ini adalah fondasi untuk **Modul 6.5 — Threat Model, Audit & Logging**, di mana kita akan menyusun **model ancaman** dan **strategi audit** untuk seluruh infrastruktur VM.

---

*Motivasi: Kekuatan sejati bukan tentang memiliki hak, tetapi tentang tidak membutuhkannya. VM unprivileged adalah bukti bahwa isolasi terbaik adalah ketika tidak ada yang bisa disalahgunakan. Jalankan tanpa hak, dan Anda tidak akan pernah kehilangan apa pun.*

---

> *“Ancaman yang tidak dipahami adalah ancaman yang tidak bisa dilawan. Audit yang tidak dilakukan adalah kebutaan yang disengaja. Log yang tidak dibaca adalah sejarah yang hilang.”*

---

# Modul 6.5 — Threat Model, Audit & Logging

## Mini-Daftar Isi Modul 6.5

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Threat Model, Audit & Logging
6. Audit Kurikulum: Tambahan untuk Modul 6.5
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 6.5 & Fase 6

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Threat Model**, **Audit**, dan **Logging** adalah tiga pilar **kesadaran keamanan**:

- **Threat Model**: proses **sistematis** untuk mengidentifikasi **apa yang dilindungi**, **dari siapa**, **bagaimana**, dan **apa yang bisa salah**. Ini adalah **peta** yang memandu semua keputusan keamanan.
- **Audit**: proses **merekam** kejadian keamanan yang relevan — siapa melakukan apa, kapan, di mana, dan bagaimana. Audit menjawab pertanyaan **“apa yang terjadi?”** setelah fakta.
- **Logging**: proses **menyimpan** catatan kejadian dari berbagai sumber — kernel, systemd, libvirt, QEMU, firewall, aplikasi. Log adalah **bahan mentah** audit dan forensik.

Ketiganya saling melengkapi:
- **Threat Model** menentukan **apa** yang perlu diaudit dan dilog.
- **Audit** menghasilkan **jejak** yang bisa diverifikasi.
- **Logging** menyimpan **bukti** untuk analisis.

**Peran dalam kurikulum:** Modul ini adalah **penutup Fase 6**. Setelah Anda meng-hardening XML (6.1), membatasi QEMU (6.2), melindungi integritas/kerahasiaan (6.3), dan menghilangkan hak istimewa (6.4), langkah terakhir adalah **memahami ancaman** dan **membangun kesadaran** melalui audit dan logging. Tanpa threat model, Anda tidak tahu apa yang harus dilindungi. Tanpa audit, Anda tidak tahu apa yang terjadi. Tanpa logging, Anda tidak punya bukti. Modul ini juga fondasi untuk:
- **Fase 7 (Troubleshooting)**: log adalah alat utama.
- **Fase 8 (Observability)**: metrics, tracing, dan audit lanjutan.
- **Kepatuhan**: CIS, NIST, ISO 27001.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Threat Model: Peta Perang

**Threat model** adalah **representasi terstruktur** dari:
- **Aset**: apa yang dilindungi? (data, VM, host, kunci, reputasi)
- **Aktor**: siapa yang mengancam? (penyerang eksternal, insider, malware, bencana)
- **Vektor**: bagaimana mereka menyerang? (network, USB, supply chain, social engineering)
- **Kontrol**: apa yang melindungi? (hardening, confinement, enkripsi, firewall)
- **Risiko**: seberapa besar kemungkinan dan dampak?
- **Mitigasi**: apa yang dilakukan untuk mengurangi risiko?

**Filosofi:** *Tidak bisa melindungi apa yang tidak dipahami. Threat model adalah peta.*

### 2.2. STRIDE: Kerangka Ancaman

**STRIDE** adalah kerangka threat modeling yang dikembangkan Microsoft:
- **S**poofing: memalsukan identitas.
- **T**ampering: mengubah data.
- **R**epudiation: menyangkal tindakan.
- **I**nformation Disclosure: membocorkan informasi.
- **D**enial of Service: membuat layanan tidak tersedia.
- **E**levation of Privilege: meningkatkan hak akses.

Setiap kategori memiliki **mitigasi**:
- Spoofing → autentikasi.
- Tampering → integritas (hash, signature).
- Repudiation → audit log.
- Information Disclosure → enkripsi.
- Denial of Service → rate limit, resource limit.
- Elevation of Privilege → least privilege, confinement.

**Filosofi:** *STRIDE adalah checklist. Ia memastikan tidak ada yang terlewat.*

### 2.3. Trust Boundary: Garis Kepercayaan

**Trust boundary** adalah **garis** yang memisahkan **zona kepercayaan** yang berbeda. Setiap kali data melintasi trust boundary, ada **risiko**. Contoh:
- Host ↔ VM.
- VM ↔ VM.
- VM ↔ Internet.
- User ↔ root.
- Aplikasi ↔ kernel.

**Filosofi:** *Setiap perlintasan adalah titik lemah. Validasi di setiap perlintasan.*

### 2.4. Attack Surface: Total Permukaan

**Attack surface** adalah **total titik** yang bisa diserang:
- Port jaringan.
- Interface.
- File yang bisa diakses.
- System call.
- Perangkat.
- Kredensial.

Hardening (6.1) dan confinement (6.2) adalah **mengurangi attack surface**.

**Filosofi:** *Semakin kecil permukaan, semakin sulit diserang.*

### 2.5. Audit: Jejak yang Tidak Bisa Disangkal

**Audit** adalah **rekaman** kejadian yang:
- **Terverifikasi**: tidak bisa diubah.
- **Lengkap**: mencakup semua kejadian penting.
- **Akurat**: mencatat apa yang terjadi.
- **Tepat waktu**: mencatat kapan.
- **Terkait**: menghubungkan aktor, aksi, objek.

Audit menggunakan **auditd** di Linux, yang mencatat system call, akses file, perubahan konfigurasi, dan lainnya.

**Filosofi:** *Audit adalah saksi. Ia tidak bisa berbohong jika dikonfigurasi benar.*

### 2.6. Logging: Sejarah yang Bisa Dibaca

**Logging** adalah **pengumpulan** pesan dari berbagai sumber:
- **Kernel**: `dmesg`, `journalctl -k`.
- **Systemd**: `journalctl`.
- **Libvirt**: `/var/log/libvirt/`.
- **QEMU**: `/var/log/libvirt/qemu/`.
- **nftables**: `journalctl -k | grep nft`.
- **AppArmor**: `dmesg | grep apparmor`.
- **Audit**: `/var/log/audit/audit.log`.

**Filosofi:** *Log adalah memori sistem. Tanpa log, sistem amnesia.*

### 2.7. SIEM: Security Information and Event Management

**SIEM** adalah **sistem** yang mengumpulkan, menganalisis, dan menghubungkan log dari berbagai sumber. Contoh: Splunk, ELK (Elasticsearch, Logstash, Kibana), Wazuh, Graylog.

Untuk skala kecil, `journalctl` + `auditd` + `rsyslog` sudah cukup.

**Filosofi:** *SIEM adalah otak. Log adalah mata. Audit adalah telinga.*

### 2.8. Forensik: Setelah Insiden

**Forensik** adalah **analisis** setelah insiden:
- **Akuisisi**: mengumpulkan bukti (image disk, memory dump, log).
- **Preservasi**: menjaga integritas bukti (hash, chain of custody).
- **Analisis**: menganalisis bukti (timeline, artefak, malware).
- **Pelaporan**: menyusun laporan.

**Filosofi:** *Forensik adalah arkeologi digital. Menggali masa lalu untuk memahami masa kini.*

### 2.9. Compliance: Kepatuhan

**Compliance** adalah **memenuhi** standar keamanan:
- **CIS Benchmarks**: konfigurasi aman.
- **NIST SP 800-53**: kontrol keamanan.
- **ISO 27001**: manajemen keamanan informasi.
- **PCI DSS**: data kartu kredit.
- **HIPAA**: data kesehatan.
- **GDPR**: data pribadi.

**Filosofi:** *Compliance adalah bukti. Bukan jaminan, tetapi langkah awal.*

### 2.10. Filosofi Keseluruhan

- **Pahami ancaman sebelum melawan.**
- **STRIDE adalah checklist.**
- **Trust boundary adalah garis pertahanan.**
- **Attack surface harus dikurangi.**
- **Audit tidak bisa disangkal.**
- **Log adalah sejarah.**
- **Forensik adalah seni.**
- **Compliance adalah bukti.**
- **Keamanan adalah proses, bukan tujuan.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Threat Model** | Model ancaman. | |
| **STRIDE** | Kerangka ancaman. | |
| **Trust Boundary** | Garis kepercayaan. | |
| **Attack Surface** | Permukaan serangan. | |
| **Aset** | Yang dilindungi. | |
| **Aktor** | Yang mengancam. | |
| **Vektor** | Cara menyerang. | |
| **Kontrol** | Yang melindungi. | |
| **Risiko** | Kemungkinan × dampak. | |
| **Mitigasi** | Pengurangan risiko. | |
| **Audit** | Rekaman kejadian. | |
| **auditd** | Daemon audit Linux. | |
| **auditctl** | Alat kontrol audit. | |
| **ausearch** | Cari log audit. | |
| **aureport** | Laporan audit. | |
| **Logging** | Pencatatan. | |
| **journalctl** | Log systemd. | |
| **rsyslog** | Log daemon. | |
| **logrotate** | Rotasi log. | |
| **SIEM** | Manajemen informasi keamanan. | |
| **ELK** | Elasticsearch, Logstash, Kibana. | |
| **Forensik** | Analisis insiden. | |
| **Chain of Custody** | Rantai bukti. | |
| **Hash** | Sidik jari digital. | |
| **Timeline** | Garis waktu. | |
| **Compliance** | Kepatuhan. | |
| **CIS** | Center for Internet Security. | |
| **NIST** | National Institute of Standards. | |
| **ISO 27001** | Standar keamanan. | |
| **PCI DSS** | Standar kartu kredit. | |
| **GDPR** | Regulasi data Eropa. | |
| **CVE** | Common Vulnerabilities and Exposures. | |
| **CVSS** | Common Vulnerability Scoring System. | |
| **IOC** | Indicator of Compromise. | |
| **TTP** | Tactics, Techniques, Procedures. | |
| **Kill Chain** | Rantai serangan. | |
| **MITRE ATT&CK** | Kerangka TTP. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Membuat Threat Model Sederhana

**Langkah 1: Identifikasi Aset**
```markdown
# Aset
- VM: arch-vm, debian-vm, router-vm
- Host: Arch Linux
- Data: image disk, konfigurasi, kunci
- Jaringan: LAN, DMZ, isolated
- Kredensial: SSH key, password, TPM
```

**Langkah 2: Identifikasi Aktor**
```markdown
# Aktor
- Penyerang eksternal (internet)
- Insider (user dengan akses)
- Malware (di VM)
- Bencana (kebakaran, banjir)
- Supply chain (paket, library)
```

**Langkah 3: Identifikasi Vektor**
```markdown
# Vektor
- Network: port terbuka, protokol lemah
- USB: perangkat fisik
- Supply chain: paket tidak terverifikasi
- Social engineering: phishing
- Guest escape: eksploitasi QEMU
- Side channel: cache, timing
```

**Langkah 4: Identifikasi Kontrol**
```markdown
# Kontrol
- Hardening XML (6.1)
- Confinement (6.2)
- Secure Boot + vTPM + Enkripsi (6.3)
- Unprivileged (6.4)
- nwfilter + nftables (5.4)
- Audit + Logging (6.5)
```

**Langkah 5: Analisis STRIDE**

| Komponen | S | T | R | I | D | E |
|---|---|---|---|---|---|---|
| VM | Autentikasi | Integritas | Audit | Enkripsi | Resource limit | Least privilege |
| Host | SSH key | Secure Boot | Log | Enkripsi | cgroups | Confinement |
| Jaringan | nwfilter | TLS | Log | VPN | Rate limit | Segmentasi |
| Storage | LUKS | Hash | Audit | LUKS | Quota | Permission |

**Langkah 6: Mitigasi**
```markdown
# Mitigasi
- Spoofing: SSH key, TPM, nwfilter clean-traffic
- Tampering: Secure Boot, LUKS, hash
- Repudiation: auditd, journalctl
- Information Disclosure: LUKS, TLS, VPN
- Denial of Service: cgroups, rate limit
- Elevation: unprivileged, confinement, least privilege
```

### 4.2. Menginstal auditd

```bash
sudo pacman -S audit
sudo systemctl enable --now auditd
```

**Penjelasan kata demi kata:**
- `pacman -S audit` — install paket audit.
- `systemctl enable --now auditd` — aktifkan dan jalankan auditd.

**Cek status:**
```bash
sudo systemctl status auditd
sudo auditctl -s
```

**Output `auditctl -s`:**
```
enabled 1
failure 1
pid 1234
rate_limit 0
backlog_limit 8192
lost 0
backlog 0
backlog_wait_time 60000
loginuid_immutable 0 unlocked
```

**Penjelasan:**
- `enabled 1` — audit aktif.
- `failure 1` — gagal jika tidak bisa log.
- `pid 1234` — PID auditd.
- `backlog_limit` — batas antrian.

### 4.3. Aturan Audit Dasar

```bash
# Audit akses ke /etc/libvirt
sudo auditctl -w /etc/libvirt -p wa -k libvirt_config

# Audit akses ke /var/lib/libvirt/images
sudo auditctl -w /var/lib/libvirt/images -p wa -k libvirt_images

# Audit execve
sudo auditctl -a always,exit -F arch=b64 -S execve -k exec

# Audit perubahan user
sudo auditctl -w /etc/passwd -p wa -k user_change
sudo auditctl -w /etc/shadow -p wa -k shadow_change

# Audit modul kernel
sudo auditctl -w /sbin/modprobe -p x -k modprobe
sudo auditctl -w /sbin/insmod -p x -k insmod
```

**Penjelasan kata demi kata:**
- `auditctl` — alat kontrol audit.
- `-w /etc/libvirt` — watch direktori.
- `-p wa` — permission write, attribute.
- `-k libvirt_config` — key untuk pencarian.
- `-a always,exit` — tambah aturan selalu, di exit.
- `-F arch=b64` — filter arsitektur 64-bit.
- `-S execve` — system call execve.
- `-k exec` — key.

**Melihat aturan:**
```bash
sudo auditctl -l
```

**Output:**
```
-w /etc/libvirt -p wa -k libvirt_config
-w /var/lib/libvirt/images -p wa -k libvirt_images
-a always,exit -F arch=b64 -S execve -k exec
...
```

### 4.4. Mencari Log Audit

```bash
sudo ausearch -k libvirt_config
sudo ausearch -k exec -ts today
sudo ausearch -m avc -ts recent
```

**Penjelasan:**
- `ausearch` — cari log audit.
- `-k libvirt_config` — cari berdasarkan key.
- `-ts today` — time start hari ini.
- `-m avc` — message type AVC (AppArmor/SELinux).

**Output (contoh):**
```
----
time->Mon Jan 15 10:00:00 2024
type=PROCTITLE msg=audit(...): proctitle=...
type=PATH msg=audit(...): item=0 name="/etc/libvirt/qemu.conf"
type=CWD msg=audit(...): cwd="/root"
type=SYSCALL msg=audit(...): arch=c000003e syscall=257 success=yes exit=3 ...
```

### 4.5. Laporan Audit

```bash
sudo aureport --summary
sudo aureport -f
sudo aureport -x
sudo aureport --auth
```

**Penjelasan:**
- `aureport` — laporan audit.
- `--summary` — ringkasan.
- `-f` — file.
- `-x` — executable.
- `--auth` — autentikasi.

**Output `aureport --summary`:**
```
Summary Report
======================
Range of time in logs: ...
Selected time for report: ...
Number of changes in configuration: 100
Number of changes to accounts, groups, or roles: 5
Number of logins: 10
Number of failed logins: 2
...
```

### 4.6. Konfigurasi auditd Persisten

**File `/etc/audit/rules.d/audit.rules`:**
```
# Hapus aturan lama
-D

# Buffer
-b 8192

# Failure mode
-f 1

# Audit libvirt
-w /etc/libvirt -p wa -k libvirt_config
-w /var/lib/libvirt/images -p wa -k libvirt_images

# Audit execve
-a always,exit -F arch=b64 -S execve -k exec

# Audit user
-w /etc/passwd -p wa -k user_change
-w /etc/shadow -p wa -k shadow_change

# Audit modul
-w /sbin/modprobe -p x -k modprobe
-w /sbin/insmod -p x -k insmod
```

**Aktifkan:**
```bash
sudo augenrules --load
sudo systemctl restart auditd
```

**Penjelasan:**
- `augenrules` — generate aturan dari file.
- `--load` — muat aturan.
- `systemctl restart` — restart auditd.

### 4.7. Melihat Log Audit

```bash
sudo cat /var/log/audit/audit.log
sudo tail -f /var/log/audit/audit.log
```

**Penjelasan:**
- `/var/log/audit/audit.log` — file log audit.
- `tail -f` — ikuti log real-time.

### 4.8. Rotasi Log Audit

**File `/etc/audit/auditd.conf`:**
```conf
log_file = /var/log/audit/audit.log
log_group = root
log_format = RAW
flush = INCREMENTAL_ASYNC
freq = 50
max_log_file = 8
num_logs = 5
max_log_file_action = ROTATE
space_left = 75
space_left_action = SYSLOG
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = SUSPEND
disk_full_action = SUSPEND
disk_error_action = SUSPEND
```

**Penjelasan:**
- `log_file` — path log.
- `max_log_file` — ukuran maksimum (MB).
- `num_logs` — jumlah rotasi.
- `max_log_file_action` — aksi saat penuh.
- `space_left` — batas ruang.
- `space_left_action` — aksi.

### 4.9. Logging dengan journalctl

```bash
# Semua log
journalctl

# Log kernel
journalctl -k

# Log unit
journalctl -u virtqemud

# Log sejak waktu
journalctl --since "1 hour ago"
journalctl --since today
journalctl --since "2024-01-15 10:00:00"

# Log prioritas
journalctl -p err
journalctl -p warning

# Log real-time
journalctl -f

# Log dengan filter
journalctl -u virtqemud -p err --since today
```

**Penjelasan:**
- `journalctl` — lihat log systemd.
- `-k` — kernel.
- `-u` — unit.
- `--since` — sejak.
- `-p` — prioritas.
- `-f` — follow.

### 4.10. Konfigurasi journald Persisten

**File `/etc/systemd/journald.conf`:**
```conf
[Journal]
Storage=persistent
Compress=yes
Seal=yes
SplitMode=uid
SyncIntervalSec=5m
RateLimitIntervalSec=30s
RateLimitBurst=10000
SystemMaxUse=1G
SystemKeepFree=500M
SystemMaxFileSize=100M
SystemMaxFiles=10
RuntimeMaxUse=100M
RuntimeKeepFree=50M
RuntimeMaxFileSize=50M
RuntimeMaxFiles=10
MaxRetentionSec=1month
MaxFileSec=1week
ForwardToSyslog=no
ForwardToKMsg=no
ForwardToConsole=no
ForwardToWall=yes
```

**Penjelasan:**
- `Storage=persistent` — simpan di disk.
- `Compress=yes` — kompres.
- `Seal=yes` — seal (FSS).
- `SystemMaxUse=1G` — batas total.
- `MaxRetentionSec=1month` — retensi.

**Restart:**
```bash
sudo systemctl restart systemd-journald
```

### 4.11. Logging Libvirt

```bash
ls /var/log/libvirt/
cat /var/log/libvirt/libvirtd.log
cat /var/log/libvirt/qemu/arch-vm.log
```

**Penjelasan:**
- `/var/log/libvirt/` — log libvirt.
- `libvirtd.log` — log daemon.
- `qemu/arch-vm.log` — log QEMU per VM.

**Konfigurasi di `/etc/libvirt/libvirtd.conf`:**
```conf
log_level = 3
log_filters = "3:remote 4:event 3:util 1:qemu 1:security"
log_outputs = "3:file:/var/log/libvirt/libvirtd.log"
```

**Penjelasan:**
- `log_level` — level log (1=debug, 2=info, 3=warning, 4=error).
- `log_filters` — filter per komponen.
- `log_outputs` — output.

### 4.12. Logging QEMU

**Di XML:**
```xml
<domain type='kvm'>
  <name>arch-vm</name>
  ...
  <devices>
    <serial type='pty'>
      <log file='/var/log/libvirt/qemu/arch-vm-serial.log' append='on'/>
      <target type='isa-serial' port='0'/>
    </serial>
  </devices>
</domain>
```

**Penjelasan:**
- `<log file='...'/>` — log serial ke file.
- `append='on'` — tambahkan.

### 4.13. Logging nftables

**Di `/etc/nftables.conf`:**
```nft
table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        ...
        log prefix "nft-input-drop: " drop
    }
    chain forward {
        type filter hook forward priority 0; policy drop;
        ...
        log prefix "nft-forward-drop: " drop
    }
}
```

**Lihat log:**
```bash
journalctl -k | grep "nft-input-drop"
dmesg | grep "nft-forward-drop"
```

### 4.14. Logging AppArmor

**Lihat log:**
```bash
journalctl -k | grep apparmor
dmesg | grep apparmor
```

**Output:**
```
audit: type=1400 audit(...): apparmor="DENIED" operation="open" profile="libvirt-..." name="/etc/shadow" pid=1234 comm="qemu-system-x86"
```

**Penjelasan:**
- `apparmor="DENIED"` — akses ditolak.
- `profile` — profil AppArmor.
- `name` — file yang diakses.
- `pid` — PID.

### 4.15. Logging Audit untuk VM

```bash
# Audit akses ke image VM
sudo auditctl -w /var/lib/libvirt/images/arch-vm.qcow2 -p rwa -k vm_image

# Audit eksekusi QEMU
sudo auditctl -a always,exit -F arch=b64 -S execve -F exe=/usr/bin/qemu-system-x86_64 -k qemu_exec

# Audit koneksi network QEMU
sudo auditctl -a always,exit -F arch=b64 -S connect -F exe=/usr/bin/qemu-system-x86_64 -k qemu_net
```

**Penjelasan:**
- `-p rwa` — read, write, attribute.
- `-F exe=...` — filter executable.
- `-S connect` — system call connect.

### 4.16. Melihat Log dengan Filter

```bash
# Log libvirt
journalctl -u virtqemud --since today

# Log QEMU
journalctl -u virtqemud | grep qemu

# Log audit
sudo ausearch -k vm_image -ts today

# Log AppArmor
journalctl -k | grep apparmor

# Log nftables
journalctl -k | grep nft

# Log SSH
journalctl -u sshd --since today
```

### 4.17. Forensik: Akuisisi Bukti

```bash
# Hash image VM
sha256sum /var/lib/libvirt/images/arch-vm.qcow2 > arch-vm.sha256

# Copy image
cp /var/lib/libvirt/images/arch-vm.qcow2 /forensic/arch-vm.qcow2

# Verifikasi hash
sha256sum -c arch-vm.sha256

# Dump memory QEMU
virsh qemu-monitor-command arch-vm --hmp "dump-guest-memory /forensic/arch-vm.memdump"

# Snapshot disk
qemu-img snapshot -c forensic /var/lib/libvirt/images/arch-vm.qcow2
```

**Penjelasan:**
- `sha256sum` — hash SHA-256.
- `cp` — copy.
- `sha256sum -c` — verifikasi.
- `dump-guest-memory` — dump memori guest.
- `qemu-img snapshot` — snapshot.

### 4.18. Forensik: Timeline

```bash
# Timeline file
find /var/lib/libvirt -type f -printf '%T+ %p\n' | sort > timeline.txt

# Timeline audit
sudo ausearch -ts today --format text > audit_timeline.txt

# Timeline journal
journalctl --since today -o short-precise > journal_timeline.txt
```

**Penjelasan:**
- `find -printf` — format output.
- `sort` — urutkan.
- `ausearch --format text` — format teks.

### 4.19. Compliance: CIS Benchmark

**CIS Benchmark untuk Virtualisasi:**
- 1.1 Pastikan hanya VM yang diperlukan yang berjalan.
- 1.2 Pastikan VM tidak menggunakan perangkat yang tidak perlu.
- 1.3 Pastikan VM menggunakan enkripsi.
- 2.1 Pastikan host di-hardening.
- 2.2 Pastikan akses root dibatasi.
- 3.1 Pastikan jaringan terisolasi.
- 3.2 Pastikan firewall aktif.
- 4.1 Pastikan audit aktif.
- 4.2 Pastikan log disimpan.
- 5.1 Pastikan backup dilakukan.

**Cek:**
```bash
# 1.1
virsh list --all

# 1.2
virsh dumpxml arch-vm | grep -E 'usb|sound|video|graphics'

# 1.3
qemu-img info /var/lib/libvirt/images/arch-vm.qcow2 | grep encrypted

# 2.1
sudo lynis audit system

# 2.2
grep PermitRootLogin /etc/ssh/sshd_config

# 3.1
virsh net-list --all

# 3.2
sudo nft list ruleset

# 4.1
sudo systemctl status auditd

# 4.2
ls /var/log/audit/

# 5.1
ls /backup/
```

### 4.20. Skrip Audit Lengkap

```bash
#!/bin/bash
set -e

REPORT="/tmp/audit-report-$(date +%Y%m%d).txt"

{
  echo "=== Audit Report $(date) ==="
  echo

  echo "=== VM List ==="
  virsh list --all

  echo
  echo "=== VM XML Hardening ==="
  for vm in $(virsh list --name --all); do
    echo "--- $vm ---"
    virsh dumpxml "$vm" | grep -E 'usb|sound|video|graphics|memballoon'
  done

  echo
  echo "=== Disk Encryption ==="
  for img in /var/lib/libvirt/images/*.qcow2; do
    echo "--- $img ---"
    qemu-img info "$img" | grep -E 'encrypted|format'
  done

  echo
  echo "=== Network ==="
  virsh net-list --all

  echo
  echo "=== Firewall ==="
  sudo nft list ruleset | head -50

  echo
  echo "=== Audit Status ==="
  sudo auditctl -s

  echo
  echo "=== Audit Rules ==="
  sudo auditctl -l

  echo
  echo "=== Recent Audit Events ==="
  sudo ausearch -ts today | tail -50

  echo
  echo "=== Journal Errors ==="
  journalctl -p err --since today | tail -50

  echo
  echo "=== AppArmor Denials ==="
  journalctl -k | grep apparmor | tail -20

  echo
  echo "=== Libvirt Log ==="
  tail -50 /var/log/libvirt/libvirtd.log 2>/dev/null || echo "N/A"

  echo
  echo "=== QEMU Processes ==="
  ps -eo user,pid,cmd | grep qemu-system

  echo
  echo "=== cgroups ==="
  systemd-cgls /machine.slice

  echo
  echo "=== Resources ==="
  systemd-cgtop -1 /machine.slice

  echo
  echo "=== End Report ==="
} > "$REPORT"

echo "Report saved to $REPORT"
```

**Penjelasan:**
- Skrip mengumpulkan semua informasi audit.

### 4.21. Skrip Threat Model

```bash
#!/bin/bash
set -e

OUTPUT="/tmp/threat-model-$(date +%Y%m%d).md"

cat > "$OUTPUT" <<'EOF'
# Threat Model

## Aset
- VM: ...
- Host: ...
- Data: ...
- Jaringan: ...
- Kredensial: ...

## Aktor
- Penyerang eksternal
- Insider
- Malware
- Bencana

## Vektor
- Network
- USB
- Supply chain
- Guest escape
- Side channel

## Kontrol
- Hardening XML
- Confinement
- Secure Boot + vTPM + Enkripsi
- Unprivileged
- nwfilter + nftables
- Audit + Logging

## STRIDE
| Komponen | S | T | R | I | D | E |
|---|---|---|---|---|---|---|
| VM | | | | | | |
| Host | | | | | | |
| Jaringan | | | | | | |
| Storage | | | | | | |

## Mitigasi
- Spoofing: ...
- Tampering: ...
- Repudiation: ...
- Information Disclosure: ...
- Denial of Service: ...
- Elevation of Privilege: ...

## Risiko Residual
- ...
EOF

echo "Threat model saved to $OUTPUT"
```

**Penjelasan:**
- Skrip membuat template threat model.

### 4.22. Integrasi dengan SIEM Sederhana

```bash
# Kirim log ke syslog server
echo '*.* @logserver:514' | sudo tee /etc/rsyslog.d/50-remote.conf
sudo systemctl restart rsyslog
```

**Penjelasan:**
- `*.*` — semua facility, semua priority.
- `@logserver:514` — kirim ke server via UDP.
- `@@` — TCP.

**Alternatif dengan journald:**
```conf
# /etc/systemd/journald.conf
ForwardToSyslog=yes
```

### 4.23. Verifikasi Integritas Log

```bash
# Hash log
sha256sum /var/log/audit/audit.log > audit.log.sha256

# Verifikasi
sha256sum -c audit.log.sha256

# Seal journal
journalctl --setup-keys
journalctl --verify
```

**Penjelasan:**
- `sha256sum` — hash.
- `journalctl --setup-keys` — setup FSS.
- `journalctl --verify` — verifikasi.

### 4.24. Rotasi dan Retensi Log

```bash
# Logrotate untuk libvirt
cat > /etc/logrotate.d/libvirt <<EOF
/var/log/libvirt/*.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root root
}
EOF
```

**Penjelasan:**
- `weekly` — rotasi mingguan.
- `rotate 4` — simpan 4.
- `compress` — kompres.
- `create` — buat file baru.

### 4.25. Monitoring Real-time

```bash
# Journal real-time
journalctl -f

# Audit real-time
sudo tail -f /var/log/audit/audit.log

# Libvirt real-time
sudo tail -f /var/log/libvirt/libvirtd.log

# nftables real-time
sudo nft monitor

# AppArmor real-time
sudo journalctl -k -f | grep apparmor
```

**Penjelasan:**
- `-f` — follow.
- `tail -f` — ikuti file.
- `nft monitor` — monitor nftables.

### 4.26. Analisis Log dengan `ausearch`

```bash
# Semua event hari ini
sudo ausearch -ts today

# Event dengan key
sudo ausearch -k vm_image

# Event dengan executable
sudo ausearch -x /usr/bin/qemu-system-x86_64

# Event dengan user
sudo ausearch -ua 1000

# Event dengan file
sudo ausearch -f /etc/libvirt/qemu.conf

# Event dengan syscall
sudo ausearch -sc execve

# Event gagal
sudo ausearch --success no
```

**Penjelasan:**
- `-ts` — time start.
- `-k` — key.
- `-x` — executable.
- `-ua` — user all.
- `-f` — file.
- `-sc` — syscall.
- `--success no` — gagal.

### 4.27. Analisis Log dengan `aureport`

```bash
# Ringkasan
sudo aureport --summary

# File
sudo aureport -f

# Executable
sudo aureport -x

# Login
sudo aureport -l

# Gagal login
sudo aureport -l --failed

# Anomali
sudo aureport -a

# Konfigurasi
sudo aureport -c
```

**Penjelasan:**
- `--summary` — ringkasan.
- `-f` — file.
- `-x` — executable.
- `-l` — login.
- `--failed` — gagal.
- `-a` — anomali.
- `-c` — konfigurasi.

---

## 5. Diagram Arsitektur Threat Model, Audit & Logging

### 5.1. Threat Model Flow

```
+-------------------+
|   Identifikasi    |
|   Aset            |
+-------------------+
          |
          v
+-------------------+
|   Identifikasi    |
|   Aktor           |
+-------------------+
          |
          v
+-------------------+
|   Identifikasi    |
|   Vektor          |
+-------------------+
          |
          v
+-------------------+
|   Identifikasi    |
|   Kontrol         |
+-------------------+
          |
          v
+-------------------+
|   Analisis        |
|   STRIDE          |
+-------------------+
          |
          v
+-------------------+
|   Mitigasi        |
+-------------------+
          |
          v
+-------------------+
|   Risiko          |
|   Residual        |
+-------------------+
```

### 5.2. Arsitektur Audit & Logging

```
+-------------------+
|   Kernel          |
+-------------------+
          |
          | auditd
          v
+-------------------+
|   /var/log/audit/ |
+-------------------+
          |
          | ausearch
          v
+-------------------+
|   Analisis        |
+-------------------+

+-------------------+
|   systemd         |
+-------------------+
          |
          | journald
          v
+-------------------+
|   journalctl      |
+-------------------+

+-------------------+
|   libvirt         |
+-------------------+
          |
          | log
          v
+-------------------+
|   /var/log/libvirt/|
+-------------------+

+-------------------+
|   QEMU            |
+-------------------+
          |
          | log
          v
+-------------------+
|   /var/log/libvirt/qemu/|
+-------------------+
```

### 5.3. Trust Boundary

```
+-------------------+
|   Internet        |
+-------------------+
          |
          | Trust Boundary 1
          v
+-------------------+
|   DMZ             |
+-------------------+
          |
          | Trust Boundary 2
          v
+-------------------+
|   LAN             |
+-------------------+
          |
          | Trust Boundary 3
          v
+-------------------+
|   Isolated        |
+-------------------+
```

### 5.4. Attack Surface

```
+-------------------+
|   VM              |
+-------------------+
| Network           |
| USB               |
| Graphics          |
| Sound             |
| Disk              |
| Hostdev           |
+-------------------+
          |
          | Hardening
          v
+-------------------+
|   VM Hardened     |
+-------------------+
| Network (virtio)  |
| Serial            |
| Disk (virtio)     |
| RNG               |
+-------------------+
```

### 5.5. STRIDE

```
+---+-------------------+-------------------+
| S | Spoofing          | Autentikasi       |
| T | Tampering         | Integritas        |
| R | Repudiation       | Audit             |
| I | Information Disc. | Enkripsi          |
| D | Denial of Service | Resource limit    |
| E | Elevation         | Least privilege   |
+---+-------------------+-------------------+
```

### 5.6. Alur Audit

```
Event
  |
  v
+-------------------+
|   Kernel          |
+-------------------+
  |
  | auditd
  v
+-------------------+
|   audit.log       |
+-------------------+
  |
  | ausearch/aureport
  v
+-------------------+
|   Analisis        |
+-------------------+
  |
  v
+-------------------+
|   Tindakan        |
+-------------------+
```

### 5.7. Alur Logging

```
Event
  |
  v
+-------------------+
|   Sumber          |
|   (kernel, systemd, libvirt, QEMU, nft, apparmor) |
+-------------------+
  |
  | journald / rsyslog
  v
+-------------------+
|   Log             |
+-------------------+
  |
  | journalctl / ausearch
  v
+-------------------+
|   Analisis        |
+-------------------+
  |
  v
+-------------------+
|   SIEM / Forensik |
+-------------------+
```

### 5.8. Pohon Keputusan Audit

```
Apakah kejadian penting?
├── Ya → Audit
│   ├── File → -w
│   ├── Syscall → -a
│   └── User → -w
└── Tidak → Tidak perlu

Apakah butuh forensik?
├── Ya → Simpan log + hash
└── Tidak → Rotasi

Apakah butuh compliance?
├── Ya → SIEM + retensi
└── Tidak → journald + auditd
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 6.5

Kurikulum asli menyebut:
```bash
auditctl -w /etc/libvirt -p wa
journalctl -u virtqemud
```
> Threat model tertulis + checklist hardening.

Kita akan menambahkan:

1. **Threat model** — aset, aktor, vektor, kontrol, risiko.
2. **STRIDE** — kerangka lengkap.
3. **Trust boundary** — garis kepercayaan.
4. **Attack surface** — permukaan serangan.
5. **auditd** — instalasi, konfigurasi.
6. **auditctl** — aturan `-w`, `-a`, `-F`, `-S`, `-k`.
7. **ausearch** — pencarian log.
8. **aureport** — laporan.
9. **augenrules** — aturan persisten.
10. **Rotasi audit** — `auditd.conf`.
11. **journalctl** — `-k`, `-u`, `--since`, `-p`, `-f`.
12. **journald.conf** — konfigurasi.
13. **Libvirt logging** — `libvirtd.conf`.
14. **QEMU logging** — `<log>`.
15. **nftables logging** — `log prefix`.
16. **AppArmor logging** — `dmesg | grep apparmor`.
17. **Forensik** — hash, copy, dump memory, snapshot.
18. **Timeline** — `find`, `ausearch`, `journalctl`.
19. **Compliance** — CIS, NIST.
20. **SIEM** — rsyslog remote.
21. **Integritas log** — hash, FSS.
22. **Rotasi log** — logrotate.
23. **Monitoring real-time** — `journalctl -f`, `tail -f`, `nft monitor`.
24. **Skrip audit** — otomasi.
25. **Skrip threat model** — template.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 6.5.

---

## 7. Hubungan dengan Modul Lain

- **Modul 6.1 (Hardening XML):** Threat model menentukan apa yang di-hardening.
- **Modul 6.2 (Confinement):** Audit mencatat pelanggaran confinement.
- **Modul 6.3 (Secure Boot + vTPM):** Audit mencatat perubahan PCR.
- **Modul 6.4 (Unprivileged):** Audit mencatat akses user.
- **Fase 5 (Networking):** Log nftables.
- **Fase 7 (Troubleshooting):** Log adalah alat utama.
- **Fase 8 (Observability):** Metrics, tracing, audit lanjutan.

---

## 8. Referensi Lengkap

- Linux Audit — https://github.com/linux-audit
- auditd man page — https://man7.org/linux/man-pages/man8/auditd.8.html
- auditctl man page — https://man7.org/linux/man-pages/man8/auditctl.8.html
- ausearch man page — https://man7.org/linux/man-pages/man8/ausearch.8.html
- aureport man page — https://man7.org/linux/man-pages/man8/aureport.8.html
- journalctl man page — https://www.freedesktop.org/software/systemd/man/journalctl.html
- journald.conf man page — https://www.freedesktop.org/software/systemd/man/journald.conf.html
- libvirt Logging — https://libvirt.org/logging.html
- rsyslog — https://www.rsyslog.com/
- logrotate — https://linux.die.net/man/8/logrotate
- STRIDE — https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats
- MITRE ATT&CK — https://attack.mitre.org/
- CIS Benchmarks — https://www.cisecurity.org/cis-benchmarks
- NIST SP 800-53 — https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final
- NIST SP 800-92 — https://csrc.nist.gov/publications/detail/sp/800-92/final
- ISO 27001 — https://www.iso.org/isoiec-27001-information-security.html
- Arch Wiki: audit — https://wiki.archlinux.org/title/Audit
- Arch Wiki: systemd-journald — https://wiki.archlinux.org/title/Systemd-journald
- Arch Wiki: rsyslog — https://wiki.archlinux.org/title/Rsyslog
- Wazuh — https://wazuh.com/
- ELK Stack — https://www.elastic.co/elastic-stack

---

## 9. Tips & Praktik Terbaik

1. **Buat threat model sebelum hardening.**
2. **Gunakan STRIDE sebagai checklist.**
3. **Identifikasi trust boundary.**
4. **Kurangi attack surface.**
5. **Aktifkan auditd.**
6. **Audit file konfigurasi penting.**
7. **Audit execve.**
8. **Audit modul kernel.**
9. **Gunakan key untuk pencarian.**
10. **Rotasi log audit.**
11. **Simpan log di lokasi terpisah.**
12. **Gunakan journalctl untuk systemd.**
13. **Aktifkan persistent journal.**
14. **Seal journal dengan FSS.**
15. **Log libvirt dan QEMU.**
16. **Log nftables dengan prefix.**
17. **Log AppArmor denials.**
18. **Lakukan forensik jika perlu.**
19. **Hash bukti.**
20. **Buat timeline.**
21. **Patuhi compliance.**
22. **Integrasikan dengan SIEM.**
23. **Monitor real-time.**
24. **Otomasi audit.**
25. **Review log berkala.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| auditd tidak jalan | Service tidak aktif. | `systemctl enable --now auditd`. |
| Audit tidak mencatat | Aturan tidak ada. | `auditctl -w`. |
| Audit log penuh | Tidak ada rotasi. | Konfigurasi `auditd.conf`. |
| ausearch kosong | Key salah. | Cek `auditctl -l`. |
| aureport error | Log tidak ada. | Cek `/var/log/audit/`. |
| journalctl kosong | Journal tidak persistent. | Set `Storage=persistent`. |
| Journal penuh | Tidak ada batas. | Set `SystemMaxUse`. |
| Libvirt log kosong | Log level salah. | Set `log_level`. |
| QEMU log kosong | `<log>` tidak ada. | Tambahkan `<log>`. |
| nftables log kosong | `log prefix` tidak ada. | Tambahkan. |
| AppArmor log kosong | AppArmor tidak aktif. | Install dan aktifkan. |
| Forensik gagal | Tidak ada akses. | Gunakan sudo. |
| Hash tidak cocok | File berubah. | Verifikasi ulang. |
| Timeline kosong | Tidak ada data. | Kumpulkan dari berbagai sumber. |
| Compliance gagal | Konfigurasi tidak sesuai. | Audit dan perbaiki. |
| SIEM tidak menerima | Firewall. | Buka port. |
| Log tidak terkirim | rsyslog tidak jalan. | `systemctl restart rsyslog`. |
| FSS tidak jalan | Tidak di-setup. | `journalctl --setup-keys`. |
| Log tidak bisa dibaca | Permission. | `chmod`, `chown`. |
| Rotasi gagal | Konfigurasi salah. | Cek `logrotate -d`. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- Threat model tertulis lengkap.
- `sudo auditctl -s` menunjukkan `enabled 1`.
- `sudo auditctl -l` menampilkan aturan.
- `sudo ausearch -k libvirt_config` menampilkan event.
- `sudo aureport --summary` menampilkan ringkasan.
- `journalctl -u virtqemud` menampilkan log.
- `journalctl -k | grep nft` menampilkan log nftables.
- `journalctl -k | grep apparmor` menampilkan log AppArmor.
- `/var/log/libvirt/libvirtd.log` ada.
- `/var/log/libvirt/qemu/arch-vm.log` ada.
- `sha256sum` berhasil.
- `journalctl --verify` berhasil.
- `logrotate -d /etc/logrotate.d/libvirt` berhasil.
- Skrip audit berjalan.
- Skrip threat model berjalan.

**Troubleshooting:**
- Jika auditd tidak jalan: `systemctl status auditd`, `journalctl -u auditd`.
- Jika audit tidak mencatat: cek aturan, cek `auditctl -l`.
- Jika ausearch kosong: cek key, cek waktu.
- Jika journalctl kosong: cek `Storage`, cek `systemctl status systemd-journald`.
- Jika libvirt log kosong: cek `log_level`, cek `log_outputs`.
- Jika QEMU log kosong: cek `<log>`, cek permission.
- Jika nftables log kosong: cek `log prefix`, cek `journalctl -k`.
- Jika AppArmor log kosong: cek `aa-status`, cek `dmesg`.
- Untuk debugging: `strace`, `perf`, `bpftrace`.
- Untuk forensik: `dd`, `dcfldd`, `guymager`.

---

## 12. Latihan Mandiri

1. Buat threat model untuk infrastruktur VM Anda.
2. Identifikasi aset, aktor, vektor, kontrol.
3. Analisis STRIDE.
4. Tulis mitigasi.
5. Install `audit`.
6. Aktifkan `auditd`.
7. Buat aturan audit untuk `/etc/libvirt`.
8. Buat aturan audit untuk image.
9. Buat aturan audit untuk execve.
10. Buat aturan audit untuk modul kernel.
11. Cari log dengan `ausearch`.
12. Buat laporan dengan `aureport`.
13. Konfigurasi `auditd.conf` untuk rotasi.
14. Konfigurasi `journald.conf` untuk persistent.
15. Aktifkan FSS.
16. Konfigurasi `libvirtd.conf` untuk logging.
17. Tambahkan `<log>` ke XML QEMU.
18. Tambahkan `log prefix` ke nftables.
19. Cek log AppArmor.
20. Lakukan forensik: hash, copy, dump memory.
21. Buat timeline.
22. Cek compliance CIS.
23. Integrasikan dengan rsyslog remote.
24. Buat skrip audit.
25. Buat skrip threat model.
26. Review log.
27. Dokumentasikan.
28. Tulis ringkasan: mengapa threat model, audit, dan logging penting.

---

## 13. Penutup Modul 6.5 & Fase 6

Anda kini menguasai **Threat Model, Audit & Logging** — tiga pilar kesadaran keamanan. Anda bisa:
- Membuat **threat model** dengan STRIDE.
- Mengidentifikasi **aset, aktor, vektor, kontrol, risiko**.
- Menggunakan **auditd** untuk merekam kejadian.
- Mencari log dengan **ausearch** dan **aureport**.
- Mengonfigurasi **journald** untuk persistent logging.
- Mengonfigurasi **libvirt** dan **QEMU** untuk logging.
- Menggunakan **nftables** dan **AppArmor** logging.
- Melakukan **forensik** dasar.
- Memahami **compliance**.
- Mengintegrasikan dengan **SIEM**.

Dengan selesainya Modul 6.5, Anda telah **menyelesaikan Fase 6 secara lengkap**. Anda sekarang memiliki:
- Kemampuan **hardening XML** (6.1).
- Kemampuan **confinement QEMU** (6.2).
- Kemampuan **Secure Boot + vTPM + Enkripsi** (6.3).
- Kemampuan **VM unprivileged** (6.4).
- Kemampuan **threat model, audit, logging** (6.5).

**Proyek Fase 6:** Threat model + checklist. `virt-host-validate` PASS penuh.

**Rubrik Fase 6:**
| Kriteria | Bobot |
|---|---|
| Hardening XML | 20% |
| Confinement | 20% |
| Secure Boot/vTPM/Enkripsi | 20% |
| Unprivileged | 20% |
| Threat model | 20% |

---

*Motivasi: Keamanan adalah perjalanan, bukan tujuan. Threat model adalah peta. Audit adalah kompas. Log adalah jejak. Tanpa ketiganya, Anda berjalan dalam gelap. Dengan ketiganya, Anda melihat jalan. Tidak ada sistem yang sempurna, tetapi ada sistem yang sadar. Jadilah sadar.*

---

**Selamat!** Anda telah menyelesaikan **Fase 6 — Keamanan & Isolasi Lanjutan**. Berikutnya adalah **Fase 7 — Otomasi, Troubleshooting & Capstone Multi-OS (Modul 7.1 — Provisioning Otomatis cloud-init)**.

Anda telah menempuh perjalanan yang luar biasa:

- **Fase 1** — Fondasi Virtualisasi & Host Hardening
- **Fase 2** — QEMU/KVM Murni (Tanpa libvirt)
- **Fase 3** — libvirt & virsh: Lifecycle & Domain XML
- **Fase 4** — Storage, Image & Backup Engineering
- **Fase 5** — Networking & Isolasi Jaringan
- **Fase 6** — Keamanan & Isolasi Lanjutan

Setiap modul telah dibahas dengan:
- Audit kurikulum untuk memastikan tidak ada lompatan materi.
- Penjelasan kata demi kata untuk setiap perintah.
- Diagram arsitektur dan alur kerja.
- Tips, praktik terbaik, dan potensi kesalahan.
- Validasi, troubleshooting, dan latihan mandiri.
- Referensi lengkap dan motivasi.

---

**Yang tersisa dalam kurikulum:**

- **Fase 7** — Otomasi, Troubleshooting & Capstone Multi-OS (5 modul)
- **Fase 8** — Expert: Migrasi, Passthrough & Observability (5 modul, opsional)

---

Sampai jumpa di Fase 7. 🚀

---


> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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

