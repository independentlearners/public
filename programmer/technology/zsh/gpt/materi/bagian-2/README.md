# Lesson 01 — Zsh vs Bash

Pada Lesson 00 kita membangun model mental tentang bagaimana Zsh berjalan dan bagaimana startup file bekerja. Sekarang kita masuk ke perbedaan inti antara Bash dan Zsh.

Tujuan Lesson 01 bukan membuat Anda menghafal semua perbedaan syntax. Tujuannya adalah memahami:

> “Bagian mana dari pengetahuan Bash yang bisa saya bawa ke Zsh, dan bagian mana yang harus saya pelajari ulang?”

---

## 01.1 — Zsh bukan sekadar Bash dengan fitur lebih banyak

Bash dan Zsh sama-sama Unix shell dan memiliki banyak konsep yang sama:

```text
Bash                         Zsh
 │                            │
 ├─ variable                  ├─ variable
 ├─ parameter expansion       ├─ parameter expansion
 ├─ function                  ├─ function
 ├─ if/else                   ├─ if/else
 ├─ loop                      ├─ loop
 ├─ exit status               ├─ exit status
 ├─ redirection               ├─ redirection
 ├─ command substitution      ├─ command substitution
 └─ process execution         └─ process execution
```

Karena itu, pengetahuan Bash Anda tetap berguna.

Tetapi Zsh mempunyai desain bahasa dan fitur interaktifnya sendiri. Jadi model yang lebih tepat adalah:

```text
              Unix Shell Concepts
                       │
             ┌─────────┴─────────┐
             │                   │
           Bash                 Zsh
             │                   │
      POSIX + Bash         POSIX-like + Zsh
      extensions           extensions
```

Jangan berpikir:

```text
Bash
 ↓
Bash++
 ↓
Zsh
```

Lebih tepat:

```text
Bash ────────┐
             ├── konsep shell yang sama
Zsh ─────────┘
      │
      └── bahasa + fitur Zsh sendiri
```

Ini penting karena nantinya ketika membaca konfigurasi Zsh, Anda akan menemukan syntax yang **bukan syntax Bash**.

---

# 01.2 — POSIX sebagai titik pertemuan

Anda sudah mempelajari POSIX dalam Bash. Ini menjadi modal penting.

Contoh:

```sh
name="Amir"

if [ -n "$name" ]; then
    printf '%s\n' "$name"
fi
```

Konsep seperti:

```text
variable
  ↓
parameter expansion
  ↓
command
  ↓
exit status
  ↓
conditional
```

tetap relevan di Zsh.

Misalnya:

```zsh
name="Amir"

if [[ -n "$name" ]]; then
    print "$name"
fi
```

Strukturnya masih dapat dikenali.

Tetapi Zsh menyediakan banyak fasilitas tambahan yang membuat kita tidak harus selalu menggunakan idiom POSIX.

---

# 01.3 — Perbedaan pertama yang sangat penting: `echo` vs `print`

Dalam Bash Anda mungkin terbiasa:

```bash
echo "Hello"
```

Di Zsh Anda akan sering menemukan:

```zsh
print "Hello"
```

`print` adalah builtin Zsh yang sangat penting.

Contoh:

```zsh
print "Hello"
print -r -- "Hello\nWorld"
```

Perhatikan:

```zsh
print -r -- "$value"
```

Anda akan sering melihat pola seperti ini dalam konfigurasi Zsh.

Untuk sementara jangan menghafalkan seluruh option `print`.

Yang perlu dipahami:

```text
Bash:
echo / printf

Zsh:
print / printf
```

`printf` tetap tersedia dan tetap berguna.

---

# 01.4 — Perbedaan besar: array

Ini salah satu perbedaan yang wajib Anda kuasai.

Bash secara default menggunakan indexing array mulai dari `0`:

```bash
array=("A" "B" "C")

echo "${array[0]}"
echo "${array[1]}"
echo "${array[2]}"
```

Hasil:

```text
A
B
C
```

Zsh secara default menggunakan indexing mulai dari `1`:

```zsh
array=("A" "B" "C")

print "$array[1]"
print "$array[2]"
print "$array[3]"
```

