# Materi Kurikulum: Fase 1 - Pondasi

**Estimasi Waktu Fase:** 30-40 jam
**Level:** Pemula

Fase ini akan memperkenalkan Anda pada konsep dasar Linux, Manjaro, dan filosofi *tiling window manager*. Anda akan belajar cara menginstal Manjaro Sway i3 dan melakukan konfigurasi awal yang esensial.

-----

## Modul 1.1: Pengenalan Linux dan Distribusi Manjaro

### Deskripsi Konkret

Modul ini akan memperkenalkan Anda pada **Linux**, menjelaskan apa itu, bagaimana ia berkembang, dan mengapa Linux menjadi pilihan yang sangat populer di berbagai bidang, termasuk server, perangkat *mobile*, dan *desktop*. Kita juga akan membahas mengapa **Manjaro Linux** sering direkomendasikan sebagai titik awal yang baik, terutama bagi mereka yang tertarik pada kekuatan Arch Linux tetapi menginginkan pengalaman yang lebih mudah diakses dan stabil.

### Konsep Dasar dan Filosofi

**Linux** bukanlah sistem operasi tunggal, melainkan keluarga sistem operasi *open source* yang dibangun di atas **kernel Linux**. Filosofi utama di balik Linux dan perangkat lunak *open source* secara umum adalah **kebebasan**, **transparansi**, dan **kolaborasi**.

  * **Kebebasan:** Pengguna bebas untuk menjalankan program, mempelajari bagaimana program bekerja, memodifikasinya, dan mendistribusikan ulang salinan. Ini memberdayakan pengguna untuk mengontrol perangkat lunak mereka, bukan sebaliknya.
  * **Transparansi:** Kode sumber (cetak biru perangkat lunak) terbuka untuk siapa saja. Ini memungkinkan siapa pun untuk memeriksa, belajar, dan berkontribusi, serta membantu mengidentifikasi masalah keamanan atau *bug*.
  * **Kolaborasi:** Pengembangan Linux dan banyak proyek *open source* lainnya didorong oleh komunitas global yang bekerja sama, berbagi ide, dan berkontribusi kode.

