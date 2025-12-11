# Overview singkat — apa itu Zig

Zig adalah bahasa pemrograman *low-level* sekaligus toolchain yang dirancang untuk menggantikan/menyempurnakan tugas-tugas yang biasa dilakukan oleh C. Fokusnya: **keandalan (robustness)**, **kontrol penuh atas layout biner**, **cross-compilation built-in**, dan **compile-time execution** (`comptime`) tanpa memerlukan garbage collector. Zig hadir juga sebagai *drop-in* C compiler (`zig cc`) sehingga dapat dipakai untuk membangun dan menautkan proyek C/C++ serta untuk pengembangan OS/embedded dan aplikasi high-performance. Informasi ringkas dan landing page Zig tersedia di situs resmi Zig. ([ziglang.org][1])

Ringkasan teknis singkat:

* Compiler: *self-hosted* (sudah mayoritas ditulis dalam Zig) dan dapat menggunakan LLVM sebagai backend; proyek beralih dari implementasi lama C++ → Zig untuk kecepatan dan pengembangan. ([ziglang.org][2])
* Cross compilation: Zig menyediakan kemampuan cross-compile **out-of-the-box** (target triple banyak tersedia) tanpa harus memasang toolchain eksternal. ([Wikipedia][3])
* Build system: `build.zig` (build system terintegrasi — Zig mengadopsi filosofi “toolchain lengkap”). ([ziglang.org][4])

---
<!---->
<!-- # Daftar sumber utama (link + penjelasan lengkap untuk tiap sumber) -->
<!---->
<!-- > Untuk setiap entri: saya tulis judul → URL lengkap → ringkasan isi / apa yang Anda dapatkan → bagaimana menyimpan offline / clone → kegunaan praktis / kapan pakai → catatan teknis (bahasa / requirement). Setiap entri penting diberi sitasi. -->
<!---->
<!-- --- -->
<!---->
## 1) Situs resmi Zig — Home / Landing page

