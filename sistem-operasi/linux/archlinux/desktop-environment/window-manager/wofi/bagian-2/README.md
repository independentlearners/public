
<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#-->
# Modul 2 — Sintaks & Penulisan Konfigurasi Wofi (penjelasan **kata-per-kata**) lalu contoh konfigurasi terperinci

Bagus — sebelum langsung mengubah file, kita akan uraikan **semua aturan penulisan** konfigurasi wofi dengan detil kata-per-kata (format, tipe nilai, komentar, escaping, aturan mode-spesifik, precedence CLI vs config, dan CSS theming). Setelah bagian sintaks selesai, saya sertakan contoh `~/.config/wofi/config` dan `style.css` lengkap — setiap baris akan dijelaskan satu-per-satu seperti yang Anda minta. Semua pernyataan teknis penting disertai rujukan dokumentasi resmi. ([Man Arch Linux][1])

---

## 1) Ringkasan singkat tentang file yang relevan (lokasi & fungsi)

* `~/.config/wofi/config` — file konfigurasi utama (opsional). Berisi pasangan *key=value* (snake_case). ([Man Arch Linux][1])
* `~/.config/wofi/style.css` — file CSS untuk theming tampilan wofi (opsional). Wofi memakai styling berbasis GTK/CSS. ([Cloud Ninja][2])
* `XDG_CACHE_HOME/wal/colors` — file warna opsional (pywal integration). ([Man Arch Linux][3])
* Prioritas: **argumen CLI > file config > nilai default internal**. (argument command-line menimpa config). ([Man Arch Linux][1])

---

##  2) Format umum konfigurasi — **aturan dasar** (kata-per-kata)

Dasar: file berisi baris *key=value*, satu pasangan per baris.
Format ringkas:

```
snake_case_key=value
```

Penjelasan kata-per-kata:

* `snake_case_key` — nama opsi ditulis dengan huruf kecil dan underscore (`_`) untuk memisahkan kata. Contoh: `hide_scroll`, `matching`, `insensitive`. (Ini konsisten dengan flag CLI yang diubah ke snake_case di config). ([ManKier][4])
* `=` — tanda sama dengan, pemisah antara *key* dan *value*. Harus ada tepat satu `=` yang memisahkan nama opsi dari nilainya untuk baris tersebut.
* `value` — nilai opsi; tipe nilainya tergantung opsi (boolean `true/false`, integer, string/path, enum seperti `contains|fuzzy|multi-contains`, atau daftar mode dipisah koma). Contoh: `hide_scroll=true`, `lines=10`, `style=/home/poweruser/.config/wofi/style.css`. ([ManKier][4])

Aturan spasi:

* Biasanya spasi sebelum/ sesudah `=` **tidak diperlukan**; sebagian besar parser menerima `key = value` tetapi praktik terbaik adalah tulis tanpa spasi: `key=value`. (man page menyarankan pasangan sederhana; gunakan format konsisten). ([Man Arch Linux][1])

Tipe nilai umum:

* **Boolean** — `true` atau `false` (semua huruf kecil). Contoh: `insensitive=true`.
* **Integer** — angka desimal tanpa tanda: `lines=8`.
* **String / Path** — path absolut relatif ke home kita: `style=/home/poweruser/.config/wofi/style.css`. Tidak perlu tanda kutip kecuali path mengandung `#` atau karakter spesial — lihat aturan escaping.
* **Enum / Keyword** — opsi yang menerima daftar pilihan: `matching=contains` atau `matching=fuzzy`.
* **List (mode list)** — ketika menerima beberapa mode, pisahkan dengan koma tanpa spasi: `show=run,drun,dmenu`. Untuk pemanggilan CLI juga bisa `--show run,drun`. ([Man Arch Linux][5])

---

##  3) Komentar & escaping — (lihat ini bagus untuk dokumentasi inline)

* **Komentar**: segala sesuatu **setelah tanda `#`** pada sebuah baris dianggap komentar dan diabaikan. Jadi:

  ```
  hide_scroll=true   # sembunyikan scrollbar
  ```

  akan mem-parsing `hide_scroll=true` dan sisanya komentar. ([Man Arch Linux][1])

* **Jika Anda perlu menggunakan `#` sebagai bagian dari nilai**, prefix `#` dengan backslash `\#`. Tetapi per man page: “Anything following a `#` is considered comment unless the `#` is prefixed with a `\`.” Selain itu backslash harus di-escape sendiri. Jadi untuk menulis literal `\` atau literal `#` mungkin perlu `\\` atau `\#`. Contoh:

  ```
  example=some\#value
  path_with_backslash=C:\\\\path\\to\\file
  ```

  (prinsip: backslash memerlukan perhatian—jika pakai banyak backslash, test dulu). ([Man Arch Linux][1])

