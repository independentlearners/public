# **[Fase 1: Fondasi – Berinteraksi dengan Shell (Tingkat Pemula)][1]**

**Tujuan Fase:** Membangun kenyamanan di baris perintah, memahami konsep fundamental interaksi dengan shell, dan menulis skrip pertama yang fungsional.

-----

1. Sejarah Singkat Unix dan Shell
2. Membedakan Terminal, Konsol, dan Shell
3. Memahami Filosofi Unix
4. Navigasi Dasar: `pwd`, `ls`, `cd`
5. Mendapatkan Bantuan: `man`, `tldr`, `--help`

-----

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Modul 1.1 ini adalah gerbang pertama Anda menuju dunia *shell scripting*. Ini bukan hanya tentang mempelajari perintah, tetapi juga tentang memahami "mengapa" di balik penggunaan baris perintah. Anda akan diajak menyelami konsep dasar bagaimana Anda berinteraksi dengan sistem operasi melalui teks, membedakan berbagai komponen seperti terminal dan shell, dan yang terpenting, memahami prinsip-prinsip desain yang menjadikan ekosistem Unix/Linux begitu kuat dan relevan hingga saat ini.

Peran modul ini sangat krusial karena ini adalah **fondasi kognitif** Anda. Tanpa pemahaman yang kuat tentang filosofi dan lingkungan kerja shell, pembelajaran perintah-perintah selanjutnya akan terasa seperti menghafal tanpa konteks. Modul ini mempersiapkan Anda untuk berpikir "ala Unix", yang akan sangat membantu dalam menulis skrip yang efisien, modular, dan dapat diandalkan—prinsip yang akan Anda bawa ke dalam pengembangan Dart/Flutter saat Anda berinterinteraksi dengan sistem berkas atau proses eksternal.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. The Unix Philosophy (Filosofi Unix):**

Ini adalah jantung dari cara kerja Unix dan Linux. Filosofi ini adalah serangkaian prinsip panduan yang diusulkan oleh Ken Thompson dan Dennis Ritchie, pencipta Unix, dan kemudian dirangkum oleh Douglas McIlroy. Prinsip-prinsip ini berpusat pada kesederhanaan, modularitas, dan interoperabilitas, yang secara radikal berbeda dari pendekatan sistem operasi lain pada masanya.

1. ***"Tulis program yang melakukan satu hal dan melakukannya dengan baik."***

      * **Konsep Mendalam:** Prinsip ini menganjurkan spesialisasi. Daripada membuat satu program raksasa yang mencoba melakukan semuanya (seperti *suite* kantor zaman dulu), Unix memilih pendekatan "alat tukang". Setiap perintah (seperti `grep`, `sort`, `cat`, `ls`) dirancang untuk satu tujuan yang sangat spesifik. Misalnya, `grep` hanya untuk mencari teks dalam file; ia tidak melakukan pengurutan atau pengeditan.
      * **Implikasi:** Ini mengurangi kompleksitas, membuat program lebih mudah untuk dikembangkan, diuji, dipelihara, dan yang paling penting, lebih andal. Jika satu program gagal, dampaknya minim karena ia hanya memiliki satu tugas.
      * **Analogi:** Bayangkan sebuah dapur. Daripada memiliki satu alat yang bisa memotong, mengaduk, dan memanggang (dan mungkin tidak optimal di ketiganya), Anda memiliki pisau yang sangat tajam, mixer yang efisien, dan oven yang andal. Setiap alat melakukan tugasnya dengan sempurna.
      * **Relevansi dalam IT (termasuk Flutter/Dart):** Konsep ini sangat mirip dengan prinsip *Single Responsibility Principle (SRP)* dalam desain perangkat lunak berorientasi objek, di mana setiap kelas atau modul harus memiliki satu dan hanya satu alasan untuk berubah. Dalam Flutter, ini bisa berarti memecah *widget* besar menjadi *widget* yang lebih kecil dan lebih terfokus, masing-masing dengan tanggung jawab tunggal.

2. ***"Tulis program yang bekerja bersama."***

      * **Konsep Mendalam:** Karena setiap program hanya melakukan satu hal, maka perlu ada cara agar program-program ini dapat berkolaborasi. Di sinilah konsep *pipes* (`|`) dan *redirection* (`>`, `>>`, `<`) menjadi fundamental. Output dari satu program dapat menjadi input untuk program lain.
      * **Implikasi:** Ini menciptakan fleksibilitas luar biasa. Anda bisa menggabungkan alat-alat sederhana dengan cara yang tak terbatas untuk melakukan tugas-tugas yang kompleks, tanpa perlu menulis program baru dari awal. Ini adalah konsep "lego" di dunia komputasi.
      * **Analogi:** Di dapur, Anda bisa menggunakan pisau untuk memotong bahan, lalu memasukkan bahan yang sudah dipotong ke dalam *mixer*, lalu adonan dari *mixer* dimasukkan ke dalam oven. Aliran kerja, bukan satu alat multifungsi.
      * **Relevansi dalam IT:** Ini adalah dasar dari *composable software*. Dalam pengembangan *backend*, ini terwujud dalam *microservices* yang berkomunikasi satu sama lain. Dalam *data engineering*, ini adalah ide di balik *pipeline* data.

3. ***"Tulis program untuk menangani aliran teks, karena itu adalah antarmuka universal."***

      * **Konsep Mendalam:** Daripada menggunakan format data biner yang kompleks dan spesifik, Unix mengandalkan teks biasa sebagai format data universal untuk komunikasi antar program. Data yang dihasilkan oleh satu program seringkali hanyalah teks yang dapat dibaca manusia (atau setidaknya mudah diproses oleh program lain).
      * **Implikasi:** Teks sangat mudah di-*parse*, di-*debug*, dan ditransfer antar sistem. Ini juga memungkinkan *interoperability* yang tinggi—program dari berbagai bahasa pemrograman atau arsitektur dapat dengan mudah bertukar data melalui teks.
      * **Analogi:** Bahasa Inggris adalah antarmuka universal dalam diplomasi internasional; semua orang setuju untuk menggunakannya agar dapat berkomunikasi, terlepas dari bahasa ibu mereka. Dalam komputasi, teks adalah "bahasa Inggris" ini.
      * **Relevansi dalam IT:** Meskipun format data biner dan terstruktur seperti JSON atau Protocol Buffers umum saat ini, fondasi teks masih sangat relevan. Log sistem, file konfigurasi, output dari banyak alat diagnostik masih berbasis teks. Pemrosesan teks adalah keterampilan inti bagi setiap *developer* atau *administrator*. Konsep *streaming* data dalam aplikasi modern juga memiliki akar filosofi ini.

#### **2.2. Shell sebagai Interpreter Perintah:**

* **Bukan Jendela Hitam Biasa:** Seringkali orang keliru mengira "terminal" atau "jendela hitam" adalah "shell". Shell adalah program, terminal adalah antarmuka grafis atau teks tempat shell berjalan.
* **Peran Shell:** Shell bertindak sebagai *interpreter* perintah. Ini adalah program yang menerima input Anda (perintah yang Anda ketik), menafsirkannya, dan kemudian "menerjemahkannya" untuk kernel sistem operasi agar dapat dieksekusi. Ini juga mengelola input/output program dan lingkungan eksekusi.
* **Bagaimana Ia Bekerja:**
    1. Anda mengetik perintah (misalnya, `ls -l`).
    2. Shell membaca perintah tersebut.
    3. Shell melakukan *parsing* (memecah perintah menjadi komponen-komponennya: nama program `ls`, argumen `-l`).
    4. Shell mencari program `ls` di lokasi yang ditentukan dalam variabel `PATH` Anda.
    5. Shell meminta *kernel* untuk menjalankan program `ls` dengan argumen `-l`.
    6. *Kernel* menjalankan `ls`.
    7. Output dari `ls` dikirim kembali ke shell, yang kemudian menampilkannya di terminal.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

Pada modul ini, fokusnya bukan pada penulisan skrip, melainkan pada interaksi langsung dengan shell. Ini adalah langkah pertama untuk merasakan bagaimana shell bekerja.

#### **3.1. Mengenali Shell Anda:**

Untuk mengetahui shell apa yang sedang Anda gunakan, Anda dapat memeriksa nilai dari variabel lingkungan `$SHELL`. Variabel lingkungan adalah variabel yang ditetapkan di lingkungan shell Anda dan tersedia untuk program yang Anda jalankan.

```bash
# Mengetahui shell apa yang sedang Anda gunakan
echo $SHELL
```

* **Penjelasan `echo $SHELL`:**
  * `echo`: Ini adalah perintah bawaan shell yang tugasnya hanya mencetak (menampilkan) argumen yang diberikan ke *standard output* (layar Anda).
  * `$SHELL`: Ini adalah **variabel lingkungan** khusus. Tanda `$` di depan `SHELL` adalah operator ekspansi variabel. Ini memberitahu shell untuk mengganti `$SHELL` dengan nilai yang disimpan dalam variabel `SHELL` sebelum perintah `echo` dieksekusi. Variabel `SHELL` secara otomatis diatur oleh sistem untuk menyimpan jalur lengkap ke shell yang sedang Anda gunakan.
  * **Contoh Output:** `/bin/bash` atau `/bin/zsh` atau `/bin/sh`.

