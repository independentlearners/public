> **Motifasi:** Membangun pemahaman yang mendalam (deep learning) membutuhkan kesabaran dan ketelitian. Maksimalkan waktu anda sebaik mungkin sebelum sesuatu mangambil sebagian besar waktu yang anda miliki sekarang adalah cara terbaik untuk mewujudkan apa yang di sebut sebagai bagian dari keberhasilan yang ingin anda gapai dalam kehidupan ini. **Selamat Belajar!**

---

Mari kita mulai perjalanan ini secara mendalam.

# PHASE 1: The Foundation – Berbicara dengan Kernel

**Fokus Utama:** Navigasi, Manipulasi File, dan Pemahaman Sistem Operasi tanpa Mouse.

-----

## MODUL 1.1: Anatomi Command Line & Navigasi File System

<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Shell:** Mengapa layar hitam (terminal) lebih berkuasa daripada GUI.
2.  **Struktur Pohon (Filesystem Hierarchy Standard):** Memahami peta dunia Linux.
3.  **Perintah Navigasi Inti:** `pwd`, `ls`, `cd`.
4.  **Konsep Kunci:** Absolute Path vs Relative Path.
5.  **Studi Kasus:** "Dimana saya dan bagaimana saya pulang?"

</details>

-----
### 1\. Deskripsi Konkret & Peran

Modul ini adalah langkah pertama bayi berjalan. Di sini, Anda belajar "berjalan" di dalam komputer. Tanpa modul ini, Anda tidak akan bisa menemukan file yang akan Anda script nanti. Perannya adalah mengubah mental model Anda dari "Mencari file dengan mata (ikon)" menjadi "Mencari file dengan alamat (path)".

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Everything is a File" & "The Shell"**
Di Windows atau macOS, Anda melihat tombol, menu, dan ikon. Itu adalah ilusi yang dibuat untuk memudahkan manusia. Di balik layar, Linux/Unix melihat segala sesuatu sebagai file (dokumen, hard drive, keyboard, koneksi internet, semua dianggap file).

**Shell (Cangkang)** adalah program yang melindungi **Kernel (Biji/Inti)**.

  * **Kernel:** Otak yang mengurus listrik ke hardware. Dia hanya bicara bahasa biner/mesin.
  * **Shell (Bash):** Penerjemah. Dia mengambil teks bahasa Inggris yang Anda ketik, menerjemahkannya ke biner untuk Kernel, lalu menampilkan hasil terjemahan Kernel kembali ke layar Anda dalam bentuk teks.

> **Analogi:** Bayangkan Anda di restoran (Komputer). Anda (User) tidak boleh masuk ke dapur (Hardware/Kernel) karena berbahaya. Anda harus memesan makanan lewat Pelayan (Shell). Anda bilang "Nasi Goreng" (Perintah/Command), Pelayan meneriakkan kode ke Dapur, Dapur memasak, dan Pelayan membawakan makanan ke meja Anda.

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Mengetahui Lokasi Kita: `pwd`

Sebelum bergerak, kita harus tahu posisi kita.

```bash
pwd
```

**Penjelasan Sintaks:**

  * `pwd`: Singkatan dari **P**rint **W**orking **D**irectory (Cetak Direktori Kerja).

**Output:**
`/home/user`
Artinya: Anda sedang berada di dalam folder `user`, yang ada di dalam folder `home`, yang ada di akar sistem (`/`).

#### B. Melihat Isi Folder: `ls`

Pelayan, apa menu yang tersedia di sini?

```bash
ls -la
```

**Penjelasan Sintaks Kata per Kata:**

  * `ls`: Singkatan dari **L**i**s**t. Perintah utama untuk menampilkan daftar file.
  * `-`: Tanda hubung yang menandakan kita akan memberikan opsi tambahan (disebut **Flags** atau **Arguments**).
  * `l`: Singkatan dari **L**ong format. Menampilkan detail (siapa pemiliknya, berapa ukurannya, kapan dibuat). Tanpa ini, Anda hanya melihat nama file.
  * `a`: Singkatan dari **A**ll. Menampilkan file tersembunyi (file yang namanya diawali titik `.`). Di Linux, file konfigurasi sering disembunyikan.

**Ilustrasi Output:**

```text
drwxr-xr-x  2 budi  staff   64 Nov 20 10:00 .
drwxr-xr-x  5 root  admin  160 Nov 19 09:00 ..
-rw-r--r--  1 budi  staff  200 Nov 20 10:01 .bashrc  <-- File tersembunyi
-rw-r--r--  1 budi  staff  500 Nov 20 12:00 notes.txt
```
Arti dari Output diatas dijelaskan [disini][1] tetapi mungkin bagi pemula ini justru semakin membingungkan, sebaiknya anda kembali melihatnya setelah anda nyaman menggunakan terminal. Untuk sekarang mari sebaiknya kita fokus melanjutkan. 

#### C. Berpindah Tempat: `cd`

Mari pindah ke ruangan lain.

```bash
cd /etc
```

