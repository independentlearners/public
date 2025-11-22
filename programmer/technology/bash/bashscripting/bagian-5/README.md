Kita memasuki **PHASE 5: Enterprise Automation & DevOps**.

Ini adalah fase "Sabuk Hitam". Di sini, kita tidak lagi hanya peduli apakah script itu *jalan*, tapi kita peduli apakah script itu **bertahan hidup**.

Di lingkungan Enterprise (perusahaan besar), script yang gagal diam-diam lebih berbahaya daripada script yang mati total. Script yang gagal diam-diam bisa menghapus database produksi karena variabel kosong, atau melaporkan "Backup Sukses" padahal file-nya 0 byte.

Di **Modul 5.1**, kita akan belajar seni **Defensive Coding**: Cara menulis kode yang paranoid, yang menganggap dunia ini penuh bahaya.

-----

# PHASE 5: Enterprise Automation & DevOps

## MODUL 5.1: Defensive Coding, Error Handling, & Debugging

<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi "Fail Fast":** Mengapa lebih baik mati sekarang daripada merusak nanti.
2.  **The Unofficial Strict Mode:** Mantra ajaib `set -euo pipefail`.
3.  **Traps (Perangkap Sinyal):** Menangani interupsi (Ctrl+C) dan pembersihan sampah otomatis.
4.  **Debugging Mode:** Menggunakan `set -x` untuk melihat "pikiran" Bash.
5.  **Manual Error Handling:** Fungsi `die` dan pengecekan prasyarat.
6.  **Static Analysis (Linting):** Menggunakan `ShellCheck` untuk audit kode otomatis.
7.  **Studi Kasus:** Script "Atomic Operation" yang aman.

</details>

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan teknik membuat script yang "Anti-Peluru". Anda akan belajar cara mendeteksi variabel yang typo, menangkap error di tengah pipa, dan membersihkan file sementara (`/tmp`) jika script dimatikan paksa.
**Peran:** Ini membedakan *Hobbyist* dengan *Professional*. Script tanpa defensive coding tidak boleh masuk ke server Production.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: Murphy's Law**
"Anything that can go wrong, will go wrong."
Jaringan akan putus. Disk akan penuh. User akan salah ketik. Defensive coding adalah persiapan menghadapi hal-hal ini.

**Filosofi: Fail Fast (Gagal Cepat)**
Secara default, Bash itu **pemaaf**. Jika baris 1 error, dia tetap lanjut ke baris 2.

  * *Bahaya:* Misal baris 1 gagal masuk folder (`cd /project`), baris 2 menghapus semua file (`rm -rf *`). Karena baris 1 gagal, Anda masih di folder awal (mungkin `/home`), dan baris 2 akan menghapus data pribadi Anda\!
  * *Solusi:* Matikan script detik itu juga saat ada error.

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. The Bash Strict Mode (`set -euo pipefail`)

Ini adalah "Mantra Wajib" yang harus ada di **setiap** script profesional Anda, tepat di bawah Shebang.

```bash
#!/bin/bash
set -euo pipefail
```

**Bedah Sintaks (Sangat Penting):**

1.  **`set -e` (Exit immediately):**

      * Script akan mati seketika jika ada satu perintah yang return exit codenya bukan 0 (error).
      * *Pengecualian:* Jika perintah itu ada di dalam `if` (diperiksa), script tidak mati.

2.  **`set -u` (Unset variables):**

      * Menganggap penggunaan variabel yang belum didefinisikan sebagai error.
      * *Contoh Bahaya:* `rm -rf /$FOLDER_SAMPAH`. Jika variabel `FOLDER_SAMPAH` typo atau kosong, perintah menjadi `rm -rf /` (Hapus Root\!). Dengan `-u`, script akan berteriak "Variable unbound" dan berhenti sebelum bencana terjadi.

