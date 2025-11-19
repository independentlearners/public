# **Mastering Notifications & Popups in SwayWM**

Berikut adalah **Rancangan Kurikulum (Syllabus Design)**. Tujuannya adalah membawa Anda dari pemahaman konsep dasar hingga mampu membuat sistem notifikasi yang *highly customized*, estetis, dan fungsional, setara dengan desktop environment modern namun tetap mempertahankan prinsip ringan (lightweight) khas Sway.

---

### **Kurikulum: Advanced Notification & Popup Customization in SwayWM**

#### **Fase 0: Prerequisites & Foundations (Prasyarat & Fondasi)**
Sebelum menyentuh konfigurasi, kita harus memastikan fondasi pengetahuan dan sistem sudah siap.
* **Teknis:**
    * Memahami konsep **DBus** (Desktop Bus) dan peranannya dalam pengiriman pesan antar aplikasi di Linux.
    * Memahami protokol `org.freedesktop.Notifications`.
    * Perbedaan notifikasi di X11 (`dunst`) vs Wayland native (`mako` atau `swaync`).
* **Bahasa Inggris:**
    * Vocabulary: *Daemon, invoke, dismiss, urgency, transient, markup.*
    * Grammar: *Passive voice* dalam dokumentasi teknis.

#### **Fase 1: Tool Selection & Anatomy (Pemilihan Alat & Anatomi)**
Kita akan membedah alat yang tersedia di repositori Arch Linux dan memilih yang paling sesuai dengan filosofi Sway (CLI-based, ringan) namun estetis.
* **Mako**: *Lightweight notification daemon* standar untuk Wayland (fokus utama kita).
* **SwayNC (Sway Notification Center)**: Alternatif jika Anda menginginkan panel kontrol notifikasi (mirip macOS/Windows 11) yang tetap estetik.
* **Sumber & Identitas:**
    * Review repositori (GitHub/Sourcehut).
    * Bahasa pemrograman yang digunakan alat tersebut (C/Rust/Go).
    * Lisensi dan Komunitas.

#### **Fase 2: Configuration Syntax & Styling (Sintaks & Gaya)**
Ini adalah inti dari estetika. Kita akan mempelajari cara menulis file konfigurasi secara manual.
* **Syntax Deep Dive:** Memahami struktur file konfigurasi (INI-style atau TOML).
* **Styling (CSS-like logic):**
    * Mengatur *padding, margin, border-radius* (sudut melengkung).
    * Tipografi (Font, ukuran, berat).
    * Warna dan transparansi (Alpha channel).
* **Grouping & Criteria:** Bagaimana mengelompokkan notifikasi berdasarkan aplikasi (misal: notifikasi Slack beda warna dengan notifikasi System).

#### **Fase 3: Scripting & Integration (Scripting & Integrasi)**
Membuat notifikasi menjadi dinamis dan fungsional, bukan hanya teks diam.
* **Command Line Interface (CLI):** Penggunaan `notify-send` secara *advance*.
* **Actions & Buttons:** Membuat tombol dalam notifikasi (misal: "Reply" atau "Open").
* **Integration Scripts:**
    * Membuat popup OSD (*On-Screen Display*) untuk Volume & Brightness (Kecerahan) menggunakan bash script dan notifikasi.
    * Menangani ikon (SVG/PNG pathing).
* **English Focus:** *Imperative sentences* dalam scripting (e.g., "Execute this command if...").

#### **Fase 4: Error Handling & Debugging (Penanganan Error)**
Bagian krusial agar Anda mandiri saat terjadi kegagalan.
* **Reading Journalctl:** Melacak log error dari layanan notifikasi.
* **DBus Monitoring:** Menggunakan `dbus-monitor` untuk melihat apakah sinyal notifikasi terkirim.
* **Common Issues:** Notifikasi tidak muncul, ikon hilang, atau *overlap*.

#### **Fase 5: Final Project & Optimization (Proyek Akhir & Optimasi)**
* Menyatukan semua konfigurasi.
* Memastikan *footprint* memori tetap rendah.
* Studi banding estetika dengan distro lain (misal: ricing gaya Nordic atau Cyberpunk).

---

### **[Fase 0: Prerequisites & Foundations](#satu)**

Sebelum kita bisa membuat notifikasi yang cantik, kita harus memahami **mekanisme** di belakang layar dan menyiapkan alat (tools) yang tepat. Di Linux, notifikasi tidak muncul begitu saja; ada protokol standar yang mengaturnya.

#### **1. English for Professional Interaction (Bahasa Inggris untuk Interaksi Profesional)**

Dalam membaca dokumentasi *notification daemon*, Anda akan sering menemukan kalimat teknis. Mari kita bedah satu kalimat fundamental yang sering muncul di dokumentasi resmi:

> *"The notification daemon listens for messages on the system bus."*
> (Daemon notifikasi mendengarkan pesan di bus sistem.)

