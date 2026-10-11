# DOKUMEN TEKNIS: PENGENALAN SHELL PADA SISTEM UNIX-LIKE - sh, Bash, Dash, dan Zsh

**Klasifikasi, Karakteristik, dan Kaitannya dengan Standar POSIX dan Lembaga IEEE**  
<!-- Tanggal: 11 Oktober 2026 | Lokasi: Malang, Jawa Timur -->

---

## 1. Pendahuluan

Shell merupakan penerjemah perintah (command language interpreter) yang menjadi antarmuka utama antara pengguna dan kernel sistem operasi. Dalam ekosistem Unix dan Linux, terdapat beberapa jenis shell yang memiliki tujuan dan karakteristik berbeda.

Dokumen ini bertujuan memberikan penjelasan komprehensif mengenai empat shell yang paling umum digunakan, yaitu sh, Bash, Dash, dan Zsh, serta menjelaskan fondasi standarisasi yang mendasarinya, yaitu standar POSIX dan peran lembaga IEEE.

## 2. sh - Bourne Shell / POSIX Shell

`sh` adalah shell standar yang didefinisikan dalam standar POSIX. Secara formal, dalam POSIX Programmer's Manual, sh dideskripsikan sebagai **"sh — shell, the standard command language interpreter"**. Bahasa yang dijalankan oleh sh disebut **"Shell Command Language"** yang diatur dalam IEEE Std 1003.1, Volume Shell and Utilities, Bab 2.

Secara historis, sh berasal dari Bourne Shell yang diciptakan oleh Stephen Bourne di Bell Labs pada tahun 1977 untuk Unix Version 7. Bourne Shell menjadi dasar bagi semua shell modern.

Dalam konteks modern, ketika seseorang menulis skrip dengan shebang `#!/bin/sh`, yang dimaksud adalah shell yang patuh terhadap spesifikasi POSIX, bukan implementasi tertentu. Dengan demikian, sh bersifat sebagai spesifikasi antarmuka, bukan program tunggal. Pada sistem operasi, `/bin/sh` umumnya merupakan tautan simbolik (symlink) ke implementasi yang tersedia.

**Karakteristik sh:**
- Patuh sepenuhnya terhadap standar POSIX
- Sintaks minimalis dan portabel
- Dijamin tersedia di semua sistem yang patuh POSIX (Linux, macOS, BSD, Solaris)
- Ideal untuk skrip sistem, skrip instalasi, dan skrip init

## 3. Bash - Bourne Again Shell

Bash adalah singkatan dari Bourne Again Shell. Bash dikembangkan oleh Brian Fox untuk Proyek GNU pada tahun 1989 sebagai pengganti bebas (free software) untuk Bourne Shell. Bash merupakan superset dari sh, artinya Bash mendukung seluruh sintaks POSIX sh ditambah dengan berbagai ekstensi.

Bash menjadi shell default pada sebagian besar distribusi Linux, serta default pada macOS hingga versi Catalina. Bash dirancang untuk penggunaan interaktif maupun untuk pemrograman skrip.

**Karakteristik Bash:**
- Mendukung fitur interaktif seperti history, auto-completion (Tab), dan line editing
- Mendukung array, associative array, `[[ test ]]`, function dengan local variable, dan `pipefail`
- Memiliki mode POSIX (`bash --posix`) untuk berperilaku seperti sh
- Ukuran binary lebih besar dan proses startup sedikit lebih lambat dibanding Dash
- Versi terbaru adalah Bash 5.x

## 4. Dash - Debian Almquist Shell

Dash adalah singkatan dari Debian Almquist Shell. Dash merupakan implementasi minimalis dan cepat dari shell POSIX.

Dash berawal dari Almquist Shell (ash) yang ditulis oleh Kenneth Almquist pada tahun 1989, kemudian di-porting dari NetBSD ke Debian Linux oleh Herbert Xu pada tahun 1997. Pada September 2002, porting tersebut secara resmi dinamai Dash.

Dash secara sengaja dirancang hanya untuk memenuhi kepatuhan POSIX tanpa menambahkan ekstensi non-POSIX. Prioritas utamanya adalah kecepatan eksekusi dan jejak memori yang kecil. Karena keunggulannya tersebut, Debian dan turunannya termasuk Ubuntu menggunakan Dash sebagai implementasi default untuk `/bin/sh` sejak tahun 2006. Hal ini mempercepat proses booting sistem karena skrip-skrip init yang menggunakan `/bin/sh` dieksekusi lebih cepat.

**Karakteristik Dash:**
- Sepenuhnya POSIX-compliant
- Tidak mendukung bashism (misalnya `[[ ]]`, `<(process substitution)`, array)
- Startup time 3-4 kali lebih cepat dari Bash
- Sangat ideal untuk skrip non-interaktif yang membutuhkan kecepatan
- Tidak direkomendasikan untuk penggunaan interaktif sehari-hari

## 5. Zsh - Z Shell

Zsh adalah singkatan dari Z Shell. Zsh dikembangkan oleh Paul Falstad pada tahun 1990. Zsh dirancang sebagai shell interaktif yang canggih dengan menggabungkan fitur-fitur terbaik dari Bash, ksh (KornShell), dan tcsh, serta menambahkan banyak inovasi baru.

Zsh memiliki kompatibilitas tinggi dengan Bash dan POSIX sh, namun menawarkan pengalaman pengguna yang jauh lebih kaya untuk penggunaan interaktif. Sejak tahun 2019, Zsh menjadi shell default pada macOS (menggantikan Bash) dan menjadi sangat populer di kalangan pengembang melalui framework konfigurasi seperti Oh My Zsh dan Powerlevel10k.

