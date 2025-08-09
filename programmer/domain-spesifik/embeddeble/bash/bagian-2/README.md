# **[Fase 2: Menengah – Struktur, Kontrol, dan Manipulasi Teks (Tingkat Menengah)][1]**

**Tujuan Fase:** Menguasai elemen-elemen pemrograman standar (kondisional, perulangan, fungsi) dan menggunakan alat bantu teks yang kuat untuk memproses data. Fase ini akan membawa Anda dari penulis skrip dasar menjadi pengembang skrip yang mampu membuat keputusan, mengotomatiskan tugas berulang, dan mengelola kode secara modular.

-----

## **Modul 2.1: Struktur Kondisional**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Memahami Exit Codes (`$?`) secara Mendalam
2. Struktur `if ... then ... fi`
3. Menggunakan `test` (`[ ... ]`) vs. `[[ ... ]]`
4. Operator Perbandingan String, Angka, dan File
5. Menggabungkan Kondisi (AND `&&`, OR `||`)
6. Struktur `case ... esac` untuk Pencocokan Pola
7. Potensi Penambahan Materi: Ternary Operator (`?:`)

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Dalam modul ini, Anda akan belajar seni membuat skrip Anda "berpikir" dan "memutuskan". Struktur kondisional adalah fondasi logika dalam pemrograman apa pun. Ini memungkinkan skrip Anda untuk mengambil jalur eksekusi yang berbeda berdasarkan kondisi tertentu—apakah itu nilai variabel, keberadaan sebuah file, atau hasil dari perintah sebelumnya. Daripada hanya menjalankan serangkaian perintah secara linier, skrip Anda akan menjadi lebih adaptif, fleksibel, dan "cerdas".

Peran modul ini sangat vital. Tanpa kemampuan untuk membuat keputusan, skrip Anda hanya akan menjadi daftar tugas statis. Dengan kondisional, Anda dapat membuat skrip yang bereaksi terhadap kesalahan, memproses berbagai jenis input, mengelola konfigurasi yang berbeda, atau bahkan berinteraksi dengan pengguna secara dinamis. Ini adalah langkah maju yang signifikan dari Modul 1.3, yang berfokus pada eksekusi linier dan dasar variabel. Dalam konteks pengembangan Dart/Flutter, logika kondisional adalah bagian tak terpisahkan dari setiap aplikasi, dari menampilkan *widget* tertentu berdasarkan status hingga menangani berbagai skenario data.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Logika Boolean (Benar/Salah):**

Inti dari setiap struktur kondisional adalah evaluasi sebuah ekspresi yang menghasilkan nilai `Benar` (True) atau `Salah` (False). Dalam Bash, "kebenaran" atau "kegagalan" ini sering kali direpresentasikan oleh **status keluar (exit status)** dari sebuah perintah atau ekspresi.

#### **2.2. Determinisme dan Fleksibilitas:**

* **Determinisme:** Tanpa kondisional, skrip selalu melakukan hal yang sama. Ini deterministik, tetapi kurang fleksibel.
* **Fleksibilitas:** Dengan kondisional, skrip menjadi non-deterministik, dalam artian perilakunya dapat berubah tergantung pada kondisi saat skrip dijalankan. Ini adalah kekuatan utama dalam otomasi karena memungkinkan skrip beradaptasi dengan lingkungan atau input yang bervariasi.

#### **2.3. Filosofi Unix dan Status Keluar (The "Return 0 is Success" Mantra):**

Dalam filosofi Unix, setiap program dirancang untuk melakukan satu hal dengan baik, dan hasilnya dikomunikasikan melalui *exit status* setelah eksekusi selesai. Status `0` secara universal berarti "sukses" atau "tidak ada kesalahan," sementara nilai non-nol (biasanya `1` hingga `255`) menunjukkan adanya suatu jenis kesalahan atau kondisi kegagalan.

* **Implikasi:** Ini adalah antarmuka yang sangat sederhana namun kuat. Daripada harus mem-*parse* *output* teks untuk mencari tahu apakah sebuah perintah berhasil, Anda cukup memeriksa *exit status*-nya. Ini adalah fondasi dari *error handling* dalam *shell scripting*.
* **Konsistensi:** Hampir semua perintah Unix/Linux mengikuti konvensi ini. Memahami hal ini akan memungkinkan Anda menulis skrip yang dapat berinteraksi dengan perintah apa pun dan bereaksi secara tepat terhadap keberhasilan atau kegagalannya.

#### **2.4. `test` Command dan Ekspresi Kondisional:**

Perintah `test` (atau aliasnya `[` dan `[[`) adalah tulang punggung dari semua kondisional di Bash. Mereka mengevaluasi ekspresi dan mengembalikan *exit status* 0 (Benar) atau 1 (Salah). Struktur `if` kemudian bereaksi terhadap *exit status* ini. Ini adalah contoh sempurna bagaimana Bash menggunakan *exit status* secara internal untuk mengendalikan alur program.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Memahami Exit Codes (`$?`) secara Mendalam:**

Seperti yang disinggung di Modul 1.3, `$?` adalah variabel khusus yang menyimpan *exit status* dari perintah terakhir yang dieksekusi. Ini adalah cara utama Bash untuk mengevaluasi "kebenaran" suatu kondisi.

```bash
#!/bin/bash

# Contoh 1: Perintah yang berhasil (exit status 0)
echo "Ini adalah pesan sukses"
echo "Exit status dari 'echo': $?" # Output: 0

# Contoh 2: Perintah yang gagal (exit status non-0)
ls /direktori/yang/tidak/ada 2>/dev/null # Redirect stderr to /dev/null agar tidak mengganggu output
echo "Exit status dari 'ls /direktori/yang/tidak/ada': $?" # Output: 2 (atau nilai non-0 lain tergantung sistem)

# Contoh 3: Menggunakan 'true' dan 'false' (perintah bawaan Bash)
true # Perintah yang selalu mengembalikan exit status 0
echo "Exit status dari 'true': $?" # Output: 0

false # Perintah yang selalu mengembalikan exit status 1
echo "Exit status dari 'false': $?" # Output: 1
```

* **Penjelasan `2>/dev/null`:** Ini adalah *redirection* yang mengalihkan `stderr` (file descriptor 2) ke `/dev/null`, sebuah "lubang hitam" virtual di mana semua data yang dialihkan ke sana akan dibuang. Ini berguna untuk menekan pesan error yang tidak ingin ditampilkan ke pengguna di terminal.

#### **3.2. Struktur `if ... then ... fi`:**

Ini adalah bentuk kondisional paling dasar.

```bash
#!/bin/bash

# Sintaks Dasar:
# if perintah_atau_ekspresi_kondisional; then
#   # Kode yang dijalankan jika perintah_atau_ekspresi_kondisional sukses (exit status 0)
# fi

# Contoh Sederhana: Mengecek keberhasilan perintah
if mkdir folder_baru_saya; then
  echo "Folder 'folder_baru_saya' berhasil dibuat."
else
  echo "Gagal membuat folder 'folder_baru_saya'."
fi
```

* **Penjelasan:**
  * `if`: Kata kunci yang memulai blok kondisional.
  * `mkdir folder_baru_saya`: Ini adalah perintah yang akan dievaluasi. Jika `mkdir` berhasil (direktori berhasil dibuat dan mengembalikan `0`), blok `then` akan dieksekusi. Jika gagal (misalnya, direktori sudah ada dan mengembalikan nilai non-nol), blok `else` akan dieksekusi.
  * `then`: Menandai awal blok kode yang akan dijalankan jika kondisi benar.
  * `else`: (Opsional) Menandai awal blok kode yang akan dijalankan jika kondisi salah.
  * `fi`: Menutup blok `if`. `fi` adalah `if` yang dibalik, sebuah konvensi umum di Bash.

#### **3.3. Menggunakan `test` (`[ ... ]`) vs. `[[ ... ]]`:**

Ini adalah dua cara utama untuk mengevaluasi ekspresi kondisional dalam Bash.

* **`test` atau `[ ... ]` (Perintah Tradisional):**

  * `[` sebenarnya adalah *alias* untuk perintah `test`.
  * Ini adalah perintah eksternal yang mengevaluasi argumennya dan mengembalikan *exit status*.
  * **Keterbatasan:** Memerlukan kutipan yang hati-hati untuk variabel dan tidak mendukung *globbing* atau *regular expressions* tingkat lanjut secara langsung.

    <!-- end list -->

    ```bash
    #!/bin/bash

    NAMA_USER="Admin"

    # Perbandingan string menggunakan [ ]
    if [ "$NAMA_USER" == "Admin" ]; then
      echo "Selamat datang, Administrator!"
    fi

    # Penting: Spasi di sekitar '[' dan ']' sangat WAJIB.
    # [ "$NAMA_USER" == "Admin" ] <--- Benar
    # [ "$NAMA_USER"=="Admin" ] <--- Salah, akan menjadi error
    ```

* **`[[ ... ]]` (Bash Keyword - Modern dan Lebih Kuat):**

  * `[[ ... ]]` bukanlah perintah, melainkan **kata kunci (keyword)** bawaan Bash.
  * **Keunggulan:**
    * Tidak memerlukan kutipan yang ketat untuk variabel (`[[ $NAMA_USER == "Admin" ]]` juga akan berfungsi, meskipun kutipan ganda tetap direkomendasikan).
    * Mendukung operator perbandingan string yang lebih intuitif (`==`, `!=`).
    * Mendukung *pattern matching* (globbing) dengan operator `==` dan `!=` tanpa perlu `grep` atau `case`.
    * Mendukung *regular expressions* dengan operator `=~`.
    * Mendukung operator boolean `&&` dan `||` secara langsung di dalamnya (lihat bagian "Menggabungkan Kondisi").
    * Tidak rentan terhadap *word splitting* atau *pathname expansion* yang tidak diinginkan.

    <!-- end list -->

    ```bash
    #!/bin/bash

    NAMA_USER="Admin"
    JENIS_FILE="dokumen.txt"

    # Perbandingan string menggunakan [[ ]]
    if [[ "$NAMA_USER" == "Admin" ]]; then
      echo "Selamat datang, Administrator!"
    fi

    # Pattern matching (globbing) dengan [[ ]]
    if [[ "$JENIS_FILE" == *.txt ]]; then
      echo "Ini adalah file teks."
    fi

    # Regular Expression matching dengan [[ ]] (regex dasar)
    if [[ "$JENIS_FILE" =~ ^[a-z]+\.txt$ ]]; then
      echo "Nama file teks valid."
    fi
    ```

