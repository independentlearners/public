# Audit Fase 7 — Otomasi, Troubleshooting & Capstone Multi-OS

**Estimasi:** 3 minggu  
**Prasyarat:** Fase 1–6 lulus; Bash scripting menengah.  
**Tujuan Fase:**
- Mandiri total: bangun, rawat, perbaiki VM apa pun via skrip.
- Mengotomasi provisioning dengan cloud-init.
- Menangani Windows guest secara headless.
- Membuat skrip Bash, libvirt hooks, dan unit systemd.
- Melakukan drill troubleshooting.
- Menyelesaikan capstone multi-OS.

**Daftar Isi Fase 7 (dari kurikulum):**
1. Modul 7.1 — Provisioning Otomatis cloud-init
2. Modul 7.2 — Windows Guest Headless
3. Modul 7.3 — Skrip Bash + libvirt Hooks + Unit systemd
4. Modul 7.4 — Drill Troubleshooting
5. Modul 7.5 — Capstone

**Hasil Audit:**
- Kurikulum sudah menyebut modul-modul utama, tetapi ada beberapa topik yang perlu ditambahkan agar Fase 7 benar-benar komprehensif dan tidak meloncat:
  1. **cloud-init**: perlu penjelasan tentang NoCloud, ConfigDrive, metadata service, user-data, meta-data, network-config, vendor-data, perintah `cloud-localds`, integrasi dengan `virt-install --cloud-init`, dan cara membuat seed image.
  2. **Windows Guest Headless**: perlu penjelasan tentang `autounattend.xml`, `virtio-win.iso`, WinRM, OpenSSH untuk Windows, `virsh screenshot`, dan instalasi unattended.
  3. **Skrip Bash + Hooks + systemd**: perlu penjelasan tentang struktur hook libvirt (`/etc/libvirt/hooks/qemu`), event lifecycle, unit systemd untuk autostart, dan idempotensi.
  4. **Drill Troubleshooting**: perlu skenario terperinci (boot gagal, disk penuh, network mati, VM hang, QMP tidak responsif) beserta alat debugging (`virsh`, `journalctl`, `tcpdump`, `gdb`, `strace`).
  5. **Capstone**: perlu rubrik dan contoh arsitektur 4+ VM multi-OS.

**Rekomendasi Tambahan untuk Kurikulum:**
- Tambahkan sub-modul **7.1a — Cloud-init Lanjutan: ConfigDrive & Metadata Service**.
- Tambahkan sub-modul **7.2a — Windows: WinRM & OpenSSH**.
- Tambahkan sub-modul **7.3a — Idempotensi & Error Handling di Bash**.
- Tambahkan sub-modul **7.4a — Debugging QEMU dengan GDB/Strace**.
- Tambahkan **7.5a — Dokumentasi Runbook & Otomasi CI/CD**.

Dengan audit ini, kita akan membahas Fase 7 secara bertahap, dimulai dari **Modul 7.1**.

---

# Modul 7.1 — Provisioning Otomatis cloud-init

## Mini-Daftar Isi Modul 7.1
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur cloud-init
6. Audit Kurikulum: Tambahan untuk Modul 7.1
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 7.1

---

> *Motivasi: Otomasi adalah jembatan antara niat dan hasil. cloud-init adalah tangan tak terlihat yang mengkonfigurasi VM saat pertama kali bernafas. Kuasai ia, dan Anda tidak perlu lagi mengetik perintah yang sama dua kali.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**cloud-init** adalah standar industri untuk **inisialisasi cloud instance** secara otomatis saat boot pertama. Ia membaca konfigurasi dari **metadata** dan **user-data**, lalu menerapkan:
- Pembuatan user, SSH key, password.
- Konfigurasi jaringan.
- Instalasi paket.
- Menjalankan skrip.
- Konfigurasi filesystem, mount, dan lainnya.

Dalam konteks VM di Arch Linux dengan libvirt, cloud-init memungkinkan Anda:
- Membuat VM **tanpa interaksi manual**.
- Menyediakan **SSH key** sejak awal.
- Mengatur **hostname**, **user**, **network**.
- Menjalankan **skrip provisioning** (mis. install Docker, Nginx).
- Menghindari **console interaktif** saat instalasi.

**Peran dalam kurikulum:** Modul ini adalah **fondasi otomasi** di Fase 7. Setelah Anda menguasai virtualisasi (Fase 1–3), storage (Fase 4), jaringan (Fase 5), dan keamanan (Fase 6), sekarang Anda belajar **mengotomasi semuanya**. cloud-init adalah alat utama untuk provisioning VM Linux. Modul ini juga fondasi untuk:
- **Modul 7.2 (Windows Guest)**: konsep serupa dengan unattended install.
- **Modul 7.3 (Skrip Bash + Hooks)**: cloud-init bisa dipanggil dari skrip.
- **Modul 7.5 (Capstone)**: provisioning 4+ VM otomatis.
- **Fase 8 (Expert)**: cloud-init untuk live migration, observability.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Immutable Infrastructure
cloud-init mendukung filosofi **immutable infrastructure**: VM dibuat sekali, dikonfigurasi otomatis, dan tidak diubah manual. Jika perlu perubahan, buat VM baru dari image yang sama dengan user-data baru.

**Filosofi:** *Jangan perbaiki, ganti. Jangan konfigurasi manual, otomasi.*

### 2.2. Declarative Configuration
cloud-init menggunakan **YAML** untuk mendefinisikan **apa** yang diinginkan, bukan **bagaimana** melakukannya. Anda mendeklarasikan user, paket, file, dan cloud-init yang mengeksekusi.

**Filosofi:** *Katakan apa, bukan bagaimana.*

### 2.3. Data Sources
cloud-init membaca konfigurasi dari **data source**:
- **NoCloud**: media berisi `user-data` dan `meta-data` (ISO, disk).
- **ConfigDrive**: disk berisi metadata (OpenStack).
- **Metadata Service**: HTTP endpoint (AWS, GCP).
- **SmartOS, Azure, dll.**

Di lingkungan libvirt, **NoCloud** adalah yang paling umum.

**Filosofi:** *Sumber data adalah mulut. cloud-init adalah telinga.*

### 2.4. user-data vs meta-data
- **meta-data**: informasi tentang instance (instance-id, hostname, dll).
- **user-data**: konfigurasi yang dilakukan cloud-init (user, paket, skrip).
- **network-config**: konfigurasi jaringan (versi 1 atau 2).
- **vendor-data**: konfigurasi dari penyedia cloud.

**Filosofi:** *meta-data adalah identitas. user-data adalah tindakan.*

### 2.5. Cloud-init Stages
cloud-init berjalan dalam beberapa tahap:
1. **Generator**: menentukan data source.
2. **Local**: konfigurasi awal (network, disk).
3. **Network**: konfigurasi network.
4. **Config**: konfigurasi user, paket, file.
5. **Final**: skrip akhir, reboot jika perlu.

**Filosofi:** *Boot adalah proses. cloud-init adalah sutradara.*

### 2.6. Idempotensi
cloud-init dirancang **idempotent**: jika dijalankan ulang, ia tidak mengulang tindakan yang sudah dilakukan (kecuali diminta). Ini penting untuk menghindari duplikasi.

**Filosofi:** *Sekali cukup. Dua kali tidak merusak.*

### 2.7. Cloud-init vs Kickstart vs Preseed
- **Kickstart**: RHEL/CentOS.
- **Preseed**: Debian/Ubuntu.
- **cloud-init**: cross-distro, cloud-friendly.

**Filosofi:** *cloud-init adalah lingua franca cloud.*