---

##  4) Mode-spesifik option (format khusus)

Beberapa opsi hanya berlaku untuk mode tertentu (mis. `dmenu`, `drun`, `run`). **Penulisan di file config** menggunakan pola:

```
<mode>-<option_name>=<value>
```

Contoh:

```
dmenu-parse_action=true
```

Penjelasan kata-per-kata:

* `<mode>` — nama mode (dmenu, drun, run).
* `-` — tanda minus sebagai pemisah antara nama mode dan nama opsi mode-spesifik.
* `<option_name>` — nama opsi yang spesifik untuk mode itu (contoh `parse_action`).
* `=` dan `<value>` seperti biasa. ([ManKier][4])

Catatan: Anda dapat menggabungkan beberapa mode di CLI (mis. `--show run,drun`) dan mode akan dimuat sesuai urutan; masing-masing mode hanya boleh dimuat satu kali. ([Man Arch Linux][5])

---

##  5) Pengaturan lewat CLI setara / define dari baris perintah

* Anda bisa menetapkan opsi config langsung saat menjalankan wofi menggunakan `-D`/`--define KEY=VALUE` atau menggunakan flag CLI yang setara. Ini berguna untuk skrip. Contoh:

```
wofi -Dhide_scroll=true --show drun
```

Penjelasan: `-D` beri definisi sementara yang menimpa config pada proses berjalan. Pilihan CLI memiliki prioritas tertinggi. ([Man Arch Linux][3])

---

##  6) Opsi penting yang sering dipakai — ringkasan (kata-per-kata)

Saya tampilkan opsi yang sering Anda butuhkan; tiap opsi disertai arti singkat dan contoh penggunaan di config + CLI. Semua diambil dari man page/ dokumentasi. ([Man Arch Linux][3])

* `style=PATH`

  * arti: path ke file CSS yang dipakai.
  * contoh config: `style=/home/poweruser/.config/wofi/style.css`
  * CLI: `--style /path/to/style.css`. ([Manpages Ubuntu][6])

* `conf=PATH` atau CLI `-c/--conf=PATH`

  * arti: gunakan config file selain default.
  * contoh: `wofi --conf /home/poweruser/.config/wofi/myconf`. ([Man Arch Linux][3])

* `show=MODE[,MODE...]` atau CLI `--show`

  * arti: mode yang akan ditampilkan (mis. `drun`, `run`, `dmenu`). Pisahkan koma tanpa spasi.
  * contoh: `show=drun` atau `wofi --show run,drun`. ([Man Arch Linux][5])

* `dmenu-parse_action=BOOL` (contoh mode-specific)

  * arti: opsi mode `dmenu` untuk parse action. `true/false`. ([ManKier][4])

* `lines=NUMBER` atau `-L, --lines`

  * arti: tinggi jendela dalam jumlah baris (bukan pixel).
  * contoh: `lines=8` atau `wofi --lines 8`. ([Man Arch Linux][3])

* `columns=NUMBER` atau `-w, --columns`

  * arti: jumlah kolom item yang ditampilkan. Default 1.
  * contoh: `columns=2`. ([Man Arch Linux][3])

* `hide_scroll=BOOL`

  * arti: sembunyikan scrollbar (tetap bisa scroll jika CSS/behavior mendukung).
  * contoh: `hide_scroll=true`. ([ManKier][4])

* `insensitive=BOOL`

  * arti: pencarian case-insensitive jika `true`.
  * contoh: `insensitive=true`. ([ManKier][4])

* `allow_markup` / CLI `--allow-markup`

  * arti: izinkan Pango markup pada entri (bisa menambah formatting seperti `<b>`, `<i>`). Hati-hati jika input berasal dari sumber tak tepercaya. ([Linux Command Library][7])

* `fork` / `-f, --fork`

  * arti: jalankan wofi dan forking ke background sehingga terminal yang memanggil bisa ditutup. ([Linux Command Library][7])

* `term` / `-t, --term`

  * arti: perintah terminal yang dipakai saat membuka terminal dari mode `run`. Contoh: `term=alacritty -e`. ([Linux Command Library][7])

* `gtk-dark` / `--gtk-dark`

  * arti: paksa style GTK ke tema gelap. ([Man Arch Linux][3])

Catatan: daftar lengkap ada di manual (man pages); di sini saya tampilkan yang paling sering berguna untuk workflow di Sway. ([Man Arch Linux][3])

---

##  7) Theming CSS — struktur selector & properti yang penting (kata-per-kata)

