# Audit Kurikulum Fase 5 — Networking & Isolasi Jaringan

Berdasarkan `kurikulum.md`, Fase 5 mencakup:

1. Modul 5.1 — Network Isolated, NAT, Routed  
2. Modul 5.2 — Bridge vs Macvtap  
3. Modul 5.3 — Topologi Multi-Segmen dengan VM Router/Firewall  
4. Modul 5.4 — nwfilter + nftables: Anti-Spoof, Default-Deny Egress  
5. Modul 5.5 — Debug Jaringan (domiflist, tcpdump, bridge)

**Temuan audit:**

- Modul 5.1 sudah tepat sebagai fondasi. Namun, kurikulum belum menyebut secara eksplisit:
  - Perbedaan mendasar antara **isolated**, **NAT**, **routed**, dan **bridged**.
  - XML libvirt `<network>` untuk masing-masing tipe.
  - Peran `dnsmasq` pada NAT dan isolated.
  - Konfigurasi `ip_forward` dan `nftables` untuk routed.
  - DHCP statik vs dinamis.
  - IPv6 pada jaringan libvirt.
  - `virsh net-*` (define, start, autostart, destroy, undefine, update).
  - `virsh net-dhcp-leases`, `net-dumpxml`, `net-edit`.
  - Penggunaan `--network` di `virt-install`.
  - Interface virtual (`virbr0`, `virbr1`, `vnetX`).
  - Keamanan: membatasi akses antar VM dalam satu jaringan.

- Modul 5.2 (Bridge vs Macvtap) perlu tambahan:
  - Bridge dengan `nmcli` dan `systemd-networkd`.
  - Macvtap mode `bridge`, `private`, `vepa`, `passthrough`.
  - Keterbatasan macvtap (tidak bisa komunikasi host-guest).
  - Perbandingan performa.

- Modul 5.3 (Topologi Multi-Segmen) perlu tambahan:
  - Routing statik di VM router.
  - NAT di VM router (masquerade).
  - Firewall di VM router (nftables).
  - DHCP relay.
  - VLAN (802.1Q) untuk segmentasi.
  - VXLAN untuk overlay network.
  - Open vSwitch (opsional, tetapi relevan untuk expert).

- Modul 5.4 (nwfilter + nftables) perlu tambahan:
  - Arsitektur nwfilter: filterref, rule, chain.
  - `clean-traffic` filter.
  - Custom filter XML.
  - Integrasi nftables dengan libvirt (libvirt menggunakan iptables/ebtables secara historis; nftables didukung melalui `firewalld` atau konfigurasi manual).
  - Default-deny egress.
  - Anti-spoofing MAC dan IP.
  - Logging dan audit.

- Modul 5.5 (Debug Jaringan) perlu tambahan:
  - `tcpdump` pada interface `vnetX` dan `virbrX`.
  - `ip link`, `ip addr`, `ip route`, `bridge fdb`, `bridge vlan`.
  - `conntrack -L` untuk NAT.
  - `nft monitor trace`.
  - `virsh domifaddr`, `domiflist`.
  - `arping`, `ping`, `traceroute`, `mtr`, `nc`, `ss`.
  - Analisis paket dengan `wireshark` (TUI: `tshark`).

**Rekomendasi:** Tambahkan sub-modul atau poin-poin di atas ke dalam kurikulum sebagai pengayaan. Untuk saat ini, kita mulai dari **Modul 5.1**.

---

# Fase 5 — Networking & Isolasi Jaringan

**Estimasi:** 2 minggu  
**Prasyarat:** Fase 3 lulus; dasar TCP/IP, routing, nftables.

**Tujuan Fase:**
- Mendesain topologi jaringan VM dengan isolasi terbukti.
- Menguasai isolated, NAT, routed, bridge, macvtap.
- Mampu membangun VM router/firewall.
- Mampu mengaudit dan men-debug jaringan VM.

**Daftar Isi Fase:**

<details>
  <summary>📃 Daftar Isi</summary>

---


1. Modul 5.1 — Network Isolated, NAT, Routed  
2. Modul 5.2 — Bridge vs Macvtap  
3. Modul 5.3 — Topologi Multi-Segmen dengan VM Router/Firewall  
4. Modul 5.4 — nwfilter + nftables: Anti-Spoof, Default-Deny Egress  
5. Modul 5.5 — Debug Jaringan (domiflist, tcpdump, bridge)

</details>

---

# Modul 5.1 — Network Isolated, NAT, Routed

> *“Jaringan adalah ruang. Tanpa isolasi, batas menjadi ilusi.”*

## Mini-Daftar Isi Modul 5.1

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur Jaringan libvirt
6. Audit Kurikulum: Tambahan untuk Modul 5.1
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 5.1

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Network Isolated, NAT, dan Routed** adalah tiga mode dasar jaringan virtual yang disediakan libvirt. Masing-masing menentukan bagaimana VM berkomunikasi dengan host, VM lain, dan dunia luar.

- **Isolated**: VM hanya bisa berkomunikasi dengan VM lain di jaringan yang sama. Tidak ada akses ke host (kecuali host memiliki interface di jaringan itu) dan tidak ada akses ke internet. Cocok untuk laboratorium tertutup, uji malware, atau cluster internal.
- **NAT**: VM bisa mengakses dunia luar melalui host, tetapi dunia luar tidak bisa menginisiasi koneksi ke VM. Host bertindak sebagai router dengan NAT (masquerade). Cocok untuk VM yang butuh internet tetapi tidak ingin terekspos.
- **Routed**: VM bisa saling berkomunikasi dan host merutekan lalu lintas antar jaringan. Berbeda dengan NAT, routed tidak melakukan masquerade; host hanya meneruskan paket. Biasanya memerlukan konfigurasi routing statik di host dan guest. Cocok untuk topologi multi-segmen yang kompleks.

**Peran dalam kurikulum:** Modul ini adalah **fondasi Fase 5**. Tanpa memahami perbedaan isolated, NAT, dan routed, Anda akan kesulitan membangun topologi multi-segmen (5.3), menerapkan nwfilter (5.4), atau men-debug (5.5). Ini juga jembatan dari Fase 3 (domain XML) ke Fase 5 (network XML).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Jaringan Virtual = Switch + Router + Firewall

libvirt membuat **switch virtual** (bridge) dan **router virtual** (dnsmasq, nftables) untuk setiap jaringan. Setiap VM terhubung ke switch melalui **interface virtual** (`vnetX`). Switch dapat terhubung ke host, ke jaringan fisik, atau terisolasi.

**Filosofi:** *Jaringan virtual adalah simulasi jaringan fisik. Semua konsep jaringan fisik berlaku.*

### 2.2. Isolated: Pulau Tertutup

Isolated network adalah **bridge tanpa uplink**. VM terhubung ke bridge, tetapi bridge tidak terhubung ke interface fisik atau NAT. Host bisa memiliki IP di bridge tersebut (jika dikonfigurasi), sehingga host bisa berkomunikasi dengan VM. Namun, tidak ada akses ke internet.

**Filosofi:** *Isolasi total untuk keamanan dan pengujian.*

### 2.3. NAT: Gerbang Tersembunyi

NAT network adalah **bridge dengan NAT**. libvirt menjalankan `dnsmasq` untuk DHCP dan DNS, serta mengatur aturan nftables/iptables untuk masquerade. VM mendapat IP privat, dan host menerjemahkan alamat saat VM mengakses internet.

**Filosofi:** *VM bisa keluar, tetapi tidak bisa dimasuki.*

### 2.4. Routed: Jalan Terbuka

Routed network adalah **bridge tanpa NAT**, tetapi host mengaktifkan `ip_forward` dan memiliki rute ke jaringan VM. VM mendapat IP privat, dan host merutekan paket ke jaringan lain. Tidak ada masquerade, sehingga VM harus memiliki rute balik ke host.

**Filosofi:** *Routing adalah tulang punggung internet. NAT adalah tambalan.*

### 2.5. dnsmasq: DHCP + DNS

libvirt menggunakan `dnsmasq` untuk menyediakan DHCP dan DNS pada jaringan NAT dan isolated. dnsmasq juga bisa menjadi DNS forwarder.

**Filosofi:** *Otomatisasi konfigurasi jaringan untuk VM.*

### 2.6. Bridge: Tulang Punggung

Semua jaringan libvirt (kecuali macvtap) menggunakan **bridge**. Bridge adalah switch virtual di kernel Linux. Interface VM (`vnetX`) di-attach ke bridge. Host juga bisa memiliki interface di bridge.

**Filosofi:** *Bridge adalah switch. Switch adalah jantung jaringan.*

### 2.7. Interface Virtual: vnetX

Setiap VM yang berjalan membuat interface `vnetX` di host. Interface ini di-attach ke bridge. Anda bisa melihatnya dengan `ip link` atau `brctl show`.

**Filosofi:** *vnetX adalah kabel virtual antara VM dan switch.*

### 2.8. XML Network: Deklarasi

libvirt mendefinisikan jaringan dalam XML. XML ini disimpan di `/etc/libvirt/qemu/networks/`. Anda bisa mengelola dengan `virsh net-*`.

**Filosofi:** *Infrastruktur sebagai kode. XML adalah sumber kebenaran.*

### 2.9. Filosofi Keseluruhan

- **Isolated** untuk keamanan dan pengujian.
- **NAT** untuk kenyamanan dan akses internet.
- **Routed** untuk kontrol dan topologi kompleks.
- **Bridge** adalah fondasi.
- **dnsmasq** adalah otak DHCP/DNS.
- **nftables** adalah penjaga gerbang.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Network** | Jaringan virtual yang didefinisikan libvirt. | `isolated`, `default` |
| **Bridge** | Switch virtual kernel. | `virbr0`, `virbr1` |
| **vnetX** | Interface virtual VM di host. | `vnet0`, `vnet1` |
| **Isolated** | Jaringan tanpa uplink. | |
| **NAT** | Network Address Translation. | |
| **Routed** | Jaringan dengan routing tanpa NAT. | |
| **dnsmasq** | DHCP/DNS server ringan. | |
| **DHCP** | Dynamic Host Configuration Protocol. | |
| **DNS** | Domain Name System. | |
| **Masquerade** | NAT dengan source NAT. | |
| **ip_forward** | Kernel IP forwarding. | |
| **nftables** | Firewall modern Linux. | |
| **iptables** | Firewall lama (legacy). | |
| **virsh net-define** | Definisikan jaringan dari XML. | |
| **virsh net-start** | Aktifkan jaringan. | |
| **virsh net-autostart** | Aktifkan otomatis saat boot. | |
| **virsh net-destroy** | Matikan jaringan. | |
| **virsh net-undefine** | Hapus definisi. | |
| **virsh net-list** | Daftar jaringan. | |
| **virsh net-info** | Info jaringan. | |
| **virsh net-dumpxml** | Tampilkan XML. | |
| **virsh net-edit** | Edit XML. | |
| **virsh net-update** | Update bagian XML. | |
| **virsh net-dhcp-leases** | Lihat lease DHCP. | |
| **`<forward mode='nat'/>`** | Mode NAT. | |
| **`<forward mode='route'/>`** | Mode routed. | |
| **`<ip>`** | Konfigurasi IP bridge. | |
| **`<dhcp>`** | Konfigurasi DHCP. | |
| **`<host>`** | Reservasi DHCP statik. | |
| **`<domain>`** | Domain DNS lokal. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Melihat Jaringan Default

```bash
virsh net-list --all
```

**Output:**
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

**Penjelasan:**
- `net-list`: daftar jaringan.
- `--all`: termasuk yang tidak aktif.

### 4.2. Melihat XML Jaringan Default

```bash
virsh net-dumpxml default
```

**Output:**
```xml
<network>
  <name>default</name>
  <uuid>...</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

**Penjelasan kata demi kata:**
- `<network>`: elemen root.
- `<name>default</name>`: nama jaringan.
- `<forward mode='nat'/>`: mode NAT.
- `<bridge name='virbr0' stp='on' delay='0'/>`: bridge `virbr0`, STP aktif, delay 0.
- `<ip address='192.168.122.1' netmask='255.255.255.0'>`: IP bridge.
- `<dhcp>`: konfigurasi DHCP.
- `<range start='...' end='...'/>`: rentang IP.

### 4.3. Membuat Jaringan Isolated

**File `isolated.xml`:**
```xml
<network>
  <name>isolated</name>
  <bridge name='virbr1' stp='on' delay='0'/>
  <ip address='192.168.100.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.100.2' end='192.168.100.254'/>
    </dhcp>
  </ip>
</network>
```

**Perintah:**
```bash
virsh net-define isolated.xml
virsh net-start isolated
virsh net-autostart isolated
virsh net-list --all
```

**Penjelasan kata demi kata:**
- `net-define`: definisikan dari XML.
- `net-start`: aktifkan.
- `net-autostart`: aktifkan otomatis.
- Tidak ada `<forward>` → isolated.

### 4.4. Membuat Jaringan NAT

**File `nat.xml`:**
```xml
<network>
  <name>nat</name>
  <forward mode='nat'/>
  <bridge name='virbr2' stp='on' delay='0'/>
  <ip address='192.168.200.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.200.2' end='192.168.200.254'/>
    </dhcp>
  </ip>
</network>
```

**Perintah:**
```bash
virsh net-define nat.xml
virsh net-start nat
virsh net-autostart nat
```

**Penjelasan:**
- `<forward mode='nat'/>`: mode NAT.
- libvirt akan menambahkan aturan masquerade.

### 4.5. Membuat Jaringan Routed

**File `routed.xml`:**
```xml
<network>
  <name>routed</name>
  <forward mode='route'/>
  <bridge name='virbr3' stp='on' delay='0'/>
  <ip address='192.168.300.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.300.2' end='192.168.300.254'/>
    </dhcp>
  </ip>
</network>
```

**Perintah:**
```bash
virsh net-define routed.xml
virsh net-start routed
virsh net-autostart routed
```

**Penjelasan:**
- `<forward mode='route'/>`: mode routed.
- Host harus mengaktifkan `ip_forward`.
- Tidak ada masquerade.

### 4.6. Menghubungkan VM ke Jaringan

**Saat membuat VM dengan `virt-install`:**
```bash
virt-install \
  --name vm1 \
  --memory 1024 \
  --vcpus 1 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --network network=isolated \
  --graphics none \
  --console pty,target_type=serial
```

**Penjelasan:**
- `--network network=isolated`: hubungkan ke jaringan `isolated`.

**Di XML domain:**
```xml
<interface type='network'>
  <source network='isolated'/>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `<interface type='network'>`: interface ke jaringan libvirt.
- `<source network='isolated'/>`: nama jaringan.
- `<model type='virtio'/>`: driver virtio.

### 4.7. Melihat Interface VM

```bash
virsh domiflist vm1
```

**Output:**
```
Interface  Type     Source    Model  MAC
---------------------------------------------------
vnet0      network  isolated  virtio 52:54:00:...
```

**Penjelasan:**
- `domiflist`: daftar interface VM.
- `Source`: jaringan.
- `MAC`: alamat MAC.

### 4.8. Melihat Lease DHCP

```bash
virsh net-dhcp-leases isolated
```

**Output:**
```
 Expiry Time          MAC address        Protocol  IP address          Hostname
-----------------------------------------------------------------------------
 2024-01-15 10:00:00  52:54:00:...       ipv4      192.168.100.2/24    vm1
```

**Penjelasan:**
- `net-dhcp-leases`: lihat lease.
- Berguna untuk mengetahui IP VM.

### 4.9. Reservasi DHCP Statik

**Edit XML jaringan:**
```xml
<ip address='192.168.100.1' netmask='255.255.255.0'>
  <dhcp>
    <range start='192.168.100.2' end='192.168.100.254'/>
    <host mac='52:54:00:...' name='vm1' ip='192.168.100.10'/>
  </dhcp>
</ip>
```

**Perintah:**
```bash
virsh net-edit isolated
virsh net-destroy isolated
virsh net-start isolated
```

**Penjelasan:**
- `<host>`: reservasi.
- `mac`: MAC VM.
- `name`: hostname.
- `ip`: IP statik.

### 4.10. Menghapus Jaringan

```bash
virsh net-destroy isolated
virsh net-undefine isolated
```

**Penjelasan:**
- `net-destroy`: matikan.
- `net-undefine`: hapus definisi.

### 4.11. Melihat Aturan nftables/iptables

```bash
sudo nft list ruleset
sudo iptables -t nat -L -n -v
```

**Penjelasan:**
- libvirt menambahkan aturan NAT ke nftables/iptables.
- Cek untuk debugging.

### 4.12. Mengaktifkan IP Forward

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

**Permanent:**
```bash
echo 'net.ipv4.ip_forward=1' | sudo tee /etc/sysctl.d/99-ipforward.conf
sudo sysctl --system
```

**Penjelasan:**
- Diperlukan untuk routed dan NAT.
- NAT libvirt biasanya mengaktifkan sendiri.

### 4.13. Konfigurasi dnsmasq

libvirt menghasilkan konfigurasi dnsmasq di `/var/lib/libvirt/dnsmasq/`. Anda bisa melihat:
```bash
cat /var/lib/libvirt/dnsmasq/isolated.conf
```

**Output:**
```
dhcp-range=192.168.100.2,192.168.100.254
...
```

**Penjelasan:**
- dnsmasq dijalankan per jaringan.
- Konfigurasi otomatis.

### 4.14. Menambahkan DNS Lokal

```xml
<dns>
  <domain name='example.com'/>
  <host ip='192.168.100.10'>
    <hostname>vm1.example.com</hostname>
  </host>
</dns>
```

**Penjelasan:**
- `<dns>`: konfigurasi DNS.
- `<domain>`: domain lokal.
- `<host>`: entri DNS statik.

### 4.15. IPv6 pada Jaringan libvirt

```xml
<ip family='ipv6' address='fd00:dead:beef::1' prefix='64'>
  <dhcp>
    <range start='fd00:dead:beef::2' end='fd00:dead:beef::ffff'/>
  </dhcp>
</ip>
```

**Penjelasan:**
- `<ip family='ipv6'>`: konfigurasi IPv6.
- DHCPv6.

### 4.16. Perbandingan Tiga Mode

