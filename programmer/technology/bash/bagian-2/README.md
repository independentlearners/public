# **Panduan Lengkap: Pattern Matching, Ekspansi Shell, Kontrol Alur, dan Manipulasi Teks di Bash**

> **Catatan revisi:** Dokumen ini menggantikan enam file terpisah (`globbing.md`, `pattern-matching.md`, `wildcard.md`, `word-splitting.md`, `short-circuiting.md`, dan `README.md` Fase 2). Semua materi telah digabung menjadi satu penjelasan utuh, dengan koreksi kesalahan faktual, penambahan materi yang hilang, serta penataan ulang alur belajar dari fondasi ke aplikasi.

---

## **Daftar Isi**

1. Pengantar & Peta Konsep
2. Urutan Ekspansi Shell (Kerangka Utama)
3. Word Splitting (Mendalam)
4. Pathname Expansion / Globbing (Mendalam)
5. Pattern Matching (Lebih Luas dari Globbing)
6. Short-Circuiting
7. Kontrol Alur: Kondisional, Perulangan, Fungsi
8. Array dan Manipulasi Teks
9. Praktik Terbaik, Kesalahan Umum, dan Debugging
10. Studi Kasus Terpadu
11. Referensi

---

## **1. Pengantar & Peta Konsep**

Bash (dan shell POSIX lain) memiliki beberapa lapisan pemrosesan teks yang sering membingungkan karena namanya mirip:

| Istilah | Dilakukan oleh | Lingkup | Contoh |
|---|---|---|---|
| **Ekspansi Shell** | Shell | Umum (semua tahap) | `~`, `$var`, `$(cmd)` |
| **Brace Expansion** | Shell | Menghasilkan string | `{a,b}.txt` → `a.txt b.txt` |
| **Word Splitting** | Shell | Memecah string jadi kata | `$var` → beberapa argumen |
| **Pathname Expansion (Globbing)** | Shell | Nama file di filesystem | `*.txt` → `a.txt b.txt` |
| **Pattern Matching** | Shell / bahasa | String (tanpa filesystem) | `[[ $x == *.txt ]]` |
| **Regex** | Program / shell | String (kompleks) | `[[ $x =~ ^[a-z]+$ ]]` |
| **Short-Circuiting** | Shell / bahasa | Evaluasi logika | `cmd1 && cmd2` |

**Ide kunci yang harus dipegang:**

- **Globbing ≠ regex ≠ brace expansion.** Ketiganya sering disalahartikan sebagai satu hal.
- **Brace expansion** terjadi **sebelum** word splitting dan **bukan** pencarian file.
- **Globbing** terjadi **setelah** word splitting, dan **hanya jika** hasil ekspansi tidak dikutip.
- **Pattern matching** di `[[ ]]` dan `case` mirip globbing, tetapi **tidak menyentuh filesystem**.
- **Regex** di `[[ =~ ]]` punya sintaks sendiri, tidak sama dengan globbing.

---

## **2. Urutan Ekspansi Shell (Kerangka Utama)**

Bash memproses baris perintah melalui tahap-tahap berikut **secara berurutan**. Memahami urutan ini adalah kunci untuk memahami semua materi berikutnya.

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

**Poin penting yang sering terlewat:**

- **Quoting** mempengaruhi tahap 6 dan 7. Jika hasil ekspansi dikutip ganda (`"$var"`), word splitting dan globbing **tidak terjadi**.
- **Assignment** (`var=value`) tidak melalui word splitting atau globbing.
- **`[[ ... ]]`** dan `case` tidak melalui globbing filesystem; mereka melakukan pattern matching pada string.
- **Brace expansion** terjadi paling awal, bahkan sebelum `$var` diekspansi.

---

## **3. Word Splitting (Mendalam)**

### 3.1 Definisi

**Word splitting** adalah proses shell memecah string menjadi kata-kata terpisah berdasarkan nilai `IFS` (*Internal Field Separator*), **setelah** parameter expansion, command substitution, dan arithmetic expansion selesai.

> **Aturan emas:** Word splitting **hanya terjadi jika hasil ekspansi tidak dikutip ganda**.

### 3.2 Mekanisme `IFS`

- **Default `IFS`** = spasi, tab, newline (`$' \t\n'`).
- Shell memotong string di setiap karakter yang ada di `IFS`.
- Karakter `IFS` berurutan digabung menjadi satu pemisah.
- **`unset IFS`** mengembalikan ke default.
- **`IFS=`** (kosong) menonaktifkan word splitting sepenuhnya.

