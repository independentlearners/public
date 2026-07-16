<!-- <details> -->
<!--   <summary>📃 Daftar Isi</summary> -->
<!---->
<!-- </details> -->

# 1. Apa itu Shell, dan Apa itu Bash

Shell adalah program yang menjembatani kamu dengan kernel Linux. Saat kamu mengetik perintah dan tekan Enter, shell yang membaca teks itu, memecahnya, mencari tahu program apa yang dimaksud, lalu meminta kernel menjalankannya.

Bash (**B**ourne **A**gain **SH**ell) adalah salah satu implementasi shell — yang paling umum dipakai di Arch Linux dan Termux. Ada shell lain (zsh, fish, dash), tapi logika dasarnya mirip.

**Login vs non-login, interactive vs non-interactive** — ini penting karena menentukan file konfigurasi mana yang dibaca Bash saat start:
- **Login shell**: shell yang dijalankan saat kamu login (misal lewat SSH atau TTY). Membaca `/etc/profile`, lalu `~/.bash_profile` atau `~/.profile`.
- **Non-login shell**: shell baru yang dibuka dari dalam sesi yang sudah login (misal buka terminal baru di desktop). Membaca `~/.bashrc`.
- **Interactive**: kamu mengetik langsung dan shell menunggu input kamu (ada prompt `$`).
- **Non-interactive**: shell menjalankan skrip dari awal sampai akhir tanpa menunggu input kamu.

Di Termux, tiap sesi terminal baru biasanya interactive non-login shell → yang dibaca adalah `~/.bashrc`.

## 2. Anatomi Sebuah Perintah

Bentuk umum:

```
perintah -opsi argumen
```

Contoh konkret:

```bash
ls -la /home/jon
```

Bedah kata per kata:
- `ls` — nama **program** yang dicari shell di dalam `$PATH`. Ini bukan "kata kunci" bawaan shell, melainkan file binary terpisah (biasanya di `/usr/bin/ls`).
- `-la` — ini sebenarnya **dua opsi digabung**: `-l` (long format, tampilkan detail permission/owner/size/tanggal) dan `-a` (all, termasuk file tersembunyi yang diawali titik). Bash tidak tahu apa arti `-l` atau `-a` — itu diinterpretasikan oleh program `ls` sendiri, bukan oleh shell.
- `/home/jon` — **argumen**, yaitu data yang diberikan ke program `ls` untuk diproses (dalam hal ini, direktori mana yang mau dilist).
- Spasi di antara tiap bagian adalah **delimiter** — cara shell tahu di mana satu token berakhir dan token berikutnya mulai. Ini disebut **word splitting**, dan ini akan sangat penting di Hari 2 saat bahas quoting.

## 3. Variabel Lingkungan (Environment Variables)

Coba jalankan:

```bash
echo $HOME
echo $PATH
echo $USER
echo $PWD
```

Penjelasan:
- `echo` — perintah bawaan (builtin) yang mencetak teks ke layar (stdout).
- `$HOME` — tanda `$` memberi tahu Bash: "ini bukan teks literal, tapi **nilai dari variabel** bernama `HOME`". Tanpa `$`, `echo HOME` hanya akan mencetak kata "HOME" secara harfiah.
- `$HOME` berisi path direktori home kamu, misal `/home/jon` (Arch) atau `/data/data/com.termux/files/home` (Termux).
- `$PATH` — ini variabel paling krusial untuk dipahami. Isinya adalah daftar direktori, dipisah tanda titik dua (`:`), tempat shell **mencari** program yang kamu ketik.

Contoh isi `$PATH`:
```
/usr/local/bin:/usr/bin:/bin
```

Saat kamu ketik `ls`, Bash tidak tahu di mana `ls` berada — ia akan **mencari secara berurutan** di tiap direktori dalam `$PATH`, dari kiri ke kanan, sampai ketemu file bernama `ls` yang bisa dieksekusi. Kalau tidak ketemu di direktori manapun, muncul error `command not found`.

Coba buktikan sendiri:

```bash
which ls
```

`which` adalah program yang menelusuri `$PATH` persis seperti yang Bash lakukan, lalu menunjukkan path lengkapnya.

## 4. Skrip Pertama: Shebang dan Izin Eksekusi

Buat file `hello.sh` isinya:

```bash
#!/bin/bash
echo "Halo, ini skrip pertamaku"
```

Bedah **kata per kata, karakter per karakter**:

