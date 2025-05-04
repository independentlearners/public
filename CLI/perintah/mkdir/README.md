# mkdir / make direktory

Penjelasan lengkap dan tuntas tentang perintah `mkdir` di Linux (Arch Linux), mencakup kemampuan dasar hingga lanjutan, serta integrasi dengan perintah lainnya:

---

### **Dasar Penggunaan `mkdir`**

#### 1. **Membuat Direktori Tunggal**

```bash
mkdir nama_folder
```

- Membuat direktori baru di lokasi saat ini.

#### 2. **Membuat Beberapa Direktori Sekaligus**

```bash
mkdir folder1 folder2 folder3
```

- Membuat beberapa direktori dalam satu perintah.

#### 3. **Membuat Direktori dengan Path Lengkap**

```bash
mkdir /path/ke/direktori/baru
```

- Membuat direktori di lokasi absolut (pastikan direktori induk sudah ada).

---

### **Fitur Lanjutan `mkdir`**

#### 1. **Membuat Direktori Bersarang (Parent Directories) dengan `-p`**

```bash
mkdir -p parent/child/grandchild
```

- Opsi `-p` (parents) membuat direktori induk jika belum ada.
- Contoh: Jika `parent` tidak ada, semua direktori (`parent`, `child`, `grandchild`) akan dibuat.

#### 2. **Menampilkan Proses Pembuatan Direktori (`-v`)**

```bash
mkdir -pv parent/child/grandchild
```

- Opsi `-v` (verbose) menampilkan output detail setiap direktori yang dibuat.

#### 3. **Atur Hak Akses (Permissions) dengan `-m`**

```bash
mkdir -m 755 secure_dir
```

- Opsi `-m` mengatur hak akses direktori saat dibuat.
- `755` = `rwxr-xr-x` (pemilik: read/write/execute, lainnya: read/execute).

#### 4. **Membuat Direktori dengan Nama Spesial**

```bash
mkdir "nama dengan spasi"
mkdir nama\ dengan\ spasi
mkdir 'nama-dengan-!#$'
```

- Gunakan tanda kutip (`"` atau `'`) atau backslash (`\`) untuk nama direktori yang mengandung spasi atau karakter khusus.

---

### **Integrasi dengan Perintah Lain**

#### 1. **Membuat Direktori dari Output Perintah Lain**

```bash
mkdir $(date +%Y-%m-%d)          # Membuat direktori dengan nama tanggal hari ini
mkdir $(uname -r)                # Membuat direktori dengan nama versi kernel
```

#### 2. **Membuat Direktori dari Daftar dalam File**

```bash
cat list_direktori.txt | xargs mkdir -p
```

- File `list_direktori.txt` berisi nama direktori (satu per baris).

#### 3. **Membuat Struktur Direktori Kompleks dengan `brace expansion`**

```bash
mkdir -p project/{src,doc,test/{unit,integration}}
```

- Hasil:
  ```
  project/
  ├── doc
  ├── src
  └── test
      ├── integration
      └── unit
  ```

#### 4. **Membuat Direktori dengan Template**

```bash
mkdir -p backup-$(date +%Y%m%d){_old,_new}
```

- Hasil: `backup-20231025_old` dan `backup-20231025_new`.

---

### **Skrip dan Automasi**

#### 1. **Membuat Direktori untuk Setiap User**

```bash
cut -d: -f1 /etc/passwd | xargs -I{} mkdir -p /home/backup/{}
```

- Membuat direktori backup untuk setiap user di sistem.

#### 2. **Membuat Direktori Berdasarkan Pola**

```bash
for i in {1..5}; do mkdir -p "folder$i"; done
```

- Membuat direktori `folder1` hingga `folder5`.

---

### **Tips Troubleshooting**

1. **Direktori Sudah Ada:**

   ```bash
   mkdir -p existing_dir   # Tidak menampilkan error
   ```

2. **Izin Tidak Cukup:**

   - Pastikan Anda memiliki izin write di direktori induk.

3. **Karakter Tidak Valid:**
   - Hindari karakter seperti `/`, `:`, atau karakter kontrol dalam nama direktori.

---

### **Arsitektur `mkdir` di Arch Linux**

- Di Arch Linux, `mkdir` adalah bagian dari paket `coreutils` (GNU `mkdir`).
- Untuk memastikan:
  ```bash
  pacman -Ql coreutils | grep mkdir
  ```

---

### **Kesimpulan Kemampuan `mkdir`**

1. **Membuat direktori tunggal atau banyak.**
2. **Membuat struktur direktori kompleks dengan opsi `-p`.**
3. **Mengatur hak akses saat direktori dibuat.**
4. **Bekerja dengan nama direktori kompleks (spasi, karakter khusus).**
5. **Integrasi dengan perintah lain (`xargs`, `date`, `brace expansion`, dll).**

---

### Contoh Implementasi Ultimate:

```bash
mkdir -pm 750 -v ~/projects/{web,app}/{src,assets,dist} \
  $(date +%Y-%m-%d)_backup \
  "data-$(hostname)"
```

- **Penjelasan:**
  - Membuat struktur direktori `web` dan `app` dengan subdirektori `src`, `assets`, `dist`.
  - Membuat direktori backup dengan tanggal hari ini.
  - Membuat direktori `data-namahost`.
  - Hak akses `750` (hanya pemilik yang bisa write).
  - Output verbose (`-v`).