Wofi memakai CSS/GTK selectors — beberapa selector umum yang sering dipakai (nama selector dapat berbeda antar versi, tapi umumnya tersedia yang berikut):

* `window` — container jendela wofi (seluruh area).
* `#outer-box` — kotak luar (wrapper).
* `#inner-box` — area yang menampilkan daftar entry.
* `#input` — area input / search box.
* `#entry` — tiap baris/entry pada daftar.
* `#text` — teks judul entry.
* `#img` — gambar/icon entri.
* `#scroll` — scrollbar area.
  Contoh CSS ringkas:

```css
window {
  margin: 8px;           /* jarak luar jendela */
  border-radius: 8px;    /* sudut membulat */
  background-color: rgba(20,20,20,0.9);
}

#input {
  padding: 6px;          /* jarak dalam input */
  font-size: 16px;
}

#entry {
  padding: 4px 8px;      /* jarak tiap entry: vertikal 4px, horizontal 8px */
}

#img {
  width: 24px;
  height: 24px;
}
```

Penjelasan kata-per-kata property umum:

* `margin` — ruang di luar box (jarak ke elemen lain).
* `padding` — ruang di dalam box (jarak isi ke border).
* `border-radius` — sudut membulat.
* `background-color` — warna latar; dapat menggunakan `rgba()` untuk transparansi.
* `font-size` — ukuran font.
* `width/height` — ukuran elemen (ikon).
  Sumber contoh selector: dokumentasi theming wofi dan koleksi tema. ([Cloud Ninja][2])

Catatan: CSS di wofi mirip CSS GTK — beberapa property CSS standar GTK berfungsi; uji perubahan dan reload wofi untuk melihat efek.

---

##  8) Contoh `~/.config/wofi/config` lengkap — **setiap baris dijelaskan kata-per-kata**

Berikut contoh file config yang aman sebagai starting point. Setelah itu saya jelaskan tiap baris.

```ini
# ~/.config/wofi/config
# Basic behaviour
show=drun
style=/home/poweruser/.config/wofi/style.css
conf=/home/poweruser/.config/wofi/config

# Appearance
lines=10
columns=1
hide_scroll=true
gtk_dark=false

# Search behavior
insensitive=true
matching=contains

# dmenu mode specific
dmenu-parse_action=true

# Markdown / markup
allow_markup=false
```

Penjelasan baris per baris (kata-per-kata):

* `# ~/.config/wofi/config`

  * komentar: judul file supaya mudah identifikasi.

* `# Basic behaviour`

  * komentar pemisah.

* `show=drun`

  * `show` = nama opsi; `=` pemisah; `drun` = nilai.
  * arti lengkap: jalankan wofi di mode `drun` (tampilkan aplikasi dari `.desktop` entries). Anda bisa mengganti `drun` menjadi `run` atau `dmenu` atau `run,drun` jika ingin beberapa mode. ([Man Arch Linux][5])

* `style=/home/poweruser/.config/wofi/style.css`

  * `style` = nama opsi; nilai adalah path absolut ke file CSS. Menentukan file ini menimpa default style. Pastikan path benar dan file terbaca. ([Manpages Ubuntu][6])

* `conf=/home/poweruser/.config/wofi/config`

  * eksplisit memberi tahu wofi path config. Biasanya tidak perlu (karena ini adalah file default), tapi berguna kalau menjalankan wofi dengan config lain.

* `# Appearance`

  * komentar bagian tampilan.

* `lines=10`

  * `lines` = tinggi tampilan dalam baris; `10` = nilai integer. Ini mengatur berapa banyak baris yang terlihat tanpa scroll. ([Man Arch Linux][3])

* `columns=1`

  * `columns` = jumlah kolom; `1` = nilai integer. Jika `2`, entri akan ditata 2 kolom. ([Man Arch Linux][3])

* `hide_scroll=true`

  * sembunyikan scrollbar (boolean). Perhatikan: Anda mungkin masih bisa scrolling; CSS dapat mengatur perilaku tampilan lebih lanjut. ([ManKier][4])

* `gtk_dark=false`

  * jangan paksa mode GTK gelap. Bisa diganti `true` jika ingin GTK dark.

* `# Search behavior`

  * komentar.

* `insensitive=true`

  * pencarian case-insensitive (`true` berarti “abaikan huruf besar/kecil”). ([ManKier][4])

* `matching=contains`

  * `matching` = mode pencocokan; `contains` berarti cocok bila query muncul di bagian nama entry. Alternatif: `fuzzy`, `multi-contains`. ([ManKier][4])

* `# dmenu mode specific`

  * komentar untuk opsi mode-spesifik.

