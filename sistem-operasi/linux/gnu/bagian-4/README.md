# GNU Coreutils — Dokumentasi lengkap (bab pertama dari *Komponen GNU di Linux*)

<!--
Siap. Berikut adalah bab lengkap tentang **GNU Coreutils**: pengertian, fungsi, bahasa implementasi, cara menemukan di sistem, langkah mengunduh/membangun/mengetes/install, contoh **PKGBUILD** untuk Arch, cara memodifikasi (keterampilan dan dependensi), praktik aman (verifikasi GPG / checksum), dan alternatif serta referensi. Setelah Anda membaca dan mengonfirmasi, saya akan melanjutkan ke komponen berikutnya (**Bash**).
> Sumber utama yang saya gunakan dan rekomendasikan untuk referensi dibagian paling penting: GNU Coreutils manual & upstream, repositori coreutils, dokumentasi Arch Linux (paket & Wiki), dan panduan build Linux From Scratch. ([gnu.org][1])
-->

## 1. Pengertian singkat — apa itu Coreutils

**GNU Coreutils** (core utilities) adalah kumpulan utilitas dasar yang diharapkan tersedia pada setiap sistem Unix-like: alat manipulasi file, teks, dan shell (mis. `ls`, `cp`, `mv`, `rm`, `cat`, `echo`, `chmod`, `chown`, `mkdir`, dll.). Coreutils merupakan gabungan dari paket-paket lama (fileutils, textutils, sh-utils) yang disatukan menjadi satu proyek. Implementasinya berorientasi POSIX namun menambahkan ekstensi GNU. ([gnu.org][1])

**Bahasa utama:** C (dengan skrip shell untuk beberapa helper).
**Lisensi:** GPL (umumnya `GPL-3.0-or-later` pada versi modern). ([GitHub][2])

---

## 2. Peran Coreutils dalam sistem

Coreutils adalah tulang punggung operasi sehari-hari pada terminal dan skrip shell. Banyak skrip, tool, dan proses sistem bergantung pada perilaku utilitas ini — sehingga penggantian atau modifikasi coreutils akan memengaruhi fungsi luas sistem. Di distribusi seperti Arch, paket `coreutils` termasuk dalam repo `core` dan menjadi paket vital. ([archlinux.org][3])

---

## 3. Menemukan Coreutils di sistem — pemeriksaan cepat

1. **Periksa versi utilitas** (cara paling cepat mengetahui apakah itu GNU):

```bash
ls --version
# contoh output: ls (GNU coreutils) 9.8
```

Jika output menyebut “GNU”, itu bagian dari GNU Coreutils. ([researchcodingclub.github.io][4])

2. **Periksa paket di Arch Linux:**

```bash
pacman -Qi coreutils        # informasi paket
pacman -Ql coreutils | head # daftar file yang dikemas
pacman -Qo /usr/bin/ls      # paket yang menyediakan file tertentu
```

Hal ini menegaskan paket yang terpasang dan versi spesifik pada sistem Arch. ([archlinux.org][3])

3. **Periksa file lisensi & manual:**

```bash
pacman -Ql coreutils | grep COPYING -i
man ls                      # baca manual bawaan
info coreutils              # manual info GNU coreutils (jika tersedia)
```

---

## 4. Mengunduh sumber Coreutils (upstream) & verifikasi

1. **Unduh tarball resmi dari GNU:**

```bash
wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.8.tar.xz
```

2. **Unduh signature (.sig) bila tersedia dan verifikasi dengan GPG:**

```bash
wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.8.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify coreutils-9.8.tar.xz.sig coreutils-9.8.tar.xz
```

Jika tanda tangan diverifikasi, Anda menerima bahwa tarball berasal dari pemilik kunci. Jika `.sig` tidak tersedia, unduh checksum resmi dan bandingkan SHA256. Praktik verifikasi ini penting untuk keamanan supply-chain. ([gnu.org][1])

---

## 5. Membangun Coreutils dari sumber — langkah praktis (standar)

> Catatan: untuk eksperimen di sistem produksi, gunakan chroot/container (mis. `arch-chroot`, `mock`, `pbuilder`) agar tidak merusak lingkungan host.

1. **Siapkan dependensi build (contoh untuk Arch/Debian):**

```bash
# Arch (umumnya base-devel sudah cukup)
sudo pacman -Syu --needed base-devel autoconf automake pkgconf gettext
# Debian/Ubuntu
sudo apt install build-essential autoconf automake pkg-config gettext
```

2. **Ekstraksi & konfigurasi:**

```bash
tar -xf coreutils-9.8.tar.xz
cd coreutils-9.8
./configure --prefix=/usr --sysconfdir=/etc
```

3. **Build & test:**

```bash
make -j$(nproc)
make check   # jalankan test-suite bila tersedia
```

4. **Install (jika ingin langsung ke sistem):**

```bash
sudo make install
```

**Rekomendasi packaging:** *jangan* langsung `sudo make install` untuk paket yang Anda kembangkan. Gunakan `make DESTDIR=/tmp/coreutils-pkg install` lalu bungkus ke paket (.pkg.tar.zst untuk Arch) atau gunakan `makepkg` (lihat bagian PKGBUILD di bawah). `make check` sangat disarankan sebelum install. Panduan serupa digunakan oleh Linux From Scratch. ([linuxfromscratch.org][5])

---

## 6. Membangun hanya sebagian utilitas (partial build)

Coreutils menyediakan Makefile yang memungkinkan membangun target spesifik. Secara umum langkahnya:

```bash
./configure
cd src
make ls    # contoh membangun hanya 'ls' (aturan bisa berbeda bergantung versi)
```

Namun beberapa utilitas bergantung pada library internal sehingga urutan build penting. Untuk eksperimen, baca `Makefile` dan target `subdir` yang ditentukan. (Diskusi di komunitas/StackExchange menunjukkan kemampuan ini tersedia meski tidak terdokumentasi secara eksplisit). ([Stack Overflow][6])

---

## 7. Membuat paket Arch (PKGBUILD) — contoh template sederhana

Berikut contoh **PKGBUILD** minimal yang dapat Anda simpan sebagai `PKGBUILD` untuk diuji pada `makepkg`. *Isi `sha256sums` dengan nilai yang benar sebelum build.*

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=coreutils-custom
pkgver=9.8
pkgrel=1
pkgdesc="GNU coreutils (custom build) - basic file, shell and text utilities"
arch=('x86_64')
url="https://www.gnu.org/software/coreutils/"
license=('GPL-3.0-or-later')
depends=('glibc' 'libacl' 'libattr' 'libcap' 'gmp' 'openssl')
source=("https://ftp.gnu.org/gnu/coreutils/coreutils-${pkgver}.tar.xz")
sha256sums=('PUT_ACTUAL_SHA256_HERE')

build() {
  cd "${srcdir}/coreutils-${pkgver}"
  ./configure --prefix=/usr --sysconfdir=/etc
  make
}

check() {
  cd "${srcdir}/coreutils-${pkgver}"
  make check || true   # jika test gagal, sesuaikan kebijakan Anda
}

