# Lesson 02 — Zsh Language

Lesson 01 sudah selesai. Sekarang kita masuk ke **Lesson 02 — Zsh Language**, sesuai urutan kurikulum asli.

```text
00 — Prep / Mental Model
✓ selesai

01 — Zsh vs Bash
✓ selesai

02 — Zsh Language
→ mulai sekarang
```

Pada Lesson 01 kita banyak menggunakan Bash sebagai pembanding. Mulai Lesson 02, fokus utama berubah:

```text
Lesson 01
Bash → Zsh
   ↓
memahami perbedaan

Lesson 02
Zsh
 ↓
memahami bahasa Zsh itu sendiri
```

Tujuannya agar nantinya ketika melihat konfigurasi seperti:

```zsh
typeset -A config
[[ -n "$commands[fzf]" ]]
setopt EXTENDED_GLOB
${(f)output}
${(@)array}
```

Anda tidak lagi berpikir:

> "Ini Bash versi apa?"

melainkan:

> "Apa aturan bahasa Zsh yang sedang digunakan?"

---

# 02.1 — Zsh sebagai Programming Language

Zsh sering dipandang hanya sebagai shell interaktif.

Untuk pembelajaran kita, pandangan itu terlalu sempit.

Zsh memiliki:

```text
Zsh
├── command execution
├── parameter system
├── expansion system
├── arrays
├── associative arrays
├── conditional expressions
├── functions
├── arithmetic
├── pattern matching
├── modules
└── interactive programming
```

Dengan kata lain, Zsh memiliki bahasa scripting yang cukup kaya.

Model dasarnya:

```text
input
  ↓
Zsh parser
  ↓
expansion
  ↓
redirection
  ↓
command execution
  ↓
exit status
```

Anda sudah mempelajari sebagian model tersebut ketika membahas Bash.

Sekarang kita akan mempelajari bagaimana Zsh memperluasnya.

---

# 02.2 — Syntax dasar Zsh

Kita mulai dari konstruksi paling dasar.

Sebuah command:

```zsh
print "Hello"
```

terdiri dari:

```text
print "Hello"
│     │
│     └── argument
└── command
```

Beberapa command:

```zsh
print "one"
print "two"
print "three"
```

dieksekusi berurutan.

Shell membaca input sebagai struktur syntax, bukan sekadar sebagai teks yang kemudian "dilempar" ke program.

---

# 02.3 — Statement dan command

Dalam Zsh, sebagian besar operasi sehari-hari berbentuk command.

Contoh:

```zsh
name="Amir"
```

merupakan assignment.

Sedangkan:

```zsh
print "$name"
```

merupakan command invocation.

Dan:

```zsh
if [[ -n "$name" ]]; then
    print "$name"
fi
```

merupakan struktur control flow.

Jadi bahasa Zsh dapat kita lihat sebagai kombinasi:

```text
Zsh Language
│
├── commands
├── assignments
├── expansions
├── conditionals
├── loops
├── functions
└── operators
```

---

# 02.4 — Assignment

Assignment dasar:

```zsh
name="Amir"
```

Kemudian:

```zsh
print "$name"
```

menghasilkan:

```text
Amir
```

Berbeda dengan banyak bahasa pemrograman, shell assignment tidak menggunakan:

```text
name = "Amir"
```

Spasi di sekitar `=` memiliki arti penting.

Benar:

```zsh
name="Amir"
```

Salah:

```zsh
name = "Amir"
```

Karena bentuk kedua akan dipahami sebagai command bernama `name`.

Mental model:

```text
name="Amir"
│ │     │
│ │     └── value
│ └──────── assignment operator
└────────── parameter
```

---

# 02.5 — Parameter adalah konsep sentral Zsh

Di Lesson 01 kita menyebut "variable".

Dalam dokumentasi dan terminology Zsh, istilah yang lebih tepat adalah:

```text
parameter
```

Contoh:

```zsh
name="Amir"
```

`name` adalah parameter.

Parameter Zsh jauh lebih kaya daripada sekadar container string.

Sebuah parameter dapat memiliki berbagai atribut:

```text
parameter
│
├── scalar
├── array
├── associative array
├── integer
├── readonly
├── exported
└── berbagai attribute lainnya
```

Contoh scalar:

```zsh
name="Amir"
```

Integer:

```zsh
typeset -i count=10
```

Array:

```zsh
typeset -a files
```

Associative array:

```zsh
typeset -A config
```

Ini menjadi salah satu perbedaan terbesar antara model:

```text
Bash variable
```

dan:

```text
Zsh parameter system
```

---

