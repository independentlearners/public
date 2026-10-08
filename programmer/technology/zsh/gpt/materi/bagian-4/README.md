# Lesson 03 — Parameter Expansion

Fokus lesson ini adalah memahami sistem parameter expansion Zsh secara mendalam. Kita belum masuk ke arrays/data manipulation sebagai topik tersendiri; itu tetap **Lesson 04**.

Parameter expansion adalah salah satu alasan utama Zsh sangat kuat untuk scripting. Jika di Bash kamu sering menggunakan kombinasi `cut`, `sed`, `awk`, `basename`, `dirname`, dan sebagainya untuk manipulasi string sederhana, Zsh memiliki banyak kemampuan yang dapat dilakukan langsung melalui expansion.

Urutan belajarnya:

```text
03 — Parameter Expansion
│
├── 03.1 Konsep parameter expansion
├── 03.2 Basic parameter expansion
├── 03.3 Default values
├── 03.4 Substring
├── 03.5 Prefix / suffix removal
├── 03.6 Pattern replacement
├── 03.7 Case modification
├── 03.8 Expansion flags
├── 03.9 Nested expansion
├── 03.10 Parameter modifiers
└── 03.11 Mental model dan praktik
```

Kita mulai dari fondasinya.

---

## 03.1 Apa itu Parameter Expansion?

Misalnya:

```zsh
name="Amir"
```

Kemudian:

```zsh
print "$name"
```

Shell melihat:

```text
$name
```

dan menggantinya dengan isi parameter:

```text
Amir
```

Secara sederhana:

```text
source code
    │
    ▼
"$name"
    │
    ▼
parameter expansion
    │
    ▼
"Amir"
```

Jadi:

```zsh
print "$name"
```

bukan berarti `print` mengetahui variable bernama `name`.

Justru Zsh terlebih dahulu melakukan expansion terhadap argumen sebelum `print` menerima hasil akhirnya.

Secara konseptual:

```text
print "$name"
     │
     └── expansion
          ↓
        "Amir"
          ↓
        print menerima "Amir"
```

Ini adalah dasar penting.

---

# 03.2 `$name` dan `${name}`

Dua bentuk dasar:

```zsh
print "$name"
```

dan:

```zsh
print "${name}"
```

keduanya mengambil nilai parameter `name`.

Contoh:

```zsh
name="Amir"

print "$name"
print "${name}"
```

hasilnya sama:

```text
Amir
Amir
```

Lalu mengapa `${...}` penting?

Karena ketika parameter berada di dalam teks lain, batas nama parameter harus dibuat eksplisit.

Misalnya:

```zsh
name="Amir"

print "${name}_config"
```

hasil:

```text
Amir_config
```

Bandingkan:

```zsh
print "$name_config"
```

Zsh akan menganggap `name_config` sebagai nama parameter.

Jadi:

```text
"$name_config"
```

berarti:

```text
parameter bernama name_config
```

sedangkan:

```text
"${name}_config"
```

berarti:

```text
parameter name
+
literal "_config"
```

Ini alasan `${parameter}` merupakan bentuk fundamental dalam parameter expansion.

---

# 03.3 Expansion bukan Assignment

Perhatikan:

```zsh
name="Amir"
```

Ini adalah **assignment**.

Sedangkan:

```zsh
print "$name"
```

mengandung **parameter expansion**.

Jangan mencampurkan keduanya:

```text
name="Amir"
│
└── assignment

"$name"
│
└── parameter expansion
```

Contoh lain:

```zsh
result="${name}_developer"
```

Dalam satu statement terdapat dua hal:

```text
result=...
│
└── assignment

"${name}"
│
└── parameter expansion
```

Hasil:

```zsh
name="Amir"
result="${name}_developer"

print "$result"
```

```text
Amir_developer
```

---

# 03.4 Default Value

Sekarang kita masuk ke salah satu bentuk yang sangat penting:

```zsh
${parameter:-word}
```

Contoh:

```zsh
name=""

print "${name:-Anonymous}"
```

hasil:

```text
Anonymous
```

Mental model:

```text
${name:-Anonymous}
       │
       ├── name punya nilai?
       │
       ├── ya  → gunakan name
       │
       └── tidak/kosong → gunakan Anonymous
```

Contoh lain:

```zsh
name="Amir"

print "${name:-Anonymous}"
```

hasil:

```text
Amir
```

Perhatikan bahwa:

```zsh
${name:-Anonymous}
```

**tidak mengubah `name`.**

Misalnya:

```zsh
unset name

print "${name:-Anonymous}"
print "$name"
```

hasil secara konseptual:

```text
Anonymous

```

`name` tetap unset.

Ini berbeda dengan bentuk assignment default yang akan kita bahas berikutnya.

---

# 03.5 Assignment Default

Bentuk:

```zsh
${parameter:=word}
```

berarti:

> Jika parameter belum memiliki nilai yang sesuai, gunakan `word` dan assign hasilnya ke parameter.

Contoh:

```zsh
unset name

print "${name:=Anonymous}"
print "$name"
```

Hasil:

```text
Anonymous
Anonymous
```

Perbedaannya:

```text
${name:-Anonymous}
        │
        └── hanya menghasilkan fallback


${name:=Anonymous}
        │
        └── menghasilkan fallback + mengubah name
```

Mental model:

```text
:- 
parameter ──→ fallback
              │
              └── parameter tidak berubah


:=
parameter ──→ fallback
      │
      └── parameter juga diisi fallback
```

Ini sangat sering digunakan dalam konfigurasi shell.

Misalnya:

```zsh
config_dir="${CONFIG_DIR:-$HOME/.config}"
```