| Fitur | Isolated | NAT | Routed |
|---|---|---|---|
| Akses internet | Tidak | Ya | Ya (dengan routing) |
| Akses dari luar | Tidak | Tidak | Ya (dengan routing) |
| DHCP | Ya | Ya | Ya |
| DNS | Ya | Ya | Ya |
| Masquerade | Tidak | Ya | Tidak |
| IP Forward | Tidak | Ya | Ya |
| Bridge | Ya | Ya | Ya |
| Cocok untuk | Lab tertutup | VM umum | Topologi kompleks |

---

## 5. Diagram Arsitektur Jaringan libvirt

### 5.1. Isolated

```
+-------------------+
|      Host         |
|   (opsional IP)   |
+-------------------+
          |
          | virbr1
          |
+-------------------+
|   Bridge virbr1   |
+-------------------+
     |         |
     |         |
+---------+ +---------+
|  VM1    | |  VM2    |
| vnet0   | | vnet1   |
+---------+ +---------+
```

### 5.2. NAT

```
+-------------------+
|      Host         |
|   (IP 192.168.122.1)|
+-------------------+
          |
          | virbr0
          |
+-------------------+
|   Bridge virbr0   |
+-------------------+
     |         |
     |         |
+---------+ +---------+
|  VM1    | |  VM2    |
+---------+ +---------+
          |
          | NAT (masquerade)
          v
+-------------------+
|   Internet        |
+-------------------+
```

### 5.3. Routed

```
+-------------------+
|      Host         |
|   (IP 192.168.300.1)|
+-------------------+
          |
          | virbr3
          |
+-------------------+
|   Bridge virbr3   |
+-------------------+
     |         |
     |         |
+---------+ +---------+
|  VM1    | |  VM2    |
+---------+ +---------+
          |
          | Routing (tanpa NAT)
          v
+-------------------+
|   Jaringan lain   |
+-------------------+
```

### 5.4. Perbandingan Mode

```
+-----------+  +-----------+  +-----------+
| Isolated  |  | NAT       |  | Routed    |
+-----------+  +-----------+  +-----------+
| Tanpa     |  | Masquerade|  | Routing   |
| uplink    |  |           |  |           |
+-----------+  +-----------+  +-----------+
| VM <-> VM |  | VM <-> VM |  | VM <-> VM |
| VM <-> Host| | VM <-> Host| | VM <-> Host|
|           |  | VM -> Internet| | VM <-> Internet|
+-----------+  +-----------+  +-----------+
```

### 5.5. Alur Paket NAT

```
VM (192.168.122.2)
      |
      | paket ke 8.8.8.8
      v
Bridge virbr0
      |
      v
Host (192.168.122.1)
      |
      | NAT: source 192.168.122.2 -> IP host
      v
Internet
      |
      | balasan ke IP host
      v
Host
      |
      | NAT: destination IP host -> 192.168.122.2
      v
VM
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 5.1

Kurikulum asli hanya menyebut:
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

Kita akan menambahkan:

1. **Perbedaan isolated, NAT, routed** — tabel perbandingan.
2. **XML untuk NAT** — `<forward mode='nat'/>`.
3. **XML untuk routed** — `<forward mode='route'/>`.
4. **`virsh net-list --all`** — daftar jaringan.
5. **`virsh net-dumpxml`** — lihat XML.
6. **`virsh net-edit`** — edit XML.
7. **`virsh net-destroy`** — matikan.
8. **`virsh net-undefine`** — hapus.
9. **`virsh net-dhcp-leases`** — lihat lease.
10. **`virsh domiflist`** — lihat interface VM.
11. **`virsh domifaddr`** — lihat IP VM.
12. **Reservasi DHCP statik** — `<host>`.
13. **DNS lokal** — `<dns>`.
14. **IPv6** — `<ip family='ipv6'>`.
15. **`sysctl net.ipv4.ip_forward=1`** — IP forward.
16. **Konfigurasi dnsmasq** — `/var/lib/libvirt/dnsmasq/`.
17. **Aturan nftables/iptables** — cek NAT.
18. **`virt-install --network network=...`** — koneksi VM.
19. **Interface XML** — `<interface type='network'>`.
20. **Keamanan** — batasi akses antar VM.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 5.1.

---

## 7. Hubungan dengan Modul Lain

- **Modul 3.2 (Domain XML):** Interface jaringan adalah bagian dari domain XML.
- **Modul 3.4 (Storage Pool):** Tidak terkait langsung.
- **Modul 4.5 (Backup):** Backup konfigurasi jaringan.
- **Modul 5.2 (Bridge vs Macvtap):** Bridge adalah fondasi isolated/NAT/routed. Macvtap adalah alternatif.
- **Modul 5.3 (Topologi Multi-Segmen):** Menggabungkan beberapa jaringan isolated/NAT/routed.
- **Modul 5.4 (nwfilter + nftables):** nwfilter diterapkan pada interface VM; nftables mengatur NAT/routing.
- **Modul 5.5 (Debug):** Debug jaringan menggunakan `domiflist`, `tcpdump`, `bridge`.
- **Fase 6 (Keamanan):** Isolasi jaringan adalah bagian dari keamanan.
- **Fase 7 (Otomasi):** Skrip untuk membuat jaringan.
- **Fase 8 (Expert):** VXLAN, Open vSwitch, SR-IOV.

---

## 8. Referensi Lengkap

- libvirt Network XML — https://libvirt.org/formatnetwork.html
- virsh net-define — https://libvirt.org/manpages/virsh.html#net-define
- virsh net-start — https://libvirt.org/manpages/virsh.html#net-start
- virsh net-autostart — https://libvirt.org/manpages/virsh.html#net-autostart
- virsh net-destroy — https://libvirt.org/manpages/virsh.html#net-destroy
- virsh net-undefine — https://libvirt.org/manpages/virsh.html#net-undefine
- virsh net-list — https://libvirt.org/manpages/virsh.html#net-list
- virsh net-info — https://libvirt.org/manpages/virsh.html#net-info
- virsh net-dumpxml — https://libvirt.org/manpages/virsh.html#net-dumpxml
- virsh net-edit — https://libvirt.org/manpages/virsh.html#net-edit
- virsh net-dhcp-leases — https://libvirt.org/manpages/virsh.html#net-dhcp-leases
- virsh domiflist — https://libvirt.org/manpages/virsh.html#domiflist
- virsh domifaddr — https://libvirt.org/manpages/virsh.html#domifaddr
- Arch Wiki: libvirt — https://wiki.archlinux.org/title/Libvirt
- Arch Wiki: QEMU — https://wiki.archlinux.org/title/QEMU
- Arch Wiki: nftables — https://wiki.archlinux.org/title/nftables
- dnsmasq — https://thekelleys.org.uk/dnsmasq/doc.html
- nftables — https://wiki.nftables.org/
- Linux Bridge — https://wiki.linuxfoundation.org/networking/bridge

---

## 9. Tips & Praktik Terbaik

1. **Gunakan isolated untuk lab malware.**
2. **Gunakan NAT untuk VM yang butuh internet.**
3. **Gunakan routed untuk topologi kompleks.**
4. **Selalu `net-autostart` untuk jaringan yang diperlukan.**
5. **Gunakan `net-dumpxml` untuk audit.**
6. **Gunakan `net-edit` untuk perubahan.**
7. **Gunakan `net-dhcp-leases` untuk melacak IP.**
8. **Gunakan reservasi DHCP untuk VM yang perlu IP statik.**
9. **Gunakan DNS lokal untuk nama yang mudah diingat.**
10. **Aktifkan `ip_forward` untuk routed.**
11. **Cek aturan nftables/iptables untuk NAT.**
12. **Gunakan `virt-install --network` untuk koneksi.**
13. **Gunakan `model type='virtio'` untuk performa.**
14. **Batasi akses antar VM dengan nwfilter.**
15. **Jangan gunakan isolated jika butuh internet.**
16. **Dokumentasikan topologi jaringan.**
17. **Backup XML jaringan.**
18. **Gunakan `net-destroy` dengan hati-hati.**
19. **Hapus jaringan yang tidak digunakan.**
20. **Uji konektivitas dengan `ping` dan `nc`.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| VM tidak dapat IP | DHCP tidak berjalan. | Cek `net-start`, cek dnsmasq. |
| VM tidak bisa internet | NAT tidak aktif. | Cek `forward mode='nat'`, cek nftables. |
| VM tidak bisa ping host | Host tidak punya IP di bridge. | Tambahkan `<ip>` di XML. |
| VM tidak bisa ping VM lain | Bridge tidak terhubung. | Cek `domiflist`, cek bridge. |
| Routed tidak berfungsi | `ip_forward` off. | `sysctl net.ipv4.ip_forward=1`. |
| Routed tidak ada rute balik | Guest tidak punya rute. | Tambahkan rute statik di guest. |
| NAT tidak bisa diakses dari luar | Memang tidak bisa. | Gunakan routed atau port forward. |
| `net-define` gagal | XML tidak valid. | `virt-xml-validate`. |
| `net-start` gagal | Bridge sudah ada. | Cek `ip link`. |
| `net-destroy` gagal | VM masih terhubung. | Matikan VM dulu. |
| `net-undefine` gagal | Jaringan masih aktif. | `net-destroy` dulu. |
| DNS tidak resolve | dnsmasq tidak jalan. | Cek `net-start`. |
| IPv6 tidak jalan | Tidak dikonfigurasi. | Tambahkan `<ip family='ipv6'>`. |
| Interface tidak muncul | VM tidak jalan. | Start VM. |
| MAC spoofing | nwfilter tidak aktif. | Aktifkan `clean-traffic`. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virsh net-list --all` menampilkan isolated, NAT, routed.
- `virsh net-dumpxml isolated` menampilkan XML yang benar.
- VM terhubung ke isolated mendapat IP.
- VM di isolated bisa ping VM lain di isolated.
- VM di isolated tidak bisa ping 8.8.8.8.
- VM di NAT bisa ping 8.8.8.8.
- VM di routed bisa ping jaringan lain (dengan routing).
- `virsh net-dhcp-leases isolated` menampilkan lease.
- `virsh domiflist vm1` menampilkan interface.
- `virsh domifaddr vm1` menampilkan IP.
- `sudo nft list ruleset` menampilkan aturan NAT.
- `sysctl net.ipv4.ip_forward` = 1 untuk routed.

**Troubleshooting:**
- Jika VM tidak dapat IP: cek `virsh net-dhcp-leases`, cek `dnsmasq` process, cek `journalctl -u virtnetworkd`.
- Jika VM tidak bisa internet: cek `forward mode`, cek `nft list ruleset`, cek `ip_forward`.
- Jika VM tidak bisa ping host: cek IP host di bridge (`ip addr show virbr1`).
- Jika VM tidak bisa ping VM lain: cek `bridge link`, cek `ebtables`/`nftables`.
- Jika routed gagal: cek rute di host (`ip route`), cek rute di guest (`ip route`).
- Untuk debugging: `tcpdump -i virbr1`, `tcpdump -i vnet0`.
- Untuk log: `journalctl -u virtnetworkd`, `/var/log/libvirt/`.

---

## 12. Latihan Mandiri

1. Buat jaringan isolated `lab-isolated` dengan bridge `virbr10`, IP `10.10.10.1/24`.
2. Buat jaringan NAT `lab-nat` dengan bridge `virbr20`, IP `10.20.20.1/24`.
3. Buat jaringan routed `lab-routed` dengan bridge `virbr30`, IP `10.30.30.1/24`.
4. Hubungkan VM1 ke `lab-isolated`.
5. Hubungkan VM2 ke `lab-isolated`.
6. Verifikasi VM1 dan VM2 bisa saling ping.
7. Verifikasi VM1 tidak bisa ping 8.8.8.8.
8. Hubungkan VM3 ke `lab-nat`.
9. Verifikasi VM3 bisa ping 8.8.8.8.
10. Hubungkan VM4 ke `lab-routed`.
11. Aktifkan `ip_forward`.
12. Tambahkan rute statik di VM4.
13. Verifikasi VM4 bisa ping VM3? (Jika tidak ada routing antar jaringan, tidak bisa. Buat routing jika perlu.)
14. Lihat lease DHCP: `virsh net-dhcp-leases lab-isolated`.
15. Tambahkan reservasi DHCP untuk VM1.
16. Tambahkan DNS lokal `vm1.lab`.
17. Lihat aturan nftables: `sudo nft list ruleset`.
18. Hapus jaringan `lab-isolated`.
19. Tulis ringkasan: kapan isolated, NAT, routed.

---

## 13. Penutup Modul 5.1

Anda kini memahami **Network Isolated, NAT, dan Routed** — fondasi jaringan virtual libvirt. Anda bisa membuat, mengelola, dan men-debug ketiga mode tersebut. Anda memahami peran bridge, dnsmasq, nftables, dan interface virtual. Ini adalah fondasi untuk Modul 5.2 (Bridge vs Macvtap), 5.3 (Topologi Multi-Segmen), 5.4 (nwfilter + nftables), dan 5.5 (Debug Jaringan).

---

*Motivasi: Jaringan adalah ruang tempat data hidup. Isolasi adalah dinding. NAT adalah pintu. Routing adalah jalan. Kuasai ketiganya, dan Anda menguasai ruang virtual.*

---

> *“Jaringan adalah jembatan. Pilih jembatan yang tepat, dan VM Anda akan terhubung tanpa kehilangan kendali.”*

---

# Modul 5.2 — Bridge vs Macvtap

## Mini-Daftar Isi Modul 5.2

1. Deskripsi Konkret & Peran dalam Kurikulum  
2. Konsep Kunci & Filosofi Mendalam  
3. Terminologi Esensial  
4. Sintaks Dasar & Contoh Implementasi Inti  
5. Diagram Arsitektur Bridge & Macvtap  
6. Audit Kurikulum: Tambahan untuk Modul 5.2  
7. Hubungan dengan Modul Lain  
8. Referensi Lengkap  
9. Tips & Praktik Terbaik  
10. Potensi Kesalahan Umum & Solusi  
11. Validasi & Troubleshooting  
12. Latihan Mandiri  
13. Penutup Modul 5.2  

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Bridge** dan **Macvtap** adalah dua mekanisme untuk menghubungkan VM ke **jaringan fisik** (LAN) atau ke jaringan host. Keduanya memungkinkan VM mendapatkan IP dari DHCP server di LAN, berkomunikasi dengan perangkat lain di LAN, dan terlihat sebagai host tersendiri di jaringan.

- **Bridge**: Membuat switch virtual di kernel. Interface fisik (mis. `enp1s0`) dijadikan *slave* dari bridge (`br0`). Host dan VM sama-sama terhubung ke bridge. VM mendapat IP dari LAN, host tetap memiliki IP di bridge. Komunikasi host–VM dan VM–VM berjalan lancar.
- **Macvtap**: Menggunakan driver `macvlan` untuk membuat interface virtual (`macvtap0`) di atas interface fisik. VM terhubung ke interface ini. VM mendapat IP dari LAN, tetapi **host tidak dapat berkomunikasi dengan VM** melalui interface fisik tersebut (kecuali ada konfigurasi tambahan). Macvtap memiliki beberapa mode: `bridge`, `private`, `vepa`, `passthrough`.

**Peran dalam kurikulum:** Modul ini adalah **jembatan antara jaringan virtual libvirt (5.1) dan jaringan fisik**. Setelah Anda memahami isolated, NAT, dan routed (5.1), Anda perlu tahu cara menghubungkan VM ke LAN nyata. Bridge adalah cara paling umum dan fleksibel. Macvtap adalah alternatif untuk performa atau situasi di mana bridge tidak memungkinkan (mis. interface wireless). Modul ini juga fondasi untuk topologi multi-segmen (5.3), nwfilter (5.4), dan debug (5.5).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Bridge = Switch Virtual

Bridge adalah perangkat Layer 2 yang meneruskan frame berdasarkan MAC address. Di Linux, bridge dibuat dengan `ip link add type bridge`. Interface fisik dan interface VM (`vnetX`) di-attach ke bridge. Host juga bisa memiliki IP di bridge. Semua anggota bridge berada dalam **satu broadcast domain**.

**Filosofi:** *Bridge adalah switch. Switch adalah jantung jaringan. Host dan VM setara di dalam switch.*

### 2.2. Macvtap = Macvlan + Tap

Macvtap menggabungkan `macvlan` (memungkinkan banyak MAC address pada satu interface fisik) dan `tap` (interface virtual untuk VM). Setiap VM memiliki `macvtapX` sendiri. VM terhubung langsung ke interface fisik melalui macvtap. Namun, karena interface fisik dipegang oleh macvtap, **host tidak bisa lagi menggunakan interface fisik itu untuk berkomunikasi dengan VM**. Host bisa menggunakan interface lain, atau membuat macvlan di atas interface fisik untuk dirinya sendiri.

**Filosofi:** *Macvtap adalah jalan pintas. Cepat, tetapi mengorbankan komunikasi host–guest.*

### 2.3. Mode Macvtap

- **Bridge**: VM dapat berkomunikasi dengan dunia luar, tetapi tidak dengan host (kecuali host memiliki macvlan). VM–VM dalam host yang sama juga tidak bisa berkomunikasi langsung (tergantung switch fisik).
- **Private**: VM tidak dapat berkomunikasi dengan VM lain di host yang sama, bahkan melalui switch fisik.
- **VEPA (Virtual Ethernet Port Aggregator)**: Semua traffic keluar ke switch fisik; switch harus mendukung hairpin untuk komunikasi VM–VM.
- **Passthrough**: VM menggunakan VF (Virtual Function) dari SR-IOV secara langsung. Performa maksimal, tetapi tidak ada fitur macvtap lainnya.

**Filosofi:** *Mode menentukan isolasi dan kemampuan komunikasi. Pilih sesuai kebutuhan.*

### 2.4. Kapan Menggunakan Bridge?

- Anda ingin host dan VM saling berkomunikasi.
- Anda ingin VM terlihat sebagai host di LAN.
- Anda memiliki interface fisik yang bisa dijadikan slave (bukan wireless).
- Anda ingin konfigurasi yang sederhana dan didukung luas.

### 2.5. Kapan Menggunakan Macvtap?

- Anda tidak bisa membuat bridge (mis. interface wireless).
- Anda menginginkan performa lebih tinggi (tanpa overhead bridge).
- Anda tidak perlu komunikasi host–VM.
- Anda ingin isolasi antar VM dengan mode `private` atau `vepa`.

**Filosofi:** *Bridge untuk fleksibilitas. Macvtap untuk performa dan keterbatasan.*

### 2.6. Filosofi Keseluruhan

