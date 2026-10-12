# Fase 2: Scripting Dasar — Dari Perintah ke Program

## Ringkasan Fase
Fase 2 terdiri dari 3 modul:
1. **Modul 2.1** — Struktur Script dan Kontrol Alur
2. **Modul 2.2** — Fungsi, Input/Output, dan Redirection
3. **Modul 2.3** — Error Handling dan Debugging Dasar

## Hasil Audit Cepat
| Aspek | Temuan | Rekomendasi |
|---|---|---|
| Prasyarat | Tidak terlihat eksplisit prasyarat Fase 1 | Tambahkan prasyarat: terminal, filesystem, perintah dasar (`ls`, `cd`, `cat`, `grep`, `chmod`), editor teks, konsep PATH |
| Shell target | Contoh memakai `#!/bin/zsh`, tetapi banyak sintaks kompatibel Bash/POSIX | Tegaskan target: Zsh. Jelaskan perbedaan Zsh vs Bash vs POSIX `sh` |
| Modul 2.1 | Sudah mencakup shebang, permission, variabel, kondisional, loop, argumen | Perlu tambahan: quoting, expansion, operator test, `break`/`continue`, `until`, `repeat`, `select`, `shift`, `$?`, `$$`, `$!`, `$LINENO`, `setopt` dasar |
| Modul 2.2 | Fungsi, I/O, redirection, pipe, `tee` | Perlu tambahan: file descriptor, here-doc, here-string, process substitution, command substitution, `xargs`, `printf`, `read` dengan IFS |
| Modul 2.3 | Error handling, `set -e`, `trap`, debugging | Perlu tambahan: `shellcheck`, logging terstruktur, `PS4`, `zshdb`, sinyal, exit code kustom, `set -u`, `pipefail` |
| Proyek akhir | Tidak ada | Rekomendasi: mini-project CLI sederhana (backup, log analyzer, menu interaktif) |
| Lompatan | 2.1 langsung memakai `[[ ]]`, `case`, `(( ))`, tanpa menjelaskan dasar test | Berikan fondasi test dan aritmetika di 2.1 |

**Kesimpulan audit:** Kurikulum sudah bagus sebagai kerangka, tetapi untuk menjadi dokumentasi pembelajaran mandiri yang lengkap, perlu ditambah materi dasar yang “menjembatani” dan beberapa topik Zsh yang jarang dibahas. Saya akan menyisipkan materi tambahan tersebut sambil tetap mengacu pada kurikulum.

---

# Modul 2.1: Struktur Script dan Kontrol Alur

## Mini-Daftar Isi Modul 2.1
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Struktur Script: Shebang, Komentar, Exit Code
4. Memberikan Permission Eksekusi (`chmod +x`)
5. Variabel: Lokal vs Environment
6. Kondisional: `if`, `elif`, `else`, `case`
7. Perbandingan String dan Angka
8. Loop: `for`, `while`, `until`, `repeat`
9. Argumen Script: `$1`, `$@`, `$#`, dan Lainnya
10. Terminologi Esensial
11. Visualisasi yang Direkomendasikan
12. Hubungan dengan Modul Lain
13. Tips dan Praktik Terbaik
14. Potensi Kesalahan Umum & Solusi
15. Sumber Referensi Lengkap

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul 2.1 adalah **titik balik** dari “mengetik perintah satu per satu” menjadi “menulis program yang bisa dijalankan ulang”. Di sini Anda belajar:
- Menulis file script pertama.
- Memberi shebang agar sistem tahu interpreter yang dipakai.
- Memberi izin eksekusi.
- Membuat keputusan dengan `if`, `case`.
- Mengulang operasi dengan `for`, `while`, `until`, `repeat`.
- Menerima argumen dari terminal.
- Memahami variabel lokal dan environment.

**Peran dalam kurikulum:** Modul ini adalah fondasi mutlak. Tanpa menguasai kontrol alur dan argumen, Anda akan kesulitan di Modul 2.2 (fungsi, pipe, redirection) dan Modul 2.3 (error handling, debugging). Semua script profesional—dari installer, deployment, backup, hingga CLI tool—dibangun dari konsep-konsep ini.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1 Script sebagai “Lem” Unix
Filosofi Unix: buat program kecil yang melakukan satu hal dengan baik, lalu gabungkan. Script adalah **lem** yang menyatukan program-program kecil itu. Script bukan bahasa pemrograman berat; ia adalah bahasa perekat.

### 2.2 Shebang sebagai Kontrak
Shebang (`#!`) adalah kontrak antara file dan kernel. Kernel membaca dua byte pertama. Jika `#!`, kernel menjalankan interpreter yang ditunjuk, lalu meneruskan file script sebagai argumen. Ini membuat script bisa dieksekusi seperti program biasa.

### 2.3 Exit Code sebagai Komunikasi
Setiap perintah mengembalikan angka 0–255. `0` = sukses, non-zero = gagal. Ini adalah “bahasa” antar program. Script yang baik selalu mengomunikasikan statusnya lewat exit code.

### 2.4 Kontrol Alur sebagai Pengambilan Keputusan
`if` dan `case` membuat script bisa memilih jalur. Loop membuat script bisa mengulang tanpa lelah. Inilah inti otomatisasi.

### 2.5 Fail Fast
Prinsip: jika ada error, hentikan segera. Jangan lanjutkan ke langkah berikutnya yang bisa merusak data. Di Modul 2.3, ini diwujudkan dengan `set -e`.

### 2.6 Portabilitas vs Kekhususan Shell
Zsh memiliki fitur yang tidak ada di Bash/POSIX. Anda perlu tahu kapan boleh memakai fitur Zsh dan kapan harus portabel. Contoh: `{1..10}` didukung Zsh dan Bash modern, tetapi tidak di POSIX `sh`.

---

## 3. Struktur Script: Shebang, Komentar, Exit Code

### 3.1 Shebang
```bash
#!/bin/zsh
```
**Penjelasan kata demi kata:**
- `#!` — disebut **shebang** atau **hash-bang**. Dua karakter pertama file. Memberi tahu kernel bahwa file ini adalah script yang harus dijalankan oleh interpreter.
- `/bin/zsh` — path absolut ke interpreter Zsh. Kernel akan menjalankan `/bin/zsh /path/ke/script`.
- Baris ini **harus** berada di baris pertama. Tidak boleh ada spasi sebelum `#!`. Jika ada spasi, kernel tidak mengenalinya.

**Varian shebang:**
```bash
#!/usr/bin/env zsh
```
- `#!/usr/bin/env` — menjalankan program `env`.
- `env` mencari `zsh` di `PATH`.
- Lebih portabel karena tidak bergantung pada lokasi absolut `/bin/zsh`.
- Kekurangan: sedikit lebih lambat dan bergantung pada `env` yang tersedia.

**Shebang lain:**
```bash
#!/bin/bash
#!/bin/sh
#!/usr/bin/python3
```

**Jika shebang tidak ada:**
- Script tetap bisa dijalankan dengan `zsh namafile.zsh` atau `bash namafile.sh`.
- Tetapi tidak bisa dijalankan dengan `./namafile` karena kernel tidak tahu interpreter-nya.

### 3.2 Komentar
```bash
# Ini komentar
```
**Penjelasan:**
- `#` memulai komentar sampai akhir baris.
- Di dalam script, `#` di awal baris atau setelah whitespace dianggap komentar.
- Di dalam tanda kutip, `#` bukan komentar: `echo "# bukan komentar"`.
- Di dalam parameter expansion seperti `${var#pattern}`, `#` punya arti khusus (menghapus prefix). Jadi konteks sangat penting.

**Komentar yang baik:**
- Menjelaskan **mengapa**, bukan **apa**.
- Contoh: `# Gunakan -r agar backslash tidak diinterpretasi` lebih baik daripada `# baca file`.

### 3.3 Exit Code
```bash
exit 0
exit 1
```
**Penjelasan:**
- `exit` — menghentikan script dan mengembalikan kode ke pemanggil.
- `0` — sukses.
- `1` — error umum. Bisa juga `2`, `127`, `130`, dll.
- Jika `exit` tanpa argumen, status perintah terakhir yang dipakai.

**Melihat exit code terakhir:**
```bash
echo $?
```
- `$?` — variabel khusus yang menyimpan exit code perintah terakhir.
- Setelah `ls /tmp`, `echo $?` akan menampilkan `0` jika sukses.
- Setelah `ls /tidakada`, `echo $?` menampilkan `2` (tergantung sistem).

**Contoh script lengkap dan penjelasan baris demi baris:**
```bash
#!/bin/zsh
# script_pertama.zsh - Contoh script dasar

# Kondisional
if [[ $# -eq 0 ]]; then
    echo "Error: Butuh minimal satu argumen" >&2
    exit 1
elif [[ "$1" == "hello" ]]; then
    echo "Halo, dunia!"
else
    echo "Argumen: $1"
fi

# Loop for
for file in *.txt; do
    echo "Memproses: $file"
done

# Loop while
counter=1
while [[ $counter -le 5 ]]; do
    echo "Iterasi ke-$counter"
    ((counter++))
done

# Loop dengan range (Zsh-specific)
for i in {1..10}; do
    echo $i
done

# Case statement
case "$1" in
    start)  echo "Memulai..." ;;
    stop)   echo "Menghentikan..." ;;
    *)      echo "Perintah tidak dikenal" ;;
esac
```

**Bedah baris demi baris:**
- `#!/bin/zsh` — shebang, interpreter Zsh.
- `# script_pertama.zsh - Contoh script dasar` — komentar deskriptif.
- `if [[ $# -eq 0 ]]; then` — `if` memulai kondisional. `[[ ... ]]` adalah extended test. `$#` adalah jumlah argumen. `-eq` adalah operator numerik “equal”. `then` memulai blok jika kondisi benar.
- `echo "Error: Butuh minimal satu argumen" >&2` — `echo` mencetak pesan. `>&2` mengarahkan stdout ke stderr (file descriptor 2). Pesan error sebaiknya ke stderr.
- `exit 1` — keluar dengan kode error.
- `elif [[ "$1" == "hello" ]]; then` — `elif` = else if. `$1` argumen pertama. Tanda kutip `"$1"` mencegah word splitting. `==` dalam `[[ ]]` adalah pencocokan string/pattern; karena RHS dikutip, ini menjadi perbandingan literal.
- `echo "Halo, dunia!"` — cetak sapaan.
- `else` — blok jika semua kondisi sebelumnya salah.
- `echo "Argumen: $1"` — cetak argumen pertama.
- `fi` — menutup `if`.
- `for file in *.txt; do` — loop `for`. `file` adalah variabel loop. `*.txt` adalah glob; shell akan menggantinya dengan daftar file yang cocok. `do` memulai blok.
- `echo "Memproses: $file"` — cetak nama file.
- `done` — menutup loop.
- `counter=1` — assignment variabel. Tidak boleh ada spasi di sekitar `=`.
- `while [[ $counter -le 5 ]]; do` — loop `while`. `-le` = less or equal (numerik).
- `echo "Iterasi ke-$counter"` — cetak iterasi.
- `((counter++))` — aritmetika. `(( ... ))` mengevaluasi ekspresi aritmetika. `counter++` menaikkan nilai setelah evaluasi. Catatan: exit status `(( ... ))` adalah 0 jika hasil non-zero, 1 jika hasil nol. Hati-hati dengan `set -e`.
- `done` — menutup while.
- `for i in {1..10}; do` — brace expansion. `{1..10}` menghasilkan `1 2 3 ... 10`.
- `echo $i` — cetak angka.
- `done` — menutup for.
- `case "$1" in` — `case` memulai percabangan pola. `"$1"` adalah subjek yang diperiksa. `in` memulai daftar pola.
- `start)  echo "Memulai..." ;;` — pola `start`. `)` memisahkan pola dari perintah. `;;` mengakhiri klausa case.
- `stop)   echo "Menghentikan..." ;;` — pola `stop`.
- `*)      echo "Perintah tidak dikenal" ;;` — `*` adalah pola default (semua).
- `esac` — menutup `case` (case dibalik).

---

## 4. Memberikan Permission Eksekusi (`chmod +x`)

