# **Materi 1: Zsh Syntax & Perbedaan dari Bash**

---

# Materi 1 — Zsh Syntax & Perbedaan dari Bash

## 1.1 Shebang dan Cara Zsh Dieksekusi

Shebang adalah baris pertama dalam script yang memberi tahu kernel interpreter apa yang harus digunakan.

```zsh
#!/bin/zsh
```

**Penjelasan kata demi kata:**

- `#!` — dua karakter pertama disebut *shebang* atau *hashbang*. Kernel membaca dua karakter ini dan tahu bahwa sisa baris adalah path ke interpreter.
- `/bin/zsh` — path absolut ke executable Zsh. Pada banyak sistem, Zsh juga tersedia di `/usr/bin/zsh` atau `/usr/local/bin/zsh`.
- Baris ini harus berada di baris paling atas file, tanpa spasi sebelum `#!`.

**Perbedaan dengan Bash:**

```bash
#!/bin/bash
```

Bash menggunakan `/bin/bash`. Jika Anda menulis script untuk Zsh, jangan gunakan `#!/bin/bash` karena akan dijalankan oleh Bash, bukan Zsh. Akibatnya, fitur khas Zsh seperti `setopt`, `$array[1]`, `**/`, dan `${name:u}` tidak akan bekerja.

Zsh juga bisa dipanggil dengan nama lain untuk emulasi:

```zsh
#!/bin/sh
```

Jika `zsh` dipanggil sebagai `sh`, ia akan berjalan dalam mode kompatibilitas POSIX. Ini berguna untuk script portabel, tetapi bukan tujuan kita. Kita fokus pada Zsh sebagai Zsh.

---

## 1.2 Variabel dan Quoting

### Assignment Variabel

```zsh
name="Cendekiawan"
```

**Penjelasan kata demi kata:**

- `name` — nama variabel. Dalam Zsh, nama variabel boleh huruf, angka, dan underscore, tetapi tidak boleh dimulai dengan angka.
- `=` — operator assignment. Tidak boleh ada spasi di sekitar `=`. Jika Anda menulis `name = "Cendekiawan"`, Zsh akan menganggap `name` sebagai perintah dan `=` sebagai argumen.
- `"Cendekiawan"` — nilai string. Tanda kutip ganda memungkinkan ekspansi variabel dan command substitution di dalamnya, tetapi mencegah word splitting dan globbing.

**Perbedaan penting dengan Bash:**

Di Bash, jika Anda menulis:

```bash
name="Cendekiawan Muslim"
echo $name
```

Bash akan melakukan *word splitting* pada `$name` karena tidak dikutip. Hasilnya adalah dua argumen: `Cendekiawan` dan `Muslim`. `echo` akan mencetak `Cendekiawan Muslim` (tetap sama secara visual), tetapi jika Anda menggunakan `for x in $name`, Bash akan mengulang dua kali.

Di Zsh, *word splitting tidak terjadi secara default* pada parameter expansion yang tidak dikutip. Jadi:

```zsh
name="Cendekiawan Muslim"
echo $name
```

Zsh akan memperlakukan `$name` sebagai satu kata. Ini adalah salah satu perbedaan terbesar yang harus Anda ingat. Untuk mengaktifkan word splitting seperti Bash, Anda harus menyalakan opsi `SH_WORD_SPLIT`:

```zsh
setopt SH_WORD_SPLIT
```

Namun, jangan lakukan itu kecuali Anda benar-benar membutuhkannya. Default Zsh lebih aman dan lebih jarang menyebabkan bug.

### Menggunakan Variabel

```zsh
printf '%s\n' "$name"
```

**Penjelasan kata demi kata:**

- `printf` — perintah builtin untuk mencetak dengan format. Berbeda dengan `echo`, `printf` tidak menambahkan newline secara otomatis dan perilakunya lebih konsisten.
- `'%s\n'` — string format. Tanda kutip tunggal berarti tidak ada ekspansi di dalamnya. `%s` adalah placeholder untuk string. `\n` adalah escape sequence untuk newline. Karena berada dalam kutip tunggal, `\n` tetap dua karakter: backslash dan `n`. `printf` yang akan menginterpretasikannya sebagai newline.
- `"$name"` — argumen kedua. Tanda kutip ganda memastikan bahwa jika `$name` berisi spasi, ia tetap menjadi satu argumen. Tanda `$` menandakan ekspansi variabel. `name` adalah nama variabel. Tanpa tanda kutip, Zsh tetap tidak akan melakukan word splitting, tetapi tanda kutip tetap disarankan untuk mencegah globbing jika nilai variabel mengandung karakter seperti `*` atau `?`.

**Mengapa `printf` dan bukan `echo`?**

`echo` di Zsh memiliki beberapa opsi yang bisa membingungkan. `printf` lebih eksplisit dan portabel. Contoh:

```zsh
echo -n "Hello"   # mencetak tanpa newline
printf '%s' "Hello"  # sama, tetapi lebih jelas
```

---

## 1.3 Array

### Deklarasi Array

```zsh
files=(one two three)
```

**Penjelasan kata demi kata:**

