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



## Lesson 00.2 — Login Shell, Interactive Shell, dan Arsitektur Startup Zsh

Pada lesson sebelumnya kita membedakan terminal emulator dan shell. Sekarang kita masuk ke konsep yang sangat penting untuk memahami `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`, dan `.zlogout`.

Target lesson ini:

```text
login shell
interactive shell
        ↓
kombinasi keduanya
        ↓
startup files
        ↓
urutan pemuatan Zsh
        ↓
memahami di mana konfigurasi harus ditempatkan
```

### 1. Interactive shell

Shell disebut **interactive** ketika shell tersebut berinteraksi langsung dengan pengguna untuk menerima command.

Contoh:

```bash
zsh
```

Kemudian Anda mendapatkan prompt:

```text
~
❯
```

dan dapat mengetik:

```zsh
ls
pwd
cd ~/Documents
```

Secara sederhana:

```text
keyboard
   │
   ▼
terminal emulator
   │
   ▼
interactive zsh
   │
   ├── membaca input
   ├── memproses input
   └── menjalankan command
```

Sebaliknya, shell non-interactive biasanya menjalankan script:

```bash
zsh script.zsh
```

Tidak ada kebutuhan bagi Zsh untuk menyediakan prompt dan line editing kepada pengguna.

---

## 2. Login shell

**Login shell** adalah konsep yang berbeda.

Login shell berkaitan dengan shell yang dijalankan sebagai bagian dari proses login/session.

Jadi jangan membuat persamaan:

```text
login shell = interactive shell
```

Itu salah.

Yang benar:

```text
LOGIN
│
├── login + interactive
├── login + non-interactive
│
NON-LOGIN
│
├── non-login + interactive
└── non-login + non-interactive
```

Dalam praktik desktop Linux modern, mekanisme session manager/display manager/terminal emulator dapat membuat kombinasi yang berbeda. Karena itu kita tidak boleh menebak jenis shell hanya berdasarkan fakta bahwa kita melihat prompt.

[Lebih lanjut][invocation]
---

# 3. Mengapa Zsh peduli terhadap perbedaan ini?

Karena Zsh tidak membaca semua file konfigurasi dalam semua kondisi.

Inilah inti lesson ini.

Zsh mempunyai beberapa startup files:

```text
.zshenv
.zprofile
.zshrc
.zlogin
.zlogout
```

Tetapi masing-masing mempunyai kondisi pemuatan tertentu.

Secara konseptual:

```text
                 ZSH STARTUP
                     │
                     ▼
                  .zshenv
                     │
          ┌──────────┴──────────┐
          │                     │
       login?                non-login
          │                     │
          ▼                     │
      .zprofile                 │
          │                     │
          └──────────┬──────────┘
                     │
                interactive?
                 /         \
               yes          no
                │            │
                ▼            │
             .zshrc          │
                │            │
                └─────┬──────┘
                      │
                 login shell?
                      │
                      ▼
                   .zlogin
```

Ketika shell login berakhir, terdapat:

```text
.zlogout
```

Untuk tahap ini, jangan menghafalkan diagram tersebut dulu. Yang penting adalah memahami **mengapa** file-file tersebut dipisahkan.

---

# 4. `.zshenv`

`.zshenv` adalah file startup yang paling fundamental.

Konsepnya:

```text
setiap invocation Zsh
        │
        ▼
    .zshenv
```

Karena itu `.zshenv` harus diperlakukan dengan hati-hati.

Misalnya Anda memiliki:

```zsh
export EDITOR=nvim
```

atau konfigurasi environment yang benar-benar diperlukan oleh setiap invocation Zsh, secara konseptual hal semacam itu dapat ditempatkan di `.zshenv`.

Namun jangan menjadikan `.zshenv` sebagai tempat semua konfigurasi.

Misalnya jangan langsung memasukkan:

```zsh
compinit
```

atau konfigurasi prompt dan keybinding ke sana.

Mengapa?

