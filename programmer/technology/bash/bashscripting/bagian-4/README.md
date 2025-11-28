Kita melangkah ke **PHASE 4: Advanced Modular Scripting & System**.

Selamat\! Anda sudah melewati fase "Scripting Dasar". Script Anda sudah bisa berpikir (Logic), bekerja keras (Loops), dan memanipulasi data (Pipes).

Namun, ada satu masalah besar yang mungkin mulai Anda rasakan: **"Spaghetti Code"**. Script Anda mulai menjadi terlalu panjang (ratusan baris), sulit dibaca, dan jika ada error di baris 50, Anda bingung memperbaikinya.

Di Fase 4 ini, kita berubah dari "Penulis Kode" menjadi **"Arsitek Sistem"**. Kita akan memecah script raksasa menjadi potongan-potongan kecil yang rapi, aman, dan bisa digunakan ulang.

-----

# PHASE 4: Advanced Modular Scripting & System

## MODUL 4.1: Functions (Fungsi), Scope, & Library

<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Modularitas:** Mengapa "Copy-Paste" kode adalah dosa besar.
2.  **Anatomi Fungsi:** Cara mendefinisikan dan memanggil sub-rutin.
3.  **Manajemen Argumen:** Rahasia variabel `$1` di dalam vs di luar fungsi.
4.  **Perang Scope:** Bahaya variabel Global dan penyelamat bernama `local`.
5.  **The Return Trap:** Mengapa `return` di Bash tidak seperti di Python/Java.
6.  **Library & Sourcing:** Cara memecah script menjadi file `.lib`.
7.  **Studi Kasus:** Membuat Library Logging Standar Perusahaan.