Artinya:

```text
CONFIG_DIR tersedia?
│
├── ya → gunakan CONFIG_DIR
│
└── tidak/kosong → gunakan $HOME/.config
```

---

# 03.6 Error Jika Parameter Tidak Tersedia

Ada juga:

```zsh
${parameter:?word}
```

Contoh:

```zsh
unset required_value

print "${required_value:?required_value is required}"
```

Jika parameter tidak tersedia sesuai kondisi yang diperiksa, expansion menghasilkan error.

Mental model:

```text
${required_value:?message}
          │
          ├── tersedia → gunakan nilainya
          │
          └── tidak → error dengan message
```

Ini berguna untuk parameter yang memang wajib ada.

Contoh konseptual:

```zsh
config_file="${CONFIG_FILE:?CONFIG_FILE must be defined}"
```

Sekarang kita memiliki tiga pola penting:

```text
${name:-default}
    fallback

${name:=default}
    fallback + assignment

${name:?error}
    fallback tidak diberikan
    → error jika tidak tersedia
```

Ada juga:

```zsh
${name:+word}
```

yang akan kita bahas setelah memahami konsep dasarnya lebih kuat.

---

# 03.7 Mengapa Ada `:`?

Perhatikan:

```zsh
${name:-default}
```

dan:

```zsh
${name-default}
```

Keduanya tidak selalu berarti hal yang sama.

Dengan `:`:

```zsh
${name:-default}
```

kondisinya memperhatikan parameter yang **unset atau empty**.

Tanpa `:`:

```zsh
${name-default}
```

fokusnya adalah apakah parameter **unset**.

Mental model:

```text
name unset
    │
    ├── ${name:-default} → default
    └── ${name-default}  → default


name=""
    │
    ├── ${name:-default} → default
    └── ${name-default}  → ""
```

Ini perbedaan yang sangat penting dalam shell scripting.

Jadi jangan menganggap `:` hanya karakter dekoratif.

---

# 03.8 Menguji Perbedaannya

Gunakan eksperimen kecil:

```zsh
unset value

print "A=[${value-default}]"
print "B=[${value:-default}]"
```

Kemudian:

```zsh
value=""

print "A=[${value-default}]"
print "B=[${value:-default}]"
```

Dan:

```zsh
value="hello"

print "A=[${value-default}]"
print "B=[${value:-default}]"
```

Dengan memasukkan hasil ke:

```text
[ ... ]
```

kita dapat melihat string kosong dengan jelas.

Mental model eksperimen:

```text
           unset       empty       non-empty
------------------------------------------------
:-         default     default     value
-          default     empty       value
```

Ini adalah salah satu tabel kecil yang layak kamu ingat.

---

## 03.9 `:+` — Alternate Value

Sekarang kebalikan dari fallback:

```zsh
${parameter:+word}
```

Artinya secara konseptual:

> Jika parameter memiliki nilai yang sesuai, gunakan `word`; jika tidak, hasilnya kosong.

Contoh:

```zsh
name="Amir"

print "[${name:+defined}]"
```

hasil:

```text
[defined]
```

Sedangkan:

```zsh
name=""

print "[${name:+defined}]"
```

hasil:

```text
[]
```

Jadi:

```text
${name:-default}
```

berorientasi:

```text
tidak ada nilai
      ↓
gunakan default
```

Sedangkan:

```text
${name:+alternate}
```

berorientasi:

```text
ada nilai
    ↓
gunakan alternate
```

---

## 03.10 Empat Operator Dasar

Sekarang kita punya empat bentuk fundamental:

```text
${parameter:-word}
${parameter-word}

${parameter:=word}
${parameter=word}

${parameter:?word}
${parameter?word}

${parameter:+word}
${parameter+word}
```

Jangan menghafalnya sebagai simbol acak.

Kelompokkan berdasarkan operasi:

```text
-  → default
=  → assign default
?  → error
+  → alternate
```

Sedangkan:

```text
:
```

membedakan perlakuan terhadap parameter kosong.

Mental model:

```text
parameter expansion
│
├── -
│   └── fallback
│
├── =
│   └── fallback + assignment
│
├── ?
│   └── error
│
└── +
    └── alternate
```

Ini baru lapisan pertama dari Parameter Expansion.

Kita **belum** masuk ke:

```zsh
${name#pattern}
${name##pattern}
${name%pattern}
${name%%pattern}
${name/pattern/replacement}
${name:l}
${name:u}
${(f)name}
```

karena itu merupakan bagian berikutnya dari Lesson 03.

---

### Posisi kurikulum saat ini

```text
03 — Parameter Expansion
│
├── ✓ konsep parameter expansion
├── ✓ $parameter
├── ✓ ${parameter}
├── ✓ default value
├── ✓ assignment default
├── ✓ error expansion
├── ✓ alternate value
│
├── → prefix/suffix removal
├── → substring
├── → pattern replacement
├── → case modification
├── → expansion flags
├── → nested expansion
└── → parameter modifiers
```

Materi berikutnya adalah **prefix/suffix removal dengan `#`, `##`, `%`, dan `%%`**.


## 03.11 Prefix Removal — `${parameter#pattern}` dan `${parameter##pattern}`

Sekarang kita masuk ke operasi yang sangat sering digunakan dalam konfigurasi dan plugin Zsh: **menghapus bagian awal atau akhir sebuah string berdasarkan pattern**.

Misalnya:

```zsh
path="/home/amir/projects/zsh/config.zsh"
```

Kita ingin mengambil bagian tertentu dari path tanpa menggunakan `sed`, `cut`, atau `basename`.

### 1. `${parameter#pattern}`

Bentuk:

