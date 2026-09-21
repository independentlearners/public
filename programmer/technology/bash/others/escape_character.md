# Escaped character

<details>
  <summary>
    <strong>⌨️ Gpt</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Model Standar.</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">


Dalam konteks **Bash, shell, dan pemrograman**, **escape character** adalah karakter yang digunakan untuk memberi tahu shell atau program bahwa karakter setelahnya harus diperlakukan dengan **makna khusus** atau **tidak diperlakukan sebagai sintaks biasa**.

Karakter escape yang paling umum adalah:

```text
\
```

Namanya **backslash**.

### 1. Konsep paling dasar

Misalnya Bash melihat:

```bash
echo "Halo"
```

Bash memahami `"` sebagai bagian dari aturan sintaks string.

Tetapi jika kita ingin mencetak tanda kutip sebagai **karakter biasa**, kita bisa melakukan escaping:

```bash
echo "\"Halo\""
```

Hasil:

```text
"Halo"
```

Di sini:

```text
\"
```

berarti:

> Perlakukan `"` sebagai karakter literal, bukan sebagai penutup string.

---

### 2. Mengapa disebut "escape"?

Kata **escape** secara konsep berarti:

> "Keluar dari interpretasi normal karakter tersebut."

Contoh:

```bash
echo "A \"B\" C"
```

Tanpa escape:

```text
"
```

mempunyai fungsi sintaksis.

Dengan:

```text
\"
```

karakter `"` "keluar" dari fungsi sintaksisnya dan menjadi karakter literal.

Secara konseptual:

```text
Normal:
"  → sintaks string

Escaped:
\" → karakter "
```

---

### 3. Escape bukan hanya untuk `"`

Dalam Bash, backslash dapat digunakan untuk berbagai karakter.

Contoh:

```bash
echo "Halo\nDunia"
```

Perlu diperhatikan: dalam double quote Bash biasa, `\n` **tidak otomatis menjadi newline**.

Untuk mendapatkan escape sequence seperti `\n`, salah satu cara adalah:

```bash
printf "Halo\nDunia\n"
```

Hasil:

```text
Halo
Dunia
```

Di sini:

```text
\n
```

adalah **escape sequence**, bukan sekadar escape character.

Perbedaannya penting:

```text
\       → escape character
\n      → escape sequence
\t      → escape sequence
\"      → escape sequence
\\      → escape sequence
```

---

### 4. Beberapa escape sequence penting

Dalam Bash `printf`:

| Sequence | Makna                              |
| -------- | ---------------------------------- |
| `\n`     | newline                            |
| `\t`     | tab                                |
| `\\`     | karakter `\`                       |
| `\"`     | karakter `"`                       |
| `\'`     | karakter `'` pada konteks tertentu |
| `\a`     | bell                               |
| `\b`     | backspace                          |
| `\r`     | carriage return                    |
| `\0`     | karakter NUL                       |

Contoh:

```bash
printf "Nama:\tCendekiawan\nUmur:\t20\n"
```

Hasil kira-kira:

```text
Nama:   Cendekiawan
Umur:   20
```

---

### 5. Escape juga sangat penting dalam Bash syntax

Contoh:

```bash
echo hello\ world
```

Hasil:

```text
hello world
```

Mengapa?

Biasanya spasi digunakan Bash untuk memisahkan **word/token**:

```bash
echo hello world
```

Bash melihat:

```text
echo
hello
world
```

Tetapi:

```bash
echo hello\ world
```

backslash memberi tahu Bash:

> Spasi ini adalah bagian dari kata, bukan pemisah argumen.

Sehingga secara konseptual:

```text
hello\ world
     ↑
     spasi di-escape
```

dan `echo` menerima satu argumen:

```text
"hello world"
```

---

### 6. Contoh yang sangat penting untuk dotfiles

Misalnya nama file:

```text
my config.txt
```

Perintah ini bermasalah secara konsep:

```bash
cat my config.txt
```

Bash menganggapnya sebagai dua argumen:

```text
my
config.txt
```

Kita bisa menggunakan escape:

```bash
cat my\ config.txt
```

atau quoting:

```bash
cat "my config.txt"
```

Keduanya menghasilkan satu pathname:

```text
my config.txt
```

Tetapi secara konsep mekanismenya berbeda:

```text
my\ config.txt
   ↑
   escape terhadap spasi
```

sedangkan:

```bash
"my config.txt"
```

menggunakan **quoting**.

Ini salah satu konsep penting dalam Bash:

```text
Escape
  ↓
\
  ↓
mengubah cara karakter berikutnya diinterpretasikan


Quoting
  ↓
'...' / "..."
  ↓
