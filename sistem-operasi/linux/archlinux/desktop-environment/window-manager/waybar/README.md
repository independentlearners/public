## [🚀 Ikhtisar: Filosofi Konfigurasi Waybar][1]

Sebelum melangkah ke teknis, penting untuk memahami filosofi Waybar. Waybar dirancang untuk menjadi **modular** dan **dapat disesaiakan gayanya (styleable)**.

* **Modularitas (Struktur):** Konfigurasi Waybar menggunakan format **JSON** (*JavaScript Object Notation*). Anda hanya mendefinisikan *apa* yang ingin Anda tampilkan (modul) dan *di mana* menampilkannya.
* **Styling (Tampilan):** Tampilan dan nuansa (estetika) Waybar dikontrol sepenuhnya oleh **CSS** (*Cascading Style Sheets*).

Pemisahan antara *struktur* (JSON) dan *tampilan* (CSS) inilah yang memberikan Waybar fleksibilitas luar biasa, sejalan dengan preferensi Anda akan kustomisasi dan estetika.

---

## [🛠️ Identitas Teknologi & Prasyarat][2]

Sesuai preferensi Anda untuk memahami teknologi secara mendalam:

* **Identitas:** Waybar adalah *status bar* (bilah status) yang sangat kustomisasi untuk *compositor* (komposer) Wayland (seperti Sway, yang Anda gunakan).
* **Bahasa Pemrograman:** Dibangun utamanya menggunakan **C++**, dengan beberapa komponen dan dependensi dalam **C**.
* **Prasyarat untuk Kustomisasi:**
    * **Wajib (Penting):**
        1.  **Pemahaman Dasar JSON:** Anda harus memahami sintaks dasar JSON (objek `{}`, array `[]`, pasangan *key-value* `"kunci": "nilai"`, dan pentingnya koma).
        2.  **Pemahaman Dasar CSS:** Anda harus memahami konsep *selectors* (pemilih) (seperti `#id` dan `.class`) dan *properties* (properti) (seperti `color`, `background-color`, `padding`).
    * **Opsional (Untuk Kustomisasi Lanjut):**
        1.  **Shell Scripting (cth: Bash):** Diperlukan jika Anda ingin membuat modul `custom` (kustom) yang menampilkan output dari skrip Anda sendiri.
        2.  **Pengetahuan Ikon Font:** (Seperti Font Awesome, Nerd Fonts) untuk menampilkan ikon alih-alih teks.

---

## [🗺️ Tahapan Pembelajaran Konfigurasi Waybar][3]

Ini adalah peta jalan (roadmap) langkah demi langkah untuk menguasai konfigurasi Waybar, dari dasar hingga mahir.

### Tahap 1: Struktur File dan Konsep Dasar

Fokus di tahap ini adalah memahami di mana Waybar mencari file dan bagaimana file-file tersebut berinteraksi.

* **File Konfigurasi Utama (`config`):**
    * **Lokasi:** Biasanya di `~/.config/waybar/config`.
    * **Tujuan:** File ini (dalam format JSON) mendefinisikan **struktur** bar Anda.
    * **Konsep Kunci:** File ini adalah sebuah *objek JSON tunggal* yang berisi semua pengaturan.
* **File Styling (`style.css`):**
    * **Lokasi:** Biasanya di `~/.config/waybar/style.css`.
    * **Tujuan:** File ini (dalam format CSS) mendefinisikan **tampilan** bar Anda.
    * **Konsep Kunci:** Waybar secara otomatis memuat file ini. Anda "menargetkan" elemen di bar Anda menggunakan pemilih CSS.

### Tahap 2: Pengaturan Global (Level Atas) dalam `config`

Ini adalah properti di dalam objek JSON utama yang mendefinisikan perilaku bar secara keseluruhan.

* **Bagian Perlu (Necessary):**
    * `"layer"`: Menentukan tumpukan (stacking) bar. (Konsep: Apakah bar selalu di atas? Nilai umum: `"top"`).
    * `"position"`: Menentukan di mana bar berada di layar. (Konsep: Penempatan. Nilai umum: `"top"`, `"bottom"`).
    * `"modules-left"`, `"modules-center"`, `"modules-right"`: Ini adalah *inti* dari layout Anda.
        * **Konsep:** Ketiganya adalah *array JSON* (`[]`).
        * **Tujuan:** Anda mendaftarkan *nama* modul yang ingin Anda tampilkan di setiap bagian. Urutan dalam array menentukan urutan tampilan.