**Bedah Gramatika & Kosakata (Grammar & Vocabulary Breakdown):**

  * **The notification daemon** (Noun Phrase / Subjek):
      * *The*: Article (kata sandang) penentu, merujuk pada objek spesifik.
      * *Notification*: Adjective (kata sifat) yang menjelaskan jenis daemon.
      * *Daemon*: Noun (kata benda). Dalam IT, ini adalah program yang berjalan di latar belakang (*background process*) tanpa interaksi langsung pengguna.
  * **Listens** (Verb / Kata Kerja):
      * Berasal dari kata dasar *listen*.
      * Akhiran **-s** menandakan *Simple Present Tense* untuk subjek tunggal (singular) orang ketiga (it/the daemon). Ini menunjukkan fakta atau fungsi yang selalu aktif.
  * **For** (Preposition / Kata Depan):
      * Digunakan untuk menunjukkan tujuan atau objek yang ditunggu. *Listen for* = mendengarkan untuk menangkap sesuatu.
  * **Messages** (Noun / Objek):
      * Bentuk jamak (*plural*) dari *message*. Dalam konteks ini, pesan adalah data notifikasi yang dikirim aplikasi.
  * **On** (Preposition):
      * Menunjukkan lokasi/medium.
  * **The system bus** (Noun Phrase / Keterangan Tempat):
      * Jalur komunikasi antar software di Linux (biasanya DBus).

-----

#### **2. Konsep Teknis: The Desktop Bus (DBus)**

Sebelum menginstal alat, pahami alurnya:

1.  Aplikasi (misal: Telegram, Script Error) mengirim sinyal.
2.  Sinyal dikirim ke **DBus** (protokol pesan).
3.  **Notification Daemon** (yang akan kita instal) menangkap sinyal itu.
4.  Daemon menggambar jendela popup di layar Sway Anda.

Jika error terjadi (notifikasi tidak muncul), biasanya rantai putus di nomor 3 (daemon belum jalan) atau nomor 2 (DBus bermasalah).

-----

#### **3. Pemilihan Alat (Tool Selection): Mako**

Karena Anda pengguna **Arch Linux**, mencintai **Sway**, dan mengutamakan **CLI/Lightweight**, alat terbaik untuk kurikulum ini adalah **Mako**.

  * **Identitas Alat:**
      * **Nama:** Mako.
      * **Pengembang:** Simon Ser (emersion) — *Salah satu kontributor utama Wayland dan Sway*.
      * **Bahasa Pemrograman:** C (Sangat cepat, *footprint* memori sangat kecil/ringan).
      * **Lisensi:** MIT (Open Source, bebas dimodifikasi).
      * **Karakteristik:** Native Wayland, konfigurasi berbasis teks, tidak ada GUI settings (sesuai preferensi Anda).

-----

#### **4. Persiapan & Instalasi (Preparation & Installation)**

Sekarang, mari kita instal **Mako** dan satu alat bantu untuk mengirim notifikasi tes bernama `libnotify`.

Silakan buka terminal Anda (misal: `foot` atau `alacritty`). Ketik perintah berikut, namun **JANGAN DI-ENTER DULU** sebelum membaca bedah kodenya di bawah ini agar Anda paham total.

**Perintah:**

```bash
sudo pacman -S mako libnotify
```

**Bedah Kode Per-Kata & Simbol (Word-by-Word & Symbol Breakdown):**

1.  **`sudo`**
      * **Jenis:** Perintah / *Command*.
      * **Arti:** *SuperUser DO*.
      * **Fungsi:** Memberikan hak akses administrator (root). Kita butuh ini karena menginstal aplikasi akan mengubah sistem file utama di `/usr/bin`.
2.  **`     ` (Spasi / Space)**
      * **Fungsi:** Pemisah argumen. Shell (bash/zsh) membaca spasi sebagai tanda perpindahan dari satu instruksi ke instruksi berikutnya. Tanpa spasi, sistem akan bingung membaca `sudopacman`.
3.  **`pacman`**
      * **Jenis:** Program / *Binary name*.
      * **Arti:** *Package Manager*.
      * **Fungsi:** Alat manajemen paket bawaan Arch Linux untuk menginstal, menghapus, dan memperbarui perangkat lunak.
4.  **`     ` (Spasi)**
      * Pemisah.
5.  **`-S`**
      * **`-` (Hyphen/Dash):** Simbol ini memberi tahu program bahwa karakter berikutnya adalah sebuah **opsi** atau **flag**, bukan nama file.
      * **`S` (Huruf Besar):** Singkatan dari **Sync** (Sinkronisasi).
      * **Fungsi:** Memerintahkan pacman untuk menyinkronkan database paket lokal dengan repositori internet, lalu menginstal paket yang diminta.
6.  **`     ` (Spasi)**
      * Pemisah.
7.  **`mako`**
      * **Jenis:** Argumen (Nama Paket).
      * **Fungsi:** Target utama yang ingin kita instal (daemon notifikasi).
8.  **`     ` (Spasi)**
      * Pemisah antar nama paket. Kita bisa menginstal banyak paket sekaligus dengan memisahkannya menggunakan spasi.
9.  **`libnotify`**
      * **Jenis:** Argumen (Nama Paket Tambahan).
      * **Fungsi:** Paket ini berisi perintah `notify-send`. Kita WAJIB menginstalnya untuk mengetes apakah Mako bekerja atau tidak nantinya. Tanpa ini, kita tidak punya cara mudah memicu notifikasi dari terminal.

-----

#### **5. Validasi Awal (Initial Validation)**

Setelah Anda menjalankan perintah di atas dan sukses (tidak ada error), kita perlu memastikan Mako sudah terinstal dengan benar.

Jalankan perintah ini:

```bash
mako --version
```

**Jika Error:**
Jika muncul pesan `bash: mako: command not found`, artinya instalasi gagal atau path belum terbaca.
**Solusi:** Cek koneksi internet dan ulangi `sudo pacman -Syu mako`.

-----

