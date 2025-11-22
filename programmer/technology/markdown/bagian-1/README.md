## [Fase I: Foundation (Dasar-Dasar)][0]

### Deskripsi Konkret & Peran dalam Kurikulum

Fase ini adalah titik awal yang mutlak dalam perjalanan Anda menguasai Markdown. Ini bukan sekadar pengenalan, melainkan peletakan fondasi yang kokoh untuk semua pembelajaran di masa depan. Di sini, Anda akan belajar tentang **"mengapa"** di balik Markdown, bukan hanya **"bagaimana"**. Tanpa pemahaman yang kuat tentang konsep dan sintaks dasar yang diajarkan di fase ini, materi yang lebih lanjut akan terasa seperti hanya sekumpulan trik tanpa makna. Fase ini memastikan Anda memiliki intuisi yang tepat tentang cara kerja Markdown, yang sangat penting untuk menulis dokumentasi yang konsisten dan profesional.

-----

### Modul 1.1: Pengenalan Markdown dan Filosofinya

#### **Struktur Pembelajaran Internal (Daftar Isi Mini):**

<details>
  <summary>📃 Daftar Isi</summary>

  * Apa itu Markdown?
  * Mengapa Menggunakan Markdown?
  * Hubungan antara Markdown, HTML, dan Plain Text.
  * Memilih dan Menggunakan Editor Markdown.
  * Tips Praktis: Membuka dan Menyimpan File `.md`.

</details>

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini berfungsi sebagai gerbang utama. Ini adalah tempat Anda akan mendapatkan jawaban atas pertanyaan fundamental seperti "Apa itu Markdown?" dan "Mengapa saya harus peduli?". Perannya sangat krusial karena ia membangun konteks dan motivasi. Dengan memahami **filosofi** Markdown—yaitu kesederhanaan dan keterbacaan—Anda tidak hanya akan hafal sintaksnya, tetapi juga akan memahami *mengapa* setiap sintaks dirancang seperti itu. Modul ini adalah fondasi filosofis dari seluruh kurikulum.

#### Konsep Kunci & Filosofi Mendalam

Markdown, yang diciptakan oleh **John Gruber** pada tahun 2004, adalah sebuah bahasa *markup* ringan. Filosofi utamanya adalah "kesederhanaan" dan "keterbacaan."

  * **Kesederhanaan:** Markdown dirancang untuk menjadi sangat minimalis. Hanya ada sedikit aturan yang perlu diingat, menjadikannya cepat dipelajari dan diimplementasikan.
  * **Keterbacaan (Readability):** Ini adalah jantung dari filosofi Markdown. Tujuan utamanya adalah membuat dokumen yang **mudah dibaca bahkan dalam bentuk teks mentah** (plain text), tanpa perlu di-*render* ke format lain terlebih dahulu. Ini adalah perbedaan besar dari bahasa *markup* lain seperti HTML, yang bisa jadi sulit dibaca saat masih dalam format mentah.

Bayangkan Anda sedang menulis catatan penting. Apakah Anda ingin menulis `<p>Ini adalah **catatan** penting.</p>` atau hanya `Ini adalah **catatan** penting.`? Markdown memilih pendekatan kedua, yang lebih intuitif dan alami bagi manusia. Ini adalah alasan mengapa Markdown begitu populer di kalangan pengembang, penulis teknis, dan jurnalis.

#### Sintaks Dasar / Contoh Implementasi Inti

Tidak ada sintaks kode yang spesifik di modul ini, karena fokusnya adalah pada konsep. Namun, implementasi utamanya adalah pada praktik memilih dan menggunakan editor teks yang tepat, anda bisa membuat file dan membukanya di VSCode. jika anda menyukai CLI seperti saya, lanjutkan kebawah tetapi jika tidak, abaikan penjelasan ini.

**Langkah-langkah Praktis:**

1.  **Buka Terminal** (sesuai kesukaan saya pada CLI).
2.  **Buat File Baru:** `touch my_first_document.md`
3.  **Buka Editor Teks:** `vim my_first_document.md` atau `nano my_first_document.md`.
4.  **Tulis Sesuatu:** Cukup ketik teks biasa.
5.  **Simpan dan Keluar:** Di Vim, tekan `ESC`, lalu ketik `:wq` (write & quit). Di Nano, tekan `Ctrl + X`, lalu `Y` untuk menyimpan.

Contoh visualisasi dari alur kerja ini akan sangat membantu:

````
┌──────────────────────────┐
│      Terminal CLI        │
│ ┌──────────────────────┐ │
│ │  touch hello.md      │ │
│ │  vim hello.md        │ │
│ └──────────────────────┘ │
│                          │
│        (Tindakan)        │
│        ┌───────┐         │
│        │  Vim  │         │
│        └───────┘         │
│                          │
│        (Editor)          │
│                          │
└──────────────────────────┘
````
#### Terminologi Esensial & Penjelasan Detil

  * **Markdown:** Sejenis bahasa *markup* ringan. Kata *markdown* sendiri merupakan plesetan dari *markup* (*mark up*), yang berarti menandai teks. **Markdown** adalah cara untuk menandai teks agar nantinya dapat diubah menjadi format lain yang lebih kaya fitur, seperti HTML.
  * **Markup Language:** Sebuah sistem untuk memberi anotasi pada dokumen dengan *tag* atau tanda khusus yang memberitahu program tentang struktur dokumen tersebut. Contoh terkenal lainnya adalah **HTML** dan **XML**.
  * **Plain Text:** Merujuk pada teks mentah yang tidak memiliki format (cetak tebal, miring, warna, ukuran font, dll.). File `.txt` adalah contoh paling umum dari *plain text*. Markdown menggunakan karakter *plain text* seperti `#`, `*`, dan `>` untuk memberikan makna struktural pada teks.
  * **Render:** Proses mengubah dokumen dari satu format ke format lain. Dalam konteks Markdown, ini berarti mengubah file `.md` menjadi HTML, PDF, atau format lain yang dapat ditampilkan secara visual.
  * **File Extension (`.md`):** Akhiran nama file yang menandakan jenisnya. File Markdown menggunakan ekstensi `.md` atau `.markdown`.

#### Hubungan dengan Modul Lain

Modul ini adalah prasyarat untuk semua modul lainnya. Pemahaman tentang mengapa Markdown ada akan mempermudah Anda dalam memahami sintaks-sintaks di **Modul 1.2** dan seterusnya. Filosofi yang Anda serap di sini akan menjadi panduan Anda saat menulis.