```zsh
${parameter#pattern}
```

berarti:

> Cocokkan `pattern` dari awal nilai parameter, lalu hapus kecocokan paling pendek.

Contoh sederhana:

```zsh
path="/home/amir/projects/zsh/config.zsh"

print "${path#*/}"
```

Hasil:

```text
home/amir/projects/zsh/config.zsh
```

Mengapa?

Nilai awal:

```text
/home/amir/projects/zsh/config.zsh
^
└── */ cocok dengan / paling pendek
```

Karena `*` dapat mencocokkan string, tetapi algoritmanya memilih **kecocokan paling pendek** yang memungkinkan.

---

### 2. `${parameter##pattern}`

Sekarang:

```zsh
${parameter##pattern}
```

Perbedaannya adalah `##` menghapus kecocokan **paling panjang** dari awal.

Contoh:

```zsh
path="/home/amir/projects/zsh/config.zsh"

print "${path##*/}"
```

Hasil:

```text
config.zsh
```

Mental model:

```text
${path#*/}
        │
        └── hapus match TERPENDEK dari awal


${path##*/}
         │
         └── hapus match TERPANJANG dari awal
```

Ini merupakan pola klasik untuk mendapatkan nama file dari path.

```text
/home/amir/projects/zsh/config.zsh
───────────────────────────────────
                       config.zsh
```

---

# 03.12 Prefix Removal dengan Contoh yang Lebih Jelas

Gunakan:

```zsh
value="abc/def/ghi"
```

Kemudian:

```zsh
print "${value#*/}"
```

hasil:

```text
def/ghi
```

Sedangkan:

```zsh
print "${value##*/}"
```

hasil:

```text
ghi
```

Visual:

```text
abc/def/ghi
│
├── ${value#*/}
│       ↓
│   def/ghi
│
└── ${value##*/}
        ↓
      ghi
```

Jadi perbedaannya bukan pada pattern `*/`.

Perbedaannya adalah **seberapa banyak pattern tersebut diperbolehkan mencocokkan dari kiri**.

---

# 03.13 Suffix Removal — `%` dan `%%`

Sekarang kita membalik arah.

Jika:

```text
#  → dari kiri / awal
%  → dari kanan / akhir
```

Bentuk:

```zsh
${parameter%pattern}
```

berarti:

> Hapus kecocokan paling pendek dari akhir parameter.

Sedangkan:

```zsh
${parameter%%pattern}
```

berarti:

> Hapus kecocokan paling panjang dari akhir parameter.

Contoh:

```zsh
file="config.backup.zsh"
```

Gunakan:

```zsh
print "${file%.*}"
```

Hasil:

```text
config.backup
```

Karena `.*` dicocokkan dari bagian akhir dan memilih match paling pendek.

Sedangkan:

```zsh
print "${file%%.*}"
```

hasil:

```text
config
```

Karena `%%` memilih match paling panjang dari akhir.

Visual:

```text
config.backup.zsh
      │       │
      │       └── extension terakhir
      │
      └── bagian sebelumnya
```

```text
${file%.*}
→ config.backup


${file%%.*}
→ config
```

---

# 03.14 Empat Operator yang Harus Dikuasai

Sekarang kita memiliki empat operator utama:

```text
┌───────────────┬───────────────────────────────┐
│ Operator      │ Operasi                       │
├───────────────┼───────────────────────────────┤
│ ${x#pattern}  │ hapus match terpendek dari kiri│
│ ${x##pattern} │ hapus match terpanjang dari kiri│
│ ${x%pattern}  │ hapus match terpendek dari kanan│
│ ${x%%pattern} │ hapus match terpanjang dari kanan│
└───────────────┴───────────────────────────────┘
```

Mental model paling sederhana:

```text
              STRING
        ┌─────────────────┐
        │ abc/def/ghi.txt │
        └─────────────────┘
          ↑             ↑
          │             │
       # / ##        % / %%
       dari kiri     dari kanan
```

Dan:

```text
satu simbol
→ shortest match

dua simbol
→ longest match
```

Ini jauh lebih penting daripada menghafalkan contoh individual.

---

# 03.15 Pattern Bukan Regex

Ini perlu ditegaskan karena kamu sudah mempelajari Bash.

Dalam:

```zsh
${path##*/}
```

bagian:

```text
*/
```

adalah **pattern**, bukan regular expression.

Misalnya:

```text
*     → mencocokkan sejumlah karakter
?     → satu karakter
[abc] → salah satu karakter dalam set
```

Jadi jangan membaca:

```zsh
${path##*/}
```

sebagai regex.

Bacalah:

```text
parameter expansion
        +
pattern matching
        +
longest prefix removal
```

Kita memang akan membahas globbing secara khusus pada **Lesson 05**, tetapi untuk Lesson 03 ini cukup memahami bahwa pattern tersebut digunakan oleh parameter expansion.

---

# 03.16 Praktik dengan Path

Ini adalah salah satu penggunaan yang sangat relevan untuk konfigurasi Zsh.

```zsh
file="/home/amir/.config/zsh/zshrc"
```

Nama file:

```zsh
print "${file##*/}"
```

hasil:

```text
zshrc
```

Directory/path:

```zsh
print "${file%/*}"
```

hasil:

```text
/home/amir/.config/zsh
```

Jadi kita dapat memperoleh dua bagian:

```text
/home/amir/.config/zsh/zshrc
───────────────────────────
             │
             ├── ${file%/*}
             │   /home/amir/.config/zsh
             │
             └── ${file##*/}
                 zshrc
```

Tanpa:

```text
basename
dirname
sed
awk
cut
```

