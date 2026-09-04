# Hari 3 — Percabangan Logika (Conditional Logic).

Ini jantung pemrograman sesungguhnya: mesin mengambil keputusan. Dan seperti yang sudah disinggung kemarin, semuanya bertumpu pada satu konsep: **exit status**.

## 1. Exit Status — Fondasi Segalanya

Di Bash, **tidak ada** konsep "true/false" seperti bahasa pemrograman lain. Yang ada hanyalah **exit status** — angka yang dikembalikan tiap perintah setelah selesai berjalan.

```bash
ls /home
echo $?
```

Bedah:
- Setelah `ls /home` sukses, `$?` bernilai `0`.
- **0 = sukses**. **Selain 0 (1–255) = gagal**, dengan makna spesifik tergantung program (misal `1` = error umum, `2` = misuse of command, dst — tiap program bebas menentukan sendiri).

Coba bandingkan:

```bash
ls /folder/tidak/ada
echo $?
```

Karena direktori tidak ada, `ls` gagal, dan `$?` akan bernilai bukan-nol (biasanya `2`).

Ini kebalikan dari intuisi kebanyakan bahasa pemrograman lain (di mana `0` sering berarti "false"). Di Bash: **0 = berhasil = dianggap "true" oleh sistem percabangan**. Pahami ini luar kepala, karena seluruh `if` di Bash sebenarnya adalah **mengecek exit status suatu perintah**, bukan mengecek "nilai boolean".

## 2. Struktur `if` / `elif` / `else` / `fi`

```bash
if [ "$1" = "ya" ]; then
    echo "Kamu menjawab ya"
elif [ "$1" = "tidak" ]; then
    echo "Kamu menjawab tidak"
else
    echo "Jawaban tidak dikenali"
fi
```

Bedah kata per kata:
- `if` — mulai blok kondisional. Setelah `if`, Bash mengeksekusi **perintah** yang mengikuti (dalam contoh ini, perintah `[ ... ]`) dan mengecek **exit status**-nya.
- `[ "$1" = "ya" ]` — ini adalah **perintah `test`**, bukan sintaks spesial (dibahas detail di poin 3).
- `; then` — titik koma memisahkan dua perintah di baris yang sama (setara dengan baris baru). `then` menandai: "kalau exit status perintah tadi adalah 0, jalankan blok ini."
- `elif` — singkatan dari "else if". Dicek **hanya jika** kondisi `if` di atasnya gagal (exit status ≠ 0).
- `else` — blok fallback, dijalankan kalau semua kondisi di atasnya gagal.
- `fi` — penutup blok `if`, yaitu **"if" dieja terbalik**. Ini konvensi khas Bash (kamu akan lihat pola sama di `case...esac` dan `do...done`) — memberi penanda eksplisit di mana blok berakhir, karena Bash tidak pakai indentasi/kurung kurawal seperti bahasa lain untuk menentukan scope blok.

## 3. `[ ]` vs `[[ ]]` — Perbedaan yang Sering Disalahpahami

Ini poin paling penting hari ini secara teknis.

**`[ ]` — perintah `test` yang menyamar jadi tanda kurung**

```bash
[ "$1" = "ya" ]
```

Fakta yang jarang disadari pemula: `[` **bukan sintaks khusus** — itu adalah **nama program/builtin** yang sesungguhnya, setara dengan perintah `test`. Buktikan sendiri:

```bash
type '['
```

Kamu akan lihat `[` terdaftar sebagai shell builtin (atau bahkan ada binary terpisah di `/usr/bin/[`). Karena `[` diperlakukan sebagai **nama perintah**, konsekuensinya:
- **Wajib ada spasi** setelah `[` dan sebelum `]` — karena `]` sebenarnya adalah **argumen terakhir** yang diharapkan perintah `[`, bukan simbol penutup sintaks. Tulis `[$1=ya]` tanpa spasi, dan Bash akan mencoba mencari program bernama `[$1=ya]` yang jelas tidak ada.
- Butuh **quoting ketat** — `"$1"` wajib diberi quote, karena kalau `$1` kosong atau mengandung spasi, `[` bisa menerima jumlah argumen yang salah dan error `unary operator expected`.

**`[[ ]]` — reserved word Bash (bukan program eksternal)**

```bash
[[ $1 = "ya" ]]
```

