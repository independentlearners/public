# Panduan lengkap membaca dokumentasi shell, POSIX, dan CLI di Linux

Panduan ini bertujuan membuat kamu **bisa menemukan, membaca, dan (jika perlu) membuat/memodifikasi dokumentasi** untuk perintah Linux — termasuk *builtins* shell, utilitas tradisional (coreutils, grep, dsb.), dan tool modern (Rust/Go/Node/Dart/Python). Semua contoh **dijelaskan kata-per-kata** dan disertai langkah praktis yang bisa langsung kamu pakai di Archlinux / Neovim / terminal.

---

## Ringkasan singkat (apa yang harus diingat)

* Perintah bisa **builtin shell**, **alias**, **fungsi**, atau **executable** di `$PATH`. Gunakan `type -a` / `command -v` / `which` untuk deteksi.
* Dokumentasi bisa berbentuk: `man` (groff/troff), `info` (Texinfo), `--help` output, README di repo, `/usr/share/doc/<pkg>`, atau dokumentasi web (GNU, POSIX, proyek upstream).
* Untuk *builtins* gunakan `help`, `enable`, `builtin`, dan `man bash`/`info bash`.
* Untuk tool modern biasanya `--help` + README online; tool-tool modern sering dibangun dengan Rust/Go/Node/Python/Dart—pelajari bahasa & toolchain jika mau mengubahnya.
* Lokasi dokumen penting: `/usr/share/man/`, `/usr/share/doc/`, `man7.org`, `kernel.org/man-pages`, `gnu.org`, `pubs.opengroup.org` (POSIX), `wiki.archlinux.org`.

Sumber rujukan umum (reputabel): GNU Bash Reference Manual (gnu.org), The Open Group POSIX spec (pubs.opengroup.org), Linux man-pages (kernel.org/man-pages), man7.org (Michael Kerrisk), Arch Wiki (wiki.archlinux.org).

---

# 1 — Alur umum saat menemukan perintah baru

1. `type -a <cmd>` → lihat tipe: builtin/alias/fungsi/executable.
2. `command -v <cmd>` atau `which <cmd>` → path yang akan dipanggil.
3. `<cmd> --help` atau `<cmd> -h` → ringkasan singkat.
4. `man <cmd>` → manual page (jika ada).
5. `info <cmd>` → Texinfo (GNU).
6. `apropos <keyword>` / `man -k <keyword>` → cari topik terkait.
7. Cek paket & dokumentasi lokal (`pacman -Qi`, `pacman -Ql <pkg>`, `ls /usr/share/doc/<pkg>`).
8. Jika perlu: cari repo upstream via `pacman -Si <pkg>` lalu `git clone` → baca `README`, `docs/`, `src/`.

---

# 2 — Perintah penting & penjelasan kata-per-kata

### `type -a git`

* `type` → builtin shell (bash) untuk mengecek jenis perintah.
* `-a` → opsi: tunjukkan **semua** lokasi yang cocok (alias, builtin, fungsi, file di PATH).
* `git` → nama perintah.

Contoh output dan arti:

* `git is /usr/bin/git` → executable.
* `git is hashed (/usr/bin/git)` → lokasi sudah di-cache oleh shell.
* `git is a shell builtin` → (jarang) artinya shell menyediakan perintah itu sendiri.

---

### `command -v ls`

* `command` → builtin yang mengeksekusi perintah tanpa mematuhi alias/fungsi.
* `-v` → opsi: tampilkan path (POSIX).
* `ls` → target.

Gunakan `command -v` bila ingin tahu apa yang benar-benar akan dijalankan oleh shell.

---

### `which python`

* `which` → utility eksternal yang mencari executable di `$PATH`. (Catatan: behavior bisa berbeda antar distribusi; `command -v` lebih POSIX-friendly).
* `python` → target.

---

### `help cd`

* `help` → builtin bash menampilkan dokumentasi singkat untuk **builtin** shell. Wajib menggunakan shell bash, jika sedang ada di zsh, ketik `bash` untuk masuk sementara ke shell bash lalu ketik `help <perintah>` seperti contoh:
  - > `help compgen` → builtin untuk menampilkan semua perintah,`help cd` → builtin yang berpindah direktori.