* `dmenu-parse_action=true`

  * `dmenu-parse_action` adalah opsi khusus untuk mode `dmenu`; `true` mengaktifkannya. Format `mode-option=value` sesuai aturan mode-spesifik. ([ManKier][4])

* `# Markdown / markup`

  * komentar

* `allow_markup=false`

  * jangan izinkan Pango markup pada entri (keamanan & stabilitas). Jika Anda ingin format kaya, ubah ke `true` (tapi hati-hati terhadap input tak tepercaya). ([Linux Command Library][7])

---

##  9) Contoh `style.css` terperinci — setiap aturan dijelaskan

File: `~/.config/wofi/style.css`

```css
/* style.css contoh untuk wofi */
window {
  margin: 8px;                 /* jarak luar jendela */
  border-radius: 12px;         /* sudut membulat */
  background-color: rgba(18,18,18,0.85); /* latar semi-transparan */
  min-width: 400px;            /* lebar minimal jendela */
}

#input {
  padding: 8px;                /* jarak dalam input */
  font-size: 15px;             /* ukuran huruf input */
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

#inner-box {
  padding: 6px;                /* jarak di sekitar daftar entry */
}

#entry {
  padding: 6px 10px;           /* padding vertikal dan horizontal */
  border-radius: 6px;          /* sedikit rounding tiap entry */
}

#entry:selected {
  background-color: rgba(100, 100, 100, 0.12); /* highlight saat seleksi */
}

#img {
  width: 20px;
  height: 20px;
  margin-right: 8px;           /* jarak antara icon dan text */
}

#text {
  font-size: 14px;
}
```

Penjelasan kilas kata-per-kata:

* `window { ... }` — selector untuk keseluruhan jendela wofi. Semua property di dalam memengaruhi tampilan dasar.
* `margin: 8px;` — beri jarak 8px di luar container.
* `border-radius: 12px;` — sudut membulat 12px.
* `background-color: rgba(18,18,18,0.85);` — warna latar pakai `rgba(red,green,blue,alpha)`; alpha <1 membuat transparansi.
* `min-width: 400px;` — ukuran minimal lebar; berguna untuk mencegah layout terlalu sempit.
* `#input { ... }` — area input/search. `padding` membuat ruang internal; `font-size` mengatur ukuran teks.
* `#entry:selected { ... }` — pseudo-state untuk entry yang dipilih (serupa :hover / selected).
* `#img` & `#text` — mengatur ukuran ikon dan teks pada tiap entry.

Sumber selector/property: dokumentasi theming wofi dan contoh tema. ([Cloud Ninja][2])

---

##  10) Checklist praktek sebelum Anda mengedit file (kesalahan umum)

* Pastikan folder `~/.config/wofi/` ada dan file `config` / `style.css` dapat dibaca oleh user.
* Gunakan path absolut di config untuk menghindari masalah PATH saat dipanggil dari sway.
* Jika mengubah style, jalankan `wofi --show drun` dari terminal untuk melihat pesan error (redirect stderr ke file bila perlu). ([GitHub][8])
* Saat menulis komentar atau memasukkan `#` dalam nilai, ingat aturan escaping. ([Man Arch Linux][1])

---

##  11) Referensi ringkas (bahan bacaan lanjutan)

* Manual page wofi (config & opsi). ([Man Arch Linux][1])
* Dokumen theming & contoh CSS. ([Cloud Ninja][2])
* Contoh penggunaan mode & kombinasi `--show`. ([Man Arch Linux][5])

---
<!--
Kalau Anda setuju, langkah berikutnya saya akan **terapkan contoh konfigurasi nyata** (salin-tempel) dan menjelaskan **setiap argumen/opsi klinis** pada baris `bindsym` Sway atau skrip pemanggil (mis. script power menu dengan pipe) — **kata-per-kata** untuk setiap command dan argumennya, lalu latihan debugging. Saya akan langsung keluarkan file contoh siap pakai dan langkah verifikasi.

Katakan "lanjut konfigurasi praktis" dan saya kerjakan seluruh file konfigurasi + skrip integrasi ke Sway (dijelaskan per-baris).
Baik, kita masuk **Modul 2 — Sintaks & Struktur Dasar Config Wofi**.
Ini modul yang sangat fundamental: kita mempelajari *bahasa* yang dipakai Wofi dulu sebelum mulai menulis konfigurasi nyata. Semua detail sintaks akan dibongkar kata-per-kata agar nanti Anda bisa membaca setiap baris config seperti membaca Bahasa Indonesia sendiri.