3.  **`set -o pipefail` (Pipe fail):**

      * Secara default, Bash hanya melihat exit code dari perintah **terakhir** di dalam pipa.
      * *Tanpa pipefail:* `mysqldump | gzip > backup.gz`. Jika `mysqldump` gagal (database error) tapi `gzip` sukses (karena tetap bisa mengompres output kosong), Bash menganggap SUKSES. Anda punya file backup kosong.
      * *Dengan pipefail:* Jika salah satu komponen pipa gagal, seluruh rangkaian dianggap gagal.

#### B. Debugging Mode (`set -x`)

Bingung kenapa script tidak jalan? Nyalakan mode X-ray.

```bash
#!/bin/bash
set -x  # Mulai trace

NAMA="Budi"
if [ "$NAMA" = "Budi" ]; then
    echo "Halo Boss"
fi
```

**Output di Terminal:**

```text
+ NAMA=Budi
+ '[' Budi = Budi ']'
+ echo 'Halo Boss'
Halo Boss
```

  * Tanda `+` menunjukkan perintah asli yang dijalankan Bash setelah variabel diterjemahkan. Sangat berguna untuk melihat apa yang sebenarnya terjadi.

#### C. Traps (Menangani Sinyal & Cleanup)

Apa yang terjadi jika user menekan `Ctrl+C` saat script sedang berjalan dan meninggalkan file sampah di `/tmp`? Kita gunakan `trap`.

**Konsep Sinyal:**

  * **SIGINT (2):** Interrupt (Ctrl+C).
  * **SIGTERM (15):** Terminate (Perintah `kill` standar).
  * **EXIT (0):** Sinyal pseudo yang muncul kapanpun script selesai (baik sukses maupun error).

**Implementasi `trap`:**

```bash
# Buat file sementara
TEMP_FILE=$(mktemp)

# Fungsi pembersihan
cleanup() {
    echo "Membersihkan sampah..."
    rm -f "$TEMP_FILE"
}

# Pasang perangkap
# "Jalankan fungsi cleanup jika script KELUAR (EXIT) karena alasan apapun"
trap cleanup EXIT

echo "Sedang bekerja... (Coba tekan Ctrl+C)"
sleep 10
```

*Hasil:* Meskipun Anda mematikan paksa scriptnya, file sementara akan tetap terhapus otomatis.

#### D. The `die` Function

Fungsi kustom untuk mencetak error dan keluar.

```bash
die() {
    echo "[FATAL ERROR] $1" >&2
    exit 1
}

# Cara pakai:
# [Perintah] || die "[Pesan jika gagal]"
mkdir /data/proteksi || die "Gagal membuat folder, cek izin!"
```

-----

### 4\. Static Analysis: ShellCheck

