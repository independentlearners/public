# Hari 7 — Skrip Robust: Error Handling, Debugging, dan Best Practice.

Ini hari terakhir dari rencana 7 hari, dan sekaligus penagihan langsung dari dua utang yang sengaja aku gantung di penutup Hari 6: `pipefail` (soal exit status pipeline) dan interaksi dengan stderr. Catatan kecil dulu: aku baru saja perbaiki satu link referensi di file kurikulum awal — `trap` ternyata didokumentasikan di Bab 4.1 (Bourne Shell Builtins), bukan 3.7.5 seperti draft awal.

## 1. `set -e`, `set -u`, `set -o pipefail` — Mengubah Kebiasaan Jadi Kontrak

```bash
set -euo pipefail
```

Ini bukan satu opsi, tapi tiga opsi digabung dalam satu baris.

**`-e` (errexit)** — begitu ada perintah yang exit status-nya bukan 0, skrip langsung berhenti total saat itu juga, tidak lanjut ke baris berikutnya. Tapi ada pengecualian penting yang wajib dihafal, karena ini sumber kebingungan paling umum: Bash tidak langsung keluar kalau perintah yang gagal itu menjadi bagian dari kondisi pengujian if, bagian dari loop while/until, bagian dari rangkaian && atau ||, atau statusnya sengaja dibalik pakai tanda !. Contoh konkret paling sering menjebak pemula:

```bash
set -e
if grep -q "pola" file.txt; then
    echo "Ketemu"
fi
echo "Baris ini tetap jalan, walau grep di atas gagal (pola tidak ketemu)"
```

`grep` di sini **gagal** (exit 1) kalau pola tidak ditemukan — tapi karena ia menjadi syarat pengujian `if`, `-e` **tidak** memicu keluar, sebab kegagalan itu memang bagian normal dari logika percabangan, bukan error tak terduga. Konsekuensi praktis lain: idiom `perintah_boleh_gagal || true` sengaja dipakai untuk meredam `-e` di satu baris tertentu, karena keseluruhan rangkaian `||` dianggap sukses selama sisi kanan (`true`) sukses.

**`-u` (nounset)** — mereferensikan variabel yang **belum pernah diset** langsung dianggap error dan menghentikan skrip. Ini pasangan langsung dari `${var:-default}` Hari 5: kalau kamu **tidak** memberi default eksplisit dan `-u` aktif, mengetik `$variabel_yang_typo` (misal salah ketik nama variabel) tidak lagi diam-diam jadi string kosong seperti biasa — skrip mati seketika dengan pesan jelas. Ini bukan konsep baru soal ekspansi, murni mengubah **perilaku default Bash** terhadap variabel kosong yang sudah kamu kenal sejak Hari 2.

**`-o pipefail`** — inilah pembayaran langsung utang Hari 6. Kalau opsi ini aktif, exit status keseluruhan pipeline menjadi status dari perintah paling kanan yang gagal, atau nol kalau semua perintah dalam pipeline sukses — bukan lagi otomatis mengikuti status perintah paling kanan apa adanya. Ingat catatan penutup Hari 6: secara default, `$?` satu baris pipeline hanya mencerminkan perintah terakhir, sehingga `cat file_tidak_ada.txt | grep "pola"` bisa terlihat "sukses" (karena `grep` sendiri jalan normal) meski `cat` di awal gagal total. `pipefail` menutup celah ini — begitu **salah satu** tahap gagal, seluruh pipeline dianggap gagal, dan kalau `-e` juga aktif, skrip langsung berhenti.

**Kenapa `-o pipefail` ditulis terpisah dengan `-o`, tidak digabung jadi huruf tunggal seperti `e` dan `u`?** Karena `-o` adalah cara Bash memberi opsi **nama panjang** (bukan satu huruf) ke perintah `set` — `pipefail` tidak punya alias satu-huruf seperti `-e`/`-u`, jadi harus dipanggil lewat mekanisme `-o nama_opsi`. Ini kenapa `-euo pipefail` valid: `-e`, `-u`, `-o` digabung jadi satu string flag (`euo`), tapi `-o` tetap butuh **argumen terpisah** setelahnya (`pipefail`) karena ia bukan flag berdiri sendiri.

## 2. `trap` — Menangkap Sinyal untuk Cleanup Otomatis

```bash
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

echo "data sementara" > "$tmpfile"
# ... proses lain pakai $tmpfile ...
```

