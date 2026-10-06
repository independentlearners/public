# **Materi 2 — Zsh Options**

Ini masih dalam kurikulum, tepat setelah Zsh Foundation. Jangan lompat ke ZLE, `.zshrc`, atau completion. Fokus dulu pada sistem option karena ini adalah salah satu perubahan mental terbesar dari Bash ke Zsh.

---

# Materi 2 — Zsh Options

## 2.1 Konsep Option di Zsh

Option adalah **saklar perilaku shell**. Ia bukan variabel, bukan fungsi, bukan perintah. Ia adalah keadaan internal Zsh yang memengaruhi cara Zsh berperilaku, baik saat parsing, ekspansi, globbing, history, maupun interaksi.

Di Bash, konfigurasi perilaku shell biasanya dilakukan lewat:
- variabel seperti `HISTCONTROL`, `HISTIGNORE`
- `shopt` untuk opsi Bash
- `set` untuk opsi POSIX

Di Zsh, hampir semua perilaku shell dikendalikan oleh **option**. Ada ratusan option. Sebagian aktif secara default, sebagian nonaktif. Anda menyalakan dan mematikannya dengan `setopt` dan `unsetopt`.

Mental model yang harus Anda bangun:

```text
Zsh
 ├── options (perilaku shell)
 ├── parameters (data)
 ├── functions (perintah yang bisa dipanggil)
 ├── aliases (pengganti teks)
 └── modules (fitur yang bisa dimuat)
```

Option adalah lapisan **perilaku**, bukan data. Jadi jangan tertukar dengan variabel.

---

## 2.2 `setopt` — Menyalakan Option

Bentuk dasar:

```zsh
setopt AUTO_CD
```

Penjelasan kata demi kata:

- `setopt` — builtin Zsh untuk **menyalakan** satu atau lebih option.
- `AUTO_CD` — nama option. Nama option di Zsh ditulis dengan huruf kapital dan underscore. Ini konvensi, bukan keharusan sintaks.
- Tidak ada tanda sama dengan, tidak ada koma, tidak ada tanda kurung. Cukup tulis nama option setelah `setopt`.

Anda bisa menyalakan beberapa option sekaligus:

```zsh
setopt AUTO_CD EXTENDED_GLOB SHARE_HISTORY
```

Penjelasan:
- `setopt` — builtin.
- `AUTO_CD` — option pertama.
- `EXTENDED_GLOB` — option kedua.
- `SHARE_HISTORY` — option ketiga.
- Zsh akan memproses semuanya dalam satu perintah.

Jika nama option salah, Zsh akan menampilkan error:

```zsh
setopt NAMA_OPTION_YANG_SALAH
```

Output kira-kira:

```text
setopt: no such option: NAMA_OPTION_YANG_SALAH
```

Pesan ini memberitahu bahwa option tidak dikenali. Perhatikan: Zsh **tidak** melanjutkan ke option berikutnya jika salah satu gagal, kecuali Anda menulisnya dalam beberapa perintah terpisah.

---

## 2.3 `unsetopt` — Mematikan Option

Bentuk dasar:

```zsh
unsetopt AUTO_CD
```

Penjelasan kata demi kata:

- `unsetopt` — builtin Zsh untuk **mematikan** satu atau lebih option.
- `AUTO_CD` — nama option yang ingin dimatikan.
- Perilaku setelah perintah ini: Zsh kembali ke perilaku default untuk option tersebut, yaitu nonaktif.

Anda juga bisa mematikan beberapa sekaligus:

```zsh
unsetopt AUTO_CD EXTENDED_GLOB
```

Penjelasan:
- `unsetopt` — builtin.
- `AUTO_CD` — option pertama.
- `EXTENDED_GLOB` — option kedua.
- Keduanya dimatikan.

Kombinasi `setopt` dan `unsetopt` adalah cara utama Anda mengonfigurasi Zsh.

---

## 2.4 `setopt -o` dan `setopt +o`

Zsh juga mengenal bentuk opsi shell klasik dengan tanda `-` dan `+`.

```zsh
set -o AUTO_CD
```

Penjelasan:
- `set` — builtin POSIX untuk mengubah opsi shell.
- `-o` — opsi untuk menentukan nama opsi.
- `AUTO_CD` — nama opsi.
- Bentuk ini setara dengan `setopt AUTO_CD`.

```zsh
set +o AUTO_CD
```

Penjelasan:
- `set` — builtin.
- `+o` — mematikan opsi.
- `AUTO_CD` — nama opsi.
- Setara dengan `unsetopt AUTO_CD`.

```zsh
setopt -o
```

