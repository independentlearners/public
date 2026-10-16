# [Audit Fase 8 — Expert: Migrasi, Passthrough & Observability][0]

**Estimasi:** 3–4 minggu  
**Prasyarat:** Fase 1–7 lulus; hardware mendukung IOMMU.

## Daftar Isi Fase 8 (dari kurikulum)
1. Modul 8.1 — Live Migration
2. Modul 8.2 — VFIO/IOMMU Passthrough
3. Modul 8.3 — SR-IOV & virtiofs
4. Modul 8.4 — NUMA, CPU Pinning, Hugepages, KSM
5. Modul 8.5 — Observability & API libvirt

## Hasil Audit & Rekomendasi Tambahan
Kurikulum sudah menyebut topik-topik expert, tetapi beberapa sub-topik penting belum eksplisit. Saya merekomendasikan penambahan berikut agar Fase 8 benar-benar komprehensif:

- **8.1a — Storage Migration & Tunneled Migration**  
  Migrasi disk saat VM berjalan, serta migrasi melalui tunnel SSH.
- **8.1b — Tuning Migrasi: Bandwidth, Compression, Auto-converge, Post-copy**  
  Optimasi downtime dan kecepatan migrasi.
- **8.2a — IOMMU Group & Isolasi Perangkat**  
  Memahami grup IOMMU dan cara mengisolasi perangkat.
- **8.2b — vfio-pci Binding & Driver Override**  
  Cara mengikat perangkat ke `vfio-pci` dan melepas driver host.
- **8.3a — SR-IOV Virtual Function (VF) & Switchdev**  
  Konfigurasi VF, representor, dan offload.
- **8.3b — virtiofs & Shared Memory (memfd, DAX)**  
  Sharing filesystem dengan performa tinggi.
- **8.4a — NUMA Topology & numatune**  
  Pemetaan memori dan CPU ke node NUMA.
- **8.4b — CPU Pinning, Isolation, & Real-time**  
  Isolasi CPU, `isolcpus`, `nohz_full`, `rcu_nocbs`.
- **8.4c — Hugepages & KSM**  
  Hugepages statis/dinamis, KSM tuning.
- **8.5a — libvirt API (Python, Go) & Event Loop**  
  Otomasi via API, bukan hanya virsh.
- **8.5b — Metrics, Tracing, & Observability**  
  Prometheus, Grafana, eBPF, `perf`, `bpftrace`.

Dengan tambahan ini, Fase 8 akan mencakup seluruh spektrum expert. Untuk saat ini, kita mulai dari **Modul 8.1 — Live Migration**.

---

# Modul 8.1 — Live Migration

## Mini-Daftar Isi Modul 8.1
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Live Migration
6. Audit Kurikulum: Tambahan untuk Modul 8.1
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 8.1

---

> *Motivasi: Memindahkan VM yang sedang berjalan tanpa mematikannya adalah salah satu pencapaian paling elegan dalam virtualisasi. Ia seperti memindahkan rumah beserta penghuninya tanpa membangunkan mereka. Live migration adalah puncak dari ketersediaan tinggi dan fleksibilitas operasional.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Live migration** adalah proses memindahkan **VM yang sedang berjalan** dari satu host fisik ke host fisik lain **tanpa mematikan VM** atau menghentikan layanan di dalamnya. Downtime yang terjadi biasanya hanya **beberapa milidetik hingga beberapa detik**, tidak terlihat oleh pengguna.

Dalam konteks Arch Linux dengan libvirt/QEMU/KVM, live migration memungkinkan:
- **Maintenance host** tanpa mengganggu VM.
- **Load balancing** antar host.
- **High availability** dan **failover**.
- **Migrasi ke hardware baru**.
- **Konsolidasi server**.

**Peran dalam kurikulum:** Modul ini adalah **fondasi untuk operasi tingkat lanjut** di Fase 8. Setelah Anda menguasai virtualisasi, storage, jaringan, keamanan, dan otomasi, sekarang Anda belajar **memindahkan beban kerja secara dinamis**. Ini adalah keterampilan yang membedakan **sysadmin** dari **cloud engineer**. Live migration juga prasyarat untuk:
- **Modul 8.5 (Observability)**: memantau migrasi.
- **Fase 8 lanjutan**: migrasi terotomasi, cluster.
- **Karier**: OpenStack, Proxmox, oVirt, Kubernetes.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Pre-copy vs Post-copy Migration

- **Pre-copy**: memori VM disalin **sebelum** VM dipindahkan. Halaman yang berubah selama penyalinan dikirim ulang. Setelah cukup sinkron, VM dihentikan sejenak, sisa halaman dikirim, lalu VM dilanjutkan di host tujuan. Ini yang paling umum.
- **Post-copy**: VM langsung dijalankan di host tujuan, lalu halaman memori diambil dari host sumber **saat dibutuhkan** (page fault). Downtime sangat kecil, tetapi jika host sumber mati, VM bisa crash.

**Filosofi:** *Pre-copy aman tapi bisa lambat. Post-copy cepat tapi berisiko.*

### 2.2. Shared Storage vs Block Migration

- **Shared storage**: disk VM berada di storage yang bisa diakses kedua host (NFS, iSCSI, Ceph). Migrasi hanya memindahkan **status memori dan CPU**, bukan disk. Ini cara tercepat dan paling umum.
- **Block migration**: disk VM **juga dipindahkan** saat migrasi. Lebih lambat, tetapi tidak perlu shared storage.

**Filosofi:** *Shared storage adalah jalan tol. Block migration adalah jalan biasa.*

### 2.3. Transport: SSH, TCP, Unix

libvirt mendukung beberapa transport untuk migrasi:
- **SSH**: aman, terenkripsi, tetapi lebih lambat karena overhead.
- **TCP**: cepat, tetapi tidak terenkripsi (bisa dibungkus tunnel).
- **Unix socket**: untuk host yang sama (tidak umum).

**Filosofi:** *SSH untuk keamanan. TCP untuk kecepatan. Tunnel untuk keduanya.*

### 2.4. Tuning: Bandwidth, Compression, Auto-converge

- **Bandwidth**: batasi kecepatan migrasi agar tidak membanjiri jaringan.
- **Compression**: kompresi halaman memori (xbzrle, zlib, zstd) untuk mengurangi data.
- **Auto-converge**: perlambat vCPU jika migrasi tidak kunjung selesai.
- **Post-copy**: fallback jika pre-copy gagal.
- **Multithread compression**: gunakan banyak thread untuk kompresi.

**Filosofi:** *Migrasi adalah seni menyeimbangkan kecepatan dan downtime.*

### 2.5. Downtime

Downtime adalah waktu di mana VM **benar-benar berhenti** saat migrasi. Target: **< 100 ms**. Untuk mencapai ini, perlu:
- Jaringan cepat.
- CPU yang cukup.
- Memori tidak terlalu besar.
- Tuning parameter migrasi.

**Filosofi:** *Downtime adalah musuh. Kecilkan dengan tuning.*

### 2.6. Konektivitas Jaringan

Setelah migrasi, VM harus tetap memiliki:
- IP address yang sama.
- Koneksi jaringan yang sama.
- MAC address yang sama.
- Jika menggunakan bridge, bridge harus ada di kedua host.

**Filosofi:** *VM tidak boleh sadar bahwa ia telah pindah.*

### 2.7. Kompatibilitas CPU

Host tujuan harus memiliki **CPU yang kompatibel** dengan host sumber. Jika tidak, VM tidak bisa dimigrasikan. Solusi:
- Gunakan `cpu mode='host-model'` atau `custom`.
- Gunakan `check='none'` dengan hati-hati.
- Pastikan fitur CPU yang sama.

**Filosofi:** *CPU adalah bahasa. Kedua host harus berbicara bahasa yang sama.*

### 2.8. Filosofi Keseluruhan

- **Pre-copy adalah default.**
- **Post-copy adalah cadangan.**
- **Shared storage adalah kunci.**
- **SSH adalah pengaman.**
- **Tuning adalah seni.**
- **Downtime adalah target.**
- **Kompatibilitas adalah syarat.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Live Migration** | Migrasi VM berjalan. | |
| **Pre-copy** | Salin memori dulu. | |
| **Post-copy** | Jalankan dulu, ambil memori. | |
| **Downtime** | Waktu VM berhenti. | |
| **Shared Storage** | Storage bersama. | NFS, iSCSI, Ceph |
| **Block Migration** | Migrasi disk. | |
| **Tunneled Migration** | Migrasi via SSH. | |
| **Migration URI** | Alamat tujuan. | `qemu+ssh://host2/system` |
| **Migration Port** | Port migrasi. | 49152-49216 |
| **xbzrle** | Kompresi memori. | |
| **Auto-converge** | Perlambat vCPU. | |
| **Multithread Compression** | Kompresi paralel. | |
| **CPU Compatibility** | Kompatibilitas CPU. | |
| **Host Model** | Model CPU host. | |
| **Domain XML** | Konfigurasi VM. | |
| **virsh migrate** | Perintah migrasi. | |
| **QEMU Migration** | Migrasi di level QEMU. | |
| **Migration Capabilities** | Fitur migrasi. | |
| **Migration Parameters** | Parameter migrasi. | |
| **Migration Status** | Status migrasi. | |
| **Migration Statistics** | Statistik migrasi. | |
| **Migration Error** | Error migrasi. | |
| **Migration Thread** | Thread migrasi. | |
| **Migration Bandwidth** | Bandwidth migrasi. | |
| **Migration Downtime** | Downtime migrasi. | |
| **Migration Time** | Waktu migrasi. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Prasyarat Live Migration

1. **Dua host** dengan Arch Linux + libvirt + QEMU/KVM.
2. **Jaringan** yang menghubungkan kedua host.
3. **Shared storage** (NFS, iSCSI, Ceph) untuk disk VM, atau block migration.
4. **Konfigurasi libvirt** yang sama di kedua host.
5. **SSH key** untuk akses non-root antar host (jika menggunakan `qemu+ssh`).
6. **CPU kompatibel**.
7. **Nama VM dan network** harus sama di kedua host.

### 4.2. Setup SSH Antar Host

```bash
# Di host1
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
ssh-copy-id user@host2

# Test
ssh user@host2 "virsh list --all"
```

**Penjelasan kata demi kata:**
- `ssh-keygen -t ed25519` — buat key ED25519.
- `-f ~/.ssh/id_ed25519` — file key.
- `-N ""` — tanpa passphrase.
- `ssh-copy-id` — copy public key ke host2.
- `ssh user@host2 "virsh list --all"` — test koneksi.

### 4.3. Migrasi Dasar dengan Shared Storage

```bash
# Di host1
virsh migrate --live arch-vm qemu+ssh://user@host2/system
```

**Penjelasan kata demi kata:**
- `virsh migrate` — perintah migrasi.
- `--live` — migrasi live.
- `arch-vm` — nama VM.
- `qemu+ssh://user@host2/system` — URI tujuan.
  - `qemu+ssh` — transport SSH.
  - `user@host2` — user dan host.
  - `/system` — koneksi system libvirt.

**Opsi lengkap:**
```bash
virsh migrate \
  --live \
  --persistent \
  --undefinesource \
  --verbose \
  --timeout 300 \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--persistent` — VM tetap ada setelah migrasi.
- `--undefinesource` — hapus VM di sumber.
- `--verbose` — tampilkan progres.
- `--timeout 300` — timeout 300 detik.

### 4.4. Migrasi dengan Block Migration

```bash
virsh migrate \
  --live \
  --blockcopy \
  --verbose \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--blockcopy` — migrasi disk juga.
- `--live` — live.
- `--verbose` — progres.

**Alternatif:**
```bash
virsh migrate --live --copy-storage-all arch-vm qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--copy-storage-all` — copy semua storage.

### 4.5. Migrasi dengan Tunnel SSH

```bash
virsh migrate \
  --live \
  --tunnelled \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--tunnelled` — migrasi melalui tunnel SSH.
- Lebih aman, tetapi lebih lambat.

### 4.6. Migrasi dengan Parameter Tuning

```bash
virsh migrate \
  --live \
  --verbose \
  --migrate-disks vda \
  --compressed \
  --auto-converge \
  --bandwidth 1000 \
  --timeout 300 \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--migrate-disks vda` — hanya migrasi disk vda.
- `--compressed` — kompresi.
- `--auto-converge` — auto-converge.
- `--bandwidth 1000` — bandwidth 1000 MiB/s.
- `--timeout 300` — timeout.

### 4.7. Migrasi Post-copy

```bash
virsh migrate \
  --live \
  --postcopy \
  --postcopy-after-precopy \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--postcopy` — gunakan post-copy.
- `--postcopy-after-precopy` — post-copy setelah pre-copy gagal.

### 4.8. Migrasi Offline

```bash
virsh migrate \
  --offline \
  --persistent \
  --undefinesource \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--offline` — migrasi offline (VM mati).

### 4.9. Melihat Status Migrasi

```bash
# Di host1
virsh migrate --live --verbose arch-vm qemu+ssh://user@host2/system

# Di host2
virsh list --all
virsh domstate arch-vm
```

**Penjelasan:**
- `--verbose` — tampilkan status.

### 4.10. Konfigurasi libvirt untuk Migrasi

**Di `/etc/libvirt/libvirtd.conf` (host1 dan host2):**

```ini
listen_tls = 0
listen_tcp = 1
tcp_port = "16509"
auth_tcp = "sasl"
```

**Penjelasan:**
- `listen_tcp = 1` — aktifkan TCP.
- `tcp_port = "16509"` — port.
- `auth_tcp = "sasl"` — autentikasi SASL.

**Alternatif SSH:**
```ini
# Tidak perlu konfigurasi khusus jika menggunakan qemu+ssh
```

### 4.11. Konfigurasi QEMU untuk Migrasi

**Di `/etc/libvirt/qemu.conf`:**

```ini
migration_port_min = 49152
migration_port_max = 49216
```

**Penjelasan:**
- `migration_port_min` — port migrasi minimum.
- `migration_port_max` — port migrasi maksimum.

### 4.12. Migrasi dengan XML

**File `migrate.xml`:**

```xml
<domain type='kvm'>
  <name>arch-vm</name>
  <memory unit='MiB'>1024</memory>
  <vcpu>2</vcpu>
  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
  </os>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/arch-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
  </devices>
</domain>
```

**Migrasi:**
```bash
virsh migrate --live --xml migrate.xml arch-vm qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--xml` — gunakan XML ini di host tujuan.

### 4.13. Migrasi dengan Storage Migration

```bash
virsh migrate \
  --live \
  --copy-storage-inc \
  --verbose \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--copy-storage-inc` — copy storage incremental.
- Hanya blok yang berubah.

### 4.14. Migrasi dengan Snapshot

```bash
# Di host1
virsh snapshot-create-as arch-vm pre-migrate
virsh migrate --live arch-vm qemu+ssh://user@host2/system
virsh snapshot-delete arch-vm pre-migrate
```

**Penjelasan:**
- Snapshot sebelum migrasi untuk rollback.

### 4.15. Migrasi dengan Hook

**File `/etc/libvirt/hooks/qemu`:**

```bash
#!/bin/bash
set -euo pipefail

VM_NAME="$1"
EVENT="$2"
SUB_EVENT="${3:-}"

LOG="/var/log/libvirt/hooks-migrate.log"

log() { echo "[$(date '+%F %T')] VM=$VM_NAME EVENT=$EVENT SUB=$SUB_EVENT :: $*" >> "$LOG"; }

case "$EVENT" in
    migrate)
        log "Migrasi: $SUB_EVENT"
        if [ "$SUB_EVENT" = "begin" ]; then
            log "Migrasi dimulai"
        elif [ "$SUB_EVENT" = "end" ]; then
            log "Migrasi selesai"
        fi
        ;;
esac

exit 0
```

**Penjelasan:**
- Hook untuk event migrasi.
- `SUB_EVENT` bisa `begin`, `end`, `failed`.

### 4.16. Migrasi dengan Python libvirt API

```python
#!/usr/bin/env python3
import libvirt
import sys

def migrate_vm(vm_name, dest_uri):
    conn = libvirt.open('qemu:///system')
    if conn is None:
        print('Gagal membuka koneksi', file=sys.stderr)
        sys.exit(1)

    dom = conn.lookupByName(vm_name)
    if dom is None:
        print(f'VM {vm_name} tidak ditemukan', file=sys.stderr)
        sys.exit(1)

    # Parameter migrasi
    flags = libvirt.VIR_MIGRATE_LIVE | libvirt.VIR_MIGRATE_PERSIST_DEST
    params = {
        libvirt.VIR_MIGRATE_PARAM_BANDWIDTH: 1000,
        libvirt.VIR_MIGRATE_PARAM_AUTO_CONVERGE: 1,
    }

    try:
        dom.migrate(conn, flags, dest_uri, params=params, bandwidth=1000)
        print(f'Migrasi {vm_name} berhasil')
    except libvirt.libvirtError as e:
        print(f'Migrasi gagal: {e}', file=sys.stderr)
        sys.exit(1)
    finally:
        conn.close()

if __name__ == '__main__':
    migrate_vm('arch-vm', 'qemu+ssh://user@host2/system')
```

**Penjelasan:**
- `libvirt.open` — buka koneksi.
- `lookupByName` — cari VM.
- `migrate` — migrasi.
- `flags` — flag migrasi.
- `params` — parameter.

### 4.17. Migrasi dengan QEMU Native

```bash
# Di host2 (tujuan)
qemu-system-x86_64 -incoming tcp:0:4444 ...

# Di host1 (sumber)
qemu-system-x86_64 ... -monitor stdio
(qemu) migrate -d tcp:host2:4444
(qemu) info migrate
```

**Penjelasan:**
- `-incoming` — mode terima.
- `migrate -d` — migrasi.
- `info migrate` — status.

### 4.18. Tuning Migration Parameters

```bash
# Set parameter
virsh migrate-setmaxdowntime arch-vm 100
virsh migrate-setspeed arch-vm 1000
virsh migrate-setmaxdowntime arch-vm 100

# Lihat parameter
virsh migrate-getmaxdowntime arch-vm
virsh migrate-getspeed arch-vm
```

**Penjelasan:**
- `migrate-setmaxdowntime` — downtime maksimum (ms).
- `migrate-setspeed` — bandwidth (MiB/s).
- `migrate-getmaxdowntime` — lihat.
- `migrate-getspeed` — lihat.

### 4.19. Migrasi dengan Compression

```bash
virsh migrate \
  --live \
  --compressed \
  --comp-methods zstd \
  --comp-level 1 \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--compressed` — aktifkan kompresi.
- `--comp-methods zstd` — metode zstd.
- `--comp-level 1` — level 1 (cepat).

### 4.20. Migrasi dengan Multithread

```bash
virsh migrate \
  --live \
  --compressed \
  --comp-methods zstd \
  --comp-threads 4 \
  arch-vm \
  qemu+ssh://user@host2/system
```

**Penjelasan:**
- `--comp-threads 4` — 4 thread kompresi.

### 4.21. Verifikasi Migrasi

```bash
# Di host1
virsh list --all
# Output: arch-vm tidak ada (jika --undefinesource)

# Di host2
virsh list --all
# Output: arch-vm running
virsh domstate arch-vm
virsh console arch-vm
```

**Penjelasan:**
- Cek VM di kedua host.

### 4.22. Skrip Migrasi Lengkap

```bash
#!/bin/bash
set -euo pipefail

VM="${1:-arch-vm}"
DEST="${2:-qemu+ssh://user@host2/system}"
LOG="/var/log/vm-migrate.log"

log() { echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }

log "Memulai migrasi $VM ke $DEST"

# Cek VM
if ! virsh dominfo "$VM" &>/dev/null; then
    log "VM $VM tidak ditemukan"
    exit 1
fi

# Cek status
STATE=$(virsh domstate "$VM")
log "Status VM: $STATE"

if [ "$STATE" != "running" ]; then
    log "VM tidak berjalan, gunakan --offline"
    virsh migrate --offline --persistent "$VM" "$DEST"
    exit 0
fi

# Migrasi live
virsh migrate \
    --live \
    --persistent \
    --verbose \
    --timeout 300 \
    --auto-converge \
    --compressed \
    --comp-methods zstd \
    --comp-threads 4 \
    "$VM" \
    "$DEST"

log "Migrasi selesai"

# Verifikasi
log "Verifikasi di tujuan..."
ssh "${DEST#qemu+ssh://}" "virsh list --all | grep $VM" || true
```

**Penjelasan:**
- Skrip migrasi dengan tuning.

### 4.23. Debug Migrasi

```bash
# Lihat log libvirt
tail -f /var/log/libvirt/libvirtd.log
journalctl -u virtqemud -f

# Lihat log QEMU
tail -f /var/log/libvirt/qemu/arch-vm.log

# Lihat status migrasi
virsh domjobinfo arch-vm

# Lihat statistik
virsh domstats arch-vm --migration
```

**Penjelasan:**
- `domjobinfo` — info job.
- `domstats --migration` — statistik migrasi.

### 4.24. Migrasi Gagal: Rollback

```bash
# Jika migrasi gagal, VM tetap di sumber
virsh domstate arch-vm
virsh domjobinfo arch-vm
```

**Penjelasan:**
- Cek status.
- Jika gagal, VM tetap di sumber.

### 4.25. Migrasi dengan Shared Storage NFS

**Di host1 dan host2:**

```bash
# Mount NFS
sudo mkdir -p /mnt/shared
sudo mount -t nfs host-nfs:/export/vm /mnt/shared

# Gunakan di XML
<disk type='file' device='disk'>
  <source file='/mnt/shared/arch-vm.qcow2'/>
  <target dev='vda' bus='virtio'/>
</disk>
```

**Penjelasan:**
- Shared storage memudahkan migrasi.

---

## 5. Diagram Arsitektur Live Migration

### 5.1. Alur Pre-copy Migration

```
Host1 (sumber)                    Host2 (tujuan)
+-------------------+             +-------------------+
|  VM arch-vm       |             |                   |
|  (running)        |             |                   |
+-------------------+             +-------------------+
         |                                 ^
         | 1. Salin memori                 |
         +---------------------------------+
         |                                 |
         | 2. Halaman berubah              |
         +---------------------------------+
         |                                 |
         | 3. Salin ulang                  |
         +---------------------------------+
         |                                 |
         | 4. Hentikan sejenak             |
         |    (downtime)                   |
         +---------------------------------+
         |                                 |
         | 5. Salin sisa                   |
         +---------------------------------+
         |                                 |
         | 6. Jalankan di tujuan           |
         |                                 v
+-------------------+             +-------------------+
|  VM (stopped)     |             |  VM (running)     |
+-------------------+             +-------------------+
```

### 5.2. Arsitektur Shared Storage

```
+-------------------+       +-------------------+
|  Host1            |       |  Host2            |
|  +-------------+  |       |  +-------------+  |
|  |  VM         |  |       |  |  VM         |  |
|  +-------------+  |       |  +-------------+  |
+-------------------+       +-------------------+
         |                           |
         |                           |
         +------------+--------------+
                      |
                      v
            +-------------------+
            |  Shared Storage   |
            |  (NFS/iSCSI/Ceph) |
            +-------------------+
```

### 5.3. Alur Post-copy Migration

```
Host1 (sumber)                    Host2 (tujuan)
+-------------------+             +-------------------+
|  VM arch-vm       |             |                   |
|  (running)        |             |                   |
+-------------------+             +-------------------+
         |                                 ^
         | 1. Transfer state minimal       |
         +---------------------------------+
         |                                 |
         | 2. Jalankan VM di tujuan        |
         |                                 v
+-------------------+             +-------------------+
|  VM (stopped)     |             |  VM (running)     |
+-------------------+             +-------------------+
         |                                 |
         | 3. Page fault, ambil memori     |
         |    dari sumber                  |
         +---------------------------------+
```

### 5.4. Diagram Transport

```
+-------------------+             +-------------------+
|  Host1            |             |  Host2            |
|  libvirt          |             |  libvirt          |
+-------------------+             +-------------------+
         |                                 ^
         | qemu+ssh://                     |
         | (SSH tunnel)                    |
         +---------------------------------+
         |                                 |
         | qemu+tcp://                     |
         | (TCP langsung)                  |
         +---------------------------------+
         |                                 |
         | qemu+unix://                    |
         | (Unix socket)                   |
         +---------------------------------+
```

### 5.5. Pohon Keputusan Migrasi

```
Apakah VM berjalan?
├── Ya → Apakah shared storage?
│   ├── Ya → Migrasi live (pre-copy)
│   └── Tidak → Block migration
└── Tidak → Migrasi offline

Apakah downtime kritis?
├── Ya → Post-copy / auto-converge
└── Tidak → Pre-copy biasa

Apakah jaringan aman?
├── Ya → TCP
└── Tidak → SSH tunnel
```

### 5.6. Alur Tuning Migrasi