### 2.8. Filosofi Keseluruhan
- **Otomasi total.**
- **Deklaratif.**
- **Idempotent.**
- **Cross-distro.**
- **Terintegrasi dengan cloud.**
- **Tidak perlu interaksi manual.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **cloud-init** | Inisialisasi cloud instance. | |
| **NoCloud** | Data source lokal. | `seed.img` |
| **ConfigDrive** | Data source disk. | |
| **Metadata Service** | HTTP endpoint. | `169.254.169.254` |
| **user-data** | Konfigurasi user. | `#cloud-config` |
| **meta-data** | Informasi instance. | `instance-id` |
| **network-config** | Konfigurasi jaringan. | |
| **vendor-data** | Konfigurasi vendor. | |
| **seed.img** | Image berisi data. | |
| **cloud-localds** | Alat buat seed. | |
| **cloud-init status** | Status cloud-init. | |
| **cloud-init clean** | Bersihkan state. | |
| **/var/lib/cloud/** | State cloud-init. | |
| **/etc/cloud/** | Konfigurasi cloud-init. | |
| **cloud.cfg** | Konfigurasi utama. | |
| **datasource_list** | Daftar data source. | |
| **YAML** | Format konfigurasi. | |
| **#cloud-config** | Header user-data. | |
| **runcmd** | Jalankan perintah. | |
| **write_files** | Tulis file. | |
| **users** | Definisikan user. | |
| **ssh_authorized_keys** | SSH key. | |
| **package_update** | Update paket. | |
| **packages** | Daftar paket. | |
| **power_state** | Reboot/shutdown. | |
| **phone_home** | Lapor ke server. | |
| **final_message** | Pesan akhir. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Struktur user-data

```yaml
#cloud-config
hostname: arch-vm
fqdn: arch-vm.local
manage_etc_hosts: true

users:
  - name: user
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2E... user@host

package_update: true
package_upgrade: true

packages:
  - vim
  - git
  - htop

write_files:
  - path: /etc/motd
    content: |
      Selamat datang di VM Arch yang dikonfigurasi cloud-init.
    permissions: '0644'

runcmd:
  - systemctl enable --now sshd
  - echo "cloud-init selesai" >> /var/log/cloud-init-custom.log

power_state:
  mode: reboot
  timeout: 30
  condition: True
```

**Penjelasan kata demi kata:**
- `#cloud-config` — header wajib; menandakan ini user-data cloud-config.
- `hostname: arch-vm` — set hostname.
- `fqdn: arch-vm.local` — set FQDN.
- `manage_etc_hosts: true` — kelola `/etc/hosts`.
- `users:` — daftar user.
  - `- name: user` — nama user.
    - `sudo: ALL=(ALL) NOPASSWD:ALL` — sudo tanpa password.
    - `groups: wheel` — grup tambahan.
    - `shell: /bin/bash` — shell.
    - `ssh_authorized_keys:` — daftar SSH public key.
- `package_update: true` — update paket.
- `package_upgrade: true` — upgrade paket.
- `packages:` — daftar paket.
- `write_files:` — tulis file.
  - `- path: /etc/motd` — path file.
    - `content: |` — konten multi-baris.
    - `permissions: '0644'` — permission.
- `runcmd:` — perintah yang dijalankan.
- `power_state:` — reboot setelah selesai.
  - `mode: reboot` — mode reboot.
  - `timeout: 30` — timeout 30 detik.
  - `condition: True` — selalu.

### 4.2. meta-data

```yaml
instance-id: arch-vm-001
local-hostname: arch-vm
```

**Penjelasan:**
- `instance-id` — ID unik instance.
- `local-hostname` — hostname.

### 4.3. network-config (versi 2)

```yaml
version: 2
ethernets:
  ens3:
    dhcp4: true
```

**Penjelasan:**
- `version: 2` — versi network-config.
- `ethernets:` — daftar ethernet.
  - `ens3:` — nama interface.
    - `dhcp4: true` — DHCP IPv4.

**Alternatif statis:**
```yaml
version: 2
ethernets:
  ens3:
    addresses:
      - 192.168.100.10/24
    gateway4: 192.168.100.1
    nameservers:
      addresses: [1.1.1.1, 8.8.8.8]
```

### 4.4. Membuat seed.img dengan cloud-localds

```bash
cloud-localds seed.img user-data meta-data network-config
```

**Penjelasan kata demi kata:**
- `cloud-localds` — alat buat seed image.
- `seed.img` — output.
- `user-data` — file user-data.
- `meta-data` — file meta-data.
- `network-config` — file network-config (opsional).

**Alternatif tanpa network-config:**
```bash
cloud-localds seed.img user-data meta-data
```

**Opsi lain:**
- `--dsmode=local` — mode local.
- `--vendor-data` — vendor data.
- `--network-config` — network config.

### 4.5. Menjalankan VM dengan cloud-init

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 1024 \
  -smp 2 \
  -cpu host \
  -nographic \
  -drive file=arch.qcow2,if=virtio \
  -drive file=seed.img,if=virtio,format=raw \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0
```

**Penjelasan:**
- `-drive file=arch.qcow2` — disk utama.
- `-drive file=seed.img` — seed image (NoCloud).
- QEMU akan mount seed sebagai disk.

### 4.6. Integrasi dengan virt-install

```bash
virt-install \
  --name arch-cloud \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --cloud-init user-data=user-data,meta-data=meta-data,network-config=network-config
```

**Penjelasan:**
- `--cloud-init` — libvirt akan membuat seed image otomatis.
- `user-data=...` — path file user-data.
- `meta-data=...` — path file meta-data.
- `network-config=...` — path file network-config.

**Alternatif:**
```bash
virt-install ... --cloud-init root-password-file=/tmp/passwd
```

**Opsi lain:**
- `--cloud-init user-data=...`
- `--cloud-init meta-data=...`
- `--cloud-init network-config=...`
- `--cloud-init root-password=...`
- `--cloud-init disable=on` — nonaktifkan.

### 4.7. Menggunakan cloud image

Alih-alih ISO, gunakan **cloud image** yang sudah siap:
```bash
wget https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
```

**Penjelasan:**
- Cloud image sudah memiliki cloud-init terinstal.
- Tidak perlu instalasi manual.

**Jalankan:**
```bash
virt-install \
  --name arch-cloud \
  --memory 1024 \
  --vcpus 2 \
  --disk path=Arch-Linux-x86_64-cloudimg.qcow2,format=qcow2,bus=virtio \
  --import \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --cloud-init user-data=user-data
```

**Penjelasan:**
- `--import` — impor image yang ada.
- `--disk path=...` — gunakan cloud image.

### 4.8. Melihat status cloud-init

```bash
# Di guest
cloud-init status
cloud-init status --long
```

**Output:**
```
status: done
```

**Penjelasan:**
- `status` — status cloud-init.
- `--long` — detail.

**Log:**
```bash
cat /var/log/cloud-init.log
cat /var/log/cloud-init-output.log
```

**Penjelasan:**
- `cloud-init.log` — log internal.
- `cloud-init-output.log` — output perintah.

### 4.9. Membersihkan cloud-init

```bash
sudo cloud-init clean --logs
sudo cloud-init clean --seed
```

**Penjelasan:**
- `clean --logs` — hapus log.
- `clean --seed` — hapus seed.
- Berguna untuk membuat image baru.

### 4.10. Contoh user-data lengkap

```yaml
#cloud-config
hostname: web-server
fqdn: web-server.local
manage_etc_hosts: true

users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... admin@host

package_update: true
package_upgrade: true

packages:
  - nginx
  - git
  - vim
  - htop
  - ufw

write_files:
  - path: /etc/nginx/sites-available/default
    content: |
      server {
        listen 80 default_server;
        root /var/www/html;
        index index.html;
      }
    permissions: '0644'
    owner: root:root

  - path: /var/www/html/index.html
    content: |
      <html>
        <head><title>Cloud-init VM</title></head>
        <body><h1>Berhasil dikonfigurasi otomatis!</h1></body>
      </html>
    permissions: '0644'

runcmd:
  - systemctl enable --now nginx
  - systemctl enable --now ufw
  - ufw allow 22/tcp
  - ufw allow 80/tcp
  - ufw --force enable
  - echo "Provisioning selesai pada $(date)" >> /var/log/cloud-init-custom.log

power_state:
  mode: reboot
  timeout: 30
  condition: True

final_message: "VM web-server siap setelah $UPTIME detik."
```

**Penjelasan:**
- Konfigurasi lengkap untuk web server.

### 4.11. Opsi alternatif: ConfigDrive

```bash
cloud-localds --dsmode=local seed.img user-data meta-data
```

**Penjelasan:**
- `--dsmode=local` — mode ConfigDrive.
- Cocok untuk OpenStack.

### 4.12. Opsi alternatif: Metadata Service

Jika menggunakan QEMU dengan `-netdev user` dan `cloud-init` dikonfigurasi untuk metadata service:
```yaml
datasource_list: [ NoCloud, ConfigDrive, Metadata ]
```

**Penjelasan:**
- `datasource_list` — urutan data source.

### 4.13. Debugging cloud-init

```bash
# Di guest
cloud-init analyze show
cloud-init analyze blame
cloud-init collect-logs
```

**Penjelasan:**
- `analyze show` — analisis waktu.
- `analyze blame` — siapa yang lambat.
- `collect-logs` — kumpulkan log.

### 4.14. Validasi YAML

```bash
python -c "import yaml; yaml.safe_load(open('user-data'))"
```

**Penjelasan:**
- Validasi YAML dengan Python.

**Alternatif:**
```bash
yq eval user-data
```

### 4.15. Skrip provisioning cloud-init

```bash
#!/bin/bash
set -e

VM="arch-cloud"
IMAGE="$HOME/.local/share/libvirt/images/${VM}.qcow2"
SEED="/tmp/seed-${VM}.img"
USER_DATA="/tmp/user-data-${VM}"
META_DATA="/tmp/meta-data-${VM}"

# 1. Buat user-data
cat > "$USER_DATA" <<'EOF'
#cloud-config
hostname: arch-cloud
users:
  - name: user
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2E... user@host
package_update: true
packages:
  - vim
  - git
runcmd:
  - systemctl enable --now sshd
EOF

# 2. Buat meta-data
cat > "$META_DATA" <<EOF
instance-id: ${VM}-001
local-hostname: ${VM}
EOF

# 3. Buat seed
cloud-localds "$SEED" "$USER_DATA" "$META_DATA"

# 4. Buat VM
virt-install \
  --name "$VM" \
  --memory 1024 \
  --vcpus 2 \
  --disk path="$IMAGE",size=10,format=qcow2,bus=virtio \
  --disk path="$SEED",device=cdrom,readonly=on \
  --os-variant archlinux \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --import \
  --noautoconsole

echo "VM $VM created with cloud-init."
```

**Penjelasan:**
- Skrip membuat user-data, meta-data, seed, dan VM.

---

## 5. Diagram Arsitektur cloud-init

### 5.1. Alur cloud-init

```
Boot VM
  |
  v
+-------------------+
|  cloud-init       |
|  (generator)      |
+-------------------+
  |
  | Cari data source
  v
+-------------------+
|  NoCloud          |
|  (seed.img)       |
+-------------------+
  |
  | Baca user-data, meta-data, network-config
  v
+-------------------+
|  cloud-init       |
|  (local, network, config, final) |
+-------------------+
  |
  | Terapkan konfigurasi
  v
+-------------------+
|  VM siap          |
+-------------------+
```

### 5.2. Struktur seed.img

```
seed.img
├── user-data
├── meta-data
└── network-config
```

### 5.3. Data Source

```
+-------------------+
|  cloud-init       |
+-------------------+
  |
  +-- NoCloud (ISO, disk)
  +-- ConfigDrive (disk)
  +-- Metadata Service (HTTP)
  +-- SmartOS
  +-- Azure
  +-- AWS
  +-- GCP
```

### 5.4. Tahapan cloud-init

```
+-------------------+
|  Generator        |
+-------------------+
          |
          v
+-------------------+
|  Local            |
+-------------------+
          |
          v
+-------------------+
|  Network          |
+-------------------+
          |
          v
+-------------------+
|  Config           |
+-------------------+
          |
          v
+-------------------+
|  Final            |
+-------------------+
```

### 5.5. Integrasi dengan libvirt

```
+-------------------+
|  virt-install     |
+-------------------+
          |
          | --cloud-init
          v
+-------------------+
|  libvirt          |
+-------------------+
          |
          | buat seed.img
          v
+-------------------+
|  QEMU             |
+-------------------+
          |
          | mount seed
          v
+-------------------+
|  cloud-init       |
+-------------------+
```

### 5.6. Pohon Keputusan Data Source

```
Apakah ada metadata service?
├── Ya → Gunakan Metadata Service
└── Tidak → Apakah ada disk seed?
    ├── Ya → Gunakan NoCloud/ConfigDrive
    └── Tidak → cloud-init gagal
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 7.1

Kurikulum asli menyebut:
```yaml
#cloud-config
users:
  - name: user
    ssh-authorized-keys:
      - ssh-rsa AAAA...
```
```bash
cloud-localds seed.img user-data meta-data
```
> VM otomatis dikonfigurasi.

Kita akan menambahkan:
1. **NoCloud, ConfigDrive, Metadata Service**.
2. **user-data, meta-data, network-config**.
3. **cloud-localds** dengan opsi `--dsmode`, `--vendor-data`, `--network-config`.
4. **Integrasi `virt-install --cloud-init`**.
5. **Cloud image** (`Arch-Linux-x86_64-cloudimg.qcow2`).
6. **`--import`**.
7. **Status cloud-init**: `cloud-init status`, `--long`.
8. **Log cloud-init**: `/var/log/cloud-init.log`, `cloud-init-output.log`.
9. **Clean cloud-init**: `cloud-init clean`.
10. **Debugging**: `cloud-init analyze`, `collect-logs`.
11. **Validasi YAML**.
12. **Contoh lengkap**: web server.
13. **Skrip provisioning**.
14. **Idempotensi**.
15. **Power state**.
16. **Final message**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 7.1.

---

## 7. Hubungan dengan Modul Lain

- **Fase 3 (libvirt)**: `virt-install` digunakan dengan `--cloud-init`.
- **Fase 4 (Storage)**: cloud image dan seed image.
- **Fase 5 (Networking)**: network-config.
- **Fase 6 (Security)**: SSH key, user, sudo.
- **Modul 7.2 (Windows)**: konsep serupa dengan unattended.
- **Modul 7.3 (Skrip)**: cloud-init dipanggil dari skrip.
- **Modul 7.5 (Capstone)**: provisioning multi-VM.
- **Fase 8 (Expert)**: cloud-init untuk live migration.

---

## 8. Referensi Lengkap

- cloud-init Documentation — https://cloud-init.readthedocs.io/
- cloud-init NoCloud — https://cloud-init.readthedocs.io/en/latest/datasources/nocloud.html
- cloud-init ConfigDrive — https://cloud-init.readthedocs.io/en/latest/datasources/configdrive.html
- cloud-init Modules — https://cloud-init.readthedocs.io/en/latest/modules.html
- cloud-init Examples — https://cloud-init.readthedocs.io/en/latest/examples.html
- cloud-localds — https://manpages.ubuntu.com/manpages/focal/man1/cloud-localds.1.html
- libvirt cloud-init — https://libvirt.org/formatdomain.html#cloud-init
- virt-install cloud-init — https://virt-manager.org/pipermail/virt-tools-list/2019-January/000123.html
- Arch Linux Cloud Image — https://geo.mirror.pkgbuild.com/images/latest/
- Arch Wiki: cloud-init — https://wiki.archlinux.org/title/Cloud-init
- YAML — https://yaml.org/
- cloud-init GitHub — https://github.com/canonical/cloud-init

---

## 9. Tips & Praktik Terbaik

1. **Gunakan cloud image** daripada ISO untuk provisioning cepat.
2. **Validasi YAML** sebelum digunakan.
3. **Gunakan SSH key**, bukan password.
4. **Gunakan `sudo: ALL=(ALL) NOPASSWD:ALL`** dengan hati-hati.
5. **Gunakan `runcmd`** untuk perintah idempotent.
6. **Gunakan `write_files`** untuk file konfigurasi.
7. **Gunakan `power_state`** untuk reboot setelah provisioning.
8. **Gunakan `final_message`** untuk konfirmasi.
9. **Cek `cloud-init status`** setelah boot.
10. **Baca log** jika gagal.
11. **Bersihkan cloud-init** sebelum membuat image baru.
12. **Gunakan `cloud-localds`** untuk seed.
13. **Integrasikan dengan `virt-install --cloud-init`**.
14. **Dokumentasikan user-data**.
15. **Simpan user-data di Git**.
16. **Gunakan template** untuk user-data.
17. **Uji di VM terpisah** sebelum produksi.
18. **Gunakan `network-config`** untuk jaringan statis.
19. **Gunakan `datasource_list`** untuk kontrol.
20. **Monitor log cloud-init**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| cloud-init tidak jalan | Tidak ada data source. | Pastikan seed.img ada. |
| YAML error | Sintaks salah. | Validasi dengan Python/yq. |
| SSH key tidak bekerja | Format salah. | Gunakan public key yang benar. |
| User tidak dibuat | `users` salah. | Cek indentasi YAML. |
| Paket tidak terinstal | `packages` salah. | Cek nama paket. |
| Network tidak jalan | `network-config` salah. | Gunakan DHCP atau statis yang benar. |
| VM tidak reboot | `power_state` salah. | Cek `condition`. |
| cloud-init lambat | `package_upgrade`. | Nonaktifkan jika tidak perlu. |
| Log tidak ditemukan | Path salah. | `/var/log/cloud-init.log`. |
| Seed tidak terbaca | Format salah. | Gunakan `cloud-localds`. |
| `virt-install` gagal | `--cloud-init` tidak didukung. | Update libvirt. |
| Cloud image corrupt | Download gagal. | Verifikasi checksum. |
| `--import` gagal | Image tidak ada. | Cek path. |
| Idempotensi gagal | `runcmd` tidak idempotent. | Gunakan `&&`, `||`, cek file. |
| Reboot loop | `power_state` selalu. | Gunakan `condition` yang tepat. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `cloud-init status` menunjukkan `done`.
- `cat /var/log/cloud-init.log` tidak ada error.
- User yang dibuat bisa login via SSH.
- Paket yang diminta terinstal.
- File yang ditulis ada.
- `runcmd` berjalan.
- VM reboot jika diminta.
- `final_message` muncul di log.

**Troubleshooting:**
- Jika cloud-init tidak jalan: cek `cloud-init status --long`, cek `datasource_list`.
- Jika YAML error: validasi dengan `python -c "import yaml; yaml.safe_load(open('user-data'))"`.
- Jika SSH key gagal: cek `~/.ssh/authorized_keys` di guest.
- Jika paket gagal: cek `cloud-init-output.log`.
- Jika network gagal: cek `network-config`, cek `ip a`.
- Jika reboot gagal: cek `power_state`.
- Untuk debugging: `cloud-init analyze show`, `cloud-init collect-logs`.
- Untuk log: `/var/log/cloud-init.log`, `/var/log/cloud-init-output.log`.

---

## 12. Latihan Mandiri

1. Buat file `user-data` dengan user dan SSH key.
2. Buat file `meta-data`.
3. Buat `network-config` dengan DHCP.
4. Buat `seed.img` dengan `cloud-localds`.
5. Jalankan VM dengan QEMU dan seed.
6. Cek `cloud-init status`.
7. Baca log cloud-init.
8. Buat VM dengan `virt-install --cloud-init`.
9. Gunakan cloud image.
10. Uji `--import`.
11. Buat user-data dengan `packages`.
12. Uji `write_files`.
13. Uji `runcmd`.
14. Uji `power_state`.
15. Uji `final_message`.
16. Bersihkan cloud-init.
17. Debug dengan `cloud-init analyze`.
18. Validasi YAML.
19. Buat skrip provisioning.
20. Dokumentasikan.

---

## 13. Penutup Modul 7.1

Anda kini menguasai **Provisioning Otomatis cloud-init**. Anda bisa:
- Membuat **user-data**, **meta-data**, **network-config**.
- Membuat **seed.img** dengan `cloud-localds`.
- Menggunakan **cloud image** dan `--import`.
- Mengintegrasikan dengan **virt-install --cloud-init**.
- Melihat **status** dan **log** cloud-init.
- Melakukan **debugging**.
- Membuat **skrip provisioning** otomatis.

Ini adalah fondasi untuk **Modul 7.2 — Windows Guest Headless**, di mana kita akan mengotomasi instalasi Windows tanpa GUI.

---

*Motivasi: Otomasi bukan tentang menggantikan manusia, tetapi membebaskan manusia dari pekerjaan berulang. cloud-init adalah tangan pertama yang menyentuh VM Anda. Biarkan ia bekerja, dan Anda bisa fokus pada hal yang lebih besar.*

---

# Modul 7.2 — Windows Guest Headless

## Mini-Daftar Isi Modul 7.2

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Windows Guest Headless
6. Audit Kurikulum: Tambahan untuk Modul 7.2
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 7.2

---

> *Motivasi: Windows bukanlah musuh. Ia adalah tamu yang berbicara bahasa berbeda. Pelajari bahasanya, dan Anda bisa mengundangnya tanpa harus menyalakan layar.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Windows Guest Headless** adalah seni **menginstal, mengonfigurasi, dan mengelola Windows sebagai VM tanpa akses GUI** — hanya melalui **TUI (Text User Interface)** di Arch Linux. Ini adalah tantangan tersendiri karena:

- **Windows tidak memiliki konsep serial console** seperti Linux. Instalasi Windows secara default membutuhkan **display grafis** (VGA, VNC, SPICE).
- **Windows tidak mengenal virtio** secara native. Driver virtio (disk, network, balloon) harus disediakan saat instalasi.
- **Windows tidak memiliki SSH server** secara default (walaupun Windows 10+ memiliki OpenSSH opsional).
- **Windows menggunakan WinRM** (Windows Remote Management) untuk manajemen jarak jauh — bukan SSH.

Untuk mengatasi ini, kita menggunakan kombinasi:

1. **Unattended Installation** (`autounattend.xml`) — menjawab semua pertanyaan instalasi secara otomatis.
2. **Virtio-win ISO** — menyediakan driver virtio saat instalasi.
3. **WinRM** — manajemen jarak jauh setelah instalasi.
4. **OpenSSH for Windows** — alternatif SSH.
5. **`virsh screenshot`** — melihat layar VM di terminal (dengan konversi ke ASCII/karakter).
6. **Cloudbase-init** — analog cloud-init untuk Windows.
7. **Sysprep** — generalisasi image untuk cloning.

**Peran dalam kurikulum:** Modul ini adalah **ujian kemampuan otomasi multi-OS**. Setelah Anda mengotomasi Linux dengan cloud-init (7.1), sekarang Anda mengotomasi **Windows** — sistem operasi yang **tidak dirancang untuk headless**. Ini adalah keterampilan **expert** yang membedakan sysadmin biasa dari **virtualization engineer**. Modul ini juga fondasi untuk:
- **Modul 7.3 (Skrip Bash + Hooks)**: skrip provisioning Windows.
- **Modul 7.4 (Drill Troubleshooting)**: debugging Windows headless.
- **Modul 7.5 (Capstone)**: multi-OS (Linux + Windows).
- **Fase 8 (Expert)**: VFIO passthrough untuk GPU Windows.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Windows adalah Tamu Khusus

Windows **tidak dirancang** untuk dijalankan tanpa layar. Ia mengasumsikan:
- Ada **display** (VGA, HDMI).
- Ada **keyboard dan mouse** fisik.
- Ada **driver bawaan** untuk perangkat umum.
- Ada **interaksi manusia** saat instalasi.

Untuk menjalankannya **headless**, kita harus **memalsukan** semua asumsi ini.

**Filosofi:** *Windows adalah tamu yang buta. Kita harus menjadi matanya.*

### 2.2. Unattended Installation: Jawaban yang Telah Disiapkan

**Unattended installation** adalah proses menjawab **semua pertanyaan** instalasi Windows **sebelum** instalasi dimulai. Jawaban ini disimpan dalam file **`autounattend.xml`** (atau `unattend.xml`).

File ini berisi:
- **Product key**.
- **Bahasa, waktu, mata uang**.
- **Partisi disk**.
- **Nama komputer**.
- **User dan password**.
- **Driver yang di-load**.
- **Perintah yang dijalankan** setelah instalasi.

**Filosofi:** *Tidak ada pertanyaan yang tidak bisa dijawab sebelumnya.*

### 2.3. Virtio: Driver yang Harus Ditanam

Windows tidak mengenal **virtio** secara native. Jika Anda menggunakan disk virtio, Windows **tidak akan melihat disk** saat instalasi. Solusinya:
- **Virtio-win ISO** berisi driver untuk Windows (disk, network, balloon, serial, dll).
- Driver ini harus **di-load** saat instalasi (via `autounattend.xml` atau manual).
- Setelah instalasi, driver bisa diinstal via **`pnputil`** atau **Device Manager**.

**Filosofi:** *Virtio adalah bahasa asing. Kita harus memberikan kamus.*

### 2.4. WinRM: SSH-nya Windows

**WinRM** (Windows Remote Management) adalah protokol **WS-Management** yang memungkinkan:
- Menjalankan perintah jarak jauh.
- Mentransfer file.
- Mengelola konfigurasi.
- PowerShell Remoting.

WinRM berjalan di **port 5985 (HTTP)** dan **5986 (HTTPS)**.

**Filosofi:** *WinRM adalah pintu masuk. Buka dengan aman.*

### 2.5. OpenSSH for Windows: Alternatif Familiar

Sejak Windows 10 1809, **OpenSSH** tersedia sebagai fitur opsional. Ini memungkinkan:
- SSH ke Windows.
- SCP/SFTP.
- Port forwarding.
- Ansible, rsync, dll.

**Filosofi:** *SSH adalah lingua franca. Windows akhirnya berbicara.*

### 2.6. Cloudbase-init: cloud-init untuk Windows

**Cloudbase-init** adalah **port cloud-init untuk Windows**. Ia mendukung:
- **Metadata service** (OpenStack, AWS, Azure).
- **User data** (PowerShell, batch, YAML).
- **Network config**.
- **Password generation**.

**Filosofi:** *Windows juga bisa otomatis. Cloudbase-init adalah jembatannya.*

### 2.7. Sysprep: Generalisasi Image

**Sysprep** (System Preparation) adalah alat Microsoft untuk **menggeneralisasi** Windows:
- Menghapus **SID** (Security Identifier).
- Menghapus **driver spesifik**.
- Menghapus **konfigurasi user**.
- Menyiapkan **OOBE** (Out-of-Box Experience).

Setelah sysprep, image bisa **di-clone** dan **di-deploy** ke VM lain.

**Filosofi:** *Satu image, banyak VM. Sysprep adalah pembersih.*

### 2.8. virsh screenshot: Mata di Terminal

**`virsh screenshot`** menangkap **framebuffer** VM dan menyimpannya sebagai **PPM** (Portable Pixmap). Dengan alat seperti **`chafa`**, **`jp2a`**, atau **`img2txt`**, Anda bisa melihatnya di terminal sebagai **ASCII art**.

**Filosofi:** *Jika tidak bisa melihat, kita bisa menebak. Screenshot adalah mata.*

### 2.9. QEMU Monitor: Kontrol Manual

**QEMU Monitor** (`-monitor`) memungkinkan:
- **`screendump`** — screenshot.
- **`sendkey`** — kirim tombol.
- **`info status`** — status.
- **`system_powerdown`** — shutdown.

**Filosofi:** *Monitor adalah remote control.*

### 2.10. Filosofi Keseluruhan

- **Windows butuh mata** → screenshot.
- **Windows butuh jawaban** → autounattend.xml.
- **Windows butuh driver** → virtio-win.
- **Windows butuh manajemen** → WinRM/OpenSSH.
- **Windows butuh otomasi** → cloudbase-init.
- **Windows butuh generalisasi** → sysprep.
- **Windows adalah tamu** → perlakukan dengan hormat.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Windows Guest** | VM Windows. | |
| **Headless** | Tanpa GUI. | |
| **Unattended** | Instalasi otomatis. | |
| **autounattend.xml** | File jawaban instalasi. | |
| **unattend.xml** | File jawaban (untuk sysprep). | |
| **Virtio-win** | Driver virtio untuk Windows. | `virtio-win.iso` |
| **WinRM** | Windows Remote Management. | |
| **WS-Man** | WS-Management. | |
| **OpenSSH** | SSH untuk Windows. | |
| **PowerShell Remoting** | Remote PowerShell. | |
| **Cloudbase-init** | cloud-init untuk Windows. | |
| **Sysprep** | Generalisasi Windows. | |
| **OOBE** | Out-of-Box Experience. | |
| **SID** | Security Identifier. | |
| **`virsh screenshot`** | Screenshot VM. | |
| **PPM** | Portable Pixmap. | |
| **`chafa`** | Viewer gambar di terminal. | |
| **`jp2a`** | JPEG to ASCII. | |
| **`img2txt`** | Image to text. | |
| **QEMU Monitor** | Kontrol QEMU. | |
| **`screendump`** | Screenshot di QEMU Monitor. | |
| **`sendkey`** | Kirim tombol. | |
| **`pnputil`** | Alat driver Windows. | |
| **`dism`** | Deployment Image Servicing. | |
| **`bcdedit`** | Boot Configuration Editor. | |
| **`wmic`** | WMI CLI. | |
| **`netsh`** | Network shell. | |
| **`winrm`** | WinRM CLI. | |
| **`winrs`** | WinRM shell. | |
| **`pywinrm`** | WinRM untuk Python. | |
| **`ansible`** | Otomasi. | |
| **`autounattend`** | Jawaban instalasi. | |
| **`Component`** | Bagian di XML. | |
| **`settings pass`** | Tahap di XML. | |
| **`specialize`** | Tahap sysprep. | |
| **`oobeSystem`** | Tahap OOBE. | |
| **`FirstLogonCommands`** | Perintah login pertama. | |
| **`RunSynchronous`** | Perintah sinkron. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Mengunduh Virtio-win ISO

```bash
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
```

**Penjelasan kata demi kata:**
- `wget` — download.
- URL — link ke virtio-win ISO.
- `virtio-win.iso` — file ISO.

**Alternatif:**
```bash
sudo pacman -S virtio-win
```

**Penjelasan:**
- Paket `virtio-win` di AUR atau repo komunitas.

### 4.2. Membuat autounattend.xml Minimal

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="windowsPE">
    <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
      <SetupUILanguage>
        <UILanguage>en-US</UILanguage>
      </SetupUILanguage>
      <InputLocale>en-US</InputLocale>
      <SystemLocale>en-US</SystemLocale>
      <UILanguage>en-US</UILanguage>
      <UserLocale>en-US</UserLocale>
    </component>

    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
      <DiskConfiguration>
        <Disk wcm:action="add">
          <DiskID>0</DiskID>
          <WillWipeDisk>true</WillWipeDisk>
          <CreatePartitions>
            <CreatePartition wcm:action="add">
              <Order>1</Order>
              <Type>Primary</Type>
              <Extend>true</Extend>
            </CreatePartition>
          </CreatePartitions>
          <ModifyPartitions>
            <ModifyPartition wcm:action="add">
              <Order>1</Order>
              <PartitionID>1</PartitionID>
              <Format>NTFS</Format>
              <Label>Windows</Label>
              <Letter>C</Letter>
              <Active>true</Active>
            </ModifyPartition>
          </ModifyPartitions>
        </Disk>
      </DiskConfiguration>

      <ImageInstall>
        <OSImage>
          <InstallFrom>
            <MetaData wcm:action="add">
              <Key>/IMAGE/NAME</Key>
              <Value>Windows 10 Pro</Value>
            </MetaData>
          </InstallFrom>
          <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>1</PartitionID>
          </InstallTo>
        </OSImage>
      </ImageInstall>

      <UserData>
        <ProductKey>
          <Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
        </ProductKey>
        <AcceptEula>true</AcceptEula>
        <FullName>User</FullName>
        <Organization>Home</Organization>
      </UserData>

      <DriverPaths>
        <PathAndCredentials wcm:action="add" wcm:keyValue="1">
          <Path>E:\amd64\w10</Path>
        </PathAndCredentials>
      </DriverPaths>
    </component>
  </settings>

  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideLocalAccountScreen>true</HideLocalAccountScreen>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <NetworkLocation>Work</NetworkLocation>
        <ProtectYourPC>1</ProtectYourPC>
      </OOBE>
      <UserAccounts>
        <LocalAccounts>
          <LocalAccount wcm:action="add">
            <Name>user</Name>
            <Group>Administrators</Group>
            <Password>
              <Value>Password123!</Value>
              <PlainText>true</PlainText>
            </Password>
          </LocalAccount>
        </LocalAccounts>
      </UserAccounts>
      <AutoLogon>
        <Username>user</Username>
        <Enabled>true</Enabled>
        <LogonCount>1</LogonCount>
        <Password>
          <Value>Password123!</Value>
          <PlainText>true</PlainText>
        </Password>
      </AutoLogon>
      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>cmd /c winrm quickconfig -q</CommandLine>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>2</Order>
          <CommandLine>powershell -Command "Enable-PSRemoting -Force"</CommandLine>
        </SynchronousCommand>
      </FirstLogonCommands>
    </component>
  </settings>
</unattend>
```

**Penjelasan kata demi kata:**
- `<?xml version="1.0" encoding="utf-8"?>` — deklarasi XML.
- `<unattend xmlns="...">` — root elemen.
- `<settings pass="windowsPE">` — tahap Windows PE (instalasi awal).
  - `<component name="Microsoft-Windows-International-Core-WinPE">` — komponen bahasa.
    - `<UILanguage>en-US</UILanguage>` — bahasa UI.
  - `<component name="Microsoft-Windows-Setup">` — komponen setup.
    - `<DiskConfiguration>` — konfigurasi disk.
      - `<Disk wcm:action="add">` — tambah disk.
        - `<DiskID>0</DiskID>` — ID disk.
        - `<WillWipeDisk>true</WillWipeDisk>` — hapus disk.
        - `<CreatePartitions>` — buat partisi.
          - `<CreatePartition>` — partisi baru.
            - `<Type>Primary</Type>` — partisi primer.
            - `<Extend>true</Extend>` — perbesar.
        - `<ModifyPartitions>` — modifikasi partisi.
          - `<Format>NTFS</Format>` — format NTFS.
          - `<Letter>C</Letter>` — drive C.
          - `<Active>true</Active>` — aktif.
    - `<ImageInstall>` — instalasi image.
      - `<OSImage>` — image OS.
        - `<InstallFrom>` — dari mana.
          - `<MetaData>` — metadata.
            - `<Key>/IMAGE/NAME</Key>` — key.
            - `<Value>Windows 10 Pro</Value>` — nilai.
        - `<InstallTo>` — ke mana.
          - `<DiskID>0</DiskID>` — disk 0.
          - `<PartitionID>1</PartitionID>` — partisi 1.
    - `<UserData>` — data user.
      - `<ProductKey>` — product key.
      - `<AcceptEula>true</AcceptEula>` — terima EULA.
    - `<DriverPaths>` — path driver.
      - `<Path>E:\amd64\w10</Path>` — path ke driver virtio.
- `<settings pass="oobeSystem">` — tahap OOBE.
  - `<component name="Microsoft-Windows-Shell-Setup">` — komponen shell.
    - `<OOBE>` — out-of-box experience.
      - `<HideEULAPage>true</HideEULAPage>` — sembunyikan EULA.
      - `<HideLocalAccountScreen>true</HideLocalAccountScreen>` — sembunyikan akun lokal.
    - `<UserAccounts>` — akun user.
      - `<LocalAccounts>` — akun lokal.
        - `<LocalAccount>` — akun.
          - `<Name>user</Name>` — nama.
          - `<Group>Administrators</Group>` — grup.
          - `<Password>` — password.
    - `<AutoLogon>` — login otomatis.
    - `<FirstLogonCommands>` — perintah login pertama.
      - `<SynchronousCommand>` — perintah sinkron.
        - `<CommandLine>cmd /c winrm quickconfig -q</CommandLine>` — aktifkan WinRM.

### 4.3. Membuat ISO dengan autounattend.xml

```bash
mkdir -p /tmp/autounattend
cp autounattend.xml /tmp/autounattend/
genisoimage -o autounattend.iso -J -R /tmp/autounattend/
```

**Penjelasan:**
- `mkdir -p` — buat direktori.
- `cp` — copy file.
- `genisoimage` — buat ISO.
- `-o autounattend.iso` — output.
- `-J -R` — opsi ISO.
- `/tmp/autounattend/` — direktori input.

**Alternatif:**
```bash
xorriso -as mkisofs -o autounattend.iso -J -R /tmp/autounattend/
```

### 4.4. Menjalankan VM Windows Headless

```bash
virt-install \
  --name windows-vm \
  --memory 4096 \
  --vcpus 2 \
  --disk size=40,format=qcow2,bus=virtio \
  --cdrom /path/to/windows.iso \
  --disk path=/path/to/virtio-win.iso,device=cdrom \
  --disk path=/path/to/autounattend.iso,device=cdrom \
  --os-variant win10 \
  --graphics none \
  --console pty,target_type=serial \
  --network network=default,model=virtio \
  --boot cdrom,hd \
  --noautoconsole
```

**Penjelasan kata demi kata:**
- `--name windows-vm` — nama VM.
- `--memory 4096` — memori 4GB.
- `--vcpus 2` — 2 vCPU.
- `--disk size=40,format=qcow2,bus=virtio` — disk 40GB virtio.
- `--cdrom /path/to/windows.iso` — ISO Windows.
- `--disk path=virtio-win.iso,device=cdrom` — ISO virtio-win.
- `--disk path=autounattend.iso,device=cdrom` — ISO autounattend.
- `--os-variant win10` — varian OS.
- `--graphics none` — tanpa grafis.
- `--console pty,target_type=serial` — serial console.
- `--network network=default,model=virtio` — jaringan virtio.
- `--boot cdrom,hd` — boot dari CD.
- `--noautoconsole` — jangan buka console otomatis.

### 4.5. Melihat Layar dengan virsh screenshot

```bash
virsh screenshot windows-vm /tmp/screen.ppm
```

**Penjelasan:**
- `virsh screenshot` — screenshot VM.
- `windows-vm` — nama VM.
- `/tmp/screen.ppm` — output PPM.

**Konversi ke ASCII:**
```bash
chafa /tmp/screen.ppm
```

**Alternatif:**
```bash
jp2a /tmp/screen.ppm
img2txt /tmp/screen.ppm
```

**Konversi ke PNG:**
```bash
convert /tmp/screen.ppm /tmp/screen.png
```

**Penjelasan:**
- `convert` — ImageMagick.

### 4.6. Mengirim Tombol dengan QEMU Monitor

```bash
virsh qemu-monitor-command windows-vm --hmp "sendkey ctrl-alt-delete"
```

**Penjelasan:**
- `qemu-monitor-command` — kirim perintah ke QEMU Monitor.
- `--hmp` — Human Monitor Protocol.
- `sendkey` — kirim tombol.
- `ctrl-alt-delete` — kombinasi tombol.

**Tombol lain:**
- `ret` — Enter.
- `esc` — Escape.
- `tab` — Tab.
- `spc` — Spasi.
- `a-z` — huruf.
- `0-9` — angka.
- `f1-f12` — fungsi.

### 4.7. WinRM: Setup di Windows

**Di Windows (via FirstLogonCommands):**
```powershell
winrm quickconfig -q
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

**Penjelasan:**
- `winrm quickconfig -q` — konfigurasi WinRM.
- `Enable-PSRemoting -Force` — aktifkan PowerShell Remoting.
- `Set-Item WSMan:\...\TrustedHosts` — trusted hosts.

**Di host Linux:**
```bash
sudo pacman -S python-pywinrm
python -c "
import winrm
s = winrm.Session('http://localhost:5985/wsman', auth=('user', 'Password123!'))
r = s.run_cmd('ipconfig')
print(r.std_out.decode())
"
```

**Penjelasan:**
- `python-pywinrm` — library WinRM.
- `winrm.Session` — buat sesi.
- `run_cmd` — jalankan perintah.
- `std_out` — output.

### 4.8. OpenSSH for Windows

**Di Windows (via FirstLogonCommands):**
```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

**Penjelasan:**
- `Add-WindowsCapability` — tambah fitur.
- `Start-Service sshd` — jalankan SSH.
- `Set-Service` — atur startup.
- `New-NetFirewallRule` — buka firewall.

**Di host Linux:**
```bash
ssh -p 22 user@localhost
```

### 4.9. Cloudbase-init

**Mengunduh:**
```bash
wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi
```

**Instalasi di Windows:**
```powershell
msiexec /i CloudbaseInitSetup_Stable_x64.msi /qn
```

**Konfigurasi:**
```ini
# C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf
[DEFAULT]
metadata_services=cloudbaseinit.metadata.services.nocloudservice.NoCloudConfigDriveService
plugins=cloudbaseinit.plugins.common.mtu.MTUPlugin,cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,cloudbaseinit.plugins.common.setuserpassword.SetUserPasswordPlugin,cloudbaseinit.plugins.windows.licensing.WindowsLicensingPlugin
```

**Penjelasan:**
- `metadata_services` — layanan metadata.
- `plugins` — plugin yang dijalankan.

### 4.10. Sysprep: Generalisasi

**Di Windows:**
```cmd
C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:C:\unattend.xml
```

**Penjelasan:**
- `/generalize` — generalisasi.
- `/oobe` — ke OOBE.
- `/shutdown` — shutdown setelah.
- `/unattend` — file jawaban.

### 4.11. Konversi Image Windows

```bash
qemu-img convert -f raw -O qcow2 windows.raw windows.qcow2
```

**Penjelasan:**
- `qemu-img convert` — konversi.
- `-f raw` — input raw.
- `-O qcow2` — output qcow2.

### 4.12. Contoh XML Windows Headless

```xml
<domain type='kvm'>
  <name>windows-vm</name>
  <memory unit='MiB'>4096</memory>
  <vcpu>2</vcpu>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
  </os>

  <features>
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state='on'/>
      <vapic state='on'/>
      <spinlocks state='on' retries='8191'/>
    </hyperv>
  </features>

  <cpu mode='host-passthrough' check='none'/>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='/var/lib/libvirt/images/windows-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>

    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/path/to/virtio-win.iso'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>

    <controller type='pci' index='0' model='pcie-root'/>
    <controller type='sata' index='0'/>

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

    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>

    <video>
      <model type='qxl'/>
    </video>

    <memballoon model='virtio'/>
  </devices>
</domain>
```

**Penjelasan:**
- `<hyperv>` — optimasi Hyper-V untuk Windows.
- `<graphics type='vnc'>` — VNC untuk melihat layar.
- `<video><model type='qxl'/></video>` — video QXL.

### 4.13. Melihat VNC dengan TUI

```bash
vncviewer localhost:5900
```

**Alternatif TUI:**
```bash
# Menggunakan vncsnapshot dan chafa
vncsnapshot localhost:0 /tmp/screen.jpg
chafa /tmp/screen.jpg
```

**Penjelasan:**
- `vncsnapshot` — screenshot VNC.
- `chafa` — tampilkan di terminal.

### 4.14. Skrip Provisioning Windows

```bash
#!/bin/bash
set -e

VM="windows-vm"
IMAGE="/var/lib/libvirt/images/${VM}.qcow2"
VIRTIO_ISO="/var/lib/libvirt/images/virtio-win.iso"
WINDOWS_ISO="/var/lib/libvirt/images/windows.iso"
AUTOUNATTEND_ISO="/var/lib/libvirt/images/autounattend.iso"

# 1. Buat disk
qemu-img create -f qcow2 "$IMAGE" 40G

# 2. Buat VM
virt-install \
  --name "$VM" \
  --memory 4096 \
  --vcpus 2 \
  --disk path="$IMAGE",format=qcow2,bus=virtio \
  --cdrom "$WINDOWS_ISO" \
  --disk path="$VIRTIO_ISO",device=cdrom \
  --disk path="$AUTOUNATTEND_ISO",device=cdrom \
  --os-variant win10 \
  --graphics vnc,listen=127.0.0.1 \
  --network network=default,model=virtio \
  --boot cdrom,hd \
  --noautoconsole

echo "VM $VM created. Waiting for installation..."
sleep 60

# 3. Screenshot
virsh screenshot "$VM" /tmp/windows-install.ppm
chafa /tmp/windows-install.ppm
```

**Penjelasan:**
- Skrip membuat VM Windows headless.

### 4.15. Verifikasi Windows Headless

```bash
# 1. Cek status VM
virsh list --all

# 2. Cek screenshot
virsh screenshot windows-vm /tmp/screen.ppm
chafa /tmp/screen.ppm

# 3. Cek WinRM (setelah instalasi)
python -c "
import winrm
s = winrm.Session('http://localhost:5985/wsman', auth=('user', 'Password123!'))
r = s.run_cmd('systeminfo')
print(r.std_out.decode())
"

# 4. Cek SSH (jika diaktifkan)
ssh user@localhost
```

### 4.16. Alternatif: Windows Cloud Image

**Windows tidak memiliki cloud image resmi** seperti Linux. Tetapi ada:
- **Windows Server Core** — tanpa GUI.
- **Windows Nano Server** — minimal.
- **Azure Windows Image** — untuk Azure.

**Untuk Windows Server Core:**
```bash
virt-install \
  --name winserver \
  --memory 4096 \
  --vcpus 2 \
  --disk size=40,bus=virtio \
  --cdrom /path/to/winserver.iso \
  --disk path=virtio-win.iso,device=cdrom \
  --os-variant win2k19 \
  --graphics none \
  --console pty,target_type=serial
```

**Penjelasan:**
- Windows Server Core memiliki **mode headless** built-in.

---

## 5. Diagram Arsitektur Windows Guest Headless

### 5.1. Alur Instalasi Unattended

```
Boot VM
  |
  v
+-------------------+
|  Windows PE       |
+-------------------+
  |
  | Baca autounattend.xml
  v
+-------------------+
|  Partisi Disk     |
+-------------------+
  |
  | Load driver virtio
  v
+-------------------+
|  Instal Windows   |
+-------------------+
  |
  | OOBE
  v
+-------------------+
|  FirstLogonCommands |
+-------------------+
  |
  | WinRM / SSH
  v
+-------------------+
|  Windows siap     |
+-------------------+
```

### 5.2. Arsitektur Headless

```
+-------------------+
|  Host Arch Linux  |
+-------------------+
          |
          | virsh
          v
+-------------------+
|  libvirt          |
+-------------------+
          |
          | QEMU
          v
+-------------------+
|  Windows VM       |
+-------------------+
          |
          +-- VNC (127.0.0.1)
          +-- WinRM (5985)
          +-- SSH (22)
          +-- QEMU Monitor
          +-- virsh screenshot
```

### 5.3. Virtio Driver

```
+-------------------+
|  virtio-win.iso   |
+-------------------+
          |
          | mount
          v
+-------------------+
|  E:\amd64\w10     |
+-------------------+
          |
          | DriverPaths
          v
+-------------------+
|  Windows Setup    |
+-------------------+
          |
          | install driver
          v
+-------------------+
|  Disk virtio      |
+-------------------+
```

### 5.4. WinRM

```
+-------------------+
|  Host Linux       |
+-------------------+
          |
          | pywinrm
          v
+-------------------+
|  WinRM (5985)     |
+-------------------+
          |
          | PowerShell
          v
+-------------------+
|  Windows VM       |
+-------------------+
```

### 5.5. Screenshot

```
+-------------------+
|  QEMU             |
+-------------------+
          |
          | framebuffer
          v
+-------------------+
|  virsh screenshot |
+-------------------+
          |
          | PPM
          v
+-------------------+
|  chafa / jp2a     |
+-------------------+
          |
          | ASCII
          v
+-------------------+
|  Terminal         |
+-------------------+
```

### 5.6. Sysprep

```
+-------------------+
|  Windows VM       |
+-------------------+
          |
          | sysprep /generalize
          v
+-------------------+
|  Image General    |
+-------------------+
          |
          | clone
          v
+-------------------+
|  VM Baru          |
+-------------------+
          |
          | OOBE
          v
+-------------------+
|  VM Siap          |
+-------------------+
```

### 5.7. Pohon Keputusan Windows Headless

```
Apakah butuh Windows?
├── Ya → Apakah butuh GUI?
│   ├── Ya → VNC + QXL
│   └── Tidak → Server Core / Nano
└── Tidak → Linux

Apakah butuh manajemen jarak jauh?
├── Ya → WinRM / OpenSSH
└── Tidak → Screenshot

Apakah butuh otomasi?
├── Ya → autounattend.xml + cloudbase-init
└── Tidak → Instal manual
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 7.2

Kurikulum asli menyebut:
> Windows butuh display grafis untuk instalasi.
> Solusi: unattended install + virtio-win + WinRM/SSH.
> `virsh screenshot` untuk melihat layar di terminal (dengan viewer karakter).
> Gunakan `autounattend.xml`, `virtio-win.iso`, dan akses via WinRM.

Kita akan menambahkan:
1. **autounattend.xml** — struktur lengkap.
2. **Virtio-win ISO** — download, mount, driver path.
3. **WinRM** — setup, python-pywinrm.
4. **OpenSSH for Windows** — instalasi, firewall.
5. **Cloudbase-init** — instalasi, konfigurasi.
6. **Sysprep** — generalisasi.
7. **`virsh screenshot`** — PPM, chafa, jp2a.
8. **QEMU Monitor** — `sendkey`, `screendump`.
9. **VNC + QXL** — untuk GUI minimal.
10. **Hyper-V enlightenments** — optimasi.
11. **Windows Server Core** — headless native.
12. **Konversi image** — `qemu-img`.
13. **Skrip provisioning**.
14. **Verifikasi**.
15. **Alternatif**: Windows Cloud Image (tidak resmi).

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 7.2.

---

## 7. Hubungan dengan Modul Lain

- **Fase 3 (libvirt)**: `virt-install` untuk Windows.
- **Fase 4 (Storage)**: disk virtio.
- **Fase 5 (Networking)**: network virtio.
- **Fase 6 (Security)**: hardening XML untuk Windows.
- **Modul 7.1 (cloud-init)**: konsep serupa dengan cloudbase-init.
- **Modul 7.3 (Skrip)**: skrip provisioning Windows.
- **Modul 7.4 (Troubleshooting)**: debugging Windows headless.
- **Modul 7.5 (Capstone)**: multi-OS.
- **Fase 8 (Expert)**: VFIO passthrough untuk GPU.

---

## 8. Referensi Lengkap

- Microsoft Docs: Unattend — https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs
- Microsoft Docs: Sysprep — https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--system-preparation--overview
- Microsoft Docs: WinRM — https://learn.microsoft.com/en-us/windows/win32/winrm/portal
- Microsoft Docs: OpenSSH — https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
- Virtio-win — https://github.com/virtio-win/virtio-win-pkg-scripts
- Virtio-win ISO — https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/
- Cloudbase-init — https://cloudbase.it/cloudbase-init/
- Cloudbase-init Docs — https://cloudbase-init.readthedocs.io/
- pywinrm — https://github.com/diyan/pywinrm
- chafa — https://hpjansson.org/chafa/
- jp2a — https://csl.name/jp2a/
- img2txt — https://manpages.debian.org/testing/caca-utils/img2txt.1.en.html
- libvirt Hyper-V — https://libvirt.org/formatdomain.html#hypervisor-features
- QEMU Monitor — https://www.qemu.org/docs/master/system/monitor.html
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt

---

## 9. Tips & Praktik Terbaik

1. **Gunakan Virtio-win ISO** untuk driver.
2. **Gunakan autounattend.xml** untuk otomasi.
3. **Aktifkan WinRM** di FirstLogonCommands.
4. **Aktifkan OpenSSH** jika butuh SSH.
5. **Gunakan cloudbase-init** untuk otomasi lanjutan.
6. **Gunakan Sysprep** untuk generalisasi.
7. **Gunakan `virsh screenshot`** untuk melihat layar.
8. **Gunakan `chafa`** untuk ASCII.
9. **Gunakan QEMU Monitor** untuk `sendkey`.
10. **Gunakan VNC** dengan `listen='127.0.0.1'`.
11. **Gunakan Hyper-V enlightenments** untuk performa.
12. **Gunakan `q35`** untuk chipset modern.
13. **Gunakan `cache='none'`** untuk keamanan.
14. **Gunakan `discard='unmap'`** untuk TRIM.
15. **Backup image** setelah instalasi.
16. **Dokumentasikan autounattend.xml**.
17. **Uji di VM terpisah** sebelum produksi.
18. **Monitor log** WinRM/SSH.
19. **Gunakan `pnputil`** untuk install driver.
20. **Gunakan `dism`** untuk image.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Windows tidak melihat disk | Driver virtio tidak di-load. | Tambahkan `DriverPaths`. |
| Instalasi gagal | autounattend.xml salah. | Validasi XML. |
| WinRM tidak jalan | Firewall. | `winrm quickconfig`. |
| SSH tidak jalan | Firewall. | `New-NetFirewallRule`. |
| Screenshot hitam | VM belum boot. | Tunggu. |
| Screenshot tidak bisa dibaca | PPM tidak didukung. | Konversi dengan `convert`. |
| VNC tidak bisa diakses | Listen address. | Gunakan `127.0.0.1`. |
| VM lambat | Tidak ada Hyper-V enlightenments. | Tambahkan `<hyperv>`. |
| Driver tidak terinstal | Path salah. | Cek `E:\amd64\w10`. |
| Sysprep gagal | Ada user login. | Logout dulu. |
| Cloudbase-init gagal | Konfigurasi salah. | Cek `cloudbase-init.conf`. |
| Image corrupt | Download gagal. | Verifikasi checksum. |
| QEMU Monitor tidak responsif | VM hang. | Restart. |
| `sendkey` tidak bekerja | Fokus salah. | Klik layar dulu. |
| `virsh screenshot` error | VM tidak jalan. | Start VM. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- VM Windows berjalan.
- `virsh screenshot` menghasilkan PPM.
- `chafa` menampilkan layar.
- Windows terinstal tanpa interaksi.
- WinRM bisa diakses.
- SSH bisa diakses (jika diaktifkan).
- Cloudbase-init berjalan (jika diinstal).
- Sysprep berhasil.
- Image bisa di-clone.
- Driver virtio terinstal.

**Troubleshooting:**
- Jika Windows tidak melihat disk: cek `DriverPaths`, cek virtio-win ISO.
- Jika autounattend.xml gagal: validasi XML, cek log `C:\Windows\Panther\`.
- Jika WinRM gagal: cek `winrm quickconfig`, cek firewall.
- Jika SSH gagal: cek `Add-WindowsCapability`, cek firewall.
- Jika screenshot hitam: tunggu boot, cek VNC.
- Jika VNC tidak bisa: cek `listen`, cek firewall host.
- Jika VM lambat: tambahkan Hyper-V enlightenments.
- Jika sysprep gagal: cek `setupact.log`, `setuperr.log`.
- Untuk debugging: `virsh console`, QEMU Monitor.
- Untuk log: `C:\Windows\Panther\`, `C:\Windows\Inf\`.

---

## 12. Latihan Mandiri

1. Download virtio-win ISO.
2. Buat autounattend.xml.
3. Buat ISO autounattend.
4. Buat VM Windows headless.
5. Screenshot dengan `virsh`.
6. Konversi dengan `chafa`.
7. Kirim `sendkey` dengan QEMU Monitor.
8. Aktifkan WinRM.
9. Uji WinRM dengan pywinrm.
10. Aktifkan OpenSSH.
11. Uji SSH.
12. Install cloudbase-init.
13. Uji cloudbase-init.
14. Sysprep.
15. Clone VM.
16. Konversi image.
17. Tambahkan Hyper-V enlightenments.
18. Uji performa.
19. Buat skrip provisioning.
20. Dokumentasikan.

---

## 13. Penutup Modul 7.2

Anda kini menguasai **Windows Guest Headless** — seni menjalankan Windows tanpa GUI di Arch Linux. Anda bisa:
- Membuat **autounattend.xml** untuk instalasi otomatis.
- Menggunakan **virtio-win ISO** untuk driver.
- Melihat layar dengan **`virsh screenshot`** dan **chafa**.
- Mengirim tombol dengan **QEMU Monitor**.
- Mengaktifkan **WinRM** dan **OpenSSH**.
- Menggunakan **cloudbase-init** untuk otomasi.
- Melakukan **Sysprep** untuk generalisasi.
- Membuat **skrip provisioning** Windows.

Ini adalah fondasi untuk **Modul 7.3 — Skrip Bash + libvirt Hooks + Unit systemd**, di mana kita akan membangun otomasi tingkat lanjut dengan skrip, hooks, dan systemd.

---

*Motivasi: Windows bukanlah tembok, melainkan pintu yang perlu kunci berbeda. Setelah Anda menemukan kuncinya, ia terbuka seperti pintu lainnya. Otomasi adalah kunci itu. Dan Anda baru saja menemukannya.*

---

# Modul 7.3 — Skrip Bash + libvirt Hooks + Unit systemd

## Mini-Daftar Isi Modul 7.3

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Skrip, Hooks & systemd
6. Audit Kurikulum: Tambahan untuk Modul 7.3
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 7.3

---

> *Motivasi: Skrip adalah tangan yang tak pernah lelah. Hook adalah refleks yang tak pernah terlambat. systemd adalah jantung yang tak pernah berhenti. Ketiganya bersama membuat VM Anda hidup secara mandiri.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Modul 7.3** adalah inti dari **otomasi tingkat lanjut** di Fase 7. Setelah Anda mengotomasi provisioning Linux (cloud-init) dan Windows (unattended), sekarang Anda belajar **mengikat semuanya** dengan:

- **Skrip Bash** — bahasa perekat yang memanggil `virsh`, `qemu-img`, `virt-install`, `cloud-localds`, dan alat lainnya.
- **libvirt Hooks** — skrip yang dipanggil **otomatis oleh libvirt** pada event tertentu (start, stop, migrate, dll). Hook memungkinkan Anda menjalankan aksi **sebelum** atau **sesudah** VM berubah state.
- **Unit systemd** — pengelola layanan yang memastikan VM **autostart**, **berurutan**, dan **tergantung** pada resource lain (network, storage).

**Peran dalam kurikulum:** Modul ini adalah **lem** yang menyatukan semua yang telah Anda pelajari. Tanpa skrip, Anda mengetik perintah berulang. Tanpa hooks, Anda tidak bisa merespons event VM. Tanpa systemd, VM tidak autostart dengan benar. Modul ini juga fondasi untuk:
- **Modul 7.4 (Drill Troubleshooting)**: skrip debugging.
- **Modul 7.5 (Capstone)**: infrastruktur 4+ VM dengan satu perintah.
- **Fase 8 (Expert)**: otomasi live migration, observability.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Bash sebagai Bahasa Perekat

Bash bukan bahasa terbaik untuk logika kompleks, tetapi ia **ada di mana-mana** dan **memanggil apa saja**. Filosofi Unix: **program kecil, pipa, teks**. Bash adalah **konduktor orkestra**.

**Filosofi:** *Bash bukan alat paling tajam, tetapi ia ada di setiap dapur.*

### 2.2. Idempotensi

Skrip yang baik bersifat **idempotent**: dijalankan sekali atau sepuluh kali, hasilnya sama. Caranya:
- Cek keberadaan file sebelum membuat.
- Cek status VM sebelum start.
- Gunakan `virsh define` yang menimpa definisi lama.
- Gunakan `--wait` dan `--noautoconsole` dengan benar.

**Filosofi:** *Sekali benar, selamanya benar.*

### 2.3. Error Handling

Skrip harus **berhenti saat error** (`set -e`), **menangani variabel kosong** (`set -u`), dan **membersihkan** (`trap`). Tanpa ini, skrip bisa merusak sistem.

**Filosofi:** *Lebih baik gagal cepat daripada sukses palsu.*

### 2.4. libvirt Hooks: Refleks Otomatis

**Hook** adalah skrip yang dijalankan libvirt pada event:
- `prepare` — sebelum VM mulai.
- `start` — setelah VM mulai.
- `started` — VM sudah berjalan.
- `stopped` — VM berhenti.
- `release` — setelah VM berhenti.
- `migrate` — migrasi.
- `restore` — restore.

Hook diletakkan di `/etc/libvirt/hooks/qemu` (satu skrip) atau `/etc/libvirt/hooks/qemu.d/` (banyak skrip).

**Filosofi:** *Hook adalah saraf. Ia merespons tanpa berpikir.*

### 2.5. systemd: Jantung Layanan

**systemd** mengelola layanan (unit). Untuk VM, kita bisa:
- **Autostart** VM dengan `virsh autostart`.
- **Membuat unit systemd** yang menjalankan `virsh start` saat boot.
- **Mengatur dependency** (network-online.target, libvirtd).
- **Restart otomatis** jika VM mati.

**Filosofi:** *systemd adalah jantung. Ia memompa kehidupan ke setiap layanan.*

### 2.6. Dependency Management

VM mungkin bergantung pada:
- **Network** (bridge, storage network).
- **Storage** (mount, pool).
- **VPN** (jika VM butuh akses khusus).
- **VM lain** (router VM harus start sebelum VM klien).

systemd menyediakan `After=`, `Requires=`, `Wants=`, `BindsTo=`.

**Filosofi:** *Tidak ada VM yang pulau. Semua terhubung.*

### 2.7. Logging dan Audit

Skrip dan hook harus **mencatat** apa yang dilakukan. Gunakan:
- `logger` — kirim ke syslog.
- `echo >> /var/log/...` — log sendiri.
- `systemd-cat` — kirim ke journal.
- `journalctl -u` — lihat log.

**Filosofi:** *Yang tidak dicatat, tidak terjadi.*

### 2.8. Keamanan Skrip

- **Jangan simpan password** di skrip. Gunakan secret libvirt, file permission 600, atau environment variable.
- **Validasi input**.
- **Batasi permission** (700 untuk skrip hook).
- **Jalankan sebagai user yang tepat**.

**Filosofi:** *Skrip adalah pedang. Pegang dengan benar.*

### 2.9. Filosofi Keseluruhan

- **Bash untuk orkestrasi.**
- **Hook untuk reaksi.**
- **systemd untuk kehidupan.**
- **Idempotensi untuk ketenangan.**
- **Logging untuk ingatan.**
- **Keamanan untuk tidur nyenyak.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Bash** | Bourne Again Shell. | |
| **shebang** | `#!/bin/bash`. | |
| **set -e** | Exit on error. | |
| **set -u** | Error on unset variable. | |
| **set -o pipefail** | Error on pipe failure. | |
| **trap** | Handler sinyal. | `trap cleanup EXIT` |
| **idempotent** | Dapat diulang. | |
| **libvirt hook** | Skrip event libvirt. | `/etc/libvirt/hooks/qemu` |
| **qemu.d** | Direktori hook. | `/etc/libvirt/hooks/qemu.d/` |
| **event** | Kejadian VM. | `start`, `stopped` |
| **systemd unit** | File layanan. | `/etc/systemd/system/vm.service` |
| **service** | Unit layanan. | |
| **target** | Grup unit. | `multi-user.target` |
| **After=** | Urutan. | |
| **Requires=** | Ketergantungan. | |
| **Wants=** | Ketergantungan lemah. | |
| **BindsTo=** | Ketergantungan kuat. | |
| **ExecStart=** | Perintah utama. | |
| **ExecStop=** | Perintah stop. | |
| **Restart=** | Kebijakan restart. | |
| **Type=** | Tipe service. | `oneshot`, `simple` |
| **RemainAfterExit=** | Tetap aktif. | |
| **systemctl** | Kontrol systemd. | |
| **virsh autostart** | Autostart libvirt. | |
| **virsh define** | Definisikan VM. | |
| **virsh start** | Jalankan VM. | |
| **virsh shutdown** | Matikan VM. | |
| **virsh destroy** | Paksa mati. | |
| **logger** | Kirim ke syslog. | |
| **systemd-cat** | Kirim ke journal. | |
| **journalctl** | Lihat log. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Kerangka Skrip Bash yang Baik

```bash
#!/bin/bash
#
# vm-provision.sh - Provisioning VM dengan libvirt
#

set -euo pipefail

# Konfigurasi
VM_NAME="${1:-arch-vm}"
VM_MEMORY="1024"
VM_VCPUS="2"
VM_DISK_SIZE="10G"
IMAGE_DIR="/var/lib/libvirt/images"
IMAGE_PATH="${IMAGE_DIR}/${VM_NAME}.qcow2"

# Fungsi logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/vm-provision.log
}

# Fungsi cleanup
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log "ERROR: Skrip gagal dengan exit code $exit_code"
    fi
    exit $exit_code
}
trap cleanup EXIT

# Fungsi cek perintah
require_cmd() {
    if ! command -v "$1" &>/dev/null; then
        log "ERROR: Perintah '$1' tidak ditemukan"
        exit 1
    fi
}

# Validasi
require_cmd virsh
require_cmd qemu-img
require_cmd virt-install

# Cek apakah VM sudah ada
if virsh dominfo "$VM_NAME" &>/dev/null; then
    log "VM $VM_NAME sudah ada. Menghapus..."
    virsh destroy "$VM_NAME" 2>/dev/null || true
    virsh undefine "$VM_NAME" --remove-all-storage 2>/dev/null || true
fi

# Buat disk
log "Membuat disk $IMAGE_PATH..."
qemu-img create -f qcow2 "$IMAGE_PATH" "$VM_DISK_SIZE"

# Buat VM
log "Membuat VM $VM_NAME..."
virt-install \
    --name "$VM_NAME" \
    --memory "$VM_MEMORY" \
    --vcpus "$VM_VCPUS" \
    --disk path="$IMAGE_PATH",format=qcow2,bus=virtio \
    --cdrom /var/lib/libvirt/images/arch.iso \
    --os-variant archlinux \
    --graphics none \
    --console pty,target_type=serial \
    --network network=default,model=virtio \
    --noautoconsole

log "VM $VM_NAME berhasil dibuat."
```

**Penjelasan kata demi kata:**
- `#!/bin/bash` — shebang, interpreter.
- `set -euo pipefail`:
  - `-e` — exit jika perintah gagal.
  - `-u` — error jika variabel tidak diset.
  - `-o pipefail` — error jika pipe gagal.
- `VM_NAME="${1:-arch-vm}"` — parameter pertama, default `arch-vm`.
- `log()` — fungsi logging.
  - `echo "[$(date ...)] $*"` — cetak dengan timestamp.
  - `tee -a` — tulis ke file dan stdout.
- `cleanup()` — fungsi cleanup.
  - `local exit_code=$?` — simpan exit code.
  - `trap cleanup EXIT` — panggil cleanup saat exit.
- `require_cmd()` — cek perintah.
  - `command -v` — cek keberadaan.
- `virsh dominfo` — cek VM.
- `virsh destroy` — matikan paksa.
- `virsh undefine --remove-all-storage` — hapus VM dan storage.
- `qemu-img create` — buat disk.
- `virt-install` — buat VM.

### 4.2. libvirt Hook: qemu

**File `/etc/libvirt/hooks/qemu`:**

```bash
#!/bin/bash
#
# /etc/libvirt/hooks/qemu - Hook untuk event QEMU/libvirt
#

set -euo pipefail

# Argumen:
# $1 = nama VM
# $2 = event (prepare, start, started, stopped, release, migrate, restore)
# $3 = sub-event (opsional)
# $4 = extra (opsional)

VM_NAME="$1"
EVENT="$2"
SUB_EVENT="${3:-}"
EXTRA="${4:-}"

LOG_FILE="/var/log/libvirt/hooks-qemu.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] VM=$VM_NAME EVENT=$EVENT SUB=$SUB_EVENT EXTRA=$EXTRA :: $*" >> "$LOG_FILE"
}

log "Hook dipanggil"

case "$EVENT" in
    prepare)
        log "Mempersiapkan VM..."
        # Contoh: buat direktori, set permission
        ;;
    start)
        log "VM akan start..."
        # Contoh: siapkan bridge, iptables
        ;;
    started)
        log "VM sudah start."
        # Contoh: kirim notifikasi
        ;;
    stopped)
        log "VM berhenti."
        # Contoh: cleanup resource
        ;;
    release)
        log "VM dilepas."
        # Contoh: hapus resource sementara
        ;;
    migrate)
        log "VM migrasi. Sub-event: $SUB_EVENT"
        # Contoh: update DNS
        ;;
    restore)
        log "VM restore."
        # Contoh: restore resource
        ;;
    *)
        log "Event tidak dikenal: $EVENT"
        ;;
esac

exit 0
```

**Penjelasan kata demi kata:**
- `$1` — nama VM.
- `$2` — event.
- `$3` — sub-event.
- `$4` — extra.
- `case "$EVENT" in` — percabangan event.
- `prepare` — sebelum start.
- `start` — saat start.
- `started` — setelah start.
- `stopped` — saat stop.
- `release` — setelah stop.
- `migrate` — saat migrasi.
- `restore` — saat restore.
- `exit 0` — sukses.

**Permission:**
```bash
sudo chmod 755 /etc/libvirt/hooks/qemu
sudo chown root:root /etc/libvirt/hooks/qemu
```

### 4.3. Hook dengan qemu.d

**Direktori `/etc/libvirt/hooks/qemu.d/`:**

```bash
sudo mkdir -p /etc/libvirt/hooks/qemu.d
```

**File `/etc/libvirt/hooks/qemu.d/arch-vm/started/01-notify.sh`:**

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="$1"
EVENT="$2"

if [ "$VM_NAME" = "arch-vm" ] && [ "$EVENT" = "started" ]; then
    logger -t libvirt-hook "VM arch-vm started"
    # Kirim email, notifikasi, dll.
fi

exit 0
```

**Penjelasan:**
- `qemu.d/` — direktori hook.
- `arch-vm/started/` — hook untuk VM tertentu.
- `01-notify.sh` — skrip urutan.
- `logger` — kirim ke syslog.

### 4.4. Unit systemd untuk VM

**File `/etc/systemd/system/vm-arch.service`:**

```ini
[Unit]
Description=Arch Linux VM
After=network-online.target libvirtd.service
Wants=network-online.target
Requires=libvirtd.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/virsh start arch-vm
ExecStop=/usr/bin/virsh shutdown arch-vm
TimeoutStartSec=300
TimeoutStopSec=300
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Penjelasan kata demi kata:**
- `[Unit]` — bagian unit.
  - `Description` — deskripsi.
  - `After` — start setelah network dan libvirtd.
  - `Wants` — keinginan lemah.
  - `Requires` — ketergantungan kuat.
- `[Service]` — bagian service.
  - `Type=oneshot` — jalankan sekali.
  - `RemainAfterExit=yes` — tetap aktif setelah exit.
  - `ExecStart` — perintah start.
  - `ExecStop` — perintah stop.
  - `TimeoutStartSec` — timeout start.
  - `TimeoutStopSec` — timeout stop.
  - `Restart=on-failure` — restart jika gagal.
  - `RestartSec=10` — jeda restart.
- `[Install]` — bagian install.
  - `WantedBy=multi-user.target` — target.

**Aktifkan:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now vm-arch.service
```

### 4.5. Unit systemd User untuk VM

**File `~/.config/systemd/user/vm-arch.service`:**

```ini
[Unit]
Description=Arch Linux VM (user)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/virsh -c qemu:///session start arch-vm
ExecStop=/usr/bin/virsh -c qemu:///session shutdown arch-vm
TimeoutStartSec=300
TimeoutStopSec=300

[Install]
WantedBy=default.target
```

**Aktifkan:**
```bash
systemctl --user daemon-reload
systemctl --user enable --now vm-arch.service
```

### 4.6. Hook + systemd: Autostart Berurutan

**Contoh: router VM harus start sebelum client VM.**

**File `/etc/systemd/system/vm-router.service`:**

```ini
[Unit]
Description=Router VM
After=network-online.target libvirtd.service
Requires=libvirtd.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/virsh start router-vm
ExecStop=/usr/bin/virsh shutdown router-vm
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
```

**File `/etc/systemd/system/vm-client.service`:**

```ini
[Unit]
Description=Client VM
After=vm-router.service
Requires=vm-router.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/virsh start client-vm
ExecStop=/usr/bin/virsh shutdown client-vm
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
```

**Penjelasan:**
- `After=vm-router.service` — client start setelah router.
- `Requires=vm-router.service` — client butuh router.

### 4.7. Hook untuk Network

**File `/etc/libvirt/hooks/qemu.d/router-vm/started/10-network.sh`:**

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="$1"
EVENT="$2"

if [ "$VM_NAME" = "router-vm" ] && [ "$EVENT" = "started" ]; then
    logger -t libvirt-hook "Router VM started, configuring network..."
    # Tambahkan route, iptables, dll.
    ip route add 192.168.100.0/24 via 192.168.122.2 || true
fi

exit 0
```

### 4.8. Hook untuk Cleanup

**File `/etc/libvirt/hooks/qemu.d/arch-vm/stopped/90-cleanup.sh`:**

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="$1"
EVENT="$2"

if [ "$VM_NAME" = "arch-vm" ] && [ "$EVENT" = "stopped" ]; then
    logger -t libvirt-hook "Arch VM stopped, cleaning up..."
    # Hapus file sementara, unmount, dll.
    rm -f /tmp/arch-vm-*.sock || true
fi

exit 0
```

### 4.9. Skrip Provisioning Lengkap dengan Hook

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="arch-vm"
IMAGE="/var/lib/libvirt/images/${VM_NAME}.qcow2"
USER_DATA="/tmp/${VM_NAME}-user-data"
META_DATA="/tmp/${VM_NAME}-meta-data"
SEED="/tmp/${VM_NAME}-seed.img"

log() { echo "[$(date '+%F %T')] $*" | tee -a /var/log/vm-provision.log; }

# 1. Buat user-data
cat > "$USER_DATA" <<'EOF'
#cloud-config
hostname: arch-vm
users:
  - name: user
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2E... user@host
package_update: true
packages:
  - vim
  - git
runcmd:
  - systemctl enable --now sshd
EOF

# 2. Buat meta-data
cat > "$META_DATA" <<EOF
instance-id: ${VM_NAME}-001
local-hostname: ${VM_NAME}
EOF

# 3. Buat seed
cloud-localds "$SEED" "$USER_DATA" "$META_DATA"

# 4. Buat VM
virt-install \
    --name "$VM_NAME" \
    --memory 1024 \
    --vcpus 2 \
    --disk path="$IMAGE",size=10,format=qcow2,bus=virtio \
    --disk path="$SEED",device=cdrom,readonly=on \
    --os-variant archlinux \
    --graphics none \
    --console pty,target_type=serial \
    --network network=default,model=virtio \
    --import \
    --noautoconsole

# 5. Autostart
virsh autostart "$VM_NAME"

log "VM $VM_NAME selesai dibuat dan autostart diaktifkan."
```

**Penjelasan:**
- Skrip membuat VM dengan cloud-init, lalu autostart.

### 4.10. Hook untuk Logging

**File `/etc/libvirt/hooks/qemu`:**

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="$1"
EVENT="$2"

logger -t libvirt-hook "VM=$VM_NAME EVENT=$EVENT"
echo "[$(date '+%F %T')] VM=$VM_NAME EVENT=$EVENT" >> /var/log/libvirt/hooks.log

exit 0
```

**Penjelasan:**
- `logger` — kirim ke syslog.
- `echo >>` — tulis ke file.

### 4.11. Debug Hook

```bash
# Lihat log hook
sudo tail -f /var/log/libvirt/hooks.log
sudo journalctl -t libvirt-hook -f

# Test hook manual
sudo /etc/libvirt/hooks/qemu arch-vm started

# Cek permission
ls -l /etc/libvirt/hooks/qemu
```

**Penjelasan:**
- `tail -f` — ikuti log.
- `journalctl -t` — filter tag.
- Test manual.

### 4.12. systemd Timer untuk Backup

**File `/etc/systemd/system/vm-backup.service`:**

```ini
[Unit]
Description=Backup VM
After=libvirtd.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/vm-backup.sh
```

**File `/etc/systemd/system/vm-backup.timer`:**

```ini
[Unit]
Description=Backup VM Timer

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

**Penjelasan:**
- `OnCalendar=daily` — setiap hari.
- `Persistent=true` — jalankan jika terlewat.

**Aktifkan:**
```bash
sudo systemctl enable --now vm-backup.timer
```

### 4.13. Skrip Backup VM

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="arch-vm"
BACKUP_DIR="/backup/vm"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${VM_NAME}-${DATE}.qcow2"

mkdir -p "$BACKUP_DIR"

# Backup dengan blockcopy
virsh blockcopy "$VM_NAME" vda "$BACKUP_FILE" --wait --verbose

# Hash
sha256sum "$BACKUP_FILE" > "${BACKUP_FILE}.sha256"

# Hapus backup lama (simpan 7 hari)
find "$BACKUP_DIR" -name "*.qcow2" -mtime +7 -delete

logger -t vm-backup "Backup $VM_NAME selesai: $BACKUP_FILE"
```

**Penjelasan:**
- `virsh blockcopy` — copy disk live.
- `sha256sum` — hash.
- `find -mtime +7 -delete` — hapus lama.

### 4.14. Contoh Hook untuk Migrasi

**File `/etc/libvirt/hooks/qemu.d/arch-vm/migrate/10-dns.sh`:**

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="$1"
EVENT="$2"
SUB_EVENT="$3"

if [ "$VM_NAME" = "arch-vm" ] && [ "$EVENT" = "migrate" ]; then
    logger -t libvirt-hook "Migrasi $VM_NAME: $SUB_EVENT"
    # Update DNS, load balancer, dll.
fi

exit 0
```

### 4.15. Verifikasi Hook dan systemd

```bash
# 1. Cek hook
ls -l /etc/libvirt/hooks/qemu
ls -R /etc/libvirt/hooks/qemu.d/

# 2. Test hook
sudo /etc/libvirt/hooks/qemu arch-vm started
sudo tail -5 /var/log/libvirt/hooks.log

# 3. Cek systemd
systemctl status vm-arch.service
systemctl list-units 'vm-*'

# 4. Cek autostart
virsh list --autostart

# 5. Cek log
journalctl -u vm-arch.service
journalctl -t libvirt-hook
```

---

## 5. Diagram Arsitektur Skrip, Hooks & systemd

### 5.1. Alur Hook

```
VM Event
  |
  v
+-------------------+
|  libvirt          |
+-------------------+
  |
  | panggil hook
  v
+-------------------+
|  /etc/libvirt/hooks/qemu |
+-------------------+
  |
  | $1=VM, $2=EVENT
  v
+-------------------+
|  qemu.d/          |
|  ├── VM1/         |
|  │   ├── start/   |
|  │   └── stopped/ |
|  └── VM2/         |
+-------------------+
  |
  v
+-------------------+
|  Aksi             |
+-------------------+
```

### 5.2. Alur systemd

```
Boot
  |
  v
+-------------------+
|  systemd          |
+-------------------+
  |
  | start unit
  v
+-------------------+
|  vm-router.service|
+-------------------+
  |
  | ExecStart
  v
+-------------------+
|  virsh start      |
+-------------------+
  |
  v
+-------------------+
|  VM Router        |
+-------------------+
  |
  | After=
  v
+-------------------+
|  vm-client.service|
+-------------------+
  |
  v
+-------------------+
|  VM Client        |
+-------------------+
```

### 5.3. Integrasi Skrip + Hook + systemd

```
+-------------------+
|  Skrip Provision  |
+-------------------+
          |
          | virsh define
          v
+-------------------+
|  libvirt          |
+-------------------+
          |
          | hook
          v
+-------------------+
|  /etc/libvirt/hooks/qemu |
+-------------------+
          |
          | systemd
          v
+-------------------+
|  vm-arch.service  |
+-------------------+
          |
          | virsh start
          v
+-------------------+
|  VM               |
+-------------------+
```

### 5.4. Pohon Keputusan Autostart

```
Apakah VM perlu autostart?
├── Ya → Apakah butuh dependency?
│   ├── Ya → systemd unit
│   └── Tidak → virsh autostart
└── Tidak → Manual
```

### 5.5. Alur Hook Lifecycle

```
prepare → start → started → stopped → release
   |         |        |          |         |
   v         v        v          v         v
 Hook      Hook     Hook       Hook      Hook
```

### 5.6. Logging Flow

```
Skrip/Hook
  |
  +-- logger → syslog → journalctl
  +-- echo >> /var/log/...
  +-- systemd-cat → journal
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 7.3

Kurikulum asli menyebut:
```bash
# /etc/libvirt/hooks/qemu
#!/bin/bash
if [ "$1" = "arch-vm" ] && [ "$2" = "started" ]; then
  # aksi
fi
```
> Hook berjalan, VM autostart berurutan.

Kita akan menambahkan:
1. **Kerangka Bash yang baik**: `set -euo pipefail`, `trap`, fungsi.
2. **Idempotensi**: cek VM, cek file.
3. **Error handling**: `require_cmd`, `cleanup`.
4. **libvirt hook**: `/etc/libvirt/hooks/qemu`, `qemu.d/`.
5. **Event hook**: `prepare`, `start`, `started`, `stopped`, `release`, `migrate`, `restore`.
6. **Hook per VM**: `qemu.d/arch-vm/started/`.
7. **Unit systemd**: `vm-arch.service`, `Type=oneshot`, `RemainAfterExit`.
8. **Dependency**: `After`, `Requires`, `Wants`.
9. **Autostart berurutan**: router → client.
10. **systemd user**: `~/.config/systemd/user/`.
11. **Timer systemd**: backup harian.
12. **Logging**: `logger`, `journalctl`, `systemd-cat`.
13. **Keamanan skrip**: permission, secret.
14. **Debugging hook**: test manual, log.
15. **Integrasi dengan cloud-init**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 7.3.

---

## 7. Hubungan dengan Modul Lain

- **Modul 7.1 (cloud-init)**: skrip provisioning memanggil cloud-init.
- **Modul 7.2 (Windows)**: skrip provisioning Windows.
- **Modul 7.4 (Troubleshooting)**: skrip debugging.
- **Modul 7.5 (Capstone)**: skrip idempotent, systemd.
- **Fase 3 (libvirt)**: `virsh`, `virt-install`.
- **Fase 6 (Security)**: hook untuk audit.
- **Fase 8 (Expert)**: hook untuk migrasi, observability.

---

## 8. Referensi Lengkap

- libvirt Hooks — https://libvirt.org/hooks.html
- libvirt Hook qemu — https://libvirt.org/hooks.html#qemu
- systemd.service — https://www.freedesktop.org/software/systemd/man/systemd.service.html
- systemd.unit — https://www.freedesktop.org/software/systemd/man/systemd.unit.html
- systemd.timer — https://www.freedesktop.org/software/systemd/man/systemd.timer.html
- Bash Manual — https://www.gnu.org/software/bash/manual/
- Bash Hackers Wiki — https://wiki.bash-hackers.org/
- Google Shell Style Guide — https://google.github.io/styleguide/shellguide.html
- ShellCheck — https://www.shellcheck.net/
- Arch Wiki: systemd — https://wiki.archlinux.org/title/Systemd
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- virsh man page — https://libvirt.org/manpages/virsh.html
- logger man page — https://man7.org/linux/man-pages/man1/logger.1.html
- systemd-cat — https://www.freedesktop.org/software/systemd/man/systemd-cat.html

---

## 9. Tips & Praktik Terbaik

1. **Gunakan `set -euo pipefail`** di setiap skrip.
2. **Gunakan `trap cleanup EXIT`**.
3. **Buat skrip idempotent**.
4. **Validasi input**.
5. **Gunakan fungsi** untuk reusable.
6. **Log setiap aksi**.
7. **Jangan simpan password** di skrip.
8. **Permission 700** untuk hook.
9. **Test hook manual** sebelum production.
10. **Gunakan `virsh autostart`** untuk sederhana.
11. **Gunakan systemd unit** untuk dependency.
12. **Gunakan `After=` dan `Requires=`**.
13. **Gunakan timer** untuk backup.
14. **Gunakan `shellcheck`** untuk validasi.
15. **Dokumentasikan skrip**.
16. **Simpan skrip di Git**.
17. **Gunakan `logger`** untuk audit.
18. **Pantau log hook**.
19. **Hati-hati dengan `virsh destroy`**.
20. **Backup sebelum perubahan**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Hook tidak jalan | Permission salah. | `chmod 755`. |
| Hook error | `set -e` tanpa penanganan. | Tambah `|| true`. |
| VM tidak autostart | Tidak enable. | `systemctl enable`. |
| systemd unit gagal | Path virsh salah. | Gunakan `/usr/bin/virsh`. |
| Dependency gagal | `After` salah. | Cek `systemctl list-dependencies`. |
| Skrip tidak idempotent | Tidak cek VM. | Cek `virsh dominfo`. |
| Log tidak muncul | `logger` tidak ada. | Install `util-linux`. |
| Hook lambat | Skrip berat. | Optimasi. |
| Race condition | Hook paralel. | Gunakan lock. |
| Secret bocor | Password di skrip. | Gunakan secret libvirt. |
| `virsh destroy` merusak | Tidak ada cleanup. | Gunakan `shutdown`. |
| Timer tidak jalan | Tidak enable. | `systemctl enable --now`. |
| User service gagal | Lingkungan user. | `systemctl --user`. |
| Hook tidak support | Libvirt versi lama. | Update. |
| Log penuh | Tidak ada rotasi. | Logrotate. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- Skrip berjalan tanpa error.
- `shellcheck` tidak ada error.
- Hook terpanggil saat VM start/stop.
- Log hook muncul di `/var/log/libvirt/hooks.log`.
- `systemctl status vm-arch.service` aktif.
- VM autostart berurutan.
- `virsh list --autostart` menampilkan VM.
- Timer backup berjalan.
- Log systemd bersih.

**Troubleshooting:**
- Jika hook tidak jalan: cek permission, cek path.
- Jika hook error: cek log, test manual.
- Jika systemd gagal: `systemctl status`, `journalctl -u`.
- Jika VM tidak start: cek `virsh start` manual.
- Jika dependency gagal: cek `After`, `Requires`.
- Jika skrip gagal: `bash -x script.sh`.
- Jika log tidak ada: cek `logger`, cek rsyslog.
- Untuk debugging: `journalctl -t libvirt-hook`, `tail -f`.
- Untuk audit: `ausearch`, `aureport`.

---

## 12. Latihan Mandiri

1. Buat skrip provisioning VM.
2. Tambahkan `set -euo pipefail`.
3. Tambahkan fungsi logging.
4. Tambahkan `trap cleanup`.
5. Buat hook `/etc/libvirt/hooks/qemu`.
6. Test hook manual.
7. Buat hook di `qemu.d/`.
8. Buat unit systemd untuk VM.
9. Enable dan start.
10. Buat dependency router → client.
11. Buat timer backup.
12. Buat skrip backup.
13. Uji backup.
14. Uji restore.
15. Tambahkan logging ke hook.
16. Gunakan `shellcheck`.
17. Dokumentasikan.
18. Buat Git repo.
19. Uji idempotensi.
20. Tulis ringkasan.

---

## 13. Penutup Modul 7.3

Anda kini menguasai **Skrip Bash + libvirt Hooks + Unit systemd** — tiga pilar otomasi tingkat lanjut. Anda bisa:
- Menulis **skrip Bash** yang idempotent, aman, dan terlog.
- Membuat **libvirt hooks** untuk merespons event VM.
- Membuat **unit systemd** untuk autostart, dependency, dan timer.
- Mengintegrasikan **cloud-init**, **Windows unattended**, dan **otomasi**.
- Melakukan **debugging** dan **audit**.

Ini adalah fondasi untuk **Modul 7.4 — Drill Troubleshooting**, di mana kita akan melatih skenario kegagalan dan solusinya.

---

*Motivasi: Otomasi sejati bukan tentang mengetik lebih cepat, tetapi tentang membuat sistem yang bekerja saat Anda tidur. Skrip adalah tangan, hook adalah refleks, systemd adalah jantung. Ketiganya membuat VM Anda hidup sendiri.*

---

# Modul 7.4 — Drill Troubleshooting

## Mini-Daftar Isi Modul 7.4

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Troubleshooting
6. Audit Kurikulum: Tambahan untuk Modul 7.4
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 7.4

---

> *Motivasi: Kegagalan bukan musuh. Ia adalah guru yang paling jujur. Setiap error adalah pelajaran, setiap crash adalah peta. Yang mahir bukan yang tidak pernah gagal, tetapi yang tahu cara bangkit.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Drill Troubleshooting** adalah **latihan terstruktur** menghadapi **skenario kegagalan** yang umum terjadi pada infrastruktur VM. Ini bukan tentang menghafal solusi, tetapi tentang **mengembangkan intuisi** dan **metodologi** untuk mendiagnosis masalah apa pun.

Kurikulum asli menyebut **5 skenario**:
1. Boot gagal.
2. Disk penuh.
3. Network mati.
4. VM hang.
5. QMP tidak responsif.

Kita akan memperluas menjadi **12 skenario** yang mencakup:
- **Boot**: kernel panic, initramfs rusak, bootloader hilang, disk tidak terdeteksi.
- **Storage**: disk penuh, image corrupt, snapshot chain rusak, permission.
- **Network**: interface tidak muncul, IP tidak didapat, DNS gagal, firewall blokir.
- **Runtime**: VM hang, QEMU crash, OOM, CPU starvation.
- **Manajemen**: QMP tidak responsif, libvirt error, socket hilang.
- **Keamanan**: AppArmor denial, seccomp block, permission DAC.

**Peran dalam kurikulum:** Modul ini adalah **ujian kemandirian**. Setelah Anda membangun (Fase 1–6) dan mengotomasi (7.1–7.3), sekarang Anda belajar **memperbaiki**. Ini adalah keterampilan yang membedakan **operator** dari **engineer**. Modul ini juga fondasi untuk:
- **Modul 7.5 (Capstone)**: skenario troubleshooting dalam proyek.
- **Fase 8 (Expert)**: debugging live migration, passthrough, observability.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Metodologi Troubleshooting

**Metodologi** adalah kunci. Tanpa metodologi, Anda menebak-nebak. Dengan metodologi, Anda **sistematis**. Metodologi yang kita gunakan:

1. **Identifikasi**: apa gejala? kapan terjadi? apa yang berubah?
2. **Isolasi**: di lapisan mana masalah? (VM, QEMU, libvirt, kernel, hardware)
3. **Hipotesis**: apa penyebab paling mungkin?
4. **Uji**: buktikan atau bantah hipotesis.
5. **Perbaikan**: terapkan solusi.
6. **Verifikasi**: pastikan masalah selesai.
7. **Dokumentasi**: catat untuk masa depan.

**Filosofi:** *Troubleshooting adalah sains. Hipotesis, uji, kesimpulan.*

### 2.2. Divide and Conquer

**Bagi masalah** menjadi bagian kecil. Jika VM tidak boot, apakah:
- **Firmware** (OVMF/BIOS) yang gagal?
- **Bootloader** (GRUB/systemd-boot) yang hilang?
- **Kernel** yang panic?
- **Initramfs** yang rusak?
- **Root filesystem** yang tidak bisa di-mount?

Setiap lapisan diuji terpisah.

**Filosofi:** *Masalah besar adalah kumpulan masalah kecil.*

### 2.3. Layered Debugging

VM adalah **tumpukan lapisan**:
```
+-------------------+
|  Guest OS         |
+-------------------+
|  Kernel Guest     |
+-------------------+
|  QEMU             |
+-------------------+
|  libvirt          |
+-------------------+
|  Kernel Host      |
+-------------------+
|  Hardware         |
+-------------------+
```

Debug dari **bawah ke atas** atau **atas ke bawah**. Jangan lompat.

**Filosofi:** *Setiap lapisan punya bahasa sendiri. Dengarkan.*

### 2.4. Log adalah Sahabat

**Log** adalah sumber kebenaran. Tanpa log, Anda buta. Sumber log:
- **`journalctl`** — systemd, kernel.
- **`/var/log/libvirt/`** — libvirt.
- **`/var/log/libvirt/qemu/`** — QEMU per VM.
- **`/var/log/audit/`** — audit.
- **`dmesg`** — kernel ring buffer.
- **QEMU log** — `-D` atau `<log>`.
- **Serial console** — `virsh console`.

**Filosofi:** *Log adalah memori sistem. Bacalah sebelum menebak.*

### 2.5. Reproduksi

**Reproduksi** masalah adalah langkah pertama. Jika tidak bisa direproduksi, sulit diperbaiki. Catat:
- **Kapan** terjadi.
- **Apa** yang dilakukan sebelumnya.
- **Bagaimana** mereproduksi.
- **Environment** (host, VM, versi).

**Filosofi:** *Yang tidak bisa direproduksi, tidak bisa diperbaiki.*

### 2.6. Perubahan Terakhir

**Pertanyaan kunci**: apa yang berubah? 90% masalah muncul setelah perubahan:
- Update paket.
- Edit XML.
- Ubah network.
- Tambah hook.
- Ubah firewall.

**Filosofi:** *Cari perubahan, temukan masalah.*

### 2.7. Minimal Reproduksi

**Sederhanakan** kasus. Jika VM gagal boot dengan 10 perangkat, coba dengan 1. Jika gagal dengan network, coba tanpa network. **Isolasi variabel**.

**Filosofi:** *Sederhanakan sampai masalah terlihat.*

### 2.8. Dokumentasi

**Catat** setiap masalah dan solusi. Buat **runbook**. Ini akan menyelamatkan Anda di masa depan.

**Filosofi:** *Yang tidak dicatat, akan diulang.*

### 2.9. Jangan Panik

**Panik** adalah musuh. **Tenang**, **sistematis**, **sabar**. VM yang crash bukan akhir dunia. Backup ada.

**Filosofi:** *Kepala dingin, tangan terampil.*

### 2.10. Filosofi Keseluruhan

- **Metodologi dulu, tebakan kemudian.**
- **Log adalah kebenaran.**
- **Isolasi lapisan.**
- **Cari perubahan.**
- **Sederhanakan.**
- **Dokumentasikan.**
- **Jangan panik.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Troubleshooting** | Pemecahan masalah. | |
| **Diagnosis** | Identifikasi masalah. | |
| **Root cause** | Penyebab utama. | |
| **Symptom** | Gejala. | |
| **Reproduce** | Ulangi masalah. | |
| **Log** | Catatan kejadian. | |
| **dmesg** | Kernel ring buffer. | |
| **journalctl** | Log systemd. | |
| **strace** | Trace syscall. | |
| **ltrace** | Trace library. | |
| **gdb** | Debugger. | |
| **perf** | Profiler. | |
| **bpftrace** | Tracing BPF. | |
| **tcpdump** | Capture network. | |
| **wireshark** | Analisis network. | |
| **virsh** | CLI libvirt. | |
| **QMP** | QEMU Machine Protocol. | |
| **HMP** | Human Monitor Protocol. | |
| **qemu-monitor-command** | Kirim perintah QMP/HMP. | |
| **screendump** | Screenshot QEMU. | |
| **sendkey** | Kirim tombol. | |
| **info status** | Status QEMU. | |
| **blockdev** | Blok device. | |
| **info block** | Info block. | |
| **info network** | Info network. | |
| **snapshot** | Snapshot. | |
| **blockcommit** | Commit snapshot. | |
| **blockpull** | Pull snapshot. | |
| **fsck** | Filesystem check. | |
| **e2fsck** | Ext filesystem check. | |
| **xfs_repair** | XFS repair. | |
| **btrfs check** | Btrfs check. | |
| **qemu-img check** | Cek image. | |
| **qemu-img repair** | Perbaiki image. | |
| **guestfish** | Edit disk offline. | |
| **virt-rescue** | Rescue VM. | |
| **chroot** | Ganti root. | |
| **initramfs** | Initial RAM filesystem. | |
| **mkinitcpio** | Buat initramfs. | |
| **dracut** | Buat initramfs. | |
| **GRUB** | Bootloader. | |
| **systemd-boot** | Bootloader. | |
| **UEFI** | Firmware. | |
| **OVMF** | UEFI untuk QEMU. | |
| **SeaBIOS** | BIOS untuk QEMU. | |
| **kernel panic** | Kernel crash. | |
| **OOM** | Out of Memory. | |
| **hung task** | Task macet. | |
| **soft lockup** | CPU macet. | |
| **hard lockup** | CPU macet parah. | |
| **rcu stall** | RCU macet. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Skenario 1: Boot Gagal — Kernel Panic

**Gejala:** VM tidak boot, layar menampilkan "Kernel panic - not syncing".

**Diagnosis:**

```bash
# 1. Lihat console
virsh console arch-vm
# atau
virsh screenshot arch-vm /tmp/screen.ppm
chafa /tmp/screen.ppm

# 2. Cek log QEMU
tail -50 /var/log/libvirt/qemu/arch-vm.log

# 3. Cek XML
virsh dumpxml arch-vm | grep -A 5 '<os>'
```

**Penyebab umum:**
- Kernel tidak ditemukan.
- Initramfs rusak.
- Root filesystem tidak bisa di-mount.
- Driver virtio tidak ada di initramfs.

**Solusi:**

```bash
# Boot dengan live ISO
virsh start arch-vm --cdrom /var/lib/libvirt/images/arch.iso

# Mount disk
mkdir -p /mnt/arch
mount /dev/vda1 /mnt/arch

# Chroot
arch-chroot /mnt/arch

# Regenerate initramfs
mkinitcpio -P

# Cek bootloader
grub-mkconfig -o /boot/grub/grub.cfg
# atau
bootctl update

exit
umount /mnt/arch
reboot
```

**Penjelasan kata demi kata:**
- `virsh console` — akses console.
- `virsh screenshot` — screenshot.
- `tail -50` — 50 baris terakhir.
- `virsh dumpxml` — XML VM.
- `mount /dev/vda1 /mnt/arch` — mount partisi.
- `arch-chroot` — chroot ke Arch.
- `mkinitcpio -P` — regenerate initramfs.
- `grub-mkconfig` — regenerate GRUB config.
- `bootctl update` — update systemd-boot.

**Alternatif dengan `guestfish`:**
```bash
guestfish --rw -a /var/lib/libvirt/images/arch-vm.qcow2 -i
><fs> ll /boot
><fs> cat /etc/fstab
><fs> exit
```

**Alternatif dengan `virt-rescue`:**
```bash
virt-rescue -a /var/lib/libvirt/images/arch-vm.qcow2
# Di dalam rescue:
mount /dev/vda1 /mnt
chroot /mnt
mkinitcpio -P
exit
```

### 4.2. Skenario 2: Disk Penuh

**Gejala:** VM tidak bisa write, error "No space left on device".

**Diagnosis:**

```bash
# Di guest
df -h
du -sh /* 2>/dev/null | sort -h

# Di host
qemu-img info /var/lib/libvirt/images/arch-vm.qcow2
du -h /var/lib/libvirt/images/arch-vm.qcow2
```

**Penyebab umum:**
- Image qcow2 tidak di-*resize*.
- Log penuh.
- Snapshot menumpuk.
- File besar.

**Solusi:**

```bash
# 1. Cek ukuran virtual vs fisik
qemu-img info arch-vm.qcow2

# 2. Resize disk
qemu-img resize arch-vm.qcow2 +10G

# 3. Di guest, resize partisi
# Untuk ext4:
growpart /dev/vda 1
resize2fs /dev/vda1

# Untuk LVM:
pvresize /dev/vda1
lvextend -l +100%FREE /dev/vg0/root
resize2fs /dev/vg0/root

# 4. Bersihkan
# Di guest:
journalctl --vacuum-size=100M
rm -rf /var/cache/pacman/pkg/*
docker system prune -af  # jika ada
```

**Penjelasan:**
- `qemu-img resize` — resize image.
- `growpart` — resize partisi.
- `resize2fs` — resize filesystem.
- `pvresize`, `lvextend` — LVM.
- `journalctl --vacuum-size` — bersihkan log.

**Alternatif:**
```bash
# Trim
fstrim -av

# Compact qcow2
qemu-img convert -O qcow2 -c arch-vm.qcow2 arch-vm-compact.qcow2
```

### 4.3. Skenario 3: Network Mati

**Gejala:** VM tidak bisa ping, tidak dapat IP.

**Diagnosis:**

```bash
# 1. Cek interface di host
virsh domiflist arch-vm
ip link show
bridge link

# 2. Cek interface di guest
# Di guest:
ip a
ip r
cat /etc/resolv.conf

# 3. Cek network libvirt
virsh net-list --all
virsh net-info default
virsh net-dumpxml default

# 4. Cek DHCP
virsh net-dhcp-leases default

# 5. Cek firewall
sudo nft list ruleset
sudo iptables -L -n -v
```

**Penyebab umum:**
- Network libvirt tidak aktif.
- Bridge tidak ada.
- Firewall blokir.
- DHCP gagal.
- Driver virtio tidak ada.

**Solusi:**

```bash
# 1. Start network
virsh net-start default
virsh net-autostart default

# 2. Restart network
virsh net-destroy default
virsh net-start default

# 3. Cek bridge
ip link show virbr0
brctl show

# 4. Debug dengan tcpdump
sudo tcpdump -i virbr0 -n
sudo tcpdump -i vnet0 -n

# 5. Cek DNS
# Di guest:
cat /etc/resolv.conf
nslookup google.com 1.1.1.1

# 6. Manual IP (jika DHCP gagal)
# Di guest:
ip addr add 192.168.122.100/24 dev ens3
ip route add default via 192.168.122.1
echo "nameserver 1.1.1.1" > /etc/resolv.conf
```

**Penjelasan:**
- `virsh net-list` — daftar network.
- `virsh net-start` — start network.
- `virsh net-dhcp-leases` — lihat lease.
- `tcpdump` — capture paket.
- `ip addr add` — set IP manual.

**Alternatif:**
```bash
# Recreate network
virsh net-undefine default
virsh net-define /usr/share/libvirt/networks/default.xml
virsh net-start default
```

### 4.4. Skenario 4: VM Hang

**Gejala:** VM tidak responsif, console tidak muncul, CPU 100%.

**Diagnosis:**

```bash
# 1. Cek status
virsh list --all
virsh domstate arch-vm
virsh domstats arch-vm

# 2. Cek proses QEMU
ps aux | grep qemu-system

# 3. Cek CPU/memori
top -p $(pgrep -f qemu-system-x86_64)
htop

# 4. Cek log
tail -100 /var/log/libvirt/qemu/arch-vm.log

# 5. Cek dmesg host
dmesg | tail -50
journalctl -k | tail -50

# 6. Cek hung task
cat /proc/$(pgrep -f qemu-system-x86_64)/stack
cat /proc/$(pgrep -f qemu-system-x86_64)/status
```

**Penyebab umum:**
- Deadlock di guest.
- OOM.
- Disk I/O lambat.
- CPU starvation.
- Bug QEMU.

**Solusi:**

```bash
# 1. Kirim NMI (Non-Maskable Interrupt) untuk dump
virsh inject-nmi arch-vm

# 2. Screenshot
virsh screenshot arch-vm /tmp/screen.ppm
chafa /tmp/screen.ppm

# 3. Coba shutdown graceful
virsh shutdown arch-vm

# 4. Jika gagal, destroy
virsh destroy arch-vm

# 5. Cek OOM
dmesg | grep -i oom
journalctl -k | grep -i oom

# 6. Cek hung task
dmesg | grep -i "hung task"
dmesg | grep -i "soft lockup"

# 7. Restart
virsh start arch-vm
```

**Penjelasan:**
- `virsh inject-nmi` — kirim NMI (untuk crash dump).
- `virsh shutdown` — shutdown graceful.
- `virsh destroy` — paksa mati.
- `dmesg | grep -i oom` — cek OOM.

**Debug dengan GDB:**
```bash
# Attach GDB ke QEMU
sudo gdb -p $(pgrep -f qemu-system-x86_64)
(gdb) bt
(gdb) info threads
(gdb) detach
(gdb) quit
```

### 4.5. Skenario 5: QMP Tidak Responsif

**Gejala:** `virsh` tidak bisa konek, QMP socket tidak merespons.

**Diagnosis:**

```bash
# 1. Cek socket
ls -la /var/lib/libvirt/qemu/*.monitor
ls -la /run/libvirt/qemu/*.sock

# 2. Cek proses QEMU
ps aux | grep qemu-system

# 3. Cek dengan socat
sudo socat - UNIX-CONNECT:/var/lib/libvirt/qemu/arch-vm.monitor
{"execute": "qmp_capabilities"}
{"execute": "query-status"}
```

**Penyebab umum:**
- QEMU hang.
- Socket permission.
- Libvirt daemon mati.
- QMP port konflik.

**Solusi:**

```bash
# 1. Restart libvirtd
sudo systemctl restart virtqemud.socket
sudo systemctl restart libvirtd

# 2. Cek status
systemctl status virtqemud
journalctl -u virtqemud --since "10 min ago"

# 3. Jika QEMU hang, destroy
virsh destroy arch-vm

# 4. Restart VM
virsh start arch-vm

# 5. Cek socket
ls -la /var/lib/libvirt/qemu/
```

### 4.6. Skenario 6: Image Corrupt

**Gejala:** QEMU tidak bisa buka image, error "Invalid image".

**Diagnosis:**

```bash
# 1. Cek image
qemu-img info arch-vm.qcow2
qemu-img check arch-vm.qcow2

# 2. Cek log
tail -50 /var/log/libvirt/qemu/arch-vm.log
dmesg | grep -i qcow2
```

**Penyebab umum:**
- Image corrupt karena crash.
- Snapshot chain rusak.
- Disk penuh saat write.
- Bit rot.

**Solusi:**

```bash
# 1. Coba repair
qemu-img check -r all arch-vm.qcow2

# 2. Jika gagal, restore dari backup
cp /backup/arch-vm.qcow2 /var/lib/libvirt/images/arch-vm.qcow2

# 3. Jika tidak ada backup, coba convert
qemu-img convert -f qcow2 -O qcow2 arch-vm.qcow2 arch-vm-fixed.qcow2

# 4. Cek snapshot
qemu-img snapshot -l arch-vm.qcow2
```

**Penjelasan:**
- `qemu-img check -r all` — repair.
- `qemu-img convert` — convert (bisa memperbaiki).
- `qemu-img snapshot -l` — daftar snapshot.

### 4.7. Skenario 7: AppArmor Denial

**Gejala:** VM tidak bisa akses file, log AppArmor muncul.

**Diagnosis:**

```bash
# 1. Cek log
sudo dmesg | grep -i apparmor
sudo journalctl -k | grep -i apparmor

# 2. Cek status
sudo aa-status
cat /proc/$(pgrep -f qemu-system-x86_64)/attr/current

# 3. Cek profil
ls /etc/apparmor.d/libvirt/
cat /etc/apparmor.d/libvirt/libvirt-*.files
```

**Solusi:**

```bash
# 1. Mode complain
sudo aa-complain /usr/bin/qemu-system-x86_64

# 2. Test
virsh start arch-vm

# 3. Cek log
sudo dmesg | grep -i apparmor

# 4. Tambahkan rule jika perlu
# Edit /etc/apparmor.d/abstractions/libvirt-qemu
# Tambahkan path yang diizinkan

# 5. Reload
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.libvirtd

# 6. Kembali ke enforce
sudo aa-enforce /usr/bin/qemu-system-x86_64
```

### 4.8. Skenario 8: Permission DAC

**Gejala:** QEMU tidak bisa akses image.

**Diagnosis:**

```bash
# 1. Cek permission
ls -la /var/lib/libvirt/images/arch-vm.qcow2

# 2. Cek user QEMU
ps -eo user,group,pid,cmd | grep qemu

# 3. Cek log
tail -50 /var/log/libvirt/qemu/arch-vm.log
```

**Solusi:**

```bash
# 1. Chown
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/arch-vm.qcow2
sudo chmod 600 /var/lib/libvirt/images/arch-vm.qcow2

# 2. Atau aktifkan dynamic_ownership
echo "dynamic_ownership = 1" | sudo tee -a /etc/libvirt/qemu.conf
sudo systemctl restart virtqemud

# 3. Restart VM
virsh start arch-vm
```

### 4.9. Skenario 9: OOM (Out of Memory)

**Gejala:** VM di-kill kernel, host OOM.

**Diagnosis:**

```bash
# 1. Cek OOM
dmesg | grep -i "oom-killer"
journalctl -k | grep -i oom

# 2. Cek memori host
free -h
cat /proc/meminfo

# 3. Cek cgroup
cat /sys/fs/cgroup/machine.slice/machine-qemu*/memory.current
cat /sys/fs/cgroup/machine.slice/machine-qemu*/memory.max

