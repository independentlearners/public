# Hari 5 — Fungsi, Array, dan String Manipulation.

Jembatan dulu: sejauh ini kamu sudah punya tiga alat besar — variabel/ekspansi (Hari 2), keputusan (Hari 3), dan pengulangan (Hari 4). Fungsi **bukan** mekanisme eksekusi baru. Fungsi hanyalah cara **menamai** sekumpulan perintah (termasuk `if`, `loop`, apa pun yang sudah kamu kuasai) supaya bisa dipanggil ulang tanpa menulis ulang isinya — plus satu lapisan baru: parameter dan scope miliknya sendiri. Array pun bukan struktur kontrol baru; ia murni variabel yang menyimpan banyak nilai sekaligus, dan nanti diakses lewat mekanisme ekspansi yang sudah kamu kenal.

## 1. Deklarasi Fungsi

```bash
sapa() {
    echo "Halo, $1!"
}

function sapa2 {
    echo "Halo juga, $1!"
}

sapa "Jon"
sapa2 "Jon"
```

Bedah:
- `sapa()` — nama fungsi diikuti kurung kosong `()`. Kurung ini **wajib ada** meski tak pernah diisi apa pun — bukan tempat mendeklarasikan parameter (beda total dari bahasa lain), sekadar penanda sintaks "ini definisi fungsi".
- `{ ... }` — badan fungsi. Spasi wajib setelah `{` dan sebelum `}`, alasannya sama persis dengan spasi wajib di `[ ]` Hari 3: keduanya token/reserved word tersendiri, bukan karakter yang menempel ke isi.
- `function sapa2 { ... }` — sintaks alternatif, kurung `()` boleh dihilangkan. Ini ekstensi **khusus Bash**, tidak portable ke `sh` POSIX murni — catatan yang sama seperti `[[ ]]` di Hari 3. Karena Arch Linux dan Termux dua-duanya menjalankan Bash asli, kedua bentuk sah dipakai; konvensi paling umum tetap bentuk pertama.
- Fungsi **harus didefinisikan sebelum dipanggil** — Bash membaca skrip sekuensial dari atas ke bawah, jadi baris pemanggilan di akhir hanya berhasil karena definisinya sudah "dilihat" lebih dulu.

## 2. Parameter Fungsi

```bash
info_pengguna() {
    echo "Nama skrip tetap: $0"
    echo "Argumen pertama fungsi: $1"
    echo "Jumlah argumen fungsi: $#"
}

info_pengguna "Jon" "Termux"
```

`$0`, `$1`, `$#` di sini adalah variabel yang sama persis dari Hari 2 — tidak ada yang perlu dijelaskan ulang soal artinya. Satu hal baru yang wajib digarisbawahi: begitu eksekusi masuk badan fungsi, `$1`, `$2`, `$#` **dibind ulang** ke argumen yang diberikan **saat memanggil fungsi**, bukan lagi argumen skrip. Kalau skrip dipanggil `bash script.sh A B C`, lalu di dalamnya ada baris `info_pengguna "Jon" "Termux"`, maka di dalam `info_pengguna`, `$1` adalah `"Jon"` — bukan `A`. Pengecualiannya satu: `$0` **tidak ikut** dibind ulang, ia tetap merujuk ke nama skrip asli di fungsi mana pun.

## 3. `local` — Scope Variabel di Dalam Fungsi

```bash
angka=10

ubah_angka() {
    local angka=99
    echo "Di dalam fungsi: $angka"
}

ubah_angka
echo "Di luar fungsi: $angka"
```

Output: `Di dalam fungsi: 99`, lalu `Di luar fungsi: 10`.

Ini titik yang wajib dibedakan tegas dari subshell Hari 1, karena sekilas terlihat mirip tapi mekanismenya beda level. Subshell adalah **proses terpisah** — memori benar-benar terpisah, perubahan tidak pernah balik ke induk sama sekali. Fungsi **tanpa** `local` berjalan di **proses yang sama** dengan pemanggilnya, jadi kalau baris `local` di atas dihapus, `angka=99` di dalam fungsi **menimpa permanen** `angka=10` di luar, karena keduanya sama-sama variabel global pada shell yang sama. `local` adalah isolasi variabel **di dalam satu proses**; subshell adalah isolasi **antar-proses**. Dua mekanisme berbeda, jangan disamakan.

Praktik wajib: setiap variabel yang dibuat di dalam fungsi dan tidak sengaja dipakai di luar, deklarasikan `local`. Ini mencegah polusi namespace global di skrip panjang berisi banyak fungsi.

## 4. `return` vs `echo` — Cara Fungsi "Mengembalikan Nilai"

