
# Tabel komprehensif: **Machine code / Binary** — (online → offline → CLI + identity teknis + instalasi)

Berikut daftar sumber, tools, dokumentasi, dan artefak yang wajib dimiliki untuk memahami *machine code / binary* secara mendalam — mencakup ISA (instruction set), spesifikasi format file objek, toolchain assembler/linker, disassembler/decompiler, emulasi & instrumentation, analisis statis/dinamis, dan referensi belajar (buku & kursus). Untuk tiap entri saya sertakan: **resource (judul)** → **cara akses online (apa cari / URL)** → **file offline / cara simpan** → **perintah CLI & instalasi (contoh Arch Linux + alternatif Debian/Ubuntu)** → **identitas teknis (bahasa/req build)** → **catatan penting**.
Catatan penting sebelum membaca: tidak mungkin “menyertakan *every* single resource di seluruh internet” secara literal — namun daftar di bawah mengumpulkan **sumber otoritatif, spesifikasi resmi, toolkit industri, dan buku/guide yang paling relevan** untuk pendidikan, pembangunan tooling, dan riset. Sumber inti yang menjadi fondasi: manual arsitektur prosesor (Intel / AMD / ARM / RISC-V), ELF/PE/Mach-O & ABI spec, DWARF, GNU Binutils & toolchain, disassembler/decompiler (Ghidra, radare2, Capstone), emulator (QEMU), dan framework analisis (angr, pwntools). Untuk referensi cepat: Intel / AMD ISA, ELF spec, DWARF, Ghidra adalah pilar utama. ([Intel][1])

> Format: setiap baris tabel panjang — baca per-bagian. Jika Anda ingin saya ekspor ini menjadi **Markdown file**, **CSV**, atau **README** siap-simpan, saya akan buatkan langsung.

---

## Tabel ringkas (kategori → resource → online → offline → instalasi contoh → bahasa / build req → catatan)

> Untuk tiap baris saya sertakan sitasi ke dokumentasi resmi atau halaman proyek (klik pada sitasi saat tersedia).

### 1) ISA (Instruction Set Architectures) — **sumber otoritatif**

* **Intel® 64 & IA-32 Software Developer’s Manual** — instruction set + system programming (Volume 1..4 / 10-volume).
  Online: halaman Intel manuals (unduh PDF volumes). ([Intel][1])
  Offline: unduh volumes (PDF). Contoh `wget <intel-sdm-vol-2.pdf>`.
  Instal (tidak perlu paket): hanya simpan PDF; untuk dev: butuh toolchain C (gcc, make) bila ingin eksperimen microcode / OS dev.
  Identitas: dokumen resmi Intel.
  Catatan: **sumber utama** untuk encoding instruksi x86/x86-64, mode, privilege, MSR, dan extensions. ([Intel][1])

* **AMD64 Architecture Programmer’s Manual (Volumes 1–5)** — AMD x86-64 reference.
  Online: situs docs.amd.com (PDF). ([Dokumen AMD][2])
  Offline: unduh PDF.
  Identitas: dok. resmi AMD — penting jika target CPU AMD (SSE, AVX, system programming). ([Dokumen AMD][2])

* **ARM Architecture Reference Manual (ARMv7 / ARMv8)** — ARM ISA & AArch64.
  Online: ARM ARM PDFs (ARM Ltd / Arm Holdings). ([ARM Documentation Service][3])
  Offline: unduh PDF (ARMv8-A, ARMv7).
  Identitas: dok. resmi Arm — wajib untuk embedded / mobile / SoC. ([ARM Documentation Service][3])

* **RISC-V Ratified Specifications** — open ISA (base + extensions).
  Online: riscv.org/specifications (PDFs). ([RISC-V International][4])
  Offline: unduh spesifikasi (User ISA, Privileged spec, ABI).
  Identitas: open spec — baik untuk riset, custom cores, dan akademik. ([RISC-V International][4])

---

### 2) Format file objek / executable / ABI

