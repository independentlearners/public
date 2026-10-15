# Lanjutan

## Pelajaran 29 — Hooks Tingkat Lanjut dalam Zsh

Hooks memungkinkan Anda menjalankan fungsi secara otomatis ketika peristiwa tertentu terjadi di shell. Ini merupakan mekanisme penting untuk membuat fitur Zsh sendiri tanpa harus mengubah kode inti shell atau menimpa fungsi milik plugin lain.

## 1. Memahami perbedaan setiap hook

| Hook       | Kapan dijalankan                                                 |
| ---------- | ---------------------------------------------------------------- |
| `precmd`   | Sebelum prompt ditampilkan.                                      |
| `preexec`  | Sebelum perintah interaktif yang dimasukkan pengguna dieksekusi. |
| `chpwd`    | Setelah direktori kerja berubah.                                 |
| `periodic` | Secara berkala, berdasarkan konfigurasi interval.                |
| `zshexit`  | Ketika shell keluar secara normal.                               |

Hooks ini memiliki tujuan berbeda. Misalnya, `precmd` cocok untuk memperbarui informasi prompt, sedangkan `chpwd` cocok untuk mendeteksi perpindahan direktori.

## 2. Mendaftarkan hook tanpa menimpa hook lain

Gunakan `add-zsh-hook`, bukan mendefinisikan ulang mekanisme hook secara langsung.

```
autoload -Uz add-zsh-hook

report_directory() {
    print -r -- "Direktori saat ini: $PWD"
}

add-zsh-hook chpwd report_directory
```

Penjelasan:

- `autoload -Uz add-zsh-hook` memuat fungsi bantuan bawaan Zsh ketika dibutuhkan.
- `report_directory` adalah fungsi yang akan dijalankan.
- `add-zsh-hook chpwd report_directory` mendaftarkan fungsi tersebut untuk peristiwa `chpwd`.

Setelah kode ini dimuat, setiap perpindahan direktori yang memicu `chpwd` akan menjalankan fungsi tersebut.

Contohnya:

```
cd /tmp
```

Keluaran yang diharapkan:

```
Direktori saat ini: /tmp
```

Hook ini tidak menjalankan `cd` untuk Anda. Ia hanya bereaksi setelah direktori kerja berubah.

## 3. Mengapa registrasi hook lebih baik daripada menimpa hook?

Bayangkan sebuah plugin sudah menggunakan `chpwd` untuk memperbarui informasi proyek. Anda kemudian menambahkan kode berikut:

```
chpwd() {
    print -r -- "$PWD"
}
```

Definisi tersebut dapat menggantikan fungsi `chpwd` yang sudah ada. Akibatnya, perilaku sebelumnya mungkin hilang.

Pendekatan yang lebih aman:

```
autoload -Uz add-zsh-hook

my_chpwd_feature() {
    print -r -- "$PWD"
}

add-zsh-hook chpwd my_chpwd_feature
```

Dengan cara ini, fitur Anda didaftarkan sebagai hook tersendiri. Ini mengurangi risiko benturan dengan plugin lain.

Namun, dua fungsi yang terdaftar pada hook yang sama masih dapat memengaruhi hasil akhir apabila keduanya mengubah state shell atau menjalankan perintah yang saling bertentangan.

## 4. Menghapus hook

Anda dapat membatalkan registrasi fungsi:

```
add-zsh-hook -d chpwd my_chpwd_feature
```

Opsi `-d` menghapus fungsi yang ditentukan dari daftar hook tersebut.

Ini berguna ketika Anda sedang menguji fitur atau ingin menonaktifkan integrasi tertentu tanpa menghapus seluruh konfigurasi.

Untuk mempelajari implementasi dan opsi yang tersedia:

```
autoload -Uz add-zsh-hook
whence -v add-zsh-hook
```

Perintah kedua membantu memeriksa bagaimana Zsh menemukan fungsi tersebut.

## 5. Menggunakan `precmd` dan `preexec`

Kedua hook ini sering dipakai untuk integrasi prompt, pencatatan waktu perintah, dan informasi status shell.

Coba contoh berikut dalam sesi uji:

```
autoload -Uz add-zsh-hook

before_prompt() {
    print -r -- "Prompt akan ditampilkan."
}

before_command() {
    print -r -- "Perintah akan dieksekusi."
}

add-zsh-hook precmd before_prompt
add-zsh-hook preexec before_command
```

`before_prompt` berjalan sebelum prompt ditampilkan. `before_command` berjalan sebelum perintah interaktif dieksekusi.

Perhatikan bahwa `preexec` bukan pengganti fungsi shell biasa: hook ini mengamati siklus eksekusi perintah interaktif, bukan dipanggil secara manual untuk setiap perintah di dalam skrip.

## 6. Tempatkan kode hook di konfigurasi modular

Dalam struktur konfigurasi Anda, hook dapat ditempatkan di file khusus, misalnya:

```
~/.config/zsh/
├── zshrc
├── hooks.zsh
└── integrations/
```

Kemudian muat `hooks.zsh` dari `zshrc` pada urutan yang sesuai:

```
[[ -r "$ZDOTDIR/hooks.zsh" ]] && source "$ZDOTDIR/hooks.zsh"
```

Gunakan jalur tersebut hanya jika `ZDOTDIR` memang menunjuk ke `~/.config/zsh`. Karena konfigurasi Anda memakai `~/.config/zsh/zshrc`, pastikan nilai `ZDOTDIR` dan lokasi file startup benar sebelum menambahkan baris ini.

Latihan: buat satu fungsi untuk hook `chpwd`, uji dengan berpindah direktori, lalu hapus registrasinya menggunakan `add-zsh-hook -d`.

Materi berikutnya adalah autoload functions dan `$fpath` secara lebih mendalam—bagaimana Zsh menemukan, memuat, dan menjalankan fungsi secara otomatis, serta bagaimana mekanisme ini dipakai oleh plugin dan sistem completion.



> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
<!-- > - **[Selanjutnya][selanjutnya]** -->
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-20/README.md
<!-- [selanjutnya]: ../bagian-17/README.md -->

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

