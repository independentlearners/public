# Level 1 – Fondasi  
## Materi 1: Pengenalan Shell & POSIX

> **Catatan:** Sesuai permintaan, saya tidak akan membahas seluruh kurikulum sekaligus. Ini adalah **materi pertama**. Setelah Anda selesai membaca dan berlatih, kita akan lanjut ke **Materi 2: Terminal & Lingkungan**. Setiap perintah dan kode akan dijelaskan kata demi kata agar pemahaman Anda benar-benar matang.

---

## 🎯 Tujuan Materi 1

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menjelaskan apa itu shell dan perannya dalam sistem operasi Unix-like.
2. Memahami apa itu POSIX dan mengapa standar ini penting.
3. Membedakan shell `sh`, `bash`, `dash`, `ksh`, dan lainnya.
4. Mengetahui mengapa `#!/bin/sh` lebih portabel daripada `#!/bin/bash`.
5. Menjalankan perintah sederhana untuk mengidentifikasi shell yang sedang digunakan.
6. Menulis skrip POSIX pertama Anda dan memahami setiap barisnya.

---

## 1.1 Apa Itu Shell?

**Shell** adalah sebuah program yang bertindak sebagai **penerjemah** antara manusia dengan **kernel** sistem operasi. Kernel adalah inti sistem yang mengatur CPU, memori, disk, dan perangkat keras lainnya. Namun, kernel tidak bisa langsung dipahami oleh manusia. Di sinilah shell berperan.

Analogi sederhana:

- Anda ingin memesan makanan di restoran.
- Anda berbicara kepada **pelayan** (shell).
- Pelayan menyampaikan pesanan Anda ke **dapur** (kernel).
- Dapur memasak dan memberikan hasilnya kembali melalui pelayan.

Jadi, shell adalah **antarmuka baris perintah** (*command-line interface*) yang membaca perintah yang Anda ketikkan, menafsirkannya, lalu meminta kernel menjalankannya.

Shell bekerja dalam dua mode utama:

1. **Interaktif** – Anda mengetik perintah satu per satu di terminal, lalu shell langsung mengeksekusinya.
2. **Non-interaktif** – Shell membaca perintah dari sebuah file teks yang disebut **skrip shell**, lalu mengeksekusinya secara berurutan.

Materi kurikulum ini fokus pada mode **non-interaktif** dengan standar **POSIX**, karena tujuan kita adalah menulis skrip yang portabel dan dapat diandalkan.

---

## 1.2 Sejarah Singkat dan Jenis-Jenis Shell

Shell pertama yang populer adalah **Bourne shell** (`sh`), dibuat oleh Stephen Bourne di Bell Labs pada tahun 1977. Sejak itu, banyak shell turunan muncul:

| Shell | Path Umum | Keterangan |
|-------|-----------|------------|
| Bourne shell | `/bin/sh` | Shell asli Unix, menjadi acuan POSIX. |
| Bash | `/bin/bash` | Bourne Again Shell, fitur lebih banyak, default di banyak Linux. |
| Dash | `/bin/dash` | Implementasi POSIX yang ringan dan cepat, sering menjadi `/bin/sh` di Debian/Ubuntu. |
| Korn shell | `/bin/ksh` | Dikembangkan oleh David Korn, memiliki fitur scripting lanjutan. |
| Zsh | `/bin/zsh` | Fitur interaktif sangat kaya, populer di kalangan pengguna power. |
| C shell | `/bin/csh` | Sintaks mirip bahasa C, kurang populer untuk scripting POSIX. |

Meskipun banyak shell, **POSIX mendefinisikan standar** yang harus dipatuhi oleh shell apa pun yang mengklaim kompatibel. Jika Anda menulis skrip yang hanya menggunakan fitur POSIX, skrip tersebut dapat berjalan di `sh`, `dash`, `bash --posix`, `ksh`, dan sebagian besar shell lainnya.

---

## 1.3 Apa Itu POSIX?

**POSIX** adalah singkatan dari **Portable Operating System Interface**. Ini adalah serangkaian standar yang ditetapkan oleh **IEEE** (Institute of Electrical and Electronics Engineers) untuk menjaga kompatibilitas antar sistem operasi Unix-like.

Standar POSIX mencakup banyak hal: sistem file, thread, sinyal, dan tentu saja **Shell Command Language**. Bagian shell dari POSIX mendefinisikan:

- Sintaks perintah.
- Variabel dan ekspansi.
- Struktur kontrol (`if`, `for`, `while`, `case`).
- Fungsi.
- Redireksi dan pipeline.
- Utilitas baris perintah yang wajib ada (`echo`, `printf`, `test`, `grep`, `sed`, `awk`, dll.).

Dengan mengikuti POSIX, skrip Anda tidak akan bergantung pada satu sistem operasi atau satu shell tertentu. Skrip yang ditulis untuk POSIX dapat berjalan di Linux, macOS, BSD, Solaris, dan bahkan Windows melalui lingkungan seperti WSL atau Cygwin.

---

## 1.4 Mengapa `#!/bin/sh` dan Bukan `#!/bin/bash`?

Setiap skrip shell yang baik diawali dengan baris **shebang**:

```sh
#!/bin/sh
```

Mari kita bedah karakter demi karakter:

- `#` – Dalam shell, tanda pagar di awal baris biasanya menandakan komentar.
- `!` – Tanda seru.
- `#!` – Kombinasi ini disebut **shebang** atau **hash-bang**. Ini adalah instruksi khusus kepada kernel.
- `/bin/sh` – Path absolut ke interpreter yang harus menjalankan skrip.
- Tidak ada spasi di antara `#!` dan `/bin/sh`.

Ketika kernel melihat dua byte pertama file adalah `#!`, ia akan membaca sisa baris itu sebagai path interpreter. Kernel kemudian menjalankan interpreter tersebut dengan file skrip sebagai argumen.

Mengapa `/bin/sh` dan bukan `/bin/bash`?

- `/bin/sh` dijamin ada di semua sistem Unix-like.
- `/bin/bash` tidak selalu ada. Di beberapa sistem minimalis (misalnya Alpine Linux, BSD), bash tidak terpasang secara default.
- `/bin/sh` bisa berupa symlink ke `dash`, `bash`, `ksh`, atau shell lain. Dengan menulis skrip POSIX, Anda tidak peduli ke mana symlink itu menunjuk, karena semua shell tersebut mendukung POSIX.
- Jika Anda menulis `#!/bin/bash`, skrip Anda hanya berjalan di sistem yang memiliki bash, dan Anda cenderung menggunakan fitur bash yang tidak portabel.

**Prinsip emas:** Tulis skrip untuk `sh`, uji di `dash`, dan Anda akan mendapatkan portabilitas maksimal.

---

## 1.5 Contoh Kode dan Penjelasan Kata demi Kata

Sekarang kita masuk ke praktik. Saya akan memberikan beberapa perintah dan skrip sederhana, lalu menjelaskan setiap kata.

### Contoh 1: Mencetak teks

```sh
echo "Hello, POSIX!"
```

Penjelasan:

- `echo` – Ini adalah perintah shell. POSIX mendefinisikan `echo` sebagai utilitas yang mencetak argumennya ke **stdout** (standard output), diikuti oleh karakter newline (`\n`). `echo` bisa berupa built-in shell atau program eksternal, tetapi perilakunya diatur oleh standar.
- `"Hello, POSIX!"` – Ini adalah **argumen** untuk `echo`. Tanda kutip ganda (`"`) mengelilingi string. Fungsinya:
  - Mencegah **word splitting**: tanpa tanda kutip, shell akan memecah string berdasarkan spasi menjadi beberapa argumen. Dengan tanda kutip, seluruh string dianggap satu argumen.
  - Mencegah **globbing**: karakter seperti `*` atau `?` tidak akan diperluas menjadi nama file.
  - Tetap memungkinkan **ekspansi variabel** (`$var`) dan **command substitution** (`$(...)`) di dalamnya.
- `!` – Dalam tanda kutip ganda, tanda seru tidak melakukan history expansion. History expansion adalah fitur interaktif bash, bukan POSIX. Jadi aman digunakan.

Output:

```
Hello, POSIX!
```

### Contoh 2: Shebang

```sh
#!/bin/sh
```

Penjelasan:

- `#!` – Shebang. Harus berada di baris **pertama** file, tanpa spasi di depan.
- `/bin/sh` – Path absolut ke interpreter. Kernel akan menjalankan `/bin/sh` dan memberikan file skrip sebagai argumen pertama.
- Jika baris ini tidak ada, kernel tidak tahu harus menjalankan skrip dengan apa. Anda bisa menjalankannya dengan `sh namafile.sh`, tetapi shebang membuat skrip dapat dieksekusi langsung (`./namafile.sh`).

### Contoh 3: Melihat shell default

```sh
echo $SHELL
```

Penjelasan:

- `echo` – Seperti sebelumnya.
- `$SHELL` – Ini adalah **ekspansi parameter**. Tanda `$` diikuti nama variabel `SHELL`. Shell akan mengganti `$SHELL` dengan nilai variabel tersebut.
- Variabel `SHELL` biasanya di-set oleh sistem saat login. Isinya adalah path shell default pengguna, misalnya `/bin/bash` atau `/bin/zsh`.
- Perlu diingat: `$SHELL` **tidak selalu menunjukkan shell yang sedang menjalankan skrip**. Ini hanya shell login Anda.

Contoh output:

```
/bin/bash
```

### Contoh 4: Memeriksa file `/bin/sh`

```sh
ls -l /bin/sh
```

Penjelasan:

- `ls` – Perintah untuk menampilkan daftar isi direktori.
- `-l` – Opsi **long format**. Menampilkan informasi detail: izin, jumlah link, pemilik, grup, ukuran, tanggal, dan nama file.
- `/bin/sh` – Argumen yang menunjukkan file atau direktori yang ingin dilihat. Di sini kita melihat file `/bin/sh`.

Contoh output di Ubuntu:

```
lrwxrwxrwx 1 root root 4 Jan  1 00:00 /bin/sh -> dash
```

Artinya `/bin/sh` adalah symlink ke `dash`. Di sistem lain bisa jadi `bash` atau `ksh`.

### Contoh 5: Melihat shell yang sedang menjalankan perintah

```sh
ps -p $$ -o comm=
```

Penjelasan:

- `ps` – Perintah untuk menampilkan status proses.
- `-p` – Opsi untuk memilih proses berdasarkan **PID** (Process ID).
- `$$` – Variabel spesial shell. `$$` akan digantikan oleh **PID dari shell saat ini**. Jika Anda menjalankan perintah ini di terminal, `$$` adalah PID shell interaktif Anda. Jika di dalam skrip, `$$` adalah PID shell yang menjalankan skrip.
- `-o comm=` – Opsi format output. `comm` berarti nama perintah. Tanda `=` di akhir menghilangkan header. Jadi output hanya nama command.

Contoh output:

```
bash
```

atau

```
dash
```

### Contoh 6: Mengetahui path sebenarnya dari `/bin/sh` (tidak POSIX)

```sh
readlink -f /bin/sh
```

Penjelasan:

- `readlink` – Perintah untuk menampilkan target symbolic link.
- `-f` – Opsi untuk mengikuti semua symlink dan menampilkan path absolut.
- `/bin/sh` – File yang ingin diperiksa.

Perintah ini **tidak POSIX**, jadi jangan digunakan di dalam skrip portabel. Ini hanya alat investigasi untuk mengetahui shell apa yang sebenarnya menjadi `/bin/sh` di sistem Anda.

---

## 1.6 Skrip POSIX Pertama Anda

Sekarang mari kita tulis skrip pertama. Buat file bernama `hello.sh`:

```sh
#!/bin/sh
# Skrip pertama: menyapa pengguna
echo "Halo, dunia POSIX!"
```

Penjelasan baris demi baris:

1. `#!/bin/sh`
   - Baris shebang. Memberi tahu kernel untuk menjalankan skrip dengan `/bin/sh`.

2. `# Skrip pertama: menyapa pengguna`
   - Baris komentar. Dimulai dengan `#`. Shell akan mengabaikan seluruh baris ini.
   - Komentar berguna untuk dokumentasi. Di skrip profesional, komentar menjelaskan **mengapa** kode ditulis, bukan hanya **apa**.