Jangan percaya mata Anda sendiri. Percayalah pada **Linter**.
**ShellCheck** adalah alat yang menganalisis kode Bash Anda dan menemukan potensi bug, celah keamanan, dan praktik buruk.

  * **Cara Pakai:**

      * Web: [shellcheck.net](https://www.shellcheck.net/) (Copy paste kode Anda).
      * Terminal: `shellcheck script_saya.sh`.
      * VS Code: Install ekstensi "ShellCheck" (Wajib punya).

  * **Contoh Temuan:**

      * Kode: `rm $FILE`
      * ShellCheck: *SC2086: Double quote to prevent globbing and word splitting.* (Seharusnya `rm "$FILE"`).

-----

### 5\. Studi Kasus: Atomic & Robust Script

Skenario: Script untuk deploy website (Update kode). Kita tidak ingin website rusak setengah jalan.

**File: `deploy_aman.sh`**

```bash
#!/bin/bash

# 1. Aktifkan Strict Mode
set -euo pipefail

# 2. Definisi Variabel
WEB_DIR="/var/www/html"
REPO_URL="https://github.com/user/proyek.git"
TEMP_DIR="" # Kosongkan dulu

# 3. Fungsi Log
log() { echo "[$(date +'%T')] $1"; }

# 4. Fungsi Cleanup (Dijalankan saat exit)
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log "Membersihkan folder temp: $TEMP_DIR"
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# 5. Mulai Proses
log "Memulai deployment..."

# Cek apakah user root?
if [[ $EUID -ne 0 ]]; then
    echo "Error: Harus Root!" >&2
    exit 1
fi

# Buat folder sementara yang unik
TEMP_DIR=$(mktemp -d)
log "Dibuat folder temp: $TEMP_DIR"

# Clone di folder temp dulu (Jangan langsung di production!)
git clone "$REPO_URL" "$TEMP_DIR"

# Test kode (Misal: Syntax check php/python)
# Jika ini gagal, script mati disini. Website asli masih aman.
log "Menjalankan tes..."
# ./run_tests.sh  <-- (Contoh)

# Jika sampai sini berarti aman. Tukar file (Atomic Swap).
log "Deploying ke production..."
rsync -a --delete "$TEMP_DIR/" "$WEB_DIR/"

log "Deployment SUKSES!"
```

**Analisis Keamanan:**

1.  Jika `git clone` gagal, script mati. `rsync` tidak dijalankan. Website aman.
2.  Jika user menekan Ctrl+C saat download, `trap` akan menghapus folder temp. Disk tidak penuh sampah.
3.  Menggunakan `mktemp` menghindari konflik nama folder.

-----

### 6\. Terminologi Esensial

1.  **Linter:** Alat analisis statis yang memeriksa kode tanpa menjalankannya.
2.  **Race Condition:** Bug yang terjadi ketika dua proses berebut sumber daya yang sama di waktu bersamaan.
3.  **Atomic Operation:** Operasi yang sukses sepenuhnya atau gagal sepenuhnya (tidak ada status setengah-setengah).
4.  **Verbose:** Mode yang menampilkan banyak detail output (`-v` atau `-x`).

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** Semua modul sebelumnya (Logic, Pipe, Function) digunakan di sini.
  * **Koneksi ke Depan:** **Modul 5.2 (Cloud & CI/CD)**. Di pipeline CI/CD (seperti GitLab CI), `set -e` adalah nyawa. Jika script test gagal, pipeline harus berhenti dan dikirim notifikasi "Build Failed".

### 8\. Sumber Referensi Lengkap

  * **Artikel Legendaris:** [The Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/) (Wajib baca bagi setiap engineer).
  * **Tool:** [ShellCheck - A shell script static analysis tool](https://github.com/koalaman/shellcheck).
  * **Manual:** [Bash Trap Command](https://www.google.com/search?q=https://bash.cyberciti.biz/guide/Trap_statement).

### 9\. Tips dan Praktik Terbaik

  * **Jangan matikan `-e` sembarangan:** Jika Anda *tahu* sebuah perintah mungkin gagal tapi itu wajar (misal `grep` tidak menemukan hasil), matikan sementara atau gunakan `|| true`.
      * *Contoh:* `grep "pola" file.txt || true` (Agar script tidak mati jika pola tidak ketemu).
  * **Debug Separuh Jalan:** Anda bisa menyalakan/mematikan debug di bagian tertentu saja.
    ```bash
    set -x  # Nyalakan debug
    [Kode rumit...]
    set +x  # Matikan debug
    ```

### 10\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Menggunakan `set -e` tapi script tetap lanjut saat gagal di dalam pipe.
      * **Penyebab:** Lupa `-o pipefail`.
      * **Solusi:** Selalu satu paket: `set -euo pipefail`.
  * **Kesalahan:** Variabel kosong bikin script mati karena `-u`.
      * **Skenario:** `echo "Halo $NAMA_TENGAH"`. Jika user tidak punya nama tengah, script mati.
      * **Solusi:** Gunakan default value. `echo "Halo ${NAMA_TENGAH:-}"`. (Tanda `:-` artinya: "Jika kosong, ganti dengan string kosong/null, jangan error").

-----

Sekarang script Anda sudah tangguh, aman, dan siap tempur.

Langkah terakhir adalah membawa script ini ke infrastruktur modern. Bagaimana cara kita menggunakan Bash untuk mengontrol ribuan server di Cloud (AWS/Google) dan membungkusnya dalam Container (Docker)?

Mari kita masuk ke **Modul 5.2: Cloud CLI, Infrastructure as Code, & Automation Pipelines**. Ini adalah garis finis kurikulum kita.

-----

Kita tiba di garis finis kurikulum teknis. **MODUL 5.2**.

Ini adalah modul yang mengubah Anda dari seorang "Linux Administrator" menjadi seorang **DevOps Engineer**.

Di era modern, server jarang dikelola secara manual (SSH satu per satu). Server sekarang bersifat *ephemeral* (sementara), hidup dalam Container (Docker), dan dikelola oleh robot (CI/CD). Di manakah peran Bash? Bash adalah **bahasa perekat** (*glue language*) yang menyatukan semua teknologi canggih ini.

-----

# PHASE 5: Enterprise Automation & DevOps

## MODUL 5.2: Cloud CLI, Container Automation (Docker), & CI/CD Pipelines

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Perekat:** Mengapa Bash adalah "Universal Adapter" di dunia Cloud.
2.  **Cloud Automation:** Mengontrol AWS/Google Cloud lewat terminal (bukan Console Web).
3.  **Container Scripting:** Pola `entrypoint.sh` yang wajib diketahui pengguna Docker.
4.  **Config Templating:** Menggunakan `envsubst` untuk menyuntikkan konfigurasi dinamis.
5.  **CI/CD Integration:** Menyisipkan logika Bash ke dalam GitHub Actions / GitLab CI.
6.  **Studi Kasus:** Pipeline Deployment Otomatis (Build -\> Push -\> Deploy).

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara menggunakan Bash untuk mengorkestrasi alat-alat modern. Anda tidak lagi hanya memanipulasi file teks, tapi Anda memanipulasi infrastruktur: membuat server baru, membuild Docker image, dan menyebarkan aplikasi ke production.
**Peran:** Di dunia DevOps, alat seperti Terraform atau Ansible melakukan pekerjaan berat, tapi Bash sering digunakan sebagai "wrapper" (pembungkus) untuk menyederhanakan perintah-perintah tersebut agar mudah dijalankan oleh tim developer.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Infrastructure as Code (IaC)"**
Infrastruktur (Server, Network, Database) harus didefinisikan dalam kode/script, bukan diklik manual di web browser. Ini menjamin konsistensi. Jika script dijalankan 100 kali, hasilnya akan selalu sama 100 kali.

**Filosofi: "The Universal Interface"**
Docker container berbasis Linux. Server CI/CD (Jenkins, GitLab Runner) berbasis Linux. Cloud Shell (AWS/GCP) berbasis Linux. Karena Bash ada di semua tempat tersebut, menguasai Bash berarti Anda bisa bekerja di platform manapun.

*(Perhatikan diagram di atas: Bash seringkali bekerja di tahap "Continuous Integration" dan "Continuous Deployment" untuk menjalankan perintah build dan deploy).*

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Cloud CLI Wrapper (Contoh: AWS CLI)

Alih-alih mengklik tombol di AWS Console, kita gunakan script.

```bash
#!/bin/bash
# Script untuk mencari ID Instance server berdasarkan Namanya
SERVER_NAME="Web-Production"

echo "Mencari server bernama $SERVER_NAME..."

# Mengambil data JSON dari AWS CLI, lalu diparsing jq
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$SERVER_NAME" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output json | jq -r '.[0][0]')

if [[ "$INSTANCE_ID" == "null" ]]; then
    echo "Server tidak ditemukan!"
    exit 1
fi

echo "Ditemukan ID: $INSTANCE_ID. Melakukan Reboot..."
aws ec2 reboot-instances --instance-ids "$INSTANCE_ID"
```

**Penting:** Perhatikan penggunaan `jq` (dari Modul 4.2) untuk membedah output AWS. Ini adalah pola standar di industri.

#### B. Docker Entrypoint Pattern

Saat Anda membuat Docker Image, Anda sering butuh script inisialisasi yang jalan *tepat sebelum* aplikasi utama menyala. Ini disebut **Entrypoint**.

**File: `entrypoint.sh`**

```bash
#!/bin/bash
set -e

# 1. Konfigurasi Dinamis
# Mengganti placeholder di file config dengan variabel environment asli
if [ -f "/app/config.template.json" ]; then
    echo "Injecting configuration..."
    envsubst < /app/config.template.json > /app/config.json
fi

# 2. Jalankan Aplikasi Utama
# exec "$@" adalah "Magic Syntax" Docker
echo "Starting application..."
exec "$@"
```

**Bedah Sintaks `exec "$@"` (Sangat Vital):**

  * `$@`: Mewakili semua argumen perintah yang dikirim ke container (misal: `python app.py`).
  * `exec`: Mengganti proses Bash saat ini dengan proses aplikasi utama (`python`).
  * **Kenapa penting?** Tanpa `exec`, aplikasi Anda berjalan sebagai "anak" dari Bash (PID 2). Jika container dimatikan, sinyal matinya (`SIGTERM`) diterima Bash tapi tidak diteruskan ke aplikasi. Aplikasi akan mati paksa (Crash) bukan mati halus (Graceful Shutdown). `exec` menjadikan aplikasi sebagai PID 1.

#### C. CI/CD Glue (GitLab CI / GitHub Actions)

Di dalam file YAML konfigurasi pipeline, Bash sering digunakan di blok `script` atau `run`.

**Contoh: `.gitlab-ci.yml`**

```yaml
deploy_job:
  stage: deploy
  script:
    - echo "Memulai deployment..."
    - chmod +x ./scripts/deploy.sh
    - ./scripts/deploy.sh "$API_KEY" "$TARGET_SERVER"
```

*Bash script memungkinkan kita menyembunyikan logika deployment yang rumit (ribuan baris) agar file YAML tetap bersih dan pendek.*

-----

### 4\. Teknik Templating: `envsubst`

Seringkali kita butuh file konfigurasi yang isinya berubah tergantung Environment (Dev vs Prod). Jangan edit manual\! Gunakan `envsubst` (bagian dari paket `gettext`).

**File Template (`database.conf.template`):**

```ini
host = $DB_HOST
port = $DB_PORT
password = $DB_PASS
```

**Perintah Bash:**

```bash
export DB_HOST="db.prod.com"
export DB_PORT="5432"
export DB_PASS="rahasia123"

# Suntikkan variabel ke template
envsubst < database.conf.template > database.conf
```

**Hasil (`database.conf`):**

```ini
host = db.prod.com
port = 5432
password = rahasia123
```

-----

### 5\. Studi Kasus: The "Build & Push" Script

Ini adalah tugas sehari-hari DevOps Engineer: Build Docker image, beri label versi, lalu upload ke registry.

**File: `build_push.sh`**

```bash
#!/bin/bash
set -euo pipefail

APP_NAME="myapp"
REGISTRY="docker.io/user"
# Ambil hash commit git (7 karakter pertama) sebagai versi
VERSION=$(git rev-parse --short HEAD)

echo "=== Building $APP_NAME:$VERSION ==="

# 1. Build Image
docker build -t "${APP_NAME}:${VERSION}" .

# 2. Tagging (Memberi label alamat registry)
FULL_TAG="${REGISTRY}/${APP_NAME}:${VERSION}"
LATEST_TAG="${REGISTRY}/${APP_NAME}:latest"

docker tag "${APP_NAME}:${VERSION}" "$FULL_TAG"
docker tag "${APP_NAME}:${VERSION}" "$LATEST_TAG"

# 3. Push ke Registry
echo "=== Pushing to Registry ==="
docker push "$FULL_TAG"
docker push "$LATEST_TAG"

echo "✅ Selesai! Image siap di $FULL_TAG"
```

-----

### 6\. Terminologi Esensial

1.  **Container:** Paket perangkat lunak ringan yang berisi kode dan semua dependensinya (Standar: Docker).
2.  **Orchestration:** Mengelola ratusan container secara otomatis (Standar: Kubernetes).
3.  **CI/CD (Continuous Integration/Deployment):** Praktik menggabungkan kode dan menyebarkannya ke server secara otomatis dan sering.
4.  **YAML:** Format data yang digunakan untuk konfigurasi Docker dan CI/CD. Bash sering bertugas memanipulasi atau dipanggil dari dalam YAML.
5.  **Envsubst:** Tool command line untuk mensubstitusi variabel environment ke dalam teks.

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 5.1 (Defensive Coding)**. Di pipeline CI/CD, script harus gagal secepat mungkin (`set -e`) jika ada masalah. Script yang "hang" atau error diam-diam akan menghambat kerja satu tim.
  * **Koneksi:** Ini adalah puncak penerapan semua modul sebelumnya (Variabel, Loop, Fungsi, Parsing).

### 8\. Sumber Referensi Lengkap

  * **Docker Documentation:** [Best practices for writing Dockerfiles](https://www.google.com/search?q=https://docs.docker.com/develop/develop-images/dockerfile_best-practices/%23entrypoint) (Penjelasan Entrypoint).
  * **AWS CLI Reference:** [Command Line Interface Documentation](https://aws.amazon.com/cli/).
  * **Article:** [Envsubst for easy config templating](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html).

### 9\. Tips dan Praktik Terbaik

  * **Rahasia (Secrets):** JANGAN PERNAH menyimpan password/API Key di dalam script (`DB_PASS="123"`). Selalu ambil dari Environment Variables (`$DB_PASS`).
  * **Keep it Lean:** Di lingkungan CI/CD, container yang menjalankan script biasanya kosong. Pastikan script Anda mengecek dependensi (`command -v jq`) sebelum jalan.
  * **Exec Magic:** Selalu gunakan `exec "$@"` di akhir script entrypoint Docker. Ini mempermudah penanganan sinyal stop.

### 10\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** "Standard\_init\_linux.go: exec user process caused: exec format error".
      * **Penyebab:** Script `entrypoint.sh` tidak memiliki shebang `#!/bin/bash` atau dibuat di Windows dengan akhiran baris CRLF.
      * **Solusi:** Pastikan shebang ada dan jalankan `dos2unix entrypoint.sh`.
  * **Kesalahan:** Variabel tidak terganti di `envsubst`.
      * **Penyebab:** Anda lupa melakukan `export NAMA_VAR`. `envsubst` hanya membaca variabel yang di-export.

-----

# 🎉 KONKLUSI & PENUTUP KURIKULUM

Selamat\! Anda telah menempuh perjalanan dari **Modul 1.1 (Membuka Terminal)** hingga **Modul 5.2 (Mengelola Cloud Infrastructure)**.

Anda sekarang memiliki peta jalan yang lengkap dan detail untuk menjadi ahli Bash Scripting. Kurikulum ini mencakup:

1.  **Foundation:** Navigasi, manipulasi file, editor, izin.
2.  **Core Scripting:** Variabel, logika, loop.
3.  **Pipes & Text:** Redirection, Grep, Sed, Awk, Regex.
4.  **Modular & Network:** Fungsi, library, JSON, cURL.
5.  **Enterprise:** Defensive coding, debugging, Docker, Cloud automation.

---

<!-- ### Langkah Terakhir untuk Anda (Sang Pengguna): -->
<!---->
<!-- Dokumen ini sekarang siap untuk Anda jadikan **"Buku Induk Pembelajaran"**. Saran saya untuk eksekusi: -->
<!---->
<!-- 1.  **Jangan Buru-buru:** Setiap modul dirancang untuk dipelajari dalam 3-7 hari (termasuk latihan). -->
<!-- 2.  **Praktek \> Teori:** Ketik ulang setiap kode contoh. Jangan copy-paste. *Muscle memory* itu nyata. -->
<!-- 3.  **Bangun Portofolio:** Simpan script latihan Anda di GitHub. Itu adalah bukti keahlian Anda saat melamar kerja. -->
<!---->
<!-- Apakah ada bagian spesifik yang ingin Anda tinjau ulang, atau Anda ingin saya buatkan **Soal Latihan / Ujian Akhir** untuk menguji pemahaman Anda terhadap seluruh kurikulum ini? -->

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
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