-->
[0]: ../
[1]: https://man.archlinux.org/man/wofi.5.en?utm_source=chatgpt.com "wofi(5) - Arch manual pages"
[2]: https://cloudninja.pw/docs/wofi.html?utm_source=chatgpt.com "Wofi"
[3]: https://man.archlinux.org/man/wofi.1.en?utm_source=chatgpt.com "wofi(1) - Arch manual pages"
[4]: https://www.mankier.com/5/wofi?utm_source=chatgpt.com "wofi: configuration file and styling | Man Page | File Formats"
[5]: https://man.archlinux.org/man/wofi.7.en?utm_source=chatgpt.com "wofi(7) - Arch manual pages"
[6]: https://manpages.ubuntu.com/manpages/jammy/man5/wofi.5.html?utm_source=chatgpt.com "wofi - configuration file and styling"
[7]: https://linuxcommandlibrary.com/man/wofi?utm_source=chatgpt.com "wofi man"
[8]: https://github.com/szaffarano/wofi-power-menu?utm_source=chatgpt.com "szaffarano/wofi-power-menu"
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

---

# **Sintaks Config Wofi (Konsep Penulisan, Struktur, Hierarki Opsi)**

*(Sebelum membuat config nyata)*

---

## **Bagian A — Prinsip umum: wofi memakai format *key = value* sederhana**

Wofi **tidak** memakai JSON, YAML, TOML, atau INI lengkap.
Formatnya adalah:

```
nama_opsi=nilai
```

atau

```
nama_opsi: nilai
```

Format ini diterima *keduanya*, tetapi gaya utama yang muncul di dokumentasi adalah bentuk memakai **=**.

### Penjelasan kata-per-kata:

* **nama_opsi**
  Ini adalah identifier, yaitu nama sebuah properti internal yang dipahami Wofi.
  Semua nama opsi memakai **snake_case** (huruf kecil + underscore).
  Contoh: `prompt`, `width`, `height`, `no_actions`, `allow_images`, `normal_window`.

* **=**
  Operator assignment. Artinya: “setel properti ini menjadi nilai berikut”.

* **nilai**
  Bisa berupa:

  * angka (mis. `width=600`)
  * teks/string (mis. `prompt=Jalankan:`)
  * boolean (mis. `no_actions=true`)
  * nama mode (mis. `show=drun`)
  * enumerasi tertentu
  * path file

* **Tidak ada tanda kutip wajib**
  Anda hanya menulis teks langsung:

  ```
  prompt=Jalankan aplikasi
  ```

  Jika ada spasi, tetap tidak perlu kutip. Wofi membaca seluruh setelah tanda `=` sebagai nilai.

---

## **Bagian B — Hal-hal penting tentang parsing file config**

1. **Whitespace tidak penting**
   Spasi sebelum/ sesudah tanda `=` diabaikan. Ini valid:

   ```
   prompt = Cari app
   ```

2. **Tidak ada section seperti `[General]`**
   Berbeda dari INI. Semua opsi berada di satu namespace global.

3. **Komentar diawali tanda pagar `#`**
   Segala teks setelah `#` sampai akhir baris diabaikan.

   Contoh:

   ```
   prompt=Menu utama  # ini komentar
   ```

4. **Prioritas nilai (urutan penting)**
   Wofi memproses nilai dalam urutan berikut:

   ```
   Argumen CLI > File config > Default internal
   ```

   Artinya: opsi pada command line (*mis. `wofi --width 600`*) **menggantikan** apa pun yang ada di file config.

5. **Jika opsi tidak dikenal**
   Wofi akan mengabaikannya tanpa error fatal.
   Ini penting untuk debugging: jika ada salah eja, Wofi **tidak akan memberi tahu**, hanya diam-diam mengabaikan.

---

## **Bagian C — Struktur umum file config Wofi**

File Anda nantinya akan berada di:

```
~/.config/wofi/config
```

Struktur tipikal:

```
# Mode default untuk wofi ketika tidak diberi argumen
show=drun

# Ukuran jendela
width=600
height=300

# Prompt teks
prompt=Run:

# Perilaku
normal_window=true
allow_images=true
```

Setiap baris selalu satu opsi. Tidak ada nested block.

---

## **Bagian D — Sintaks opsi via Command Line (CLI)**

Wofi memiliki dua cara konfigurasi:

1. **via file config**
2. **via argumen CLI** (yang selalu override config)

Bentuk CLI mengikuti pola:

```
wofi --nama-opsi nilai
```

Contoh:

```
wofi --show drun
```

Penjelasan kata-per-kata:

* `--show` → nama opsi
* `drun` → nilai
* Spasi digunakan untuk memisahkan opsi dan nilai, bukan tanda `=`.

Beberapa opsi adalah *flag* (boolean).
Contoh:

```
wofi --normal-window
```

Flag ini setara dengan:

```
normal_window=true
```

