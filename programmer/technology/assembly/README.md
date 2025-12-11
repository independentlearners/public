Di bawah ini  **kompilasi paling lengkap** yang bisa disusun untuk sumber belajar **Assembly** mencakup **x86**, **x86-64**, **ARM (A32/T32/A64)**, **RISC-V**, dan **MIPS**.
Struktur dibuat sama seperti daftar Anda untuk memudahkan “referensi seumur hidup”.
Ini adalah **daftar sumber resmi + dokumentasi primer + buku gratis + manual arsitektur + toolchain** yang secara praktis digunakan dalam low-level programming, reverse engineering, OSDev, emulator, sampai arsitektur CPU.

Kita memastikan **tidak ada sumber penting yang tertinggal**: manual vendor, ISA spec resmi, toolchain, assembler, disassembler, buku universitas, OSDev, debugging, ABI, ELF, calling conventions, dan referensi instruksi.

---

# 1. ARCHITECTURE-SPECIFIC (RESMI)

## 1.1 Intel x86 / x86-64 (RESMI)

| Resource                                                           | Online                                                                  | Offline                  | Kategori                         | Kenapa penting                                                    |
| ------------------------------------------------------------------ | ----------------------------------------------------------------------- | ------------------------ | -------------------------------- | ----------------------------------------------------------------- |
| Intel® 64 and IA-32 Architectures Software Developer Manuals (SDM) | intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html | PDF lengkap semua volume | Official ISA & microarchitecture | Referensi absolut instruksi, register, mode proteksi, paging, VMX |
| Intel Optimization Manual                                          | intel.com/.../optimization-manual.html                                  | PDF                      | Performance                      | Optimasi pipeline, cache, branch predictor                        |
| Intel Intrinsics Guide                                             | software.intel.com/sites/landingpage/IntrinsicsGuide/                   | Offline HTML             | SIMD                             | Referensi SSE–AVX–AVX-512                                         |
| Intel XED Instruction Encoder/Decoder                              | intelxed.github.io                                                      | Source                   | Disassembly/encoding             | Tool open-source untuk mempelajari encoding biner instruksi       |

## 1.2 AMD64 Architecture (RESMI)

| Resource                                         | Online                                                | Offline |               |
| ------------------------------------------------ | ----------------------------------------------------- | ------- | ------------- |
| AMD64 Architecture Programmer’s Manual (vol 1–5) | developer.amd.com/resources/developer-guides-manuals/ | PDF     | ISA resmi AMD |

---

# 2. ARM ARCHITECTURE (ARMv7/AArch32/AArch64)

| Resource                                         | Online                          | Offline |           |
| ------------------------------------------------ | ------------------------------- | ------- | --------- |
| ARM Architecture Reference Manual (A32/T32/A64)  | developer.arm.com/documentation | PDF     | ISA resmi |
| ARM Cortex-A Series Programmer Guide             | developer.arm.com/documentation | PDF     |           |
| ARM Architecture Procedure Call Standard (AAPCS) | developer.arm.com/documentation | PDF     |           |
| ARM System Registers                             | developer.arm.com/documentation | HTML    |           |
| ARM Instruction Set Quick Reference              | infocenter.arm.com              | PDF     |           |

---

# 3. RISC-V (RESMI)

| Resource                                          | Online                                       | Offline  |           |
| ------------------------------------------------- | -------------------------------------------- | -------- | --------- |
| The RISC-V Instruction Set Manual (Volume I & II) | riscv.org/technical/specifications           | PDF      | ISA resmi |
| RISC-V Reader (Waterman & Asanovic)               | free PDF at riscv.org                        | PDF      |           |
| RISC-V ELF psABI                                  | github.com/riscv-non-isa/riscv-elf-psabi-doc | Git repo |           |
| RISC-V Assembly Programmer's Handbook             | banyak mirror (resmi free)                   | PDF      |           |

---

# 4. MIPS (RESMI)