package() {
  cd "${srcdir}/coreutils-${pkgver}"
  make DESTDIR="${pkgdir}" install
}
```

**Catatan PKGBUILD:**

* Pakai `makepkg -si` untuk membangun dan menginstal paket lokal.
* Pada paket resmi Arch, pemelihara melakukan patching, set opsi konfigurasi khusus, dan mengisi `depends` dengan hati-hati (coreutils biasanya bagian base系统 sehingga `depends` minimal). Lihat PKGBUILD resmi di repositori Arch untuk praktik lengkap. ([archlinux.org][3])

---

## 8. Men-debug build besar (masalah umum & solusi)

* **Missing headers/deps:** pastikan `base-devel` dan dependensi runtime (libacl, libattr, libcap, gmp, openssl) tersedia. Lihat `configure` output. ([archlinux.org][7])
* **Masalah locale / gettext:** pastikan `gettext` terinstall.
* **Test-suite gagal:** periksa `make check` output; beberapa test mungkin bergantung pada lingkungan (permissions, capabilities). Jalankan di chroot bersih untuk reproduksi. ([linuxfromscratch.org][5])

---

## 9. Memodifikasi Coreutils — apa yang perlu Anda kuasai

Untuk menyesuaikan atau menambah fitur pada coreutils Anda perlu:

1. **Bahasa & konsep**

   * **C**: mayoritas kode ditulis C; pahami standar C (GNU C), manajemen memori, pointer.
   * **POSIX API & sistem panggilan**: `open`, `read`, `write`, `stat`, `opendir`, `exec`, dsb.
   * **Format return code & konvensi CLI**: exit codes, parsing `getopt_long`, standar input/output. ([GitHub][2])

2. **Build system**

   * `autoconf`/`automake` (atau `configure` script yang disediakan), `make`, `pkg-config`.
   * Gnulib: coreutils sering memakai gnulib; pemahaman cara menghasilkan patch/menambah modul diperlukan.

3. **Pengujian & QA**

   * Unit / integration tests, `make check`, dan case coverage.
   * Jalankan perubahan di chroot/container sebelum diterapkan di sistem produksi.

4. **Proses kontribusi upstream**

   * Fork di repository coreutils (GitHub mirror atau repositori upstream), buat patch, jalankan test, ajukan patch sesuai pedoman maintainers (lihat `CONTRIBUTING` atau `README`). ([GitHub][2])

---

## 10. Alternatif & kompatibilitas

* **BusyBox**: kumpulan applet kecil untuk embedded, lebih hemat ruang, lisensi GPL-2.0.
* **Toybox / uutils (Rust)**: implementasi alternatif yang lebih kecil atau berbahasa lain (uutils coreutils, uutils-coreutils di Arch yang ditulis Rust). Penggantian coreutils sistem penuh perlu kehati-hatian karena kompatibilitas dan integrasi. Arch menyediakan paket `uutils-coreutils` sebagai opsi. ([Wikipedia][8])

---

## 11. Contoh perintah praktis & penggunaan (beberapa perintah inti)

* `ls --version` — verifikasi implementasi GNU. ([researchcodingclub.github.io][4])
* `install` dari coreutils (bukan package manager) — menyalin file dan set permissions.
* `cp -a src dst` — menyalin secara arsip (preserve attributes).
* `stat filename` — lihat metadata file.
* Gunakan `info coreutils` atau `man <command>` untuk opsi lengkap.

---

## 12. Referensi penting (sertakan di dokumen)

* GNU Coreutils manual (up-to-date manual & doc). ([gnu.org][1])
* GitHub mirror coreutils (source & issue tracker): `https://github.com/coreutils/coreutils`. ([GitHub][2])
* Halaman paket resmi Arch Linux — `core` paket coreutils (info paket, files, license). ([archlinux.org][3])
* Arch Wiki — artikel *Core utilities* dan panduan packaging. ([wiki.archlinux.org][9])
* Linux From Scratch — panduan build Coreutils (opsi configure & catatan build). ([linuxfromscratch.org][5])

---

## 13. Ringkasan tindakan untuk pelajar (checklist praktis)

1. Verifikasi `ls --version` untuk memastikan coreutils GNU. ([researchcodingclub.github.io][4])
2. Lihat paket dan file: `pacman -Qi coreutils` / `pacman -Qo /usr/bin/ls`. ([archlinux.org][3])
3. Unduh tarball dari ftp.gnu.org, verifikasi `.sig` atau checksum, ekstrak. ([gnu.org][1])
4. Build di chroot/container: `./configure && make && make check` → buat paket dengan PKGBUILD bila ingin instal terkontrol. ([linuxfromscratch.org][5])
5. Untuk modifikasi, pelajari C, POSIX API, autotools, dan cara kontribusi upstream. ([GitHub][2])

---

<!--
Jika Anda ingin, saya bisa:

* Menyimpan file ini sebagai `CLI/struktur-sistem/gnu/coreutils.md` dengan format Markdown lengkap (siap commit).
* Menyusun **PKGBUILD** yang lengkap dengan `sha256sums` terisi (saya dapat mengambil hash dari upstream sekarang jika Anda ingin) — perlu konfirmasi karena ini memerlukan pengunduhan sumber (saya bisa menempel template sekarang).
* Menyediakan contoh `git` workflow untuk kontribusi ke coreutils (fork → branch → patch → PR) & contoh perubahan `ls` sederhana sebagai latihan.
Apakah Anda **mengonfirmasi** agar saya melanjutkan ke **komponen berikutnya: GNU Bash** sekarang? Jika ya, saya akan membuat bab tentang Bash (fungsi, bahasa implementasi, cara build/modifikasi, contoh patch kecil, testing, PKGBUILD, dan perintah verifikasi).
-->

[1]: https://www.gnu.org/software/coreutils/manual/coreutils.html?utm_source=chatgpt.com "GNU Coreutils Manual"
[2]: https://github.com/coreutils/coreutils?utm_source=chatgpt.com "coreutils/coreutils: upstream mirror"
[3]: https://archlinux.org/packages/core/x86_64/coreutils/?utm_source=chatgpt.com "coreutils 9.8-2 (x86_64)"
[4]: https://researchcodingclub.github.io/slides/2017-07-21-coreutils.pdf?utm_source=chatgpt.com "GNU Coreutils - The Standard Command Line Toolbox"
[5]: https://www.linuxfromscratch.org/lfs/view/12.3-rc2/chapter06/coreutils.html?utm_source=chatgpt.com "6.5. Coreutils-9.6"
[6]: https://stackoverflow.com/questions/22005048/compile-specific-source-file-in-linux-coreutils-package?utm_source=chatgpt.com "compile specific source file in Linux coreutils package"
[7]: https://archlinux.org/packages/core/x86_64/coreutils/files/?utm_source=chatgpt.com "coreutils 9.8-2 (x86_64) - File List"
[8]: https://en.wikipedia.org/wiki/GNU_Core_Utilities?utm_source=chatgpt.com "GNU Core Utilities"
[9]: https://wiki.archlinux.org/title/Core_utilities?utm_source=chatgpt.com "Core utilities - ArchWiki"

# GNU Bash 

## Ringkasan singkat

**Bash** (Bourne Again SHell) adalah *shell* yang dikembangkan dalam proyek GNU — implementasi shell POSIX lengkap dengan fitur interaktif (history, job control, expansion, dll.). Bash ditulis terutama dalam **bahasa C** dan menjadi shell default di banyak distribusi Linux. Dokumen resmi dan manual instalasi tersedia dari situs GNU Bash. ([gnu.org][1])

---

## 1. Peran Bash dalam sistem

* Bash menyediakan antarmuka command-line interaktif dan lingkungan eksekusi skrip (shell scripting).
* Banyak skrip sistem, instalasi, dan dotfiles mengasumsikan perilaku Bash (builtin, ekspansi parameter, arrays, job control). Oleh karena itu perubahan pada Bash harus dilakukan hati-hati. ([tiswww.case.edu][2])