#### **3.2. Menemukan Lokasi Perintah:**

Perintah-perintah yang Anda jalankan (seperti `ls`, `grep`, `cd`) adalah program yang disimpan di suatu tempat dalam sistem file Anda. Perintah `which` digunakan untuk menunjukkan lokasi *executable* dari sebuah perintah.

```bash
# Melihat di mana program 'ls' berada
which ls
```

* **Penjelasan `which ls`:**
  * `which`: Perintah ini mencari dalam direktori-direktori yang terdaftar dalam variabel lingkungan `PATH` untuk menemukan lokasi file *executable* dari perintah yang diberikan sebagai argumen.
  * `ls`: Nama perintah yang ingin Anda cari lokasinya.
  * **Contoh Output:** `/usr/bin/ls` (ini menunjukkan bahwa `ls` adalah program biner yang terletak di `/usr/bin/`).

#### **3.3. Mendapatkan Bantuan (Manual Pages):**

Salah satu alat terpenting dalam lingkungan Unix/Linux adalah `man` (*manual pages*). Ini adalah dokumentasi bawaan untuk sebagian besar perintah sistem.

```bash
# Mendapatkan bantuan untuk sebuah perintah
man ls
```

* **Penjelasan `man ls`:**
  * `man`: Perintah ini membuka halaman manual (dokumentasi) untuk perintah yang diberikan sebagai argumen.
  * `ls`: Nama perintah yang manualnya ingin Anda lihat.
  * **Bagaimana Menggunakan `man`:** Setelah Anda menjalankan `man ls`, Anda akan masuk ke *pager* teks (biasanya `less`).
    * Gunakan `Panah Atas/Bawah` untuk menggulir baris demi baris.
    * Gunakan `Page Up/Page Down` atau `Spasi` untuk menggulir halaman demi halaman.
    * Tekan `/` diikuti dengan kata kunci untuk mencari dalam manual.
    * Tekan `q` untuk keluar dari manual.
  * **Struktur Manual Page (Penting):**
    * `NAME`: Nama perintah dan fungsi singkatnya.
    * `SYNOPSIS`: Ringkasan sintaksis perintah. Ini sangat penting untuk memahami cara menggunakan perintah dengan opsi dan argumennya.
    * `DESCRIPTION`: Penjelasan mendetail tentang fungsi perintah.
    * `OPTIONS`: Penjelasan semua opsi (flag) yang dapat digunakan dengan perintah.
    * `EXAMPLES`: Contoh penggunaan perintah.
    * `SEE ALSO`: Perintah terkait lainnya.

### **4. Terminologi Esensial & Penjelasan Detil:**

* **Terminal:** Aplikasi perangkat lunak yang menyediakan antarmuka jendela untuk berinteraksi dengan shell. Dulunya, terminal adalah perangkat keras fisik (seperti teletypewriter) yang digunakan untuk mengirim dan menerima data dari komputer pusat. Sekarang, terminal paling sering berupa emulator terminal grafis (misalnya, GNOME Terminal, Konsole, iTerm2, Windows Terminal, VS Code Integrated Terminal). Ini hanyalah jendela tempat Anda mengetik dan melihat output.
  * **Contoh:** Ketika Anda membuka "Command Prompt" di Windows, "Terminal" di macOS, atau "Konsole" di Linux, Anda sebenarnya membuka *terminal emulator*.
* **Shell:** Program *interpreter* perintah yang berjalan di dalam terminal. Shell bertanggung jawab untuk membaca perintah yang Anda ketik, menafsirkannya, dan meminta *kernel* sistem operasi untuk menjalankan perintah tersebut. Shell juga menyediakan fitur seperti manajemen variabel, *input/output redirection*, dan *scripting*.
  * **Contoh:** `bash` (Bourne-Again Shell, shell default di banyak sistem Linux dan macOS), `zsh` (Z Shell), `sh` (Bourne Shell), `fish` (Friendly Interactive Shell), `csh` (C Shell).
* **Command Line Interface (CLI):** Antarmuka pengguna yang berbasis teks, tempat Anda berinteraksi dengan komputer dengan mengetik perintah dan menerima output teks. Ini kontras dengan *Graphical User Interface (GUI)* yang menggunakan ikon, jendela, dan pointer mouse. CLI sangat kuat untuk otomasi dan administrasi sistem.
  * **Relevansi:** Banyak *tool* pengembangan Dart/Flutter (seperti `flutter doctor`, `flutter run`, `flutter build`) dijalankan melalui CLI. Memahami CLI secara mendalam akan membuat Anda lebih efisien dalam menggunakan *tool* ini.
* **Kernel:** Inti dari sistem operasi. Ini adalah perangkat lunak tingkat rendah yang mengelola sumber daya perangkat keras komputer (CPU, memori, perangkat input/output) dan menyediakan layanan untuk perangkat lunak aplikasi. Shell berkomunikasi dengan *kernel* untuk meminta eksekusi program atau akses ke sumber daya.
  * **Analogi:** Jika sistem operasi adalah sebuah mobil, maka *kernel* adalah mesinnya, sedangkan shell adalah *dashboard* dan *setir* yang Anda gunakan untuk mengendalikannya.

### **5. Hubungan dengan Modul Lain:**

Modul ini adalah titik awal. Pemahaman tentang perbedaan antara terminal, shell, dan *kernel* adalah fondasi untuk Modul 1.2 (I/O Redirection) karena Anda akan belajar bagaimana shell mengelola aliran data. Pengetahuan tentang cara kerja perintah dan pentingnya *manual pages* juga akan membantu Anda dalam Modul 1.3 (Skrip Pertama Anda) karena Anda akan mulai menggabungkan perintah-perintah ini ke dalam sebuah skrip. Filosofi Unix yang dipelajari di sini akan menjadi pedoman sepanjang perjalanan Anda dalam *shell scripting*.

### **6. Sumber Referensi Lengkap:**