Sebuah **Distribusi Linux** adalah sistem operasi lengkap yang terdiri dari **kernel Linux** dan kumpulan perangkat lunak lainnya, seperti utilitas **GNU** (GNU's Not Unix\!), *shell* (seperti Bash), pustaka (*libraries*), aplikasi, dan mungkin *desktop environment* atau *window manager*.

**Manjaro Linux** adalah salah satu dari banyak distribusi Linux. Keistimewaannya adalah ia **berbasis Arch Linux**. Ini berarti Manjaro mewarisi banyak keunggulan Arch, seperti model pembaruan **"Rolling Release"** (pembaruan berkelanjutan, bukan versi besar yang terpisah) dan akses ke repositori perangkat lunak yang sangat luas, termasuk **Arch User Repository (AUR)**. Namun, Manjaro menambahkan lapisan kemudahan penggunaan dan stabilitas melalui pengujian paket dan *installer* grafisnya, menjadikannya pilihan yang lebih ramah bagi pemula Arch.

### Sintaks Dasar/Contoh Implementasi Inti

Pada modul ini, tidak ada sintaks kode atau perintah yang perlu diimplementasikan secara langsung karena kita berfokus pada konsep. Namun, untuk memulai eksplorasi, Anda akan sering berinteraksi dengan sistem melalui **Terminal** atau **Command Line Interface (CLI)**.

Misalnya, untuk memeriksa versi kernel Linux Anda, Anda dapat menggunakan perintah berikut di Terminal:

```bash
uname -r
```

Ini akan mengeluarkan nomor versi kernel yang sedang berjalan di sistem Anda. Ini adalah contoh sederhana bagaimana Anda akan mulai berinteraksi dengan Linux di tingkat dasar.

### Terminologi Kunci

  * **Linux:** Merujuk pada keluarga sistem operasi *Unix-like* yang menggunakan kernel Linux.
  * **Kernel:** Inti dari sistem operasi. Kernel bertanggung jawab untuk mengelola sumber daya perangkat keras komputer dan menjembatani komunikasi antara *hardware* dan *software*.
  * **Open Source:** Model pengembangan perangkat lunak di mana kode sumbernya terbuka untuk publik, dapat diakses, dimodifikasi, dan didistribusikan ulang secara bebas.
  * **GNU:** Proyek perangkat lunak bebas yang dimulai oleh Richard Stallman. Banyak alat dan utilitas yang digunakan di Linux, seperti *shell* Bash, berasal dari proyek GNU.
  * **Distribusi Linux (Distro):** Sistem operasi lengkap yang dibangun di atas kernel Linux, mencakup perangkat lunak tambahan yang dikemas bersama. Contohnya adalah Ubuntu, Fedora, Debian, dan Manjaro.
  * **Arch Linux:** Sebuah distribusi Linux *rolling release* yang dikenal karena kesederhanaan, fleksibilitas, dan pendekatan minimalisnya. Pengguna biasanya membangun sistem dari bawah ke atas.
  * **Manjaro Linux:** Distribusi Linux berbasis Arch yang berfokus pada kemudahan penggunaan dan aksesibilitas. Ia menawarkan instalasi yang lebih sederhana dan *desktop environment* yang sudah dikonfigurasi.
  * **Rolling Release:** Model pembaruan perangkat lunak di mana sistem terus-menerus menerima pembaruan kecil secara berkala, daripada melalui "versi" besar yang terpisah. Ini berarti Anda selalu menjalankan perangkat lunak terbaru.
  * **Fixed Release:** Model pembaruan di mana distribusi mengeluarkan versi besar secara berkala (misalnya, setiap 6 bulan atau 2 tahun) dengan siklus dukungan yang tetap.
  * **Repository (Repo):** Tempat penyimpanan sentral di mana paket-paket perangkat lunak (aplikasi, *library*, dll.) disimpan dan dapat diunduh oleh manajer paket.
  * **Arch User Repository (AUR):** Repositori yang dikelola komunitas untuk pengguna Arch Linux dan turunannya. Ini berisi *script* (disebut PKGBUILD) yang memungkinkan pengguna mengkompilasi perangkat lunak dari kode sumber atau menginstal paket yang tidak tersedia di repositori resmi.

### Daftar Isi

  * Apa itu Linux? Sejarah Singkat dan Evolusinya.
  * Filosofi *Open Source*: Kebebasan, Transparansi, dan Kolaborasi.
  * Memahami Konsep Kernel dan Distribusi Linux.
  * Mengapa Memilih Manjaro? Keunggulan dan Fitur Khasnya.
  * Perbedaan Antara *Rolling Release* dan *Fixed Release* dalam Konteks Manjaro.
  * Pengenalan Singkat tentang Arch User Repository (AUR) dan Relevansinya.

### Sumber Referensi

  * **Apa itu Linux?**
      * [Linux Foundation: What is Linux?](https://www.google.com/search?q=https://www.linuxfoundation.org/about/who-we-are/what-is-linux)
      * [Wikipedia: Linux](https://en.wikipedia.org/wiki/Linux)
  * **Manjaro Linux:**
      * [Situs Web Resmi Manjaro](https://manjaro.org/)
      * [Manjaro Wiki](https://wiki.manjaro.org/index.php?title=Main_Page)
  * **Rolling Release vs. Fixed Release:**
      * [MakeUseOf: Rolling Release vs. Fixed Release](https://www.google.com/search?q=https://www.makeuseof.com/linux-fixed-rolling-release-explained/)
  * **Arch User Repository (AUR):**
      * [Arch Wiki: Arch User Repository](https://wiki.archlinux.org/title/Arch_User_Repository)

-----


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