Karena `.zshenv` juga dapat dibaca oleh shell yang tidak interactive.

Mental model:

```text
.zshenv
    ↓
environment / fundamental configuration
```

bukan:

```text
.zshenv
    ↓
semua konfigurasi Zsh
```

---

# 5. `.zprofile`

`.zprofile` berkaitan dengan **login shell**.

Secara konseptual:

```text
login shell
    │
    └── .zprofile
```

Ini mirip peran `.profile` pada shell Unix lainnya.

Tempat ini cocok untuk konfigurasi yang memang berhubungan dengan login/session environment.

Contoh konseptual:

```zsh
export SOME_LOGIN_ENV=value
```

Namun kita belum akan membuat konfigurasi nyata di sini. Kita sedang membangun mental model terlebih dahulu.

---

# 6. `.zshrc`

Ini file yang akan paling sering Anda temui sebagai pengguna Zsh interactive.

```text
interactive Zsh
       │
       ▼
    .zshrc
```

Di sinilah biasanya terdapat:

```text
alias
function
option
completion
history
prompt
keybinding
ZLE
plugin
integration
```

Misalnya nanti:

```zsh
setopt AUTO_CD
```

atau:

```zsh
bindkey -v
```

atau:

```zsh
autoload -Uz compinit
compinit
```

atau konfigurasi plugin.

Karena target kita adalah **Zsh sebagai programmable interactive shell**, `.zshrc` akan menjadi salah satu file terpenting dalam seluruh kurikulum.

---

# 7. `.zlogin`

`.zlogin` juga berhubungan dengan login shell.

Perhatikan bahwa:

```text
.zprofile
.zlogin
```

bukan dua nama untuk file yang sama.

Secara konseptual:

```text
login Zsh
   │
   ├── .zprofile
   │
   ├── .zshrc       ← jika interactive
   │
   └── .zlogin
```

Urutan ini nantinya penting ketika konfigurasi Anda mempunyai dependency.

Misalnya:

```text
A harus dimuat sebelum B
```

maka kita perlu memahami startup sequence, bukan sekadar memasukkan semuanya ke `.zshrc`.

---

# 8. `.zlogout`

`.zlogout` berkaitan dengan penghentian **login shell**.

Mental model:

```text
login shell
    │
    ├── startup
    │
    ├── interactive work
    │
    └── logout
          │
          ▼
       .zlogout
```

Konsep ini nantinya berguna jika kita perlu melakukan cleanup tertentu ketika session berakhir.

---

# 9. Urutan penting

Untuk login + interactive Zsh, mental model sederhananya:

```text
.zshenv
   ↓
.zprofile
   ↓
.zshrc
   ↓
.zlogin
   ↓
[session]
   ↓
.zlogout
```

Sedangkan untuk non-login interactive:

```text
.zshenv
   ↓
.zshrc
   ↓
[session]
```

Untuk non-interactive:

```text
.zshenv
   ↓
[command/script]
```

Jadi satu file yang paling universal adalah:

```text
.zshenv
```

sedangkan `.zshrc` berhubungan dengan interactive shell.

---

# 10. Mengapa ini sangat penting untuk dotfiles Anda?

Anda nantinya ingin memiliki struktur seperti:

```text
~/.config/zsh/
├── .zshenv
├── .zprofile
├── .zshrc
├── .zlogin
├── .zlogout
├── options.zsh
├── environment.zsh
├── history.zsh
├── aliases.zsh
├── functions.zsh
├── completion.zsh
├── keybinds.zsh
└── integrations/
```

Tetapi Zsh secara tradisional mencari startup files berdasarkan `$ZDOTDIR`.

Jadi nanti kita akan belajar:

```zsh
print -r -- "$ZDOTDIR"
```

dan bagaimana membuat:

```text
~/.config/zsh/
```

menjadi lokasi konfigurasi Anda.

Ini sangat relevan dengan struktur dotfiles yang sedang Anda bangun.

---

# 11. Eksperimen pertama: lihat kondisi shell

