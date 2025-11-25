# Pembelajaran dasar

Berikut adalah daftar **perintah dasar terminal Linux** yang penting untuk dipelajari. Perintah yang umum di sebutkan seperti (`cp`, `echo`, `ls`, `mkdir`, `ps`, `rm`, `mv`, `touch`) memang termasuk dasar, tetapi masih banyak perintah penting lainnya. Disini kita akan mengelompokkannya berdasarkan kategori untuk memudahkan pemahaman. Untuk setiap perintah apapun dilinux, kita bisa menggunakan argumen/flag `--help`, kadang `-h` contoh `cp --help` atau `mkdir --help` untuk mendapatkan bantuan terkait apa saja fitur yang disediakan. Untuk bantuan dokumentasi lengkap kita bisa menggunakan perintah `man` seperti contoh `man cp`, semua perintah dasar pasti tersedia di dalam `man` namun untuk berbagai jenis tools diluar perintah dasar/umum biasanya diperlukan pemasangan tools tersebut agar dokumentasi man tersedia

---

### **1. Manajemen File & Direktori**

| Perintah                       | Contoh                       | Deskripsi                        |
| ------------------------------ | ---------------------------- | -------------------------------- |
| [**`cp`**](cp/README.md)       | `cp file.txt backup/`        | Menyalin file/direktori.         |
| [**`mv`**](mv/README.md)       | `mv file.txt newname.txt`    | Memindahkan/mengganti nama file. |
| [**`rm`**](rm/README.md)       | `rm -r folder/`              | Menghapus file/direktori.        |
| [**`ls`**](ls/README.md)       | `ls -la`                     | Menampilkan isi direktori.       |
| [**`mkdir`**](mkdir/README.md) | `mkdir project`              | Membuat direktori baru.          |
| [**`touch`**](touch/README.md) | `touch file.txt`             | Membuat file kosong.             |
| [**`cat`**]()                  | `cat file.txt`               | Menampilkan isi file.            |
| **`nano`/`vim`**               | `nano file.txt`              | Editor teks terminal.            |
| **`chmod`**                    | `chmod 755 script.sh`        | Mengubah izin file.              |
| **`chown`**                    | `sudo chown user:file.txt`   | Mengubah kepemilikan file.       |
| **`find`**                     | `find / -name "file.txt"`    | Mencari file berdasarkan nama.   |
| **`tar`**                      | `tar -cvf arsip.tar folder/` | Membuat/mengekstrak arsip.       |

---

### **2. Manajemen Sistem**

| Perintah                 | Contoh                       | Deskripsi                                   |
| ------------------------ | ---------------------------- | ------------------------------------------- |
| [**`ps`**](ps/README.md) | `ps aux`                     | Menampilkan proses yang berjalan.           |
| **`top`/`htop`**         | `htop`                       | Memantau penggunaan sumber daya (CPU, RAM). |
| **`kill`**               | `kill 1234`                  | Menghentikan proses dengan PID.             |
| **`df`**                 | `df -h`                      | Mengecek ruang disk.                        |
| **`du`**                 | `du -sh folder/`             | Menghitung ukuran direktori.                |
| **`systemctl`**          | `sudo systemctl start nginx` | Mengelola layanan sistem.                   |
| **`journalctl`**         | `journalctl -u nginx`        | Melihat log sistem.                         |

---

### **3. Jaringan**

| Perintah      | Contoh                             | Deskripsi                                             |
| ------------- | ---------------------------------- | ----------------------------------------------------- |
| **`ping`**    | `ping google.com`                  | Mengecek koneksi jaringan.                            |
| **`curl`**    | `curl -O https://example.com/file` | Mengunduh file dari internet.                         |
| **`wget`**    | `wget https://example.com/file`    | Alternatif untuk mengunduh file.                      |
| **`ssh`**     | `ssh user@192.168.1.1`             | Koneksi ke server remote.                             |
| **`ip`**      | `ip a`                             | Menampilkan informasi jaringan (gantinya `ifconfig`). |
| **`netstat`** | `netstat -tuln`                    | Menampilkan koneksi jaringan.                         |