Hasil:

```text
A
B
C
```

Jadi:

```text
Bash                       Zsh

array[0] → A              array[1] → A
array[1] → B              array[2] → B
array[2] → C              array[3] → C
```

Ini bukan perbedaan kecil.

Ketika membaca plugin Zsh, konfigurasi completion, widget, atau script yang memanipulasi array, indexing adalah salah satu hal pertama yang harus diperhatikan.

---

# 01.5 — Array Zsh lebih terintegrasi dengan shell

Misalnya:

```zsh
files=(one two three)
```

Kemudian:

```zsh
print "$files[1]"
```

atau:

```zsh
print "$files[@]"
```

Zsh mempunyai sistem parameter expansion yang sangat kuat.

Nanti kita akan mempelajari secara khusus:

```text
$array
$array[1]
$array[1,3]
$array[-1]
$array[@]
$array[*]
```

Jangan mencoba menghafalkan semuanya sekarang.

Untuk Lesson 01 cukup tanamkan:

> Array Zsh memiliki aturan indexing dan expansion yang berbeda dari Bash.

---

# 01.6 — Associative array

Bash:

```bash
declare -A user

user[name]="Amir"
user[shell]="zsh"

echo "${user[name]}"
```

Zsh menggunakan:

```zsh
typeset -A user

user[name]="Amir"
user[shell]="zsh"

print "$user[name]"
```

`typeset` adalah salah satu builtin penting Zsh.

Nanti kita akan membahas:

```zsh
typeset
typeset -a
typeset -A
typeset -i
typeset -r
typeset -x
```

Karena `typeset` berhubungan erat dengan sistem parameter Zsh.

---

# 01.7 — Globbing: salah satu kekuatan besar Zsh

Ini bagian yang sangat penting untuk tujuan Anda.

Bash:

```bash
*.txt
```

Zsh juga:

```zsh
*.txt
```

Tetapi Zsh mempunyai kemampuan globbing yang jauh lebih luas.

Contohnya recursive glob:

```zsh
**/*.txt
```

Secara konseptual:

```text
*.txt
│
└── file .txt pada level tertentu


**/*.txt
│
└── file .txt secara recursive
```

Zsh juga memiliki extended globbing.

Contoh:

```zsh
^*.txt
```

atau pola-pola yang jauh lebih kompleks.

Nantinya kita akan mempelajari:

```text
Filename generation
        │
        ├── *
        ├── ?
        ├── **
        ├── qualifiers
        ├── extended glob
        └── glob modifiers
```

Ini sangat penting untuk scripting Zsh.

---

# 01.8 — `set -o` vs `setopt`

Anda sudah mengenal kemungkinan seperti:

```bash
set -e
set -u
set -o pipefail
```

Di Zsh ada sistem option sendiri.

Contoh:

```zsh
setopt
```

Untuk melihat option aktif.

Kemudian:

```zsh
setopt AUTO_CD
```

atau:

```zsh
setopt EXTENDED_GLOB
```

Untuk mematikannya:

```zsh
unsetopt AUTO_CD
```

Secara konsep:

```text
Bash

set -o option
set +o option


Zsh

setopt OPTION
unsetopt OPTION
```

Tetapi jangan menyimpulkan bahwa semua option Bash mempunyai padanan langsung di Zsh.

Zsh mempunyai option yang memang dirancang untuk perilaku Zsh.

---

# 01.9 — `[[ ... ]]` menjadi sangat penting

Anda mungkin sudah menggunakan:

```bash
[[ "$value" == "hello" ]]
```

Zsh juga sangat bergantung pada:

```zsh
[[ ... ]]
```

Contoh:

```zsh
if [[ -n "$name" ]]; then
    print "name exists"
fi
```

Bahkan banyak konfigurasi Zsh hampir seluruhnya menggunakan:

```zsh
[[ ... ]]
```

daripada:

```zsh
[ ... ]
```

Jadi pengetahuan conditional Bash Anda tetap berguna, tetapi nanti kita perlu mempelajari ekspresi kondisional Zsh secara khusus.

---