- `files` — nama array.
- `=(...)` — sintaks assignment array. Tanda `=` diikuti `(` dan `)`.
- `one two three` — elemen-elemen array, dipisahkan oleh spasi. Tidak perlu tanda kutip kecuali ada spasi dalam satu elemen.

**Perbedaan indeks dengan Bash:**

Di Bash, array diindeks mulai dari 0. Elemen pertama adalah `${files[0]}`.

Di Zsh, array diindeks mulai dari 1 secara default. Elemen pertama adalah `$files[1]`. Ini adalah perbedaan yang sangat sering menjebak pemula.

Jika Anda ingin Zsh menggunakan indeks 0 seperti Bash, Anda bisa menyalakan opsi `KSH_ARRAYS`:

```zsh
setopt KSH_ARRAYS
```

Namun, untuk tujuan kita, biasakan diri dengan indeks 1 karena itu default Zsh dan lebih alami bagi banyak orang.

### Mengakses Elemen Array

```zsh
print -r -- $files[1]
```

**Penjelasan kata demi kata:**

- `print` — builtin Zsh untuk mencetak. Mirip `echo` tetapi lebih kuat.
- `-r` — opsi *raw*. Artinya, `print` tidak akan menginterpretasikan escape sequence seperti `\n` atau `\t`. Tanpa `-r`, `print` bisa mengubah `\n` menjadi newline.
- `--` — penanda akhir opsi. Ini penting jika argumen berikutnya dimulai dengan `-`. Dengan `--`, `print` tahu bahwa semua yang berikutnya adalah argumen, bukan opsi.
- `$files[1]` — elemen pertama array `files`. Tanda `$` menandakan ekspansi. `files` adalah nama array. `[1]` adalah indeks. Dalam Zsh, ini menghasilkan `one`.

Jika Anda menulis `$files` tanpa indeks, Zsh akan mengekspansi ke semua elemen array, dipisahkan oleh spasi. Namun, dalam konteks tertentu, ini bisa berbeda. Untuk mengambil semua elemen sebagai array, gunakan `$files[@]` atau `$files[*]`.

```zsh
print -r -- $files[@]   # mencetak semua elemen, masing-masing sebagai argumen terpisah
print -r -- $files[*]   # mencetak semua elemen sebagai satu string, dipisahkan spasi
```

**Perbedaan `@` dan `*`:**

- `$files[@]` — setiap elemen menjadi argumen terpisah. Jika `files=(one two three)`, maka `print -r -- $files[@]` sama dengan `print -r -- one two three`.
- `$files[*]` — semua elemen digabung menjadi satu string dengan separator pertama dari `$IFS` (biasanya spasi). Hasilnya adalah satu argumen: `"one two three"`.

Dalam Bash, `${files[@]}` dan `${files[*]}` memiliki perilaku serupa, tetapi sintaksnya menggunakan kurung kurawal.

---

## 1.4 Glob / Filename Generation

### Glob Dasar

```zsh
*.txt
```

**Penjelasan kata demi kata:**

- `*` — wildcard yang cocok dengan nol atau lebih karakter, kecuali `/`.
- `.txt` — literal string. Titik di sini adalah karakter biasa, bukan wildcard.
- Secara keseluruhan, `*.txt` cocok dengan semua file di direktori saat ini yang berakhiran `.txt`.

Di Zsh, globbing terjadi secara otomatis pada argumen perintah. Jika tidak ada file yang cocok, Zsh secara default akan menghasilkan error `no matches found`. Di Bash, glob yang tidak cocok akan dibiarkan apa adanya. Untuk mengubah perilaku ini di Zsh, Anda bisa menggunakan `setopt NULL_GLOB` atau `setopt NOMATCH`.

### Glob Rekursif

```zsh
**/*.lua
```

**Penjelasan kata demi kata:**

- `**/` — cocok dengan nol atau lebih direktori secara rekursif. Ini adalah fitur Zsh yang sangat berguna.
- `*` — cocok dengan nama file apa pun.
- `.lua` — ekstensi literal.
- Secara keseluruhan, `**/*.lua` akan mencari semua file `.lua` di direktori saat ini dan semua subdirektori di bawahnya.

Di Bash, Anda harus menyalakan `shopt -s globstar` terlebih dahulu agar `**` berfungsi. Di Zsh, `**` sudah aktif secara default.

### Glob Negasi

```zsh
^*.bak
```

**Penjelasan kata demi kata:**

- `^` — operator negasi dalam *extended glob*. Ini berarti "kecuali" atau "bukan".
- `*.bak` — pola file yang berakhiran `.bak`.
- Secara keseluruhan, `^*.bak` cocok dengan semua file yang **bukan** `.bak`.

Untuk menggunakan `^`, Anda harus menyalakan opsi `EXTENDED_GLOB`:

```zsh
setopt EXTENDED_GLOB
```

Jika tidak, `^` akan dianggap karakter literal. Setelah `EXTENDED_GLOB` aktif, Anda juga bisa menggunakan operator lain seperti `~` (kecuali), `#` (nol atau lebih), `##` (satu atau lebih), dan `^` (negasi).

Contoh lain:

```zsh
*.txt~*.bak
```