`[[` adalah **kata kunci (keyword)** yang di-parsing langsung oleh Bash sendiri, bukan dijalankan sebagai program terpisah. Konsekuensinya:
- Tidak rawan word splitting — `$1` di dalam `[[ ]]` **aman meski tanpa quote** (walau tetap disarankan quote untuk kebiasaan konsisten).
- Mendukung `&&`, `||`, `<`, `>` langsung di dalamnya tanpa perlu escape.
- Mendukung pattern matching dan regex lewat `=~`.
- **Hanya tersedia di Bash** (dan beberapa shell modern lain) — tidak portable ke `sh` POSIX murni. Kalau skrip kamu butuh portable ke shell lain, harus pakai `[ ]`.

**Kesimpulan praktis:** karena target kamu Bash (bukan POSIX `sh`), gunakan `[[ ]]` sebagai default kecuali ada alasan spesifik butuh portabilitas POSIX.

## 4. Operator Perbandingan

**String** (dipakai di dalam `[ ]` atau `[[ ]]`):

| Operator | Arti |
|---|---|
| `=` (atau `==` khusus di `[[ ]]`) | sama dengan |
| `!=` | tidak sama dengan |
| `-z` | *zero length* — string kosong |
| `-n` | *non-zero length* — string tidak kosong |

**Numerik:**

| Operator | Arti |
|---|---|
| `-eq` | *equal*, sama dengan |
| `-ne` | *not equal*, tidak sama dengan |
| `-gt` | *greater than*, lebih besar |
| `-lt` | *less than*, lebih kecil |
| `-ge` | *greater or equal*, lebih besar sama dengan |
| `-le` | *less or equal*, lebih kecil sama dengan |

Kenapa string pakai `=` tapi angka pakai `-eq`, bukan cuma `==`? Ini warisan desain perintah `test` POSIX asli: `test` didesain generik untuk banyak tipe perbandingan sekaligus (string, angka, file), jadi operator kata (`-eq`, `-gt`, dst) dipakai untuk numerik supaya tidak ambigu dengan `=` yang dipakai string. Ini murni historis, tapi wajib dihafal karena tertukar keduanya adalah sumber bug klasik:

```bash
[ "10" = "9" ]    # dibandingkan sebagai STRING → "10" tidak sama "9" → false (benar kebetulan)
[ "10" -eq "9" ]  # dibandingkan sebagai ANGKA → 10 ≠ 9 → false
[ "10" = "10.0" ] # STRING → beda karakter → false, padahal secara numerik sama!
```

**File test operators:**

| Operator | Arti |
|---|---|
| `-e` | file **e**xists (ada, apapun jenisnya) |
| `-f` | **f**ile biasa (regular file, bukan direktori/symlink) |
| `-d` | **d**irectory |
| `-x` | executable (punya izin `+x`) |
| `-r` | readable |
| `-w` | writable |

Contoh gabungan (ingat latihan Hari 1 soal `hello.sh`):

```bash
if [[ -f "hello.sh" && -x "hello.sh" ]]; then
    echo "File ada, jenisnya file biasa, dan bisa dieksekusi"
fi
```

## 5. Operator Logika: `&&`, `||`, `!`

Di dalam `[[ ]]`, bisa langsung digabung:

```bash
if [[ -f "$1" && -r "$1" ]]; then
```

- `&&` — **AND**: kedua sisi harus sukses (exit status 0) agar keseluruhan dianggap sukses.
- `||` — **OR**: cukup salah satu sisi sukses.
- `!` — negasi, membalik hasil. `[[ ! -f "$1" ]]` berarti "jika `$1` **BUKAN** file biasa".

Di luar `[ ]`/`[[ ]]`, `&&` dan `||` juga bisa langsung merangkai **perintah biasa** (bukan cuma di dalam test), karena keduanya bekerja berdasarkan exit status perintah di kirinya:

```bash
mkdir folder_baru && cd folder_baru
```

Bedah: `cd folder_baru` **hanya** dijalankan **jika** `mkdir folder_baru` sukses (exit status 0). Kalau `mkdir` gagal (misal folder sudah ada dan tanpa izin), `cd` tidak akan pernah dieksekusi.

## 6. Short-Circuit Evaluation — Cara Bash "Malas" Mengevaluasi

```bash
perintah1 && perintah2 || perintah3
```