# 01.10 — Function

Bentuk dasar tetap familiar:

```zsh
hello() {
    print "Hello"
}
```

Kemudian:

```zsh
hello
```

Namun Zsh memiliki kemampuan function yang lebih luas, terutama ketika dikombinasikan dengan:

```text
autoload
function directories
modules
hooks
widgets
completion
```

Contoh yang nanti akan menjadi sangat penting:

```zsh
autoload -Uz some_function
```

Ini bukan sekadar function biasa yang didefinisikan langsung di `.zshrc`.

Konsep `autoload` akan menjadi dasar ketika kita mulai membaca struktur plugin Zsh.

---

# 01.11 — Interactive shell: perbedaan terbesar mulai terlihat

Sampai sekarang kita membahas bahasa shell.

Tetapi tujuan Anda sebenarnya lebih jauh:

> memahami konfigurasi Zsh dan akhirnya membuat fitur terminal sendiri.

Di sinilah Zsh mulai berbeda secara signifikan dari cara Anda memandang Bash.

Model Bash yang umum:

```text
Bash
 │
 ├── script
 ├── variable
 ├── function
 └── command
```

Model Zsh yang akan kita bangun:

```text
Zsh
 │
 ├── shell language
 │
 ├── configuration
 │
 ├── completion
 │
 ├── history
 │
 ├── prompt
 │
 ├── hooks
 │
 ├── widgets
 │
 ├── ZLE
 │
 └── plugins
```

Jadi Zsh bukan hanya bahasa scripting.

Ia juga menyediakan lingkungan pemrograman untuk **interactive shell**.

---

# 01.12 — Bash Readline vs Zsh ZLE

Ketika Anda menekan:

```text
Ctrl + A
Ctrl + E
Ctrl + R
Alt + ...
```

shell membutuhkan mekanisme untuk menangani input keyboard.

Pada Bash, komponen utamanya adalah:

```text
Readline
```

Pada Zsh:

```text
ZLE
Zsh Line Editor
```

Secara konseptual:

```text
Keyboard
   │
   ▼
 ZLE
   │
   ├── keymap
   ├── widget
   ├── function
   └── command line
```

Contoh:

```zsh
bindkey
```

akan menjadi sangat penting.

Dan nanti Anda dapat membuat widget sendiri:

```zsh
my_widget() {
    ...
}

zle -N my_widget
bindkey '^X^X' my_widget
```

Ini adalah salah satu alasan mengapa Anda tidak cukup hanya belajar syntax Zsh.

Anda perlu memahami **arsitektur interactive Zsh**.

---

# 01.13 — Completion Bash vs Zsh

Bash mempunyai completion system.

Zsh mempunyai completion system yang sangat terintegrasi dengan Zsh:

```zsh
autoload -Uz compinit
compinit
```

Setelah itu:

```text
Tab
 │
 ▼
completion system
 │
 ├── command
 ├── option
 ├── file
 ├── directory
 ├── argument
 └── context-specific completion
```

Nanti kita akan membedah:

```text
compinit
   │
   ├── completion functions
   ├── completers
   ├── styles
   ├── widgets
   └── contexts
```

Jangan pelajari `compinit` sekarang secara detail.

Cukup pahami bahwa ini adalah **lapisan interactive Zsh**, bukan sekadar builtin sederhana.

---

# 01.14 — Perbandingan mental model

Simpan model berikut.

```text
                 BASH
                  │
       ┌──────────┴──────────┐
       │                     │
    scripting             interactive
       │                     │
       ├─ variables          ├─ Readline
       ├─ functions          ├─ history
       ├─ loops              └─ completion
       └─ expansion


                 ZSH
                  │
       ┌──────────┴──────────┐
       │                     │
    scripting             interactive
       │                     │
       ├─ parameters         ├─ ZLE
       ├─ arrays             ├─ widgets
       ├─ globbing           ├─ keymaps
       ├─ functions          ├─ completion
       ├─ options            ├─ hooks
       └─ modules            └─ prompt
```

Kemudian:

```text
Zsh
 │
 └── Configuration
       │
       ├── .zshenv
       ├── .zprofile
       ├── .zshrc
       ├── functions
       ├── completion
       ├── widgets
       ├── hooks
       └── plugins
```

Inilah fondasi untuk tahap berikutnya.

---

# 01.15 — Eksperimen pertama: Bash vs Zsh

Sekarang jangan langsung masuk ke teori lebih jauh.

Kita akan membuktikan perbedaan dengan eksperimen.

Buat dua shell secara terpisah.

### Bash

Jalankan:

```bash
bash
```

Kemudian:

```bash
arr=(one two three)
```

Lalu:

```bash
printf '%s\n' "${arr[0]}"
printf '%s\n' "${arr[1]}"
printf '%s\n' "${arr[2]}"
```

Perhatikan indexing-nya.

Keluar:

```bash
exit
```

### Zsh

Jalankan:

```bash
zsh
```

Kemudian:

```zsh
arr=(one two three)
```

Lalu:

```zsh
print "$arr[1]"
print "$arr[2]"
print "$arr[3]"
```

Kemudian:

```zsh
print "$arr[0]"
```

Perhatikan apa yang terjadi.

---

# 01.16 — Eksperimen kedua: `print`

Di Zsh:

```zsh
print "Hello"
```

Bandingkan:

```zsh
printf '%s\n' "Hello"
```

Kemudian:

```zsh
print -r -- 'Hello\nWorld'
```

Bandingkan dengan:

```zsh
printf '%s\n' 'Hello\nWorld'
```

Tujuan eksperimen ini bukan mempelajari semua option `print`.

Tujuannya adalah mengenali bahwa Zsh memiliki builtin native yang sering muncul dalam konfigurasi:

```text
print
typeset
setopt
unsetopt
autoload
zle
bindkey
```

Kelak keenam nama ini akan sangat sering Anda temui.

---

# 01.17 — Eksperimen ketiga: globbing

Di direktori latihan:

```zsh
mkdir -p /tmp/zsh-glob/a/b
touch /tmp/zsh-glob/a/one.txt
touch /tmp/zsh-glob/a/b/two.txt
touch /tmp/zsh-glob/a/three.md
```

Masuk:

```zsh
cd /tmp/zsh-glob
```

Coba:

```zsh
print -rl -- *.txt
```

Kemudian:

```zsh
print -rl -- **/*.txt
```

Perhatikan perbedaannya.

Lalu aktifkan:

```zsh
setopt EXTENDED_GLOB
```

Untuk sekarang cukup lihat bahwa Zsh memiliki sistem filename generation yang dapat diperluas melalui options.

---

# 01.18 — Hal yang jangan dilakukan

Jangan langsung menghafalkan:

```text
setopt
unsetopt
typeset
autoload
zle
bindkey
compinit
extended glob
parameter expansion
```

sekaligus.

Kita sedang membangun peta.

```text
Lesson 01
   │
   ├── Bash knowledge tetap berguna
   │
   ├── Zsh mempunyai syntax sendiri
   │
   ├── array berbeda
   │
   ├── expansion lebih kuat
   │
   ├── glob lebih kuat
   │
   ├── options berbeda
   │
   └── interactive layer jauh lebih programmable
```

Baru pada lesson berikutnya masing-masing mekanisme akan dibedah.

---

# Latihan Lesson 01

Jangan melihat jawaban dari materi sebelumnya. Jawab berdasarkan pemahaman Anda sendiri.

**1.** Apakah Zsh merupakan Bash yang ditambah fitur?

Jelaskan model yang menurut Anda lebih tepat.

**2.** Apa perbedaan indexing array berikut?

```bash
arr=(A B C)
```

dan:

```zsh
arr=(A B C)
```

**3.** Mengapa perbedaan indexing array penting ketika membaca konfigurasi/plugin Zsh?

**4.** Apa fungsi konseptual `setopt`?

**5.** Apa perbedaan peran:

```text
Readline
```

dengan:

```text
ZLE
```

**6.** Apa yang dimaksud dengan globbing?

Dan mengapa:

```zsh
**/*.txt
```

menunjukkan bahwa Zsh mempunyai kemampuan globbing yang lebih luas daripada glob sederhana?