---

### **4. Pemrosesan Teks & Pencarian**

| Perintah          | Contoh                          | Deskripsi                      |
| ----------------- | ------------------------------- | ------------------------------ |
| **`grep`**        | `grep "error" log.txt`          | Mencari pola dalam teks.       |
| **`echo`**        | `echo "Hello" > file.txt`       | Menulis teks ke file.          |
| **`sed`**         | `sed -i 's/old/new/g' file.txt` | Mengedit teks secara otomatis. |
| **`awk`**         | `awk '{print $1}' file.txt`     | Alat pemrosesan teks lanjutan. |
| **`head`/`tail`** | `tail -f log.txt`               | Menampilkan awal/akhir file.   |

---

### **5. Manajemen Paket (Arch Linux/Manjaro)**

| Perintah     | Contoh                | Deskripsi                     |
| ------------ | --------------------- | ----------------------------- |
| **`pacman`** | `sudo pacman -Syu`    | Update sistem & instal paket. |
| **`yay`**    | `yay -S package-name` | Instal paket dari AUR.        |

---

### **6. Hak Akses & Pengguna**

| Perintah     | Contoh            | Deskripsi                               |
| ------------ | ----------------- | --------------------------------------- |
| **`sudo`**   | `sudo apt update` | Menjalankan perintah sebagai superuser. |
| **`su`**     | `su - username`   | Beralih pengguna.                       |
| **`passwd`** | `passwd`          | Mengubah kata sandi.                    |

---

### **7. Utilitas Penting Lainnya**

| Perintah      | Contoh                | Deskripsi                                |
| ------------- | --------------------- | ---------------------------------------- |
| **`history`** | `history`             | Riwayat perintah yang pernah dijalankan. |
| **`alias`**   | `alias ll='ls -la'`   | Membuat perintah pintas.                 |
| **`man`**     | `man ls`              | Membaca manual perintah.                 |
| **`which`**   | `which python`        | Menampilkan lokasi perintah.             |
| **`ln`**      | `ln -s file.txt link` | Membuat tautan simbolik.                 |

---

### **Peringatan & Tips**

1. **Hati-hati dengan `rm`**:
   - Hindari `rm -rf /` atau `rm -rf ~` karena akan menghapus seluruh sistem atau direktori home.
2. **Gunakan `sudo` dengan Bijak**:
   - Pastikan Anda memahami perintah yang dijalankan dengan `sudo` untuk menghindari kerusakan sistem.
3. **Backup Data**:
   - Selalu backup file penting sebelum melakukan operasi berisiko (misal: menghapus direktori besar).
4. **Pelajari `man` dan `--help`**:
   - Contoh: `man cp` atau `cp --help` untuk memahami opsi perintah.

---

### **Perintah yang Sering Terlupakan Tapi Penting**

- **`rsync`**: Untuk sinkronisasi file (lebih baik dari `cp`).  
  Contoh: `rsync -av source/ destination/`
- **`scp`**: Menyalin file melalui SSH.  
  Contoh: `scp file.txt user@remote:/path/`