Ini merupakan contoh penting mengapa parameter expansion menjadi sangat kuat dalam scripting Zsh.

---

# 03.17 Menghapus Extension

Misalnya:

```zsh
file="script.zsh"
```

Gunakan:

```zsh
print "${file%.zsh}"
```

hasil:

```text
script
```

Namun jika extension dapat bervariasi:

```zsh
file="script.zsh"
print "${file%.*}"
```

hasil:

```text
script
```

Untuk nama:

```zsh
file="archive.tar.gz"
```

```zsh
print "${file%.*}"
```

hasil:

```text
archive.tar
```

Sedangkan:

```zsh
print "${file%%.*}"
```

hasil:

```text
archive
```

Ini menunjukkan kembali perbedaan shortest vs longest.

---

# 03.18 Cara Berpikir yang Benar

Jangan menghafalkan:

```text
# = kiri
## = kiri lebih banyak
% = kanan
%% = kanan lebih banyak
```

saja.

Gunakan model:

```text
#   → remove shortest prefix match
##  → remove longest prefix match

%   → remove shortest suffix match
%%  → remove longest suffix match
```

Kemudian visualisasikan arah pencarian:

```text
# / ##
←──────────── STRING ────────────→
^
awal


% / %%
←──────────── STRING ────────────→
                               ^
                              akhir
```

---

# 03.19 Menggabungkan Beberapa Expansion

Parameter expansion dapat digunakan bertingkat.

Misalnya:

```zsh
path="/home/amir/projects/zsh/config.zsh"
```

Kita ingin mendapatkan:

```text
config
```

Pertama:

```zsh
${path##*/}
```

menghasilkan:

```text
config.zsh
```

Kemudian suffix:

```zsh
${...%.zsh}
```

secara konseptual menghasilkan:

```text
config
```

Kita dapat menulisnya dalam bentuk nested expansion.

Namun, untuk sekarang **jangan terlalu mengejar sintaks nested yang kompleks**. Nested parameter expansion akan kita bahas sebagai bagian tersendiri setelah operasi dasar selesai.

Yang penting sekarang adalah memahami bahwa hasil sebuah expansion dapat menjadi input untuk expansion berikutnya.

---

# 03.20 Ringkasan Tahap Ini

Kita sekarang sudah menguasai:

```text
${parameter#pattern}
${parameter##pattern}
${parameter%pattern}
${parameter%%pattern}
```

Dengan model:

```text
                 PARAMETER
                     │
          ┌──────────┴──────────┐
          │                     │
        dari kiri             dari kanan
          │                     │
       # / ##                 % / %%
          │                     │
       shortest              shortest
       longest               longest
```

Contoh paling penting:

```zsh
path="/home/amir/project/file.zsh"

print "${path##*/}"
# file.zsh

print "${path%/*}"
# /home/amir/project
```

Dan:

```zsh
file="archive.tar.gz"

print "${file%.*}"
# archive.tar

print "${file%%.*}"
# archive
```

---

## Posisi Lesson 03 sekarang

```text
03 — Parameter Expansion
│
├── ✓ Konsep parameter expansion
├── ✓ $parameter
├── ✓ ${parameter}
├── ✓ Default values
├── ✓ Assignment default
├── ✓ Error expansion
├── ✓ Alternate value
├── ✓ Prefix removal  # / ##
├── ✓ Suffix removal  % / %%
│
├── → Substring
├── → Pattern replacement
├── → Case modification
├── → Expansion flags
├── → Nested expansion
└── → Parameter modifiers
```

Berikutnya **substring extraction**, kemudian pattern replacement.

## 03.21 Substring Extraction

Tujuannya adalah mengambil bagian tertentu dari nilai parameter berdasarkan posisi karakter.

Bentuk dasarnya:

```zsh
${parameter:offset:length}
```

Namun ada satu hal penting: **indeks substring Zsh perlu dipahami dengan benar**, karena Zsh memiliki aturan array dan substring yang khas.

### 1. Offset

Misalnya:

```zsh
value="abcdef"
```

Kita dapat mengambil substring berdasarkan posisi:

```zsh
print "${value:2}"
```

Secara konsep:

```text
abcdef
  ↑
 offset
```

Hasilnya adalah bagian string mulai dari posisi tersebut.

Untuk belajar substring dengan aman, gunakan eksperimen kecil dan jangan langsung mengandalkan asumsi dari Bash, karena detail indexing Zsh berbeda dalam beberapa konteks.

---

### 2. Offset dan length

Bentuk:

```zsh
${value:offset:length}
```

memungkinkan kita menentukan jumlah karakter yang diambil.

Misalnya secara konseptual:

```zsh
value="abcdef"

print "${value:1:3}"
```

artinya:

```text
mulai dari offset 1
ambil 3 karakter
```

Mental model:

```text
abcdef
 ↑───↑
 │
 offset
 │
 └── length
```

Hasil konkret untuk eksperimen seperti ini sebaiknya kamu jalankan langsung pada Zsh 5.9 yang kamu gunakan, karena kita sedang mempelajari semantik Zsh, bukan sekadar menghafal bentuk sintaks.

---

## 03.22 Substring vs Prefix/Suffix Removal

Sekarang bedakan dua teknik yang sudah kita pelajari.

### Prefix/suffix removal

```zsh
${value#pattern}
${value##pattern}
${value%pattern}
${value%%pattern}
```

berbasis **pattern**.

Misalnya:

```zsh
path="/home/amir/project/file.zsh"

print "${path##*/}"
```

Kita tidak menentukan posisi karakter. Kita mengatakan:

> Hapus prefix yang cocok dengan pattern `*/`.

---

### Substring

```zsh
${value:offset:length}
```

