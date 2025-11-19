### [🗺️ Tahap 4: Pengaturan Global (Level Atas) dalam `config`][0]

Bagian ini berfokus secara eksklusif pada *key-value pair* (pasangan kunci-nilai) di level teratas (Top-Level) dari file `config` JSON Anda. Ini adalah properti yang mengontrol **bar secara keseluruhan**, bukan modul-modul individual di dalamnya.

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### Daftar Isi Mini (Mini-Table of Contents)

  * **4.1 Konsep Inti:** Ruang Lingkup Konfigurasi (Configuration Scope)
  * **4.2 Bedah Kode (Wajib):** Properti Penempatan & Penargetan
      * 4.2.1 `"layer"`: Tumpukan Z-Axis (Stacking)
      * 4.2.2 `"position"`: Penjajaran X/Y-Axis (Alignment)
      * 4.2.3 `"output"`: Penargetan Monitor (Multi-Monitor)
      * 4.2.4 Bedah Perintah (CLI): Menemukan Nama `output` Anda
  * **4.3 Bedah Kode (Opsional):** Properti Dimensi Manual
      * 4.3.1 `"height"` dan `"width"`: Mengapa & Kapan Menggunakannya
  * **4.4 Bedah Kode (Inti):** Arsitektur Layout Modul
      * 4.4.1 `"modules-left"`, `"modules-center"`, `"modules-right"`
      * 4.4.2 Filosofi Array Modul: *Registrasi* vs *Definisi*
  * **4.5 Penanganan Error & Debugging Umum**
      * Kasus 1: "Bar saya tumpang tindih dengan jendela\!"
      * Kasus 2: "Bar saya muncul di monitor yang salah."
      * Kasus 3: "Bar saya tidak menampilkan modul apa pun."
  * **4.6 Fokus Bahasa Inggris:** Terminologi "Global", "Property", & "Array"
  * **4.7 Hubungan ke Tahap Berikutnya:** Dari *Layout* ke *Implementasi Modul*

-----

</details>

#### 4.1 Konsep Inti: Ruang Lingkup Konfigurasi (Configuration Scope)

**Penjelasan Detail**
Saat kita berbicara tentang "Pengaturan Global" atau "Level Atas" (Top-Level), kita merujuk pada *key-value pair* yang ditempatkan langsung di dalam objek JSON utama (di dalam `{}` pertama dan terakhir dari file `config`).

Anggap saja file `config` Anda sebagai sebuah "Rumah" (objek `{}`). Pengaturan global ini adalah aturan untuk *seluruh rumah*, seperti:

  * Alamat rumah (pada monitor mana ia berada? -\> `"output"`)
  * Apakah rumah itu melayang di udara atau menempel di tanah? (`"layer"`)
  * Di sisi jalan mana rumah itu dibangun? (`"position"`)

Ini berbeda dengan pengaturan *spesifik* untuk "kamar tidur" (`"clock"`) atau "dapur" (`"cpu"`), yang akan kita bahas di Tahap 5.

**Mengapa Ini Penting?**
Memahami *scope* (ruang lingkup) adalah fundamental. Jika Anda salah menempatkan properti global (seperti `"position"`) *di dalam* konfigurasi modul (seperti di dalam `"clock": { ... }`), itu tidak akan berfungsi, karena Waybar tidak mencarinya di sana.

-----

#### 4.2 Bedah Kode (Wajib): Properti Penempatan & Penargetan

Ini adalah properti paling dasar yang memberi tahu Waybar di mana harus "hidup".

