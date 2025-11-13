<!--
Luar biasa — ini langkah tepat menuju tingkat “power user sejati” Arch Linux.
Berikut **kurikulum 7 hari** yang disusun khusus untuk membangun kemampuan memahami setiap konfigurasi di `~/.config` **secara mandiri dan mendalam**, sehingga kamu bisa membaca, menulis, dan memodifikasi file konfigurasi hanya bermodalkan dokumentasi resmi (`man`, `--help`, dan README`).

Setiap hari terdiri dari **tujuan belajar**, **materi teknis**, **latihan**, dan **alat bantu CLI** yang relevan.
Fokus utamanya adalah *pembentukan intuisi sintaks dan struktur konfigurasi.*

-->
# 7 Hari Memahami Alur Kerja Konfigurasi
---

## 🧭 HARI 1 — Fondasi: Struktur Sistem & XDG Base Directory

### Tujuan

Memahami **mengapa konfigurasi berada di `~/.config`**, bagaimana hierarki sistem bekerja, dan apa hubungan antara konfigurasi sistem dan user.

### Materi

* Hierarki direktori Linux: `/etc`, `/usr/share`, `/home/<user>/.config`.
* Spesifikasi XDG: `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`.
* Cara Linux menentukan prioritas file konfigurasi (System → User → Runtime).

### CLI & Dokumentasi

```bash
man 7 hier
man 7 environ
man 7 xdg-base-dir
echo $XDG_CONFIG_HOME
```

### Latihan

1. Jalankan `printenv | grep XDG` — pahami variabel lingkungan XDG.
2. Cek konfigurasi global vs lokal:

   ```bash
   ls /etc/sway/
   ls ~/.config/sway/
   ```

   Catat bedanya.
3. Buat diagram kecil alur prioritas konfigurasi.

---

## 🧱 HARI 2 — Bahasa Konfigurasi: INI, TOML, YAML, JSON

### Tujuan

Menjadi paham 4 format utama konfigurasi yang sering muncul di `~/.config`.

### Materi

* **INI:** digunakan oleh `alacritty`, `gtk`, `wine`.
* **TOML:** digunakan oleh `starship`, `helix`, `cargo`.
* **YAML:** digunakan oleh `waybar`, `docker-compose`.
* **JSON:** digunakan oleh `VSCode`, `nvim-lspconfig`, `dunst`.

### CLI & Dokumentasi

```bash
man 5 systemd.syntax
python -m json.tool ~/.config/somefile.json
yq --help
```

### Latihan

1. Ambil satu file `.toml`, `.yaml`, `.ini`, `.json` dari `~/.config`.
2. Ubah satu nilai, reload aplikasinya, lihat efeknya.
3. Coba validasi sintaks:

   ```bash
   yq e . ~/.config/waybar/config
   jq . ~/.config/waybar/config
   ```

---

## 🧩 HARI 3 — DSL & Imperatif Config (Sway, Bashrc, Vimrc)

### Tujuan

Memahami file konfigurasi yang berbentuk **skrip domain-spesifik** (DSL), bukan sekadar key=value.

### Materi

* Struktur DSL pada `sway`, `i3`, `vimrc`.
* Konsep perintah, argumen, variabel, dan komentar.
* Perbedaan antara deklaratif dan imperatif.

### CLI & Dokumentasi

```bash
man 5 sway
man 1 bash
man 5 bashrc
```

### Latihan

1. Buka `~/.config/sway/config` dan cocokkan setiap baris dengan dokumentasi di `man 5 sway`.
2. Jalankan:

   ```bash
   swaymsg -t get_config | less
   ```
3. Uji perubahan dengan `swaymsg reload`.

---

## 🧮 HARI 4 — Membaca Dokumentasi & Manual dengan Efektif

### Tujuan

Melatih membaca dan menafsirkan dokumentasi resmi seperti `man`, `info`, dan `--help`.

### Materi

* Struktur umum halaman manual (NAME, SYNOPSIS, DESCRIPTION, EXAMPLES).
* Arti tanda `[ ]`, `< >`, `{ }`, dan `|` dalam manual.
* Menggunakan `apropos`, `whatis`, dan `tldr`.

### CLI & Dokumentasi

```bash
man man
man 7 man-pages
apropos sway
whatis sway
tldr sway
```

### Latihan

1. Pilih satu tool favoritmu (contoh: `waybar`), baca `man waybar` dari awal sampai akhir.
2. Jelaskan secara lisan apa maksud setiap bagian `SYNOPSIS`.
3. Buat catatan pribadi “pola bacaan cepat” versi kamu sendiri.

---

## ⚙️ HARI 5 — Eksperimen Konfigurasi: Reload, Test, Sandbox

### Tujuan

Belajar **menguji perubahan konfigurasi tanpa merusak sistem**.

### Materi

* Membuat *sandbox environment* menggunakan user dummy atau virtual terminal.
* Menggunakan `--config` untuk menjalankan aplikasi dengan file konfigurasi lain.
* Perbedaan `reload` dan `restart`.

### CLI & Dokumentasi

```bash
sway -c /tmp/testconfig
waybar -c ~/.config/waybar/test.json
```

### Latihan

1. Salin file konfigurasi asli ke `/tmp/test/`.
2. Ubah beberapa nilai, lalu jalankan:

   ```bash
   sway -c /tmp/test/config
   ```

   Lihat hasilnya tanpa memengaruhi sesi utama.
3. Catat perintah reload tiap aplikasi (`swaymsg reload`, `systemctl --user restart ...`).

---

## 🧠 HARI 6 — Autodiscovery & Debugging Konfigurasi

### Tujuan

Belajar menelusuri di mana file konfigurasi dibaca, dan bagaimana menemukan kesalahan sintaks.

### Materi

* `strace` untuk melihat file yang dibuka.
* `journalctl --user` untuk log aplikasi.
* `set -x` (bash) untuk debug konfigurasi shell.

### CLI & Dokumentasi

```bash
strace -e openat sway 2>&1 | grep config
journalctl --user -b | grep sway
```

### Latihan

1. Jalankan `strace` pada aplikasi untuk melihat path konfigurasi.
2. Buat kesalahan kecil di file konfigurasi dan lihat error log-nya.
3. Catat bagaimana aplikasi menangani error itu.

---

## 🔮 HARI 7 — Sintesis: Membangun Konfigurasi dari Nol

### Tujuan

Menguji pemahaman penuh dengan membuat satu konfigurasi sistem kamu sendiri dari nol.

### Materi

* Menggabungkan seluruh konsep: format file, dokumentasi, debugging.
* Membuat layout konfigurasi modular (misal `~/.config/sway/conf.d/`).
* Dokumentasi diri: memberi komentar yang deskriptif.

### Latihan Akhir

1. Buat file konfigurasi sway baru di `~/.config/sway/custom/`.
2. Gunakan dokumentasi `man 5 sway` untuk menulis ulang minimal 10 binding baru.
3. Jalankan `sway -c ~/.config/sway/custom/config` dan pastikan semuanya berfungsi.
4. Buat README.md untuk menjelaskan konfigurasi kamu seolah itu proyek open source.

---

## 📘 Penutup

Setelah 7 hari, kamu akan:

* Memahami struktur `~/.config` dan cara sistem memuatnya.
* Mengerti format umum konfigurasi (TOML, YAML, JSON, DSL).
* Bisa membaca dokumentasi resmi tanpa kebingungan.
* Dapat menguji dan memodifikasi konfigurasi dengan aman.
* Siap membangun konfigurasi yang terstruktur, modular, dan mudah dipelihara.

---
<!--
Kamu ingin saya lanjutkan dengan **modul tambahan (minggu ke-2)** khusus untuk membedah **konfigurasi nyata** (contoh: `waybar`, `alacritty`, `neovim`, `starship`, dan `sway`) dengan penjelasan kata per kata serta makna sintaksnya?
Itu akan jadi kelanjutan langsung dari kurikulum ini.-->