**URL:** [https://ziglang.org/](https://ziglang.org/)
**Penjelasan:** Halaman resmi (landing) proyek Zig: ringkasan filosofi, link download, link ke dokumentasi, berita rilis, dan pointer ke sumber. Gunakan halaman ini untuk mengetahui rilis terbaru, tautan unduhan, dan daftar dokumentasi/learn. ([ziglang.org][1])
**Offline:** simpan halaman HTML atau gunakan feed/arsip rilis. Untuk automasi unduh tarball, gunakan *Community Mirrors* yang dijelaskan di halaman download (lihat entri Download). ([ziglang.org][5])
**Kegunaan praktis:** starting point resmi — selalu cek di sini untuk versi rilis dan dokumentasi canonical. ([ziglang.org][1])

---

## 2) Download / Releases (binary & tarball)

**URL:** [https://ziglang.org/download/](https://ziglang.org/download/)
**Penjelasan:** Halaman unduhan resmi berisi tarball/binari untuk platform (Linux, macOS, Windows), release notes setiap versi, dan petunjuk instalasi ringkas. Halaman ini juga menjelaskan *Community Mirrors* untuk automasi unduh agar mengurangi beban bandwidth server resmi. ([ziglang.org][6])
**Offline:** unduh tarball (contoh: `zig-linux-x86_64-<version>.tar.xz`) dan simpan di folder `/opt/zig` atau `~/bin`. Panduan getting started di situs menjelaskan langkah `tar -xf` dan menambahkan `zig` ke PATH. ([ziglang.org][7])
**Kegunaan praktis:** cara tercepat memasang Zig tanpa bergantung pada paket distro (rekomendasi umum jika ingin versi terbaru). ([ziglang.org][7])

---

## 3) Language Reference (Dokumentasi bahasa resmi)

**URL (master):** [https://ziglang.org/documentation/master/](https://ziglang.org/documentation/master/)
**Contoh versi:** [https://ziglang.org/documentation/0.14.1/](https://ziglang.org/documentation/0.14.1/) (versi released docs). ([ziglang.org][8])
**Penjelasan:** dokumentasi bahasa lengkap (syntax, keywords, semantics, builtins, behavior test notes). Gunakan ini sebagai *definisi resmi bahasa* ketika Anda butuh aturan semantik (contoh: `comptime`, tipe, calling convention helpers, builtin functions). ([ziglang.org][8])
**Offline:** sumber dokumentasi berada dalam repo `zig` (file doc) — Anda dapat mengunduh HTML versi rilis atau build docs lokal (lihat entri “How to generate std docs” di forum dan wiki). ([Ziggit][9])
**Kegunaan praktis:** referensi teknis utama untuk bahasa saat menulis library atau memodifikasi compiler. ([ziglang.org][8])

---

## 4) Standard Library (std) — dokumentasi API stdlib

**URL:** [https://ziglang.org/documentation/master/std/](https://ziglang.org/documentation/master/std/)  (contoh: [https://ziglang.org/documentation/0.7.0/std/](https://ziglang.org/documentation/0.7.0/std/))
**Penjelasan:** dokumentasi fungsional dari modul-modul `std` (I/O, allocator, fs, os, crypto helpers, test runner, dll.). Menjelaskan API publik, signature fungsi, error sets, dan contoh penggunaan. ([ziglang.org][10])
**Offline:** build lokal docs dari source Zig (`zig build docs`) atau simpan HTML rilis. Forum dan issue membahas bagaimana meng-generate dokumen std secara lokal. ([Ziggit][11])
**Kegunaan praktis:** rujukan saat memanggil allocator, menguji kode, atau memakai utilities std (contoh: `std.debug.print`, `std.heap` dll.). ([ziglang.org][10])

---

## 5) Build System — dokumentasi `build.zig` dan panduan penggunaan `zig build`

**URL:** [https://ziglang.org/learn/build-system/](https://ziglang.org/learn/build-system/)
**Penjelasan:** panduan resmi untuk menulis `build.zig`, membuat executable/library, phases build, tests integration, dan contoh konfigurasi. Ini adalah referensi untuk menangani project Zig (menggantikan CMake/Make untuk proyek Zig native). ([ziglang.org][4])
**Offline:** salin tutorial dan file contoh (`build.zig`) ke repos lokal; ada thread diskusi & tutorial yang didaur ulang di forum. ([Ziggit][12])
**Kegunaan praktis:** menyiapkan pipeline build, cross-compile target, dan mengintegrasikan dependen (via submodule/zig.mod/gyro). ([ziglang.org][4])

---

## 6) Zig Git repository (source compiler & stdlib) — canonical origin moved

**URL (announcement):** [https://ziglang.org/news/migrating-from-github-to-codeberg/](https://ziglang.org/news/migrating-from-github-to-codeberg/)
**Repo mirror (GitHub org page):** [https://github.com/ziglang](https://github.com/ziglang) (read-only notice) — canonical repo sekarang di Codeberg (lihat pengumuman). ([ziglang.org][13])
**Penjelasan:** kode sumber compiler & stdlib; repo berisi `doc/`, `src/`, `build scripts`, test harness, dan `langref.html.in`. Pengumuman migrasi menjelaskan bahwa canonical origin bergeser ke Codeberg. Jika Anda ingin *membangun dari source*, ikuti README di repo (clone origin yang tercantum). ([ziglang.org][13])
**Offline:** `git clone` repo (origin canonical — Codeberg) → lakukan build (cmake / ninja) sesuai README. Ada juga release tarballs pada halaman download. ([ziglang.org][13])
**Kegunaan praktis:** kontribusi ke compiler, meneliti implementasi backend/linker/IR. ([ziglang.org][2])

---

## 7) Devlog / Release Notes / Roadmap (perubahan besar & arsitektur self-hosting)

**Contoh URL:** Devlog & Release Notes — [https://ziglang.org/devlog/2025/](https://ziglang.org/devlog/2025/)  dan release notes (contoh 0.15.1): [https://ziglang.org/download/0.15.1/release-notes.html](https://ziglang.org/download/0.15.1/release-notes.html)
**Penjelasan:** catatan rilis (changelog), devlog yang menjelaskan milestone (mis. “goodbye to the C++ implementation”, perkembangan self-hosted backends, perbaikan x86 backend, migrasi ke self-hosted compiler). Sumber ini penting untuk memahami roadmap teknis (mengapa Zig mengurangi ketergantungan pada LLVM). ([ziglang.org][2])
**Kegunaan praktis:** memutuskan apakah akan membangun dengan LLVM backend atau menggunakan self-hosted backend, menilai stabilitas fitur target. ([ziglang.org][14])

---

## 8) Zigtools / ZLS (Language Server + tooling komunitas)

**ZLS (Language Server) — GitHub:** [https://github.com/zigtools/zls](https://github.com/zigtools/zls)
**Zigtools (project hub):** [https://zigtools.org/](https://zigtools.org/)
**Penjelasan:** ZLS adalah implementasi LSP untuk Zig (autocomplete, goto-def, formatting hooks). Zigtools menyediakan playground dan utilitas komunitas. Gunakan ZLS untuk integrasi editor (Neovim/Helix/VSCode). ([GitHub][15])
**Offline / instalasi:** release zls tersedia di GitHub; install binaan atau build dari source (lihat README zls). Ada issue tracker & dokumentasi install. ([GitHub][15])
**Kegunaan praktis:** pengalaman pengembangan interaktif — jump-to-source, diagnostics, formatting; sangat penting untuk workflow Neovim/Helix yang Anda pakai. ([GitHub][15])

---

## 9) Komunitas-learning & tutorial (non-official tetapi lengkap)

**Zig Learn / ziglearn (repo & site):** [https://github.com/pmuens/ziglearn](https://github.com/pmuens/ziglearn)  dan [https://zig.guide/](https://zig.guide/) (community guide)
**Penjelasan:** tutorial langkah-demi-langkah, “idiomatic Zig” guides, contoh code snippets, dan ringkasan konsep `comptime`, allocators, dan contoh cross-compile. Cocok untuk belajar praktis. ([GitHub][16])
**Offline:** clone repo tutorial, simpan halaman guide sebagai markdown/PDF. ([GitHub][16])
**Kegunaan praktis:** cepat praktek dan membuat project awal. ([zig.guide][17])

---

## 10) Package managers / ecosystems komunitas (zigmod, gyro, zigistry, zig.pm)

**Zigmod (nektro):** [https://github.com/nektro/zigmod](https://github.com/nektro/zigmod)  — docs: [https://nektro.github.io/zigmod/](https://nektro.github.io/zigmod/)
**Gyro:** (project page / repo; dokumentasi dan index) — gyro resources & download mirrors (contoh: SourceForge mirror). ([GitHub][18])
**Zigistry / zig.pm (registries):** [https://zigistry.dev/](https://zigistry.dev/)  dan [https://zig.pm/](https://zig.pm/) — indeks paket komunitas. ([Zigistry][19])
**Penjelasan:** Zig belum memiliki package manager resmi yang diseragamkan seperti Cargo; beberapa solusi komunitas (zigmod, gyro) muncul untuk membantu dependency management. Gunakan jika Anda butuh workflow mirip Cargo. ([GitHub][18])
**Offline:** alat-alat ini dapat di-install lokal; sebagian memiliki index publik yang bisa di-mirror. ([Homebrew Formulae][20])
**Kegunaan praktis:** manajemen dependensi untuk project besar atau reuse package; catatan: ekosistem masih berevolusi, tinjau stabilitas tiap manager sebelum adopsi. ([blog.orhun.dev][21])

---

## 11) Artikel, diskusi, dan ringkasan sejarah (context & alasan desain)

**Contoh penting:** “Goodbye to the C++ Implementation of Zig” (pengumuman resmi) — menjelaskan peralihan ke compiler yang ditulis Zig; diskusi di forum & Hacker News/Lobsters menjelaskan keuntungan self-hosting. ([ziglang.org][2])
**Penjelasan:** bacaan ini memberi konteks mengapa Zig mengusahakan self-hosted backends, bagaimana hal itu mempengaruhi build chain, dan trade-offs terhadap LLVM. Berguna untuk developer yang mempertimbangkan kontribusi ke compiler. ([ziglang.org][2])

---

# Identitas teknis & *what you need* untuk memodifikasi / membangun Zig dari source

**Bahasa implementasi:** mayoritas compiler modern Zig **ditulis dalam Zig** (self-hosted) — sejarahnya ada implementasi awal sbg C++ base yang kemudian digantikan; LLVM digunakan sebagai backend utama untuk banyak target, namun Zig mengembangkan backend sendiri untuk mengurangi ketergantungan pada LLVM. Lihat artikel pengumuman dan devlog untuk detail sejarah dan status self-hosting. ([ziglang.org][2])

**Dependency & environment (ringkas):**

* `cmake`, `ninja`, `python3` (jika diperlukan oleh build scripts).
* LLVM toolchain (jika Anda ingin build dengan LLVM backend) — header/devel packages.
* Toolchain POSIX-like (gcc/make) untuk bootstrap steps pada beberapa target.
* Sistem Git untuk clone repo canonical (perhatikan migrasi ke Codeberg). ([ziglang.org][13])

**Langkah ringkas build from source (contoh umum):**

1. Clone repo canonical (lihat pengumuman migrasi → gunakan origin di Codeberg). ([ziglang.org][13])
2. Ikuti README (biasanya `mkdir build && cmake .. && ninja` atau `make -j$(nproc)` tergantung instruksi rilis). Contoh instruksi umum ada di README repo/Release notes. ([ziglang.org][6])

**Skill wajib untuk kontributor:**

* Penguasaan Zig lanjutan (`comptime`, allocator, error unions).
* Familiarity dengan LLVM (opsional jika menggunakan LLVM backend).
* Pengalaman dengan build system CMake/Ninja, debugging compiler, dan test harness. ([ziglang.org][2])

---

# Perintah CLI penting (kata-per-kata) — penggunaan praktis & penjelasan token

Saya ambil perintah yang paling sering dipakai; tiap token dijelaskan singkat dan rujukan diberikan.

### 1. Menjalankan file Zig langsung

```bash
zig run src/main.zig
```

* `zig` : executable Zig (compiler + tooling). ([ziglang.org][1])
* `run` : subcommand yang **compile lalu menjalankan** program tanpa menyimpan file binary ke disk (convenience). ([ziglang.org][7])
* `src/main.zig` : path ke file sumber Zig.

Gunakan saat prototyping.

---

### 2. Menghasilkan executable

```bash
zig build-exe src/main.zig -O ReleaseFast -target x86_64-linux-gnu -o bin/myprog
```

* `build-exe` : perintah compile → hasilkan executable. ([ziglang.org][7])
* `-O ReleaseFast` : level optimasi build (ReleaseFast = aggressive optimizations).
* `-target x86_64-linux-gnu` : target triple (platform/ABI) untuk cross-compile. Zig mendukung banyak target tanpa toolchain eksternal. ([Wikipedia][3])
* `-o bin/myprog` : tulis hasil ke path `bin/myprog`.

---

### 3. Format kode

```bash
zig fmt src/
```

* `fmt` : formatter built-in Zig.
* `src/` : direktori/berkas target.
  Gunakan di pre-commit atau CI untuk konsistensi styling.

---

### 4. Menjalankan test runner

```bash
zig test src/lib.zig
```

* `test` : compile + jalankan `test` blocks di file (Zig memiliki builtin `test "name" { ... }`). ([ziglang.org][10])

---

### 5. Menggunakan Zig sebagai C compiler (drop-in)

```bash
zig cc hello.c -o hello
```

* `cc` : mode Zig sebagai C/C++ compiler front-end; Zig menggunakan kemampuan parsing/translation sendiri (sering memanggil clang/translate-c historically, tetapi kini Zig menyediakan banyak tooling) dan dapat menghasilkan cross-compiled binaries. ([Wikipedia][3])
* `hello.c` : input source C.
* `-o hello` : output name.

Kegunaan: menggantikan `gcc/clang` sebagai cross-compiler sederhana.

---

### 6. Install & getting started (tarball recommended)

Situs resmi merekomendasikan mengunduh tarball bila ingin versi terbaru:

```bash
# contoh ringkas dari Getting Started
wget https://ziglang.org/download/zig-linux-x86_64-<version>.tar.xz
tar -xf zig-linux-x86_64-<version>.tar.xz
sudo mv zig-linux-x86_64-<version>/ /opt/zig
sudo ln -s /opt/zig/zig /usr/local/bin/zig
```

* Rujukan: Getting Started pada dokumentasi resmi (Download / Getting Started). ([ziglang.org][7])

---

# Rekomendasi praktis & ringkasan tindakan Anda selanjutnya

1. **Untuk menguji cepat:** unduh tarball dari [https://ziglang.org/download/](https://ziglang.org/download/) , ekstrak, jalankan `zig run hello.zig`. ([ziglang.org][6])
2. **Jika goal Anda: modifikasi compiler / kontribusi:** clone repo canonical (cek pengumuman migrasi → Codeberg), baca `doc/` dan `README`, siapkan `cmake`/`ninja` & (opsional) LLVM dev libs. ([ziglang.org][13])
3. **Untuk pengembangan sehari-hari di Neovim/Helix:** pasang `zls` (Zig LSP) dan konfigurasikan editor Anda untuk memakai `zig fmt` + `zig test`. ([GitHub][15])
4. **Jika Anda perlu dependency manager:** evaluasi `zigmod` atau `gyro` — keduanya komunitas-driven; gunakan submodules bila butuh stabilitas jangka panjang. ([GitHub][18])

---

# Sumber & sitasi ringkas (semua link yang saya gunakan di atas)

* Zig — Home / Official: [https://ziglang.org/](https://ziglang.org/) . ([ziglang.org][1])
* Zig — Documentation (Language Reference master): [https://ziglang.org/documentation/master/](https://ziglang.org/documentation/master/) . ([ziglang.org][8])
* Zig — Standard library docs: [https://ziglang.org/documentation/master/std/](https://ziglang.org/documentation/master/std/) . ([ziglang.org][10])
* Zig — Build system guide: [https://ziglang.org/learn/build-system/](https://ziglang.org/learn/build-system/) . ([ziglang.org][4])
* Zig — Download page (tarballs & release notes): [https://ziglang.org/download/](https://ziglang.org/download/) . ([ziglang.org][6])
* Getting started: [https://ziglang.org/learn/getting-started/](https://ziglang.org/learn/getting-started/) . ([ziglang.org][7])
* Zigtools / ZLS (LSP): [https://github.com/zigtools/zls](https://github.com/zigtools/zls) and [https://zigtools.org/](https://zigtools.org/) . ([GitHub][15])
* Zig repo migration announcement (GitHub → Codeberg): [https://ziglang.org/news/migrating-from-github-to-codeberg/](https://ziglang.org/news/migrating-from-github-to-codeberg/) . ([ziglang.org][13])
* Devlog / self-hosting discussions & Goodbye-C++: [https://ziglang.org/devlog/2025/](https://ziglang.org/devlog/2025/)  and [https://ziglang.org/news/goodbye-cpp/](https://ziglang.org/news/goodbye-cpp/) . ([ziglang.org][22])
* Release notes (contoh 0.15.1): [https://ziglang.org/download/0.15.1/release-notes.html](https://ziglang.org/download/0.15.1/release-notes.html) . ([ziglang.org][14])
* zig.guide / community guides: [https://zig.guide/](https://zig.guide/) . ([zig.guide][17])
* ziglearn (tutorial repo): [https://github.com/pmuens/ziglearn](https://github.com/pmuens/ziglearn) . ([GitHub][16])
* zigmod (package manager): [https://github.com/nektro/zigmod](https://github.com/nektro/zigmod)  and docs [https://nektro.github.io/zigmod/](https://nektro.github.io/zigmod/) . ([GitHub][18])
* gyro (package manager project): various mirrors / docs (example mirror): SourceForge / repo pages. ([SourceForge][23])

---
<!---->
<!-- Jika Anda ingin, saya bisa langsung: -->
<!---->
<!-- * (A) **Buatkan file Markdown README** berisi seluruh daftar di atas (dengan link yang clickable) untuk di-archive; atau -->
<!-- * (B) **Buatkan skrip bash** yang otomatis mengunduh tarball Zig terbaru, clone repo canonical (Codeberg), dan menyiapkan lingkungan build (cmake/ninja) — lengkap dengan penjelasan kata-per-kata setiap baris skrip; atau -->
<!-- * (C) **Susun checklist** konfigurasi Neovim/Helix + ZLS + pre-commit (`zig fmt`) yang siap dipasang di lingkungan Arch + Sway Wayland Anda. -->
<!---->
<!-- Sebutkan pilihan (A/B/C) atau minta output lain — saya akan buatkan langsung (lengkap dengan penjelasan teknis kata-per-kata seperti Anda minta). -->
<!---->
[1]: https://ziglang.org/?utm_source=chatgpt.com "Home Zig Programming Language"
[2]: https://ziglang.org/news/goodbye-cpp/?utm_source=chatgpt.com "Goodbye to the C++ Implementation of Zig"
[3]: https://en.wikipedia.org/wiki/Zig_%28programming_language%29?utm_source=chatgpt.com "Zig (programming language)"
[4]: https://ziglang.org/learn/build-system/?utm_source=chatgpt.com "Zig Build System"
[5]: https://ziglang.org/news/announcing-community-mirrors/?utm_source=chatgpt.com "Community Mirrors: A Better Way To Download Zig"
[6]: https://ziglang.org/download/?utm_source=chatgpt.com "Download"
[7]: https://ziglang.org/learn/getting-started/?utm_source=chatgpt.com "Getting Started"
[8]: https://ziglang.org/documentation/master/?utm_source=chatgpt.com "Zig Language Reference"
[9]: https://ziggit.dev/t/where-is-the-doc-source-for-the-zig-language-reference-doc/7609?utm_source=chatgpt.com "Where is the doc source for the Zig language reference doc?"
[10]: https://ziglang.org/documentation/master/std/?utm_source=chatgpt.com "std - Zig Documentation"
[11]: https://ziggit.dev/t/local-std-documentation/5114?utm_source=chatgpt.com "Local std documentation? - Help"
[12]: https://ziggit.dev/t/new-zig-build-system-documentation/2191?utm_source=chatgpt.com "New Zig Build System Documentation"
[13]: https://ziglang.org/news/migrating-from-github-to-codeberg/?utm_source=chatgpt.com "Migrating from GitHub to Codeberg"
[14]: https://ziglang.org/download/0.15.1/release-notes.html?utm_source=chatgpt.com "0.15.1 Release Notes"
[15]: https://github.com/zigtools/zls?utm_source=chatgpt.com "zigtools/zls: A language server for Zig supporting ..."
[16]: https://github.com/pmuens/ziglearn?utm_source=chatgpt.com "Learning Zig via ziglearn.org"
[17]: https://zig.guide/?utm_source=chatgpt.com "zig.guide: Welcome"
[18]: https://github.com/nektro/zigmod?utm_source=chatgpt.com "nektro/zigmod: 📦 A package manager for the Zig ..."
[19]: https://zigistry.dev/packages/github/leecannon/zig-x86_64/?utm_source=chatgpt.com "zig-x86_64"
[20]: https://formulae.brew.sh/formula/zigmod?utm_source=chatgpt.com "zigmod"
[21]: https://blog.orhun.dev/zig-bits-03/?utm_source=chatgpt.com "Zig Bits 0x3: Mastering project management in Zig"
[22]: https://ziglang.org/devlog/2025/?utm_source=chatgpt.com "Devlog"
[23]: https://sourceforge.net/projects/gyro.mirror/?utm_source=chatgpt.com "Gyro download"
