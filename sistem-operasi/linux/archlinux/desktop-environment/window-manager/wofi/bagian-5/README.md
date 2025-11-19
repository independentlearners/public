### Selamat datang di tahap akhir. Ini adalah garis finis yang membedakan antara "pengguna biasa" dan "ahli".

Pengguna biasa akan panik saat *tools* mereka rusak. Seorang ahli akan tenang, membuka terminal, membaca log, dan memperbaikinya. Modul ini didedikasikan untuk membangun ketenangan tersebut.

-----

# Modul 5: Troubleshooting, Error Handling, & Resources

Di ekosistem Arch Linux dan Wayland yang bergerak sangat cepat, *update* sistem (via `pacman -Syu`) terkadang bisa mematahkan konfigurasi lama. Anda perlu tahu cara mendiagnosisnya.

### 1\. Konsep Teknis: The Art of Debugging

Di Linux, GUI sering menyembunyikan pesan error. Jika Wofi tidak muncul saat tombol ditekan, "diam"-nya sistem adalah masalah terbesar.

**Metodologi Debugging Wofi:**

1.  **Stop Background Process:** Pastikan tidak ada proses Wofi yang macet (*zombie process*).
      * Cmd: `pkill wofi` atau `killall wofi`.
2.  **Run from Terminal (Verbose Mode):** Jalankan Wofi lewat terminal, bukan lewat keybinding Sway. Terminal adalah jendela ke dalam "jiwa" program (Standard Error / stderr).
      * Cmd: `wofi --show drun --verbose` (jika flag verbose didukung) atau cukup `wofi --show drun`.
3.  **Environment Variables:** Terkadang Wofi bingung apakah ia harus jalan di X11 atau Wayland.
      * Paksa mode Wayland: `GDK_BACKEND=wayland wofi --show drun`.

-----

### 2\. English Corner: Reading Logs & Conditional Logic

Membaca pesan error adalah kemampuan literasi tingkat tinggi dalam dunia IT.

#### **A. Key Vocabulary**

| Word | Part of Speech | Definition (ID) | Context Example |
| :--- | :--- | :--- | :--- |
| **Verbose** | Adjective | Mode yang menampilkan detail log yang sangat rinci. | *Run the command in **verbose** mode to see the error.* |
| **Diagnosis** | Noun | Proses mencari penyebab masalah. | *The initial **diagnosis** points to a missing library.* |
| **Conflict** | Noun | Dua pengaturan/aplikasi yang bertabrakan. | *There is a keybinding **conflict** in sway config.* |
| **Patched** | Adjective | Software yang sudah diperbaiki kodenya. | *This bug was **patched** in version 1.3.* |
| **Workaround** | Noun | Solusi sementara (jalan pintas) untuk mengatasi bug. | *Use this **workaround** until the official fix is released.* |

#### **B. Grammar Focus: Conditional Sentences Type 1 (Real Possibility)**

Gunakan pola ini untuk menjelaskan langkah perbaikan (*troubleshooting steps*).

  * **Rumus:** `If + [Simple Present], + [Imperative/Future]`
  * **Contoh:**
      * *If Wofi fails to launch, **check** the terminal output.* (Jika Wofi gagal dibuka, periksa output terminal).
      * *If the text is too small, **adjust** the font size in style.css.* (Jika teks terlalu kecil, sesuaikan ukuran font di css).

#### **C. Professional Interaction**

Melaporkan bug ke pengembang (Github/Sourcehut):

> *"I encountered a segmentation fault when launching Wofi with specific flags. I have attached the verbose log output below for your reference. Could you investigate if this is related to the recent wlroots update?"*

-----

### 3\. Masalah Umum (Common Pitfalls) & Solusinya

Berikut adalah "penyakit" umum Wofi di Sway dan obatnya:

