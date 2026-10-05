# Lesson 00.1 — Memahami Zsh sebagai Shell

Kita mulai benar-benar dari awal, tetapi tidak mengulang Bash secara panjang. Karena Anda sudah memiliki fondasi Bash, materi akan selalu diarahkan pada pertanyaan:

> **Apa yang berbeda dari Zsh, dan mengapa perbedaan itu penting untuk konfigurasi serta pengembangan fitur terminal?**

Materi sebelumnya menetapkan bahwa fokus kita adalah Zsh sebagai **programmable interactive shell**, bukan sekadar bahasa scripting. 

### 1. Apa sebenarnya Zsh?

Zsh adalah **shell Unix** yang dapat berfungsi sebagai command interpreter sekaligus interactive shell yang sangat dapat dikustomisasi.

Secara sederhana:

```text
Terminal Emulator
       │
       ▼
      Zsh
       │
       ├── menerima command
       ├── melakukan parsing
       ├── melakukan expansion
       ├── menjalankan program
       ├── mengelola environment
       └── menyediakan interactive features
              │
              ├── completion
              ├── history
              ├── prompt
              ├── key binding
              ├── ZLE
              ├── widget
              └── hooks
```

Bagian terakhir inilah yang akan menjadi fokus utama kita.

Bash juga mempunyai kemampuan interactive, tetapi Zsh menyediakan mekanisme yang sangat kaya untuk memprogram perilaku shell. Dalam kurikulum kita, ini kemudian membawa kita menuju `bindkey`, ZLE, completion, widgets, hooks, dan konfigurasi modular. 

### 2. Zsh bukan terminal

Ini konsep pertama yang harus benar-benar jelas.

```text
Terminal Emulator
        │
        │ input/output
        ▼
      Shell
        │
        ▼
     Program
```

Misalnya Anda menggunakan:

```text
foot
```

Maka kira-kira:

```text
foot
 │
 └── zsh
      │
      ├── git
      ├── nvim
      ├── yazi
      ├── fzf
      └── ...
```

`foot` adalah terminal emulator.

`zsh` adalah shell.

`git`, `nvim`, `yazi`, dan sebagainya adalah program yang dijalankan oleh shell.

Ini penting karena nanti ketika kita membuat fitur Zsh, kita perlu mengetahui apakah sebuah kemampuan berasal dari:

```text
Zsh
atau
program eksternal
atau
terminal emulator
```

---

## 3. Interactive shell

Interactive shell adalah shell yang menerima input secara langsung dari pengguna.

Contohnya Anda membuka terminal dan mendapatkan:

```text
~
❯
```

Kemudian mengetik:

```zsh
ls
```

Zsh membaca input tersebut dan memprosesnya.

Secara konseptual:

```text
keyboard
   │
   ▼
terminal emulator
   │
   ▼
Zsh
   │
   ├── parsing
   ├── expansion
   ├── command lookup
   └── execution
          │
          ▼
         ls
```

Nanti kita akan masuk sangat dalam ke bagian sebelum execution tersebut.

Misalnya:

```zsh
echo **/*.lua
```

Zsh tidak sekadar meneruskan string tersebut kepada `echo`.

Zsh dapat melakukan filename generation terlebih dahulu.

Inilah alasan kita akan mempelajari expansion dan glob secara khusus.

---

# 4. Login shell vs interactive shell

Ini konsep yang sangat penting untuk konfigurasi Zsh.

Keduanya bukan istilah yang sama.

Sebuah shell dapat dikategorikan berdasarkan dua sifat berbeda:

```text
             Login?
            /      \
          yes       no

Interactive?
   /       \
 yes        no
```

Sehingga secara konseptual kita dapat memiliki:

```text
login + interactive
login + non-interactive
non-login + interactive
non-login + non-interactive
```

Dalam penggunaan desktop Linux Anda, ketika terminal emulator membuka shell untuk penggunaan sehari-hari, yang paling penting adalah memahami apakah shell tersebut **interactive**, dan apakah ia juga **login shell**.

Mengapa?

Karena Zsh menentukan file konfigurasi yang dibaca berdasarkan kondisi tersebut.