# 02.6 — Scalar parameter

Parameter biasa:

```zsh
name="Amir"
```

Nilainya dapat digunakan:

```zsh
print "$name"
```

atau:

```zsh
print "${name}"
```

Untuk sekarang:

```text
$name
```

dan:

```text
${name}
```

dapat dianggap sebagai dua bentuk dasar parameter expansion.

Tetapi `${...}` adalah bentuk yang jauh lebih penting karena hampir seluruh kemampuan parameter expansion Zsh berkembang dari syntax tersebut.

---

# 02.7 — Parameter expansion

Contoh paling dasar:

```zsh
name="Amir"
print "$name"
```

Zsh melakukan expansion:

```text
"$name"
   │
   ▼
"Amir"
```

Dengan braces:

```zsh
print "${name}"
```

juga menghasilkan:

```text
Amir
```

Namun braces memungkinkan kita menambahkan operasi.

Misalnya:

```zsh
print "${name:u}"
```

dan:

```zsh
print "${name:l}"
```

Zsh dapat melakukan transformasi terhadap parameter secara langsung.

Konsep ini akan menjadi salah satu materi terbesar dalam kurikulum:

```text
Lesson 03 — Parameter Expansion
```

Jadi sekarang kita hanya membangun fondasinya.

---

# 02.8 — Command substitution

Zsh mendukung:

```zsh
result=$(command)
```

Contoh:

```zsh
current_dir=$(pwd)
print "$current_dir"
```

Modelnya:

```text
$(pwd)
  │
  ▼
jalankan command
  │
  ▼
ambil stdout
  │
  ▼
masukkan ke parameter
```

Ini sama secara fundamental dengan Bash.

Tetapi nanti ketika kita masuk ke expansion system Zsh, kita akan melihat bahwa Zsh menyediakan banyak cara tambahan untuk memproses hasil command.

---

# 02.9 — Arithmetic expansion

Zsh juga mendukung:

```zsh
result=$((10 + 20))
```

Kemudian:

```zsh
print "$result"
```

hasilnya:

```text
30
```

Zsh juga memiliki arithmetic context:

```zsh
(( result = 10 + 20 ))
```

Sehingga:

```text
$(( ... ))
```

dan:

```text
(( ... ))
```

harus mulai Anda bedakan.

```text
$(( expression ))
      ↓
menghasilkan nilai


(( expression ))
      ↓
arithmetic evaluation context
```

Konsep ini akan kita dalami dalam bahasa Zsh, bukan sekadar sebagai kompatibilitas Bash.

---

# 02.10 — Quoting

Tiga bentuk utama yang harus selalu Anda bedakan:

```zsh
'text'
"text"
text
```

### Single quotes

```zsh
print '$name'
```

menghasilkan literal:

```text
$name
```

Expansion tidak dilakukan di dalam single quotes.

### Double quotes

```zsh
print "$name"
```

parameter expansion dilakukan.

Jika:

```zsh
name="Amir"
```

hasilnya:

```text
Amir
```

### Unquoted

```zsh
print $name
```

di sinilah expansion dan word formation dapat memberikan efek berbeda.

Dalam Zsh, perilaku array dan splitting juga berbeda dari Bash, sehingga:

```text
unquoted expansion
```

merupakan area yang harus dipahami dengan hati-hati.

Kita tidak akan menyelesaikan seluruh detailnya sekarang karena itu masuk ke **Lesson 03 — Parameter Expansion**.

---

# 02.11 — Word dan expansion

Salah satu mental model terpenting dalam shell:

```text
source text
    ↓
parsing
    ↓
expansion
    ↓
redirection
    ↓
execution
```

Misalnya:

```zsh
name="Amir"
print "$name"
```

Zsh tidak langsung melihat `"Amir"` di source code.

Ia terlebih dahulu menemukan:

```text
$name
```

kemudian melakukan parameter expansion:

```text
$name
 ↓
Amir
```

Barulah hasil tersebut digunakan dalam command.

Karena itu ketika kita mempelajari Zsh secara mendalam, **expansion system** akan menjadi pusat perhatian.

---

# 02.12 — Zsh memiliki expansion flags

Sekarang kita mulai melihat sesuatu yang sangat khas Zsh.

Zsh memungkinkan modifier/flag digunakan di dalam parameter expansion.

Contoh:

```zsh
value="one two three"
print -r -- "${(f)value}"
```

Flag:

```text
(f)
```

memiliki fungsi tertentu dalam expansion.

Jangan khawatir jika syntax tersebut terlihat asing.

Justru ini salah satu tujuan Lesson 02:

```text
Bash:
${parameter}

Zsh:
${(flag)parameter}
```

Zsh menambahkan sistem expansion yang sangat kuat.

Namun detail semua flags **belum kita pelajari sekarang**.

Itu akan menjadi inti:

```text
03 — Parameter Expansion
```

---

# 02.13 — Zsh sebagai bahasa dengan expansion pipeline

Sekarang kita bisa memperbaiki mental model kita:

```text
Zsh command
│
├── parsing
│
├── parameter expansion
│
├── command substitution
│
├── arithmetic expansion
│
├── filename generation
│
├── redirection
│
└── execution
```

Tidak semua command melewati setiap tahap dengan cara yang sama.

Tetapi ketika Anda melihat konfigurasi Zsh yang kompleks, Anda harus mulai berpikir:

> "Pada tahap expansion mana syntax ini bekerja?"

Ini jauh lebih berguna daripada sekadar menghafalkan syntax.

---

# 02.14 — Kenapa Lesson 02 dimulai dari sini?

Karena seluruh bagian besar Zsh berikutnya bergantung pada pemahaman ini:

```text
Zsh Language
      │
      ▼
Parameter
      │
      ▼
Parameter Expansion
      │
      ├── Arrays
      ├── String manipulation
      ├── Flags
      ├── Pattern matching
      ├── Command output processing
      └── Data transformation
```

Kemudian:

```text
Parameter Expansion
      ↓
Configuration
      ↓
Functions
      ↓
Plugins
```

Jadi kita tidak langsung melompat ke `.zshrc`, plugin, atau ZLE.

Fondasi bahasa harus kuat terlebih dahulu.

---

# Posisi Lesson 02

Untuk menjaga kita tetap pada jalur kurikulum:

```text
02 — Zsh Language
│
├── → Syntax dasar Zsh
├── → Parameter system
├── → Expansion system
├── → Quoting
├── → Command substitution
├── → Arithmetic
├── → Conditional / control structures
├── → Loops
├── → Functions
├── → Scope
├── → Error / exit status
└── → Advanced syntax
```

Bagian yang baru kita mulai adalah **syntax dasar + parameter/expansion foundation**. Kita belum masuk ke Lesson 03; parameter expansion mendalam tetap ditahan untuk tahap berikutnya sesuai kurikulum.

Selanjutnya kita lanjutkan **02 — Zsh Language** secara berurutan ke struktur kontrol, operator, dan aturan syntax yang lebih khas Zsh sebelum masuk ke Lesson 03.

## 02 — Zsh Language

### 02.6 Conditional & Control Structures

Karena kamu sudah mempelajari control flow di Bash, fokus kita di Zsh adalah memahami apa yang tetap sama dan bagian mana yang memiliki karakteristik Zsh.

### 1. `if`

Struktur dasarnya tetap familiar:

```zsh
if [[ condition ]]; then
    command
elif [[ condition ]]; then
    command
else
    command
fi
```

Contoh:

```zsh
name="Amir"

if [[ -n "$name" ]]; then
    print "Nama tersedia"
else
    print "Nama kosong"
fi
```

Yang penting dipahami: `if` tidak secara langsung memeriksa apakah sebuah kondisi "benar" dalam pengertian boolean.

Shell melihat exit status dari command/conditional expression.

```text
[[ -n "$name" ]]
        │
        ▼
   exit status
     │      │
     0    != 0
     │      │
    true   false
```

Jadi:

```zsh
if [[ -n "$name" ]]; then
```

secara konseptual berarti:

```text
jalankan [[ ... ]]
        ↓
status = 0 ?
   ├─ ya  → then
   └─ tidak → else/elif
```

Ini merupakan konsep yang sama dengan Bash dan penting untuk dipertahankan sebagai mental model.

---

### 2. `case`

Zsh juga memiliki `case`:

```zsh
case "$value" in
    one)
        print "Satu"
        ;;
    two)
        print "Dua"
        ;;
    *)
        print "Lainnya"
        ;;
esac
```

Misalnya:

```zsh
choice="start"

case "$choice" in
    start)
        print "Memulai"
        ;;
    stop)
        print "Menghentikan"
        ;;
    restart)
        print "Memulai ulang"
        ;;
    *)
        print "Pilihan tidak dikenal"
        ;;
esac
```

Mental model:

```text
case value
   │
   ├── pattern 1 → command
   ├── pattern 2 → command
   ├── pattern 3 → command
   └── *          → fallback
```

`case` sangat berguna untuk konfigurasi dan command dispatcher karena menghindari rantai `if/elif` yang panjang.

---

### 3. `for`