Bash **tidak punya** mekanisme return value bebas seperti bahasa lain. `return` hanya bisa mengembalikan **exit status** — integer 0–255, persis mekanisme `$?` sejak Hari 3.

```bash
cek_genap() {
    if (( $1 % 2 == 0 )); then
        return 0
    else
        return 1
    fi
}

if cek_genap 4; then
    echo "Genap"
fi
```

`return 0` di sini bukan "mengembalikan angka 0 sebagai data" — ia mengatur exit status fungsi itu sendiri, yang langsung bisa dicek `if cek_genap 4; then` persis seperti mengecek exit status perintah biasa. Pola ini natural untuk fungsi bersifat ya/tidak (**predicate function**).

Untuk fungsi yang perlu mengembalikan **data** (string, hasil kalkulasi — bukan sekadar sukses/gagal), polanya adalah `echo` dikombinasikan `$( )`:

```bash
tambah() {
    local hasil=$(( $1 + $2 ))
    echo "$hasil"
}

jumlah=$(tambah 5 3)
echo "Hasil: $jumlah"
```

Fungsi mencetak hasil ke stdout, pemanggil menangkapnya lewat command substitution — mekanisme identik dengan `tanggal=$(date +%Y-%m-%d)` Hari 2, hanya sekarang program yang dipanggil adalah fungsi buatanmu sendiri. Konsekuensi: kalau fungsi ini juga memakai `echo` untuk debug di tengah jalan **dan** dipanggil lewat `$(...)`, semua `echo` itu ikut tertangkap jadi bagian "return value" — sumber bug klasik. Solusinya nanti dibahas tuntas di Hari 6 lewat file descriptor, cukup catat pola: arahkan log ke stderr (`>&2`), bukan stdout.

**Predicate function dengan regex matching** — perluasan langsung dari `cek_genap` di atas, sekarang untuk validasi format string:

```bash
is_number() {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

if is_number "12345"; then
    echo "Angka valid"
else
    echo "Bukan angka"
fi
```

Bedah simbol regex — ini elemen baru yang belum pernah disentuh:
- `=~` — operator pencocokan regex, **hanya tersedia di dalam `[[ ]]`**, tidak ada di `[ ]` POSIX. Sisi kiri (`$1`) dicocokkan terhadap pola di sisi kanan.
- `^` — penanda **awal string**.
- `[0-9]` — character class, cocok **satu** karakter apa pun dalam rentang `0`–`9`.
- `+` — kuantifier "satu atau lebih" dari elemen sebelumnya, jadi `[0-9]+` cocok satu digit atau lebih digit berurutan.
- `$` — penanda **akhir string** (perhatikan: ini `$` dalam konteks regex, beda makna total dari `$` ekspansi variabel Hari 2 — di sini murni simbol pola).
- Kombinasi `^...$` memaksa **seluruh** string cocok pola, bukan sebagian. Tanpa `$` di akhir, input `"123abc"` tetap dianggap cocok karena awalannya memenuhi `^[0-9]+`.

## 5. Array Indexed

```bash
buah=("apel" "jeruk" "mangga")

echo "${buah[0]}"
echo "${buah[@]}"
echo "${#buah[@]}"

for item in "${buah[@]}"; do
    echo "- $item"
done

buah+=("nanas")
```

Bedah:
- `buah=("apel" "jeruk" "mangga")` — elemen dipisah spasi di dalam kurung, index mulai dari `0`.
- `${buah[0]}` — akses satu elemen. Kurung kurawal `{}` di sini **wajib**, bukan opsional seperti `${nama}` biasa — tanpa `{}`, `$buah[0]` dibaca Bash sebagai `$buah` (elemen pertama secara default) diikuti teks literal `[0]`.
- `${buah[@]}` — seluruh elemen, tiap elemen tetap terpisah. Ini **parallel persis** dengan `$@` Hari 2 — logika yang sama, sekarang diterapkan ke elemen array. Ada juga `${buah[*]}`, parallel dengan `$*`: menggabungkan semua jadi satu string. Kalau kamu sudah paham beda `$@` vs `$*`, beda `${buah[@]}` vs `${buah[*]}` otomatis sudah kamu pahami juga.
- `${#buah[@]}` — jumlah elemen (di sini `3`). Prefix `#` sebagai "operator hitung" ini sama dengan `$#` Hari 2, dan akan muncul lagi sebentar di string manipulation.
- Loop `for item in "${buah[@]}"` — nol mekanisme baru; ini `for...in...do...done` Hari 4 apa adanya, hanya daftarnya sekarang hasil ekspansi array, bukan ditulis literal.
- `buah+=("nanas")` — `+=` menambah elemen ke akhir array **tanpa** menimpa isi sebelumnya (beda dari `buah=("nanas")` yang mengganti total seluruh isi).