Nanti kita akan sampai pada:

```text
.zshenv
.zprofile
.zshrc
.zlogin
.zlogout
```

dan tidak semua file tersebut dibaca pada kondisi yang sama. Materi kurikulum kita memang menempatkan startup architecture sebagai tahap khusus setelah fondasi bahasa dan options. 

---

# 5. Jangan ubah default shell dulu

Untuk pembelajaran, kita tidak perlu langsung:

```bash
chsh -s /bin/zsh
```

Kita cukup menjalankan:

```bash
zsh
```

Sekarang Anda berada di Zsh sebagai child process.

Periksa:

```zsh
print -r -- "$ZSH_VERSION"
```

Kemudian:

```zsh
print -r -- "$ZSH_NAME"
```

Kemudian:

```zsh
print -r -- "$SHELL"
```

Anda kemungkinan akan melihat sesuatu yang menarik:

```text
ZSH_VERSION → versi Zsh
ZSH_NAME    → zsh
SHELL       → shell login yang terdaftar
```

Jangan langsung menyimpulkan bahwa `$SHELL` menunjukkan shell yang sedang menjalankan command.

Ini akan menjadi latihan pertama kita dalam memahami **environment variable vs state shell yang sedang berjalan**.

---

# 6. Mengetahui shell yang sedang berjalan

Gunakan:

```zsh
ps -p $$
```

Di sini terdapat konsep yang sudah Anda pelajari dari Bash:

```text
$$
```

adalah PID shell saat ini.

Kemudian:

```zsh
ps -p $$ -o pid,ppid,comm,args
```

Perhatikan hasilnya.

Secara konseptual:

```text
PID
 │
 └── shell sekarang
       │
       └── zsh
```

Kemudian keluar:

```zsh
exit
```

Anda kembali ke shell sebelumnya.

Ini menunjukkan sesuatu yang fundamental:

```text
Bash
 │
 └── zsh
      │
      ├── command
      ├── process
      └── ...
```

Zsh tadi bukan menggantikan Bash.

Ia hanya menjadi child process.

---

# 7. Eksperimen pertama

Sekarang masuk ke Zsh:

```bash
zsh
```

Jalankan satu per satu:

```zsh
print -r -- "$ZSH_VERSION"
print -r -- "$ZSH_NAME"
print -r -- "$SHELL"
print -r -- "$$"
ps -p $$ -o pid,ppid,comm,args
```

Kemudian:

```zsh
echo $-
```

Perhatikan hasilnya.

`$-` berisi option flags dari shell yang sedang berjalan. Ini konsep shell yang sudah Anda temui di Bash, tetapi nanti kita akan membahas bagaimana Zsh memiliki sistem option yang jauh lebih besar melalui:

```zsh
setopt
unsetopt
```

Sistem option tersebut merupakan salah satu fondasi utama konfigurasi Zsh. 

Terakhir:

```zsh
exit
```

---

# Latihan 00.1

Jangan hanya menjalankan command. Coba jawab dengan pemahaman Anda sendiri:

1. Apa perbedaan **terminal emulator**, **shell**, dan **program**?

2. Mengapa menjalankan:

```bash
zsh
```

tidak otomatis membuat Zsh menjadi shell login/default Anda?

3. Apa fungsi:

```zsh
$$
```

?

4. Menurut Anda, apa perbedaan konseptual antara:

```text
interactive shell
```

dan:

```text
login shell
```

5. Jika `$SHELL` masih menunjukkan `/bin/bash` setelah Anda menjalankan `zsh`, apakah berarti Anda sebenarnya masih menggunakan Bash? Jelaskan alasannya.

6. Jalankan:

```zsh
print -r -- "$ZSH_VERSION"
print -r -- "$ZSH_NAME"
print -r -- "$SHELL"
ps -p $$ -o pid,ppid,comm,args
```

dan kirim hasilnya.

Saya akan memeriksa jawaban Anda satu per satu. Setelah itu kita lanjut ke **Lesson 00.2 — Login Shell, Interactive Shell, dan arsitektur startup Zsh**, sebelum masuk ke syntax Zsh.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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