* **Bagian Opsional (Optional but Recommended):**
    * `"output"`: Penting untuk pengaturan multi-monitor. (Konsep: Menentukan pada monitor mana bar ini akan muncul).
    * `"height"` / `"width"`: Mengatur dimensi bar secara manual, meskipun biasanya otomatis lebih baik.

### Tahap 3: Konfigurasi Modul (Inti Kustomisasi)

Ini adalah bagian terbesar dan terpenting. Setiap item yang Anda lihat di bar (jam, CPU, workspace) adalah sebuah modul.

* **Konsep:** Setelah Anda *mendaftarkan* nama modul di Tahap 2 (misalnya, di `"modules-left"`), Anda harus *mendefinisikan* konfigurasi untuk modul tersebut sebagai objek JSON baru di level atas file `config`.
* **Contoh Struktur:** Jika Anda mendaftarkan `"clock"`, Anda perlu menambahkan bagian `"clock": { ... }` di file `config`.

* **Bagian Perlu (Umum untuk Hampir Semua Modul):**
    * `"format"`: Ini adalah properti *paling penting* dari sebuah modul.
        * **Konsep:** Ini adalah *string* (teks) yang mendefinisikan *apa* yang ditampilkan.
        * **Terminologi:** Menggunakan **Placeholders** (Penanda Tempat). Misalnya, untuk modul `cpu`, placeholder `{usage}` akan diganti dengan persentase penggunaan CPU saat ini. Setiap modul memiliki set placeholder-nya sendiri (Anda *harus* merujuk ke dokumentasi resmi Waybar untuk ini).

* **Bagian Opsional (Umum):**
    * `"tooltip"`: (true/false) Mengaktifkan/menonaktifkan info tambahan saat kursor *hover* di atas modul.
    * `"tooltip-format"`: Mirip dengan `"format"`, tetapi untuk konten *tooltip*.
    * `"interval"`: Seberapa sering modul diperbarui (dalam detik). (Konsep: Keseimbangan antara data *real-time* dan penggunaan sumber daya).
    * `"on-click"` / `"on-scroll"`: Menjalankan perintah kustom (skrip shell) saat modul diklik atau di-scroll. (Konsep: Interaktivitas).

* **Jenis Modul yang Perlu Dipelajari:**
    * **Modul Internal:** (Misalnya: `clock`, `cpu`, `memory`, `network`, `pulseaudio`, `battery`). Ini adalah modul bawaan. Anda hanya perlu mengonfigurasi format dan perilakunya.
    * **Modul Integrasi (Penting untuk Anda):** `sway/workspaces`, `sway/mode`. Ini adalah modul yang berinteraksi langsung dengan Sway.
    * **Modul Kustom (`custom/<name>`):** Ini adalah modul terkuat untuk kustomisasi.
        * **Konsep:** Anda memberikan perintah shell (`"exec"`) dan Waybar akan menampilkan *output* (stdout) dari perintah tersebut.
        * **Ini adalah kunci** untuk menampilkan informasi apa pun yang bisa Anda dapatkan melalui skrip CLI.

### Tahap 4: Styling (CSS)

Setelah struktur Anda (JSON) selesai, Anda beralih ke `style.css` untuk membuatnya terlihat bagus.

* **Konsep:** Setiap elemen di Waybar memiliki *ID* atau *class* CSS yang dapat Anda targetkan.
* **Pemilih (Selectors) Perlu:**
    * `window#waybar`: Menargetkan seluruh *container* (wadah) bar. (Gunakan ini untuk `background-color`, `border`, dll. pada bar itu sendiri).
    * `#<module-name>`: Menargetkan modul tertentu berdasarkan namanya. (Contoh: `#clock`, `#cpu`, `#custom-weather`). (Gunakan ini untuk `padding`, `margin`, `color` per modul).

