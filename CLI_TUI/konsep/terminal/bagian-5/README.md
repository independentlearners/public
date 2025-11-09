# Saran Praktik

Setelah menguasai seluruh kurikulum kini saatnya menyusun proyek nyata. Ini adalah fase di mana teori bertemu dengan praktik, dan pengetahuan Anda akan berubah menjadi keahlian yang terbukti.

---

### **Penerapan Praktis: Membangun Proyek Nyata**

Ini adalah momen untuk menerapkan semua yang telah Anda pelajari. Fokuslah pada proyek yang dapat menyelesaikan masalah sehari-hari atau mengotomatisasi tugas yang biasa Anda lakukan. Berikut adalah beberapa ide proyek, dibagi berdasarkan tingkat kompleksitas, yang akan mengkonsolidasikan keterampilan Anda:

* **Tingkat Pemula:** **Skrip Pencadangan Otomatis.**
    * **Deskripsi:** Buat skrip Bash sederhana yang menyalin direktori penting (misalnya, `~/Documents`, `~/Pictures`) ke direktori cadangan (`~/backup`).
    * **Keterampilan yang Diterapkan:**
        * **Manajemen File:** Perintah `cp` dan `mkdir`.
        * **Shell Scripting:** Penggunaan variabel untuk direktori sumber dan tujuan, dan mungkin penggunaan `date` untuk memberi nama direktori cadangan dengan tanggal.
    * **Tantangan Tambahan:** Jadwalkan skrip ini untuk berjalan secara otomatis setiap hari menggunakan `cron` di Linux atau penjadwal tugas di Termux.

* **Tingkat Menengah:** **Alat Pembersih Sistem.**
    * **Deskripsi:** Kembangkan skrip yang mencari dan menghapus file sementara, file log lama, atau file yang tidak digunakan di direktori tertentu.
    * **Keterampilan yang Diterapkan:**
        * **Piping dan Redirection:** Menggabungkan `find` untuk mencari file, `grep` untuk menyaring hasilnya, dan `xargs` untuk menghapusnya. Contoh: `find . -type f -name "*.log" | xargs rm`.
        * **Kondisional:** Tambahkan logika untuk meminta konfirmasi dari pengguna sebelum menghapus file, atau untuk mengecualikan direktori penting.

* **Tingkat Ahli:** **Skrip Deployment Web Otomatis.**
    * **Deskripsi:** Buat skrip yang terhubung ke server jarak jauh (melalui **SSH**), menarik kode terbaru dari repositori **Git** (`git pull`), dan memulai ulang layanan web (misalnya, kontainer Docker atau Nginx).
    * **Keterampilan yang Diterapkan:**
        * **Integrasi Teknologi:** Menggunakan `ssh` untuk koneksi, perintah `git` untuk manajemen kode, dan perintah `docker` untuk mengelola layanan.
        * **Shell Scripting Tingkat Lanjut:** Menggunakan fungsi untuk memecah tugas (misalnya, fungsi `deploy()` dan `restart_service()`), dan menggunakan `if` untuk memeriksa apakah deployment berhasil.

---

### **Pembelajaran Berkelanjutan**

Setelah Anda merasa nyaman dengan proyek-proyek ini, lanjutkan pembelajaran Anda dengan dua jalur utama:

* **Jalur 1: Menjadi Ahli Administrasi Sistem.**
    Fokus pada topik-topik seperti manajemen pengguna, izin file yang lebih dalam, konfigurasi jaringan, dan manajemen paket lanjutan. Untuk pengguna Arch Linux seperti Anda, ini berarti mendalami `pacman`, `systemd`, dan konfigurasi sistem. Sumber daya utama Anda adalah **Arch Wiki**.
* **Jalur 2: Menjadi Ahli Pengembangan Skrip.**
    Pelajari bahasa scripting yang lebih canggih seperti **Python** atau **Perl**. Bahasa-bahasa ini menawarkan struktur data dan pustaka yang lebih kaya untuk tugas-tugas yang kompleks, sementara Bash tetap menjadi alat yang sempurna untuk tugas administrasi.

Membuat proyek-proyek ini adalah cara terbaik untuk menguji dan menguatkan pemahaman Anda. Klik selanjutnya jika anda ingin mempelajari kurikululm khusus **shellscripting**

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../programmer/domain-spesifik/README.md
[kurikulum]: ../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../../../programmer/domain-spesifik/embeddeble/bash/README.md

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
