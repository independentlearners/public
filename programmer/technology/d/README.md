
# Overview singkat — apa itu D

D (sering disebut *dlang*) adalah bahasa pemrograman **sistem** ber-`static typing` dengan sintaks mirip C/C++ yang menggabungkan fitur-fitur modern (GC opsional, meta-programming, contract programming, ranges, slice, UFCS, RAII, dll.). D dirancang untuk produktivitas tinggi sekaligus performa native; ada subset *BetterC* untuk interoperabilitas C tanpa runtime D. Ada beberapa implementasi compiler (DMD — reference frontend/backends, LDC — LLVM backend, GDC — GCC frontend). Untuk rilis & dokumentasi resmi gunakan dlang.org. ([dlang.org][1])

Mengapa belajar D? alasan praktis:

* cocok untuk tool/CLI native (compile cepat, performa),
* mendukung pemrograman sistem dan high-level productivity (metaprogramming + GC opsi),
* interoperabilitas C yang baik → bagus untuk binding / extension, dan
* ekosistem (Phobos, DUB) untuk packaging & standar library. ([dlang.org][2])

---

### 1) Situs resmi D — *D Programming Language*

**[https://dlang.org/](https://dlang.org/)**. ([dlang.org][1])

* **Isi:** landing page, rilis terbaru, link ke dokumentasi (language spec, Phobos, druntime), download compiler (DMD/LDC/GDC), berita komunitas.
* **Alasan / tujuan:** entry point canonical; selalu cek untuk rilis, installer resmi dan pointer dokumentasi. Gunakan ini untuk memastikan Anda menggunakan versi compiler yang tepat.
* **Offline / teknis:** simpan halaman rilis dan unduh tarball/installer dari halaman *Download*.

---

### 2) Language Specification & Reference (D spec / function reference / intro)

**D Language intro & spec — [https://dlang.org/spec/](https://dlang.org/spec/)** (modul-by-modul seperti function, types, templates). ([dlang.org][3])

* **Isi:** aturan bahasa resmi (semantik, syntax, attributes, contracts, templates, CTFE).
* **Alasan / tujuan:** rujukan otoritatif ketika Anda perlu kepastian behaviour bahasa (mis. semantics CTFE, contract behavior, `@safe`/`@trusted`). Wajib untuk implementor compiler & library authors.
* **Offline / teknis:** unduh halaman spec (HTML/PDF mirror) atau clone repo dokumentasi.

---

### 3) Tour / Tutorial interaktif — *Tour of D*

**[https://tour.dlang.org/](https://tour.dlang.org/)**. ([tour.dlang.org][4])

* **Isi:** pengenalan interaktif (hello world → tipe → arrays → ranges → templates → CTFE).
* **Alasan / tujuan:** cara tercepat dan praktis untuk pemula memahami fitur khas D lewat contoh. Gunakan sebagai starting exercises.
* **Offline / teknis:** salin materi contoh; beberapa mirror/tutorial video tersedia (YouTube).

---

### 4) DMD — reference compiler (Digital Mars)

**DMD overview & repo — [https://dlang.org/dmd.html](https://dlang.org/dmd.html)** and [https://github.com/dlang/dmd](https://github.com/dlang/dmd). ([dlang.org][5])

* **Isi:** DMD adalah compiler acuan (frontend) dan banyak bagian sekarang diimplementasikan dalam D (self-hosted). Repositori berisi `compiler`, `druntime`, `phobos`.
* **Alasan / tujuan:** gunakan DMD untuk fitur terbaru dan fastest debug compile times; referensi saat mengikuti rilis bahasa. Jika Anda mau kontribusi ke compiler, baca repo & CONTRIBUTING.
* **Offline / teknis:** build DMD dengan `dub` (lihat README); untuk memodifikasi: butuh DMD (or LDC), dub, toolchain build deps. Repo sebagian besar ditulis dalam D (bahasa implementasi) — lihat bahasa breakdown di GitHub. ([GitHub][6])

---

### 5) LDC — LLVM-based D compiler

**[https://github.com/ldc-developers/ldc](https://github.com/ldc-developers/ldc)** and docs/wiki [https://wiki.dlang.org/LDC](https://wiki.dlang.org/LDC). ([GitHub][7])

* **Isi:** LDC menggunakan frontend DMD (kompatibilitas) dan LLVM untuk codegen/optimizations. Distribusi tersedia prebuilt untuk banyak platform.
* **Alasan / tujuan:** pakai LDC bila butuh optimasi LLVM (LTO, link-time optimizations), cross-compiling advanced optimization, atau ingin integrasi toolchain LLVM. LDC sering jadi pilihan produksi untuk binari performa tinggi.
* **Offline / teknis:** paket tersedia di banyak distro; untuk membangun perlu LLVM dev libs, CMake, ninja, dll. ([GitHub][7])

---

### 6) GDC — GCC frontend untuk D (bagian dari GCC)

**[https://gdcproject.org/](https://gdcproject.org/)** dan integrasi ke GCC. ([gdcproject.org][8])

* **Isi:** frontend D untuk GCC, memungkinkan target banyak arsitektur yang didukung GCC.
* **Alasan / tujuan:** bila Anda butuh target GCC yang luas atau integrasi dengan toolchain GCC (mis. embedded platforms), GDC berguna. Juga berguna jika Anda ingin memanfaatkan ekosistem GCC.
* **Offline / teknis:** GDC berada dalam tree GCC; membangun memerlukan sumber GCC dan toolchain pengembangan.

---

### 7) Phobos — Standard Library (D stdlib)

**[https://dlang.org/phobos/](https://dlang.org/phobos/)** and GitHub [https://github.com/dlang/phobos](https://github.com/dlang/phobos). ([dlang.org][2])

* **Isi:** modul `std`: algorithms, I/O, regex, containers, ranges, concurrency utilities, utf; core dan runtime (`core.*`) untuk low-level.
* **Alasan / tujuan:** Phobos adalah library standar D — pelajari struktur std, idiom (ranges, iterations), dan facilities yang menggantikan banyak kebutuhan third-party. Wajib untuk menulis aplikasi produksi.
* **Offline / teknis:** Phobos biasanya di-pack bersama compiler; repo dapat di-clone dan dibuild untuk referensi lokal.

---

### 8) druntime — runtime & GC (D runtime)

**druntime (bagian dmd repo / docs di wiki)**. ([GitHub][6])

* **Isi:** runtime D (garbage collector, runtime type info, exception/RT stuff).
* **Alasan / tujuan:** pelajari druntime jika target Anda adalah *systems programming* (mengerti GC behaviour), atau jika ingin menggunakan *BetterC* tanpa runtime. Juga penting bila ingin memodifikasi/optimalkan runtime.
* **Offline / teknis:** ada di repo dmd; membutuhkan C toolchain / linker untuk build.

---

### 9) DUB — package manager & build tool (seperti cargo)

**[https://dub.pm/](https://dub.pm/)** (guide & reference). ([dub.pm][9])

* **Isi:** deklarasi paket (`dub.json` / `dub.sdl`), dependency resolver, build profiles, registries. Sering terbundel dengan DMD.
* **Alasan / tujuan:** DUB adalah cara standar untuk membuat project, menangani dependensi, dan distribusi package. Wajib dikuasai untuk workflow modern D.
* **Offline / teknis:** DUB terpasang bersama DMD/installer pada banyak platform; dapat diupdate sendiri.

---

### 10) Buku penting — *The D Programming Language* (Andrei Alexandrescu)

**Andrei Alexandrescu — The D Programming Language** (buku terbitan Addison-Wesley). Contoh ringkasan & sample: (book pages / publisher). ([ptgmedia.pearsoncmg.com][10])

* **Isi:** pembahasan bahasa D mendalam—design choices, contoh idiom, template/compile-time programming, contract programming.
* **Alasan / tujuan:** buku terstruktur untuk developer serius; memberikan konteks desain dan praktik idiomatik. Sangat direkomendasikan sebagai bacaan lanjutan setelah tour.
* **Offline / teknis:** tersedia fisik/ebook (beli/legal). Beberapa excerpt/paper tersedia online.

---

### 11) D Wiki (komunitas) — *wiki.dlang.org*

**[https://wiki.dlang.org/](https://wiki.dlang.org/)**. ([wiki.dlang.org][11])

* **Isi:** tips, how-tos, recipes (LDC build, cross-compile guides, library examples), FAQ.
* **Alasan / tujuan:** koleksi pengetahuan praktis & resep yang tidak selalu ada di spec; berguna untuk debugging atau teknik-khusus (cross-compiling, embedding).
* **Offline / teknis:** mirror wiki dapat di-clone untuk referensi.

---

### 12) Tools & ecosystem (dscanner / dfmt / DCD / serve-d / rdmd) — (repos / README)

* **D-Scanner (static analyser):** [https://github.com/dlang-community/D-Scanner](https://github.com/dlang-community/D-Scanner) — *untuk pemeriksaan statis dan style checks*. ([Homebrew Formulae][12])
* **dfmt (formatter):** [https://github.com/dlang-community/dfmt](https://github.com/dlang-community/dfmt) — *code formatter*. ([GitHub][13])
* **DCD (completion daemon):** [https://github.com/dlang-community/DCD](https://github.com/dlang-community/DCD) — *autocompletion backend untuk editor*. ([GitHub][14])
* **serve-d / DLS / language server:** [https://github.com/Pure-D/serve-d](https://github.com/Pure-D/serve-d) — LSP server untuk pengalaman IDE yang lengkap. ([GitHub][15])
* **rdmd (script/run helper):** [https://dlang.org/rdmd.html](https://dlang.org/rdmd.html) — *rapid edit-compile-run tool* (mirip `cargo run` / `python -m`). ([dlang.org][16])

**Alasan / tujuan:** tools di atas meningkatkan produktivitas pengembangan (autocomplete, formatting, linting, rapid run). Jika Anda bekerja di Neovim/Helix/VSCode, pasang LSP & DCD/serve-d untuk IDE-like features.

---

# Cara mengunduh / mirror / instal (ringkas & perintah contoh)

**Instalasi cepat (Linux/Arch)** — gunakan script resmi atau paket repo:

* **Script resmi instalasi (instal DMD/LDC/DUB):**

```bash
curl -fsS https://dlang.org/install.sh | bash
```

— script ini menyediakan pilihan installer untuk `dmd`, `ldc`, `gdc`. (lihat halaman *Downloads* di dlang.org). ([dlang.org][17])

* **Contoh Arch (pacman):**

```bash
sudo pacman -S ldc dmd dub
```

(paket tersedia di repos/community). Lihat manpage `dmd(1)` untuk opsi. ([Arch Manual Pages][18])

* **Install LDC dari paket / GitHub releases** (recommended for production): ambil binary dari releases GitHub LDC. ([GitHub][7])

**Offline / mirror:** clone repos `dmd`, `phobos`, `druntime`, `ldc` dan simpan tarball release. Simpan dokumentasi spec & tour HTML ke koleksi pribadi.

---

# Persyaratan & identitas teknis untuk memodifikasi / membangun D toolchain

**Apa bahasa implementasi masing-masing compiler / runtime:**

* **DMD:** frontend & sebagian besar sekarang ditulis dalam **D** (project self-hosted). Repo: `github.com/dlang/dmd`. ([GitHub][6])
* **LDC:** menggunakan frontend DMD (untuk parsing/semantic) dan **LLVM** untuk backend (C++ libs). Repo: `github.com/ldc-developers/ldc`. ([GitHub][7])
* **GDC:** frontend D dalam tree **GCC** (C/C++) — terintegrasi di GCC project. ([gdcproject.org][8])
* **Phobos / druntime:** implementasi library & runtime di repo yang sama (Phobos mostly D; druntime C/assembly + D interactions). ([GitHub][6])

**Dev environment minimal untuk kontributor / builder:**

* D compiler (DMD / LDC) untuk bootstrap, `dub` untuk build; alat build (CMake, make/ninja) bila membangun LDC; LLVM dev libs & headers apabila membangun LDC; toolchain C (gcc/clang) untuk linking runtime. Untuk debug/CI: git, Python, shell tools. ([GitHub][7])

**Kenapa relevan:** bila Anda berminat mengubah compiler, Anda harus mampu membaca source D dan memahami interaksi frontend/frontend-shared (DMD) dengan backend (LLVM atau GCC).

---

# Perintah CLI D penting — **kata-per-kata** (penjelasan tiap token)

Saya pilih perintah yang akan sering Anda pakai (compile/run/project).

---

## 1) `dmd hello.d` — compile dengan DMD

* `dmd` : executable (Digital Mars D compiler). ([GitHub][6])
* `hello.d` : file source D.
  **Apa yang terjadi:** DMD mem-compile `hello.d` → link dengan Phobos/druntime → hasilkan `hello` (exe) di current directory (atau `hello.exe` di Windows).
  **Catatan:** gunakan flag `-version=`, `-debug`, `-release`, `-O` untuk mengatur build mode.

---

## 2) `ldc2 -O3 -release main.d -of=prog` — compile dengan LDC (LLVM)

* `ldc2` : LDC compiler driver (LLVM-based). ([GitHub][7])
* `-O3` : optimization level 3 (aggressive).
* `-release` : kumpulan flag untuk optimisasi release (mis. disable debug asserts).
* `main.d` : input file.
* `-of=prog` : set output filename `prog`.
  **Gunakan ketika** Anda butuh perf tinggi dan optimisasi LLVM (profiling / PGO).

---

## 3) `dub init myapp` lalu `dub build`

* `dub` : package manager / build tool resmi. ([dub.pm][9])
* `init myapp` : inisialisasi project baru (buat `dub.json`/`dub.sdl` template).
* `build` : compile project dan dependency sesuai `dub.json`.
  **Alasan:** face-fit untuk project multi-module. `dub run` menjalankan binary hasil build.

---

## 4) `rdmd test.d` — run quickly

* `rdmd` : rapid dmd wrapper (cache & run) — mempermudah siklus edit→run. ([dlang.org][16])
* `test.d` : file.
  **Cocok untuk prototyping** — `rdmd` kompilasi bila perlu dan jalankan.

---

## 5) `dub add <package>` / `dub upgrade` — manage deps

* `dub add` : menambahkan dependency ke `dub.json` (note: `dub` versi CLI dan cara manajemen bisa berbeda). ([dub.pm][19])
  **Gunakan** untuk mengambil paket dari registry DUB atau local git.

---

## 6) `dscanner` / `dfmt` / `dcd` / `serve-d` — tools workflow

* `dscanner <path>` : scanning static code (style & issues). ([Homebrew Formulae][12])
* `dfmt -i file.d` : format file in-place (beta quality — backup recommended). ([GitHub][20])
* `dcd-server` : jalankan daemon autocomplete untuk editor. ([GitHub][14])
* `serve-d` : LSP server, integrasi editor modern. ([GitHub][15])

---

# Alasan ringkas kenapa setiap kategori sumber penting (summary)

* **Spec & Lang reference:** otoritatif—pakai ketika butuh kepastian bahasa/perilaku. ([dlang.org][3])
* **Tour & Tutorials:** jalur onboarding cepat & hands-on. ([tour.dlang.org][4])
* **DMD / LDC / GDC:** implementasi compiler — pilih sesuai kebutuhan: DMD (debug / bleeding features), LDC (optimasi/LLVM), GDC (GCC targets). ([GitHub][6])
* **Phobos & druntime:** standard library & runtime — inti pemrograman D. ([dlang.org][2])
* **DUB & tools (rdmd, dscanner, dfmt, DCD, serve-d):** workflow modern (dependency, formatting, linting, editor support). ([dub.pm][9])
* **Buku & community (Alexandrescu, D Wiki):** konteks desain dan praktik idiomatik serta recipes real-world. ([ptgmedia.pearsoncmg.com][10])

---

# Rekomendasi langkah-langkah pembelajaran yang direkomendasikan (ringkas & berurutan)

Di bawah ini adalah **daftar ringkas** (actionable) yang menunjukkan urutan prioritas belajar — langsung bisa diikuti oleh pelajar baru sampai menengah. Setiap langkah disertai tujuan singkat.

1. **Instal toolchain** — pasang DMD (atau gunakan script `curl https://dlang.org/install.sh | bash`) dan DUB.
   *Tujuan:* punya compiler & package manager untuk praktek. ([dlang.org][17])

2. **Baca *Tour of D* (tour.dlang.org)** + kerjakan semua contoh interaktif (Hello, types, arrays, ranges, templates).
   *Tujuan:* pemahaman cepat fitur khas D (CTFE, UFCS, ranges). ([tour.dlang.org][4])

3. **Buat project kecil dengan DUB** (`dub init myapp` → `dub build` → `dub run`) — sederhana CLI tools (parsing argumen, file I/O).
   *Tujuan:* pahami workflow projek, struktur paket, dan dependency.

4. **Pelajari Phobos (std) modul yang sering dipakai:** `std.stdio`, `std.algorithm`, `std.range`, `std.digest`, `std.json`.
   *Tujuan:* tahu API umum & idiom range/algorithms. ([dlang.org][2])

5. **Pelajari memory model & runtime:** konsep GC, `@safe`/`@trusted`/`@system`, dan *BetterC* subset.
   *Tujuan:* menilai trade-off GC vs manual (systems programming). ([Wikipedia][21])

6. **Mulai praktik: project nyata** — buat CLI yang memproses file (parsing + concurrency), atau binding C library (FFI).
   *Tujuan:* menguji interoperabilitas dan performa.

7. **Pelajari metaprogramming & CTFE** — templates, mixins, `static if`, `enum` as compile-time values.
   *Tujuan:* gunakan kekuatan kompilasi waktu untuk generate code & optimisasi.

8. **Pelajari build untuk produksi:** gunakan LDC (`ldc2`) untuk release builds, pelajari opsi `-O`/`-release`/linker flags, buat CI (dub.json build scripts).
   *Tujuan:* menghasilkan binari teroptimasi & stabil. ([GitHub][7])

9. **Tooling & workflow editor:** pasang `serve-d` / `DCD` / LSP + `dfmt` + `dscanner` → integrasikan ke Neovim/Helix atau VSCode.
   *Tujuan:* pengalaman development produktif (auto-complete, diagnostics, format). ([GitHub][15])

10. **Baca buku Alexandrescu & kontributor advanced:** pelajari idiom, design choices, contract programming. Mulai kontribusi ke library (Phobos) atau bugfix di compiler.
    *Tujuan:* naik ke tingkat advanced (library design & compiler internals). ([ptgmedia.pearsoncmg.com][10])

---

# Waktu & rancangan singkat belajar (contoh 3 bulan)

* Minggu 0–2: Setup toolchain, Tour D, Hello projects.
* Bulan 1: Phobos basics, DUB project CLI, unit tests.
* Bulan 2: CTFE, templates, mixin, FFI sederhana (C binding), mulai pakai LDC untuk release.
* Bulan 3: Contribute docs/tests, pelajari druntime/Phobos internals, optimisasi & profiling.

---

# Referensi utama (sitasi ringkas)

* D official — [https://dlang.org/](https://dlang.org/) . ([dlang.org][1])
* D language spec / intro — [https://dlang.org/spec/intro.html](https://dlang.org/spec/intro.html). ([dlang.org][3])
* Tour — [https://tour.dlang.org/](https://tour.dlang.org/) . ([tour.dlang.org][4])
* Downloads (DMD/LDC/GDC) — [https://dlang.org/download.html](https://dlang.org/download.html) . ([dlang.org][17])
* DMD repo (reference compiler) — [https://github.com/dlang/dmd](https://github.com/dlang/dmd) . ([GitHub][6])
* LDC repo (LLVM-based) — [https://github.com/ldc-developers/ldc](https://github.com/ldc-developers/ldc) . ([GitHub][7])
* Phobos stdlib — [https://dlang.org/phobos/](https://dlang.org/phobos/) and [https://github.com/dlang/phobos](https://github.com/dlang/phobos) . ([dlang.org][2])
* DUB package manager — [https://dub.pm/](https://dub.pm/) . ([dub.pm][9])
* Tools: D-Scanner ([https://github.com/dlang-community/D-Scanner](https://github.com/dlang-community/D-Scanner)), dfmt ([https://github.com/dlang-community/dfmt](https://github.com/dlang-community/dfmt)), DCD ([https://github.com/dlang-community/DCD](https://github.com/dlang-community/DCD)), serve-d ([https://github.com/Pure-D/serve-d](https://github.com/Pure-D/serve-d)). ([Homebrew Formulae][12])
* Buku: *The D Programming Language* — Andrei Alexandrescu (publisher) — referensi buku. ([ptgmedia.pearsoncmg.com][10])

---

<!-- Jika Anda ingin **saya ekspor** semua ini ke file Markdown / CSV untuk arsip lokal (link clickable + ringkasan) atau **skrip bash** untuk mengunduh installer & clone repo (DMD, LDC, Phobos, druntime, DUB) ke folder `~/docs/dlang/`, saya buatkan langsung lengkap dengan penjelasan **kata-per-kata** untuk setiap baris skrip. Juga saya bisa menambahkan **roadmap mingguan 12-minggu** terperinci beserta latihan praktis dan contoh proyek (CLI, binding C, web server kecil dengan vibe.d jika mau). Mana yang Anda ingin saya buat sekarang? -->

[1]: https://dlang.org/?utm_source=chatgpt.com "D Programming Language: Home"
[2]: https://dlang.org/phobos/?utm_source=chatgpt.com "Phobos Runtime Library"
[3]: https://dlang.org/spec/intro.html?utm_source=chatgpt.com "Introduction"
[4]: https://tour.dlang.org/?utm_source=chatgpt.com "Dlang Tour - D Programming Language"
[5]: https://dlang.org/dmd.html?utm_source=chatgpt.com "DMD Compiler for Linux"
[6]: https://github.com/dlang/dmd "GitHub - dlang/dmd: dmd D Programming Language compiler"
[7]: https://github.com/ldc-developers/ldc "GitHub - ldc-developers/ldc: The LLVM-based D Compiler."
[8]: https://gdcproject.org/documentation?utm_source=chatgpt.com "GDC - D Programming Language for GCC"
[9]: https://dub.pm/?utm_source=chatgpt.com "Intro to DUB - DUB Documentation"
[10]: https://ptgmedia.pearsoncmg.com/images/9780321635365/samplepages/0321635361.pdf?utm_source=chatgpt.com "0321635361.pdf"
[11]: https://wiki.dlang.org/Using_LDC?utm_source=chatgpt.com "Using LDC - D Wiki"
[12]: https://formulae.brew.sh/formula/dscanner?utm_source=chatgpt.com "dscanner"
[13]: https://github.com/dlang-community/dfmt?utm_source=chatgpt.com "dlang-community/dfmt: Dfmt is a formatter for D source code"
[14]: https://github.com/dlang-community/DCD?utm_source=chatgpt.com "dlang-community/DCD: The D Completion Daemon is an ..."
[15]: https://github.com/Pure-D/serve-d?utm_source=chatgpt.com "Pure-D/serve-d: D LSP server (dlang language ..."
[16]: https://dlang.org/rdmd.html?utm_source=chatgpt.com "rdmd"
[17]: https://dlang.org/download.html?utm_source=chatgpt.com "Downloads"
[18]: https://man.archlinux.org/man/dmd.1.en?utm_source=chatgpt.com "dmd(1) - Arch manual pages"
[19]: https://dub.pm/dub-reference/package_settings/?utm_source=chatgpt.com "Package settings - DUB Documentation"
[20]: https://github.com/dlang-community/dfmt/releases?utm_source=chatgpt.com "Releases · dlang-community/dfmt"
[21]: https://en.wikipedia.org/wiki/D_%28programming_language%29?utm_source=chatgpt.com "D (programming language)"