```
Mulai migrasi
  |
  v
+-------------------+
|  Set bandwidth    |
+-------------------+
  |
  v
+-------------------+
|  Set max downtime |
+-------------------+
  |
  v
+-------------------+
|  Aktifkan         |
|  auto-converge    |
+-------------------+
  |
  v
+-------------------+
|  Aktifkan         |
|  compression      |
+-------------------+
  |
  v
+-------------------+
|  Multithread      |
+-------------------+
  |
  v
+-------------------+
|  Selesai          |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 8.1

Kurikulum asli menyebut:
```bash
virsh migrate --live arch-vm qemu+ssh://host2/system
```
> VM pindah tanpa downtime signifikan.

Kita akan menambahkan:
1. **Pre-copy vs Post-copy**.
2. **Shared storage vs Block migration**.
3. **Transport: SSH, TCP, Unix**.
4. **Tuning: bandwidth, compression, auto-converge, post-copy, multithread**.
5. **Downtime**.
6. **Kompatibilitas CPU**.
7. **Setup SSH antar host**.
8. **Konfigurasi libvirt & QEMU**.
9. **Migrasi dengan XML**.
10. **Migrasi storage incremental**.
11. **Hook migrasi**.
12. **Python libvirt API**.
13. **QEMU native migration**.
14. **Parameter migrasi**.
15. **Debug & troubleshooting**.
16. **Skrip migrasi lengkap**.
17. **Shared storage NFS**.
18. **Verifikasi**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 8.1.

---

## 7. Hubungan dengan Modul Lain

- **Fase 1–7**: semua materi menjadi prasyarat.
- **Modul 8.2 (VFIO)**: perangkat passthrough juga bisa dimigrasikan dengan batasan.
- **Modul 8.3 (SR-IOV/virtiofs)**: migrasi dengan perangkat ini perlu perhatian.
- **Modul 8.4 (NUMA)**: migrasi mempengaruhi topologi NUMA.
- **Modul 8.5 (Observability)**: memantau migrasi.
- **Fase 8 lanjutan**: cluster, HA, load balancing.

---

## 8. Referensi Lengkap

- libvirt Migration — https://libvirt.org/migration.html
- libvirt virsh migrate — https://libvirt.org/manpages/virsh.html#migrate
- QEMU Migration — https://www.qemu.org/docs/master/interop/migration.html
- QEMU Live Migration — https://www.qemu.org/docs/master/devel/migration.html
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- libvirt Python API — https://libvirt.org/python.html
- NFS — https://wiki.archlinux.org/title/NFS
- iSCSI — https://wiki.archlinux.org/title/ISCSI
- Ceph — https://docs.ceph.com/
- Post-copy Migration — https://www.qemu.org/docs/master/devel/migration.html#post-copy
- Auto-converge — https://libvirt.org/formatdomain.html#migration
- xbzrle — https://www.qemu.org/docs/master/devel/migration.html#xbzrle

---

## 9. Tips & Praktik Terbaik

1. **Gunakan shared storage** untuk migrasi cepat.
2. **Gunakan SSH** untuk keamanan.
3. **Set bandwidth** agar tidak membanjiri jaringan.
4. **Set max downtime** sesuai SLA.
5. **Aktifkan auto-converge** untuk VM besar.
6. **Aktifkan compression** untuk jaringan lambat.
7. **Gunakan multithread** untuk kompresi.
8. **Test migrasi** sebelum produksi.
9. **Monitor migrasi** dengan `domjobinfo`.
10. **Backup** sebelum migrasi.
11. **Pastikan CPU kompatibel**.
12. **Pastikan network** sama di kedua host.
13. **Gunakan `--persistent`** jika ingin VM tetap ada.
14. **Gunakan `--undefinesource`** jika ingin hapus di sumber.
15. **Dokumentasikan** setiap migrasi.
16. **Gunakan hook** untuk otomasi.
17. **Gunakan API** untuk skrip.
18. **Pantau log**.
19. **Siapkan rollback**.
20. **Latih tim**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Migrasi gagal | CPU tidak kompatibel. | Gunakan `host-model` atau `custom`. |
| Migrasi lambat | Jaringan lambat. | Aktifkan kompresi, batasi bandwidth. |
| Downtime tinggi | Memori besar. | Aktifkan auto-converge, post-copy. |
| VM tidak start di tujuan | XML tidak cocok. | Gunakan `--xml` atau samakan konfigurasi. |
| SSH gagal | Key tidak ada. | `ssh-copy-id`. |
| Network mati setelah migrasi | Bridge tidak ada. | Pastikan bridge di kedua host. |
| Disk tidak ditemukan | Shared storage tidak di-mount. | Mount NFS/iSCSI. |
| Migrasi hang | QEMU hang. | Cek log, restart. |
| Error "migration failed" | Banyak penyebab. | Cek log libvirt & QEMU. |
| Post-copy crash | Host sumber mati. | Gunakan pre-copy. |
| Block migration lambat | Disk besar. | Gunakan shared storage. |
| Port migrasi diblokir | Firewall. | Buka port 49152-49216. |
| Libvirt versi beda | Tidak kompatibel. | Samakan versi. |
| QEMU versi beda | Tidak kompatibel. | Samakan versi. |
| CPU flag beda | Host beda generasi. | Gunakan `check='none'` dengan hati-hati. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virsh migrate --live` berhasil.
- VM berjalan di host tujuan.
- Downtime < 1 detik.
- Network tetap berfungsi.
- Disk tetap bisa diakses.
- `virsh domjobinfo` menunjukkan sukses.
- Log tidak ada error.
- Hook migrasi berjalan.
- API Python berhasil.

**Troubleshooting:**
- Jika migrasi gagal: cek `virsh domjobinfo`, log libvirt, log QEMU.
- Jika lambat: cek bandwidth, aktifkan kompresi.
- Jika downtime tinggi: set max downtime, auto-converge.
- Jika CPU tidak kompatibel: gunakan `host-model`.
- Jika network mati: cek bridge, cek firewall.
- Jika disk tidak ditemukan: cek shared storage.
- Jika SSH gagal: cek key, cek permission.
- Untuk debug: `virsh migrate --verbose`, `tail -f /var/log/libvirt/libvirtd.log`.
- Untuk rollback: VM tetap di sumber jika gagal.

---

## 12. Latihan Mandiri

1. Siapkan dua host Arch dengan libvirt.
2. Setup SSH antar host.
3. Buat VM di host1.
4. Migrasi live ke host2.
5. Cek status di kedua host.
6. Migrasi dengan `--verbose`.
7. Migrasi dengan `--persistent`.
8. Migrasi dengan `--undefinesource`.
9. Migrasi dengan block migration.
10. Migrasi dengan tunnel SSH.
11. Migrasi dengan kompresi.
12. Migrasi dengan auto-converge.
13. Migrasi dengan post-copy.
14. Set max downtime.
15. Set bandwidth.
16. Lihat `domjobinfo`.
17. Buat hook migrasi.
18. Buat skrip migrasi.
19. Buat Python API migrasi.
20. Dokumentasikan.

---

## 13. Penutup Modul 8.1

Anda kini menguasai **Live Migration** — seni memindahkan VM yang sedang berjalan tanpa mengganggu layanan. Anda bisa:
- Memahami **pre-copy vs post-copy**.
- Menggunakan **shared storage vs block migration**.
- Memilih **transport SSH, TCP, Unix**.
- Melakukan **tuning**: bandwidth, compression, auto-converge, multithread.
- Menyiapkan **SSH antar host**.
- Mengkonfigurasi **libvirt & QEMU**.
- Menggunakan **hook migrasi**.
- Menggunakan **Python libvirt API**.
- Melakukan **debugging & troubleshooting**.
- Membuat **skrip migrasi lengkap**.

Ini adalah fondasi untuk **Modul 8.2 — VFIO/IOMMU Passthrough**, di mana kita akan membahas cara memberikan akses langsung ke perangkat fisik ke VM.

---

*Motivasi: Live migration adalah bukti bahwa virtualisasi bukan sekadar membuat VM, tetapi juga memindahkannya dengan mulus. Anda telah melangkah ke level expert. Teruslah belajar, karena di depan masih ada passthrough, SR-IOV, NUMA, dan observability. Dunia virtualisasi tidak pernah berhenti ber evolusi.*

---

# Modul 8.2 — VFIO/IOMMU Passthrough

## Mini-Daftar Isi Modul 8.2
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur VFIO/IOMMU Passthrough
6. Audit Kurikulum: Tambahan untuk Modul 8.2
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 8.2

---

> *Motivasi: Passthrough adalah jembatan antara dunia fisik dan virtual. Ia memberikan VM akses langsung ke perangkat keras — GPU, NIC, NVMe — seolah-olah perangkat itu miliknya sendiri. Ini adalah puncak isolasi dan performa, tetapi juga puncak risiko. Kuasai dengan hati-hati, dan Anda membuka pintu ke dunia yang tak terbatas.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**VFIO/IOMMU Passthrough** adalah teknik memberikan **akses langsung** kepada VM ke **perangkat fisik** (GPU, NIC, USB controller, NVMe, sound card, dll.) seolah-olah perangkat tersebut terpasang di dalam VM. Host **melepas** driver perangkat tersebut, dan **menyerahkannya** ke VM.

Secara teknis:
- **IOMMU** (Input/Output Memory Management Unit) adalah unit hardware yang menerjemahkan alamat memori untuk perangkat I/O. Ia memungkinkan **isolasi DMA** — perangkat hanya bisa mengakses memori yang diizinkan.
- **VFIO** (Virtual Function I/O) adalah framework kernel Linux yang memanfaatkan IOMMU untuk **mengamankan** akses perangkat dari userspace (QEMU).
- **vfio-pci** adalah driver kernel yang **mengikat** perangkat, menggantikan driver asli (mis. `nvidia`, `amdgpu`, `i915`, `nvme`, `xhci_hcd`).

Dalam konteks Arch Linux + libvirt/QEMU/KVM, VFIO passthrough memungkinkan:
- **GPU passthrough** untuk gaming, rendering, CUDA, ML.
- **NIC passthrough** untuk performa jaringan maksimal (10GbE, 40GbE).
- **NVMe passthrough** untuk storage berperforma tinggi.
- **USB controller passthrough** untuk perangkat USB khusus.
- **Sound card passthrough** untuk audio berkualitas.
- **PCIe device passthrough** secara umum.

**Peran dalam kurikulum:** Modul ini adalah **puncak isolasi dan performa** di Fase 8. Setelah Anda menguasai virtualisasi, storage, jaringan, keamanan, otomasi, dan migrasi, sekarang Anda belajar **memberikan akses hardware langsung**. Ini adalah keterampilan yang membedakan **virtualization engineer** dari **cloud engineer**. VFIO passthrough juga prasyarat untuk:
- **Modul 8.3 (SR-IOV & virtiofs)**: SR-IOV adalah variasi passthrough.
- **Modul 8.4 (NUMA, Pinning, Hugepages)**: passthrough butuh tuning.
- **Modul 8.5 (Observability)**: memantau perangkat passthrough.
- **Karier**: gaming VM, workstation virtualization, AI/ML, network function virtualization (NFV).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. IOMMU: Penjaga Gerbang DMA

**IOMMU** (Intel VT-d, AMD-Vi) adalah **unit hardware** yang menerjemahkan alamat **virtual** perangkat I/O ke alamat **fisik** memori. Tanpa IOMMU, perangkat bisa menulis ke **sembarang** alamat memori — ini berbahaya. Dengan IOMMU:
- Perangkat hanya bisa mengakses **memori yang diizinkan**.
- Perangkat di-**isolasi** dalam **IOMMU group**.
- DMA **remapping** memungkinkan passthrough aman.

**Filosofi:** *IOMMU adalah polisi lalu lintas DMA. Tanpa dia, chaos.*

### 2.2. IOMMU Group: Unit Isolasi

**IOMMU group** adalah **kumpulan perangkat** yang **tidak bisa dipisahkan** oleh IOMMU. Semua perangkat dalam satu grup **harus** di-passthrough **bersama-sama**, atau **tidak sama sekali**. Grup terbentuk berdasarkan **topologi PCIe** (PCIe root port, bridge, switch).

**Contoh:**
```
IOMMU Group 1:
  00:01.0 PCI bridge: Intel Corporation
  01:00.0 VGA compatible controller: NVIDIA Corporation
  01:00.1 Audio device: NVIDIA Corporation
```

Artinya, jika Anda ingin passthrough GPU NVIDIA, Anda **juga** harus passthrough audio device-nya (atau setidaknya memastikan host tidak memakainya).

**Filosofi:** *IOMMU group adalah paket. Tidak bisa dipisah.*

### 2.3. VFIO: Framework Kernel

**VFIO** adalah **framework kernel** yang:
- Menggunakan IOMMU untuk **isolasi**.
- Menyediakan **API** ke userspace (QEMU).
- Mengelola **DMA mapping**.
- Menangani **interrupt remapping**.
- Mendukung **PCI, platform, mediated devices**.

VFIO terdiri dari:
- **vfio** — modul inti.
- **vfio-pci** — driver untuk PCI.
- **vfio-iommu** — tipe IOMMU.
- **vfio-platform** — untuk platform device (ARM).
- **vfio-mdev** — mediated device (SR-IOV, NVIDIA vGPU).

**Filosofi:** *VFIO adalah jembatan antara kernel dan userspace untuk perangkat.*

### 2.4. vfio-pci: Driver Pengganti

**vfio-pci** adalah **driver kernel** yang **menggantikan** driver asli perangkat. Ketika perangkat diikat ke `vfio-pci`:
- Driver asli (mis. `nvidia`) **tidak** memuat.
- Host **tidak** bisa memakai perangkat.
- QEMU **bisa** mengakses perangkat via VFIO.
- VM **melihat** perangkat sebagai perangkat fisik.

**Filosofi:** *vfio-pci adalah kunci. Ia mengunci perangkat dari host, membukanya untuk VM.*

### 2.5. Binding: Mengikat Perangkat

**Binding** adalah proses **mengikat** perangkat ke driver `vfio-pci`. Ada beberapa cara:
1. **Kernel cmdline**: `vfio-pci.ids=10de:1b80,10de:10f0`
2. **Driver override**: `driver_override` + `bind`.
3. **Modprobe**: `options vfio-pci ids=...`
4. **Initramfs**: untuk perangkat yang dibutuhkan saat boot.
5. **libvirt**: `<hostdev>` dengan `managed='yes'`.

**Filosofi:** *Binding adalah ritual. Perangkat harus diserahkan dengan benar.*

### 2.6. DMA Remapping & Interrupt Remapping

- **DMA Remapping**: IOMMU menerjemahkan alamat DMA perangkat ke alamat fisik yang diizinkan.
- **Interrupt Remapping**: IOMMU menerjemahkan interrupt perangkat ke **MSI/MSI-X** yang tepat, mencegah interrupt injection.

Keduanya **wajib** untuk passthrough aman.

**Filosofi:** *DMA dan interrupt adalah dua tangan. IOMMU mengendalikan keduanya.*

### 2.7. ACS: Access Control Services

**ACS** (Access Control Services) adalah fitur PCIe yang memungkinkan **isolasi** perangkat di balik **PCIe switch**. Tanpa ACS, perangkat di balik switch yang sama **tidak bisa dipisahkan** — mereka berada di IOMMU group yang sama.

**Contoh:**
- **CPU root port**: biasanya punya ACS.
- **PCIe switch**: tergantung.
- **PLX switch**: sering tidak punya ACS.

**Filosofi:** *ACS adalah pemisah. Tanpa dia, perangkat saling terikat.*

### 2.8. Resizable BAR & Above 4G Decoding

- **Above 4G Decoding**: BIOS/UEFI harus mengaktifkan decoding memori di atas 4GB agar GPU dengan VRAM besar bisa di-passthrough.
- **Resizable BAR**: fitur PCIe yang memungkinkan BAR besar; berguna untuk GPU modern.

**Filosofi:** *GPU butuh ruang. Berikan dia ruang.*

### 2.9. GPU Passthrough: Tantangan Khusus

GPU passthrough adalah **kasus paling umum** dan **paling menantang**:
- **GPU utama** (yang dipakai host) **tidak bisa** di-passthrough tanpa **integrated GPU** (iGPU) sebagai host.
- **GPU kedua** bisa di-passthrough.
- **VBIOS** mungkin perlu di-*dump* dan di-*patch*.
- **Audio device** di GPU harus di-passthrough juga.
- **NVIDIA** punya **driver error** jika mendeteksi VM (solusi: `kvm=off`, `vendor_id`).
- **AMD** lebih ramah, tetapi butuh **vendor-reset** untuk reset GPU.
- **iGPU passthrough** (Intel GVT-g) berbeda — menggunakan **mediated device**.

**Filosofi:** *GPU adalah tamu istimewa. Ia butuh perlakuan khusus.*

### 2.10. Vendor Reset: Mengembalikan GPU ke Host

Ketika VM dimatikan, GPU **tidak selalu** bisa kembali ke host. GPU perlu **reset**. Jika tidak, host tidak bisa memakai GPU lagi sampai reboot. Solusi:
- **vendor-reset** (AMD).
- **Reset via ACPI**.
- **FLR** (Function Level Reset).
- **PCIe hotplug**.

**Filosofi:** *GPU adalah tamu yang sulit pulang. Kita harus membujuknya.*

### 2.11. MDev: Mediated Device

**MDev** (Mediated Device) adalah **perangkat virtual** yang dibuat dari **perangkat fisik** yang mendukung **SR-IOV** atau **GVT-g**. Contoh:
- **Intel GVT-g**: iGPU dibagi menjadi beberapa vGPU.
- **NVIDIA vGPU**: GPU dibagi menjadi vGPU.
- **MDev** memungkinkan **sharing** perangkat fisik.

**Filosofi:** *MDev adalah cara membagi satu perangkat menjadi banyak.*

### 2.12. Filosofi Keseluruhan

- **IOMMU adalah fondasi.**
- **IOMMU group adalah batas.**
- **VFIO adalah jembatan.**
- **vfio-pci adalah kunci.**
- **ACS adalah pemisah.**
- **VBIOS adalah nyawa.**
- **Vendor reset adalah pemulih.**
- **MDev adalah pembagi.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **IOMMU** | Input/Output Memory Management Unit. | Intel VT-d, AMD-Vi |
| **VT-d** | Intel Virtualization Technology for Directed I/O. | |
| **AMD-Vi** | AMD I/O Virtualization. | |
| **VFIO** | Virtual Function I/O. | |
| **vfio-pci** | Driver VFIO untuk PCI. | |
| **IOMMU Group** | Grup isolasi IOMMU. | |
| **ACS** | Access Control Services. | |
| **DMA Remapping** | Terjemahan alamat DMA. | |
| **Interrupt Remapping** | Terjemahan interrupt. | |
| **Binding** | Mengikat perangkat ke driver. | |
| **Driver Override** | Mengganti driver. | |
| **VBIOS** | Video BIOS. | |
| **ROM File** | File ROM untuk GPU. | |
| **Vendor Reset** | Reset GPU. | |
| **FLR** | Function Level Reset. | |
| **MDev** | Mediated Device. | |
| **GVT-g** | Intel Graphics Virtualization Technology. | |
| **vGPU** | Virtual GPU. | |
| **SR-IOV** | Single Root I/O Virtualization. | |
| **VF** | Virtual Function. | |
| **PF** | Physical Function. | |
| **Above 4G Decoding** | Decoding memori di atas 4GB. | |
| **Resizable BAR** | BAR yang bisa di-resize. | |
| **PCIe Root Port** | Port root PCIe. | |
| **PCIe Switch** | Switch PCIe. | |
| **MSI/MSI-X** | Message Signaled Interrupts. | |
| **IOMMU Group** | Grup perangkat. | |
| **vfio_iommu_type1** | Tipe IOMMU VFIO. | |
| **vfio_pci** | Modul VFIO PCI. | |
| **pci-stub** | Driver stub lama. | |
| **driver_override** | Override driver. | |
| **vendor-reset** | Modul reset GPU. | |
| **GPU Passthrough** | Passthrough GPU. | |
| **NIC Passthrough** | Passthrough NIC. | |
| **NVMe Passthrough** | Passthrough NVMe. | |
| **USB Passthrough** | Passthrough USB. | |
| **Looking Glass** | Sharing framebuffer. | |
| **Spice** | Protocol display. | |
| **QXL** | Driver video QEMU. | |
| **virtio-gpu** | GPU paravirtual. | |
| **VirGL** | Virtual OpenGL. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Cek Dukungan IOMMU

```bash
# Cek CPU
lscpu | grep -E 'vmx|svm'

# Cek IOMMU di kernel
dmesg | grep -i -e DMAR -e IOMMU

# Cek apakah IOMMU aktif
ls /sys/kernel/iommu_groups/
```

**Penjelasan kata demi kata:**
- `lscpu | grep vmx` — cek VT-x (Intel).
- `lscpu | grep svm` — cek AMD-V (AMD).
- `dmesg | grep DMAR` — cek DMAR (Intel IOMMU).
- `dmesg | grep IOMMU` — cek IOMMU.
- `ls /sys/kernel/iommu_groups/` — cek grup IOMMU.

**Expected Output:**
- `vmx` atau `svm` muncul.
- `DMAR` atau `AMD-Vi` muncul.
- `/sys/kernel/iommu_groups/` berisi grup (mis. `0`, `1`, `2`, ...).

### 4.2. Aktifkan IOMMU di Bootloader

**Untuk GRUB (Intel):**
```bash
sudo nano /etc/default/grub
```

**Edit:**
```ini
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet intel_iommu=on iommu=pt"
```

**Untuk GRUB (AMD):**
```ini
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet amd_iommu=on iommu=pt"
```

**Untuk systemd-boot:**
```bash
sudo nano /boot/loader/entries/arch.conf
```

**Edit:**
```
options root=... intel_iommu=on iommu=pt
```

**Regenerate GRUB:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Penjelasan kata demi kata:**
- `intel_iommu=on` — aktifkan IOMMU Intel.
- `amd_iommu=on` — aktifkan IOMMU AMD.
- `iommu=pt` — passthrough mode (performa).
- `iommu=on` — mode normal.
- `iommu=force` — paksa.

**Setelah reboot:**
```bash
dmesg | grep -i -e DMAR -e IOMMU
```

### 4.3. Cek IOMMU Group

```bash
#!/bin/bash
shopt -s nullglob
for g in /sys/kernel/iommu_groups/*; do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done
done
```

**Penjelasan kata demi kata:**
- `shopt -s nullglob` — glob kosong tidak error.
- `for g in /sys/kernel/iommu_groups/*` — iterasi grup.
- `${g##*/}` — ambil nama grup.
- `lspci -nns` — tampilkan PCI.

**Contoh Output:**
```
IOMMU Group 1:
        00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor PCIe Controller [8086:1901] (rev 07)
        01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP104 [GeForce GTX 1080] [10de:1b80] (rev a1)
        01:00.1 Audio device [0403]: NVIDIA Corporation GP104 High Definition Audio Controller [10de:10f0] (rev a1)
```

### 4.4. Cek Driver Perangkat

```bash
lspci -nnk -d 10de:1b80
```

**Penjelasan:**
- `lspci -nnk` — tampilkan driver.
- `-d 10de:1b80` — filter vendor:device.

**Output:**
```
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP104 [GeForce GTX 1080] [10de:1b80] (rev a1)
        Subsystem: ...
        Kernel driver in use: nvidia
        Kernel modules: nvidia
```

### 4.5. Binding vfio-pci via Kernel Cmdline

**Edit GRUB:**
```ini
GRUB_CMDLINE_LINUX_DEFAULT="... intel_iommu=on iommu=pt vfio-pci.ids=10de:1b80,10de:10f0"
```

**Penjelasan:**
- `vfio-pci.ids=10de:1b80,10de:10f0` — ID vendor:device yang diikat ke vfio-pci.

**Regenerate:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

**Verifikasi:**
```bash
lspci -nnk -d 10de:1b80
# Output: Kernel driver in use: vfio-pci
```

### 4.6. Binding vfio-pci via driver_override

```bash
# Cari PCI address
lspci -nn | grep -i nvidia
# Output: 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP104 [10de:1b80]

# Unbind dari driver asli
echo "0000:01:00.0" | sudo tee /sys/bus/pci/devices/0000:01:00.0/driver/unbind

# Set driver_override
echo "vfio-pci" | sudo tee /sys/bus/pci/devices/0000:01:00.0/driver_override

# Bind ke vfio-pci
echo "0000:01:00.0" | sudo tee /sys/bus/pci/drivers/vfio-pci/bind
```

**Penjelasan kata demi kata:**
- `echo "0000:01:00.0" > .../unbind` — lepas dari driver.
- `echo "vfio-pci" > .../driver_override` — set override.
- `echo "0000:01:00.0" > .../bind` — bind ke vfio-pci.

**Alternatif satu baris:**
```bash
sudo sh -c 'echo "0000:01:00.0" > /sys/bus/pci/devices/0000:01:00.0/driver/unbind && \
            echo "vfio-pci" > /sys/bus/pci/devices/0000:01:00.0/driver_override && \
            echo "0000:01:00.0" > /sys/bus/pci/drivers/vfio-pci/bind'
```

### 4.7. Binding via modprobe

**File `/etc/modprobe.d/vfio.conf`:**

```ini
options vfio-pci ids=10de:1b80,10de:10f0
softdep nvidia pre: vfio-pci
softdep nouveau pre: vfio-pci
softdep amdgpu pre: vfio-pci
```