Bentuk yang paling penting dalam Zsh:

```zsh
for item in one two three; do
    print "$item"
done
```

Hasilnya:

```text
one
two
three
```

Dengan array:

```zsh
items=(one two three)

for item in "${items[@]}"; do
    print "$item"
done
```

Namun, karena Zsh memiliki model array yang lebih kuat, nanti kita akan membahas cara idiomatik Zsh untuk iterasi array. Itu belum kita dalami sekarang karena berkaitan dengan Lesson 04.

---

### 4. `while`

```zsh
count=1

while (( count <= 3 )); do
    print "$count"
    (( count++ ))
done
```

Hasil:

```text
1
2
3
```

Di sini ada dua mekanisme berbeda:

```zsh
(( count <= 3 ))
```

adalah arithmetic conditional.

Sedangkan:

```zsh
(( count++ ))
```

adalah arithmetic evaluation.

Keduanya merupakan bagian penting dari bahasa shell, bukan command eksternal.

---

### 5. `until`

Kebalikan konseptual `while`:

```zsh
count=1

until (( count > 3 )); do
    print "$count"
    (( count++ ))
done
```

Mental model:

```text
while condition
→ ulangi SELAMA condition true

until condition
→ ulangi SAMPAI condition true
```

Secara praktis, `while` jauh lebih sering digunakan, tetapi `until` tetap bagian dari bahasa Zsh.

---

## 02.7 Operators

Sekarang kita masuk ke operator karena control flow bergantung pada operator.

Ada beberapa kelompok.

### String

```zsh
[[ "$name" == "Amir" ]]
[[ "$name" != "Amir" ]]
[[ -n "$name" ]]
[[ -z "$name" ]]
```

Maknanya:

```text
-n → string tidak kosong
-z → string kosong
== → cocok
!= → tidak cocok
```

Contoh:

```zsh
name="Amir"

if [[ "$name" == "Amir" ]]; then
    print "Benar"
fi
```

---

### File

```zsh
[[ -f "$file" ]]
[[ -d "$directory" ]]
[[ -r "$file" ]]
[[ -w "$file" ]]
[[ -x "$file" ]]
```

Contoh:

```zsh
if [[ -f "$HOME/.zshrc" ]]; then
    print ".zshrc ditemukan"
fi
```

Ini penting untuk scripting konfigurasi karena nantinya banyak konfigurasi Zsh akan melakukan pemeriksaan seperti:

```zsh
if [[ -r "$file" ]]; then
    source "$file"
fi
```

---

### Logical operators

```zsh
[[ condition1 && condition2 ]]
[[ condition1 || condition2 ]]
[[ ! condition ]]
```

Contoh:

```zsh
if [[ -f "$file" && -r "$file" ]]; then
    print "File tersedia dan dapat dibaca"
fi
```

Mental model:

```text
condition1 ──┐
              ├── && → keduanya harus true
condition2 ──┘
```

Sedangkan:

```text
condition1 ──┐
              ├── || → salah satu cukup true
condition2 ──┘
```

---

## 02.8 Arithmetic

Zsh memiliki arithmetic evaluation yang sangat terintegrasi.

```zsh
count=10

(( count += 5 ))

print "$count"
```

Hasil:

```text
15
```

Conditional:

```zsh
if (( count > 10 )); then
    print "Lebih besar dari 10"
fi
```

Tidak perlu:

```zsh
if [[ "$count" -gt 10 ]]; then
```

walaupun bentuk tersebut juga dikenal dari shell scripting.

Untuk arithmetic, gunakan:

```zsh
(( ... ))
```

Mental model:

```text
[[ ... ]]
→ conditional expression

(( ... ))
→ arithmetic evaluation / arithmetic condition
```

Contoh:

```zsh
a=10
b=20

(( result = a + b ))

print "$result"
```

---

## 02.9 Exit Status

Ini harus benar-benar kuat sebelum masuk ke bagian berikutnya.

Setiap command menghasilkan status.

```zsh
command
print "$?"
```

Secara umum:

```text
0      → berhasil / true
non-0  → gagal / false
```

Contoh:

```zsh
true
print "$?"
```

menghasilkan:

```text
0
```

Sedangkan:

```zsh
false
print "$?"
```

menghasilkan:

```text
1
```

Tetapi angka non-zero tidak selalu berarti hanya `1`. Program dapat menggunakan berbagai nilai non-zero untuk menunjukkan kondisi error yang berbeda.

---

### Exit status dalam `if`

Ini menjelaskan kembali:

```zsh
if command; then
    ...
fi
```

sebenarnya:

```text
jalankan command
       ↓
ambil exit status
       ↓
0 ?
├── ya → then
└── tidak → else/elif
```

Contoh:

```zsh
if command -v git >/dev/null 2>&1; then
    print "Git tersedia"
else
    print "Git tidak tersedia"
fi
```

Ini merupakan pola yang sangat penting dalam konfigurasi shell.

---

## 02.10 `&&` dan `||` sebagai Control Flow

Operator ini bukan hanya operator logical di `[[ ... ]]`.

Mereka juga dapat menghubungkan command:

```zsh
command1 && command2
```

Artinya:

```text
jalankan command1
       ↓
berhasil?
 ├─ ya → command2
 └─ tidak → berhenti
```

Contoh:

```zsh
mkdir /tmp/example && print "Berhasil"
```

Sedangkan:

```zsh
command1 || command2
```

berarti:

```text
jalankan command1
       ↓
berhasil?
 ├─ ya → selesai
 └─ tidak → command2
```

Contoh:

```zsh
cd /directory || print "Gagal berpindah directory"
```

Ini sangat sering muncul dalam konfigurasi Zsh.

Tetapi jangan langsung menganggap:

```zsh
command1 && command2 || command3
```

sebagai pengganti sempurna `if/else`. Ada persoalan precedence dan status dari `command2`.

Untuk logika yang penting, `if` biasanya lebih jelas.

---

## 02.11 Functions dalam Zsh

Kita sudah mengenalkan function pada Lesson 01. Sekarang kita lihat dari sudut bahasa.

```zsh
greet() {
    print "Hello"
}
```

Memanggil:

```zsh
greet
```

Parameter positional:

```zsh
greet() {
    print "Hello $1"
}

greet "Amir"
```

Di dalam function:

```text
$1 → argument pertama
$2 → argument kedua
$# → jumlah argument
```

Contoh:

```zsh
greet() {
    print "Jumlah argument: $#"
    print "Argument pertama: $1"
}
```

---

## 02.12 Scope

Ini bagian yang mulai membedakan cara berpikir antara scripting sederhana dan scripting konfigurasi.

Misalnya:

```zsh
name="global"

test_scope() {
    name="local?"
    print "$name"
}

test_scope
print "$name"
```

Assignment biasa di dalam function tidak otomatis berarti "buat variable lokal".

Untuk membuat parameter lokal, Zsh menggunakan `typeset`:

```zsh
name="global"

test_scope() {
    typeset name="local"
    print "$name"
}

test_scope

print "$name"
```

Mental model:

```text
global scope
    │
    │ name="global"
    │
    └── function
          │
          └── typeset name="local"
                    │
                    └── parameter lokal
```

Ini salah satu alasan `typeset` sangat penting dalam Zsh.

Nanti ketika kita masuk ke konfigurasi modular, fungsi, plugin, dan autoload, pemahaman scope ini akan sangat penting.

Untuk sekarang cukup pegang:

```zsh
typeset name="..."
```

dalam function digunakan ketika kita ingin mendeklarasikan parameter lokal dengan atribut tertentu.

---

## 02.13 `return`

Function dapat mengembalikan exit status:

```zsh
check() {
    return 0
}
```

Kemudian:

```zsh
if check; then
    print "Berhasil"
fi
```

Atau:

```zsh
check
print "$?"
```

Perhatikan perbedaan:

```text
return
→ keluar dari function

exit
→ keluar dari shell/process
```

Ini sangat penting untuk konfigurasi `.zshrc`.

Misalnya sebuah function:

```zsh
setup_feature() {
    if [[ ! -d "$HOME/.something" ]]; then
        return 1
    fi

    ...
}
```

`return 1` hanya mengakhiri function.

---

## 02.14 `source` / `.`

Zsh dapat menjalankan file dalam environment shell saat ini:

```zsh
source "$HOME/.config/zsh/module.zsh"
```

atau:

```zsh
. "$HOME/.config/zsh/module.zsh"
```

Perbedaan mental modelnya dengan menjalankan script:

```text
source file
    ↓
kode file masuk ke shell saat ini
    ↓
variable/function/options dapat memengaruhi shell sekarang
```

sedangkan:

```zsh
zsh file.zsh
```

membuat proses Zsh baru.

Ini akan menjadi sangat penting pada Lesson 09 — Startup Architecture dan Lesson 17 — Modular Configuration.

---

## Posisi kita sekarang

Lesson 02 sudah mencakup:

```text
02 — Zsh Language

✓ syntax dasar
✓ parameter dasar
✓ assignment
✓ command substitution
✓ arithmetic dasar
✓ quoting
✓ expansion pipeline
✓ conditional
✓ case
✓ for
✓ while
✓ until
✓ operators
✓ exit status
✓ && / ||
✓ functions dasar
✓ scope dasar
✓ return
✓ source
```

Yang masih perlu kita selesaikan dalam Lesson 02 adalah bagian **advanced syntax yang masih merupakan bahasa Zsh**, terutama konstruksi yang akan sering kamu temui ketika membaca konfigurasi/plugin Zsh.

Sekarang kita menyelesaikan bagian **advanced syntax** yang masih termasuk bahasa Zsh. Fokusnya bukan menghafal fitur, tetapi mengenali konstruksi yang nanti akan muncul ketika membaca `.zshrc`, plugin, dan framework.

## 02.15 `[[ ... ]]` sebagai konstruksi bahasa

Sebelumnya kita sudah menggunakan:

```zsh
if [[ -f "$file" ]]; then
    print "File ditemukan"
fi
```

Penting untuk membedakan:

```zsh
[[ ... ]]
```

dari:

```zsh
[ ... ]
```

dan dari command eksternal.

`[[ ... ]]` merupakan konstruksi conditional yang dipahami langsung oleh shell.

Contoh:

```zsh
if [[ "$SHELL" == */zsh ]]; then
    print "Menggunakan Zsh"
fi
```

Mental modelnya:

```text
[[ expression ]]
       │
       ▼
evaluasi oleh Zsh
       │
       ▼
exit status
       │
   ┌───┴───┐
   0      != 0
   │        │
 true      false
```

Ini merupakan salah satu konstruksi yang akan sangat sering kamu lihat di konfigurasi Zsh.

---

# 02.16 Grouping dengan `{ ... }`

Zsh dapat mengelompokkan beberapa command:

```zsh
{
    print "Satu"
    print "Dua"
    print "Tiga"
}
```

Ketiganya dijalankan dalam shell yang sama.

Grouping ini juga dapat dikombinasikan dengan redirection:

```zsh
{
    print "Satu"
    print "Dua"
} > output.txt
```

Mental model:

```text
{
    command 1
    command 2
}
      │
      ▼
  satu kelompok
      │
      ▼
  redirection
```

Ini berguna ketika beberapa command harus diperlakukan sebagai satu unit.

---

# 02.17 Subshell dengan `( ... )`

Berbeda dengan `{ ... }`, bentuk:

```zsh
(
    command1
    command2
)
```

menjalankan kelompok tersebut dalam subshell.

Contoh:

```zsh
pwd

(
    cd /tmp
    pwd
)

pwd
```

Secara konsep:

```text
shell utama
    │
    ├── pwd
    │
    └── subshell
          │
          ├── cd /tmp
          └── pwd
    │
    └── pwd
```

Perubahan directory di subshell tidak mengubah directory shell utama.

Ini sangat berguna untuk memahami konfigurasi yang menjalankan operasi sementara tanpa ingin mengubah state shell utama.

Perbedaan penting:

```zsh
{
    ...
}
```

→ grouping dalam shell saat ini.

```zsh
(
    ...
)
```

→ grouping dalam subshell.

---

# 02.18 Anonymous function

Zsh memiliki konstruksi function yang dapat dibuat dan langsung dijalankan.

Bentuknya:

```zsh
() {
    print "Hello"
}
```

Kemudian block tersebut langsung dieksekusi.

Contoh:

```zsh
() {
    print "Current directory: $PWD"
}
```

Mental model:

```text
function
   ↓
dibuat
   ↓
langsung dijalankan
   ↓
selesai
```

Ini mungkin terlihat aneh jika baru mengenal Zsh, tetapi konstruksi seperti ini dapat ditemukan dalam konfigurasi Zsh yang menggunakan scope sementara.

Untuk sekarang cukup kenali sintaksnya. Kita belum perlu menggunakannya sebagai pola desain konfigurasi.

---

# 02.19 `emulate`

Ini merupakan fitur yang sangat penting ketika nanti membaca plugin atau konfigurasi Zsh.

Zsh memiliki banyak option yang dapat mengubah perilaku shell.

Karena itu sebuah fungsi atau plugin kadang ingin menjalankan dirinya dengan lingkungan perilaku Zsh yang terkontrol.

Salah satu mekanismenya adalah:

```zsh
emulate
```

Contoh:

```zsh
emulate -L zsh
```

Mental model:

```text
emulate -L zsh
       │
       ├── gunakan perilaku Zsh
       └── scope option dibuat lokal
```