**7.** Dari daftar berikut, mana yang merupakan mekanisme yang sangat berkaitan dengan interactive Zsh?

```text
variable
ZLE
widget
keymap
completion
loop
hook
```

Jelaskan hubungan antar mekanismenya.

**8. Eksperimen wajib**

Jalankan:

```bash
bash
```

dan:

```zsh
zsh
```

Kemudian bandingkan:

```text
array indexing
print
globbing
setopt
```

Catat minimal **3 perbedaan nyata** yang Anda lihat.


## Lesson 01 — Zsh vs Bash

### Bagian 01 — Posisi Zsh terhadap Bash

Kita mulai kembali dari awal Lesson 01 secara sistematis. Tujuan bagian ini bukan mempelajari syntax Zsh satu per satu, tetapi membangun model yang benar sebelum masuk ke perbedaan teknis.

### 1. Bash yang sudah Anda pelajari tetap berlaku

Pengetahuan berikut dapat langsung dibawa ke Zsh:

```text
Shell
├── command execution
├── process
├── environment
├── variable / parameter
├── expansion
├── quoting
├── function
├── conditional
├── loop
├── exit status
├── redirection
├── pipeline
├── command substitution
└── process substitution
```

Jadi ketika berpindah dari Bash ke Zsh, Anda tidak memulai dari nol.

Yang berubah adalah **cara Zsh mengembangkan konsep-konsep tersebut**.

Misalnya Anda sudah memahami:

```bash
name="Amir"

if [[ -n "$name" ]]; then
    printf '%s\n' "$name"
fi
```

Ketika melihat:

```zsh
name="Amir"

if [[ -n "$name" ]]; then
    print "$name"
fi
```

Anda sebenarnya sudah memahami sebagian besar struktur programnya.

Yang perlu dipelajari adalah bagian yang spesifik terhadap Zsh.

---

## 2. POSIX bukan Zsh

Ini salah satu konsep penting dalam perpindahan Bash → Zsh.

Secara sederhana:

```text
             Shell programming
                    │
          ┌─────────┴─────────┐
          │                   │
        POSIX              Extensions
          │                   │
          │             ┌─────┴─────┐
          │             │           │
        Bash            Bash        Zsh
```

Bash mempunyai fitur yang berasal dari POSIX sekaligus fitur khusus Bash.

Zsh juga mempunyai banyak konsep yang familier bagi pengguna shell, tetapi mempunyai ekstensi dan mekanisme sendiri.

Karena itu jangan menggunakan aturan:

> “Kalau syntax ini bekerja di Bash, pasti sama di Zsh.”

Dan jangan pula menggunakan aturan:

> “Kalau saya belajar Zsh, semua syntax Bash harus saya lupakan.”

Keduanya salah.

Model yang lebih tepat:

```text
Bash knowledge
      │
      ├── konsep shell umum ──────────────► tetap berguna
      │
      ├── POSIX shell syntax ─────────────► banyak yang berguna
      │
      └── Bash-specific behavior ────────► perlu diverifikasi
                                               │
                                               ▼
                                             Zsh
                                               │
                                    Zsh-specific behavior
```

Inilah pola berpikir yang akan kita gunakan sepanjang kurikulum.

---

# 3. Compatibility ≠ Identity

Dua shell dapat memiliki syntax yang sama tanpa berarti keduanya mempunyai implementasi atau perilaku yang identik.

Contoh sederhana:

```bash
name="Amir"
```

dan:

```zsh
name="Amir"
```

Syntax tersebut sama.

Tetapi sistem parameter Zsh memiliki kemampuan yang jauh lebih luas.

Hal yang sama terjadi pada:

```bash
arr=(A B C)
```

dan:

```zsh
arr=(A B C)
```

Keduanya terlihat sama.

Namun ketika mengakses elemennya:

```bash
"${arr[0]}"
```

sedangkan di Zsh:

```zsh
"$arr[1]"
```

kita sudah menemukan perbedaan semantik.

Jadi ketika belajar Zsh, kita perlu membedakan:

```text
Syntax terlihat sama
        ≠
Behavior pasti sama
```