---

## 2. Bahasa implementasi & keterampilan yang dibutuhkan jika ingin memodifikasi

* **Bahasa utama**: C.
* **Keterampilan yang diperlukan**: pemahaman C (pointer, memory), POSIX API, toolchain GNU (`gcc`, `make`, `autoconf`), basic knowledge tentang `readline`/`ncurses` jika memodifikasi fitur interaktif, serta testing (`make check` / test-suite). Untuk kontribusi upstream: git workflow, patch format, dan pedoman maintainers. ([gnu.org][3])

---

## 3. Menemukan Bash di sistem — perintah praktis

* Versi dan identifikasi:

```bash
bash --version
# contoh output: GNU bash, version 5.3.0(1)-release (x86_64-pc-linux-gnu)
```

* Lokasi biner:

```bash
which bash        # /usr/bin/bash atau /bin/bash
type -a bash
```

* Paket (Arch):

```bash
pacman -Qi bash
pacman -Qo $(command -v bash)
```

* Periksa apakah `sh` menunjuk ke `bash`:

```bash
ls -l /bin/sh
# atau
readlink -f /bin/sh
```

Gunakan `chsh -s $(which bash)` untuk mengganti shell login default ke Bash (ingat: perlu logout/login). ([gnu.org][1])

---

## 4. Dependensi penting — Readline & terminfo (ncurses)

* Bash biasanya menggunakan **GNU Readline** untuk fitur editing interaktif (history, completion, emacs/vi mode). Readline adalah library GPL yang berimplikasi lisensi jika Anda menautkannya pada program yang didistribusikan. Anda bisa memeriksa apakah Bash tertaut ke readline dengan:

```bash
nm -D $(command -v bash) | grep -i readline || true
```

atau melihat dependensi paket di distribusi Anda (`ldd /usr/bin/bash`). ([tiswww.case.edu][4])

* `ncurses` / `libtinfo` sering diperlukan untuk dukungan terminal. Jika membangun dari source, pasang paket development (contoh: `libreadline-dev`, `ncurses-devel`) sebelum konfigurasi. ([Ask Ubuntu][5])

---

## 5. Mengunduh source Bash & verifikasi

1. **Unduh tarball resmi**:

```bash
wget https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz
```

(versi berubah dari waktu ke waktu — gunakan halaman rilis resmi atau mirror GNU). ([lwn.net][6])

2. **Verifikasi**: jika tersedia, unduh signature `.sig` dan verifikasi dengan `gpg`:

```bash
wget https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify bash-5.3.tar.gz.sig bash-5.3.tar.gz
```

Jika `.sig` tidak tersedia, verifikasi checksum SHA256 dari sumber resmi. Praktik ini membantu supply-chain security. ([gnu.org][3])

---

## 6. Membangun Bash dari sumber — langkah standar

> *Saran:* uji build dalam chroot/container (mis. `arch-chroot`, `systemd-nspawn`, atau LXC) untuk menghindari mengganti shell sistem utama sebelum Anda yakin.

1. **Siapkan build-env** (contoh Arch / Debian):

```bash
# Arch
sudo pacman -Syu --needed base-devel ncurses readline texinfo

# Debian/Ubuntu
sudo apt update
sudo apt install build-essential bison gettext texinfo libncurses-dev libreadline-dev
```

2. **Ekstrak & konfigurasi**:

```bash
tar -xf bash-5.3.tar.gz
cd bash-5.3
./configure --prefix=/usr --sysconfdir=/etc
# Lihat opsi konfigurasi dengan ./configure --help
```

`configure` mengenali banyak opsi `--enable-` dan `--with-` (opsional features). Periksa manual instalasi untuk daftar lengkap opsi konfigurasi. ([tiswww.case.edu][7])

3. **Build & test**:

```bash
make -j$(nproc)
make check   # jalankan test-suite bila tersedia
```

4. **Install (pilihan)**:

```bash
sudo make install
```

Atau agar terkontrol: `make DESTDIR=/tmp/bash-pkg install` dan bungkus menjadi paket distribusi (lihat PKGBUILD di bawah). ([gnu.org][3])

---

## 7. Opsi konfigurasi penting (pilihan)

* `--with-readline` / `--without-readline` (kontrol pemakaian readline).
* `--enable-largefile` (jika butuh support file besar di platform lama).
* `--with-bash-malloc` (gunakan malloc bawaan bash, kadang berguna pada sistem tua).
  Gunakan `./configure --help` dan dokumentasi `INSTALL`/`README` untuk daftar lengkap. Opsi-opsi ini memengaruhi fitur interaktif, portabilitas, dan linking library. ([tiswww.case.edu][7])

---

## 8. Struktur source relevant untuk modifikasi

* Direktori `builtins/` berisi definisi builtin shell (def-files yang dibangun menjadi `builtins.c`). Untuk melihat dokumentasi help builtin yang ada, lihat file `builtins/*.def`. Ini adalah tempat logis bila Anda ingin menambah builtin baru. ([Unix & Linux Stack Exchange][8])

* File utama implementasi ada di root source (`execute_cmd.c`, `parse.y`/`shell.c` bergantung versi) dan generator build (mkbuiltins) — pelajari `Makefile.in` dan `INSTALL` untuk alur pembuatan. Gunakan repo upstream (savannah/git mirror atau GitHub mirrors) untuk mendapatkan tree yang paling mutakhir. ([GitHub][9])

---

## 9. Contoh: menambahkan builtin sederhana (konsep)

Langkah ringkas (konsep, bukan patch penuh):

1. Tambah definisi di `builtins/` (mis. `mycmd.def`) dengan format definisi builtin.
2. Jalankan `make` untuk membangun `mkbuiltins` yang menggabungkan definisi ke `builtins.c`.
3. Kompilasi dan jalankan `make check`.
4. Ikuti pedoman coding style dan testing sebelum kirim patch.

Untuk latihan, buat perubahan kecil (mis. ubah pesan `help` atau tweak implementasi echo) lalu jalankan `make` dan test di container. Artikel komunitas dan contoh proyek (tutorial membuat builtin) membantu dalam langkah praktis. ([mbuki-mvuki.org][10])

---

## 10. Contoh PKGBUILD untuk Arch (template)

Simpan file ini sebagai `PKGBUILD` pada direktori kerja, isi `sha256sums` sesuai tarball upstream.

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=bash-custom
pkgver=5.3
pkgrel=1
pkgdesc="GNU Bourne Again SHell (custom build)"
arch=('x86_64')
url="https://www.gnu.org/software/bash/"
license=('GPL-3.0-or-later')
depends=('glibc' 'ncurses' 'readline')
makedepends=('pkgconf' 'autoconf' 'automake' 'texinfo')
source=("https://ftp.gnu.org/gnu/bash/bash-${pkgver}.tar.gz")
sha256sums=('PUT_SHA256_HERE')

build() {
  cd "${srcdir}/bash-${pkgver}"
  ./configure --prefix=/usr --sysconfdir=/etc
  make
}

check() {
  cd "${srcdir}/bash-${pkgver}"
  make check || true
}

