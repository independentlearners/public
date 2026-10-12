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

```bash
whence -w cd
whence -w print
whence -w ls
```

Opsi `-w` meminta Zsh menjelaskan jenis perintah. Hasilnya dapat menunjukkan kategori seperti builtin, alias, fungsi, atau perintah eksternal, bergantung pada nama yang diperiksa dan konfigurasi shell.

Untuk informasi yang lebih terperinci, gunakan:

```bash
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

```bash
whence -va ll
```

Opsi `-a` meminta seluruh kecocokan yang ditemukan, bukan hanya kecocokan pertama. Opsi `-v` meminta penjelasan tentang jenis atau lokasi perintah.

Perbedaan ini berguna ketika melakukan debugging konfigurasi. Jika sebuah perintah berperilaku tidak seperti yang Anda harapkan, bisa jadi nama yang Anda ketik merujuk pada alias atau fungsi, bukan executable yang Anda maksud.

### 07.4 — Memilih builtin atau program eksternal secara eksplisit

Zsh menyediakan dua mekanisme penting: `builtin` dan `command`.

`builtin` meminta Zsh menjalankan builtin dengan nama tertentu:

```bash
builtin cd /tmp
```

`command` meminta shell menjalankan perintah tanpa menggunakan fungsi shell dengan nama tersebut:

```bash
command ls
```

Dalam praktiknya, `command` berguna ketika Anda ingin menghindari fungsi yang menimpa nama perintah. Namun, jangan menganggapnya sebagai jaminan bahwa executable tertentu akan dijalankan: alias diproses pada tahap penguraian input, dan pencarian perintah masih mengikuti aturan shell.

Perhatikan contoh berikut:

```bash
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

```bash
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


</details>

---

Materi selanjutnya dalam Lesson 07 — Builtins & Native Features adalah builtin pengelolaan parameter dan fungsi, termasuk penggunaan `typeset`, `functions`, `autoload`, serta pengenalan direktori kerja dan direktori bertumpuk melalui `cd`, `pushd`, `popd`, dan `dirs`. Tujuannya adalah mengenali mekanismenya sebelum nanti mempelajari fungsi dan `autoload` secara lebih mendalam.

---

## Builtins & Native Features (lanjutan)

Bagian ini membahas bagaimana Zsh menyediakan fitur internal untuk mengelola parameter, memeriksa fungsi, memuat fungsi secara otomatis, dan berpindah direktori. 

### 07.6 — `typeset`: mengelola parameter

`typeset` adalah builtin Zsh untuk mendeklarasikan parameter dan menentukan atributnya. Parameter di sini mencakup variabel biasa, array, dan associative array.

```bash
typeset username="user"
typeset -i count=10
typeset -a tools=(git fzf nvim)
typeset -A editor=(name nvim type terminal)
```

Arti setiap deklarasi:

| Kode                      | Fungsi                            |
| ------------------------- | --------------------------------- |
| `typeset username="user"` | Mendeklarasikan parameter biasa   |
| `typeset -i count=10`     | Memberi atribut integer           |
| `typeset -a tools=(...)`  | Mendeklarasikan indexed array     |
| `typeset -A editor=(...)` | Mendeklarasikan associative array |

Contoh atribut integer:

```bash
typeset -i count=10
count=count+5

print -r -- "$count"
```

Hasil:

```bash
15
```

Karena `count` memiliki atribut integer, Zsh memperlakukan nilainya sebagai bilangan dalam operasi aritmetika.

`typeset` juga berkaitan dengan cakupan variabel. Di dalam fungsi, deklarasi `local` merupakan cara yang lazim untuk membuat variabel lokal:

```bash
show_message() {
    local message="Halo dari fungsi"
    print -r -- "$message"
}

