# Hari 6 — I/O, Pipe, Redirection, dan Text Processing.

Jembatan dulu, sekaligus menutup dua utang penjelasan dari hari-hari sebelumnya: di Hari 4, baris `done < file.txt` sengaja belum dibedah tuntas ("redirection detail Hari 6"). Di Hari 5, `echo ... >&2` juga baru disinggung sekilas. Hari ini kita selesaikan keduanya sekaligus, karena akar keduanya sama persis: **file descriptor**.

## 1. File Descriptor — Kenapa Ini Harus Dipahami Dulu

Setiap proses yang berjalan (ingat konsep proses dari Hari 1 — subshell, child process) otomatis mendapat tiga **saluran komunikasi** bernomor saat pertama kali dijalankan:

| Nomor | Nama | Default arah |
|---|---|---|
| `0` | stdin (standard input) | dari keyboard |
| `1` | stdout (standard output) | ke layar |
| `2` | stderr (standard error) | ke layar |

Poin krusial yang mudah terlewat: stdout dan stderr **sama-sama tampil di layar secara default**, jadi secara visual terlihat identik — tapi keduanya adalah **dua saluran terpisah**. Inilah yang memungkinkan kamu memisahkan output normal dari pesan error tanpa mengubah kode program sama sekali, murni lewat redirection. Pola `echo "log" >&2` di Hari 5 kemarin adalah: paksa `echo` menulis ke saluran `2` (stderr) alih-alih default-nya `1` (stdout).

## 2. Operator Redirection

```bash
perintah > file.txt      # stdout → file.txt (timpa/truncate)
perintah >> file.txt     # stdout → file.txt (tambahkan di akhir)
perintah < file.txt      # file.txt → stdin
perintah 2> error.log    # stderr → error.log
perintah 2>&1            # stderr diarahkan ke tujuan yang SAMA dengan stdout saat ini
perintah &> semua.log    # stdout DAN stderr → semua.log (ekstensi Bash)
```

Bedah satu per satu:
- `>` — redirect stdout, **menimpa** isi file kalau sudah ada (tanpa peringatan apa pun).
- `>>` — sama, tapi **menambahkan** di akhir file, isi lama tidak hilang.
- `<` — inilah yang menyelesaikan utang Hari 4: `done < file.txt` berarti **isi file.txt menggantikan stdin default** (yang biasanya keyboard) untuk seluruh blok `while...done`. `read` di dalam loop lalu membaca dari saluran `0` seperti biasa — hanya saja saluran itu sekarang bersumber dari file, bukan dari kamu mengetik manual.
- `2>` — redirect **khusus** saluran `2`, stdout tetap tampil normal di layar.
- `2>&1` — ini paling sering disalahpahami. `&1` di sini **bukan** berarti "file bernama 1" — tanda `&` memberi tahu Bash: "ini merujuk ke **tujuan saat ini** dari file descriptor 1, bukan nama file literal." Urutan penulisan **menentukan hasil**:

```bash
perintah > output.log 2>&1   # BENAR: stdout ke output.log dulu, baru stderr ikut ke tujuan stdout (output.log)
perintah 2>&1 > output.log   # SALAH (kemungkinan besar bukan maksudmu): stderr disalin ke tujuan stdout SAAT ITU (masih layar), BARU SETELAHNYA stdout dialihkan ke output.log — akibatnya stderr tetap tampil di layar, tidak ikut masuk file
```

Bash membaca redirection **dari kiri ke kanan, satu per satu, dieksekusi saat itu juga** — bukan dievaluasi sebagai satu paket. Ini kenapa urutan `> file 2>&1` adalah idiom baku yang wajib dihafal persis seperti itu.

- `&>` — jalan pintas Bash (bukan POSIX, sama seperti `[[ ]]` di Hari 3) untuk menggabungkan stdout dan stderr ke tujuan yang sama sekaligus, setara `> file 2>&1` tapi lebih ringkas.

## 3. Pipe `|`

```bash
ls -la | grep ".sh"
```

Pipe menyambungkan **stdout proses kiri langsung ke stdin proses kanan**, sepenuhnya di memori, tanpa file perantara. Ini secara harfiah: saluran `1` milik `ls` disambung ke saluran `0` milik `grep`.

Bandingkan konsep ini dengan command substitution `$( )` Hari 2: keduanya sama-sama menangkap stdout suatu perintah. Bedanya, `$( )` menangkap **seluruhnya sekaligus** ke dalam satu variabel setelah perintah selesai total, sedangkan pipe menyambungkan **dua proses yang berjalan bersamaan**, datanya mengalir terus tanpa menunggu proses kiri selesai total dulu.

Catatan penting untuk fondasi Hari 7 nanti: exit status (`$?`) dari satu baris pipeline, **secara default**, adalah exit status dari perintah **paling kanan** saja — meski perintah di tengah atau kiri gagal, `$?` tidak akan tahu itu kecuali kamu mengaktifkan `set -o pipefail` besok.