* **Rekomendasi:** Selalu gunakan `[[ ... ]]` untuk ekspresi kondisional baru di Bash, kecuali Anda memiliki alasan kuat untuk menggunakan `[ ... ]` (misalnya, untuk kompatibilitas dengan *shell* yang lebih lama atau POSIX `sh`).

#### **3.4. Operator Perbandingan String, Angka, dan File:**

**a. Perbandingan String (dalam `[ ]` atau `[[ ]]`):**

| Operator | Arti              | Contoh (dalam `[[ ... ]]`)          |
| :------- | :---------------- | :---------------------------------- |
| `==`     | Sama dengan       | `[[ "$VAR" == "nilai" ]]`           |
| `!=`     | Tidak sama dengan | `[[ "$VAR" != "nilai" ]]`           |
| `<`      | Kurang dari       | `[[ "$VAR1" < "$VAR2" ]]` (Lexicographical) |
| `>`      | Lebih dari        | `[[ "$VAR1" > "$VAR2" ]]` (Lexicographical) |
| `-z`     | String kosong     | `[[ -z "$VAR" ]]` (True jika panjang 0) |
| `-n`     | String tidak kosong | `[[ -n "$VAR" ]]` (True jika panjang \> 0) |
| `=~`     | Regex match       | `[[ "$VAR" =~ "pattern" ]]` (Hanya di `[[ ]]`) |

**b. Perbandingan Angka (dalam `(( ))` atau `[ ]` / `test` dengan operator numerik):**

* **Cara Paling Disarankan: Arithmetic Expansion `(( ... ))`:**

  * Ini adalah ekspresi aritmatika Bash. Mengembalikan `0` (true) jika ekspresi bernilai bukan nol, dan `1` (false) jika ekspresi bernilai nol. Mirip dengan bagaimana bahasa C menangani boolean.
  * **Keunggulan:** Mendukung operator matematika standar (`+`, `-`, `*`, `/`, `%`), dan perbandingan numerik yang intuitif.

    <!-- end list -->

    ```bash
    #!/bin/bash

    ANGKA1=10
    ANGKA2=5

    if (( ANGKA1 > ANGKA2 )); then
      echo "$ANGKA1 lebih besar dari $ANGKA2"
    fi

    if (( ANGKA1 % ANGKA2 == 0 )); then
      echo "$ANGKA1 adalah kelipatan dari $ANGKA2"
    fi
    ```

* **Cara Alternatif: Operator Numerik dalam `[ ]` atau `[[ ]]`:**

  * Gunakan `-eq`, `-ne`, `-gt`, `-ge`, `-lt`, `-le`.

    | Operator | Arti              | Contoh (dalam `[[ ... ]]`)    |
    | :------- | :---------------- | :---------------------------- |
    | `-eq`    | Sama dengan       | `[[ "$ANGKA1" -eq "$ANGKA2" ]]` |
    | `-ne`    | Tidak sama dengan | `[[ "$ANGKA1" -ne "$ANGKA2" ]]` |
    | `-gt`    | Lebih besar dari  | `[[ "$ANGKA1" -gt "$ANGKA2" ]]` |
    | `-ge`    | Lebih besar atau sama dengan | `[[ "$ANGKA1" -ge "$ANGKA2" ]]` |
    | `-lt`    | Kurang dari       | `[[ "$ANGKA1" -lt "$ANGKA2" ]]` |
    | `-le`    | Kurang dari atau sama dengan | `[[ "$ANGKA1" -le "$ANGKA2" ]]` |

**c. Pengujian File (dalam `[ ]` atau `[[ ]]`):**

| Operator | Arti                              | Contoh (dalam `[[ ... ]]`)       |
| :------- | :-------------------------------- | :------------------------------- |
| `-a file` | File ada (`-e` lebih modern)      | `[[ -e "/path/to/file" ]]`     |
| `-f file` | File ada dan merupakan file biasa | `[[ -f "/path/to/file.txt" ]]` |
| `-d dir` | File ada dan merupakan direktori  | `[[ -d "/path/to/directory" ]]` |
| `-s file` | File ada dan ukurannya \> 0        | `[[ -s "/path/to/file" ]]`     |
| `-r file` | File ada dan dapat dibaca         | `[[ -r "/path/to/file" ]]`     |
| `-w file` | File ada dan dapat ditulis        | `[[ -w "/path/to/file" ]]`     |
| `-x file` | File ada dan dapat dieksekusi     | `[[ -x "/path/to/script.sh" ]]` |

#### **3.5. Menggabungkan Kondisi (AND `&&`, OR `||`):**

Anda dapat menggabungkan beberapa kondisi menggunakan operator boolean.

* **Operator `&&` (AND):** Kondisi keseluruhan benar hanya jika **kedua** sisi `&&` benar (exit status 0). Jika sisi kiri gagal, sisi kanan tidak dievaluasi (short-circuiting).
* **Operator `||` (OR):** Kondisi keseluruhan benar jika **salah satu** sisi `||` benar (exit status 0). Jika sisi kiri berhasil, sisi kanan tidak dievaluasi (short-circuiting).

<!-- end list -->

```bash
#!/bin/bash

# Contoh 1: Menggabungkan kondisi dengan AND (&&)
# Membuat direktori HANYA JIKA TIDAK ADA dan file_config.txt ADA
if [[ ! -d "log_files" ]] && [[ -f "file_config.txt" ]]; then
  echo "Membuat direktori 'log_files'..."
  mkdir log_files
else
  echo "Kondisi tidak terpenuhi: direktori 'log_files' mungkin sudah ada atau 'file_config.txt' tidak ada."
fi

echo "---------------------"

# Contoh 2: Menggabungkan kondisi dengan OR (||)
# Jika user adalah 'root' ATAU grup adalah 'admin'
USER_CHECK="user1"
GROUP_CHECK="developers"

if [[ "$USER_CHECK" == "root" ]] || [[ "$GROUP_CHECK" == "admin" ]]; then
  echo "Akses diberikan sebagai pengguna istimewa atau anggota grup admin."
else
  echo "Akses ditolak."
fi
```

* **Penjelasan `[[ ! -d "log_files" ]]`:** Tanda seru `!` membalikkan hasil evaluasi. Jadi, `! -d "log_files"` berarti "jika TIDAK direktori log\_files ada".

---

### **Tambahan `else-if` dan Struktur Dasar**

```bash
if KONDISI; then
    # kode dijalankan jika kondisi BENAR
elif KONDISI_LAIN; then
    # kode dijalankan jika kondisi pertama SALAH dan kondisi ini BENAR
else
    # kode dijalankan jika semua kondisi SALAH
fi
```

---

## **Poin Penting**

1. **`if`** memulai blok pemeriksaan kondisi.
2. **`then`** menandai awal kode yang dijalankan jika kondisi bernilai *true* (exit status 0).
3. **`elif`** (`else if`) menambahkan percabangan baru, dicek hanya jika kondisi sebelumnya *false*.
4. **`else`** dijalankan hanya jika semua kondisi *false*.
5. **`fi`** menutup blok `if` — dibaca sebagai `if` terbalik.

---

## **Contoh Singkat**

```bash
#!/bin/bash

NAMA="Budi"

if [[ "$NAMA" == "Andi" ]]; then
    echo "Halo Andi!"
elif [[ "$NAMA" == "Budi" ]]; then
    echo "Hai Budi!"
else
    echo "Saya tidak kenal kamu."
fi
```

---

## **Tips Praktis**

* **Jangan lupa untuk selalu beri spasi** di dalam `[ ]` atau `[[ ]]`.
* Gunakan `[[ ... ]]` untuk skrip Bash modern karena lebih aman dan fleksibel.
* Kutip variabel (`"$VAR"`) untuk menghindari masalah jika variabel kosong atau mengandung spasi.
* Ingat bahwa Bash menganggap **exit status 0** sebagai *true*.

---

#### **3.6. Struktur `case ... esac` untuk Pencocokan Pola:**

Struktur `case` sangat berguna ketika Anda perlu membandingkan satu variabel atau ekspresi dengan beberapa pola yang berbeda. Ini adalah alternatif yang lebih bersih dan seringkali lebih efisien daripada serangkaian `if/elif/else` yang panjang.

```bash
#!/bin/bash

# Contoh: Skrip sederhana untuk mengelola layanan (start/stop/restart)
ACTION="$1" # Ambil argumen pertama sebagai aksi

case "$ACTION" in
  start)
    echo "Memulai layanan..."
    # Lakukan perintah untuk memulai layanan
    ;;
  stop)
    echo "Menghentikan layanan..."
    # Lakukan perintah untuk menghentikan layanan
    ;;
  restart)
    echo "Melakukan restart layanan..."
    # Lakukan perintah untuk restart layanan
    ;;
  *) # Default case: jika tidak ada pola yang cocok
    echo "Penggunaan: $0 {start|stop|restart}"
    exit 1
    ;;
esac

echo "Proses selesai."
```

* **Penjelasan `case ... esac`:**
  * `case "$ACTION" in`: Memulai blok `case` dan menentukan variabel yang akan dicocokkan (`$ACTION`).
  * `start)`: Ini adalah sebuah "pola". Jika nilai `$ACTION` cocok dengan "start", blok kode di bawahnya akan dieksekusi.
  * `*)`: Ini adalah pola *wildcard* yang cocok dengan apa pun. Ini berfungsi sebagai `default` atau `else` dalam blok `case`.
  * `;;`: Mengakhiri blok kode untuk setiap pola dan mencegah "fall-through" ke pola berikutnya (seperti `break` di bahasa C/Java).
  * `esac`: Menutup blok `case`. `esac` adalah `case` yang dibalik.