Sekarang kita tidak perlu mengubah konfigurasi apa pun.

Masuk ke Zsh:

```bash
zsh
```

Kemudian:

```zsh
print -r -- "$ZSH_VERSION"
print -r -- "$ZSH_NAME"
print -r -- "$ZDOTDIR"
print -r -- "$-"
```

Kemudian periksa apakah shell interactive:

```zsh
[[ -o interactive ]] && print "interactive" || print "non-interactive"
```

Perhatikan bahwa kita menggunakan:

```zsh
[[ -o interactive ]]
```

Ini sekaligus menjadi preview kecil dari sistem option Zsh yang akan kita pelajari secara mendalam nanti.

---

# 12. Eksperimen kedua: login shell

Dari shell Anda saat ini, jalankan:

```zsh
zsh -l
```

`-l` meminta Zsh dijalankan sebagai login shell.

Kemudian:

```zsh
[[ -o login ]] && print "login" || print "non-login"
```

Sekarang Anda memiliki:

```text
shell pertama
    │
    └── zsh -l
            │
            └── login Zsh
```

Keluar dua kali:

```zsh
exit
exit
```

---

# 13. Eksperimen ketiga: kombinasi

Coba:

```bash
zsh -i
```

`-i` meminta interactive shell.

Kemudian:

```zsh
[[ -o interactive ]] && print "interactive" || print "non-interactive"
[[ -o login ]] && print "login" || print "non-login"
```

Kemudian:

```zsh
exit
```

Sekarang jalankan:

```bash
zsh -li
```

Ini menggabungkan:

```text
-l → login
-i → interactive
```

Periksa lagi:

```zsh
[[ -o login ]] && print "login" || print "non-login"
[[ -o interactive ]] && print "interactive" || print "non-interactive"
```

Dengan eksperimen ini Anda dapat melihat sendiri bahwa:

```text
login
```

dan:

```text
interactive
```

adalah dua properti berbeda.

---

# 14. Hal yang harus benar-benar Anda pahami

Jangan menghafalkan:

```text
.zshenv
.zprofile
.zshrc
.zlogin
.zlogout
```

sebagai lima nama file.

Pahami sebagai **startup lifecycle**:

```text
                  Zsh starts
                      │
                      ▼
                  .zshenv
                      │
             ┌────────┴────────┐
             │                 │
          login?           non-login
             │                 │
             ▼                 │
         .zprofile             │
             │                 │
             └────────┬────────┘
                      │
                interactive?
                      │
                      ▼
                   .zshrc
                      │
                      ▼
                   .zlogin
                      │
                      ▼
                   running
                      │
                      ▼
                   .zlogout
```

Dan pertanyaan yang harus selalu ada di kepala ketika membaca konfigurasi:

> **Shell macam apa yang sedang berjalan, dan startup file mana yang menyebabkan kode ini dieksekusi?**

Ini akan menjadi kemampuan debugging yang sangat penting ketika konfigurasi Anda sudah besar.

---

## Tugas Lesson 00.2

Jalankan tiga kondisi berikut:

```bash
zsh -i
```

```bash
zsh -l
```

```bash
zsh -li
```

Di masing-masing shell jalankan:

```zsh
print -r -- "interactive: $([[ -o interactive ]] && print yes || print no)"
print -r -- "login:       $([[ -o login ]] && print yes || print no)"
print -r -- "PID:         $$"
print -r -- "ZDOTDIR:     ${ZDOTDIR:-<unset>}"
```

Lalu jawab tanpa melihat materi:

1. Apa perbedaan **interactive** dan **login**?
2. Mengapa `zsh -li` berbeda dari `zsh -i`?
3. Mengapa `.zshenv` harus diperlakukan lebih hati-hati daripada `.zshrc`?
4. Untuk konfigurasi `bindkey`, menurut Anda lebih tepat `.zshenv` atau `.zshrc`? Mengapa?
5. Untuk `compinit`, di mana seharusnya konfigurasi interactive tersebut berada?
6. Urutkan startup file untuk **login + interactive Zsh**.
7. Apa fungsi `$ZDOTDIR`?

