# [Modul 2: Bedah Sintaks dan Anatomi Konfigurasi][0]

Di Linux, "Power" ada pada file teks. Jika Anda bisa menguasai file konfigurasi, Anda menguasai aplikasinya.

-----

Secara bawaan, Wofi mungkin terlihat polos dan fungsinya standar. Kita akan mengubahnya. Wofi mencari konfigurasi di direktori standar XDG, yaitu `~/.config/wofi/`. Biasanya direktori ini belum ada, jadi kita harus membuatnya.

Ada dua file utama yang perlu Anda pahami:

1.  **`config`**: Mengatur perilaku (*behavior*), parameter, dan logika.
2.  **`style.css`**: Mengatur tampilan (*appearance*), warna, dan estetika.

### 1\. Identitas dan Konsep Teknis (Technical Deep Dive)

#### **A. The Config File (Logic)**

Format file ini mirip dengan file `.ini` standar tetapi sedikit lebih longgar.

  * **Sintaks Dasar:** `key=value`
  * **Boolean:** Jika sebuah fitur hanya perlu dinyalakan, cukup tulis kuncinya atau `key=true`.
  * **Lokasi:** `~/.config/wofi/config`

Beberapa parameter krusial (berdasarkan `man 5 wofi`):

  * `mode`: Menentukan mode default (`drun`, `run`, atau `dmenu`).
  * `width` / `height`: Dimensi jendela (bisa dalam pixel `px` atau persentase `%`).
  * `insensitive`: Fitur pencarian *fuzzy* yang tidak membedakan huruf besar/kecil (Sangat penting untuk UX cepat).
  * `allow_images`: Mengizinkan ikon (penting untuk estetika).

#### **B. The Style File (Aesthetics)**

Wofi menggunakan **GTK3 CSS**. Ini berbeda dengan CSS web biasa, meskipun sintaksnya 90% mirip.

  * **Selectors (Pemilih):** Bagian mana yang ingin diubah?
      * `#window`: Kontainer utama wofi.
      * `#input`: Kotak pencarian tempat Anda mengetik.
      * `#entry`: Setiap baris item dalam daftar.
      * `#entry:selected`: Baris item yang sedang disorot kursor.
  * **Lokasi:** `~/.config/wofi/style.css`

-----

### 2\. English Corner: Instructions & Configuration

Di sini kita belajar bahasa instruksi yang sering Anda temukan di README GitHub atau dokumentasi konfigurasi.

#### **A. Key Vocabulary**

| Word | Part of Speech | Definition (ID) | Context Example |
| :--- | :--- | :--- | :--- |
| **Directory** | Noun | Folder (Istilah teknis Linux/CLI). | *Create the configuration **directory** first.* |
| **Boolean** | Noun/Adj | Tipe data logika (Benar/Salah). | *Set the allow\_images flag to true (a **boolean** value).* |
| **Comment** | Noun/Verb | Catatan dalam kode yang tidak dieksekusi. | *Use `#` to add a **comment** in the config file.* |
| **Override** | Verb | Mengganti pengaturan default dengan pengaturan kita. | *This user config will **override** the system defaults.* |
| **Properties** | Noun | Atribut yang diubah (misal: warna, lebar). | *CSS **properties** define the look of the window.* |

#### **B. Grammar Focus: Imperative Sentences (Kalimat Perintah)**

Dalam panduan teknis, kita jarang menggunakan subjek ("I", "You"). Kita langsung menggunakan **Verb 1 (Base Form)** di awal kalimat. Ini disebut *Imperative*.

  * **Pola:** `[Verb 1] + [Object/Complement]`
  * **Contoh:**
      * *Salah:* You should open the file. (Terlalu bertele-tele).
      * *Benar (Professional):* **Open** the configuration file. (Buka file konfigurasi).
      * *Lainnya:* **Set** the width to 50%. **Save** the changes. **Restart** the application.

#### **C. Professional Interaction**

Jika Anda ingin bertanya mengenai styling di komunitas:

> *"Does Wofi support the standard GTK `box-shadow` property? I attempted to apply it to the `#window` selector, but it doesn't render."*
> (Apakah Wofi mendukung properti GTK `box-shadow` standar? Saya mencoba menerapkannya pada selektor `#window`, tapi tidak muncul).

-----

### 3\. Implementasi: Membuat Konfigurasi (CLI Based)

Mari kita praktikkan di terminal Sway Anda. Kita akan menggunakan editor teks CLI (saya asumsikan Anda bisa menggunakan `nano`, `vim`, atau `micro`).

**Langkah 1: Buat Direktori**

```bash
mkdir -p ~/.config/wofi
```

*Catatan:* `-p` (parents) memastikan tidak error jika direktori induknya belum ada.

**Langkah 2: Membuat File `config`**
Kita buat file yang mendukung *fuzzy search* dan tampilan responsif.

```bash
nano ~/.config/wofi/config
```

Salin konfigurasi berikut (Isi materi ini saya buat untuk performa dan estetika minimalis):

```ini
# Wofi Configuration
# Mode drun = Desktop Run (Mencari aplikasi terinstal)
mode=drun

# Tampilan (Layout)
show=drun
width=500
height=400
# Posisi: center, top, bottom, left, right
location=center

# Perilaku (Behavior)
# Prompt text di kotak pencarian
prompt=Search...
# Pencarian tidak peduli huruf besar/kecil (Wajib untuk kecepatan)
insensitive=true
# Mengizinkan pencarian fuzzy (tidak harus urut karakter)
allow_markup=true
# Hilangkan scrollbar jika tidak suka
no_actions=true

# Ikon
allow_images=true
image_size=24

# Eksekusi
# Jika menjalankan command terminal, gunakan foot (sesuaikan terminal Anda)
term=foot
```

