# ⚙️ Integrasi GNU Toolchain pada Sistem Arch Linux

Bagian ini menjelaskan bagaimana ekosistem Arch Linux menggabungkan seluruh komponen GNU — **GCC, Binutils, Glibc, Make, GDB, Coreutils, Bash, dan Autotools** — menjadi *toolchain terpadu* yang digunakan untuk membangun seluruh sistem dari sumber. Arch dikenal sebagai salah satu distribusi paling “GNU murni”, karena hampir seluruh lapisan sistem pengguna dan pembangunnya bergantung pada GNU Toolchain.

---

## 1. Konsep dasar GNU Toolchain

**GNU Toolchain** adalah kumpulan alat yang memungkinkan pengembang membangun, menautkan, menjalankan, dan men-debug perangkat lunak pada sistem berbasis Unix. Komponen utamanya meliputi:

* **Compiler**: `gcc`
* **Assembler & Linker**: `as`, `ld` (dari Binutils)
* **Standard C Library**: `glibc`
* **Build tools**: `make`, `autoconf`, `automake`, `libtool`
* **Debugger**: `gdb`
* **Core utilities dan shell**: `coreutils`, `bash`

Di Arch Linux, semua komponen ini tersedia sebagai paket terpisah namun saling terkait dalam grup *base-devel*.

---

## 2. Struktur Toolchain di Arch Linux

### a. Paket utama dalam *base-devel*

```bash
sudo pacman -S base-devel
```

Perintah ini akan menginstal kumpulan alat GNU berikut:

```
autoconf  automake  binutils  bison  fakeroot  file
findutils  flex  gawk  gcc  gettext  grep
groff  gzip  libtool  m4  make  patch
pkgconf  sed  texinfo  util-linux  which
```

Sebagian besar berasal langsung dari proyek GNU. Grup ini menjadi **lingkungan minimum** untuk membangun paket di Arch.

---

### b. Hubungan antar-komponen

Diagram hubungan fungsional:

```
        +----------------------+
        |     Source Code      |
        +----------+-----------+
                   |
                 (gcc)
                   ↓
          +-----------------+
          |  Assembler (as) |  ← dari Binutils
          +-----------------+
                   ↓
             Object Files (.o)
                   ↓
                (ld)
                   ↓
          +------------------+
          |  Executable ELF  |
          +------------------+
                   ↓
                 (gdb)
         ← debugging & analysis
```

`glibc` menyediakan pustaka C standar yang ditautkan oleh `ld`, dan `make` mengatur urutan kompilasi berdasarkan dependensi di `Makefile`.

---

## 3. Integrasi dengan `makepkg` dan `pacman`

Arch Linux membangun seluruh sistem dan paket resminya menggunakan *GNU Toolchain* melalui pipeline berikut:

```
PKGBUILD → makepkg → gcc/binutils/make → pacman
```

### a. Tahapan build:

1. **makepkg** membaca file `PKGBUILD`.
2. Menjalankan `make` atau `configure` (Autotools GNU).
3. `gcc` mengompilasi kode → `as` mengubah ke object → `ld` menautkan.
4. `strip` dan `objcopy` (Binutils) memproses hasil akhir.
5. `pacman` menginstal paket `.pkg.tar.zst` ke sistem.

### b. Contoh sederhana:

```bash
makepkg -s
```

Secara otomatis akan memanggil toolchain GNU yang ada di PATH Anda.

---

## 4. Integrasi GCC, Binutils, dan Glibc

Ketiga komponen ini saling terikat versi dan ABI-nya (Application Binary Interface). Arch menjaga sinkronisasi melalui repositori resmi:

* **gcc-libs**: pustaka runtime C/C++
* **binutils**: assembler & linker
* **glibc**: pustaka sistem utama

Untuk memastikan konsistensi sistem, Anda bisa memeriksa:

```bash
pacman -Qi gcc binutils glibc
```

dan memverifikasi kesesuaian versi. Arch biasanya memutakhirkan ketiganya bersamaan (misalnya GCC 14, Binutils 2.43, Glibc 2.40).

---

## 5. Perbandingan dengan Toolchain non-GNU di Arch