### 3.3 Contoh

```bash
# Default IFS
var="a b   c"
echo $var       # a b c   ← tiga argumen: a, b, c
echo "$var"     # a b   c ← satu argumen utuh

# Mengubah IFS secara lokal
IFS=: read -r user pass uid <<< "budi:secret:1000"
echo "$user | $pass | $uid"   # budi | secret | 1000

# IFS global (hindari, gunakan lokal)
old_ifs="$IFS"
IFS=:
data="user:pass:123"
echo $data      # user pass 123
IFS="$old_ifs"
```

### 3.4 Kapan Word Splitting **Tidak** Terjadi

1. Di dalam tanda kutip ganda: `"$var"`.
2. Di dalam assignment: `var=$other` (tidak di-split).
3. Di dalam `[[ ... ]]`: `[[ $x == $y ]]` (tidak di-split).
4. Di dalam `case "$var" in`.

### 3.5 `$@` vs `$*` — Perbedaan Krusial

```bash
set -- "a b" c d

for x in "$@"; do echo "[$x]"; done   # [a b] [c] [d]
for x in $@;   do echo "[$x]"; done   # [a] [b] [c] [d]  ← salah
for x in "$*"; do echo "[$x]"; done   # [a b c d]        ← satu string
for x in $*;   do echo "[$x]"; done   # [a] [b] [c] [d]
```

**Aturan:** Selalu gunakan `"$@"` untuk meneruskan argumen; `"$*"` hanya jika Anda memang ingin menggabungkan.

### 3.6 Bahaya Umum dan Solusinya

| Bahaya | Contoh Buruk | Solusi |
|---|---|---|
| Nama file berisi spasi | `for f in $(ls)` | `for f in *; do ...` atau `find . -print0 \| while IFS= read -r -d '' f` |
| Variabel user | `rm $file` | `rm "$file"` |
| Daftar dinamis | `files=$(ls)` | `mapfile -t files < <(ls)` atau langsung `files=(*)` |
| Argumen fungsi | `func $args` | `func "$@"` |

### 3.7 Contoh Benar Membaca File Baris demi Baris

```bash
# ✅ BENAR: while di shell yang sama, IFS dilokalisasi
while IFS= read -r line; do
  printf 'Baris: %s\n' "$line"
done < "$file"

# ✅ BENAR: baca ke array
mapfile -t lines < "$file"

# ❌ SALAH: while di subshell, variabel hilang
cat "$file" | while read -r line; do
  count=$((count + 1))   # perubahan tidak terlihat di luar
done
echo "$count"            # kosong
```

### 3.8 Visualisasi Tahap Ekspansi (Script Aman)

