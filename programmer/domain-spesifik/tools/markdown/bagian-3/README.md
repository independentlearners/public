## [Fase III: Expert (Tingkat Mahir)][0]

### Deskripsi Konkret & Peran dalam Kurikulum

Fase **Expert** adalah tentang **penguasaan dan adaptasi**. Di sini, Anda akan melampaui sintaks standar dan menyelami dunia ekstensi (extension) dan alat-alat (*tool*) yang mengubah Markdown dari sekadar format teks menjadi bagian integral dari alur kerja pengembangan perangkat lunak dan publikasi. Anda akan belajar bagaimana Markdown tidak hanya digunakan untuk menulis, tetapi juga untuk memproduksi dokumen, presentasi, dan bahkan buku dengan bantuan alat canggih.

### Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan fase ini, Anda akan mampu:

  * Memahami perbedaan dan kegunaan dari berbagai **Markdown *flavors*** (varian).
  * Menggunakan fitur tambahan seperti daftar tugas (*task lists*), emoji, dan tabel konten otomatis.
  * Mengintegrasikan Markdown ke dalam alur kerja pengembangan perangkat lunak.
  * Menggunakan alat baris perintah (CLI) seperti **Pandoc** untuk mengonversi dokumen Markdown ke berbagai format lain (misalnya, HTML, PDF, `.docx`).
  * Membuat presentasi atau slide dari file Markdown.
  * Menjelaskan interoperabilitas Markdown dengan bahasa pemrograman lain dan *engine* rendering.

-----

### Modul 3.1: Ekstensi Markdown (Markdown Flavors)

#### **Struktur Pembelajaran Internal (Daftar Isi Mini):**

<details>
  <summary>📃 Daftar Isi</summary>

  * Apa itu Markdown *Flavors*?
  * Pengenalan GitHub Flavored Markdown (GFM)
  * Fitur Utama GFM: Daftar Tugas, Emoji, dan Tabel.
  * Pengenalan CommonMark.
  * Perbedaan antara Markdown Asli, CommonMark, dan GFM.
  * Hubungan dengan komunitas.

</details>

-----

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memperluas wawasan Anda tentang Markdown. Anda akan belajar bahwa tidak semua Markdown diciptakan sama. **Markdown *flavors***, atau varian, adalah versi yang dimodifikasi dari sintaks Markdown asli untuk memenuhi kebutuhan komunitas tertentu. Peran modul ini sangat penting karena ia memperkenalkan konsep **interoperabilitas**, yaitu kemampuan dokumen Markdown Anda untuk bekerja dengan benar di berbagai platform. Memahami hal ini akan mencegah kebingungan saat Anda melihat dokumen yang tidak ter-*render* dengan benar di tempat yang berbeda.

#### Konsep Kunci & Filosofi Mendalam

Filosofi di balik Markdown *flavors* adalah **spesialisasi**. Markdown asli minimalis, yang membuatnya universal, tetapi juga membatasi fungsinya. Komunitas, terutama di dunia pengembangan, membutuhkan fitur tambahan seperti tabel atau daftar tugas. GFM, yang dikembangkan oleh GitHub, adalah respons terhadap kebutuhan ini. Sementara itu, **CommonMark** adalah upaya untuk menciptakan **standar** Markdown yang jelas dan tidak ambigu, memastikan bahwa satu file Markdown akan ter-*render* sama di mana pun, sebuah tujuan yang tidak pernah sepenuhnya dicapai oleh Markdown asli.

  * **GitHub Flavored Markdown (GFM):** Ini adalah *flavor* yang paling banyak digunakan di dunia, berkat popularitas GitHub. Ia menambahkan beberapa fitur penting yang tidak ada di Markdown asli.
  * **CommonMark:** Ini bukan *flavor*, melainkan **spesifikasi**. Tujuannya adalah untuk menjadi "cetak biru" yang mendefinisikan dengan tepat bagaimana setiap sintaks Markdown harus diinterpretasikan. Ini mengatasi ambiguitas dalam sintaks Markdown asli.

#### Sintaks Dasar / Contoh Implementasi Inti

Berikut adalah beberapa sintaks yang diperkenalkan oleh **GFM**:

##### **1. Daftar Tugas (Task Lists)**

  * **Sintaks:** Gunakan `*` atau `-` diikuti oleh spasi, dan kemudian kurung siku `[]` dengan spasi di dalamnya untuk item yang belum selesai, atau `x` untuk item yang sudah selesai.

  * **Contoh:**

    ```markdown
    Daftar Tugas Proyek:
    - [x] Merancang skema database
    - [ ] Menerapkan API backend
    - [ ] Menulis dokumentasi
    ```

  * **Peran:** Fitur ini sangat populer untuk mengelola proyek di repositori kode dan menjadi alat yang sangat berguna untuk *checklist*.

