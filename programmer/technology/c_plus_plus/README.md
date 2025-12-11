Di bawah ini kita susun **kompilasi sumber paling lengkap untuk C++**, dengan format yang sama seperti sebelumnya: **standar resmi → implementasi compiler → ABI → STL → toolchain → build system → debugging → metaprogramming → concurrency → OSDev → security → reverse engineering → HPC → literatur akademik → referensi wajib yang harus di-download.**
Tujuannya: **tidak ada satu pun sumber penting tentang C++ yang tertinggal.**

Struktur ini dirancang sebagai **“master list” seumur hidup** untuk seluruh pembelajaran C++ dari level dasar sampai tingkat compiler engineer.

---

# 1. STANDAR RESMI C++ (ISO/IEC)

| Standar                    | Link                                                                               | Keterangan                                    |
| -------------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------- |
| C++23 (ISO/IEC 14882:2023) | [https://www.iso.org/standard/82566.html](https://www.iso.org/standard/82566.html) | Final terbaru                                 |
| C++20 (ISO/IEC 14882:2020) | [https://www.iso.org/standard/79358.html](https://www.iso.org/standard/79358.html) | Standard besar: concepts, coroutines, modules |
| C++17                      | ISO                                                                                | Stability release                             |
| C++14                      | ISO                                                                                | Refinement                                    |
| C++11                      | ISO                                                                                | Revolution (move, threads, constexpr)         |
| C++03/C++98                | ISO                                                                                | Historical                                    |

## Draft gratis paling lengkap (dipakai seluruh komunitas C++)

| Nama                     | Link                                                                                 |
| ------------------------ | ------------------------------------------------------------------------------------ |
| WG21 Draft C++ Standard  | [https://eel.is/c++draft](https://eel.is/c++draft)                                   |
| Full WG21 document index | [https://www.open-std.org/jtc1/sc22/wg21/](https://www.open-std.org/jtc1/sc22/wg21/) |

WG21 di atas adalah **sumber pertama** yang digunakan oleh compiler engineer LLVM/GCC/MSVC.

---

# 2. IMPLEMENTASI COMPILER C++ (RESMI)

## 2.1 GCC (GNU C++)

| Resource            | Link                                                                                                                             |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| GCC C++ manual      | [https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Extensions.html](https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Extensions.html) |
| Standard compliance | [https://gcc.gnu.org/projects/cxx-status.html](https://gcc.gnu.org/projects/cxx-status.html)                                     |
| GCC internals       | [https://gcc.gnu.org/onlinedocs/gccint/](https://gcc.gnu.org/onlinedocs/gccint/)                                                 |

## 2.2 Clang/LLVM (C++)

| Resource                | Link                                                                             |
| ----------------------- | -------------------------------------------------------------------------------- |
| Clang documentation     | [https://clang.llvm.org/docs/](https://clang.llvm.org/docs/)                     |
| LLVM Language Reference | [https://llvm.org/docs/LangRef.html](https://llvm.org/docs/LangRef.html)         |
| Clang C++ status        | [https://clang.llvm.org/cxx_status.html](https://clang.llvm.org/cxx_status.html) |
| LLVM source             | [https://github.com/llvm/llvm-project](https://github.com/llvm/llvm-project)     |

## 2.3 MSVC (Windows)

| Link                                                                                   |
| -------------------------------------------------------------------------------------- |
| [https://learn.microsoft.com/en-us/cpp/cpp](https://learn.microsoft.com/en-us/cpp/cpp) |

---

# 3. ABI DAN OBJECT FORMAT

## 3.1 Itanium C++ ABI (Linux/BSD/macOS)

| Resource            | Link                                                                                     |
| ------------------- | ---------------------------------------------------------------------------------------- |
| Itanium C++ ABI     | [https://itanium-cxx-abi.github.io/cxx-abi/](https://itanium-cxx-abi.github.io/cxx-abi/) |
| Name mangling rules | sama seperti di atas                                                                     |

Itanium ABI adalah **standard de-facto** untuk seluruh platform non-Windows.

## 3.2 Microsoft C++ ABI

| Link                                                                                                           |                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| [https://learn.microsoft.com/en-us/cpp/build/reference](https://learn.microsoft.com/en-us/cpp/build/reference) |                                                                                                                                    |
| PE/COFF ABI                                                                                                    | [https://learn.microsoft.com/en-us/windows/win32/debug/pe-format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format) |

---

# 4. STANDARD LIBRARY (STL)

## Dokumentasi STL terbaik (praktis untuk programmer)

| Resource             | Link                                                                                   |
| -------------------- | -------------------------------------------------------------------------------------- |
| cppreference (wajib) | [https://en.cppreference.com](https://en.cppreference.com)                             |
| Boost C++ Library    | [https://www.boost.org/doc/libs/](https://www.boost.org/doc/libs/)                     |
| libc++ reference     | [https://libcxx.llvm.org/](https://libcxx.llvm.org/)                                   |
| libstdc++ reference  | [https://gcc.gnu.org/onlinedocs/libstdc++/](https://gcc.gnu.org/onlinedocs/libstdc++/) |

cppreference adalah **sumber nomor 1**.

---

# 5. PERANGKAT PENTING C++ (TOOLCHAIN)

## GNU Binutils

| Tool      | Fungsi                  |
| --------- | ----------------------- |
| objdump   | melihat assembly output |
| readelf   | debugging binary        |
| nm        | simbol                  |
| addr2line | mapping alamat ke baris |

## CMake

Dokumentasi:
[https://cmake.org/documentation/](https://cmake.org/documentation/)

## Ninja

Build system cepat untuk CMake.

---

# 6. DEBUGGING

## GDB

[https://sourceware.org/gdb/current/onlinedocs/gdb](https://sourceware.org/gdb/current/onlinedocs/gdb)

## LLDB

[https://lldb.llvm.org/](https://lldb.llvm.org/)

## Sanitizers (Wajib untuk C++)

| Nama  | Fungsi               | Link                                                                                                                       |
| ----- | -------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| ASAN  | Memory errors        | [https://clang.llvm.org/docs/AddressSanitizer.html](https://clang.llvm.org/docs/AddressSanitizer.html)                     |
| UBSAN | Undefined behavior   | [https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html](https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html) |
| TSAN  | Thread race detector | [https://clang.llvm.org/docs/ThreadSanitizer.html](https://clang.llvm.org/docs/ThreadSanitizer.html)                       |
| MSAN  | Uninitialized memory | [https://clang.llvm.org/docs/MemorySanitizer.html](https://clang.llvm.org/docs/MemorySanitizer.html)                       |

---

# 7. BUKU TERBAIK (GRATIS DAN BERBAYAR)

## GRATIS

* **A Tour of C++ (Stroustrup Drafts)** – berbagai mirror
* **Thinking in C++** (Bruce Eckel, free PDF – klasik)
* **C++ Annotations (Frank Brokken)** – free PDF
* **MIT OCW 6.096 Introduction to C++** – free

## WAJIB (BERBAYAR)

* **The C++ Programming Language – Stroustrup (4th ed)**
* **Effective C++ Series – Scott Meyers**
  (Effective C++, More Effective C++, Effective STL)
* **Effective Modern C++ (Scott Meyers)**
* **C++ Concurrency in Action (Anthony Williams)**
* **Design Patterns (GoF)**
* **Clean Code / Clean Architecture**

## Tingkat tinggi / compiler / optimization

* **C++ Templates: The Complete Guide (2nd ed)** – Vandevoorde, Josuttis
* **Advanced Metaprogramming in C++** – Abrahams
* **High-Performance C++** – berbagai sumber akademik
* **Linkers & Loaders** – John Levine
* **Computer Systems: A Programmer’s Perspective** – Bryant & O’Hallaron (binary level)

---

# 8. C++ UNTUK SISTEM LEVEL RENDAH

## OSDev (C++ kernel)

[https://wiki.osdev.org/C%2B%2B](https://wiki.osdev.org/C%2B%2B)

## Drivers (Linux)

| Resource             | Link                                                         |
| -------------------- | ------------------------------------------------------------ |
| Linux Device Drivers | [https://lwn.net/Kernel/LDD3/](https://lwn.net/Kernel/LDD3/) |
| Kernel docs          | [https://docs.kernel.org/](https://docs.kernel.org/)         |

---

# 9. C++ UNTUK REVERSE ENGINEERING

Tool yang umum:

* **Ghidra**
* **IDA Free**
* **Radare2 / Cutter**
* **Capstone disassembly**
* **LLVM MC layer (machine code)**

Dokumentasi encoding instruksi:
[https://llvm.org/docs/CommandGuide/llvm-mc.html](https://llvm.org/docs/CommandGuide/llvm-mc.html)

---

# 10. C++ UNTUK KEAMANAN & EXPLOIT DEVELOPMENT

| Resource                         | Link                                                                                                                                   |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Modern Binary Exploitation (RPI) | berbagai mirror                                                                                                                        |
| Pwn.college                      | [https://pwn.college](https://pwn.college)                                                                                             |
| LiveOverflow                     | YouTube                                                                                                                                |
| Binary Ninja docs                | [https://docs.binary.ninja](https://docs.binary.ninja)                                                                                 |
| Hardened C++ Guidelines          | [https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines.html](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines.html) |

---

# 11. FRAMEWORK DAN LIBRARY PENTING

| Area             | Library                              |
| ---------------- | ------------------------------------ |
| Networking       | ASIO, Boost.Asio                     |
| GUI              | Qt, Dear ImGui, wxWidgets            |
| Game engine      | Unreal Engine (C++), Godot modules   |
| Serialization    | nlohmann/json, Protobuf              |
| HPC              | Kokkos, RAJA, HPX                    |
| Machine Learning | TensorRT, libtorch                   |
| SIMD             | xsimd, Boost.SIMD, std::simd (C++23) |

---

# 12. C++ METAPROGRAMMING

## Sumber kunci

* **C++ Templates: The Complete Guide**
* **Modern C++ Design (Loki Library)** – Andrei Alexandrescu
* TMP resources:

  * [https://eli.thegreenplace.net](https://eli.thegreenplace.net)
  * Articles on metaprogramming from WG21 papers
* Concepts (C++20):

  * [https://en.cppreference.com/w/cpp/language/constraints](https://en.cppreference.com/w/cpp/language/constraints)

---

# 13. CONCURRENCY (MULTITHREADING)

| Resource                           | Link                                                                                                                                                     |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| std::thread, std::mutex docs       | cppreference.com                                                                                                                                         |
| C++ Concurrency in Action          | Anthony Williams                                                                                                                                         |
| Intel TBB (Thread Building Blocks) | [https://www.intel.com/content/www/us/en/developer/tools/oneapi/onetbb.html](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onetbb.html) |

---

# 14. SEMUA HAL WAJIB YANG HARUS DI-DOWNLOAD (CHECKLIST)

[x] WG21 Draft Standard (eel.is/c++draft)
[x] GCC & Clang C++ extensions manual
[x] libstdc++ & libc++ reference offline
[x] Boost library docs offline
[x] cppreference offline HTML dump
[x] C++ Core Guidelines PDF
[x] C++ Templates: The Complete Guide
[x] Effective Modern C++
[x] Linkers & Loaders
[x] GDB manual
[x] LLVM LangRef
[x] Sanitizer documentation
[x] Ninja + CMake docs offline

---
<!---->
<!-- # 15. LANGKAH BELAJAR 0 → EXPERT (SINGKAT) -->
<!---->
<!-- Jika Anda ingin, saya bisa buatkan **roadmap 3 bulan / 6 bulan / 12 bulan**, misalnya: -->
<!---->
<!-- 1. Dasar C++ -->
<!-- 2. OOP modern -->
<!-- 3. STL & Generic programming -->
<!-- 4. Templates & metaprogramming -->
<!-- 5. Memory model & concurrency -->
<!-- 6. Compiler-level C++ dan LLVM IR -->
<!-- 7. High-performance dan low-level system programming -->
<!-- 8. OSDev C++ kernel -->
<!-- 9. Reverse engineering + security -->
<!---->
<!-- Saya juga bisa menyiapkan **daftar referensi format tabel markdown**, atau daftar yang bisa Anda **download secara offline**. -->
<!---->
<!-- --- -->
<!---->
<!-- Jika Anda ingin melanjutkan ke **Java**, **Rust**, **Go**, **Swift**, **Zig**, **Fortran**, **Python**, atau **Compiler Construction**, tinggal beri instruksi. -->