- **`tmux`**/**`screen`**: Mengelola sesi terminal (berguna untuk remote work).
- **`diff`**: Membandingkan isi dua file.  
  Contoh: `diff file1.txt file2.txt`

## Kompendium Lengkap Perintah CLI Linux

Panduan komprehensif tentang perintah CLI Linux berdasarkan informasi yang sudah diberikan, menambahkan perintah yang belum tercakup, dan menjelaskannya secara mendalam dengan contoh implementasi.

## 1. Perintah Navigasi dan Manajemen File Sistem

### `pwd` (Print Working Directory)

Menampilkan direktori kerja saat ini.

```bash
pwd
# Output: /home/user/Documents
```

### `ls` (List)

Menampilkan konten direktori.

```bash
# Menampilkan semua file termasuk yang tersembunyi dengan detail
ls -la
# Menampilkan dengan ukuran yang mudah dibaca
ls -lh
# Menampilkan folder saja
ls -d */
```

### `cd` (Change Directory)

Berpindah antar direktori.

```bash
# Pindah ke direktori tertentu
cd Documents
# Kembali ke direktori induk
cd ..
# Kembali ke direktori home
cd ~
# Kembali ke direktori sebelumnya
cd -
```

### `mkdir` (Make Directory)

Membuat direktori baru.

```bash
# Membuat satu direktori
mkdir proyek_baru
# Membuat direktori bersarang sekaligus
mkdir -p proyek/src/components
```

### `touch`

Membuat file kosong atau mengupdate timestamp file.

```bash
# Membuat file kosong
touch dokumen.txt
# Membuat beberapa file sekaligus
touch file1.txt file2.txt file3.txt
```

### `cp` (Copy)

Menyalin file atau direktori.

```bash
# Menyalin file
cp dokumen.txt backup/
# Menyalin direktori secara rekursif
cp -r proyek/ backup/
# Menyalin dengan mempertahankan atribut
cp -a source_file destination_file
```

### `mv` (Move)

Memindahkan atau mengganti nama file/direktori.

```bash
# Mengganti nama file
mv old_name.txt new_name.txt
# Memindahkan file ke direktori lain
mv file.txt /path/to/destination/
# Memindahkan beberapa file sekaligus
mv file1.txt file2.txt destination/
```

### `rm` (Remove)

Menghapus file atau direktori.

```bash
# Menghapus file
rm file.txt
# Menghapus direktori dan isinya secara rekursif
rm -r direktori/
# Menghapus tanpa konfirmasi (hati-hati!)
rm -f sensitif.txt
# Kombinasi rekursif dan force (sangat berbahaya!)
rm -rf direktori_lama/
```

### `rmdir` (Remove Directory)

Menghapus direktori kosong.

```bash
rmdir direktori_kosong
```

### `ln` (Link)

Membuat tautan antara file.

```bash
# Membuat hard link
ln target link_name
# Membuat symbolic link (lebih umum digunakan)
ln -s /path/to/target link_name
```

## 2. Perintah Melihat dan Memanipulasi Konten File

### `cat` (Concatenate)

Menampilkan isi file atau menggabungkan file.

```bash
# Menampilkan isi file
cat file.txt
# Menggabungkan beberapa file
cat file1.txt file2.txt > gabungan.txt
# Menambahkan konten ke file
cat >> file.txt << EOF
Ini adalah teks
yang akan ditambahkan
ke file
EOF
```

### `less`

Melihat file dengan kemampuan scroll.

```bash
less file_panjang.log
# Tekan / untuk mencari, q untuk keluar
```

### `head` dan `tail`

Menampilkan awal atau akhir file.

```bash
# Menampilkan 10 baris pertama
head file.txt
# Menampilkan 5 baris pertama
head -n 5 file.txt
# Menampilkan 10 baris terakhir
tail file.txt
# Monitoring file secara real-time (sangat berguna untuk log)
tail -f /var/log/syslog
# Menampilkan semua kecuali 5 baris pertama
tail -n +6 file.txt
```

### `nano`, `vim`, `emacs`

Editor teks berbasis terminal.

```bash
# Editor sederhana untuk pemula
nano file.txt
# Editor lebih powerful dengan kurva belajar lebih tinggi
vim dokumen.txt
# Editor kompleks dengan banyak fitur
emacs proyek.txt
```

### `echo`

Menampilkan teks atau nilai variabel.

```bash
# Menampilkan teks
echo "Hello World"
# Menulis ke file (overwrite)
echo "Konten baru" > file.txt
# Menambahkan ke file (append)
echo "Teks tambahan" >> file.txt
# Menampilkan nilai variabel
echo $PATH
```

## 3. Pencarian dan Manipulasi Teks

### `grep` (Global Regular Expression Print)

Mencari pola teks dalam file.

```bash
# Mencari kata dalam file
grep "error" log.txt
# Pencarian rekursif dalam direktori
grep -r "function" /path/to/codebase
# Mencari dengan menampilkan nomor baris
grep -n "WARNING" *.log
# Pencarian case-insensitive
grep -i "error" log.txt
# Menampilkan hanya nama file yang cocok
grep -l "pattern" *.txt
# Menggunakan regex
grep -E "error|warning" log.txt
```

### `sed` (Stream Editor)

Editor aliran teks untuk transformasi data.

```bash
# Mengganti teks dalam file
sed 's/old/new/' file.txt
# Mengganti semua kemunculan (global)
sed 's/old/new/g' file.txt
# Mengganti pada baris tertentu
sed '3s/old/new/' file.txt
# Menghapus baris
sed '5d' file.txt
# Menyimpan perubahan ke file (in-place)
sed -i 's/old/new/g' file.txt
# Bekerja dengan delimiter lain
sed 's|/path/old|/path/new|g' file.txt
```

### `awk`

Bahasa pemrograman untuk pemrosesan teks.

```bash
# Menampilkan kolom tertentu
awk '{print $1}' file.txt
# Memfilter baris berdasarkan kondisi
awk '$3 > 100 {print $1, $3}' data.txt
# Menjumlahkan kolom
awk '{sum+=$1} END {print sum}' numbers.txt
# Menggunakan pemisah khusus
awk -F, '{print $1, $3}' data.csv
# Script awk multi-baris
awk '
BEGIN {print "Start processing"}
{total += $1}
END {print "Total:", total}
' data.txt
```

### `cut`

Mengekstrak bagian dari setiap baris file.

```bash
# Mengambil karakter berdasarkan posisi
cut -c 1-5 file.txt
# Mengambil field berdasarkan delimiter
cut -d, -f1,3 data.csv
```

### `sort`

Mengurutkan baris teks.

```bash
# Pengurutan dasar
sort file.txt
# Pengurutan numerik
sort -n numbers.txt
# Pengurutan terbalik
sort -r file.txt
# Pengurutan berdasarkan kolom ke-2
sort -k2 data.txt
# Menghapus duplikat setelah pengurutan
sort -u file.txt
```

### `uniq`

Melaporkan atau menghilangkan baris yang berulang.

```bash
# Menghilangkan baris duplikat berurutan
uniq file.txt
# Menampilkan hanya baris duplikat
uniq -d file.txt
# Menampilkan jumlah kemunculan
uniq -c file.txt
```

### `tr` (Translate)

Mentranslasikan atau menghapus karakter.

```bash
# Mengubah huruf kecil menjadi huruf besar
cat file.txt | tr 'a-z' 'A-Z'
# Menghapus karakter tertentu
cat file.txt | tr -d '\n'
# Menghapus karakter berulang
echo "hellooo" | tr -s 'o'
```

## 4. Perintah Sistem dan Proses

### `ps` (Process Status)

Menampilkan proses yang sedang berjalan.

```bash
# Menampilkan proses pengguna saat ini
ps
# Menampilkan semua proses dengan format lengkap
ps aux
# Menampilkan proses dalam format pohon
ps axjf
# Mencari proses spesifik
ps aux | grep firefox
```

### `top` / `htop`

Memantau proses sistem secara real-time.

```bash
# Monitoring dasar
top
# Monitoring lebih interaktif (perlu instalasi)
htop
```

### `kill`

Menghentikan proses.

```bash
# Menghentikan proses dengan PID
kill 1234
# Menghentikan paksa
kill -9 1234
# Menghentikan semua proses dengan nama tertentu
killall firefox
```

### `df` (Disk Free)

Menampilkan penggunaan ruang disk.

```bash
# Menampilkan dalam format mudah dibaca
df -h
# Menampilkan sistem file tertentu
df -h /home
# Menampilkan jenis sistem file
df -T
```

### `du` (Disk Usage)

Mengestimasi penggunaan ruang file.

```bash
# Menampilkan ukuran direktori
du -sh /path/to/dir
# Menampilkan subdirektori terurut berdasarkan ukuran
du -h --max-depth=1 /path | sort -hr
```

### `free`

Menampilkan penggunaan memori.

```bash
# Menampilkan dalam format mudah dibaca
free -h
# Menampilkan dalam megabyte
free -m
```

### `uptime`

Menampilkan berapa lama sistem telah berjalan.

```bash
uptime
```

### `systemctl`

Mengelola layanan systemd.

```bash
# Memeriksa status layanan
systemctl status nginx
# Memulai layanan
sudo systemctl start apache2
# Menghentikan layanan
sudo systemctl stop mysql
# Mengaktifkan layanan saat boot
sudo systemctl enable ssh
# Menonaktifkan layanan saat boot
sudo systemctl disable cups
```

### `journalctl`

Melihat log sistem.

```bash
# Melihat log sistem
journalctl
# Melihat log untuk layanan tertentu
journalctl -u nginx
# Melihat log real-time
journalctl -f
```

## 5. Perintah Jaringan

### `ping`

Menguji konektivitas jaringan.

```bash
# Ping dasar
ping google.com
# Membatasi jumlah ping
ping -c 4 192.168.1.1
```

### `curl`

Mentransfer data dari atau ke server.

```bash
# Mengunduh file
curl -O https://example.com/file.zip
# Request HTTP dengan header
curl -H "Content-Type: application/json" https://api.example.com
# POST request dengan data
curl -X POST -d "name=value" https://api.example.com
# Menyimpan output ke file
curl -o output.html https://example.com
```

### `wget`

Mengunduh file dari internet.

```bash
# Mengunduh file
wget https://example.com/file.zip
# Mengunduh secara rekursif (website)
wget -r -np https://example.com
# Melanjutkan unduhan yang terputus
wget -c https://example.com/large-file.iso
```

### `ssh` (Secure Shell)

Menghubungkan ke server jarak jauh.

```bash
# Koneksi dasar
ssh user@hostname
# Menentukan port
ssh -p 2222 user@hostname
# Menggunakan kunci privat tertentu
ssh -i key.pem user@hostname
# Port forwarding
ssh -L 8080:localhost:80 user@hostname
```

### `scp` (Secure Copy)

Menyalin file melalui SSH.

```bash
# Menyalin file ke remote server
scp file.txt user@hostname:/path/to/destination
# Menyalin file dari remote server
scp user@hostname:/path/to/file.txt local_directory
# Menyalin direktori secara rekursif
scp -r directory user@hostname:/path/to/destination
```

### `rsync`

Sinkronisasi file dan direktori.

```bash
# Sinkronisasi direktori lokal
rsync -av source/ destination/
# Sinkronisasi dengan remote server
rsync -avz -e ssh source/ user@hostname:/path/to/destination
# Sinkronisasi dengan menghapus file yang tidak ada di sumber
rsync -avz --delete source/ destination/
# Simulasi sinkronisasi (dry run)
rsync -avzn source/ destination/
```

### `ip`

Menampilkan/memanipulasi routing, perangkat, kebijakan routing.

```bash
# Menampilkan informasi alamat
ip addr show
# Menampilkan informasi routing
ip route show
# Mengaktifkan interface
ip link set eth0 up
```

### `netstat` / `ss`

Menampilkan koneksi jaringan.

```bash
# Menampilkan semua koneksi
netstat -a
# Menampilkan koneksi TCP
netstat -t
# Menampilkan port yang mendengarkan
netstat -tuln
# Alternatif modern dengan ss
ss -tuln
```

## 6. Perintah Hak Akses dan Pengguna

### `chmod` (Change Mode)

Mengubah izin file.

```bash
# Memberikan izin eksekusi ke pemilik
chmod u+x script.sh
# Set izin spesifik dengan notasi oktal
chmod 755 file.txt
# Mengubah izin secara rekursif
chmod -R 755 directory/
```

### `chown` (Change Owner)

Mengubah kepemilikan file.

```bash
# Mengubah pemilik file
sudo chown user file.txt
# Mengubah pemilik dan grup
sudo chown user:group file.txt
# Mengubah kepemilikan secara rekursif
sudo chown -R user:group directory/
```

### `sudo` (Superuser Do)

Menjalankan perintah sebagai pengguna lain (biasanya root).

```bash
# Menjalankan perintah sebagai root
sudo apt update
# Beralih ke shell root
sudo -i
# Menjalankan perintah sebagai pengguna lain
sudo -u otheruser command
```

### `su` (Switch User)

Beralih ke pengguna lain.

```bash
# Beralih ke pengguna root
su -
# Beralih ke pengguna tertentu
su - username
```

### `passwd`

Mengubah kata sandi pengguna.

```bash
# Mengubah kata sandi sendiri
passwd
# Mengubah kata sandi pengguna lain (sebagai root)
sudo passwd username
```

### `useradd` / `adduser`

Membuat pengguna baru.

```bash
# Membuat pengguna dasar
sudo useradd newuser
# Membuat pengguna dengan home directory (lebih interaktif)
sudo adduser newuser
```

### `usermod`

Memodifikasi akun pengguna.

```bash
# Menambahkan pengguna ke grup
sudo usermod -aG sudo username
# Mengubah shell pengguna
sudo usermod -s /bin/bash username
```

## 7. Perintah Utilitas Lainnya

### `find`

Mencari file dalam hierarki direktori.

```bash
# Mencari file berdasarkan nama
find /path -name "*.txt"
# Mencari file berdasarkan ukuran
find /path -size +10M
# Mencari file berdasarkan waktu modifikasi
find /path -mtime -7
# Mencari dan menjalankan perintah pada file yang ditemukan
find /path -name "*.log" -exec rm {} \;
# Mencari file dengan izin tertentu
find /path -perm 0644
```

### `tar`

Membuat dan mengekstrak arsip.

```bash
# Membuat arsip tar
tar -cvf archive.tar files/
# Membuat arsip terkompresi (gzip)
tar -czvf archive.tar.gz files/
# Membuat arsip terkompresi (bzip2)
tar -cjvf archive.tar.bz2 files/
# Mengekstrak arsip
tar -xvf archive.tar
# Mengekstrak arsip terkompresi (otomatis deteksi format)
tar -xvf archive.tar.gz
```

### `gzip`, `bzip2`, `xz`

Kompresi file.

```bash
# Kompresi dengan gzip
gzip file.txt
# Dekompresi gzip
gzip -d file.txt.gz
# Kompresi dengan bzip2 (lebih baik dari gzip)
bzip2 file.txt
# Kompresi dengan xz (rasio terbaik)
xz -9 file.txt
```

### `alias`

Membuat alias perintah.

```bash
# Membuat alias sementara
alias ll='ls -la'
# Menampilkan semua alias
alias
# Untuk alias permanen, tambahkan ke ~/.bashrc
echo 'alias ll="ls -la"' >> ~/.bashrc
```

### `history`

Menampilkan riwayat perintah.

```bash
# Melihat riwayat
history
# Menjalankan perintah dari riwayat (nomor 123)
!123
# Menjalankan perintah terakhir
!!
# Menjalankan perintah terakhir yang dimulai dengan 'apt'
!apt
```

### `cron` dan `crontab`

Menjadwalkan tugas.

```bash
# Mengedit crontab pengguna
crontab -e
# Melihat crontab pengguna
crontab -l
# Format dasar crontab: m h dom mon dow command
# Contoh: menjalankan script setiap hari pada jam 2 pagi
0 2 * * * /path/to/script.sh
```

### `which`, `whereis`, `type`

Menemukan lokasi perintah.

```bash
# Mencari lokasi biner
which python
# Mencari lokasi biner, source, dan manual
whereis python
# Menentukan jenis perintah (alias, biner, dll)
type ls
```

### `watch`

Menjalankan perintah secara periodik.

```bash
# Menjalankan perintah setiap 2 detik (default)
watch ls -la
# Menjalankan perintah setiap 5 detik
watch -n 5 df -h
# Menyorot perubahan
watch -d free -m
```

### `tmux` dan `screen`

Terminal multiplexer untuk sesi persistent.

```bash
# Memulai sesi tmux baru
tmux
# Memulai sesi dengan nama
tmux new -s mysession
# Memisahkan dari sesi (detach)
# Tekan Ctrl+b, lalu d
# Menyambung kembali ke sesi
tmux attach
# Menyambung ke sesi bernama
tmux attach -t mysession
```

## 8. Kombinasi Perintah dan Pipeline

Linux CLI sangat powerful karena kemampuan kombinasi perintahnya:

### Pipeline (`|`)

Meneruskan output dari satu perintah ke perintah lain.

```bash
# Mencari proses dan filter hasilnya
ps aux | grep nginx
# Mengurutkan file berdasarkan ukuran
ls -lh | sort -rh
# Menghitung jumlah baris dalam file
cat file.txt | wc -l
# Pipeline kompleks
find /var/log -name "*.log" | xargs grep "ERROR" | sort | uniq -c
```

### Pengalihan Output (`>`, `>>`)

Mengarahkan output ke file.

```bash
# Menulis output ke file (overwrite)
ls > files.txt
# Menambahkan output ke file (append)
echo "New line" >> file.txt
# Mengarahkan error ke file
command 2> errors.log
# Mengarahkan output dan error ke file yang sama
command > output.log 2>&1
```

### Command Substitution

Menggunakan output perintah sebagai argumen.

```bash
# Menggunakan sintaks $(...)
echo "Today is $(date)"
# Versi lama dengan backticks
echo "Files: `ls | wc -l`"
# Menggunakan dalam loop
for file in $(find . -name "*.txt"); do
    echo "Processing $file"