* **ELF (Executable and Linking Format) spec & Linux Foundation refspecs** — System V / LSB / ELF canonical docs.
  Online: refspecs.linuxfoundation.org (ELF PDF / ABI). ([Spesifikasi Referensi Linux Foundation][5])
  Offline: unduh `elf.pdf` / ABI docs.
  Instal CLI tools untuk inspeksi: `readelf`, `objdump` (binutils).
  Arch: `sudo pacman -S binutils` — Debian/Ubuntu: `sudo apt install binutils`.
  Identitas: dokumen resmi ELF / ABI.
  Catatan: pahami header ELF, program header vs section header, symbol table, relocations, dynamic linking. ([Spesifikasi Referensi Linux Foundation][5])

* **PE / COFF (Portable Executable) — Microsoft docs**
  Online: Microsoft PE format docs (MSDN / docs.microsoft.com). ([Microsoft Learn][6])
  Offline: simpan halaman PDF/HTML.
  Tools: `objdump`/`readpe`/PE-viewers (Linux: `objdump -m i386 -b pe` kadang; ada `pefile` Python).
  Instal: Arch: `sudo pacman -S mingw-w64-tools` (untuk Windows PE tools) + `pefile` pip. Debian: `sudo apt install python3-pefile`.
  Identitas: Microsoft specification; wajib untuk reverse-engineering Windows binaries. ([Microsoft Learn][6])

* **Mach-O (macOS)** — Apple developer docs / Mach-O format references.
  Online: Apple docs & Darwin source / `mach-o` manpages. (Cari “Mach-O file format”).
  Offline: simpan docs; tools: `otool`, `dyldinfo`.
  Instal: Arch: `sudo pacman -S llvm` (untuk `llvm-objdump`), Debian: `sudo apt install llvm-binutils`.

* **RISC-V ELF/PSABI** — RISCV ELF PSABI docs (riscv-elf-psabi). ([D3S][7])

---

### 3) Debug info / unwind / ABI metadata

* **DWARF (Debugging Standard)** — versions (v4,v5,v6). Dokumentasi & PDF di dwarfstd.org. ([Dwarfstd][8])
  Offline: unduh DWARF spec PDF.
  Tools: read DWARF via `objdump --dwarf=info`, `readelf --debug-dump=info`, `eu-readelf` (elfutils).
  Instal Arch: `sudo pacman -S elfutils binutils` ; Debian: `sudo apt install elfutils binutils`.
  Identitas: format independen arsitektur untuk source-level debug mapping. ([Dwarfstd][8])

---

### 4) Toolchain: assembler, compiler, linker, binutils

* **GNU Binutils (objdump, readelf, nm, objcopy, strip, ld)** — dokumentasi & manual. ([GNU][9])
  Instal Arch: `sudo pacman -S binutils` ; Debian/Ubuntu: `sudo apt install binutils`.
  Identitas: C/C++ (GNU) tools ditulis mayoritas C; build: autotools / make.
  Catatan: `readelf` untuk ELF inspect, `objdump -d` untuk disassembly, `objcopy` untuk convert format, `nm` untuk symbol. ([GNU][9])

* **GCC / GNU toolchain** — compiler & linker front-end.
  Instal Arch: `sudo pacman -S gcc` ; Debian: `sudo apt install build-essential`.
  Identitas: GCC (C/C++), toolchain C/C++ (C implementation). ([LLVM][10])

* **LLVM / Clang** — alternative modern toolchain (clang/llvm/llc/llvm-objdump). ([LLVM][11])
  Instal Arch: `sudo pacman -S llvm clang` ; Debian: `sudo apt install llvm clang`.
  Identitas: C++ (LLVM codebase), useful untuk IR-level analysis (LLVM IR).

* **Assembler: GAS (GNU as) dan NASM** — manual & docs. ([Sourceware][12])
  Instal Arch: `sudo pacman -S nasm` + `sudo pacman -S binutils` ; Debian: `sudo apt install nasm binutils`.
  Identitas: GAS (bagian dari binutils, ditulis C), NASM (C) — dua sintaks populer (AT&T vs Intel). ([Sourceware][12])

---

### 5) Disassemblers, decompilers, reversing tools