- **Bridge adalah standar.** Dukungan luas, komunikasi penuh.
- **Macvtap adalah alternatif.** Cepat, tetapi batasan host–guest.
- **Pilih sesuai kebutuhan.** Tidak ada solusi terbaik untuk semua.
- **Uji konektivitas.** Pastikan VM bisa ping gateway, host, dan internet.
- **Dokumentasikan.** Topologi jaringan harus jelas.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Bridge** | Switch virtual Layer 2. | `br0` |
| **Slave** | Interface yang di-attach ke bridge. | `enp1s0` |
| **vnetX** | Interface virtual VM di host. | `vnet0` |
| **Macvtap** | Driver yang menggabungkan macvlan dan tap. | `macvtap0` |
| **Macvlan** | Driver yang memungkinkan banyak MAC pada satu interface. | |
| **Tap** | Interface virtual untuk VM. | `/dev/tapX` |
| **Mode bridge** | Macvtap mode default. | |
| **Mode private** | Isolasi antar VM. | |
| **Mode vepa** | Hairpin di switch fisik. | |
| **Mode passthrough** | SR-IOV VF langsung. | |
| **`ip link add type bridge`** | Membuat bridge. | |
| **`ip link set master`** | Menjadikan interface sebagai slave. | |
| **`nmcli con add type bridge`** | Membuat bridge via NetworkManager. | |
| **`systemd-networkd`** | Network manager systemd. | |
| **`virsh net-define`** | Definisikan jaringan libvirt. | |
| **`<forward mode='bridge'/>`** | Mode bridge di libvirt. | |
| **`<interface type='bridge'>`** | Interface VM ke bridge. | |
| **`<interface type='direct'>`** | Interface VM ke macvtap. | |
| **`<source dev='enp1s0' mode='bridge'/>`** | Macvtap mode bridge. | |
| **`<virtualport>`** | Konfigurasi 802.1Qbg/802.1Qbh. | |
| **STP** | Spanning Tree Protocol. | |
| **Hairpin** | Mode switch untuk mengirim kembali paket. | |
| **Promiscuous mode** | Mode menerima semua paket. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Membuat Bridge dengan `iproute2`

```bash
sudo ip link add name br0 type bridge
sudo ip link set br0 up
sudo ip link set enp1s0 master br0
sudo ip addr add 192.168.1.10/24 dev br0
sudo ip route add default via 192.168.1.1
```

**Penjelasan kata demi kata:**
- `ip link add name br0 type bridge`: buat interface bridge bernama `br0`.
- `ip link set br0 up`: aktifkan bridge.
- `ip link set enp1s0 master br0`: jadikan `enp1s0` sebagai slave `br0`.
- `ip addr add 192.168.1.10/24 dev br0`: beri IP host di bridge.
- `ip route add default via 192.168.1.1`: tambahkan default route.

**Catatan:** Konfigurasi ini tidak persisten. Untuk persisten, gunakan NetworkManager atau systemd-networkd.

### 4.2. Membuat Bridge dengan `nmcli`

```bash
nmcli con add type bridge ifname br0 con-name br0
nmcli con add type bridge-slave ifname enp1s0 master br0
nmcli con modify br0 ipv4.addresses 192.168.1.10/24
nmcli con modify br0 ipv4.gateway 192.168.1.1
nmcli con modify br0 ipv4.method manual
nmcli con up br0
```

**Penjelasan:**
- `nmcli con add type bridge`: buat koneksi bridge.
- `bridge-slave`: tambahkan interface fisik sebagai slave.
- `ipv4.addresses`: set IP.
- `ipv4.gateway`: set gateway.
- `ipv4.method manual`: konfigurasi manual.
- `nmcli con up br0`: aktifkan.

**Alternatif:** Gunakan `nmtui` untuk TUI.

### 4.3. Membuat Bridge dengan `systemd-networkd`

**File `/etc/systemd/network/br0.netdev`:**
```ini
[NetDev]
Name=br0
Kind=bridge
```

**File `/etc/systemd/network/br0.network`:**
```ini
[Match]
Name=br0

[Network]
Address=192.168.1.10/24
Gateway=192.168.1.1
DNS=192.168.1.1
```

**File `/etc/systemd/network/enp1s0.network`:**
```ini
[Match]
Name=enp1s0

[Network]
Bridge=br0
```

**Aktifkan:**
```bash
sudo systemctl enable --now systemd-networkd
sudo networkctl status br0
```

**Penjelasan:**
- `.netdev`: definisi bridge.
- `.network`: konfigurasi IP.
- `Bridge=br0`: jadikan slave.

### 4.4. Mendefinisikan Jaringan Bridge di libvirt

**File `host-bridge.xml`:**
```xml
<network>
  <name>host-bridge</name>
  <forward mode='bridge'/>
  <bridge name='br0'/>
</network>
```

**Perintah:**
```bash
virsh net-define host-bridge.xml
virsh net-start host-bridge
virsh net-autostart host-bridge
```

**Penjelasan:**
- `<forward mode='bridge'/>`: mode bridge.
- `<bridge name='br0'/>`: gunakan bridge yang sudah ada.

### 4.5. Menghubungkan VM ke Bridge

**Di `virt-install`:**
```bash
virt-install \
  --name vm-bridge \
  --memory 1024 \
  --vcpus 1 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --network network=host-bridge \
  --graphics none \
  --console pty,target_type=serial
```

**Di XML domain:**
```xml
<interface type='bridge'>
  <source bridge='br0'/>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `<interface type='bridge'>`: interface ke bridge.
- `<source bridge='br0'/>`: nama bridge.
- `<model type='virtio'/>`: driver virtio.

### 4.6. Menghubungkan VM ke Macvtap

**Di XML domain:**
```xml
<interface type='direct'>
  <source dev='enp1s0' mode='bridge'/>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `<interface type='direct'>`: interface macvtap.
- `<source dev='enp1s0' mode='bridge'/>`: interface fisik dan mode.
- `mode` bisa `bridge`, `private`, `vepa`, `passthrough`.

**Di `virt-install`:**
```bash
virt-install \
  --name vm-macvtap \
  --memory 1024 \
  --vcpus 1 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --network type=direct,source=enp1s0,source_mode=bridge,model=virtio \
  --graphics none \
  --console pty,target_type=serial
```

**Penjelasan:**
- `type=direct`: macvtap.
- `source=enp1s0`: interface fisik.
- `source_mode=bridge`: mode bridge.
- `model=virtio`: driver.

### 4.7. Membuat Macvtap Manual

```bash
sudo ip link add link enp1s0 name macvtap0 type macvtap mode bridge
sudo ip link set macvtap0 up
sudo ip addr add 192.168.1.20/24 dev macvtap0
```

**Penjelasan:**
- `ip link add link enp1s0 name macvtap0 type macvtap mode bridge`: buat macvtap di atas `enp1s0` dengan mode bridge.
- `ip link set macvtap0 up`: aktifkan.
- `ip addr add`: beri IP.

**Catatan:** Untuk VM, libvirt yang membuat macvtap. Manual hanya untuk testing.

### 4.8. Mode Macvtap di XML

```xml
<interface type='direct'>
  <source dev='enp1s0' mode='private'/>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `mode='private'`: isolasi antar VM.
- `mode='vepa'`: hairpin di switch.
- `mode='passthrough'`: SR-IOV VF.

### 4.9. Melihat Interface dan Bridge

```bash
ip link show
bridge link show
brctl show
virsh domiflist vm-bridge
```

**Penjelasan:**
- `ip link show`: lihat semua interface.
- `bridge link show`: lihat slave bridge.
- `brctl show`: lihat bridge (jika `bridge-utils` terinstal).
- `virsh domiflist`: lihat interface VM.

### 4.10. Menghapus Bridge

```bash
sudo ip link set enp1s0 nomaster
sudo ip link delete br0 type bridge
```

**Penjelasan:**
- `nomaster`: lepaskan slave.
- `delete`: hapus bridge.

### 4.11. Menghapus Macvtap

```bash
sudo ip link delete macvtap0
```

**Penjelasan:**
- Hapus interface macvtap.

### 4.12. Konfigurasi VLAN di Bridge

```bash
sudo ip link add link enp1s0 name enp1s0.10 type vlan id 10
sudo ip link set enp1s0.10 master br0
```

**Penjelasan:**
- Buat VLAN interface.
- Jadikan slave bridge.

**Di XML:**
```xml
<interface type='bridge'>
  <source bridge='br0'/>
  <vlan>
    <tag id='10'/>
  </vlan>
  <model type='virtio'/>
</interface>
```

**Penjelasan:**
- `<vlan><tag id='10'/></vlan>`: tag VLAN.

---

## 5. Diagram Arsitektur Bridge & Macvtap

### 5.1. Bridge

```
+-------------------+
|      Host         |
|   IP 192.168.1.10 |
+-------------------+
          |
          | br0
          |
+-------------------+
|   Bridge br0      |
+-------------------+
     |         |
     |         |
+---------+ +---------+
| enp1s0  | | vnet0   |
| (slave) | | (VM1)   |
+---------+ +---------+
     |
     |
+-------------------+
|   LAN Fisik       |
+-------------------+
```

### 5.2. Macvtap

```
+-------------------+
|      Host         |
|   (tidak bisa     |
|    komunikasi     |
|    dengan VM)     |
+-------------------+
          |
          | enp1s0
          |
+-------------------+
|   macvtap0        |
+-------------------+
          |
          | tap
          |
+-------------------+
|   VM1             |
+-------------------+
          |
          |
+-------------------+
|   LAN Fisik       |
+-------------------+
```

### 5.3. Perbandingan

```
+-------------------+  +-------------------+
|      Bridge       |  |     Macvtap       |
+-------------------+  +-------------------+
| Switch virtual    |  | Macvlan + tap     |
| Host <-> VM       |  | Host tidak <-> VM |
| VM <-> VM         |  | VM <-> VM (mode)  |
| Konfigurasi mudah |  | Konfigurasi sedang|
| Dukungan luas     |  | Performa tinggi   |
| Wireless: tidak   |  | Wireless: tidak   |
+-------------------+  +-------------------+
```

### 5.4. Alur Paket Bridge

```
VM1 (vnet0) -> br0 -> enp1s0 -> LAN
Host (br0)  -> br0 -> enp1s0 -> LAN
```

### 5.5. Alur Paket Macvtap

```
VM1 (macvtap0) -> enp1s0 -> LAN
Host tidak bisa lewat enp1s0
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 5.2

Kurikulum asli hanya menyebut:
```bash
ip link add br0 type bridge
ip link set enp1s0 master br0
```

Kita akan menambahkan:

1. **Bridge dengan `nmcli`** — NetworkManager.
2. **Bridge dengan `systemd-networkd`** — konfigurasi file.
3. **Bridge dengan `iproute2`** — manual.
4. **Libvirt bridge network XML** — `<forward mode='bridge'/>`.
5. **Interface VM ke bridge** — `<interface type='bridge'>`.
6. **Interface VM ke macvtap** — `<interface type='direct'>`.
7. **Mode macvtap** — `bridge`, `private`, `vepa`, `passthrough`.
8. **Perbandingan bridge vs macvtap** — tabel.
9. **Keterbatasan macvtap** — host tidak bisa komunikasi.
10. **Workaround macvtap** — macvlan di host.
11. **VLAN di bridge** — `<vlan>`.
12. **STP** — `stp='on'`.
13. **Hairpin** — mode vepa.
14. **Promiscuous mode** — untuk bridge.
15. **Debug** — `bridge link`, `ip link`, `tcpdump`.
16. **Keamanan** — isolasi, anti-spoof.
17. **Wireless limitation** — tidak bisa bridge.
18. **Performance** — perbandingan throughput.
19. **SR-IOV** — passthrough.
20. **Dokumentasi** — topologi.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 5.2.

---

## 7. Hubungan dengan Modul Lain

- **Modul 5.1 (Isolated/NAT/Routed):** Bridge adalah fondasi isolated/NAT/routed. Macvtap adalah alternatif.
- **Modul 5.3 (Topologi Multi-Segmen):** Bridge dan macvtap digunakan untuk menghubungkan segmen.
- **Modul 5.4 (nwfilter + nftables):** nwfilter diterapkan pada interface VM, termasuk bridge dan macvtap.
- **Modul 5.5 (Debug):** Debug bridge dan macvtap dengan `bridge link`, `tcpdump`.
- **Fase 6 (Keamanan):** Isolasi jaringan, anti-spoof, macvtap private.
- **Fase 7 (Otomasi):** Skrip untuk membuat bridge.
- **Fase 8 (Expert):** SR-IOV, VFIO, Open vSwitch.

---

## 8. Referensi Lengkap

- libvirt Network XML — https://libvirt.org/formatnetwork.html
- libvirt Domain XML interface — https://libvirt.org/formatdomain.html#network-interfaces
- Arch Wiki: Network bridge — https://wiki.archlinux.org/title/Network_bridge
- Arch Wiki: Macvlan — https://wiki.archlinux.org/title/Macvlan
- Arch Wiki: systemd-networkd — https://wiki.archlinux.org/title/Systemd-networkd
- Arch Wiki: NetworkManager — https://wiki.archlinux.org/title/NetworkManager
- Kernel Docs: Bridge — https://www.kernel.org/doc/html/latest/networking/bridge.html
- Kernel Docs: Macvlan — https://www.kernel.org/doc/html/latest/networking/mac80211-injection.html
- iproute2 — https://wiki.linuxfoundation.org/networking/iproute2
- nmcli — https://networkmanager.dev/docs/api/latest/nmcli.html
- systemd.netdev — https://www.freedesktop.org/software/systemd/man/systemd.netdev.html
- systemd.network — https://www.freedesktop.org/software/systemd/man/systemd.network.html
- libvirt macvtap — https://libvirt.org/formatdomain.html#direct-attachment-to-physical-interface

---

## 9. Tips & Praktik Terbaik

1. **Gunakan bridge untuk komunikasi host–VM.**
2. **Gunakan macvtap untuk performa.**
3. **Jangan gunakan macvtap jika butuh host–VM.**
4. **Gunakan `nmcli` untuk konfigurasi persisten.**
5. **Gunakan `systemd-networkd` untuk server.**
6. **Gunakan `iproute2` untuk testing.**
7. **Aktifkan STP hanya jika perlu.**
8. **Gunakan VLAN untuk segmentasi.**
9. **Gunakan mode `private` untuk isolasi VM.**
10. **Gunakan mode `vepa` hanya jika switch mendukung.**
11. **Gunakan `passthrough` untuk SR-IOV.**
12. **Uji konektivitas dengan `ping` dan `tcpdump`.**
13. **Dokumentasikan topologi.**
14. **Backup konfigurasi jaringan.**
15. **Hindari bridge di wireless.**
16. **Gunakan virtio untuk performa.**
17. **Monitor dengan `bridge link`.**
18. **Gunakan `virsh domiflist` untuk audit.**
19. **Jangan lupa `net-autostart`.**
20. **Latih troubleshooting.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Bridge tidak dibuat | Tidak ada izin. | Gunakan sudo. |
| Interface fisik hilang | Di-slave ke bridge. | Normal, IP pindah ke bridge. |
| Host tidak bisa ping VM | Bridge tidak punya IP. | Tambahkan IP ke bridge. |
| VM tidak dapat IP | DHCP tidak jalan. | Cek LAN, cek bridge. |
| Macvtap host tidak bisa ping VM | Memang batasan. | Gunakan bridge. |
| Macvtap VM tidak dapat IP | Mode salah. | Cek mode. |
| Wireless tidak bisa bridge | Driver tidak mendukung. | Gunakan macvtap. |
| VLAN tidak jalan | Tag tidak cocok. | Cek `vlan` di XML. |
| `nmcli` gagal | NetworkManager tidak jalan. | Start NM. |
| `systemd-networkd` gagal | File salah. | Cek `networkctl status`. |
| `virsh net-define` gagal | XML tidak valid. | `virt-xml-validate`. |
| VM tidak bisa internet | Gateway salah. | Cek route. |
| STP loop | Bridge loop. | Aktifkan STP. |
| Performa rendah | Emulasi. | Gunakan virtio. |
| MAC spoofing | nwfilter tidak aktif. | Aktifkan `clean-traffic`. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `ip link show br0` menampilkan bridge.
- `bridge link show` menampilkan slave.
- `virsh net-list --all` menampilkan `host-bridge`.
- VM terhubung ke bridge mendapat IP dari LAN.
- Host bisa ping VM.
- VM bisa ping host.
- VM bisa ping gateway.
- VM bisa ping internet.
- Macvtap VM mendapat IP dari LAN.
- Host tidak bisa ping VM macvtap (kecuali workaround).
- `virsh domiflist` menampilkan interface.
- `tcpdump -i br0` menangkap paket.
- `tcpdump -i macvtap0` menangkap paket.

**Troubleshooting:**
- Jika bridge tidak muncul: cek `ip link`, cek modul `bridge`.
- Jika slave tidak terattach: cek `bridge link`.
- Jika host tidak bisa ping VM: cek IP bridge, cek firewall.
- Jika VM tidak dapat IP: cek DHCP, cek `tcpdump -i br0 port 67 or 68`.
- Jika macvtap tidak jalan: cek mode, cek driver.
- Jika wireless: gunakan macvtap atau USB Ethernet.
- Untuk debugging: `journalctl -u systemd-networkd`, `journalctl -u NetworkManager`, `dmesg | grep bridge`.
- Untuk audit: `virsh domiflist`, `virsh net-dumpxml`.

---

## 12. Latihan Mandiri

1. Buat bridge `br0` dengan `iproute2`.
2. Pindahkan IP host ke `br0`.
3. Hubungkan VM ke `br0` via libvirt.
4. Verifikasi VM mendapat IP dari LAN.
5. Verifikasi host bisa ping VM.
6. Verifikasi VM bisa ping host.
7. Verifikasi VM bisa ping internet.
8. Hapus bridge.
9. Buat bridge dengan `nmcli`.
10. Buat bridge dengan `systemd-networkd`.
11. Buat macvtap dengan mode `bridge`.
12. Hubungkan VM ke macvtap.
13. Verifikasi VM mendapat IP.
14. Verifikasi host tidak bisa ping VM.
15. Buat macvtap mode `private`.
16. Verifikasi VM tidak bisa ping VM lain.
17. Buat VLAN di bridge.
18. Verifikasi VLAN berfungsi.
19. Buat skrip untuk membuat bridge.
20. Tulis ringkasan: kapan bridge, kapan macvtap.

