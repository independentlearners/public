# Lesson 06 — Zsh Options (`setopt` dan `unsetopt`)

Kita beralih ke materi berikutnya dalam kurikulum: Zsh Options. Fokusnya adalah memahami bagaimana opsi mengubah perilaku shell, bagaimana mengaktifkan atau menonaktifkannya, dan bagaimana opsi tersebut memengaruhi scripting serta penggunaan Zsh secara interaktif.

Materi ini penting untuk tujuan Anda memahami konfigurasi Zsh karena banyak fitur Zsh dikendalikan oleh opsi bawaan, bukan melalui fungsi atau program eksternal.

### 06.1 — Apa itu Zsh option?

Option adalah pengaturan yang mengubah perilaku Zsh. Contohnya, opsi dapat mengatur apakah direktori bisa dijalankan seperti perintah `cd`, bagaimana glob yang tidak cocok ditangani, atau bagaimana riwayat perintah dikelola.

Perhatikan contoh berikut:

```
setopt AUTO_CD
```

Setelah opsi tersebut aktif, Anda dapat mengetik nama direktori sebagai perintah untuk berpindah ke direktori itu, tanpa menulis `cd` terlebih dahulu.

```
Documents
```

Jika direktori `Documents` tersedia dan dapat dikenali oleh Zsh, shell akan berpindah ke direktori tersebut.

Bandingkan dengan perilaku biasa:

```
cd Documents
```

Perintah `setopt` mengaktifkan opsi. Kebalikannya, `unsetopt`, menonaktifkannya:

```
unsetopt AUTO_CD
```

Perubahan ini berlaku pada proses shell yang sedang berjalan. Perubahan tersebut tidak otomatis menjadi konfigurasi permanen setelah shell ditutup.

### 06.2 — Memeriksa status opsi

Sebelum mengubah konfigurasi, Anda perlu mengetahui opsi mana yang aktif.

Jalankan:

```
setopt
```

Tanpa argumen, perintah ini menampilkan opsi yang sedang aktif. Anda dapat mencari nama opsi tertentu dari hasilnya.

Untuk memeriksa satu opsi secara langsung, gunakan conditional expression:

```
if [[ -o AUTO_CD ]]; then
    print -r -- "AUTO_CD aktif"
else
    print -r -- "AUTO_CD tidak aktif"
fi
```

Penjelasannya:

- `[[ ... ]]` mengevaluasi kondisi menggunakan sintaks conditional Zsh.
- `-o AUTO_CD` menguji apakah opsi `AUTO_CD` sedang aktif.
- `if` memilih cabang berdasarkan hasil pengujian.

Pemeriksaan seperti ini berguna saat Anda membaca konfigurasi yang perilakunya bergantung pada opsi tertentu.

### 06.3 — Mengaktifkan dan menonaktifkan beberapa opsi

`setopt` dan `unsetopt` dapat menerima lebih dari satu nama opsi.

```
setopt AUTO_CD EXTENDED_GLOB
```

Perintah tersebut mengaktifkan kedua opsi.

Untuk menonaktifkannya:

```
unsetopt AUTO_CD EXTENDED_GLOB
```

Perlu diingat bahwa mengaktifkan suatu opsi bisa mengubah cara Zsh menafsirkan perintah atau pola. Karena itu, ketika mempelajari konfigurasi orang lain, jangan hanya membaca nama opsinya—pahami pula dampaknya terhadap kode setelahnya.

### 06.4 — Eksperimen aman di shell saat ini

Jalankan satu per satu:

```
# Periksa status awal
if [[ -o AUTO_CD ]]; then
    print -r -- "Awalnya aktif"
else
    print -r -- "Awalnya tidak aktif"
fi

# Aktifkan opsi
setopt AUTO_CD

# Periksa kembali
[[ -o AUTO_CD ]] && print -r -- "Sekarang aktif"

# Nonaktifkan opsi
unsetopt AUTO_CD

# Periksa hasil akhir
[[ -o AUTO_CD ]] || print -r -- "Sekarang tidak aktif"
```

Komentar yang diawali `#` hanya menjadi penjelasan bagi pembaca. Zsh tidak menjalankan isi komentar sebagai perintah.

