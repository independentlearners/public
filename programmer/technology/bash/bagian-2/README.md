# **Panduan Lengkap: Pattern Matching, Ekspansi Shell, Kontrol Alur, dan Manipulasi Teks di Bash**
<!-- > **Catatan revisi:** Dokumen ini menggantikan enam file terpisah (`globbing.md`, `pattern-matching.md`, `wildcard.md`, `word-splitting.md`, `short-circuiting.md`, dan `README.md` Fase 2). Semua materi telah digabung menjadi satu penjelasan utuh, dengan koreksi kesalahan faktual, penambahan materi yang hilang, serta penataan ulang alur belajar dari fondasi ke aplikasi. Setiap konsep dijelaskan secara mendalam—bukan hanya *apa*, tetapi juga *mengapa*, *kapan*, dan *bagaimana* ia berinteraksi dengan konsep lain. -->
---

## **Daftar Isi**

- [1. Pengantar & Peta Konsep](#--1--pengantar-&-peta-konsep)
- [2. Urutan Ekspansi Shell (Kerangka Utama)](#2-urutan-ekspansi-shell-kerangka-utama)
- [3. Word Splitting (Mendalam)](#3-word-splitting-mendalam)
- [4. Pathname Expansion / Globbing (Mendalam)](#4-pathname-expansion--globbing-mendalam)
- [5. Pattern Matching (Lebih Luas dari Globbing)](#5-pattern-matching-lebih-luas-dari-globbing)
- [6. Short-Circuiting](#6-short-circuiting)
- [7. Kontrol Alur: Kondisional, Perulangan, Fungsi](#7-kontrol-alur-kondisional-perulangan-fungsi)
- [8. Array dan Manipulasi Teks](#8-array-dan-manipulasi-teks)
- [9. Praktik Terbaik, Kesalahan Umum, dan Debugging](#9-praktik-terbaik-kesalahan-umum-dan-debugging)
- [10. Studi Kasus Terpadu](#10-studi-kasus-terpadu)
- [11. Referensi](#11-referensi)

---

## **1. Pengantar & Peta Konsep**

### 1.1 Mengapa Topik Ini Penting

Bash (dan shell POSIX lain) adalah **lapisan perekat** yang menghubungkan pengguna, filesystem, dan ratusan utilitas Unix. Ketika Anda mengetik perintah di terminal, shell tidak langsung mengeksekusinya. Ia terlebih dahulu melakukan serangkaian **transformasi teks** yang disebut *ekspansi*, lalu memecah hasilnya menjadi argumen, lalu memanggil program. Transformasi ini adalah alasan mengapa:

- `echo *.txt` bisa menghasilkan daftar file, bukan literal `*.txt`.
- `echo "$var"` dan `echo $var` bisa memberi hasil berbeda.
- `rm $file` bisa menghapus file yang salah jika `$file` berisi spasi.
- `[[ $x == *.txt ]]` bekerja tanpa menyentuh filesystem.

Sayangnya, banyak pemula (dan bahkan pengguna berpengalaman) mencampuradukkan konsep-konsep ini: **globbing**, **brace expansion**, **word splitting**, **pattern matching**, dan **regex**. Padahal masing-masing adalah tahap atau mekanisme yang berbeda, terjadi di waktu yang berbeda, dengan aturan yang berbeda pula.

Memahami perbedaan ini bukan sekadar teori. Ia adalah **garis pemisah** antara skrip yang rapuh (mudah rusak oleh nama file berisi spasi, karakter khusus, atau input pengguna) dan skrip yang **robust** (aman terhadap berbagai input). Ia juga menjelaskan mengapa beberapa idiom Bash terlihat "aneh" (seperti `while IFS= read -r line; do ... done < file`) dan mengapa idiom lain berbahaya (seperti `for f in $(ls)`).

### 1.2 Peta Konsep

Berikut adalah peta konsep yang menghubungkan semua istilah yang akan dibahas:

| Istilah | Dilakukan oleh | Lingkup | Kapan Terjadi | Contoh |
|---|---|---|---|---|
| **Ekspansi Shell** | Shell | Umum (payung semua tahap) | Sebelum eksekusi | `~`, `$var`, `$(cmd)` |
| **Brace Expansion** | Shell | Menghasilkan string | Tahap 1 | `{a,b}.txt` → `a.txt b.txt` |
| **Tilde Expansion** | Shell | Mengganti `~` | Tahap 2 | `~` → `/home/user` |
| **Parameter Expansion** | Shell | Mengganti `$var` | Tahap 3 | `$USER` → `budi` |
| **Command Substitution** | Shell | Menjalankan perintah | Tahap 4 | `$(date)` → `2024-01-15` |
| **Arithmetic Expansion** | Shell | Menghitung aritmatika | Tahap 5 | `$((2+3))` → `5` |
| **Word Splitting** | Shell | Memecah string jadi kata | Tahap 6 | `$var` → beberapa argumen |
| **Pathname Expansion (Globbing)** | Shell | Nama file di filesystem | Tahap 7 | `*.txt` → `a.txt b.txt` |
| **Pattern Matching** | Shell / bahasa | String (tanpa filesystem) | Di `[[ ]]`, `case` | `[[ $x == *.txt ]]` |
| **Regex** | Program / shell | String (kompleks) | Di `[[ =~ ]]`, `grep` | `[[ $x =~ ^[a-z]+$ ]]` |
| **Short-Circuiting** | Shell / bahasa | Evaluasi logika | Di `&&`, `\|\|` | `cmd1 && cmd2` |

**Ide kunci yang harus dipegang:**

1. **Globbing ≠ regex ≠ brace expansion.** Ketiganya sering disalahartikan sebagai satu hal. Brace expansion adalah **generator string**, globbing adalah **pencari file**, regex adalah **pencocok pola kompleks**.

2. **Brace expansion terjadi paling awal**, sebelum `$var` diekspansi. Ia **tidak menyentuh filesystem**. Ia hanya menghasilkan kombinasi string.

3. **Word splitting terjadi setelah ekspansi**, tetapi **sebelum globbing**. Ini berarti string yang dihasilkan oleh `$var` bisa dipecah menjadi beberapa kata, lalu setiap kata bisa di-glob.

4. **Globbing hanya terjadi jika hasil ekspansi tidak dikutip ganda.** Kutip ganda (`"$var"`) menonaktifkan word splitting **dan** globbing.

5. **Pattern matching di `[[ ]]` dan `case` mirip globbing, tetapi tidak menyentuh filesystem.** Ia mencocokkan **string** terhadap pola, bukan mencari file.

6. **Regex di `[[ =~ ]]` punya sintaks sendiri**, tidak sama dengan globbing. Regex jauh lebih kuat tetapi juga lebih kompleks.

### 1.3 Analogi untuk Memahami Perbedaan

Bayangkan Anda memberikan instruksi kepada asisten:

- **Brace expansion** seperti membuat daftar variasi: "Ambil {apel, jeruk} dari kulkas" → asisten membuat dua instruksi: "Ambil apel" dan "Ambil jeruk".
- **Word splitting** seperti memotong kalimat menjadi kata: "Ambil apel jeruk mangga" → tiga kata: "Ambil", "apel", "jeruk", "mangga" (asisten menganggap "Ambil" sebagai perintah, sisanya sebagai objek).
- **Globbing** seperti mencari barang di gudang: "Ambil *.txt" → asisten mencari semua barang dengan ekstensi `.txt` di gudang (filesystem).
- **Pattern matching** seperti mencocokkan label: "Apakah label ini cocok dengan *.txt?" → asisten hanya melihat label, tidak mencari barang.
- **Regex** seperti mencocokkan pola rumit: "Apakah label ini cocok dengan pola 'diawali huruf kecil, diakhiri .txt, minimal 3 karakter'?"

Analogi ini menunjukkan bahwa masing-masing mekanisme bekerja pada **tingkat yang berbeda**: brace expansion pada **teks mentah**, word splitting pada **pemecahan kata**, globbing pada **filesystem**, pattern matching pada **string**, dan regex pada **pola kompleks**.

---

## **2. Urutan Ekspansi Shell (Kerangka Utama)**

### 2.1 Mengapa Urutan Penting

Urutan ekspansi shell adalah **fondasi** untuk memahami semua materi berikutnya. Ketika Anda mengetik perintah, Bash memprosesnya melalui tujuh tahap secara **berurutan**. Setiap tahap mengambil input dari tahap sebelumnya, mengubahnya, dan meneruskannya ke tahap berikutnya. Memahami urutan ini menjelaskan:

- Mengapa `echo {a,b}$var` menghasilkan `a<nilai-var> b<nilai-var>` — brace expansion terjadi **sebelum** parameter expansion, jadi `{a,b}` diperluas menjadi `a b`, lalu `$var` diekspansi, menghasilkan `a<nilai> b<nilai>`.
- Mengapa `echo "$var"` tidak di-glob — kutip ganda menonaktifkan word splitting dan globbing.
- Mengapa `var=*; echo $var` bisa menghasilkan daftar file, tetapi `var=*; echo "$var"` menghasilkan literal `*`.

### 2.2 Diagram Urutan Ekspansi

```
+----------------------+
|  1. Brace Expansion  |   {a,b} → a b
+----------+-----------+
           |
           v
+----------------------+
|  2. Tilde Expansion  |   ~ → /home/user
+----------+-----------+
           |
           v
+------------------------------+
|  3. Parameter Expansion      |   $var → value
|     (Variable Substitution)  |
+----------+-------------------+
           |
           v
+------------------------------+
|  4. Command Substitution     |   $(cmd) → output cmd
+----------+-------------------+
           |
           v
+------------------------------+
|  5. Arithmetic Expansion     |   $((1+2)) → 3
+----------+-------------------+
           |
           v
+==============================+
||  6. WORD SPLITTING          ||   berdasarkan IFS
+==============================+
           |
           v
+------------------------------+
|  7. Pathname Expansion       |   *.txt → file1.txt file2.txt
|     (Globbing)               |
+----------+-------------------+
           |
           v
+----------------------+
|  Final Arguments     |
|  dikirim ke program  |
+----------------------+
```

**Tips mengingat:** *"Brace, Tilde, Param, Cmd, Math → Split → Glob → Run"*.

### 2.3 Penjelasan Setiap Tahap

**Tahap 1 — Brace Expansion:** Menghasilkan string baru berdasarkan pola `{...}`. Contoh: `{a,b,c}` → `a b c`; `file{1..3}.txt` → `file1.txt file2.txt file3.txt`; `{a,b}{1,2}` → `a1 a2 b1 b2`. Brace expansion **tidak menyentuh filesystem** — ia hanya menghasilkan string. Jika tidak ada yang cocok, string tetap dihasilkan.

**Tahap 2 — Tilde Expansion:** Mengganti `~` di awal kata dengan `$HOME`. Contoh: `~` → `/home/user`; `~/docs` → `/home/user/docs`; `~budi` → `/home/budi`. Tilde hanya diekspansi jika berada di awal kata atau setelah `:` dalam assignment.

**Tahap 3 — Parameter Expansion:** Mengganti `$var`, `${var}`, dan bentuk lanjutan seperti `${var:-default}`, `${var#prefix}`, `${var%.suffix}`. Contoh: `$USER` → `budi`; `${HOME}/docs` → `/home/user/docs`; `${file%.txt}` → `file`.

**Tahap 4 — Command Substitution:** Menjalankan perintah di dalam `$(...)` atau `` `...` `` dan menggantinya dengan output. Contoh: `$(date +%Y)` → `2024`; `` `pwd` `` → `/home/user`.

**Tahap 5 — Arithmetic Expansion:** Menghitung ekspresi aritmatika di dalam `$((...))`. Contoh: `$((2+3))` → `5`; `$((i * 2))` → dua kali nilai `i`.

**Tahap 6 — Word Splitting:** Memecah hasil ekspansi menjadi kata-kata berdasarkan `IFS`. **Hanya terjadi jika hasil tidak dikutip ganda.** Contoh: `var="a b c"; echo $var` → tiga argumen; `echo "$var"` → satu argumen.

**Tahap 7 — Pathname Expansion (Globbing):** Mencocokkan setiap kata terhadap pola glob dan menggantinya dengan daftar file yang cocok. **Hanya terjadi jika kata mengandung karakter glob dan tidak dikutip.** Contoh: `*.txt` → `a.txt b.txt`; jika tidak ada file yang cocok, perilakunya tergantung opsi shell (`nullglob`, `failglob`).

### 2.4 Pengecualian dan Kasus Khusus

- **Assignment** (`var=value`) tidak melalui word splitting atau globbing. `var=*.txt` menyimpan literal `*.txt`, bukan daftar file.
- **`[[ ... ]]`** dan `case` tidak melalui globbing filesystem. Mereka melakukan pattern matching pada string.
- **Heredoc** (`<<EOF`) tidak melalui word splitting atau globbing, kecuali jika `EOF` tidak dikutip.
- **`$@` dan `$*`** memiliki perilaku khusus terkait word splitting (lihat §3.5).
- **Quoting** mempengaruhi tahap 6 dan 7, tetapi tidak mempengaruhi tahap 1–5. Brace expansion tetap terjadi bahkan di dalam kutip ganda: `echo "{a,b}"` menghasilkan `{a,b}`, tetapi `echo {a,b}` menghasilkan `a b` (karena `{a,b}` tidak dikutip).

### 2.5 Contoh Terpadu

```bash
# Setup
mkdir -p /tmp/demo && cd /tmp/demo
touch a.txt b.txt c.md
export NAME="file"

# Contoh 1: brace + parameter + glob
echo {a,b}.txt
# Output: a.txt b.txt

# Contoh 2: brace + parameter (brace dulu)
echo {a,b}$NAME
# Output: afile bfile

# Contoh 3: parameter + glob (glob setelah splitting)
echo $NAME*.txt
# Output: file*.txt (jika tidak ada file "file*.txt"), atau
#         file.txt (jika ada file bernama "file.txt")

# Contoh 4: quoting menonaktifkan glob
echo "$NAME"*.txt
# Output: file*.txt  (glob tetap terjadi karena * tidak dikutip)

echo "$NAME*.txt"
# Output: file*.txt  (literal, tidak ada globbing)
```

Contoh 3 dan 4 menunjukkan nuansa penting: **kutipan hanya menonaktifkan globbing pada bagian yang dikutip**. Jika `*` berada di luar kutipan, globbing tetap terjadi.

---

## **3. Word Splitting (Mendalam)**

### 3.1 Definisi Formal

**Word splitting** (disebut juga *field splitting*) adalah proses di mana shell memecah string menjadi **kata-kata terpisah** (*fields*) berdasarkan nilai variabel `IFS` (*Internal Field Separator*). Proses ini terjadi **setelah** parameter expansion, command substitution, dan arithmetic expansion selesai, tetapi **sebelum** pathname expansion (globbing).

**Aturan emas:** Word splitting **hanya terjadi jika hasil ekspansi tidak dikutip ganda**.

### 3.2 Mengapa Word Splitting Ada?

Word splitting adalah mekanisme yang memungkinkan shell mengubah **satu string** menjadi **beberapa argumen**. Ini adalah fitur, bukan bug. Tanpa word splitting, shell tidak akan bisa melakukan:

```bash
# Menjalankan perintah dengan argumen dari variabel
args="--verbose --output=result.txt"
mycommand $args   # dipecah menjadi: mycommand --verbose --output=result.txt
```

Namun, fitur ini juga menjadi **sumber bug** paling umum dalam shell scripting, terutama ketika string berisi spasi atau karakter khusus:

```bash
file="My Document.txt"
rm $file          # SALAH: rm dipanggil dengan dua argumen: "My" dan "Document.txt"
rm "$file"        # BENAR: rm dipanggil dengan satu argumen: "My Document.txt"
```

### 3.3 Mekanisme `IFS`

`IFS` adalah variabel lingkungan khusus yang berisi **karakter-karakter yang dianggap sebagai pemisah**. Secara default:

```bash
IFS=$' \t\n'   # spasi, tab, newline
```

**Aturan word splitting:**

1. Shell memindai string dan memotongnya di setiap karakter yang ada di `IFS`.
2. **Karakter `IFS` yang berurutan dianggap sebagai satu pemisah.** Jadi `"a   b"` (tiga spasi) dipecah menjadi `a` dan `b`, bukan `a`, ``, ``, `b`.
3. **Karakter `IFS` di awal dan akhir string diabaikan.** Jadi `"  a b  "` dipecah menjadi `a` dan `b`.
4. **Jika `IFS` kosong**, word splitting tidak terjadi sama sekali.
5. **Jika `IFS` di-unset**, ia kembali ke default (spasi, tab, newline).

**Contoh:**

```bash
# Default IFS
var="a b   c"
printf '<%s>\n' $var
# Output:
# <a>
# <b>
# <c>

# IFS diubah
IFS=:
var="a:b::c"
printf '<%s>\n' $var
# Output:
# <a>
# <b>
# <>
# <c>
# Perhatikan: '::' menghasilkan satu field kosong karena
# karakter IFS berurutan dianggap satu pemisah, tetapi
# dua pemisah berturut-turut menghasilkan field kosong.
```

### 3.4 Kapan Word Splitting **Tidak** Terjadi

1. **Di dalam tanda kutip ganda:** `"$var"` — seluruh string dianggap satu kata.
2. **Di dalam assignment:** `var=$other` — tidak di-split.
3. **Di dalam `[[ ... ]]`:** `[[ $x == $y ]]` — tidak di-split.
4. **Di dalam `case "$var" in`** — tidak di-split.
5. **Di dalam heredoc dengan `<<'EOF'`** (quoted) — tidak di-split.
6. **Jika `IFS` kosong:** `IFS=; var="a b"; echo $var` → satu argumen `a b`.

### 3.5 `$@` vs `$*` — Perbedaan Krusial

Ini adalah salah satu topik paling membingungkan di Bash. Perbedaannya terletak pada **bagaimana mereka di-quote**:

| Ekspresi | Perilaku | Contoh (`set -- "a b" c d`) |
|---|---|---|
| `"$@"` | Setiap argumen menjadi kata terpisah, **tanpa** word splitting lebih lanjut | `["a b"]`, `["c"]`, `["d"]` |
| `$@` | Sama seperti `"$@"` jika tidak ada `IFS` khusus, tetapi rentan | `["a", "b"]`, `["c"]`, `["d"]` |
| `"$*"` | Semua argumen digabung menjadi **satu string** dengan pemisah karakter pertama `IFS` | `["a b c d"]` (jika IFS=spasi) |
| `$*` | Semua argumen digabung, lalu di-split oleh `IFS` | `["a", "b", "c", "d"]` |

**Aturan praktis:**

- **Selalu gunakan `"$@"`** untuk meneruskan argumen ke fungsi atau perintah lain. Ini adalah satu-satunya bentuk yang **aman** terhadap spasi dan karakter khusus.
- `"$*"` hanya digunakan jika Anda memang ingin menggabungkan semua argumen menjadi satu string (misalnya, untuk logging).
- Hindari `$@` dan `$*` tanpa kutipan ganda.

**Contoh:**

```bash
set -- "a b" c d

# Cara benar meneruskan argumen
myfunc() {
  echo "Jumlah argumen: $#"
  for arg in "$@"; do
    echo "  [$arg]"
  done
}
myfunc "$@"
# Output:
#   Jumlah argumen: 3
#   [a b]
#   [c]
#   [d]
```

### 3.6 Bahaya Umum dan Solusinya

| Bahaya | Contoh Buruk | Mengapa Salah | Solusi |
|---|---|---|---|
| Nama file berisi spasi | `for f in $(ls)` | `$(ls)` di-split, nama dengan spasi jadi beberapa kata | `for f in *; do ...; done` |
| Variabel user | `rm $file` | Jika `$file` berisi spasi, `rm` menerima beberapa argumen | `rm "$file"` |
| Daftar dinamis dari `ls` | `files=$(ls)` | Hasil `ls` di-split, nama dengan spasi rusak | `mapfile -t files < <(ls)` |
| Argumen fungsi | `func $args` | `$args` di-split, argumen dengan spasi rusak | `func "$@"` atau array |
| Loop dari command substitution | `for x in $(cat list)` | Setiap kata di-split, tidak peduli baris | `while IFS= read -r x; do ...; done < list` |
| `IFS` global diubah | `IFS=:` di seluruh skrip | Mempengaruhi semua perintah berikutnya | Lokalkan: `IFS=: read -r ...` atau simpan/restore |

### 3.7 Contoh Benar Membaca File Baris demi Baris

Membaca file baris demi baris adalah tugas yang sering dilakukan, dan ada banyak cara yang **salah**. Berikut adalah cara yang **benar**:

```bash
# ✅ BENAR: while di shell yang sama, IFS dilokalisasi
while IFS= read -r line; do
  printf 'Baris: %s\n' "$line"
done < "$file"

# ✅ BENAR: baca ke array (Bash 4+)
mapfile -t lines < "$file"
for line in "${lines[@]}"; do
  printf 'Baris: %s\n' "$line"
done

# ✅ BENAR: untuk file dengan nama aneh (newline dalam nama file)
find . -maxdepth 1 -print0 | while IFS= read -r -d '' file; do
  printf 'File: %s\n' "$file"
done

# ❌ SALAH: while di subshell, variabel hilang
cat "$file" | while read -r line; do
  count=$((count + 1))   # perubahan tidak terlihat di luar
done
echo "$count"            # kosong

# ❌ SALAH: for dari command substitution
for line in $(cat "$file"); do
  echo "$line"           # baris dengan spasi akan rusak
done

# ❌ SALAH: IFS global
IFS=$'\n'
for line in $(cat "$file"); do
  echo "$line"           # masih rusak untuk baris dengan newline
done
```

**Penjelasan mengapa `while IFS= read -r` adalah yang terbaik:**

- **`while ... done < file`** — perulangan berjalan di **shell yang sama**, sehingga variabel yang dimodifikasi di dalam loop tetap ada setelah loop selesai. Ini berbeda dengan `cat file | while ...` yang menjalankan `while` di **subshell** (karena pipe menciptakan subshell).
- **`IFS=`** — mengosongkan `IFS` **hanya untuk perintah `read`**. Ini mencegah `read` memecah baris berdasarkan spasi. Tanpa `IFS=`, baris `"a b c"` akan dibaca sebagai tiga field.
- **`read -r`** — opsi `-r` (*raw*) mencegah `read` menafsirkan backslash (`\`) sebagai escape. Tanpa `-r`, input `"a\tb"` akan diubah menjadi `"a<TAB>b"`.
- **`< file`** — input redirection. Ini adalah cara paling efisien untuk memberikan input ke loop, tanpa membuat subshell atau proses tambahan.

### 3.8 Visualisasi Tahap Ekspansi (Script Aman)

Berikut versi yang **tidak menggunakan `eval` berulang** (yang berbahaya). Kita hanya mendemonstrasikan tahap secara manual dengan contoh terbatas:

```bash
#!/usr/bin/env bash
# shell-expansion-demo.sh
# Menampilkan urutan ekspansi shell dengan contoh terbatas (aman).

GREEN=$'\033[1;32m'
RED=$'\033[1;31m'
CYAN=$'\033[1;36m'
NC=$'\033[0m'

step() { echo -e "$1"; sleep 0.6; }

clear
echo "Demo urutan ekspansi shell (contoh terbatas, aman):"
echo

step "${GREEN}[1] Brace Expansion${NC}: {a,b}.txt → a.txt b.txt"
step "${GREEN}[2] Tilde Expansion${NC}: ~ → $HOME"
step "${GREEN}[3] Parameter Expansion${NC}: \$USER → $USER"
step "${GREEN}[4] Command Substitution${NC}: \$(date +%Y) → $(date +%Y)"
step "${GREEN}[5] Arithmetic Expansion${NC}: \$((2+3)) → $((2+3))"

# Word splitting — didemonstrasikan tanpa eval
var="satu dua tiga"
step "${RED}[6] Word Splitting${NC}: var='$var'; \$var → 3 argumen"

# Globbing — didemonstrasikan dengan pola terbatas
step "${CYAN}[7] Pathname Expansion${NC}: *.sh → $(echo *.sh 2>/dev/null | head -c 60)..."

echo
echo "Final: argumen dikirim ke program."
```

> **Peringatan:** Jangan gunakan `eval echo "$CMD"` berulang untuk "mensimulasikan" tahap ekspansi. Itu mengeksekusi ulang command substitution di setiap tahap dan bisa menjadi celah keamanan. Untuk mempelajari ekspansi, lebih baik gunakan contoh terbatas seperti di atas, atau gunakan `set -x` untuk melihat perintah yang benar-benar dijalankan.

### 3.9 Interaksi Word Splitting dengan Globbing

Urutan word splitting → globbing memiliki implikasi penting:

```bash
var="*.txt"
echo $var      # Word splitting: ["*.txt"]; Globbing: ["a.txt", "b.txt"]
echo "$var"    # Word splitting: ["*.txt"]; Globbing: (tidak terjadi)

var="a b"
echo $var      # Word splitting: ["a", "b"]; Globbing: (tidak ada match)
echo "$var"    # Satu argumen: ["a b"]
```

Jika variabel berisi karakter glob dan tidak dikutip, globbing akan terjadi **setelah** word splitting. Ini berarti `var="*.txt *.md"; echo $var` akan menghasilkan daftar file `.txt` **dan** `.md`.

---

## **4. Pathname Expansion / Globbing (Mendalam)**

### 4.1 Definisi Formal

**Globbing** (atau *pathname expansion*) adalah proses **shell** mencocokkan nama file atau path menggunakan pola (*glob patterns*) **sebelum** perintah dijalankan. Hasilnya adalah daftar nama file yang cocok, **diurutkan secara leksikografis** (berdasarkan urutan byte, biasanya ASCII).

> **Penting:** Globbing **bukan regex**, dan **bukan** brace expansion. Globbing menyentuh filesystem—ia mencari file yang benar-benar ada.

### 4.2 Sejarah dan Etimologi

Istilah "glob" berasal dari bahasa pemrograman **Lisp** (1960-an), tempat fungsi `glob` digunakan untuk mencocokkan pola nama file. Istilah ini kemudian diadopsi oleh Unix shell. Globbing adalah salah satu fitur paling awal dari Unix shell (Bourne shell, 1977), dan sintaksnya (`*`, `?`, `[...]`) telah menjadi standar de facto di hampir semua shell modern.

### 4.3 Wildcard Dasar

| Pola | Arti | Contoh | Cocok dengan | Tidak Cocok dengan |
|---|---|---|---|---|
| `*` | 0 atau lebih karakter (kecuali `/` dan leading `.`) | `*.txt` | `a.txt`, `b.txt`, `abc.txt` | `.hidden.txt`, `a/b.txt` |
| `?` | Tepat 1 karakter (kecuali `/`) | `file?.sh` | `file1.sh`, `fileA.sh` | `file.sh`, `file12.sh` |
| `[abc]` | 1 karakter dari set | `file[12].txt` | `file1.txt`, `file2.txt` | `file3.txt`, `file12.txt` |
| `[a-z]` | 1 karakter dari range | `[a-z]*.sh` | `app.sh`, `run.sh` | `App.sh`, `1app.sh` |
| `[!abc]` | 1 karakter **bukan** dari set (POSIX) | `file[!0-9].txt` | `fileA.txt`, `fileX.txt` | `file1.txt` |
| `[^abc]` | Sama seperti `[!abc]`, **non-POSIX** | `file[^0-9].txt` | `fileA.txt` | `file1.txt` |
| `[[:alpha:]]` | POSIX character class | `[[:digit:]]*.log` | `1.log`, `2.log` | `a.log` |
| `[[:space:]]` | Karakter whitespace | `file[[:space:]]*.txt` | `file a.txt` | `filea.txt` |

**Catatan POSIX:** Hanya `[!...]` yang standar. `[^...]` didukung Bash/Zsh, tetapi tidak dijamin ada di shell POSIX lain (misalnya `dash`). Untuk portabilitas maksimum, gunakan `[!...]`.

**POSIX character classes** yang umum:

| Class | Arti |
|---|---|
| `[[:alpha:]]` | Huruf (a-z, A-Z) |
| `[[:digit:]]` | Angka (0-9) |
| `[[:alnum:]]` | Huruf atau angka |
| `[[:space:]]` | Whitespace (spasi, tab, newline) |
| `[[:upper:]]` | Huruf kapital |
| `[[:lower:]]` | Huruf kecil |
| `[[:punct:]]` | Tanda baca |
| `[[:xdigit:]]` | Digit heksadesimal |

**Catatan:** Character class hanya bekerja di dalam `[...]`, dan **case-sensitive** terhadap nama class (harus huruf kecil).

### 4.4 Extended Globbing (Bash & Zsh)

Extended globbing adalah fitur yang memperluas sintaks glob di luar POSIX. Di Bash, ia diaktifkan dengan:

```bash
shopt -s extglob
```

Di Zsh, extended glob aktif secara default atau dengan:

```zsh
setopt extendedglob
```

| Pola | Arti | Contoh | Cocok dengan |
|---|---|---|---|
| `?(pattern-list)` | 0 atau 1 kemunculan | `?(foo)` | ``, `foo` |
| `*(pattern-list)` | 0 atau lebih kemunculan | `*(foo bar)` | ``, `foo`, `bar`, `foobar`, `barfoo`, ... |
| `+(pattern-list)` | 1 atau lebih kemunculan | `+(jpg\|png)` | `jpg`, `png`, `jpgpng`, `pngjpg`, ... |
| `@(pattern-list)` | Tepat satu pilihan | `@(jpg\|png)` | `jpg`, `png` (bukan `jpgpng`) |
| `!(pattern-list)` | Tidak cocok dengan pola | `!(tmp\|bak)` | Semua file kecuali `tmp`, `bak` |

**Pemisah pattern-list:** Di Bash, gunakan `|` (pipe), dan **harus di-escape** jika berada di luar `[[ ]]`: `@(jpg|png)` di dalam `[[ ]]`, tetapi `@(jpg\|png)` di command line.

**Contoh:**

```bash
shopt -s extglob

# Semua file kecuali .bak dan .tmp
echo !(*.bak|*.tmp)

# File dengan 0 atau 1 'a' di awal
echo ?(a)*.txt

# File dengan satu atau lebih digit
echo +([0-9]).txt
```

**Perhatian penting:** Extended globbing **bukan** brace expansion. Brace expansion `{a,b}` adalah tahap terpisah yang terjadi sebelum globbing. Extended globbing `@(a|b)` adalah bagian dari globbing.

### 4.5 Opsi Shell yang Mempengaruhi Globbing

| Opsi | Efek | Contoh |
|---|---|---|
| `shopt -s dotglob` | `*` juga cocok dengan file berawalan `.` | `echo *` menampilkan `.bashrc` |
| `shopt -s nullglob` | Jika tidak ada match, pola dihapus (jadi array kosong) | `for f in *.zzz` → tidak ada iterasi |
| `shopt -s failglob` | Jika tidak ada match, Bash error dan hentikan perintah | `echo *.zzz` → error, skrip berhenti |
| `shopt -s globstar` | Aktifkan `**` untuk match rekursif | `echo **/*.txt` |
| `shopt -s nocaseglob` | Globbing case-insensitive | `*.TXT` cocok dengan `a.txt` |
| `shopt -s extglob` | Aktifkan extended globbing | `!(...)*` |
| `shopt -s globasciiranges` | Range `[a-z]` mengikuti ASCII (bukan locale) | `[a-z]` hanya a-z |
| `shopt -s globskipdots` | `*` tidak cocok dengan `.` dan `..` (default di Bash 5.2+) | `echo .*` tidak termasuk `.` dan `..` |
| `set -f` / `set -o noglob` | Nonaktifkan globbing sepenuhnya | `echo *` → literal `*` |
| `GLOBIGNORE` | Daftar pola yang dikecualikan dari hasil glob | `GLOBIGNORE=*.bak; echo *` |

**Contoh perilaku `nullglob` vs `failglob`:**

```bash
# Default: jika tidak ada match, pola tetap ditampilkan
echo *.zzz              # *.zzz

# nullglob: hapus pola jika tidak ada match
shopt -s nullglob
echo *.zzz              # (kosong)

# failglob: error jika tidak ada match
shopt -s failglob
echo *.zzz              # bash: no match: *.zzz  (dan skrip berhenti jika set -e)
```

**Mengapa `nullglob` penting?** Tanpa `nullglob`, loop `for f in *.txt; do ...; done` akan tetap berjalan satu kali dengan `$f = "*.txt"` jika tidak ada file `.txt`. Ini sering menyebabkan bug yang sulit dilacak. Dengan `nullglob`, loop tidak berjalan sama sekali.

**Mengapa `globstar` penting?** Tanpa `globstar`, `**` diperlakukan sebagai `*` (dua kali). Dengan `globstar`, `**` cocok dengan semua file dan direktori secara rekursif:

```bash
shopt -s globstar
echo **/*.txt    # semua .txt di direktori saat ini dan subdirektori
```

### 4.6 Dotfiles dan Globbing

Secara default, `*` dan `?` **tidak** cocok dengan file yang diawali titik (`.bashrc`, `.git`, `.config`). Ini adalah konvensi Unix: file dengan awalan `.` dianggap "tersembunyi".

Untuk memasukkannya:

```bash
# Cara 1: aktifkan dotglob
shopt -s dotglob
echo *          # termasuk .bashrc

# Cara 2: pola eksplisit
echo .*         # semua dotfile (termasuk . dan .. jika tidak ada globskipdots)
echo .??*       # dotfile minimal 3 karakter (kecuali . dan ..)

# Cara 3: GLOBIGNORE
GLOBIGNORE=".:.."
echo .*         # tanpa . dan ..
```

**Catatan:** `.` dan `..` selalu ada di setiap direktori. Pola `.*` akan mencocokkannya kecuali Anda menggunakan `globskipdots` (Bash 5.2+) atau `GLOBIGNORE`.

### 4.7 Quoting Menonaktifkan Globbing

Ini adalah konsep yang sangat penting dan sering terlewat:

```bash
echo *.txt      # globbing aktif
echo "*.txt"    # literal "*.txt"
echo '*.txt'    # literal "*.txt"
echo \*.txt     # literal "*.txt"
echo "*"".txt"  # literal "*.txt" (kutipan terpisah)
```

**Mengapa ini penting?** Ketika Anda menulis skrip yang menerima input dari pengguna, Anda **tidak** ingin input tersebut di-glob. Misalnya:

```bash
read -p "Masukkan pola: " pattern
echo $pattern    # BAHAYA: jika pattern = "*.txt", akan di-glob
echo "$pattern"  # AMAN: literal
```

### 4.8 Batas Argumen (`ARG_MAX`)

Jika glob menghasilkan terlalu banyak file, shell bisa gagal dengan error `Argument list too long`. Ini karena ada batas kernel pada ukuran total argumen (`ARG_MAX`, biasanya 2 MB di Linux modern).

**Solusi:**

```bash
# Cara 1: find + xargs
find . -name '*.log' -print0 | xargs -0 rm

# Cara 2: find + -exec ... +
find . -name '*.log' -exec rm {} +

# Cara 3: loop dengan find -print0
while IFS= read -r -d '' f; do
  rm -- "$f"
done < <(find . -name '*.log' -print0)
```

**Mengapa `-print0` dan `-0`?** Karena nama file bisa berisi newline. `-print0` memisahkan nama file dengan NUL (`\0`), dan `xargs -0` membaca pemisah NUL. Ini adalah cara paling aman untuk menangani nama file arbitrer.

### 4.9 Globbing Lintas Platform

| Pola | Bash/Zsh | PowerShell | CMD (Windows) |
|---|---|---|---|
| `*` | 0+ karakter, kecuali `/` dan leading `.` | 0+ karakter | 0+ karakter |
| `?` | Tepat 1 karakter | Tepat 1 karakter | Tepat 1 karakter |
| `[abc]` | Ya | Ya | Ya |
| `[a-z]` | Ya | Ya | Ya |
| `[!abc]` | Ya | Ya | Ya |
| `{a,b}` | Brace expansion (bukan glob) | Tidak ada | Tidak ada |
| `**` rekursif | Ya, dengan `globstar` | Tidak ada; gunakan `-Recurse` | Tidak ada; gunakan `dir /s` |
| `!(pattern)` | Ya, dengan `extglob` | Tidak ada; gunakan `-notlike` | Tidak ada |

**Koreksi penting untuk PowerShell:** `**` **bukan** wildcard di PowerShell. Rekursi dilakukan dengan parameter `-Recurse`:

```powershell
Get-ChildItem -Recurse -Filter *.txt
```

**CMD:** `dir /s *.txt` untuk rekursif. CMD tidak memiliki wildcard `**`.

**PowerShell wildcard** mengikuti **.NET wildcard**, yang mirip tetapi tidak identik dengan POSIX. Misalnya, PowerShell tidak mendukung `[!...]` (menggunakan `[^...]`), dan tidak mendukung brace expansion.

### 4.10 Globbing vs Regex — Perbedaan Fundamental

| Aspek | Globbing | Regex |
|---|---|---|
| Tujuan | Cocokkan **nama file** | Cocokkan **teks** (umum) |
| Dilakukan oleh | Shell (sebelum eksekusi) | Program (saat runtime) |
| Simbol | `*`, `?`, `[...]` | `.`, `*`, `+`, `?`, `{n,m}`, `(...)`, `^`, `$`, dll. |
| `*` artinya | 0 atau lebih karakter | 0 atau lebih dari **karakter sebelumnya** |
| `?` artinya | Tepat 1 karakter | 0 atau 1 dari **karakter sebelumnya** |
| Kekuatan | Sederhana | Sangat fleksibel |
| Akses filesystem | Ya | Tidak |

**Contoh perbedaan:**

- Globbing: `*.txt` cocok dengan `a.txt`, `b.txt`, `abc.txt`.
- Regex: `.*\.txt` cocok dengan hal yang sama, tetapi `.` dan `*` punya arti berbeda.
- Regex: `^a.*\.txt$` cocok dengan `a.txt`, `abc.txt`, tetapi tidak `b.txt`.

**Kesalahan umum:** Menganggap `*.txt` di regex sama dengan di globbing. Di regex, `*.txt` berarti "nol atau lebih titik, diikuti karakter apa pun, diikuti `txt`" — bukan "file dengan ekstensi .txt".

### 4.11 Globbing dan Urutan Hasil

Hasil glob diurutkan **secara leksikografis** berdasarkan locale. Di locale `C`/`POSIX`, urutannya berdasarkan byte ASCII:

```bash
touch a.txt B.txt 1.txt
echo *.txt
# Output: 1.txt B.txt a.txt   (ASCII: '1' < 'B' < 'a')
```

Di locale lain (misalnya `en_US.UTF-8`), urutannya bisa berbeda (case-insensitive, atau berdasarkan aturan bahasa). Untuk hasil yang dapat diprediksi, set `LC_ALL=C`:

```bash
LC_ALL=C echo *.txt
```

**Catatan:** Urutan leksikografis berarti `file10.txt` muncul **sebelum** `file2.txt`, karena `'1' < '2'`. Ini sering mengejutkan pemula. Untuk urutan numerik, gunakan `sort -V` atau `ls -v`.

---

## **5. Pattern Matching (Lebih Luas dari Globbing)**

### 5.1 Definisi Formal

**Pattern matching** adalah konsep umum: mencocokkan data (string, angka, struktur) terhadap suatu pola yang didefinisikan oleh aturan tertentu. Globbing adalah **salah satu** bentuk pattern matching (khusus nama file). Ada banyak jenis pattern matching lain, masing-masing dengan sintaks dan kegunaan berbeda.

**Perbedaan kunci dengan globbing:** Pattern matching **tidak menyentuh filesystem**. Ia mencocokkan **nilai** (string, angka, struktur), bukan nama file.

### 5.2 Jenis Pattern Matching

| Jenis | Contoh Bahasa/Alat | Pola | Lingkup |
|---|---|---|---|
| **String matching sederhana** | `case` di Bash/Zsh, `switch` di Dart/Lua | `*.txt`, `foo?bar` | Mencocokkan teks terhadap pola wildcard |
| **Globbing (filename matching)** | Bash/Zsh, PowerShell | `*`, `?`, `[a-z]` | Mencari file yang cocok di filesystem |
| **Regex (regular expression)** | `grep`, `sed`, Dart `RegExp`, Lua `string.match` | `^foo.*bar$` | Mencocokkan pola teks kompleks |
| **Structural pattern matching** | Python `match/case`, Dart `switch` dengan destructuring | `case [x, y]:` | Mencocokkan bentuk/struktur data |
| **Wildcard PowerShell** | PowerShell cmdlet | `*.ps1` | Mirip globbing tetapi dijalankan di cmdlet, bukan shell |

### 5.3 Pattern Matching di Bash: `[[ ]]`

Di dalam `[[ ... ]]`, operator `==`, `!=`, dan `=~` melakukan pattern matching pada **string**, tanpa menyentuh filesystem.

**Operator `==` dan `!=` (wildcard glob):**

```bash
name="report.txt"
[[ $name == *.txt ]] && echo "File teks"
[[ $name != *.md ]] && echo "Bukan markdown"
```

**Aturan quoting:**

```bash
pattern="*.txt"
[[ $name == $pattern ]]     # pattern matching ✅ (variabel tidak dikutip → pattern)
[[ $name == "$pattern" ]]   # literal ✅ (variabel dikutip → literal "*.txt")
```

Ini adalah salah satu dari sedikit kasus di mana **tidak mengutip variabel** adalah hal yang benar. Jika Anda ingin pattern matching, jangan kutip pattern. Jika Anda ingin perbandingan literal, kutip.

**Operator `=~` (regex ERE):**

```bash
if [[ "$name" =~ ^[a-z]+\.(txt|md)$ ]]; then
  echo "Cocok"
fi
```

**Capture group via `BASH_REMATCH`:**

```bash
[[ "2024-01-15" =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]
echo "Tahun: ${BASH_REMATCH[1]}"   # 2024
echo "Bulan: ${BASH_REMATCH[2]}"   # 01
echo "Hari:  ${BASH_REMATCH[3]}"   # 15
echo "Match: ${BASH_REMATCH[0]}"   # 2024-01-15
```

**Penting tentang regex di Bash:**

- Regex di Bash adalah **ERE** (Extended Regular Expression), bukan PCRE. Tidak ada `\d`, `\w`, lookahead, atau fitur PCRE lainnya.
- Jangan mengutip regex, kecuali bagian yang literal: `[[ $x =~ "^abc" ]]` mencari literal `^abc` (bukan awal string).
- Untuk case-insensitive: `shopt -s nocasematch`.
- Regex dengan spasi harus dikutip: `[[ $x =~ "foo bar" ]]`.

**Extglob di `[[ ]]`:**

Jika `extglob` aktif, Anda bisa memakai `?(...)`, `*(...)`, `+(...)`, `@(...)`, `!(...)` di dalam `[[ ]]` juga:

```bash
shopt -s extglob
[[ $name == +(foo|bar).txt ]] && echo "cocok"
```

### 5.4 Pattern Matching di `case`

Statement `case` menggunakan pattern matching gaya globbing. Ini adalah alternatif yang lebih bersih daripada serangkaian `if/elif/else` panjang.

**Sintaks:**

```bash
case "$variabel" in
  pola1) perintah1 ;;
  pola2|pola3) perintah2 ;;
  *) default ;;
esac
```

**Contoh:**

```bash
case "$file" in
  *.txt|*.md)  echo "Teks" ;;
  *.jpg|*.png) echo "Gambar" ;;
  *.tar.gz)    echo "Arsip" ;;
  *)           echo "Lainnya" ;;
esac
```

**Fitur lanjutan (Bash 4+):**

- `;;` — akhiri blok (default).
- `;&` — lanjut ke blok berikutnya **tanpa** mengecek pola (fall-through).
- `;;&` — lanjut mengecek pola berikutnya.

```bash
case "$x" in
  a) echo "a" ;&     # lanjut ke blok berikutnya tanpa cek pola
  b) echo "b" ;;&    # lanjut cek pola berikutnya
  c) echo "c" ;;
esac
```

**Perbedaan `case` dengan `[[ ]]`:**

- `case` lebih efisien untuk banyak pola (tidak perlu `elif` berulang).
- `case` mendukung multiple pattern dengan `|`.
- `case` **tidak** mendukung regex (hanya wildcard glob).
- `case` **tidak** mendukung `&&`/`||` di dalam pattern.

### 5.5 Pattern Matching di Zsh

Zsh memiliki pattern matching yang lebih kuat daripada Bash:

- **Extended glob aktif secara default** (tidak perlu `setopt extendedglob` untuk fitur dasar).
- **Negasi pattern:** `^pattern` untuk "tidak cocok dengan pattern".
- **Pengecualian:** `~` untuk mengecualikan.
- **Glob qualifier:** `*(.)` untuk file biasa, `*(/)` untuk direktori, `*(@)` untuk symlink.

```zsh
# Semua file kecuali .jpg dan .png
ls ^(*.jpg|*.png)

# File .txt kecuali yang diawali 'tmp'
ls *.txt~tmp*

# Semua direktori
ls *(/)
```

### 5.6 Pattern Matching Lintas Bahasa

**Bash:**

```bash
file="report.txt"
if [[ $file == *.txt ]]; then
    echo "File teks"
fi
```

**Zsh:**

```zsh
setopt extendedglob
[[ $file == ^(*.jpg|*.png) ]] && echo "Bukan gambar"
```

**PowerShell:**

```powershell
if ("report.txt" -like "*.txt") { "File teks" }
if ("report.txt" -match "^[a-z]+\.txt$") { "Cocok regex" }
```

PowerShell memiliki dua operator:
- `-like` — wildcard .NET (mirip globbing).
- `-match` — regex .NET.

**Dart 3+:**

```dart
void check(Object value) {
  switch (value) {
    case int n when n > 0:
      print("Positif");
    case String s when s.endsWith('.txt'):
      print("Teks file");
    case [int x, int y]:
      print("Koordinat: $x, $y");
    default:
      print("Tidak cocok");
  }
}
```

Dart 3+ mendukung **structural pattern matching** dengan destructuring, guard clause (`when`), dan tipe literal.

**Lua:**

```lua
if string.match("report.txt", "%.txt$") then
    print("File teks")
end
```

Lua patterns **bukan** regex penuh. Tidak ada alternasi `|`, tidak ada quantifier `{n,m}`. Escape menggunakan `%` bukan `\`.

### 5.7 Perbandingan Globbing vs Pattern Matching vs Regex

| Fitur | Globbing | Pattern Matching (`[[ ]]`) | Regex (`=~`) |
|---|---|---|---|
| Eksekusi | Shell, sebelum perintah | Shell, tanpa filesystem | Shell atau program |
| Lingkup | Nama file/path | String | String |
| Simbol | `*`, `?`, `[...]`, `{...}` (brace expansion terpisah) | Sama | `^`, `$`, `.`, `*`, `+`, `?`, `{n,m}`, `(...)` |
| Kekuatan | Sederhana | Sedang | Paling fleksibel |
| Akses filesystem | Ya | Tidak | Tidak |
| Case-insensitive | `nocaseglob` | `nocasematch` | Flag `(?i)` (tidak di Bash ERE) |

### 5.8 Structural Pattern Matching (Referensi)

Beberapa bahasa modern mendukung **structural pattern matching**, di mana pola dapat mencocokkan **bentuk** data, bukan hanya nilai:

**Python 3.10+:**

```python
match value:
    case [x, y]:
        print(f"List dengan 2 elemen: {x}, {y}")
    case {"name": name, "age": age}:
        print(f"Dict: {name}, {age}")
    case int(n) if n > 0:
        print(f"Positif: {n}")
    case _:
        print("Tidak cocok")
```

**Rust:**

```rust
match value {
    Some(x) => println!("Ada: {}", x),
    None => println!("Kosong"),
    Point { x, y } => println!("Point: {}, {}", x, y),
}
```

**Dart 3+:** (lihat contoh di §5.6)

Structural pattern matching adalah konsep yang lebih luas dari globbing, dan biasanya digunakan untuk memproses struktur data kompleks (list, map, object).

---

## **6. Short-Circuiting**

### 6.1 Definisi Formal

**Short-circuiting** adalah mekanisme evaluasi logika di mana ekspresi berhenti dievaluasi lebih awal begitu hasilnya bisa ditentukan, tanpa memeriksa sisa operasinya. Ini adalah konsep universal di hampir semua bahasa pemrograman, tetapi implementasinya berbeda-beda.

### 6.2 Mengapa Short-Circuiting Penting?

Short-circuiting bukan sekadar optimasi. Ia memiliki **implikasi semantik**:

1. **Efisiensi:** Menghindari evaluasi yang tidak perlu.
2. **Keamanan:** Mencegah error yang tidak perlu. Contoh: `[[ -n "$var" && -f "$var" ]]` — jika `$var` kosong, `-f ""` tidak dievaluasi (yang bisa jadi error).
3. **Guard clause:** Memungkinkan pola seperti `user != null && user.isLoggedIn`.
4. **Kontrol alur:** Di shell, `cmd1 && cmd2` adalah cara ringkas untuk "jalankan `cmd2` hanya jika `cmd1` sukses".

### 6.3 Operator dan Perilaku

| Operator | Nama | Perilaku Short-Circuit |
|---|---|---|
| `&&` | AND | Jika kiri false → kanan **tidak** dievaluasi |
| `\|\|` | OR | Jika kiri true → kanan **tidak** dievaluasi |

### 6.4 Dua Konteks Berbeda di Bash

**Konteks 1 — Command list (di luar `[[ ]]`):**

Di sini, `&&` dan `||` adalah **list operator** yang bekerja berdasarkan **exit status** perintah. Mereka bukan operator boolean.

```bash
mkdir -p dir && cd dir && touch file
# cd hanya jalan jika mkdir sukses
# touch hanya jalan jika cd sukses
```

**Konteks 2 — Logical operator di dalam `[[ ]]`:**

Di sini, `&&` dan `||` adalah **operator boolean** yang bekerja pada ekspresi kondisional.

```bash
[[ -f file && -r file ]] && echo "Ada dan bisa dibaca"
```

**Perbedaan krusial:** Jangan campur! `[ -f file && -r file ]` **salah** — `&&` tidak dikenal oleh `[`. Gunakan `[ -f file ] && [ -r file ]` atau `[[ -f file && -r file ]]`.

### 6.5 Precedence dan Asosiatif

Di Bash, `&&` dan `||` memiliki **precedence sama** dan **left-associative**:

```bash
cmd1 || cmd2 && cmd3
# Dievaluasi sebagai: (cmd1 || cmd2) && cmd3
```

Ini sering mengejutkan pemula. Untuk kejelasan, gunakan `{ ...; }` atau `( ... )`:

```bash
{ cmd1 || cmd2; } && cmd3
```

**Catatan:** `{ ...; }` menjalankan perintah di shell saat ini; `( ... )` menjalankan di subshell. Untuk grouping sederhana, `{ ...; }` lebih efisien.

### 6.6 Interaksi dengan `set -e`

Dengan `set -e`, skrip berhenti saat ada perintah gagal. Namun:

```bash
set -e
cmd1 && cmd2    # jika cmd1 gagal, skrip TIDAK berhenti (bagian dari &&)
```

Ini karena `set -e` mengabaikan perintah yang merupakan bagian dari `&&`, `||`, `if`, `while`, atau `until`. Perilaku ini sering membingungkan, tetapi disengaja: `cmd1 && cmd2` adalah satu unit logika, jadi kegagalan `cmd1` tidak dianggap "error yang tidak tertangani".

### 6.7 Contoh Lintas Bahasa

| Bahasa | AND | OR | Perilaku |
|---|---|---|---|
| Bash | `&&` | `\|\|` | Exit status |
| Zsh | `&&` | `\|\|` | Exit status |
| PowerShell | `-and` | `-or` | Boolean murni |
| Dart | `&&` | `\|\|` | Boolean murni |
| JavaScript | `&&` | `\|\|` | Mengembalikan operand |
| Lua | `and` | `or` | Mengembalikan operand |
| Python | `and` | `or` | Mengembalikan operand |

**JavaScript mengembalikan operand, bukan boolean:**

```javascript
const x = null && foo();   // x = null, foo() tidak dipanggil
const y = "a" || "b";      // y = "a" (truthy)
const z = 0 || "default";  // z = "default" (0 falsy)
```

**Lua juga:**

```lua
local x = false and print("tidak jalan")   -- x = false
local y = "a" or "b"                       -- y = "a"
local z = nil or "default"                 -- z = "default"
```

**PowerShell boolean murni:**

```powershell
$false -and (Write-Host "tidak jalan")   # $false
$true  -or  (Write-Host "tidak jalan")   # $true
```

### 6.8 Pola Guard Clause

Guard clause adalah pola di mana short-circuit digunakan untuk mencegah error atau memvalidasi kondisi sebelum operasi yang lebih kompleks:

```bash
# Bash: source config hanya jika ada
[[ -f "$config" ]] && source "$config"

# Bash: cek variabel sebelum digunakan
[[ -n "$var" && -f "$var" ]] && process "$var"

# Dart: null-safe
user != null && user.isLoggedIn

# Lua: null-safe
user and user.loggedIn

# PowerShell
if ($user -and $user.IsLoggedIn) { ... }

# Python
if user and user.is_logged_in: ...
```

### 6.9 Null-Coalescing dan Optional Chaining

Beberapa bahasa memiliki operator khusus untuk null-check yang lebih ringkas:

- **Dart/JS:** `??` (null-coalescing), `?.` (optional chaining).
- **PowerShell 7+:** `??`, `?.`.
- **Lua:** `a or default` (idiom).
- **Bash:** `${var:-default}`, `${var:=default}`, `${var:?error}`.

**Bash parameter expansion untuk default:**

```bash
echo "${var:-default}"    # gunakan default jika var unset atau kosong
echo "${var:=default}"    # assign default jika var unset atau kosong
echo "${var:?error msg}"  # error jika var unset atau kosong
echo "${var:+alternate}"  # gunakan alternate jika var di-set
```

### 6.10 Kesalahan Umum Short-Circuiting

| Kesalahan | Contoh | Masalah | Solusi |
|---|---|---|---|
| Campur `[ ]` dengan `&&` | `[ -f x && -r x ]` | `&&` tidak dikenal `[` | `[ -f x ] && [ -r x ]` atau `[[ -f x && -r x ]]` |
| Precedence `&&`/`\|\|` | `a \|\| b && c` | Dievaluasi `(a \|\| b) && c` | Gunakan `{ ...; }` |
| Mengira `set -e` berlaku | `set -e; a && b` | Tidak berhenti jika `a` gagal | Sadari perilaku ini |
| Side-effect tidak diinginkan | `a && b` di mana `b` punya efek samping | Jika `a` gagal, `b` tidak jalan | Pastikan ini yang diinginkan |

---

## **7. Kontrol Alur: Kondisional, Perulangan, Fungsi**

### **7.1 Struktur Kondisional**

#### 7.1.1 Exit Codes (`$?`) — Filosofi Unix

Dalam filosofi Unix, setiap program dirancang untuk melakukan **satu hal dengan baik**, dan hasilnya dikomunikasikan melalui **exit status** setelah eksekusi selesai. Exit status adalah angka 0–255:

- **`0`** — sukses, tidak ada kesalahan.
- **`1`–`125`** — kegagalan yang ditentukan program.
- **`126`** — perintah tidak dapat dieksekusi.
- **`127`** — perintah tidak ditemukan.
- **`128`–`255`** — kegagalan yang berhubungan dengan sinyal (`128 + N`, di mana `N` adalah nomor sinyal).

**Mengapa ini penting?** Ini adalah antarmuka yang sangat sederhana namun kuat. Daripada mem-parsing output teks untuk mencari tahu apakah perintah berhasil, Anda cukup memeriksa exit status. Ini adalah fondasi dari *error handling* dalam shell scripting.

```bash
echo "hi"
echo "Exit: $?"        # 0

ls /tidak/ada 2>/dev/null
echo "Exit: $?"        # 2 (atau non-nol)

command_yang_tidak_ada 2>/dev/null
echo "Exit: $?"        # 127
```

**Variabel khusus `$?`:** Menyimpan exit status dari perintah terakhir yang dieksekusi. Penting: `$?` harus segera diperiksa, karena perintah berikutnya akan menimpanya.

#### 7.1.2 Struktur `if ... then ... fi`

```bash
if perintah; then
  # dijalankan jika perintah sukses (exit 0)
elif perintah_lain; then
  # jika kondisi pertama gagal dan ini sukses
else
  # jika semua gagal
fi
```

**Penjelasan:**

- `if` memulai blok kondisional.
- `then` menandai awal blok yang dijalankan jika kondisi benar.
- `elif` (else if) menambahkan percabangan baru.
- `else` dijalankan jika semua kondisi salah.
- `fi` menutup blok (`if` terbalik).

**Penting:** `then` bisa berada di baris yang sama dengan `if` (dipisahkan `;`) atau di baris berikutnya. `fi` harus ada.

```bash
# Gaya 1
if [[ -f "$file" ]]; then
  echo "Ada"
fi

# Gaya 2 (lebih ringkas)
if [[ -f "$file" ]]; then echo "Ada"; fi

# Gaya 3 (multi-line)
if [[ -f "$file" ]]
then
  echo "Ada"
fi
```

#### 7.1.3 `[ ]` vs `[[ ]]` — Perbedaan Mendalam

| Aspek | `[ ]` (test) | `[[ ]]` (keyword) |
|---|---|---|
| Tipe | Perintah eksternal (atau builtin) | Keyword Bash |
| POSIX | Ya | Tidak (Bash/Zsh saja) |
| Quoting | Wajib hati-hati | Tidak wajib |
| Pattern matching | Tidak | Ya (`==`, `!=`) |
| Regex | Tidak | Ya (`=~`) |
| `&&`, `\|\|` di dalam | Tidak | Ya |
| Word splitting | Rentan | Aman |
| `<`, `>` | Harus di-escape (`\>`) | Tidak perlu |
| `(` `)` grouping | Tidak | Ya |
| Rekomendasi | Hanya untuk POSIX | **Gunakan ini di Bash** |

**Mengapa `[ ]` rentan?** Karena `[` adalah perintah, argumennya melalui word splitting dan globbing. Jika variabel kosong atau berisi spasi, hasilnya bisa kacau:

```bash
file=""
[ -f $file ]    # menjadi [ -f ], yang error
[ -f "$file" ]  # benar
[[ -f $file ]]  # benar (tidak di-split)
```

**Mengapa `[[ ]]` lebih aman?** Karena `[[` adalah keyword, Bash memprosesnya secara internal tanpa word splitting atau globbing pada variabel.

**Kapan menggunakan `[ ]`?** Hanya jika Anda menulis skrip yang harus kompatibel dengan POSIX `sh` (misalnya, skrip yang akan dijalankan oleh `dash`, `ash`, atau `sh` di sistem yang tidak punya Bash). Untuk skrip Bash, selalu gunakan `[[ ]]`.

#### 7.1.4 Operator Perbandingan

**String:**

| Operator | Arti | Contoh |
|---|---|---|
| `==` | Sama | `[[ "$a" == "b" ]]` |
| `!=` | Tidak sama | `[[ "$a" != "b" ]]` |
| `<`, `>` | Leksikografis | `[[ "$a" < "$b" ]]` |
| `-z` | Kosong (panjang 0) | `[[ -z "$a" ]]` |
| `-n` | Tidak kosong | `[[ -n "$a" ]]` |
| `=~` | Regex (hanya `[[ ]]`) | `[[ "$a" =~ ^[0-9]+$ ]]` |

**Angka (disarankan pakai `(( ))`):**

```bash
if (( a > b )); then ...
```

Atau dengan operator numerik:

| Operator | Arti |
|---|---|
| `-eq` | Sama |
| `-ne` | Tidak sama |
| `-gt` | Lebih besar |
| `-ge` | Lebih besar atau sama |
| `-lt` | Kurang |
| `-le` | Kurang atau sama |

**Mengapa `(( ))` lebih baik untuk angka?**

- `(( ))` menggunakan sintaks aritmatika C-like (`>`, `<`, `==`, `!=`), yang lebih intuitif.
- `(( ))` mengembalikan exit status 0 jika ekspresi **bukan nol**, dan 1 jika nol. Ini berarti `(( 0 ))` adalah "false", dan `(( 1 ))` adalah "true".
- `(( ))` mendukung operator aritmatika penuh (`+`, `-`, `*`, `/`, `%`, `**`, `<<`, `>>`, `&`, `|`, `^`, dll.).

**Perbandingan string vs angka — jebakan umum:**

```bash
a=10
b=2

[[ "$a" > "$b" ]]   # TRUE (leksikografis: "10" < "2"? Tidak, "1" < "2", jadi "10" < "2" → FALSE... tunggu)
# Sebenarnya: "10" > "2" secara leksikografis? Bandingkan karakter pertama: '1' vs '2'.
# '1' (ASCII 49) < '2' (ASCII 50), jadi "10" < "2". Maka [[ "$a" > "$b" ]] = FALSE.
# Ini SALAH secara numerik (10 > 2).

(( a > b ))         # TRUE (numerik: 10 > 2) ✅
```

Ini adalah salah satu bug paling umum dalam shell scripting. **Selalu gunakan `(( ))` untuk perbandingan angka.**

**File:**

| Operator | Arti |
|---|---|
| `-e` | Ada (file/direktori) |
| `-f` | File biasa |
| `-d` | Direktori |
| `-s` | Ukuran > 0 |
| `-r` | Bisa dibaca |
| `-w` | Bisa ditulis |
| `-x` | Bisa dieksekusi |
| `-L` / `-h` | Symlink |
| `-p` | Named pipe (FIFO) |
| `-S` | Socket |
| `-b` | Block device |
| `-c` | Character device |
| `-t FD` | File descriptor adalah terminal |
| `-v` | Variabel terdefinisi (Bash 4.2+) |
| `-o` | Opsi shell aktif |

**Perbandingan file:**

| Operator | Arti |
|---|---|
| `file1 -nt file2` | file1 lebih baru dari file2 |
| `file1 -ot file2` | file1 lebih lama dari file2 |
| `file1 -ef file2` | file1 dan file2 adalah file yang sama (hard link) |

#### 7.1.5 Menggabungkan Kondisi

```bash
# Cara 1: di dalam [[ ]]
if [[ -f "$f" && -r "$f" ]]; then ...

# Cara 2: command list
if [ -f "$f" ] && [ -r "$f" ]; then ...

# Cara 3: OR
if [[ "$u" == "root" || "$g" == "admin" ]]; then ...

# Cara 4: negasi
if [[ ! -f "$f" ]]; then ...
```

**Short-circuit di dalam `[[ ]]`:** Sama seperti di luar, `&&` dan `||` di dalam `[[ ]]` juga short-circuit.

#### 7.1.6 `case ... esac`

`case` adalah struktur kontrol yang digunakan untuk mencocokkan **satu nilai** dengan **beberapa pola**. Ia lebih bersih dan seringkali lebih efisien daripada serangkaian `if/elif/else` yang panjang.

**Sintaks:**

```bash
case "$variabel" in
  pola1) perintah1 ;;
  pola2|pola3) perintah2 ;;
  *) default ;;
esac
```

**Penjelasan:**

- `case "$variabel" in` — memulai blok `case`.
- `pola)` — pola yang akan dicocokkan.
- `;;` — mengakhiri blok untuk pola tersebut (mencegah fall-through).
- `esac` — menutup blok `case` (`case` terbalik).

**Contoh:**

```bash
case "$aksi" in
  start)   echo "Memulai..." ;;
  stop)    echo "Menghentikan..." ;;
  restart) echo "Restart..." ;;
  *)       echo "Penggunaan: $0 {start|stop|restart}"; exit 1 ;;