* **Ghidra (NSA)** — open-source SRE suite (disasm + decompiler + scripting).
  Online: ghidra-sre.org / GitHub repo. Instal via unduh zip atau `git clone` GitHub. ([Ghidra][13])
  Offline: simpan distribusi (zip/tar), butuh JDK 11+.
  Arch: tidak di-pkg resmi; unduh & jalankan (butuh `openjdk`). Debian: `sudo apt install default-jdk` lalu unduh Ghidra.
  Identitas teknis: Java (UI & core), plugin C/C++ (some native libs), scripting (Java/Python/Jython). ([Ghidra][13])

* **radare2 / r2 / Cutter / iaito / rizin** — CLI/TUI/GUI reversing toolkit (C).
  Online: rada.re / GitHub. ([rada.re][14])
  Instal Arch: `sudo pacman -S radare2` (atau `rizin` fork) ; Debian: `sudo apt install radare2`.
  Identitas: C / C++ ; build via meson/cmake in modern releases. ([rada.re][14])

* **Capstone (disassembly engine)** — API multi-arch (C, bindings Python/Go/JS). ([capstone-engine.org][15])
  Instal Arch: `sudo pacman -S capstone` (paket) atau `pip install capstone` (binding Python). Debian: `sudo apt install libcapstone-dev python3-capstone`.
  Identitas: C core + language bindings. Berguna sebagai engine di banyak tools (radare2, keystone, unicorn integrasi). ([GitHub][16])

* **IDA Pro / Binary Ninja / Hopper** — komersial/proprietary reversing (jika butuh fitur advanced & plugin ecosystem). Lihat situs vendor. (tidak selalu gratis).

---

### 6) Dynamic analysis / emulation / instrumentation

* **QEMU** — full system & user-mode emulation; berguna untuk menjalankan binaries ARCh-diff. ([qemu.org][17])
  Instal Arch: `sudo pacman -S qemu` ; Debian: `sudo apt install qemu`.
  Identitas: C; build dengan configure/make. ([qemu.org][18])

* **Unicorn Engine** — CPU emulation framework (fork dari QEMU dynasm, C). Instal via paket atau pip.

* **PIN (Intel Pin)** & **DynamoRIO** — dynamic instrumentation frameworks (binary instrumentation, research). Cari situs resmi Intel Pin / DynamoRIO.

---

### 7) Binary analysis & automation frameworks (security / research)