Bedah kata per kata:
- `mktemp` — program (bukan builtin) yang membuat file sementara dengan nama unik secara aman, lalu mencetak **path lengkapnya** ke stdout. `$(mktemp)` di sini murni command substitution Hari 2 seperti biasa, hanya sekarang program yang dipanggil adalah `mktemp`.
- `trap 'rm -f "$tmpfile"' EXIT` — argumen pertama (dalam single quote, supaya `$tmpfile` **tidak** langsung diekspansi saat baris `trap` dieksekusi, melainkan diekspansi nanti saat trap-nya benar-benar terpicu) adalah perintah yang akan dijalankan. Argumen kedua, `EXIT`, adalah **pseudo-sinyal** — bukan sinyal Unix sungguhan, tapi nama khusus yang dikenali Bash.
- sigspec yang dikenali trap boleh berupa nama sinyal seperti SIGINT (dengan atau tanpa awalan SIG) atau nomor sinyal; kalau sigspec berupa 0 atau EXIT, perintahnya dijalankan saat shell keluar, kalau DEBUG maka dijalankan setelah tiap perintah sederhana, dan kalau ERR maka dijalankan tiap kali sebuah perintah sederhana menghasilkan status bukan-nol.

Konsekuensi praktis: `EXIT` trap ini terpicu **apa pun** penyebab skrip berhenti — selesai normal, dipanggil `exit` manual, atau dihentikan paksa oleh `-e` di section 1. Ini kenapa pola `mktemp` + `trap ... EXIT` jadi idiom baku untuk cleanup: kamu tidak perlu menaruh `rm -f "$tmpfile"` di **setiap** kemungkinan jalur keluar skrip secara manual satu-satu — cukup didaftarkan sekali di awal.

Bisa juga menangkap sinyal sungguhan dan beberapa sekaligus:

```bash
trap 'echo "Dihentikan paksa, membersihkan..."; rm -f "$tmpfile"; exit 1' SIGINT SIGTERM
```

`SIGINT` — sinyal yang dikirim saat kamu tekan Ctrl+C. `SIGTERM` — sinyal terminasi standar (misal dari `kill` tanpa opsi tambahan). Satu baris `trap` bisa didaftarkan untuk **beberapa** sigspec sekaligus, dipisah spasi.

Untuk debugging, kombinasi berguna dengan `$LINENO` (variabel spesial berisi nomor baris yang sedang dieksekusi, belum pernah disebut sebelumnya):

```bash
trap 'echo "Error di baris $LINENO" >&2' ERR
```

Pola `>&2` di sini murni penerapan langsung file descriptor Hari 6 — arahkan pesan error trap ke stderr, bukan bercampur dengan output normal skrip di stdout.

## 3. Debugging: `bash -x` dan `set -x` / `set +x`

```bash
bash -x script.sh
```

Menjalankan seluruh skrip dalam **xtrace mode** — tiap perintah dicetak ke stderr (diawali tanda `+`) **setelah** mengalami ekspansi (variabel sudah diganti nilainya, command substitution sudah dieksekusi), tepat sebelum benar-benar dijalankan. Ini cara paling langsung melihat apa yang **sungguh-sungguh** dieksekusi Bash, bukan cuma apa yang kamu tulis secara literal.

Untuk mengaktifkan hanya di sebagian skrip:

```bash
set -x
# ... blok yang mau diperiksa detail ...
set +x
```

Perhatikan baik-baik: ini builtin `set` yang **sama persis** dari section 1, hanya sekarang dengan flag `-x` (bukan `-e`/`-u`/`-o`). Yang wajib digarisbawahi karena kontra-intuitif: `-x` **menyalakan** xtrace, tapi `+x` (tanda plus, bukan minus) yang **mematikannya**. Pola tanda `-`/`+` berkebalikan ini berlaku untuk semua flag `set`, termasuk `-e`/`+e` dan `-u`/`+u` di section 1 — `-` selalu "aktifkan", `+` selalu "nonaktifkan", meski secara visual `+` biasanya diasosiasikan "tambah/nyala" di konteks lain.

## 4. `shellcheck` — Linter Wajib Sebelum Skrip Dianggap Selesai

```bash
# Arch Linux
sudo pacman -S shellcheck

# Termux
pkg install shellcheck

# Pemakaian
shellcheck script.sh
```