---

## 13. Penutup Modul 5.2

Anda kini menguasai **Bridge vs Macvtap** — dua cara menghubungkan VM ke jaringan fisik. Anda bisa membuat bridge dengan `iproute2`, `nmcli`, atau `systemd-networkd`; menghubungkan VM ke bridge atau macvtap; memahami mode macvtap; serta men-debug dan memvalidasi konektivitas. Ini adalah fondasi untuk Modul 5.3 (Topologi Multi-Segmen), 5.4 (nwfilter + nftables), dan 5.5 (Debug Jaringan).

---

*Motivasi: Bridge adalah jembatan yang menghubungkan dua dunia. Macvtap adalah terowongan cepat. Pilih dengan bijak, dan VM Anda akan terhubung tanpa batas.*

---

> *“Topologi adalah peta perang. Tanpa router dan firewall, segmen hanyalah pulau yang terputus.”*

---

# Modul 5.3 — Topologi Multi-Segmen dengan VM Router/Firewall

## Mini-Daftar Isi Modul 5.3

1. Deskripsi Konkret & Peran dalam Kurikulum  
2. Konsep Kunci & Filosofi Mendalam  
3. Terminologi Esensial  
4. Sintaks Dasar & Contoh Implementasi Inti  
5. Diagram Arsitektur Topologi Multi-Segmen  
6. Audit Kurikulum: Tambahan untuk Modul 5.3  
7. Hubungan dengan Modul Lain  
8. Referensi Lengkap  
9. Tips & Praktik Terbaik  
10. Potensi Kesalahan Umum & Solusi  
11. Validasi & Troubleshooting  
12. Latihan Mandiri  
13. Penutup Modul 5.3  

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Topologi Multi-Segmen** adalah rancangan jaringan yang membagi VM ke dalam beberapa **segmen terisolasi** (misalnya DMZ, LAN, dan isolated), lalu menghubungkannya melalui sebuah **VM Router/Firewall**. VM Router berfungsi sebagai:
- **Router**: meneruskan paket antar segmen.
- **Firewall**: membatasi lalu lintas berdasarkan aturan (nftables).
- **NAT Gateway**: (opsional) memberikan akses internet ke segmen tertentu.
- **DHCP Relay**: (opsional) meneruskan permintaan DHCP antar segmen.

Dengan topologi ini, Anda dapat mensimulasikan arsitektur jaringan perusahaan: DMZ untuk layanan publik, LAN untuk internal, dan isolated untuk laboratorium tertutup. Setiap segmen memiliki tingkat kepercayaan dan aturan yang berbeda.

**Peran dalam kurikulum:** Modul ini adalah **puncak Fase 5**. Setelah memahami isolated/NAT/routed (5.1) dan bridge/macvtap (5.2), Anda kini menggabungkan semuanya menjadi satu kesatuan yang utuh. Modul ini melatih kemampuan desain, implementasi, dan validasi jaringan kompleks. Ini juga fondasi untuk:
- **Modul 5.4 (nwfilter + nftables)**: aturan firewall di VM router dan host.
- **Modul 5.5 (Debug)**: melacak paket antar segmen.
- **Fase 6 (Keamanan)**: segmentasi sebagai kontrol keamanan.
- **Fase 7 (Otomasi)**: provisioning topologi dengan skrip.
- **Fase 8 (Expert)**: VXLAN, Open vSwitch, SDN.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Segmentasi = Kontrol

Dengan memecah jaringan menjadi segmen-segmen kecil, Anda membatasi **blast radius** jika terjadi kompromi. DMZ boleh diakses dari luar, tetapi tidak boleh mengakses LAN. LAN boleh mengakses internet, tetapi tidak boleh diakses dari DMZ. Isolated sama sekali tidak boleh keluar.

**Filosofi:** *Segmentasi adalah tembok api. Tanpa tembok, api menyebar.*

### 2.2. VM Router = Otak Topologi

VM Router adalah VM biasa yang memiliki **beberapa interface**, masing-masing terhubung ke segmen berbeda. Di dalam VM Router, Anda mengaktifkan `ip_forward`, menambahkan rute statik, dan menulis aturan nftables. VM Router menjadi **single point of failure**, tetapi juga **single point of control**.

**Filosofi:** *Router adalah pusat kendali. Di dalamnya, semua aturan ditentukan.*

### 2.3. DMZ: Zona Demiliterisasi

DMZ adalah segmen yang **terekspos ke jaringan tidak tepercaya** (misalnya internet). Layanan yang ditempatkan di DMZ harus dianggap **rentan**. DMZ tidak boleh memiliki akses langsung ke LAN.

**Filosofi:** *DMZ adalah benteng terdepan. Jika jatuh, LAN tetap aman.*

### 2.4. LAN: Zona Internal

LAN adalah segmen **tepercaya** untuk VM internal. LAN boleh mengakses internet melalui NAT, tetapi tidak boleh diakses dari DMZ atau isolated.

**Filosofi:** *LAN adalah rumah. Lindungi dari tamu tak diundang.*

### 2.5. Isolated: Zona Karantina

Isolated adalah segmen **tertutup total**. Tidak ada akses ke internet, tidak ada akses ke LAN, tidak ada akses ke DMZ. Hanya VM di dalamnya yang bisa saling berkomunikasi.

**Filosofi:** *Isolated adalah ruang hampa. Tidak ada yang masuk, tidak ada yang keluar.*

### 2.6. Routing Statik vs Dinamis

- **Routing statik**: rute ditulis manual. Sederhana, deterministik, cocok untuk topologi kecil.
- **Routing dinamis**: menggunakan protokol seperti OSPF, BGP. Kompleks, tetapi skalabel.

Untuk lab ini, kita gunakan **routing statik**.

**Filosofi:** *Rute statik adalah peta yang digambar tangan. Akurat, tetapi butuh perawatan.*

### 2.7. NAT di VM Router

VM Router dapat melakukan **masquerade** untuk segmen LAN, sehingga VM di LAN bisa mengakses internet melalui IP DMZ atau IP host. NAT di VM Router berbeda dengan NAT di host (libvirt).

**Filosofi:** *NAT adalah penerjemah. Ia menyembunyikan alamat asli di balik satu alamat.*

### 2.8. Firewall di VM Router

VM Router menjalankan **nftables**. Aturan default: **drop**. Hanya lalu lintas yang diizinkan yang diteruskan. Ini adalah **default-deny egress** dan **default-deny ingress**.

**Filosofi:** *Firewall adalah hakim. Tanpa izin, tidak ada yang lewat.*

### 2.9. DHCP Relay

Jika VM di segmen tidak memiliki DHCP server sendiri, VM Router dapat menjadi **DHCP relay** yang meneruskan permintaan ke DHCP server di segmen lain.

**Filosofi:** *DHCP relay adalah kurir. Ia menyampaikan permintaan, bukan menjawabnya.*

### 2.10. VLAN: Segmentasi di Layer 2

VLAN (802.1Q) memungkinkan segmentasi **di dalam satu interface fisik**. Setiap VLAN adalah broadcast domain terpisah. VM Router dapat memiliki interface VLAN untuk setiap segmen.

**Filosofi:** *VLAN adalah partisi logis. Satu kabel, banyak jaringan.*

### 2.11. VXLAN: Overlay Network

VXLAN (Virtual Extensible LAN) adalah tunnel Layer 2 di atas Layer 3. Cocok untuk menghubungkan segmen yang tersebar di host berbeda.

**Filosofi:** *VXLAN adalah terowongan. Ia menembus batas fisik.*

### 2.12. Open vSwitch: Switch Programmable

Open vSwitch (OVS) adalah switch virtual yang mendukung **OpenFlow**. Memungkinkan kontrol terprogram atas aliran paket. Alternatif dari bridge Linux.

**Filosofi:** *OVS adalah switch yang bisa diprogram. Fleksibel, tetapi kompleks.*

### 2.13. Filosofi Keseluruhan

- **Segmentasi adalah kunci keamanan.**
- **VM Router adalah pusat kendali.**
- **DMZ, LAN, isolated memiliki peran berbeda.**
- **Routing statik untuk kesederhanaan.**
- **Firewall default-deny.**
- **VLAN dan VXLAN untuk skalabilitas.**
- **Validasi konektivitas wajib.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **DMZ** | Demilitarized Zone; segmen terekspos. | `dmz` |
| **LAN** | Local Area Network; segmen internal. | `lan` |
| **Isolated** | Segmen tertutup. | `isolated` |
| **VM Router** | VM yang merutekan antar segmen. | `router-vm` |
| **ip_forward** | Kernel IP forwarding. | `net.ipv4.ip_forward=1` |
| **Routing statik** | Rute manual. | `ip route add` |
| **NAT** | Network Address Translation. | `nft ... masquerade` |
| **Masquerade** | Source NAT. | |
| **Firewall** | Penjaga lalu lintas. | `nft` |
| **Default-deny** | Tolak semua, izinkan sebagian. | `policy drop` |
| **DHCP relay** | Penerus DHCP. | `dhcrelay` |
| **VLAN** | Virtual LAN. | `vlan10` |
| **802.1Q** | Standar VLAN. | |
| **VXLAN** | Virtual Extensible LAN. | `vxlan0` |
| **Open vSwitch** | Switch virtual programmable. | `ovs-vsctl` |
| **OpenFlow** | Protokol kontrol OVS. | |
| **Hairpin** | Mode switch untuk VM–VM. | |
| **Policy routing** | Routing berdasarkan aturan. | `ip rule` |
| **Conntrack** | Connection tracking. | `conntrack -L` |
| **nftables** | Firewall modern. | |
| **iptables** | Firewall lama. | |
| **dhcrelay** | DHCP relay daemon. | |
| **radvd** | Router Advertisement daemon. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Membuat Jaringan untuk Setiap Segmen

**DMZ:**
```xml
<network>
  <name>dmz</name>
  <bridge name='virbr10' stp='on' delay='0'/>
  <ip address='10.0.10.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.10.2' end='10.0.10.254'/>
    </dhcp>
  </ip>
</network>
```

**LAN:**
```xml
<network>
  <name>lan</name>
  <bridge name='virbr20' stp='on' delay='0'/>
  <ip address='10.0.20.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.20.2' end='10.0.20.254'/>
    </dhcp>
  </ip>
</network>
```

**Isolated:**
```xml
<network>
  <name>isolated</name>
  <bridge name='virbr30' stp='on' delay='0'/>
  <ip address='10.0.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.30.2' end='10.0.30.254'/>
    </dhcp>
  </ip>
</network>
```

**Perintah:**
```bash
virsh net-define dmz.xml
virsh net-define lan.xml
virsh net-define isolated.xml
virsh net-start dmz
virsh net-start lan
virsh net-start isolated
virsh net-autostart dmz
virsh net-autostart lan
virsh net-autostart isolated
```

**Penjelasan:**
- Setiap segmen adalah jaringan libvirt terpisah.
- Bridge berbeda: `virbr10`, `virbr20`, `virbr30`.
- Subnet berbeda: `10.0.10.0/24`, `10.0.20.0/24`, `10.0.30.0/24`.

### 4.2. Membuat VM Router dengan 3 Interface

```bash
virt-install \
  --name router-vm \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --network network=dmz,model=virtio \
  --network network=lan,model=virtio \
  --network network=isolated,model=virtio \
  --graphics none \
  --console pty,target_type=serial
```

**Penjelasan:**
- Tiga `--network` untuk tiga segmen.
- Interface akan muncul sebagai `ens3`, `ens4`, `ens5` (tergantung urutan).

### 4.3. Konfigurasi IP di VM Router

Di dalam VM Router:
```bash
# Interface ke DMZ
ip addr add 10.0.10.2/24 dev ens3
ip link set ens3 up

# Interface ke LAN
ip addr add 10.0.20.2/24 dev ens4
ip link set ens4 up

# Interface ke isolated
ip addr add 10.0.30.2/24 dev ens5
ip link set ens5 up
```

**Penjelasan:**
- Setiap interface mendapat IP di subnet masing-masing.
- VM Router menjadi gateway untuk setiap segmen.

### 4.4. Mengaktifkan IP Forward di VM Router

```bash
sysctl -w net.ipv4.ip_forward=1
```

**Permanent:**
```bash
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-ipforward.conf
sysctl --system
```

**Penjelasan:**
- Diperlukan agar VM Router meneruskan paket antar interface.

### 4.5. Menambahkan Rute Statik di VM Router

```bash
ip route add 10.0.20.0/24 dev ens4
ip route add 10.0.30.0/24 dev ens5
ip route add 10.0.10.0/24 dev ens3
```

**Penjelasan:**
- Rute ke setiap subnet.
- Sebenarnya sudah otomatis saat `ip addr add`, tetapi eksplisit lebih aman.

### 4.6. Menambahkan Rute di VM Klien

Di VM DMZ:
```bash
ip route add default via 10.0.10.2
```

Di VM LAN:
```bash
ip route add default via 10.0.20.2
```

Di VM Isolated:
```bash
ip route add default via 10.0.30.2
```

**Penjelasan:**
- Klien menggunakan VM Router sebagai gateway.
- Untuk isolated, default route tidak berguna jika tidak ada akses keluar, tetapi tetap diperlukan untuk komunikasi antar segmen (jika diizinkan).

### 4.7. Firewall nftables di VM Router

**File `/etc/nftables.conf`:**
```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain forward {
        type filter hook forward priority 0; policy drop;

        # Izinkan koneksi yang sudah established
        ct state established,related accept

        # Izinkan LAN ke internet (via DMZ)
        iifname "ens4" oifname "ens3" accept

        # Izinkan DMZ ke LAN? Tidak! Default drop.

        # Izinkan LAN ke isolated? Tidak! Default drop.

        # Izinkan isolated ke isolated? Ya, tetapi tidak lewat router.

        # Izinkan DMZ ke isolated? Tidak!

        # Log yang di-drop
        log prefix "nft-drop: " drop
    }

    chain input {
        type filter hook input priority 0; policy drop;

        iif lo accept
        ct state established,related accept
        ip protocol icmp accept
        tcp dport 22 accept

        # DHCP
        udp dport 67 accept
        udp dport 68 accept
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

**Aktifkan:**
```bash
nft -f /etc/nftables.conf
systemctl enable --now nftables
```

**Penjelasan:**
- `hook forward`: untuk paket yang diteruskan.
- `policy drop`: default tolak.
- `ct state established,related accept`: izinkan balasan.
- `iifname "ens4" oifname "ens3" accept`: LAN ke DMZ (internet).
- `log prefix`: log paket yang drop.
- `hook input`: untuk paket ke VM Router sendiri.
- `hook output`: izinkan semua keluar dari VM Router.

### 4.8. NAT di VM Router (Opsional)

Jika Anda ingin LAN bisa mengakses internet melalui DMZ:
```nft
table inet nat {
    chain postrouting {
        type nat hook postrouting priority 100; policy accept;
        oifname "ens3" masquerade
    }
}
```

**Penjelasan:**
- `oifname "ens3"`: keluar melalui interface DMZ.
- `masquerade`: source NAT.

### 4.9. DHCP Relay di VM Router (Opsional)

Jika Anda ingin VM di isolated mendapat IP dari DHCP server di LAN:
```bash
pacman -S dhcp
dhcrelay -i ens4 -i ens5 10.0.20.1
```

**Penjelasan:**
- `-i ens4`: interface LAN.
- `-i ens5`: interface isolated.
- `10.0.20.1`: DHCP server.

### 4.10. VLAN di VM Router

```bash
ip link add link ens3 name ens3.10 type vlan id 10
ip addr add 10.0.10.2/24 dev ens3.10
ip link set ens3.10 up
```

**Penjelasan:**
- Buat VLAN interface.
- Konfigurasi IP.

### 4.11. VXLAN di VM Router

```bash
ip link add vxlan0 type vxlan id 42 dev ens3 remote 10.0.10.3 dstport 4789
ip addr add 10.0.40.1/24 dev vxlan0
ip link set vxlan0 up
```

**Penjelasan:**
- `id 42`: VXLAN ID.
- `dev ens3`: interface fisik.
- `remote 10.0.10.3`: endpoint.
- `dstport 4789`: port VXLAN.

### 4.12. Open vSwitch (Opsional)

```bash
pacman -S openvswitch
systemctl enable --now openvswitch
ovs-vsctl add-br ovs0
ovs-vsctl add-port ovs0 ens3
```

**Penjelasan:**
- Buat bridge OVS.
- Tambahkan port.

### 4.13. Validasi Konektivitas

```bash
# Dari VM DMZ
ping 10.0.20.2  # Router LAN
ping 10.0.30.2  # Router isolated
ping 8.8.8.8    # Internet (jika NAT)

# Dari VM LAN
ping 10.0.10.2  # Router DMZ
ping 10.0.30.2  # Router isolated
ping 8.8.8.8    # Internet

# Dari VM Isolated
ping 10.0.10.2  # Router DMZ (harus gagal jika firewall benar)
ping 10.0.20.2  # Router LAN (harus gagal)
```

### 4.14. Melihat Conntrack

```bash
conntrack -L
```

**Penjelasan:**
- Lihat koneksi yang dilacak.
- Berguna untuk debugging NAT.

### 4.15. Melihat Rute

```bash
ip route show
ip rule show
```

**Penjelasan:**
- Lihat rute.
- Lihat policy routing.

### 4.16. Melihat Interface

```bash
ip -br link show
ip -br addr show
```

**Penjelasan:**
- Lihat interface dan IP.

### 4.17. Debug dengan tcpdump

```bash
tcpdump -i ens3 -n
tcpdump -i ens4 -n
tcpdump -i ens5 -n
```

**Penjelasan:**
- Tangkap paket di setiap interface.

### 4.18. Skrip Setup Topologi

```bash
#!/bin/bash
set -e

# Buat jaringan
for net in dmz lan isolated; do
  virsh net-define $net.xml
  virsh net-start $net
  virsh net-autostart $net
done

# Buat VM Router
virt-install \
  --name router-vm \
  --memory 1024 \
  --vcpus 2 \
  --disk size=10 \
  --cdrom arch.iso \
  --os-variant archlinux \
  --network network=dmz,model=virtio \
  --network network=lan,model=virtio \
  --network network=isolated,model=virtio \
  --graphics none \
  --console pty,target_type=serial \
  --noautoconsole