Agar script bisa dijalankan dengan `./script_pertama.zsh`, file harus memiliki izin eksekusi.

```bash
chmod +x script_pertama.zsh
./script_pertama.zsh
```

**Penjelasan:**
- `chmod` — change mode. Mengubah izin file.
- `+x` — menambahkan izin execute.
- `script_pertama.zsh` — nama file.
- `./` — menjalankan file di direktori saat ini. Tanpa `./`, shell mencari di `PATH`, bukan di direktori saat ini.

**Mode numerik:**
```bash
chmod 755 script_pertama.zsh
```
- `7` = `rwx` untuk owner.
- `5` = `r-x` untuk group.
- `5` = `r-x` untuk others.

**Mode simbolik:**
```bash
chmod u+x script_pertama.zsh   # owner
chmod g+x script_pertama.zsh   # group
chmod o+x script_pertama.zsh   # others
chmod a+x script_pertama.zsh   # all
```

**Melihat izin:**
```bash
ls -l script_pertama.zsh
```
Output: `-rwxr-xr-x 1 user user 123 ... script_pertama.zsh`

**Umask:**
- `umask` menentukan izin default file baru. Biasanya `022` → file baru `644`, direktori `755`.
- Jika script tidak bisa dieksekusi, cek `ls -l` dan `umask`.

**Jika muncul “bad interpreter”:**
- Shebang salah, misalnya `#!/bin/zsh` tetapi Zsh tidak ada di `/bin/zsh`.
- Solusi: gunakan `#!/usr/bin/env zsh` atau jalankan `zsh script.zsh`.
- Periksa dengan `which zsh`.

---

## 5. Variabel: Lokal vs Environment

### 5.1 Assignment Dasar
```bash
nama="Budi"
umur=25
```
**Penjelasan:**
- `nama` — nama variabel.
- `=` — operator assignment.
- `"Budi"` — nilai string. Tanda kutip mencegah word splitting.
- **Tidak boleh ada spasi** di sekitar `=`. `nama = "Budi"` akan dianggap perintah `nama` dengan argumen `=` dan `Budi`.

### 5.2 Menggunakan Variabel
```bash
echo "Halo, $nama"
echo "Umur: ${umur}"
```
- `$nama` — ekspansi variabel.
- `${umur}` — bentuk kurung kurawal, berguna jika diikuti teks lain: `${umur}tahun`.

### 5.3 Environment Variable
```bash
export PATH="$PATH:$HOME/bin"
```
- `export` — menjadikan variabel sebagai environment variable, diwariskan ke proses anak.
- `PATH` — variabel environment berisi daftar direktori untuk mencari perintah.
- `$PATH` — nilai PATH saat ini.
- `$HOME` — direktori home user.
- `:` — pemisah antar direktori di PATH.

**Melihat environment:**
```bash
env
printenv
set
```
- `env` — tampilkan environment variable.
- `printenv` — sama, bisa untuk satu variabel: `printenv PATH`.
- `set` — tampilkan semua variabel shell dan fungsi.

### 5.4 Variabel Lokal dalam Fungsi
```bash
sapa() {
    local nama="$1"
    echo "Halo, $nama!"
}
```
- `local` — variabel hanya berlaku di dalam fungsi. Tidak bocor ke luar.
- `$1` — argumen pertama fungsi.
- Tanpa `local`, variabel akan global.

### 5.5 Readonly
```bash
readonly PI=3.14
```
- `readonly` — variabel tidak bisa diubah setelah ditetapkan.
- Berguna untuk konstanta.

### 5.6 Typeset
```bash
typeset -g var_global
typeset -x VAR_EXPORT
typeset -r KONSTANTA
```
- `typeset` — deklarasi variabel dengan atribut.
- `-g` — global.
- `-x` — export.
- `-r` — readonly.

### 5.7 Scope dan Pewarisan
- **Shell variable** — hanya di shell saat ini.
- **Environment variable** — diwariskan ke child process.
- Child process **tidak bisa** mengubah environment parent.
- Contoh: `export VAR=1; zsh -c 'echo $VAR'` akan mencetak `1`.
- Tanpa `export`, `zsh -c 'echo $VAR'` akan kosong.

### 5.8 Variabel Khusus
| Variabel | Arti |
|---|---|
| `$0` | Nama script |
| `$1`–`$9` | Argumen posisi |
| `$#` | Jumlah argumen |
| `$@` | Semua argumen sebagai kata terpisah |
| `$*` | Semua argumen sebagai satu string |
| `$?` | Exit code perintah terakhir |
| `$$` | PID shell saat ini |
| `$!` | PID background job terakhir |
| `$_` | Argumen terakhir perintah sebelumnya |
| `$LINENO` | Nomor baris saat ini |
| `$RANDOM` | Angka acak |

---

## 6. Kondisional: `if`, `elif`, `else`, `case`

### 6.1 `if`
```bash
if [[ kondisi ]]; then
    perintah
fi
```
- `if` — memulai.
- `[[ ... ]]` — extended test.
- `then` — blok benar.
- `fi` — penutup.

### 6.2 `elif` dan `else`
```bash
if [[ $1 == "start" ]]; then
    echo "Mulai"
elif [[ $1 == "stop" ]]; then
    echo "Stop"
else
    echo "Tidak dikenal"
fi
```

### 6.3 `case`
```bash
case "$1" in
    start)  echo "Memulai..." ;;
    stop)   echo "Menghentikan..." ;;
    *)      echo "Perintah tidak dikenal" ;;
esac
```
- `case` — memilih berdasarkan pola.
- `$1` — subjek.
- `in` — mulai daftar.
- `start)` — pola.
- `;;` — akhir klausa.
- `*` — default.
- `esac` — penutup.

**Pola `case` yang lebih kaya:**
```bash
case "$file" in
    *.txt)       echo "Text file" ;;
    *.jpg|*.png) echo "Image file" ;;
    [0-9]*)      echo "Dimulai angka" ;;
    *)           echo "Lainnya" ;;
esac
```
- `*.txt` — glob.
- `*.jpg|*.png` — alternasi.
- `[0-9]*` — karakter pertama angka.

### 6.4 `select` (opsional, sering muncul di menu)
```bash
select pilihan in "Start" "Stop" "Keluar"; do
    case $pilihan in
        Start) echo "Mulai" ;;
        Stop) echo "Stop" ;;
        Keluar) break ;;
        *) echo "Pilih 1-3" ;;
    esac
done
```
- `select` — membuat menu interaktif.
- `break` — keluar dari loop.

---

## 7. Perbandingan String dan Angka

### 7.1 Operator Numerik
| Operator | Arti |
|---|---|
| `-eq` | equal |
| `-ne` | not equal |
| `-lt` | less than |
| `-le` | less or equal |
| `-gt` | greater than |
| `-ge` | greater or equal |

Contoh:
```bash
if [[ $umur -ge 18 ]]; then
    echo "Dewasa"
fi
```

### 7.2 Operator String
| Operator | Arti |
|---|---|
| `==` atau `=` | sama |
| `!=` | tidak sama |
| `<` | lexicographic less |
| `>` | lexicographic greater |
| `-z` | string kosong |
| `-n` | string tidak kosong |

Contoh:
```bash
if [[ "$nama" == "Budi" ]]; then
    echo "Halo Budi"
fi

if [[ -z "$nama" ]]; then
    echo "Nama kosong"
fi
```

### 7.3 Operator File
| Operator | Arti |
|---|---|
| `-e` | file ada |
| `-f` | file biasa |
| `-d` | direktori |
| `-r` | bisa dibaca |
| `-w` | bisa ditulis |
| `-x` | bisa dieksekusi |
| `-s` | ukuran > 0 |
| `-L` | symlink |

Contoh:
```bash
if [[ -f "$file" ]]; then
    echo "File ada"
fi
```

### 7.4 `[[ ]]` vs `[ ]` vs `(( ))`
- `[[ ... ]]` — Zsh/Bash extended. Mendukung pattern matching, regex `=~`, tidak perlu quoting ketat. **Disarankan.**
- `[ ... ]` — POSIX test. Perlu quoting, operator `=` bukan `==`, tidak mendukung `&&` di dalam.
- `(( ... ))` — aritmetika. Untuk perbandingan angka.

Contoh:
```bash
[[ $a -lt $b ]]
(( a < b ))
[ "$a" -lt "$b" ]
```

### 7.5 Operator Logika
```bash
if [[ $a -gt 0 && $b -gt 0 ]]; then
    echo "Keduanya positif"
fi

if [[ $a -gt 0 || $b -gt 0 ]]; then
    echo "Salah satu positif"
fi

if [[ ! -f "$file" ]]; then
    echo "File tidak ada"
fi
```

---

## 8. Loop: `for`, `while`, `until`, `repeat`

### 8.1 `for`
```bash
for file in *.txt; do
    echo "Memproses: $file"
done
```
- `for` — mulai loop.
- `file` — variabel loop.
- `in *.txt` — daftar item.
- `do ... done` — blok.

**For dengan range:**
```bash
for i in {1..10}; do
    echo $i
done
```

**For gaya C:**
```bash
for ((i=1; i<=10; i++)); do
    echo $i
done
```

**For dengan argumen:**
```bash
for arg in "$@"; do
    echo "Argumen: $arg"
done
```
- `"$@"` — semua argumen sebagai kata terpisah. Selalu kutip.

### 8.2 `while`
```bash
counter=1
while [[ $counter -le 5 ]]; do
    echo "Iterasi ke-$counter"
    ((counter++))
done
```
- `while` — ulang selama kondisi benar.
- `((counter++))` — increment.

**While membaca file:**
```bash
while IFS= read -r line; do
    echo "$line"
done < file.txt
```
- `IFS=` — mencegah trimming spasi.
- `read -r` — jangan interpretasi backslash.
- `< file.txt` — redirect input.

### 8.3 `until`
```bash
counter=1
until [[ $counter -gt 5 ]]; do
    echo "Iterasi ke-$counter"
    ((counter++))
done
```
- `until` — ulang selama kondisi **salah**. Kebalikan `while`.

### 8.4 `repeat` (Zsh)
```bash
repeat 5 do
    echo "Halo"
done
```
- `repeat` — ulang sejumlah kali.
- `5` — jumlah pengulangan.
- `do ... done` — blok.

### 8.5 `break` dan `continue`
```bash
for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        break
    fi
    if [[ $i -eq 3 ]]; then
        continue
    fi
    echo $i
done
```
- `break` — keluar dari loop.
- `continue` — lewati iterasi saat ini, lanjut ke berikutnya.

---

## 9. Argumen Script: `$1`, `$@`, `$#`, dan Lainnya

```bash
#!/bin/zsh
echo "Nama script: $0"
echo "Jumlah argumen: $#"
echo "Argumen pertama: $1"
echo "Semua argumen: $@"
echo "Semua argumen (satu string): $*"
```
**Penjelasan:**
- `$0` — nama script.
- `$#` — jumlah argumen.
- `$1` — argumen pertama.
- `$2` — argumen kedua, dst.
- `$@` — semua argumen sebagai kata terpisah. Dalam tanda kutip: `"$@"` → `"$1" "$2" ...`.
- `$*` — semua argumen sebagai satu string. Dalam tanda kutip: `"$*"` → `"$1 $2 ..."`.

**Shift:**
```bash
echo "Sebelum shift: $1"
shift
echo "Setelah shift: $1"
```
- `shift` — menggeser argumen ke kiri. `$2` menjadi `$1`, `$1` hilang.

**Loop argumen:**
```bash
for arg in "$@"; do
    echo "Argumen: $arg"
done
```

**Validasi argumen:**
```bash
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <input> <output>" >&2
    exit 1
fi
```

---