### **4. Terminologi Esensial & Penjelasan Detil:**

* **Kondisional (Conditional):** Struktur kontrol dalam pemrograman yang memungkinkan alur eksekusi program berubah berdasarkan evaluasi suatu kondisi (benar atau salah).
* **`if/then/elif/else/fi`:** Kata kunci yang membentuk blok kondisional `if`.
  * `if`: Memulai pernyataan kondisional.
  * `then`: Menjalankan blok kode jika kondisi `if` benar.
  * `elif` (else if): Menguji kondisi tambahan jika kondisi `if` sebelumnya salah.
  * `else`: Menjalankan blok kode jika tidak ada kondisi `if` atau `elif` yang benar.
  * `fi`: Menandai akhir dari pernyataan `if`.
* **`test` / `[`:** Perintah eksternal yang digunakan untuk mengevaluasi ekspresi kondisional.
* **`[[ ... ]]`:** Kata kunci internal Bash yang lebih modern dan disarankan untuk evaluasi ekspresi kondisional, menawarkan fitur yang lebih kaya dan penanganan yang lebih aman.
* **Operator Perbandingan:** Simbol atau kata kunci yang digunakan untuk membandingkan nilai:
  * **String:** `==` (sama), `!=` (tidak sama), `<` (kurang dari secara leksikografis), `>` (lebih dari secara leksikografis), `-z` (string kosong), `-n` (string tidak kosong).
  * **Angka:** `-eq` (sama), `-ne` (tidak sama), `-gt` (lebih besar), `-ge` (lebih besar atau sama), `-lt` (kurang dari), `-le` (kurang dari atau sama).
  * **File:** `-f` (file biasa), `-d` (direktori), `-e` (ada), `-s` (ukuran \> 0), `-r` (dapat dibaca), `-w` (dapat ditulis), `-x` (dapat dieksekusi).
* **`&&` (AND):** Operator logika boolean yang memerlukan kedua kondisi di kedua sisinya agar benar.
* **`||` (OR):** Operator logika boolean yang memerlukan setidaknya satu kondisi di kedua sisinya agar benar.
* **`case ... esac`:** Struktur kontrol yang digunakan untuk mencocokkan satu nilai dengan beberapa pola yang berbeda, menyediakan alur kontrol yang lebih bersih daripada serangkaian `if/elif` yang panjang.
* **Pola (Pattern) dalam `case`:** String atau *wildcard* yang digunakan untuk mencocokkan nilai variabel dalam pernyataan `case`.
* **Short-circuiting:** Perilaku operator `&&` dan `||` di mana evaluasi kondisi di sisi kanan dihentikan jika hasil akhir sudah dapat ditentukan dari sisi kiri (misalnya, jika sisi kiri `&&` gagal, tidak perlu mengevaluasi sisi kanan).

### **5. Rekomendasi Visualisasi (Jika Diperlukan):**

* **Diagram Alur `if/else/elif`:** Sebuah *flowchart* yang menunjukkan alur eksekusi berdasarkan kondisi yang dievaluasi (misalnya, berbentuk *diamond* untuk keputusan).
* **Tabel Perbandingan Operator:** Tabel ringkas yang membandingkan operator string, numerik, dan file untuk `[ ]` dan `[[ ]]` akan sangat membantu referensi cepat.
* **Diagram Alur `case` Statement:** Sebuah *flowchart* yang menggambarkan bagaimana nilai dicocokkan dengan pola dan alur eksekusi bercabang.

### **6. Hubungan dengan Modul Lain:**

Modul ini adalah batu loncatan yang esensial. Konsep *exit codes* yang didalami di sini akan menjadi fondasi utama untuk Modul 3.1 (Penanganan Kesalahan) di mana Anda akan belajar bagaimana merancang skrip yang robust terhadap kegagalan. Logika kondisional ini juga mutlak diperlukan untuk Modul 2.2 (Perulangan) karena Anda akan sering menggunakan kondisi untuk mengontrol kapan perulangan harus berhenti atau berlanjut. Selain itu, dalam Modul 2.3 (Fungsi), Anda akan menerapkan kondisional di dalam fungsi untuk memvalidasi input atau mengontrol perilaku fungsi. Logika pengambilan keputusan ini akan menjadi bagian integral dari setiap skrip yang lebih kompleks di Fase 3 dan 4.

### **7. Sumber Referensi Lengkap:**

