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

Sebelum berpindah ke Lesson 02. Bagian berikutnya adalah **perbedaan syntax dan parameter/expansion**, karena ini merupakan fondasi yang diperlukan sebelum kita membahas fitur Zsh yang lebih tinggi.

## Lesson 01 — Zsh vs Bash

### Bagian 02 — Syntax Compatibility dan Parameter Expansion

Setelah memahami posisi Zsh terhadap Bash, kita masuk ke compatibility/incompatibility, lalu parameter/expansion, sebelum bergerak ke arrays, globbing, conditional, function, redirection, options, builtins, dan interactive layer.

### 01.2.1 — Tiga kategori syntax

Saat membawa pengetahuan Bash ke Zsh, gunakan tiga kategori berikut:

```text
Syntax Bash
│
├── 1. Sama dan kompatibel
│
├── 2. Mirip tetapi perilakunya berbeda
│
└── 3. Bash-specific
        └── jangan diasumsikan berlaku di Zsh
```

Kategori kedua adalah yang paling berbahaya.

Contohnya:

```bash
arr=(A B C)
```

dan:

```zsh
arr=(A B C)
```

Syntax-nya sama, tetapi indexing array berbeda.

Jadi saat mem-port script Bash ke Zsh, jangan hanya bertanya:

> “Apakah syntax-nya valid?”

Tetapi juga:

> “Apakah semantic behavior-nya sama?”

Ini akan menjadi kebiasaan penting ketika nanti Anda membaca plugin Zsh.

---

## 01.2.2 — Parameter dalam Zsh

Di shell, istilah yang lebih tepat untuk dipahami adalah **parameter**, bukan hanya “variable”.

Contoh:

```zsh
name="Amir"
```

Kemudian:

```zsh
print "$name"
```

Secara sederhana:

```text
name
 │
 ▼
parameter
 │
 ▼
"Amir"
```

Shell melakukan parameter expansion ketika `$name` digunakan.

```zsh
$name
```

atau:

```zsh
${name}
```

Keduanya dapat digunakan dalam banyak konteks.

Contoh:

```zsh
name="Amir"

print "$name"
print "${name}"
```

Hasilnya sama.

Tetapi `${...}` menjadi sangat penting ketika expansion mulai kompleks.

---

## 01.2.3 — Mengapa `${...}` penting?

Perhatikan:

```zsh
name="Amir"

print "${name}123"
```

Yang dimaksud adalah:

```text
nilai name + literal 123
```

Hasil:

```text
Amir123
```

Tanpa boundary yang jelas, shell dapat kesulitan menentukan bagian mana yang merupakan nama parameter.

Karena itu:

```zsh
${name}
```

dapat dipahami sebagai bentuk eksplisit:

```text
mulai parameter expansion
        ↓
       name
        ↓
selesai expansion
```

Nanti kita akan menemukan bentuk yang jauh lebih kompleks:

```zsh
${name:-default}
${name##pattern}
${name%%pattern}
${name:l}
${name:u}
${name//old/new}
```

Untuk sekarang jangan menghafalnya.

Yang perlu dibangun adalah pemahaman bahwa:

> `${...}` bukan sekadar cara lain menulis `$variable`; ia adalah pintu masuk ke sistem parameter expansion Zsh.

---

# 01.2.4 — Parameter expansion adalah salah satu pusat bahasa Zsh

Di Bash, parameter expansion juga penting.

Tetapi di Zsh, sistem ini menjadi salah satu bagian paling kuat dari bahasa.

Modelnya:

```text
Parameter
   │
   ▼
Parameter Expansion
   │
   ├── mengambil nilai
   ├── memilih bagian nilai
   ├── mengganti nilai
   ├── memodifikasi bentuk
   ├── mengolah array
   └── menghasilkan nilai untuk command
```

Karena itu nanti kurikulum memiliki:

```text
02 — Zsh Language
03 — Parameter Expansion
04 — Arrays & Data Manipulation
```

Ada alasan mengapa parameter expansion mendapat tahap tersendiri.

---

# 01.2.5 — Positional parameters

Seperti Bash, Zsh mempunyai positional parameters.

Contoh konseptual:

```zsh
print "$1"
print "$2"
```

Jika sebuah function dipanggil:

```zsh
my_function one two
```

maka:

```text
$1 → one
$2 → two
```

Zsh juga memiliki:

```zsh
$0
$1
$2
$3
...
```

serta:

```zsh
$#
```

untuk jumlah positional parameters.

Ini adalah bagian yang sudah Anda kenal dari Bash.

Jadi di sini kita tidak mengulang konsepnya dari awal. Yang perlu Anda tanamkan adalah bahwa Zsh mempertahankan banyak konsep shell parameter yang sudah Anda kuasai.

---

# 01.2.6 — Special parameters

Zsh juga mempunyai banyak special parameters.

Contoh yang sudah kita gunakan pada Lesson 00:

```zsh
$$
```

yang merepresentasikan [PID] shell saat ini.

Contoh lainnya yang nanti akan sering ditemui:

```zsh
$?
```

exit status command terakhir.

```zsh
$!
```

PID proses background terakhir.

```zsh
$#
```

jumlah positional parameters.

```zsh
$0
```

nama shell/function/script dalam konteks tertentu.

Dan masih banyak lagi.

Jadi ketika membaca konfigurasi Zsh:

```zsh
if (( $? != 0 )); then
    ...
fi
```

Anda harus bisa mengenali `$?` sebagai special parameter, bukan variable biasa.

---

# 01.2.7 — Quoting tetap penting

Pengetahuan Bash mengenai quoting tetap sangat berguna.

Tiga bentuk dasar:

```text
'...'
"..."
tanpa quote
```

Contoh:

```zsh
name="Amir"

print "$name"
print '$name'
print $name
```

Secara konseptual:

```text
"$name"
    │
    └── parameter expansion terjadi

'$name'
    │
    └── literal, tidak diexpand

$name
    │
    └── expansion terjadi, tetapi hasil akhirnya dapat
        mengalami pemrosesan shell berikutnya
```

Ini akan menjadi jauh lebih penting di Zsh karena Zsh memiliki expansion system yang lebih kaya.

Jangan menganggap:

```zsh
"$array"
```

dan:

```zsh
$array
```

selalu memiliki arti yang sama.

Khususnya ketika parameter tersebut merupakan array.

Itulah salah satu alasan mengapa kita akan mempelajari parameter expansion secara mendalam nanti.

---

# 01.2.8 — Zsh mempunyai expansion yang lebih banyak

Secara konseptual, command line Zsh melewati beberapa jenis pemrosesan.

Salah satu model sederhananya:

```text
source code
    │
    ▼
lexing / parsing
    │
    ▼
parameter expansion
    │
    ▼
command substitution
    │
    ▼
arithmetic expansion
    │
    ▼
filename generation / globbing
    │
    ▼
command execution
```

Urutan persisnya memiliki detail yang lebih kompleks dan akan kita pelajari ketika masuk ke `zshexpn`.

Untuk Lesson 01, yang penting adalah mengenali bahwa:

> Shell tidak sekadar mengganti `$variable` menjadi teks lalu menjalankan command.

Ada sistem expansion yang bekerja sebelum command dieksekusi.

Zsh memperluas sistem tersebut secara signifikan.

---

# 01.2.9 — Command substitution

Ini sudah Anda kenal dari Bash:

```bash
result=$(command)
```

Zsh juga mendukung:

```zsh
result=$(command)
```

Contoh:

```zsh
current_dir=$(pwd)

print "$current_dir"
```

Ini termasuk konsep yang dapat langsung dibawa dari Bash.

Tetapi Zsh juga mempunyai mekanisme expansion dan substitution lain yang akan kita pelajari secara terpisah.

---

# 01.2.10 — Arithmetic expansion

Demikian pula:

```zsh
number=10

print $((number + 5))
```

Hasil:

```text
15
```

Konsep:

```text
$(( ... ))
```

sudah Anda kenal dari Bash.

Namun Zsh mempunyai integrasi arithmetic yang lebih luas dengan parameter dan tipe integer.

Nanti kita akan membahasnya dalam bagian bahasa Zsh.

---

# 01.2.11 — Process substitution

Bash:

```bash
diff <(command1) <(command2)
```

Zsh juga mendukung konsep:

```zsh
diff <(command1) <(command2)
```

Ini merupakan contoh penting bahwa pengetahuan Bash Anda tidak dibuang.

Konsep:

```text
command1
   │
   └── process substitution ──┐
                              │
command2                      ├── diff
   │                          │
   └── process substitution ──┘
```

Tetapi implementasi dan fitur lanjutan Zsh tetap akan kita pelajari ketika masuk ke bagian redirection/process substitution.

---

# 01.2.12 — Perbedaan yang mulai terasa: ekspresi array

Sekarang kita kembali ke array karena di sinilah model Zsh mulai berbeda secara nyata.

Zsh:

```zsh
files=(one two three)
```

Anda dapat mengakses:

```zsh
print "$files[1]"
```

atau beberapa elemen:

```zsh
print "$files[1,2]"
```

Secara konseptual:

```text
files
 │
 ├── [1] one
 ├── [2] two
 └── [3] three
```

Sedangkan Bash menggunakan model indexing berbeda.

Ini menunjukkan bahwa Zsh tidak hanya mengganti beberapa builtin Bash.

Sistem parameter Zsh sendiri mempunyai semantic model yang berbeda.

---

# 01.2.13 — Kenapa kita belum membahas semua expansion?

Karena kurikulum sengaja memisahkan:

```text
Lesson 01
    ↓
memahami perbedaan Bash ↔ Zsh

Lesson 02
    ↓
mempelajari bahasa Zsh secara sistematis

Lesson 03
    ↓
membedah parameter expansion

Lesson 04
    ↓
arrays dan data manipulation

Lesson 05
    ↓
globbing
```

Dengan demikian Lesson 01 menjawab:

> “Apa yang berbeda?”

Sedangkan Lesson 02–05 menjawab:

> “Bagaimana mekanismenya bekerja?”

Ini menjaga agar kita tidak mencampur orientasi dengan pendalaman.

---

# 01.2.14 — Prinsip porting Bash → Zsh

Ketika suatu saat Anda memiliki script Bash:

```bash
#!/usr/bin/env bash
```

dan ingin memindahkannya ke:

```zsh
#!/usr/bin/env zsh
```

jangan melakukan:

```text
ganti interpreter
       ↓
selesai
```

Gunakan proses:

```text
Bash script
    │
    ▼
identifikasi Bash-specific features
    │
    ├── arrays
    ├── expansion
    ├── builtins
    ├── options
    ├── conditionals
    └── behavior
    │
    ▼
cek padanan Zsh
    │
    ▼
port
    │
    ▼
uji behavior
```

Ini akan sangat relevan ketika nanti Anda mulai membaca konfigurasi `.zshrc` milik sendiri.

---

## Posisi Lesson 01 sekarang