Artinya: semua file `.txt` kecuali yang berakhiran `.bak`.

---

## 1.5 Parameter Expansion Khas Zsh

### Ekspansi Dasar

```zsh
${name}
```

**Penjelasan kata demi kata:**

- `$` — menandakan ekspansi parameter.
- `{` dan `}` — kurung kurawal untuk membatasi nama variabel. Ini opsional jika nama variabel diikuti oleh karakter yang bukan bagian dari nama variabel. Misalnya, `$name.txt` akan mencoba mengekspansi variabel `name.txt`, bukan `name` diikuti `.txt`. Dengan `${name}.txt`, Anda memperjelas batasnya.
- `name` — nama variabel.

### Modifier Huruf Besar dan Kecil

```zsh
${name:u}
```

**Penjelasan kata demi kata:**

- `:u` — modifier untuk mengubah seluruh nilai menjadi huruf besar (uppercase). Ini adalah fitur khas Zsh.
- Jika `name="Cendekiawan"`, maka `${name:u}` menghasilkan `CENDEKIAWAN`.

```zsh
${name:l}
```

- `:l` — modifier untuk mengubah seluruh nilai menjadi huruf kecil (lowercase).
- Jika `name="Cendekiawan"`, maka `${name:l}` menghasilkan `cendekiawan`.

Modifier ini bisa digabungkan dengan ekspansi lain. Misalnya, `${name:u:l}` akan mengubah ke huruf besar lalu ke huruf kecil, hasil akhirnya huruf kecil semua.

### Quoting Ekspansi

```zsh
${(q)name}
```

**Penjelasan kata demi kata:**

- `(q)` — *flag* dalam parameter expansion. Tanda kurung `()` digunakan untuk menampung flag.
- `q` — flag untuk *quote*. Ini akan mengutip nilai variabel sehingga aman digunakan kembali sebagai input shell. Karakter khusus seperti spasi, `*`, `?`, `$`, dan sebagainya akan di-escape dengan backslash.
- Jika `name="Cendekiawan Muslim"`, maka `${(q)name}` menghasilkan `Cendekiawan\ Muslim`. Ini berguna ketika Anda ingin menyimpan perintah dalam variabel dan mengeksekusinya nanti tanpa risiko word splitting atau globbing.

### Memecah Teks Menjadi Array

```zsh
${(f)text}
```

**Penjelasan kata demi kata:**

- `(f)` — flag untuk *split on newlines*. Huruf `f` berasal dari "field splitting" atau "split on newline". Secara spesifik, `f` membagi string pada karakter newline.
- `text` — variabel yang berisi string dengan beberapa baris.
- Hasilnya adalah array di mana setiap elemen adalah satu baris dari `text`.

Contoh:

```zsh
text=$'baris1\nbaris2\nbaris3'
lines=(${(f)text})
print -r -- $lines[1]   # baris1
print -r -- $lines[2]   # baris2
```

Perhatikan penggunaan `$'...'` untuk string yang mengandung escape sequence seperti `\n`. Dalam Zsh, `$'...'` memproses escape sequence.

---

## 1.6 Fungsi

### Definisi Fungsi

```zsh
myfunc() {
    echo "Hello"
}
```

**Penjelasan kata demi kata:**

- `myfunc` — nama fungsi.
- `()` — daftar parameter kosong. Dalam Zsh, Anda bisa menulis `function myfunc { ... }` tanpa tanda kurung, atau `myfunc() { ... }` seperti di Bash. Keduanya valid.
- `{` — awal blok fungsi. Harus dipisahkan oleh spasi atau newline dari `)`.
- `echo "Hello"` — isi fungsi.
- `}` — akhir blok fungsi.

**Perbedaan dengan Bash:**

Di Bash, `function myfunc { ... }` juga valid, tetapi `myfunc() { ... }` lebih umum. Di Zsh, keduanya valid. Namun, Zsh memiliki fitur `autoload` yang memungkinkan fungsi dimuat dari file terpisah.

### Autoload

```zsh
autoload -Uz myfunc
myfunc
```

**Penjelasan kata demi kata:**

- `autoload` — builtin Zsh untuk menandai bahwa `myfunc` adalah fungsi yang akan dimuat secara otomatis dari file di `$fpath` ketika pertama kali dipanggil.
- `-U` — opsi untuk menonaktifkan alias expansion saat memuat fungsi. Ini penting untuk menghindari konflik dengan alias.
- `-z` — opsi untuk memastikan fungsi ditulis dalam format Zsh native, bukan Ksh emulation.
- `myfunc` — nama fungsi yang akan di-autoload.
- Setelah `autoload -Uz myfunc`, Anda bisa memanggil `myfunc` seperti biasa. Zsh akan mencari file bernama `myfunc` di direktori-direktori yang terdaftar di `$fpath`. File tersebut harus berisi definisi fungsi, biasanya tanpa baris `myfunc() { ... }`, melainkan langsung isi fungsi.

Contoh isi file `~/.zsh/functions/myfunc`:

```zsh
echo "Hello from autoloaded function"
```

Kemudian tambahkan direktori ke `$fpath`:

```zsh
fpath=(~/.zsh/functions $fpath)
autoload -Uz myfunc
myfunc
```