*Simpan (Ctrl+O) dan Keluar (Ctrl+X).*

**Langkah 3: Membuat File `style.css`**
Kita buat tampilan yang elegan, gelap, dan minimalis (sesuai selera estetika Anda).

```bash
nano ~/.config/wofi/style.css
```

Salin CSS berikut:

```css
/* Reset dasar */
* {
    font-family: "JetBrains Mono", monospace; /* Sesuaikan font Anda */
    font-size: 14px;
}

/* Jendela Utama */
#window {
    margin: 0px;
    border: 2px solid #458588; /* Warna border (misal: Gruvbox Teal) */
    background-color: #282828; /* Background gelap */
    border-radius: 10px; /* Sudut membulat */
}

/* Kotak Input */
#input {
    margin: 5px;
    border: none;
    background-color: #3c3836;
    color: #ebdbb2; /* Warna teks */
    border-radius: 5px;
}

/* Area dalam input */
#inner-box {
    margin: 5px;
    background-color: transparent;
}

/* Item List (Non-selected) */
#entry {
    margin: 0px 5px;
    padding: 5px;
    border: none;
    background-color: transparent;
}

/* Item List (Selected/Hover) */
#entry:selected {
    background-color: #458588; /* Warna sorotan */
    color: #282828;
    border-radius: 5px;
    font-weight: bold;
}
```

-----

### 4\. Sumber Resmi (Official References)

Selalu validasi sintaks di sini jika ragu:

1.  **Config Parameters:** Jalankan `man 5 wofi` di terminal. Ini adalah "kitab suci" untuk mengetahui parameter apa saja yang valid di file `config`.
2.  **GTK CSS Properties:** Wofi menggunakan subset dari GTK CSS. Referensi lengkap properti CSS yang didukung GTK ada di [Gnome Developer Documentation (CSS Overview)](https://docs.gtk.org/gtk3/css-overview.html).

-----

### 5\. Error Handling & Troubleshooting

Bagian penting untuk Anda catat.

**Error A: Perubahan tidak terlihat**

  * **Penyebab:** Wofi tidak mendukung *hot-reload* (memuat ulang otomatis saat file disimpan).
  * **Solusi:** Anda harus menutup Wofi dan menjalankannya lagi.
      * *Command:* `pkill wofi` lalu jalankan `wofi --show drun`.

**Error B: Tampilan berantakan / CSS Parsing Error**

  * **Gejala:** Wofi muncul tapi warnanya putih polos atau terminal mengeluarkan pesan error "CSS parsing error".
  * **Solusi:** Jalankan Wofi lewat terminal (`wofi --show drun`). Perhatikan output log-nya. Wofi akan memberitahu baris ke berapa di `style.css` yang salah sintaksnya.
  * **English Error Message:** \*"Gtk-WARNING \**: Parsing error at line 10: 'foobar' is not a valid property name."*

**Error C: Ikon tidak muncul**

  * **Analisis:** Anda mungkin sudah set `allow_images=true` tapi tidak muncul.
  * **Solusi:** Pastikan tema ikon sistem diatur dengan benar (biasanya diatur via `gsettings` atau `nwg-look` di Arch/Sway). Wofi mengambil ikon dari tema GTK sistem.

-----

**Next Step:**
Sekarang Wofi Anda sudah memiliki "otak" (config) dan "wajah" (style). Tapi, membukanya lewat terminal itu merepotkan. Kita perlu mengintegrasikannya dengan tombol keyboard di Sway.

## Referensi ringkas (bahan bacaan lanjutan)

* Manual page wofi (config & opsi). ([Man Arch Linux][1])
* Dokumen theming & contoh CSS. ([Cloud Ninja][2])
* Contoh penggunaan mode & kombinasi `--show`. ([Man Arch Linux][5])
* Jika mengubah style, jalankan `wofi --show drun` dari terminal untuk melihat pesan error (redirect stderr ke file bila perlu). ([GitHub][8])
* Pencarian case-insensitive (`true` berarti “abaikan huruf besar/kecil”). ([ManKier][4])
* `XDG_CACHE_HOME/wal/colors` — file warna opsional (pywal integration). ([Man Arch Linux][3])
* jangan izinkan Pango markup pada entri (keamanan & stabilitas). Jika Anda ingin format kaya, ubah ke `true` (tapi hati-hati terhadap input tak tepercaya). ([Linux Command Library][7])
* `style` = nama opsi; nilai adalah path absolut ke file CSS. Menentukan file ini menimpa default style. Pastikan path benar dan file terbaca. ([Manpages Ubuntu][6])

---

###   **4. SUMBER BANTUAN RESMI UNTUK SINTAKS**

Anda bisa memvalidasi dan mendalami lebih lanjut:

* Dokumentasi Wofi resmi:
  [https://hg.sr.ht/~scoopta/wofi/tree/default/docs](https://hg.sr.ht/~scoopta/wofi/tree/default/docs)
* GTK CSS Reference (Wofi memakai GTK layer):
  [https://docs.gtk.org](https://docs.gtk.org)
* Sway Wiki:
  [https://github.com/swaywm/sway/wiki](https://github.com/swaywm/sway/wiki)
* lalulintas bantuan CLI seperti:

```
wofi --help
man wofi
```
---

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md
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