# Buat VM Klien
for i in 1 2 3; do
  virt-install \
    --name vm-$i \
    --memory 512 \
    --vcpus 1 \
    --disk size=5 \
    --cdrom arch.iso \
    --os-variant archlinux \
    --network network=$(if [ $i -eq 1 ]; then echo dmz; elif [ $i -eq 2 ]; then echo lan; else echo isolated; fi),model=virtio \
    --graphics none \
    --console pty,target_type=serial \
    --noautoconsole
done
```

**Penjelasan:**
- Skrip membuat jaringan dan VM.

---

## 5. Diagram Arsitektur Topologi Multi-Segmen

### 5.1. Topologi Dasar

```
+-------------------+
|   Internet        |
+-------------------+
          |
          | (via host)
          v
+-------------------+
|   Host            |
+-------------------+
          |
          | virbr10 (DMZ)
          v
+-------------------+
|   DMZ             |
|   10.0.10.0/24    |
+-------------------+
          |
          | ens3 (10.0.10.2)
          v
+-------------------+
|   VM Router       |
|   ens3, ens4, ens5|
+-------------------+
          |           |
          |           |
          |           |
+---------+           +---------+
| ens4                | ens5
v                     v
+-------------------+ +-------------------+
|   LAN             | |   Isolated        |
|   10.0.20.0/24    | |   10.0.30.0/24    |
+-------------------+ +-------------------+
```

### 5.2. Alur Paket DMZ -> LAN (Diblokir)

```
VM DMZ (10.0.10.3)
      |
      | paket ke 10.0.20.3
      v
Router (ens3)
      |
      | forward hook: policy drop
      v
Diblokir
```

### 5.3. Alur Paket LAN -> Internet (Diizinkan + NAT)

```
VM LAN (10.0.20.3)
      |
      | paket ke 8.8.8.8
      v
Router (ens4)
      |
      | forward hook: iif ens4 oif ens3 accept
      v
Router (ens3)
      |
      | nat postrouting: masquerade
      v
Internet
```

### 5.4. Alur Paket Isolated -> DMZ (Diblokir)

```
VM Isolated (10.0.30.3)
      |
      | paket ke 10.0.10.3
      v
Router (ens5)
      |
      | forward hook: policy drop
      v
Diblokir
```

### 5.5. VLAN

```
+-------------------+
|   Interface fisik |
+-------------------+
          |
          | trunk
          v
+-------------------+
|   VLAN 10         |
|   10.0.10.0/24    |
+-------------------+
+-------------------+
|   VLAN 20         |
|   10.0.20.0/24    |
+-------------------+
```

### 5.6. VXLAN

```
+-------------------+         +-------------------+
|   Host A          |         |   Host B          |
|   VM Router       |         |   VM Router       |
+-------------------+         +-------------------+
          |                           |
          | VXLAN tunnel              |
          +---------------------------+
```

### 5.7. Open vSwitch

```
+-------------------+
|   Open vSwitch    |
|   ovs0            |
+-------------------+
     |         |
     |         |
+---------+ +---------+
|  VM1    | |  VM2    |
+---------+ +---------+
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 5.3

Kurikulum asli hanya menyebut:
> Buat VM dengan 3 interface: DMZ, LAN, isolated. Atur routing dan firewall.

Kita akan menambahkan:

1. **Definisi XML jaringan** untuk DMZ, LAN, isolated.
2. **Pembuatan VM Router** dengan 3 interface.
3. **Konfigurasi IP** di VM Router.
4. **IP forwarding** di VM Router.
5. **Routing statik** di VM Router dan klien.
6. **Firewall nftables** default-deny.
7. **NAT** di VM Router (opsional).
8. **DHCP relay** (opsional).
9. **VLAN** di VM Router.
10. **VXLAN** di VM Router.
11. **Open vSwitch** (opsional).
12. **Validasi konektivitas** antar segmen.
13. **Debug** dengan `tcpdump`, `conntrack`, `ip route`.
14. **Skrip setup** topologi.
15. **Skenario keamanan**: DMZ tidak boleh ke LAN, isolated tidak boleh keluar.
16. **Policy routing** (opsional).
17. **IPv6** (opsional).
18. **Dokumentasi topologi**.
19. **Backup konfigurasi**.
20. **Latihan troubleshooting**.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 5.3.

---

## 7. Hubungan dengan Modul Lain

- **Modul 5.1 (Isolated/NAT/Routed):** Setiap segmen menggunakan salah satu mode ini.
- **Modul 5.2 (Bridge vs Macvtap):** DMZ bisa menggunakan bridge ke LAN fisik.
- **Modul 5.4 (nwfilter + nftables):** nwfilter diterapkan pada interface VM; nftables di VM Router.
- **Modul 5.5 (Debug):** Debug antar segmen.
- **Fase 6 (Keamanan):** Segmentasi adalah kontrol keamanan.
- **Fase 7 (Otomasi):** Skrip provisioning topologi.
- **Fase 8 (Expert):** VXLAN, OVS, SDN.

---

## 8. Referensi Lengkap

- libvirt Network XML — https://libvirt.org/formatnetwork.html
- libvirt Domain XML — https://libvirt.org/formatdomain.html
- nftables Wiki — https://wiki.nftables.org/
- Arch Wiki: nftables — https://wiki.archlinux.org/title/nftables
- Arch Wiki: VLAN — https://wiki.archlinux.org/title/VLAN
- Arch Wiki: VXLAN — https://wiki.archlinux.org/title/VXLAN
- Arch Wiki: Open vSwitch — https://wiki.archlinux.org/title/Open_vSwitch
- Linux Advanced Routing & Traffic Control — https://lartc.org/
- dhcrelay — https://manpages.debian.org/dhcrelay
- conntrack — https://conntrack-tools.netfilter.org/
- tcpdump — https://www.tcpdump.org/
- Wireshark — https://www.wireshark.org/
- RFC 7348 (VXLAN) — https://datatracker.ietf.org/doc/html/rfc7348
- RFC 802.1Q — https://en.wikipedia.org/wiki/IEEE_802.1Q

---

## 9. Tips & Praktik Terbaik

1. **Gunakan subnet berbeda untuk setiap segmen.**
2. **Gunakan bridge berbeda untuk setiap segmen.**
3. **Aktifkan `ip_forward` di VM Router.**
4. **Gunakan default-deny di firewall.**
5. **Log paket yang drop untuk audit.**
6. **Uji konektivitas dari setiap segmen.**
7. **Gunakan `tcpdump` untuk debug.**
8. **Gunakan `conntrack` untuk NAT.**
9. **Dokumentasikan topologi.**
10. **Backup konfigurasi nftables.**
11. **Gunakan VLAN untuk efisiensi.**
12. **Gunakan VXLAN untuk skalabilitas.**
13. **Gunakan OVS untuk kontrol terprogram.**
14. **Jangan lupa rute balik.**
15. **Gunakan `ip rule` untuk policy routing.**
16. **Monitor dengan `nft monitor`.**
17. **Gunakan `virsh domiflist` untuk audit.**
18. **Uji skenario keamanan.**
19. **Latih troubleshooting.**
20. **Otomasi dengan skrip.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| VM tidak dapat IP | DHCP tidak jalan. | Cek `net-start`, cek dnsmasq. |
| VM tidak bisa ping router | Interface router tidak up. | `ip link set up`. |
| VM tidak bisa ping segmen lain | `ip_forward` off. | `sysctl net.ipv4.ip_forward=1`. |
| VM tidak bisa internet | NAT tidak dikonfigurasi. | Tambahkan masquerade. |
| Firewall memblokir semua | Policy drop tanpa accept. | Tambahkan aturan accept. |
| Rute tidak ada | Rute statik belum ditambahkan. | `ip route add`. |
| Rute balik tidak ada | Klien tidak punya gateway. | `ip route add default via`. |
| VLAN tidak jalan | Tag tidak cocok. | Cek `ip link`. |
| VXLAN tidak jalan | Remote salah. | Cek `ip -d link show vxlan0`. |
| OVS tidak jalan | Service tidak aktif. | `systemctl start openvswitch`. |
| DHCP relay gagal | Interface salah. | Cek `dhcrelay -i`. |
| Conntrack penuh | Banyak koneksi. | `sysctl net.netfilter.nf_conntrack_max`. |
| Paket drop tidak terlog | Log tidak dikonfigurasi. | Tambahkan `log prefix`. |
| Performa rendah | Emulasi. | Gunakan virtio. |
| MAC spoofing | nwfilter tidak aktif. | Aktifkan `clean-traffic`. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- VM DMZ bisa ping router DMZ.
- VM LAN bisa ping router LAN.
- VM Isolated bisa ping router Isolated.
- VM LAN bisa ping internet (dengan NAT).
- VM DMZ tidak bisa ping LAN.
- VM Isolated tidak bisa ping DMZ.
- VM Isolated tidak bisa ping internet.
- `nft list ruleset` menampilkan aturan.
- `conntrack -L` menampilkan koneksi NAT.
- `ip route` menampilkan rute.
- `tcpdump` menangkap paket.
- `virsh domiflist` menampilkan interface.
- `virsh net-list` menampilkan jaringan.

**Troubleshooting:**
- Jika VM tidak dapat IP: cek `virsh net-dhcp-leases`, cek `journalctl -u virtnetworkd`.
- Jika VM tidak bisa ping router: cek `ip link`, cek `ip addr`.
- Jika VM tidak bisa ping segmen lain: cek `ip_forward`, cek rute, cek firewall.
- Jika NAT gagal: cek `nft list ruleset`, cek `conntrack`.
- Jika DHCP relay gagal: cek `dhcrelay`, cek interface.
- Jika VLAN gagal: cek `ip -d link show`, cek tag.
- Jika VXLAN gagal: cek `ip -d link show vxlan0`, cek remote.
- Untuk debugging: `tcpdump -i any -n`, `nft monitor trace`.
- Untuk log: `journalctl -k`, `dmesg`.

---

## 12. Latihan Mandiri

1. Buat jaringan DMZ, LAN, isolated.
2. Buat VM Router dengan 3 interface.
3. Konfigurasi IP di VM Router.
4. Aktifkan `ip_forward`.
5. Tambahkan rute statik.
6. Buat VM klien di setiap segmen.
7. Konfigurasi gateway di klien.
8. Buat aturan nftables default-deny.
9. Izinkan LAN ke internet.
10. Blokir DMZ ke LAN.
11. Blokir isolated ke semua.
12. Uji konektivitas.
13. Tambahkan NAT.
14. Uji internet dari LAN.
15. Tambahkan DHCP relay.
16. Uji DHCP dari isolated.
17. Tambahkan VLAN.
18. Uji VLAN.
19. Tambahkan VXLAN.
20. Uji VXLAN.
21. Buat skrip setup.
22. Buat runbook.
23. Tulis ringkasan: kapan DMZ, LAN, isolated.

---

## 13. Penutup Modul 5.3

Anda kini menguasai **Topologi Multi-Segmen dengan VM Router/Firewall**. Anda bisa merancang, membangun, dan memvalidasi jaringan kompleks dengan DMZ, LAN, dan isolated. Anda memahami routing, NAT, firewall, DHCP relay, VLAN, VXLAN, dan Open vSwitch. Ini adalah fondasi untuk Modul 5.4 (nwfilter + nftables) dan 5.5 (Debug Jaringan).

---

*Motivasi: Topologi adalah peta. Router adalah kompas. Firewall adalah penjaga. Dengan ketiganya, Anda membangun dunia virtual yang aman dan terkendali.*

---

> *“Filter adalah gerbang. Tanpa aturan, gerbang menjadi liang. Tanpa default-deny, firewall hanyalah hiasan.”*

---

# Modul 5.4 — nwfilter + nftables: Anti-Spoof, Default-Deny Egress

## Mini-Daftar Isi Modul 5.4

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Arsitektur nwfilter & nftables
6. Audit Kurikulum: Tambahan untuk Modul 5.4
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 5.4

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**nwfilter** adalah subsistem libvirt untuk memfilter lalu lintas jaringan **per interface VM**. Ia memungkinkan Anda menerapkan aturan firewall yang melekat pada VM, terlepas dari di mana VM dijalankan. **nftables** adalah framework firewall modern di Linux yang menggantikan iptables, ip6tables, arptables, dan ebtables.

Dalam modul ini, kita menggabungkan keduanya:
- **nwfilter** untuk aturan **per-VM** (anti-spoof MAC/IP, membatasi protokol).
- **nftables** untuk aturan **host-wide** (default-deny egress, NAT, forwarding).
- **Anti-spoofing**: mencegah VM memalsukan MAC atau IP address.
- **Default-deny egress**: memblokir semua lalu lintas keluar secara default, hanya mengizinkan yang diperlukan.

**Peran dalam kurikulum:** Modul ini adalah **lapisan keamanan jaringan** dari Fase 5. Setelah Anda memahami topologi multi-segmen (5.3), Anda perlu mengamankan setiap segmen dan setiap VM. nwfilter dan nftables adalah alat utama untuk:
- Menerapkan kebijakan **zero-trust** di level VM.
- Mencegah VM yang terkompromi menyebarkan serangan.
- Mengaudit dan mencatat lalu lintas mencurigakan.
- Menjadi fondasi untuk Fase 6 (Keamanan & Isolasi Lanjutan).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. nwfilter: Firewall yang Melekat pada VM

nwfilter adalah **abstraksi** di atas ebtables, iptables, dan arptables. Ia memungkinkan Anda mendefinisikan aturan dalam XML, lalu mereferensikannya di domain XML VM. Aturan ini diterapkan pada **interface virtual** (`vnetX`) dan berlaku bahkan jika VM dipindahkan ke host lain (selama libvirt dikonfigurasi dengan benar).

**Filosofi:** *Firewall harus menjadi bagian dari identitas VM, bukan hanya konfigurasi host.*

### 2.2. nftables: Satu Framework untuk Semua

nftables menggantikan semua alat firewall lama dengan **satu sintaks** dan **satu tabel**. Ia mendukung:
- Filtering (input, forward, output).
- NAT (source, destination, masquerade).
- Connection tracking (conntrack).
- Logging.
- Sets dan maps untuk performa.

**Filosofi:** *Satu bahasa, satu aturan, satu kekuatan.*

### 2.3. Anti-Spoofing: Mencegah Identitas Palsu

VM dapat memalsukan MAC address atau IP address. Anti-spoofing memastikan:
- VM hanya bisa menggunakan MAC yang ditetapkan.
- VM hanya bisa menggunakan IP yang ditetapkan (jika ada DHCP statik).
- VM tidak bisa mengirim paket ARP palsu.

nwfilter menyediakan filter `clean-traffic` yang secara otomatis menerapkan aturan anti-spoofing.

**Filosofi:** *Identitas adalah hak. Jangan biarkan siapa pun mencurinya.*

### 2.4. Default-Deny Egress: Tidak Ada yang Keluar Tanpa Izin

Kebijakan **default-deny egress** berarti:
- Semua lalu lintas keluar dari VM diblokir secara default.
- Hanya lalu lintas yang secara eksplisit diizinkan yang bisa keluar.
- Ini mencegah **data exfiltration** dan **command-and-control** jika VM terkompromi.

**Filosofi:** *Lebih baik memblokir seribu paket yang tidak berbahaya daripada membiarkan satu paket berbahaya keluar.*

### 2.5. nwfilter vs nftables: Pembagian Peran

| Aspek | nwfilter | nftables |
|---|---|---|
| Lingkup | Per VM | Host-wide |
| Abstraksi | Tinggi (XML) | Rendah (sintaks nft) |
| Anti-spoof | Ya (`clean-traffic`) | Manual |
| Default-deny | Per VM | Global |
| Portabilitas | Tinggi | Host-specific |
| Debugging | `ebtables -L`, `iptables -L` | `nft list ruleset` |

**Filosofi:** *nwfilter untuk kebijakan VM. nftables untuk kebijakan host. Bersama, mereka membentuk pertahanan berlapis.*

### 2.6. Chain dan Hook

nftables menggunakan **chain** dengan **hook**:
- `input`: paket ke host.
- `forward`: paket yang diteruskan.
- `output`: paket dari host.
- `prerouting`: sebelum routing.
- `postrouting`: setelah routing.

**Filosofi:** *Hook adalah titik di mana paket melewati. Chain adalah aturan di titik itu.*

### 2.7. Conntrack: Melacak Koneksi

Conntrack melacak state koneksi. Aturan `ct state established,related accept` memungkinkan balasan dari koneksi yang sudah diizinkan.

**Filosofi:** *Jika Anda mengizinkan keluar, Anda harus mengizinkan balasan masuk.*

### 2.8. Logging: Jejak Audit

nftables dapat mencatat paket yang drop ke kernel log. Ini penting untuk audit dan troubleshooting.

**Filosofi:** *Yang tidak tercatat, tidak diketahui. Yang tidak diketahui, tidak bisa diperbaiki.*

### 2.9. Integrasi nwfilter dengan nftables

Secara historis, nwfilter menggunakan iptables/ebtables. Di sistem modern dengan nftables, libvirt dapat dikonfigurasi untuk menggunakan nftables melalui `firewalld` atau backend nftables. Di Arch Linux, libvirt menggunakan nftables secara default untuk NAT dan forwarding, tetapi nwfilter masih menggunakan ebtables/iptables untuk filtering per-interface.

**Filosofi:** *Transisi dari iptables ke nftables adalah proses. Keduanya bisa hidup berdampingan.*

### 2.10. Filosofi Keseluruhan