## 10. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| Shebang | Baris pertama script yang menentukan interpreter | `#!/bin/zsh` |
| Exit Code | Kode numerik status perintah | `0` sukses, `1` error |
| Argumen | Nilai yang diberikan ke script | `$1`, `$2` |
| Environment Variable | Variabel yang diwariskan ke proses anak | `PATH`, `HOME` |
| Shell Variable | Variabel lokal shell, tidak diwariskan | `nama="Budi"` |
| Loop | Struktur pengulangan | `for`, `while` |
| Kondisional | Struktur pengambilan keputusan | `if`, `case` |
| Glob | Pola nama file | `*.txt` |
| Brace Expansion | Ekspansi kurung kurawal | `{1..10}` |
| Word Splitting | Pemecahan string menjadi kata | `$var` tanpa kutip |
| Quoting | Menggunakan tanda kutip untuk mencegah ekspansi | `"$var"` |
| File Descriptor | Nomor yang merepresentasikan stream | `0` stdin, `1` stdout, `2` stderr |
| Redirection | Mengubah arah stream | `>`, `>>`, `2>` |
| Pipe | Menghubungkan stdout ke stdin | `ls | grep txt` |
| Subshell | Shell anak | `(cd /tmp && ls)` |
| Command Substitution | Mengganti perintah dengan outputnya | `$(date)` |
| Arithmetic Expansion | Evaluasi aritmetika | `$((1+2))` |
| Parameter Expansion | Manipulasi variabel | `${var:-default}` |

---

## 11. Visualisasi yang Direkomendasikan

1. **Diagram alur eksekusi script:**
   ```
   User menjalankan ./script.zsh
        |
        v
   Kernel membaca shebang #!/bin/zsh
        |
        v
   Kernel menjalankan /bin/zsh script.zsh
        |
        v
   Zsh membaca baris demi baris
        |
        v
   Eksekusi perintah, kontrol alur, loop
        |
        v
   Exit code dikembalikan ke user
   ```

2. **Flowchart if/elif/else:**
   ```
   [Kondisi 1] --Ya--> [Blok 1]
        | Tidak
        v
   [Kondisi 2] --Ya--> [Blok 2]
        | Tidak
        v
   [Blok else]
   ```

3. **Flowchart loop:**
   ```
   [Inisialisasi] -> [Kondisi] --Ya--> [Blok] -> [Update] -> [Kondisi]
                          | Tidak
                          v
                        [Selesai]
   ```

4. **Pohon scope variabel:**
   ```
   Parent Shell
   ├── Shell variable: nama
   ├── Environment variable: PATH (diwariskan)
   └── Child Process
       ├── Menerima PATH
       └── Tidak menerima nama (kecuali di-export)
   ```

5. **Tabel operator perbandingan** (sudah ada di atas).

---

## 12. Hubungan dengan Modul Lain

- **Modul 2.2** — Fungsi, Input/Output, Redirection.
  - Anda akan memakai `if`, `case`, loop untuk memproses input.
  - Argumen script `$1`, `$@` akan dipakai di fungsi.
  - Exit code akan dipakai untuk error handling.
- **Modul 2.3** — Error Handling dan Debugging.
  - `set -e` bergantung pada exit code.
  - `trap` memakai fungsi dan exit code.
  - `set -x` membantu debug loop dan kondisional.
- **Fase berikutnya** — Scripting Lanjutan, otomatisasi, CLI tool.

---

## 13. Tips dan Praktik Terbaik

1. **Selalu gunakan shebang** `#!/usr/bin/env zsh` untuk portabilitas.
2. **Quote variabel** kecuali Anda benar-benar ingin word splitting: `"$var"`.
3. **Gunakan `[[ ]]`** daripada `[ ]` di Zsh/Bash.
4. **Gunakan `local`** di dalam fungsi.
5. **Validasi argumen** di awal script.
6. **Gunakan `set -u`** untuk error jika variabel tidak terdefinisi.
7. **Gunakan `set -e`** untuk fail fast (hati-hati dengan `((counter++))`).
8. **Gunakan `shellcheck`** untuk memeriksa script.
9. **Beri nama variabel yang jelas**: `input_file`, bukan `f`.
10. **Hindari parsing `ls`**. Gunakan glob atau `find`.
11. **Gunakan `printf`** daripada `echo` untuk output kompleks.
12. **Beri komentar “mengapa”**, bukan “apa”.
13. **Uji script dengan `zsh -n script.zsh`** untuk cek sintaks tanpa eksekusi.
14. **Gunakan `zsh -x script.zsh`** untuk debug.

---

## 14. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `bad interpreter: No such file` | Shebang salah | Gunakan `#!/usr/bin/env zsh` |
| `Permission denied` | Tidak ada izin eksekusi | `chmod +x script.zsh` |
| `command not found` | `./` tidak dipakai | Jalankan `./script.zsh` |
| `nama = "Budi"` error | Spasi di sekitar `=` | `nama="Budi"` |
| `$1` kosong | Argumen tidak diberikan | Validasi `$#` |
| `unbound variable` | `set -u` dan variabel kosong | Inisialisasi variabel |
| Loop tidak berhenti | Kondisi selalu benar | Pastikan update variabel |
| `((counter++))` dengan `set -e` | Exit status 1 saat hasil 0 | Gunakan `((++counter))` atau `counter=$((counter+1))` |
| `$@` tanpa kutip | Word splitting | Gunakan `"$@"` |
| `case` tanpa `;;` | Lupa terminator | Tambahkan `;;` |
| CRLF di file | Dibuat di Windows | `dos2unix script.zsh` |
| Glob tidak cocok | Tidak ada file `.txt` | Gunakan `nullglob` atau cek |
| `cd` gagal | Direktori tidak ada | Cek dengan `[[ -d ]]` |
| `rm -rf $var` | Variabel kosong | Quote dan validasi: `rm -rf -- "$var"` |

---

## 15. Sumber Referensi Lengkap

- **Zsh Roadmap — Scripting:** https://zsh.sourceforge.io/Guide/zshguide.html
- **Zsh Manual — Conditional Expressions:** https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html
- **Zsh Manual — Arithmetic Evaluation:** https://zsh.sourceforge.io/Doc/Release/Arithmetic-Evaluation.html
- **Zsh Manual — Parameters:** https://zsh.sourceforge.io/Doc/Release/Parameters.html
- **Zsh Manual — Options:** https://zsh.sourceforge.io/Doc/Release/Options.html
- **Zsh Manual — Shell Grammar:** https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html
- **Shebang (Unix):** https://en.wikipedia.org/wiki/Shebang_(Unix)
- **GNU Coreutils — chmod:** https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html
- **ShellCheck:** https://www.shellcheck.net/
- **Google Shell Style Guide:** https://google.github.io/styleguide/shellguide.html
- **ZSH Development Guidelines (Data-Wise):** https://github.com/Data-Wise/flow-cli/blob/master/docs/ZSH-DEVELOPMENT-GUIDELINES.md
- **Bash Pitfalls (banyak berlaku di Zsh):** https://mywiki.wooledge.org/BashPitfalls

---

#### Modul 2.1 sudah dibahas sangat mendalam: shebang, permission, variabel, kondisional, perbandingan, loop, argumen, terminologi, visualisasi, tips, kesalahan umum, dan referensi.

---

# Modul 2.2: Fungsi, Input/Output, dan Redirection

## Mini-Daftar Isi Modul 2.2
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Fungsi: Definisi, Pemanggilan, Parameter, Return
    - 3.1 Definisi Fungsi
    - 3.2 Memanggil Fungsi
    - 3.3 Parameter Posisi
    - 3.4 Return Value: Exit Code vs Stdout
    - 3.5 Variabel Lokal dalam Fungsi (`local`)
    - 3.6 Fungsi Rekursif (Opsional)
    - 3.7 Autoload Functions di Zsh (Opsional)
4. Input dari Pengguna
    - 4.1 `read`
    - 4.2 Prompt di Zsh vs Bash
    - 4.3 `IFS` dan `read`
    - 4.4 Opsi `read`: `-r`, `-s`, `-n`, `-t`
    - 4.5 `select`
5. Tiga Stream Standar
    - 5.1 stdin (0)
    - 5.2 stdout (1)
    - 5.3 stderr (2)
    - 5.4 File Descriptor
6. Redirection
    - 6.1 `>` Overwrite
    - 6.2 `>>` Append
    - 6.3 `2>` Redirect stderr
    - 6.4 `&>` Redirect stdout + stderr
    - 6.5 `2>&1`
    - 6.6 `<` Redirect input
    - 6.7 Here-Document `<<`
    - 6.8 Here-String `<<<`
    - 6.9 Process Substitution `<()`, `>()`
    - 6.10 `exec` untuk Redirection Permanen
7. Pipe dan Pipeline
    - 7.1 Pipe `|`
    - 7.2 `pipefail`
    - 7.3 Contoh Pipeline
    - 7.4 `xargs`
8. `tee`: Output ke File dan Layar
9. Command Substitution
10. `printf` vs `echo`
11. Terminologi Esensial
12. Visualisasi yang Direkomendasikan
13. Hubungan dengan Modul Lain
14. Tips dan Praktik Terbaik
15. Potensi Kesalahan Umum & Solusi
16. Sumber Referensi Lengkap

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul 2.2 membahas tiga pilar yang membuat script menjadi **alat yang bisa berkomunikasi**:
1. **Fungsi** — membungkus logika agar bisa dipakai ulang.
2. **Input/Output** — menerima data dari pengguna atau file, dan mengeluarkan hasil.
3. **Redirection & Pipe** — mengarahkan aliran data antar program.

Dalam kurikulum, modul ini adalah jembatan antara “script yang berjalan sendiri” (Modul 2.1) dan “script yang tangguh menghadapi error” (Modul 2.3). Tanpa fungsi, script akan panjang dan sulit dirawat. Tanpa redirection dan pipe, Anda tidak bisa memanfaatkan kekuatan Unix: menggabungkan program kecil menjadi pipeline yang kuat.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1 Fungsi sebagai “Kotak Alat”
Fungsi adalah kotak yang diberi nama. Anda memasukkan bahan (argumen), kotak memproses, lalu mengeluarkan hasil. Tujuan: **DRY** (Don’t Repeat Yourself). Jika logika yang sama dipakai tiga kali, jadikan fungsi.

### 2.2 Input/Output sebagai “Percakapan”
Setiap program Unix memiliki tiga “pintu”:
- **stdin (0)** — pintu masuk data.
- **stdout (1)** — pintu keluar hasil normal.
- **stderr (2)** — pintu keluar pesan error.

Redirection adalah cara **memindahkan pintu** ke file, perangkat, atau program lain. Pipe adalah **pipa** yang menyambungkan stdout satu program ke stdin program lain.

### 2.3 Filosofi Unix: “Everything is a File”
File, keyboard, layar, printer, bahkan koneksi jaringan direpresentasikan sebagai file. Karena itu, redirection bisa bekerja pada hampir semua hal.

### 2.4 Pipeline sebagai “Perakitan”
Bayangkan pabrik: satu stasiun memotong, stasiun lain mengecat, stasiun lain mengemas. Pipe adalah ban berjalan yang membawa barang antar stasiun. Inilah kekuatan sebenarnya Unix.

### 2.5 Fail Fast dan Pipefail
Di Modul 2.3, `set -o pipefail` akan memastikan pipeline gagal jika salah satu komponen gagal. Ini penting karena secara default, exit code pipeline hanya mengambil exit code perintah terakhir.

---

## 3. Fungsi: Definisi, Pemanggilan, Parameter, Return

### 3.1 Definisi Fungsi
```bash
sapa() {
    echo "Halo!"
}
```
**Penjelasan sintaks:**
- `sapa` — nama fungsi.
- `()` — tanda bahwa ini fungsi, bukan variabel.
- `{` — awal blok.
- `echo "Halo!"` — isi fungsi.
- `}` — akhir blok.

**Aturan penulisan:**
- `{` harus dipisahkan dengan spasi atau newline dari nama fungsi. `sapa(){` salah.
- `}` harus di awal baris atau setelah `;`. `echo "Halo!"; }` benar.

### 3.2 Memanggil Fungsi
```bash
sapa
```
- Cukup tulis nama fungsi.
- Tidak perlu `()` saat memanggil.
- Jika fungsi didefinisikan di file lain, Anda perlu `source file.zsh` atau `. file.zsh`.

### 3.3 Parameter Posisi
```bash
sapa() {
    local nama="$1"
    echo "Halo, $nama!"
}
sapa "Dunia"
```
**Penjelasan:**
- `$1` — argumen pertama yang diberikan ke fungsi.
- `$2` — argumen kedua, dst.
- `$@` — semua argumen.
- `$#` — jumlah argumen.
- `local nama="$1"` — `local` membatasi variabel hanya di dalam fungsi.