# 4. Cek VM
virsh domstats arch-vm --memory
```

**Solusi:**

```bash
# 1. Batasi memori VM
virsh setmem arch-vm 1G --live
virsh setmaxmem arch-vm 2G

# 2. Batasi cgroup
# Di XML:
# <memtune>
#   <hard_limit unit='MiB'>2048</hard_limit>
# </memtune>

# 3. Tambah swap host
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 4. Atau tambah RAM host
```

### 4.10. Skenario 10: CPU Starvation

**Gejala:** VM lambat, host CPU 100%.

**Diagnosis:**

```bash
# 1. Cek CPU
top
htop
mpstat -P ALL 1

# 2. Cek cgroup
cat /sys/fs/cgroup/machine.slice/machine-qemu*/cpu.max
cat /sys/fs/cgroup/machine.slice/machine-qemu*/cpu.stat

# 3. Cek VM
virsh schedinfo arch-vm
virsh domstats arch-vm --cpu-total
```

**Solusi:**

```bash
# 1. Batasi CPU
virsh schedinfo arch-vm --set vcpu_quota=50000

# 2. Pin vCPU
virsh vcpupin arch-vm 0 0
virsh vcpupin arch-vm 1 1

# 3. Pin emulator
virsh emulatorpin arch-vm 2-3

