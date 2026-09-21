<details>
  <summary>
    <strong>GPT</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Model Standar.</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

# .gitignore

```
Menambahkan ignore untuk file tertentu setelah file tersebut sudah dikomit ke github dan disin tujuannya hanya ingin menghilangkan yang digithub sedangkan di lokal tetap ada
```
Ini kasus klasik di git. `.gitignore` itu **hanya berlaku untuk file yang belum pernah di-track**. Kalau file sudah pernah kamu `git add` dan `git commit`, `.gitignore` tidak akan ngaruh sampai kamu hapus dari index git.

Tujuan kamu: hapus di GitHub tapi tetap ada di lokal = pakai `git rm --cached`

> Jangan pakai `git rm` tanpa `--cached`, itu akan menghapus file lokal kamu juga.

### Langkah Lengkap

Misal kamu mau ignore file `.env` dan folder `storage/logs`

**1. Tambahkan ke .gitignore dulu**

Buka file `.gitignore` dan tambahkan:

```
.env
storage/logs/
namafile-yang-kamu-mau.txt
```

**2. Hapus dari tracking git tapi biarkan di lokal**

Untuk 1 file:
```bash
git rm --cached .env
git rm --cached namafile-yang-kamu-mau.txt
```

Untuk 1 folder:
```bash
git rm -r --cached storage/logs/
```

**3. Commit perubahan ini**

```bash
git add .gitignore
git commit -m "chore: hentikan tracking file yang seharusnya di-ignore, file lokal tetap dipertahankan"
```

**4. Push ke GitHub**

```bash
git push origin main
```
Setelah ini, file akan hilang di GitHub, tapi di laptop kamu tetap ada.

### Kalau File-nya Sudah Banyak Terlanjur Ke-ignore

Kalau kamu sudah terlanjur menambahkan banyak aturan di `.gitignore` tapi file-file itu masih muncul di GitHub, pakai cara sapu bersih:

```bash
git rm -r --cached .
git add .
git commit -m "fix: apply .gitignore untuk file yang sudah terlanjur ter-track"
git push origin main
```
Ini akan menghapus semua file yang ada di `.gitignore` dari index git, lalu menambahkan ulang hanya file yang tidak di-ignore.

### 2 Hal Penting

**1. Untuk teman satu tim:** Saat mereka `git pull` nanti, file tersebut di lokal mereka **akan ikut terhapus**. Jadi suruh mereka backup dulu sebelum pull.

**2. Kalau file tersebut berisi password / API key:** Menghapus dengan cara di atas hanya menghapus dari commit terbaru. File tersebut **masih ada di history commit lama** di GitHub dan masih bisa dilihat orang. Kalau ini kasusnya, kamu harus ganti password / key tersebut segera.

Mau ignore file apa? Sebutkan nama file/foldernya, aku kasih command pastinya biar tinggal copy-paste.
  </div>
</details>


<details>
  <summary>
    <strong>Meta</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Thinker.</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">
        - 


# .gitignore

### Tambahan Perintah di `.gitignore`

### Mengabaikan File dengan Underscore di Awal

```PS
# Mengabaikan file yang diawali dengan underscore
_*
```

### Pengaturan Dasar

- Mengabaikan seluruh direktori:

```PS
/dir_name/
```

- Mengabaikan semua file dengan ekstensi tertentu:

```PS
*.log
```

- Mengabaikan file tertentu di sembarang lokasi:

```PS
filename.txt
```

- Mengabaikan file dalam sub-direktori tertentu:

```PS
dir_name/*.temp
```

### Contoh Umum dari Berbagai Proyek

- **Node.js Projects**:

```PS
# Mengabaikan node_modules
node_modules/
```

- **Python Projects**:

```PS
# Mengabaikan cache dan bytecode
__pycache__/
*.pyc
*.pyo
*.pyd
```

- **Java Projects (Maven/Gradle)**:

```PS
# Mengabaikan target dan build directory
target/
build/
```

- **iOS Projects**:

```PS
# Mengabaikan workspace file
*.xcworkspace
```

- **Android Projects**:

```PS
# Mengabaikan IntelliJ IDE files, Gradle artifacts dan build directory
*.iml
.gradle/
build/
```

### Penggunaan Lanjutan

- Mengabaikan file yang spesifik, tapi melacak direktori:

```PS
dir_name/*
!dir_name/tracked_file.txt
```

- Menambahkan komentar:

```PS
# Ignore all HTML files
*.html
```

- Mengabaikan semua file kecuali beberapa file tertentu:

```PS
*.log
!important.log
```

- Spesifik hanya di direktori root:

```PS
/.config
```

- Mengabaikan folder tertentu (lanjutan):

```PS
# Mengabaikan folder debug dan temp di root
/debug/
/temp/
```

- Mengabaikan semua file yang bernama tertentu di direktori mana pun:

```PS
# Mengabaikan file config.json di sembarang lokasi
config.json
```

- Mengabaikan file dengan pola di sub-direktori tertentu:

```PS
# Mengabaikan semua log files dalam direktori logs dan semua tmp files dalam direktori tmp
logs/*.log
tmp/**/*.tmp
```

- Mengabaikan output build:

```PS
# Mengabaikan output build
bin/
obj/
target/
build/
```

- Mengabaikan hasil sementara dari text editor tertentu:

```PS
*.swp
.idea/
.vscode/
```

- Mengabaikan file berdasarkan ekstensi mereka:

```PS
*.dll
*.exe
*.bak
*.swp
```

- Mengabaikan file tertentu tetapi melacak direktori:

```PS
/logs/*
!/logs/app.log
```

- Menggunakan wildcard:

```PS
# Mengabaikan file sementara
*~
*.tmp
```
  </div>
</details>