* **Bash Conditional Expressions (Bash Manual):** [https://www.gnu.org/software/bash/manual/html\_node/Bash-Conditional-Expressions.html](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)
  * **Detail:** Sumber resmi dan definitif. Ini menjelaskan secara teknis semua operator dan sintaks untuk ekspresi kondisional di Bash. Mungkin agak padat, tetapi sangat akurat.
* **Greg's Wiki - BashFAQ/031 (if/test):** [https://mywiki.wooledge.org/BashFAQ/031](https://mywiki.wooledge.org/BashFAQ/031)
  * **Detail:** Sebuah wiki yang sangat dihargai di komunitas Bash. Artikel ini membahas perbedaan dan praktik terbaik antara `[` dan `[[`, serta alasan di balik rekomendasi penggunaan `[[ ]]`. Wajib dibaca.
* **Bash Conditional Statements (Linuxize):** [https://linuxize.com/howto/bash-if-else/](https://linuxize.com/howto/bash-if-else/)
  * **Detail:** Tutorial yang lebih ramah pemula dengan banyak contoh praktis untuk `if/else/elif`.
* **Bash Case Statement (Linuxize):** [https://linuxize.com/howto/bash-case-statement/](https://linuxize.com/howto/bash-case-statement/)
  * **Detail:** Tutorial yang baik untuk memahami dan menguasai penggunaan pernyataan `case`.
* **Bash Arithmetic Expansion (Bash Manual):** [https://www.gnu.org/software/bash/manual/html\_node/Arithmetic-Expansion.html](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html)
  * **Detail Tambahan (opsional):** Bagian dari manual Bash yang menjelaskan `((...))` secara mendalam, termasuk operator yang didukung dan perilakunya.

### **8. Tips dan Praktik Terbaik:**

* **Pilih `[[ ... ]]`:** Untuk skrip Bash modern, `[[ ... ]]` adalah pilihan yang lebih aman dan kuat dibandingkan `[ ... ]`.
* **Gunakan Kutipan Ganda:** Selalu kutip ganda variabel Anda dalam ekspresi kondisional (misalnya, `[[ "$VARIABEL" == "nilai" ]]`) untuk mencegah masalah *word splitting* atau *globbing* yang tidak diinginkan, terutama jika variabel mungkin berisi spasi atau karakter khusus.
* **Periksa Status Keluar:** Biasakan untuk memeriksa `$?` setelah perintah penting, terutama dalam skrip yang lebih besar, atau gunakan `if` untuk membungkus perintah yang bisa gagal.
* **Prioritaskan `case` untuk Multiple Options:** Jika Anda memiliki banyak cabang `if/elif` yang membandingkan satu variabel dengan banyak nilai, `case` seringkali adalah solusi yang lebih bersih dan lebih mudah dibaca.
* **Berikan Pesan Error yang Informatif:** Ketika skrip Anda mengalami kondisi yang tidak valid, berikan pesan error yang jelas kepada pengguna (seringkali ke `stderr` menggunakan `>&2`) dan keluar dengan *exit status* non-nol (`exit 1`).

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Lupa spasi di sekitar kurung siku `[` dan `]`.
  * **Contoh:** `if ["$VAR" == "val"]` (salah)
  * **Solusi:** Harus ada spasi di dalam kurung siku: `if [ "$VAR" == "val" ]`. Ini karena `[` sebenarnya adalah perintah.
* **Kesalahan:** Menggunakan operator perbandingan string (`==`, `!=`) untuk angka dalam `[ ]` atau `[[ ]]` alih-alih operator numerik (`-eq`, `-gt`).
  * **Contoh:** `if [[ $ANGKA == 10 ]]` (secara teknis akan berfungsi jika angka adalah string yang mewakili angka, tetapi ini adalah perbandingan *string*, bukan numerik).
  * **Solusi:** Gunakan `if (( $ANGKA == 10 ))` atau `if [[ $ANGKA -eq 10 ]]`. Perbandingan string `==` akan membandingkan "10" dan "2" sebagai string, sehingga "10" mungkin dianggap "lebih kecil" dari "2" secara leksikografis (seperti dalam kamus), yang salah secara numerik.
* **Kesalahan:** Tidak mengutip ganda variabel dalam kondisional, menyebabkan masalah dengan spasi atau *wildcard*.
  * **Contoh:** `if [ $FILE == *.txt ]` (akan gagal jika `$FILE` berisi spasi atau *wildcard* tidak ditangani dengan benar).
  * **Solusi:** Selalu kutip ganda: `if [[ "$FILE" == *.txt ]]` (dalam `[[ ]]` *pattern matching* sudah didukung) atau `if [ -f "$FILE" ]` untuk memeriksa keberadaan file.
* **Kesalahan:** Lupa `;;` di setiap kasus dalam pernyataan `case`.
  * **Solusi:** Ini akan menyebabkan "fall-through", di mana kode dari pola berikutnya juga dieksekusi. Selalu pastikan ada `;;` untuk mengakhiri setiap blok kasus.
* **Kesalahan:** Menggunakan operator `&&` atau `||` di luar `[[ ... ]]` atau tanpa memahami *short-circuiting*.
  * **Contoh:** `if [ kondisi1 && kondisi2 ]` (salah, `&&` bukanlah operator yang dikenali oleh `[`).
  * **Solusi:** Gunakan `if [[ kondisi1 && kondisi2 ]]` (disarankan) atau `if kondisi1 && kondisi2; then ...` (jika kondisi adalah perintah). Pahami bahwa `&&` dan `||` di luar `[[ ]]` bertindak sebagai operator kontrol eksekusi perintah (jalankan perintah berikutnya hanya jika yang ini berhasil/gagal), bukan operator boolean untuk ekspresi tunggal.

-----

Dengan penjelasan mendalam ini untuk Modul 2.1, saya harap Anda mendapatkan pemahaman yang sangat komprehensif tentang struktur kondisional di Bash. Modul berikut ini akan mengajarkan Anda bagaimana mengotomatiskan tugas-tugas berulang, sebuah konsep inti dalam *shell scripting* dan pemrograman secara umum.

-----

**Tujuan Fase:** Menguasai elemen-elemen pemrograman standar (kondisional, perulangan, fungsi) dan menggunakan alat bantu teks yang kuat untuk memproses data.

-----

## **Modul 2.2: Perulangan (Loops)**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Filosofi Otomasi Berulang
2. Perulangan `for` (Berbasis Daftar)
3. Perulangan `for` (Gaya C: `for ((i=0; i<5; i++))`)
4. Perulangan `while`
5. Perulangan `until`
6. Pola yang Benar untuk Membaca File Baris demi Baris
7. Mengontrol Perulangan: `break` dan `continue`
8. Potensi Penambahan Materi: `select` loop (untuk menu interaktif sederhana)

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Modul ini adalah tentang bagaimana Anda dapat menginstruksikan skrip Anda untuk mengulang serangkaian perintah berkali-kali. Bayangkan Anda memiliki 100 file log yang perlu diproses, atau Anda perlu terus memantau suatu kondisi sampai terpenuhi. Di sinilah perulangan berperan. Anda akan mempelajari berbagai jenis perulangan: `for` untuk iterasi melalui daftar item, dan `while`/`until` untuk mengulang berdasarkan suatu kondisi.

Perulangan adalah pilar fundamental otomasi. Daripada menjalankan perintah yang sama secara manual berulang kali, Anda dapat menginstruksikan shell untuk melakukannya untuk Anda, menghemat waktu, mengurangi kesalahan manusia, dan meningkatkan efisiensi. Ini adalah salah satu konsep terpenting yang akan Anda pelajari dalam *shell scripting*, memungkinkan Anda untuk menulis skrip yang jauh lebih kuat dan scalable. Dalam pengembangan Dart/Flutter, konsep perulangan digunakan secara ekstensif untuk memproses daftar data, membangun antarmuka pengguna secara dinamis, atau mengelola siklus hidup suatu proses. Memahami bagaimana perulangan bekerja di Bash akan memperkuat pemahaman Anda tentang prinsip-prinsip umum ini.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. DRY (Don't Repeat Yourself) Principle:**

Prinsip "Jangan Mengulang Diri Sendiri" adalah filosofi inti di balik perulangan. Jika Anda menemukan diri Anda menulis kode yang sama berulang kali dengan sedikit variasi, itu adalah tanda bahwa perulangan atau fungsi (Modul 2.3) mungkin diperlukan. Perulangan memungkinkan Anda untuk menulis logika sekali dan menerapkannya ke banyak item atau selama kondisi tertentu.

#### **2.2. Iterasi vs. Kondisi:**

* **Perulangan Iteratif (`for`):** Dirancang untuk mengulang melalui kumpulan item yang sudah diketahui atau dapat dihitung (misalnya, daftar file, baris dalam file, angka dalam rentang). Fokusnya adalah pada setiap "item" dalam koleksi.
* **Perulangan Kondisional (`while`, `until`):** Dirancang untuk mengulang selama atau sampai suatu kondisi terpenuhi. Fokusnya adalah pada kondisi "true" atau "false". Ini berguna untuk menunggu sesuatu terjadi, membaca input terus-menerus, atau menjalankan tugas secara berkala.

#### **2.3. Aliran Kontrol yang Dinamis:**

Perulangan, bersama dengan kondisional dari Modul 2.1, membentuk inti dari "aliran kontrol" dalam skrip Anda. Mereka memungkinkan skrip Anda untuk tidak hanya membuat keputusan, tetapi juga untuk melakukan tindakan berulang berdasarkan keputusan tersebut. Ini mengubah skrip dari sekumpulan perintah statis menjadi program yang dinamis dan interaktif.

#### **2.4. Pentingnya `IFS` (Internal Field Separator):**

Ketika Bash membaca input (terutama dalam perulangan `while` atau ketika memisahkan kata), ia menggunakan variabel lingkungan khusus bernama `IFS`. Secara *default*, `IFS` berisi spasi, tab, dan *newline*. Memahami dan kadang-kadang memanipulasi `IFS` sangat penting untuk membaca data dengan benar, terutama dari file CSV atau file dengan nama yang mengandung spasi.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Perulangan `for` (Berbasis Daftar):**

Perulangan `for` adalah cara yang paling umum untuk mengulang melalui daftar item (kata-kata, file, string, dll.).

**Sintaks Umum:**

```bash
for VAR_NAME in item1 item2 "item dengan spasi" itemN; do
  # Perintah yang akan dijalankan untuk setiap item
  # VAR_NAME akan berisi item saat ini dalam setiap iterasi
done
```

**Contoh 1: Iterasi pada Daftar String:**

```bash
#!/bin/bash

echo "Daftar Buah:"
for BUAH in apel jeruk mangga pisang; do
  echo "Saya suka $BUAH"
done

echo "-------------------"

# Contoh 2: Iterasi pada File di Direktori Saat Ini
# Ini adalah cara yang umum dan sangat berguna untuk memproses banyak file.
echo "Memproses file teks di direktori ini:"
for FILE in *.txt; do
  if [[ -f "$FILE" ]]; then # Pastikan itu benar-benar file
    echo "Mencadangkan file: $FILE"
    cp "$FILE" "$FILE.bak"
  else
    echo "Tidak ada file .txt ditemukan atau $FILE bukan file biasa."
  fi
done

echo "-------------------"

# Contoh 3: Iterasi pada Output Perintah (menggunakan Command Substitution)
echo "Daftar pengguna sistem:"
for USERNAME in $(cut -d: -f1 /etc/passwd); do
  echo "Pengguna: $USERNAME"
done
```

* **Penjelasan:**
  * `for BUAH in apel jeruk mangga pisang;`: Mendefinisikan perulangan. `BUAH` adalah nama variabel yang akan mengambil nilai setiap item dari daftar `apel jeruk mangga pisang` secara berurutan.
  * `do`: Menandai awal blok kode perulangan.
  * `done`: Menandai akhir blok kode perulangan.
  * `$(cut -d: -f1 /etc/passwd)`: Ini adalah *command substitution* (Modul 1.3). *Output* dari perintah `cut` (yang mengekstrak nama pengguna dari `/etc/passwd`) akan dipecah menjadi kata-kata (berdasarkan `IFS`) dan digunakan sebagai daftar untuk perulangan `for`.

#### **3.2. Perulangan `for` (Gaya C: `for ((i=0; i<5; i++))`):**

Bash mendukung perulangan `for` bergaya C yang akrab bagi programmer dari bahasa C, Java, JavaScript, atau Dart. Ini sangat berguna untuk iterasi berbasis angka.

**Sintaks Umum:**

```bash
for (( INISIALISASI; KONDISI; PENINGKATAN )); do
  # Perintah yang akan dijalankan
done
```

**Contoh:**

```bash
#!/bin/bash

echo "Menghitung mundur dari 5:"
for (( I=5; I>=0; I-- )); do
  echo "Hitungan: $I"
done

echo "-------------------"

echo "Mencetak angka genap dari 0 hingga 10:"
for (( J=0; J<=10; J+=2 )); do
  echo "Angka genap: $J"
done
```

* **Penjelasan:**
  * `(( I=5; I>=0; I-- ))`: Bagian aritmatika.
    * `I=5`: Inisialisasi variabel `I` menjadi 5.
    * `I>=0`: Kondisi yang harus benar agar perulangan berlanjut.
    * `I--`: Ekspresi peningkatan (decrement) yang dijalankan setelah setiap iterasi.
  * **Penting:** Variabel dalam perulangan gaya C tidak perlu diawali dengan `$`, meskipun Anda bisa menggunakannya (`$I`) di dalam blok `do...done` untuk mengakses nilainya.

#### **3.3. Perulangan `while`:**

Perulangan `while` terus berjalan selama kondisi tertentu bernilai benar (exit status 0).

**Sintaks Umum:**

```bash
while kondisi; do
  # Perintah yang akan dijalankan selama kondisi benar
done
```

**Contoh 1: Mengulang sampai suatu file ada:**

```bash
#!/bin/bash

FILE_YANG_DITUNGGU="data_yang_siap.txt"

echo "Menunggu file '$FILE_YANG_DITUNGGU' muncul..."
while [[ ! -f "$FILE_YANG_DITUNGGU" ]]; do
  echo "File belum ada, menunggu 5 detik..."
  sleep 5 # Menunggu selama 5 detik
done
echo "File '$FILE_YANG_DITUNGGU' ditemukan! Melanjutkan skrip..."
```

* **Penjelasan:**
  * `while [[ ! -f "$FILE_YANG_DITUNGGU" ]];`: Kondisi di sini menggunakan tes file dari Modul 2.1. Perulangan akan terus berjalan selama file `data_yang_siap.txt` TIDAK ADA (`! -f`).
  * `sleep 5`: Perintah untuk menunda eksekusi skrip selama 5 detik.

**Contoh 2: Mengulang selama input pengguna tidak valid:**

```bash
#!/bin/bash

VALID_INPUT="false"

while [[ "$VALID_INPUT" == "false" ]]; do
  read -p "Masukkan 'ya' atau 'tidak': " RESPON
  if [[ "$RESPON" == "ya" ]] || [[ "$RESPON" == "tidak" ]]; then
    VALID_INPUT="true"
    echo "Input Anda valid: $RESPON"
  else
    echo "Input tidak valid. Silakan coba lagi."
  fi
done
```

* **Penjelasan `read -p "Prompt: " VAR`:** Perintah `read` membaca baris dari *standard input* dan menyimpannya ke variabel `VAR`. Opsi `-p` menampilkan *prompt* sebelum membaca input.

#### **3.4. Perulangan `until`:**

Perulangan `until` adalah kebalikan dari `while`. Ini terus berjalan selama kondisi tertentu bernilai **salah** (exit status non-0).

**Sintaks Umum:**

```bash
until kondisi; do
  # Perintah yang akan dijalankan selama kondisi salah
done
```

**Contoh:**

```bash
#!/bin/bash

# Contoh yang sama dengan while, tapi dengan until
KONTEN_PENTING="Laporan Akhir"
FILE_LAPORAN="laporan.txt"

echo "Menunggu file '$FILE_LAPORAN' berisi '$KONTEN_PENTING'..."
until grep -q "$KONTEN_PENTING" "$FILE_LAPORAN"; do
  echo "Konten belum ditemukan, menunggu 10 detik..."
  sleep 10
done
echo "Konten ditemukan di '$FILE_LAPORAN'! Melanjutkan proses..."
```

* **Penjelasan:**
  * `until grep -q "$KONTEN_PENTING" "$FILE_LAPORAN";`: Perulangan ini akan terus berjalan `until` (sampai) perintah `grep` berhasil menemukan string `$KONTEN_PENTING` dalam `$FILE_LAPORAN`. Opsi `-q` pada `grep` berarti "quiet", yaitu tidak mencetak baris yang cocok, hanya mengembalikan *exit status* (0 jika ditemukan, 1 jika tidak ditemukan).

#### **3.5. Pola yang Benar untuk Membaca File Baris demi Baris:**

Membaca file baris demi baris adalah tugas umum, dan ada cara yang benar dan salah. Cara yang paling aman dan efisien adalah menggunakan perulangan `while read` yang dialihkan inputnya dari file. Ini penting karena mengatasi masalah spasi dalam nama file atau baris, serta efisiensi.

**Sintaks Umum:**

```bash
while IFS= read -r VAR_BARIS; do
  # Perintah yang akan dijalankan untuk setiap baris
  # VAR_BARIS akan berisi isi baris saat ini
done < nama_file.txt
```

**Contoh:**

Misalkan Anda memiliki file `data.csv` dengan konten:

```
Nama Lengkap,Usia,Kota
Alice Smith,30,New York
Bob Johnson,25,London
Charlie Brown,35,Paris,France
```

```bash
#!/bin/bash

FILE_CSV="data.csv"

echo "Membaca file CSV baris demi baris:"
# Menggunakan IFS untuk memisahkan kolom berdasarkan koma, dan read -r untuk mencegah backslash interpretation
# read -a array_name bisa digunakan untuk array
while IFS=',' read -r NAMA USIA KOTA SISA; do
  # Lewati baris header jika ada
  if [[ "$NAMA" == "Nama Lengkap" ]]; then
    continue # Lanjutkan ke iterasi berikutnya
  fi
  echo "Nama: $NAMA, Usia: $USIA, Kota: $KOTA"
  if [[ -n "$SISA" ]]; then # Jika ada sisa kolom
      echo "  (Ada data sisa: $SISA)"
  fi
done < "$FILE_CSV"
```

* **Penjelasan `while IFS= read -r VAR_BARIS; do ... done < FILE`:**
  * `while`: Memulai perulangan.
  * `IFS=`: Menyetel `IFS` ke string kosong **hanya untuk perintah `read` ini**. Ini mencegah Bash memecah baris berdasarkan spasi atau tab, sehingga seluruh baris (termasuk spasi di dalamnya) dibaca ke `VAR_BARIS`. Ini sangat krusial saat baris berisi spasi.
  * `read -r VAR_BARIS`: Perintah `read` akan membaca satu baris dari *standard input* dan menyimpannya ke variabel `VAR_BARIS`. Opsi `-r` (raw) mencegah interpretasi *backslash escape sequences*, memastikan baris dibaca secara literal. Anda juga bisa menyediakan beberapa nama variabel (misal: `read -r NAMA USIA`) dan `read` akan memecah baris berdasarkan `IFS` untuk mengisi variabel-variabel tersebut.
  * `done < "$FILE_CSV"`: Ini adalah *input redirection* (Modul 1.2) yang mengarahkan konten `$FILE_CSV` sebagai *standard input* untuk perulangan `while` secara keseluruhan. Ini lebih efisien daripada `cat "$FILE_CSV" | while read ...` karena menghindari proses `cat` terpisah dan *subshell* yang kadang tidak diinginkan.

#### **3.6. Mengontrol Perulangan: `break` dan `continue`:**

* **`break`:** Menghentikan eksekusi perulangan secara keseluruhan dan melompat ke perintah pertama setelah blok `done` (atau `esac` untuk `case`).

    ```bash
    #!/bin/bash

    for I in 1 2 3 4 5 6 7 8 9 10; do
      if (( I == 5 )); then
        echo "Angka 5 ditemukan, menghentikan perulangan."
        break
      fi
      echo "Memproses angka: $I"
    done
    echo "Perulangan selesai."
    ```

* **`continue`:** Melewatkan sisa iterasi saat ini dan melompat ke awal iterasi berikutnya.

    ```bash
    #!/bin/bash

    for I in 1 2 3 4 5 6 7 8 9 10; do
      if (( I % 2 != 0 )); then # Jika angka ganjil
        echo "Melewatkan angka ganjil: $I"
        continue # Lewati sisa kode untuk iterasi ini
      fi
      echo "Memproses angka genap: $I"
    done
    echo "Perulangan selesai."
    ```

### **4. Terminologi Esensial & Penjelasan Detil:**

* **Perulangan (Loop):** Struktur kontrol yang memungkinkan serangkaian perintah dieksekusi berulang kali.
* **`for` loop:** Perulangan yang mengulang melalui daftar item yang telah ditentukan atau pada rentang numerik (gaya C).
* **`while` loop:** Perulangan yang terus berjalan selama kondisi tertentu bernilai benar (exit status 0).
* **`until` loop:** Perulangan yang terus berjalan selama kondisi tertentu bernilai salah (exit status non-0).
* **Iterasi:** Satu siklus eksekusi dari blok kode dalam sebuah perulangan.
* **`IFS` (Internal Field Separator):** Variabel lingkungan khusus yang digunakan Bash untuk menentukan bagaimana string dipecah menjadi kata-kata (misalnya, untuk perulangan `for` tanpa kutipan, atau perintah `read`). Secara *default* berisi spasi, tab, dan *newline*.
* **`read`:** Perintah Bash yang membaca satu baris dari *standard input* dan menyimpannya ke satu atau lebih variabel.
  * `-r`: Opsi pada `read` yang mencegah *backslash escapes* agar string dibaca secara literal.
  * `-p`: Opsi pada `read` untuk menampilkan *prompt* sebelum membaca input.
* **`sleep`:** Perintah untuk menunda eksekusi skrip selama sejumlah detik yang ditentukan.
* **`break`:** Perintah yang digunakan di dalam perulangan untuk segera menghentikan eksekusi perulangan dan melanjutkan ke perintah setelah perulangan.
* **`continue`:** Perintah yang digunakan di dalam perulangan untuk melewati sisa iterasi saat ini dan melompat ke awal iterasi berikutnya.

### **5. Rekomendasi Visualisasi (Jika Diperlukan):**

* **Diagram Alur Perulangan `for` (Daftar):** Tunjukkan bagaimana setiap item dari daftar diambil satu per satu dan diproses dalam blok perulangan.
* **Diagram Alur Perulangan `while`/`until`:** Sebuah *flowchart* dengan kotak kondisi di awal perulangan, menunjukkan panah kembali ke kondisi jika benar (untuk `while`) atau salah (untuk `until`).
* **Visualisasi `IFS`:** Diagram yang menunjukkan bagaimana string "Kata dengan Spasi" dipecah menjadi "Kata", "dengan", "Spasi" jika `IFS` adalah spasi, dan bagaimana `IFS=` menjaga string tetap utuh.

### **6. Hubungan dengan Modul Lain:**

Modul perulangan ini secara langsung membangun di atas **Modul 1.3 (Variabel dan Ekspansi)** karena perulangan seringkali memanipulasi dan memproses variabel, serta menggunakan *command substitution* untuk membuat daftar iterasi. Koneksinya dengan **Modul 2.1 (Struktur Kondisional)** sangat kuat; kondisi seringkali digunakan sebagai pengendali utama untuk perulangan `while` dan `until`, dan pernyataan `if` sering ditemukan di dalam perulangan untuk membuat keputusan pada setiap iterasi. Pemahaman yang kuat tentang perulangan akan menjadi prasyarat untuk **Modul 2.3 (Fungsi)**, di mana fungsi mungkin berisi perulangan, dan untuk semua skrip otomasi yang lebih kompleks di Fase 3 dan 4, seperti memproses file log, manajemen pengguna, atau *deployment* otomatis.

### **7. Sumber Referensi Lengkap:**

* **Bash Loops (ryanstutorials.net):** [https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php](https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php)
  * **Detail:** Tutorial yang sangat baik untuk pemula, menjelaskan berbagai jenis perulangan dengan contoh-contoh yang jelas dan mudah dipahami.
* **Greg's Wiki - BashFAQ/001 (Reading a file line-by-line):** [https://mywiki.wooledge.org/BashFAQ/001](https://mywiki.wooledge.org/BashFAQ/001)
  * **Detail:** Sumber daya kritis yang menjelaskan cara terbaik (dan cara yang salah) untuk membaca file baris demi baris di Bash, termasuk detail tentang `IFS` dan `read -r`. Wajib dibaca untuk menghindari masalah umum.
* **The Linux Command Line: A Complete Introduction (William E. Shotts, Jr.):** [http://linuxcommand.org/tlcl.php](http://linuxcommand.org/tlcl.php)
  * **Detail:** Buku gratis yang sangat direkomendasikan. Bab tentang perulangan menyediakan penjelasan yang solid dan latihan praktis.
* **Advanced Bash-Scripting Guide (Mendel Cooper):** [https://tldp.org/LDP/abs/html/loops.html](https://tldp.org/LDP/abs/html/loops.html)
  * **Detail:** Bagian tentang perulangan dari panduan Bash yang lebih mendalam. Ini mencakup detail teknis dan contoh yang lebih kompleks.
* **Bash Manual: Loop Commands:** [https://www.gnu.org/software/bash/manual/bash.html\#Loop-Commands](https://www.gnu.org/software/bash/manual/bash.html%23Loop-Commands)
  * **Detail Tambahan (opsional):** Dokumentasi resmi Bash tentang perintah perulangan. Referensi definitif untuk semua opsi dan perilaku.

### **8. Tips dan Praktik Terbaik:**

* **Selalu Kutip Ganda Variabel:** Saat menggunakan variabel dalam daftar `for` atau dalam kondisi `while`/`until`, selalu kutip ganda variabel Anda (`"$VAR"`) untuk mencegah *word splitting* atau *pathname expansion* yang tidak diinginkan, terutama jika variabel mungkin berisi spasi atau karakter khusus.
* **Gunakan `read -r` untuk Keandalan:** Saat membaca dari file, selalu gunakan `read -r` untuk mencegah Bash menafsirkan *backslash* dalam data Anda.
* **Pahami `IFS`:** Jika Anda memproses data yang dipisahkan oleh karakter selain spasi, tab, atau *newline* (misalnya, CSV), manipulasi `IFS` secara lokal untuk perintah `read` (contoh `IFS=',' read -r ...`) adalah praktik terbaik.
* **Hindari `ls | while read`:** Pola `for FILE in $(ls)` atau `ls | while read FILE` seringkali bermasalah jika nama file mengandung spasi atau karakter khusus. Lebih baik gunakan `for FILE in *` (jika hanya file di direktori saat ini) atau `find ... -print0 | xargs -0` untuk kasus yang lebih kompleks (akan dibahas di modul manipulasi teks).
* **Gunakan `sleep` untuk Polling:** Jika Anda menunggu suatu kondisi terpenuhi (misalnya, file muncul), gunakan `sleep` di dalam perulangan untuk menghindari *busy-waiting* yang membebani CPU.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Menggunakan `for FILE in $(ls)` atau ` for FILE in `ls\`\`.
  * **Masalah:** Ini akan gagal jika nama file memiliki spasi atau karakter *globbing* (misal `*`, `?`, `[`). *Output* `ls` dipecah oleh `IFS`, sehingga nama file seperti "My Document.txt" akan menjadi "My" dan "Document.txt".
  * **Solusi:**
    * Untuk file di direktori saat ini: `for FILE in *; do ... "$FILE" ...; done`.
    * Untuk mencari file secara rekursif: `find . -print0 | while IFS= read -r -d $'\0' FILE; do ... "$FILE" ...; done`. (Ini lebih kompleks, akan dibahas mendalam di modul manipulasi teks).
* **Kesalahan:** Lupa `do` atau `done` dalam perulangan.
  * **Solusi:** Bash akan menampilkan kesalahan sintaks. Pastikan struktur `for ... do ... done`, `while ... do ... done`, dan `until ... do ... done` lengkap.
* **Kesalahan:** Perulangan tak terbatas (Infinite Loop).
  * **Penyebab:** Kondisi `while` selalu benar, atau kondisi `until` selalu salah, dan tidak ada mekanisme untuk mengubahnya di dalam perulangan.
  * **Contoh:** `while true; do echo "Hello"; done` (tanpa `break` atau cara `true` menjadi `false`).
  * **Solusi:** Selalu pastikan ada cara bagi kondisi untuk akhirnya terpenuhi atau gagal, atau gunakan `break` untuk keluar secara kondisional. Tekan `Ctrl+C` di terminal untuk menghentikan perulangan tak terbatas secara manual.
* **Kesalahan:** Tidak mengutip variabel yang digunakan dalam kondisi perulangan (terutama string).
  * **Penyebab:** Jika variabel kosong atau berisi spasi, ini dapat menyebabkan kesalahan sintaks atau perilaku tak terduga dalam evaluasi kondisi.
  * **Solusi:** Selalu gunakan kutipan ganda: `while [[ "$COUNT" -lt 10 ]]` atau `while [[ -n "$INPUT_VAR" ]]`.
* **Kesalahan:** Variabel yang didefinisikan di dalam `while read` tidak terlihat di luar perulangan.
  * **Penyebab:** Jika Anda menggunakan `cat file | while read ...`, perulangan `while` berjalan di *subshell* terpisah. Variabel yang dimodifikasi di *subshell* tidak akan memengaruhi *shell* induk.
  * **Solusi:** Gunakan *input redirection* langsung ke perulangan `while`: `while IFS= read -r VAR; do ... done < file.txt`. Ini membuat `while` berjalan di *shell* yang sama.

-----

Dengan penjelasan mendalam ini untuk Modul 2.2, Anda sekarang memiliki pemahaman yang kuat tentang berbagai jenis perulangan dan bagaimana menggunakannya untuk otomasi tugas berulang.

Modul berikut ini adalah tentang bagaimana Anda dapat mengorganisir kode Anda agar lebih mudah dikelola, digunakan kembali, dan di-*debug*.

-----

# **Fase 2: Menengah – Struktur, Kontrol, dan Manipulasi Teks (Tingkat Menengah)**

**Tujuan Fase:** Menguasai elemen-elemen pemrograman standar (kondisional, perulangan, fungsi) dan menggunakan alat bantu teks yang kuat untuk memproses data.

-----

## **Modul 2.3: Fungsi dan Cakupan (Scoping)**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Filosofi DRY (Don't Repeat Yourself)
2. Sintaks Deklarasi Fungsi
3. Melewatkan Argumen ke Fungsi (Positional Parameters)
4. Mengembalikan Nilai dari Fungsi (Melalui Exit Codes dan `stdout`)
5. Cakupan Variabel: Global vs. Lokal (`local`)
6. Membuat Pustaka Fungsi (Sourcing Scripts)
7. Potensi Penambahan Materi: Exporting Functions (`export -f`)

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Dalam modul ini, Anda akan belajar bagaimana mengemas serangkaian perintah ke dalam unit-unit yang diberi nama yang disebut **fungsi**. Fungsi seperti "mini-skrip" dalam skrip Anda; mereka melakukan tugas tertentu dan dapat dipanggil berkali-kali dari berbagai tempat. Anda juga akan memahami konsep **cakupan (scoping)**, yaitu di mana variabel dapat diakses—apakah di seluruh skrip (global) atau hanya di dalam fungsi (lokal).

Peran modul ini sangat krusial untuk membuat skrip Anda menjadi lebih terstruktur, mudah dibaca, di-*debug*, dan yang terpenting, mudah digunakan kembali. Alih-alih menulis ulang blok kode yang sama berulang kali (melanggar prinsip DRY), Anda akan mendefinisikannya sekali sebagai fungsi. Ini adalah langkah maju yang signifikan dari perulangan (Modul 2.2) dan kondisional (Modul 2.1), karena sekarang Anda dapat mengelompokkan logika-logika tersebut ke dalam unit modular. Dalam konteks pengembangan Dart/Flutter, penggunaan fungsi dan pemahaman cakupan variabel adalah inti dari setiap aplikasi modern, dari *method* pada *class* hingga fungsi *utility* sederhana.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Prinsip DRY (Don't Repeat Yourself):**

Ini adalah prinsip fundamental dalam rekayasa perangkat lunak. Jika Anda menulis blok kode yang sama lebih dari satu kali, Anda harus mempertimbangkan untuk mengubahnya menjadi fungsi. Manfaatnya:

* **Maintainability:** Perubahan atau perbaikan bug hanya perlu dilakukan di satu tempat (fungsi).
* **Readability:** Kode menjadi lebih bersih dan lebih mudah dipahami karena tugas-tugas kompleks dipecah menjadi unit-unit yang lebih kecil dan diberi nama yang jelas.
* **Reusability:** Fungsi yang ditulis dengan baik dapat digunakan kembali di skrip lain atau dalam bagian skrip yang berbeda.

#### **2.2. Modularitas dan Abstraksi:**

Fungsi memungkinkan Anda untuk memecah masalah besar menjadi masalah-masalah yang lebih kecil dan lebih mudah dikelola. Setiap fungsi dapat berfokus pada satu tugas spesifik. Ini adalah bentuk **modularitas**. Selain itu, fungsi menyediakan tingkat **abstraksi**: pengguna fungsi (atau bagian lain dari skrip) tidak perlu tahu bagaimana fungsi tersebut bekerja secara internal, hanya perlu tahu apa yang dilakukannya dan bagaimana cara menggunakannya.

#### **2.3. Cakupan Variabel: Membatasi Risiko Side Effects:**

Memahami cakupan variabel adalah kritis untuk menulis skrip yang stabil dan bebas bug. Variabel global dapat secara tidak sengaja diubah oleh bagian lain dari skrip, menyebabkan *bug* yang sulit dilacak. Variabel lokal, di sisi lain, terbatas pada konteks fungsi tempat mereka didefinisikan, mengurangi risiko "efek samping" yang tidak diinginkan. Ini adalah konsep universal dalam pemrograman.

#### **2.4. Fungsi sebagai Perintah:**

Di Bash, fungsi pada dasarnya bertindak seperti perintah internal. Anda dapat memanggilnya dengan nama mereka, dan mereka menerima argumen posisi dan mengembalikan *exit status* sama seperti perintah eksternal.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Sintaks Deklarasi Fungsi:**

Ada dua cara untuk mendeklarasikan fungsi di Bash, keduanya memiliki fungsionalitas yang sama.

**Sintaks 1 (Direkomendasikan - Lebih Umum):**

```bash
function nama_fungsi {
  # Blok kode fungsi
  # Perintah-perintah yang akan dieksekusi saat fungsi dipanggil
}
```

**Sintaks 2 (Alternatif - Kompatibel POSIX sh):**

```bash
nama_fungsi () {
  # Blok kode fungsi
}
```

**Contoh Sederhana:**

```bash
#!/bin/bash

# Deklarasi fungsi sederhana
pesan_selamat_datang() {
  echo "Selamat datang di skrip otomasi saya!"
  echo "Semoga hari Anda menyenangkan."
}

# Memanggil fungsi
pesan_selamat_datang
echo "---"
pesan_selamat_datang # Bisa dipanggil berulang kali
```

* **Penjelasan:**
  * `pesan_selamat_datang()`: Mendefinisikan fungsi bernama `pesan_selamat_datang`. Tanda kurung kosong `()` menunjukkan bahwa ini adalah deklarasi fungsi.
  * `{ ... }`: Melingkupi blok kode yang merupakan tubuh fungsi.
  * Untuk memanggil fungsi, cukup ketik nama fungsinya.

#### **3.2. Melewatkan Argumen ke Fungsi (Positional Parameters):**

Fungsi dapat menerima argumen dengan cara yang sama seperti skrip menerima argumen baris perintah, yaitu melalui *variabel posisi* (`$1`, `$2`, `$@`, `$*`, `$#`).

```bash
#!/bin/bash

# Fungsi untuk membuat dan mengelola direktori
buat_direktori_log() {
  local DIR_NAME="$1" # Argumen pertama adalah nama direktori
  local LOG_FILE="$2" # Argumen kedua adalah nama file log

  if [[ -z "$DIR_NAME" ]]; then
    echo "Error: Nama direktori diperlukan." >&2
    return 1 # Keluar dari fungsi dengan status error
  fi

  if mkdir -p "$DIR_NAME"; then
    echo "Direktori '$DIR_NAME' berhasil dibuat atau sudah ada."
    if [[ -n "$LOG_FILE" ]]; then
      touch "$DIR_NAME/$LOG_FILE"
      echo "File log '$LOG_FILE' dibuat di '$DIR_NAME'."
    fi
    return 0
  else
    echo "Gagal membuat direktori '$DIR_NAME'." >&2
    return 1
  fi
}

# Memanggil fungsi dengan argumen
buat_direktori_log "aplikasi_log" "error.log"
echo "Status keluar dari panggilan fungsi 1: $?"

echo "---"

buat_direktori_log "data_temp"
echo "Status keluar dari panggilan fungsi 2: $?"

echo "---"

buat_direktori_log # Memanggil tanpa argumen (akan gagal)
echo "Status keluar dari panggilan fungsi 3: $?"
```

* **Penjelasan:**
  * `local DIR_NAME="$1"`: Di dalam fungsi, `$1` mengacu pada argumen pertama yang dilewatkan **ke fungsi tersebut** (bukan ke skrip induk). Sama halnya dengan `$2`, `$3`, `$@`, `$*`, `$#` yang akan mengacu pada argumen fungsi.

#### **3.3. Mengembalikan Nilai dari Fungsi (Melalui Exit Codes dan `stdout`):**

Fungsi di Bash tidak "mengembalikan" nilai dalam arti yang sama seperti bahasa pemrograman lain (misalnya, `return` pada Dart/C++). Sebaliknya, mereka berkomunikasi hasil melalui:

* **Status Keluar (Exit Code):** Ini adalah cara utama untuk mengindikasikan keberhasilan (0) atau kegagalan (non-nol) suatu fungsi.

  * Menggunakan `return N` di mana `N` adalah angka 0-255. Jika tidak ada `return` eksplisit, *exit status* dari perintah terakhir di fungsi akan menjadi *exit status* fungsi.
  * Nilai ini dapat diperiksa menggunakan `$?` setelah fungsi dipanggil.

    <!-- end list -->

    ```bash
    #!/bin/bash

    validasi_angka() {
      local ANGKA="$1"
      if [[ "$ANGKA" =~ ^[0-9]+$ ]]; then
        echo "Validasi: Angka '$ANGKA' valid."
        return 0 # Sukses
      else
        echo "Validasi: Angka '$ANGKA' TIDAK valid." >&2
        return 1 # Gagal
      fi
    }

    validasi_angka "123"
    if [[ $? -eq 0 ]]; then
      echo "Angka valid."
    else
      echo "Angka tidak valid, tolong periksa."
    fi

    validasi_angka "abc"
    if [[ $? -eq 0 ]]; then
      echo "Angka valid."
    else
      echo "Angka tidak valid, tolong periksa."
    fi
    ```

* **Standard Output (`stdout`):** Jika fungsi menghasilkan data yang ingin Anda gunakan, cetak data tersebut ke `stdout`. Anda kemudian dapat menangkap *output* ini menggunakan *command substitution* (`$(nama_fungsi)`) dan menyimpannya ke variabel.

    ```bash
    #!/bin/bash

    dapatkan_nama_file_temp() {
      local TIMESTAMP=$(date +%Y%m%d%H%M%S)
      echo "temp_file_$TIMESTAMP.tmp"
      return 0 # Opsional, jika sudah mencetak ke stdout, biasanya return 0
    }

    # Tangkap output fungsi ke variabel
    FILE_TEMPORARY=$(dapatkan_nama_file_temp)
    echo "Nama file sementara yang dihasilkan: $FILE_TEMPORARY"

    touch "$FILE_TEMPORARY"
    echo "File sementara berhasil dibuat."
    ```

* **Penting:** Jangan mencampur pesan diagnostik/informasi dengan data yang dimaksudkan untuk ditangkap sebagai *output*. Jika fungsi harus mencetak pesan ke pengguna, alihkan pesan tersebut ke `stderr` (`echo "Pesan" >&2`) agar tidak bercampur dengan *output* yang ditangkap.

#### **3.4. Cakupan Variabel: Global vs. Lokal (`local`):**

Secara *default*, variabel yang didefinisikan dalam fungsi adalah **global**, artinya mereka dapat diakses dan diubah dari mana saja dalam skrip, termasuk di luar fungsi, dan dapat menimpa variabel dengan nama yang sama di luar fungsi. Ini adalah sumber *bug* yang umum.

Untuk mencegah hal ini, selalu gunakan kata kunci `local` untuk mendeklarasikan variabel yang cakupannya terbatas **hanya di dalam fungsi**.

```bash
#!/bin/bash

GLOBAL_VAR="Saya adalah variabel global awal"

contoh_scoping() {
  local LOCAL_VAR="Saya adalah variabel lokal" # Variabel lokal
  GLOBAL_VAR="Saya adalah variabel global yang diubah di dalam fungsi" # Mengubah global var

  echo "Di dalam fungsi:"
  echo "  Variabel Lokal: $LOCAL_VAR"
  echo "  Variabel Global: $GLOBAL_VAR"
}

echo "Sebelum memanggil fungsi:"
echo "  Variabel Global: $GLOBAL_VAR" # Output: Saya adalah variabel global awal

contoh_scoping

echo "Setelah memanggil fungsi:"
echo "  Variabel Lokal: $LOCAL_VAR"   # Output: (kosong, karena tidak bisa diakses dari luar)
echo "  Variabel Global: $GLOBAL_VAR" # Output: Saya adalah variabel global yang diubah di dalam fungsi

# Contoh: Variabel i di loop for (gaya C) juga lokal secara implisit
for (( i=0; i<3; i++ )); do
  echo "Loop i: $i"
done
echo "Nilai i di luar loop: $i" # Output: (kosong, karena i hanya ada dalam konteks loop)
```

* **Pentingnya `local`:** Menggunakan `local` adalah **praktik terbaik yang sangat direkomendasikan** untuk semua variabel yang hanya perlu ada di dalam fungsi. Ini mencegah *side effects* yang tidak disengaja dan membuat fungsi Anda lebih independen dan dapat digunakan kembali.

#### **3.5. Membuat Pustaka Fungsi (Sourcing Scripts):**

Anda dapat mengorganisir fungsi-fungsi Anda ke dalam file terpisah (mirip dengan modul atau library di Dart/Python) dan kemudian "mengambil" (sourcing) file-file tersebut ke dalam skrip utama Anda. Ini memungkinkan Anda untuk membangun pustaka fungsi yang dapat digunakan di banyak skrip berbeda.

* **Sintaks:** `source nama_file_fungsi.sh` atau `.` `nama_file_fungsi.sh` (ada spasi setelah titik).

**Contoh:**

1. Buat file `utils.sh`:

    ```bash
    # utils.sh
    # Pustaka fungsi utility umum

    log_info() {
      echo "[INFO] $(date +%H:%M:%S) - $1"
    }

    log_error() {
      echo "[ERROR] $(date +%H:%M:%S) - $1" >&2
    }

    cek_file_ada() {
      if [[ -f "$1" ]]; then
        return 0 # File ada
      else
        return 1 # File tidak ada
      fi
    }
    ```

2. Buat file `main_script.sh`:

    ```bash
    #!/bin/bash

    # Source pustaka fungsi
    source ./utils.sh # Atau: . ./utils.sh

    log_info "Memulai skrip utama..."

    FILE_TO_CHECK="konfigurasi.cfg"
    if cek_file_ada "$FILE_TO_CHECK"; then
      log_info "File '$FILE_TO_CHECK' ditemukan."
    else
      log_error "File '$FILE_TO_CHECK' tidak ditemukan. Harap periksa konfigurasi."
      exit 1
    fi

    log_info "Skrip utama selesai."
    ```

<!-- end list -->

* **Penjelasan `source`:** Perintah `source` (atau `.` ) membaca dan mengeksekusi perintah-perintah dari file yang diberikan **dalam shell saat ini**. Ini berarti fungsi dan variabel yang didefinisikan dalam `utils.sh` akan tersedia di `main_script.sh` seolah-olah mereka didefinisikan langsung di sana. Ini berbeda dengan menjalankan skrip (`./utils.sh`), yang akan menjalankan skrip di *subshell* terpisah.

### **4. Terminologi Esensial & Penjelasan Detil:**

* **Fungsi (Function):** Blok kode yang diberi nama dan dapat dipanggil/dieksekusi berulang kali dari berbagai tempat dalam skrip atau dari skrip lain (jika di-source).
* **Prinsip DRY (Don't Repeat Yourself):** Filosofi pemrograman yang menyarankan untuk menghindari duplikasi kode dengan menggunakan fungsi atau struktur modular lainnya.
* **Modularitas:** Konsep membagi sistem menjadi komponen-komponen independen dan dapat dipertukarkan (modul atau fungsi), yang masing-masing melakukan satu tugas spesifik.
* **Abstraksi:** Menyembunyikan detail implementasi internal dari sebuah fungsi, sehingga pengguna fungsi hanya perlu tahu apa yang dilakukannya, bukan bagaimana ia bekerja.
* **Argumen Posisi (Positional Parameters):** Variabel khusus (`$1`, `$2`, `$@`, `$*`, `$#`) yang digunakan di dalam fungsi untuk mengakses argumen yang dilewatkan saat fungsi dipanggil.
* **Status Keluar (Exit Status / Exit Code):** Angka (`0` untuk sukses, non-nol untuk gagal) yang dikembalikan oleh fungsi untuk mengindikasikan hasil eksekusinya. Diakses melalui `$?`.
* **Cakupan (Scope):** Konteks di mana sebuah variabel didefinisikan dan dapat diakses.
* **Variabel Global:** Variabel yang didefinisikan di level teratas skrip (di luar fungsi mana pun) atau tanpa kata kunci `local` di dalam fungsi, dan dapat diakses dari mana saja dalam skrip.
* **Variabel Lokal (`local`):** Variabel yang didefinisikan di dalam fungsi menggunakan kata kunci `local`, dan hanya dapat diakses di dalam fungsi tersebut dan fungsi yang dipanggil dari dalamnya. Ini adalah praktik terbaik untuk menghindari konflik nama dan *side effects*.
* **Sourcing (Source / `.`):** Proses membaca dan mengeksekusi konten file skrip lain di lingkungan *shell* yang sama. Ini membuat fungsi dan variabel dari file yang di-source tersedia di *shell* saat ini.

### **5. Rekomendasi Visualisasi (Jika Diperlukan):**

* **Diagram Alur Panggilan Fungsi:** Ilustrasi yang menunjukkan bagaimana kontrol program beralih ke fungsi saat dipanggil dan kembali ke titik panggilan setelah fungsi selesai.
* **Visualisasi Cakupan Variabel:** Diagram berlapis yang menunjukkan "lingkaran" atau "kotak" cakupan: satu kotak untuk cakupan global, dan kotak-kotak yang lebih kecil di dalamnya untuk setiap fungsi, dengan panah yang menunjukkan variabel mana yang dapat diakses di setiap lapisan. Ini sangat efektif untuk menjelaskan konsep `local`.
* **Diagram Sourcing vs. Eksekusi Subshell:** Perbandingan visual antara `source script.sh` (garis putus-putus ke dalam *shell* yang sama) dan `./script.sh` (kotak *subshell* baru).

### **6. Hubungan dengan Modul Lain:**

Fungsi adalah puncak dari fondasi yang dibangun di Fase 1 dan modul sebelumnya di Fase 2. Mereka akan sering berisi **kondisional (Modul 2.1)** untuk pengambilan keputusan dan **perulangan (Modul 2.2)** untuk otomasi berulang. Pemahaman tentang **variabel dan ekspansi (Modul 1.3)** adalah prasyarat untuk bekerja dengan argumen fungsi dan variabel lokal. Penggunaan *exit status* dari fungsi adalah dasar dari **Modul 3.1 (Penanganan Kesalahan)**. Fungsi yang dirancang dengan baik akan menjadi unit bangunan utama untuk skrip-skrip kompleks dan pustaka utilitas yang akan Anda kembangkan di Fase 3 dan 4.

### **7. Sumber Referensi Lengkap:**

* **Bash Functions (The Linux Documentation Project):** [https://tldp.org/LDP/abs/html/functions.html](https://tldp.org/LDP/abs/html/functions.html)
  * **Detail:** Bagian dari "Advanced Bash-Scripting Guide" ini memberikan penjelasan mendalam tentang fungsi di Bash, termasuk sintaks, argumen, dan beberapa fitur lanjutan.
* **Greg's Wiki - BashFAQ/053 (Variable Scope):** [https://mywiki.wooledge.org/BashFAQ/053](https://mywiki.wooledge.org/BashFAQ/053)
  * **Detail:** Sumber daya yang sangat direkomendasikan untuk memahami konsep cakupan variabel di Bash, menjelaskan perbedaan antara variabel global dan lokal serta pentingnya `local`.
* **Bash Functions (ryanstutorials.net):** [https://ryanstutorials.net/bash-scripting-tutorial/bash-functions.php](https://ryanstutorials.net/bash-scripting-tutorial/bash-functions.php)
  * **Detail:** Tutorial yang lebih ramah pemula dengan contoh-contoh praktis tentang cara membuat dan menggunakan fungsi.
* **Bash Manual: Functions:** [https://www.gnu.org/software/bash/manual/bash.html\#Functions](https://www.gnu.org/software/bash/manual/bash.html%23Functions)
  * **Detail Tambahan (opsional):** Dokumentasi resmi Bash tentang fungsi. Ini adalah referensi definitif untuk semua detail teknis.
* **Bash Manual: Shell Builtin Commands (source):** [https://www.gnu.org/software/bash/manual/bash.html\#index-source](https://www.gnu.org/software/bash/manual/bash.html%23index-source)
  * **Detail Tambahan (opsional):** Penjelasan resmi tentang perintah `source` dan mengapa penting untuk menggunakannya untuk pustaka fungsi.

### **8. Tips dan Praktik Terbaik:**

* **Gunakan `local` Secara Konsisten:** Jadikan kebiasaan untuk mendeklarasikan semua variabel di dalam fungsi Anda dengan kata kunci `local`, kecuali Anda memiliki alasan yang sangat kuat untuk membuatnya global. Ini akan mencegah *side effects* yang tidak disengaja.
* **Nama Fungsi yang Deskriptif:** Berikan nama fungsi yang jelas dan deskriptif tentang apa yang mereka lakukan (misalnya, `buat_cadangan`, `validasi_input`, `kirim_notifikasi`).
* **Fokus Satu Tugas per Fungsi:** Usahakan setiap fungsi melakukan satu tugas spesifik dengan baik. Ini meningkatkan modularitas dan kemudahan pengujian.
* **Tangani Error di Fungsi:** Gunakan `return N` untuk mengembalikan *exit status* yang sesuai dari fungsi, dan biarkan pemanggil fungsi menanganinya menggunakan `if [[ $? -ne 0 ]]`.
* **Cetak Output ke `stdout` untuk Data, `stderr` untuk Pesan:** Jika fungsi perlu menghasilkan data yang akan ditangkap oleh *command substitution*, pastikan data tersebut dicetak ke `stdout`. Pesan informasi atau kesalahan lainnya harus dialihkan ke `stderr` (`echo "Pesan error" >&2`).
* **Komentari Fungsi:** Sertakan komentar singkat di awal setiap fungsi yang menjelaskan tujuannya, argumen yang diterima, dan nilai yang dikembalikan (melalui *exit status* atau *stdout*).

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Variabel global yang tidak sengaja ditimpa oleh fungsi.
  * **Penyebab:** Variabel dalam fungsi didefinisikan tanpa `local`, sehingga menjadi global dan menimpa variabel di luar fungsi dengan nama yang sama.
  * **Solusi:** Selalu gunakan `local` untuk variabel di dalam fungsi.
* **Kesalahan:** Berpikir `return` mengembalikan nilai seperti di bahasa lain.
  * **Penyebab:** Di Bash, `return` hanya mengembalikan *exit status* (angka 0-255). Untuk mengembalikan data string, Anda harus mencetaknya ke `stdout` dan menangkapnya dengan *command substitution*.
  * **Solusi:** Pahami perbedaan antara `return` (untuk *exit status*) dan `echo` (untuk *output* yang dapat ditangkap).
* **Kesalahan:** Variabel yang dimodifikasi di dalam perulangan `while` yang di-*pipe* tidak terlihat di luar perulangan.
  * **Penyebab:** `cat file | while read ...` menjalankan `while` dalam *subshell*. Perubahan variabel di *subshell* tidak akan memengaruhi *shell* induk.
  * **Solusi:** Gunakan *input redirection* langsung: `while IFS= read -r BARIS; do ... done < file.txt`. Ini membuat `while` berjalan di *shell* yang sama.
* **Kesalahan:** Salah memanggil fungsi karena kurangnya izin eksekusi.
  * **Penyebab:** Fungsi yang di-source (`source script.sh`) tidak memerlukan izin eksekusi pada file sumbernya, tetapi jika Anda mencoba menjalankan file tersebut sebagai skrip (`./script.sh`), itu memang membutuhkan izin eksekusi.
  * **Solusi:** Pastikan Anda menggunakan `source` atau `.` untuk pustaka fungsi Anda, atau berikan izin eksekusi jika Anda memang berniat menjalankannya sebagai skrip terpisah.

-----

**Selamat!** Anda telah menyelesaikan **Fase 2: Menengah – Struktur, Kontrol, dan Manipulasi Teks**. Anda kini memiliki pemahaman yang solid tentang kondisional, perulangan, dan fungsi, yang merupakan inti dari setiap bahasa pemrograman dan esensial untuk menulis skrip Bash yang kuat dan terorganisir.

> * **[Ke Atas](#)**
> * **[Selanjutnya][selanjutnya]**
> * **[Sebelumnya][sebelumnya]**
> * **[Kurikulum][kurikulum]**
> * **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->
[1]:../README.md