**Contoh dengan banyak argumen:**
```bash
perkenalan() {
    echo "Nama: $1"
    echo "Umur: $2"
    echo "Kota: $3"
}
perkenalan "Budi" 25 "Jakarta"
```

### 3.4 Return Value: Exit Code vs Stdout
Di shell, fungsi tidak “mengembalikan nilai” seperti bahasa pemrograman lain. Ada dua mekanisme:
1. **Exit code** — angka 0–255, diakses dengan `$?`.
2. **Stdout** — teks yang dicetak, ditangkap dengan command substitution `$(...)`.

**Contoh exit code:**
```bash
cek_file() {
    if [[ -f "$1" ]]; then
        return 0
    else
        return 1
    fi
}
cek_file "data.txt"
if [[ $? -eq 0 ]]; then
    echo "File ada"
fi
```
- `return 0` — sukses.
- `return 1` — gagal.
- `$?` — exit code fungsi terakhir.

**Contoh stdout:**
```bash
hitung_luas() {
    local panjang=$1
    local lebar=$2
    echo $((panjang * lebar))
}
luas=$(hitung_luas 5 3)
echo "Luas: $luas"
```
- `echo $((panjang * lebar))` — mencetak hasil ke stdout.
- `$(...)` — command substitution, menangkap stdout.
- `luas=...` — menyimpan ke variabel.

**Kapan pakai exit code vs stdout?**
- Exit code: untuk status sukses/gagal.
- Stdout: untuk data yang akan diolah lebih lanjut.

### 3.5 Variabel Lokal dalam Fungsi (`local`)
```bash
counter=10
tambah() {
    local counter=5
    ((counter++))
    echo "Dalam fungsi: $counter"
}
tambah
echo "Di luar: $counter"
```
Output:
```
Dalam fungsi: 6
Di luar: 10
```
- `local counter=5` — variabel lokal, tidak mengubah `counter` global.
- Tanpa `local`, `counter++` akan mengubah variabel global.

### 3.6 Fungsi Rekursif (Opsional)
```bash
faktorial() {
    if [[ $1 -le 1 ]]; then
        echo 1
    else
        local prev=$(faktorial $(( $1 - 1 )))
        echo $(( $1 * prev ))
    fi
}
faktorial 5
```
- Fungsi memanggil dirinya sendiri.
- `$(( $1 - 1 ))` — aritmetika.
- `$(...)` — menangkap hasil rekursi.
- Hati-hati: rekursi dalam shell lambat dan bisa menghabiskan stack.

### 3.7 Autoload Functions di Zsh (Opsional)
Zsh mendukung `autoload` untuk memuat fungsi saat pertama dipanggil.
```bash
autoload -Uz nama_fungsi
```
- `-U` — suppress alias expansion.
- `-z` — gaya Zsh.
- Fungsi disimpan di file `nama_fungsi` di direktori `$fpath`.

---

## 4. Input dari Pengguna

### 4.1 `read`
```bash
read nama
echo "Halo, $nama"
```
- `read` — membaca satu baris dari stdin.
- `nama` — variabel tujuan.
- Jika tidak ada variabel, `read` menyimpan ke `$REPLY`.

**Membaca banyak nilai:**
```bash
read nama umur kota
```
Input: `Budi 25 Jakarta`
- `nama=Budi`, `umur=25`, `kota=Jakarta`.

### 4.2 Prompt di Zsh vs Bash
Kurikulum menggunakan:
```bash
read -p "Masukkan nama Anda: " nama
```
Ini adalah sintaks **Bash**. Di **Zsh**, opsi `-p` bukan untuk prompt; `-p` digunakan untuk membaca dari coprocess. Untuk Zsh, gunakan:
```bash
read "nama?Masukkan nama Anda: "
```
- `"nama?prompt"` — format Zsh: nama variabel, tanda `?`, lalu prompt.
- Jika Anda ingin script kompatibel Bash dan Zsh, gunakan:
```bash
printf "Masukkan nama Anda: "
read nama
```
- `printf` — mencetak prompt tanpa newline.
- `read` — membaca input.

**Contoh lengkap Zsh:**
```bash
read "nama?Masukkan nama Anda: "
echo "Halo, $nama"
```

### 4.3 `IFS` dan `read`
`IFS` (Internal Field Separator) menentukan pemisah kata.
```bash
IFS=: read user pass <<< "budi:rahasia"
echo "User: $user"
echo "Pass: $pass"
```
- `IFS=:` — pemisah adalah `:`.
- `<<<` — here-string.
- `user` mendapat `budi`, `pass` mendapat `rahasia`.

**IFS default:** spasi, tab, newline.

### 4.4 Opsi `read`: `-r`, `-s`, `-n`, `-t`
```bash
read -r line          # Jangan interpretasi backslash
read -s -p "Password: " pass   # Bash: silent
read -s "pass?Password: "      # Zsh: silent
read -n 1 jawaban     # Baca 1 karakter
read -t 5 input       # Timeout 5 detik
```
- `-r` — raw, backslash tidak dianggap escape.
- `-s` — silent, input tidak ditampilkan (untuk password).
- `-n N` — baca N karakter.
- `-t N` — timeout N detik.

### 4.5 `select`
```bash
select pilihan in "Start" "Stop" "Keluar"; do
    case $pilihan in
        Start) echo "Memulai..." ;;
        Stop)  echo "Menghentikan..." ;;
        Keluar) break ;;
        *)     echo "Pilih 1-3" ;;
    esac
done
```
- `select` — membuat menu interaktif.
- `in "Start" "Stop" "Keluar"` — daftar opsi.
- `do ... done` — blok.
- `$pilihan` — nilai yang dipilih.
- `break` — keluar dari loop.

**Output:**
```
1) Start
2) Stop
3) Keluar
? 
```

---

## 5. Tiga Stream Standar

### 5.1 stdin (0)
- Pintu masuk data.
- Default: keyboard.
- Bisa diarahkan dari file: `command < file`.

### 5.2 stdout (1)
- Pintu keluar hasil normal.
- Default: terminal.
- Bisa diarahkan ke file: `command > file`.

### 5.3 stderr (2)
- Pintu keluar pesan error.
- Default: terminal.
- Bisa diarahkan ke file: `command 2> error.log`.

### 5.4 File Descriptor
- Angka yang merepresentasikan stream.
- `0` = stdin, `1` = stdout, `2` = stderr.
- Bisa buka fd tambahan: `exec 3> file`.

**Contoh:**
```bash
echo "Pesan normal"
echo "Pesan error" >&2
```
- `>&2` — mengarahkan stdout ke stderr.

---

## 6. Redirection

### 6.1 `>` Overwrite
```bash
echo "Pesan ini ke file" > output.txt
```
- `>` — redirect stdout ke file.
- Jika file ada, isinya ditimpa.
- Jika tidak ada, file dibuat.

### 6.2 `>>` Append
```bash
echo "Pesan ini ditambahkan" >> output.txt
```
- `>>` — tambahkan ke akhir file.
- Tidak menimpa.

### 6.3 `2>` Redirect stderr
```bash
command_berat 2> error.log
```
- `2>` — redirect stderr ke file.
- stdout tetap ke terminal.

### 6.4 `&>` Redirect stdout + stderr
```bash
command &> semua.log
```
- `&>` — redirect stdout dan stderr ke file.
- Di Zsh, `&>` didukung.
- Di Bash, `&>` juga didukung, tetapi POSIX tidak.

### 6.5 `2>&1`
```bash
command > output.log 2>&1
```
- `> output.log` — stdout ke file.
- `2>&1` — stderr ke stdout (yang sudah ke file).
- Urutan penting: `2>&1 > output.log` salah; stderr tetap ke terminal.

### 6.6 `<` Redirect input
```bash
command < input.txt
```
- `<` — stdin dari file.

### 6.7 Here-Document `<<`
```bash
cat <<EOF
Halo, $nama
Ini baris kedua.
EOF
```
- `<<EOF` — mulai here-doc, delimiter `EOF`.
- Isi sampai `EOF` dikirim ke stdin `cat`.
- `$nama` — diekspansi.
- Jika `<<'EOF'`, tidak ada ekspansi.

### 6.8 Here-String `<<<`
```bash
cat <<< "Halo dunia"
```
- `<<<` — kirim string sebagai stdin.
- Berguna untuk `read`: `read var <<< "nilai"`.

### 6.9 Process Substitution `<()`, `>()`
```bash
diff <(ls dir1) <(ls dir2)
```
- `<(...)` — menjalankan perintah, hasilnya seperti file.
- `>(...)` — output ke perintah.
- Zsh dan Bash mendukung.

### 6.10 `exec` untuk Redirection Permanen
```bash
exec > log.txt 2>&1
echo "Semua output ke log"
```
- `exec` — mengganti shell saat ini.
- `exec > log.txt` — stdout shell saat ini ke file.
- Berlaku untuk sisa script.

---

## 7. Pipe dan Pipeline

### 7.1 Pipe `|`
```bash
ps aux | grep zsh | awk '{print $2}'
```
- `|` — menghubungkan stdout kiri ke stdin kanan.
- `ps aux` — daftar proses.
- `grep zsh` — filter baris mengandung `zsh`.
- `awk '{print $2}'` — cetak kolom kedua.

**Penjelasan `awk`:**
- `awk` — bahasa pemrosesan teks.
- `'{print $2}'` — program: cetak field kedua.
- `$2` — kolom kedua.

### 7.2 `pipefail`
```bash
set -o pipefail
```
- Jika salah satu perintah di pipeline gagal, exit code pipeline adalah exit code perintah gagal.
- Tanpa `pipefail`, exit code adalah perintah terakhir.

### 7.3 Contoh Pipeline
```bash
cat access.log | grep "404" | wc -l
```
- `cat` — baca file.
- `grep "404"` — filter.
- `wc -l` — hitung baris.

### 7.4 `xargs`
```bash
find . -name "*.txt" | xargs rm
```
- `xargs` — mengambil stdin, menjadikannya argumen untuk perintah.
- `rm` — hapus file.
- Hati-hati dengan nama file berspasi; gunakan `-print0` dan `xargs -0`.

**Aman:**
```bash
find . -name "*.txt" -print0 | xargs -0 rm
```

---

## 8. `tee`: Output ke File dan Layar

```bash
command 2>&1 | tee log.txt
```
- `tee` — membaca stdin, menulis ke stdout dan file.
- `2>&1` — stderr ke stdout.
- `| tee log.txt` — stdout ke `tee`, lalu ke layar dan file.

**Opsi `-a`:**
```bash
command | tee -a log.txt
```
- `-a` — append, bukan overwrite.

---

## 9. Command Substitution

```bash
tanggal=$(date)
echo "Hari ini: $tanggal"
```
- `$(...)` — menjalankan perintah, mengganti dengan outputnya.
- `date` — perintah tanggal.
- `tanggal=...` — simpan ke variabel.

**Backtick (usang):**
```bash
tanggal=`date`
```
- Gunakan `$(...)` karena lebih mudah dibaca dan bisa nested.

---

## 10. `printf` vs `echo`

```bash
printf "Nama: %s\n" "$nama"
```
- `printf` — format output.
- `%s` — placeholder string.
- `\n` — newline.
- Lebih portabel dan aman daripada `echo`.

**Perbandingan:**
- `echo` — sederhana, tetapi perilaku berbeda antar shell.
- `printf` — format terkontrol, disarankan untuk output kompleks.

---

## 11. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| Fungsi | Blok kode bernama | `sapa() { echo "Halo"; }` |
| Parameter | Argumen fungsi | `$1`, `$2` |
| Return Code | Exit code fungsi | `return 0` |
| Local Variable | Variabel hanya di fungsi | `local x=1` |
| stdin | Stream input standar | fd 0 |
| stdout | Stream output standar | fd 1 |
| stderr | Stream error standar | fd 2 |
| File Descriptor | Nomor stream | `0`, `1`, `2` |
| Redirection | Mengubah arah stream | `>`, `>>`, `2>` |
| Pipe | Menghubungkan stdout ke stdin | `|` |
| Pipeline | Rangkaian pipe | `ls | grep txt` |
| `tee` | Output ke file dan layar | `| tee log.txt` |
| Here-Doc | Input multiline | `<<EOF` |
| Here-String | Input string | `<<<` |
| Process Substitution | File virtual dari perintah | `<(ls)` |
| Command Substitution | Output perintah ke variabel | `$(date)` |
| `xargs` | Bangun argumen dari stdin | `| xargs rm` |
| `IFS` | Pemisah field | `IFS=:` |
| `select` | Menu interaktif | `select x in a b; do` |

