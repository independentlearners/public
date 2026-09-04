# Hari 4 — Perulangan (Loops) dan Kontrol Alur.

Sebelum masuk sintaks baru, satu jembatan penting dulu: kemarin kita tetapkan bahwa `if` mengeksekusi satu perintah test, lalu bercabang berdasarkan exit status-nya — sekali jalan, sekali keputusan. Loop **bukan konsep baru** dari sisi logika keputusan. Loop hanyalah: *ambil mekanisme keputusan yang sama, lalu ulangi terus selama exit status-nya masih 0*. Tidak ada mekanisme evaluasi baru di sini — yang baru hanyalah pengulangannya. Pegang ini sebagai kerangka berpikir sepanjang materi hari ini.

## 1. `for` Loop — Tiga Gaya

**Gaya list-based:**

```bash
for item in satu dua tiga; do
    echo "$item"
done
```

Bedah elemen yang benar-benar baru:
- `for item in ...` — `item` adalah nama variabel loop (bebas kamu namai apa saja), diisi ulang tiap iterasi dengan satu elemen dari daftar setelah `in`.
- `do` ... `done` — perhatikan ini **beda pola** dari `if...fi` atau `case...esac` kemarin: `done` **bukan** ejaan terbalik dari `for` (kalau dibalik harusnya "rof"). Jangan generalisasi pola "kata dibalik" terlalu jauh — `do...done` adalah pasangan pembuka-penutup tersendiri, dipakai konsisten di semua bentuk loop (`for`, `while`, `until`).
- Daftar `satu dua tiga` di sini dipisah spasi — secara diam-diam ini memanfaatkan mekanisme word splitting yang sudah kita bahas Hari 2, hanya sekarang tujuannya disengaja: memecah daftar jadi elemen-elemen loop.

**Gaya range dengan brace expansion:**

```bash
for i in {1..10}; do
    echo "$i"
done
```

`{1..10}` dievaluasi Bash **sebelum** `for` bahkan mulai membaca daftar — ini disebut *brace expansion*, salah satu bentuk ekspansi yang belum kita singgung Hari 2. Bash secara tekstual mengubah `{1..10}` jadi `1 2 3 4 5 6 7 8 9 10` terlebih dulu, baru `for...in` memprosesnya sebagai daftar biasa seperti contoh pertama. Bisa juga ditambah step: `{1..10..2}` menghasilkan `1 3 5 7 9`.

**Gaya C-style:**

```bash
for (( i=0; i<10; i++ )); do
    echo "$i"
done
```

Ini memanfaatkan langsung konteks aritmetika `(( ))` dari Hari 2 — di dalamnya `i` tidak butuh `$`, sama seperti `$(( ))` kemarin. Tiga bagian dipisah `;`: inisialisasi (`i=0`, jalan sekali di awal), kondisi (`i<10`, dicek tiap sebelum iterasi — inilah exit-status check yang kita bahas di paragraf pembuka), dan increment (`i++`, jalan tiap setelah satu iterasi selesai). `i++` adalah *post-increment*: tambah 1 ke `i` setelah nilainya dipakai (lawannya `++i`, pre-increment — jarang terasa bedanya di konteks ini, tapi penting kalau nanti kamu baca kode orang lain).

## 2. `while` — Pembayaran Langsung dari Konsep Exit Status

```bash
count=1
while [[ $count -le 5 ]]; do
    echo "Iterasi ke-$count"
    ((count++))
done
```

Tidak ada yang perlu dijelaskan ulang soal `[[ $count -le 5 ]]` — itu persis mekanisme test dari Hari 3. Yang baru murni kata kunci `while` sendiri: **selama** exit status perintah setelahnya masih 0, blok `do...done` terus diulang; begitu exit status berubah jadi bukan-nol, loop berhenti dan eksekusi lanjut ke baris setelah `done`.

Ingat catatan kecil Hari 2 soal `(( ))` tanpa `$` sebagai *perintah* ber-exit-status? Inilah momen pembayarannya — kondisi di atas bisa ditulis ulang:

```bash
while (( count <= 5 )); do
    echo "Iterasi ke-$count"
    ((count++))
done
```

Dua bentuk ini **fungsinya identik**. `[[ $count -le 5 ]]` mengevaluasi lewat mesin test string/numerik Hari 3; `(( count <= 5 ))` mengevaluasi lewat mesin aritmetika, lalu menerjemahkan hasilnya (bukan-nol = exit 0, nol = exit 1). Dua jalur berbeda, satu mekanisme keputusan yang sama.

## 3. `until` — Cermin Logis dari `while`

```bash
count=1
until [[ $count -gt 5 ]]; do
    echo "Iterasi ke-$count"
    ((count++))
done
```

