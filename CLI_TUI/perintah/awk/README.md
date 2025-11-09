**Panduan Lengkap Penggunaan `awk` di Arch Linux (dan Linux Lainnya)**

**1. Pengenalan AWK**  
`awk` adalah bahasa pemrograman dan utilitas CLI untuk memproses teks, data terstruktur (CSV, log, dll.), dan melakukan transformasi kompleks. Di Arch Linux, `awk` biasanya merujuk ke **GNU Awk (gawk)** dengan fitur ekstensi.

---

**2. Sintaks Dasar**

```bash
awk 'pattern { action }' input_file
```

- **Pattern**: Kondisi (bisa regex, perbandingan, dll.) atau kosong (eksekusi untuk semua baris).
- **Action**: Perintah yang dijalankan jika pattern terpenuhi (contoh: `print`, perhitungan).

---

**3. Cara Kerja AWK**

- Setiap baris input adalah **record**.
- Record terbagi menjadi **fields** (kolom) berdasarkan pemisah (`FS`, default: spasi/tab).
- Pemrosesan dilakukan per record, dengan variabel khusus:
  - `$0`: Seluruh record.
  - `$1, $2, ...`: Kolom 1, 2, dst.
  - `NR`: Nomor record saat ini.
  - `NF`: Jumlah kolom di record saat ini.
  - `FS`: Field separator (input).
  - `OFS`: Output field separator.

---

**4. Dasar-Dasar Penggunaan**

**a. Print Kolom**

```bash
awk '{print $1, $3}' file.txt  # Print kolom 1 dan 3
awk '{print $NF}' file.txt     # Print kolom terakhir
```

**b. Filter Berdasarkan Kondisi**

```bash
awk '$3 > 100 {print $0}' data.csv      # Jika kolom 3 > 100
awk '/error/ {print}' log.txt           # Jika baris mengandung "error"
```

**c. Variabel Bawaan & Custom**

```bash
awk 'BEGIN {FS=":"; OFS=" - "} {print $1, $NF}' /etc/passwd
awk '{sum += $1} END {print sum}' numbers.txt
```

**d. Operator & Ekspresi**

```bash
awk '$1 == "root" && $3 == 0 {print}' /etc/passwd
awk 'NR % 2 == 0 {print}' file.txt  # Print baris genap
```

---

**5. Tingkat Lanjut (Advanced)**

**a. Array Asosiatif**

```bash
# Hitung frekuensi kata
awk '{for (i=1; i<=NF; i++) count[$i]++} END {for (word in count) print word, count[word]}' text.txt
```

**b. Fungsi Bawaan**

- **String**: `length()`, `substr()`, `split()`, `gsub()/sub()`
  ```bash
  awk '{gsub(/error/, "CRITICAL"); print}' log.txt
  ```
- **Matematika**: `sqrt()`, `int()`, `rand()`
  ```bash
  awk '{print sqrt($1)}' numbers.txt
  ```

**c. Kontrol Alur (Loop & Kondisi)**

```bash
awk '{
  if ($3 >= 90) grade = "A";
  else if ($3 >= 80) grade = "B";
  else grade = "F";
  print $1, grade
}' scores.txt
```

**d. Multi-file & Block Khusus**

- `BEGIN`: Jalankan sebelum proses input.
- `END`: Jalankan setelah semua input diproses.

```bash
awk 'BEGIN {print "Mulai"} /pattern/ {print} END {print "Selesai"}' file1.txt file2.txt
```

**e. Input dengan Pemisah Kustom**

```bash
awk -F',' '{print $2}' data.csv          # Pemisah koma
awk -F'[:\t]' '{print $1}' config.txt    # Multiple pemisah
```

---

**6. Integrasi dengan Command Lain**

**a. Pipe ke/filter dari Command**

```bash
ps aux | awk '$3 > 50 {print $2, $3}'          # Proses dengan CPU >50%
grep "GET" access.log | awk '{print $7}' | sort | uniq -c
```

**b. Gabung dengan `sed`, `xargs`, dll.**

```bash
awk '{print $1}' emails.txt | xargs -I {} sed -i "s/{}//g" data.txt
```

**c. Parsing Output Command**

```bash
df -h | awk '/\/dev\/sd/ {print $1, $5}'       # Partisi disk dan penggunaan
pacman -Qe | awk '{print $1}' > packages.txt    # Daftar paket terinstall
```

---

**7. Contoh Implementasi Kompleks**

**a. Laporan Sistem**

```bash
# Hitung penggunaan memori proses
ps aux | awk 'NR>1 {mem[$11] += $4} END {for (p in mem) print p, mem[p] "%"}'
```

**b. Analisis Log Apache**

```bash
# Hitung request per IP
awk '{ip_count[$1]++} END {for (ip in ip_count) print ip, ip_count[ip]}' access.log
```

**c. Transformasi Data CSV**

```bash
awk -F',' 'BEGIN {OFS=";"} {gsub(/ /, "_", $2); print $1, $2, $3*1.1}' data.csv
```

**d. Validasi Data**

```bash
# Cek email valid
awk '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ {print "Valid:", $0}' emails.txt
```

---

**8. Optimisasi & Tips**

- **In-Place Edit**:
  ```bash
  awk '{...}' input.txt > tmp && mv tmp input.txt
  ```
- **Prefer `printf` untuk Format Kompleks**:
  ```bash
  awk '{printf "%-10s %5d\n", $1, $2}' data.txt
  ```
- **Gunakan `next` untuk Skip Baris**:
  ```bash
  awk '/skipme/ {next} {print}'
  ```
- **Proses File Besar**:
  ```bash
  awk '{...}' large_file.txt | head -n 1000   # Batasi output
  ```

---

**9. Dokumentasi & Referensi**

- Baca manual: `man awk` atau `info gawk`.
- **Buku**: _GAWK: Effective AWK Programming_ (tersedia di `gawk-doc` package di Arch).
- **Online**: [GNU AWK User's Guide](https://www.gnu.org/software/gawk/manual/).

---

**Kesimpulan**  
`awk` adalah alat **super powerful** untuk:

- Pemrosesan teks & data terstruktur.
- Laporan, statistik, dan transformasi data.
- Integrasi dengan CLI tools lainnya.  
  Dengan penguasaan `awk`, Anda bisa menggantikan banyak script Python/Bash sederhana dengan **one-liner yang efisien**!
