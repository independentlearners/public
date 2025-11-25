## Contoh output (baris pertama sebagai referensi)

##### Dalam sistem Unix/Linux:

| Karakter pertama | Arti file                                           |
| ---------------- | --------------------------------------------------- |
| `d`              | directory (folder)                                  |
| `-`              | regular file (file biasa)                           |
| `l`              | symbolic link (shortcut/alias file di Linux)        |
| `c`              | character device (device driver karakter, mis: tty) |
| `b`              | block device (disk, storage driver)                 |
| `p`              | named pipe (FIFO)                                   |
| `s`              | socket file                                         |

```
drwxr-xr-x  2 budi  staff   64 Nov 20 10:00 .
```

### Penjelasan **token per token** (urutan dari kiri ke kanan)

1. **`drwxr-xr-x` — permission string**

   * Karakter pertama: `d` → **tipe entri**, kadang `l` atau `-` kita akan membahasnya lebih dari hanya sekedar contoh diatas. Jadi jika karakter pertama adalah:

     * `d` = directory (direktori)
     * `-` = regular file (file biasa)
     * `l` = symbolic link, dll.
   * Sembilan karakter berikutnya terbagi tiga grup (masing-masing 3): `rwx` `r-x` `r-x`

     * Grup 1 (owner / pemilik): `rwx`

       * `r` = read (baca)
       * `w` = write (tulis/ubah)
       * `x` = execute (jalankan / untuk direktori = masuk/akses)
     * Grup 2 (group): `r-x` → baca + tidak tulis + execute
     * Grup 3 (others): `r-x` → baca + tidak tulis + execute
   * Nilai oktal (angka) dari `rwx r-x r-x` = `7 5 5` → **755** (sering dipakai dengan `chmod`).

2. **`2` — link count**

   * Jumlah link keras (hard links) ke entri tersebut. Untuk direktori, ini berkaitan dengan jumlah subdirektori (`.` dan `..` terhitung) — nilai kecil (2) menunjukkan direktori kosong selain dirinya sendiri.

3. **`budi` — owner (pemilik)**

   * Nama pengguna yang memiliki file/direktori.

4. **`staff` — group**

   * Grup unix yang mengelompokkan izin akses.

5. **`64` — ukuran (bytes)**

   * Ukuran objek dalam *bytes*. Untuk direktori ini nilai yang tampil adalah ukuran metadata direktori (bukan total isi). Untuk file, ini adalah ukuran file aktual.

6. **`Nov 20 10:00` — waktu modifikasi terakhir**

   * Format: `Bulan Tanggal Jam:Menit`. Jika file lebih tua dari ~6 bulan biasanya akan menampilkan tahun daripada jam.

7. **`.` — nama entri**

   * `.` = direktori saat ini (current directory). Pada listing `ls -la` Anda akan melihat `.` dan `..`.

---

## Penjelasan baris lain pada contoh (ringkas)

```
drwxr-xr-x  5 root  admin  160 Nov 19 09:00 ..
```

* `..` = parent directory (induk). Pemilik `root`, grup `admin`. Link count 5 → parent memiliki beberapa subdirektori.

```
-rw-r--r--  1 budi  staff  200 Nov 20 10:01 .bashrc  <-- File tersembunyi
```

* `-` = file biasa. Permission `rw- r-- r--` → owner `r/w`, group `r`, others `r`. Oktal = `644`. Link count 1 (biasa untuk file). Nama diawali titik → **hidden file** (file tersembunyi di Unix). `.bashrc` umumnya berisi konfigurasi shell milik user.

```
-rw-r--r--  1 budi  staff  500 Nov 20 12:00 notes.txt
```

* File biasa bernama `notes.txt`, ukuran 500 bytes, dimodifikasi 20 Nov 12:00.

---

## Perintah terkait (cara memeriksa / mengubah) — lengkap dengan arti setiap argumen/sintaks

1. **Melihat listing yang sama (termasuk file tersembunyi)**

   * `ls -la`

     * `ls` : list directory contents
     * `-l` : long format (tampilkan kolom detail seperti permissions, owner, size, waktu)
     * `-a` : all — tampilkan semua, termasuk file yang diawali `.` (hidden)