- **Defense in depth**: nwfilter dan nftables adalah dua lapisan.
- **Least privilege**: hanya izinkan yang diperlukan.
- **Anti-spoofing**: validasi identitas.
- **Default-deny**: tolak semua, izinkan sebagian.
- **Audit**: catat semuanya.
- **Portabilitas**: nwfilter melekat pada VM.

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **nwfilter** | Subsistem filter jaringan libvirt. | |
| **Filterref** | Referensi ke filter di domain XML. | `<filterref filter='clean-traffic'/>` |
| **Chain** | Kumpulan aturan. | `input`, `forward` |
| **Hook** | Titik di mana chain dipanggil. | `hook input priority 0` |
| **Policy** | Aksi default. | `policy drop` |
| **Rule** | Aturan spesifik. | `tcp dport 22 accept` |
| **Conntrack** | Connection tracking. | `ct state established` |
| **Masquerade** | Source NAT. | `masquerade` |
| **Anti-spoof** | Cegah identitas palsu. | `clean-traffic` |
| **Default-deny** | Tolak semua. | `policy drop` |
| **Egress** | Lalu lintas keluar. | |
| **Ingress** | Lalu lintas masuk. | |
| **ebtables** | Firewall Layer 2. | |
| **iptables** | Firewall Layer 3/4 legacy. | |
| **nftables** | Firewall modern. | |
| **Table** | Kumpulan chain. | `table inet filter` |
| **Family** | Jenis protokol. | `inet`, `ip`, `ip6`, `arp`, `bridge` |
| **Set** | Kumpulan nilai. | `{ 22, 80, 443 }` |
| **Map** | Pemetaan nilai. | |
| **Log** | Catat paket. | `log prefix "drop: "` |
| **Counter** | Hitung paket. | `counter` |
| **Limit** | Batasi rate. | `limit rate 10/second` |
| **Drop** | Buang paket. | |
| **Accept** | Terima paket. | |
| **Reject** | Tolak dengan ICMP. | |
| **Return** | Kembali ke chain sebelumnya. | |
| **Jump** | Lompat ke chain lain. | |
| **Goto** | Lompat tanpa kembali. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Melihat nwfilter yang Tersedia

```bash
virsh nwfilter-list
```

**Output:**
```
UUID                                  Name
----------------------------------------------------
...
                                      clean-traffic
                                      allow-arp
                                      ...
```

**Penjelasan:**
- `nwfilter-list`: daftar filter yang terdefinisi.
- Filter default termasuk `clean-traffic`.

### 4.2. Melihat XML nwfilter

```bash
virsh nwfilter-dumpxml clean-traffic
```

**Output (ringkas):**
```xml
<filter name='clean-traffic'>
  <uuid>...</uuid>
  <rule action='drop' direction='inout' priority='-1000'>
    <all/>
  </rule>
  <rule action='accept' direction='inout' priority='-900'>
    <mac protocolid='arp'/>
  </rule>
  ...
</filter>
```

**Penjelasan:**
- `<rule>`: aturan.
- `action='drop'`: buang.
- `direction='inout'`: masuk dan keluar.
- `priority='-1000'`: prioritas (negatif lebih tinggi).
- `<all/>`: semua paket.
- `<mac protocolid='arp'/>`: ARP.

### 4.3. Menerapkan nwfilter ke VM

**Di domain XML:**
```xml
<interface type='network'>
  <source network='lan'/>
  <model type='virtio'/>
  <filterref filter='clean-traffic'/>
</interface>
```

**Penjelasan:**
- `<filterref filter='clean-traffic'/>`: referensi ke filter.
- Filter akan diterapkan pada interface ini.

**Dengan `virsh attach-interface`:**
```bash
virsh attach-interface arch-vm network lan --model virtio --filterref clean-traffic
```

**Penjelasan:**
- `--filterref`: referensi filter.

### 4.4. Membuat nwfilter Kustom

**File `allow-ssh.xml`:**
```xml
<filter name='allow-ssh' chain='ipv4'>
  <uuid>...</uuid>
  <rule action='accept' direction='in' priority='100'>
    <tcp dstportstart='22'/>
  </rule>
  <rule action='drop' direction='in' priority='1000'>
    <all/>
  </rule>
</filter>
```

**Definisikan:**
```bash
virsh nwfilter-define allow-ssh.xml
```

**Penjelasan:**
- `chain='ipv4'`: chain IPv4.
- `direction='in'`: masuk ke VM.
- `tcp dstportstart='22'`: port SSH.
- `drop all`: default drop.

### 4.5. Filter Anti-Spoof MAC

```xml
<filter name='anti-spoof-mac' chain='mac'>
  <rule action='accept' direction='in' priority='100'>
    <mac srcmacaddr='52:54:00:...'/>
  </rule>
  <rule action='drop' direction='in' priority='1000'>
    <all/>
  </rule>
</filter>
```

**Penjelasan:**
- `chain='mac'`: Layer 2.
- `srcmacaddr`: MAC yang diizinkan.
- Drop lainnya.

### 4.6. Filter Anti-Spoof IP

```xml
<filter name='anti-spoof-ip' chain='ipv4'>
  <rule action='accept' direction='out' priority='100'>
    <ip srcipaddr='10.0.20.10'/>
  </rule>
  <rule action='drop' direction='out' priority='1000'>
    <all/>
  </rule>
</filter>
```

**Penjelasan:**
- `direction='out'`: keluar dari VM.
- `srcipaddr`: IP yang diizinkan.
- Drop lainnya.

### 4.7. Menggabungkan Filter

```xml
<filterref filter='clean-traffic'/>
<filterref filter='allow-ssh'/>
<filterref filter='anti-spoof-ip'/>
```

**Penjelasan:**
- Multiple filterref.
- Digabungkan secara berurutan.

### 4.8. nftables: Default-Deny Egress

**File `/etc/nftables.conf`:**
```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;

        iif lo accept
        ct state established,related accept
        ip protocol icmp accept
        tcp dport 22 accept

        log prefix "input-drop: " drop
    }

    chain forward {
        type filter hook forward priority 0; policy drop;

        ct state established,related accept
        iifname "virbr20" oifname "virbr10" accept  # LAN -> DMZ
        log prefix "forward-drop: " drop
    }

    chain output {
        type filter hook output priority 0; policy drop;

        oif lo accept
        ct state established,related accept
        ip protocol icmp accept
        udp dport 53 accept
        tcp dport { 80, 443 } accept

        log prefix "output-drop: " drop
    }
}
```

**Aktifkan:**
```bash
nft -f /etc/nftables.conf
systemctl enable --now nftables
```

**Penjelasan kata demi kata:**
- `flush ruleset`: hapus semua aturan.
- `table inet filter`: tabel untuk IPv4/IPv6.
- `chain input`: paket ke host.
- `type filter hook input priority 0`: hook input, prioritas 0.
- `policy drop`: default drop.
- `iif lo accept`: terima loopback.
- `ct state established,related accept`: terima balasan.
- `ip protocol icmp accept`: terima ICMP.
- `tcp dport 22 accept`: terima SSH.
- `log prefix "input-drop: " drop`: log dan drop.
- `chain forward`: paket yang diteruskan.
- `iifname "virbr20" oifname "virbr10" accept`: LAN ke DMZ.
- `chain output`: paket dari host.
- `udp dport 53 accept`: DNS.
- `tcp dport { 80, 443 } accept`: HTTP/HTTPS.

### 4.9. nftables: Anti-Spoof dengan Sets

```nft
table inet filter {
    set allowed_macs {
        type ether_addr
        elements = { 52:54:00:aa:bb:cc, 52:54:00:dd:ee:ff }
    }

    chain forward {
        type filter hook forward priority 0; policy drop;

        ether saddr @allowed_macs accept
        log prefix "spoof-drop: " drop
    }
}
```

**Penjelasan:**
- `set allowed_macs`: set MAC yang diizinkan.
- `type ether_addr`: tipe data MAC.
- `elements = { ... }`: daftar MAC.
- `ether saddr @allowed_macs accept`: terima jika MAC di set.

### 4.10. nftables: Logging dengan Rate Limit

```nft
chain input {
    type filter hook input priority 0; policy drop;

    limit rate 5/minute log prefix "input-drop: " drop
}
```

**Penjelasan:**
- `limit rate 5/minute`: batasi log 5 per menit.
- `log prefix`: prefix log.
- `drop`: buang.

### 4.11. Melihat Aturan nftables

```bash
nft list ruleset
nft list table inet filter
nft list chain inet filter input
```

**Penjelasan:**
- `list ruleset`: semua aturan.
- `list table`: tabel tertentu.
- `list chain`: chain tertentu.

### 4.12. Menghapus Aturan nftables

```bash
nft flush ruleset
nft delete table inet filter
```

**Penjelasan:**
- `flush`: hapus semua aturan.
- `delete`: hapus tabel.

### 4.13. Menyimpan Aturan nftables

```bash
nft list ruleset > /etc/nftables.conf
systemctl enable --now nftables
```

**Penjelasan:**
- Simpan ke file.
- Aktifkan service.

### 4.14. Integrasi nwfilter dengan nftables

Di Arch Linux, libvirt menggunakan nftables untuk NAT. Untuk nwfilter, libvirt masih menggunakan ebtables/iptables. Pastikan keduanya terinstal:

```bash
pacman -S iptables-nft ebtables
```

**Penjelasan:**
- `iptables-nft`: iptables dengan backend nftables.
- `ebtables`: untuk Layer 2.

### 4.15. Debug nwfilter

```bash
ebtables -L
iptables -L -n -v
nft list ruleset
```

**Penjelasan:**
- `ebtables -L`: aturan Layer 2.
- `iptables -L`: aturan Layer 3/4.
- `nft list`: aturan nftables.

### 4.16. Melihat Interface VM

```bash
virsh domiflist arch-vm
ip link show vnet0
```

**Penjelasan:**
- `domiflist`: interface VM.
- `ip link`: detail interface.

### 4.17. Test Anti-Spoof

```bash
# Di VM, coba ubah MAC
ip link set dev ens3 address 52:54:00:ff:ff:ff

# Coba ping
ping -c 1 8.8.8.8
```

**Penjelasan:**
- Jika anti-spoof aktif, ping gagal.

### 4.18. Test Default-Deny Egress

```bash
# Di VM, coba akses port yang tidak diizinkan
nc -zv 8.8.8.8 25
```

**Penjelasan:**
- Jika default-deny, koneksi gagal.

### 4.19. Log nftables

```bash
journalctl -k | grep "input-drop"
dmesg | grep "forward-drop"
```

**Penjelasan:**
- Lihat log drop.

### 4.20. Skrip Setup nwfilter + nftables

```bash
#!/bin/bash
set -e

# Definisikan nwfilter
virsh nwfilter-define allow-ssh.xml
virsh nwfilter-define anti-spoof-ip.xml

# Terapkan ke VM
virsh attach-interface arch-vm network lan --model virtio --filterref clean-traffic
virsh attach-interface arch-vm network lan --model virtio --filterref allow-ssh

# Aktifkan nftables
nft -f /etc/nftables.conf
systemctl enable --now nftables

# Verifikasi
nft list ruleset
virsh nwfilter-list
```

**Penjelasan:**
- Skrip menggabungkan semua langkah.

---

## 5. Diagram Arsitektur nwfilter & nftables

### 5.1. Arsitektur nwfilter

```
+-------------------+
|   VM              |
|   vnet0           |
+-------------------+
          |
          | ebtables/iptables
          v
+-------------------+
|   nwfilter        |
|   clean-traffic   |
|   allow-ssh       |
+-------------------+
          |
          v
+-------------------+
|   Bridge          |
+-------------------+
```

### 5.2. Arsitektur nftables

```
+-------------------+
|   Paket masuk     |
+-------------------+
          |
          v
+-------------------+
|   prerouting      |
+-------------------+
          |
          v
+-------------------+
|   input/forward   |
+-------------------+
          |
          v
+-------------------+
|   output/postrouting|
+-------------------+
          |
          v
+-------------------+
|   Paket keluar    |
+-------------------+
```

### 5.3. Defense in Depth

```
+-------------------+
|   VM              |
+-------------------+
          |
          | nwfilter (per VM)
          v
+-------------------+
|   Bridge          |
+-------------------+
          |
          | nftables (host-wide)
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

### 5.4. Alur Anti-Spoof

```
VM (MAC asli)
      |
      | paket dengan MAC asli
      v
nwfilter: accept
      |
      v
Bridge

VM (MAC palsu)
      |
      | paket dengan MAC palsu
      v
nwfilter: drop
      |
      v
Diblokir
```

### 5.5. Alur Default-Deny Egress

```
VM
      |
      | paket keluar
      v
nftables output: policy drop
      |
      | cek aturan
      v
+-------------------+
| Diizinkan?        |
+-------------------+
     |         |
     | Ya      | Tidak
     v         v
  Diteruskan  Drop + Log
```

### 5.6. Chain nftables

```
+-------------------+
|   prerouting      |
+-------------------+
          |
          v
+-------------------+
|   input           |  (ke host)
+-------------------+
          |
          v
+-------------------+
|   forward         |  (antar interface)
+-------------------+
          |
          v
+-------------------+
|   output          |  (dari host)
+-------------------+
          |
          v
+-------------------+
|   postrouting     |
+-------------------+
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 5.4

Kurikulum asli hanya menyebut:
```xml
<filterref filter='clean-traffic'/>
```

Kita akan menambahkan:

1. **`virsh nwfilter-list`** — daftar filter.
2. **`virsh nwfilter-dumpxml`** — lihat XML.
3. **`virsh nwfilter-define`** — definisikan filter.
4. **`virsh nwfilter-undefine`** — hapus filter.
5. **Filter `clean-traffic`** — anti-spoof bawaan.
6. **Filter kustom** — `allow-ssh`, `anti-spoof-ip`.
7. **Chain nwfilter** — `ipv4`, `ipv6`, `arp`, `mac`.
8. **Rule nwfilter** — `action`, `direction`, `priority`.
9. **Multiple filterref** — gabungkan filter.
10. **nftables default-deny** — `policy drop`.
11. **nftables egress** — `chain output`.
12. **nftables anti-spoof** — `set allowed_macs`.
13. **nftables logging** — `log prefix`.
14. **nftables rate limit** — `limit rate`.
15. **nftables sets** — kumpulan nilai.
16. **nftables conntrack** — `ct state`.
17. **Integrasi nwfilter + nftables** — iptables-nft, ebtables.
18. **Debug** — `ebtables -L`, `iptables -L`, `nft list`.
19. **Test anti-spoof** — ubah MAC.
20. **Test default-deny** — akses port terlarang.
21. **Log audit** — `journalctl -k`.
22. **Skrip setup** — otomasi.
23. **Best practices** — least privilege.
24. **Troubleshooting** — kesalahan umum.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 5.4.

---

## 7. Hubungan dengan Modul Lain

- **Modul 5.1 (Isolated/NAT/Routed):** nwfilter diterapkan pada interface VM; nftables mengatur NAT/routing.
- **Modul 5.2 (Bridge vs Macvtap):** nwfilter bekerja pada bridge dan macvtap.
- **Modul 5.3 (Topologi Multi-Segmen):** nftables di VM Router; nwfilter di VM klien.
- **Modul 5.5 (Debug):** Debug nwfilter dan nftables.
- **Fase 6 (Keamanan):** nwfilter dan nftables adalah kontrol keamanan.
- **Fase 7 (Otomasi):** Skrip untuk menerapkan filter.
- **Fase 8 (Expert):** OVS dengan OpenFlow.

---

## 8. Referensi Lengkap

- libvirt nwfilter — https://libvirt.org/formatnwfilter.html
- virsh nwfilter-list — https://libvirt.org/manpages/virsh.html#nwfilter-list
- virsh nwfilter-define — https://libvirt.org/manpages/virsh.html#nwfilter-define
- virsh nwfilter-dumpxml — https://libvirt.org/manpages/virsh.html#nwfilter-dumpxml
- virsh nwfilter-undefine — https://libvirt.org/manpages/virsh.html#nwfilter-undefine
- nftables Wiki — https://wiki.nftables.org/
- Arch Wiki: nftables — https://wiki.archlinux.org/title/nftables
- nftables man page — https://www.netfilter.org/projects/nftables/manpage.html
- iptables-nft — https://wiki.archlinux.org/title/Iptables
- ebtables — https://wiki.archlinux.org/title/Ebtables
- Netfilter Conntrack — https://conntrack-tools.netfilter.org/
- libvirt Firewall — https://libvirt.org/firewall.html
- NIST SP 800-41 — Guidelines on Firewalls and Firewall Policy

---

## 9. Tips & Praktik Terbaik