# 4. Tambah CPU host
# atau kurangi VM.
```

### 4.11. Skenario 11: Snapshot Chain Rusak

**Gejala:** VM tidak bisa boot setelah snapshot.

**Diagnosis:**

```bash
# 1. Cek snapshot
qemu-img snapshot -l arch-vm.qcow2

# 2. Cek backing chain
qemu-img info --backing-chain arch-vm.qcow2

# 3. Cek log
tail -50 /var/log/libvirt/qemu/arch-vm.log
```

**Solusi:**

```bash
# 1. Blockcommit
virsh blockcommit arch-vm vda --active --pivot

# 2. Atau blockpull
virsh blockpull arch-vm vda --wait --verbose

# 3. Atau convert
qemu-img convert -O qcow2 arch-vm.qcow2 arch-vm-flat.qcow2

# 4. Ganti image
virsh blockcopy arch-vm vda /var/lib/libvirt/images/arch-vm-flat.qcow2 --wait --verbose --pivot
```

### 4.12. Skenario 12: libvirt Daemon Mati

**Gejala:** `virsh` tidak bisa konek.

**Diagnosis:**

```bash
# 1. Cek status
systemctl status virtqemud
systemctl status virtqemud.socket
systemctl status libvirtd

# 2. Cek log
journalctl -u virtqemud --since "10 min ago"
journalctl -u libvirtd --since "10 min ago"