ShellCheck adalah tool analisis statis yang mencari bug di dalam skrip shell. Yang membuatnya sangat relevan menutup minggu ini: banyak kategori peringatannya **persis** memetakan ke disiplin yang kita bangun sejak Hari 2 — misalnya kode `SC2086` menandai variabel yang dipakai tanpa quote (persis jebakan word splitting Hari 2), dan `SC2181` menandai kebiasaan mengecek `$?` secara tidak langsung padahal bisa langsung menguji perintahnya di `if` (persis prinsip exit status Hari 3). `shellcheck` pada dasarnya bukan mengajarkan aturan baru — ia **menegakkan otomatis** apa yang sudah kamu latih jadi refleks manual sepanjang minggu ini.

## 5. Struktur Skrip Profesional

Contoh kerangka `usage()` — perhatikan ini merangkai lima konsep lintas hari sekaligus tanpa satu pun perlu dijelaskan ulang:

```bash
#!/bin/bash
set -euo pipefail

usage() {
    echo "Penggunaan: $0 <sumber> <tujuan>" >&2
    exit 1
}

[[ $# -eq 2 ]] || usage

sumber="$1"
tujuan="$2"
```

Runtutannya: fungsi (Hari 5) bernama `usage`, mencetak ke stderr lewat `>&2` (Hari 6), dipicu lewat `||` (Hari 3) kalau jumlah argumen (`$#`, Hari 2) tidak sama dua (`-eq`, Hari 3), lalu `exit 1` sebagai kode keluar tidak-nol yang konsisten. Validasi ini **wajib** diletakkan di awal skrip, sebelum baris kerja nyata mana pun dieksekusi — prinsipnya: gagal cepat, gagal jelas, sebelum skrip sempat mengubah apa pun di sistem.

Tabel kode keluar (exit code) yang jadi konvensi luas dan layak kamu ikuti demi konsistensi:

| Kode | Makna konvensional |
|---|---|
| `0` | Sukses |
| `1` | Error umum |
| `2` | Kesalahan penggunaan (argumen salah/kurang) |
| `126` | File ditemukan, tapi tidak bisa dieksekusi |
| `127` | Perintah tidak ditemukan |
| `128+n` | Dihentikan oleh sinyal nomor `n` (mis. `130` = `128+2`, dihentikan `SIGINT`/Ctrl+C) |

Yang penting bukan kamu menghafal tabel ini kata per kata, tapi **konsisten** memakai skema yang sama di seluruh skrip kamu sendiri — supaya siapa pun (termasuk kamu sendiri enam bulan lagi) bisa membaca `echo $?` dan langsung tahu kategori kegagalannya tanpa buka kode.

## 6. Perbedaan Platform: Termux vs Arch Linux

Ini bukan soal sintaks Bash (yang identik di keduanya), tapi soal **lingkungan** tempat skrip kamu berjalan:

- **Akses root** — Arch Linux biasanya memberi akses `sudo`/root penuh ke seluruh sistem. Termux, tanpa perangkat di-root secara terpisah, berjalan sepenuhnya di sandbox userspace Android — skrip kamu **tidak** bisa menyentuh file di luar direktori Termux sendiri (`$HOME` Termux) atau memodifikasi sistem Android secara langsung.
- **`systemd`** — Arch Linux memakai `systemd` sebagai init system, jadi `systemctl`, `journalctl` tersedia untuk mengelola service/membaca log. Android **tidak** memakai `systemd` sama sekali, sehingga dua perintah itu **tidak ada** di Termux — kalau kamu butuh skrip "berjalan terus di background", pendekatannya balik ke `while true` + `sleep` (Hari 4) atau `nohup perintah &`, bukan lewat service `systemd`.
- **Ketersediaan tool** — beberapa tool dari section 6 Hari 6 (`grep`, `sed`, `awk`, dst) tersedia di keduanya lewat paket standar, tapi selalu bijak cek dulu (`which nama_tool`, konsep Hari 1) sebelum asumsi sebuah tool otomatis ada di Termux.

Praktik aman: kalau skrip kamu perlu portable ke dua-duanya, deteksi lingkungan di awal skrip (misal cek `$PREFIX` yang khas ada di Termux, atau cek keberadaan `/etc/arch-release`), lalu cabangkan perilaku pakai `if` (Hari 3) yang sudah kamu kuasai.

## 7. Skrip Idempotent

Idempotent berarti: dijalankan satu kali atau seratus kali, hasil akhirnya **sama**, tidak ada efek samping menumpuk. Dua pola konkret, keduanya murni menyusun ulang alat yang sudah kamu punya:

```bash
mkdir -p "$folder_tujuan"
```

