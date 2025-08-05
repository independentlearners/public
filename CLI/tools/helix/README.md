# **Helix**
Kurikulum pembelajaran yang komprehensif dan mendalam untuk topik **Helix Editor**, sebuah editor teks berbasis terminal. Kurikulum ini dirancang untuk membawa Anda dari tingkat pemula (foundation) hingga ahli (expert/enterprise) dengan pendekatan yang logis dan berurutan.

-----

## Kurikulum Pembelajaran: Helix Editor

**Target Pembelajar:** Individu yang ingin menguasai editor teks modern berbasis terminal. Cocok untuk pengembang perangkat lunak, administrator sistem, penulis, atau siapa pun yang bekerja dengan teks dan kode. Kurikulum ini dirancang agar dapat dipahami bahkan oleh mereka yang tidak memiliki latar belakang pemrograman, namun memiliki keinginan kuat untuk belajar.

**Hasil Pembelajaran (Learning Outcomes):**
Setelah menyelesaikan kurikulum ini, Anda akan dapat:

  * Memahami filosofi dan model pengeditan **modal** (modal editing) yang digunakan oleh Helix.
  * Menavigasi, memilih, dan memodifikasi teks dengan sangat efisien menggunakan **seleksi multi-cursor** secara alami.
  * Mengkonfigurasi Helix sesuai dengan kebutuhan pribadi, termasuk tema, ekstensi, dan pemetaan kunci (keybindings).
  * Mengintegrasikan Helix dengan alat pengembangan lainnya seperti **Language Server Protocol (LSP)**, **Tree-sitter**, dan **sistem kontrol versi (VCS)**.
  * Mengotomatisasi tugas-tugas berulang dan membuat alur kerja (workflow) yang produktif.
  * Menyesuaikan Helix dengan menambahkan fungsionalitas baru atau memperbaikinya dari kode sumber (source code) secara mandiri.

**Prasyarat:**

  * **Wajib:** Memiliki pemahaman dasar tentang penggunaan **terminal/command line interface (CLI)**.
  * **Opsional (Direkomendasikan):** Pengalaman dasar dengan sistem operasi berbasis **Unix-like**, seperti **Linux** atau **macOS**.
  * **Opsional (untuk modifikasi tingkat lanjut):** Pemahaman dasar bahasa pemrograman **Rust** (yang akan dijelaskan lebih lanjut di fase ahli).

**Alat Esensial:**

  * Terminal (Terminal Emulator) seperti **Alacritty, Kitty, atau WezTerm**.
  * Sistem Operasi **Arch Linux** atau OS lainnya.
  * **Git** untuk manajemen versi.
  * **Helix Editor** sendiri, juga dapat diinstal melalui manajer paket (package manager) atau dikompilasi dari sumber.

**Rekomendasi Waktu:**

  * **Fase 1 (Pemula):** Sekitar 1-2 minggu (tergantung frekuensi latihan).
  * **Fase 2 (Menengah):** Sekitar 2-4 minggu.
  * **Fase 3 (Mahir):** Sekitar 1-2 bulan.
  * **Fase 4 (Ahli):** Waktu tidak terbatas, berlanjut seiring pengalaman dan eksplorasi.

-----

### **Fase 1: Pemula (Foundation)**

**Level:** Pemula (Beginner)

Pada fase ini, Anda akan mempelajari dasar-dasar penggunaan Helix, filosofi pengeditannya, dan cara melakukan tugas-tugas dasar dengan efisien. Fokus utamanya adalah membiasakan diri dengan **model modal** dan **seleksi multi-cursor**.

#### **Modul 1: Pengantar Helix dan Filosofi Modal Editing**

**Deskripsi Konkret:**
Anda akan memahami apa itu Helix, mengapa ia berbeda dari editor lain seperti Vim, dan bagaimana filosofi **modal editing** bekerja. Modul ini adalah fondasi yang akan menentukan kecepatan dan efisiensi Anda ke depannya.

