# **Kurikulum Masterclass: The Art of SwayWM Theming**

Membangun *environment* SwayWM yang estetik (sering disebut "*ricing*" dalam komunitas Linux) membutuhkan pemahaman mendalam tentang bagaimana komponen-komponen terpisah bekerja sama melalui konfigurasi teks. Kurikulum ini dirancang secara logis, dimulai dari fondasi hingga teknik manipulasi tingkat lanjut, dengan fokus pada CLI dan Arch Linux.

Sebelum kita melihat kurikulumnya, mari kita selesaikan sesi mini bahasa Inggris teknis untuk konteks ini.

---

### 🇬🇧 English Corner: Technical & Professional Context

Dalam dunia konfigurasi (*configuration*), Anda akan sering menemukan istilah **"Attributes"** dan **"Properties"**.

**1. Vocabulary Focus:**
* **Prerequisite** *(Noun)*: Sesuatu yang wajib dimiliki atau dilakukan sebelum melakukan hal lain (Prasyarat).
    * *Example:* "Understanding the file system hierarchy is a **prerequisite** for this course." (Memahami hierarki sistem file adalah prasyarat untuk kursus ini.)
* **To override** *(Verb)*: Mengganti pengaturan default atau pengaturan yang sudah ada dengan pengaturan baru.
    * *Example:* "You can **override** the default background color by editing the config file." (Anda dapat menimpa warna latar belakang default dengan mengedit file konfigurasi.)

**2. Grammar Focus: Imperative Sentences in Documentation**
Dokumentasi teknis sering menggunakan *Imperative Mood* (kalimat perintah) yang langsung dan efisien.
* *Structure:* [Verb] + [Object] + [Complement].
* *Example:* "**Define** the variable **colors** at the top of the file."
    * *Analisis:* Subjek ("You") dihilangkan agar kalimat lebih *concise* (ringkas) dan profesional.

---

### 📋 Kurikulum Kelas: SwayWM Theming Mastery

Berikut adalah rancangan struktur kelas yang saya tawarkan. Alur ini disusun berdasarkan dependensi: kita tidak bisa mengatur *bar* (panel) jika kita belum paham variabel warna di Sway, dan kita tidak bisa membuat skrip ganti tema jika kita belum paham sintaks dasar CLI-nya.

#### **Fase 0: Prerequisites & Philosophy (Pondasi)**
*Tujuan: Memahami peta jalan dan mempersiapkan mental serta tools.*
* **0.1. Konsep Desktop Wayland vs X11:** Mengapa *theming* di Sway berbeda dengan i3wm (penting untuk memilih tools).
* **0.2. Struktur File Konfigurasi Sway:** Memahami lokasi `~/.config/sway/config`, izin file, dan cara *reload* tanpa logout.
* **0.3. Terminologi Desain:** Memahami *Padding*, *Margin*, *Border*, dan *Gaps*.
* **0.4. Alat Bantu (Tools):** Pengenalan `grim` & `slurp` (untuk color picking), dan `man pages` (dokumentasi resmi).

#### **Fase 1: Core Sway Configuration (Internal Theming)**
*Tujuan: Menguasai tampilan jendela (window) dan perilaku dasar tanpa aplikasi tambahan.*
* **1.1. Syntax & Variables:** Cara mendeklarasikan variabel (`set $variable value`) untuk penggunaan ulang warna (DRY Principle - *Don't Repeat Yourself*).
* **1.2. Client Colors (Window Decoration):** Mengupas tuntas kelas warna: `client.focused`, `client.unfocused`, `client.urgent`. Apa arti setiap baris hex code di sana.
* **1.3. Gaps & Borders:** Mengatur jarak antar jendela (gaps inner/outer) dan ketebalan garis tepi untuk estetika minimalis.
* **1.4. Font Handling:** Cara pango *font rendering* bekerja di Sway.

#### **Fase 2: The Ecosystem (Komponen Eksternal)**
*Karena Sway hanyalah Window Manager, estetika utama datang dari alat pihak ketiga. Fokus pada tools berbasis Wayland/CLI.*
* **2.1. Wallpaper Management:** Menggunakan `swaybg` atau `hyprpaper` (sebagai alternatif modern).
* **2.2. Status Bar (Waybar):** Ini adalah materi terberat.
    * Struktur JSON untuk modul.
    * Struktur CSS untuk *styling* (seperti membuat web).
* **2.3. Application Launcher (Wofi/Rofi-wayland):** Mengubah menu aplikasi agar senada dengan tema.
* **2.4. Notification Daemon (Mako/SwayNC):** Mengatur tampilan notifikasi pop-up.

#### **Fase 3: System-wide Consistency (Penyatuan Tema)**
*Tujuan: Agar aplikasi (File Manager, Browser, Editor) tidak terlihat asing ("belang") dengan tema Sway.*
* **3.1. GTK & QT Theming:** Menggunakan `nwg-look` (atau edit file `.ini` manual) untuk menyamakan tema aplikasi GUI.
* **3.2. Cursor & Icon Themes:** Instalasi dan penerapan ikon.
* **3.3. Terminal Styling:** Sinkronisasi warna terminal (Alacritty/Kitty/Foot) dengan warna Sway.

#### **Fase 4: Advanced Scripting & Automation (Dunia Profesional)**
*Tujuan: Mengganti tema secara instan dan dinamis.*
* **4.1. IPC (Inter-Process Communication):** Menggunakan `swaymsg` untuk mengubah properti (seperti gap atau border) secara langsung dari terminal tanpa reload file.
* **4.2. Integrasi Script (Bash/Python):** Membuat skrip sederhana untuk mengganti wallpaper dan warna secara bersamaan (Konsep *Theme Switcher*).
* **4.3. Pywal/Wallust:** Pengenalan *auto-generate* warna berdasarkan wallpaper (Opsional tapi sangat populer).

#### **Fase 5: Error Handling & Debugging**
* **5.1. Validasi Konfigurasi:** Cara membaca error log Sway (`sway -d`).
* **5.2. Fallback Mechanism:** Apa yang terjadi jika font atau gambar tidak ditemukan.

---

### 🛡️ Standar Kualitas Materi

Untuk setiap modul di atas, disertakan format berikut saat kita masuk ke materi:
1.  **Identitas Tools:** Bahasa pemrograman pembuatnya (C, Rust, Go), lisensi, dan negara asal/komunitas pengembang (jika tersedia informasinya).
2.  **Sumber Referensi:** Link ke Repository resmi (GitHub/GitLab/SourceHut) dan Wiki Arch Linux.
3.  **Sintaks:** Penjelasan baris per baris.
4.  **Penanganan Error:** Solusi jika konfigurasi gagal dimuat.

---
<!---->
<!-- **Langkah Selanjutnya:** -->
<!---->
<!-- Apakah **Kurikulum** di atas sudah mencakup semua yang Anda bayangkan, atau ada bagian spesifik (misalnya animasi atau *transparency/blur*) yang ingin Anda tambahkan secara eksplisit ke dalam salah satu fase? -->
<!---->
<!-- Jika Anda setuju dengan struktur ini, kita akan mulai dari **Fase 0: Prerequisites & Philosophy**. Beritahu saya jika saya boleh melanjutkan. -->
