# Lesson 02 — Zsh Language

Pada Lesson 01 kita banyak menggunakan Bash sebagai pembanding. Mulai Lesson 02, fokus utama berubah:

```bash
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

```bash
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

```bash
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

```bash
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

```bash
print "Hello"
```

terdiri dari:

```bash
print "Hello"
│     │
│     └── argument
└── command
```

Beberapa command:

```bash
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

```bash
name="Amir"
```

merupakan assignment.

Sedangkan:

```bash
print "$name"
```

merupakan command invocation.

Dan:

```bash
if [[ -n "$name" ]]; then
    print "$name"
fi
```

merupakan struktur control flow.

Jadi bahasa Zsh dapat kita lihat sebagai kombinasi:

```bash
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

```bash
name="Amir"
```

Kemudian:

```bash
print "$name"
```

menghasilkan:

```bash
Amir
```

Berbeda dengan banyak bahasa pemrograman, shell assignment tidak menggunakan:

```bash
name = "Amir"
```

Spasi di sekitar `=` memiliki arti penting.

Benar:

```bash
name="Amir"
```

Salah:

```bash
name = "Amir"
```

Karena bentuk kedua akan dipahami sebagai command bernama `name`.

Mental model:

```bash
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

```bash
parameter
```

Contoh:

```bash
name="Amir"
```

`name` adalah parameter.

Parameter Zsh jauh lebih kaya daripada sekadar container string.

Sebuah parameter dapat memiliki berbagai atribut:

```bash
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

```bash
name="Amir"
```

Integer:

```bash
typeset -i count=10
```

Array:

```bash
typeset -a files
```

Associative array:

```bash
typeset -A config
```

Ini menjadi salah satu perbedaan terbesar antara model:

```bash
Bash variable
```

dan:

```bash
Zsh parameter system
```

---

# 02.6 — Scalar parameter

Parameter biasa:

```bash
name="Amir"
```

Nilainya dapat digunakan:

```bash
print "$name"
```

atau:

```bash
print "${name}"
```

Untuk sekarang:

```bash
$name
```

dan:

```bash
${name}
```

dapat dianggap sebagai dua bentuk dasar parameter expansion.

Tetapi `${...}` adalah bentuk yang jauh lebih penting karena hampir seluruh kemampuan parameter expansion Zsh berkembang dari syntax tersebut.

---

# 02.7 — Parameter expansion

Contoh paling dasar:

```bash
name="Amir"
print "$name"
```

Zsh melakukan expansion:

```bash
"$name"
   │
   ▼
"Amir"
```

Dengan braces:

```bash
print "${name}"
```

juga menghasilkan:

```bash
Amir
```

Namun braces memungkinkan kita menambahkan operasi.

Misalnya:

```bash
print "${name:u}"
```

dan:

```bash
print "${name:l}"
```

Zsh dapat melakukan transformasi terhadap parameter secara langsung.

Konsep ini akan menjadi salah satu materi terbesar dalam kurikulum:

```bash
Lesson 03 — Parameter Expansion
```

Jadi sekarang kita hanya membangun fondasinya.

---

# 02.8 — Command substitution

Zsh mendukung:

```bash
result=$(command)
```

Contoh:

```bash
current_dir=$(pwd)
print "$current_dir"
```

Modelnya:

```bash
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

```bash
result=$((10 + 20))
```

Kemudian:

```bash
print "$result"
```

hasilnya:

```bash
30
```

Zsh juga memiliki arithmetic context:

```bash
(( result = 10 + 20 ))
```

Sehingga:

```bash
$(( ... ))
```

dan:

```bash
(( ... ))
```

harus mulai Anda bedakan.

```bash
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

```bash
'text'
"text"
text
```

### Single quotes

```bash
print '$name'
```

menghasilkan literal:

```bash
$name
```

Expansion tidak dilakukan di dalam single quotes.

### Double quotes

```bash
print "$name"
```

parameter expansion dilakukan.