**Konsep Dasar dan Filosofi:**
Helix adalah editor teks modern yang terinspirasi dari Vim, namun dengan pendekatan yang lebih intuitif dan "sederhana". Filosofi utamanya adalah **"sebelum aksi, pilih objek"** atau dalam bahasa aslinya, **select first, then act**. Ini adalah kebalikan dari Vim yang menggunakan model `verb + noun` (misalnya, `d + w` untuk "hapus kata"). Di Helix, Anda akan selalu memilih teks terlebih dahulu (noun), lalu menentukan aksi (verb) yang ingin dilakukan (misalnya, `v + d` untuk "hapus seleksi visual").

**Terminologi Kunci:**

  * **Modal Editing:** Sebuah paradigma pengeditan di mana editor memiliki beberapa mode (misalnya, **normal mode, insert mode, select mode**) dan setiap mode memiliki serangkaian perintah yang berbeda. Ini mengurangi penggunaan tombol `Ctrl` dan `Alt` yang sering menyebabkan cedera tangan.
  * **Normal Mode:** Mode default di Helix di mana Anda dapat menavigasi, memilih, dan memodifikasi teks.
  * **Insert Mode:** Mode di mana Anda dapat mengetik teks seperti pada editor biasa.
  * **Select Mode:** Mode di mana Anda dapat memperluas atau mempersempit seleksi teks.
  * **Seleksi Multi-Cursor (Multi-cursor Selection):** Kemampuan untuk memiliki lebih dari satu kursor (atau titik seleksi) aktif pada saat yang sama, memungkinkan pengeditan simultan di beberapa lokasi.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Masuk ke **Normal Mode** (default): `ESC`
  * Masuk ke **Insert Mode:** `i`
  * Masuk ke **Select Mode:** `v`
  * Menyimpan file: `  :w `
  * Keluar dari editor: `  :q `
  * Membuka file: `hx <nama_file>`

**Daftar Isi:**

  * Sejarah Singkat dan Inspirasi Helix.
  * Perbedaan fundamental antara Helix dan Vim/Neovim.
  * Pengenalan mode-mode dasar: Normal, Insert, dan Select.
  * Demonstrasi filosofi `select first, then act`.
  * Latihan praktis: Navigasi dan pengeditan dasar.