package() {
  cd "${srcdir}/bash-${pkgver}"
  make DESTDIR="${pkgdir}" install
}
```

* Jalankan `makepkg -si` untuk membangun dan menginstal paket lokal.
* Untuk kontribusi resmi, lihat pedoman Arch packaging. ([wiki.archlinux.org][11])

---

## 11. Testing & QA

* **Unit / integration tests:** `make check` bila tersedia; baca output log test untuk failure.
* **Smoke test**: jalankan shell interaktif dari build tree:

```bash
./bash --noprofile --norc -i
# coba builtins penting: echo, cd, job control, arrays
```

* **Regression/security tests:** perhatikan CVE lama (mis. Shellshock) dan pelajari cara publik patch dan mitigasi. Selalu gunakan versi patched upstream untuk produksi. ([tuanpembual.wordpress.com][12])

---

## 12. Keamanan dan praktik baik

* Jangan mengganti `bash` sistem secara langsung di host produksi — gunakan container/chroot untuk menguji.
* Verifikasi tarball upstream (GPG/checksum).
* Buat paket (PKGBUILD / deb-src) sehingga perubahan dapat di-rollback dan dilacak via package manager.
* Jalankan `make check` sebelum instal.
* Pantau mailing list dan advisories upstream (bug-bash / bash-announce). ([lists.gnu.org][13])

---

## 13. Alat dan referensi cepat (untuk disertakan di dokumen)

* GNU Bash official: [https://www.gnu.org/software/bash/](https://www.gnu.org/software/bash/) ([gnu.org][1])
* Bash Reference Manual — Basic installation & optional features. ([gnu.org][3])
* GNU Readline home (license & docs). ([tiswww.case.edu][4])
* Arch PKGBUILD / packaging guide. ([wiki.archlinux.org][11])
* Repositori source / mirrors: savannah git / GitHub mirrors. ([GitHub][9])

---

## 14. Rangkuman & checklist untuk pelajar (actionable)

1. Cek versi & lokasi: `bash --version` / `which bash`.
2. Siapkan environment: install `build-essential` / `base-devel` + `libreadline-dev` + `libncurses-dev`.
3. Unduh tarball resmi & verifikasi GPG/checksum.
4. `./configure --prefix=/usr && make && make check`. Jalankan build di chroot/container.
5. Jika berhasil, bungkus ke paket (PKGBUILD / deb) dan ujicoba pada VM.
6. Untuk modifikasi, pelajari `builtins/` di source tree, buat perubahan kecil, jalankan `make` dan test terisolasi.

[1]: https://www.gnu.org/software/bash/ "Bash - GNU Project - Free Software Foundation"
[2]: https://tiswww.case.edu/php/chet/bash/bashtop.html "The GNU Bourne-Again Shell"
[3]: https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html "Basic Installation (Bash Reference Manual)"
[4]: https://tiswww.case.edu/php/chet/readline/rltop.html?utm_source=chatgpt.com "The GNU Readline Library"
[5]: https://askubuntu.com/questions/194523/how-do-i-install-gnu-readline "How do I install GNU Readline?"
[6]: https://lwn.net/Articles/1029079/ "Bash-5.3-release available"
[7]: https://tiswww.case.edu/php/chet/bash/INSTALL "Basic Installation"
[8]: https://unix.stackexchange.com/questions/427326/where-does-bashs-help-builtin-source-its-documentation/427331 "Where does bash's 'help' builtin source its documentation?"
[9]: https://github.com/gitGNU/gnu_bash?utm_source=chatgpt.com "gitGNU/gnu_bash"
[10]: https://mbuki-mvuki.org/posts/2021-07-12-writing-a-bash-builtin-in-c-to-parse-ini-configs/ "Writing a Bash Builtin in C to Parse INI Configs"
[11]: https://wiki.archlinux.org/title/PKGBUILD?utm_source=chatgpt.com "PKGBUILD - ArchWiki"
[12]: https://tuanpembual.wordpress.com/2014/09/25/cve-2014-6271-bash-vulnerability-dan-bagaimana-menanganinya/ "CVE-2014-6271 Bash Vulnerability dan Bagaimana ..."
[13]: https://lists.gnu.org/archive/html/info-gnu/2022-09/msg00012.html "Bash-5.2 Release available"
<!--
Baik, kita lanjut ke bab berikutnya: **GNU GCC (GNU Compiler Collection)** — ini salah satu komponen paling besar dan kompleks di seluruh proyek GNU. Dokumen ini saya tulis agar pembelajar bukan hanya memahami fungsinya sebagai *compiler*, tetapi juga mampu menelusuri struktur kodenya, membangun dan memodifikasi GCC sendiri, serta memahami posisinya dalam *toolchain* GNU/Linux.

Setelah bab ini selesai, saya akan berhenti dulu menunggu konfirmasi Anda sebelum masuk ke **GNU Make**.

-->

# GNU GCC 

## 1. Pengantar singkat

**GCC (GNU Compiler Collection)** adalah kumpulan *compiler front-end dan back-end* yang mendukung banyak bahasa pemrograman: C, C++, Fortran, Ada, Go, D, dan lainnya. Ia merupakan komponen inti dalam *GNU Toolchain* dan digunakan untuk membangun kernel, pustaka sistem, serta sebagian besar perangkat lunak di Linux.

GCC ditulis dalam **bahasa C dan C++**, dengan sebagian kecil kode menggunakan generator dan skrip Python/Perl untuk proses build dan tes otomatis. Lisensinya adalah **GPL-3.0-or-later**, sementara library yang dihasilkannya (libgcc, libstdc++) dilisensikan di bawah **LGPL** agar kompatibel dengan proyek non-GPL.

---

## 2. Peran GCC dalam sistem GNU/Linux

GCC adalah pusat dari seluruh proses *compilation* pada sistem berbasis GNU. Ia bertugas:

* Mengonversi kode sumber (C, C++, dll.) menjadi kode mesin.
* Menghubungkan hasil kompilasi dengan *libraries* menggunakan **Binutils** (linker `ld`, assembler `as`).
* Digunakan secara tidak langsung oleh *make* saat membangun proyek.

Tanpa GCC, sistem tidak dapat membangun kernel, pustaka, maupun utilitas dasar — menjadikannya fondasi semua distribusi.

---

## 3. Komponen utama GCC

* **Frontend**: parser dan analyzer untuk bahasa tertentu (mis. `gcc/c/`, `gcc/cp/` untuk C dan C++).
* **Middle-end (Optimizer)**: menganalisis dan mengoptimalkan representasi internal (GIMPLE, RTL).
* **Backend (Code Generator)**: menghasilkan kode assembly untuk arsitektur target (x86, ARM, RISC-V, dll.).
* **Libgcc & libstdc++**: pustaka runtime dan implementasi STL.
* **GCC Driver** (`gcc`): antarmuka CLI yang memanggil *subtool* seperti `cc1`, `as`, `ld`.

---

## 4. Menemukan GCC di sistem

* Versi dan lokasi:

```bash
gcc --version
which gcc
```

* Periksa paket:

```bash
pacman -Qi gcc         # Arch
apt show gcc           # Debian/Ubuntu
```

* Cek path compiler lain (cross-compiler):

```bash
ls /usr/bin | grep gcc
```

Anda mungkin menemukan varian seperti `arm-none-eabi-gcc`, `riscv64-linux-gnu-gcc`.

---

## 5. Mengunduh source GCC (upstream)

```bash
wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz
wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify gcc-14.2.0.tar.xz.sig gcc-14.2.0.tar.xz
```

Gunakan versi terbaru yang stabil (mis. GCC 14.x atau 13.x).

---

## 6. Dependensi build

Untuk membangun GCC dari sumber, Anda wajib memiliki:

* **GMP**, **MPFR**, **MPC**, **ISL**: pustaka matematika untuk optimisasi numerik.
* **Binutils**: assembler & linker.
* **Zlib**, **libelf**, **texinfo**, **flex**, **bison**, **make**, **perl**, **python**.

Di Arch:

```bash
sudo pacman -Syu --needed base-devel gmp mpfr libmpc isl zlib texinfo
```

Di Debian:

```bash
sudo apt install build-essential gmp-dev libmpfr-dev libmpc-dev flex bison zlib1g-dev texinfo
```

---

## 7. Membangun GCC dari sumber (native build)

> Catatan: selalu lakukan build di direktori terpisah dari source (`out-of-tree` build).

```bash
tar -xf gcc-14.2.0.tar.xz
mkdir gcc-build && cd gcc-build
../gcc-14.2.0/configure --prefix=/usr \
  --enable-languages=c,c++ \
  --enable-bootstrap \
  --enable-lto \
  --with-system-zlib \
  --disable-multilib