# Lesson 00.3 — Eksperimen Startup Files

Sekarang kita berhenti sejenak dari teori. Tujuan lesson ini adalah **membuktikan sendiri** file startup mana yang dibaca Zsh pada kondisi yang berbeda.

Kita ingin membuktikan hubungan:

```text
                 Zsh
                  │
              .zshenv
                  │
          ┌───────┴───────┐
          │               │
       login           non-login
          │               │
     .zprofile            │
          │               │
          └───────┬───────┘
                  │
             interactive?
                  │
                  ▼
               .zshrc
                  │
                  ▼
               .zlogin
                  │
                  ▼
              berjalan
                  │
                  ▼
              .zlogout
```

Materi sebelumnya menjelaskan bahwa `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`, dan `.zlogout` mempunyai peran berbeda dalam lifecycle Zsh. 

Kali ini kita akan **membuktikannya melalui eksperimen**, bukan mempercayai diagram.

---

## 1. Jangan gunakan konfigurasi utama Anda

Untuk eksperimen, kita tidak ingin konfigurasi pribadi Anda mengganggu hasil.

Kita dapat membuat direktori eksperimen:

```bash
mkdir -p /tmp/zsh-lab
```

Kemudian buat lima startup file:

```bash
touch /tmp/zsh-lab/.zshenv
touch /tmp/zsh-lab/.zprofile
touch /tmp/zsh-lab/.zshrc
touch /tmp/zsh-lab/.zlogin
touch /tmp/zsh-lab/.zlogout
```

Sekarang:

```bash
ls -la /tmp/zsh-lab
```

Hasil konseptual:

```text
/tmp/zsh-lab/
├── .zlogin
├── .zlogout
├── .zprofile
├── .zshenv
└── .zshrc
```

---

# 2. Berikan identitas kepada setiap file

Kita tidak ingin hanya melihat bahwa file tersebut ada.

Kita ingin setiap file mengatakan:

> “Saya telah dieksekusi.”

Masukkan:

```bash
printf '%s\n' 'print ".zshenv"' > /tmp/zsh-lab/.zshenv
printf '%s\n' 'print ".zprofile"' > /tmp/zsh-lab/.zprofile
printf '%s\n' 'print ".zshrc"' > /tmp/zsh-lab/.zshrc
printf '%s\n' 'print ".zlogin"' > /tmp/zsh-lab/.zlogin
printf '%s\n' 'print ".zlogout"' > /tmp/zsh-lab/.zlogout
```

Sekarang setiap file memiliki satu command.

Misalnya:

```bash
cat /tmp/zsh-lab/.zshenv
```

akan menghasilkan:

```zsh
print ".zshenv"
```

---

# 3. Apa itu `$ZDOTDIR`?

Sekarang kita menggunakan konsep yang baru saja kita bahas.

Zsh menggunakan:

```zsh
$ZDOTDIR
```

sebagai lokasi startup files.

Kita akan memberitahu Zsh:

```text
"Gunakan /tmp/zsh-lab sebagai direktori konfigurasi."
```

Jalankan:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -i
```

Perhatikan output.

Anda seharusnya mendapatkan:

```text
.zshenv
.zshrc
```

Kemudian:

```zsh
exit
```

Perhatikan bahwa `.zlogout` **tidak muncul**.

Ini adalah observasi pertama yang penting.

Shell tadi:

```text
interactive
non-login
```

Maka:

```text
.zshenv
   ↓
.zshrc
```

---

# 4. Eksperimen login shell

Sekarang:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -l
```

Perhatikan hasilnya.

Shell ini:

```text
login
non-interactive
```

Secara umum Anda akan melihat:

```text
.zshenv
.zprofile
.zlogin
```

Kemudian:

```zsh
exit
```

dan Anda seharusnya melihat:

```text
.zlogout
```

Perhatikan sesuatu yang penting:

```text
.zshrc
```