Ini bukan sekadar command biasa yang kebetulan bernama `emulate`. Ini adalah bagian penting dari cara Zsh mengisolasi perilaku sebuah function.

Contoh yang akan sering kamu temui ketika membaca kode Zsh:

```zsh
some_function() {
    emulate -L zsh

    ...
}
```

Untuk tahap sekarang, cukup pahami fungsi konseptualnya:

> Function menetapkan lingkungan perilaku Zsh yang lebih terkontrol sebelum menjalankan logic-nya.

Pembahasan mendalam tentang option dan `emulate` akan lebih tepat ketika kita mencapai **Lesson 06 — Zsh Options**.

---

# 02.20 `noglob`

Zsh mempunyai kemampuan untuk menonaktifkan filename generation untuk invocation tertentu.

Contoh:

```zsh
noglob command '*.txt'
```

Biasanya shell dapat melakukan filename generation terhadap pattern tertentu.

Dengan `noglob`, pattern tersebut diteruskan ke command tanpa globbing biasa.

Mental model:

```text
normal:

command *.txt
       │
       ▼
filename generation
       │
       ▼
command file1.txt file2.txt ...


noglob:

noglob command *.txt
              │
              ▼
       tidak dilakukan
       filename generation
              │
              ▼
       command menerima *.txt
```

Ini merupakan salah satu karakteristik yang akan membuat kode Zsh terlihat berbeda ketika dibandingkan dengan Bash.

Namun detail filename generation secara keseluruhan memang milik **Lesson 05**, jadi kita tidak membahas globbing lebih jauh di sini.

---

# 02.21 `eval`

Zsh juga memiliki:

```zsh
eval
```

Misalnya:

```zsh
command="print Hello"

eval "$command"
```

`eval` menyebabkan string diproses kembali sebagai shell code.

Mental model:

```text
string
  ↓
eval
  ↓
diparse kembali
  ↓
shell syntax
  ↓
execution
```

Karena itu `eval` harus digunakan dengan sangat hati-hati.

Contoh konseptual:

```zsh
value="$user_input"
eval "$value"
```

Jika `user_input` berasal dari sumber yang tidak dipercaya, isinya dapat menjadi shell code.

Jadi untuk tahap ini, aturan pentingnya:

> Jangan menggunakan `eval` hanya karena ingin menjalankan isi sebuah variable sebagai command.

Biasanya ada mekanisme yang lebih aman.

---

# 02.22 `command`, `builtin`, dan `functions`

Ketika membaca konfigurasi Zsh, kamu akan sering menemukan:

```zsh
command git
```

atau:

```zsh
builtin cd
```

atau:

```zsh
functions
```

Masing-masing memiliki tujuan berbeda.

### `command`

```zsh
command git
```

meminta shell menjalankan `git` sebagai command, dengan menghindari penggunaan function bernama `git` sebagai mekanisme pemanggilan.

Misalnya:

```zsh
git() {
    print "custom git"
}
```

Kemudian:

```zsh
git
```

akan memanggil function tersebut.

Sedangkan:

```zsh
command git
```

meminta command resolution untuk command tersebut.

Ini sangat relevan ketika membuat wrapper function.

---

### `builtin`

```zsh
builtin cd /tmp
```

secara eksplisit meminta builtin `cd`.

Ini berguna ketika terdapat function dengan nama yang sama:

```zsh
cd() {
    print "custom cd"
}
```

Kemudian:

```zsh
builtin cd /tmp
```

memanggil builtin asli.

---

### `functions`

Zsh mempunyai mekanisme untuk melihat function yang didefinisikan:

```zsh
functions
```

Untuk melihat definisi function tertentu:

```zsh
functions my_function
```

Dan sebelumnya kita juga telah mengenal:

```zsh
whence -f my_function
```

Ini akan sangat berguna nanti ketika kita mulai **membaca plugin Zsh**.

---

# 02.23 `autoload` — hanya konsep dasar

Kita sudah beberapa kali menyebut:

```zsh
autoload -Uz function_name
```

Sekarang kita perlu memasukkannya ke bahasa Zsh, tetapi belum membahas sistem autoload secara mendalam.

Konsep dasarnya:

```text
function definition
       │
       ▼
file function
       │
       ▼
autoload
       │
       ▼
function tersedia ketika dibutuhkan
```

Contoh yang sangat terkenal:

```zsh
autoload -Uz compinit
compinit
```

Tetapi `autoload`, function directories, `fpath`, dan mekanisme lazy loading akan menjadi materi utama **Lesson 08 — Functions & Autoload**.

Jadi pada Lesson 02 kita hanya perlu mengenali sintaks dan konsepnya.