make -j$(nproc)
make check
sudo make install
```

Penjelasan opsi penting:

* `--enable-languages`: menentukan bahasa yang akan dikompilasi (mis. `c,c++,fortran`).
* `--enable-bootstrap`: melakukan *3-stage compilation* untuk memastikan compiler stabil.
* `--disable-multilib`: mematikan dukungan 32-bit di sistem 64-bit (opsional).

---

## 8. Verifikasi hasil build

```bash
gcc -v
gcc -Q --help=target | head
ldd $(which gcc)
```

Gunakan `make check` untuk menjalankan *testsuite* (ribuan pengujian otomatis). Jika Anda menggunakan container ringan, bisa menonaktifkan beberapa tes panjang dengan `make -k check`.

---

## 9. Cross-Compilation (GCC lintas arsitektur)

Salah satu kekuatan utama GCC adalah kemampuan **cross-compiling** — menyusun program untuk arsitektur lain (mis. ARM di x86_64).
Langkah utama:

1. Bangun **Binutils** untuk target tertentu.
2. Bangun **GCC (stage 1)** hanya dengan `--enable-languages=c` dan `--without-headers`.
3. Gunakan hasil itu untuk membangun `libgcc` & `libstdc++` target.
   Panduan terperinci tersedia di *Cross-LFS* atau *OSDev Wiki*.

---

## 10. Membuat paket Arch (PKGBUILD sederhana)

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=gcc-custom
pkgver=14.2.0
pkgrel=1
pkgdesc="GNU Compiler Collection (custom build)"
arch=('x86_64')
url="https://gcc.gnu.org/"
license=('GPL-3.0-or-later' 'LGPL-3.0-or-later')
depends=('glibc' 'zlib' 'libmpc' 'mpfr' 'gmp')
makedepends=('texinfo' 'isl')
source=("https://ftp.gnu.org/gnu/gcc/gcc-${pkgver}/gcc-${pkgver}.tar.xz")
sha256sums=('PUT_SHA256_HERE')

build() {
  mkdir -p "${srcdir}/gcc-build"
  cd "${srcdir}/gcc-build"
  ../gcc-${pkgver}/configure --prefix=/usr --enable-languages=c,c++ \
    --disable-multilib --enable-lto --with-system-zlib
  make -j$(nproc)
}

check() {
  cd "${srcdir}/gcc-build"
  make -k check || true
}

package() {
  cd "${srcdir}/gcc-build"
  make DESTDIR="${pkgdir}" install
}
```

Gunakan `makepkg -si` untuk membangun paket dan instal ke sistem lokal.

---

## 11. Memodifikasi GCC — apa yang perlu Anda kuasai

Untuk benar-benar menyentuh bagian dalam GCC, pelajari:

* **Struktur front-end** (parser `.c` / `.cc` di `gcc/c/` dan `gcc/cp/`).
* **Intermediate Representation (IR)**: GIMPLE dan RTL (Register Transfer Language).
* **Code generation**: direktori `gcc/config/<arch>/`.
* **Plugins**: Anda bisa menulis plugin GCC dalam C untuk menambah analisis atau optimisasi tanpa memodifikasi kode inti.

Contoh kecil menulis plugin:

```c
#include "gcc-plugin.h"
int plugin_is_GPL_compatible;
int plugin_init(struct plugin_name_args *info, struct plugin_gcc_version *ver) {
    printf("Plugin GCC sederhana aktif!\n");
    return 0;
}
```

Kompilasi plugin dengan:

```bash
gcc -fPIC -shared myplugin.c -o myplugin.so -I$(gcc -print-file-name=plugin)
gcc -fplugin=./myplugin.so hello.c
```

---

## 12. Testing & QA

GCC memiliki test-suite besar (DejaGNU). Jalankan:

```bash
make -k check RUNTESTFLAGS="--target_board=unix"
```

Hasil log berada di `gcc/testsuite/`. Jika ingin analisis cepat, gunakan:

```bash
grep -A3 'FAIL:' gcc/testsuite/*.log
```

Gagal minor sering terjadi tergantung arsitektur dan konfigurasi.

---

## 13. Praktik aman & verifikasi integritas

* Selalu verifikasi tarball (`.sig` / checksum SHA256).
* Lakukan build di *clean environment* (chroot atau container).
* Jangan ganti compiler sistem secara langsung — simpan di `/opt/gcc-custom/`.
* Tambahkan path ke `PATH`:

```bash
export PATH=/opt/gcc-custom/bin:$PATH
```

---

## 14. Referensi utama