done
```

### Chaining Commands

Menjalankan perintah berurutan dengan kondisi.

```bash
# Menjalankan command2 hanya jika command1 berhasil
command1 && command2
# Menjalankan command2 hanya jika command1 gagal
command1 || command2
# Menjalankan command secara berurutan terlepas dari hasilnya
command1 ; command2
```

## 9. Contoh Implementasi Terintegrasi

Berikut adalah contoh skenario penggunaan perintah Linux secara terintegratif untuk kasus-kasus nyata:

### Pencadangan (Backup) Otomatis

```bash
#!/bin/bash
# Script backup.sh - mengarsipkan direktori home dan menguploadnya ke server

# Variabel
BACKUP_DIR="/home/user"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="/tmp/backup_$TIMESTAMP.tar.gz"
REMOTE_USER="backup"
REMOTE_HOST="server.example.com"
REMOTE_PATH="/backups"

# Membuat arsip terkompresi
echo "Membuat backup dari $BACKUP_DIR..."
tar -czf $BACKUP_FILE $BACKUP_DIR 2>/tmp/backup_errors.log

# Memeriksa keberhasilan
if [ $? -eq 0 ]; then
    echo "Backup berhasil dibuat: $BACKUP_FILE"

    # Mentransfer ke server remote
    echo "Mengirim backup ke server remote..."
    scp $BACKUP_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/

    # Memeriksa transfer
    if [ $? -eq 0 ]; then
        echo "Transfer berhasil ke $REMOTE_HOST:$REMOTE_PATH/"

        # Menghapus file lokal untuk menghemat ruang
        rm $BACKUP_FILE
        echo "File backup lokal dihapus."
    else
        echo "ERROR: Gagal mentransfer backup ke server remote!"
    fi
