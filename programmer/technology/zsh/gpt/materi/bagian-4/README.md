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

Kita akan lanjut ke **nested parameter expansion**, lalu menyelesaikan **parameter modifiers**.

## 03.9 — Nested Parameter Expansion

### 1. Apa itu nested expansion?

Nested parameter expansion adalah parameter expansion yang berada di dalam parameter expansion lainnya.

Contoh sederhana:

Zsh

```
name="amir"
print -r -- "${${name}}"
```

Hasil:

```
amir
```

Pada contoh tersebut:

1. `${name}` mengambil nilai parameter `name`.

2. Ekspansi bagian dalam selesai.

3. Ekspansi bagian luar memproses hasilnya.

Untuk kasus sederhana ini, bentuk bertingkat tersebut tidak memberi keuntungan dibandingkan `${name}`. Tujuannya adalah memahami bahwa sebuah ekspansi dapat menjadi bagian dari ekspansi lain.

### 2. Mengapa nested expansion berguna?

Nested expansion mulai berguna ketika hasil satu ekspansi perlu diproses oleh ekspansi lain.

Misalnya:

Zsh

```
filename="/home/user/archive.tar.gz"

base="${${filename:t}:r}"

print -r -- "$base"
```

Hasil yang diharapkan:

```
archive.tar
```

Kita perlu memahami dua modifier yang dipakai di sini:

* `:t` mengambil komponen terakhir dari sebuah path—mirip nama berkasnya.

* `:r` menghapus akhiran yang dianggap sebagai ekstensi terakhir.

Alurnya:

```
filename
   │
   ▼
${filename:t}
   │
   │  archive.tar.gz
   ▼
${...:r}
   │
   ▼
archive.tar
```

Perhatikan bahwa ini bukan manipulasi regex. Kita sedang menggabungkan dua operasi ekspansi Zsh.

Catatan: modifier `:t` dan `:r` diperkenalkan di sini agar kita bisa memahami nested expansion. Pembahasan sistematis tentang modifier akan dilakukan pada submateri berikutnya.

### 3. Cara yang lebih ringkas: beberapa modifier sekaligus

Untuk contoh path tadi, Zsh juga menyediakan bentuk yang lebih ringkas:

Zsh

```
filename="/home/user/archive.tar.gz"

print -r -- "${filename:t:r}"
```

Hasil:

```
archive.tar
```

Bentuk `${filename:t:r}` menerapkan dua modifier secara berurutan pada nilai parameter yang sama. Jadi, nested expansion tidak selalu diperlukan hanya untuk menggabungkan operasi.

Perbandingannya:

Zsh

```
# Nested expansion
print -r -- "${${filename:t}:r}"

# Beberapa modifier pada satu ekspansi
print -r -- "${filename:t:r}"
```

Keduanya menghasilkan `archive.tar`. Bentuk kedua lebih sederhana untuk kasus ini. Dokumentasi resmi Zsh juga menjelaskan bahwa operasi bertingkat diproses dari bagian terdalam ke bagian terluar.

