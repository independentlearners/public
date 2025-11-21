## [Fase II: Intermediate (Menengah)][0]

### Deskripsi Konkret & Peran dalam Kurikulum

Fase ini adalah jembatan dari penggunaan Markdown yang sederhana ke tingkat yang lebih serius. Anda tidak lagi hanya membuat catatan pribadi, melainkan mulai menyusun dokumen yang lebih kompleks dan terstruktur. Modul-modul di fase ini akan memperkenalkan Anda pada cara menyajikan data (tabel) dan kode program, yang merupakan dua elemen paling penting dalam dokumentasi teknologi. Ini adalah langkah krusial untuk menjadikan Anda seorang penulis teknis yang profesional.

-----

### Modul 2.1: Kode dan Tabel

#### **Struktur Pembelajaran Internal (Daftar Isi Mini):**

<details>
  <summary>📃 Daftar Isi</summary>

  * Kode Sebaris (Inline Code)
  * Blok Kode (Fenced Code Blocks)
  * Tabel
  * Garis Horizontal (Horizontal Rules)
  * Hubungan dengan Markdown Flavors (seperti GFM)
  * Tips dan Praktik Terbaik
  * Potensi Kesalahan Umum & Solusi

</details>

-----

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah tentang **presisi dan kejelasan**. Dalam dunia IT, berbagi kode dan data adalah hal yang sangat umum. Markdown menyederhanakan proses ini dengan sintaks yang minimalis namun efektif. Kemampuan untuk menyisipkan kode program dengan penyorotan sintaks (syntax highlighting) dan membuat tabel yang rapi adalah ciri khas dari dokumentasi yang berkualitas. Modul ini mengajarkan Anda alat-alat yang diperlukan untuk pekerjaan tersebut.

#### Konsep Kunci & Filosofi Mendalam

Markdown memperlakukan kode dan tabel sebagai elemen khusus yang membutuhkan penandaan eksplisit. Filosofinya adalah **menjaga kode dan data agar tetap utuh dan mudah dibaca**.

  * **Kode:** Markdown melindungi kode dari pemformatan lain (seperti cetak tebal atau miring) dengan mengisolasi mereka. Konsep **`fenced code blocks`** adalah standar modern yang memungkinkan Anda tidak hanya menampilkan kode, tetapi juga memberitahu *renderer* jenis bahasa pemrograman apa yang digunakan, sehingga dapat dilakukan penyorotan sintaks otomatis.
  * **Tabel:** Meskipun tidak sekuat spreadsheet, tabel Markdown memberikan cara yang sederhana dan cepat untuk menampilkan data tabular tanpa perlu sintaks HTML yang rumit. Ini sangat ideal untuk daftar fitur, perbandingan, atau ringkasan data.

#### Sintaks Dasar / Contoh Implementasi Inti

##### **1. Kode Sebaris (Inline Code)**