di file config.

---

## **Bagian E — Bagaimana Wofi membaca style.css**

`style.css` *tidak mengikuti format config* tetapi sepenuhnya mengadopsi **CSS GTK**.

Struktur CSS Wofi:

* Wofi secara internal memiliki ID dan kelas GTK tertentu.
* Tema bekerja dengan selector seperti:

```
window {
    background-color: #1e1e1e;
}

entry {
    padding: 5px;
}

listview row:selected {
    background-color: #444;
}
```

*Karena ini CSS GTK, bukan CSS browser,* beberapa properti berbeda.
Nanti kita buat modul khusus mengenai CSS Wofi (Modul 3).

---

## **Bagian F — Konsep hierarki opsi (logika internal)**

Wofi membagi opsi dalam dua kelompok besar:

### 1. **Opsi tampilan dan jendela (Window/UI)**

Mengatur bentuk window, lebar, tinggi, padding, prompt, alignment.

### 2. **Opsi perilaku & mode operasi**

Mengatur bagaimana wofi bekerja:

* mode (“run”, “drun”, “dmenu”)
* pencarian fuzzy
* perintah fallback
* filtering
* jumlah hasil
* apakah history disimpan
* path icon
* mode dmenu via stdin

Dalam modul 2 ini kita baru membongkar sintaks & konsep penulisan opsinya.

---

## **Bagian G — Perbedaan penting antara tiga mode Wofi**

Wofi memiliki 3 mode inti, dan ini akan mempengaruhi *set opsi* yang relevan.

### **1) Mode “drun”**

Membaca menu dari `.desktop` (XDG Desktop Entry).
Ini yang digunakan sebagai launcher aplikasi grafis.

### **2) Mode “run”**

Membaca PATH dan menjalankan perintah shell.
Secara teknis ia tidak memanggil shell secara langsung; ia mengeksekusi perintah seperti launcher.

### **3) Mode “dmenu”**

Membaca dari stdin.
Jika Anda membuat piped menu, mode ini yang dipakai.

Kita nanti akan membahas opsinya satu-per-satu di **Modul 2B**.

---

## **Bagian H — Terminologi penting dalam Wofi (harus dikuasai sebelum lanjut)**

Sebelum masuk konfigurasi lengkap, pahami istilah berikut:

* **Entry**
  Input box tempat Anda mengetik.

* **Row**
  Setiap item hasil pencarian, baik aplikasi maupun teks dalam mode dmenu.

* **Listview / list**
  Container daftar hasil.

* **Prompt**
  Label di sebelah kiri input box.

* **Action**
  Fitur Wofi untuk memunculkan menu tindakan (ikon kanan). Bisa dimatikan dengan `no_actions=true`.

* **Icons**
  Icon aplikasi pada mode drun. Path icon mengikuti standar XDG icon theme.

* **Re-filtering / live filtering**
  Cara Wofi menyaring hasil setiap kali Anda mengetik.

* **Word match / fuzzy match**
  Mode pencarian. (Beberapa versi wofi mengubah defaultnya, kita bahas detail nanti).

Semua ini akan muncul dalam opsi konfigurasi.

---

## **Bagian I — Bagian paling penting dari Modul 2: Cara membaca dan menulis config Wofi secara benar**

Ini inti modul.

### **1. Semua opsi = satu baris = satu assignment**

Tidak ada nested sections.

### **2. Tidak ada koma, bracket, atau tanda petik wajib**

Ini bukan JSON/YAML.

### **3. Anda bisa menulis opsinya dalam urutan apa pun**

Urutan tidak mempengaruhi parsing.

### **4. Jika salah tulis nama opsi**

Wofi tidak error, hanya diabaikan → debugging harus manual.

### **5. Jika Anda kombinasi CLI dan config**

Argumen CLI menang.

### **6. Jika ada dua file config**

Wofi hanya membaca *satu*, yaitu:

```
$XDG_CONFIG_HOME/wofi/config
```

Jika environment variable tidak ada, berarti:

```
~/.config/wofi/config
```

---

## **Bagian J — Tugas praktik Modul 2**

Sebelum lanjut ke opsi lengkap, lakukan latihan berikut (sangat penting).

---

### **Tugas 1 — Buat file config minimal dan uji parsing**

Buat file:

```
mkdir -p ~/.config/wofi
nano ~/.config/wofi/config
```

Isi:

```
prompt=Test prompt
width=500
height=200
```

Jalankan:

```
wofi 2> /tmp/wofi.cfgtest
```

Periksa apakah ada error parsing:

```
cat /tmp/wofi.cfgtest
```

(Jika kosong berarti parsing OK.)

---