3. `echo "Halo, dunia POSIX!"`
   - Perintah `echo` dengan satu argumen string.
   - Tanda kutip ganda memastikan string dianggap satu argumen.
   - Output: `Halo, dunia POSIX!`

Cara menjalankan:

1. Beri izin eksekusi:

   ```sh
   chmod +x hello.sh
   ```

   Penjelasan:
   - `chmod` – Change mode, mengubah izin file.
   - `+x` – Menambahkan izin **execute** (eksekusi).
   - `hello.sh` – Nama file.

2. Jalankan:

   ```sh
   ./hello.sh
   ```

   Penjelasan:
   - `./` – Menunjukkan bahwa file berada di direktori saat ini. Tanpa `./`, shell akan mencari `hello.sh` di dalam `PATH`, bukan di direktori saat ini.
   - `hello.sh` – Nama file yang akan dieksekusi.

Output:

```
Halo, dunia POSIX!
```

---

## 1.7 Latihan

Kerjakan latihan berikut untuk memperkuat pemahaman:

1. Jalankan `echo $SHELL`. Shell apa yang ditampilkan?
2. Jalankan `ls -l /bin/sh`. Apakah `/bin/sh` symlink? Ke mana?
3. Jalankan `ps -p $$ -o comm=`. Shell apa yang sedang Anda gunakan?
4. Buat skrip `identitas.sh` yang mencetak:
   - Nama shell default Anda (`$SHELL`).
   - PID shell yang menjalankan skrip (`$$`).
   - Nama file skrip (`$0`).
5. Jalankan skrip yang sama dengan `sh identitas.sh` dan `bash identitas.sh`. Apakah hasilnya berbeda? Mengapa?

---

## 1.8 Ringkasan Materi 1

- **Shell** adalah penerjemah perintah antara pengguna dan kernel.
- **POSIX** adalah standar portabilitas untuk sistem operasi Unix-like, termasuk bahasa skrip shell.
- `#!/bin/sh` adalah shebang yang membuat skrip portabel.
- `echo`, `ls`, `ps`, `chmod` adalah perintah dasar yang akan sering digunakan.
- `$SHELL`, `$$`, `$0` adalah variabel spesial yang penting.
- Menulis skrip POSIX berarti menghindari fitur spesifik shell tertentu dan menguji di `dash` atau `sh`.

---

## 📌 Selanjutnya

Materi 1 selesai. Anda sekarang memiliki fondasi tentang shell dan POSIX.  
Berikutnya adalah **Materi 2: Terminal & Lingkungan**, di mana kita akan membahas:

- Navigasi direktori (`ls`, `cd`, `pwd`, `man`).
- Environment variable (`PATH`, `HOME`, `PS1`).
- Bagaimana shell membaca konfigurasi.
- Latihan praktis yang lebih menantang.

## Materi 2: Terminal & Lingkungan

> **Catatan:** Ini adalah **materi kedua** dari kurikulum. Setelah selesai, kita akan lanjut ke **Materi 3: Skrip Pertama & Shebang** (meskipun shebang sudah disinggung di Materi 1, di Materi 3 kita akan bahas lebih dalam tentang eksekusi, PATH resolution, dan alur kernel). Setiap perintah dan kode dijelaskan kata demi kata.

---

## 🎯 Tujuan Materi 2

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menjelaskan perbedaan antara **terminal**, **shell**, **console**, dan **tty**.
2. Bernavigasi di sistem file dengan percaya diri: `ls`, `cd`, `pwd`, `man`.
3. Memahami struktur direktori Unix-like (`/`, `/etc`, `/usr`, `/var`, dll.).
4. Menguasai **environment variable** dan perbedaannya dengan **shell variable**.
5. Mengelola `PATH`, `HOME`, `PS1`, dan variabel penting lainnya.
6. Menjelaskan bagaimana shell membaca file konfigurasi saat startup (`.profile`, `.bashrc`, dll.).
7. Menulis skrip yang memanfaatkan environment variable secara aman.

---

## 2.1 Terminal, Shell, Console, dan Tty — Apa Bedanya?

Sebelum menyelam lebih dalam, kita perlu meluruskan empat istilah yang sering dianggap sama, padahal berbeda.

### Terminal

**Terminal** adalah perangkat atau program yang menyediakan **antarmuka input/output** ke pengguna. Dulu, terminal adalah perangkat keras fisik (mesin ketik + layar). Sekarang, terminal adalah program seperti **GNOME Terminal**, **iTerm2**, **Windows Terminal**, atau **xterm**.

Terminal tidak "mengerti" perintah. Ia hanya mengirimkan apa yang Anda ketik ke shell dan menampilkan apa yang shell kembalikan.

### Shell

**Shell** adalah program yang membaca perintah dari terminal, memprosesnya, dan menjalankannya. Contoh: `sh`, `bash`, `zsh`, `dash`.

Jadi, alur sederhananya:

```
Keyboard → Terminal → Shell → Kernel → Perangkat Keras
                    ↑
                    Hasil dikembalikan ke Terminal untuk ditampilkan
```

### Console

**Console** adalah terminal fisik yang terhubung langsung ke komputer (bukan melalui jaringan atau emulator). Di Linux, Anda bisa mengakses console dengan menekan `Ctrl + Alt + F1` hingga `F6`. Console biasanya menampilkan log kernel saat booting.

### Tty (Teletypewriter)

**tty** adalah singkatan dari *teletypewriter*, perangkat asli yang menjadi cikal bakal terminal. Di sistem Unix modern, `tty` merujuk pada **file device** di `/dev/tty*` yang merepresentasikan terminal.

Ketika Anda menjalankan perintah `tty`, Anda akan melihat path seperti `/dev/pts/0` (`pts` = pseudo-terminal slave). Ini adalah tty virtual yang digunakan oleh emulator terminal.

### Membuktikan dengan Perintah

```sh
tty
```

Penjelasan:

- `tty` – Perintah POSIX yang mencetak nama file terminal yang terhubung ke input standar.
- Jika Anda menjalankannya di terminal, output misalnya `/dev/pts/0`.
- Jika Anda menjalankannya di dalam skrip yang dijalankan dengan cron atau tanpa terminal, output biasanya `not a tty`.

```sh
who
```

Penjelasan:

- `who` – Menampilkan daftar pengguna yang sedang login dan tty yang mereka gunakan.
- Format output biasanya: `username tty waktu-login`.

```sh
w
```

Penjelasan:

- `w` – Mirip `who` tetapi lebih detail: menampilkan beban sistem, proses yang sedang dijalankan, dan uptime.
- Perintah ini **tidak POSIX**, jadi jangan gunakan di skrip portabel.

---

## 2.2 Struktur Direktori Unix

Sebelum belajar navigasi, Anda harus paham **struktur direktori** sistem Unix-like. Semuanya dimulai dari root `/`.

| Direktori | Keterangan |
|-----------|------------|
| `/` | Root. Titik awal semua path. |
| `/bin` | Binary penting untuk boot dan single-user mode (`ls`, `cp`, `mv`). |
| `/sbin` | Binary sistem untuk administrator (`ifconfig`, `reboot`). |
| `/etc` | File konfigurasi sistem (`/etc/passwd`, `/etc/hosts`). |
| `/home` | Direktori pengguna biasa (`/home/budi`). |
| `/root` | Direktori home untuk user root. |
| `/tmp` | File sementara. Dihapus saat reboot. |
| `/usr` | Program pengguna dan data baca-saja (`/usr/bin`, `/usr/lib`). |
| `/var` | Data variabel (`/var/log`, `/var/spool`). |
| `/dev` | File device (`/dev/tty`, `/dev/null`). |
| `/proc` | Sistem file virtual untuk info proses (Linux). |
| `/opt` | Aplikasi opsional pihak ketiga. |
| `/mnt`, `/media` | Titik mount untuk filesystem eksternal. |

**Penting:** Semua yang diawali `/` disebut **absolute path**. Semua yang tidak diawali `/` disebut **relative path**, yang relatif terhadap direktori saat ini.

---

## 2.3 Navigasi Dasar: `ls`, `cd`, `pwd`, `man`

### `pwd` – Print Working Directory

```sh
pwd
```

Penjelasan:

- `pwd` – Print Working Directory. Mencetak path absolut direktori saat ini.
- Tidak ada argumen. Perintah ini POSIX dan hampir selalu built-in.
- Contoh output: `/home/budi`.

### `cd` – Change Directory

```sh
cd /etc
```

Penjelasan:

- `cd` – Change Directory. Mengubah direktori kerja saat ini.
- `/etc` – Argumen berupa absolute path. Direktori tujuan.
- Setelah perintah ini, prompt Anda berubah menjadi direktori `/etc`.

```sh
cd ..
```

Penjelasan:

- `..` – Referensi khusus untuk **direktori induk**. Jika Anda berada di `/etc`, maka `..` berarti `/`.
- `cd ..` berarti naik satu level ke direktori induk.

```sh
cd ~
```

Penjelasan:

- `~` – Tilde. Ekspansi oleh shell menjadi nilai variabel `$HOME`.
- `cd ~` artinya kembali ke direktori home pengguna.

```sh
cd -
```

Penjelasan:

- `-` – Perintah `cd` menafsirkan tanda minus sebagai "direktori sebelumnya". Fitur ini POSIX.
- Berguna untuk bolak-balik antara dua direktori.

```sh
cd
```

Penjelasan:

- Tanpa argumen, `cd` langsung kembali ke `$HOME`. Ini sama dengan `cd ~`.
- Perilaku ini didefinisikan dalam POSIX.

### `ls` – List

```sh
ls
```

Penjelasan:

- `ls` – List. Menampilkan isi direktori saat ini secara alfabetis.
- Hanya menampilkan nama file dan direktori, tanpa detail.

```sh
ls -a
```

Penjelasan:

- `-a` – **All**. Menampilkan semua file, termasuk yang diawali titik (`.`) yang biasanya tersembunyi.
- File tersembunyi di Unix dimulai dengan `.`, seperti `.bashrc`, `.profile`, `.git`.

```sh
ls -l
```

Penjelasan:

- `-l` – **Long format**. Menampilkan detail: izin, jumlah link, pemilik, grup, ukuran, tanggal modifikasi, dan nama.
- Contoh output:
  ```
  -rw-r--r-- 1 budi users 1024 Jan  1 12:00 catatan.txt
  ```
- Mari bedah baris di atas:
  - `-` – Tipe file. `-` untuk file biasa, `d` untuk direktori, `l` untuk symlink.
  - `rw-r--r--` – Izin. Tiga kelompok: pemilik (`rw-`), grup (`r--`), lainnya (`r--`).
  - `1` – Jumlah hard link.
  - `budi` – Pemilik (owner).
  - `users` – Grup.
  - `1024` – Ukuran dalam byte.
  - `Jan 1 12:00` – Waktu modifikasi terakhir.
  - `catatan.txt` – Nama file.

```sh
ls -la
```

Penjelasan:

- Kombinasi `-l` dan `-a`. Menampilkan semua file dalam format panjang.

```sh
ls -d */
```

Penjelasan:

- `-d` – Menampilkan direktori itu sendiri, bukan isinya.
- `*/` – Pola glob. `*` cocok dengan apa pun, `/` memastikan hanya direktori (karena direktori diakhiri `/`).
- Berguna untuk melihat daftar subdirektori saja.

### `man` – Manual

```sh
man ls
```

Penjelasan:

- `man` – Manual. Menampilkan halaman manual untuk perintah.
- `ls` – Nama perintah yang ingin dilihat dokumentasinya.
- Navigasi dalam `man`:
  - `Space` – Halaman berikutnya.
  - `b` – Halaman sebelumnya.
  - `/kata` – Cari kata "kata".
  - `n` – Kemunculan berikutnya.
  - `q` – Keluar.

`man` adalah **sumber kebenaran** untuk perintah POSIX. Jika ragu, baca `man`.

```sh
man 1 ls
```

Penjelasan:

- Angka `1` adalah **section number** dalam manual. Section:
  - `1` – Perintah pengguna.
  - `2` – System call.
  - `3` – Library C.
  - `5` – Format file.
  - `7` – Konvensi dan misc.
  - `8` – Perintah admin.
- Jika Anda mengetik `man ls` dan sistem menemukan lebih dari satu hasil, `man` akan memilih section pertama yang tersedia.

---