## 6. Array Asosiatif

```bash
declare -A harga

harga["apel"]="15000"
harga["jeruk"]="12000"

for kunci in "${!harga[@]}"; do
    echo "$kunci -> ${harga[$kunci]}"
done
```

- `declare -A harga` — **wajib** dideklarasikan eksplisit sebelum dipakai (beda dari array indexed yang bisa langsung `buah=(...)` tanpa `declare`). `-A` = **A**ssociative, index-nya string/key bebas, bukan angka berurutan.
- `harga["apel"]="15000"` — assignment per key.
- `${!harga[@]}` — tanda `!` di sini **bukan** negasi logika seperti `!` Hari 3. Dalam konteks `${! ... }`, `!` berarti "ambil daftar **key**", bukan value. `${!harga[@]}` menghasilkan `apel jeruk`; `${harga[@]}` tanpa `!` menghasilkan `15000 12000` — daftar value saja.
- `${harga[$kunci]}` — akses pakai **variabel** sebagai key (bukan string literal), variasi kecil dari `${harga[apel]}`.

## 7. String Manipulation

```bash
kalimat="Belajar Bash Scripting"

echo "${#kalimat}"
echo "${kalimat:8:4}"
echo "${kalimat/Bash/Shell}"
echo "${kalimat//a/A}"

kosong=""
echo "${kosong:-default}"
echo "${kosong:=default}"
echo "$kosong"
```

- `${#kalimat}` — prefix `#` yang sama persis dari `${#buah[@]}` barusan, sekarang pada string biasa: hasilnya **jumlah karakter** (`23`), bukan jumlah elemen, karena string bukan array.
- `${kalimat:8:4}` — substring, format `${var:offset:length}`. `offset=8` posisi awal (dihitung dari `0`), `length=4` jumlah karakter diambil → hasil `Bash`.
- `${kalimat/Bash/Shell}` — replace **kemunculan pertama** saja, format `${var/pola/pengganti}` → `Belajar Shell Scripting`.
- `${kalimat//a/A}` — tanda `/` **dobel** = replace **semua** kemunculan, bukan cuma pertama → semua huruf `a` kecil jadi `A`.
- `${kosong:-default}` — kalau `$kosong` kosong/belum diset, **tampilkan** `"default"` sebagai pengganti untuk kebutuhan saat ini saja — `$kosong` sendiri **tidak berubah** (`echo "$kosong"` terakhir tetap mencetak kosong).
- `${kosong:=default}` — mirip di atas, tapi `=` benar-benar **meng-assign** `"default"` ke `$kosong` secara permanen. Setelah baris ini, `$kosong` sungguhan berisi `default`.
- Perbedaan `:-` vs `:=` penting untuk validasi argumen: `:-` untuk default sekali pakai, `:=` kalau variabel itu memang harus "terisi" untuk sisa eksekusi skrip.

---

**Referensi bagian ini:** Bab 3.3 (Shell Functions), Bab 3.5.3 (Shell Parameter Expansion), Bab 6.7 (Arrays) — https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions

**Latihan wajib Hari 5:**

1. Buat fungsi `hitung_rata_rata()` yang menerima sejumlah angka lewat `"$@"`, memakai loop (Hari 4) untuk menjumlahkan, lalu **return** hasilnya lewat pola `echo` + `$( )` seperti `tambah()` di atas — bukan lewat `return`, karena hasilnya bisa lebih dari 255.
2. Perluas contoh array asosiatif `harga` jadi minimal 5 item. Sebelum tiap `harga["item"]=nilai` dieksekusi, panggil `is_number` untuk memvalidasi nilainya — kalau bukan angka, tolak dan cetak pesan error.
3. Jelaskan dengan kalimatmu sendiri: kenapa menghapus `local` di `ubah_angka()` menyebabkan kebocoran variabel ke luar fungsi, sementara subshell Hari 1 **tidak pernah** bocor sama sekali walau pakai `export`? Jangan jelaskan ulang apa itu subshell atau apa itu `local` — cukup tunjukkan **letak perbedaan level isolasinya**.

Kerjakan ketiganya — terutama poin 3, karena itu akan mengunci pemahaman bahwa Bash punya **dua lapis isolasi berbeda** (proses vs fungsi), bukan satu. Hari 6 (I/O, pipe, redirection) akan langsung memakai pola `echo ... >&2` yang baru disinggung sekilas di section 4 — jadi pastikan pola itu sudah masuk akal dulu sebelum lanjut.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ./../../../../../README.md
[kurikulum]: ./../../../README.md
[sebelumnya]: ./bagian-4/README.md
[selanjutnya]: ./bagian-6/README.md

<!----------------------------------------------------->

[0]: ../README.md
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