* **Pemilih Opsional (Tingkat Lanjut):**
    * **Styling Berbasis Status:** Ini *sangat* kuat. Waybar secara dinamis menambahkan *class* CSS berdasarkan status modul.
        * **Contoh Konsep:** Modul baterai (`#battery`) mungkin mendapatkan class `.charging` saat mengisi daya atau `.warning` saat baterai lemah.
        * **Penerapan:** Anda dapat menulis CSS seperti `#battery.warning { background-color: red; }`. Ini memungkinkan bar Anda bereaksi secara visual terhadap status sistem.

### Tahap 5: Penanganan Error dan Iterasi

Sesuai permintaan Anda mengenai penanganan *error*.

* **Konsep:** Kesalahan paling umum adalah *sintaks JSON yang tidak valid*.
* **Cara Membaca Error:**
    1.  Selalu jalankan Waybar dari terminal (CLI) Anda saat melakukan *debugging*.
    2.  Jika Waybar gagal memulai atau *crash*, ia akan mencetak *error* ke terminal.
    3.  **Error Umum:** "Unexpected character" (Karakter tak terduga) atau "Missing comma" (Koma hilang). Ini hampir selalu berarti Anda salah menempatkan koma (atau lupa) di file `config` JSON Anda.
    4Next steps:
* **Cara Memvalidasi:** Gunakan *linter* (pemeriksa) JSON. Banyak editor kode (seperti VS Code) memilikinya secara bawaan, atau Anda dapat menggunakan alat *online* untuk memvalidasi sintaks file `config` Anda.
* **Cara Reload:** Setelah menyimpan perubahan pada `config` atau `style.css`, Waybar **tidak** otomatis me-reload. Anda perlu memuat ulang konfigurasinya. Cara standar di Sway adalah dengan mengirim sinyal, atau cukup *restart* Waybar (misalnya, dengan *keybinding* reload Sway Anda).

---
<!--

## 🧐 Fokus Bahasa Inggris (Sesuai Instruksi)

Mari kita bedah beberapa terminologi kunci dari dokumentasi Waybar, sesuai permintaan Anda untuk fokus pada pembelajaran bahasa Inggris teknis dan profesional.

### 1. Placeholder (Penanda Tempat)

* **Konteks Teknis (Technical Context):** Dalam dokumentasi Waybar (seperti pada properti `"format"`), *placeholder* adalah token teks khusus (seperti `{usage}`, `{title}`, atau `{percentage}`) yang diapit kurung kurawal. Sistem (Waybar) mengganti token ini dengan nilai data dinamis (nilai *real-time*) sebelum menampilkannya.
* **Analisis (Grammar & Vocabulary):**
    * Ini adalah kata benda (Noun). *Placeholder* secara harfiah berarti "memegang tempat" (to hold a place).
    * Ini menyiratkan sesuatu yang sementara (temporary) atau perwakilan (representative) yang akan digantikan oleh konten sebenarnya.
* **Penggunaan Profesional (Professional Interaction):**
    * *"When defining the format string, you must consult the documentation to see which **placeholders** are available for that specific module."*
    * (Saat mendefinisikan *string* format, Anda harus merujuk ke dokumentasi untuk melihat **penanda tempat** apa yang tersedia untuk modul spesifik tersebut.)
* **Penggunaan Percakapan (Conversational Interaction):**
    * *"I'm just using **placeholder** text here; we'll add the real content later."*
    * (Saya hanya menggunakan teks **sementara** di sini; kita akan menambahkan konten sebenarnya nanti.)

### 2. Fallback (Cadangan / Mundur ke)

* **Konteks Teknis (Technical Context):** Dalam konfigurasi, *fallback* adalah nilai, perilaku, atau modul cadangan yang digunakan ketika pilihan utama (primary) gagal, tidak tersedia, atau tidak terdefinisi. Misalnya, jika format kustom gagal, ia mungkin *falls back* (mundur ke) format default.
* **Analisis (Grammar & Vocabulary):**
    * Bisa menjadi Noun: "We need a **fallback**." (Kita butuh **cadangan**.)
    * Bisa menjadi Phrasal Verb: "It will **fall back** to the default." (Itu akan **mundur ke** default.)
    * Kata ini menyiratkan *resilience* (ketahanan) atau *redundancy* (redundansi).
* **Penggunaan Profesional (Professional Interaction):**
    * *"The configuration should include a **fallback** mechanism in case the primary data source is unreachable."*
    * (Konfigurasi harus menyertakan mekanisme **cadangan** seandainya sumber data utama tidak dapat dijangkau.)
