# mv / move

**Perintah `mv` di Linux - Panduan Komprehensif**

Perintah `mv` (move) digunakan untuk **memindahkan** atau **mengganti nama** file/direktori. Berikut penjelasan lengkap mulai dari dasar hingga tingkat lanjut:

---

### **1. Dasar Penggunaan**

#### **a. Mengganti Nama File**

```bash
mv nama_file_lama nama_file_baru
```

Contoh:

```bash
mv dokumen.txt laporan.txt  # Mengubah nama "dokumen.txt" menjadi "laporan.txt"
```

#### **b. Memindahkan File ke Direktori**

```bash
mv file.txt /path/ke/direktori/tujuan/
```

Contoh:

```bash
mv gambar.jpg ~/Gambar/  # Memindahkan "gambar.jpg" ke direktori "Gambar" di home.
```

#### **c. Memindahkan Direktori**

```bash
mv direktori_lama/ direktori_baru/
```

Contoh:

```bash
mv Projek/ Projek_2023/  # Mengubah nama direktori "Projek" menjadi "Projek_2023"
```

---

### **2. Opsi Penting `mv`**

- **`-i` (Interactive)**: Konfirmasi sebelum menimpa file.

  ```bash
  mv -i file.txt direktori/
  ```

- **`-v` (Verbose)**: Menampilkan detail operasi.

  ```bash
  mv -v *.log ~/Logs/
  ```

- **`-n` (No-clobber)**: Tidak menimpa file yang sudah ada.

  ```bash
  mv -n file.txt direktori/
  ```

- **`-b` (Backup)**: Membuat backup file yang ditimpa (misal: `file.txt~`).

  ```bash
  mv -b file.txt direktori/
  ```

- **`--backup=numbered`**: Membuat backup dengan nomor (misal: `file.txt.~1~`).

  ```bash
  mv --backup=numbered file.txt direktori/
  ```

- **`-f` (Force)**: Memaksa operasi tanpa konfirmasi (override `-i`).
  ```bash
  mv -f file.txt direktori/
  ```

---

### **3. Teknik Lanjut**

#### **a. Memindahkan Banyak File Sekaligus**

```bash
mv file1.txt file2.jpg file3.mp3 ~/Documents/
```

#### **b. Menggunakan Wildcard**

```bash
mv *.pdf ~/Documents/  # Memindahkan semua file PDF
mv chapter_??.txt buku/  # Memindahkan file dengan pola (misal: chapter_01.txt)
```

#### **c. Memindahkan File dengan Kriteria Tertentu**

Gabungkan dengan `find`:

```bash
find . -name "*.tmp" -exec mv {} ~/Trash/ \;
```

#### **d. Rename Massal dengan Parameter Expansion**

Gunakan loop `bash` untuk rename kompleks:

```bash
for file in *.jpeg; do
  mv "$file" "${file%.jpeg}.jpg"
done
```

#### **e. Memindahkan File Tersembunyi (Hidden)**

```bash
mv .* ~/backup_hidden/  # Hati-hati: termasuk . dan ..
mv ./.* ~/backup_hidden/  # Lebih aman
```

#### **f. Menggunakan `xargs` untuk Efisiensi**

```bash
ls | grep ".log" | xargs mv -t ~/Logs/
```

---

### **4. Skenario Khusus**

#### **a. Memindahkan ke Filesystem Berbeda**

- `mv` akan melakukan **copy + delete** otomatis jika target berbeda filesystem.
- Untuk memastikan, gunakan `rsync`:
  ```bash
  rsync -avh --remove-source-files file.txt /mnt/backup/
  ```

#### **b. Menangani File dengan Spasi/Nama Aneh**

Gunakan tanda kutip atau escape karakter:

```bash
mv "file dengan spasi.txt" ~/Documents/
mv file\ dengan\ spasi.txt ~/Documents/
```

#### **c. Menghindari Overwrite dengan Backup**

```bash
mv --backup=numbered laporan.txt backup/
# Hasil: laporan.txt.~1~, laporan.txt.~2~, dst.
```

#### **d. Dry Run (Simulasi)**

Gabungkan dengan `echo` untuk simulasi:

```bash
echo mv -v *.txt ~/Documents/
```

---

### **5. Tips & Peringatan**

- **Backup Data**: Selalu gunakan `-i` atau `-b` saat memindahkan file penting.
- **Perizinan**: Jika memindahkan file sistem, gunakan `sudo`.
- **Symlinks**:
  - `mv symlink/ target/` akan memindahkan symlink, bukan targetnya.
  - Jika target symlink dipindahkan, symlink akan rusak.
- **Batch Rename Kompleks**: Pertimbangkan `rename` atau `mmv` untuk pola regex kompleks.

---

### **6. Contoh Integrasi dengan Perintah Lain**

#### **a. Gabung dengan `grep` dan `xargs`**

```bash
grep -rl "draft" | xargs mv -t ~/Drafts/
```

#### **b. Seleksi File Berdasarkan Ukuran**

```bash
find . -size +10M -exec mv {} ~/LargeFiles/ \;
```

#### **c. Rename Berdasarkan Tanggal**

```bash
mv foto.jpg "$(date +%Y%m%d)_foto.jpg"
```

## Contoh kasus :

### **1. Pemindahan Berbasis Skala Besar (Ribuan File)**

**Kasus**: Memindahkan semua file `.log` dari `/var/log/` ke direktori `~/Logs/archive/`.

**Solusi**:

```bash
# Menggunakan find + xargs untuk efisiensi
find /var/log/ -type f -name "*.log" -print0 | xargs -0 mv -t ~/Logs/archive/

# Atau dengan parallel (jika terinstall)
find /var/log/ -name "*.log" | parallel mv {} ~/Logs/archive/
```

**Penjelasan**:

- `-print0` dan `xargs -0` untuk menangani nama file dengan spasi/karakter khusus.
- `-t` pada `mv` untuk menentukan direktori tujuan.
- `parallel` mempercepat proses dengan multithreading.

---

### **2. Pemindahan ke Direktori Berbeda untuk Masing-Masing Folder**

**Kasus**: Memindahkan folder `Documents/`, `Music/`, `Videos/` ke direktori berbeda:

- `Documents/` → `~/Backup/2023/docs/`
- `Music/` → `/mnt/external_drive/media/music/`
- `Videos/` → `/mnt/external_drive/media/videos/`

**Solusi**:

```bash
# Gunakan array untuk mapping sumber -> tujuan
declare -A destinations=(
  ["Documents"]="~/Backup/2023/docs/"
  ["Music"]="/mnt/external_drive/media/music/"
  ["Videos"]="/mnt/external_drive/media/videos/"
)

for folder in "${!destinations[@]}"; do
  mkdir -p "${destinations[$folder]}"  # Pastikan direktori tujuan ada
  mv -v "$folder" "${destinations[$folder]}"
done
```

**Penjelasan**:

- `declare -A` untuk membuat associative array (hash table).
- `${!destinations[@]}` mengiterasi semua key (nama folder sumber).
- `mkdir -p` membuat direktori tujuan jika belum ada.

---

### **3. Pemindahan Banyak File & Folder ke Satu Direktori vs Direktori Berbeda**

#### **a. Ke Satu Direktori**

```bash
# Pindahkan semua file .txt dan folder Project_* ke ~/archive/
mv *.txt Project_*/ ~/archive/
```

#### **b. Ke Direktori Berbeda Berdasarkan Jenis**

**Kasus**:

- File `.jpg` → `~/Pictures/`
- File `.mp3` → `~/Music/`
- Folder `client_*` → `~/Work/clients/`

**Solusi**:

```bash
# File .jpg dan .mp3
mv *.jpg ~/Pictures/
mv *.mp3 ~/Music/

# Folder client_*
mkdir -p ~/Work/clients/
mv client_*/ ~/Work/clients/

# Atau dengan loop
for file in *; do
  case $file in
    *.jpg) mv "$file" ~/Pictures/ ;;
    *.mp3) mv "$file" ~/Music/ ;;
    client_*) mv "$file" ~/Work/clients/ ;;
  esac
done
```

---

### **4. Pemindahan ke Subfolder dengan Kategori Kompleks**

**Kasus**: Organisasi file berdasarkan tahun dan bulan pembuatan:

- File `report_2023-04.docx` → `~/Documents/2023/April/`
- File `meeting_2023-05.txt` → `~/Documents/2023/Mei/`

**Solusi**:

```bash
for file in report_*.docx meeting_*.txt; do
  # Ekstrak tahun dan bulan dari nama file
  year=$(echo "$file" | grep -oE '20[0-9]{2}')
  month=$(echo "$file" | grep -oE '(Jan|Feb|Mar|Apr|Mei|Jun|Jul|Agu|Sep|Okt|Nov|Des)' | tr 'A-Z' 'a-z' | sed 's/^/\u&/')

  # Format bulan ke bahasa Indonesia (April, Mei, dst)
  case $month in
    "Jan") month="Januari" ;;
    "Feb") month="Februari" ;;
    "Mar") month="Maret" ;;
    "Apr") month="April" ;;
    "Mei") month="Mei" ;;
    "Jun") month="Juni" ;;
    # ... dan seterusnya
  esac

  # Buat direktori dan pindahkan file
  mkdir -p ~/Documents/"$year"/"$month"/
  mv -v "$file" ~/Documents/"$year"/"$month"/
done
```

**Penjelasan**:

- `grep -oE` untuk ekstraksi pola tahun/bulan.
- `tr` dan `sed` untuk formatting nama bulan.
- `mkdir -p` membuat struktur direktori secara rekursif.

---

### **Tips Umum**

1. **Dry Run**:  
   Tambahkan `echo` sebelum `mv` untuk simulasi:

   ```bash
   echo mv "file" "destination"
   ```

2. **Backup Otomatis**:  
   Gunakan `--backup=numbered` untuk menghindari overwrite:

   ```bash
   mv --backup=numbered file.txt destination/
   ```

3. **Penanganan Nama Aneh**:  
   Gunakan wildcard `./*` untuk menghindari kesalahan dengan hidden files:

   ```bash
   mv ./*.txt ~/Documents/
   ```

4. **Integrasi dengan `rsync`**:  
   Untuk pemindahan besar antar filesystem:
   ```bash
   rsync -avh --remove-source-files /source/ /destination/
   ```

### **7. Batasan `mv`**

Dengan kombinasi `mv`, scripting, dan alat CLI lainnya, Anda bisa menangani skenario kompleks secara efisien di Arch Linux.

- Tidak bisa memindahkan file yang sedang digunakan (open oleh proses lain).
- Tidak memiliki fitur sinkronisasi dua arah (gunakan `rsync` atau `unison`).

Dengan memahami opsi dan integrasi ini, kita bisa memaksimalkan `mv` untuk manajemen file yang efisien di Linux!