---

## 12. Visualisasi yang Direkomendasikan

1. **Diagram Tiga Stream Standar:**
   ```
   +-------------+
   |   Program   |
   |             |
   |  stdin (0)  <---- Keyboard / File
   |  stdout (1) ----> Terminal / File / Pipe
   |  stderr (2) ----> Terminal / File
   +-------------+
   ```

2. **Diagram Redirection:**
   ```
   command > file       : stdout -> file
   command 2> file      : stderr -> file
   command &> file      : stdout + stderr -> file
   command < file       : stdin <- file
   command1 | command2  : stdout1 -> stdin2
   command | tee file   : stdout -> file + layar
   ```

3. **Diagram Pipeline:**
   ```
   ps aux  |  grep zsh  |  awk '{print $2}'
      |           |              |
   stdout     stdin/stdout    stdin/stdout
   ```

4. **Diagram Fungsi:**
   ```
   Input argumen -> [ Fungsi ] -> Output stdout
                        |
                    Exit code
   ```

5. **Diagram Here-Doc:**
   ```
   cat <<EOF
   baris1
   baris2
   EOF
   ```

---

## 13. Hubungan dengan Modul Lain

- **Modul 2.1** — Anda sudah belajar kontrol alur, argumen, variabel. Fungsi dan redirection memperkuat itu.
- **Modul 2.3** — `set -e`, `trap`, `pipefail` akan memanfaatkan exit code dan redirection.
- **Fase berikutnya** — Scripting lanjutan: `zparseopts`, `getopts`, CLI tool, otomatisasi deployment.

---

## 14. Tips dan Praktik Terbaik

1. **Gunakan `local`** di dalam fungsi untuk menghindari efek samping.
2. **Quote variabel** saat digunakan: `"$var"`.
3. **Gunakan `printf`** untuk output yang membutuhkan format.
4. **Gunakan `read -r`** untuk mencegah interpretasi backslash.
5. **Gunakan `IFS=`** saat membaca baris utuh: `while IFS= read -r line`.
6. **Gunakan `set -o pipefail`** di script yang memakai pipeline.
7. **Hindari `cat file | command`**; gunakan `command < file` atau `command file`.
8. **Gunakan `tee`** jika ingin melihat output sekaligus menyimpannya.
9. **Gunakan `xargs -0`** untuk nama file dengan spasi.
10. **Gunakan `$(...)`** daripada backtick.
11. **Gunakan `>&2`** untuk pesan error.
12. **Gunakan `exec`** dengan hati-hati; bisa mengubah seluruh script.
13. **Uji pipeline** dengan data kecil sebelum data besar.
14. **Gunakan `shellcheck`** untuk mendeteksi masalah redirection.

---

## 15. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| `read -p` tidak muncul di Zsh | `-p` bukan untuk prompt di Zsh | Gunakan `read "var?prompt"` |
| `$1` kosong di fungsi | Argumen tidak diberikan | Cek `$#` |
| `local` di luar fungsi | `local` hanya di fungsi | Gunakan di dalam fungsi |
| `return` dengan string | `return` hanya angka | Gunakan `echo` untuk string |
| `>` menimpa file penting | Lupa `>>` | Gunakan `>>` untuk append |
| `2>&1 > file` salah | Urutan redirection | `> file 2>&1` |
| Pipe gagal tapi exit code 0 | Tidak ada `pipefail` | `set -o pipefail` |
| `xargs` gagal pada spasi | Nama file berspasi | `find -print0 | xargs -0` |
| `read` memotong spasi | IFS default | `IFS= read -r line` |
| `select` loop tak berhenti | Tidak ada `break` | Tambahkan `break` |
| `tee` tidak menulis | Pipe salah | `command | tee file` |
| `printf` tidak ada newline | Lupa `\n` | `printf "%s\n" "$var"` |
| `exec` mengubah shell | `exec > file` permanen | Gunakan di subshell `( exec > file; ... )` |
| Here-doc tidak berakhir | Delimiter tidak cocok | Pastikan `EOF` di awal baris |
| Process substitution tidak didukung | Shell POSIX | Gunakan Zsh/Bash |

---

## 16. Sumber Referensi Lengkap

- **Zsh Functions:** https://zsh.sourceforge.io/Doc/Release/Functions.html
- **Zsh Redirection:** https://zsh.sourceforge.io/Doc/Release/Redirection.html
- **Zsh Input/Output:** https://zsh.sourceforge.io/Doc/Release/Input-Output.html
- **Zsh Parameters:** https://zsh.sourceforge.io/Doc/Release/Parameters.html
- **Bash Redirection:** https://www.gnu.org/software/bash/manual/html_node/Redirections.html
- **Bash `read`:** https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-read
- **`tee` Manual:** https://www.gnu.org/software/coreutils/manual/html_node/tee-invocation.html
- **`xargs` Manual:** https://www.gnu.org/software/findutils/manual/html_node/find_html/xargs-invocation.html
- **`printf` Manual:** https://www.gnu.org/software/coreutils/manual/html_node/printf-invocation.html
- **ShellCheck:** https://www.shellcheck.net/
- **Google Shell Style Guide:** https://google.github.io/styleguide/shellguide.html

---

#### Modul 2.2 sudah dibahas lengkap: fungsi, parameter, return, variabel lokal, input (`read`, `select`), tiga stream standar, redirection, pipe, `tee`, command substitution, `printf`, terminologi, visualisasi, tips, kesalahan umum, dan referensi. Ini adalah modul terakhir di Fase 2. Setelah ini, Fase 2 tuntas dan kita bisa masuk ke proyek mini atau Fase 3.

---

# Modul 2.3: Error Handling dan Debugging Dasar

## Mini-Daftar Isi Modul 2.3
1. Deskripsi Konkret & Peran dalam Kurikulum
2. Konsep Kunci & Filosofi Mendalam
3. Exit Code dan `$?`
4. Opsi Shell: `set -e`, `set -u`, `set -o pipefail`
5. `set -x` dan `PS4`
6. `trap` dan Cleanup
7. Tracing Fungsi dengan `typeset -ft`
8. Logging Terstruktur
9. Debugging Tools: `zsh -n`, `zsh -x`, `shellcheck`, `zshdb`
10. Sinyal dan Exit Code Kustom
11. Terminologi Esensial
12. Visualisasi yang Direkomendasikan
13. Hubungan dengan Modul Lain
14. Tips dan Praktik Terbaik
15. Potensi Kesalahan Umum & Solusi
16. Sumber Referensi Lengkap

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara membuat script yang **tidak mudah runtuh** saat menghadapi error, serta cara **menemukan penyebab error** ketika script tidak berjalan sesuai harapan.

Yang dipelajari:
- Membaca dan memanfaatkan exit code.
- Menggunakan `set -e`, `set -u`, `set -o pipefail` untuk fail fast.
- Menangkap sinyal dan event dengan `trap` untuk cleanup.
- Menyalakan mode debug `set -x` dan menyesuaikan `PS4`.
- Melacak eksekusi fungsi dengan `typeset -ft`.
- Menulis log terstruktur.
- Menggunakan alat bantu seperti `zsh -n`, `zsh -x`, `shellcheck`, dan `zshdb`.

**Peran dalam kurikulum:** Ini adalah modul yang membedakan script “mainan” dengan script “produksi”. Script yang baik tidak hanya berjalan saat semuanya lancar, tetapi juga:
- Berhenti dengan aman saat ada error.
- Membersihkan file sementara.
- Memberikan pesan error yang jelas.
- Bisa dilacak saat ada masalah.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1 Exit Code sebagai Bahasa Status
Setiap perintah mengembalikan angka 0–255. `0` = sukses, non-zero = gagal. Script yang baik selalu memeriksa dan mengomunikasikan status ini.

### 2.2 Fail Fast
Prinsip: jika ada error, hentikan segera. Jangan lanjutkan ke langkah berikutnya yang bisa merusak data. `set -e` adalah implementasi prinsip ini.

### 2.3 Graceful Degradation
Tidak semua error harus menghentikan script. Kadang kita ingin menangani error, memberi pesan, lalu tetap melanjutkan. `trap` dan pengecekan eksplisit memungkinkan ini.

### 2.4 Observability
Script yang baik bisa “dilihat” isi perutnya. `set -x`, `PS4`, dan logging terstruktur memberikan visibilitas.

### 2.5 Idempotent Cleanup
Cleanup harus aman dijalankan berkali-kali. Contoh: `rm -f` tidak error jika file tidak ada.

### 2.6 Trap sebagai “Pintu Darurat”
`trap` memastikan cleanup tetap berjalan meskipun script dihentikan paksa (Ctrl+C, kill, error).

---

## 3. Exit Code dan `$?`

### 3.1 Definisi
- Exit code: angka 0–255 yang dikembalikan perintah.
- `0` = sukses.
- `1` = error umum.
- `2` = misuse of shell builtins.
- `126` = tidak bisa dieksekusi.
- `127` = command not found.
- `128 + n` = fatal signal n.
- `130` = SIGINT (Ctrl+C).
- `143` = SIGTERM.

### 3.2 `$?`
```bash
ls /tmp
echo $?
```
- `$?` — exit code perintah terakhir.
- Setelah `ls /tmp`, biasanya `0`.
- Setelah `ls /tidakada`, biasanya `2`.

### 3.3 Contoh Pengecekan
```bash
if ! command -v git &>/dev/null; then
    echo "Git tidak terinstall" >&2
    exit 1
fi
```
**Penjelasan:**
- `command -v git` — cek apakah `git` ada di PATH.
- `&>/dev/null` — buang stdout dan stderr.
- `!` — negasi.
- `if ! ...; then` — jika git tidak ada.
- `echo ... >&2` — pesan error ke stderr.
- `exit 1` — keluar dengan error.

### 3.4 `$pipestatus` di Zsh
```bash
ls /tmp | grep tmp | wc -l
echo $pipestatus
```
- `$pipestatus` — array exit code setiap perintah dalam pipeline.
- Di Bash: `${PIPESTATUS[@]}`.

---

## 4. Opsi Shell: `set -e`, `set -u`, `set -o pipefail`

### 4.1 `set -e` (errexit)
```bash
set -e
```
- `set -e` — keluar otomatis jika ada perintah yang gagal.
- Di Zsh, ini menyalakan opsi `ERR_EXIT`.
- Alternatif Zsh: `setopt ERR_EXIT`.

**Pengecualian `set -e`:**
- Perintah di dalam `if`, `while`, `until`, `&&`, `||`, `!` tidak memicu exit.
- Pipeline: hanya exit code perintah terakhir yang diperiksa, kecuali `pipefail`.
- Command substitution: perilaku bisa berbeda.
- Aritmetika `((...))`: exit status 1 jika hasil 0. Ini sering menyebabkan script keluar tak terduga.

**Contoh pitfall:**
```bash
set -e
counter=0
((counter++))   # hasil 0, exit status 1, script keluar!
echo "Tidak akan tercetak"
```
**Solusi:**
```bash
((++counter))   # pre-increment, hasil 1, exit status 0
# atau
counter=$((counter + 1))
```

### 4.2 `set -u` (nounset)
```bash
set -u
```
- `set -u` — error jika variabel tidak terdefinisi.
- Di Zsh: `setopt NO_UNSET`.

**Contoh:**
```bash
set -u
echo "$nama"   # error: nama: parameter not set
```
**Solusi:**
```bash
echo "${nama:-}"   # default kosong jika tidak ada
```

**Pitfall `$1`:**
```bash
set -u
echo "$1"   # error jika tidak ada argumen
```
**Solusi:**
```bash
echo "${1:-}"
```

