# **[Kurikulum Markdown][0]**

Selamat! Anda telah membuat keputusan yang sangat baik untuk mendalami **Markdown**. Sebagai format yang ringkas, fleksibel, dan universal, Markdown adalah salah satu alat yang paling mendasar namun kuat dalam ekosistem IT dan penulisan modern. Kuasai Markdown, dan Anda akan menemukan diri Anda jauh lebih efisien dalam berbagai tugas, mulai dari menulis dokumentasi teknis hingga catatan pribadi dan bahkan pembuatan blog.

Berikut adalah kurikulum yang telah disusun secara komprehensif dan mendalam untuk menguasai Markdown, dari tingkat pemula hingga ahli.

-----

## Tidak ada Prasyarat

Tidak ada prasyarat formal atau pengalaman pemrograman yang dibutuhkan. Kurikulum ini dirancang agar dapat diakses oleh siapa pun, terlepas dari latar belakang mereka. Yang terpenting adalah keinginan untuk belajar dan berlatih.

### Alat Esensial

Untuk mengikuti kurikulum ini, Anda hanya memerlukan dua alat utama:

1.  **Editor Teks:** Anda dapat menggunakan editor teks sederhana apa pun, seperti **`vim`**, **`nano`**, atau **`emacs`** yang sudah terpasang secara *default* di Arch Linux Anda. Untuk pengalaman yang lebih kaya fitur, Anda bisa menggunakan **`Visual Studio Code (VS Code)`** dengan ekstensi Markdown Preview, atau **`Typora`** yang menyediakan pratinjau langsung (*live preview*).
2.  **Mesin Rendering Markdown:** Alat ini akan mengubah file `.md` Anda menjadi format lain, seperti HTML atau PDF. Contoh yang umum digunakan adalah **`Pandoc`**.

<!-- end list -->

```bash
# Contoh instalasi Pandoc di Arch Linux
sudo pacman -S pandoc
```

-----

## [Fase I: Foundation (Dasar-Dasar)][1]

**Estimasi Waktu:** 2-4 jam
**Level:** Pemula (Beginner)

### Deskripsi Konkret

Fase ini akan memperkenalkan Anda pada konsep dasar Markdown, dari mengapa format ini ada hingga bagaimana menggunakannya untuk membuat teks sederhana dan terstruktur. Anda akan belajar sintaks-sintaks fundamental yang akan menjadi landasan untuk semua yang akan Anda lakukan di masa depan.

### Konsep Dasar dan Filosofi

Filosofi di balik Markdown adalah **kesederhanaan dan keterbacaan**. Pencipta Markdown, **John Gruber**, ingin membuat format teks yang mudah dibaca dan ditulis oleh manusia, tanpa perlu *tag* HTML yang rumit, namun tetap bisa diubah menjadi HTML yang valid. Markdown menggunakan sintaks yang intuitif dan menyerupai format yang sudah kita gunakan secara alami dalam email atau pesan teks.

### Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan fase ini, Anda akan mampu:

  * Menjelaskan kegunaan dan filosofi Markdown.
  * Membuat dokumen teks dengan judul, paragraf, daftar, dan penekanan teks.
  * Menyertakan tautan dan gambar.
  * Menggunakan pemformatan dasar untuk catatan atau dokumentasi sederhana.

-----