**Penjelasan:**
- `options vfio-pci ids=...` — ID yang diikat.
- `softdep nvidia pre: vfio-pci` — vfio-pci dimuat sebelum nvidia.

**Regenerate initramfs:**
```bash
sudo mkinitcpio -P
```

**Edit `/etc/mkinitcpio.conf`:**
```ini
MODULES=(vfio_pci vfio vfio_iommu_type1 vfio_virqfd)
```

**Regenerate:**
```bash
sudo mkinitcpio -P
sudo reboot
```

### 4.8. Cek VFIO Aktif

```bash
# Cek modul
lsmod | grep vfio
# Output:
# vfio_pci               16384  0
# vfio_pci_core          86016  1 vfio_pci
# vfio_iommu_type1       45056  0
# vfio                   45056  2 vfio_pci_core,vfio_iommu_type1
# vfio_virqfd            16384  1 vfio_pci_core

# Cek driver
lspci -nnk -d 10de:1b80

# Cek iommu group
ls /sys/kernel/iommu_groups/
```

### 4.9. Menambahkan Hostdev ke XML

**Edit XML:**
```bash
virsh edit arch-vm
```

**Tambahkan:**
```xml
<devices>
  <!-- ... perangkat lain ... -->

  <hostdev mode='subsystem' type='pci' managed='yes'>
    <source>
      <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
    </source>
  </hostdev>

  <hostdev mode='subsystem' type='pci' managed='yes'>
    <source>
      <address domain='0x0000' bus='0x01' slot='0x00' function='0x1'/>
    </source>
  </hostdev>
</devices>
```

**Penjelasan kata demi kata:**
- `<hostdev mode='subsystem' type='pci' managed='yes'>` — hostdev PCI.
  - `managed='yes'` — libvirt yang bind/unbind.
- `<source>` — sumber perangkat.
  - `<address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>` — alamat PCI.

**Alternatif dengan `virsh attach-device`:**
```bash
virsh attach-device arch-vm hostdev.xml --live
```

**File `hostdev.xml`:**
```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

### 4.10. Konfigurasi CPU untuk GPU Passthrough (NVIDIA)

**Edit XML:**
```xml
<features>
  <acpi/>
  <apic/>
  <hyperv>
    <relaxed state='on'/>
    <vapic state='on'/>
    <spinlocks state='on' retries='8191'/>
    <vendor_id state='on' value='1234567890ab'/>
  </hyperv>
  <kvm>
    <hidden state='on'/>
  </kvm>
</features>
```

**Penjelasan:**
- `<vendor_id value='1234567890ab'/>` — spoof vendor ID (untuk NVIDIA).
- `<hidden state='on'/>` — sembunyikan KVM.

### 4.11. Konfigurasi VBIOS

**Dump VBIOS:**
```bash
# Cari ROM
ls /sys/bus/pci/devices/0000:01:00.0/rom

# Enable ROM
echo 1 | sudo tee /sys/bus/pci/devices/0000:01:00.0/rom

# Dump
sudo cat /sys/bus/pci/devices/0000:01:00.0/rom > /var/lib/libvirt/vbios/gtx1080.rom

# Disable ROM
echo 0 | sudo tee /sys/bus/pci/devices/0000:01:00.0/rom
```

**Penjelasan kata demi kata:**
- `/sys/bus/pci/devices/.../rom` — file ROM.
- `echo 1 > .../rom` — enable.
- `cat .../rom > file.rom` — dump.
- `echo 0 > .../rom` — disable.

**Tambahkan ke XML:**
```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
  </source>
  <rom bar='on' file='/var/lib/libvirt/vbios/gtx1080.rom'/>
</hostdev>
```

**Penjelasan:**
- `<rom bar='on' file='...'/>` — ROM file.

### 4.12. Konfigurasi Audio GPU

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x01' slot='0x00' function='0x1'/>
  </source>
</hostdev>
```

**Penjelasan:**
- Audio device GPU (function `0x1`).

### 4.13. Contoh XML Lengkap GPU Passthrough

```xml
<domain type='kvm'>
  <name>gaming-vm</name>
  <memory unit='MiB'>8192</memory>
  <vcpu placement='static'>4</vcpu>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>/usr/share/edk2/x64/OVMF_CODE.fd</loader>
    <nvram>/var/lib/libvirt/qemu/nvram/gaming-vm_VARS.fd</nvram>
  </os>

  <features>
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state='on'/>
      <vapic state='on'/>
      <spinlocks state='on' retries='8191'/>
      <vendor_id state='on' value='1234567890ab'/>
    </hyperv>
    <kvm>
      <hidden state='on'/>
    </kvm>
  </features>

  <cpu mode='host-passthrough' check='none' migratable='on'>
    <topology sockets='1' dies='1' cores='4' threads='1'/>
    <cache mode='passthrough'/>
    <feature policy='require' name='topoext'/>
  </cpu>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
      <source file='/var/lib/libvirt/images/gaming-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>

    <controller type='pci' index='0' model='pcie-root'/>
    <controller type='pci' index='1' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='1' port='0x10'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
    </controller>

    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>

    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </source>
      <rom bar='on' file='/var/lib/libvirt/vbios/gtx1080.rom'/>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
    </hostdev>

    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x01' slot='0x00' function='0x1'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x1'/>
    </hostdev>

    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>

    <graphics type='spice' autoport='yes' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>

    <video>
      <model type='virtio' heads='1' primary='yes'/>
    </video>

    <memballoon model='none'/>
  </devices>
</domain>
```

**Penjelasan:**
- `<loader type='pflash'>OVMF</loader>` — UEFI.
- `<hyperv>` — optimasi.
- `<kvm><hidden state='on'/></kvm>` — sembunyikan KVM.
- `<hostdev>` — GPU dan audio.
- `<graphics type='spice'>` — SPICE untuk display.

### 4.14. Vendor Reset AMD

**Install vendor-reset:**
```bash
# Dari AUR
yay -S vendor-reset-dkms-git
```

**Edit `/etc/modprobe.d/vfio.conf`:**
```ini
softdep amdgpu pre: vfio-pci
```

**Edit `/etc/mkinitcpio.conf`:**
```ini
MODULES=(vfio_pci vfio vfio_iommu_type1 vendor_reset)
```

**Regenerate:**
```bash
sudo mkinitcpio -P
sudo reboot
```

**Verifikasi:**
```bash
lsmod | grep vendor_reset
dmesg | grep -i vendor-reset
```

### 4.15. NVIDIA Driver Error

**Gejala:** `Error 43` di Windows.

**Solusi:**
- `<vendor_id value='1234567890ab'/>`
- `<hidden state='on'/>`
- Sembunyikan fitur KVM.

**Alternatif:**
```xml
<features>
  <kvm>
    <hidden state='on'/>
  </kvm>
  <hyperv>
    <vendor_id state='on' value='1234567890ab'/>
  </hyperv>
</features>
```

### 4.16. USB Controller Passthrough

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

**Penjelasan:**
- Passthrough USB controller (bukan USB device individual).
- Semua perangkat di controller tersebut masuk ke VM.

### 4.17. USB Device Passthrough

```xml
<hostdev mode='subsystem' type='usb' managed='yes'>
  <source>
    <vendor id='0x1234'/>
    <product id='0x5678'/>
  </source>
</hostdev>
```

**Penjelasan:**
- `type='usb'` — USB device.
- `<vendor>` dan `<product>` — ID USB.

**Cari ID:**
```bash
lsusb
# Output: Bus 001 Device 002: ID 1234:5678 ...
```

### 4.18. NVMe Passthrough

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

**Penjelasan:**
- Passthrough NVMe controller.
- VM melihat NVMe langsung.

### 4.19. Mediated Device (MDev) untuk Intel GVT-g

**Enable GVT-g:**
```bash
echo "options i915 enable_gvt=1" | sudo tee /etc/modprobe.d/i915.conf
sudo mkinitcpio -P
sudo reboot
```

**Cek:**
```bash
ls /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/
# Output: i915-GVTg_V5_4  i915-GVTg_V5_8

# Buat mdev
echo "8f1b2c3d-4e5f-6789-abcd-ef0123456789" | sudo tee /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create
```

**Tambahkan ke XML:**
```xml
<hostdev mode='subsystem' type='mdev' model='vfio-pci'>
  <source>
    <address uuid='8f1b2c3d-4e5f-6789-abcd-ef0123456789'/>
  </source>
</hostdev>
```

**Penjelasan:**
- `type='mdev'` — mediated device.
- `<address uuid='...'/>` — UUID mdev.

### 4.20. Looking Glass

**Install:**
```bash
yay -S looking-glass
```

**Konfigurasi XML:**
```xml
<shmem name='looking-glass'>
  <model type='ivshmem-plain'/>
  <size unit='M'>32</size>
</shmem>
```

**Penjelasan:**
- `<shmem>` — shared memory.
- `ivshmem-plain` — model.
- `32M` — ukuran.

**Konfigurasi host:**
```bash
# /etc/tmpfiles.d/10-looking-glass.conf
f /dev/shm/looking-glass 0660 user kvm -
```

**Konfigurasi client:**
```bash
looking-glass-client
```

### 4.21. Skrip Binding VFIO

```bash
#!/bin/bash
set -euo pipefail

# ID perangkat
GPU="10de:1b80"
AUDIO="10de:10f0"
PCI_GPU="0000:01:00.0"
PCI_AUDIO="0000:01:00.1"

# Unbind dari driver asli
unbind() {
    local pci="$1"
    if [ -e "/sys/bus/pci/devices/${pci}/driver" ]; then
        echo "Unbind ${pci}..."
        echo "$pci" | sudo tee "/sys/bus/pci/devices/${pci}/driver/unbind" > /dev/null
    fi
}

# Bind ke vfio-pci
bind_vfio() {
    local pci="$1"
    echo "Bind ${pci} ke vfio-pci..."
    echo "vfio-pci" | sudo tee "/sys/bus/pci/devices/${pci}/driver_override" > /dev/null
    echo "$pci" | sudo tee "/sys/bus/pci/drivers/vfio-pci/bind" > /dev/null
}

# Main
unbind "$PCI_GPU"
unbind "$PCI_AUDIO"
bind_vfio "$PCI_GPU"
bind_vfio "$PCI_AUDIO"

# Verifikasi
lspci -nnk -d "$GPU"
lspci -nnk -d "$AUDIO"
```

**Penjelasan:**
- Skrip unbind dan bind.
- Verifikasi dengan `lspci -nnk`.

### 4.22. Skrip Unbind VFIO

```bash
#!/bin/bash
set -euo pipefail

PCI_GPU="0000:01:00.0"
PCI_AUDIO="0000:01:00.1"

unbind_vfio() {
    local pci="$1"
    if [ -e "/sys/bus/pci/devices/${pci}/driver" ]; then
        local driver=$(basename $(readlink "/sys/bus/pci/devices/${pci}/driver"))
        if [ "$driver" = "vfio-pci" ]; then
            echo "Unbind ${pci} dari vfio-pci..."
            echo "$pci" | sudo tee "/sys/bus/pci/drivers/vfio-pci/unbind" > /dev/null
            echo "" | sudo tee "/sys/bus/pci/devices/${pci}/driver_override" > /dev/null
        fi
    fi
}

unbind_vfio "$PCI_GPU"
unbind_vfio "$PCI_AUDIO"

# Trigger rescan
echo 1 | sudo tee /sys/bus/pci/rescan > /dev/null

lspci -nnk -d 10de:1b80
```

**Penjelasan:**
- Unbind dari vfio-pci.
- Rescan PCI.

### 4.23. Verifikasi Passthrough

```bash
# 1. Cek VM
virsh list --all
virsh domstate gaming-vm

# 2. Cek hostdev
virsh dumpxml gaming-vm | grep -A 10 hostdev

# 3. Cek di guest
# Di guest:
lspci | grep -i nvidia
nvidia-smi

# 4. Cek driver host
lspci -nnk -d 10de:1b80
# Output: Kernel driver in use: vfio-pci

# 5. Cek IOMMU group
ls /sys/kernel/iommu_groups/
```

### 4.24. Debug Passthrough

```bash
# Log libvirt
tail -f /var/log/libvirt/qemu/gaming-vm.log

# Log QEMU
journalctl -u virtqemud -f

# dmesg
dmesg | grep -i -e vfio -e iommu

# Cek group
for g in /sys/kernel/iommu_groups/*; do
    echo "Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done
done
```

### 4.25. Konfigurasi Hugepages untuk Passthrough

**Edit `/etc/sysctl.d/10-hugepages.conf`:**
```ini
vm.nr_hugepages = 4096
```

**Terapkan:**
```bash
sudo sysctl -p /etc/sysctl.d/10-hugepages.conf
```

**Edit XML:**
```xml
<memoryBacking>
  <hugepages/>
</memoryBacking>
```

**Penjelasan:**
- `vm.nr_hugepages` — jumlah hugepages.
- `<hugepages/>` — gunakan hugepages.

### 4.26. Konfigurasi CPU Pinning untuk Passthrough

**Edit XML:**
```xml
<vcpu placement='static'>4</vcpu>
<cputune>
  <vcpupin vcpu='0' cpuset='2'/>
  <vcpupin vcpu='1' cpuset='3'/>
  <vcpupin vcpu='2' cpuset='4'/>
  <vcpupin vcpu='3' cpuset='5'/>
  <emulatorpin cpuset='0-1'/>
</cputune>
```

**Penjelasan:**
- Pin vCPU ke core fisik.
- Pin emulator ke core lain.

### 4.27. Isolasi CPU di Host

**Edit GRUB:**
```ini
GRUB_CMDLINE_LINUX_DEFAULT="... isolcpus=2,3,4,5 nohz_full=2,3,4,5 rcu_nocbs=2,3,4,5"
```

**Penjelasan:**
- `isolcpus` — isolasi CPU dari scheduler.
- `nohz_full` — no timer tick.
- `rcu_nocbs` — offload RCU.

### 4.28. Passthrough NIC

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

**Penjelasan:**
- Passthrough NIC fisik.
- VM melihat NIC langsung.

### 4.29. Passthrough Sound Card

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

**Penjelasan:**
- Passthrough sound card.

### 4.30. Migrasi dengan Passthrough

**Catatan:** Migrasi VM dengan passthrough **tidak bisa** dilakukan secara live, karena perangkat fisik **tidak bisa** dipindahkan. Migrasi harus **offline** (VM dimatikan), atau perangkat harus di-**hot-unplug** dulu.

**Filosofi:** *Perangkat fisik adalah jangkar. VM tidak bisa pindah selama jangkar terpasang.*

---

## 5. Diagram Arsitektur VFIO/IOMMU Passthrough

### 5.1. Arsitektur VFIO

```
+-------------------+
|  QEMU (userspace) |
+-------------------+
          |
          | /dev/vfio/*
          v
+-------------------+
|  VFIO (kernel)    |
+-------------------+
          |
          | IOMMU API
          v
+-------------------+
|  IOMMU (hardware) |
+-------------------+
          |
          | DMA Remapping
          v
+-------------------+
|  Perangkat PCI    |
|  (GPU, NIC, NVMe) |
+-------------------+
```

### 5.2. IOMMU Group

```
+-------------------+
|  IOMMU Group 1    |
|  +-------------+  |
|  | PCI Bridge  |  |
|  +-------------+  |
|  +-------------+  |
|  | GPU         |  |
|  +-------------+  |
|  +-------------+  |
|  | GPU Audio   |  |
|  +-------------+  |
+-------------------+
```

### 5.3. Alur Binding

```
Perangkat PCI
  |
  v
+-------------------+
|  Driver asli      |
|  (nvidia, amdgpu) |
+-------------------+
  |
  | unbind
  v
+-------------------+
|  Tanpa driver     |
+-------------------+
  |
  | driver_override
  v
+-------------------+
|  vfio-pci         |
+-------------------+
  |
  | bind
  v
+-------------------+
|  VFIO             |
+-------------------+
  |
  | QEMU
  v
+-------------------+
|  VM               |
+-------------------+
```

### 5.4. Alur GPU Passthrough

```
Host                           VM
+-------------------+          +-------------------+
|  iGPU (host)      |          |  GPU (passthrough)|
|  Display          |          |  NVIDIA/AMD       |
+-------------------+          +-------------------+
         |                              ^
         |                              |
         |  vfio-pci                    |
         +------------------------------+
```

### 5.5. Pohon Keputusan Passthrough

```
Apakah IOMMU aktif?
├── Ya → Apakah IOMMU group terisolasi?
│   ├── Ya → Bind vfio-pci
│   └── Tidak → ACS override / ganti slot
└── Tidak → Aktifkan IOMMU

Apakah perangkat punya driver?
├── Ya → Unbind
└── Tidak → Bind vfio-pci

Apakah GPU butuh VBIOS?
├── Ya → Dump VBIOS
└── Tidak → Langsung
```

### 5.6. Alur Vendor Reset