Penjelasan:
- `setopt` — builtin Zsh.
- `-o` — bendera untuk menampilkan semua opsi yang sedang aktif.
- Output: daftar option yang menyala saat ini, satu per baris.

```zsh
setopt +o
```

Penjelasan:
- `+o` — menampilkan semua opsi yang sedang nonaktif.
- Berguna untuk melihat apa yang belum Anda nyalakan.

Ada juga:

```zsh
setopt -m
```

Penjelasan:
- `-m` — menampilkan opsi yang aktif beserta deskripsi singkatnya.

Anda bisa mencari option tertentu dengan menggabungkan dengan `grep`:

```zsh
setopt -o | grep GLOB
```

Penjelasan:
- `setopt -o` — daftar opsi aktif.
- `|` — pipe ke perintah berikutnya.
- `grep GLOB` — filter hanya baris yang mengandung `GLOB`.

---

## 2.5 Anatomi Nama Option

Nama option di Zsh memiliki konvensi:

- Huruf kapital semua.
- Dipisahkan oleh underscore.
- Contoh: `AUTO_CD`, `EXTENDED_GLOB`, `HIST_IGNORE_DUPS`, `SHARE_HISTORY`.

Beberapa option memiliki alias pendek. Contoh:

- `AUTO_CD` juga bisa ditulis `AUTOCD`.
- `SHARE_HISTORY` juga bisa ditulis `SHAREHIST`.

Zsh menerima keduanya, tetapi konvensi yang jelas adalah dengan underscore. Gunakan underscore agar mudah dibaca.

Ada juga bentuk negasi eksplisit. Contoh:

```zsh
setopt NO_AUTO_CD
```

Penjelasan:
- `NO_` — awalan untuk membalik opsi.
- `NO_AUTO_CD` — setara dengan `unsetopt AUTO_CD`.
- Ini berguna saat Anda ingin menetapkan semua opsi dalam satu blok dan mematikan sebagian.

Contoh:

```zsh
setopt AUTO_CD NO_EXTENDED_GLOB
```

Penjelasan:
- `AUTO_CD` — nyalakan.
- `NO_EXTENDED_GLOB` — matikan `EXTENDED_GLOB`.
- Keduanya diproses dalam satu perintah.

---

## 2.6 Default Option vs Interactive Option

Zsh membagi option menjadi beberapa kategori berdasarkan konteks.

### Default Option

Default option adalah opsi yang aktif atau nonaktif secara bawaan ketika Zsh dijalankan. Contoh default aktif:

- `INTERACTIVE` — hanya aktif jika shell interaktif.
- `MONITOR` — job control aktif.
- `HASH_CMDS` — Zsh mengingat path perintah.

Contoh default nonaktif:

- `AUTO_CD` — tidak aktif secara default.
- `EXTENDED_GLOB` — tidak aktif secara default.
- `SHARE_HISTORY` — tidak aktif secara default.

Ini berarti: jika Anda ingin perilaku yang tidak standar, Anda harus menyalakannya sendiri.

### Interactive Option

Option interaktif adalah option yang hanya relevan untuk shell interaktif. Contoh:

- `INTERACTIVE` — menyala jika Zsh dijalankan di terminal.
- `SHARE_HISTORY` — hanya berguna di sesi interaktif.
- `AUTO_CD` — hanya berguna di sesi interaktif.

Anda bisa memeriksa apakah Zsh berjalan interaktif:

```zsh
[[ -o INTERACTIVE ]] && echo "interaktif"
```

Penjelasan kata demi kata:

- `[[` — awal conditional.
- `-o` — operator untuk memeriksa option.
- `INTERACTIVE` — nama option.
- `]]` — akhir conditional.
- `&&` — jika benar, lanjut ke perintah berikutnya.
- `echo "interaktif"` — cetak.

### Option dan Konteks Script

Ketika Zsh menjalankan script non-interaktif, banyak opsi interaktif tidak relevan. Contoh `AUTO_CD` tidak berpengaruh di script karena script tidak menerima input dari keyboard.

Karena itu, konfigurasi `setopt` biasanya diletakkan di `.zshrc` (file konfigurasi shell interaktif), bukan di `.zshenv` (yang selalu dibaca). Kita akan bahas lokasi file ini di Materi 4.

---

## 2.7 Emulation

Emulation adalah mode di mana Zsh meniru shell lain.

```zsh
emulate sh
```

Penjelasan kata demi kata:

- `emulate` — builtin Zsh untuk mengaktifkan mode emulasi.
- `sh` — shell yang ditiru, yaitu POSIX sh.