```text
01 — Zsh vs Bash
│
├── ✓ Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific behavior
├── ✓ Compatibility ≠ identity
├── ✓ Parameter dasar
├── ✓ Parameter expansion sebagai konsep
│
├── → Arrays
├── → Globbing
├── → Conditional expressions
├── → Functions
├── → Redirection & process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Bagian berikutnya yaitu **Arrays: perbedaan model array Bash dan Zsh secara lebih mendalam**. 

### Bagian 03 — Arrays: Bash vs Zsh

Bagian ini mengikuti cabang `Arrays` dalam kurikulum, tetapi belum masuk ke pendalaman penuh `Arrays & Data Manipulation` pada Lesson 04. Di sini fokusnya adalah memahami perbedaan model Bash dan Zsh.

### 01.3.1 — Array sebagai parameter

Di kedua shell, array dapat dibuat dengan bentuk yang mirip:

Bash:

```bash
arr=(one two three)
```

Zsh:

```zsh
arr=(one two three)
```

Sekilas tidak ada perbedaan.

Tetapi jangan berhenti pada syntax. Perhatikan bagaimana elemen tersebut direpresentasikan.

Di Bash:

```text
arr
├── [0] one
├── [1] two
└── [2] three
```

Di Zsh:

```text
arr
├── [1] one
├── [2] two
└── [3] three
```

Ini adalah perbedaan fundamental.

---

### 01.3.2 — Indexing

Bash:

```bash
arr=(one two three)

printf '%s\n' "${arr[0]}"
```

menghasilkan:

```text
one
```

Zsh:

```zsh
arr=(one two three)

print "$arr[1]"
```

menghasilkan:

```text
one
```

Jadi:

```text
Bash                       Zsh

${arr[0]} → one            $arr[1] → one
${arr[1]} → two            $arr[2] → two
${arr[2]} → three          $arr[3] → three
```

Perbedaan ini harus menjadi refleks ketika membaca kode.

Jika Anda melihat:

```zsh
$array[1]
```

jangan membacanya dengan mental model Bash:

```text
"elemen kedua"
```

Dalam Zsh itu adalah **elemen pertama**.

---

### 01.3.3 — Index negatif

Zsh juga mendukung indexing dari belakang.

Misalnya:

```zsh
arr=(one two three)
```

Kemudian:

```zsh
print "$arr[-1]"
```

mengacu pada elemen terakhir:

```text
three
```

Secara konseptual:

```text
        depan             belakang
          │                  │
          ▼                  ▼
       [1] [2] [3]
       one two three
                 [-1]
```

Jadi Zsh menyediakan cara yang sangat nyaman untuk mengambil elemen relatif terhadap akhir array.

Ini akan menjadi semakin berguna ketika nanti kita mempelajari parameter expansion.

---

### 01.3.4 — Range indexing

Zsh juga memungkinkan pemilihan range:

```zsh
arr=(one two three four five)

print "$arr[2,4]"
```

Secara konseptual:

```text
[1] one
[2] two    ←
[3] three  ←
[4] four   ←
[5] five
```

Hasilnya merupakan elemen:

```text
two
three
four
```

Jadi bentuk:

```zsh
$array[start,end]
```

dapat dipahami sebagai:

```text
ambil elemen dari start sampai end
```

Ini merupakan salah satu contoh bagaimana parameter Zsh memiliki operasi yang lebih terintegrasi daripada sekadar mengambil satu nilai.

---

### 01.3.5 — Array dan scalar bukan konsep yang sepenuhnya terpisah

Dalam Zsh, parameter mempunyai tipe/atribut.

Contoh:

```zsh
typeset -a arr
```

berarti parameter tersebut merupakan array biasa.

Sedangkan:

```zsh
typeset -A map
```

merupakan associative array.

Ini membawa kita ke builtin penting:

```zsh
typeset
```

Untuk saat ini cukup pahami:

```text
typeset
   │
   └── mengatur / mendeklarasikan atribut parameter
```

Nanti `typeset` akan kita pelajari kembali pada bagian **Zsh builtins** dan **Zsh language**.

---

# 01.3.6 — Associative array

Bash:

```bash
declare -A user

user[name]="Amir"
user[shell]="zsh"
```

Zsh:

```zsh
typeset -A user

user[name]="Amir"
user[shell]="zsh"
```

Kemudian:

```zsh
print "$user[name]"
```

menghasilkan:

```text
Amir
```

Modelnya:

```text
user
│
├── [name]  → Amir
└── [shell] → zsh
```

Berbeda dengan indexed array:

```text
arr
│
├── [1] → one
├── [2] → two
└── [3] → three
```

Maka secara konseptual:

```text
Zsh parameter
│
├── scalar
│
├── indexed array
│
└── associative array
```

Ini merupakan bagian penting dari sistem parameter Zsh.

---

# 01.3.7 — `$array` adalah hal yang perlu diperhatikan

Dalam Bash, Anda sering menemukan:

```bash
"${arr[@]}"
```

ketika ingin memperluas seluruh elemen array secara terpisah.

Zsh memiliki model expansion yang berbeda.

Misalnya:

```zsh
arr=(one two three)
```

Anda dapat menggunakan:

```zsh
print -rl -- "$arr[@]"
```

Konsepnya:

```text
$arr[@]
   │
   └── seluruh elemen array
```

Namun Anda harus berhati-hati terhadap quoting dan konteks penggunaan.

Ini bukan tempat untuk menghafalkan semua variasi:

```zsh
$array
$array[@]
$array[*]
${array[...]}
```

Karena seluruh sistem tersebut akan menjadi materi khusus pada Lesson 04 dan terutama Lesson 03.

Untuk Lesson 01, yang penting adalah memahami bahwa **array expansion Zsh tidak boleh dibaca menggunakan aturan Bash secara otomatis**.

---

# 01.3.8 — Mengapa ini penting untuk konfigurasi Zsh?

Dalam `.zshrc`, plugin, completion, dan konfigurasi terminal, array sering digunakan untuk menyimpan:

```text
PATH entries
plugin names
completion configuration
arguments
directory lists
command lists
options
```

Misalnya suatu konfigurasi dapat mempunyai:

```zsh
plugins=(git fzf zoxide)
```

Kemudian:

```text
plugins[1] → git
plugins[2] → fzf
plugins[3] → zoxide
```

Jika Anda membawa asumsi Bash:

```text
plugins[0] → git
```

maka seluruh logika Anda bergeser satu posisi.

Pada konfigurasi yang kompleks, kesalahan semacam ini dapat menyebabkan bug yang cukup sulit ditemukan.

---

# 01.3.9 — Array dan `PATH`

Ada satu konsep Zsh yang sangat penting untuk masa depan konfigurasi Anda.

Zsh dapat memperlakukan parameter tertentu sebagai array melalui parameter khusus.

Salah satu contoh terkenal adalah:

```zsh
path
```

yang berkaitan dengan:

```text
PATH
```

Secara konseptual:

```text
PATH
 │
 ▼
/usr/bin:/usr/local/bin:/home/user/bin
```

sedangkan bentuk array-nya:

```text
path
 │
 ├── /usr/bin
 ├── /usr/local/bin
 └── /home/user/bin
```

Ini sangat cocok dengan filosofi Zsh:

```text
PATH sebagai string
        ↓
PATH sebagai kumpulan directory
```

Ini akan sangat relevan ketika kita sampai pada **Lesson 10 — Environment & PATH**.

Untuk sekarang cukup kenali bahwa Zsh mempunyai integrasi parameter yang membuat manipulasi environment tertentu jauh lebih nyaman.

---

# 01.3.10 — Jangan menyamakan array expansion Bash dan Zsh

Perhatikan dua mental model berikut.

Bash:

```text
"${array[@]}"
```

sering digunakan ketika kita ingin mempertahankan setiap elemen sebagai argument terpisah.

Zsh:

```text
$array
$array[@]
```

mempunyai aturan expansion Zsh sendiri.

Jadi ketika melakukan porting:

```text
Bash code
   │
   ▼
"${array[@]}"
   │
   │  jangan langsung mengganti
   ▼
"$array[@]"
```

Kita harus memahami konteks expansion-nya terlebih dahulu.

Ini contoh konkret dari prinsip yang sudah kita bangun:

```text
Syntax mirip
     ≠
Semantik sama
```

---

# 01.3.11 — Eksperimen kecil

Sekarang belum perlu menjawab quiz. Tujuan eksperimen ini hanya membuat perbedaan Bash/Zsh terlihat secara langsung.

Di Zsh:

```zsh
arr=(one two three four five)

print "$arr[1]"
print "$arr[-1]"
print "$arr[2,4]"
```

Perhatikan hubungan:

```text
$arr[1]
$arr[-1]
$arr[2,4]
```

Kemudian:

```zsh
typeset -A user

user[name]="Amir"
user[shell]="zsh"

print "$user[name]"
print "$user[shell]"
```

Sekarang Anda sudah melihat tiga konsep berbeda:

```text
indexed array
     │
     ├── positive index
     ├── negative index
     └── range

associative array
     │
     └── key → value

parameter
     │
     └── dapat mempunyai atribut tertentu
```

---

# 01.3.12 — Posisi kita dalam Lesson 01

Setelah bagian array ini:

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion — pengantar
├── ✓ Arrays — model dasar dan perbedaan
│
├── → Globbing
├── → Conditional expressions
├── → Functions
├── → Redirection
├── → Process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Bagian berikutnya **Lesson 01 — Globbing: perbedaan filename generation Bash dan Zsh**, karena globbing merupakan salah satu perbedaan Zsh yang paling penting untuk dipahami sebelum kita beralih ke bahasa Zsh secara mendalam.

### Bagian 04 — Globbing: Bash vs Zsh

Setelah parameter dan array, sekarang masuk ke `Globbing`. Fokusnya masih perbandingan Bash ↔ Zsh, bukan pendalaman penuh. Pendalaman khusus filename generation akan dilakukan nanti pada **Lesson 05 — Filename Generation / Glob**.

### 01.4.1 — Apa itu globbing?

Globbing adalah mekanisme shell untuk mencocokkan pola terhadap nama file atau direktori.

Misalnya terdapat:

```text
project/
├── main.zsh
├── config.zsh
├── notes.txt
└── README.md
```

Kemudian:

```zsh
print -- *.zsh
```

Shell mencocokkan:

```text
*.zsh
  │
  └── semua nama yang berakhiran .zsh
```

sehingga pola tersebut dapat berkembang menjadi:

```text
main.zsh config.zsh
```

Proses ini disebut **filename generation**.

Mental modelnya:

```text
pattern
   │
   ▼
shell melakukan matching
   │
   ▼
nama file yang cocok
   │
   ▼
command execution
```

Jadi:

```zsh
print -- *.zsh
```

bukan berarti `print` sendiri memahami `*.zsh`.

Shell-lah yang melakukan ekspansi tersebut sebelum `print` menerima argument.

---

# 01.4.2 — Wildcard dasar

Wildcard yang paling dasar:

```text
*
?
[...]
```

`*`:

```zsh
*.zsh
```

berarti pola dengan sejumlah karakter sebelum `.zsh`.

`?`:

```zsh
file?.txt
```

mencocokkan satu karakter pada posisi `?`.

Character class:

```zsh
file[0-9].txt
```

mencocokkan satu karakter yang berada pada rentang `0` sampai `9`.

Konsep ini sudah Anda temui di Bash.

Karena itu bagian ini bukan sesuatu yang harus dipelajari ulang dari nol.

Perbedaannya mulai menarik ketika kita masuk ke kemampuan khusus Zsh.

---

# 01.4.3 — `*` tidak sama dengan recursive search

Perhatikan:

```zsh
*.txt
```

Jika struktur direktori:

```text
project/
├── a.txt
├── b.txt
└── src/
    └── c.txt
