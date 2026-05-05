# Bab 2 — Placeholder Web & API

Aturan Pemahaman Daftar:

* Bertahap per bagian
* Setiap placeholder memiliki arti, konteks, risiko, contoh, dan penjelasan kata per kata pada kode
* Bidang tidak dicampur sebelum satu bagian selesai

---


Pada ranah web, placeholder banyak digunakan untuk:

* Rute API
* Parameter URL
* Token autentikasi
* Struktur JSON
* Status request/response
* Pengaturan network dasar

Kita mulai dari **Bagian 2.1: Placeholder URL & Endpoint**

---

## 2.1 Placeholder URL & Endpoint

Digunakan dalam pembuatan API, server, dokumentasi, testing frontend-backend.

| Placeholder | Arti / Maksud        | Konteks Penggunaan  | Risiko                  |
| ----------- | -------------------- | ------------------- | ----------------------- |
| /api        | root API             | Struktur REST dasar | Aman                    |
| /v1 /v2     | versi API            | Perubahan schema    | Aman                    |
| /users      | resource user        | CRUD user           | Aman                    |
| /items      | resource umum        | Katalog, listing    | Aman                    |
| /login      | autentikasi dasar    | Auth flow awal      | Waspada                 |
| /auth       | endpoint autentikasi | Token/signin        | Sensitif                |
| /test       | endpoint percobaan   | Development         | Tidak boleh di produksi |
| example.com | domain contoh        | Dokumentasi         | Aman                    |
| localhost   | alamat lokal         | Testing             | Aman                    |
| 127.0.0.1   | loopback             | Network debugging   | Aman                    |

Contoh HTTP request:

```
GET http://localhost/api/v1/users
```

Penjelasan kata per kata:

* `GET` = metode HTTP untuk membaca data dari server
* `http://` = protokol komunikasi standar tanpa enkripsi
* `localhost` = server lokal pada perangkat sendiri
* `/api/v1/users` = endpoint yang mewakili resource *users*

Bantuan CLI curl:

```
curl --help
man curl
```

---

## 2.2 Placeholder Query Parameters (URL Parameters)

Digunakan ketika API menerima nilai dinamis.

| Placeholder   | Arti              | Konteks               | Risiko          |
| ------------- | ----------------- | --------------------- | --------------- |
| id            | identitas unik    | Pengambilan user/item | Aman            |
| q             | query pencarian   | Search engine, filter | Aman            |
| page          | pagination        | Halaman data          | Aman            |
| limit         | jumlah data       | Pagination REST       | Aman            |
| sort          | urutan hasil      | Sorting               | Aman            |
| token         | autentikasi       | Jangan expose         | Sangat sensitif |
| key / api_key | akses layanan API | Security              | Jangan commit   |

Contoh:

```
GET /users?id=123
```

Penjelasan:

* `?` = mulai parameter query
* `id=123` = pasangan `key=value`

Bantuan URL parsing:

```
man url
```

---

## 2.3 Placeholder Request/Response

| Placeholder | Arti            | Konteks         |
| ----------- | --------------- | --------------- |
| req         | request         | Server handler  |
| res         | response        | Server response |
| body        | isi pesan       | JSON, form      |
| header      | metadata        | Auth, CORS      |
| status      | status HTTP     | error handling  |
| code        | kode error/http | debugging       |
| data        | payload         | hasil backend   |

Contoh JavaScript Express:

```
app.get("/api", (req, res) => {
  res.send("OK");
});
```

Penjelasan kata per kata:

* `app.get` = definisi handler HTTP GET
* `"/api"` = rute endpoint
* `(req, res)` = placeholder request & response
* `res.send("OK")` = kirim respons ke client

Bantuan:

```
npm help
```

---

## 2.4 Placeholder JSON Key-Value

Digunakan pada API berbasis JSON / Web services.

| Placeholder | Arti             | Konteks         |
| ----------- | ---------------- | --------------- |
| id          | identitas        | objek           |
| name        | nama entitas     | user/item       |
| title       | judul            | blog, UI        |
| value       | isi              | konfigurasi     |
| type        | jenis            | pengklasifikasi |
| created_at  | waktu dibuat     | database        |
| updated_at  | waktu diperbarui | perubahan data  |
| metadata    | info tambahan    | file/log        |

Contoh JSON:

```
{
  "id": 1,
  "name": "John Doe"
}
```

Penjelasan kata per kata:

* `{}` = objek JSON
* `"id": 1` = pasangan key-value dengan integer
* `"name": "John Doe"` = pasangan key-value string

Bantuan CLI JSON:

```
jq --help
```

---

### Ringkasan progress Bab 2 sejauh ini

✔ 2.1 URL & endpoint
✔ 2.2 Query param
✔ 2.3 Request/response
✔ 2.4 JSON placeholder

---

# Bagian Networking — Dokumen Lengkap Placeholder

## A. Addressing & Names (Alam alamat dan nama host)

* **`localhost`**

  * Arti: host loopback (mesin lokal).
  * Konteks: testing lokal, binding server development.
  * Variasi: `127.0.0.1`, `::1` (IPv6).
  * Risiko: aman untuk docs; jangan gunakan sebagai publik endpoint.
  * Contoh: `http://localhost:8080/`

* **`127.0.0.1` / `::1`**

  * Arti: alamat loopback IPv4 / IPv6.
  * Konteks: debugging, service lokal.
  * Variasi: `127.0.0.2`..`127.255.255.254` juga loopback-range.
  * Risiko: aman; perhatikan perbedaan IPv4/IPv6 ketika bind.

* **`example.com`, `example.org`, `example.net`, `.test`, `.invalid`**

  * Arti: domain yang direservasi untuk contoh/dokumentasi (IANA/RFC).
  * Konteks: contoh URL, email, hostnames.
  * Variasi: `api.example.com`, `dev.example.com`.
  * Risiko: aman — justru direkomendasikan untuk docs.

* **`<hostname>`, `<fqdn>`**

  * Arti: nama host / Fully Qualified Domain Name placeholder.
  * Konteks: konfigurasi server, SSL CN, README.
  * Variasi: `web01.example.com`, `db-node-1.local`.
  * Risiko: pastikan FQDN valid sesuai DNS produksi.

* **`<interface>`**

  * Arti: nama antarmuka jaringan (contoh: `eth0`, `ens3`, `wlan0`).
  * Konteks: konfigurasi network, ip link, ip addr.
  * Risiko: perbedaan nama interface antar distro/OS.

* **`<mac>` / `xx:xx:xx:xx:xx:xx`**

  * Arti: MAC address placeholder.
  * Konteks: dokumentasi switch, ARP, binding DHCP.
  * Risiko: jangan gunakan MAC nyata publik; gunakan range diuji (ex: `00:00:5E:00:53:00` sebagai contoh IANA).

## B. CIDR, Ranges & Reserved Blocks

* **`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`**

  * Arti: private IPv4 ranges (RFC1918).
  * Konteks: LAN, NAT, contoh topologi.
  * Risiko: aman untuk docs; perhatikan overlap saat menggabungkan jaringan.

* **`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`**

  * Arti: TEST-NET ranges (RFC 5737) untuk dokumentasi.
  * Konteks: contoh konfigurasi IP di docs (tidak dirutekan di internet).
  * Risiko: aman — memang disediakan untuk tujuan ini.

* **`0.0.0.0`**

  * Arti: unspecified / bind-all address.
  * Konteks: server binding (bind to all interfaces).
  * Risiko: exposing service ke semua interface — pahami keamanan (firewall).

* **`255.255.255.255`**

  * Arti: limited broadcast.
  * Konteks: broadcast messaging, DHCP DISCOVER.
  * Risiko: gunakan dengan hati-hati; tidak untuk routing.

* **`::/0`, `fe80::/10`, `2001:db8::/32`**

  * Arti: IPv6 default route, link-local range, documentation prefix (RFC3849).
  * Konteks: IPv6 addressing, examples.
  * Risiko: `2001:db8::/32` hanya untuk docs.

## C. DNS & Records

* **`<fqdn>` / `hostname`**

  * Arti/konteks: nama host lengkap, DNS mapping.
* **`A`, `AAAA`**

  * Arti: DNS record tipe A (IPv4) / AAAA (IPv6).
  * Placeholder: `example.com. IN A 192.0.2.1`
* **`CNAME`**

  * Arti: alias name.
  * Contoh: `www.example.com. IN CNAME example.com.`
  * Catatan deprecated dalam beberapa konteks (CNAME root usage discouraged).