### 4.3 `set -o pipefail`
```bash
set -o pipefail
```
- Jika salah satu perintah di pipeline gagal, exit code pipeline adalah exit code perintah gagal.
- Tanpa ini, exit code pipeline hanya dari perintah terakhir.
- Di Zsh: `setopt PIPE_FAIL`.

**Contoh:**
```bash
set -o pipefail
grep "error" file.txt | wc -l
```
Jika `grep` gagal (file tidak ada), pipeline gagal meskipun `wc` sukses.

### 4.4 Kombinasi Umum
```bash
set -euo pipefail
```
- `-e` — exit on error.
- `-u` — error on undefined variable.
- `-o pipefail` — pipe fails if any command fails.
- Sering ditulis sebagai `set -euo pipefail`.
- **Catatan:** Tidak selalu cocok untuk semua script. Kadang terlalu agresif.

### 4.5 `set +e`, `set +u`, `set +o pipefail`
- `+` — mematikan opsi.
- Berguna untuk sementara menonaktifkan fail fast.

---

## 5. `set -x` dan `PS4`

### 5.1 `set -x`
```bash
set -x
echo "Halo"
set +x
```
- `set -x` — menampilkan setiap perintah sebelum dieksekusi.
- Di Zsh: `setopt XTRACE`.
- `set +x` — mematikan.

**Output:**
```
+ echo Halo
Halo
```

### 5.2 `PS4`
```bash
PS4='+${LINENO}: '
set -x
```
- `PS4` — prompt untuk xtrace.
- Default: `+ `.
- Di Zsh, bisa pakai `%N`, `%i`, `%_`:
```bash
PS4='+%N:%i:%_ '
```
- `%N` — nama script.
- `%i` — nomor baris.
- `%_` — nama fungsi.
- Di Bash: `PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '`.

### 5.3 Debug Terarah
```bash
set -x
# kode yang di-debug
set +x
```
- Nyalakan hanya di bagian yang bermasalah.

---

## 6. `trap` dan Cleanup

### 6.1 Sintaks Dasar
```bash
trap 'perintah' SIGNAL
```
- `trap` — menangkap sinyal atau event.
- `'perintah'` — perintah yang dijalankan.
- `SIGNAL` — nama sinyal atau event.

### 6.2 Contoh dari Kurikulum
```bash
cleanup() {
    echo "Membersihkan temporary files..."
    rm -f /tmp/temp_$$
}
trap cleanup EXIT
```
**Penjelasan:**
- `cleanup()` — fungsi cleanup.
- `rm -f /tmp/temp_$$` — hapus file sementara. `$$` adalah PID shell.
- `trap cleanup EXIT` — jalankan `cleanup` saat script keluar, baik normal maupun error.

### 6.3 Event yang Umum
| Event | Arti |
|---|---|
| `EXIT` | Saat script keluar |
| `ERR` | Saat perintah gagal (Zsh/Bash) |
| `INT` | SIGINT (Ctrl+C) |
| `TERM` | SIGTERM (kill) |
| `HUP` | SIGHUP (hangup) |
| `DEBUG` | Sebelum setiap perintah |

### 6.4 Trap Zsh Spesifik
Zsh mendukung fungsi khusus:
```bash
TRAPEXIT() {
    echo "Keluar"
}
TRAPINT() {
    echo "Dibatalkan"
}
TRAPERR() {
    echo "Error"
}
```
- `TRAPEXIT`, `TRAPINT`, `TRAPERR`, `TRAPDEBUG`, dll.
- Lebih rapi daripada `trap` string.

### 6.5 Cleanup dengan `mktemp`
```bash
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
echo "data" > "$tmp"
```
- `mktemp` — buat file sementara dengan nama unik.
- `trap 'rm -f "$tmp"' EXIT` — hapus saat keluar.
- Gunakan tanda kutip tunggal agar `$tmp` dievaluasi saat trap dijalankan, bukan saat didefinisikan.

### 6.6 Trap dengan Sinyal
```bash
trap 'echo "Interrupted"; exit 130' INT
```
- `INT` — Ctrl+C.
- `exit 130` — kode standar untuk SIGINT.

---

## 7. Tracing Fungsi dengan `typeset -ft`

```bash
typeset -ft nama_fungsi
```
- `typeset` — deklarasi atribut.
- `-f` — untuk fungsi.
- `-t` — trace.
- Menyalakan xtrace hanya untuk fungsi tersebut.
- Matikan dengan `typeset +ft nama_fungsi`.

**Contoh:**
```bash
sapa() {
    echo "Halo, $1"
}
typeset -ft sapa
sapa "Dunia"
typeset +ft sapa
```
Output xtrace hanya di dalam `sapa`.

---

## 8. Logging Terstruktur

### 8.1 Fungsi Log Sederhana
```bash
log() {
    local level="$1"
    shift
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $*" >&2
}

log INFO "Script dimulai"
log ERROR "Gagal membaca file"
```
**Penjelasan:**
- `local level="$1"` — level log.
- `shift` — geser argumen, `$*` sekarang pesan.
- `date '+%Y-%m-%d %H:%M:%S'` — timestamp.
- `>&2` — log ke stderr.
- `$*` — semua pesan.

### 8.2 Level Log
```bash
log DEBUG "Detail"
log INFO "Informasi"
log WARN "Peringatan"
log ERROR "Error"
```

### 8.3 Redirect Log ke File
```bash
exec 3>> app.log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] ${*:2}" >&3
}
```
- `exec 3>> app.log` — buka fd 3 untuk append.
- `>&3` — tulis ke fd 3.

---

## 9. Debugging Tools: `zsh -n`, `zsh -x`, `shellcheck`, `zshdb`

### 9.1 `zsh -n`
```bash
zsh -n script.zsh
```
- Cek sintaks tanpa eksekusi.
- Berguna sebelum menjalankan script.

### 9.2 `zsh -x`
```bash
zsh -x script.zsh
```
- Jalankan dengan xtrace.
- Sama seperti `set -x` di awal script.

### 9.3 `shellcheck`
```bash
shellcheck script.zsh
```
- Menganalisis script untuk bug umum.
- Mendukung sh/bash; untuk Zsh, dukungan terbatas.
- Tetap sangat berguna untuk redirection, quoting, dll.

### 9.4 `zshdb`
```bash
zshdb script.zsh
```
- Debugger interaktif untuk Zsh.
- Bisa breakpoint, step, inspect variabel.
- Referensi: https://manpages.ubuntu.com/manpages/focal/man1/zshdb.1.html

---

## 10. Sinyal dan Exit Code Kustom

### 10.1 Daftar Sinyal
```bash
kill -l
```
- Menampilkan daftar sinyal.
- Umum: `HUP`, `INT`, `QUIT`, `TERM`, `KILL`, `STOP`, `CONT`.

### 10.2 Exit Code Kustom
```bash
exit 1   # error umum
exit 2   # misuse
exit 130 # SIGINT
exit 143 # SIGTERM
```
- Gunakan kode yang konsisten.
- Dokumentasikan arti kode di header script.

### 10.3 Menangkap Sinyal
```bash
trap 'echo "Dibatalkan"; exit 130' INT
trap 'echo "Dihentikan"; exit 143' TERM
```

---

## 11. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| Exit Code | Status numerik perintah | `0`, `1`, `130` |
| `$?` | Exit code terakhir | `echo $?` |
| `set -e` | Exit on error | `set -e` |
| `set -u` | Error on undefined variable | `set -u` |
| `pipefail` | Pipe gagal jika salah satu gagal | `set -o pipefail` |
| `trap` | Tangkap sinyal/event | `trap cleanup EXIT` |
| `EXIT` | Event saat script keluar | `trap ... EXIT` |
| `ERR` | Event saat perintah gagal | `trap ... ERR` |
| `INT` | Sinyal Ctrl+C | `trap ... INT` |
| `TERM` | Sinyal terminate | `trap ... TERM` |
| `set -x` | Mode debug | `set -x` |
| `PS4` | Prompt xtrace | `PS4='+$LINENO: '` |
| `typeset -ft` | Trace fungsi | `typeset -ft func` |
| `mktemp` | Buat file sementara | `tmp=$(mktemp)` |
| `shellcheck` | Alat analisis script | `shellcheck script.zsh` |
| `zshdb` | Debugger Zsh | `zshdb script.zsh` |
| `$pipestatus` | Array exit code pipeline | `echo $pipestatus` |
| `TRAPEXIT` | Fungsi trap Zsh | `TRAPEXIT() { ... }` |

---

## 12. Visualisasi yang Direkomendasikan

1. **Diagram Alur Error Handling:**
   ```
   Perintah dijalankan
        |
        v
   Exit code 0? --Ya--> Lanjut
        | Tidak
        v
   set -e aktif? --Ya--> Keluar
        | Tidak
        v
   trap ERR? --Ya--> Jalankan handler
        |
        v
   Lanjut / exit
   ```

2. **Diagram Trap Cleanup:**
   ```
   Script mulai
        |
   trap cleanup EXIT
        |
   ... eksekusi ...
        |
   Script selesai / error / Ctrl+C
        |
        v
   cleanup() dijalankan
        |
        v
   Keluar
   ```

3. **Diagram Xtrace:**
   ```
   set -x
   + echo Halo
   Halo
   + ls /tmp
   file1 file2
   set +x
   ```

4. **Diagram Stream dan Trap:**
   ```
   stdout -> terminal / file
   stderr -> terminal / file
   trap -> cleanup saat EXIT
   ```

---

## 13. Hubungan dengan Modul Lain

- **Modul 2.1** — kontrol alur, argumen, exit code. Error handling memperkuat ini.
- **Modul 2.2** — fungsi, redirection, pipe. `trap` dan `pipefail` bergantung pada pipe dan fungsi.
- **Fase 3** — Scripting Lanjutan: CLI tool, otomatisasi, deployment. Error handling adalah fondasi.
- **Proyek mini** — Anda bisa membuat script backup dengan cleanup, logging, dan fail fast.

---

## 14. Tips dan Praktik Terbaik

1. **Gunakan `set -euo pipefail`** di awal script, tetapi pahami pengecualiannya.
2. **Selalu `trap` cleanup** untuk file sementara.
3. **Gunakan `mktemp`** daripada nama file statis di `/tmp`.
4. **Log ke stderr** agar tidak mengganggu stdout.
5. **Gunakan `printf`** untuk log.
6. **Beri timestamp** di log.
7. **Gunakan `shellcheck`** sebelum commit.
8. **Uji dengan `zsh -n`** untuk cek sintaks.
9. **Gunakan `zsh -x`** untuk debug.
10. **Jangan tinggalkan `set -x`** di produksi.
11. **Dokumentasikan exit code** di header script.
12. **Gunakan `TRAPEXIT`** di Zsh untuk cleanup yang lebih rapi.
13. **Hati-hati dengan `((...))`** di bawah `set -e`.
14. **Gunakan `${var:-}`** untuk variabel opsional di bawah `set -u`.
15. **Tes trap** dengan Ctrl+C dan kill.

---

## 15. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Script keluar tak terduga | `set -e` + `((counter++))` | Gunakan `((++counter))` |
| `unbound variable` | `set -u` + `$1` kosong | `${1:-}` |
| Pipe gagal tapi exit 0 | Tidak ada `pipefail` | `set -o pipefail` |
| Cleanup tidak jalan | Trap tidak dipasang | `trap cleanup EXIT` |
| File temp tertinggal | Tidak ada cleanup | `mktemp` + `trap` |
| Trap tidak berjalan | Salah kutip | Gunakan kutip tunggal |
| `set -x` terlalu berisik | Debug global | Nyalakan di bagian tertentu |
| `PS4` tidak informatif | Default `+ ` | Kustomisasi `PS4` |
| `typeset -ft` tidak berfungsi | Salah nama fungsi | Pastikan fungsi sudah didefinisikan |
| `shellcheck` tidak mendukung Zsh | Keterbatasan alat | Gunakan `zsh -n` juga |
| Exit code salah | Tidak konsisten | Dokumentasikan kode |
| Sinyal tidak tertangkap | Trap salah sinyal | Cek `kill -l` |
| `trap` menimpa trap lain | Hanya satu trap per sinyal | Gabungkan atau gunakan fungsi |
| Log tidak muncul | Ke stdout | Log ke stderr |
| `exec` mengubah shell | Permanen | Gunakan di subshell |