- `#!` — disebut **shebang** (gabungan kata "hash" + "bang"). Ini bukan komentar biasa meski diawali `#`. Kernel Linux membaca dua karakter pertama file ini secara khusus untuk menentukan **interpreter** mana yang harus menjalankan sisa file.
- `/bin/bash` — **path absolut** ke executable Bash. Kernel akan menjalankan `/bin/bash hello.sh` di belakang layar ketika kamu mengeksekusi file ini langsung.
- Kenapa harus baris pertama, tanpa spasi sebelum `#!`? Karena kernel hanya mengecek 2 byte pertama file secara literal. Kalau ada spasi atau baris kosong sebelumnya, mekanisme ini gagal dan file dianggap skrip shell biasa (fallback ke shell default) — bisa menyebabkan perilaku tak terduga.
- Baris kedua adalah perintah biasa: `echo "teks"` — mencetak teks yang diapit tanda kutip ganda.

Sekarang beri izin eksekusi:

```bash
chmod +x hello.sh
```

Bedah:
- `chmod` — **ch**ange **mod**e, mengubah izin akses file.
- `+x` — tambahkan (`+`) izin eksekusi (`x` = execute) pada file ini. Tanpa ini, sistem operasi akan menolak menjalankan file itu sebagai program meski isinya benar.

## 5. Tiga Cara Menjalankan Skrip — dan Perbedaan Fundamentalnya

```bash
./hello.sh
bash hello.sh
source hello.sh
```

Ini bagian paling sering disalahpahami pemula:

**`./hello.sh`**
- `.` mewakili direktori saat ini, `/` sebagai pemisah, lalu nama file. Ini **wajib** pakai `./` (atau path lengkap) karena direktori kerja saat ini (`.`) biasanya **tidak** termasuk dalam `$PATH` — alasan keamanan, supaya file berbahaya di folder sembarang tidak otomatis tereksekusi.
- Mekanismenya: shell melihat file ini executable (`+x`), membaca shebang, lalu **membuat subshell/proses baru** untuk menjalankan skrip di sana.
- Efek: variabel apa pun yang di-`export` atau diubah di dalam skrip **tidak** memengaruhi shell tempat kamu mengetik perintah ini, karena berjalan di proses anak (child process) yang terpisah.

**`bash hello.sh`**
- Sama seperti di atas — memaksa subshell baru menjalankan file lewat interpreter `bash`, terlepas dari shebang atau izin eksekusi file. Bahkan kalau file tidak punya `+x`, cara ini tetap jalan karena kamu memanggil `bash` secara eksplisit sebagai program, dan file skrip hanya jadi argumennya.

**`source hello.sh`** (atau setara `. hello.sh` dengan titik tunggal + spasi)
- **Tidak** membuat proses baru. Skrip dijalankan **di dalam shell yang sedang kamu pakai sekarang**, baris demi baris, seolah kamu mengetiknya manual satu per satu di prompt.
- Efek: variabel, `export`, perubahan direktori (`cd`) di dalam skrip **akan** memengaruhi sesi terminal kamu saat ini dan tetap ada setelah skrip selesai. Ini kenapa file seperti `~/.bashrc` di-*source*, bukan dieksekusi biasa.

## 6. Instalasi dan Verifikasi Versi Bash

Arch Linux:
```bash
sudo pacman -S bash
bash --version
```

Termux:
```bash
pkg install bash
bash --version
```

Penjelasan singkat opsi:
- `pacman -S` — **S**ync, instal paket dari repository resmi Arch.
- `pkg install` — wrapper Termux di atas `apt`, sintaksnya lebih sederhana.
- `bash --version` — opsi panjang (diawali `--`) untuk menampilkan versi Bash yang terpasang. Penting dicek karena beberapa fitur (misal array asosiatif) hanya ada di Bash versi 4 ke atas.

---

**Latihan wajib Hari 1:**

1. Buat `hello.sh` persis seperti contoh di atas.
2. Jalankan dengan ketiga cara (`./hello.sh`, `bash hello.sh`, `source hello.sh`).
3. Tambahkan baris `MYVAR="tes"` di dalam skrip, lalu setelah tiap cara eksekusi, cek dari terminal luar dengan `echo $MYVAR` — bandingkan hasilnya di ketiga skenario dan jelaskan **kenapa** hasilnya berbeda, berdasarkan konsep subshell vs shell saat ini yang baru kita bahas.

<!-- Coba kerjakan latihan itu, lalu ceritakan hasilnya ke saya — termasuk kalau ada yang bikin bingung. Kita lanjut Hari 2 setelah kamu yakin paham konsep subshell ini, karena semua materi berikutnya bertumpu di atasnya. -->

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------
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
------------------>