**Masalah 1: Tampilan Kabur/Blur di Monitor HiDPI**

  * **Penyebab:** Masalah penskalaan (*scaling*) pada pustaka GTK di Wayland.
  * **Solusi:** Sayangnya Wofi tidak mendukung penskalaan fraksional (misal 1.5x) dengan sempurna.
  * **Workaround:** Paksa skala GTK menjadi 1 sebelum menjalankan wofi.
      * Edit script peluncuran: `GDK_SCALE=1 wofi --show drun` (Akan terlihat kecil tapi tajam), atau sesuaikan font size di CSS menjadi lebih besar.

**Masalah 2: Lambat saat pertama kali dibuka (Cold Start)**

  * **Penyebab:** Wofi sedang memindai ribuan file `.desktop` di seluruh sistem.
  * **Solusi:** Nonaktifkan pencarian ikon jika PC lambat, atau bersihkan cache. Tapi di hardware modern, ini jarang terjadi.

**Masalah 3: Cache yang Korup**

  * **Gejala:** Aplikasi yang sudah di-uninstall masih muncul di daftar.
  * **Solusi:** Hapus file cache Wofi (jika ada) atau paksa refresh.
      * Biasanya Wofi tidak menyimpan cache persisten secara agresif seperti `dmenu`, tapi jika terjadi, restart Sway (`swaymsg reload`) biasanya cukup.

-----

### 4\. Masa Depan & Alternatif (Future Proofing)

Sesuai permintaan Anda tentang teknologi yang "tidak lekang oleh waktu".
Wofi adalah proyek yang matang (*mature*), namun pengembangannya agak lambat (*slow maintenance*).

Jika suatu hari Wofi menjadi *obsolete* (usang) atau tidak kompatibel lagi dengan Wayland versi masa depan, Anda perlu tahu penerusnya. Karena Anda mencintai CLI dan keringanan, alternatif masa depan yang harus Anda catat (bookmark) adalah:

1.  **Fuzzel:** Lebih ringan dari Wofi, dibangun murni untuk Wayland (tanpa GTK, menggunakan library fcft untuk font). Sangat disukai pengguna Arch garis keras karena kecepatan dan minimalisnya.
2.  **Rofi (Wayland Fork):** Rofi versi klasik yang di-porting ke Wayland. Pilihan bagus jika Anda butuh fitur yang sangat kompleks.

Namun, untuk saat ini, **Wofi** adalah titik tengah terbaik antara estetika CSS dan fungsi.

-----

### 5\. Sumber Resmi & Komunitas (The Holy Grail)

Simpan daftar ini sebagai referensi abadi Anda:

1.  **Arch Wiki - Wofi:**
      * Selalu cek [Arch Wiki](https://www.google.com/search?q=https://wiki.archlinux.org/title/Wofi) pertama kali. Jika ada error spesifik Arch, solusinya ada di sana.
2.  **Sourcehut Repository (Upstream):**
      * [hg.sr.ht/\~scoopta/wofi](https://hg.sr.ht/~scoopta/wofi). Di sini Anda bisa melihat *source code* aslinya.
3.  **Man Pages (Local):**
      * Jangan lupa, dokumentasi terbaik sudah ada di laptop Anda.
      * `man wofi`
      * `man 5 wofi`
      * `man 7 drun` (Memahami format file desktop entry).

-----

### 🎓 Penutupan Kelas: Graduation

# Selamat! Anda telah menyelesaikan kursus **Mastering Wofi on Sway**.

Anda telah mempelajari:

1.  **Installation:** Memahami dependensi dan cara instal di Arch.
2.  **Configuration:** Menguasai sintaks config dan CSS styling (GTK).
3.  **Integration:** Menghubungkan Wofi dengan Sway via `bindsym`.
4.  **Scripting:** Membuat logika Power Menu sendiri menggunakan Bash & Pipes.
5.  **Troubleshooting:** Cara mendiagnosis error layaknya profesional.

# Selamat!

Sekarang, sistem Anda bukan lagi sekadar kumpulan paket default. Ia adalah cerminan dari efisiensi dan logika Anda.

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