Berikut versi yang **tidak menggunakan `eval` berulang** (yang berbahaya). Kita hanya mendemonstrasikan tahap secara manual:

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
step "${RED}[6] Word Splitting${NC}: var='a b c'; \$var → 3 argumen"
step "${CYAN}[7] Pathname Expansion${NC}: *.sh → $(echo *.sh 2>/dev/null | head -c 60)..."
echo
echo "Final: argumen dikirim ke program."
```

> **Peringatan:** Jangan gunakan `eval echo "$CMD"` berulang untuk “mensimulasikan” tahap ekspansi. Itu mengeksekusi ulang command substitution dan bisa menjadi celah keamanan.

---

## **4. Pathname Expansion / Globbing (Mendalam)**

### 4.1 Definisi

**Globbing** (atau *pathname expansion*) adalah proses **shell** mencocokkan nama file atau path menggunakan pola (*glob patterns*) **sebelum** perintah dijalankan. Hasilnya adalah daftar nama file yang cocok, diurutkan secara leksikografis.

> Penting: Globbing **bukan regex**, dan **bukan** brace expansion. Globbing menyentuh filesystem.

### 4.2 Wildcard Dasar

| Pola | Arti | Contoh | Cocok dengan |
|---|---|---|---|
| `*` | 0 atau lebih karakter (kecuali `/` dan leading `.`) | `*.txt` | `a.txt`, `b.txt` |
| `?` | Tepat 1 karakter (kecuali `/`) | `file?.sh` | `file1.sh`, `fileA.sh` |
| `[abc]` | 1 karakter dari set | `file[12].txt` | `file1.txt`, `file2.txt` |
| `[a-z]` | 1 karakter dari range | `[a-z]*.sh` | `app.sh`, `run.sh` |
| `[!abc]` | 1 karakter **bukan** dari set (POSIX) | `file[!0-9].txt` | `fileA.txt` |
| `[^abc]` | Sama seperti `[!abc]`, **non-POSIX** | `file[^0-9].txt` | `fileA.txt` |
| `[[:alpha:]]` | POSIX character class | `[[:digit:]]*.log` | `1.log`, `2.log` |

**Catatan POSIX:** Hanya `[!...]` yang standar. `[^...]` didukung Bash/Zsh, tapi hindari jika portabilitas penting.

### 4.3 Extended Globbing (Bash & Zsh)

Aktifkan di Bash:

```bash
shopt -s extglob
```

Di Zsh, extended glob aktif secara default atau dengan:

```zsh
setopt extendedglob
```

| Pola | Arti | Contoh |
|---|---|---|
| `?(pattern-list)` | 0 atau 1 kemunculan | `?(foo)` → ``, `foo` |
| `*(pattern-list)` | 0 atau lebih kemunculan | `*(foo bar)` |
| `+(pattern-list)` | 1 atau lebih kemunculan | `+(jpg\|png)` |
| `@(pattern-list)` | Tepat satu pilihan | `@(jpg\|png)` |
| `!(pattern-list)` | Tidak cocok dengan pola | `!(tmp\|bak)` |

Contoh:

```bash
shopt -s extglob
echo !(*.bak|*.tmp)     # semua file kecuali .bak dan .tmp
```

> **Perhatian:** Brace expansion `{a,b}` **bukan** bagian dari extended globbing. Ia adalah tahap ekspansi terpisah.

### 4.4 Opsi Shell yang Mempengaruhi Globbing

| Opsi | Efek |
|---|---|
| `shopt -s dotglob` | `*` juga cocok dengan file berawalan `.` |
| `shopt -s nullglob` | Jika tidak ada match, pola dihapus (jadi array kosong) |
| `shopt -s failglob` | Jika tidak ada match, Bash error dan hentikan perintah |
| `shopt -s globstar` | Aktifkan `**` untuk match rekursif |
| `shopt -s nocaseglob` | Globbing case-insensitive |
| `shopt -s extglob` | Aktifkan extended globbing |
| `shopt -s globasciiranges` | Range `[a-z]` mengikuti ASCII |
| `set -f` / `set -o noglob` | Nonaktifkan globbing sepenuhnya |
| `GLOBIGNORE` | Daftar pola yang dikecualikan dari hasil glob |

Contoh:

```bash
# Default: jika tidak ada file .zzz, pola tetap
echo *.zzz              # *.zzz

shopt -s nullglob
echo *.zzz              # (kosong)

shopt -s failglob
echo *.zzz              # bash: no match: *.zzz  (error)
```

### 4.5 Dotfiles

Secara default, `*` dan `?` **tidak** cocok dengan file yang diawali titik (`.bashrc`, `.git`). Untuk memasukkannya:

```bash
shopt -s dotglob
echo *
```

Pola `.??*` cocok dengan dotfile minimal 3 karakter (kecuali `.` dan `..`).

### 4.6 Quoting Menonaktifkan Globbing

Ini krusial dan sering terlewat:

```bash
echo *.txt      # globbing aktif
echo "*.txt"    # literal "*.txt"
echo '*.txt'    # literal "*.txt"
echo \*.txt     # literal "*.txt"
```

### 4.7 Batas Argumen (`ARG_MAX`)

Jika glob menghasilkan terlalu banyak file, shell bisa gagal dengan error `Argument list too long`. Solusi:

```bash
find . -name '*.log' -print0 | xargs -0 rm
# atau
find . -name '*.log' -exec rm {} +
```

### 4.8 Globbing Lintas Platform

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

**PowerShell — koreksi penting:** `**` **bukan** wildcard di PowerShell. Rekursi dilakukan dengan parameter:

```powershell
Get-ChildItem -Recurse -Filter *.txt
```

**CMD:** `dir /s *.txt` untuk rekursif.

---

## **5. Pattern Matching (Lebih Luas dari Globbing)**

### 5.1 Definisi

**Pattern matching** adalah konsep umum: mencocokkan data (string, angka, struktur) terhadap suatu pola. Globbing adalah **salah satu** bentuk pattern matching (khusus nama file). Ada juga:

- Pattern matching **string** di `[[ ]]` dan `case`.
- **Regex** di `[[ =~ ]]`, `grep`, `sed`, dll.
- **Structural pattern matching** di Python, Rust, Dart 3+.

### 5.2 Pattern Matching di Bash: `[[ ]]` dan `case`

Di dalam `[[ ]]`, operator `==`, `!=` melakukan **pattern matching gaya globbing** pada string **tanpa menyentuh filesystem**:

```bash
name="report.txt"
[[ $name == *.txt ]] && echo "File teks"
```

**Aturan quoting:**

```bash
pattern="*.txt"
[[ $name == $pattern ]]     # pattern matching ✅
[[ $name == "$pattern" ]]   # literal, bukan pattern ✅ (perilaku berbeda!)
```

**Case statement** menggunakan pattern matching gaya globbing:

```bash
case "$name" in
  *.txt|*.md)  echo "Teks" ;;
  *.jpg|*.png) echo "Gambar" ;;
  *)           echo "Lainnya" ;;