![](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

+1

### 4. Nested expansion untuk menghapus awalan dan akhiran

Kita juga bisa menggunakan operator yang sudah dipelajari sebelumnya:

Zsh

```
value="prefix-content-suffix"

print -r -- "${${value#prefix-}%-suffix}"
```

Hasil:

```
content
```

Urutan prosesnya:

1. `${value#prefix-}` menghapus awalan `prefix-` yang cocok dengan pola terpendek.

2. Hasilnya menjadi `content-suffix`.

3. `%-suffix` menghapus akhiran `-suffix` yang cocok dengan pola terpendek.

4. Hasil akhir adalah `content`.

Ini menggabungkan dua konsep yang sudah dipelajari: prefix/suffix removal dan nested expansion. Tidak ada variabel perantara yang perlu dibuat.

Dokumentasi resmi memberikan pola yang sama melalui contoh `${${foo#head}%tail}`.

![](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

### 5. Nested expansion dan indirect expansion berbeda

Jangan menyamakan dua mekanisme ini.

Zsh

```
name="amir"

print -r -- "${${name}}"
```

Hasil:

```
amir
```

Di sini, ekspansi bagian dalam menghasilkan nilai `amir`, lalu ekspansi luar memproses nilai tersebut.

Sekarang bandingkan dengan indirect expansion yang menggunakan flag `(P)`:

Zsh

```
target="message"
message="Halo dari Zsh"

print -r -- "${(P)target}"
```

Hasil:

```
Halo dari Zsh
```

Mekanismenya berbeda:

* `${${name}}` memproses nilai ekspansi yang bersarang.

* `${(P)target}` memperlakukan nilai `target` sebagai nama parameter lain, kemudian mengambil nilai parameter yang namanya ditemukan.

Flag `(P)` sudah kita kenal dari submateri expansion flags. Kita tidak perlu mempelajari ulang flag tersebut sekarang. Contoh ini hanya menunjukkan hubungannya dengan nested expansion.

![](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

Untuk saat ini, pahami tiga pola utama:

| Pola                         | Kegunaan                                                |
| ---------------------------- | ------------------------------------------------------- |
| `${${value#prefix}%-suffix}` | Menggabungkan operasi ekspansi bertingkat               |
| `${value:t:r}`               | Menerapkan beberapa modifier secara berurutan           |
| `${(P)name}`                 | Menggunakan nilai parameter sebagai nama parameter lain |

Array belum kita bahas secara mendalam. Walaupun nested expansion menjadi lebih menarik ketika memproses array, materi itu tetap berada di Lesson 04 — Arrays & Data Manipulation.

## 03.10 — Parameter Modifiers

Expansion flags seperti `(q)` dan `(U)` sudah kita pelajari. Sekarang kita bedakan flag tersebut dari modifier yang ditulis menggunakan titik dua (`:`).

Bentuk umum:

Zsh

```
${parameter:modifier}
```

Beberapa modifier bisa dirangkai:

Zsh

```
${parameter:modifier1:modifier2}
```

Modifier mengolah hasil parameter expansion, misalnya untuk mengambil bagian path, mengubah huruf, atau mengganti teks. Daftar dan aturan lengkapnya tersedia di dokumentasi resmi Zsh bagian Modifiers in History Expansion dan Parameter Expansion.

![](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

### 1. Modifier untuk path dan nama berkas

Gunakan satu nilai berikut untuk menguji contoh:

Zsh

```
file="/home/amir/archive.tar.gz"
```

| Ekspresi    | Hasil                    | Fungsi                             |
| ----------- | ------------------------ | ---------------------------------- |
| `${file:h}` | `/home/amir`             | Mengambil bagian direktori (head)  |
| `${file:t}` | `archive.tar.gz`         | Mengambil komponen terakhir (tail) |
| `${file:r}` | `/home/amir/archive.tar` | Menghapus ekstensi terakhir        |
| `${file:e}` | `gz`                     | Mengambil ekstensi terakhir        |

Contoh:

Zsh

```
file="/home/amir/archive.tar.gz"

print -r -- "${file:h}"
print -r -- "${file:t}"
print -r -- "${file:r}"
print -r -- "${file:e}"
```

Perhatikan perbedaan `:r` dan `:e`. Untuk nama `archive.tar.gz`, `:r` menghasilkan `archive.tar`, sedangkan `:e` menghasilkan `gz`.

Modifier ini berguna ketika menulis fungsi Zsh yang mengolah path tanpa harus menjalankan program eksternal seperti `basename` atau `dirname`.

### 2. Modifier untuk huruf besar dan kecil

Zsh

```
word="Belajar Zsh"

print -r -- "${word:l}"
print -r -- "${word:u}"
```

Hasil:

```
belajar zsh
BELAJAR ZSH
```

* `:l` mengubah hasil menjadi huruf kecil.

* `:u` mengubah hasil menjadi huruf besar.

Ini mirip dengan flag `(L)` dan `(U)` yang telah kita pelajari, tetapi penulisannya berbeda:

Zsh

```
print -r -- "${word:u}"    # Modifier
print -r -- "${(U)word}"   # Expansion flag
```

Keduanya dapat menghasilkan huruf besar. Jangan menganggap semua modifier dan flag saling dapat dipertukarkan; masing-masing memiliki aturan dan fungsi tersendiri.

### 3. Modifier untuk quoting

Modifier `:q` melakukan quoting terhadap hasil ekspansi agar karakter khusus shell terlindungi saat teks tersebut dievaluasi oleh shell.

Zsh

```
value='file with spaces/$HOME'

print -r -- "${value:q}"
```

Outputnya akan menampilkan bentuk teks yang telah di-quote, bukan sekadar nilai mentahnya. Detail karakter escape bergantung pada isi nilai.

Perlu diingat: `:q` bukan mekanisme untuk membuat teks arbitrer aman dieksekusi. Quoting saja tidak menjadikan penggunaan `eval` aman. Dalam scripting biasa, lebih baik hindari `eval` apabila tidak diperlukan.

Kita sebelumnya juga mempelajari flag `${(q)value}`. Keduanya berhubungan dengan quoting, tetapi satu menggunakan modifier `:q` dan satu lagi menggunakan flag `(q)`.

### 4. Modifier untuk mengganti teks

Modifier `:s` dapat mengganti kemunculan pertama teks yang cocok. Berbeda dengan operator `${parameter/pattern/replacement}` yang telah dipelajari sebelumnya, modifier `:s` secara default memperlakukan sisi pencarian sebagai teks literal, bukan pola shell.

Zsh

```
text="zsh-config-zsh"

print -r -- "${text:s/zsh/bash/}"
```

Hasil:

```
bash-config-zsh
```

Hanya kemunculan pertama yang diganti.

Untuk mengganti semua kemunculan, gunakan bentuk global modifier:

Zsh

```
print -r -- "${text:gs/zsh/bash/}"
```

Hasil:

```
bash-config-bash
```

Perhatikan perbedaan sintaksnya:

Zsh

```
# Operator parameter expansion
${text//zsh/bash}

# Modifier
${text:gs/zsh/bash/}
```

Keduanya dapat mengganti semua kemunculan, tetapi sintaks dan aturan pencocokannya berbeda. Jangan mencampuradukkan keduanya ketika membaca konfigurasi atau plugin Zsh.

![](https://www.google.com/s2/favicons?domain=https://zsh.sourceforge.io\&sz=32)

zsh.sourceforge.io

## Ringkasan Lesson 03 sejauh ini

Sudah dipelajari

Parameter dasar, default values, prefix/suffix removal, substring, pattern replacement, case modification, expansion flags, nested expansion, dan parameter modifiers.

Berikutnya

Latihan terpadu Lesson 03 untuk menguji pemahaman dan menemukan bagian yang masih perlu diperbaiki.

---

<details>
  <summary>
    <strong>📝 Latihan terpadu Lesson 03</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Uji Pemahaman</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

---

Jangan langsung menjalankan kode untuk mencari hasilnya. Prediksi hasil setiap ekspresi terlebih dahulu, kemudian verifikasi dengan Zsh.

<h3 id="satu"></h3>

### [Soal 1](#satuu)

```bash
file="/home/amir/archive.tar.gz" print -r -- "${file:t:r}"
```

Terapkan `:t` terlebih dahulu, lalu `:r`.

<h3 id="dua"></h3>

### [Soal 2](#duaa)

```bash
value="prefix-data-suffix" print -r -- "${${value#prefix-}%-suffix}"
```

Hapus awalan, kemudian hapus akhiran.

<h3 id="tiga"></h3>

### [Soal 3](#tigaa)

```bash
text="zsh-config-zsh" print -r -- "${text:gs/zsh/bash/}"
```

Modifier gs mengganti semua kemunculan teks literal.

<h3 id="empat"></h3>

### [Soal 4](#empaat)

```bash
name="message" message="Halo Zsh" print -r -- "${(P)name}"
```

Flag `(P)` memakai nilai name sebagai nama parameter lain.

<h3 id="lima"></h3>

### [Soal 5](#limaa)

```bash
word="Belajar Zsh" print -r -- "${word:u}"
```

`:u` mengubah huruf menjadi kapital.


---

#### Untuk benar-benar menguji pemahaman, jangan melihat kunci jawaban berikut, prediksi output setiap soal sendiri, lalu jalankan contoh-contohnya di Zsh untuk memverifikasi hasil. Setelah selesai, barulah lihat semua jawaban dibawah ini:

---

## Evaluasi latihan Lesson 03 — Parameter Expansion

<h3 id="satuu"></h3>

### [Soal 1 — Modifier path](#satu)

Zsh

```bash
file="/home/amir/archive.tar.gz"
print -r -- "${file:t:r}"
```

Jawaban: `archive.tar`

Penjelasan:

* `:t` mengambil komponen terakhir dari path, yaitu `archive.tar.gz`.

* `:r` menghapus ekstensi terakhir, yaitu `.gz`.

* Hasil akhirnya `archive.tar`.

Konsep yang diuji: menggabungkan beberapa parameter modifier dalam satu ekspansi.

<h3 id="duaa"></h3>

### [Soal 2 — Nested expansion](#dua)

Zsh

```bash
value="prefix-data-suffix"
print -r -- "${${value#prefix-}%-suffix}"
```

Jawaban: `data`

Prosesnya:

1. `${value#prefix-}` menghapus awalan `prefix-`, menghasilkan `data-suffix`.

2. Ekspansi luar `${...%-suffix}` menghapus akhiran `-suffix`.

3. Hasil akhirnya `data`.

Konsep yang diuji: ekspansi bagian dalam diproses sebelum ekspansi bagian luar.

<h3 id="tigaa"></h3>

### [Soal 3 — Global substitution modifier](#tiga)

Zsh

```bash
text="zsh-config-zsh"
print -r -- "${text:gs/zsh/bash/}"
```

Jawaban: `bash-config-bash`

Penjelasan:

* `:s/pola/pengganti/` mengganti kemunculan pertama.

* `:gs/pola/pengganti/` mengganti semua kemunculan.

* Karena terdapat dua kemunculan `zsh`, keduanya menjadi `bash`.

Konsep yang diuji: perbedaan modifier penggantian pertama dan global.

<h3 id="empaat"></h3>

### [Soal 4 — Indirect parameter expansion](#empat)

Zsh

```bash
name="message"
message="Halo Zsh"
print -r -- "${(P)name}"
```

Jawaban: `Halo Zsh`

Penjelasan:

1. Nilai `name` adalah teks `message`.

2. Flag `(P)` menggunakan teks tersebut sebagai nama parameter lain.

3. Zsh mengambil nilai parameter `message`, yaitu `Halo Zsh`.

Perhatikan perbedaannya:

* `${name}` menghasilkan `message`.

* `${(P)name}` menghasilkan `Halo Zsh`.

Konsep yang diuji: penggunaan nilai parameter sebagai nama parameter lain.

<h3 id="limaa"></h3>

### [Soal 5 — Case modifier](#lima)

Zsh

```bash
word="Belajar Zsh"
print -r -- "${word:u}"
```

Jawaban: `BELAJAR ZSH`

Penjelasan:

Modifier `:u` mengubah huruf menjadi kapital. Kebalikannya, `:l`, mengubah huruf menjadi kecil.

Zsh

```
print -r -- "${word:u}"  # BELAJAR ZSH
print -r -- "${word:l}"  # belajar zsh
```

Konsep yang diuji: transformasi kapitalisasi melalui parameter modifier.

## Rekapitulasi

| No. | Materi                   | Jawaban acuan      |
| --- | ------------------------ | ------------------ |
| 1   | Path modifier            | `archive.tar`      |
| 2   | Nested expansion         | `data`             |
| 3   | Global substitution      | `bash-config-bash` |
| 4   | Indirect expansion `(P)` | `Halo Zsh`         |
| 5   | Case modifier `:u`       | `BELAJAR ZSH`      |


  </div>
</details>

- [Sumber]

[Sumber]: https://zsh.sourceforge.io/Doc/Release/Expansion.html?utm_source=chatgpt.com "14 Expansion (zsh)"

---

## 04 — Arrays & Data Manipulation

Bagian ini sesuai dengan tahap Zsh Foundation dalam dokumen Anda, yang secara eksplisit memasukkan arrays dan associative arrays. Kita akan membahas array biasa terlebih dahulu, kemudian operasi elemen, iterasi, associative arrays, dan penggunaannya dalam scripting. Kita belum masuk ke globbing, options, atau konfigurasi interaktif.

### 04.1 — Apa itu array?

Variabel biasa menyimpan satu nilai:

Zsh

```
name="Amir"
```

Array menyimpan beberapa elemen dalam satu parameter:

Zsh

```
names=(Amir Budi Citra)
```

Gambaran konseptual:

```
names
  │
  ├── elemen 1: Amir
  ├── elemen 2: Budi
  └── elemen 3: Citra
```

Array berguna ketika script perlu mengelola sekumpulan nilai, misalnya daftar paket yang akan dipasang, nama file, argumen perintah, atau daftar direktori.

### 04.2 — Membuat dan membaca array

Zsh

```
tools=(git fzf neovim yazi)

print -r -- "$tools[1]"
print -r -- "$tools[2]"
print -r -- "$tools[3]"
```

Output:

```
git
fzf
neovim
```

Perbedaan penting dari Bash: secara default, indeks array numerik Zsh dimulai dari 1, sedangkan array indeks Bash umumnya dimulai dari 0.

Jangan langsung membawa asumsi indeks Bash ke Zsh. Perbedaan ini sangat berpengaruh saat mengakses elemen, membuat loop, atau memodifikasi daftar.

### 04.3 — Mengakses elemen dan seluruh isi array

Untuk membuat kode lebih mudah dibaca, gunakan bentuk kurung kurawal:

Zsh

```
tools=(git fzf neovim yazi)

print -r -- "${tools[1]}"
print -r -- "${tools[4]}"
```

Hasil:

```
git
yazi
```

Untuk mengambil semua elemen:

Zsh

```
print -r -- "${tools[@]}"
```

Dalam Zsh, `${tools[@]}` mempertahankan elemen array sebagai kata-kata terpisah. Ini penting ketika elemen mengandung spasi.

Contoh:

Zsh

```
tools=("git" "GNU Stow" "neovim")

for tool in "${tools[@]}"; do
    print -r -- "$tool"
done
```

Output:

```
git
GNU Stow
neovim
```

Perhatikan bahwa `"GNU Stow"` tetap menjadi satu elemen. Kita tidak ingin nama tersebut terpecah menjadi dua kata.

### 04.4 — Menghitung jumlah elemen

Gunakan:

Zsh

```
tools=(git fzf neovim yazi)

print -r -- "${#tools}"
```

Hasil:

```
4
```

Pada array Zsh, `${#tools}` menghasilkan jumlah elemen array, bukan panjang karakter seluruh isi array.

Bandingkan dengan parameter string:

Zsh

```
name="Amir"

print -r -- "${#name}"
```

Hasil:

```
4
```

Untuk `name`, angka `4` berarti panjang string. Untuk `tools`, angka `4` berarti jumlah elemen. Makna ekspansi bergantung pada jenis parameter yang digunakan.

### 04.5 — Menambahkan dan mengubah elemen

Menambahkan elemen ke akhir array:

Zsh

```
tools=(git fzf)
tools+=(neovim)
tools+=(yazi)

print -r -- "${tools[@]}"
```

Hasilnya adalah tiga elemen:

```
git
fzf
neovim
yazi
```

Mengubah elemen tertentu:

Zsh

```
tools=(git fzf neovim)

tools[2]="ripgrep"

print -r -- "${tools[@]}"
```

Hasil:

```
git
ripgrep
neovim
```

Perhatikan bahwa `tools[2]="ripgrep"` mengganti elemen kedua, bukan menambahkan elemen baru.

### 04.6 — Menghapus elemen

Gunakan `unset` untuk menghapus elemen berdasarkan indeks:

Zsh

```
tools=(git fzf neovim yazi)

unset 'tools[2]'

print -r -- "${tools[@]}"
```

Hasil:

```
git
neovim
yazi
```

Tanda kutip pada `'tools[2]'` memastikan ekspresi indeks diberikan sebagai argumen literal kepada `unset`.

Untuk saat ini, cukup pahami bahwa penghapusan elemen berbeda dari mengganti nilainya. Kita akan membahas konsekuensi indeks dan operasi array yang lebih lanjut setelah dasar-dasar ini dikuasai.

---

<details>
  <summary>
    <strong>📝 Latihan 04.1</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Uji Pemahaman</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

---

Jalankan setiap potongan kode di Zsh. Sebelum menjalankannya, prediksi hasilnya.

Soal 1 — Indeks

Zsh

```
items=(alpha beta gamma)
print -r -- "${items[2]}"
```

Soal 2 — Jumlah elemen

Zsh

```
items=(git fzf yazi neovim)
print -r -- "${#items}"
```

Soal 3 — Menambahkan elemen

Zsh

```
items=(git fzf)
items+=(yazi)
print -r -- "${items[@]}"
```

Soal 4 — Elemen dengan spasi

Zsh

```
items=("GNU Stow" git)
for item in "${items[@]}"; do
    print -r -- "$item"
done
```

## Evaluasi jawaban

  </div>
</details>

---

Materi dasar array sebelumnya sudah mencakup deklarasi, indeks, membaca semua elemen, menghitung jumlah elemen, menambah, mengubah, dan menghapus elemen. Sekarang kita lanjutkan ke 04.7 — Array Slicing dan Rentang Indeks, belum masuk ke globbing atau options.

## 04.7 — Array Slicing

Array slicing adalah mengambil sebagian elemen dari array tanpa harus mengambil seluruh isinya.

Misalnya:

Zsh

```
tools=(git fzf neovim yazi ripgrep)
```

Representasi indeksnya:

```
Indeks:   1      2       3       4       5
         git    fzf   neovim   yazi   ripgrep
```

### 1. Mengambil rentang elemen

Gunakan bentuk subscript berikut:

Zsh

```
${array[start,end]}
```

Contoh:

Zsh

```
tools=(git fzf neovim yazi ripgrep)

print -r -- "${tools[2,4]}"
```

Output:

```
fzf
neovim
yazi
```

Artinya, ambil elemen dari indeks 2 sampai indeks 4, termasuk kedua batas tersebut.

### 2. Mengambil beberapa elemen pertama

Zsh

```
tools=(git fzf neovim yazi ripgrep)

print -r -- "${tools[1,3]}"
```

Output:

```
git
fzf
neovim
```

Ini berguna ketika script hanya membutuhkan sebagian awal daftar.

### 3. Mengambil elemen terakhir

Zsh mendukung indeks negatif untuk mengakses elemen dari belakang:

Zsh

```
tools=(git fzf neovim yazi ripgrep)

print -r -- "${tools[-1]}"
print -r -- "${tools[-2]}"
```

Output:

```
ripgrep
yazi
```

Maknanya:

* `-1`: elemen terakhir.

* `-2`: elemen kedua dari belakang.

Indeks negatif berguna ketika panjang array berubah-ubah dan Anda tidak ingin menghitung jumlah elemennya terlebih dahulu.

### 4. Mengambil rentang dari belakang

Zsh

```
tools=(git fzf neovim yazi ripgrep)

print -r -- "${tools[-3,-1]}"
```

Output:

```
neovim
yazi
ripgrep
```

Ekspresi tersebut mengambil tiga elemen terakhir dalam urutan aslinya.

## 04.8 — Memahami array dan ekspansi

Slicing berhubungan langsung dengan parameter expansion yang telah dipelajari pada Lesson 03. Namun, ketika parameternya berupa array, hasilnya dapat terdiri dari beberapa elemen.

Perhatikan perbedaan berikut:

Zsh

```
tools=(git "GNU Stow" neovim)

print -r -- "${tools[2]}"
print -r -- "${tools[@]}"
```

Perintah pertama mengambil satu elemen:

```
GNU Stow
```

Perintah kedua mengambil seluruh elemen array. Dalam konteks perintah yang menerima argumen, `"${tools[@]}"` mempertahankan setiap elemen sebagai argumen tersendiri, termasuk elemen yang berisi spasi.

Konsep ini sangat penting untuk scripting. Misalnya, saat meneruskan daftar argumen ke perintah lain, kita ingin setiap elemen tetap terpisah dengan benar.

Contoh:

Zsh

```
tools=(git "GNU Stow" neovim)

printf '<%s>\n' "${tools[@]}"
```

Output:

```
<git>
<GNU Stow>
<neovim>
```

Kurung sudut pada output membantu memperlihatkan batas setiap argumen.

---

<details>
  <summary>
    <strong>📝 Latihan 04.2</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Uji Pemahaman</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

---

Prediksi output berikut sebelum menjalankannya.

Soal 1 — Rentang indeks

Zsh

```
items=(alpha beta gamma delta epsilon)
print -r -- "${items[2,4]}"
```

Soal 2 — Indeks negatif

Zsh

```
items=(alpha beta gamma delta epsilon)
print -r -- "${items[-2]}"
```

Soal 3 — Mempertahankan elemen yang mengandung spasi

Zsh

```
items=("GNU Stow" git neovim)
printf '<%s>\n' "${items[@]:1:2}"
```

  </div>
</details>


Submateri berikutnya adalah associative arrays, yaitu array yang menggunakan kunci teks untuk menyimpan dan mengambil nilai.

# 04.9 — Associative Arrays

## 1. Mengapa associative array diperlukan?

Array biasa menggunakan indeks numerik:

Zsh

```
tools=(git fzf neovim)

print -r -- "${tools[1]}"
```

Output:

```
git
```

Anda harus mengetahui indeks untuk mengambil elemen. Namun, jika data memiliki nama atau kategori, kunci teks bisa lebih mudah dipahami.

Misalnya, kita ingin menyimpan informasi tentang beberapa program:

```
editor  → neovim
search  → fzf
files   → yazi
```

Associative array memungkinkan kita mengambil nilai menggunakan kunci seperti `editor`, bukan angka `1`.

## 2. Membuat associative array

Dalam Zsh, gunakan `typeset -A` untuk mendeklarasikan associative array.

Zsh

```
typeset -A tools

tools=(
    editor neovim
    search fzf
    files  yazi
)
```

Penjelasan:

* `typeset` adalah builtin Zsh untuk mendeklarasikan atau mengatur atribut parameter.

* `-A` menetapkan parameter sebagai associative array.

* `tools` adalah nama array.

* Setiap kunci dipasangkan dengan sebuah nilai.

Susunan tersebut merupakan pasangan kunci–nilai (key–value pairs).

## 3. Mengakses nilai berdasarkan kunci

Gunakan kunci di dalam subscript:

Zsh

```
print -r -- "${tools[editor]}"
print -r -- "${tools[search]}"
print -r -- "${tools[files]}"
```

Output:

```
neovim
fzf
yazi
```

Perhatikan perbedaan berikut:

Zsh

```
# Array numerik
print -r -- "${tools[1]}"

# Associative array
print -r -- "${tools[editor]}"
```

Pada array numerik, `1` berarti indeks pertama. Pada associative array, `editor` adalah kunci yang dicari.

Jangan menggunakan nama array yang sama untuk kedua contoh sekaligus dalam satu shell karena keduanya memiliki jenis deklarasi berbeda. Contoh di atas hanya untuk membandingkan sintaksnya.

## 4. Menambah dan memperbarui nilai

Anda bisa menambahkan pasangan kunci–nilai setelah deklarasi:

Zsh

```
typeset -A tools

tools=(
    editor neovim
    search fzf
)

tools[files]=yazi
tools[terminal]=foot
```

Jika kunci sudah ada, pemberian nilai baru akan memperbarui nilai tersebut:

Zsh

```
tools[editor]=helix

print -r -- "${tools[editor]}"
```

Output:

```
helix
```

Jadi, penugasan pada kunci yang sudah ada tidak membuat kunci baru; nilai yang tersimpan pada kunci tersebut diganti.

## 5. Mengambil semua kunci dan semua nilai

Untuk mengambil semua kunci, gunakan ekspansi `(k)`:

Zsh

```
print -r -- "${(k)tools}"
```

Untuk mengambil semua nilai, gunakan ekspansi `(v)`:

Zsh

```
print -r -- "${(v)tools}"
```

Di sini `(k)` berarti keys, sedangkan `(v)` berarti values.

Urutan keluaran associative array tidak boleh diasumsikan sebagai urutan deklarasi. Jika program memerlukan urutan tertentu, urutkan kuncinya secara eksplisit atau simpan urutan tersebut di array numerik terpisah.

## 6. Memeriksa apakah suatu kunci tersedia

Gunakan operator pemeriksaan parameter `${+...}`:

Zsh

```
if (( ${+tools[editor]} )); then
    print -r -- "Kunci editor tersedia"
else
    print -r -- "Kunci editor tidak tersedia"
fi
```

`1` berarti parameter atau elemen dengan kunci tersebut tersedia; `0` berarti tidak tersedia.

Pemeriksaan ini berbeda dari sekadar mengecek apakah nilainya tidak kosong. Sebuah kunci bisa tersedia meskipun nilainya berupa string kosong.

## 7. Menghapus satu kunci

Gunakan `unset` dengan ekspresi kunci yang dikutip:

Zsh

```
unset 'tools[search]'
```

Setelah itu, kunci `search` tidak lagi menjadi bagian dari associative array.

Mengutip ekspresi tersebut membantu memastikan sintaks subscript diteruskan secara utuh ke `unset`.

---

<details>
  <summary>
    <strong>📝 Latihan 04.3</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Kumpulan Jawaban</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

---

Tuliskan prediksi output atau jelaskan perilaku setiap potongan kode berikut.

Soal 1 — Mengakses nilai

Zsh

```
typeset -A apps
apps=(editor neovim terminal foot)
print -r -- "${apps[terminal]}"
```

Soal 2 — Memperbarui nilai

Zsh

```
typeset -A apps
apps=(editor neovim)
apps[editor]=helix
print -r -- "${apps[editor]}"
```

Soal 3 — Memeriksa kunci

Zsh

```
typeset -A apps
apps=(editor neovim)
if (( ${+apps[terminal]} )); then
    print -r -- "ada"
else
    print -r -- "tidak ada"
fi
```

  </div>
</details>

Setelah associative arrays, kita akan menuntaskan operasi dan pemrosesan data array yang diperlukan, sebelum berpindah ke Lesson 05 — Glob / Filename Generation.

## 04.10 — Iterasi array

Iterasi berarti mengunjungi setiap elemen array secara berurutan, biasanya menggunakan `for`.

Zsh

```
tools=(git fzf neovim yazi)

for tool in "${tools[@]}"; do
    print -r -- "$tool"
done
```

Output:

```
git
fzf
neovim
yazi
```

Mekanismenya:

1. `"${tools[@]}"` menghasilkan elemen array sebagai kata-kata terpisah.

2. `for tool in ...` mengambil setiap elemen secara bergantian.

3. Variabel `tool` berisi elemen yang sedang diproses.

4. `print -r -- "$tool"` mencetak nilainya tanpa interpretasi tambahan terhadap backslash.

Mengapa ekspansi array dikutip? Karena sebuah elemen bisa mengandung spasi.

Zsh

```
tools=("GNU Stow" git neovim)

for tool in "${tools[@]}"; do
    print -r -- "$tool"
done
```

Output tetap terdiri dari tiga elemen, bukan empat kata terpisah.

## 04.11 — Memproses associative array

Associative array juga dapat diproses menggunakan `for`, tetapi kita perlu memilih apakah akan mengiterasi kunci atau nilai.

Zsh

```
typeset -A apps

apps=(
    editor neovim
    search fzf
    files  yazi
)

for key in "${(k)apps}"; do
    print -r -- "$key"
done
```

`(k)` meminta kunci-kunci associative array.

Jika kita ingin mengambil nilai berdasarkan setiap kunci:

Zsh

```
for key in "${(k)apps}"; do
    print -r -- "$key: ${apps[$key]}"
done
```

Contoh hasil:

```
editor: neovim
search: fzf
files: yazi
```

Urutan kunci tidak dijamin. Jika urutan tertentu penting, jangan bergantung pada urutan iterasi associative array.

## 04.12 — Membuat array dari hasil perintah

Anda mungkin ingin menyimpan hasil suatu perintah ke dalam array. Di Zsh, ada perbedaan penting antara command substitution biasa dan menangkap baris keluaran sebagai elemen array.

Misalnya:

Zsh

```
output=$(print -r -- $'git\nfzf\nyazi')
```

`output` adalah parameter scalar yang menyimpan teks, termasuk baris baru.

Untuk memecah teks berdasarkan baris menjadi elemen array, gunakan flag ekspansi `(f)`:

Zsh

```
output=$(print -r -- $'git\nfzf\nyazi')
items=("${(@f)output}")

print -r -- "${items[1]}"
print -r -- "${items[2]}"
print -r -- "${items[3]}"
```

Output:

```
git
fzf
yazi
```

Penjelasan dua flag:

* `(f)` memecah teks berdasarkan karakter baris baru.

* `(@)` mempertahankan hasil ekspansi array sebagai elemen-elemen terpisah ketika ekspansi dikutip.

Teknik ini berguna untuk mengolah keluaran perintah yang memang menghasilkan satu item per baris. Namun, jangan menggunakannya untuk keluaran arbitrer yang mungkin mengandung baris baru di dalam nama atau data sebuah item.

## 04.13 — Ringkasan konsep array

| Kebutuhan                         | Sintaks                    |
| --------------------------------- | -------------------------- |
| Membuat array numerik             | `items=(alpha beta gamma)` |
| Mengakses elemen                  | `${items[1]}`              |
| Mengambil rentang indeks          | `${items[2,3]}`            |
| Mengakses dari belakang           | `${items[-1]}`             |
| Menghitung jumlah elemen          | `${#items}`                |
| Mengambil seluruh elemen          | `"${items[@]}"`            |
| Menambah elemen                   | `items+=(delta)`           |
| Mengubah elemen                   | `items[2]=new_value`       |
| Menghapus elemen                  | `unset 'items[2]'`         |
| Mendeklarasikan associative array | `typeset -A data`          |
| Mengambil kunci associative array | `${(k)data}`               |
| Mengambil nilai associative array | `${(v)data}`               |
| Memeriksa keberadaan kunci        | `${+data[key]}`            |

Perlu dibedakan bahwa `${items[2,3]}` adalah bentuk subscript Zsh untuk mengambil rentang indeks, sedangkan ekspansi seperti `${items[@]:offset:length}` memiliki aturan tersendiri. Untuk sekarang, prioritaskan bentuk subscript Zsh yang sudah dipelajari.

## Latihan penutup Lesson 04

Buat sebuah script Zsh yang melakukan hal-hal berikut:

- 1. Menyimpan `git`, `fzf`, dan `yazi` dalam array numerik bernama `tools`.

- 2. Menambahkan `neovim` ke array tersebut.

- 3. Mencetak jumlah elemennya.

- 4. Mengiterasi seluruh elemen dan mencetak setiap nama program.

- 5. Membuat associative array bernama `commands` yang memetakan `editor` ke `neovim` dan `files` ke `yazi`.

- 6. Mencetak nilai yang terkait dengan kunci `editor`.

Kerjakan sendiri terlebih dahulu. Tujuannya adalah menggabungkan konsep, bukan sekadar menghafal sintaks.

Setelah array numerik, slicing, associative array, dan iterasi dasar ini, kita siap berpindah ke Lesson 05 — Glob / Filename Generation, yaitu mekanisme khas Zsh untuk mencocokkan nama file dan direktori.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Daftar Teknologi][tekno]**
> - **[Home]**

[tekno]: ../../../../../README.md
[Home]: ./../../../../../../README.md
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