```
VM shutdown
  |
  v
+-------------------+
|  GPU perlu reset  |
+-------------------+
  |
  +-- FLR → sukses → host
  |
  +-- Gagal → vendor-reset
  |
  +-- Gagal → ACPI reset
  |
  +-- Gagal → reboot host
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 8.2

Kurikulum asli menyebut:
> - Aktifkan IOMMU.
> - Isolasi perangkat dengan `vfio-pci`.
> - Tambahkan `<hostdev>` di XML.
> Validasi Lulus: Guest mengenali perangkat fisik.

Kita akan menambahkan:
1. **IOMMU**: VT-d, AMD-Vi, `intel_iommu=on`, `amd_iommu=on`, `iommu=pt`.
2. **IOMMU Group**: cara cek, isolasi, ACS.
3. **VFIO**: framework, `vfio-pci`, `vfio_iommu_type1`.
4. **Binding**: kernel cmdline, driver_override, modprobe, initramfs.
5. **DMA & Interrupt Remapping**.
6. **ACS Override**.
7. **Above 4G Decoding & Resizable BAR**.
8. **GPU Passthrough**: VBIOS, vendor_id, hidden KVM, audio.
9. **Vendor Reset**: AMD, vendor-reset.
10. **NVIDIA Error 43**.
11. **MDev**: Intel GVT-g, NVIDIA vGPU.
12. **USB Passthrough**: controller, device.
13. **NVMe Passthrough**.
14. **NIC Passthrough**.
15. **Sound Card Passthrough**.
16. **Looking Glass**.
17. **Hugepages & CPU Pinning**.
18. **Isolasi CPU**.
19. **Migrasi dengan Passthrough**.
20. **Skrip binding/unbind**.
21. **Debug & troubleshooting**.
22. **Verifikasi**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 8.2.

---

## 7. Hubungan dengan Modul Lain

- **Fase 1–7**: semua materi menjadi prasyarat.
- **Modul 8.1 (Live Migration)**: passthrough membatasi migrasi.
- **Modul 8.3 (SR-IOV & virtiofs)**: SR-IOV adalah variasi passthrough.
- **Modul 8.4 (NUMA, Pinning, Hugepages)**: passthrough butuh tuning ini.
- **Modul 8.5 (Observability)**: memantau perangkat passthrough.
- **Fase 8 lanjutan**: NFV, AI/ML, gaming VM.

---

## 8. Referensi Lengkap

- Arch Wiki: PCI passthrough via OVMF — https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
- Arch Wiki: IOMMU — https://wiki.archlinux.org/title/IOMMU
- Arch Wiki: VFIO — https://wiki.archlinux.org/title/VFIO
- VFIO Documentation — https://docs.kernel.org/driver-api/vfio.html
- VFIO Mediated Devices — https://docs.kernel.org/driver-api/vfio-mediated-device.html
- libvirt Host Device — https://libvirt.org/formatdomain.html#host-device-assignment
- libvirt PCI Passthrough — https://libvirt.org/formatdomain.html#pci-passthrough
- QEMU VFIO — https://www.qemu.org/docs/master/system/devices/vfio.html
- QEMU GPU Passthrough — https://www.qemu.org/docs/master/system/devices/vfio.html
- vendor-reset — https://github.com/gnif/vendor-reset
- Looking Glass — https://looking-glass.io/
- Intel GVT-g — https://github.com/intel/gvt-linux/wiki
- NVIDIA vGPU — https://www.nvidia.com/en-us/design-visualization/virtual-gpu/
- Red Hat VFIO — https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/
- PCI Passthrough via OVMF — https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
- VFIO in 2019 — https://www.youtube.com/watch?v=XX3RCIQnGpE
- Alex Williamson VFIO — https://www.linux-kvm.org/page/How_to_assign_devices_with_VT-d_in_KVM

---

## 9. Tips & Praktik Terbaik

1. **Aktifkan IOMMU** di BIOS/UEFI.
2. **Gunakan `iommu=pt`** untuk performa.
3. **Cek IOMMU group** sebelum passthrough.
4. **Isolasi perangkat** dengan ACS.
5. **Bind vfio-pci** via kernel cmdline atau driver_override.
6. **Gunakan initramfs** untuk perangkat yang dibutuhkan saat boot.
7. **Dump VBIOS** jika perlu.
8. **Spoof vendor_id** untuk NVIDIA.
9. **Sembunyikan KVM** untuk NVIDIA.
10. **Gunakan vendor-reset** untuk AMD.
11. **Passthrough audio GPU** juga.
12. **Gunakan hugepages** untuk performa.
13. **Pin vCPU** ke core fisik.
14. **Isolasi CPU** di host.
15. **Gunakan Looking Glass** untuk display.
16. **Gunakan SPICE** untuk remote.
17. **Backup XML** sebelum edit.
18. **Test di VM terpisah**.
19. **Monitor log**.
20. **Dokumentasikan**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| IOMMU tidak aktif | BIOS/UEFI. | Aktifkan VT-d/AMD-Vi. |
| Group tidak terisolasi | ACS. | ACS override / ganti slot. |
| GPU tidak terdeteksi | VBIOS. | Dump VBIOS, tambahkan ROM. |
| NVIDIA Error 43 | Deteksi VM. | vendor_id + hidden KVM. |
| GPU tidak reset | Vendor reset. | vendor-reset. |
| Audio tidak jalan | Audio tidak di-passthrough. | Passthrough function 0x1. |
| VM tidak boot | OVMF. | Gunakan OVMF. |
| Host crash | IOMMU tidak aman. | Cek group. |
| Bind gagal | Driver asli. | Unbind dulu. |
| Modul tidak load | Initramfs. | Tambahkan ke MODULES. |
| VM lambat | Tidak ada hugepages. | Aktifkan hugepages. |
| CPU 100% | Tidak ada pinning. | Pin vCPU. |
| Migrasi gagal | Passthrough. | Migrasi offline. |
| Looking Glass gagal | Shared memory. | Cek `/dev/shm/looking-glass`. |
| SPICE lambat | Tidak ada QXL. | Gunakan virtio-gpu. |
| MDev gagal | Tidak didukung. | Cek CPU/GPU. |
| NVMe tidak terdeteksi | IOMMU group. | Cek group. |
| USB tidak jalan | Controller. | Passthrough controller. |
| Sound pecah | Latency. | Gunakan pinning. |
| VM tidak shutdown | GPU hang. | Destroy, reset. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- IOMMU aktif.
- IOMMU group terisolasi.
- Perangkat di-bind ke vfio-pci.
- VM melihat perangkat fisik.
- GPU berfungsi di VM.
- Audio berfungsi.
- VM bisa shutdown.
- Host tidak crash.
- Vendor reset berfungsi.
- Looking Glass berfungsi.

**Troubleshooting:**
- Jika IOMMU tidak aktif: cek BIOS, cek cmdline.
- Jika group tidak terisolasi: cek ACS, ganti slot.
- Jika GPU tidak terdeteksi: cek VBIOS, cek ROM.
- Jika NVIDIA Error 43: tambah vendor_id, hidden KVM.
- Jika GPU tidak reset: install vendor-reset.
- Jika audio tidak jalan: passthrough function 0x1.
- Jika VM tidak boot: cek OVMF, cek XML.
- Jika host crash: cek IOMMU group, cek isolasi.
- Jika bind gagal: unbind dulu, cek driver.
- Untuk debug: `dmesg | grep -i vfio`, `lspci -nnk`, `virsh dumpxml`.

---

## 12. Latihan Mandiri

1. Cek dukungan IOMMU.
2. Aktifkan IOMMU di bootloader.
3. Cek IOMMU group.
4. Cek driver perangkat.
5. Bind vfio-pci via kernel cmdline.
6. Bind vfio-pci via driver_override.
7. Bind vfio-pci via modprobe.
8. Tambahkan hostdev ke XML.
9. Dump VBIOS.
10. Tambahkan ROM ke XML.
11. Konfigurasi vendor_id.
12. Konfigurasi hidden KVM.
13. Passthrough audio GPU.
14. Install vendor-reset.
15. Passthrough USB controller.
16. Passthrough USB device.
17. Passthrough NVMe.
18. Passthrough NIC.
19. Konfigurasi Looking Glass.
20. Konfigurasi MDev.
21. Konfigurasi hugepages.
22. Konfigurasi CPU pinning.
23. Isolasi CPU.
24. Buat skrip binding.
25. Buat skrip unbind.
26. Debug passthrough.
27. Dokumentasikan.

---

## 13. Penutup Modul 8.2

Anda kini menguasai **VFIO/IOMMU Passthrough** — seni memberikan akses hardware langsung ke VM. Anda bisa:
- Memahami **IOMMU, VFIO, vfio-pci**.
- Mengaktifkan **IOMMU** di bootloader.
- Menganalisis **IOMMU group**.
- Melakukan **binding** via berbagai metode.
- Melakukan **GPU passthrough** dengan VBIOS, vendor_id, hidden KVM.
- Menangani **NVIDIA Error 43**.
- Menggunakan **vendor-reset** untuk AMD.
- Melakukan **USB, NVMe, NIC, sound card passthrough**.
- Menggunakan **MDev** (Intel GVT-g, NVIDIA vGPU).
- Menggunakan **Looking Glass**.
- Melakukan **tuning**: hugepages, CPU pinning, isolasi CPU.
- Melakukan **debugging & troubleshooting**.
- Membuat **skrip binding/unbind**.

Ini adalah fondasi untuk **Modul 8.3 — SR-IOV & virtiofs**, di mana kita akan membahas sharing perangkat fisik dan filesystem berperforma tinggi.

---

*Motivasi: Passthrough adalah puncak isolasi. Anda telah memberikan VM akses ke dunia fisik, dengan aman dan terkendali. Ini bukan sekadar teknik, tetapi seni menyeimbangkan performa, keamanan, dan kompleksitas. Teruslah belajar, karena di depan masih ada SR-IOV, virtiofs, NUMA, dan observability. Dunia virtualisasi tidak pernah berhenti ber evolusi.*

---

# Modul 8.3 — SR-IOV & virtiofs

## Mini-Daftar Isi Modul 8.3
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur SR-IOV & virtiofs
6. Audit Kurikulum: Tambahan untuk Modul 8.3
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 8.3

---

> *Motivasi: SR-IOV adalah seni membagi satu perangkat fisik menjadi banyak perangkat virtual tanpa kehilangan performa. Virtiofs adalah seni berbagi filesystem antara host dan guest dengan kecepatan mendekati native. Keduanya adalah jembatan antara isolasi dan efisiensi. Kuasai keduanya, dan Anda membuka pintu ke infrastruktur virtual yang benar-benar profesional.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Modul 8.3** membahas dua teknologi expert yang saling melengkapi:

1. **SR-IOV (Single Root I/O Virtualization)** — teknik membagi **satu perangkat PCIe fisik** (Physical Function, PF) menjadi **beberapa Virtual Function (VF)**. Setiap VF dapat diberikan ke VM secara langsung, memberikan **performa mendekati native** dengan **overhead rendah**. Umum digunakan untuk **NIC**, **GPU**, **NVMe**, dan **FPGA**.

2. **virtiofs** — filesystem sharing berbasis **virtio** yang memungkinkan host berbagi direktori ke guest dengan **performa tinggi**, **latensi rendah**, dan **fitur lengkap** (xattr, ACL, mmap). Ini adalah pengganti modern untuk **9p** dan **NFS** di lingkungan virtualisasi.

Dalam konteks Arch Linux + libvirt/QEMU/KVM, SR-IOV dan virtiofs memungkinkan:
- **NIC SR-IOV**: VM mendapat VF NIC langsung, throughput tinggi, CPU rendah.
- **GPU SR-IOV**: beberapa VM berbagi satu GPU (jika GPU mendukung).
- **NVMe SR-IOV**: storage berperforma tinggi per VM.
- **virtiofs**: berbagi direktori host ke guest tanpa network, dengan performa tinggi.
- **DevOps**: CI/CD, build farm, container VM.
- **AI/ML**: dataset sharing cepat ke VM.
- **Gaming/Workstation**: akses filesystem host untuk asset.

**Peran dalam kurikulum:** Modul ini adalah **puncak efisiensi dan sharing** di Fase 8. Setelah Anda menguasai passthrough penuh (8.2), sekarang Anda belajar **membagi perangkat** dan **berbagi filesystem**. Ini adalah keterampilan yang membedakan **virtualization engineer** dari **cloud architect**. SR-IOV dan virtiofs juga prasyarat untuk:
- **Modul 8.4 (NUMA, Pinning, Hugepages)**: SR-IOV dan virtiofs butuh tuning.
- **Modul 8.5 (Observability)**: memantau VF dan virtiofs.
- **Karier**: NFV, OpenStack, Kubernetes, AI/ML, gaming VM.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. SR-IOV: Membagi Satu Menjadi Banyak

**SR-IOV** adalah standar PCIe yang memungkinkan **satu perangkat fisik** (PF) untuk **mempresentasikan dirinya** sebagai **beberapa perangkat virtual** (VF). Setiap VF:
- Memiliki **PCIe address sendiri**.
- Memiliki **resource sendiri** (queue, interrupt, MAC, VLAN).
- Dapat di-**assign** ke VM secara langsung.
- Beroperasi **independen** dari VF lain.

**Filosofi:** *Satu perangkat fisik, banyak perangkat virtual. Seperti Hydra.*

### 2.2. PF vs VF

- **PF (Physical Function)**: perangkat fisik penuh. Digunakan host untuk **mengelola** VF (membuat, menghapus, mengkonfigurasi).
- **VF (Virtual Function)**: perangkat virtual ringan. Digunakan VM untuk **I/O**.

PF dan VF **berbagi** resource fisik, tetapi **terisolasi** secara logis.

**Filosofi:** *PF adalah manajer. VF adalah pekerja.*

### 2.3. SR-IOV vs Passthrough Penuh

| Aspek | Passthrough Penuh | SR-IOV |
|---|---|---|
| Perangkat | 1 VM per perangkat | Banyak VM per perangkat |
| Performa | Native | Mendekati native |
| Overhead | Rendah | Sangat rendah |
| Sharing | Tidak | Ya |
| Kompleksitas | Sedang | Tinggi |
| Dukungan | Luas | Tergantung perangkat |

**Filosofi:** *Passthrough adalah eksklusif. SR-IOV adalah berbagi.*

### 2.4. Switchdev & Representors

Pada NIC SR-IOV modern, ada dua mode:
- **Legacy mode**: VF diperlakukan sebagai perangkat PCI terpisah. Konfigurasi via PF driver.
- **Switchdev mode**: VF dan PF direpresentasikan sebagai **netdev** (representor). Memungkinkan **offload** ke hardware, **tc flower**, **OVS offload**, dan **VLAN** yang lebih fleksibel.

**Filosofi:** *Switchdev adalah mode modern. Ia membawa SR-IOV ke era software-defined.*

### 2.5. virtiofs: Filesystem Berbagi Berkecepatan Tinggi

**virtiofs** adalah filesystem **FUSE** yang berjalan di **virtio**. Ia terdiri dari:
- **virtiofsd** — daemon di host yang melayani filesystem.
- **vhost-user-fs** — perangkat virtio di QEMU.
- **Shared memory** — untuk komunikasi cepat.
- **DAX window** — untuk mmap langsung.

Guest melihat **filesystem virtiofs** dan bisa **mount** seperti filesystem biasa.

**Filosofi:** *virtiofs adalah jembatan filesystem. Cepat, aman, dan terintegrasi.*

### 2.6. virtiofs vs 9p vs NFS

| Aspek | 9p | NFS | virtiofs |
|---|---|---|---|
| Performa | Rendah | Sedang | Tinggi |
| Latensi | Tinggi | Sedang | Rendah |
| xattr | Terbatas | Ya | Ya |
| mmap | Terbatas | Ya | Ya |
| DAX | Tidak | Tidak | Ya |
| Keamanan | Sedang | Tinggi | Tinggi |
| Kompleksitas | Rendah | Sedang | Sedang |

**Filosofi:** *9p adalah masa lalu. NFS adalah jaringan. virtiofs adalah masa depan.*

### 2.7. Cache Mode & DAX

virtiofs mendukung beberapa mode cache:
- **none**: tidak ada cache. Konsisten, lambat.
- **auto**: cache otomatis. Seimbang.
- **always**: cache selalu. Cepat, tapi bisa tidak konsisten.
- **DAX**: Direct Access. Guest bisa **mmap** file host langsung. Sangat cepat.

**Filosofi:** *Cache adalah pedang bermata dua. Cepat, tapi bisa menusuk konsistensi.*

### 2.8. Keamanan virtiofs

virtiofsd berjalan sebagai **proses userspace**. Ia bisa dijalankan dengan:
- **sandbox**: namespace, seccomp.
- **xattr**: kontrol extended attributes.
- **accessmode**: `passthrough`, `mapped-xattr`, `mapped-file`, `squash`, `none`.
- **user/group**: mapping.

**Filosofi:** *virtiofsd adalah penjaga pintu. Ia harus kuat.*

### 2.9. Filosofi Keseluruhan

- **SR-IOV adalah pembagi.**
- **VF adalah pekerja.**
- **Switchdev adalah modern.**
- **virtiofs adalah jembatan.**
- **DAX adalah kecepatan.**
- **Cache adalah keseimbangan.**
- **Keamanan adalah prioritas.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **SR-IOV** | Single Root I/O Virtualization. | |
| **PF** | Physical Function. | |
| **VF** | Virtual Function. | |
| **VFIO** | Virtual Function I/O. | |
| **vfio-pci** | Driver VFIO PCI. | |
| **Switchdev** | Mode switch modern. | |
| **Representor** | Netdev representasi VF. | |
| **ip link** | Konfigurasi network. | |
| **sriov_numvfs** | Jumlah VF. | |
| **sriov_totalvfs** | Total VF. | |
| **spoofchk** | Cek spoof MAC. | |
| **trust** | Trust mode. | |
| **VLAN** | Virtual LAN. | |
| **MAC** | Media Access Control. | |
| **tc flower** | Traffic control flower. | |
| **OVS** | Open vSwitch. | |
| **virtiofs** | Virtio filesystem. | |
| **virtiofsd** | Daemon virtiofs. | |
| **vhost-user-fs** | Perangkat virtiofs. | |
| **FUSE** | Filesystem in Userspace. | |
| **DAX** | Direct Access. | |
| **mmap** | Memory map. | |
| **xattr** | Extended attributes. | |
| **ACL** | Access Control List. | |
| **cache mode** | Mode cache. | |
| **shared memory** | Memori bersama. | |
| **memfd** | Memory file descriptor. | |
| **sandbox** | Isolasi proses. | |
| **seccomp** | Secure Computing. | |
| **accessmode** | Mode akses. | |
| **squash** | Mapping user. | |
| **mapped-xattr** | Mapping xattr. | |
| **mapped-file** | Mapping file. | |
| **passthrough** | Langsung. | |
| **queue** | Jumlah queue. | |
| **vhost-user** | Vhost userspace. | |
| **virtio-fs** | Nama lain virtiofs. | |
| **9p** | Plan 9 filesystem. | |
| **NFS** | Network File System. | |
| **CIFS** | Common Internet File System. | |
| **SMB** | Server Message Block. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Cek Dukungan SR-IOV

```bash
# Cek PCI device
lspci -nn | grep -i ethernet

# Cek kapabilitas SR-IOV
lspci -vvv -s 03:00.0 | grep -i "Single Root I/O Virtualization"
# Output: Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
```

**Penjelasan kata demi kata:**
- `lspci -nn` — tampilkan PCI.
- `grep -i ethernet` — filter ethernet.
- `lspci -vvv` — verbose.
- `grep -i "Single Root"` — cek SR-IOV.

### 4.2. Cek Total VF

```bash
cat /sys/class/net/enp3s0f0/device/sriov_totalvfs
# Output: 64
```

**Penjelasan:**
- `sriov_totalvfs` — total VF yang didukung.
- `enp3s0f0` — nama interface PF.

### 4.3. Membuat VF

```bash
# Buat 4 VF
echo 4 | sudo tee /sys/class/net/enp3s0f0/device/sriov_numvfs

# Cek
cat /sys/class/net/enp3s0f0/device/sriov_numvfs
# Output: 4

# Cek VF
lspci -nn | grep -i "Virtual Function"
```

**Penjelasan:**
- `echo 4 > .../sriov_numvfs` — buat 4 VF.
- `sriov_numvfs` — jumlah VF aktif.

**Alternatif dengan `ip link`:**
```bash
sudo ip link set enp3s0f0 vf 0 mac 00:11:22:33:44:55
sudo ip link set enp3s0f0 vf 0 vlan 100
sudo ip link set enp3s0f0 vf 0 spoofchk on
sudo ip link set enp3s0f0 vf 0 trust on
```

**Penjelasan:**
- `vf 0` — VF index.
- `mac` — set MAC.
- `vlan` — set VLAN.
- `spoofchk` — anti-spoof.
- `trust` — trust mode.

### 4.4. Melihat VF

```bash
# Lihat VF
ip link show enp3s0f0
# Output: vf 0 MAC 00:11:22:33:44:55, vlan 100, spoof checking on, link-state auto, trust on

# Lihat VF PCI
lspci -nn | grep -i "Virtual Function"
# Output: 03:10.0 Ethernet controller [0200]: Intel Corporation X710 Virtual Function [8086:154c]
```

### 4.5. Binding VF ke vfio-pci

```bash
# Cari PCI VF
lspci -nn | grep -i "Virtual Function"
# Output: 03:10.0 Ethernet controller [0200]: Intel Corporation X710 Virtual Function [8086:154c]

# Unbind dari driver asli
echo "0000:03:10.0" | sudo tee /sys/bus/pci/devices/0000:03:10.0/driver/unbind

# Set driver_override
echo "vfio-pci" | sudo tee /sys/bus/pci/devices/0000:03:10.0/driver_override

# Bind ke vfio-pci
echo "0000:03:10.0" | sudo tee /sys/bus/pci/drivers/vfio-pci/bind
```

**Penjelasan:**
- `unbind` — lepas dari driver.
- `driver_override` — set vfio-pci.
- `bind` — bind.

**Alternatif kernel cmdline:**
```ini
vfio-pci.ids=8086:154c
```

### 4.6. Menambahkan VF ke XML

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x03' slot='0x10' function='0x0'/>
  </source>
</hostdev>
```

**Penjelasan:**
- `<hostdev>` — host device.
- `type='pci'` — PCI.
- `<address>` — alamat VF.

**Alternatif dengan `virsh attach-device`:**
```bash
virsh attach-device arch-vm vf.xml --live
```

### 4.7. Switchdev Mode

```bash
# Aktifkan switchdev
sudo devlink dev eswitch set pci/0000:03:00.0 mode switchdev

# Cek
sudo devlink dev eswitch show pci/0000:03:00.0

# Lihat representor
ip link show
# Output: enp3s0f0npf0vf0, enp3s0f0npf0vf1, ...
```

**Penjelasan:**
- `devlink dev eswitch set` — set mode.
- `mode switchdev` — switchdev.
- Representor muncul.

### 4.8. Konfigurasi VF dengan `ip link`

```bash
# Set MAC
sudo ip link set dev enp3s0f0 vf 0 mac 00:11:22:33:44:55

# Set VLAN
sudo ip link set dev enp3s0f0 vf 0 vlan 100

# Set spoofchk
sudo ip link set dev enp3s0f0 vf 0 spoofchk on

# Set trust
sudo ip link set dev enp3s0f0 vf 0 trust on

# Set rate
sudo ip link set dev enp3s0f0 vf 0 rate 1000

# Set link-state
sudo ip link set dev enp3s0f0 vf 0 state enable
```

**Penjelasan:**
- `rate` — batas bandwidth (Mbps).
- `state` — enable/disable.

### 4.9. Melihat Statistik VF

```bash
ip -s link show enp3s0f0
# Output: vf 0 ... RX: ... TX: ...
```

**Penjelasan:**
- `-s` — statistik.

### 4.10. Install virtiofsd

```bash
sudo pacman -S qemu-virtiofsd
```

**Penjelasan:**
- Paket `qemu-virtiofsd` di Arch.

**Alternatif:**
```bash
sudo pacman -S virtiofsd
```

### 4.11. Konfigurasi virtiofs di XML

```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs' queue='1024'/>
  <source dir='/host/share'/>
  <target dir='share'/>
  <binary path='/usr/lib/virtiofsd' xattr='on'>
    <cache mode='auto'/>
    <sandbox mode='namespace'/>
  </binary>
</filesystem>
```

**Penjelasan kata demi kata:**
- `<filesystem type='mount'>` — filesystem mount.
- `accessmode='passthrough'` — mode akses.
- `<driver type='virtiofs' queue='1024'/>` — driver virtiofs, queue 1024.
- `<source dir='/host/share'/>` — direktori host.
- `<target dir='share'/>` — tag guest.
- `<binary path='/usr/lib/virtiofsd' xattr='on'>` — binary virtiofsd, xattr.
- `<cache mode='auto'/>` — cache auto.
- `<sandbox mode='namespace'/>` — sandbox namespace.

**Alternatif tanpa binary:**
```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs'/>
  <source dir='/host/share'/>
  <target dir='share'/>
</filesystem>
```

### 4.12. Mount di Guest

```bash
# Di guest
sudo mkdir -p /mnt/share
sudo mount -t virtiofs share /mnt/share
```

**Penjelasan:**
- `mount -t virtiofs` — tipe virtiofs.
- `share` — tag target.
- `/mnt/share` — mount point.

**Otomatis di `/etc/fstab`:**
```ini
share /mnt/share virtiofs defaults 0 0
```

### 4.13. Konfigurasi DAX

```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs' queue='1024'/>
  <source dir='/host/share'/>
  <target dir='share'/>
  <binary path='/usr/lib/virtiofsd' xattr='on'>
    <cache mode='always'/>
    <sandbox mode='namespace'/>
  </binary>
  <space hard_limit='1048576' soft_limit='524288' unit='KiB'/>
  <memoryBacking>
    <source type='memfd'/>
    <access mode='shared'/>
  </memoryBacking>
</filesystem>
```

**Penjelasan:**
- `<memoryBacking><source type='memfd'/><access mode='shared'/></memoryBacking>` — shared memory.
- DAX window.

**Di guest:**
```bash
mount -t virtiofs -o dax share /mnt/share
```

### 4.14. Konfigurasi Cache Mode

```xml
<binary path='/usr/lib/virtiofsd' xattr='on'>
  <cache mode='always'/>
</binary>
```

**Mode:**
- `none` — tidak ada cache.
- `auto` — otomatis.
- `always` — selalu.
- `never` — tidak pernah.

### 4.15. Konfigurasi Sandbox

```xml
<binary path='/usr/lib/virtiofsd' xattr='on'>
  <sandbox mode='namespace'/>
</binary>
```

**Mode:**
- `namespace` — namespace.
- `chroot` — chroot.
- `none` — tidak ada.

### 4.16. Konfigurasi accessmode

```xml
<filesystem type='mount' accessmode='passthrough'>
```

**Mode:**
- `passthrough` — langsung.
- `mapped-xattr` — mapping xattr.
- `mapped-file` — mapping file.
- `squash` — squash user.
- `none` — tidak ada.

### 4.17. Contoh XML Lengkap SR-IOV + virtiofs

```xml
<domain type='kvm'>
  <name>sriov-vm</name>
  <memory unit='MiB'>4096</memory>
  <vcpu>4</vcpu>

  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>/usr/share/edk2/x64/OVMF_CODE.fd</loader>
    <nvram>/var/lib/libvirt/qemu/nvram/sriov-vm_VARS.fd</nvram>
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
      <source file='/var/lib/libvirt/images/sriov-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>

    <controller type='pci' index='0' model='pcie-root'/>

    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>

    <!-- SR-IOV VF -->
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x03' slot='0x10' function='0x0'/>
      </source>
    </hostdev>

    <!-- virtiofs -->
    <filesystem type='mount' accessmode='passthrough'>
      <driver type='virtiofs' queue='1024'/>
      <source dir='/host/share'/>
      <target dir='share'/>
      <binary path='/usr/lib/virtiofsd' xattr='on'>
        <cache mode='auto'/>
        <sandbox mode='namespace'/>
      </binary>
    </filesystem>

    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>

    <graphics type='none'/>
    <video><model type='none'/></video>
    <memballoon model='none'/>
  </devices>
</domain>
```

### 4.18. Skrip Membuat VF

```bash
#!/bin/bash
set -euo pipefail

PF="enp3s0f0"
NUM_VFS=4

log() { echo "[$(date '+%F %T')] $*"; }

log "Membuat $NUM_VFS VF pada $PF..."

# Cek total
TOTAL=$(cat /sys/class/net/$PF/device/sriov_totalvfs)
log "Total VF yang didukung: $TOTAL"

if [ "$NUM_VFS" -gt "$TOTAL" ]; then
    log "Error: $NUM_VFS > $TOTAL"
    exit 1
fi

# Hapus VF lama
echo 0 | sudo tee /sys/class/net/$PF/device/sriov_numvfs > /dev/null
sleep 1

# Buat VF
echo "$NUM_VFS" | sudo tee /sys/class/net/$PF/device/sriov_numvfs > /dev/null
sleep 1

# Verifikasi
log "VF aktif: $(cat /sys/class/net/$PF/device/sriov_numvfs)"
lspci -nn | grep -i "Virtual Function"
```

**Penjelasan:**
- `sriov_totalvfs` — total VF.
- `sriov_numvfs` — set jumlah.

### 4.19. Skrip Binding VF ke vfio-pci

```bash
#!/bin/bash
set -euo pipefail

VF_PCI="0000:03:10.0"

log() { echo "[$(date '+%F %T')] $*"; }

log "Binding $VF_PCI ke vfio-pci..."

# Unbind
if [ -e "/sys/bus/pci/devices/${VF_PCI}/driver" ]; then
    echo "$VF_PCI" | sudo tee "/sys/bus/pci/devices/${VF_PCI}/driver/unbind" > /dev/null
fi

# Override
echo "vfio-pci" | sudo tee "/sys/bus/pci/devices/${VF_PCI}/driver_override" > /dev/null

# Bind
echo "$VF_PCI" | sudo tee "/sys/bus/pci/drivers/vfio-pci/bind" > /dev/null

# Verifikasi
lspci -nnk -s "$VF_PCI"
```

### 4.20. Skrip Setup virtiofs

```bash
#!/bin/bash
set -euo pipefail

SHARE_DIR="/host/share"
VM="sriov-vm"

log() { echo "[$(date '+%F %T')] $*"; }

# Buat direktori
sudo mkdir -p "$SHARE_DIR"
sudo chmod 755 "$SHARE_DIR"

# Cek virtiofsd
if ! command -v virtiofsd &>/dev/null; then
    log "virtiofsd tidak ditemukan, install qemu-virtiofsd"
    exit 1
fi

log "virtiofs siap untuk $VM"
log "Direktori: $SHARE_DIR"
```

### 4.21. Verifikasi SR-IOV

```bash
# 1. Cek PF
ip link show enp3s0f0

# 2. Cek VF
lspci -nn | grep -i "Virtual Function"

# 3. Cek driver VF
lspci -nnk -s 03:10.0
# Output: Kernel driver in use: vfio-pci

# 4. Cek VM
virsh dumpxml sriov-vm | grep -A 5 hostdev

# 5. Cek di guest
# Di guest:
lspci | grep -i ethernet
ip link show
```

### 4.22. Verifikasi virtiofs

```bash
# 1. Cek mount di guest
mount | grep virtiofs
# Output: share on /mnt/share type virtiofs (rw,relatime)

# 2. Cek file
ls -la /mnt/share

# 3. Cek performa
dd if=/dev/zero of=/mnt/share/test bs=1M count=1000
rm /mnt/share/test

# 4. Cek xattr
setfattr -n user.test -v value /mnt/share/test
getfattr -d /mnt/share/test
```

### 4.23. Debug SR-IOV

```bash
# Log kernel
dmesg | grep -i -e sriov -e vfio

# Log libvirt
tail -f /var/log/libvirt/qemu/sriov-vm.log

# Cek VF
ip link show enp3s0f0

# Cek devlink
sudo devlink dev eswitch show pci/0000:03:00.0
```

### 4.24. Debug virtiofs

```bash
# Log virtiofsd
journalctl -t virtiofsd -f
ps aux | grep virtiofsd

# Log QEMU
tail -f /var/log/libvirt/qemu/sriov-vm.log

# Cek shared memory
ls -la /dev/shm/

# Cek mount
mount | grep virtiofs
```

### 4.25. Tuning SR-IOV

```bash
# Set rate
sudo ip link set dev enp3s0f0 vf 0 rate 10000

# Set trust
sudo ip link set dev enp3s0f0 vf 0 trust on

# Set spoofchk
sudo ip link set dev enp3s0f0 vf 0 spoofchk off

# Set VLAN
sudo ip link set dev enp3s0f0 vf 0 vlan 100

# Set MAC
sudo ip link set dev enp3s0f0 vf 0 mac 00:11:22:33:44:55
```

### 4.26. Tuning virtiofs

```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs' queue='1024'/>
  <source dir='/host/share'/>
  <target dir='share'/>
  <binary path='/usr/lib/virtiofsd' xattr='on'>
    <cache mode='always'/>
    <sandbox mode='namespace'/>
  </binary>
  <space hard_limit='1048576' soft_limit='524288' unit='KiB'/>
</filesystem>
```