##### 4.2.1 `"layer"`: Tumpukan Z-Axis (Stacking)

  * **Konsep:** Properti ini mengontrol tumpukan *z-axis* (vertikal) bar Anda, yaitu, apakah ia berada di *atas* jendela, di *bawah* jendela, atau di *latar belakang*. Ini adalah implementasi dari protokol **Wayland layer-shell**.

  * **Nilai yang Mungkin:**

      * `"top"`: (Paling Umum) Bar berada di lapisan atas. *Compositor* (Sway) akan secara otomatis *me-resize* (mengubah ukuran) jendela lain agar tidak tertutup oleh bar. Ini menciptakan "ruang" permanen untuk bar.
      * `"bottom"`: Sama seperti `"top"`, tetapi di bagian bawah.
      * `"overlay"`: Bar *melayang di atas* jendela Anda. Jendela akan digambar *di bawahnya*. Ini berguna untuk *bar* transparan yang ingin Anda lihat di atas jendela *fullscreen*, tetapi bisa mengganggu.
      * `"background"`: Bar berada di belakang segalanya, di atas *wallpaper*.

  * **Contoh Kode:**

    ```json
    "layer": "top"
    ```

      * `"layer"`: Ini adalah **Kunci** (Key) JSON, sebuah *string* literal. Ini memberi tahu Waybar properti mana yang sedang Anda atur.
      * `:`: Pemisah *key-value*.
      * `"top"`: Ini adalah **Nilai** (Value) JSON, sebuah *string*. Ini mengatur *layer* ke "top".

  * **Praktik Terbaik (Untuk Pengguna Sway):** Gunakan `"top"` atau `"bottom"`. Ini adalah perilaku yang paling diharapkan dan terintegrasi paling baik dengan *window manager* Anda, memungkinkan *layout* *tiling* (berubin) menyesuaikan diri secara otomatis.

##### 4.2.2 `"position"`: Penjajaran X/Y-Axis (Alignment)

  * **Konsep:** Setelah Anda mengatur *layer* (lapisan), properti ini menentukan di mana pada lapisan itu bar akan ditempatkan.

  * **Nilai yang Mungkin:**

      * `"top"`: (Paling Umum) Menempel di tepi atas layar.
      * `"bottom"`: (Umum) Menempel di tepi bawah layar.
      * `"left"`: Menghasilkan *bar vertikal* yang menempel di tepi kiri.
      * `"right"`: Menghasilkan *bar vertikal* yang menempel di tepi kanan.

  * **Contoh Kode:**

    ```json
    "position": "bottom"
    ```

      * `"position"`: *Kunci* JSON, nama properti.
      * `:`: Pemisah.
      * `"bottom"`: *Nilai* JSON. Mengatur bar agar menempel di bagian bawah.

  * **Tips:** Jika Anda menggunakan `"left"` atau `"right"`, bar akan horizontal secara *default*. Anda harus menggunakan CSS (`orientation: vertical;`) dan mungkin properti global `"width"` untuk membuatnya berfungsi seperti yang diharapkan.

##### 4.2.3 `"output"`: Penargetan Monitor (Multi-Monitor)

  * **Konsep:** Properti ini sangat penting bagi siapa pun yang memiliki lebih dari satu monitor. Ini memberi tahu Waybar pada *monitor* (atau "output") mana ia harus muncul.

  * **Perilaku Default:** Jika Anda **tidak menyertakan** *key* `"output"` sama sekali, Waybar akan muncul di **semua** monitor.

  * **Nilai yang Mungkin:**

    1.  Sebuah *String* Nama Output: `e.g., "eDP-1"` (untuk laptop internal) atau `"HDMI-A-1"` (untuk monitor eksternal). Bar hanya akan muncul di monitor itu.
    2.  Sebuah *Array* String: `e.g., ["eDP-1", "HDMI-A-1"]`. Bar akan muncul di *setiap* monitor yang tercantum dalam *array*.

  * **Contoh Kode (Satu Monitor):**

    ```json
    "output": "HDMI-A-1"
    ```

      * `"output"`: *Kunci* JSON.
      * `:`: Pemisah.
      * `"HDMI-A-1"`: *Nilai* JSON. Ini adalah **nama spesifik** monitor Anda.

##### 4.2.4 Bedah Perintah (CLI): Menemukan Nama `output` Anda

