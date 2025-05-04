# cp / copy

**Panduan Lengkap Penggunaan Perintah `cp` di Arch Linux (dan Linux Lainnya)**  
Perintah `cp` (copy) adalah alat inti untuk menyalin file dan direktori di Linux. Berikut penjelasan komprehensif tentang kemampuannya, mulai dari dasar hingga tingkat lanjut:

---

### **1. Dasar Penggunaan `cp`**

#### a. Menyalin File ke Lokasi Baru

```bash
cp [file_sumber] [file_tujuan]
```

Contoh:

```bash
cp dokumen.txt salinan_dokumen.txt
```

#### b. Menyalin File ke Direktori Tertentu

```bash
cp [file_sumber] [direktori_tujuan]
```

Contoh:

```bash
cp gambar.jpg ~/Gambar/
```

#### c. Menyalin Banyak File Sekaligus

```bash
cp file1.txt file2.txt direktori_tujuan/
```

---

### **2. Menyalin Direktori (Termasuk Subdirektori)**

Gunakan opsi **`-r`** (recursive) untuk menyalin direktori:

```bash
cp -r direktori_sumber/ direktori_tujuan/
```

Contoh:

```bash
cp -r Musik/ Backup_Musik/
```

---

### **3. Opsi Preservasi (Atribut File)**

#### a. **`-p`** (Preserve)

Mempertahankan hak akses, kepemilikan, dan timestamp.

```bash
cp -p file.txt backup/
```

#### b. **`-a`** (Archive Mode)

Mode arsip (termasuk `-r`, `-p`, dan atribut lainnya).  
**Ideal untuk backup**.

```bash
cp -a direktori_sumber/ direktori_tujuan/
```

#### c. **`--preserve=`**

Pilih atribut yang ingin dipertahankan (e.g., `mode`, `ownership`, `timestamps`).

```bash
cp --preserve=ownership file.txt /backup/
```

---

### **4. Penanganan Konflik (Overwrite)**

#### a. **`-i`** (Interactive)

Konfirmasi sebelum menimpa file.

```bash
cp -i file.txt direktori/
```

#### b. **`-n`** (No Clobber)

Tidak menimpa file yang sudah ada.

```bash
cp -n file.txt direktori/
```

#### c. **`-u`** (Update)

Hanya salin jika file sumber lebih baru atau tidak ada di tujuan.

```bash
cp -u file.txt direktori/
```

#### d. **`--backup`**

Buat backup file yang tertimpa (opsi: `--backup=numbered`, `simple`, dll).

```bash
cp --backup=numbered file.txt direktori/
```

---

### **5. Penanganan Tautan (Links)**

#### a. **`-L`** (Follow Links)

Salin file asli, bukan tautan simbolik.

```bash
cp -L tautan.txt salinan.txt
```

#### b. **`-P`** (Preserve Links)

Pertahankan tautan simbolik (default pada beberapa sistem).

```bash
cp -P tautan.txt salinan.txt
```

#### c. **`--link`**

Buat hard link (jika sumber dan tujuan di filesystem yang sama).

```bash
cp --link file.txt hardlink.txt
```

---

### **6. Advanced Copy**

#### a. **`-t`** (Target Directory)

Tentukan direktori tujuan di awal (berguna untuk `xargs`).

```bash
cp -t direktori_tujuan/ file1.txt file2.txt
```

#### b. **`-v`** (Verbose)

Tampilkan proses salin.

```bash
cp -v file.txt direktori/
```

#### c. **`--sparse=always`**

Salin file "sparse" (file dengan blok kosong) secara efisien.

```bash
cp --sparse=always large_file.img backup/
```

#### d. **`--parents`**

Pertahankan struktur direktori sumber di tujuan.

```bash
cp --parents src/file.txt backup/  # Hasil: backup/src/file.txt
```

---

### **7. Kombinasi dengan Perintah Lain**

#### a. **`find` + `cp`**

Salin file yang ditemukan oleh `find`:

```bash
find . -name "*.txt" -exec cp -t direktori_tujuan/ {} +
```

#### b. **`tar` + `ssh`**

Salin direktori antar mesin via SSH:

```bash
tar czf - direktori/ | ssh user@remote "tar xzf - -C /path/to/dest"
```

#### c. **`rsync`**

Alternatif lebih canggih untuk sinkronisasi file (bukan `cp`, tapi sering digunakan):

```bash
rsync -avz direktori/ user@remote:/path/to/dest
```

---

### **8. Skenario Khusus**

#### a. Salin File dengan Nama Spesial

Gunakan `--` untuk menghentikan parsing opsi:

```bash
cp -- -file_aneh.txt backup/
```

#### b. Salin File ke Root (Butuh `sudo`)

```bash
sudo cp file.conf /etc/
```

#### c. Salin Kepemilikan File (Butuh `sudo`)

```bash
sudo cp -a --preserve=ownership file.txt /backup/
```

---

### **9. Tips dan Peringatan**

- **Hati-hati dengan `-r`**: Pastikan direktori tujuan benar sebelum menyalin.
- **Gunakan `alias` untuk keamanan**:  
  Tambahkan `alias cp='cp -i'` di `.bashrc` untuk konfirmasi overwrite otomatis.
- **Tes dengan `-n` atau `--dry-run`** (jika tersedia) sebelum operasi besar.

---

### **10. Daftar Lengkap Opsi `cp`**

Lihat semua opsi dengan:

