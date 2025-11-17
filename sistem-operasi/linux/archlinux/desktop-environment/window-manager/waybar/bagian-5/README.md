### 🗺️ Tahap 5: Konfigurasi Modul (Inti Kustomisasi)

Bagian ini berfokus pada *objek-objek* JSON yang Anda tambahkan di *level atas* (Top-Level) file `config` Anda. Setiap objek ini **mendefinisikan** perilaku dan tampilan dari satu modul spesifik yang Anda daftarkan di Tahap 4 (`modules-left`, dll.). 
Kita sekarang memasuki **jantung** dari kustomisasi Waybar. Tahap 1-3 adalah fondasi (Filosofi, Prasyarat, Lokasi File) dan Tahap 4 adalah cetak biru (Layout Global).

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### Daftar Isi Mini (Mini-Table of Contents)

  * **5.1 Konsep Inti: *Registrasi* vs. *Definisi***
  * **5.2 Properti Umum Wajib: `"format"` (Sang Penampil)**
      * 5.2.1 Bedah Kode: *String* Format, Teks Literal, dan *Placeholder*
  * **5.3 Properti Umum Opsional (Informatif): `"tooltip"` & `"tooltip-format"`**
  * **5.4 Properti Umum Opsional (Kinerja): `"interval"`**
      * 5.4.1 Filosofi: *Polling* vs. *Event-Driven* (Implikasi Kinerja)
  * **5.5 Properti Umum Opsional (Interaktivitas): `on-click`, `on-scroll`**
      * 5.5.1 Bedah Perintah (CLI): Menggunakan `on-click` untuk Notifikasi
  * **5.6 Jenis-Jenis Modul: Gambaran Umum Kategori**
      * 5.6.1 Modul Internal (Bawaan)
      * 5.6.2 Modul Integrasi (Pihak Ketiga)
      * 5.6.3 Modul Kustom (`custom/<name>`)
  * **5.7 Penanganan Error & Debugging Umum**
      * Kasus 1: "Bar saya kosong / modul saya tidak muncul\!"
      * Kasus 2: "Modul saya muncul, tapi menampilkan 'N/A' atau '0%' terus-menerus."
      * Kasus 3: "Perintah `on-click` saya tidak berfungsi."
  * **5.8 Fokus Bahasa Inggris:** Terminologi "Placeholder", "Polling", & "Event-Driven"
  * **5.9 Hubungan ke Tahap Berikutnya:** Dari *Aturan Umum* ke *Modul Spesifik*

-----

</details>

#### 5.1 Konsep Inti: *Registrasi* vs. *Definisi*

Ini adalah konsep paling krusial untuk dipahami di Tahap 5, yang sering membingungkan pemula.

  * **Registrasi (Registration):** Terjadi di Tahap 4. Saat Anda menulis `"modules-center": [ "clock" ]`, Anda *hanya* memberi tahu Waybar: "Saya memesan satu slot di tengah untuk modul yang saya *putuskan* untuk beri nama 'clock'." Anda **mendaftarkan** sebuah nama.
  * **Definisi (Definition):** Ini adalah Tahap 5. Di *level atas* file `config` Anda (sebagai *sibling* atau "saudara" dari `"modules-center"`), Anda **wajib** membuat *key* JSON baru yang **cocok persis** dengan nama yang Anda daftarkan.

**Bedah Kode: Hubungan Registrasi & Definisi**

```json
{
  "layer": "top",
  "position": "top",

  "modules-center": [ "clock" ],

  "clock": {
    "format": "{:%H:%M}",
    "tooltip-format": "{:%A, %d %B %Y}"
  }
}
```

  * `"modules-center": [ "clock" ]`
      * **Penjelasan:** Ini adalah **Registrasi**. Anda "mendaftarkan" nama `"clock"`.
  * `"clock": { ... }`
      * **Penjelasan:** Ini adalah **Definisi**. Karena Anda mendaftarkan nama `"clock"`, Waybar sekarang mencari *objek* JSON level atas dengan *key* `"clock"` untuk mengetahui *apa yang harus dilakukan* dengan modul itu.
      * `{ ... }`: Objek JSON ini berisi *semua* konfigurasi khusus untuk modul jam, seperti `"format"`-nya.