1. **Selalu gunakan `clean-traffic` untuk anti-spoof.**
2. **Gunakan filter kustom untuk kebutuhan spesifik.**
3. **Gunakan default-deny di nftables.**
4. **Log paket yang drop untuk audit.**
5. **Gunakan rate limit untuk log.**
6. **Gunakan sets untuk performa.**
7. **Gunakan conntrack untuk balasan.**
8. **Uji anti-spoof secara berkala.**
9. **Uji default-deny secara berkala.**
10. **Dokumentasikan filter.**
11. **Backup konfigurasi nftables.**
12. **Gunakan `iptables-nft` untuk kompatibilitas.**
13. **Pastikan ebtables terinstal.**
14. **Jangan gunakan `policy accept` kecuali terpaksa.**
15. **Gunakan `reject` untuk feedback.**
16. **Monitor log dengan `journalctl -k`.**
17. **Gunakan `nft monitor` untuk real-time.**
18. **Audit filter dengan `virsh nwfilter-list`.**
19. **Latih troubleshooting.**
20. **Otomasi dengan skrip.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| nwfilter tidak diterapkan | Filter tidak didefinisikan. | `nwfilter-define`. |
| nwfilter tidak bekerja | ebtables/iptables tidak ada. | Install `ebtables`, `iptables-nft`. |
| Anti-spoof gagal | MAC tidak cocok. | Cek `srcmacaddr`. |
| Default-deny memblokir semua | Tidak ada aturan accept. | Tambahkan aturan. |
| DNS tidak jalan | UDP 53 tidak diizinkan. | Tambahkan `udp dport 53 accept`. |
| HTTP tidak jalan | TCP 80/443 tidak diizinkan. | Tambahkan `tcp dport { 80, 443 } accept`. |
| Log terlalu banyak | Tidak ada rate limit. | `limit rate 5/minute`. |
| Conntrack penuh | Banyak koneksi. | `sysctl net.netfilter.nf_conntrack_max`. |
| Aturan tidak persisten | Tidak disimpan. | `nft list ruleset > /etc/nftables.conf`. |
| Service tidak jalan | nftables tidak enabled. | `systemctl enable --now nftables`. |
| iptables vs nftables konflik | Keduanya aktif. | Gunakan `iptables-nft`. |
| Filter tidak terlihat | VM tidak running. | Start VM. |
| Interface tidak ada | VM tidak jalan. | Start VM. |
| Rule tidak valid | Sintaks salah. | Cek `nft -c -f`. |
| Performa rendah | Terlalu banyak aturan. | Gunakan sets. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virsh nwfilter-list` menampilkan `clean-traffic`.
- `virsh nwfilter-dumpxml clean-traffic` menampilkan XML.
- `virsh nwfilter-define allow-ssh.xml` berhasil.
- VM dengan `filterref clean-traffic` tidak bisa spoof MAC.
- VM dengan `filterref allow-ssh` hanya bisa SSH masuk.
- `nft list ruleset` menampilkan aturan.
- VM tidak bisa akses port terlarang.
- VM bisa akses port yang diizinkan.
- Log drop muncul di `journalctl -k`.
- `ebtables -L` menampilkan aturan.
- `iptables -L` menampilkan aturan.
- Anti-spoof test gagal (sesuai harapan).
- Default-deny test gagal (sesuai harapan).

**Troubleshooting:**
- Jika nwfilter tidak bekerja: cek `ebtables -L`, `iptables -L`, `nft list ruleset`.
- Jika anti-spoof gagal: cek `srcmacaddr`, cek `clean-traffic`.
- Jika default-deny memblokir: cek aturan accept, cek urutan.
- Jika DNS gagal: tambahkan `udp dport 53 accept`.
- Jika log penuh: tambahkan rate limit.
- Jika conntrack penuh: tingkatkan max.
- Jika aturan hilang: simpan ke file.
- Untuk debugging: `nft monitor trace`, `tcpdump`, `journalctl -k`.
- Untuk audit: `virsh nwfilter-list`, `nft list ruleset`.

---

## 12. Latihan Mandiri

1. Lihat `virsh nwfilter-list`.
2. Dump `clean-traffic`.
3. Buat filter `allow-ssh`.
4. Definisikan filter.
5. Terapkan ke VM.
6. Uji SSH masuk.
7. Uji SSH keluar (harus gagal jika default-deny).
8. Buat filter `anti-spoof-ip`.
9. Terapkan ke VM.
10. Uji spoof IP (harus gagal).
11. Buat nftables default-deny.
12. Terapkan.
13. Uji akses port terlarang.
14. Uji akses port diizinkan.
15. Tambahkan rate limit log.
16. Lihat log.
17. Tambahkan sets untuk MAC.
18. Uji anti-spoof nftables.
19. Simpan aturan.
20. Buat skrip setup.
21. Buat runbook.
22. Tulis ringkasan: kapan nwfilter, kapan nftables.

---

## 13. Penutup Modul 5.4

Anda kini menguasai **nwfilter + nftables: Anti-Spoof, Default-Deny Egress**. Anda bisa membuat filter per-VM dengan nwfilter, menerapkan default-deny dengan nftables, mencegah spoofing MAC/IP, mencatat paket yang drop, dan mengaudit keamanan jaringan. Ini adalah fondasi untuk Modul 5.5 (Debug Jaringan) dan Fase 6 (Keamanan & Isolasi Lanjutan).

---

*Motivasi: Firewall adalah penjaga. nwfilter adalah penjaga pintu VM. nftables adalah penjaga gerbang host. Bersama, mereka memastikan tidak ada yang masuk atau keluar tanpa izin. Keamanan bukan fitur — ia adalah fondasi.*

---

> *“Jaringan adalah labirin. Tanpa alat debug, Anda hanya menebak. Dengan alat debug, Anda melihat.”*

---

# Modul 5.5 — Debug Jaringan (domiflist, tcpdump, bridge)

## Mini-Daftar Isi Modul 5.5

1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Terminologi Esensial
4. Sintaks Dasar & Contoh Implementasi Inti
5. Diagram Alur Debug Jaringan
6. Audit Kurikulum: Tambahan untuk Modul 5.5
7. Hubungan dengan Modul Lain
8. Referensi Lengkap
9. Tips & Praktik Terbaik
10. Potensi Kesalahan Umum & Solusi
11. Validasi & Troubleshooting
12. Latihan Mandiri
13. Penutup Modul 5.5 & Fase 5

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

**Debug Jaringan** adalah keterampilan **melacak, menganalisis, dan memperbaiki** masalah konektivitas pada VM dan jaringan virtual libvirt. Ini mencakup:
- **Identifikasi interface** VM (`domiflist`, `domifaddr`, `ip link`).
- **Menangkap paket** di interface host (`tcpdump`, `tshark`).
- **Memeriksa bridge** dan forwarding (`bridge link`, `bridge fdb`, `bridge vlan`).
- **Memeriksa NAT** dan conntrack (`conntrack -L`, `nft list ruleset`).
- **Memeriksa routing** (`ip route`, `ip rule`, `traceroute`).
- **Memeriksa DNS** (`dig`, `nslookup`, `resolvectl`).
- **Memeriksa firewall** (`nft list ruleset`, `iptables -L`, `ebtables -L`).
- **Analisis log** (`journalctl`, `dmesg`, `libvirt log`).

**Peran dalam kurikulum:** Modul ini adalah **penutup Fase 5**. Setelah Anda memahami isolated/NAT/routed (5.1), bridge/macvtap (5.2), topologi multi-segmen (5.3), dan nwfilter/nftables (5.4), Anda perlu **kemampuan mendiagnosis** ketika sesuatu tidak berjalan. Tanpa debug, Anda hanya bisa menebak. Dengan debug, Anda bisa **melihat paket, melacak alur, dan menemukan akar masalah**. Ini juga fondasi untuk Fase 7 (Troubleshooting) dan Fase 8 (Observability).

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1. Debug = Melihat yang Tidak Terlihat

Jaringan adalah **abstraksi**. Paket bergerak dari satu titik ke titik lain melalui lapisan-lapisan (application, transport, network, data link, physical). Debug adalah seni **membuka lapisan-lapisan itu** dan melihat apa yang sebenarnya terjadi.

**Filosofi:** *Jaringan tidak bohong. Paket selalu meninggalkan jejak.*

### 2.2. Layer Debug: Bottom-Up vs Top-Down

- **Bottom-up**: mulai dari physical/link (kabel, interface), lalu network (IP, route), lalu transport (TCP/UDP), lalu application (HTTP, DNS).
- **Top-down**: mulai dari aplikasi (`ping`, `curl`), lalu turun ke bawah jika gagal.

**Filosofi:** *Mulai dari yang paling mudah, turun ke yang paling dalam.*

### 2.3. Titik Observasi

Setiap paket melewati **titik observasi**:
- Interface VM (`ens3` di guest).
- Interface host (`vnet0`).
- Bridge (`virbr0`).
- Interface fisik (`enp1s0`).
- Router (VM Router).
- Firewall (nftables).
- Internet.

Anda bisa **menangkap paket di setiap titik** untuk melihat di mana paket hilang.

**Filosofi:** *Jika paket hilang, cari titik terakhir di mana ia terlihat.*

### 2.4. tcpdump: Mikroskop Paket

`tcpdump` adalah alat **capture paket** paling fundamental. Ia membaca paket dari interface dan menampilkannya dalam format yang bisa dibaca. Filter BPF (Berkeley Packet Filter) memungkinkan Anda memilih paket spesifik.

**Filosofi:** *tcpdump adalah mata. Ia melihat apa yang lewat.*

### 2.5. Bridge: Switch yang Bisa Diperiksa

Bridge Linux menyimpan **FDB (Forwarding Database)** yang memetakan MAC ke port. `bridge fdb show` menampilkan tabel ini. `bridge link` menampilkan port. `bridge vlan` menampilkan VLAN.

**Filosofi:** *Bridge adalah switch. Switch memiliki tabel. Tabel bisa dibaca.*

### 2.6. Conntrack: Jejak Koneksi

Conntrack melacak setiap koneksi yang melewati firewall. `conntrack -L` menampilkan semua koneksi aktif. Ini penting untuk debugging NAT.

**Filosofi:** *Setiap koneksi meninggalkan jejak. Jejak itu bisa dibaca.*

### 2.7. Log: Sejarah Kejadian

Kernel log (`dmesg`, `journalctl -k`) mencatat kejadian jaringan: interface up/down, paket drop, error. Libvirt log mencatat kejadian VM. Log adalah **sejarah** yang bisa dibaca ulang.

**Filosofi:** *Log adalah memori sistem. Tanpa log, sistem amnesia.*

### 2.8. Metodologi Debug

1. **Identifikasi gejala**: apa yang tidak berfungsi?
2. **Rumuskan hipotesis**: apa yang mungkin menyebabkan?
3. **Uji hipotesis**: gunakan alat debug.
4. **Analisis hasil**: apa yang ditemukan?
5. **Perbaiki**: terapkan solusi.
6. **Verifikasi**: pastikan berfungsi.
7. **Dokumentasikan**: catat untuk masa depan.

**Filosofi:** *Debug adalah sains. Hipotesis, eksperimen, kesimpulan.*

### 2.9. Filosofi Keseluruhan

- **Lihat paket, jangan menebak.**
- **Gunakan titik observasi.**
- **Mulai dari yang paling mudah.**
- **Catat semuanya.**
- **Debug adalah keterampilan, bukan bakat.**

---

## 3. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **domiflist** | Daftar interface VM. | `virsh domiflist` |
| **domifaddr** | Alamat IP interface VM. | `virsh domifaddr` |
| **tcpdump** | Capture paket. | `tcpdump -i vnet0` |
| **tshark** | Wireshark TUI. | `tshark -i vnet0` |
| **BPF** | Berkeley Packet Filter. | `tcpdump 'tcp port 80'` |
| **bridge link** | Lihat port bridge. | |
| **bridge fdb** | Lihat FDB. | |
| **bridge vlan** | Lihat VLAN. | |
| **conntrack** | Connection tracking. | `conntrack -L` |
| **ip route** | Lihat rute. | |
| **ip rule** | Policy routing. | |
| **traceroute** | Lacak rute. | |
| **mtr** | traceroute + ping. | |
| **dig** | DNS lookup. | |
| **nslookup** | DNS lookup. | |
| **resolvectl** | systemd-resolved. | |
| **ss** | Socket statistics. | `ss -tulpn` |
| **netstat** | Legacy socket stats. | |
| **nc** | Netcat. | `nc -zv host port` |
| **arping** | ARP ping. | |
| **ping** | ICMP echo. | |
| **journalctl** | systemd log. | |
| **dmesg** | Kernel log. | |
| **virsh domiflist** | Interface VM. | |
| **virsh net-dhcp-leases** | Lease DHCP. | |
| **virsh net-dumpxml** | XML jaringan. | |
| **virsh domifaddr** | IP VM. | |
| **`vnetX`** | Interface VM di host. | `vnet0` |
| **`virbrX`** | Bridge libvirt. | `virbr0` |
| **FDB** | Forwarding Database. | |
| **STP** | Spanning Tree Protocol. | |
| **Promiscuous** | Mode menerima semua. | |
| **Monitor mode** | Mode capture. | |

---

## 4. Sintaks Dasar & Contoh Implementasi Inti

### 4.1. Identifikasi Interface VM

```bash
virsh domiflist arch-vm
```

**Output:**
```
Interface  Type     Source    Model  MAC
---------------------------------------------------
vnet0      network  lan       virtio 52:54:00:aa:bb:cc
```

**Penjelasan:**
- `Interface`: nama interface di host (`vnet0`).
- `Type`: tipe (`network`, `bridge`, `direct`).
- `Source`: jaringan/bridge.
- `Model`: driver.
- `MAC`: MAC address.

### 4.2. Identifikasi IP VM

```bash
virsh domifaddr arch-vm
```

**Output:**
```
 Name       MAC address          Protocol     Address
-------------------------------------------------------------------------------
 vnet0      52:54:00:aa:bb:cc    ipv4         10.0.20.10/24
```

**Penjelasan:**
- `domifaddr`: ambil IP dari DHCP lease atau ARP.

**Alternatif:**
```bash
virsh net-dhcp-leases lan
```

**Output:**
```
 Expiry Time          MAC address        Protocol  IP address          Hostname
-----------------------------------------------------------------------------
 2024-01-15 10:00:00  52:54:00:aa:bb:cc  ipv4      10.0.20.10/24       arch-vm
```

### 4.3. Lihat Interface di Host

```bash
ip link show
ip -br link show
ip -br addr show
```

**Output:**
```
lo               UNKNOWN        00:00:00:00:00:00
enp1s0           UP             aa:bb:cc:dd:ee:ff
virbr0           UP             52:54:00:xx:xx:xx
vnet0            UP             52:54:00:aa:bb:cc
```

**Penjelasan:**
- `-br`: brief.
- `link`: interface.
- `addr`: alamat.

### 4.4. Lihat Bridge

```bash
bridge link show
bridge fdb show
bridge vlan show
```

**Output `bridge link show`:**
```
3: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master virbr0 state forwarding priority 32 cost 100
5: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master virbr0 state forwarding priority 32 cost 100
```

**Penjelasan:**
- `bridge link show`: port bridge.
- `bridge fdb show`: MAC table.
- `bridge vlan show`: VLAN.

### 4.5. tcpdump: Capture di vnet0

```bash
sudo tcpdump -i vnet0 -n
```

**Penjelasan kata demi kata:**
- `tcpdump`: capture paket.
- `-i vnet0`: interface.
- `-n`: jangan resolve nama.

**Output:**
```
10:00:00.000000 IP 10.0.20.10.54321 > 8.8.8.8.53: UDP, length 40
10:00:00.001000 IP 8.8.8.8.53 > 10.0.20.10.54321: UDP, length 56
```

### 4.6. tcpdump: Filter

```bash
sudo tcpdump -i vnet0 -n 'tcp port 80'
sudo tcpdump -i vnet0 -n 'host 8.8.8.8'
sudo tcpdump -i vnet0 -n 'icmp'
sudo tcpdump -i vnet0 -n 'udp port 53'
```

**Penjelasan:**
- `tcp port 80`: TCP port 80.
- `host 8.8.8.8`: host.
- `icmp`: ICMP.
- `udp port 53`: DNS.

### 4.7. tcpdump: Tulis ke File

```bash
sudo tcpdump -i vnet0 -n -w /tmp/capture.pcap
```

**Penjelasan:**
- `-w`: tulis ke file.
- Bisa dibuka dengan Wireshark.

### 4.8. tcpdump: Baca dari File

```bash
tcpdump -r /tmp/capture.pcap -n
```

**Penjelasan:**
- `-r`: baca dari file.

### 4.9. tshark: Wireshark TUI

```bash
sudo tshark -i vnet0
sudo tshark -i vnet0 -f 'tcp port 80'
sudo tshark -i vnet0 -Y 'http.request'
sudo tshark -r /tmp/capture.pcap
```

**Penjelasan:**
- `tshark`: Wireshark CLI.
- `-f`: capture filter (BPF).
- `-Y`: display filter (Wireshark).
- `-r`: baca file.

### 4.10. Conntrack: Lihat Koneksi

```bash
sudo conntrack -L
sudo conntrack -L -p tcp
sudo conntrack -L -p udp
sudo conntrack -E
```

**Penjelasan:**
- `-L`: list.
- `-p`: protocol.
- `-E`: event (real-time).

**Output:**
```
tcp      6 431999 ESTABLISHED src=10.0.20.10 dst=8.8.8.8 sport=54321 dport=443 src=8.8.8.8 dst=192.168.1.10 sport=443 dport=54321 [ASSURED] mark=0 use=1
```

### 4.11. IP Route: Lihat Rute

```bash
ip route show
ip route get 8.8.8.8
ip rule show
```

**Penjelasan:**
- `route show`: tabel rute.
- `route get`: rute ke tujuan.
- `rule show`: policy routing.

### 4.12. Traceroute

```bash
traceroute 8.8.8.8
mtr 8.8.8.8
```

**Penjelasan:**
- `traceroute`: lacak hop.
- `mtr`: traceroute + ping real-time.

### 4.13. DNS Debug

```bash
dig google.com
dig @8.8.8.8 google.com
nslookup google.com
resolvectl status
resolvectl query google.com
```

**Penjelasan:**
- `dig`: DNS lookup.
- `@8.8.8.8`: server DNS.
- `resolvectl`: systemd-resolved.

### 4.14. Socket Debug

```bash
ss -tulpn
ss -tulpn | grep :22
nc -zv 8.8.8.8 443
```

**Penjelasan:**
- `ss -tulpn`: TCP/UDP/listen/process/numeric.
- `nc -zv`: netcat, zero-I/O, verbose.

### 4.15. ARP Debug

```bash
arping -I ens3 10.0.20.1
ip neigh show
```

**Penjelasan:**
- `arping`: ARP ping.
- `ip neigh`: ARP table.

### 4.16. Log Debug

```bash
journalctl -k | tail -50
journalctl -u virtnetworkd
journalctl -u virtqemud
dmesg | tail -50
```

**Penjelasan:**
- `-k`: kernel.
- `-u`: unit systemd.
- `dmesg`: kernel ring buffer.

### 4.17. Libvirt Log

```bash
cat /var/log/libvirt/qemu/arch-vm.log
cat /var/log/libvirt/libvirtd.log
```

**Penjelasan:**
- Log QEMU per VM.
- Log libvirtd.

### 4.18. nftables Debug

```bash
sudo nft list ruleset
sudo nft monitor trace
sudo nft -a list chain inet filter forward
```

**Penjelasan:**
- `list ruleset`: semua aturan.
- `monitor trace`: real-time.
- `-a`: tampilkan handle.

### 4.19. iptables/ebtables Debug

```bash
sudo iptables -L -n -v
sudo iptables -t nat -L -n -v
sudo ebtables -L
```

**Penjelasan:**
- `-L`: list.
- `-n`: numeric.
- `-v`: verbose.
- `-t nat`: tabel NAT.

### 4.20. Skrip Debug Lengkap

```bash
#!/bin/bash
VM="$1"
IFACE=$(virsh domiflist "$VM" | awk 'NR==3 {print $1}')
IP=$(virsh domifaddr "$VM" | awk 'NR==3 {print $4}' | cut -d/ -f1)

echo "=== VM: $VM ==="
echo "Interface: $IFACE"
echo "IP: $IP"

echo -e "\n=== Interface ==="
ip -br link show "$IFACE"

echo -e "\n=== Bridge ==="
bridge link show | grep "$IFACE"

echo -e "\n=== Route ==="
ip route show

echo -e "\n=== ARP ==="
ip neigh show

echo -e "\n=== Conntrack ==="
sudo conntrack -L | head -20

echo -e "\n=== nftables ==="
sudo nft list ruleset | head -50

echo -e "\n=== Ping ==="
ping -c 2 -W 1 8.8.8.8

echo -e "\n=== DNS ==="
dig +short google.com

