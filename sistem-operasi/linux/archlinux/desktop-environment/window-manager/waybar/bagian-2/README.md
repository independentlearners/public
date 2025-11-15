### 🛠️ Bagian 2: Identitas Teknologi & Prasyarat

Bagian ini berfokus pada pemahaman "bahan-bahan" teknis yang membangun Waybar dan keterampilan dasar yang *mutlak* diperlukan untuk memodifikasinya. Ini adalah jembatan antara "filosofi" (Bagian 1) dan "praktik" (Bagian 3).

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### Daftar Isi Mini (Mini-Table of Contents)

  * **2.1 Identitas Teknologi:** Waybar sebagai *Status Bar* Wayland
  * **2.2 Bahasa Pemrograman Inti:** Mengapa C++ Penting bagi Anda
  * **2.3 Prasyarat Wajib (Struktur):** Pemahaman Sintaksis JSON
      * *Bedah Kode:* Sintaksis JSON Kata-per-Kata
  * **2.4 Prasyarat Wajib (Tampilan):** Pemahaman Sintaksis CSS
      * *Bedah Kode:* Sintaksis CSS Kata-per-Kata
  * **2.5 Prasyarat Opsional (Kustomisasi Lanjut):** Shell Scripting
      * *Bedah Perintah:* Format Output JSON dari Shell
  * **2.6 Prasyarat Opsional (Estetika):** Ikon Font
  * **2.7 Fokus Bahasa Inggris:** Terminologi "Prerequisite" & "Syntax"
  * **2.8 Hubungan ke Tahap Berikutnya:** Menjembatani Pengetahuan dan Lokasi File

-----


</details>


#### 2.1 Identitas Teknologi: Waybar sebagai *Status Bar* Wayland

**Penjelasan Detail**
Waybar secara spesifik diidentifikasi sebagai *status bar* (bilah status) yang dirancang *hanya* untuk *compositor* (komposer) Wayland.

**Mengapa Ini Penting?**
Ini adalah poin krusial. Waybar **tidak akan** berfungsi di lingkungan X11 (seperti i3, bspwm, atau GNOME/KDE di mode X11). Waybar dirancang untuk berkomunikasi langsung dengan protokol Wayland, seperti *layer-shell*, untuk "menempelkan" dirinya di layar.

Karena Anda menggunakan **Sway** (yang merupakan *compositor* Wayland), Waybar adalah pilihan *native* (asli). Ini berarti:

1.  **Stabilitas Maksimum:** Komunikasi antara Sway dan Waybar lebih efisien dan tidak memerlukan *hack* atau *wrapper* (pembungkus) tambahan.
2.  **Integrasi Mendalam:** Modul seperti `sway/workspaces` dapat "mendengarkan" langsung ke *event* (kejadian) dari Sway, membuatnya instan dan hemat sumber daya.
3.  **Kinerja:** Sesuai dengan preferensi Anda akan *low footprint* (jejak rendah), solusi *native* hampir selalu lebih ringan daripada solusi yang dijembatani (seperti *bar* X11 yang dijalankan di bawah XWayland).

**Terminologi**

  * **Status Bar (Bilah Status):** Elemen antarmuka pengguna (UI) persisten (biasanya di atas atau bawah layar) yang menampilkan informasi status sistem (jam, volume, koneksi jaringan, dll.).
  * **Wayland:** Protokol server tampilan modern di Linux. Ini adalah penerus dari X11 (X Window System). Tujuannya adalah menyediakan cara yang lebih sederhana, aman, dan efisien untuk menggambar jendela di layar.
  * **Compositor (Komposer):** Dalam dunia Wayland, *compositor* adalah segalanya. Ini adalah server tampilan, manajer jendela, dan komposer grafis sekaligus. **Sway** adalah *compositor*.