else
    echo "ERROR: Gagal membuat backup!"
    cat /tmp/backup_errors.log
fi
```

### Monitoring Sistem Sederhana

```bash
#!/bin/bash
# Script monitor.sh - memantau metrik sistem utama

echo "=========== SISTEM MONITORING ==========="
echo "Waktu: $(date)"
echo ""

# Ruang disk
echo "=== PENGGUNAAN DISK ==="
df -h | grep -v "tmpfs" | grep -v "udev"
echo ""

# Penggunaan CPU
echo "=== PENGGUNAAN CPU ==="
top -bn1 | head -n 15
echo ""

# Memori
echo "=== PENGGUNAAN MEMORI ==="
free -h
echo ""

# Jaringan
echo "=== KONEKSI JARINGAN AKTIF ==="
netstat -tuln | grep LISTEN
echo ""

# Proses terbanyak menggunakan CPU
echo "=== TOP 5 PROSES CPU ==="
ps aux --sort=-%cpu | head -n 6
echo ""

# Proses terbanyak menggunakan memori
echo "=== TOP 5 PROSES MEMORI ==="
ps aux --sort=-%mem | head -n 6
echo ""

# Log sistem terbaru
echo "=== LOG SISTEM TERBARU ==="
journalctl -n 10 --no-pager
```

### Pengolahan Data Log

```bash
#!/bin/bash
# Script analyze_logs.sh - menganalisis file log untuk pola tertentu