**Potensi Kesalahan Umum**

  * **Kesalahan:** Anda mendaftarkan `"modules-center": [ "Clock" ]` (dengan 'C' kapital) tetapi mendefinisikan `"clock": { ... }` (dengan 'c' kecil).
  * **Hasil:** **Nama tidak cocok.** Waybar tidak akan menemukan definisinya. Modul tidak akan muncul. Nama harus **cocok persis** (case-sensitive).

-----

#### 5.2 Properti Umum Wajib: `"format"` (Sang Penampil)

**Penjelasan Detail**
Ini adalah properti **paling penting** di dalam *definisi* modul. Properti `"format"` adalah *string* (teks) yang mengontrol **apa yang sebenarnya ditampilkan** oleh modul di bar.

**Konsep Inti: Teks Literal dan *Placeholder***
Nilai dari `"format"` adalah *string* yang berisi campuran dua hal:

1.  **Teks Literal (Literal Text):** Karakter apa pun yang Anda ketik (seperti `CPU:`, `%`, atau ikon ``) akan ditampilkan **persis seperti apa adanya**.
2.  **Placeholder (Penanda Tempat):** Token khusus yang diapit kurung kurawal (misal: `{usage}`, `{percentage}`) yang **diganti** oleh Waybar dengan **data dinamis** (nilai *real-time*).

**Setiap modul memiliki daftar *placeholder*-nya sendiri.** Anda *wajib* merujuk ke dokumentasi modul tersebut untuk mengetahui *placeholder* apa yang tersedia.

##### 5.2.1 Bedah Kode: *String* Format, Teks Literal, dan *Placeholder*

Mari kita lihat definisi untuk modul `cpu` (meskipun kita belum secara resmi mendaftarkannya, ini adalah contoh yang baik).

```json
"cpu": {
  "format": "CPU: {usage}% "
}
```

  * `"cpu": { ... }`
      * **Penjelasan:** Ini adalah **Definisi** modul. Kita asumsikan `"cpu"` telah *diregistrasi* (misalnya di `"modules-right"`).
  * `"format"`
      * **Penjelasan:** *Kunci* JSON. Nama properti.
  * `:`
      * **Penjelasan:** Pemisah *key-value*.
  * `"CPU: {usage}% "`
      * **Penjelasan:** Ini adalah **Nilai** (Value) berupa *string*. Mari kita bedah *isinya*:
      * ` CPU:  ` (dengan spasi)
          * **Penjelasan:** Ini adalah **Teks Literal**. Waybar akan mencetak kata "CPU:" diikuti spasi ke bar.
      * `{usage}`
          * **Penjelasan:** Ini adalah **Placeholder**. Waybar *tahu* bahwa untuk modul `cpu`, `{usage}` harus diganti dengan nilai persentase penggunaan CPU saat ini (misal: `14`).
      * `%` (setelah placeholder)
          * **Penjelasan:** Ini adalah **Teks Literal** lagi. Waybar akan mencetaknya persis setelah nilai *placeholder*.
      * `     ` (spasi)
          * **Penjelasan:** Teks Literal.
      * ``
          * **Penjelasan:** Ini adalah **Teks Literal**. Ini bukan perintah, ini adalah satu karakter *glyph* (ikon) dari Nerd Font (sesuai preferensi estetika Anda). Waybar hanya menampilkannya.
  * **Hasil Akhir di Bar:** `CPU: 14% `

