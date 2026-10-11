# Lesson 13 — Prompt Zsh

Prompt adalah tampilan yang menunjukkan bahwa Zsh siap menerima perintah. Di Zsh, prompt dapat diprogram melalui parameter seperti `PROMPT` dan `RPROMPT`, serta mekanisme ekspansi khusus untuk menampilkan informasi dinamis.

Tujuan materi ini adalah memahami prompt bawaan Zsh terlebih dahulu sebelum mempelajari Starship atau membuat prompt kustom untuk konfigurasi dotfiles Anda.

## 1. Mengenal `PROMPT` dan `RPROMPT`

PROMPT — kiri

\~/dotfiles on main ❯&#x20;

Prompt utama tempat Anda mengetik perintah.

RPROMPT — kanan

❯

15:30

Prompt tambahan yang ditampilkan di sisi kanan jika terminal mendukung ruang yang cukup.

`PROMPT` adalah parameter untuk prompt utama, sedangkan `RPROMPT` digunakan untuk prompt di sisi kanan. `PS1` merupakan nama lain yang berkaitan dengan prompt utama.

Coba di terminal Zsh:

```
PROMPT='%n@%m %~ %# '
```

Komponen tersebut memiliki arti:

- `%n` — nama pengguna.
- `%m` — nama host, biasanya dipendekkan.
- `%~` — direktori kerja dengan `~` untuk home.
- `%#` — penanda prompt yang berbeda menurut status pengguna.

Kemudian coba:

```
RPROMPT='%*'
```

`%*` menampilkan waktu dalam format jam, menit, dan detik. Kedua perubahan ini hanya memengaruhi sesi shell saat ini; belum mengubah konfigurasi permanen.

## 2. Escape sequence khusus prompt Zsh

Zsh memiliki format `%` khusus yang dievaluasi saat prompt ditampilkan. Ini berbeda dari variabel shell biasa.

Berikut beberapa sequence yang sering digunakan:

| Sequence | Fungsi                                     |
| -------- | ------------------------------------------ |
| `%n`     | Nama pengguna                              |
| `%m`     | Nama host                                  |
| `%~`     | Direktori kerja dengan home disingkat      |
| `%d`     | Direktori kerja                            |
| `%#`     | Penanda prompt berdasarkan status pengguna |
| `%?`     | Status keluar perintah sebelumnya          |
| `%h`     | Nomor entri history saat ini               |
| `%*`     | Waktu saat ini, termasuk detik             |
| `%D`     | Tanggal dalam format `yy-mm-dd`            |

Contoh prompt yang lebih informatif:

```
PROMPT='[%D] %n@%m:%~ %# '
```

Contoh tampilan konseptual:

```
[26-10-11] user@arch:~/dotfiles ❯
```

Nilai aktual bergantung pada pengguna, hostname, direktori, dan konfigurasi terminal Anda.

Perhatikan perbedaan ini:

```
PROMPT='$HOME %# '
```

dan:

```
PROMPT='%~ %# '
```

Pada contoh pertama, `$HOME` berada dalam tanda kutip tunggal sehingga nilainya tidak diekspansi saat assignment. Pada contoh kedua, `%~` merupakan sequence prompt yang dievaluasi oleh Zsh ketika prompt ditampilkan.

## 3. Warna dan format teks

Zsh memiliki sequence format untuk mengatur warna serta gaya teks prompt.

```
PROMPT='%F{green}%n%f %F{blue}%~%f %# '
```

Sequence yang digunakan:

- `%F{green}` — mulai menggunakan warna teks hijau.
- `%f` — mengembalikan warna teks ke kondisi normal.
- `%B` — mulai format tebal.
- `%b` — mengakhiri format tebal.
- `%U` dan `%u` — memulai dan mengakhiri garis bawah.

Contoh dengan teks tebal:

```
PROMPT='%B%n%b %F{cyan}%~%f %# '
```

Warna bernama seperti `green`, `blue`, dan `cyan` dapat dipakai untuk percobaan awal. Warna yang terlihat sebenarnya dipengaruhi oleh tema terminal dan palet warnanya.