esac
```

**Bash 4+ `case` fall-through:**

- `;;` — akhiri blok (default).
- `;&` — lanjut ke blok berikutnya **tanpa** mengecek pola (fall-through).
- `;;&` — lanjut mengecek pola berikutnya.

### 5.3 Regex di Bash: `[[ =~ ]]`

Bash mendukung regex ERE dengan operator `=~`:

```bash
if [[ "$name" =~ ^[a-z]+\.(txt|md)$ ]]; then
  echo "Cocok"
fi

# Capture group via BASH_REMATCH
[[ "2024-01-15" =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]
echo "${BASH_REMATCH[1]}"   # 2024
echo "${BASH_REMATCH[2]}"   # 01
echo "${BASH_REMATCH[3]}"   # 15
```

**Penting:**

- Regex di Bash adalah **ERE** (Extended Regular Expression), bukan PCRE.
- Jangan mengutip regex, kecuali bagian yang literal: `[[ $x =~ "^abc" ]]` mencari literal `^abc`.
- Untuk case-insensitive: `shopt -s nocasematch`.

### 5.4 Extglob di `[[ ]]`

Jika `extglob` aktif, Anda bisa memakai `?(...)`, `*(...)`, `+(...)`, `@(...)`, `!(...)` di dalam `[[ ]]` juga:

```bash
shopt -s extglob
[[ $name == +(foo|bar).txt ]] && echo "cocok"
```

### 5.5 Pattern Matching Lintas Bahasa

| Bahasa | Sintaks | Tipe Pola | Contoh |
|---|---|---|---|
| **Bash** | `[[ s == pat ]]`, `case` | Wildcard glob | `[[ $f == *.txt ]]` |
| **Bash (regex)** | `[[ s =~ re ]]` | ERE | `[[ $f =~ ^[a-z]+\.txt$ ]]` |
| **Zsh** | `[[ s == pat ]]`, `^pat`, `~pat` | Wildcard + extended | `[[ $f == ^*.jpg ]]` |
| **PowerShell** | `-like`, `-match` | Wildcard .NET / Regex | `"a.txt" -like "*.txt"` |
| **Dart 3+** | `switch`/`if-case` | Literal, destructuring, guard | `case String s when s.endsWith('.txt'):` |
| **Lua** | `string.match`, `string.find` | Lua patterns | `string.match(f, "%.txt$")` |
| **Python** | `match/case`, `re` | Struktural / Regex | `case [x, y]:` |

**Lua patterns** bukan regex penuh: tidak ada alternasi `|`, tidak ada quantifier `{n,m}`, `%` untuk escape.

### 5.6 Perbandingan Globbing vs Pattern Matching vs Regex

| Fitur | Globbing | Pattern Matching (`[[ ]]`) | Regex (`=~`) |
|---|---|---|---|
| Eksekusi | Shell, sebelum perintah | Shell, tanpa filesystem | Shell atau program |
| Lingkup | Nama file/path | String | String |
| Simbol | `*`, `?`, `[...]`, `{...}` (brace expansion terpisah) | Sama | `^`, `$`, `.`, `*`, `+`, `?`, `{n,m}`, `(...)` |
| Kekuatan | Sederhana | Sedang | Paling fleksibel |
| Akses filesystem | Ya | Tidak | Tidak |

---

## **6. Short-Circuiting**

### 6.1 Definisi

**Short-circuiting** adalah mekanisme evaluasi logika di mana ekspresi berhenti dievaluasi lebih awal begitu hasilnya bisa ditentukan.

### 6.2 Operator dan Perilaku

| Operator | Nama | Perilaku |
|---|---|---|
| `&&` | AND | Jika kiri false → kanan **tidak** dievaluasi |
| `\|\|` | OR | Jika kiri true → kanan **tidak** dievaluasi |

### 6.3 Dua Konteks Berbeda di Bash

**Konteks 1 — Command list (di luar `[[ ]]`):** Berdasarkan **exit status**.

```bash
mkdir -p dir && cd dir && touch file
# cd hanya jalan jika mkdir sukses
```

**Konteks 2 — Logical operator di dalam `[[ ]]`:** Berdasarkan **boolean**.

```bash
[[ -f file && -r file ]] && echo "Ada dan bisa dibaca"
```

**Perbedaan krusial:** Jangan campur! `[ -f file && -r file ]` **salah** — `&&` tidak dikenal oleh `[`.

### 6.4 Precedence

Di Bash, `&&` dan `||` memiliki **precedence sama** dan **left-associative**:

```bash
cmd1 || cmd2 && cmd3
# Dievaluasi sebagai: (cmd1 || cmd2) && cmd3
```

Untuk kejelasan, gunakan `{ ...; }` atau `( ... )`:

```bash
{ cmd1 || cmd2; } && cmd3
```

### 6.5 Interaksi dengan `set -e`

Dengan `set -e`, skrip berhenti saat ada perintah gagal. Namun:

```bash
set -e
cmd1 && cmd2    # jika cmd1 gagal, skrip TIDAK berhenti (bagian dari &&)
```

### 6.6 Contoh Lintas Bahasa

| Bahasa | AND | OR | Perilaku |
|---|---|---|---|
| Bash | `&&` | `\|\|` | Exit status |
| Zsh | `&&` | `\|\|` | Exit status |
| PowerShell | `-and` | `-or` | Boolean murni |
| Dart/JS | `&&` | `\|\|` | Boolean (Dart) / operand (JS) |
| Lua | `and` | `or` | Mengembalikan operand |

**Lua mengembalikan operand, bukan boolean:**

```lua
local x = false and print("tidak jalan")   -- x = false
local y = "a" or "b"                       -- y = "a"
```

**JavaScript juga:**

```javascript
const x = null && foo();   // x = null, foo() tidak dipanggil
const y = "a" || "b";      // y = "a"
```

### 6.7 Pola Guard Clause

```bash
# Bash: source config hanya jika ada
[[ -f "$config" ]] && source "$config"

# Dart: null-safe
user != null && user.isLoggedIn

# Lua: null-safe
user and user.loggedIn

# PowerShell
if ($user -and $user.IsLoggedIn) { ... }
```

### 6.8 Null-Coalescing dan Optional Chaining (Referensi Lintas Bahasa)

- **Dart/JS:** `??`, `?.`
- **PowerShell:** `??` (PS 7+)
- **Lua:** `a or default` (idiom)
- **Bash:** `${var:-default}`, `${var:=default}`

---

## **7. Kontrol Alur: Kondisional, Perulangan, Fungsi**

### **7.1 Struktur Kondisional**

#### 7.1.1 Exit Codes (`$?`)

Setiap perintah mengembalikan **exit status**: `0` = sukses, non-nol = gagal.

```bash
echo "hi"
echo "Exit: $?"        # 0

ls /tidak/ada 2>/dev/null
echo "Exit: $?"        # 2 (atau non-nol)
```

#### 7.1.2 `if ... then ... fi`

```bash
if perintah; then
  # dijalankan jika perintah sukses
elif perintah_lain; then
  # jika kondisi pertama gagal dan ini sukses
else
  # jika semua gagal
fi
```

#### 7.1.3 `[ ]` vs `[[ ]]`

| Aspek | `[ ]` (test) | `[[ ]]` (keyword) |
|---|---|---|
| Tipe | Perintah eksternal | Keyword Bash |
| Quoting | Wajib hati-hati | Tidak wajib |
| Pattern matching | Tidak | Ya (`==`, `!=`) |
| Regex | Tidak | Ya (`=~`) |
| `&&`, `\|\|` di dalam | Tidak | Ya |
| Word splitting | Rentan | Aman |
| Rekomendasi | Hanya untuk POSIX | **Gunakan ini di Bash** |

**Perhatian `<` dan `>` di `[ ]`:** Harus di-escape (`\>`), jika tidak dianggap redirection.

```bash
[ "$a" \> "$b" ]    # benar
[[ "$a" > "$b" ]]   # benar (tanpa escape)
```

#### 7.1.4 Operator Perbandingan

**String:**

| Operator | Arti |
|---|---|
| `==` | Sama |
| `!=` | Tidak sama |
| `<`, `>` | Leksikografis |
| `-z` | Kosong |
| `-n` | Tidak kosong |
| `=~` | Regex (hanya `[[ ]]`) |

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

**File:**

| Operator | Arti |
|---|---|
| `-e` | Ada |
| `-f` | File biasa |
| `-d` | Direktori |
| `-s` | Ukuran > 0 |
| `-r` | Bisa dibaca |
| `-w` | Bisa ditulis |
| `-x` | Bisa dieksekusi |
| `-L` | Symlink |
| `-v` | Variabel terdefinisi (Bash 4.2+) |

#### 7.1.5 Menggabungkan Kondisi

```bash
# Cara 1: di dalam [[ ]]
if [[ -f "$f" && -r "$f" ]]; then ...

# Cara 2: command list
if [ -f "$f" ] && [ -r "$f" ]; then ...

# Cara 3: OR
if [[ "$u" == "root" || "$g" == "admin" ]]; then ...
```

#### 7.1.6 `case ... esac`

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

#### 7.1.7 Ternary di Bash

Bash tidak punya operator ternary seperti `?:` di C. Namun:

```bash
# Arithmetic ternary
result=$(( a > b ? a : b ))

# Idiom short-circuit
[[ $x -gt 0 ]] && echo "positif" || echo "non-positif"
```

#### 7.1.8 `set -euo pipefail` — Praktik Robust

```bash
set -e          # berhenti pada error
set -u          # error jika variabel belum didefinisikan
set -o pipefail # pipe gagal jika salah satu komponen gagal
```

Atau digabung: `set -euo pipefail`.

**Peringatan:** `set -e` tidak berlaku di dalam kondisi `if`, `&&`, `||`, `!`. Gunakan `trap` untuk cleanup.

---

### **7.2 Perulangan**

#### 7.2.1 `for` Berbasis Daftar

```bash
for buah in apel jeruk mangga; do
  echo "Suka $buah"
done

# Dari glob (aman untuk nama dengan spasi)
for f in *.txt; do
  [[ -f "$f" ]] || continue
  cp "$f" "$f.bak"
done
```

#### 7.2.2 `for` Gaya C

```bash
for (( i=0; i<5; i++ )); do
  echo "$i"
done
```

> **Koreksi penting:** Variabel `i` **bukan lokal** secara implisit. Ia tetap ada setelah loop:

```bash
for (( i=0; i<3; i++ )); do :; done
echo "$i"   # Output: 3
```

Untuk membuatnya lokal, gunakan `local i` di dalam fungsi.

#### 7.2.3 `while` dan `until`

```bash
# while: selama kondisi benar
while [[ ! -f "$file" ]]; do
  echo "Menunggu..."
  sleep 5
done

# until: sampai kondisi benar
until grep -q "READY" "$log"; do
  sleep 2
done
```

#### 7.2.4 Membaca File Baris demi Baris

```bash
# Cara aman
while IFS= read -r line; do
  printf '%s\n' "$line"
done < "$file"

# Baca ke array
mapfile -t lines < "$file"

# CSV sederhana
while IFS=, read -r nama usia kota; do
  echo "$nama | $usia | $kota"
done < data.csv
```

> **Catatan:** `IFS=, read` tidak menangani quoted field seperti `"Smith, John"`. Untuk CSV kompleks, gunakan tool khusus (mis. `csvkit`, `python`).

#### 7.2.5 `break` dan `continue` (termasuk `n`)

```bash
for i in {1..10}; do
  [[ $i -eq 5 ]] && break
  [[ $((i % 2)) -eq 0 ]] && continue
  echo "$i"
done

# Untuk nested loop
for i in 1 2 3; do
  for j in a b c; do
    [[ $j == b ]] && break 2   # keluar dari kedua loop
  done
done
```

#### 7.2.6 `select` — Menu Interaktif

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

#### 7.2.7 Pitfall Loop

| Pitfall | Solusi |
|---|---|
| `for f in $(ls)` | `for f in *` |
| `cat file \| while read` (subshell) | `while read ... done < file` |
| Infinite loop | Pastikan kondisi bisa berubah; tambahkan `break` |
| Variabel di loop tidak terlihat | Hindari subshell, atau gunakan `mapfile` |

---

### **7.3 Fungsi dan Scoping**

#### 7.3.1 Sintaks

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

#### 7.3.2 Argumen

Fungsi menerima argumen lewat `$1`, `$2`, `$@`, `$#`, seperti skrip:

```bash
greet() {
  local nama="$1"
  echo "Halo, $nama"
}
greet "Budi"
```

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
```

#### 7.3.3 Return: Exit Code dan `stdout`

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

#### 7.3.4 Cakupan Variabel: `local` vs Global

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

> **Koreksi:** Variabel loop `for (( i=0; ... ))` **tetap global**. Untuk melokalkannya, deklarasikan `local i` di dalam fungsi.

#### 7.3.5 Pustaka Fungsi (Sourcing)

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

#### 7.3.6 `export -f` — Ekspor Fungsi

Fungsi bisa diekspor ke subshell:

```bash
my_func() { echo "hi"; }
export -f my_func
bash -c 'my_func'   # hi
```

#### 7.3.7 Debugging Fungsi

- `declare -f nama_fungsi` — tampilkan definisi fungsi.
- `unset -f nama_fungsi` — hapus fungsi.
- `command nama_perintah` — bypass fungsi dengan nama sama.
- `FUNCNAME`, `BASH_SOURCE`, `BASH_LINENO` — variabel debugging.

---

## **8. Array dan Manipulasi Teks**

### **8.1 Array**

```bash
# Indexed array
arr=(satu dua tiga)
echo "${arr[0]}"        # satu
echo "${arr[@]}"        # semua elemen
echo "${#arr[@]}"       # jumlah elemen
arr+=(empat)            # tambah

# Iterasi
for x in "${arr[@]}"; do echo "$x"; done

# Slice
echo "${arr[@]:1:2}"    # dua tiga
```

### **8.2 Associative Array (Bash 4+)**

```bash
declare -A umur
umur[budi]=25
umur[ani]=30
for k in "${!umur[@]}"; do
  echo "$k → ${umur[$k]}"
done
```

### **8.3 `mapfile` / `readarray`**

```bash
mapfile -t lines < file.txt    # -t menghapus trailing newline
```

### **8.4 Alat Manipulasi Teks**

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

**Contoh gabungan:**

```bash
# 10 IP paling sering muncul di access.log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Cari file .log lebih dari 7 hari, hapus
find /var/log -name '*.log' -mtime +7 -print0 | xargs -0 rm
```

### **8.5 `getopts` — Parsing Opsi**

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
10. **Gunakan `trap`** untuk cleanup:

```bash
trap 'rm -f "$tmpfile"' EXIT
```

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

### 9.3 Debugging

```bash
set -x          # tampilkan perintah yang dijalankan
set -v          # tampilkan input mentah
PS4='+${BASH_SOURCE}:${LINENO}: '   # prompt trace informatif
bash -n script.sh    # cek sintaks tanpa eksekusi
shellcheck script.sh # linter (sangat direkomendasikan)
```

**Contoh `trap` untuk cleanup:**

```bash
#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Bekerja di $tmpdir"
# ... kerja ...
```

---

## **10. Studi Kasus Terpadu**

### Studi Kasus 1: Pembersih File Log

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly LOG_DIR="${1:-/var/log}"
readonly MAX_AGE=7
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
  local f
  for f in "$LOG_DIR"/*.log; do
    [[ -f "$f" ]] || continue
    if [[ $(find "$f" -mtime +$MAX_AGE 2>/dev/null) ]]; then
      hapus_file "$f"
    fi
  done
}

main "$@"
```

**Konsep yang dipakai:**
- `set -euo pipefail`, `readonly`, parameter default `${1:-...}`.
- `shopt -s nullglob`.
- Fungsi dengan `local`.
- `printf` alih-alih `echo`.
- `--` pada `rm` untuk keamanan.

### Studi Kasus 2: Pemroses CSV dan Laporan

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly INPUT="${1:?Usage: $0 <file.csv>}"

declare -A total_per_kota

while IFS=, read -r nama usia kota; do
  [[ "$nama" == "Nama" ]] && continue   # skip header
  [[ -z "$nama" ]] && continue
  total_per_kota["$kota"]=$(( ${total_per_kota["$kota"]:-0} + 1 ))
done < "$INPUT"

printf '%-15s %s\n' "Kota" "Jumlah"
for k in "${!total_per_kota[@]}"; do
  printf '%-15s %s\n' "$k" "${total_per_kota[$k]}"
done | sort -k2 -rn
```

**Konsep yang dipakai:**
- Associative array, default parameter `${var:-0}`.
- IFS lokal untuk `read`.
- Pattern matching `==` di dalam `[[ ]]`.
- `sort` untuk laporan.

### Studi Kasus 3: Menu Interaktif dengan `select`

```bash
#!/usr/bin/env bash
set -euo pipefail

pilih() {
  select opt in "Lihat tanggal" "Lihat user" "Keluar"; do
    case "$opt" in
      "Lihat tanggal") date ;;
      "Lihat user")    whoami ;;
      "Keluar")        return 0 ;;
      *)               echo "Pilihan tidak valid" >&2 ;;
    esac
  done
}