esac
```

**Fall-through (Bash 4+):**

```bash
case "$x" in
  a) echo "a" ;&     # lanjut ke blok berikutnya tanpa cek pola
  b) echo "b" ;;&    # lanjut cek pola berikutnya
  c) echo "c" ;;
esac
```

**Kapan menggunakan `case`?**

- Ketika Anda membandingkan **satu variabel** dengan **banyak nilai**.
- Ketika Anda perlu mencocokkan **pola** (misalnya `*.txt`).
- Ketika Anda ingin kode yang lebih bersih daripada `if/elif` berulang.

#### 7.1.7 Ternary di Bash

Bash tidak punya operator ternary `?:` seperti C. Namun, ada beberapa idiom:

```bash
# Arithmetic ternary
result=$(( a > b ? a : b ))

# Short-circuit idiom
[[ $x -gt 0 ]] && echo "positif" || echo "non-positif"

# Parameter expansion
echo "${var:+set}"    # "set" jika var di-set, kosong jika tidak
```

**Peringatan tentang short-circuit idiom:** `[[ $x -gt 0 ]] && echo "positif" || echo "non-positif"` **tidak** sama dengan ternary yang sebenarnya. Jika `echo "positif"` gagal, `echo "non-positif"` akan dijalankan. Untuk keandalan, gunakan `if/else`.

#### 7.1.8 `set -euo pipefail` — Praktik Robust

```bash
set -e          # berhenti pada error (errexit)
set -u          # error jika variabel belum didefinisikan (nounset)
set -o pipefail # pipe gagal jika salah satu komponen gagal
```

Atau digabung: `set -euo pipefail`.

**Penjelasan:**

- **`set -e`** — skrip berhenti jika ada perintah yang mengembalikan exit status non-nol. Pengecualian: perintah di dalam `if`, `while`, `until`, `&&`, `||`, `!`.
- **`set -u`** — skrip error jika menggunakan variabel yang belum didefinisikan. Ini mencegah bug seperti `rm -rf "$UNDEFINED/"` yang menjadi `rm -rf /`.
- **`set -o pipefail`** — exit status pipe adalah exit status perintah terakhir yang gagal. Tanpa ini, `cmd1 | cmd2` mengembalikan exit status `cmd2`, bahkan jika `cmd1` gagal.

**Peringatan:** `set -e` tidak selalu berperilaku seperti yang diharapkan. Ini adalah topik kontroversial di komunitas Bash. Beberapa ahli merekomendasikan untuk **tidak** menggunakan `set -e`, dan sebagai gantinya menangani error secara eksplisit. Namun, untuk skrip sederhana, `set -euo pipefail` adalah awal yang baik.

**Cleanup dengan `trap`:**

```bash
#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Bekerja di $tmpdir"
# ... kerja ...
# tmpdir otomatis dihapus saat skrip keluar (normal atau error)
```

---

### **7.2 Perulangan**

#### 7.2.1 Filosofi Otomasi Berulang

Perulangan adalah pilar fundamental otomasi. Daripada menjalankan perintah yang sama secara manual berulang kali, Anda dapat menginstruksikan shell untuk melakukannya untuk Anda. Ini menghemat waktu, mengurangi kesalahan manusia, dan meningkatkan efisiensi.

Prinsip **DRY (Don't Repeat Yourself)** berlaku: jika Anda menemukan diri Anda menulis kode yang sama berulang kali dengan sedikit variasi, itu adalah tanda bahwa perulangan (atau fungsi) diperlukan.

#### 7.2.2 `for` Berbasis Daftar

**Sintaks:**

```bash
for VAR in item1 item2 item3; do
  # perintah