## 2.4 Environment Variable vs Shell Variable

Ini adalah konsep **krusial** yang wajib dipahami untuk menulis skrip POSIX.

### Definisi

- **Shell variable**: variabel yang hanya ada di dalam shell saat ini. Tidak diwariskan ke proses anak.
- **Environment variable**: variabel yang diwariskan ke **semua proses anak** shell.

Analoginya:

- Shell variable = catatan pribadi Anda.
- Environment variable = informasi yang Anda bagikan ke semua bawahan Anda.

### Membuat Shell Variable

```sh
nama="Budi"
```

Penjelasan:

- `nama` – Nama variabel. Dalam POSIX, nama variabel harus diawali huruf atau underscore (`_`), dan hanya boleh berisi huruf, angka, underscore.
- `=` – Operator assignment. **Tidak boleh ada spasi** di sekitar `=`. Jika Anda menulis `nama = "Budi"`, shell akan menganggap `nama` sebagai perintah dan `= "Budi"` sebagai argumen, yang akan error.
- `"Budi"` – Nilai. Tanda kutip ganda melindungi dari word splitting.
- Variabel ini adalah **shell variable**. Tidak ada proses anak yang bisa melihatnya.

### Membaca Variabel

```sh
echo "$nama"
```

Penjelasan:

- `$nama` – Ekspansi parameter. Shell mengganti `$nama` dengan nilai variabel.
- Tanda kutip ganda **sangat disarankan** untuk mencegah word splitting dan globbing.
- Jika nilai `nama` mengandung spasi, misalnya `Budi Santoso`, tanpa kutip `echo $nama` akan menghasilkan dua argumen ke `echo`: `Budi` dan `Santoso`. Hasilnya tetap sama, tapi jika digunakan dalam konteks lain (misalnya sebagai nama file), bisa berbahaya.

### Membuat Environment Variable

```sh
export nama
```

Penjelasan:

- `export` – Perintah POSIX untuk menandai variabel sebagai environment variable.
- `nama` – Nama variabel yang akan diekspor.
- Setelah `export`, variabel `nama` akan diwariskan ke semua proses anak, termasuk skrip yang dijalankan dari shell ini.

Bisa juga digabung:

```sh
export nama="Budi"
```

Penjelasan:

- Sekaligus mendefinisikan dan mengekspor dalam satu baris.

### Melihat Environment Variable

```sh
env
```

Penjelasan:

- `env` – Menampilkan semua environment variable yang diwariskan ke proses saat ini.
- Output berupa baris `NAMA=nilai`, satu per baris.

```sh
printenv
```

Penjelasan:

- Sama seperti `env`, tetapi `printenv` bisa menerima nama variabel sebagai argumen:
  ```sh
  printenv PATH
  ```
- `printenv` **tidak POSIX**; `env` adalah pilihan yang lebih portabel.

### Mengapa Perbedaan Ini Penting?

Ketika Anda menjalankan skrip dari terminal:

```sh
#!/bin/sh
echo "$nama"
```

Jika `nama` di-export, skrip akan mencetak `Budi`. Jika tidak, skrip akan mencetak kosong, karena variabel tidak diwariskan.

Cara aman: selalu `export` variabel yang perlu diakses skrip anak.

### `set` untuk Melihat Semua Variabel

```sh
set
```

Penjelasan:

- `set` – Tanpa argumen, menampilkan **semua** variabel (shell dan environment) yang sedang didefinisikan.
- Output biasanya panjang. Berguna untuk debugging.
- `set` juga bisa digunakan untuk mengubah opsi shell, yang akan kita pelajari nanti.

---

## 2.5 Variabel Penting: `PATH`, `HOME`, `PS1`

### `PATH`

`PATH` adalah environment variable yang menentukan **di mana shell mencari program** ketika Anda mengetik perintah tanpa path absolut.

```sh
echo "$PATH"
```

Contoh output:

```
/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin
```

Penjelasan:

- Nilai `PATH` adalah daftar direktori, dipisahkan oleh **titik dua** (`:`).
- Ketika Anda mengetik `ls`, shell akan mencari file `ls` di:
  1. `/usr/local/bin/ls`
  2. `/usr/bin/ls`
  3. `/bin/ls`
  4. dst.
- Direktori pertama yang mengandung file bernama `ls` akan dieksekusi.

Mengapa ini penting untuk skrip?

Skrip POSIX yang baik **tidak mengandalkan `PATH`**. Jika Anda menulis `grep`, ada risiko `PATH` dimodifikasi oleh pengguna sehingga `grep` yang dijalankan bukan `grep` standar. Untuk skrip kritis, gunakan path absolut:

```sh
/usr/bin/grep
```

Tapi hati-hati: path absolut juga tidak selalu portabel (di FreeBSD, `grep` ada di `/usr/bin/grep`; di sistem lain bisa berbeda). Solusinya: pelajari lokasi standar untuk perintah yang Anda butuhkan, atau gunakan `command -v` untuk memverifikasi.

### `command -v` (POSIX)

```sh
command -v ls
```

Penjelasan:

- `command` – Perintah POSIX untuk menjalankan perintah lain atau memeriksa keberadaannya.
- `-v` – Opsi untuk menampilkan path ke perintah jika ditemukan.
- Output misalnya: `/bin/ls`.
- Jika perintah tidak ditemukan, output kosong dan exit status non-zero.

Alternatif non-POSIX: `which`. Jangan gunakan `which` di skrip portabel karena implementasinya berbeda-beda.

### `HOME`

```sh
echo "$HOME"
```

Penjelasan:

- `HOME` adalah path direktori home pengguna.
- Contoh: `/home/budi` atau `/root`.
- Shell `cd` tanpa argumen menggunakan `$HOME`.
- Banyak program membaca `HOME` untuk mencari file konfigurasi pengguna.
- **Selalu kutip** `$HOME` saat digunakan dalam skrip:
  ```sh
  cd "$HOME" || exit 1
  ```

### `PS1`

`PS1` adalah **Primary Prompt String** — string yang muncul sebagai prompt di shell interaktif.

```sh
echo "$PS1"
```

Penjelasan:

- Nilai default biasanya `\u@\h:\w\$ `:
  - `\u` – Username.
  - `\@` – Hostname.
  - `\h` – Hostname (singkat).
  - `\w` – Working directory.
  - `\$` – `$` atau `#` tergantung apakah pengguna root.
- `PS1` **tidak memiliki efek pada skrip non-interaktif**. Ini murni untuk kenyamanan interaktif.
- Di skrip POSIX, Anda tidak perlu mengutak-atik `PS1`.

Ada juga `PS2` (prompt lanjutan untuk baris kontinu) dan `PS4` (prompt tracing saat `set -x`).

---

## 2.6 File Konfigurasi Shell

Shell membaca beberapa file saat startup. Perilaku ini **berbeda antara shell login dan non-login**, dan **antara shell interaktif dan non-interaktif**. Untuk portabilitas maksimal, Anda harus tahu urutannya.

### Untuk `sh` / `dash` (POSIX)

Saat login:

1. `/etc/profile` – Konfigurasi global.
2. `$HOME/.profile` – Konfigurasi pengguna.

Urutan: `/etc/profile` dibaca dulu, kemudian `$HOME/.profile`.

Tidak ada file khusus untuk non-login interaktif. Jadi semua variabel harus didefinisikan di `.profile`.

### Untuk `bash`

Bash memiliki lebih banyak file:

- Login shell: `/etc/profile`, lalu `~/.bash_profile` (atau `~/.bash_login`, atau `~/.profile` — yang pertama ditemukan).
- Interaktif non-login: `/etc/bash.bashrc`, lalu `~/.bashrc`.

Inilah salah satu alasan menulis skrip POSIX lebih sederhana: Anda hanya perlu tahu `.profile`.

### `$HOME/.profile` – Contoh Sederhana

```sh
# ~/.profile
PATH="$HOME/bin:$PATH"
export PATH

EDITOR=vi
export EDITOR

umask 022
```

Penjelasan:

- `PATH="$HOME/bin:$PATH"` – Menambahkan `$HOME/bin` di **depan** `PATH`. Ini berarti perintah di `$HOME/bin` akan diprioritaskan.
- `export PATH` – Mengekspor `PATH` agar diwariskan ke proses anak.
- `EDITOR=vi` – Menetapkan editor default. Banyak program (seperti `crontab`, `git`) membaca `EDITOR`.
- `export EDITOR` – Mengekspor agar program tersebut bisa melihatnya.
- `umask 022` – Mengatur default permission untuk file baru. `022` berarti:
  - Pemilik: full akses (dikurangi 0).
  - Grup: read + execute (dikurangi 2 = write dihilangkan).
  - Lainnya: read + execute (dikurangi 2 = write dihilangkan).

### Membaca Kembali File Konfigurasi

Jika Anda mengubah `.profile` dan ingin menerapkannya di shell saat ini:

```sh
. "$HOME/.profile"
```

Penjelasan:

- `.` – Perintah POSIX untuk **source** file. Titik diikuti spasi dan path file.
- `"$HOME/.profile"` – File yang akan dibaca dan dieksekusi dalam shell saat ini.
- Berbeda dengan menjalankan skrip biasa, `.` menjalankan isi file **di shell saat ini**, sehingga variabel dan fungsi tetap ada setelah eksekusi.
- Alternatif non-POSIX: `source` (tersedia di bash, zsh, tetapi tidak POSIX).

---

## 2.7 Latihan

1. **Investigasi terminal:**
   - Jalankan `tty`, `who`, dan `echo $TERM`.
   - Apa perbedaan outputnya?

2. **Navigasi:**
   - Mulai dari `$HOME`. Gunakan `cd` untuk masuk ke `/etc`, lalu `cd -` untuk kembali. Apa yang terjadi?
   - Gunakan `ls -la` di `/etc` dan identifikasi 3 file konfigurasi penting.

3. **Environment variable:**
   - Buat variabel `MYVAR="hello"`.
   - Jalankan `echo "$MYVAR"` — berhasil.
   - Jalankan `sh -c 'echo "$MYVAR"'` — apa yang terjadi? Mengapa?
   - Ulangi dengan `export MYVAR`. Apa perbedaannya?

4. **PATH:**
   - Jalankan `command -v ls`, `command -v sh`, `command -v grep`.
   - Jalankan `echo "$PATH"` dan identifikasi tiap direktori.
   - Modifikasi `PATH` sementara: `PATH="$HOME/bin:$PATH"`. Cek hasilnya.

5. **Skrip `ceklingkungan.sh`:**
   - Cetak `$HOME`, `$PATH`, `$USER`, `$SHELL`.
   - Untuk setiap variabel, gunakan `"${VAR:-TIDAK ADA}"` untuk menangani kasus variabel kosong.
   - Jelaskan mengapa `"${VAR:-default}"` lebih aman daripada `$VAR`.

---

## 2.8 Ringkasan Materi 2

- **Terminal**, **shell**, **console**, dan **tty** adalah konsep berbeda yang saling terkait.
- Struktur direktori Unix dimulai dari `/` dan mengikuti standar FHS (Filesystem Hierarchy Standard).
- `pwd`, `cd`, `ls`, `man` adalah perintah navigasi dasar yang wajib dikuasai.
- **Shell variable** lokal, **environment variable** diwariskan ke proses anak via `export`.
- `PATH` menentukan pencarian program; **jangan** mengandalkannya di skrip portabel.
- `command -v` adalah cara POSIX untuk memeriksa keberadaan perintah.
- `HOME`, `PS1`, `EDITOR` adalah environment variable yang sering digunakan.
- File konfigurasi POSIX utama: `/etc/profile` dan `$HOME/.profile`.
- Gunakan `. file` untuk sourcing, bukan `source file` (non-POSIX).

---

## 📌 Selanjutnya

Materi 2 selesai. Anda sekarang menguasai lingkungan kerja shell secara mendalam.

Berikutnya adalah **Materi 3: Skrip Pertama & Shebang (Mendalam)**, di mana kita akan membahas:

- Alur eksekusi kernel saat menjalankan skrip.
- Mengapa `#!/bin/sh` dianggap magic number.
- Perbedaan `./skrip.sh`, `sh skrip.sh`, dan `. skrip.sh`.
- Path resolution dan PATH lookup.
- Latihan membuat skrip yang dapat dieksekusi langsung.

