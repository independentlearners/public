# 📘 Overview: Text Processing & Fondasi Regex

**Memahami Teks di Komputer Sebelum Masuk ke Regex**

Dokumen ini menjelaskan konsep dasar mengenai **teks**, **representasi data**, serta **pengolahan teks (text processing)** di komputer. Materi ini menjadi pondasi sebelum peserta belajar **regex (regular expressions)**. Pemahaman konteks ini akan membuat peserta memahami *mengapa regex penting*, *kapan digunakan*, dan *bagaimana text processing bekerja dalam sistem komputer modern*. Berikut pengantar sistematis serta profesional untuk memahami jenis-jenis file dan teks di Linux.

---

## Jenis File dan Teks di Linux (Pra-Regex)

### 🎯 Tujuan

Untuk memberikan pemahaman dasar mengenai:

- Perbedaan antara file teks dan file biner
- Jenis-jenis file berdasarkan struktur datanya
- Kapan dan bagaimana regex dapat digunakan
- Alat bantu untuk mengenali dan mengelola file di Linux CLI

---

## 🧩 1. Apa Itu “Teks” di Dunia Komputer?

Dalam komputer, **teks adalah data yang direpresentasikan sebagai urutan byte**, biasanya menggunakan encoding seperti:

* **ASCII** — standar lama 7-bit (huruf Latin, angka, simbol dasar).
* **UTF-8** — encoding modern yang mendukung semua bahasa (Unicode).
* **UTF-16 / UTF-32** — encoding alternatif yang digunakan oleh beberapa sistem.

Teks pada dasarnya hanyalah **angka**, tetapi dibaca dan ditampilkan sebagai huruf oleh aplikasi.

Contoh representasi byte:

* Huruf `A` dalam ASCII → `0x41`
* Huruf `a` → `0x61`
* Karakter `你` dalam UTF-8 → tiga byte: `0xE4 0xBD 0xA0`

**Kesimpulan:** sebelum kita bisa memproses teks, kita harus memahami bahwa semua teks adalah *data mentah* yang hanya terlihat bermakna setelah diinterpretasikan oleh aplikasi.


### Jenis Teks:
| Jenis | Ciri | Contoh |
|-------|------|--------|
| **Plain Text** | Teks murni tanpa format khusus | `.txt`, `.md`, `.conf` |
| **Structured Text** | Teks dengan struktur tertentu | `.json`, `.yaml`, `.csv`, `.html` |
| **Source Code** | Teks berisi instruksi program | `.c`, `.py`, `.lua`, `.sh` |

---

## 🧱 2. Apa Itu File Biner?

**File biner** adalah file yang berisi data dalam format byte mentah, tidak bisa dibaca langsung oleh manusia tanpa decoding.

### Contoh File Biner:
| Jenis | Ekstensi | Keterangan |
|-------|----------|------------|
| **Executable** | `.exe`, `.bin`, `.so` | Berisi instruksi mesin |
| **Media** | `.mp3`, `.mp4`, `.jpg`, `.png` | Data audio/visual |
| **Archive** | `.zip`, `.tar`, `.gz` | Kompresi file |
| **Database** | `.db`, `.sqlite`, `.mdb` | Data terstruktur dalam format biner |

---

### 🔍 3. Bagaimana Mengenali Jenis File?

Gunakan perintah CLI berikut:

```bash
file nama_file
```

Contoh output:
- `ASCII text` → Plain text
- `gzip compressed data` → Arsip terkompresi
- `ELF 64-bit LSB executable` → File eksekusi Linux

---

### 🧮 4. Kapan Regex Bisa Digunakan?

**Regex hanya efektif untuk file teks.** Regex tidak cocok untuk file biner karena:
- Struktur datanya tidak berbasis karakter
- Bisa menyebabkan hasil pencarian tidak valid atau error

### File yang Cocok untuk Regex

Hanya file untuk penulisan yang dapat di edit seperti: 

✅ `.txt`, `.log`, `.conf`, `.json`, `.html`, `.csv`, `.py`, `.sh`

### File yang Tidak Cocok untuk Regex

Semua file matang seperti:

❌ `.mp3`, `.mp4`, `.zip`, `.exe`, `.db`, `.png`, `.pdf` (tergantung encoding)

---

### 🛠️ 5. Tools CLI Terkait

| Tool | Fungsi |
|------|--------|
| `cat`, `less`, `nano`, `vim` | Membaca dan mengedit file teks |
| `grep`, `sed`, `awk` | Pencarian dan manipulasi teks (regex) |
| `file` | Mengidentifikasi tipe file |
| `strings` | Mengekstrak teks dari file biner |
| `xxd`, `hexdump` | Melihat isi file dalam format heksadesimal |
| `jq`, `yq` | Parsing file JSON/YAML |

---

### 📌 Kesimpulan Inti

- Tidak semua file di Linux adalah teks.
- Regex hanya bekerja pada file teks.
- Penting untuk mengenali tipe file sebelum memprosesnya dengan regex.
- Gunakan `file` dan `strings` untuk investigasi awal.

---

## 2. Bagaimana Teks Disimpan dan Dikelola?

Semua file konfigurasi, log sistem, kode sumber, skrip, dokumen markdown, dan output perintah CLI adalah **plain text**.

Contoh:

* `/etc/sway/config`
* `~/.config/waybar/config.json`
* `journalctl`
* `dmesg`
* file `.log`
* skrip `.sh`
* kode `.lua`, `.py`, `.dart`

Karena Linux sangat berbasis teks, **pengolahan teks (text processing)** menjadi kemampuan inti bagi siapa pun yang bekerja di lingkungan Unix-like.

---

## 3. Apa Itu Text Processing?

**Text processing** adalah proses:

* membaca,
* memfilter,
* mengubah,
* memecah,
* mengekstrak,
* atau menganalisis
  teks menggunakan tool atau algoritma.

Text processing mencakup banyak hal, misalnya:

* mencari baris tertentu dalam file,
* mengubah format data,
* memotong kolom,
* mengganti kata,
* menghapus duplikasi,
* mengekstrak pola tertentu,
* mengubah struktur teks untuk kebutuhan lain.

### Tool utama text processing di dunia Unix:

* `grep` — mencari pola di file.
* `sed` — melakukan pengeditan otomatis.
* `awk` — memproses data baris-per-baris dan kolom-per-kolom.
* `cut`, `tr`, `sort`, `uniq`, `wc`, `paste` — utilitas text processing dasar.
* Bahasa scripting seperti **bash**, **perl**, **python**, **lua** juga memiliki fasilitas pemrosesan teks.

Text processing sangat penting karena hampir **semua konfigurasi Linux berbasis teks**, dan log sistem juga berupa teks.

---

## 4. Mengapa Text Processing Penting?

### 4.1 Untuk Administrator Sistem

* Modifikasi konfigurasi secara otomatis
* Deploy sistem dengan skrip
* Eksplorasi log untuk debugging

### 4.2 Untuk Developer

* Parse file konfigurasi
* Generate file otomatis
* Analisis kode sumber

### 4.3 Untuk Cybersecurity

* Analisis log kejadian
* Mendeteksi pola serangan
* Ekstraksi IOC (Indicators of Compromise)
* Parsing payload untuk forensik

### 4.4 Untuk Automation & DevOps

* Membuat pipeline data
* Menyusun skrip provisioning
* Mengolah output CLI

### 4.5 Untuk Pengembangan CLI/TUI

* Parsing input pengguna
* Membaca file konfigurasi kustom
* Menemukan pola command

Text processing pada dasarnya adalah **kemampuan untuk mengontrol, memahami, dan memodifikasi data teks dengan efisien**.

---

## 5. Keterbatasan Text Processing Tanpa Regex

Tanpa regex, Anda hanya bisa memproses teks dengan cara sederhana:

* mencari kata literal tertentu,
* mengganti string statis,
* membaca baris tertentu.

Contoh:

```
grep "error" file.log
```

Tetapi kenyataannya, data di dunia nyata **tidak selalu terstruktur rapi**:

* IP Address memiliki banyak bentuk.
* Timestamp memiliki format berbeda.
* Path file berisi karakter yang bervariasi.
* Log cybersecurity dapat sangat kompleks.

Contoh data nyata:

```
Failed password for invalid user root from 192.168.0.12 port 48822 ssh2
```

Untuk mengekstrak **IP Address**, **username**, atau **timestamp**, pencarian literal tidak cukup.

Di sinilah **regex menjadi solusi inti**.

---

## 6. Apa Itu Regex?

**Regular expression (regex)** adalah bahasa mini yang dirancang untuk:

* menemukan pola yang kompleks,
* mengekstrak bagian tertentu dari teks,
* mencocokkan struktur tertentu,
* memvalidasi format data.

Regex bisa:

* mengenali email
* memfilter alamat IP
* mengekstrak angka tertentu
* menemukan pola berulang
* mendeteksi pola serangan

Contoh regex untuk alamat IP:

```
\b\d{1,3}(\.\d{1,3}){3}\b
```

Regex adalah **bahasa presisi teks**.

Ia memungkinkan kita melakukan hal-hal yang **tidak mungkin** dilakukan dengan pencarian biasa.

---

## 7. Regex sebagai “Alat Pilihan” dalam Text Processing

Regex bukan menggantikan text processing, tetapi merupakan **bagian pamungkas** dari text processing.

Ketika menemukan masalah yang:

* terlalu rumit untuk sekadar `grep "kata"`
* membutuhkan pencocokan pola dinamis
* membutuhkan struktur validasi tertentu
* membutuhkan parsing complex log di cybersecurity

regex adalah solusi yang tepat.

Regex digunakan di:

* `grep -E`, `grep -P`
* `sed -E`
* `awk`
* `perl`
* `python re`
* `dart RegExp`
* `lua lpeg`
* `ripgrep`
* `neoVim syntax`
* firewall IDS/IPS

Regex adalah skill universal, tidak tergantung bahasa.

---

## 8. Text Processing + Regex = Kekuatan Utama di Dunia Linux

Ketika text processing digabung dengan regex, Anda mendapatkan kemampuan untuk:

* mengubah ribuan file konfigurasi secara otomatis,
* memfilter log sistem yang sangat besar,
* mengekstrak informasi penting dengan presisi tinggi,
* membangun tool CLI/TUI untuk pengguna lain,
* membuat rule analisis cybersecurity,
* membangun pipeline data yang kompleks.

Keduanya saling melengkapi.

---

## 9. Pembelajaran Lanjutan (Arah ke Regex)

Setelah memahami overview ini, seharusnya anda siap memasuki pembelajaran:

* PCRE2
* POSIX BRE/ERE
* Lookaround
* Backreference
* Pattern grouping
* Integrasi dengan grep, sed, awk
* Regex dalam bahasa pemrograman

Dan seterusnya.

---

# Penutup

Dokumen ini memberikan gambaran lengkap mengenai:

* bagaimana teks direpresentasikan,
* apa itu text processing,
* mengapa text processing penting,
* bagaimana regex menjadi bagian tak terpisahkan dari pekerjaan teknis modern.

Dengan pemahaman dasar ini, anda akan dapat memulai pembelajaran regex dengan landasan yang kuat — memahami *bukan hanya bagaimana regex bekerja*, tetapi *mengapa regex dibutuhkan*.

---

**[Pembelajaran Regex](../text/regex/README.md)**