**Penjelasan:**
- `queue='1024'` — queue depth.
- `cache mode='always'` — cache.
- `space hard_limit` — batas.

---

## 5. Diagram Arsitektur SR-IOV & virtiofs

### 5.1. Arsitektur SR-IOV

```
+-------------------+
|  Physical NIC     |
|  (PF)             |
+-------------------+
          |
          +-- VF 0 --> VM 1
          +-- VF 1 --> VM 2
          +-- VF 2 --> VM 3
          +-- VF 3 --> VM 4
```

### 5.2. SR-IOV Switchdev

```
+-------------------+
|  PF               |
+-------------------+
          |
          +-- Representor VF0
          +-- Representor VF1
          +-- Representor VF2
          +-- Representor VF3
          |
          v
+-------------------+
|  OVS / tc flower  |
+-------------------+
```

### 5.3. virtiofs

```
+-------------------+
|  Host             |
|  /host/share      |
+-------------------+
          |
          | virtiofsd
          v
+-------------------+
|  QEMU             |
|  vhost-user-fs    |
+-------------------+
          |
          | virtio
          v
+-------------------+
|  Guest            |
|  /mnt/share       |
+-------------------+
```

### 5.4. DAX

```
+-------------------+
|  Host             |
|  File             |
+-------------------+
          |
          | DAX window
          v
+-------------------+
|  Guest            |
|  mmap             |
+-------------------+
```

### 5.5. Pohon Keputusan SR-IOV

```
Apakah perangkat mendukung SR-IOV?
├── Ya → Apakah total VF > 0?
│   ├── Ya → Buat VF
│   └── Tidak → Tidak bisa
└── Tidak → Gunakan passthrough penuh

Apakah butuh sharing?
├── Ya → SR-IOV
└── Tidak → Passthrough penuh
```

### 5.6. Pohon Keputusan virtiofs

```
Apakah butuh sharing filesystem?
├── Ya → Apakah performa tinggi?
│   ├── Ya → virtiofs
│   └── Tidak → 9p / NFS
└── Tidak → Tidak perlu
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 8.3

Kurikulum asli menyebut:
> **Lab L8.3 — virtiofs**
> ```xml
> <filesystem type='mount' accessmode='passthrough'>
>   <source dir='/host/share'/>
>   <target dir='share'/>
> </filesystem>
> ```
> Validasi Lulus: Guest bisa mount share.

Kita akan menambahkan:
1. **SR-IOV**: PF, VF, total VF, num VF.
2. **Cek dukungan SR-IOV**.
3. **Membuat VF** via `sriov_numvfs`.
4. **Konfigurasi VF**: MAC, VLAN, spoofchk, trust, rate.
5. **Binding VF ke vfio-pci**.
6. **Switchdev & representors**.
7. **`devlink`**.
8. **tc flower & OVS offload**.
9. **virtiofs**: virtiofsd, vhost-user-fs.
10. **XML virtiofs**: driver, source, target, binary, cache, sandbox.
11. **Mount di guest**.
12. **DAX & shared memory**.
13. **Cache mode**: none, auto, always.
14. **Sandbox mode**: namespace, chroot.
15. **accessmode**: passthrough, mapped-xattr, mapped-file, squash.
16. **Tuning**: queue, space.
17. **Keamanan**: xattr, seccomp.
18. **Debug & troubleshooting**.
19. **Verifikasi**.
20. **Skrip setup**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 8.3.

---

## 7. Hubungan dengan Modul Lain

- **Modul 8.1 (Live Migration)**: SR-IOV VF tidak bisa live migrate.
- **Modul 8.2 (VFIO)**: SR-IOV VF menggunakan VFIO.
- **Modul 8.4 (NUMA, Pinning)**: SR-IOV dan virtiofs butuh tuning.
- **Modul 8.5 (Observability)**: memantau VF dan virtiofs.
- **Fase 8 lanjutan**: NFV, OVS offload, AI/ML.

---

## 8. Referensi Lengkap

- Arch Wiki: SR-IOV — https://wiki.archlinux.org/title/SR-IOV
- Arch Wiki: PCI passthrough via OVMF — https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
- Arch Wiki: virtiofs — https://wiki.archlinux.org/title/Virtiofs
- libvirt Filesystem — https://libvirt.org/formatdomain.html#filesystems
- libvirt Host Device — https://libvirt.org/formatdomain.html#host-device-assignment
- QEMU virtiofs — https://www.qemu.org/docs/master/interop/virtiofs.html
- virtiofsd — https://gitlab.com/virtio-fs/virtiofsd
- Linux SR-IOV — https://docs.kernel.org/PCI/pci-iov-howto.html
- Linux Switchdev — https://docs.kernel.org/networking/switchdev.html
- devlink — https://docs.kernel.org/networking/devlink/index.html
- ip link — https://man7.org/linux/man-pages/man8/ip-link.8.html
- tc flower — https://man7.org/linux/man-pages/man8/tc-flower.8.html
- Open vSwitch — https://docs.openvswitch.org/
- Intel SR-IOV — https://www.intel.com/content/www/us/en/developer/articles/technical/configure-sr-iov-network-virtual-functions-in-linux-kvm.html
- Mellanox SR-IOV — https://docs.nvidia.com/networking/
- virtiofs DAX — https://virtio-fs.gitlab.io/
- FUSE — https://www.kernel.org/doc/html/latest/filesystems/fuse.html

---

## 9. Tips & Praktik Terbaik

1. **Cek dukungan SR-IOV** sebelum membeli hardware.
2. **Gunakan switchdev** untuk NIC modern.
3. **Set spoofchk** untuk keamanan.
4. **Set trust** dengan hati-hati.
5. **Bind VF ke vfio-pci** untuk passthrough.
6. **Gunakan representor** untuk OVS offload.
7. **Gunakan virtiofs** daripada 9p.
8. **Gunakan DAX** untuk performa.
9. **Gunakan cache mode** sesuai kebutuhan.
10. **Gunakan sandbox** untuk keamanan.
11. **Set xattr** untuk fitur lengkap.
12. **Gunakan queue depth** yang cukup.
13. **Monitor performa**.
14. **Backup XML**.
15. **Test di VM terpisah**.
16. **Dokumentasikan**.
17. **Gunakan skrip** untuk otomasi.
18. **Gunakan systemd** untuk persistensi.
19. **Gunakan hook** untuk setup.
20. **Jangan lupa cleanup**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| VF tidak muncul | SR-IOV tidak didukung. | Cek `lspci -vvv`. |
| VF gagal dibuat | Total VF 0. | Cek BIOS, driver. |
| VF tidak bisa bind | Driver asli. | Unbind dulu. |
| VF tidak terdeteksi di VM | vfio-pci. | Cek driver. |
| Spoofing MAC | spoofchk off. | Set spoofchk on. |
| VLAN tidak jalan | VLAN salah. | Set VLAN. |
| Trust tidak jalan | trust off. | Set trust on. |
| Switchdev gagal | Driver tidak support. | Update driver. |
| Representor tidak muncul | Switchdev off. | Set switchdev. |
| virtiofs tidak mount | virtiofsd tidak ada. | Install. |
| virtiofs lambat | Cache none. | Set cache always. |
| DAX tidak jalan | Shared memory. | Set memfd. |
| xattr tidak jalan | xattr off. | Set xattr on. |
| Sandbox gagal | Namespace. | Set sandbox. |
| Accessmode salah | Mode tidak cocok. | Cek mode. |
| Guest tidak lihat share | Target salah. | Cek target. |
| Mount gagal | Tipe salah. | `-t virtiofs`. |
| Performa rendah | Queue kecil. | Perbesar queue. |
| VM hang | VF hang. | Reset VF. |
| Host crash | IOMMU. | Cek group. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- SR-IOV didukung.
- VF dibuat.
- VF di-bind ke vfio-pci.
- VM melihat VF.
- VF berfungsi.
- Switchdev berfungsi.
- virtiofsd berjalan.
- Guest mount share.
- DAX berfungsi.
- xattr berfungsi.
- Performa baik.

**Troubleshooting:**
- Jika SR-IOV tidak didukung: cek `lspci -vvv`, cek BIOS.
- Jika VF gagal: cek `sriov_totalvfs`, cek driver.
- Jika VF tidak bind: cek driver, unbind.
- Jika VM tidak lihat VF: cek XML, cek driver.
- Jika spoofing: set spoofchk on.
- Jika VLAN gagal: cek VLAN.
- Jika switchdev gagal: cek driver, update.
- Jika virtiofs tidak mount: cek virtiofsd, cek XML.
- Jika lambat: cek cache, queue.
- Jika DAX gagal: cek shared memory.
- Jika xattr gagal: cek xattr.
- Untuk debug: `dmesg`, `journalctl`, `virsh dumpxml`, `ip link`.

---

## 12. Latihan Mandiri

1. Cek dukungan SR-IOV.
2. Cek total VF.
3. Buat VF.
4. Konfigurasi MAC VF.
5. Konfigurasi VLAN VF.
6. Set spoofchk.
7. Set trust.
8. Set rate.
9. Bind VF ke vfio-pci.
10. Passthrough VF ke VM.
11. Aktifkan switchdev.
12. Lihat representor.
13. Konfigurasi OVS offload.
14. Install virtiofsd.
15. Konfigurasi virtiofs di XML.
16. Mount di guest.
17. Konfigurasi DAX.
18. Konfigurasi cache mode.
19. Konfigurasi sandbox.
20. Konfigurasi xattr.
21. Tuning queue.
22. Debug SR-IOV.
23. Debug virtiofs.
24. Buat skrip setup.
25. Dokumentasikan.

---

## 13. Penutup Modul 8.3

Anda kini menguasai **SR-IOV & virtiofs** — dua teknologi expert yang membuka pintu ke efisiensi dan sharing. Anda bisa:
- Memahami **SR-IOV, PF, VF**.
- Membuat dan mengkonfigurasi **VF**.
- Melakukan **binding VF ke vfio-pci**.
- Menggunakan **switchdev & representors**.
- Melakukan **OVS offload**.
- Memahami **virtiofs, virtiofsd, vhost-user-fs**.
- Mengkonfigurasi **virtiofs di XML**.
- Melakukan **mount di guest**.
- Menggunakan **DAX, cache mode, sandbox, xattr**.
- Melakukan **tuning**.
- Melakukan **debugging & troubleshooting**.
- Membuat **skrip setup**.

Ini adalah fondasi untuk **Modul 8.4 — NUMA, CPU Pinning, Hugepages, KSM**, di mana kita akan membahas tuning performa tingkat lanjut.

---

*Motivasi: SR-IOV dan virtiofs adalah bukti bahwa virtualisasi bukan tentang mengorbankan performa, tetapi tentang menemukan keseimbangan antara isolasi dan efisiensi. Anda telah melangkah ke level expert. Teruslah belajar, karena di depan masih ada NUMA, hugepages, KSM, dan observability. Dunia virtualisasi tidak pernah berhenti ber evolusi.*

---

# Modul 8.4 — NUMA, CPU Pinning, Hugepages, KSM

## Mini-Daftar Isi Modul 8.4
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur NUMA, Pinning, Hugepages & KSM
6. Audit Kurikulum: Tambahan untuk Modul 8.4
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 8.4

---

> *Motivasi: Performa bukan kebetulan. Ia adalah hasil dari pemahaman mendalam tentang topologi hardware, penjadwalan CPU, manajemen memori, dan deduplikasi. NUMA, CPU pinning, hugepages, dan KSM adalah empat pilar tuning virtualisasi. Kuasai keempatnya, dan VM Anda tidak hanya berjalan — ia terbang.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Modul 8.4** membahas empat teknologi tuning performa tingkat lanjut:

1. **NUMA (Non-Uniform Memory Access)** — arsitektur memori multiprosesor di mana **waktu akses memori bergantung pada lokasi memori relatif terhadap CPU**. Setiap CPU memiliki **memori lokal** yang cepat diakses, dan **memori remote** yang lambat diakses. Memahami NUMA memungkinkan **penempatan VM** yang optimal.

2. **CPU Pinning (CPU Affinity)** — teknik **mengikat vCPU** ke **core fisik** tertentu. Ini mengurangi **context switch**, meningkatkan **cache locality**, dan **mengisolasi** VM dari gangguan. Sangat penting untuk **real-time**, **gaming**, dan **latency-sensitive** workload.

3. **Hugepages** — halaman memori berukuran **besar** (2 MiB atau 1 GiB) sebagai pengganti halaman standar **4 KiB**. Hugepages mengurangi **TLB miss**, meningkatkan **performa memori**, dan mengurangi **overhead page table**. Wajib untuk **DPDK**, **database**, **AI/ML**, dan **VM besar**.

4. **KSM (Kernel Same-page Merging)** — fitur kernel yang **mendeteksi halaman memori identik** antar proses/VM dan **menggabungkannya** menjadi satu halaman **copy-on-write**. Ini **menghemat memori** tetapi **mengorbankan CPU** dan bisa menjadi **risiko keamanan** (side-channel).

Dalam konteks Arch Linux + libvirt/QEMU/KVM, keempat teknologi ini memungkinkan:
- **Performa maksimal** untuk VM gaming, workstation, database.
- **Efisiensi memori** untuk banyak VM.
- **Latensi rendah** untuk real-time.
- **Skalabilitas** untuk server besar.
- **Keamanan** (dengan mematikan KSM).

**Peran dalam kurikulum:** Modul ini adalah **puncak tuning performa** di Fase 8. Setelah Anda menguasai passthrough (8.2) dan sharing (8.3), sekarang Anda belajar **mengoptimalkan** semuanya. Ini adalah keterampilan yang membedakan **virtualization engineer** dari **performance engineer**. Keempat teknologi ini juga prasyarat untuk:
- **Modul 8.5 (Observability)**: memantau performa.
- **Fase 8 lanjutan**: HPC, AI/ML, NFV, real-time.
- **Karier**: performance engineer, SRE, cloud architect.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. NUMA: Memori Tidak Seragam

**NUMA** adalah arsitektur di mana **memori** dibagi menjadi **node** yang terikat ke **socket CPU**. Setiap CPU memiliki:
- **Local memory**: memori di node yang sama. Akses **cepat** (~100 ns).
- **Remote memory**: memori di node lain. Akses **lambat** (~200 ns), melalui **interconnect** (UPI, Infinity Fabric).

**Contoh:**
```
+-------------------+     +-------------------+
|  Socket 0         |     |  Socket 1         |
|  +-------------+  |     |  +-------------+  |
|  |  CPU 0-15   |  |     |  |  CPU 16-31  |  |
|  +-------------+  |     |  +-------------+  |
|  +-------------+  |     |  +-------------+  |
|  |  Mem Node 0 |  |     |  |  Mem Node 1 |  |
|  +-------------+  |     |  +-------------+  |
+-------------------+     +-------------------+
          |                         |
          +---- Interconnect -------+
```

Jika CPU 0 mengakses memori Node 1, ia harus melalui **interconnect** — lebih lambat.

**Filosofi:** *Memori tidak seragam. Dekatkan CPU dengan memorinya.*

### 2.2. NUMA Node & Distance

Setiap **NUMA node** memiliki:
- **CPUs**: daftar CPU.
- **Memory**: memori.
- **Distance**: jarak ke node lain (10 = lokal, 20 = remote, 30+ = jauh).

**Contoh:**
```bash
numactl --hardware
# node 0 cpus: 0 1 2 3 4 5 6 7
# node 0 size: 32768 MB
# node 1 cpus: 8 9 10 11 12 13 14 15
# node 1 size: 32768 MB
# node distances:
# node   0   1
#   0:  10  21
#   1:  21  10
```

**Filosofi:** *Distance adalah peta. Ia menunjukkan jalan tercepat.*

### 2.3. NUMA Policy

Ada beberapa **kebijakan NUMA**:
- **strict**: hanya alokasi dari node yang ditentukan. Gagal jika tidak cukup.
- **preferred**: coba node yang ditentukan, fallback ke node lain.
- **interleave**: alokasi bergilir antar node.
- **bind**: ikat ke node tertentu.
- **default**: kebijakan kernel.

**Filosofi:** *Kebijakan adalah aturan. Pilih sesuai kebutuhan.*

### 2.4. CPU Pinning: Mengikat vCPU

**CPU pinning** adalah **mengikat vCPU** ke **core fisik** tertentu. Manfaat:
- **Cache locality**: vCPU selalu di core yang sama, cache tetap hangat.
- **Mengurangi context switch**: tidak ada migrasi vCPU antar core.
- **Isolasi**: VM tidak terganggu proses lain.
- **Determinisme**: latensi lebih stabil.

**Filosofi:** *CPU adalah rumah. vCPU harus punya rumah tetap.*

### 2.5. Emulator Pinning

**Emulator pinning** adalah mengikat **thread emulator QEMU** (I/O, VNC, dll.) ke **core terpisah** dari vCPU. Ini mencegah emulator mengganggu vCPU.

**Filosofi:** *Emulator adalah pelayan. Ia harus tahu tempatnya.*

### 2.6. CPU Isolation

**CPU isolation** adalah **mengisolasi core** dari **scheduler host**. Core yang diisolasi **tidak** digunakan host untuk proses biasa. Hanya VM yang bisa memakainya. Kernel cmdline:
- `isolcpus=2,3,4,5` — isolasi core 2-5.
- `nohz_full=2,3,4,5` — no timer tick.
- `rcu_nocbs=2,3,4,5` — offload RCU.
- `irqaffinity=0,1` — IRQ di core 0-1.

**Filosofi:** *Isolasi adalah tembok. Core yang diisolasi adalah milik VM.*

### 2.7. Hugepages: Halaman Besar

**Hugepages** adalah halaman memori berukuran:
- **2 MiB** (default x86_64).
- **1 GiB** (dengan `pdpe1gb`).

Manfaat:
- **TLB miss berkurang**: satu entry TLB mencakup 2 MiB/1 GiB, bukan 4 KiB.
- **Page table lebih kecil**: overhead berkurang.
- **Performa memori meningkat**: 10-30% untuk workload memori-intensif.
- **Latensi lebih stabil**: penting untuk real-time.

**Filosofi:** *Halaman besar adalah jalan tol. Lebih sedikit lampu merah.*

### 2.8. Transparent Hugepages (THP)

**THP** adalah **hugepages otomatis** yang dikelola kernel. Tidak perlu konfigurasi manual. Tetapi:
- **Kurang deterministik**.
- **Fragmentasi**.
- **Latency spike** saat `khugepaged` bekerja.

Untuk VM, **hugepages statis** lebih baik.

**Filosofi:** *THP adalah otomatis. Statis adalah deterministik.*

### 2.9. KSM: Deduplikasi Memori

**KSM** (Kernel Same-page Merging) adalah fitur kernel yang:
- **Memindai** halaman memori.
- **Mendeteksi** halaman identik.
- **Menggabungkan** menjadi satu halaman **copy-on-write**.
- **Menghemat memori** (bisa 30-50% untuk VM homogen).

Tetapi:
- **CPU overhead**: pemindaian memakan CPU.
- **Risiko keamanan**: side-channel (Meltdown, Spectre).
- **Latency**: copy-on-write bisa lambat.

**Filosofi:** *KSM adalah penghemat memori. Tetapi ia punya harga.*

### 2.10. KSM vs Hugepages

| Aspek | KSM | Hugepages |
|---|---|---|
| Tujuan | Hemat memori | Performa |
| CPU | Overhead | Rendah |
| Keamanan | Risiko | Aman |
| Determinisme | Rendah | Tinggi |
| Kompleksitas | Rendah | Sedang |
| Gunakan | Banyak VM homogen | VM performa |

**Filosofi:** *KSM dan hugepages adalah dua sisi. Pilih sesuai tujuan.*

### 2.11. Filosofi Keseluruhan

- **NUMA adalah peta.**
- **Pinning adalah rumah.**
- **Isolation adalah tembok.**
- **Hugepages adalah jalan tol.**
- **KSM adalah penghemat.**
- **Tuning adalah seni.**
- **Ukur, jangan tebak.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **NUMA** | Non-Uniform Memory Access. | |
| **NUMA Node** | Node memori. | |
| **Distance** | Jarak antar node. | |
| **Local Memory** | Memori lokal. | |
| **Remote Memory** | Memori remote. | |
| **Interconnect** | Jembatan antar socket. | UPI, Infinity Fabric |
| **UPI** | Ultra Path Interconnect (Intel). | |
| **Infinity Fabric** | Interconnect AMD. | |
| **numactl** | Tool NUMA. | |
| **numastat** | Statistik NUMA. | |
| **numad** | Daemon NUMA. | |
| **NUMA Policy** | Kebijakan NUMA. | strict, preferred, interleave |
| **CPU Pinning** | Ikat vCPU. | |
| **vcpupin** | Pin vCPU. | |
| **emulatorpin** | Pin emulator. | |
| **iothreadpin** | Pin iothread. | |
| **CPU Affinity** | Afinitas CPU. | |
| **taskset** | Tool afinitas. | |
| **isolcpus** | Isolasi CPU. | |
| **nohz_full** | No timer tick. | |
| **rcu_nocbs** | Offload RCU. | |
| **irqaffinity** | Afinitas IRQ. | |
| **Hugepages** | Halaman besar. | |
| **THP** | Transparent Hugepages. | |
| **khugepaged** | Daemon THP. | |
| **TLB** | Translation Lookaside Buffer. | |
| **Page Table** | Tabel halaman. | |
| **2M Hugepage** | Hugepage 2 MiB. | |
| **1G Hugepage** | Hugepage 1 GiB. | |
| **hugetlbfs** | Filesystem hugepages. | |
| **vm.nr_hugepages** | Jumlah hugepages. | |
| **KSM** | Kernel Same-page Merging. | |
| **ksmd** | Daemon KSM. | |
| **ksmtuned** | Tuning KSM. | |
| **COW** | Copy-on-Write. | |
| **MADV_MERGEABLE** | Flag KSM. | |
| **MADV_UNMERGEABLE** | Flag KSM. | |
| **Side-channel** | Saluran samping. | |
| **Spectre** | Kerentanan CPU. | |
| **Meltdown** | Kerentanan CPU. | |
| **Cache Locality** | Lokalitas cache. | |
| **Context Switch** | Pergantian konteks. | |
| **Latency** | Waktu tunda. | |
| **Throughput** | Throughput. | |
| **Determinisme** | Keteraturan. | |
| **Real-time** | Waktu nyata. | |
| **DPDK** | Data Plane Development Kit. | |
| **NFV** | Network Function Virtualization. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Cek Topologi NUMA

```bash
# Cek NUMA
numactl --hardware
# Output:
# available: 2 nodes (0-1)
# node 0 cpus: 0 1 2 3 4 5 6 7
# node 0 size: 32768 MB
# node 0 free: 30000 MB
# node 1 cpus: 8 9 10 11 12 13 14 15
# node 1 size: 32768 MB
# node 1 free: 30000 MB
# node distances:
# node   0   1
#   0:  10  21
#   1:  21  10
```

**Penjelasan kata demi kata:**
- `numactl --hardware` — tampilkan topologi NUMA.
- `available` — jumlah node.
- `node 0 cpus` — CPU di node 0.
- `node 0 size` — memori node 0.
- `node distances` — jarak.

**Alternatif:**
```bash
lscpu | grep -i numa
# Output: NUMA node(s): 2
#         NUMA node0 CPU(s): 0-7
#         NUMA node1 CPU(s): 8-15

ls /sys/devices/system/node/
# Output: node0 node1

cat /sys/devices/system/node/node0/cpulist
# Output: 0-7
```

### 4.2. Cek Statistik NUMA

```bash
numastat
# Output:
#                            node0           node1
# numa_hit                12345678         87654321
# numa_miss                  12345            54321
# numa_foreign               54321            12345
# interleave_hit             10000            10000
# local_node              12000000         85000000
# other_node                 345678          2654321
```

**Penjelasan:**
- `numa_hit` — alokasi lokal.
- `numa_miss` — alokasi remote.
- `numa_foreign` — alokasi untuk node lain.
- `local_node` — akses lokal.
- `other_node` — akses remote.

### 4.3. Menggunakan numactl

```bash
# Jalankan di node 0
numactl --cpunodebind=0 --membind=0 qemu-system-x86_64 ...

# Interleave
numactl --interleave=all qemu-system-x86_64 ...

# Preferred
numactl --preferred=0 qemu-system-x86_64 ...
```

**Penjelasan:**
- `--cpunodebind=0` — ikat CPU ke node 0.
- `--membind=0` — ikat memori ke node 0.
- `--interleave=all` — interleave semua node.
- `--preferred=0` — prefer node 0.

### 4.4. Konfigurasi NUMA di XML

```xml
<domain type='kvm'>
  <name>numa-vm</name>
  <memory unit='MiB'>4096</memory>
  <vcpu placement='static'>4</vcpu>

  <cpu>
    <topology sockets='2' dies='1' cores='2' threads='1'/>
    <numa>
      <cell id='0' cpus='0-1' memory='2048' unit='MiB'/>
      <cell id='1' cpus='2-3' memory='2048' unit='MiB'/>
    </numa>
  </cpu>

  <numatune>
    <memory mode='strict' nodeset='0-1'/>
    <memnode cellid='0' mode='strict' nodeset='0'/>
    <memnode cellid='1' mode='strict' nodeset='1'/>
  </numatune>

  <devices>
    <!-- ... -->
  </devices>