## Materi 3: Skrip Pertama & Shebang (Mendalam)

> **Catatan:** Ini adalah **materi ketiga**. Di Materi 1 kita sudah menyinggung shebang secara singkat. Sekarang kita akan membedahnya **sampai ke level kernel**. Setiap baris kode, setiap byte, setiap syscall yang terlibat akan dijelaskan. Setelah materi ini, Anda akan benar-benar memahami apa yang terjadi ketika Anda menekan Enter pada `./skrip.sh`.

---

## 🎯 Tujuan Materi 3

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menjelaskan apa yang terjadi **di level kernel** ketika skrip dieksekusi.
2. Memahami **magic number** `#!` dan mengapa disebut demikian.
3. Membedakan tiga cara eksekusi: `./skrip.sh`, `sh skrip.sh`, dan `. skrip.sh`.
4. Memahami **PATH resolution** dan mengapa `./` diperlukan.
5. Menulis skrip yang dapat dieksekusi langsung di berbagai sistem.
6. Memahami jebakan umum seputar shebang (spasi, CRLF, argumen interpreter).
7. Menguji skrip Anda di berbagai shell POSIX.

---

## 3.1 Apa Itu Skrip Shell?

**Skrip shell** adalah file teks berisi serangkaian perintah shell yang disimpan dalam sebuah file, lalu dieksekusi sebagai satu unit. Ini adalah bentuk pemrograman paling dasar di Unix.

Skrip shell memiliki tiga karakteristik:

1. **File teks biasa** – bukan binary. Dapat dibuka dengan editor apa pun.
2. **Berisi perintah shell** – sama seperti yang Anda ketik di terminal.
3. **Dapat dieksekusi** – dengan bantuan interpreter (shell).

Yang menjadikan file teks biasa menjadi "program" adalah **shebang** dan **izin eksekusi** (execute permission).

---

## 3.2 Shebang: Definisi dan Sejarah

**Shebang** adalah dua karakter pertama pada baris pertama file skrip:

```
#!
```

Kombinasi `#` dan `!` ini memiliki makna khusus di level kernel. Berbagai nama lain untuk shebang:

- **hash-bang** – karena `#` disebut hash dan `!` disebut bang.
- **pound-bang** – `#` juga disebut pound.
- **hash-pling** – `!` juga disebut pling.
- **sharp-bang** – `#` disebut sharp di Inggris.

### Sejarah Singkat

Shebang diperkenalkan di **Version 7 Unix** (1979) oleh Dennis Ritchie. Sebelumnya, untuk menjalankan skrip, Anda harus mengetik:

```sh
sh namafile
```

Dengan shebang, Anda dapat mengetik:

```sh
./namafile
```

dan kernel akan otomatis mengetahui interpreter yang tepat.

### Mengapa Disebut Magic Number?

Dalam dunia file, ada yang disebut **magic number** – beberapa byte pertama file yang mengidentifikasi tipe file. Contoh:

- File ELF (executable Linux) dimulai dengan `\x7fELF`.
- File PNG dimulai dengan `\x89PNG`.
- File ZIP dimulai dengan `PK`.
- File skrip dengan shebang dimulai dengan `#!`.

Kernel Linux dan Unix memiliki tabel magic number. Ketika Anda meminta kernel menjalankan file (`execve()`), kernel membaca beberapa byte pertama:

1. Jika diawali `#!`, kernel tahu ini adalah skrip dan membaca path interpreter dari baris pertama.
2. Jika diawali `\x7fELF`, kernel tahu ini adalah binary ELF dan menjalankannya langsung.
3. Jika tidak dikenali, kernel mengembalikan error `ENOEXEC`.

---

## 3.3 Apa yang Terjadi Ketika Anda Menjalankan `./skrip.sh`?

Mari kita bedah **alur eksekusi** secara mendetail. Anggaplah Anda memiliki skrip `skrip.sh` di direktori saat ini, dan Anda mengetik:

```sh
./skrip.sh
```

Berikut adalah langkah demi langkah apa yang terjadi:

### Langkah 1: Shell Membaca Input

Shell (misalnya `bash` atau `dash`) menerima input `./skrip.sh` dari terminal.

### Langkah 2: Shell Melakukan Word Splitting

Shell memecah input berdasarkan spasi, tab, dan newline (IFS). Hasilnya adalah satu kata: `./skrip.sh`.

### Langkah 3: Shell Mengidentifikasi Perintah

Karena kata pertama bukan **built-in** (seperti `cd`, `echo`, `export`), bukan **fungsi**, dan bukan **alias**, shell menganggapnya sebagai **perintah eksternal**.

### Langkah 4: PATH Lookup

Shell akan mencari `./skrip.sh` di setiap direktori dalam `$PATH`. Tapi tunggu — `./skrip.sh` berisi `/`. Jika perintah mengandung `/`, shell **langsung** menganggapnya sebagai path, tanpa mencari di `PATH`.

Inilah mengapa `./skrip.sh` berhasil tetapi `skrip.sh` gagal (kecuali `.` ada di `PATH`, yang berbahaya dan tidak disarankan).

- `./skrip.sh` – Path relatif eksplisit. Shell tahu ini mengacu pada file di direktori saat ini.
- `skrip.sh` – Shell akan mencari `skrip.sh` di setiap direktori di `$PATH`. Karena direktori saat ini biasanya tidak ada di `$PATH`, perintah akan gagal dengan `command not found`.

### Langkah 5: Shell Memanggil `execve()`

Shell memanggil **system call** `execve(path, argv, envp)`:

- `path` – `./skrip.sh`, yang akan di-resolve menjadi path absolut, misalnya `/home/budi/skrip.sh`.
- `argv` – Array argumen: `["./skrip.sh", NULL]`.
- `envp` – Array environment variable yang diwariskan.

### Langkah 6: Kernel Memeriksa Magic Number

Kernel menerima `execve()`. Kernel membuka file, membaca beberapa byte pertama. Kernel menemukan:

```
#!
```

Kernel mengenali ini sebagai skrip. Kernel membaca sisa baris pertama hingga newline:

```
#!/bin/sh
```

Kernel mengekstrak path interpreter: `/bin/sh`.

### Langkah 7: Kernel Menyiapkan Argumen Baru

Kernel menyusun ulang argumen untuk interpreter:

```
argv[0] = "/bin/sh"
argv[1] = "./skrip.sh"    (path skrip)
argv[2] = argumen tambahan (jika ada)
```

Perhatikan: kernel **menyisipkan** path skrip sebagai argumen pertama untuk interpreter.

### Langkah 8: Kernel Mengeksekusi Interpreter

Kernel menjalankan `/bin/sh` dengan argumen di atas. Interpreter `/bin/sh` kemudian:

1. Membuka file `./skrip.sh`.
2. Membaca isinya baris per baris.
3. Mengeksekusi setiap perintah.

### Langkah 9: Shebang Dilewati sebagai Komentar

Interpreter melihat baris pertama `#!/bin/sh`. Karena dimulai dengan `#`, interpreter menganggapnya sebagai **komentar** dan melewatinya. Ini adalah kebetulan yang elegan: shebang berfungsi sebagai instruksi kernel **dan** komentar shell secara bersamaan.

### Langkah 10: Eksekusi Selesai

Setelah semua perintah dieksekusi, interpreter keluar dengan exit status. Shell induk (yang memanggil `./skrip.sh`) menerima exit status ini di `$?`.

---

## 3.4 Tiga Cara Menjalankan Skrip — Perbedaannya

Ada tiga cara umum menjalankan skrip shell. Masing-masing memiliki implikasi berbeda.

### Cara 1: `./skrip.sh` (Langsung)

```sh
./skrip.sh
```

**Yang terjadi:**

- Shell memanggil `execve()`.
- Kernel membaca shebang.
- Kernel menjalankan interpreter yang ditunjuk shebang.
- Skrip dieksekusi di dalam **proses anak** (fork + exec).
- Perubahan variabel di dalam skrip **tidak** mempengaruhi shell induk.

**Syarat:**

- File harus memiliki izin eksekusi (`chmod +x`).
- Shebang harus ada di baris pertama.

### Cara 2: `sh skrip.sh` (Eksplisit)

```sh
sh skrip.sh
```

**Yang terjadi:**

- Shell memanggil `execve("/bin/sh", ["sh", "skrip.sh"], envp)`.
- Kernel menjalankan `/bin/sh` secara langsung. Tidak ada shebang yang dibaca.
- Interpreter `/bin/sh` membaca `skrip.sh` sebagai argumen pertamanya.
- Shebang di dalam skrip **diabaikan** (dianggap komentar biasa).

**Implikasi:**

- Izin eksekusi **tidak diperlukan**.
- Shebang di dalam skrip **diabaikan**. Jika skrip Anda memiliki `#!/bin/bash` tetapi Anda menjalankan `sh skrip.sh`, maka yang menjalankan adalah `/bin/sh`, bukan `/bin/bash`. Ini bisa menyebabkan error jika skrip menggunakan fitur bash.

### Cara 3: `. skrip.sh` (Sourcing)

```sh
. skrip.sh
```

**Yang terjadi:**

- Shell **tidak** memanggil `execve()`.
- Shell membaca isi `skrip.sh` dan mengeksekusinya **di dalam shell saat ini**.
- Tidak ada proses anak yang dibuat.
- Perubahan variabel, fungsi, dan direktori kerja **mempengaruhi shell saat ini**.

**Implikasi:**

- Izin eksekusi **tidak diperlukan**.
- Shebang diabaikan.
- Jika skrip berisi `exit`, shell Anda akan **keluar**. Ini berbahaya jika tidak disengaja.
- Berguna untuk memuat konfigurasi atau fungsi.

### Tabel Perbandingan

| Aspek | `./skrip.sh` | `sh skrip.sh` | `. skrip.sh` |
|-------|--------------|---------------|--------------|
| Fork proses baru | Ya | Ya | Tidak |
| Shebang dibaca | Ya | Tidak | Tidak |
| Perlu izin execute | Ya | Tidak | Tidak |
| Variabel mempengaruhi shell induk | Tidak | Tidak | Ya |
| `exit` di skrip menutup shell | Tidak | Tidak | Ya |
| Menggunakan interpreter dari shebang | Ya | Tidak (pakai `sh`) | Tidak (pakai shell saat ini) |

---

## 3.5 Membuat Skrip Pertama dengan Benar

Mari kita buat skrip dari nol, langkah demi langkah.

### Langkah 1: Buat File

Gunakan editor teks seperti `vi`, `nano`, atau `emacs`:

```sh
vi skrip_pertama.sh
```

### Langkah 2: Tulis Isi Skrip

```sh
#!/bin/sh
# Nama: skrip_pertama.sh
# Tujuan: Mencetak informasi dasar tentang lingkungan

echo "Halo, saya dijalankan oleh: $0"
echo "PID saya: $$"
echo "Direktori kerja: $(pwd)"
```

Mari bedah baris demi baris:

**Baris 1:** `#!/bin/sh`

- Shebang. Memberi tahu kernel untuk menggunakan `/bin/sh`.
- `/bin/sh` adalah path absolut. Wajib absolut. Jika Anda menulis `#!sh` (tanpa `/`), kernel akan mencari `sh` di direktori kerja saat ini, bukan di `PATH`. Ini kesalahan umum.

**Baris 2:** `# Nama: skrip_pertama.sh`

- Komentar. Dimulai dengan `#`. Diabaikan oleh shell.

**Baris 3:** `# Tujuan: Mencetak informasi dasar tentang lingkungan`

- Komentar lain. Mendokumentasikan tujuan skrip.
- Kebiasaan baik: selalu beri header di skrip Anda dengan nama, penulis, tanggal, dan deskripsi.

**Baris 4:** (kosong)

- Baris kosong diabaikan. Berguna untuk keterbacaan.

**Baris 5:** `echo "Halo, saya dijalankan oleh: $0"`

- `echo` – Mencetak argumen ke stdout.
- `"Halo, saya dijalankan oleh: $0"` – String dengan ekspansi variabel.
- `$0` – Variabel spesial. Berisi nama skrip **sebagaimana dipanggil**.
  - Jika dijalankan `./skrip_pertama.sh`, maka `$0` = `./skrip_pertama.sh`.
  - Jika dijalankan `/home/budi/skrip_pertama.sh`, maka `$0` = `/home/budi/skrip_pertama.sh`.
  - Jika dijalankan `sh skrip_pertama.sh`, maka `$0` = `skrip_pertama.sh`.

