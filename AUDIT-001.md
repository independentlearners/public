# Audit #001 — Struktur Awal Repository Publik

Tanggal audit: 2026-08-10
Branch audit: `improvement/public-private-separation`

## Ruang Lingkup

Audit ini hanya mencakup `independentlearners/public`. Direktori personal `Pribadi/saya/` pada repository `file` berada di luar ruang lingkup.

Tujuan audit pertama adalah memahami struktur, hubungan antarhalaman, dan fungsi setiap domain sebelum melakukan pemindahan, penggabungan, atau penghapusan konten.

## 1. Struktur Tingkat Atas

Repository publik saat ini memiliki domain utama:

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

Belum ada dasar yang cukup untuk memindahkan domain-domain tersebut. Masing-masing harus dipetakan berdasarkan fungsi, bukan hanya nama direktori.

## 2. Root README

Root `README.md` telah berfungsi sebagai navigasi tingkat tinggi, tetapi juga memuat materi konseptual yang panjang, termasuk bagian Programmer Hub dan Operating Systems Hub.

Keputusan sementara:

- pertahankan root README sebagai entry point;
- jangan langsung menghapus materi di dalamnya;
- audit semua tautan sebelum memisahkan materi konseptual;
- setelah canonical location ditentukan, root README secara bertahap diarahkan menjadi peta repository.

## 3. CLI_TUI

`CLI_TUI/README.md` sendiri berukuran sekitar 16 KB dan memuat:

- definisi CLI;
- perbandingan CLI dan GUI;
- struktur command, option, argument, dan subcommand;
- identitas teknis serta bahasa implementasi;
- persyaratan pengembangan/modifikasi;
- latihan;
- referensi;
- inventaris teknologi yang sangat panjang.

Temuan: halaman ini mencampur **orientation**, **reference**, **learning material**, dan **technology inventory**. Ini bukan alasan untuk menghapusnya; konten perlu dipetakan ke fungsi masing-masing.

`CLI_TUI` mempunyai beberapa cabang utama:

- `konsep`
- `package-manager`
- `perintah`
- `referensi`
- `scripting`
- `struktur-sistem`
- `termux`
- `tools`
- `windows`

Struktur ini menunjukkan bahwa `CLI_TUI` sudah menjadi domain pembelajaran yang cukup besar, bukan sekadar dokumentasi perintah.

## 4. Kurikulum Terminal

`CLI_TUI/konsep/terminal/README.md` merupakan salah satu dokumen paling bernilai secara pedagogis. Dokumen tersebut sudah mempunyai:

- prerequisite;
- alat yang diperlukan;
- learning outcomes;
- fase pembelajaran;
- modul;
- terminologi;
- contoh implementasi;
- sumber referensi.

Dokumen juga membagi materi menjadi fase Foundation, Intermediate, dan Advanced.

Temuan struktural: dokumen utama tersebut sangat panjang dan mempunyai turunan `bagian-1` sampai `bagian-5`. Audit lanjutan harus menentukan apakah setiap bagian merupakan modul mandiri, lanjutan linear, atau hanya pecahan dokumen besar.

Keputusan: **jangan memecah dokumen ini sebelum hubungan internal dan canonical navigation dipetakan.**

## 5. Programmer

`programmer/README.md` merupakan referensi yang sangat luas. Ia mengklasifikasikan bahasa berdasarkan paradigma, tingkat abstraksi, ekosistem, dan domain, kemudian memuat tabel besar teknologi dengan kolom seperti implementasi engine/compiler dan persyaratan teknis untuk modifikasi.

Temuan: dokumen ini lebih dekat ke **reference/technology encyclopedia** daripada kurikulum linear.

Keputusan sementara:

- jangan memaksanya menjadi learning path;
- pertahankan nilai referensinya;
- pisahkan fungsi navigasi, referensi, dan materi belajar secara bertahap;
- verifikasi klaim teknis sebelum menjadikannya canonical reference.

## 6. README dan Hierarki Materi

