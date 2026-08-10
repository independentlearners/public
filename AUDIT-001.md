# Audit #001 — Struktur Awal Repository Publik

Tanggal audit: 2026-08-09
Branch audit: `improvement/public-private-separation`

## Ruang Lingkup

Audit ini hanya mencakup `independentlearners/public`. Direktori personal `saya/` dan seluruh repository di bawah `Pribadi/saya/` berada di luar ruang lingkup.

Tujuan audit pertama adalah memahami struktur sebelum melakukan pemindahan, penggabungan, atau penghapusan konten.

## Temuan Awal

### 1. Repository sudah mempunyai navigasi tingkat tinggi

`README.md` telah mencoba membentuk jalur pembelajaran, terutama untuk CLI/TUI, dengan urutan fundamental → shell/terminal → package manager → tools → scripting → networking → reference/experiments. Struktur ini layak dipertahankan sebagai fondasi, tetapi perlu dipisahkan dari isi yang terlalu panjang.

### 2. README utama terlalu padat

`README.md` tidak hanya berfungsi sebagai indeks. Ia juga memuat penjelasan konseptual yang panjang, termasuk Programmer Hub dan Operating Systems Hub. Ini meningkatkan biaya pemeliharaan dan membuat navigasi sulit dipisahkan dari materi.

Arah perbaikan: README root menjadi entry point dan peta; materi konseptual dipindahkan secara bertahap ke halaman domain yang sesuai setelah semua tautannya diaudit.

### 3. Terdapat README kosong atau sangat minim

Audit tree menunjukkan beberapa README dengan ukuran nol atau hampir nol, termasuk:

- `CLI_TUI/konsep/README.md`
- `CLI_TUI/konsep/shell/zsh/README.md`
- `CLI_TUI/konsep/terminal/kitty/README.md`
- `CLI_TUI/package-manager/linux/README.md`
- `CLI_TUI/package-manager/macos/README.md`

README minim tidak otomatis harus diisi. Setiap kasus harus diperiksa apakah direktori tersebut memang membutuhkan halaman indeks atau seharusnya hanya menjadi struktur pendukung.

### 4. Ada indikasi duplikasi struktur

`CLI_TUI/konsep/terminal/README.md` berukuran sangat besar dan mempunyai beberapa bagian turunan (`bagian-1` sampai `bagian-5`). Ini perlu diperiksa apakah pembagian tersebut benar-benar modular atau hanya memecah dokumen besar tanpa hubungan navigasi yang jelas.

### 5. Root README mengandung tautan ke struktur yang harus diverifikasi

Karena repository telah mengalami perubahan struktur sebelumnya, seluruh tautan relatif perlu diperiksa sebelum direktori dipindahkan. Audit berikutnya harus menghasilkan daftar target valid, target hilang, dan target yang menunjuk ke lokasi yang tidak lagi canonical.

### 6. Beberapa materi mencampur kurikulum dan referensi

`CLI_TUI/konsep/terminal/README.md` sudah mempunyai prerequisite, learning outcomes, fase, modul, contoh, dan sumber. Ini adalah pola yang baik dan dapat dijadikan kandidat template untuk materi matang. Namun halaman tersebut juga sangat panjang sehingga struktur materi perlu dipisahkan setelah hubungan antarhalaman diketahui.

### 7. Struktur domain utama masih perlu dipetakan berdasarkan fungsi

Top-level saat ini mencakup:

- `CLI_TUI`
- `jobs`
- `kamus`
- `markdown`
- `matematik`
- `others`
- `pengaturan`
- `programmer`
- `sistem-operasi`
- `software`

Belum ada dasar yang cukup untuk memindahkan semuanya. Langkah berikutnya adalah menentukan hubungan antardomain dan canonical location sebelum restrukturisasi.

### 8. Root README memiliki indikasi referensi yang perlu disinkronkan dengan tree aktual

Navigasi root menyebut sejumlah lokasi sebagai halaman pembelajaran. Karena repository terus berkembang, setiap target harus dibandingkan dengan tree aktual sebelum halaman dipertahankan sebagai canonical entry point. Pemeriksaan ini akan dilakukan sebelum restrukturisasi dan bukan berdasarkan asumsi nama direktori.

### 9. Repository memiliki banyak README sehingga navigasi harus dibedakan dari materi

Pencarian repository menunjukkan README tersebar pada banyak tingkat, dari domain utama hingga materi dan bagian-bagian kecil. Ini menguatkan kebutuhan untuk membedakan tiga fungsi: landing/index, materi pembelajaran, dan reference. Tidak semua direktori membutuhkan README baru.

## Keputusan Audit #001

Belum ada pemindahan atau penghapusan konten publik pada tahap ini.

Prioritas berikutnya:

1. Audit seluruh tautan internal.
2. Audit README kosong/minim.
3. Audit struktur `CLI_TUI`.
4. Audit `programmer`.
5. Audit `sistem-operasi`.
6. Audit domain lainnya.
7. Susun master map dan dependency map.
8. Baru melakukan perubahan struktur P0.

## Protokol Sinkronisasi Lokal

Setiap checkpoint perubahan repository harus dapat direproduksi dari root repository privat beserta seluruh submodule. Gunakan urutan berikut dari root `file`:

```bash
git fetch --all --prune
git pull --ff-only
git submodule sync --recursive
git submodule update --init --recursive
git submodule foreach --recursive 'git fetch --all --prune'
git status
```

Perintah tersebut memperbarui referensi root, menyelaraskan URL/path submodule, checkout commit submodule yang direferensikan root, dan mengambil referensi remote pada repository submodule. `git submodule update --init --recursive` adalah langkah yang menentukan isi working tree sesuai gitlink root; `foreach` hanya memperbarui referensi remote submodule dan tidak melakukan merge/pull pada branch submodule secara otomatis.

Untuk verifikasi akhir checkpoint:

```bash
git status

git submodule status --recursive
```

Targetnya adalah root `file` dan seluruh working tree submodule berada pada keadaan yang dapat direproduksi dari commit yang direferensikan, tanpa perubahan lokal yang tidak disengaja.

## Prinsip Perlindungan Konten

- Jangan menghapus konten hanya karena duplikat sebelum canonical source ditentukan.
- Jangan memindahkan direktori sebelum semua referensi path ditemukan.
- Jangan membuat halaman baru jika halaman lama masih dapat diperbaiki tanpa kehilangan konteks.
- Jangan menganggap panjang dokumen sebagai kualitas.
- Jangan menganggap status `completed` sebagai bukti penguasaan materi.

## Status

`Audit #001 — in progress`