Jika:

```bash
name="Amir"
```

hasilnya:

```bash
Amir
```

### Unquoted

```bash
print $name
```

di sinilah expansion dan word formation dapat memberikan efek berbeda.

Dalam Zsh, perilaku array dan splitting juga berbeda dari Bash, sehingga:

```bash
unquoted expansion
```

merupakan area yang harus dipahami dengan hati-hati.

Kita tidak akan menyelesaikan seluruh detailnya sekarang karena itu masuk ke **Lesson 03 — Parameter Expansion**.

---

# 02.11 — Word dan expansion

Salah satu mental model terpenting dalam shell:

```bash
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

```bash
name="Amir"
print "$name"
```

Zsh tidak langsung melihat `"Amir"` di source code.

Ia terlebih dahulu menemukan:

```bash
$name
```

kemudian melakukan parameter expansion:

```bash
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

```bash
value="one two three"
print -r -- "${(f)value}"
```

Flag:

```bash
(f)
```

memiliki fungsi tertentu dalam expansion.

Jangan khawatir jika syntax tersebut terlihat asing.

Justru ini salah satu tujuan Lesson 02:

```bash
Bash:
${parameter}

Zsh:
${(flag)parameter}
```

Zsh menambahkan sistem expansion yang sangat kuat.

Namun detail semua flags **belum kita pelajari sekarang**.

Itu akan menjadi inti:

```bash
03 — Parameter Expansion
```

---

# 02.13 — Zsh sebagai bahasa dengan expansion pipeline

Sekarang kita bisa memperbaiki mental model kita:

```bash
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

```bash
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

```bash
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

Bagian yang baru kita mulai adalah **syntax dasar + parameter/expansion foundation**. Selanjutnya struktur kontrol, operator, dan aturan syntax yang lebih khas Zsh sebelum masuk ke Lesson 03.

## 02 — Zsh Language

### 02.6 Conditional & Control Structures

Karena kamu sudah mempelajari control flow di Bash, fokus kita di Zsh adalah memahami apa yang tetap sama dan bagian mana yang memiliki karakteristik Zsh.

### 1. `if`

Struktur dasarnya tetap familiar:

```bash
if [[ condition ]]; then
    command
elif [[ condition ]]; then
    command
else
    command
fi
```

Contoh:

```bash
name="Amir"

if [[ -n "$name" ]]; then
    print "Nama tersedia"
else
    print "Nama kosong"
fi
```

Yang penting dipahami: `if` tidak secara langsung memeriksa apakah sebuah kondisi "benar" dalam pengertian boolean.

Shell melihat exit status dari command/conditional expression.

```bash
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

```bash
if [[ -n "$name" ]]; then
```

secara konseptual berarti:

```bash
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

```bash
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

```bash
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

```bash
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

```bash
for item in one two three; do
    print "$item"
done
```

Hasilnya:

```bash
one
two
three
```

Dengan array:

```bash
items=(one two three)

for item in "${items[@]}"; do
    print "$item"
done
```

Namun, karena Zsh memiliki model array yang lebih kuat, nanti kita akan membahas cara idiomatik Zsh untuk iterasi array. Itu belum kita dalami sekarang karena berkaitan dengan Lesson 04.

---

### 4. `while`

```bash
count=1

while (( count <= 3 )); do
    print "$count"
    (( count++ ))
done
```

Hasil:

```bash
1
2
3
```

Di sini ada dua mekanisme berbeda:

```bash
(( count <= 3 ))
```

adalah arithmetic conditional.

Sedangkan:

```bash
(( count++ ))
```

adalah arithmetic evaluation.

Keduanya merupakan bagian penting dari bahasa shell, bukan command eksternal.

---

### 5. `until`

Kebalikan konseptual `while`:

```bash
count=1

until (( count > 3 )); do
    print "$count"
    (( count++ ))
done
```

Mental model:

```bash
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

```bash
[[ "$name" == "Amir" ]]
[[ "$name" != "Amir" ]]
[[ -n "$name" ]]
[[ -z "$name" ]]
```

Maknanya:

```bash
-n → string tidak kosong
-z → string kosong
== → cocok
!= → tidak cocok
```

Contoh:

```bash
name="Amir"

if [[ "$name" == "Amir" ]]; then
    print "Benar"
fi
```

---

### File

```bash
[[ -f "$file" ]]
[[ -d "$directory" ]]
[[ -r "$file" ]]
[[ -w "$file" ]]
[[ -x "$file" ]]
```

Contoh:

```bash
if [[ -f "$HOME/.zshrc" ]]; then
    print ".zshrc ditemukan"
fi
```

Ini penting untuk scripting konfigurasi karena nantinya banyak konfigurasi Zsh akan melakukan pemeriksaan seperti:

```bash
if [[ -r "$file" ]]; then
    source "$file"
fi
```

---

### Logical operators

```bash
[[ condition1 && condition2 ]]
[[ condition1 || condition2 ]]
[[ ! condition ]]
```

Contoh:

```bash
if [[ -f "$file" && -r "$file" ]]; then
    print "File tersedia dan dapat dibaca"
fi
```

Mental model:

```bash
condition1 ──┐
              ├── && → keduanya harus true
condition2 ──┘
```

Sedangkan:

```bash
condition1 ──┐
              ├── || → salah satu cukup true
condition2 ──┘
```

---

## 02.8 Arithmetic

Zsh memiliki arithmetic evaluation yang sangat terintegrasi.

```bash
count=10

(( count += 5 ))

print "$count"
```

Hasil:

```bash
15
```

Conditional:

```bash
if (( count > 10 )); then
    print "Lebih besar dari 10"
fi
```

Tidak perlu:

```bash
if [[ "$count" -gt 10 ]]; then
```

walaupun bentuk tersebut juga dikenal dari shell scripting.

Untuk arithmetic, gunakan:

```bash
(( ... ))
```

Mental model:

```bash
[[ ... ]]
→ conditional expression

(( ... ))
→ arithmetic evaluation / arithmetic condition
```

Contoh:

```bash
a=10
b=20

(( result = a + b ))

print "$result"
```

---

## 02.9 Exit Status

Ini harus benar-benar kuat sebelum masuk ke bagian berikutnya.

Setiap command menghasilkan status.

```bash
command
print "$?"
```

Secara umum:

```bash
0      → berhasil / true
non-0  → gagal / false
```

Contoh:

```bash
true
print "$?"
```

menghasilkan:

```bash
0
```

Sedangkan:

```bash
false
print "$?"
```

menghasilkan:

```bash
1
```

Tetapi angka non-zero tidak selalu berarti hanya `1`. Program dapat menggunakan berbagai nilai non-zero untuk menunjukkan kondisi error yang berbeda.

---

### Exit status dalam `if`

Ini menjelaskan kembali:

```bash
if command; then
    ...
fi
```

sebenarnya:

```bash
jalankan command
       ↓
ambil exit status
       ↓
0 ?
├── ya → then
└── tidak → else/elif
```

Contoh:

```bash
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

```bash
command1 && command2
```

Artinya:

```bash
jalankan command1
       ↓
berhasil?
 ├─ ya → command2
 └─ tidak → berhenti
```

Contoh:

```bash
mkdir /tmp/example && print "Berhasil"
```

Sedangkan:

```bash
command1 || command2
```

berarti:

```bash
jalankan command1
       ↓
berhasil?
 ├─ ya → selesai
 └─ tidak → command2
```

Contoh:

```bash
cd /directory || print "Gagal berpindah directory"
```

Ini sangat sering muncul dalam konfigurasi Zsh.

Tetapi jangan langsung menganggap:

```bash
command1 && command2 || command3
```

sebagai pengganti sempurna `if/else`. Ada persoalan precedence dan status dari `command2`.

