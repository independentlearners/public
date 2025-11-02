# 📜 Sejarah GNU — uraian lengkap

## Ringkasan singkat

GNU (rekursif: *GNU’s Not Unix!*) adalah proyek perangkat lunak bebas yang diinisiasi oleh **Richard M. Stallman** pada akhir 1983 dengan tujuan membuat sistem operasi lengkap yang kompatibel dengan Unix tetapi **sepenuhnya bebas** (libre). Sejak pengumuman awal, proyek ini melahirkan banyak komponen penting — GNU Emacs, GCC, glibc, coreutils, bash, make, gdb, dan lain-lain — yang bersama-sama membentuk fondasi sistem GNU/Linux modern. Namun implementasi kernel asli proyek GNU, **GNU Hurd**, tidak mencapai adopsi luas; ketika kernel **Linux** muncul (Linus Torvalds, 1991) dan kemudian dirilis di bawah lisensi GPL, kernel Linux dipadukan dengan utilitas GNU sehingga menciptakan sistem lengkap yang umum digunakan hari ini. ([gnu.org][1])

---

## Garis waktu kronologis penting (milestone)

* **27 September 1983** — Pengumuman awal proyek GNU oleh Richard Stallman (Usenet). Tujuan: membuat sistem operasi bebas yang kompatibel Unix. ([Wikipedia][2])
* **Maret 1985** — GNU Manifesto dipublikasikan (dr. Dobb’s Journal). Manifesto menjelaskan alasan moral dan praktis di balik proyek, serta mengajak komunitas bergabung. ([gnu.org][1])
* **Oktober 1985** — Didirikan Free Software Foundation (FSF) untuk mendukung proyek GNU dan mempromosikan kebebasan perangkat lunak. ([fsf.org][3])
* **Awal — pertengahan 1990-an** — Pengembangan komponen GNU berlanjut: GCC, glibc, coreutils, bash, make, gdb, dsb. Kernel yang dimaksudkan (Hurd) berkembang tetapi lambat dan belum stabil untuk adopsi luas. ([gnu.org][4])
* **1991** — Linus Torvalds mengumumkan kernel Linux (25 Agustus 1991). Kernel ini kemudian menjadi pengganti praktis bagi kernel GNU/Hurd untuk membentuk sistem operasi yang lengkap. ([Wikipedia][5])
* **1992** — Kernel Linux dirilis di bawah GNU GPL; ini mempermudah integrasi dengan toolchain dan utilitas GNU. Hasilnya: distribusi yang sekarang umum disebut “Linux” namun teknisnya merupakan gabungan banyak komponen GNU plus kernel Linux. ([Wikipedia][5])

---

## Latar filosofis — mengapa GNU lahir

Garis besar motivasi Stallman adalah **kebebasan pengguna komputer**: kemampuan untuk menjalankan, mempelajari, memodifikasi, dan membagikan perangkat lunak. GNU Manifesto (1985) memaparkan bahwa semakin banyak perangkat lunak penting menjadi berpemilik, yang membatasi kolaborasi dan hak pengguna; Stallman mengusulkan pembuatan sistem yang seluruh komponennya bersifat bebas sebagai solusi praktis dan etis. FSF kemudian dibentuk untuk mendukung pengembangan dan advokasi. ([gnu.org][1])

---

## GNU Hurd vs Linux — kronik teknis singkat

* **GNU Hurd** adalah implementasi kernel yang dirancang untuk menjalankan server di atas *microkernel* (aslinya Mach), dengan tujuan fitur lanjutan dan arsitektur modular. Namun, perkembangan Hurd berjalan lambat karena kompleksitas desain dan hambatan pengembangan. Hasilnya Hurd tidak mencapai kesiapan produksi dalam waktu pendek. ([gnu.org][4])
* **Linux (kernel)** oleh Linus Torvalds muncul sebagai kernel monolitik kecil yang cepat berkembang bersama kontributor dari seluruh dunia. Karena Linux segera fungsional dan dapat digunakan, komunitas menggabungkannya dengan banyak alat GNU yang sudah matang. Kombinasi ini melahirkan sistem yang praktis: distribusi “GNU + Linux kernel” (sering disebut singkat: “Linux”). ([Wikipedia][5])

---

## Kontroversi penamaan: “Linux” vs “GNU/Linux”