Digunakan untuk menyorot potongan kode, nama file, atau perintah singkat di dalam sebuah paragraf.

  * **Sintaks:** Gunakan satu tanda *backtick* (`` ` ``) di awal dan akhir teks.

---

  * **Contoh:**

    ```markdown
    Untuk menginstal paket, jalankan perintah `sudo pacman -S [nama-paket]`.
    Variabel `user_name` menyimpan nama pengguna.
    ```
  * **Hasil:**
    
    Untuk menginstal paket, jalankan perintah `sudo pacman -S [nama-paket]`.
    Variabel `user_name` menyimpan nama pengguna.

---

  * **Tips Praktis:** Selalu gunakan kode sebaris untuk nama perintah, variabel, atau entri direktori. Ini membedakannya dari teks biasa dan meningkatkan keterbacaan.

##### **2. Blok Kode (Fenced Code Blocks)**

Digunakan untuk menampilkan blok kode yang lebih besar, seringkali dengan fitur penyorotan sintaks.

  * **Sintaks:** Gunakan tiga tanda *backtick* (\`\`\`) di awal dan di akhir blok. Anda bisa menambahkan nama bahasa pemrograman (misalnya `javascript`, \`python\`, \`bash\`) tepat setelah tanda pembuka untuk mengaktifkan penyorotan sintaks.

  * **Contoh:**

    Berikut adalah contoh skrip Bash sederhana:

    ````markdown 
    ```bash
    #!/bin/bash
    echo "Halo, Dunia!"
    ```
    ````
    
    Dan ini adalah contoh kode yang lain semisal Dart, tetapi anda bisa mengubahnya sesuai jenis kode, ubah `dart` menjadi `javascript` semisal, atau `python`, dsb:

    ````markdown
    ```dart
    void main() {
      print('Hello, World!');
    }
    ```
    ````

    Contoh di atas menunjukkan bagaimana sintaks Markdown melindungi kode dari pemformatan lain, dan bagaimana penambahan nama bahasa (`bash`, `dart`) memberikan informasi tambahan untuk *renderer*.

##### **3. Tabel**

Sintaks tabel adalah salah satu yang paling sering digunakan dalam dokumentasi teknis.

  * **Sintaks:** Gunakan tanda `|` (pipa) untuk memisahkan kolom dan tanda `-` untuk membuat garis pemisah. Anda bisa menggunakan `:` untuk menentukan perataan teks (kiri, kanan, tengah).

---

  * **Contoh:**

    ```markdown
    | Fitur         | Status                   | Catatan                  |
    |---------------|:-------------------------|:------------------------:|
    | Autentikasi   | :heavy_check_mark:       | Menggunakan OAuth 2.0    |
    | Pembayaran    | :x:                      | Masih dalam pengembangan |
    | Notifikasi    | :hourglass_flowing_sand: | Perlu diuji lebih lanjut |
    ```
  * **Hasilnya**
  
    | Fitur         | Status                   | Catatan                  |
    |---------------|:-------------------------|:------------------------:|
    | Autentikasi   | :heavy_check_mark:       | Menggunakan OAuth 2.0    |
    | Pembayaran    | :x:                      | Masih dalam pengembangan |
    | Notifikasi    | :hourglass_flowing_sand: | Perlu diuji lebih lanjut |

---

  * **Penjelasan:**

      * Baris pertama adalah **Header** (judul kolom).
      * Baris kedua, yang berisi `---`, adalah **Separator**. Tanda `:` di dalamnya mengontrol perataan.
          * `---` (default): Rata kiri.
          * `:---` : Rata kiri.
          * `:---:` : Rata tengah.
          * `---:` : Rata kanan.

#### Terminologi Esensial & Penjelasan Detil

  * **Backtick (`` ` ``):** Karakter `     ` yang digunakan untuk menandai kode sebaris.
  * **Fenced Code Blocks:** Istilah untuk blok kode yang "dipagari" (fenced) oleh tiga tanda *backtick*. Ini adalah standar yang lebih modern dan fleksibel dibandingkan indentasi empat spasi yang digunakan oleh Markdown asli.
  * **Syntax Highlighting:** Proses pewarnaan kode berdasarkan sintaksnya. Ini adalah fitur yang disediakan oleh *renderer* Markdown (bukan oleh Markdown itu sendiri) dan sangat penting untuk membaca kode dengan cepat.
  * **Pipa (`|`):** Karakter vertikal yang berfungsi sebagai pemisah kolom dalam tabel Markdown.
  * **Table Column Alignment:** Perataan konten di dalam kolom tabel, yang dikendalikan oleh posisi tanda titik dua (`:`) pada baris pemisah.

#### Hubungan dengan Modul Lain

Sintaks yang Anda pelajari di sini akan sering berinteraksi dengan sintaks dari **Modul 1.2**. Misalnya, Anda bisa menyisipkan tautan (dari **Modul 2.2**) di dalam sebuah sel tabel. Ini juga menjadi prasyarat untuk pemahaman **Modul 3.1**, di mana Anda akan belajar tentang **GitHub Flavored Markdown (GFM)** yang memperluas sintaks tabel dan kode ini dengan emoji atau *task list*.