Untuk logika yang penting, `if` biasanya lebih jelas.

---

## 02.11 Functions dalam Zsh

Kita sudah mengenalkan function pada Lesson 01. Sekarang kita lihat dari sudut bahasa.

```bash
greet() {
    print "Hello"
}
```

Memanggil:

```bash
greet
```

Parameter positional:

```bash
greet() {
    print "Hello $1"
}

greet "Amir"
```

Di dalam function:

```bash
$1 → argument pertama
$2 → argument kedua
$# → jumlah argument
```

Contoh:

```bash
greet() {
    print "Jumlah argument: $#"
    print "Argument pertama: $1"
}
```

---

## 02.12 Scope

Ini bagian yang mulai membedakan cara berpikir antara scripting sederhana dan scripting konfigurasi.

Misalnya:

```bash
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

```bash
name="global"

test_scope() {
    typeset name="local"
    print "$name"
}

test_scope

print "$name"
```

Mental model:

```bash
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

```bash
typeset name="..."
```

dalam function digunakan ketika kita ingin mendeklarasikan parameter lokal dengan atribut tertentu.

---

## 02.13 `return`

Function dapat mengembalikan exit status:

```bash
check() {
    return 0
}
```

Kemudian:

```bash
if check; then
    print "Berhasil"
fi
```

Atau:

```bash
check
print "$?"
```

Perhatikan perbedaan:

```bash
return
→ keluar dari function

exit
→ keluar dari shell/process
```

Ini sangat penting untuk konfigurasi `.zshrc`.

Misalnya sebuah function:

```bash
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

```bash
source "$HOME/.config/zsh/module.zsh"
```

atau:

```bash
. "$HOME/.config/zsh/module.zsh"
```

Perbedaan mental modelnya dengan menjalankan script:

```bash
source file
    ↓
kode file masuk ke shell saat ini
    ↓
variable/function/options dapat memengaruhi shell sekarang
```

sedangkan:

```bash
zsh file.zsh
```

membuat proses Zsh baru.

Ini akan menjadi sangat penting pada Lesson 09 — Startup Architecture dan Lesson 17 — Modular Configuration.

---

## Posisi kita sekarang

Lesson 02 sudah mencakup:

```bash
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

```bash
if [[ -f "$file" ]]; then
    print "File ditemukan"
fi
```

Penting untuk membedakan:

```bash
[[ ... ]]
```

dari:

```bash
[ ... ]
```

dan dari command eksternal.

`[[ ... ]]` merupakan konstruksi conditional yang dipahami langsung oleh shell.

Contoh:

```bash
if [[ "$SHELL" == */zsh ]]; then
    print "Menggunakan Zsh"
fi
```

Mental modelnya:

```bash
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

```bash
{
    print "Satu"
    print "Dua"
    print "Tiga"
}
```

Ketiganya dijalankan dalam shell yang sama.

Grouping ini juga dapat dikombinasikan dengan redirection:

```bash
{
    print "Satu"
    print "Dua"
} > output.txt
```

Mental model:

```bash
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

```bash
(
    command1
    command2
)
```

menjalankan kelompok tersebut dalam subshell.

Contoh:

```bash
pwd

(
    cd /tmp
    pwd
)

pwd
```

Secara konsep:

```bash
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

```bash
{
    ...
}
```

→ grouping dalam shell saat ini.

```bash
(
    ...
)
```

→ grouping dalam subshell.

---

# 02.18 Anonymous function

Zsh memiliki konstruksi function yang dapat dibuat dan langsung dijalankan.

Bentuknya:

```bash
() {
    print "Hello"
}
```

Kemudian block tersebut langsung dieksekusi.

Contoh:

```bash
() {
    print "Current directory: $PWD"
}
```

Mental model:

```bash
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

```bash
emulate
```

Contoh:

```bash
emulate -L zsh
```

Mental model:

```bash
emulate -L zsh
       │
       ├── gunakan perilaku Zsh
       └── scope option dibuat lokal
```