</domain>
```

**Penjelasan kata demi kata:**
- `<numa>` — topologi NUMA guest.
  - `<cell id='0' cpus='0-1' memory='2048'/>` — cell 0.
  - `<cell id='1' cpus='2-3' memory='2048'/>` — cell 1.
- `<numatune>` — tuning NUMA.
  - `<memory mode='strict' nodeset='0-1'/>` — memori strict di node 0-1.
  - `<memnode cellid='0' mode='strict' nodeset='0'/>` — cell 0 di node 0.
  - `<memnode cellid='1' mode='strict' nodeset='1'/>` — cell 1 di node 1.

### 4.5. CPU Pinning di XML

```xml
<vcpu placement='static'>4</vcpu>
<cputune>
  <vcpupin vcpu='0' cpuset='2'/>
  <vcpupin vcpu='1' cpuset='3'/>
  <vcpupin vcpu='2' cpuset='4'/>
  <vcpupin vcpu='3' cpuset='5'/>
  <emulatorpin cpuset='0-1'/>
  <iothreadpin iothread='1' cpuset='6-7'/>
</cputune>
```

**Penjelasan kata demi kata:**
- `<vcpu placement='static'>4</vcpu>` — 4 vCPU statis.
- `<cputune>` — tuning CPU.
- `<vcpupin vcpu='0' cpuset='2'/>` — vCPU 0 di core 2.
- `<emulatorpin cpuset='0-1'/>` — emulator di core 0-1.
- `<iothreadpin iothread='1' cpuset='6-7'/>` — iothread 1 di core 6-7.

**Alternatif dengan `virsh`:**
```bash
virsh vcpupin numa-vm 0 2
virsh vcpupin numa-vm 1 3
virsh vcpupin numa-vm 2 4
virsh vcpupin numa-vm 3 5
virsh emulatorpin numa-vm 0-1
```

### 4.6. CPU Isolation di Bootloader

**Edit GRUB:**
```ini
GRUB_CMDLINE_LINUX_DEFAULT="... isolcpus=2,3,4,5 nohz_full=2,3,4,5 rcu_nocbs=2,3,4,5 irqaffinity=0,1"
```

**Penjelasan:**
- `isolcpus=2,3,4,5` — isolasi core 2-5.
- `nohz_full=2,3,4,5` — no timer tick.
- `rcu_nocbs=2,3,4,5` — offload RCU.
- `irqaffinity=0,1` — IRQ di core 0-1.

**Regenerate:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

**Verifikasi:**
```bash
cat /sys/devices/system/cpu/isolated
# Output: 2-5

cat /proc/cmdline
```

### 4.7. Cek Hugepages

```bash
# Cek hugepages
cat /proc/meminfo | grep -i huge
# Output:
# AnonHugePages:         0 kB
# ShmemHugePages:        0 kB
# HugePages_Total:       0
# HugePages_Free:        0
# HugePages_Rsvd:        0
# HugePages_Surp:        0
# Hugepagesize:       2048 kB
# Hugetlb:               0 kB
```

**Penjelasan:**
- `HugePages_Total` — total hugepages.
- `HugePages_Free` — free.
- `Hugepagesize` — ukuran.

### 4.8. Mengaktifkan Hugepages

```bash
# 2M hugepages: 2048 pages = 4 GiB
echo 2048 | sudo tee /proc/sys/vm/nr_hugepages

# Verifikasi
cat /proc/meminfo | grep -i huge
```

**Penjelasan:**
- `vm.nr_hugepages` — jumlah hugepages 2M.

**Persisten:**
```bash
echo "vm.nr_hugepages = 2048" | sudo tee /etc/sysctl.d/10-hugepages.conf
sudo sysctl -p /etc/sysctl.d/10-hugepages.conf
```

### 4.9. Hugepages 1G

**Edit GRUB:**
```ini
GRUB_CMDLINE_LINUX_DEFAULT="... default_hugepagesz=1G hugepagesz=1G hugepages=4"
```

**Penjelasan:**
- `default_hugepagesz=1G` — default 1G.
- `hugepagesz=1G` — ukuran 1G.
- `hugepages=4` — 4 halaman 1G = 4 GiB.

**Verifikasi:**
```bash
cat /proc/meminfo | grep -i huge
```

### 4.10. Konfigurasi Hugepages di XML

```xml
<memoryBacking>
  <hugepages>
    <page size='2' unit='MiB'/>
  </hugepages>
  <source type='file'/>
  <access mode='private'/>
  <allocation mode='immediate'/>
</memoryBacking>
```

**Penjelasan kata demi kata:**
- `<memoryBacking>` — backing memori.
- `<hugepages>` — gunakan hugepages.
  - `<page size='2' unit='MiB'/>` — ukuran 2 MiB.
- `<source type='file'/>` — sumber file.
- `<access mode='private'/>` — akses private.
- `<allocation mode='immediate'/>` — alokasi langsung.

**Untuk 1G:**
```xml
<memoryBacking>
  <hugepages>
    <page size='1' unit='GiB'/>
  </hugepages>
  <source type='file'/>
  <access mode='private'/>
  <allocation mode='immediate'/>
</memoryBacking>
```

### 4.11. Mount hugetlbfs

```bash
sudo mkdir -p /dev/hugepages
sudo mount -t hugetlbfs hugetlbfs /dev/hugepages
```

**Penjelasan:**
- `hugetlbfs` — filesystem hugepages.

**Otomatis di `/etc/fstab`:**
```ini
hugetlbfs /dev/hugepages hugetlbfs mode=1770,gid=999 0 0
```

**Penjelasan:**
- `mode=1770` — permission.
- `gid=999` — grup kvm.

### 4.12. Cek KSM

```bash
# Cek status KSM
cat /sys/kernel/mm/ksm/run
# Output: 0 (mati) atau 1 (hidup)

# Cek statistik
cat /sys/kernel/mm/ksm/pages_shared
cat /sys/kernel/mm/ksm/pages_sharing
cat /sys/kernel/mm/ksm/pages_unshared
cat /sys/kernel/mm/ksm/pages_volatile
```

**Penjelasan:**
- `run` — status.
- `pages_shared` — halaman dibagi.
- `pages_sharing` — halaman berbagi.
- `pages_unshared` — halaman tidak dibagi.
- `pages_volatile` — halaman volatil.

### 4.13. Mengaktifkan KSM

```bash
# Aktifkan KSM
echo 1 | sudo tee /sys/kernel/mm/ksm/run

# Set parameter
echo 1000 | sudo tee /sys/kernel/mm/ksm/pages_to_scan
echo 20 | sudo tee /sys/kernel/mm/ksm/sleep_millisecs
```

**Penjelasan:**
- `run=1` — aktifkan.
- `pages_to_scan=1000` — halaman per scan.
- `sleep_millisecs=20` — jeda.

**Persisten dengan systemd:**
```bash
sudo systemctl enable --now ksm.service
sudo systemctl enable --now ksmtuned.service
```

### 4.14. Konfigurasi KSM di XML

```xml
<memoryBacking>
  <nosharepages/>
</memoryBacking>
```

**Penjelasan:**
- `<nosharepages/>` — matikan KSM untuk VM ini.

**Alternatif dengan `madvise`:**
```xml
<memoryBacking>
  <source type='anonymous'/>
  <access mode='private'/>
  <allocation mode='immediate'/>
</memoryBacking>
```

### 4.15. Konfigurasi NUMA di XML Lengkap

```xml
<cpu mode='host-passthrough' check='none'>
  <topology sockets='2' dies='1' cores='4' threads='1'/>
  <numa>
    <cell id='0' cpus='0-3' memory='4096' unit='MiB'/>
    <cell id='1' cpus='4-7' memory='4096' unit='MiB'/>
  </numa>
</cpu>

<numatune>
  <memory mode='strict' nodeset='0-1'/>
  <memnode cellid='0' mode='strict' nodeset='0'/>
  <memnode cellid='1' mode='strict' nodeset='1'/>
</numatune>

<cputune>
  <vcpupin vcpu='0' cpuset='2'/>
  <vcpupin vcpu='1' cpuset='3'/>
  <vcpupin vcpu='2' cpuset='4'/>
  <vcpupin vcpu='3' cpuset='5'/>
  <vcpupin vcpu='4' cpuset='10'/>
  <vcpupin vcpu='5' cpuset='11'/>
  <vcpupin vcpu='6' cpuset='12'/>
  <vcpupin vcpu='7' cpuset='13'/>
  <emulatorpin cpuset='0-1'/>
</cputune>

<memoryBacking>
  <hugepages>
    <page size='2' unit='MiB'/>
  </hugepages>
  <nosharepages/>
  <source type='file'/>
  <access mode='private'/>
  <allocation mode='immediate'/>
</memoryBacking>
```

**Penjelasan:**
- NUMA 2 cell.
- Pinning ke core fisik.
- Hugepages 2M.
- KSM off.

### 4.16. Skrip Setup Hugepages

```bash
#!/bin/bash
set -euo pipefail

log() { echo "[$(date '+%F %T')] $*"; }

# Hitung total memori
TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
log "Total memori: ${TOTAL_MEM} MiB"

# Alokasi 50% untuk hugepages 2M
HUGEPAGES=$((TOTAL_MEM / 2 / 2))
log "Alokasi $HUGEPAGES hugepages 2M (${HUGEPAGES} x 2 MiB = $((HUGEPAGES * 2)) MiB)"

# Set
echo "$HUGEPAGES" | sudo tee /proc/sys/vm/nr_hugepages > /dev/null

# Persisten
echo "vm.nr_hugepages = $HUGEPAGES" | sudo tee /etc/sysctl.d/10-hugepages.conf > /dev/null
sudo sysctl -p /etc/sysctl.d/10-hugepages.conf

# Verifikasi
cat /proc/meminfo | grep -i huge
```

**Penjelasan:**
- Hitung hugepages.
- Set.
- Persisten.

### 4.17. Skrip Setup NUMA

```bash
#!/bin/bash
set -euo pipefail

log() { echo "[$(date '+%F %T')] $*"; }

log "Topologi NUMA:"
numactl --hardware

log "Statistik NUMA:"
numastat

log "CPU per node:"
for node in /sys/devices/system/node/node*; do
    echo "Node $(basename $node): $(cat $node/cpulist)"
done

log "Distance:"
cat /sys/devices/system/node/node*/distance
```

### 4.18. Skrip Setup CPU Pinning

```bash
#!/bin/bash
set -euo pipefail

VM="${1:-numa-vm}"
VCPU_COUNT=$(virsh dominfo "$VM" | awk '/CPU\(s\)/{print $2}')
log() { echo "[$(date '+%F %T')] $*"; }

log "VM $VM memiliki $VCPU_COUNT vCPU"

# Pin vCPU ke core 2,3,4,5,...
for i in $(seq 0 $((VCPU_COUNT - 1))); do
    CORE=$((i + 2))
    log "Pin vCPU $i ke core $CORE"
    virsh vcpupin "$VM" "$i" "$CORE" --live
done

# Pin emulator
virsh emulatorpin "$VM" 0-1 --live

log "Selesai"
virsh vcpupin "$VM"
```

**Penjelasan:**
- Loop pin vCPU.
- Pin emulator.

### 4.19. Verifikasi NUMA di Guest

```bash
# Di guest
numactl --hardware
lscpu | grep -i numa
cat /sys/devices/system/node/node*/cpulist
```

**Penjelasan:**
- Cek topologi NUMA di guest.

### 4.20. Verifikasi Pinning

```bash
# Di host
virsh vcpupin numa-vm
# Output:
# VCPU: CPU Affinity
# ----------------------------------
#    0: 2
#    1: 3
#    2: 4
#    3: 5

virsh emulatorpin numa-vm
# Output:
# emulator: CPU Affinity
# ----------------------------------
#        *: 0-1
```

### 4.21. Verifikasi Hugepages

```bash
# Di host
cat /proc/meminfo | grep -i huge
# Output:
# HugePages_Total:    2048
# HugePages_Free:     1024
# HugePages_Rsvd:        0
# HugePages_Surp:        0
# Hugepagesize:       2048 kB

# Di guest
cat /proc/meminfo | grep -i huge
```

### 4.22. Verifikasi KSM

```bash
# Cek status
cat /sys/kernel/mm/ksm/run

# Cek statistik
watch -n 1 'cat /sys/kernel/mm/ksm/pages_shared /sys/kernel/mm/ksm/pages_sharing'
```

### 4.23. Benchmark NUMA

```bash
# Install
sudo pacman -S numactl

# Benchmark
numactl --cpunodebind=0 --membind=0 sysbench cpu --threads=4 run
numactl --cpunodebind=0 --membind=1 sysbench cpu --threads=4 run
```

**Penjelasan:**
- Bandingkan lokal vs remote.

### 4.24. Benchmark Hugepages

```bash
# Tanpa hugepages
sysbench memory --memory-block-size=1G --memory-total-size=10G run

# Dengan hugepages
sysbench memory --memory-block-size=1G --memory-total-size=10G --memory-hugetlb=on run
```

### 4.25. Debug NUMA

```bash
# Cek statistik
numastat -p $(pgrep -f qemu-system-x86_64)
numastat -m

# Cek migrasi
grep -i numa /var/log/libvirt/qemu/numa-vm.log
```

### 4.26. Debug Pinning

```bash
# Cek afinitas
taskset -cp $(pgrep -f qemu-system-x86_64)
ps -eLo pid,tid,psr,comm | grep qemu

# Cek isolasi
cat /sys/devices/system/cpu/isolated
```

### 4.27. Debug Hugepages

```bash
# Cek alokasi
cat /proc/meminfo | grep -i huge
cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

# Cek defrag
cat /proc/sys/vm/compact_memory

# Trigger defrag
echo 1 | sudo tee /proc/sys/vm/compact_memory
```

### 4.28. Debug KSM

```bash
# Cek status
cat /sys/kernel/mm/ksm/run
cat /sys/kernel/mm/ksm/pages_to_scan
cat /sys/kernel/mm/ksm/sleep_millisecs

# Statistik
cat /sys/kernel/mm/ksm/pages_shared
cat /sys/kernel/mm/ksm/pages_sharing
cat /sys/kernel/mm/ksm/pages_unshared
cat /sys/kernel/mm/ksm/pages_volatile
cat /sys/kernel/mm/ksm/full_scans
```

### 4.29. Contoh XML Lengkap Tuning

```xml
<domain type='kvm'>
  <name>tuned-vm</name>
  <memory unit='MiB'>8192</memory>
  <vcpu placement='static'>8</vcpu>

  <cpu mode='host-passthrough' check='none'>
    <topology sockets='2' dies='1' cores='4' threads='1'/>
    <numa>
      <cell id='0' cpus='0-3' memory='4096' unit='MiB'/>
      <cell id='1' cpus='4-7' memory='4096' unit='MiB'/>
    </numa>
  </cpu>

  <numatune>
    <memory mode='strict' nodeset='0-1'/>
    <memnode cellid='0' mode='strict' nodeset='0'/>
    <memnode cellid='1' mode='strict' nodeset='1'/>
  </numatune>

  <cputune>
    <vcpupin vcpu='0' cpuset='2'/>
    <vcpupin vcpu='1' cpuset='3'/>
    <vcpupin vcpu='2' cpuset='4'/>
    <vcpupin vcpu='3' cpuset='5'/>
    <vcpupin vcpu='4' cpuset='10'/>
    <vcpupin vcpu='5' cpuset='11'/>
    <vcpupin vcpu='6' cpuset='12'/>
    <vcpupin vcpu='7' cpuset='13'/>
    <emulatorpin cpuset='0-1'/>
  </cputune>

  <memoryBacking>
    <hugepages>
      <page size='2' unit='MiB'/>
    </hugepages>
    <nosharepages/>
    <source type='file'/>
    <access mode='private'/>
    <allocation mode='immediate'/>
  </memoryBacking>

  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='/var/lib/libvirt/images/tuned-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
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
    <graphics type='none'/>
    <video><model type='none'/></video>
    <memballoon model='none'/>
  </devices>
</domain>
```

**Penjelasan:**
- NUMA 2 cell.
- Pinning.
- Hugepages.
- KSM off.
- Emulator pin.
- Hardened.

### 4.30. Verifikasi Tuning

```bash
# 1. Cek VM
virsh dominfo tuned-vm

# 2. Cek NUMA
virsh numatune tuned-vm
# Output: nodeset: 0-1

# 3. Cek pinning
virsh vcpupin tuned-vm
virsh emulatorpin tuned-vm

# 4. Cek hugepages
virsh dumpxml tuned-vm | grep -A 10 memoryBacking

# 5. Cek KSM
cat /sys/kernel/mm/ksm/run
virsh dumpxml tuned-vm | grep nosharepages

# 6. Benchmark
sysbench cpu --threads=8 run
sysbench memory --memory-block-size=1G run
```

---

## 5. Diagram Arsitektur NUMA, Pinning, Hugepages & KSM

### 5.1. Arsitektur NUMA

```
+-------------------+     +-------------------+
|  Socket 0         |     |  Socket 1         |
|  +-------------+  |     |  +-------------+  |
|  |  CPU 0-7    |  |     |  |  CPU 8-15   |  |
|  +-------------+  |     |  +-------------+  |
|  +-------------+  |     |  +-------------+  |
|  |  Mem Node 0 |  |     |  |  Mem Node 1 |  |
|  +-------------+  |     |  +-------------+  |
+-------------------+     +-------------------+
          |                         |
          |    Interconnect         |
          +-------------------------+
          |                         |
      Distance 10                Distance 21
```

### 5.2. CPU Pinning

```
Host CPU:  0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
Host:      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
VM1 vCPU:  |  |  | 0  1  2  3  |  |  |  |  |  |  |  |  |
VM2 vCPU:  |  |  |  |  |  |  |  |  | 4  5  6  7  |  |  |
Emulator:  0  1  |  |  |  |  |  |  |  |  |  |  |  |  |  |
```

### 5.3. Hugepages

```
Halaman standar (4 KiB):    [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ]
TLB entry:                  1   2   3   4   5   6   7   8

Hugepages (2 MiB):          [         ] [         ]
TLB entry:                  1           2
```

### 5.4. KSM

```
VM1 Memori:  [A] [B] [C] [D] [E] [F]
VM2 Memori:  [A] [B] [X] [Y] [E] [F]
                   |
                   v
KSM:         [A] [B] [C] [D] [E] [F]
             [ ] [ ] [X] [Y] [ ] [ ]
             (A, B, E, F dibagi)
```

### 5.5. Alur Tuning

```
Mulai
  |
  v
+-------------------+
|  Cek NUMA         |
+-------------------+
  |
  v
+-------------------+
|  Konfigurasi NUMA |
+-------------------+
  |
  v
+-------------------+
|  CPU Pinning      |
+-------------------+
  |
  v
+-------------------+
|  CPU Isolation    |
+-------------------+
  |
  v
+-------------------+
|  Hugepages        |
+-------------------+
  |
  v
+-------------------+
|  KSM              |
+-------------------+
  |
  v
+-------------------+
|  Benchmark        |
+-------------------+
  |
  v
+-------------------+
|  Iterasi          |
+-------------------+
```

### 5.6. Pohon Keputusan Tuning

```
Apakah host punya NUMA?
├── Ya → Konfigurasi NUMA
└── Tidak → Skip

Apakah butuh latensi rendah?
├── Ya → CPU pinning + isolasi
└── Tidak → Biarkan default

Apakah butuh performa memori?
├── Ya → Hugepages
└── Tidak → Standar

Apakah butuh hemat memori?
├── Ya → KSM
└── Tidak → Matikan KSM
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 8.4

Kurikulum asli menyebut:
> **Lab L8.4 — NUMA**
> ```xml
> <numatune>
>   <memory mode='strict' nodeset='0'/>
> </numatune>
> ```
> Validasi Lulus: Performa meningkat, latensi turun.

Kita akan menambahkan:
1. **NUMA**: node, distance, local/remote memory, interconnect.
2. **numactl, numastat, numad**.
3. **NUMA Policy**: strict, preferred, interleave, bind.
4. **NUMA di XML**: `<numa>`, `<numatune>`, `<memnode>`.
5. **CPU Pinning**: vcpupin, emulatorpin, iothreadpin.
6. **CPU Isolation**: isolcpus, nohz_full, rcu_nocbs, irqaffinity.
7. **Hugepages**: 2M, 1G, hugetlbfs, THP.
8. **Hugepages di XML**: `<memoryBacking>`, `<hugepages>`, `<page>`.
9. **KSM**: run, pages_to_scan, sleep_millisecs.
10. **KSM di XML**: `<nosharepages/>`.
11. **Keamanan KSM**: side-channel.
12. **Tuning**: cache, queue, defrag.
13. **Benchmark**: sysbench, numactl.
14. **Debug**: numastat, taskset, /proc/meminfo.
15. **Skrip setup**.
16. **Verifikasi**.
17. **Pohon keputusan**.
18. **Kombinasi dengan passthrough & SR-IOV**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 8.4.

---

## 7. Hubungan dengan Modul Lain

- **Modul 8.1 (Live Migration)**: NUMA mempengaruhi migrasi.
- **Modul 8.2 (VFIO)**: passthrough butuh pinning.
- **Modul 8.3 (SR-IOV & virtiofs)**: VF butuh NUMA & pinning.
- **Modul 8.5 (Observability)**: memantau performa.
- **Fase 8 lanjutan**: HPC, AI/ML, NFV, real-time.

---

## 8. Referensi Lengkap

- Arch Wiki: Improving performance — https://wiki.archlinux.org/title/Improving_performance
- Arch Wiki: CPU frequency scaling — https://wiki.archlinux.org/title/CPU_frequency_scaling
- Arch Wiki: Hugepages — https://wiki.archlinux.org/title/Hugepages
- Arch Wiki: KSM — https://wiki.archlinux.org/title/Kernel_Samepage_Merging
- Linux NUMA — https://docs.kernel.org/admin-guide/mm/numa_memory_policy.html
- Linux Hugepages — https://docs.kernel.org/admin-guide/mm/hugetlbpage.html
- Linux KSM — https://docs.kernel.org/admin-guide/mm/ksm.html
- libvirt CPU Tuning — https://libvirt.org/formatdomain.html#cpu-model-and-topology
- libvirt NUMA — https://libvirt.org/formatdomain.html#numa-node-tuning
- libvirt Memory Backing — https://libvirt.org/formatdomain.html#memory-backing
- QEMU NUMA — https://www.qemu.org/docs/master/system/qemu-cpu-models.html
- QEMU Hugepages — https://www.qemu.org/docs/master/system/invocation.html
- numactl — https://man7.org/linux/man-pages/man8/numactl.8.html
- numastat — https://man7.org/linux/man-pages/man8/numastat.8.html
- taskset — https://man7.org/linux/man-pages/man1/taskset.1.html
- sysbench — https://github.com/akopytov/sysbench
- DPDK — https://doc.dpdk.org/
- NFV — https://www.etsi.org/technologies/nfv

---

## 9. Tips & Praktik Terbaik

1. **Cek NUMA** sebelum tuning.
2. **Gunakan strict** untuk determinisme.
3. **Pin vCPU** ke core fisik.
4. **Pin emulator** ke core terpisah.
5. **Isolasi core** untuk VM kritis.
6. **Gunakan nohz_full** untuk latensi.
7. **Gunakan hugepages** untuk performa.
8. **Alokasi hugepages** di boot.
9. **Gunakan 1G** untuk VM besar.
10. **Matikan KSM** untuk keamanan.
11. **Aktifkan KSM** untuk hemat memori.
12. **Benchmark** sebelum & sesudah.
13. **Monitor** dengan numastat.
14. **Gunakan taskset** untuk verifikasi.
15. **Backup XML**.
16. **Test di VM terpisah**.
17. **Dokumentasikan**.
18. **Iterasi**.
19. **Ukur, jangan tebak**.
20. **Kombinasikan** dengan passthrough & SR-IOV.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| NUMA tidak terdeteksi | BIOS. | Aktifkan NUMA. |
| Performa tidak meningkat | Pinning salah. | Cek core. |
| Hugepages gagal | Memori tidak cukup. | Defrag. |
| Hugepages tidak terpakai | XML salah. | Cek XML. |
| KSM tidak jalan | Tidak aktif. | `echo 1 > run`. |
| KSM lambat | pages_to_scan besar. | Kecilkan. |
| VM crash | NUMA strict. | Gunakan preferred. |
| Latensi tinggi | Remote memory. | Pin ke lokal. |
| CPU 100% | Tidak ada pinning. | Pin. |
| Cache miss | vCPU migrasi. | Pin. |
| Hugepages fragmentasi | Memori fragmentasi. | Defrag. |
| 1G gagal | Tidak didukung. | Cek CPU. |
| THP aktif | Default. | Matikan THP. |
| KSM side-channel | Keamanan. | Matikan KSM. |
| VM tidak start | Memori tidak cukup. | Tambah. |
| Benchmark salah | Tidak isolasi. | Isolasi. |
| numastat tidak ada | Paket. | Install. |
| taskset tidak ada | Paket. | Install. |
| Hugepages tidak persisten | Tidak sysctl. | Set sysctl. |
| NUMA distance salah | BIOS. | Cek BIOS. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- NUMA terdeteksi.
- numastat menunjukkan lokal.
- vCPU ter-pin.
- Emulator ter-pin.
- Core terisolasi.
- Hugepages teralokasi.
- VM menggunakan hugepages.
- KSM sesuai keinginan.
- Benchmark meningkat.
- Latensi turun.