Logika evaluasinya, **berurutan dari kiri**:
1. Jalankan `perintah1`.
2. Kalau sukses (exit 0) → jalankan `perintah2`. Kalau `perintah2` juga sukses, `perintah3` **dilewati** (karena sudah ada satu blok `&&...||` yang sukses secara keseluruhan lewat jalur kiri).
3. Kalau `perintah1` **gagal** → langsung lompat ke `perintah3` (sisi kanan `||`), `perintah2` **dilewati sepenuhnya**.

**Perangkap klasik** yang wajib kamu waspadai: pola ini **bukan** pengganti sempurna untuk `if/else` kalau `perintah2` sendiri **bisa gagal**:

```bash
[ -f "$1" ] && echo "ada" || echo "tidak ada"
```

Kalau file **ada** tapi entah kenapa `echo "ada"` itu sendiri gagal (jarang terjadi untuk `echo`, tapi bisa terjadi untuk perintah lain yang lebih kompleks), maka Bash akan **tetap** menjalankan `echo "tidak ada"` juga — karena dari sudut pandang `||`, yang dicek adalah exit status `perintah2`, bukan `perintah1`. Untuk logika kritis, `if/else` eksplisit selalu lebih aman dan lebih jelas dibaca.

## 7. `case` — Pattern Matching yang Lebih Bersih dari `if/elif` Bertumpuk

```bash
case "$1" in
    ya|iya|y)
        echo "Kamu setuju"
        ;;
    tidak|t)
        echo "Kamu menolak"
        ;;
    *)
        echo "Jawaban tidak dikenali"
        ;;
esac
```

Bedah kata per kata:
- `case "$1" in` — mulai evaluasi nilai `$1`, dicocokkan terhadap pola-pola berikutnya.
- `ya|iya|y)` — pola pertama. Tanda `|` di sini berarti **OR** (cocokkan salah satu). Tanda `)` menutup daftar pola, menandai mulai blok perintah untuk pola ini.
- `;;` — **titik koma ganda**, menandai akhir satu blok kasus (setara `break` di bahasa lain — mencegah Bash "jatuh" ke pola berikutnya).
- `*)` — pola wildcard, cocok dengan **apa saja** yang tidak cocok pola-pola sebelumnya. Konvensinya selalu diletakkan **paling akhir** sebagai fallback/default.
- `esac` — penutup blok `case`, sekali lagi **"case" dieja terbalik**, pola yang sama seperti `if...fi`.

Kapan pakai `case` dibanding `if/elif` bertumpuk? Ketika kamu mengecek **satu variabel** terhadap **banyak kemungkinan nilai diskrit** — jauh lebih ringkas dan mudah dibaca dibanding menulis `elif [[ "$1" = "..." ]]` berulang-ulang.

---

**Referensi bagian ini:** Bab 3.2.4 (Conditional Constructs) dan Bab 6.4 (Bash Conditional Expressions) — https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions

**Latihan wajib Hari 3:**

1. Buat skrip `cek_file.sh` yang menerima 1 argumen (path file), lalu pakai `if/elif/else` untuk mengecek dan mencetak status berbeda untuk: file tidak ada sama sekali, ada tapi bukan file biasa (misal direktori), ada dan file biasa tapi tidak bisa dibaca, ada dan bisa dibaca. Gunakan `[[ ]]` dan operator file dari section 4.
2. Ubah skrip yang sama supaya bagian pengecekan nilai argumen tunggal seperti "backup", "restore", "hapus" ditulis pakai `case` alih-alih `if/elif` — bandingkan sendiri mana yang lebih mudah dibaca.
3. Jelaskan ke saya dengan kata-katamu sendiri: kenapa `[ "10" -eq "10.0" ]` akan **error** (bukan sekadar false)? (petunjuk: pikirkan bahwa `-eq` memaksa Bash melakukan interpretasi **integer**, dan `10.0` bukan representasi integer yang valid — coba jalankan sendiri dan baca pesan errornya kata per kata).

Kerjakan dulu ketiganya, terutama poin 3 — itu akan membongkar batas antara "integer arithmetic" Bash dan bagaimana ia berbeda total dari bahasa yang punya tipe data float bawaan. Setelah ini paham, Hari 4 (loop) akan terasa jauh lebih natural karena kondisi `while` juga memakai mekanisme exit status yang sama persis.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