Catatan: eksperimen ini mengubah opsi pada shell yang sedang digunakan. Jika Anda ingin menguji perubahan tanpa memengaruhi shell induk, Anda dapat menggunakan subshell:

```
(
    setopt AUTO_CD
    setopt
)
```

Tanda kurung `(...)` menjalankan kelompok perintah dalam subshell. Perubahan opsi di dalamnya tidak diterapkan ke shell induk setelah subshell selesai.

### 06.5 — Tiga konsep yang perlu dibedakan

| Konsep               | Arti                                                                               |
| -------------------- | ---------------------------------------------------------------------------------- |
| Opsi aktif           | Perilaku yang dikendalikan opsi tersebut sedang berlaku.                           |
| Opsi nonaktif        | Perilaku khusus dari opsi tersebut tidak diberlakukan.                             |
| Konfigurasi permanen | Perintah pengaturan ditulis dalam file konfigurasi yang dibaca ketika Zsh dimulai. |

Misalnya, jika Anda ingin `AUTO_CD` aktif setiap kali membuka shell interaktif, perintah berikut dapat ditambahkan ke konfigurasi yang sesuai:

```
setopt AUTO_CD
```

Namun, untuk saat ini jangan buru-buru memasukkan semua opsi ke `.zshrc`. Kita perlu memahami dulu jenis opsi, perilaku default, dan cara pengelolaannya agar konfigurasi tidak menjadi kumpulan pengaturan yang tidak dipahami.

<details>
  <summary>📃  Latihan Lesson 06.1</summary>

---

Coba jawab tanpa menjalankan kode terlebih dahulu.

1\. Apa fungsi `setopt AUTO_CD`?

Mengaktifkan perilaku berpindah direktori dengan mengetik nama direktori

Menambahkan direktori ke `$PATH`

Membuat alias bernama `AUTO_CD`

2\. Apa fungsi `unsetopt AUTO_CD`?

Menghapus file konfigurasi Zsh

Menonaktifkan opsi `AUTO_CD` pada shell saat ini

Mengakhiri proses shell

3\. Apakah `setopt AUTO_CD` yang dijalankan di terminal otomatis tetap aktif setelah shell ditutup dan dibuka kembali?

Ya, semua opsi otomatis disimpan

Tidak, untuk mempertahankannya perlu konfigurasi yang dibaca saat shell dimulai

</details>

---
Materi berikutnya dalam Lesson 06 adalah jenis opsi, opsi default, opsi khusus shell interaktif, serta hubungan opsi dengan emulasi perilaku shell. Kita akan membahasnya sebelum melanjutkan ke materi berikutnya dalam kurikulum.

### 06.6 — Jenis opsi dan perilaku default

Pada bagian sebelumnya, kita mempelajari `setopt`, `unsetopt`, dan cara memeriksa apakah sebuah opsi aktif. Berikutnya, kita perlu memahami bahwa tidak semua opsi mengendalikan jenis perilaku yang sama.

Ada opsi yang memengaruhi cara Zsh menafsirkan pola, ada yang mengatur interaksi dengan pengguna, dan ada yang memengaruhi penanganan perintah atau riwayat.

Contohnya:

| Opsi               | Perilaku yang dikendalikan                                          |
| ------------------ | ------------------------------------------------------------------- |
| `AUTO_CD`          | Memungkinkan berpindah direktori dengan mengetik nama direktori     |
| `EXTENDED_GLOB`    | Mengaktifkan sintaks extended glob                                  |
| `HIST_IGNORE_DUPS` | Mengatur penyimpanan perintah duplikat yang berurutan dalam history |
| `SHARE_HISTORY`    | Mengatur berbagi dan penggabungan history antarsesi interaktif      |

Nama-nama tersebut berasal dari keluarga opsi Zsh yang berbeda. Anda tidak harus menghafal semuanya sekarang. Yang penting adalah mengenali bahwa opsi merupakan mekanisme untuk mengubah perilaku internal shell.

### 06.7 — Memahami default option

Default option adalah keadaan opsi sebelum Anda mengubahnya melalui konfigurasi atau perintah selama sesi shell.

Jangan berasumsi bahwa semua opsi nonaktif saat Zsh dimulai. Sebagian opsi sudah aktif secara default, sebagian tidak, dan perilakunya juga dapat dipengaruhi oleh cara Zsh dijalankan serta konfigurasi yang dimuat.