Ini akan menjadi salah satu prinsip utama ketika nanti Anda membaca plugin Zsh.

---

# 4. Mengapa kita tidak mempelajari ulang Bash?

Karena tujuan kita bukan:

```text
Bash
 ↓
ulang dari awal
 ↓
Zsh
```

Tetapi:

```text
Bash foundation
      │
      ▼
identifikasi konsep yang sudah dikuasai
      │
      ▼
identifikasi perbedaan Zsh
      │
      ▼
pelajari mekanisme Zsh
      │
      ▼
gabungkan dengan interactive shell
```

Contohnya:

Anda sudah memahami function.

Maka kita tidak perlu menghabiskan satu lesson untuk menjelaskan kembali:

```bash
hello() {
    ...
}
```

Sebaliknya kita akan bertanya:

```text
Bagaimana function Zsh berbeda?
Apa itu autoload?
Bagaimana function directory bekerja?
Bagaimana function digunakan oleh completion?
Bagaimana function dapat menjadi ZLE widget?
Bagaimana hook menggunakan function?
```

Dengan demikian waktu belajar digunakan untuk bagian yang memang baru.

---

# 5. Perbedaan Zsh yang akan menjadi fokus

Dalam Lesson 01 kita akan membedah perbedaan pada beberapa lapisan.

```text
Zsh vs Bash
│
├── 1. Language
│   ├── parameter
│   ├── expansion
│   ├── quoting
│   ├── arrays
│   ├── conditions
│   └── functions
│
├── 2. Filename generation
│   └── globbing
│
├── 3. Shell behavior
│   └── options
│
├── 4. Builtins
│   ├── print
│   ├── typeset
│   ├── autoload
│   └── lainnya
│
└── 5. Interactive environment
    ├── ZLE
    ├── keymaps
    ├── widgets
    └── completion
```

Urutan ini penting.

Kita akan bergerak dari:

```text
bahasa
 ↓
perilaku shell
 ↓
interactive shell
```

bukan langsung masuk ke plugin.

---

# 6. Perbedaan pertama: array indexing

Mari kita jadikan ini contoh konkret pertama.

Bash:

```bash
arr=(A B C)

printf '%s\n' "${arr[0]}"
printf '%s\n' "${arr[1]}"
printf '%s\n' "${arr[2]}"
```

Konsepnya:

```text
index
 0 ──► A
 1 ──► B
 2 ──► C
```

Zsh:

```zsh
arr=(A B C)

print "$arr[1]"
print "$arr[2]"
print "$arr[3]"
```

Konsepnya:

```text
index
 1 ──► A
 2 ──► B
 3 ──► C
```

Ini merupakan perbedaan yang sangat penting karena array akan muncul terus-menerus dalam konfigurasi Zsh.

Terutama ketika nanti kita bertemu:

```text
completion
plugin manager
PATH manipulation
widgets
hooks
configuration modules
```

---

# 7. Mengapa Zsh memilih model seperti ini?

Untuk sekarang jangan mencari alasan historisnya.

Yang perlu Anda pahami adalah bahwa Zsh mempunyai filosofi parameter yang sangat kuat.

Zsh memperlakukan array sebagai bagian integral dari sistem parameter shell.

Nanti kita akan melihat hal seperti:

```zsh
array=(one two three)

print "$array"
print "$array[1]"
print "$array[1,2]"
print "$array[-1]"
```

Artinya, array bukan sekadar fitur tambahan seperti yang mungkin Anda bayangkan dari scripting sederhana.

Ia terintegrasi dengan parameter expansion.

Inilah alasan Lesson 02 dan Lesson 03 nantinya akan memberikan perhatian besar terhadap parameter dan expansion.

---

# 8. Perbedaan kedua: builtin Zsh

Dalam Bash Anda sering menggunakan:

```bash
echo
printf
declare
export
set
```

Di Zsh Anda akan sering menemukan:

```zsh
print
printf
typeset
export
setopt
unsetopt
autoload
```

Perhatikan khusus:

```zsh
print
typeset
setopt
autoload
```