* **`MX`**

  * Arti: mail exchanger record.
  * Contoh: `example.com. IN MX 10 mail.example.com.`
* **`TXT`**

  * Arti: text record (SPF, DKIM).
  * Placeholder umum: `v=spf1 include:example.com -all`
* **`SRV`**

  * Arti: service locator (SIP, XMPP).
  * Contoh: `_sip._tcp.example.com. IN SRV 10 5 5060 sip.example.com.`
* **`PTR`**

  * Arti: reverse DNS pointer record.
* **`SOA`**

  * Arti: start of authority.
* **`NS`**

  * Arti: nameserver record.
* **`<dns_server>`** / `8.8.8.8` (contoh)

  * Arti: placeholder resolver.
  * Risiko: jangan hardcode production resolvers di docs; gunakan contoh atau variabel.

## D. Ports & Services (Well-known / Registered / Ephemeral)

* **`<port>` / `80`, `443`, `22`, `25`, `53`, `123`, `3389`, `3306`, `5432`**

  * Arti: common ports (HTTP, HTTPS, SSH, SMTP, DNS, NTP, RDP, MySQL, Postgres).
  * Konteks: firewall rules, service binding.
  * Risiko: jangan expose port sensitif tanpa auth/firewall.

* **`<ephemeral_port>`**

  * Arti: port client ephemeral (OS assigned, biasanya 49152–65535 or 32768–60999).
  * Catatan: rentang tergantung OS/kernel.

* **`<protocol>`** — `tcp`, `udp`, `icmp`, `sctp`

  * Arti: transport protocol.
  * Konteks: iptables/nftables rules, socket programming.

## E. Routing, BGP, IGP, ASN

* **`<gateway>` / `gw`**

  * Arti: next-hop gateway IP.
  * Konteks: default route, static routes.

* **`<route>` / `0.0.0.0/0`**

  * Arti: routing entry or default route.
  * Konteks: static route configuration.

* **`AS<number>` / `65000`, `65534`**

  * Arti: Autonomous System Number (private ranges 64512–65534).
  * Konteks: BGP config, route-target.
  * Risiko: gunakan AS private ranges untuk docs (IANA reserved ranges).

* **`BGP` specific placeholders**:

  * `neighbor`, `peer_ip`, `peer_as`, `local_as`, `route_map`, `prefix_list`, `community`
  * Arti: konfigurasi neighbor/peering.
  * Contoh: `neighbor 203.0.113.2 remote-as 65500`
  * Deprecated/historical: `no synchronization` (BGP synchronization is historical, rarely used now).

* **`OSPF` / `ISIS` placeholders**:

  * `area`, `area_id`, `router_id`, `network`, `cost`, `metric`
  * Konteks: IGP configuration.

* **`next-hop`**, **`metric`**, **`preference`**, **`route-map`**

  * Arti: atribut routing.

## F. Switching, VLAN, STP, L2 Concepts

* **`vlan<number>` / `vlan10`**

  * Arti: Virtual LAN identifier.
  * Konteks: switch config, tagging (802.1Q).
  * Risiko: VLAN ID 0/4095 special cases.

* **`trunk` / `access`**

  * Arti: interface mode.
  * Contoh: `switchport mode trunk`, `switchport access vlan 10`.

* **`STP` placeholders**: `root_bridge`, `bridge_priority`, `port_cost`, `bpdu`

  * Arti: Spanning Tree Protocol elements.

* **`mac_table`, `fdb`**

  * Arti: forwarding database / MAC address table.

## G. Wireless / Radio

* **`SSID`**

  * Arti: network name.
  * Konteks: config AP, client connect.
  * Risiko: jangan publish SSID produksi yang sensitif.

* **`BSSID`**

  * Arti: MAC address of AP (basic service set identifier).

* **`RSSI`, `SNR`, `dBm`**

  * Arti: signal strength/quality metrics.

* **`channel`**, **`band`** (`2.4GHz`, `5GHz`, `6GHz`)

  * Arti: radio frequency channel.

* **`wpa2`, `wpa3`, `psk`, `eap`**

  * Arti: security modes / auth methods.

## H. DHCP, ARP, NAT, PAT

* **`dhcp` placeholders**: `lease_time`, `dhcp_pool`, `start_ip`, `end_ip`, `gateway`, `dns_servers`

  * Arti: configuration of DHCP server/pool.