pilih
```

---

## **11. Referensi**

### Dokumentasi Resmi

- **Bash Manual — Shell Expansions:** <https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html>
- **Bash Manual — Conditional Expressions:** <https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html>
- **Bash Manual — Loop Commands:** <https://www.gnu.org/software/bash/manual/html_node/Loop-Commands.html>
- **Bash Manual — Functions:** <https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html>
- **POSIX Shell Command Language:** <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html>

### Wiki Komunitas

- **Greg's Wiki — BashFAQ/031 (if/test):** <https://mywiki.wooledge.org/BashFAQ/031>
- **Greg's Wiki — BashFAQ/001 (Read file line by line):** <https://mywiki.wooledge.org/BashFAQ/001>
- **Greg's Wiki — BashFAQ/053 (Variable Scope):** <https://mywiki.wooledge.org/BashFAQ/053>
- **Greg's Wiki — BashPitfalls:** <https://mywiki.wooledge.org/BashPitfalls>

### Tutorial & Buku

- **The Linux Command Line** (William Shotts) — <http://linuxcommand.org/tlcl.php>
- **Advanced Bash-Scripting Guide** (Mendel Cooper) — <https://tldp.org/LDP/abs/html/>
- **ryanstutorials.net — Bash Scripting:** <https://ryanstutorials.net/bash-scripting-tutorial/>
- **Linuxize — Bash if/else, case, loops:** <https://linuxize.com/>

### Tooling

- **shellcheck:** <https://www.shellcheck.net/>
- **explainshell:** <https://explainshell.com/>

---

## **Penutup**

Dokumen ini menyatukan enam file terpisah menjadi satu penjelasan utuh, dengan:

- **Koreksi kesalahan faktual:** brace expansion dipisahkan dari globbing; `i` di `for ((...))` tidak lokal; PowerShell tidak punya wildcard `**`; script `eval` berulang dihapus.
- **Penambahan materi yang hilang:** quoting, opsi shell (`dotglob`, `nullglob`, `failglob`, `globstar`, `extglob`, `nocaseglob`, `GLOBIGNORE`), array, associative array, `mapfile`, `getopts`, `trap`, `set -euo pipefail`, text processing, studi kasus.
- **Penataan ulang alur belajar:** dari ekspansi shell → word splitting → globbing → pattern matching → short-circuiting → kontrol alur → array & teks → praktik terbaik → studi kasus.
- **Integrasi antar-topik:** setiap konsep dikaitkan dengan konsep lain (misalnya, bagaimana quoting mempengaruhi word splitting dan globbing, bagaimana `IFS` mempengaruhi `read` dan loop).

<!-- Dengan struktur ini, dokumen dapat dibaca secara linear sebagai kurikulum, atau dijadikan referensi cepat lewat daftar isi dan tabel perbandingan. -->

> * **[Ke Atas](#)**
> * **[Selanjutnya][selanjutnya]**
> * **[Sebelumnya][sebelumnya]**
> * **[Kurikulum][kurikulum]**
> * **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->
[1]:../README.md
[2]:./short-circuiting.md
[3]:./globbing.md
[4]:./word-splitting.md