### Modul 1.1: Pengenalan Markdown dan Filosofinya

  * **Daftar Isi:**
      * Apa itu Markdown?
      * Mengapa Menggunakan Markdown?
      * Hubungan antara Markdown, HTML, dan Plain Text
      * Membuka file `.md`
  * **Terminologi Kunci:**
      * **Markdown:** Sebuah bahasa *markup* ringan yang menggunakan sintaks teks biasa untuk memformat dokumen.
      * **Markup:** Teks khusus yang ditambahkan ke dokumen untuk menentukan bagaimana bagian dari dokumen tersebut harus ditampilkan.
      * **Plain Text:** Teks polos tanpa format khusus (misalnya, tanpa cetak tebal, miring, atau ukuran font).
  * **Sumber Referensi:**
      * [Daring: The Markdown Guide](https://www.markdownguide.org/getting-started/)
      * [Markdown: Syntax by John Gruber](https://daringfireball.net/projects/markdown/syntax)
      * [CommonMark Specification](https://commonmark.org/help/)

### Modul 1.2: Sintaks Dasar: Teks dan Struktur

  * **Daftar Isi:**
      * Judul (Headings)
      * Paragraf dan Baris Baru (Paragraphs & Line Breaks)
      * Penekanan Teks (Emphasis: Bold, Italic, Strikethrough)
      * Daftar (Lists: Ordered & Unordered)
      * Kutipan Blok (Blockquotes)
  * **Sintaks Dasar/Contoh:**
    ```markdown
    # Judul 1
    ## Judul 2

    Ini adalah sebuah paragraf.

    Teks ini akan menjadi **cetak tebal** dan *cetak miring*.

    - Item 1
    - Item 2

    1. Item pertama
    2. Item kedua

    > Ini adalah sebuah kutipan.
    ```
  * **Terminologi Kunci:**
      * **Heading:** Judul atau sub-judul dalam sebuah dokumen, ditandai dengan `#`. Semakin banyak `#`, semakin kecil level judulnya.
      * **List:** Daftar butir-butir, dapat berupa **`Ordered List`** (dengan angka) atau **`Unordered List`** (dengan `*` atau `-`).
      * **Blockquote:** Kutipan teks, ditandai dengan `>`.
  * **Sumber Referensi:**
      * [Markdown Guide: Basic Syntax](https://www.markdownguide.org/basic-syntax/)
      * [Tutorialspoint: Markdown Basic Syntax](https://www.google.com/search?q=https://www.tutorialspoint.com/markdown/markdown_basic_syntax.htm)

-----

## [Fase II: Intermediate (Menengah)][2]

**Estimasi Waktu:** 4-6 jam
**Level:** Menengah (Intermediate)

### Deskripsi Konkret

Setelah menguasai dasar-dasar, fase ini akan membawa Anda ke fitur-fitur yang lebih canggih yang diperlukan untuk dokumentasi teknis dan publikasi profesional. Anda akan belajar tentang tabel, kode, dan cara menyisipkan konten eksternal dengan lebih efektif.

### Konsep Dasar dan Filosofi

Fase ini berfokus pada **struktur dan fungsionalitas**. Anda akan melihat bagaimana Markdown bisa melampaui sekadar teks biasa untuk menyajikan data terstruktur (tabel) dan kode program secara visual yang dapat dibaca. Konsep **"fenced code blocks"** dan **`inline code`** menjadi sangat penting di sini, memungkinkan para pengembang untuk berbagi contoh kode dengan rapi.

### Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan fase ini, Anda akan mampu:

  * Membuat tabel untuk menyajikan data secara terorganisir.
  * Menyisipkan dan memformat blok kode program dengan penyorotan sintaks (syntax highlighting).
  * Menggunakan tautan referensi untuk mengelola tautan dengan lebih efisien.
  * Menambahkan garis horizontal sebagai pemisah visual.

-----

### Modul 2.1: Kode dan Tabel

  * **Daftar Isi:**

      * Kode Sebaris (Inline Code)
      * Blok Kode (Fenced Code Blocks)
      * Tabel
      * Garis Horizontal (Horizontal Rules)

  * **Sintaks Dasar/Contoh:**

    ````markdown
    Gunakan `npm install` untuk menginstal dependensi.

    ```javascript
    const greeting = "Hello, World!";
    console.log(greeting);
    ````

    | Kolom 1 | Kolom 2 | Kolom 3 |
    |---|---|---|
    | Data 1 | Data 2 | Data 3 |

    -----

    Ini adalah garis horizontal.

    ```
    ```

  * **Terminologi Kunci:**

      * **Inline Code:** Digunakan untuk menampilkan potongan kode pendek di dalam kalimat, ditandai dengan backtick (`     `).
      * **Fenced Code Block:** Digunakan untuk menampilkan blok kode yang lebih besar dan sering kali dengan penyorotan sintaks, ditandai dengan tiga backtick (\`\`\`) di awal dan akhir.
      * **Syntax Highlighting:** Proses menampilkan kode program dalam warna yang berbeda untuk setiap jenis sintaks (misalnya, variabel, fungsi, string), yang memudahkan pembacaan.

  * **Sumber Referensi:**

      * [Markdown Guide: Code Blocks](https://www.google.com/search?q=https://www.markdownguide.org/extended-syntax/%23code-blocks)
      * [Markdown Guide: Tables](https://www.google.com/search?q=https://www.markdownguide.org/extended-syntax/%23tables)

### Modul 2.2: Tautan dan Gambar Tingkat Lanjut

  * **Daftar Isi:**
      * Tautan Otomatis (Automatic Links)
      * Tautan Referensi (Reference-style Links)
      * Gambar dengan Tautan (Image Links)
  * **Sintaks Dasar/Contoh:**
    ```markdown
    Hubungi saya di <mail@example.com>.

    [Google][1]
    [Wikipedia][2]

    [1]: [http://google.com](http://google.com)
    [2]: [http://wikipedia.org](http://wikipedia.org)

    ![Logo Markdown][3]

    [3]: [https://www.markdown.org/img/logo.svg](https://www.markdown.org/img/logo.svg)
    ```
  * **Terminologi Kunci:**
      * **Reference-style Link:** Sebuah teknik untuk mengelola tautan dalam dokumen yang panjang dengan memisahkannya dari teks, meningkatkan keterbacaan.
  * **Sumber Referensi:**
      * [Markdown Guide: Links](https://www.google.com/search?q=https://www.markdownguide.org/basic-syntax/%23links)

-----

## [Fase III: Expert (Tingkat Mahir)][3]

**Estimasi Waktu:** 5-7 jam
**Level:** Mahir (Advanced)

### Deskripsi Konkret

Pada fase ini, Anda akan menjelajahi ekstensi Markdown yang lebih kompleks dan alat-alat yang mengubah Markdown dari sekadar bahasa *markup* menjadi alat penulisan serbaguna. Anda akan belajar tentang **Markdown Flavors** yang berbeda dan bagaimana mereka memperluas fungsionalitas inti Markdown.

### Konsep Dasar dan Filosofi

Konsep utama di sini adalah **ekstensibilitas**. Markdown asli sangat minimalis, tetapi berbagai komunitas telah membuat "ekstensi" atau **`flavors`** untuk menambahkan fitur yang dibutuhkan untuk kasus penggunaan tertentu, seperti GitHub Flavored Markdown (GFM) untuk repositori kode atau MultiMarkdown untuk publikasi. Memahami perbedaan ini sangat penting untuk interoperabilitas.

### Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan fase ini, Anda akan mampu:

  * Menggunakan fitur Markdown yang diperluas seperti daftar tugas dan tabel konten.
  * Mengintegrasikan Markdown dengan bahasa pemrograman lain untuk otomatisasi.
  * Memahami dan memilih Markdown *flavor* yang tepat untuk kebutuhan spesifik.
  * Menggunakan **`Pandoc`** untuk mengkonversi dokumen `.md` ke format lain (misalnya, HTML, PDF).

-----

### Modul 3.1: Ekstensi Markdown (Markdown Flavors)

  * **Daftar Isi:**
      * GitHub Flavored Markdown (GFM)
      * Daftar Tugas (Task Lists)
      * Tabel Konten Otomatis
  * **Sintaks Dasar/Contoh:**
    ```markdown
    - [x] Selesaikan tugas 1
    - [ ] Selesaikan tugas 2

    ---

    # Judul Dokumen

    ## Daftar Isi

    - [Section A](#section-a)
    - [Section B](#section-b)

    ## Section A

    ## Section B
    ```
  * **Terminologi Kunci:**
      * **Markdown Flavor:** Varian dari sintaks Markdown standar yang menambahkan fitur baru. GFM adalah salah satu yang paling populer.
      * **Task List:** Daftar yang memungkinkan Anda menandai item sebagai selesai, berguna untuk daftar tugas atau *checklist* dalam dokumentasi proyek.
  * **Sumber Referensi:**
      * [GitHub: Mastering Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
      * [GitLab: GitLab Flavored Markdown](https://docs.gitlab.com/ee/user/markdown.html)

### Modul 3.2: Alur Kerja Profesional dan Otomasi

  * **Daftar Isi:**
      * Menggunakan Pandoc untuk Konversi
      * Membuat Slide Presentasi dengan Markdown
      * Otomasi dan *Build Pipeline*
  * **Deskripsi Konkret:**
      * **Pandoc** adalah alat baris perintah yang sangat kuat. Ini adalah program yang dibangun dengan bahasa **Haskell** (dari komunitas Haskell di seluruh dunia) dan memungkinkan konversi dari satu format *markup* ke format lainnya, termasuk Markdown ke HTML, PDF, dan bahkan `.docx`. Ini adalah alat esensial untuk alur kerja profesional.
  * **Contoh Implementasi Inti (CLI):**
    ```bash
    # Mengubah file Markdown ke HTML
    pandoc my_document.md -o my_document.html

    # Mengubah file Markdown ke PDF (memerlukan LaTeX)
    pandoc my_document.md -o my_document.pdf
    ```
  * **Interoperabilitas:**
      * **Pandoc** dapat berinteraksi dengan berbagai bahasa dan *engine*. Untuk menghasilkan PDF, misalnya, Pandoc akan menggunakan **LaTeX** sebagai *engine* rendering, yang artinya Anda perlu menginstalnya di sistem Anda.
  * **Sumber Referensi:**
      * [Pandoc Documentation](https://pandoc.org/MANUAL.html)
      * [Pandoc's GitHub Repository](https://github.com/jgm/pandoc)

-----

## Sumber Daya Komunitas dan Sertifikasi

Meskipun tidak ada sertifikasi formal untuk Markdown, penguasaan Markdown dapat divalidasi dengan cara berikut:

  * **Berkontribusi pada Proyek Open Source:** Banyak proyek di GitHub, GitLab, atau Gitee menggunakan Markdown untuk dokumentasi mereka. Berkontribusi pada proyek-proyek ini adalah cara terbaik untuk menunjukkan keahlian Anda.
  * **Menulis Blog atau Dokumentasi Pribadi:** Buat blog atau repositori pribadi yang sepenuhnya menggunakan Markdown.
  * **Komunitas:**
      * **GitHub Discussions:** Forum untuk berbagai pertanyaan terkait proyek.
      * **Stack Overflow:** Tanyakan dan jawab pertanyaan terkait Markdown.
      * **Reddit:** Bergabunglah dengan subreddit seperti `r/markdown` untuk diskusi dan inspirasi.

Kurikulum ini memberi Anda fondasi yang kuat, memungkinkan Anda untuk tidak hanya membaca, tetapi juga menulis dokumentasi profesional. Gunakanlah setiap modul, praktikkan setiap sintaks, dan Anda akan menguasai Markdown dalam waktu singkat.

[0]: ./../../../README.md
[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