```

maka:

```zsh
*.txt
```

berhubungan dengan file `.txt` pada direktori saat ini.

Ia tidak secara otomatis berarti:

```text
semua .txt
di seluruh subdirectory
```

Untuk recursive globbing, Zsh mempunyai:

```zsh
**/*.txt
```

yang memungkinkan pencocokan secara recursive.

Secara konseptual:

```text
*.txt
│
└── current directory

**/*.txt
│
├── current directory
├── subdirectory
├── subdirectory/subdirectory
└── ...
```

Ini salah satu kemampuan Zsh yang akan sangat sering Anda temui.

---

# 01.4.4 — Recursive globbing bukan sekadar `find`

Perhatikan perbedaan mental model:

```text
find
 │
 └── program eksternal
```

sedangkan:

```text
**/*.txt
 │
 └── filename generation shell
```

Jadi ketika menulis:

```zsh
print -rl -- **/*.txt
```

Zsh dapat melakukan pencarian pola tersebut sebagai bagian dari proses ekspansi shell.

Ini sangat berguna untuk scripting dan konfigurasi.

Tetapi jangan menyimpulkan bahwa `**` selalu identik dengan semua kemampuan `find`.

`find` memiliki kemampuan filtering, metadata checking, actions, traversal control, dan sebagainya yang berbeda.

Yang kita pelajari di sini adalah mekanisme **filename generation**.

---

# 01.4.5 — Zsh extended globbing

Zsh mempunyai sistem extended globbing yang jauh lebih kaya.

Untuk mengaktifkannya:

```zsh
setopt EXTENDED_GLOB
```

Setelah option tersebut aktif, pola glob dapat menggunakan operator tambahan.

Contohnya:

```zsh
^*.txt
```

Dalam konteks extended globbing, operator tersebut dapat digunakan untuk membuat pola negasi.

Secara konseptual:

```text
*.txt
   │
   └── match .txt

^*.txt
   │
   └── pola yang tidak match *.txt
```

Detail sintaks extended glob sangat luas. Karena itu kita **tidak akan menghafalkannya sekarang**.

Nanti Lesson 05 akan membedah:

```text
extended glob
├── operators
├── negation
├── grouping
├── repetition
├── qualifiers
└── modifiers
```

---

# 01.4.6 — Globbing adalah bagian dari shell expansion

Ini penting untuk menghubungkan materi sebelumnya.

Kita sebelumnya melihat:

```text
parameter expansion
command substitution
arithmetic expansion
```

Sekarang:

```text
filename generation
```

Semuanya merupakan bagian dari mekanisme expansion shell.

Secara konseptual:

```text
Zsh command line
       │
       ▼
    expansion
       │
       ├── parameter
       ├── command substitution
       ├── arithmetic
       └── filename generation
              │
              ▼
           arguments
              │
              ▼
        command execution
```

Karena itu globbing bukan fitur terpisah dari bahasa shell.

Ia merupakan bagian dari cara shell membentuk argument sebelum command dijalankan.

---

# 01.4.7 — Perbedaan penting Bash dan Zsh: unmatched glob

Ini salah satu perbedaan perilaku yang harus Anda kenali.

Misalnya tidak ada file `.xyz`:

```zsh
print -- *.xyz
```

Perilaku shell terhadap pola yang tidak memiliki kecocokan dapat berbeda antara Bash dan Zsh.

Zsh secara default memiliki perilaku `NOMATCH`, sehingga pola yang tidak menemukan kecocokan dapat menghasilkan error daripada diteruskan secara literal.

Secara konseptual:

```text
pattern
   │
   ▼
ada match?
 ┌─┴─┐
yes  no
 │    │
 ▼    ▼
expand  Zsh dapat error
```

Ini contoh bagus mengapa:

> syntax yang terlihat sama tidak menjamin behavior yang sama.

Bash dan Zsh dapat menerima:

```text
*.xyz
```

tetapi menangani hasil unmatched secara berbeda.

---

# 01.4.8 — Mengapa `NOMATCH` penting dalam konfigurasi?

Bayangkan sebuah function:

```zsh
cleanup() {
    rm -- *.tmp
}
```

Jika tidak ada file `.tmp`, perilakunya perlu Anda pahami.

Jangan hanya melihat:

```zsh
rm -- *.tmp
```

dan berpikir:

> “Ini sama seperti Bash.”

Anda harus mempertimbangkan:

```text
shell options
       │
       ▼
globbing behavior
       │
       ▼
hasil argument
       │
       ▼
rm
```

Inilah alasan `setopt` dan globbing nantinya harus dipahami bersama.

---

# 01.4.9 — Glob qualifiers

Salah satu fitur Zsh yang lebih khas adalah **glob qualifiers**.

Secara konseptual, Zsh dapat menggunakan informasi tambahan tentang file untuk membatasi atau memodifikasi hasil glob.

Contohnya pola glob dapat digunakan untuk memilih jenis file tertentu.

Misalnya konsep:

```text
file biasa
directory
executable
symlink
```

dapat menjadi bagian dari filtering glob.

Ini sangat berbeda dari mental model:

```text
*.txt
```

yang hanya melihat pola nama.

Zsh dapat membuat glob menjadi lebih dekat dengan:

```text
"cari file yang memenuhi nama + atribut tertentu"
```

Detail syntax glob qualifiers kita simpan untuk Lesson 05.

---

# 01.4.10 — Globbing vs regex

Jangan mencampurkan:

```text
glob
```

dengan:

```text
regular expression
```

Keduanya sama-sama melakukan pattern matching, tetapi sistemnya berbeda.

Contoh glob:

```zsh
*.txt
```

Sedangkan regex memiliki konsep seperti:

```text
^.*\.txt$
```

Mental model:

```text
Glob
 │
 └── shell filename generation

Regex
 │
 └── pattern matching dalam tool/program
```

Contoh program yang menggunakan regex:

```text
grep
sed
awk
```

Sedangkan:

```zsh
*.txt
```

diproses oleh shell sebagai glob.

Ini penting karena ketika Anda nanti membuat function Zsh, Anda akan sering menggunakan keduanya untuk tujuan yang berbeda.

---

# 01.4.11 — Glob tidak selalu berarti filesystem

Dalam Zsh, globbing sangat terintegrasi dengan parameter expansion dan pattern matching.

Artinya kemampuan pattern Zsh nantinya tidak hanya berguna untuk:

```text
nama file
```

tetapi juga dapat muncul dalam manipulasi parameter.

Ini merupakan salah satu alasan Zsh memiliki sistem pattern yang jauh lebih dalam daripada sekadar wildcard filename.

Namun detail tersebut kita tahan sampai Lesson 03 dan Lesson 05.

---

# 01.4.12 — Eksperimen

Gunakan direktori sementara agar tidak mengganggu file Anda:

```zsh
mkdir -p /tmp/zsh-glob/a/b
touch /tmp/zsh-glob/one.txt
touch /tmp/zsh-glob/two.txt
touch /tmp/zsh-glob/a/three.txt
touch /tmp/zsh-glob/a/b/four.txt
touch /tmp/zsh-glob/a/note.md
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

Sekarang coba pola yang tidak ada:

```zsh
print -rl -- *.does-not-exist
```

Perhatikan perbedaan perilakunya.

Kemudian:

```zsh
setopt EXTENDED_GLOB
```

dan perhatikan bahwa option tersebut mengubah kemampuan globbing Zsh.

Tidak perlu menghafalkan hasil eksperimen. Tujuan tahap ini adalah membentuk hubungan:

```text
glob
  ↓
filename generation
  ↓
shell option
  ↓
hasil argument
```

---

# 01.4.13 — Posisi kita

Setelah bagian globbing:

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion — pengantar
├── ✓ Arrays
├── ✓ Globbing
│
├── → Conditional expressions
├── → Functions
├── → Redirection
├── → Process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Bagian berikutnya adalah **Conditional Expressions — perbedaan `[ ]`, `[[ ]]`, operator, dan evaluasi kondisi antara Bash dan Zsh**.


## Bagian 05 — Conditional Expressions

Kita masih tetap berada tepat di dalam cakupan **Lesson 01 — Zsh vs Bash**. Urutannya sekarang:

```text
01 — Zsh vs Bash
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion — pengantar
├── ✓ Arrays
├── ✓ Globbing
├── → Conditional expressions  ← SEKARANG
├── → Functions
├── → Redirection
├── → Process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Fokus bagian ini adalah mengetahui apa yang tetap berlaku dari Bash dan di mana Zsh memiliki perilaku atau fasilitas tersendiri.

### 01.5.1 — Dua bentuk conditional yang perlu dibedakan

Dalam shell, Anda sudah mengenal:

```bash
[ "$name" = "Amir" ]
```

dan:

```bash
[[ "$name" == "Amir" ]]
```

Zsh juga mendukung:

```zsh
[ "$name" = "Amir" ]
```

dan:

```zsh
[[ "$name" == "Amir" ]]
```

Jadi syntax dasar tidak perlu Anda pelajari ulang.

Yang penting adalah memahami bahwa:

```text
[ ... ]
```

dan:

```text
[[ ... ]]
```

bukan sekadar dua cara penulisan yang identik.

`[[ ... ]]` merupakan konstruksi conditional yang disediakan shell, dengan aturan parsing dan operator yang berbeda dari command `[ ... ]`.

---

## 01.5.2 — Mengapa `[[ ... ]]` penting di Zsh?

Dalam konfigurasi Zsh, Anda akan sangat sering melihat:

```zsh
if [[ condition ]]; then
    ...
fi
```

Contoh:

```zsh
if [[ -n "$EDITOR" ]]; then
    print "$EDITOR"
fi
```

atau:

```zsh
if [[ "$TERM" == "xterm-256color" ]]; then
    ...
fi
```

Jadi ketika membaca `.zshrc`, bentuk:

```zsh
[[ ... ]]
```

harus langsung Anda kenali sebagai **shell conditional expression**.

---

## 01.5.3 — Operator string

Contoh dasar:

```zsh
name="Amir"

if [[ "$name" == "Amir" ]]; then
    print "match"
fi
```

Operator:

```text
== 
!=
```

digunakan untuk perbandingan.

Anda juga sudah mengenal:

```zsh
[[ -n "$name" ]]
```

untuk memeriksa apakah string tidak kosong.

Dan:

```zsh
[[ -z "$name" ]]
```

untuk memeriksa apakah string kosong.

Mental model:

```text
[[ ... ]]
   │
   ├── string comparison
   ├── string existence
   ├── pattern matching
   ├── file tests
   └── logical combination
```

---

## 01.5.4 — `==` dan pattern matching

Di sini mulai muncul perbedaan penting.

Conditional:

```zsh
[[ "$name" == "Amir" ]]
```

melakukan perbandingan.

Tetapi dalam konteks `[[ ... ]]`, pola dapat digunakan dengan aturan shell pattern tertentu.

Contoh:

```zsh
name="Amir"