Anda tidak bisa menebak nama *output* Anda. Anda harus menanyakannya kepada *compositor* (Sway).

  * **Perintah (Sesuai Preferensi CLI Anda):**
    ```bash
    swaymsg -t get_outputs
    ```
  * **Penjelasan Kata-per-Kata:**
      * `swaymsg`: Ini adalah utilitas *command-line* (baris perintah) yang memungkinkan Anda mengirim pesan ke proses Sway yang sedang berjalan. Ini adalah cara Anda berinteraksi dengan Sway melalui skrip.
      * `-t`: Ini adalah *flag* (bendera) atau *option* (opsi) yang merupakan kependekan dari `--type`. Ini memberi tahu `swaymsg` jenis pesan apa yang Anda kirim.
      * `get_outputs`: Ini adalah **argumen** untuk *flag* `-t`. Ini adalah *tipe pesan*. Anda meminta Sway untuk mengembalikan (get) daftar semua *output* (monitor) yang terdeteksi.
  * **Contoh Output Terminal (Dipotong):**
    ```json
    [
      {
        "name": "eDP-1",
        "active": true,
        ...
      },
      {
        "name": "HDMI-A-1",
        "active": true,
        ...
      }
    ]
    ```
  * **Cara Membaca:** Outputnya adalah JSON. Cari *key* `"name"`. Nilai yang terkait (misal: `"eDP-1"`) adalah *string* yang tepat yang harus Anda gunakan untuk properti `"output"` di `config` Waybar Anda.

