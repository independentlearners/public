# Long Format

Perintah `ls -l` adalah perintah untuk menampilkan daftar berkas dalam format panjang atau *long listing format*.

### 1. Format Umum Keluaran

Setiap baris memiliki 7 kolom utama:

```
-rwxr--r-- 1 amir staff 2048 12 Okt 10:00 nama-berkas
[1] [2] [3] [4] [5] [6] [7]
```

**Tipe berkas dan izin akses, Jumlah tautan keras, Pemilik, Grup pemilik, Ukuran dalam bita, Waktu modifikasi terakhir, Nama berkas.**[1][2][3][4][5][6][7]

Baris paling atas yang bertuliskan `total 32` menunjukkan total alokasi blok disk yang digunakan oleh seluruh berkas dalam direktori tersebut.

### 2. Kolom Pertama: Tipe Berkas dan Izin Akses

Kolom ini terdiri dari 10 hingga 11 karakter. Contoh: `drwxr-xr-x`.

#### A. Karakter ke-1: Tipe Berkas

| Simbol | Kepanjangan | Penjelasan |
| :--- | :--- | :--- |
| `-` | *regular file* | Berkas biasa, seperti dokumen, gambar, atau skrip. |
| `d` | *directory* | Direktori atau folder. |
| `l` | *link* | Tautan simbolik atau pintasan ke berkas lain. |
| `c` | *character device* | Berkas perangkat karakter, yang membaca data per karakter. Contoh: `/dev/null`. |
| `b` | *block device* | Berkas perangkat blok, yang membaca data per blok. Contoh: `/dev/sda` (cakram keras). |
| `p` | *named pipe / FIFO* | Pipa bernama untuk komunikasi antar proses. |
| `s` | *socket* | Soket untuk komunikasi antar proses atau jaringan. |
| `D` | *door* | Tipe khusus yang hanya terdapat pada sistem Solaris. |

#### B. Karakter ke-2 sampai ke-10: Izin Akses Dasar

Terbagi menjadi tiga kelompok, masing-masing tiga karakter: **pemilik (user), grup (group), dan lainnya (other).**

| Simbol | Kepanjangan | Makna |
| :--- | :--- | :--- |
| `r` | *read* | Izin untuk membaca. Pada direktori berarti izin melihat isi direktori. |
| `w` | *write* | Izin untuk menulis atau mengubah. Pada direktori berarti izin membuat atau menghapus berkas di dalamnya. |
| `x` | *execute* | Izin untuk mengeksekusi berkas sebagai program. Pada direktori berarti izin untuk masuk ke direktori tersebut. |
| `-` | - | Tidak memiliki izin tersebut. |

**Cara membaca:** `rwxr-xr--` berarti pemilik memiliki izin baca, tulis, dan eksekusi, grup memiliki izin baca dan eksekusi, sedangkan pengguna lain hanya memiliki izin baca.

#### C. Izin Khusus

Simbol khusus ini menggantikan posisi `x`:

| Simbol | Posisi | Kepanjangan | Makna |
| :--- | :--- | :--- | :--- |
| `s` | eksekusi pemilik | *setuid* | Berkas dieksekusi dengan hak pemilik berkas, bukan pelaksana. Huruf kecil menandakan izin eksekusi `x` tetap aktif. Contoh: `-rwsr-xr-x`. |
| `S` | eksekusi pemilik | *setuid* | Sama seperti di atas, tetapi izin eksekusi `x` tidak aktif. Umumnya menandakan kesalahan pengaturan. |
| `s` | eksekusi grup | *setgid* | Berkas dieksekusi dengan hak grup. Jika diterapkan pada direktori, berkas baru di dalamnya akan mewarisi grup direktori induk. |
| `S` | eksekusi grup | *setgid* | Sama seperti di atas, tetapi izin eksekusi `x` tidak aktif. |
| `t` | eksekusi lainnya | *sticky bit* | Jika diterapkan pada direktori seperti `/tmp`, hanya pemilik berkas yang dapat menghapus berkas tersebut. |
| `T` | eksekusi lainnya | *sticky bit* | Sama seperti di atas, tetapi izin eksekusi `x` tidak aktif. |

#### D. Karakter ke-11: Indikator Atribut Tambahan

Karakter ini bersifat opsional dan muncul di akhir rangkaian izin:

* **Tidak ada karakter (spasi):** Tidak ada atribut tambahan.
* `.` : Terdapat konteks keamanan SELinux.
* `+` : Terdapat Daftar Kendali Akses atau *Access Control List (ACL)*.
* `@` : Terdapat atribut tambahan pada sistem macOS.

### 3. Kolom Kedua hingga Ketujuh

1. **Jumlah Tautan:** Jumlah tautan keras yang mengarah ke berkas tersebut.
2. **Pemilik:** Nama pengguna pemilik berkas.
3. **Grup:** Nama grup pemilik berkas.
4. **Ukuran:** Ukuran berkas dalam bita. Jika menggunakan opsi `-h`, akan tampil dalam format yang mudah dibaca manusia, seperti 2K atau 1M.
5. **Waktu:** Waktu modifikasi terakhir berkas.
6. **Nama:** Nama berkas. Jika bertipe tautan simbolik, akan diikuti dengan tanda `->` dan target tujuannya.

### 4. Contoh Lengkap untuk Seluruh Tipe Berkas

```
-rw-r--r-- 1 amir staff 1024 12 Okt 10:00 dokumen.txt # berkas reguler
drwxr-xr-x 2 amir staff 4096 12 Okt 10:00 folder # direktori
lrwxrwxrwx 1 amir staff 12 12 Okt 10:00 pintasan -> dokumen.txt # tautan simbolik
crw-rw-rw- 1 root root 1, 5 12 Okt 09:00 /dev/zero # perangkat karakter
brw-rw---- 1 root disk 8, 0 12 Okt 09:00 /dev/sda # perangkat blok
prw-r--r-- 1 amir staff 0 12 Okt 10:00 pipa # FIFO, dibuat dengan mkfifo
srw-rw-rw- 1 amir staff 0 12 Okt 10:00 soket.sock # soket
```

### 5. Variasi Perintah yang Berkaitan

* `ls -la`: Menampilkan semua berkas termasuk berkas tersembunyi yang diawali titik.
* `ls -lh`: Menampilkan ukuran dalam format yang mudah dibaca.
* `ls -li`: Menampilkan nomor *inode* berkas.
* `ls -lt`: Mengurutkan berdasarkan waktu modifikasi terbaru.
* `ls -lS`: Mengurutkan berdasarkan ukuran terbesar.