if [[ "$name" == A* ]]; then
    print "starts with A"
fi
```

`A*` di sini bukan berarti shell melakukan filename globbing terhadap filesystem.

Ini penting.

Kita sebelumnya membahas:

```zsh
*.txt
```

sebagai filename generation.

Tetapi:

```zsh
[[ "$name" == A* ]]
```

menggunakan pattern matching di dalam conditional.

Jadi:

```text
*.txt
  ↓
filename generation

A*
  ↓
pattern matching dalam [[ ... ]]
```

Syntax pattern-nya dapat terlihat sama, tetapi konteks pemrosesannya berbeda.

---

## 01.5.5 — `[[ ... ]]` dan `&&` / `||`

Anda dapat menggabungkan kondisi:

```zsh
if [[ -n "$name" && "$name" == "Amir" ]]; then
    print "valid"
fi
```

atau:

```zsh
if [[ -z "$name" || "$name" == "unknown" ]]; then
    print "empty or unknown"
fi
```

Secara konseptual:

```text
[[ condition1 && condition2 ]]
              │
              ▼
        keduanya benar


[[ condition1 || condition2 ]]
              │
              ▼
       salah satunya benar
```

Ini sangat mirip dengan yang sudah Anda kenal dari Bash.

Jadi sekali lagi:

```text
Pengetahuan Bash
       │
       ▼
tetap digunakan
       │
       ▼
pelajari perbedaan Zsh
```

bukan mengulang dari nol.

---

## 01.5.6 — File tests

Zsh juga menyediakan pemeriksaan file melalui conditional expressions.

Contoh:

```zsh
if [[ -f "$file" ]]; then
    print "regular file"
fi
```

Direktori:

```zsh
if [[ -d "$dir" ]]; then
    print "directory"
fi
```

File readable:

```zsh
if [[ -r "$file" ]]; then
    print "readable"
fi
```

Ini merupakan konsep shell yang sudah Anda kenal.

Yang penting untuk Lesson 01 adalah mengetahui bahwa bagian ini dapat dibawa dari Bash ke Zsh.

---

## 01.5.7 — Arithmetic condition

Zsh juga memiliki arithmetic evaluation.

Misalnya:

```zsh
count=10

if (( count > 5 )); then
    print "greater than five"
fi
```

Perhatikan bentuk:

```zsh
(( ... ))
```

Ini bukan `[[ ... ]]`.

Ia merupakan konteks evaluasi arithmetic.

Modelnya:

```text
(( expression ))
       │
       ▼
numeric evaluation
```

Contoh:

```zsh
(( count == 10 ))
(( count > 5 ))
(( count < 20 ))
```

Konsep ini juga sudah ada di Bash.

Jadi kembali:

```text
Bash knowledge
      ↓
langsung berguna
      ↓
pelajari semantic Zsh
```

---

## 01.5.8 — Perbedaan penting: status command vs nilai boolean

Shell tidak memiliki sistem boolean seperti bahasa pemrograman yang biasanya menghasilkan:

```text
true
false
```

Sebaliknya, conditional shell berhubungan dengan **exit status**.

Misalnya:

```zsh
[[ -n "$name" ]]
```

Jika kondisi benar, statusnya:

```text
0
```

Jika salah:

```text
non-zero
```

Karena itu:

```zsh
if [[ -n "$name" ]]; then
    ...
fi
```

secara konseptual berarti:

```text
jalankan conditional
       ↓
periksa exit status
       ↓