**Troubleshooting:**
- Jika NUMA tidak terdeteksi: cek BIOS, cek kernel.
- Jika performa tidak meningkat: cek pinning, cek NUMA.
- Jika hugepages gagal: cek memori, defrag.
- Jika VM crash: cek NUMA mode, cek memori.
- Jika KSM lambat: kecilkan pages_to_scan.
- Jika KSM tidak jalan: cek run.
- Jika latensi tinggi: cek remote memory.
- Jika cache miss: cek pinning.
- Untuk debug: numastat, taskset, /proc/meminfo.
- Untuk benchmark: sysbench.

---

## 12. Latihan Mandiri

1. Cek topologi NUMA.
2. Cek statistik NUMA.
3. Konfigurasi NUMA di XML.
4. Verifikasi NUMA di guest.
5. Konfigurasi CPU pinning.
6. Verifikasi pinning.
7. Konfigurasi emulator pinning.
8. Konfigurasi CPU isolation.
9. Verifikasi isolasi.
10. Aktifkan hugepages 2M.
11. Aktifkan hugepages 1G.
12. Konfigurasi hugepages di XML.
13. Verifikasi hugepages.
14. Mount hugetlbfs.
15. Aktifkan KSM.
16. Konfigurasi KSM.
17. Matikan KSM untuk VM.
18. Benchmark NUMA.
19. Benchmark hugepages.
20. Benchmark KSM.
21. Debug NUMA.
22. Debug pinning.
23. Debug hugepages.
24. Debug KSM.
25. Buat skrip setup.
26. Dokumentasikan.

---

## 13. Penutup Modul 8.4

Anda kini menguasai **NUMA, CPU Pinning, Hugepages, KSM** — empat pilar tuning performa virtualisasi. Anda bisa:
- Memahami **NUMA**: node, distance, local/remote memory.
- Menggunakan **numactl, numastat**.
- Mengkonfigurasi **NUMA di XML**: `<numa>`, `<numatune>`, `<memnode>`.
- Melakukan **CPU pinning**: vcpupin, emulatorpin, iothreadpin.
- Melakukan **CPU isolation**: isolcpus, nohz_full, rcu_nocbs.
- Mengaktifkan **hugepages**: 2M, 1G, hugetlbfs.
- Mengkonfigurasi **hugepages di XML**.
- Mengaktifkan & mengkonfigurasi **KSM**.
- Memahami **risiko keamanan KSM**.
- Melakukan **benchmark**.
- Melakukan **debugging & troubleshooting**.
- Membuat **skrip setup**.

Ini adalah fondasi untuk **Modul 8.5 — Observability & API libvirt**, di mana kita akan membahas cara memantau dan mengotomasi semua yang telah dipelajari.

---

*Motivasi: Performa adalah hasil dari pemahaman, bukan kebetulan. Anda telah mempelajari empat pilar tuning: NUMA, pinning, hugepages, dan KSM. Setiap pilar memiliki trade-off. Tugas Anda adalah menemukan keseimbangan yang tepat untuk workload Anda. Ukur, jangan tebak. Iterasi, jangan berhenti. Dunia virtualisasi tidak pernah berhenti ber evolusi.*

---

# Modul 8.5 — Observability & API libvirt

## Mini-Daftar Isi Modul 8.5
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Observability & API
6. Audit Kurikulum: Tambahan untuk Modul 8.5
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 8.5 & Fase 8

---

> *Motivasi: Yang tidak terukur, tidak bisa diperbaiki. Yang tidak terlihat, tidak bisa dikendalikan. Observability adalah mata dan telinga seorang engineer. API adalah tangan dan kakinya. Bersama, keduanya mengubah Anda dari operator menjadi arsitek. Kuasai keduanya, dan Anda tidak hanya menjalankan infrastruktur — Anda memahaminya.*

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Modul 8.5** adalah **puncak Fase 8** dan **penutup seluruh kurikulum**. Ia membahas dua pilar terakhir yang menyatukan semuanya:

1. **Observability** — kemampuan **memahami keadaan internal sistem** dari **output eksternal**. Terdiri dari tiga pilar:
   - **Metrics** — angka numerik (CPU, memori, I/O).
   - **Logs** — catatan kejadian (event, error, audit).
   - **Traces** — jejak alur eksekusi (syscall, function call).

2. **API libvirt** — antarmuka **programmatic** untuk mengelola libvirt, bukan hanya via `virsh`. Tersedia dalam **Python**, **Go**, **C**, **Perl**, **Ruby**, **Java**, **OCaml**, **PHP**. Memungkinkan **otomasi**, **integrasi**, dan **orchestration**.

Dalam konteks Arch Linux + libvirt/QEMU/KVM, observability & API memungkinkan:
- **Memantau** semua VM, host, storage, network.
- **Mendeteksi** anomali sebelum menjadi masalah.
- **Mengotomasi** provisioning, migrasi, backup.
- **Mengintegrasikan** dengan Prometheus, Grafana, Loki, Jaeger.
- **Membuat** dashboard, alert, SLO/SLA.
- **Mengaudit** keamanan.
- **Mengembangkan** tool kustom.

**Peran dalam kurikulum:** Modul ini adalah **penutup Fase 8** dan **seluruh kurikulum**. Setelah Anda menguasai virtualisasi, storage, jaringan, keamanan, otomasi, migrasi, passthrough, sharing, dan tuning, sekarang Anda belajar **memahami dan mengendalikan** semuanya secara terprogram. Ini adalah keterampilan yang membedakan **engineer** dari **arsitek**. Observability & API juga fondasi untuk:
- **Karier**: SRE, platform engineer, cloud architect.
- **Sertifikasi**: RHCE, CKA, AWS/GCP.
- **Proyek**: cluster, HA, orchestration, monitoring.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Observability vs Monitoring

- **Monitoring** — memantau **metrik yang diketahui** (CPU, memori). Menjawab "apakah sistem sehat?"
- **Observability** — memahami **keadaan internal** dari **output eksternal**. Menjawab "mengapa sistem begini?"

**Filosofi:** *Monitoring adalah pertanyaan. Observability adalah jawaban.*

### 2.2. Tiga Pilar Observability

1. **Metrics** — angka numerik dengan timestamp. Contoh: `cpu_usage_percent{vm="arch-vm"} 45`.
2. **Logs** — catatan kejadian. Contoh: `[2024-01-15] VM arch-vm started`.
3. **Traces** — jejak alur. Contoh: `qemu → ioctl → vfio → gpu`.

**Filosofi:** *Metrics adalah denyut. Logs adalah memori. Traces adalah jejak.*

### 2.3. Pull vs Push

- **Pull** — server **mengambil** metrics dari target. Contoh: Prometheus.
- **Push** — target **mengirim** metrics ke server. Contoh: StatsD, Graphite.

**Filosofi:** *Pull adalah wawancara. Push adalah laporan.*

### 2.4. Prometheus: Standar de Facto

**Prometheus** adalah sistem monitoring **pull-based** dengan:
- **Time-series database**.
- **PromQL** — query language.
- **Exporters** — untuk berbagai target.
- **Alertmanager** — untuk alert.
- **Service discovery**.

**Filosofi:** *Prometheus adalah mata. Ia melihat segalanya.*

### 2.5. Grafana: Visualisasi

**Grafana** adalah platform **visualisasi** yang mendukung:
- **Dashboard** interaktif.
- **Multiple data sources** (Prometheus, InfluxDB, Loki, dll.).
- **Alerting**.
- **Annotations**.
- **Variables**.

**Filosofi:** *Grafana adalah jendela. Ia membuat data terlihat.*

### 2.6. Loki: Log Aggregation

**Loki** adalah sistem **log aggregation** dari Grafana Labs:
- **Index label**, bukan full text.
- **LogQL** — query language mirip PromQL.
- **Integrasi dengan Grafana**.
- **Ringan** dibanding Elasticsearch.

**Filosofi:** *Loki adalah ingatan. Ia menyimpan cerita.*

### 2.7. eBPF: Tracing Modern

**eBPF** (extended Berkeley Packet Filter) adalah teknologi kernel yang memungkinkan:
- **Tracing** syscall, function, tracepoint.
- **Monitoring** network, I/O, scheduler.
- **Security** (seccomp, LSM).
- **Performance** analysis.

Tool: `bcc`, `bpftrace`, `bpftool`, `perf`.

**Filosofi:** *eBPF adalah mata di dalam kernel. Tanpa modul, tanpa reboot.*

### 2.8. libvirt API: Programmatic Control

**libvirt API** adalah antarmuka **C** dengan binding untuk banyak bahasa. Ia menyediakan:
- **Koneksi** ke daemon.
- **Domain** (VM) lifecycle.
- **Storage** pool & volume.
- **Network** management.
- **Event** loop.
- **Stream** untuk I/O.

**Filosofi:** *libvirt API adalah tangan. Ia melakukan apa yang virsh lakukan, tapi terprogram.*

### 2.9. Event Loop: Reaksi Otomatis

**Event loop** libvirt memungkinkan **callback** untuk event:
- VM start/stop.
- Migrasi.
- Perubahan konfigurasi.
- Alert.

**Filosofi:** *Event loop adalah refleks. Ia merespons tanpa menunggu.*

### 2.10. SLO/SLA/SLI

- **SLI** (Service Level Indicator) — metrik yang diukur. Contoh: uptime.
- **SLO** (Service Level Objective) — target internal. Contoh: 99.9% uptime.
- **SLA** (Service Level Agreement) — kontrak dengan pengguna. Contoh: 99.5% uptime.

**Filosofi:** *SLI adalah angka. SLO adalah janji. SLA adalah kontrak.*

### 2.11. Alerting: Ketika Sesuatu Salah

**Alerting** adalah **notifikasi** ketika metrik melewati **threshold**. Best practice:
- **Alert pada symptom**, bukan cause.
- **Hindari alert fatigue**.
- **Runbook** untuk setiap alert.
- **Severity** yang jelas.

**Filosofi:** *Alert adalah alarm. Jangan biarkan ia menangis tanpa alasan.*

### 2.12. Filosofi Keseluruhan

- **Metrics adalah denyut.**
- **Logs adalah memori.**
- **Traces adalah jejak.**
- **Prometheus adalah mata.**
- **Grafana adalah jendela.**
- **Loki adalah ingatan.**
- **eBPF adalah mata di kernel.**
- **API adalah tangan.**
- **Event loop adalah refleks.**
- **SLO adalah janji.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Observability** | Pemahaman internal dari output. | |
| **Monitoring** | Pemantauan metrik. | |
| **Metrics** | Angka numerik. | |
| **Logs** | Catatan kejadian. | |
| **Traces** | Jejak alur. | |
| **Pull** | Server ambil. | |
| **Push** | Target kirim. | |
| **Prometheus** | TSDB + monitoring. | |
| **PromQL** | Query Prometheus. | |
| **Exporter** | Penyedia metrics. | |
| **node_exporter** | Exporter host. | |
| **libvirt_exporter** | Exporter libvirt. | |
| **Grafana** | Visualisasi. | |
| **Dashboard** | Panel visual. | |
| **Loki** | Log aggregation. | |
| **LogQL** | Query Loki. | |
| **Jaeger** | Tracing. | |
| **OpenTelemetry** | Standar observability. | |
| **eBPF** | Extended BPF. | |
| **bpftrace** | Tracing BPF. | |
| **bcc** | BPF Compiler Collection. | |
| **perf** | Profiler kernel. | |
| **ftrace** | Function tracer. | |
| **libvirt API** | API libvirt. | |
| **libvirt-python** | Binding Python. | |
| **libvirt-go** | Binding Go. | |
| **virConnect** | Koneksi. | |
| **virDomain** | Domain (VM). | |
| **virNetwork** | Network. | |
| **virStoragePool** | Storage pool. | |
| **virStorageVol** | Storage volume. | |
| **Event Loop** | Loop event. | |
| **Callback** | Fungsi callback. | |
| **Stream** | Stream I/O. | |
| **SLO** | Service Level Objective. | |
| **SLA** | Service Level Agreement. | |
| **SLI** | Service Level Indicator. | |
| **Alert** | Notifikasi. | |
| **Alertmanager** | Manajer alert. | |
| **Runbook** | Panduan. | |
| **Dashboard** | Panel. | |
| **Annotation** | Catatan. | |
| **Variable** | Variabel. | |
| **Recording Rule** | Aturan rekam. | |
| **Alert Rule** | Aturan alert. | |
| **Grafana Loki** | Loki. | |
| **Promtail** | Agen log. | |
| **Fluentd** | Log collector. | |
| **Vector** | Log collector. | |
| **OpenTelemetry Collector** | Collector. | |
| **Jaeger** | Tracing. | |
| **Tempo** | Tracing Grafana. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Install libvirt-python

```bash
sudo pacman -S python-libvirt
```

**Penjelasan:**
- Paket `python-libvirt` di Arch.

**Alternatif pip:**
```bash
pip install libvirt-python
```

### 4.2. Koneksi Dasar Python

```python
#!/usr/bin/env python3
import libvirt
import sys

def main():
    # Koneksi
    conn = libvirt.open('qemu:///system')
    if conn is None:
        print('Gagal membuka koneksi', file=sys.stderr)
        sys.exit(1)

    print(f'libvirt version: {conn.getLibVersion()}')
    print(f'Hypervisor: {conn.getType()}')

    # Daftar VM
    domains = conn.listAllDomains()
    print(f'Jumlah VM: {len(domains)}')

    for dom in domains:
        print(f'  - {dom.name()}: {dom.state()}')

    conn.close()

if __name__ == '__main__':
    main()
```

**Penjelasan kata demi kata:**
- `import libvirt` — impor modul.
- `libvirt.open('qemu:///system')` — buka koneksi.
- `conn.getLibVersion()` — versi libvirt.
- `conn.getType()` — tipe hypervisor.
- `conn.listAllDomains()` — daftar VM.
- `dom.name()` — nama VM.
- `dom.state()` — state VM.
- `conn.close()` — tutup koneksi.

### 4.3. Membuat VM via API

```python
#!/usr/bin/env python3
import libvirt

def create_vm(conn, xml):
    try:
        dom = conn.createXML(xml, 0)
        print(f'VM {dom.name()} dibuat')
        return dom
    except libvirt.libvirtError as e:
        print(f'Gagal membuat VM: {e}')
        return None

xml = """
<domain type='kvm'>
  <name>api-vm</name>
  <memory unit='MiB'>1024</memory>
  <vcpu>2</vcpu>
  <os>
    <type arch='x86_64'>hvm</type>
  </os>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/api-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <graphics type='none'/>
  </devices>
</domain>
"""

conn = libvirt.open('qemu:///system')
dom = create_vm(conn, xml)
conn.close()
```

**Penjelasan:**
- `conn.createXML(xml, 0)` — buat VM dari XML.
- `dom.name()` — nama.

### 4.4. Lifecycle VM via API

```python
#!/usr/bin/env python3
import libvirt
import time

conn = libvirt.open('qemu:///system')
dom = conn.lookupByName('api-vm')

# Start
if dom.isActive() == 0:
    dom.create()
    print('VM started')

# Info
info = dom.info()
print(f'State: {info[0]}, MaxMem: {info[1]}, Memory: {info[2]}, CPUs: {info[3]}, CPU time: {info[4]}')

# Stats
stats = dom.getCPUStats(True)
print(f'CPU stats: {stats}')

# Memory stats
mem_stats = dom.memoryStats()
print(f'Memory stats: {mem_stats}')

# Shutdown
dom.shutdown()
time.sleep(5)

# Destroy
if dom.isActive() == 1:
    dom.destroy()
    print('VM destroyed')

conn.close()
```

**Penjelasan:**
- `dom.create()` — start.
- `dom.isActive()` — cek aktif.
- `dom.info()` — info.
- `dom.getCPUStats()` — statistik CPU.
- `dom.memoryStats()` — statistik memori.
- `dom.shutdown()` — shutdown.
- `dom.destroy()` — destroy.

### 4.5. Event Loop Python

```python
#!/usr/bin/env python3
import libvirt
import time

def domain_event_callback(conn, dom, event, detail, opaque):
    print(f'Event: {dom.name()} - {event} - {detail}')

def main():
    conn = libvirt.open('qemu:///system')

    # Register event
    conn.domainEventRegister(domain_event_callback, None)

    # Register lifecycle
    conn.registerCloseCallback(lambda conn, reason, opaque: print(f'Close: {reason}'), None)

    print('Event loop berjalan. Tekan Ctrl+C untuk keluar.')

    try:
        while True:
            conn.getInfo()  # trigger event loop
            time.sleep(1)
    except KeyboardInterrupt:
        print('Keluar...')
    finally:
        conn.close()

if __name__ == '__main__':
    main()
```

**Penjelasan:**
- `domainEventRegister` — register callback.
- `domain_event_callback` — fungsi callback.
- Event: `Started`, `Stopped`, `Defined`, `Undefined`.

### 4.6. Storage Pool via API

```python
#!/usr/bin/env python3
import libvirt

conn = libvirt.open('qemu:///system')

# List pool
pools = conn.listAllStoragePools()
print(f'Jumlah pool: {len(pools)}')

for pool in pools:
    print(f'  - {pool.name()}: {pool.isActive()}')

# Info pool
pool = conn.storagePoolLookupByName('default')
print(f'Pool info: {pool.info()}')

# List volume
vols = pool.listAllVolumes()
for vol in vols:
    print(f'  - {vol.name()}: {vol.info()}')

# Buat volume
xml = """
<volume>
  <name>api-vol.qcow2</name>
  <capacity unit='GiB'>10</capacity>
  <target>
    <format type='qcow2'/>
  </target>
</volume>
"""
vol = pool.createXML(xml, 0)
print(f'Volume {vol.name()} dibuat')

conn.close()
```

**Penjelasan:**
- `listAllStoragePools()` — daftar pool.
- `storagePoolLookupByName()` — cari pool.
- `listAllVolumes()` — daftar volume.
- `createXML()` — buat volume.

### 4.7. Network via API

```python
#!/usr/bin/env python3
import libvirt

conn = libvirt.open('qemu:///system')

# List network
nets = conn.listAllNetworks()
for net in nets:
    print(f'Network: {net.name()}, Active: {net.isActive()}')

# Info network
net = conn.networkLookupByName('default')
print(f'Bridge: {net.bridgeName()}')
print(f'DHCP leases: {net.DHCPLeases()}')

conn.close()
```

**Penjelasan:**
- `listAllNetworks()` — daftar network.
- `bridgeName()` — nama bridge.
- `DHCPLeases()` — lease DHCP.

### 4.8. Statistik VM via API

```python
#!/usr/bin/env python3
import libvirt
import time

conn = libvirt.open('qemu:///system')
dom = conn.lookupByName('api-vm')

# CPU stats
cpu_stats = dom.getCPUStats(True)
for i, stat in enumerate(cpu_stats):
    print(f'CPU {i}: {stat}')

# Memory stats
mem_stats = dom.memoryStats()
for key, value in mem_stats.items():
    print(f'Mem {key}: {value}')

# Block stats
block_stats = dom.blockStats('vda')
print(f'Block: {block_stats}')
# (rd_req, rd_bytes, wr_req, wr_bytes, errs)

# Interface stats
if_stats = dom.interfaceStats('vnet0')
print(f'Interface: {if_stats}')
# (rx_bytes, rx_packets, rx_errs, rx_drop, tx_bytes, tx_packets, tx_errs, tx_drop)

# Block info
block_info = dom.blockInfo('vda')
print(f'Block info: {block_info}')
# (capacity, allocation, physical)

conn.close()
```

**Penjelasan:**
- `getCPUStats(True)` — statistik CPU.
- `memoryStats()` — statistik memori.
- `blockStats('vda')` — statistik block.
- `interfaceStats('vnet0')` — statistik interface.
- `blockInfo('vda')` — info block.

### 4.9. Migrasi via API

```python
#!/usr/bin/env python3
import libvirt
import sys

def migrate(conn, dom, dest_uri):
    flags = libvirt.VIR_MIGRATE_LIVE | libvirt.VIR_MIGRATE_PERSIST_DEST
    params = {
        libvirt.VIR_MIGRATE_PARAM_BANDWIDTH: 1000,
        libvirt.VIR_MIGRATE_PARAM_AUTO_CONVERGE: 1,
    }

    try:
        dom.migrate(conn, flags, dest_uri, params=params, bandwidth=1000)
        print(f'Migrasi {dom.name()} berhasil')
    except libvirt.libvirtError as e:
        print(f'Migrasi gagal: {e}', file=sys.stderr)
        return False
    return True

conn = libvirt.open('qemu:///system')
dom = conn.lookupByName('api-vm')
migrate(conn, dom, 'qemu+ssh://user@host2/system')
conn.close()
```

**Penjelasan:**
- `VIR_MIGRATE_LIVE` — migrasi live.
- `VIR_MIGRATE_PERSIST_DEST` — persist di tujuan.
- `VIR_MIGRATE_PARAM_BANDWIDTH` — bandwidth.
- `VIR_MIGRATE_PARAM_AUTO_CONVERGE` — auto-converge.

### 4.10. Snapshot via API

```python
#!/usr/bin/env python3
import libvirt

conn = libvirt.open('qemu:///system')
dom = conn.lookupByName('api-vm')

# Buat snapshot
snap_xml = """
<domainsnapshot>
  <name>api-snap1</name>
  <description>Snapshot via API</description>
</domainsnapshot>
"""
snap = dom.snapshotCreateXML(snap_xml, 0)
print(f'Snapshot {snap.getName()} dibuat')

# List snapshot
snaps = dom.listAllSnapshots()
for s in snaps:
    print(f'  - {s.getName()}')

# Hapus snapshot
snap.delete()
print('Snapshot dihapus')

conn.close()
```

**Penjelasan:**
- `snapshotCreateXML()` — buat snapshot.
- `listAllSnapshots()` — daftar.
- `delete()` — hapus.

### 4.11. Prometheus Node Exporter

```bash
# Install
sudo pacman -S prometheus-node-exporter

# Enable
sudo systemctl enable --now prometheus-node-exporter

# Test
curl http://localhost:9100/metrics | head
```

**Penjelasan:**
- `node_exporter` — metrics host.
- Port 9100.

### 4.12. Prometheus libvirt Exporter

```bash
# Install dari AUR
yay -S prometheus-libvirt-exporter

# Atau build dari source
git clone https://github.com/kumina/libvirt_exporter.git
cd libvirt_exporter
make
sudo make install
```

**Penjelasan:**
- `libvirt_exporter` — metrics VM.
- Port 9177.

### 4.13. Konfigurasi Prometheus

**File `/etc/prometheus/prometheus.yml`:**

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'libvirt'
    static_configs:
      - targets: ['localhost:9177']

  - job_name: 'qemu'
    static_configs:
      - targets: ['localhost:9177']
```

**Penjelasan:**
- `scrape_interval` — interval.
- `job_name` — nama job.
- `targets` — target.

**Enable:**
```bash
sudo systemctl enable --now prometheus
```

### 4.14. PromQL Dasar

```promql
# CPU usage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk usage
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100

# VM CPU
rate(libvirt_domain_info_cpu_time_seconds_total[5m])

# VM memory
libvirt_domain_info_maximum_memory_bytes - libvirt_domain_info_memory_usage_bytes

# VM state
libvirt_domain_state_code
```

**Penjelasan:**
- `rate()` — laju.
- `avg by()` — rata-rata.
- `[5m]` — 5 menit.

### 4.15. Grafana

```bash
# Install
sudo pacman -S grafana

# Enable
sudo systemctl enable --now grafana

# Akses
# http://localhost:3000
# User: admin
# Pass: admin
```

**Penjelasan:**
- Grafana di port 3000.

**Tambah data source:**
- Configuration → Data Sources → Add → Prometheus.
- URL: `http://localhost:9090`.

### 4.16. Dashboard Grafana

**Import dashboard:**
- ID `1860` — Node Exporter Full.
- ID `12548` — libvirt Exporter.

**Buat dashboard kustom:**
- Panel: CPU, Memory, Disk, Network.
- VM: state, CPU, memory.

### 4.17. Loki & Promtail

```bash
# Install
sudo pacman -S loki promtail

# Konfigurasi Loki
sudo nano /etc/loki/loki-local-config.yaml
```

**File `/etc/loki/loki-local-config.yaml`:**

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1

schema_config:
  configs:
    - from: 2024-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /var/lib/loki/index
    cache_location: /var/lib/loki/cache
  filesystem:
    directory: /var/lib/loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