* **Penggunaan Percakapan (Conversational Interaction):**
    * *"My car won't start. My **fallback** plan is to take the bus."*
    * (Mobil saya tidak mau menyala. Rencana **cadangan** saya adalah naik bus.)

### 3. Conjunction: "Whereas" (Sedangkan / Padahal)

Anda meminta fokus pada *conjunctions* (kata hubung). "Whereas" adalah kata hubung formal yang sangat umum dalam dokumentasi teknis untuk menunjukkan kontras.

* **Konteks Teknis (Technical Context):** Sering digunakan untuk membandingkan dua pendekatan atau properti.
* **Analisis (Grammar & Vocabulary):**
    * Ini adalah *subordinating conjunction* (kata hubung subordinatif).
    * Ini digunakan untuk menghubungkan dua klausa independen yang saling bertentangan atau kontras secara langsung. Ini setara dengan "while" (sementara) tetapi lebih formal.
* **Contoh Dokumentasi (Professional Interaction):**
    * *"The `config` file defines the structure, **whereas** the `style.css` file defines the visual presentation."*
    * (File `config` mendefinisikan struktur, **sedangkan** file `style.css` mendefinisikan presentasi visual.)
* **Penggunaan Percakapan (Conversational Interaction):**
    * (Lebih jarang dalam percakapan santai, tetapi bisa digunakan dalam diskusi formal.)
    * *"He prefers a lightweight setup, **whereas** I prefer a system with all features enabled by default."*
    * (Dia lebih suka pengaturan yang ringan, **padahal** saya lebih suka sistem dengan semua fitur aktif secara default.)

---

## 💡 Rekomendasi Sumber Daya

Untuk menerapkan konsep-konsep ini, referensi utama Anda adalah **Waybar Wiki di GitHub** (sesuai permintaan Anda untuk referensi dari repositori). Ini adalah sumber utama (dari komunitas global) untuk daftar lengkap modul, placeholder, dan opsi konfigurasi.

Apakah Anda ingin saya melanjutkan dengan membedah satu modul spesifik (seperti `sway/workspaces` atau `custom`) secara mendalam, atau fokus pada contoh CSS untuk mencapai estetika tertentu?

## 🚀 Ikhtisar: Filosofi Konfigurasi Waybar

Sebelum melangkah ke teknis, penting untuk memahami filosofi Waybar. Waybar dirancang untuk menjadi **modular** dan **dapat disesaiakan gayanya (styleable)**.

* **Modularitas (Struktur):** Konfigurasi Waybar menggunakan format **JSON** (*JavaScript Object Notation*). Anda hanya mendefinisikan *apa* yang ingin Anda tampilkan (modul) dan *di mana* menampilkannya.
* **Styling (Tampilan):** Tampilan dan nuansa (estetika) Waybar dikontrol sepenuhnya oleh **CSS** (*Cascading Style Sheets*).

Pemisahan antara *struktur* (JSON) dan *tampilan* (CSS) inilah yang memberikan Waybar fleksibilitas luar biasa, sejalan dengan preferensi Anda akan kustomisasi dan estetika.

---

## 🛠️ Identitas Teknologi & Prasyarat

Preferensi untuk memahami teknologi secara mendalam:

* **Identitas:** Waybar adalah *status bar* (bilah status) yang sangat kustomisasi untuk *compositor* (komposer) Wayland (seperti Sway, yang Anda gunakan).
* **Bahasa Pemrograman:** Dibangun utamanya menggunakan **C++**, dengan beberapa komponen dan dependensi dalam **C**.
* **Prasyarat untuk Kustomisasi:**
    * **Wajib (Penting):**
        1.  **Pemahaman Dasar JSON:** Anda harus memahami sintaks dasar JSON (objek `{}`, array `[]`, pasangan *key-value* `"kunci": "nilai"`, dan pentingnya koma).
        2.  **Pemahaman Dasar CSS:** Anda harus memahami konsep *selectors* (pemilih) (seperti `#id` dan `.class`) dan *properties* (properti) (seperti `color`, `background-color`, `padding`).
    * **Opsional (Untuk Kustomisasi Lanjut):**
        1.  **Shell Scripting (cth: Bash):** Diperlukan jika Anda ingin membuat modul `custom` (kustom) yang menampilkan output dari skrip Anda sendiri.
        2.  **Pengetahuan Ikon Font:** (Seperti Font Awesome, Nerd Fonts) untuk menampilkan ikon alih-alih teks.

