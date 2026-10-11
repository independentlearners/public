# Lesson 15 — ZLE (Zsh Line Editor)

ZLE adalah singkatan dari Zsh Line Editor. Ini adalah komponen Zsh yang mengelola baris perintah yang sedang Anda edit sebelum dikirim untuk dieksekusi.

ZLE merupakan fondasi penting untuk tujuan Anda: membuat fitur keyboard sendiri, memodifikasi input perintah, dan memahami cara kerja plugin produktivitas Zsh.

## 1. Memahami posisi ZLE

Saat Anda mengetik perintah di terminal, alurnya secara sederhana seperti ini:

```
Keyboard
│
└─▶ Karakter dan tombol yang ditekan
     │
     ├─▶ [SEBELUM Enter] ZLE
     │      │
     │      └─▶ Mengedit baris, memindahkan kursor, menjalankan widget
     │
     └─▶ [SESUDAH Enter] Zsh memproses perintah
            │
            └─▶ Setelah Anda menekan EnterContohnya, ketika Anda mengetik:


```
```
print -r -- "Halo"
```

ZLE mengelola teks tersebut ketika Anda mengetik, menghapus karakter, memindahkan kursor, atau mengedit argumen. Setelah Anda menekan Enter, Zsh memproses baris perintah itu.

Artinya, ZLE mengelola proses penyuntingan input interaktif, bukan menggantikan interpreter Zsh.

## 2. Widget: fungsi yang dapat dijalankan melalui ZLE

ZLE menyediakan widget, yaitu operasi yang dapat dipanggil untuk melakukan tindakan pada editor baris perintah.

Beberapa contoh widget bawaan:

- `backward-char` — memindahkan kursor ke kiri.
- `forward-char` — memindahkan kursor ke kanan.
- `backward-delete-char` — menghapus karakter sebelum kursor.
- `accept-line` — menerima baris perintah, biasanya ketika Enter ditekan.
- `clear-screen` — membersihkan tampilan layar terminal.

Anda dapat memeriksa binding tombol yang tersedia:

```
bindkey
```

Untuk memeriksa binding tombol tertentu, misalnya Ctrl+A:

```
bindkey '^A'
```

Hasilnya bergantung pada keymap aktif dan konfigurasi Anda.

## 3. Keymap dan `bindkey`

Keymap adalah kumpulan pemetaan antara input keyboard dan widget. Zsh dapat memiliki keymap berbeda untuk perilaku seperti mode emacs dan vi.

Karena konfigurasi Anda menggunakan vi mode, periksa keymap yang tersedia:

```
bindkey -l
```

Kemudian periksa keymap aktif:

```
bindkey -L
```

Untuk melihat pemetaan dalam keymap vi insert, Anda dapat mencoba:

```
bindkey -M viins
```

Jika keymap `viins` tersedia, perintah tersebut menampilkan binding yang terkait dengan mode insert vi.

Pemetaan tombol dapat diubah dengan `bindkey`. Misalnya, binding berikut menghubungkan Ctrl+X dengan widget `clear-screen` pada keymap saat ini:

```
bindkey '^X' clear-screen
```

Gunakan contoh tersebut hanya untuk percobaan. Binding Ctrl+X yang sudah ada bisa tertimpa, sehingga sebaiknya periksa binding lama sebelum mengubah konfigurasi permanen.

## 4. Membuat widget ZLE sendiri

Sekarang kita membuat fitur sederhana. Ketika Anda menekan Ctrl+G, ZLE akan mengganti isi baris perintah dengan teks yang telah ditentukan.

```
zsh_lesson_widget() {
    BUFFER='print -r -- "Halo dari ZLE"'
    CURSOR=${#BUFFER}
}

zle -N zsh_lesson_widget
bindkey '^G' zsh_lesson_widget
```

Jalankan kode tersebut di terminal Zsh interaktif.

Cara kerjanya:

1. `zsh_lesson_widget()` mendefinisikan fungsi shell.
2. `BUFFER` adalah parameter khusus ZLE yang berisi teks baris perintah yang sedang diedit.
3. `CURSOR` menentukan posisi kursor di dalam buffer. `${#BUFFER}` menempatkannya di akhir teks.
4. `zle -N zsh_lesson_widget` mendaftarkan fungsi sebagai widget ZLE.
5. `bindkey '^G' zsh_lesson_widget` menghubungkan Ctrl+G dengan widget pada keymap saat ini.