Untuk memeriksa keadaan aktual:

```
[[ -o EXTENDED_GLOB ]] \
    && print -r -- "EXTENDED_GLOB aktif" \
    || print -r -- "EXTENDED_GLOB tidak aktif"
```

Ini lebih dapat diandalkan daripada menebak keadaan shell berdasarkan konfigurasi yang Anda ingat.

Untuk melihat opsi yang aktif:

```
setopt
```

Ingat, hasil `setopt` menampilkan opsi yang aktif; opsi yang tidak tercantum bukan berarti tidak tersedia di Zsh—opsi tersebut mungkin hanya sedang nonaktif.

### 06.8 — Opsi interaktif dan noninteraktif

Zsh dapat berjalan dalam beberapa konteks. Contohnya, ketika Anda mengetik perintah di terminal, Zsh biasanya berjalan sebagai shell interaktif. Ketika menjalankan berkas `.zsh`, Zsh biasanya menjalankan skrip secara noninteraktif.

Perbedaan konteks ini penting karena opsi tertentu terutama berpengaruh pada penggunaan interaktif, sedangkan opsi lain berpengaruh pada pemrosesan skrip juga.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

+1



Contoh opsi yang sering digunakan untuk terminal interaktif:

- `AUTO_CD` — berpindah direktori dengan mengetik nama direktori.
- `INTERACTIVE_COMMENTS` — memungkinkan komentar yang dimulai dengan `#` dalam input interaktif.
- `SHARE_HISTORY` — berbagi riwayat perintah antarsesi interaktif.

Jangan menganggap semua opsi tersebut harus diaktifkan. Pilih berdasarkan perilaku yang Anda inginkan, lalu uji dampaknya.

Untuk mengetahui apakah shell saat ini interaktif:

```
if [[ -o INTERACTIVE ]]; then
    print -r -- "Shell interaktif"
else
    print -r -- "Shell noninteraktif"
fi
```

Pengujian ini berguna ketika suatu konfigurasi hanya boleh dijalankan pada shell interaktif.

### 06.9 — Nama opsi dan bentuk negatifnya

Nama opsi Zsh tidak sensitif terhadap kapitalisasi, dan garis bawah dalam nama opsi diabaikan. Karena itu, beberapa variasi berikut merujuk pada opsi yang sama.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io



```
setopt AUTO_CD
setopt auto_cd
setopt autocd
```

Untuk menonaktifkan opsi, Anda dapat menggunakan `unsetopt`:

```
unsetopt AUTO_CD
```

Zsh juga menerima bentuk negatif menggunakan awalan `NO`:

```
setopt NO_AUTO_CD
```

Perintah terakhir menonaktifkan `AUTO_CD`. Meski demikian, untuk konfigurasi yang mudah dibaca, sebaiknya gunakan `setopt` untuk mengaktifkan opsi dan `unsetopt` untuk menonaktifkannya secara eksplisit.

### 06.10 — Apa itu emulasi shell?

Zsh menyediakan mekanisme emulasi untuk menyesuaikan sejumlah perilakunya agar mendekati shell lain, terutama `sh` dan `ksh`. Mekanisme ini berkaitan erat dengan opsi. Namun, emulasi tidak menjamin kompatibilitas penuh dengan shell yang ditiru.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

+2



Contoh:

```
emulate zsh
```

Perintah ini meminta Zsh menggunakan perilaku emulasi Zsh. Untuk memeriksa bantuan tentang opsi yang berkaitan dengan emulasi, Anda dapat membaca:

```
man zshbuiltins
```

Lalu cari bagian `emulate`.

Salah satu bentuk yang akan berguna ketika kita mempelajari fungsi adalah:

```
emulate -L zsh
```

Untuk saat ini, pahami konsepnya dahulu: emulasi dapat mengatur beberapa opsi agar kode berjalan dengan asumsi perilaku shell tertentu. Makna `-L` dan penggunaannya dalam fungsi akan kita pelajari lebih mendalam pada materi fungsi, sehingga tidak perlu menghafalnya sekarang.

### Ringkasan Lesson 06 sejauh ini

Anda sudah mempelajari:

1. `setopt` untuk mengaktifkan opsi.
2. `unsetopt` untuk menonaktifkan opsi.
3. `[[ -o OPTION ]]` untuk memeriksa status opsi.
4. Perbedaan opsi aktif, nonaktif, dan konfigurasi permanen.
5. Opsi yang berkaitan dengan shell interaktif.
6. Bentuk negatif `NO_OPTION`.
7. Konsep emulasi shell.

Referensi resmi: [Zsh Manual — Options](https://zsh.sourceforge.io/Doc/Release/Options.html) dan [Zsh Manual — Shell Builtin Commands](https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html).

Berikutnya, kita akan melanjutkan materi opsi dengan memahami bagaimana opsi memengaruhi ekspansi, globbing, penanganan kesalahan, dan perilaku skrip. Setelah cakupan Lesson 06 selesai, barulah kita berpindah ke Lesson 07 — Builtins & Native Features, sesuai urutan kurikulum.

### 06.11 — `setopt -o` dan nama opsi alternatif

Penggunaan `setopt -o` termasuk bagian yang perlu dipelajari. Bentuk ini memungkinkan opsi ditulis menggunakan nama alternatif yang juga dikenal oleh `set`, terutama untuk kompatibilitas dengan gaya penamaan opsi `sh`/`ksh`.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

+1



Contohnya, `ERR_EXIT` memiliki nama alternatif `errexit`.

```
# Bentuk nama opsi Zsh
setopt ERR_EXIT

# Bentuk nama alternatif
setopt -o errexit

# Menonaktifkannya
unsetopt ERR_EXIT
```

`ERR_EXIT` memengaruhi apakah Zsh keluar ketika perintah tertentu gagal. Kita belum akan membahas perilaku penanganan error secara mendalam; fokus sekarang adalah memahami bahwa satu opsi bisa memiliki lebih dari satu nama yang valid.

Perhatikan perbedaannya:

```
setopt ERR_EXIT
setopt -o errexit
```

Keduanya mengaktifkan opsi yang sama. Sementara itu, `setopt` tanpa argumen menampilkan daftar opsi aktif, bukan daftar seluruh opsi yang tersedia.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

+1



### 06.12 — Melihat status opsi dengan `set -o`

Selain `setopt`, Zsh mendukung bentuk berikut:

```
set -o
```

Bentuk ini menampilkan status opsi menggunakan format nama alternatif. Untuk mengaktifkan atau menonaktifkan opsi tertentu, Anda juga dapat menulis:

```
set -o errexit
set +o errexit
```

Dalam penggunaan Zsh sehari-hari, `setopt` dan `unsetopt` biasanya lebih jelas karena nama opsi yang digunakan sesuai dengan konvensi Zsh. Namun, Anda perlu mengenali `set -o` ketika membaca skrip yang mengadopsi gaya shell lain.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

+1


---

<details>
  <summary>📃  Latihan Lesson 06</summary>


1\. Apa perbedaan `setopt` dan `unsetopt`?

`setopt` mengaktifkan opsi; `unsetopt` menonaktifkannya

Keduanya hanya menampilkan opsi

`setopt` mengubah file konfigurasi secara permanen

2\. Apa fungsi `[[ -o AUTO_CD ]]`?

Mengaktifkan `AUTO_CD`

Memeriksa apakah `AUTO_CD` aktif

Menonaktifkan `AUTO_CD`

3\. Apa makna `setopt -o errexit`?

Mengaktifkan opsi `ERR_EXIT` melalui nama alternatifnya

Menonaktifkan seluruh penanganan error

Menampilkan semua opsi yang tersedia

4\. Di mana sebaiknya opsi diletakkan jika ingin berlaku pada setiap shell interaktif yang baru dibuka?

Di `.zshrc`, yang dibaca oleh shell interaktif

Di file skrip acak yang tidak pernah dipanggil

Tidak perlu konfigurasi karena perubahan selalu disimpan otomatis

---

</details>

Setelah bagian ini, cakupan utama Lesson 06 dari kurikulum sudah dibahas: `setopt`, `unsetopt`, `setopt -o`, konsep opsi dan default-nya, opsi interaktif, serta emulasi. Materi berikutnya dalam urutan utama adalah Lesson 07 — Builtins & Native Features, dimulai dengan perbedaan perintah bawaan shell dan program eksternal.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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