Keempatnya akan menjadi penting dalam perjalanan kita.

Namun jangan mempelajari semuanya sekarang.

Untuk saat ini cukup kategorikan:

```text
print
└── output

typeset
└── parameter declaration / attributes

setopt / unsetopt
└── shell behavior

autoload
└── function loading
```

Nanti setiap mekanisme akan memiliki lesson khusus.

---

# 9. Perbedaan ketiga: shell options

Bash:

```bash
set -o
```

dan:

```bash
set -o pipefail
```

Zsh:

```zsh
setopt
```

dan:

```zsh
setopt PIPE_FAIL
```

serta:

```zsh
unsetopt PIPE_FAIL
```

Yang perlu Anda pahami sekarang bukan nama setiap option.

Konsepnya:

```text
Shell behavior
      │
      ▼
    option
      │
 ┌────┴────┐
 │         │
enable   disable
 │         │
setopt   unsetopt
```

Ini nantinya sangat penting dalam konfigurasi karena banyak perilaku Zsh ditentukan oleh options.

Contoh:

```zsh
setopt AUTO_CD
```

dapat mengubah bagaimana command line diperlakukan.

Jadi ketika membaca `.zshrc`, Anda tidak boleh menganggap:

```zsh
setopt ...
```

sebagai konfigurasi kosmetik.

Ia dapat mengubah **semantik shell**.

---

# 10. Perbedaan keempat: globbing

Ini salah satu wilayah yang akan menjadi sangat penting untuk Anda sebagai Zsh scripter.

Shell melakukan filename generation sebelum command dieksekusi.

Misalnya:

```zsh
print -- *.txt
```

Jika direktori berisi:

```text
a.txt
b.txt
c.txt
```

shell dapat mengembangkan:

```text
*.txt
```

menjadi:

```text
a.txt b.txt c.txt
```

Zsh kemudian menyediakan kemampuan glob yang jauh lebih luas.

Contoh yang perlu Anda kenal sejak sekarang:

```zsh
**/*.txt
```

Secara konseptual:

```text
*.txt
└── matching pada level tertentu

**/*.txt
└── matching secara recursive
```

Nanti kita akan membedah sistem glob Zsh secara khusus pada **Lesson 05 — Filename Generation / Glob**.

---

# 11. Perbedaan kelima: interactive shell

Sampai titik ini, Bash dan Zsh masih terlihat seperti dua bahasa scripting yang mirip.

Perbedaan yang jauh lebih besar muncul ketika kita menggunakan keduanya sebagai **interactive shell**.

Model sederhana Bash:

```text
Bash
 │
 ├── shell language
 └── Readline
```

Model Zsh:

```text
Zsh
 │
 ├── shell language
 ├── ZLE
 ├── keymaps
 ├── widgets
 ├── completion
 ├── hooks
 └── prompt system
```

Ini sangat relevan dengan tujuan Anda.

Anda bukan hanya ingin:

```text
menulis script.zsh
```

Anda ingin dapat memahami:

```text
.zshrc
   ↓
function
   ↓
widget
   ↓
key binding
   ↓
completion
   ↓
hook
   ↓
plugin
```

Jadi Zsh perlu dipahami sebagai:

> **shell language + programmable interactive environment**

Itulah konsep yang akan menjadi jembatan dari Lesson 01 menuju Lesson 11–24.

---

# 12. Posisi kita dalam Lesson 01

Bagian pertama sudah selesai:

```text
01 — Zsh vs Bash
│
├── ✓ Zsh bukan Bash++
├── ✓ Bash knowledge tetap berguna
├── ✓ POSIX vs shell-specific behavior
├── ✓ Compatibility ≠ identity
│
├── → Parameter / expansion
├── → Arrays
├── → Globbing
├── → Conditional expressions
├── → Functions
├── → Redirection / process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion
```

Sekarang kita lanjut **di dalam Lesson 01**, bukan pindah ke Lesson 02.

Bagian berikutnya adalah **perbedaan syntax dan parameter/expansion**, karena ini merupakan fondasi yang diperlukan sebelum kita membahas fitur Zsh yang lebih tinggi.

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

