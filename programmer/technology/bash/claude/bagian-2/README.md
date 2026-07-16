<!-- <details> -->
<!--   <summary>📃 Daftar Isi</summary> -->
<!---->
<!-- </details> -->
<!---->
# Hari 2 — Variabel, Quoting, dan Ekspansi.

Ini bagian yang menentukan apakah skrip kamu nanti robust atau penuh bug aneh, karena Bash melakukan ekspansi teks *sebelum* eksekusi — kalau kamu tidak paham urutan ini, hasil skrip jadi tidak terduga.

## 1. Deklarasi Variabel: `nama=nilai`

```bash
nama="Jon"
```

Bedah kata per kata:
- `nama` — nama variabel. Aturan penamaan: harus diawali huruf atau underscore (`_`), tidak boleh diawali angka, isinya huruf/angka/underscore, dan **case-sensitive** (`nama` ≠ `Nama`).
- `=` — operator assignment. **Wajib tanpa spasi** di kiri maupun kanan tanda ini.
- `"Jon"` — nilai yang di-assign.

Kenapa spasi jadi masalah fatal? Coba bayangkan:

```bash
nama = "Jon"
```

Bash membaca ini bukan sebagai assignment, tapi sebagai: jalankan **program bernama `nama`**, dengan argumen `=` dan `Jon`. Hasilnya error `nama: command not found` — karena begitu ada spasi setelah `nama`, Bash langsung menganggap kata pertama adalah nama perintah, bukan bagian dari sintaks assignment.

Konvensi (bukan aturan wajib, tapi disiplin yang baik): variabel `UPPERCASE` biasanya dipakai untuk environment variable atau konstanta penting, `lowercase` untuk variabel lokal skrip.

## 2. Membaca Variabel: `$nama` vs `${nama}`

```bash
nama="Jon"
echo $nama
echo ${nama}
```

Keduanya sama-sama mencetak `Jon` di kasus ini. Tapi `${}` **wajib** dipakai saat variabel akan langsung disambung teks lain tanpa pemisah jelas:

```bash
nama="Jon"
echo "$nama_belajar"     # OUTPUT: kosong (baris baru)
echo "${nama}_belajar"   # OUTPUT: Jon_belajar
```

Kenapa baris pertama kosong? Karena Bash membaca `$nama_belajar` sebagai **satu nama variabel utuh**: `nama_belajar` — dan variabel itu tidak pernah didefinisikan, jadi nilainya string kosong. Kurung kurawal `{}` secara eksplisit menandai **di mana nama variabel berakhir**, sehingga `_belajar` di luar kurung dibaca sebagai teks literal yang disambung setelah nilai `nama`.

## 3. Quoting — Bagian Paling Krusial Hari Ini

Bash punya tiga cara menangani teks, dan masing-masing punya perilaku ekspansi berbeda:

```bash
pesan="Halo    dunia"

echo $pesan     # tanpa quote
echo "$pesan"   # double quote
echo '$pesan'   # single quote
```

Hasil dan penjelasannya:

- **`echo $pesan`** → output: `Halo dunia` (spasi berlebih **hilang**, jadi satu spasi saja). Ini terjadi karena tanpa quote, Bash melakukan **word splitting**: hasil ekspansi variabel dipecah lagi berdasarkan `$IFS` (Internal Field Separator, default-nya spasi/tab/newline), lalu disusun ulang. Ini juga rawan **globbing** tak disengaja — kalau isi variabel mengandung `*`, Bash akan mencoba mencocokkannya dengan nama file di direktori saat ini.
- **`echo "$pesan"`** → output: `Halo    dunia` (spasi asli **dipertahankan** persis). Di dalam double quote, ekspansi variabel tetap terjadi, tapi hasilnya diperlakukan sebagai **satu token utuh** — tidak dipecah lagi, tidak di-glob.
- **`echo '$pesan'`** → output: `$pesan` secara harfiah. Single quote mematikan **semua** jenis ekspansi — variabel, command substitution, semuanya dibaca apa adanya karakter per karakter.

**Aturan praktis yang wajib kamu pegang:** selalu bungkus variabel dengan double quote (`"$variabel"`) kecuali kamu **sengaja** butuh word splitting atau globbing. Ini bukan gaya penulisan — ini pencegahan bug nyata, terutama saat variabel berisi path dengan spasi.

## 4. Command Substitution: `$(perintah)` vs Backtick `` `perintah` ``

```bash
tanggal=$(date +%Y-%m-%d)
echo "Hari ini: $tanggal"
```

Bedah:
- `$( ... )` — jalankan perintah di dalamnya di **subshell**, tangkap **stdout**-nya, lalu substitusikan hasilnya menggantikan seluruh ekspresi `$(...)`.
- `date +%Y-%m-%d` — perintah `date` dengan opsi format kustom (`%Y` tahun 4 digit, `%m` bulan, `%d` tanggal).

Bentuk lama pakai backtick:

```bash
tanggal=`date +%Y-%m-%d`
```