Tidak butuh penjelasan mekanisme baru sama sekali — `until` hanya membalik syarat lanjut: `while` mengulang **selama** exit status 0, `until` mengulang **selama** exit status bukan-nol (berhenti begitu jadi 0). Efek program di atas persis sama dengan `while [[ $count -le 5 ]]` di section 2 — ini murni soal mana yang lebih natural dibaca untuk kasus tertentu ("ulangi *sampai* kondisi tercapai" vs "ulangi *selama* kondisi bertahan").

## 4. `break` dan `continue`

```bash
for i in {1..10}; do
    if [[ $i -eq 7 ]]; then
        break
    fi
    if (( i % 2 == 0 )); then
        continue
    fi
    echo "$i"
done
```

- `break` — segera menghentikan loop **terdekat** yang membungkusnya, lompat langsung ke kode setelah `done`. Sisa iterasi yang belum jalan (di contoh ini, `8, 9, 10`) tidak pernah dieksekusi sama sekali.
- `continue` — menghentikan **iterasi saat ini saja**, lompat balik ke pengecekan kondisi loop untuk iterasi berikutnya. Baris `echo "$i"` di bawahnya dilewati untuk angka genap, tapi loop tetap lanjut ke angka berikutnya.
- `i % 2 == 0` — `%` adalah operator modulus (sisa bagi) yang sudah disebut sekilas Hari 2; di sini dipakai konkret untuk mendeteksi angka genap (sisa bagi 2 sama dengan 0).
- Untuk nested loop (loop di dalam loop), `break 2` atau `continue 2` menentukan berapa **level** loop yang ditembus — angka defaultnya 1 (loop terdekat saja) kalau tidak ditulis.

## 5. Membaca File Baris per Baris — Idiom Wajib

```bash
while IFS= read -r line; do
    echo "Baris: $line"
done < file.txt
```

Ini bagian paling penting hari ini secara praktik, dan langsung memanen apa yang kita tanam Hari 2. Bedah tiap elemen baru:

- `IFS=` di depan `read` — ini **temporary assignment**: mengosongkan `$IFS` **hanya untuk satu eksekusi perintah `read` ini**, tidak mengubah `$IFS` shell kamu secara permanen. Kenapa perlu dikosongkan? Karena default `$IFS` (spasi/tab/newline dari Hari 2) akan membuat `read` memangkas spasi di awal/akhir tiap baris — dengan `IFS=`, baris dibaca **persis apa adanya**.
- `-r` — mode raw. Tanpa ini, `read` memperlakukan backslash (`\`) sebagai karakter escape, yang akan merusak baris berisi backslash literal (path gaya Windows, pola regex, dll).
- `done < file.txt` — tanda `<` di sini me-redirect isi `file.txt` jadi stdin untuk **seluruh blok** `while...done`. Kita akan bedah redirection detail Hari 6, tapi cukup pahami dulu: `read` di dalam loop mengonsumsi input ini baris demi baris, satu baris per iterasi, sampai file habis (EOF). Saat EOF tercapai, `read` mengembalikan exit status bukan-nol — dan persis seperti section 2 tadi, itu yang menghentikan `while`-nya. Tidak ada mekanisme berhenti baru di sini; EOF hanya jadi salah satu cara exit status berubah jadi gagal.

Sekarang bandingkan dengan pola yang **terlihat** lebih sederhana tapi salah:

```bash
for line in $(cat file.txt); do
    echo "$line"
done
```

Ini adalah antipola klasik. `$(cat file.txt)` tidak diberi quote, sehingga seluruh isi file mengalami word splitting Hari 2 — bukan dipecah per baris, tapi dipecah per **kata** (berdasarkan spasi juga, bukan cuma newline), dan kalau ada nama file mengandung `*` di dalam teksnya, itu bisa ter-globbing tak sengaja. Baris `"halo dunia"` di file akan pecah jadi dua elemen loop terpisah: `halo` dan `dunia`. Idiom `while IFS= read -r` di atas ada justru untuk menghindari jebakan yang kita pelajari sendiri kemarin.

## 6. `select` — Menyatukan `case` dan `break` dalam Satu Konstruksi

```bash
select opsi in "Mulai" "Berhenti" "Keluar"; do
    case $opsi in
        "Mulai")   echo "Memulai..." ;;
        "Berhenti") echo "Berhenti." ;;
        "Keluar")  break ;;
        *)         echo "Pilihan tidak valid, coba lagi" ;;
    esac