**Sumber Referensi**

  * [Waybar Wiki (Beranda)](https://www.google.com/search?q=https://github.com/Alexays/Waybar/wiki) - Klik modul apa pun (misal: `Module: Cpu`) untuk melihat daftar lengkap *placeholder* yang didukungnya.

-----

#### 5.3 Properti Umum Opsional (Informatif): `"tooltip"` & `"tooltip-format"`

  * **Konsep:** *Tooltip* adalah kotak informasi yang muncul saat Anda *hover* (mengarahkan kursor) di atas modul.

  * `"tooltip": true` (atau `false`)

      * **Penjelasan:** *Key* JSON ini (bernilai *boolean* `true` atau `false`) mengaktifkan atau menonaktifkan *tooltip* untuk modul ini. *Default*-nya biasanya `true`.

  * `"tooltip-format"`

      * **Penjelasan:** Berfungsi **persis seperti `"format"`**, tetapi *string* ini digunakan untuk konten di dalam kotak *tooltip*. Ini memungkinkan Anda menampilkan ringkasan singkat di bar (`"format"`) dan detail lengkap di *tooltip* (`"tooltip-format"`).

  * **Contoh Kode (Modul Memori):**

    ```json
    "memory": {
      "format": "RAM: {used:0.1f}G",
      "tooltip-format": "{used:0.1f}G / {total:0.1f}G Digunakan"
    }
    ```

      * `{used:0.1f}G`: Ini adalah *placeholder* (`{used}`) dengan *pemformatan* (`:0.1f` yang berarti "angka desimal (float) dengan 1 angka di belakang koma").
      * **Hasil di Bar:** `RAM: 4.2G`
      * **Hasil di Tooltip (saat hover):** `4.2G / 16.0G Digunakan`

-----

#### 5.4 Properti Umum Opsional (Kinerja): `"interval"`

  * **Konsep:** Properti ini mengontrol seberapa sering (dalam **detik**) Waybar **memperbarui** modul ini dengan menjalankan perintah internalnya.

  * **Nilai:** Sebuah **Angka (Number)**, bukan *string*. Contoh: `"interval": 5`.

  * **Contoh Kode (Modul CPU):**

    ```json
    "cpu": {
      "format": "CPU: {usage}%",
      "interval": 10
    }
    ```

      * `"interval": 10`
          * **Penjelasan:** Waybar hanya akan memeriksa penggunaan CPU **setiap 10 detik**.

  * **Mengapa Ini Penting? (Sesuai Preferensi Kinerja Anda):**
    Ini adalah pengoptimalan *low footprint* (jejak rendah). Anda tidak perlu tahu penggunaan CPU setiap detik. Mengaturnya ke `10` detik (alih-alih *default*-nya, misal `1` detik) **sangat** mengurangi penggunaan sumber daya Waybar.

  * **Praktik Terbaik:**

      * `clock`: Tidak perlu *interval* (ia tahu kapan harus update).
      * `cpu`, `memory`, `network`: Set ke interval wajar (`5`, `10`, atau `30` detik).
      * `sway/workspaces`: **Tidak perlu interval.** Ini adalah modul *Event-Driven*.

##### 5.4.1 Filosofi: *Polling* vs. *Event-Driven* (Implikasi Kinerja)

  * **Polling (Proaktif):** Menggunakan `"interval"` disebut *Polling*. Modul secara proaktif "bangun" setiap X detik, "bertanya" ke sistem (misal: "Berapa penggunaan CPU sekarang?"), lalu "tidur" lagi. Ini *memakan* sumber daya, meskipun sedikit.
  * **Event-Driven (Reaktif):** Modul seperti `sway/workspaces` tidak perlu *polling*. Sway **memberi tahu** (mengirim *event*) Waybar saat Anda berpindah *workspace*. Waybar hanya "mendengarkan" dan bereaksi. Ini **sangat efisien** dan instan.

-----

#### 5.5 Properti Umum Opsional (Interaktivitas): `on-click`, `on-scroll`

  * **Konsep:** Properti ini mengubah modul Anda dari *display* (tampilan) statis menjadi *launcher* (peluncur) interaktif. Nilainya adalah **string** yang berisi **perintah shell** (CLI).

  * **Properti yang Tersedia:**

      * `"on-click"`: Klik kiri.
      * `"on-click-right"`: Klik kanan.
      * `"on-click-middle"`: Klik tengah (roda mouse).
      * `"on-scroll-up"`: Scroll roda mouse ke atas.
      * `"on-scroll-down"`: Scroll roda mouse ke bawah.

  * **Contoh Kode (Modul `pulseaudio` - Kontrol Volume):**

    ```json
    "pulseaudio": {
      "format": "{volume}% ",
      "on-click": "pavucontrol",
      "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +5%",
      "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -5%"
    }
    ```

      * `"on-click": "pavucontrol"`: Saat diklik kiri, jalankan perintah `pavucontrol` (membuka *mixer* volume).
      * `"on-scroll-up": "..."`: Saat *scroll* ke atas, jalankan perintah `pactl` untuk menaikkan volume 5%.

##### 5.5.1 Bedah Perintah (CLI): Menggunakan `on-click` untuk Notifikasi

Mari kita buat modul kustom sederhana untuk menguji ini (sesuai preferensi CLI Anda).

  * **Konfigurasi (`config`):**

    ```json
    "custom/test": {
      "format": "Test 🔔",
      "on-click": "notify-send 'Halo dari Waybar!' 'Ini adalah tes on-click.'"
    }
    ```

    (Asumsikan Anda *mendaftarkan* `"custom/test"` di suatu tempat, misal `"modules-center"`).

  * **Prasyarat (Arch Linux):** Anda memerlukan `libnotify` untuk perintah `notify-send`.
    `sudo pacman -S libnotify`

  * **Penjelasan Kata-per-Kata Perintah `on-click`:**

      * `"on-click"`: *Kunci* JSON.
      * `:`: Pemisah.
      * `"notify-send 'Halo dari Waybar!' 'Ini adalah tes on-click.'"`
          * **Penjelasan:** Ini adalah **satu *string* JSON** yang akan dieksekusi oleh *shell*.
          * `notify-send`
              * **Penjelasan:** Ini adalah **perintah** (file *executable*). Tugasnya adalah mengirim notifikasi *desktop*.
          * `'Halo dari Waybar!'`
              * **Penjelasan:** Ini adalah **argumen pertama** untuk `notify-send`. Ini adalah *judul* notifikasi. Tanda kutip tunggal (`'`) adalah praktik *shell* yang baik untuk memastikan *string* dengan spasi diperlakukan sebagai satu argumen.
          * `'Ini adalah tes on-click.'`
              * **Penjelasan:** Ini adalah **argumen kedua** untuk `notify-send`. Ini adalah *isi* (body) dari notifikasi.

-----

#### 5.6 Jenis-Jenis Modul: Gambaran Umum Kategori

Waybar membagi modulnya menjadi beberapa jenis, yang penting untuk diketahui di mana mencarinya di dokumentasi.

  * **5.6.1 Modul Internal (Bawaan):**
      * **Contoh:** `clock`, `cpu`, `memory`, `network`, `battery`.
      * **Filosofi:** Ini adalah modul yang fungsionalitasnya **dikompilasi langsung ke dalam C++** Waybar. Mereka sangat cepat, efisien, dan tidak memerlukan dependensi eksternal.
  * **5.6.2 Modul Integrasi (Pihak Ketiga):**
      * **Contoh:** `sway/workspaces`, `sway/mode` (Spesifik Sway\!), `pulseaudio`, `mpd`.
      * **Filosofi:** Modul ini juga dikompilasi, tetapi dirancang untuk **berkomunikasi** dengan *perangkat lunak lain* (seperti Sway atau server audio PulseAudio) melalui API atau *event*.
  * **5.6.3 Modul Kustom (`custom/<name>`):**
      * **Contoh:** `"custom/cuaca"`, `"custom/crypto"`, `"custom/test"` (dari atas).
      * **Filosofi:** Modul terkuat dan paling fleksibel. Ini memungkinkan Anda **menjalankan skrip shell apa pun**. Anda memberi Waybar sebuah perintah di properti `"exec"`, dan Waybar menampilkan apa pun yang dicetak skrip itu ke STDOUT (idealnya dalam format JSON: `{"text": "...", "tooltip": "..."}`).

-----

#### 5.7 Penanganan Error & Debugging Umum

  * **Kasus 1: "Bar saya kosong / modul saya tidak muncul\!"**
      * **Penyebab Paling Umum:** Anda **mendaftarkan** sebuah nama (misal: `"clock"`) tetapi **lupa mendefinisikannya** (lupa menambahkan blok `"clock": { ... }`).
      * **Penyebab Kedua:** Salah ketik (Typo). Anda mendaftarkan `"clok"` tetapi mendefinisikan `"clock"`. Namanya harus **cocok 100%** (case-sensitive).
  * **Kasus 2: "Modul saya muncul, tapi menampilkan 'N/A' atau '0%' terus-menerus."**
      * **Penyebab:** Modulnya dimuat, tetapi tidak bisa mendapatkan data. (Contoh: modul `"battery"` di PC Desktop, atau modul `"network"` tetapi Anda salah nama *interface*, misal `eth0` padahal seharusnya `enp3s0`).
      * **Penyebab Lain:** Anda salah *placeholder* di `"format"`. (Misal: Anda mengetik `{percent}` padahal dokumentasi bilang `{percentage}`).
      * **Solusi:** **Selalu baca dokumentasi Wiki Waybar** untuk modul tersebut. Pastikan *placeholder* Anda benar dan semua properti wajib (seperti nama *interface* jaringan) telah diatur.
  * **Kasus 3: "Perintah `on-click` saya tidak berfungsi."**
      * **Solusi:** **Uji perintah Anda di terminal (CLI) terlebih dahulu.** Buka terminal dan ketik `pavucontrol`. Apakah itu berjalan? Jika ya, itu akan berjalan di Waybar. Jika tidak (misal: "command not found"), itu berarti *executable*-nya tidak ada di `$PATH` Anda atau Anda salah mengetiknya.

-----
<!--
#### 5.8 🧐 Fokus Bahasa Inggris (Sesuai Instruksi)

Mari kita bedah tiga terminologi kunci dari bagian ini.

**1. Placeholder (Penanda Tempat)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata benda (Noun) majemuk. `Place` (Tempat) + `Holder` (Pemegang).
      * Maknanya sangat harfiah: "Sesuatu yang *memegang tempat* untuk sesuatu yang lain yang akan datang nanti."
  * **Konteks Teknis (Technical Context):** Seperti dijelaskan, ini adalah token (seperti `{usage}`) dalam sebuah *template string* yang akan diganti dengan nilai dinamis (data *real-time*) saat *runtime* (waktu eksekusi).
  * **Penggunaan Profesional (Professional Interaction):**
      * *"The `format` string uses **placeholders** to inject dynamic data from the module."*
      * (String `format` menggunakan **penanda tempat** untuk menyuntikkan data dinamis dari modul.)
      * *"Please use the `{user_name}` **placeholder** in the email template; our system will replace it with the recipient's actual name."*
      * (Tolong gunakan **penanda tempat** `{user_name}` di templat email; sistem kami akan menggantinya dengan nama asli penerima.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * *"This empty box is just a **placeholder** until the real statue arrives."*
      * (Kotak kosong ini hanyalah **pengisi tempat** sampai patung aslinya tiba.)

**2. Polling (Polling / Jajak Pendapat)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah *gerund* (kata kerja yang berfungsi sebagai kata benda), dari kata kerja (Verb) `to poll`.
      * `To poll` berarti "meminta (suara/data) secara berulang dari banyak sumber."
  * **Konteks Teknis (Technical Context):** Ini adalah teknik di mana sebuah sistem *secara aktif* dan *berulang kali* memeriksa status perangkat atau sumber daya dalam interval tetap (misal: `"interval": 5`). Ini adalah *proaktif*.
  * **Penggunaan Profesional (Professional Interaction):**
      * *"We are **polling** the sensor every five seconds for a new temperature reading."*
      * (Kami sedang **melakukan polling** sensor setiap lima detik untuk mendapatkan data suhu baru.)
      * *"Frequent **polling** can be inefficient and increase resource consumption."*
      * (**Polling** yang sering bisa jadi tidak efisien dan meningkatkan konsumsi sumber daya.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * *"The news channel is **polling** voters as they exit the building."*
      * (Saluran berita sedang **mengambil suara** pemilih saat mereka keluar gedung.)

**3. Event-Driven (Digerakkan oleh Peristiwa/Kejadian)**

  * **Analisis (Grammar & Vocabulary):**
      * Ini adalah kata sifat (Adjective) majemuk. `Event` (Peristiwa) + `Driven` (Digerakkan).
      * Maknanya: "Digerakkan, dikendalikan, atau bereaksi terhadap *peristiwa*."
  * **Konteks Teknis (Technical Context):** Ini adalah arsitektur perangkat lunak (lawan dari *polling*). Sistem berada dalam mode "mendengarkan" (listening) yang pasif dan **hanya bereaksi** ketika sebuah *event* (peristiwa) atau *sinyal* (misal: "pengguna mengklik mouse", "workspace berubah") dikirimkan kepadanya. Ini **sangat efisien**.
  * **Penggunaan Profesional (Professional Interaction):**
      * *"Modern UI frameworks like Flutter are **event-driven**; they rebuild the UI in response to state changes or user input."*
      * (Kerangka kerja UI modern seperti Flutter bersifat **event-driven**; mereka membangun ulang UI sebagai respons terhadap perubahan status atau input pengguna.)
      * *"Instead of **polling** the database, we use an **event-driven** approach with a message queue."*
      * (Daripada **melakukan polling** ke database, kami menggunakan pendekatan **event-driven** dengan antrian pesan.)
  * **Penggunaan Percakapan (Conversational Interaction):**
      * (Jarang, tetapi konsepnya ada.) *"A firefighter's job is **event-driven**; they wait for an alarm (the *event*) before taking action."*
      * (Pekerjaan pemadam kebakaran itu **digerakkan oleh peristiwa**; mereka menunggu alarm (*event*) sebelum bertindak.)

-----

#### 5.9 Hubungan ke Tahap Berikutnya

Kita telah berhasil menguasai **aturan umum** yang berlaku untuk *hampir semua* modul (Definisi, `format`, `interval`, `on-click`). Kita sekarang memiliki semua pengetahuan konseptual yang kita perlukan.

Langkah selanjutnya adalah mengambil "kerangka" (layout) yang kita buat di Tahap 4 (misal: `["sway/workspaces", "clock", "cpu", "memory"]`) dan melakukan *deep-dive* (penyelaman mendalam) pada **setiap modul spesifik tersebut**, satu per satu.

Kita akan menerapkan aturan umum dari Tahap 5 ini untuk mengonfigurasi `sway/workspaces` secara detail, lalu `clock`, lalu `cpu`, dan seterusnya, sambil mempelajari *placeholder* dan properti *khusus* milik mereka masing-masing.

-----

Ini adalah akhir dari Bagian 5. Kita telah menyelesaikan semua *konsep* konfigurasi.

**Apakah Anda siap untuk mulai menerapkan pengetahuan ini dan melakukan *deep-dive* pada modul spesifik pertama kita, dimulai dengan yang paling penting untuk lingkungan Anda: `sway/workspaces`?**
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[selanjutnya]: ../bagian-6/README.md
-->
> - **[Sebelumnya][sebelumnya]**
[sebelumnya]: ../bagian-4/README.md

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