#### Sumber Referensi Lengkap

  * **John Gruber's Original Post on Markdown (2004):** [Daring Fireball: Markdown](https://daringfireball.net/projects/markdown/) — Sumber paling otentik. Membacanya akan memberikan Anda wawasan langsung tentang alasan di balik penciptaan Markdown.
  * **Markdown Guide: Getting Started:** [The Markdown Guide: Getting Started](https://www.markdownguide.org/getting-started/) — Panduan yang sangat bagus untuk pemula, menjelaskan konsep dasar secara ringkas.
  * **GitHub Docs: About Markdown:** [GitHub Docs: About Markdown](https://www.google.com/search?q=https://docs.github.com/en/get-started/writing-on-github/about-writing-and-formatting-on-github) — Meskipun berfokus pada GitHub, ini memberikan perspektif yang relevan tentang penggunaan Markdown dalam konteks dunia IT.

#### Tips dan Praktik Terbaik

  * **Pilih Editor yang Tepat:** Meskipun Anda cinta CLI, pertimbangkan untuk mencoba editor GUI seperti VS Code. Mode *preview* langsungnya dapat membantu Anda memvisualisasikan hasil akhir saat Anda mengetik, yang sangat membantu dalam proses pembelajaran.
  * **Mulai dari yang Paling Sederhana:** Jangan mencoba menguasai semua sintaks sekaligus. Mulailah dengan menulis paragraf, lalu tambahkan judul, dan seterusnya.
  * **Pentingnya Keterbacaan:** Selalu periksa kembali file Markdown Anda dalam format *plain text*. Apakah mudah dibaca dan dimengerti tanpa perlu di-*render*? Jika ya, berarti Anda sudah menerapkan filosofi Markdown dengan benar.

#### Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Mengira Markdown adalah bahasa pemrograman.
      * **Solusi:** Markdown adalah **bahasa *markup***, bukan bahasa pemrograman. Ini tidak dapat melakukan komputasi atau logika seperti Dart atau Python. Perannya hanyalah untuk **memformat teks**.
  * **Kesalahan:** Menggunakan editor seperti Microsoft Word.
      * **Solusi:** Editor seperti Word menambahkan *tag* tersembunyi yang membuat teks menjadi "format kaya" (rich text). Ini tidak kompatibel dengan Markdown yang hanya bekerja dengan *plain text*. Selalu gunakan editor teks polos.

-----

### Modul 1.2: Sintaks Dasar: Teks dan Struktur

#### **Struktur Pembelajaran Internal (Daftar Isi Mini):**

  * Judul (Headings)
  * Paragraf dan Baris Baru (Paragraphs & Line Breaks)
  * Penekanan Teks (Emphasis: Bold, Italic, Strikethrough)
  * Daftar (Lists: Ordered & Unordered)
  * Kutipan Blok (Blockquotes)
  * Hubungan dengan HTML
  * Tips dan Praktik Terbaik

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah blok bangunan fundamental Anda. Di sini, Anda akan mempelajari sintaks-sintaks yang paling sering digunakan dalam penulisan sehari-hari, baik untuk dokumentasi teknis maupun catatan pribadi. Anda akan belajar cara membuat judul untuk mengorganisir dokumen, memformat teks agar lebih mudah dibaca, dan menyusun informasi dalam bentuk daftar. Menguasai modul ini adalah prasyarat mutlak untuk semua hal lain yang akan Anda lakukan dengan Markdown.

#### Konsep Kunci & Filosofi Mendalam

Markdown menggunakan karakter yang sudah familiar dari lingkungan teks biasa (`#`, `*`, `>`) untuk memberikan makna struktural. Filosofi "keterbacaan" yang kita bahas di Modul 1.1 diimplementasikan secara langsung di sini. Setiap sintaks Markdown memiliki padanan yang logis dalam HTML, namun jauh lebih ringkas dan mudah dibaca. Contohnya, `# Judul 1` adalah representasi dari tag HTML `<h1>Judul 1</h1>`. Ini menunjukkan hubungan erat antara Markdown sebagai alat penulisan dan HTML sebagai *output* akhirnya.

#### Sintaks Dasar / Contoh Implementasi Inti

Berikut adalah contoh praktis dari setiap sintaks. Anda dapat mencobanya langsung di terminal Anda menggunakan `vim` atau editor teks pilihan Anda.

##### **1. Judul (Headings)**

Judul digunakan untuk memberikan hierarki pada dokumen Anda, mirip dengan bab dan sub-bab dalam sebuah buku.

  * **Sintaks:** Gunakan satu hingga enam tanda `#` di awal baris. Jumlah `#` menentukan level judul (misalnya, `#` untuk `h1`, `##` untuk `h2`).

  * **Contoh:**

    ```markdown
    # Ini adalah Judul Level 1

    ## Ini adalah Judul Level 2

    ### Ini adalah Judul Level 3

    #### Ini adalah Judul Level 4

    ##### Ini adalah Judul Level 5

    ###### Ini adalah Judul Level 6
    ```

  * **Studi Kasus:** Bayangkan Anda sedang menulis dokumentasi proyek. Anda bisa menggunakan `#` untuk nama proyek, `##` untuk setiap fitur, dan `###` untuk sub-bagian dari fitur tersebut.

##### **2. Paragraf dan Baris Baru**

Secara *default*, Markdown menganggap setiap baris teks sebagai bagian dari paragraf yang sama. Untuk membuat paragraf baru, Anda perlu menggunakan baris kosong.

  * **Sintaks:** Akhiri satu paragraf dengan **dua baris kosong** (tekan `Enter` dua kali) untuk memulai paragraf baru. Untuk baris baru di dalam paragraf yang sama, akhiri baris dengan dua spasi.

  * **Contoh:**

    ```markdown
    Ini adalah paragraf pertama.
    Teks ini masih berada di paragraf yang sama.

    Ini adalah paragraf kedua.
    ```

##### **3. Penekanan Teks (Emphasis)**

Digunakan untuk menyorot kata atau frasa tertentu.

  * **Sintaks:**

      * **Cetak Miring (Italic):** Gunakan satu tanda bintang (`*`) atau satu garis bawah (`_`).
      * **Cetak Tebal (Bold):** Gunakan dua tanda bintang (`**`) atau dua garis bawah (`__`).
      * **Coret (Strikethrough):** Gunakan dua tanda tilde (`~~`). Fitur ini adalah ekstensi dan tidak ada dalam Markdown asli.

  * **Contoh:**

    ```markdown
    Ini adalah teks *miring* atau _miring_.

    Ini adalah teks **tebal** atau __tebal__.

    Ini adalah teks yang ~~dicoret~~.
    ```

##### **4. Daftar (Lists)**

Markdown menawarkan dua jenis daftar: terurut (*ordered*) dan tidak terurut (*unordered*).

  * **Sintaks:**

      * **Daftar Tidak Terurut:** Gunakan tanda bintang (`*`), tanda plus (`+`), atau tanda hubung (`-`) di awal setiap item.
      * **Daftar Terurut:** Gunakan angka diikuti oleh titik (`1.`, `2.`, `3.`).

  * **Contoh:**

    ```markdown
    Daftar Belanjaan:
    * Apel
    * Susu
    * Roti

    Instruksi Membuat Kopi:
    1. Siapkan air panas.
    2. Masukkan bubuk kopi.
    3. Tambahkan gula sesuai selera.
    ```

##### **5. Kutipan Blok (Blockquotes)**

Digunakan untuk mengutip teks dari sumber lain.

  * **Sintaks:** Gunakan tanda lebih besar (`>`) di awal baris.

  * **Contoh:**

    ```markdown
    > "Ilmu tanpa agama buta, agama tanpa ilmu lumpuh."
    > — Albert Einstein
    ```

#### Terminologi Esensial & Penjelasan Detil

  * **Heading:** Judul atau sub-judul. Istilah ini berasal dari jurnalisme dan penulisan tradisional. Dalam konteks HTML, *heading* direpresentasikan oleh tag `<h1>` hingga `<h6>`.
  * **Emphasis:** Teknik penekanan teks. Istilah ini umum dalam tipografi.
  * **Ordered List:** Daftar yang item-itemnya berurutan, biasanya ditandai dengan angka.
  * **Unordered List:** Daftar yang item-itemnya tidak berurutan, biasanya ditandai dengan simbol seperti bullet point.
  * **Blockquote:** Sebuah kutipan yang menempati blok teksnya sendiri, seringkali dengan format visual yang berbeda untuk membedakannya dari teks utama.

#### Hubungan dengan Modul Lain

Modul ini adalah dasar yang paling esensial. Sintaks yang Anda pelajari di sini akan menjadi fondasi untuk modul-modul berikutnya. Misalnya, **Modul 2.1** tentang kode dan tabel adalah perluasan dari kemampuan pemformatan yang Anda pelajari di sini, menerapkan konsep yang sama ke data yang lebih terstruktur. Menguasai hierarki judul di sini sangat penting untuk mengelola dokumentasi yang besar di fase-fase berikutnya.

#### Sumber Referensi Lengkap

  * **Markdown Guide: Basic Syntax:** [The Markdown Guide: Basic Syntax](https://www.markdownguide.org/basic-syntax/) — Sumber yang sangat terperinci dan mudah diikuti untuk sintaks dasar.
  * **CommonMark Specification:** [CommonMark Spec: Blocks and Inlines](https://www.google.com/search?q=https://spec.commonmark.org/0.30/%23blocks-and-inlines) — Jika Anda ingin pemahaman teknis yang mendalam tentang aturan sintaks Markdown, CommonMark adalah standar yang perlu Anda pelajari. Ini sangat berguna untuk pengembangan alat.

#### Tips dan Praktik Terbaik

  * **Gunakan Spasi dengan Bijak:** Spasi sangat penting dalam Markdown. Selalu pastikan ada spasi setelah `#` untuk judul dan setelah `*` atau `1.` untuk daftar. Ini tidak hanya membuat kode Anda lebih mudah dibaca, tetapi juga mencegah kesalahan *rendering*.
  * **Konsistensi adalah Kunci:** Meskipun Markdown mengizinkan `*` atau `_` untuk cetak miring, dan `**` atau `__` untuk cetak tebal, pilih salah satu gaya dan konsistenlah. Kebanyakan komunitas lebih suka menggunakan `*` dan `**` karena lebih mudah diketik.
  * **Strikethrough (Coretan):** Fitur ini adalah ekstensi dari Markdown asli dan tidak didukung oleh semua *renderer*. Namun, ini adalah fitur standar di **GitHub Flavored Markdown (GFM)** yang sangat populer, jadi Anda akan sering menemukannya dalam dokumentasi proyek.

#### Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Lupa menyisipkan baris kosong antara judul dan paragraf berikutnya. Ini dapat menyebabkan judul tidak ter-*render* dengan benar atau digabungkan dengan paragraf di bawahnya.
      * **Solusi:** Selalu sisipkan baris kosong setelah setiap judul, daftar, atau kutipan. Praktik terbaik adalah selalu ada baris kosong di antara setiap blok elemen.
  * **Kesalahan:** Menggunakan tab untuk indentasi daftar.
      * **Solusi:** Meskipun beberapa *flavor* mendukungnya, praktik terbaik adalah menggunakan dua atau empat spasi untuk indentasi item daftar bersarang.

-----

### Representasi Visual Sintaks

Berikut adalah representasi visual untuk memahami hubungan antara teks yang Anda tulis dan struktur yang dihasilkan.

```
┌──────────────────────────┐
│      Judul Utama         │
│  ┌────────────────────┐  │  (Diwakili oleh `#`)
│  │   Judul Sekunder   │  │
│  │ ┌────────────────┐ │  │  (Diwakili oleh `##`)
│  │ │ Paragraf 1     │ │  │
│  │ │                │ │  │
│  │ │   * Poin A     │ │  │
│  │ │   * Poin B     │ │  │
│  │ └────────────────┘ │  │  (Daftar tidak terurut, diwakili oleh `*`)
│  │                    │  │
│  │ ┌────────────────┐ │  │
│  │ │ > Kutipan      │ │  │  (Diwakili oleh `>`)
│  │ └────────────────┘ │  │
│  └────────────────────┘  │
│                          │
└──────────────────────────┘
```

Diagram di atas menunjukkan bagaimana sintaks Markdown yang Anda tulis (*plain text*) secara logis merepresentasikan struktur hierarkis dari sebuah dokumen.

# Selamat!

Kita telah menyelesaikan fase 1

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