2. **Tampilkan ukuran human-readable**

   * `ls -lh`

     * `-h` : human readable (mis. `1.5K`, `2M`)

3. **Informasi lengkap tentang satu file**

   * `stat .bashrc`

     * `stat` : menampilkan metadata file (permissions numeric, waktu akses/modifikasi, inode, dsb.)

4. **Membaca isi file**

   * `cat .bashrc` — tampilkan seluruh isi ke stdout
   * `less .bashrc` — paging interaktif (naik/turun)
   * `nano .bashrc` atau `vim .bashrc` — edit (tergantung editor)

5. **Mengubah permission (contoh)**

   * `chmod 755 nama_file`

     * `chmod` : change mode (ubah permission)
     * `755` : owner=7(rwx), group=5(r-x), others=5(r-x)
   * Contoh simbolik: `chmod u+x script.sh`

     * `u` = user/owner, `g` = group, `o` = others, `a` = all
     * `+` = tambahkan permission, `-` = hapus, `=` = set persis
     * `x` = execute

6. **Mengubah pemilik / grup**

   * `chown pengguna:grup nama_file`

     * `chown` : change owner
     * contoh: `sudo chown budi:staff notes.txt` — set owner budi dan group staff
     * `sudo` diperlukan jika Anda bukan pemilik atau butuh hak root

7. **Melihat hak akses dalam representasi numerik dan simbolik**

   * `ls -l` → sudah menunjukkan simbolik
   * `stat -c "%A %a %n" nama_file`

     * `%A` = permission simbolik, `%a` = permission oktal, `%n` = nama file

---

## Catatan keamanan & praktik

* File seperti **`.bashrc`** berisi skrip/alias/env vars — jangan membagikannya jika ada kredensial.
* Konfigurasi permission `644` untuk file konfigurasi user (rw- untuk owner, r-- untuk lainnya) adalah umum; `600` (only owner read/write) lebih aman jika file berisi data sensitif.

---

## Ringkasan singkat — arti cepat tiap baris pada contoh 

* Baris 1 (`.`) : direktori saat ini, dimiliki `budi:staff`, permission `rwxr-xr-x` (755).
* Baris 2 (`..`): parent directory, dimiliki `root:admin`.
* Baris 3 (`.bashrc`): file tersembunyi milik `budi`, permission `rw-r--r--` (644), ukuran 200 bytes.
* Baris 4 (`notes.txt`): file biasa milik `budi`, ukuran 500 bytes, permission `rw-r--r--` (644).

---

Berikut **tabel referensi lengkap** yang lebih luas untuk mengartikan output `ls -l` pada sistem Unix/Linux. Ini menyertakan juga penjelasan pelengkap (kolom `ls -l`, arti angka link, perilaku ukuran untuk device, special bits seperti `s/t`, indikator `+`/`.`/`@`, contoh perintah pembuatan/inspeksi, serta sumber referensi resmi). 

> Sumber utama implementasi `ls` & tipe file: GNU coreutils / `ls` manual dan manual Linux — saya gunakan dokumentasi resmi dan referensi komunitas untuk bagian aturan khusus (special bits, ACL, extended attributes). ([gnu.org][a])

---

# Tabel: Karakter pertama pada `ls -l` dan artinya (referensi lengkap)