**Sumber Referensi:**

  * [Dokumentasi Resmi Helix: Getting Started](https://www.google.com/search?q=https://docs.helix-editor.com/get-started.html)
  * [Dokumentasi Resmi Helix: `hx --tutor`](https://www.google.com/search?q=%5Bhttps://docs.helix-editor.com/tutorial.html%5D\(https://docs.helix-editor.com/tutorial.html\)) (Jalankan perintah ini di terminal untuk tutorial interaktif).

-----

#### **Modul 2: Navigasi dan Seleksi Efisien**

**Deskripsi Konkret:**
Modul ini akan mengajarkan Anda cara bergerak di dalam file dengan cepat dan melakukan seleksi teks yang presisi. Ini adalah langkah kunci untuk menguasai pengeditan yang efisien.

**Konsep Dasar dan Filosofi:**
Helix dirancang untuk menjaga tangan Anda di atas keyboard utama (home row). Gerakan yang sering digunakan dipetakan ke tombol-tombol yang mudah dijangkau. Konsep penting lainnya adalah **objek teks (text objects)**, yaitu unit-unit teks seperti kata, kalimat, atau blok kode yang dapat dipilih dengan satu perintah.

**Terminologi Kunci:**

  * **Home Row:** Baris tengah pada keyboard (`asdfjkl;`) tempat jari-jari Anda secara alami diletakkan.
  * **Text Objects:** Unit-unit teks yang dapat dipilih dengan cepat (contoh: `w` untuk "word"/kata, `p` untuk "paragraph"/paragraf, `a` untuk "argument"/argumen dalam fungsi).
  * **Jump List:** Riwayat navigasi yang memungkinkan Anda melompat kembali ke lokasi-lokasi sebelumnya.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Navigasi:
      * `h`, `j`, `k`, `l`: Kiri, Bawah, Atas, Kanan.
      * `w`, `b`: Lompat ke awal kata berikutnya/sebelumnya.
      * `(` dan `)`: Lompat ke awal/akhir kalimat.
      * `{` dan `}`: Lompat ke awal/akhir paragraf atau blok kode.
  * Seleksi (di Normal Mode):
      * `w` (tekan `w` dua kali): Memilih kata.
      * `p` (tekan `p` dua kali): Memilih paragraf.
      * `mi`: Memilih teks di dalam tanda kurung `()`.
      * `ma`: Memilih teks di dalam tanda kurung `()` dan kurungnya.
  * Manipulasi (setelah seleksi):
      * `d`: Hapus seleksi.
      * `y`: Salin (yank) seleksi.
      * `p`: Tempel (paste) seleksi.
      * `c`: Ganti (change) seleksi.

**Daftar Isi:**

  * Gerakan dasar kursor.
  * Penggunaan **multi-cursor** untuk seleksi.
  * Objek teks (text objects) dan cara menggunakannya.
  * Latihan praktis: Memilih, menyalin, dan memindahkan blok teks.

**Sumber Referensi:**

  * [Dokumentasi Resmi Helix: Navigasi](https://www.google.com/search?q=https://docs.helix-editor.com/keymap.html%23navigation)
  * [Video Tutorial YouTube: The Primeagen - Why I use Helix](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dy3n93T9y4C0)

-----

### **Fase 2: Menengah (Intermediate)**

**Level:** Menengah (Intermediate)

Pada fase ini, Anda akan memperdalam pemahaman tentang konfigurasi, manajemen file, dan penggunaan fitur-fitur yang lebih canggih. Anda akan mulai mengintegrasikan Helix ke dalam alur kerja pengembangan Anda.

-----

#### **Modul 3: Konfigurasi dan Personalisasi**

**Deskripsi Konkret:**
Anda akan mempelajari cara menyesuaikan tampilan dan perilaku Helix. Ini mencakup pengaturan tema warna, pemetaan kunci (keybindings), dan pengaturan global lainnya.

**Konsep Dasar dan Filosofi:**
Konfigurasi Helix disimpan dalam file **TOML** (Tom's Obvious, Minimal Language). Tidak seperti Vim yang menggunakan VimL atau Lua, Helix menggunakan format file yang lebih sederhana dan deklaratif. Konfigurasi ini memungkinkan Anda untuk menyesuaikan editor sesuai dengan kebutuhan, preferensi visual, dan kenyamanan ergonomis Anda.

**Terminologi Kunci:**

  * **TOML:** Format file konfigurasi minimalis yang mudah dibaca dan ditulis.
  * **Theme:** Tema warna yang menentukan tampilan editor (latar belakang, warna teks, dll.).
  * **Keybinding:** Pemetaan kunci keyboard ke sebuah perintah.

**Sintaks Dasar/Contoh Implementasi Inti:**
Lokasi default file konfigurasi:

  * **Linux/macOS:** `~/.config/helix/config.toml`

Contoh isi file `config.toml`:

```toml
theme = "tokyonight_night"

[editor]
line-number = "relative"
true-color = true
```

  * `theme = "tokyonight_night"`: Menentukan tema yang digunakan.
  * `[editor]` dan `line-number = "relative"`: Mengatur nomor baris menjadi relatif, yang sangat membantu navigasi dengan `j` dan `k`.

**Daftar Isi:**

  * Struktur file konfigurasi Helix (`config.toml`).
  * Mengganti tema bawaan.
  * Menyesuaikan pemetaan kunci (`keybindings`).
  * Pengaturan editor esensial lainnya (`line-numbers`, `rulers`, `indent`).

**Sumber Referensi:**

  * [Dokumentasi Resmi Helix: Konfigurasi](https://docs.helix-editor.com/configuration.html)
  * [Galeri Tema Helix di GitHub](https://www.google.com/search?q=https://github.com/helix-editor/helix/tree/master/helix-term/themes)

-----

#### **Modul 4: Manajemen Proyek dan Integrasi Eksternal**

**Deskripsi Konkret:**
Anda akan belajar cara mengelola file dan direktori, serta mengintegrasikan Helix dengan fitur-fitur modern seperti **Language Server Protocol (LSP)** dan **Tree-sitter** untuk pengalaman pengeditan yang lebih cerdas.

**Konsep Dasar dan Filosofi:**
Helix dirancang untuk menjadi lebih dari sekadar editor teks; ia adalah **code editor** yang kuat. Hal ini dicapai melalui integrasi natif dengan **LSP** dan **Tree-sitter**. **LSP** memungkinkan Helix berkomunikasi dengan server bahasa (language server) yang menyediakan fitur-fitur cerdas seperti penyelesaian otomatis (autocomplete), diagnostik, dan definisi (goto definition). **Tree-sitter** adalah parser incremental yang memungkinkan Helix memahami struktur sintaksis kode, sehingga memfasilitasi penyorotan sintaks (syntax highlighting) yang lebih akurat.

**Terminologi Kunci:**

  * **Language Server Protocol (LSP):** Protokol standar yang memungkinkan editor berkomunikasi dengan server bahasa untuk fitur-fitur bahasa (seperti penyelesaian kode, format, dll.).
  * **Tree-sitter:** Parser yang digunakan Helix untuk memahami struktur kode, memungkinkan penyorotan sintaks dan navigasi yang cerdas.
  * **Telescope Mode:** Mode bawaan di Helix untuk mencari file, `grepping` (mencari teks dalam file), dan lain-lain.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Membuka file finder: `space f`
  * Mencari teks di proyek (grep): `space /`
  * Lompat ke definisi: `gd`
  * Menemukan semua referensi: `gr`
  * Menginstal LSP (contoh untuk Rust):
    ```bash
    rustup component add rust-analyzer
    ```
    Helix akan secara otomatis mendeteksi dan menggunakan LSP yang terinstal.

**Daftar Isi:**

  * Menggunakan `Telescope Mode` untuk navigasi file.
  * Pengenalan dan konfigurasi **LSP**.
  * Pengenalan dan konfigurasi **Tree-sitter**.
  * Integrasi dengan **Git** dan fitur manajemen versi dasar.

**Sumber Referensi:**

  * [Dokumentasi Resmi Helix: Bahasa (LSP)](https://docs.helix-editor.com/languages.html)
  * [Repositori Tree-sitter](https://github.com/tree-sitter/tree-sitter)
  * [Situs Resmi Language Server Protocol](https://microsoft.github.io/language-server-protocol/)

-----

### **Fase 3: Mahir (Advanced)**

**Level:** Mahir (Advanced)

Pada fase ini, Anda akan mempelajari cara mengotomatisasi alur kerja Anda dan memanfaatkan fitur-fitur tingkat lanjut untuk meningkatkan produktivitas secara signifikan.

-----

#### **Modul 5: Makro dan Skrip Otomatisasi**

**Deskripsi Konkret:**
Anda akan belajar cara merekam dan memutar ulang urutan perintah (macro) untuk mengotomatisasi tugas-tugas berulang. Anda juga akan memahami konsep **shell commands** untuk mengintegrasikan Helix dengan utilitas CLI lainnya.

**Konsep Dasar dan Filosofi:**
Makro di Helix memungkinkan Anda merekam serangkaian perintah (misalnya, menavigasi, memilih, menghapus, atau mengetik) dan memutarnya kembali. Ini sangat berguna untuk melakukan tugas-tugas repetitif seperti pemformatan data atau refactoring kode. Integrasi dengan **shell commands** memungkinkan Anda menjalankan perintah eksternal langsung dari dalam Helix, menghubungkan editor dengan ekosistem terminal yang kuat.

**Terminologi Kunci:**

  * **Macro:** Urutan perintah yang direkam dan dapat diputar ulang.
  * **Shell Commands:** Perintah-perintah yang dijalankan di terminal.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Mulai merekam makro: `q` (di Normal Mode)
  * Selesai merekam makro: `q` (di Normal Mode)
  * Memutar ulang makro: `Q`
  * Menjalankan perintah shell: `:sh <perintah>`
      * Contoh: `:sh git status`

**Daftar Isi:**

  * Dasar-dasar perekaman dan pemutaran makro.
  * Studi kasus penggunaan makro untuk refactoring dan pemformatan.
  * Menjalankan shell commands dari Helix.
  * Integrasi dengan tools eksternal (contoh: `awk`, `sed`, `grep`).

**Sumber Referensi:**

  * [Dokumentasi Resmi Helix: Macros](https://www.google.com/search?q=https://docs.helix-editor.com/keymap.html%23macros)
  * [Dokumentasi Resmi Helix: Command Palette](https://www.google.com/search?q=https://docs.helix-editor.com/keymap.html%23command-palette)

-----

### **Fase 4: Ahli (Expert/Enterprise)**

**Level:** Ahli (Expert)

Fase ini adalah puncak dari kurikulum, di mana Anda akan memiliki pemahaman mendalam tentang arsitektur Helix dan mampu memodifikasi, bahkan berkontribusi pada kode sumbernya.

-----

#### **Modul 6: Arsitektur Helix, Kustomisasi Mendalam, dan Kontribusi**

**Identitas dan Bahasa Pemrograman:**
Helix adalah proyek **open source** yang berasal dari komunitas pengembang global. Dikembangkan menggunakan bahasa pemrograman **Rust**. Bahasa ini dikenal karena keamanan memori, performa tinggi, dan konkurensi tanpa *data race*. Helix dapat ditemukan di repositori **GitHub** (Amerika Serikat).

**Deskripsi Konkret:**
Modul ini akan membawa Anda melampaui penggunaan Helix sebagai editor dan masuk ke ranah pengembangnya. Anda akan memahami struktur kode, cara menambahkan fitur, membuat plugin, atau bahkan mengkompilasi Helix dari sumber.

**Konsep Dasar dan Filosofi:**
Filosofi di balik Helix adalah kesederhanaan, performa, dan modernitas. Arsitekturnya dirancang untuk menjadi minimalis dan **"batteries-included"**, yang berarti fitur-fitur esensial sudah terintegrasi secara natif, bukan melalui plugin eksternal seperti Vim/Neovim. Untuk menguasai ini, Anda perlu memahami bahasa **Rust**, sistem *build* **Cargo**, dan arsitektur Helix itu sendiri.

**Persyaratan untuk Pengembangan Mandiri/Modifikasi:**

  * **Bahasa Pemrograman:** Pemahaman bahasa pemrograman **Rust** adalah **wajib**. Ini adalah fondasi dari seluruh kode Helix.
  * **Konsep Wajib:** Anda harus memiliki pengalaman dan pemahaman yang mendalam mengenai:
      * **Git:** Untuk manajemen kode sumber dan kolaborasi.
      * **Cargo:** Manajer paket dan sistem *build* untuk Rust.
      * **Terminologi CLI & Unix-like:** Pemahaman tentang interaksi program dengan terminal dan sistem operasi.
      * **Arsitektur Editor:** Memahami bagaimana editor bekerja, termasuk parsing, rendering, dan manajemen buffer.
  * **Pengalaman Opsional (Sangat Direkomendasikan):**
      * Pemahaman tentang **Text Object Model** dan bagaimana cara kerjanya di level kode.
      * Pengalaman dengan **TUI (Text-based User Interface)** atau **Crossterm** (library yang digunakan Helix).

**Sintaks Dasar/Contoh Implementasi Inti:**

  * **Kloning Repositori:**
    ```bash
    git clone https://github.com/helix-editor/helix.git
    cd helix
    ```
  * **Mengkompilasi dari Sumber:**
    ```bash
    cargo install --path helix-term --locked
    ```
    Ini akan menginstal versi terbaru dari `master branch` dan menempatkannya di path yang dapat dieksekusi.

**Visualisasi (Direkomendasikan):**
Diagram arsitektur internal Helix akan sangat membantu di sini, yang menunjukkan bagaimana komponen-komponen seperti **UI thread**, **LSP client**, dan **Tree-sitter parser** saling berinteraksi.

**Daftar Isi:**

  * Struktur repositori Helix di GitHub.
  * Membangun Helix dari sumber menggunakan Cargo.
  * Menambah/memodifikasi fitur (misalnya, menambahkan perintah baru).
  * Proses kontribusi ke proyek open source.
  * Pentingnya pengujian (`cargo test`).

**Sumber Referensi:**

  * [Repositori GitHub Helix](https://github.com/helix-editor/helix)
  * [Dokumentasi Resmi Rust](https://doc.rust-lang.org/book/)
  * [Tutorial Rust oleh The Primeagen](https://www.google.com/search?q=https://www.youtube.com/playlist%3Flist%3DPLm3tE683R0_u1c-Y6e4V4oXwS3gJ3G4x_)

-----

### **Sumber Daya Komunitas & Sertifikasi**

**Komunitas:**

  * **GitHub Discussions:** Tempat utama untuk berdiskusi tentang fitur, *bug*, dan ide. ([https://github.com/helix-editor/helix/discussions](https://github.com/helix-editor/helix/discussions))
  * **Discord Server:** Saluran komunikasi real-time dengan komunitas pengembang dan pengguna.
  * **Reddit r/helixeditor:** Forum untuk berbagi tips, trik, dan konfigurasi. ([https://www.reddit.com/r/helixeditor/](https://www.reddit.com/r/helixeditor/))

**Sertifikasi:**
Saat ini, tidak ada sertifikasi formal untuk Helix Editor. Keahlian Anda divalidasi melalui portofolio, kontribusi open source, dan penguasaan praktis. Menguasai Helix dapat menjadi aset yang sangat kuat dalam resume, terutama bagi mereka yang bekerja di lingkungan yang berorientasi pada terminal dan CLI.

-----

### **Penanganan Error**

Dalam perjalanan belajar Helix, Anda mungkin akan menemui beberapa error. Berikut adalah panduan umum:

  * **Error: `command not found: hx`**: Ini berarti `helix` belum terinstal atau tidak ada di `$PATH`.
      * **Solusi:** Pastikan Anda telah menginstal Helix dengan benar, baik melalui manajer paket (`pacman -S helix` di Arch Linux) atau dengan mengkompilasi dari sumber.
  * **Error: Masalah `config.toml`**: Biasanya terjadi jika ada kesalahan sintaks di file konfigurasi.
      * **Solusi:** Periksa kembali file Anda. Jalankan perintah `hx --health` untuk melihat diagnostik dan peringatan konfigurasi. Gunakan **LSP TOML** untuk editor lain jika diperlukan.
  * **Error: Fitur LSP tidak berfungsi**: Mungkin ada masalah dengan instalasi server bahasa atau konfigurasi yang salah.
      * **Solusi:** Pastikan server bahasa yang relevan (misalnya, `rust-analyzer` untuk Rust) sudah terinstal dan dapat diakses oleh Helix. Cek juga file `config.toml` dan `languages.toml` untuk konfigurasi yang benar.

**Cara Membaca Error:**
Pesan error di terminal sering kali sangat spesifik. Perhatikan kata kunci seperti `path`, `syntax error`, `cannot find`, atau `permission denied`. Kata-kata ini adalah petunjuk langsung tentang apa yang salah. Jika Anda tidak yakin, cari pesan error tersebut di GitHub Discussions atau forum komunitas. Kemungkinan besar, seseorang sudah pernah mengalami masalah yang sama.