Jika `help` punya hasil → **pasti** itu builtin.

---

### `builtin echo`

* `builtin` → kata kunci bash untuk memaksa menjalankan versi builtin dari perintah (mengabaikan alias/executable).
* `echo` → target.

Jika kamu ingin memaksa menggunakan `/usr/bin/echo`, jalankan path lengkap: `/usr/bin/echo`.

---

### `man bash`

* `man` → pembaca manual page (menggunakan groff/troff halaman yang ada di `/usr/share/man/`).
* `bash` → topik manual (file `bash.1` atau file manual Bash).

`man bash` berisi seluruh dokumentasi Bash (termasuk daftar builtin). Karena besar, sering dipakai *grep pipeline* untuk mencari bagian tertentu (lihat contoh di bawah).

---

### `info coreutils`

* `info` → pembaca Texinfo (format dokumentasi GNU).
* `coreutils` → topik.

Digunakan terutama untuk dokumentasi GNU yang ditulis dalam Texinfo.

---

### `apropos useradd`  /  `man -k useradd`

* `apropos` / `man -k` → cari database man pages untuk kata kunci.
* `useradd` → istilah pencarian.

Mengembalikan daftar man pages yang relevan.

---

## Contoh pipeline yang sering dipakai

**Contoh yang kamu beri**:

```
man bash | grep -A 20 compgen | bat
```

Penjelasan alur:

* `man bash` → keluarkan manual lengkap Bash ke stdout.
* `|` → pipe: alirkan stdout ke stdin perintah berikutnya.
* `grep -A 20 compgen` → `grep` cari baris yang mengandung `compgen`, `-A 20` sertakan 20 baris **setelah** baris yang cocok.
* `| bat` → kirim hasil ke `bat` (cat modern dengan highlighting).
  `bat` memudahkan baca (syntax highlight, nomor baris). Jika `bat` belum ada, gunakan `less` atau `ccat`.

Variasi berguna:

* Case-insensitive: `grep -i -A 20 'compgen'`
* Gunakan `rg` (ripgrep) untuk kecepatan: `man bash | rg -n -A20 compgen | bat` (`rg` ditulis menggunakan Rust).

---

# 3 — Memahami struktur `man` page (SYNOPSIS & konvensi)

`man` page umumnya terstruktur: `NAME`, `SYNOPSIS`, `DESCRIPTION`, `OPTIONS`, `EXAMPLES`, `FILES`, `SEE ALSO`.

Contoh `SYNOPSIS`:

```
ls [OPTION]... [FILE]...
```

Penjelasan:

* `ls` → nama program.
* `[OPTION]...` → `[]` berarti **opsional**; `...` berarti **bisa berulang**.
* `[FILE]...` → argumen file/dir opsional dan bisa lebih dari satu.
* `|` → pemisah pilihan (pilih salah satu).
* `ARG` kapital → placeholder untuk nilai nyata.

Konvensi umum:

* `-o`, `--option` → short dan long options.
* `--` → menandai akhir opsi; argumen berikutnya diperlakukan sebagai operand (berguna jika filename dimulai dengan `-`).
* `man <section> topic` → baca man page di section tertentu, mis. `man 5 crontab` (section 5 = file format).

Man sections biasa:
1 — user commands, 2 — system calls, 3 — library calls, 4 — special files, 5 — file formats, 6 — games, 7 — misc, 8 — admin commands.

---

# 4 — Builtins shell: cara membaca dan eksperimen

* Cek apakah builtin: `type -a <cmd>` / `help <cmd>`.
* Semua builtin Bash terdaftar di `man bash` di bagian `SHELL BUILTIN COMMANDS`.
* Daftar runtime builtin: `enable` atau `enable -a`.
* Untuk eksperimen tanpa mempengaruhi shell kamu: buka subshell `bash --noprofile --norc` lalu coba builtins.
* `compgen`, `complete`, `compopt`, `bind` — relevan ke autocompletion dan sering hanya dijelaskan di `man bash` bukan man page terpisah.

---

# 5 — Mencari dokumentasi paket pada Arch Linux (praktik)

Perintah essential:

* `pacman -Qi <pkg>` → info paket terinstal.
* `pacman -Ql <pkg>` → daftar file paket (lihat `usr/share/man`, `usr/share/doc`).
* `pacman -Si <pkg>` → info paket di repo (termasuk URL upstream).
* `pkgfile <path>` → cari paket yang menyediakan file (install `pkgfile`).

Contoh:

```
pacman -Ql bash
```

Penjelasan:

* `pacman` → package manager Arch.
* `-Q` → query paket lokal.
* `-l` → list file paket.
* `bash` → nama paket target.

Jika dokumentasi tidak ada, pasang paket dokumen:

```
sudo pacman -S man-db man-pages systemd-doc
```

— `man-db` dan `man-pages` menyediakan man/DB dan halaman man dasar.

Sumber lokal lain: `/usr/share/doc/<pkg>/`.

---

# 6 — Jika dokumentasi minim: baca source

Alur:

1. `command -v <cmd>` → dapatkan path.
2. `pacman -Qo $(command -v <cmd>)` → tahu paket pemilik file.
3. `pacman -Si <pkg>` → ambil URL upstream / homepage.
4. `git clone <repo>` → buka `README.md`, `docs/`, dan `src/`.
5. Cari strings “usage”, “help”, `--help` handler di source.

Kenapa ini penting: banyak small utility / script hanya punya comment di header atau README di repo.

---

# 7 — Membuat man page (ringkas & template)

Pilihan umum:

* Tulis langsung dalam *groff (man) format*.
* Gunakan generator: `help2man` (dapat menghasilkan man dari `--help`), `ronn`, `pandoc` untuk convert Markdown → man.
* Untuk Texinfo gunakan `makeinfo`.

Contoh *minimal* file man (groff) untuk `mycmd` — simpan sebagai `mycmd.1`:

```
.\" Manpage for mycmd
.TH MYCMD 1 "2025-11-13" "mycmd 1.0" "User Commands"
.SH NAME
mycmd \- contoh utilitas
.SH SYNOPSIS
.B mycmd
.RI [ options ] " " file
.SH DESCRIPTION
.PP
Penjelasan singkat tentang mycmd.
.SH OPTIONS
.TP
.B \-h, \-\-help
Tampilkan bantuan.
.SH SEE ALSO
.BR anothercmd (1)
```

Penjelasan ringkas:

* `.TH` → header: judul, section (1), tanggal, versi, kategori.
* `.SH` → section heading.
* `.B` / `.RI` → groff macros untuk bold/italic/argument formatting.
* `.TP` → tag paragraph untuk opsi.

Setelah file `mycmd.1` selesai, taruh di `usr/share/man/man1/mycmd.1` pada paketmu, lalu `mandb`/`makewhatis` supaya bisa diakses oleh `man`.

---

# 8 — Packaging (Arch) — memastikan man pages ikut terpasang

* Dalam `PKGBUILD`, sertakan instalasi man page ke `${pkgdir}/usr/share/man/man1/`.
* Build package: `makepkg -si` (buat paket lalu instal).
  Penjelasan sederhana:
* `PKGBUILD` → file skrip build untuk Arch.
* `${pkgdir}` → directory destinasi saat packaging.
* `makepkg` → tool yang membuat paket.

---

# 9 — Tools tambahan yang mempercepat pencarian docs & contoh

* `tldr <cmd>` → ringkasan & contoh (komunitas). Ada klien di banyak bahasa (Node/Python/Rust).
* `cheat` / `cht.sh` → cheat sheets.
* `ripgrep (rg)` → pencarian cepat (ditulis di Rust).
* `bat` → cat modern (Rust), untuk tampilan berwarna.
* `man -k / apropos` → keyword search di DB man.

---

# 10 — Script kustomisasi panduan

Jika kamu memiliki tujuan memodifikasi atau menambahkan fitur/documentation secara mandiri, kamu bisa mengikuti saran berikut.

### Persiapan minimal:

1. **Cari bahasa & toolchain**: lihat repo (README/Makefile/ Cargo.toml / go.mod / setup.py / pubspec.yaml). Umum: C untuk coreutils/bash, Rust untuk banyak tool modern (rg, bat), Go untuk beberapa util, Node/Python untuk klien.
2. **Install toolchain**: `gcc/clang`, `make`, `cargo` (Rust), `go` (Go), `dart` SDK (Dart), `python` & `pip`, `node` & `npm`.
3. **Pelajari build & testing**: baca `CONTRIBUTING.md` di repo upstream.
4. **Buat man page**: bisa dengan `help2man` (auto-generate dari `--help`) lalu tweak manual teks.
5. **Buat PKGBUILD** agar dokumentasi ikut terinstal di `/usr/share/man/`.

Contoh alur kontribusi singkat:

* Fork repo → clone → buat branch fitur → tambahkan `--help` atau `man` → jalankan test lokal → buat PR.

---

# 11 — Skrip bantu: `checkdoc` (Bash) — buat ringkasan otomatis

Simpan sebagai `~/bin/checkdoc` dan buat executable (`chmod +x ~/bin/checkdoc`).

```bash
#!/usr/bin/env bash
# checkdoc: ringkas dokumentasi untuk <cmd>

cmd="$1"
if [ -z "$cmd" ]; then
  echo "Usage: checkdoc <command>"
  exit 1
fi

echo "1) type -a $cmd"
type -a "$cmd" 2>/dev/null || true
echo

echo "2) command -v $cmd"
command -v "$cmd" 2>/dev/null || true
echo

echo "3) --help (first 200 lines)"
"$cmd" --help 2>&1 | sed -n '1,200p' || echo "(no --help)"
echo

echo "4) man (first match)"
man "$cmd" 2>/dev/null | sed -n '1,200p' || echo "(no man page)"
echo

echo "5) apropos/$cmd (man -k)"
man -k "$cmd" 2>/dev/null | sed -n '1,50p' || echo "(no apropos match)"
echo

# arch specific: paket pemilik
if command -v pacman >/dev/null 2>&1; then
  binpath=$(command -v "$cmd" 2>/dev/null)
  if [ -n "$binpath" ]; then
    echo "6) pacman -Qo $binpath"
    pacman -Qo "$binpath" 2>/dev/null || echo "(not owned by pacman)"
    echo
  fi
fi
```

Penjelasan kata-per-kata (ringkas):

* `#!/usr/bin/env bash` → shebang, jalankan skrip dengan `bash`.
* `cmd="$1"` → ambil argumen pertama sebagai nama perintah.
* `type -a "$cmd"` → cek tipe.
* `"${cmd}" --help` → jalankan `--help` program (note: beberapa program akan error jika dijalankan tanpa argumen; kita redirect stderr ke stdout `2>&1`).
* `man "$cmd"` → tampilkan man page jika ada.
* `man -k "$cmd"` → cari keyword.
* `pacman -Qo "$binpath"` → (Arch) cari paket pemilik file.

Skrip ini berguna sebagai langkah pertama; kamu bisa kembangkan lagi (format output jadi Markdown, buka di Neovim, dsb).

---

# 12 — Tips lanjutan & best practices

* Pasang `man-db`, `man-pages`, `info` untuk pengalaman offline.
* Gunakan `man -P "less -R"` untuk melihat warna/formating.
* `man -l /path/to/local/manpage.1` untuk membaca man page lokal.
* Untuk builtins, gunakan `help` dan `man bash`. Jika pakai zsh, gunakan `whence -v` / `man zshbuiltins`.
* Pelajari POSIX spec (The Open Group) bila menulis skrip portabel.
* Selalu sediakan `--help` singkat dan `README.md` untuk proyek baru; gunakan `help2man`/`ronn` untuk man page awal.

---
<!--
## Penutup singkat (aksi nyata)

Aku sudah menyusun panduan terstruktur + skrip bantu. Jika kamu mau, aku bisa **langsung**:

* Buatkan `checkdoc` versi lebih lengkap (tampilan rapi, output Markdown, buka di Neovim).
* Buat template man page yang lengkap + contoh `PKGBUILD` untuk memasang manual di Arch.
* Buatkan cheat-sheet `tldr` style untuk 50 perintah yang sering kamu pakai.

Aku akan mengikutkan **penjelasan kata-per-kata** untuk setiap file yang kubuat—langsung siap pakai di Arch + Neovim + Sway. Pilih salah satu dan aku buat sekarang (lengkap dengan penjelasan per baris).-->