### **Tugas 2 — Salah-sengaja menulis opsi dan lihat efeknya**

Ubah:

```
widt=500
```

Jalankan kembali.
Anda akan lihat **wofi tetap berjalan** tetapi lebar default digunakan.

Ini latihan penting memahami bahwa wofi tidak memunculkan error untuk opsi yang tidak dikenali.

---

### **Tugas 3 — Tes override CLI**

Isi config:

```
width=300
height=100
```

Jalankan:

```
wofi --width 800 --height 600
```

Window akan memakai nilai dari CLI, bukan config.

---

## **Bagian K — Checklist Kompetensi Modul 2**

Setelah modul ini Anda harus bisa:

* [ ] Menjelaskan bentuk sintaks wofi (key=value).
* [ ] Menulis opsi sederhana dan mengetahui bahwa Wofi tidak memakai tanda kutip.
* [ ] Memahami cara kerja komentar `#`.
* [ ] Memahami bahwa CLI override config.
* [ ] Mengetahui bahwa opsi salah-eja tidak error.
* [ ] Mengerti konsep entry, row, prompt, listview.
* [ ] Mengerti tiga mode wofi dan pengaruhnya.
* [ ] Menguji parsing file config dengan redirect stderr.

Jika semuanya sudah aman dan Anda siap masuk ke bagian paling besar:

---

# **Modul 2B — Detail seluruh opsi konfigurasi Wofi, penjelasan kata-per-kata, ilustrasi, contoh, debugging, dan rekomendasi Sway**

Ini modul yang sangat besar.
Akan mencakup:

* Semua opsi window/layout (width, height, location, padding, halignment, valignment, image support, fixed height/width behaviour)
* Semua opsi input/filter/pencarian
* Semua opsi mode drun/run/dmenu
* Semua opsi perilaku UI
* Semua perbedaan antar versi Wofi
* Debugging common misconfiguration
* Contoh file config lengkap
* Penjelasan kata-per-kata untuk **setiap** baris
<!--
Jika Anda siap lanjut, cukup jawab:

**"lanjut Modul 2B"**

Setelah itu saya buka seluruh daftar opsi lengkap satu per satu, sangat rinci, sampai Anda bisa menguasai wofi seperti developer internalnya.

Baik, kita lanjut ke **Modul 2 — Bagian B: Sintaks Lengkap, Anatomi, dan Cara Kerja File Konfigurasi Wofi**.
Ini bagian yang sangat teknis, jadi anggap ini seperti membedah organisme kecil bernama *wofi.conf* dan *style.css* hingga setiap sel-selnya terlihat jelas.

-->
---

## **MODUL 2 — BAGIAN B

Anatomi Sintaks Wofi (wofi.conf & style.css) — Dijelaskan Kata-per-Kata**

Sebelum menyentuh konfigurasi, peserta harus memahami logika internal yang dipatuhi Wofi. Ibarat belajar sihir, kamu harus tahu dulu grammarnya sebelum merapal mantra.

---

# **1. STRUKTUR DASAR KONFIGURASI WOFI**

Wofi memiliki dua jenis berkas konfigurasi:

### 1) **wofi.conf**

Berisi *opsi perilaku* (behavior) dan *logika internal program*.

Formatnya sederhana:

```
kunci = nilai
```

Tidak ada array, tidak ada nested object, tidak ada JSON. Hanya key-value.

---

### 2) **style.css**

Berisi styling seperti tema GTK/CSS yang mengatur tampilan antarmuka: warna, padding, radius, font, dsb.
Format: CSS murni.

---

# **2. SEMUA OPSI DI wofi.conf

(DIBEDAH SATU PER SATU, KATA PER KATA)**

Di bawah ini seluruh opsi penting dalam wofi.conf, dijelaskan detail makna per kata dan efeknya.

---

## **2.1. `mode=`**

Contoh:

```
mode = drun
```

Pembagian kata-per-kata:

* **mode** → kunci yang memberi tahu Wofi: “Jenis launcher apa yang harus aku jalankan?”
* **=** → operator penugasan; memberi nilai pada kunci.
* **drun** → mode untuk memunculkan desktop entries (.desktop files) dalam sistem.

Mode lain:

* **run** → mode menjalankan aplikasi via PATH
* **dmenu** → kompatibel dengan dmenu (mode text list)
* **ssh** → daftar host SSH
* **window** → switcher antar-window

Makna teknis:
Mode menentukan *backend* internal Wofi yang diambil dari modul penyedia data.

---

## **2.2. `prompt=`**

```
prompt = Cari:
```

* **prompt** → teks petunjuk dalam input bar
* **Cari:** → string literal yg ditampilkan apa adanya

