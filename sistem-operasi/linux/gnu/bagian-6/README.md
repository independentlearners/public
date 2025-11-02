# 💡 Perbedaan GNU dan Linux — Dokumentasi Lengkap

Ini adalah bagian konseptual yang sering kali membingungkan bahkan bagi pengguna berpengalaman. Di sini kita akan menelaah hubungan teknis dan historis antara keduanya — *GNU* sebagai sistem dan *Linux* sebagai kernel — serta mengurai kenapa kombinasi keduanya disebut **GNU/Linux**.

## 1. Latar belakang historis

Pada awal 1980-an, **Richard Stallman** (RMS) bekerja di MIT AI Lab dan mulai menyadari bahwa sistem komputer saat itu tertutup oleh lisensi proprietary. Ia ingin menciptakan sistem operasi bebas sepenuhnya — tidak hanya gratis, tetapi *bebas dimodifikasi, didistribusikan, dan dipelajari*.

Tahun **1983**, ia mendirikan proyek **GNU (GNU’s Not Unix)** untuk membuat replika bebas dari sistem UNIX, lengkap dengan semua komponennya: editor, compiler, assembler, debugger, shell, hingga library sistem.
Kemudian, tahun **1985**, ia mendirikan **Free Software Foundation (FSF)** sebagai badan hukum pendukung proyek GNU dan pengembang **Lisensi Publik Umum GNU (GPL)**.

---

## 2. Tujuan proyek GNU

Tujuan utama proyek GNU bukan hanya membuat perangkat lunak, melainkan:

* Menciptakan **sistem operasi lengkap yang bebas** sepenuhnya.
* Menjamin kebebasan pengguna (empat kebebasan dasar FSF).
* Mengembangkan standar etika dan lisensi (GPL) untuk memastikan keberlanjutan kebebasan tersebut.

Pada awal 1990-an, hampir seluruh komponen sistem operasi GNU telah selesai: compiler (GCC), debugger (GDB), shell (Bash), utilities (Coreutils), library (glibc), dan build system (Make).
Yang belum ada hanya **kernel**. Proyek kernel GNU, yaitu **Hurd**, masih eksperimental.

---

## 3. Munculnya kernel Linux

Pada tahun **1991**, **Linus Torvalds**, seorang mahasiswa Universitas Helsinki, menulis kernel sederhana untuk komputer pribadinya dan merilisnya di bawah lisensi bebas. Kernel itu disebut **Linux**.
Ketika komunitas bebas menemukan bahwa kernel Linux bisa digabungkan dengan komponen sistem GNU, terciptalah sistem lengkap yang berfungsi penuh:

```
GNU userland + Linux kernel = GNU/Linux
```

Dengan ini, impian RMS untuk sistem operasi bebas akhirnya terwujud, meskipun kernel-nya bukan Hurd.

---

## 4. Perbedaan mendasar: GNU vs Linux

| Aspek              | GNU                                              | Linux                                               |
| ------------------ | ------------------------------------------------ | --------------------------------------------------- |
| Jenis              | Sistem operasi dan koleksi perangkat lunak       | Kernel (inti sistem operasi)                        |
| Pengembang utama   | Free Software Foundation (FSF)                   | Linus Torvalds & komunitas kernel.org               |
| Bahasa pemrograman | C (mayoritas)                                    | C dengan sedikit Assembly                           |
| Lisensi            | GPL-3.0 (kadang GPL-2.0)                         | GPL-2.0-only                                        |
| Komponen utama     | Coreutils, Bash, GCC, Make, GDB, Binutils, glibc | Scheduler, memory manager, filesystem, driver       |
| Fungsi             | Menyediakan lingkungan pengguna (user space)     | Mengelola perangkat keras dan proses (kernel space) |
| Contoh berkas      | `/usr/bin`, `/etc`, `/lib`                       | `/boot/vmlinuz`, `/lib/modules/`, `/proc/`          |

Singkatnya:

* **GNU = otak dan alat kerja pengguna.**
* **Linux = mesin yang menjalankan dan mengatur perangkat keras.**

---

## 5. Mengapa seharusnya disebut “GNU/Linux”