done
```

Perhatikan: sintaks `case...esac` di dalamnya tidak dijelaskan ulang — itu murni pemakaian langsung dari Hari 3. Yang baru hanya `select` sendiri:

- `select opsi in "Mulai" "Berhenti" "Keluar"` — otomatis mencetak menu bernomor (`1) Mulai`, `2) Berhenti`, `3) Keluar`) ke layar, lalu menunggu input angka dari pengguna.
- Setelah pengguna mengetik nomor, `opsi` diisi dengan **teks** yang sesuai (bukan angkanya) — kalau pengguna ketik `1`, maka `$opsi` bernilai `Mulai`.
- Variabel spesial `$REPLY` (belum pernah disebut sebelumnya) otomatis terisi dengan **angka mentah** yang diketik pengguna, kalau kamu butuh nomor asli, bukan teksnya.
- `select` **tidak pernah berhenti sendiri** — ia akan terus menampilkan menu lagi dan lagi setiap selesai satu putaran, kecuali kamu keluarkan secara eksplisit lewat `break` (persis mekanisme `break` yang baru saja dibahas section 4). Ini kenapa opsi "Keluar" di atas wajib memanggil `break` di dalam `case`-nya — tanpa itu, menu akan muncul selamanya.

Ini bukan kebetulan tiga elemen (`select`, `case`, `break`) digabung dalam satu contoh — kombinasi persis inilah yang membentuk hampir semua menu interaktif skrip Bash di dunia nyata.

## 7. Infinite Loop yang Disengaja

```bash
while true; do
    echo "Berjalan terus..."
    sleep 5
done
```

- `true` — builtin yang satu-satunya tugasnya adalah **selalu** mengembalikan exit status 0, apa pun yang terjadi. Ini bukan sintaks khusus untuk infinite loop — ini murni penerapan langsung mekanisme `while` di section 2: karena exit status-nya dijamin selalu 0, kondisi loop tidak akan pernah gagal, jadi loop tidak akan pernah berhenti sendiri.
- `sleep 5` — menjeda eksekusi selama 5 detik (satuan default detik; bisa juga `5m`, `5h` untuk menit/jam) sebelum lanjut ke iterasi berikutnya. Tanpa ini, loop akan menghabiskan seluruh CPU secepat mungkin tanpa jeda — praktik buruk untuk skrip monitoring.
- Cara keluar dari infinite loop seperti ini biasanya dari luar (Ctrl+C, sinyal `SIGINT`) atau lewat `break` internal berdasarkan kondisi tertentu — dua-duanya sudah kita punya alatnya (`break` dari section 4, sinyal akan dibahas lebih dalam Hari 7).

## Kapan Pakai yang Mana

- **`for`** — jumlah iterasi **diketahui di depan** (daftar tetap, range angka, atau iterasi file).
- **`while`** — jumlah iterasi **tidak diketahui di depan**, tergantung kondisi yang bisa berubah dinamis (termasuk idiom baca file section 5).
- **`until`** — sama seperti `while`, dipilih murni karena kondisi berhentinya lebih natural diucapkan sebagai "sampai X terjadi" ketimbang "selama X belum terjadi".
- **`select`** — kapan pun kamu butuh interaksi bernomor dari pengguna, bukan iterasi otomatis.

---

**Referensi bagian ini:** Bab 3.2.5 (Looping Constructs) — https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs

**Latihan wajib Hari 4:**

1. Bangun skrip pemantau baterai di Termux: `while true` + `termux-battery-status` + `sleep 5`, cetak persentase baterai tiap putaran. Jelaskan tiap komponen memakai kerangka section 7 di atas.
2. Buat `for i in {1..20}`: pakai `continue` untuk melewati kelipatan 3, lalu pakai `break` untuk berhenti total begitu `i` lebih besar dari 15. Cetak sisanya.
3. Jawab dengan kalimatmu sendiri: kenapa `while IFS= read -r line; do ... done < file.txt` dianggap aman, sementara `for line in $(cat file.txt); do ... done` dianggap antipola? Kaitkan jawabanmu langsung ke konsep word splitting dari Hari 2 — jangan jelaskan ulang apa itu word splitting, cukup tunjukkan **bagaimana** konsep itu jadi akar masalah di kasus konkret ini.

Kerjakan ketiganya — terutama poin 3, karena itu bukti kamu sudah bisa **menyambungkan** materi lintas hari, bukan sekadar menghafal per topik. Hari 5 (fungsi, array, string manipulation) akan langsung memakai `for`/`while` hari ini sebagai isi tubuh fungsi, jadi fondasi ini harus solid dulu.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ./../../../../../README.md
[kurikulum]: ./../../../README.md
[sebelumnya]: ./bagian-3/README.md
[selanjutnya]: ./bagian-5/README.md

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