# 3. Cek socket
ls -la /run/libvirt/
```

**Solusi:**

```bash
# 1. Start socket
sudo systemctl start virtqemud.socket
sudo systemctl start virtnetworkd.socket
sudo systemctl start virtstoraged.socket

# 2. Enable
sudo systemctl enable virtqemud.socket

# 3. Test
virsh -c qemu:///system list --all

# 4. Jika masih gagal, cek config
sudo libvirtd --verbose --daemon
```

### 4.13. Skrip Diagnostik Lengkap

```bash
#!/bin/bash
set -euo pipefail

VM="${1:-arch-vm}"
REPORT="/tmp/diagnostic-${VM}-$(date +%Y%m%d-%H%M%S).txt"

{
    echo "=== Diagnostic Report for $VM ==="
    echo "Date: $(date)"
    echo

    echo "=== VM Status ==="
    virsh list --all
    virsh domstate "$VM" 2>/dev/null || echo "VM not found"
    echo

    echo "=== VM Info ==="
    virsh dominfo "$VM" 2>/dev/null || true
    echo

    echo "=== VM XML ==="
    virsh dumpxml "$VM" 2>/dev/null || true
    echo

    echo "=== VM Stats ==="
    virsh domstats "$VM" 2>/dev/null || true
    echo

    echo "=== Block Info ==="
    virsh domblklist "$VM" 2>/dev/null || true
    virsh domblkinfo "$VM" vda 2>/dev/null || true
    echo

    echo "=== Interface Info ==="
    virsh domiflist "$VM" 2>/dev/null || true
    virsh domifaddr "$VM" 2>/dev/null || true
    echo

    echo "=== QEMU Process ==="
    ps -eo user,pid,cmd | grep "qemu-system.*$VM" | grep -v grep || true
    echo

    echo "=== QEMU Log ==="
    tail -100 "/var/log/libvirt/qemu/${VM}.log" 2>/dev/null || echo "N/A"
    echo

    echo "=== Libvirt Log ==="
    tail -50 /var/log/libvirt/libvirtd.log 2>/dev/null || echo "N/A"
    echo

    echo "=== Journal ==="
    journalctl -u virtqemud --since "1 hour ago" | tail -50
    echo

    echo "=== dmesg ==="
    dmesg | tail -50
    echo

    echo "=== cgroup ==="
    systemd-cgls /machine.slice 2>/dev/null || true
    echo

    echo "=== Disk ==="
    df -h
    echo

    echo "=== Memory ==="
    free -h
    echo

    echo "=== CPU ==="
    top -bn1 | head -20
    echo

    echo "=== Network ==="
    ip a
    ip r
    virsh net-list --all
    echo

    echo "=== Firewall ==="
    sudo nft list ruleset 2>/dev/null | head -50 || true
    echo

    echo "=== AppArmor ==="
    sudo aa-status 2>/dev/null | head -20 || true
    echo

    echo "=== End Report ==="
} > "$REPORT" 2>&1