**Sumber Referensi**

  * [Waybar (GitHub Repository)](https://github.com/Alexays/Waybar) - Sumber kode resmi dan halaman utama proyek.
  * [Wayland (Situs Resmi)](https://wayland.freedesktop.org/) - Penjelasan resmi tentang apa itu protokol Wayland.

-----

#### 2.2 Bahasa Pemrograman Inti: Mengapa C++ Penting bagi Anda

**Penjelasan Detail**
Waybar dibangun menggunakan **C++** (utamanya) dan beberapa dependensi dalam **C**. Ini adalah bahasa pemrograman *compiled* (terkompilasi).

**Mengapa Ini Penting (Bagi Anda sebagai *Pengguna*):**
Anda tidak perlu *menulis* C++ untuk *menggunakan* atau *mengonfigurasi* Waybar. Namun, fakta bahwa ia ditulis dalam C++ memiliki implikasi langsung pada pengalaman Anda:

1.  **Kinerja & Kecepatan:** C++ dikompilasi langsung ke kode mesin (machine code). Ini berarti eksekusinya sangat cepat dan efisien.
2.  **Penggunaan Sumber Daya Rendah:** Tidak ada *interpreter* atau *virtual machine* (seperti pada Python atau Java) yang perlu berjalan. Hasilnya adalah penggunaan RAM dan CPU yang minimal, sesuai dengan preferensi Anda akan *low footprint* dan *stabilitas*.

**Mengapa Ini Penting (Bagi Anda sebagai *Modifikator*):**
Jika suatu hari Anda memutuskan bahwa modul `custom` (skrip shell) terlalu lambat atau Anda ingin membuat modul *internal* baru yang bereaksi terhadap *event* sistem secara *asynchronous* (asinkron), Anda **wajib** memiliki pengetahuan C++ untuk memodifikasi dan mengkompilasi ulang kode sumber Waybar.

**Terminologi**

  * **C++ / C:** Bahasa pemrograman *compiled*, *statically-typed* (tipe statis) yang terkenal dengan kinerja tinggi. Sering digunakan untuk perangkat lunak sistem, *driver*, dan aplikasi yang menuntut performa.
  * **Compiled (Terkopilasi):** Proses di mana kode sumber yang dapat dibaca manusia (seperti file `.cpp`) diterjemahkan oleh *compiler* (seperti `g++`) menjadi file biner (binary) yang dapat dieksekusi langsung oleh prosesor komputer.
  * **Internal Module (Modul Internal):** Fungsionalitas (seperti `clock` atau `cpu`) yang kodenya ada di dalam *source code* Waybar itu sendiri dan dikompilasi ke dalam *binary* Waybar.

**Sumber Referensi**

  * [Source Code Waybar (src/modules)](https://www.google.com/search?q=https://github.com/Alexays/Waybar/tree/master/src/modules) - Anda dapat melihat di sini bahwa semua modul inti (seperti `cpu.cpp`, `memory.cpp`) adalah file C++.

-----

#### 2.3 Prasyarat Wajib (Struktur): Pemahaman Sintaksis JSON

**Penjelasan Detail**
Anda **wajib** memahami sintaksis dasar JSON. File `config` Anda **adalah** file JSON. Jika sintaksisnya tidak valid (tidak sempurna), Waybar **tidak akan bisa membacanya** dan kemungkinan besar akan gagal total saat dijalankan.

**Konsep Inti**
JSON dibangun di atas dua struktur:

1.  **Objek `{}`:** Kumpulan pasangan *key-value* (kunci-nilai) yang tidak terurut.
2.  **Array `[]`:** Daftar nilai yang terurut.

**Bedah Kode: Sintaksis JSON Kata-per-Kata**

Mari kita bedah contoh file `config` minimal:

```json
{
  "layer": "top",
  "modules-left": [ "sway/workspaces", "clock" ]
}
```

  * `{`
      * **Penjelasan:** Tanda kurung kurawal buka. Ini mendeklarasikan dimulainya sebuah **Objek JSON**. Seluruh file `config` Anda adalah satu objek ini.
  * `"layer"`
      * **Penjelasan:** Ini adalah **Kunci** (Key). Dalam JSON, Kunci *harus* berupa *string* (teks) dan *harus* diapit oleh **tanda kutip ganda** (`"`).
  * `:`
      * **Penjelasan:** Tanda titik dua. Ini adalah **pemisah** (separator) yang memisahkan *Kunci* dari *Nilai*-nya.
  * `"top"`
      * **Penjelasan:** Ini adalah **Nilai** (Value) yang terkait dengan kunci `"layer"`. Nilai ini bertipe *string*, sehingga harus diapit tanda kutip ganda.
  * `,`
      * **Penjelasan:** Tanda koma. Ini adalah **pemisah** antar pasangan *key-value*. Ini *wajib* ada di antara setiap pasangan.
  * `"modules-left"`
      * **Penjelasan:** Ini adalah *Kunci* (Key) kedua dalam objek.
  * `:`
      * **Penjelasan:** Pemisah *key-value*.
  * `[`
      * **Penjelasan:** Tanda kurung siku buka. Ini mendeklarasikan dimulainya sebuah **Array JSON**. Nilai yang terkait dengan `"modules-left"` adalah sebuah *array*.
  * `"sway/workspaces"`
      * **Penjelasan:** Ini adalah *item* pertama (indeks 0) di dalam *array*. Ini adalah *string*.
  * `,`
      * **Penjelasan:** Tanda koma. Ini adalah **pemisah** antar *item* di dalam sebuah *array*.
  * `"clock"`
      * **Penjelasan:** Ini adalah *item* kedua (indeks 1) di dalam *array*.
  * `]`
      * **Penjelasan:** Tanda kurung siku tutup. Ini menandakan akhir dari *array*.
  * `}`
      * **Penjelasan:** Tanda kurung kurawal tutup. Ini menandakan akhir dari **Objek JSON**. Perhatikan: **Tidak ada koma** setelah pasangan *key-value* terakhir dalam sebuah objek.

**Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** *Trailing Comma* (Koma di akhir). Menaruh koma setelah `[ "sway/workspaces", "clock" ],` (sebelum `}`). JSON **tidak mengizinkan** ini.
  * **Solusi:** Hapus koma terakhir.
  * **Kesalahan:** *Missing Comma* (Koma hilang). Lupa koma di antara `"layer": "top"` dan `"modules-left": [...]`.
  * **Solusi:** Tambahkan koma.
  * **Kesalahan:** Menggunakan tanda kutip tunggal (`'`) alih-alih ganda (`"`). JSON **mewajibkan** tanda kutip ganda.
  * **Solusi:** Ganti semua kutip tunggal menjadi ganda.

**Praktik Terbaik**
Gunakan *editor* (seperti VS Code) yang memiliki **JSON Linter** (pemeriksa sintaksis) bawaan. Ini akan memberi garis bawah merah pada kesalahan sintaksis Anda secara *real-time* sebelum Anda menyimpannya.

**Terminologi**

  * **Syntax (Sintaksis):** Aturan tata bahasa dari sebuah bahasa pemrograman atau format data.
  * **Linter:** Alat (tool) yang menganalisis kode sumber untuk menandai potensi kesalahan sintaksis, *bug*, atau penyimpangan gaya (style).
  * **Key-Value Pair (Pasangan Kunci-Nilai):** Fondasi JSON. `Kunci` adalah nama (string), `Nilai` adalah datanya (bisa string, angka, boolean, array, atau objek lain).

**Sumber Referensi**

  * [JSON.org](https://www.json.org/json-en.html) - Pengenalan resmi yang sangat singkat dan padat.
  * [JSONLint](https://jsonlint.com/) - Alat *online* untuk memvalidasi (memeriksa keabsahan) JSON Anda. Sangat berguna untuk *debugging*.

-----

#### 2.4 Prasyarat Wajib (Tampilan): Pemahaman Sintaksis CSS

**Penjelasan Detail**
Anda **wajib** memahami sintaksis dasar CSS. File `style.css` Anda **adalah** file CSS. Jika sintaksisnya tidak valid, Waybar mungkin akan mengabaikannya atau gagal menerapkannya, menghasilkan bar yang terlihat "polos" atau "rusak".

**Konsep Inti**
CSS bekerja berdasarkan aturan **"Selector { Property: Value; }"**:

1.  **Selector (Pemilih):** Menargetkan elemen mana yang ingin Anda gayai.
2.  **Declaration Block `{ ... }`:** Blok yang berisi satu atau lebih deklarasi *style*.
3.  **Declaration `property: value;`:** Satu aturan *style* (misal: `color: white;`).

**Bedah Kode: Sintaksis CSS Kata-per-Kata**

Mari kita bedah contoh file `style.css` minimal:

```css
window#waybar {
  background-color: #323232;
  color: white;
}

#clock {
  padding: 0 10px;
}
```

  * `window#waybar`
      * **Penjelasan:** Ini adalah **Selector** (Pemilih).
      * `window`: Memilih *tipe* elemen (dalam kasus Waybar, ini adalah elemen jendela utama).
      * `#waybar`: Memilih elemen dengan **ID** (Identitas) `waybar`. Waybar secara otomatis memberi ID `waybar` pada jendela utamanya. Tanda `#` (hash) secara spesifik berarti "memilih berdasarkan ID".
  * `{`
      * **Penjelasan:** Tanda kurung kurawal buka. Memulai **Blok Deklarasi** (Declaration Block) untuk pemilih `window#waybar`.
  * `background-color`
      * **Penjelasan:** Ini adalah **Properti** (Property) CSS. Ini mendefinisikan warna latar belakang.
  * `:`
      * **Penjelasan:** Tanda titik dua. Pemisah antara *Properti* dan *Nilai*-nya.
  * `#323232`
      * **Penjelasan:** Ini adalah **Nilai** (Value) untuk properti `background-color`. Ini adalah kode warna Heksadesimal untuk abu-abu gelap.
  * `;`
      * **Penjelasan:** Tanda titik koma. Ini **mengakhiri** sebuah deklarasi *style*. Ini *wajib* ada di antara setiap deklarasi.
  * `color: white;`
      * **Penjelasan:** Deklarasi kedua. Mengatur properti `color` (warna teks) ke nilai `white` (putih).
  * `}`
      * **Penjelasan:** Tanda kurung kurawal tutup. Mengakhiri blok deklarasi untuk `window#waybar`.
  * `#clock`
      * **Penjelasan:** *Selector* (Pemilih) kedua. Ini menargetkan elemen apa pun dengan **ID** `clock`. Waybar secara otomatis memberi ID yang cocok dengan nama modulnya.
  * `{ ... }`
      * **Penjelasan:** Blok deklarasi untuk modul `#clock`.
  * `padding: 0 10px;`
      * **Penjelasan:** Sebuah deklarasi.
      * `padding`: Properti untuk mengatur *ruang dalam* (bantalan) di dalam sebuah elemen.
      * `0 10px`: Nilai. Ini adalah singkatan (shorthand) CSS. `0` berlaku untuk `padding-top` (bantalan atas) dan `padding-bottom` (bantalan bawah). `10px` (10 piksel) berlaku untuk `padding-left` (kiri) dan `padding-right` (kanan).

**Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Lupa titik koma (`;`) di akhir deklarasi. Ini akan menyebabkan aturan *berikutnya* gagal dibaca.
  * **Solusi:** Selalu akhiri setiap baris `property: value` dengan `;`.
  * **Kesalahan:** Salah ketik nama properti (misal: `backgroud-color` atau `pading`).
  * **Solusi:** Periksa ejaan. CSS akan mengabaikan properti yang tidak dikenali.
  * **Kesalahan:** Bingung antara `#` (ID) dan `.` (Class). `#clock` menargetkan ID, `.clock` menargetkan *class* (kelas).

**Terminologi**

  * **Selector (Pemilih):** Pola CSS untuk memilih elemen HTML/GTK (dalam kasus Waybar) yang ingin diberi *style*.
  * **ID (Identitas):** Atribut unik untuk sebuah elemen. Dalam CSS, ditargetkan dengan `#`.
  * **Class (Kelas):** Atribut yang dapat digunakan kembali untuk banyak elemen. Dalam CSS, ditargetkan dengan `.` (titik).
  * **Property (Properti):** Aspek visual yang ingin Anda ubah (misal: `font-size`, `border`).
  * **Value (Nilai):** Pengaturan spesifik untuk properti tersebut (misal: `16px`, `1px solid red`).

**Sumber Referensi**

  * [MDN Web Docs: CSS Selectors](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors) - Referensi lengkap tentang cara kerja pemilih CSS.
  * [W3Schools CSS Tutorial](https://www.w3schools.com/css/) - Tempat belajar interaktif yang baik untuk pemula.

-----

#### 2.5 Prasyarat Opsional (Kustomisasi Lanjut): Shell Scripting

**Penjelasan Detail**
Ini opsional, tetapi sangat direkomendasikan untuk kustomisasi mendalam, terutama mengingat preferensi Anda terhadap **CLI**. Jika Waybar tidak memiliki modul internal untuk sesuatu (misal: cuaca, harga *crypto*, lagu yang sedang diputar di `mpd`), Anda dapat menggunakan modul `custom` untuk menjalankan skrip **shell** (seperti Bash, sh) atau skrip bahasa lain (Python, Node.js, dll.).

**Konsep Inti**

1.  Anda memberi tahu Waybar (di `config`) untuk menjalankan perintah/skrip dalam interval tertentu.
2.  Waybar menjalankan perintah itu.
3.  Waybar mengambil **Standard Output (STDOUT)** dari skrip Anda.
4.  Waybar **mengharapkan** STDOUT itu diformat sebagai **objek JSON**.
5.  Objek JSON minimal harus berisi *key* `"text"` untuk menampilkan sesuatu.

**Bedah Perintah: Format Output JSON dari Shell**

Perintah ini, jika dijalankan di terminal, menghasilkan output yang dipahami Waybar:

```bash
echo "{\"text\": \"Hello 🐧\", \"tooltip\": \"Linux is fun!\"}"
```

  * `echo`
      * **Penjelasan:** Perintah shell (CLI) standar yang tugasnya adalah "menggemakan" atau **mencetak** (output) argumen teks yang mengikutinya ke **STDOUT**.
  * `"`
      * **Penjelasan:** Tanda kutip ganda buka. Memulai *string* (teks) yang akan dicetak oleh `echo`.
  * `{`
      * **Penjelasan:** Karakter harfiah (literal) kurung kurawal. Ini adalah *bagian* dari *string* yang akan dicetak. Ini adalah awal dari objek JSON yang kita *buat*.
  * `\`
      * **Penjelasan:** Karakter *Backslash*. Ini adalah **karakter escape**.
      * **Konteks:** Karena seluruh string kita diapit oleh `"` (kutip ganda), jika kita ingin *mencetak* karakter kutip ganda literal (sebagai bagian dari sintaksis JSON), kita harus "memberi tahu" `echo` bahwa `"` berikutnya bukanlah akhir dari string, melainkan karakter biasa. Inilah fungsi `\`.
  * `"`
      * **Penjelasan:** Karakter kutip ganda literal, yang "diloloskan" (escaped) oleh `\`. Ini adalah awal dari *Kunci* JSON.
  * `text`
      * **Penjelasan:** String literal, menjadi *Kunci* JSON.
  * `\"`
      * **Penjelasan:** Koma dan kutip ganda *escaped* lagi.
  * ` :  `
      * **Penjelasan:** Titik dua dan spasi literal. Pemisah *key-value* JSON.
  * `\"Hello 🐧\"`
      * **Penjelasan:** String *value* JSON (ter-escape) yang akan ditampilkan di bar.
  * `,`
      * **Penjelasan:** Koma literal. Pemisah pasangan *key-value* JSON.
  * `\"tooltip\"` ... `\"Linux is fun!\"`
      * **Penjelasan:** Pasangan *key-value* JSON opsional kedua. Ini akan ditampilkan saat Anda *hover* (mengarahkan kursor) di atas modul.
  * `}`
      * **Penjelasan:** Karakter kurung kurawal tutup literal. Akhir dari objek JSON.
  * `"`
      * **Penjelasan:** Tanda kutip ganda tutup. Mengakhiri *string* yang akan dicetak oleh `echo`.

**Terminologi**

  * **Shell Scripting:** Menulis skrip (file berisi perintah) yang dapat dieksekusi oleh *shell* (seperti Bash) untuk mengotomatisasi tugas.
  * **STDOUT (Standard Output):** Aliran (stream) output default dari program CLI. Secara default, ini adalah apa yang Anda lihat tercetak di terminal Anda.
  * **Escaping (Meloloskan):** Proses menggunakan karakter khusus (seperti `\`) untuk memberi tahu *interpreter* (seperti `bash`) agar memperlakukan karakter berikutnya secara harfiah, bukan sebagai karakter kontrol.

**Sumber Referensi**

  * [Waybar Wiki: Custom Module](https://www.google.com/search?q=https://github.com/Alexays/Waybar/wiki/Module:-Custom) - Dokumentasi resmi untuk modul `custom`, menunjukkan semua *key* JSON yang diterima (seperti `text`, `tooltip`, `class`, `percentage`).

-----

#### 2.6 Prasyarat Opsional (Estetika): Ikon Font

**Penjelasan Detail**
Ini murni untuk estetika (sesuai preferensi Anda). Alih-alih menampilkan teks seperti `VOL:` atau `CPU:`, Anda dapat menggunakan ikon seperti `` atau ``.

**Konsep Inti**
Anda menginstal *font* khusus (seperti **Nerd Fonts** atau **Font Awesome**) yang berisi ribuan *glyph* (ikon) yang dipetakan ke titik kode Unicode.

**Implementasi Praktis**

1.  **Instal Font:** (Di Arch Linux): `sudo pacman -S ttf-nerd-fonts-symbols` (atau font spesifik seperti `ttf-firacode-nerd`).
2.  **Atur di CSS:** Di `style.css` Anda, atur `font-family` Anda untuk *menyertakan* font ikon sebagai *fallback* (cadangan).
    ```css
    * {
      font-family: "FiraCode", "Symbols Nerd Font";
    }
    ```
3.  **Gunakan di Config:** Buka situs seperti [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet), cari ikon yang Anda suka, **salin** ikonnya, dan **tempel** langsung ke dalam *string* `"format"` di file `config` JSON Anda.

**Terminologi**

  * **Icon Font (Font Ikon):** Sebuah file font yang berisi simbol dan ikon alih-alih karakter alfabet.
  * **Nerd Fonts:** Proyek yang menggabungkan banyak *font* pemrograman populer dengan sekumpulan besar ikon dari Font Awesome, Material Design, dll. Sangat populer untuk kustomisasi *rice* (tema) Linux.
  * **Glyph (Glif):** Representasi visual spesifik dari sebuah karakter dalam *font*. Dalam konteks ini, *glyph* adalah ikon itu sendiri.

**Sumber Referensi**

  * [Nerd Fonts (Situs Resmi)](https://www.nerdfonts.com/) - Halaman utama proyek, termasuk unduhan dan *cheat sheet* ikon.

---

<!---
#### 2.8 Hubungan ke Tahap Berikutnya

Kita telah mengidentifikasi **apa** itu Waybar (aplikasi C++ Wayland) dan **keterampilan dasar** apa yang diperlukan untuk mengeditnya (JSON untuk struktur, CSS untuk tampilan, Shell untuk kustomisasi).

Sekarang setelah Anda memiliki pengetahuannya, pertanyaan logis berikutnya adalah: "**Di mana** saya menemukan file-file ini?" dan "**Bagaimana** Waybar tahu cara memuatnya?". Ini adalah jembatan sempurna ke **Tahap 3: Struktur File dan Konsep Dasar**, di mana kita akan membahas lokasi `~/.config/waybar/config` dan `~/.config/waybar/style.css` secara mendalam.

-----

Ini adalah akhir dari Bagian 2. Kita telah mengurai fondasi teknis dan keterampilan yang diperlukan.



#### 2.7 🧐 Fokus Bahasa Inggris (Sesuai Instruksi)

Mari kita bedah dua terminologi kunci dari bagian ini.

**1. Prerequisite (Prasyarat)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata benda (Noun). Sering juga digunakan sebagai kata sifat (Adjective: "prerequisite knowledge").
      * Terdiri dari dua bagian Latin: `pre-` (berarti "sebelum") dan `requisite` (berarti "sesuatu yang diperlukan" atau "syarat").
      * Secara harfiah berarti: "syarat yang harus dipenuhi *sebelum* (hal lain dapat terjadi)."
  * **Konteks Teknis (Technical Context):** Ini adalah dependensi (ketergantungan) atau keterampilan yang harus Anda miliki *sebelum* memulai tugas atau mempelajari teknologi baru.
  * **Penggunaan Profesional (Professional Interaction):**
      * *"A solid understanding of JSON is a **prerequisite** for customizing the Waybar configuration."*
      * (Pemahaman yang kuat tentang JSON adalah **prasyarat** untuk menyesuaikan konfigurasi Waybar.)
      * *"The C++ compiler is a **prerequisite** package that must be installed before building the software from source."*
      * (Kompilator C++ adalah paket **prasyarat** yang harus diinstal sebelum membangun perangkat lunak dari sumbernya.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * *"Finishing your homework is a **prerequisite** for playing video games."*
      * (Menyelesaikan PR-mu adalah **syarat** sebelum boleh bermain game.)

**2. Syntax (Sintaksis)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata benda (Noun).
      * Berasal dari bahasa Yunani `syntaxis`, yang berarti "pengaturan" atau "susunan".
  * **Konteks Teknis (Technical Context):** Ini merujuk pada **aturan tata bahasa** dari sebuah bahasa pemrograman atau format data. Ini adalah *struktur* yang benar dari penulisan kode agar dapat dipahami oleh *compiler* atau *interpreter*. Ini *bukan* tentang *logika* (apa yang dilakukan kode), tetapi tentang *format* (bagaimana kode itu ditulis).
  * **Penggunaan Profesional (ProfessionalInteraction):**
      * *"My code failed to compile because of a simple **syntax** error; I missed a semicolon."*
      * (Kode saya gagal dikompilasi karena kesalahan **sintaksis** sederhana; saya lupa titik koma.)
      * *"This JSON parser is very strict and will reject any file with invalid **syntax**."*
      * (Parser JSON ini sangat ketat dan akan menolak file apa pun dengan **sintaksis** yang tidak valid.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * (Lebih jarang, tetapi bisa digunakan untuk bahasa manusia.) *"The **syntax** of your sentence is a bit confusing, but I understand what you mean."*
      * (Susunan tata bahasa kalimat Anda sedikit membingungkan, tapi saya mengerti maksud Anda.)

-----

**Apakah Anda siap untuk melanjutkan ke "Tahap 3: Struktur File dan Konsep Dasar"?**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
<!----------------------------------------------------->

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**

[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md


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