show_message
```

Variabel `message` berlaku lokal di dalam fungsi tersebut, bukan sebagai variabel global biasa.

Konsep utama: `typeset` bukan sekadar cara lain menulis `name=value`. Ia juga mengatur bagaimana parameter diperlakukan oleh Zsh. Kita akan menggunakan konsep ini lagi ketika menyusun fungsi dan konfigurasi modular.

### 07.7 — `functions`: memeriksa definisi fungsi

Zsh memiliki builtin `functions` yang dapat digunakan untuk menampilkan definisi fungsi yang sudah dikenal oleh shell.

```bash
my_greeting() {
    print -r -- "Halo"
}
```

Setelah fungsi didefinisikan, jalankan:

```bash
functions my_greeting
```

Zsh akan menampilkan definisi fungsi tersebut.

Untuk memeriksa apakah suatu nama dikenali sebagai fungsi, gunakan:

```bash
whence -w my_greeting
```

Keduanya memiliki tujuan berbeda:

- `functions my_greeting` — menampilkan isi definisi fungsi.
- `whence -w my_greeting` — memeriksa jenis perintah yang dikenali dengan nama tersebut.

Kemampuan membaca definisi fungsi akan berguna ketika Anda mulai memeriksa plugin Zsh dan mencari tahu bagaimana sebuah fitur diimplementasikan.

### 07.8 — `autoload`: memuat fungsi saat dibutuhkan

Biasanya, fungsi harus didefinisikan atau dimuat sebelum digunakan. `autoload` memungkinkan Zsh menandai fungsi agar definisinya dimuat ketika fungsi tersebut pertama kali dipanggil.

Alurnya:

File fungsi berada di direktori `$fpath`

`autoload -Uz nama_fungsi`

Fungsi dipanggil

Zsh mencari dan memuat definisinya

Kita bisa menguji mekanisme ini dalam direktori sementara.

Pertama, buat direktori untuk menyimpan fungsi:

```bash
mkdir -p ~/zsh-functions
```

Buat file `~/zsh-functions/hello_zsh` dengan isi berikut:

```bash
print -r -- "Fungsi autoload berhasil dipanggil"
```

Pada format native Zsh yang digunakan contoh ini, file tersebut berisi isi fungsi secara langsung, tanpa pembungkus `hello_zsh() { ... }`.

Kemudian, di sesi Zsh yang sama:

```bash
fpath=(~/zsh-functions $fpath)
autoload -Uz hello_zsh
hello_zsh
```

Hasilnya:

```bash
Fungsi autoload berhasil dipanggil
```

Penjelasan setiap perintah:

- `fpath` — array direktori tempat Zsh mencari fungsi yang dapat dimuat.
- `autoload` — menandai `hello_zsh` sebagai fungsi autoload.
- `-U` — mencegah ekspansi alias saat definisi fungsi dimuat.
- `-z` — memilih gaya autoload native Zsh.
- `hello_zsh` — memanggil fungsi sehingga Zsh memuat definisinya.

Perubahan `fpath` di atas hanya berlaku pada sesi saat ini. Belum ada konfigurasi permanen yang diubah.

Mengapa ini penting untuk konfigurasi Zsh? Fungsi dapat disimpan dalam file terpisah dan dimuat sesuai kebutuhan, alih-alih mendefinisikan semua fungsi sekaligus di `.zshrc`. Mekanisme ini akan dibahas lebih mendalam pada bagian fungsi dan autoload dalam kurikulum.

### 07.9 — `cd`, `pushd`, `popd`, dan `dirs`

Keempat builtin ini berhubungan dengan direktori kerja, tetapi tidak memiliki fungsi yang sama.

| Builtin | Kegunaan                                                                |
| ------- | ----------------------------------------------------------------------- |
| `cd`    | Berpindah direktori                                                     |
| `pushd` | Berpindah direktori sambil menyimpan direktori dalam directory stack    |
| `popd`  | Menghapus entri teratas stack sekaligus berpindah ke direktori tersebut |
| `dirs`  | Menampilkan directory stack                                             |

Coba urutan berikut:

```bash
cd ~
pushd /tmp
dirs -v
popd
```

Mekanismenya:

1. `cd ~` berpindah ke direktori home.
2. `pushd /tmp` berpindah ke `/tmp` dan menyimpan direktori sebelumnya dalam directory stack.
3. `dirs -v` menampilkan isi stack dengan nomor indeks.
4. `popd` menghapus entri teratas stack dan kembali ke direktori yang tersimpan di sana.

Directory stack berguna ketika Anda perlu berpindah di antara beberapa direktori tanpa harus mengetik seluruh path berulang kali.

Perhatikan perbedaannya dengan variabel `$PWD`: `$PWD` menunjukkan direktori kerja saat ini, sedangkan directory stack menyimpan daftar direktori untuk navigasi.

<details>
  <summary>📃 Latihan</summary>

---

Coba jawab berdasarkan pemahaman Anda. Tidak perlu menjalankan semua perintah terlebih dahulu.

- #### **1. Apa perbedaan utama `typeset -a` dan `typeset -A`?**


`-a` untuk indexed array, `-A` untuk associative array

`-a` untuk alias, `-A` untuk array biasa

Keduanya sama

- #### **2. Apa peran `$fpath` ketika menggunakan `autoload`?**

Menyimpan riwayat perintah

Menentukan direktori pencarian file fungsi

Menyimpan direktori kerja saat ini

- #### **3. Apa yang dilakukan `popd`?**

**Menghapus semua fungsi**

Menghapus entri teratas directory stack dan berpindah ke direktori tersebut

Hanya menampilkan directory stack

- #### **4. Perintah mana yang menampilkan definisi fungsi `my_greeting`?**

`functions my_greeting`

`dirs my_greeting`

`autoload -Uz my_greeting`


</details>

---

## Builtins & Native Features (Penyempurnaan)

### 07.10 — `read`: menerima input

`read` adalah builtin yang membaca input, biasanya dari standard input, lalu menyimpan hasilnya ke parameter.

Contoh:

```bash
read -r username
print -r -- "Nama: $username"
```

Saat dijalankan, Zsh menunggu Anda memasukkan teks. Setelah menekan Enter, teks tersebut disimpan ke `username`.

Opsi `-r` membuat `read` memperlakukan backslash sebagai karakter biasa, bukan sebagai karakter escape.

Agar pengguna mendapat petunjuk sebelum memasukkan input, Anda dapat menggunakan `-p` pada Zsh:

```bash
read -r "username?Masukkan nama: "
print -r -- "Nama: $username"
```

Perhatikan perbedaan sintaksnya: format `read -r "parameter?prompt"` merupakan bentuk khusus Zsh, bukan sintaks portabel untuk semua shell.

Untuk membaca input dengan batas waktu:

```bash
if read -r -t 5 "answer?Jawab dalam 5 detik: "; then
    print -r -- "Input: $answer"