|                            Karakter | Nama singkat                      | Arti lengkap                                                                                              | Contoh `ls -l` (format)                                       | Cara/alat membuat / kapan muncul                                          | Catatan penting                                                                                                        |
| ----------------------------------: | --------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
|                                 `-` | regular file                      | File biasa (data, teks, biner).                                                                           | `-rw-r--r-- 1 user group 1234 Nov 20 10:00 file.txt`          | `touch file.txt`, program menulis file                                    | Link count = jumlah hard link; `size` kolom = byte file.                                                               |
|                                 `d` | directory                         | Direktori (folder).                                                                                       | `drwxr-xr-x 2 user group  64 Nov 20 10:00 somedir`            | `mkdir somedir`                                                           | Untuk direktori, `size` menunjukkan ukuran metadata direktori (bukan total isi). Link count = `2 + number_of_subdirs`. |
|                                 `l` | symbolic link (symlink)           | Link simbolik menunjuk ke target; `ls -l` menampilkan `-> target`.                                        | `lrwxrwxrwx 1 user group   9 Nov 20 10:00 link -> target.txt` | `ln -s target.txt link`                                                   | `l` selalu tampilkan `-> target`. Symlink dapat menunjuk ke non-existent target (dangling).                            |
|                                 `c` | character special file            | Character device (karakter device node), mis. terminal (`/dev/tty`), serial port.                         | `crw-rw-rw- 1 root root 4, 1 Nov 20 10:00 /dev/tty1`          | Dibuat oleh kernel atau `mknod` (root) saat device tersedia.              | Pada kolom `size` muncul `major, minor` (mis. `4, 1`) bukan ukuran bytes. Membutuhkan hak root untuk `mknod`.          |
|                                 `b` | block special file                | Block device (block device node), mis. disk (`/dev/sda`).                                                 | `brw-rw---- 1 root disk 8, 0 Nov 20 10:00 /dev/sda`           | Dibuat oleh kernel/udev atau `mknod` (root).                              | Kolom `size` menampilkan `major, minor`.                                                                               |
|                                 `p` | named pipe / FIFO                 | FIFO yang dibuat aplikasi untuk komunikasi antar-proses.                                                  | `prw-r--r-- 1 user group    0 Nov 20 10:00 myfifo`            | `mkfifo myfifo`                                                           | FIFO tidak punya `size` meaningful; digunakan untuk streaming data antar-proses.                                       |
|                                 `s` | socket (UNIX domain socket)       | Unix-domain socket file (IPC lokal).                                                                      | `srwxr-xr-x 1 user group    0 Nov 20 10:00 my.sock`           | Dibuat oleh aplikasi (contoh: `nc -U`, server aplikasi, atau API socket). | Biasa muncul di `/tmp` atau direktori aplikasi. Tidak sama dengan network socket TCP.                                  |
| `D` / `C` (opsional di beberapa ls) | device / high-performance special | Varian/ekstensi pada beberapa distribusi (`C` dipakai di GNU coreutils sebagai "high-performance device") | tergantung implementasi `ls`                                  | distro/versi `coreutils`                                                  | Jarang dipakai; lihat manual `ls` lokal. ([gnu.org][a])                                                                |

---

# Penjelasan kolom `ls -l` (urutan dan arti singkat)

Format tipikal:

```
drwxr-xr-x  2 owner group  4096 Nov 20 10:00 filename
^perm^   ^nlink^ ^owner^ ^group^ ^size/major,minor^ ^mtime^ ^name^
```

* **permission string (10 chars)**: posisi 1 = tipe (lihat tabel di atas). Posisi 2–10 = tiga grup `rwx` untuk `owner` / `group` / `others`.
* **nlink (link count)**: jumlah hard link. Untuk direktori: `2 + number_of_subdirectories` (karena `.` dan `..`). Untuk file: jumlah hard links.
* **owner / group**: pemilik unix user dan grup.
* **size**: untuk file = bytes; untuk device = `major, minor`; untuk direktori = metadata size yang tergantung FS.
* **mtime**: waktu modifikasi terakhir (format berubah jika lebih dari ~6 bulan).
* **name**: nama file; untuk symlink akan tampil `-> target`.

(Sumber: `ls` manual / coreutils). ([man7.org][b])

---

# Special bits pada field permission (karakter `s`, `S`, `t`, `T`) — arti & contoh

