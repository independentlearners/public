# Ini adalah **Ujian Akhir (Final Capstone Project)** untuk kurikulum *"Mastery in Bash Scripting"*.

Tujuan ujian ini bukan untuk menghukum, tetapi untuk menantang Anda menggabungkan **semua 5 Fase** yang telah dipelajari menjadi satu solusi nyata yang elegan.

-----

# 🎓 UJIAN AKHIR: The "SysAdmin Savior" Tool

## Skenario Studi Kasus

Anda baru saja direkrut sebagai DevOps Engineer di sebuah startup. Senior Anda memberikan tugas pertama:

> "Server kita sering penuh karena file log lama menumpuk. Selain itu, kita butuh laporan harian apakah ada 'CRITICAL ERROR' di log tersebut. Tolong buatkan **satu script** yang bisa membersihkan log lama, mengarsipkannya, mencari error, dan mengirim laporan JSON ke tim."

-----

## 📋 Spesifikasi Teknis (Requirements)

Script Anda harus memenuhi kriteria berikut (menguji Fase 1-5):

1.  **Keamanan (Fase 5):** Script wajib menggunakan *Strict Mode* (`set -euo pipefail`) dan menangani sinyal `Ctrl+C` dengan `trap` untuk pembersihan file sampah.
2.  **Input Argumen (Fase 2):** Script harus menerima input folder target.
      * Contoh: `./log_manager.sh /var/log/app`
      * Jika argumen kosong, tampilkan pesan bantuan (Usage).
3.  **Modularitas (Fase 4):** Kode utama harus dipecah minimal menjadi 3 fungsi:
      * `check_disk_space()`
      * `archive_logs()`
      * `generate_report()`
4.  **Pemrosesan Teks (Fase 3):** Gunakan `find` untuk mencari file `.log` yang lebih tua dari 7 hari. Gunakan `grep`/`awk` untuk menghitung jumlah kata "ERROR" di dalamnya.
5.  **Interoperabilitas (Fase 4):** Output akhirnya harus berupa format **JSON** (gunakan `jq` atau format manual) yang berisi: Tanggal, Jumlah File Diarsipkan, dan Total Error Ditemukan.

-----

## 📝 Soal Bagian 1: Konsep Kilat (The Gauntlet)

*Jawablah ini di dalam hati atau kertas untuk menguji ingatan Anda sebelum mulai coding.*

1.  Apa arti angka **755** pada perintah `chmod`?
2.  Apa bedanya `echo $VAR` dengan `echo '$VAR'`?
3.  Mengapa kita menggunakan `set -e` di awal script?
4.  Apa bedanya `>` dan `>>`?
5.  Bagaimana cara mengambil output dari perintah `date` dan menyimpannya ke variabel?

-----

## 🛠️ Soal Bagian 2: The Coding Challenge

**Tugas:** Buat file bernama `log_savior.sh`.

Cobalah tulis sendiri dulu berdasarkan spesifikasi di atas. Jangan melihat kunci jawaban di bawah sampai Anda benar-benar mentok atau sudah selesai\!

**Visualisasi Alur Logika (Flowchart):**

[Image of For Loop Flowchart]

*(Bayangkan alurnya: Start -\> Cek Argumen -\> Init Trap -\> Loop File Log -\> Jika \> 7 hari -\> Grep Error -\> Zip File -\> Tambah ke Laporan -\> Generate JSON -\> End)*

-----

### 🛑 SPOILER ALERT: Kunci Jawaban & Pembahasan 🛑

Hanya buka bagian ini jika Anda sudah mencoba menulis kode Anda sendiri.

.
.
.

### Kunci Jawaban: `log_savior.sh`