Setelah `emulate sh`, Zsh akan menyesuaikan banyak option agar berperilaku seperti `sh`. Ini berguna ketika Anda ingin menjalankan script POSIX dengan Zsh.

```zsh
emulate zsh
```

Penjelasan:
- `emulate zsh` — kembali ke mode Zsh native.
- Ini mematikan emulasi dan mengembalikan default Zsh.

```zsh
emulate -L zsh
```

Penjelasan:
- `-L` — *local*. Emulasi hanya berlaku di dalam fungsi tempat perintah ini dijalankan.
- Setelah fungsi selesai, opsi kembali seperti semula.

Emulasi penting untuk memahami mengapa perilaku Zsh bisa berbeda di beberapa konteks. Misalnya, ketika Zsh dipanggil sebagai `sh`, ia masuk mode emulasi `sh` dan opsi seperti `EXTENDED_GLOB` tidak aktif.

Anda bisa melihat mode emulasi saat ini:

```zsh
emulate
```

Penjelasan:
- Tanpa argumen, `emulate` menampilkan mode saat ini.

---

## 2.8 Option Penting untuk Interactive Shell

Berikut option yang paling sering digunakan dan masuk dalam kurikulum kita.

### AUTO_CD

```zsh
setopt AUTO_CD
```

Penjelasan:
- `AUTO_CD` — jika Anda mengetik nama direktori tanpa perintah, Zsh akan otomatis menjalankan `cd` ke direktori itu.
- Contoh: jika Anda mengetik `~/Documents` dan menekan Enter, Zsh akan pindah ke direktori tersebut.
- Tanpa `AUTO_CD`, Zsh akan mencoba menjalankan `~/Documents` sebagai perintah dan gagal.

Cara kerja:
- Zsh memeriksa apakah kata pertama adalah nama direktori.
- Jika ya, ia mengubahnya menjadi `cd <direktori>`.
- Jika tidak, ia menjalankan sebagai perintah biasa.

Catatan: `AUTO_CD` tidak aktif di script. Ia hanya berguna di shell interaktif.

### EXTENDED_GLOB

```zsh
setopt EXTENDED_GLOB
```

Penjelasan:
- `EXTENDED_GLOB` — mengaktifkan operator glob lanjutan: `^`, `~`, `#`, `##`.
- Tanpa opsi ini, karakter `^` dan `#` diperlakukan sebagai karakter literal.
- Dengan opsi ini, Anda bisa menulis `^*.bak` untuk “semua kecuali `.bak`”, dan `*.txt~*.bak` untuk “semua `.txt` kecuali `.bak`”.

Ini adalah opsi yang sangat sering dipakai di konfigurasi Zsh.

### HIST_IGNORE_DUPS

```zsh
setopt HIST_IGNORE_DUPS
```

Penjelasan:
- `HIST_IGNORE_DUPS` — jika Anda menjalankan perintah yang sama seperti perintah sebelumnya, Zsh tidak akan menyimpannya dua kali.
- Contoh: Anda menjalankan `ls`, lalu `ls` lagi. History hanya berisi satu `ls`.
- Tanpa opsi ini, history akan berisi dua `ls` berturut-turut.

Ini berbeda dari `HIST_IGNORE_ALL_DUPS` yang menghapus semua duplikat, bukan hanya yang berturut-turut.

### SHARE_HISTORY

```zsh
setopt SHARE_HISTORY
```

Penjelasan:
- `SHARE_HISTORY` — history dibagikan antar sesi Zsh yang sedang berjalan.
- Tanpa opsi ini, setiap terminal memiliki history sendiri. Ketika Anda membuka terminal baru, history dari terminal lain belum tentu terlihat.
- Dengan `SHARE_HISTORY`, history ditulis dan dibaca dari file history bersama, sehingga semua sesi berbagi riwayat yang sama.

Ada juga `INC_APPEND_HISTORY` yang menambahkan perintah ke file history segera setelah dijalankan, bukan saat shell keluar. `SHARE_HISTORY` sering digunakan bersama `INC_APPEND_HISTORY` atau `INC_APPEND_HISTORY_TIME`.

### Kombinasi Umum

```zsh
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
```

Ini adalah kombinasi awal yang umum. Anda bisa menambah option lain sesuai kebutuhan.

---

## 2.9 Praktik: AUTO_CD

Mari kita praktikkan sesuai kurikulum.

### Langkah 1: Cek Status Awal

```zsh
setopt -o | grep AUTO_CD
```

Penjelasan:
- `setopt -o` — daftar opsi aktif.
- `| grep AUTO_CD` — filter hanya `AUTO_CD`.
- Jika tidak ada output, berarti `AUTO_CD` nonaktif.