echo "Report saved to $REPORT"
```

**Penjelasan:**
- Skrip mengumpulkan semua informasi diagnostik.

### 4.14. Skrip Recovery VM

```bash
#!/bin/bash
set -euo pipefail

VM="${1:-arch-vm}"
BACKUP_DIR="/backup/vm"
IMAGE="/var/lib/libvirt/images/${VM}.qcow2"

log() { echo "[$(date '+%F %T')] $*" | tee -a /var/log/vm-recovery.log; }

# 1. Cek VM
if ! virsh dominfo "$VM" &>/dev/null; then
    log "VM $VM tidak ditemukan"
    exit 1
fi

# 2. Destroy VM jika jalan
if virsh domstate "$VM" | grep -q running; then
    log "Mematikan VM $VM..."
    virsh destroy "$VM" || true
    sleep 2
fi

# 3. Backup image lama
if [ -f "$IMAGE" ]; then
    log "Backup image lama..."
    mv "$IMAGE" "${IMAGE}.broken-$(date +%Y%m%d-%H%M%S)"
fi

# 4. Restore dari backup terbaru
LATEST_BACKUP=$(ls -t "${BACKUP_DIR}/${VM}-"*.qcow2 2>/dev/null | head -1)
if [ -z "$LATEST_BACKUP" ]; then
    log "Tidak ada backup untuk $VM"
    exit 1
fi

log "Restore dari $LATEST_BACKUP..."
cp "$LATEST_BACKUP" "$IMAGE"

# 5. Set permission
chown libvirt-qemu:kvm "$IMAGE"
chmod 600 "$IMAGE"

# 6. Start VM
log "Start VM $VM..."
virsh start "$VM"

log "Recovery selesai."
```

**Penjelasan:**
- Skrip recovery dari backup.

### 4.15. Debug dengan strace

```bash
# Trace QEMU
sudo strace -f -p $(pgrep -f qemu-system-x86_64) -o /tmp/qemu-strace.log

# Filter syscall
sudo strace -f -p $(pgrep -f qemu-system-x86_64) -e trace=open,read,write -o /tmp/qemu-io.log

# Lihat log
tail -100 /tmp/qemu-strace.log
```

**Penjelasan:**
- `strace -f` — follow fork.
- `-p PID` — attach ke PID.
- `-e trace=` — filter syscall.

### 4.16. Debug dengan perf

```bash
# Profil QEMU
sudo perf top -p $(pgrep -f qemu-system-x86_64)

# Record
sudo perf record -p $(pgrep -f qemu-system-x86_64) -g -- sleep 10

# Report
sudo perf report
```

**Penjelasan:**
- `perf top` — live profile.
- `perf record` — rekam.
- `perf report` — laporan.

### 4.17. Debug dengan bpftrace

```bash
# Trace syscall QEMU
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /pid == '$(pgrep -f qemu-system-x86_64)'/ { printf("%s\n", probe); }'
```

**Penjelasan:**
- `bpftrace` — tracing BPF.
- `tracepoint:syscalls` — tracepoint syscall.

### 4.18. Analisis Network dengan tcpdump

```bash
# Capture di bridge
sudo tcpdump -i virbr0 -n -w /tmp/capture.pcap

# Capture di vnet
sudo tcpdump -i vnet0 -n -w /tmp/capture.pcap

# Baca
tcpdump -r /tmp/capture.pcap -n
wireshark /tmp/capture.pcap
```

**Penjelasan:**
- `tcpdump -i` — interface.
- `-w` — write pcap.
- `-r` — read pcap.

### 4.19. Analisis Disk dengan guestfish

```bash
# Read-only
guestfish --ro -a /var/lib/libvirt/images/arch-vm.qcow2 -i

# Read-write
guestfish --rw -a /var/lib/libvirt/images/arch-vm.qcow2 -i

# Perintah:
><fs> ll /
><fs> cat /etc/fstab
><fs> ls /var/log
><fs> download /var/log/syslog /tmp/syslog
><fs> exit
```

**Penjelasan:**
- `--ro` — read-only.
- `--rw` — read-write.
- `ll` — list long.
- `cat` — baca file.
- `download` — download file.

### 4.20. Mount Disk VM di Host

```bash
# 1. Load nbd
sudo modprobe nbd max_part=16

# 2. Connect
sudo qemu-nbd -c /dev/nbd0 /var/lib/libvirt/images/arch-vm.qcow2

# 3. Lihat partisi
lsblk /dev/nbd0

# 4. Mount
sudo mount /dev/nbd0p1 /mnt

# 5. Chroot
sudo arch-chroot /mnt

# 6. Unmount
exit
sudo umount /mnt
sudo qemu-nbd -d /dev/nbd0
```

**Penjelasan:**
- `modprobe nbd` — load modul NBD.
- `qemu-nbd -c` — connect.
- `mount` — mount.
- `arch-chroot` — chroot.

### 4.21. Verifikasi Troubleshooting

```bash
# 1. Cek VM
virsh list --all
virsh domstate arch-vm

# 2. Cek console
virsh console arch-vm

# 3. Cek network
virsh domifaddr arch-vm

# 4. Cek disk
virsh domblklist arch-vm

# 5. Cek log
tail -50 /var/log/libvirt/qemu/arch-vm.log

# 6. Cek sistem
virsh domstats arch-vm
```

---

## 5. Diagram Arsitektur Troubleshooting

### 5.1. Metodologi Troubleshooting

```
Masalah
  |
  v
+-------------------+
|  Identifikasi     |
+-------------------+
  |
  v
+-------------------+
|  Isolasi Lapisan  |
+-------------------+
  |
  v
+-------------------+
|  Hipotesis        |
+-------------------+
  |
  v
+-------------------+
|  Uji              |
+-------------------+
  |
  +-- Berhasil --> Perbaikan --> Verifikasi --> Dokumentasi
  |
  +-- Gagal --> Hipotesis Baru
```

### 5.2. Lapisan Debug

```
+-------------------+
|  Guest OS         |
+-------------------+
|  Kernel Guest     |
+-------------------+
|  QEMU             |
+-------------------+
|  libvirt          |
+-------------------+
|  Kernel Host      |
+-------------------+
|  Hardware         |
+-------------------+
```

### 5.3. Alur Boot Gagal

```
VM tidak boot
  |
  v
+-------------------+
|  Cek console      |
+-------------------+
  |
  v
+-------------------+
|  Cek log QEMU     |
+-------------------+
  |
  v
+-------------------+
|  Cek firmware     |
+-------------------+
  |
  v
+-------------------+
|  Cek bootloader   |
+-------------------+
  |
  v
+-------------------+
|  Cek initramfs    |
+-------------------+
  |
  v
+-------------------+
|  Cek root fs      |
+-------------------+
```

### 5.4. Alur Network Mati

```
Network mati
  |
  v
+-------------------+
|  Cek interface    |
+-------------------+
  |
  v
+-------------------+
|  Cek bridge       |
+-------------------+
  |
  v
+-------------------+
|  Cek DHCP         |
+-------------------+
  |
  v
+-------------------+
|  Cek firewall     |
+-------------------+
  |
  v
+-------------------+
|  tcpdump          |
+-------------------+
```

### 5.5. Alur VM Hang

```
VM hang
  |
  v
+-------------------+
|  Cek status       |
+-------------------+
  |
  v
+-------------------+
|  Cek CPU/memori   |
+-------------------+
  |
  v
+-------------------+
|  Cek log          |
+-------------------+
  |
  v
+-------------------+
|  inject-nmi       |
+-------------------+
  |
  v
+-------------------+
|  shutdown/destroy |
+-------------------+
```

### 5.6. Pohon Keputusan Troubleshooting

```
Apakah VM jalan?
├── Tidak → Apakah ada di libvirt?
│   ├── Ya → Cek log QEMU, start manual
│   └── Tidak → Cek XML, define ulang
└── Ya → Apakah responsif?
    ├── Ya → Cek performa, network, disk
    └── Tidak → Cek CPU, OOM, hang
```

### 5.7. Alur Recovery

```
Masalah
  |
  v
+-------------------+
|  Diagnostik       |
+-------------------+
  |
  v
+-------------------+
|  Isolasi          |
+-------------------+
  |
  v
+-------------------+
|  Backup dulu      |
+-------------------+
  |
  v
+-------------------+
|  Perbaikan        |
+-------------------+
  |
  v
+-------------------+
|  Uji              |
+-------------------+
  |
  v
+-------------------+
|  Dokumentasi      |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 7.4

Kurikulum asli menyebut:
> Skenario:
> 1. Boot gagal.
> 2. Disk penuh.
> 3. Network mati.
> 4. VM hang.
> 5. QMP tidak responsif.
> Validasi Lulus: 5 skenario lulus berbatas waktu.

Kita akan menambahkan:
1. **12 skenario** (bukan 5).
2. **Metodologi troubleshooting**.
3. **Log sources**: journalctl, libvirt, QEMU, audit, dmesg.
4. **Debug tools**: strace, gdb, perf, bpftrace, tcpdump.
5. **Boot gagal**: kernel panic, initramfs, bootloader, root fs.
6. **Disk penuh**: resize, trim, compact.
7. **Network mati**: bridge, DHCP, firewall, tcpdump.
8. **VM hang**: NMI, screenshot, shutdown/destroy.
9. **QMP**: socket, socat, restart.
10. **Image corrupt**: qemu-img check/repair, convert.
11. **AppArmor denial**: aa-complain, aa-enforce, profil.
12. **Permission DAC**: chown, dynamic_ownership.
13. **OOM**: cgroup, swap, batas.
14. **CPU starvation**: pin, quota, schedinfo.
15. **Snapshot chain**: blockcommit, blockpull.
16. **libvirt daemon**: socket, restart.
17. **Skrip diagnostik**.
18. **Skrip recovery**.
19. **Mount disk VM di host**: nbd, chroot.
20. **guestfish, virt-rescue**.
21. **Verifikasi**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 7.4.

---

## 7. Hubungan dengan Modul Lain

- **Fase 1–6**: semua materi bisa rusak, modul ini cara memperbaiki.
- **Modul 7.1 (cloud-init)**: debug cloud-init.
- **Modul 7.2 (Windows)**: debug Windows headless.
- **Modul 7.3 (Skrip)**: skrip diagnostik.
- **Modul 7.5 (Capstone)**: troubleshooting dalam proyek.
- **Fase 8 (Expert)**: debugging live migration, passthrough.

---

## 8. Referensi Lengkap

- libvirt Debugging — https://libvirt.org/debuglogs.html
- libvirt Troubleshooting — https://wiki.libvirt.org/Troubleshooting.html
- QEMU Debugging — https://www.qemu.org/docs/master/devel/debugging.html
- QEMU Monitor — https://www.qemu.org/docs/master/system/monitor.html
- qemu-img — https://qemu.readthedocs.io/en/latest/tools/qemu-img.html
- guestfish — https://libguestfs.org/guestfish.1.html
- virt-rescue — https://libguestfs.org/virt-rescue.1.html
- libguestfs — https://libguestfs.org/
- strace — https://strace.io/
- gdb — https://www.gnu.org/software/gdb/
- perf — https://perf.wiki.kernel.org/
- bpftrace — https://github.com/iovisor/bpftrace
- tcpdump — https://www.tcpdump.org/
- wireshark — https://www.wireshark.org/
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: nbd — https://wiki.archlinux.org/title/NBD
- NIST SP 800-61 — https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final

---

## 9. Tips & Praktik Terbaik

1. **Selalu backup** sebelum perbaikan.
2. **Baca log** sebelum menebak.
3. **Isolasi lapisan**.
4. **Cari perubahan terakhir**.
5. **Sederhanakan** kasus.
6. **Gunakan metodologi**.
7. **Jangan panik**.
8. **Dokumentasikan**.
9. **Test di VM terpisah**.
10. **Gunakan skrip diagnostik**.
11. **Gunakan `virsh console`**.
12. **Gunakan `virsh screenshot`**.
13. **Gunakan `tcpdump`** untuk network.
14. **Gunakan `strace`** untuk syscall.
15. **Gunakan `gdb`** untuk crash.
16. **Gunakan `perf`** untuk performa.
17. **Gunakan `guestfish`** untuk disk offline.
18. **Gunakan `virt-rescue`** untuk rescue.
19. **Gunakan `qemu-nbd`** untuk mount disk.
20. **Buat runbook**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `virsh console` hang | Serial tidak dikonfigurasi. | Cek XML, cek `console=ttyS0`. |
| `virsh destroy` merusak | Tidak ada sync. | Gunakan `shutdown`. |
| Mount gagal | Partisi tidak ada. | Cek `lsblk`. |
| Chroot gagal | Arch tidak match. | Gunakan `arch-chroot`. |
| Image corrupt | Crash. | `qemu-img check -r all`. |
| Network mati | Bridge down. | Restart network. |
| DHCP gagal | dnsmasq mati. | Restart libvirt. |
| OOM | Memori kurang. | Batasi cgroup. |
| CPU 100% | Starvation. | Pin vCPU. |
| QMP tidak responsif | QEMU hang. | Restart. |
| AppArmor denial | Profil salah. | `aa-complain`. |
| Permission DAC | Ownership salah. | `chown`. |
| Snapshot rusak | Chain rusak. | `blockcommit`. |
| libvirt mati | Service crash. | Restart. |
| Guestfish gagal | Image sibuk. | Matikan VM. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- 12 skenario berhasil diatasi.
- Skrip diagnostik berjalan.
- Skrip recovery berjalan.
- VM bisa boot setelah perbaikan.
- Network berfungsi.
- Disk bisa di-resize.
- Image bisa di-repair.
- Log bersih.

**Troubleshooting:**
- Jika skenario gagal: cek log, cek metodologi.
- Jika skrip gagal: `bash -x`.
- Jika VM tidak boot: cek firmware, bootloader, kernel, initramfs, root fs.
- Jika network mati: cek bridge, DHCP, firewall.
- Jika disk penuh: resize, trim, compact.
- Jika VM hang: NMI, screenshot, destroy.
- Untuk debugging: `strace`, `gdb`, `perf`, `bpftrace`.
- Untuk log: `journalctl`, `/var/log/libvirt/`, `dmesg`.

---

## 12. Latihan Mandiri

1. Buat VM, lalu rusak bootloader, perbaiki.
2. Buat disk penuh, perbaiki.
3. Matikan network, perbaiki.
4. Buat VM hang, perbaiki.
5. Matikan QMP, perbaiki.
6. Rusak image, perbaiki.
7. Buat AppArmor denial, perbaiki.
8. Buat permission error, perbaiki.
9. Buat OOM, perbaiki.
10. Buat CPU starvation, perbaiki.
11. Rusak snapshot, perbaiki.
12. Matikan libvirt, perbaiki.
13. Buat skrip diagnostik.
14. Buat skrip recovery.
15. Mount disk VM di host.
16. Gunakan guestfish.
17. Gunakan virt-rescue.
18. Gunakan strace, gdb, perf.
19. Buat runbook.
20. Dokumentasikan.

---

## 13. Penutup Modul 7.4

Anda kini menguasai **Drill Troubleshooting** — seni mendiagnosis dan memperbaiki masalah VM. Anda bisa:
- Menggunakan **metodologi** troubleshooting.
- Mendiagnosis **boot gagal**, **disk penuh**, **network mati**, **VM hang**, **QMP tidak responsif**.
- Memperbaiki **image corrupt**, **AppArmor denial**, **permission DAC**, **OOM**, **CPU starvation**, **snapshot rusak**, **libvirt mati**.
- Menggunakan **alat debug**: `strace`, `gdb`, `perf`, `bpftrace`, `tcpdump`.
- Menggunakan **guestfish**, **virt-rescue**, **qemu-nbd**.
- Membuat **skrip diagnostik** dan **recovery**.
- Membuat **runbook**.

Ini adalah fondasi untuk **Modul 7.5 — Capstone**, di mana kita akan membangun infrastruktur multi-OS lengkap dengan otomasi dan troubleshooting.

---

*Motivasi: Kegagalan adalah guru terbaik. Setiap error yang Anda perbaiki adalah pengetahuan yang tidak akan hilang. Setiap crash yang Anda atasi adalah keterampilan yang tidak akan pudar. Jadilah engineer yang tidak takut pada masalah, karena masalah adalah tangga menuju penguasaan.*

---

# Modul 7.5 — Capstone

## Mini-Daftar Isi Modul 7.5

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Capstone
6. Audit Kurikulum: Tambahan untuk Modul 7.5
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 7.5 & Fase 7

---

> *Motivasi: Puncak gunung bukanlah akhir perjalanan, melainkan tempat untuk melihat seberapa jauh Anda telah melangkah. Capstone adalah cermin yang menunjukkan siapa Anda sebagai engineer. Jangan takut pada kompleksitas; Anda telah membangun fondasinya batu demi batu.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Capstone** adalah **proyek akhir** Fase 7 — sebuah **integrasi lengkap** dari semua yang telah Anda pelajari di Fase 1 hingga 7. Ini bukan sekadar latihan, tetapi **simulasi dunia nyata** di mana Anda membangun, mengelola, dan menghancurkan **infrastruktur VM multi-OS** dengan **satu perintah**.

Kurikulum asli menyebut:
> **Tugas:**
> - Infrastruktur 4+ VM multi-OS.
> - Build & destroy dengan satu perintah.
> - Skrip idempotent, target <15 menit.
> - Runbook terdokumentasi.
>
> **Validasi Lulus:**
> - Skrip capstone berhasil dari nol.

Kita akan memperluas menjadi:
- **Arsitektur 4+ VM** dengan peran berbeda: router/firewall, web server, database, workstation, dan monitoring.
- **Multi-OS**: Arch Linux, Debian, Alpine, Windows Server Core.
- **Otomasi penuh**: cloud-init, autounattend, hook, systemd.
- **Keamanan berlapis**: hardening XML, confinement, enkripsi, unprivileged.
- **Jaringan tersegmentasi**: DMZ, LAN, isolated.
- **Backup & recovery**: otomatis dengan systemd timer.
- **Observability**: metrics, logging, audit.
- **Runbook**: dokumentasi lengkap.
- **CI/CD**: opsional, integrasi dengan Git.

**Peran dalam kurikulum:** Modul ini adalah **puncak Fase 7** dan **jembatan ke Fase 8**. Setelah Anda menguasai dasar (Fase 1–6) dan otomasi (Fase 7.1–7.4), sekarang Anda **menggabungkan semuanya** menjadi satu proyek nyata. Capstone adalah **portofolio** yang bisa Anda tunjukkan ke employer, klien, atau komunitas. Ini juga fondasi untuk:
- **Fase 8 (Expert)**: live migration, VFIO, observability tingkat lanjut.
- **Karier**: sysadmin, DevOps, security engineer, cloud engineer.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Infrastructure as Code (IaC)

**IaC** adalah filosofi mengelola infrastruktur melalui **kode** yang bisa di-*version control*, di-*review*, dan di-*test*. Capstone adalah **implementasi IaC** dengan Bash + libvirt XML + cloud-init.

**Filosofi:** *Infrastruktur adalah kode. Perlakukan seperti kode.*

### 2.2. Idempotensi Total

Skrip capstone harus **idempotent**: dijalankan sekali atau seratus kali, hasilnya sama. Ini berarti:
- Cek keberadaan VM sebelum membuat.
- Cek network sebelum define.
- Cek storage pool sebelum build.
- Hapus resource lama dengan hati-hati.

**Filosofi:** *Sekali benar, selamanya benar.*

### 2.3. Build & Destroy: Siklus Hidup Penuh

**Build** adalah membuat infrastruktur dari nol. **Destroy** adalah menghapusnya. Keduanya harus **cepat**, **aman**, dan **bersih**. Target: build <15 menit, destroy <5 menit.

**Filosofi:** *Yang bisa dibangun, bisa dihancurkan. Yang bisa dihancurkan, bisa dibangun ulang.*

### 2.4. Multi-OS: Heterogenitas

Infrastruktur nyata tidak homogen. Capstone harus mencakup:
- **Linux**: Arch, Debian, Alpine.
- **Windows**: Server Core.
- **BSD**: opsional (FreeBSD).

Setiap OS punya **cara provisioning** berbeda (cloud-init vs autounattend).

**Filosofi:** *Heterogenitas adalah norma. Kuasai perbedaannya.*

### 2.5. Segmentasi Jaringan

**Segmentasi** adalah memisahkan jaringan menjadi **zona** dengan **kebijakan** berbeda:
- **WAN/Internet**: tidak terpercaya.
- **DMZ**: semi-terpercaya (web server).
- **LAN**: terpercaya (workstation).
- **Isolated**: tidak terpercaya (lab malware).
- **Management**: khusus admin.

Router VM menghubungkan zona dan menerapkan firewall.

**Filosofi:** *Jaringan adalah kastil. Segmentasi adalah temboknya.*

### 2.6. Defense in Depth

Capstone harus menerapkan **defense in depth**:
- **Host hardening**: nftables, audit, AppArmor.
- **VM hardening**: XML minimal, virtio.
- **Confinement**: cgroups, seccomp.
- **Integritas**: Secure Boot, vTPM.
- **Kerahasiaan**: LUKS, qcow2 encryption.
- **Isolasi**: unprivileged, namespace.
- **Monitoring**: audit, logging.
- **Recovery**: backup, snapshot.

**Filosofi:** *Satu lapisan tidak cukup. Gunakan banyak.*

### 2.7. Dokumentasi Runbook

**Runbook** adalah **panduan operasional** yang menjelaskan:
- Cara build.
- Cara destroy.
- Cara troubleshooting.
- Cara backup/restore.
- Cara update.
- Kontak.

Runbook harus **jelas**, **lengkap**, dan **teruji**.

**Filosofi:** *Dokumentasi adalah warisan. Tanpa itu, pengetahuan hilang.*

### 2.8. Otomasi Penuh

Capstone harus **otomatis**:
- **Build**: satu perintah.
- **Destroy**: satu perintah.
- **Backup**: timer.
- **Monitoring**: otomatis.
- **Recovery**: otomatis.

**Filosofi:** *Otomasi adalah kebebasan. Anda tidak perlu mengetik, hanya memerintah.*