Terdapat banyak README pada berbagai tingkat kedalaman, misalnya pada perintah individual, tools, teknologi, modul, dan bagian-bagian kurikulum.

Keberadaan README di setiap direktori **tidak otomatis berarti direktori tersebut membutuhkan materi baru**. README harus diklasifikasikan berdasarkan fungsi:

- `landing/index`;
- `concept`;
- `tutorial`;
- `reference`;
- `practice`;
- `project`;
- `troubleshooting`;
- `assessment`;
- `placeholder`.

README kosong atau minim akan diperiksa setelah fungsi direktori diketahui.

## 7. Duplikasi dan Overlap

Indikasi overlap sudah terlihat setidaknya pada tiga lapisan:

1. Root `README.md` memuat ringkasan domain sekaligus materi.
2. `CLI_TUI/README.md` mengulang sebagian konsep yang juga dibahas di kurikulum terminal.
3. `programmer/README.md` menggabungkan klasifikasi bahasa, teknologi, dan persyaratan pengembangan dalam satu referensi besar.

Belum ada konten yang dihapus atau digabung. Canonical source harus ditentukan terlebih dahulu.

## 8. Model Canonical Source

Sebelum memindahkan materi, gunakan prinsip:

```text
Satu konsep utama
      ↓
Satu canonical explanation
      ↓
Referensi silang dari halaman lain
```

Salinan ringkas masih diperbolehkan jika benar-benar berfungsi sebagai orientation, tetapi penjelasan substantif sebaiknya mempunyai satu sumber utama.

## 9. Audit Link

Audit link penuh belum selesai. Karena repository telah mengalami pemisahan `public/saya`, link yang menuju struktur lama harus dicari sebelum restrukturisasi lebih lanjut.

Prioritas:

1. referensi `saya/`;
2. referensi path relatif antar-domain;
3. referensi ke file yang sudah dipindahkan;
4. tautan dari root README;
5. tautan antarbagian kurikulum;
6. tautan eksternal yang relevan terhadap klaim teknis.

## 10. Keputusan Audit #001 Saat Ini

Belum ada pemindahan atau penghapusan materi pembelajaran publik.

Temuan yang sudah cukup kuat untuk menjadi dasar perubahan P0:

- root README perlu diarahkan menjadi entry point;
- fungsi `CLI_TUI/README.md` perlu dipisahkan dari materi/reference yang terlalu panjang;
- kurikulum terminal perlu memiliki navigasi modular tanpa kehilangan isi;
- `programmer/README.md` perlu diperlakukan sebagai reference domain, bukan dipaksa menjadi kurikulum;
- README tingkat direktori perlu diklasifikasikan sebelum diisi atau dihapus;
- canonical source harus ditentukan sebelum deduplikasi.

## Prioritas Audit Berikutnya

1. Audit link internal secara sistematis.
2. Audit struktur lengkap `CLI_TUI`.
3. Audit `programmer`.
4. Audit `sistem-operasi`.
5. Audit domain lain.
6. Susun master map.
7. Susun dependency/prerequisite map.
8. Tentukan canonical locations.
9. Tentukan perubahan P0.
10. Implementasikan perubahan P0 secara bertahap.

## Prinsip Perlindungan Konten

- Jangan menghapus konten hanya karena terlihat duplikat sebelum canonical source ditentukan.
- Jangan memindahkan direktori sebelum semua referensi path ditemukan.
- Jangan membuat halaman baru jika halaman lama masih dapat diperbaiki tanpa kehilangan konteks.
- Jangan menganggap panjang dokumen sebagai kualitas.
- Jangan menganggap status `completed` sebagai bukti penguasaan materi.
- Jangan mencampur workspace personal ke dalam repository publik.

## Protokol Sinkronisasi Lokal

Setiap checkpoint perubahan repository harus dapat diambil dari root repository privat beserta seluruh submodule. Gunakan urutan berikut dari root `file`:

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

## Status

`Audit #001 — in progress`