* **angr** — symbolic + binary analysis (Python). Instal: `pip install angr`. (Dok: angr's docs).
* **pwntools** — exploitation helper library (Python). `pip install pwntools`.
* **radare2/rax** + **r2pipe** — scripting interface. ([GitHub][19])

---

### 8) Low-level utilities (hexdump, strings, binwalk, elfutils)

* **hexdump / xxd / bvi / bless** — hex editors. Arch: `sudo pacman -S vim` (xxd included) / `sudo pacman -S bless` ; Deb: `sudo apt install xxd bless`.
* **strings** (binutils/grep-utils), **binwalk** (for firmware reverse).
* **elfutils (eu-readelf, eu-objdump)** — Arch: `sudo pacman -S elfutils` ; Debian: `sudo apt install elfutils`.

---

### 9) Symbol/ABI/Calling conventions references

* **System V AMD64 ABI** — calling conventions for x86_64 Unix. (Cari “System V AMD64 ABI” PDF).
* **Microsoft x64 calling convention** — Microsoft docs.

---

### 10) Reference books & learning resources (buku & tutorial penting)

* **Computer Systems: A Programmer’s Perspective (CS:APP)** — fundamental bridge between C/assembly & machine. (Buku).
* **The Art of Assembly Language (Randall Hyde)** — assembly programming and concepts.
* **Hacker’s Delight** — bit hacks & numeric algorithms.
* **Reverse Engineering for Beginners** (Dennis Yurichev) — gratis PDF & sumber.
* **Practical Reverse Engineering** — commercial book.
  Cari PDF / beli buku di penerbit; beberapa tersedia gratis/legally mirrored. (contoh: CS:APP / official site).

---

## Petunjuk offline & cara mengarsipkan (mirroring)

* **Unduh PDF resmi** (ISA / ELF / DWARF): gunakan `wget` atau `curl` ke URL resmi (contoh: Intel SDM volumes, AMD PDFs, ELF refspecs, DWARF). Simpan di folder `~/docs/binary/`.
  Contoh: `wget -P ~/docs/binary/ "https://www.intel.com/content/dam/develop/external/us/en/documents/intel-sdm-vol-2abcd.pdf"` (ganti URL nyata). ([Intel CDRD][20])
* **Clone repositories** (tools/source):

  * Ghidra: `git clone https://github.com/NationalSecurityAgency/ghidra.git`. ([GitHub][21])
  * radare2: `git clone https://github.com/radareorg/radare2.git`. ([GitHub][19])
* **Docset offline**: gunakan Zeal / DevDocs / Dash untuk mengunduh docsets (ELF, DWARF, Intel docs jika tersedia). (DevDocs & Zeal).

---

## Perintah CLI penting — **penjelasan kata-per-kata** (kata-per-kata untuk perintah yang sering dipakai)

Saya pilih beberapa perintah inti dan jelaskan token demi token (bahasa Indonesia teknis).

1. `readelf -h ./program` — lihat ELF header.

   * `readelf` : program CLI untuk membaca struktur ELF (bagian dari binutils/elfutils). ([man7.org][22])
   * `-h` : flag, singkatan *header* — menampilkan ELF header (entry point, class (32/64), endianness).
   * `./program` : path ke file target (relatif).
     Contoh keluaran: `ELF Header: Class: ELF64, Data: 2's complement, little endian, Version: 1, OS/ABI: UNIX - System V, Entry point: 0x400540`.

2. `objdump -d -M intel ./program > program.s` — disassemble ke assembly Intel syntax.

   * `objdump` : binutils disassembler/inspector. ([Sourceware][23])
   * `-d` : perintah untuk *disassemble* semua sections yang dieksekusi.
   * `-M intel` : opsi untuk memformat keluaran sebagai Intel-syntax (bukan default AT&T).
   * `./program` : file target (ELF/obj).
   * `> program.s` : shell redirection; simpan keluaran ke file `program.s`.
     Catatan: gunakan `-D` untuk disassemble *semua* sections termasuk data.

3. `objcopy -O binary a.out a.bin` — ekstrak image biner mentah.

   * `objcopy` : copy/translate object files (binutils).
   * `-O binary` : output format = raw binary (tanpa header).
   * `a.out` : input file.
   * `a.bin` : output file binary.

4. `gdb ./program` lalu `break main` / `run` / `disas /r $pc`

   * `gdb` : GNU Debugger. ([Sourceware][24])
   * `break main` : set breakpoint di simbol `main`.
   * `run` : jalankan program dalam gdb.
   * `disas /r $pc` : disassemble instruksi di program counter (raw bytes).

5. `strings firmware.bin | rg -i password`

   * `strings` : mengekstrak substring printable dari file biner.
   * `|` : pipe, kirim output ke program selanjutnya.
   * `rg -i password` : ripgrep mencari kata `password` tanpa case sensitive.

6. `git clone https://github.com/NationalSecurityAgency/ghidra.git` — clone repo Ghidra.

   * `git` : version control CLI.
   * `clone` : verb untuk menyalin repo remote ke lokal.
   * URL : lokasi repo.

Jika Anda ingin penjelasan kata-per-kata untuk tiap perintah daftar lengkap saya (puluhan perintah), saya akan jabarkan semuanya dalam format referensi singkat.

---

## Instalasi ringkas (perintah contoh) — **Arch Linux** vs **Debian/Ubuntu**

* Binutils / readelf / objdump / nm / objcopy:

  * Arch: `sudo pacman -S binutils`
  * Debian: `sudo apt update && sudo apt install binutils`
  * Penjelasan: `sudo` (hak root), `pacman -S` (install pacman), `apt install` (apt package manager).
* nasm: `sudo pacman -S nasm` / `sudo apt install nasm`. ([nasm.us][25])
* capstone: `sudo pacman -S capstone` or `pip install capstone` (bindings). ([GitHub][16])
* qemu: `sudo pacman -S qemu` / `sudo apt install qemu qemu-user qemu-user-static`. ([qemu.org][17])
* radare2: `sudo pacman -S radare2` / `sudo apt install radare2`. ([GitHub][19])
* ghidra: unduh dari website → butuh JDK 11: `sudo pacman -S jdk-openjdk` ; Debian: `sudo apt install default-jdk` lalu unzip Ghidra. ([Ghidra][13])

---

## Rekomendasi urutan belajar (praktis, untuk jadi ahli binary / reverse / low-level dev)

1. **Dasar arsitektur & ISA**: baca ringkasan Intel/AMD/ARM/RISC-V (pilih 1 ISA untuk mulai; x86_64 umum). ([Intel][1])
2. **Format executable & ABI**: pelajari ELF (Linux) & System V ABI; jika target Windows, pelajari PE/COFF. ([Spesifikasi Referensi Linux Foundation][5])
3. **Toolchain & Assembler**: praktekkan assembler (NASM / GAS), compile & link (GCC/LLVM), dan inspeksi hasil (`objdump`, `readelf`). ([nasm.us][25])
4. **Debugging & DWARF**: belajar GDB & DWARF debug info mapping (source ↔ machine). ([Sourceware][24])
5. **Disassembly & Decompilation**: gunakan Capstone, radare2 dan Ghidra; pelajari scripting untuk automasi. ([GitHub][16])
6. **Emulasi & dynamic analysis**: QEMU, Unicorn, Pin / DynamoRIO untuk instrumentasi. ([qemu.org][17])
7. **Advanced analysis**: angr, symbolic execution, exploit dev practice (legal CTF).
8. **Baca buku**: CS:APP → Art of Assembly → Hacker’s Delight → Reverse Engineering for Beginners.

---

## Sumber utama & sitasi ringkas (pilih-pilih, paling relevan)

* Intel® 64 & IA-32 Architectures Software Developer’s Manual (official). ([Intel][1])
* AMD64 Architecture Programmer’s Manual (official). ([Dokumen AMD][2])
* ARM Architecture Reference Manual (ARMv7/ARMv8). ([ARM Documentation Service][3])
* RISC-V Ratified Specifications (riscv.org). ([RISC-V International][4])
* ELF Specification (Linux Foundation / refspecs). ([Spesifikasi Referensi Linux Foundation][5])
* PE / COFF docs — Microsoft docs. ([Microsoft Learn][6])
* DWARF Debugging Standard (dwarfstd.org). ([Dwarfstd][8])
* GNU Binutils docs (objdump / readelf). ([GNU][9])
* Ghidra (NSA) — GitHub & ghidra-sre.org. ([GitHub][21])
* radare2 / r2 / rizin official. ([GitHub][19])
* Capstone engine. ([capstone-engine.org][15])
* QEMU docs. ([qemu.org][17])
* NASM documentation. ([nasm.us][25])
* GDB docs. ([Sourceware][24])

---

## Catatan etika & legal

* Banyak teknik SRE / binary analysis dapat digunakan untuk tujuan baik (forensik, debugging, hardening) dan buruk (reverse-engineering ilegal, circumvention). **Patuhi hukum lokal & lisensi perangkat lunak**, gunakan sandbox / VM, dan jangan mencoba membongkar software berlisensi tanpa izin. Jika perlu saya sertakan panduan etika dan sandboxing (qemu snapshots, seccomp, docker) untuk eksperimen yang aman.

---
<!---->
<!-- ## Penutup & opsi output -->
<!---->
<!-- Saya telah mengumpulkan dan merangkum semua sumber otoritatif dan toolkit penting (ISA manuals, format file, DWARF, binutils, toolchain, reversing frameworks, emulator, dan buku referensi) beserta langkah-langkah instalasi contoh dan penjelasan perintah inti kata-per-kata. Jika Anda ingin saya: -->
<!---->
<!-- 1. **Ekspor tabel ini ke Markdown / CSV / README** siap simpan — saya hasilkan file dan lampirkan. -->
<!-- 2. **Jabarkan perintah CLI kata-per-kata** untuk seluruh daftar (lebih dari 50 perintah) — saya buat sebagai referensi single-page. -->
<!-- 3. **Susun rencana belajar mingguan** (terperinci, dengan praktik hands-on: latihan assembly, disassembly, debugging, CTF) — saya rancang sesuai jadwal belajar Anda. -->
<!-- 4. **Berikan skrip otomatis** (bash) untuk mengunduh & mengarsipkan semua PDF & git repos di atas ke satu folder (backup offline) — saya bisa sediakan. -->
<!---->
<!-- Beritahu nomor opsi (1–4) atau langsung sebutkan output yang Anda inginkan — saya akan buatkan langsung (tanpa menunggu). -->
<!---->
[1]: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html?utm_source=chatgpt.com "Manuals for Intel® 64 and IA-32 Architectures"
[2]: https://docs.amd.com/v/u/en-US/40332-PUB_4.08?utm_source=chatgpt.com "AMD64 Architecture Programmer's Manual, Volumes 1-5 ..."
[3]: https://documentation-service.arm.com/static/5fad51cbca04df4095c1c905?utm_source=chatgpt.com "ARM Architecture Reference Manual Supplement ARMv8, ..."
[4]: https://riscv.org/specifications/ratified/?utm_source=chatgpt.com "RISC-V Ratified Specifications"
[5]: https://refspecs.linuxfoundation.org/elf/elf.pdf?utm_source=chatgpt.com "Tool Interface Standard (TIS) Executable and Linking ..."
[6]: https://learn.microsoft.com/en-us/windows/win32/debug/pe-format?utm_source=chatgpt.com "PE Format - Win32 apps"
[7]: https://d3s.mff.cuni.cz/files/teaching/nswi200/202324/doc/riscv-abi.pdf?utm_source=chatgpt.com "RISC-V ABIs Specification"
[8]: https://dwarfstd.org/?utm_source=chatgpt.com "DWARF Debugging Information Format"
[9]: https://www.gnu.org/software/binutils/?utm_source=chatgpt.com "Binutils - GNU Project - Free Software Foundation"
[10]: https://llvm.org/docs/GettingStarted.html?utm_source=chatgpt.com "Getting Started with the LLVM System"
[11]: https://llvm.org/docs/?utm_source=chatgpt.com "About — LLVM 22.0.0git documentation"
[12]: https://sourceware.org/binutils/docs/as/?utm_source=chatgpt.com "Top (Using as)"
[13]: https://ghidra.net/?utm_source=chatgpt.com "Ghidra"
[14]: https://rada.re/?utm_source=chatgpt.com "radare.org"
[15]: https://www.capstone-engine.org/?utm_source=chatgpt.com "The Ultimate Disassembly Framework – Capstone – The ..."
[16]: https://github.com/capstone-engine/capstone?utm_source=chatgpt.com "capstone-engine/capstone"
[17]: https://www.qemu.org/?utm_source=chatgpt.com "QEMU"
[18]: https://www.qemu.org/docs/master/?utm_source=chatgpt.com "Welcome to QEMU's documentation!"
[19]: https://github.com/radareorg/radare2?utm_source=chatgpt.com "radareorg/radare2: UNIX-like reverse engineering ..."
[20]: https://cdrdv2-public.intel.com/825743/325462-sdm-vol-1-2abcd-3abcd-4.pdf?utm_source=chatgpt.com "Intel® 64 and IA-32 Architectures Software Developer's ..."
[21]: https://github.com/NationalSecurityAgency/ghidra?utm_source=chatgpt.com "Ghidra is a software reverse engineering (SRE) framework"
[22]: https://man7.org/linux/man-pages/man1/readelf.1.html?utm_source=chatgpt.com "readelf(1) - Linux manual page"
[23]: https://sourceware.org/binutils/docs/binutils/objdump.html?utm_source=chatgpt.com "objdump (GNU Binary Utilities)"
[24]: https://sourceware.org/gdb/?utm_source=chatgpt.com "GDB: The GNU Project Debugger"
[25]: https://www.nasm.us/doc/?utm_source=chatgpt.com "The Netwide Assembler"