| Notasi pada permission                |                                                                                                   Arti | Cara set                                   | Contoh `ls -l`                                                                  |
| ------------------------------------- | -----------------------------------------------------------------------------------------------------: | ------------------------------------------ | ------------------------------------------------------------------------------- |
| `s` pada posisi execute owner (`rws`) |                                            **setuid**; program akan dijalankan dengan UID pemilik file | `chmod u+s program` (`chmod 4755 program`) | `-rwsr-xr-x 1 root root  12345 Nov 20 10:00 passwd` (passwd berjalan EUID=root) |
| `S` (huruf kapital)                   |                  setuid **terpasang** tetapi bit `x` owner **tidak** terpasang (tidak biasa untuk exe) | sama                                       | `-rwSr--r--`                                                                    |
| `s` pada group execute (`r-s`)        |       **setgid**; file dijalankan dengan GID file; untuk direktori: file baru mewarisi group direktori | `chmod g+s dir` (`chmod 2775 dir`)         | `drwxr-sr-x 2 user dev 4096 Nov 20 10:00 shared`                                |
| `t` pada others execute (`rwt`)       | **sticky bit** pada direktori: hanya owner atau root boleh menghapus/rename file di direktori tersebut | `chmod +t /tmp` (`chmod 1777 /tmp`)        | `drwxrwxrwt 14 root root 4096 Nov 20 10:00 /tmp`                                |
| `T` (kapital)                         |                                             sticky bit terpasang tetapi `x` others **tidak** terpasang | sama                                       | `drw-rw-r-T`                                                                    |

Angka oktal untuk special bits: setuid = `4000`, setgid = `2000`, sticky = `1000`. Jadi `chmod 4755` = setuid + `rwxr-xr-x`. ([redhat.com][c])

---

# Indikator tambahan yang muncul bersebelahan dengan permission string

* **`+`** di akhir string permissions (mis. `drwxr-xr-x+`) → ada **Access Control List (ACL)** tambahan (non-standard POSIX ACL). Periksa dengan `getfacl` / `setfacl`. ([Linux Audit][d])
* **`.`** (GNU ls) → menandakan **security context** (mis. SELinux context) tetapi tidak berarti ACL; lihat `id -Z`. ([Unix & Linux Stack Exchange][e])
* **`@`** (macOS / BSD `ls`) → file memiliki **extended attributes** (xattr). Gunakan `xattr -l filename` untuk lihat. ([Apple Support Communities][f])

---

# Contoh pembuatan & pemeriksaan (perintah + arti tiap argumen singkat)

1. Buat file biasa

   * `touch notes.txt`

     * `touch`: buat file kosong atau update timestamp.

2. Buat direktori

   * `mkdir mydir`

     * `mkdir`: make directory.

3. Buat symlink

   * `ln -s target.txt linkname`

     * `ln`: link; `-s` = symbolic.

4. Buat FIFO (named pipe)

   * `mkfifo mypipe`

     * `mkfifo`: create FIFO.

5. Buat socket UNIX (contoh cepat)

   * Python: `python3 -c "import socket, os; s=socket.socket(socket.AF_UNIX); s.bind('/tmp/mysock'); s.listen(1); input()"`

     * Program membuat file socket `/tmp/mysock` sampai proses berakhir.

6. Buat device node (root)

   * `sudo mknod /tmp/mydev c 1 7`

     * `mknod` membuat device; `c` = character, `1 7` = major, minor (ROOT required).

7. Lihat ACL / xattr / security context

   * `getfacl filename` — tampilkan ACL.
   * `getfattr -d filename` / `xattr -l filename` — extended attributes.
   * `stat filename` — metadata lengkap (mode, inode, times, dsb.).
   * `file filename` — tebak tipe isi (text/binary).
   * `ss -x` atau `ss -l` — lihat socket (network / unix-domain).
     (Sumber: `ls` manpage & utilitas Linux). ([man7.org][b])

---

# Cara mengubah permission & owner (contoh dan arti argumen)

* `chmod 755 file` — set `rwxr-xr-x`. (Angka: owner=7 (rwx), group=5 (r-x), others=5 (r-x)).
* `chmod u+x script.sh` — tambahkan execute untuk owner. (`u`=user/owner)
* `chmod g+s dir` — setgid pada direktori.
* `chmod 1777 /tmp` — oktal `1` = sticky bit + `777` untuk semua akses.
* `chown budi:staff notes.txt` — ubah owner & group (`chown owner:group file`). (`sudo` mungkin diperlukan). ([man7.org][b])