* **Situs resmi GCC:** [https://gcc.gnu.org/](https://gcc.gnu.org/)
* **GNU GCC Manual & Wiki:** dokumentasi penuh untuk opsi, plugin, dan IR.
* **Linux From Scratch:** panduan membangun GCC.
* **Arch PKGBUILD resmi untuk gcc.**
* **GCC Internals Manual:** untuk modifikasi compiler.

---

## 15. Checklist ringkas untuk pelajar

1. `gcc --version` → pastikan versi GNU.
2. Unduh & verifikasi tarball dari `ftp.gnu.org`.
3. Pasang dependensi `gmp`, `mpfr`, `mpc`, `isl`.
4. Build di direktori terpisah (`gcc-build`).
5. Jalankan `make check`.
6. Instal ke `/usr/local` atau bungkus ke paket.
7. Pelajari plugin sederhana untuk memahami API internal GCC.

---

Sempurna — kita lanjut ke bab **GNU Make**, salah satu alat terpenting dalam *GNU Build System*. Ini adalah program yang tampak sederhana namun sesungguhnya merupakan mesin otomatisasi yang sangat kuat; hampir semua proyek open source bergantung padanya secara langsung maupun tidak langsung.

---

# GNU Make — Dokumentasi Lengkap

## 1. Gambaran umum

**GNU Make** adalah utilitas yang secara otomatis membangun program dan file lain dari kode sumber dengan membaca *Makefile* — sebuah file yang berisi aturan dependensi dan perintah.
Make ditulis dalam **bahasa C**, berlisensi **GPL-3.0-or-later**, dan menjadi bagian resmi dari proyek GNU.

---

## 2. Fungsi dalam ekosistem GNU

Make berperan sebagai *scheduler dan automator* di toolchain GNU. Ia tidak melakukan kompilasi sendiri, melainkan:

* Menentukan urutan eksekusi perintah (biasanya memanggil GCC atau Clang).
* Memeriksa *timestamp* dan dependensi antar-file agar hanya membangun bagian yang berubah.
* Digunakan oleh Autotools (`configure` → menghasilkan Makefile).

Tanpa Make, pengembang harus menjalankan `gcc` untuk setiap file secara manual — sehingga produktivitas akan menurun drastis.

---

## 3. Menemukan Make di sistem

* **Periksa versi dan lokasi:**

```bash
make --version
which make
```

Contoh output:

```
GNU Make 4.4.1
Built for x86_64-pc-linux-gnu
```

* **Periksa paket:**

```bash
pacman -Qi make      # Arch
apt show make        # Debian/Ubuntu
```

---

## 4. Unduh sumber resmi GNU Make

```bash
wget https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz
wget https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify make-4.4.1.tar.gz.sig make-4.4.1.tar.gz
```

Versi stabil terbaru dapat dilihat di [https://ftp.gnu.org/gnu/make/](https://ftp.gnu.org/gnu/make/).

---

## 5. Dependensi build

GNU Make relatif ringan.
Di Arch:

```bash
sudo pacman -Syu --needed base-devel texinfo
```

Di Debian:

```bash
sudo apt install build-essential texinfo
```

---

## 6. Membangun GNU Make dari sumber

> Lakukan build di direktori terpisah untuk menjaga kebersihan source tree.

```bash
tar -xf make-4.4.1.tar.gz
cd make-4.4.1
./configure --prefix=/usr
make -j$(nproc)
make check
sudo make install
```

Jika ingin build statis:

```bash
./configure --prefix=/usr LDFLAGS=-static
```

---

## 7. Struktur internal singkat

* `src/` — berisi implementasi inti `main.c`, `read.c` (parser Makefile), `job.c` (eksekusi perintah paralel).
* `job.c` menangani *parallel build* (`-j` option).
* `rule.c` mengelola dependensi dan evaluasi ekspresi.
* `variable.c` mengelola variabel dan ekspansi (`$(VAR)` dan fungsi builtin seperti `$(shell ...)`).
* Build system-nya menggunakan autotools (autoconf, automake).

---

## 8. Contoh `PKGBUILD` sederhana untuk Arch

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=make-custom
pkgver=4.4.1
pkgrel=1
pkgdesc="GNU Make - custom build"
arch=('x86_64')
url="https://www.gnu.org/software/make/"
license=('GPL-3.0-or-later')
depends=('glibc')
makedepends=('texinfo')
source=("https://ftp.gnu.org/gnu/make/make-${pkgver}.tar.gz")
sha256sums=('PUT_SHA256_HERE')

build() {
  cd "${srcdir}/make-${pkgver}"
  ./configure --prefix=/usr
  make
}

check() {
  cd "${srcdir}/make-${pkgver}"
  make check || true
}

package() {
  cd "${srcdir}/make-${pkgver}"
  make DESTDIR="${pkgdir}" install
}
```

Build dengan `makepkg -si`.

---

## 9. Memodifikasi GNU Make

Untuk memodifikasi perilaku Make, pelajari:

* **Parsing Makefile** (fungsi di `read.c`).
* **Eksekusi paralel** (`job.c`).
* **Evaluasi variabel & ekspansi fungsi** (`variable.c`, `function.c`).
  Cukup pahami C dan dasar struktur data seperti *linked list* dan *hash table* karena Make menggunakan keduanya secara intensif.

---

## 10. Praktik aman

* Jangan ganti `make` sistem langsung di `/usr/bin` tanpa backup — gunakan `/usr/local/bin` atau container.
* Gunakan `make check` sebelum instal.
* Pastikan PATH Anda memprioritaskan versi baru jika Anda uji coba build.

```bash
export PATH=/usr/local/bin:$PATH
```

---

## 11. Penggunaan praktis

* Jalankan `make -j$(nproc)` untuk *parallel build*.
* Debug rule:

```bash
make -n       # tampilkan perintah tanpa menjalankan
make -d       # tampilkan debug parsing Makefile
```

* Tentukan target tertentu:

```bash
make clean all
```

---

## 12. Referensi utama

* Situs resmi GNU Make: [https://www.gnu.org/software/make/](https://www.gnu.org/software/make/)
* Manual resmi GNU Make & opsi build.
* PKGBUILD resmi Arch (repo `core/make`).
* Linux From Scratch — panduan build GNU Make.

---

## 13. Checklist pelajar

1. Jalankan `make --version` untuk verifikasi GNU.
2. Unduh & verifikasi `make-x.y.tar.gz`.
3. Build dengan `./configure && make && make check`.
4. Instal ke `/usr/local` atau bungkus dengan PKGBUILD.
5. Eksperimen dengan `make -d` untuk memahami proses parsing.

<!--
Jika bagian ini sudah jelas, saya akan lanjutkan ke komponen berikutnya: **GNU GDB (GNU Debugger)** — alat debugging utama dalam ekosistem GNU/Linux, sekaligus salah satu yang paling penting untuk pengembangan sistem.
Apakah Anda ingin saya lanjut ke **GDB** sekarang?

Baik — kita lanjut ke **GNU GDB (GNU Debugger)**, alat utama dalam ekosistem GNU untuk menganalisis dan men-debug program di tingkat mesin maupun sumber. Bab ini dirancang agar Anda memahami posisi GDB dalam toolchain, mampu membangun, menyesuaikan, dan menggunakannya secara mandiri, serta mengetahui cara mengintegrasikannya dengan IDE maupun terminal TUI seperti Neovim atau TUI GDB.
-->

# GNU GDB

## 1. Pengantar singkat

**GNU Debugger (GDB)** adalah debugger lintas-platform yang digunakan untuk menganalisis perilaku program pada tingkat sumber dan mesin. Ia mendukung berbagai bahasa (C, C++, Fortran, Ada, Rust, Go) dan arsitektur CPU (x86, ARM, RISC-V, MIPS, PowerPC, dll.).
Dikembangkan oleh proyek GNU, ditulis dalam **bahasa C dan C++**, dan dilisensikan di bawah **GPL-3.0-or-later**.

---

## 2. Fungsi dan posisi GDB dalam ekosistem GNU

GDB berperan sebagai **komponen debugging utama** dalam GNU Toolchain, berdampingan dengan:

* **GCC**: mengompilasi program dengan simbol debug (`-g` flag).
* **Binutils**: menyediakan *objdump*, *readelf*, dan *as* untuk analisis biner.
* **Make**: menjalankan target debugging otomatis.

Secara sederhana: *GCC membangun, GDB membedah.*

---

## 3. Menemukan GDB di sistem

* Versi & lokasi:

```bash
gdb --version
which gdb
```

Contoh output:

```
GNU gdb (GDB) 14.1
Copyright (C) 2024 Free Software Foundation, Inc.
```

* Periksa paket:

```bash
pacman -Qi gdb      # Arch
apt show gdb        # Debian/Ubuntu
```

---

## 4. Unduh sumber resmi

```bash
wget https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz
wget https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify gdb-14.2.tar.xz.sig gdb-14.2.tar.xz
```

Anda juga bisa menggunakan mirror di [https://sourceware.org/git/?p=binutils-gdb.git](https://sourceware.org/git/?p=binutils-gdb.git).

---

## 5. Dependensi build

* **Wajib**: `gcc`, `make`, `texinfo`, `zlib`, `readline`, `expat`.
* **Opsional**: `python` (untuk scripting), `guile` (ekstensi Scheme), `ncurses` (TUI), `libipt` (Intel Processor Trace).

Di Arch:

```bash
sudo pacman -Syu --needed base-devel python guile ncurses expat texinfo
```

Di Debian:

```bash
sudo apt install build-essential python3-dev guile-3.0-dev libexpat1-dev libncurses-dev texinfo
```

---

## 6. Membangun GDB dari sumber

> Seperti GCC, disarankan membangun di direktori terpisah.

```bash
tar -xf gdb-14.2.tar.xz
mkdir gdb-build && cd gdb-build
../gdb-14.2/configure --prefix=/usr \
  --with-system-readline \
  --with-python=/usr/bin/python3 \
  --enable-tui \
  --enable-targets=all
make -j$(nproc)
make check
sudo make install
```

---

## 7. Struktur source utama

* `gdb/` — kode utama debugger.
* `bfd/` — *Binary File Descriptor library* (abstraksi format biner, ELF, COFF).
* `opcodes/` — deskripsi opcode arsitektur.
* `sim/` — simulator CPU (beberapa target).
* `python/` — binding Python untuk scripting (mis. plugin atau UI).

---

## 8. Penggunaan dasar (CLI)

```bash
gcc -g hello.c -o hello
gdb ./hello
```

Contoh sesi GDB:

```
(gdb) break main
(gdb) run
(gdb) print x
(gdb) next
(gdb) step
(gdb) continue
(gdb) quit
```

* `-g` pada GCC penting agar GDB dapat membaca simbol debug.
* Simpan konfigurasi di `~/.gdbinit` untuk otomatisasi (mis. `set pagination off`, `set print pretty on`).

---

## 9. Mode TUI (Text User Interface)

GDB menyediakan mode semi-grafis berbasis terminal:

```bash
gdb -tui ./program
```

* Gunakan `Ctrl+x a` untuk mengaktifkan/menonaktifkan tampilan TUI.
* Integrasi bagus dengan **Neovim** melalui plugin seperti `vimspector` atau `nvim-dap`.

Untuk integrasi manual:

```bash
:term gdb -q ./a.out
```

Lalu kontrol langsung di dalam buffer terminal Neovim.

---

## 10. Scripting dengan Python

GDB memiliki API Python bawaan:

```python
class HelloCmd(gdb.Command):
    def __init__(self):
        super(HelloCmd, self).__init__("hello", gdb.COMMAND_USER)
    def invoke(self, arg, from_tty):
        print("Halo dari GDB Python!")

HelloCmd()
```

Simpan sebagai `~/.gdbinit` atau `~/.gdb/hello.py` lalu jalankan `source hello.py` di sesi GDB.

---

## 11. Membuat paket Arch (PKGBUILD contoh)

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=gdb-custom
pkgver=14.2
pkgrel=1
pkgdesc="GNU Debugger (custom build)"
arch=('x86_64')
url="https://www.gnu.org/software/gdb/"
license=('GPL-3.0-or-later')
depends=('glibc' 'readline' 'expat' 'python' 'ncurses')
makedepends=('texinfo' 'guile')
source=("https://ftp.gnu.org/gnu/gdb/gdb-${pkgver}.tar.xz")
sha256sums=('PUT_SHA256_HERE')

build() {
  mkdir -p "${srcdir}/build"
  cd "${srcdir}/build"
  ../gdb-${pkgver}/configure --prefix=/usr --with-system-readline --with-python=/usr/bin/python3 --enable-tui
  make
}

check() {
  cd "${srcdir}/build"
  make -k check || true
}

package() {
  cd "${srcdir}/build"
  make DESTDIR="${pkgdir}" install
}
```

Build: `makepkg -si`.

---

## 12. Modifikasi GDB

Untuk memodifikasi atau memperluas GDB:

* **Bahasa**: C/C++ dengan Python sebagai ekstensi scripting.
* **Bidang umum modifikasi**:

  * Menambah *command internal* (`gdb/cli/cli-cmds.c`).
  * Menambah backend target baru (`gdb/arch/`).
  * Integrasi debugger eksternal (via Remote Serial Protocol).
* **Remote debugging**: gunakan `gdbserver` pada target dan `target remote :port` di host.

---

## 13. Praktik aman & debugging lanjutan

* Gunakan build GDB tersendiri di `/usr/local/bin` agar tidak mengganggu versi sistem.
* Jalankan `make check` untuk validasi build.
* Debug kernel atau remote target hanya dalam lingkungan aman (VM, QEMU, atau hardware dummy).
* Kombinasikan GDB dengan `valgrind` untuk deteksi memory leak.

---

## 14. Referensi utama

* **GNU GDB** — [https://www.gnu.org/software/gdb/](https://www.gnu.org/software/gdb/)
* **GDB Manual & Python API documentation**
* **Sourceware.org GDB Git Repository**
* **Arch PKGBUILD GDB (core repository)**
* **Linux From Scratch — GDB build chapter**

---

## 15. Checklist untuk pelajar

1. Verifikasi GDB dengan `gdb --version`.
2. Bangun dari source dengan `--enable-tui` dan `--with-python`.
3. Jalankan `gdb -tui ./program`.
4. Pelajari `~/.gdbinit` dan buat command Python sendiri.
5. Integrasikan GDB ke Neovim TUI (via `:term` atau `nvim-dap`).
6. Eksperimen dengan *remote debugging* menggunakan `gdbserver`.

<!--
Jika Anda sudah siap, saya akan lanjutkan ke komponen terakhir dalam daftar utama **Komponen GNU di Linux**, yaitu **GNU Binutils** — alat penting yang bekerja berdampingan dengan GCC dan GDB untuk proses linking, assembling, serta inspeksi biner.
Apakah Anda ingin saya lanjut ke **GNU Binutils** sekarang?

Baik, kita lanjut ke bagian terakhir dari kelompok **Komponen GNU di Linux**, yaitu **GNU Binutils** — fondasi penting bagi proses kompilasi, linking, dan manipulasi berkas biner. Jika GCC adalah otak dan GDB adalah indera pengamatan, maka Binutils adalah tangan yang memahat hasil akhirnya di tingkat mesin.

---
-->
# GNU Binutils

## 1. Pengantar singkat

**GNU Binutils (Binary Utilities)** adalah kumpulan alat untuk memproses berkas biner seperti object files (`.o`), libraries (`.a`, `.so`), dan executable (`ELF`, `COFF`, `PE`).
Dikembangkan oleh **Free Software Foundation (FSF)** dalam proyek GNU, ditulis dalam **bahasa C**, dan berlisensi **GPL-3.0-or-later**.

Komponen Binutils juga menjadi fondasi bagi banyak *compiler toolchain*, termasuk **GCC**, **LLVM**, dan **embedded cross-compilers**.

---

## 2. Peran Binutils dalam GNU/Linux

Binutils berfungsi sebagai jembatan antara hasil kompilasi (object code) dan executable akhir.
Peran utamanya:

* Mengonversi *object code* menjadi *binary executable*.
* Menganalisis isi berkas biner (ELF header, simbol, section).
* Menyediakan *assembler* (`as`) dan *linker* (`ld`) yang digunakan oleh GCC.
* Menyediakan alat bantu debugging (`objdump`, `readelf`, `nm`, `strings`).

Alur sederhananya:

```
source.c → (GCC) → main.o → (ld) → main → (objdump/readelf) → analisis
```

---

## 3. Komponen utama Binutils

| Alat      | Fungsi Utama                                           | Contoh Penggunaan               |
| --------- | ------------------------------------------------------ | ------------------------------- |
| `as`      | GNU Assembler                                          | `as -o file.o file.s`           |
| `ld`      | GNU Linker                                             | `ld -o output file.o`           |
| `objdump` | Menampilkan isi berkas biner dan disassembly           | `objdump -d main`               |
| `readelf` | Membaca header ELF                                     | `readelf -h main`               |
| `nm`      | Menampilkan simbol (fungsi/variabel) dari berkas biner | `nm main.o`                     |
| `strings` | Mengekstrak teks ASCII dari biner                      | `strings main`                  |
| `ar`      | Mengarsipkan object file menjadi library (`.a`)        | `ar rcs libx.a file1.o file2.o` |
| `ranlib`  | Mengindeks simbol library statis                       | `ranlib libx.a`                 |

Semua alat ini biasanya terinstal otomatis saat Anda memasang paket `binutils` di distribusi Linux.

---

## 4. Menemukan Binutils di sistem

```bash
ld --version
as --version
which ld
```

Contoh output:

```
GNU ld (GNU Binutils) 2.43.1
```

Periksa paket:

```bash
pacman -Qi binutils      # Arch
apt show binutils        # Debian/Ubuntu
```

---

## 5. Unduh sumber resmi

```bash
wget https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.xz
wget https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify binutils-2.43.1.tar.xz.sig binutils-2.43.1.tar.xz
```

---

## 6. Dependensi build

Binutils termasuk proyek besar yang memiliki dependensi minimal:

* `texinfo`, `zlib`, `bison`, `flex`, `gmp`, `mpfr`.

Di Arch:

```bash
sudo pacman -Syu --needed base-devel texinfo zlib
```

Di Debian:

```bash
sudo apt install build-essential texinfo zlib1g-dev
```

---

## 7. Membangun Binutils dari sumber

> Build dilakukan di direktori terpisah, terutama jika Anda ingin membuat *cross-compiler*.

```bash
tar -xf binutils-2.43.1.tar.xz
mkdir build-binutils && cd build-binutils
../binutils-2.43.1/configure --prefix=/usr \
  --enable-gold \
  --enable-ld=default \
  --enable-plugins \
  --enable-shared \
  --disable-werror
make -j$(nproc)
make check
sudo make install
```

Penjelasan:

* `--enable-gold`: mengaktifkan linker cepat “gold”.
* `--enable-plugins`: agar GCC dan Clang dapat menautkan plugin lintasan LTO.
* `--disable-werror`: mengabaikan peringatan agar tidak menggagalkan build.

---

## 8. Verifikasi hasil build

```bash
ld -v
as --version
objdump -i | head
```

Untuk memastikan versi baru aktif:

```bash
which ld
ld --verbose | grep SEARCH_DIR
```

---

## 9. Menggunakan alat Binutils

### Contoh 1 — Melihat struktur ELF

```bash
readelf -h /bin/ls
```

Output menampilkan:

```
ELF Header:
  Class: ELF64
  Entry point address: 0x401000
```

### Contoh 2 — Disassembly program

```bash
objdump -d /bin/ls | less
```

### Contoh 3 — Menelusuri simbol fungsi

```bash
nm main.o | grep 'T main'
```

### Contoh 4 — Membuat library statis

```bash
gcc -c math.c
ar rcs libmath.a math.o
ranlib libmath.a
```

---

## 10. Cross-compilation dengan Binutils

Untuk membangun toolchain lintas arsitektur (misal ARM dari x86):

```bash
../binutils-2.43.1/configure --target=arm-none-eabi --prefix=/opt/cross --disable-nls --disable-werror
make -j$(nproc)
sudo make install
```

Setelah itu, gunakan `arm-none-eabi-as`, `arm-none-eabi-ld`, dll.

---

## 11. Contoh `PKGBUILD` untuk Arch

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=binutils-custom
pkgver=2.43.1
pkgrel=1
pkgdesc="GNU Binutils - custom build"
arch=('x86_64')
url="https://www.gnu.org/software/binutils/"
license=('GPL-3.0-or-later')
depends=('glibc' 'zlib')
makedepends=('texinfo')
source=("https://ftp.gnu.org/gnu/binutils/binutils-${pkgver}.tar.xz")
sha256sums=('PUT_SHA256_HERE')

build() {
  mkdir -p "${srcdir}/build"
  cd "${srcdir}/build"
  ../binutils-${pkgver}/configure --prefix=/usr --enable-gold --enable-plugins --disable-werror
  make
}

check() {
  cd "${srcdir}/build"
  make -k check || true
}

package() {
  cd "${srcdir}/build"
  make DESTDIR="${pkgdir}" install
}
```

Build: `makepkg -si`.

---

## 12. Modifikasi Binutils

Untuk memodifikasi Binutils, pelajari:

* Struktur di `binutils/`, `bfd/`, dan `gas/`.
* **Bahasa pemrograman**: C murni dengan kode portabel antar-arsitektur.
* *Assembler grammar* (file `.tc` dan `.md`) di `gas/config/`.
* Tambah dukungan arsitektur baru melalui `bfd/archures.c`.
* Gunakan skrip `ldscripts` untuk mengatur urutan linking.

Keterampilan yang diperlukan:

* Pemahaman *ELF format*, *linking process*, dan *assembly language*.
* Kemampuan membaca spesifikasi arsitektur CPU target.

---

## 13. Praktik aman

* Jangan ganti linker sistem (`/usr/bin/ld`) tanpa uji di lingkungan aman (chroot/VM).
* Gunakan prefix `/opt/binutils-custom` agar versi eksperimen tidak bentrok.
* Tambahkan path sementara:

```bash
export PATH=/opt/binutils-custom/bin:$PATH
```

* Pastikan `make check` lulus sebagian besar tes.

---

## 14. Referensi utama

* **GNU Binutils Home:** [https://www.gnu.org/software/binutils/](https://www.gnu.org/software/binutils/)
* **Manual Binutils & BFD Library Reference.**
* **Arch PKGBUILD resmi binutils.**
* **Sourceware.org Git Repository:** [https://sourceware.org/git/?p=binutils-gdb.git](https://sourceware.org/git/?p=binutils-gdb.git)
* **OSDev Wiki (ELF dan linker script)** — pembahasan teknis detail.

---

## 15. Checklist untuk pelajar

1. Pastikan `ld --version` menampilkan “GNU ld”.
2. Unduh dan verifikasi sumber `binutils-x.y.tar.xz`.
3. Build di direktori terpisah dengan `--enable-gold --enable-plugins`.
4. Jalankan `make check`.
5. Eksperimen dengan `objdump`, `readelf`, `nm`, `strings`.
6. Coba build *cross-binutils* untuk arsitektur lain.
7. Pelajari struktur ELF dengan `readelf -a program`.

---

Dengan berakhirnya pembahasan **GNU Binutils**, maka seluruh kelompok besar **⚙️ Komponen GNU di Linux** kini sudah lengkap: Coreutils, Bash, GCC, Make, GDB, dan Binutils.

Langkah berikutnya dalam rencana besar dokumentasi Anda adalah bagian **💡 Perbedaan GNU dan Linux** — di mana kita akan membedah hubungan historis dan teknis antara proyek GNU dan kernel Linux, serta alasan kenapa sistem seharusnya disebut **GNU/Linux**.