**Baris 6:** `echo "PID saya: $$"`

- `$$` – Variabel spesial. Berisi PID dari shell yang menjalankan skrip.
- Jika skrip dijalankan dengan `./skrip_pertama.sh`, `$$` adalah PID dari shell anak yang menjalankan skrip.
- Jika di-source dengan `. skrip_pertama.sh`, `$$` adalah PID shell interaktif Anda.

**Baris 7:** `echo "Direktori kerja: $(pwd)"`

- `$(pwd)` – **Command substitution**. Shell menjalankan `pwd`, menangkap outputnya, dan menggantikan `$(pwd)` dengan hasil tersebut.
- POSIX menggunakan `$(...)`. Backtick (`` `pwd` ``) juga POSIX tetapi lebih sulit dibaca dan memiliki masalah dengan nesting. **Selalu gunakan `$(...)`**.
- `pwd` – Mencetak direktori kerja saat ini.

### Langkah 3: Beri Izin Eksekusi

```sh
chmod +x skrip_pertama.sh
```

Penjelasan:

- `chmod` – Change mode.
- `+x` – Menambahkan izin eksekusi untuk **pemilik, grup, dan lainnya**? Tidak — `+x` tanpa spesifikasi siapa akan menambahkan execute untuk semua kategori yang memiliki hak baca. Sebenarnya `chmod +x` menerapkan `a+x` secara default (all).
- Untuk kontrol lebih baik, gunakan `chmod 755 skrip_pertama.sh`:
  - `7` – Pemilik: rwx (4+2+1).
  - `5` – Grup: r-x (4+1).
  - `5` – Lainnya: r-x (4+1).

Verifikasi dengan `ls -l skrip_pertama.sh`. Output harus menunjukkan `-rwxr-xr-x`.

### Langkah 4: Jalankan

```sh
./skrip_pertama.sh
```

Output:

```
Halo, saya dijalankan oleh: ./skrip_pertama.sh
PID saya: 12345
Direktori kerja: /home/budi
```

---

## 3.6 Jebakan Umum Seputar Shebang

### Jebakan 1: Spasi Setelah `#!`

```sh
#! /bin/sh
```

**Ini tidak portabel.** POSIX tidak mengizinkan spasi antara `#!` dan path. Linux modern mentoleransi ini, tetapi sistem lain mungkin tidak. **Selalu tulis `#!/bin/sh` tanpa spasi.**

### Jebakan 2: Path Interpreter dengan Spasi

```sh
#!/usr/local/my shell/sh
```

Kernel membaca sisa baris sebagai satu string, bukan sebagai daftar argumen yang di-split dengan benar. Beberapa kernel hanya memotong pada spasi pertama, sehingga interpreter menjadi `/usr/local/my`. **Jangan gunakan path interpreter dengan spasi.**

### Jebakan 3: Argumen ke Interpreter

```sh
#!/bin/sh -e
```

Di beberapa sistem, kernel tidak meneruskan `-e` sebagai argumen ke shell. Perilakunya tidak portabel. **Jangan mengandalkan argumen shebang.** Sebagai gantinya, gunakan `set -e` di dalam skrip.

### Jebakan 4: CRLF (Windows Line Ending)

Jika Anda mengedit skrip di Windows, editor mungkin menyisipkan `\r\n` (CRLF) alih-alih `\n` (LF). Kernel membaca baris pertama sebagai:

```
#!/bin/sh\r
```

Kernel akan mencari interpreter bernama `/bin/sh\r` yang tidak ada. Hasilnya: error `No such file or directory` yang membingungkan.

**Solusi:** Konversi dengan `dos2unix` atau perintah `tr -d '\r' < file > file.baru`.

Cara mendeteksi:

```sh
cat -A skrip.sh | head -1
```

Jika output menunjukkan `^M$` di akhir baris, ada CR.

### Jebakan 5: `#!/usr/bin/env sh`

Alternatif shebang:

```sh
#!/usr/bin/env sh
```

Penjelasan:

- `/usr/bin/env` – Program POSIX yang mencari perintah di `PATH`.
- `env sh` – Menjalankan `sh` dari `PATH`.
- Kelebihan: portabel jika `sh` tidak ada di `/bin/sh` (misalnya di NixOS, Termux).
- Kekurangan: `env` mungkin tidak ada di `/usr/bin/env` di beberapa sistem; dan jika `PATH` dimodifikasi oleh pengguna, `sh` yang ditemukan bisa bukan POSIX shell.

Untuk skrip POSIX, **`#!/bin/sh` adalah pilihan yang lebih disarankan** karena `sh` dijamin ada di `/bin/sh` di semua sistem Unix-like bersertifikasi POSIX.

---

## 3.7 Path Resolution dan Mengapa `./` Penting

Mari kita perdalam konsep **PATH lookup**.

### Bagaimana Shell Mencari Perintah

Ketika Anda mengetik `namaprogram` (tanpa `/`), shell melakukan:

1. Cek apakah `namaprogram` adalah **built-in** (seperti `cd`, `echo`, `exit`). Jika ya, jalankan.
2. Cek apakah `namaprogram` adalah **fungsi** yang didefinisikan di shell. Jika ya, jalankan.
3. Cek apakah `namaprogram` adalah **alias**. Jika ya, ganti dan ulangi.
4. Cari di setiap direktori dalam `$PATH`. Direktori dipisahkan `:`.
5. Jika ditemukan, jalankan file tersebut (via `execve`).
6. Jika tidak ditemukan, cetak `command not found` dan exit status 127.

### Mengapa `.` Tidak Ada di `PATH` Default?

Anda mungkin bertanya-tanya: mengapa shell tidak otomatis mencari di direktori saat ini? Jawabannya: **keamanan**.

Bayangkan Anda berada di direktori `/tmp` yang bisa ditulis oleh siapa saja. Penyerang meletakkan file bernama `ls` yang berisi kode berbahaya. Jika `.` ada di `PATH`, Anda mengetik `ls` dan tanpa sadar menjalankan kode berbahaya tersebut. Ini disebut **PATH injection attack**.

Karena itu, direktori saat ini **tidak** dimasukkan ke `PATH` secara default. Untuk menjalankan program di direktori saat ini, gunakan `./program`.

### Verifikasi

```sh
echo "$PATH"
```

Output tipikal:

```
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Anda bisa menambahkan `.` sementara (tidak disarankan):

```sh
PATH="$PATH:."
export PATH
```

**Jangan lakukan ini di skrip produksi.**

---

## 3.8 Skrip dengan Argumen

Skrip shell yang baik harus bisa menerima argumen. Mari kita lihat variabel spesial untuk argumen.

### Contoh Skrip

```sh
#!/bin/sh
# Nama: sapa.sh
# Tujuan: Menyapa pengguna dengan nama yang diberikan

