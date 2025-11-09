### **[Fase 2: Level Menengah (Intermediate)][0]**

Fase ini akan membawa Anda melampaui penggunaan Helix sebagai editor default dan mulai mengubahnya menjadi "senjata" pribadi yang sepenuhnya disesuaikan dengan kebutuhan Anda. Anda akan belajar cara mengkonfigurasi tampilan, perilaku, dan mengintegrasikannya dengan alat pengembangan modern untuk pengalaman yang lebih cerdas.

-----

### **Modul 3: Konfigurasi dan Personalisasi**

<details>
  <summary>📃 Struktur Pembelajaran Internal</summary>

-----

1.  **Deskripsi Konkret & Peran dalam Kurikulum**
2.  **Konsep Kunci & Filosofi Mendalam**
      * Filosofi Konfigurasi Helix: Sederhana dan Deklaratif
      * Bahasa Konfigurasi TOML: Kejelasan di Atas Segalanya
3.  **Sintaks Dasar / Contoh Implementasi Inti**
      * Lokasi File Konfigurasi
      * Mengubah Tema
      * Mengatur Opsi Editor
      * Mengganti Pemetaan Kunci (Keybindings)
4.  **Terminologi Esensial & Penjelasan Detil**
      * `TOML` (Tom's Obvious, Minimal Language)
      * `Theme` (Tema)
      * `Keybinding` (Pemetaan Kunci)
5.  **Rekomendasi Visualisasi**
6.  **Hubungan dengan Modul Lain**
7.  **Sumber Referensi Lengkap**
8.  **Tips dan Praktik Terbaik**
9.  **Potensi Kesalahan Umum & Solusi**

</details>

-----

### **1. Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini akan mengajarkan Anda cara menyesuaikan setiap aspek dari Helix, mulai dari warna hingga fungsi tombol. Secara konkret, Anda akan belajar cara menemukan dan memodifikasi file konfigurasi utama Helix. Anda akan dapat mengubah skema warna (tema), mengaktifkan atau menonaktifkan fitur tertentu, dan memetakan ulang perintah ke tombol yang Anda inginkan.

Peran modul ini sangat krusial. Editor apa pun yang tidak dapat disesuaikan akan membatasi produktivitas Anda. Dengan menguasai konfigurasi, Anda mengubah Helix dari sekadar alat menjadi sebuah ekstensi dari alur kerja (workflow) Anda sendiri. Personalisasi ini akan membuat pengalaman pengeditan Anda tidak hanya lebih efisien tetapi juga lebih menyenangkan.

### **2. Konsep Kunci & Filosofi Mendalam**

#### **Filosofi Konfigurasi Helix: Sederhana dan Deklaratif**

Filosofi konfigurasi Helix berbeda dari editor lainnya. Sementara Vim/Neovim menggunakan bahasa pemrograman (`VimL` atau `Lua`) untuk konfigurasinya, Helix menggunakan format data yang lebih sederhana, yaitu **TOML**.

Tujuannya adalah:

  * **Kesederhanaan:** TOML mudah dibaca dan ditulis, bahkan oleh non-programmer sekalipun. Ini menghilangkan kurva pembelajaran yang curam dari bahasa scripting editor.
  * **Deklaratif:** Anda tidak perlu menulis "bagaimana" editor harus bertindak, tetapi cukup mendeklarasikan "apa" yang Anda inginkan (misalnya, `theme = "tokyonight_night"`). Ini membuat konfigurasi lebih mudah dipahami dan dikelola.
  * **"Batteries-Included":** Helix dirancang dengan fitur-fitur esensial yang sudah terpasang. Ini mengurangi ketergantungan pada plugin dan konfigurasi yang rumit, sehingga Anda hanya perlu menyesuaikan apa yang benar-benar Anda butuhkan.

#### **Bahasa Konfigurasi TOML: Kejelasan di Atas Segalanya**

**TOML** adalah singkatan dari **Tom's Obvious, Minimal Language**. Itu adalah bahasa konfigurasi yang didesain untuk menjadi minimal dan mudah dibaca karena semantiknya yang jelas.

  * **Sintaks:** Menggunakan struktur `kunci = "nilai"` dan tabel (`[nama_tabel]`). Ini membuat konfigurasi menjadi hierarkis dan terorganisir dengan baik, seperti contoh berikut:

<!-- end list -->

```toml
[editor]
line-number = "relative"

[editor.cursor-shape]
normal = "bar"
```

Ini menunjukkan bahwa ada sebuah "tabel" bernama `editor`, yang di dalamnya terdapat kunci `line-number`. Lalu, ada juga sub-tabel `cursor-shape` di dalam `editor`. Struktur ini sangat logis dan mudah diikuti.

### **3. Sintaks Dasar / Contoh Implementasi Inti**

#### **Lokasi File Konfigurasi**

Sebelum memulai, Anda perlu tahu di mana file konfigurasi berada. Helix mencari file ini di lokasi standar.

  * **Linux & macOS:** `~/.config/helix/config.toml`

Jika file ini tidak ada, Anda bisa membuatnya secara manual. Helix akan menggunakan konfigurasi *default* internal jika tidak ada file yang ditemukan.

#### **Mengubah Tema**

Salah satu penyesuaian pertama yang sering dilakukan adalah mengubah tema. Helix memiliki banyak tema bawaan. Anda dapat melihat daftar lengkapnya di [repositori GitHub Helix](https://www.google.com/search?q=https://github.com/helix-editor/helix/tree/master/helix-term/themes).

  * **Contoh:**
    1.  Buka file `config.toml` Anda dengan Helix: `hx ~/.config/helix/config.toml`.
    2.  Tambahkan atau modifikasi baris berikut:
    <!-- end list -->
    ```toml
    theme = "nord"
    ```
    3.  Simpan file (`:w`) dan *restart* Helix, atau muat ulang konfigurasi tanpa *restart* dengan `:config-reload`. Editor Anda akan langsung berubah.

#### **Mengatur Opsi Editor**

Anda bisa menyesuaikan berbagai opsi yang memengaruhi cara Helix berinteraksi dengan teks.

  * **Contoh:** Mengubah nomor baris menjadi relatif (untuk navigasi yang lebih cepat), dan mengaktifkan *ruler* (garis pembatas kolom).

<!-- end list -->

```toml
[editor]
line-number = "relative" # Baris relatif sangat membantu navigasi dengan 'j' dan 'k'
rulers = [80, 100]       # Menampilkan garis di kolom 80 dan 100
```

  * **Catatan:** Mengubah nomor baris menjadi relatif berarti baris di sekitar kursor akan dinomori secara relatif terhadap posisi kursor. Contoh, jika kursor berada di baris 50, baris di atasnya akan menjadi 1, 2, 3, dst., dan baris di bawahnya juga akan menjadi 1, 2, 3, dst. Ini memudahkan Anda untuk melompat cepat dengan perintah seperti `10j` (turun 10 baris).

#### **Mengganti Pemetaan Kunci (Keybindings)**

Ini adalah bagian terkuat dari kustomisasi. Anda dapat memetakan ulang *shortcut* bawaan atau bahkan membuat yang baru. Struktur ini sangat fleksibel.

  * **Contoh:** Mengganti *shortcut* untuk menyimpan file dari `:w` menjadi `Ctrl+s`.

<!-- end list -->

```toml
[keys.normal]
"C-s" = ":w"
```

  * **Penjelasan:**
      * `[keys.normal]` menunjukkan bahwa pemetaan kunci ini hanya berlaku di **Normal Mode**.
      * `"C-s"` adalah sintaks untuk `Ctrl+s`.
      * `":w"` adalah perintah yang akan dijalankan ketika kombinasi tombol tersebut ditekan.

Dengan cara ini, Anda dapat menyesuaikan Helix agar lebih familier dengan kebiasaan Anda dari editor lain, atau membuat *shortcut* yang sepenuhnya baru dan unik.

### **4. Terminologi Esensial & Penjelasan Detil**

  * **`TOML` (Tom's Obvious, Minimal Language):**
      * **Arti:** Sebuah format file konfigurasi yang didesain untuk menjadi mudah dibaca dan ditulis.
      * **Maksud:** Ini adalah format yang digunakan oleh Helix untuk semua pengaturannya. Memahami sintaks dasarnya adalah kunci untuk melakukan kustomisasi.
  * **`Theme` (Tema):**
      * **Arti:** Kumpulan pengaturan warna yang menentukan tampilan visual editor.
      * **Maksud:** Anda dapat mengubah warna latar belakang, warna teks, penyorotan sintaks, dan lainnya. Ini penting untuk estetika dan kenyamanan mata.
  * **`Keybinding` (Pemetaan Kunci):**
      * **Arti:** Sebuah pemetaan dari kombinasi tombol keyboard ke sebuah perintah.
      * **Maksud:** Ini adalah cara Anda mengontrol Helix. Mengubah *keybinding* memungkinkan Anda untuk membuat alur kerja Anda sendiri yang lebih cepat dan sesuai dengan preferensi ergonomis Anda.

### **5. Rekomendasi Visualisasi**

Sebuah **diagram pohon (tree diagram)** untuk struktur file konfigurasi akan sangat membantu. Diagram ini dapat menggambarkan hubungan hierarkis dari tabel dan sub-tabel dalam `config.toml`, seperti `[editor]`, `[editor.cursor-shape]`, dan `[keys.normal]`. Ini akan memberikan pemahaman visual yang jelas tentang bagaimana konfigurasi disusun.

### **6. Hubungan dengan Modul Lain**

Modul ini adalah jembatan menuju fase-fase berikutnya.

  * **Modul 4 (Integrasi):** Konfigurasi adalah prasyarat untuk mengintegrasikan LSP dan Tree-sitter. Anda akan memodifikasi file `languages.toml` untuk mengaktifkan fitur-fitur tersebut, yang merupakan bagian dari sistem konfigurasi Helix.
  * **Fase 3 & 4 (Mahir & Ahli):** Memahami konfigurasi adalah kunci untuk membuat makro, skrip, dan bahkan berkontribusi pada kode sumber. Anda harus tahu di mana dan bagaimana perubahan yang Anda buat dapat diintegrasikan dengan sistem yang ada.

### **7. Sumber Referensi Lengkap**

  * **Dokumentasi Resmi Helix:**
      * [Configuration](https://docs.helix-editor.com/configuration.html): Panduan lengkap untuk semua opsi konfigurasi.
      * [Themes](https://docs.helix-editor.com/themes.html): Daftar semua tema bawaan dan cara membuatnya sendiri.
      * [Keymap](https://docs.helix-editor.com/keymap.html): Referensi untuk semua pemetaan kunci *default* dan cara memodifikasinya.
  * **Situs Resmi TOML:**
      * [TOML: Tom's Obvious, Minimal Language](https://toml.io/en/): Halaman resmi dengan spesifikasi lengkap TOML.

### **8. Tips dan Praktik Terbaik**

  * **Versi Kontrol Konfigurasi:** Simpan file `config.toml` Anda dalam sistem kontrol versi seperti **Git**. Ini akan memungkinkan Anda untuk melacak perubahan, membagikannya di antara mesin yang berbeda, atau kembali ke versi sebelumnya jika terjadi kesalahan. Ini juga praktik umum di kalangan pengguna CLI *power-user*.
  * **Mulai dari yang Minimal:** Jangan mencoba mengubah terlalu banyak hal sekaligus. Mulai dengan perubahan kecil yang paling Anda butuhkan, seperti tema atau `line-number`, lalu perlahan-lahan sesuaikan *keybinding* seiring waktu.
  * **Manfaatkan `languages.toml`:** Selain `config.toml`, ada file `languages.toml` di direktori yang sama. File ini digunakan untuk mengkonfigurasi integrasi dengan Language Server Protocol (LSP) untuk setiap bahasa pemrograman.

### **9. Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Kesalahan sintaks pada `config.toml`, seperti lupa tanda koma atau tanda kurung.
      * **Solusi:** Periksa kembali file Anda dengan cermat. Helix akan menunjukkan peringatan atau error di terminal saat diluncurkan jika ada masalah. Gunakan perintah `hx --health` untuk memeriksa kesehatan konfigurasi Anda.
  * **Kesalahan:** *Keybinding* yang baru tidak berfungsi.
      * **Solusi:** Pastikan Anda meletakkannya di bawah `[keys.normal]` jika Anda ingin itu berfungsi di Normal Mode. Pastikan juga tidak ada tabrakan dengan *keybinding* bawaan.
  * **Kesalahan:** Tema yang baru tidak terlihat seperti yang diharapkan.
      * **Solusi:** Pastikan nama tema yang Anda tulis di `config.toml` sudah benar dan sesuai dengan nama file tema yang ada di instalasi Helix Anda.

-----

Modul ini telah memberikan Anda kontrol penuh atas tampilan dan perilaku dasar Helix. Setelah ini, Anda akan memiliki fondasi yang kuat untuk mengintegrasikannya dengan alat-alat pengembang yang lebih canggih.

### **Modul 4: Manajemen Proyek dan Integrasi Eksternal**

**Struktur Pembelajaran Internal:**

1.  **Deskripsi Konkret & Peran dalam Kurikulum**
2.  **Konsep Kunci & Filosofi Mendalam**
      * Filosofi Integrasi Helix: "Batteries-Included"
      * Language Server Protocol (LSP): Otak Editor
      * Tree-sitter: Mesin Pemahaman Sintaksis
3.  **Sintaks Dasar / Contoh Implementasi Inti**
      * Menggunakan `Telescope Mode` untuk Navigasi Proyek
      * Mengaktifkan LSP di `languages.toml`
      * Perintah Utama LSP (Definisi, Referensi, Diagnostik)
4.  **Terminologi Esensial & Penjelasan Detil**
      * `Language Server Protocol (LSP)`
      * `Tree-sitter`
      * `Diagnostik`
      * `Telescope Mode`
      * `Git`
5.  **Rekomendasi Visualisasi**
6.  **Hubungan dengan Modul Lain**
7.  **Sumber Referensi Lengkap**
8.  **Tips dan Praktik Terbaik**
9.  **Potensi Kesalahan Umum & Solusi**

-----

### **1. Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini akan mengajarkan Anda cara mengelola file di dalam sebuah proyek dan mengintegrasikan Helix dengan alat-alat cerdas. Secara konkret, Anda akan belajar cara berpindah antar file dengan cepat, mencari teks di seluruh proyek, dan memanfaatkan fitur-fitur yang biasanya hanya ada di IDE (Integrated Development Environment) lengkap, seperti penyelesaian kode, pemeriksaan kesalahan (diagnostik), dan lompat ke definisi.

Peran modul ini sangat penting untuk pengembang. Editor teks yang hanya bisa mengedit tidaklah cukup. Dengan mengintegrasikan **LSP** dan **Tree-sitter**, Helix berubah menjadi alat pengembangan yang tangguh. Ini akan meningkatkan produktivitas Anda secara signifikan, memungkinkan Anda untuk menulis kode lebih cepat, menemukan kesalahan lebih dini, dan menavigasi kode yang kompleks dengan mudah.

### **2. Konsep Kunci & Filosofi Mendalam**

#### **Filosofi Integrasi Helix: "Batteries-Included"**

Berbeda dengan editor seperti Vim atau Emacs yang sangat bergantung pada plugin, Helix menganut filosofi **"batteries-included"**. Ini berarti banyak fitur canggih, termasuk integrasi dengan **LSP** dan **Tree-sitter**, sudah ada di dalam kode intinya. Anda tidak perlu menginstal plugin tambahan yang rumit; Anda hanya perlu mengaktifkan dan mengkonfigurasinya.

Pendekatan ini menjamin stabilitas dan performa yang lebih baik. Karena fitur-fitur ini dikembangkan dan dikelola oleh tim inti yang sama, mereka terintegrasi dengan sempurna ke dalam arsitektur editor, menciptakan pengalaman yang mulus.

#### **Language Server Protocol (LSP): Otak Editor**

**LSP** adalah protokol standar yang dikembangkan oleh Microsoft. Tujuan utamanya adalah untuk memisahkan logika bahasa (misalnya, penyelesaian kode, diagnostik, pemformatan) dari editor itu sendiri.

**Alur kerjanya seperti ini:**

1.  Anda sebagai pengguna mengetik kode di Helix.
2.  Helix, yang bertindak sebagai "LSP Client", mengirimkan informasi kode tersebut ke "LSP Server" yang sesuai (misalnya, `rust-analyzer` untuk Rust).
3.  LSP Server memproses kode tersebut, menganalisisnya, dan mengirimkan kembali informasi cerdas ke Helix (misalnya, daftar fungsi yang bisa digunakan, lokasi kesalahan, atau definisi sebuah variabel).
4.  Helix kemudian menampilkan informasi ini kepada Anda di antarmuka editor.

Filosofi di baliknya adalah **reusability** (kemampuan untuk digunakan kembali). Satu server bahasa dapat digunakan oleh banyak editor (VS Code, Helix, Neovim). Ini menghemat upaya pengembang dan menjamin fitur-fitur yang konsisten.

#### **Tree-sitter: Mesin Pemahaman Sintaksis**

**Tree-sitter** adalah parser incremental yang sangat cepat. Alih-alih hanya mencocokkan kata kunci seperti penyorotan sintaks tradisional, Tree-sitter membangun **Abstract Syntax Tree (AST)** atau pohon sintaksis abstrak dari kode Anda.

**Mengapa ini penting?**

  * **Penyorotan Sintaks Akurat:** Dengan memahami struktur kode, Tree-sitter dapat menyorot sintaks dengan sangat akurat, bahkan di dalam blok kode yang kompleks atau bercampur (misalnya, JavaScript di dalam HTML).
  * **Navigasi Cerdas:** Pemahaman struktur ini memungkinkan Helix untuk melakukan navigasi yang lebih cerdas, seperti melompat antar fungsi atau blok kode dengan mudah.

Helix menggunakan Tree-sitter secara natif untuk penyorotan sintaks, pemformatan kode, dan navigasi. Ini adalah bagian penting dari arsitektur yang membuat Helix begitu kuat.

### **3. Sintaks Dasar / Contoh Implementasi Inti**

#### **Menggunakan `Telescope Mode` untuk Navigasi Proyek**

Helix memiliki sebuah "command palette" yang disebut **Telescope Mode**. Ini adalah antarmuka interaktif yang sangat cepat untuk mencari dan berpindah antar file.

  * **Membuka File Picker (Pencari Berkas):**
      * Tekan `space f`. Sebuah antarmuka pop-up akan muncul, menampilkan semua file di dalam direktori proyek Anda. Anda bisa mulai mengetik untuk memfilter hasilnya secara instan.
  * **Mencari Teks di Seluruh Proyek (grep):**
      * Tekan `space /`. Ini akan membuka pencarian teks di seluruh file proyek. Hasil pencarian akan ditampilkan secara interaktif, dan Anda dapat melompat ke setiap kemunculan teks yang ditemukan.
  * **Membuka Command Palette:**
      * Tekan ` space  ` (spasi dua kali). Ini akan membuka daftar semua perintah Helix yang tersedia. Anda bisa mulai mengetik untuk mencari perintah yang Anda inginkan.

#### **Mengaktifkan LSP di `languages.toml`**

Untuk mengaktifkan LSP, Anda harus menginstal server bahasa yang relevan dan kemudian memberi tahu Helix tentang server tersebut melalui file `languages.toml`.

  * **Lokasi File:** `~/.config/helix/languages.toml`

  * **Contoh:** Mengaktifkan **rust-analyzer** untuk Rust.

<!-- end list -->

```toml
[[language]]
name = "rust"
language-server = { command = "rust-analyzer" }
```

  * **Penjelasan:**
      * `[[language]]`: Mendeklarasikan bahwa Anda akan mendefinisikan konfigurasi untuk sebuah bahasa.
      * `name = "rust"`: Nama bahasa yang akan dikonfigurasi.
      * `language-server = { command = "rust-analyzer" }`: Mendeklarasikan bahwa untuk bahasa Rust, perintah untuk menjalankan server bahasanya adalah `"rust-analyzer"`. Helix akan mencoba menjalankan perintah ini saat Anda membuka file `.rs`.

#### **Perintah Utama LSP**

Setelah LSP aktif, Anda dapat menggunakan perintah berikut (di Normal Mode):

  * `gd`: Lompat ke **definisi** (go to definition) dari simbol di bawah kursor.
  * `gr`: Lompat ke semua **referensi** (go to references) dari simbol di bawah kursor.
  * `gh`: Tampilkan **informasi** (go to hover) dari simbol di bawah kursor.
  * `ga`: Tampilkan **aksi kode** (go to code actions) yang relevan (misalnya, `refactor` atau perbaikan otomatis).
  * `space f`: Buka pencari berkas.

### **4. Terminologi Esensial & Penjelasan Detil**

  * **`Language Server Protocol (LSP)`:**
      * **Arti:** Protokol komunikasi standar antara editor teks dan server bahasa.
      * **Maksud:** Ini adalah standar industri yang memungkinkan Helix memiliki fitur-fitur canggih seperti penyelesaian kode, diagnostik, dan definisi tanpa harus mengimplementasikannya dari awal untuk setiap bahasa.
  * **`Tree-sitter`:**
      * **Arti:** Parser yang cepat dan inkremental untuk membangun pohon sintaksis dari kode.
      * **Maksud:** Helix menggunakannya untuk memahami struktur kode Anda, memungkinkan penyorotan sintaks yang akurat dan navigasi yang cerdas.
  * **`Diagnostik`:**
      * **Arti:** Informasi yang diberikan oleh LSP tentang potensi kesalahan, peringatan, atau saran di dalam kode.
      * **Maksud:** Di Helix, ini biasanya ditandai di sebelah baris kode dan memberikan umpan balik secara real-time saat Anda mengetik.
  * **`Telescope Mode`:**
      * **Arti:** Antarmuka pencarian dan perintah interaktif bawaan Helix.
      * **Maksud:** Ini adalah cara utama untuk menavigasi file, mencari teks, dan menjalankan perintah di seluruh proyek Anda.
  * **`Git`:**
      * **Arti:** Sistem kontrol versi terdistribusi yang melacak perubahan dalam kode sumber selama pengembangan perangkat lunak.
      * **Maksud:** Meskipun Helix tidak memiliki antarmuka Git yang lengkap seperti GUI, ia mengintegrasikan status Git (`stage`, `unstage`, dll.) di dalam editor, dan Anda dapat menggunakan perintah CLI Git dari dalam Helix.

### **5. Rekomendasi Visualisasi**

  * **Diagram Alur LSP:** Diagram yang menunjukkan bagaimana Helix (sebagai Client) berkomunikasi dengan **Language Server** (sebagai Server) melalui protokol LSP akan sangat membantu. Ini dapat memvisualisasikan bagaimana sebuah perintah seperti `gd` (go to definition) memicu permintaan dari Helix ke server dan respons kembali.
  * **Visualisasi Tree-sitter:** Ilustrasi struktur pohon dari sebuah baris kode sederhana (`let x = 10;`) akan sangat efektif. Ini akan menunjukkan bagaimana Tree-sitter memecah baris kode menjadi node-node seperti `keyword`, `variable`, `operator`, dan `number`.

### **6. Hubungan dengan Modul Lain**

Modul ini adalah transisi dari editor teks biasa menjadi editor kode yang profesional.

  * **Modul 3 (Konfigurasi):** Modul ini adalah kelanjutan dari Modul 3. Anda tidak hanya akan mengkonfigurasi tampilan, tetapi juga akan mengkonfigurasi fungsionalitas inti editor melalui `languages.toml`.
  * **Fase 3 (Mahir):** Keterampilan di sini adalah prasyarat untuk membuat alur kerja otomatis. Makro dan skrip yang Anda buat di fase berikutnya akan jauh lebih kuat jika mereka dapat memanfaatkan informasi kontekstual yang disediakan oleh LSP dan Tree-sitter.

### **7. Sumber Referensi Lengkap**

  * **Dokumentasi Resmi Helix:**
      * [Languages](https://docs.helix-editor.com/languages.html): Panduan lengkap untuk mengkonfigurasi LSP dan bahasa.
      * [Keymap: Navigation](https://www.google.com/search?q=https://docs.helix-editor.com/keymap.html%23navigation): Beberapa perintah di sini terkait dengan fitur LSP.
  * **Situs Resmi LSP:**
      * [Language Server Protocol](https://microsoft.github.io/language-server-protocol/): Dokumentasi resmi tentang protokol.
  * **Repositori Tree-sitter:**
      * [Tree-sitter on GitHub](https://github.com/tree-sitter/tree-sitter): Repositori sumber untuk Tree-sitter.

### **8. Tips dan Praktik Terbaik**

  * **Gunakan LSP yang Tepat:** Pastikan Anda menginstal LSP yang direkomendasikan untuk bahasa pemrograman Anda. Cek dokumentasi resmi Helix untuk rekomendasi.
  * **Gunakan `hx --health`:** Jika ada masalah, gunakan perintah ini untuk memeriksa instalasi LSP Anda. Ini akan memberikan diagnostik yang sangat berguna.
  * **Pelajari `Telescope Mode`:** Habiskan waktu untuk membiasakan diri dengan `space f` dan `space /`. Menggunakan alat ini secara efisien akan mengurangi ketergantungan Anda pada `ls` dan `grep` di terminal eksternal.

### **9. Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** LSP tidak berfungsi setelah konfigurasi.
      * **Solusi:** Periksa `languages.toml` untuk kesalahan ketik. Pastikan server bahasa (misalnya, `rust-analyzer`) sudah terinstal dan ada di `PATH` sistem Anda. Jalankan `hx --health` untuk memeriksa apakah Helix dapat menemukan server.
  * **Kesalahan:** Penyorotan sintaks tidak akurat.
      * **Solusi:** Ini mungkin berarti Tree-sitter untuk bahasa tersebut tidak diinstal. Anda mungkin perlu menginstal parser yang relevan atau memperbarui instalasi Helix Anda.
  * **Kesalahan:** Perintah `gd` (go to definition) tidak berfungsi.
      * **Solusi:** Ini biasanya disebabkan oleh LSP yang tidak berjalan. Periksa log LSP (jika tersedia) atau pastikan Anda telah menginstal dan mengkonfigurasi server dengan benar.

-----

Dengan modul ini, Anda telah mengubah Helix dari editor teks menjadi lingkungan pengembangan yang kuat. Anda sekarang memiliki kemampuan untuk bekerja dengan proyek-proyek yang kompleks dengan tingkat efisiensi yang tinggi.

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