```bash
#!/bin/bash

# --- FASE 5: Defensive Coding ---
# Aktifkan mode ketat agar script mati jika ada error/variabel kosong
set -euo pipefail

# Variabel Global
TARGET_DIR="${1:-}" # Ambil argumen pertama, default kosong jika tidak ada
REPORT_FILE="/tmp/log_report.json"
ARCHIVE_DIR="./archive_logs"
TOTAL_ERRORS=0
ARCHIVED_COUNT=0

# --- FASE 5: Trap / Cleanup ---
cleanup() {
    # Fungsi ini otomatis jalan saat script exit
    echo ""
    echo "🧹 Membersihkan file sementara..."
    # (Di kasus nyata, hapus file temp di sini)
    echo "✅ Selesai."
}
trap cleanup EXIT

# --- FASE 4: Fungsi Helper ---
usage() {
    echo "Usage: $0 <directory_log>"
    echo "Contoh: $0 /var/log/myapp"
    exit 1
}

check_prerequisites() {
    # FASE 2: Logic & Conditional
    if [ -z "$TARGET_DIR" ]; then
        echo "❌ Error: Target directory belum ditentukan."
        usage
    fi

    if [ ! -d "$TARGET_DIR" ]; then
        echo "❌ Error: Directory '$TARGET_DIR' tidak ditemukan!"
        exit 1
    fi
    
    # Cek apakah jq terinstall (Fase 4)
    if ! command -v jq &> /dev/null; then
        echo "❌ Error: 'jq' belum terinstall. Mohon install dulu."
        exit 1
    fi

    mkdir -p "$ARCHIVE_DIR"
}

analyze_and_archive() {
    echo "🔍 Memindai log yang lebih tua dari 7 hari di: $TARGET_DIR"

    # FASE 2 & 3: Loops & Find
    # Menggunakan process substitution < <(...) agar variabel di dalam loop
    # tetap bisa diakses di luar loop (masalah scope bash standard)
    while IFS= read -r file; do
        echo "   -> Memproses: $file"
        
        # FASE 3: Grep & Awk (Menghitung kata ERROR case insensitive)
        # || true agar script tidak mati jika grep tidak menemukan apa-apa
        count=$(grep -i -c "ERROR" "$file" || true)
        
        # Aritmatika Bash (Fase 2)
        TOTAL_ERRORS=$((TOTAL_ERRORS + count))
        
        # Kompres file (Manipulasi File Fase 1)
        gzip -c "$file" > "$ARCHIVE_DIR/$(basename "$file").gz"
        
        # Hapus file asli (simulasi dengan echo agar aman saat latihan)
        # rm "$file" 
        
        ((ARCHIVED_COUNT++))
        
    done < <(find "$TARGET_DIR" -type f -name "*.log" -mtime +7)
}

generate_json_report() {
    # FASE 4: JSON creation dengan jq
    echo "📊 Membuat laporan JSON..."
    
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Menggunakan jq -n untuk membuat object baru
    jq -n \
       --arg ts "$TIMESTAMP" \
       --arg dir "$TARGET_DIR" \
       --argjson files "$ARCHIVED_COUNT" \
       --argjson errs "$TOTAL_ERRORS" \
       '{
         timestamp: $ts,
         target_directory: $dir,
         status: "success",
         stats: {
           files_archived: $files,
           total_errors_found: $errs
         }
       }' > "$REPORT_FILE"
       
    cat "$REPORT_FILE"
}

# --- MAIN EXECUTION ---
check_prerequisites
analyze_and_archive
generate_json_report
```

-----

### 📊 Kriteria Penilaian Mandiri (Rubrik)

Cek script buatan Anda dan beri nilai:

1.  **Fungsionalitas (40 Poin):**

      * [ ] Apakah script bisa jalan tanpa error? (10)
      * [ ] Apakah script berhasil menemukan file \> 7 hari? (10)
      * [ ] Apakah script berhasil menghitung jumlah Error? (10)
      * [ ] Apakah output JSON valid? (10)

2.  **Keamanan & Best Practice (30 Poin):**

      * [ ] Apakah ada `set -euo pipefail`? (10)
      * [ ] Apakah input folder divalidasi (cek folder ada/tidak)? (10)
      * [ ] Apakah variabel di-quote `"$VAR"` untuk menangani spasi? (10)

3.  **Kualitas Kode (30 Poin):**

      * [ ] Apakah kode menggunakan Fungsi? (10)
      * [ ] Apakah nama variabel jelas (bukan `$x`, `$y`)? (10)
      * [ ] Apakah ada komentar penjelasan? (10)

**Total Skor:**

  * **90-100:** Level **Expert**. Anda siap untuk kerja di Enterprise.
  * **70-89:** Level **Advanced**. Kode jalan, tapi perlu sedikit perapian di keamanan.
  * **\< 70:** Level **Intermediate**. Review kembali Modul 2 dan 3.

-----

### Langkah Penutup

Selamat\! Anda telah menyelesaikan seluruh rangkaian kurikulum ini. Anda sekarang memiliki kemampuan yang dimiliki oleh kurang dari 10% pengguna komputer di dunia: **Kemampuan untuk berbicara langsung dengan mesin dan memerintahnya melakukan tugas kompleks secara otomatis.**

**Apa yang harus Anda lakukan sekarang?**
Simpan script `log_savior.sh` ini di akun GitHub Anda. Beri nama repositori: `bash-automation-tools`. Ini adalah portofolio nyata yang bisa Anda tunjukkan saat wawancara kerja.

Terima kasih telah belajar bersama saya. Jika suatu hari Anda menjadi Senior DevOps Engineer, ingatlah dasar-dasar ini.

*Session complete. Happy Scripting\!* 🐧

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