**Penjelasan Sintaks:**

  * `cd`: Singkatan dari **C**hange **D**irectory.
  * `/etc`: **Argumen** tujuan. Ini adalah alamat absolut (dijelaskan di bawah).

Untuk perintah lainnya dilinux yang sangat membantu anda bisa mengunjunginya [disini][2]

-----

### 4\. Konsep Kritis: Absolute vs Relative Path

Ini adalah konsep yang **paling sering** membingungkan pemula.

*Saran Visual:* Bayangkan pohon terbalik. Akarnya (`/`) ada di atas. Cabang-cabangnya turun ke bawah.

  * **Absolute Path (Alamat Lengkap):** Selalu dimulai dengan garis miring `/` (Root). Ini seperti memberikan koordinat GPS lengkap. Tidak peduli Anda sedang di mana, alamat ini selalu valid.

      * Contoh: `/home/budi/Documents/Surat.pdf`
      * Analogi: "Jalan Jendral Sudirman No. 5, Jakarta."

  * **Relative Path (Alamat Relatif):** Tidak dimulai dengan `/`. Ini bergantung pada posisi Anda sekarang.

      * Contoh: `Documents/Surat.pdf` (Hanya berhasil jika Anda sudah berada di `/home/budi`).
      * Analogi: "Belok kiri, lalu rumah ketiga." (Petunjuk ini salah jika Anda start dari tempat yang berbeda).

**Simbol Khusus Jalur:**

  * `.` (Satu titik): "Di sini" (Folder saat ini).
  * `..` (Dua titik): "Mundur satu langkah" (Folder induk/atasnya).

**Studi Kasus Implementasi:**
Anda berada di `/home/budi/Music` dan ingin mundur ke `/home/budi` lalu masuk ke `Pictures`.

  * Cara Absolut: `cd /home/budi/Pictures` (Aman, pasti berhasil).
  * Cara Relatif: `cd ../Pictures` (Lebih cepat diketik, mundur satu level, lalu masuk Pictures).

-----

### 5\. Terminologi Esensial