Ini bukan sekadar command biasa yang kebetulan bernama `emulate`. Ini adalah bagian penting dari cara Zsh mengisolasi perilaku sebuah function.

Contoh yang akan sering kamu temui ketika membaca kode Zsh:

```bash
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

```bash
noglob command '*.txt'
```

Biasanya shell dapat melakukan filename generation terhadap pattern tertentu.

Dengan `noglob`, pattern tersebut diteruskan ke command tanpa globbing biasa.

Mental model:

```bash
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

```bash
eval
```

Misalnya:

```bash
command="print Hello"

eval "$command"
```

`eval` menyebabkan string diproses kembali sebagai shell code.

Mental model:

```bash
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

```bash
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

```bash
command git
```

atau:

```bash
builtin cd
```

atau:

```bash
functions
```

Masing-masing memiliki tujuan berbeda.

### `command`

```bash
command git
```

meminta shell menjalankan `git` sebagai command, dengan menghindari penggunaan function bernama `git` sebagai mekanisme pemanggilan.

Misalnya:

```bash
git() {
    print "custom git"
}
```

Kemudian:

```bash
git
```

akan memanggil function tersebut.

Sedangkan:

```bash
command git
```

meminta command resolution untuk command tersebut.

Ini sangat relevan ketika membuat wrapper function.

---

### `builtin`

```bash
builtin cd /tmp
```

secara eksplisit meminta builtin `cd`.

Ini berguna ketika terdapat function dengan nama yang sama:

```bash
cd() {
    print "custom cd"
}
```

Kemudian:

```bash
builtin cd /tmp
```

memanggil builtin asli.

---

### `functions`

Zsh mempunyai mekanisme untuk melihat function yang didefinisikan:

```bash
functions
```

Untuk melihat definisi function tertentu:

```bash
functions my_function
```

Dan sebelumnya kita juga telah mengenal:

```bash
whence -f my_function
```

Ini akan sangat berguna nanti ketika kita mulai **membaca plugin Zsh**.

---

# 02.23 `autoload` — hanya konsep dasar

Kita sudah beberapa kali menyebut:

```bash
autoload -Uz function_name
```

Sekarang kita perlu memasukkannya ke bahasa Zsh, tetapi belum membahas sistem autoload secara mendalam.

Konsep dasarnya:

```bash
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

```bash
autoload -Uz compinit
compinit
```

Tetapi `autoload`, function directories, `fpath`, dan mekanisme lazy loading akan menjadi materi utama **Lesson 08 — Functions & Autoload**.

Jadi pada Lesson 02 kita hanya perlu mengenali sintaks dan konsepnya.

---

# 02.24 `trap`

Kamu sudah memiliki dasar Bash mengenai `trap`, sehingga tidak perlu mengulang konsep shell signal secara panjang.

Dalam Zsh juga terdapat:

```bash
trap 'command' SIGNAL
```

Contoh:

```bash
trap 'print "Received INT"' INT
```

Konsepnya tetap:

```bash
signal
   ↓
trap
   ↓
shell menjalankan handler
```

Namun Zsh mempunyai mekanisme lain yang lebih khas untuk konfigurasi interaktif, terutama **hooks**.

Hooks tersebut baru akan kita pelajari pada:

```bash
Lesson 15 — Hooks
```

Jadi jangan mencampurkan `trap` dengan hook Zsh.

```bash
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

```bash
setopt ERR_EXIT
```

Konsepnya berkaitan dengan penghentian shell/function ketika command tertentu menghasilkan status non-zero.

Tetapi Zsh mempunyai aturan yang cukup kompleks mengenai konteks ketika error dianggap fatal atau tidak.

Karena itu kita **tidak akan menjadikan `set -e`/`ERR_EXIT` sebagai fokus Lesson 02**.

Yang perlu dibawa dari sini:

```bash
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

```bash
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

```bash
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

```bash
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

```bash
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