---

## 1.7 Conditional dan Loop

### Conditional dengan `[[ ]]`

```zsh
if [[ $name == "Cendekiawan" ]]; then
    echo "Yes"
fi
```

**Penjelasan kata demi kata:**

- `if` — kata kunci untuk memulai percabangan.
- `[[` — awal *conditional expression*. Ini adalah fitur shell yang lebih aman daripada `[`. Di Zsh, `[[` adalah reserved word dan memiliki perilaku khusus.
- `$name` — ekspansi variabel.
- `==` — operator perbandingan string. Dalam `[[ ]]`, `==` melakukan pencocokan pola jika sisi kanan mengandung wildcard, tetapi di sini sisi kanan adalah string literal.
- `"Cendekiawan"` — string pembanding. Tanda kutip ganda tidak wajib di dalam `[[ ]]`, tetapi disarankan untuk konsistensi.
- `]]` — akhir conditional expression.
- `; then` — `;` memisahkan perintah, `then` adalah kata kunci untuk memulai blok yang dijalankan jika kondisi benar.
- `echo "Yes"` — perintah yang dijalankan.
- `fi` — akhir blok `if`.

**Perbedaan dengan Bash:**

Di Bash, `[[ ]]` juga ada, tetapi Zsh memiliki beberapa perbedaan dalam pencocokan pola. Misalnya, di Zsh, `[[ $name == Cendekiawan* ]]` akan melakukan pencocokan glob. Di Bash, Anda perlu mengutip sisi kanan atau menggunakan `==` dengan pola. Zsh secara default mengaktifkan `EXTENDED_GLOB` di dalam `[[ ]]`? Sebenarnya tidak, tetapi Zsh memiliki perilaku yang lebih konsisten.

### Loop dengan Brace Expansion

```zsh
for i in {1..5}; do
    echo $i
done
```

**Penjelasan kata demi kata:**

- `for` — kata kunci loop.
- `i` — nama variabel loop.
- `in` — kata kunci yang memisahkan variabel dari daftar.
- `{1..5}` — *brace expansion*. Ini menghasilkan `1 2 3 4 5`. Zsh juga mendukung `{a..e}` untuk huruf, dan `{1..10..2}` untuk step.
- `; do` — `;` memisahkan perintah, `do` memulai blok loop.
- `echo $i` — perintah yang dijalankan setiap iterasi.
- `done` — akhir loop.

**Perbedaan dengan Bash:**

Brace expansion `{1..5}` didukung di Bash dan Zsh. Namun, Zsh memiliki `{1..5..2}` untuk step, yang tidak ada di Bash versi lama. Zsh juga mendukung `{01..10}` dengan leading zero.

---

## 1.8 Exit Status dan Redirection

### Exit Status

```zsh
command
echo $?
```

**Penjelasan kata demi kata:**

- `command` — perintah apa pun.
- `$?` — variabel khusus yang menyimpan exit status dari perintah terakhir. Nilai 0 berarti sukses, non-zero berarti gagal.

Di Zsh, sama seperti Bash. Namun, Zsh memiliki variabel `$pipestatus` untuk status pipeline.

### Redirection

```zsh
command > file 2>&1
```

**Penjelasan kata demi kata:**

- `>` — mengarahkan stdout (file descriptor 1) ke `file`. Jika file sudah ada, isinya akan ditimpa.
- `2>&1` — mengarahkan stderr (file descriptor 2) ke stdout (file descriptor 1). Karena stdout sudah diarahkan ke `file`, maka stderr juga akan masuk ke `file`.
- Urutan penting: `2>&1` harus ditulis setelah `> file`. Jika dibalik, stderr akan diarahkan ke stdout yang masih menunjuk ke terminal, bukan ke file.

Di Zsh, redirection sama. Zsh juga mendukung `&> file` untuk mengarahkan stdout dan stderr sekaligus, dan `&>> file` untuk append.

---

## 1.9 Process Substitution

```zsh
diff <(ls dir1) <(ls dir2)
```

**Penjelasan kata demi kata:**

- `diff` — perintah untuk membandingkan dua file.
- `<(ls dir1)` — *process substitution*. Ini menjalankan `ls dir1` dan mengarahkan outputnya ke file sementara (sebenarnya /dev/fd/...). Argumen yang diterima `diff` adalah path ke file tersebut.
- `<(...)` — sintaks process substitution. Tanda `<` diikuti `(` dan perintah.
- `ls dir1` — perintah yang dijalankan. Outputnya menjadi isi file sementara.
- `<(ls dir2)` — sama untuk `dir2`.

Process substitution juga bekerja untuk output:

```zsh
command >(gzip > file.gz)
```

Ini menjalankan `gzip > file.gz` dan mengarahkan stdout `command` ke stdin `gzip`.

Di Zsh, process substitution didukung penuh. Di Bash juga, tetapi Zsh memiliki beberapa perbedaan dalam penanganan file descriptor.

---

## Ringkasan Materi 1