done
```

**Contoh:**

```bash
for buah in apel jeruk mangga; do
  echo "Suka $buah"
done

# Dari glob (aman untuk nama dengan spasi)
for f in *.txt; do
  [[ -f "$f" ]] || continue
  cp "$f" "$f.bak"
done

# Dari argumen posisi
for arg in "$@"; do
  echo "$arg"
done
```

**Penting:** Jika tidak ada file yang cocok dengan `*.txt`, loop akan tetap berjalan satu kali dengan `$f = "*.txt"` (kecuali `nullglob` aktif). Untuk menghindari ini, gunakan `shopt -s nullglob` atau cek `[[ -f "$f" ]]`.

#### 7.2.3 `for` Gaya C

**Sintaks:**

```bash
for (( INISIALISASI; KONDISI; PENINGKATAN )); do
  # perintah
done
```

**Contoh:**

```bash
for (( i=0; i<5; i++ )); do
  echo "$i"
done

for (( i=10; i>0; i-=2 )); do
  echo "$i"
done
```

**Koreksi penting:** Variabel `i` **bukan lokal** secara implisit. Ia tetap ada setelah loop:

```bash
for (( i=0; i<3; i++ )); do :; done
echo "$i"   # Output: 3
```

Untuk membuatnya lokal, gunakan `local i` di dalam fungsi.

#### 7.2.4 `while` dan `until`

**`while`** — selama kondisi benar:

```bash
while [[ ! -f "$file" ]]; do
  echo "Menunggu..."
  sleep 5