Untuk sekarang, gunakan sequence bawaan Zsh ini daripada menambahkan kode warna ANSI mentah. Ini membuat prompt lebih mudah dibaca dan dirawat.

## 4. Menampilkan status perintah sebelumnya

Sequence `%?` dapat menampilkan status keluar dari perintah sebelumnya. Status `0` biasanya berarti berhasil, sedangkan nilai bukan nol biasanya menandakan kegagalan.

```
PROMPT='[%?] %~ %# '
```

Coba jalankan:

```
true
false
```

Setelah masing-masing perintah selesai, amati angka di prompt. `true` biasanya menghasilkan status `0`, sedangkan `false` menghasilkan status `1`.

Ini berguna untuk prompt yang ingin menunjukkan apakah perintah sebelumnya berhasil tanpa harus mengetik `echo $?` secara manual.

## 5. Menampilkan hasil perintah dalam prompt

Terkadang Anda ingin prompt menampilkan informasi dinamis, misalnya branch Git. Namun, sequence `%` bawaan saja tidak cukup untuk menjalankan sembarang perintah.

Zsh memiliki opsi `PROMPT_SUBST` yang mengaktifkan ekspansi parameter, substitusi perintah, dan ekspansi aritmetika pada prompt.

Contoh eksperimental:

```
setopt PROMPT_SUBST
PROMPT='$(date +%H:%M:%S) %# '
```

Prompt akan menjalankan `date` ketika perlu ditampilkan. Perintah tersebut dapat dieksekusi berulang kali, sehingga pemanggilan program eksternal yang berat dapat membuat prompt terasa lambat.

Jangan aktifkan `PROMPT_SUBST` tanpa memahami efeknya pada konfigurasi Anda. Prompt yang berasal dari sumber tepercaya lebih mudah diamankan dan dipelihara dibandingkan prompt yang menyisipkan teks tidak tepercaya sebagai kode shell.

Untuk tahap ini, utamakan sequence prompt bawaan seperti `%~`, `%n`, dan `%?`.

## 6. Menyimpan konfigurasi prompt secara modular

Karena konfigurasi Anda menggunakan struktur `~/.config/zsh/`, pengaturan prompt dapat dipisahkan ke dalam `prompt.zsh`.

Contoh isi file tersebut:

```
PROMPT='%F{green}%n%f %F{blue}%~%f %# '
RPROMPT='[%?]'
```

Lalu muat file itu dari `zshrc`:

```
if [[ -r "$HOME/.config/zsh/prompt.zsh" ]]; then
    source "$HOME/.config/zsh/prompt.zsh"
fi
```

Dengan cara ini, pengaturan prompt tidak bercampur dengan history, alias, atau keybinding.

Jika konfigurasi Anda sudah menggunakan Starship, file tersebut mungkin menginisialisasi prompt melalui mekanismenya sendiri. Jangan langsung menambahkan assignment `PROMPT` di bawah inisialisasi Starship tanpa memeriksa urutan konfigurasi, karena assignment manual dapat menggantikan prompt yang dihasilkan Starship.

## 7. Latihan

Jalankan setiap percobaan secara terpisah di terminal:

```
PROMPT='%n@%m:%~ %# '
```

Kemudian:

```
RPROMPT='%D %*'
```

Terakhir:

```
PROMPT='[%?] %F{cyan}%~%f %# '
```

Amati perubahan yang terjadi. Untuk mengembalikan prompt sederhana:

```
PROMPT='%~ %# '
RPROMPT=''
```

Tidak ada file konfigurasi permanen yang diubah oleh percobaan ini.

Inti pelajaran: prompt Zsh bukan sekadar teks statis. Ia memiliki sequence khusus, format warna, informasi status perintah, serta opsi untuk menjalankan ekspansi dinamis. Menguasai mekanisme bawaan ini akan memudahkan Anda membaca konfigurasi prompt yang lebih kompleks.

Materi berikutnya: Lesson 14 — Completion System, yaitu bagaimana Zsh melengkapi nama file, direktori, perintah, opsi, dan argumen program melalui sistem completion bawaannya.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-13/README.md
[selanjutnya]: ../bagian-15/README.md

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