### 2.9. Version Control

Semua kode (skrip, XML, cloud-init) harus disimpan di **Git**. Ini memungkinkan:
- **History**: melihat perubahan.
- **Rollback**: kembali ke versi lama.
- **Kolaborasi**: tim.
- **Audit**: siapa mengubah apa.

**Filosofi:** *Git adalah memori proyek. Tanpa itu, amnesia.*

### 2.10. Filosofi Keseluruhan

- **Infrastruktur adalah kode.**
- **Idempotensi adalah hukum.**
- **Build & destroy adalah siklus.**
- **Multi-OS adalah norma.**
- **Segmentasi adalah pertahanan.**
- **Defense in depth adalah strategi.**
- **Dokumentasi adalah warisan.**
- **Otomasi adalah kebebasan.**
- **Version control adalah memori.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Capstone** | Proyek akhir. | |
| **IaC** | Infrastructure as Code. | |
| **Idempotent** | Dapat diulang. | |
| **Build** | Membangun. | |
| **Destroy** | Menghancurkan. | |
| **Multi-OS** | Banyak OS. | |
| **Segmentasi** | Pemisahan jaringan. | |
| **DMZ** | Demilitarized Zone. | |
| **LAN** | Local Area Network. | |
| **Isolated** | Terisolasi. | |
| **Management** | Jaringan manajemen. | |
| **Router VM** | VM router. | |
| **Web Server** | Server web. | |
| **Database** | Server database. | |
| **Workstation** | Workstation. | |
| **Monitoring** | Pemantauan. | |
| **Runbook** | Panduan operasional. | |
| **Git** | Version control. | |
| **CI/CD** | Continuous Integration/Deployment. | |
| **Ansible** | Otomasi konfigurasi. | |
| **Terraform** | IaC. | |
| **Packer** | Image builder. | |
| **Vagrant** | VM manager. | |
| **Makefile** | Build automation. | |
| **Taskfile** | Task runner. | |
| **Justfile** | Command runner. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Arsitektur Capstone

**Zona:**
```
+-------------------+
|   Internet        |
+-------------------+
          |
          | WAN (192.168.122.0/24)
          v
+-------------------+
|   Router VM       |
|   (Alpine)        |
+-------------------+
          |
          +-- DMZ (10.0.10.0/24)
          |       |
          |       v
          |   +-------------------+
          |   |   Web Server      |
          |   |   (Debian)        |
          |   +-------------------+
          |
          +-- LAN (10.0.20.0/24)
          |       |
          |       v
          |   +-------------------+
          |   |   Database        |
          |   |   (Arch)          |
          |   +-------------------+
          |   +-------------------+
          |   |   Workstation     |
          |   |   (Windows)       |
          |   +-------------------+
          |
          +-- MGMT (10.0.30.0/24)
                  |
                  v
              +-------------------+
              |   Monitoring      |
              |   (Alpine)        |
              +-------------------+
```

**Peran:**
- **Router VM** (Alpine): routing, firewall (nftables), DHCP, DNS.
- **Web Server** (Debian): Nginx, PHP, di DMZ.
- **Database** (Arch): PostgreSQL, di LAN.
- **Workstation** (Windows Server Core): di LAN.
- **Monitoring** (Alpine): Prometheus, Grafana, Loki, di MGMT.

### 4.2. Struktur Direktori Proyek

```
capstone/
├── README.md
├── Makefile
├── runbook.md
├── .gitignore
├── scripts/
│   ├── build.sh
│   ├── destroy.sh
│   ├── backup.sh
│   ├── restore.sh
│   ├── status.sh
│   └── lib/
│       ├── common.sh
│       ├── network.sh
│       ├── storage.sh
│       └── vm.sh
├── config/
│   ├── networks/
│   │   ├── wan.xml
│   │   ├── dmz.xml
│   │   ├── lan.xml
│   │   └── mgmt.xml
│   └── storage/
│       └── default.xml
├── vms/
│   ├── router/
│   │   ├── domain.xml
│   │   ├── user-data
│   │   └── meta-data
│   ├── web/
│   │   ├── domain.xml
│   │   ├── user-data
│   │   └── meta-data
│   ├── db/
│   │   ├── domain.xml
│   │   ├── user-data
│   │   └── meta-data
│   ├── workstation/
│   │   ├── domain.xml
│   │   └── autounattend.xml
│   └── monitoring/
│       ├── domain.xml
│       ├── user-data
│       └── meta-data
├── hooks/
│   └── qemu
└── systemd/
    ├── vm-router.service
    ├── vm-web.service
    ├── vm-db.service
    ├── vm-workstation.service
    ├── vm-monitoring.service
    └── vm-backup.timer
```

### 4.3. Makefile

```makefile
.PHONY: all build destroy status backup restore clean help

SHELL := /bin/bash
SCRIPT_DIR := $(shell pwd)/scripts

all: build

build:
	@echo "Building infrastructure..."
	@$(SCRIPT_DIR)/build.sh

destroy:
	@echo "Destroying infrastructure..."
	@$(SCRIPT_DIR)/destroy.sh

status:
	@$(SCRIPT_DIR)/status.sh

backup:
	@$(SCRIPT_DIR)/backup.sh

restore:
	@$(SCRIPT_DIR)/restore.sh

clean:
	@echo "Cleaning temporary files..."
	@rm -f /tmp/*.qcow2 /tmp/*.img /tmp/*-user-data /tmp/*-meta-data

help:
	@echo "Available targets:"
	@echo "  build    - Build all VMs"
	@echo "  destroy  - Destroy all VMs"
	@echo "  status   - Show status"
	@echo "  backup   - Backup all VMs"
	@echo "  restore  - Restore from backup"
	@echo "  clean    - Clean temporary files"
```

**Penjelasan kata demi kata:**
- `.PHONY` — target yang bukan file.
- `SHELL := /bin/bash` — shell.
- `SCRIPT_DIR` — direktori skrip.
- `build:` — target build.
- `@` — jangan echo perintah.
- `$(SCRIPT_DIR)/build.sh` — panggil skrip.

### 4.4. Skrip Common Library

**File `scripts/lib/common.sh`:**

```bash
#!/bin/bash
#
# common.sh - Fungsi umum untuk capstone
#

set -euo pipefail

# Warna
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Path
readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly CONFIG_DIR="${PROJECT_ROOT}/config"
readonly VMS_DIR="${PROJECT_ROOT}/vms"
readonly IMAGE_DIR="/var/lib/libvirt/images"
readonly BACKUP_DIR="/backup/vm"
readonly LOG_DIR="/var/log/capstone"

# Log
readonly LOG_FILE="${LOG_DIR}/capstone.log"

log() {
    local level="$1"
    shift
    local msg="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local color=""
    case "$level" in
        INFO)  color="$GREEN" ;;
        WARN)  color="$YELLOW" ;;
        ERROR) color="$RED" ;;
        DEBUG) color="$BLUE" ;;
    esac
    echo -e "${color}[${timestamp}] [${level}] ${msg}${NC}" | tee -a "$LOG_FILE"
}

info()  { log INFO "$@"; }
warn()  { log WARN "$@"; }
error() { log ERROR "$@"; }
debug() { log DEBUG "$@"; }

# Cek perintah
require_cmd() {
    if ! command -v "$1" &>/dev/null; then
        error "Perintah '$1' tidak ditemukan"
        exit 1
    fi
}

# Cek root
require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        error "Skrip ini harus dijalankan sebagai root"
        exit 1
    fi
}

# Cek VM ada
vm_exists() {
    virsh dominfo "$1" &>/dev/null
}

# Cek network ada
net_exists() {
    virsh net-info "$1" &>/dev/null
}

# Cek pool ada
pool_exists() {
    virsh pool-info "$1" &>/dev/null
}

# Tunggu VM
wait_vm() {
    local vm="$1"
    local timeout="${2:-300}"
    local elapsed=0
    while [ $elapsed -lt $timeout ]; do
        if virsh domstate "$vm" 2>/dev/null | grep -q running; then
            info "VM $vm berjalan"
            return 0
        fi
        sleep 2
        elapsed=$((elapsed + 2))
    done
    error "Timeout menunggu VM $vm"
    return 1
}

# Tunggu SSH
wait_ssh() {
    local host="$1"
    local port="${2:-22}"
    local user="${3:-user}"
    local timeout="${4:-300}"
    local elapsed=0
    while [ $elapsed -lt $timeout ]; do
        if ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -p "$port" "${user}@${host}" true 2>/dev/null; then
            info "SSH ke $host:$port siap"
            return 0
        fi
        sleep 5
        elapsed=$((elapsed + 5))
    done
    error "Timeout menunggu SSH $host:$port"
    return 1
}

# Trap
setup_trap() {
    trap 'error "Skrip gagal pada baris $LINENO"' ERR
}

# Export
export -f log info warn error debug
export -f require_cmd require_root
export -f vm_exists net_exists pool_exists
export -f wait_vm wait_ssh
```

**Penjelasan:**
- `readonly` — konstanta.
- `PROJECT_ROOT` — root proyek.
- `log()` — fungsi logging.
- `require_cmd()` — cek perintah.
- `vm_exists()` — cek VM.
- `wait_vm()` — tunggu VM.
- `wait_ssh()` — tunggu SSH.

### 4.5. Skrip Network

**File `scripts/lib/network.sh`:**

```bash
#!/bin/bash
#
# network.sh - Fungsi network untuk capstone
#

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Buat network dari XML
create_network() {
    local name="$1"
    local xml="$2"

    if net_exists "$name"; then
        info "Network $name sudah ada"
        if ! virsh net-info "$name" | grep -q "Active:.*yes"; then
            virsh net-start "$name"
        fi
        return 0
    fi

    info "Membuat network $name..."
    virsh net-define "$xml"
    virsh net-start "$name"
    virsh net-autostart "$name"
}

# Hapus network
destroy_network() {
    local name="$1"

    if ! net_exists "$name"; then
        info "Network $name tidak ada"
        return 0
    fi

    info "Menghapus network $name..."
    virsh net-destroy "$name" 2>/dev/null || true
    virsh net-undefine "$name" 2>/dev/null || true
}

# Setup semua network
setup_networks() {
    local networks=("wan" "dmz" "lan" "mgmt")

    for net in "${networks[@]}"; do
        local xml="${CONFIG_DIR}/networks/${net}.xml"
        if [ -f "$xml" ]; then
            create_network "$net" "$xml"
        else
            warn "XML network $net tidak ditemukan"
        fi
    done
}

# Hapus semua network
teardown_networks() {
    local networks=("mgmt" "lan" "dmz" "wan")

    for net in "${networks[@]}"; do
        destroy_network "$net"
    done
}
```

**Penjelasan:**
- `source` — include library.
- `create_network()` — buat network.
- `destroy_network()` — hapus network.
- `setup_networks()` — setup semua.
- `teardown_networks()` — hapus semua.

### 4.6. XML Network WAN

**File `config/networks/wan.xml`:**

```xml
<network>
  <name>wan</name>
  <forward mode='nat'/>
  <bridge name='virbr-wan' stp='on' delay='0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.100' end='192.168.122.200'/>
    </dhcp>
  </ip>
</network>
```

**Penjelasan:**
- `<forward mode='nat'/>` — NAT ke internet.
- `<bridge name='virbr-wan'/>` — bridge.
- `<ip address='192.168.122.1'/>` — gateway.
- `<dhcp>` — DHCP range.

### 4.7. XML Network DMZ

**File `config/networks/dmz.xml`:**

```xml
<network>
  <name>dmz</name>
  <bridge name='virbr-dmz' stp='on' delay='0'/>
  <ip address='10.0.10.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.10.100' end='10.0.10.200'/>
    </dhcp>
  </ip>
</network>
```

**Penjelasan:**
- Tanpa `<forward>` — isolated.
- Gateway `10.0.10.1`.

### 4.8. XML Network LAN

**File `config/networks/lan.xml`:**

```xml
<network>
  <name>lan</name>
  <bridge name='virbr-lan' stp='on' delay='0'/>
  <ip address='10.0.20.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.20.100' end='10.0.20.200'/>
    </dhcp>
  </ip>
</network>
```

### 4.9. XML Network MGMT

**File `config/networks/mgmt.xml`:**

```xml
<network>
  <name>mgmt</name>
  <bridge name='virbr-mgmt' stp='on' delay='0'/>
  <ip address='10.0.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.30.100' end='10.0.30.200'/>
    </dhcp>
  </ip>
</network>
```

### 4.10. Skrip VM

**File `scripts/lib/vm.sh`:**

```bash
#!/bin/bash
#
# vm.sh - Fungsi VM untuk capstone
#

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Buat disk
create_disk() {
    local name="$1"
    local size="$2"
    local path="${IMAGE_DIR}/${name}.qcow2"

    if [ -f "$path" ]; then
        info "Disk $path sudah ada"
        return 0
    fi

    info "Membuat disk $path ($size)..."
    qemu-img create -f qcow2 "$path" "$size"
}

# Buat seed cloud-init
create_seed() {
    local name="$1"
    local user_data="$2"
    local meta_data="$3"
    local network_config="${4:-}"
    local seed="${IMAGE_DIR}/${name}-seed.img"

    if [ -f "$seed" ]; then
        info "Seed $seed sudah ada"
        return 0
    fi

    info "Membuat seed $seed..."

    if [ -n "$network_config" ]; then
        cloud-localds "$seed" "$user_data" "$meta_data" "$network_config"
    else
        cloud-localds "$seed" "$user_data" "$meta_data"
    fi
}

# Define VM
define_vm() {
    local name="$1"
    local xml="$2"

    if vm_exists "$name"; then
        info "VM $name sudah terdefinisi"
        return 0
    fi

    info "Mendefinisikan VM $name..."
    virsh define "$xml"
}

# Start VM
start_vm() {
    local name="$1"

    if virsh domstate "$name" 2>/dev/null | grep -q running; then
        info "VM $name sudah berjalan"
        return 0
    fi

    info "Menjalankan VM $name..."
    virsh start "$name"
}

# Stop VM
stop_vm() {
    local name="$1"
    local force="${2:-no}"

    if ! virsh domstate "$name" 2>/dev/null | grep -q running; then
        info "VM $name tidak berjalan"
        return 0
    fi

    if [ "$force" = "yes" ]; then
        info "Mematikan paksa VM $name..."
        virsh destroy "$name"
    else
        info "Mematikan VM $name..."
        virsh shutdown "$name"
        # Tunggu max 60s
        local elapsed=0
        while [ $elapsed -lt 60 ]; do
            if ! virsh domstate "$name" 2>/dev/null | grep -q running; then
                return 0
            fi
            sleep 2
            elapsed=$((elapsed + 2))
        done
        warn "Timeout shutdown, paksa mati..."
        virsh destroy "$name"
    fi
}

# Hapus VM
destroy_vm() {
    local name="$1"

    if ! vm_exists "$name"; then
        info "VM $name tidak ada"
        return 0
    fi

    info "Menghapus VM $name..."
    stop_vm "$name" "yes"
    virsh undefine "$name" --remove-all-storage 2>/dev/null || virsh undefine "$name"
}

# Autostart VM
autostart_vm() {
    local name="$1"
    info "Mengaktifkan autostart untuk VM $name..."
    virsh autostart "$name"
}
```

**Penjelasan:**
- `create_disk()` — buat disk.
- `create_seed()` — buat seed.
- `define_vm()` — define VM.
- `start_vm()` — start VM.
- `stop_vm()` — stop VM.
- `destroy_vm()` — hapus VM.
- `autostart_vm()` — autostart.

### 4.11. Skrip Build

**File `scripts/build.sh`:**

```bash
#!/bin/bash
#
# build.sh - Build semua VM capstone
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/network.sh"
source "${SCRIPT_DIR}/lib/vm.sh"

# Setup
mkdir -p "$LOG_DIR" "$BACKUP_DIR" "$IMAGE_DIR"

# Trap
setup_trap

# Cek dependencies
require_root
require_cmd virsh
require_cmd qemu-img
require_cmd virt-install
require_cmd cloud-localds

info "=== Memulai build capstone ==="
START_TIME=$(date +%s)

# 1. Setup networks
info "--- Setup networks ---"
setup_networks

# 2. Build VM: Router
info "--- Build Router VM ---"
build_router() {
    local vm="capstone-router"
    local disk="${IMAGE_DIR}/${vm}.qcow2"
    local seed="${IMAGE_DIR}/${vm}-seed.img"

    # Download cloud image jika belum ada
    if [ ! -f "${IMAGE_DIR}/alpine-cloud.img" ]; then
        info "Download Alpine cloud image..."
        wget -O "${IMAGE_DIR}/alpine-cloud.img" \
            "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/cloud/nocloud_alpine-3.19.1-x86_64-uefi-cloudinit-r0.qcow2"
    fi

    # Copy image
    if [ ! -f "$disk" ]; then
        info "Copy Alpine image ke $disk..."
        cp "${IMAGE_DIR}/alpine-cloud.img" "$disk"
        qemu-img resize "$disk" 5G
    fi

    # Buat seed
    create_seed "$vm" \
        "${VMS_DIR}/router/user-data" \
        "${VMS_DIR}/router/meta-data"

    # Define VM
    local xml_tmp="/tmp/${vm}.xml"
    sed -e "s|@DISK@|${disk}|g" \
        -e "s|@SEED@|${seed}|g" \
        "${VMS_DIR}/router/domain.xml" > "$xml_tmp"

    define_vm "$vm" "$xml_tmp"
    start_vm "$vm"
    autostart_vm "$vm"
}

build_router

# 3. Build VM: Web Server
info "--- Build Web Server VM ---"
build_web() {
    local vm="capstone-web"
    local disk="${IMAGE_DIR}/${vm}.qcow2"
    local seed="${IMAGE_DIR}/${vm}-seed.img"

    if [ ! -f "${IMAGE_DIR}/debian-cloud.img" ]; then
        info "Download Debian cloud image..."
        wget -O "${IMAGE_DIR}/debian-cloud.img" \
            "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    fi

    if [ ! -f "$disk" ]; then
        info "Copy Debian image ke $disk..."
        cp "${IMAGE_DIR}/debian-cloud.img" "$disk"
        qemu-img resize "$disk" 10G
    fi

    create_seed "$vm" \
        "${VMS_DIR}/web/user-data" \
        "${VMS_DIR}/web/meta-data"

    local xml_tmp="/tmp/${vm}.xml"
    sed -e "s|@DISK@|${disk}|g" \
        -e "s|@SEED@|${seed}|g" \
        "${VMS_DIR}/web/domain.xml" > "$xml_tmp"

    define_vm "$vm" "$xml_tmp"
    start_vm "$vm"
    autostart_vm "$vm"
}

build_web

# 4. Build VM: Database
info "--- Build Database VM ---"
build_db() {
    local vm="capstone-db"
    local disk="${IMAGE_DIR}/${vm}.qcow2"
    local seed="${IMAGE_DIR}/${vm}-seed.img"

    if [ ! -f "${IMAGE_DIR}/arch-cloud.img" ]; then
        info "Download Arch cloud image..."
        wget -O "${IMAGE_DIR}/arch-cloud.img" \
            "https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
    fi

    if [ ! -f "$disk" ]; then
        info "Copy Arch image ke $disk..."
        cp "${IMAGE_DIR}/arch-cloud.img" "$disk"
        qemu-img resize "$disk" 20G
    fi

    create_seed "$vm" \
        "${VMS_DIR}/db/user-data" \
        "${VMS_DIR}/db/meta-data"

    local xml_tmp="/tmp/${vm}.xml"
    sed -e "s|@DISK@|${disk}|g" \
        -e "s|@SEED@|${seed}|g" \
        "${VMS_DIR}/db/domain.xml" > "$xml_tmp"

    define_vm "$vm" "$xml_tmp"
    start_vm "$vm"
    autostart_vm "$vm"
}

build_db

# 5. Build VM: Monitoring
info "--- Build Monitoring VM ---"
build_monitoring() {
    local vm="capstone-monitoring"
    local disk="${IMAGE_DIR}/${vm}.qcow2"
    local seed="${IMAGE_DIR}/${vm}-seed.img"

    if [ ! -f "$disk" ]; then
        info "Copy Alpine image ke $disk..."
        cp "${IMAGE_DIR}/alpine-cloud.img" "$disk"
        qemu-img resize "$disk" 10G
    fi

    create_seed "$vm" \
        "${VMS_DIR}/monitoring/user-data" \
        "${VMS_DIR}/monitoring/meta-data"

    local xml_tmp="/tmp/${vm}.xml"
    sed -e "s|@DISK@|${disk}|g" \
        -e "s|@SEED@|${seed}|g" \
        "${VMS_DIR}/monitoring/domain.xml" > "$xml_tmp"

    define_vm "$vm" "$xml_tmp"
    start_vm "$vm"
    autostart_vm "$vm"
}

build_monitoring

# 6. Build VM: Windows Workstation (opsional)
info "--- Build Windows Workstation (opsional) ---"
if [ "${BUILD_WINDOWS:-no}" = "yes" ]; then
    build_workstation() {
        local vm="capstone-workstation"
        local disk="${IMAGE_DIR}/${vm}.qcow2"

        if [ ! -f "$disk" ]; then
            qemu-img create -f qcow2 "$disk" 40G
        fi

        # Virt-install untuk Windows
        virt-install \
            --name "$vm" \
            --memory 4096 \
            --vcpus 2 \
            --disk path="$disk",format=qcow2,bus=virtio \
            --cdrom "${IMAGE_DIR}/windows.iso" \
            --disk path="${IMAGE_DIR}/virtio-win.iso",device=cdrom \
            --os-variant win2k22 \
            --graphics vnc,listen=127.0.0.1 \
            --network network=lan,model=virtio \
            --boot cdrom,hd \
            --noautoconsole
    }
    build_workstation
else
    info "Skip Windows (set BUILD_WINDOWS=yes untuk build)"
fi

# 7. Tunggu semua VM
info "--- Menunggu semua VM ---"
for vm in capstone-router capstone-web capstone-db capstone-monitoring; do
    wait_vm "$vm" 300 || warn "VM $vm tidak siap dalam 5 menit"
done

# 8. Verifikasi
info "--- Verifikasi ---"
virsh list --all
virsh net-list --all

# 9. Selesai
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
info "=== Build selesai dalam ${DURATION} detik ==="

if [ $DURATION -gt 900 ]; then
    warn "Build melebihi target 15 menit"
else
    info "Build dalam target 15 menit"
fi
```

**Penjelasan:**
- `source` — include library.
- `build_router()` — build router.
- `build_web()` — build web.
- `build_db()` — build db.
- `build_monitoring()` — build monitoring.
- `build_workstation()` — build Windows.
- `wait_vm()` — tunggu VM.
- `virsh list --all` — verifikasi.

### 4.12. Skrip Destroy

**File `scripts/destroy.sh`:**

```bash
#!/bin/bash
#
# destroy.sh - Hapus semua VM capstone
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/network.sh"
source "${SCRIPT_DIR}/lib/vm.sh"

setup_trap
require_root

info "=== Memulai destroy capstone ==="
START_TIME=$(date +%s)

# 1. Hapus VM
info "--- Hapus VM ---"
VMS=("capstone-workstation" "capstone-monitoring" "capstone-db" "capstone-web" "capstone-router")

for vm in "${VMS[@]}"; do
    destroy_vm "$vm"
done

# 2. Hapus network
info "--- Hapus network ---"
teardown_networks

# 3. Hapus disk
info "--- Hapus disk ---"
for vm in "${VMS[@]}"; do
    local_disk="${IMAGE_DIR}/${vm}.qcow2"
    local_seed="${IMAGE_DIR}/${vm}-seed.img"
    [ -f "$local_disk" ] && rm -f "$local_disk"
    [ -f "$local_seed" ] && rm -f "$local_seed"
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
info "=== Destroy selesai dalam ${DURATION} detik ==="
```

**Penjelasan:**
- `destroy_vm()` — hapus VM.
- `teardown_networks()` — hapus network.
- Hapus disk.

### 4.13. Skrip Status

**File `scripts/status.sh`:**