done
```

**`until`** — sampai kondisi benar:

```bash
until grep -q "READY" "$log"; do
  sleep 2
done
```

**Perbedaan:** `while` berjalan **selama** kondisi benar; `until` berjalan **sampai** kondisi benar. Mereka adalah kebalikan satu sama lain.

**Kapan menggunakan `while` vs `until`?**

- `while` lebih alami untuk kondisi "terus lakukan selama X".
- `until` lebih alami untuk kondisi "terus lakukan sampai X".
- Secara fungsional, keduanya setara: `while ! kondisi` = `until kondisi`.

#### 7.2.5 Membaca File Baris demi Baris

Ini adalah topik yang sangat penting dan sering dilakukan dengan **salah**. Berikut adalah cara yang **benar**:

```bash
# Cara aman (paling direkomendasikan)
while IFS= read -r line; do
  printf '%s\n' "$line"
done < "$file"

# Baca ke array (Bash 4+)
mapfile -t lines < "$file"

# CSV sederhana
while IFS=, read -r nama usia kota; do
  echo "$nama | $usia | $kota"
done < data.csv

# File dengan nama aneh (newline dalam nama file)
find . -maxdepth 1 -print0 | while IFS= read -r -d '' file; do
  printf 'File: %s\n' "$file"
done
```

**Penjelasan mendalam:**

- **`while ... done < file`** — perulangan berjalan di **shell yang sama**, sehingga variabel yang dimodifikasi di dalam loop tetap ada setelah loop. Ini berbeda dengan `cat file | while ...` yang menjalankan `while` di **subshell**.
- **`IFS=`** — mengosongkan `IFS` **hanya untuk perintah `read`**. Ini mencegah `read` memecah baris berdasarkan spasi.
- **`read -r`** — opsi `-r` (*raw*) mencegah `read` menafsirkan backslash sebagai escape.
- **`read -d ''`** — menggunakan NUL sebagai delimiter (untuk nama file dengan newline).
- **`< file`** — input redirection, lebih efisien daripada pipe.

**Catatan tentang CSV:** `IFS=, read` tidak menangani quoted field seperti `"Smith, John"`. Untuk CSV kompleks, gunakan tool khusus (mis. `csvkit`, `python`, `awk` dengan FPAT).

#### 7.2.6 `break` dan `continue` (termasuk `n`)

**`break`** — menghentikan perulangan sepenuhnya:

```bash
for i in {1..10}; do
  [[ $i -eq 5 ]] && break
  echo "$i"