```

**File `/etc/promtail/promtail-local-config.yaml`:**

```yaml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log

  - job_name: libvirt
    static_configs:
      - targets:
          - localhost
        labels:
          job: libvirt
          __path__: /var/log/libvirt/**/*.log
```

**Enable:**
```bash
sudo systemctl enable --now loki promtail
```

### 4.18. LogQL Dasar

```logql
# Semua log
{job="varlogs"}

# Filter
{job="libvirt"} |= "error"

# Regex
{job="libvirt"} |~ "error|fail"

# JSON
{job="libvirt"} | json

# Rate
rate({job="libvirt"}[5m])
```

**Penjelasan:**
- `|=` — contains.
- `|~` — regex.
- `| json` — parse JSON.
- `rate()` — laju.

### 4.19. eBPF dengan bpftrace

```bash
# Install
sudo pacman -S bpftrace

# Trace syscall QEMU
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /comm == "qemu-system-x86"/ { @[probe] = count(); }'

# Trace I/O
sudo bpftrace -e 'tracepoint:block:block_rq_issue { @[comm] = count(); }'

# Trace network
sudo bpftrace -e 'tracepoint:net:net_dev_queue { @[comm] = count(); }'
```

**Penjelasan:**
- `tracepoint` — tracepoint kernel.
- `comm` — nama proses.
- `@[probe]` — map.
- `count()` — hitung.

### 4.20. eBPF dengan BCC

```bash
# Install
sudo pacman -S bcc-tools

# execsnoop
sudo /usr/share/bcc/tools/execsnoop

# opensnoop
sudo /usr/share/bcc/tools/opensnoop

# biolatency
sudo /usr/share/bcc/tools/biolatency

# tcpconnect
sudo /usr/share/bcc/tools/tcpconnect
```

**Penjelasan:**
- `execsnoop` — trace exec.
- `opensnoop` — trace open.
- `biolatency` — latensi block I/O.
- `tcpconnect` — trace TCP connect.

### 4.21. perf

```bash
# Install
sudo pacman -S perf

# Top
sudo perf top -p $(pgrep -f qemu-system-x86_64)

# Record
sudo perf record -p $(pgrep -f qemu-system-x86_64) -g -- sleep 10

# Report
sudo perf report

# Stat
sudo perf stat -p $(pgrep -f qemu-system-x86_64) -- sleep 10
```

**Penjelasan:**
- `perf top` — live profile.
- `perf record` — rekam.
- `perf report` — laporan.
- `perf stat` — statistik.

### 4.22. OpenTelemetry

```bash
# Install
sudo pacman -S opentelemetry-collector
```

**File `/etc/otel/config.yaml`:**

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:

exporters:
  logging:
    loglevel: debug
  prometheus:
    endpoint: "0.0.0.0:8889"
  loki:
    endpoint: "http://localhost:3100/loki/api/v1/push"

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [loki]
```

**Penjelasan:**
- `receivers` — penerima.
- `processors` — pemroses.
- `exporters` — pengirim.
- `service` — pipeline.

### 4.23. Skrip Monitoring VM

```python
#!/usr/bin/env python3
"""Monitor VM dan kirim metrics ke Prometheus Pushgateway."""
import libvirt
import time
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

PUSHGATEWAY = 'localhost:9091'

def collect_metrics():
    conn = libvirt.open('qemu:///system')
    registry = CollectorRegistry()

    cpu_gauge = Gauge('vm_cpu_usage', 'CPU usage', ['vm'], registry=registry)
    mem_gauge = Gauge('vm_memory_usage', 'Memory usage', ['vm'], registry=registry)

    for dom in conn.listAllDomains():
        if not dom.isActive():
            continue

        name = dom.name()

        # CPU
        try:
            cpu_stats = dom.getCPUStats(True)[0]
            cpu_time = cpu_stats['cpu_time'] / 1e9
            cpu_gauge.labels(vm=name).set(cpu_time)
        except Exception as e:
            print(f'CPU error {name}: {e}')

        # Memory
        try:
            mem = dom.memoryStats()
            usage = mem.get('actual', 0) - mem.get('available', 0)
            mem_gauge.labels(vm=name).set(usage)
        except Exception as e:
            print(f'Mem error {name}: {e}')

    conn.close()
    push_to_gateway(PUSHGATEWAY, job='vm_monitor', registry=registry)

if __name__ == '__main__':
    while True:
        try:
            collect_metrics()
            print('Metrics pushed')
        except Exception as e:
            print(f'Error: {e}')
        time.sleep(15)
```

**Penjelasan:**
- `libvirt.open` — koneksi.
- `Gauge` — metrik.
- `push_to_gateway` — kirim.
- Loop setiap 15 detik.

### 4.24. Alertmanager

**File `/etc/prometheus/alert.rules.yml`:**

```yaml
groups:
  - name: vm_alerts
    rules:
      - alert: VMHighCPU
        expr: rate(libvirt_domain_info_cpu_time_seconds_total[5m]) > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "VM {{ $labels.domain }} CPU tinggi"
          description: "VM {{ $labels.domain }} menggunakan CPU > 90% selama 5 menit"

      - alert: VMHighMemory
        expr: (libvirt_domain_info_maximum_memory_bytes - libvirt_domain_info_memory_usage_bytes) < 0.1 * libvirt_domain_info_maximum_memory_bytes
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "VM {{ $labels.domain }} memori tinggi"
          description: "VM {{ $labels.domain }} menggunakan > 90% memori"

      - alert: HostHighCPU
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Host {{ $labels.instance }} CPU tinggi"
          description: "Host CPU > 90% selama 5 menit"

      - alert: HostHighMemory
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Host {{ $labels.instance }} memori tinggi"
          description: "Host memory > 90% selama 5 menit"

      - alert: DiskFull
        expr: (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk {{ $labels.device }} penuh"
          description: "Disk usage > 85%"
```

**Konfigurasi Prometheus:**
```yaml
rule_files:
  - "/etc/prometheus/alert.rules.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']
```

**Penjelasan:**
- `alert` — nama alert.
- `expr` — query PromQL.
- `for` — durasi.
- `labels` — label.
- `annotations` — anotasi.

### 4.25. Alertmanager Config

**File `/etc/alertmanager/alertmanager.yml`:**

```yaml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'default'
  routes:
    - match:
        severity: critical
      receiver: 'critical'
    - match:
        severity: warning
      receiver: 'warning'

receivers:
  - name: 'default'
    email_configs:
      - to: 'admin@example.com'
        from: 'alert@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'alert@example.com'
        auth_password: 'password'

  - name: 'critical'
    email_configs:
      - to: 'oncall@example.com'
        from: 'alert@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'alert@example.com'
        auth_password: 'password'

  - name: 'warning'
    email_configs:
      - to: 'admin@example.com'
        from: 'alert@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'alert@example.com'
        auth_password: 'password'
```

**Enable:**
```bash
sudo systemctl enable --now alertmanager
```

### 4.26. Audit dengan auditd

```bash
# Install
sudo pacman -S audit

# Enable
sudo systemctl enable --now auditd

# Tambah rule
sudo auditctl -w /etc/libvirt -p wa -k libvirt_config
sudo auditctl -w /var/lib/libvirt/images -p wa -k libvirt_images

# Lihat log
sudo ausearch -k libvirt_config
sudo ausearch -k libvirt_images

# Laporan
sudo aureport -f
```

**Penjelasan:**
- `auditctl -w` — watch.
- `-p wa` — write, attribute.
- `-k` — key.
- `ausearch` — cari.
- `aureport` — laporan.

### 4.27. Skrip Audit

```bash
#!/bin/bash
set -euo pipefail

LOG="/var/log/vm-audit.log"

audit_vm() {
    local vm="$1"
    {
        echo "=== Audit $vm pada $(date) ==="
        virsh dominfo "$vm"
        virsh domstats "$vm"
        virsh dumpxml "$vm"
        echo
    } >> "$LOG"
}

for vm in $(virsh list --name); do
    audit_vm "$vm"
done

echo "Audit selesai: $LOG"
```

### 4.28. libvirt Go Binding

```go
package main

import (
	"fmt"
	"log"

	"github.com/libvirt/libvirt-go"
)

func main() {
	conn, err := libvirt.NewConnect("qemu:///system")
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	domains, err := conn.ListAllDomains(0)
	if err != nil {
		log.Fatal(err)
	}

	for _, dom := range domains {
		name, _ := dom.GetName()
		state, _, _ := dom.GetState()
		fmt.Printf("VM: %s, State: %d\n", name, state)
	}
}
```

**Penjelasan:**
- `libvirt.NewConnect` — koneksi.
- `ListAllDomains` — daftar VM.
- `GetName` — nama.
- `GetState` — state.

**Install:**
```bash
go get github.com/libvirt/libvirt-go
```

### 4.29. Dashboard Sederhana dengan Python

```python
#!/usr/bin/env python3
"""Dashboard VM sederhana di terminal."""
import libvirt
import time
import os

def clear():
    os.system('clear')

def render(conn):
    clear()
    print("=" * 80)
    print("VM DASHBOARD".center(80))
    print("=" * 80)
    print(f"{'Name':<20} {'State':<12} {'CPU':<10} {'Mem':<15} {'Disk':<15}")
    print("-" * 80)

    for dom in conn.listAllDomains():
        try:
            name = dom.name()
            state = dom.state()[0]
            state_str = ['N/A', 'Running', 'Blocked', 'Paused', 'Shutdown', 'Shutoff', 'Crashed'][state] if state < 7 else 'Unknown'

            if dom.isActive():
                cpu = dom.getCPUStats(True)[0]['cpu_time'] / 1e9
                mem = dom.memoryStats().get('actual', 0) / 1024 / 1024
                block = dom.blockInfo('vda')
                disk = block[0] / 1024 / 1024 / 1024
                print(f"{name:<20} {state_str:<12} {cpu:<10.2f} {mem:<15.2f} {disk:<15.2f}")
            else:
                print(f"{name:<20} {state_str:<12} {'-':<10} {'-':<15} {'-':<15}")
        except Exception as e:
            print(f"{name:<20} Error: {e}")

    print("-" * 80)
    print(f"Total: {len(conn.listAllDomains())} VM")

def main():
    conn = libvirt.open('qemu:///system')
    try:
        while True:
            render(conn)
            time.sleep(5)
    except KeyboardInterrupt:
        pass
    finally:
        conn.close()

if __name__ == '__main__':
    main()
```

**Penjelasan:**
- Dashboard terminal.
- Update setiap 5 detik.

### 4.30. Verifikasi Observability

```bash
# 1. Cek Prometheus
curl http://localhost:9090/api/v1/targets | jq

# 2. Cek metrics
curl http://localhost:9100/metrics | head
curl http://localhost:9177/metrics | head

# 3. Cek Grafana
curl http://localhost:3000/api/health

# 4. Cek Loki
curl http://localhost:3100/ready

# 5. Cek Promtail
curl http://localhost:9080/metrics | head

# 6. Cek Alertmanager
curl http://localhost:9093/api/v1/status

# 7. Cek API Python
python3 -c "import libvirt; print(libvirt.getVersion())"

# 8. Cek eBPF
sudo bpftrace -l 'tracepoint:syscalls:*' | head
```

---

## 5. Diagram Arsitektur Observability & API

### 5.1. Arsitektur Observability

```
+-------------------+     +-------------------+     +-------------------+
|  Host             |     |  Prometheus       |     |  Grafana          |
|  node_exporter    |---->|  (TSDB)           |---->|  (Dashboard)      |
|  libvirt_exporter |     |                   |     |                   |
+-------------------+     +-------------------+     +-------------------+
        |                          |                          ^
        |                          |                          |
        v                          v                          |
+-------------------+     +-------------------+     +-------------------+
|  Loki             |<----|  Promtail         |     |  Alertmanager     |
|  (Logs)           |     |  (Agent)          |     |  (Alert)          |
+-------------------+     +-------------------+     +-------------------+
        ^                          ^                          ^
        |                          |                          |
        |                          |                          |
+-------------------+     +-------------------+     +-------------------+
|  OpenTelemetry    |     |  eBPF / bpftrace  |     |  libvirt API      |
|  (Traces)         |     |  (Kernel)         |     |  (Python, Go)     |
+-------------------+     +-------------------+     +-------------------+
```

### 5.2. Alur Metrics

```
Target (node, VM)
  |
  | HTTP /metrics
  v
+-------------------+
|  Prometheus       |
+-------------------+
  |
  | PromQL
  v
+-------------------+
|  Grafana          |
+-------------------+
  |
  | Alert
  v
+-------------------+
|  Alertmanager     |
+-------------------+
  |
  | Email/Slack
  v
+-------------------+
|  Admin            |
+-------------------+
```

### 5.3. Alur Logs

```
Log Files
  |
  | Promtail
  v
+-------------------+
|  Loki             |
+-------------------+
  |
  | LogQL
  v
+-------------------+
|  Grafana          |
+-------------------+
```

### 5.4. Alur Traces

```
Application
  |
  | OpenTelemetry
  v
+-------------------+
|  OTel Collector   |
+-------------------+
  |
  | Export
  v
+-------------------+
|  Jaeger/Tempo     |
+-------------------+
  |
  v
+-------------------+
|  Grafana          |
+-------------------+
```

### 5.5. libvirt API

```
+-------------------+
|  Python/Go/C       |
+-------------------+
  |
  | libvirt API
  v
+-------------------+
|  libvirt daemon   |
+-------------------+
  |
  | QMP
  v
+-------------------+
|  QEMU             |
+-------------------+
  |
  v
+-------------------+
|  VM               |
+-------------------+
```

### 5.6. Event Loop

```
+-------------------+
|  libvirt daemon   |
+-------------------+
  |
  | Event
  v
+-------------------+
|  Event Loop       |
+-------------------+
  |
  | Callback
  v
+-------------------+
|  Application      |
+-------------------+
  |
  | Action
  v
+-------------------+
|  (notify, log,    |
|   migrate, etc.)  |
+-------------------+
```

### 5.7. Pohon Keputusan Observability

```
Apakah butuh metrics?
├── Ya → Prometheus + Grafana
└── Tidak → Skip

Apakah butuh logs?
├── Ya → Loki + Promtail
└── Tidak → Skip

Apakah butuh traces?
├── Ya → OpenTelemetry + Jaeger
└── Tidak → Skip

Apakah butuh kernel tracing?
├── Ya → eBPF / bpftrace
└── Tidak → Skip
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 8.5

Kurikulum asli menyebut:
> **Lab L8.5 — API**
> ```python
> import libvirt
> conn = libvirt.open('qemu:///system')
> ```
> Validasi Lulus: Skrip Python mengelola VM.

Kita akan menambahkan:
1. **Observability**: metrics, logs, traces.
2. **Prometheus**: arsitektur, PromQL, exporter.
3. **node_exporter & libvirt_exporter**.
4. **Grafana**: dashboard, data source.
5. **Loki & Promtail**: log aggregation, LogQL.
6. **eBPF**: bpftrace, BCC, perf.
7. **OpenTelemetry**: receiver, processor, exporter.
8. **libvirt API**: Python, Go.
9. **virConnect, virDomain, virNetwork, virStoragePool**.
10. **Event Loop**: register callback.
11. **Statistik**: CPU, memory, block, interface.
12. **Migrasi via API**.
13. **Snapshot via API**.
14. **Storage & Network via API**.
15. **Alertmanager**: rules, route, receiver.
16. **SLO/SLA/SLI**.
17. **Audit dengan auditd**.
18. **Dashboard terminal**.
19. **Skrip monitoring**.
20. **Verifikasi**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 8.5.

---

## 7. Hubungan dengan Modul Lain

- **Fase 1–7**: semua materi menjadi objek observability.
- **Modul 8.1 (Live Migration)**: memantau migrasi.
- **Modul 8.2 (VFIO)**: memantau perangkat passthrough.
- **Modul 8.3 (SR-IOV & virtiofs)**: memantau VF & virtiofs.
- **Modul 8.4 (NUMA, Pinning, Hugepages, KSM)**: memantau tuning.
- **Fase 8 lanjutan**: cluster, HA, orchestration.

---

## 8. Referensi Lengkap

- libvirt API — https://libvirt.org/html/libvirt-libvirt-domain.html
- libvirt Python — https://libvirt.org/python.html
- libvirt Go — https://github.com/libvirt/libvirt-go
- libvirt Events — https://libvirt.org/html/libvirt-libvirt-event.html
- Prometheus — https://prometheus.io/docs/
- PromQL — https://prometheus.io/docs/prometheus/latest/querying/basics/
- node_exporter — https://github.com/prometheus/node_exporter
- libvirt_exporter — https://github.com/kumina/libvirt_exporter
- Grafana — https://grafana.com/docs/
- Loki — https://grafana.com/docs/loki/
- Promtail — https://grafana.com/docs/loki/latest/clients/promtail/
- LogQL — https://grafana.com/docs/loki/latest/logql/
- Alertmanager — https://prometheus.io/docs/alerting/latest/alertmanager/
- OpenTelemetry — https://opentelemetry.io/docs/
- Jaeger — https://www.jaegertracing.io/docs/
- eBPF — https://ebpf.io/
- bpftrace — https://github.com/iovisor/bpftrace
- BCC — https://github.com/iovisor/bcc
- perf — https://perf.wiki.kernel.org/
- auditd — https://man7.org/linux/man-pages/man8/auditd.8.html
- Arch Wiki: Prometheus — https://wiki.archlinux.org/title/Prometheus
- Arch Wiki: Grafana — https://wiki.archlinux.org/title/Grafana
- Arch Wiki: eBPF — https://wiki.archlinux.org/title/BPF
- Google SRE Book — https://sre.google/sre-book/table-of-contents/
- SLO — https://sre.google/workbook/implementing-slos/

---

## 9. Tips & Praktik Terbaik

1. **Mulai dari metrics** sebelum logs/traces.
2. **Gunakan Prometheus** sebagai standar.
3. **Gunakan Grafana** untuk visualisasi.
4. **Gunakan Loki** untuk logs (lebih ringan dari ELK).
5. **Gunakan eBPF** untuk kernel tracing.
6. **Gunakan OpenTelemetry** untuk standar.
7. **Alert pada symptom**, bukan cause.
8. **Hindari alert fatigue**.
9. **Buat runbook** untuk setiap alert.
10. **Gunakan SLO** untuk prioritas.
11. **Gunakan libvirt API** untuk otomasi.
12. **Gunakan event loop** untuk reaksi.
13. **Gunakan pushgateway** untuk batch job.
14. **Gunakan recording rules** untuk query berat.
15. **Backup konfigurasi**.
16. **Version control** untuk dashboard.
17. **Test alert**.
18. **Dokumentasikan**.
19. **Monitor diri sendiri**.
20. **Iterasi**.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Prometheus tidak scrape | Konfigurasi. | Cek `prometheus.yml`. |
| Exporter tidak jalan | Service. | `systemctl status`. |
| Grafana tidak connect | Data source. | Cek URL. |
| Loki tidak terima log | Promtail. | Cek `promtail.yml`. |
| Alert tidak kirim | Alertmanager. | Cek route. |
| libvirt API error | Permission. | Cek polkit. |
| Event loop tidak jalan | Tidak trigger. | Panggil `conn.getInfo()`. |
| Migrasi via API gagal | Flag. | Cek flag. |
| Snapshot gagal | Disk. | Cek disk. |
| Metrics hilang | Pushgateway. | Cek push. |
| eBPF gagal | Permission. | `sudo`. |
| bpftrace error | Kernel. | Update kernel. |
| perf tidak jalan | Package. | Install `perf`. |
| Audit tidak jalan | Service. | `systemctl enable auditd`. |
| Dashboard blank | Query. | Cek PromQL. |
| Alert spam | Threshold. | Naikkan threshold. |
| Alert tidak sampai | SMTP. | Cek SMTP. |
| API lambat | Koneksi. | Reuse koneksi. |
| Memory leak | Event. | Deregister. |
| CPU tinggi | Polling. | Kurangi interval. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- Prometheus scrape target.
- Grafana menampilkan dashboard.
- Loki menerima log.
- Alertmanager mengirim alert.
- libvirt API berfungsi.
- Event loop berjalan.
- eBPF tracing berjalan.
- Audit berjalan.
- Dashboard terminal berjalan.
- SLO tercapai.

**Troubleshooting:**
- Jika Prometheus tidak scrape: cek `prometheus.yml`, cek firewall.
- Jika exporter tidak jalan: `systemctl status`, `journalctl`.
- Jika Grafana tidak connect: cek data source, cek URL.
- Jika Loki tidak terima log: cek promtail, cek path.
- Jika alert tidak kirim: cek route, cek receiver.
- Jika libvirt API error: cek permission, cek polkit.
- Jika event loop tidak jalan: panggil `conn.getInfo()`.
- Jika eBPF gagal: cek kernel, cek permission.
- Untuk debug: `journalctl`, `curl`, `promtool`.
- Untuk validasi: `promtool check config`, `logcli`.

---

## 12. Latihan Mandiri

1. Install libvirt-python.
2. Buat koneksi.
3. Daftar VM.
4. Buat VM via API.
5. Lifecycle VM via API.
6. Statistik VM via API.
7. Snapshot via API.
8. Migrasi via API.
9. Storage via API.
10. Network via API.
11. Event loop.
12. Install node_exporter.
13. Install libvirt_exporter.
14. Konfigurasi Prometheus.
15. Buat PromQL.
16. Install Grafana.
17. Buat dashboard.
18. Install Loki & Promtail.
19. Buat LogQL.
20. eBPF dengan bpftrace.
21. perf.
22. Alertmanager.
23. Audit.
24. Dashboard terminal.
25. Dokumentasikan.

---

## 13. Penutup Modul 8.5 & Fase 8

Anda kini menguasai **Observability & API libvirt** — puncak Fase 8 dan penutup seluruh kurikulum. Anda bisa:
- Memahami **tiga pilar observability**: metrics, logs, traces.
- Menggunakan **Prometheus, Grafana, Loki, Alertmanager**.
- Menggunakan **node_exporter, libvirt_exporter**.
- Menggunakan **eBPF, bpftrace, BCC, perf**.
- Menggunakan **OpenTelemetry**.
- Menggunakan **libvirt API** (Python, Go).
- Membuat **event loop**.
- Mengambil **statistik** VM.
- Melakukan **migrasi, snapshot** via API.
- Membuat **alert** dengan SLO/SLA.
- Melakukan **audit** dengan auditd.
- Membuat **dashboard terminal**.

**Proyek Fase 8:** Implementasi live migration + passthrough + observability.

**Rubrik Fase 8:**
| Kriteria | Bobot |
|---|---|
| Live migration | 20% |
| VFIO | 20% |
| SR-IOV/virtiofs | 20% |
| NUMA | 20% |
| Observability | 20% |

---

## Penutup Seluruh Kurikulum

Anda telah menempuh perjalanan luar biasa:

- **Fase 1** — Fondasi Virtualisasi & Host Hardening
- **Fase 2** — QEMU/KVM Murni (Tanpa libvirt)
- **Fase 3** — libvirt & virsh: Lifecycle & Domain XML
- **Fase 4** — Storage, Image & Backup Engineering
- **Fase 5** — Networking & Isolasi Jaringan
- **Fase 6** — Keamanan & Isolasi Lanjutan
- **Fase 7** — Otomasi, Troubleshooting & Capstone Multi-OS
- **Fase 8** — Expert: Migrasi, Passthrough & Observability

**Total estimasi:** 17–19 minggu (Fase 1–7) + 3–4 minggu (Fase 8) = **20–23 minggu**.

Anda bukan lagi pembelajar — Anda adalah **virtualization engineer**. Anda bisa:
- Membangun **infrastruktur VM terisolasi** di Arch Linux.
- Mengelola **QEMU/KVM** langsung dan via **libvirt**.
- Mengotomasi **provisioning** dengan cloud-init & unattended.
- Mengamankan **host & VM** dengan defense in depth.
- Membangun **jaringan tersegmentasi**.
- Melakukan **live migration**.
- Melakukan **VFIO/IOMMU passthrough**.
- Menggunakan **SR-IOV & virtiofs**.
- Melakukan **tuning NUMA, pinning, hugepages, KSM**.
- Memantau dengan **Prometheus, Grafana, Loki**.
- Mengotomasi dengan **libvirt API**.

---

*Motivasi: Perjalanan ini bukan tentang mencapai garis akhir, tetapi tentang menjadi engineer yang lebih baik. Setiap fase adalah batu bata. Setiap modul adalah pelajaran. Setiap lab adalah pengalaman. Kini Anda berdiri di puncak. Pandanglah ke belakang — betapa jauh Anda telah melangkah. Pandanglah ke depan — betapa luas dunia yang menanti. Teruslah belajar, teruslah berevolusi. Karena engineer sejati tidak pernah berhenti belajar.*

---

**Selamat!** Anda telah menyelesaikan **seluruh kurikulum** — dari Fase 1 hingga Fase 8. Anda adalah **virtualization engineer** sejati.

> - **[⬆️ Ke Atas](#)**
> - **[📚 Kurikulum](../../../../README.md)**
> - **[🏠 Home](../../../../../README.md)**
> - **[⬅️ Sebelumnya](../bagian-4/README.md)**

---

[0]: ./../README.md
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

