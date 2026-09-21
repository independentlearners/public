# **Pemahaman Mendalam Mengenai Word Splitting**

Dalam lingkungan *shell scripting* (seperti Bash atau sh), **Word Splitting** adalah sebuah proses di mana *shell* secara otomatis memecah atau memotong string dari hasil ekspansi yang tidak diberi tanda kutip (seperti pemanggilan variabel, substitusi perintah, atau ekspansi aritmetika) menjadi argumen-argumen (kata) yang terpisah.

Pemecahan kata ini didasarkan pada variabel lingkungan khusus yang disebut **`IFS`** (*Internal Field Separator*). Secara *default*, `IFS` berisi karakter **Spasi (*Space*)**, **Tab**, dan **Baris Baru (*Newline*)**.

### Kapan dan Bagaimana Word Splitting Terjadi?

Ketika Anda memanggil sebuah variabel tanpa membungkusnya dengan tanda kutip ganda (`"..."`), *shell* akan memindai nilai variabel tersebut. Jika di dalam nilai tersebut terdapat karakter yang cocok dengan `IFS` (misalnya spasi), *shell* akan menganggapnya sebagai pemisah argumen, lalu memecah nilai tersebut menjadi potongan-potongan terpisah.

**Contoh Kasus yang Menimbulkan Masalah:**

```bash
# Kita mendeklarasikan variabel yang isinya mengandung spasi
nama_file="Laporan Keuangan 2023.pdf"

# Jika kita memanggilnya TANPA tanda kutip ganda
cat $nama_file

```

Pada perintah `cat $nama_file` di atas, Bash akan mengekspansi variabelnya menjadi `Laporan Keuangan 2023.pdf`. Karena tidak ada tanda kutip, terjadi *word splitting* berdasarkan spasi. Shell akhirnya mengeksekusi perintah seolah-olah Anda mengetik:
`cat "Laporan" "Keuangan" "2023.pdf"`
Hasilnya akan **error**, karena perintah `cat` mencoba membuka 3 file terpisah yang tidak ada, bukan satu file tunggal.

### Cara Mencegah Word Splitting

Praktik terbaik dalam *shell scripting* untuk mencegah *word splitting* adalah dengan **selalu membungkus pemanggilan variabel dengan tanda kutip ganda (`"..."`)**.

**Contoh Pencegahan:**

```bash
# Menggunakan tanda kutip ganda
cat "$nama_file"

```

Dengan tanda kutip ganda, Bash akan membungkus seluruh hasil ekspansi sebagai satu string tunggal. Perintah akan dieksekusi persis sebagai: `cat "Laporan Keuangan 2023.pdf"`.

---

### Penerapan pada File Bernama "Bash" di Notebook Anda

Di dalam file referensi Anda yang bernama "Bash", kita bisa melihat secara langsung implementasi dari praktik pencegahan *word splitting* ini agar skrip berjalan dengan aman:

* File tersebut berfungsi sebagai satu-satunya *orchestrator* untuk memuat komponen sesi Zsh interaktif pengguna.


* Di seluruh baris skrip tersebut, setiap pemanggilan variabel lingkungan untuk direktori (*path*) selalu diapit dengan tanda kutip ganda (`"..."`), contohnya pada baris `source "$ZSH_CONFIG_DIR/lib/loader.zsh"`.


* Tanda kutip ganda ini terus digunakan ketika skrip memuat berbagai komponen penting lainnya, seperti `zsh_load "$ZSH_CONFIG_DIR/config/environment.zsh"` atau saat memuat *history* perintah dan opsi perilaku bawaan.


* Selain untuk menjalankan *source*, pencegahan *word splitting* juga diimplementasikan pada operasi kondisi (*conditional*), seperti saat memastikan *loader* utama tersedia menggunakan blok `if [[ ! -r "$ZSH_CONFIG_DIR/lib/loader.zsh" ]]`.


* Tujuan utama pembungkusan string variabel tersebut adalah untuk mencegah *word splitting* jika *path* direktori konfigurasi pengguna (`$ZSH_CONFIG_DIR`) kebetulan mengandung spasi.


* Tanpa tanda kutip, jika terjadi perpecahan string (misal: jalurnya adalah `/home/user/my config/zsh`), *shell* akan gagal menemukan file yang dibutuhkan dan mengembalikan *error* yang dapat menghentikan proses *startup*, yang mana dirancang untuk dicegah agar konfigurasi tidak berjalan dalam keadaan setengah terpasang.