done
```

**`continue`** — melewati sisa iterasi saat ini:

```bash
for i in {1..10}; do
  [[ $((i % 2)) -eq 0 ]] && continue
  echo "$i"   # hanya ganjil
done
```

**`break n` dan `continue n`** — untuk nested loop:

```bash
for i in 1 2 3; do
  for j in a b c; do
    [[ $j == b ]] && break 2   # keluar dari kedua loop
    echo "$i-$j"
  done
done
```

#### 7.2.7 `select` — Menu Interaktif

`select` adalah perulangan khusus untuk membuat menu interaktif sederhana:

```bash
select pilihan in "start" "stop" "keluar"; do
  case "$pilihan" in
    start)   echo "Memulai..." ;;
    stop)    echo "Menghentikan..." ;;
    keluar)  break ;;
    *)       echo "Pilihan tidak valid" ;;
  esac
done
```

**Cara kerja:**

- `select` menampilkan menu bernomor.
- Pengguna memasukkan nomor.
- `$pilihan` diisi dengan item yang sesuai.
- `$REPLY` diisi dengan input mentah.
- Loop berlanjut sampai `break`.

#### 7.2.8 Pitfall Loop

| Pitfall | Contoh | Masalah | Solusi |
|---|---|---|---|
| `for f in $(ls)` | `for f in $(ls)` | Word splitting, nama dengan spasi rusak | `for f in *` |
| `cat file \| while read` | `cat f \| while read l` | Subshell, variabel hilang | `while read l; do ...; done < f` |
| Infinite loop | `while true; do :; done` | Tidak pernah berhenti | Tambahkan kondisi `break` |
| Variabel di loop tidak terlihat | `while read l; do c=$((c+1)); done < f; echo $c` | Sebenarnya ini OK (shell yang sama) | Pastikan tidak pakai pipe |
| Lupa `nullglob` | `for f in *.txt` | Loop jalan dengan `$f="*.txt"` | `shopt -s nullglob` |
| IFS global diubah | `IFS=$'\n'; for ...` | Mempengaruhi semua perintah | Lokalkan `IFS` |

---

### **7.3 Fungsi dan Scoping**

#### 7.3.1 Filosofi DRY

Prinsip **DRY (Don't Repeat Yourself)** adalah filosofi inti di balik fungsi. Jika Anda menulis blok kode yang sama lebih dari satu kali, Anda harus mempertimbangkan untuk mengubahnya menjadi fungsi. Manfaatnya:

- **Maintainability:** Perubahan hanya perlu dilakukan di satu tempat.
- **Readability:** Kode lebih bersih dan mudah dipahami.
- **Reusability:** Fungsi dapat digunakan kembali di skrip lain.
- **Testability:** Fungsi dapat diuji secara terpisah.

#### 7.3.2 Sintaks Deklarasi Fungsi

```bash
# Sintaks 1 (umum)
nama_fungsi() {
  ...
}