```bash
cp --help
```

atau dokumentasi lengkap:

```bash
man cp
```

---

### **Contoh Implementasi Kompleks**

#### Backup Harian dengan Timestamp:

```bash
cp -a --backup=numbered --suffix=$(date +".%Y-%m-%d") direktori/ backup/
```

#### Salin Hanya File Baru ke Remote Server via SSH:

```bash
tar cf - . | ssh user@remote "tar xf - -C /backup --checkpoint=1000"
```

## Eksplorasi

### Membuat Banyak Folder

```bash
# Membuat folder di direktori saat ini
mkdir -p {folder1,folder2,"Folder Dengan Spasi",project-{frontend,backend},data_{2020..2023}_{01..12}}

# Membuat folder di path tertentu
mkdir -p ~/Documents/{laporan,assets/{gambar,video},backup-$(date +%Y%m%d)}
```

#### Penjelasan dan Fungsi:

1. **`mkdir`**: Perintah dasar untuk membuat direktori
2. **`-p`**: Opsi untuk:
   - Membuat parent directory jika belum ada
   - Tidak menampilkan error jika folder sudah ada
3. **Kurung kurawal `{}`**: Teknik brace expansion untuk membuat pola
4. **Contoh pola**:
   - `{a,b,c}`: Membuat folder a, b, dan c
   - `"Folder Dengan Spasi"`: Kutip untuk nama dengan spasi
   - `project-{frontend,backend}`: Nested expansion
   - `data_{2020..2023}_{01..12}`: Sequence expansion untuk tahun dan bulan
   - `$(date +%Y%m%d)`: Command substitution untuk tanggal terkini

#### Hasil yang dibuat:

```
folder1
folder2
Folder Dengan Spasi
project-frontend
project-backend
data_2020_01
data_2020_02
...
data_2023_12
~/Documents/laporan
~/Documents/assets/gambar
~/Documents/assets/video
~/Documents/backup-20240325
```

### Menyalin Banyak File ke Multiple Folder

```bash
# Versi dasar dengan loop
for item in "file1.txt:dirA" "laporan.pdf:dirB" "*.jpg:images"; do
  file="${item%%:*}"   # Ekstrak bagian sebelum :
  dir="${item##*:}"    # Ekstrak bagian setelah :
  cp -v "$file" "$dir"
done

# Versi advanced dengan array
declare -A copy_pairs=(
  ["/path/source/file1.txt"]="/path/target/dir1"
  ["*.config"]="/etc/"
  ["/data/*.csv"]="/backup/"
)

for file in "${!copy_pairs[@]}"; do
  cp -v --parents "$file" "${copy_pairs[$file]}"
done
```

#### Penjelasan dan Fungsi:

1. **`for item in ...`**: Loop untuk memproses setiap pasangan
2. **Parameter expansion**:
   - `${item%%:*}`: Hapus semua setelah `:` (mendapatkan nama file)
   - `${item##*:}`: Hapus semua sebelum `:` (mendapatkan direktori target)
3. **`cp`**: Perintah copy dengan opsi:
   - `-v`: Verbose mode (menampilkan proses)
   - `--parents`: Mempertahankan struktur direktori
4. **Wildcard**:
   - `*.jpg`: Semua file JPEG
   - `*.config`: Semua file berekstensi .config
5. **Array asosiatif**: Untuk mapping file->direktori yang kompleks
6. **`declare -A`**: Mendeklarasikan array asosiatif (bash 4+)

#### Contoh operasi yang dilakukan:

1. Salin file1.txt ke dirA
2. Salin laporan.pdf ke dirB
3. Salin semua .jpg ke folder images
4. Salin file config ke /etc dengan struktur path
5. Backup \*.csv ke /backup

### Best Practices:

1. **Dry run** pertama dengan `echo`:
   ```bash
   for item in ...; do
     echo "Copying $file to $dir"
   done
   ```
2. **Backup** sebelum operasi besar:
   ```bash
   tar -czf backup-$(date +%Y%m%d).tgz /path/to/source
   ```
3. **Handle error**:
   ```bash
   cp -f "$file" "$dir" || echo "Gagal menyalin $file" >&2
   ```
4. **Parallel processing** (untuk file besar):
   ```bash
   parallel cp {} /target/dir ::: *.log
   ```

### Alternatif Tools:

1. **`rsync`**: Untuk sinkronisasi kompleks
   ```bash
   rsync -avh /source/{file1,file2} /target/
   ```
2. **`find` + `xargs`**: Untuk operasi rekursif
   ```bash
   find . -name "*.tmp" -print0 | xargs -0 -I{} cp {} /backup
   ```
3. **`install`**: Untuk set permission sambil copy
   ```bash
   install -m 644 -t /target/dir file1 file2
   ```

### Penanganan Kasus Khusus:

1. **Nama file dengan spasi**:
   ```bash
   cp "file name with spaces.txt" "/target dir/"
   ```
2. **File hidden**:
   ```bash
   cp .* /backup_hidden
   ```
3. **Preserve metadata**:
   ```bash
   cp -a /source /target
   ```

Kedua solusi ini memungkinkan operasi file/folder kompleks dalam satu baris perintah sambil menjaga keamanan dan fleksibilitas. Dan dengan menguasai opsi-opsi di atas, maka bisa memanfaatkan `cp` untuk hampir semua kebutuhan salin-menyalin di Arch Linux, mulai dari operasi sederhana hingga skenario kompleks.