</details>

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara membungkus logika yang rumit ke dalam satu kata perintah baru buatan Anda sendiri. Alih-alih menulis 20 baris kode untuk backup database berulang kali, Anda cukup membuat fungsi `backup_db` dan memanggilnya kapan saja.
**Peran:** Ini adalah kunci **Scalability** (Skala Besar). Tanpa fungsi, script enterprise yang panjangnya 5.000 baris akan mustahil dirawat (*unmaintainable*). Fungsi membuat kode Anda bersih, terstruktur, dan mudah didebug.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: DRY (Don't Repeat Yourself)**
Prinsip emas pemrograman: Jika Anda menulis kode yang sama lebih dari dua kali, bungkuslah dalam fungsi. Duplikasi kode adalah sumber bug (jika satu salah, Anda harus memperbaiki di semua tempat kopiannya).

**Konsep: Encapsulation (Pengkapsulan)**
Fungsi yang baik adalah "Kotak Hitam". Dia menerima input, melakukan proses, dan mengeluarkan output tanpa mengacak-acak variabel di luar kotak tersebut. Di sinilah konsep **Scope** (Ruang Lingkup) menjadi vital.

*(Visualisasi Konseptual: Bayangkan rumah kaca (Fungsi) di dalam taman besar (Script Global). Tanaman di dalam rumah kaca (Local Variable) tidak terpengaruh oleh cuaca di taman luar, dan sebaliknya).*

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Mendefinisikan & Memanggil Fungsi

Ada dua cara penulisan, tapi cara POSIX (Portable) lebih disarankan.

```bash
#!/bin/bash

# Definisi Fungsi (Harus ditulis SEBELUM dipanggil)
sapa_user() {
    echo "-----------------------------"
    echo "Selamat Datang di Sistem Ini"
    echo "-----------------------------"
}

# Memanggil Fungsi (Cukup panggil namanya)
sapa_user
sapa_user
```

*Catatan:* Jangan gunakan tanda kurung `()` saat memanggil\! Cukup `sapa_user`, bukan `sapa_user()`.

#### B. Passing Arguments (Argumen Fungsi)

Di sinilah banyak pemula terkecoh.
Di dalam fungsi, `$1`, `$2`, dst adalah **milik fungsi tersebut**, bukan milik script utama.

```bash
tambah_angka() {
    # $1 dan $2 di sini adalah argumen yang dikirim KE FUNGSI
    HASIL=$(( $1 + $2 ))
    echo "Hasil penjumlahan $1 + $2 = $HASIL"
}

# Memanggil fungsi dengan parameter
tambah_angka 10 5
tambah_angka 100 200
```

**Output:**
Hasil penjumlahan 10 + 5 = 15
Hasil penjumlahan 100 + 200 = 300

#### C. Scope: `local` vs Global

Ini adalah **bagian paling berbahaya** di Bash Scripting. Secara default, semua variabel di Bash adalah **GLOBAL**, bahkan jika dibuat di dalam fungsi.

**Masalah (Variable Leaking):**

```bash
ubah_nama() {
    NAMA="Joko"  # Variabel ini menimpa variabel global!
}

NAMA="Budi"
echo "Sebelum: $NAMA"
ubah_nama
echo "Sesudah: $NAMA"  # Output jadi "Joko". Budi hilang!
```

**Solusi (Local Variable):**
Selalu gunakan kata kunci `local` di dalam fungsi.

```bash
ubah_nama_aman() {
    local NAMA="Joko" # Hanya hidup di dalam fungsi ini
    echo "Di dalam fungsi: $NAMA"
}

NAMA="Budi"
ubah_nama_aman
echo "Di luar fungsi: $NAMA" # Tetap "Budi". Aman.
```

#### D. The Return Trap (Jebakan Return)

Di bahasa lain (Python/JS), `return "Data"` memberikan data kembali.
Di Bash, `return` **HANYA** bisa mengembalikan **Exit Code (0-255)** (Status Sukses/Gagal).

**Cara Salah:**

```bash
dapat_tanggal() {
    return "2025-01-01" # ERROR! Return hanya terima angka.
}
```

**Cara Benar 1 (Menggunakan Echo + Command Substitution):**
Ini adalah cara standar untuk mengembalikan data string.

```bash
dapat_tanggal() {
    local TGL=$(date +%Y-%m-%d)
    echo "$TGL" # Cetak ke stdout (stdout ini yang dianggap "return value")
}

# Tangkap output fungsi ke variabel
HARI_INI=$(dapat_tanggal)
echo "Hari ini adalah $HARI_INI"
```

**Cara Benar 2 (Menggunakan Global Variable - Kurang disarankan tapi cepat):**

```bash
dapat_tanggal_global() {
    RESULT_TGL=$(date +%Y-%m-%d)
}

dapat_tanggal_global
echo "Hari ini: $RESULT_TGL"
```

-----

### 4\. Libraries & Sourcing

Bagaimana jika fungsi kita dibutuhkan oleh 10 script berbeda? Kita tidak mungkin copy-paste fungsi itu ke 10 file.
Kita buat **Library**.

1.  Buat file `utils.lib` (atau `.sh`):

    ```bash
    # utils.lib - Kumpulan fungsi umum

    log_error() {
        echo "[ERROR] $1" >&2
    }

    cek_root() {
        if [[ $EUID -ne 0 ]]; then
            log_error "Harus dijalankan sebagai Root!"
            return 1
        fi
    }
    ```

2.  Gunakan di script utama (`main.sh`) dengan perintah `source`:

    ```bash
    #!/bin/bash

    # Import library (Gunakan titik . atau kata source)
    source ./utils.lib

    # Panggil fungsi dari library
    cek_root || exit 1

    echo "Script jalan..."
    ```

**Konsep `source`:**
Perintah `source` (atau titik `.`) membaca isi file lain dan mengeksekusinya **di dalam konteks shell saat ini**. Seolah-olah kode di file library disalin-tempel ke script utama saat runtime.

-----

### 5\. Terminologi Esensial

1.  **Modularitas:** Memecah sistem besar menjadi modul-modul kecil yang independen.
2.  **Scope (Lingkup):** Area di mana sebuah variabel bisa "dilihat" atau diakses.
3.  **Shadowing:** Ketika variabel lokal mempunyai nama yang sama dengan variabel global, variabel lokal "menutupi" variabel global selama fungsi berjalan.
4.  **Boilerplate:** Kode standar/berulang yang harus ditulis di banyak tempat (fungsi membantu mengurangi ini).

-----

### 6\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 2.2 (Variabel)**. Anda harus paham variabel untuk mengerti masalah scope.
  * **Koneksi ke Depan:** **Modul 4.2 (Interoperabilitas)**. Kita akan membungkus perintah JSON/API yang rumit ke dalam fungsi sederhana agar mudah dipakai.

### 7\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [GNU Bash Manual - Shell Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html)
  * **Deep Dive:** [Bash Hackers Wiki - Functions](https://www.google.com/search?q=https://wiki.bash-hackers.org/scripting/obsolete/function) (Penjelasan teknis mendalam).
  * **Best Practice:** [Google Shell Style Guide - Functions](https://www.google.com/search?q=https://google.github.io/styleguide/shellguide.html%23s4-functions).

### 8\. Tips dan Praktik Terbaik

  * **Naming Convention:** Gunakan `verb_noun` untuk nama fungsi. Contoh: `get_ip_address`, `calculate_tax`, `check_connection`.
  * **Selalu Gunakan `local`:** Jadikan ini hukum wajib. Jangan pernah membuat variabel di dalam fungsi tanpa `local`, kecuali Anda **sengaja** ingin mengubah state global (dan beri komentar jika demikian).
  * **Return Code untuk Logika:** Gunakan `return 0` (sukses) dan `return 1` (gagal) agar fungsi bisa dipakai di dalam `if`.
    ```bash
    if cek_koneksi; then ... fi
    ```

### 9\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Lupa mendefinisikan fungsi sebelum memanggilnya.
      * **Bash:** Script dibaca dari atas ke bawah. Jika Anda panggil `sapa_user` di baris 1, tapi fungsinya baru ditulis di baris 10, script akan error "command not found".
      * **Solusi:** Taruh semua fungsi di bagian paling atas script, atau di file library terpisah.
  * **Kesalahan:** Menggunakan `exit` di dalam fungsi library.
      * **Bahaya:** Jika fungsi `utils.lib` memanggil `exit`, dia akan mematikan **seluruh script utama**.
      * **Solusi:** Gunakan `return` di dalam fungsi, biarkan script utama yang memutuskan apakah harus `exit` atau tidak.

-----

Script Anda kini sudah rapi, modular, dan aman dari konflik variabel. Anda sudah berpikir seperti seorang *Software Engineer*.

Namun, script kita masih hidup sendirian di dalam komputer ("Localhost"). Bagaimana jika script kita perlu bicara dengan dunia luar? Mengambil data cuaca dari internet? Mengirim notifikasi ke Slack/Telegram?

Di **Modul 4.2**, kita akan belajar **Interoperabilitas & Jaringan**. Kita akan mengajarkan Bash bicara bahasa **HTTP, JSON, dan API**.

-----

Kita memasuki **MODUL 4.2**. Ini adalah modul di mana script Anda mendapatkan "Paspor" untuk keliling dunia.

Hingga saat ini, script Anda hanya jago kandang (berjalan di `localhost`). Di era Cloud dan Microservices, script yang terisolasi itu kurang berguna. Script modern harus bisa berbicara dengan API (Application Programming Interface), mengambil data dari server lain, dan mengirim laporan ke Slack/Telegram.

Di sini kita akan mempelajari **Interoperabilitas**: Kemampuan Bash untuk bertukar data dengan sistem lain menggunakan standar modern (**HTTP & JSON**).

-----

## MODUL 4.2: Interoperabilitas, Jaringan (cURL), & JSON Parsing (`jq`)

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Konektivitas:** Bash sebagai "Lem" antar layanan web.
2.  **The Messenger (`curl`):** Mengirim dan menerima paket data lewat internet.
3.  **Bahasa Universal (JSON):** Mengapa format teks biasa sudah ketinggalan zaman.
4.  **The Translator (`jq`):** Alat wajib untuk membedah JSON di terminal.
5.  **HTTP Methods:** Memahami `GET` (Ambil) vs `POST` (Kirim).
6.  **Remote Automation (SSH):** Mengendalikan server lain dari jarak jauh.
7.  **Studi Kasus:** Membuat script pemantau cuaca yang lapor ke Discord/Slack.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara membuat script yang bisa "browsing" internet tanpa browser. Anda akan belajar mengambil data kurs mata uang terkini, mengotomatiskan tweet, atau merestart server di benua lain, semuanya dari satu file script.
**Peran:** Ini adalah jembatan antara **SysAdmin** tradisional dan **DevOps** modern. DevOps sangat bergantung pada API (AWS CLI, Docker API, Kubernetes API), dan modul ini adalah dasarnya.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Everything is an API"**
Dulu, kita mengelola server dengan mengedit file konfigurasi. Sekarang, kita mengelola infrastruktur (Cloud) dengan memanggil API. Bash script Anda harus bisa menjadi "Klien HTTP" yang pintar.

**Tantangan: Structured Data**
Bash sangat hebat memproses teks baris (seperti log), tapi sangat buruk memproses data terstruktur yang bersarang seperti JSON. Itulah mengapa kita **wajib** menggunakan alat bantu eksternal bernama `jq`. Memparsing JSON dengan `grep` atau `sed` adalah praktik buruk yang rawan error.

*(Visualisasi Direkomendasikan: Diagram interaksi Client-Server. Script Anda (Klien) mengirim 'Request' membawa 'Header' dan 'Body'. Server memproses dan mengembalikan 'Response' berupa JSON).*

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. The Swiss Army Knife: `curl`

`curl` (Client URL) adalah alat standar industri untuk transfer data.

**1. GET Request (Mengambil Data)**

```bash
curl -s "https://jsonplaceholder.typicode.com/users/1"
```

**Bedah Sintaks:**

  * `curl`: Perintah utama.
  * `-s`: **S**ilent. Jangan tampilkan progress bar/meteran download. Kita hanya ingin datanya.
  * `"URL"`: Alamat API tujuan.

**2. POST Request (Mengirim Data)**

```bash
curl -X POST -H "Content-Type: application/json" -d '{"nama":"Budi"}' "https://api.contoh.com/daftar"
```

**Bedah Sintaks:**

  * `-X POST`: Tentukan metode HTTP (Default adalah GET).
  * `-H "..."`: **H**eader. Memberitahu server jenis data apa yang kita kirim (di sini: JSON).
  * `-d '...'`: **D**ata. Isi paket yang dikirim.

#### B. The Translator: `jq`

`jq` adalah "sed/awk" khusus untuk JSON. Karena JSON formatnya berjenjang (objek di dalam objek), kita butuh `jq` untuk menavigasinya.

*Contoh Data JSON (disimpan di variabel atau hasil curl):*

```json
{
  "nama": "Budi",
  "lokasi": {
    "kota": "Jakarta",
    "negara": "Indonesia"
  },
  "hobi": ["Coding", "Gaming"]
}
```

**Operasi Dasar `jq`:**

```bash
# Mengambil nilai sederhana
echo $JSON_DATA | jq '.nama'
# Output: "Budi" (dengan kutip)

# Mengambil nilai bersarang (Nested)
echo $JSON_DATA | jq '.lokasi.kota'
# Output: "Jakarta"

# Mengambil nilai Raw (Tanpa tanda kutip - Penting untuk script!)
echo $JSON_DATA | jq -r '.nama'
# Output: Budi
```

#### C. Gabungan Maut: `curl` | `jq`

Inilah cara kerja profesional. Ambil data dari internet, langsung bedah, dan simpan ke variabel.

```bash
# Ambil data user github dan simpan lokasi ke variabel
LOKASI=$(curl -s https://api.github.com/users/octocat | jq -r '.location')

echo "Octocat tinggal di: $LOKASI"
```

-----

### 4\. Remote Execution dengan SSH

Terkadang API tidak cukup. Anda perlu masuk ke server lain dan menjalankan perintah shell.

**Sintaks Dasar:**

```bash
ssh user@192.168.1.50 "ls -l /var/www/html"
```

  * Script ini akan login ke server `192.168.1.50`, menjalankan `ls`, lalu outputnya dikirim balik ke terminal Anda saat ini.

**Here Doc (Menjalankan Banyak Perintah):**
Jika Anda perlu menjalankan script panjang di server orang lain:

```bash
ssh user@server << 'EOF'
    echo "Saya sedang di server: $(hostname)"
    cd /var/log
    grep "Error" syslog > error_report.txt
    echo "Selesai."
EOF
```

  * `<< 'EOF'`: Mengirim blok teks berikut ini ke stdin SSH sampai ketemu kata `EOF`.

-----

### 5\. Studi Kasus: IP Geolocation & Discord Notifier

Kita akan membuat script yang mendeteksi lokasi internet kita saat ini, lalu mengirim laporannya ke Webhook Discord (bisa diganti Slack).

**Prasyarat:** Anda butuh URL Webhook Discord (gratis dibuat di pengaturan channel Discord).

**File: `lapor_lokasi.sh`**

```bash
#!/bin/bash

# 1. Set URL Webhook (Ganti dengan URL asli Anda)
WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_ID/YOUR_TOKEN"

# 2. Ambil data Info IP (Output JSON)
echo "Mengambil data lokasi..."
DATA_JSON=$(curl -s https://ipinfo.io/json)

# 3. Parsing data menggunakan jq
# Opsi -r (raw) agar tanda kutip hilang
IP=$(echo "$DATA_JSON" | jq -r '.ip')
KOTA=$(echo "$DATA_JSON" | jq -r '.city')
NEGARA=$(echo "$DATA_JSON" | jq -r '.country')
ORG=$(echo "$DATA_JSON" | jq -r '.org')

# 4. Susun Payload JSON untuk Discord
# Hati-hati dengan escaping kutip!
PAYLOAD=$(cat <<EOF
{
  "content": "🚨 **Login Terdeteksi!**",
  "embeds": [{
    "title": "Detail Jaringan",
    "color": 15158332,
    "fields": [
      {"name": "IP", "value": "$IP", "inline": true},
      {"name": "Lokasi", "value": "$KOTA, $NEGARA", "inline": true},
      {"name": "ISP", "value": "$ORG"}
    ]
  }]
}
EOF
)

# 5. Kirim ke Discord menggunakan POST
echo "Mengirim notifikasi..."
curl -H "Content-Type: application/json" \
     -d "$PAYLOAD" \
     "$WEBHOOK_URL"

echo "Selesai."
```

**Analisis:**

1.  Kita menggunakan `curl` (GET) untuk bertanya ke `ipinfo.io`.
2.  Kita menggunakan `jq` untuk mengekstrak hanya info penting.
3.  Kita menyusun JSON baru (Payload) yang sesuai format Discord.
4.  Kita menggunakan `curl` (POST) untuk mengirim JSON tersebut ke server Discord.

-----

### 6\. Terminologi Esensial

1.  **API (Application Programming Interface):** Pintu yang disediakan aplikasi (seperti Google, Github) agar program lain bisa berbicara dengannya.
2.  **JSON (JavaScript Object Notation):** Format pertukaran data paling populer. Ringan, mudah dibaca manusia dan mesin.
3.  **Endpoint:** Alamat URL spesifik di API (misal `/users`, `/login`).
4.  **Header:** Metadata yang dikirim bersama request (seperti "Saya mengirim JSON", atau "Ini Token Rahasia saya").
5.  **Webhook:** Cara server mengirim notifikasi ke kita (Reverse API).

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 2.2 (Variabel)** untuk menyimpan hasil JSON, dan **Modul 4.1 (Fungsi)** untuk membungkus logika request ini agar rapi.
  * **Interoperabilitas:** Ini menghubungkan Bash dengan dunia web development (Python/NodeJS backends).
  * **Kebutuhan Alat:** Anda mungkin perlu menginstall `jq` (`sudo apt install jq` atau `brew install jq`) karena biasanya belum terinstall default, tidak seperti `curl` atau `grep`.

### 8\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi jq:** [stedolan.github.io/jq](https://stedolan.github.io/jq/manual/) (Kitab suci manipulasi JSON).
  * **Buku Panduan cURL:** [Everything curl](https://everything.curl.dev/) (Panduan sangat lengkap tentang cURL).
  * **API Gratis untuk Latihan:** [JSONPlaceholder](https://jsonplaceholder.typicode.com/) (API dummy untuk testing).

### 9\. Tips dan Praktik Terbaik

  * **Selalu gunakan `-s` (Silent) pada curl:** Dalam script, kita tidak butuh animasi progress bar yang mengotori log atau variabel.
  * **Gunakan `jq` untuk *membuat* JSON:** Menyusun JSON manual dengan `echo "{ ... }"` rawan error kutip. Gunakan `jq -n` untuk membuat JSON yang valid secara sintaks.
      * Contoh: `jq -n --arg nm "Budi" '{nama: $nm}'`
  * **Amankan Token API:** Jangan pernah *hardcode* token rahasia di script jika script itu akan diupload ke Github. Gunakan Environment Variable.

### 10\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** JSON Parse Error.
      * **Penyebab:** String JSON tidak valid (kurang koma atau kutip).
      * **Solusi:** Gunakan `jq .` untuk memvalidasi struktur JSON.
  * **Kesalahan:** `command not found: jq`.
      * **Penyebab:** `jq` belum diinstall.
      * **Solusi:** Masukkan pengecekan dependensi di awal script.
    <!-- end list -->
    ```bash
    if ! command -v jq &> /dev/null; then
        echo "Error: jq belum diinstall."
        exit 1
    fi
    ```

-----

Script Anda sekarang sudah menjadi warga negara global internet.

Namun, dengan kekuatan besar (koneksi internet, database akses, logika kompleks), datanglah tanggung jawab besar. Bagaimana jika script Anda gagal di tengah jalan? Bagaimana jika internet mati saat `curl` berjalan?

Di **PHASE 5: Enterprise Automation**, kita akan fokus pada ketahanan (**Robustness**).

Kita mulai dengan **Modul 5.1: Defensive Coding, Error Handling, & Debugging**. Kita akan membuat script yang "Anti-Peluru".

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