| Resource                                      | Online                          | Offline |     |
| --------------------------------------------- | ------------------------------- | ------- | --- |
| MIPS32 / MIPS64 Architecture Reference Manual | mips.com                        | PDF     | ISA |
| MIPS Instruction Set Reference                | mips.com/products/architectures | PDF     |     |
| MIPS ABI / calling conventions                | berbagai mirror                 | PDF     |     |

---

# 5. ASSEMBLER, LINKER, ABI, ELF

## GNU Binutils (Assembler GAS, LD, objdump, readelf)

| Resource                   | Online                                             | Offline  |             |
| -------------------------- | -------------------------------------------------- | -------- | ----------- |
| GAS (GNU Assembler) manual | sourceware.org/binutils/docs/as                    | HTML/PDF | Syntax AT&T |
| LD (linker) manual         | sourceware.org/binutils/docs/ld                    | HTML/PDF |             |
| Objdump manual             | sourceware.org/binutils/docs/binutils/objdump.html | HTML     |             |
| Readelf                    | sourceware.org                                     | HTML     |             |
| Binutils source            | sourceware.org/git/binutils-gdb.git                | Git      |             |

## NASM / YASM

| Resource    | Online                              | Offline  |
| ----------- | ----------------------------------- | -------- |
| NASM manual | nasm.us/doc/                        | HTML/PDF |
| YASM manual | yasm.tortall.net/Documentation.html | HTML     |

## LLVM / Clang / lld / lldb (Assembly & Disassembly)

| Resource                           | Online                                       | Offline       |
| ---------------------------------- | -------------------------------------------- | ------------- |
| LLVM Language Reference            | llvm.org/docs/LangRef.html                   | PDF buildable |
| LLVM MC (Machine Code & Assembler) | llvm.org/docs/CommandGuide/llvm-mc.html      | HTML          |
| llvm-objdump                       | llvm.org/docs/CommandGuide/llvm-objdump.html | HTML          |
| lldb debugger                      | llvm.org/docs/lldb.html                      | HTML          |

---

# 6. DEBUGGER & REVERSE ENGINEERING

## GDB

| Resource      | Online                                    | Offline  |
| ------------- | ----------------------------------------- | -------- |
| GDB manual    | sourceware.org/gdb/current/onlinedocs/gdb | HTML/PDF |
| GDB Internals | gnu.org/software/gdb/documentation        | PDF      |

## Radare2 / Cutter

| Resource     | Online                                  |
| ------------ | --------------------------------------- |
| radare2 book | radare.gitbooks.io/radare2book/content/ |
| Cutter docs  | cutter.re/docs                          |

## Capstone (Disassembler)

| Resource            | Online        |
| ------------------- | ------------- |
| capstone-engine.org | API reference |

## Keystone (Assembler)

| Resource            | Online        |
| ------------------- | ------------- |
| keystone-engine.org | API reference |

## Unicorn (CPU emulator)

| Resource           | Online           |
| ------------------ | ---------------- |
| unicorn-engine.org | Semua arsitektur |

---

# 7. OPERATING SYSTEM DEVELOPMENT (OSDev)

| Resource            | Online                                 |
| ------------------- | -------------------------------------- |
| OSDev Wiki          | osdev.org                              |
| Little OS Book      | littleosbook.github.io                 |
| Intel Boot Protocol | osdev.org/wiki/BIOS                    |
| Multiboot Spec      | gnu.org/software/grub/manual/multiboot |

---

# 8. BUKU GRATIS TERBAIK (NON-RESMI TAPI WAJIB)

## x86/x86-64

* Paul A. Carter — *PC Assembly Language* (free PDF)
* Bryant & O’Hallaron — *Computer Systems: A Programmer's Perspective*
* Randall Hyde — *The Art of Assembly Language* (HLA, free PDF lama)
* Wikibooks — *X86 Assembly*

## ARM