berbasis **posisi**.

Mental model:

```text
Pattern-based
────────────────────────
${value##pattern}
        ↓
    cari berdasarkan pattern


Position-based
────────────────────────
${value:offset:length}
        ↓
    ambil berdasarkan posisi
```

Keduanya sama-sama melakukan manipulasi string, tetapi cara berpikirnya berbeda.

---

# 03.23 Negative Offset

Zsh juga mendukung pengambilan dari arah akhir string menggunakan offset negatif.

Misalnya:

```zsh
value="abcdef"
```

Secara konsep:

```text
abcdef
     ↑
   akhir
```

Offset negatif memungkinkan kita menghitung dari sisi kanan.

Ini berguna untuk kasus seperti:

```text
ambil beberapa karakter terakhir
```

Tetapi hati-hati membedakannya dari:

```zsh
${value[-1]}
```

yang nanti juga berkaitan dengan sintaks array/parameter Zsh.

Karena **Lesson 04 adalah Arrays & Data Manipulation**, kita tidak akan mencampurkan pembahasan indexing array ke sini.

Untuk Lesson 03, fokusnya:

```text
substring
└── manipulasi scalar string
```

---

# 03.24 Pattern Replacement

Sekarang kita masuk ke operasi berikutnya:

```zsh
${parameter/pattern/replacement}
```

Misalnya:

```zsh
name="hello world"
```

Kemudian:

```zsh
print "${name/hello/hi}"
```

Secara konseptual:

```text
hello world
  │
  └── hello → hi
```

hasil:

```text
hi world
```

Ini adalah **pattern replacement**, bukan regex replacement.

Jadi:

```zsh
${name/hello/hi}
```

harus dibaca:

```text
parameter
    ↓
cari pattern
    ↓
ganti dengan replacement
```

---

# 03.25 Replace Pertama vs Semua Match

Perhatikan bentuk:

```zsh
${parameter/pattern/replacement}
```

dan:

```zsh
${parameter//pattern/replacement}
```

Satu `/`:

```zsh
${value/pattern/replacement}
```

→ mengganti **match pertama**.

Dua `/`:

```zsh
${value//pattern/replacement}
```

→ mengganti **semua match yang sesuai**.

Contoh:

```zsh
value="foo foo foo"

print "${value/foo/bar}"
```

secara konsep:

```text
foo foo foo
 ↓
bar foo foo
```

Sedangkan:

```zsh
print "${value//foo/bar}"
```

menjadi:

```text
bar bar bar
```

Mental model:

```text
/   → first match
//  → all matches
```

Ini merupakan pola yang sangat penting.

---

# 03.26 Pattern Replacement Bukan Regex

Misalnya:

```zsh
value="foo123foo456"
```

Kamu mungkin terbiasa berpikir:

```text
regex → foo[0-9]+
```

Tetapi parameter replacement menggunakan **shell pattern**, bukan regular expression.

Jadi jangan membawa mental model regex ke:

```zsh
${value//pattern/replacement}
```

Kita akan membahas pattern secara lebih lengkap di **Lesson 05 — Filename Generation / Glob**.

Untuk sekarang:

```text
parameter expansion
        │
        └── pattern matching
```

cukup dipahami sebagai mekanisme pattern Zsh.

---

# 03.27 Replacement dengan Variabel

Replacement juga dapat menggunakan parameter lain.

```zsh
value="hello world"
replacement="Zsh"

print "${value/world/$replacement}"
```

Hasil:

```text
hello Zsh
```

Dengan demikian parameter expansion dapat dikombinasikan:

```text
parameter
   ↓
match pattern
   ↓
ambil replacement
   ↓
hasilkan string baru
```

Ini menjadi semakin kuat ketika nanti digabungkan dengan expansion flags.

---

# 03.28 Case Modification

Sekarang kita masuk ke operasi perubahan huruf besar/kecil.

Zsh menyediakan modifier:

```zsh
${parameter:l}
```

untuk lowercase.

Contoh:

```zsh
name="AMIR"

print "${name:l}"
```

hasil:

```text
amir
```

Sedangkan:

```zsh
${parameter:u}
```

untuk uppercase.

```zsh
name="amir"

print "${name:u}"
```

hasil:

```text
AMIR
```

Mental model:

```text
${name:l}
      │
      └── lowercase


${name:u}
      │
      └── uppercase
```

Perhatikan bahwa expansion ini **tidak mengubah parameter asli**.

```zsh
name="Amir"

print "${name:u}"
print "$name"
```

hasil secara konseptual:

```text
AMIR
Amir
```

Jadi:

```text
${name:u}
```

menghasilkan nilai baru untuk digunakan dalam command/assignment, bukan melakukan mutation langsung terhadap `name`.

---

# 03.29 Contoh Praktis Case Modification

Misalnya kita ingin normalisasi input:

```zsh
choice="YES"
```

Kita bisa melakukan:

```zsh
case "${choice:l}" in
    yes)
        print "Enabled"
        ;;
    no)
        print "Disabled"
        ;;
esac
```

Input:

```text
YES
Yes
yes
YeS
```

semuanya dapat dinormalisasi menjadi:

```text
yes
```

melalui:

```zsh
${choice:l}
```

Ini merupakan pola yang sangat berguna dalam konfigurasi interaktif.

---

# 03.30 Menggabungkan Operator

Sekarang kita mulai melihat kekuatan parameter expansion ketika beberapa operasi digabungkan.

Misalnya:

```zsh
file="/home/amir/projects/script.zsh"
```

Kita bisa mengambil nama file:

```zsh
name="${file##*/}"
```

hasil:

```text
script.zsh
```