# Sintaks 2 (POSIX)
function nama_fungsi {
  ...
}
```

**Perbedaan:** Sintaks 1 adalah POSIX dan lebih portabel. Sintaks 2 adalah Bash/Zsh spesifik. Untuk skrip Bash, keduanya setara.

#### 7.3.3 Argumen

Fungsi menerima argumen lewat `$1`, `$2`, `$@`, `$#`, seperti skrip:

```bash
greet() {
  local nama="$1"
  echo "Halo, $nama"
}
greet "Budi"
```

**Penting:** `$1` di dalam fungsi mengacu pada argumen **fungsi**, bukan argumen skrip. Untuk mengakses argumen skrip dari dalam fungsi, gunakan variabel global atau simpan sebelumnya.

**`shift`** untuk memproses argumen:

```bash
sum() {
  local total=0
  while [[ $# -gt 0 ]]; do
    total=$(( total + $1 ))
    shift
  done
  echo "$total"
}
sum 1 2 3 4   # 10
```

**`$@` vs `$*` di fungsi:** Sama seperti di skrip. Selalu gunakan `"$@"` untuk meneruskan argumen.

#### 7.3.4 Return: Exit Code dan `stdout`

Bash **tidak** mengembalikan nilai via `return` seperti bahasa lain. `return N` hanya mengembalikan **exit status** (0–255). Untuk mengembalikan data, cetak ke `stdout` dan tangkap dengan `$()`:

```bash
dapatkan_tanggal() {
  date +%Y-%m-%d
}
hari_ini=$(dapatkan_tanggal)
```

**Penting:** Pisahkan pesan diagnostik (ke `stderr`) dari data (ke `stdout`):

```bash
log_info() { echo "[INFO] $*" >&2; }
get_value() { echo "42"; }   # stdout
```

**Kesalahan umum:** Mencetak pesan informasi ke `stdout` di dalam fungsi yang seharusnya mengembalikan data. Ini akan mengotori output yang ditangkap.

```bash
# ❌ SALAH
get_file() {
  echo "Mencari file..." >&1   # ini masuk ke stdout!
  echo "result.txt"
}
file=$(get_file)   # file = "Mencari file...\nresult.txt"

# ✅ BENAR
get_file() {
  echo "Mencari file..." >&2   # ke stderr
  echo "result.txt"
}
file=$(get_file)   # file = "result.txt"
```

#### 7.3.5 Cakupan Variabel: `local` vs Global

Secara default, variabel yang didefinisikan dalam fungsi adalah **global**. Untuk membatasinya, gunakan `local`:

```bash
global_var="global"

contoh() {
  local lokal_var="lokal"
  global_var="diubah"       # menimpa global
  echo "$lokal_var / $global_var"
}

contoh
echo "$global_var"     # "diubah"
echo "$lokal_var"      # kosong (di luar scope)
```

**Mengapa `local` penting?**

1. **Mencegah side effect:** Variabel global bisa tidak sengaja diubah oleh fungsi, menyebabkan bug yang sulit dilacak.
2. **Membuat fungsi independen:** Fungsi dengan variabel lokal tidak bergantung pada state global.
3. **Memungkinkan rekursi:** Setiap pemanggilan fungsi punya salinan variabel lokal sendiri.

**Koreksi:** Variabel loop `for (( i=0; ... ))` **tetap global**. Untuk melokalkannya, deklarasikan `local i` di dalam fungsi.

#### 7.3.6 Pustaka Fungsi (Sourcing)

**`utils.sh`:**

```bash
log_info()  { echo "[INFO] $(date +%T) - $*"; }
log_error() { echo "[ERROR] $(date +%T) - $*" >&2; }
```

**`main.sh`:**

```bash
#!/usr/bin/env bash
source ./utils.sh     # atau: . ./utils.sh

log_info "Mulai"
log_error "Ada masalah"
```

**Perbedaan `source` vs eksekusi:**

| Cara | Efek |
|---|---|
| `source file.sh` | Dijalankan di shell saat ini; fungsi/variabel tersedia |
| `./file.sh` | Dijalankan di subshell; tidak mempengaruhi shell induk |

**Idiom untuk memastikan sourced, bukan dieksekusi:**

```bash
# Di utils.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Skrip ini harus di-source, bukan dieksekusi." >&2
  exit 1
fi
```

#### 7.3.7 `export -f` — Ekspor Fungsi

Fungsi bisa diekspor ke subshell:

```bash
my_func() { echo "hi"; }
export -f my_func
bash -c 'my_func'   # hi
```

Ini berguna ketika Anda ingin fungsi tersedia di skrip yang dipanggil dari skrip utama.

#### 7.3.8 Debugging Fungsi

- `declare -f nama_fungsi` — tampilkan definisi fungsi.
- `unset -f nama_fungsi` — hapus fungsi.
- `command nama_perintah` — bypass fungsi dengan nama sama.
- `FUNCNAME`, `BASH_SOURCE`, `BASH_LINENO` — variabel debugging.
- `set -x` di dalam fungsi — trace eksekusi fungsi.

**Contoh:**

```bash
my_func() {
  command ls "$@"   # bypass alias/fungsi ls
}
```

#### 7.3.9 Praktik Terbaik Fungsi

1. **Gunakan `local` untuk semua variabel.**
2. **Beri nama deskriptif:** `buat_cadangan`, bukan `bc`.
3. **Fokus satu tugas per fungsi.**
4. **Tangani error dengan `return N`.**
5. **Cetak output ke `stdout`, pesan ke `stderr`.**
6. **Komentari fungsi** (tujuan, argumen, return).
7. **Validasi argumen** di awal fungsi.
8. **Hindari efek samping global.**

---

## **8. Array dan Manipulasi Teks**

### 8.1 Array

**Array** adalah kumpulan nilai yang diindeks. Bash mendukung **indexed array** (indeks angka) dan **associative array** (indeks string).

**Indexed array:**

```bash
arr=(satu dua tiga)
echo "${arr[0]}"        # satu
echo "${arr[@]}"        # semua elemen
echo "${arr[*]}"        # semua elemen sebagai satu string
echo "${#arr[@]}"       # jumlah elemen
arr+=(empat)            # tambah
echo "${arr[-1]}"       # elemen terakhir (Bash 4.3+)

# Iterasi
for x in "${arr[@]}"; do echo "$x"; done

# Slice
echo "${arr[@]:1:2}"    # dua tiga
```

**Perbedaan `"${arr[@]}"` vs `"${arr[*]}"`:**

- `"${arr[@]}"` — setiap elemen menjadi kata terpisah.
- `"${arr[*]}"` — semua elemen digabung dengan pemisah karakter pertama `IFS`.

Sama seperti `"$@"` vs `"$*"`.

### 8.2 Associative Array (Bash 4+)

```bash
declare -A umur
umur[budi]=25
umur[ani]=30
umur[citra]=28

for k in "${!umur[@]}"; do
  echo "$k → ${umur[$k]}"
done
```

**Penting:** Gunakan `declare -A` untuk mendeklarasikan associative array. Tanpa itu, `umur[budi]=25` akan diperlakukan sebagai indexed array dengan indeks aritmatika (yang akan error).

### 8.3 `mapfile` / `readarray`

`mapfile` (alias `readarray`) membaca baris dari input ke array:

```bash
mapfile -t lines < file.txt    # -t menghapus trailing newline
echo "${lines[0]}"
```

**Opsi:**

- `-t` — hapus trailing delimiter (newline).
- `-n N` — baca maksimal N baris.
- `-s N` — lewati N baris pertama.
- `-d CHAR` — gunakan CHAR sebagai delimiter (default newline).
- `-O N` — mulai dari indeks N.

**Contoh dengan `find -print0`:**

```bash
mapfile -d '' files < <(find . -name '*.txt' -print0)
for f in "${files[@]}"; do
  echo "$f"
done
```

### 8.4 Alat Manipulasi Teks

| Tool | Fungsi | Contoh |
|---|---|---|
| `grep` | Cari pola | `grep -E 'error\|warn' log.txt` |
| `sed` | Edit stream | `sed 's/foo/bar/g' file` |
| `awk` | Proses kolom | `awk -F: '{print $1}' /etc/passwd` |
| `cut` | Potong kolom | `cut -d: -f1 /etc/passwd` |
| `sort` | Urutkan | `sort -n -k2 file` |
| `uniq` | Hapus duplikat | `sort file \| uniq -c` |
| `tr` | Translasi karakter | `tr 'a-z' 'A-Z'` |
| `find` | Cari file | `find . -name '*.log' -mtime -7` |
| `xargs` | Bangun argumen | `find . -print0 \| xargs -0 rm` |
| `head`/`tail` | Baris awal/akhir | `tail -f log.txt` |
| `wc` | Hitung baris/kata/karakter | `wc -l file` |
| `paste` | Gabung kolom | `paste file1 file2` |
| `join` | Gabung berdasarkan field | `join -t: file1 file2` |
| `split` | Pecah file | `split -l 1000 file` |
| `comm` | Bandingkan file terurut | `comm file1 file2` |

**Contoh gabungan:**

```bash
# 10 IP paling sering muncul di access.log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Cari file .log lebih dari 7 hari, hapus
find /var/log -name '*.log' -mtime +7 -print0 | xargs -0 rm

# Ganti semua kemunculan 'foo' dengan 'bar' di semua .txt
sed -i 's/foo/bar/g' *.txt

# Ekstrak kolom 2 dan 4 dari CSV sederhana
awk -F, '{print $2, $4}' data.csv

# Hitung total baris dari semua .log
find . -name '*.log' -print0 | xargs -0 wc -l | tail -1
```

### 8.5 `getopts` — Parsing Opsi

`getopts` adalah builtin Bash untuk parsing opsi baris perintah:

```bash
while getopts ":hv:f:" opt; do
  case "$opt" in
    h) usage; exit 0 ;;
    v) verbose="$OPTARG" ;;
    f) file="$OPTARG" ;;
    \?) echo "Opsi tidak dikenal: -$OPTARG" >&2; exit 1 ;;
    :)  echo "Opsi -$OPTARG butuh argumen" >&2; exit 1 ;;
  esac
done
shift $(( OPTIND - 1 ))
```

**Penjelasan:**

- `":hv:f:"` — string opsi. `:` di awal mengaktifkan mode silent. `h` adalah flag tanpa argumen. `v:` dan `f:` adalah opsi dengan argumen.
- `$OPTARG` — nilai argumen untuk opsi.
- `$OPTIND` — indeks argumen berikutnya.
- `\?` — opsi tidak dikenal.
- `:` — opsi butuh argumen tetapi tidak diberikan.

**Setelah `getopts`:** `shift $(( OPTIND - 1 ))` untuk memproses argumen non-opsi yang tersisa.

### 8.6 `trap` — Menangani Sinyal dan Cleanup

`trap` memungkinkan Anda menjalankan perintah ketika sinyal diterima atau ketika skrip keluar:

```bash
trap 'rm -f "$tmpfile"' EXIT
trap 'echo "Interrupted"; exit 1' INT TERM
```

**Sinyal umum:**

- `EXIT` — ketika skrip keluar (normal atau error).
- `INT` — Ctrl+C.
- `TERM` — `kill`.
- `HUP` — hangup.
- `ERR` — ketika perintah gagal (dengan `set -e`).

**Contoh cleanup:**

```bash
#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Bekerja di $tmpdir"
# ... kerja ...
```

---

## **9. Praktik Terbaik, Kesalahan Umum, dan Debugging**

### 9.1 Praktik Terbaik