##### **2. Tabel Konten Otomatis**

Meskipun tidak ada sintaks GFM resmi untuk ini, banyak *renderer* (seperti yang digunakan di GitHub) secara otomatis membuat tautan dari judul-judul Anda. Fitur ini bekerja dengan mengubah judul (misalnya, `## Penggunaan`) menjadi ID HTML (`id="penggunaan"`) yang dapat ditautkan.

  * **Contoh Implementasi:**

    ```markdown
    # Bagian 1: Pengenalan

    Teks pengenalan...

    ## Penggunaan

    Instruksi penggunaan...
    ```

    Secara otomatis, *renderer* akan membuat tautan seperti `[Penggunaan](#penggunaan)`. Memahami konsep ini sangat penting untuk navigasi dokumen yang besar.

#### Terminologi Esensial & Penjelasan Detil

  * **Markdown *Flavor*:** Varian Markdown dengan fitur tambahan. Contohnya adalah GFM, MultiMarkdown, dan Kramdown.
  * **Spesifikasi (Specification):** Dokumen teknis yang secara detail mendefinisikan bagaimana sesuatu harus bekerja. CommonMark adalah spesifikasi untuk Markdown.
  * **Interoperabilitas (Interoperability):** Kemampuan dua atau lebih sistem untuk berkomunikasi dan bekerja sama. Dalam hal ini, kemampuan file Markdown untuk di-*render* dengan benar di berbagai platform.
  * **Renderer:** Program atau *engine* yang mengubah sintaks Markdown menjadi format lain (misalnya, HTML).

#### Hubungan dengan Modul Lain

Modul ini adalah kelanjutan logis dari **Modul 2.1 (Tabel dan Kode)**. Fitur-fitur GFM seperti tabel sebenarnya adalah perluasan dari sintaks yang telah Anda pelajari. Materi ini juga menjadi prasyarat untuk **Modul 3.2**, di mana Anda akan menggunakan alat yang kompatibel dengan berbagai *flavor* ini untuk mengotomatisasi pekerjaan Anda.

