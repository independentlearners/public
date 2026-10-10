# Lesson 07 — Builtins & Native Features

Kita memasuki tahap berikutnya dalam kurikulum: perintah bawaan Zsh dan fitur native shell. Fokusnya adalah memahami kemampuan yang sudah disediakan Zsh tanpa harus membuat fungsi sendiri atau menjalankan program eksternal.

Materi ini menjadi fondasi untuk membaca konfigurasi Zsh dan plugin nantinya. Saat membaca sebuah konfigurasi, Anda perlu mengetahui apakah suatu perintah berasal dari Zsh, dari fungsi yang didefinisikan pengguna, atau dari program eksternal.

### 07.1 — Apa itu builtin?

Builtin adalah perintah yang implementasinya tersedia di dalam shell itu sendiri. Zsh dapat menjalankannya secara langsung, tanpa perlu mencari executable terpisah melalui `$PATH`.

Contoh builtin yang umum:

| Perintah   | Kegunaan                                                |
| ---------- | ------------------------------------------------------- |
| `cd`       | Mengubah direktori kerja shell                          |
| `print`    | Menampilkan teks dengan fitur khusus Zsh                |
| `read`     | Membaca input                                           |
| `typeset`  | Mendeklarasikan atau mengatur parameter                 |
| `whence`   | Menelusuri jenis atau lokasi suatu perintah             |
| `autoload` | Menyiapkan fungsi untuk dimuat ketika dibutuhkan        |
| `bindkey`  | Mengatur pemetaan tombol pada editor baris perintah Zsh |
| `zmodload` | Memuat atau memeriksa modul Zsh                         |

Beberapa builtin ini sudah Anda temui pada materi sebelumnya. Sekarang kita akan mempelajari cara mengenalinya dan mengapa perbedaan jenis perintah penting.

### 07.2 — Mengenali jenis perintah dengan `whence`

Zsh menyediakan builtin `whence` untuk membantu mengetahui bagaimana suatu nama perintah dikenali oleh shell.

Coba jalankan:

```
whence -w cd
whence -w print
whence -w ls
```

Opsi `-w` meminta Zsh menjelaskan jenis perintah. Hasilnya dapat menunjukkan kategori seperti builtin, alias, fungsi, atau perintah eksternal, bergantung pada nama yang diperiksa dan konfigurasi shell.

Untuk informasi yang lebih terperinci, gunakan:

```
whence -v cd
whence -v print
whence -v ls
```

Misalnya, `cd` dan `print` merupakan builtin Zsh, sedangkan `ls` biasanya merupakan program eksternal. Namun, `ls` dapat saja berupa alias atau fungsi dalam konfigurasi Anda. Karena itu, jangan menganggap hasil di semua sistem pasti sama.

### 07.3 — Perbedaan builtin, fungsi, alias, dan program eksternal

Bayangkan Anda mengetik `ll` di terminal.

Ada beberapa kemungkinan:

- `ll` adalah alias yang menggantikan teks perintah lain.
- `ll` adalah fungsi shell yang menjalankan beberapa perintah.
- `ll` adalah executable yang ditemukan melalui `$PATH`.
- Nama tersebut tidak dikenali oleh shell.

Kita bisa memeriksa nama yang tersedia:

```
whence -va ll
```

Opsi `-a` meminta seluruh kecocokan yang ditemukan, bukan hanya kecocokan pertama. Opsi `-v` meminta penjelasan tentang jenis atau lokasi perintah.

Perbedaan ini berguna ketika melakukan debugging konfigurasi. Jika sebuah perintah berperilaku tidak seperti yang Anda harapkan, bisa jadi nama yang Anda ketik merujuk pada alias atau fungsi, bukan executable yang Anda maksud.

### 07.4 — Memilih builtin atau program eksternal secara eksplisit

Zsh menyediakan dua mekanisme penting: `builtin` dan `command`.

`builtin` meminta Zsh menjalankan builtin dengan nama tertentu:

```
builtin cd /tmp
```

`command` meminta shell menjalankan perintah tanpa menggunakan fungsi shell dengan nama tersebut:

```
command ls
```

Dalam praktiknya, `command` berguna ketika Anda ingin menghindari fungsi yang menimpa nama perintah. Namun, jangan menganggapnya sebagai jaminan bahwa executable tertentu akan dijalankan: alias diproses pada tahap penguraian input, dan pencarian perintah masih mengikuti aturan shell.

Perhatikan contoh berikut:

```
my_command() {
    print -r -- "Ini fungsi buatan sendiri"
}

my_command
command my_command
```

Pemanggilan pertama menjalankan fungsi yang Anda definisikan. Pemanggilan kedua tidak menjalankan fungsi tersebut; Zsh akan mencoba menemukan perintah lain bernama `my_command`. Jika tidak tersedia, pemanggilan itu gagal.

Ini adalah salah satu teknik penting untuk memahami konflik nama dalam konfigurasi shell.

### 07.5 — Mengapa `print` sering digunakan dalam Zsh?

Anda sudah mengenal `printf` dari Bash. Zsh juga menyediakan builtin `print` dengan opsi yang praktis untuk penggunaan interaktif maupun skrip.

Contoh:

```
print "Halo"
print -r -- '$HOME tetap berupa teks'
print -n -- "Tanpa newline"
```

Makna opsinya:

- `-r` mencegah interpretasi khusus terhadap karakter backslash.
- `-n` tidak menambahkan newline di akhir output.
- `--` menandai akhir opsi sehingga teks setelahnya tidak ditafsirkan sebagai opsi `print`.

Pada contoh kedua, `$HOME` ditulis di dalam tanda kutip tunggal sehingga tidak diekspansi oleh shell. Opsi `-r` memastikan backslash di dalam teks juga tidak diperlakukan sebagai escape oleh `print`.

Untuk skrip yang mengutamakan portabilitas POSIX, `printf` tetap pilihan yang baik. Dalam konfigurasi yang memang ditujukan khusus untuk Zsh, `print` merupakan builtin yang layak dipahami.


<details>
  <summary>📃 Latihan Lesson 07.1</summary>

---

Coba tentukan jawaban berikut.

1\. Apa kegunaan `whence -w cd`?

Mengubah direktori kerja

Memeriksa jenis perintah `cd`

Menghapus fungsi bernama `cd`

2\. Apa perbedaan utama `builtin cd` dan `command ls`?

Keduanya selalu menjalankan executable eksternal

`builtin` memilih builtin shell, sedangkan `command` menghindari fungsi shell dengan nama yang dipanggil

Keduanya membuat alias baru

3\. Mengapa `whence -va ll` berguna saat debugging?

Menampilkan seluruh kecocokan yang ditemukan untuk nama perintah

Mengaktifkan seluruh builtin Zsh

Menambahkan `ll` ke `$PATH`

4\. Apa kegunaan `print -r -- '$HOME'`?

Menampilkan nilai direktori home

Menampilkan teks literal `$HOME` tanpa ekspansi variabel

Mengubah nilai variabel `HOME`

Periksa jawaban



</details>

Materi selanjutnya dalam Lesson 07 — Builtins & Native Features adalah builtin pengelolaan parameter dan fungsi, termasuk penggunaan `typeset`, `functions`, `autoload`, serta pengenalan direktori kerja dan direktori bertumpuk melalui `cd`, `pushd`, `popd`, dan `dirs`. Kita tetap berada pada Lesson 07 sampai cakupan utamanya selesai.

---

<details>
  <summary>📃 Latihan Lesson 07.1</summary>

</details>

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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