mengubah aturan interpretasi sekumpulan karakter
```

---

### 7. Escape dan ANSI escape sequence

Dalam konfigurasi terminal, kamu juga akan sering melihat:

```bash
printf '\033[2J\033[H'
```

Ini berhubungan langsung dengan escape character.

Bagian:

```text
\033
```

merepresentasikan karakter **ESC (Escape)** ASCII.

Kemudian:

```text
\033[
```

menjadi awal dari **ANSI/terminal escape sequence**.

Contohnya:

```bash
printf '\033[2J'
```

digunakan untuk mengirim instruksi terminal tertentu.

Karena itu kamu sebelumnya melihat kode seperti:

```bash
printf "\033[2J\033[H"
```

Strukturnya:

```text
\033[2J
│  │
│  └── instruksi terminal
└───── ESC

\033[H
│  │
│  └── instruksi terminal
└───── ESC
```

Jadi jangan menyamakan:

```text
escape character
```

dengan:

```text
escape sequence
```

atau:

```text
ANSI escape sequence
```

Ketiganya berkaitan, tetapi bukan istilah yang identik.

### Inti yang perlu kamu pegang

```text
Escape character
        ↓
       \

fungsi umum:
"Jangan perlakukan karakter berikut dengan makna normalnya."

Contoh:
\"   → "
\    → \
\    + spasi → spasi literal
```

Sedangkan dalam terminal:

```text
ESC character
      ↓
    \033
      ↓
ANSI escape sequence
      ↓
mengirim instruksi kepada terminal
```

Untuk Bash scripting, memahami **escape → quoting → word splitting → expansion** adalah fondasi yang sangat penting. Keempat konsep ini saling berkaitan dan nantinya menjelaskan mengapa Bash bisa sangat sensitif terhadap `" "`, `' '`, `\`, `${...}`, `$()`, dan `$(...)`.
  </div>
</details>

<details>
  <summary>
    <strong>⌨️ Gemini</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Model Pro Mendalam.</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">


*Escape character* adalah sebuah karakter (hampir selalu berupa *backslash* atau garis miring terbalik `\`) yang memodifikasi interpretasi dari karakter yang mengikutinya. Karakter ini digunakan untuk dua tujuan utama: menyisipkan karakter yang tidak dapat diketik langsung (seperti baris baru atau tab) dan memerintahkan *interpreter* atau *compiler* untuk memperlakukan karakter khusus sebagai teks biasa (literal).

Berikut adalah dokumentasi komprehensif mengenai penggunaan *escape character* di berbagai lingkungan.

### 1. Escape Sequence Standar (C, Dart, Java, dll.)

Sebagian besar bahasa pemrograman modern mengadopsi standar *escape sequence* dari bahasa C.

* **`\n`** : *Newline* / Baris baru.
* **`\t`** : *Horizontal Tab*.
* **`\r`** : *Carriage Return* (sering dikombinasikan menjadi `\r\n` pada sistem Windows, atau menimpa baris saat ini di terminal).
* **`\\`** : *Backslash* literal (mencetak simbol `\`).
* **`\'`** : *Single quote* literal (berguna saat string diapit oleh tanda kutip tunggal).
* **`\"`** : *Double quote* literal (berguna saat string diapit oleh tanda kutip ganda).
* **`\0`** : *Null character* (menandai akhir dari sebuah string di memori pada beberapa bahasa).
* **`\b`** : *Backspace* (menghapus satu karakter sebelumnya di output terminal).
* **`\e` atau `\033**` : *Escape* (sangat sering digunakan dalam skrip Bash/TUI untuk kode warna ANSI).
* **`\uXXXX`** : Representasi karakter Unicode heksadesimal (misalnya `\u00A9` untuk simbol ©).

### 2. Implementasi di Shell / Bash Scripting

Dalam lingkungan *command-line* Unix/Linux, *escape character* mencegah *shell* menerjemahkan karakter meta (seperti spasi, wildcard, atau variabel).

* **Mencegah Ekspansi Variabel:**
Jika Anda memiliki string ganda `" "`, Bash akan mengekspansi variabel. Gunakan `\` untuk mencegahnya.
```bash
echo "Biayanya adalah \$100" # Output: Biayanya adalah $100

```


* **Spasi pada Nama File:**
Untuk memanipulasi file dengan spasi di terminal, spasi tersebut harus di-*escape*.
```bash
cat laporan\ keuangan.txt

```


* **Karakter Khusus Shell:**
Karakter pengontrol alir seperti `&`, `|`, `<`, `>`, `*`, `?`, dan `!` memiliki fungsi khusus di shell.
```bash
echo "Cari file dengan ekstensi \* atau \?"

```


* **Pemecahan Baris (Line Continuation):**
Di dalam skrip Bash yang panjang, `\` di akhir baris memberi tahu shell bahwa perintah berlanjut ke baris berikutnya.

### 3. Implementasi Khusus (Dart & Flutter)

Dalam pengembangan aplikasi dengan Dart, mekanisme *escape* memiliki beberapa sintaks tambahan yang relevan dengan ekosistemnya.

* **Interpolasi String (`$`):**
Dart menggunakan `$` untuk menyisipkan variabel langsung ke dalam string. Untuk mencetak simbol dolar secara literal, Anda harus menggunakan `\$`.
```dart
String harga = "Total tagihan: \$50.00 untuk ${user.name}";

```


* **Raw Strings (`r`):**
Jika Anda berurusan dengan path direktori atau regex yang membutuhkan banyak *backslash*, Anda dapat mengawali string dengan huruf `r` (*raw string*). Dalam mode ini, *escape character* akan sepenuhnya diabaikan.
```dart
// Tanpa raw string (harus double escape)
var path = 'C:\\Program Files\\Aplikasi';

// Dengan raw string
var rawPath = r'C:\Program Files\Aplikasi'; 

```



### 4. Escape Character dalam Regular Expressions (Regex)

Saat menggunakan alat berbasis regex seperti `grep`, `ripgrep`, `jq`, atau fungsi regex di dalam kode, banyak karakter standar yang berubah menjadi metakarakter dengan fungsi pencarian spesifik.

Karakter-karakter berikut ini **wajib** di-*escape* dengan `\` jika Anda ingin mencarinya sebagai teks biasa:
`.` `*` `+` `?` `^` `$` `(` `)` `[` `]` `{` `}` `|` `\`

**Contoh Kasus Regex:**
Jika Anda ingin mencari alamat IP literal `192.168.1.1`, titik `.` harus di-*escape*, jika tidak regex akan menganggap titik sebagai "karakter apa pun".

* Salah: `192.168.1.1` (akan cocok dengan `192a168b1c1`)
* Benar: `192\.168\.1\.1`

  </div>
</details>
