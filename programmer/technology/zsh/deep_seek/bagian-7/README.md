# FASE 7: PRAKTIK NYATA & MENTAL PROGRAMMING

> **📌 Catatan Audit & Posisi Fase Ini:**
> Fase ini **tidak tercantum** dalam kurikulum asli yang Anda unggah. Ini adalah fase tambahan yang dibangun berdasarkan prinsip "learning by doing" — mengubah semua teori dari Fase 1–6 menjadi **proyek nyata yang mensimulasikan dunia kerja**. Tujuannya bukan mengulang kurikulum, melainkan **membentuk mental programming** dan kemampuan menerjemahkan pengetahuan menjadi aksi. Setiap modul mewakili satu fase kurikulum, dengan pertanyaan dan jawaban yang mencerminkan skenario proyek nyata.

---

## Struktur Fase 7

| Modul | Mewakili Fase | Tema Proyek Nyata |
|-------|---------------|-------------------|
| **7.1** | Fase 1 (Fondasi) | Onboarding Developer Baru di Startup "Nusantara Tech" |
| **7.2** | Fase 2 (Scripting Dasar) | Otomatisasi Backup & Log Rotation |
| **7.3** | Fase 3 (Globbing, Completion, Konfigurasi) | Membangun Sistem Konfigurasi Tim yang Skalabel |
| **7.4** | Fase 4 (Ekosistem, Performa, Keamanan) | Audit & Optimasi Lingkungan Shell Tim |
| **7.5** | Fase 5 (Scripting Lanjutan & Testing) | Membangun CLI Tool dengan Test Suite |
| **7.6** | Fase 6 (Expert) | Arsitektur Enterprise & Kontribusi Open Source |
| **7.7** | **Capstone** | Proyek Akhir: Membangun "DevEnv" — Shell Environment Manager |

---

## Cara Menggunakan Fase 7

Setiap modul dalam Fase 7 berisi:

1. **Skenario Proyek** — Konteks nyata yang mensimulasikan dunia kerja
2. **Pertanyaan** — Tantangan yang harus dijawab/dikerjakan
3. **Jawaban** — Solusi lengkap dengan penjelasan *mengapa* dan *bagaimana*
4. **Refleksi Mental Programming** — Apa yang harus dipelajari dari proyek ini
5. **Verifikasi** — Checklist apakah Anda sudah benar-benar memahami

**Aturan main:**
- **Jangan melihat jawaban sebelum mencoba.** Tulis jawaban Anda sendiri dulu.
- **Gunakan terminal sungguhan.** Jangan hanya membaca — ketik, jalankan, amati.
- **Jika error, debug.** Error adalah guru terbaik.
- **Setiap modul harus diselesaikan sebelum melanjutkan.**

---

# MODUL 7.1: ONBOARDING DEVELOPER BARU — MEMBANGUN MENTAL MODEL

> **Mewakili:** Fase 1 — Fondasi Shell, Navigasi, Variabel, Quoting, Ekspansi
> **Level:** Pemula | **Durasi:** 4–6 jam | **Tipe:** Proyek Simulasi

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model shell sebagai "ruang kerja"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Perintah yang akan digunakan
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan nyata
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Anda adalah developer baru di "Nusantara Tech"**, sebuah startup fintech yang baru saja mendapat pendanaan Seri A. Hari ini adalah hari pertama Anda. Tim IT memberikan Anda laptop kosong dan berkata:

> *"Selamat datang! Tugas pertama Anda: kenali lingkungan kerja kami. Codebase ada di `/home/nusantara/projects/`, konfigurasi server ada di `/etc/nusantara/`, dan log ada di `/var/log/nusantara/`. Kami butuh Anda membuat laporan tentang struktur ini, dan menyiapkan environment kerja Anda sendiri. Gunakan terminal — tidak ada GUI di sini."*

Anda memiliki akses ke terminal Zsh. Tidak ada dokumentasi. Tidak ada senior yang bisa ditanya (mereka sedang di retreat). Anda harus:
1. Menavigasi struktur direktori
2. Memahami apa yang ada di dalamnya
3. Mendokumentasikan temuan
4. Menyiapkan environment kerja pribadi
5. Membuat laporan dalam format terstruktur

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **jembatan antara teori dan praktik**. Anda sudah mempelajari (di Fase 1) tentang `pwd`, `cd`, `ls`, variabel, quoting, dan ekspansi. Sekarang, Anda harus **menggunakan semuanya secara bersamaan** untuk menyelesaikan masalah nyata.

Di dunia kerja, tidak ada yang bertanya "apa itu `cd`?" — yang ada adalah "temukan file konfigurasi nginx, lalu buat backup-nya." Modul ini melatih Anda untuk **berpikir dalam konteks**, bukan dalam sintaks terisolasi.

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: Shell sebagai "ruang kerja fisik".**

Bayangkan shell sebagai ruang kerja fisik:
- **Direktori** = ruangan
- **Path** = alamat ruangan
- **File** = dokumen di dalam ruangan
- **Variabel** = label atau catatan tempel
- **Quoting** = cara Anda berbicara (hati-hati atau ceroboh)
- **Ekspansi** = apa yang terjadi ketika Anda menunjuk sesuatu

**Filosofi "You are here":** Shell selalu memiliki konsep "lokasi saat ini" (`$PWD`). Semua perintah navigasi (`cd`, `pwd`, `ls`) adalah tentang menjawab pertanyaan: *"Di mana saya sekarang? Apa yang ada di sekitar saya? Bagaimana cara ke sana?"*

**Filosofi "Variables are memory":** Variabel adalah cara shell "mengingat" sesuatu. Tanpa variabel, Anda harus mengetik ulang path panjang setiap kali. Dengan variabel, Anda memberi nama pada sesuatu dan menggunakannya kembali.

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.1 — Perintah yang akan digunakan
# ═══════════════════════════════════════════════════════════

# Navigasi
pwd                          # Di mana saya?
cd /path/to/dir              # Pindah
cd ~                         # Ke home
cd -                         # Kembali ke sebelumnya
ls -la                       # Lihat semua file (termasuk hidden)

# Informasi file
file namafile                # Tipe file
stat namafile                # Detail lengkap
wc -l namafile               # Hitung baris

# Variabel
PROJECT_DIR="/home/nusantara/projects"
echo "$PROJECT_DIR"          # Gunakan variabel
echo "${PROJECT_DIR}"        # Dengan braces (lebih aman)
echo "${#PROJECT_DIR}"       # Panjang string

# Quoting
echo 'literal $PROJECT_DIR'  # Single quote: literal
echo "expanded $PROJECT_DIR" # Double quote: ekspansi

# Command substitution
TANGGAL=$(date +%Y-%m-%d)
HOSTNAME=$(hostname)
USER_NAME=$(whoami)

# Array
DIRS=("projects" "configs" "logs")
echo "${DIRS[1]}"            # Zsh: index mulai dari 1
echo "${DIRS[@]}"            # Semua elemen
echo "${#DIRS[@]}"           # Jumlah elemen

# Pencarian
find /path -type f -name "*.conf"
which zsh
type cd
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **Working Directory** | Direktori tempat shell "berada" saat ini | `pwd` → `/home/nusantara` |
| **Absolute Path** | Path lengkap dari root (`/`) | `/home/nusantara/projects/app` |
| **Relative Path** | Path dari direktori saat ini | `projects/app` (jika di `/home/nusantara`) |
| **Home Directory** | Direktori pribadi pengguna | `~` atau `$HOME` |
| **Hidden File** | File yang diawali titik, tidak muncul di `ls` biasa | `.zshrc`, `.gitconfig` |
| **Variable** | Nama yang menyimpan nilai | `PROJECT_DIR="/home/..."` |
| **Expansion** | Proses shell mengganti variabel dengan nilainya | `$PROJECT_DIR` → `/home/nusantara/projects` |
| **Command Substitution** | Output perintah dijadikan nilai | `$(date +%Y)` → `2026` |
| **Array** | Kumpulan nilai berindeks | `DIRS=(a b c)` |
| **Glob** | Pola untuk mencocokkan nama file | `*.conf` |
| **Pipe** | Menghubungkan output ke input perintah lain | `ls \| wc -l` |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Orientasi Dasar

**Tantangan:** Anda baru login. Tulis perintah untuk menjawab: (a) Siapa saya? (b) Di mana saya? (c) Apa isi direktori home saya?

**Jawaban:**

```zsh
# (a) Siapa saya
whoami
# Output: nusantara

# Alternatif:
echo "$USER"
echo "$(whoami)"

# (b) Di mana saya
pwd
# Output: /home/nusantara

# (c) Apa isi home directory
ls -la
# Output akan menunjukkan file termasuk yang hidden (.zshrc, .bashrc, dll.)
```

**Penjelasan Mental:**
- `whoami` adalah perintah eksternal; `$USER` adalah environment variable — **keduanya valid**, tetapi `$USER` lebih cepat karena tidak perlu menjalankan program.
- `pwd` adalah **builtin** di Zsh (bukan program eksternal) — ia hanya membaca `$PWD`.
- `ls -la` adalah kombinasi flag: `-l` (long format), `-a` (all, termasuk hidden).

**Mengapa ini penting:** Di dunia nyata, Anda sering kali "tersesat" di direktori. Kebiasaan pertama yang baik: **selalu `pwd` sebelum melakukan operasi destruktif** (seperti `rm`).

---

### Pertanyaan 2: Menavigasi ke Lokasi Proyek

**Tantangan:** Tim IT memberi tahu Anda bahwa codebase ada di `/home/nusantara/projects/`. Navigasi ke sana. Kemudian, buat subdirektori baru bernama `sandbox` untuk eksperimen Anda. Kembali ke home, lalu kembali ke `sandbox` menggunakan `cd -`.

**Jawaban:**

```zsh
# 1. Navigasi ke projects
cd /home/nusantara/projects

# Verifikasi
pwd
# Output: /home/nusantara/projects

# 2. Buat direktori sandbox
mkdir sandbox

# 3. Masuk ke sandbox
cd sandbox
pwd
# Output: /home/nusantara/projects/sandbox

# 4. Kembali ke home
cd ~
pwd
# Output: /home/nusantara

# 5. Kembali ke sandbox dengan cd -
cd -
# Output: /home/nusantara/projects/sandbox
# (Zsh juga menampilkan: ~/projects/sandbox)
```

**Penjelasan Mental:**
- `cd -` adalah "tombol undo" untuk navigasi. Ini menyimpan direktori sebelumnya di `$OLDPWD`.
- Zsh secara otomatis menampilkan direktori baru setelah `cd -` (fitur ini bisa diatur dengan opsi `AUTO_CD` dan prompt).
- **Best practice:** Biasakan menggunakan `cd -` daripada mengetik ulang path panjang.

---

### Pertanyaan 3: Mendokumentasikan Struktur

**Tantangan:** Anda perlu membuat laporan tentang struktur `/home/nusantara/projects/`. Bagaimana cara melihat struktur direktori hingga 2 level ke dalam, lalu menyimpannya ke file `struktur.txt`?

**Jawaban:**

```zsh
# Menggunakan find untuk melihat struktur
find /home/nusantara/projects -maxdepth 2 -type d | sort > /home/nusantara/struktur.txt

# Lihat hasilnya
cat /home/nusantara/struktur.txt
```

**Alternatif menggunakan `tree` (jika terinstall):**

```zsh
tree -L 2 /home/nusantara/projects > /home/nusantara/struktur.txt
```

**Penjelasan Mental:**
- `find` adalah "pisau Swiss Army" untuk pencarian file. `-maxdepth 2` membatasi kedalaman, `-type d` hanya direktori.
- `| sort` mengurutkan output — penting untuk laporan yang mudah dibaca.
- `> file` adalah **redirection**: output yang seharusnya ke layar, dialihkan ke file.
- **Best practice:** Selalu simpan output pencarian ke file untuk **audit trail** — di dunia kerja, Anda tidak ingin mengulang perintah yang sama.

**Mengapa `>` dan bukan `>>`?** Karena ini laporan baru, kita ingin **overwrite** (mulai dari nol). Jika kita ingin menambahkan ke file yang sudah ada, gunakan `>>`.

---

### Pertanyaan 4: Variabel untuk Konfigurasi

**Tantangan:** Daripada mengetik `/home/nusantara/projects` berulang-ulang, buat variabel `PROJECTS_DIR` yang menyimpannya. Lalu, buat variabel `CONFIG_DIR` yang berisi `/etc/nusantara/`, dan `LOG_DIR` untuk `/var/log/nusantara/`. Tampilkan semua variabel ini dalam format yang mudah dibaca.

**Jawaban:**

```zsh
# Definisikan variabel
PROJECTS_DIR="/home/nusantara/projects"
CONFIG_DIR="/etc/nusantara"
LOG_DIR="/var/log/nusantara"

# Tampilkan dalam format rapi
echo "═══════════════════════════════════════"
echo "  KONFIGURASI LINGKUNGAN NUSANTARA TECH"
echo "═══════════════════════════════════════"
echo "  Projects : $PROJECTS_DIR"
echo "  Config   : $CONFIG_DIR"
echo "  Logs     : $LOG_DIR"
echo "═══════════════════════════════════════"
```

**Penjelasan Mental:**
- **Kapan pakai quotes?** `PROJECTS_DIR="/home/nusantara/projects"` — gunakan double quote meskipun tidak ada spasi, karena ini adalah **praktik defensif**. Jika di masa depan path berubah dan mengandung spasi, kode Anda tetap aman.
- **Kapan pakai `$VAR` vs `${VAR}`?** Gunakan `${VAR}` ketika variabel diikuti karakter yang bisa dianggap bagian dari nama variabel, misalnya `${PROJECTS_DIR}_backup`. Tanpa braces, shell akan mencari variabel `PROJECTS_DIR_backup`.
- **Mengapa tidak `export`?** Karena variabel ini hanya digunakan di shell saat ini. Jika Anda ingin variabel tersedia untuk subproses (misalnya script yang Anda panggil), gunakan `export`.

**Pertanyaan lanjutan:** Bagaimana jika `CONFIG_DIR` tidak ada? Tampilkan pesan error yang jelas.

```zsh
if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "⚠️  Warning: $CONFIG_DIR tidak ditemukan" >&2
else
    echo "✅ $CONFIG_DIR terdeteksi"
fi
```

---

### Pertanyaan 5: Eksplorasi Isi Direktori

**Tantangan:** Di dalam `/home/nusantara/projects/`, ada beberapa subdirektori. Anda perlu: (a) melihat semua file (termasuk hidden), (b) menghitung jumlah file `.conf` di seluruh proyek secara rekursif, (c) menampilkan 5 file terbaru berdasarkan waktu modifikasi.

**Jawaban:**

```zsh
# (a) Lihat semua file
ls -la /home/nusantara/projects/

# (b) Hitung file .conf secara rekursif
find /home/nusantara/projects -type f -name "*.conf" | wc -l

# (c) 5 file terbaru — menggunakan ZSH GLOB QUALIFIER!
ls -la /home/nusantara/projects/**/*(om[1,5])
```

**Penjelasan Mental — Mengapa Zsh Istimewa:**

Untuk (c), di Bash Anda harus menulis:
```bash
# Bash: rumit
find /home/nusantara/projects -type f -printf '%T@ %p\n' | sort -rn | head -5 | cut -d' ' -f2-
```

Di Zsh, cukup dengan **glob qualifier**:
- `**/*` = recursive glob (semua file di semua subdirektori)
- `(om[1,5])` = **o**rder by **m**odification time, ambil **[1,5]** (5 terbaru)

**Ini adalah alasan mengapa Zsh disebut "shell untuk manusia"** — apa yang membutuhkan 4 perintah di Bash, di Zsh cukup 1.

**Pertanyaan reflektif:** Apa yang terjadi jika direktori kosong? Bagaimana Anda menanganinya?

```zsh
# Solusi robust: gunakan null_glob
files=(/home/nusantara/projects/**/*.conf(Nom[1,5]))
if [[ ${#files[@]} -eq 0 ]]; then
    echo "Tidak ada file .conf ditemukan"
else
    ls -la "${files[@]}"
fi
```

- `(N)` = **null_glob**: jika tidak ada file cocok, kembalikan array kosong (tidak error).

---

### Pertanyaan 6: Membuat Laporan Terstruktur

**Tantangan:** Gabungkan semua temuan Anda menjadi satu laporan. Buat script yang menghasilkan file `laporan_onboarding.md` dengan format Markdown yang berisi: tanggal, hostname, user, struktur direktori, jumlah file, dan konfigurasi environment.

**Jawaban:**

```zsh
#!/bin/zsh
# laporan_onboarding.zsh — Generate laporan onboarding

# === Kumpulkan data ===
TANGGAL=$(date +%Y-%m-%d)
WAKTU=$(date +%H:%M:%S)
HOST=$(hostname)
USER_NAME=$(whoami)
PROJECTS_DIR="/home/nusantara/projects"
CONFIG_DIR="/etc/nusantara"
LOG_DIR="/var/log/nusantara"

# Hitung statistik
TOTAL_FILES=$(find "$PROJECTS_DIR" -type f 2>/dev/null | wc -l)
CONF_FILES=$(find "$PROJECTS_DIR" -type f -name "*.conf" 2>/dev/null | wc -l)

# === Tulis laporan ===
cat > /home/nusantara/laporan_onboarding.md <<EOF
# Laporan Onboarding Developer

**Tanggal:** $TANGGAL
**Waktu:** $WAKTU
**Hostname:** $HOST
**User:** $USER_NAME

## Ringkasan Environment

| Lokasi | Path |
|--------|------|
| Projects | $PROJECTS_DIR |
| Config | $CONFIG_DIR |
| Logs | $LOG_DIR |

## Statistik

- Total file di projects: **$TOTAL_FILES**
- File konfigurasi (.conf): **$CONF_FILES**

## Struktur Direktori (2 level)

\`\`\`
$(find "$PROJECTS_DIR" -maxdepth 2 -type d 2>/dev/null | sort)
\`\`\`

## Catatan

Laporan ini di-generate otomatis oleh laporan_onboarding.zsh.
EOF

echo "✅ Laporan tersimpan di /home/nusantara/laporan_onboarding.md"
```

**Penjelasan Mental — Heredoc (`<<EOF`):**

- `cat > file <<EOF ... EOF` adalah **heredoc**: cara menulis blok teks multi-baris ke file.
- Semua yang ada di antara `EOF` dan `EOF` kedua akan dikirim ke stdin `cat`.
- **Variable expansion tetap terjadi** di dalam heredoc (karena tidak di-quote). Jika Anda ingin literal (tanpa ekspansi), gunakan `<<'EOF'`.
- `2>/dev/null` — redirect error ke "tempat sampah" (`/dev/null`). Berguna jika direktori mungkin tidak ada.

**Pertanyaan reflektif:** Apa yang terjadi jika `/home/nusantara/` tidak writable? Bagaimana Anda menangani?

```zsh
if [[ ! -w /home/nusantara ]]; then
    echo "❌ Tidak bisa menulis ke /home/nusantara" >&2
    exit 1
fi
```

---

### Pertanyaan 7: Quoting — Studi Kasus

**Tantangan:** Tim memberi Anda file dengan nama yang mengandung spasi: `"Laporan Q4 2026.pdf"`. Buat script yang: (a) memindahkan file ke folder `arsip/`, (b) membuat backup dengan nama `Laporan Q4 2026.pdf.bak`.

**Jawaban:**

```zsh
# ❌ SALAH — akan gagal karena spasi
# mv Laporan Q4 2026.pdf arsip/

# ✅ BENAR — quoting
mkdir -p arsip
mv "Laporan Q4 2026.pdf" arsip/
cp "arsip/Laporan Q4 2026.pdf" "arsip/Laporan Q4 2026.pdf.bak"

# ✅ ALTERNATIF — gunakan variabel
FILE="Laporan Q4 2026.pdf"
mkdir -p arsip
mv "$FILE" arsip/
cp "arsip/$FILE" "arsip/${FILE}.bak"
```

**Penjelasan Mental — Aturan Quoting Emas:**

| Situasi | Gunakan |
|---|---|
| Path/file dengan spasi | **Selalu** double quote: `"$FILE"` |
| Variabel | **Selalu** double quote: `"$VAR"` |
| String literal tanpa ekspansi | Single quote: `'literal'` |
| Pattern/glob yang ingin diekspansi | Tanpa quote: `*.txt` |
| Pattern literal | Single quote: `'*.txt'` |

**Aturan praktis:** *"Jika ragu, quote."* — Quote berlebih tidak berbahaya; kurang quote berbahaya.

**Kesalahan umum:** `mv $FILE arsip/` — jika `$FILE` mengandung spasi, shell akan menganggapnya sebagai dua argumen. **Selalu** gunakan `"$FILE"`.

---

### Pertanyaan 8: Array untuk Daftar Direktori

**Tantangan:** Buat array Zsh yang berisi semua direktori penting: `projects`, `configs`, `logs`, `backups`. Loop melalui array dan tampilkan: (a) apakah direktori ada, (b) jumlah file di dalamnya.

**Jawaban:**

```zsh
#!/bin/zsh

# Definisikan array (Zsh: index mulai dari 1)
typeset -a DIRS
DIRS=(
    "/home/nusantara/projects"
    "/etc/nusantara"
    "/var/log/nusantara"
    "/home/nusantara/backups"
)

# Loop melalui array
for dir in "${DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        count=$(find "$dir" -type f 2>/dev/null | wc -l)
        echo "✅ $dir — $count file"
    else
        echo "❌ $dir — TIDAK ADA"
    fi
done
```

**Penjelasan Mental — Array Zsh vs Bash:**

| Aspek | Bash | Zsh |
|---|---|---|
| Index mulai | 0 | **1** |
| Semua elemen | `${arr[@]}` | `${arr[@]}` |
| Elemen pertama | `${arr[0]}` | `${arr[1]}` |
| Jumlah elemen | `${#arr[@]}` | `${#arr[@]}` |
| Deklarasi | `arr=(a b c)` | `arr=(a b c)` |

**Mengapa Zsh 1-indexed?** Karena **manusia menghitung dari 1**. Ini adalah bagian dari filosofi "shell untuk manusia".

**Penting:** `"${DIRS[@]}"` dengan double quote memastikan setiap elemen diperlakukan sebagai satu argumen, bahkan jika mengandung spasi. Ini adalah **praktik terbaik**.

**Pertanyaan reflektif:** Apa perbedaan `"${DIRS[@]}"` dan `"${DIRS[*]}"`?

- `"${DIRS[@]}"` → setiap elemen adalah argumen terpisah
- `"${DIRS[*]}"` → semua elemen digabung menjadi satu string (dipisahkan spasi pertama IFS)

Untuk loop, **selalu gunakan `[@]`**.

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Peta Direktori Nusantara Tech** — Buat diagram pohon yang menunjukkan struktur `/home/nusantara/`, `/etc/nusantara/`, dan `/var/log/nusantara/`. Tandai direktori mana yang "baca saja" vs "bisa ditulis".
>
> 2. **Alur Navigasi** — Diagram yang menunjukkan perjalanan Anda: `~` → `projects/` → `sandbox/` → `~` → `sandbox/` (via `cd -`). Gunakan panah berwarna berbeda untuk `cd` vs `cd -`.
>
> 3. **Peta Ekspansi Shell** — Diagram yang menunjukkan bagaimana `"$PROJECTS_DIR/file.txt"` di-ekspansi: `$PROJECTS_DIR` → `/home/nusantara/projects`, lalu digabung dengan `/file.txt`.
>
> 4. **Tabel Quoting** — Tabel visual dengan tiga kolom: Single Quote, Double Quote, No Quote — dan contoh output untuk setiap kasus.

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.2 (Scripting Dasar)** | Variabel dan quoting dari modul ini akan menjadi fondasi untuk fungsi dan kontrol alur |
| **7.3 (Globbing & Konfigurasi)** | Array dan glob qualifier yang diperkenalkan di sini akan diperdalam |
| **7.4 (Performa & Keamanan)** | Praktik quoting yang benar adalah langkah pertama menuju scripting yang aman |
| **Fase 1 (Kurikulum)** | Modul ini adalah aplikasi langsung dari semua materi Fase 1 |

---

## 9. Sumber Referensi Lengkap

- **Zsh Manual: Expansion** — https://zsh.sourceforge.io/Doc/Release/Expansion.html
- **Zsh Manual: Parameters** — https://zsh.sourceforge.io/Doc/Release/Parameters.html
- **Zsh Manual: Options** — https://zsh.sourceforge.io/Doc/Release/Options.html
- **Zsh FAQ: Array Indexing** — https://zsh.sourceforge.io/FAQ/zshfaq02.html
- **Linux Command Line Navigation** — https://linuxcommand.org/lc3_lts0020.php
- **Bash vs Zsh: Quoting Differences** — https://www.baeldung.com/linux/bash-zsh-quoting
- **Google Shell Style Guide** — https://google.github.io/styleguide/shellguide.html

---

## 10. Tips dan Praktik Terbaik

1. **Selalu `pwd` sebelum operasi destruktif.** Kebiasaan ini menyelamatkan Anda dari `rm -rf` di direktori yang salah.
2. **Quote semuanya.** `"$VAR"`, `"$FILE"`, `"${ARRAY[@]}"`. Quote berlebih tidak berbahaya.
3. **Gunakan `${VAR}` bukan `$VAR`** ketika diikuti karakter alfanumerik.
4. **Simpan path panjang dalam variabel.** Lebih mudah dibaca dan diubah.
5. **Gunakan `cd -` untuk kembali.** Menghemat waktu dan mengurangi kesalahan ketik.
6. **Gunakan `>>` untuk log, `>` untuk laporan baru.** Jangan sampai tidak sengaja menimpa data.
7. **Test di `sandbox` dulu.** Jangan pernah eksperimen di direktori produksi.
8. **Dokumentasikan temuan Anda.** Laporan tertulis adalah bukti kerja dan referensi di masa depan.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `cd projects` tanpa `/` | Pindah ke direktori relatif, bukan absolut | Gunakan `cd /home/nusantara/projects` atau `cd ~/projects` |
| `mv $FILE` tanpa quote | Error "No such file" jika ada spasi | Selalu `"$FILE"` |
| `echo $VAR` untuk variabel dengan spasi | Output terpotong | `echo "$VAR"` |
| `arr[0]` di Zsh | Kosong (karena 1-indexed) | Gunakan `arr[1]` |
| Lupa `mkdir -p` | Error jika parent tidak ada | `mkdir -p a/b/c` |
| `>` menimpa file penting | Data hilang | Gunakan `>>` atau backup dulu |
| `find` tanpa `2>/dev/null` | Error permission memenuhi layar | `find ... 2>/dev/null` |
| `for f in $(ls)` | Gagal jika ada spasi di nama file | `for f in *` atau `for f in "${arr[@]}"` |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.1, Anda seharusnya mulai merasakan **pola pikir shell**:

1. **Shell adalah ruang kerja, bukan sekadar alat.** Anda tidak "menjalankan perintah" — Anda "berpindah, mengamati, dan mengubah" lingkungan.
2. **Variabel adalah memori jangka pendek.** Mereka menyimpan konteks yang Anda butuhkan berulang kali.
3. **Quoting adalah sabuk pengaman.** Ia melindungi Anda dari karakter khusus yang bisa merusak perintah.
4. **Ekspansi adalah sihir.** Shell mengganti `$VAR`, `$(command)`, dan `*.txt` dengan nilai sebenarnya sebelum mengeksekusi.
5. **Array adalah daftar.** Mereka memungkinkan Anda memproses banyak item dengan loop.
6. **Semua perintah adalah program kecil.** Mereka bisa digabungkan dengan `|`, diarahkan dengan `>`, dan dijalankan dalam loop.

**Pertanyaan reflektif untuk diri sendiri:**
- Apakah saya bisa menjelaskan perbedaan `$VAR`, `"$VAR"`, dan `'$VAR'` tanpa melihat catatan?
- Apakah saya tahu kapan harus menggunakan `cd -` vs `cd ~`?
- Apakah saya bisa menulis loop yang aman untuk array dengan spasi?

Jika jawabannya "belum", **ulangi modul ini** sebelum melanjutkan. Fondasi yang kuat akan membuat modul berikutnya jauh lebih mudah.

### Checklist Verifikasi

Sebelum melanjutkan ke Modul 7.2, pastikan Anda dapat:

- [ ] Menavigasi sistem file dengan `pwd`, `cd`, `ls`, dan `cd -`
- [ ] Membuat, memindahkan, dan menghapus file dengan aman (dengan quote)
- [ ] Mendefinisikan dan menggunakan variabel untuk menyimpan path
- [ ] Menjelaskan perbedaan single quote, double quote, dan no quote
- [ ] Menggunakan command substitution `$(...)`
- [ ] Membuat dan mengiterasi array Zsh (1-indexed)
- [ ] Menggunakan glob qualifier dasar seperti `**/*.conf`
- [ ] Menulis heredoc untuk menghasilkan laporan multi-baris
- [ ] Mengarahkan output ke file dengan `>` dan `>>`
- [ ] Menangani file dengan spasi menggunakan quoting yang benar

---

## ✅ MODUL 7.1 SELESAI

**Ringkasan yang telah Anda kuasai:**
- Orientasi dan navigasi sistem file
- Variabel dan quoting untuk path yang aman
- Command substitution untuk data dinamis
- Array Zsh 1-indexed
- Glob qualifier dasar (`**/`, `(N)`, `(om)`)
- Heredoc untuk laporan terstruktur
- Redirection untuk menyimpan output

**Yang akan datang di Modul 7.2:**
Anda akan membangun **sistem backup dan log rotation otomatis** — menggunakan fungsi, kontrol alur, error handling, dan I/O redirection. Ini adalah langkah pertama dari "pengguna shell" menjadi "programmer shell".

---

# MODUL 7.2: OTOMATISASI BACKUP & LOG ROTATION — DARI PERINTAH KE PROGRAM

> **Mewakili:** Fase 2 — Struktur Script, Kontrol Alur, Fungsi, I/O, Redirection, Error Handling, Debugging
> **Level:** Pemula–Menengah | **Durasi:** 6–8 jam | **Tipe:** Proyek Simulasi

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model "script sebagai kontrak"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Toolkit scripting
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan nyata
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Enam bulan berlalu sejak Anda bergabung di Nusantara Tech.** Kini Anda adalah developer yang dipercaya. Suatu pagi, CTO memanggil Anda:

> *"Kami punya masalah. Setiap hari, server kami menghasilkan log hingga 2GB. Disk hampir penuh. Kami juga belum punya backup otomatis untuk konfigurasi dan database. Saya butuh Anda membangun sistem yang:*
> - *Menjalankan backup setiap hari pada jam 2 pagi*
> - *Memutar (rotate) log yang lebih tua dari 7 hari*
> - *Mengompres backup lama untuk menghemat disk*
> - *Mengirim notifikasi jika ada yang gagal*
> - *Mencatat semua aktivitas ke file log tersendiri*
>
> *Gunakan Zsh. Jangan install tools tambahan. Saya butuh solusi yang bisa jalan di server mana pun."*

Anda memiliki:
- Server Linux dengan Zsh
- Direktori `/var/log/nusantara/` berisi file log aplikasi
- Direktori `/etc/nusantara/` berisi file konfigurasi
- Direktori `/home/nusantara/backups/` (kosong, untuk backup)
- Akses ke `cron` untuk penjadwalan

**Tantangan:** Bangun sistem backup & log rotation yang **robust, idempoten, dan bisa di-debug**.

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **titik balik** dari "pengguna shell" menjadi "programmer shell". Di Modul 7.1, Anda menjalankan perintah satu per satu. Sekarang, Anda akan menulis **program** — file yang bisa dijalankan berulang kali, dengan logika, penanganan error, dan output yang terstruktur.

Di dunia kerja, **80% pekerjaan sysadmin dan DevOps adalah scripting**. Backup, deployment, monitoring, cleanup — semuanya adalah script yang berjalan otomatis. Kemampuan menulis script yang **tidak akan merusak sistem saat error** adalah pembeda antara profesional dan amatir.

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: Script sebagai "kontrak".**

Sebuah script adalah **kontrak antara Anda dan sistem**:
- **Input:** Apa yang script butuhkan (argumen, file, environment)
- **Proses:** Apa yang script lakukan (dengan logika dan kontrol alur)
- **Output:** Apa yang script hasilkan (file, log, exit code)
- **Jaminan:** Apa yang script pastikan (idempoten, aman, bisa di-debug)

**Filosofi "Fail Fast, Fail Loud":**

Script yang baik **tidak diam-diam gagal**. Jika backup gagal, script harus:
1. **Berhenti segera** (`set -e`) — jangan lanjutkan ke langkah berikutnya
2. **Memberi tahu** (log ke stderr, kirim notifikasi)
3. **Membersihkan** (hapus file temporary dengan `trap`)
4. **Mengembalikan exit code** yang jelas

Script yang buruk akan "melanjutkan" meskipun backup gagal, lalu menghapus backup lama — dan Anda kehilangan data tanpa tahu.

**Filosofi "Idempotent by Design":**

Script backup harus bisa dijalankan **berkali-kali** tanpa efek samping:
- Jika backup hari ini sudah ada, jangan buat lagi
- Jika log sudah dirotasi, jangan rotasi lagi
- Jika direktori tujuan belum ada, buat dulu

Ini dicapai dengan **pengecekan kondisi** sebelum aksi.

**Filosofi "Observable Systems":**

Setiap script harus **bisa diobservasi** — Anda harus bisa tahu apa yang terjadi tanpa harus menjalankannya lagi. Ini dicapai dengan:
- **Logging terstruktur** (timestamp, level, pesan)
- **Exit code** yang bermakna
- **Debug mode** yang bisa diaktifkan

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.2 — Elemen Script Profesional
# ═══════════════════════════════════════════════════════════

#!/bin/zsh
# ─── 1. SHEBANG ───
# Memberi tahu sistem: jalankan dengan Zsh

# ─── 2. STRICT MODE ───
set -euo pipefail
# -e: exit jika ada perintah gagal
# -u: exit jika ada variabel undefined
# -o pipefail: exit jika ada perintah dalam pipe gagal

# ─── 3. KONSTANTA ───
readonly SCRIPT_NAME="${0:t}"     # ${0:t} = tail (nama file saja)
readonly SCRIPT_DIR="${0:A:h}"    # ${0:A:h} = absolute path dirname
readonly LOG_FILE="/var/log/nusantara/backup.log"

# ─── 4. FUNGSI LOGGING ───
log() {
    local level="$1"; shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@" >&2; }
log_error() { log "ERROR" "$@" >&2; }

# ─── 5. TRAP UNTUK CLEANUP ───
cleanup() {
    local exit_code=$?
    if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
    if [[ $exit_code -ne 0 ]]; then
        log_error "Script gagal dengan exit code: $exit_code"
    fi
    exit $exit_code
}
trap cleanup EXIT

# ─── 6. VALIDASI INPUT ───
if [[ $# -lt 1 ]]; then
    log_error "Usage: $SCRIPT_NAME <command> [args]"
    exit 1
fi

# ─── 7. FUNGSI UTAMA ───
do_backup() {
    local source_dir="$1"
    local dest_dir="$2"
    
    # Validasi
    if [[ ! -d "$source_dir" ]]; then
        log_error "Source tidak ditemukan: $source_dir"
        return 1
    fi
    
    # Buat direktori tujuan jika belum ada
    mkdir -p "$dest_dir"
    
    # Nama file backup dengan timestamp
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_name="backup_${timestamp}.tar.gz"
    
    # Buat backup
    log_info "Membuat backup: $backup_name"
    if tar -czf "${dest_dir}/${backup_name}" -C "$source_dir" .; then
        log_info "✅ Backup berhasil: ${dest_dir}/${backup_name}"
    else
        log_error "❌ Backup gagal"
        return 1
    fi
}

# ─── 8. DISPATCH COMMAND ───
case "${1:-}" in
    backup)  do_backup "${2:-}" "${3:-}" ;;
    rotate)  do_rotate ;;
    *)       log_error "Command tidak dikenal: $1"; exit 1 ;;
esac
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **Shebang** | Baris pertama script: `#!/bin/zsh` | Menentukan interpreter |
| **Strict Mode** | `set -euo pipefail` — fail on error | Wajib untuk script produksi |
| **Exit Code** | Angka 0–255 yang dikembalikan script | 0 = sukses, non-zero = error |
| **`trap`** | Handler untuk signal/event | `trap cleanup EXIT` |
| **`readonly`** | Variabel yang tidak bisa diubah | `readonly LOG_FILE=...` |
| **`local`** | Variabel yang hanya berlaku di fungsi | `local timestamp=...` |
| **`return`** | Mengembalikan exit code dari fungsi | `return 1` |
| **`${0:t}`** | Tail — nama file tanpa path | `script.zsh` |
| **`${0:A:h}`** | Absolute path dirname | `/home/user/bin` |
| **`$*`** | Semua argumen sebagai satu string | `"$@"` lebih aman |
| **`$@`** | Semua argumen sebagai array | `"$@"` untuk preserve spasi |
| **`$?`** | Exit code perintah terakhir | `if [[ $? -eq 0 ]]` |
| **`$#`** | Jumlah argumen | `if [[ $# -lt 1 ]]` |
| **Heredoc** | Blok teks multi-baris ke stdin | `cat <<EOF` |
| **Pipefail** | Opsi: pipe gagal jika salah satu komponen gagal | `set -o pipefail` |
| **Idempoten** | Aman dijalankan berkali-kali | Backup cek dulu sebelum buat |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Struktur Script Backup

**Tantangan:** Tulis script `backup.zsh` yang: (a) memiliki shebang, (b) menggunakan strict mode, (c) mendefinisikan `SCRIPT_NAME` dan `SCRIPT_DIR`, (d) memiliki fungsi `log()` yang menulis ke file dan layar sekaligus.

**Jawaban:**

```zsh
#!/bin/zsh
# backup.zsh — Script backup dasar

# ═══════════════════════════════════════════════════════════
# STRICT MODE — Wajib untuk script produksi
# ═══════════════════════════════════════════════════════════
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# KONSTANTA — readonly untuk mencegah perubahan tak sengaja
# ═══════════════════════════════════════════════════════════
readonly SCRIPT_NAME="${0:t}"
readonly SCRIPT_DIR="${0:A:h}"
readonly LOG_FILE="${LOG_FILE:-/var/log/nusantara/backup.log}"
readonly BACKUP_DIR="${BACKUP_DIR:-/home/nusantara/backups}"

# ═══════════════════════════════════════════════════════════
# FUNGSI LOGGING — terstruktur dengan timestamp dan level
# ═══════════════════════════════════════════════════════════
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    printf '[%s] [%s] %s\n' "$timestamp" "$level" "$message" | tee -a "$LOG_FILE"
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }

# ═══════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════
log_info "Script dimulai: $SCRIPT_NAME"
log_info "Script directory: $SCRIPT_DIR"
log_info "Log file: $LOG_FILE"
```

**Penjelasan Mental — Mengapa Konstruksi Ini:**

**`set -euo pipefail`** — Tiga opsi dalam satu baris:
- `-e`: Script berhenti jika ada perintah yang mengembalikan exit code non-zero
- `-u`: Script berhenti jika menggunakan variabel yang belum didefinisikan
- `-o pipefail`: Pipe (`|`) dianggap gagal jika **salah satu** perintah di dalamnya gagal

**Mengapa ini penting?** Tanpa `pipefail`, perintah ini akan "sukses" meskipun bagian pertama gagal:
```zsh
# ❌ TANPA pipefail: command gagal tapi pipe tetap "sukses"
gagal_command | tee output.log

# ✅ DENGAN pipefail: pipe gagal jika gagal_command gagal
set -o pipefail
gagal_command | tee output.log
```

**`${0:t}` dan `${0:A:h}`** — Zsh parameter expansion modifiers:
- `${0}` = path script
- `${0:t}` = **t**ail (nama file saja): `backup.zsh`
- `${0:A}` = **A**bsolute path
- `${0:A:h}` = **h**ead (dirname): `/home/nusantara/bin`

**`"$@"` vs `"$*"`** — Perbedaan krusial:
- `"$@"` = array argumen, setiap argumen terpisah (AMAN untuk spasi)
- `"$*"` = semua argumen digabung dengan IFS pertama (BERBAHAYA untuk spasi)

Selalu gunakan `"$@"` untuk meneruskan argumen.

**`tee -a`** — `tee` menulis ke stdout **dan** ke file. `-a` = append (tambahkan, jangan timpa). Ini memungkinkan output terlihat di terminal **dan** tersimpan di log.

---

### Pertanyaan 2: Kontrol Alur — Validasi Argumen

**Tantangan:** Script Anda menerima argumen: `backup <source> <dest>`. Validasi bahwa: (a) ada 2 argumen, (b) `source` ada dan merupakan direktori, (c) `dest` bisa ditulis. Jika validasi gagal, tampilkan pesan error dan exit dengan kode yang sesuai.

**Jawaban:**

```zsh
#!/bin/zsh
set -euo pipefail

# Fungsi usage
usage() {
    cat <<EOF
Usage: $SCRIPT_NAME <source_dir> <dest_dir>

Arguments:
    source_dir  Direktori yang akan di-backup (harus ada)
    dest_dir    Direktori tujuan backup (akan dibuat jika belum ada)

Examples:
    $SCRIPT_NAME /etc/nusantara /home/nusantara/backups
    $SCRIPT_NAME /var/log/nusantara /home/nusantara/backups
EOF
    exit 1
}

# Validasi jumlah argumen
if [[ $# -ne 2 ]]; then
    echo "Error: butuh tepat 2 argumen, diberikan $#" >&2
    usage
fi

# Baca argumen ke variabel dengan nama bermakna
local source_dir="$1"
local dest_dir="$2"

# Validasi source
if [[ ! -e "$source_dir" ]]; then
    echo "Error: source tidak ditemukan: $source_dir" >&2
    exit 2
fi

if [[ ! -d "$source_dir" ]]; then
    echo "Error: source bukan direktori: $source_dir" >&2
    exit 2
fi

if [[ ! -r "$source_dir" ]]; then
    echo "Error: source tidak bisa dibaca: $source_dir" >&2
    exit 2
fi

# Validasi dest — buat jika belum ada
if [[ ! -d "$dest_dir" ]]; then
    mkdir -p "$dest_dir" || {
        echo "Error: tidak bisa membuat dest_dir: $dest_dir" >&2
        exit 3
    }
fi

if [[ ! -w "$dest_dir" ]]; then
    echo "Error: dest_dir tidak bisa ditulis: $dest_dir" >&2
    exit 3
fi

echo "✅ Validasi berhasil"
echo "   Source: $source_dir"
echo "   Dest:   $dest_dir"
```

**Penjelasan Mental — Exit Code yang Bermakna:**

Di dunia Unix, exit code **memiliki makna**:
- `0` = sukses
- `1` = error umum
- `2` = error input pengguna (argumen salah)
- `3` = error file system (file tidak ada, permission)
- `4` = error network
- `126` = command tidak bisa dieksekusi
- `127` = command tidak ditemukan
- `128+N` = signal N (misalnya 130 = Ctrl+C)

**Mengapa exit code berbeda?** Agar caller (script lain yang memanggil script Anda) bisa **membedakan jenis kegagalan**:
```zsh
# Caller bisa membedakan:
./backup.zsh /src /dst
case $? in
    0) echo "Sukses" ;;
    2) echo "Argumen salah" ;;
    3) echo "I/O error" ;;
    *) echo "Error tidak dikenal" ;;
esac
```

**Test Operator Zsh yang Digunakan:**

| Operator | Arti |
|---|---|
| `-e file` | File **e**xists |
| `-d file` | **D**irectory |
| `-f file` | **F**ile biasa |
| `-r file` | **R**eadable |
| `-w file` | **W**ritable |
| `-x file` | E**x**ecutable |
| `-s file` | **S**ize > 0 |
| `-L file` | Sym**L**ink |
| `!` | Negasi (NOT) |

---

### Pertanyaan 3: Loop dan Backup File Individual

**Tantangan:** Tulis fungsi `backup_files()` yang menerima direktori dan mem-backup setiap file `.conf` di dalamnya secara individual (bukan tarball). Setiap file backup harus memiliki suffix timestamp.

**Jawaban:**

```zsh
#!/bin/zsh
set -euo pipefail

backup_files() {
    local source_dir="$1"
    local dest_dir="$2"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local count=0
    local errors=0
    
    # Buat dest_dir jika belum ada
    mkdir -p "$dest_dir"
    
    # Loop setiap file .conf
    # Gunakan glob qualifier: *.conf(N) untuk null_glob
    for file in "$source_dir"/*.conf(N); do
        local basename="${file:t}"
        local backup_file="${dest_dir}/${basename}.${timestamp}.bak"
        
        if cp "$file" "$backup_file"; then
            echo "✅ $basename → $backup_file"
            (( count++ ))
        else
            echo "❌ Gagal backup: $basename" >&2
            (( errors++ ))
        fi
    done
    
    echo "─────────────────────────────"
    echo "Total: $count berhasil, $errors gagal"
    
    # Return non-zero jika ada error
    [[ $errors -eq 0 ]]
}
```

**Penjelasan Mental — Loop yang Aman:**

**Mengapa `*.conf(N)` bukan `*.conf`?**

Tanpa `(N)`, jika tidak ada file `.conf`, glob akan **gagal** dan dengan `set -e`, script akan berhenti:
```zsh
# ❌ Tanpa (N): script error jika tidak ada .conf
set -e
for file in *.conf; do
    # Jika tidak ada *.conf, `file` akan berisi literal "*.conf"
    # dan `cp` akan gagal → script exit
done
```

Dengan `(N)` (**null_glob**), array akan kosong dan loop tidak jalan:
```zsh
# ✅ Dengan (N): aman meskipun tidak ada file
for file in *.conf(N); do
    # Tidak dieksekusi jika tidak ada file
done
```

**Mengapa `(( count++ ))` di dalam loop?**

- Ini adalah **arithmetic expansion** Zsh
- `(( ))` adalah "arithmetic context" — semua di dalamnya dianggap operasi matematika
- `count++` = post-increment (kembalikan nilai lama, lalu tambah 1)
- **Penting:** Jika `count` bernilai 0, `(( count++ ))` akan mengembalikan **exit code 1** (karena nilai sebelum increment adalah 0). Dengan `set -e`, ini akan **menghentikan script**!

**Solusi:** Gunakan `(( count++ )) || true` atau `(( ++count ))`:
```zsh
# ❌ Bahaya dengan set -e:
(( count++ ))  # Jika count=0, ini return exit code 1 → script exit!

# ✅ Aman:
(( ++count ))   # Pre-increment: nilai baru = 1, return exit code 0
# atau
(( count++ )) || true
```

Ini adalah **jebakan klasik** yang sering menimpa pemula.

**Mengapa `[[ $errors -eq 0 ]]` sebagai return?**

- Ini adalah ekspresi boolean
- Jika `$errors -eq 0`, ekspresi mengembalikan exit code 0 (sukses)
- Jika tidak, mengembalikan exit code 1 (gagal)
- Fungsi `backup_files` akan mengembalikan exit code ini ke caller

---

### Pertanyaan 4: Log Rotation — Logika Rotasi

**Tantangan:** Tulis fungsi `rotate_logs()` yang: (a) menerima direktori log, (b) memutar file log yang lebih tua dari 7 hari, (c) mengompres file yang lebih tua dari 30 hari, (d) menghapus file yang lebih tua dari 90 hari.

**Jawaban:**

```zsh
#!/bin/zsh
set -euo pipefail

rotate_logs() {
    local log_dir="$1"
    local days_rotate="${2:-7}"
    local days_compress="${3:-30}"
    local days_delete="${4:-90}"
    
    if [[ ! -d "$log_dir" ]]; then
        echo "Error: direktori log tidak ditemukan: $log_dir" >&2
        return 1
    fi
    
    local rotated=0
    local compressed=0
    local deleted=0
    
    # ─── 1. ROTATE: log > 7 hari → ubah nama dengan suffix tanggal ───
    # Gunakan glob qualifier untuk filter berdasarkan waktu modifikasi
    # (m+7) = modified more than 7 days ago
    for log in "$log_dir"/*.log(m+${days_rotate}); do
        # Skip jika file tidak ada (null_glob mungkin menghasilkan kosong)
        [[ -f "$log" ]] || continue
        
        local date_suffix=$(date -r "$log" '+%Y%m%d' 2>/dev/null || stat -c '%y' "$log" | cut -d' ' -f1)
        local rotated_name="${log}.${date_suffix}"
        
        if mv "$log" "$rotated_name"; then
            echo "🔄 Rotated: ${log:t} → ${rotated_name:t}"
            (( ++rotated ))
        fi
    done
    
    # ─── 2. COMPRESS: log > 30 hari → gzip ───
    for log in "$log_dir"/*.log.*(m+${days_compress}); do
        [[ -f "$log" ]] || continue
        [[ "$log" == *.gz ]] && continue  # Skip jika sudah terkompres
        
        if gzip "$log"; then
            echo "📦 Compressed: ${log:t}"
            (( ++compressed ))
        fi
    done
    
    # ─── 3. DELETE: log > 90 hari → hapus ───
    for log in "$log_dir"/*.log.*.gz(m+${days_delete}); do
        [[ -f "$log" ]] || continue
        
        if rm "$log"; then
            echo "🗑️  Deleted: ${log:t}"
            (( ++deleted ))
        fi
    done
    
    echo "─────────────────────────────"
    echo "Rotated: $rotated | Compressed: $compressed | Deleted: $deleted"
}
```

**Penjelasan Mental — Glob Qualifier `(m+N)`:**

Ini adalah fitur **khas Zsh** yang sangat powerful:

| Qualifier | Arti |
|---|---|
| `(m+7)` | **m**odified lebih dari 7 hari lalu |
| `(m-7)` | **m**odified dalam 7 hari terakhir |
| `(m7)` | Modified tepat 7 hari lalu |
| `(mh+2)` | Modified lebih dari 2 **jam** lalu |
| `(mm+30)` | Modified lebih dari 30 **menit** lalu |
| `(mw+1)` | Modified lebih dari 1 **minggu** lalu |

**Tanpa Zsh glob qualifier**, Anda harus menulis:
```bash
# Bash: sangat panjang dan error-prone
find "$log_dir" -name "*.log" -type f -mtime +7 -exec mv {} {}.$(date +%Y%m%d) \;
```

Dengan Zsh:
```zsh
# Zsh: satu baris, jelas
for log in "$log_dir"/*.log(m+7); do
    mv "$log" "${log}.$(date +%Y%m%d)"
done
```

**`date -r` vs `stat -c`:**

- **BSD/macOS:** `date -r file +format` untuk membaca waktu modifikasi file
- **Linux:** `stat -c '%y' file` untuk format waktu
- Solusi portabel: coba `date -r`, fallback ke `stat`:
```zsh
local date_suffix
if date_suffix=$(date -r "$log" '+%Y%m%d' 2>/dev/null); then
    : # berhasil dengan date -r (BSD/macOS)
else
    date_suffix=$(stat -c '%y' "$log" | cut -d' ' -f1 | tr -d '-')
fi
```

**Jebakan:** Urutan rotasi **sangat penting**:
1. **Rotate dulu** — ubah nama file log lama
2. **Compress** — kompres file yang sudah di-rotate (bukan file aktif)
3. **Delete** — hapus yang paling tua

Jika Anda compress dulu lalu rotate, file aktif juga akan terkompres — tidak diinginkan.

---

### Pertanyaan 5: Error Handling dengan Trap

**Tantangan:** Tambahkan `trap` ke script backup yang: (a) membersihkan file temporary, (b) mencatat pesan error ke log jika script gagal, (c) mengirim exit code yang benar.

**Jawaban:**

```zsh
#!/bin/zsh
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# VARIABEL GLOBAL untuk cleanup
# ═══════════════════════════════════════════════════════════
TEMP_DIR=""

# ═══════════════════════════════════════════════════════════
# FUNGSI CLEANUP — dipanggil saat script exit
# ═══════════════════════════════════════════════════════════
cleanup() {
    # Simpan exit code PERTAMA — penting!
    local exit_code=$?
    
    # Bersihkan temporary directory
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        echo "🧹 Membersihkan temporary: $TEMP_DIR"
        rm -rf "$TEMP_DIR"
    fi
    
    # Log jika script gagal
    if [[ $exit_code -ne 0 ]]; then
        echo "❌ Script gagal dengan exit code: $exit_code" >&2
        # Opsional: kirim notifikasi
        # notify_admin "Backup failed with exit $exit_code"
    else
        echo "✅ Script selesai dengan sukses"
    fi
    
    exit $exit_code
}

# ═══════════════════════════════════════════════════════════
# DAFTARKAN TRAP
# ═══════════════════════════════════════════════════════════
# EXIT = dipanggil setiap kali script exit (sukses atau gagal)
trap cleanup EXIT

# Opsional: tangkap signal
trap 'echo "⚠️ Diterima SIGINT"; exit 130' INT
trap 'echo "⚠️ Diterima SIGTERM"; exit 143' TERM

# ═══════════════════════════════════════════════════════════
# SCRIPT UTAMA
# ═══════════════════════════════════════════════════════════
echo "🚀 Memulai backup..."

# Buat temporary directory
TEMP_DIR=$(mktemp -d)
echo "📁 Temporary: $TEMP_DIR"

# Simulasi pekerjaan
echo "📦 Mengumpulkan file..."
sleep 1

# Simulasi error (uncomment untuk test)
# false

echo "💾 Menyimpan backup..."
sleep 1

echo "🎉 Selesai!"
```

**Penjelasan Mental — Trap sebagai "Last Will":**

**Analogi:** Trap seperti "surat wasiat" — Anda menulis apa yang harus dilakukan saat "meninggal" (exit). Apapun yang terjadi (sukses, error, Ctrl+C, kill), trap akan dijalankan.

**Jenis-jenis trap:**

| Signal | Arti | Kapan dipanggil |
|---|---|---|
| `EXIT` | Exit | Setiap kali script berakhir (apapun alasannya) |
| `INT` | Interrupt | Ctrl+C ditekan |
| `TERM` | Terminate | `kill` command |
| `HUP` | Hangup | Terminal ditutup |
| `ERR` | Error | Ada perintah yang gagal (dengan `set -e`) |

**Penting — Simpan `$?` di awal cleanup:**

```zsh
# ❌ SALAH: exit code sudah hilang
cleanup() {
    echo "Bersihkan..."
    rm -rf "$TEMP_DIR"
    # Di sini, $? adalah exit code dari `rm`, bukan script!
    exit $?  # Ini akan selalu 0 (karena rm sukses)
}

# ✅ BENAR: simpan exit code PERTAMA
cleanup() {
    local exit_code=$?  # ← Simpan di baris PERTAMA
    rm -rf "$TEMP_DIR"
    exit $exit_code     # ← Gunakan yang asli
}
```

**Mengapa ini penting?** Tanpa menyimpan `$?` di awal, Anda kehilangan exit code asli script. Script Anda mungkin gagal dengan code 1, tapi trap menjalankan `rm` yang sukses (code 0), lalu `exit $?` mengembalikan 0. **Caller akan mengira script sukses padahal gagal!**

**`mktemp -d` — Temporary Directory yang Aman:**

- Membuat direktori unik di `/tmp/` dengan permission 700
- Nama seperti `/tmp/tmp.X9kLm2nPqR`
- Aman dari race condition dan symlink attack
- **Selalu** bersihkan dengan trap

---

### Pertanyaan 6: Debugging dengan `set -x`

**Tantangan:** Script backup Anda kadang berhasil, kadang gagal, tanpa pola jelas. Bagaimana Anda men-debug? Tambahkan mode debug yang bisa diaktifkan dengan environment variable `DEBUG=1`.

**Jawaban:**

```zsh
#!/bin/zsh
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# DEBUG MODE — Aktifkan dengan DEBUG=1
# ═══════════════════════════════════════════════════════════
if [[ "${DEBUG:-0}" == "1" ]]; then
    # xtrace: tampilkan setiap perintah sebelum dieksekusi
    set -x
    
    # PS4: prefix untuk xtrace — lebih informatif
    # %N = nama file, %i = nomor baris, %_ = fungsi saat ini
    export PS4='+[${(%):-%N}:${(%):-%i}] '
    
    echo "🐛 DEBUG MODE AKTIF" >&2
fi

# ═══════════════════════════════════════════════════════════
# FUNGSI DEBUG — Untuk pesan yang lebih terstruktur
# ═══════════════════════════════════════════════════════════
debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "🐛 DEBUG: $*" >&2
    fi
}

# ═══════════════════════════════════════════════════════════
# FUNGSI UTAMA
# ═══════════════════════════════════════════════════════════
do_backup() {
    local source="$1"
    local dest="$2"
    
    debug "Source: $source"
    debug "Dest: $dest"
    
    debug "Memeriksa source..."
    if [[ ! -d "$source" ]]; then
        echo "Error: source tidak ada" >&2
        return 1
    fi
    
    debug "Membuat dest_dir..."
    mkdir -p "$dest"
    
    debug "Menjalankan tar..."
    tar -czf "$dest/backup.tar.gz" -C "$source" . 
    
    debug "Backup selesai"
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
do_backup "$@"
```

**Cara menjalankan:**

```bash
# Normal
./backup.zsh /etc/nusantara /home/nusantara/backups

# Debug
DEBUG=1 ./backup.zsh /etc/nusantara /home/nusantara/backups

# Debug + simpan ke file
DEBUG=1 ./backup.zsh /etc/nusantara /home/nusantara/backups 2>debug.log
```

**Penjelasan Mental — `set -x` (xtrace):**

**Apa yang terjadi:**
```zsh
set -x
name="Budi"
echo "Halo, $name"
```
**Output:**
```
+name=Budi
+echo 'Halo, Budi'
Halo, Budi
```

Setiap baris dengan prefix `+` adalah **trace** dari perintah yang dieksekusi.

**`PS4` — Prompt untuk xtrace:**

Default `PS4` adalah `+ `. Anda bisa mengubahnya untuk debugging yang lebih informatif:

| Specifier | Arti |
|---|---|
| `%N` | Nama file script |
| `%i` | Nomor baris |
| `%_` | Nama fungsi saat ini |
| `%D` | Tanggal/waktu |

**Contoh PS4 yang berguna:**
```zsh
export PS4='+[${LINENO}] ${funcfiletrace[1]}: '
# Output: +[42] backup.zsh:12: echo 'test'
```

Ini memungkinkan Anda **langsung tahu di baris mana dan fungsi mana** trace terjadi — sangat berguna untuk script panjang.

**Perbedaan `set -x` dan `set -v`:**

- `set -x` (**xtrace**): Tampilkan **setelah ekspansi** — menunjukkan perintah final
- `set -v` (**verbose**): Tampilkan **sebelum ekspansi** — menunjukkan baris asli

Contoh:
```zsh
set -v
name="Budi"
echo "$name"
```
Output:
```
name="Budi"        # Baris asli
echo "$name"       # Baris asli (belum di-ekspansi)
Budi               # Hasil
```

**`DEBUG` sebagai environment variable:**

- `${DEBUG:-0}` — Parameter expansion dengan default: gunakan `$DEBUG` jika ada, jika tidak `0`
- Ini memungkinkan: `DEBUG=1 ./script.zsh`
- Tidak perlu mengubah script untuk debugging

**⚠️ Peringatan:** Jangan biarkan `set -x` aktif di produksi! Output trace bisa sangat panjang dan berisi informasi sensitif (seperti password di argumen).

---

### Pertanyaan 7: Menggabungkan Semua — Script Backup Lengkap

**Tantangan:** Gabungkan semua yang telah dipelajari menjadi script `backup.zsh` yang lengkap: strict mode, logging, validasi, backup, rotasi, error handling, dan debug mode.

**Jawaban:**

```zsh
#!/bin/zsh
# ═══════════════════════════════════════════════════════════
# backup.zsh — Script backup enterprise dengan log rotation
# ═══════════════════════════════════════════════════════════
# Usage: backup.zsh <command> [options]
# 
# Commands:
#   backup <src> <dst>   Backup direktori
#   rotate <logdir>      Rotate log lama
#   full                 Backup lengkap + rotate
# ═══════════════════════════════════════════════════════════

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# KONSTANTA
# ═══════════════════════════════════════════════════════════
readonly SCRIPT_NAME="${0:t}"
readonly SCRIPT_DIR="${0:A:h}"
readonly SCRIPT_VERSION="1.0.0"
readonly LOG_FILE="${LOG_FILE:-/var/log/nusantara/backup.log}"
readonly BACKUP_DIR="${BACKUP_DIR:-/home/nusantara/backups}"
readonly CONFIG_DIR="${CONFIG_DIR:-/etc/nusantara}"
readonly LOG_DIR="${LOG_DIR:-/var/log/nusantara}"

# Konfigurasi rotasi (hari)
readonly ROTATE_DAYS=7
readonly COMPRESS_DAYS=30
readonly DELETE_DAYS=90

# ═══════════════════════════════════════════════════════════
# STATE
# ═══════════════════════════════════════════════════════════
TEMP_DIR=""

# ═══════════════════════════════════════════════════════════
# DEBUG MODE
# ═══════════════════════════════════════════════════════════
if [[ "${DEBUG:-0}" == "1" ]]; then
    set -x
    export PS4='+[${LINENO}] '
fi

# ═══════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════
log() {
    local level="$1"; shift
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    printf '[%s] [%-5s] %s\n' "$timestamp" "$level" "$*" | tee -a "$LOG_FILE" >&2
}
log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }
log_debug() { [[ "${DEBUG:-0}" == "1" ]] && log "DEBUG" "$@"; }

# ═══════════════════════════════════════════════════════════
# TRAP
# ═══════════════════════════════════════════════════════════
cleanup() {
    local exit_code=$?
    [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"
    if [[ $exit_code -ne 0 ]]; then
        log_error "Script gagal (exit: $exit_code)"
    fi
    exit $exit_code
}
trap cleanup EXIT

# ═══════════════════════════════════════════════════════════
# USAGE
# ═══════════════════════════════════════════════════════════
usage() {
    cat <<EOF
$SCRIPT_NAME v$SCRIPT_VERSION — Backup & Log Rotation

Usage: $SCRIPT_NAME <command> [options]

Commands:
    backup <src> <dst>   Backup direktori ke tujuan
    rotate [logdir]      Rotate log (default: $LOG_DIR)
    full                 Full backup + rotate
    help                 Tampilkan bantuan ini

Environment Variables:
    DEBUG=1              Aktifkan debug mode
    LOG_FILE=<path>      Lokasi log (default: $LOG_FILE)
    BACKUP_DIR=<path>    Direktori backup (default: $BACKUP_DIR)
EOF
}

# ═══════════════════════════════════════════════════════════
# FUNGSI BACKUP
# ═══════════════════════════════════════════════════════════
do_backup() {
    local src="${1:?Error: source tidak diberikan}"
    local dst="${2:?Error: dest tidak diberikan}"
    
    log_info "Backup dimulai: $src → $dst"
    
    # Validasi
    if [[ ! -d "$src" ]]; then
        log_error "Source tidak ada: $src"
        return 1
    fi
    if [[ ! -r "$src" ]]; then
        log_error "Source tidak bisa dibaca: $src"
        return 2
    fi
    
    # Buat dest jika belum ada
    mkdir -p "$dst" || {
        log_error "Gagal membuat dest: $dst"
        return 3
    }
    
    # Buat backup
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_name="backup_$(basename "$src")_${timestamp}.tar.gz"
    local backup_path="${dst}/${backup_name}"
    
    log_info "Membuat arsip: $backup_name"
    if tar -czf "$backup_path" -C "$(dirname "$src")" "$(basename "$src")" 2>/dev/null; then
        local size=$(du -h "$backup_path" | cut -f1)
        log_info "✅ Backup selesai: $backup_path ($size)"
        return 0
    else
        log_error "❌ Backup gagal: $src"
        return 4
    fi
}

# ═══════════════════════════════════════════════════════════
# FUNGSI ROTATE
# ═══════════════════════════════════════════════════════════
do_rotate() {
    local logdir="${1:-$LOG_DIR}"
    
    log_info "Rotasi log dimulai: $logdir"
    
    if [[ ! -d "$logdir" ]]; then
        log_error "Direktori tidak ada: $logdir"
        return 1
    fi
    
    local rotated=0 compressed=0 deleted=0
    
    # ─── 1. ROTATE: > 7 hari ───
    log_debug "Mencari log > $ROTATE_DAYS hari..."
    for logfile in "$logdir"/*.log(m+${ROTATE_DAYS}); do
        [[ -f "$logfile" ]] || continue
        local date_suffix=$(date -r "$logfile" '+%Y%m%d' 2>/dev/null || echo "unknown")
        mv "$logfile" "${logfile}.${date_suffix}" && {
            log_info "🔄 Rotated: ${logfile:t}"
            (( ++rotated ))
        }
    done
    
    # ─── 2. COMPRESS: > 30 hari ───
    for logfile in "$logdir"/*.log.*(m+${COMPRESS_DAYS}); do
        [[ -f "$logfile" ]] || continue
        [[ "$logfile" == *.gz ]] && continue
        gzip "$logfile" && {
            log_info "📦 Compressed: ${logfile:t}"
            (( ++compressed ))
        }
    done
    
    # ─── 3. DELETE: > 90 hari ───
    for logfile in "$logdir"/*.log.*.gz(m+${DELETE_DAYS}); do
        [[ -f "$logfile" ]] || continue
        rm "$logfile" && {
            log_info "🗑️  Deleted: ${logfile:t}"
            (( ++deleted ))
        }
    done
    
    log_info "Rotasi selesai: rotated=$rotated, compressed=$compressed, deleted=$deleted"
}

# ═══════════════════════════════════════════════════════════
# FUNGSI FULL
# ═══════════════════════════════════════════════════════════
do_full() {
    log_info "═══ FULL BACKUP DIMULAI ═══"
    do_backup "$CONFIG_DIR" "$BACKUP_DIR/configs" || return 1
    do_rotate "$LOG_DIR" || return 2
    log_info "═══ FULL BACKUP SELESAI ═══"
}

# ═══════════════════════════════════════════════════════════
# MAIN DISPATCH
# ═══════════════════════════════════════════════════════════
main() {
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        backup)  do_backup "$@" ;;
        rotate)  do_rotate "$@" ;;
        full)    do_full ;;
        help|-h|--help) usage ;;
        version|-v|--version) echo "$SCRIPT_NAME v$SCRIPT_VERSION" ;;
        *)       log_error "Command tidak dikenal: $command"; usage; exit 1 ;;
    esac
}

main "$@"
```

**Cara Menggunakan:**

```bash
# Berikan permission eksekusi
chmod +x backup.zsh

# Backup config
./backup.zsh backup /etc/nusantara /home/nusantara/backups

# Rotate log
./backup.zsh rotate

# Full backup
./backup.zsh full

# Debug mode
DEBUG=1 ./backup.zsh full
```

**Penjelasan Mental — Arsitektur Script:**

Script ini mengikuti **pola dispatcher**:

```
main() 
  └── case "$command" in
        backup)  do_backup "$@"   ← Argumen diteruskan
        rotate)  do_rotate "$@"   ← Argumen diteruskan
        full)    do_full          ← Tidak perlu argumen
        ...
```

**Mengapa pola ini?** 
1. **Satu entry point** — `main()` adalah satu-satunya yang dipanggil di akhir
2. **Modular** — setiap command punya fungsinya sendiri
3. **Extensible** — menambah command baru cukup tambah case
4. **Testable** — setiap fungsi bisa di-test secara independen

**`"${1:?Error: ...}"` — Parameter Expansion dengan Error:**

```zsh
local src="${1:?Error: source tidak diberikan}"
```

Ini adalah **ekspansi dengan validasi**:
- Jika `$1` **ada** dan tidak kosong → gunakan nilainya
- Jika `$1` **kosong/undefined** → tampilkan error dan **exit script**

Ini adalah cara ringkas untuk validasi argumen wajib:

```zsh
# Panjang:
if [[ -z "${1:-}" ]]; then
    echo "Error: source tidak diberikan" >&2
    exit 1
fi
local src="$1"

# Ringkas:
local src="${1:?Error: source tidak diberikan}"
```

**`du -h` — Disk Usage:**

- `du` = disk usage
- `-h` = human-readable (KB, MB, GB)
- Output: `1.5M    /path/to/file`

**Mengapa `2>/dev/null` di `tar`?**

`tar` kadang menulis warning ke stderr meskipun berhasil (misalnya "file changed as we read it"). Kita tidak ingin warning ini mengganggu. Tetapi kita tetap capture **exit code** untuk mengecek sukses/gagal.

**⚠️ Peringatan:** Ini adalah trade-off. Jika ada error **benar-benar** penting, Anda tidak akan melihatnya. Untuk sistem kritis, mungkin lebih baik **log stderr** daripada membuangnya.

---

### Pertanyaan 8: Menjadwalkan dengan Cron

**Tantangan:** Setelah script selesai, jadwalkan agar berjalan otomatis setiap hari pada jam 2 pagi. Tulis entri cron yang benar, dan jelaskan environment yang harus di-set.

**Jawaban:**

**Langkah 1: Edit crontab**

```bash
crontab -e
```

**Langkah 2: Tambahkan entri**

```cron
# ═══════════════════════════════════════════════════════════
# CRONTAB ENTRY — Backup Nusantara Tech
# ═══════════════════════════════════════════════════════════

# Format: minute hour day_of_month month day_of_week command
# ┌─────── minute (0-59)
# │ ┌─────── hour (0-23)
# │ │ ┌─────── day of month (1-31)
# │ │ │ ┌─────── month (1-12)
# │ │ │ │ ┌─────── day of week (0-6, 0=Sunday)
# │ │ │ │ │
# 0 2 * * * /home/nusantara/bin/backup.zsh full >> /var/log/nusantara/cron_backup.log 2>&1
```

**Langkah 3: Verifikasi**

```bash
# Lihat crontab Anda
crontab -l

# Cek log cron
tail -f /var/log/nusantara/cron_backup.log

# Cek apakah cron daemon berjalan
systemctl status cron  # Linux Debian/Ubuntu
systemctl status crond # Linux RHEL/CentOS
```

**Penjelasan Mental — Cron Environment:**

**Jebakan terbesar dengan cron:** Cron tidak memiliki environment yang sama dengan shell interaktif Anda!

**Environment cron:**
- `PATH` sangat minimal: biasanya hanya `/usr/bin:/bin`
- Tidak ada `~/.zshrc`, `~/.bashrc`, atau dotfiles lain yang di-source
- Tidak ada `DISPLAY` (tidak bisa GUI)
- Working directory adalah home directory user

**Solusi — 3 lapis:**

**Lapis 1: Gunakan absolute path di crontab**
```cron
# ❌ SALAH: `zsh` mungkin tidak ada di PATH cron
0 2 * * * backup.zsh full

# ✅ BENAR: gunakan absolute path
0 2 * * * /home/nusantara/bin/backup.zsh full
```

**Lapis 2: Set environment di crontab**
```cron
# Set environment di awal crontab
SHELL=/bin/zsh
PATH=/usr/local/bin:/usr/bin:/bin:/home/nusantara/bin
HOME=/home/nusantara

0 2 * * * /home/nusantara/bin/backup.zsh full
```

**Lapis 3: Buat script wrapper yang setup environment**

```zsh
#!/bin/zsh
# /home/nusantara/bin/cron-backup-wrapper.zsh
# Wrapper untuk cron — setup environment yang diperlukan

# Setup PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/home/nusantara/bin"

# Set environment variables yang dibutuhkan script
export LOG_FILE="/var/log/nusantara/backup.log"
export BACKUP_DIR="/home/nusantara/backups"

# Jalankan script utama
exec /home/nusantara/bin/backup.zsh full
```

Lalu di crontab:
```cron
0 2 * * * /home/nusantara/bin/cron-backup-wrapper.zsh
```

**Redirect Output:**

```cron
# Redirect stdout dan stderr ke log
0 2 * * * /path/to/backup.zsh full >> /var/log/backup.log 2>&1
```

- `>>` = append (jangan timpa log lama)
- `2>&1` = redirect stderr (2) ke stdout (1) — gabungkan keduanya
- **Selalu redirect** — jika tidak, cron akan mencoba mengirim email setiap kali script berjalan

**Format Waktu Cron:**

| Ekspresi | Arti |
|---|---|
| `0 2 * * *` | Setiap hari jam 2 pagi |
| `0 */6 * * *` | Setiap 6 jam (00:00, 06:00, 12:00, 18:00) |
| `0 2 * * 0` | Setiap hari Minggu jam 2 pagi |
| `0 2 1 * *` | Tanggal 1 setiap bulan jam 2 pagi |
| `*/5 * * * *` | Setiap 5 menit |
| `0 9-17 * * 1-5` | Setiap jam 9-17, Senin-Jumat (jam kerja) |

**Tips Debug Cron:**

Jika script berjalan manual tapi tidak di cron:

1. **Cek log cron:**
```bash
grep CRON /var/log/syslog  # Debian/Ubuntu
grep CRON /var/log/cron    # RHEL/CentOS
```

2. **Test dengan environment terbatas:**
```bash
# Simulasi environment cron
env -i HOME=$HOME PATH=/usr/bin:/bin /bin/zsh -c '/path/to/backup.zsh full'
```

3. **Tambahkan debug output:**
```cron
0 2 * * * /path/to/backup.zsh full > /tmp/cron-debug.log 2>&1
```

4. **Gunakan `logger` untuk syslog:**
```zsh
# Di dalam script
logger -t backup "Backup dimulai"
```

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Alur Script Backup** — Flowchart dengan decision points: Validasi → Backup → Rotate → Compress → Delete. Tandai jalur "sukses" (hijau) dan "error" (merah) dengan trap yang menangkap keduanya.
>
> 2. **Diagram Trap** — Diagram yang menunjukkan kapan `trap EXIT` dipanggil: setelah sukses, setelah error, setelah Ctrl+C. Bandingkan dengan tanpa trap.
>
> 3. **Timeline Rotasi Log** — Garis waktu horizontal dengan file log sebagai kotak. Tandai kapan file di-rotate (>7 hari), di-compress (>30 hari), dan di-delete (>90 hari). Ini akan memperjelas logika `(m+7)`, `(m+30)`, `(m+90)`.
>
> 4. **Tabel Strict Mode** — Tabel 3 kolom: Opsi (`-e`, `-u`, `pipefail`), Efek, dan Contoh Kasus yang Dicegah.
>
> 5. **Cron Environment** — Diagram yang membandingkan environment interaktif vs cron: PATH, dotfiles, HOME, working directory. Tandai perbedaan dengan warna merah.

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.1 (Fondasi)** | Variabel, quoting, dan command substitution adalah fondasi untuk semua yang ada di sini |
| **7.3 (Globbing & Konfigurasi)** | Glob qualifier `(m+7)` yang digunakan di sini akan diperdalam |
| **7.4 (Performa & Keamanan)** | Strict mode dan trap adalah langkah awal menuju scripting yang aman |
| **7.5 (Testing)** | Script backup ini akan menjadi kandidat untuk unit test |
| **Fase 2 (Kurikulum)** | Modul ini adalah aplikasi langsung dari: struktur script, kontrol alur, fungsi, I/O, error handling, debugging |

---

## 9. Sumber Referensi Lengkap

- **Zsh Manual: Options (`set -e`, `set -x`)** — https://zsh.sourceforge.io/Doc/Release/Options.html
- **Zsh Manual: Functions** — https://zsh.sourceforge.io/Doc/Release/Functions.html
- **Zsh Manual: Conditional Expressions** — https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html
- **Zsh Manual: Redirection** — https://zsh.sourceforge.io/Doc/Release/Redirection.html
- **Zsh Manual: Parameter Expansion** — https://zsh.sourceforge.io/Doc/Release/Expansion.html
- **Bash Strict Mode** — http://redsymbol.net/articles/unofficial-bash-strict-mode/
- **Google Shell Style Guide** — https://google.github.io/styleguide/shellguide.html
- **ShellCheck** — https://www.shellcheck.net/
- **crontab.guru (interactive cron)** — https://crontab.guru/
- **cron man page** — https://man7.org/linux/man-pages/man5/crontab.5.html
- **trap man page** — https://man7.org/linux/man-pages/man1/trap.1p.html

---

## 10. Tips dan Praktik Terbaik

1. **Selalu `set -euo pipefail` di awal script.** Ini adalah "sabuk pengaman" untuk scripting.
2. **Gunakan `readonly` untuk konfigurasi.** Mencegah perubahan tidak sengaja.
3. **Simpan `$?` di awal fungsi cleanup.** Jangan biarkan exit code asli hilang.
4. **Log ke file dan layar sekaligus** dengan `tee`. Di cron, file adalah satu-satunya cara debugging.
5. **Gunakan `mktemp -d` untuk temporary directory.** Aman dari race condition.
6. **Test dengan `DEBUG=1`.** Jangan debug dengan `echo` di mana-mana.
7. **Exit code yang bermakna.** Caller harus bisa membedakan jenis kegagalan.
8. **Idempoten.** Jika dijalankan dua kali, hasilnya sama.
9. **Jangan pernah hardcode path.** Gunakan variabel atau environment.
10. **Redirect output di cron.** Jika tidak, mail box akan penuh dengan notifikasi.
11. **Test di environment minimal.** Cron environment berbeda dari shell interaktif.
12. **Backup script Anda sendiri.** Ironis jika script backup hilang.
13. **Gunakan `shellcheck`.** Linter ini menangkap banyak bug umum.
14. **Review exit code.** `echo $?` setelah setiap perintah penting saat development.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Lupa `set -e` | Script lanjut meskipun ada error | Tambahkan `set -euo pipefail` |
| `$?` di cleanup setelah perintah lain | Exit code asli hilang | `local exit_code=$?` di baris **pertama** |
| `(( count++ ))` dengan `set -e` | Script exit jika count=0 | Gunakan `(( ++count ))` atau `|| true` |
| Tidak quote `"$@"` | Argumen dengan spasi terpecah | Selalu `"$@"` |
| `ls | grep` | Gagal dengan nama file aneh | Gunakan glob atau `find` |
| `for f in $(ls)` | Gagal dengan spasi di nama file | Gunakan `for f in *` atau `${arr[@]}` |
| Cron tanpa absolute path | Command not found | Gunakan `/full/path/to/script` |
| Cron tanpa redirect | Mailbox penuh | `>> logfile 2>&1` |
| Tidak cleanup temp | `/tmp` penuh | `trap cleanup EXIT` |
| Log tidak writable | Script error tanpa pesan | Cek `-w` sebelum log |
| `tar` tanpa `-C` | Arsip salah path | Gunakan `-C dir .` |
| Symlink loop | `find`/`ls` infinite | Gunakan `-L` flag hati-hati |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.2, Anda seharusnya mengembangkan **mental model baru**:

1. **Script adalah kontrak, bukan urutan perintah.** Anda mendefinisikan input, proses, output, dan jaminan.
2. **Fail fast, fail loud.** Lebih baik script berhenti cepat dengan pesan jelas daripada melanjutkan dan menyebabkan kerusakan.
3. **Idempotent by default.** Script harus aman dijalankan berkali-kali.
4. **Observable.** Setiap aksi harus tercatat; setiap kegagalan harus bisa di-debug.
5. **Exit code adalah API.** Caller menggunakan exit code untuk memahami apa yang terjadi.
6. **Trap adalah asuransi.** Apapun yang terjadi, cleanup akan dijalankan.
7. **Cron adalah lingkungan asing.** Script yang berjalan di cron harus mandiri (tidak bergantung pada dotfiles).
8. **Debugging adalah keterampilan, bukan sihir.** `set -x`, `DEBUG=1`, dan log terstruktur adalah tools utama.

**Pertanyaan reflektif untuk diri sendiri:**
- Bisakah saya menjelaskan perbedaan `-e`, `-u`, `-o pipefail` tanpa melihat catatan?
- Apakah saya tahu mengapa `local exit_code=$?` harus di baris pertama cleanup?
- Bisakah saya menulis script backup dari nol tanpa melihat contoh?
- Apakah saya tahu mengapa cron tidak menemukan script saya yang jalan manual?
- Apakah script saya idempoten? Bisakah dijalankan dua kali?

Jika jawabannya "belum", **ulangi modul ini** — scripting adalah keterampilan fundamental untuk semua fase berikutnya.

### Checklist Verifikasi

Sebelum melanjutkan ke Modul 7.3, pastikan Anda dapat:

- [ ] Menulis script dengan shebang, strict mode, dan komentar yang jelas
- [ ] Mendefinisikan dan menggunakan fungsi dengan parameter dan return value
- [ ] Menggunakan `local` untuk variabel fungsi
- [ ] Memvalidasi input dengan test operator (`-d`, `-f`, `-r`, `-w`)
- [ ] Menangani error dengan `set -e`, `trap`, dan exit code bermakna
- [ ] Menggunakan `set -x` dan `PS4` untuk debugging
- [ ] Membuat temporary directory dengan `mktemp -d` dan membersihkannya di trap
- [ ] Menulis log terstruktur dengan timestamp dan level
- [ ] Menggunakan heredoc untuk usage/help text
- [ ] Membuat dispatcher script dengan subcommands
- [ ] Menjadwalkan script di cron dengan environment yang benar
- [ ] Menjalankan `shellcheck` dan memperbaiki peringatan

---

## ✅ MODUL 7.2 SELESAI

**Ringkasan yang telah Anda kuasai:**
- Struktur script profesional dengan strict mode
- Kontrol alur: kondisi, loop, case dispatch
- Fungsi dengan parameter, lokal, dan return value
- Logging terstruktur dengan `tee`
- Error handling dengan `trap` dan exit code
- Debugging dengan `set -x` dan `PS4`
- Rotasi log dengan glob qualifier `(m+N)`
- Penjadwalan dengan cron dan environment minimal

**Yang akan datang di Modul 7.3:**
Anda akan membangun **sistem konfigurasi tim yang skalabel** — menggunakan globbing lanjutan, completion system, dan file konfigurasi modular. Ini adalah langkah pertama menuju "arsitek shell" — dari pengguna menjadi perancang.

---

# MODUL 7.3: MEMBANGUN SISTEM KONFIGURASI TIM YANG SKALABEL

> **Mewakili:** Fase 3 — Globbing Lanjutan, Completion System, Konfigurasi `.zshrc`, Opsi Shell, Startup Files
> **Level:** Menengah | **Durasi:** 8–10 jam | **Tipe:** Proyek Simulasi

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model "konfigurasi sebagai produk"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Toolkit globbing, completion, konfigurasi
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan nyata
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Nusantara Tech telah berkembang pesat.** Dari 5 developer menjadi 30 developer dalam setahun. Tim IT — yang dulu hanya Anda — kini memiliki 3 orang. Suatu hari, VP Engineering memanggil Anda:

> *"Masalah besar. Setiap developer punya setup shell yang berbeda-beda. Ada yang pakai Oh My Zsh dengan 50 plugin, ada yang vanilla, ada yang pakai framework lain. Akibatnya:*
> - *Ketika ada bug, kami tidak tahu apakah environment developer yang menyebabkan*
> - *Developer baru butuh 2-3 hari untuk setup environment*
> - *Ada developer yang tidak punya completion untuk tools internal kami*
> - *Ada yang menjalankan `rm -rf` tanpa konfirmasi dan hampir menghapus data*
> - *Tidak ada standar: siapa yang punya alias `gs` untuk `git status`, siapa yang punya `gs` untuk `git stash`*
>
> *Saya butuh Anda membangun **sistem konfigurasi Zsh yang skalabel untuk 30+ developer**. Persyaratan:*
> - *Konfigurasi harus modular — tim bisa menambah/mengurangi tanpa konflik*
> - *Harus ada baseline yang dijamin (keamanan, tools internal)*
> - *Developer tetap bisa customize dalam batas yang aman*
> - *Completion untuk tools internal harus tersedia otomatis*
> - *Harus ada dokumentasi dan onboarding yang jelas*
> - *Harus bisa di-deploy dengan satu perintah"*

Anda memiliki:
- Repository Git internal: `git.nusantara.tech/dotfiles`
- 30 developer dengan berbagai level
- Tools internal: `nusantara-cli`, `nt-deploy`, `nt-db`
- Kebutuhan: standarisasi tanpa mengebiri kreativitas

**Tantangan:** Bangun sistem konfigurasi yang **modular, aman, dan skalabel**.

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **jembatan dari pengguna menjadi arsitek**. Di Modul 7.2, Anda menulis script untuk diri sendiri. Sekarang, Anda menulis **konfigurasi untuk orang lain** — dan konfigurasi untuk orang lain jauh lebih sulit karena:

1. **Anda tidak bisa mengontrol cara mereka menggunakannya.**
2. **Mereka akan menemukan edge case yang tidak Anda pikirkan.**
3. **Mereka akan mengubahnya — dan Anda harus memastikan perubahan itu tidak merusak.**
4. **Anda harus mendokumentasikan — karena Anda tidak bisa menjawab pertanyaan 30 orang sekaligus.**

Di dunia kerja, **shell configuration adalah produk internal**. Ia memiliki user (developer), requirement (standar, keamanan, produktivitas), version (Git), dan deployment (onboarding). Modul ini melatih Anda untuk berpikir seperti **product engineer** untuk shell.

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: Konfigurasi sebagai "produk internal".**

Bayangkan Anda membangun aplikasi. Anda tidak akan:
- Hardcode konfigurasi di source code
- Mengizinkan user mengubah apa pun tanpa batas
- Mengabaikan error handling
- Tidak punya dokumentasi
- Tidak punya cara update

Hal yang sama berlaku untuk shell configuration. Sistem konfigurasi yang baik memiliki:
- **Layer**: baseline (wajib) + team (opsional) + personal (bebas)
- **Contract**: apa yang dijamin vs apa yang bisa diubah
- **Distribution**: cara deploy dan update
- **Observability**: cara tahu apakah konfigurasi berjalan benar
- **Safety**: apa yang tidak boleh dilanggar

**Filosofi "Convention over Configuration":**

Ruby on Rails mempopulerkan prinsip ini: berikan default yang masuk akal, izinkan override hanya jika perlu. Dalam konteks Zsh:
- **Convention**: file di `conf.d/` di-load dalam urutan numerik
- **Configuration**: Anda bisa menambah file `05-custom.zsh` tanpa mengubah file lain

**Filosofi "Progressive Disclosure":**

Sistem yang baik tidak membebani user dengan semua detail sekaligus. Developer baru cukup tahu: *"clone repo, jalankan setup, selesai."* Developer senior bisa menggali lebih dalam: *"tambahkan file di `conf.d/`, gunakan helper functions."*

**Filosofi "Fail-Safe Defaults":**

Jika konfigurasi gagal, default harus aman:
- Jika completion tidak tersedia → fallback ke default completion
- Jika plugin gagal load → log warning, jangan crash shell
- Jika `conf.d` tidak ada → shell tetap berjalan

**Filosofi "Explicit is Better than Implicit":**

- Jangan mengandalkan `$PATH` yang di-set entah di mana
- Jangan mengandalkan environment variable yang tidak jelas asalnya
- Setiap konfigurasi harus **eksplisit** — dari mana asalnya, apa tujuannya

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.3 — Globbing, Completion, Konfigurasi
# ═══════════════════════════════════════════════════════════

# ─── GLOBBING LANJUTAN ───
ls **/*.zsh                      # Recursive glob
ls **/*.zsh(.)                   # Hanya file biasa
ls **/*.zsh(/)                   # Hanya direktori
ls *(om[1,5])                    # 5 file terbaru
ls *(Lk+100)                     # File > 100KB
ls *(m-7)                        # Modified dalam 7 hari
ls ^*.tmp                        # Semua kecuali .tmp
setopt EXTENDED_GLOB
ls *~*.bak                       # Exclude pattern

# ─── COMPLETION SYSTEM ───
autoload -Uz compinit
compinit

# zstyle untuk konfigurasi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# Completion function kustom
_mycommand() {
    local -a options
    options=(
        '--help:Membuka bantuan'
        '--version:Menampilkan versi'
    )
    _describe 'options' options
}
compdef _mycommand mycommand

# ─── KONFIGURASI MODULAR ───
# Struktur:
# ~/.config/zsh/
#   ├── .zshrc           → entry point
#   ├── .zshenv          → environment
#   ├── conf.d/
#   │   ├── 00-base.zsh
#   │   ├── 10-security.zsh
#   │   ├── 20-tools.zsh
#   │   └── 30-prompt.zsh
#   └── functions/       → autoload functions

# Loading loop
for conf in "${ZDOTDIR:-$HOME}/conf.d"/*.zsh(N); do
    source "$conf"
done
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **Glob Qualifier** | Filter dalam tanda kurung setelah glob pattern | `*(.)` = hanya file |
| **`**` (Recursive Glob)** | Mencari di semua subdirektori | `**/*.zsh` |
| **`^` (Negasi)** | Exclude pattern | `^*.tmp` |
| **`~` (Exclusion)** | Exclude dalam extended glob | `*~*.bak` |
| **`(N)` (Null Glob)** | Jangan error jika tidak ada match | `*.zsh(N)` |
| **`(om)`** | Order by modification time | `*(om[1,5])` |
| **`(m+N)`** | Modified more than N days ago | `*(m+7)` |
| **`compinit`** | Inisialisasi completion system | `autoload -Uz compinit && compinit` |
| **`compdef`** | Daftarkan completion function | `compdef _git git` |
| **`zstyle`** | Konfigurasi untuk completion dan modul | `zstyle ':completion:*' menu select` |
| **`_describe`** | Helper untuk completion dengan deskripsi | `_describe 'opts' options` |
| **`conf.d`** | Direktori konfigurasi modular | `~/.config/zsh/conf.d/` |
| **`ZDOTDIR`** | Direktori dotfiles Zsh | `export ZDOTDIR=~/.config/zsh` |
| **`fpath`** | Array lokasi fungsi autoload | `fpath=("$ZDOTDIR/functions" $fpath)` |
| **`autoload`** | Muat fungsi saat pertama dipanggil | `autoload -Uz my_function` |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Audit Konfigurasi yang Ada

**Tantangan:** Sebelum membangun sistem baru, Anda perlu **audit** konfigurasi yang ada. Tulis script yang memeriksa: (a) shell apa yang digunakan, (b) file startup apa yang ada, (c) plugin manager apa yang terinstall, (d) berapa waktu startup shell.

**Jawaban:**

```zsh
#!/bin/zsh
# audit-zsh.zsh — Audit konfigurasi Zsh developer

set -euo pipefail

readonly REPORT_FILE="${1:-/tmp/zsh-audit-$(whoami)-$(date +%Y%m%d).txt}"

# ═══════════════════════════════════════════════════════════
# Fungsi helper
# ═══════════════════════════════════════════════════════════
section() {
    echo "" | tee -a "$REPORT_FILE"
    echo "════════════════════════════════════════════════════" | tee -a "$REPORT_FILE"
    echo "  $*" | tee -a "$REPORT_FILE"
    echo "════════════════════════════════════════════════════" | tee -a "$REPORT_FILE"
}

check_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local size=$(wc -c < "$file" | tr -d ' ')
        echo "  ✅ $file (${size} bytes)" | tee -a "$REPORT_FILE"
    else
        echo "  ❌ $file (tidak ada)" | tee -a "$REPORT_FILE"
    fi
}

# ═══════════════════════════════════════════════════════════
# 1. Informasi shell
# ═══════════════════════════════════════════════════════════
section "INFORMASI SHELL"
echo "  User: $(whoami)" | tee -a "$REPORT_FILE"
echo "  Home: $HOME" | tee -a "$REPORT_FILE"
echo "  Shell: $SHELL" | tee -a "$REPORT_FILE"
echo "  Zsh version: $ZSH_VERSION" | tee -a "$REPORT_FILE"
echo "  Host: $(hostname)" | tee -a "$REPORT_FILE"
echo "  OS: $(uname -s) $(uname -r)" | tee -a "$REPORT_FILE"

# ═══════════════════════════════════════════════════════════
# 2. File startup — cek di lokasi standar dan XDG
# ═══════════════════════════════════════════════════════════
section "FILE STARTUP"
# Cek lokasi tradisional
check_file "$HOME/.zshenv"
check_file "$HOME/.zprofile"
check_file "$HOME/.zshrc"
check_file "$HOME/.zlogin"
check_file "$HOME/.zlogout"

# Cek XDG
if [[ -n "${ZDOTDIR:-}" ]]; then
    echo "  ZDOTDIR: $ZDOTDIR" | tee -a "$REPORT_FILE"
    for f in .zshenv .zprofile .zshrc .zlogin .zlogout; do
        check_file "$ZDOTDIR/$f"
    done
fi

# ═══════════════════════════════════════════════════════════
# 3. Plugin manager
# ═══════════════════════════════════════════════════════════
section "PLUGIN MANAGER"
# Cek berbagai plugin manager
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "  ✅ Oh My Zsh terinstall" | tee -a "$REPORT_FILE"
    # Hitung plugin yang aktif
    if [[ -n "${plugins:-}" ]]; then
        echo "     Plugins aktif: ${#plugins[@]}" | tee -a "$REPORT_FILE"
        echo "     ${plugins[@]}" | tee -a "$REPORT_FILE"
    fi
fi

[[ -d "$HOME/.antidote" ]] && echo "  ✅ Antidote" | tee -a "$REPORT_FILE"
[[ -d "$HOME/.zinit" ]] && echo "  ✅ Zinit" | tee -a "$REPORT_FILE"
[[ -d "$HOME/.zplug" ]] && echo "  ✅ Zplug" | tee -a "$REPORT_FILE"

# ═══════════════════════════════════════════════════════════
# 4. Waktu startup
# ═══════════════════════════════════════════════════════════
section "WAKTU STARTUP"
echo "  Mengukur startup time..." | tee -a "$REPORT_FILE"
local times=()
for i in {1..3}; do
    local start=$(date +%s%N)
    zsh -i -c exit 2>/dev/null
    local end=$(date +%s%N)
    local duration=$(( (end - start) / 1000000 ))  # ms
    times+=("$duration")
done
echo "  3x pengukuran (ms): ${times[@]}" | tee -a "$REPORT_FILE"
local avg=$(( (${times[1]} + ${times[2]} + ${times[3]}) / 3 ))
echo "  Rata-rata: ${avg}ms" | tee -a "$REPORT_FILE"

if [[ $avg -gt 500 ]]; then
    echo "  ⚠️  Startup > 500ms — perlu optimasi" | tee -a "$REPORT_FILE"
elif [[ $avg -gt 200 ]]; then
    echo "  ⚠️  Startup > 200ms — bisa dioptimasi" | tee -a "$REPORT_FILE"
else
    echo "  ✅ Startup cepat" | tee -a "$REPORT_FILE"
fi

# ═══════════════════════════════════════════════════════════
# 5. Environment PATH
# ═══════════════════════════════════════════════════════════
section "PATH ANALYSIS"
echo "  Jumlah entry PATH: $(echo $PATH | tr ':' '\n' | wc -l | tr -d ' ')" | tee -a "$REPORT_FILE"
echo "  Duplikat: $(echo $PATH | tr ':' '\n' | sort | uniq -d | wc -l | tr -d ' ')" | tee -a "$REPORT_FILE"

# ═══════════════════════════════════════════════════════════
# SELESAI
# ═══════════════════════════════════════════════════════════
echo "" | tee -a "$REPORT_FILE"
echo "✅ Laporan tersimpan: $REPORT_FILE"
```

**Penjelasan Mental — Audit adalah Langkah Pertama:**

Audit adalah **prinsip universal** dalam engineering:
- Sebelum refactor kode, audit kode
- Sebelum deploy, audit environment
- Sebelum bangun sistem, audit yang ada

**Mengapa ini penting untuk proyek 30 developer?** Karena Anda perlu tahu **titik awal yang berbeda-beda**:
- 5 developer mungkin pakai Oh My Zsh
- 10 developer mungkin vanilla
- 15 developer mungkin tidak tahu apa yang mereka gunakan

Dengan audit script ini, Anda bisa **mengumpulkan data** dari 30 mesin dalam hitungan menit, bukan hari.

**`date +%s%N` — Nanosecond Timestamp:**

- `%s` = Unix timestamp (detik sejak 1970)
- `%N` = nanosecond
- Kombinasi: `1712345678123456789`
- Berguna untuk mengukur durasi presisi tinggi

**Mengapa 3x pengukuran?** Karena shell startup bisa bervariasi:
- Disk cache mungkin dingin pada run pertama
- Sistem mungkin sedang sibuk
- Rata-rata lebih reliable daripada single measurement

**`tr ':' '\n'` — Translate:**

- Mengganti `:` dengan newline
- `$PATH` = `dir1:dir2:dir3` → `dir1\ndir2\ndir3`
- Berguna untuk counting dengan `wc -l`

---

### Pertanyaan 2: Globbing Lanjutan untuk Code Review

**Tantangan:** Tim Anda melakukan code review mingguan. Anda perlu **menemukan file yang perlu di-review** berdasarkan kriteria:
- (a) File `.zsh` yang dimodifikasi dalam 7 hari terakhir
- (b) File `.conf` yang lebih besar dari 10KB
- (c) Semua file `.tmp` yang bisa dihapus
- (d) File executable di direktori `bin/`
- (e) 10 file terbaru di seluruh proyek

Tulis perintah Zsh untuk setiap kriteria (gunakan glob qualifier, bukan `find`).

**Jawaban:**

```zsh
#!/bin/zsh
set -euo pipefail

readonly PROJECT_DIR="${PROJECT_DIR:-/home/nusantara/projects}"
cd "$PROJECT_DIR"

# ═══════════════════════════════════════════════════════════
# (a) File .zsh modified dalam 7 hari
# ═══════════════════════════════════════════════════════════
echo "=== File .zsh modified dalam 7 hari ==="
for file in **/*.zsh(m-7); do
    [[ -f "$file" ]] || continue
    local mtime=$(date -r "$file" '+%Y-%m-%d %H:%M' 2>/dev/null || echo "?")
    echo "  $mtime  $file"
done

# ═══════════════════════════════════════════════════════════
# (b) File .conf > 10KB
# ═══════════════════════════════════════════════════════════
echo ""
echo "=== File .conf > 10KB ==="
# Lk+10 = size > 10 KB (k = kilobytes)
for file in **/*.conf(Lk+10); do
    [[ -f "$file" ]] || continue
    local size=$(du -h "$file" | cut -f1)
    echo "  $size  $file"
done

# ═══════════════════════════════════════════════════════════
# (c) File .tmp yang bisa dihapus
# ═══════════════════════════════════════════════════════════
echo ""
echo "=== File .tmp (kandidat hapus) ==="
local tmp_files=(**/*.tmp(N))
if [[ ${#tmp_files[@]} -eq 0 ]]; then
    echo "  (tidak ada file .tmp)"
else
    for file in "${tmp_files[@]}"; do
        local age=$(( ($(date +%s) - $(stat -c '%Y' "$file" 2>/dev/null || stat -f '%m' "$file")) / 86400 ))
        echo "  ${age} hari  $file"
    done
fi

# ═══════════════════════════════════════════════════════════
# (d) File executable di bin/
# ═══════════════════════════════════════════════════════════
echo ""
echo "=== Executable di bin/ ==="
# (x) = executable, (.) = regular file
for file in bin/*(x.); do
    [[ -f "$file" ]] || continue
    echo "  $file"
done

# ═══════════════════════════════════════════════════════════
# (e) 10 file terbaru secara rekursif
# ═══════════════════════════════════════════════════════════
echo ""
echo "=== 10 File Terbaru ==="
# om = order by mtime (descending), [1,10] = ambil 10 pertama
for file in **/*(.om[1,10]); do
    [[ -f "$file" ]] || continue
    local mtime=$(date -r "$file" '+%Y-%m-%d %H:%M' 2>/dev/null || echo "?")
    echo "  $mtime  $file"
done
```

**Penjelasan Mental — Glob Qualifier adalah "Query Language":**

Pikirkan glob qualifier seperti SQL untuk file system:

| Zsh Glob | "SQL" Equivalent |
|---|---|
| `*.zsh` | `WHERE name LIKE '%.zsh'` |
| `*(.)` | `WHERE type = 'file'` |
| `*(/)` | `WHERE type = 'directory'` |
| `*(x)` | `WHERE executable = true` |
| `*(Lk+10)` | `WHERE size > 10KB` |
| `*(m-7)` | `WHERE mtime > (now - 7 days)` |
| `*(om)` | `ORDER BY mtime DESC` |
| `*(om[1,10])` | `ORDER BY mtime DESC LIMIT 10` |
| `*(N)` | `IF EMPTY THEN []` (no error) |

**Keunggulan Zsh:** Semua ini **built-in**, tidak perlu `find` dengan `-exec`, tidak perlu pipeline kompleks.

**Glob Qualifier yang Sering Digunakan:**

| Qualifier | Arti |
|---|---|
| `.` | Regular file |
| `/` | Direktori |
| `@` | Symlink |
| `*` | Executable (dengan `x`) |
| `x` | Executable |
| `r` | Readable |
| `w` | Writable |
| `R` | World-readable |
| `W` | World-writable |
| `N` | Null glob (jangan error) |
| `^` | Negasi |
| `m-N` | Modified N days ago |
| `m+N` | Modified > N days ago |
| `Lk+N` | Size > N KB |
| `om` | Order by mtime |
| `On` | Order by name |
| `On` | Reverse name order |
| `[start,end]` | Slice |

**Mengapa `[[ -f "$file" ]] || continue`?**

Karena `(N)` (null_glob) hanya bekerja untuk **satu level**. Jika pattern `**/*.zsh(m-7)` tidak menemukan apa pun, array bisa kosong — tapi dalam `for` loop, Zsh mungkin tetap menjalankan satu iterasi dengan nilai literal. Guard `[[ -f "$file" ]]` memastikan hanya file nyata yang diproses.

**Kombinasi `(x.)` — Executable AND Regular File:**

- `x` = executable
- `.` = regular file
- `(x.)` = kedua kondisi harus terpenuhi

Ini mencegah symlink yang executable (yang mungkin menunjuk ke luar proyek) ikut terdeteksi.

---

### Pertanyaan 3: Membangun Completion untuk Tools Internal

**Tantangan:** Nusantara Tech punya tools internal `nt-deploy` dengan sintaks:
```
nt-deploy <environment> [--service <name>] [--version <tag>] [--dry-run]
```
Di mana `<environment>` adalah `staging`, `production`, atau `dev`. Buat completion function Zsh untuk tool ini.

**Jawaban:**

```zsh
#!/bin/zsh
# _nt-deploy — Completion untuk nt-deploy
# Letakkan di: ~/.config/zsh/functions/_nt-deploy

#compdef nt-deploy

_nt-deploy() {
    local -a environments
    local -a services
    local -a versions
    local context state line
    typeset -A opt_args

    # ─── Data yang bisa di-complete ───
    environments=(
        'staging:Staging environment'
        'production:Production environment (requires approval)'
        'dev:Development environment'
    )

    # Ambil daftar service dari konfigurasi
    if [[ -f /etc/nusantara/services.txt ]]; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == \#* ]] && continue
            services+=("$line")
        done < /etc/nusantara/services.txt
    else
        services=(api web worker db)
    fi

    # Ambil versi dari Git tags (jika di repo)
    if git rev-parse --git-dir &>/dev/null; then
        while IFS= read -r tag; do
            versions+=("$tag")
        done < <(git tag --sort=-v:refname | head -20)
    fi

    # ─── Parsing argumen ───
    _arguments -C \
        '1:environment:->env' \
        '--service=[Service name]:service:->service' \
        '--version=[Version tag]:version:->version' \
        '--dry-run[Simulate deployment]' \
        '--help[Show help]' \
        '(-h --help)'{-h,--help}'[Show help]' \
        '*::arg:->args'

    case "$state" in
        env)
            _describe -t environments 'environment' environments
            ;;
        service)
            _describe -t services 'service' services
            ;;
        version)
            if [[ ${#versions[@]} -gt 0 ]]; then
                _describe -t versions 'version' versions
            else
                _message 'version tag'
            fi
            ;;
        args)
            case "$words[1]" in
                nt-deploy)
                    _nt-deploy
                    ;;
            esac
            ;;
    esac
}

_nt-deploy "$@"
```

**Penjelasan Mental — Struktur Completion Function:**

**1. `#compdef` — Tag untuk autoload:**

Baris `#compdef nt-deploy` memberitahu sistem completion bahwa file ini adalah completion function untuk command `nt-deploy`. Ketika Anda mengetik `nt-deploy <TAB>`, Zsh akan mencari file ini di `$fpath`.

**2. `_arguments` — Parser Argumen:**

Ini adalah fungsi helper yang paling powerful di Zsh completion. Ia mem-parsing argumen berdasarkan spesifikasi:

```
'1:environment:->env'
 │ │            │
 │ │            └── State untuk case di bawah
 │ └── Deskripsi
 └── Posisi argumen ke-1
```

```
'--service=[Service name]:service:->service'
 │         │              │        │
 │         │              │        └── State
 │         │              └── Nama untuk completion
 │         └── Deskripsi
 └── Opsi --service (dengan =)
```

**3. `_describe` — Tampilkan dengan Deskripsi:**

```zsh
_describe -t environments 'environment' environments
```

- `-t environments` = tag untuk grouping
- `'environment'` = judul yang ditampilkan
- `environments` = array nama (dengan format `name:description`)

Output:
```
staging      -- Staging environment
production   -- Production environment (requires approval)
dev          -- Development environment
```

**4. `_message` — Fallback:**

Jika tidak ada data dinamis (misalnya tidak ada Git tags), gunakan `_message` untuk memberi tahu user bahwa mereka perlu mengetik manual.

**5. `_arguments -C` — Context:**

Opsi `-C` memungkinkan `_arguments` untuk memodifikasi `$state` dan `$words` berdasarkan konteks. Ini memungkinkan completion bersarang.

**Studi Kasus: Bagaimana Completion Bekerja?**

Ketika user mengetik:
```
nt-deploy sta<TAB>
```

1. Zsh mencari `_nt-deploy` di `$fpath`
2. `_arguments` menganalisis: `sta` adalah argumen posisi 1
3. `$state` di-set ke `env`
4. `case "$state"` dijalankan: `env` → `_describe` dengan array `environments`
5. `_describe` memfilter: `staging` cocok dengan prefix `sta`
6. Saran: `staging`

Ketika user mengetik:
```
nt-deploy staging --service <TAB>
```

1. `_arguments` menganalisis: `--service` adalah opsi dengan argumen
2. `$state` di-set ke `service`
3. `case "$state"` dijalankan: `service` → `_describe` dengan array `services`
4. Saran: `api`, `web`, `worker`, `db`

**Integrasi ke fpath:**

```zsh
# ~/.config/zsh/.zshrc
fpath=("$ZDOTDIR/functions" $fpath)

# Inisialisasi completion
autoload -Uz compinit
compinit

# Sekarang _nt-deploy akan otomatis di-load saat dibutuhkan
# (autoload -Uz _nt-deploy tidak perlu manual)
```

**Untuk 30 developer**, Anda bisa distribute `_nt-deploy` melalui:
- Repository dotfiles (via Stow/Git)
- `/etc/zsh/functions/` (system-wide, read-only)
- Plugin manager (jika tim menggunakan Oh My Zsh atau Antidote)

---

### Pertanyaan 4: Konfigurasi Modular dengan conf.d

**Tantangan:** Bangun struktur konfigurasi modular untuk tim. Requirement:
- (a) `00-base.zsh` — PATH, locale, umask
- (b) `10-security.zsh` — history policy, timeout
- (c) `20-tools.zsh` — tools internal (kubectl, aws, nt-cli)
- (d) `30-completion.zsh` — completion untuk tools internal
- (e) `40-prompt.zsh` — prompt standar (opsional)
- (f) `99-local.zsh` — override pribadi

Tulis setiap file dan mekanisme loading-nya.

**Jawaban:**

**Struktur Direktori:**

```
~/.config/zsh/
├── .zshenv
├── .zshrc
├── conf.d/
│   ├── 00-base.zsh
│   ├── 10-security.zsh
│   ├── 20-tools.zsh
│   ├── 30-completion.zsh
│   ├── 40-prompt.zsh
│   └── 99-local.zsh
└── functions/
    ├── _nt-deploy
    └── _nt-db
```

**`.zshrc` — Entry Point:**

```zsh
# ~/.config/zsh/.zshrc — Entry point konfigurasi

# ═══════════════════════════════════════════════════════════
# LOADING MODULAR
# ═══════════════════════════════════════════════════════════
# (N) = null_glob: jangan error jika direktori kosong
# Urutan numerik: 00, 10, 20, ... di-load secara alfabetis
if [[ -d "$ZDOTDIR/conf.d" ]]; then
    for conf in "$ZDOTDIR/conf.d"/*.zsh(N); do
        source "$conf"
    done
fi

# ═══════════════════════════════════════════════════════════
# LOAD LOCAL OVERRIDE (opsional)
# ═══════════════════════════════════════════════════════════
# File ini TIDAK di-track di Git — untuk preferensi pribadi
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
    source "$ZDOTDIR/local.zsh"
fi
```

**`00-base.zsh` — Fondasi:**

```zsh
# ~/.config/zsh/conf.d/00-base.zsh — Fondasi
# Tanggung jawab: PATH, locale, umask, editor

# ─── PATH (unique, no duplicates) ───
typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "/usr/local/bin"
    $path
)
export PATH

# ─── Locale ───
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# ─── Umask ───
umask 022

# ─── Editor ───
export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"
export PAGER="${PAGER:-less}"

# ─── Less ───
export LESS='-R -F -X -i -M'

# ─── History ───
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
```

**`10-security.zsh` — Keamanan:**

```zsh
# ~/.config/zsh/conf.d/10-security.zsh — Keamanan
# Tanggung jawab: history policy, timeout, alias aman

# ─── History options ───
setopt HIST_IGNORE_DUPS         # Jangan simpan duplikat berurutan
setopt HIST_IGNORE_SPACE        # Jangan simpan command diawali spasi
setopt HIST_VERIFY              # Tampilkan command sebelum eksekusi dari history
setopt SHARE_HISTORY            # Share history antar session
setopt EXTENDED_HISTORY         # Simpan timestamp
setopt INC_APPEND_HISTORY       # Tulis langsung ke file

# ─── Timeout ───
TMOUT=3600                      # Exit setelah 1 jam idle
setopt TMOUT

# ─── Alias aman ───
alias rm='rm -I --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

# ─── Path aman ───
# Tambahkan . di akhir PATH (untuk kompatibilitas)
# Tapi jangan tambahkan di awal (bahaya security)
```

**`20-tools.zsh` — Tools Internal:**

```zsh
# ~/.config/zsh/conf.d/20-tools.zsh — Tools internal Nusantara Tech

# ─── Kubernetes ───
if command -v kubectl &>/dev/null; then
    export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    
    # Context switching
    nt-k8s-context() {
        local ctx
        ctx=$(kubectl config get-contexts -o name | fzf --prompt="K8s context: ")
        [[ -n "$ctx" ]] && kubectl config use-context "$ctx"
    }
fi

# ─── AWS ───
if command -v aws &>/dev/null; then
    export AWS_PROFILE="${AWS_PROFILE:-default}"
    export AWS_REGION="${AWS_REGION:-ap-southeast-1}"
fi

# ─── Nusantara CLI ───
if command -v nt-cli &>/dev/null; then
    alias ntc='nt-cli'
fi

# ─── nt-deploy helper ───
nt-deploy-quick() {
    local env="${1:-staging}"
    nt-deploy "$env" --service api --version latest
}

# ─── Git helpers ───
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Hati-hati: alias `gs` bisa konflik dengan Ghostscript
# Untuk tim Nusantara Tech, kita definisikan `gs` = git status
```

**`30-completion.zsh` — Completion:**

```zsh
# ~/.config/zsh/conf.d/30-completion.zsh — Completion system

# ─── fpath ───
fpath=("$ZDOTDIR/functions" $fpath)

# ─── compinit ───
autoload -Uz compinit

# Cache completion dump (untuk performa)
if [[ -f "$ZDOTDIR/.zcompdump" ]]; then
    compinit -d "$ZDOTDIR/.zcompdump"
else
    compinit -d "$ZDOTDIR/.zcompdump"
fi

# ─── Konfigurasi completion ───
# Case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu selection
zstyle ':completion:*' menu select

# Colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f'

# Completion untuk sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin

# ─── Command-specific completion ───
# Pastikan _nt-deploy di-load
autoload -Uz _nt-deploy _nt-db

# Register completion untuk tools internal
compdef _nt-deploy nt-deploy
compdef _nt-db nt-db
```

**`40-prompt.zsh` — Prompt:**

```zsh
# ~/.config/zsh/conf.d/40-prompt.zsh — Prompt standar
# Opsional: developer bisa skip jika ingin prompt sendiri

# ─── Git info ───
autoload -Uz vcs_info
precmd() {
    vcs_info
    # Set judul terminal
    print -Pn "\e]0;%~\a"
}

zstyle ':vcs_info:git:*' formats ' %F{blue}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}(%b|%a)%f'

setopt PROMPT_SUBST

# ─── Prompt ───
# Format: [user@host] dir (branch) %
PS1='%F{green}%n@%m%f %F{cyan}%~%f${vcs_info_msg_0_} %(?.%F{green}❯%f.%F{red}❯%f) '

# Prompt untuk command yang di-continue
PS2='%F{yellow}❯%f '

# Prompt untuk quote
PS3='%F{cyan}?%f '
```

**`99-local.zsh` — Override Pribadi:**

```zsh
# ~/.config/zsh/conf.d/99-local.zsh — Override pribadi
# File ini di-load TERAKHIR, bisa menimpa semua konfigurasi sebelumnya
# Developer bisa mengubah file ini tanpa mempengaruhi tim
# (karena file ini ada di .gitignore)

# Contoh: override prompt
# PS1='%F{red}%n%f $ '

# Contoh: tambah PATH pribadi
# path=("$HOME/.cargo/bin" $path)

# Contoh: alias pribadi
# alias ll='ls -lah --color=auto'

# Contoh: load local override dari file lain
[[ -f "$HOME/.zshrc.personal" ]] && source "$HOME/.zshrc.personal"
```

**Penjelasan Mental — Konvensi Numerik:**

Prefix numerik (`00-`, `10-`, `20-`) bukan sekadar hiasan — ini **kontrak**:

| Range | Tujuan |
|---|---|
| `00-09` | Fondasi (PATH, locale, umask) |
| `10-19` | Keamanan (history, timeout, permissions) |
| `20-29` | Tools (CLI tools, environment spesifik) |
| `30-39` | Completion (compinit, zstyle) |
| `40-49` | UI (prompt, theme) |
| `90-99` | Override (local, testing) |

Dengan konvensi ini:
- **Tim tahu di mana meletakkan file baru** — apakah ini fondasi? Keamanan? Tools?
- **Urutan dijamin** — `00` selalu sebelum `10`, terlepas dari urutan pembuatan file
- **Celah angka** — Anda bisa menyisipkan `05-` di antara `00-` dan `10-` tanpa rename

**Mengapa File `.zshrc` Sangat Minimal?**

Perhatikan `.zshrc` hanya berisi **loop loading**. Mengapa?

Karena **separation of concerns**:
- `.zshrc` = infrastruktur (bagaimana file di-load)
- `conf.d/*.zsh` = konfigurasi (apa yang di-load)

Jika Anda ingin mengubah cara loading (misalnya menambahkan validasi), Anda hanya mengubah `.zshrc`. Jika Anda ingin mengubah konfigurasi (misalnya menambah PATH), Anda tambah file di `conf.d/`.

**Mengapa `99-local.zsh` tidak di-track di Git?**

Karena ini adalah **override pribadi**. Jika di-track:
- Setiap developer akan konflik saat push
- Developer tidak bisa customize tanpa mempengaruhi yang lain
- Sulit membedakan "konfigurasi tim" vs "konfigurasi pribadi"

Solusi: `.gitignore` file ini, dan beri contoh di `99-local.zsh.example`.

**`.gitignore`:**

```gitignore
# Ignore local overrides
conf.d/99-local.zsh

# Ignore completion dump
.zcompdump

# Ignore history
.zsh_history

# Ignore caches
.cache/
```

---

### Pertanyaan 5: Migrasi Konfigurasi yang Ada

**Tantangan:** Developer Anda memiliki konfigurasi yang tersebar. Buat script migrasi yang: (a) backup konfigurasi lama, (b) mendeteksi konfigurasi yang ada, (c) memindahkan file ke struktur baru, (d) melaporkan apa yang di-migrasi.

**Jawaban:**

```zsh
#!/bin/zsh
# migrate-zsh.zsh — Migrasi konfigurasi ke struktur Nusantara Tech

set -euo pipefail

readonly BACKUP_DIR="$HOME/.zsh-backup-$(date +%Y%m%d_%H%M%S)"
readonly NEW_CONFIG_DIR="$HOME/.config/zsh"

# ═══════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════
log() {
    local level="$1"; shift
    printf '[%s] %s\n' "$level" "$*"
}

# ═══════════════════════════════════════════════════════════
# STEP 1: BACKUP
# ═══════════════════════════════════════════════════════════
backup_existing() {
    log "INFO" "Membuat backup di: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    local files=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.zprofile"
        "$HOME/.zlogin"
        "$HOME/.zlogout"
    )
    
    local backed_up=0
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$BACKUP_DIR/"
            log "INFO" "  ✅ $file"
            (( ++backed_up ))
        fi
    done
    
    # Backup .oh-my-zsh jika ada (hanya config, bukan seluruh dir)
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        if [[ -f "$HOME/.oh-my-zsh/custom" ]]; then
            cp -r "$HOME/.oh-my-zsh/custom" "$BACKUP_DIR/oh-my-zsh-custom" 2>/dev/null || true
        fi
    fi
    
    log "INFO" "Total file di-backup: $backed_up"
}

# ═══════════════════════════════════════════════════════════
# STEP 2: DETEKSI KONFIGURASI
# ═══════════════════════════════════════════════════════════
detect_config() {
    log "INFO" "Mendeteksi konfigurasi yang ada..."
    
    # Deteksi plugin manager
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "INFO" "  Found: Oh My Zsh"
    fi
    if [[ -d "$HOME/.antidote" ]]; then
        log "INFO" "  Found: Antidote"
    fi
    if [[ -d "$HOME/.zinit" ]]; then
        log "INFO" "  Found: Zinit"
    fi
    
    # Deteksi konfigurasi khusus
    if [[ -f "$HOME/.zshrc" ]]; then
        local plugins=$(grep -E "^plugins=" "$HOME/.zshrc" 2>/dev/null || true)
        [[ -n "$plugins" ]] && log "INFO" "  $plugins"
        
        local theme=$(grep -E "^ZSH_THEME=" "$HOME/.zshrc" 2>/dev/null || true)
        [[ -n "$theme" ]] && log "INFO" "  $theme"
    fi
    
    # Deteksi aliases dan functions
    if [[ -f "$HOME/.zshrc" ]]; then
        local alias_count=$(grep -c "^alias " "$HOME/.zshrc" 2>/dev/null || echo 0)
        log "INFO" "  Aliases: $alias_count"
    fi
}

# ═══════════════════════════════════════════════════════════
# STEP 3: SETUP STRUKTUR BARU
# ═══════════════════════════════════════════════════════════
setup_new_structure() {
    log "INFO" "Membuat struktur baru di: $NEW_CONFIG_DIR"
    
    mkdir -p "$NEW_CONFIG_DIR/conf.d"
    mkdir -p "$NEW_CONFIG_DIR/functions"
    
    # Buat .zshenv (set ZDOTDIR)
    cat > "$NEW_CONFIG_DIR/.zshenv" <<'EOF'
# .zshenv — Environment untuk SEMUA shell
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Load conf.d untuk environment (hanya 00-base)
if [[ -d "$ZDOTDIR/conf.d" ]]; then
    for conf in "$ZDOTDIR/conf.d"/00-*.zsh(N); do
        source "$conf"
    done
fi
EOF
    
    # Buat .zshrc (loading loop)
    cat > "$NEW_CONFIG_DIR/.zshrc" <<'EOF'
# .zshrc — Konfigurasi untuk interactive shell

# Load semua file di conf.d
if [[ -d "$ZDOTDIR/conf.d" ]]; then
    for conf in "$ZDOTDIR/conf.d"/*.zsh(N); do
        source "$conf"
    done
fi

# Load local override
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
EOF
    
    # Buat .zprofile jika login shell
    cat > "$NEW_CONFIG_DIR/.zprofile" <<'EOF'
# .zprofile — Login shell
# (biasanya kosong, login shell jarang digunakan di desktop)
EOF
    
    # Buat 99-local.zsh.example
    cat > "$NEW_CONFIG_DIR/conf.d/99-local.zsh.example" <<'EOF'
# 99-local.zsh — Override pribadi (copy dari .example)
# File ini TIDAK di-track di Git.
# Contoh:
# PS1='%F{red}%n%f $ '
# alias ll='ls -lah'
EOF
    
    # Buat .gitignore
    cat > "$NEW_CONFIG_DIR/.gitignore" <<'EOF'
.zcompdump
.zsh_history
conf.d/99-local.zsh
local.zsh
.cache/
EOF
    
    log "INFO" "  ✅ Struktur dibuat"
}

# ═══════════════════════════════════════════════════════════
# STEP 4: MIGRASI KONTEN
# ═══════════════════════════════════════════════════════════
migrate_content() {
    log "INFO" "Migrasi konten..."
    
    if [[ ! -f "$HOME/.zshrc" ]]; then
        log "WARN" "  Tidak ada .zshrc lama, skip migrasi konten"
        return
    fi
    
    # Ekstrak aliases ke 50-aliases.zsh
    local alias_file="$NEW_CONFIG_DIR/conf.d/50-aliases.zsh"
    if grep -q "^alias " "$HOME/.zshrc" 2>/dev/null; then
        {
            echo "# 50-aliases.zsh — Aliases dari migrasi otomatis"
            echo "# Tanggal: $(date)"
            echo ""
            grep "^alias " "$HOME/.zshrc"
        } > "$alias_file"
        log "INFO" "  ✅ Aliases → $alias_file"
    fi
    
    # Ekstrak exports ke 15-env.zsh
    local env_file="$NEW_CONFIG_DIR/conf.d/15-env.zsh"
    if grep -qE "^export " "$HOME/.zshrc" 2>/dev/null; then
        {
            echo "# 15-env.zsh — Environment dari migrasi otomatis"
            echo "# Tanggal: $(date)"
            echo ""
            grep "^export " "$HOME/.zshrc"
        } > "$env_file"
        log "INFO" "  ✅ Exports → $env_file"
    fi
    
    # Simpan sisa .zshrc untuk review manual
    cp "$HOME/.zshrc" "$NEW_CONFIG_DIR/.zshrc.old"
    log "INFO" "  ⚠️  .zshrc lama disimpan di .zshrc.old untuk review manual"
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    log "INFO" "═══════════════════════════════════════════════"
    log "INFO" "  ZSH MIGRATION TOOL — Nusantara Tech"
    log "INFO" "═══════════════════════════════════════════════"
    
    backup_existing
    detect_config
    setup_new_structure
    migrate_content
    
    log "INFO" ""
    log "INFO" "═══════════════════════════════════════════════"
    log "INFO" "  MIGRASI SELESAI"
    log "INFO" "═══════════════════════════════════════════════"
    log "INFO" ""
    log "INFO" "Langkah selanjutnya:"
    log "INFO" "  1. Review $NEW_CONFIG_DIR/.zshrc.old"
    log "INFO" "  2. Pindahkan konfigurasi yang relevan ke conf.d/"
    log "INFO" "  3. Buka terminal baru dan test"
    log "INFO" "  4. Jika ada masalah, restore dari: $BACKUP_DIR"
    log "INFO" ""
}

main "$@"
```

**Penjelasan Mental — Migrasi sebagai "Operasi Berisiko":**

Migrasi konfigurasi adalah **operasi berisiko tinggi**:
- Jika gagal, developer kehilangan environment kerja
- Jika tidak di-backup, tidak bisa rollback
- Jika tidak di-test, bisa merusak produktivitas

**Prinsip migrasi yang baik:**

1. **Backup dulu, apapun yang terjadi.** `backup_existing()` adalah langkah pertama, tanpa kecuali.
2. **Deteksi, jangan asumsi.** `detect_config()` memeriksa apa yang ada sebelum bertindak.
3. **Buat struktur baru, jangan timpa.** `setup_new_structure()` membuat direktori baru.
4. **Migrasi bertahap, jangan paksa.** `migrate_content()` memindahkan apa yang bisa dipindahkan, sisanya untuk review manual.
5. **Beri jalan pulang.** Backup path diberikan di output akhir.
6. **Test sebelum deploy.** Script ini harus di-test di VM terlebih dahulu.

**Mengapa `.zshrc.old` tidak dihapus?**

Karena konfigurasi pribadi developer mungkin berisi hal-hal yang tidak bisa di-migrasi otomatis:
- Fungsi kompleks dengan logika khusus
- Plugin yang tidak standar
- Komentar dan catatan pribadi

Alih-alih mencoba "menebak" apa yang penting, script menyimpan file lama untuk review manual.

**Mengapa hanya migrasi `alias` dan `export`?**

Karena keduanya adalah **pola yang mudah dikenali**:
- `^alias ` — baris yang dimulai dengan `alias `
- `^export ` — baris yang dimulai dengan `export `

Pola lain (fungsi, loop, kondisional) membutuhkan analisis sintaksis yang lebih kompleks dan berisiko salah.

---

### Pertanyaan 6: Distribution dan Onboarding

**Tantangan:** Bangun mekanisme distribution untuk 30 developer. Requirement:
- (a) Repository Git tunggal
- (b) Setup script yang idempoten
- (c) Bisa di-update dengan `git pull`
- (d) Verifikasi setelah setup

**Jawaban:**

**Struktur Repository:**

```
nusantara-dotfiles/
├── README.md
├── LICENSE
├── install.sh              # Script instalasi
├── verify.sh               # Script verifikasi
├── zsh/                    # Package untuk GNU Stow
│   ├── .zshenv
│   ├── .zshrc
│   └── .config/zsh/
│       ├── conf.d/
│       │   ├── 00-base.zsh
│       │   ├── 10-security.zsh
│       │   ├── 20-tools.zsh
│       │   ├── 30-completion.zsh
│       │   └── 40-prompt.zsh
│       └── functions/
│           ├── _nt-deploy
│           └── _nt-db
└── docs/
    ├── onboarding.md
    ├── customization.md
    └── troubleshooting.md
```

**`install.sh` — Script Instalasi:**

```zsh
#!/bin/zsh
# install.sh — Instalasi dotfiles Nusantara Tech

set -euo pipefail

readonly REPO_URL="git@git.nusantara.tech:dotfiles/nusantara-dotfiles.git"
readonly INSTALL_DIR="$HOME/.nusantara-dotfiles"
readonly ZSH_CONFIG="$HOME/.config/zsh"

# ═══════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════
log() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

# ═══════════════════════════════════════════════════════════
# PRASYARAT
# ═══════════════════════════════════════════════════════════
check_prerequisites() {
    log "Memeriksa prasyarat..."
    
    local missing=()
    
    command -v git &>/dev/null || missing+=(git)
    command -v zsh &>/dev/null || missing+=(zsh)
    command -v stow &>/dev/null || missing+=(stow)
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Tool berikut tidak ditemukan: ${missing[@]}"
        error "Install terlebih dahulu:"
        error "  macOS:  brew install ${missing[@]}"
        error "  Ubuntu: sudo apt install ${missing[@]}"
        return 1
    fi
    
    log "✅ Semua prasyarat terpenuhi"
}

# ═══════════════════════════════════════════════════════════
# CLONE / UPDATE REPOSITORY
# ═══════════════════════════════════════════════════════════
clone_or_update() {
    if [[ -d "$INSTALL_DIR/.git" ]]; then
        log "Repository sudah ada, melakukan update..."
        git -C "$INSTALL_DIR" pull --rebase
    else
        log "Cloning repository ke $INSTALL_DIR..."
        git clone "$REPO_URL" "$INSTALL_DIR"
    fi
}

# ═══════════════════════════════════════════════════════════
# BACKUP KONFIGURASI LAMA
# ═══════════════════════════════════════════════════════════
backup_existing() {
    log "Backup konfigurasi lama..."
    
    local backup_dir="$HOME/.zsh-backup-$(date +%Y%m%d_%H%M%S)"
    local found=0
    
    for f in "$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile"; do
        if [[ -f "$f" && ! -L "$f" ]]; then
            mkdir -p "$backup_dir"
            cp "$f" "$backup_dir/"
            (( ++found ))
        fi
    done
    
    if [[ $found -gt 0 ]]; then
        log "  ✅ $found file di-backup ke: $backup_dir"
    else
        log "  ℹ️  Tidak ada file lama yang perlu di-backup"
    fi
}

# ═══════════════════════════════════════════════════════════
# STOW KONFIGURASI
# ═══════════════════════════════════════════════════════════
stow_config() {
    log "Stow konfigurasi..."
    
    cd "$INSTALL_DIR"
    
    # Stow package zsh ke home
    stow -t "$HOME" zsh
    log "  ✅ Package zsh di-stow ke $HOME"
    
    cd - >/dev/null
}

# ═══════════════════════════════════════════════════════════
# VERIFIKASI
# ═══════════════════════════════════════════════════════════
verify_installation() {
    log "Verifikasi instalasi..."
    
    # Cek symlink
    if [[ ! -L "$HOME/.zshrc" ]]; then
        error "  ❌ $HOME/.zshrc bukan symlink"
        return 1
    fi
    
    # Cek shell startup
    if zsh -n -c 'source ~/.zshrc' 2>/dev/null; then
        log "  ✅ .zshrc valid"
    else
        error "  ❌ .zshrc memiliki error"
        return 1
    fi
    
    # Cek ZDOTDIR
    if zsh -i -c 'echo $ZDOTDIR' | grep -q '.config/zsh'; then
        log "  ✅ ZDOTDIR ter-set dengan benar"
    else
        warn "  ⚠️  ZDOTDIR mungkin tidak ter-set"
    fi
    
    log "✅ Instalasi berhasil!"
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║  Nusantara Tech — Zsh Configuration Setup   ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    check_prerequisites
    clone_or_update
    backup_existing
    stow_config
    verify_installation
    
    echo ""
    log "🎉 Selesai! Buka terminal baru untuk memulai."
    log "📖 Dokumentasi: $INSTALL_DIR/docs/onboarding.md"
    log "🐛 Troubleshooting: $INSTALL_DIR/docs/troubleshooting.md"
}

main "$@"
```

**`verify.sh` — Script Verifikasi:**

```zsh
#!/bin/zsh
# verify.sh — Verifikasi konfigurasi Zsh

set -euo pipefail

PASS=0
FAIL=0

check() {
    local description="$1"
    local command="$2"
    
    if eval "$command" &>/dev/null; then
        printf '  ✅ %s\n' "$description"
        (( ++PASS ))
    else
        printf '  ❌ %s\n' "$description"
        (( ++FAIL ))
    fi
}

echo "╔══════════════════════════════════════════════╗"
echo "║  Verifikasi Konfigurasi Zsh                  ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

echo "📁 File & Direktori:"
check ".zshenv ada" "[[ -f \$HOME/.config/zsh/.zshenv ]]"
check ".zshrc ada" "[[ -f \$HOME/.config/zsh/.zshrc ]]"
check "conf.d ada" "[[ -d \$HOME/.config/zsh/conf.d ]]"
check "functions ada" "[[ -d \$HOME/.config/zsh/functions ]]"

echo ""
echo "🔧 Shell Configuration:"
check "ZDOTDIR ter-set" "zsh -i -c '[[ -n \$ZDOTDIR ]]'"
check "PATH tidak duplikat" "zsh -i -c '[[ \$(echo \$PATH | tr : \\n | sort | uniq -d | wc -l) -eq 0 ]]'"
check "compinit berjalan" "zsh -i -c '(( \$+functions[compinit] ))'"

echo ""
echo "🛠️  Tools Internal:"
check "nt-deploy tersedia" "command -v nt-deploy"
check "completion nt-deploy" "zsh -i -c '(( \$+functions[_nt-deploy] ))'"

echo ""
echo "⏱️  Performance:"
START=$(date +%s%N)
zsh -i -c exit 2>/dev/null
END=$(date +%s%N)
DURATION=$(( (END - START) / 1000000 ))
if [[ $DURATION -lt 200 ]]; then
    printf '  ✅ Startup: %dms (cepat)\n' "$DURATION"
    (( ++PASS ))
elif [[ $DURATION -lt 500 ]]; then
    printf '  ⚠️  Startup: %dms (cukup)\n' "$DURATION"
else
    printf '  ❌ Startup: %dms (lambat)\n' "$DURATION"
    (( ++FAIL ))
fi

echo ""
echo "════════════════════════════════════════════════"
printf '  PASS: %d | FAIL: %d\n' "$PASS" "$FAIL"
echo "════════════════════════════════════════════════"

[[ $FAIL -eq 0 ]]
```

**`docs/onboarding.md` — Dokumentasi:**

```markdown
# Onboarding — Nusantara Tech Zsh

## Quick Start

```bash
curl -fsSL https://git.nusantara.tech/dotfiles/install.sh | zsh
```

## Apa yang terjadi?

Script `install.sh`:
1. Memeriksa prasyarat (git, zsh, stow)
2. Clone repository ke `~/.nusantara-dotfiles`
3. Backup konfigurasi lama
4. Stow konfigurasi ke home directory
5. Verifikasi instalasi

## Setelah Instalasi

1. Buka terminal baru
2. Jalankan `verify.sh` untuk memastikan semuanya OK
3. Baca `customization.md` untuk kustomisasi
4. Jika ada masalah, baca `troubleshooting.md`

## Struktur Konfigurasi

```
~/.config/zsh/
├── .zshenv
├── .zshrc
├── conf.d/
│   ├── 00-base.zsh          # Fondasi
│   ├── 10-security.zsh      # Keamanan
│   ├── 20-tools.zsh         # Tools internal
│   ├── 30-completion.zsh    # Completion
│   ├── 40-prompt.zsh        # Prompt
│   └── 99-local.zsh         # Override pribadi (gitignored)
└── functions/
    ├── _nt-deploy
    └── _nt-db
```

## Kustomisasi

### Menambah Alias Pribadi

Edit `~/.config/zsh/conf.d/99-local.zsh`:

```zsh
alias myalias='command here'
```

### Mengganti Prompt

Edit `99-local.zsh`:

```zsh
PS1='%F{red}%n%f $ '
```

### Menambah PATH

Edit `99-local.zsh`:

```zsh
path=("$HOME/.cargo/bin" $path)
```

## Update

```bash
cd ~/.nusantara-dotfiles
git pull
# Jika ada file baru, restow:
stow -R -t ~ zsh
```

## Troubleshooting

Lihat `troubleshooting.md` atau hubungi tim IT.
```

**Penjelasan Mental — Distribution sebagai "Product Launch":**

Distribusi konfigurasi untuk 30 developer memiliki kemiripan dengan meluncurkan produk:

1. **Installation experience** — Harus mudah. Satu perintah.
2. **Documentation** — Harus ada. Developer baru tidak akan menebak.
3. **Verification** — Harus jelas. Apakah instalasi berhasil?
4. **Rollback** — Harus ada. Jika gagal, bagaimana kembali?
5. **Update mechanism** — Harus jelas. Bagaimana mendapatkan perubahan?

**Mengapa `install.sh` idempoten?**

Script ini bisa dijalankan berkali-kali dengan hasil sama:
- Jika repository sudah ada, `git pull` bukan clone ulang
- Jika konfigurasi sudah di-stow, Stow akan skip (atau `-R` untuk refresh)
- Backup hanya dibuat jika ada file lama

**Mengapa `verify.sh` dipisah?**

Karena verifikasi adalah **operasi yang berbeda** dari instalasi:
- Instalasi: mengubah sistem
- Verifikasi: memeriksa sistem (read-only)

Dengan memisahkan, Anda bisa menjalankan verifikasi kapan pun tanpa mengubah apa pun.

**Mengapa dokumentasi dalam Markdown?**

Karena:
- **Universal** — bisa dibaca di GitHub, VS Code, atau viewer apa pun
- **Version-controlled** — perubahan dokumentasi di-track
- **Searchable** — `grep` bisa mencari di Markdown
- **Bisa di-render** — banyak tools yang bisa mengkonversi ke HTML

---

### Pertanyaan 7: Troubleshooting Umum

**Tantangan:** Developer Anda melaporkan beberapa masalah setelah migrasi. Buat panduan troubleshooting untuk 5 masalah paling umum: (a) shell startup lambat, (b) completion tidak muncul, (c) `nt-deploy` tidak ditemukan, (d) prompt berantakan, (e) konflik alias.

**Jawaban:**

**`docs/troubleshooting.md`:**

```markdown
# Troubleshooting — Nusantara Tech Zsh

## 1. Shell Startup Lambat (> 500ms)

**Gejala:** Terminal butuh > 0.5 detik untuk membuka.

**Diagnosis:**

```zsh
# Ukur startup time
time zsh -i -c exit

# Profiling
zmodload zsh/zprof
# ... konfigurasi ...
zprof | head -20
```

**Penyebab Umum:**

| Penyebab | Solusi |
|---|---|
| `compinit` tanpa cache | Pastikan `compinit -d "$ZDOTDIR/.zcompdump"` |
| Plugin berat (nvm, pyenv) | Lazy load dengan `zsh-defer` atau function wrapper |
| Terlalu banyak plugin | Audit: `echo $plugins` |
| Sourcing file besar | Gunakan `zcompile` |

**Solusi Cepat:**

```zsh
# Compile .zshrc dan conf.d
for f in ~/.config/zsh/.zshrc ~/.config/zsh/conf.d/*.zsh; do
    zcompile "$f"
done
```

## 2. Completion Tidak Muncul

**Gejala:** Tekan Tab, tidak ada saran.

**Diagnosis:**

```zsh
# Cek apakah compinit sudah jalan
whence -w compinit
# Output: compinit: function

# Cek fpath
echo $fpath | tr ' ' '\n' | head -10

# Cek apakah completion function di-load
whence -w _nt-deploy
```

**Penyebab Umum:**

| Penyebab | Solusi |
|---|---|
| `compinit` tidak dipanggil | Tambahkan `autoload -Uz compinit && compinit` |
| `fpath` tidak include direktori functions | `fpath=("$ZDOTDIR/functions" $fpath)` |
| Completion function tidak autoload | `autoload -Uz _nt-deploy` |
| Cache rusak | `rm ~/.config/zsh/.zcompdump` lalu buka terminal baru |

**Solusi Cepat:**

```zsh
# Rebuild completion cache
rm -f ~/.config/zsh/.zcompdump
exec zsh
```

## 3. `nt-deploy` Tidak Ditemukan

**Gejala:** `command not found: nt-deploy`

**Diagnosis:**

```zsh
# Cek PATH
echo $PATH | tr ':' '\n' | grep -i nusantara

# Cek apakah file ada
ls -la /usr/local/bin/nt-*
ls -la ~/.local/bin/nt-*
```

**Solusi:**

1. Pastikan `nt-cli` terinstall
2. Pastikan PATH include direktori tools:
```zsh
# Di 99-local.zsh:
path=("/opt/nusantara/bin" $path)
```
3. Jika manual, install dari repository internal:
```bash
git clone git@git.nusantara.tech:tools/nt-cli.git
cd nt-cli
./install.sh
```

## 4. Prompt Berantakan

**Gejala:** Prompt menampilkan karakter aneh (`%F{green}`, `\u`, dll.)

**Diagnosis:**

```zsh
# Cek PS1
echo $PS1

# Cek apakah PROMPT_SUBST aktif
setopt | grep prompt_subst
```

**Penyebab:**

| Penyebab | Solusi |
|---|---|
| `PROMPT_SUBST` tidak aktif | `setopt PROMPT_SUBST` |
| Terminal tidak support warna | Ganti ke `PS1='$ '` untuk test |
| Konflik dengan tema | Comment out `40-prompt.zsh` |
| Encoding terminal salah | Set `LANG=en_US.UTF-8` |

**Solusi Cepat:**

```zsh
# Sementara: prompt minimal
PS1='%n@%m:%~%# '

# Cek apakah masalah di 40-prompt.zsh
mv ~/.config/zsh/conf.d/40-prompt.zsh ~/.config/zsh/conf.d/40-prompt.zsh.disabled
exec zsh
```

## 5. Konflik Alias

**Gejala:** Alias yang Anda definisikan tidak bekerja, atau bekerja berbeda dari yang diharapkan.

**Diagnosis:**

```zsh
# Cek alias
alias gs

# Cari definisi alias
grep -rn "alias gs" ~/.config/zsh/

# Cek urutan loading
zsh -xvs 2>&1 | grep "alias gs"
```

**Penyebab:**

Alias didefinisikan **dua kali**:
- Di `20-tools.zsh` (tim) dan `99-local.zsh` (pribadi)
- Yang **terakhir** di-load menang

**Solusi:**

1. **Jangan definisikan alias di `99-local.zsh`** jika sudah ada di `conf.d/`
2. **Gunakan `unalias`** jika perlu override:
```zsh
# Di 99-local.zsh:
unalias gs 2>/dev/null
alias gs='git stash'
```

3. **Gunakan fungsi**, bukan alias:
```zsh
# Fungsi bisa memanggil command yang sama
gs() {
    if [[ $# -eq 0 ]]; then
        git status
    else
        git stash "$@"
    fi
}
```

**Cek Konflik:**

```zsh
# Script untuk mendeteksi alias duplikat
grep -h "^alias " ~/.config/zsh/conf.d/*.zsh | \
    awk '{print $2}' | \
    sort | uniq -d
```

Jika output ada, ada alias duplikat.
```

**Penjelasan Mental — Troubleshooting sebagai "Debugging Sistematis":**

Troubleshooting yang baik mengikuti **metode ilmiah**:

1. **Observasi** — Apa gejalanya? Kapan terjadi?
2. **Hipotesis** — Apa penyebab yang mungkin?
3. **Eksperimen** — Test hipotesis dengan diagnosis
4. **Kesimpulan** — Solusi yang terverifikasi
5. **Dokumentasi** — Catat untuk masa depan

**Mengapa dokumentasi troubleshooting penting?**

- **Scalability** — 30 developer tidak bisa dijawab satu per satu
- **Empowerment** — Developer bisa solve masalah sendiri
- **Knowledge base** — Masalah baru bisa ditambahkan
- **Onboarding** — Developer baru belajar dari pengalaman orang lain

**Pola diagnosis yang umum:**

| Gejala | Pertanyaan Diagnosis |
|---|---|
| "Tidak bekerja" | Apa yang seharusnya terjadi? Apa yang terjadi? |
| "Lambat" | Berapa lama? Kapan mulai lambat? |
| "Error" | Pesan error apa? Kapan muncul? |
| "Berbeda" | Berbeda dari apa? Sejak kapan? |

---

### Pertanyaan 8: Evaluasi dan Iterasi

**Tantangan:** Setelah 1 bulan, lakukan evaluasi sistem. Buat script yang: (a) mengumpulkan feedback dari developer, (b) menganalisis pola masalah, (c) menghasilkan laporan untuk perbaikan.

**Jawaban:**

```zsh
#!/bin/zsh
# evaluate.zsh — Evaluasi sistem konfigurasi

set -euo pipefail

readonly REPORT="$HOME/zsh-evaluation-$(date +%Y%m%d).md"

# ═══════════════════════════════════════════════════════════
# KUMPULKAN DATA
# ═══════════════════════════════════════════════════════════

# 1. Startup time
measure_startup() {
    local times=()
    for i in {1..5}; do
        local start=$(date +%s%N)
        zsh -i -c exit 2>/dev/null
        local end=$(date +%s%N)
        times+=($(( (end - start) / 1000000 )))
    done
    # Rata-rata
    local sum=0
    for t in "${times[@]}"; do (( sum += t )); done
    echo $(( sum / ${#times[@]} ))
}

# 2. Jumlah file konfigurasi
count_config_files() {
    find "$ZDOTDIR/conf.d" -name "*.zsh" 2>/dev/null | wc -l | tr -d ' '
}

# 3. Jumlah plugin
count_plugins() {
    # Deteksi dari berbagai plugin manager
    local count=0
    [[ -n "${plugins:-}" ]] && count=${#plugins[@]}
    echo "$count"
}

# 4. Frekuensi error di log
count_errors() {
    if [[ -f "$ZDOTDIR/.zsh_errors.log" ]]; then
        wc -l < "$ZDOTDIR/.zsh_errors.log" | tr -d ' '
    else
        echo "0"
    fi
}

# 5. Tools yang terinstall
check_tools() {
    local tools=(kubectl aws terraform docker git fzf rg fd bat)
    local found=()
    local missing=()
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &>/dev/null; then
            found+=("$tool")
        else
            missing+=("$tool")
        fi
    done
    
    echo "Found: ${#found[@]} | Missing: ${#missing[@]}"
    [[ ${#missing[@]} -gt 0 ]] && echo "Missing: ${missing[@]}"
}

# ═══════════════════════════════════════════════════════════
# GENERATE LAPORAN
# ═══════════════════════════════════════════════════════════
{
    echo "# Evaluasi Konfigurasi Zsh — Nusantara Tech"
    echo ""
    echo "**Tanggal:** $(date '+%Y-%m-%d %H:%M')"
    echo "**User:** $(whoami)"
    echo "**Host:** $(hostname)"
    echo ""
    echo "## Metrik"
    echo ""
    echo "| Metrik | Nilai | Status |"
    echo "|--------|-------|--------|"
    
    STARTUP=$(measure_startup)
    if [[ $STARTUP -lt 200 ]]; then
        STATUS="✅"
    elif [[ $STARTUP -lt 500 ]]; then
        STATUS="⚠️"
    else
        STATUS="❌"
    fi
    echo "| Startup time | ${STARTUP}ms | $STATUS |"
    
    FILES=$(count_config_files)
    echo "| Config files | $FILES | ℹ️ |"
    
    PLUGINS=$(count_plugins)
    echo "| Plugins | $PLUGINS | ℹ️ |"
    
    ERRORS=$(count_errors)
    if [[ $ERRORS -eq 0 ]]; then
        STATUS="✅"
    else
        STATUS="⚠️"
    fi
    echo "| Errors in log | $ERRORS | $STATUS |"
    
    echo ""
    echo "## Tools"
    echo ""
    echo '```'
    check_tools
    echo '```'
    
    echo ""
    echo "## Rekomendasi"
    echo ""
    
    if [[ $STARTUP -gt 500 ]]; then
        echo "- ⚠️ Startup time > 500ms — pertimbangkan untuk profiling dengan \`zprof\`"
    fi
    
    if [[ $FILES -gt 20 ]]; then
        echo "- ⚠️ Terlalu banyak file konfigurasi ($FILES) — audit dan merge"
    fi
    
    if [[ $ERRORS -gt 0 ]]; then
        echo "- ⚠️ Ada $ERRORS error di log — periksa \`$ZDOTDIR/.zsh_errors.log\`"
    fi
    
    if [[ $STARTUP -lt 200 && $ERRORS -eq 0 ]]; then
        echo "- ✅ Sistem berjalan dengan baik"
    fi
    
    echo ""
    echo "## Pertanyaan untuk Developer"
    echo ""
    echo "1. Apakah ada alias/fungsi yang sering Anda gunakan tapi belum ada?"
    echo "2. Apakah ada konfigurasi yang mengganggu workflow Anda?"
    echo "3. Apakah ada tools internal yang belum terintegrasi?"
    echo "4. Saran untuk perbaikan?"
    
} > "$REPORT"

echo "✅ Laporan: $REPORT"
echo ""
cat "$REPORT"
```

**Penjelasan Mental — Evaluasi sebagai "Feedback Loop":**

Sistem konfigurasi bukan produk sekali jadi. Ia memerlukan **iterasi**:

```
Build → Deploy → Observe → Learn → Improve → Build (lagi)
```

**Metrik yang Diukur:**

| Metrik | Mengapa Penting |
|---|---|
| Startup time | Produktivitas developer |
| Jumlah file config | Kompleksitas maintenance |
| Jumlah plugin | Potensi konflik, performa |
| Errors in log | Kesehatan sistem |
| Tools availability | Kesesuaian dengan kebutuhan |

**Bagaimana Menggunakan Laporan:**

1. **Kumpulkan laporan dari 30 developer**
2. **Agregasi data** — cari pola
3. **Prioritas masalah** — yang paling sering muncul
4. **Rencanakan perbaikan** — sprint berikutnya
5. **Implementasi dan deploy** — update konfigurasi
6. **Ukur lagi** — apakah membaik?

**Prinsip "Measure, Don't Guess":**

Jangan berasumsi "startup lambat" tanpa data. Jangan berasumsi "developer tidak suka prompt" tanpa feedback. **Ukur, kumpulkan data, baru bertindak.**

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Diagram Arsitektur Konfigurasi** — Diagram pohon yang menunjukkan hierarki: `.zshrc` → `conf.d/00-*` → `10-*` → `20-*` → `...` → `99-local`. Tandai mana yang "team-managed" vs "user-managed".
>
> 2. **Alur Startup Shell** — Flowchart yang menunjukkan urutan: `.zshenv` → `.zprofile` → `.zshrc` → `conf.d/*` → `.zlogin`. Tandai file mana yang di-load untuk login vs interactive shell.
>
> 3. **Diagram Completion System** — Diagram yang menunjukkan: user menekan Tab → `compinit` → `_arguments` → `_describe` → suggestion. Tandai peran `fpath` dan `#compdef`.
>
> 4. **Tabel Glob Qualifier** — Tabel referensi dengan kolom: Qualifier, Arti, Contoh, Hasil. Kelompokkan berdasarkan kategori (tipe, permission, waktu, ukuran).
>
> 5. **Peta Migrasi** — Diagram before/after yang menunjukkan konfigurasi lama (tersebar) → konfigurasi baru (terstruktur). Gunakan panah untuk menunjukkan migrasi.
>
> 6. **Timeline Onboarding** — Timeline horizontal: `clone` (1 menit) → `install` (2 menit) → `verify` (30 detik) → `siap` (total < 5 menit).

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.1 (Fondasi)** | Variabel dan quoting adalah fondasi untuk konfigurasi |
| **7.2 (Scripting)** | Fungsi, error handling, dan trap digunakan di `install.sh` dan `verify.sh` |
| **7.4 (Performa & Keamanan)** | Completion system dan konfigurasi modular akan dioptimasi di sana |
| **7.5 (Testing)** | Script migrasi dan verifikasi akan di-test dengan framework |
| **7.6 (Expert)** | Sistem konfigurasi ini akan menjadi baseline untuk deployment enterprise |
| **Fase 3 (Kurikulum)** | Modul ini adalah aplikasi langsung dari: globbing, completion, konfigurasi |

---

## 9. Sumber Referensi Lengkap

- **Zsh Manual: Filename Generation (Globbing)** — https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation
- **Zsh Manual: Glob Qualifiers** — https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
- **Zsh Manual: Completion System** — https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- **Zsh Manual: Completion Widgets** — https://zsh.sourceforge.io/Doc/Release/Completion-Widgets.html
- **Zsh Manual: Files (Startup)** — https://zsh.sourceforge.io/Doc/Release/Files.html
- **Zsh Manual: Options** — https://zsh.sourceforge.io/Doc/Release/Options.html
- **zsh-completions (GitHub)** — https://github.com/zsh-users/zsh-completions
- **GNU Stow Manual** — https://www.gnu.org/software/stow/manual/
- **dotfiles.github.io** — https://dotfiles.github.io/
- **XDG Base Directory Spec** — https://specifications.freedesktop.org/basedir-spec/latest/
- **Zsh Completion Guide** — https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide

---

## 10. Tips dan Praktik Terbaik

1. **Konvensi numerik `conf.d/` wajib.** `00-`, `10-`, `20-` — jangan campur dengan nama non-numerik.
2. **Satu file, satu tanggung jawab.** `00-base.zsh` hanya fondasi, bukan fondasi + tools.
3. **Jangan hardcode path.** Gunakan `$ZDOTDIR` untuk portabilitas.
4. **Selalu sediakan `99-local.zsh.example`.** Developer baru butuh contoh.
5. **Gunakan `(N)` di semua glob loop.** Null glob mencegah error.
6. **Cache completion dump.** `compinit -d "$ZDOTDIR/.zcompdump"` — jangan rebuild setiap startup.
7. **Test completion dengan `zsh -f`.** Fast mode (no rcs) memastikan completion bekerja tanpa konfigurasi.
8. **Dokumentasi harus di-version-control.** `docs/` di repository, bukan di wiki terpisah.
9. **Verifikasi setelah instalasi.** Jangan asumsikan berhasil — cek dengan `verify.sh`.
10. **Backup sebelum migrasi.** Apapun yang terjadi, developer harus bisa rollback.
11. **Idempoten di `install.sh`.** Bisa dijalankan berkali-kali tanpa efek samping.
12. **Gunakan `stow -R` untuk refresh.** Setelah `git pull`, refresh symlink.
13. **Jangan paksa developer mengubah preferensi.** Hormati `99-local.zsh`.
14. **Ukur, jangan menebak.** Gunakan `time` dan `zprof` untuk performa.
15. **Review konfigurasi berkala.** Setiap quarter, audit dan bersihkan.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `compinit` tanpa `-d` | Startup lambat, rebuild setiap kali | `compinit -d "$ZDOTDIR/.zcompdump"` |
| `conf.d` tanpa `(N)` | Error jika direktori kosong | `for f in .../*.zsh(N)` |
| Completion function tidak di-fpath | `_nt-deploy` tidak ditemukan | `fpath=("$ZDOTDIR/functions" $fpath)` |
| Alias duplikat | Alias tidak bekerja seperti yang diharapkan | Audit dengan `grep -h "^alias "` |
| `ZDOTDIR` di `.zshrc` | Shell tidak membaca `.zshenv` baru | Set di `.zshenv` atau `/etc/zsh/zshenv` |
| `install.sh` tidak idempoten | Error saat dijalankan dua kali | Cek kondisi sebelum aksi |
| Migrasi tanpa backup | Developer kehilangan konfigurasi | Selalu backup sebelum migrasi |
| Lupa `.gitignore` | `99-local.zsh` ter-commit | Tambahkan ke `.gitignore` |
| Prompt error karena `PROMPT_SUBST` | Escape tidak diproses | `setopt PROMPT_SUBST` |
| Konflik `stow` | File sudah ada (bukan symlink) | Backup dulu atau `stow --adopt` |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.3, Anda seharusnya mengembangkan **mental model baru**:

1. **Konfigurasi adalah produk.** Ia memiliki user, requirement, version, dan deployment.
2. **Modularitas adalah kunci skalabilitas.** `conf.d/` dengan konvensi numerik memungkinkan 30+ developer bekerja tanpa konflik.
3. **Layer adalah kontrak.** Baseline (00-19) wajib, team (20-89) opsional, personal (90-99) bebas.
4. **Glob qualifier adalah query language.** `*(om[1,5])` jauh lebih expressive dari `find | sort | head`.
5. **Completion adalah UX.** Completion yang baik membuat tools terasa "native".
6. **Migrasi memerlukan empati.** Developer punya konfigurasi yang mereka cintai — jangan paksa.
7. **Distribusi adalah bagian dari produk.** Install yang mudah = adopsi yang tinggi.
8. **Evaluasi adalah siklus.** Ukur, pelajari, perbaiki — terus menerus.

**Pertanyaan reflektif untuk diri sendiri:**
- Bisakah saya merancang struktur `conf.d/` untuk tim baru tanpa melihat contoh?
- Apakah saya tahu perbedaan `*(.)`, `*(/)`, `*(x)`, dan `*(@)`?
- Bisakah saya menulis completion function untuk tools internal?
- Apakah saya tahu mengapa `compinit -d` lebih baik dari `compinit`?
- Apakah saya tahu bagaimana memigrasi konfigurasi tanpa kehilangan data?

Jika jawabannya "belum", **ulangi modul ini** — konfigurasi adalah fondasi untuk semua yang berikutnya.

### Checklist Verifikasi

Sebelum melanjutkan ke Modul 7.4, pastikan Anda dapat:

- [ ] Menggunakan glob qualifier untuk filter file berdasarkan tipe, permission, waktu, ukuran
- [ ] Menggabungkan multiple glob qualifier dalam satu pattern
- [ ] Menjelaskan perbedaan `*(.)`, `*(/)`, `*(x)`, `*(@)`, `*(N)`
- [ ] Menulis completion function sederhana dengan `_arguments` dan `_describe`
- [ ] Mengkonfigurasi `zstyle` untuk completion
- [ ] Merancang struktur `conf.d/` yang skalabel
- [ ] Menulis file konfigurasi modular dengan tanggung jawab tunggal
- [ ] Membuat script migrasi yang idempoten
- [ ] Membangun `install.sh` dan `verify.sh` untuk distribusi
- [ ] Mendokumentasikan konfigurasi untuk tim
- [ ] Melakukan evaluasi berkala dengan metrik

---

## ✅ MODUL 7.3 SELESAI

**Ringkasan yang telah Anda kuasai:**
- Glob qualifier lanjutan untuk query file system
- Completion system dengan `compinit`, `compdef`, `zstyle`
- Menulis completion function dengan `_arguments` dan `_describe`
- Struktur konfigurasi modular dengan `conf.d/`
- Migrasi konfigurasi dengan backup dan deteksi
- Distribution dengan `install.sh` dan `verify.sh`
- Dokumentasi troubleshooting untuk tim
- Evaluasi sistem dengan metrik

**Yang akan datang di Modul 7.4:**
Anda akan membangun **audit dan optimasi lingkungan shell tim** — menggunakan teknik profiling, lazy loading, keamanan, dan audit kepatuhan. Ini adalah langkah menuju "shell engineer" — dari perancang menjadi pengoptimal.

---

# MODUL 7.4: AUDIT & OPTIMASI LINGKUNGAN SHELL TIM

> **Mewakili:** Fase 4 — Framework & Plugin Manager, Prompt Kustomisasi, Optimasi Performa, Keamanan Scripting
> **Level:** Menengah–Mahir | **Durasi:** 10–12 jam | **Tipe:** Proyek Simulasi

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model "performance & security as first-class"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Toolkit profiling, keamanan, plugin
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan nyata
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Tiga bulan setelah migrasi konfigurasi.** Sistem `conf.d/` sudah berjalan di 30 developer. Tetapi laporan mulai masuk:

> **VP Engineering:** *"Saya dengar ada developer yang komplain terminal-nya lambat. Ada juga yang bilang prompt-nya error. Dan yang paling penting: audit keamanan internal menemukan beberapa masalah. Kita perlu:*
> - *Profiling performa shell untuk semua developer*
> - *Identifikasi plugin yang memperlambat startup*
> - *Audit keamanan: history policy, secrets management, permission file*
> - *Standarisasi prompt tanpa mengorbankan performa*
> - *Dokumentasi best practices untuk tim*
> - *Setup monitoring berkelanjutan*
>
> *Kita punya deadline 2 minggu sebelum audit compliance. Ini prioritas."*

**Masalah spesifik yang dilaporkan:**
- 8 dari 30 developer startup >1 detik
- 3 developer mengalami konflik plugin (autosuggestions vs syntax-highlighting)
- 5 developer menyimpan API keys di `.zshrc` (temuan audit!)
- 12 developer menggunakan plugin manager berbeda (Oh My Zsh, Antidote, Zinit, vanilla)
- Ada 2 laporan di mana command history berisi secrets (accidental paste)

Anda memiliki:
- Akses ke semua mesin developer (via SSH)
- Repository dotfiles yang sudah terstruktur
- Wewenang untuk mengubah konfigurasi enterprise
- Deadline 2 minggu

**Tantangan:** Bangun sistem **audit, optimasi, dan keamanan** yang komprehensif.

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **titik kritis** dalam perjalanan Anda: dari **pengguna** menjadi **pengoptimal**. Sebelum ini, Anda membangun konfigurasi yang berfungsi. Sekarang, Anda harus memastikan konfigurasi itu:

1. **Cepat** — startup <200ms, tidak mengganggu produktivitas
2. **Aman** — tidak menyimpan secrets, tidak rentan code injection
3. **Konsisten** — prompt dan perilaku sama di semua mesin
4. **Observable** — bisa diukur, dilaporkan, dan dipantau
5. **Maintainable** — mudah di-debug dan di-update

Di dunia kerja, **audit keamanan dan optimasi performa adalah deliverable berbayar**. Konsultan dibayar $150–300/jam untuk melakukan hal yang sama. Kemampuan ini adalah pembeda antara "developer yang bisa pakai shell" dan "engineer yang bisa merancang sistem shell".

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: Performance & Security sebagai "First-Class Citizens".**

Di kebanyakan tutorial shell, performa dan keamanan adalah **afterthought** — sesuatu yang dipikirkan setelah semuanya berfungsi. Dalam sistem enterprise, keduanya harus menjadi **pertimbangan utama** dari awal desain.

**Filosofi "You Can't Optimize What You Don't Measure":**

Optimasi tanpa pengukuran adalah **tebak-tebakan**. Anda tidak tahu:
- Plugin mana yang lambat?
- File konfigurasi mana yang memakan waktu?
- Berapa startup time sebenarnya?
- Apakah perubahan Anda benar-benar memperbaiki?

**Semua keputusan optimasi harus didasarkan pada data**, bukan intuisi.

**Filosofi "Defense in Depth":**

Keamanan bukan satu lapisan, tapi banyak:
1. **Pencegahan** — jangan sampai secrets masuk ke `.zshrc`
2. **Deteksi** — scan konfigurasi untuk pola berbahaya
3. **Mitigasi** — batasi kerusakan jika terjadi insiden
4. **Pemulihan** — bisa rollback jika ada masalah

**Filosofi "Security is a Continuous Process":**

Audit sekali tidak cukup. Ancaman berkembang, plugin update, developer berganti. Keamanan harus **berkelanjutan** — ada monitoring, alert, dan review berkala.

**Filosofi "Performance Budget":**

Tetapkan **budget** untuk startup time: misalnya <200ms. Setiap plugin, setiap baris konfigurasi harus "membayar" dengan waktu. Jika total melebihi budget, **ada yang harus dikorbankan**.

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.4 — Profiling, Keamanan, Plugin
# ═══════════════════════════════════════════════════════════

# ─── PROFILING STARTUP ───
# 1. Mengukur total waktu
time zsh -i -c exit

# 2. Profiling dengan zprof
zmodload zsh/zprof
# ... konfigurasi ...
zprof | head -30

# 3. Profiling dengan hyperfine (lebih akurat)
hyperfine --warmup 3 --runs 10 'zsh -i -c exit'

# 4. Tracing startup file-by-file
zsh -xvs 2>&1 | ts '[%H:%M:%.S]' | head -100

# ─── OPTIMASI ───
# 1. Lazy loading
function nvm() {
    unset -f nvm
    source ~/.nvm/nvm.sh
    nvm "$@"
}

# 2. zcompile
zcompile ~/.config/zsh/.zshrc
zcompile ~/.config/zsh/conf.d/00-base.zsh

# 3. compinit cache
compinit -d "$ZDOTDIR/.zcompdump"

# 4. Skip security check (hati-hati)
compinit -C -d "$ZDOTDIR/.zcompdump"

# ─── KEAMANAN ───
# 1. Cek secrets di konfigurasi
grep -rniE '(api[_-]?key|password|token|secret)\s*=\s*["\x27][^"\x27]+' ~/.config/zsh/

# 2. Audit history
grep -iE '(password|api_key|token)' ~/.zsh_history | head -20

# 3. Restrict permission
chmod 600 ~/.config/zsh/.zsh_history
chmod 700 ~/.config/zsh/
chmod 600 ~/.config/zsh/conf.d/*.zsh

# 4. Audit shellcheck
shellcheck ~/.config/zsh/conf.d/*.zsh

# ─── PLUGIN MANAGEMENT ───
# Cek plugin manager
[[ -d ~/.oh-my-zsh ]] && echo "Oh My Zsh"
[[ -d ~/.antidote ]] && echo "Antidote"
[[ -d ~/.zinit ]] && echo "Zinit"

# Cek waktu load per plugin
zprof | grep -E "^\s*[0-9]+\s+[0-9.]+.*zinit|antidote|omz" | head
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **`zprof`** | Modul profiling bawaan Zsh | `zmodload zsh/zprof` |
| **Startup time** | Waktu dari invoke shell hingga siap | `time zsh -i -c exit` |
| **Lazy loading** | Memuat komponen saat dibutuhkan | Function wrapper |
| **`zcompile`** | Compile file Zsh ke bytecode | `zcompile .zshrc` |
| **`.zwc`** | Bytecode Zsh (hasil zcompile) | `.zshrc.zwc` |
| **`zcompdump`** | Cache completion system | `~/.zcompdump` |
| **`compinit -C`** | Skip security check (cepat, tidak aman) | Untuk environment terpercaya |
| **Performance budget** | Batas waktu yang ditetapkan | <200ms startup |
| **Defense in depth** | Beberapa lapisan keamanan | Prevent + Detect + Mitigate |
| **Secret scanning** | Deteksi secrets di konfigurasi | `grep -E 'password'` |
| **ShellCheck** | Linter shell script | `shellcheck script.zsh` |
| **Redaction** | Menyamarkan data sensitif | `HIST_IGNORE_SPACE` |
| **Plugin manager** | Alat untuk manage plugin Zsh | Oh My Zsh, Antidote, Zinit |
| **Turbo mode** | Load plugin setelah prompt (Zinit) | `zinit ice wait'0'` |
| **`zsh-defer`** | Defer loading setelah prompt | `zsh-defer source file` |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Profiling — Mengapa Shell Lambat?

**Tantangan:** Delapan developer melaporkan startup >1 detik. Anda perlu (a) mengukur startup time mereka, (b) mengidentifikasi bottleneck dengan `zprof`, (c) menghasilkan laporan yang bisa ditindaklanjuti.

**Jawaban:**

```zsh
#!/bin/zsh
# profile-startup.zsh — Profiling startup time untuk audit

set -euo pipefail

readonly REPORT_DIR="${1:-/tmp/zsh-profile}"
mkdir -p "$REPORT_DIR"

# ═══════════════════════════════════════════════════════════
# FUNGSI: Mengukur 5x dan hitung rata-rata
# ═══════════════════════════════════════════════════════════
measure_startup() {
    local times=()
    local i
    
    for i in {1..5}; do
        local start=$(date +%s%N)
        # Jalankan shell interaktif, langsung exit
        zsh -i -c exit 2>/dev/null
        local end=$(date +%s%N)
        times+=($(( (end - start) / 1000000 )))
    done
    
    # Hitung rata-rata
    local sum=0
    for t in "${times[@]}"; do
        (( sum += t ))
    done
    echo $(( sum / ${#times[@]} ))
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Profiling dengan zprof
# ═══════════════════════════════════════════════════════════
run_zprof() {
    local output_file="$1"
    
    # Buat temporary .zshrc dengan zprof
    local tmp_zshrc=$(mktemp)
    cat > "$tmp_zshrc" <<'EOF'
# Profile startup
zmodload zsh/zprof
source "${ZDOTDIR:-$HOME}/.zshrc"
zprof > "$ZPROF_OUTPUT"
EOF
    
    ZPROF_OUTPUT="$output_file" ZDOTDIR="${ZDOTDIR:-$HOME}" \
        zsh -i "$tmp_zshrc" 2>/dev/null
    
    rm -f "$tmp_zshrc"
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Analisis zprof output
# ═══════════════════════════════════════════════════════════
analyze_zprof() {
    local zprof_file="$1"
    
    echo "── Top 10 Fungsi Paling Lambat ──"
    grep -E "^\s+[0-9]+\s+[0-9.]+" "$zprof_file" | head -11 | tail -10
    
    echo ""
    echo "── File Konfigurasi yang Di-source ──"
    grep -E "source|autoload" "$zprof_file" | head -10 || true
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    local report="$REPORT_DIR/report-$(whoami)-$(date +%Y%m%d).txt"
    local zprof_file="$REPORT_DIR/zprof-$(whoami)-$(date +%Y%m%d).txt"
    
    {
        echo "════════════════════════════════════════════════════════"
        echo "  ZSH STARTUP PROFILE"
        echo "════════════════════════════════════════════════════════"
        echo "  User: $(whoami)"
        echo "  Host: $(hostname)"
        echo "  Date: $(date)"
        echo ""
        
        # 1. Startup time
        echo "── Startup Time ──"
        local avg=$(measure_startup)
        echo "  Rata-rata (5x): ${avg}ms"
        
        if [[ $avg -lt 200 ]]; then
            echo "  Status: ✅ Cepat"
        elif [[ $avg -lt 500 ]]; then
            echo "  Status: ⚠️  Cukup (bisa dioptimasi)"
        elif [[ $avg -lt 1000 ]]; then
            echo "  Status: ⚠️  Lambat (perlu optimasi)"
        else
            echo "  Status: ❌ Sangat lambat (urgent)"
        fi
        echo ""
        
        # 2. Environment info
        echo "── Environment ──"
        echo "  Zsh version: $ZSH_VERSION"
        echo "  ZDOTDIR: ${ZDOTDIR:-<not set>}"
        echo "  Plugin manager:"
        [[ -d "$HOME/.oh-my-zsh" ]] && echo "    - Oh My Zsh"
        [[ -d "$HOME/.antidote" ]] && echo "    - Antidote"
        [[ -d "$HOME/.zinit" ]] && echo "    - Zinit"
        [[ -d "$HOME/.zplug" ]] && echo "    - Zplug"
        echo ""
        
        # 3. Jumlah plugin
        if [[ -n "${plugins:-}" ]]; then
            echo "── Plugins (${#plugins[@]} aktif) ──"
            printf "  %s\n" "${plugins[@]}"
        fi
        
    } > "$report"
    
    # 4. Profiling dengan zprof
    echo "Menjalankan zprof..." >&2
    run_zprof "$zprof_file"
    
    if [[ -f "$zprof_file" ]]; then
        analyze_zprof "$zprof_file" >> "$report"
    fi
    
    echo "✅ Laporan: $report"
    cat "$report"
}

main "$@"
```

**Penjelasan Mental — zprof Membaca Apa:**

Ketika Anda menjalankan `zprof`, ia menghasilkan output seperti:

```
num  calls                time                       self            name
-----------------------------------------------------------------------------------
 1)    1          86.14    86.14   62.47%     86.14    86.14   62.47%  nvm_load
 2)    3          25.20     8.40   18.29%     25.20     8.40   18.29%  compinit
 3)    1          10.50    10.50    7.62%     10.50    10.50    7.62%  __zsh_autosuggest_start
 4)    2           5.20     2.60    3.77%      5.20     2.60    3.77%  source
 5)    1           3.40     3.40    2.47%      3.40     3.40    2.47%  precmd
```

**Kolom:**
- **num** — Nomor urut
- **calls** — Berapa kali fungsi dipanggil
- **time** — Total waktu kumulatif (ms)
- **self** — Waktu yang dihabiskan di fungsi itu sendiri (tidak termasuk anak)
- **name** — Nama fungsi

**Insight:**
- `nvm_load` memakan 86ms (62% dari total) → **kandidat utama untuk lazy loading**
- `compinit` memakan 25ms → **perlu di-cache**
- `__zsh_autosuggest_start` memakan 10ms → **bisa di-defer**

**Pola Optimasi Berdasarkan zprof:**

| Temuan | Solusi |
|---|---|
| Fungsi besar (nvm, pyenv, conda) | Lazy loading |
| `compinit` lambat | Cache dengan `-d` |
| Banyak `source` | Compile dengan `zcompile` |
| Plugin manager overhead | Ganti ke Antidote/Sheldon |

**Mengapa Rata-rata 5x?**

Karena single measurement bisa jadi outlier:
- Run pertama: disk cache dingin
- Run kedua: sistem sibuk dengan proses lain
- Rata-rata menghilangkan noise

**Zsh-specific: `zmodload zsh/zprof` vs `set -x`**

- `zprof` — **statistical profiler**, menunjukkan fungsi mana yang lambat
- `set -x` — **execution tracer**, menunjukkan urutan eksekusi

Untuk optimasi, gunakan `zprof`. Untuk debugging, gunakan `set -x`.

---

### Pertanyaan 2: Optimasi dengan Lazy Loading

**Tantangan:** Anda menemukan bahwa `nvm` memakan 86ms startup, `pyenv` 45ms, dan `conda` 30ms. Total 161ms hanya untuk tiga tools ini. Optimasi dengan lazy loading.

**Jawaban:**

```zsh
#!/bin/zsh
# conf.d/25-lazy-tools.zsh — Lazy loading untuk tools berat

# ═══════════════════════════════════════════════════════════
# TEKNIK 1: Function wrapper (paling simple)
# ═══════════════════════════════════════════════════════════
nvm() {
    # Hapus fungsi wrapper
    unset -f nvm
    
    # Load nvm asli
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    
    # Panggil fungsi asli dengan argumen
    nvm "$@"
}

# Tambahkan completion lazy
_nvm_lazy() {
    # Completion akan di-load setelah nvm dimuat
    [[ -f "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}
compdef _nvm_lazy nvm

# ═══════════════════════════════════════════════════════════
# TEKNIK 2: Lazy loading pyenv
# ═══════════════════════════════════════════════════════════
pyenv() {
    unset -f pyenv
    
    export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
    export PATH="$PYENV_ROOT/bin:$PATH"
    
    if command -v pyenv &>/dev/null; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)" 2>/dev/null
    fi
    
    pyenv "$@"
}

# ═══════════════════════════════════════════════════════════
# TEKNIK 3: Lazy loading conda
# ═══════════════════════════════════════════════════════════
conda() {
    unset -f conda
    
    local conda_base="${CONDA_BASE:-$HOME/miniconda3}"
    if [[ -f "$conda_base/etc/profile.d/conda.sh" ]]; then
        source "$conda_base/etc/profile.d/conda.sh"
    fi
    
    conda "$@"
}

# ═══════════════════════════════════════════════════════════
# TEKNIK 4: Generic lazy loader
# ═══════════════════════════════════════════════════════════
lazy_load() {
    local cmd="$1"
    local load_command="$2"
    
    # Buat fungsi wrapper
    eval "
    $cmd() {
        unset -f $cmd
        $load_command
        $cmd \"\$@\"
    }
    "
}

# Contoh penggunaan:
# lazy_load nvm 'source ~/.nvm/nvm.sh'
# lazy_load rbenv 'eval "$(rbenv init -)"'

# ═══════════════════════════════════════════════════════════
# TEKNIK 5: Defer dengan zsh-defer (jika tersedia)
# ═══════════════════════════════════════════════════════════
if [[ -f "$ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh" ]]; then
    source "$ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh"
    
    # Defer loading — jalan SETELAH prompt
    zsh-defer source ~/.nvm/nvm.sh
    zsh-defer source ~/.pyenv/pyenv.zsh
    zsh-defer source ~/.conda/conda.zsh
fi
```

**Penjelasan Mental — Lazy Loading Menyelamatkan Startup:**

**Perbedaan "eager" vs "lazy":**

| Approach | Startup | First-use |
|---|---|---|
| **Eager** (langsung) | 161ms lambat | 0ms instant |
| **Lazy** (function) | 0ms instant | 30-80ms (load) |
| **Defer** (setelah prompt) | 0ms instant | 0ms instant |

**Kapan pakai yang mana:**

| Approach | Kapan |
|---|---|
| **Eager** | Tools yang SELALU digunakan (misalnya `git`) |
| **Lazy** | Tools yang jarang digunakan (nvm, pyenv, conda) |
| **Defer** | Tools yang mungkin digunakan tapi tidak di prompt (autosuggestions) |

**Teknik 1 vs Teknik 4 (generic):**

Teknik 1 (manual wrapper) **jelas** dan **eksplisit** — lebih mudah di-debug.
Teknik 4 (generic `lazy_load`) **ringkas** — cocok untuk banyak tools.

Untuk enterprise, **prefer manual wrapper** karena:
- Lebih mudah dipahami developer baru
- Bisa menambahkan logika khusus (misalnya konfigurasi PATH yang berbeda)
- Tidak ada "kejutan" — semua eksplisit

**Lazy Completion:**

Perhatikan `_nvm_lazy` — completion juga lazy-loaded. Ketika developer mengetik `nvm <TAB>`, Zsh memuat:
1. Fungsi wrapper `nvm` (dari `.zshrc`)
2. Completion function `_nvm_lazy` (dari fpath)
3. Fungsi asli `nvm` (dari `nvm.sh`)

**Mengapa `unset -f nvm` di awal fungsi?**

Karena setelah fungsi wrapper dijalankan sekali, kita ingin **menggantinya dengan fungsi asli**. Tanpa `unset -f`, fungsi wrapper akan terus ada dan **recursive call** ke dirinya sendiri.

**Defer dengan `zsh-defer`:**

`zsh-defer` adalah plugin yang menjalankan source setelah prompt pertama ditampilkan. Ini membuat:
- Prompt muncul instan
- Loading tools terjadi "di background"
- Tidak ada delay saat startup

Cocok untuk: syntax highlighting, autosuggestions, tools yang tidak dibutuhkan untuk render prompt.

**Kapan TIDAK boleh defer:**
- Fungsi yang digunakan oleh prompt (misalnya `vcs_info`)
- Environment variable yang dibutuhkan oleh command selanjutnya
- Completion function (harus siap saat Tab ditekan)

---

### Pertanyaan 3: Optimasi `compinit` dan Cache

**Tantangan:** `compinit` memakan 25ms di setiap startup. Bagaimana Anda mengoptimalkannya?

**Jawaban:**

```zsh
# conf.d/30-completion.zsh — Completion dengan optimasi

# ═══════════════════════════════════════════════════════════
# OPTIMASI 1: Cache dump file
# ═══════════════════════════════════════════════════════════
# Tanpa -d, compinit akan scan semua fpath dan rebuild cache
# setiap startup. Dengan -d, ia hanya rebuild jika ada perubahan.

autoload -Uz compinit

# Tentukan lokasi dump
local compdump="${ZDOTDIR:-$HOME}/.zcompdump"

# Tentukan berapa lama cache valid (dalam detik)
# 3600 = 1 jam. Setelah itu, rebuild.
local cache_age=$(( 24 * 60 * 60 ))  # 24 jam

# Cek apakah perlu rebuild
if [[ -f "$compdump" ]]; then
    local dump_age=$(( $(date +%s) - $(stat -c '%Y' "$compdump" 2>/dev/null || stat -f '%m' "$compdump") ))
    
    if [[ $dump_age -lt $cache_age ]]; then
        # Cache masih fresh — skip security check untuk kecepatan
        compinit -C -d "$compdump"
    else
        # Cache lama — rebuild dengan security check
        compinit -d "$compdump"
    fi
else
    # Belum ada cache — buat baru
    compinit -d "$compdump"
fi

# ═══════════════════════════════════════════════════════════
# OPTIMASI 2: Skip fpath scan saat cache fresh
# ═══════════════════════════════════════════════════════════
# Compinit default: scan semua fpath setiap startup
# Dengan -C: skip security check (file ownership, dll.)
# Dampak: ~50% lebih cepat, tapi tidak aman untuk sistem multi-user

# ═══════════════════════════════════════════════════════════
# OPTIMASI 3: Reduced fpath
# ═══════════════════════════════════════════════════════════
# Semakin banyak direktori di fpath, semakin lambat compinit
# Audit fpath secara berkala:
#   echo $fpath | tr ' ' '\n' | wc -l

# Hanya tambahkan yang perlu:
fpath=(
    "$ZDOTDIR/functions"
    /usr/share/zsh/vendor-completions
    /usr/share/zsh/functions/Completion
    $fpath
)

# ═══════════════════════════════════════════════════════════
# OPTIMASI 4: Reduced zstyle (minimal, hanya yang penting)
# ═══════════════════════════════════════════════════════════
# Setiap zstyle menambah overhead saat Tab ditekan
# Hanya set yang benar-benar meningkatkan UX:

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f'
```

**Penjelasan Mental — Mengapa `compinit` Lambat:**

`compinit` melakukan beberapa hal:
1. **Scan `fpath`** — mencari semua file completion (`_*`)
2. **Parse file** — membaca header setiap file completion
3. **Security check** — verifikasi ownership dan permission
4. **Build cache** — menyimpan daftar completion di `.zcompdump`

**Scan fpath** memakan waktu karena:
- Setiap direktori di fpath harus di-`readdir`
- Setiap file harus di-`stat` untuk cek ownership
- Semakin banyak file completion (ribuan), semakin lambat

**Cache dengan `-d`:**

Setelah pertama kali, `compinit` akan menggunakan cache. Ia hanya rebuild jika:
- File cache tidak ada
- File cache lebih tua dari `.zcompdump` (file yang lebih baru dari cache)
- Ada perubahan di fpath

**Security check di `compinit`:**

`compinit` memverifikasi bahwa file completion dimiliki oleh root atau user (bukan user lain). Ini mencegah **completion hijacking** — di mana user jahat meletakkan `_ssh` palsu yang mencuri password.

**`-C` skip security check.** Ini **berbahaya** di sistem multi-user (misalnya shared server), tetapi **aman** di laptop pribadi.

**Aturan enterprise:**

```zsh
# Multi-user server: JANGAN pakai -C
compinit -d "$compdump"

# Laptop pribadi: -C OK
compinit -C -d "$compdump"

# Deteksi otomatis:
if [[ $(whoami) == "root" ]] || [[ -n "${MULTI_USER:-}" ]]; then
    compinit -d "$compdump"
else
    compinit -C -d "$compdump"
fi
```

**Reducing fpath — Mengapa Penting:**

Setiap direktori di fpath diperiksa oleh `compinit`. Direktori yang berisi banyak file bisa memakan waktu:

```zsh
# Cek ukuran fpath
for dir in $fpath; do
    [[ -d "$dir" ]] || continue
    local count=$(ls -1 "$dir" 2>/dev/null | wc -l)
    printf '%4d  %s\n' "$count" "$dir"
done | sort -rn | head -10
```

Direktori dengan ribuan file (misalnya `/usr/share/zsh/functions/Completion`) adalah **target optimasi pertama**.

**Strategi "Cherry-pick":**

Daripada include seluruh `/usr/share/zsh/functions/Completion/`, ambil hanya subdirektori yang benar-benar digunakan:

```zsh
# ❌ Lambat: seluruh direktori
fpath+=(/usr/share/zsh/functions/Completion)

# ✅ Cepat: hanya yang digunakan
fpath+=(
    /usr/share/zsh/functions/Completion/Unix
    /usr/share/zsh/functions/Completion/Zsh
    # Skip: AIX, BSD, Cygwin, Darwin (jika tidak digunakan)
)
```

**Trade-off:**

- **Lebih banyak fpath** = completion lebih lengkap, startup lambat
- **Lebih sedikit fpath** = startup cepat, completion terbatas

Untuk enterprise, **95% completion** dengan startup **2x lebih cepat** adalah trade-off yang bagus.

---

### Pertanyaan 4: Audit Keamanan — Cari Secrets di Konfigurasi

**Tantangan:** Audit menemukan 5 developer menyimpan API keys di `.zshrc`. Buat script yang: (a) scan semua konfigurasi untuk pola secrets, (b) audit history untuk secrets, (c) hasilkan laporan yang detail.

**Jawaban:**

```zsh
#!/bin/zsh
# security-audit.zsh — Audit keamanan konfigurasi Zsh

set -euo pipefail

readonly REPORT="/tmp/zsh-security-audit-$(whoami)-$(date +%Y%m%d).txt"
readonly ZSH_DIR="${ZDOTDIR:-$HOME}"

# ═══════════════════════════════════════════════════════════
# POLA SECRETS YANG DICARI
# ═══════════════════════════════════════════════════════════
typeset -a SECRET_PATTERNS=(
    # API keys umum
    'api[_-]?key'
    'apikey'
    'access[_-]?key'
    'secret[_-]?key'
    'client[_-]?secret'
    
    # Tokens
    'auth[_-]?token'
    'access[_-]?token'
    'bearer'
    'jwt'
    
    # Passwords
    'password'
    'passwd'
    'pwd'
    
    # AWS
    'aws[_-]?secret'
    'aws[_-]?access'
    
    # Database
    'db[_-]?pass'
    'database[_-]?url'
    'postgres://'
    'mysql://'
    'mongodb://'
    
    # Generic
    'private[_-]?key'
    'ssh[_-]?key'
)

# Pola value yang mencurigakan (bukan sekadar variabel kosong)
typeset -a VALUE_PATTERNS=(
    'sk-[A-Za-z0-9]{20,}'        # OpenAI
    'ghp_[A-Za-z0-9]{36}'        # GitHub PAT
    'AKIA[0-9A-Z]{16}'            # AWS Access Key
    'xox[baprs]-[A-Za-z0-9-]+'   # Slack
    '[A-Za-z0-9_-]{32,}'          # Generic long string
)

# ═══════════════════════════════════════════════════════════
# FUNGSI: Scan file untuk secrets
# ═══════════════════════════════════════════════════════════
scan_file() {
    local file="$1"
    local findings=0
    
    [[ -f "$file" ]] || return 0
    
    # Buat pattern OR dari semua SECRET_PATTERNS
    local pattern=$(IFS='|'; echo "${SECRET_PATTERNS[*]}")
    
    # Cari baris yang mengandung pattern + value (bukan sekadar comment)
    while IFS= read -r line; do
        # Skip komentar
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        
        # Skip baris kosong
        [[ -z "${line// /}" ]] && continue
        
        # Cek apakah ada assignment dengan value yang mencurigakan
        if echo "$line" | grep -qiE "($pattern)[[:space:]]*="; then
            # Ekstrak nama variabel
            local varname=$(echo "$line" | grep -oE '^[A-Z_]+' | head -1)
            local has_value=0
            
            # Cek apakah ada value setelah =
            if echo "$line" | grep -qE '=[[:space:]]*["\x27]?.+["\x27]?[[:space:]]*$'; then
                # Ada value
                has_value=1
                
                # Cek apakah value terlihat seperti placeholder
                if echo "$line" | grep -qiE '=(your|xxx|placeholder|changeme|foo|bar|<.*>)'; then
                    has_value=0  # Placeholder, bukan secret asli
                fi
            fi
            
            if [[ $has_value -eq 1 ]]; then
                echo "  🔴 $file"
                echo "     Line: ${line//$'\n'/}"
                echo "     Variabel: $varname"
                echo ""
                (( ++findings ))
            fi
        fi
    done < "$file"
    
    return $findings
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Scan history untuk secrets
# ═══════════════════════════════════════════════════════════
scan_history() {
    local histfile="${HISTFILE:-$HOME/.zsh_history}"
    [[ -f "$histfile" ]] || return 0
    
    echo "── Scan History untuk Secrets ──"
    
    # Cari pola command yang mungkin berisi secret
    local patterns='(password|passwd|api[_-]?key|token|secret|bearer)[[:space:]]*[=:]|--password|--token|curl.*-H.*Authorization'
    
    local count=0
    while IFS= read -r line; do
        # Extract command dari format history: ": timestamp:duration;command"
        local cmd="${line#*;}"
        
        if echo "$cmd" | grep -qiE "$patterns"; then
            echo "  ⚠️  ${cmd:0:100}"
            (( ++count ))
        fi
    done < <(tail -1000 "$histfile")
    
    if [[ $count -eq 0 ]]; then
        echo "  ✅ Tidak ada command mencurigakan di 1000 history terakhir"
    else
        echo ""
        echo "  Total: $count command mencurigakan"
    fi
    echo ""
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Audit permission file konfigurasi
# ═══════════════════════════════════════════════════════════
audit_permissions() {
    echo "── Audit Permission ──"
    
    # File konfigurasi harus 600 atau 644 (bukan 666, 777)
    local files=(
        "$ZSH_DIR/.zshrc"
        "$ZSH_DIR/.zshenv"
        "$ZSH_DIR/.zsh_history"
    )
    
    # Tambah conf.d
    if [[ -d "$ZSH_DIR/conf.d" ]]; then
        for f in "$ZSH_DIR/conf.d"/*.zsh(N); do
            files+=("$f")
        done
    fi
    
    local issues=0
    for file in "${files[@]}"; do
        [[ -f "$file" ]] || continue
        
        local perms=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%A' "$file")
        
        # Cek world-writable
        if [[ "$perms" == *"6"* || "$perms" == *"7"* ]]; then
            if echo "$perms" | grep -qE '[2367]$'; then
                echo "  ⚠️  $file — permission: $perms (world-writable!)"
                (( ++issues ))
            fi
        fi
    done
    
    if [[ $issues -eq 0 ]]; then
        echo "  ✅ Semua file konfigurasi memiliki permission aman"
    fi
    echo ""
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Audit sourcing pattern
# ═══════════════════════════════════════════════════════════
audit_sourcing() {
    echo "── Audit Sourcing Pattern ──"
    
    local issues=0
    
    # Cari "source" tanpa validasi
    for conf in "$ZSH_DIR/conf.d"/*.zsh(N); do
        while IFS= read -r line; do
            # Cari pattern source yang berbahaya
            if echo "$line" | grep -qE '^\s*source\s+.*\$[A-Z_]+.*$'; then
                # Source dengan variabel — perlu validasi
                echo "  ⚠️  $conf: source dengan variabel"
                echo "     $line"
                (( ++issues ))
            fi
            
            # Cari eval
            if echo "$line" | grep -qE '\beval\b'; then
                echo "  🔴 $conf: menggunakan eval"
                echo "     $line"
                (( ++issues ))
            fi
        done < "$conf"
    done
    
    if [[ $issues -eq 0 ]]; then
        echo "  ✅ Tidak ada pattern sourcing berbahaya"
    fi
    echo ""
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    {
        echo "════════════════════════════════════════════════════════"
        echo "  ZSH SECURITY AUDIT"
        echo "════════════════════════════════════════════════════════"
        echo "  User: $(whoami)"
        echo "  Host: $(hostname)"
        echo "  Date: $(date)"
        echo ""
        
        # 1. Scan file konfigurasi untuk secrets
        echo "── Scan Konfigurasi untuk Secrets ──"
        local total_findings=0
        
        for file in "$ZSH_DIR/.zshrc" "$ZSH_DIR/.zshenv" "$ZSH_DIR/.zprofile" "$ZSH_DIR/local.zsh"; do
            [[ -f "$file" ]] || continue
            scan_file "$file" || (( total_findings += $? ))
        done
        
        for file in "$ZSH_DIR/conf.d"/*.zsh(N); do
            scan_file "$file" || (( total_findings += $? ))
        done
        
        if [[ $total_findings -eq 0 ]]; then
            echo "  ✅ Tidak ditemukan secrets di konfigurasi"
        else
            echo "  Total: $total_findings temuan"
        fi
        echo ""
        
        # 2. Scan history
        scan_history
        
        # 3. Audit permission
        audit_permissions
        
        # 4. Audit sourcing pattern
        audit_sourcing
        
        # 5. Ringkasan
        echo "════════════════════════════════════════════════════════"
        echo "  RINGKASAN"
        echo "════════════════════════════════════════════════════════"
        
        if [[ $total_findings -gt 0 ]]; then
            echo "  ❌ ADA TEMUAN KRITIS"
            echo "  Tindakan:"
            echo "    1. Pindahkan secrets ke secret manager (1Password/Vault)"
            echo "    2. Rotasi semua credentials yang terekspos"
            echo "    3. Tambahkan .zsh_history ke .gitignore"
            echo "    4. Aktifkan HIST_IGNORE_SPACE"
        else
            echo "  ✅ Konfigurasi aman"
        fi
    } > "$REPORT"
    
    cat "$REPORT"
    echo ""
    echo "📄 Laporan: $REPORT"
}

main "$@"
```

**Penjelasan Mental — Anatomi Secret di Shell:**

**Jenis secrets yang umum bocor:**

1. **API Keys** — `export OPENAI_API_KEY="sk-..."`
2. **Database URLs** — `export DATABASE_URL="postgres://user:pass@host/db"`
3. **Tokens** — `export GITHUB_TOKEN="ghp_..."`
4. **Passwords** — `export DB_PASSWORD="secret123"`

**Mengapa berbahaya di `.zshrc`:**

1. **Plaintext** — siapapun yang bisa baca file bisa lihat
2. **Git** — jika di-commit, tersimpan selamanya di history
3. **Backup** — backup dotfiles berisi secrets
4. **Process list** — `ps aux` bisa menampilkan env variables
5. **Child processes** — semua child process inherit env vars
6. **Logs** — jika ada command yang log env vars

**Pola Grep yang Digunakan:**

```zsh
'(api[_-]?key|apikey|access[_-]?key|...)[[:space:]]*='
```

- `[_-]?` — optional underscore atau dash (api_key, api-key, apikey)
- `[[:space:]]*` — spasi atau tab
- `=` — tanda sama dengan

**Filtering False Positives:**

Tidak semua `TOKEN=` adalah secret. Placeholder seperti:
```zsh
export API_KEY="your-key-here"
export GITHUB_TOKEN="<placeholder>"
```

Bukan secret asli. Kita filter dengan regex:
```zsh
'=(your|xxx|placeholder|changeme|foo|bar|<.*>)'
```

**Audit History — Mengapa Penting:**

History adalah **sumber kebocoran yang sering diabaikan**. Developer sering menjalankan:
```bash
curl -H "Authorization: Bearer eyJhbGci..." https://api.example.com
mysql -u user -p"password123" -e "SELECT ..."
```

Command ini tersimpan di `.zsh_history` dalam plaintext. Siapapun yang bisa membaca file ini (misalnya jika permission salah) bisa melihat credentials.

**Solusi — `HIST_IGNORE_SPACE`:**

```zsh
setopt HIST_IGNORE_SPACE
```

Dengan opsi ini, command yang diawali spasi tidak disimpan di history:
```bash
# Ini AKAN tersimpan:
mysql -u user -ppassword

# Ini TIDAK akan tersimpan (perhatikan spasi di awal):
 mysql -u user -ppassword
```

Best practice: awali command sensitif dengan spasi, dan aktifkan `HIST_IGNORE_SPACE`.

**Audit Permission — World-Writable:**

File dengan permission `666` atau `777` bisa dimodifikasi siapapun. Ini berbahaya untuk:
- `.zshrc` — attacker bisa inject kode
- `.zsh_history` — attacker bisa lihat command Anda
- `.ssh/config` — attacker bisa redirect koneksi

**Best practice permission:**

| File | Permission | Alasan |
|---|---|---|
| `.zshrc` | `600` (user only) | Konfigurasi pribadi |
| `.zshenv` | `600` | Environment pribadi |
| `.zsh_history` | `600` | Berisi command history |
| `.ssh/` | `700` | Direktori kunci |
| `.ssh/id_*` | `600` | Private keys |
| `.ssh/config` | `600` | Konfigurasi SSH |
| `.ssh/known_hosts` | `644` | Boleh dibaca publik |

**Audit `eval` dan `source` Berbahaya:**

`eval` adalah **fungsi paling berbahaya** di shell:
```zsh
# ❌ Jika $USER_INPUT berisi "; rm -rf /", ini akan menghapus file system!
eval "echo $USER_INPUT"

# ✅ Gunakan printf, array, atau argument passing
printf '%s\n' "$USER_INPUT"
```

`source` dengan path dari variabel juga berbahaya:
```zsh
# ❌ Jika $CONFIG_DIR bisa dikontrol attacker, bisa source malicious file
source "$CONFIG_DIR/helper.zsh"

# ✅ Validasi dulu
if [[ -O "$CONFIG_DIR/helper.zsh" && -r "$CONFIG_DIR/helper.zsh" ]]; then
    source "$CONFIG_DIR/helper.zsh"
fi
```

**`-O` (ownership) — Zsh-specific test:**

`-O file` = true jika file dimiliki oleh user yang sedang menjalankan shell.

Ini mencegah attacker (user lain) meletakkan file yang akan di-source.

---

### Pertanyaan 5: Manajemen Secrets yang Benar

**Tantangan:** Setelah audit menemukan 5 developer menyimpan secrets, Anda perlu: (a) memberikan solusi yang aman, (b) migrasi secrets yang ada, (c) mencegah masalah terulang.

**Jawaban:**

```zsh
# conf.d/15-secrets.zsh — Manajemen secrets yang aman

# ═══════════════════════════════════════════════════════════
# PRINSIP: JANGAN PERNAH simpan secret di file konfigurasi
# ═══════════════════════════════════════════════════════════

# ─── SOLUSI 1: macOS Keychain ───
if [[ "$OSTYPE" == darwin* ]]; then
    # Simpan secret (sekali saja, manual):
    #   security add-generic-password -a "$USER" -s "nusantara-github-token" -w "ghp_xxx"
    
    # Load secret ke environment
    load_keychain_secret() {
        local service="$1"
        local var_name="$2"
        local secret
        
        secret=$(security find-generic-password \
            -a "$USER" \
            -s "$service" \
            -w 2>/dev/null)
        
        if [[ -n "$secret" ]]; then
            export "$var_name=$secret"
            return 0
        fi
        return 1
    }
    
    # Load secrets
    load_keychain_secret "nusantara-github-token" "GITHUB_TOKEN"
    load_keychain_secret "nusantara-aws-secret"   "AWS_SECRET_ACCESS_KEY"
fi

# ─── SOLUSI 2: 1Password CLI ───
if command -v op &>/dev/null; then
    # Cek apakah sudah login
    if ! op account list &>/dev/null; then
        # Belum login — jangan block startup
        # User akan diminta login saat pertama kali akses secret
        :
    fi
    
    # Lazy load: hanya fetch saat dibutuhkan
    get_secret() {
        local ref="$1"  # e.g., "op://Company/AWS/secret_key"
        op read "$ref" 2>/dev/null
    }
    
    # Contoh: load AWS credentials via wrapper
    aws-profile-with-secrets() {
        local profile="${1:-default}"
        
        # Fetch credentials dari 1Password
        export AWS_ACCESS_KEY_ID=$(get_secret "op://Company/AWS/access_key_id")
        export AWS_SECRET_ACCESS_KEY=$(get_secret "op://Company/AWS/secret_access_key")
        export AWS_PROFILE="$profile"
        
        echo "✅ AWS credentials loaded for profile: $profile"
    }
fi

# ─── SOLUSI 3: HashiCorp Vault ───
if command -v vault &>/dev/null; then
    vault_get() {
        local path="$1"
        local field="$2"
        vault kv get -field="$field" "$path" 2>/dev/null
    }
    
    # Contoh: load database password
    vault-db-connect() {
        local env="${1:-dev}"
        export DB_PASSWORD=$(vault_get "secret/nusantara/db/$env" "password")
        export DB_HOST=$(vault_get "secret/nusantara/db/$env" "host")
        echo "✅ Database credentials loaded for: $env"
    fi
fi

# ─── SOLUSI 4: SOPS (encrypted file) ───
if command -v sops &>/dev/null; then
    sops_load() {
        local file="$1"
        [[ -f "$file" ]] || return 1
        
        # Decrypt dan source
        eval "$(sops -d --output-type dotenv "$file" 2>/dev/null | \
            grep -v '^#' | grep '=' | sed 's/^/export /')"
    }
    
    # Load secrets file (jika ada)
    [[ -f "$ZDOTDIR/secrets.enc.yaml" ]] && sops_load "$ZDOTDIR/secrets.enc.yaml"
fi

# ═══════════════════════════════════════════════════════════
# FUNGSI: Prompt untuk secret yang dibutuhkan
# ═══════════════════════════════════════════════════════════
prompt_for_secret() {
    local var_name="$1"
    local description="$2"
    
    # Jika sudah ada, skip
    [[ -n "${(P)var_name:-}" ]] && return 0
    
    # Prompt
    local value
    read -s "value?🔐 $description: "
    echo
    
    export "$var_name=$value"
    unset value
}

# Contoh penggunaan:
# prompt_for_secret GITHUB_TOKEN "GitHub Personal Access Token"
```

**Penjelasan Mental — Hierarki Solusi Secrets:**

**Level 0: NO SECRETS IN FILES (Prinsip Dasar)**

Jangan pernah:
```zsh
# ❌ JANGAN
export API_KEY="sk-1234567890"
export DB_PASSWORD="secret123"
```

**Level 1: Environment Variable dari Parent Process**

```zsh
# Set di wrapper script sebelum launch shell
# (misalnya di .desktop file atau wrapper .sh)
# Zsh hanya membaca, tidak menyimpan
echo "API_KEY dari parent: $API_KEY"
```

**Level 2: Secret Manager dengan CLI**

```zsh
# Fetch saat dibutuhkan (lazy)
get_secret() {
    op read "op://vault/api-key"
}
```

**Level 3: Encrypted File (SOPS, Ansible Vault)**

```zsh
# File terenkripsi di disk, decrypt saat load
sops_load "$ZDOTDIR/secrets.enc.yaml"
```

**Level 4: Hardware-backed (YubiKey, TPM)**

```zsh
# Lebih kompleks, untuk high-security environment
# Contoh: gpg-agent dengan YubiKey
```

**Best Practices untuk 30 Developer:**

1. **Centralize di 1Password/Vault** — satu source of truth
2. **Gunakan CLI** — `op read`, `vault kv get` daripada copy-paste
3. **Lazy fetch** — jangan fetch semua secrets di startup
4. **Cache dengan timeout** — fetch sekali, gunakan berulang kali untuk session
5. **Audit access** — secret manager punya log audit
6. **Rotasi berkala** — kredensial harus di-rotate setiap quarter

**`op read` vs `op item get`:**

- `op read "op://vault/item/field"` — langsung fetch value
- `op item get "item" --fields "field"` — fetch dengan metadata

Untuk secrets, **`op read`** lebih cepat dan straightforward.

**`vault kv get -field`:**

Vault CLI mendukung `-field` untuk ekstrak satu field:
```zsh
# Ambil hanya password, bukan seluruh JSON
PASSWORD=$(vault kv get -field=password secret/db/prod)
```

Lebih clean daripada pipe ke `jq`.

**SOPS Pattern:**

SOPS mengenkripsi file YAML/JSON. File tetap format-nya, tapi values dienkripsi:
```yaml
# secrets.enc.yaml (sebelum decrypt)
database:
    password: ENC[AES256_GCM,data:xxxxx,iv:yyy,tag:zzz,type:str]
    host: ENC[AES256_GCM,data:xxxxx,iv:yyy,tag:zzz,type:str]
```

Setelah `sops -d`:
```yaml
database:
    password: secret123
    host: db.example.com
```

**`eval` dengan SOPS — Trade-off:**

```zsh
eval "$(sops -d --output-type dotenv file | sed 's/^/export /')"
```

Ini adalah **`eval` terkontrol** — file sudah diverifikasi (encrypted dengan kunci yang diketahui). Tetap ada risiko, tapi **minimal**.

Alternatif yang lebih aman:
```zsh
# Baca line-by-line
while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    export "$key=$value"
done < <(sops -d --output-type dotenv file)
```

**Prompt Interaktif untuk Developer Baru:**

Untuk developer baru yang belum setup secret manager, berikan fallback prompt:

```zsh
if [[ -z "${GITHUB_TOKEN:-}" ]] && [[ -o interactive ]]; then
    echo "⚠️  GITHUB_TOKEN belum di-set."
    echo "   Setup: security add-generic-password ... (macOS)"
    echo "   Atau: export GITHUB_TOKEN=... (session ini saja)"
fi
```

**Jangan block startup** — hanya warning. Jika blocking, developer tidak bisa menggunakan shell untuk setup.

---

### Pertanyaan 6: Standarisasi Prompt Tanpa Mengorbankan Performa

**Tantangan:** 12 developer menggunakan prompt berbeda. Anda perlu standarisasi prompt yang: (a) informatif (menampilkan Git branch, error code), (b) cepat (<20ms), (c) konsisten.

**Jawaban:**

```zsh
# conf.d/40-prompt.zsh — Prompt standar Nusantara Tech

# ═══════════════════════════════════════════════════════════
# PRINSIP: Prompt cepat dengan vcs_info
# ═══════════════════════════════════════════════════════════

# ─── Git info dengan vcs_info ───
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# Konfigurasi format vcs_info
zstyle ':vcs_info:git:*' formats       ' %F{blue}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}(%b|%a)%f'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr     '%F{yellow}*%f'
zstyle ':vcs_info:git:*' unstagedstr   '%F{red}*%f'

# ─── precmd: dijalankan sebelum prompt ───
update_prompt() {
    # Update vcs_info
    vcs_info
    
    # Set judul terminal (untuk tab name)
    print -Pn "\e]0;%~\a"
}

# Gunakan add-zsh-hook (lebih baik dari override precmd)
add-zsh-hook precmd update_prompt

# ─── Prompt dengan conditional ───
setopt PROMPT_SUBST

# Format:
# [user@host] dir (branch) ❯
# 
# Dengan warna:
# - user@host: hijau
# - dir: cyan (basename saja, bukan full path)
# - branch: biru
# - prompt char: hijau jika exit 0, merah jika tidak

# %(?.%F{green}❯%f.%F{red}❯%f) = conditional pada exit code
#   jika exit 0 → hijau ❯
#   jika exit ≠ 0 → merah ❯

# %~ = tilde-expanded path
# %1~ = hanya basename
# %2~ = parent/basename

# Prompt standar Nusantara Tech
PS1='%F{green}%n@%h%f %F{cyan}%2~%f${vcs_info_msg_0_} %(?.%F{green}❯%f.%F{red}❯%f) '

# Prompt untuk multi-line command
PS2='%F{yellow}  ❯%f '

# Prompt untuk select (menu)
PS3='%F{cyan}?%f '

# Prompt untuk quote
PS4='%F{magenta}+%f '

# ─── Prompt time (opsional) ───
# Hanya tampilkan jika command terakhir > 5 detik
show_prompt_time() {
    if [[ $CMD_DURATION -gt 5000 ]]; then
        local duration=$(( CMD_DURATION / 1000 ))
        echo " %F{yellow}(${duration}s)%f"
    fi
}

# Uncomment untuk mengaktifkan:
# PROMPT='$(show_prompt_time)'$PROMPT

# ─── Alternatif: prompt minimal untuk developer yang ingin ───
# Developer bisa override di 99-local.zsh:
#   PS1='$ '
```

**Penjelasan Mental — Prompt Cepat dengan vcs_info:**

**Masalah dengan "manual git status":**

```zsh
# ❌ LAMBAT: setiap prompt, jalankan git status
PS1='$(git branch --show-current) $ '
```

Setiap kali prompt muncul, `git branch` dijalankan. Di repo besar, ini bisa memakan **50-200ms** — signifikan!

**Solusi vcs_info:**

`vcs_info` adalah **module Zsh** yang:
1. **Cache** status Git
2. **Hanya update** jika ada perubahan
3. **Lebih cepat** dari manual `git status`

Hasil: **<5ms** per prompt.

**`precmd` hook — Dijalankan Sebelum Prompt:**

```
[shell idle] → user tekan Enter → [command runs] → precmd → PS1 ditampilkan → [shell idle]
```

`precmd` adalah tempat untuk:
- Update variabel prompt (vcs_info)
- Set judul terminal
- Log command

**`add-zsh-hook` vs override `precmd`:**

```zsh
# ❌ Override — konflik dengan plugin lain
precmd() {
    vcs_info
}

# ✅ add-zsh-hook — multiple functions
add-zsh-hook precmd update_prompt
add-zsh-hook precmd update_title
add-zsh-hook precmd log_command
```

`add-zsh-hook` memungkinkan **multiple hooks** tanpa konflik.

**Conditional Prompt — Exit Code:**

```zsh
%(?.%F{green}❯%f.%F{red}❯%f)
```

- `%(?...)` — conditional pada exit code
- `.` memisahkan true/false
- Jika exit 0 → `%F{green}❯%f` (hijau)
- Jika tidak → `%F{red}❯%f` (merah)

**Path Display — `%~` vs `%1~` vs `%2~`:**

| Format | Hasil untuk `/home/user/projects/app` |
|---|---|
| `%~` | `~/projects/app` (full) |
| `%1~` | `app` (basename) |
| `%2~` | `projects/app` (parent/basename) |
| `%3~` | `user/projects/app` |

Untuk enterprise, **`%2~`** biasanya pilihan terbaik — cukup konteks tapi tidak overwhelming.

**Performance Measurement:**

```zsh
# Ukur waktu prompt rendering
time (vcs_info; echo "$PS1") > /dev/null

# Target: <20ms
```

Jika prompt lambat, cek:
1. Apakah menggunakan `git status` manual? Ganti dengan `vcs_info`.
2. Apakah ada command substitution kompleks? Cache hasilnya.
3. Apakah ada plugin prompt yang berat? Ganti dengan custom minimal.

**Trade-off: Standarisasi vs Kustomisasi:**

Untuk 30 developer, Anda perlu:
- **Standar default** — di `40-prompt.zsh`
- **Override yang mudah** — di `99-local.zsh`

```zsh
# 99-local.zsh (developer boleh ubah)
# Override prompt
PS1='%F{cyan}❯%f '   # Minimal

# Atau: load tema lain
# source ~/.config/zsh/themes/powerlevel10k.zsh
```

**Prinsip:** Berikan **default yang baik**, izinkan **override**.

---

### Pertanyaan 7: Migrasi ke Plugin Manager Tunggal

**Tantangan:** 12 developer menggunakan plugin manager berbeda (5 Oh My Zsh, 4 Antidote, 2 Zinit, 1 vanilla). Standarisasi ke satu plugin manager. Mana yang dipilih? Bagaimana migrasinya?

**Jawaban:**

**Analisis Plugin Manager:**

| Plugin Manager | Startup | Bahasa | Aktif | Fitur |
|---|---|---|---|---|
| **Oh My Zsh** | ~200-800ms | Zsh | ✅ | Komprehensif, banyak tema |
| **Antidote** | ~50-100ms | Zsh | ✅ | Cepat, static loading |
| **Zinit** | ~100-200ms | Zsh | ✅ | Turbo mode, fleksibel |
| **Sheldon** | ~30-80ms | Rust | ✅ | Sangat cepat |
| **Znap** | ~50-100ms | Zsh | ✅ | Modern |
| **Vanilla** | ~10ms | Zsh | — | Kontrol penuh |

**Rekomendasi: Antidote** — alasan:

1. **Cepat** — static loading, benchmark ~50-100ms
2. **Aktif** — dikelola oleh `mattmc3` (kontributor aktif)
3. **Sederhana** — file `.zsh_plugins.txt` sebagai source of truth
4. **Kompatibel** — bisa load plugin Oh My Zsh
5. **Migrasi mudah** — dari Oh My Zsh ke Antidote straightforward

**Strategi Migrasi (2 minggu):**

```zsh
#!/bin/zsh
# migrate-plugins.zsh — Migrasi ke Antidote

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# STEP 1: INSTALL ANTIDOTE
# ═══════════════════════════════════════════════════════════
install_antidote() {
    local antidote_dir="$HOME/.antidote"
    
    if [[ -d "$antidote_dir" ]]; then
        echo "✅ Antidote sudah terinstall, update..."
        git -C "$antidote_dir" pull --rebase
    else
        echo "📦 Installing Antidote..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_dir"
    fi
}

# ═══════════════════════════════════════════════════════════
# STEP 2: MIGRASI PLUGIN LIST
# ═══════════════════════════════════════════════════════════
migrate_plugins() {
    local plugins_file="$ZDOTDIR/.zsh_plugins.txt"
    
    echo "📝 Membuat daftar plugin..."
    
    cat > "$plugins_file" <<'EOF'
# ═══════════════════════════════════════════════════════════
# Nusantara Tech — Daftar Plugin
# Format: username/repo atau URL
# Dokumentasi: https://getantidote.github.io/
# ═══════════════════════════════════════════════════════════

# ─── Core Plugins (WAJIB) ───
zsh-users/zsh-completions
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting

# ─── Tools ───
# (dari Oh My Zsh — gunakan path:plugins/)
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/docker
ohmyzsh/ohmyzsh path:plugins/kubectl
ohmyzsh/ohmyzsh path:plugins/aws

# ─── Nusantara Custom ───
# Plugin internal
git.nusantara.tech/dotfiles/plugins/nt-tools

# ─── Optional (comment untuk disable) ───
# ohmyzsh/ohmyzsh path:plugins/tmux
# ohmyzsh/ohmyzsh path:plugins/npm
EOF
    
    echo "✅ Plugin list: $plugins_file"
}

# ═══════════════════════════════════════════════════════════
# STEP 3: UPDATE .zshrc
# ═══════════════════════════════════════════════════════════
update_zshrc() {
    local zshrc="$ZDOTDIR/conf.d/25-plugins.zsh"
    
    cat > "$zshrc" <<'EOF'
# conf.d/25-plugins.zsh — Plugin management dengan Antidote

# Source Antidote
source "$HOME/.antidote/antidote.zsh"

# Load plugins (static mode — paling cepat)
antidote load "$ZDOTDIR/.zsh_plugins.txt"

# Bundle (opsional): compile plugin ke satu file untuk load lebih cepat
# antidote bundle < "$ZDOTDIR/.zsh_plugins.txt" > "$ZDOTDIR/.zsh_plugins.zsh"
# source "$ZDOTDIR/.zsh_plugins.zsh"
EOF
    
    echo "✅ Updated: $zshrc"
}

# ═══════════════════════════════════════════════════════════
# STEP 4: BACKUP KONFIGURASI LAMA
# ═══════════════════════════════════════════════════════════
backup_old() {
    local backup_dir="$HOME/.zsh-backup-plugin-migration-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup Oh My Zsh custom
    if [[ -d "$HOME/.oh-my-zsh/custom" ]]; then
        cp -r "$HOME/.oh-my-zsh/custom" "$backup_dir/"
        echo "✅ Backup: Oh My Zsh custom → $backup_dir"
    fi
    
    # Backup .zshrc lama
    [[ -f "$ZDOTDIR/.zshrc" ]] && cp "$ZDOTDIR/.zshrc" "$backup_dir/.zshrc.old"
    
    echo "📁 Backup directory: $backup_dir"
}

# ═══════════════════════════════════════════════════════════
# STEP 5: VERIFIKASI
# ═══════════════════════════════════════════════════════════
verify_migration() {
    echo ""
    echo "🔍 Verifikasi..."
    
    # Test startup
    local startup=$(measure_startup)
    echo "   Startup time: ${startup}ms"
    
    # Test plugin load
    if zsh -c 'source $ZDOTDIR/conf.d/25-plugins.zsh' 2>/dev/null; then
        echo "   ✅ Plugin loading OK"
    else
        echo "   ❌ Plugin loading FAILED"
        return 1
    fi
    
    # Test completion
    if zsh -i -c 'whence -w compinit' 2>/dev/null | grep -q function; then
        echo "   ✅ Completion OK"
    fi
    
    # Test autosuggestions
    if zsh -i -c '(( $+functions[_zsh_autosuggest_start] ))' 2>/dev/null; then
        echo "   ✅ Autosuggestions OK"
    fi
}

measure_startup() {
    local times=()
    for i in {1..3}; do
        local start=$(date +%s%N)
        zsh -i -c exit 2>/dev/null
        local end=$(date +%s%N)
        times+=($(( (end - start) / 1000000 )))
    done
    echo $(( (${times[1]} + ${times[2]} + ${times[3]}) / 3 ))
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    echo "╔══════════════════════════════════════════════╗"
    echo "║  MIGRASI KE ANTIDOTE — Nusantara Tech       ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    backup_old
    install_antidote
    migrate_plugins
    update_zshrc
    verify_migration
    
    echo ""
    echo "🎉 Migrasi selesai!"
    echo "   Buka terminal baru untuk testing."
}

main "$@"
```

**Penjelasan Mental — Mengapa Antidote:**

**Filosofi Antidote: "Static loading, no magic."**

Berbeda dengan Zinit yang punya **turbo mode** (load plugin setelah prompt), Antidote menggunakan **static loading** — plugin di-load saat startup.

**Trade-off:**

| Aspek | Static (Antidote) | Turbo (Zinit) |
|---|---|---|
| Startup | Lebih lambat | Instan |
| Complexity | Simple | Kompleks |
| Debug | Mudah | Sulit |
| First-use | Instan | Ada delay kecil |
| Reliabilitas | Tinggi | Rentan race conditions |

Untuk enterprise, **reliabilitas > kecepatan**. Static loading:
- Tidak ada "kejutan" — plugin selalu siap
- Debugging straightforward
- Tidak ada delay saat pertama kali pakai fitur
- Performance predictable

**Migrasi dari Oh My Zsh:**

Oh My Zsh menggunakan format:
```zsh
plugins=(git docker kubectl aws)
```

Antidote menggunakan:
```
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/docker
```

Setiap plugin Oh My Zsh bisa di-load sebagai "package" dari repo `ohmyzsh/ohmyzsh` dengan path `plugins/<name>`.

**Plugin "Core" yang Wajib:**

| Plugin | Fungsi |
|---|---|
| `zsh-users/zsh-completions` | Completion tambahan |
| `zsh-users/zsh-autosuggestions` | Saran berdasarkan history |
| `zsh-users/zsh-syntax-highlighting` | Warna saat mengetik |

Ketiganya harus ada untuk UX standar.

**Plugin Internal (`git.nusantara.tech/dotfiles/plugins/nt-tools`):**

Untuk tools internal, buat plugin sendiri:
```
nt-tools/
├── nt-tools.plugin.zsh
├── functions/
│   ├── _nt-deploy
│   └── _nt-db
└── README.md
```

Lalu tambahkan ke `.zsh_plugins.txt`:
```
git.nusantara.tech/dotfiles/plugins/nt-tools
```

Antidote akan clone dan load otomatis.

**Bundle Option (Performance Boost):**

```zsh
# Setelah plugin list stabil, "bundle" ke file tunggal
antidote bundle < "$ZDOTDIR/.zsh_plugins.txt" > "$ZDOTDIR/.zsh_plugins.zsh"
```

File `bundle` berisi semua plugin dalam satu file — load lebih cepat (satu file vs banyak file).

**Trade-off bundle:**
- ✅ Lebih cepat (satu I/O)
- ❌ Tidak otomatis update (harus re-bundle setelah ubah plugin list)

Untuk enterprise: **bundle** setelah plugin list stabil, **static load** selama development.

**Benchmark yang Realistis:**

| Setup | Startup Time |
|---|---|
| Vanilla Zsh | ~50ms |
| Oh My Zsh (default) | ~300-500ms |
| Oh My Zsh (optimized) | ~150-250ms |
| Antidote | ~80-120ms |
| Antidote + bundle | ~60-90ms |
| Sheldon | ~50-80ms |

**Target enterprise:** 80-150ms.

**Migrasi Bertahap — Jangan Big Bang:**

Untuk 30 developer, jangan migrasi sekaligus:

**Minggu 1:**
- Pilih 5 developer (early adopters)
- Migrasi mereka
- Kumpulkan feedback

**Minggu 2:**
- Update dokumentasi berdasarkan feedback
- Migrasi 15 developer lagi

**Minggu 3:**
- Migrasi sisanya
- Monitor performa

**Mengapa bertahap:**
- Bug ditemukan di kelompok kecil
- Feedback lebih actionable
- Rollback lebih mudah
- Tidak ada downtime masif

---

### Pertanyaan 8: Monitoring Berkelanjutan

**Tantangan:** Setelah audit dan migrasi, Anda perlu monitoring berkelanjutan. Buat sistem yang: (a) mengumpulkan metrik performa secara berkala, (b) mendeteksi anomali, (c) mengirim laporan ke tim IT.

**Jawaban:**

```zsh
#!/bin/zsh
# monitor-zsh.zsh — Monitoring Zsh berkelanjutan

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# KONFIGURASI
# ═══════════════════════════════════════════════════════════
readonly METRICS_DIR="${METRICS_DIR:-$HOME/.local/share/zsh-metrics}"
readonly METRICS_FILE="$METRICS_DIR/metrics.jsonl"
readonly REPORT_ENDPOINT="${REPORT_ENDPOINT:-https://metrics.nusantara.tech/zsh}"
readonly MAX_FILE_SIZE=$(( 10 * 1024 * 1024 ))  # 10MB

mkdir -p "$METRICS_DIR"

# ═══════════════════════════════════════════════════════════
# KOLEKSI METRIK
# ═══════════════════════════════════════════════════════════
collect_metrics() {
    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
    
    # Startup time
    local startup=$(measure_startup)
    
    # Jumlah plugin
    local plugin_count=0
    if [[ -n "${plugins:-}" ]]; then
        plugin_count=${#plugins[@]}
    elif [[ -f "$ZDOTDIR/.zsh_plugins.txt" ]]; then
        plugin_count=$(grep -vE '^\s*#|^\s*$' "$ZDOTDIR/.zsh_plugins.txt" | wc -l)
    fi
    
    # Jumlah config files
    local config_count=$(find "$ZDOTDIR/conf.d" -name "*.zsh" 2>/dev/null | wc -l | tr -d ' ')
    
    # Completion dump size
    local compdump_size=0
    if [[ -f "$ZDOTDIR/.zcompdump" ]]; then
        compdump_size=$(stat -c '%s' "$ZDOTDIR/.zcompdump" 2>/dev/null || echo 0)
    fi
    
    # History size
    local history_size=0
    if [[ -f "$HISTFILE" ]]; then
        history_size=$(wc -l < "$HISTFILE" | tr -d ' ')
    fi
    
    # Plugin manager detected
    local plugin_manager="unknown"
    [[ -d "$HOME/.antidote" ]] && plugin_manager="antidote"
    [[ -d "$HOME/.oh-my-zsh" ]] && plugin_manager="ohmyzsh"
    [[ -d "$HOME/.zinit" ]] && plugin_manager="zinit"
    
    # Build JSON
    cat <<EOF
{"timestamp":"$timestamp","user":"$(whoami)","host":"$(hostname)","zsh_version":"$ZSH_VERSION","startup_ms":$startup,"plugin_count":$plugin_count,"config_count":$config_count,"compdump_size":$compdump_size,"history_size":$history_size,"plugin_manager":"$plugin_manager"}
EOF
}

measure_startup() {
    local start=$(date +%s%N)
    zsh -i -c exit 2>/dev/null
    local end=$(date +%s%N)
    echo $(( (end - start) / 1000000 ))
}

# ═══════════════════════════════════════════════════════════
# SIMPAN METRIK
# ═══════════════════════════════════════════════════════════
save_metrics() {
    local metrics="$1"
    
    # Rotate file jika terlalu besar
    if [[ -f "$METRICS_FILE" ]]; then
        local size=$(stat -c '%s' "$METRICS_FILE" 2>/dev/null || echo 0)
        if [[ $size -gt $MAX_FILE_SIZE ]]; then
            mv "$METRICS_FILE" "${METRICS_FILE}.$(date +%Y%m%d)"
        fi
    fi
    
    # Append
    echo "$metrics" >> "$METRICS_FILE"
}

# ═══════════════════════════════════════════════════════════
# ANALISIS ANOMALI
# ═══════════════════════════════════════════════════════════
detect_anomalies() {
    local current_metrics="$1"
    
    # Ekstrak startup_ms dari JSON
    local current_startup=$(echo "$current_metrics" | jq -r '.startup_ms')
    
    # Threshold
    local threshold=500  # ms
    
    if [[ $current_startup -gt $threshold ]]; then
        echo "⚠️  ANOMALY: Startup ${current_startup}ms > ${threshold}ms threshold" >&2
        return 1
    fi
    
    return 0
}

# ═══════════════════════════════════════════════════════════
# KIRIM KE SERVER
# ═══════════════════════════════════════════════════════════
send_to_server() {
    local metrics="$1"
    
    if command -v curl &>/dev/null; then
        curl -sS -X POST \
            -H "Content-Type: application/json" \
            -d "$metrics" \
            "$REPORT_ENDPOINT" 2>/dev/null || true
    fi
}

# ═══════════════════════════════════════════════════════════
# LAPORAN LOKAL
# ═══════════════════════════════════════════════════════════
generate_local_report() {
    [[ -f "$METRICS_FILE" ]] || return
    
    echo "📊 METRICS REPORT (${METRICS_FILE})"
    echo ""
    
    # Rata-rata startup 7 hari terakhir
    local avg_7d=$(tail -100 "$METRICS_FILE" | \
        jq -r '.startup_ms' | \
        awk '{sum+=$1; count++} END {printf "%.0f", sum/count}')
    
    echo "  Rata-rata startup: ${avg_7d}ms"
    
    # Max startup 7 hari terakhir
    local max_7d=$(tail -100 "$METRICS_FILE" | \
        jq -r '.startup_ms' | \
        sort -rn | head -1)
    
    echo "  Max startup: ${max_7d}ms"
    
    # Trend (compare first 50 vs last 50)
    local first_50=$(head -50 "$METRICS_FILE" | jq -r '.startup_ms' | awk '{sum+=$1} END {print sum/NR}')
    local last_50=$(tail -50 "$METRICS_FILE" | jq -r '.startup_ms' | awk '{sum+=$1} END {print sum/NR}')
    local trend=$(echo "$first_50 $last_50" | awk '{print ($2 > $1) ? "lambat" : "cepat"}')
    
    echo "  Trend: $trend"
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    local command="${1:-collect}"
    
    case "$command" in
        collect)
            local metrics=$(collect_metrics)
            save_metrics "$metrics"
            
            if ! detect_anomalies "$metrics"; then
                echo "$metrics" | jq -C . >&2
            fi
            
            send_to_server "$metrics"
            ;;
        report)
            generate_local_report
            ;;
        *)
            echo "Usage: $0 {collect|report}"
            exit 1
            ;;
    esac
}

main "$@"
```

**Setup Cron (Setiap Hari Jam 9 Pagi):**

```cron
# Kirim metrik ke server setiap hari
0 9 * * * /home/nusantara/bin/monitor-zsh.zsh collect > /dev/null 2>&1
```

**Penjelasan Mental — Observability dalam Praktik:**

**Pilar Observability:**

1. **Metrics** — angka yang bisa diukur (startup time, plugin count)
2. **Logs** — event yang bisa ditelusuri (apa yang terjadi kapan)
3. **Traces** — alur eksekusi (fungsi mana yang lambat)

Untuk Zsh, kita fokus pada **metrics** dan **logs**.

**Format JSONL — JSON Lines:**

Setiap baris adalah JSON valid:
```
{"timestamp":"2026-10-12T09:00:00Z","startup_ms":85,"plugin_count":12}
{"timestamp":"2026-10-13T09:00:00Z","startup_ms":82,"plugin_count":12}
{"timestamp":"2026-10-14T09:00:00Z","startup_ms":120,"plugin_count":13}
```

**Keunggulan JSONL:**
- **Append-only** — efisien untuk penulisan
- **Streaming** — bisa dibaca baris per baris
- **Queryable** — bisa diproses dengan `jq`, `awk`, atau database
- **Rotatable** — file bisa di-rotate tanpa mempengaruhi struktur

**Rotasi File:**

File metrics bisa tumbuh besar (10MB = ~50,000 entries untuk 30 user). Rotasi mencegah file terlalu besar:

```zsh
if [[ $size -gt $MAX_FILE_SIZE ]]; then
    mv "$METRICS_FILE" "${METRICS_FILE}.$(date +%Y%m%d)"
fi
```

**`jq` untuk Parsing JSON:**

```zsh
# Ambil satu field
jq -r '.startup_ms' < metrics.jsonl

# Filter by condition
jq -r 'select(.startup_ms > 500) | .user' < metrics.jsonl

# Aggregate
jq -s 'map(.startup_ms) | add / length' < metrics.jsonl
```

**`jq -s` (slurp)** — baca semua baris menjadi array. Berguna untuk agregasi.

**`jq -r` (raw)** — output tanpa quote. Berguna untuk piping ke `awk`.

**Analisis Trend:**

```zsh
# Compare first 50 (baseline) vs last 50 (current)
first=$(head -50 file | jq -r '.startup_ms' | awk '{sum+=$1} END {print sum/NR}')
last=$(tail -50 file | jq -r '.startup_ms' | awk '{sum+=$1} END {print sum/NR}')

# Trend
if (( $(echo "$last > $first * 1.2" | bc -l) )); then
    echo "⚠️  Startup melambat 20%+ — perlu investigasi"
fi
```

**Anomaly Detection Sederhana:**

Threshold-based:
```zsh
if [[ $startup -gt 500 ]]; then
    echo "ANOMALY: $startup > 500ms"
fi
```

Statistik (lebih sophisticated):
```zsh
# Deteksi jika current > mean + 2*stddev
mean=$(tail -100 file | jq -r '.startup_ms' | awk '{sum+=$1} END {print sum/NR}')
stddev=$(tail -100 file | jq -r '.startup_ms' | awk -v m="$mean" '{sum+=($1-m)^2} END {print sqrt(sum/NR)}')
threshold=$(echo "$mean + 2 * $stddev" | bc -l)

if (( $(echo "$current > $threshold" | bc -l) )); then
    echo "ANOMALY: statistical outlier"
fi
```

**Real-World Insights dari Monitoring:**

Setelah 1 bulan monitoring, Anda mungkin menemukan:
- **Startup time naik setiap Senin pagi** — karena sistem sibuk
- **Developer dengan MacBook M1 40% lebih cepat** dari Intel
- **Plugin autosuggestions bertambah 5ms per 10,000 history entries**
- **Developer yang pakai Docker Desktop startup 2x lebih lambat**

Insight ini **tidak bisa didapat tanpa monitoring**.

**Privacy Considerations:**

Metrics yang dikumpulkan harus **anonim**:
- ✅ Startup time, plugin count, config count
- ❌ Command history, file paths, secrets

**Jangan kumpulkan:**
- Isi command
- Isi file
- Path pribadi (`/Users/nama/...`)
- Environment variables

**Best practice:** Kumpulkan **hanya angka** dan **hash** dari identitas (bukan nama user asli).

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Diagram Pareto Startup Time** — Bar chart yang menunjukkan kontribusi setiap komponen terhadap total startup time. Bantu developer melihat "20% komponen menyebabkan 80% startup time".
>
> 2. **Timeline Lazy Loading** — Garis waktu horizontal: dari invoke shell → prompt muncul → user mengetik → tools load. Bandingkan eager vs lazy vs defer.
>
> 3. **Diagram Defense in Depth** — Lingkaran konsentris: Prevent → Detect → Mitigate → Recover. Tandai tools/strategi di setiap lapisan.
>
> 4. **Peta Secret Management** — Diagram alur: dari secret (di 1Password/Vault) → CLI fetch → environment variable (session) → used by command. Tandai mana yang "aman" dan "tidak aman".
>
> 5. **Grafik Trend Startup Time** — Line chart dengan sumbu X (waktu) dan sumbu Y (startup ms). Tandai anomali dengan warna merah.
>
> 6. **Diagram Migrasi Plugin Manager** — Before/after: 12 developers dengan 4 plugin manager → 30 developers dengan 1 plugin manager. Tandai performa masing-masing.

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.1 (Fondasi)** | Variabel, quoting, dan file system adalah dasar untuk audit |
| **7.2 (Scripting)** | Fungsi, error handling, dan trap digunakan di semua script di sini |
| **7.3 (Konfigurasi)** | Sistem `conf.d/` adalah target audit dan optimasi |
| **7.5 (Testing)** | Script audit dan monitoring akan di-test |
| **7.6 (Expert)** | Sistem monitoring ini akan menjadi bagian dari deployment enterprise |
| **Fase 4 (Kurikulum)** | Modul ini adalah aplikasi langsung dari: plugin manager, prompt, performa, keamanan |

---

## 9. Sumber Referensi Lengkap

- **Zsh Manual: `zprof` module** — https://zsh.sourceforge.io/Doc/Release/Modules.html
- **Zsh Manual: `zcompile`** — https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html
- **Zsh Manual: Completion System** — https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- **Zsh Manual: Security** — https://zsh.sourceforge.io/Doc/Release/Options.html
- **1Password CLI** — https://developer.1password.com/docs/cli/
- **HashiCorp Vault** — https://developer.hashicorp.com/vault/docs
- **SOPS** — https://github.com/getsops/sops
- **ShellCheck** — https://www.shellcheck.net/
- **Antidote** — https://getantidote.github.io/
- **zsh-defer** — https://github.com/romkatv/zsh-defer
- **zsh-bench (benchmarking)** — https://github.com/romkatv/zsh-bench
- **hyperfine** — https://github.com/sharkdp/hyperfine
- **jq Manual** — https://jqlang.github.io/jq/manual/
- **Google Shell Style Guide: Security** — https://google.github.io/styleguide/shellguide.html
- **OWASP: Secrets Management Cheat Sheet** — https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html

---

## 10. Tips dan Praktik Terbaik

1. **Ukur sebelum optimasi.** Tanpa `zprof`, Anda akan menebak-nebak.
2. **Target <200ms startup.** Di atas itu, ada bottleneck.
3. **Lazy loading untuk tools jarang.** nvm, pyenv, conda — tidak perlu di startup.
4. **`compinit -d` wajib.** Tanpa cache, compinit 3-5x lebih lambat.
5. **`zcompile` file besar.** Bytecode load 2-5x lebih cepat.
6. **Jangan simpan secrets di files.** Gunakan secret manager.
7. **Audit permission.** File konfigurasi harus `600`, bukan `666`.
8. **`HIST_IGNORE_SPACE` wajib.** Awali command sensitif dengan spasi.
9. **Standarisasi plugin manager.** 1 manager untuk 30 developer.
10. **Monitoring berkelanjutan.** Audit sekali tidak cukup.
11. **Anonimkan metrics.** Jangan kumpulkan data pribadi.
12. **Test migrasi di 5 developer dulu.** Baru rollout ke 30.
13. **Dokumentasi perubahan.** Setiap migrasi harus di-dokumentasi.
14. **Rollback plan.** Setiap perubahan harus bisa di-revert.
15. **Review berkala.** Setiap quarter, evaluasi ulang.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `compinit` tanpa `-d` | Startup lambat | `compinit -d "$ZDOTDIR/.zcompdump"` |
| Lazy loading `git` | Delay saat commit pertama | Jangan lazy-load tools yang sering digunakan |
| Secrets di `.zshrc` | Audit finding | Secret manager |
| Permission `666` | Attacker bisa edit | `chmod 600` |
| `eval` dengan input user | Code injection | Hindari `eval`, gunakan array |
| File history world-readable | Credentials bocor | `chmod 600 ~/.zsh_history` |
| Plugin manager gonta-ganti | Inkonsisten, konflik | Standarisasi 1 manager |
| Prompt pakai `git status` | 50-200ms per prompt | Gunakan `vcs_info` |
| Monitoring tanpa rotasi | File metrics tumbuh tak terbatas | Rotasi berdasarkan ukuran |
| Metrics berisi data pribadi | Privacy violation | Anonimkan, hanya angka |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.4, Anda seharusnya mengembangkan **mental model baru**:

1. **Performance adalah fitur.** Shell yang lambat adalah bug, bukan hanya ketidaknyamanan.
2. **Measure, don't guess.** Tanpa data, optimasi adalah tebak-tebakan.
3. **Security is layered.** Pencegahan, deteksi, mitigasi, pemulihan — semua penting.
4. **Secrets have a lifecycle.** Create → Store → Access → Rotate → Revoke.
5. **Lazy loading adalah senjata utama.** Setiap tools yang tidak selalu digunakan adalah kandidat.
6. **Monitoring adalah kontrak.** Sistem yang tidak dimonitor adalah sistem yang tidak diketahui.
7. **Standarisasi memudahkan.** 1 plugin manager > 4 plugin manager.
8. **Perubahan harus bisa di-rollback.** Big bang migration = bencana.
9. **Documentation is a product.** Tanpa dokumentasi, audit tidak berguna.
10. **Compliance is ongoing.** Bukan sekali setahun, tapi terus-menerus.

**Pertanyaan reflektif untuk diri sendiri:**
- Bisakah saya menjelaskan mengapa `compinit -d` lebih cepat dari `compinit`?
- Apakah saya tahu kapan harus lazy-load dan kapan jangan?
- Bisakah saya menulis script audit untuk secrets tanpa melihat contoh?
- Apakah saya tahu perbedaan `op read`, `vault kv get`, dan `sops -d`?
- Bisakah saya membuat monitoring yang anonim dan berkelanjutan?

Jika jawabannya "belum", **ulangi modul ini** — performa dan keamanan adalah keterampilan yang membedakan profesional dari amatir.

### Checklist Verifikasi

Sebelum melanjutkan ke Modul 7.5, pastikan Anda dapat:

- [ ] Mengukur startup time dengan `time` dan `zprof`
- [ ] Mengidentifikasi bottleneck dari output `zprof`
- [ ] Mengimplementasikan lazy loading untuk tools berat (nvm, pyenv, conda)
- [ ] Mengkonfigurasi `compinit` dengan cache
- [ ] Menggunakan `zcompile` untuk file besar
- [ ] Menulis script audit untuk secrets di konfigurasi
- [ ] Mengaudit history untuk command mencurigakan
- [ ] Mengaudit permission file konfigurasi
- [ ] Mengimplementasikan secret manager (1Password, Vault, SOPS)
- [ ] Menstandarisasi prompt dengan `vcs_info`
- [ ] Memilih dan memigrasi plugin manager
- [ ] Membangun monitoring berkelanjutan dengan metrics JSONL
- [ ] Mendeteksi anomali dari data historis
- [ ] Menjalankan `shellcheck` pada semua script
- [ ] Membuat rollback plan untuk setiap perubahan

---

## ✅ MODUL 7.4 SELESAI

**Ringkasan yang telah Anda kuasai:**
- Profiling dengan `zprof`, `time`, dan `hyperfine`
- Optimasi dengan lazy loading, `zcompile`, dan cache
- Audit keamanan: secrets, permission, sourcing pattern
- Manajemen secrets: Keychain, 1Password, Vault, SOPS
- Standarisasi prompt dengan `vcs_info`
- Migrasi plugin manager (Antidote)
- Monitoring berkelanjutan dengan metrics JSONL
- Deteksi anomali dan trend analysis

**Yang akan datang di Modul 7.5:**
Anda akan membangun **CLI tool dengan test suite** — menggunakan teknik scripting lanjutan (hook, autoload, parameter expansion), framework testing (ShellSpec, ZUnit), dan integrasi dengan bahasa lain (Python, jq). Ini adalah langkah menuju "shell engineer" — dari pengoptimal menjadi pengembang produk.

---

# MODUL 7.5: MEMBANGUN CLI TOOL DENGAN TEST SUITE

> **Mewakili:** Fase 5 — Fungsi Lanjutan, Hook, Autoloading, Testing & QA, Integrasi dengan Bahasa Lain & API Eksternal
> **Level:** Mahir | **Durasi:** 12–15 jam | **Tipe:** Proyek Simulasi

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model "CLI tool sebagai produk"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Toolkit fungsi lanjutan, testing, integrasi
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan nyata
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Enam bulan setelah audit keamanan.** Sistem konfigurasi Zsh Anda stabil, performa startup rata-rata 95ms, tidak ada temuan keamanan. Kini giliran inovasi. VP Engineering memanggil Anda:

> *"Tim DevOps kami punya masalah. Setiap hari mereka harus:*
> - *Cek status 15 service di 3 environment (dev, staging, prod)*
> - *Deploy ke berbagai environment dengan konfigurasi berbeda*
> - *Rotasi credentials yang tersebar di banyak tempat*
> - *Generate laporan mingguan dari metrics*
> - *Debug masalah produksi dengan berbagai tools*
>
> *Semua ini dilakukan manual dengan command yang panjang dan mudah lupa. Kami butuh **CLI tool internal** yang:*
> - *Memiliki subcommands yang jelas*
> - *Auto-completion di Zsh*
> - *Bisa di-test secara otomatis*
> - *Terintegrasi dengan Kubernetes, AWS, dan database*
> - *Bisa di-distribute ke seluruh tim*
> - *Ter-dokumentasi dengan baik*
> - *Bisa dikembangkan tanpa takut rusak (test coverage)*
>
> *Tool ini akan menjadi 'senjata utama' tim DevOps. Namanya: `nt` (Nusantara Toolkit). Deadline: 4 minggu."*

**Requirement spesifik:**

| Subcommand | Fungsi |
|---|---|
| `nt status` | Cek status semua service |
| `nt deploy <env> <service>` | Deploy service ke environment |
| `nt db <action>` | Interaksi dengan database |
| `nt k8s <action>` | Interaksi dengan Kubernetes |
| `nt secrets <action>` | Manajemen secrets |
| `nt report <period>` | Generate laporan |
| `nt debug <service>` | Debug interaktif |
| `nt help` | Bantuan |

Anda memiliki:
- 4 minggu
- Tim 3 developer (termasuk Anda)
- Akses ke semua environment
- Repository Git internal
- CI/CD pipeline (GitHub Actions)

**Tantangan:** Bangun CLI tool **production-grade** dengan test coverage >80%, dokumentasi lengkap, dan distribusi yang mudah.

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **kulminasi** dari semua yang telah Anda pelajari:

- **Fase 1 (Fondasi)** — variabel, quoting, ekspansi → digunakan di setiap baris
- **Fase 2 (Scripting Dasar)** — fungsi, kontrol alur, I/O → fondasi CLI tool
- **Fase 3 (Globbing, Completion)** — glob qualifier, completion system → UX CLI tool
- **Fase 4 (Performa, Keamanan)** — lazy loading, secrets management → production readiness
- **Fase 5 (Fungsi Lanjutan, Testing, Integrasi)** — hook, autoload, test framework, API → inti modul ini

Ini adalah **momen di mana semua potongan puzzle bersatu**. Anda tidak lagi menulis script kecil — Anda membangun **produk** yang digunakan oleh puluhan orang setiap hari.

Di dunia kerja, CLI tool internal adalah **aset perusahaan**. Ia:
- Menghemat waktu developer (otomasi berulang)
- Mengurangi error manual (prosedur terstandar)
- Meningkatkan onboarding (satu tool untuk semua)
- Menjadi dokumentasi hidup (kode sebagai dokumentasi)

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: CLI tool sebagai "produk dengan user".**

Bayangkan Anda membangun aplikasi web. Anda akan:
- Mendesain UI/UX (di CLI: argumen, output, error message)
- Menulis test (di CLI: unit, integration, end-to-end)
- Mendeploy (di CLI: install, update, uninstall)
- Mendokumentasikan (di CLI: help, man page, README)
- Memantau (di CLI: logging, telemetry)
- Mengumpulkan feedback (di CLI: issue tracker, survey)

**Filosofi "Unix Philosophy, Modern Implementation":**

CLI tool yang baik mengikuti prinsip Unix:
1. **Small tools, one job** — `nt` melakukan satu hal (DevOps), bukan semuanya
2. **Composability** — output `nt status` bisa di-pipe ke `jq` atau `grep`
3. **Text streams** — output adalah teks, bukan binary
4. **Exit codes** — 0 = sukses, non-zero = error dengan makna

Tetapi juga modern:
1. **Subcommands** — seperti `git`, `docker`, `kubectl`
2. **Structured output** — bisa JSON, YAML, atau table
3. **Interactive mode** — dengan FZF untuk pemilihan
4. **Auto-completion** — untuk Zsh, Bash
5. **Plugin system** — bisa extend dengan plugin

**Filosofi "Test as Safety Net":**

Untuk 30 developer yang menggunakan tool ini sehari-hari, **test bukan pilihan — ini keharusan**. Setiap bug di produksi berarti:
- Waktu developer terbuang
- Kepercayaan berkurang
- Rollback mungkin diperlukan

Test memberikan **jaring pengaman** untuk refactoring:
- Anda bisa ubah implementasi tanpa takut rusak
- Anda bisa tambah fitur dengan yakin
- Anda bisa refactor dengan aman

**Filosofi "Fail Fast, Fail Informative":**

CLI tool yang baik **gagal cepat** dan **memberi tahu dengan jelas**:
- Validasi input sebelum aksi
- Error message yang actionable (tidak hanya "error")
- Sarankan solusi jika memungkinkan
- Exit code yang bermakna

**Filosofi "Composition over Inheritance" (Unix style):**

```
nt status → jq '.services[] | select(.status=="down")' → nt notify
```

Setiap subcommand adalah **komponen yang bisa digabungkan** dengan tools Unix lain.

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.5 — Fungsi Lanjutan, Testing, Integrasi
# ═══════════════════════════════════════════════════════════

# ─── FUNGSI LANJUTAN ───
# Anonymous function
() {
    local tmp=$(mktemp -d)
    # ... kerja ...
} # langsung dieksekusi

# Hook functions
autoload -Uz add-zsh-hook
chpwd() { echo "Pindah ke: $PWD" }
precmd() { update_git_status }
preexec() { log_command "$1" }
add-zsh-hook chpwd my_chpwd_hook
add-zsh-hook precmd my_precmd_hook
add-zsh-hook preexec my_preexec_hook

# Autoloading
fpath=("$ZDOTDIR/functions" $fpath)
autoload -Uz my_function
my_function  # otomatis load

# Parameter expansion flags
local -a arr=(satu dua tiga)
echo ${(j:,:)arr}     # Join: satu,dua,tiga
echo ${(Oa)arr}       # Sort descending
echo ${(k)assoc}      # Keys
echo ${(v)assoc}      # Values
echo ${(U)arr}        # Uppercase
echo ${(L)arr}        # Lowercase
echo ${(C)str}        # Capitalize

# ─── TESTING ───
# ShellSpec (BDD)
Describe 'my_function'
    It 'returns correct value'
        When call my_function arg
        The output should eq "expected"
        The status should be success
    End
End

# ZUnit (TDD)
function test_my_function() {
    local result=$(my_function arg)
    assert_equal "$result" "expected" "Should return expected"
}

# ─── INTEGRASI ───
# Python
result=$(python3 -c "import json; print(json.dumps({'a': 1}))")
echo "$result" | jq '.a'

# Node.js
version=$(node -e "console.log(process.version)")

# API call
curl -s https://api.example.com/data | jq '.items[] | select(.active)'

# Database
psql -U user -d db --csv -c "SELECT * FROM users"
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **Subcommand** | Perintah sekunder di bawah command utama | `nt deploy`, `nt status` |
| **Dispatcher** | Fungsi yang memilih subcommand | `main() { case $1 in ...` |
| **`$0` handling** | Standar untuk mengetahui lokasi script | `0="${ZERO:-...}"` |
| **Hook** | Fungsi yang dipanggil otomatis pada event | `precmd`, `preexec` |
| **`add-zsh-hook`** | Fungsi untuk menambah hook | `add-zsh-hook precmd fn` |
| **Autoload** | Load fungsi saat pertama dipanggil | `autoload -Uz fn` |
| **`fpath`** | Array lokasi fungsi autoload | `fpath+=(dir)` |
| **Parameter Expansion Flag** | Modifier `(flag)var` untuk manipulasi | `${(U)var}` uppercase |
| **ShellSpec** | Framework testing BDD | `Describe...It...End` |
| **ZUnit** | Framework testing Zsh | `zunit` |
| **BDD** | Behavior-Driven Development | `When call...The output should...` |
| **TDD** | Test-Driven Development | Test dulu, implementasi kemudian |
| **Fixture** | Data test statis | `fixtures/data.json` |
| **Mock** | Pengganti komponen | `mock command` |
| **Stub** | Versi sederhana | `stub curl` |
| **Coverage** | Persentase kode yang di-test | `>80%` |
| **`jq`** | JSON processor | `jq '.key'` |
| **`curl`** | HTTP client | `curl -s URL` |
| **`psql`** | PostgreSQL CLI | `psql -c "query"` |
| **`kubectl`** | Kubernetes CLI | `kubectl get pods` |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Desain Struktur CLI Tool

**Tantangan:** Rancang struktur direktori dan file untuk CLI tool `nt` yang skalabel untuk 8 subcommand dan mudah di-test.

**Jawaban:**

**Struktur Direktori:**

```
nt/
├── bin/
│   └── nt                          # Entry point (executable)
├── lib/
│   ├── core.zsh                    # Core functions (logging, utils)
│   ├── commands/
│   │   ├── status.zsh              # nt status
│   │   ├── deploy.zsh              # nt deploy
│   │   ├── db.zsh                  # nt db
│   │   ├── k8s.zsh                 # nt k8s
│   │   ├── secrets.zsh             # nt secrets
│   │   ├── report.zsh              # nt report
│   │   ├── debug.zsh               # nt debug
│   │   └── help.zsh                # nt help
│   └── integrations/
│       ├── kubernetes.zsh          # k8s helpers
│       ├── aws.zsh                 # AWS helpers
│       └── database.zsh            # DB helpers
├── completions/
│   └── _nt                         # Zsh completion
├── tests/
│   ├── spec/                       # ShellSpec tests
│   │   ├── status_spec.sh
│   │   ├── deploy_spec.sh
│   │   └── ...
│   ├── fixtures/                   # Test data
│   │   └── status.json
│   └── helpers/
│       └── mocks.zsh               # Mock functions
├── docs/
│   ├── README.md
│   ├── CONTRIBUTING.md
│   └── architecture.md
├── install.sh                      # Install script
├── uninstall.sh                    # Uninstall script
├── Makefile                        # Build/test/release
└── .github/
    └── workflows/
        └── test.yml                # CI/CD
```

**`bin/nt` — Entry Point:**

```zsh
#!/bin/zsh
# ═══════════════════════════════════════════════════════════
# nt — Nusantara Toolkit
# Entry point untuk semua subcommand
# ═══════════════════════════════════════════════════════════

set -euo pipefail

# ─── Standard $0 handling ───
# Memastikan $0 adalah path ke file ini (bukan Zsh binary)
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# ─── Tentukan direktori ───
readonly NT_ROOT="${0:A:h:h}"    # Dua level ke atas: bin/nt → nt/
readonly NT_LIB="$NT_ROOT/lib"
readonly NT_VERSION="1.0.0"

# ─── Load core ───
source "$NT_LIB/core.zsh"

# ─── Load integrations ───
for integration in "$NT_LIB/integrations"/*.zsh(N); do
    source "$integration"
done

# ─── Load commands ───
typeset -gA NT_COMMANDS
for cmd_file in "$NT_LIB/commands"/*.zsh(N); do
    local cmd_name="${cmd_file:t:r}"  # basename tanpa .zsh
    source "$cmd_file"
    NT_COMMANDS[$cmd_name]="$cmd_file"
done

# ─── Dispatcher ───
nt_dispatch() {
    local command="${1:-help}"
    shift || true
    
    # Cek apakah command dikenal
    if [[ -z "${NT_COMMANDS[$command]:-}" ]]; then
        nt_error "Command tidak dikenal: $command"
        nt_help
        return 1
    fi
    
    # Panggil fungsi dengan prefix "nt_cmd_"
    local func="nt_cmd_${command}"
    
    if (( $+functions[$func] )); then
        "$func" "$@"
    else
        nt_error "Fungsi tidak ditemukan: $func"
        return 1
    fi
}

# ─── Main ───
nt_dispatch "$@"
```

**`lib/core.zsh` — Core Functions:**

```zsh
# lib/core.zsh — Core functions untuk semua subcommand

# ═══════════════════════════════════════════════════════════
# KONSTANTA
# ═══════════════════════════════════════════════════════════
readonly NT_LOG_FILE="${NT_LOG_FILE:-$HOME/.nt/log}"
readonly NT_CONFIG_FILE="${NT_CONFIG_FILE:-$HOME/.nt/config}"
readonly NT_CACHE_DIR="${NT_CACHE_DIR:-$HOME/.cache/nt}"

mkdir -p "${NT_LOG_FILE:h}" "$NT_CACHE_DIR" 2>/dev/null

# ═══════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════
nt_log() {
    local level="$1"; shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    printf '[%s] [%-5s] %s\n' "$timestamp" "$level" "$message" >> "$NT_LOG_FILE"
}

nt_debug() { [[ "${NT_DEBUG:-0}" == "1" ]] && echo "🔍 $*" >&2; }
nt_info()  { echo "ℹ️  $*"; nt_log "INFO" "$*"; }
nt_warn()  { echo "⚠️  $*" >&2; nt_log "WARN" "$*"; }
nt_error() { echo "❌ $*" >&2; nt_log "ERROR" "$*"; }
nt_ok()    { echo "✅ $*"; nt_log "OK" "$*"; }

# ═══════════════════════════════════════════════════════════
# OUTPUT FORMATTING
# ═══════════════════════════════════════════════════════════
nt_output_json() {
    # Kirim JSON ke stdout
    echo "$1"
}

nt_output_table() {
    # Simple table formatting
    local header=("$1"); shift
    local rows=("$@")
    
    printf '%s\n' "${header[@]}" | column -t -s$'\t'
}

# ═══════════════════════════════════════════════════════════
# VALIDASI
# ═══════════════════════════════════════════════════════════
nt_validate_environment() {
    local env="$1"
    case "$env" in
        dev|staging|production) return 0 ;;
        *) nt_error "Environment tidak valid: $env (harus: dev, staging, production)"
           return 1 ;;
    esac
}

nt_validate_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        nt_error "$cmd tidak terinstall"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════
# CONFIRMATION
# ═══════════════════════════════════════════════════════════
nt_confirm() {
    local message="$1"
    local reply
    
    if [[ "${NT_YES:-0}" == "1" ]]; then
        return 0
    fi
    
    read -q "reply?${message} (y/n) " 
    echo
    [[ "$reply" == "y" ]]
}

# ═══════════════════════════════════════════════════════════
# HELP
# ═══════════════════════════════════════════════════════════
nt_help() {
    cat <<EOF
nt — Nusantara Toolkit v$NT_VERSION

Penggunaan: nt <command> [options]

Commands:
    status              Cek status semua service
    deploy <env> <svc>  Deploy service ke environment
    db <action>         Interaksi dengan database
    k8s <action>        Interaksi dengan Kubernetes
    secrets <action>    Manajemen secrets
    report <period>     Generate laporan
    debug <service>     Debug interaktif
    help                Tampilkan bantuan ini

Environment Variables:
    NT_DEBUG=1          Aktifkan debug mode
    NT_YES=1            Auto-confirm untuk semua prompt
    NT_LOG_FILE=<path>  Lokasi log file

Examples:
    nt status
    nt deploy staging api --version v1.2.3
    nt db query "SELECT * FROM users LIMIT 10"
    nt k8s pods --context production-cluster

Dokumentasi: https://docs.nusantara.tech/nt
EOF
}
```

**`lib/commands/status.zsh` — Contoh Subcommand:**

```zsh
# lib/commands/status.zsh — Subcommand: nt status

nt_cmd_status() {
    local output_format="table"
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --json) output_format="json"; shift ;;
            --format=*) output_format="${1#*=}"; shift ;;
            -h|--help)
                cat <<EOF
Penggunaan: nt status [options]

Options:
    --json              Output dalam format JSON
    --format=<fmt>      Format output (table, json, yaml)
    -h, --help          Tampilkan bantuan ini
EOF
                return 0
                ;;
            *) nt_error "Option tidak dikenal: $1"; return 1 ;;
        esac
    done
    
    nt_info "Mengecek status service..."
    
    # Kumpulkan status (mock untuk contoh)
    local -A statuses
    statuses=(
        [api]="running"
        [web]="running"
        [worker]="down"
        [db]="running"
        [cache]="running"
    )
    
    # Build output
    if [[ "$output_format" == "json" ]]; then
        # Convert associative array ke JSON
        local json="{"
        local first=1
        for svc in "${(@k)statuses}"; do
            [[ $first -eq 0 ]] && json+=","
            json+="\"$svc\":\"${statuses[$svc]}\""
            first=0
        done
        json+="}"
        echo "$json" | jq .
    else
        # Table format
        printf '%-12s %s\n' "SERVICE" "STATUS"
        printf '%-12s %s\n' "───────" "──────"
        for svc in "${(@k)statuses}"; do
            local st="${statuses[$svc]}"
            local icon="✅"
            [[ "$st" != "running" ]] && icon="❌"
            printf '%-12s %s %s\n' "$svc" "$icon" "$st"
        done
    fi
}
```

**Penjelasan Mental — Arsitektur Dispatcher:**

CLI tool mengikuti **pola dispatcher**:

```
nt status --json
│  │      │
│  │      └── Argumen (diteruskan ke subcommand)
│  └── Command
└── Binary

       ↓ dispatcher

nt_dispatch("status", "--json")
    ↓
nt_cmd_status("--json")
    ↓
[eksekusi]
```

**Mengapa `nt_cmd_` prefix?**

Karena Zsh memiliki **namespace** terbatas. Dengan prefix `nt_cmd_`:
- Semua fungsi subcommand bisa di-loop: `${(k)functions}` filter `nt_cmd_*`
- Tidak ada konflik dengan fungsi lain
- Mudah di-`unfunction` saat cleanup

**Standard `$0` Handling:**

```zsh
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"
```

Ini terlihat rumit, tapi esensial. Mari kita pecah:

```zsh
# Bagian 1: Coba berbagai cara untuk tahu path script
${ZERO:-}           # Jika $ZERO di-set, gunakan
${0:#$ZSH_ARGZERO}  # Jika $0 = ZSH_ARGZERO (path zsh binary), jangan pakai
${(%):-%N}          # Prompt expansion %N = path absolut script

# Bagian 2: Jika hasil bukan path absolut, gabung dengan $PWD
${${(M)0:#/*}:-$PWD/$0}
```

**Mengapa ini penting?**

Ketika script di-source vs dieksekusi, `$0` bisa berbeda:
- `./nt` → `$0 = ./nt`
- `zsh nt` → `$0 = nt`
- `source nt` → `$0` mungkin path Zsh binary

Standar ini memastikan `$0` selalu berisi path absolut ke script.

**`${0:A:h}` — Absolute dirname:**

- `${0:A}` = absolute path (resolve symlink)
- `${0:A:h}` = dirname dari absolute path

Dengan `readonly NT_ROOT="${0:A:h:h}"`, kita naik 2 level: `nt/bin/nt` → `nt/`.

**Loop Loading Commands:**

```zsh
for cmd_file in "$NT_LIB/commands"/*.zsh(N); do
    local cmd_name="${cmd_file:t:r}"  # basename tanpa .zsh
    source "$cmd_file"
    NT_COMMANDS[$cmd_name]="$cmd_file"
done
```

- `(N)` — null glob (jangan error jika kosong)
- `${cmd_file:t}` — tail (basename): `status.zsh`
- `${cmd_file:t:r}` — tail + remove extension: `status`
- `NT_COMMANDS[$cmd_name]` — daftarkan di associative array

**Keunggulan:** Menambah subcommand cukup dengan menambah file di `commands/`. Tidak perlu ubah `bin/nt`.

**`$+functions[$func]` — Cek fungsi:**

```zsh
if (( $+functions[$func] )); then
    "$func" "$@"
fi
```

`$+functions[name]` = 1 jika fungsi `name` terdefinisi, 0 jika tidak.

Ini lebih cepat dan lebih aman dari `whence -w` atau `type`.

---

### Pertanyaan 2: Fungsi Lanjutan — Anonymous, Hook, Autoload

**Tantangan:** Tunjukkan (a) anonymous function untuk setup temporary directory, (b) hook `chpwd` untuk update status ketika pindah direktori, (c) autoload untuk command `debug` yang jarang digunakan.

**Jawaban:**

```zsh
# lib/core.zsh — Fungsi lanjutan

# ═══════════════════════════════════════════════════════════
# (a) ANONYMOUS FUNCTION — Setup temporary, auto-cleanup
# ═══════════════════════════════════════════════════════════
nt_with_temp_dir() {
    # Anonymous function: () { ... } arg1 arg2
    # Argumen diteruskan ke $@ di dalam blok
    () {
        local temp_dir=$(mktemp -d)
        
        # Trap untuk cleanup otomatis
        trap "rm -rf '$temp_dir'" EXIT
        
        # Set variabel untuk digunakan di blok
        local workdir="$temp_dir"
        
        # Jalankan callback di dalam temp_dir
        cd "$workdir"
        "$@"  # Callback function
    } "$@"
}

# Penggunaan:
nt_with_temp_dir() {
    echo "Bekerja di: $PWD"
    touch file.txt
    ls -la
}
# Setelah blok selesai, temp_dir otomatis dihapus

# ═══════════════════════════════════════════════════════════
# (b) HOOK chpwd — Update status ketika pindah direktori
# ═══════════════════════════════════════════════════════════
# Hook ini HANYA aktif jika NT_AUTO_STATUS=1
if [[ "${NT_AUTO_STATUS:-0}" == "1" ]]; then
    nt_chpwd_hook() {
        # Hanya jalankan jika di direktori project Nusantara
        [[ -f "$PWD/.nt-project" ]] || return 0
        
        # Jalankan status secara background (jangan block)
        (nt status --quick &) 2>/dev/null
    }
    
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd nt_chpwd_hook
fi

# ═══════════════════════════════════════════════════════════
# (c) AUTOLOAD — Command debug jarang digunakan
# ═══════════════════════════════════════════════════════════
# File: lib/commands/debug.zsh
# Tidak di-source saat startup — di-autoload saat dipanggil

# Di bin/nt, jangan source debug.zsh. Sebagai gantinya:
# fpath=("$NT_LIB/commands" $fpath)
# autoload -Uz nt_cmd_debug

# Ketika user menjalankan `nt debug`, Zsh akan:
# 1. Cari file `nt_cmd_debug` di $fpath
# 2. Source file tersebut
# 3. Jalankan fungsi

# lib/commands/debug.zsh:
nt_cmd_debug() {
    local service="$1"
    
    if [[ -z "$service" ]]; then
        nt_error "Penggunaan: nt debug <service>"
        return 1
    fi
    
    nt_info "Debug mode untuk: $service"
    # ... logic ...
}
```

**Penjelasan Mental — Anonymous Function:**

**Sintaks:**
```zsh
() {
    # Blok kode
    echo "argumen: $@"
} arg1 arg2
```

**Kapan pakai:**
1. **Scope terbatas** — ketika Anda butuh blok kode yang tidak perlu nama
2. **Setup/teardown** — dengan trap untuk cleanup
3. **IIFE pattern** — Immediately-Invoked Function Expression

**Keunggulan:**
- Tidak "mengotori" namespace
- Otomatis di-GC (garbage collected) setelah selesai
- Bisa menerima argumen

**Kapan TIDAK pakai:**
- Jika blok akan dipanggil lebih dari sekali
- Jika blok berisi logic yang perlu di-test
- Jika blok sangat panjang (lebih baik named function)

**Hook — `chpwd`:**

Hook adalah **callback** yang dipanggil pada event tertentu. Zsh punya beberapa:

| Hook | Kapan Dipanggil |
|---|---|
| `chpwd` | Setelah `cd` berhasil |
| `precmd` | Sebelum prompt ditampilkan |
| `preexec` | Sebelum command dieksekusi |
| `periodic` | Setiap `PERIOD` detik (jika di-set) |
| `zshaddhistory` | Sebelum command ditambah ke history |

**`add-zsh-hook` — Best Practice:**

```zsh
# ❌ Override (buruk):
chpwd() { my_hook; }

# ✅ add-zsh-hook (baik):
add-zsh-hook chpwd my_hook
```

`add-zsh-hook` memungkinkan **multiple hooks** tanpa konflik:
```zsh
add-zsh-hook chpwd hook_1
add-zsh-hook chpwd hook_2
# Keduanya dipanggil saat chpwd
```

Untuk melepas:
```zsh
add-zsh-hook -d chpwd my_hook
```

**Autoload — Lazy Loading Functions:**

Autoload adalah fitur Zsh yang memungkinkan fungsi **tidak di-load sampai dibutuhkan**:

1. **Setup fpath:**
   ```zsh
   fpath=("$NT_LIB/commands" $fpath)
   ```

2. **Autoload fungsi:**
   ```zsh
   autoload -Uz nt_cmd_debug
   ```

3. **Saat pertama dipanggil:**
   Zsh mencari file `nt_cmd_debug` di `fpath`. Jika ditemukan, source file dan jalankan.

**Keunggulan:**
- **Startup cepat** — hanya load yang dibutuhkan
- **Organized** — setiap fungsi di file terpisah
- **Testable** — bisa di-unit-test secara independen

**Kapan pakai autoload:**
- Fungsi yang **jarang digunakan** (seperti `debug`)
- Fungsi yang **kompleks** dan terpisah
- Fungsi yang ingin **di-maintain secara independen**

**Kapan TIDAK pakai autoload:**
- Fungsi yang **selalu digunakan** (seperti `nt_dispatch`)
- Fungsi yang **saling bergantung** (sulit di-autoload)
- Fungsi yang **sangat kecil** (<10 baris)

**Benchmark Autoload:**

Untuk 8 subcommand:
- **Eager loading**: ~15ms untuk load semua
- **Autoload**: ~2ms startup, +3ms saat pertama panggil

Untuk enterprise, autoload **bisa** menghemat ~13ms — worth it jika fungsi tidak selalu digunakan.

---

### Pertanyaan 3: Testing dengan ShellSpec

**Tantangan:** Tulis test suite untuk subcommand `nt status` menggunakan ShellSpec. Test harus mencakup: (a) output format table, (b) output format JSON, (c) validasi opsi, (d) mock untuk data status.

**Jawaban:**

```zsh
# tests/spec/status_spec.sh — Test untuk nt status

# ═══════════════════════════════════════════════════════════
# SETUP
# ═══════════════════════════════════════════════════════════
# Source the CLI tool
Include lib/core.zsh
Include lib/commands/status.zsh

# ═══════════════════════════════════════════════════════════
# FIXTURES — Mock data status
# ═══════════════════════════════════════════════════════════
# Setup mock untuk command yang dipanggil oleh nt_cmd_status
setup() {
    # Mock kubectl / aws / dll.
    # ShellSpec punya built-in untuk mocking
    Mock kubectl
        echo "api: running"
        echo "web: running"
        echo "worker: down"
    End
}

# ═══════════════════════════════════════════════════════════
# TEST SUITE
# ═══════════════════════════════════════════════════════════
Describe 'nt status'
    BeforeAll 'setup'

    Describe 'output format'
        It 'default menggunakan table'
            When call nt_cmd_status
            The status should be success
            The output should include "SERVICE"
            The output should include "STATUS"
            The output should include "api"
            The output should include "running"
        End

        It 'menampilkan icon untuk service down'
            When call nt_cmd_status
            The output should include "❌"
            The output should include "worker"
        End

        It 'menampilkan icon untuk service running'
            When call nt_cmd_status
            The output should include "✅"
            The output should include "api"
        End
    End

    Describe 'output format JSON'
        It 'menggunakan --json'
            When call nt_cmd_status --json
            The status should be success
            The output should be valid JSON
            The output should include '"api"'
            The output should include '"running"'
        End

        It 'output JSON valid'
            When call nt_cmd_status --json
            The stdout should satisfy "echo \"\$output\" | jq . > /dev/null"
        End

        It 'menggunakan --format=json'
            When call nt_cmd_status --format=json
            The status should be success
            The output should be valid JSON
        End
    End

    Describe 'validasi opsi'
        It 'menolak opsi tidak dikenal'
            When call nt_cmd_status --invalid-option
            The status should be failure
            The stderr should include "Option tidak dikenal"
        End

        It 'menampilkan help dengan -h'
            When call nt_cmd_status -h
            The status should be success
            The output should include "Penggunaan"
            The output should include "--json"
        End

        It 'menampilkan help dengan --help'
            When call nt_cmd_status --help
            The status should be success
            The output should include "Penggunaan"
        End
    End

    Describe 'case sensitivity'
        It 'menerima format case-insensitive'
            When call nt_cmd_status --format=JSON
            The status should be success
            # (Jika implementasi mendukung case-insensitive)
        End
    End
End

# ═══════════════════════════════════════════════════════════
# TEST UNTUK VALIDASI CORE
# ═══════════════════════════════════════════════════════════
Describe 'nt_validate_environment'
    Parameters
        "dev"       success
        "staging"   success
        "production" success
        "invalid"   failure
        ""          failure
        "DEV"       failure  # Case-sensitive
    End

    It "validasi environment: $1 → $2"
        When call nt_validate_environment "$1"
        The status should be "$2"
    End
End
```

**Menjalankan Test:**

```bash
# Install ShellSpec
curl -fsSL https://git.io/shellspec | sh

# Jalankan semua test
shellspec

# Jalankan dengan output verbose
shellspec --format documentation

# Jalankan test spesifik
shellspec tests/spec/status_spec.sh

# Dengan coverage
shellspec --kcov
```

**Output yang Diharapkan:**

```
Running: /bin/zsh [zsh 5.9]

nt status
  output format
    ✓ default menggunakan table
    ✓ menampilkan icon untuk service down
    ✓ menampilkan icon untuk service running
  output format JSON
    ✓ menggunakan --json
    ✓ output JSON valid
    ✓ menggunakan --format=json
  validasi opsi
    ✓ menolak opsi tidak dikenal
    ✓ menampilkan help dengan -h
    ✓ menampilkan help dengan --help

nt_validate_environment
  ✓ validasi environment: dev → success
  ✓ validasi environment: staging → success
  ✓ validasi environment: production → success
  ✓ validasi environment: invalid → failure
  ✓ validasi environment:  → failure
  ✓ validasi environment: DEV → failure

12 examples, 0 failures
```

**Penjelasan Mental — ShellSpec BDD:**

**Struktur:**

```
Describe 'subject'
    Context 'when condition'
        It 'does something'
            When call action
            The result should be expected
        End
    End
End
```

**Pola `When call...The...should...`:**

- `When call <function> <args>` — panggil fungsi
- `The output should include <string>` — assert output
- `The status should be success/failure` — assert exit code
- `The stderr should include <string>` — assert error output

**Matchers yang Tersedia:**

| Matcher | Arti |
|---|---|
| `eq` | Sama dengan |
| `include` | Mengandung |
| `start with` | Dimulai dengan |
| `end with` | Diakhiri dengan |
| `match` | Regex match |
| `be valid JSON` | Valid JSON |
| `be empty` | Kosong |
| `be present` | Ada |

**Mocking:**

```zsh
Mock kubectl
    echo "api: running"
End
```

Setelah `Mock kubectl`, setiap pemanggilan `kubectl` di test akan mengembalikan output yang di-mock.

**Parameters — Test Data-Driven:**

```zsh
Parameters
    "dev"    success
    "prod"   success
    "invalid" failure
End

It "validasi $1 → $2"
    When call nt_validate_environment "$1"
    The status should be "$2"
End
```

Setiap baris `Parameters` menjadi satu test. Ini menghindari duplikasi.

**Coverage:**

ShellSpec mendukung `--kcov` untuk code coverage:
```bash
shellspec --kcov
# Menghasilkan laporan HTML di coverage/
```

Target: **>80% coverage** untuk production code.

**`BeforeAll` vs `Before`:**

- `BeforeAll` — dijalankan **sekali** sebelum semua test di block
- `Before` — dijalankan **sebelum setiap test**

```zsh
Describe 'my function'
    BeforeAll 'setup_database'  # Sekali
    Before 'clear_cache'         # Setiap test
End
```

---

### Pertanyaan 4: Integrasi dengan Python untuk Analisis Kompleks

**Tantangan:** Subcommand `nt report` perlu menganalisis data metrics (JSONL) dan menghasilkan laporan mingguan. Analisis statistik kompleks (mean, median, stddev, trend) lebih mudah dengan Python. Integrasikan Python dengan Zsh CLI tool.

**Jawaban:**

```zsh
# lib/commands/report.zsh — Subcommand: nt report

nt_cmd_report() {
    local period="${1:-weekly}"
    local format="text"
    local output_file=""
    
    # Parse options
    shift || true
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --format=*) format="${1#*=}"; shift ;;
            --output=*) output_file="${1#*=}"; shift ;;
            --json) format="json"; shift ;;
            -h|--help)
                cat <<EOF
Penggunaan: nt report <period> [options]

Periods:
    daily       Laporan harian
    weekly      Laporan mingguan (default)
    monthly     Laporan bulanan

Options:
    --format=<fmt>      Format output (text, json, markdown)
    --output=<file>     Simpan ke file
    --json              Shortcut untuk --format=json
    -h, --help          Tampilkan bantuan ini
EOF
                return 0
                ;;
            *) nt_error "Option tidak dikenal: $1"; return 1 ;;
        esac
    done
    
    # Validasi period
    case "$period" in
        daily|weekly|monthly) ;;
        *) nt_error "Period tidak valid: $period"; return 1 ;;
    esac
    
    local metrics_file="$NT_CACHE_DIR/metrics.jsonl"
    
    if [[ ! -f "$metrics_file" ]]; then
        nt_error "Metrics file tidak ditemukan: $metrics_file"
        nt_info "Jalankan 'nt monitor collect' terlebih dahulu"
        return 1
    fi
    
    nt_info "Menganalisis metrics untuk periode: $period"
    
    # ─── Analisis dengan Python ───
    local analysis
    analysis=$(python3 - "$metrics_file" "$period" <<'PYEOF'
import json
import sys
import statistics
from datetime import datetime, timedelta
from collections import defaultdict

metrics_file = sys.argv[1]
period = sys.argv[2]

# Tentukan rentang waktu
period_days = {"daily": 1, "weekly": 7, "monthly": 30}
days = period_days.get(period, 7)
cutoff = datetime.now() - timedelta(days=days)

# Baca metrics
entries = []
with open(metrics_file) as f:
    for line in f:
        try:
            data = json.loads(line)
            ts = datetime.fromisoformat(data["timestamp"].replace("Z", "+00:00"))
            if ts.replace(tzinfo=None) >= cutoff:
                entries.append(data)
        except (json.JSONDecodeError, KeyError, ValueError):
            continue

if not entries:
    print(json.dumps({"error": "No data for period"}))
    sys.exit(0)

# Analisis
startup_times = [e["startup_ms"] for e in entries if "startup_ms" in e]

result = {
    "period": period,
    "days": days,
    "total_entries": len(entries),
    "unique_users": len(set(e["user"] for e in entries if "user" in e)),
    "startup_ms": {
        "count": len(startup_times),
        "mean": round(statistics.mean(startup_times), 2) if startup_times else 0,
        "median": round(statistics.median(startup_times), 2) if startup_times else 0,
        "stdev": round(statistics.stdev(startup_times), 2) if len(startup_times) > 1 else 0,
        "min": min(startup_times) if startup_times else 0,
        "max": max(startup_times) if startup_times else 0,
        "p95": round(sorted(startup_times)[int(len(startup_times) * 0.95)] if startup_times else 0, 2),
    },
    "anomalies": [],
    "trend": "stable",
}

# Deteksi anomali (startup > 500ms)
for e in entries:
    if e.get("startup_ms", 0) > 500:
        result["anomalies"].append({
            "timestamp": e["timestamp"],
            "user": e.get("user", "unknown"),
            "startup_ms": e["startup_ms"],
        })

# Trend analysis
if len(startup_times) >= 10:
    first_half = startup_times[:len(startup_times)//2]
    second_half = startup_times[len(startup_times)//2:]
    first_avg = statistics.mean(first_half)
    second_avg = statistics.mean(second_half)
    change_pct = ((second_avg - first_avg) / first_avg) * 100
    
    if change_pct > 20:
        result["trend"] = "degrading"
    elif change_pct < -20:
        result["trend"] = "improving"
    else:
        result["trend"] = "stable"
    
    result["trend_change_pct"] = round(change_pct, 1)

print(json.dumps(result, indent=2))
PYEOF
)
    
    if [[ -z "$analysis" ]]; then
        nt_error "Gagal menganalisis metrics"
        return 1
    fi
    
    # ─── Format output ───
    case "$format" in
        json)
            echo "$analysis"
            ;;
        markdown)
            echo "$analysis" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data:
    print(f'# Error: {data[\"error\"]}')
    sys.exit(0)

print(f'# Laporan {data[\"period\"].title()} — Nusantara Toolkit')
print()
print(f'**Total entries:** {data[\"total_entries\"]}')
print(f'**Unique users:** {data[\"unique_users\"]}')
print()
print('## Startup Time')
print()
print('| Metric | Value |')
print('|--------|-------|')
s = data['startup_ms']
print(f'| Mean | {s[\"mean\"]}ms |')
print(f'| Median | {s[\"median\"]}ms |')
print(f'| Std Dev | {s[\"stdev\"]}ms |')
print(f'| Min | {s[\"min\"]}ms |')
print(f'| Max | {s[\"max\"]}ms |')
print(f'| P95 | {s[\"p95\"]}ms |')
print()
if data['anomalies']:
    print(f'## Anomalies ({len(data[\"anomalies\"])})')
    print()
    for a in data['anomalies'][:5]:
        print(f'- {a[\"timestamp\"]}: {a[\"user\"]} — {a[\"startup_ms\"]}ms')
"
            ;;
        text|*)
            echo "$analysis" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data:
    print(f'❌ {data[\"error\"]}')
    sys.exit(0)

print('═' * 50)
print(f'  LAPORAN {data[\"period\"].upper()} — NUSANTARA TOOLKIT')
print('═' * 50)
print()
print(f'  Total entries: {data[\"total_entries\"]}')
print(f'  Unique users: {data[\"unique_users\"]}')
print(f'  Trend: {data[\"trend\"]}' + (f' ({data.get(\"trend_change_pct\", 0)}%)' if 'trend_change_pct' in data else ''))
print()
print('  Startup Time:')
s = data['startup_ms']
print(f'    Mean:   {s[\"mean\"]}ms')
print(f'    Median: {s[\"median\"]}ms')
print(f'    StdDev: {s[\"stdev\"]}ms')
print(f'    Min:    {s[\"min\"]}ms')
print(f'    Max:    {s[\"max\"]}ms')
print(f'    P95:    {s[\"p95\"]}ms')
print()
if data['anomalies']:
    print(f'  ⚠️  Anomalies: {len(data[\"anomalies\"])}')
    for a in data['anomalies'][:3]:
        print(f'    - {a[\"user\"]}: {a[\"startup_ms\"]}ms')
print()
print('═' * 50)
"
            ;;
    esac
    
    # Simpan ke file jika diminta
    if [[ -n "$output_file" ]]; then
        nt_cmd_report "$period" --format="$format" > "$output_file"
        nt_ok "Laporan tersimpan: $output_file"
    fi
}
```

**Penjelasan Mental — Integrasi Zsh ↔ Python:**

**Pola yang Digunakan:**

```
Zsh script
    ↓ (pass data via argument)
Python heredoc (<<'PYEOF')
    ↓ (proses dengan library Python)
JSON output
    ↓ (capture dengan $())
Zsh variable
    ↓ (format dengan jq atau Python lagi)
Final output
```

**Mengapa Python?**

- **Statistik kompleks** — mean, median, stddev, percentile (rumit di awk)
- **Tanggal/waktu** — `datetime` Python jauh lebih powerful dari `date`
- **Parsing JSON** — `json` library lebih mudah dari `jq` untuk logika kompleks
- **Pandas** — untuk analisis yang lebih canggih

**Mengapa bukan Python sepenuhnya?**

- **Startup Python** ~30-50ms vs Zsh ~5ms
- **Shell-specific features** — glob, hook, completion
- **Composability** — pipe ke tools lain lebih mudah di shell

**Heredoc `<<'PYEOF'` vs `<<PYEOF`:**

```zsh
# ❌ Without quotes — variabel Zsh akan di-expand
cat <<PYEOF
print("$USER")  # Zsh akan replace $USER
PYEOF

# ✅ With quotes — literal, no expansion
cat <<'PYEOF'
print("$USER")  # Python akan melihat $USER sebagai string
PYEOF
```

Untuk Python code, **selalu gunakan quotes** `<<'PYEOF'` agar `$` tidak di-expand oleh Zsh.

**Argumen ke Python:**

```zsh
python3 - "$metrics_file" "$period" <<'PYEOF'
import sys
metrics_file = sys.argv[1]
period = sys.argv[2]
PYEOF
```

- `-` = baca dari stdin (heredoc)
- `"$metrics_file"` = argumen pertama → `sys.argv[1]`
- `"$period"` = argumen kedua → `sys.argv[2]`

**Capture Output:**

```zsh
analysis=$(python3 - "$metrics_file" "$period" <<'PYEOF'
...
PYEOF
)
```

`$(...)` menangkap stdout Python ke variabel Zsh.

**Nested Python untuk Format:**

Setelah mendapat JSON dari Python pertama, kita pipe ke Python kedua untuk formatting:

```zsh
echo "$analysis" | python3 -c "
import json, sys
data = json.load(sys.stdin)
# ... format ...
"
```

Ini memisahkan **logic** (analisis) dari **presentation** (formatting) — prinsip yang baik.

**Alternatif dengan jq:**

Untuk formatting sederhana, `jq` lebih cepat:
```zsh
echo "$analysis" | jq -r '
    "Mean: \(.startup_ms.mean)ms",
    "P95: \(.startup_ms.p95)ms"
'
```

Untuk logika kompleks (kondisional, iterasi), Python lebih baik.

**Exit Code Propagation:**

```zsh
local analysis
if ! analysis=$(python3 ...); then
    nt_error "Python script failed"
    return 1
fi
```

Jika Python exit non-zero, Zsh akan menangkap dengan `if !`.

**Best Practice:**

1. **Selalu quote heredoc delimiter** (`<<'PYEOF'`)
2. **Pass data via argumen** (`sys.argv`)
3. **Output JSON** — mudah di-parse oleh `jq` atau Python lagi
4. **Exit 0 pada sukses, non-zero pada error**
5. **Jangan embed Python terlalu panjang** — jika >50 baris, pisah ke file `.py`

---

### Pertanyaan 5: Integrasi dengan API Eksternal

**Tantangan:** Subcommand `nt k8s` perlu berinteraksi dengan Kubernetes API. Buat wrapper yang: (a) memvalidasi koneksi, (b) menangani error HTTP, (c) retry dengan exponential backoff, (d) caching untuk query yang sering.

**Jawaban:**

```zsh
# lib/integrations/kubernetes.zsh — Integrasi Kubernetes

# ═══════════════════════════════════════════════════════════
# KONFIGURASI
# ═══════════════════════════════════════════════════════════
readonly K8S_CACHE_TTL=60     # Cache valid 60 detik
readonly K8S_MAX_RETRIES=3
readonly K8S_RETRY_DELAY=2    # Detik, akan di-double setiap retry

# ═══════════════════════════════════════════════════════════
# FUNGSI: Cek koneksi Kubernetes
# ═══════════════════════════════════════════════════════════
k8s_check_connection() {
    local context="${1:-$(kubectl config current-context 2>/dev/null)}"
    
    if [[ -z "$context" ]]; then
        nt_error "Tidak ada Kubernetes context"
        return 1
    fi
    
    # Timeout 5 detik
    if ! timeout 5 kubectl --context="$context" cluster-info &>/dev/null; then
        nt_error "Tidak bisa koneksi ke cluster: $context"
        return 1
    fi
    
    return 0
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Retry dengan exponential backoff
# ═══════════════════════════════════════════════════════════
k8s_retry() {
    local max_retries="$1"
    shift
    local command=("$@")
    
    local attempt=0
    local delay=$K8S_RETRY_DELAY
    
    while [[ $attempt -lt $max_retries ]]; do
        if "${command[@]}" 2>/dev/null; then
            return 0
        fi
        
        (( ++attempt ))
        
        if [[ $attempt -lt $max_retries ]]; then
            nt_warn "Attempt $attempt gagal, retry dalam ${delay}s..."
            sleep "$delay"
            (( delay *= 2 ))
        fi
    done
    
    nt_error "Gagal setelah $max_retries percobaan"
    return 1
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: Cache
# ═══════════════════════════════════════════════════════════
k8s_cache_get() {
    local key="$1"
    local cache_file="$NT_CACHE_DIR/k8s-${key}.json"
    
    if [[ -f "$cache_file" ]]; then
        local age=$(( $(date +%s) - $(stat -c '%Y' "$cache_file" 2>/dev/null || stat -f '%m' "$cache_file") ))
        if [[ $age -lt $K8S_CACHE_TTL ]]; then
            cat "$cache_file"
            return 0
        fi
    fi
    
    return 1
}

k8s_cache_set() {
    local key="$1"
    local value="$2"
    local cache_file="$NT_CACHE_DIR/k8s-${key}.json"
    
    echo "$value" > "$cache_file"
}

# ═══════════════════════════════════════════════════════════
# API WRAPPER
# ═══════════════════════════════════════════════════════════
k8s_get_pods() {
    local namespace="${1:-default}"
    local context="${2:-}"
    local use_cache="${3:-true}"
    
    local cache_key="pods-${context}-${namespace}"
    
    # Coba cache
    if [[ "$use_cache" == "true" ]]; then
        if cached=$(k8s_cache_get "$cache_key"); then
            nt_debug "Cache hit: $cache_key"
            echo "$cached"
            return 0
        fi
    fi
    
    # Build command
    local -a cmd=(kubectl)
    [[ -n "$context" ]] && cmd+=(--context="$context")
    cmd+=(-n "$namespace" get pods -o json)
    
    # Jalankan dengan retry
    local result
    if ! result=$(k8s_retry "$K8S_MAX_RETRIES" "${cmd[@]}"); then
        return 1
    fi
    
    # Simpan cache
    k8s_cache_set "$cache_key" "$result"
    
    echo "$result"
}

# ═══════════════════════════════════════════════════════════
# SUBCOMMAND: nt k8s
# ═══════════════════════════════════════════════════════════
nt_cmd_k8s() {
    local action="${1:-help}"
    shift || true
    
    case "$action" in
        pods)
            nt_k8s_pods "$@"
            ;;
        contexts)
            nt_k8s_contexts "$@"
            ;;
        switch)
            nt_k8s_switch "$@"
            ;;
        help|-h|--help)
            cat <<EOF
Penggunaan: nt k8s <action> [options]

Actions:
    pods [namespace]     List pods
    contexts             List semua context
    switch [context]     Ganti context

Options:
    --context=<ctx>      Kubernetes context
    --namespace=<ns>     Namespace (default: default)
    --no-cache           Skip cache
    --json               Output JSON
    -h, --help           Tampilkan bantuan
EOF
            ;;
        *) nt_error "Action tidak dikenal: $action"; return 1 ;;
    esac
}

nt_k8s_pods() {
    local namespace="default"
    local context=""
    local output="table"
    local use_cache="true"
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --context=*) context="${1#*=}"; shift ;;
            --namespace=*) namespace="${1#*=}"; shift ;;
            --json) output="json"; shift ;;
            --no-cache) use_cache="false"; shift ;;
            -*) nt_error "Option tidak dikenal: $1"; return 1 ;;
            *) namespace="$1"; shift ;;
        esac
    done
    
    nt_info "Mengambil pods dari namespace: $namespace"
    
    if ! k8s_check_connection "$context"; then
        return 1
    fi
    
    local result
    if ! result=$(k8s_get_pods "$namespace" "$context" "$use_cache"); then
        return 1
    fi
    
    if [[ "$output" == "json" ]]; then
        echo "$result"
    else
        # Format table
        echo "$result" | jq -r '
            .items[] | 
            [.metadata.name, .status.phase, .spec.nodeName] | 
            @tsv
        ' | column -t -s$'\t' | {
            printf '%-40s %-12s %s\n' "NAME" "STATUS" "NODE"
            printf '%-40s %-12s %s\n' "────" "──────" "────"
            cat
        }
    fi
}

nt_k8s_contexts() {
    nt_info "Kubernetes contexts:"
    kubectl config get-contexts
}

nt_k8s_switch() {
    local context="${1:-}"
    
    if [[ -z "$context" ]]; then
        # Interactive dengan FZF
        if command -v fzf &>/dev/null; then
            context=$(kubectl config get-contexts -o name | fzf --prompt="Pilih context: ")
        else
            nt_error "FZF tidak tersedia, sebutkan context: nt k8s switch <context>"
            return 1
        fi
    fi
    
    [[ -z "$context" ]] && return 1
    
    if ! kubectl config use-context "$context"; then
        nt_error "Gagal switch ke: $context"
        return 1
    fi
    
    nt_ok "Context: $context"
}
```

**Penjelasan Mental — Integrasi API Robust:**

**Tiga Pilar API Integration:**

1. **Connection Validation** — cek koneksi sebelum aksi
2. **Error Handling** — retry, timeout, fallback
3. **Caching** — hindari request berulang

**Connection Check:**

```zsh
if ! timeout 5 kubectl cluster-info &>/dev/null; then
    nt_error "Tidak bisa koneksi"
    return 1
fi
```

- `timeout 5` — batas 5 detik (mencegah hang)
- `&>/dev/null` — suppress output
- `!` — negasi: jika gagal, return error

**Exponential Backoff:**

```
Attempt 1: gagal → sleep 2s
Attempt 2: gagal → sleep 4s
Attempt 3: gagal → sleep 8s → give up
```

**Mengapa exponential?** Karena kegagalan network sering karena **overload**. Retry cepat memperburuk masalah. Backoff memberi waktu untuk recovery.

**Caching Pattern:**

```zsh
# 1. Cek cache dulu
if cached=$(k8s_cache_get "$key"); then
    echo "$cached"
    return 0
fi

# 2. Fetch dari API
result=$(k8s_api_call)

# 3. Simpan ke cache
k8s_cache_set "$key" "$result"

# 4. Return
echo "$result"
```

**Cache TTL:**

```zsh
local age=$(( $(date +%s) - $(stat -c '%Y' "$cache_file") ))
if [[ $age -lt $K8S_CACHE_TTL ]]; then
    cat "$cache_file"
    return 0
fi
```

- `stat -c '%Y'` — mtime dalam Unix timestamp
- `date +%s` — Unix timestamp saat ini
- `age = now - mtime`

**Invalidasi Cache:**

Cache harus di-invalidate ketika:
- User meminta `--no-cache`
- TTL expired
- Ada operasi yang mengubah state (create, delete)

**Retry dengan `command` Array:**

```zsh
local -a cmd=(kubectl)
cmd+=(--context="$context")
cmd+=(-n "$namespace" get pods -o json)

k8s_retry "$K8S_MAX_RETRIES" "${cmd[@]}"
```

Menggunakan array untuk command memiliki keunggulan:
- **Aman dari quoting** — setiap elemen adalah satu argumen
- **Mudah di-inspect** — `echo "${cmd[@]}"`
- **Dinamis** — bisa di-`+=` untuk menambah argumen

**Versus command string:**

```zsh
# ❌ Tidak aman jika ada spasi di nilai
local cmd="kubectl -n $namespace get pods"
$cmd  # Word splitting!

# ✅ Aman
local -a cmd=(kubectl -n "$namespace" get pods)
"${cmd[@]}"
```

**JSON Parsing dengan `jq`:**

```zsh
echo "$result" | jq -r '
    .items[] | 
    [.metadata.name, .status.phase, .spec.nodeName] | 
    @tsv
'
```

- `.items[]` — iterasi array
- `[field1, field2, field3]` — buat array baru
- `@tsv` — output sebagai TSV (tab-separated)
- `-r` — raw output (tanpa quotes)

**Table Formatting:**

```zsh
| column -t -s$'\t' | {
    printf '%-40s %-12s %s\n' "NAME" "STATUS" "NODE"
    printf '%-40s %-12s %s\n' "────" "──────" "────"
    cat
}
```

- `column -t -s$'\t'` — align columns
- `printf '%-40s'` — left-align, 40 char width
- Pipe ke block untuk menambahkan header

**Cache Directory:**

```zsh
readonly NT_CACHE_DIR="${NT_CACHE_DIR:-$HOME/.cache/nt}"
mkdir -p "$NT_CACHE_DIR"
```

Mengikuti XDG Base Directory:
- `~/.cache/` untuk cache (bisa dihapus)
- `~/.config/` untuk konfigurasi
- `~/.local/share/` untuk data

**Cleanup Cache:**

```zsh
# Hapus cache lebih tua dari 7 hari
find "$NT_CACHE_DIR" -type f -mtime +7 -delete
```

Ini bisa dijalankan di cron atau saat startup.

---

### Pertanyaan 6: Completion untuk CLI Tool

**Tantangan:** Tulis completion function `_nt` yang: (a) melengkapi subcommand, (b) melengkapi opsi spesifik per subcommand, (c) melengkapi environment dan service dari konfigurasi dinamis, (d) mendukung `--context` untuk k8s.

**Jawaban:**

```zsh
# completions/_nt — Completion untuk nt

#compdef nt

_nt() {
    local -a subcommands
    local -a environments
    local -a services
    local context state line
    typeset -A opt_args

    # ═══════════════════════════════════════════════════════════
    # DATA DINAMIS
    # ═══════════════════════════════════════════════════════════
    
    subcommands=(
        'status:Cek status semua service'
        'deploy:Deploy service ke environment'
        'db:Interaksi dengan database'
        'k8s:Interaksi dengan Kubernetes'
        'secrets:Manajemen secrets'
        'report:Generate laporan'
        'debug:Debug interaktif'
        'help:Tampilkan bantuan'
    )

    environments=(
        'dev:Development environment'
        'staging:Staging environment'
        'production:Production environment (requires approval)'
    )

    # Ambil services dari config
    if [[ -f "$HOME/.nt/services.conf" ]]; then
        while IFS= read -r svc; do
            [[ -z "$svc" || "$svc" == \#* ]] && continue
            services+=("$svc")
        done < "$HOME/.nt/services.conf"
    else
        services=(api web worker db cache)
    fi

    # ═══════════════════════════════════════════════════════════
    # PARSING ARGUMEN
    # ═══════════════════════════════════════════════════════════
    
    _arguments -C \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]' \
        '(-v --version)'{-v,--version}'[Tampilkan versi]' \
        '--debug[Aktifkan debug mode]' \
        '1:subcommand:->subcommand' \
        '*::args:->args'

    case "$state" in
        subcommand)
            _describe -t subcommands 'subcommand' subcommands
            ;;
        args)
            local subcmd="${words[1]}"
            case "$subcmd" in
                deploy)
                    _nt_deploy
                    ;;
                db)
                    _nt_db
                    ;;
                k8s)
                    _nt_k8s
                    ;;
                secrets)
                    _nt_secrets
                    ;;
                report)
                    _nt_report
                    ;;
                debug)
                    _nt_debug
                    ;;
                status)
                    _arguments \
                        '--json[Output JSON]' \
                        '--format=[Format output]:format:(table json yaml)'
                    ;;
                *)
                    _default
                    ;;
            esac
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════
# COMPLETION SUBCOMMAND
# ═══════════════════════════════════════════════════════════

_nt_deploy() {
    local -a environments services versions
    
    environments=(
        'dev:Development'
        'staging:Staging'
        'production:Production'
    )
    
    # Services dari config
    if [[ -f "$HOME/.nt/services.conf" ]]; then
        services=(${(f)"$(grep -v '^#' "$HOME/.nt/services.conf" | grep -v '^$')"})
    else
        services=(api web worker)
    fi
    
    # Versions dari Git tags (jika di repo)
    if git rev-parse --git-dir &>/dev/null; then
        versions=(${(f)"$(git tag --sort=-v:refname | head -20)"})
    fi
    
    _arguments \
        '1:environment:->env' \
        '2:service:->svc' \
        '--version=[Version tag]:version:->ver' \
        '--dry-run[Simulate deployment]' \
        '--force[Force deployment]' \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]'
    
    case "$state" in
        env) _describe -t environments 'environment' environments ;;
        svc) _describe -t services 'service' services ;;
        ver)
            if [[ ${#versions[@]} -gt 0 ]]; then
                _describe -t versions 'version' versions
            else
                _message 'version tag'
            fi
            ;;
    esac
}

_nt_db() {
    local -a actions
    actions=(
        'query:Jalankan SQL query'
        'list:Tampilkan daftar tabel'
        'schema:Tampilkan schema'
        'backup:Backup database'
        'restore:Restore dari backup'
    )
    
    _arguments \
        '1:action:->action' \
        '--database=[Database name]:db:_nt_db_names' \
        '--format=[Output format]:format:(table json csv)' \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]'
    
    case "$state" in
        action) _describe -t actions 'action' actions ;;
    esac
}

_nt_db_names() {
    local -a databases
    databases=(main users logs analytics)
    _describe -t databases 'database' databases
}

_nt_k8s() {
    local -a actions
    actions=(
        'pods:List pods'
        'contexts:List contexts'
        'switch:Ganti context'
        'logs:Tampilkan logs'
        'exec:Exec ke pod'
    )
    
    _arguments \
        '1:action:->action' \
        '--context=[K8s context]:context:_nt_k8s_contexts' \
        '--namespace=[Namespace]:namespace:_nt_k8s_namespaces' \
        '--json[Output JSON]' \
        '--no-cache[Skip cache]' \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]'
    
    case "$state" in
        action) _describe -t actions 'action' actions ;;
    esac
}

_nt_k8s_contexts() {
    local -a contexts
    contexts=(${(f)"$(kubectl config get-contexts -o name 2>/dev/null)"})
    _describe -t contexts 'context' contexts
}

_nt_k8s_namespaces() {
    local context=""
    local -a namespaces
    
    # Extract --context dari command line
    local i
    for (( i = 1; i <= ${#words}; i++ )); do
        if [[ "${words[i]}" == --context=* ]]; then
            context="${words[i]#--context=}"
            break
        fi
    done
    
    if [[ -n "$context" ]]; then
        namespaces=(${(f)"$(kubectl --context="$context" get namespaces -o name 2>/dev/null | sed 's/namespace\///')"})
    else
        namespaces=(${(f)"$(kubectl get namespaces -o name 2>/dev/null | sed 's/namespace\///')"})
    fi
    
    _describe -t namespaces 'namespace' namespaces
}

_nt_secrets() {
    local -a actions
    actions=(
        'list:List secrets'
        'get:Ambil secret'
        'set:Set secret'
        'delete:Hapus secret'
        'rotate:Rotasi secret'
    )
    
    _arguments \
        '1:action:->action' \
        '--vault=[Vault backend]:vault:(1password vault sops)' \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]'
    
    case "$state" in
        action) _describe -t actions 'action' actions ;;
    esac
}

_nt_report() {
    local -a periods
    periods=(
        'daily:Laporan harian'
        'weekly:Laporan mingguan'
        'monthly:Laporan bulanan'
    )
    
    _arguments \
        '1:period:->period' \
        '--format=[Output format]:format:(text json markdown)' \
        '--output=[Output file]:file:_files' \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]'
    
    case "$state" in
        period) _describe -t periods 'period' periods ;;
    esac
}

_nt_debug() {
    local -a services
    services=(api web worker db cache)
    _arguments \
        '1:service:->service' \
        '--tail=[Number of lines]:lines:(10 50 100 500)' \
        '--follow[Follow log output]' \
        '(-h --help)'{-h,--help}'[Tampilkan bantuan]'
    
    case "$state" in
        service) _describe -t services 'service' services ;;
    esac
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
_nt "$@"
```

**Penjelasan Mental — Completion sebagai UX:**

**Tiga Level Completion:**

1. **Level 1: Subcommand** — `nt <TAB>` → status, deploy, db, ...
2. **Level 2: Argumen** — `nt deploy <TAB>` → dev, staging, production
3. **Level 3: Opsi** — `nt deploy --<TAB>` → --version, --dry-run, ...

**Struktur `_arguments`:**

```
'1:subcommand:->subcommand'
 │ │          │
 │ │          └── State untuk case
 │ └── Deskripsi
 └── Posisi argumen
```

**Nested Completion:**

Ketika user mengetik `nt deploy dev <TAB>`, Zsh memanggil:
1. `_nt` dengan `words=(nt deploy dev)`
2. `_nt` menganalisis `words[1]=deploy` → panggil `_nt_deploy`
3. `_nt_deploy` menganalisis posisi → complete service

**Dynamic Completion — Ambil dari Config:**

```zsh
if [[ -f "$HOME/.nt/services.conf" ]]; then
    services=(${(f)"$(grep -v '^#' "$HOME/.nt/services.conf" | grep -v '^$')"})
fi
```

- `$(...)` — command substitution
- `(f)` — split per newline (flag `f`)
- `services=(...)` — assign ke array

**Versions dari Git Tags:**

```zsh
versions=(${(f)"$(git tag --sort=-v:refname | head -20)"})
```

- `--sort=-v:refname` — sort versi terbaru dulu (v2.0 > v1.9)
- `head -20` — ambil 20 terbaru

**Completion untuk K8s Context — Dinamis:**

```zsh
_nt_k8s_contexts() {
    local -a contexts
    contexts=(${(f)"$(kubectl config get-contexts -o name 2>/dev/null)"})
    _describe -t contexts 'context' contexts
}
```

Setiap kali user mengetik `--context=<TAB>`, Zsh memanggil `kubectl` untuk mendapatkan daftar context terbaru. Ini **dinamis** — selalu up-to-date.

**Extract `--context` dari Command Line:**

```zsh
for (( i = 1; i <= ${#words}; i++ )); do
    if [[ "${words[i]}" == --context=* ]]; then
        context="${words[i]#--context=}"
        break
    fi
done
```

Untuk completion namespace, kita perlu tahu context yang dipilih. Kita extract dari `$words`.

**Installation:**

Completion file harus di `fpath`. Untuk enterprise, install ke `/usr/local/share/zsh/site-functions/` atau di `~/.config/zsh/functions/`.

```bash
# Install completion
cp completions/_nt ~/.config/zsh/functions/_nt

# Pastikan fpath include direktori
# (sudah di .zshrc)
```

Setelah `compinit`, Zsh akan mencari `_nt` ketika user mengetik `nt <TAB>`.

**Best Practice Completion:**

1. **Berikan deskripsi** — `'status:Cek status semua service'`
2. **Dynamic jika memungkinkan** — ambil dari config/API
3. **Jangan block** — `2>/dev/null` untuk command yang mungkin gagal
4. **Cache jika lambat** — untuk API yang lambat, cache hasil
5. **Test dengan `zsh -f`** — memastikan completion bekerja tanpa config lain

---

### Pertanyaan 7: CI/CD untuk CLI Tool

**Tantangan:** Setup GitHub Actions untuk CLI tool `nt` yang: (a) menjalankan test di berbagai OS, (b) menjalankan ShellCheck, (c) mengukur coverage, (d) build release.

**Jawaban:**

```yaml
# .github/workflows/test.yml — CI untuk nt

name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    # Jalankan setiap hari jam 9 pagi (untuk deteksi regression)
    - cron: '0 9 * * *'

jobs:
  shellcheck:
    name: ShellCheck
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install ShellCheck
        run: sudo apt-get install -y shellcheck
      
      - name: Run ShellCheck
        run: |
          shellcheck --shell=zsh --severity=warning \
            bin/nt \
            lib/**/*.zsh \
            tests/**/*.zsh

  test:
    name: Test (${{ matrix.os }}, Zsh ${{ matrix.zsh }})
    needs: shellcheck
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest]
        zsh: ['5.8', '5.9']
        exclude:
          # macOS tidak support install Zsh 5.8 via apt
          - os: macos-latest
            zsh: '5.8'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Zsh ${{ matrix.zsh }}
        if: matrix.os == 'ubuntu-latest'
        run: |
          sudo apt-get update
          sudo apt-get install -y zsh
          # Untuk versi spesifik, build dari source (disingkat)
      
      - name: Install Zsh (macOS)
        if: matrix.os == 'macos-latest'
        run: |
          brew install zsh
      
      - name: Verify Zsh version
        run: zsh --version
      
      - name: Install ShellSpec
        run: |
          curl -fsSL https://git.io/shellspec | sh -s -- --yes
          sudo ln -sf $PWD/shellspec /usr/local/bin/shellspec
      
      - name: Install dependencies
        run: |
          if [[ "${{ matrix.os }}" == "ubuntu-latest" ]]; then
            sudo apt-get install -y jq
          else
            brew install jq
          fi
      
      - name: Run tests
        run: shellspec --format documentation
      
      - name: Run tests with coverage
        if: matrix.os == 'ubuntu-latest' && matrix.zsh == '5.9'
        run: |
          sudo apt-get install -y kcov
          shellspec --kcov
      
      - name: Upload coverage to Codecov
        if: matrix.os == 'ubuntu-latest' && matrix.zsh == '5.9'
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage/coverage.json
          fail_ci_if_error: false

  integration:
    name: Integration Test
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Zsh
        run: sudo apt-get install -y zsh jq
      
      - name: Install nt
        run: ./install.sh --prefix=/usr/local
      
      - name: Verify installation
        run: |
          which nt
          nt --version
          nt help
      
      - name: Test subcommand (with mock)
        run: |
          # Setup mock untuk kubectl
          mkdir -p /tmp/mock-bin
          cat > /tmp/mock-bin/kubectl <<'EOF'
          #!/bin/zsh
          echo '{"items":[]}'
          EOF
          chmod +x /tmp/mock-bin/kubectl
          
          export PATH="/tmp/mock-bin:$PATH"
          nt status --json | jq .

  release:
    name: Release
    needs: [test, integration]
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Untuk changelog
      
      - name: Generate changelog
        id: changelog
        run: |
          # Generate changelog dari git log
          PREV_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
          if [[ -n "$PREV_TAG" ]]; then
            CHANGELOG=$(git log --pretty=format:"- %s (%h)" $PREV_TAG..HEAD)
          else
            CHANGELOG=$(git log --pretty=format:"- %s (%h)")
          fi
          echo "changelog<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGELOG" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT
      
      - name: Create tarball
        run: |
          VERSION=${GITHUB_REF#refs/tags/}
          tar -czf "nt-${VERSION}.tar.gz" \
            bin/ lib/ completions/ docs/ install.sh uninstall.sh
      
      - name: Create release
        uses: softprops/action-gh-release@v2
        with:
          body: ${{ steps.changelog.outputs.changelog }}
          files: nt-*.tar.gz
```

**`Makefile` — Build Automation:**

```makefile
# Makefile — Build dan test automation

.PHONY: help test lint coverage install uninstall clean

SHELL := /bin/zsh

help:
	@echo "Targets:"
	@echo "  test       Jalankan semua test"
	@echo "  lint       Jalankan ShellCheck"
	@echo "  coverage   Test dengan coverage"
	@echo "  install    Install nt ke /usr/local"
	@echo "  uninstall  Hapus nt"
	@echo "  clean      Hapus cache dan coverage"

test:
	@echo "🧪 Running tests..."
	@shellspec --format documentation

lint:
	@echo "🔍 Running ShellCheck..."
	@shellcheck --shell=zsh --severity=warning bin/nt lib/**/*.zsh tests/**/*.zsh

coverage:
	@echo "📊 Running with coverage..."
	@shellspec --kcov

install:
	@echo "📦 Installing nt..."
	@./install.sh --prefix=/usr/local

uninstall:
	@echo "🗑️  Uninstalling nt..."
	@./uninstall.sh --prefix=/usr/local

clean:
	@echo "🧹 Cleaning..."
	@rm -rf coverage .shellspec-cache
	@rm -rf ~/.cache/nt

# Build: shellcheck + test
build: lint test
	@echo "✅ Build selesai"
```

**`install.sh` — Install Script:**

```zsh
#!/bin/zsh
# install.sh — Install nt CLI tool

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# KONFIGURASI
# ═══════════════════════════════════════════════════════════
readonly SCRIPT_DIR="${0:A:h}"
PREFIX="/usr/local"
USER_INSTALL=0

# ═══════════════════════════════════════════════════════════
# PARSE ARGS
# ═══════════════════════════════════════════════════════════
while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix=*) PREFIX="${1#*=}"; shift ;;
        --user) PREFIX="$HOME/.local"; USER_INSTALL=1; shift ;;
        -h|--help)
            cat <<EOF
Penggunaan: install.sh [options]

Options:
    --prefix=<dir>   Install ke direktori (default: /usr/local)
    --user           Install ke ~/.local (tidak butuh sudo)
    -h, --help       Tampilkan bantuan
EOF
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

readonly INSTALL_DIR="$PREFIX/share/nt"
readonly BIN_DIR="$PREFIX/bin"

# ═══════════════════════════════════════════════════════════
# INSTALL
# ═══════════════════════════════════════════════════════════
echo "📦 Installing nt to $PREFIX..."

# Buat direktori
if [[ $USER_INSTALL -eq 0 ]]; then
    sudo mkdir -p "$INSTALL_DIR" "$BIN_DIR"
    sudo cp -r "$SCRIPT_DIR"/{bin,lib,completions} "$INSTALL_DIR/"
    sudo ln -sf "$INSTALL_DIR/bin/nt" "$BIN_DIR/nt"
else
    mkdir -p "$INSTALL_DIR" "$BIN_DIR"
    cp -r "$SCRIPT_DIR"/{bin,lib,completions} "$INSTALL_DIR/"
    ln -sf "$INSTALL_DIR/bin/nt" "$BIN_DIR/nt"
fi

# Install completion
local fpath_dir="$PREFIX/share/zsh/site-functions"
mkdir -p "$fpath_dir" 2>/dev/null || sudo mkdir -p "$fpath_dir"
cp "$SCRIPT_DIR/completions/_nt" "$fpath_dir/" 2>/dev/null || \
    sudo cp "$SCRIPT_DIR/completions/_nt" "$fpath_dir/"

# ═══════════════════════════════════════════════════════════
# VERIFY
# ═══════════════════════════════════════════════════════════
echo ""
echo "✅ Instalasi selesai!"
echo ""
echo "Verifikasi:"
echo "  nt --version"
echo "  nt help"
echo ""

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "⚠️  $BIN_DIR tidak ada di PATH"
    echo "   Tambahkan ke .zshrc:"
    echo "   export PATH=\"$BIN_DIR:\$PATH\""
fi
```

**Penjelasan Mental — CI/CD sebagai Safety Net:**

**Multi-OS Testing:**

```yaml
matrix:
  os: [ubuntu-latest, macos-latest]
  zsh: ['5.8', '5.9']
```

Mengapa multi-OS?
- **Zsh berperilaku berbeda** di macOS vs Linux (BSD vs GNU tools)
- **Command ketersediaan** berbeda (`stat`, `date -r`, dll.)
- **File path** berbeda (`/usr/local` vs `/opt/homebrew`)
- **User base** tersebar di kedua OS

**ShellCheck di CI:**

```yaml
- name: Run ShellCheck
  run: shellcheck --shell=zsh --severity=warning ...
```

- `--shell=zsh` — analisis sebagai Zsh (bukan Bash)
- `--severity=warning` — hanya warning dan error (skip info)
- **Fail CI** jika ada warning → memaksa kualitas

**Coverage dengan kcov:**

```yaml
- name: Run tests with coverage
  run: |
    sudo apt-get install -y kcov
    shellspec --kcov
```

`kcov` adalah coverage tool yang bekerja dengan ShellSpec. Output HTML di `coverage/`.

**Upload ke Codecov:**

```yaml
- uses: codecov/codecov-action@v4
```

Codecov memberikan:
- **Badge** untuk README
- **Trend** coverage
- **Comment** di PR jika coverage turun

**Integration Test:**

```yaml
- name: Test subcommand (with mock)
  run: |
    # Setup mock untuk kubectl
    cat > /tmp/mock-bin/kubectl <<'EOF'
    #!/bin/zsh
    echo '{"items":[]}'
    EOF
    chmod +x /tmp/mock-bin/kubectl
    export PATH="/tmp/mock-bin:$PATH"
    nt status --json | jq .
```

Integration test memverifikasi bahwa:
- Install berhasil
- Binary di PATH
- Subcommand berjalan
- Output valid

**Release Automation:**

```yaml
if: startsWith(github.ref, 'refs/tags/v')
```

Workflow release hanya jalan saat ada Git tag `v*` (misalnya `v1.0.0`). Ini memisahkan:
- **CI** (setiap push) — test, lint
- **CD** (setiap tag) — build, release

**Changelog Generation:**

```bash
git log --pretty=format:"- %s (%h)" $PREV_TAG..HEAD
```

Format:
- `-` — bullet
- `%s` — subject (commit message)
- `%h` — short hash

Output:
```
- Fix bug in deploy (#abc123)
- Add retry logic for k8s (#def456)
```

**Tarball untuk Distribusi:**

```bash
tar -czf "nt-${VERSION}.tar.gz" bin/ lib/ completions/ docs/ install.sh uninstall.sh
```

Sertakan:
- `bin/` — entry point
- `lib/` — semua fungsi
- `completions/` — completion
- `docs/` — dokumentasi
- `install.sh`, `uninstall.sh` — install/uninstall

**Best Practice CI/CD:**

1. **Test di multi-OS** — Ubuntu + macOS
2. **Test di multi-versi** — Zsh 5.8, 5.9
3. **ShellCheck wajib** — fail on warning
4. **Coverage target** — >80%
5. **Integration test** — install dan run binary
6. **Release otomatis** — dari Git tag
7. **Changelog otomatis** — dari Git log
8. **Artifact** — tarball di GitHub Releases

**Mengapa Bukan Hanya Unit Test?**

Unit test tidak cukup karena:
- Tidak menangkap **integration issue** (missing dependency)
- Tidak menangkap **installation issue** (path salah)
- Tidak menangkap **OS-specific issue** (GNU vs BSD)

Piramida test:

```
        E2E (Integration)
       /                \
      /                  \
     /     Unit Tests     \
    /                      \
   /________________________\
```

- **Unit** (dasar): Banyak, cepat, murah
- **Integration** (tengah): Sedang
- **E2E** (atas): Sedikit, lambat, mahal

Untuk CLI tool, kita fokus pada **unit** dan **integration**.

---

### Pertanyaan 8: Dokumentasi dan Onboarding Kontributor

**Tantangan:** Tim Anda akan berkembang — mungkin akan ada developer baru yang bergabung untuk mengembangkan `nt`. Buat dokumentasi yang: (a) menjelaskan arsitektur, (b) memberikan panduan kontribusi, (c) menunjukkan cara menambah subcommand baru.

**Jawaban:**

**`docs/README.md`:**

```markdown
# nt — Nusantara Toolkit

CLI tool internal untuk tim DevOps Nusantara Tech.

## Instalasi

### User

```bash
curl -fsSL https://git.nusantara.tech/tools/nt/raw/main/install.sh | zsh
```

### Developer

```bash
git clone git@git.nusantara.tech:tools/nt.git
cd nt
make install
```

## Quick Start

```bash
# Cek status service
nt status

# Deploy ke staging
nt deploy staging api --version v1.2.3

# Interaksi dengan K8s
nt k8s pods

# Generate laporan
nt report weekly --format=markdown
```

## Commands

| Command | Deskripsi |
|---------|-----------|
| `nt status` | Cek status semua service |
| `nt deploy <env> <svc>` | Deploy service |
| `nt db <action>` | Database operations |
| `nt k8s <action>` | Kubernetes operations |
| `nt secrets <action>` | Secret management |
| `nt report <period>` | Generate laporan |
| `nt debug <service>` | Debug interaktif |
| `nt help` | Bantuan |

## Arsitektur

Lihat [architecture.md](architecture.md).

## Development

Lihat [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Internal — Nusantara Tech
```

**`docs/architecture.md`:**

```markdown
# Arsitektur nt

## Overview

`nt` mengikuti pola **dispatcher** dengan **plugin commands**.

```
┌──────────────┐
│   bin/nt     │ ← Entry point
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Dispatcher  │ ← Parse args, dispatch ke subcommand
└──────┬───────┘
       │
       ├──► lib/commands/status.zsh
       ├──► lib/commands/deploy.zsh
       ├──► lib/commands/db.zsh
       ├──► lib/commands/k8s.zsh
       ├──► lib/commands/secrets.zsh
       ├──► lib/commands/report.zsh
       ├──► lib/commands/debug.zsh
       └──► lib/commands/help.zsh
```

## Struktur Direktori

- **`bin/nt`** — Entry point, dispatcher
- **`lib/core.zsh`** — Core functions (logging, validation, formatting)
- **`lib/commands/`** — Satu file per subcommand
- **`lib/integrations/`** — Integrasi dengan external tools (K8s, AWS, DB)
- **`completions/_nt`** — Zsh completion
- **`tests/`** — Test suite (ShellSpec)

## Alur Eksekusi

1. User menjalankan `nt status --json`
2. `bin/nt` dipanggil
3. Standard `$0` handling menentukan `NT_ROOT`
4. Load `lib/core.zsh` dan `lib/integrations/*.zsh`
5. Load semua `lib/commands/*.zsh` (eager)
6. `nt_dispatch "status" "--json"` dipanggil
7. Dispatcher mencari `nt_cmd_status` dan memanggilnya
8. `nt_cmd_status` memproses args dan menghasilkan output

## Ekstensi

### Menambah Subcommand Baru

1. Buat file `lib/commands/<name>.zsh`
2. Definisikan fungsi `nt_cmd_<name>()`
3. Tambahkan completion di `completions/_nt`
4. Tambahkan test di `tests/spec/<name>_spec.sh`
5. Update `docs/README.md`

### Menambah Integration

1. Buat file `lib/integrations/<name>.zsh`
2. Definisikan fungsi-fungsi helper
3. Source di `bin/nt` (atau autoload)
4. Test dengan mock

## Konvensi

- **Nama fungsi**: `nt_cmd_<name>` untuk subcommand, `<name>_<action>` untuk helper
- **Exit code**: 0 = sukses, 1 = error umum, 2 = input invalid
- **Output**: stdout untuk data, stderr untuk error
- **Logging**: gunakan `nt_log`, `nt_info`, `nt_error`
```

**`docs/CONTRIBUTING.md`:**

```markdown
# Contributing ke nt

Terima kasih atas kontribusi Anda!

## Setup Development

```bash
# Clone
git clone git@git.nusantara.tech:tools/nt.git
cd nt

# Install dependencies
brew install shellspec shellcheck  # macOS
sudo apt install shellspec shellcheck  # Ubuntu

# Install nt untuk testing
make install

# Verify
nt --version
make test
```

## Alur Development

1. **Buat branch** dari `main`
   ```bash
   git checkout -b feat/my-feature
   ```

2. **Tulis test dulu** (TDD)
   ```bash
   vim tests/spec/my_feature_spec.sh
   ```

3. **Implementasi**
   ```bash
   vim lib/commands/my_feature.zsh
   ```

4. **Test lokal**
   ```bash
   make test
   make lint
   ```

5. **Commit dengan pesan jelas**
   ```bash
   git commit -m "feat: add my-feature command"
   ```

6. **Push dan buat PR**
   ```bash
   git push origin feat/my-feature
   ```

## Panduan Kode

### Fungsi

- Prefix `nt_cmd_` untuk subcommand
- Prefix `nt_` untuk core functions
- Prefix `<integration>_` untuk integration (misalnya `k8s_`, `aws_`)

### Error Handling

```zsh
# ✅ Baik
if ! command -v kubectl &>/dev/null; then
    nt_error "kubectl tidak terinstall"
    return 1
fi

# ❌ Buruk
kubectl get pods  # Akan fail jika kubectl tidak ada
```

### Logging

```zsh
nt_info "Starting operation..."      # Info ke user
nt_debug "Fetching $url"             # Hanya dengan NT_DEBUG=1
nt_warn "Retrying..."                # Warning
nt_error "Failed: $reason"           # Error ke stderr
nt_ok "Success!"                     # Success
```

### Testing

Setiap fungsi publik harus punya test:

```zsh
Describe 'nt_cmd_myfeature'
    It 'returns success'
        When call nt_cmd_myfeature
        The status should be success
    End

    It 'handles invalid input'
        When call nt_cmd_myfeature --invalid
        The status should be failure
        The stderr should include "invalid"
    End
End
```

## Checklist PR

- [ ] Test coverage >80%
- [ ] ShellCheck pass
- [ ] Dokumentasi di-update
- [ ] Changelog entry
- [ ] Contoh penggunaan
- [ ] Test di macOS dan Linux

## Review Process

1. **Automated checks** — CI menjalankan test + lint
2. **Peer review** — minimal 1 approve
3. **Integration test** — test di staging
4. **Merge** — squash dan merge

## Menambah Subcommand

Template:

```zsh
# lib/commands/mycommand.zsh

nt_cmd_mycommand() {
    local action="${1:-help}"
    shift || true
    
    case "$action" in
        do)
            nt_mycommand_do "$@"
            ;;
        help|-h|--help)
            cat <<EOF
Penggunaan: nt mycommand <action>

Actions:
    do        Melakukan sesuatu
    help      Bantuan ini
EOF
            ;;
        *)
            nt_error "Action tidak dikenal: $action"
            return 1
            ;;
    esac
}

nt_mycommand_do() {
    nt_info "Doing something..."
    # Implementasi
    nt_ok "Done"
}
```

Test:

```zsh
# tests/spec/mycommand_spec.sh
Describe 'nt mycommand'
    It 'menampilkan help'
        When call nt_cmd_mycommand help
        The output should include "Penggunaan"
    End
    
    It 'melakukan do'
        When call nt_cmd_mycommand do
        The status should be success
        The output should include "Done"
    End
End
```

Completion:

```zsh
# Di completions/_nt
_nt_mycommand() {
    local -a actions
    actions=(
        'do:Melakukan sesuatu'
        'help:Bantuan'
    )
    _arguments '1:action:->action'
    case "$state" in
        action) _describe 'action' actions ;;
    esac
}
```
```

**Penjelasan Mental — Dokumentasi sebagai Onboarding:**

**Tiga Tingkat Dokumentasi:**

1. **README** — untuk user. Cara install, quick start, command reference.
2. **Architecture** — untuk developer. Bagaimana sistem bekerja, bagaimana extend.
3. **CONTRIBUTING** — untuk kontributor. Setup, konvensi, alur PR.

**Mengapa Dokumentasi Penting?**

- **Onboarding** — developer baru bisa productive dalam jam, bukan hari
- **Maintenance** — Anda bisa lupa kode 6 bulan lalu; dokumentasi mengingatkan
- **Quality** — dokumentasi memaksa Anda berpikir tentang desain
- **Communication** — dokumentasi adalah komunikasi dengan tim

**Template-Driven Development:**

Dengan template subcommand di CONTRIBUTING, menambah fitur baru menjadi **mekanis**:
1. Copy template
2. Ganti nama
3. Isi logic
4. Test

Ini mengurangi **cognitive load** dan **error**.

**Dokumentasi sebagai Test:**

Dokumentasi yang baik berisi **contoh yang bisa dijalankan**:

```bash
# Dari README
nt deploy staging api --version v1.2.3
```

Anda bisa menambahkan **doctest** — test yang menjalankan contoh dari dokumentasi:

```zsh
# tests/spec/docs_spec.sh
Describe 'README examples'
    It 'nt status berjalan'
        When call nt status
        The status should be success
    End
    
    It 'nt deploy dengan version'
        When call nt deploy staging api --version v1.0.0 --dry-run
        The status should be success
    End
End
```

Ini memastikan dokumentasi **selalu akurat**.

**Architecture Decision Records (ADR):**

Untuk keputusan arsitektur penting, buat ADR:

```markdown
# ADR-001: Menggunakan ShellSpec untuk Testing

## Status
Accepted

## Context
Kami butuh framework testing untuk Zsh CLI tool. Kandidat: ShellSpec, ZUnit, Bats.

## Decision
Menggunakan ShellSpec.

## Alasan
- BDD syntax yang expressive
- Mendukung mocking
- Coverage via kcov
- Aktif dikembangkan

## Konsekuensi
- Developer perlu belajar BDD syntax
- Test ditulis dalam DSL ShellSpec
```

ADR membantu **track keputusan** dan **alasan di baliknya** — penting saat onboarding developer baru.

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Diagram Arsitektur Dispatcher** — Kotak `bin/nt` di atas, panah ke `dispatcher`, lalu bercabang ke setiap subcommand. Tandai mana yang eager vs autoload.
>
> 2. **Alur Eksekusi `nt deploy staging api`** — Flowchart dari entry point → parsing → validasi → eksekusi → output. Tandai setiap exit code.
>
> 3. **Piramida Test** — Segitiga dengan Unit di bawah (banyak), Integration di tengah, E2E di atas (sedikit). Tandai coverage target per level.
>
> 4. **Diagram CI/CD Pipeline** — Flowchart: push → ShellCheck → Test (multi-OS) → Integration → Release. Tandai durasi setiap step.
>
> 5. **Peta Integrasi** — Diagram yang menunjukkan `nt` di tengah, dengan panah ke Kubernetes, AWS, Database, 1Password, Slack, dll.
>
> 6. **Timeline Fitur** — Gantt chart 4 minggu dengan milestone: Week 1 (core + status), Week 2 (deploy + k8s), Week 3 (test + completion), Week 4 (docs + release).

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.1 (Fondasi)** | Variabel, quoting, file system — fondasi |
| **7.2 (Scripting)** | Fungsi, error handling, trap — dasar CLI tool |
| **7.3 (Konfigurasi)** | Modular config, completion — UX CLI tool |
| **7.4 (Performa)** | Lazy loading, audit, monitoring — production readiness |
| **7.6 (Expert)** | CLI tool ini akan menjadi bagian dari deployment enterprise |
| **Fase 5 (Kurikulum)** | Modul ini adalah aplikasi langsung dari: fungsi lanjutan, hook, autoload, testing, integrasi |

---

## 9. Sumber Referensi Lengkap

- **ShellSpec Documentation** — https://shellspec.info/
- **ShellSpec GitHub** — https://github.com/shellspec/shellspec
- **ZUnit GitHub** — https://github.com/z-shell/zunit
- **zsh-test-runner** — https://github.com/olets/zsh-test-runner
- **Zsh Manual: Functions** — https://zsh.sourceforge.io/Doc/Release/Functions.html
- **Zsh Manual: Hook Functions** — https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
- **Zsh Manual: Autoloading** — https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions
- **Zsh Manual: Parameter Expansion** — https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion
- **Zsh Manual: Completion System** — https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- **jq Manual** — https://jqlang.github.io/jq/manual/
- **ShellCheck** — https://www.shellcheck.net/
- **kcov (coverage)** — https://github.com/SimonKagstrom/kcov
- **Codecov** — https://about.codecov.io/
- **GitHub Actions: Workflow Syntax** — https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
- **Google Shell Style Guide** — https://google.github.io/styleguide/shellguide.html
- **CLI Guidelines** — https://clig.dev/

---

## 10. Tips dan Praktik Terbaik

1. **Test dulu, implementasi kemudian (TDD).** Test adalah spesifikasi.
2. **Coverage >80%.** Ini bukan angka absolut, tapi disiplin.
3. **ShellCheck di CI.** Fail pada warning, bukan hanya error.
4. **Multi-OS testing.** macOS + Linux — Zsh berperilaku berbeda.
5. **Integration test wajib.** Unit test tidak cukup.
6. **Autoload untuk command jarang.** Startup cepat > instant first-use.
7. **Standard `$0` handling.** Untuk portabilitas.
8. **Dispatcher pattern.** Extensible tanpa ubah core.
9. **Documentation-as-code.** Update docs dalam PR yang sama.
10. **Semantic versioning.** Breaking change = major bump.
11. **Changelog otomatis.** Dari Git log.
12. **Release otomatis.** Dari Git tag.
13. **Satu file per subcommand.** Mudah di-navigasi.
14. **Test file per subcommand.** Mudah ditemukan.
15. **ADR untuk keputusan besar.** Dokumentasi arsitektur.
16. **README yang singkat.** Detail di docs/.
17. **CLI help yang jelas.** Contoh penggunaan di help.
18. **Exit code yang bermakna.** 0 = sukses, 1 = error umum, 2 = invalid input.
19. **Jangan breaking change tanpa deprecation.** Beri waktu migrasi.
20. **Feedback loop.** Dengar user, iterasi.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `set -e` tanpa `pipefail` | Pipe gagal tapi script lanjut | `set -euo pipefail` |
| `$@` tanpa quote | Argumen dengan spasi terpecah | `"$@"` |
| Tidak ada `$0` handling | Plugin tidak portabel | Standard `$0` handling |
| Eager load semua commands | Startup lambat | Autoload untuk yang jarang |
| `eval` dengan input user | Code injection | Hindari `eval` |
| Hardcode path | Tidak portable | Gunakan `$0:A:h` |
| Test setelah implementasi | Tidak menangkap bug | TDD |
| Coverage rendah | Bug di production | >80% coverage |
| Documentation di wiki | Tidak di-version-control | Di `docs/` Git |
| Breaking change tanpa deprecation | User frustrasi | Beri waktu migrasi |
| Missing `2>/dev/null` | Error mengganggu output | Suppress di tempat yang tepat |
| Tidak ada timeout | Script hang | `timeout` untuk API calls |
| Tidak ada retry | Gagal karena network glitch | Exponential backoff |
| Cache tanpa invalidasi | Data stale | TTL atau explicit invalidation |
| Secret di CLI args | Terlihat di `ps aux` | Environment variable, prompt, atau file |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.5, Anda seharusnya mengembangkan **mental model baru**:

1. **CLI tool adalah produk.** Ia memiliki user, dokumentasi, test, release cycle.
2. **Test adalah safety net.** Tanpa test, refactor adalah mimpi buruk.
3. **TDD bukan dogma, tapi disiplin.** Test dulu membantu desain.
4. **Autoload adalah optimization.** Untuk functions yang jarang.
5. **Hook memungkinkan reactivity.** `precmd`, `preexec`, `chpwd`.
6. **Integration adalah kekuatan.** Zsh + Python + jq + kubectl = super power.
7. **API calls perlu robustness.** Retry, timeout, caching.
8. **Completion adalah UX.** Completion yang baik membuat tool terasa "native".
9. **CI/CD bukan optional.** Untuk production code, ini wajib.
10. **Documentation adalah code.** Ia hidup di repo, di-update di PR.
11. **Dispatcher pattern adalah extensible.** Menambah command = tambah file.
12. **Exit code adalah contract.** Caller bergantung padanya.

**Pertanyaan reflektif untuk diri sendiri:**
- Bisakah saya merancang CLI tool dengan dispatcher pattern tanpa melihat contoh?
- Apakah saya tahu kapan harus autoload dan kapan eager load?
- Bisakah saya menulis test dengan ShellSpec untuk fungsi saya?
- Apakah saya bisa mengintegrasikan Python dengan Zsh untuk analisis kompleks?
- Bisakah saya membuat completion yang dynamic (dari config/API)?
- Apakah saya tahu cara setup CI/CD untuk CLI tool?
- Bisakah saya mendokumentasikan tool untuk developer baru?

Jika jawabannya "belum", **ulangi modul ini** — CLI tool adalah senjata utama DevOps engineer.

### Checklist Verifikasi

Sebelum melanjutkan ke Modul 7.6, pastikan Anda dapat:

- [ ] Merancang struktur direktori CLI tool dengan dispatcher pattern
- [ ] Menulis entry point dengan standard `$0` handling
- [ ] Mengimplementasikan dispatcher dengan associative array
- [ ] Menggunakan anonymous function untuk setup/teardown
- [ ] Menggunakan hook (`precmd`, `preexec`, `chpwd`) untuk reactivity
- [ ] Menggunakan autoload untuk lazy loading functions
- [ ] Menggunakan parameter expansion flags `(U)`, `(L)`, `(j)`, `(k)`
- [ ] Menulis test dengan ShellSpec (Describe, It, When, The)
- [ ] Menggunakan mocking di ShellSpec
- [ ] Mengintegrasikan Python dengan Zsh via heredoc
- [ ] Mengintegrasikan API eksternal dengan retry dan caching
- [ ] Menulis completion function dengan `_arguments` dan `_describe`
- [ ] Membuat dynamic completion dari config/API
- [ ] Setup CI/CD dengan GitHub Actions
- [ ] Menulis `Makefile` untuk build automation
- [ ] Menulis `install.sh` dan `uninstall.sh`
- [ ] Mendokumentasikan arsitektur dan kontribusi

---

## ✅ MODUL 7.5 SELESAI

**Ringkasan yang telah Anda kuasai:**
- Struktur CLI tool dengan dispatcher pattern
- Standard `$0` handling untuk portabilitas
- Anonymous functions untuk scoped execution
- Hook functions (`precmd`, `preexec`, `chpwd`)
- Autoload untuk lazy loading
- Parameter expansion flags lanjutan
- Testing dengan ShellSpec (BDD)
- Mocking untuk test isolation
- Integrasi Python via heredoc
- Integrasi API dengan retry dan caching
- Completion function dengan `_arguments`
- Dynamic completion dari config/API
- CI/CD dengan GitHub Actions
- Multi-OS testing
- Build automation dengan Makefile
- Dokumentasi arsitektur dan kontribusi

**Yang akan datang di Modul 7.6:**
Anda akan membangun **arsitektur enterprise dan kontribusi open source** — deployment untuk seluruh organisasi, kontribusi ke proyek Zsh, dan spesialisasi (DevOps, Data, Tooling). Ini adalah langkah terakhir menuju "shell expert" — dari pengembang produk menjadi arsitek enterprise.

---

# MODUL 7.6: ARSITEKTUR ENTERPRISE & KONTRIBUSI OPEN SOURCE

> **Mewakili:** Fase 6 — Arsitektur Enterprise dan Deployment, Kontribusi ke Proyek Zsh & Open Source, Spesialisasi (DevOps, Data, Tooling)
> **Level:** Expert | **Durasi:** 15–20 jam | **Tipe:** Proyek Simulasi

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model "arsitek & kontributor"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Toolkit enterprise & kontribusi
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan nyata
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Satu tahun setelah `nt` dirilis.** CLI tool internal Anda telah menjadi tulang punggung tim DevOps. Tim tumbuh dari 30 menjadi **120 developer**, dengan **5 tim** berbeda (Backend, Frontend, Data, DevOps, Security). Anda dipromosikan menjadi **Principal Engineer**. CTO memanggil Anda:

> *"Kita punya tantangan baru. Dengan 120 developer dan 5 tim:*
> - *Kita perlu **standardisasi environment** di seluruh organisasi, bukan hanya satu tim*
> - *Kita perlu **deploy konfigurasi** ke 120 mesin (laptop, server, CI runner)*
> - *Kita perlu **audit compliance** untuk SOC 2 dan ISO 27001*
> - *Kita perlu **kontribusi ke upstream** — kita menggunakan banyak open source, saatnya memberi kembali*
> - *Kita perlu **spesialisasi** — setiap tim punya kebutuhan yang berbeda*
>
> *Tugas Anda: bangun **arsitektur shell enterprise** yang mencakup:*
> - *Deployment otomatis untuk 120 mesin*
> - *Kebijakan keamanan yang di-enforce*
> - *Audit trail yang compliance*
> - *Kontribusi ke Zsh upstream*
> - *Panduan spesialisasi untuk setiap tim*
>
> *Budget: 3 bulan. Tim: 3 engineer (termasuk Anda). Target: Zero-config untuk developer baru, compliance-ready untuk auditor."*

**Requirement spesifik:**

| Area | Kebutuhan |
|---|---|
| **Deployment** | Ansible untuk 120 mesin, <5 menit per mesin |
| **Config Management** | Dotfiles terpusat, override per tim |
| **Security** | Secrets, audit trail, policy enforcement |
| **Compliance** | SOC 2, ISO 27001 evidence |
| **Kontribusi** | Patch ke Zsh core, plugin open source |
| **Spesialisasi** | DevOps, Data, Tooling tracks |
| **Documentation** | Onboarding, runbook, ADR |

Anda memiliki:
- 3 bulan
- 3 engineer
- Akses ke semua sistem
- Budget untuk training
- Dukungan CTO

**Tantangan:** Bangun **arsitektur shell enterprise** yang mencakup deployment, keamanan, compliance, dan kontribusi open source.

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **puncak dari semua yang telah Anda pelajari**:

- **Fase 1–2 (Fondasi & Scripting)** — dasar untuk semua scripting
- **Fase 3 (Konfigurasi)** — modularitas untuk enterprise
- **Fase 4 (Performa & Keamanan)** — audit, optimasi, compliance
- **Fase 5 (Testing & Integrasi)** — kualitas production
- **Modul 7.1–7.5 (Praktik)** — aplikasi progresif dari pengetahuan

Di level **Expert**, Anda tidak lagi:
- Menulis script untuk diri sendiri — tapi untuk **organisasi**
- Memikirkan satu mesin — tapi **120 mesin**
- Optimasi satu shell — tapi **arsitektur sistem**
- Menggunakan open source — tapi **berkontribusi kembali**

**Perbedaan "Mahir" vs "Expert":**

| Aspek | Mahir | Expert |
|---|---|---|
| **Scope** | Satu tim | Organisasi |
| **Time horizon** | Sprint (2 minggu) | Quarter (3 bulan) |
| **Deliverable** | Fitur | Arsitektur |
| **Risk** | Fitur tidak jalan | Business disruption |
| **Communication** | Tim | C-level, auditor |
| **Kontribusi** | Internal | Open source |

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: "Architect as Steward."**

Seorang arsitek bukan hanya pembuat keputusan teknis — mereka adalah **penjaga** sistem. Mereka berpikir tentang:
- **Sustainability** — apakah sistem ini bisa di-maintain 5 tahun?
- **Scalability** — apakah bisa tumbuh 10x?
- **Security** — apakah aman dari ancaman?
- **Compliance** — apakah memenuhi regulasi?
- **People** — apakah developer bisa produktif?

**Filosofi "Policy as Code":**

Kebijakan tidak boleh berupa dokumen PDF yang diabaikan. Kebijakan harus **diekspresikan sebagai kode** yang bisa:
- **Di-version-control** — siapa mengubah kapan, mengapa
- **Di-test** — apakah policy masih valid?
- **Di-enforce** — otomatis diterapkan, bukan manual
- **Di-audit** — siapa melanggar kapan

**Filosofi "Zero-Config Onboarding":**

Developer baru harus bisa **productive dalam jam, bukan hari**. Target:
- **Clone repository** — 1 menit
- **Run install** — 3 menit
- **Ready to code** — 5 menit total

Tanpa dokumentasi panjang, tanpa setup manual, tanpa "tanya senior".

**Filosofi "Give Back to Open Source":**

Jika Anda menggunakan open source (dan pasti Anda menggunakannya), **berkontribusi kembali** bukan pilihan — ini tanggung jawab. Bentuk kontribusi:
- **Bug report** — yang jelas dan reproducible
- **Documentation** — perbaikan typo, tambah contoh
- **Plugin** — extend functionality
- **Patch** — perbaikan bug, fitur baru
- **Sponsorship** — dana untuk maintainer
- **Advocacy** — berbicara tentang proyek

**Filosofi "Specialization with Common Foundation":**

Setiap tim punya kebutuhan yang berbeda:
- **DevOps** — cloud, container, IaC
- **Data** — ETL, analitik, visualisasi
- **Tooling** — CLI, editor, produktivitas

Tapi semua tim **berbagi fondasi**:
- Keamanan
- Konfigurasi dasar
- Completion
- Prompt

Arsitektur yang baik: **fondasi kuat + spesialisasi per tim**.

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.6 — Enterprise & Kontribusi
# ═══════════════════════════════════════════════════════════

# ─── ENTERPRISE DEPLOYMENT ───
# Ansible playbook
ansible-playbook -i inventory.ini site.yml

# Ansible role untuk zsh
ansible-galaxy init role-zsh

# ─── KONTRIBUSI ZSH ───
# Clone Zsh
git clone https://github.com/zsh-users/zsh.git
cd zsh

# Build dari source
./Util/preconfig
./configure --prefix=/usr/local
make -j$(nproc)
make check

# Buat patch
git checkout -b fix-bug-xyz
# ... edit files ...
git commit -m "Fix: deskripsi"
git format-patch origin/master

# Kirim ke mailing list
git send-email --to=zsh-workers@zsh.org 0001-*.patch

# ─── SPESIALISASI ───
# DevOps track
kubectl get pods -o json | jq '.items[] | select(.status.phase != "Running")'

# Data track
cat data.csv | awk -F',' '{sum[$1]+=$2} END {for (k in sum) print k, sum[k]}' | \
    jq -R -s 'split("\n") | map(select(length > 0)) | map(split(" ")) | map({key: .[0], value: .[1]})'

# Tooling track
fd --type f --exec bat {} --paging=never | fzf --preview 'bat {}'
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **Ansible** | Configuration management tool | Deploy ke 120 mesin |
| **Playbook** | File YAML yang mendefinisikan tasks | `site.yml` |
| **Role** | Kumpulan tasks untuk satu tujuan | `role-zsh` |
| **Inventory** | Daftar host target | `inventory.ini` |
| **Idempotent** | Aman dijalankan berkali-kali | Ansible task |
| **Dotfiles** | File konfigurasi (`.zshrc`, dll.) | Repository dotfiles |
| **GNU Stow** | Symlink farm manager | Manage dotfiles |
| **XDG** | Base directory specification | `~/.config/zsh/` |
| **SOC 2** | Compliance framework | Audit trail |
| **ISO 27001** | Information security standard | Policy enforcement |
| **Audit trail** | Rekaman aktivitas | Log command |
| **Policy as Code** | Kebijakan sebagai kode | YAML, script |
| **Mail patch** | Patch via email | `git send-email` |
| **Mailing list** | Diskusi via email | `zsh-workers@zsh.org` |
| **X-Seq** | Nomor urut mailing list | Untuk tracking |
| **Contributor License Agreement** | Perjanjian kontributor | Untuk proyek besar |
| **Semantic versioning** | `MAJOR.MINOR.PATCH` | `1.2.3` |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Desain Arsitektur Enterprise

**Tantangan:** Rancang arsitektur shell enterprise untuk 120 developer di 5 tim. Anda perlu memutuskan: (a) struktur repository, (b) layer konfigurasi, (c) mekanisme distribusi, (d) kebijakan.

**Jawaban:**

**Arsitektur Enterprise:**

```
┌────────────────────────────────────────────────────────────────────┐
│                ENTERPRISE SHELL ARCHITECTURE                        │
│                     Nusantara Tech                                  │
└────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────┐
│  LAYER 1: FOUNDATION (Wajib untuk semua)                            │
│  ─────────────────────────────────────                              │
│  • Security policy (history, TMOUT, secrets)                        │
│  • Base config (PATH, locale, editor)                               │
│  • Completion system                                                │
│  • Prompt standar                                                   │
│  Deploy: /etc/zsh/ (system-wide, read-only)                         │
└────────────────────────────────────────────────────────────────────┘
                              ▲
                              │ inherit
                              │
┌────────────────────────────────────────────────────────────────────┐
│  LAYER 2: TEAM (Per tim, opsional)                                  │
│  ──────────────────────────────────                                 │
│  • DevOps: kubectl, terraform, aws helpers                          │
│  • Data: python venv, jupyter, spark helpers                        │
│  • Tooling: CLI tools, editor integration                           │
│  • Frontend: node, npm, yarn helpers                                │
│  • Backend: go, java, database helpers                              │
│  Deploy: ~/.config/zsh/teams/<team>/                                │
└────────────────────────────────────────────────────────────────────┘
                              ▲
                              │ extend
                              │
┌────────────────────────────────────────────────────────────────────┐
│  LAYER 3: PERSONAL (Per developer)                                  │
│  ────────────────────────────────                                   │
│  • Aliases pribadi                                                  │
│  • Prompt preferensi                                                │
│  • Tools pribadi                                                    │
│  Deploy: ~/.config/zsh/local.zsh (gitignored)                       │
└────────────────────────────────────────────────────────────────────┘
```

**Repository Structure:**

```
nusantara-dotfiles/
├── README.md
├── LICENSE
├── CODEOWNERS                          # Review per area
├── .github/
│   └── workflows/
│       ├── test.yml                    # Test semua
│       ├── deploy.yml                  # Deploy saat rilis
│       └── security-scan.yml           # Scan secrets
│
├── ansible/                            # Deployment
│   ├── inventory/
│   │   ├── production.ini
│   │   ├── staging.ini
│   │   └── group_vars/
│   │       ├── all.yml
│   │       ├── developers.yml
│   │       └── ci-runners.yml
│   ├── roles/
│   │   ├── zsh-foundation/             # Layer 1
│   │   ├── zsh-team-devops/            # Layer 2 - DevOps
│   │   ├── zsh-team-data/              # Layer 2 - Data
│   │   └── zsh-team-tooling/           # Layer 2 - Tooling
│   ├── playbooks/
│   │   ├── deploy-all.yml
│   │   ├── deploy-team.yml
│   │   └── audit.yml
│   └── ansible.cfg
│
├── foundation/                         # Layer 1 files
│   ├── etc/
│   │   └── zsh/
│   │       ├── zshenv
│   │       ├── zshrc
│   │       └── conf.d/
│   │           ├── 00-base.zsh
│   │           ├── 10-security.zsh
│   │           ├── 20-tools.zsh
│   │           └── 30-completion.zsh
│   └── share/
│       └── zsh/
│           └── site-functions/
│               ├── _nt
│               └── _nusantara-cli
│
├── teams/                              # Layer 2 files
│   ├── devops/
│   │   └── conf.d/
│   │       ├── 20-k8s.zsh
│   │       ├── 21-aws.zsh
│   │       └── 22-terraform.zsh
│   ├── data/
│   │   └── conf.d/
│   │       ├── 20-python.zsh
│   │       ├── 21-jupyter.zsh
│   │       └── 22-spark.zsh
│   ├── tooling/
│   │   └── conf.d/
│   │       ├── 20-cli-tools.zsh
│   │       └── 21-editor.zsh
│   ├── backend/
│   └── frontend/
│
├── tests/                              # Test suite
│   ├── spec/
│   │   ├── foundation_spec.sh
│   │   ├── security_spec.sh
│   │   └── teams_spec.sh
│   └── integration/
│       └── ansible-test.sh
│
├── docs/                               # Dokumentasi
│   ├── README.md
│   ├── onboarding.md
│   ├── adr/                            # Architecture Decision Records
│   │   ├── 001-modular-config.md
│   │   ├── 002-ansible-deployment.md
│   │   └── 003-secret-management.md
│   ├── runbook/                        # Operational runbook
│   │   ├── incident-response.md
│   │   ├── rollback.md
│   │   └── troubleshooting.md
│   └── compliance/                     # Evidence for audit
│       ├── soc2-mapping.md
│       └── iso27001-mapping.md
│
├── scripts/                            # Utility scripts
│   ├── audit-secrets.zsh
│   ├── rotate-credentials.zsh
│   ├── compliance-report.zsh
│   └── verify-installation.zsh
│
└── install.sh                          # Quick install
```

**Layer Configuration:**

**Layer 1 — Foundation (`/etc/zsh/`):**

```zsh
# /etc/zsh/conf.d/00-base.zsh — Fondasi
# Di-manage oleh IT, read-only untuk user

# PATH dengan deduplikasi
typeset -U path PATH
path=(
    /usr/local/bin
    /usr/bin
    /bin
    $path
)
export PATH

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Umask: file tidak world-writable
umask 022

# History policy (compliance)
HISTFILE="/var/log/zsh_history/${USER}_${HOST}"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Timeout idle
TMOUT=3600
setopt TMOUT

# Security: alias aman
alias rm='rm -I --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
```

**Layer 2 — Team (`~/.config/zsh/teams/<team>/`):**

```zsh
# ~/.config/zsh/conf.d/15-team.zsh — Load team config
# Di-set oleh installer berdasarkan tim developer

# Tim dideteksi dari environment atau file
local team="${NUSANTARA_TEAM:-}"

if [[ -z "$team" ]] && [[ -f "$HOME/.nusantara-team" ]]; then
    team=$(cat "$HOME/.nusantara-team")
fi

if [[ -n "$team" ]] && [[ -d "$ZDOTDIR/teams/$team" ]]; then
    for conf in "$ZDOTDIR/teams/$team/conf.d"/*.zsh(N); do
        source "$conf"
    done
fi
```

**Layer 3 — Personal (`~/.config/zsh/local.zsh`):**

```zsh
# ~/.config/zsh/local.zsh — Override pribadi
# TIDAK di-track di Git

# Developer bisa menambahkan alias, prompt, dll.
# Contoh:
# PS1='%F{cyan}❯%f '
# alias ll='ls -lah'
# export EDITOR=nvim
```

**Penjelasan Mental — Mengapa Layer:**

**Layer 1 (Foundation) adalah "hukum konstitusi":**
- Tidak bisa di-override
- Di-manage sentral (IT)
- Mencakup: security, base config, compliance

**Layer 2 (Team) adalah "peraturan daerah":**
- Bisa di-override dengan alasan
- Di-manage per tim
- Mencakup: tools spesifik tim

**Layer 3 (Personal) adalah "preferensi pribadi":**
- Fully customizable
- Tidak di-manage sentral
- Mencakup: alias, prompt, editor

**Keunggulan Layer:**

1. **Separation of concerns** — keamanan di Layer 1, produktivitas di Layer 2, preferensi di Layer 3
2. **Scalability** — tim baru cukup buat Layer 2, tidak sentuh Layer 1
3. **Audit** — Layer 1 dan 2 di-version-control, mudah di-audit
4. **Compliance** — Layer 1 adalah "policy as code"

**Distribution Options:**

| Option | Pro | Con |
|---|---|---|
| **Git + Stow** | Simple, familiar | Manual di setiap mesin |
| **Ansible** | Otomatis, idempotent | Perlu setup, learning curve |
| **Chef/Puppet** | Enterprise-grade | Overkill, berat |
| **Homebrew Bundle** | macOS native | Tidak cross-platform |
| **Custom installer** | Kontrol penuh | Maintenance |

**Untuk 120 developer: Ansible.**

Alasan:
- **Idempotent** — aman dijalankan berkali-kali
- **Agentless** — cukup SSH
- **Declarative** — "apa" bukan "bagaimana"
- **Scalable** — 120 atau 1200 mesin, sama
- **Testable** — bisa di-test di staging

---

### Pertanyaan 2: Ansible untuk 120 Mesin

**Tantangan:** Bangun Ansible playbook untuk deploy konfigurasi Zsh ke 120 mesin (developer laptops, CI runners, servers). Requirement: (a) idempotent, (b) timeout <5 menit per mesin, (c) audit, (d) rollback.

**Jawaban:**

**Inventory Structure:**

```ini
# ansible/inventory/production.ini

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_connection=ssh
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[developers]
# 100 developer laptops
dev-laptop-001 ansible_host=10.1.1.1  team=devops
dev-laptop-002 ansible_host=10.1.1.2  team=data
dev-laptop-003 ansible_host=10.1.1.3  team=tooling
# ... 100 total

[ci_runners]
ci-runner-001 ansible_host=10.2.1.1
ci-runner-002 ansible_host=10.2.1.2
# ... 20 total

[servers]
build-server-001 ansible_host=10.3.1.1
# ... 5 total

[all:children]
developers
ci_runners
servers

[devops:children]
# Subgroup untuk devops team
[devops]
dev-laptop-001
dev-laptop-010
# ...
```

**`ansible/ansible.cfg`:**

```ini
# ansible/ansible.cfg
[defaults]
inventory = inventory/production.ini
roles_path = roles
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
callback_whitelist = profile_tasks
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[ssh_connection]
pipelining = True
control_path = /tmp/ansible-ssh-%%h-%%p-%%r
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

**`playbooks/deploy-all.yml`:**

```yaml
---
# playbooks/deploy-all.yml — Deploy ke semua mesin

- name: Deploy Zsh Foundation (Layer 1)
  hosts: all
  become: yes
  roles:
    - zsh-foundation
  tags:
    - foundation
    - always

- name: Deploy Team Configuration (Layer 2)
  hosts: developers
  become: no
  roles:
    - role: zsh-team
      team_name: "{{ team }}"
  tags:
    - team

- name: Verify installation
  hosts: all
  become: no
  tasks:
    - name: Run verification script
      script: scripts/verify-installation.zsh
      register: verify_result
      changed_when: false
      failed_when: verify_result.rc != 0
  tags:
    - verify
```

**`roles/zsh-foundation/tasks/main.yml`:**

```yaml
---
# roles/zsh-foundation/tasks/main.yml — Setup Layer 1

- name: Ensure Zsh is installed
  package:
    name: zsh
    state: present
  tags:
    - packages

- name: Ensure required packages
  package:
    name:
      - git
      - curl
      - jq
      - tree
    state: present
  tags:
    - packages

- name: Create /etc/zsh directory structure
  file:
    path: "{{ item }}"
    state: directory
    owner: root
    group: root
    mode: '0755'
  loop:
    - /etc/zsh
    - /etc/zsh/conf.d
    - /usr/local/share/zsh
    - /usr/local/share/zsh/site-functions
    - /var/log/zsh_history
  tags:
    - directories

- name: Deploy zshenv
  copy:
    src: files/etc/zsh/zshenv
    dest: /etc/zsh/zshenv
    owner: root
    group: root
    mode: '0644'
    backup: yes
  notify: validate zsh config
  tags:
    - config

- name: Deploy zshrc
  copy:
    src: files/etc/zsh/zshrc
    dest: /etc/zsh/zshrc
    owner: root
    group: root
    mode: '0644'
    backup: yes
  notify: validate zsh config
  tags:
    - config

- name: Deploy conf.d files
  copy:
    src: "files/etc/zsh/conf.d/{{ item }}"
    dest: "/etc/zsh/conf.d/{{ item }}"
    owner: root
    group: root
    mode: '0644'
    backup: yes
  loop:
    - 00-base.zsh
    - 10-security.zsh
    - 20-tools.zsh
    - 30-completion.zsh
  notify: validate zsh config
  tags:
    - config

- name: Deploy completion functions
  copy:
    src: "files/share/zsh/site-functions/{{ item }}"
    dest: "/usr/local/share/zsh/site-functions/{{ item }}"
    owner: root
    group: root
    mode: '0644'
    backup: yes
  loop:
    - _nt
    - _nusantara-cli
  tags:
    - completion

- name: Set permissions on history directory
  file:
    path: /var/log/zsh_history
    state: directory
    owner: root
    group: root
    mode: '1777'  # Sticky bit — users can write but not delete others
  tags:
    - permissions

- name: Configure logrotate for zsh history
  copy:
    src: files/etc/logrotate.d/zsh-history
    dest: /etc/logrotate.d/zsh-history
    owner: root
    group: root
    mode: '0644'
  tags:
    - logrotate

- name: Ensure /etc/shells includes zsh
  lineinfile:
    path: /etc/shells
    line: /usr/bin/zsh
    state: present
  tags:
    - shells

- name: Set Zsh as default shell (optional)
  user:
    name: "{{ item }}"
    shell: /usr/bin/zsh
  loop: "{{ lookup('file', 'users.txt').splitlines() }}"
  when: set_default_shell | default(false)
  tags:
    - default-shell
```

**`roles/zsh-foundation/handlers/main.yml`:**

```yaml
---
# roles/zsh-foundation/handlers/main.yml

- name: validate zsh config
  command: zsh -n /etc/zsh/zshrc
  register: validate_result
  failed_when: validate_result.rc != 0
  listen: "validate zsh config"

- name: restart zsh sessions
  # Tidak ada restart Zsh, hanya warning
  debug:
    msg: "Zsh config updated. Users perlu buka terminal baru."
  listen: "restart zsh sessions"
```

**`roles/zsh-team/tasks/main.yml`:**

```yaml
---
# roles/zsh-team/tasks/main.yml — Setup Layer 2

- name: Validate team name
  assert:
    that:
      - team_name in ['devops', 'data', 'tooling', 'backend', 'frontend']
    fail_msg: "Team {{ team_name }} tidak valid"
  when: team_name is defined

- name: Create team config directory
  file:
    path: "{{ zsh_config_dir }}/teams/{{ team_name }}"
    state: directory
    owner: "{{ ansible_user_id }}"
    mode: '0755'
  when: team_name is defined

- name: Deploy team conf.d files
  copy:
    src: "files/teams/{{ team_name }}/conf.d/{{ item }}"
    dest: "{{ zsh_config_dir }}/teams/{{ team_name }}/conf.d/{{ item }}"
    owner: "{{ ansible_user_id }}"
    mode: '0644'
  loop: "{{ lookup('fileglob', 'files/teams/' + team_name + '/conf.d/*.zsh', wantlist=True) | map('basename') | list }}"
  when: team_name is defined
  notify: reload zsh for user

- name: Write team marker
  copy:
    content: "{{ team_name }}\n"
    dest: "{{ ansible_env.HOME }}/.nusantara-team"
    owner: "{{ ansible_user_id }}"
    mode: '0644'
  when: team_name is defined
```

**Rollback Strategy:**

```yaml
---
# playbooks/rollback.yml — Rollback ke versi sebelumnya

- name: Rollback Zsh configuration
  hosts: "{{ target_hosts | default('all') }}"
  become: yes
  vars:
    rollback_date: "{{ rollback_date | mandatory }}"
  
  tasks:
    - name: Find backup files
      find:
        paths:
          - /etc/zsh
          - /etc/zsh/conf.d
        patterns: "*.bak"
        age: "-1d"
      register: backup_files
    
    - name: Restore from backup
      copy:
        src: "{{ item.path }}"
        dest: "{{ item.path | regex_replace('\\.bak.*$', '') }}"
        remote_src: yes
        backup: no
      loop: "{{ backup_files.files }}"
      when: backup_files.matched > 0
    
    - name: Validate after rollback
      command: zsh -n /etc/zsh/zshrc
      register: validate_result
      failed_when: validate_result.rc != 0
    
    - name: Report
      debug:
        msg: "Rollback selesai untuk {{ inventory_hostname }}"
```

**Run Deployment:**

```bash
# Deploy ke semua
ansible-playbook playbooks/deploy-all.yml

# Deploy ke tim spesifik
ansible-playbook playbooks/deploy-all.yml --limit devops

# Deploy ke satu host
ansible-playbook playbooks/deploy-all.yml --limit dev-laptop-001

# Dry run
ansible-playbook playbooks/deploy-all.yml --check --diff

# Dengan verbose
ansible-playbook playbooks/deploy-all.yml -vvv

# Rollback
ansible-playbook playbooks/rollback.yml -e "rollback_date=2026-10-10"
```

**Penjelasan Mental — Mengapa Ansible:**

**Ansible vs Shell Script:**

| Aspek | Shell Script | Ansible |
|---|---|---|
| **Idempotent** | Manual | Built-in |
| **Parallel** | Manual | Built-in (fork) |
| **Error handling** | Manual | Built-in |
| **Reporting** | Manual | Built-in |
| **Dry-run** | Manual | `--check` |
| **Diff** | Manual | `--diff` |

**Mengapa Idempotent Penting:**

```bash
# ❌ Shell script: jalankan 2x = PATH duplikat
echo 'export PATH=/usr/local/bin:$PATH' >> ~/.zshrc

# ✅ Ansible: jalankan 2x = tidak ada perubahan
- lineinfile:
    path: ~/.zshrc
    line: 'export PATH=/usr/local/bin:$PATH'
```

**Parallel Execution:**

Ansible secara default menjalankan task di banyak host **secara paralel** (default: 5 host sekaligus). Untuk 120 host, ini berarti:
- Tanpa parallel: 120 × 5 menit = 10 jam
- Dengan parallel (5): 2 jam
- Dengan parallel (20): 30 menit

Set di `ansible.cfg`:
```ini
[defaults]
forks = 20
```

**Handlers — Event-Driven Tasks:**

```yaml
- copy:
    src: zshrc
    dest: /etc/zsh/zshrc
  notify: validate zsh config

# Handler hanya dijalankan SEKALI, bahkan jika di-notify berkali-kali
# Handler dijalankan di AKHIR play
handlers:
  - name: validate zsh config
    command: zsh -n /etc/zsh/zshrc
```

**Keunggulan handler:**
- **Efisien** — validasi hanya sekali setelah semua perubahan
- **Konsisten** — tidak ada race condition
- **Idempotent** — handler hanya jalan jika ada notify

**Tags — Selective Execution:**

```yaml
- name: Deploy zshrc
  copy: ...
  tags:
    - config
    - foundation

# Jalankan hanya task dengan tag config:
ansible-playbook site.yml --tags config

# Skip tag tertentu:
ansible-playbook site.yml --skip-tags packages
```

**Best Practice Tags:**
- `packages` — install packages
- `config` — deploy config files
- `completion` — completion functions
- `verify` — verifikasi
- `always` — selalu jalankan

**Dry Run dengan Diff:**

```bash
ansible-playbook site.yml --check --diff
```

`--check` — jangan ubah apa pun, hanya cek
`--diff` — tunjukkan perbedaan file

Output:
```diff
--- before: /etc/zsh/zshrc
+++ after: /etc/zsh/zshrc
@@ -10,3 +10,6 @@
 # Base config
 export PATH=/usr/local/bin:$PATH
+
+# New security settings
+setopt HIST_IGNORE_SPACE
```

**Rollback Strategy:**

Tiga level rollback:

1. **Automatic backup** — Ansible menyimpan `.bak` setiap deploy
2. **Git-based rollback** — checkout versi sebelumnya
3. **Snapshot-based** — snapshot VM sebelum deploy

Untuk enterprise, **kombinasi**:
- Backup file di setiap deploy (level 1)
- Git tag untuk rilis (level 2)
- VM snapshot untuk server kritis (level 3)

**Performance Optimization:**

| Setting | Default | Untuk 120 host |
|---|---|---|
| `forks` | 5 | 20 |
| `pipelining` | False | True |
| `ControlMaster` | False | auto |
| `ControlPersist` | 0 | 60s |
| `gathering` | implicit | smart |
| `fact_caching` | none | jsonfile |

Dengan setting di atas, deploy 120 host bisa selesai dalam **~30 menit**.

**Audit Trail:**

Ansible secara otomatis mencatat:
- **Apa** yang diubah (task name)
- **Di mana** (host)
- **Kapan** (timestamp)
- **Oleh siapa** (user)
- **Hasil** (changed/ok/failed)

Enable logging:
```ini
# ansible.cfg
[defaults]
log_path = /var/log/ansible/ansible.log
```

Format log:
```
2026-10-12 10:30:45 p=1234 u=admin n=ansible | PLAY [Deploy Zsh Foundation]
2026-10-12 10:30:46 p=1234 u=admin n=ansible | TASK [zsh-foundation : Deploy zshrc]
2026-10-12 10:30:47 p=1234 u=admin n=ansible | ok: [dev-laptop-001]
2026-10-12 10:30:47 p=1234 u=admin n=ansible | changed: [dev-laptop-002]
```

Ini adalah **audit trail** yang dibutuhkan SOC 2.

---

### Pertanyaan 3: Compliance & Audit Trail

**Tantangan:** SOC 2 dan ISO 27001 auditor meminta bukti bahwa kebijakan shell di-enforce. Bangun sistem yang menghasilkan evidence untuk audit.

**Jawaban:**

**Kebijakan yang Harus Di-enforce:**

| Requirement | Framework | Implementasi |
|---|---|---|
| **Access Control** | SOC 2 CC6.1 | Permission file, role-based |
| **Audit Logging** | SOC 2 CC7.2 | Log command, session |
| **Data Integrity** | SOC 2 CC8.1 | Git version control |
| **Change Management** | SOC 2 CC8.1 | PR, review, approval |
| **Vulnerability Management** | ISO 27001 A.12.6 | Regular scan |
| **Cryptography** | ISO 27001 A.10.1 | Secrets encryption |
| **Operations Security** | ISO 27001 A.12 | Monitoring, alerting |
| **Incident Management** | ISO 27001 A.16 | Runbook, rollback |

**Compliance Report Script:**

```zsh
#!/bin/zsh
# scripts/compliance-report.zsh — Generate compliance evidence

set -euo pipefail

readonly REPORT_DIR="${1:-/var/log/compliance}"
readonly REPORT_DATE=$(date +%Y%m%d)
readonly REPORT_FILE="$REPORT_DIR/compliance-${REPORT_DATE}.md"

mkdir -p "$REPORT_DIR"

# ═══════════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════════
check_pass() { echo "✅ PASS" ; }
check_fail() { echo "❌ FAIL" ; }
check_warn() { echo "⚠️  WARN" ; }

section() {
    echo ""
    echo "## $*"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# GENERATE REPORT
# ═══════════════════════════════════════════════════════════
{
    cat <<EOF
# Compliance Report — Nusantara Tech

**Tanggal:** $(date '+%Y-%m-%d %H:%M:%S')
**Host:** $(hostname)
**User:** $(whoami)
**Auditor:** Automated

---

## 1. Access Control (SOC 2 CC6.1)

### 1.1 File Permissions

EOF

    # Cek permission file konfigurasi
    echo "| File | Expected | Actual | Status |"
    echo "|------|----------|--------|--------|"

    local files=(
        "/etc/zsh/zshrc:644"
        "/etc/zsh/zshenv:644"
        "/etc/zsh/conf.d:755"
        "/var/log/zsh_history:1777"
    )

    for entry in "${files[@]}"; do
        local file="${entry%:*}"
        local expected="${entry#*:}"
        
        if [[ -e "$file" ]]; then
            local actual=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%A' "$file")
            local status=$(check_pass)
            [[ "$actual" != "$expected" ]] && status=$(check_fail)
            echo "| \`$file\` | $expected | $actual | $status |"
        else
            echo "| \`$file\` | $expected | NOT FOUND | $(check_fail) |"
        fi
    done

    section "2. Audit Logging (SOC 2 CC7.2)"

    # Cek apakah audit logging aktif
    if grep -q "HISTFILE" /etc/zsh/conf.d/00-base.zsh 2>/dev/null; then
        echo "- ✅ HISTFILE dikonfigurasi"
    else
        echo "- ❌ HISTFILE tidak dikonfigurasi"
    fi

    if grep -q "EXTENDED_HISTORY" /etc/zsh/conf.d/00-base.zsh 2>/dev/null; then
        echo "- ✅ EXTENDED_HISTORY aktif (timestamp di history)"
    else
        echo "- ❌ EXTENDED_HISTORY tidak aktif"
    fi

    if grep -q "SHARE_HISTORY" /etc/zsh/conf.d/00-base.zsh 2>/dev/null; then
        echo "- ✅ SHARE_HISTORY aktif (history shared)"
    else
        echo "- ❌ SHARE_HISTORY tidak aktif"
    fi

    # Cek log file
    if [[ -d /var/log/zsh_history ]]; then
        local log_count=$(find /var/log/zsh_history -type f 2>/dev/null | wc -l)
        echo "- ✅ Directory /var/log/zsh_history ada ($log_count files)"
    else
        echo "- ❌ Directory /var/log/zsh_history tidak ada"
    fi

    section "3. Data Integrity (SOC 2 CC8.1)"

    # Cek versi Git
    if [[ -d /etc/zsh/.git ]]; then
        local commit=$(git -C /etc/zsh rev-parse --short HEAD 2>/dev/null)
        local last_change=$(git -C /etc/zsh log -1 --format='%ci' 2>/dev/null)
        echo "- ✅ Config under version control"
        echo "  - Commit: \`$commit\`"
        echo "  - Last change: $last_change"
    else
        echo "- ⚠️  Config tidak under version control"
    fi

    section "4. Change Management (SOC 2 CC8.1)"

    # Cek backup
    local backup_count=$(find /etc/zsh -name "*.bak" 2>/dev/null | wc -l)
    echo "- Backup files: $backup_count"

    # Cek Ansible log
    if [[ -f /var/log/ansible/ansible.log ]]; then
        local recent_deploys=$(grep -c "PLAY" /var/log/ansible/ansible.log 2>/dev/null || echo 0)
        echo "- Ansible deployments recorded: $recent_deploys"
    fi

    section "5. Vulnerability Management (ISO 27001 A.12.6)"

    # Cek ShellCheck
    if command -v shellcheck &>/dev/null; then
        local issues=0
        for script in /etc/zsh/conf.d/*.zsh; do
            local result=$(shellcheck -f json "$script" 2>/dev/null | jq 'length')
            issues=$((issues + result))
        done
        echo "- ShellCheck: $issues issues in /etc/zsh/conf.d/"
    fi

    # Cek package updates
    if command -v apt &>/dev/null; then
        local updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo 0)
        echo "- System package updates available: $updates"
    fi

    section "6. Cryptography (ISO 27001 A.10.1)"

    # Cek secrets management
    if command -v op &>/dev/null; then
        echo "- ✅ 1Password CLI installed"
    else
        echo "- ⚠️  1Password CLI not installed"
    fi

    # Scan secrets di config
    local secret_pattern='(api[_-]?key|password|token|secret)\s*=\s*["\x27][^"\x27]{8,}'
    local secrets_found=$(grep -rniE "$secret_pattern" /etc/zsh/ 2>/dev/null | wc -l)
    
    if [[ $secrets_found -eq 0 ]]; then
        echo "- ✅ Tidak ada secrets di config"
    else
        echo "- ❌ $secrets_found potential secrets found in config!"
    fi

    section "7. Operations Security (ISO 27001 A.12)"

    # Cek monitoring
    if [[ -f /var/log/zsh-metrics/metrics.jsonl ]]; then
        local metric_count=$(wc -l < /var/log/zsh-metrics/metrics.jsonl)
        echo "- ✅ Monitoring active ($metric_count data points)"
    else
        echo "- ⚠️  Monitoring not active"
    fi

    # Cek logrotate
    if [[ -f /etc/logrotate.d/zsh-history ]]; then
        echo "- ✅ Logrotate configured"
    else
        echo "- ❌ Logrotate not configured"
    fi

    section "8. Incident Management (ISO 27001 A.16)"

    # Cek runbook
    if [[ -d /opt/nusantara/runbook ]]; then
        local runbooks=$(find /opt/nusantara/runbook -name "*.md" | wc -l)
        echo "- ✅ Runbook available ($runbooks documents)"
    else
        echo "- ❌ Runbook not found"
    fi

    section "Summary"

    cat <<EOF
- **Report Date:** $(date '+%Y-%m-%d')
- **Report File:** \`$REPORT_FILE\`
- **Next Review:** $(date -d '+90 days' '+%Y-%m-%d' 2>/dev/null || date -v+90d '+%Y-%m-%d')

---

*Generated by compliance-report.zsh v1.0*
EOF
} > "$REPORT_FILE"

echo "✅ Report: $REPORT_FILE"
```

**Setup Automation:**

```yaml
# ansible/playbooks/compliance.yml

- name: Generate compliance report
  hosts: all
  become: yes
  tasks:
    - name: Deploy compliance script
      copy:
        src: scripts/compliance-report.zsh
        dest: /usr/local/bin/compliance-report.zsh
        mode: '0755'
    
    - name: Setup cron for weekly compliance
      cron:
        name: "Compliance report"
        minute: "0"
        hour: "9"
        day: "1"
        month: "*"
        job: "/usr/local/bin/compliance-report.zsh >> /var/log/compliance/cron.log 2>&1"
```

**Penjelasan Mental — Compliance as Evidence:**

**Filosofi:** Compliance bukan tentang "melakukan", tapi tentang **"membuktikan bahwa Anda melakukan"**.

**Tiga Pilar Compliance:**

1. **Policy** — Apa yang seharusnya dilakukan?
2. **Implementation** — Apakah sudah dilakukan?
3. **Evidence** — Bagaimana membuktikannya?

**Sumber Evidence:**

| Evidence | Sumber | Framework |
|---|---|---|
| **Config files** | `/etc/zsh/conf.d/` | Change Mgmt |
| **Git history** | `git log` | Change Mgmt |
| **Ansible log** | `/var/log/ansible/` | Change Mgmt |
| **Audit trail** | `/var/log/zsh_history/` | Audit Logging |
| **Compliance reports** | `/var/log/compliance/` | Ongoing Monitoring |
| **ShellCheck output** | CI logs | Vulnerability Mgmt |
| **Secret scan** | Automated | Cryptography |
| **Runbook** | Git repo | Incident Mgmt |

**Otomasi Evidence:**

Manual evidence = auditor tidak percaya.
Automated evidence = auditor percaya.

**Script compliance-report.zsh** menghasilkan evidence dalam format Markdown yang bisa:
- Dibaca auditor (human-readable)
- Di-commit ke Git (version-controlled)
- Di-convert ke PDF (untuk submission)

**SOC 2 vs ISO 27001:**

| SOC 2 | ISO 27001 |
|---|---|
| **Fokus:** Service organization | **Fokus:** Information security |
| **Audience:** Customers | **Audience:** Regulators |
| **Framework:** Trust Services Criteria | **Framework:** Controls |
| **Frequency:** Annual | **Frequency:** 3 years (certification) |
| **Mandatory:** US-based, SaaS | **Mandatory:** International |

**Overlap:** Banyak control yang sama (access, audit, change, incident).

**Best Practice:**
1. **Automate everything** — evidence otomatis
2. **Version control all config** — Git as source of truth
3. **Log all changes** — Ansible, Git, audit trail
4. **Regular review** — weekly compliance report
5. **Runbook untuk incident** — documented, tested
6. **Separate concern** — Foundation vs Team vs Personal
7. **Never allow secrets in config** — enforce by policy

---

### Pertanyaan 4: Kontribusi ke Zsh Upstream

**Tantangan:** Setelah setahun menggunakan Zsh, Anda menemukan bug di completion system untuk `kubectl`. Anda perlu: (a) verify bug, (b) fix, (c) submit patch ke upstream Zsh.

**Jawaban:**

**Step 1: Verify Bug**

```bash
# Clone Zsh
git clone https://github.com/zsh-users/zsh.git
cd zsh

# Build dari source (untuk testing)
./Util/preconfig
./configure --prefix=/usr/local
make -j$(nproc)

# Test current behavior
./Src/zsh -f
% autoload -Uz compinit && compinit
% kubectl get pods --<TAB>
# Bug: only completes some options
```

**Step 2: Investigate**

```bash
# Cari completion file untuk kubectl
find Completion -name "*kubectl*"
# Completion/Unix/Command/_kubectl

# Cek versi
git log --oneline -10 -- Completion/Unix/Command/_kubectl

# Test dengan debug
./Src/zsh -f -x
% autoload -Uz compinit && compinit
% kubectl get pods --<TAB>
# Lihat trace untuk memahami flow
```

**Step 3: Read Contributing Guide**

```bash
# Baca panduan development
cat Etc/zsh-development-guide
# Atau di GitHub:
# https://github.com/zsh-users/zsh/blob/master/Etc/zsh-development-guide
```

Panduan penting:
- **Mailing list:** `zsh-workers@zsh.org` (development)
- **Patch format:** Context atau unified diff
- **Satu patch = satu perbaikan**
- **ChangeLog entry wajib**
- **Test case di `Test/`**

**Step 4: Fix Bug**

```zsh
# Completion/Unix/Command/_kubectl — Fix bug

# Sebelum:
_arguments \
    '--kubeconfig=[Path to kubeconfig]:file:_files' \
    '(-n --namespace)'{-n,--namespace}'=[Namespace]:namespace:->namespaces' \
    # BUG: option missing

# Sesudah:
_arguments \
    '--kubeconfig=[Path to kubeconfig]:file:_files' \
    '(-n --namespace)'{-n,--namespace}'=[Namespace]:namespace:->namespaces' \
    '--context=[Context name]:context:->contexts' \
    '--cluster=[Cluster name]:cluster:->clusters' \
    '--user=[User name]:user:->users' \
    '--token=[Bearer token]:token' \
    '--server=[API server]:url:_urls' \
    '(-h --help)'{-h,--help}'[Show help]' \
    '--v=[Log level]:level:(0 1 2 3 4 5 6 7 8 9)' \
    '*::args:->args'
```

**Step 5: Add Test**

```zsh
# Test/Completion/compctl.ztst (atau Test/Completion/...)

# Tambah test untuk kubectl completion
:
# Test completion untuk --context
comptest 'kubectl --context' \
    'kubectl --context <TAB>' \
    'context1' 'context2' 'context3'

# Test completion untuk --namespace
comptest 'kubectl --namespace' \
    'kubectl --namespace <TAB>' \
    'default' 'kube-system' 'kube-public'
```

**Step 6: Update ChangeLog**

```
2026-10-12  Your Name  <your.email@example.com>

    * Completion/Unix/Command/_kubectl: Add missing options
      (--context, --cluster, --user, --token, --server)
    * Test/Completion/comptest: Add test for kubectl options
```

**Step 7: Commit dengan Format yang Benar**

```bash
# Pesan commit harus deskriptif
git add Completion/Unix/Command/_kubectl Test/Completion/comptest ChangeLog

git commit -m "Fix: kubectl completion missing options

- Add --context, --cluster, --user, --token, --server options
- Add completion for namespace and context values
- Add test case for kubectl options

Fixes: zsh-workers@zsh.org issue reported by user"
```

**Step 8: Generate Patch**

```bash
# Format patch dengan X-Seq number (dari mailing list)
git format-patch origin/master

# Hasil: 0001-Fix-kubectl-completion-missing-options.patch
cat 0001-*.patch
```

**Step 9: Submit ke Mailing List**

```bash
# Kirim ke zsh-workers
git send-email \
    --to="zsh-workers@zsh.org" \
    --subject="PATCH: Fix kubectl completion missing options" \
    0001-Fix-kubectl-completion-missing-options.patch
```

Atau manual via email client:

```
To: zsh-workers@zsh.org
Subject: [PATCH] Fix kubectl completion missing options

Description:
The kubectl completion is missing several common options:
- --context
- --cluster
- --user
- --token
- --server

This patch adds these options with appropriate completion functions.

Testing:
- Manually verified completion works in Zsh 5.9
- Added test case to Test/Completion/

Patch attached.

Best regards,
Your Name
```

**Step 10: Iterasi dengan Feedback**

```
[Setelah beberapa hari, Anda menerima feedback:]

From: Maintainer <maintainer@example.com>
Subject: Re: [PATCH] Fix kubectl completion missing options

> +    '--token=[Bearer token]:token' \

Should this be a secret? We should not store token in history.
Consider using `_message` instead of accepting the value.

Also, the test should be added to Test/Completion/comptest
not Test/Completion/compctl.ztst.

--
Maintainer
```

**Revisi patch:**

```zsh
# Fix 1: Token tidak di-complete (untuk keamanan)
'--token=[Bearer token]:' \

# Fix 2: Test di file yang benar
# Test/Completion/comptest
```

**Re-submit:**

```bash
git add -A
git commit --amend
git format-patch origin/master
git send-email --to=zsh-workers@zsh.org 0001-*.patch
```

**Step 11: Patch Diterima**

```
From: Maintainer <maintainer@example.com>
Subject: Re: [PATCH v2] Fix kubectl completion missing options

Applied, thanks!
```

**Penjelasan Mental — Open Source Contribution Etiquette:**

**Do's:**

1. **Read the contributing guide** — jangan asal kirim patch
2. **Search existing issues** — mungkin sudah ada
3. **Follow style** — sesuaikan dengan kode di sekitarnya
4. **One patch = one fix** — jangan gabung multiple fix
5. **Test thoroughly** — di berbagai OS, versi
6. **Update documentation** — jika mengubah behavior
7. **Update ChangeLog** — wajib di proyek Zsh
8. **Be patient** — maintainer sukarelawan
9. **Be open to feedback** — jangan defensif
10. **Give credit** — reference original issue

**Don'ts:**

1. **Jangan spam mailing list** — kirim satu patch, tunggu
2. **Jangan top-post** — bottom-post di mailing list
3. **Jangan kirim HTML** — plain text only
4. **Jangan argue** — jika ditolak, terima dengan baik
5. **Jangan kirim patch besar tanpa diskusi** — diskusi dulu di list
6. **Jangan assume maintainer tahu konteks** — jelaskan
7. **Jangan follow-up cepat** — tunggu 1-2 minggu
8. **Jangan kirim patch ke private email** — selalu ke list

**Anatomi Patch yang Baik:**

```diff
From: Your Name <your.email@example.com>
Date: Mon, 12 Oct 2026 10:30:00 +0700
Subject: [PATCH] Fix: kubectl completion missing options

This patch fixes missing options in kubectl completion.

The kubectl completion currently supports:
- --kubeconfig
- --namespace

But is missing common options:
- --context
- --cluster
- --user
- --server

This patch adds those options.

Signed-off-by: Your Name <your.email@example.com>
---
 Completion/Unix/Command/_kubectl | 15 +++++++++++++--
 Test/Completion/comptest         | 12 ++++++++++++
 ChangeLog                         |  5 +++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Completion/Unix/Command/_kubectl b/Completion/Unix/Command/_kubectl
index abc1234..def5678 100644
--- a/Completion/Unix/Command/_kubectl
+++ b/Completion/Unix/Command/_kubectl
@@ -50,6 +50,12 @@ _kubectl() {
     _arguments \
         '--kubeconfig=[Path to kubeconfig]:file:_files' \
         '(-n --namespace)'{-n,--namespace}'=[Namespace]:namespace:->namespaces' \
+        '--context=[Context name]:context:->contexts' \
+        '--cluster=[Cluster name]:cluster:->clusters' \
+        '--user=[User name]:user:->users' \
+        '--server=[API server]:url:_urls' \
         '*::args:->args'
```

**Struktur Patch:**

1. **Header** — dari, tanggal, subject
2. **Body** — penjelasan perubahan (wrap di 72 char)
3. **Signed-off-by** — DCO (Developer Certificate of Origin)
4. **---** — separator
5. **Stat** — file yang diubah
6. **Diff** — perubahan aktual

**Zsh Mailing List Etiquette:**

- **Format:** Plain text, tidak HTML
- **Quote:** Minimal, bottom-post
- **Subject:** `[PATCH]` atau `[PATCH v2]`
- **Reference:** Gunakan `Message-ID` untuk reply
- **Signature:** 4 baris, `--` sebagai separator
- **Reply:** Ke list, bukan ke pribadi

**Penjelasan Mental — Mengapa Kontribusi:**

**Alasan Kontribusi:**

1. **Give back** — Anda menggunakan gratis, waktunya memberi
2. **Reputasi** — kontribusi open source adalah portofolio
3. **Belajar** — membaca kode orang lain = belajar
4. **Networking** — bertemu developer lain
5. **Impact** — perubahan Anda digunakan jutaan orang

**Bentuk Kontribusi (dari mudah ke sulit):**

1. **Bug report** — laporkan dengan reproducible steps
2. **Documentation** — perbaiki typo, tambah contoh
3. **Translation** — terjemahkan dokumentasi
4. **Test case** — tambah test untuk bug yang ada
5. **Plugin** — buat plugin baru
6. **Bug fix** — perbaiki bug
7. **Feature** — implementasi fitur baru
8. **Refactor** — perbaiki kode
9. **Sponsorship** — dana untuk maintainer
10. **Mentoring** — bantu contributor baru

---

### Pertanyaan 5: Specialization Track — DevOps

**Tantangan:** Bangun specialization track untuk tim DevOps. Track harus mencakup: cloud (AWS/GCP/Azure), container (Docker/K8s), IaC (Terraform/Ansible), CI/CD (GitHub Actions/GitLab CI). Buat struktur, konten, dan capstone project.

**Jawaban:**

**Track Structure:**

```
teams/devops/
├── README.md                    # Overview
├── conf.d/                      # Zsh configuration
│   ├── 20-k8s.zsh               # Kubernetes helpers
│   ├── 21-aws.zsh               # AWS helpers
│   ├── 22-terraform.zsh         # Terraform helpers
│   ├── 23-docker.zsh            # Docker helpers
│   └── 24-cicd.zsh              # CI/CD helpers
├── functions/                   # Autoload functions
│   ├── _k8s
│   ├── _aws
│   ├── _tf
│   └── _docker
├── learning/                    # Learning materials
│   ├── 01-cloud.md
│   ├── 02-containers.md
│   ├── 03-iac.md
│   └── 04-cicd.md
└── projects/                    # Capstone projects
    └── deploy-pipeline/
```

**`teams/devops/conf.d/20-k8s.zsh`:**

```zsh
# 20-k8s.zsh — Kubernetes helpers untuk DevOps team

# ═══════════════════════════════════════════════════════════
# ALIASES
# ═══════════════════════════════════════════════════════════
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias ka='kubectl apply'
alias kdel='kubectl delete'
alias kx='kubectl config use-context'

# ═══════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════

# Context switching dengan FZF
kctx() {
    local ctx
    ctx=$(kubectl config get-contexts -o name | fzf --prompt="Context: " --height=40%)
    [[ -n "$ctx" ]] && kubectl config use-context "$ctx"
}

# Namespace switching dengan FZF
kns() {
    local ns
    ns=$(kubectl get namespaces -o name | sed 's/namespace\///' | fzf --prompt="Namespace: " --height=40%)
    [[ -n "$ns" ]] && kubectl config set-context --current --namespace="$ns"
}

# Pod logs dengan FZF
klf() {
    local pod
    pod=$(kubectl get pods -o name | sed 's/pod\///' | fzf --prompt="Pod: " --height=40%)
    [[ -n "$pod" ]] && kubectl logs -f "$pod"
}

# Exec ke pod
kx() {
    local pod
    pod=$(kubectl get pods -o name | sed 's/pod\///' | fzf --prompt="Pod: " --height=40%)
    [[ -n "$pod" ]] && kubectl exec -it "$pod" -- /bin/sh
}

# Watch pods
kwp() {
    watch -n 2 'kubectl get pods --sort-by=.metadata.creationTimestamp'
}

# Scale deployment
kscale() {
    local deploy="$1"
    local replicas="$2"
    
    if [[ -z "$deploy" || -z "$replicas" ]]; then
        echo "Usage: kscale <deployment> <replicas>" >&2
        return 1
    fi
    
    kubectl scale deployment "$deploy" --replicas="$replicas"
}

# Port forward
kpf() {
    local pod="$1"
    local local_port="$2"
    local remote_port="$3"
    
    if [[ -z "$pod" || -z "$local_port" || -z "$remote_port" ]]; then
        echo "Usage: kpf <pod> <local-port> <remote-port>" >&2
        return 1
    fi
    
    kubectl port-forward "$pod" "${local_port}:${remote_port}"
}

# Get events sorted by time
kevents() {
    kubectl get events --sort-by='.lastTimestamp' "$@"
}

# Get pod images
kimages() {
    kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}' | tr ' ' '\n' | sort -u
}

# ═══════════════════════════════════════════════════════════
# PROMPT: Tambah K8s context
# ═══════════════════════════════════════════════════════════
k8s_prompt_info() {
    local ctx=$(kubectl config current-context 2>/dev/null)
    local ns=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
    
    [[ -z "$ctx" ]] && return
    
    # Warning jika production
    if [[ "$ctx" == *"prod"* ]]; then
        echo "%F{red}[${ctx}]%f"
    else
        echo "%F{cyan}[${ctx}]%f"
    fi
}

# Tambahkan ke prompt (jika belum ada)
if [[ "$PROMPT" != *"k8s_prompt_info"* ]]; then
    PROMPT='$(k8s_prompt_info)'"$PROMPT"
fi
```

**`teams/devops/conf.d/21-aws.zsh`:**

```zsh
# 21-aws.zsh — AWS helpers

# ═══════════════════════════════════════════════════════════
# PROFILE SWITCHING
# ═══════════════════════════════════════════════════════════
aws-profile() {
    local profile="$1"
    
    if [[ -z "$profile" ]]; then
        profile=$(aws configure list-profiles | fzf --prompt="AWS Profile: " --height=40%)
    fi
    
    [[ -z "$profile" ]] && return 1
    
    # Konfirmasi untuk production
    if [[ "$profile" == *"prod"* ]]; then
        echo "⚠️  Switching to PRODUCTION profile: $profile"
        read "reply?Continue? (y/n) "
        [[ "$reply" != "y" ]] && return 1
    fi
    
    export AWS_PROFILE="$profile"
    export AWS_DEFAULT_PROFILE="$profile"
    
    echo "✅ AWS Profile: $profile"
    aws sts get-caller-identity --output table 2>/dev/null
}

alias awsp='aws-profile'

# ═══════════════════════════════════════════════════════════
# REGION
# ═══════════════════════════════════════════════════════════
aws-region() {
    local region="$1"
    
    if [[ -z "$region" ]]; then
        region=$(aws ec2 describe-regions --query 'Regions[].RegionName' --output text | tr '\t' '\n' | fzf --prompt="Region: " --height=40%)
    fi
    
    [[ -z "$region" ]] && return 1
    
    export AWS_REGION="$region"
    export AWS_DEFAULT_REGION="$region"
    echo "✅ AWS Region: $region"
}

alias awsr='aws-region'

# ═══════════════════════════════════════════════════════════
# SSM SESSION
# ═══════════════════════════════════════════════════════════
aws-ssm() {
    local instance="$1"
    
    if [[ -z "$instance" ]]; then
        instance=$(aws ec2 describe-instances \
            --filters "Name=instance-state-name,Values=running" \
            --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value|[0]]' \
            --output text | \
            fzf --prompt="Instance: " --height=40%)
        instance=$(echo "$instance" | awk '{print $1}')
    fi
    
    [[ -z "$instance" ]] && return 1
    
    aws ssm start-session --target "$instance"
}

# ═══════════════════════════════════════════════════════════
# S3
# ═══════════════════════════════════════════════════════════
s3-ls() {
    local bucket="$1"
    
    if [[ -z "$bucket" ]]; then
        bucket=$(aws s3 ls | awk '{print $3}' | fzf --prompt="Bucket: " --height=40%)
    fi
    
    [[ -z "$bucket" ]] && return 1
    
    aws s3 ls "s3://$bucket/" --recursive --human-readable --summarize
}
```

**`teams/devops/conf.d/22-terraform.zsh`:**

```zsh
# 22-terraform.zsh — Terraform helpers

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfs='terraform state'
alias tfo='terraform output'

# ═══════════════════════════════════════════════════════════
# WORKSPACE SWITCHING
# ═══════════════════════════════════════════════════════════
tf-workspace() {
    local workspace="$1"
    
    if [[ -z "$workspace" ]]; then
        workspace=$(terraform workspace list | sed 's/^*//' | tr -d ' ' | \
            fzf --prompt="Workspace: " --height=40%)
    fi
    
    [[ -z "$workspace" ]] && return 1
    
    terraform workspace select "$workspace" && {
        echo "✅ Workspace: $workspace"
        [[ "${TF_AUTO_INIT:-0}" == "1" ]] && terraform init -reconfigure
    }
}

alias tfw='tf-workspace'

# ═══════════════════════════════════════════════════════════
# PLAN + APPLY dengan konfirmasi
# ═══════════════════════════════════════════════════════════
tf-plan-apply() {
    local workspace=$(terraform workspace show)
    
    echo "📋 Planning in workspace: $workspace"
    terraform plan -out=tfplan
    
    echo ""
    echo "Apakah Anda ingin apply plan ini? (y/n)"
    read "reply?"
    
    if [[ "$reply" == "y" ]]; then
        terraform apply tfplan
        rm -f tfplan
        echo "✅ Applied"
    else
        echo "❌ Cancelled"
        rm -f tfplan
    fi
}
```

**`teams/devops/learning/01-cloud.md`:**

```markdown
# Cloud Fundamentals (AWS)

## Konsep Dasar

### Region & Availability Zone
- **Region**: Lokasi geografis (us-east-1, ap-southeast-1)
- **AZ**: Data center terisolasi dalam region (us-east-1a, us-east-1b)

### Compute
- **EC2**: Virtual machine
- **ECS/EKS**: Container orchestration
- **Lambda**: Serverless

### Storage
- **S3**: Object storage
- **EBS**: Block storage untuk EC2
- **EFS**: File storage

### Database
- **RDS**: Relational (PostgreSQL, MySQL)
- **DynamoDB**: NoSQL
- **ElastiCache**: Redis, Memcached

## Zsh Integration

```zsh
# List EC2 instances
aws ec2 describe-instances \
    --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType]' \
    --output table

# Filter dengan jq
aws ec2 describe-instances | \
    jq '.Reservations[].Instances[] | {id: .InstanceId, state: .State.Name}'

# Switch profile
awsp production
```

## Latihan

1. Setup AWS CLI profile
2. List semua EC2 di region ap-southeast-1
3. Connect ke EC2 via SSM
4. Upload file ke S3
5. Download file dari S3

## Sumber Referensi
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [AWS Free Tier](https://aws.amazon.com/free/)
```

**Capstone Project — `teams/devops/projects/deploy-pipeline/`:**

```zsh
#!/bin/zsh
# deploy-pipeline.zsh — Full deployment pipeline

set -euo pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly APP_NAME="${APP_NAME:-myapp}"
readonly ENV="${1:-staging}"
readonly VERSION="${2:-$(git rev-parse --short HEAD 2>/dev/null || echo 'latest')}"

# ═══════════════════════════════════════════════════════════
# VALIDASI
# ═══════════════════════════════════════════════════════════
case "$ENV" in
    staging|production) ;;
    *) echo "Error: env harus staging atau production" >&2; exit 1 ;;
esac

if [[ "$ENV" == "production" ]]; then
    echo "⚠️  PRODUCTION DEPLOYMENT"
    echo "App: $APP_NAME"
    echo "Version: $VERSION"
    read "reply?Lanjutkan? (y/n) "
    [[ "$reply" != "y" ]] && exit 1
fi

# ═══════════════════════════════════════════════════════════
# STEPS
# ═══════════════════════════════════════════════════════════
echo "🚀 Starting deployment: $APP_NAME@$VERSION → $ENV"

# 1. Build
echo ""
echo "📦 Building Docker image..."
docker build -t "${APP_NAME}:${VERSION}" .

# 2. Test
echo ""
echo "🧪 Running tests..."
docker run --rm "${APP_NAME}:${VERSION}" npm test

# 3. Push
echo ""
echo "📤 Pushing to registry..."
docker tag "${APP_NAME}:${VERSION}" "${ECR_URL}/${APP_NAME}:${VERSION}"
aws ecr get-login-password | docker login --username AWS --password-stdin "$ECR_URL"
docker push "${ECR_URL}/${APP_NAME}:${VERSION}"

# 4. Deploy
echo ""
echo "🚢 Deploying to Kubernetes..."
kubectl set image deployment/${APP_NAME} \
    ${APP_NAME}="${ECR_URL}/${APP_NAME}:${VERSION}" \
    --namespace="$ENV"

# 5. Wait for rollout
echo ""
echo "⏳ Waiting for rollout..."
kubectl rollout status deployment/${APP_NAME} -n "$ENV" --timeout=5m

# 6. Health check
echo ""
echo "🏥 Health check..."
kubectl run health-check --rm -it --restart=Never \
    --image=curlimages/curl -- \
    curl -sf "https://${APP_NAME}.${ENV}.nusantara.tech/health" || {
        echo "❌ Health check failed"
        echo "🔄 Rolling back..."
        kubectl rollout undo deployment/${APP_NAME} -n "$ENV"
        exit 1
    }

echo ""
echo "✅ Deployment successful!"
```

**Penjelasan Mental — Specialization Tracks:**

**Tujuan track specialization:**

1. **Fokus** — setiap tim butuh tools berbeda
2. **Depth** — belajar dalam-dalam, bukan shallow
3. **Efficiency** — tidak perlu semua orang tahu semua
4. **Career** — spesialisasi = nilai jual di market

**Struktur track:**

```
teams/<name>/
├── README.md          # Overview
├── conf.d/            # Zsh configuration
├── functions/         # Autoload functions
├── learning/          # Materials
└── projects/          # Capstone
```

**Pola yang konsisten:**

1. **Alias** — perintah sering digunakan
2. **Functions** — perintah kompleks
3. **FZF integration** — pemilihan interaktif
4. **Safety** — konfirmasi untuk operasi berbahaya
5. **Prompt** — konteks yang relevan

**Best Practice untuk Team Config:**

1. **Team lead owns** — team lead approve changes
2. **Version-controlled** — di Git, bukan lokal
3. **Tested** — test di CI
4. **Documented** — README per team
5. **Modular** — satu file per tool
6. **Idempotent** — aman di-source berkali-kali
7. **No secrets** — hanya helper, bukan credentials
8. **Progressive** — dari basic ke advanced

---

### Pertanyaan 6: Specialization Track — Data Engineering

**Tantangan:** Bangun track untuk tim Data. Fokus: ETL pipeline, data analysis, ML workflow. Tools: Python, pandas, jq, awk, Spark.

**Jawaban:**

**`teams/data/conf.d/20-python.zsh`:**

```zsh
# 20-python.zsh — Python helpers untuk Data team

# ═══════════════════════════════════════════════════════════
# VIRTUAL ENVIRONMENT
# ═══════════════════════════════════════════════════════════
venv() {
    local name="${1:-venv}"
    
    if [[ ! -d "$name" ]]; then
        echo "📦 Creating virtual environment: $name"
        python3 -m venv "$name"
    fi
    
    source "$name/bin/activate"
    echo "✅ Active: $VIRTUAL_ENV"
    
    # Auto-install requirements jika ada
    if [[ -f requirements.txt ]]; then
        echo "📥 Installing requirements..."
        pip install -r requirements.txt
    fi
}

# Auto-activate venv on cd
autoload -Uz add-zsh-hook

auto_venv() {
    [[ -d ".venv" ]] || [[ -d "venv" ]] || return 0
    [[ -n "$VIRTUAL_ENV" ]] && return 0
    
    if [[ -d ".venv" ]]; then
        source .venv/bin/activate
        echo "🔄 Activated: .venv"
    elif [[ -d "venv" ]]; then
        source venv/bin/activate
        echo "🔄 Activated: venv"
    fi
}

# Uncomment untuk aktifkan
# add-zsh-hook chpwd auto_venv

# ═══════════════════════════════════════════════════════════
# JUPYTER
# ═══════════════════════════════════════════════════════════
jup() {
    local port="${1:-8888}"
    echo "🚀 Starting Jupyter on port $port"
    jupyter notebook --port="$port" --no-browser
}

jlab() {
    local port="${1:-8888}"
    echo "🚀 Starting JupyterLab on port $port"
    jupyter lab --port="$port" --no-browser
}

# ═══════════════════════════════════════════════════════════
# PYTHON QUICK SCRIPTS
# ═══════════════════════════════════════════════════════════
py-json-pretty() {
    python3 -m json.tool
}

py-json-query() {
    local query="$1"
    python3 -c "
import json, sys
data = json.load(sys.stdin)
print(json.dumps($query, indent=2))
"
}

# ═══════════════════════════════════════════════════════════
# ALIASES
# ═══════════════════════════════════════════════════════════
alias py='python3'
alias pip='pip3'
alias pipup='pip3 install --upgrade pip'
alias pipl='pip3 list'
alias pyclean='find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true'
```

**`teams/data/conf.d/21-data-tools.zsh`:**

```zsh
# 21-data-tools.zsh — Data processing helpers

# ═══════════════════════════════════════════════════════════
# CSV OPERATIONS
# ═══════════════════════════════════════════════════════════
csv-header() {
    head -1 "$1"
}

csv-columns() {
    csv_header "$1" | tr ',' '\n' | nl
}

csv-select() {
    local file="$1"
    local cols="$2"
    
    # cols = comma-separated column numbers (1-indexed)
    awk -F',' -v cols="$cols" '
        BEGIN {
            n = split(cols, c, ",")
            OFS = ","
        }
        {
            for (i = 1; i <= n; i++) {
                printf "%s%s", $c[i], (i < n ? OFS : ORS)
            }
        }
    ' "$file"
}

csv-to-json() {
    python3 -c "
import csv, json, sys
with open('$1') as f:
    reader = csv.DictReader(f)
    print(json.dumps(list(reader), indent=2))
"
}

csv-to-tsv() {
    awk -F',' '{OFS="\t"; $1=$1; print}' "$1"
}

csv-summary() {
    local file="$1"
    
    echo "📊 Summary: $file"
    echo ""
    echo "Rows: $(wc -l < "$file" | tr -d ' ')"
    echo "Columns: $(head -1 "$file" | tr ',' '\n' | wc -l | tr -d ' ')"
    echo ""
    echo "Column headers:"
    head -1 "$file" | tr ',' '\n' | nl
}

# ═══════════════════════════════════════════════════════════
# JSON OPERATIONS
# ═══════════════════════════════════════════════════════════
jq-keys() {
    jq 'keys'
}

jq-flatten() {
    jq 'flatten'
}

jq-to-csv() {
    jq -r '.[] | [.[]] | @csv'
}

jq-from-csv() {
    # Input: CSV
    # Output: JSON array
    python3 -c "
import csv, json, sys
print(json.dumps(list(csv.DictReader(sys.stdin)), indent=2))
"
}

# ═══════════════════════════════════════════════════════════
# DATA ANALYSIS
# ═══════════════════════════════════════════════════════════
data-stats() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file" >&2
        return 1
    fi
    
    python3 -c "
import statistics
import sys
from pathlib import Path

with open('$file') as f:
    numbers = [float(line.strip()) for line in f if line.strip()]

if not numbers:
    print('No numeric data')
    sys.exit(0)

print(f'Count:  {len(numbers)}')
print(f'Mean:   {statistics.mean(numbers):.2f}')
print(f'Median: {statistics.median(numbers):.2f}')
print(f'Min:    {min(numbers):.2f}')
print(f'Max:    {max(numbers):.2f}')
if len(numbers) > 1:
    print(f'StdDev: {statistics.stdev(numbers):.2f}')
"
}

# ═══════════════════════════════════════════════════════════
# LOG ANALYSIS
# ═══════════════════════════════════════════════════════════
log-top-errors() {
    local file="$1"
    local n="${2:-10}"
    
    grep -iE 'error|fail|exception' "$file" | \
        awk '{$1=$2=""; print}' | \
        sort | uniq -c | sort -rn | head -"$n"
}

log-requests-per-minute() {
    local file="$1"
    
    # Asumsi: timestamp di awal baris (format Apache)
    awk '{print substr($4, 2, 17)}' "$file" | \
        sort | uniq -c
}
```

**`teams/data/learning/01-etl.md`:**

```markdown
# ETL Pipeline dengan Zsh

## Konsep ETL

- **Extract**: Ambil data dari sumber (API, DB, file)
- **Transform**: Bersihkan, agregasi, format ulang
- **Load**: Simpan ke tujuan (DB, file, dashboard)

## Extract

```zsh
# Dari API
curl -s https://api.example.com/data | jq '.items' > raw.json

# Dari database
psql -U user -d db --csv -c "SELECT * FROM users" > users.csv

# Dari file
cat data.csv
```

## Transform

```zsh
# Dengan jq
jq '[.items[] | select(.status == "active")]' raw.json > active.json

# Dengan awk
awk -F',' '$3 > 100 {print $1, $3}' data.csv

# Dengan python
python3 -c "
import json
with open('raw.json') as f:
    data = json.load(f)
result = [d for d in data if d['age'] > 18]
print(json.dumps(result))
"
```

## Load

```zsh
# Ke database
cat result.json | jq -r '.[] | [.id, .name] | @csv' | \
    psql -U user -d db -c "COPY users FROM STDIN CSV"

# Ke file
echo "$result" > output.json

# Ke S3
aws s3 cp output.json s3://bucket/output/
```

## Contoh Pipeline Lengkap

```zsh
#!/bin/zsh
set -euo pipefail

# Extract
echo "📥 Extracting..."
curl -s https://api.example.com/users > /tmp/users.json

# Transform
echo "🔄 Transforming..."
cat /tmp/users.json | jq '
    [.users[] | 
     select(.active == true) | 
     {id: .id, name: .name, email: .email}]
' > /tmp/active_users.json

# Load
echo "📤 Loading..."
aws s3 cp /tmp/active_users.json s3://nusantara-data/users/

# Cleanup
rm /tmp/users.json /tmp/active_users.json

echo "✅ Pipeline complete"
```
```

**Capstone — `teams/data/projects/etl-pipeline/`:**

```zsh
#!/bin/zsh
# etl-pipeline.zsh — Full ETL pipeline dengan monitoring

set -euo pipefail

readonly PIPELINE_NAME="user-analytics"
readonly LOG_FILE="/var/log/etl/${PIPELINE_NAME}.log"
readonly DATA_DIR="/data/etl/${PIPELINE_NAME}"
readonly DATE=$(date +%Y%m%d)

log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $*" | tee -a "$LOG_FILE"
}

# ═══════════════════════════════════════════════════════════
# EXTRACT
# ═══════════════════════════════════════════════════════════
extract() {
    log "📥 Extracting data..."
    
    mkdir -p "$DATA_DIR/raw"
    
    # 1. Dari API
    curl -sf "https://api.nusantara.tech/users" > "$DATA_DIR/raw/users.json"
    
    # 2. Dari database
    psql -U etl_user -d analytics --csv -c "
        SELECT * FROM events WHERE date = '$DATE'
    " > "$DATA_DIR/raw/events.csv"
    
    # 3. Dari S3
    aws s3 cp "s3://nusantara-logs/${DATE}/app.log" "$DATA_DIR/raw/app.log"
    
    log "✅ Extract selesai"
}

# ═══════════════════════════════════════════════════════════
# TRANSFORM
# ═══════════════════════════════════════════════════════════
transform() {
    log "🔄 Transforming data..."
    
    mkdir -p "$DATA_DIR/transformed"
    
    # 1. Filter active users
    jq '[.[] | select(.active == true)]' \
        "$DATA_DIR/raw/users.json" > "$DATA_DIR/transformed/active_users.json"
    
    # 2. Aggregate events per user
    python3 <<PYEOF
import csv
import json
from collections import defaultdict

events = defaultdict(int)
with open('$DATA_DIR/raw/events.csv') as f:
    reader = csv.DictReader(f)
    for row in reader:
        events[row['user_id']] += 1

with open('$DATA_DIR/transformed/event_counts.json', 'w') as f:
    json.dump(dict(events), f, indent=2)
PYEOF
    
    # 3. Parse app log
    log-top-errors "$DATA_DIR/raw/app.log" 100 > "$DATA_DIR/transformed/top_errors.txt"
    
    log "✅ Transform selesai"
}

# ═══════════════════════════════════════════════════════════
# LOAD
# ═══════════════════════════════════════════════════════════
load() {
    log "📤 Loading data..."
    
    # 1. Upload ke S3
    aws s3 cp "$DATA_DIR/transformed/" "s3://nusantara-analytics/${DATE}/" \
        --recursive --quiet
    
    # 2. Insert ke database
    cat "$DATA_DIR/transformed/event_counts.json" | \
        jq -r 'to_entries[] | [.key, .value] | @csv' | \
        psql -U etl_user -d analytics -c "
            CREATE TEMP TABLE tmp_events (user_id text, count int);
            COPY tmp_events FROM STDIN WITH CSV;
            INSERT INTO event_counts (date, user_id, count)
            SELECT '$DATE', user_id, count FROM tmp_events
            ON CONFLICT (date, user_id) DO UPDATE SET count = EXCLUDED.count;
        "
    
    log "✅ Load selesai"
}

# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════
main() {
    log "🚀 Starting pipeline: $PIPELINE_NAME"
    log "Date: $DATE"
    
    extract
    transform
    load
    
    log "🎉 Pipeline complete!"
    
    # Report
    log "Summary:"
    log "  Users processed: $(jq length "$DATA_DIR/transformed/active_users.json")"
    log "  Events: $(jq 'to_entries | map(.value) | add' "$DATA_DIR/transformed/event_counts.json")"
}

main "$@"
```

**Penjelasan Mental — Data Track:**

**Fokus Data Track:**

1. **Data manipulation** — awk, sed, jq
2. **Python integration** — pandas, numpy
3. **ETL patterns** — extract, transform, load
4. **Analysis** — statistics, visualization
5. **Pipeline** — automation, scheduling

**Tools Esensial:**

| Tool | Purpose |
|---|---|
| `jq` | JSON processing |
| `awk` | Text processing |
| `sed` | Stream editing |
| `csvkit` | CSV operations |
| `mlr` (Miller) | CSV/JSON processing |
| `python3` | Complex logic |
| `pandas` | Data analysis |

**Pola ETL:**

```
Extract → Validate → Transform → Enrich → Aggregate → Load → Verify
```

**Best Practice Data Pipeline:**

1. **Idempotent** — aman dijalankan berkali-kali
2. **Logged** — setiap step tercatat
3. **Monitored** — metrics dikumpulkan
4. **Tested** — unit test per step
5. **Modular** — function per operation
6. **Fault-tolerant** — retry, rollback
7. **Versioned** — data versioned
8. **Documented** — schema, lineage

---

### Pertanyaan 7: Specialization Track — Developer Tooling

**Tantangan:** Bangun track untuk Developer Tooling. Fokus: CLI tools, editor integration, productivity tools (FZF, ripgrep, fd, bat, zoxide).

**Jawaban:**

**`teams/tooling/conf.d/20-modern-cli.zsh`:**

```zsh
# 20-modern-cli.zsh — Modern CLI tools

# ═══════════════════════════════════════════════════════════
# BAT (cat dengan syntax highlighting)
# ═══════════════════════════════════════════════════════════
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
    alias catl='bat --style=plain'
    export BAT_THEME="TwoDark"
    export BAT_STYLE="numbers,changes,header"
fi

# ═══════════════════════════════════════════════════════════
# EZA / LSD (ls modern)
# ═══════════════════════════════════════════════════════════
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
    alias ltt='eza --tree --icons --level=3'
    alias lg='eza -la --icons --git --sort=size'
elif command -v lsd &>/dev/null; then
    alias ls='lsd --group-dirs first'
    alias ll='lsd -la --group-dirs first'
fi

# ═══════════════════════════════════════════════════════════
# RIPGREP (grep modern)
# ═══════════════════════════════════════════════════════════
if command -v rg &>/dev/null; then
    alias grep='rg'
    alias rgi='rg -i'
    alias rgw='rg -w'
    alias rgl='rg -l'
    alias rgn='rg --no-ignore'
    alias rgu='rg --hidden --no-ignore'
    
    export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"
fi

# ═══════════════════════════════════════════════════════════
# FD (find modern)
# ═══════════════════════════════════════════════════════════
if command -v fd &>/dev/null; then
    alias find='fd'
    alias fdh='fd --hidden'
    alias fdi='fd --no-ignore'
    alias fdhi='fd --hidden --no-ignore'
fi

# ═══════════════════════════════════════════════════════════
# ZOXIDE (cd pintar)
# ═══════════════════════════════════════════════════════════
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    # z <dir>   - jump ke direktori
    # zi        - interactive dengan fzf
fi

# ═══════════════════════════════════════════════════════════
# DELTA (git diff viewer)
# ═══════════════════════════════════════════════════════════
if command -v delta &>/dev/null; then
    export GIT_PAGER='delta'
    export DELTA_FEATURES='side-by-side line-numbers decorations'
    export DELTA_NAVIGATE='true'
fi
```

**`teams/tooling/conf.d/21-fzf.zsh`:**

```zsh
# 21-fzf.zsh — FZF integration

# ═══════════════════════════════════════════════════════════
# FZF CONFIG
# ═══════════════════════════════════════════════════════════
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --inline-info
    --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
    --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7
"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --level=2 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind \"?:toggle-preview\""

# Source FZF shell integration
source <(fzf --zsh)

# ═══════════════════════════════════════════════════════════
# CUSTOM FZF FUNCTIONS
# ═══════════════════════════════════════════════════════════

# Ctrl+G — Git branch
fzf-git-branch() {
    local branch
    branch=$(git branch -a --color=always | \
        grep -v '/HEAD\s' | \
        fzf --ansi \
            --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | sed "s/.* //")' \
            --preview-window='right:60%' \
        | sed 's/.* //')
    
    [[ -n "$branch" ]] && echo "$branch"
}

# Ctrl+O — Open file
fzf-file-open() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}')
    [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

# Ctrl+P — Process kill
fzf-process-kill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --preview 'ps -p {1} -o pid,cmd' | awk '{print $2}')
    [[ -n "$pid" ]] && kill -9 "$pid"
}

# Alt+S — Search content
fzf-search-content() {
    local query="$1"
    [[ -z "$query" ]] && read "query?Search: "
    
    local result
    result=$(rg --line-number --no-heading --color=always "$query" | \
        fzf --ansi --delimiter=':' \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '+{2}-5')
    
    [[ -z "$result" ]] && return
    
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    
    ${EDITOR:-vim} "+$line" "$file"
}

# Keybindings
bindkey -s '^G' 'fzf-git-branch\n'
bindkey -s '^O' 'fzf-file-open\n'
bindkey -s '^P' 'fzf-process-kill\n'
bindkey -s '\es' 'fzf-search-content\n'
```

**`teams/tooling/conf.d/22-editor.zsh`:**

```zsh
# 22-editor.zsh — Editor integration

export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"

# ═══════════════════════════════════════════════════════════
# EDITOR WRAPPERS
# ═══════════════════════════════════════════════════════════

# v — open file (dengan fzf jika tanpa argumen)
v() {
    if [[ $# -eq 0 ]]; then
        local file
        file=$(fd --type f --hidden --exclude .git | \
            fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}')
        [[ -n "$file" ]] && $EDITOR "$file"
    else
        $EDITOR "$@"
    fi
}

# vg — open file dari git repo
vg() {
    local file
    file=$(git ls-files | fzf --preview 'bat --color=always {}')
    [[ -n "$file" ]] && $EDITOR "$file"
}

# vs — search content dan open
vs() {
    local query="$1"
    [[ -z "$query" ]] && read "query?Search: "
    
    local result
    result=$(rg --line-number --no-heading --color=always "$query" | \
        fzf --ansi --delimiter=':' \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '+{2}-5')
    
    [[ -z "$result" ]] && return
    
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    
    $EDITOR "+$line" "$file"
}

# ═══════════════════════════════════════════════════════════
# VS CODE
# ═══════════════════════════════════════════════════════════
if command -v code &>/dev/null; then
    alias c='code'
    alias c.='code .'
fi
```

**`teams/tooling/learning/01-cli-tools.md`:**

```markdown
# Modern CLI Tools

## Mengapa Tools Modern?

Tools Unix tradisional (cat, ls, grep, find) sudah ada sejak 1970-an.
Tools modern menawarkan:
- **Warna** — output lebih mudah dibaca
- **Git integration** — respect .gitignore
- **Speed** — ditulis dalam Rust/Go
- **UX** — flag lebih intuitif

## Perbandingan

| Traditional | Modern | Keunggulan |
|---|---|---|
| `cat` | `bat` | Syntax highlighting |
| `ls` | `eza`, `lsd` | Icons, git status |
| `grep` | `ripgrep` | Lebih cepat, .gitignore |
| `find` | `fd` | Sintaks intuitif |
| `cd` | `zoxide` | Frequency-based |
| `diff` | `delta` | Side-by-side |

## FZF — Fuzzy Finder

FZF adalah "game changer" untuk terminal:
- Cari file: `Ctrl+T`
- Cari history: `Ctrl+R`
- Cari direktori: `Alt+C`

Dengan preview, pencarian menjadi visual.

## Contoh Penggunaan

```zsh
# Cari file dan buka
fd --type f | fzf --preview 'bat {}' | xargs nvim

# Cari konten dan buka
rg "function" | fzf | ...
```

## Install

```bash
# macOS
brew install bat eza ripgrep fd zoxide fzf delta

# Ubuntu
sudo apt install bat fd-find ripgrep fzf

# Cargo (universal)
cargo install bat eza ripgrep fd-find zoxide
```
```

**Capstone — `teams/tooling/projects/dev-toolbox/`:**

```zsh
#!/bin/zsh
# dev-toolbox.zsh — Interactive developer toolbox

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# MENU
# ═══════════════════════════════════════════════════════════
main_menu() {
    local options=(
        "📁 Cari file"
        "🔍 Cari konten"
        "🌿 Git operations"
        "📝 Edit file"
        "🐳 Docker"
        "☸️  Kubernetes"
        "📊 System info"
        "🚪 Exit"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="Pilih: " --height=40%)
    
    case "$choice" in
        "📁 Cari file")     search_files ;;
        "🔍 Cari konten")   search_content ;;
        "🌿 Git operations") git_menu ;;
        "📝 Edit file")     edit_file ;;
        "🐳 Docker")        docker_menu ;;
        "☸️  Kubernetes")   k8s_menu ;;
        "📊 System info")   system_info ;;
        "🚪 Exit")          return 0 ;;
    esac
}

# ═══════════════════════════════════════════════════════════
# SEARCH FILES
# ═══════════════════════════════════════════════════════════
search_files() {
    local file
    file=$(fd --type f --hidden --exclude .git | \
        fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}')
    
    [[ -z "$file" ]] && return
    
    local action
    action=$(printf "📝 Edit\n📋 Copy path\n📂 Show dir\n🗑️  Delete" | \
        fzf --prompt="Action: " --height=20%)
    
    case "$action" in
        "📝 Edit")       ${EDITOR:-vim} "$file" ;;
        "📋 Copy path")  echo -n "$file" | pbcopy 2>/dev/null || echo "$file" | xclip -selection clipboard 2>/dev/null ;;
        "📂 Show dir")   ls -la "$(dirname "$file")" ;;
        "🗑️  Delete")    rm -i "$file" ;;
    esac
}

# ═══════════════════════════════════════════════════════════
# SEARCH CONTENT
# ═══════════════════════════════════════════════════════════
search_content() {
    read "query?🔍 Query: "
    [[ -z "$query" ]] && return
    
    local result
    result=$(rg --line-number --no-heading --color=always "$query" | \
        fzf --ansi --delimiter=':' \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '+{2}-5')
    
    [[ -z "$result" ]] && return
    
    local file=$(echo "$result" | cut -d: -f1)
    local line=$(echo "$result" | cut -d: -f2)
    
    ${EDITOR:-vim} "+$line" "$file"
}

# ═══════════════════════════════════════════════════════════
# GIT MENU
# ═══════════════════════════════════════════════════════════
git_menu() {
    local options=(
        "📊 Status"
        "📝 Commit"
        "🌿 Branches"
        "📜 Log"
        "🔄 Pull"
        "📤 Push"
        "📦 Stash"
    )
    
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="Git: " --height=40%)
    
    case "$choice" in
        "📊 Status")   git status ;;
        "📝 Commit")   git_commit ;;
        "🌿 Branches") git_branches ;;
        "📜 Log")      git log --oneline --graph --decorate | head -30 ;;
        "🔄 Pull")     git pull ;;
        "📤 Push")     git push ;;
        "📦 Stash")    git stash list ;;
    esac
}

git_commit() {
    git status --short
    
    echo ""
    read "message?Commit message: "
    [[ -z "$message" ]] && return
    
    git add -A
    git commit -m "$message"
}

git_branches() {
    local branch
    branch=$(git branch -a --color=always | \
        fzf --ansi --preview 'git log --oneline -20 $(echo {} | sed "s/.* //")' \
        | sed 's/.* //')
    
    [[ -z "$branch" ]] && return
    
    git checkout "$branch"
}

# ═══════════════════════════════════════════════════════════
# EDIT FILE
# ═══════════════════════════════════════════════════════════
edit_file() {
    local file
    file=$(fd --type f --hidden --exclude .git | \
        fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}')
    
    [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

# ═══════════════════════════════════════════════════════════
# SYSTEM INFO
# ═══════════════════════════════════════════════════════════
system_info() {
    echo "════════════════════════════════════════"
    echo "  System Info"
    echo "════════════════════════════════════════"
    echo ""
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Uptime: $(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')"
    echo "OS: $(uname -s) $(uname -r)"
    echo "Shell: $SHELL"
    echo "Zsh: $ZSH_VERSION"
    echo ""
    echo "Memory:"
    free -h 2>/dev/null || vm_stat
    echo ""
    echo "Disk:"
    df -h / 2>/dev/null
    echo ""
    echo "Top Processes:"
    ps aux --sort=-%cpu | head -6 2>/dev/null || ps aux | head -6
    echo ""
    read "reply?Press Enter to continue..."
}

# ═══════════════════════════════════════════════════════════
# MAIN LOOP
# ═══════════════════════════════════════════════════════════
while main_menu; do
    :
done

echo "👋 Bye!"
```

**Penjelasan Mental — Tooling Track:**

**Fokus Tooling Track:**

1. **Productivity** — tools yang menghemat waktu
2. **Integration** — editor, terminal, git
3. **Customization** — sesuai workflow
4. **Automation** — script untuk tasks berulang

**Tools Esensial:**

| Tool | Purpose |
|---|---|
| `fzf` | Fuzzy finder |
| `ripgrep` | Search content |
| `fd` | Find files |
| `bat` | View files |
| `eza` | List directories |
| `zoxide` | Smart cd |
| `delta` | Git diff |
| `jq` | JSON |
| `yq` | YAML |

**FZF Patterns:**

1. **Preview** — selalu berikan konteks
2. **Bindings** — `Ctrl+T`, `Ctrl+R`, `Alt+C`
3. **Custom functions** — untuk workflow spesifik
4. **Integration** — dengan tools lain

**Best Practice Tooling:**

1. **Learn the shortcuts** — 10 menit belajar = 100 jam hemat
2. **Customize gradually** — jangan overwhelm
3. **Document your setup** — untuk diri sendiri dan tim
4. **Share with team** — kontribusi ke team config

---

### Pertanyaan 8: Kontribusi ke Open Source — Plugin Zsh

**Tantangan:** Setelah kontribusi ke Zsh core, Anda ingin berkontribusi lebih — buat plugin Zsh yang bermanfaat untuk komunitas. Plugin harus: (a) mengikuti standar, (b) terdokumentasi, (c) ter-test, (d) siap digunakan.

**Jawaban:**

**Plugin Idea:** `zsh-clipboard-history` — menyimpan clipboard history dengan FZF integration.

**Struktur Plugin:**

```
zsh-clipboard-history/
├── zsh-clipboard-history.plugin.zsh    # Entry point
├── functions/
│   └── _zch
├── completions/
│   └── _zch
├── tests/
│   └── spec/
│       └── clipboard_spec.sh
├── README.md
├── LICENSE
├── CHANGELOG.md
└── .github/
    └── workflows/
        └── test.yml
```

**`zsh-clipboard-history.plugin.zsh`:**

```zsh
# zsh-clipboard-history.plugin.zsh — Entry point

# ═══════════════════════════════════════════════════════════
# STANDARD $0 HANDLING
# ═══════════════════════════════════════════════════════════
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

readonly ZCH_DIR="${0:A:h}"

# ═══════════════════════════════════════════════════════════
# FPATH
# ═══════════════════════════════════════════════════════════
[[ -d "$ZCH_DIR/functions" ]] && fpath=("$ZCH_DIR/functions" $fpath)
[[ -d "$ZCH_DIR/completions" ]] && fpath=("$ZCH_DIR/completions" $fpath)

# ═══════════════════════════════════════════════════════════
# CONFIG
# ═══════════════════════════════════════════════════════════
: ${ZCH_HISTORY_FILE:="$HOME/.cache/zsh-clipboard-history"}
: ${ZCH_MAX_ENTRIES:=1000}
: ${ZCH_KEYBIND:="^Y"}

mkdir -p "${ZCH_HISTORY_FILE:h}"

# ═══════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════

# Deteksi OS
_zch_detect_os() {
    case "$OSTYPE" in
        darwin*) echo "macos" ;;
        linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Get clipboard content
_zch_get_clipboard() {
    local os=$(_zch_detect_os)
    case "$os" in
        macos) pbpaste 2>/dev/null ;;
        linux)
            if command -v xclip &>/dev/null; then
                xclip -selection clipboard -o 2>/dev/null
            elif command -v xsel &>/dev/null; then
                xsel --clipboard --output 2>/dev/null
            elif command -v wl-paste &>/dev/null; then
                wl-paste 2>/dev/null
            fi
            ;;
    esac
}

# Set clipboard content
_zch_set_clipboard() {
    local content="$1"
    local os=$(_zch_detect_os)
    case "$os" in
        macos) echo -n "$content" | pbcopy ;;
        linux)
            if command -v xclip &>/dev/null; then
                echo -n "$content" | xclip -selection clipboard
            elif command -v xsel &>/dev/null; then
                echo -n "$content" | xsel --clipboard --input
            elif command -v wl-copy &>/dev/null; then
                echo -n "$content" | wl-copy
            fi
            ;;
    esac
}

# Save clipboard entry
zch-save() {
    local content="${1:-$(_zch_get_clipboard)}"
    [[ -z "$content" ]] && return 1
    
    # Skip jika sama dengan yang terakhir
    if [[ -f "$ZCH_HISTORY_FILE" ]]; then
        local last=$(tail -1 "$ZCH_HISTORY_FILE")
        [[ "$content" == "$last" ]] && return 0
    fi
    
    # Simpan (dengan base64 untuk handle multiline)
    echo "$content" | base64 >> "$ZCH_HISTORY_FILE"
    
    # Trim jika terlalu panjang
    if [[ $(wc -l < "$ZCH_HISTORY_FILE") -gt $ZCH_MAX_ENTRIES ]]; then
        tail -n "$ZCH_MAX_ENTRIES" "$ZCH_HISTORY_FILE" > "${ZCH_HISTORY_FILE}.tmp"
        mv "${ZCH_HISTORY_FILE}.tmp" "$ZCH_HISTORY_FILE"
    fi
}

# List entries
zch-list() {
    [[ -f "$ZCH_HISTORY_FILE" ]] || return 1
    
    # Reverse (terbaru dulu), decode
    tac "$ZCH_HISTORY_FILE" 2>/dev/null | while IFS= read -r line; do
        echo "$line" | base64 -d 2>/dev/null
        echo "---SEPARATOR---"
    done | head -n -1  # Hapus separator terakhir
}

# Interactive picker
zch-pick() {
    command -v fzf &>/dev/null || {
        echo "fzf tidak terinstall" >&2
        return 1
    }
    
    local selected
    selected=$(zch-list | fzf --read0 --print0 --prompt="📋 Clipboard: " | tr '\0' '\n')
    
    [[ -z "$selected" ]] && return 1
    
    _zch_set_clipboard "$selected"
    echo "✅ Copied to clipboard"
}

# Clear history
zch-clear() {
    read "reply?Hapus semua history? (y/n) "
    [[ "$reply" != "y" ]] && return 1
    
    : > "$ZCH_HISTORY_FILE"
    echo "✅ History cleared"
}

# Statistics
zch-stats() {
    [[ -f "$ZCH_HISTORY_FILE" ]] || { echo "No history"; return; }
    
    local count=$(wc -l < "$ZCH_HISTORY_FILE")
    local size=$(du -h "$ZCH_HISTORY_FILE" | cut -f1)
    
    echo "📊 Clipboard History Stats"
    echo "  Entries: $count"
    echo "  Size: $size"
    echo "  File: $ZCH_HISTORY_FILE"
}

# ═══════════════════════════════════════════════════════════
# HOOK: Auto-save clipboard saat precmd
# ═══════════════════════════════════════════════════════════
autoload -Uz add-zsh-hook
add-zsh-hook precmd zch-save

# ═══════════════════════════════════════════════════════════
# KEYBIND
# ═══════════════════════════════════════════════════════════
bindkey -s "$ZCH_KEYBIND" 'zch-pick\n'

# ═══════════════════════════════════════════════════════════
# CLEAN UNLOAD
# ═══════════════════════════════════════════════════════════
typeset -ga _zch_functions=(
    zch-save
    zch-list
    zch-pick
    zch-clear
    zch-stats
    _zch_detect_os
    _zch_get_clipboard
    _zch_set_clipboard
)
```

**`completions/_zch`:**

```zsh
#compdef zch zch-pick zch-save zch-list zch-clear zch-stats

_zch() {
    local -a commands
    commands=(
        'pick:Pilih dari history'
        'list:List semua history'
        'save:Simpan ke history'
        'clear:Hapus history'
        'stats:Statistik'
    )
    
    _arguments -C \
        '1:command:->command' \
        '*::arg:->args'
    
    case "$state" in
        command)
            _describe -t commands 'command' commands
            ;;
    esac
}

_zch "$@"
```

**`tests/spec/clipboard_spec.sh`:**

```zsh
# tests/spec/clipboard_spec.sh

Include zsh-clipboard-history.plugin.zsh

Describe 'zsh-clipboard-history'
    # Setup mock file
    setup() {
        export ZCH_HISTORY_FILE="$(mktemp)"
        export ZCH_MAX_ENTRIES=10
    }
    
    cleanup() {
        rm -f "$ZCH_HISTORY_FILE"
    }
    
    BeforeEach 'setup'
    AfterEach 'cleanup'

    Describe 'zch-save'
        It 'menyimpan konten ke history'
            When call zch-save "hello world"
            The file "$ZCH_HISTORY_FILE" should be exist
            The line 1 of file "$ZCH_HISTORY_FILE" should eq "$(echo 'hello world' | base64)"
        End

        It 'mengabaikan konten kosong'
            When call zch-save ""
            The status should be failure
        End

        It 'tidak menyimpan duplikat berturut-turut'
            zch-save "hello"
            zch-save "hello"
            The line count of file "$ZCH_HISTORY_FILE" should eq 1
        End
    End

    Describe 'zch-list'
        It 'menampilkan semua entries'
            zch-save "first"
            zch-save "second"
            When call zch-list
            The output should include "first"
            The output should include "second"
        End
    End

    Describe 'zch-clear'
        It 'menghapus semua history'
            zch-save "test"
            echo "y" | zch-clear
            The line count of file "$ZCH_HISTORY_FILE" should eq 0
        End
    End
End
```

**`README.md`:**

```markdown
# zsh-clipboard-history

Clipboard history untuk Zsh dengan FZF integration.

## Features

- 📋 Otomatis menyimpan clipboard ke history
- 🔍 Cari history dengan FZF
- 🌍 Cross-platform (macOS, Linux)
- ⚡ Ringan (<5ms overhead per prompt)
- 🎨 Terintegrasi dengan workflow

## Instalasi

### Antidote

```bash
# Tambahkan ke ~/.zsh_plugins.txt
yourusername/zsh-clipboard-history
```

### Oh My Zsh

```bash
git clone https://github.com/yourusername/zsh-clipboard-history \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-clipboard-history

# Tambahkan ke plugins=() di .zshrc
plugins=(... zsh-clipboard-history)
```

### Manual

```bash
git clone https://github.com/yourusername/zsh-clipboard-history \
    ~/.zsh/plugins/zsh-clipboard-history

# Source di .zshrc
source ~/.zsh/plugins/zsh-clipboard-history/zsh-clipboard-history.plugin.zsh
```

## Usage

### Keybinding

- `Ctrl+Y` — Buka FZF picker untuk clipboard history

### Commands

```bash
zch-pick     # Interactive picker
zch-list     # List semua history
zch-save     # Simpan manual
zch-clear    # Hapus history
zch-stats    # Statistik
```

## Konfigurasi

Set di `.zshrc` sebelum sourcing plugin:

```zsh
export ZCH_HISTORY_FILE="$HOME/.cache/zsh-clipboard-history"
export ZCH_MAX_ENTRIES=1000
export ZCH_KEYBIND="^Y"  # Ctrl+Y
```

## Requirements

- Zsh 5.0+
- fzf (untuk interactive picker)
- xclip atau xsel (Linux)
- pbcopy/pbpaste (macOS)

## Development

```bash
git clone https://github.com/yourusername/zsh-clipboard-history
cd zsh-clipboard-history

# Install ShellSpec
curl -fsSL https://git.io/shellspec | sh

# Run tests
shellspec

# Lint
shellcheck zsh-clipboard-history.plugin.zsh
```

## License

MIT

## Contributing

PRs welcome! Lihat CONTRIBUTING.md untuk panduan.
```

**`.github/workflows/test.yml`:**

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Zsh
        run: |
          if [[ "$RUNNER_OS" == "Linux" ]]; then
            sudo apt-get install -y zsh fzf xclip
          else
            brew install zsh fzf
          fi
      
      - name: Install ShellSpec
        run: |
          curl -fsSL https://git.io/shellspec | sh -s -- --yes
          sudo ln -sf $PWD/shellspec /usr/local/bin/shellspec
      
      - name: Run tests
        run: shellspec
      
      - name: ShellCheck
        run: shellcheck --shell=zsh zsh-clipboard-history.plugin.zsh
```

**Publishing:**

```bash
# Tag release
git tag -a v0.1.0 -m "First release"
git push origin v0.1.0

# Register di awesome-zsh-plugins
# 1. Fork https://github.com/unixorn/awesome-zsh-plugins
# 2. Tambah entry di README.md
# 3. Submit PR
```

**Penjelasan Mental — Plugin Open Source:**

**Anatomi Plugin yang Baik:**

1. **Entry point** — `*.plugin.zsh` di root
2. **Standard `$0` handling** — untuk portabilitas
3. **fpath** — tambahkan functions/ dan completions/
4. **Config** — environment variables dengan default
5. **Functions** — prefix untuk namespace
6. **Hook** — jika perlu reactive behavior
7. **Keybinding** — configurable
8. **Clean unload** — daftarkan functions untuk cleanup
9. **Completion** — untuk commands
10. **Tests** — ShellSpec
11. **README** — install, usage, config
12. **LICENSE** — biasanya MIT
13. **CHANGELOG** — untuk tracking changes
14. **CI** — GitHub Actions

**Mengapa Plugin Penting:**

1. **Reusable** — bisa digunakan banyak orang
2. **Composable** — dengan plugin lain
3. **Standard** — mengikuti konvensi
4. **Testable** — bisa di-test otomatis
5. **Distributable** — via plugin manager

**Community Standards:**

- **Zsh Plugin Standard** — https://wiki.zshell.dev/community/zsh_plugin_standard
- **Awesome Zsh Plugins** — https://github.com/unixorn/awesome-zsh-plugins
- **Plugin name**: `<scope>-<feature>` (misalnya `zsh-clipboard-history`)
- **Prefix**: pendek, unik (misalnya `zch`)

**Best Practice:**

1. **Namespace** — semua functions dengan prefix
2. **Configurable** — environment variables
3. **Document** — README yang jelas
4. **Test** — CI dengan ShellSpec
5. **Version** — semver
6. **Compatible** — Oh My Zsh, Antidote, Zinit, manual
7. **Fast** — <5ms startup overhead
8. **Robust** — handle error gracefully

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Diagram Arsitektur Enterprise** — Tiga layer (Foundation, Team, Personal) dengan repository Git di atas, Ansible di tengah, dan 120 mesin di bawah. Tandai alur deploy.
>
> 2. **Peta Compliance** — Matriks: Framework (SOC 2, ISO 27001) × Requirement × Implementation × Evidence. Tandai overlap antar framework.
>
> 3. **Flow Kontribusi Open Source** — Flowchart: Issue → Discussion → Patch → Review → Merge → Release. Tandai waktu rata-rata setiap step.
>
> 4. **Track Spesialisasi** — Tiga kolom paralel (DevOps, Data, Tooling) dengan sub-topik di bawah masing-masing. Tandai overlap (fondasi bersama).
>
> 5. **Timeline Proyek 3 Bulan** — Gantt chart: Bulan 1 (arsitektur), Bulan 2 (implementation), Bulan 3 (audit & kontribusi). Tandai milestone.
>
> 6. **Layer Interaction** — Diagram yang menunjukkan bagaimana Layer 3 override Layer 2 override Layer 1. Tandai mana yang "bisa di-override" vs "tidak bisa".

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.1 (Fondasi)** | Layer 1 adalah fondasi semua |
| **7.2 (Scripting)** | Script untuk automation, deploy |
| **7.3 (Konfigurasi)** | Layer system adalah aplikasi langsung |
| **7.4 (Performa)** | Audit, keamanan, monitoring di-scale ke 120 mesin |
| **7.5 (CLI Tool)** | `nt` adalah bagian dari ekosistem enterprise |
| **Fase 6 (Kurikulum)** | Modul ini adalah aplikasi langsung dari: arsitektur, kontribusi, spesialisasi |

---

## 9. Sumber Referensi Lengkap

- **Ansible Documentation** — https://docs.ansible.com/
- **Ansible Best Practices** — https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
- **SOC 2 Trust Services Criteria** — https://www.aicpa-cima.com/resources/download/2017-trust-services-criteria-with-revised-points-of-focus-2022
- **ISO 27001** — https://www.iso.org/standard/27001
- **OWASP Secrets Management** — https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- **Zsh Development Guide** — https://github.com/zsh-users/zsh/blob/master/Etc/zsh-development-guide
- **Zsh Plugin Standard** — https://wiki.zshell.dev/community/zsh_plugin_standard
- **Awesome Zsh Plugins** — https://github.com/unixorn/awesome-zsh-plugins
- **Git send-email** — https://git-scm.com/docs/git-send-email
- **Zsh Mailing List Archive** — https://www.zsh.org/mla/
- **Kubernetes Documentation** — https://kubernetes.io/docs/
- **AWS CLI Reference** — https://docs.aws.amazon.com/cli/
- **Terraform Documentation** — https://developer.hashicorp.com/terraform/docs
- **FZF Wiki** — https://github.com/junegunn/fzf/wiki

---

## 10. Tips dan Praktik Terbaik

1. **Policy as Code.** Kebijakan = kode yang di-version-control.
2. **Idempotent deployment.** Aman dijalankan berkali-kali.
3. **Layer separation.** Foundation, Team, Personal.
4. **Audit trail wajib.** Setiap perubahan tercatat.
5. **Compliance otomatis.** Report reguler, bukan manual.
6. **Rollback plan.** Setiap perubahan harus bisa di-revert.
7. **Test sebelum deploy.** Staging → production.
8. **Gradual rollout.** 5 host → 50 → 120.
9. **Document decisions.** ADR untuk keputusan besar.
10. **Give back to open source.** Kontribusi bukan optional.
11. **One patch = one fix.** Untuk kontribusi upstream.
12. **Be patient.** Maintainer sukarelawan.
13. **Specialization.** Setiap tim punya track sendiri.
14. **Common foundation.** Keamanan & config dasar untuk semua.
15. **Documentation is product.** Untuk 120 developer, ini wajib.
16. **Onboarding <5 menit.** Zero-config ideal.
17. **Monitor everything.** Metrics, logs, traces.
18. **Automate evidence.** Untuk audit compliance.
19. **Test in production-like.** Bukan hanya staging.
20. **Continuous improvement.** Retrospective, feedback.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Deploy tanpa idempotent | PATH duplikat, config corrupt | Gunakan Ansible/Puppet |
| Tidak ada backup | Tidak bisa rollback | Backup before deploy |
| Deploy langsung ke prod | Downtime, error masif | Staging dulu, gradual rollout |
| Tidak ada audit trail | Tidak bisa investigasi | Log semua perubahan |
| Secrets di config | Security breach | Secret manager |
| Manual evidence | Audit gagal | Automate compliance report |
| Breaking change tanpa deprecation | User frustrasi | Deprecation period |
| Patch besar tanpa diskusi | Ditolak | Diskusi di list dulu |
| Top-post di mailing list | Diabaikan | Bottom-post |
| HTML email | Di-reject | Plain text |
| No tests di plugin | Regression | ShellSpec tests |
| Tidak ada CI | Deploy manual | GitHub Actions |
| Layer tidak jelas | Konflik config | Layer 1/2/3 yang jelas |
| Override berlebihan | Sulit di-maintain | Dokumentasi yang jelas |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.6, Anda seharusnya mencapai **level Expert** dengan mental model:

1. **Architect as Steward.** Anda menjaga sistem untuk generasi berikutnya.
2. **Policy as Code.** Kebijakan = kode yang testable.
3. **Compliance as Evidence.** Bukan "melakukan", tapi "membuktikan".
4. **Give Back.** Open source = tanggung jawab untuk kontribusi.
5. **Layer Separation.** Foundation, Team, Personal — jelas batasnya.
6. **Zero-Config Onboarding.** Produktivitas <5 menit.
7. **Automate Everything.** Manual = error-prone.
8. **Test Everything.** Termasuk deployment.
9. **Document Decisions.** ADR untuk arsitektur.
10. **Specialization with Common Foundation.** Tim punya track, tapi fondasi sama.
11. **Idempotent Operations.** Aman dijalankan berkali-kali.
12. **Observability.** Metric, log, trace untuk semua.
13. **Continuous Improvement.** Retro, feedback, iterasi.
14. **Community.** Kontribusi upstream = reputasi + belajar.
15. **Sustainability.** Sistem harus bertahan 5+ tahun.

**Pertanyaan reflektif untuk diri sendiri:**
- Bisakah saya merancang arsitektur shell untuk 1000 developer?
- Apakah saya tahu perbedaan SOC 2 dan ISO 27001?
- Bisakah saya menulis Ansible playbook untuk deploy ke 100 host?
- Apakah saya pernah berkontribusi ke open source?
- Bisakah saya menulis plugin Zsh dari nol?
- Apakah saya tahu bagaimana memilih specialization untuk tim?
- Bisakah saya melakukan audit compliance?
- Apakah saya bisa mengelola sistem yang sudah berjalan setahun?

Jika jawabannya "belum", **ulangi modul ini** — ini adalah level Expert, standarnya tinggi.

### Checklist Verifikasi

Sebelum melanjutkan ke **Modul 7.7 (Capstone)**, pastikan Anda dapat:

- [ ] Merancang arsitektur shell enterprise dengan layer
- [ ] Menulis Ansible playbook untuk deployment
- [ ] Menggunakan Ansible role dan inventory
- [ ] Mengimplementasikan idempotent deployment
- [ ] Membangun rollback strategy
- [ ] Mengumpulkan compliance evidence otomatis
- [ ] Memetakan requirement SOC 2 / ISO 27001
- [ ] Menulis script compliance report
- [ ] Melakukan kontribusi ke open source
- [ ] Membuat patch dengan format yang benar
- [ ] Berkomunikasi di mailing list
- [ ] Membangun plugin Zsh open source
- [ ] Mendokumentasikan plugin dengan baik
- [ ] Menulis test untuk plugin
- [ ] Mendeploy plugin ke distribution channel
- [ ] Membangun specialization track untuk tim
- [ ] Menulis learning materials
- [ ] Membuat capstone project per track

---

## ✅ MODUL 7.6 SELESAI

**Ringkasan yang telah Anda kuasai:**
- Arsitektur shell enterprise dengan 3 layer
- Ansible untuk deployment 120+ mesin
- Compliance report otomatis untuk SOC 2 / ISO 27001
- Audit trail dan evidence collection
- Kontribusi ke Zsh upstream (patch, mailing list)
- Plugin Zsh open source (standard, test, publish)
- Specialization tracks (DevOps, Data, Tooling)
- Capstone projects per track

**Yang akan datang di Modul 7.7:**
Anda akan menyelesaikan **Capstone Project** — proyek akhir yang menggabungkan **SEMUA** yang telah Anda pelajari dari Fase 1 hingga Fase 7. Ini bukan proyek baru, tetapi **sintesis** dari semua yang telah Anda bangun: `nt` CLI tool, dotfiles, monitoring, deployment, dan kontribusi. Anda akan mempresentasikan portfolio lengkap dan menerima evaluasi komprehensif.

---

# MODUL 7.7: CAPSTONE — PORTFOLIO & PRESENTASI

> **Mewakili:** Sintesis dari SEMUA fase (Fase 1–7) — Fondasi, Scripting, Konfigurasi, Performa, Testing, Enterprise, Spesialisasi
> **Level:** Expert | **Durasi:** 20–25 jam | **Tipe:** Proyek Akhir & Assessment

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Skenario Proyek** — Konteks dan peran Anda
2. **Deskripsi Konkret & Peran dalam Kurikulum**
3. **Konsep Kunci & Filosofi Mendalam** — Mental model "portfolio as proof"
4. **Sintaks Dasar / Contoh Implementasi Inti** — Toolkit synthesis
5. **Terminologi Esensial & Penjelasan Detil**
6. **Pertanyaan & Jawaban** — 8 tantangan capstone
7. **Rekomendasi Visualisasi**
8. **Hubungan dengan Modul Lain**
9. **Sumber Referensi Lengkap**
10. **Tips dan Praktik Terbaik**
11. **Potensi Kesalahan Umum & Solusi**
12. **Refleksi Mental Programming & Verifikasi**

---

## 1. Skenario Proyek

**Hari ini adalah hari terakhir Anda di Nusantara Tech.** Bukan karena Anda keluar, tetapi karena Anda dipromosikan menjadi **VP of Engineering** — dan Anda perlu menyerahkan **tanggung jawab teknis** kepada penerus Anda. CTO memanggil Anda:

> *"Selamat atas promosinya! Sebelum Anda pindah ke peran baru, saya ingin Anda melakukan dua hal:*
>
> **Pertama:** Buat **handover document** yang komprehensif. Penerus Anda harus bisa memahami seluruh arsitektur shell enterprise yang telah Anda bangun selama 18 bulan terakhir, tanpa harus bertanya ke Anda setiap saat.
>
> **Kedua:** Buat **portfolio presentation** untuk **board of directors**. Mereka ingin tahu apa yang telah dicapai tim engineering dalam hal produktivitas developer. Anda perlu:
> - Menjelaskan **business impact** dari investasi shell tooling
> - Menunjukkan **metrics** sebelum dan sesudah
> - Menjelaskan **risk mitigation** (security, compliance)
> - Menyiapkan **roadmap** 12 bulan ke depan
> - Mempresentasikan **kontribusi open source** sebagai brand building
>
> *Deadline: 2 minggu. Output: Dokumen handover + Slide deck + Demo. CTO akan review sebelum presentasi ke board."*

**Yang harus Anda siapkan:**

| Deliverable | Audience | Format |
|---|---|---|
| **Handover Document** | Penerus (technical) | Markdown + diagrams |
| **Portfolio Presentation** | Board (non-technical) | Slides + demo |
| **Metrics Dashboard** | CTO + board | Visual + numbers |
| **Roadmap Document** | CTO + team | Quarterly plan |
| **Open Source Report** | Community | Blog post + stats |
| **Personal Reflection** | Diri sendiri | Journal |

Anda memiliki:
- 2 minggu
- Semua data dan sistem yang telah dibangun
- Akses ke semua dokumentasi
- Support dari tim

**Tantangan:** Sintesis lengkap dari 18 bulan kerja menjadi **artifact yang bisa dihandover** dan **story yang bisa dijual**.

---

## 2. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **puncak dari seluruh perjalanan Anda**. Ia bukan tentang mempelajari hal baru, tetapi tentang **mengintegrasikan** semua yang telah dipelajari menjadi **satu portfolio yang koheren**.

Di dunia kerja, **portfolio adalah bukti**. Sertifikat bisa dipalsukan, CV bisa dibesar-besarkan, tetapi portfolio:
- **Konkret** — bisa dilihat, disentuh, dijalankan
- **Verifiable** — ada Git history, ada deployment, ada user
- **Narrative** — menceritakan perjalanan Anda
- **Impactful** — menunjukkan dampak nyata

**Portfolio yang baik menjawab tiga pertanyaan:**

1. **Apa yang Anda bangun?** — Teknis, konkret
2. **Mengapa itu penting?** — Business impact, value
3. **Bagaimana Anda melakukannya?** — Proses, keputusan, trade-off

## 3. Konsep Kunci & Filosofi Mendalam

**Mental model: "Portfolio as Time Capsule".**

Bayangkan Anda menulis surat untuk diri sendiri 5 tahun dari sekarang. Apa yang ingin Anda ingat?
- **Keputusan** — mengapa Anda memilih solusi tertentu?
- **Trade-off** — apa yang Anda korbankan dan mengapa?
- **Pelajaran** — apa yang Anda pelajari dari kegagalan?
- **Dampak** — apa yang berubah karena kerja Anda?

Portfolio adalah **time capsule** yang menangkap semua ini.

**Filosofi "Show, Don't Tell":**

Jangan hanya bilang "saya ahli Zsh". Tunjukkan:
- **Kode** — repository dengan kualitas production
- **Metrics** — startup time turun dari 800ms ke 95ms
- **Impact** — onboarding developer dari 3 hari ke 5 menit
- **Adoption** — 120 developer menggunakan tool Anda
- **Sustainability** — sistem berjalan 18 bulan tanpa downtime

**Filosofi "Business Language for Technical Work":**

Engineer sering gagal berkomunikasi dengan business karena mereka bicara **fitur**, bukan **value**. Portfolio yang efektif bicara dalam bahasa bisnis:

| Teknis | Bisnis |
|---|---|
| "Saya membangun CLI tool" | "Menghemat 10 jam/developer/minggu" |
| "Saya optimasi startup time" | "Meningkatkan produktivitas 15%" |
| "Saya implementasi security policy" | "Menghindari risiko breach $2M" |
| "Saya kontribusi ke Zsh" | "Building brand di komunitas" |

**Filosofi "Documentation as Legacy":**

Dokumen handover bukan hanya untuk penerus — ia adalah **legacy** Anda. Ketika Anda pergi, dokumentasi Anda tetap hidup. Ia harus:
- **Self-contained** — tidak butuh Anda untuk menjelaskan
- **Actionable** — penerus bisa langsung bertindak
- **Living** — bisa di-update seiring waktu
- **Honest** — termasuk apa yang belum selesai

**Filosofi "Metrics Tell Stories":**

Angka tidak berbohong, tapi juga tidak bercerita. Anda perlu **konteks**:
- **Before/After** — apa yang berubah?
- **Trend** — apakah membaik atau memburuk?
- **Baseline** — dari mana Anda mulai?
- **Target** — ke mana Anda menuju?

## 4. Sintaks Dasar / Contoh Implementasi Inti

```zsh
# ═══════════════════════════════════════════════════════════
# TOOLKIT MODUL 7.7 — Portfolio & Handover
# ═══════════════════════════════════════════════════════════

# ─── PORTFOLIO DOCUMENTATION ───
# Struktur
mkdir -p handover/{architecture,metrics,roadmap,lessons}
mkdir -p portfolio/{slides,demo,assets}

# ─── METRICS COLLECTION ───
# Startup time
hyperfine --warmup 3 --runs 20 'zsh -i -c exit' --export-json startup.json

# Plugin count
grep -vE '^\s*#|^\s*$' ~/.config/zsh/.zsh_plugins.txt | wc -l

# Adoption
git log --since="1 year ago" --pretty=format:"%an" | sort -u | wc -l

# Contribution stats
git log --author="$(git config user.name)" --oneline | wc -l
git shortlog -sn --author="$(git config user.name)"

# ─── HANDOVER DOCUMENT ───
# Generate TOC
find handover -name "*.md" | sort | sed 's/^/- [ ] /'

# Verify links
for f in handover/**/*.md; do
    grep -oE '\[.*\]\(.*\)' "$f" | while read link; do
        url=$(echo "$link" | sed 's/.*(\(.*\))/\1/')
        [[ "$url" == http* ]] && curl -sfI "$url" > /dev/null || echo "Broken: $url in $f"
    done
done

# ─── PRESENTATION ───
# Convert Markdown to slides (reveal.js, marp)
marp handover/presentation.md --output portfolio/slides.pdf

# Or with pandoc
pandoc handover/presentation.md -t revealjs -s -o portfolio/slides.html

# ─── DEMO SCRIPT ───
# Record terminal session
asciinema rec demo.cast
# Play back
asciinema play demo.cast

# Convert to GIF
agg demo.cast demo.gif
```

## 5. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh dalam Proyek |
|---|---|---|
| **Handover** | Proses transfer tanggung jawab | Dokumen + knowledge transfer |
| **Portfolio** | Kumpulan karya yang menunjukkan skill | Repo + metrics + presentation |
| **Metrics** | Angka yang mengukur dampak | Startup time, adoption |
| **Baseline** | Titik awal untuk perbandingan | "Sebelum optimasi: 800ms" |
| **Before/After** | Perbandingan kondisi | "Turun dari 800ms ke 95ms" |
| **ROI** | Return on Investment | "Menghemat $500K/tahun" |
| **Adoption** | Tingkat penggunaan | "120/120 developer" |
| **Sustainability** | Kemampuan sistem bertahan | "18 bulan tanpa downtime" |
| **Legacy** | Warisan yang ditinggalkan | Dokumentasi, kode |
| **Knowledge transfer** | Proses berbagi pengetahuan | Pair programming, docs |
| **Runbook** | Panduan operasional | Incident response |
| **ADR** | Architecture Decision Record | Keputusan teknis |
| **Post-mortem** | Analisis setelah insiden | Pelajaran dari kegagalan |
| **Retrospective** | Refleksi berkala | Sprint review |
| **RACI** | Responsible, Accountable, Consulted, Informed | Matrix keputusan |

---

## 6. PERTANYAAN & JAWABAN

### Pertanyaan 1: Handover Document — Struktur & Konten

**Tantangan:** Buat dokumen handover untuk penerus Anda. Dokumen harus: (a) self-contained, (b) actionable, (c) honest tentang apa yang belum selesai. Struktur harus memudahkan penerus untuk memahami seluruh sistem dalam <1 hari.

**Jawaban:**

**Struktur Handover Document:**

```
handover/
├── README.md                       # Overview + quick start
├── 01-architecture.md              # Sistem dan komponen
├── 02-deployment.md                # Cara deploy
├── 03-monitoring.md                # Cara monitor
├── 04-security.md                  # Kebijakan dan compliance
├── 05-troubleshooting.md           # Playbook untuk masalah umum
├── 06-runbook.md                   # Prosedur operasional
├── 07-metrics.md                   # Data dan analisis
├── 08-roadmap.md                   # Rencana 12 bulan
├── 09-lessons-learned.md           # Apa yang berhasil dan tidak
├── 10-contacts.md                  # Siapa yang bisa dihubungi
├── adr/                            # Architecture Decision Records
│   ├── 001-modular-config.md
│   ├── 002-ansible-deployment.md
│   ├── 003-secret-management.md
│   ├── 004-plugin-manager-choice.md
│   └── 005-monitoring-strategy.md
├── diagrams/                       # Diagram
│   ├── architecture.excalidraw
│   ├── data-flow.excalidraw
│   └── security-layers.excalidraw
└── appendix/                       # Lampiran
    ├── glossary.md                 # Terminologi
    ├── references.md               # Sumber referensi
    └── changelog.md                # Riwayat perubahan
```

**`handover/README.md`:**

```markdown
# Handover — Nusantara Tech Shell Infrastructure

**Author:** [Your Name]
**Date:** 2026-10-12
**Version:** 1.0

## Untuk Penerus

Selamat datang! Dokumen ini adalah **peta lengkap** dari infrastruktur shell yang telah saya bangun selama 18 bulan. Tujuan saya: Anda bisa memahami, mengoperasikan, dan mengembangkan sistem ini **dalam 1 hari kerja**.

## Quick Start (30 menit)

Jika Anda hanya punya 30 menit, baca ini:
1. **[01-architecture.md](01-architecture.md)** — 10 menit: apa yang kita bangun
2. **[02-deployment.md](02-deployment.md)** — 10 menit: bagaimana deploy
3. **[05-troubleshooting.md](05-troubleshooting.md)** — 10 menit: jika ada masalah

## Deep Dive (1 hari)

Untuk pemahaman lengkap, baca berurutan:
- **Pagi (3 jam):** 01, 02, 03, 04
- **Siang (3 jam):** 05, 06, 07
- **Sore (2 jam):** 08, 09, 10, adr/

## Top 3 Priorities

Jika Anda hanya punya waktu untuk 3 hal:

1. **Pahami deployment** (02) — jika ada masalah, Anda perlu bisa deploy ulang
2. **Pahami security** (04) — compliance adalah prioritas #1
3. **Pahami metrics** (07) — untuk melanjutkan improvement

## My Contact

Saya tidak menghilang. Untuk pertanyaan kritis:
- **Email:** [your.email@nusantara.tech]
- **Slack:** @[username]
- **Response time:** <24 jam (kecuali weekend)

Untuk pertanyaan non-kritis, silakan buka issue di:
- Repository: `git.nusantara.tech/infra/shell-dotfiles`
- Labels: `question`, `documentation`

## Apa yang Belum Selesai

Honest assessment — apa yang perlu dilanjutkan:
- **ShellCheck di CI** — saat ini manual, perlu otomatis
- **Multi-region deployment** — masih single-region
- **Backup testing** — perlu regular restore test
- **Team self-service** — beberapa task masih manual

Lihat [09-lessons-learned.md](09-lessons-learned.md) untuk detail.

## Konvensi Dokumen

- ✅ **Done** — selesai dan stabil
- 🚧 **In Progress** — sedang dikerjakan
- 📋 **Planned** — direncanakan
- ❌ **Not Started** — belum dimulai
- ⚠️ **Warning** — perlu perhatian

## Feedback

Jika Anda menemukan kesalahan atau kekurangan di dokumen ini:
1. Buat issue di repository
2. Atau langsung edit dan PR
3. Atau email saya

Feedback Anda membantu dokumen ini menjadi lebih baik untuk penerus berikutnya.

---

*Last updated: 2026-10-12*
```

**`handover/01-architecture.md`:**

```markdown
# Architecture — Shell Infrastructure

## Overview

Infrastruktur shell Nusantara Tech terdiri dari **3 layer** yang di-deploy ke **120 mesin** (100 developer laptop, 15 CI runner, 5 server).

```
┌──────────────────────────────────────────────────────────┐
│                  LAYER 3: PERSONAL                        │
│  Per developer, tidak di-manage sentral                   │
│  ~/.config/zsh/local.zsh                                  │
└──────────────────────────────────────────────────────────┘
                          ▲
┌──────────────────────────────────────────────────────────┐
│                  LAYER 2: TEAM                            │
│  Per tim (devops, data, tooling, backend, frontend)       │
│  ~/.config/zsh/teams/<team>/                              │
└──────────────────────────────────────────────────────────┘
                          ▲
┌──────────────────────────────────────────────────────────┐
│                  LAYER 1: FOUNDATION                      │
│  System-wide, read-only                                   │
│  /etc/zsh/                                                │
└──────────────────────────────────────────────────────────┘
```

## Komponen Utama

### 1. Foundation Layer (Layer 1)

**Tujuan:** Kebijakan keamanan dan config dasar.

**Lokasi:** `/etc/zsh/`

**Files:**
- `/etc/zsh/zshenv` — environment minimal (semua shell)
- `/etc/zsh/zprofile` — login shell environment
- `/etc/zsh/zshrc` — interactive shell base
- `/etc/zsh/conf.d/` — modular config
  - `00-base.zsh` — PATH, locale, editor
  - `10-security.zsh` — history policy, timeout, aliases aman
  - `20-tools.zsh` — tools sistem
  - `30-completion.zsh` — completion system
- `/usr/local/share/zsh/site-functions/` — completion functions

**Managed by:** Ansible role `zsh-foundation`

**Who can change:** IT team only (via Git PR)

### 2. Team Layer (Layer 2)

**Tujuan:** Tools dan config spesifik per tim.

**Lokasi:** `~/.config/zsh/teams/<team>/conf.d/`

**Teams:**
- **devops** — k8s, aws, terraform, docker helpers
- **data** — python, jupyter, data tools
- **tooling** — fzf, ripgrep, fd, modern CLI
- **backend** — go, java, database helpers
- **frontend** — node, npm, yarn helpers

**Managed by:** Ansible role `zsh-team` + team lead

**Who can change:** Team lead + 1 approval

### 3. Personal Layer (Layer 3)

**Tujuan:** Preferensi pribadi developer.

**Lokasi:** `~/.config/zsh/local.zsh`

**Content:** alias pribadi, prompt, editor, tools pribadi

**Managed by:** Developer sendiri

**Who can change:** Developer

## CLI Tool: `nt`

**Purpose:** Nusantara Toolkit — CLI untuk operasi DevOps.

**Location:** `/usr/local/bin/nt`

**Subcommands:**
- `nt status` — cek status service
- `nt deploy <env> <svc>` — deploy service
- `nt db <action>` — database operations
- `nt k8s <action>` — kubernetes operations
- `nt secrets <action>` — secrets management
- `nt report <period>` — generate report
- `nt debug <service>` — debug interaktif

**Repository:** `git.nusantara.tech/tools/nt`

**Documentation:** `https://docs.nusantara.tech/nt`

## Deployment

**Tool:** Ansible

**Inventory:** `ansible/inventory/production.ini` (120 hosts)

**Playbook:** `ansible/playbooks/deploy-all.yml`

**Frequency:**
- **Weekly** — automated via CI (Sunday 2 AM)
- **On-demand** — for critical updates

**Duration:** ~30 minutes for all 120 hosts (parallel)

See [02-deployment.md](02-deployment.md) for details.

## Monitoring

**Metrics collected:**
- Startup time (setiap shell startup)
- Plugin count
- Config count
- History size
- Anomalies (startup >500ms)

**Frequency:** Daily via cron (9 AM)

**Storage:** JSONL di `/var/log/zsh-metrics/metrics.jsonl`

**Report:** Weekly via `nt report weekly`

See [03-monitoring.md](03-monitoring.md) for details.

## Security

**Policies:**
- History di `/var/log/zsh_history/` (centralized, audit-ready)
- Timeout idle 1 jam
- Aliases aman (rm -I, chmod --preserve-root)
- Secret management via 1Password CLI
- No secrets in config

**Compliance:**
- SOC 2 — pass (verified October 2026)
- ISO 27001 — in progress (expected Q1 2027)

See [04-security.md](04-security.md) for details.

## Key Decisions

- **ADR-001:** Modular config dengan `conf.d/`
- **ADR-002:** Ansible untuk deployment
- **ADR-003:** 1Password untuk secrets
- **ADR-004:** Antidote untuk plugin manager
- **ADR-005:** JSONL untuk metrics

See `adr/` folder for details.

## Repository Structure

```
nusantara-dotfiles/
├── ansible/          # Deployment
├── foundation/       # Layer 1 files
├── teams/            # Layer 2 files
├── tests/            # Test suite
├── docs/             # Documentation
├── scripts/          # Utility scripts
└── install.sh        # Quick install
```

## Contacts

| Role | Name | Contact |
|---|---|---|
| **IT Lead** | [Name] | [email] |
| **DevOps Lead** | [Name] | [email] |
| **Security** | [Name] | [email] |
| **Previous Author** | [Your Name] | [your email] |

---

*Last updated: 2026-10-12*
```

**`handover/09-lessons-learned.md`:**

```markdown
# Lessons Learned — 18 Bulan Shell Infrastructure

## Apa yang Berhasil

### 1. Modular Config dengan conf.d/

**Keputusan:** Split config menjadi file kecil di `conf.d/` dengan prefix numerik.

**Hasil:**
- ✅ Mudah di-maintain (satu file satu tanggung jawab)
- ✅ Tim bisa kontribusi tanpa konflik
- ✅ Rollback granular (disable satu file)
- ✅ Onboarding cepat (developer tahu di mana cari)

**Pelajaran:** **Convention over configuration** bekerja sangat baik untuk tim besar.

### 2. Ansible untuk Deployment

**Keputusan:** Gunakan Ansible daripada shell script manual.

**Hasil:**
- ✅ Idempotent — aman dijalankan berkali-kali
- ✅ Parallel — 120 host dalam 30 menit
- ✅ Audit trail — setiap deployment tercatat
- ✅ Rollback terstruktur

**Pelajaran:** Investasi awal (belajar Ansible) terbayar berkali-kali dalam 18 bulan.

### 3. Secret Management dengan 1Password

**Keputusan:** Wajibkan secret management, larang secrets di config.

**Hasil:**
- ✅ Zero secrets di config (verified via automated scan)
- ✅ Rotasi mudah (ubah di 1Password, semua mesin update)
- ✅ Audit trail (siapa akses kapan)
- ✅ SOC 2 pass

**Pelajaran:** **Security bukan optional** — ini adalah fondasi.

### 4. Antidote sebagai Plugin Manager

**Keputusan:** Standarisasi ke Antidote (dari 4 plugin manager berbeda).

**Hasil:**
- ✅ Startup time turun dari ~300ms ke ~95ms
- ✅ Konsisten di semua developer
- ✅ Debugging mudah (satu tool)
- ✅ Konfigurasi simple (`.zsh_plugins.txt`)

**Pelajaran:** **Standardisasi > fleksibilitas** untuk enterprise.

### 5. Monitoring Berkelanjutan

**Keputusan:** Kumpulkan metrics harian, bukan audit sekali.

**Hasil:**
- ✅ Deteksi anomali lebih awal
- ✅ Data-driven decisions
- ✅ Trend analysis (membaik/memburuk)
- ✅ Evidence untuk compliance

**Pelajaran:** **Measure, don't guess** — ini adalah prinsip fundamental.

## Apa yang Tidak Berhasil

### 1. Big Bang Migration ke Antidote (Bulan 3)

**Apa yang terjadi:** Kami migrasi 30 developer sekaligus dalam 1 weekend.

**Masalah:**
- ❌ 5 developer mengalami masalah (plugin tidak kompatibel)
- ❌ Support request membludak Senin pagi
- ❌ 2 hari produktivitas hilang

**Pelajaran:** **Gradual rollout** — 5 → 15 → 30. **Never big bang.**

**Apa yang seharusnya:** Migrasi 5 developer (early adopters) minggu 1, 15 developer minggu 2, sisanya minggu 3.

### 2. Lazy Loading untuk `git` (Bulan 5)

**Apa yang terjadi:** Kami lazy-load `git` untuk mempercepat startup.

**Masalah:**
- ❌ Developer yang sering pakai `git` mengalami delay
- ❌ Delay lebih terasa dari startup time yang dihemat
- ❌ Net negative untuk workflow

**Pelajaran:** **Lazy loading bukan untuk semua tools.** Hanya untuk tools yang **jarang** digunakan (nvm, pyenv, conda).

**Apa yang seharusnya:** Lazy load hanya tools berat yang jarang (nvm, pyenv), bukan tools sehari-hari (git, kubectl).

### 3. Custom Prompt (Bulan 7)

**Apa yang terjadi:** Kami buat prompt custom dari nol (bukan pakai Powerlevel10k).

**Masalah:**
- ❌ Butuh waktu 3 minggu untuk polish
- ❌ Bug yang tidak terduga (escaping, terminal compatibility)
- ❌ Developer complain: "kok lambat?"
- ❌ Akhirnya migrasi ke Powerlevel10k

**Pelajaran:** **Jangan reinvent the wheel.** Gunakan tools yang sudah mature untuk hal non-core.

**Apa yang seharusnya:** Mulai dengan Powerlevel10k (mature), baru customize jika perlu.

### 4. Over-Engineering Metrics (Bulan 9)

**Apa yang terjadi:** Kami bangun sistem metrics dengan banyak dimensi (per user, per team, per OS, per plugin).

**Masalah:**
- ❌ Privacy concerns (data terlalu detail)
- ❌ Storage membengkak (10GB per bulan)
- ❌ Data tidak actionable (over-analyzed)
- ❌ Akhirnya disederhanakan

**Pelajaran:** **Start simple.** Tambahkan complexity hanya jika diperlukan.

**Apa yang seharusnya:** Mulai dengan 5 metrics (startup, plugin, config, history, anomaly), baru tambah jika perlu.

## Apa yang Belum Selesai

### 1. ShellCheck di CI

**Status:** 🚧 In Progress

**Current:** ShellCheck dijalankan manual oleh reviewer.

**Target:** Automated di CI — fail on warning.

**Blockers:** Butuh setup GitHub Actions untuk repo internal.

**Effort:** ~2 hari

### 2. Multi-Region Deployment

**Status:** 📋 Planned

**Current:** Single region (Jakarta).

**Target:** Multi-region (Jakarta, Singapore) untuk DR.

**Blockers:** Budget approval, network setup.

**Effort:** ~2 minggu

### 3. Backup Testing

**Status:** ❌ Not Started

**Current:** Backup ada, tapi belum pernah di-test restore.

**Target:** Monthly restore test, automated.

**Blockers:** Butuh staging environment.

**Effort:** ~1 minggu

### 4. Team Self-Service

**Status:** 🚧 In Progress

**Current:** Beberapa task (tambah tools, update config) butuh IT intervention.

**Target:** Team lead bisa self-service.

**Blockers:** Butuh RBAC system.

**Effort:** ~3 minggu

## Personal Reflections

### What I Learned

1. **Technical excellence ≠ business impact.** Yang penting bukan teknologi keren, tapi dampak bisnis.
2. **Communication is 50% of the job.** Engineer yang bisa menjelaskan ke non-technical = 2x value.
3. **Security is not a feature.** Ini adalah fondasi. Tidak bisa di-retrofit.
4. **Documentation is an investment.** 1 jam dokumentasi = 10 jam saved di masa depan.
5. **Measure twice, cut once.** Data sebelum keputusan.
6. **Gradual rollout saves sanity.** Big bang = pain.
7. **Simple > clever.** Kode yang simple lebih baik dari kode yang clever.
8. **Community matters.** Kontribusi open source = brand building.
9. **Burnout is real.** Sustainable pace > sprint akhir.
10. **People > process > tools.** Yang paling penting adalah orang.

### What I Would Do Differently

1. **Start with security from day 1.** Kami retrofit security di bulan 6 — seharusnya dari awal.
2. **Invest in documentation earlier.** Kami mulai serious di bulan 9 — seharusnya dari bulan 1.
3. **Say no to scope creep.** Beberapa fitur yang tidak dipakai menghabiskan waktu.
4. **Automate earlier.** Manual task = technical debt.
5. **Communicate more with non-technical.** Saya fokus teknis terlalu lama.

### What I'm Proud Of

1. **Zero security incidents** in 18 months.
2. **120 developers** using the system daily.
3. **Startup time 8x faster** (800ms → 95ms).
4. **SOC 2 pass** with zero findings.
5. **5 open source contributions** to Zsh ecosystem.
6. **Onboarding in 5 minutes** (from 3 days).
7. **Documentation** that outlives me.

### Advice for Successor

1. **Talk to developers.** Metrics tidak menangkap semua. Ngobrol dengan user.
2. **Embrace failure.** Post-mortem tanpa blame.
3. **Invest in yourself.** Konferensi, buku, kursus.
4. **Find a mentor.** Untuk topik yang tidak Anda kuasai.
5. **Celebrate wins.** 18 bulan adalah marathon, bukan sprint.

---

*Last updated: 2026-10-12*
```

**Penjelasan Mental — Handover as Legacy:**

Handover document adalah **legacy** Anda. Prinsip-prinsip:

1. **Self-contained** — penerus tidak perlu bertanya
2. **Actionable** — bisa langsung diikuti
3. **Honest** — termasuk kekurangan
4. **Living** — bisa di-update
5. **Complete** — tidak ada "hidden knowledge"

**Tiga Audiens:**

| Audiens | Fokus | Detail |
|---|---|---|
| **Quick reader** (30 min) | Overview | README, top 3 priorities |
| **Serious reader** (1 day) | Understanding | All docs berurutan |
| **Reference user** (as needed) | Specific answer | Troubleshooting, runbook |

**Mengapa "Honest Assessment" Penting:**

Penerus perlu tahu:
- Apa yang **sudah selesai** — jangan over-engineer
- Apa yang **sedang dikerjakan** — jangan duplikasi
- Apa yang **belum dimulai** — opportunity
- Apa yang **tidak berhasil** — jangan ulangi

**Mengapa "Lessons Learned" Paling Berharga:**

Dokumen teknis bisa dibuat siapa saja. **Lessons learned** adalah unique — hanya bisa dibuat oleh orang yang mengalami. Ini adalah **wisdom** yang tidak bisa di-copy.

---

### Pertanyaan 2: Metrics & Business Impact

**Tantangan:** Board of directors ingin tahu **business impact** dari investasi shell tooling. Anda perlu: (a) kumpulkan metrics sebelum/sesudah, (b) konversi ke business language, (c) hitung ROI.

**Jawaban:**

**`handover/07-metrics.md`:**

```markdown
# Metrics — Shell Infrastructure Impact

## Executive Summary

| Metric | Before (Feb 2025) | After (Oct 2026) | Change |
|---|---|---|---|
| **Startup time** | 800ms | 95ms | **-88%** |
| **Onboarding time** | 3 hari | 5 menit | **-99.7%** |
| **Developer count** | 30 | 120 | +300% |
| **Security incidents** | 2/tahun | 0 | **-100%** |
| **Compliance** | Not ready | SOC 2 ✅ | — |
| **CLI tool usage** | 0 | 85% daily | — |

## 1. Performance

### Startup Time

**Baseline (Feb 2025):** 800ms rata-rata
- Oh My Zsh dengan 50 plugins
- No caching
- Eager loading semua tools

**Current (Oct 2026):** 95ms rata-rata
- Antidote dengan 12 plugins
- Completion cache
- Lazy loading untuk tools berat

**Business Impact:**
- Developer buka terminal ~50x/hari
- Waktu hemat: 50 × 705ms = 35 detik/hari/developer
- Total: 120 developer × 35 detik × 250 hari = **292 jam/tahun**
- Nilai (jam × Rp 300K): **Rp 87.6 juta/tahun**

### Monitoring Data

```
Monthly Average Startup Time (ms)
─────────────────────────────────
Feb 2025 ████████████████████████ 800
Jun 2025 ██████████████           450
Oct 2025 ██████                   200
Feb 2026 ████                     130
Jun 2026 ███                      110
Oct 2026 ███                      95
```

## 2. Onboarding

### Before vs After

| Step | Before | After |
|---|---|---|
| Clone repo | 5 min | 1 min |
| Install tools | 2 jam | 1 min |
| Setup config | 4 jam | 1 min |
| Setup secrets | 1 hari | 1 min |
| Verify | 30 min | 2 min |
| **Total** | **~3 hari** | **~5 menit** |

**Business Impact:**
- 40 new hires/tahun
- Waktu hemat: 3 hari × 8 jam = 24 jam → 5 menit
- **Per hire: 23.9 jam hemat**
- **Per tahun: 40 × 23.9 = 956 jam**
- Nilai: **Rp 287 juta/tahun**

## 3. Security

### Incidents

| Year | Incidents | Severity |
|---|---|---|
| 2024 | 2 | Medium (secrets exposed) |
| 2025 | 1 | Low (bad permission) |
| 2026 | **0** | — |

**Business Impact:**
- Cost of incident: ~$100K (investigation, remediation, notification)
- Avoided: 3 × $100K = **$300K** over 18 months

### Compliance

**SOC 2:** Passed October 2026, zero findings.
**ISO 27001:** In progress, expected Q1 2027.

**Business Impact:**
- Enterprise deals require SOC 2
- Enables $2M+ enterprise contracts
- Avoided audit failure: **potentially $5M+ in lost deals**

## 4. Productivity

### CLI Tool Adoption

| Metric | Value |
|---|---|
| Daily active users | 102/120 (85%) |
| Weekly command executions | ~50,000 |
| Average time saved per command | 30-60 seconds |
| Total time saved | ~500-800 hours/month |

**Business Impact:**
- Total: ~600 jam/bulan = 7,200 jam/tahun
- Nilai: **Rp 2.16 miliar/tahun**

### Developer Satisfaction

Survey results (N=95):

| Question | Before | After |
|---|---|---|
| "Saya puas dengan shell setup" | 40% | 92% |
| "Setup cepat dan mudah" | 25% | 88% |
| "Saya merasa produktif" | 55% | 85% |
| "Keamanan memadai" | 30% | 95% |

**Business Impact:**
- Developer satisfaction tinggi → retention tinggi
- Cost of turnover: ~Rp 200M per developer
- If reduce turnover by 10%: 12 developers × Rp 200M = **Rp 2.4 miliar/tahun**

## 5. Open Source Contributions

### Statistics

| Metric | Value |
|---|---|
| Patches submitted | 12 |
| Patches merged | 8 |
| Plugins created | 2 |
| Stars on plugins | 450+ |
| Blog posts | 5 |
| Conference talks | 2 |

**Business Impact:**
- **Brand building** — Nusantara Tech dikenal di komunitas
- **Recruiting** — developer ingin kerja di tempat yang contribute
- **Retention** — developer bangga bekerja di sini
- **Estimated value:** $50K-100K in PR + recruiting

## 6. Total ROI

### Investment

| Item | Cost |
|---|---|
| Engineering time (18 bulan) | Rp 1.2 miliar |
| Tools (1Password, Ansible Tower) | Rp 200 juta |
| Training | Rp 100 juta |
| **Total** | **Rp 1.5 miliar** |

### Return

| Category | Annual Value |
|---|---|
| Performance (startup) | Rp 87 juta |
| Onboarding | Rp 287 juta |
| Security (avoided incidents) | Rp 450 juta |
| Compliance (enabled deals) | Rp 3 miliar |
| Productivity (CLI tool) | Rp 2.16 miliar |
| Retention (satisfaction) | Rp 2.4 miliar |
| Open source (brand) | Rp 750 juta |
| **Total Annual** | **Rp 9.13 miliar** |

### ROI Calculation

```
ROI = (Return - Investment) / Investment × 100%
    = (9.13M - 1.5M) / 1.5M × 100%
    = 508%
```

**Payback period:** ~2 bulan.

## 7. Dashboard

Metrics dashboard live: `https://metrics.nusantara.tech/shell`

**Views:**
- **Executive** — high-level metrics
- **Team** — per-team breakdown
- **Individual** — developer self-check
- **Compliance** — audit evidence

**Refresh:** Daily at 9 AM.

## 8. Caveats

Honest assessment of metrics:

- **Baseline mungkin tidak akurat.** Startup 800ms diukur dari 5 developer, mungkin tidak representatif.
- **Business impact adalah estimasi.** Nilai jam × rate adalah estimasi, bukan actual.
- **Correlation vs causation.** Beberapa improvement mungkin dari faktor lain (hardware, OS upgrade).
- **Survey sample.** 95 dari 120 = 79% response rate, mungkin ada bias.
- **Cost of turnover.** Angka Rp 200M adalah industry average, mungkin berbeda di Nusantara.

**Rekomendasi:** Track metrics berkelanjutan, update quarterly.

---

*Last updated: 2026-10-12*
```

**`handover/diagrams/roi-breakdown.excalidraw` — visual:**

```
┌─────────────────────────────────────────────────────────────┐
│                ROI BREAKDOWN — SHELL INFRASTRUCTURE          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INVESTMENT (Rp 1.5M)                                       │
│  ████████████                                               │
│                                                             │
│  RETURN (Rp 9.13M/tahun)                                    │
│  ████████████████████████████████████████████████████████  │
│                                                             │
│  ROI = 508%                                                 │
│  Payback = 2 bulan                                          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Category          │ Annual    │ % of Total          │   │
│  ├───────────────────┼───────────┼─────────────────────┤   │
│  │ Compliance        │ Rp 3.0M   │ 33%                 │   │
│  │ Retention         │ Rp 2.4M   │ 26%                 │   │
│  │ Productivity      │ Rp 2.16M  │ 24%                 │   │
│  │ Open Source       │ Rp 0.75M  │ 8%                  │   │
│  │ Security          │ Rp 0.45M  │ 5%                  │   │
│  │ Onboarding        │ Rp 0.29M  │ 3%                  │   │
│  │ Performance       │ Rp 0.09M  │ 1%                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Penjelasan Mental — Metrics yang Menjual:**

**Tiga Tingkat Metrics:**

1. **Technical** — startup time, plugin count (untuk engineer)
2. **Productivity** — time saved, adoption (untuk manager)
3. **Business** — ROI, compliance, retention (untuk board)

**Konversi Technical → Business:**

```zsh
# Technical
startup_time_saved = 705ms

# Productivity
daily_time_saved = 705ms × 50 invocations = 35 seconds/developer/day
yearly_time_saved = 35s × 120 developers × 250 days = 1,050,000 seconds = 292 hours

# Business
hourly_rate = Rp 300,000
yearly_value = 292 hours × Rp 300K = Rp 87.6 juta
```

**Mengapa ROI Penting untuk Board:**

Board of directors berpikir dalam:
- **ROI** — return on investment
- **Risk** — risk mitigation
- **Competitive advantage** — market positioning
- **Scalability** — bisa tumbuh?

**Bahasa Bisnis:**

| Jangan bilang | Bilang |
|---|---|
| "Saya optimasi startup time" | "Menghemat Rp 87 juta/tahun" |
| "Saya implementasi security" | "Menghindari risiko breach $2M" |
| "Saya bangun CLI tool" | "Meningkatkan produktivitas 15%" |
| "Saya kontribusi open source" | "Building brand, memudahkan hiring" |
| "Saya dokumentasi sistem" | "Reducing bus factor, enabling scale" |

**Caveats — Mengapa Penting:**

Metrics bisa menyesatkan. Honest assessment:
- **Sample size** — 5 developer ≠ 120 developer
- **Correlation vs causation** — improvement mungkin dari faktor lain
- **Estimation** — nilai jam × rate adalah estimasi
- **Bias** — survey ada response bias

**Board menghargai kejujuran.** Menyebut caveat menunjukkan **intellectual honesty** dan **rigor**.

---

### Pertanyaan 3: Portfolio Presentation — Slide Deck

**Tantangan:** Buat slide deck 20-slide untuk board of directors. Deck harus: (a) tidak teknis, (b) fokus pada business impact, (c) punya narrative yang jelas, (d) siap untuk presentasi 30 menit + 15 menit Q&A.

**Jawaban:**

**`portfolio/presentation.md` — Marp/Pandoc format:**

```markdown
---
marp: true
theme: default
paginate: true
---

<!-- _class: lead -->

# Shell Infrastructure
## 18 Months of Investment, 508% ROI

**Presented to:** Board of Directors
**By:** [Your Name], VP of Engineering
**Date:** October 2026

---

## The Challenge (Feb 2025)

![bg right:40% 80%](assets/challenge.png)

- **30 developers** struggling with inconsistent environments
- **3 days** to onboard new developer
- **2 security incidents** in 2024
- **No compliance** readiness
- **No internal tooling** for DevOps

**Cost:** ~$500K/year in lost productivity + risk

---

## Our Approach

Three pillars:

### 1. Standardize
- Modular configuration
- Automated deployment
- Consistent experience

### 2. Secure
- Policy as code
- Secret management
- Audit trail

### 3. Enable
- Custom CLI tool
- Modern tooling
- Self-service

---

## Investment

| Item | 18-Month Cost |
|---|---|
| Engineering time | $80K |
| Tools | $15K |
| Training | $7K |
| **Total** | **$102K** |

**Team size:** 3 engineers
**Duration:** 18 months

---

## Results — Performance

![w:800](assets/startup-chart.png)

| Metric | Before | After |
|---|---|---|
| Startup time | 800ms | **95ms (-88%)** |
| Terminal opens/day | ~50/developer | ~50/developer |
| **Time saved** | — | **292 hours/year** |

**Annual value:** $58K

---

## Results — Onboarding

![bg left:40%](assets/onboarding.png)

| Step | Before | After |
|---|---|---|
| Full setup | 3 days | **5 minutes** |

**For 40 new hires/year:**
- Time saved: **956 hours/year**
- Value: **$191K/year**

---

## Results — Security

![w:800](assets/security-chart.png)

| Metric | 2024 | 2026 |
|---|---|---|
| Security incidents | 2 | **0** |
| Secrets in config | 15 | **0** |
| Compliance | Not ready | **SOC 2 ✅** |

**Value:** $300K (avoided incidents) + $2M+ (enabled deals)

---

## Results — Productivity

![bg right:40%](assets/cli-tool.png)

**CLI Tool Adoption:**
- **85%** daily active users
- **~50,000** commands/week
- **~600 hours/month** saved

**Value:** **$1.4M/year**

---

## Results — Developer Satisfaction

| Survey Question | 2025 | 2026 |
|---|---|---|
| Satisfied with setup | 40% | **92%** |
| Setup is fast | 25% | **88%** |
| Feel productive | 55% | **85%** |
| Security adequate | 30% | **95%** |

**Impact:** Higher retention → $1.6M/year saved

---

## Results — Open Source

**We gave back:**

- **12 patches** submitted to Zsh core
- **8 merged**
- **2 plugins** created (450+ stars)
- **5 blog posts**
- **2 conference talks**

**Value:** Brand building, easier recruiting, community recognition

---

## Total ROI

![w:900](assets/roi-chart.png)

| Metric | Value |
|---|---|
| **Investment** | $102K |
| **Annual Return** | **$5.5M** |
| **ROI** | **5,400%** |
| **Payback** | **~2 weeks** |

---

## Business Impact Summary

### Before (Feb 2025)
- 🔴 Slow, inconsistent environments
- 🔴 3-day onboarding
- 🔴 Security incidents
- 🔴 No compliance
- 🔴 No internal tooling

### After (Oct 2026)
- 🟢 **8x faster** startup
- 🟢 **5-minute** onboarding
- 🟢 **Zero** incidents
- 🟢 **SOC 2 certified**
- 🟢 **85% adoption** of CLI tool

---

## What's Next — 12 Month Roadmap

### Q1 2027
- ✅ ISO 27001 certification
- 🚧 ShellCheck in CI
- 📋 Multi-region deployment

### Q2 2027
- 📋 Backup testing automation
- 📋 Team self-service
- 📋 Metrics dashboard v2

### Q3-Q4 2027
- 📋 Extend to CI/CD pipelines
- 📋 Container-based dev environments
- 📋 ML-based anomaly detection

---

## Key Learnings

### What Worked

1. **Modular architecture** — enables scale
2. **Automation** — Ansible, CI/CD
3. **Security first** — not retrofitted
4. **Measurement** — data-driven decisions
5. **Community** — give back to open source

### What Didn't

1. **Big bang migration** — gradual is better
2. **Over-engineering** — start simple
3. **Reinventing wheels** — use mature tools
4. **Delayed documentation** — document as you go

---

## Risk Mitigation

### Risks We've Addressed

| Risk | Mitigation |
|---|---|
| **Security breach** | Policy as code, zero secrets in config |
| **Compliance failure** | Automated evidence, regular audit |
| **Key person dependency** | Documentation, handover |
| **Scaling issues** | Modular architecture, automation |
| **Vendor lock-in** | Open standards, open source |

---

## Recommendation

### Continue Investment

- **$50K/year** for tooling and training
- **1 FTE** dedicated to platform engineering
- **Quarterly** board updates on metrics

### Expected Returns

- **$5.5M/year** in value
- **100x** ROI
- **Industry-leading** developer experience

**This is not a cost center — it's a competitive advantage.**

---

## Questions?

**Contact:**
- Email: [your.email@nusantara.tech]
- Docs: docs.nusantara.tech/shell
- Metrics: metrics.nusantara.tech/shell

**Thank you.**

---

<!-- _class: lead -->

# Appendix
## Backup slides

---

## Technical Architecture

![w:900](assets/architecture.png)

Three layers:
- **Foundation** — security, base config
- **Team** — specialized tools per team
- **Personal** — developer preferences

---

## Deployment Pipeline

![w:900](assets/pipeline.png)

1. **Git push** → CI test
2. **Merge** → Ansible deploy to staging
3. **Verify** → Deploy to production
4. **Monitor** → Metrics + alerts

**Duration:** ~30 minutes for 120 hosts

---

## Security Layers

![w:900](assets/security.png)

1. **Prevention** — Policy as code, no secrets in config
2. **Detection** — Automated scanning, anomaly detection
3. **Response** — Runbook, rollback, incident management
4. **Recovery** — Backup, tested restore

---

## Metrics Data

### Startup Time Trend

```
Feb 2025 ████████████████████████ 800ms
Jun 2025 ██████████████           450ms
Oct 2025 ██████                   200ms
Feb 2026 ████                     130ms
Jun 2026 ███                      110ms
Oct 2026 ███                       95ms
```

### Adoption

```
Q1 2025 ██░░░░░░░░ 15%
Q2 2025 ████░░░░░░ 35%
Q3 2025 ██████░░░░ 55%
Q4 2025 ████████░░ 75%
Q1 2026 █████████░ 85%
Q2 2026 ██████████ 88%
Q3 2026 ██████████ 85%
```

---

## ROI Calculation Detail

**Investment:** $102K
- Engineering: 3 × 18 months × $15K/month = $81K
- Tools: $15K
- Training: $6K

**Annual Return:** $5.5M
- Compliance deals: $2M
- Developer retention: $1.6M
- Productivity (CLI): $1.4M
- Security avoided: $300K
- Onboarding: $191K
- Open source brand: $100K

**ROI = (5.5M - 102K) / 102K × 100% = 5,292%**

---

## Contact

**Handover Documents:**
git.nusantara.tech/infra/shell-dotfiles/docs/handover

**Live Metrics:**
metrics.nusantara.tech/shell

**Email:**
[your.email@nusantara.tech]
```

**Penjelasan Mental — Slide Deck yang Efektif:**

**Aturan Presentasi ke Board:**

1. **Less is more** — 20 slides max untuk 30 menit
2. **One idea per slide** — jangan campur
3. **Visual > text** — charts > tables > bullet points
4. **Lead with impact** — hasil dulu, cara kemudian
5. **Business language** — $ bukan ms
6. **Tell a story** — challenge → approach → results

**Struktur Narrative:**

```
1. Hook — The Challenge (empati)
2. Setup — Our Approach (visi)
3. Journey — Investment (what it took)
4. Payoff — Results (proof)
5. Vision — Roadmap (future)
6. Call — Recommendation (action)
```

**Mengapa Chart Penting:**

Board tidak punya waktu untuk membaca tabel. Chart:
- **Instan** — visual diproses 60,000x lebih cepat
- **Memorable** — 65% orang visual learners
- **Persuasive** — menunjukkan trend, bukan hanya angka

**Rules untuk Chart:**

1. **Simple** — satu chart, satu pesan
2. **Labeled** — axis, legend jelas
3. **Color** — gunakan warna untuk emphasis
4. **Title** — kesimpulan, bukan deskripsi
5. **Source** — selalu cite sumber

**Anticipate Q&A:**

Untuk setiap slide, siapkan:
- **Data pendukung** — backup slide
- **Analogi** — untuk menjelaskan ke non-technical
- **Contoh konkret** — story, bukan abstrak
- **Honest caveat** — acknowledge limitations

**Pertanyaan yang Mungkin Ditanya:**

| Pertanyaan | Jawaban |
|---|---|
| "Bagaimana Anda mengukur ROI?" | Estimasi jam × rate + avoided costs |
| "Apa risiko utama?" | Security (mitigated), key person (documented) |
| "Apakah ini scalable?" | Yes — modular, automated |
| "Apa jika Anda pergi?" | Handover docs, no key person |
| "Berapa biaya maintain?" | $50K/year, 1 FTE |
| "Apa yang tidak berhasil?" | Big bang migration, over-engineering |
| "Bagaimana Anda membandingkan dengan industri?" | Better than average (95ms vs ~200ms industry) |
| "Apa next step?" | ISO 27001, multi-region, self-service |

---

### Pertanyaan 4: Demo Script — Live Demonstration

**Tantangan:** Board ingin melihat demo live. Anda perlu: (a) scenario yang menunjukkan value, (b) script yang repeatable, (c) backup plan jika demo gagal.

**Jawaban:**

**`portfolio/demo/demo-script.md`:**

```markdown
# Demo Script — Shell Infrastructure

**Duration:** 10 minutes
**Audience:** Board of Directors
**Presenter:** [Your Name]

## Pre-Demo Checklist

- [ ] Terminal window clean (clear screen)
- [ ] Font size besar (18pt+)
- [ ] Color scheme high-contrast
- [ ] Notification off (Slack, email)
- [ ] WiFi stable
- [ ] Backup recording ready
- [ ] Test the demo 30 minutes before

## Scenario

**Story:** New developer "Budi" joins Nusantara Tech. From fresh laptop to productive in 5 minutes.

## Demo Flow

### Part 1: Onboarding (3 min)

**[Screen: Empty terminal]**

> "Mari kita lihat bagaimana developer baru setup environment mereka. Ini laptop fresh, tanpa setup apa pun."

```zsh
# Show no Zsh config
ls -la ~/.zshrc 2>/dev/null || echo "Tidak ada config"
```

**[Output: "Tidak ada config"]**

> "Sekarang, Budi clone repository dan jalankan satu perintah."

```zsh
# Run onboarding
curl -fsSL https://git.nusantara.tech/infra/shell-dotfiles/raw/main/install.sh | zsh
```

**[Show installation output — ~30 seconds]**

> "Itu saja. 30 detik. Sekarang Budi buka terminal baru."

```zsh
# Open new terminal
exec zsh
```

**[Show new prompt with all features]**

> "Perhatikan: prompt menunjukkan git branch, Kubernetes context, dan status. Ini yang dulu butuh 3 hari untuk setup."

### Part 2: CLI Tool (4 min)

> "Sekarang mari kita lihat CLI tool internal yang kami bangun."

```zsh
# Show help
nt help
```

**[Show help output]**

> "Tool ini menggantikan puluhan command yang dulu harus diingat."

```zsh
# Check service status
nt status
```

**[Show service status table]**

> "Sebelumnya, untuk cek status 15 service, developer harus SSH ke 3 server dan menjalankan 15 perintah berbeda. Sekarang: satu perintah."

```zsh
# Deploy to staging
nt deploy staging api --version v2.1.0 --dry-run
```

**[Show dry-run output]**

> "Deploy aman dengan dry-run. Dalam production, ada konfirmasi."

```zsh
# Kubernetes interaction
nt k8s pods --context staging
```

**[Show pods]**

> "FZF integration untuk pemilihan interaktif. Developer tidak perlu ingat nama pod."

```zsh
# Interactive debug
nt debug api
```

**[Show interactive picker]**

> "Semua ini awalnya butuh bertahun-tahun pengalaman untuk mengingat. Sekarang, satu tool."

### Part 3: Security (2 min)

> "Sekarang bagian yang penting: keamanan."

```zsh
# Show no secrets in config
grep -rE '(password|token|api_key)\s*=' ~/.config/zsh/ 2>/dev/null | head
```

**[Output: empty]**

> "Zero secrets in config. Semua secrets di 1Password."

```zsh
# Show secret management
op account list
```

**[Show 1Password account]**

> "Satu source of truth. Rotasi mudah. Audit trail otomatis."

```zsh
# Show audit trail
cat /var/log/zsh_history/$(whoami)_$(hostname) | tail -5
```

**[Show history with timestamps]**

> "Semua command tercatat dengan timestamp. Untuk compliance."

### Part 4: Performance (1 min)

> "Terakhir, performa."

```zsh
# Measure startup time
for i in {1..5}; do
    /usr/bin/time -p zsh -i -c exit 2>&1 | grep real
done
```

**[Show ~95ms consistently]**

> "95ms rata-rata. Bandingkan dengan industri yang ~200-300ms. Kami 2-3x lebih cepat."

### Closing (30 sec)

> "Jadi, dalam 10 menit, Anda melihat:"
> - "Onboarding 3 hari → 5 menit"
> - "CLI tool dengan 85% adoption"
> - "Zero security incidents"
> - "Startup 8x lebih cepat"
>
> "Ini adalah investasi $102K yang menghasilkan $5.5M/tahun. ROI 5,400%."

## Backup Plan

### If demo fails:

1. **Apologize briefly** — "Sepertinya ada masalah teknis"
2. **Switch to video** — pre-recorded demo (ready)
3. **Continue with slides** — skip live demo
4. **Offer follow-up** — "Saya akan kirim video demo setelah presentasi"

### Common failures & solutions:

| Failure | Solution |
|---|---|
| Network down | Use local demo files |
| CLI tool errors | Switch to backup environment |
| Slow output | Skip to next part |
| Terminal freeze | Ctrl+C, restart demo |
| Wrong output | Acknowledge, explain expected |

## Practice

**Practice schedule:**
- Day 1: Run demo 3x
- Day 2: Run with timer, aim for 10 min
- Day 3: Run with colleague as audience
- Day 4: Run with backup scenarios
- Day 5: Final run 30 min before

## Key Messages

Repetition is key. Repeat these 3 times during demo:

1. **"5 menit onboarding"** — 3x
2. **"85% adoption"** — 2x
3. **"ROI 5,400%"** — 2x

## Body Language

- **Eye contact** — with board members
- **Pace** — slow down, don't rush
- **Pauses** — after key points
- **Gestures** — point to screen
- **Voice** — project, vary tone

## Q&A Preparation

Anticipate these questions:

1. **"Apa jika developer tidak mau pakai?"** — 85% adoption, voluntary
2. **"Bagaimana kalau ada bug?"** — Automated rollback, tested
3. **"Berapa biaya maintain?"** — $50K/year, 1 FTE
4. **"Apakah bisa di-scale?"** — Yes, modular architecture
5. **"Apa yang tidak berhasil?"** — Big bang migration, over-engineering

**Answer structure:**
- Direct answer (1 sentence)
- Supporting detail (1-2 sentences)
- Transition to next topic

## Post-Demo

- [ ] Send slides + recording within 24 hours
- [ ] Follow up on questions
- [ ] Schedule deeper dive if requested
- [ ] Collect feedback
```

**`portfolio/demo/record-demo.sh` — Script untuk merekam demo:**

```zsh
#!/bin/zsh
# record-demo.sh — Rekam demo sebagai backup

set -euo pipefail

echo "🎬 Preparing demo recording..."

# Cek tools
if ! command -v asciinema &>/dev/null; then
    echo "Install asciinema: brew install asciinema"
    exit 1
fi

# Setup environment
mkdir -p ~/demo
cd ~/demo

# Start recording
echo "🎥 Recording akan dimulai dalam 3 detik..."
echo "   Tekan Ctrl+D untuk selesai."
sleep 3

asciinema rec --title "Nusantara Shell Demo" demo.cast

echo ""
echo "✅ Recording saved: ~/demo/demo.cast"
echo ""
echo "Convert ke GIF:"
echo "  agg demo.cast demo.gif"
echo ""
echo "Play back:"
echo "  asciinema play demo.cast"
```

**Penjelasan Mental — Demo yang Mengesankan:**

**Tiga Prinsip Demo:**

1. **Show, don't tell** — jangan hanya slide, tunjukkan
2. **Story-driven** — framing sebagai cerita
3. **Repeat key messages** — repetition = retention

**Formula Demo yang Efektif:**

```
Problem (10%) → Solution (80%) → Result (10%)
```

- **Problem:** Budi, developer baru, 3 hari setup
- **Solution:** Demo langkah demi langkah
- **Result:** 5 menit, live

**Mengapa Backup Plan Kritis:**

Demo live bisa gagal karena:
- Network
- Environment
- Typo
- Bug

**Aturan:** Selalu punya backup. Video recording adalah insurance.

**Body Language:**

- **Eye contact** — dengan audience, bukan layar
- **Pause** — setelah poin penting
- **Voice** — varied, project
- **Hands** — gestures untuk emphasis

**Struktur Demo:**

```
Setup (30s) → Onboarding (3m) → CLI (4m) → Security (2m) → Perf (1m) → Close (30s)
= 11 menit total
```

**Tips Teknis:**

1. **Font besar** — 18pt minimum
2. **High contrast** — light text on dark
3. **No animation** — distraction
4. **Clear screen** — before each section
5. **Test first** — 30 min before

---

### Pertanyaan 5: Roadmap — 12 Bulan ke Depan

**Tantangan:** Buat roadmap 12 bulan untuk shell infrastructure. Roadmap harus: (a) realistic, (b) aligned dengan business goals, (c) punya milestones yang terukur.

**Jawaban:**

**`handover/08-roadmap.md`:**

```markdown
# Roadmap — Shell Infrastructure (2027)

## Strategic Objectives

### 1. Maturity
- Dari "berfungsi" → "enterprise-grade"
- ISO 27001 certification
- 99.9% uptime

### 2. Scale
- Dari 120 → 200 developer
- Dari 5 → 8 tim
- Multi-region deployment

### 3. Innovation
- AI-assisted tooling
- Self-service platform
- Extend to CI/CD

## Q1 2027 (Jan-Mar)

### 🎯 Milestone 1: ISO 27001 Certification

**Owner:** Security Lead
**Effort:** 3 months
**Budget:** $30K

**Tasks:**
- [ ] Gap analysis (Jan)
- [ ] Remediation (Feb)
- [ ] Internal audit (Mar)
- [ ] External audit prep (Mar)

**Success criteria:**
- Zero findings in internal audit
- External audit scheduled Q2

**Business value:** Enterprise deals require ISO 27001

### 🎯 Milestone 2: ShellCheck in CI

**Owner:** Platform Engineer
**Effort:** 2 weeks
**Budget:** $0

**Tasks:**
- [ ] Setup GitHub Actions workflow
- [ ] Configure severity thresholds
- [ ] Fix existing warnings
- [ ] Enable as required check

**Success criteria:**
- All scripts pass ShellCheck
- CI blocks on warning

**Business value:** Prevent bugs sebelum production

### 🎯 Milestone 3: Multi-Region Deployment

**Owner:** DevOps Lead
**Effort:** 2 months
**Budget:** $50K

**Tasks:**
- [ ] Network setup (Jan)
- [ ] Replicate infrastructure (Feb)
- [ ] Test failover (Mar)
- [ ] Production rollout (Mar)

**Success criteria:**
- <5 min failover time
- Zero data loss
- Tested quarterly

**Business value:** DR compliance, regional latency

## Q2 2027 (Apr-Jun)

### 🎯 Milestone 4: Backup Testing Automation

**Owner:** Platform Engineer
**Effort:** 1 month
**Budget:** $0

**Tasks:**
- [ ] Setup staging environment
- [ ] Automate restore test
- [ ] Integrate with CI
- [ ] Monthly report

**Success criteria:**
- Monthly restore test passing
- RTO <1 hour, RPO <15 min

**Business value:** Verify backup actually works

### 🎯 Milestone 5: Team Self-Service

**Owner:** Platform Engineer + Team Leads
**Effort:** 3 months
**Budget:** $20K (tooling)

**Tasks:**
- [ ] Design RBAC system
- [ ] Build self-service portal
- [ ] Migrate 5 teams
- [ ] Document process

**Success criteria:**
- 80% tasks self-service
- <1 day lead time for config changes

**Business value:** Reduce IT bottleneck, empower teams

### 🎯 Milestone 6: Metrics Dashboard v2

**Owner:** Data Engineer
**Effort:** 2 months
**Budget:** $10K

**Tasks:**
- [ ] Design new schema
- [ ] Build dashboard (Grafana)
- [ ] Add alerting
- [ ] Integrate with Slack

**Success criteria:**
- Real-time metrics
- Proactive alerts
- Executive dashboard

**Business value:** Data-driven decisions

## Q3 2027 (Jul-Sep)

### 🎯 Milestone 7: Extend to CI/CD

**Owner:** DevOps Lead
**Effort:** 3 months
**Budget:** $40K

**Tasks:**
- [ ] Standardize CI environments
- [ ] Container-based runners
- [ ] Reproducible builds
- [ ] Security scanning in pipeline

**Success criteria:**
- All CI uses standardized environment
- Build time reduced 50%

**Business value:** Faster, more reliable deployments

### 🎯 Milestone 8: Container-Based Dev Environments

**Owner:** Platform Engineer
**Effort:** 2 months
**Budget:** $30K

**Tasks:**
- [ ] Design container-based dev env
- [ ] Migrate pilot team
- [ ] Documentation
- [ ] Rollout to all teams

**Success criteria:**
- <2 min environment startup
- Zero local dependency conflicts

**Business value:** "Works on my machine" → solved

## Q4 2027 (Oct-Dec)

### 🎯 Milestone 9: ML-Based Anomaly Detection

**Owner:** Data Engineer
**Effort:** 3 months
**Budget:** $20K

**Tasks:**
- [ ] Collect training data
- [ ] Build ML model
- [ ] Integrate with monitoring
- [ ] Validate accuracy

**Success criteria:**
- 95% precision in anomaly detection
- <5% false positive rate

**Business value:** Proactive issue detection

### 🎯 Milestone 10: Extend to 200 Developers

**Owner:** VP Engineering
**Effort:** Ongoing
**Budget:** $0

**Tasks:**
- [ ] Onboard 80 new developers
- [ ] Extend to 3 new teams
- [ ] Update documentation
- [ ] Quarterly review

**Success criteria:**
- All developers onboarded
- Same quality metrics

**Business value:** Scale without degradation

## Success Metrics (End of 2027)

| Metric | Target |
|---|---|
| **Startup time** | <80ms |
| **Onboarding time** | <3 minutes |
| **Security incidents** | 0 |
| **Compliance** | ISO 27001 ✅ |
| **Adoption** | >90% |
| **Developer satisfaction** | >90% |
| **Uptime** | 99.9% |
| **Uptime (dev productivity)** | — |

## Investment Summary

| Quarter | Investment | Focus |
|---|---|---|
| Q1 2027 | $80K | Compliance, DR |
| Q2 2027 | $30K | Automation, self-service |
| Q3 2027 | $70K | CI/CD, containers |
| Q4 2027 | $20K | ML, scale |
| **Total** | **$200K** | — |

**Expected Return:** $8M/year (vs $5.5M current)

## Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| **ISO audit delay** | Medium | High | Buffer time, pre-audit |
| **Multi-region complexity** | High | High | Phased rollout, expert help |
| **Budget cut** | Medium | Medium | Prioritize high-ROI items |
| **Key person departure** | Low | High | Documentation, cross-training |
| **Technology change** | Medium | Low | Modular, adaptable |

## Dependencies

### Internal
- **IT team** — Network, security
- **Finance** — Budget approval
- **HR** — Hiring for growth
- **CTO** — Strategic alignment

### External
- **Auditors** — ISO 27001 certification
- **Cloud providers** — Multi-region infrastructure
- **Open source** — Zsh, Ansible, etc.

## Quarterly Review Process

**Every quarter:**
1. Review progress vs milestones
2. Adjust roadmap if needed
3. Report to CTO
4. Update stakeholders

**Format:** Metrics dashboard + narrative + next quarter plan

---

*Last updated: 2026-10-12*
```

**Penjelasan Mental — Roadmap yang Realistic:**

**Tiga Prinsip Roadmap:**

1. **Realistic** — jangan over-promise
2. **Prioritized** — high-impact dulu
3. **Measurable** — milestones terukur

**Prioritization Framework:**

| Framework | Kapan Pakai |
|---|---|
| **MoSCoW** | Must, Should, Could, Won't |
| **RICE** | Reach, Impact, Confidence, Effort |
| **Kano** | Basic, Performance, Delight |

**Untuk Enterprise:** RICE.

**RICE Example:**

```
Milestone: ISO 27001
Reach: 120 developers (all)
Impact: 3 (massive — enables enterprise deals)
Confidence: 80% (auditor available)
Effort: 3 months
RICE Score: 120 × 3 × 0.8 / 3 = 96

Milestone: ML Anomaly Detection
Reach: 120 developers
Impact: 1 (nice to have)
Confidence: 50%
Effort: 3 months
RICE Score: 120 × 1 × 0.5 / 3 = 20

Priority: ISO 27001 (96) > ML (20)
```

**Mengapa Roadmap Realistic Penting:**

Over-promise = under-deliver = loss of trust.
Under-promise = over-deliver = trust building.

**Buffer untuk Risiko:**

Setiap milestone harus punya buffer:
- **Optimistic:** 2 weeks
- **Realistic:** 3 weeks
- **Pessimistic:** 4 weeks

**Plan:** 3 weeks. Buffer: 1 week.

**Aligned dengan Business Goals:**

Roadmap harus mendukung strategic objectives perusahaan:
- **Revenue growth** → compliance, DR
- **Cost reduction** → automation
- **Competitive advantage** → innovation
- **Risk mitigation** → security

**Quarterly Review:**

Setiap quarter:
1. **Progress** — milestone selesai?
2. **Metrics** — target tercapai?
3. **Adjust** — re-prioritize?
4. **Communicate** — stakeholder update

---

### Pertanyaan 6: Open Source Contribution Report

**Tantangan:** Board ingin tahu dampak dari open source contribution. Buat report yang: (a) menunjukkan kontribusi, (b) menghubungkan dengan business value, (c) membuat rekomendasi untuk kelanjutan.

**Jawaban:**

**`portfolio/open-source-report.md`:**

```markdown
# Open Source Contribution Report

**Period:** 2024-2026
**Author:** [Your Name]
**For:** Board of Directors

## Executive Summary

Nusantara Tech telah berkontribusi ke ekosistem open source selama 18 bulan:

| Metric | Value |
|---|---|
| **Patches submitted** | 12 |
| **Patches merged** | 8 |
| **Plugins created** | 2 |
| **Stars on plugins** | 450+ |
| **Blog posts** | 5 |
| **Conference talks** | 2 |
| **Estimated PR value** | $100K+ |

**Strategic Value:** Brand building, recruiting, retention.

## Contribution Detail

### 1. Zsh Core Contributions

**Project:** [Zsh](https://github.com/zsh-users/zsh) (50K+ stars)

**Patches:**

| # | Title | Status | Impact |
|---|---|---|---|
| 1 | Fix kubectl completion missing options | ✅ Merged | All Zsh users |
| 2 | Add support for XDG Base Directory | ✅ Merged | Compliance |
| 3 | Improve autoload performance | ✅ Merged | 20% faster |
| 4 | Fix glob qualifier edge case | ✅ Merged | Bug fix |
| 5 | Add test for completion system | ✅ Merged | Quality |
| 6 | Documentation: completion guide | ✅ Merged | Documentation |
| 7 | Refactor: modernize code style | 🚧 In Review | Cleanup |
| 8 | Feature: async completion | 🚧 In Review | Performance |
| 9 | Documentation: FAQ update | ❌ Rejected | Duplicate |
| 10 | Fix: typo in manual | ❌ Rejected | Trivial |
| 11 | Feature: Zsh LSP support | 💭 Discussion | Large scope |
| 12 | Documentation: Migration guide | ✅ Merged | Onboarding |

**Impact:**
- Used by **millions of Zsh users** globally
- Startup improvements benefit **all Zsh users**
- Documentation helps **new Zsh users**

### 2. Plugins Created

#### Plugin 1: `zsh-clipboard-history`

**Purpose:** Clipboard history dengan FZF integration.

**Stats:**

| Metric | Value |
|---|---|
| Stars | 320+ |
| Forks | 45 |
| Contributors | 8 |
| Issues closed | 23 |
| Downloads | ~5K/month |

**Adoption:** Listed in [awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins)

#### Plugin 2: `zsh-k8s-prompt`

**Purpose:** Kubernetes context di prompt dengan safety warnings.

**Stats:**

| Metric | Value |
|---|---|
| Stars | 130+ |
| Forks | 18 |
| Contributors | 3 |
| Issues closed | 12 |
| Downloads | ~2K/month |

**Adoption:** Used by several companies internally (mentioned in issues).

### 3. Blog Posts

| # | Title | Platform | Views |
|---|---|---|---|
| 1 | "From 800ms to 95ms: Optimizing Zsh Startup" | dev.to | 15K |
| 2 | "Modular Zsh Configuration" | Medium | 8K |
| 3 | "Building Production CLI Tools in Zsh" | Company blog | 5K |
| 4 | "Secret Management for Shell Scripts" | dev.to | 12K |
| 5 | "Open Source Contribution Guide" | Company blog | 3K |

**Total views:** 43K+

### 4. Conference Talks

| # | Talk | Conference | Attendees |
|---|---|---|---|
| 1 | "Zsh for Enterprise" | DevOps Days Jakarta | 200 |
| 2 | "Open Source Contribution" | Internal Tech Talk | 150 |

**Slides:** Available on [Speaker Deck](https://speakerdeck.com/)

## Business Value

### 1. Brand Building

**Media Coverage:**
- 2 mentions di newsletters
- 3 mentions di podcasts
- 5 mentions di blog posts

**Estimated Media Value:** $25K

### 2. Recruiting

**Impact:**
- **30%** of candidates mention open source contribution in interview
- **50%** of new hires say open source was a factor
- **20%** reduction in time-to-hire

**Cost Savings:**
- Average cost per hire: $15K
- 40 hires/year × 20% reduction = 8 hires × $15K = **$120K/year**

### 3. Retention

**Survey Result:**
- 78% of developers say open source contribution increases job satisfaction
- 65% say it's a factor in staying

**Estimated Value:**
- Cost of turnover: $100K per developer
- If contribute to 10% retention: 12 developers × $100K = **$1.2M**

### 4. Developer Growth

**Skills Developed:**
- Communication (async, written)
- Code review (both sides)
- Community management
- Technical writing

**Estimated Training Value:** $20K

### 5. Technical Benefits

**Influence on Upstream:**
- We use Zsh daily, so we know pain points
- Our patches improve Zsh for everyone
- We can influence direction of project

**Early Access:**
- We know about changes before release
- We can test early
- We can prepare

## Total Value

| Category | Value |
|---|---|
| Media coverage | $25K |
| Recruiting | $120K |
| Retention | $1.2M |
| Training | $20K |
| Technical | $100K |
| **Total** | **$1.47M** |

## Recommendation

### Continue and Expand

**Recommendation:** Continue investment in open source, expand to:
- **2 more contributors** (from team)
- **1 dedicated open source day/month**
- **Budget for conferences** ($20K/year)

**Expected Return:**
- $1.5M+ annual value
- 100x ROI on time investment
- Strategic positioning as "engineering-first" company

### Specific Actions

1. **Q1 2027:**
   - Hire 1 developer with open source experience
   - Setup open source policy
   - Budget approval ($20K)

2. **Q2 2027:**
   - 2 engineers contribute 1 day/month
   - Submit 1 conference talk
   - Blog post monthly

3. **Q3 2027:**
   - Host local meetup
   - Sponsor 1 conference
   - Create "open source" page on website

4. **Q4 2027:**
   - Review impact
   - Plan 2028

## Risks

| Risk | Mitigation |
|---|---|
| **Time distraction** | Dedicated day, clear scope |
| **IP concerns** | Policy, legal review |
| **Employee burnout** | Voluntary, recognized |
| **No ROI** | Track metrics, adjust |

## Conclusion

Open source contribution adalah **strategic investment**, bukan **cost center**.

Dengan ROI ~100x, ini adalah salah satu investasi terbaik yang bisa dilakukan perusahaan.

**Recommendation:** Continue and expand.

---

*Last updated: 2026-10-12*
```

**Penjelasan Mental — Open Source sebagai Strategi:**

**Mengapa Open Source Penting untuk Bisnis:**

1. **Brand** — dikenal sebagai "engineering company"
2. **Recruiting** — developer ingin kerja di tempat yang contribute
3. **Retention** — developer bangga
4. **Influence** — bisa influence arah teknologi
5. **Learning** — belajar dari komunitas
6. **Networking** — koneksi dengan expert

**Bentuk Kontribusi (Value Ranking):**

| Bentuk | Effort | Value |
|---|---|---|
| **Patch ke core** | High | Very High |
| **Plugin creation** | Medium | High |
| **Bug report** | Low | Medium |
| **Documentation** | Low | Medium |
| **Blog post** | Medium | Medium |
| **Conference talk** | Medium | High |
| **Sponsorship** | Money | High |
| **Mentoring** | High | High |

**ROI Open Source:**

```
Investment:
- Time: 20% of 3 engineers = 0.6 FTE
- Conferences: $20K/year
- Tools: $5K
Total: ~$100K/year

Return:
- Recruiting: $120K/year
- Retention: $1.2M/year
- Brand: $25K/year
- Training: $20K/year
Total: $1.365M/year

ROI: 1,265%
```

**Best Practice Open Source Corporate:**

1. **Policy** — clear rules
2. **Time** — dedicated (10-20%)
3. **Recognition** — rewarded in perf review
4. **Legal** — IP review
5. **Measurement** — track impact
6. **Communication** — internal blog, external blog

**Risks to Manage:**

1. **IP leak** — prevent by policy
2. **Time distraction** — dedicated time
3. **Employee burnout** — voluntary
4. **No ROI** — track, adjust
5. **Legal issues** — legal review

---

### Pertanyaan 7: Personal Reflection & Career Development

**Tantangan:** Tulis personal reflection untuk diri sendiri. Reflection harus: (a) honest tentang perjalanan, (b) identify area untuk growth, (c) plan untuk 12 bulan ke depan.

**Jawaban:**

**`portfolio/personal-reflection.md`:**

```markdown
# Personal Reflection — 18 Months Journey

**Author:** [Your Name]
**Date:** 2026-10-12
**Privacy:** Private (personal journal)

---

## The Beginning (Feb 2025)

Saya ingat hari pertama saya bergabung sebagai Senior Engineer. Saya pikir saya sudah tahu banyak tentang Zsh. Ternyata saya salah.

Hari pertama saya: setup laptop. Butuh 3 hari. Frustrasi. Saya pikir: "Ini tidak boleh terjadi."

Itu adalah **seed** dari semua yang saya bangun.

## The Journey

### Month 1-3: Foundation

Fokus: memahami environment, membangun audit.

**Pelajari:**
- Startup files Zsh yang sebenarnya (bukan yang saya kira)
- Perbedaan sistem-wide vs user
- Bagaimana developer lain bekerja

**Challenge:** 30 developer dengan 30 setup berbeda.

**Achievement:** Berhasil audit semua, dokumentasi temuan.

### Month 4-6: Building

Fokus: membangun konfigurasi modular.

**Pelajari:**
- `conf.d/` pattern
- GNU Stow
- Ansible (pertama kali!)

**Challenge:** Migrasi 30 developer tanpa downtime.

**Achievement:** Berhasil migrasi, tapi ada drama (big bang → gradual).

**Lesson:** Gradual > Big Bang.

### Month 7-9: Scaling

Fokus: security, compliance, performance.

**Pelajari:**
- 1Password CLI
- Secret management
- Compliance frameworks (SOC 2)
- Profiling (zprof)

**Challenge:** Audit keamanan menemukan 15 secrets.

**Achievement:** Zero secrets now. SOC 2 pass.

**Lesson:** Security is not a feature.

### Month 10-12: Innovating

Fokus: membangun `nt` CLI tool.

**Pelajari:**
- Dispatcher pattern
- Testing (ShellSpec)
- CI/CD
- Integration (Python, K8s)

**Challenge:** Build production-grade tool dalam 4 minggu.

**Achievement:** 85% adoption.

**Lesson:** User-centered design matters.

### Month 13-15: Scaling Further

Fokus: 120 developer, 5 tim, open source.

**Pelajari:**
- Multi-team architecture
- Open source contribution
- Ansible advanced
- Compliance reporting

**Challenge:** Balance between standardization and flexibility.

**Achievement:** 5 open source patches merged.

**Lesson:** Give back to community.

### Month 16-18: Consolidating

Fokus: handover, roadmap, reflection.

**Pelajari:**
- Documentation as product
- Communication with C-level
- Strategic thinking

**Challenge:** Synthesize 18 months into docs.

**Achievement:** Complete handover, portfolio ready.

**Lesson:** Documentation is legacy.

## Skills Gained

### Technical

| Skill | Before (1/5) | After (1/5) |
|---|---|---|
| Zsh scripting | 3 | 5 |
| Bash → Zsh migration | 2 | 5 |
| Ansible | 1 | 4 |
| Security (secrets) | 2 | 5 |
| Compliance (SOC 2) | 1 | 4 |
| Testing (ShellSpec) | 1 | 4 |
| CI/CD | 2 | 4 |
| Documentation | 3 | 5 |

### Non-Technical

| Skill | Before (1/5) | After (1/5) |
|---|---|---|
| Communication (C-level) | 2 | 4 |
| Mentoring | 3 | 4 |
| Project management | 2 | 4 |
| Strategic thinking | 2 | 4 |
| Writing | 3 | 5 |
| Open source etiquette | 1 | 4 |

## What I'm Proud Of

1. **Zero security incidents** — 18 bulan tanpa breach
2. **120 developers** menggunakan sistem setiap hari
3. **8x startup improvement** (800ms → 95ms)
4. **5 open source patches merged** — diakui secara global
5. **Onboarding 5 menit** — dari 3 hari
6. **SOC 2 pass** — zero findings
7. **Documentation** yang akan hidup setelah saya pergi
8. **Team culture** — blame-free, learning-focused

## What I Regret

1. **Big bang migration** — seharusnya gradual
2. **Delayed documentation** — seharusnya dari awal
3. **Over-engineering metrics** — seharusnya start simple
4. **Too technical for too long** — seharusnya komunikasi ke business lebih awal
5. **Not asking for help** — terlalu gengsi untuk tanya

## Areas for Growth

### 1. Strategic Thinking

**Current:** 4/5
**Target:** 5/5

**Action:**
- Baca buku strategi (Good Strategy/Bad Strategy)
- Mentoring dari CTO
- MBA? (consider)

### 2. Communication (Executive)

**Current:** 4/5
**Target:** 5/5

**Action:**
- Toastmasters
- Executive presence training
- Present to board regularly

### 3. Financial Acumen

**Current:** 2/5
**Target:** 4/5

**Action:**
- Baca buku finance
- Kerja dengan CFO
- Understand P&L

### 4. Hiring & Team Building

**Current:** 3/5
**Target:** 5/5

**Action:**
- Learn interview techniques
- Build team from scratch
- Develop leaders

## 12-Month Plan

### Q1 2027

- [ ] Setup new role as VP
- [ ] Hire 1 senior engineer
- [ ] Complete handover
- [ ] Start Toastmasters

### Q2 2027

- [ ] Present at 1 conference
- [ ] Read 3 books on leadership
- [ ] Mentor 2 junior engineers
- [ ] Set up executive coaching

### Q3 2027

- [ ] Launch new initiative
- [ ] Get feedback (360 review)
- [ ] Build leadership team
- [ ] Financial literacy course

### Q4 2027

- [ ] Year-end review
- [ ] Plan 2028
- [ ] Personal retreat
- [ ] Reflect on journey

## Long-Term Vision (5 Years)

**Where do I want to be?**

- **CTO** of a mid-size company, or
- **VP Engineering** at larger company, or
- **Founder** of own startup

**Skills needed:**
- Strategic thinking (currently 4/5)
- Financial acumen (2/5 → need work)
- Executive communication (4/5 → need polish)
- Team building (3/5 → need work)

**Path:**
- Year 1-2: VP role, learn execution
- Year 3-4: Senior VP, learn strategy
- Year 5: CTO or founder

## Lessons for Life

1. **Technical excellence is table stakes.** Yang membedakan adalah **impact**.
2. **Communication is 50%.** Engineer yang bisa komunikasi = 2x value.
3. **People > Process > Tools.** Yang paling penting adalah orang.
4. **Document as you go.** Documentation is investment, bukan cost.
5. **Give back.** Open source = responsibility.
6. **Measure everything.** Tanpa data, tebak-tebakan.
7. **Embrace failure.** Post-mortem, not blame.
8. **Sustainable pace.** Marathon, bukan sprint.
9. **Never stop learning.** Teknologi berubah, fundamental tetap.
10. **Be kind.** Hidup terlalu singkat untuk tidak.

## Gratitude

Terima kasih kepada:
- **CTO** — untuk trust dan mentorship
- **Team** — untuk eksekusi dan feedback
- **Community** — untuk open source
- **Family** — untuk support
- **Myself** — untuk persistensi

## Closing

18 bulan adalah perjalanan yang transformative. Saya masuk sebagai Senior Engineer, keluar sebagai VP of Engineering. Tapi yang lebih penting: saya tumbuh sebagai **manusia**.

Saya belajar bahwa **technical skill** hanyalah fondasi. Yang membedakan adalah **empathy**, **communication**, **strategic thinking**, dan **kindness**.

Saya excited untuk chapter berikutnya.

---

*Last updated: 2026-10-12*
```

**Penjelasan Mental — Reflection sebagai Growth:**

**Mengapa Reflection Penting:**

1. **Learning** — dari pengalaman
2. **Growth** — identify gap
3. **Direction** — set goals
4. **Gratitude** — appreciate journey
5. **Legacy** — untuk masa depan

**Framework Reflection:**

1. **What?** — Apa yang terjadi?
2. **So What?** — Mengapa penting?
3. **Now What?** — Apa next?

**Skill Assessment:**

Honest assessment penting. Jangan over-estimate.
- **1/5:** Beginner
- **2/5:** Advanced beginner
- **3/5:** Competent
- **4/5:** Proficient
- **5/5:** Expert

**Career Planning:**

12-month plan harus:
- **Specific** — bukan "belajar X"
- **Measurable** — "baca 3 buku"
- **Achievable** — realistic
- **Relevant** — aligned dengan vision
- **Time-bound** — deadline

**Long-term Vision:**

- **Where** — CTO? VP? Founder?
- **When** — 5 years?
- **How** — what skills needed?
- **Why** — what drives you?

---

### Pertanyaan 8: Final Presentation & Q&A

**Tantangan:** Presentasikan seluruh portfolio dalam 45 menit (30 menit presentasi + 15 menit Q&A). Siapkan untuk pertanyaan yang sulit.

**Jawaban:**

**`portfolio/presentation-script.md`:**

```markdown
# Presentation Script — Final

**Duration:** 30 minutes
**Audience:** Board of Directors
**Presenter:** [Your Name]

## Opening (2 min)

> "Selamat pagi, Bapak/Ibu. Terima kasih atas waktu Anda.
>
> Saya di sini untuk mempresentasikan hasil 18 bulan investasi perusahaan di infrastruktur shell. Namun, saya tidak akan berbicara tentang teknologi. Saya akan berbicara tentang **business impact**.
>
> Mari kita mulai dengan pertanyaan sederhana: **berapa nilai dari 5 menit?**
>
> Bagi developer, 5 menit adalah waktu setup. Bagi perusahaan, 5 menit × 120 developer × 250 hari = 25,000 jam per tahun. **Itu adalah nilai dari 5 menit.**"

## The Challenge (3 min)

> "Februari 2025. Perusahaan memiliki 30 developer. Setiap orang punya setup berbeda. Onboarding butuh 3 hari. Ada 2 insiden keamanan di tahun 2024. Compliance: tidak siap.
>
> Biaya tersembunyi: ~$500K per tahun dalam produktivitas yang hilang, ditambah risiko."

**[Show slide: The Challenge]**

## Our Approach (5 min)

> "Kami mengambil pendekatan tiga pilar:
>
> **Pertama, standardize.** Kami bangun konfigurasi modular yang bisa di-deploy otomatis. Bukan 30 setup berbeda, tapi 1 setup standar.
>
> **Kedua, secure.** Kami implementasi policy as code, secret management, dan audit trail. Security bukan fitur — ini fondasi.
>
> **Ketiga, enable.** Kami bangun CLI tool internal yang mengotomasi 80% task DevOps. Dari yang butuh 30 menit, jadi 30 detik."

**[Show slide: Our Approach]**

## Investment (2 min)

> "Total investasi: $102,000 selama 18 bulan. Tim: 3 engineers. Ini adalah investasi, bukan cost."

**[Show slide: Investment]**

## Results (10 min)

> "Sekarang, hasil."

**[Slide 1: Performance]**
> "Startup time: dari 800ms ke 95ms. 8x lebih cepat. Untuk 120 developer, ini adalah 292 jam per tahun yang dihemat. Nilai: $58K per tahun."

**[Slide 2: Onboarding]**
> "Onboarding: dari 3 hari ke 5 menit. Untuk 40 new hires per tahun: 956 jam dihemat. Nilai: $191K per tahun."

**[Slide 3: Security]**
> "Security incidents: dari 2 per tahun ke 0. Secrets in config: dari 15 ke 0. Compliance: SOC 2 certified. Nilai: $300K dalam avoided incidents, ditambah $2M+ dalam enabled deals."

**[Slide 4: Productivity]**
> "CLI tool adoption: 85%. Weekly commands: 50,000. Time saved: 600 jam per bulan. Nilai: $1.4M per tahun."

**[Slide 5: Developer Satisfaction]**
> "Survey: satisfaction dari 40% ke 92%. Setup speed dari 25% ke 88%. Ini berdampak pada retention. Nilai: $1.6M per tahun."

**[Slide 6: Open Source]**
> "Kami contribute 12 patches ke Zsh core. 8 merged. 2 plugins dengan 450+ stars. 5 blog posts. 2 conference talks. Ini adalah brand building. Nilai: $100K+ per tahun."

**[Slide 7: Total ROI]**
> "Total ROI: 5,400%. Payback: 2 weeks."

## Business Impact Summary (3 min)

> "Mari kita ringkas.
>
> **Before:** lambat, inconsistent, insecure, non-compliant, no tooling.
>
> **After:** 8x faster, 5-minute onboarding, zero incidents, SOC 2 certified, 85% adoption."

**[Show slide: Business Impact Summary]**

## Roadmap (3 min)

> "Apa selanjutnya? Kami punya roadmap 12 bulan.
>
> **Q1:** ISO 27001 certification, ShellCheck in CI, multi-region deployment.
>
> **Q2:** Backup testing automation, team self-service, metrics v2.
>
> **Q3:** Extend to CI/CD, container-based dev environments.
>
> **Q4:** ML-based anomaly detection, extend to 200 developers."

**[Show slide: Roadmap]**

## Recommendation (2 min)

> "Rekomendasi kami:
>
> **Continue investment.** $50K per tahun untuk tooling dan training. 1 FTE dedicated.
>
> **Expected return:** $5.5M per tahun. 100x ROI.
>
> **Ini bukan cost center — ini competitive advantage.**"

## Closing (1 min)

> "Terima kasih. Saya siap untuk pertanyaan."

## Q&A Preparation

### Anticipated Questions

**Q1: "Bagaimana Anda mengukur ROI?"**

> "Kami menggunakan tiga komponen: (1) time saved × hourly rate, (2) avoided costs (incidents, turnover), (3) enabled revenue (deals requiring compliance). Semua detail ada di slide appendix."

**Q2: "Apa risiko utama?"**

> "Tiga risiko utama: (1) key person dependency — mitigated by documentation dan handover; (2) security breach — mitigated by policy as code dan zero secrets in config; (3) scaling issues — mitigated by modular architecture. Semua ini sudah di-address."

**Q3: "Apakah ini scalable ke 500 developer?"**

> "Ya. Arsitektur kami modular dan automated. Deploy ke 120 host saat ini dalam 30 menit. Untuk 500 host, ~2 jam dengan parallel execution. Arsitektur yang sama, hanya perlu tambah host di inventory."

**Q4: "Apa yang tidak berhasil?"**

> "Tiga hal: (1) big bang migration ke Antidote — seharusnya gradual; (2) over-engineering metrics — seharusnya start simple; (3) custom prompt — seharusnya pakai Powerlevel10k. Semua ini documented di lessons-learned."

**Q5: "Berapa biaya maintain?"**

> "$50K per tahun: $30K tooling, $20K training. 1 FTE dedicated. Total cost of ownership: ~$200K per tahun, tapi return $5.5M. ROI tetap >2,500%."

**Q6: "Bagaimana jika developer tidak mau pakai?"**

> "Voluntary. Kami tidak mandate. Tapi adoption 85% menunjukkan bahwa developer memilih untuk pakai. Yang tidak pakai tetap punya akses ke CLI tool dan security policy."

**Q7: "Apa competitor comparison?"**

> "Industri benchmark: startup time rata-rata 200-300ms. Kami 95ms. Open source contribution: kebanyakan perusahaan tidak contribute. Kami 12 patches. Ini adalah competitive advantage."

**Q8: "Bagaimana Anda hire untuk ini?"**

> "Kami hire untuk: (1) curiosity — mau belajar hal baru; (2) communication — bisa menjelaskan ke non-technical; (3) ownership — mau ambil tanggung jawab. Skills bisa diajarkan, mindset tidak."

### Difficult Questions

**Q: "Mengapa ini butuh 18 bulan?"**

> "Karena ini adalah investasi foundational, bukan quick fix. Setup bisa dalam 1 bulan, tapi: security, compliance, dan reliability membutuhkan waktu. Kami tidak ingin build sesuatu yang harus di-refactor 6 bulan kemudian."

**Q: "Mengapa 3 engineers?"**

> "1 engineer untuk build, 1 untuk testing, 1 untuk documentation. Parallel work. Hasilnya: faster delivery, better quality. Alternatifnya: 1 engineer × 18 bulan = tidak feasible."

**Q: "Apakah ini bisa dilakukan lebih cepat?"**

> "Bisa, tapi ada trade-off. Fast track: kurangi documentation, testing, compliance work. Hasilnya: faster delivery, tapi higher risk. Kami memilih sustainable pace."

**Q: "Apa jika Anda pergi?"**

> "Saya sudah prepare handover document. Penerus bisa langsung lanjut. Ini adalah prinsip: no key person dependency. Documentation adalah asuransi kami."

**Q: "Berapa payback period?"**

> "2 bulan. Investment $102K, annual return $5.5M. Bahkan jika kita hanya hitung satu kategori (productivity = $1.4M), payback tetap <1 bulan."

### Answer Framework

Setiap jawaban mengikuti struktur:

1. **Direct answer** — jawab pertanyaan langsung
2. **Supporting data** — berikan data
3. **Story** — berikan contoh konkret
4. **Transition** — pindah ke topik berikutnya

### Body Language

- **Eye contact** — 3 detik per board member
- **Pause** — setelah setiap poin
- **Gesture** — untuk emphasis
- **Voice** — varied, project
- **Pace** — slow down, don't rush

### If Stuck

> "Pertanyaan bagus. Saya tidak punya data exact saat ini, tapi saya akan follow up dengan detail dalam 24 jam."

Jangan pernah bluff. **Honesty > bluff.**

## Post-Presentation

- [ ] Send slides + recording within 24 hours
- [ ] Follow up on questions within 48 hours
- [ ] Schedule deep dive if requested
- [ ] Collect feedback
- [ ] Update presentation for next time

---

*Last updated: 2026-10-12*
```

**Penjelasan Mental — Presentasi yang Mengubah:**

**Tiga Tujuan Presentasi:**

1. **Inform** — berikan data
2. **Persuade** — ubah persepsi
3. **Inspire** — ciptakan visi

**Formula Presentasi:**

```
Hook (10%) → Story (30%) → Data (40%) → Call (20%)
```

- **Hook:** "Berapa nilai dari 5 menit?"
- **Story:** Journey 18 bulan
- **Data:** Metrics + ROI
- **Call:** Continue investment

**Mengapa "5 menit" Hook Powerful:**

Karena:
- **Simple** — semua orang tahu 5 menit
- **Unexpected** — 5 menit × 120 × 250 = 25,000 jam
- **Concrete** — angka specific
- **Story** — developer setup experience
- **Credible** — verifiable

**Struktur Data Presentasi:**

1. **Before/After** — visual contrast
2. **Trend** — chart over time
3. **ROI** — bottom line

**Mengapa Honesty Lebih Baik dari Over-promise:**

1. **Trust** — board lebih percaya
2. **Credibility** — tidak dianggap sales pitch
3. **Realistic** — tidak over-promise
4. **Sustainable** — tidak burnout

**Practice Makes Perfect:**

- **Day 1:** Run 3x, record self
- **Day 2:** Run with timer, aim 30 min
- **Day 3:** Run with colleague
- **Day 4:** Run with backup scenarios
- **Day 5:** Final run 30 min before

**Q&A Prep:**

Untuk setiap pertanyaan, siapkan:
- **Direct answer** — 1 sentence
- **Data** — 1-2 data points
- **Story** — 1 example
- **Transition** — next topic

---

## 7. Rekomendasi Visualisasi

> **🔍 Visualisasi Sangat Membantu di Sini:**
>
> 1. **Diagram Arsitektur Portfolio** — Empat kuadran: Handover (technical), Presentation (business), Metrics (data), Reflection (personal). Tandai interkoneksi.
>
> 2. **Timeline 18 Bulan** — Horizontal timeline dengan milestones, achievement, dan pelajaran. Tandai "high point" dan "low point".
>
> 3. **Skill Radar** — Radar chart dengan 8 skill, before vs after. Visual gap analysis.
>
> 4. **Career Path** — Flowchart: Senior → Staff → VP → CTO/Founder. Tandai posisi saat ini dan target.
>
> 5. **Peta Portfolio** — Diagram yang menunjukkan koneksi antara: handover doc, presentation, metrics, roadmap, open source, reflection. Tandai "hub" (presentation).
>
> 6. **Executive Dashboard** — Layout 4 kuadran: Metrics (kiri atas), Timeline (kanan atas), ROI (kiri bawah), Roadmap (kanan bawah). Untuk board.

---

## 8. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **7.1 (Fondasi)** | Reflection mencakup skill dari fondasi |
| **7.2 (Scripting)** | Handover mencakup script yang dibangun |
| **7.3 (Konfigurasi)** | Arsitektur adalah konfigurasi yang di-scale |
| **7.4 (Performa)** | Metrics adalah bukti dari optimasi |
| **7.5 (CLI Tool)** | `nt` adalah showcase utama |
| **7.6 (Enterprise)** | Handover adalah hasil dari enterprise work |
| **Fase 1-6 (Kurikulum)** | Sintesis dari SEMUA fase |

---

## 9. Sumber Referensi Lengkap

- **"Made to Stick" (Chip & Dan Heath)** — untuk komunikasi
- **"Good Strategy/Bad Strategy" (Richard Rumelt)** — untuk strategic thinking
- **"The Effective Executive" (Peter Drucker)** — untuk manajemen
- **"Thinking, Fast and Slow" (Daniel Kahneman)** — untuk decision making
- **"The Manager's Path" (Camille Fournier)** — untuk career
- **"An Elegant Puzzle" (Will Larson)** — untuk engineering management
- **Marp (Markdown to Slides)** — https://marp.app/
- **Pandoc** — https://pandoc.org/
- **Excalidraw** — https://excalidraw.com/
- **Asciinema** — https://asciinema.org/
- **agg (Asciinema to GIF)** — https://github.com/asciinema/agg
- **Reveal.js** — https://revealjs.com/

---

## 10. Tips dan Praktik Terbaik

1. **Start with "why".** Mengapa ini penting?
2. **Show, don't tell.** Demo > slide.
3. **Business language.** $ bukan ms.
4. **One idea per slide.** Jangan campur.
5. **Visual > text.** Chart > table.
6. **Repeat key messages.** 3x minimum.
7. **Practice out loud.** 5x minimum.
8. **Backup plan.** Video recording.
9. **Prepare for Q&A.** Anticipate questions.
10. **Honest caveats.** Acknowledge limitations.
11. **Story over data.** Data penting, story lebih.
12. **Pause after key points.** Untuk emphasis.
13. **Eye contact.** 3 detik per orang.
14. **Follow up.** Within 24 hours.
15. **Reflect after.** Apa yang berhasil, tidak.

---

## 11. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Terlalu teknis | Board bingung | Business language |
| Terlalu panjang | Kehilangan attention | 30 min max |
| Tidak ada demo | Kurang meyakinkan | Live demo |
| Tidak ada backup | Demo gagal = disaster | Video recording |
| Over-promise | Kehilangan trust | Realistic targets |
| Tidak ada metrics | Tidak credible | Kumpulkan data |
| Bluff saat Q&A | Kehilangan credibility | Honest "I'll follow up" |
| Tidak practice | Nervous, error | 5x practice |
| Tidak follow up | Lose momentum | 24-hour rule |
| Tidak reflect | Miss learning | Post-presentation review |

---

## 12. Refleksi Mental Programming & Verifikasi

### Refleksi Mental Programming

Setelah menyelesaikan Modul 7.7, Anda seharusnya mencapai **level Expert** dengan mental model:

1. **Portfolio as Time Capsule.** Menangkap perjalanan Anda.
2. **Show, Don't Tell.** Bukti lebih kuat dari klaim.
3. **Business Language.** Komunikasi dengan impact.
4. **Documentation as Legacy.** Warisan yang hidup.
5. **Metrics Tell Stories.** Data + konteks = insight.
6. **Gradual > Big Bang.** Untuk perubahan signifikan.
7. **Give Back.** Open source = responsibility.
8. **Reflection is Growth.** Belajar dari pengalaman.
9. **Practice Makes Perfect.** Untuk presentasi.
10. **Honesty > Bluff.** Trust lebih penting.
11. **Communication is 50%.** Technical skill adalah table stakes.
12. **People > Process > Tools.** Yang paling penting adalah orang.

**Pertanyaan reflektif untuk diri sendiri:**
- Bisakah saya membuat handover document yang self-contained?
- Bisakah saya mengonversi technical metrics ke business language?
- Bisakah saya presentasi ke board dengan confidence?
- Bisakah saya reflect dengan jujur tentang perjalanan?
- Apakah portfolio saya menjawab "apa", "mengapa", "bagaimana"?

Jika jawabannya "ya", **selamat** — Anda telah mencapai level Expert.

### Checklist Verifikasi

Sebelum menyelesaikan program, pastikan Anda dapat:

- [ ] Membuat handover document yang self-contained
- [ ] Menyusun metrics dengan business impact
- [ ] Menghitung ROI
- [ ] Membuat slide deck untuk non-technical audience
- [ ] Melakukan demo live dengan backup plan
- [ ] Membuat roadmap 12 bulan yang realistic
- [ ] Melaporkan open source contribution dengan value
- [ ] Menulis personal reflection yang honest
- [ ] Mempresentasikan portfolio dengan confidence
- [ ] Menangani Q&A dengan berbagai pertanyaan sulit
- [ ] Follow up setelah presentasi

---

## ✅ MODUL 7.7 SELESAI — FASE 7 SELESAI

**Ringkasan Fase 7 (Semua Modul):**

| Modul | Topik | Fase Kurikulum |
|---|---|---|
| 7.1 | Onboarding Developer Baru | Fase 1 (Fondasi) |
| 7.2 | Otomatisasi Backup & Log Rotation | Fase 2 (Scripting) |
| 7.3 | Konfigurasi Tim Skalabel | Fase 3 (Konfigurasi) |
| 7.4 | Audit & Optimasi Lingkungan | Fase 4 (Performa & Keamanan) |
| 7.5 | CLI Tool dengan Test Suite | Fase 5 (Testing & Integrasi) |
| 7.6 | Arsitektur Enterprise & Kontribusi | Fase 6 (Expert) |
| **7.7** | **Capstone — Portfolio & Presentasi** | **Sintesis Semua Fase** |

---

## 🎓 PROGRAM SELESAI

**Anda telah menyelesaikan:**

- ✅ Fase 1: Fondasi Shell
- ✅ Fase 2: Scripting Dasar
- ✅ Fase 3: Globbing, Completion, Konfigurasi
- ✅ Fase 4: Ekosistem, Performa, Keamanan
- ✅ Fase 5: Scripting Lanjutan & Testing
- ✅ Fase 6: Expert — Arsitektur, Kontribusi, Spesialisasi
- ✅ **Fase 7: Praktik Nyata & Mental Programming (Capstone)**

**Total waktu:** ~6-9 bulan (santai) atau ~3-4 bulan (intensif)

---

## Apa Selanjutnya?

### Untuk Karir

1. **Portfolio** — publish di GitHub
2. **Blog** — tulis tentang perjalanan
3. **Conference** — present di meetup
4. **Open Source** — continue contribution
5. **Mentor** — bantu yang baru mulai

### Untuk Skill

1. **Bahasa lain** — Python, Go, Rust
2. **Domain lain** — Cloud, DevOps, ML
3. **Soft skills** — Leadership, Communication
4. **Specialization** — Pilih 1-2 track

### Untuk Community

1. **Local meetup** — organize atau attend
2. **Online community** — Reddit, Discord
3. **Mentoring** — 1-on-1
4. **Speaking** — conference, podcast

---

## Kata Penutup

**Selamat!** Anda telah menyelesaikan perjalanan dari **pemula** menjadi **expert** dalam Zsh dan shell scripting.

Perjalanan ini bukan tentang menghafal sintaks — ini tentang **mengembangkan cara berpikir**:
- **Sistematis** — memecah masalah kompleks
- **Detail** — memperhatikan edge case
- **Praktis** — fokus pada solusi, bukan teori
- **Berkelanjutan** — membangun untuk jangka panjang
- **Kolaboratif** — berbagi dengan komunitas

Anda sekarang bukan hanya "orang yang bisa pakai Zsh" — Anda adalah **shell engineer** yang bisa:
- Merancang arsitektur untuk 1000 developer
- Membangun CLI tool production-grade
- Berkontribusi ke open source
- Mempresentasikan ke board of directors
- Mentor developer berikutnya

**Ini bukan akhir — ini awal.**

Selamat berkarya. **Keep learning, keep giving back.**

---

*"The best way to learn is to teach. The best way to grow is to give."*

— [Your Name], 2026

---

**Program Pembelajaran Zsh & Shell Scripting**
**Fase 1-7 | Pemula hingga Expert | 6-9 Bulan**

> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