- Zsh menggunakan `#!/bin/zsh` untuk shebang.
- Variabel tidak mengalami word splitting secara default.
- Array diindeks mulai dari 1.
- Globbing `**/` dan `^` memerlukan `EXTENDED_GLOB`.
- Parameter expansion memiliki flag seperti `:u`, `:l`, `(q)`, `(f)`.
- Fungsi bisa di-autoload dari `$fpath`.
- `[[ ]]`, loop, redirection, process substitution mirip Bash tetapi dengan perbedaan halus.

---

Ini baru **Materi 1**. Materi berikutnya akan masuk ke **Parameter Expansion lebih dalam, Arrays dan Associative Arrays, Glob lanjutan, Functions dan Autoload, Options (`setopt`), serta Interactive Zsh (ZLE, bindkey, widget)**. Saya akan lanjutkan satu per satu di respons berikutnya. Apakah Anda ingin saya lanjut ke **Materi 2: Parameter Expansion dan Arrays** sekarang?

Materi yang sudah dibahas sebelumnya:
- shebang
- variabel dan quoting
- array dasar
- glob dasar
- parameter expansion dasar
- fungsi
- conditional dan loop
- exit status dan redirection
- process substitution

Sekarang kita lanjutkan bagian yang masih termasuk kurikulum Materi 1:
- parameter expansion lebih dalam
- array dan associative array
- glob lanjutan
- fungsi dan autoload
- conditional expressions

---

# Materi 1 — Lanjutan: Zsh Foundation

## 1.10 Parameter Expansion Lebih Dalam

Parameter expansion adalah mekanisme untuk mengambil nilai variabel dan memodifikasinya sebelum digunakan. Di Zsh, parameter expansion jauh lebih kaya daripada Bash.

### Bentuk Dasar

```zsh
${name}
```

Penjelasan:
- `$` — menandakan ekspansi parameter.
- `{` — awal pembatas nama parameter.
- `name` — nama variabel.
- `}` — akhir pembatas.

Bentuk ini sama seperti Bash. Gunanya adalah memperjelas batas nama variabel. Contoh:

```zsh
name="Cendekiawan"
echo "${name}Muslim"
```

Tanpa `{}`, `$nameMuslim` akan dianggap variabel bernama `nameMuslim`. Dengan `${name}Muslim`, Zsh tahu bahwa yang diekspansi adalah `name`, lalu ditambah literal `Muslim`.

### Default Value

```zsh
${name:-default}
```

Penjelasan:
- `name` — nama variabel.
- `:-` — operator “jika kosong atau tidak diset, gunakan nilai default”.
- `default` — nilai pengganti.

Jika `name` kosong atau belum diset, hasilnya `default`. Jika `name` sudah berisi nilai, hasilnya nilai `name`.

Contoh:

```zsh
name=""
echo "${name:-tanpa nama}"
```

Hasil: `tanpa nama`.

### Assign Default Value

```zsh
${name:=default}
```

Penjelasan:
- `:=` — operator “jika kosong atau tidak diset, isi variabel dengan nilai default, lalu gunakan nilai itu”.

Contoh:

```zsh
unset name
echo "${name:=Cendekiawan}"
echo "$name"
```

Hasil:
- Baris pertama mencetak `Cendekiawan`.
- Baris kedua juga mencetak `Cendekiawan`, karena variabel `name` sudah diisi.

### Error Jika Kosong

```zsh
${name:?pesan error}
```

Penjelasan:
- `:?` — operator “jika kosong atau tidak diset, tampilkan pesan error dan hentikan eksekusi”.

Contoh:

```zsh
unset name
echo "${name:?Variabel name wajib diisi}"
```

Jika `name` kosong, Zsh akan menampilkan error dan script berhenti.

### Alternatif Jika Ada Nilai

```zsh
${name:+alternatif}
```

Penjelasan:
- `:+` — operator “jika variabel diset dan tidak kosong, gunakan nilai alternatif. Jika kosong, hasilnya kosong”.

Contoh:

```zsh
name="Cendekiawan"
echo "${name:+Ada nilai}"
```

Hasil: `Ada nilai`.

### Modifier Zsh

Zsh memiliki modifier yang ditulis setelah titik dua.

```zsh
${name:u}
```

Penjelasan:
- `:u` — uppercase. Mengubah seluruh nilai menjadi huruf besar.

```zsh
name="Cendekiawan"
echo "${name:u}"
```

Hasil: `CENDEKIAWAN`.

```zsh
${name:l}
```

Penjelasan:
- `:l` — lowercase. Mengubah seluruh nilai menjadi huruf kecil.

```zsh
name="Cendekiawan"
echo "${name:l}"
```

Hasil: `cendekiawan`.

```zsh
${path:h}
```

Penjelasan:
- `:h` — head. Menghapus komponen terakhir dari path.

```zsh
path="/home/user/dokumen/file.txt"
echo "${path:h}"
```

Hasil: `/home/user/dokumen`.

```zsh
${path:t}
```

Penjelasan:
- `:t` — tail. Mengambil komponen terakhir dari path.

```zsh
path="/home/user/dokumen/file.txt"
echo "${path:t}"
```

Hasil: `file.txt`.

```zsh
${file:r}
```

Penjelasan:
- `:r` — remove extension. Menghapus ekstensi terakhir.