Kemudian menghilangkan extension:

```zsh
base="${name%.zsh}"
```

hasil:

```text
script
```

Kemudian mengubahnya:

```zsh
print "${base:u}"
```

hasil:

```text
SCRIPT
```

Alurnya:

```text
/home/amir/projects/script.zsh
                │
                │ ${file##*/}
                ▼
           script.zsh
                │
                │ ${name%.zsh}
                ▼
             script
                │
                │ ${base:u}
                ▼
             SCRIPT
```

Tidak diperlukan command eksternal.

---

# 03.31 Expansion Bersifat Ekspresif

Sekarang mulai terlihat mengapa Zsh sangat kuat untuk scripting konfigurasi.

Dalam shell lain, seseorang mungkin membuat pipeline:

```text
path
 ↓
basename
 ↓
sed
 ↓
tr
```

Sedangkan Zsh dapat melakukan banyak transformasi langsung:

```zsh
"${path##*/}"
"${name%.zsh}"
"${name:u}"
"${value//old/new}"
```

Namun jangan mengambil kesimpulan bahwa external tools selalu buruk.

Prinsipnya:

```text
Gunakan parameter expansion
→ jika operasi memang merupakan manipulasi parameter sederhana.

Gunakan external tool
→ jika pekerjaan membutuhkan kemampuan yang memang lebih cocok
  dilakukan oleh tool tersebut.
```

Tujuan kita bukan menghilangkan `sed`, `awk`, `grep`, dan lainnya, tetapi memahami kemampuan native Zsh.

---

# 03.32 Posisi Lesson 03

Sekarang struktur kita menjadi:

```text
03 — Parameter Expansion
│
├── ✓ Konsep parameter expansion
├── ✓ $parameter
├── ✓ ${parameter}
├── ✓ Default values
├── ✓ Assignment default
├── ✓ Error expansion
├── ✓ Alternate value
├── ✓ Prefix removal
│   ├── #
│   └── ##
├── ✓ Suffix removal
│   ├── %
│   └── %%
├── ✓ Substring
├── ✓ Pattern replacement
│   ├── /
│   └── //
├── ✓ Case modification
│   ├── :l
│   └── :u
│
├── → Expansion flags
├── → Nested expansion
└── → Parameter modifiers
```

Tahap berikutnya masih **Lesson 03**, yaitu bagian yang sangat khas Zsh:

```zsh
${(flag)parameter}
```

Di sinilah kita akan mulai membahas **expansion flags** seperti `(f)`, `(s:...:)`, `(j:...:)`, `(q)`, `(Q)`, dan flag lainnya secara bertahap.

Ini penting karena expansion flags adalah salah satu mekanisme yang membuat konfigurasi/plugin Zsh terlihat sangat berbeda dari Bash.

## 03.33 Expansion Flags

Ini adalah bagian yang sangat penting dari Zsh.

Sebelumnya kita menggunakan:

```zsh
${name}
${name:u}
${name:l}
${path##*/}
${value//old/new}
```

Zsh memiliki bentuk tambahan:

```zsh
${(flag)parameter}
```

Bagian:

```text
${( ... )parameter}
   ^^^^^
   flags
```

disebut **parameter expansion flags**.

Dokumentasi Zsh menjelaskan bahwa ketika `{` langsung diikuti `(`, isi sampai `)` diperlakukan sebagai daftar flag untuk expansion tersebut. ([Zsh][1])

Mental modelnya:

```text
${(flag)parameter}
       │
       └── ubah cara Zsh memproses
           hasil parameter expansion
```

Jadi `(flag)` bukan nilai parameter dan bukan syntax command biasa.

---

# 03.34 Flag `(f)` — Split by Newline

Salah satu flag yang sangat penting:

```zsh
${(f)parameter}
```

`f` berarti hasil expansion dipecah berdasarkan newline. Dokumentasi resmi menyebutnya sebagai shorthand untuk pemisahan pada `\n`. ([Zsh][1])

Misalnya:

```zsh
text=$'one\ntwo\nthree'
```

Kemudian:

```zsh
print -r -- ${(f)text}
```

Secara konseptual, hasil expansion menjadi:

```text
one
two
three
```

Yang penting bukan sekadar outputnya.

Sebelum `(f)`:

```text
text
└── satu scalar string
    "one\ntwo\nthree"
```

Dengan `(f)`:

```text
text
   │
   ▼
(f)
   │
   ▼
one
two
three
   │
   ▼
beberapa word
```

Jadi `(f)` mengubah bagaimana hasil expansion diperlakukan pada tahap splitting.

---

# 03.35 Mengapa `(f)` Penting?

Ini sangat berguna ketika membaca file.

Misalnya:

```zsh
text="$(< "$HOME/example.txt")"
```

Kemudian kita ingin memproses setiap baris.

Dengan:

```zsh
${(f)text}
```

isi tersebut dapat diperlakukan sebagai kumpulan word berdasarkan newline.

Dokumentasi resmi bahkan menggunakan pola:

```zsh
${(f)"$(<file)"}
```

untuk membuat isi file menjadi elemen berdasarkan baris. ([Zsh][1])

Perhatikan dua hal:

```zsh
${(f)"$(<file)"}
      ^^^^^^^^
```

dan:

```zsh
${(f)text}
```

Keduanya menggunakan konsep yang sama:

```text
ambil hasil
   ↓
parameter expansion flag (f)
   ↓
split berdasarkan newline
```

Ini adalah contoh bagus bagaimana Zsh menggabungkan beberapa mekanisme native tanpa harus menggunakan:

```text
cat
while read
sed
awk
```

untuk pekerjaan sederhana.

---