1.  **CLI (Command Line Interface):** Antarmuka berbasis teks. Lawan dari GUI (Graphical User Interface).
2.  **Directory:** Istilah teknis untuk "Folder".
3.  **Root (`/`):** Titik awal dari seluruh sistem file Linux. Tidak ada yang lebih tinggi dari Root. Sama seperti `C:\` di Windows, tapi Linux hanya punya satu Root untuk semua drive.
4.  **Flag / Option:** Modifikasi perilaku perintah, biasanya diawali `-` (misal `-l` pada `ls -l`).
5.  **Argument:** Objek yang dikenai perintah (misal `Documents` pada `cd Documents`).
6.  **Hidden File:** File yang diawali tanda titik (`.config`). Biasanya berisi pengaturan aplikasi.

-----

### 6\. Hubungan dengan Modul Lain

  * **Prasyarat untuk:** **Modul 1.2 (Manipulasi File)**. Anda tidak bisa menyalin atau menghapus file jika Anda tidak bisa menavigasi ke lokasi file tersebut (`cd`) atau melihatnya (`ls`).
  * **Prasyarat untuk:** **Fase 2 (Scripting)**. Dalam script, Anda harus menulis jalur file (Path) dengan tepat agar script bisa berjalan otomatis tanpa error "File not found".

### 7\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [GNU Coreutils - pwd](https://www.gnu.org/software/coreutils/manual/html_node/pwd-invocation.html)
  * **Tutorial Interaktif:** [Linux Journey - Navigation](https://linuxjourney.com/lesson/the-shell)
  * **Standard:** [Filesystem Hierarchy Standard (FHS)](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) - Dokumen resmi yang menjelaskan kenapa folder `/etc` atau `/bin` ada.

### 8\. Tips & Praktik Terbaik

  * **Gunakan `Tab` Completion:** Jangan ketik nama folder secara manual dan lengkap\! Ketik 3 huruf pertama, lalu tekan tombol `Tab` di keyboard. Terminal akan melengkapinya otomatis. Ini mencegah *typo* (salah ketik).
  * **Tahu jalan pulang:** Jika Anda tersesat di kedalaman folder, ketik `cd` (tanpa argumen) lalu Enter. Itu akan langsung memulangkan Anda ke "Home Directory" (`~` atau `/home/user_anda`).

### 9\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Mengetik `cd/home` (tanpa spasi).
      * **Solusi:** Komputer sangat literal. `cd` adalah perintah, `/home` adalah tujuan. Mereka harus dipisah spasi: `cd /home`.
  * **Kesalahan:** Salah huruf besar/kecil (Case Sensitivity).
      * **Masalah:** Di Linux, `File.txt`, `file.txt`, dan `FILE.TXT` adalah 3 file yang berbeda.
      * **Solusi:** Selalu perhatikan kapitalisasi. Gunakan `ls` untuk mengecek nama asli file.
  * **Kesalahan:** Terjebak di folder root atau folder sistem dan tidak bisa membuat file (Permission Denied).
      * **Solusi:** Pahami bahwa user biasa hanya boleh mengacak-acak di dalam `/home/user_anda`. Jangan bermain di `/bin` atau `/etc` tanpa izin khusus (yang akan dibahas di Modul tentang `sudo`).

-----

## MODUL 1.2: Manipulasi File & Folder (Creation, Destruction & Organization)

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Destruktif:** Mengapa Linux tidak memiliki "Recycle Bin" secara default.
2.  **Penciptaan:** `mkdir` (Folder) dan `touch` (File).
3.  **Duplikasi & Pemindahan:** `cp` (Copy) vs `mv` (Move/Rename).
4.  **Penghapusan:** `rm` dan bahaya latennya.
5.  **Magic Tools (Wildcards/Globbing):** Mengelola 1000 file dengan 1 karakter (`*`).
6.  **Studi Kasus:** Mengorganisir folder proyek yang berantakan.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan Anda menjadi "Tukang Bangunan" di dalam sistem operasi. Anda akan belajar membangun struktur direktori, menduplikasi data, memindahkan aset, dan menghancurkan apa yang tidak lagi berguna.
**Peran:** Ini adalah *keterampilan motorik halus* bagi seorang SysAdmin. Tanpa modul ini, Anda hanya penonton pasif di terminal. Di sini Anda mulai mengubah keadaan sistem.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "No Undo Button" (Ketegasan Tindakan)**
Dalam GUI (Windows/Mac), saat Anda menghapus file, file itu masuk ke "Sampah". Anda bisa memulihkannya. Di Terminal Linux, **penghapusan bersifat permanen**. Begitu Anda menekan Enter pada perintah `rm`, data tersebut dihapus dari *inode table* (daftar isi hard drive) dan ruangnya ditandai "kosong" untuk ditimpa data lain.

**Filosofi: "Renaming is Moving"**
Di Linux, mengganti nama file (`rename`) dan memindahkan file (`move`) adalah operasi yang **sama** di mata sistem file. Keduanya hanya mengubah "alamat" atau "label" file tersebut tanpa mengubah isi datanya secara fisik di hard disk (selama masih dalam partisi yang sama).

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Menciptakan Struktur: `mkdir`

Membuat folder baru untuk menyimpan file kerja.

```bash
mkdir -p Proyek/Data/2024
```

**Penjelasan Sintaks Kata per Kata:**

  * `mkdir`: Singkatan dari **M**a**k**e **Dir**ectory.
  * `-p`: Singkatan dari **P**arents. Ini adalah opsi *best practice*. Jika folder `Proyek` dan `Data` belum ada, perintah ini akan membuatnya sekaligus secara otomatis. Tanpa `-p`, perintah akan error jika folder induknya tidak ada.
  * `Proyek/Data/2024`: Argumen jalur folder yang ingin dibuat.

#### B. Membuat File Kosong: `touch`

Sering digunakan oleh programmer untuk membuat file *placeholder* sebelum diisi kode.

```bash
touch script_baru.sh
```

**Penjelasan Sintaks:**

  * `touch`: Secara harfiah artinya "sentuh".
      * *Fungsi 1:* Jika file belum ada, dia akan membuat file kosong (0 bytes).
      * *Fungsi 2:* Jika file sudah ada, dia akan **memperbarui timestamp** (waktu terakhir diakses) menjadi "sekarang", tanpa mengubah isi file.
  * `script_baru.sh`: Nama file yang dibuat.

#### C. Menyalin Data: `cp`

Menduplikasi file atau folder.

**Kasus 1: Menyalin File**

```bash
cp laporan.txt laporan_backup.txt
```

  * `cp`: **C**o**p**y.
  * `laporan.txt`: *Source* (Sumber/Asal).
  * `laporan_backup.txt`: *Destination* (Tujuan/Nama Baru).

**Kasus 2: Menyalin Folder (Wajib Tahu)**

```bash
cp -r FolderAsli FolderCadangan
```

  * `-r`: Singkatan dari **R**ecursive. **Sangat Penting\!** Secara default, `cp` tidak bisa menyalin folder. Opsi `-r` memerintahkan `cp` untuk masuk ke dalam folder, menyalin isinya, masuk ke sub-folder, menyalin isinya lagi, dan seterusnya sampai tuntas.

#### D. Memindahkan & Mengganti Nama: `mv`

Satu perintah, dua fungsi.

**Fungsi 1: Memindahkan (Pindah Rumah)**

```bash
mv file.txt /home/budi/Documents/
```

  * `mv`: **M**o**v**e.
  * Mengambil `file.txt` dan menaruhnya di dalam folder `Documents`.

**Fungsi 2: Rename (Ganti Nama)**

```bash
mv file_lama.txt file_baru.txt
```

  * Logika sistem: "Pindahkan konten `file_lama.txt` ke alamat baru bernama `file_baru.txt` di lokasi yang sama." Hasilnya adalah ganti nama.

#### E. Penghapusan: `rm` (The Danger Zone)

Menghapus file atau folder selamanya.

```bash
rm -rf FolderSampah
```

**Penjelasan Sintaks Kata per Kata:**

  * `rm`: **R**e**m**ove.
  * `-r`: **R**ecursive. Diperlukan jika yang dihapus adalah folder (beserta isinya).
  * `-f`: **F**orce. Menghapus tanpa bertanya "Apakah Anda yakin?". Ini **sangat berbahaya** tapi sering digunakan dalam script otomasi agar script tidak berhenti (hang) menunggu konfirmasi user.
  * `FolderSampah`: Target yang akan dimusnahkan.

-----

### 4\. Konsep Lanjutan: Wildcards (Globbing)

Bagaimana jika Anda ingin memindahkan 500 file gambar `.jpg` ke folder Gambar? Mengetik satu-satu adalah mustahil. Kita gunakan **Wildcards**.

**Simbol Bintang (`*`):** Mewakili "teks apa saja, sepanjang apa saja".

**Contoh Implementasi:**

```bash
mv *.jpg /home/budi/Pictures/
```

  * `*.jpg`: Cocok dengan `foto.jpg`, `liburan.jpg`, `a.jpg`.
  * Tidak cocok dengan `foto.png`.

**Simbol Tanya (`?`):** Mewakili "tepat satu karakter apa saja".

  * `file?.txt`: Cocok dengan `file1.txt`, `fileA.txt`.
  * Tidak cocok dengan `file10.txt` (karena 10 adalah dua karakter).

*(Visualisasi disarankan: Gambar corong filter. Di atas masuk berbagai bentuk file. Di tengah ada saringan berbentuk bintang. Di bawah hanya keluar file yang sesuai pola).*

-----

### 5\. Terminologi Esensial

1.  **Recursive:** Proses melakukan sesuatu berulang-ulang ke dalam struktur yang lebih dalam (seperti membuka boneka Matryoshka Rusia). Wajib untuk operasi folder.
2.  **Globbing:** Proses Shell mengembangkan karakter wildcard (`*`) menjadi daftar nama file yang sebenarnya sebelum perintah dijalankan.
3.  **Empty File:** File yang ada namanya tapi ukurannya 0 byte. Berguna untuk penanda (flag) atau inisialisasi.
4.  **Destructive Command:** Perintah yang mengubah atau menghapus data (seperti `rm`, `mv`, `cp` yang menimpa).

-----

### 6\. Hubungan dengan Modul Lain

  * **Prasyarat:** Anda harus paham **Modul 1.1 (Navigasi)** untuk tahu file mana yang sedang Anda manipulasi.
  * **Koneksi ke Depan:** **Modul 1.3 (Permissions)**. Setelah Anda membuat file dengan `touch` atau `mkdir` di modul ini, Anda akan belajar cara mengamankannya agar tidak dibaca orang lain di modul berikutnya.
  * **Koneksi ke Depan:** **Fase 3 (Pipes & Grep)**. Wildcards (`*`) yang dipelajari di sini adalah dasar pemahaman untuk *Regular Expressions* (Regex) yang jauh lebih kompleks nanti.

### 7\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi GNU:** [GNU Coreutils - rm](https://www.gnu.org/software/coreutils/manual/html_node/rm-invocation.html)
  * **Panduan Komunitas:** [Ryan's Tutorials - File Manipulation](https://www.google.com/search?q=https://ryanstutorials.net/linuxtutorial/file-manipulation.php) - Tutorial visual yang sangat bagus untuk pemula.
  * **Deep Dive:** [Article: How Linux Deletes Files](https://www.google.com/search?q=https://www.linux.com/training-tutorials/how-linux-deletes-files/) - Penjelasan teknis tentang inode dan unlink.

### 8\. Tips dan Praktik Terbaik

  * **The "ls" First Rule:** Sebelum melakukan perintah berbahaya dengan wildcard (seperti `rm *.txt`), lakukanlah `ls *.txt` terlebih dahulu. Ini memastikan Anda melihat file apa saja yang *akan* terhapus. Jika daftarnya benar, baru ganti `ls` dengan `rm`.
  * **Backup Sebelum Overwrite:** Saat menggunakan `cp`, gunakan opsi `-i` (interactive). Contoh: `cp -i a.txt b.txt`. Jika `b.txt` sudah ada, sistem akan bertanya "Overwrite?" untuk mencegah data hilang tak sengaja.

### 9\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Menghapus folder dengan `rm namafolder` saja.
      * **Error:** `rm: cannot remove 'namafolder': Is a directory`.
      * **Solusi:** Ingat, folder butuh opsi **Recursive**. Gunakan `rm -r namafolder`.
  * **Kesalahan:** Spasi mematikan pada `rm`.
      * **Skenario:** Anda ingin menghapus folder "Project Lama". Anda mengetik: `rm -rf Project Lama`.
      * **Bencana:** Sistem membaca ini sebagai "Hapus folder `Project` DAN hapus folder `Lama`". Jika ada folder penting bernama `Project`, folder itu akan hilang.
      * **Solusi:** Gunakan tanda kutip untuk nama file berspasi: `rm -rf "Project Lama"`. Atau lebih baik, **jangan gunakan spasi pada nama file di Linux**. Gunakan underscore (`Project_Lama`) atau camelCase (`ProjectLama`).

-----

Sebelum kita bisa mengatur "Izin" (Permissions) atau menulis "Script" (Fase 2), kita menghadapi satu **kesenjangan kritis**: Kita perlu alat untuk menulis kode tersebut. Di dunia GUI, Anda punya Notepad atau VS Code. Di dunia server (CLI) yang seringkali tidak memiliki layar grafis, Anda harus menggunakan **Terminal Text Editor**.

Oleh karena itu, **Modul 1.3** ini adalah modul tambahan (hasil audit) yang sangat krusial sebelum kita masuk ke Permissions.

-----

## MODUL 1.3: The Editor – Melukis di Terminal (Nano & Vim)

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Teks:** Mengapa Linux sangat bergantung pada file teks polos (*plain text*).
2.  **Nano (The Savior):** Editor sederhana untuk pemula dan situasi darurat.
3.  **Vim (The Surgeon's Scalpel):** Editor tingkat lanjut, konsep "Modal Editing", dan navigasi keyboard.
4.  **Perbandingan:** Kapan pakai Nano, kapan pakai Vim.
5.  **Studi Kasus:** Mengedit file konfigurasi dummy.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan Anda cara membuka, mengedit, dan menyimpan isi file langsung dari terminal tanpa menggunakan mouse.
**Peran:** Ini adalah "pena" Anda. Tanpa menguasai salah satu editor ini, Anda tidak akan bisa mengubah konfigurasi sistem (`.bashrc`), menulis script, atau memperbaiki server yang rusak lewat SSH. SysAdmin yang tidak bisa menggunakan terminal editor seperti dokter bedah tanpa pisau.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Plain Text is Universal"**
Di Windows, konfigurasi sering disimpan di *Registry* (database biner yang rumit). Di Linux, hampir **semua** konfigurasi disimpan sebagai file teks biasa yang bisa dibaca manusia. Ini berarti jika Anda bisa mengedit teks, Anda bisa mengendalikan seluruh sistem operasi.

**Filosofi Vim: "Mouse-less Efficiency"**
Vim didesain dengan asumsi bahwa memindahkan tangan dari keyboard ke mouse itu membuang waktu. Vim memungkinkan Anda menavigasi, mengedit, dan memanipulasi teks dengan kecepatan pikiran, hanya menggunakan tombol huruf di keyboard.

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. GNU Nano (Pilihan Pemula)

Nano adalah editor "modeless" (mirip Notepad). Apa yang Anda ketik, langsung muncul.

**Membuka/Membuat File:**

```bash
nano catatan.txt
```

**Interface Nano:**
Di bagian bawah layar Nano, Anda akan melihat baris bantuan seperti `^X Exit`.

  * Tanda `^` (Caret) berarti tombol **CTRL**.
  * Jadi `^X` berarti tekan **CTRL** dan **X** secara bersamaan.

**Operasi Inti Nano (Langkah demi Langkah):**

1.  Ketik teks apapun, misal: "Halo Dunia".
2.  **Simpan (Write Out):** Tekan `Ctrl + O`.
      * Nano akan bertanya: *File Name to Write: catatan.txt*. Tekan **Enter**.
3.  **Keluar (Exit):** Tekan `Ctrl + X`.

-----

#### B. VIM (Vi IMproved) - Standar Industri

Ini adalah tantangan terbesar pemula. Vim bukan sekadar editor, ia adalah "bahasa" pengeditan teks.

**Membuka File:**

```bash
vim script_hebat.sh
```

**Konsep Inti: The MODES (Mode)**
Vim memiliki "kepribadian ganda". Anda tidak bisa langsung mengetik saat pertama membukanya.

1.  **Normal Mode (Default):** Tombol keyboard berfungsi sebagai perintah navigasi/edit (misal: `x` untuk hapus, `u` untuk undo). Anda tidak bisa mengetik teks di sini.
2.  **Insert Mode:** Tombol keyboard berfungsi untuk mengetik teks (seperti Notepad biasa).
3.  **Command Mode:** Untuk perintah tingkat tinggi (simpan, keluar).

*(Visualisasi Direkomendasikan: Diagram segitiga. Sudut atas "Normal Mode". Panah ke kanan bawah "Insert Mode" dipicu tombol `i`. Panah kembali ke atas dipicu tombol `Esc`. Panah ke kiri bawah "Command Mode" dipicu tombol `:`).*

**Sintaks & Alur Kerja Vim (Sangat Detail):**

*Skenario: Kita ingin membuat file, isi teks, simpan, dan keluar.*

1.  **Masuk:** Ketik `vim tes.txt` lalu Enter. (Anda sekarang di **Normal Mode**).
2.  **Ubah ke Insert:** Tekan huruf `i` (singkatan dari **I**nsert).
      * *Indikator:* Di pojok kiri bawah layar muncul tulisan `-- INSERT --`.
3.  **Ketik:** Ketik teks "Belajar Vim itu seru".
4.  **Kembali ke Normal:** Tekan tombol `Esc` (Escape).
      * *Indikator:* Tulisan `-- INSERT --` menghilang.
5.  **Simpan & Keluar:**
      * Tekan titik dua `:`. (Kursor pindah ke paling bawah layar).
      * Ketik `w` (**W**rite/Simpan).
      * Ketik `q` (**Q**uit/Keluar).
      * Tekan **Enter**.
      * Gabungan: `:wq` (Simpan lalu keluar).

**Tombol Sakti di Normal Mode:**

  * `dd`: Hapus (potong) satu baris penuh.
  * `yy`: Copy (yank) satu baris penuh.
  * `p`: Paste (tempel) di bawah kursor.
  * `u`: Undo (Membatalkan perubahan terakhir).
  * `/kata`: Mencari "kata" dalam dokumen.

-----

### 4\. Terminologi Esensial

1.  **Buffer:** Saat Anda membuka file di Vim/Nano, file itu disalin dari harddisk ke memori (RAM). Salinan di RAM ini disebut Buffer. Perubahan tidak permanen sampai Anda menyimpannya ke disk (`:w`).
2.  **Keybinding / Shortcut:** Kombinasi tombol untuk melakukan aksi.
3.  **Syntax Highlighting:** Fitur editor yang mewarnai teks berdasarkan jenisnya (misal: perintah bash warna hijau, variabel warna merah) untuk memudahkan pembacaan kode.
4.  **Panic Button (Vim):** Tombol `Esc`. Jika Anda bingung sedang di mode apa, tekan `Esc` beberapa kali sampai Anda yakin kembali ke Normal Mode.

-----

### 5\. Hubungan dengan Modul Lain

  * **Prasyarat:** Modul 1.1 & 1.2 (Anda harus bisa menavigasi ke folder tempat file dibuat).
  * **Koneksi ke Depan:** **Modul 1.4 (Permissions)**. Kita akan menggunakan editor ini untuk menguji apakah kita *bisa* mengedit file yang dikunci (read-only).
  * **Koneksi ke Depan:** **Fase 2 (Scripting)**. Anda akan menghabiskan 90% waktu Anda di dalam editor ini untuk menulis kode Bash.

### 6\. Sumber Referensi Lengkap

  * **Game Pembelajaran:** [Vim Adventures](https://vim-adventures.com/) - Belajar Vim sambil bermain game RPG. (Sangat direkomendasikan untuk visual learner).
  * **Simulasi Online:** [OpenVim](https://www.openvim.com/) - Tutorial interaktif tanpa perlu install.
  * **Dokumentasi Resmi:** [GNU Nano Manual](https://www.nano-editor.org/dist/latest/nano.html).

### 7\. Tips dan Praktik Terbaik

  * **Pilih Senjata Anda:**
      * Gunakan **Nano** untuk edit cepat konfigurasi kecil atau jika Anda panik.
      * Pelajari **Vim** untuk produktivitas jangka panjang. Investasi waktu 2 minggu belajar Vim akan menghemat ratusan jam di masa depan.
  * **Jangan Menghafal Semuanya:** Cukup hafal alur dasar Vim: `i` (tulis), `Esc` (selesai), `:wq` (simpan keluar). Sisanya akan datang seiring waktu.

### 8\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan (Vim):** "Saya terjebak di Vim\! Saya mengetik tapi tidak muncul apa-apa, atau malah barisnya hilang."
      * **Penyebab:** Anda mengetik di **Normal Mode**. Anda mungkin tidak sengaja menekan `d` (delete) atau perintah lain.
      * **Solusi:** Tekan `Esc` beberapa kali. Lalu ketik `:q!` (Quit Bang/Paksa Keluar). Tanda seru `!` memaksa keluar **tanpa menyimpan** perubahan agar file tidak rusak karena ketikan acak Anda.
  * **Kesalahan (Nano):** Menutup terminal (`X` di window) tanpa menyimpan.
      * **Penyebab:** Lupa `Ctrl+O`.
      * **Solusi:** Biasakan alur `Ctrl+O` -\> `Enter` -\> `Ctrl+X`.

-----

Setelah kita memiliki "Pena" (Editor) dan kemampuan "Membangun" (Manipulasi File), kita siap untuk belajar tentang **Hukum & Keamanan**.

Sekarang kita memasuki salah satu pilar paling fundamental dari keamanan Linux.

Jika Modul 1.2 adalah tentang "Membangun Rumah", maka **Modul 1.4** adalah tentang "Memasang Kunci Pintu". Tanpa pemahaman ini, script yang Anda buat nanti tidak akan bisa berjalan, atau sebaliknya, sistem Anda bisa diretas karena pintu yang terbuka lebar.

-----

# PHASE 1: The Foundation

## MODUL 1.4: Permissions (Izin) & Ownership (Kepemilikan)

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Multi-User:** Mengapa Linux membeda-bedakan perlakuan terhadap pengguna.
2.  **Decoding `ls -l`:** Membaca kode matriks izin (`drwxr-xr-x`).
3.  **The Trinity (User, Group, Others):** Siapa yang boleh melakukan apa.
4.  **Matematika Izin (Octal Mode):** Mengapa angka `755` dan `644` adalah angka keramat.
5.  **Symbolic Mode:** Mengubah izin dengan logika manusia (`u+x`).
6.  **Ownership:** Mengganti pemilik aset dengan `chown`.
7.  **Studi Kasus:** Menyiapkan script agar bisa dieksekusi.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengupas tuntas sistem keamanan file Linux. Anda akan belajar menentukan siapa yang boleh membaca rahasia Anda, siapa yang boleh mengubah data Anda, dan siapa yang boleh menjalankan program Anda.
**Peran:** Ini adalah "gerbang tol" sebelum masuk ke Fase Scripting. Script Bash hanyalah file teks biasa sampai Anda memberikan izin **Execute (`x`)**. Tanpa modul ini, script Anda mati.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Linux is Multi-User by Design"**
Sejak lahir, Unix/Linux didesain untuk komputer besar (Mainframe) yang dipakai ratusan orang sekaligus. Karena itu, isolasi data sangat krusial. File milik `Budi` tidak boleh dihapus oleh `Siti` kecuali `Budi` mengizinkannya.

**Konsep: The Three Actions (R, W, X)**
Setiap file memiliki tiga tombol aksi potensial:

1.  **Read (r):**
      * *Pada File:* Bisa melihat isi (cat/nano).
      * *Pada Folder:* Bisa melihat daftar isi folder (`ls`).
2.  **Write (w):**
      * *Pada File:* Bisa mengedit atau menghapus isi file.
      * *Pada Folder:* Bisa membuat (`mkdir`) atau menghapus (`rm`) file *di dalam* folder tersebut. **(Penting: Izin menghapus file ditentukan oleh izin folder induknya, bukan izin file itu sendiri\!)**.
3.  **Execute (x):**
      * *Pada File:* Bisa dijalankan sebagai program/script.
      * *Pada Folder:* Bisa *masuk* ke dalamnya (`cd`). Tanpa `x` pada folder, Anda tidak bisa masuk meski punya `r`.

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Membedah Kode: `ls -l`

Mari kita lihat "KTP" dari sebuah file. Jalankan `ls -l` di terminal.

**Contoh Output:**

```text
-rwxr-xr--  1  budi  devs   8920  Nov 20 14:00  script.sh
```

**Analisis Anatomi (Kiri ke Kanan):**

1.  **Tipe File (Karakter Pertama):**
      * `-`: File biasa (teks, gambar, program).
      * `d`: Directory (folder).
2.  **Izin (9 Karakter Berikutnya):** `rwxr-xr--`
      * Ini dibagi menjadi 3 blok (Triad):
      * **Blok 1 (Owner/User):** `rwx` (Si `budi` bisa Baca, Tulis, Eksekusi).
      * **Blok 2 (Group):** `r-x` (Grup `devs` bisa Baca dan Eksekusi, tapi **tidak** bisa Tulis/Edit). Tanda `-` berarti izin dicabut.
      * **Blok 3 (Others/World):** `r--` (Orang asing hanya bisa Baca).
3.  **Owner:** `budi` (Pemilik file).
4.  **Group:** `devs` (Kelompok pemilik file).

*(Visualisasi: Diagram balok yang memecah `-rwxrwxrwx` menjadi 3 kotak warna berbeda: User, Group, Others).*

#### B. Mengubah Izin: `chmod` (Change Mode)

Ada dua cara melakukan ini: Cara Simbolik (Mudah) dan Cara Oktal (Profesional).

**Cara 1: Symbolic Mode (Manusiawi)**
Rumus: `[Siapa][Operator][Apa]`

  * **Siapa:** `u` (user), `g` (group), `o` (others), `a` (all).
  * **Operator:** `+` (tambah), `-` (hapus), `=` (set).
  * **Apa:** `r`, `w`, `x`.

*Contoh Kasus: Membuat script bisa dijalankan.*

```bash
chmod u+x script.sh
```

*Artinya:* "Untuk **U**ser, **+ambahkan izin eX**ecute pada file `script.sh`."

*Contoh Kasus: Melarang orang lain mengintip.*

```bash
chmod o-r rahasia.txt
```

*Artinya:* "Untuk **O**thers, \*\*-\*\*hapus izin **R**ead."

**Cara 2: Octal Mode (Angka/Matematis)**
Ini adalah standar industri karena lebih cepat diketik. Setiap izin punya nilai angka:

  * **Read (r) = 4**
  * **Write (w) = 2**
  * **Execute (x) = 1**
  * **Tidak ada (-) = 0**

Kita menjumlahkan angka ini untuk setiap blok.

*Contoh: Izin `rwx` (Full)*
4 (r) + 2 (w) + 1 (x) = **7**

*Contoh: Izin `r-x` (Baca & Jalan)*
4 (r) + 0 + 1 (x) = **5**

*Contoh: Izin `rw-` (Baca & Tulis)*
4 (r) + 2 (w) + 0 = **6**

**Kombinasi Umum (Wajib Hafal):**

  * **777:** Semua orang bebas melakukan apa saja (Bahaya\!).
      * `(4+2+1) (4+2+1) (4+2+1)`
  * **755:** Pemilik bebas, orang lain hanya baca/jalan (Standar Script/Program).
      * `u=7(rwx), g=5(r-x), o=5(r-x)`
      * Perintah: `chmod 755 script.sh`
  * **644:** Pemilik bisa edit, orang lain hanya baca (Standar Dokumen Teks).
      * `u=6(rw-), g=4(r--), o=4(r--)`
      * Perintah: `chmod 644 catatan.txt`
  * **600:** Sangat Rahasia (Hanya pemilik yang bisa lihat/edit).
      * Perintah: `chmod 600 password.txt`

#### C. Mengubah Pemilik: `chown` (Change Owner)

Hanya user `root` (administrator) yang biasanya bisa memberikan file ke orang lain secara paksa.

```bash
sudo chown budi:developers laporan.txt
```

**Sintaks:**

  * `sudo`: Membutuhkan izin admin.
  * `chown`: Perintah utama.
  * `budi`: User pemilik baru.
  * `:`: Pemisah.
  * `developers`: Group pemilik baru.
  * `laporan.txt`: File target.

-----

### 4\. Terminologi Esensial

1.  **Superuser (Root):** User spesial dengan UID 0. Dia mengabaikan semua aturan izin. Meskipun file di-set "Tidak boleh dibaca siapapun (000)", Root tetap bisa membacanya.
2.  **Octal Notation:** Sistem bilangan basis 8 (0-7) yang digunakan untuk merepresentasikan bit izin.
3.  **Execute Bit:** "Saklar" khusus pada file yang memberitahu Kernel: "File ini adalah program, tolong jalankan sebagai proses, jangan cuma dibaca teksnya."

-----

### 5\. Hubungan dengan Modul Lain

  * **Prasyarat:** Modul 1.1 & 1.2 (Anda memanipulasi file yang izinnya sedang Anda atur).
  * **Koneksi ke Depan:** **Fase 2 (Modul 2.1)**. Langkah pertama membuat script Bash adalah menulis baris kode, langkah keduanya **wajib** melakukan `chmod +x nama_script.sh`. Tanpa modul ini, Anda tidak bisa masuk ke Fase 2.

### 6\. Sumber Referensi Lengkap

  * **Kalkulator Izin Online:** [Chmod Calculator](https://chmod-calculator.com/) - Alat visual bagus untuk memahami hubungan angka dan simbol.
  * **Dokumentasi Resmi:** [GNU Coreutils - chmod](https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html).
  * **Artikel:** [Red Hat Sysadmin - Linux Permissions](https://www.redhat.com/sysadmin/linux-file-permissions-explained).

### 7\. Tips dan Praktik Terbaik

  * **Prinsip *Least Privilege*:** Berikan izin seminimal mungkin. Jangan gunakan `777` hanya karena "biar gampang". Jika file hanya perlu dibaca, beri `4` (read), jangan `7` (full).
  * **Recursive chmod:** Hati-hati menggunakan `chmod -R` (Recursive) pada folder sistem. Salah mengubah izin `/etc` bisa membuat komputer gagal booting.
  * **Gunakan Group:** Di lingkungan kerja tim (Enterprise), jangan beri akses ke *Everyone/Others*. Buatlah Group (misal: `dev-team`), masukkan user teman-teman Anda ke group itu, lalu beri izin `770` (User & Group full, Others ditolak).

### 8\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** "Permission Denied" saat mencoba menjalankan script `./script.sh`.
      * **Penyebab:** Lupa memberikan execute bit.
      * **Solusi:** Jalankan `chmod +x script.sh`.
  * **Kesalahan:** Menggunakan `777` untuk mengatasi masalah permission di web server.
      * **Bahaya:** Hacker bisa mengupload script jahat dan menjalankannya.
      * **Solusi:** Cari tahu user apa yang menjalankan web server (biasanya `www-data`), lalu lakukan `chown www-data` ke folder tersebut, alih-alih membuka izin ke seluruh dunia.

-----

Dengan selesainya **Modul 1.4**, kita telah menyelesaikan **Fase 1: The Foundation**.

1.  Kita tahu cara navigasi (`cd`, `ls`).
2.  Kita tahu cara manipulasi (`cp`, `mv`, `rm`).
3.  Kita tahu cara menulis (`nano`, `vim`).
4.  Kita tahu cara mengamankan (`chmod`, `chown`).

Sekarang, Anda memiliki lisensi penuh untuk mulai memprogram.

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../bagian-1/bagian-1/README.md
[2]: ../../../../../CLI_TUI/perintah/README.md
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