* **`arp_table`**, **`arp_entry`**, **`arp_ip`/`arp_mac`**

  * Arti: ARP mapping.

* **`NAT`, `SNAT`, `DNAT`, `MASQUERADE`, `PAT`**

  * Arti: network address translation types.
  * Contoh: `iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE`
  * Risiko: NAT hides addressing; be explicit in docs about direction and security.

## I. VPN / Tunneling / Overlay

* **`tun`, `tap`**

  * Arti: virtual network interfaces (layer3/level2).
  * Konteks: OpenVPN, WireGuard.

* **`WireGuard` placeholders**: `private_key`, `public_key`, `peer`, `endpoint`, `AllowedIPs`

  * Contoh config snippet:

    ```
    [Peer]
    PublicKey = <peer_pubkey>
    AllowedIPs = 10.0.0.2/32
    ```

* **`ipsec` placeholders**: `psk`, `cert`, `ike`, `tunnel`

  * Arti: IPsec params.

* **`GRE`, `VXLAN`, `L2TP`, `PPTP`**

  * Arti: tunneling protocols (PPTP deprecated/insecure; note as deprecated).
  * Risiko: PPTP deprecated; avoid in production.

* **`overlay` placeholders**: `vxlan_vni`, `vni`, `vtep`, `underlay`, `overlay_subnet`

  * Arti: virtual overlay networks.

## J. Firewall, ACL, Security Controls

* **`iptables` / `nftables` placeholders**: `INPUT`, `OUTPUT`, `FORWARD`, `PREROUTING`, `POSTROUTING`, `chain`, `rule`, `target`

  * Contoh: `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`

* **`acl`** (access-list) placeholders: `permit`, `deny`, `src`, `dst`, `proto`, `eq` (equal port)

  * Contoh Cisco-like: `access-list 100 permit tcp any host 192.0.2.10 eq 80`

* **`security_group`**, **`sg_rule`** (Cloud)

  * Arti: cloud-native firewall sets (AWS, Azure, GCP).

* **`ids` / `ips`** placeholders: `snort_rule`, `alert`, `signature_id`, `sid`

  * Arti: intrusion detection/prevention identifiers.

* **`tls_cert`**, **`crt`**, **`pem`**, **`csr`**, **`ocsp`**, **`ca_bundle`**

  * Arti: certificate placeholders for TLS.
  * Risiko: never commit private key (`.key`) — use `REPLACE_ME` or secret manager.

## K. ICMP, TCP, UDP, Protocol Meta

* **`icmp_type`**: `echo-request (8)`, `echo-reply (0)`, `destination-unreach`

  * Konteks: ping/troubleshoot.

* **`tcp_flags`**: `SYN`, `ACK`, `RST`, `FIN`, `PSH`, `URG`

  * Arti: TCP handshake/flags; used in firewall rules or packet-craft examples.

* **`sequence`, `ack`**

  * Arti: TCP sequence/ack numbers.

* **`udp_port`**, **`udp_payload`**

## L. Multicast, Anycast, IGMP, PIM

* **`multicast_group`**: `224.0.0.0/4` (IPv4), `ff00::/8` (IPv6)

  * Arti: multicast group address placeholder.
  * Contoh: `224.0.0.1`

* **`igmp`, `pim`**, **`rp_address`** (Rendezvous Point)

  * Arti: multicast control protocols.

* **`anycast`**

  * Arti: same IP announced from multiple locations.

## M. Telephony / VoIP

* **`SIP` placeholders**: `sip:user@example.com`, `sip_server`, `sip_port`, `contact`, `from`, `to`, `call-id`
* **`RTP` placeholders**: `ssrc`, `rtp_port`, `rtcp_port`, `rtp_payload_type`
* **`SIP Credentials`**: `sip_user`, `sip_pass` — treat as secret.

## N. Cloud & IoT addressing / metadata

* **`instance_id`**, **`vm_id`**, **`project_id`**, **`region`**, **`zone`**

  * Arti: cloud resource placeholders (AWS, GCP, Azure).
* **`public_ip`**, **`private_ip`**
* **`device_id`**, **`thing_id`**, **`mac`**, **`firmware_version`** (IoT)

  * Risiko: device identifiers can be sensitive; anonymize test data.