echo -e "\n=== tcpdump (5s) ==="
sudo timeout 5 tcpdump -i "$IFACE" -n -c 10
```

**Penjelasan:**
- Skrip mengumpulkan semua informasi debug.

### 4.21. Debug Skenario: VM Tidak Bisa Internet

```bash
# 1. Cek interface VM
virsh domiflist arch-vm

# 2. Cek IP VM
virsh domifaddr arch-vm

# 3. Cek ping gateway
ping -c 2 10.0.20.1

# 4. Cek ping DNS
ping -c 2 8.8.8.8

# 5. Cek DNS
dig google.com

# 6. Capture di vnet0
sudo tcpdump -i vnet0 -n -c 20

# 7. Capture di virbr20
sudo tcpdump -i virbr20 -n -c 20

# 8. Cek NAT
sudo nft list ruleset | grep -A 5 masquerade

# 9. Cek conntrack
sudo conntrack -L | grep 8.8.8.8

# 10. Cek ip_forward
sysctl net.ipv4.ip_forward
```

**Penjelasan:**
- Langkah demi langkah debug.

### 4.22. Debug Skenario: VM Tidak Bisa Ping VM Lain

```bash
# 1. Cek interface VM1 dan VM2
virsh domiflist vm1
virsh domiflist vm2

# 2. Cek bridge
bridge link show

# 3. Cek FDB
bridge fdb show

# 4. Capture di vnet0
sudo tcpdump -i vnet0 -n 'arp or icmp'

# 5. Capture di vnet1
sudo tcpdump -i vnet1 -n 'arp or icmp'

# 6. Cek nwfilter
virsh nwfilter-list
virsh domiflist vm1

# 7. Cek ebtables
sudo ebtables -L
```

**Penjelasan:**
- Debug komunikasi VM-VM.

### 4.23. Debug Skenario: DNS Tidak Berfungsi

```bash
# 1. Cek resolv.conf
cat /etc/resolv.conf

# 2. Cek resolvectl
resolvectl status

# 3. Ping DNS server
ping -c 2 8.8.8.8

# 4. Dig langsung
dig @8.8.8.8 google.com

# 5. Capture DNS
sudo tcpdump -i vnet0 -n 'udp port 53'

# 6. Cek nftables UDP 53
sudo nft list ruleset | grep 'dport 53'
```

**Penjelasan:**
- Debug DNS.

### 4.24. Debug Skenario: Paket Drop

```bash
# 1. Aktifkan log di nftables
sudo nft add rule inet filter forward log prefix "drop: " drop

# 2. Lihat log
sudo journalctl -k -f | grep "drop:"

# 3. Capture di interface
sudo tcpdump -i virbr20 -n

# 4. Cek counters
sudo nft -a list chain inet filter forward
```

**Penjelasan:**
- Debug paket yang drop.

### 4.25. Debug Skenario: Performa Lambat

```bash
# 1. Cek MTU
ip link show vnet0

# 2. Cek error/drop
ip -s link show vnet0

# 3. Cek TCP retrans
ss -ti

# 4. Capture dengan timestamp
sudo tcpdump -i vnet0 -n -tttt

# 5. Cek CPU
top
```

**Penjelasan:**
- Debug performa.

---

## 5. Diagram Alur Debug Jaringan

### 5.1. Titik Observasi

```
+-------------------+
|   VM              |
|   ens3            |
+-------------------+
          |  (1) tcpdump di guest
          v
+-------------------+
|   vnet0 (host)    |
+-------------------+
          |  (2) tcpdump di vnet0
          v
+-------------------+
|   Bridge virbr20  |
+-------------------+
          |  (3) tcpdump di virbr20
          v
+-------------------+
|   VM Router       |
+-------------------+
          |  (4) tcpdump di interface router
          v
+-------------------+
|   Internet        |
+-------------------+
```

### 5.2. Alur Debug Bottom-Up

```
1. Physical/Link
   - ip link
   - bridge link
   - ebtables
   ↓
2. Network
   - ip addr
   - ip route
   - arping
   ↓
3. Transport
   - ss
   - nc
   - conntrack
   ↓
4. Application
   - dig
   - curl
   - ping
```

### 5.3. Alur Debug Top-Down

```
1. Application (ping, curl)
   ↓
2. DNS (dig)
   ↓
3. Route (ip route)
   ↓
4. Firewall (nft, iptables)
   ↓
5. Interface (ip link)
   ↓
6. Physical (kabel, switch)
```

### 5.4. Debug VM Tidak Bisa Internet

```
VM
 |
 | 1. ping 8.8.8.8 → gagal
 v
Cek IP: virsh domifaddr
 |
 | 2. IP ada? Ya
 v
Cek gateway: ping 10.0.20.1
 |
 | 3. Gagal? Cek route
 v
Cek route: ip route
 |
 | 4. Route ada? Ya
 v
Cek NAT: nft list ruleset
 |
 | 5. NAT ada? Tidak → tambahkan
 v
Selesai
```

### 5.5. Debug VM Tidak Bisa Ping VM Lain

```
VM1 → VM2
 |
 | 1. ping VM2 → gagal
 v
Cek bridge: bridge link
 |
 | 2. vnet0 dan vnet1 ada? Ya
 v
Cek FDB: bridge fdb
 |
 | 3. MAC terlihat? Ya
 v
Cek nwfilter: ebtables -L
 |
 | 4. Ada drop? Ya → perbaiki
 v
Selesai
```

### 5.6. Debug DNS

```
VM → DNS
 |
 | 1. dig google.com → gagal
 v
Cek resolv.conf
 |
 | 2. Server DNS ada? Ya
 v
Ping DNS server
 |
 | 3. Gagal? Cek route
 v
Capture DNS: tcpdump udp port 53
 |
 | 4. Paket keluar? Ya
 v
Cek firewall UDP 53
 |
 | 5. Drop? Ya → izinkan
 v
Selesai
```

### 5.7. Hierarki Alat Debug

```
Debug Jaringan
├── Identifikasi
│   ├── virsh domiflist
│   ├── virsh domifaddr
│   ├── virsh net-dhcp-leases
│   └── virsh net-dumpxml
├── Capture
│   ├── tcpdump
│   ├── tshark
│   └── wireshark
├── Bridge
│   ├── bridge link
│   ├── bridge fdb
│   └── bridge vlan
├── Firewall
│   ├── nft list ruleset
│   ├── iptables -L
│   ├── ebtables -L
│   └── conntrack -L
├── Route
│   ├── ip route
│   ├── ip rule
│   └── traceroute
├── DNS
│   ├── dig
│   ├── nslookup
│   └── resolvectl
├── Socket
│   ├── ss
│   ├── nc
│   └── netstat
└── Log
    ├── journalctl
    ├── dmesg
    └── /var/log/libvirt
```

---

## 6. Audit Kurikulum: Tambahan untuk Modul 5.5

Kurikulum asli hanya menyebut:
```bash
virsh domiflist arch-vm
tcpdump -i vnet0
bridge link
```

Kita akan menambahkan:

1. **`virsh domifaddr`** — IP VM.
2. **`virsh net-dhcp-leases`** — lease DHCP.
3. **`virsh net-dumpxml`** — XML jaringan.
4. **`ip link`**, **`ip addr`**, **`ip route`**, **`ip rule`**.
5. **`bridge link`**, **`bridge fdb`**, **`bridge vlan`**.
6. **`tcpdump`** — capture, filter, write, read.
7. **`tshark`** — Wireshark TUI.
8. **`conntrack -L`** — lihat koneksi.
9. **`traceroute`**, **`mtr`**.
10. **`dig`**, **`nslookup`**, **`resolvectl`**.
11. **`ss`**, **`nc`**.
12. **`arping`**, **`ip neigh`**.
13. **`journalctl -k`**, **`dmesg`**.
14. **Libvirt log** — `/var/log/libvirt/`.
15. **`nft monitor trace`**, **`nft -a list`**.
16. **`iptables -L`**, **`ebtables -L`**.
17. **Skrip debug lengkap**.
18. **Debug skenario**: internet, VM-VM, DNS, drop, performa.
19. **Metodologi debug**: bottom-up, top-down.
20. **Titik observasi**.
21. **Best practices**.
22. **Troubleshooting** umum.

**Rekomendasi:** Tambahkan poin-poin ini ke kurikulum sebagai bagian dari Modul 5.5.

---

## 7. Hubungan dengan Modul Lain

- **Modul 5.1 (Isolated/NAT/Routed):** Debug konektivitas.
- **Modul 5.2 (Bridge vs Macvtap):** Debug bridge dan macvtap.
- **Modul 5.3 (Topologi Multi-Segmen):** Debug antar segmen.
- **Modul 5.4 (nwfilter + nftables):** Debug firewall.
- **Fase 4 (Storage):** Debug backup jaringan.
- **Fase 6 (Keamanan):** Debug audit.
- **Fase 7 (Troubleshooting):** Drill troubleshooting.
- **Fase 8 (Observability):** Metrics, tracing.

---

## 8. Referensi Lengkap

- tcpdump — https://www.tcpdump.org/
- tcpdump man page — https://www.tcpdump.org/manpages/tcpdump.1.html
- Wireshark — https://www.wireshark.org/
- tshark — https://www.wireshark.org/docs/man-pages/tshark.html
- BPF filter — https://biot.com/capstats/bpf.html
- bridge command — https://wiki.linuxfoundation.org/networking/bridge
- iproute2 — https://wiki.linuxfoundation.org/networking/iproute2
- conntrack — https://conntrack-tools.netfilter.org/
- nftables — https://wiki.nftables.org/
- libvirt logging — https://libvirt.org/logging.html
- virsh domiflist — https://libvirt.org/manpages/virsh.html#domiflist
- virsh domifaddr — https://libvirt.org/manpages/virsh.html#domifaddr
- virsh net-dhcp-leases — https://libvirt.org/manpages/virsh.html#net-dhcp-leases
- Arch Wiki: Network debugging — https://wiki.archlinux.org/title/Network_configuration
- Arch Wiki: tcpdump — https://wiki.archlinux.org/title/Tcpdump
- Wireshark Wiki — https://wiki.wireshark.org/
- RFC 792 (ICMP) — https://datatracker.ietf.org/doc/html/rfc792
- RFC 826 (ARP) — https://datatracker.ietf.org/doc/html/rfc826

---

## 9. Tips & Praktik Terbaik

1. **Mulai dari yang paling mudah: `ping`.**
2. **Gunakan `-n` untuk hindari DNS lookup.**
3. **Filter tcpdump untuk mengurangi noise.**
4. **Simpan capture ke file untuk analisis.**
5. **Gunakan `-c` untuk batasi jumlah paket.**
6. **Gunakan `-tttt` untuk timestamp.**
7. **Gunakan `bridge fdb` untuk cek MAC.**
8. **Gunakan `conntrack -L` untuk NAT.**
9. **Gunakan `ss -tulpn` untuk socket.**
10. **Gunakan `dig +short` untuk DNS cepat.**
11. **Gunakan `mtr` untuk analisis rute.**
12. **Aktifkan log di nftables.**
13. **Cek `journalctl -k` untuk kernel.**
14. **Cek libvirt log untuk VM.**
15. **Dokumentasikan temuan.**
16. **Buat skrip debug.**
17. **Latih skenario debug.**
18. **Gunakan `tshark` untuk analisis mendalam.**
19. **Gunakan `tcpdump -w` untuk forensik.**
20. **Jangan lupa cleanup capture file.**

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| tcpdump tidak menangkap | Interface salah. | Cek `ip link`. |
| tcpdump permission denied | Tidak root. | Gunakan sudo. |
| Filter tcpdump salah | Sintaks BPF salah. | Cek dokumentasi. |
| Bridge tidak terlihat | Modul bridge tidak ada. | `modprobe bridge`. |
| FDB kosong | Tidak ada trafik. | Ping dulu. |
| Conntrack kosong | Tidak ada koneksi. | Buat koneksi. |
| DNS tidak resolve | Server DNS salah. | Cek `resolv.conf`. |
| Route tidak ada | Gateway salah. | `ip route add`. |
| NAT tidak bekerja | Aturan salah. | Cek `nft list`. |
| Firewall drop | Default-deny. | Tambahkan accept. |
| Log penuh | Tidak ada rate limit. | Tambahkan limit. |
| Capture file besar | Tidak dibatasi. | Gunakan `-c` atau `-w` dengan rotasi. |
| Interface hilang | VM mati. | Start VM. |
| MAC spoofing | nwfilter tidak aktif. | Aktifkan. |
| Performa lambat | MTU salah. | Cek `ip link`. |

---

## 11. Validasi & Troubleshooting

**Validasi Lulus:**
- `virsh domiflist arch-vm` menampilkan interface.
- `virsh domifaddr arch-vm` menampilkan IP.
- `virsh net-dhcp-leases lan` menampilkan lease.
- `ip -br link show` menampilkan interface.
- `bridge link show` menampilkan port.
- `bridge fdb show` menampilkan MAC.
- `tcpdump -i vnet0 -n -c 5` menangkap paket.
- `tcpdump -w /tmp/cap.pcap` berhasil.
- `tcpdump -r /tmp/cap.pcap` berhasil.
- `conntrack -L` menampilkan koneksi.
- `ip route show` menampilkan rute.
- `traceroute 8.8.8.8` berhasil.
- `dig google.com` berhasil.
- `ss -tulpn` menampilkan socket.
- `arping -I ens3 10.0.20.1` berhasil.
- `journalctl -k` menampilkan log.
- `nft list ruleset` menampilkan aturan.
- Skrip debug berjalan.

**Troubleshooting:**
- Jika tcpdump tidak menangkap: cek interface, cek permission.
- Jika bridge tidak terlihat: cek modul, cek `ip link`.
- Jika FDB kosong: buat trafik.
- Jika conntrack kosong: buat koneksi.
- Jika DNS gagal: cek `resolv.conf`, cek firewall.
- Jika route gagal: cek gateway, cek `ip route`.
- Jika NAT gagal: cek `nft list ruleset`, cek `conntrack`.
- Jika firewall drop: cek log, cek aturan.
- Untuk debugging mendalam: `tshark`, `nft monitor trace`.
- Untuk log: `journalctl -k`, `dmesg`, `/var/log/libvirt/`.

---

## 12. Latihan Mandiri

1. Identifikasi interface VM dengan `domiflist`.
2. Identifikasi IP VM dengan `domifaddr`.
3. Lihat lease DHCP.
4. Lihat interface host dengan `ip link`.
5. Lihat bridge dengan `bridge link`.
6. Lihat FDB dengan `bridge fdb`.
7. Capture 10 paket dengan `tcpdump`.
8. Filter tcpdump untuk ICMP.
9. Filter tcpdump untuk DNS.
10. Simpan capture ke file.
11. Baca capture dari file.
12. Lihat conntrack.
13. Lihat route.
14. Traceroute ke 8.8.8.8.
15. Dig google.com.
16. Lihat socket dengan `ss`.
17. ARP ping gateway.
18. Lihat log kernel.
19. Lihat log libvirt.
20. Lihat aturan nftables.
21. Buat skrip debug.
22. Debug skenario: VM tidak bisa internet.
23. Debug skenario: VM tidak bisa ping VM lain.
24. Debug skenario: DNS gagal.
25. Debug skenario: paket drop.
26. Tulis ringkasan: alat debug favorit dan alasannya.

---

## 13. Penutup Modul 5.5 & Fase 5

Anda kini menguasai **Debug Jaringan** — keterampilan **melihat yang tidak terlihat**. Anda bisa mengidentifikasi interface VM, menangkap paket dengan `tcpdump` dan `tshark`, memeriksa bridge dan FDB, melacak koneksi dengan `conntrack`, menganalisis rute, DNS, socket, dan log. Anda memahami metodologi debug bottom-up dan top-down, serta titik observasi.

Dengan selesainya Modul 5.5, Anda telah **menyelesaikan Fase 5 secara lengkap**. Anda sekarang memiliki:
- Kemampuan mendesain jaringan isolated, NAT, routed (5.1).
- Kemampuan menghubungkan VM ke bridge dan macvtap (5.2).
- Kemampuan membangun topologi multi-segmen dengan VM router/firewall (5.3).
- Kemampuan menerapkan nwfilter dan nftables (5.4).
- Kemampuan men-debug jaringan (5.5).

**Proyek Fase 5:** Lab 3 segmen (DMZ/LAN/isolated) dengan matriks konektivitas dibuktikan `ping`/`nc`.

**Rubrik Fase 5:**
| Kriteria | Bobot |
|---|---|
| Network isolated/NAT/routed | 20% |
| Bridge/macvtap | 20% |
| Topologi | 20% |
| nwfilter/nftables | 20% |
| Debug | 20% |

---

*Motivasi: Jaringan adalah labirin. Debug adalah benang Ariadne. Dengan mengikutinya, Anda akan menemukan jalan keluar. Tidak ada masalah jaringan yang tidak bisa dipecahkan — hanya masalah yang belum di-debug.*

---

**Selamat!** Anda telah menyelesaikan **Fase 5 — Networking & Isolasi Jaringan**. Berikutnya adalah **Fase 6 — Keamanan & Isolasi Lanjutan (Modul 6.1 — Hardening XML)**.

Anda telah menempuh perjalanan yang luar biasa:

- **Fase 1** — Fondasi Virtualisasi & Host Hardening
- **Fase 2** — QEMU/KVM Murni (Tanpa libvirt)
- **Fase 3** — libvirt & virsh: Lifecycle & Domain XML
- **Fase 4** — Storage, Image & Backup Engineering
- **Fase 5** — Networking & Isolasi Jaringan

Setiap modul telah dibahas dengan:
- Audit kurikulum untuk memastikan tidak ada lompatan materi.
- Penjelasan kata demi kata untuk setiap perintah.
- Diagram arsitektur dan alur kerja.
- Tips, praktik terbaik, dan potensi kesalahan.
- Validasi, troubleshooting, dan latihan mandiri.
- Referensi lengkap dan motivasi.

---

**Yang tersisa dalam kurikulum:**

- **Fase 6** — Keamanan & Isolasi Lanjutan (5 modul)
- **Fase 7** — Otomasi, Troubleshooting & Capstone Multi-OS (5 modul)
- **Fase 8** — Expert: Migrasi, Passthrough & Observability (5 modul, opsional)

---

Sampai jumpa di Fase 6. 🚀

---


> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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