```bash
#!/bin/bash
#
# status.sh - Status capstone
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

echo "=== Capstone Status ==="
echo

echo "--- VMs ---"
virsh list --all

echo
echo "--- Networks ---"
virsh net-list --all

echo
echo "--- Storage Pools ---"
virsh pool-list --all

echo
echo "--- Disk Usage ---"
df -h /var/lib/libvirt/images

echo
echo "--- Memory ---"
free -h

echo
echo "--- CPU ---"
top -bn1 | head -5
```

### 4.14. Skrip Backup

**File `scripts/backup.sh`:**

```bash
#!/bin/bash
#
# backup.sh - Backup semua VM capstone
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

setup_trap
require_root

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_SUBDIR="${BACKUP_DIR}/${DATE}"

mkdir -p "$BACKUP_SUBDIR"

VMS=("capstone-router" "capstone-web" "capstone-db" "capstone-monitoring")

info "=== Backup capstone ke $BACKUP_SUBDIR ==="

for vm in "${VMS[@]}"; do
    if ! vm_exists "$vm"; then
        warn "VM $vm tidak ada, skip"
        continue
    fi

    info "Backup VM $vm..."
    backup_file="${BACKUP_SUBDIR}/${vm}.qcow2"

    # Snapshot + blockcopy
    virsh blockcopy "$vm" vda "$backup_file" --wait --verbose || {
        warn "Blockcopy gagal, coba snapshot..."
        virsh snapshot-create-as "$vm" "backup-${DATE}" --disk-only --atomic
        virsh blockcopy "$vm" vda "$backup_file" --wait --verbose
        virsh blockcommit "$vm" vda --active --pivot
    }

    # Hash
    sha256sum "$backup_file" > "${backup_file}.sha256"

    # XML
    virsh dumpxml "$vm" > "${BACKUP_SUBDIR}/${vm}.xml"

    info "Backup $vm selesai"
done

# Hapus backup lama (>7 hari)
info "Hapus backup lama..."
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;

info "=== Backup selesai ==="
ls -lh "$BACKUP_SUBDIR"
```

### 4.15. Skrip Restore

**File `scripts/restore.sh`:**

```bash
#!/bin/bash
#
# restore.sh - Restore VM dari backup
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

setup_trap
require_root

BACKUP_DATE="${1:-}"

if [ -z "$BACKUP_DATE" ]; then
    # Ambil backup terbaru
    BACKUP_DATE=$(ls -t "$BACKUP_DIR" | head -1)
fi

BACKUP_SUBDIR="${BACKUP_DIR}/${BACKUP_DATE}"

if [ ! -d "$BACKUP_SUBDIR" ]; then
    error "Backup $BACKUP_DATE tidak ditemukan"
    exit 1
fi

info "=== Restore dari $BACKUP_SUBDIR ==="

for backup_file in "$BACKUP_SUBDIR"/*.qcow2; do
    vm=$(basename "$backup_file" .qcow2)
    target="${IMAGE_DIR}/${vm}.qcow2"

    info "Restore VM $vm..."

    # Hapus VM lama
    if vm_exists "$vm"; then
        destroy_vm "$vm"
    fi

    # Copy image
    cp "$backup_file" "$target"
    chown libvirt-qemu:kvm "$target" 2>/dev/null || chown qemu:qemu "$target"
    chmod 600 "$target"

    # Restore XML
    if [ -f "${BACKUP_SUBDIR}/${vm}.xml" ]; then
        virsh define "${BACKUP_SUBDIR}/${vm}.xml"
        virsh start "$vm"
    fi
done

info "=== Restore selesai ==="
```

### 4.16. Contoh user-data Router

**File `vms/router/user-data`:**

```yaml
#cloud-config
hostname: capstone-router
fqdn: router.capstone.local
manage_etc_hosts: true

users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... admin@capstone

package_update: true
packages:
  - nftables
  - dnsmasq
  - openssh

write_files:
  - path: /etc/nftables.conf
    content: |
      #!/usr/sbin/nft -f
      flush ruleset
      table inet filter {
        chain input {
          type filter hook input priority 0; policy drop;
          iif lo accept
          ct state established,related accept
          tcp dport 22 accept
          icmp type echo-request accept
        }
        chain forward {
          type filter hook forward priority 0; policy drop;
          iifname "eth0" oifname "eth1" ct state new accept
          iifname "eth1" oifname "eth0" ct state established,related accept
        }
        chain output {
          type filter hook output priority 0; policy accept;
        }
      }
    permissions: '0644'

runcmd:
  - sysctl -w net.ipv4.ip_forward=1
  - echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  - systemctl enable --now nftables
  - systemctl enable --now sshd

power_state:
  mode: reboot
  timeout: 30
  condition: True
```

**Penjelasan:**
- Router dengan nftables, IP forwarding.

### 4.17. Contoh user-data Web Server

**File `vms/web/user-data`:**

```yaml
#cloud-config
hostname: capstone-web
fqdn: web.capstone.local
manage_etc_hosts: true

users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... admin@capstone

package_update: true
packages:
  - nginx
  - php-fpm
  - ufw

write_files:
  - path: /var/www/html/index.html
    content: |
      <html>
        <head><title>Capstone Web Server</title></head>
        <body><h1>Selamat datang di Capstone!</h1></body>
      </html>
    permissions: '0644'

runcmd:
  - systemctl enable --now nginx
  - ufw allow 22/tcp
  - ufw allow 80/tcp
  - ufw allow 443/tcp
  - ufw --force enable
  - echo "Provisioning web selesai $(date)" >> /var/log/cloud-init-custom.log

power_state:
  mode: reboot
  timeout: 30
  condition: True
```

### 4.18. Contoh user-data Database

**File `vms/db/user-data`:**

```yaml
#cloud-config
hostname: capstone-db
fqdn: db.capstone.local
manage_etc_hosts: true

users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... admin@capstone

package_update: true
package_upgrade: true
packages:
  - postgresql
  - postgresql-libs

runcmd:
  - sudo -u postgres initdb -D /var/lib/postgresql/data || true
  - systemctl enable --now postgresql
  - echo "Provisioning db selesai $(date)" >> /var/log/cloud-init-custom.log

power_state:
  mode: reboot
  timeout: 30
  condition: True
```

### 4.19. Contoh domain.xml Router

**File `vms/router/domain.xml`:**

```xml
<domain type='kvm'>
  <name>capstone-router</name>
  <memory unit='MiB'>512</memory>
  <currentMemory unit='MiB'>512</currentMemory>
  <vcpu placement='static'>1</vcpu>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
  </os>

  <features>
    <acpi/>
    <apic/>
  </features>

  <cpu mode='host-passthrough' check='none'/>

  <clock offset='utc'/>

  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
      <source file='@DISK@'/>
      <target dev='vda' bus='virtio'/>
    </disk>

    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='@SEED@'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>

    <controller type='pci' index='0' model='pcie-root'/>
    <controller type='sata' index='0'/>

    <interface type='network'>
      <source network='wan'/>
      <model type='virtio'/>
    </interface>
    <interface type='network'>
      <source network='dmz'/>
      <model type='virtio'/>
    </interface>
    <interface type='network'>
      <source network='lan'/>
      <model type='virtio'/>
    </interface>
    <interface type='network'>
      <source network='mgmt'/>
      <model type='virtio'/>
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
    <video><model type='none'/></video>
    <controller type='usb' index='0' model='none'/>
  </devices>

  <seclabel type='dynamic' model='dac' relabel='yes'/>
</domain>
```

**Penjelasan:**
- 4 interface: wan, dmz, lan, mgmt.
- Hardened: no graphics, no usb, no sound.

### 4.20. Unit systemd untuk Router

**File `systemd/vm-router.service`:**

```ini
[Unit]
Description=Capstone Router VM
After=network-online.target libvirtd.service
Wants=network-online.target
Requires=libvirtd.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/virsh start capstone-router
ExecStop=/usr/bin/virsh shutdown capstone-router
TimeoutStartSec=300
TimeoutStopSec=300
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### 4.21. Unit systemd untuk Web (depends on Router)

**File `systemd/vm-web.service`:**

```ini
[Unit]
Description=Capstone Web Server VM
After=vm-router.service
Requires=vm-router.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/virsh start capstone-web
ExecStop=/usr/bin/virsh shutdown capstone-web
TimeoutStartSec=300
TimeoutStopSec=300

[Install]
WantedBy=multi-user.target
```

### 4.22. Runbook

**File `runbook.md`:**

```markdown
# Capstone Runbook

## Arsitektur

- **Router VM** (Alpine): Routing, firewall, DHCP, DNS.
- **Web Server** (Debian): Nginx, PHP.
- **Database** (Arch): PostgreSQL.
- **Workstation** (Windows Server Core): Workstation.
- **Monitoring** (Alpine): Prometheus, Grafana.

## Network

| Zona | CIDR | Gateway | Fungsi |
|------|------|---------|--------|
| WAN | 192.168.122.0/24 | 192.168.122.1 | Internet |
| DMZ | 10.0.10.0/24 | 10.0.10.1 | Web server |
| LAN | 10.0.20.0/24 | 10.0.20.1 | Database, workstation |
| MGMT | 10.0.30.0/24 | 10.0.30.1 | Monitoring |

## Perintah

### Build

```bash
make build
```

### Destroy

```bash
make destroy
```

### Status

```bash
make status
```

### Backup

```bash
make backup
```

### Restore

```bash
./scripts/restore.sh 2024-01-15-10-30-00
```

## Troubleshooting

### VM tidak start

```bash
virsh domstate capstone-web
virsh dumpxml capstone-web
virsh console capstone-web
tail -50 /var/log/libvirt/qemu/capstone-web.log
```

### Network mati

```bash
virsh net-list --all
virsh net-info lan
virsh domiflist capstone-web
```

### Disk penuh

```bash
qemu-img info /var/lib/libvirt/images/capstone-web.qcow2
qemu-img resize /var/lib/libvirt/images/capstone-web.qcow2 +10G
```

## Kontak

- Admin: admin@capstone.local
- Dokumentasi: https://github.com/user/capstone
```

### 4.23. Git Integration

**File `.gitignore`:**

```
*.qcow2
*.img
*.log
/tmp/
*.swp
```

**Inisialisasi Git:**
```bash
git init
git add .
git commit -m "Initial capstone"
git remote add origin git@github.com:user/capstone.git
git push -u origin main
```

### 4.24. CI/CD (Opsional)

**File `.github/workflows/build.yml`:**

```yaml
name: Build Capstone

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: ShellCheck
        run: shellcheck scripts/*.sh scripts/lib/*.sh
      - name: Validate XML
        run: |
          for xml in config/networks/*.xml vms/*/domain.xml; do
            xmllint --noout "$xml"
          done
      - name: Validate YAML
        run: |
          for yaml in vms/*/user-data; do
            python -c "import yaml; yaml.safe_load(open('$yaml'))"
          done
```

**Penjelasan:**
- Lint skrip.
- Validasi XML.
- Validasi YAML.

### 4.25. Verifikasi Capstone

```bash
# 1. Build
make build

# 2. Cek VM
virsh list --all
# Output: 4-5 VM running

# 3. Cek network
virsh net-list --all
# Output: 4 network active

# 4. Cek SSH
ssh admin@10.0.10.100  # web
ssh admin@10.0.20.100  # db

# 5. Cek web
curl http://10.0.10.100
# Output: halaman web

# 6. Cek DB
ssh admin@10.0.20.100 "systemctl status postgresql"

# 7. Cek monitoring
curl http://10.0.30.100:9090

# 8. Cek firewall
ssh admin@10.0.20.100 "sudo nft list ruleset"

# 9. Backup
make backup
ls -lh /backup/vm/

# 10. Destroy
make destroy
virsh list --all
# Output: kosong
```

---

## 5. Diagram Arsitektur Capstone

### 5.1. Arsitektur Lengkap

```
                        +-------------------+
                        |   Internet        |
                        +-------------------+
                                  |
                                  | WAN
                                  v
                        +-------------------+
                        |  Router VM        |
                        |  (Alpine)         |
                        |  nftables, DHCP   |
                        +-------------------+
                          |       |       |
                  DMZ ----+       |       +---- MGMT
                  |               |               |
                  v               v               v
        +-------------------+ +-------------------+ +-------------------+
        |  Web Server       | |  Database         | |  Monitoring       |
        |  (Debian)         | |  (Arch)           | |  (Alpine)         |
        |  Nginx            | |  PostgreSQL       | |  Prometheus       |
        +-------------------+ +-------------------+ +-------------------+
                                  ^
                                  | LAN
                                  v
                        +-------------------+
                        |  Workstation      |
                        |  (Windows)        |
                        +-------------------+
```

### 5.2. Struktur Proyek

```
capstone/
├── Makefile
├── README.md
├── runbook.md
├── .gitignore
├── scripts/
│   ├── build.sh
│   ├── destroy.sh
│   ├── backup.sh
│   ├── restore.sh
│   ├── status.sh
│   └── lib/
│       ├── common.sh
│       ├── network.sh
│       └── vm.sh
├── config/
│   └── networks/
│       ├── wan.xml
│       ├── dmz.xml
│       ├── lan.xml
│       └── mgmt.xml
├── vms/
│   ├── router/
│   ├── web/
│   ├── db/
│   ├── workstation/
│   └── monitoring/
├── hooks/
│   └── qemu
└── systemd/
    ├── vm-router.service
    ├── vm-web.service
    ├── vm-db.service
    ├── vm-workstation.service
    ├── vm-monitoring.service
    └── vm-backup.timer
```

### 5.3. Alur Build

```
make build
  |
  v
+-------------------+
|  build.sh         |
+-------------------+
  |
  +-- setup_networks
  |     |
  |     +-- wan
  |     +-- dmz
  |     +-- lan
  |     +-- mgmt
  |
  +-- build_router
  +-- build_web
  +-- build_db
  +-- build_monitoring
  +-- build_workstation (opsional)
  |
  v
+-------------------+
|  Verifikasi       |
+-------------------+
```

### 5.4. Alur Destroy

```
make destroy
  |
  v
+-------------------+
|  destroy.sh       |
+-------------------+
  |
  +-- destroy_vm (semua)
  +-- teardown_networks
  +-- hapus disk
  |
  v
+-------------------+
|  Selesai          |
+-------------------+
```

### 5.5. Alur Backup

```
systemd timer
  |
  v
+-------------------+
|  backup.sh        |
+-------------------+
  |
  +-- blockcopy
  +-- hash
  +-- dumpxml
  +-- hapus lama
  |
  v
+-------------------+
|  Backup selesai   |
+-------------------+
```

### 5.6. Alur Recovery

```
VM rusak
  |
  v
+-------------------+
|  Diagnostik       |
+-------------------+
  |
  v
+-------------------+
|  restore.sh       |
+-------------------+
  |
  +-- destroy VM lama
  +-- copy image
  +-- define XML
  +-- start VM
  |
  v
+-------------------+
|  VM pulih         |
+-------------------+
```

### 5.7. Pohon Keputusan Build

```
Apakah VM sudah ada?
├── Ya → Skip atau destroy
└── Tidak → Apakah disk ada?
    ├── Ya → Pakai
    └── Tidak → Buat disk

Apakah network ada?
├── Ya → Start
└── Tidak → Define + start

Apakah seed ada?
├── Ya → Pakai
└── Tidak → Buat
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 7.5

Kurikulum asli menyebut:
> **Tugas:**
> - Infrastruktur 4+ VM multi-OS.
> - Build & destroy dengan satu perintah.
> - Skrip idempotent, target <15 menit.
> - Runbook terdokumentasi.
>
> **Validasi Lulus:**
> - Skrip capstone berhasil dari nol.

Kita akan menambahkan:
1. **Arsitektur 5 VM**: router, web, db, workstation, monitoring.
2. **Multi-OS**: Alpine, Debian, Arch, Windows.
3. **Segmentasi jaringan**: WAN, DMZ, LAN, MGMT.
4. **Skrip modular**: `lib/common.sh`, `lib/network.sh`, `lib/vm.sh`.
5. **Makefile** untuk orkestrasi.
6. **Idempotensi**: cek VM, network, disk.
7. **Error handling**: `set -euo pipefail`, `trap`.
8. **Logging**: `log()`, `info()`, `warn()`, `error()`.
9. **Backup & restore**: `blockcopy`, `sha256sum`, `dumpxml`.
10. **systemd**: autostart, dependency, timer.
11. **Hook**: `qemu` hook.
12. **Runbook**: dokumentasi lengkap.
13. **Git integration**: `.gitignore`, commit.
14. **CI/CD**: GitHub Actions, shellcheck, xmllint, YAML.
15. **Verifikasi**: SSH, curl, nft.
16. **Target**: build <15 menit, destroy <5 menit.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 7.5.

---

## 7. Hubungan dengan Modul Lain

- **Fase 1–6**: semua materi digunakan.
- **Modul 7.1 (cloud-init)**: provisioning Linux.
- **Modul 7.2 (Windows)**: provisioning Windows.
- **Modul 7.3 (Skrip)**: Bash, hook, systemd.
- **Modul 7.4 (Troubleshooting)**: debugging.
- **Fase 8 (Expert)**: live migration, VFIO, observability.

---

## 8. Referensi Lengkap

- libvirt Domain XML — https://libvirt.org/formatdomain.html
- libvirt Network XML — https://libvirt.org/formatnetwork.html
- libvirt Storage XML — https://libvirt.org/formatstorage.html
- cloud-init — https://cloud-init.readthedocs.io/
- cloud-localds — https://manpages.ubuntu.com/manpages/focal/man1/cloud-localds.1.html
- Alpine Cloud Image — https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/cloud/
- Debian Cloud Image — https://cloud.debian.org/images/cloud/
- Arch Cloud Image — https://geo.mirror.pkgbuild.com/images/latest/
- Virtio-win — https://github.com/virtio-win/virtio-win-pkg-scripts
- Makefile — https://www.gnu.org/software/make/manual/
- Bash Manual — https://www.gnu.org/software/bash/manual/
- ShellCheck — https://www.shellcheck.net/
- GitHub Actions — https://docs.github.com/en/actions
- libvirt Hooks — https://libvirt.org/hooks.html
- systemd — https://www.freedesktop.org/software/systemd/man/
- Git — https://git-scm.com/doc
- NIST SP 800-125 — https://csrc.nist.gov/publications/detail/sp/800-125/final
- CIS Benchmarks — https://www.cisecurity.org/cis-benchmarks

---

## 9. Tips & Praktik Terbaik

1. **Modular**: pisahkan skrip ke library.
2. **Idempotent**: cek sebelum buat.
3. **Error handling**: `set -euo pipefail`.
4. **Logging**: setiap aksi.
5. **Trap**: cleanup.
6. **Validasi**: shellcheck, xmllint, YAML.
7. **Version control**: Git.
8. **Dokumentasi**: runbook.
9. **Test**: build, destroy, backup, restore.
10. **Target waktu**: build <15 menit.
11. **Backup**: sebelum perubahan.
12. **Security**: hardening, confinement.
13. **Monitoring**: audit, logging.
14. **CI/CD**: otomasi test.
15. **Review**: kode dan arsitektur.
16. **Iterasi**: perbaiki terus.
17. **Kolaborasi**: Git, issue, PR.
18. **Feedback**: dari komunitas.
19. **Portofolio**: tunjukkan ke employer.
20. **Jangan takut gagal**: belajar dari error.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Build gagal | Network belum ada. | Setup network dulu. |
| VM tidak start | Disk tidak ada. | Cek path disk. |
| cloud-init gagal | YAML salah. | Validasi YAML. |
| SSH tidak bisa | Firewall. | Cek nftables. |
| Network tidak connect | Bridge down. | Restart network. |
| Disk penuh | Image kecil. | Resize. |
| Backup gagal | VM sibuk. | Snapshot dulu. |
| Restore gagal | XML tidak ada. | Backup XML. |
| systemd gagal | Path virsh. | Gunakan `/usr/bin/virsh`. |
| Hook tidak jalan | Permission. | `chmod 755`. |
| Idempotensi gagal | Tidak cek. | Tambah cek. |
| Build lambat | Download image. | Pre-download. |
| Destroy lambat | Shutdown graceful. | Gunakan `destroy`. |
| Log penuh | Tidak ada rotasi. | Logrotate. |
| Git conflict | Branch. | Merge. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `make build` berhasil <15 menit.
- 5 VM berjalan.
- 4 network aktif.
- SSH ke setiap VM berhasil.
- Web server bisa diakses.
- Database berjalan.
- Monitoring berjalan.
- `make destroy` berhasil <5 menit.
- `make backup` berhasil.
- `make restore` berhasil.
- Runbook lengkap.
- Git commit ada.
- CI/CD berjalan (opsional).

**Troubleshooting:**
- Jika build gagal: cek log, cek network.
- Jika VM tidak start: cek disk, cek XML.
- Jika SSH gagal: cek firewall, cek cloud-init.
- Jika backup gagal: cek VM, cek disk.
- Jika restore gagal: cek backup, cek XML.
- Jika systemd gagal: `systemctl status`, `journalctl`.
- Untuk debugging: `bash -x`, `strace`, `virsh console`.

---

## 12. Latihan Mandiri

1. Buat struktur proyek.
2. Buat Makefile.
3. Buat library common.
4. Buat library network.
5. Buat library vm.
6. Buat XML network.
7. Buat user-data.
8. Buat domain XML.
9. Buat build.sh.
10. Buat destroy.sh.
11. Buat backup.sh.
12. Buat restore.sh.
13. Buat status.sh.
14. Buat systemd unit.
15. Buat hook.
16. Buat runbook.
17. Inisialisasi Git.
18. Buat CI/CD.
19. Test build.
20. Test destroy.
21. Test backup.
22. Test restore.
23. Dokumentasikan.
24. Tulis ringkasan.

---

## 13. Penutup Modul 7.5 & Fase 7

Anda kini menguasai **Capstone** — puncak Fase 7. Anda bisa:
- Membangun **infrastruktur 5 VM multi-OS**.
- Menggunakan **segmentasi jaringan** (WAN, DMZ, LAN, MGMT).
- Mengotomasi **build & destroy** dengan satu perintah.
- Membuat **skrip idempotent**, modular, dengan error handling.
- Menggunakan **Makefile** untuk orkestrasi.
- Membuat **backup & restore** otomatis.
- Menggunakan **systemd** untuk autostart dan dependency.
- Membuat **runbook** lengkap.
- Menggunakan **Git** untuk version control.
- Membuat **CI/CD** (opsional).

**Proyek Fase 7:** Capstone selesai.

**Rubrik Fase 7:**
| Kriteria | Bobot |
|---|---|
| cloud-init | 20% |
| Windows headless | 20% |
| Otomasi | 20% |
| Troubleshooting | 20% |
| Capstone | 20% |

---

*Motivasi: Anda telah menempuh perjalanan panjang. Dari fondasi virtualisasi hingga capstone multi-OS. Setiap baris skrip, setiap XML, setiap user-data adalah bukti kerja Anda. Capstone bukan akhir, tetapi awal. Dengan ini, Anda bukan lagi pembelajar — Anda adalah engineer. Selamat!*

---

**Selamat!** Anda telah menyelesaikan **Fase 7 — Otomasi, Troubleshooting & Capstone Multi-OS**. Berikutnya adalah **Fase 8 — Expert: Migrasi, Passthrough & Observability (Opsional)**.

Anda telah menempuh perjalanan yang luar biasa:

- **Fase 1** — Fondasi Virtualisasi & Host Hardening
- **Fase 2** — QEMU/KVM Murni (Tanpa libvirt)
- **Fase 3** — libvirt & virsh: Lifecycle & Domain XML
- **Fase 4** — Storage, Image & Backup Engineering
- **Fase 5** — Networking & Isolasi Jaringan
- **Fase 6** — Keamanan & Isolasi Lanjutan
- **Fase 7** — Otomasi, Troubleshooting & Capstone Multi-OS

---

**Yang tersisa dalam kurikulum:**

- **Fase 8** — Expert: Migrasi, Passthrough & Observability (5 modul, opsional)

---

Sampai jumpa di Fase 8. 🚀

---


> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