0 ?
├── ya  → then
└── tidak → else
```

Ini adalah konsep yang sudah Anda pelajari dalam Bash dan sangat penting untuk dibawa ke Zsh.

---

## 01.5.9 — `[[ ... ]]` bukan external command

Ini juga penting untuk mental model.

Ketika Anda menulis:

```zsh
[[ -f "$file" ]]
```

shell tidak menjalankan sebuah program eksternal bernama `[[`.

`[[ ... ]]` merupakan bagian dari syntax shell.

Demikian pula:

```zsh
(( count > 5 ))
```

merupakan konstruksi shell.

Bandingkan dengan:

```zsh
test -f "$file"
```

`test` merupakan builtin yang menyediakan mekanisme lain untuk melakukan pemeriksaan.

Mental model:

```text
[[ ... ]]
    │
    └── shell conditional construct

(( ... ))
    │
    └── arithmetic evaluation construct

test / [
    │
    └── conditional command/builtin interface
```

Perbedaan seperti ini akan semakin penting ketika nanti kita mempelajari parsing dan execution model Zsh.

---

## 01.5.10 — Mengapa `[[ ... ]]` penting untuk konfigurasi?

Konfigurasi Zsh sering harus memeriksa keadaan environment.

Contohnya secara konseptual:

```zsh
if [[ -o interactive ]]; then
    ...
fi
```

atau:

```zsh
if [[ -n "$commands[fzf]" ]]; then
    ...
fi
```

atau:

```zsh
if [[ -d "$HOME/.config" ]]; then
    ...
fi
```

Artinya conditional expressions nantinya menjadi bagian dari pola konfigurasi:

```text
startup
   │
   ▼
deteksi environment
   │
   ├── command tersedia?
   ├── directory tersedia?
   ├── option aktif?
   ├── parameter terisi?
   └── shell berada dalam mode tertentu?
          │
          ▼
       konfigurasi
```

Ini sangat relevan dengan tujuan akhir Anda untuk memahami `.zshrc`.

---

## 01.5.11 — Pattern matching bukan globbing filesystem

Ini perlu ditekankan karena kedua materi berdekatan.

Globbing:

```zsh
print -- *.txt
```

dapat menghasilkan nama file.

Conditional:

```zsh
[[ "$file" == *.txt ]]
```

tidak mencari file.

Ia membandingkan **nilai string** dengan pattern.

Contoh:

```text
file="config.txt"
```

Kemudian:

```zsh
[[ "$file" == *.txt ]]
```

berarti:

```text
nilai file
    │
    ▼
"config.txt"
    │
    ▼
cocok dengan pattern *.txt ?
```

Bukan:

```text
cari semua file *.txt
```

Perbedaan ini harus benar-benar jelas sebelum kita masuk lebih jauh ke Zsh pattern system.

---

# 01.5.12 — Ringkasan bagian Conditional Expressions

Yang perlu dibawa dari bagian ini:

```text
Bash → Zsh
│
├── [ ... ]             → tersedia
├── [[ ... ]]           → tersedia dan sangat penting
├── (( ... ))           → arithmetic evaluation
├── -n / -z             → string tests
├── -f / -d / -r        → file tests
├── && / ||             → logical combination
└── pattern matching    → dapat digunakan dalam [[ ... ]]
```

Dan satu prinsip penting:

```text
[[ "$value" == *.txt ]]
```

≠

```text
*.txt
```

Yang pertama adalah **pattern matching dalam conditional**.

Yang kedua adalah **filename generation**.

---

## Posisi Lesson 01

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
│
├── → Functions
├── → Redirection
├── → Process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Bagian berikutnya sesuai urutan kurikulum adalah **Functions — perbedaan function Bash dan Zsh, kemudian konsep `autoload` yang menjadi dasar arsitektur function/plugin Zsh**. Disini fokusnya bukan mempelajari function dari nol—konsep dasarnya sudah Anda kuasai dari Bash—melainkan memahami bagaimana function bekerja di Zsh dan apa yang nantinya menjadi fondasi konfigurasi modular serta plugin.

### 01.6.1 — Function dasar

Bentuk yang paling familiar:

```zsh
hello() {
    print "Hello"
}
```

Kemudian:

```zsh
hello
```

Output:

```text
Hello
```

Bentuk ini juga sudah Anda kenal dari Bash:

```bash
hello() {
    printf '%s\n' "Hello"
}
```

Jadi struktur dasarnya tidak berubah:

```text
nama_function()
    │
    ▼
{ body }
    │
    ▼
pemanggilan function
```

Perbedaan pertama yang langsung terlihat adalah builtin Zsh `print`.

Di Zsh:

```zsh
print "Hello"
```

merupakan builtin yang sangat penting dan akan sering ditemukan dalam konfigurasi Zsh.

---

### 01.6.2 — Function sebagai command

Setelah didefinisikan:

```zsh
hello() {
    print "Hello"
}
```

function tersebut menjadi bagian dari command namespace shell:

```zsh
hello
```

Anda dapat melihatnya menggunakan:

```zsh
whence -f hello
```

Zsh akan menunjukkan definisi function tersebut.

Ini memperkenalkan salah satu builtin penting Zsh:

```zsh
whence
```

yang nanti akan kita bahas lebih lengkap ketika masuk ke **Builtins**.

Untuk sekarang, pahami:

```text
whence
  │
  └── membantu mengetahui bagaimana Zsh
      mengenali suatu nama command
```

---

### 01.6.3 — Argument function

Seperti Bash, argument function tersedia melalui positional parameters.

```zsh
greet() {
    print "Hello, $1"
}
```

Kemudian:

```zsh
greet Amir
```

menghasilkan:

```text
Hello, Amir
```

Parameter:

```text
$1
$2
$3
...
```

tetap digunakan.

Contoh:

```zsh
greet() {
    print "name : $1"
    print "shell: $2"
}
```

Pemanggilan:

```zsh
greet Amir zsh
```

menghasilkan:

```text
name : Amir
shell: zsh
```

Konsep ini dapat langsung dibawa dari Bash.

---

### 01.6.4 — `$@`, `$*`, dan array argument

Di sinilah Anda harus mulai berhati-hati.

Zsh memiliki model array yang berbeda dari Bash.

Misalnya:

```zsh
show_args() {
    print -rl -- "$@"
}
```

Pemanggilan:

```zsh
show_args one two three
```

akan memproses argument secara individual.

Zsh memperlakukan positional parameters sebagai array dengan karakteristik Zsh sendiri.

Ini berkaitan erat dengan materi sebelumnya:

```text
Bash
└── indexed array biasanya mulai dari 0

Zsh
└── indexed array biasanya mulai dari 1
```

Jadi jangan membawa seluruh aturan ekspansi array Bash secara mekanis ke Zsh.

Prinsip yang harus Anda pertahankan:

> Function syntax dapat terlihat sama, tetapi parameter expansion dan array semantics tetap harus dipahami sebagai aturan Zsh.

---

## 01.6.5 — `local` dan `typeset`

Di Bash Anda sudah mengenal:

```bash
my_function() {
    local value="hello"
}
```

Zsh juga mendukung local variables.

Contoh:

```zsh
my_function() {
    local value="hello"
    print "$value"
}
```

Namun Zsh memiliki builtin yang jauh lebih sentral:

```zsh
typeset
```

Contoh:

```zsh
my_function() {
    typeset value="hello"
    print "$value"
}
```

Dalam function, `typeset` dapat digunakan untuk membuat parameter lokal.

Zsh juga menggunakan `typeset` untuk berbagai deklarasi parameter:

```zsh
typeset -a array
typeset -A map
typeset -i number
```

Karena itu:

```text
Bash
└── local
     │
     └── sangat umum untuk local variable

Zsh
└── typeset
     │
     ├── local parameters
     ├── arrays
     ├── associative arrays
     ├── integer parameters
     └── parameter attributes
```

Nanti kita akan membahas `typeset` secara lebih mendalam.

---

# 01.6.6 — Function syntax `function name`

Zsh juga menerima bentuk:

```zsh
function hello {
    print "Hello"
}
```

Jadi Anda dapat menemukan dua bentuk:

```zsh
hello() {
    print "Hello"
}
```

dan:

```zsh
function hello {
    print "Hello"
}
```

Untuk membaca konfigurasi Zsh, Anda harus mampu memahami keduanya.

Jangan menyimpulkan bahwa setiap function Zsh harus ditulis dengan satu gaya tertentu.

---

# 01.6.7 — Function dapat menggunakan shell state

Ini sangat penting untuk konfigurasi.

Function bukan sekadar blok kode yang menerima argument.

Function berjalan di dalam shell dan dapat mengakses serta memodifikasi parameter, option, directory, dan state shell sesuai scope dan mekanisme yang digunakan.

Contoh:

```zsh
show_shell() {
    print "$ZSH_VERSION"
}
```

Kemudian:

```zsh
show_shell
```

Function tersebut dapat membaca parameter environment/shell yang tersedia.

Ini menjadi dasar:

```text
.zshrc
 │
 ├── define function
 │
 ├── define widget
 │
 ├── define hook
 │
 └── function digunakan selama shell berjalan
```

Jadi function adalah salah satu komponen utama yang nantinya menghubungkan **bahasa Zsh** dengan **interactive Zsh**.

---

# 01.6.8 — Return status

Function juga memiliki exit status.

```zsh
check() {
    return 0
}
```

Kemudian:

```zsh
check
print $?
```

akan menghasilkan:

```text
0
```

Sedangkan:

```zsh
check() {
    return 1
}
```

akan menghasilkan status non-zero.

Ini langsung berhubungan dengan materi sebelumnya:

```text
function
   │
   ▼
return status
   │
   ▼
$?
   │
   ▼
if / && / ||
```

Contoh:

```zsh
check_file() {
    [[ -f "$1" ]]
}
```

Kemudian:

```zsh
if check_file "$HOME/.zshrc"; then
    print "exists"
fi
```

Function tersebut tidak perlu secara eksplisit menulis:

```zsh
return $?
```

karena status command terakhir dapat menjadi status function.

Ini adalah pola yang sangat umum dalam shell scripting.

---

# 01.6.9 — Function biasa vs `autoload`

Sekarang kita sampai pada bagian yang sangat penting untuk tujuan akhir Anda.

Dalam Bash, Anda mungkin terbiasa dengan:

```text
script
 └── define functions
```

Sedangkan Zsh memiliki mekanisme yang memungkinkan function disimpan secara terpisah dan dimuat ketika diperlukan:

```zsh
autoload
```

Contoh konseptual:

```zsh
autoload -Uz my_function
```

Ini **bukan sekadar alternatif syntax function**.

`autoload` merupakan bagian dari mekanisme modularisasi Zsh.

Mental model:

```text
Function biasa
│
└── function sudah didefinisikan di shell

autoload
│
└── Zsh diberi tahu bahwa function
    dapat dimuat dari function definition file
```

Ini merupakan salah satu alasan mengapa memahami Zsh secara mendalam nantinya membawa Anda ke:

```text
autoload
   ↓
function directories
   ↓
completion functions
   ↓
widgets
   ↓
plugin architecture
```

Tetapi kita **belum masuk ke mekanisme `autoload` secara mendalam sekarang**. Itu akan menjadi materi tersendiri ketika kurikulum masuk ke **Functions & Autoload**.

Untuk Lesson 01, yang perlu Anda pahami hanya posisinya:

> Zsh mempunyai sistem function yang lebih modular daripada sekadar mendefinisikan semua function langsung di `.zshrc`.

---

# 01.6.10 — Mengapa `autoload -Uz` sering muncul?

Ketika nanti membaca konfigurasi/plugin Zsh, Anda sangat mungkin menemukan:

```zsh
autoload -Uz compinit
```

atau:

```zsh
autoload -Uz some_function
```

Untuk saat ini jangan menghafalkan `-U` dan `-z` sebagai mantra.

Pahami struktur besarnya:

```text
autoload
   │
   ├── mengambil function dari function search path
   │
   └── membuat function tersedia untuk digunakan
```

Detail:

```text
autoload flags
function search path
autoloaded functions
load behavior
```

akan dibahas saat kita sampai pada **Lesson 08 — Functions & Autoload**.

Ini sengaja ditahan agar kita tidak keluar dari urutan kurikulum.

---

# 01.6.11 — Bash function vs Zsh function

Perbandingan mental model:

```text
                    Bash                  Zsh
                    ────                  ───
Function syntax     ✓                     ✓
$1, $2, ...         ✓                     ✓
$@                  ✓                     ✓
return status       ✓                     ✓
local variable      local                 local/typeset
Function loading    source                autoload
Modular functions   manual arrangement    autoload system
```

Bagian terakhir sangat penting.

Bukan berarti Bash tidak dapat membuat sistem modular.

Bash bisa:

```bash
source file.sh
```

Tetapi Zsh memiliki konsep function autoloading yang merupakan bagian native dari ekosistem Zsh.

---

# 01.6.12 — Hubungannya dengan tujuan Anda

Tujuan Anda bukan sekadar:

```text
bisa menulis function Zsh
```

Tetapi akhirnya:

```text
memahami konfigurasi
       ↓
memahami function
       ↓
memahami autoload
       ↓
memahami widget
       ↓
memahami hook
       ↓
memahami completion
       ↓
membaca plugin
       ↓
memodifikasi plugin
       ↓
membuat fitur Zsh sendiri
```

Karena itu, `autoload` sekarang cukup dipahami sebagai **konsep yang akan muncul kembali**, bukan dipelajari sampai tuntas.

---

## Posisi kurikulum sekarang

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
│
├── → Redirection
├── → Process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```


## 01.7 — Redirection

Kita tetap berada di **Lesson 01 — Zsh vs Bash**. Tidak ada perpindahan ke Lesson 02.

Posisinya sekarang:

```text
01 — Zsh vs Bash
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
├── → Redirection          ← SEKARANG
├── → Process substitution
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Redirection adalah salah satu bagian Bash yang sudah Anda pelajari. Jadi kita tidak mengulang konsep file descriptor dari awal. Fokusnya adalah memastikan mental model tersebut tetap benar di Zsh dan mengenali kemampuan Zsh yang nantinya sering muncul dalam konfigurasi.

### 01.7.1 — Redirection dasar tetap berlaku

Output standar:

```zsh
print "hello" > output.txt
```

Input dari file:

```zsh
command < input.txt
```

Append:

```zsh
print "hello" >> output.txt
```

Standard error:

```zsh
command 2> error.txt
```

Standard output dan error secara terpisah:

```zsh
command > output.txt 2> error.txt
```

Konsep file descriptor tetap:

```text
0 → stdin
1 → stdout
2 → stderr
```

Sehingga:

```zsh
command > file
```

secara konseptual adalah:

```text
stdout (1)
    │
    ▼
file
```

Sedangkan:

```zsh
command 2> file
```

adalah:

```text
stderr (2)
    │
    ▼
file
```

Ini tidak berubah hanya karena shell yang digunakan adalah Zsh.

---

### 01.7.2 — Redirection terjadi pada level shell

Perhatikan:

```zsh
print "hello" > output.txt
```

`>` bukan argument untuk `print`.

Ia merupakan bagian dari syntax shell.

Mental model:

```text
print "hello" > output.txt
│
├── command: print
├── argument: "hello"
└── redirection:
    stdout → output.txt
```

Hal ini penting ketika nanti membaca konfigurasi Zsh karena banyak perilaku shell sebenarnya berasal dari **expansion + parsing + redirection**, bukan dari command yang dipanggil.

---

### 01.7.3 — Redirecting stdout dan stderr

Pola yang sudah Anda kenal:

```zsh
command >output.txt 2>error.txt
```

Atau menggabungkan keduanya:

```zsh
command >output.txt 2>&1
```

Modelnya:

```text
             ┌── stdout ──→ output.txt
command ─────┤
             └── stderr ──→ stdout
```

Urutan redirection penting.

Misalnya:

```zsh
command >file 2>&1
```

berbeda secara konsep dari:

```zsh
command 2>&1 >file
```

karena redirection diproses berdasarkan urutannya.

Ini adalah konsep file descriptor yang sudah Anda pelajari di Bash dan tetap relevan ketika bekerja dengan Zsh.

---

### 01.7.4 — Pipeline bukan redirection biasa

Contoh:

```zsh
command1 | command2
```

berarti stdout `command1` diberikan sebagai stdin `command2`.

```text
command1
   │
 stdout
   │
   ▼
 stdin
command2
```

Pipeline juga tersedia di Zsh.

Contoh:

```zsh
print -rl -- *.txt | grep config
```

Namun jangan mencampurkan:

```text
|
```

dengan:

```text
>
```

secara konseptual.

```text
|  → menghubungkan proses
>  → mengarahkan file descriptor
```

Keduanya dapat digunakan bersama, tetapi mekanismenya berbeda.

---

## 01.7.5 — Redirection dan Zsh-specific features

Di sinilah Zsh mulai memiliki kemampuan tambahan yang penting.

Salah satu fitur yang akan sering Anda temui adalah bentuk redirection yang berhubungan dengan **multios**.

Zsh dapat mengizinkan satu output diarahkan ke lebih dari satu tujuan.

Contoh konseptual:

```zsh
print "hello" >one >two
```

Dengan mekanisme multios Zsh, output dapat diteruskan ke beberapa file.

Secara mental:

```text
                 ┌──→ one
stdout ──────────┤
                 └──→ two
```

Ini berbeda dari asumsi Bash bahwa redirection terakhir semata-mata menggantikan tujuan sebelumnya.

Fitur ini merupakan salah satu contoh nyata mengapa:

```text
syntax terlihat sama
        ≠
semantics selalu sama
```

yang sejak awal menjadi prinsip utama Lesson 01.

---

## 01.7.6 — `MULTIOS`

Perilaku tersebut dikendalikan oleh option Zsh:

```zsh
MULTIOS
```

Nanti kita akan mempelajari option secara khusus, tetapi untuk sekarang cukup mengetahui hubungan:

```text
setopt MULTIOS
       │
       ▼
Zsh dapat melakukan multiple redirections
```

Anda dapat melihat status option dengan mekanisme Zsh yang akan kita bahas lebih lanjut nanti.

Jangan menghafalkan implementasinya sekarang. Yang penting adalah mengenali ketika Anda membaca konfigurasi:

```zsh
setopt MULTIOS
```

itu berkaitan dengan perilaku redirection Zsh.

---

# 01.7.7 — Redirection ke dan dari command

Konsep lain yang penting adalah redirection yang tidak hanya menggunakan file.

Misalnya process substitution:

```zsh
command < <(other_command)
```

Tetapi ini sudah masuk ke materi berikutnya.

Untuk Lesson 01, kita pisahkan dengan jelas:

```text
Redirection
└── file descriptor → file / stream

Process substitution
└── command → digunakan sebagai input/output
```

Dengan pemisahan ini kita tidak mencampurkan dua konsep yang berdekatan.

---

# 01.7.8 — `print` dan redirection

Karena Zsh memiliki builtin `print`, Anda akan sering melihat:

```zsh
print -r -- "message" >file
```

Perhatikan bahwa:

```text
print
```

adalah command/builtin Zsh, sedangkan:

```text
>
```

adalah redirection shell.

Jadi:

```text
print -r -- "message" >file
│                  │
│                  └── shell redirection
└── Zsh builtin
```

Pemisahan ini penting ketika nanti kita mempelajari **Zsh builtins**.

---

# 01.7.9 — File descriptor tetap menjadi fondasi

Karena Anda sudah mempelajari file descriptor di Bash, kita tidak perlu mengulang teori dasarnya.

Yang perlu dipastikan:

```text
Zsh
│
├── stdin  = 0
├── stdout = 1
└── stderr = 2
```

dan operasi seperti:

```zsh
1>file
2>file
<file
2>&1
```

tetap harus Anda pahami.

Nantinya, ketika membuat function atau plugin Zsh, kemampuan ini digunakan untuk mengontrol:

```text
output function
error message
input
pipeline
command substitution
temporary output
```

Jadi redirection bukan materi terpisah dari scripting; ia merupakan bagian dari execution model shell.

---

# 01.7.10 — Prinsip porting Bash → Zsh

Ketika menemukan Bash:

```bash
command >output.txt 2>&1
```

Anda tidak perlu mencari "versi Zsh" secara otomatis.

Pertama tanyakan:

```text
Apakah syntax ini merupakan shell concept umum?
```

Jika ya, kemungkinan besar konsepnya tetap berlaku.

Kemudian tanyakan:

```text
Apakah Zsh memberikan semantic tambahan?
```

Untuk redirection, salah satu jawabannya adalah **multios**.

Maka pendekatannya:

```text
Bash syntax
    ↓
identifikasi konsep
    ↓
uji di Zsh
    ↓
periksa semantic Zsh
```

Bukan:

```text
Bash syntax
    ↓
terjemahkan setiap karakter
    ↓
anggap selesai
```

---

# 01.8 — Process Substitution

Sekarang kita lanjut tepat ke item berikutnya dalam kurikulum.

Process substitution adalah fitur shell yang mungkin sudah pernah Anda lihat di Bash:

```zsh
<(command)
```

atau:

```zsh
>(command)
```

Tujuannya adalah membuat output/input suatu command dapat digunakan seolah-olah berupa file.

---

## 01.8.1 — `<(command)`

Contoh:

```zsh
diff <(command1) <(command2)
```

Mental model:

```text
command1 ──┐
           │
           ▼
       pseudo-file
           │
           ▼
         diff
           ▲
           │
       pseudo-file
           ▲
           │
command2 ──┘
```

Jadi `diff` tidak menerima:

```text
output command1
output command2
```

sebagai argument string biasa.

Ia menerima path-like input yang mewakili output kedua command.

---

## 01.8.2 — Mengapa process substitution berguna?

Misalnya:

```zsh
diff <(sort file1) <(sort file2)
```

Daripada harus:

```text
sort file1 → temporary file
sort file2 → temporary file
diff temporary files
hapus temporary files
```

process substitution memungkinkan shell menyediakan mekanisme perantara tersebut.

Mental model:

```text
tanpa process substitution:

command
   ↓
temporary file
   ↓
command berikutnya


dengan process substitution:

command
   ↓
<(command)
   ↓
command berikutnya
```

Ini sangat berguna dalam scripting.

---

## 01.8.3 — `>(command)`

Arah sebaliknya:

```zsh
command > >(other_command)
```

Secara konseptual:

```text
command
   │
 stdout
   │
   ▼
>(other_command)
   │
   ▼
other_command
```

Jadi `>(...)` menyediakan endpoint yang dapat menerima data.

Perhatikan perbedaan:

```text
<(command)
    │
    └── command menghasilkan input

>(command)
    │
    └── command menerima output
```

---

## 01.8.4 — Process substitution bukan pipeline

Bandingkan:

```zsh
command1 | command2
```

dengan:

```zsh
command2 <(command1)
```

Pipeline:

```text
command1
   │
   ▼
command2
```

Process substitution:

```text
command1
   │
   ▼
pseudo-file
   │
   ▼
command2
```

Ini memungkinkan command kedua menggunakan hasil command pertama melalui interface yang menyerupai file.

Contoh:

```zsh
diff <(sort file1) <(sort file2)
```

`diff` secara natural bekerja dengan dua input file.

Process substitution memungkinkan kita memberikan hasil command sebagai sumber input tersebut.

---

# 01.8.5 — Process substitution adalah fitur shell, bukan command eksternal

Sama seperti:

```text
[[ ... ]]
(( ... ))
>
|
```

syntax:

```zsh
<(command)
```

diproses oleh shell.

Bukan berarti ada executable bernama `<`.

Mental model:

```text
Zsh parser
    │
    ├── expansion
    ├── redirection
    ├── process substitution
    └── execution
```

Ini mulai memperlihatkan mengapa pemahaman **shell expansion dan execution model** akan sangat penting untuk tahap Zsh yang lebih lanjut.

---

## 01.8.6 — Posisi Bash dan Zsh

Process substitution tersedia di Bash dan Zsh.

Jadi:

```zsh
<(command)
>(command)
```

bukan sesuatu yang harus Anda pelajari ulang sebagai konsep baru.

Yang perlu Anda kuasai dalam Lesson 01 adalah:

```text
Bash
  │
  └── process substitution
          │
          ▼
Zsh
  │
  └── process substitution
```

dengan catatan bahwa masing-masing shell dapat memiliki detail semantic tambahan.

---

# 01.8.7 — Eksperimen kecil

Untuk melihat perbedaannya dengan jelas:

```zsh
mkdir -p /tmp/zsh-redirection
cd /tmp/zsh-redirection

print -r -- "b" > one.txt
print -r -- "a" > two.txt
```

Kemudian:

```zsh
diff <(sort one.txt) <(sort two.txt)
```

Bandingkan dengan:

```zsh
sort one.txt
sort two.txt
```

Tujuan eksperimen ini bukan menghafalkan command, tetapi memahami struktur:

```text
diff
├── input 1 ← hasil command
└── input 2 ← hasil command
```

tanpa membuat temporary files secara manual.

---

## Posisi Lesson 01 sekarang

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
├── ✓ Redirection
├── ✓ Process substitution
│
├── → Options
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

Urutan berikutnya tetap **Options — `setopt` vs `set -o`**, lalu **Builtins**, kemudian **Readline vs ZLE**, dan terakhir **Completion System**. Setelah seluruh cabang Lesson 01 tersebut selesai, barulah kita bergerak ke Lesson 02 sesuai kurikulum.

## 01.9 — Options: `setopt` vs `set -o`

Kita tetap mengikuti urutan **Lesson 01 — Zsh vs Bash**.

```text
01 — Zsh vs Bash
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
├── ✓ Redirection
├── ✓ Process substitution
├── → Options          ← SEKARANG
├── → Builtins
├── → Readline vs ZLE
└── → Completion system
```

### 01.9.1 — Apa itu shell option?

Shell option adalah konfigurasi internal yang mengubah perilaku shell.

Mental model sederhananya:

```text
Zsh
│
├── syntax
├── parameters
├── functions
├── builtins
└── options
      │
      └── mengubah perilaku shell
```

Misalnya sebelumnya kita sudah bertemu:

```zsh
setopt EXTENDED_GLOB
```

Option tersebut mengubah kemampuan pattern matching/globbing Zsh.

Jadi:

```text
command
   +
shell option
   ↓
perilaku Zsh
```

Ini berbeda dari variable biasa.

---

## 01.9.2 — `setopt`

Cara native Zsh untuk mengaktifkan option adalah:

```zsh
setopt OPTION_NAME
```

Contoh:

```zsh
setopt EXTENDED_GLOB
```

Untuk menonaktifkannya:

```zsh
unsetopt EXTENDED_GLOB
```

Mental model:

```text
setopt
   ↓
enable option

unsetopt
   ↓
disable option
```

Contoh:

```zsh
setopt EXTENDED_GLOB
unsetopt EXTENDED_GLOB
```

---

## 01.9.3 — `set -o`

Karena Zsh memiliki hubungan historis dan kompatibilitas dengan shell lain, Anda juga dapat menemukan:

```zsh
set -o
```

dan:

```zsh
set +o
```

Tetapi dalam konfigurasi Zsh, bentuk yang perlu Anda kenali sebagai idiom Zsh adalah:

```zsh
setopt
unsetopt
```

Perbandingan mental:

```text
Bash
└── set -o OPTION
    set +o OPTION

Zsh
├── setopt OPTION
└── unsetopt OPTION
```

Jangan menganggap keduanya sebagai syntax yang sama persis hanya karena memiliki tujuan serupa.

---

## 01.9.4 — Mengapa Zsh memiliki `setopt`?

Zsh memiliki jumlah option yang jauh lebih besar dan option tersebut merupakan bagian penting dari identitas bahasa Zsh.

Contoh yang akan sering Anda temui:

```zsh
setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt CORRECT
setopt INTERACTIVE_COMMENTS
```

Masing-masing mengubah perilaku shell.

Karena itu ketika membaca `.zshrc`, bagian seperti:

```zsh
setopt ...
```

bukan sekadar konfigurasi kosmetik.

Ia dapat mengubah bagaimana Zsh:

* memproses command,
* melakukan globbing,
* menangani directory,
* melakukan history,
* menangani expansion,
* berinteraksi dengan user.

---

# 01.9.5 — `AUTO_CD`

Contoh sederhana:

```zsh
setopt AUTO_CD
```

Dengan option tersebut, directory dapat digunakan sebagai command untuk berpindah ke directory tersebut.

Misalnya:

```text
~/projects
```

Jika `AUTO_CD` aktif, mengetik:

```zsh
projects
```

dapat diperlakukan sebagai perpindahan directory ketika nama tersebut merupakan directory yang sesuai.

Secara konseptual:

```text
tanpa AUTO_CD:

projects
   ↓
command not found


dengan AUTO_CD:

projects
   ↓
cd projects
```

Ini contoh yang baik untuk memahami bahwa option dapat mengubah **bahasa interaktif Zsh**.

---

# 01.9.6 — `EXTENDED_GLOB`

Ini sudah kita temui di bagian globbing:

```zsh
setopt EXTENDED_GLOB
```

Option tersebut mengaktifkan extended globbing.

Jadi sekarang kita bisa melihat hubungan antar-materi:

```text
Lesson 01
│
├── Globbing
│      │
│      └── EXTENDED_GLOB
│
└── Options
       │
       └── setopt EXTENDED_GLOB
```

Materi tidak berdiri sendiri. Kita sengaja kembali ke contoh yang sudah dipelajari.

---

# 01.9.7 — Option bukan environment variable

Jangan mencampurkan:

```zsh
setopt AUTO_CD
```

dengan:

```zsh
export AUTO_CD=1
```

Keduanya merupakan mekanisme yang berbeda.

```text
Shell option
└── state internal Zsh

Parameter/environment variable
└── parameter shell
```

Misalnya:

```zsh
EDITOR=nvim
```

adalah parameter.

Sedangkan:

```zsh
setopt AUTO_CD
```

mengubah option shell.

Ini akan menjadi penting ketika nanti kita membangun konfigurasi `.zshrc`.

---

# 01.9.8 — Memeriksa option

Zsh menyediakan mekanisme untuk melihat option yang aktif.

Salah satu bentuk yang akan Anda temui:

```zsh
setopt
```

Tanpa argument, Zsh dapat menampilkan option yang sedang aktif.

Anda juga akan menemukan:

```zsh
set -o
```

untuk melihat status option dalam format shell-option style.

Untuk pembelajaran sekarang, jangan terlalu fokus pada format output. Yang penting:

```text
setopt
   ↓
mengubah / melihat konfigurasi option Zsh
```

Detail introspection option akan kita gunakan lagi pada materi konfigurasi dan debugging.

---

# 01.9.9 — Option dapat menjadi sumber perbedaan Bash/Zsh

Ini sangat penting ketika melakukan porting.

Misalnya sebuah script berjalan dengan perilaku tertentu di Bash.

Ketika dijalankan di Zsh:

```text
source code sama
       ↓
shell berbeda
       ↓
default option berbeda
       ↓
behavior dapat berbeda
```

Jadi ketika sesuatu yang tampaknya "aneh" terjadi di Zsh, jangan hanya memeriksa:

```text
syntax
```

Periksa juga:

```text
shell options
```

Mental model porting kita sekarang menjadi:

```text
Bash → Zsh
│
├── syntax
├── expansion
├── arrays
├── globbing
├── conditional expressions
├── functions
├── redirection
├── process substitution
└── options
```

---

# 01.9.10 — Option sangat penting dalam `.zshrc`

Tujuan akhir kita adalah memahami konfigurasi Zsh.

Contoh konfigurasi sederhana:

```zsh
# Globbing
setopt EXTENDED_GLOB

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
```

Secara konseptual:

```text
.zshrc
│
├── parameter configuration
├── option configuration
├── function definitions
├── keymap configuration
├── completion configuration
└── prompt configuration
```

Dengan demikian `setopt` akan menjadi salah satu konstruksi yang sangat sering Anda lihat dalam konfigurasi nyata.

---

# 01.9.11 — Hal yang belum kita pelajari sekarang

Kita belum akan membahas seluruh option Zsh.

Itu akan terlalu jauh dari posisi kita dalam kurikulum.

Belum sekarang:

```text
❌ seluruh daftar option Zsh
❌ kombinasi option kompleks
❌ option inheritance
❌ option behavior pada function
❌ local option state
❌ debugging option secara mendalam
```

Semua itu akan muncul ketika fondasi Zsh sudah lebih kuat.

Untuk Lesson 01, targetnya hanya:

```text
Bash
└── set -o

Zsh
├── setopt
└── unsetopt
```

dan memahami bahwa **option merupakan bagian fundamental dari perilaku Zsh**.

---

# 01.10 — Builtins

Sekarang kita masuk ke item berikutnya.

Zsh memiliki sejumlah builtin yang sangat penting untuk konfigurasi dan scripting.

Anda sudah mengenal builtin shell secara umum dari Bash. Yang perlu kita lakukan di sini adalah mengenali **builtin yang menjadi sangat penting dalam ekosistem Zsh**.

---

## 01.10.1 — Apa itu builtin?

Builtin adalah command yang disediakan oleh shell itu sendiri.

Misalnya:

```zsh
cd
```

tidak perlu menjalankan executable eksternal bernama `cd`.

Shell menangani `cd` secara internal karena perubahan working directory harus terjadi pada shell yang sedang berjalan.

Secara konseptual:

```text
command
│
├── external command
│      └── executable
│
└── builtin
       └── ditangani shell
```

---

## 01.10.2 — `print`

Salah satu builtin Zsh yang sangat penting:

```zsh
print
```

Contoh:

```zsh
print "Hello"
```

atau:

```zsh
print -r -- "$message"
```

Dalam konfigurasi Zsh Anda akan sangat sering menemukan `print`.

Kenapa?

Karena `print` memiliki interface yang cocok untuk berbagai kebutuhan output Zsh dan merupakan builtin native Zsh.

Mental model:

```text
Bash
└── printf sangat umum

Zsh
├── printf
└── print
      ↑
      sangat penting dalam Zsh
```

Ini tidak berarti `printf` menjadi tidak valid di Zsh.

Keduanya tersedia.

---

# 01.10.3 — `typeset`

Kita sudah menyentuhnya ketika membahas function:

```zsh
typeset
```

Ini merupakan builtin yang sangat penting karena berkaitan langsung dengan parameter attributes.

Contoh:

```zsh
typeset -a files
```

indexed array.

```zsh
typeset -A config
```

associative array.

```zsh
typeset -i count
```

integer parameter.

Jadi:

```text
typeset
│
├── parameter
├── array
├── associative array
├── integer
└── parameter attributes
```

Ini merupakan salah satu alasan mengapa `typeset` akan muncul berkali-kali dalam kurikulum berikutnya.

---

# 01.10.4 — `autoload`

Kita juga sudah mengenalnya:

```zsh
autoload
```

Fungsinya berkaitan dengan pemuatan function secara modular.

```text
autoload
   ↓
function definition
   ↓
available to shell
```

Untuk saat ini cukup kenali sebagai builtin penting Zsh.

Pembahasan mendalam tetap ditunda ke **Lesson 08 — Functions & Autoload**.

---

# 01.10.5 — `whence`

Salah satu builtin/introspection mechanism yang sangat berguna:

```zsh
whence
```

Contoh:

```zsh
whence -v ls
```

atau:

```zsh
whence -f my_function
```

Tujuannya adalah membantu mengetahui bagaimana Zsh menyelesaikan sebuah nama.

Mental model:

```text
"nama ini sebenarnya apa?"
          │
          ▼
       whence
          │
          ├── alias?
          ├── builtin?
          ├── function?
          └── command?
```

Ini akan sangat berguna ketika nanti kita melakukan debugging konfigurasi dan plugin.

---

# 01.10.6 — `cd`, `pushd`, `popd`, `dirs`

Zsh juga menyediakan mekanisme directory stack.

Contoh:

```zsh
pushd /tmp
```

Kemudian:

```zsh
popd
```

dan:

```zsh
dirs
```

Secara konseptual:

```text
directory stack
│
├── current directory
├── previous directory
└── ...
```

Zsh kemudian menyediakan berbagai option yang berhubungan dengan directory stack.

Ini nantinya bertemu dengan:

```text
AUTO_PUSHD
PUSHD_IGNORE_DUPS
```

dan sebagainya.

Untuk sekarang cukup kenali bahwa builtin dan option sering bekerja bersama.

---

# 01.10.7 — Mengapa builtin penting untuk Zsh configuration?

Karena `.zshrc` bukan hanya sekumpulan command Linux.

Ia berisi instruksi kepada **shell itu sendiri**.

Contoh:

```zsh
setopt ...
typeset ...
autoload ...
bindkey ...
compinit ...
```

Semua ini berhubungan langsung dengan kemampuan internal Zsh.

Mental model:

```text
.zshrc
│
├── external commands
│
└── Zsh builtins / shell constructs
      │
      ├── setopt
      ├── typeset
      ├── autoload
      ├── print
      ├── bindkey
      └── ...
```

Dan semakin jauh kita masuk ke konfigurasi Zsh, semakin besar bagian kedua tersebut.

---

## Posisi kurikulum

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
├── ✓ Redirection
├── ✓ Process substitution
├── ✓ Options
├── ✓ Builtins
│
├── → Readline vs ZLE
└── → Completion system
```

Jadi masih ada **dua materi terakhir** dalam Lesson 01:

1. **Readline vs ZLE**
2. **Completion system**

Setelah dua bagian itu selesai, kita akan melakukan **mini lab Bash vs Zsh side-by-side** sebagai penutup Lesson 01, kemudian baru bergerak ke **Lesson 02 — Zsh Language** sesuai urutan kurikulum.

## 01.11 — Readline vs ZLE

Kita tetap berada di **Lesson 01 — Zsh vs Bash**, tepat pada dua materi terakhir sebelum penutup Lesson 01.

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
├── ✓ Redirection
├── ✓ Process substitution
├── ✓ Options
├── ✓ Builtins
├── → Readline vs ZLE       ← SEKARANG
└── → Completion system
```

Bagian ini penting karena mulai membawa kita dari **Zsh sebagai scripting language** menuju **Zsh sebagai interactive shell**.

### 01.11.1 — Bash menggunakan Readline

Ketika Anda menggunakan Bash secara interaktif:

```text
Terminal
   │
   ▼
Bash
   │
   └── GNU Readline
          │
          ├── input editing
          ├── cursor movement
          ├── history navigation
          └── key bindings
```

Readline adalah library yang menangani line editing untuk banyak program terminal, termasuk Bash.

Contohnya ketika Anda menekan:

```text
↑
```

untuk mengambil command sebelumnya, atau:

```text
Ctrl+A
Ctrl+E
Ctrl+R
```

dan sebagainya, Anda sedang berinteraksi dengan sistem line editing.

---

# 01.11.2 — Zsh menggunakan ZLE

Zsh memiliki sistem sendiri:

```text
ZLE
```

singkatan dari:

```text
Zsh Line Editor
```

Modelnya:

```text
Terminal
   │
   ▼
Zsh
   │
   └── ZLE
         │
         ├── keymaps
         ├── widgets
         ├── editing
         └── interactive behavior
```

Jadi perbandingan fundamentalnya:

```text
Bash
└── Readline

Zsh
└── ZLE
```

Ini adalah salah satu perbedaan paling penting antara kedua shell ketika kita berbicara tentang **interactive shell customization**.

---

# 01.11.3 — Mengapa ZLE sangat penting untuk tujuan Anda?

Karena tujuan Anda nantinya bukan hanya:

```text
menulis script Zsh
```

tetapi:

```text
membuat fitur produktivitas terminal
```

Untuk itu Anda perlu memahami:

```text
keyboard input
      ↓
keymap
      ↓
widget
      ↓
function
      ↓
shell action
```

Misalnya Anda ingin membuat shortcut:

```text
Ctrl+X
   ↓
menjalankan custom action
```

Mekanismenya di Zsh bukan sekadar:

```text
alias Ctrl+X=...
```

Melainkan melalui sistem ZLE.

---

# 01.11.4 — Widget

Konsep penting dalam ZLE adalah **widget**.

Widget merupakan unit aksi yang dapat dijalankan oleh ZLE.

Contoh built-in widget:

```text
accept-line
backward-char
forward-char
beginning-of-line
end-of-line
kill-line
```

Secara konseptual:

```text
keyboard
   │
   ▼
key binding
   │
   ▼
widget
   │
   ▼
action
```

Misalnya Enter secara konseptual terhubung dengan:

```text
accept-line
```

yang kemudian menyebabkan command line diproses.

---

# 01.11.5 — Keymap

ZLE tidak hanya memiliki widget.

Ada pula:

```text
keymap
```

Keymap menentukan hubungan antara:

```text
key sequence
       ↓
widget
```

Contoh mental model:

```text
"^A"
  │
  ▼
beginning-of-line
```

dan:

```text
"^E"
  │
  ▼
end-of-line
```

Jadi:

```text
Keymap
│
├── Ctrl+A → beginning-of-line
├── Ctrl+E → end-of-line
└── ...
```

Ini berbeda dari alias.

---

# 01.11.6 — `bindkey`

Builtin Zsh yang akan sangat sering Anda lihat:

```zsh
bindkey
```

Contoh:

```zsh
bindkey -v
```

Ini relevan langsung dengan konfigurasi Anda karena Anda memang menggunakan **vi keymap** pada Zsh.

Secara konseptual:

```zsh
bindkey -v
```

mengubah mode editing ZLE menjadi model vi.

Sedangkan:

```zsh
bindkey -e
```

menggunakan gaya emacs.

Mental model:

```text
ZLE
│
└── keymap
     │
     ├── emacs
     └── vi
```

Jadi ketika Anda menemukan:

```zsh
bindkey -v
```

di `.zshrc`, sekarang Anda seharusnya mengenal bahwa command tersebut berkaitan dengan:

```text
Zsh
 └── ZLE
      └── keymap
```

bukan sekadar "mengaktifkan shortcut keyboard".

---

# 01.11.7 — Function dapat menjadi widget

Di sinilah Zsh mulai menarik untuk tujuan akhir kita.

Function Zsh dapat digunakan untuk membuat custom widget.

Secara konseptual:

```text
Zsh function
      ↓
zle widget
      ↓
key binding
      ↓
keyboard shortcut
```

Contohnya nanti kita dapat membuat function:

```zsh
my_widget() {
    ...
}
```

kemudian menjadikannya widget dan menghubungkannya dengan key.

Tetapi mekanisme detailnya **belum dipelajari sekarang**.

Itu akan menjadi bagian dari materi **ZLE** pada tahap interactive Zsh.

Untuk Lesson 01, cukup pahami arsitekturnya.

---

# 01.11.8 — Mengapa ZLE lebih dari sekadar line editing?

Karena ZLE dapat diprogram.

Model sederhananya:

```text
Readline
└── line editing system

ZLE
├── line editing
├── keymaps
├── widgets
├── programmable actions
└── integration dengan function Zsh
```

Ini salah satu alasan Zsh sangat cocok untuk konfigurasi interactive shell yang kompleks.

Nantinya Anda dapat membuat fitur seperti:

```text
Ctrl+G
   ↓
custom widget
   ↓
ambil data
   ↓
olah data
   ↓
ubah command line
```

Tanpa harus membuat program terminal terpisah untuk setiap fitur.

---

# 01.11.9 — Jangan mencampurkan ZLE dengan completion

Keduanya sama-sama berada di interactive Zsh, tetapi mekanismenya berbeda.

```text
Interactive Zsh
│
├── ZLE
│    ├── keyboard
│    ├── keymap
│    └── widgets
│
└── Completion
     ├── candidate generation
     ├── completion functions
     └── selection
```

Jadi:

```text
bindkey
```

berhubungan terutama dengan:

```text
ZLE / keymap
```

sedangkan:

```text
compinit
```

berhubungan dengan:

```text
completion system
```

Ini akan menjadi sangat penting ketika kita membaca `.zshrc`.

---

# 01.12 — Completion System

Ini adalah materi terakhir dalam daftar utama Lesson 01.

```text
01 — Zsh vs Bash
│
└── Completion system ← SEKARANG
```

### 01.12.1 — Apa itu shell completion?

Ketika Anda mengetik:

```zsh
cd /u<Tab>
```

shell dapat membantu melengkapi:

```text
/usr/
```

atau ketika:

```zsh
git che<Tab>
```

shell dapat menawarkan:

```text
checkout
cherry-pick
...
```

Ini disebut:

```text
completion
```

Bash dan Zsh sama-sama memiliki programmable completion, tetapi arsitekturnya berbeda.

---

# 01.12.2 — Bash completion

Bash memiliki sistem completion yang biasanya menggunakan:

```bash
complete
```

Contoh konseptual:

```bash
complete -F _my_function mycommand
```

Artinya sebuah completion function dikaitkan dengan command tertentu.

Mental model:

```text
Bash
│
└── complete
      │
      └── completion function
```

---

# 01.12.3 — Zsh completion

Zsh memiliki completion framework yang jauh lebih terintegrasi.

Entry point yang sangat sering Anda lihat:

```zsh
autoload -Uz compinit
compinit
```

Sekarang Anda dapat melihat beberapa materi sebelumnya bertemu:

```text
autoload
   ↓
completion function
   ↓
compinit
   ↓
Zsh completion system
```

Ini bukan kebetulan.

---

# 01.12.4 — `compinit`

`compinit` menginisialisasi sistem completion Zsh.

Contoh konfigurasi yang sangat umum:

```zsh
autoload -Uz compinit
compinit
```

Strukturnya:

```text
autoload -Uz compinit
        │
        ▼
function compinit tersedia
        │
        ▼
compinit
        │
        ▼
completion system initialized
```

Untuk sekarang, jangan masuk ke detail implementasi `compinit`.

Nanti akan ada materi khusus **Completion System** yang membahas:

```text
completion functions
compdef
compsys
styles
tags
contexts
widgets
```

---

# 01.12.5 — `compdef`

Salah satu konsep yang nantinya akan sangat penting adalah:

```zsh
compdef
```

Secara konseptual:

```text
command
   │
   ▼
completion function
```

Contoh bentuk yang mungkin Anda temukan:

```zsh
compdef _mycommand mycommand
```

Artinya completion system mengetahui bahwa:

```text
mycommand
    ↓
_mycommand
```

digunakan untuk menyediakan completion.

Perhatikan konvensi:

```text
_mycommand
```

Nama dengan underscore seperti ini sangat umum dalam completion system Zsh.

---

# 01.12.6 — Perbedaan arsitektur Bash dan Zsh

Mental model sederhana:

```text
Bash
│
└── programmable completion
      │
      └── complete / completion functions


Zsh
│
└── Completion System
      │
      ├── compinit
      ├── compdef
      ├── completion functions
      ├── tags
      ├── styles
      └── contexts
```

Zsh completion bukan sekadar:

```text
"versi Bash completion yang syntax-nya berbeda"
```

Ia merupakan sistem yang lebih besar.

---

# 01.12.7 — Mengapa completion sangat penting untuk tujuan akhir?

Karena completion merupakan salah satu bagian terbesar dari kemampuan interactive Zsh.

Nantinya Anda dapat membuat:

```text
mycommand <Tab>
```

menghasilkan:

```text
subcommands
files
directories
options
arguments
dynamic candidates
```

Bahkan completion dapat mengambil data dari program lain.

Secara konseptual:

```text
User
 │
 └── mycommand <Tab>
          │
          ▼
       Zsh
          │
          ▼
    completion system
          │
          ├── context
          ├── tags
          ├── function
          └── candidates
          │
          ▼
       suggestions
```

Ini merupakan salah satu fondasi utama ketika nanti Anda membuat fitur produktivitas Zsh.

---

# 01.12.8 — Hubungan completion dengan `autoload`

Kita sekarang bisa melihat mengapa `autoload` tadi sengaja diperkenalkan tanpa dibahas terlalu dalam.

```text
Zsh completion
       │
       ▼
completion functions
       │
       ▼
autoload
       │
       ▼
function loading
```

Dengan demikian materi Lesson 01 sebenarnya sudah mulai membangun hubungan antar-konsep:

```text
Functions
    │
    ├── autoload
    │
    └── ZLE widgets
           │
           └── key bindings

Completion
    │
    ├── compinit
    ├── compdef
    └── completion functions
```

Namun detail masing-masing tetap akan dipelajari pada lesson yang sesuai.

---

# Penutup Lesson 01 — Mini Lab Bash vs Zsh

Sekarang seluruh materi utama Lesson 01 sudah kita lewati.

Mini lab ini bukan untuk menguji Anda sekarang, melainkan untuk mengikat semua materi menjadi satu eksperimen.

Buat dua shell secara berdampingan.

```text
/tmp/zsh-bash-lab/
├── bash/
└── zsh/
```

Di masing-masing shell, bandingkan:

```text
1. parameter
2. array
3. globbing
4. conditional
5. function
6. redirection
7. process substitution
8. option
9. builtin
10. interactive behavior
11. completion
```

Beberapa eksperimen yang relevan:

```zsh
print -r -- "$ZSH_VERSION"
```

bandingkan dengan Bash:

```bash
printf '%s\n' "$BASH_VERSION"
```

Array:

```zsh
arr=(one two three)
print -r -- "$arr[1]"
```

Bandingkan dengan indeks Bash.

Globbing:

```zsh
print -rl -- **/*.txt
```

Conditional:

```zsh
[[ -f "$file" ]]
```

Function:

```zsh
hello() {
    print "hello"
}
```

Redirection:

```zsh
print "hello" > output.txt
```

Process substitution:

```zsh
diff <(sort one.txt) <(sort two.txt)
```

Option:

```zsh
setopt EXTENDED_GLOB
```

Builtin:

```zsh
whence -v print
whence -v typeset
```

Interactive:

```zsh
bindkey -v
```

Completion:

```zsh
autoload -Uz compinit
compinit
```

Tujuan lab bukan menghafalkan command-command tersebut. Tujuannya adalah membentuk kemampuan berikut:

```text
Melihat kode Zsh
      │
      ▼
mengenali apakah konsepnya berasal dari
shell umum atau fitur Zsh
      │
      ▼
memahami semantic-nya
      │
      ▼
mampu membaca konfigurasi Zsh
```

---

# Lesson 01 selesai

Sekarang status kurikulum:

```text
00 — Prep / Mental Model
✓ SELESAI

01 — Zsh vs Bash
✓ SELESAI

02 — Zsh Language
→ BERIKUTNYA
```

Dan **Lesson 01 tidak kita perluas lagi dengan materi dari Lesson 02**.

Urutan utama yang sudah diselesaikan:

```text
01 — Zsh vs Bash
│
├── ✓ Mengapa Zsh bukan Bash++
├── ✓ POSIX vs Zsh-specific extensions
├── ✓ Syntax compatibility / incompatibility
├── ✓ Parameter / expansion differences
├── ✓ Arrays
├── ✓ Globbing
├── ✓ Conditional expressions
├── ✓ Functions
├── ✓ Redirection
├── ✓ Process substitution
├── ✓ Options (`setopt` vs `set -o`)
├── ✓ Builtins
├── ✓ Readline vs ZLE
├── ✓ Completion systems
└── ✓ Mini lab Bash vs Zsh
        │
        ▼
02 — Zsh Language
```

Tahap berikutnya adalah **Lesson 02 — Zsh Language**. Di sana kita mulai meninggalkan perbandingan Bash sebagai fokus utama dan mempelajari **bahasa Zsh itu sendiri secara sistematis**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Daftar Teknologi][tekno]**
> - **[Home][home]**

[home]: ./../../../../../../README.md
[tekno]: ../../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md
[PID]: ./../../../../../../CLI_TUI/konsep/pid/pid.md

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