---

## 🗺️ Tahapan Pembelajaran Konfigurasi Waybar

Ini adalah peta jalan (roadmap) langkah demi langkah untuk menguasai konfigurasi Waybar, dari dasar hingga mahir.

### Tahap 1: Struktur File dan Konsep Dasar

Fokus di tahap ini adalah memahami di mana Waybar mencari file dan bagaimana file-file tersebut berinteraksi.

* **File Konfigurasi Utama (`config`):**
    * **Lokasi:** Biasanya di `~/.config/waybar/config`.
    * **Tujuan:** File ini (dalam format JSON) mendefinisikan **struktur** bar Anda.
    * **Konsep Kunci:** File ini adalah sebuah *objek JSON tunggal* yang berisi semua pengaturan.
* **File Styling (`style.css`):**
    * **Lokasi:** Biasanya di `~/.config/waybar/style.css`.
    * **Tujuan:** File ini (dalam format CSS) mendefinisikan **tampilan** bar Anda.
    * **Konsep Kunci:** Waybar secara otomatis memuat file ini. Anda "menargetkan" elemen di bar Anda menggunakan pemilih CSS.

### Tahap 2: Pengaturan Global (Level Atas) dalam `config`

Ini adalah properti di dalam objek JSON utama yang mendefinisikan perilaku bar secara keseluruhan.

* **Bagian Perlu (Necessary):**
    * `"layer"`: Menentukan tumpukan (stacking) bar. (Konsep: Apakah bar selalu di atas? Nilai umum: `"top"`).
    * `"position"`: Menentukan di mana bar berada di layar. (Konsep: Penempatan. Nilai umum: `"top"`, `"bottom"`).
    * `"modules-left"`, `"modules-center"`, `"modules-right"`: Ini adalah *inti* dari layout Anda.
        * **Konsep:** Ketiganya adalah *array JSON* (`[]`).
        * **Tujuan:** Anda mendaftarkan *nama* modul yang ingin Anda tampilkan di setiap bagian. Urutan dalam array menentukan urutan tampilan.

* **Bagian Opsional (Optional but Recommended):**
    * `"output"`: Penting untuk pengaturan multi-monitor. (Konsep: Menentukan pada monitor mana bar ini akan muncul).
    * `"height"` / `"width"`: Mengatur dimensi bar secara manual, meskipun biasanya otomatis lebih baik.

### Tahap 3: Konfigurasi Modul (Inti Kustomisasi)

Ini adalah bagian terbesar dan terpenting. Setiap item yang Anda lihat di bar (jam, CPU, workspace) adalah sebuah modul.

* **Konsep:** Setelah Anda *mendaftarkan* nama modul di Tahap 2 (misalnya, di `"modules-left"`), Anda harus *mendefinisikan* konfigurasi untuk modul tersebut sebagai objek JSON baru di level atas file `config`.
* **Contoh Struktur:** Jika Anda mendaftarkan `"clock"`, Anda perlu menambahkan bagian `"clock": { ... }` di file `config`.

* **Bagian Perlu (Umum untuk Hampir Semua Modul):**
    * `"format"`: Ini adalah properti *paling penting* dari sebuah modul.
        * **Konsep:** Ini adalah *string* (teks) yang mendefinisikan *apa* yang ditampilkan.
        * **Terminologi:** Menggunakan **Placeholders** (Penanda Tempat). Misalnya, untuk modul `cpu`, placeholder `{usage}` akan diganti dengan persentase penggunaan CPU saat ini. Setiap modul memiliki set placeholder-nya sendiri (Anda *harus* merujuk ke dokumentasi resmi Waybar untuk ini).

* **Bagian Opsional (Umum):**
    * `"tooltip"`: (true/false) Mengaktifkan/menonaktifkan info tambahan saat kursor *hover* di atas modul.
    * `"tooltip-format"`: Mirip dengan `"format"`, tetapi untuk konten *tooltip*.
    * `"interval"`: Seberapa sering modul diperbarui (dalam detik). (Konsep: Keseimbangan antara data *real-time* dan penggunaan sumber daya).
    * `"on-click"` / `"on-scroll"`: Menjalankan perintah kustom (skrip shell) saat modul diklik atau di-scroll. (Konsep: Interaktivitas).