---

# Penjelasan ringkas link count (nlink)

* **File biasa**: nlink = jumlah *hard links* ke inode yang sama. `ln file linkfile` meningkatkan nlink. Hapus file tidak menghapus data sampai nlink menjadi 0 dan tidak ada proses yang membuka file.
* **Direktori**: nlink = `2 + number_of_subdirectories` (2 untuk `.` dan `..` setiap direktori) — jadi direktori yang punya 0 subdir umumnya punya nlink=2. (Referensi implementasi filesystem / manpages). ([man7.org][b])

---

# Identitas teknologi & persyaratan pengembangan / modifikasi 

Ringkasan bahasa utama, serta persyaratan bila ingin **mengembangkan atau memodifikasi** bagian terkait `ls`/output:

* **`ls` / coreutils**: implementasi utama adalah GNU **coreutils** (`ls` termasuk di situ). Project dan manual tersedia di GNU; kode sumber ditulis dalam **C**. Untuk memodifikasi `ls`, Anda perlu:

  * Bahasa: **C** (kemampuan membaca/menulis C modern).
  * Build tools: `gcc`/`clang`, `make`/`autoconf`, `automake` (tergantung versi).
  * Familiar dengan POSIX API (sys/stat.h, readdir, stat/lstat, permissions handling).
  * Knowledge: behavior FS, locales, uids/gids, ACL/xattr/SELinux interaction.
  * Test: jalankan di lingkungan Linux, paket `coreutils` build, atau gunakan container.
  * Referensi implementasi: kode sumber GNU coreutils (manual & repo). ([gnu.org][a])

* **Kernel / device nodes**: tipe `c`/`b` dihasilkan oleh kernel / udev. Kernel ditulis **C**; untuk memodifikasi cara kernel expose device memerlukan pengembangan kernel (C, build kernel, modul). Untuk membuat node manual: `mknod` (root). ([gnu.org][a])

---

# Ringkasan & tautan rujukan singkat

* Tipe karakter di posisi pertama permission string = file type (`-`, `d`, `l`, `c`, `b`, `p`, `s`, dll.). (lihat GNU coreutils/manual ls). ([gnu.org][a])
* Special bits (`s`, `S`, `t`) punya efek fungsional yang penting (setuid/setgid/sticky) dan angka oktal mereka (4000/2000/1000). ([GeeksforGeeks][g])
* Indikator `+`, `.`, `@` menandakan ACL / SELinux / extended attributes; gunakan `getfacl`, `id -Z`, `xattr/getfattr` untuk memeriksa. ([Linux Audit][d])

---

[a]: https://www.gnu.org/s/coreutils/manual/coreutils.html?utm_source=chatgpt.com "GNU Coreutils 9.9"
[b]: https://man7.org/linux/man-pages/man1/ls.1.html?utm_source=chatgpt.com "ls(1) - Linux manual page"
[c]: https://www.redhat.com/en/blog/linux-file-permissions-explained?utm_source=chatgpt.com "Linux file permissions explained"
[d]: https://linux-audit.com/categories/file-systems/?utm_source=chatgpt.com "Topic: File systems - Linux Audit"
[e]: https://unix.stackexchange.com/questions/102624/what-does-a-dot-after-the-file-permission-bits-mean?utm_source=chatgpt.com "What does a dot after the file permission bits mean?"
[f]: https://discussions.apple.com/thread/3233347?utm_source=chatgpt.com "What is the @ sign at the end of a file mode string"
[g]: https://www.geeksforgeeks.org/linux-unix/setuid-setgid-and-sticky-bits-in-linux-file-permissions/?utm_source=chatgpt.com "SetUID, SetGID, and Sticky Bits in Linux File Permissions"
<!-- > - **[Selanjutnya][selanjutnya]** -->
> - **[Kembali][kurikulum]**

[kurikulum]: ../README.md
<!-- [selanjutnya]: ../bagian-2/README.md -->

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