Arch juga menyediakan *alternatif* toolchain seperti LLVM/Clang, namun secara default seluruh sistem dibangun menggunakan GNU:

| Komponen   | GNU Default   | Alternatif                  |
| ---------- | ------------- | --------------------------- |
| Compiler   | GCC           | Clang/LLVM                  |
| Assembler  | GNU As        | LLVM Assembler              |
| Linker     | GNU ld / Gold | lld                         |
| Library    | glibc         | musl / bionic (tidak resmi) |
| Debugger   | GDB           | LLDB                        |
| Build tool | GNU Make      | Ninja / Meson               |

Untuk membangun seluruh sistem dengan Clang, Arch menyediakan meta-paket `base-devel-clang`, namun mayoritas repositori resmi tetap menggunakan GNU Toolchain.

---

## 6. Memeriksa seluruh GNU Toolchain di Arch

Gunakan perintah berikut:

```bash
gcc --version
ld --version
as --version
make --version
gdb --version
ldd --version   # dari glibc
```

Untuk melihat seluruh alat GNU terinstal:

```bash
pacman -Q | grep gnu
```

atau untuk daftar toolchain:

```bash
pacman -Q | grep -E 'gcc|make|binutils|gdb|glibc'
```

---

## 7. Memutakhirkan Toolchain secara aman

Karena GCC, Binutils, dan Glibc saling bergantung, lakukan pembaruan sistem penuh agar ABI tetap sinkron:

```bash
sudo pacman -Syu
```

Hindari memperbarui salah satu di antaranya secara parsial (misalnya hanya glibc), karena bisa menyebabkan program lama tidak dapat dijalankan.

Untuk uji coba versi baru GCC tanpa mengganti sistem utama:

```bash
sudo pacman -S gcc14
export CC=gcc-14
```

Ini memungkinkan *parallel installation* antara GCC sistem dan versi eksperimental.

---

## 8. Contoh kasus: membangun program dari sumber

```bash
sudo pacman -S base-devel
git clone https://github.com/coreutils/coreutils.git
cd coreutils
./bootstrap
./configure --prefix=/usr
make -j$(nproc)
sudo make install
```

Semua proses di atas — mulai dari konfigurasi, kompilasi, linking, hingga instalasi — sepenuhnya dijalankan oleh alat GNU: `autoconf`, `make`, `gcc`, `ld`, `install`.

---

## 9. Sumber resmi Arch Linux & GNU

* **ArchWiki: [Development Tools](https://wiki.archlinux.org/title/Development_tools)**
* **ArchWiki: [Makepkg](https://wiki.archlinux.org/title/Makepkg)**
* **ArchLinux Packages: [base-devel group](https://archlinux.org/groups/x86_64/base-devel/)**
* **GNU Toolchain Overview:** [https://gcc.gnu.org/wiki/GNUToolchain](https://gcc.gnu.org/wiki/GNUToolchain)
* **FSF & GNU manuals:** GCC, Binutils, Make, GDB, Glibc documentation.

---

## 10. Checklist pemahaman pelajar

1. Dapat menjelaskan apa itu GNU Toolchain dan komponennya.
2. Memahami hubungan GCC, Binutils, dan Glibc di Arch.
3. Dapat menjelaskan bagaimana Makepkg dan Pacman menggunakan GNU Toolchain.
4. Mengetahui perbedaan GNU Toolchain dengan LLVM Toolchain.
5. Dapat memeriksa dan memperbarui toolchain sistem secara aman.
6. Mampu membangun paket dari sumber menggunakan GNU Toolchain di Arch.

---

Dengan selesainya bab ini, maka seluruh isi bagian **⚙️ Komponen GNU di Linux** benar-benar lengkap secara teknis dan struktural — mencakup seluruh komponen internal beserta implementasinya di Arch Linux.

Langkah berikutnya adalah masuk ke bagian penutup dari rangkaian dokumentasi GNU, yaitu **🔍 Verifikasi Tools GNU**, di mana kita akan fokus pada cara:

* memeriksa versi dan identitas alat GNU,
* mendeteksi duplikasi atau versi non-GNU,
* serta mengaudit seluruh sistem untuk memastikan lingkungan sepenuhnya berbasis GNU.