* *ARM Assembly Basics* — Azeria Labs
* *Think Like an ARM Programmer* — berbagai mirror
* Cortex-M Bare-Metal Programming (free PDF di banyak universitas)

## RISC-V

* *RISC-V Reader* (free)
* *Computer Organization and Design RISC-V Edition* (tidak gratis, tetapi standar)

## MIPS

* *See MIPS Run* (unggal free PDF)
* *Introduction to MIPS Assembly Language* (banyak universitas share)

---

# 9. ABI, CALLING CONVENTION, ELF, SYSTEM V ABI

| Resource                            | Link                                                        |
| ----------------------------------- | ----------------------------------------------------------- |
| System V ABI AMD64                  | github.com/ARM-software/abi-aa                              |
| System V ELF Specification          | refspecs.linuxfoundation.org/elf/                           |
| x86-64 Calling Convention (SysV)    | Cornell / WashU / CS:APP notes                              |
| Windows x64 calling convention      | docs.microsoft.com/en-us/cpp/build/x64-software-conventions |
| ARM Procedure Call Standard (AAPCS) | developer.arm.com/documentation                             |

---

# 10. TOOLCHAIN SEMUA ARSITEKTUR

## GCC Cross-Compiler (multi-arch)

Instruksi umum:

```
sudo pacman -S base-devel binutils gcc
sudo pacman -S clang lld lldb llvm
sudo pacman -S qemu-full
```

Cross-compiler manual:
[https://wiki.osdev.org/GCC_Cross-Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)

## QEMU (semua arsitektur)

* qemu.org
* Mendukung x86/x64, ARM, RISC-V, MIPS, PPC, SPARC
* Tool wajib untuk testing assembly low-level

## Renode (alternative for RISC-V & ARM)

* renode.io
* Simulator sistem embedded level tinggi

---

# 11. INDEX INSTRUKSI LENGKAP (TABEL SINGKAT)

| Arsitektur            | Manual Instruksi                    |
| --------------------- | ----------------------------------- |
| x86/x64               | Intel SDM Vol.2, AMD Vol.3          |
| ARMv7/A32             | ARM ARM (Architecture Ref Manual)   |
| ARM64/AArch64         | ARM ARM (A64)                       |
| RISC-V                | ISA Volume I (User-Level)           |
| MIPS                  | MIPS32/64 Instruction Set Reference |
| Universal disassembly | Capstone, objdump, llvm-objdump     |

---

# 12. Sumber Video (Kuliah Resmi)

* MIT 6.004 — Computation Structures (x86)
* Stanford CS107 — Computer Systems
* Berkeley CS61C — Great Ideas in Computer Architecture
* Georgia Tech — High Performance Computer Architecture (ARM)
* RISC-V official YT channel (tutorial ISA)

---

# 13. Forensik, Reverse Engineering, Malware

* Malware Unicorn — ARM & x86 reversing
* OpenSecurityTraining (OST2) — kursus assembly x86/x64 gratis
* Pwn.college — exploitation + assembly
* LiveOverflow — reverse engineering dasar → lanjutan

---

# 14. Sumber Terpenting yang WAJIB Diunduh

Checklist wajib:

[x] Intel SDM
[x] AMD64 Programmer Manual
[x] ARM ARM (A32/T32/A64)
[x] RISC-V ISA Vol I & II
[x] MIPS32/64 Instruction Set
[x] System V ABI
[x] Binutils manual (as, ld, objdump)
[x] LLVM MC & llvm-objdump
[x] OSDev wiki offline
[x] Shellcode cookbook (berbagai repo)
[x] QEMU
<!---->
<!-- Saya bisa buatkan **versi tabel markdown**, **versi CSV**, atau **versi “learning roadmap”** kalau Anda ingin lanjut. -->
<!---->
<!-- Anda ingin berikutnya apa? -->
<!---->
<!-- * Disassembly? -->
<!-- * ISA encoding? -->
<!-- * Shellcode? -->
<!-- * OSDev khusus arsitektur tertentu? -->