Efek: muncul di field input di UI.

---

## **2.3. `normal_window=`**

```
normal_window = true
```

* **normal_window** → apakah jendela Wofi muncul sebagai “window normal” atau overlay.
* **true/false** → nilai boolean.

*true* membuat Wofi behave seperti aplikasi biasa; *false* membuatnya jadi panel overlay seperti dmenu.

---

## **2.4. `width=` dan `height=`**

```
width = 800
height = 400
```

* **width/height** → ukuran window Wofi dalam satuan pixel.
* **800** → integer; bukan %, bukan auto.

Jika tidak ditentukan, Wofi menyesuaikan berdasarkan konten.

---

## **2.5. `lines=`**

```
lines = 10
```

* **lines** → jumlah item yang ditampilkan
* **10** → integer jumlah baris

Wofi akan membuat UI tinggi sesuai jumlah item.

---

## **2.6. `location=`**

```
location = center
```

Nilai yang valid:

* center
* top-left
* top
* top-right
* left
* right
* bottom-left
* bottom
* bottom-right

Arti:

* **location** → memerintahkan posisi window di layar
* **center** → posisikan tepat di tengah monitor aktif (monitor di mana fokus keyboard berada)

---

## **2.7. `key_bindings=`**

Contoh umum:

```
key_up = Up
key_down = Down
```

Makna kata-per-kata:

* **key_up** → aksi internal: memilih item di atas
* **Up** → nama tombol di keyboard (mengikuti penamaaan XKB)

Binding lain yang umum:

```
key_left = Left
key_right = Right
key_accept = Return
key_exit = Escape
```

---

## **2.8. `allow_markup=`**

```
allow_markup = true
```

* **allow_markup** → apakah item boleh pakai markup Pango
* **true** → izinkan font bold/italic warna dsb dalam hasil

Markup mengikuti format Pango, bukan HTML.

---

## **2.9. `cache=`**

```
cache = true
```

Menentukan apakah Wofi menyimpan hasil input terakhir agar lebih cepat startup.

---

## **2.10. `insensitive=`**

```
insensitive = false
```

* **insensitive** → apakah pencarian *case-insensitive*
* **false** → case-sensitive

Set ke true untuk pencarian lebih ramah.

---

## **2.11. `hide_scrollbar=`**

```
hide_scrollbar = true
```

Menghilangkan scrollbar dari UI.

---

## **2.12. `image_size=`**

```
image_size = 32
```

Jika item punya icon (e.g. drun mode), ikon akan di-resize ke 32px.

---

# **3. SINTAKS style.css (DIBEDAH KATA-PER-KATA)**

Mari bedah contoh tema sederhana:

```
window {
    background-color: #1e1e1e;
}

#input {
    border-radius: 6px;
    padding: 6px;
    background-color: #2d2d2d;
    color: white;
}

#entry:selected {
    background-color: #4c4c4c;
}
```

Penjelasan:

---

## **3.1. Selector: `window`**

* **window** → selector elemen root UI Wofi.
  Ini sama seperti `<body>` di HTML.

---

## **3.2. Property: `background-color:`**

* **background-color** → warna latar.
* **#1e1e1e** → warna hex RGB.

---

## **3.3. Selector: `#input`**

* **#input** → ID CSS. Wofi mendefinisikan elemen input dengan id “input”.

Property penting:

* **border-radius** → lengkungan sudut
* **padding** → jarak isi terhadap tepi
* **color** → warna teks

---

## **3.4. Selector: `#entry:selected`**

* **#entry** → tiap entri dalam list
* **:selected** → pseudo-class yang aktif saat item dipilih

Property umum:

* background-color
* color
* padding
* font-weight

---

# **4. SUMBER BANTUAN RESMI UNTUK SINTAKS**

Agar kamu bisa memvalidasi dan mendalami lebih lanjut:

* Dokumentasi Wofi resmi:
  [https://hg.sr.ht/~scoopta/wofi/tree/default/docs](https://hg.sr.ht/~scoopta/wofi/tree/default/docs)
* GTK CSS Reference (Wofi memakai GTK layer):
  [https://docs.gtk.org](https://docs.gtk.org)
* Sway Wiki:
  [https://github.com/swaywm/sway/wiki](https://github.com/swaywm/sway/wiki)
* lalulintas bantuan CLI seperti:

```
wofi --help
```

dan

```
man wofi
```

---

# **5. SEBELUM LANJUT KE BAGIAN C**

Bagian berikutnya baru kita siapkan:

**Modul 2 — Bagian C: Pengelolaan Template, Variabel, dan Pembuatan File wofi.conf + style.css yang Saling Bersinergi dengan Sway.**

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