* **The Art of Unix Programming (Eric S. Raymond):** [http://www.catb.org/\~esr/writings/taoup/html/](http://www.catb.org/~esr/writings/taoup/html/)
  * **Detail:** Buku klasik yang menjelaskan secara mendalam filosofi dan praktik terbaik dalam lingkungan Unix. Bab-bab awal sangat relevan untuk memahami "pemikiran Unix". Ini adalah sumber yang sangat direkomendasikan untuk Anda karena membahas filosofi dan arsitektur, yang selaras dengan minat Anda pada sains dan filsafat.
* **Linux Command Line for Beginners (Ubuntu Tutorials):** [https://ubuntu.com/tutorials/command-line-for-beginners](https://ubuntu.com/tutorials/command-line-for-beginners)
  * **Detail:** Tutorial yang sangat baik dan ramah pemula dari Ubuntu, menjelaskan dasar-dasar baris perintah dengan contoh praktis. Bagian pengantar ini akan memberikan gambaran yang jelas.
* **What is a shell? (Red Hat):** [https://www.redhat.com/en/topics/linux/what-is-a-shell](https://www.redhat.com/en/topics/linux/what-is-a-shell)
  * **Detail Tambahan (opsional untuk ditambahkan ke kurikulum):** Artikel ini memberikan definisi yang jelas tentang shell dan perannya dalam sistem Linux.
* **What is the Linux kernel? (Red Hat):** [https://www.redhat.com/en/topics/linux/what-is-linux-kernel](https://www.redhat.com/en/topics/linux/what-is-linux-kernel)
  * **Detail Tambahan (opsional untuk ditambahkan ke kurikulum):** Penjelasan yang bagus tentang *kernel* dan fungsinya.
* **Bash Reference Manual: Shell Operations:** [https://www.gnu.org/software/bash/manual/bash.html\#Shell-Operation](https://www.gnu.org/software/bash/manual/bash.html%23Shell-Operation)
  * **Detail Tambahan (opsional untuk ditambahkan ke kurikulum):** Meskipun lebih teknis, bagian ini dari manual resmi Bash menjelaskan bagaimana shell beroperasi secara internal, termasuk ekspansi variabel dan eksekusi perintah. Ini relevan untuk pembelajar tingkat lanjut yang ingin mendalami.

### **7. Tips dan Praktik Terbaik:**

* **Latihan Adalah Kunci:** Satu-satunya cara untuk menguasai baris perintah adalah dengan sering menggunakannya. Cobalah setiap perintah yang Anda pelajari.
* **Jangan Takut `man`:** Halaman manual adalah teman terbaik Anda. Seringkali, semua informasi yang Anda butuhkan ada di sana.
* **Mulailah dari yang Kecil:** Jangan mencoba membuat skrip kompleks di awal. Kuasai perintah-perintah dasar satu per satu.
* **Kustomisasi Terminal (Opsional):** Meskipun bukan bagian inti dari *scripting*, mengkustomisasi tampilan terminal Anda (misalnya, warna, *font*) dapat membuat pengalaman belajar lebih menyenangkan dan mengurangi kelelahan mata.

### **8. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Menganggap "terminal" dan "shell" adalah hal yang sama.
  * **Solusi:** Ingatlah analogi: terminal adalah jendela, shell adalah program *interpreter* yang berjalan di dalamnya.
* **Kesalahan:** Tidak tahu cara keluar dari halaman `man`.
  * **Solusi:** Selalu ingat untuk menekan `q` (quit) untuk keluar dari *pager* `less` yang digunakan oleh `man`.
* **Kesalahan:** Mengira semua perintah adalah program eksternal.
  * **Solusi:** Beberapa perintah (seperti `echo`, `cd`, `pwd`) adalah "perintah bawaan" (built-in) shell, yang berarti mereka adalah bagian dari shell itu sendiri dan tidak memiliki file *executable* terpisah di `/usr/bin/` atau `/bin/`. Anda bisa memeriksa ini dengan `type <perintah>` (misalnya, `type cd` akan menunjukkan `cd is a shell builtin`). Ini akan dibahas lebih lanjut di modul mendatang, tetapi penting untuk diketahui secara implisit.

-----

## **Modul 1.2: Perintah Fundamental dan I/O Redirection**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Memahami Standard Streams: `stdin`, `stdout`, `stderr`
2. Output Redirection: `>` (timpa) dan `>>` (tambahkan)
3. Input Redirection: `<`
4. Kekuatan Pipes (`|`): Merangkai Perintah
5. Menggabungkan dan Mengarahkan Stream (`2>&1`)
6. Perintah Esensial: `cat`, `grep`, `head`, `tail`, `wc`, `sort`, `uniq`

Mari kita pecah jadi bagian-bagian penting dan kita bahas satu per satu dengan penjelasan teknis, contoh, dan istilah yang biasa digunakan dalam dokumentasi Bash.

---

## 1. **Standard Streams (Standar Aliran)**

> **stdin**, **stdout**, **stderr** adalah tiga saluran I/O standar di Unix-like systems.

| Stream   | Deskripsi                          | File Descriptor |
| -------- | ---------------------------------- | --------------- |
| `stdin`  | Standar input (biasanya keyboard)  | `0`             |
| `stdout` | Standar output (biasanya terminal) | `1`             |
| `stderr` | Standar error (output kesalahan)   | `2`             |

Contoh:

```bash
echo "Hello"           # ke stdout (1)
cat file.txt           # baca dari stdin (0) kalau tanpa argumen
ls file.txt 2>error.log  # redirect stderr (2) ke file
```

---

## 2. **Output Redirection**

### `>`

**Istilah dokumentasi:** *output redirection*
**Fungsi:** Mengalihkan `stdout` ke file, **menimpa** isinya.

```bash
echo "Hello" > output.txt
```

### `>>`

**Istilah dokumentasi:** *append output redirection*
**Fungsi:** Mengalihkan `stdout` ke file, **menambahkan** ke akhir file.

```bash
echo "Another line" >> output.txt
```

---

## 3. **Input Redirection**

### `<`

**Istilah dokumentasi:** *input redirection*
**Fungsi:** Menggunakan isi file sebagai `stdin`.

```bash
cat < file.txt
```

---

## 4. **Pipes  / Pipa (`|`)**

### `|`

**Istilah dokumentasi:** *pipe operator*
**Fungsi:** Mengalirkan output dari satu perintah sebagai input (`stdin`) ke perintah lain.

```bash
ls | grep "txt"
```

---

## 5. **Penggabungan dan Pengalihan Stream**

### `2>`

**Istilah dokumentasi:** *stderr redirection*
**Fungsi:** Redirect `stderr` ke file.

```bash
ls nonexist 2> error.log
```

---

### `2>>`

**Istilah dokumentasi:** *append stderr redirection*
**Fungsi:** Tambahkan `stderr` ke file tanpa menimpa.

---

### `&>`

**Istilah dokumentasi:** *redirect both stdout and stderr*
**Fungsi:** Mengalihkan `stdout` dan `stderr` ke target yang sama.
(Sintaks Bash, bukan POSIX-sh)

```bash
command &> output.log
```

---

### `2>&1`

**Istilah dokumentasi:** *file descriptor duplication*
**Fungsi:** Arahkan `stderr (2)` ke lokasi yang sama seperti `stdout (1)`.

```bash
command > out.log 2>&1
```

**Catatan:** Urutan penting! `2>&1 > out.log` artinya beda.

---

### Kombinasi:

```bash
command > out.log 2>&1     # stdout dan stderr ke satu file
command &>> log.txt        # append stdout dan stderr ke file (Bash extension)
```

---

## 6. **Perintah Esensial**

| Perintah | Fungsi Singkat                                 |
| -------- | ---------------------------------------------- |
| `cat`    | Tampilkan isi file                             |
| `grep`   | Filter teks dengan pola regex                  |
| `head`   | Tampilkan baris awal                           |
| `tail`   | Tampilkan baris akhir                          |
| `wc`     | Hitung baris, kata, byte                       |
| `sort`   | Urutkan baris                                  |
| `uniq`   | Hapus duplikat baris (biasanya setelah `sort`) |

---

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Modul ini adalah tentang bagaimana Anda dapat mengendalikan aliran data di lingkungan shell. Anda akan belajar bagaimana menggabungkan perintah-perintah sederhana menjadi alur kerja yang jauh lebih kuat dan otomatis menggunakan konsep *redirection* (pengalihan) dan *pipes* (pipa). Ini adalah keterampilan paling fundamental dalam *shell scripting* karena memungkinkan Anda untuk membuat program saling "berbicara" dan memproses data secara berurutan, layaknya sebuah *assembly line* informasi.

Peran modul ini sangat sentral. Setelah Anda memahami filosofi Unix di Modul 1.1—bahwa program harus melakukan satu hal dengan baik dan bekerja sama—Modul 1.2 ini memberikan **mekanisme konkret** tentang bagaimana program-program tersebut "bekerja sama". Tanpa penguasaan *I/O redirection* dan *pipes*, *shell scripting* akan sangat terbatas, hanya sebatas menjalankan perintah tunggal. Keterampilan ini tidak hanya relevan untuk *shell scripting*, tetapi juga membentuk dasar pemahaman tentang bagaimana data mengalir dalam sistem komputasi secara lebih luas, yang akan sangat berharga dalam bidang IT apapun, termasuk saat Anda berurusan dengan *stream* data atau *pipeline* dalam pengembangan Flutter.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Segalanya Adalah File (Almost):**

Di dunia Unix/Linux, ada filosofi yang mengatakan "segalanya adalah file". Ini bukan berarti setiap entitas fisik adalah file, tetapi bahwa banyak sumber daya (perangkat keras, proses, bahkan komunikasi antar program) diperlakukan dan diakses **melalui antarmuka yang konsisten seperti file**. Anda dapat membaca dari mereka, menulis ke mereka, atau mengarahkan output ke mereka.

#### **2.2. Standard Streams: `stdin`, `stdout`, dan `stderr`:**

Setiap program yang berjalan di lingkungan Unix/Linux (termasuk perintah shell) secara *default* memiliki tiga "saluran" komunikasi standar yang diasosiasikan dengannya. Ini adalah konsep inti dari Modul 1.2.

1. **Standard Input (`stdin`, file descriptor 0):**

      * **Konsep:** Ini adalah saluran masukan default untuk sebuah program. Secara *default*, `stdin` terhubung ke *keyboard* Anda. Artinya, ketika sebuah program membutuhkan input, ia akan "mendengarkan" apa yang Anda ketikkan.
      * **Filosofi:** Memberikan cara standar bagi program untuk menerima data dari sumber eksternal tanpa perlu mengetahui secara spesifik dari mana data itu berasal (apakah itu keyboard, file, atau output dari program lain).

2. **Standard Output (`stdout`, file descriptor 1):**

      * **Konsep:** Ini adalah saluran keluaran default untuk sebuah program. Secara *default*, `stdout` terhubung ke layar terminal Anda. Ketika sebuah program berhasil menyelesaikan tugasnya dan ingin menampilkan hasil, ia akan "berbicara" ke `stdout`.
      * **Filosofi:** Memberikan cara standar bagi program untuk menampilkan hasil yang berhasil kepada pengguna.

3. **Standard Error (`stderr`, file descriptor 2):**

      * **Konsep:** Ini adalah saluran khusus untuk pesan kesalahan atau diagnostik. Secara *default*, `stderr` juga terhubung ke layar terminal Anda. Ini penting karena memisahkan pesan kesalahan dari output program yang sebenarnya, memungkinkan Anda untuk menangani keduanya secara berbeda.
      * **Filosofi:** Memastikan bahwa bahkan jika output program dialihkan ke file, pesan kesalahan masih dapat terlihat oleh pengguna (di layar) atau dialihkan ke file log terpisah untuk analisis. Ini sangat penting untuk *debugging* dan penanganan kesalahan yang robust.

#### **Visualisasi:**

Visualisasi diagram alur adalah rekomendasi kuat di sini untuk mengilustrasikan bagaimana data mengalir dari `stdout` satu perintah ke `stdin` perintah berikutnya melalui sebuah *pipe*, serta bagaimana `stdin`, `stdout`, dan `stderr` bisa dialihkan.

**Diagram Alur Konseptual Standard Streams (Default):**

```
                         +-------------------+
                         |      Program      |
                         |                   |
Keyboard --(stdin, 0)--> |                   | --(stdout, 1)--> Layar (Terminal)
                         |                   |
                         |                   | --(stderr, 2)--> Layar (Terminal)
                         +-------------------+
```

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Output Redirection: Mengarahkan `stdout` ke File**

Anda dapat mengubah tujuan `stdout` dari layar ke sebuah file menggunakan operator *redirection*.

* **Operator `>` (Timpa):** Menulis *output* ke file. Jika file sudah ada, isinya akan **ditimpa** (dihapus dan diganti dengan *output* baru). Jika file tidak ada, file baru akan dibuat.

    ```bash
    # Menulis output dari 'ls -l' ke dalam file 'daftar_file.txt'
    # Jika daftar_file.txt sudah ada, isinya akan DITIMPA.
    ls -l > daftar_file.txt
    ```

  * **Penjelasan `ls -l > daftar_file.txt`:**
    * `ls -l`: Perintah `ls` (list directory contents) dengan opsi `-l` (long listing format) untuk menampilkan detail file dan direktori.
    * `>`: Operator *output redirection*. Ini mengalihkan `stdout` dari perintah `ls -l`.
    * `daftar_file.txt`: Nama file tujuan tempat *output* akan disimpan.

* **Operator `>>` (Tambahkan):** Menulis *output* ke file. Jika file sudah ada, *output* akan **ditambahkan** (ditulis di akhir file yang sudah ada). Jika file tidak ada, file baru akan dibuat.

    ```bash
    # Menambahkan output dari 'date' ke file 'daftar_file.txt'
    # Output date akan ditambahkan di akhir file yang sudah ada.
    date >> daftar_file.txt
    ```

  * **Penjelasan `date >> daftar_file.txt`:**
    * `date`: Perintah yang menampilkan tanggal dan waktu saat ini.
    * `>>`: Operator *output redirection* untuk menambahkan *output* ke file.
    * `daftar_file.txt`: Nama file tujuan.

#### **3.2. Input Redirection: Mengarahkan `stdin` dari File**

Anda dapat mengubah sumber `stdin` dari *keyboard* ke sebuah file menggunakan operator `<`.

```bash
# Menggunakan file 'data.txt' sebagai input untuk perintah 'wc -l'
# wc -l akan menghitung jumlah baris dalam data.txt
wc -l < data.txt
```

* **Penjelasan `wc -l < data.txt`:**
  * `wc -l`: Perintah `wc` (word count) dengan opsi `-l` (lines) untuk menghitung jumlah baris. Secara *default*, `wc` membaca dari `stdin`.
  * `<`: Operator *input redirection*. Ini mengalihkan `stdin` dari perintah `wc -l` untuk membaca dari `data.txt`.
  * `data.txt`: Nama file sumber yang akan menjadi *input* bagi `wc -l`.

#### **3.3. Kekuatan Pipes (`|`): Merangkai Perintah**

*Pipes* adalah salah satu fitur paling revolusioner di Unix, memungkinkan Anda untuk merangkai perintah-perintah sederhana untuk membentuk alur kerja yang kompleks. Operator *pipe* (`|`) mengambil `stdout` dari perintah di sebelah kiri dan mengirimkannya sebagai `stdin` ke perintah di sebelah kanan.

```bash
# Menggunakan output 'cat' sebagai input untuk 'grep' (mencari kata 'Dokumen')
# cat daftar_file.txt -> stdout -> grep "Dokumen" -> stdin
cat daftar_file.txt | grep "Dokumen"
```

* **Penjelasan `cat daftar_file.txt | grep "Dokumen"`:**
  * `cat daftar_file.txt`: Perintah `cat` (concatenate and print files) akan membaca isi `daftar_file.txt` dan mencetaknya ke `stdout`.
  * `|`: Operator *pipe*. Ini mengambil semua *output* dari `cat daftar_file.txt` dan "memipanya" sebagai *input* ke perintah berikutnya.
  * `grep "Dokumen"`: Perintah `grep` (global regular expression print) akan menerima *input* dari *pipe* dan mencari baris-baris yang mengandung string "Dokumen". Baris yang cocok akan dicetak ke `stdout` dari `grep`.

#### **Visualisasi Data Flow dengan Pipe:**

```
+-----------+     stdout    +-----------+     stdout    +-----------+
| Command A | -----------> | Command B | -----------> | Command C |
+-----------+     (pipe)    +-----------+     (pipe)    +-----------+
  (writes to)                 (reads from)                  (reads from)
  (its stdout)                (its stdin)                   (its stdin)
```

#### **3.4. Menggabungkan dan Mengarahkan Stream (File Descriptor)**

Secara *default*, operator `>` dan `>>` hanya mengarahkan `stdout` (file descriptor 1). Untuk mengarahkan `stderr` (file descriptor 2) atau bahkan menggabungkan keduanya, Anda perlu menentukan nomor *file descriptor*.

* **Mengarahkan `stderr` saja:** Gunakan `2>` atau `2>>`.

    ```bash
    # Mengarahkan pesan error dari find ke file terpisah 'error.log'
    # Output sukses (jika ada) masih akan ditampilkan ke layar.
    find /non/existent/directory 2> error.log
    ```

  * **Penjelasan:** `find` akan mencoba mencari di direktori yang tidak ada, yang akan menghasilkan pesan error. `2>` mengalihkan *error message* tersebut ke `error.log`.

* **Menggabungkan `stdout` dan `stderr`:** Seringkali Anda ingin menangani `stdout` dan `stderr` secara bersamaan, misalnya, mengarahkan keduanya ke file yang sama atau memipakan keduanya.

  * **Sintaks:** `&>` atau `2>&1`
    * `&>`: Ini adalah sintaks singkat Bash untuk mengarahkan `stdout` (1) dan `stderr` (2) ke file yang sama.
    * `2>&1`: Ini berarti "arahkan file descriptor 2 (stderr) ke tempat yang sama dengan file descriptor 1 (stdout)". Penting: `2>&1` harus diletakkan **setelah** *redirection* `stdout` jika Anda ingin keduanya pergi ke file yang sama.

    <!-- end list -->

    ```bash
    # Mengarahkan pesan error dan output sukses ke file yang sama
    # find / -name "rahasia.txt" akan mencari file, jika tidak ditemukan, akan ada error permission
    find / -name "rahasia.txt" > output_dan_error.log 2>&1

    # Atau menggunakan sintaks yang lebih modern dan ringkas di Bash
    # find / -name "rahasia.txt" &> output_dan_error.log
    ```

  * **Penjelasan `find ... > output_dan_error.log 2>&1`:**
    * `find / -name "rahasia.txt"`: Perintah `find` mencari file `rahasia.txt` dimulai dari root `/`. Ini kemungkinan akan menghasilkan banyak *permission denied error* (ke `stderr`) dan mungkin output sukses (ke `stdout`) jika file ditemukan.
    * `> output_dan_error.log`: Pertama, `stdout` diarahkan ke `output_dan_error.log`.
    * `2>&1`: Kemudian, `stderr` (file descriptor 2) diarahkan ke lokasi yang sama dengan `stdout` (file descriptor 1) yang sudah dialihkan ke `output_dan_error.log`. Jadi, kedua *stream* sekarang pergi ke file yang sama.

#### **Visualisasi Penggabungan Stream:**

```
+-------------------+
|      Program      |
|                   |
|                   | --(stdout, 1)--> File: output_dan_error.log
|                   |
|                   | --(stderr, 2)--> (redirected to 1)
+-------------------+
```

### **4. Terminologi Esensial & Penjelasan Detil:**

* **Standard Input (`stdin`, `fd 0`):** Aliran data masukan default untuk sebuah program, biasanya berasal dari *keyboard*. Diwakili oleh *file descriptor* `0`.
* **Standard Output (`stdout`, `fd 1`):** Aliran data keluaran default dari sebuah program, biasanya menuju layar terminal. Diwakili oleh *file descriptor* `1`.
* **Standard Error (`stderr`, `fd 2`):** Aliran khusus untuk pesan kesalahan atau diagnostik dari sebuah program, juga biasanya menuju layar terminal. Diwakili oleh *file descriptor* `2`.
* **File Descriptor (FD):** Angka bulat non-negatif yang digunakan oleh sistem operasi Unix/Linux untuk mengidentifikasi file atau saluran I/O yang terbuka. `0`, `1`, dan `2` adalah *file descriptor* standar untuk `stdin`, `stdout`, dan `stderr`.
* **Pipe (`|`):** Operator yang menghubungkan `stdout` dari satu perintah ke `stdin` dari perintah berikutnya. Ini menciptakan sebuah "pipa" di mana data mengalir dari kiri ke kanan.
* **Redirection (`>`, `>>`, `<`):** Operator yang mengubah sumber atau tujuan aliran data standar (input, output, atau error) ke atau dari file.
  * `>`: *Output redirection*, menimpa file tujuan.
  * `>>`: *Output redirection*, menambahkan ke file tujuan.
  * `<`: *Input redirection*, membaca dari file sumber.

### **5. Perintah Esensial:**

Modul ini memperkenalkan beberapa perintah dasar yang sering digunakan bersama dengan *redirection* dan *pipes* untuk memproses teks.

* **`cat` (concatenate and print files):**
  * **Fungsi:** Membaca file secara berurutan dan mencetak isinya ke `stdout`. Paling sering digunakan untuk menampilkan isi file ke terminal atau sebagai sumber input untuk *pipe*.
  * **Contoh:** `cat nama_file.txt`
* **`grep` (global regular expression print):**
  * **Fungsi:** Mencari baris-baris dalam file atau *input stream* yang cocok dengan pola teks (regular expression) tertentu dan mencetak baris-baris yang cocok ke `stdout`.
  * **Contoh:** `grep "kata_kunci" log_file.txt` atau `cat log_file.txt | grep "ERROR"`
* **`head`:**
  * **Fungsi:** Menampilkan baris-baris pertama dari sebuah file atau *input stream* (secara *default*, 10 baris pertama).
  * **Contoh:** `head -n 5 data.csv` (menampilkan 5 baris pertama)
* **`tail`:**
  * **Fungsi:** Menampilkan baris-baris terakhir dari sebuah file atau *input stream* (secara *default*, 10 baris terakhir). Sangat berguna untuk memantau log (*tail -f*).
  * **Contoh:** `tail -n 20 error.log` (menampilkan 20 baris terakhir), `tail -f access.log` (memantau log secara real-time)
* **`wc` (word count):**
  * **Fungsi:** Menghitung jumlah baris (`-l`), kata (`-w`), dan/atau karakter (`-c`) dalam file atau *input stream*.
  * **Contoh:** `wc -l dokumen.txt` (jumlah baris), `ls -l | wc -l` (jumlah file/direktori di output `ls -l`)
* **`sort`:**
  * **Fungsi:** Mengurutkan baris-baris dari file atau *input stream* secara alfabetis (*default*) atau numerik.
  * **Contoh:** `cat daftar_nama.txt | sort`, `sort -r data.txt` (mengurutkan terbalik)
* **`uniq` (report or omit repeated lines):**
  * **Fungsi:** Menghapus baris-baris duplikat yang berurutan dari sebuah file atau *input stream*. Sering digunakan setelah perintah `sort`.
  * **Contoh:** `cat data.txt | sort | uniq` (mendapatkan daftar unik dari baris)

### **6. Hubungan dengan Modul Lain:**

Konsep *I/O redirection* dan *pipes* adalah jembatan utama antara perintah-perintah tunggal yang dipelajari di Modul 1.1 dan penulisan skrip yang fungsional di Modul 1.3. Anda akan menggunakan *redirection* untuk menulis *output* skrip Anda ke file log, dan *pipes* untuk memproses data antar perintah dalam skrip Anda. Kemampuan untuk mengarahkan `stderr` juga sangat penting untuk Modul 3.1 (Penanganan Kesalahan) guna memisahkan pesan kesalahan dari output normal. Perintah-perintah teks yang diperkenalkan di sini akan menjadi "bahan bakar" utama untuk skrip-skrip otomasi di Fase 2 dan Fase 4.

### **7. Sumber Referensi Lengkap:**

* **I/O Redirection (The Linux Documentation Project):** [https://tldp.org/LDP/abs/html/io-redirection.html](https://tldp.org/LDP/abs/html/io-redirection.html)
  * **Detail:** Bagian dari "Advanced Bash-Scripting Guide" ini adalah sumber yang sangat komprehensif untuk memahami konsep *I/O redirection*, *file descriptors*, dan berbagai operator. Sangat direkomendasikan untuk pemahaman mendalam.
* **Ryans Tutorials - Pipes and Redirection:** [https://ryanstutorials.net/linuxtutorial/piping.php](https://ryanstutorials.net/linuxtutorial/piping.php)
  * **Detail:** Tutorial yang lebih ringkas dan mudah diikuti, bagus untuk mendapatkan pemahaman praktis yang cepat dengan contoh-contoh yang jelas.
* **`cat` command in Linux (GeeksforGeeks):** [https://www.geeksforgeeks.org/cat-command-in-linux-with-examples/](https://www.geeksforgeeks.org/cat-command-in-linux-with-examples/)
  * **Detail Tambahan (opsional):** Penjelasan mendalam tentang perintah `cat` dan berbagai opsi penggunaannya.
* **`grep` command in Linux (Linuxize):** [https://linuxize.com/howto/grep-command-linux/](https://linuxize.com/howto/grep-command-linux/)
  * **Detail Tambahan (opsional):** Panduan lengkap tentang perintah `grep`, termasuk penggunaan *regular expressions*.
* **`head` command in Linux (Linuxize):** [https://linuxize.com/howto/head-command-linux/](https://linuxize.com/howto/head-command-linux/)
  * **Detail Tambahan (opsional):** Detail tentang perintah `head`.
* **`tail` command in Linux (Linuxize):** [https://linuxize.com/howto/tail-command-linux/](https://linuxize.com/howto/tail-command-linux/)
  * **Detail Tambahan (opsional):** Detail tentang perintah `tail`, termasuk opsi `-f` yang sangat berguna.
* **`wc` command in Linux (GeeksforGeeks):** [https://www.geeksforgeeks.org/wc-command-in-linux-with-examples/](https://www.geeksforgeeks.org/wc-command-in-linux-with-examples/)
  * **Detail Tambahan (opsional):** Penjelasan perintah `wc`.
* **`sort` command in Linux (Linuxize):** [https://linuxize.com/howto/sort-command-linux/](https://linuxize.com/howto/sort-command-linux/)
  * **Detail Tambahan (opsional):** Panduan tentang penggunaan perintah `sort`.
* **`uniq` command in Linux (Linuxize):** [https://linuxize.com/howto/uniq-command-linux/](https://linuxize.com/howto/uniq-command-linux/)
  * **Detail Tambahan (opsional):** Penjelasan tentang perintah `uniq`.

### **8. Tips dan Praktik Terbaik:**

* **Pikirkan Alur Data:** Ketika Anda menulis perintah, bayangkan bagaimana data mengalir dari satu perintah ke perintah berikutnya. Ini akan membantu Anda merangkai *pipes* secara efektif.
* **Gunakan *Pipes* untuk Komposisi:** Daripada mencoba membuat satu perintah yang melakukan semuanya, gunakan filosofi Unix: gabungkan perintah-perintah kecil yang efisien menggunakan *pipes*.
* **Hati-hati dengan `>`:** Selalu ingat bahwa operator `>` akan **menimpa** isi file jika file tersebut sudah ada. Jika Anda tidak yakin, gunakan `>>` untuk menambahkan atau periksa file terlebih dahulu.
* **Gunakan *Redirection* untuk Log:** Alihkan *output* atau *error* skrip Anda ke file log terpisah. Ini sangat penting untuk *debugging* dan *troubleshooting* di kemudian hari.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Mengira `>` dan `>>` melakukan hal yang sama.
  * **Solusi:** Ingat: `>` untuk *overwrite* (timpa), `>>` untuk *append* (tambahkan).
* **Kesalahan:** Mengharapkan `stderr` juga melalui *pipe* secara *default*.
  * **Solusi:** Ingat bahwa *pipe* hanya mengarahkan `stdout`. Untuk mengarahkan `stderr` juga, Anda harus secara eksplisit menggabungkannya dengan `stdout` menggunakan `2>&1` atau `&>`.
* **Kesalahan:** Menggunakan `uniq` tanpa `sort` terlebih dahulu untuk menghapus semua duplikat.
  * **Solusi:** `uniq` hanya menghapus baris duplikat yang **berurutan**. Jika Anda memiliki daftar: A, B, A, C, `uniq` hanya akan melihat A, B, A, C. Untuk menghapus semua duplikat, Anda harus mengurutkan daftar terlebih dahulu: A, A, B, C, kemudian `uniq` akan menghasilkan A, B, C. Selalu ingat pola `sort | uniq` untuk mendapatkan daftar item unik.

-----

Dengan penjelasan mendalam untuk Modul 1.2 ini, yang mencakup konsep, sintaks, terminologi, visualisasi, dan sumber referensi, berikut ini adalah modul krusial di mana Anda akan mulai menulis skrip Bash pertama Anda dan memahami konsep dasar pemrograman di lingkungan shell.

-----

## **Modul 1.3: Skrip Pertama Anda, Variabel, dan Ekspansi**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Menciptakan Skrip Bash Pertama: `#!/bin/bash` (Shebang)
2. Menjadikan Skrip Dapat Dieksekusi: `chmod`
3. Menjalankan Skrip: Relatif vs. Absolut
4. Variabel dalam Bash: Definisi dan Penggunaan
5. Variabel Lingkungan (Environment Variables)
6. Input dari Pengguna: Argumen Baris Perintah (`$0`, `$1`, `$@`, `$*`)
7. Status Keluar (Exit Status): `$?`
8. Ekspansi Shell (Shell Expansion): Brace, Tilde, Command, Arithmetic, Parameter

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Modul 1.3 adalah titik balik di mana Anda beralih dari sekadar menjalankan perintah individual di terminal ke **menulis serangkaian perintah menjadi sebuah file yang dapat dieksekusi sebagai program**. Anda akan mempelajari bagaimana membuat "resep" perintah yang dapat dijalankan berulang kali, memahami cara menyimpan dan memanipulasi data menggunakan variabel, dan bagaimana skrip Anda dapat menerima input.

Peran modul ini sangat vital karena ini adalah langkah pertama Anda menuju **otomasi dan pemrograman yang sesungguhnya** di shell. Konsep-konsep seperti variabel, argumen, dan *exit status* adalah pondasi dasar dari setiap bahasa pemrograman, dan memahaminya dalam konteks Bash akan memudahkan Anda untuk mengaplikasikannya ke bahasa lain, termasuk Dart dan Flutter. Modul ini mengajarkan Anda untuk membuat skrip yang lebih dinamis dan interaktif, melampaui perintah statis.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Skrip sebagai Otomasi (Batch Processing):**

Filosofi utama di balik *shell scripting* adalah otomasi. Daripada mengetik ulang serangkaian perintah yang sama berulang kali, Anda dapat menulisnya sekali dalam sebuah skrip dan menjalankannya kapan pun dibutuhkan. Ini menghemat waktu, mengurangi kesalahan manusia, dan memastikan konsistensi.

* **Dari Interaktif ke Skrip:** Di Modul 1.1 dan 1.2, Anda berinteraksi dengan shell secara *interaktif* (mengetik perintah, mendapatkan respons). Di sini, Anda akan membundel interaksi tersebut ke dalam file *script* yang dapat dijalankan secara *non-interaktif*.
* **Relevansi dalam IT:** Konsep otomasi ini sangat mendasar dalam DevOps, administrasi sistem, dan bahkan pengembangan *software*. Dalam konteks Flutter, Anda mungkin ingin mengotomatiskan tugas-tugas seperti membersihkan *build*, menjalankan tes, atau *deploy* aplikasi ke lingkungan tertentu menggunakan skrip.

#### **2.2. Variabel: Menyimpan Informasi yang Berubah:**

Dalam pemrograman, variabel adalah lokasi penyimpanan yang diberi nama untuk data. Data tersebut bisa berupa teks, angka, atau hasil dari perintah. Variabel memungkinkan skrip Anda menjadi dinamis, artinya dapat beradaptasi dengan kondisi yang berbeda atau input pengguna.

* **Immutabilitas vs. Mutabilitas:** Variabel Bash secara *default* dapat berubah (mutable). Penting untuk memahami kapan data harus disimpan dalam variabel dan kapan harus langsung diproses.
* **Lingkungan Eksekusi:** Variabel juga mendefinisikan "lingkungan" di mana skrip Anda berjalan, memengaruhi bagaimana program menemukan file, berkomunikasi, dan berperilaku.

#### **2.3. Ekspansi Shell: Kekuatan di Balik Layar:**

Sebelum Bash menjalankan sebuah perintah, ia melakukan serangkaian "ekspansi". Ini berarti Bash mengganti bagian-bagian tertentu dari baris perintah dengan nilai-nilai yang sesuai. Memahami ini penting untuk menghindari perilaku tak terduga dan untuk memanfaatkan kemampuan Bash secara maksimal.

* **Urutan Eksekusi:** Shell tidak langsung mengeksekusi apa yang Anda ketik. Ada urutan langkah-langkah *parsing* dan *ekspansi* yang terjadi sebelum perintah utama dijalankan. Memahami urutan ini adalah kunci untuk *debugging* dan menulis skrip yang benar.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Membuat Skrip Bash Pertama (`.sh`):**

Setiap skrip Bash dimulai dengan apa yang disebut **shebang** (`#!`). Ini adalah baris pertama dalam skrip Anda yang memberi tahu sistem operasi *shell* mana yang harus digunakan untuk mengeksekusi skrip tersebut.

**Contoh 1: `halo_dunia.sh`**

```bash
#!/bin/bash
# Ini adalah komentar. Baris komentar diawali dengan '#'
# Skrip sederhana untuk mencetak pesan "Halo, Dunia!"

echo "Halo, Dunia!"
```

* **Penjelasan `#!/bin/bash` (Shebang):**
  * `#!`: Ini adalah "magic number" yang dikenali oleh *kernel* sebagai penanda untuk sebuah *interpreter*.
  * `/bin/bash`: Ini adalah jalur absolut ke *executable* Bash. Ketika Anda menjalankan skrip, sistem akan melihat baris ini dan menggunakan `/bin/bash` untuk menafsirkan dan mengeksekusi perintah-perintah di dalam skrip.
  * **Penting:** Selalu gunakan jalur absolut untuk *interpreter* (misalnya, `/bin/bash`, bukan hanya `bash`) untuk memastikan skrip Anda berjalan dengan *shell* yang benar terlepas dari variabel `PATH` pengguna.

#### **3.2. Menjadikan Skrip Dapat Dieksekusi (`chmod`):**

Secara *default*, file yang Anda buat tidak memiliki izin untuk dieksekusi. Anda harus secara eksplisit memberikan izin eksekusi menggunakan perintah `chmod` (change mode).

```bash
# Memberikan izin eksekusi kepada pemilik file
chmod u+x halo_dunia.sh

# Atau, memberikan izin eksekusi kepada semua pengguna (jika diperlukan)
# chmod +x halo_dunia.sh
```

* **Penjelasan `chmod u+x halo_dunia.sh`:**
  * `chmod`: Perintah untuk mengubah izin file.
  * `u+x`:
    * `u`: Mengacu pada "user" (pemilik file).
    * `+x`: Menambahkan (`+`) izin eksekusi (`x`).
  * `halo_dunia.sh`: File skrip yang ingin Anda ubah izinnya.
* **Konsep Izin File:** Di sistem Unix/Linux, setiap file memiliki izin yang menentukan siapa (pemilik, grup, orang lain) yang dapat membaca (r), menulis (w), dan mengeksekusi (x) file tersebut. Izin ini penting untuk keamanan sistem.

#### **3.3. Menjalankan Skrip:**

Setelah skrip memiliki izin eksekusi, Anda dapat menjalankannya.

```bash
# Menjalankan skrip dari direktori saat ini
./halo_dunia.sh

# Jika skrip ada di PATH sistem (misalnya, di /usr/local/bin)
# halo_dunia.sh
```

* **Penjelasan `./halo_dunia.sh`:**
  * `./`: Menunjukkan "direktori saat ini". Ini diperlukan karena Bash (dan shell lainnya) tidak mencari skrip di direktori saat ini secara *default* demi alasan keamanan. Anda harus secara eksplisit memberi tahu Bash untuk mencari skrip di lokasi relatif ini.
* **Jalur Absolut vs. Relatif:**
  * **Jalur Absolut:** Dimulai dari root (`/`). Contoh: `/home/user/myscripts/halo_dunia.sh`. Anda bisa menjalankan skrip dengan jalur absolut dari mana saja.
  * **Jalur Relatif:** Dimulai dari direktori saat ini. Contoh: `./halo_dunia.sh` (jika Anda berada di direktori yang sama dengan skrip).

#### **3.4. Variabel dalam Bash:**

Anda dapat membuat variabel untuk menyimpan nilai dan mereferensikannya nanti.

```bash
#!/bin/bash

# Mendefinisikan variabel
NAMA="Alice"
USIA=30 # Variabel tanpa tanda kutip dianggap angka jika hanya berisi digit
PESAN="Halo, $NAMA! Anda berusia $USIA tahun."

# Menggunakan variabel
echo $PESAN
echo "Nama saya adalah ${NAMA} dan saya berusia ${USIA} tahun."

# Menggunakan tanda kurung kurawal ({}) untuk menghindari ambiguitas
# Contoh:
# echo "Nilai variabel adalah $VAR_VALUE."
# echo "Nilai variabel adalah ${VAR}_VALUE." # Ini akan mencari variabel VAR_VALUE
```

* **Penjelasan Variabel:**
  * `NAMA="Alice"`: Mendefinisikan variabel `NAMA` dengan nilai string "Alice". Penting: **Tidak ada spasi** di sekitar tanda sama dengan (`=`).
  * `USIA=30`: Mendefinisikan variabel `USIA` dengan nilai numerik 30.
  * `$NAMA`, `${NAMA}`: Tanda `$` digunakan untuk **mengakses nilai** dari variabel. Penggunaan kurung kurawal (`{}`) disarankan untuk menghindari ambiguitas, terutama ketika nama variabel diikuti oleh karakter lain yang bisa disalahartikan sebagai bagian dari nama variabel itu sendiri.
  * **Tanda Kutip:**
    * **Kutipan Ganda (`"`):** Memungkinkan ekspansi variabel (seperti `$NAMA`) dan ekspansi perintah (`$(perintah)`), tetapi mencegah *word splitting* dan *pathname expansion* (globbing). Ini adalah pilihan terbaik untuk sebagian besar kasus saat Anda ingin variabel diekspansi.
    * **Kutipan Tunggal (`'`):** Mencegah semua jenis ekspansi. Apa pun di dalam kutipan tunggal diperlakukan sebagai string literal. Gunakan ini jika Anda ingin string ditampilkan persis seperti yang Anda ketik.
    * **Tanpa Kutip:** Memungkinkan semua ekspansi, tetapi juga melakukan *word splitting* (memisahkan string menjadi "kata-kata" berdasarkan spasi) dan *pathname expansion*. Berpotensi menyebabkan masalah jika nilai variabel mengandung spasi atau karakter *wildcard*. **Hindari ini untuk variabel yang berisi string dengan spasi.**

#### **3.5. Variabel Lingkungan (Environment Variables):**

Variabel lingkungan adalah variabel yang tersedia untuk semua proses yang berjalan di shell Anda, dan juga diwarisi oleh skrip yang Anda jalankan. Contohnya adalah `PATH`, `HOME`, `USER`.

```bash
#!/bin/bash

echo "Direktori home saya adalah: $HOME"
echo "Username saya adalah: $USER"
echo "PATH eksekusi program: $PATH"

# Membuat variabel lingkungan baru (akan tersedia untuk sub-proses/skrip lain)
export MY_CUSTOM_VAR="Nilai Kustom Saya"
echo "Variabel kustom: $MY_CUSTOM_VAR"
```

* **Penjelasan `export`:** Perintah `export` digunakan untuk mengubah variabel shell biasa menjadi variabel lingkungan, sehingga variabel tersebut dapat diwarisi oleh proses anak atau sub-skrip yang dijalankan dari shell tersebut.

#### **3.6. Input dari Pengguna: Argumen Baris Perintah**

Skrip dapat menerima input dalam bentuk argumen yang diberikan setelah nama skrip saat dijalankan. Bash menyediakan variabel khusus untuk mengakses argumen ini.

```bash
#!/bin/bash

# Menampilkan nama skrip
echo "Nama skrip ini adalah: $0"

# Menampilkan argumen pertama, kedua, dst.
echo "Argumen pertama: $1"
echo "Argumen kedua: $2"

# Menampilkan semua argumen sebagai string tunggal (dipisahkan oleh spasi)
echo "Semua argumen sebagai string tunggal: $*"

# Menampilkan semua argumen sebagai daftar terpisah (sering digunakan dalam loop)
echo "Semua argumen sebagai daftar: $@"

# Menampilkan jumlah argumen
echo "Jumlah argumen: $#"

# Contoh penggunaan:
# Jalankan skrip ini dengan: ./contoh_argumen.sh Hello World 123
```

* **Penjelasan Variabel Posisi:**
  * `$0`: Nama skrip itu sendiri.
  * `$1`, `$2`, `$3`, ...: Argumen posisi pertama, kedua, ketiga, dan seterusnya.
  * `$#`: Jumlah total argumen yang diberikan ke skrip (tidak termasuk `$0`).
  * `$*`: Mengekspansi semua argumen sebagai **satu string tunggal**. Jika dalam kutipan ganda (`"$*"`), mereka akan menjadi satu string tunggal dengan argumen dipisahkan oleh karakter pertama dari `IFS` (Internal Field Separator, *default*nya spasi).
  * `$@`: Mengekspansi semua argumen sebagai **daftar terpisah**. Jika dalam kutipan ganda (`"$@"`), setiap argumen akan diekspansi sebagai string yang terpisah, menjaga spasi dalam argumen tunggal. Ini sangat penting dan sering digunakan dalam perulangan `for`.

#### **3.7. Status Keluar (Exit Status): `$?`**

Setiap perintah yang dieksekusi di shell akan mengembalikan sebuah "status keluar" (exit status) atau "kode keluar" (exit code). Ini adalah angka yang menunjukkan apakah perintah berhasil diselesaikan atau tidak. Konvensinya:

* `0`: Berhasil diselesaikan tanpa kesalahan.
* Angka selain `0` (biasanya `1` hingga `255`): Terjadi kesalahan. Nilai spesifik sering menunjukkan jenis kesalahan tertentu.

Anda dapat memeriksa status keluar dari perintah terakhir yang dijalankan menggunakan variabel khusus `$?`.

```bash
#!/bin/bash

# Contoh 1: Perintah sukses
ls /tmp
echo "Status keluar 'ls /tmp': $?" # Akan mencetak 0

echo "---------------------"

# Contoh 2: Perintah gagal (direktori tidak ada)
ls /direktori/tidak/ada
echo "Status keluar 'ls /direktori/tidak/ada': $?" # Akan mencetak nilai selain 0 (misal: 1 atau 2)
```

* **Pentingnya `$`:** Memahami dan memeriksa `$?` adalah dasar dari *error handling* dalam *shell scripting*, yang akan dibahas lebih mendalam di Modul 3.1. Ini memungkinkan skrip Anda untuk mengambil tindakan berbeda tergantung pada keberhasilan atau kegagalan sebuah perintah.

#### **3.8. Ekspansi Shell (Shell Expansion):**

Bash melakukan berbagai jenis ekspansi sebelum menjalankan perintah. Memahami ini penting untuk mengontrol perilaku skrip Anda.

1. **Brace Expansion (`{}`):**
      * **Fungsi:** Menghasilkan string yang dapat diprediksi dari pola yang diberikan. Berguna untuk membuat daftar file atau direktori dengan cepat.
      * **Contoh:**

        ```bash
        echo file_{a,b,c}.txt   # Output: file_a.txt file_b.txt file_c.txt
        mkdir project_{v1,v2}/src # Membuat project_v1/src dan project_v2/src
        echo {1..5}             # Output: 1 2 3 4 5
        ```

2. **Tilde Expansion (`~`):**
      * **Fungsi:** Mengganti `~` dengan direktori *home* pengguna saat ini.
      * **Contoh:** `cd ~` (pergi ke direktori *home*), `cp ~/dokumen.txt .`
3. **Command Substitution (`$()` atau `` ` ``):**
      * **Fungsi:** Mengeksekusi perintah di dalam tanda kurung dan mengganti perintah tersebut dengan *output* standar dari perintah tersebut.
      * **Contoh:**

        ```bash
        CURRENT_DATE=$(date +%Y-%m-%d) # Menjalankan perintah date dan menyimpan outputnya ke variabel
        echo "Tanggal hari ini adalah: $CURRENT_DATE"

        # Bentuk lama (backticks), kurang disarankan karena masalah nesting
        # FILES=`ls -l`
        ```

      * **Konteks Flutter/Dart:** Anda seringkali perlu menjalankan perintah shell dari Dart (misalnya, menggunakan `Process.run`). Memahami *command substitution* adalah bagaimana perintah tersebut mendapatkan *output*-nya.
4. **Arithmetic Expansion (`(())` atau `$(( ))`):**
      * **Fungsi:** Melakukan operasi aritmatika integer.
      * **Contoh:**

        ```bash
        A=10
        B=5
        RESULT=$((A + B * 2))
        echo "Hasil: $RESULT" # Output: 20
        ```

5. **Parameter Expansion (`${variable}`):**
      * **Fungsi:** Sudah dibahas sebelumnya (`$nama_variabel`), tetapi juga mencakup operasi lebih lanjut seperti *substring extraction*, *default values*, dan *length*. Ini akan dibahas lebih detail di modul yang lebih lanjut, tetapi penting untuk menyadari cakupannya.
      * **Contoh Awal:** `echo ${#NAMA}` (mencetak panjang string NAMA)

### **4. Terminologi Esensial & Penjelasan Detil:**

* **Skrip Bash:** Sebuah file teks yang berisi serangkaian perintah Bash, yang dapat dieksekusi sebagai satu program.
* **Shebang (`#!`):** Baris pertama dalam skrip yang menentukan *interpreter* (misalnya, `/bin/bash`) yang harus digunakan untuk menjalankan skrip.
* **Executable:** Sebuah file (dalam konteks ini, skrip) yang memiliki izin untuk dijalankan sebagai program. Izin `x` (eksekusi) diperlukan.
* **Variabel:** Sebuah nama yang menyimpan nilai (teks, angka, dll.) dan dapat diakses serta dimanipulasi dalam skrip.
* **Variabel Lingkungan (Environment Variables):** Variabel yang tersedia untuk semua proses yang berjalan di dalam sebuah shell dan dapat diwarisi oleh proses anak. Mereka mendefinisikan lingkungan operasi. Contoh: `PATH`, `HOME`.
* **Argumen Baris Perintah (Command Line Arguments):** Input tambahan yang diberikan ke skrip saat skrip tersebut dijalankan dari baris perintah. Diakses menggunakan `$1`, `$2`, dst.
* **Status Keluar (Exit Status / Exit Code):** Sebuah angka (0-255) yang dikembalikan oleh setiap perintah setelah eksekusinya selesai, menunjukkan keberhasilan (0) atau kegagalan (non-0). Diakses melalui `$?`.
* **Ekspansi Shell (Shell Expansion):** Proses di mana Bash mengganti bagian-bagian tertentu dari baris perintah dengan nilai-nilai yang sesuai sebelum perintah dieksekusi. Ini termasuk *brace expansion*, *tilde expansion*, *command substitution*, *arithmetic expansion*, dan *parameter expansion*.

### **5. Rekomendasi Visualisasi (Jika Diperlukan):**

* **Diagram Alur Eksekusi Skrip:** Visualisasi yang menunjukkan langkah-langkah dari pengetikan `./myscript.sh` hingga eksekusi perintah di dalamnya, termasuk peran shebang dan bagaimana argumen baris perintah diproses.
* **Diagram Alur Proses Ekspansi Shell:** Sebuah *flowchart* yang menggambarkan urutan berbagai jenis ekspansi shell (misalnya, tilde -\> parameter -\> command -\> arithmetic -\> word splitting -\> pathname) akan sangat membantu dalam memahami bagaimana Bash "memproses" sebuah baris perintah.

### **6. Hubungan dengan Modul Lain:**

Modul 1.3 adalah jembatan yang kuat ke semua modul selanjutnya. Pemahaman tentang variabel dan argumen akan menjadi dasar untuk Modul 2.1 (Kondisional) dan 2.2 (Perulangan) karena Anda akan memanipulasi data dan membuat keputusan berdasarkan data tersebut. Konsep *exit status* sangat penting untuk Modul 3.1 (Penanganan Kesalahan). Kemampuan untuk membuat skrip yang dapat dieksekusi adalah prasyarat untuk setiap studi kasus dan otomasi di Fase 2, 3, dan 4. Ekspansi shell akan terus muncul dan menjadi penting dalam skrip yang lebih kompleks.

### **7. Sumber Referensi Lengkap:**

* **The Linux Command Line: A Complete Introduction (William E. Shotts, Jr.):** [http://linuxcommand.org/tlcl.php](http://linuxcommand.org/tlcl.php)
  * **Detail:** Buku gratis yang sangat direkomendasikan untuk pemula hingga menengah. Bab "Shell Scripting" (Chapter 26 dan seterusnya) mencakup semua konsep di modul ini dengan penjelasan yang sangat jelas dan contoh yang baik.
* **Advanced Bash-Scripting Guide (Mendel Cooper):** [https://tldp.org/LDP/abs/html/](https://tldp.org/LDP/abs/html/)
  * **Detail:** Meskipun "Advanced", bagian-bagian awal tentang "Basics" dan "Variables" adalah referensi yang sangat detail. Ini adalah sumber daya yang luar biasa untuk mendalami setiap detail.
* **Bash Reference Manual: Shell Parameters:** [https://www.gnu.org/software/bash/manual/bash.html\#Shell-Parameters](https://www.gnu.org/software/bash/manual/bash.html%23Shell-Parameters)
  * **Detail:** Dokumentasi resmi Bash. Bagian ini menjelaskan semua variabel khusus shell (seperti `$0`, `$@`, `$?`) secara rinci.
* **Bash Reference Manual: Shell Expansions:** [https://www.gnu.org/software/bash/manual/bash.html\#Shell-Expansions](https://www.gnu.org/software/bash/manual/bash.html%23Shell-Expansions)
  * **Detail:** Bagian yang sangat penting dari manual resmi yang menjelaskan berbagai jenis ekspansi yang dilakukan Bash. Ini mungkin agak padat untuk pemula, tetapi merupakan referensi definitif.
* **Permissions in Linux (GeeksforGeeks):** [https://www.geeksforgeeks.org/permissions-in-linux/](https://www.geeksforgeeks.org/permissions-in-linux/)
  * **Detail Tambahan (opsional):** Penjelasan mendalam tentang izin file Linux (`chmod`).

### **8. Tips dan Praktik Terbaik:**

* **Selalu Gunakan Shebang:** Pastikan setiap skrip Bash Anda dimulai dengan `#!/bin/bash` atau `#!/usr/bin/env bash` (yang lebih fleksibel karena mencari `bash` di `PATH`).
* **Berikan Izin Eksekusi:** Jangan lupa `chmod +x` setelah membuat skrip baru.
* **Gunakan Kutipan Ganda untuk Variabel:** Biasakan untuk selalu mengapit ekspansi variabel dengan kutipan ganda (`"$VARIABEL"`) kecuali Anda memang sengaja ingin *word splitting* atau *pathname expansion* terjadi (kasus yang jarang). Ini akan mencegah masalah tak terduga dengan spasi atau karakter khusus dalam nilai variabel.
* **Pahami Alur Eksekusi:** Ketika sebuah perintah gagal, segera periksa `$?`. Ini adalah *debugger* pertama Anda.
* **Komentar Skrip Anda:** Gunakan `#` untuk menambahkan komentar yang menjelaskan tujuan setiap bagian skrip. Ini sangat membantu orang lain (dan diri Anda di masa depan) memahami kode Anda.
* **Gunakan `shellcheck` (Wajib):** Integrasikan `shellcheck` ke dalam alur kerja Anda. Alat ini akan menganalisis skrip Anda dan memberikan peringatan tentang potensi masalah atau praktik buruk. Ini akan sangat meningkatkan kualitas skrip Anda. Anda bisa mengunjunginya di [ShellCheck Online](https://www.shellcheck.net/) atau menginstalnya secara lokal.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Lupa shebang atau shebang salah.
  * **Solusi:** Skrip tidak akan dieksekusi dengan *interpreter* yang benar, atau bahkan tidak bisa dieksekusi sama sekali. Selalu pastikan `#!/bin/bash` ada di baris pertama.
* **Kesalahan:** Lupa memberikan izin eksekusi (`chmod +x`).
  * **Solusi:** Anda akan mendapatkan pesan `Permission denied` saat mencoba menjalankan skrip. Jalankan `chmod u+x nama_skrip.sh`.
* **Kesalahan:** Mencoba menjalankan skrip tanpa `./` jika tidak ada di `PATH`.
  * **Solusi:** Skrip tidak akan ditemukan. Gunakan `./nama_skrip.sh` untuk menjalankan skrip di direktori saat ini.
* **Kesalahan:** Menggunakan spasi di sekitar `=` saat mendefinisikan variabel (`NAMA = "Alice"`).
  * **Solusi:** Bash akan menafsirkan `NAMA` sebagai perintah dan `=` serta `"Alice"` sebagai argumennya. Selalu pastikan `NAMA="Alice"` tanpa spasi.
* **Kesalahan:** Tidak mengapit `$*` atau `$@` dengan kutipan ganda saat meneruskan argumen yang mungkin berisi spasi.
  * **Solusi:** Ini akan menyebabkan masalah *word splitting*. Selalu gunakan `"$@"` dan `"$*"` dalam kutipan ganda untuk mempertahankan integritas argumen.
* **Kesalahan:** Mengandalkan `$?` tanpa melakukan validasi yang cukup.
  * **Solusi:** `$?` hanya mencerminkan status perintah terakhir. Jika Anda memiliki serangkaian perintah, Anda harus memeriksa `$?` setelah setiap perintah kritis. Atau gunakan `set -e` (akan dibahas nanti) untuk keluar secara otomatis jika ada perintah yang gagal.

# Selesai

Dengan penjelasan mendalam ini untuk Modul 1.3, yang mencakup pembuatan skrip pertama, penggunaan variabel, pemrosesan argumen, status keluar, dan berbagai ekspansi shell, Anda kini memiliki fondasi yang kuat untuk menulis skrip yang dinamis.

> * **[Ke Atas](#)**
> * **[Selanjutnya][selanjutnya]**
> * **[Kurikulum][kurikulum]**
> * **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->
 [1]:../README.md