1. **Selalu kutip ganda** variabel: `"$var"`, `"$@"`.
2. **Gunakan `[[ ]]`** untuk kondisional di Bash.
3. **Gunakan `local`** di dalam fungsi.
4. **`set -euo pipefail`** untuk skrip robust.
5. **Gunakan `read -r`** untuk membaca input mentah.
6. **Lokalkan `IFS`** saat mengubahnya.
7. **Hindari `eval`** kecuali sangat terpaksa.
8. **Pisahkan `stdout` (data) dan `stderr` (pesan)**.
9. **Gunakan `printf`** alih-alih `echo` untuk output yang dapat diprediksi.
10. **Gunakan `trap`** untuk cleanup.
11. **Gunakan `--`** untuk mengakhiri opsi: `rm -- "$file"`.
12. **Gunakan `mktemp`** untuk file/direktori sementara.
13. **Periksa apakah file ada** sebelum menggunakannya.
14. **Validasi input** pengguna.
15. **Gunakan `shellcheck`** untuk linting.

### 9.2 Kesalahan Umum

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Lupa spasi di `[ ]` | `["$x"=="y"]` | `[ "$x" == "y" ]` |
| Pakai `==` untuk angka | Perbandingan string | `(( a == b ))` atau `-eq` |
| `for f in $(ls)` | Word splitting | `for f in *` |
| `cat file \| while read` | Subshell | `while read ... done < file` |
| Variabel di `for (( ))` dianggap lokal | Salah paham | Gunakan `local` |
| `eval` berulang | Bahaya injection | Hindari |
| `echo $var` tanpa kutip | Word splitting/glob | `echo "$var"` |
| Lupa `;;` di `case` | Fall-through | Tambahkan `;;` |
| `[ -f $file ]` tanpa kutip | Word splitting | `[ -f "$file" ]` |
| `rm -rf $dir/` di mana `$dir` kosong | `set -u` tidak aktif | `set -u` dan `rm -rf "${dir:?}"` |
| Mengira `set -e` selalu berhenti | Perilaku kompleks | Pahami pengecualian |

### 9.3 Debugging

**Teknik debugging:**

```bash
set -x          # tampilkan perintah yang dijalankan (trace)
set -v          # tampilkan input mentah
PS4='+${BASH_SOURCE}:${LINENO}: '   # prompt trace informatif
bash -n script.sh    # cek sintaks tanpa eksekusi
bash -x script.sh    # jalankan dengan trace
shellcheck script.sh # linter (sangat direkomendasikan)
```

**Contoh `PS4` yang informatif:**

```bash
PS4='+${BASH_SOURCE##*/}:${LINENO}:${FUNCNAME[0]:-main}: '
set -x
my_func() { echo "hi"; }
my_func
# Output:
# +script.sh:5:main: my_func
# +script.sh:3:my_func: echo hi
# hi
```

**Debugging dengan `trap`:**

```bash
trap 'echo "Error di baris $LINENO"' ERR
```

**Alat eksternal:**

- **shellcheck** — linter statis untuk shell script.
- **explainshell** — menjelaskan perintah shell.
- **bashdb** — debugger interaktif untuk Bash.

---

## **10. Studi Kasus Terpadu**

### Studi Kasus 1: Pembersih File Log

```bash
#!/usr/bin/env bash
# pembersih-log.sh — Hapus file log lebih dari N hari
set -euo pipefail

readonly LOG_DIR="${1:-/var/log}"
readonly MAX_AGE="${2:-7}"
readonly DRY_RUN="${DRY_RUN:-false}"

shopt -s nullglob

hapus_file() {
  local f="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '[DRY] rm %s\n' "$f"
  else
    rm -f -- "$f"
    printf '[DEL] %s\n' "$f"
  fi
}

main() {
  local f count=0
  for f in "$LOG_DIR"/*.log; do
    [[ -f "$f" ]] || continue
    if [[ $(find "$f" -mtime +"$MAX_AGE" 2>/dev/null) ]]; then
      hapus_file "$f"
      count=$(( count + 1 ))
    fi
  done
  printf 'Total dihapus: %d\n' "$count"
}

main "$@"
```

**Konsep yang dipakai:**

- `set -euo pipefail` — mode robust.
- `readonly` — konstanta.
- Parameter default `${1:-...}`.
- `shopt -s nullglob` — hindari literal `*.log`.
- Fungsi dengan `local`.
- `printf` alih-alih `echo`.
- `--` pada `rm` untuk keamanan.
- `[[ -f ... ]]` untuk memvalidasi.

### Studi Kasus 2: Pemroses CSV dan Laporan

```bash
#!/usr/bin/env bash
# laporan-kota.sh — Hitung jumlah orang per kota dari CSV
set -euo pipefail

readonly INPUT="${1:?Usage: $0 <file.csv>}"

declare -A total_per_kota

# Header: Nama,Usia,Kota
while IFS=, read -r nama usia kota; do
  [[ "$nama" == "Nama" ]] && continue   # skip header
  [[ -z "$nama" ]] && continue          # skip baris kosong
  total_per_kota["$kota"]=$(( ${total_per_kota["$kota"]:-0} + 1 ))
done < "$INPUT"

printf '%-15s %s\n' "Kota" "Jumlah"
for k in "${!total_per_kota[@]}"; do
  printf '%-15s %s\n' "$k" "${total_per_kota[$k]}"
done | sort -k2 -rn
```

**Konsep yang dipakai:**

- Associative array.
- Default parameter `${var:-0}`.
- `IFS=,` lokal untuk `read`.
- Pattern matching `==` di dalam `[[ ]]`.
- `sort` untuk laporan.
- `printf` dengan format alignment.

### Studi Kasus 3: Menu Interaktif dengan `select`

```bash
#!/usr/bin/env bash
# menu.sh — Menu interaktif sederhana
set -euo pipefail

pilih() {
  select opt in "Lihat tanggal" "Lihat user" "Lihat disk" "Keluar"; do
    case "$opt" in
      "Lihat tanggal") date ;;
      "Lihat user")    whoami ;;
      "Lihat disk")    df -h / ;;
      "Keluar")        return 0 ;;
      *)               echo "Pilihan tidak valid" >&2 ;;
    esac
  done
}

pilih
```

**Konsep yang dipakai:**

- `select` untuk menu.
- `case` untuk dispatch.
- `return 0` untuk keluar dari fungsi.

### Studi Kasus 4: Backup dengan `trap` Cleanup

```bash
#!/usr/bin/env bash
# backup.sh — Backup direktori dengan cleanup otomatis
set -euo pipefail

readonly SRC="${1:?Usage: $0 <source-dir>}"
readonly DST="${2:?Usage: $0 <source-dir> <dest-dir>}"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Backup $SRC ke $DST"
tar -czf "$tmpdir/backup.tar.gz" -C "$(dirname "$SRC")" "$(basename "$SRC")"
mv "$tmpdir/backup.tar.gz" "$DST/backup-$(date +%Y%m%d%H%M%S).tar.gz"
echo "Selesai."
```

**Konsep yang dipakai:**

- `mktemp -d` untuk direktori sementara.
- `trap ... EXIT` untuk cleanup otomatis.
- `tar` untuk arsip.
- `date` untuk timestamp.

### Studi Kasus 5: Pemroses Log dengan `awk` dan `sort`

```bash
#!/usr/bin/env bash
# top-ip.sh — 10 IP paling sering muncul di access.log
set -euo pipefail

readonly LOG="${1:?Usage: $0 <access.log>}"

awk '{print $1}' "$LOG" \
  | sort \
  | uniq -c \
  | sort -rn \
  | head -10 \
  | awk '{printf "%-20s %s\n", $2, $1}'
```

**Konsep yang dipakai:**

- Pipeline untuk pemrosesan bertahap.
- `awk` untuk ekstraksi kolom.
- `sort | uniq -c` untuk menghitung frekuensi.
- `sort -rn` untuk urut numerik terbalik.
- `head` untuk top 10.

---

## **11. Referensi**

### Dokumentasi Resmi

- **Bash Manual — Shell Expansions:** <https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html>
- **Bash Manual — Conditional Expressions:** <https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html>
- **Bash Manual — Loop Commands:** <https://www.gnu.org/software/bash/manual/html_node/Loop-Commands.html>
- **Bash Manual — Functions:** <https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html>
- **Bash Manual — Arrays:** <https://www.gnu.org/software/bash/manual/html_node/Arrays.html>
- **POSIX Shell Command Language:** <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html>

### Wiki Komunitas

- **Greg's Wiki — BashFAQ/031 (if/test):** <https://mywiki.wooledge.org/BashFAQ/031>
- **Greg's Wiki — BashFAQ/001 (Read file line by line):** <https://mywiki.wooledge.org/BashFAQ/001>
- **Greg's Wiki — BashFAQ/053 (Variable Scope):** <https://mywiki.wooledge.org/BashFAQ/053>
- **Greg's Wiki — BashPitfalls:** <https://mywiki.wooledge.org/BashPitfalls>
- **Greg's Wiki — BashGuide:** <https://mywiki.wooledge.org/BashGuide>

### Tutorial & Buku

- **The Linux Command Line** (William Shotts) — <http://linuxcommand.org/tlcl.php>
- **Advanced Bash-Scripting Guide** (Mendel Cooper) — <https://tldp.org/LDP/abs/html/>
- **ryanstutorials.net — Bash Scripting:** <https://ryanstutorials.net/bash-scripting-tutorial/>
- **Linuxize — Bash if/else, case, loops:** <https://linuxize.com/>

### Tooling

- **shellcheck:** <https://www.shellcheck.net/>
- **explainshell:** <https://explainshell.com/>
- **bashdb:** <https://bashdb.sourceforge.net/>

---

<!-- ## **Penutup** -->
<!---->
<!-- Dokumen ini menyatukan enam file terpisah menjadi satu penjelasan utuh, dengan: -->
<!---->
<!-- - **Koreksi kesalahan faktual:** -->
<!--   - Brace expansion dipisahkan dari globbing. -->
<!--   - `i` di `for ((...))` **tidak** lokal secara implisit. -->
<!--   - PowerShell **tidak** punya wildcard `**`; rekursi dilakukan dengan `-Recurse`. -->
<!--   - Script `eval` berulang dihapus (bahaya keamanan). -->
<!--   - `[ -f x && -r x ]` dikoreksi menjadi `[[ -f x && -r x ]]`. -->
<!---->
<!-- - **Penambahan materi yang hilang:** -->
<!--   - Quoting dan pengaruhnya pada word splitting/globbing. -->
<!--   - Opsi shell: `dotglob`, `nullglob`, `failglob`, `globstar`, `extglob`, `nocaseglob`, `GLOBIGNORE`, `globskipdots`. -->
<!--   - Array, associative array, `mapfile`. -->
<!--   - `getopts`, `trap`, `set -euo pipefail`. -->
<!--   - Text processing: `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `tr`, `find`, `xargs`. -->
<!--   - Debugging: `set -x`, `PS4`, `shellcheck`, `bashdb`. -->
<!--   - Studi kasus terpadu. -->
<!---->
<!-- - **Penataan ulang alur belajar:** -->
<!--   - Dari ekspansi shell → word splitting → globbing → pattern matching → short-circuiting → kontrol alur → array & teks → praktik terbaik → studi kasus. -->
<!--   - Setiap konsep dijelaskan dengan *apa*, *mengapa*, *kapan*, dan *bagaimana*. -->
<!---->
<!-- - **Integrasi antar-topik:** -->
<!--   - Setiap konsep dikaitkan dengan konsep lain. -->
<!--   - Contoh menunjukkan interaksi (misalnya, bagaimana quoting mempengaruhi word splitting dan globbing). -->
<!---->
<!-- Dengan struktur ini, dokumen dapat dibaca secara linear sebagai kurikulum, atau dijadikan referensi cepat lewat daftar isi dan tabel perbandingan. Setiap bagian menyediakan **deskripsi lengkap**, **contoh praktis**, **kesalahan umum**, dan **praktik terbaik** yang dapat langsung diterapkan. -->

> ⬆️ **[Ke Atas](#)**
> ➡️ **[Modul Berikutnya (Fase 3)][selanjutnya]**
> 📘 **[Kurikulum]**
> 🌐 **[Home][domain]**
<!-- > 📎 **[Lampiran POSIX](./posix.md)** -->

[domain]: ../../../../README.md
[Kurikulum]: ./../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->
[1]:../README.md
[2]:./short-circuiting.md
[3]:./globbing.md
[4]:./word-splitting.md