* **Jenis Modul yang Perlu Dipelajari:**
    * **Modul Internal:** (Misalnya: `clock`, `cpu`, `memory`, `network`, `pulseaudio`, `battery`). Ini adalah modul bawaan. Anda hanya perlu mengonfigurasi format dan perilakunya.
    * **Modul Integrasi (Penting untuk Anda):** `sway/workspaces`, `sway/mode`. Ini adalah modul yang berinteraksi langsung dengan Sway.
    * **Modul Kustom (`custom/<name>`):** Ini adalah modul terkuat untuk kustomisasi.
        * **Konsep:** Anda memberikan perintah shell (`"exec"`) dan Waybar akan menampilkan *output* (stdout) dari perintah tersebut.
        * **Ini adalah kunci** untuk menampilkan informasi apa pun yang bisa Anda dapatkan melalui skrip CLI.

### Tahap 4: Styling (CSS)

Setelah struktur Anda (JSON) selesai, Anda beralih ke `style.css` untuk membuatnya terlihat bagus.

* **Konsep:** Setiap elemen di Waybar memiliki *ID* atau *class* CSS yang dapat Anda targetkan.
* **Pemilih (Selectors) Perlu:**
    * `window#waybar`: Menargetkan seluruh *container* (wadah) bar. (Gunakan ini untuk `background-color`, `border`, dll. pada bar itu sendiri).
    * `#<module-name>`: Menargetkan modul tertentu berdasarkan namanya. (Contoh: `#clock`, `#cpu`, `#custom-weather`). (Gunakan ini untuk `padding`, `margin`, `color` per modul).

* **Pemilih Opsional (Tingkat Lanjut):**
    * **Styling Berbasis Status:** Ini *sangat* kuat. Waybar secara dinamis menambahkan *class* CSS berdasarkan status modul.
        * **Contoh Konsep:** Modul baterai (`#battery`) mungkin mendapatkan class `.charging` saat mengisi daya atau `.warning` saat baterai lemah.
        * **Penerapan:** Anda dapat menulis CSS seperti `#battery.warning { background-color: red; }`. Ini memungkinkan bar Anda bereaksi secara visual terhadap status sistem.

### Tahap 5: Penanganan Error dan Iterasi

Sesuai permintaan Anda mengenai penanganan *error*.

* **Konsep:** Kesalahan paling umum adalah *sintaks JSON yang tidak valid*.
* **Cara Membaca Error:**
    1.  Selalu jalankan Waybar dari terminal (CLI) Anda saat melakukan *debugging*.
    2.  Jika Waybar gagal memulai atau *crash*, ia akan mencetak *error* ke terminal.
    3.  **Error Umum:** "Unexpected character" (Karakter tak terduga) atau "Missing comma" (Koma hilang). Ini hampir selalu berarti Anda salah menempatkan koma (atau lupa) di file `config` JSON Anda.
    4Next steps:
* **Cara Memvalidasi:** Gunakan *linter* (pemeriksa) JSON. Banyak editor kode (seperti VS Code) memilikinya secara bawaan, atau Anda dapat menggunakan alat *online* untuk memvalidasi sintaks file `config` Anda.
* **Cara Reload:** Setelah menyimpan perubahan pada `config` atau `style.css`, Waybar **tidak** otomatis me-reload. Anda perlu memuat ulang konfigurasinya. Cara standar di Sway adalah dengan mengirim sinyal, atau cukup *restart* Waybar (misalnya, dengan *keybinding* reload Sway Anda).


## 🧐 Fokus Bahasa Inggris (Sesuai Instruksi)

Mari kita bedah beberapa terminologi kunci dari dokumentasi Waybar, sesuai permintaan Anda untuk fokus pada pembelajaran bahasa Inggris teknis dan profesional.

### 1. Placeholder (Penanda Tempat)