```zsh
file="catatan.txt"
echo "${file:r}"
```

Hasil: `catatan`.

```zsh
${file:e}
```

Penjelasan:
- `:e` — extension. Mengambil ekstensi terakhir.

```zsh
file="catatan.txt"
echo "${file:e}"
```

Hasil: `txt`.

```zsh
${text:s/lama/baru/}
```

Penjelasan:
- `:s` — substitute. Mengganti kemunculan pertama pola `lama` dengan `baru`.

```zsh
text="saya suka bash"
echo "${text:s/bash/zsh/}"
```

Hasil: `saya suka zsh`.

```zsh
${text:gs/lama/baru/}
```

Penjelasan:
- `:gs` — global substitute. Mengganti semua kemunculan.

```zsh
text="bash bash bash"
echo "${text:gs/bash/zsh/}"
```

Hasil: `zsh zsh zsh`.

### Flag dalam Parameter Expansion

Flag ditulis di dalam tanda kurung setelah `$`.

```zsh
${(q)name}
```

Penjelasan:
- `$` — ekspansi.
- `(` — awal flag.
- `q` — quote flag. Mengutip nilai agar aman digunakan kembali sebagai input shell.
- `)` — akhir flag.
- `name` — nama variabel.

Contoh:

```zsh
name="Cendekiawan Muslim"
echo "${(q)name}"
```

Hasil kira-kira: `Cendekiawan\ Muslim`.

```zsh
${(f)text}
```

Penjelasan:
- `f` — split on newlines. Memecah string menjadi array berdasarkan baris baru.

```zsh
text=$'baris1\nbaris2\nbaris3'
lines=(${(f)text})
echo "$lines[1]"
echo "$lines[2]"
```

Hasil:
- `baris1`
- `baris2`

```zsh
${(s:,:)text}
```

Penjelasan:
- `s` — split flag.
- `:` — pembatas awal untuk delimiter.
- `,` — delimiter, yaitu koma.
- `:` — pembatas akhir.
- `text` — variabel yang dipecah.

Contoh:

```zsh
text="satu,dua,tiga"
arr=(${(s:,:)text})
echo "$arr[2]"
```

Hasil: `dua`.

```zsh
${(j:,:)array}
```

Penjelasan:
- `j` — join flag.
- `:` — pembatas awal.
- `,` — separator.
- `:` — pembatas akhir.
- `array` — array yang digabung.

Contoh:

```zsh
arr=(satu dua tiga)
echo "${(j:,:)arr}"
```

Hasil: `satu,dua,tiga`.

```zsh
${(k)assoc}
```

Penjelasan:
- `k` — keys flag. Mengambil semua key dari associative array.

```zsh
${(v)assoc}
```

Penjelasan:
- `v` — values flag. Mengambil semua value dari associative array.

```zsh
${(kv)assoc}
```

Penjelasan:
- `kv` — keys dan values secara bergantian.

```zsh
${(o)array}
```

Penjelasan:
- `o` — order. Mengurutkan array secara ascending.

```zsh
${(O)array}
```

Penjelasan:
- `O` — order reverse. Mengurutkan array secara descending.

```zsh
${(u)array}
```

Penjelasan:
- `u` — unique. Menghapus duplikat.

```zsh
${(L)name}
```

Penjelasan:
- `L` — lower. Mengubah menjadi huruf kecil.

```zsh
${(U)name}
```

Penjelasan:
- `U` — upper. Mengubah menjadi huruf besar.

---

## 1.11 Array dan Associative Array

### Array Indexed

Di Zsh, array diindeks mulai dari 1.

```zsh
files=(one two three)
```

Penjelasan:
- `files` — nama array.
- `=(...)` — assignment array.
- `one two three` — elemen array.

Mengakses elemen:

```zsh
echo "$files[1]"
```

Penjelasan:
- `$files[1]` — elemen pertama.
- Hasil: `one`.

```zsh
echo "$files[-1]"
```

Penjelasan:
- `-1` — indeks negatif. Menghitung dari belakang.
- Hasil: `three`.

```zsh
echo "$files[2,3]"
```

Penjelasan:
- `[2,3]` — slice. Mengambil elemen indeks 2 sampai 3.
- Hasil: `two three`.

```zsh
echo "${#files}"
```

Penjelasan:
- `${#files}` — jumlah elemen array.
- Hasil: `3`.

```zsh
echo "${#files[1]}"
```

Penjelasan:
- `${#files[1]}` — panjang string elemen pertama.
- Hasil: `3`, karena `one` memiliki 3 karakter.

Menambah elemen:

```zsh
files+=(four)
```

Penjelasan:
- `+=` — append.
- `(four)` — elemen baru.
- Sekarang `files` berisi `one two three four`.

Mengubah elemen:

```zsh
files[1]="satu"
```

Penjelasan:
- `files[1]` — elemen pertama.
- `="satu"` — nilai baru.

Menghapus elemen:

```zsh
unset "files[2]"
```

Penjelasan:
- `unset` — hapus.
- `"files[2]"` — elemen indeks 2.
- Setelah ini, array memiliki celah. Zsh tidak otomatis merapatkan indeks.

### Expansi Array