---

# 02.24 `trap`

Kamu sudah memiliki dasar Bash mengenai `trap`, sehingga tidak perlu mengulang konsep shell signal secara panjang.

Dalam Zsh juga terdapat:

```zsh
trap 'command' SIGNAL
```

Contoh:

```zsh
trap 'print "Received INT"' INT
```

Konsepnya tetap:

```text
signal
   ↓
trap
   ↓
shell menjalankan handler
```

Namun Zsh mempunyai mekanisme lain yang lebih khas untuk konfigurasi interaktif, terutama **hooks**.

Hooks tersebut baru akan kita pelajari pada:

```text
Lesson 15 — Hooks
```

Jadi jangan mencampurkan `trap` dengan hook Zsh.

```text
trap
└── mekanisme signal

hook
└── mekanisme event/function Zsh
```

---

# 02.25 Error dan `set -e`

Karena kamu sudah mempelajari error handling Bash, kita hanya perlu memahami posisi Zsh.

Zsh juga mempunyai mekanisme option yang memengaruhi bagaimana shell menangani status gagal.

Misalnya:

```zsh
setopt ERR_EXIT
```

Konsepnya berkaitan dengan penghentian shell/function ketika command tertentu menghasilkan status non-zero.

Tetapi Zsh mempunyai aturan yang cukup kompleks mengenai konteks ketika error dianggap fatal atau tidak.

Karena itu kita **tidak akan menjadikan `set -e`/`ERR_EXIT` sebagai fokus Lesson 02**.

Yang perlu dibawa dari sini:

```text
exit status
    ↓
control flow
    ↓
option dapat mengubah bagaimana
status tersebut diperlakukan
```

Pembahasan option secara sistematis tetap berada di:

**Lesson 06 — Zsh Options.**

---

# 02.26 Mental model bahasa Zsh

Sekarang kumpulkan seluruh bagian Lesson 02 yang telah kita pelajari.

```text
ZSH LANGUAGE
│
├── Syntax
│
├── Parameters
│   └── basic parameter usage
│
├── Assignment
│
├── Quoting
│   ├── single quote
│   ├── double quote
│   └── unquoted
│
├── Expansion
│   └── basic expansion model
│
├── Command substitution
│
├── Arithmetic
│   └── (( ... ))
│
├── Conditional
│   ├── [[ ... ]]
│   └── if / elif / else
│
├── Pattern dispatch
│   └── case
│
├── Loops
│   ├── for
│   ├── while
│   └── until
│
├── Operators
│   ├── logical
│   ├── comparison
│   └── arithmetic
│
├── Functions
│   ├── arguments
│   ├── return
│   └── scope
│
├── Grouping
│   ├── { ... }
│   └── ( ... )
│
├── Advanced constructs
│   ├── anonymous function
│   ├── emulate
│   ├── noglob
│   ├── command
│   ├── builtin
│   └── eval
│
├── Function loading
│   └── autoload (intro)
│
└── Error / signal
    └── trap (intro)
```

Yang **sengaja belum kita dalami**:

```text
Parameter Expansion       → Lesson 03
Arrays                    → Lesson 04
Glob                      → Lesson 05
Options                   → Lesson 06
Functions & Autoload      → Lesson 08
Startup Architecture      → Lesson 09
Completion                → Lesson 13
ZLE                       → Lesson 14
Hooks                     → Lesson 15
Modules                   → Lesson 16
Plugin Architecture      → Lesson 18+
```

Itu penting supaya materi tidak saling tumpang tindih.

### Status Lesson 02

Secara materi inti, **Lesson 02 — Zsh Language sekarang sudah selesai**.

Kita sudah bergerak dari:

```text
Bash foundation
      ↓
Lesson 01
Zsh vs Bash
      ↓
Lesson 02
Zsh Language
      ↓
```

Langkah berikutnya sesuai kurikulum adalah:

**Lesson 03 — Parameter Expansion**

Dan di sinilah kita mulai membedah salah satu bagian paling penting dari Zsh, bukan sekadar `${name}`, tetapi bagaimana Zsh dapat melakukan manipulasi data melalui expansion:

```zsh
${parameter}
${parameter:-default}
${parameter##pattern}
${parameter%%pattern}
${(flags)parameter}
```

Termasuk nanti bagaimana expansion tersebut menjadi fondasi untuk scripting Zsh yang jauh lebih ringkas dan kuat.

**Kita belum masuk Lesson 03 pada penjelasan ini; perpindahan dilakukan pada sesi berikutnya.**


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Daftar Teknologi][tekno]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[tekno]: ../../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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