Fungsinya identik, tapi `$()` lebih disarankan karena bisa **di-nesting** (disarangkan) dengan bersih:

```bash
echo $(echo $(date +%A))
```

Coba lakukan hal sama dengan backtick, kamu harus escape backtick bagian dalam — jadi berantakan dan gampang salah:

```bash
echo `echo \`date +%A\``
```

## 5. Arithmetic Expansion: `$(( ekspresi ))`

```bash
a=5
b=3
hasil=$((a + b))
echo "$hasil"   # OUTPUT: 8
```

Bedah:
- Di dalam `$(( ))`, kamu **tidak wajib** pakai `$` di depan nama variabel (`a + b`, bukan `$a + $b`) — Bash tahu konteks ini murni aritmetika, jadi otomatis membaca `a` dan `b` sebagai nilai variabel.
- Operator yang didukung: `+`, `-`, `*`, `/` (pembagian integer, bukan desimal), `%` (modulus/sisa bagi), `**` (pangkat).

Catatan penting untuk fondasi Hari 3 nanti: ada juga bentuk `(( ekspresi ))` **tanpa** `$` di depan — ini bukan untuk menghasilkan nilai, tapi dipakai sebagai **perintah** yang exit status-nya `0` (sukses/true) kalau hasil ekspresi bukan nol, dan `1` (gagal/false) kalau hasilnya nol. Ini jembatan penting antara aritmetika dan logika percabangan yang akan kita bahas besok.

## 6. Variabel Khusus (Special Parameters)

Buat skrip `cek_argumen.sh`:

```bash
#!/bin/bash
echo "Nama skrip: $0"
echo "Argumen pertama: $1"
echo "Argumen kedua: $2"
echo "Jumlah argumen: $#"
echo "Semua argumen (@): $@"
echo "Exit status perintah sebelumnya: $?"
echo "PID shell ini: $$"
```

Jalankan: `bash cek_argumen.sh satu dua tiga`

Bedah tiap variabel:
- `$0` — nama file skrip itu sendiri (bukan argumen).
- `$1`, `$2`, ... `$9` — argumen posisional sesuai urutan saat skrip dipanggil.
- `$#` — jumlah total argumen yang diberikan (di contoh ini akan bernilai `3`).
- `$@` — seluruh argumen, masing-masing sebagai **elemen terpisah** (pentingnya beda dengan `$*` akan sangat terasa saat bahas array/loop di Hari 4–5; singkatnya `"$@"` menjaga tiap argumen tetap terpisah meski mengandung spasi, sedangkan `"$*"` menggabungkan semuanya jadi satu string).
- `$?` — exit status dari perintah **terakhir** yang dijalankan (0 = sukses). Ini fondasi utama percabangan `if` besok.
- `$$` — Process ID (PID) dari shell/skrip yang sedang berjalan, berguna misalnya untuk membuat nama file temporary yang unik.
- `$!` — (tidak ada di contoh di atas, tapi penting dicatat) PID dari proses **background** terakhir yang dijalankan dengan `&`.

## 7. `export` — Mewariskan Variabel ke Proses Anak

```bash
VAR="rahasia"
bash -c 'echo "Dari child process: $VAR"'
```

Output: **kosong**. Kenapa? Karena `bash -c '...'` membuka **subshell/proses baru**, dan variabel biasa **tidak otomatis diwariskan** ke proses anak — ia hanya hidup di shell tempat ia didefinisikan.

Sekarang bandingkan:

```bash
VAR="rahasia"
export VAR
bash -c 'echo "Dari child process: $VAR"'
```

Output: `Dari child process: rahasia`. `export` menandai variabel itu sebagai bagian dari **environment**, yang secara otomatis disalin ke setiap proses anak yang dibuat sesudahnya (ingat konsep subshell dari Hari 1 — ini penerapan langsungnya).

---

**Referensi bagian ini:** Bab 3.4 (Shell Parameters) dan 3.5 (Shell Expansions) — https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters

**Latihan wajib Hari 2:**

1. Buat skrip `latihan_hari2.sh` yang menerima 2 argumen, lalu cetak: nama skrip, kedua argumen, jumlah argumen, dan hasil penjumlahan keduanya (anggap keduanya angka) memakai arithmetic expansion.
2. Di dalam skrip yang sama, buat satu variabel berisi spasi ganda, lalu `echo` dengan tiga cara (tanpa quote, double quote, single quote) — cocokkan hasilnya dengan penjelasan section 3 di atas.
<!-- 3. Jelaskan ke saya: kenapa `"$@"` disebut lebih aman dipakai di loop dibanding `$*`? (petunjuk: pikirkan kembali konsep word splitting dari section 3 — jawabannya akan langsung menyambung ke materi Hari 4). -->


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!-- Kerjakan dulu, lalu ceritakan hasil dan jawabanmu — terutama poin 3, karena itu jembatan logika langsung menuju perulangan besok. -->
<!---

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
---->