### Langkah 2: Nyalakan

```zsh
setopt AUTO_CD
```

Penjelasan:
- Nyalakan option.
- Setelah ini, direktori bisa diakses tanpa `cd`.

### Langkah 3: Uji

```zsh
~/Documents
```

Penjelasan:
- Tanpa `AUTO_CD`, Zsh akan mencoba menjalankan `~/Documents` sebagai perintah dan gagal.
- Dengan `AUTO_CD`, Zsh akan pindah ke `~/Documents`.

Untuk kembali:

```zsh
cd -
```

Penjelasan:
- `cd -` — kembali ke direktori sebelumnya.

### Langkah 4: Matikan

```zsh
unsetopt AUTO_CD
```

Penjelasan:
- Matikan kembali.
- Uji lagi `~/Documents`, dan Zsh akan gagal menjalankan sebagai perintah.

---

## 2.10 Praktik: EXTENDED_GLOB

```zsh
setopt EXTENDED_GLOB
```

Setelah aktif, coba:

```zsh
ls ^*.txt
```

Penjelasan:
- `ls` — daftar file.
- `^*.txt` — semua file kecuali `.txt`.
- Tanpa `EXTENDED_GLOB`, `^` dianggap literal dan glob gagal.

```zsh
ls *.txt~*.bak
```

Penjelasan:
- `*.txt` — semua `.txt`.
- `~` — kecuali.
- `*.bak` — file `.bak`.
- Hasil: file `.txt` yang bukan `.bak`.

```zsh
ls *.(txt|md)
```

Penjelasan:
- `*.` — prefix.
- `(txt|md)` — alternasi.
- Hasil: file `.txt` atau `.md`.

---

## 2.11 Praktik: HIST_IGNORE_DUPS dan SHARE_HISTORY

```zsh
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
```

Uji `HIST_IGNORE_DUPS`:

```zsh
echo halo
echo halo
history | tail -5
```

Penjelasan:
- `echo halo` dijalankan dua kali.
- `history | tail -5` — lihat 5 perintah terakhir.
- Dengan `HIST_IGNORE_DUPS`, hanya satu `echo halo` yang tersimpan.

Uji `SHARE_HISTORY`:
- Buka terminal baru.
- Jalankan `history`.
- Anda akan melihat perintah dari terminal sebelumnya.

---

## 2.12 Cara Menemukan Option

Karena ada ratusan option, Anda perlu cara mencari.

```zsh
setopt -m | less
```

Penjelasan:
- `setopt -m` — daftar opsi aktif dengan deskripsi.
- `| less` — tampilkan halaman per halaman.

Untuk opsi yang nonaktif:

```zsh
unsetopt -m | less
```

Penjelasan:
- `unsetopt -m` — daftar opsi nonaktif dengan deskripsi.

Untuk melihat dokumentasi:

```zsh
man zshoptions
```

Penjelasan:
- `man zshoptions` — halaman manual yang menjelaskan semua option Zsh.
- Ini adalah referensi resmi yang wajib Anda baca.

Bagian penting di `man zshoptions`:
- `OPTIONS` — daftar semua option.
- `SINGLE LETTER OPTIONS` — opsi dengan satu huruf.
- `OPTION ALIASES` — alias nama option.
- `OPTIONS FOR COMPATIBILITY` — opsi untuk kompatibilitas Bash/Ksh.

---

## 2.13 Ringkasan Materi 2

- Option adalah saklar perilaku Zsh.
- `setopt` menyalakan, `unsetopt` mematikan.
- `setopt -o` menampilkan opsi aktif, `setopt +o` menampilkan opsi nonaktif.
- `NO_` adalah awalan untuk membalik opsi.
- Ada default option, interactive option, dan emulation.
- `AUTO_CD` memungkinkan pindah direktori tanpa `cd`.
- `EXTENDED_GLOB` mengaktifkan operator glob lanjutan.
- `HIST_IGNORE_DUPS` menghindari duplikat history berturut-turut.
- `SHARE_HISTORY` berbagi history antar sesi.
- `man zshoptions` adalah referensi resmi.

---

Sampai di sini **Materi 2 — Zsh Options** selesai. Sesuai kurikulum, berikutnya adalah **Materi 3 — Interactive Zsh**, yang mencakup:
- history
- completion
- ZLE
- bindkey
- keymap
- widget
- hook
- autoload
- compinit

Ini adalah tahap yang paling penting untuk tujuan Anda, karena di sinilah Zsh menjadi *programmable interactive shell*.

Saya lanjutkan ke **Materi 3 — Interactive Zsh** di respons berikutnya.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

