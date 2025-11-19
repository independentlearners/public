Kurikulum ini disusun untuk menjembatani pemahaman teknis mendalam tentang **Wofi pada ekosistem Arch Linux (Sway/Wayland)** dengan tambahan peningkatan kemampuan bahasa Inggris profesional. Berikut adalah **Rancangan Kurikulum (Syllabus)** untuk kelas "Mastering Wofi in Sway".

---

### [🎓 Kurikulum Kelas: Mastering Wofi on Sway Window Manager][0]
**Target:** Pemahaman mendalam tentang launcher Wofi, integrasi total dengan Sway, sintaks konfigurasi, *scripting* tingkat lanjut (CLI), penanganan error, serta penguasaan Bahasa Inggris Teknis.

#### **[Modul 1: Identitas, Konsep Dasar, dan Instalasi][a]**
* **Fokus Teknis:**
    * Apa itu Wofi? (Perbedaan dengan Rofi/Dmenu).
    * Identitas Teknologi: Bahasa pembuat (C), lisensi, dan repositori (Sourcehut/Github).
    * Arsitektur: Bagaimana Wofi berinteraksi dengan protokol Wayland.
    * Instalasi di Arch Linux (Pacman vs AUR) dan dependensi wajib.
* **Fokus Bahasa Inggris:**
    * **Vocabulary:** *Dependency, Repository, Protocol, Fork, Deprecated.*
    * **Grammar:** Penggunaan *Passive Voice* dalam dokumentasi teknis (e.g., *"Wofi is built based on..."*).

#### **[Modul 2: Bedah Sintaks dan Anatomi Konfigurasi][b]**
* **Fokus Teknis:**
    * **The Config File:** Penjelasan mendalam mengenai format standar (INI-style syntax). Kita akan membedah struktur *Key-Value pairs*.
    * **The Style File:** Penjelasan sintaks CSS (GTK3 CSS) yang digunakan Wofi. Memahami *Selectrors*, *Properties*, dan *Values*.
    * **Mode Operasi:** Memahami argumen CLI (`--show drun`, `--show run`, `--dmenu`).
* **Fokus Bahasa Inggris:**
    * **Terminologi:** *Syntax, Parameter, Argument, Property, Selector.*
    * **Professional Interaction:** Cara bertanya atau menjelaskan struktur kode (e.g., *"Could you clarify the syntax for..."*).

#### **[Modul 3: Integrasi Wofi ke dalam Sway (The Handshake)][c]**
* **Fokus Teknis:**
    * Mbedah file konfigurasi Sway (`~/.config/sway/config`).
    * Sintaks `bindsym` dan variabel di Sway.
    * Menggantikan `dmenu` default dengan Wofi.
    * Fuzzy Search concept: Bagaimana algoritma pencarian bekerja.
* **Fokus Bahasa Inggris:**
    * **Grammar:** *Imperative Sentences* (Kalimat perintah) yang sering muncul di file konfigurasi dan manual.
    * **Connectors:** Kata hubung untuk menjelaskan sebab-akibat (*Therefore, Thus, Consequently*).

#### **[Modul 4: Advanced Scripting & Custom Menus (CLI Focus)][d]**
* **Fokus Teknis:**
    * **Standard Input (stdin) & Pipes:** Konsep inti Linux (`|`) untuk mengirim data ke Wofi.
    * Membuat menu interaktif kustom (contoh: Power Menu, Wifi Menu) menggunakan Bash Script.
    * Membaca *Standard Output (stdout)* dari Wofi untuk dieksekusi.
    * Sintaks Bash dasar yang diperlukan: `case`, `echo`, `printf`, `read`.
* **Fokus Bahasa Inggris:**
    * **Technical Descriptions:** Menjelaskan alur data (*Data Flow*).
    * **Verbs:** *Pipe, Redirect, Execute, Parse, Fetch.*

#### **[Modul 5: Troubleshooting, Error Handling, & Resources][e]**
* **Fokus Teknis:**
    * Cara membaca log error Wofi (menjalankan via terminal untuk *debugging*).
    * Masalah umum: *Missing icons, Cache issues, Scaling/Resolution issues on Wayland.*
    * Alternatif jika Wofi gagal (Fuzzel, Bemenu) – *Plan B*.
    * Sumber Referensi: Menelusuri dokumentasi resmi (`man wofi`, `man 5 wofi`) dan diskusi komunitas (Arch Wiki, Reddit, Github Issues).
* **Fokus Bahasa Inggris:**
    * **Reading Comprehension:** Menganalisis pesan error (*Error messages*).
    * **Grammar:** *Conditional Sentences* (If clauses) untuk menjelaskan skenario *troubleshooting* (*"If the error persists, then..."*).

---

#####  📝 Metodologi Pembelajaran

Setiap kali kita memasuki sebuah modul, struktur penjelasannya akan seperti ini:

1.  **Technical Deep Dive:** Penjelasan konsep, sintaks, dan cara kerja (Indonesia).
2.  **English Corner:**
    * **Key Vocabulary:** Daftar kata penting (Noun/Verb/Adjective).
    * **Grammar Focus:** Bedah satu aturan tata bahasa yang relevan dengan teks teknis tersebut.
    * **Example Phrases:** Contoh kalimat profesional untuk dokumentasi atau percakapan kerja.
3.  **Implementation:** Kode, Konfigurasi, atau Perintah CLI.
4.  **Official Sources:** Link ke dokumentasi resmi (man pages/repo).
5.  **Error Handling:** Apa yang harus dilakukan jika langkah ini gagal.

---

##  Materi Tambahan & Sumber Referensi (awalan)

* Repo / README wofi (dependensi & build): ([GitHub][1])
* Tutorial & artikel pengguna: mephisto (pengantar penggunaan): ([mephisto.cc][5])
* Koleksi tema wofi (contoh style.css): ([GitHub][3])
* Perbandingan app launcher Wayland (untuk konteks dan alternatif): ([Mark Stosberg][6])
* Daftar paket Debian/Arch terkait wofi (packaging): ([packages.debian.org][7])
* `drun` mode: bagaimana wofi mengambil `.desktop` (desktop database). ([bbs.archlinux.org][2])
* Contoh proyek: `wofi-power-menu` (arsitektur), cara memanggil wofi dari skrip, opsi konfirmasi. ([GitHub][4])

---

##  Format pengajaran & deliverable per modul

* Teori ringkas (konsep inti).
* Contoh konfigurasi minimal (dijelaskan kata-per-kata untuk tiap baris ketika masuk isi materi).
* Latihan hands-on & file contoh (`~/.config/wofi/config`, `style.css`, contoh skrip power-menu).
* Checklist debugging untuk tiap topik.
* Kuis singkat & tugas coding.
* Diakhiri dengan PR/patch example untuk fase kontribusi.

---

##  Estimasi pembagian waktu belajar (opsional)

Estimasi jam per fase supaya Anda punya gambaran; ini fleksibel dan bisa disesuaikan:

* Modul 0–2 (fundamental): 2–4 jam
* Modul 3–5 (konfig & thema): 4–8 jam
* Modul 6–8 (scripting, build, debug): 6–12 jam
* Modul 9–10 (packaging & proyek): 4–8 jam

<!--
(Bila Anda ingin saya ubah alokasi atau jadwal pembelajaran sesuai rutinitas Anda, saya sesuaikan.)
Kalau kurikulum ini sudah sesuai — **konfirmasi** saja, lalu saya mulai mengerjakan: saya akan mengembangkan **Modul 1 (Fase 0 + 1)** atau modul yang Anda pilih menjadi materi lengkap dengan contoh perintah, penjelasan kata-per-kata setiap argumen, file config contoh, dan latihan praktis.

Saya siap mulai kapan Anda bilang “lanjut” — beri tanda yang jelas (mis. “mulai modul 1”) agar saya langsung keluarkan materi lengkapnya.

-->
---

[0]: ../README.md
[1]: https://github.com/SimplyCEO/wofi?utm_source=chatgpt.com "SimplyCEO/wofi"
[2]: https://bbs.archlinux.org/viewtopic.php?id=296070&utm_source=chatgpt.com "[SOLVED] Wofi drun Where does it pull Applications from? ..."
[3]: https://github.com/joao-vitor-sr/wofi-themes-collection?utm_source=chatgpt.com "joao-vitor-sr/wofi-themes-collection"
[4]: https://github.com/szaffarano/wofi-power-menu?utm_source=chatgpt.com "szaffarano/wofi-power-menu"
[5]: https://mephisto.cc/en/tech/wofi/?utm_source=chatgpt.com "Wofi Tutorial - mephisto.cc"
[6]: https://mark.stosberg.com/rofi-alternatives-for-wayland/?utm_source=chatgpt.com "Rofi alternatives for Wayland: app launcher, window switcher ..."
[7]: https://packages.debian.org/wofi?utm_source=chatgpt.com "Debian -- Package Search Results -- wofi"

[a]: ../wofi/bagian-1/README.md
[b]: ../wofi/bagian-2/README.md
[c]: ../wofi/bagian-3/README.md
[d]: ../wofi/bagian-4/README.md
[e]: ../wofi/bagian-5/README.md
<!--
[f]: ../wofi/bagian-6/README.md
[g]: ../wofi/bagian-7/README.md
[h]: ../wofi/bagian-8/README.md
[i]: ../wofi/bagian-9/README.md
[j]: ../wofi/bagian-10/README.md
[k]: ../wofi/bagian-11//README.md
[l]: ../wofi/bagian-12/README.md
[m]: ../wofi/bagian-13/README.md
[n]: ../wofi/bagian-14/README.md
[o]: ../wofi/bagian-15/README.md
[p]: ../wofi/bagian-1/README.md
[q]: ../wofi/bagian-1/README.md
[r]: ../wofi/bagian-1/README.md-->