# 03.36 `(F)` — Join dengan Newline

Kebalikan konseptual `(f)` adalah:

```zsh
${(F)array}
```

`F` menggabungkan words/array menggunakan newline sebagai separator. Dokumentasi Zsh mendefinisikannya sebagai shorthand untuk join dengan `\n`. ([Zsh][1])

Mental model:

```text
(f)
──────
string
  ↓
split newline
  ↓
words


(F)
──────
words
  ↓
join newline
  ↓
string
```

Jadi:

```text
(f) → memecah
(F) → menggabungkan
```

Perhatikan bahwa `(f)` dan `(F)` **case-sensitive** dan memiliki fungsi berbeda.

---

# 03.37 `(j:string:)` — Join dengan Separator

Sekarang bentuk yang lebih umum:

```zsh
${(j:separator:)parameter}
```

Contoh:

```zsh
items=(one two three)
```

Kemudian secara konseptual:

```zsh
print -r -- "${(j:, :)items}"
```

hasil:

```text
one, two, three
```

Dokumentasi resmi mendefinisikan `j:string:` sebagai penggabungan words dari array menggunakan `string` sebagai separator. ([Zsh][1])

Perhatikan syntax-nya:

```text
(j:, :)
  │  │
  │  └── separator
  └───── flag
```

Delimiter setelah `j` adalah `:` dalam contoh tersebut.

Tetapi delimiter sebenarnya tidak harus selalu `:`. Zsh memungkinkan delimiter lain untuk beberapa flag dengan argumen.

---

# 03.38 `(s:string:)` — Split dengan Separator

Kebalikan dari `(j)`:

```zsh
${(s:separator:)parameter}
```

Misalnya:

```zsh
value="one,two,three"
```

Kita dapat membaginya menggunakan comma:

```zsh
print -r -- "${(s:,:)value}"
```

Mental model:

```text
one,two,three
      │
      │ (s:, :)
      ▼
one
two
three
```

Jadi:

```text
(s:...:)
→ split

(j:...:)
→ join
```

Ini merupakan pasangan konsep yang sangat penting.

---

# 03.39 `(s)` dan `(j)` sebagai Pasangan

Perhatikan transformasi:

```text
                STRING
                   │
             (s:,:)
                   ▼
          ┌────┬────┬────┐
          │one │two │three│
          └────┴────┴────┘
                   │
             (j:,:)
                   ▼
             one,two,three
```

Secara konseptual:

```zsh
${(s:,:)value}
```

melakukan:

```text
string → words
```

Sedangkan:

```zsh
${(j:,:)array}
```

melakukan:

```text
words → string
```

Ini akan menjadi sangat penting ketika kita masuk ke **Lesson 04 — Arrays & Data Manipulation**, tetapi untuk sekarang kita hanya memahami mekanisme expansion flag-nya.

---

# 03.40 `(q)` — Shell Quoting

Sekarang salah satu flag yang sangat berguna ketika membaca plugin:

```zsh
${(q)parameter}
```

`q` melakukan quoting terhadap karakter yang memiliki arti khusus bagi shell. Dokumentasi resmi menjelaskan bahwa hasilnya diberi escape sehingga dapat digunakan dengan aman ketika hasil tersebut akan diproses kembali sebagai shell input. ([Zsh][1])

Contoh:

```zsh
value='hello world'
```

Kemudian:

```zsh
print -r -- ${(q)value}
```

Secara konseptual menghasilkan bentuk yang aman untuk dibaca sebagai satu shell word, misalnya:

```text
hello\ world
```

Tujuan utamanya bukan membuat output "lebih cantik".

Tujuannya adalah:

```text
nilai
 ↓
(q)
 ↓
representasi yang di-quote
 ↓
aman diproses kembali sebagai shell syntax
```

---

# 03.41 `(Q)` — Remove Quoting

Kebalikan tertentu dari `(q)` adalah:

```zsh
${(Q)parameter}
```

`Q` menghapus satu level quoting dari hasil expansion. ([Zsh][1])

Mental model sederhananya:

```text
(q)
→ tambahkan/hasilkan quoting


(Q)
→ lepaskan satu level quoting
```

Tetapi jangan menganggap `(Q)` sebagai "unescape semua karakter".

Ia memiliki aturan khusus dalam sistem expansion Zsh.

Untuk tahap awal, cukup pahami pasangan:

```text
q → quote
Q → remove one level of quote
```

---

# 03.42 `(u)` dan `(l)` — Case Conversion

Sebelumnya kita sudah menggunakan:

```zsh
${name:u}
${name:l}
```

Dalam pembahasan expansion flags, Zsh juga memiliki flag case transformation seperti:

```zsh
${(U)name}
${(L)name}
```

Secara konseptual:

```text
(U) → uppercase
(L) → lowercase
```

Dokumentasi expansion Zsh mendefinisikan `L` dan `U` sebagai case modification flags. ([Zsh][1])

Perhatikan perbedaan bentuk:

```zsh
${name:u}
```

dan:

```zsh
${(U)name}
```

Keduanya berkaitan dengan transformasi case, tetapi berasal dari mekanisme modifier/flag yang berbeda.

Untuk sekarang jangan mencampurkannya secara sembarangan. Yang penting kamu mulai mengenali bahwa Zsh memiliki **dua lapisan syntax manipulasi parameter**:

```text
${parameter:modifier}
        │
        └── parameter modifier

${(flag)parameter}
        │
        └── expansion flag
```

Kita akan menyatukan konsep ini setelah semua komponen utama selesai.

---

# 03.43 `(P)` — Indirect Parameter Expansion

Ini salah satu flag yang lebih maju:

```zsh
${(P)name}
```

Misalnya:

```zsh
foo="bar"
bar="hello"
```

Kemudian:

```zsh
print "${(P)foo}"
```

hasilnya:

```text
hello
```

Mengapa?

Tanpa `(P)`:

```text
foo
 ↓
bar
```

Dengan `(P)`:

```text
foo
 ↓
bar
 ↓
nilai parameter bar
 ↓
hello
```

Dokumentasi resmi menjelaskan `(P)` sebagai mekanisme yang membuat nilai parameter diperlakukan sebagai **nama parameter berikutnya**, lalu nilai parameter tersebut digunakan. ([Zsh][1])

Mental model:

```text
foo="bar"
bar="hello"

${foo}
   ↓
bar


${(P)foo}
   ↓
foo → bar → hello
```

Ini adalah **indirect parameter expansion**.

Kita tidak perlu menggunakannya dalam scripting sehari-hari, tetapi sangat penting untuk dikenali ketika membaca framework/plugin yang lebih kompleks.

---

# 03.44 `(V)` — Make Special Characters Visible

Zsh juga memiliki:

```zsh
${(V)parameter}
```

`V` membuat karakter khusus dalam hasil expansion menjadi terlihat. Dokumentasi resmi memasukkannya sebagai flag untuk membuat special characters visible. ([Zsh][1])

Ini terutama berguna untuk debugging.

Mental model:

```text
nilai sebenarnya
    ↓
(V)
    ↓
representasi yang memperlihatkan
karakter khusus
```

Misalnya ketika kamu sedang mencoba memahami apakah sebuah string mengandung:

```text
newline
tab
escape
```

flag semacam ini dapat membantu inspeksi.

---

# 03.45 Jangan Menghafalkan Semua Flag

Pada titik ini daftar flag mulai terlihat panjang:

```text
(f)
(F)

(s:...:)
(j:...:)

(q)
(Q)

(U)
(L)

(P)
(V)
```

Jangan mencoba menghafalkan semuanya sekarang.

Kelompokkan berdasarkan fungsi:

```text
SPLITTING / JOINING
├── (f)       split newline
├── (s:...:)  split separator
├── (F)       join newline
└── (j:...:)  join separator

QUOTING
├── (q)       quote
└── (Q)       remove quoting

CASE
├── (U)       uppercase
└── (L)       lowercase

INDIRECTION
└── (P)       parameter indirection

DEBUGGING / DISPLAY
└── (V)       visible special characters
```

Dengan model ini, syntax:

```zsh
${(s:,:)value}
```

tidak lagi terlihat seperti simbol acak.

Kamu membacanya:

```text
${ ... }
   │
   └── expansion
       │
       ├── s
       │   └── split
       │
       └── separator = ,
```

---

# 03.46 Urutan Expansion

Ini bagian yang sangat penting untuk memahami mengapa kombinasi flags kadang menghasilkan sesuatu yang tidak langsung intuitif.

Zsh tidak sekadar melihat:

```zsh
${(flags)parameter}
```

lalu melakukan semuanya secara acak.

Expansion memiliki tahapan pemrosesan. Dokumentasi Zsh menjelaskan bahwa splitting, joining, case modification, quoting, dan operasi lain terjadi pada tahap-tahap tertentu. ([Zsh][1])

Mental model sederhananya:

```text
parameter
   ↓
parameter expansion
   ↓
modifier / transformation
   ↓
joining / splitting
   ↓
case modification
   ↓
quoting
   ↓
hasil
```

Urutan persisnya lebih kompleks daripada diagram ini, tetapi konsep terpentingnya:

> **Urutan operasi expansion memengaruhi hasil.**

Karena itu:

```zsh
${(j:,:)value}
```

dan:

```zsh
${(s:,:)value}
```

bukan sekadar dua syntax yang melakukan hal berlawanan secara tekstual. Mereka bekerja pada tahap expansion yang berbeda.

---

# 03.47 Contoh Gabungan

Misalnya:

```zsh
value="one,two,three"
```

Kita ingin:

```text
one
two
three
```

Gunakan:

```zsh
${(s:,:)value}
```

Kemudian kita dapat menggabungkannya lagi dengan separator lain.

Secara konsep:

```text
one,two,three
       │
       │ (s:,:)
       ▼
one two three
       │
       │ (j:|:)
       ▼
one|two|three
```

Jadi:

```text
STRING
  │
  ├── split
  │
  ▼
WORDS
  │
  ├── join
  │
  ▼
STRING BARU
```

Ini merupakan dasar penting untuk manipulasi data di Zsh.

---

## Posisi kurikulum setelah bagian ini

Saya kembali mencocokkan posisi kita dengan daftar kurikulum, sehingga kita **tetap berada di Lesson 03**:

```text
03 — Parameter Expansion
│
├── ✓ Konsep parameter expansion
├── ✓ Basic parameter expansion
├── ✓ Default values
├── ✓ Prefix / suffix removal
├── ✓ Substring
├── ✓ Pattern replacement
├── ✓ Case modification
├── ✓ Expansion flags ← kita di sini
│
├── → Nested expansion
└── → Parameter modifiers
```

Jadi materi berikutnya masih **Lesson 03**, bukan Lesson 04.

Kita akan lanjut ke **nested parameter expansion**, lalu menyelesaikan **parameter modifiers**. Setelah seluruh Lesson 03 selesai, barulah sesuai kurikulum kita pindah ke **Lesson 04 — Arrays & Data Manipulation**.

[1]: https://zsh.sourceforge.io/Doc/Release/Expansion.html?utm_source=chatgpt.com "14 Expansion (zsh)"
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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