* **Konteks Teknis (Technical Context):** Dalam dokumentasi Waybar (seperti pada properti `"format"`), *placeholder* adalah token teks khusus (seperti `{usage}`, `{title}`, atau `{percentage}`) yang diapit kurung kurawal. Sistem (Waybar) mengganti token ini dengan nilai data dinamis (nilai *real-time*) sebelum menampilkannya.
* **Analisis (Grammar & Vocabulary):**
    * Ini adalah kata benda (Noun). *Placeholder* secara harfiah berarti "memegang tempat" (to hold a place).
    * Ini menyiratkan sesuatu yang sementara (temporary) atau perwakilan (representative) yang akan digantikan oleh konten sebenarnya.
* **Penggunaan Profesional (Professional Interaction):**
    * *"When defining the format string, you must consult the documentation to see which **placeholders** are available for that specific module."*
    * (Saat mendefinisikan *string* format, Anda harus merujuk ke dokumentasi untuk melihat **penanda tempat** apa yang tersedia untuk modul spesifik tersebut.)
* **Penggunaan Percakapan (Conversational Interaction):**
    * *"I'm just using **placeholder** text here; we'll add the real content later."*
    * (Saya hanya menggunakan teks **sementara** di sini; kita akan menambahkan konten sebenarnya nanti.)

### 2. Fallback (Cadangan / Mundur ke)

* **Konteks Teknis (Technical Context):** Dalam konfigurasi, *fallback* adalah nilai, perilaku, atau modul cadangan yang digunakan ketika pilihan utama (primary) gagal, tidak tersedia, atau tidak terdefinisi. Misalnya, jika format kustom gagal, ia mungkin *falls back* (mundur ke) format default.
* **Analisis (Grammar & Vocabulary):**
    * Bisa menjadi Noun: "We need a **fallback**." (Kita butuh **cadangan**.)
    * Bisa menjadi Phrasal Verb: "It will **fall back** to the default." (Itu akan **mundur ke** default.)
    * Kata ini menyiratkan *resilience* (ketahanan) atau *redundancy* (redundansi).
* **Penggunaan Profesional (Professional Interaction):**
    * *"The configuration should include a **fallback** mechanism in case the primary data source is unreachable."*
    * (Konfigurasi harus menyertakan mekanisme **cadangan** seandainya sumber data utama tidak dapat dijangkau.)
* **Penggunaan Percakapan (Conversational Interaction):**
    * *"My car won't start. My **fallback** plan is to take the bus."*
    * (Mobil saya tidak mau menyala. Rencana **cadangan** saya adalah naik bus.)

### 3. Conjunction: "Whereas" (Sedangkan / Padahal)

Anda meminta fokus pada *conjunctions* (kata hubung). "Whereas" adalah kata hubung formal yang sangat umum dalam dokumentasi teknis untuk menunjukkan kontras.

* **Konteks Teknis (Technical Context):** Sering digunakan untuk membandingkan dua pendekatan atau properti.
* **Analisis (Grammar & Vocabulary):**
    * Ini adalah *subordinating conjunction* (kata hubung subordinatif).
    * Ini digunakan untuk menghubungkan dua klausa independen yang saling bertentangan atau kontras secara langsung. Ini setara dengan "while" (sementara) tetapi lebih formal.
* **Contoh Dokumentasi (Professional Interaction):**
    * *"The `config` file defines the structure, **whereas** the `style.css` file defines the visual presentation."*
    * (File `config` mendefinisikan struktur, **sedangkan** file `style.css` mendefinisikan presentasi visual.)
* **Penggunaan Percakapan (Conversational Interaction):**
    * (Lebih jarang dalam percakapan santai, tetapi bisa digunakan dalam diskusi formal.)
    * *"He prefers a lightweight setup, **whereas** I prefer a system with all features enabled by default."*
    * (Dia lebih suka pengaturan yang ringan, **padahal** saya lebih suka sistem dengan semua fitur aktif secara default.)

---

## 💡 Rekomendasi Sumber Daya

Untuk menerapkan konsep-konsep ini, referensi utama Anda adalah **Waybar Wiki di GitHub** (sesuai permintaan Anda untuk referensi dari repositori). Ini adalah sumber utama (dari komunitas global) untuk daftar lengkap modul, placeholder, dan opsi konfigurasi.

Apakah Anda ingin saya melanjutkan dengan membedah satu modul spesifik (seperti `sway/workspaces` atau `custom`) secara mendalam, atau fokus pada contoh CSS untuk mencapai estetika tertentu?
-->
[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