```zsh
print -r -- "${files[@]}"
```

Penjelasan:
- `"${files[@]}"` — semua elemen sebagai argumen terpisah.
- `print -r --` — cetak raw.

```zsh
print -r -- "${files[*]}"
```

Penjelasan:
- `"${files[*]}"` — semua elemen sebagai satu string, dipisahkan oleh karakter pertama `$IFS`.

### Associative Array

Associative array adalah array dengan key berupa string.

```zsh
typeset -A user
```

Penjelasan:
- `typeset` — builtin untuk mendeklarasikan tipe variabel.
- `-A` — associative array.
- `user` — nama variabel.

Mengisi:

```zsh
user=(
    nama "Cendekiawan"
    kota "Jakarta"
    umur "25"
)
```

Penjelasan:
- `user=(` — mulai assignment.
- `nama "Cendekiawan"` — key `nama`, value `Cendekiawan`.
- `kota "Jakarta"` — key `kota`, value `Jakarta`.
- `umur "25"` — key `umur`, value `25`.
- `)` — akhir assignment.

Mengakses:

```zsh
echo "${user[nama]}"
```

Penjelasan:
- `${user[nama]}` — value untuk key `nama`.
- Hasil: `Cendekiawan`.

Mengambil keys:

```zsh
echo "${(k)user}"
```

Penjelasan:
- `(k)` — keys flag.
- Hasil: `nama kota umur` atau urutan lain.

Mengambil values:

```zsh
echo "${(v)user}"
```

Penjelasan:
- `(v)` — values flag.
- Hasil: `Cendekiawan Jakarta 25`.

Mengambil keys dan values:

```zsh
for key val in "${(kv)user[@]}"; do
    echo "$key = $val"
done
```

Penjelasan:
- `(kv)` — keys dan values bergantian.
- `key val` — dua variabel loop.
- Setiap iterasi mengambil satu key dan satu value.

---

## 1.12 Glob Lanjutan

### Extended Glob

Untuk menggunakan operator glob lanjutan, aktifkan:

```zsh
setopt EXTENDED_GLOB
```

Penjelasan:
- `setopt` — builtin untuk menyalakan opsi.
- `EXTENDED_GLOB` — opsi yang mengaktifkan operator seperti `^`, `~`, `#`, `##`.

### Negasi

```zsh
^*.bak
```

Penjelasan:
- `^` — negasi. “Kecuali”.
- `*.bak` — pola file berekstensi `.bak`.
- Hasil: semua file yang bukan `.bak`.

### Except

```zsh
*.txt~*.bak
```

Penjelasan:
- `*.txt` — semua file `.txt`.
- `~` — except. “Kecuali”.
- `*.bak` — file `.bak`.
- Hasil: semua file `.txt` kecuali yang juga `.bak`.

### Pengulangan

```zsh
a#
```

Penjelasan:
- `#` — nol atau lebih kemunculan pola sebelumnya.
- `a#` — cocok dengan string kosong, `a`, `aa`, `aaa`, dan seterusnya.

```zsh
a##
```

Penjelasan:
- `##` — satu atau lebih kemunculan.
- `a##` — cocok dengan `a`, `aa`, `aaa`, tetapi tidak string kosong.

### Alternasi

```zsh
(ini|itu)
```

Penjelasan:
- `(` dan `)` — grup.
- `|` — alternasi. “Atau”.
- `ini|itu` — cocok dengan `ini` atau `itu`.

### Glob Qualifier

Glob qualifier ditulis dalam tanda kurung di akhir pola.

```zsh
**/*.lua(.)
```

Penjelasan:
- `**/*.lua` — semua file `.lua` rekursif.
- `(.)` — qualifier: hanya file biasa, bukan direktori.

```zsh
**/*(/)
```

Penjelasan:
- `(/)` — hanya direktori.

```zsh
**/*(@)
```

Penjelasan:
- `(@)` — hanya symlink.

```zsh
**/*(*)
```

Penjelasan:
- `(*)` — hanya file executable biasa.

```zsh
*.log(om[1])
```

Penjelasan:
- `*.log` — semua file `.log`.
- `(om[1])` — `om` urutkan berdasarkan modification time, terbaru dulu. `[1]` ambil yang pertama.
- Hasil: file `.log` paling baru.

```zsh
*(m-1)
```

Penjelasan:
- `m` — modification time.
- `-1` — kurang dari 1 hari.
- Hasil: file yang dimodifikasi dalam 24 jam terakhir.

```zsh
*(Lk+10)
```

Penjelasan:
- `L` — size.
- `k` — dalam kilobyte.
- `+10` — lebih besar dari 10 KB.
- Hasil: file berukuran lebih dari 10 KB.

---

## 1.13 Fungsi dan Autoload

### Fungsi Dasar

```zsh
myfunc() {
    echo "Hello"
}
```

Penjelasan:
- `myfunc` — nama fungsi.
- `()` — daftar parameter kosong.
- `{` — awal blok.
- `echo "Hello"` — isi fungsi.
- `}` — akhir blok.

Memanggil:

```zsh
myfunc
```

### Argumen Fungsi

```zsh
greet() {
    echo "Hello, $1"
}
```