#### Sumber Referensi Lengkap

  * **Markdown Guide: Code Blocks:** [Markdown Guide: Code Blocks](https://www.google.com/search?q=https://www.markdownguide.org/extended-syntax/%23code-blocks) — Panduan yang sangat jelas tentang sintaks blok kode.
  * **Markdown Guide: Tables:** [Markdown Guide: Tables](https://www.google.com/search?q=https://www.markdownguide.org/extended-syntax/%23tables) — Penjelasan detail tentang cara membuat tabel.
  * **GitHub Docs: Fenced Code Blocks:** [GitHub Docs: Fenced Code Blocks](https://www.google.com/search?q=https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax%23quoting-code) — Contoh langsung dari bagaimana GitHub (salah satu implementasi GFM terpopuler) menangani blok kode.

#### Tips dan Praktik Terbaik

  * **Penyorotan Bahasa:** Selalu tentukan bahasa pemrograman pada blok kode Anda. Ini tidak hanya meningkatkan keterbacaan, tetapi juga membantu alat otomatisasi yang mungkin memproses dokumen Anda.
  * **Gunakan Spasi Ekstra:** Dalam tabel, Anda bisa menambahkan spasi di sekitar tanda `|` untuk membuatnya terlihat lebih rapi di editor teks, meskipun *renderer* akan mengabaikannya.
  * **Kesederhanaan Tabel:** Jangan mencoba membuat tabel yang terlalu rumit dengan penggabungan sel atau baris. Markdown tidak dirancang untuk itu. Gunakan HTML atau alat lain jika tabel Anda sangat kompleks.

#### Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Lupa menambahkan baris pemisah (---) di bawah *header* tabel.
      * **Solusi:** Selalu sertakan baris `|---|---|` untuk memisahkan *header* dari konten tabel. Tanpa baris ini, Markdown tidak akan mengenali tabel.
  * **Kesalahan:** Mencoba menyisipkan baris kosong di dalam tabel.
      * **Solusi:** Markdown tidak mendukung baris kosong di dalam tabel. Jika Anda membutuhkannya, Anda harus mempertimbangkan untuk menggunakan HTML di dalam file Markdown atau membuat tabel baru.

-----

### Representasi Visual Sintaks

Berikut adalah contoh visualisasi yang menggabungkan semua sintaks yang telah kita pelajari.

````
┌──────────────────────────────────────────┐
│             Dokumen Proyek               │
│  ┌────────────────────────────────────┐  │
│  │                                    │  │
│  │   Judul Utama                      │  │
│  │     (Menggunakan `#`)              │  │
│  │                                    │  │
│  │   Paragraf dengan `inline code`    │  │
│  │                                    │  │
│  │   ┌──────────────────────────┐     │  │
│  │   │   Blok Kode              │     │  │
│  │   │   ```javascript          │     │  │
│  │   │   (Kode dengan syntax)   │     │  │
│  │   │   ```                    │     │  │
│  │   └──────────────────────────┘     │  │
│  │                                    │  │
│  │   Tabel Fitur                  (Contoh Tabel)
│  │     ┌─────────┬──────────────┐     │  │
│  │     │ Header  │ Header       │     │  │
│  │     │ :-------|:-------------│     │  │
│  │     │ Konten  │ Konten       │     │  │
│  │     └─────────┴──────────────┘     │  │
│  │                                    │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
````

Diagram ini menunjukkan bagaimana berbagai elemen Markdown (judul, paragraf, kode, tabel) dapat disusun untuk membuat dokumen yang terstruktur dan mudah dibaca secara profesional.

-----

### Modul 2.2: Tautan dan Gambar Tingkat Lanjut

#### **Struktur Pembelajaran Internal (Daftar Isi Mini):**

  * Tautan Standar (Standard Links)
  * Tautan Otomatis (Automatic Links)
  * Tautan Referensi (Reference-style Links)
  * Gambar (Images)
  * Gambar dengan Tautan
  * Tips dan Praktik Terbaik
  * Potensi Kesalahan Umum & Solusi

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah tentang **konektivitas dan visualisasi**. Di era digital, konten tidak pernah berdiri sendiri. Tautan dan gambar adalah elemen esensial yang menghubungkan dokumen Anda dengan sumber eksternal dan memperkaya konten visual. Modul ini mengajarkan Anda cara menyisipkan tautan dan gambar dengan cara yang fleksibel dan profesional, memungkinkan Anda membuat dokumentasi yang tidak hanya informatif tetapi juga mudah dinavigasi.

#### Konsep Kunci & Filosofi Mendalam

Filosofi di balik tautan dan gambar di Markdown adalah **efisiensi penulisan**. Markdown menyederhanakan sintaks HTML yang rumit (`<a href="...">...</a>` dan `<img src="...">`) menjadi format yang ringkas.

  * **Tautan (Links):** Markdown menawarkan beberapa cara untuk membuat tautan. Tautan standar mudah dan intuitif, tetapi **tautan referensi** adalah konsep yang lebih kuat. Filosofi di baliknya adalah **memisahkan konten dari data**. Dengan memindahkan URL ke bagian bawah dokumen, Anda menjaga teks utama tetap rapi dan mudah dibaca. Ini sangat berguna untuk dokumen dengan banyak tautan.
  * **Gambar (Images):** Sintaks gambar sangat mirip dengan tautan, mencerminkan fakta bahwa gambar pada dasarnya adalah tautan ke sebuah file.

#### Sintaks Dasar / Contoh Implementasi Inti

##### **1. Tautan Standar (Standard Links)**

Tautan paling umum yang akan Anda gunakan.

  * **Sintaks:** Teks tautan diapit oleh kurung siku (`[]`), diikuti oleh URL di dalam kurung biasa (`()`). Anda dapat menambahkan teks *hover* opsional di dalam tanda kutip.

---

  * **Contoh:**

    ```markdown
    Silakan kunjungi [situs resmi Google](https://www.google.com "Kunjungi Google").
    ```

  * **Hasilnya**
  
    Silakan kunjungi [situs resmi Google](https://www.google.com "Kunjungi Google").

---

##### **2. Tautan Otomatis (Automatic Links)**

Markdown dapat secara otomatis mengubah URL atau alamat email menjadi tautan yang dapat diklik.

  * **Sintaks:** Cukup apit URL atau alamat email dengan tanda kurung sudut (`<>`).

  * **Contoh:**

    ```markdown
    Email saya di <support@example.com>.
    Kunjungi situs ini: <https://www.example.com>.
    ```

##### **3. Tautan Referensi (Reference-style Links)**

Ini adalah teknik yang lebih canggih untuk mengelola tautan. Ini memisahkan definisi URL dari teks utama.

  * **Sintaks:** Teks tautan diapit `[]`, diikuti oleh label referensi di dalam kurung siku kedua. Definisi label referensi diletakkan di bagian lain dari dokumen (biasanya di bagian bawah), menggunakan sintaks `[label]: URL`.

  * **Contoh:**

    ```markdown
    [Google][google-link] adalah mesin pencari terkemuka.

    [google-link]: https://www.google.com

    Silakan lihat contoh lain pada [Dokumentasi Markdown][md-docs].

    [md-docs]: https://www.markdownguide.org/
    ```

  * **Studi Kasus:** Bayangkan Anda sedang menulis laporan teknis dengan 50 tautan berbeda. Menggunakan tautan referensi membuat teks utama Anda bersih, dan Anda dapat mengelola semua URL dari satu bagian. Ini juga mempermudah pembaruan URL di masa depan.

##### **4. Gambar (Images)**

Sintaks gambar sangat mirip dengan tautan, hanya dengan tambahan tanda seru (`!`) di depannya.

  * **Sintaks:** Tanda seru (`!`), diikuti oleh teks alternatif di dalam kurung siku (`[]`), dan URL gambar di dalam kurung biasa (`()`).

  * **Contoh:**

    ```markdown
    ![Logo Markdown](https://www.markdown.org/img/logo.svg)
    ```

  * **Penjelasan:** Teks alternatif ("Logo Markdown") adalah teks yang akan ditampilkan jika gambar tidak dapat dimuat. Ini sangat penting untuk **aksesibilitas** dan SEO.

##### **5. Gambar dengan Tautan**

Anda bisa menggabungkan sintaks gambar dan tautan untuk membuat gambar yang dapat diklik.

  * **Sintaks:** Masukkan sintaks gambar di dalam kurung siku pertama dari sintaks tautan.

  * **Contoh:**

    ```markdown
    [![Logo Github](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png)](https://github.com)
    ```

#### Terminologi Esensial & Penjelasan Detil

  * **URL (Uniform Resource Locator):** Alamat unik yang digunakan untuk mengidentifikasi sumber daya di web.
  * **Teks Alternatif (Alt Text):** Teks yang menjelaskan isi gambar. Penting untuk pengguna dengan gangguan penglihatan yang menggunakan pembaca layar.
  * **Referensial:** Suatu gaya atau metode yang mengacu pada sumber lain, dalam hal ini URL yang didefinisikan secara terpisah.

#### Hubungan dengan Modul Lain

Penggunaan tautan dan gambar tingkat lanjut ini akan sangat sering Anda temui dalam alur kerja profesional. Ini akan menjadi prasyarat untuk **Modul 3.2: Alur Kerja Profesional dan Otomasi**, di mana Anda akan belajar bagaimana alat seperti Pandoc dapat mengolah dokumen Markdown yang berisi gambar dan tautan ini untuk membuat dokumen akhir yang profesional.

#### Sumber Referensi Lengkap

  * **Markdown Guide: Images:** [Markdown Guide: Images](https://www.google.com/search?q=https://www.markdownguide.org/basic-syntax/%23images)
  * **Markdown Guide: Links:** [Markdown Guide: Links](https://www.google.com/search?q=https://www.markdownguide.org/basic-syntax/%23links)
  * **GitHub Docs: Links and Images:** [GitHub Docs: Links and Images](https://www.google.com/search?q=https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax%23links)

#### Tips dan Praktik Terbaik

  * **Gunakan Teks Deskriptif:** Dalam tautan, gunakan teks yang deskriptif dan informatif. Hindari teks seperti `[klik di sini]`. Sebaliknya, gunakan `[baca dokumentasi selengkapnya]`.
  * **Kerapian dengan Tautan Referensi:** Tempatkan semua definisi tautan referensi di bagian bawah dokumen Anda untuk menjaga keterbacaan. Ini adalah praktik standar dalam komunitas penulis teknis.
  * **Manajemen Gambar:** Untuk proyek besar, simpan semua gambar dalam satu direktori (`/images` atau `/assets`) dan gunakan jalur relatif dalam sintaks Markdown Anda.

#### Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Lupa tanda seru `!` di depan sintaks gambar.
      * **Solusi:** Selalu ingat, tanda seru adalah pembeda antara tautan dan gambar.
  * **Kesalahan:** Menggunakan jalur file absolut (*absolute path*) untuk gambar lokal.
      * **Solusi:** Untuk portabilitas, selalu gunakan jalur relatif (*relative path*) dari file `.md` Anda. Misalnya, `![gambar](/assets/gambar.jpg)` lebih baik daripada `![gambar](C:/Users/User/Documents/gambar.jpg)`. Jalur relatif memastikan dokumen Anda akan berfungsi di mana pun ia ditempatkan.

-----

### Representasi Visual Sintaks

Berikut adalah diagram yang menunjukkan struktur tautan dan gambar.

```
┌───────────────────────────────────────┐
│              Elemen Tautan            │
│  ┌───────────────────────────────────┐│
│  │ [Teks Tautan](https://example.com)│─────┐
│  │ (Teks + URL)                      ││    │
│  │                                   ││    ▼
│  │ [Teks Referensi][referensi-id]    ││   Tautan Standar
│  │ (ID Tautan)                       ││
│  │                                   ││
│  │ [referensi-id]: https://example.org│─────┐
│  │ (Definisi URL)                    ││     │
│  └───────────────────────────────────┘│     ▼
│                                       │   Tautan Referensi
│             (Teks bersih)             │
│                                       │
│ ┌───────────────────────────────────┐ │
│ │          Elemen Gambar            │ │
│ └───────────────────────────────────┘ │
│                                       │
│ ┌───────────────────────────────────┐ │
│ │ ![Alt Text](https://url.com/img.jpg)│─────┐
│ │ (Tanda ! + Teks Alternatif + URL) │ │     │
│ └───────────────────────────────────┘ │     ▼
│                                       │   Gambar
└───────────────────────────────────────┘
```

Diagram ini secara visual membedakan dan menyederhanakan cara kerja tautan standar, tautan referensi, dan gambar dalam Markdown.

# Selamat!

Fase 2 Selesai!!

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

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