## O. Monitoring / Telemetry / Observability (Networking context)

* **`flow_id`**, **`netflow`**, **`s_flow`**, **`collection_port`**, **`exporter_ip`**

  * Arti: network flow telemetry placeholders.

## P. Deprecated / Historical Placeholders (ditandai)

* **`DECnet`, `X.25` placeholders** — legacy network protocols (historic).
* **`PPTP`** — deprecated VPN protocol (insecure).
* **`RIP v1` related placeholders** — legacy IGP (still in use niche).
* **`classful` network notation references** (`class A/B/C` hard-coding) — sudah digantikan oleh CIDR; tetap dicatat sebagai sejarah.

## Q. Helper / Operational Placeholders & Tools

* **`<netns>`** (network namespace), **`<bridge>`**, **`br0`**, **`veth0`**

  * Arti: Linux network namespace and bridge interface placeholders.

* **`<ifupdown>`, `<systemd-networkd>`, `<NetworkManager>`**

  * Arti: network manager placeholders for OS-level configuration.

* **`packet_capture_file.pcap`**, **`tshark_filter`**, **`tcpdump_expr`**

  * Arti: capture file and capture filter placeholders (e.g., `tcpdump -i eth0 port 80`).

## R. Contoh Snippet — Beberapa representatif dengan penjelasan kata-per-kata

### Contoh 1 — iptables NAT (penjelasan singkat tiap token)

```bash
iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE
```

* `iptables` → utilitas konfigurasi firewall/packet filtering Linux legacy (nftables modern alternatif).
* `-t nat` → table NAT (network address translation).
* `-A POSTROUTING` → append rule ke chain POSTROUTING (setelah routing decision).
* `-s 10.0.0.0/8` → source matching network 10.0.0.0/8.
* `-o eth0` → output interface eth0.
* `-j MASQUERADE` → target action: masquerade source IP (dynamic SNAT).

**Catatan**: `iptables` masih umum; `nftables` direkomendasikan untuk setup baru.

### Contoh 2 — BGP neighbor (format Cisco-like, token explanation)

```
router bgp 65000
  neighbor 198.51.100.2 remote-as 65001
  neighbor 198.51.100.2 description PEER-1
  neighbor 198.51.100.2 update-source Loopback0
```

* `router bgp 65000` → enable BGP instance with local AS 65000.
* `neighbor 198.51.100.2 remote-as 65001` → define neighbor IP and remote AS.
* `description` → human label for admin.
* `update-source` → the source interface/IP for BGP session.

**Catatan**: gunakan private AS for docs (64512–65534) atau documentation prefixes.

### Contoh 3 — DNS SRV (penjelasan singkat)

```
_sip._tcp.example.com. 3600 IN SRV 10 5 5060 sip1.example.com.
```

* `_sip._tcp.example.com.` → service + proto + domain.
* `3600` → TTL seconds.
* `IN SRV` → SRV record type.
* `10` → priority.
* `5` → weight.
* `5060` → port.
* `sip1.example.com.` → target host.

## S. Regex untuk Deteksi Placeholder Networking di Repo

Gunakan regex gabungan untuk scanning (contoh):

```
\b(127\.0\.0\.1|localhost|example\.com|10\.\d+\.\d+\.\d+|192\.168\.\d+\.\d+|0\.0\.0\.0|REPLACE_ME|MASQUERADE|PPTP|ipsec|private_key|public_key|certificate)\b
```

* `\b` = word boundary.
* Tambahkan pattern khusus (`AS\d+`, `vlan\d+`, `ff[0-9a-f:]+`) sesuai kebutuhan.

## T. Risiko dan Kebijakan Praktis (ringkasan)

1. **Jangan commit kunci/privat data**: private keys, PSKs, actual device MACs, production IPs. Gunakan `REPLACE_ME` dan secrets manager.
2. **Gunakan ranges yang direkomendasikan untuk docs**: RFC5737 testnets, RFC3849 IPv6 documentation prefix.
3. **Tandai deprecated**: mis. PPTP, X.25, classful assumptions. Sertakan catatan mitigasi.
4. **Cross-platform naming**: dokumentasikan per-OS (contoh `eth0` vs `enp3s0`).
5. **CI checks**: gunakan pre-commit hooks untuk scanning placeholder sensitif (lihat contoh pre-commit sebelumnya).

---

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