#### Sumber Referensi Lengkap

  * **GitHub Flavored Markdown Spec:** [GFM Spec](https://github.github.com/gfm/) — Dokumentasi resmi dan terperinci tentang GFM. Sangat direkomendasikan untuk pemahaman mendalam.
  * **CommonMark Spec:** [CommonMark Specification](https://spec.commonmark.org/0.30/) — Spesifikasi teknis untuk Markdown yang tidak ambigu. Ini adalah referensi terbaik untuk memahami aturan dan pengecualian.
  * **Markdown Guide: CommonMark:** [Markdown Guide: CommonMark](https://www.google.com/search?q=https://www.markdownguide.org/commonmark/) — Penjelasan yang lebih mudah dipahami tentang CommonMark dan perbedaannya dengan Markdown asli.

#### Tips dan Praktik Terbaik

  * **Pilih *Flavor* yang Tepat:** Dalam kebanyakan kasus, **GFM** adalah pilihan terbaik karena banyak platform populer seperti GitHub, GitLab, dan Stack Overflow menggunakannya. Jika Anda bekerja dengan komunitas spesifik, pastikan Anda mengetahui *flavor* yang mereka gunakan.
  * **Selalu *Fall Back* ke Standar:** Jika Anda ingin dokumen Anda dapat diakses di mana pun, cobalah untuk tetap menggunakan sintaks Markdown yang paling dasar (yang juga kompatibel dengan CommonMark). Gunakan fitur *flavor* hanya jika Anda yakin platform target akan mendukungnya.

#### Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Menganggap semua sintaks Markdown akan berfungsi di mana saja.
      * **Solusi:** Selalu periksa dokumentasi platform yang Anda gunakan (misalnya, dokumentasi Slack, Discord, atau GitLab) untuk mengetahui *flavor* Markdown apa yang mereka dukung.
  * **Kesalahan:** Lupa menambahkan spasi setelah tanda `- [x]` pada daftar tugas.
      * **Solusi:** Sintaks ini sangat spesifik. Selalu pastikan ada spasi setelah tanda `-` dan juga di dalam kurung siku `[]` jika item belum selesai.

-----

### Representasi Visual Sintaks

Berikut adalah diagram yang menunjukkan bagaimana **Markdown *flavors*** memperluas sintaks dasar.

```
┌───────────────────────────┐
│     Markdown Asli         │
│  (Sintaks Dasar)          │
│ ┌───────────────────────┐ │
│ │   # Judul             │ │
│ │   **tebal**           │ │
│ │   - Daftar            │ │
│ └───────────────────────┘ │
└───────────┬───────────────┘
            │
            ▼
┌───────────────────────────┐
│     GitHub Flavored       │
│     Markdown (GFM)        │
│ ┌───────────────────────┐ │
│ │ (Sintaks Asli +)      │ │
│ │   - [x] Task Lists    │ │
│ │   | Tabel |           │ │
│ │   :smile: Emoji       │ │
│ └───────────────────────┘ │
└───────────────────────────┘
```

Diagram ini secara visual menunjukkan bahwa GFM adalah superset (kumpulan yang lebih besar) dari Markdown asli, yang berarti ia mencakup semua sintaks asli ditambah fitur-fitur baru.

-----

### Modul 3.2: Alur Kerja Profesional dan Otomasi

#### **Struktur Pembelajaran Internal (Daftar Isi Mini):**

  * Mengapa Automasi Penting?
  * Pengenalan Pandoc: Mesin Konversi Serbaguna
  * Menggunakan Pandoc untuk Konversi Dasar
  * Membuat Slide Presentasi dari Markdown
  * Integrasi Markdown dalam *Build Pipeline*
  * Hubungan dengan Bahasa Pemrograman
  * Tips dan Praktik Terbaik

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengubah pandangan Anda tentang Markdown dari sekadar bahasa *markup* menjadi sebuah **format sumber (source format)** yang fleksibel. Peran utamanya adalah mengajarkan Anda bagaimana memanfaatkan kekuatan *plain text* Markdown untuk menghasilkan output dalam berbagai format berbeda, seperti PDF untuk laporan, HTML untuk blog, atau bahkan *slide* presentasi. Ini adalah modul yang memungkinkan Anda menerapkan filosofi **"Write once, publish everywhere"**.

#### Konsep Kunci & Filosofi Mendalam

Filosofi di balik modul ini adalah **pemisahan antara konten dan presentasi**. Anda menulis konten Anda di Markdown, yang fokus pada makna dan struktur. Kemudian, Anda menggunakan alat seperti **Pandoc** untuk menentukan bagaimana konten tersebut akan ditampilkan atau dipresentasikan. Ini adalah konsep yang sangat kuat dan merupakan inti dari banyak sistem publikasi modern.

**Pandoc** adalah contoh utama dari filosofi ini. **Pandoc** adalah sebuah program baris perintah (CLI) yang dibangun dengan bahasa **Haskell** oleh John MacFarlane. Fleksibilitasnya berasal dari arsitektur internalnya yang mengubah setiap dokumen input menjadi representasi internal yang abstrak, lalu mengubahnya kembali ke format output yang diinginkan. Ini memungkinkannya mendukung puluhan format, dari Markdown, LaTeX, dan HTML hingga DOCX, ODT, dan EPUB.

#### Sintaks Dasar / Contoh Implementasi Inti

Semua implementasi di modul ini berfokus pada **CLI**, yang sejalan dengan preferensi Anda untuk Linux dan CLI.

##### **1. Menggunakan Pandoc untuk Konversi Dasar**

  * **Prasyarat:** Pastikan Anda telah menginstal Pandoc. Jika belum, jalankan `sudo pacman -S pandoc`.

  * **Sintaks Dasar:** `pandoc [file_input] -o [file_output]`

  * **Contoh:**

      * **Markdown ke HTML:**

        ```bash
        pandoc my_document.md -o my_document.html
        ```

      * **Markdown ke PDF:** Konversi ke PDF seringkali membutuhkan **LaTeX** sebagai *engine* rendering. Jadi, Anda mungkin perlu menginstal `texlive` atau distribusi LaTeX lainnya.

        ```bash
        sudo pacman -S texlive-most
        pandoc my_document.md -o my_document.pdf
        ```

      * **Markdown ke Word (DOCX):**

        ```bash
        pandoc my_document.md -o my_document.docx
        ```

##### **2. Membuat Slide Presentasi dari Markdown**

Pandoc dapat mengubah file Markdown menjadi slide presentasi menggunakan *engine* seperti **Reveal.js** atau **Beamer** (yang menggunakan LaTeX).

  * **Contoh:**

    ```bash
    pandoc -t revealjs -s -o presentation.html my_slides.md
    ```

      * **Penjelasan:**
          * `-t revealjs`: Mengatur format output menjadi **Reveal.js** (sebuah *engine* presentasi berbasis HTML dan JavaScript).
          * `-s`: Membuat output menjadi dokumen mandiri (*standalone*), yang mencakup semua CSS dan JS yang diperlukan.
          * `-o presentation.html`: Menentukan nama file output.

#### Hubungan dengan Bahasa Pemrograman

Pandoc sendiri dibangun dengan Haskell, namun kemampuannya untuk berinteraksi dengan berbagai bahasa dan *engine* lain sangat penting. Contohnya:

  * **LaTeX:** Digunakan sebagai *engine* untuk menghasilkan PDF yang berkualitas tinggi.
  * **JavaScript:** *Engine* seperti Reveal.js bergantung pada JavaScript untuk fungsionalitas slide.
  * **Python:** Banyak *script* otomasi yang memproses file Markdown menggunakan pustaka Python yang pada dasarnya memanggil Pandoc di belakang layar.

#### Terminologi Esensial & Penjelasan Detil

  * **Pandoc:** Disebut sebagai "Swiss Army knife of document conversion." Ini adalah alat baris perintah universal untuk konversi dokumen.
  * **Toolchain:** Serangkaian alat yang dihubungkan bersama untuk menyelesaikan suatu tugas. Dalam hal ini, Markdown, Pandoc, dan LaTeX/HTML/PDF adalah sebuah *toolchain*.
  * **Build Pipeline:** Konsep dalam DevOps di mana serangkaian tugas (seperti konversi file, pengujian, dan penyebaran) diotomatisasi. Pandoc seringkali menjadi bagian dari *pipeline* ini.

#### Sumber Referensi Lengkap

  * **Pandoc Official Website:** [Pandoc - About](https://pandoc.org/index.html) — Halaman utama yang berisi informasi dan unduhan.
  * **Pandoc User's Guide:** [Pandoc - User's Guide](https://pandoc.org/MANUAL.html) — Panduan yang sangat rinci untuk semua opsi dan format yang didukung oleh Pandoc.
  * **The Pandoc Community:** [Pandoc Google Group](https://groups.google.com/g/pandoc-discuss) — Forum diskusi komunitas tempat Anda dapat bertanya dan berbagi tips.

#### Tips dan Praktik Terbaik

  * **Integrasi dengan *Text Editor*:** Banyak editor (terutama yang berbasis CLI seperti Vim atau Emacs) memiliki *plugin* yang memungkinkan Anda menjalankan perintah Pandoc langsung dari dalam editor.
  * **Pelajari LaTeX Dasar:** Jika Anda berencana untuk sering menghasilkan PDF yang kompleks, luangkan waktu untuk mempelajari sintaks LaTeX dasar. Ini akan memungkinkan Anda mengkustomisasi output Pandoc Anda secara mendalam.
  * **Otomatisasi dengan `make`:** Untuk proyek besar, pertimbangkan untuk menggunakan `Makefile` untuk mengotomatisasi proses konversi. Cukup jalankan `make all`, dan semua file akan diubah secara otomatis.

#### Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Gagal menginstal dependensi yang dibutuhkan (misalnya, LaTeX).
      * **Solusi:** Pandoc akan memberikan pesan error yang jelas jika dependensi tidak ditemukan. Baca pesan tersebut dengan cermat dan instal paket yang dibutuhkan. Contoh: `pdflatex not found`. Solusinya adalah menginstal `texlive`.
  * **Kesalahan:** Bingung dengan banyaknya opsi Pandoc.
      * **Solusi:** Mulai dengan sintaks paling dasar (`pandoc input.md -o output.html`) dan tambahkan opsi satu per satu. Panduan pengguna adalah sumber terbaik Anda.

-----

### Representasi Visual Alur Kerja

Berikut adalah diagram alur yang menjelaskan bagaimana Markdown, Pandoc, dan format lain berinteraksi dalam sebuah *toolchain* profesional.

````
┌───────────────────────────┐
│     Dokumen Sumber        │
│       (File .md)          │
│   ┌───────────────────┐   │
│   │ # Judul Dokumen   │   │
│   │                   │   │
│   │ Teks **konten**   │   │
│   │                   │   │
│   │ ```js             │   │
│   │ (Kode)            │   │
│   │ ```               │   │
│   └───────────────────┘   │
└───────────┬───────────────┘
            │
            │           ┌────────────────────────────────┐
            │           │   Pandoc (CLI)                 │
            │──────────►│   (Mesin Konversi)             │
            │           └────────────────────────────────┘
            │
┌───────────▼──────────────────────────┐
│            Berbagai Output           │
│ ┌────────┬─────────────┬───────────┐ │
│ │  HTML  │    PDF      │   DOCX    │ │
│ │ (Blog) │ (Laporan)   │ (Laporan) │ │
│ └────────┴─────────────┴───────────┘ │
└──────────────────────────────────────┘
````

Diagram ini menunjukkan bagaimana satu file Markdown dapat diubah menjadi berbagai format yang berbeda hanya dengan mengubah perintah Pandoc. Ini adalah gambaran alur kerja yang sangat efisien dan profesional.

# Selamat!

Kita telah menyelesaikan pendalaman menyeluruh pada kurikulum Markdown. Anda kini memiliki pemahaman yang kuat dari fondasi hingga alur kerja ahli. 

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