Setelah kode dimuat, tekan Ctrl+G saat prompt siap menerima input. Teks perintah akan muncul di baris input, tetapi tidak langsung dijalankan. Tekan Enter jika ingin mengeksekusinya.

Karena Anda menggunakan vi mode, binding juga dapat dipasang secara khusus pada keymap insert:

```
bindkey -M viins '^G' zsh_lesson_widget
```

Periksa binding Ctrl+G yang sudah ada sebelum menggunakannya agar tidak menimpa fungsi tombol yang masih Anda perlukan.

## 5. Memahami `BUFFER`, `LBUFFER`, `RBUFFER`, dan `CURSOR`

Keempat parameter ini penting saat membuat widget yang memodifikasi command line.

| Parameter | Fungsi                                               |
| --------- | ---------------------------------------------------- |
| `BUFFER`  | Seluruh teks pada baris perintah yang sedang diedit. |
| `LBUFFER` | Bagian teks di sebelah kiri kursor.                  |
| `RBUFFER` | Bagian teks di sebelah kanan kursor.                 |
| `CURSOR`  | Posisi kursor di dalam buffer.                       |

Misalnya, jika baris input berisi `git commit` dan kursor berada di antara `git` dan `commit`, `LBUFFER` berisi teks di sebelah kiri kursor, sedangkan `RBUFFER` berisi teks di sebelah kanannya.

Ini memungkinkan Anda membuat fitur seperti menyisipkan teks pada posisi kursor, membungkus teks dengan karakter tertentu, atau memodifikasi sebagian input tanpa mengganti seluruh baris.

Contoh widget yang menambahkan awalan ke input:

```
zsh_prefix_widget() {
    LBUFFER='sudo ' 
}

zle -N zsh_prefix_widget
bindkey '^X^S' zsh_prefix_widget
```

Ketika dipanggil, widget menambahkan `sudo ` di sebelah kiri kursor. Contoh ini hanya untuk demonstrasi; jangan gunakan secara membabi buta pada perintah yang tidak seharusnya dijalankan dengan hak akses lebih tinggi.

## 6. Menempatkan widget dalam konfigurasi modular

Jika widget sudah diuji dan ingin dipertahankan, simpan definisinya dalam file, misalnya:

```
~/.config/zsh/
├── zshrc
└── keybinds.zsh
```

Contoh isi `keybinds.zsh`:

```
zsh_lesson_widget() {
    BUFFER='print -r -- "Halo dari ZLE"'
    CURSOR=${#BUFFER}
}

zle -N zsh_lesson_widget
bindkey -M viins '^G' zsh_lesson_widget
```

Muat file tersebut dari `zshrc` setelah konfigurasi vi mode diaktifkan:

```
if [[ -r "$HOME/.config/zsh/keybinds.zsh" ]]; then
    source "$HOME/.config/zsh/keybinds.zsh"
fi
```

Pemisahan ini membuat definisi widget dan binding keyboard lebih mudah dipelihara daripada mencampurkannya dengan history, prompt, atau pengaturan environment.

## Inti pelajaran

- ZLE mengelola penyuntingan baris perintah interaktif.
- Widget adalah operasi yang dapat dijalankan oleh ZLE.
- Keymap menentukan kumpulan binding tombol yang berlaku.
- `bindkey` menghubungkan input keyboard dengan widget.
- `BUFFER`, `LBUFFER`, `RBUFFER`, dan `CURSOR` memungkinkan widget memanipulasi teks yang sedang diedit.

Materi berikutnya adalah Lesson 16 — ZLE Widgets dan Keymaps lebih lanjut: memahami widget bawaan, perbedaan mode vi insert dan command, cara membungkus widget yang sudah ada, serta cara membuat binding yang tidak merusak perilaku default Zsh.


> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-15/README.md
[selanjutnya]: ../bagian-17/README.md

<!-- [selanjutnya]: ../bagian-3/README.md -->

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