Penjelasan:
- `$1` — argumen pertama.
- `greet "Cendekiawan"` akan mencetak `Hello, Cendekiawan`.

```zsh
show_all() {
    for arg in "$@"; do
        echo "$arg"
    done
}
```

Penjelasan:
- `"$@"` — semua argumen sebagai item terpisah.
- `for arg in "$@"` — iterasi setiap argumen.

### Local Variable

```zsh
myfunc() {
    local name="Cendekiawan"
    echo "$name"
}
```

Penjelasan:
- `local` — variabel hanya berlaku di dalam fungsi.
- Tanpa `local`, variabel akan menjadi global.

### Return

```zsh
myfunc() {
    return 1
}
```

Penjelasan:
- `return` — mengembalikan exit status fungsi.
- `1` — status non-zero, biasanya menandakan gagal.

### Autoload

Autoload memungkinkan fungsi dimuat dari file terpisah saat pertama kali dipanggil.

```zsh
fpath=(~/.zsh/functions $fpath)
autoload -Uz myfunc
```

Penjelasan:
- `fpath` — array direktori tempat Zsh mencari fungsi autoload.
- `(~/.zsh/functions $fpath)` — tambahkan direktori baru di depan `$fpath`.
- `autoload` — builtin untuk menandai fungsi akan dimuat otomatis.
- `-U` — jangan ekspansi alias saat memuat.
- `-z` — format Zsh native.
- `myfunc` — nama fungsi.

File `~/.zsh/functions/myfunc` berisi isi fungsi, bukan definisi `myfunc() { ... }`. Contoh isi:

```zsh
echo "Hello dari autoload"
```

Setelah itu:

```zsh
myfunc
```

Zsh akan mencari file `myfunc` di `$fpath`, memuatnya, lalu menjalankannya.

---

## 1.14 Conditional Expressions

### Operator File

```zsh
[[ -e "$file" ]]
```

Penjelasan:
- `[[` — awal conditional.
- `-e` — exists. Benar jika file ada.
- `"$file"` — nama file.
- `]]` — akhir conditional.

Operator lain:

- `-f` — regular file.
- `-d` — directory.
- `-L` — symlink.
- `-r` — readable.
- `-w` — writable.
- `-x` — executable.
- `-s` — size lebih dari 0.
- `-nt` — newer than.
- `-ot` — older than.
- `-ef` — same file.

Contoh:

```zsh
if [[ -f "$file" ]]; then
    echo "File biasa"
fi
```

Penjelasan:
- `if` — mulai kondisi.
- `[[ -f "$file" ]]` — cek apakah file biasa.
- `; then` — blok jika benar.
- `fi` — akhir.

### Operator String

```zsh
[[ -z "$str" ]]
```

Penjelasan:
- `-z` — zero length. Benar jika string kosong.

```zsh
[[ -n "$str" ]]
```

Penjelasan:
- `-n` — non-zero length. Benar jika string tidak kosong.

```zsh
[[ "$a" == "$b" ]]
```

Penjelasan:
- `==` — sama dengan.

```zsh
[[ "$a" != "$b" ]]
```

Penjelasan:
- `!=` — tidak sama dengan.

### Pattern Matching

```zsh
[[ "$file" == *.txt ]]
```

Penjelasan:
- Sisi kanan `*.txt` tidak dikutip, sehingga diperlakukan sebagai pola glob.
- Benar jika `$file` berakhiran `.txt`.

### Regex

```zsh
[[ "$name" =~ ^[A-Z] ]]
```

Penjelasan:
- `=~` — operator regex.
- `^[A-Z]` — regex: awal string diikuti huruf kapital.
- Jika cocok, `$MATCH` berisi string yang cocok, dan `$match` array berisi grup tangkapan.

### Logika

```zsh
[[ -f "$file" && -r "$file" ]]
```

Penjelasan:
- `&&` — DAN. Kedua kondisi harus benar.

```zsh
[[ -f "$file" || -d "$file" ]]
```

Penjelasan:
- `||` — ATAU. Salah satu kondisi benar.

```zsh
[[ ! -f "$file" ]]
```

Penjelasan:
- `!` — NOT. Membalik kondisi.

---

# Ringkasan Materi 1 Lengkap

Sampai di sini, Materi 1 — Zsh Foundation sudah mencakup:
- shebang
- variabel dan quoting
- parameter expansion dasar dan lanjutan
- modifier dan flag
- array indexed
- associative array
- glob dasar dan lanjutan
- fungsi dan autoload
- conditional expressions
- exit status, redirection, process substitution

Ini adalah fondasi bahasa Zsh. Kita belum masuk ke `setopt` secara khusus, belum masuk ZLE, belum masuk `.zshrc`, dan belum masuk completion system. Itu semua ada di materi berikutnya sesuai kurikulum.

Berikutnya adalah **Materi 2 — Zsh Options**. Di situ kita akan membahas:
- `setopt`
- `unsetopt`
- `setopt -o`
- option, default option, interactive option, emulation
- `AUTO_CD`
- `EXTENDED_GLOB`
- `HIST_IGNORE_DUPS`
- `SHARE_HISTORY`
- dan praktik langsung

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