tidak muncul.

Mengapa?

Karena shell tersebut **login**, tetapi bukan interactive.

---

# 5. Eksperimen login + interactive

Sekarang eksperimen paling penting:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -li
```

Kali ini terdapat dua flag:

```text
-l → login
-i → interactive
```

Maka kita mengharapkan:

```text
.zshenv
.zprofile
.zshrc
.zlogin
```

Setelah:

```zsh
exit
```

kita mengharapkan:

```text
.zlogout
```

Jadi lifecycle lengkapnya:

```text
START
 │
 ▼
.zshenv
 │
 ▼
.zprofile
 │
 ▼
.zshrc
 │
 ▼
.zlogin
 │
 ▼
INTERACTIVE SESSION
 │
 ▼
exit
 │
 ▼
.zlogout
```

Ini adalah eksperimen inti lesson ini.

---

# 6. Eksperimen non-interactive

Sekarang kita hilangkan interactive shell:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -c 'print "command body"'
```

Hasil yang perlu diperhatikan:

```text
.zshenv
command body
```

Tidak ada:

```text
.zprofile
.zshrc
.zlogin
.zlogout
```

Ini membuktikan bahwa `.zshenv` memiliki karakteristik khusus: ia dapat dibaca bahkan ketika Zsh digunakan secara non-interactive.

---

# 7. Buat tabel hasil eksperimen

Setelah semua eksperimen, Anda seharusnya memperoleh model seperti ini:

| Mode                | `.zshenv` | `.zprofile` | `.zshrc` | `.zlogin` |    `.zlogout` |
| ------------------- | --------: | ----------: | -------: | --------: | ------------: |
| interactive         |         ✓ |           — |        ✓ |         — |             — |
| login               |         ✓ |           ✓ |        — |         ✓ | ✓ saat keluar |
| login + interactive |         ✓ |           ✓ |        ✓ |         ✓ | ✓ saat keluar |
| non-interactive     |         ✓ |           — |        — |         — |             — |

Ada satu detail penting: tabel ini menggambarkan **startup path normal** yang sedang kita eksperimenkan. Kita tidak boleh menggeneralisasikannya ke semua mekanisme invocation Zsh tanpa melihat kondisi dan opsi invocation yang digunakan.

---

# 8. Sekarang kita buktikan urutannya dengan `print`

Daripada hanya melihat nama file, kita dapat memberikan timestamp atau informasi proses.

Ubah `.zshenv` menjadi:

```zsh
print -- "STARTUP: .zshenv PID=$$"
```

`.zprofile`:

```zsh
print -- "STARTUP: .zprofile PID=$$"
```

`.zshrc`:

```zsh
print -- "STARTUP: .zshrc PID=$$"
```

`.zlogin`:

```zsh
print -- "STARTUP: .zlogin PID=$$"
```

`.zlogout`:

```zsh
print -- "STARTUP: .zlogout PID=$$"
```

Kemudian:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -li
```

Anda akan melihat bahwa seluruh startup file menggunakan PID shell yang sama.

Misalnya:

```text
STARTUP: .zshenv PID=12345
STARTUP: .zprofile PID=12345
STARTUP: .zshrc PID=12345
STARTUP: .zlogin PID=12345
```

Setelah:

```zsh
exit
```

```text
STARTUP: .zlogout PID=12345
```

Ini menunjukkan bahwa file-file tersebut bukan proses terpisah.

Mereka adalah **kode yang di-source oleh shell yang sama**.

Ini konsep yang sangat penting.

---

# 9. Startup file bukan executable terpisah

Misalnya `.zshrc` berisi:

```zsh
MY_VARIABLE="hello"
```

ketika `.zshrc` dibaca, variable tersebut berada dalam shell yang sedang berjalan.

Secara konseptual:

```text
zsh process
    │
    ├── source .zshenv
    │
    ├── source .zprofile
    │
    ├── source .zshrc
    │       │
    │       └── MY_VARIABLE="hello"
    │
    └── lanjut menjalankan shell