Ada perdebatan panjang apakah nama yang tepat adalah “Linux” atau “GNU/Linux”. FSF dan Stallman berpendapat bahwa karena banyak komponen kunci (toolchain, utilitas, pustaka) berasal dari proyek GNU, penamaan yang paling akurat adalah **GNU/Linux** — yakni kernel Linux berjalan bersama sistem GNU. Di pihak lain, banyak pengguna dan komunitas (termasuk distribusi besar dan media) populer menggunakan nama singkat **Linux** untuk menyebut seluruh sistem, karena singkat dan telah menjadi istilah umum. Perdebatan ini mengandung unsur teknis (asal komponen) dan ideologis (apresiasi atas kontribusi GNU dan filosofi perangkat lunak bebas). ([gnu.org][6])

---

## Dampak historis dan teknis

1. **Toolchain & utilities**: Banyak perangkat lunak inti (GCC, glibc, coreutils, bash, make) yang dikembangkan oleh proyek GNU tetap menjadi fondasi teknis sebagian besar distribusi Linux. Tanpa GNU, banyak fungsi dasar sistem tidak akan ada dalam bentuk yang sekarang. ([Wikipedia][7])
2. **Lisensi**: Integrasi Linux dengan tool GNU makin mulus setelah kernel Linux dirilis di bawah **GNU GPL**, sehingga kompatibilitas legal dan distribusi kode bebas menjadi lebih mudah. Penggunaan GPL memiliki implikasi luas terhadap bagaimana kode dapat dipakai kembali dan disebarluaskan. ([Wikipedia][5])
3. **Komunitas & ekosistem**: Perpaduan GNU (filsafat + perangkat) dan Linux (kernel + ekosistem) mendorong terbentuknya distribusi, perusahaan dukungan (commercial support), dan proyek turunannya; sekaligus menimbulkan perbedaan pandangan antara gerakan “free software” (FSF) dan gerakan “open source” yang lebih pragmatis. ([fsf.org][3])

---

## Referensi utama (untuk dicantumkan di dokumen)

* **GNU Manifesto (Richard Stallman).** GNU Project. ([gnu.org][1])
* **FSF — History & mission.** Free Software Foundation. ([fsf.org][3])
* **Why GNU/Linux?** — Penjelasan posisi FSF tentang penamaan. ([gnu.org][6])
* **History of Linux (Linus Torvalds announcement, 1991).** Wikipedia (ringkasan sejarah kernel Linux). ([Wikipedia][5])
* **GNU Project — ringkasan projek & komponennya.** Wikipedia / GNU pages. ([Wikipedia][7])

---

## Catatan penulisan & rekomendasi file

* Lokasi file yang direkomendasikan:
  `CLI/struktur-sistem/gnu/sejarah.md`
* Gaya: formal teknis, lengkap dengan footnote sumber di akhir tiap sub-bagian jika ingin export ke situs dokumentasi.
* Untuk bagian berikutnya (sesuai rencana Anda): saya akan membahas **Latar belakang Richard Stallman & Free Software Foundation** (termasuk empat kebebasan perangkat lunak, struktur FSF, litera primer manifesto). Pada bagian itu akan saya sertakan kutipan terpilih (parafrase) dari Manifesto, lebih banyak sumber sekunder, serta contoh document/arsip historis yang relevan.

---
<!--
Apakah Anda ingin saya **melanjutkan ke bab berikutnya: “Latar belakang Richard Stallman & Free Software Foundation” sekarang**?
Jika setuju, saya akan melanjutkan dan menulis bab itu secara mendalam (sejarah pribadi Stallman dalam konteks proyek, empat kebebasan perangkat lunak, pendirian FSF, dampak hukum & sosial).
-->
[1]: https://www.gnu.org/gnu/manifesto.en.html?utm_source=chatgpt.com "The GNU Manifesto - GNU Project - Free Software ..."
[2]: https://en.wikipedia.org/wiki/GNU_Manifesto?utm_source=chatgpt.com "GNU Manifesto"
[3]: https://www.fsf.org/history?utm_source=chatgpt.com "FSF History"
[4]: https://www.gnu.org/gnu/linux-and-gnu.en.html?utm_source=chatgpt.com "Linux and GNU - GNU Project - Free Software Foundation"
[5]: https://en.wikipedia.org/wiki/History_of_Linux?utm_source=chatgpt.com "History of Linux"
[6]: https://www.gnu.org/gnu/why-gnu-linux.en.html?utm_source=chatgpt.com "Why GNU/Linux? - GNU Project - Free Software Foundation"
[7]: https://en.wikipedia.org/wiki/GNU_Project?utm_source=chatgpt.com "GNU Project"