LOG_FILE="/var/log/apache2/access.log"
TEMP_FILE="/tmp/log_analysis.tmp"

echo "Analisis Log: $LOG_FILE"
echo "===================="

# Hitung total request
TOTAL=$(wc -l < $LOG_FILE)
echo "Total request: $TOTAL"

# Request per jam
echo -e "\nRequest per jam:"
awk '{print $4}' $LOG_FILE | cut -d: -f2 | sort | uniq -c | sort -nr

# HTTP response codes
echo -e "\nHTTP response codes:"
awk '{print $9}' $LOG_FILE | sort | uniq -c | sort -nr

# IP address paling aktif
echo -e "\nTop 10 IP address:"
awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -10

# URLs paling banyak diakses
echo -e "\nTop 10 URL yang diakses:"
awk '{print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -10

# User agents
echo -e "\nBrowser/User Agent:"
awk -F\" '{print $6}' $LOG_FILE | sort | uniq -c | sort -nr | head -5

# Request dengan error 404
echo -e "\nURL dengan 404 error:"
grep " 404 " $LOG_FILE | awk '{print $7}' | sort | uniq -c | sort -nr | head -10
```

## 10. Tips Efisiensi dan Peningkatan Produktivitas

### 1. Menggunakan Shortcut Terminal

- `Ctrl+C`: Menghentikan proses yang berjalan
- `Ctrl+Z`: Menangguhkan proses (bisa dilanjutkan dengan `fg`)
- `Ctrl+D`: Logout dari terminal atau keluar dari shell
- `Ctrl+L`: Membersihkan layar (sama dengan `clear`)
- `Ctrl+A`: Pindah ke awal baris
- `Ctrl+E`: Pindah ke akhir baris
- `Ctrl+U`: Menghapus dari kursor ke awal baris
- `Ctrl+K`: Menghapus dari kursor ke akhir baris
- `Ctrl+W`: Menghapus kata sebelum kursor
- `Ctrl+R`: Pencarian riwayat perintah secara interaktif

### 2. Konfigurasi Shell yang Berguna

Menambahkan konfigurasi ini ke `~/.bashrc` atau `~/.zshrc`:

```bash
# Alias umum
alias update='sudo apt update && sudo apt upgrade'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'

# History yang lebih baik
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups

# Prompt yang informatif
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Fungsi untuk membuat direktori dan langsung masuk
mcd() {
    mkdir -p "$1" && cd "$1"
}

# Fungsi untuk mengekstrak berbagai format arsip
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' tidak dapat diekstrak" ;;
        esac
    else
        echo "'$1' bukan file valid"
    fi
}
```

## Kesimpulan

Linux CLI menawarkan kekuatan dan fleksibilitas luar biasa dengan perintah-perintah yang memungkinkan kontrol penuh atas sistem. Meskipun kurva pembelajaran mungkin terlihat curam pada awalnya, memahami perintah-perintah dasar dan bagaimana mengkombinasikannya akan membuka pintu untuk produktivitas dan kemampuan administrasi sistem yang lebih efisien. Yang paling penting, pendekatan terbaik untuk belajar CLI Linux adalah dengan praktik langsung—eksperimen dengan perintah yang berbeda, baca dokumentasi (`man pages`), dan bangun kebiasaan menyelesaikan tugas sehari-hari melalui terminal.

> Simpan daftar ini sebagai referensi cepat!