## 4. `tee` — Memecah Aliran Data

```bash
ls -la | tee daftar.txt | grep ".sh"
```

`tee` membaca dari stdin, lalu **menulis ke file DAN tetap meneruskannya ke stdout** secara bersamaan — namanya diambil dari analogi sambungan pipa berbentuk huruf T. Di contoh ini, `daftar.txt` berisi output lengkap `ls -la`, sementara `grep ".sh"` tetap menerima data yang sama lewat pipe kedua untuk difilter. Tanpa `tee`, kamu harus menjalankan `ls -la` dua kali terpisah untuk mendapat dua hasil ini. Opsi `-a` membuat `tee` menambahkan (append) ke file alih-alih menimpa — paralel persis dengan beda `>` vs `>>` di section 2.

## 5. Here-Document dan Here-String

```bash
cat <<EOF
Baris pertama
Nilai variabel: $nama
EOF
```

- `<<EOF` — mulai blok teks multi-baris yang diarahkan jadi stdin untuk `cat`. `EOF` adalah **token pembatas bebas** (bisa kamu ganti nama apa saja, konvensi umum saja) — Bash akan terus membaca baris apa adanya sampai menemukan baris yang **persis sama** dengan token itu lagi.
- Di dalam blok ini, ekspansi variabel (`$nama`) **tetap berjalan** — mirip perilaku double quote Hari 2, bukan single quote. Kalau kamu ingin blok ini benar-benar literal tanpa ekspansi apa pun, tulis `<<'EOF'` (token diberi quote).
- `<<-EOF` (varian dengan strip) mengizinkan baris-baris di dalamnya diawali karakter tab untuk indentasi rapi di dalam skrip, tab itu otomatis dibuang saat dieksekusi.

```bash
grep "kata" <<< "ini kalimat yang mengandung kata kunci"
```

- `<<<` — here-string, versi satu baris dari here-document. Teks di sebelah kanan langsung jadi seluruh isi stdin untuk `grep`, tanpa perlu blok multi-baris.

## 6. Tools Eksternal Wajib — Ingat Konsep Hari 1: `$PATH`

Sebelum masuk detail, satu penegasan penting: `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `xargs` **bukan** builtin Bash seperti `echo`, `read`, `cd`. Ini adalah **program terpisah**, dicari lewat `$PATH` persis seperti mekanisme yang kamu bedah di Hari 1 saat menjalankan `ls`. Bash hanya menyediakan "lem" (pipe, redirection) untuk menyambungkan program-program independen ini.

**`grep`** — mencari baris yang cocok pola:

```bash
pacman -Qe | grep -i "python"
```

`-i` — **i**gnore case, pencocokan tanpa peduli huruf besar/kecil. Pola pencocokan dasar `grep` secara konsep **paralel** dengan operator `=~` Hari 5 — bedanya `=~` mencocokkan **satu string** Bash, sedangkan `grep` mencocokkan **tiap baris** dari sebuah stream, satu per satu. Dua opsi lain yang sangat sering dipakai bersamanya: `-v` (invert — tampilkan baris yang **tidak** cocok) dan `-c` (count — cetak **jumlah** baris cocok, bukan isinya).

**`sed`** — pengeditan teks berbasis stream:

```bash
echo "Belajar Bash Scripting" | sed 's/Bash/Shell/'
```

Perintah `s/Bash/Shell/` — **s**ubstitute, ganti kemunculan pertama `Bash` jadi `Shell` di tiap baris. Perhatikan ini **konsep yang sama persis** dengan `${kalimat/Bash/Shell}` Hari 5 — bedanya `sed` bekerja lintas banyak baris dalam sebuah stream, sedangkan ekspansi parameter Bash hanya bekerja pada satu variabel yang sudah ada di memori. Tambahkan `g` di akhir (`s/Bash/Shell/g`) untuk ganti **semua** kemunculan per baris — paralel juga dengan `//` dobel di `${kalimat//a/A}` Hari 5.

**`awk`** — pemrosesan berbasis kolom/field:

```bash
echo "Jon 25 Malang" | awk '{print $2}'
```

Peringatan penting supaya tidak tertukar: `$2` di sini **bukan** argumen posisional Bash dari Hari 2. Di dalam `awk`, `$1`, `$2`, dst merujuk ke **kolom ke-N** pada baris saat ini, dipisah otomatis berdasarkan whitespace secara default (`$0` di `awk` juga beda makna — itu **seluruh baris**, bukan nama skrip seperti `$0` Bash). Ini dua bahasa berbeda yang kebetulan memakai simbol sama — konteksnya (di dalam kutip tunggal setelah `awk`) yang menentukan makna mana yang berlaku.

**`cut`** — ekstraksi kolom lebih sederhana dari `awk`, berbasis delimiter eksplisit:

```bash
cut -d: -f1 /etc/passwd
```

`-d:` — **d**elimiter, karakter pemisah kolom (di sini titik dua, sesuai format `/etc/passwd`). `-f1` — **f**ield nomor 1, ambil kolom pertama saja.

**`sort`** — mengurutkan baris:

```bash
sort -n daftar_angka.txt
```

`-n` — paksa pengurutan **numerik**. Ini wajib diingat sebagai penerapan langsung pelajaran Hari 3 soal `=` vs `-eq`: tanpa `-n`, `sort` mengurutkan secara **string/leksikografis**, sehingga `"10"` dianggap "lebih kecil" dari `"9"` (karena karakter `'1'` lebih kecil dari `'9'` secara ASCII) — akar masalahnya identik persis dengan kenapa `[ "10" = "9" ]` dan `[ "10" -eq "9" ]` menghasilkan logika berbeda kemarin.

**`uniq`** — menghapus baris duplikat **yang bersebelahan saja**:

```bash
sort daftar.txt | uniq -c
```

`uniq` **wajib** dipasangkan setelah `sort` dalam pipeline (bukan kebetulan dua contoh ini digabung) — karena `uniq` hanya mendeteksi duplikat pada baris yang **posisinya bersebelahan langsung**, bukan duplikat yang tersebar di seluruh file. `-c` — **c**ount, tampilkan berapa kali tiap baris unik muncul di depan tiap baris hasil.

**`xargs`** — mengubah baris stdin jadi argumen posisional:

```bash
cat daftar_file.txt | xargs rm
```

Ini jembatan konseptual balik ke Hari 2: pipe biasa mengalirkan data lewat stdin (saluran `0`), tapi banyak program (seperti `rm`) tidak membaca stdin sama sekali — mereka mengharapkan data lewat **argumen posisional** (`$1`, `$2`, ingat Hari 2 & 5). `xargs` menjembatani dua dunia ini: ia membaca tiap baris dari stdin, lalu memanggil perintah setelahnya (`rm` di contoh ini) dengan tiap baris itu dijadikan argumen, persis seolah kamu ketik `rm nama_file1 nama_file2 ...` manual.

## 7. Pipeline Sebagai Rantai Transformasi Data

```bash
cat akses.log | grep "ERROR" | cut -d' ' -f1 | sort | uniq -c | sort -rn
```

Cara membaca pipeline seperti ini bukan "satu perintah panjang", tapi **rantai transformasi berurutan**, tiap tahap menerima output tahap sebelumnya sebagai bahan mentah: ambil isi log → saring baris ber-`ERROR` → ambil kolom pertama tiap baris → urutkan → hitung kemunculan tiap baris unik → urutkan ulang dari yang paling sering muncul. Ini inti filosofi Unix yang disebut di judul hari ini: bukan satu program raksasa yang melakukan semuanya, tapi banyak program kecil, masing-masing ahli di satu hal, disambung lewat mekanisme fd `1` → fd `0` yang sudah kamu bedah tuntas di section 1–3.

---

**Referensi bagian ini:** Bab 3.6 (Redirections) — https://www.gnu.org/software/bash/manual/bash.html#Redirections

**Latihan wajib Hari 6:**

1. Dari `pacman -Qe` (Arch) atau `pkg list-installed` (Termux), bangun pipeline untuk menghitung **jumlah** paket terinstal yang namanya mengandung `"lib"` — manfaatkan opsi `grep` yang sudah dijelaskan di section 6 (petunjuk: kamu tidak perlu tools tambahan di luar yang sudah dibahas hari ini untuk menghasilkan angka akhirnya langsung).
2. Buat skrip yang menjalankan satu perintah sengaja salah (misal `ls /folder/tidak/ada`), redirect stdout-nya ke `output.log` dan stderr-nya ke `error.log` **secara terpisah** dalam satu baris perintah — buktikan dengan `cat` kedua file itu bahwa keduanya benar-benar berisi hal berbeda.
3. Jelaskan dengan kalimatmu sendiri: kenapa `perintah > file.txt 2>&1` dan `perintah 2>&1 > file.txt` menghasilkan perilaku berbeda? Jangan jelaskan ulang apa itu `2>&1` — cukup tunjukkan **urutan eksekusi kiri-ke-kanan** yang membuat dua baris ini berakhir beda, berdasarkan penjelasan section 2 di atas.

Kerjakan ketiganya, terutama poin 3 — pemahaman soal urutan redirection ini akan langsung terpakai di Hari 7, karena `set -euo pipefail` dan `trap` besok berinteraksi langsung dengan exit status pipeline dan saluran stderr yang baru saja kamu kuasai hari ini.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ./../../../../../README.md
[kurikulum]: ./../../../README.md
[sebelumnya]: ./bagian-5/README.md
[selanjutnya]: ./bagian-7/README.md

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
