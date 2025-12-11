> Salin-Tempel berikut ini dan ubah bagia TOPIC :

Saya ingin sebuah dokumen referensi teknis komprehensif tentang: **{TOPIC}**

Tugas Anda: hasilkan jawaban profesional, teknis, dan lengkap — dalam bahasa Indonesia — yang mengikuti struktur dan level detail berikut **tepat** (jangan lewati struktur; setiap bagian harus ada):

1. **Overview singkat**  
   - Perkenalkan apa itu {TOPIC} dalam 3–6 kalimat ringkas (tujuan utama, domain penggunaan).  
   - Sebutkan *pendiri / pencipta / tim inti* jika tersedia dan relevan (nama + peran singkat).  
   - Jika relevan, tambahkan satu kalimat kenapa topik ini penting saat ini.

2. **Daftar sumber & dokumentasi resmi (setiap entri harus mengandung)**  
   Untuk setiap *sumber resmi/utama* (minimal 8–12 entri tergantung topik):  
   - Judul sumber — **URL lengkap** (link).  
   - **Ringkasan isi**: apa yang ada di sumber itu (2–5 kalimat).  
   - **Alasan / tujuan**: mengapa sumber ini penting untuk dipelajari atau disimpan.  
   - **Cara menyimpan/offline**: langkah singkat (perintah `wget`/`git clone`/unduh PDF atau docset) agar bisa diakses offline.  
   - **Catatan teknis**: bahasa apa sumber itu ditulis, apakah perlu toolchain tertentu untuk membangunnya, lisensi penting.  
   - Prioritaskan sumber otoritatif: spesifikasi resmi, manual vendor, repositoris resmi, dokumentasi toolchain, dan buku/whitepaper penting.

   > Tambahkan sitasi/hyperlink untuk **setiap** sumber (URL harus lengkap).

3. **Instalasi untuk semua sistem operasi & termasuk perintah CLI untuk linux (cont: Arch Linux / Debian/Ubuntu)**  
   - Berikan tata cara instalasinya secara lengkap dan perintah instalasi nyata untuk *Arch Linux* **dan** *Debian/Ubuntu* (atau catat "tidak perlu" jika tidak relevan).  
   - Sertakan satu blok contoh perintah lengkap (copy-paste ready) untuk menginstal toolchain/utility paling penting.  
   - Di akhir sub-bagian ini, tuliskan versi minimal/rekomendasi paket bila relevan.

4. **Identitas teknis & persyaratan untuk memodifikasi / mengembangkan**  
   - Sebutkan **bahasa apa** teknologi/tool tersebut ditulis (mis. C, Rust, Go, Java).  
   - Daftar dependensi build utama (toolchain, compiler, libs).  
   - Langkah singkat (3–6 langkah) bagaimana membangun dari sumber (git clone → konfigurasi → build → test).  
   - Wajib jelaskan tingkat pengalaman yang dibutuhkan (wajib, opsional).

5. **Tooling & implementasi (apa saja yang ada: compiler, runtimes, alternatif)**  
   - Ringkas per-implementasi (mis. implementasi A: overview + kapan pakai).  
   - Alasan memilih satu implementasi di atas yang lain (keuntungan/kerugian).

6. **Perintah CLI penting — kata-per-kata**  
   - Pilih 10–20 perintah/operasi yang paling sering dipakai untuk {TOPIC}.  
   - Untuk tiap perintah, jelaskan token demi token (apa arti masing-masing argumen/flag) dan contoh output jika relevan.  
   - Sertakan saran troubleshooting singkat (1–2 baris) untuk error umum.

7. **Membangun dari source & kontribusi**  
   - Instruksi untuk clone repo resmi, bootstrap, dan menjalankan test suite.  
   - Tips contribution (code style, CI, test coverage, PR etiquette).  
   - Keterangan apakah repo self-hosted / membutuhkan build bootstrap.

8. **Debugging / profiling / sanitizers / testing**  
   - Tools & perintah untuk debugging/profiling (contoh: gdb/delve/pprof/miri/valgrind).  
   - Perintah contoh dengan penjelasan token-per-token.  
   - Rekomendasi praktik aman (sandboxing, lisensi, legal).

9. **Keamanan & etika**  
   - Singkat: peringatan legal/etis jika topik punya potensi disalahgunakan.  
   - Rekomendasi praktik aman dan sandbox.

10. **Referensi buku & kursus (prioritas)**  
    - Minimal 6 rekomendasi buku/kursus (dengan URL) dan ringkasan kecil kenapa tiap buku penting.

11. **Checklist file yang wajib diunduh (minimal)**  
    - Buat checklist actionable (PDF/spec/repos) yang harus diunduh untuk arsip offline.

12. **Roadmap pembelajaran terstruktur (ringkas & berurutan)**  
    - Berikan 10–12 langkah pembelajaran yang direkomendasikan, berurutan dari *apa harus dipelajari pertama* → *praktik menengah* → *advanced* (untuk pembelajaran 3 bulan / 6 bulan).  
    - Untuk tiap langkah, berikan tujuan singkat dan satu latihan praktis rekomendasi.

13. **Output deliverables & opsi ekspor**  
    - Tawarkan 3 opsi output: (A) README Markdown lengkap; (B) CSV tabel sumber (kolom: kategori, judul, URL, penggunaan singkat); (C) Skrip bash otomatis yang mengunduh semua PDF/repos primer ke `~/docs/{topic}/`.  
    - Jika ditanya, berikan file/scripting content saat user pilih.

14. **Sitasi & bukti (paling load-bearing)**  
    - Dalam jawaban, *ciderahkan* dan sertakan link untuk **5 pernyataan terpenting** yang kemungkinan berubah dari waktu ke waktu (rilis, versi, standar).  
    - Pastikan semua klaim non-trivial memiliki link.

15. **Gaya & batasan**  
    - Jawaban harus: bahasa Indonesia profesional, hangat tetapi formal, ringkas di pembukaan, mendalam di badan teks.  
    - Untuk tiap potongan perintah CLI/skrip, jelaskan **kata-per-kata** setiap token.  
    - Jika ada ketidakmampuan (mis. sumber berbayar, atau akses luar AI), jelaskan secara singkat apa yang tidak bisa disediakan dan apa alternatifnya.  
    - Jangan minta klarifikasi — jika informasi topik ambiguitas, buatlah asumsi yang wajar dan sebutkan asumsi tersebut singkat di awal.  

Hasil yang saya inginkan harus **sesuai** struktur di atas, mencakup semua bagian, dan wajib disampaikan dalam bahasa Indonesia profesional tanpa mengurangi nilai teknisnya tetapi anda tetap diperbolehkan untuk menyertakan maksud dari istilah teknis tersebut jika ada.  

---

**Tambahan teknis opsional yang saya (user) dapat set pada prompt:**  
- `DEPTH=short|medium|deep` — tingkat kedalaman (default `deep`).  
- `EXPORT=yes|no` — apakah AI harus langsung menghasilkan file Markdown/CSV/Script.  
- `OFFLINE=yes|no` — apakah prioritaskan tautan yang dapat diunduh offline.

Contoh penggunaan (fill-in singkat):
> "Jelaskan {TOPIC} = `Kubernetes`, DEPTH=deep, EXPORT=yes, OFFLINE=yes"