else
    print -r -- "Input tidak diterima tepat waktu."
fi
```

`-t 5` membatasi waktu tunggu hingga lima detik. Nilai status keluarnya menentukan apakah pembacaan berhasil, sehingga dapat digunakan dalam `if`.

### 07.11 — `source` dan `.`: menjalankan file dalam shell saat ini

Keduanya digunakan untuk membaca dan menjalankan isi file dalam lingkungan shell yang sedang berjalan.

Misalnya, file `settings.zsh` berisi:

```bash
MY_EDITOR="nvim"
```

Anda dapat memuatnya dengan:

```bash
source ./settings.zsh
print -r -- "$MY_EDITOR"
```

Hasilnya:

```bash
nvim
```

Zsh juga mendukung bentuk berikut:

```bash
. ./settings.zsh
```

Mengapa ini penting? File konfigurasi modular sering dimuat dari `.zshrc` menggunakan `source`. Variabel, fungsi, dan perubahan opsi dari file tersebut berlaku pada shell yang memuatnya.

Jangan menyamakan `source` dengan menjalankan file sebagai proses terpisah. Ketika file dijalankan melalui `source`, perubahan pada lingkungan shell dapat tetap berlaku setelah file selesai dibaca.

### 07.12 — `zmodload`: memuat modul Zsh

Zsh memiliki sistem modul yang dapat menyediakan fitur tambahan bagi shell. `zmodload` merupakan builtin untuk memuat atau memeriksa modul tersebut.

Untuk melihat modul yang telah dimuat:

```bash
zmodload
```

Untuk memuat modul tertentu, sintaks umumnya:

```bash
zmodload nama_modul
```

Nama modul harus benar-benar tersedia pada instalasi Zsh Anda. Jangan menganggap semua modul terpasang atau sudah dimuat secara otomatis.

Modul merupakan salah satu mekanisme native yang akan relevan saat mempelajari fitur internal Zsh. Untuk sekarang, cukup pahami pembagian ini:

- Builtin adalah perintah yang disediakan langsung oleh shell, seperti `read`, `source`, dan `zmodload`.
- Modul adalah komponen yang dapat dimuat untuk menyediakan kemampuan tertentu.
- Fungsi autoload adalah fungsi yang definisinya dapat dimuat ketika dibutuhkan.

Detail modul dan pemanfaatannya akan dipelajari pada bagian internals, sesuai urutan kurikulum.


<details>
  <summary>📃 Latihan lanjutan</summary>

---

Coba jelaskan dengan kata-kata Anda sendiri:

**1. Mengapa `source settings.zsh` dapat membuat variabel dari file tersebut tersedia pada shell saat ini?**
**2. Apa perbedaan peran `read` dan `print`?**
**3. Apa hubungan antara `zmodload` dan modul Zsh?**
**4. Mengapa fungsi yang dimuat melalui `autoload` berbeda dari perintah eksternal seperti `ls`?**


</details>

---

## Builtins & Native Features (Penyelesaian)

### 07.13 — `command`, `builtin`, dan `exec`

Ketiganya memengaruhi cara Zsh menjalankan perintah, tetapi mekanismenya berbeda.

1\. `command` — melewati pencarian fungsi shell

Misalnya Anda membuat fungsi bernama `ls`:

```bash
ls() {
    print -r -- "Ini fungsi ls"
}
```

Saat menjalankan:

```bash
ls
```

Zsh memanggil fungsi tersebut. Untuk meminta Zsh mencari perintah eksternal bernama `ls` tanpa memanggil fungsi `ls` itu, gunakan:

```bash
command ls
```

Catatan: `command` tidak dengan sendirinya menonaktifkan ekspansi alias. Jika nama perintah memiliki alias aktif, alias tetap perlu diperhitungkan.

2\. `builtin` — memaksa pemanggilan builtin

```bash
cd /tmp
builtin cd ~
```

`builtin cd ~` secara eksplisit memanggil builtin `cd`, bukan fungsi shell yang kebetulan bernama `cd`.

3\. `exec` — mengganti proses shell

```bash
exec program
```

Dalam penggunaan normal, `exec` mengganti proses shell saat ini dengan `program`, alih-alih membuat shell tetap berjalan setelah program selesai. Karena itu, jangan mencoba perintah ini secara sembarangan pada sesi terminal utama jika Anda masih ingin mempertahankan shell tersebut.

Perbedaan intinya:

| Perintah       | Tujuan                                                            |
| -------------- | ----------------------------------------------------------------- |
| `command nama` | Menjalankan perintah tanpa memanggil fungsi shell dengan nama itu |
| `builtin nama` | Memanggil builtin Zsh secara eksplisit                            |
| `exec nama`    | Mengganti proses shell dengan program yang dijalankan             |

### 07.14 — `eval`: mengevaluasi teks sebagai kode shell

`eval` meminta shell mem-parsing dan menjalankan teks sebagai perintah shell.

```bash
name="Zsh"
eval 'print -r -- "$name"'
```

Hasil:

```bash
Zsh
```

Perhatikan bahwa teks yang diteruskan ke `eval` diproses sebagai kode shell. Ini berbeda dari `print`, yang sekadar menampilkan teks.

Contoh berisiko:

```bash
eval "$user_input"
```

Jika `user_input` berisi teks dari sumber yang tidak tepercaya, teks itu dapat dijalankan sebagai perintah. Karena itu, hindari `eval` jika kebutuhan Anda bisa diselesaikan menggunakan array, parameter expansion, atau pemanggilan perintah biasa.

Untuk tujuan mempelajari konfigurasi Zsh, Anda perlu mengenali `eval` ketika membaca plugin, tetapi tidak perlu menjadikannya solusi default.

---

<details>
  <summary>📃 Ringkasan Lesson 07 dengan sedikit latihan akhir</summary>

### Pada bagian ini, Anda telah mempelajari kelompok builtin dan mekanisme native berikut:

- `whence` untuk memeriksa jenis perintah.
- `print` dan `read` untuk output dan input.
- `typeset` untuk parameter dan atributnya.
- `functions` dan `autoload` untuk definisi serta pemuatan fungsi.
- `cd`, `pushd`, `popd`, dan `dirs` untuk navigasi direktori.
- `source` untuk memuat konfigurasi ke shell saat ini.
- `zmodload` untuk mekanisme modul.
- `command`, `builtin`, `exec`, dan `eval` untuk memahami cara perintah dijalankan.

Daftar tersebut merupakan pengenalan konsep penting, bukan seluruh builtin Zsh. Referensi lengkapnya adalah manual `zshbuiltins(1)`.

### Latihan akhir: tanpa menjalankan kode, jelaskan perbedaan `command ls`, `builtin cd /tmp`, dan `exec ls`. Jelaskan juga mengapa `eval "$user_input"` berisiko.

</details>

---

Setelah latihan ini, kita dapat melanjutkan ke bagian berikutnya **Lesson 08 — Functions & Autoload,** dengan fokus lebih dalam pada definisi fungsi, parameter fungsi, cakupan variabel, dan cara Zsh memuat fungsi dari file.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
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