**Karakteristik Zsh:**
- Auto-completion yang sangat cerdas dan kontekstual
- Globbing yang kuat (misalnya `ls **/*.js`)
- Sistem tema dan plugin yang ekstensif
- Koreksi ejaan perintah (spelling correction)
- Mendukung shared history antar sesi
- Kompatibel dengan skrip Bash dalam banyak kasus, namun memiliki bahasa skrip sendiri yang lebih ekspresif

## 6. Perbandingan Komprehensif

| Aspek | sh (POSIX) | Bash | Dash | Zsh |
| :--- | :--- | :--- | :--- | :--- |
| **Tujuan Utama** | Standar & Portabilitas | Skrip & Interaktif General Purpose | Eksekusi Cepat /bin/sh | Interaktif Modern & Kustomisasi |
| **Kepatuhan POSIX** | 100% (Definisi Standar) | Ya, dengan mode --posix | 100% (Implementasi Minimalis) | Ya, sebagian besar |
| **Fitur Interaktif** | Minimal | Lengkap | Sangat Minimal | Sangat Lengkap & Canggih |
| **Kecepatan** | Tergantung Implementasi | Sedang | Sangat Cepat | Sedang - Lambat saat banyak plugin |
| **Ukuran Binary** | Tergantung Implementasi | Besar (~1.2 MB) | Kecil (~100 KB) | Besar |
| **Default di** | Semua sistem POSIX | Kebanyakan Linux, WSL | /bin/sh di Debian/Ubuntu | macOS (sejak Catalina), Kali Linux |

## 7. Standar POSIX

POSIX merupakan singkatan dari Portable Operating System Interface. POSIX adalah kumpulan standar yang diatur oleh IEEE untuk menyeragamkan antarmuka pemrograman aplikasi (API) dan antarmuka sistem operasi yang berbasis Unix. Tujuan utamanya adalah meningkatkan portabilitas dan kompatibilitas, sehingga program yang mendukung standar POSIX dapat dengan mudah dipindahkan dari satu sistem ke sistem lainnya.

POSIX mendefinisikan antarmuka pemrograman aplikasi (API), bersama dengan shell baris perintah dan antarmuka utilitas untuk kompatibilitas perangkat lunak dengan varian Unix dan sistem operasi lainnya. Keluarga standar POSIX secara resmi ditunjuk sebagai IEEE Std 1003.1. Awalnya dirilis pada tahun 1988.

Ruang lingkup standar POSIX mencakup empat volume utama: Base Definitions (definisi istilah dan header), System Interfaces (system call seperti open(), fork(), pipe()), Shell and Utilities (perintah seperti sh, ls, grep, awk), dan Rationale (penjelasan desain). Versi yang umum digunakan saat ini adalah POSIX.1-2017 dan pembaruan terbaru POSIX.1-2024.

## 8. IEEE Sebagai Lembaga Standarisasi

Institute of Electrical and Electronics Engineers (IEEE) adalah organisasi profesional nirlaba terbesar di dunia yang didedikasikan untuk kemajuan teknologi. IEEE merupakan asosiasi profesional teknis nirlaba dengan lebih dari 360.000 anggota individu di sekitar 175 negara. Organisasi ini bukan entitas pemerintah maupun perusahaan yang dimiliki korporasi tertentu.

IEEE didirikan pada tahun 1963 melalui merger American Institute of Electrical Engineers (AIEE, 1884) dan Institute of Radio Engineers (IRE, 1912), dengan kantor pusat di New York. Pendanaan berasal dari iuran anggota, publikasi jurnal, dan konferensi. Pengembangan standar dilakukan oleh sukarelawan (volunteer) yang terdiri dari insinyur industri, akademisi, dan peneliti.

Standar POSIX dikembangkan oleh Working Group P1003 di bawah IEEE Computer Society. Sejak tahun 2001, pengembangan dilakukan secara kolaboratif melalui Austin Group, yang terdiri dari IEEE, The Open Group (pemegang merek dagang UNIX), dan ISO/IEC. Model kerja berbasis konsensus terbuka memastikan standar bersifat netral dan tidak dikendalikan oleh satu vendor.

## 9. Kesimpulan dan Rekomendasi Penggunaan

Berdasarkan uraian di atas, pemilihan shell harus disesuaikan dengan kebutuhan:

- **Gunakan sh (POSIX)** untuk skrip yang menuntut portabilitas maksimum, skrip instalasi (`curl | sh`), dan skrip init sistem. Pastikan hanya menggunakan sintaks POSIX murni.
- **Gunakan Bash** untuk skrip general-purpose di lingkungan Linux, otomasi DevOps, dan penggunaan interaktif sehari-hari yang membutuhkan keseimbangan antara fitur dan kompatibilitas.
- **Gunakan Dash** secara tidak langsung melalui `/bin/sh` untuk skrip sistem yang membutuhkan kecepatan eksekusi tinggi, terutama pada sistem berbasis Debian/Ubuntu.
- **Gunakan Zsh** untuk penggunaan interaktif harian (daily driver) bagi pengembang yang mengutamakan produktivitas, auto-completion cerdas, dan kustomisasi tampilan terminal.

Dengan memahami perbedaan karakteristik masing-masing shell dan fondasi standarnya, pengembang dapat menulis skrip yang lebih andal, portabel, dan efisien.

---

## Daftar Pustaka

- IEEE Std 1003.1-2017 & 1003.1-2024 - The Open Group Base Specifications, Shell Command Language.
- POSIX Programmer's Manual - sh(1p) - shell, the standard command language interpreter.
- Bash Manual - GNU Project, Free Software Foundation.
- Dash Manual - Debian Almquist Shell, git.kernel.org.
- Zsh Manual - Paul Falstad et al.
- IEEE - A not-for-profit organization, world's largest technical professional organization.