```

Ini berbeda dari konsep:

```zsh
./some-script.zsh
```

yang melibatkan process execution tersendiri.

Perbedaan antara **sourcing** dan **executing** akan sangat penting ketika nanti kita membangun konfigurasi modular.

---

# 10. Eksperimen tambahan: variabel

Sekarang kita buktikan bahwa startup file dapat memengaruhi shell berikutnya.

Masukkan ke `.zshenv`:

```zsh
ZSH_LAB="hello-from-zshenv"
```

Kemudian jalankan:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -c 'print -- "$ZSH_LAB"'
```

Hasil:

```text
hello-from-zshenv
```

Sekarang masukkan variable yang sama ke `.zshrc`:

```zsh
ZSH_LAB="hello-from-zshrc"
```

Lalu jalankan lagi:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -c 'print -- "$ZSH_LAB"'
```

Jika `.zshrc` tidak dibaca dalam invocation non-interactive tersebut, nilai dari `.zshrc` tidak akan tersedia.

Inilah alasan pemilihan startup file bukan sekadar masalah organisasi file.

**Lokasi konfigurasi menentukan kapan konfigurasi tersebut tersedia.**

---

# 11. Hubungannya dengan konfigurasi Anda nanti

Setelah memahami eksperimen ini, kita dapat mulai menentukan arsitektur.

Misalnya:

```text
.zshenv
│
└── environment yang benar-benar fundamental

.zprofile
│
└── login/session environment

.zshrc
│
├── options
├── aliases
├── functions
├── history
├── completion
├── prompt
├── keybindings
├── ZLE
└── plugins

.zlogin
│
└── login-specific interactive initialization

.zlogout
│
└── login-shell cleanup
```

Ini belum berarti struktur final Anda harus persis seperti itu.

Kita akan membuat keputusan tersebut setelah memahami semua mekanismenya.

---

# 12. Mengapa eksperimen ini penting untuk target akhir kita?

Nanti Anda akan menemukan konfigurasi seperti:

```zsh
[[ -o interactive ]] || return
```

atau:

```zsh
autoload -Uz compinit
compinit
```

atau:

```zsh
if [[ -r "$file" ]]; then
    source "$file"
fi
```

Tanpa memahami startup architecture, kode tersebut hanya terlihat seperti sekumpulan syntax.

Setelah memahami lifecycle:

```text
shell starts
    ↓
startup files
    ↓
conditions
    ↓
source modules
    ↓
interactive features
```

Anda mulai dapat membaca konfigurasi sebagai **sistem**, bukan baris-baris kode terpisah.

Itulah kemampuan yang akan kita bawa sampai tahap membaca dan memodifikasi plugin.

---

## Tugas Lesson 00.3

Lakukan empat eksperimen ini:

```bash
ZDOTDIR=/tmp/zsh-lab zsh -i
```

```bash
ZDOTDIR=/tmp/zsh-lab zsh -l
```

```bash
ZDOTDIR=/tmp/zsh-lab zsh -li
```

```bash
ZDOTDIR=/tmp/zsh-lab zsh -c 'print "body"'
```

Kemudian catat urutan startup file yang muncul.

Setelah itu jawab:

1. Mengapa `zsh -i` membaca `.zshrc` tetapi tidak `.zprofile`?
2. Mengapa `zsh -l` membaca `.zprofile` dan `.zlogin` tetapi tidak `.zshrc`?
3. Mengapa `zsh -li` membaca ketiganya?
4. Mengapa `.zshenv` muncul bahkan pada `zsh -c`?
5. Mengapa `.zlogout` baru muncul ketika login shell keluar?
6. Apa perbedaan konseptual antara **startup file yang di-source oleh Zsh** dan **script yang dieksekusi sebagai program**?
7. Mengapa menurut Anda memasukkan `compinit`, ZLE, prompt, atau plugin ke `.zshenv` merupakan keputusan yang buruk?

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md
[invocation]: ./invocation.md

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