**Sumber Referensi:**

  * [Waybar Wiki: Configuration](https://www.google.com/search?q=https://github.com/Alexays/Waybar/wiki/Configuration) - Dokumentasi resmi untuk semua *key* global.
  * `man swaymsg` - Halaman *manual* (di terminal Anda) untuk perintah `swaymsg`.

-----

#### 4.3 Bedah Kode (Opsional): Properti Dimensi Manual

##### 4.3.1 `"height"` dan `"width"`: Mengapa & Kapan Menggunakannya

  * **Konsep:** Properti ini memungkinkan Anda *memaksa* (force) dimensi bar ke nilai piksel tertentu.

  * **Contoh Kode:**

    ```json
    "height": 30
    ```

      * `"height"`: *Kunci* JSON.
      * `:`: Pemisah.
      * `30`: *Nilai* JSON. Perhatikan: ini adalah **Angka (Number)**, bukan *string* (tanpa tanda kutip `"`). Ini berarti 30 piksel.

  * **Praktik Terbaik: KAPAN JANGAN DIGUNAKAN\!**
    Sesuai filosofi *Separation of Concerns* (SoC) kita, dimensi (ukuran) adalah bagian dari *tampilan* (style). **Cara terbaik** untuk mengontrol tinggi bar Anda adalah melalui `style.css` dengan mengatur `font-size` dan `padding` pada `window#waybar`. Bar kemudian akan **secara otomatis** menghitung tingginya agar pas dengan kontennya. Ini jauh lebih fleksibel.

  * **Praktik Terbaik: KAPAN HARUS DIGUNAKAN\!**

      * Satu-satunya pengecualian umum adalah untuk **bar vertikal**.
      * Jika Anda mengatur `"position": "left"`, Anda **wajib** mengatur properti `"width"` (misal: `"width": 35`), karena bar tidak dapat secara otomatis menentukan lebarnya dalam mode vertikal.

-----

#### 4.4 Bedah Kode (Inti): Arsitektur Layout Modul

Ini adalah *key* paling penting di level global. Mereka adalah cetak biru untuk *layout* bar Anda.

##### 4.4.1 `"modules-left"`, `"modules-center"`, `"modules-right"`

  * **Konsep:** Tiga *key* ini adalah inti dari layout Anda. Masing-masing mengambil **Array** (daftar) dari *string* (teks). Setiap *string* adalah **nama** dari modul yang ingin Anda tampilkan di bagian tersebut.
  * **Urutan Penting:** Urutan *string* di dalam *array* menentukan urutan visual modul di bar (dari kiri ke kanan di setiap bagian).

##### 4.4.2 Filosofi Array Modul: *Registrasi* vs *Definisi*

Ini adalah konsep yang **sangat penting** yang sering membingungkan pemula.

  * **Registrasi (Pendaftaran):** Menempatkan nama modul (misal: `"clock"`) di dalam *array* ini **tidak mengonfigurasi** jam. Itu hanya **mendaftarkan** modul tersebut untuk dimuat dan memberi tahu Waybar, "Hei, saya ingin modul bernama 'clock' ada di sini."

  * **Definisi (Pendefinisian):** Nanti (di Tahap 5), di *level atas* JSON, Anda harus *secara terpisah* **mendefinisikan** apa itu modul `"clock"` dengan membuat *objek* JSON baru: `"clock": { "format": "..." }`.

  * **Bedah Kode (Contoh Lengkap):**

    ```json
    {
      "layer": "top",
      "position": "top",
      "modules-left": [ "sway/workspaces", "sway/mode" ],
      "modules-center": [ "clock" ],
      "modules-right": [ "pulseaudio", "network", "cpu", "memory" ]
    }
    ```

  * **Penjelasan Kata-per-Kata (Fokus pada Layout):**

      * `"modules-left"`: *Kunci* JSON. Mendefinisikan bagian kiri dari bar.
      * `:`: Pemisah.
      * `[`: Tanda kurung siku buka. Ini memulai sebuah **Array JSON**.
      * `"sway/workspaces"`: *Item* pertama dalam *array*. Ini adalah *string* (teks). Ini memberi tahu Waybar untuk memuat modul bernama `sway/workspaces` **pertama** di sebelah kiri.
      * `,`: Koma. Pemisah antar *item* dalam *array*.
      * `"sway/mode"`: *Item* kedua. Ini akan muncul **di sebelah kanan** `"sway/workspaces"`.
      * `]`: Kurung siku tutup. Mengakhiri *array* untuk `modules-left`.
      * `"modules-center"`: *Kunci* JSON. Mendefinisikan bagian tengah.
      * `[`: Memulai *array* baru.
      * `"clock"`: *Item* tunggal. Ini memberi tahu Waybar untuk memuat modul bernama `clock` di tengah.
      * `]`: Mengakhiri *array*.
      * `"modules-right"`: *Kunci* JSON. Mendefinisikan bagian kanan.
      * `[ ... ]`: Memulai *array* yang berisi modul-modul `pulseaudio`, `network`, `cpu`, dan `memory`, **dalam urutan tersebut** dari kiri ke kanan (atau kanan ke kiri jika bar diatur *right-to-left*, tetapi itu jarang).

-----

#### 4.5 Penanganan Error & Debugging Umum

  * **Kasus 1: "Bar saya tumpang tindih dengan jendela\!"**

      * **Penyebab:** Properti `"layer"` Anda kemungkinan diatur ke `"overlay"`.
      * **Solusi:** Ubah menjadi `"layer": "top"` atau `"layer": "bottom"`. Pastikan Anda me-restart Waybar setelah mengubahnya.

  * **Kasus 2: "Bar saya muncul di monitor yang salah (atau di semua monitor)."**

      * **Penyebab:** Anda tidak mengatur properti `"output"` (sehingga *default*-nya ke semua monitor), atau Anda salah mengetik nama *output*.
      * **Solusi:** Jalankan `swaymsg -t get_outputs`. Salin-tempel (copy-paste) nama yang benar (misal: `"eDP-1"`) ke dalam properti `"output"` Anda.

  * **Kasus 3: "Bar saya muncul, tapi kosong\!"**

      * **Penyebab:** Anda telah mendefinisikan *layout* (misal: `"modules-left": ["clock"]`), tetapi Anda **lupa** untuk *mendefinisikan* modul `"clock"` itu sendiri.
      * **Solusi:** Ini adalah *pratinjau* (preview) dari Tahap 5. Anda perlu menambahkan blok konfigurasi modul di level atas, seperti: `"clock": { "format": "{:%H:%M}" }`. Kita akan membahas ini secara detail di tahap berikutnya.

-----
<!---------
#### 4.6 🧐 Fokus Bahasa Inggris (Sesuai Instruksi)

Mari kita bedah tiga terminologi kunci dari bagian ini.

**1. Global (Global)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata sifat (Adjective).
      * Berasal dari kata "globe" (bola dunia), yang menyiratkan sesuatu yang "mencakup keseluruhan".
  * **Konteks Teknis (Technical Context):** Dalam pemrograman dan konfigurasi, "global" merujuk pada pengaturan, variabel, atau *scope* (ruang lingkup) yang dapat diakses atau berlaku untuk *seluruh* program atau sistem, bukan hanya satu bagian kecil (yang disebut "local").
  * **Penggunaan Profesional (Professional Interaction):**
      * *"These settings are **global**; they apply to the entire application, not just this one module."*
      * (Pengaturan ini bersifat **global**; ini berlaku untuk seluruh aplikasi, bukan hanya satu modul ini.)
      * *"Avoid using **global** variables when possible, as they can be modified from anywhere, which makes debugging difficult."*
      * (Hindari penggunaan variabel **global** jika memungkinkan, karena variabel tersebut dapat dimodifikasi dari mana saja, yang membuat *debugging* sulit.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * *"Climate change is a **global** problem."*
      * (Perubahan iklim adalah masalah **global**.)

**2. Property (Properti)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata benda (Noun).
      * Berasal dari bahasa Latin `proprietas`, yang berarti "kepemilikan" atau "karakteristik".
  * **Konteks Teknis (Technical Context):** Ini adalah istilah yang sangat umum dalam JSON, CSS, dan pemrograman berorientasi objek (OOP). Ini adalah **karakteristik** atau **atribut** dari sebuah objek yang dapat diatur. Dalam JSON, ini adalah **Key** (Kunci) dalam *key-value pair*.
  * **Penggunaan Profesional (Professional Interaction):**
      * *"You need to set the `position` **property** to 'top' in your JSON config."*
      * (Anda perlu mengatur **properti** `position` ke 'top' di konfigurasi JSON Anda.)
      * *"The `color` **property** in CSS defines the text color of the selected element."*
      * (**Properti** `color` di CSS mendefinisikan warna teks dari elemen yang dipilih.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * *"One **property** of water is that it freezes at 0°C."*
      * (Salah satu **sifat** air adalah ia membeku pada 0°C.)

**3. Array (Larik / Array)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata benda (Noun).
      * Berasal dari bahasa Prancis Kuno `arayer`, yang berarti "mengatur" atau "menyusun dalam urutan".
  * **Konteks Teknis (Technical Context):** Struktur data fundamental. Ini adalah **daftar (list) yang terurut** dari *item* atau *elemen*. Dalam JSON, *array* ditandai dengan kurung siku `[ ]` dan setiap *item* dipisahkan oleh koma.
  * **Penggunaan Profesional (Professional Interaction):**
      * *"The `modules-left` property expects an **array** of strings."*
      * (Properti `modules-left` mengharapkan sebuah **array** berisi *string*.)
      * *"We need to loop over this **array** to process each item individually."*
      * (Kita perlu melakukan *looping* pada **array** ini untuk memproses setiap *item* satu per satu.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * *"The store has a wide **array** of options to choose from."*
      * (Toko itu memiliki beragam **susunan** pilihan untuk dipilih.)

-----

#### 4.7 Hubungan ke Tahap Berikutnya

Kita telah berhasil\! Kita telah membangun "kerangka" (scaffolding) dari bar kita. Kita telah memberi tahu Waybar:

1.  Di mana harus muncul (`position`, `layer`, `output`).
2.  "Slot" atau "ruang" apa yang telah kita siapkan (`modules-left`, `modules-center`, `modules-right`).
3.  Nama-nama modul yang ingin kita masukkan ke dalam slot tersebut (misal: `"clock"`, `"cpu"`).

Sekarang, bar kita masih kosong karena meskipun kita sudah *mendaftarkan* nama `"clock"`, kita belum *memberi tahu* Waybar **apa itu `"clock"`**. Kita belum *mendefinisikannya*.

Ini adalah jembatan yang sempurna ke **Tahap 5: Konfigurasi Modul**, di mana kita akan mulai menambahkan objek-objek JSON level atas (seperti `"clock": { ... }`, `"cpu": { ... }`) untuk benar-benar menghidupkan modul-modul tersebut.

-----

Ini adalah akhir dari Bagian 4. Kita telah mendefinisikan struktur dan layout bar secara keseluruhan.

*> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
*Apakah Anda siap untuk mulai mengisi "slot" tersebut dan membedah "Tahap 5: Konfigurasi Modul (Inti Kustomisasi)"?**
-------------------------------------------->

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**

[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md


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