---

## 16. Sumber Referensi Lengkap

- **Zsh Debugging Techniques:** https://hoop.dev/blog/zsh-debug-logging
- **zshdb Debugger:** https://manpages.ubuntu.com/manpages/focal/man1/zshdb.1.html
- **Zsh Manual — Options:** https://zsh.sourceforge.io/Doc/Release/Options.html
- **Zsh Manual — Signals:** https://zsh.sourceforge.io/Doc/Release/Signals.html
- **Zsh Manual — Functions:** https://zsh.sourceforge.io/Doc/Release/Functions.html
- **Bash `set` Builtin:** https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
- **Bash `trap`:** https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-trap
- **ShellCheck:** https://www.shellcheck.net/
- **Google Shell Style Guide:** https://google.github.io/styleguide/shellguide.html
- **BashFAQ — Error Handling:** https://mywiki.wooledge.org/BashFAQ/105
- **Zsh `mktemp`:** https://www.gnu.org/software/coreutils/manual/html_node/mktemp-invocation.html

---

# Proyek Mini Fase 2: “Backup & Log Analyzer CLI”

## Mini-Daftar Isi Proyek Mini
1. Deskripsi Proyek & Tujuan Pembelajaran
2. Konsep & Filosofi
3. Arsitektur & Struktur File
4. Visualisasi
5. Tahap 1: Kerangka Dasar & Menu Interaktif
6. Tahap 2: Fungsi Backup
7. Tahap 3: Fungsi Analisis Log
8. Tahap 4: Input/Output & Redirection
9. Tahap 5: Error Handling, Trap, dan Cleanup
10. Tahap 6: Logging Terstruktur & Debugging
11. Kode Lengkap (`backuptool.zsh`)
12. Cara Menjalankan & Menguji
13. Terminologi Esensial
14. Tips & Praktik Terbaik
15. Potensi Kesalahan Umum & Solusi
16. Hubungan dengan Modul & Fase Berikutnya
17. Sumber Referensi
18. Konfirmasi

---

## 1. Deskripsi Proyek & Tujuan Pembelajaran

**Nama proyek:** `backuptool.zsh` — CLI tool untuk:
1. **Backup** file/folder ke arsip `.tar.gz`.
2. **Analisis log** untuk menghitung error, warning, dan pola tertentu.
3. **Info sistem** singkat (disk, memori, uptime).
4. **Cleanup** file sementara otomatis.
5. **Logging** setiap aksi ke file log.
6. **Menu interaktif** untuk memilih aksi.

**Tujuan pembelajaran:** Menggabungkan **semua** materi Fase 2:
- **Modul 2.1:** shebang, permission, variabel, `if`, `case`, `for`, `while`, `select`, argumen, exit code.
- **Modul 2.2:** fungsi, `local`, `read`, redirection, pipe, `tee`, `printf`, command substitution.
- **Modul 2.3:** `set -euo pipefail`, `trap`, cleanup, logging, `set -x`, `PS4`, `shellcheck`.

**Hasil akhir:** Script yang bisa dijalankan (`chmod +x`), punya menu, punya log, bisa diuji, dan siap dijadikan portofolio.

---

## 2. Konsep & Filosofi

### 2.1 Modularitas
Setiap fitur adalah **fungsi terpisah**. Fungsi utama hanya mengatur alur; detail ada di fungsi masing-masing. Ini memudahkan debugging dan pengujian.

### 2.2 Fail Fast, Cleanup Always
Script keluar cepat saat ada error (`set -e`), tetapi **selalu** membersihkan file sementara (`trap EXIT`).

### 2.3 Observability
Semua aksi penting dicatat ke log dengan timestamp. Mode debug (`DEBUG=1`) menyalakan `set -x` dan `PS4` yang informatif.

### 2.4 Idempotent
Backup ke direktori yang sama tidak merusak backup lama; file arsip diberi timestamp unik.

### 2.5 Portabilitas Zsh
Kita pakai Zsh (sesuai kurikulum), tetapi banyak bagian kompatibel Bash.

---

## 3. Arsitektur & Struktur File

```
backuptool/
├── backuptool.zsh        # Script utama
├── lib/
│   └── (opsional)        # Fungsi tambahan (fase berikutnya)
├── backup/               # Output arsip backup
├── logs/
│   └── backuptool.log    # Log aktivitas
└── tmp/                  # File sementara (dibersihkan saat exit)
```

**Struktur script:**
```
[Header: shebang, deskripsi]
[Opsi shell: set -euo pipefail]
[Konstanta: VERSION, BASE_DIR, dll]
[Fungsi logging]
[Fungsi cleanup]
[Fungsi trap]
[Fungsi: backup, analyze_log, info_sistem]
[Fungsi: menu]
[Fungsi: main]
[Pemanggilan main "$@"]
```

---

## 4. Visualisasi

### 4.1 Alur Eksekusi
```bash
./backuptool.zsh [opsi]
        |
        v
[Parsing argumen]
        |
        v
[Setup: dir, trap, log]
        |
        v
[Menu loop]
        |
   +----+----+----+----+
   |    |    |    |    |
   v    v    v    v    v
Backup Log Info Debug Keluar
   |    |    |    |    |
   +----+----+----+----+
        |
        v
[Cleanup via trap EXIT]
        |
        v
[Exit code]
```

### 4.2 Struktur Stream
```
stdin  <-- keyboard / file
stdout --> terminal (menu, hasil)
stderr --> log file (>&2)
log    --> logs/backuptool.log (fd 3)
```

### 4.3 Trap & Cleanup
```
Script mulai
    |
trap cleanup EXIT
    |
... eksekusi ...
    |
Script selesai / error / Ctrl+C
    |
cleanup() jalan:
  - hapus tmp/
  - tutup fd 3
  - log "Selesai"
    |
Keluar
```

---

## 5. Tahap 1: Kerangka Dasar & Menu Interaktif

**Tujuan:** Membuat kerangka script, shebang, permission, menu `select`, dan loop utama.

```bash
#!/usr/bin/env zsh
# backuptool.zsh - CLI backup & log analyzer
# Versi: 1.0
# Deskripsi: Tool sederhana untuk backup dan analisis log.

set -euo pipefail

# Konstanta
readonly VERSION="1.0"
readonly BASE_DIR="${HOME}/backuptool"
readonly BACKUP_DIR="${BASE_DIR}/backup"
readonly LOG_DIR="${BASE_DIR}/logs"
readonly TMP_DIR="${BASE_DIR}/tmp"
readonly LOG_FILE="${LOG_DIR}/backuptool.log"

# Fungsi menu
menu() {
    echo "=============================="
    echo "  Backuptool v${VERSION}"
    echo "=============================="
    select pilihan in "Backup" "Analisis Log" "Info Sistem" "Keluar"; do
        case "$pilihan" in
            Backup)        echo "Menu Backup"; break ;;
            "Analisis Log") echo "Menu Analisis"; break ;;
            "Info Sistem") echo "Menu Info"; break ;;
            Keluar)        echo "Sampai jumpa"; exit 0 ;;
            *)             echo "Pilih 1-4" ;;
        esac
    done
}

menu
```

**Penjelasan kata demi kata:**
- `#!/usr/bin/env zsh` — shebang portabel.
- `set -euo pipefail` — fail fast.
- `readonly VERSION="1.0"` — konstanta, tidak bisa diubah.
- `${HOME}/backuptool` — `$HOME` environment variable.
- `select pilihan in ...` — menu interaktif Zsh.
- `case "$pilihan" in ... esac` — percabangan.
- `break` — keluar dari `select`.
- `exit 0` — keluar sukses.

**Cara uji:**
```bash
chmod +x backuptool.zsh
./backuptool.zsh
```

**Kesalahan umum:**
- Lupa `chmod +x` → `Permission denied`.
- Lupa `#!/usr/bin/env zsh` → `bad interpreter`.
- `select` tanpa `break` → loop tak berhenti.

---

## 6. Tahap 2: Fungsi Backup

**Tujuan:** Menambahkan fungsi `backup` yang menerima path, membuat arsip `.tar.gz`, dan menangani error.

```bash
backup() {
    local target="${1:-}"
    local timestamp arsip

    if [[ -z "$target" ]]; then
        echo "Error: target kosong" >&2
        return 1
    fi

    if [[ ! -e "$target" ]]; then
        echo "Error: '$target' tidak ditemukan" >&2
        return 1
    fi

    timestamp=$(date '+%Y%m%d_%H%M%S')
    arsip="${BACKUP_DIR}/backup_${timestamp}.tar.gz"

    if tar -czf "$arsip" "$target" 2>/dev/null; then
        echo "Backup sukses: $arsip"
        return 0
    else
        echo "Backup gagal" >&2
        return 1
    fi
}
```

**Penjelasan:**
- `local target="${1:-}"` — argumen pertama, default kosong (aman di bawah `set -u`).
- `[[ -z "$target" ]]` — cek kosong.
- `[[ ! -e "$target" ]]` — cek tidak ada.
- `date '+%Y%m%d_%H%M%S'` — timestamp unik.
- `tar -czf` — buat arsip gzip.
- `2>/dev/null` — buang stderr tar.
- `return 0/1` — exit code fungsi.

**Uji:**
```bash
backup /etc/hosts
```

---

## 7. Tahap 3: Fungsi Analisis Log

**Tujuan:** Menghitung error, warning, dan pola dari file log.

```bash
analyze_log() {
    local file="${1:-}"
    local total errors warnings

    if [[ ! -f "$file" ]]; then
        echo "Error: '$file' bukan file" >&2
        return 1
    fi

    total=$(wc -l < "$file")
    errors=$(grep -ci 'error' "$file" || true)
    warnings=$(grep -ci 'warning' "$file" || true)

    printf "File      : %s\n" "$file"
    printf "Total     : %d\n" "$total"
    printf "Error     : %d\n" "$errors"
    printf "Warning   : %d\n" "$warnings"
}
```

**Penjelasan:**
- `wc -l < "$file"` — hitung baris; `<` redirect input.
- `grep -ci` — case-insensitive count.
- `|| true` — jangan gagal jika grep tidak menemukan.
- `printf` — format output.

---

## 8. Tahap 4: Input/Output & Redirection

**Tujuan:** Menambahkan interaksi user dan output ke file.

```bash
prompt_path() {
    local path
    read "path?Masukkan path: "   # Zsh
    echo "$path"
}

backup_interaktif() {
    local target
    target=$(prompt_path)
    backup "$target" | tee -a "${LOG_FILE}"
}
```

**Penjelasan:**
- `read "path?prompt"` — sintaks Zsh untuk prompt.
- `$(prompt_path)` — command substitution.
- `| tee -a` — tampilkan ke layar dan append ke log.

**Uji:**
```bash
backup_interaktif
```

---

## 9. Tahap 5: Error Handling, Trap, dan Cleanup

**Tujuan:** Menambahkan trap untuk cleanup dan penanganan error.

```bash
cleanup() {
    local exit_code=$?
    echo "Membersihkan..." >&2
    rm -rf "${TMP_DIR:?}"/* 2>/dev/null || true
    echo "$(date '+%F %T') [INFO] Selesai (exit=$exit_code)" >> "${LOG_FILE}"
    exit "$exit_code"
}
trap cleanup EXIT

trap 'echo "Dibatalkan"; exit 130' INT
```

**Penjelasan:**
- `local exit_code=$?` — simpan exit code sebelum diubah.
- `${TMP_DIR:?}` — error jika `TMP_DIR` kosong (mencegah `rm -rf /`).
- `rm -rf ... || true` — jangan gagal cleanup.
- `trap cleanup EXIT` — jalankan saat keluar.
- `trap ... INT` — tangkap Ctrl+C.

**Setup awal:**
```bash
setup() {
    mkdir -p "$BACKUP_DIR" "$LOG_DIR" "$TMP_DIR"
    exec 3>> "$LOG_FILE"   # fd 3 untuk log
    echo "$(date '+%F %T') [INFO] Mulai v${VERSION}" >&3
}
```