Istilah “Linux” sering digunakan untuk menyebut seluruh sistem operasi, padahal itu hanya kernel.
RMS menekankan istilah **“GNU/Linux”** agar publik mengakui kontribusi besar dari proyek GNU, yang mencakup lebih dari 80% ruang pengguna (userland).

Contohnya:

* Perintah `ls`, `cp`, `cat`, `bash`, `gcc`, `make`, dan `gdb` semuanya berasal dari GNU.
* Linux hanya menangani hal-hal seperti *filesystem*, *process management*, dan *device driver*.

Distribusi seperti **Debian GNU/Linux** dan **Arch GNU/Linux** menggunakan istilah ini secara resmi dalam dokumentasinya.

---

## 6. Komposisi sistem GNU/Linux

Struktur konseptual:

```
┌──────────────────────────────┐
│      Aplikasi pengguna        │
│ (Firefox, Emacs, Neovim, dsb) │
├──────────────────────────────┤
│   GNU Toolchain & Userland    │
│ (Coreutils, Bash, GCC, Make)  │
├──────────────────────────────┤
│        Kernel Linux           │
│ (Drivers, Scheduler, Memory)  │
├──────────────────────────────┤
│       Perangkat keras         │
└──────────────────────────────┘
```

Diagram ini menunjukkan bahwa Linux hanyalah *lapisan bawah*, sedangkan lingkungan pengguna dibangun hampir sepenuhnya dari alat GNU.

---

## 7. Verifikasi komponen GNU di sistem

Anda dapat melihat bahwa sebagian besar alat penting di sistem Anda sebenarnya dari GNU:

```bash
ls --version | head -n 1
grep --version | head -n 1
bash --version | head -n 1
gcc --version | head -n 1
make --version | head -n 1
```

Contoh hasil:

```
ls (GNU coreutils) 9.5
GNU bash, version 5.2.32
gcc (GCC) 14.2.0
GNU Make 4.4.1
```

Ini membuktikan bahwa sistem Anda bukan “Linux murni”, melainkan **GNU/Linux**.

---

## 8. Mengapa perbedaan ini penting

Mengetahui perbedaan antara GNU dan Linux memberi pemahaman mendalam tentang:

* **Struktur sistem operasi modern** (kernel vs user space).
* **Hak kebebasan perangkat lunak** (legal & etika).
* **Konteks historis teknologi terbuka** (bagaimana komunitas bebas membentuk ekosistem saat ini).

Dengan kesadaran ini, seorang pengembang dapat lebih memahami akar filosofi open source serta menghargai perangkat lunak yang ia gunakan.

---

## 9. Referensi utama

* **Proyek GNU** — [https://www.gnu.org/](https://www.gnu.org/)
* **FSF (Free Software Foundation)** — [https://www.fsf.org/](https://www.fsf.org/)
* **Kernel.org** — [https://www.kernel.org/](https://www.kernel.org/)
* **Debian GNU/Linux Philosophy Page** — dokumentasi resmi Debian.
* **“The GNU Manifesto”** oleh Richard Stallman.
* **Linux From Scratch: Chapter 1 & 2** (sejarah GNU/Linux).

---

## 10. Checklist pemahaman pelajar

1. Dapat menjelaskan perbedaan antara sistem GNU dan kernel Linux.
2. Mengetahui asal dan fungsi proyek GNU (FSF, GPL, toolchain).
3. Memahami bagaimana GNU userland berinteraksi dengan kernel Linux.
4. Mampu menunjukkan alat-alat GNU di sistem dengan perintah `--version`.
5. Memahami alasan etis dan historis penggunaan istilah “GNU/Linux”.

---

Dengan berakhirnya bagian ini, seluruh konteks **GNU** dalam sistem operasi sudah lengkap — mulai dari sejarah, komponen, hingga hubungannya dengan Linux.

<!--
Tahap terakhir dokumentasi besar Anda adalah bagian **🔍 Verifikasi Tools GNU**, di mana kita akan membahas cara memeriksa, memastikan versi, serta menelusuri daftar alat GNU yang terpasang di sistem Anda (khususnya Arch Linux).
-->