`-p` — buat direktori **hanya kalau belum ada**, dan tidak error kalau ternyata sudah ada (beda dari `mkdir` polos yang akan melempar error "File exists" kalau dijalankan dua kali). Ini setara menulis manual `[[ -d "$folder_tujuan" ]] || mkdir "$folder_tujuan"` (operator `-d` dan `||` dari Hari 3) — tapi `-p` melakukannya dalam satu langkah.

```bash
grep -qxF "baris_konfigurasi" file.conf || echo "baris_konfigurasi" >> file.conf
```

Tiga opsi `grep` baru sekaligus di sini: `-q` (**q**uiet, tidak mencetak apa pun ke stdout, hanya menghasilkan exit status — cocok dipakai murni sebagai syarat `||`), `-x` (cocokkan **seluruh baris**, bukan sebagian), `-F` (**F**ixed string, perlakukan pola sebagai teks literal, bukan regex). Logikanya: tambahkan baris ke `file.conf` **hanya kalau** baris itu belum ada persis sama di sana — tanpa pengecekan ini, tiap kali skrip dijalankan ulang, baris yang sama akan terus menumpuk di `file.conf`.

---

**Referensi bagian ini:** Bab 4.3.1 (The Set Builtin) — https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin, dan Bab 4.1 (Bourne Shell Builtins, bagian `trap`) — https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins. Untuk `shellcheck`: https://www.shellcheck.net/

---

## Ini Menutup Rencana 7 Hari — Saatnya Proyek Akhir

Latihan hari ini tetap ada (di bawah), tapi karena ini hari terakhir dari roadmap awal, latihan sesungguhnya adalah **satu proyek nyata** yang memaksa kamu memakai seluruh tujuh hari sekaligus, bukan per bagian terpisah.

**Checklist wajib — proyek kamu harus memuat:**

| Elemen | Dari hari mana |
|---|---|
| Shebang + `chmod +x`, dijalankan via `./` | Hari 1 |
| Variabel di-quote benar, minimal satu `$()` | Hari 2 |
| Validasi argumen pakai `if`/`[[ ]]` dan/atau `case` | Hari 3 |
| Minimal satu bentuk loop (`for`/`while`) | Hari 4 |
| Minimal satu fungsi dengan `local`, satu array | Hari 5 |
| Minimal satu pipeline (`\|`), output di-redirect ke log file | Hari 6 |
| `set -euo pipefail`, satu `trap ... EXIT`, fungsi `usage()` | Hari 7 |

**Tiga pilihan proyek** (persis seperti yang disebut di garis besar awal kurikulum) — pilih satu:
1. **Skrip backup** — kompres folder tertentu ke file `.tar.gz` bertanggal, simpan log hasil, hapus backup lebih tua dari N hari.
2. **Monitor resource** — loop tak berhenti (Hari 4) yang mencatat pemakaian CPU/RAM/baterai (Termux: `termux-battery-status`) ke file log setiap interval tertentu.
3. **Installer paket favorit** — baca daftar nama paket dari array/file, loop instalasi tiap paket lewat `pacman`/`pkg`, catat mana yang sukses/gagal ke log terpisah.

Supaya kamu tidak mulai dari kertas kosong, ini kerangka (**bukan solusi** — isi tiap `TODO` sendiri):

```bash
#!/bin/bash
set -euo pipefail

LOGFILE="$HOME/proyek_akhir.log"

usage() {
    echo "Penggunaan: $0 <argumen_yang_relevan>" >&2
    exit 1
}

log() {
    # TODO: format pesan dengan timestamp, arahkan ke $LOGFILE lewat >>
    :
}

cleanup() {
    # TODO: aksi cleanup, misal hapus file sementara
    :
}
trap cleanup EXIT

[[ $# -ge 1 ]] || usage

# TODO: validasi tiap argumen dengan case/if + operator file Hari 3

proses_item() {
    local item="$1"
    # TODO: logika inti per item, kembalikan status via return
}

# TODO: loop utama (for/while) memanggil proses_item untuk tiap target,
#       tangkap hasilnya, kirim ke pipeline (Hari 6) kalau perlu

log "Selesai."
```

Mau ambil proyek yang mana dari ketiganya, atau kamu sudah punya ide otomatisasi sendiri yang ingin dikerjakan? Setelah kamu tentukan, aku akan review tiap bagian yang kamu tulis — sama seperti pola sepanjang minggu ini, bukan menuliskan solusinya untukmu.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