---

## 10. Tahap 6: Logging Terstruktur & Debugging

**Tujuan:** Menambahkan logging berlevel dan mode debug.

```bash
log() {
    local level="$1"; shift
    printf '%s [%s] %s\n' "$(date '+%F %T')" "$level" "$*" >&3
}

debug_enabled() { [[ "${DEBUG:-0}" == "1" ]]; }

if debug_enabled; then
    PS4='+%N:%i:%_ '
    set -x
fi
```

**Penjelasan:**
- `local level="$1"; shift` — ambil level, sisanya pesan.
- `>&3` — tulis ke fd 3 (log file).
- `DEBUG=1` — environment variable untuk mode debug.
- `PS4='+%N:%i:%_ '` — prompt xtrace Zsh.
- `set -x` — nyalakan trace.

**Uji:**
```bash
DEBUG=1 ./backuptool.zsh
```

---

## 11. Kode Lengkap (`backuptool.zsh`)

```bash
#!/usr/bin/env zsh
# backuptool.zsh - CLI backup & log analyzer
# Versi: 1.0
# Penggunaan: ./backuptool.zsh [--help] [--version] [--debug]

set -euo pipefail

# ---------- Konstanta ----------
readonly VERSION="1.0"
readonly BASE_DIR="${HOME}/backuptool"
readonly BACKUP_DIR="${BASE_DIR}/backup"
readonly LOG_DIR="${BASE_DIR}/logs"
readonly TMP_DIR="${BASE_DIR}/tmp"
readonly LOG_FILE="${LOG_DIR}/backuptool.log"

# ---------- Logging ----------
log() {
    local level="$1"; shift
    printf '%s [%s] %s\n' "$(date '+%F %T')" "$level" "$*" >&3
}

# ---------- Cleanup ----------
cleanup() {
    local exit_code=$?
    echo "Membersihkan temporary files..." >&2
    rm -rf "${TMP_DIR:?}"/* 2>/dev/null || true
    log INFO "Selesai (exit=$exit_code)"
    exit "$exit_code"
}

# ---------- Setup ----------
setup() {
    mkdir -p "$BACKUP_DIR" "$LOG_DIR" "$TMP_DIR"
    exec 3>> "$LOG_FILE"
    trap cleanup EXIT
    trap 'echo "Dibatalkan"; exit 130' INT
    log INFO "Mulai backuptool v${VERSION}"
}

# ---------- Fungsi Fitur ----------
backup() {
    local target="${1:-}"
    local timestamp arsip
    if [[ -z "$target" ]]; then
        echo "Error: target kosong" >&2
        return 1
    fi
    if [[ ! -e "$target" ]]; then
        echo "Error: '$target' tidak ditemukan" >&2
        return 1
    fi
    timestamp=$(date '+%Y%m%d_%H%M%S')
    arsip="${BACKUP_DIR}/backup_${timestamp}.tar.gz"
    if tar -czf "$arsip" "$target" 2>/dev/null; then
        log INFO "Backup sukses: $arsip"
        echo "Backup sukses: $arsip"
        return 0
    else
        log ERROR "Backup gagal: $target"
        echo "Backup gagal" >&2
        return 1
    fi
}

analyze_log() {
    local file="${1:-}"
    local total errors warnings
    if [[ ! -f "$file" ]]; then
        echo "Error: '$file' bukan file" >&2
        return 1
    fi
    total=$(wc -l < "$file")
    errors=$(grep -ci 'error' "$file" || true)
    warnings=$(grep -ci 'warning' "$file" || true)
    printf "File      : %s\n" "$file"
    printf "Total     : %d\n" "$total"
    printf "Error     : %d\n" "$errors"
    printf "Warning   : %d\n" "$warnings"
    log INFO "Analisis $file: total=$total errors=$errors warnings=$warnings"
}

info_sistem() {
    echo "=== Info Sistem ==="
    echo "Hostname : $(hostname)"
    echo "Uptime   : $(uptime -p 2>/dev/null || uptime)"
    echo "Disk     : $(df -h / | awk 'NR==2 {print $4" tersisa"}')"
    echo "Memori   : $(free -h 2>/dev/null | awk 'NR==2 {print $3"/"$2}' || echo '-')"
    log INFO "Info sistem ditampilkan"
}

# ---------- Menu ----------
menu() {
    while true; do
        echo
        echo "=============================="
        echo "  Backuptool v${VERSION}"
        echo "=============================="
        select pilihan in "Backup" "Analisis Log" "Info Sistem" "Keluar"; do
            case "$pilihan" in
                Backup)
                    read "target?Path yang akan di-backup: "
                    backup "$target" || true
                    break
                    ;;
                "Analisis Log")
                    read "file?Path file log: "
                    analyze_log "$file" || true
                    break
                    ;;
                "Info Sistem")
                    info_sistem
                    break
                    ;;
                Keluar)
                    echo "Sampai jumpa!"
                    return 0
                    ;;
                *)
                    echo "Pilih 1-4"
                    ;;
            esac
        done
    done
}

# ---------- Main ----------
main() {
    case "${1:-}" in
        --help|-h)
            cat <<EOF
Penggunaan: $0 [opsi]
  --help, -h     Tampilkan bantuan
  --version, -v  Tampilkan versi
  --debug        Aktifkan mode debug
EOF
            exit 0
            ;;
        --version|-v)
            echo "backuptool v${VERSION}"
            exit 0
            ;;
        --debug)
            export DEBUG=1
            shift
            ;;
    esac

    if [[ "${DEBUG:-0}" == "1" ]]; then
        PS4='+%N:%i:%_ '
        set -x
    fi

    setup
    menu
}

main "$@"
```

---

## 12. Cara Menjalankan & Menguji

### 12.1 Persiapan
```bash
mkdir -p ~/backuptool
cp backuptool.zsh ~/backuptool/
chmod +x ~/backuptool/backuptool.zsh
cd ~/backuptool
```

### 12.2 Uji Sintaks
```bash
zsh -n backuptool.zsh
shellcheck backuptool.zsh   # opsional
```

### 12.3 Jalankan
```bash
./backuptool.zsh
```

### 12.4 Uji Debug
```bash
DEBUG=1 ./backuptool.zsh
```

### 12.5 Uji Backup
Pilih menu 1, masukkan `/etc/hosts`.

### 12.6 Uji Analisis Log
Pilih menu 2, masukkan `logs/backuptool.log`.

### 12.7 Uji Ctrl+C
Tekan `Ctrl+C` di tengah; pastikan cleanup jalan.

### 12.8 Cek Hasil
```bash
ls -lh backup/
cat logs/backuptool.log
```

---

## 13. Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| Shebang | Penunjuk interpreter | `#!/usr/bin/env zsh` |
| Fail Fast | Hentikan saat error | `set -e` |
| Trap | Tangkap sinyal/event | `trap cleanup EXIT` |
| Cleanup | Bersihkan resource | `rm -rf tmp/*` |
| Function | Blok kode bernama | `backup() { ... }` |
| Local | Variabel lokal fungsi | `local x=1` |
| Redirection | Ubah arah stream | `> file`, `2>&1` |
| Pipe | Sambung stdout→stdin | `cmd | tee log` |
| tee | Output ke file + layar | `| tee -a log` |
| Command Substitution | Output perintah → variabel | `$(date)` |
| Exit Code | Status numerik | `0`, `1`, `130` |
| Log Level | Tingkat log | INFO, ERROR |
| Xtrace | Mode debug | `set -x` |
| PS4 | Prompt xtrace | `PS4='+%N:%i '` |
| Idempotent | Aman diulang | `mkdir -p` |
| File Descriptor | Nomor stream | `3>> log` |
| SIGINT | Sinyal Ctrl+C | `trap ... INT` |
| Select | Menu interaktif | `select x in a b` |

---

## 14. Tips & Praktik Terbaik

1. Gunakan `#!/usr/bin/env zsh` untuk portabilitas.
2. Selalu `set -euo pipefail`, tetapi pahami pengecualiannya.
3. Pasang `trap cleanup EXIT` **sebelum** operasi yang bisa gagal.
4. Gunakan `${VAR:?}` untuk mencegah `rm -rf /`.
5. Log ke fd terpisah (`exec 3>> log`) agar tidak mengganggu stdout.
6. Gunakan `printf` untuk log dan output terstruktur.
7. Beri timestamp di semua log.
8. Uji dengan `zsh -n` sebelum menjalankan.
9. Gunakan `DEBUG=1` untuk mode debug, jangan hardcode `set -x`.
10. Hindari `((counter++))` di bawah `set -e`.
11. Gunakan `mktemp` untuk file sementara.
12. Dokumentasikan exit code di header script.
13. Tes trap dengan Ctrl+C dan `kill`.
14. Buat script idempotent (`mkdir -p`, `rm -f`).
15. Simpan konfigurasi di variabel `readonly` di atas.

---

## 15. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Permission denied | Belum `chmod +x` | `chmod +x backuptool.zsh` |
| `bad interpreter` | Shebang salah | `#!/usr/bin/env zsh` |
| Script keluar tak terduga | `set -e` + `((...))` | Gunakan `((++...))` atau `$((...))` |
| `unbound variable` | `set -u` + `$1` kosong | `${1:-}` |
| Trap tidak jalan | Trap dipasang setelah error | Pasang di awal `setup` |
| File temp tertinggal | Cleanup gagal | `rm -rf ... || true` |
| `rm -rf /` | `TMP_DIR` kosong | `${TMP_DIR:?}` |
| Log tidak muncul | Log ke stdout | `>&3` atau `>&2` |
| `read -p` tidak muncul | Zsh bukan Bash | `read "var?prompt"` |
| Menu tak berhenti | Lupa `break`/`return` | Tambahkan |
| Pipe gagal tapi exit 0 | Tanpa `pipefail` | `set -o pipefail` |
| `select` invalid | Input bukan angka | Default `*` |
| `tar` gagal | Path salah | Cek `[[ -e ]]` |
| Log file besar | Tidak rotasi | Rotasi manual (fase berikutnya) |
| Debug di produksi | Lupa matikan | Gunakan env `DEBUG` |

---

## 16. Hubungan dengan Modul & Fase Berikutnya

- **Modul 2.1** — shebang, permission, `if`, `case`, `select`, loop, argumen, exit code → dipakai di menu, fungsi, trap.
- **Modul 2.2** — fungsi, `local`, `read`, redirection, pipe, `tee`, `printf`, command substitution → dipakai di `backup`, `analyze_log`, `log`.
- **Modul 2.3** — `set -euo pipefail`, `trap`, cleanup, logging, `set -x`, `PS4` → dipakai di `setup`, `cleanup`, `log`, mode debug.
- **Fase 3 (jika ada)** — CLI lanjutan: `zparseopts`, `getopts`, subcommand, konfigurasi file, plugin, distribusi via `brew`/`apt`, unit test dengan `zunit`.

**Proyek ini adalah “jembatan”** dari belajar sintaks menjadi membangun alat nyata. Setelah ini, Anda siap masuk ke Fase 3 atau memperdalam Zsh tingkat lanjut.

---

## 17. Sumber Referensi

- **Zsh Manual — Functions:** https://zsh.sourceforge.io/Doc/Release/Functions.html
- **Zsh Manual — Options:** https://zsh.sourceforge.io/Doc/Release/Options.html
- **Zsh Manual — Signals:** https://zsh.sourceforge.io/Doc/Release/Signals.html
- **Zsh Manual — Redirection:** https://zsh.sourceforge.io/Doc/Release/Redirection.html
- **Google Shell Style Guide:** https://google.github.io/styleguide/shellguide.html
- **ShellCheck:** https://www.shellcheck.net/
- **BashFAQ — Error Handling:** https://mywiki.wooledge.org/BashFAQ/105
- **`tar` Manual:** https://www.gnu.org/software/tar/manual/
- **`mktemp` Manual:** https://www.gnu.org/software/coreutils/manual/html_node/mktemp-invocation.html
- **`tee` Manual:** https://www.gnu.org/software/coreutils/manual/html_node/tee-invocation.html
- **zshdb Debugger:** https://manpages.ubuntu.com/manpages/focal/man1/zshdb.1.html

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

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