if [ $# -eq 0 ]; then
    echo "Penggunaan: $0 nama"
    exit 1
fi

echo "Halo, $1!"
```

Bedah baris demi baris:

**`if [ $# -eq 0 ]; then`**

- `if` – Kata kunci untuk kondisional.
- `[` – Perintah `test`. Perhatikan spasi: `[` adalah perintah, jadi butuh spasi setelahnya.
- `$#` – Variabel spesial. Berisi **jumlah argumen** yang diberikan ke skrip.
- `-eq` – Operator numerik "equal". Untuk angka, gunakan `-eq`, bukan `=`.
- `0` – Angka pembanding.
- `]` – Penutup perintah `test`. Butuh spasi sebelum `]`.
- `;` – Pemisah perintah. Mengizinkan `then` ditulis di baris yang sama.
- `then` – Kata kunci yang mengawali blok `if`.
- Baris ini berarti: "Jika jumlah argumen sama dengan 0, maka..."

**`echo "Penggunaan: $0 nama"`**

- Mencetak pesan penggunaan.
- `$0` – Nama skrip.
- `nama` – Literal, menunjukkan bahwa argumen yang diharapkan adalah nama.

**`exit 1`**

- `exit` – Keluar dari skrip.
- `1` – Exit status. Non-zero berarti error. Skrip lain yang memanggil ini bisa memeriksa `$?`.
- Konvensi: `0` = sukses, `1`–`125` = berbagai error, `126` = tidak dapat dieksekusi, `127` = perintah tidak ditemukan, `128`+ = sinyal.

**`fi`**

- Penutup blok `if`. Kata `fi` adalah `if` terbalik. Ini adalah sintaks POSIX.

**`echo "Halo, $1!"`**

- `$1` – Variabel spesial. Berisi **argumen pertama**.
- Jika dijalankan `./sapa.sh Budi`, maka `$1` = `Budi`, dan output: `Halo, Budi!`.

### Variabel Argumen Spesial

| Variabel | Arti |
|----------|------|
| `$0` | Nama skrip. |
| `$1` – `$9` | Argumen posisi 1–9. |
| `${10}` | Argumen ke-10 (butuh kurung kurawal). |
| `$#` | Jumlah argumen. |
| `$@` | Semua argumen sebagai daftar terpisah. |
| `$*` | Semua argumen sebagai satu string. |
| `$?` | Exit status perintah terakhir. |
| `$$` | PID shell saat ini. |
| `$!` | PID proses latar belakang terakhir. |

Perbedaan `$@` dan `$*` akan dibahas detail di materi Level 2.

---

## 3.9 Menguji Portabilitas Skrip

Setelah menulis skrip, langkah penting adalah **menguji di berbagai shell**.

### Uji di `dash` (POSIX ketat)

```sh
dash skrip_pertama.sh
```

`dash` adalah shell POSIX minimalis. Jika skrip Anda berjalan di `dash`, kemungkinan besar portabel.

### Uji di `bash --posix`

```sh
bash --posix skrip_pertama.sh
```

Opsi `--posix` membuat `bash` berperilaku seperti POSIX `sh`.

### Uji dengan `sh`

```sh
sh skrip_pertama.sh
```

`/bin/sh` di sistem Anda mungkin symlink ke `dash`, `bash`, atau shell lain.

### Uji Syntax Tanpa Eksekusi

```sh
sh -n skrip_pertama.sh
```

- `-n` – **Noexec**. Membaca skrip dan memeriksa sintaks tanpa mengeksekusi.
- Berguna untuk memverifikasi sintaks sebelum menjalankan.

### Gunakan `shellcheck`

```sh
shellcheck -s sh skrip_pertama.sh
```

- `shellcheck` – Alat analisis statis.
- `-s sh` – Beri tahu bahwa target adalah POSIX `sh`.
- `shellcheck` akan menandai "bashism" dan potensi bug.

`shellcheck` bukan POSIX, tetapi sangat berguna untuk pengembangan.

---

## 3.10 Latihan

1. **Skrip dasar:**
   - Buat `info.sh` yang mencetak `$0`, `$$`, `$#`, `$@`, dan `$PWD`.
   - Jalankan dengan tiga cara: `./info.sh`, `sh info.sh`, dan `. info.sh`.
   - Bandingkan outputnya. Terutama `$$` dan `$0`.

2. **Shebang:**
   - Buat skrip dengan shebang `#!/bin/sh` dan jalankan.
   - Ubah shebang menjadi `#! /bin/sh` (dengan spasi). Apakah masih bekerja?
   - Ubah menjadi `#!/bin/sh -e`. Apakah `-e` diterapkan?

3. **PATH:**
   - Jalankan `skrip_pertama.sh` tanpa `./`. Apa yang terjadi?
   - Tambahkan direktori saat ini ke `PATH` sementara dan coba lagi.
   - Jelaskan mengapa ini berbahaya.

4. **CRLF:**
   - Buat file skrip dengan editor yang menghasilkan CRLF (misalnya Notepad).
   - Coba jalankan. Apa errornya?
   - Konversi dengan `tr -d '\r'` dan jalankan lagi.

5. **Argumen:**
   - Buat `jumlah.sh` yang menerima dua angka dan mencetak jumlahnya menggunakan `expr` atau `$(( ))`.
   - Uji dengan nol argumen, satu argumen, dan dua argumen.
   - Tangani kasus argumen kurang dengan pesan error dan `exit 1`.

6. **Sumber:**
   - Buat `fungsi.sh` yang mendefinisikan fungsi `sapa()`.
   - Coba panggil `sapa` dari shell setelah menjalankan `./fungsi.sh`. Apakah berhasil?
   - Coba panggil setelah `. ./fungsi.sh`. Apakah berhasil?
   - Jelaskan perbedaannya.

---

## 3.11 Ringkasan Materi 3

- **Shebang** (`#!`) adalah magic number yang memberi tahu kernel interpreter untuk skrip.
- Kernel membaca shebang saat `execve()`, mengekstrak path interpreter, dan menjalankannya dengan skrip sebagai argumen.
- Tiga cara menjalankan skrip: `./skrip.sh` (via shebang), `sh skrip.sh` (eksplisit), `. skrip.sh` (source).
- `./` diperlukan karena direktori saat ini tidak ada di `PATH` (alasan keamanan).
- Jebakan shebang: spasi, CRLF, argumen, path dengan spasi.
- Gunakan `#!/bin/sh` untuk portabilitas maksimal.
- Variabel argumen (`$0`, `$1`, `$#`, `$@`, `$?`, `$$`) adalah fondasi skrip yang dapat dikonfigurasi.
- Uji dengan `dash`, `bash --posix`, `sh -n`, dan `shellcheck`.

---

## 📌 Selanjutnya

Materi 3 selesai. Sekarang Anda benar-benar memahami apa yang terjadi "di balik layar" saat skrip dieksekusi.

Berikutnya adalah **Materi 4: Perintah Dasar yang Wajib Dikuasai** — bagian akhir dari Level 1. Kita akan membahas secara mendalam:

- Manipulasi file: `cp`, `mv`, `rm`, `mkdir`, `touch`.
- Melihat isi file: `cat`, `less`, `head`, `tail`.
- Pencarian: `grep`, `find`.
- Setiap opsi penting dari setiap perintah, dengan contoh praktis dan penjelasan kata demi kata.

## Materi 4: Perintah Dasar yang Wajib Dikuasai

> **Catatan:** Ini adalah **materi keempat** dan **terakhir** dari Level 1. Setelah ini, Anda akan naik ke Level 2 (Blok Bangunan). Setiap perintah akan dibedah kata demi kata, setiap opsi dijelaskan mengapa ada dan kapan digunakan, serta contoh praktis yang bisa langsung Anda coba.

---

## 🎯 Tujuan Materi 4

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memanipulasi file dan direktori dengan `cp`, `mv`, `rm`, `mkdir`, `touch`, `rmdir`, `ln`.
2. Melihat isi file dengan `cat`, `less`, `head`, `tail`, `wc`.
3. Mencari file dan konten dengan `grep` dan `find`.
4. Memahami opsi-opsi penting dan jebakan dari setiap perintah.
5. Menulis skrip yang memanfaatkan perintah-perintah ini secara portabel.
6. Menghindari kesalahan fatal seperti `rm -rf /` atau menimpa file tanpa sengaja.

---

## 4.1 Manipulasi File dan Direktori

### 4.1.1 `cp` – Copy

`cp` menyalin file atau direktori dari sumber ke tujuan.

**Sintaks dasar:**

```sh
cp [opsi] sumber tujuan
```

**Contoh 1: Menyalin file**

```sh
cp laporan.txt laporan_backup.txt
```

Penjelasan kata demi kata:

- `cp` – Perintah copy. POSIX mendefinisikannya sebagai utilitas untuk menyalin file.
- `laporan.txt` – **Sumber**. File yang akan disalin. Harus ada, jika tidak `cp` akan error.
- `laporan_backup.txt` – **Tujuan**. Nama file baru. Jika file ini sudah ada, isinya akan **ditimpa tanpa peringatan** (kecuali Anda menggunakan alias interaktif, yang tidak berlaku di skrip).

**Contoh 2: Menyalin ke direktori**

```sh
cp laporan.txt /tmp/
```

Penjelasan:

- `/tmp/` – Direktori tujuan. Perhatikan trailing slash `/`. Ini memberi tahu `cp` bahwa tujuan adalah direktori.
- Hasil: `/tmp/laporan.txt` dibuat.

Jika `/tmp/` tidak ada, `cp` akan menganggap `/tmp` sebagai nama file baru dan menyalin `laporan.txt` menjadi file bernama `/tmp`. Ini jebakan umum!

**Contoh 3: Menyalin banyak file ke direktori**

```sh
cp file1.txt file2.txt file3.txt /tmp/
```

Penjelasan:

- Argumen terakhir (`/tmp/`) harus berupa direktori.
- Semua file sebelumnya disalin ke dalamnya.

**Contoh 4: Menyalin direktori secara rekursif**

```sh
cp -R proyek/ proyek_backup/
```

Penjelasan:

- `-R` – **Recursive**. Menyalin direktori beserta seluruh isinya (subdirektori, file, symlink).
- POSIX menggunakan `-R` (huruf besar). GNU `cp` juga mendukung `-r` (huruf kecil), tetapi `-R` lebih portabel.
- `proyek/` – Direktori sumber. Trailing slash opsional; `cp -R proyek proyek_backup` juga bekerja.
- `proyek_backup/` – Direktori tujuan. Jika belum ada, `cp` akan membuatnya.

**Contoh 5: Mempertahankan atribut file**

```sh
cp -p laporan.txt laporan_backup.txt
```

Penjelasan:

- `-p` – **Preserve**. Mempertahankan:
  - Mode (izin file).
  - Kepemilikan (owner dan group) — hanya jika Anda punya izin.
  - Timestamp (waktu modifikasi dan akses).
- Berguna untuk backup yang ingin mempertahankan metadata.

**Contoh 6: Interaktif (bukan POSIX untuk skrip, tapi berguna)**

```sh
cp -i laporan.txt laporan_backup.txt
```

Penjelasan:

- `-i` – **Interactive**. Meminta konfirmasi sebelum menimpa.
- Opsi ini **tidak POSIX**. Jangan gunakan di skrip portabel. Ini hanya untuk penggunaan interaktif.

**Jebakan `cp`:**

- Menimpa file tanpa peringatan.
- Trailing slash yang hilang mengubah direktori menjadi file.
- `-R` pada symlink: POSIX `cp -R` mengikuti symlink secara default. GNU `cp -R` tidak. Gunakan `-P` (no-dereference) untuk perilaku yang konsisten jika perlu.

---

### 4.1.2 `mv` – Move

`mv` memindahkan atau mengganti nama file/direktori.

**Sintaks dasar:**

```sh
mv [opsi] sumber tujuan
```

**Contoh 1: Mengganti nama file**

```sh
mv laporan.txt laporan_final.txt
```

Penjelasan:

- `mv` – Move. Jika sumber dan tujuan berada di filesystem yang sama, operasi ini hanya mengganti nama (rename). Jika berbeda filesystem, `mv` akan menyalin lalu menghapus sumber.
- `laporan.txt` – Sumber.
- `laporan_final.txt` – Tujuan. Jika sudah ada, akan ditimpa.

**Contoh 2: Memindahkan file ke direktori**

```sh
mv laporan.txt /tmp/
```

Penjelasan:

- Memindahkan `laporan.txt` ke `/tmp/laporan.txt`.

**Contoh 3: Memindahkan direktori**

```sh
mv proyek/ /home/budi/arsip/
```

Penjelasan:

- Memindahkan seluruh direktori `proyek/` ke dalam `/home/budi/arsip/`.
- Hasil: `/home/budi/arsip/proyek/`.

**Contoh 4: Memindahkan banyak file**

```sh
mv file1.txt file2.txt file3.txt /tmp/
```

Penjelasan:

- Sama seperti `cp`, argumen terakhir harus direktori.

**Contoh 5: Interaktif**

```sh
mv -i laporan.txt /tmp/
```

Penjelasan:

- `-i` – Meminta konfirmasi sebelum menimpa. Tidak POSIX.

**Jebakan `mv`:**

- Menimpa file tanpa peringatan.
- `mv` tidak memiliki opsi `-R`; direktori dipindahkan secara implisit.
- Jika tujuan adalah file yang sudah ada dan sumber adalah direktori, `mv` akan error.

---

### 4.1.3 `rm` – Remove

`rm` menghapus file atau direktori. **Perintah ini tidak memiliki undo.** Sekali dihapus, hilang.

**Sintaks dasar:**

```sh
rm [opsi] file...
```

**Contoh 1: Menghapus file**

```sh
rm laporan.txt
```

Penjelasan:

- `rm` – Remove.
- `laporan.txt` – File yang akan dihapus.
- Jika file tidak ada, `rm` akan error dan exit status non-zero.

**Contoh 2: Menghapus banyak file**

```sh
rm file1.txt file2.txt file3.txt
```

**Contoh 3: Menghapus direktori kosong**

```sh
rmdir direktori_kosong/
```

Penjelasan:

- `rmdir` – Remove directory. Hanya berfungsi jika direktori **kosong**.
- Jika direktori berisi file, `rmdir` akan error.
- `rmdir` adalah perintah terpisah, bukan opsi `rm`.

**Contoh 4: Menghapus direktori beserta isinya**

```sh
rm -r proyek/
```

Penjelasan:

- `-r` – **Recursive**. Menghapus direktori dan seluruh isinya.
- POSIX mendukung `-r` dan `-R`. Keduanya sama.
- **Gunakan dengan sangat hati-hati.**

**Contoh 5: Menghapus tanpa konfirmasi (default di skrip)**

```sh
rm -f laporan.txt
```

Penjelasan:

- `-f` – **Force**. 
  - Tidak error jika file tidak ada.
  - Tidak meminta konfirmasi.
  - Menimpa izin read-only (jika Anda punya izin direktori).
- `-f` berguna di skrip untuk menghindari pesan error yang tidak perlu.

**Contoh 6: Kombinasi berbahaya**

```sh
rm -rf /
```

Penjelasan:

- `-r` – Rekursif.
- `-f` – Force.
- `/` – Root direktori.
- Perintah ini akan mencoba menghapus seluruh sistem. **Jangan pernah jalankan.**
- Di sistem modern, `rm` memiliki proteksi `--preserve-root` yang mencegah ini, tetapi tidak semua sistem.

**Praktik aman:**

- Gunakan `rm -i` saat berinteraksi manual.
- Di skrip, verifikasi variabel sebelum `rm`:
  ```sh
  if [ -n "$file" ]; then
      rm -f "$file"
  fi
  ```
  Penjelasan:
  - `-n "$file"` – Cek apakah string tidak kosong.
  - Jika `$file` kosong dan Anda menjalankan `rm -f "$file"`, Anda menjalankan `rm -f` tanpa argumen, yang error. Tapi jika tanpa `-f` dan `$file` kosong, Anda bisa menghapus semua file di direktori saat ini (`rm *`)? Tidak, `rm` tanpa argumen akan error. Namun, jika `$file` berisi `*`, shell akan mengekspansinya. Selalu kutip.

**Jebakan `rm`:**

- `rm -rf $dir/` – Jika `$dir` kosong, menjadi `rm -rf /`. **Selalu kutip dan verifikasi.**
- `rm` tidak memindahkan ke trash. Langsung hapus.
- Symlink: `rm symlink` menghapus symlink, bukan target.

---

### 4.1.4 `mkdir` – Make Directory

`mkdir` membuat direktori baru.

**Sintaks dasar:**

```sh
mkdir [opsi] direktori...
```

**Contoh 1: Membuat satu direktori**

```sh
mkdir proyek
```

Penjelasan:

- `mkdir` – Make directory.
- `proyek` – Nama direktori. Dibuat di direktori saat ini.
- Jika `proyek` sudah ada, `mkdir` akan error.

**Contoh 2: Membuat beberapa direktori**

```sh
mkdir src doc test
```

Penjelasan:

- Membuat tiga direktori sekaligus: `src`, `doc`, `test`.

**Contoh 3: Membuat direktori bersarang**

```sh
mkdir -p proyek/src/main
```

Penjelasan:

- `-p` – **Parents**. Membuat direktori induk jika belum ada.
- Tanpa `-p`, jika `proyek` atau `proyek/src` tidak ada, `mkdir` akan error.
- Dengan `-p`, semua direktori dalam path dibuat.
- `-p` juga tidak error jika direktori sudah ada.

**Contoh 4: Mengatur izin saat membuat**

```sh
mkdir -m 755 proyek
```

Penjelasan:

- `-m 755` – **Mode**. Mengatur izin direktori menjadi `rwxr-xr-x`.
- Tanpa `-m`, izin default adalah `777` dikurangi `umask`. Jika `umask` adalah `022`, hasilnya `755`.

**Jebakan `mkdir`:**

- Tanpa `-p`, error jika direktori sudah ada atau induk tidak ada.
- `-m` tidak mempengaruhi direktori induk yang dibuat dengan `-p`. Untuk itu, atur `umask` sebelum.

---

### 4.1.5 `touch` – Touch

`touch` memperbarui timestamp file, atau membuat file kosong jika belum ada.

**Sintaks dasar:**

```sh
touch [opsi] file...
```

**Contoh 1: Membuat file kosong**

```sh
touch catatan.txt
```

Penjelasan:

- `touch` – Jika `catatan.txt` tidak ada, buat file kosong.
- Jika sudah ada, perbarui waktu akses dan modifikasi ke waktu sekarang.
- `touch` **tidak** mengubah isi file.

**Contoh 2: Membuat banyak file**

```sh
touch file1.txt file2.txt file3.txt
```

**Contoh 3: Mengatur timestamp spesifik**

```sh
touch -t 202601011200 catatan.txt
```

Penjelasan:

- `-t` – **Time**. Format: `[[CC]YY]MMDDhhmm[.ss]`.
  - `CC` – Century (opsional).
  - `YY` – Year.
  - `MM` – Month (01–12).
  - `DD` – Day (01–31).
  - `hh` – Hour (00–23).
  - `mm` – Minute (00–59).
  - `.ss` – Second (opsional).
- Contoh di atas: 1 Januari 2026, 12:00.

**Contoh 4: Menggunakan timestamp file lain**

```sh
touch -r referensi.txt catatan.txt
```

Penjelasan:

- `-r` – **Reference**. Menggunakan timestamp dari `referensi.txt` untuk `catatan.txt`.
- Berguna untuk menyamakan timestamp.

**Jebakan `touch`:**

- `touch` tidak membuat direktori. Untuk itu, gunakan `mkdir`.
- `touch` pada file yang tidak dapat ditulis akan error (kecuali Anda pemilik atau root).

---

### 4.1.6 `ln` – Link

`ln` membuat hard link atau symbolic link.

**Sintaks dasar:**

```sh
ln [opsi] target linkname
```

**Contoh 1: Hard link**

```sh
ln laporan.txt laporan_hardlink.txt
```

Penjelasan:

- `ln` – Link.
- `laporan.txt` – Target (file asli).
- `laporan_hardlink.txt` – Nama link.
- Hard link berbagi inode yang sama dengan target. Menghapus salah satu tidak menghapus data selama masih ada link lain.
- Hard link **tidak bisa** melintasi filesystem.
- Hard link **tidak bisa** menunjuk ke direktori (kecuali oleh root, dan bahkan itu dibatasi).

**Contoh 2: Symbolic link**

```sh
ln -s /usr/local/bin/python3 python
```

Penjelasan:

- `-s` – **Symbolic**. Membuat symlink (soft link).
- `/usr/local/bin/python3` – Target. Bisa berupa path absolut atau relatif.
- `python` – Nama symlink.
- Symlink adalah file khusus yang berisi path ke target.
- Menghapus symlink tidak menghapus target.
- Symlink bisa melintasi filesystem.
- Symlink bisa menunjuk ke direktori.

**Contoh 3: Symlink dengan path relatif**

```sh
ln -s ../lib/utils.sh utils.sh
```

Penjelasan:

- Target relatif terhadap **lokasi symlink**, bukan direktori kerja saat ini.
- Jika symlink ada di `/home/budi/bin/utils.sh`, maka target menjadi `/home/budi/lib/utils.sh`.

**Jebakan `ln`:**

- Symlink yang rusak (target tidak ada) disebut **dangling symlink**.
- `ln -s` tanpa target yang ada tetap berhasil, tetapi symlink tidak berguna.
- Untuk menimpa symlink yang ada, gunakan `ln -sf`.
- `ln -sf` bisa berbahaya jika target adalah direktori: `ln -sf /some/dir existing_symlink` akan membuat symlink di dalam direktori jika `existing_symlink` adalah direktori.

---

## 4.2 Melihat Isi File

### 4.2.1 `cat` – Concatenate

`cat` menampilkan isi file ke stdout, atau menggabungkan beberapa file.

**Sintaks dasar:**

```sh
cat [opsi] [file...]
```

**Contoh 1: Menampilkan satu file**

```sh
cat laporan.txt
```

Penjelasan:

- `cat` – Concatenate.
- `laporan.txt` – File yang akan ditampilkan.
- Output: seluruh isi file ke stdout.

**Contoh 2: Menampilkan beberapa file**

```sh
cat file1.txt file2.txt
```

Penjelasan:

- Menampilkan isi `file1.txt` lalu `file2.txt` secara berurutan.
- Tidak ada pemisah otomatis antar file.

**Contoh 3: Menomori baris**

```sh
cat -n laporan.txt
```

Penjelasan:

- `-n` – **Number**. Menomori semua baris output.
- POSIX mendukung `-n`, tetapi juga `-b` (nomori hanya baris non-kosong).
- Berguna untuk melihat file dengan referensi baris.

**Contoh 4: Menampilkan karakter tak terlihat**

```sh
cat -v laporan.txt
```

Penjelasan:

- `-v` – **Visible**. Menampilkan karakter non-printing dalam bentuk `^X` atau `M-X`.
- Berguna untuk mendeteksi karakter kontrol atau CRLF.

**Contoh 5: Menggabungkan file**

```sh
cat bagian1.txt bagian2.txt > gabungan.txt
```

Penjelasan:

- `>` – Redirection. Mengarahkan stdout ke file `gabungan.txt`.
- Jika file sudah ada, isinya **ditimpa**.
- Hasil: `gabungan.txt` berisi isi `bagian1.txt` diikuti `bagian2.txt`.

**Jebakan `cat`:**

- `cat` untuk file besar bisa membanjiri terminal. Gunakan `less` untuk file besar.
- `cat file > file` akan **mengosongkan** file, karena shell membuka file untuk ditulis (truncate) sebelum `cat` membaca. Jangan lakukan ini.

---

### 4.2.2 `less` – Pager

`less` menampilkan file satu layar pada satu waktu, memungkinkan navigasi.

**Sintaks dasar:**

```sh
less [opsi] file
```

**Contoh:**

```sh
less /var/log/syslog
```

Penjelasan:

- `less` – Pager. Membuka file dalam mode interaktif.
- Navigasi:
  - `Space` atau `f` – Halaman berikutnya.
  - `b` – Halaman sebelumnya.
  - `/kata` – Cari kata.
  - `n` – Kemunculan berikutnya.
  - `N` – Kemunculan sebelumnya.
  - `g` – Awal file.
  - `G` – Akhir file.
  - `q` – Keluar.

`less` **bukan POSIX**. POSIX mendefinisikan `more`, tetapi `less` lebih fungsional dan hampir selalu tersedia. Untuk skrip, jangan gunakan `less` karena interaktif.

**Jebakan `less`:**

- Tidak cocok untuk skrip non-interaktif.
- Jika outputnya pendek, `less` mungkin tidak menampilkan apa-apa dan langsung keluar.

---

### 4.2.3 `head` – Head

`head` menampilkan beberapa baris pertama file.

**Sintaks dasar:**

```sh
head [-n jumlah] [file...]
```

**Contoh 1: Default 10 baris**

```sh
head laporan.txt
```

Penjelasan:

- Menampilkan 10 baris pertama.

**Contoh 2: Menentukan jumlah baris**

```sh
head -n 5 laporan.txt
```

Penjelasan:

- `-n 5` – Menampilkan 5 baris pertama.
- POSIX juga mendukung `-5` (tanpa `n`), tetapi `-n 5` lebih jelas.

**Contoh 3: Beberapa file**

```sh
head -n 3 file1.txt file2.txt
```

Penjelasan:

- Menampilkan 3 baris pertama dari masing-masing file.
- Output diawali header `==> file1.txt <==`.

**Jebakan `head`:**

- `head -n 0` menampilkan nol baris. Berguna untuk mengosongkan output.
- `head -n -5` (semua kecuali 5 baris terakhir) **tidak POSIX**. GNU `head` mendukung, tetapi jangan gunakan di skrip portabel.

---

### 4.2.4 `tail` – Tail

`tail` menampilkan beberapa baris terakhir file.

**Sintaks dasar:**

```sh
tail [-n jumlah] [file...]
```

**Contoh 1: Default 10 baris terakhir**

```sh
tail laporan.txt
```

**Contoh 2: Menentukan jumlah baris**

```sh
tail -n 20 laporan.txt
```

Penjelasan:

- Menampilkan 20 baris terakhir.

**Contoh 3: Memantau file secara real-time**

```sh
tail -f /var/log/syslog
```

Penjelasan:

- `-f` – **Follow**. Menampilkan baris baru saat ditambahkan ke file.
- Berguna untuk memantau log.
- `-f` **tidak POSIX**. POSIX mendefinisikan `tail -f`? Sebenarnya POSIX mendefinisikan `-f` untuk `tail`, tetapi perilakunya berbeda-beda. Gunakan dengan hati-hati di skrip portabel.

**Contoh 4: Mulai dari baris tertentu**

```sh
tail -n +5 laporan.txt
```

Penjelasan:

- `-n +5` – Mulai dari baris ke-5 hingga akhir.
- Tanda `+` berarti "mulai dari". Ini POSIX.

**Jebakan `tail`:**

- `tail -f` tidak berhenti sendiri. Gunakan `Ctrl+C`.
- Di skrip, `tail -f` harus dijalankan di latar belakang atau dengan timeout.

---

### 4.2.5 `wc` – Word Count

`wc` menghitung baris, kata, dan byte.

**Sintaks dasar:**

```sh
wc [-l] [-w] [-c] [file...]
```

**Contoh 1: Semua hitungan**

```sh
wc laporan.txt
```

Output:

```
  100  500 3000 laporan.txt
```

Penjelasan:

- `100` – Jumlah baris.
- `500` – Jumlah kata.
- `3000` – Jumlah byte.
- `laporan.txt` – Nama file.

**Contoh 2: Hanya baris**

```sh
wc -l laporan.txt
```

Penjelasan:

- `-l` – **Lines**. Hanya menghitung baris.

**Contoh 3: Hanya kata**

```sh
wc -w laporan.txt
```

Penjelasan:

- `-w` – **Words**. Menghitung kata, dipisahkan oleh whitespace.

**Contoh 4: Hanya byte**

```sh
wc -c laporan.txt
```

Penjelasan:

- `-c` – **Bytes**. Menghitung byte.

**Contoh 5: Dari stdin**

```sh
echo "Halo dunia" | wc -w
```

Penjelasan:

- `|` – Pipe. Mengirim output `echo` ke `wc`.
- `wc -w` membaca dari stdin.
- Output: `2` (dua kata: "Halo" dan "dunia").

**Jebakan `wc`:**

- `wc -l` menghitung newline, bukan baris. File yang tidak diakhiri newline akan dihitung kurang satu.
- `wc -c` menghitung byte, bukan karakter. Untuk UTF-8, gunakan `wc -m` (tetapi `-m` tidak POSIX).

---

## 4.3 Pencarian

### 4.3.1 `grep` – Global Regular Expression Print

`grep` mencari pola dalam file atau input.

**Sintaks dasar:**

```sh
grep [opsi] pola [file...]
```

**Contoh 1: Mencari kata dalam file**

```sh
grep "error" log.txt
```

Penjelasan:

- `grep` – Global Regular Expression Print.
- `"error"` – Pola yang dicari. Tanda kutip melindungi dari ekspansi shell.
- `log.txt` – File yang dicari.
- Output: semua baris yang mengandung "error".

**Contoh 2: Mencari di banyak file**

```sh
grep "error" *.log
```

Penjelasan:

- `*.log` – Glob. Shell mengekspansi menjadi daftar file `.log`.
- `grep` akan mencetak nama file di depan setiap baris yang cocok.

**Contoh 3: Abaikan huruf besar/kecil**

```sh
grep -i "error" log.txt
```

Penjelasan:

- `-i` – **Ignore case**. "error", "Error", "ERROR" semuanya cocok.

**Contoh 4: Menampilkan baris yang tidak cocok**

```sh
grep -v "error" log.txt
```

Penjelasan:

- `-v` – **Invert**. Menampilkan baris yang **tidak** mengandung pola.

**Contoh 5: Menampilkan nomor baris**

```sh
grep -n "error" log.txt
```

Penjelasan:

- `-n` – **Number**. Menampilkan nomor baris di depan setiap kecocokan.

**Contoh 6: Menghitung kecocokan**

```sh
grep -c "error" log.txt
```

Penjelasan:

- `-c` – **Count**. Menghitung jumlah baris yang cocok, bukan menampilkan barisnya.

**Contoh 7: Mencari secara rekursif**

```sh
grep -r "TODO" proyek/
```

Penjelasan:

- `-r` – **Recursive**. Mencari di semua file dalam direktori dan subdirektori.
- `-r` **tidak POSIX**. POSIX mendefinisikan `-R`? Tidak, keduanya tidak POSIX. Untuk portabilitas, gunakan `find` + `grep`.

**Contoh 8: Extended Regular Expression**

```sh
grep -E "error|warning" log.txt
```

Penjelasan:

- `-E` – **Extended**. Menggunakan ERE (Extended Regular Expression).
- `|` – Alternasi. Cocok dengan "error" atau "warning".
- Tanpa `-E`, Anda harus menggunakan `grep "error\|warning"` (dengan backslash) untuk BRE.

**Contoh 9: Hanya menampilkan bagian yang cocok**

```sh
grep -o "error[0-9]*" log.txt
```

Penjelasan:

- `-o` – **Only matching**. Menampilkan hanya bagian yang cocok, bukan seluruh baris.
- `[0-9]*` – Nol atau lebih digit.

**Contoh 10: Pencarian tepat seluruh kata**

```sh
grep -w "error" log.txt
```

Penjelasan:

- `-w` – **Word**. Cocok hanya jika pola adalah kata utuh.
- "error" cocok, "errors" tidak.

**Contoh 11: Dari stdin**

```sh
ps aux | grep "python"
```

Penjelasan:

- `ps aux` – Menampilkan semua proses.
- `| grep "python"` – Memfilter baris yang mengandung "python".

**Jebakan `grep`:**

- `grep` dengan pola yang diawali `-` akan dianggap opsi. Gunakan `--`:
  ```sh
  grep -- "-error" log.txt
  ```
- `grep` default adalah BRE (Basic Regular Expression), bukan ERE. Untuk ERE, gunakan `-E`.
- `grep` bisa lambat untuk file besar. Pertimbangkan `awk` atau `sed` untuk pemrosesan kompleks.

---

### 4.3.2 `find` – Find

`find` mencari file dan direktori berdasarkan berbagai kriteria.

**Sintaks dasar:**

```sh
find path... [ekspresi]
```

**Contoh 1: Mencari berdasarkan nama**

```sh
find /home/budi -name "*.txt"
```

Penjelasan:

- `find` – Perintah pencarian.
- `/home/budi` – Path awal pencarian. `find` akan menelusuri secara rekursif.
- `-name "*.txt"` – Predikat. Cocok dengan nama file yang berakhiran `.txt`.
- `*.txt` harus dikutip agar shell tidak mengekspansinya.

**Contoh 2: Mencari berdasarkan tipe**

```sh
find . -type f
```

Penjelasan:

- `.` – Direktori saat ini.
- `-type f` – Hanya file biasa.
- `-type d` – Hanya direktori.
- `-type l` – Hanya symlink.

**Contoh 3: Mencari berdasarkan ukuran**

```sh
find /var/log -size +10M
```

Penjelasan:

- `-size +10M` – File yang lebih besar dari 10 megabyte.
- `+` berarti lebih besar, `-` berarti lebih kecil, tanpa tanda berarti tepat.
- Satuan: `c` (byte), `k` (kilobyte), `M` (megabyte), `G` (gigabyte).

**Contoh 4: Mencari berdasarkan waktu**

```sh
find /home/budi -mtime -7
```

Penjelasan:

- `-mtime -7` – File yang dimodifikasi dalam 7 hari terakhir.
- `-mtime +30` – File yang dimodifikasi lebih dari 30 hari lalu.
- `-mmin -60` – File yang dimodifikasi dalam 60 menit terakhir.

**Contoh 5: Mencari dan mengeksekusi perintah**

```sh
find . -name "*.tmp" -exec rm {} \;
```

Penjelasan:

- `-exec` – Menjalankan perintah untuk setiap file yang ditemukan.
- `rm` – Perintah yang dijalankan.
- `{}` – Placeholder untuk nama file.
- `\;` – Penutup `-exec`. Backslash melindungi `;` dari shell.

Alternatif yang lebih efisien:

```sh
find . -name "*.tmp" -exec rm {} +
```

Penjelasan:

- `+` – Menggabungkan banyak file menjadi satu pemanggilan `rm`. Lebih cepat.
- `+` **tidak POSIX**? Sebenarnya POSIX mendukung `+` untuk `-exec`. Gunakan `+` jika memungkinkan.

**Contoh 6: Mencari dan menampilkan detail**

```sh
find /etc -name "*.conf" -ls
```

Penjelasan:

- `-ls` – Menampilkan detail seperti `ls -l`.

**Contoh 7: Menggabungkan predikat**

```sh
find . -type f -name "*.sh" -size +1k
```

Penjelasan:

- Beberapa predikat digabungkan dengan **AND** implisit.
- Hanya file yang memenuhi semua kriteria yang ditampilkan.

**Contoh 8: OR**

```sh
find . \( -name "*.txt" -o -name "*.md" \)
```

Penjelasan:

- `\(` dan `\)` – Pengelompokan. Harus di-escape agar tidak ditafsirkan shell.
- `-o` – **OR**.

**Contoh 9: NOT**

```sh
find . ! -name "*.txt"
```

Penjelasan:

- `!` – **NOT**. Menampilkan file yang bukan `.txt`.

**Contoh 10: Membatasi kedalaman**

```sh
find . -maxdepth 2 -name "*.sh"
```

Penjelasan:

- `-maxdepth 2` – Hanya menelusuri 2 level direktori.
- `-maxdepth` **tidak POSIX**. POSIX memiliki `-prune` untuk tujuan serupa.

**Jebakan `find`:**

- `find` menelusuri symlink secara default? Tidak, `find` tidak mengikuti symlink kecuali `-L`.
- `find` bisa sangat lambat di filesystem besar.
- `-exec ... \;` menjalankan perintah untuk setiap file, bisa lambat. Gunakan `+` jika bisa.
- Path dengan spasi: `find . -name "*.txt" -exec rm {} \;` aman karena `{}` digantikan dengan nama file yang di-quote oleh `find`. Namun, selalu berhati-hati.

---

## 4.4 Contoh Skrip Praktis

Mari kita gabungkan semua perintah dalam skrip nyata.

### Skrip 1: Backup File `.txt`

```sh
#!/bin/sh
# Nama: backup_txt.sh
# Tujuan: Menyalin semua file .txt dari direktori saat ini ke backup/

set -e

BACKUP_DIR="backup"

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Direktori $BACKUP_DIR dibuat."
fi

for file in *.txt; do
    if [ -f "$file" ]; then
        cp -p "$file" "$BACKUP_DIR/"
        echo "Disalin: $file"
    fi
done

echo "Backup selesai."
```

Bedah:

- `set -e` – Keluar jika ada perintah yang gagal. Akan dibahas di Level 4, tetapi berguna.
- `if [ ! -d "$BACKUP_DIR" ]` – Cek apakah direktori tidak ada.
- `for file in *.txt` – Loop glob. Jika tidak ada file `.txt`, `*.txt` akan tetap literal, dan `[ -f "$file" ]` akan gagal.
- `cp -p "$file" "$BACKUP_DIR/"` – Salin dengan mempertahankan atribut.

### Skrip 2: Pencarian Log

```sh
#!/bin/sh
# Nama: cari_error.sh
# Tujuan: Mencari baris error dalam log dan menghitungnya

LOG_DIR="/var/log"
POLA="error"

if [ ! -d "$LOG_DIR" ]; then
    echo "Direktori $LOG_DIR tidak ada." >&2
    exit 1
fi

jumlah=$(grep -r -i "$POLA" "$LOG_DIR" 2>/dev/null | wc -l)
echo "Ditemukan $jumlah baris mengandung '$POLA'."
```

Bedah:

- `>&2` – Redirection ke stderr. Pesan error harus ke stderr, bukan stdout.
- `$(...)` – Command substitution. Menjalankan pipeline dan menangkap output.
- `2>/dev/null` – Membuang pesan error dari `grep` (misalnya izin ditolak).
- `wc -l` – Menghitung baris.

### Skrip 3: Pembersihan File Sementara

```sh
#!/bin/sh
# Nama: bersihkan.sh
# Tujuan: Menghapus file .tmp yang lebih tua dari 7 hari

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR bukan direktori." >&2
    exit 1
fi

find "$TARGET_DIR" -type f -name "*.tmp" -mtime +7 -exec rm -f {} +

echo "Pembersihan selesai."
```

Bedah:

- `${1:-.}` – Ekspansi parameter dengan default. Jika `$1` kosong, gunakan `.`.
- `find ... -exec rm -f {} +` – Menghapus file yang ditemukan.
- `-mtime +7` – Lebih dari 7 hari.

---

## 4.5 Latihan

1. **Manipulasi file:**
   - Buat direktori `latihan/` dan masuk ke dalamnya.
   - Buat file `a.txt`, `b.txt`, `c.txt` dengan `touch`.
   - Salin semua ke `backup/` dengan `cp`.
   - Ganti nama `a.txt` menjadi `utama.txt` dengan `mv`.
   - Hapus `b.txt` dengan `rm`.
   - Hapus direktori `backup/` dengan `rm -r`.

2. **Melihat file:**
   - Buat file dengan 100 baris menggunakan `seq 100 > angka.txt`.
   - Tampilkan 5 baris pertama dengan `head`.
   - Tampilkan 5 baris terakhir dengan `tail`.
   - Hitung jumlah baris dengan `wc -l`.

3. **Pencarian:**
   - Buat file `data.txt` berisi beberapa baris dengan kata "apel", "jeruk", "mangga".
   - Cari "apel" dengan `grep`.
   - Cari dengan `grep -c` untuk menghitung.
   - Cari file `.txt` di direktori saat ini dengan `find`.

4. **Skrip:**
   - Tulis skrip `hitung.sh` yang menerima direktori sebagai argumen dan mencetak jumlah file `.txt` di dalamnya.
   - Tangani kasus argumen tidak diberikan.
   - Tangani kasus direktori tidak ada.

5. **Keamanan:**
   - Jelaskan mengapa `rm -rf $dir/` berbahaya.
   - Tulis versi aman yang memverifikasi `$dir` tidak kosong dan bukan `/`.

---

## 4.6 Ringkasan Materi 4

- `cp`, `mv`, `rm`, `mkdir`, `touch`, `ln` adalah perintah manipulasi file dasar.
- Selalu kutip variabel dan verifikasi sebelum operasi destruktif.
- `cat`, `head`, `tail`, `wc` untuk melihat isi file.
- `grep` untuk mencari pola teks; `-i`, `-v`, `-n`, `-c`, `-E` adalah opsi penting.
- `find` untuk mencari file berdasarkan nama, tipe, ukuran, waktu, dengan `-exec` untuk tindakan.
- Perhatikan portabilitas: hindari opsi non-POSIX di skrip.

---

## 🎉 Level 1 Selesai!

Anda telah menyelesaikan **Level 1 – Fondasi**. Anda sekarang memahami:

- Apa itu shell dan POSIX.
- Lingkungan terminal dan variabel.
- Shebang dan eksekusi skrip.
- Perintah dasar manipulasi file dan pencarian.

---

## 📌 Selanjutnya: Level 2 – Blok Bangunan

Di Level 2, kita akan masuk ke pemrograman shell yang sebenarnya:

- **Materi 1:** Variabel & Ekspansi Parameter (mendalam).
- **Materi 2:** Kondisional (`if`, `test`, `case`).
- **Materi 3:** Loop (`for`, `while`, `until`).
- **Materi 4:** Fungsi.

# Selamat!
## Anda telah menyelesaikan level 1

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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

