# cp (copy)

Ppanduan lengkap penggunaan `cp` (dan contoh `mv` untuk memindahkan subdirektori) di Arch Linux dengan tampilan struktur direktori sebelum dan sesudah (menggunakan `tree`). Setiap contoh disertai output “Struktur awal” dan “Hasil” dalam format tree.

---

## 1. Menyalin File

### 1.1. Salin satu file ke file baru

```bash
cp dokumen.txt salinan_dokumen.txt
```

```bash
# Struktur awal:
└── dokumen.txt

# Hasil:
├── dokumen.txt
└── salinan_dokumen.txt
```

### 1.2. Salin file ke direktori

```bash
cp gambar.jpg ~/Gambar/
```

```bash
# Struktur awal:
└── gambar.jpg

# Hasil:
Gambar
└── gambar.jpg
```

### 1.3. Salin beberapa file sekaligus

```bash
cp file1.txt file2.txt folder_tujuan/
```

```bash
# Struktur awal:
├── file1.txt
└── file2.txt

# Hasil:
folder_tujuan
├── file1.txt
└── file2.txt
```

---

## 2. Menyalin Direktori Secara Rekursif

### 2.1. Opsi `-r`

```bash
cp -r Musik/ Backup_Musik/
```

```bash
# Struktur awal:
Musik
├── lagu1.mp3
└── playlist
    └── fav.m3u

# Hasil:
├── Musik
│   ├── lagu1.mp3
│   └── playlist
│       └── fav.m3u
└── Backup_Musik
    ├── lagu1.mp3
    └── playlist
        └── fav.m3u
```

---

## 3. Preserve Atribut

### 3.1. `-p` (mode, ownership, timestamps)

```bash
cp -p skrip.sh backup_skrip/
```

```bash
# Struktur awal:
└── skrip.sh   (mode=755, owner=cendekiawan)

# Hasil:
backup_skrip
└── skrip.sh   (mode=755, owner=cendekiawan)
```

### 3.2. `-a` (archive = -r + -p + …)

```bash
cp -a project/ backup_project/
```

```bash
# Struktur awal:
project
├── src/
│   └── main.dart
└── README.md

# Hasil:
├── project
│   ├── src/
│   │   └── main.dart
│   └── README.md
└── backup_project
    ├── src/
    │   └── main.dart
    └── README.md
```

---

## 4. Penanganan Konflik Overwrite

```bash
cp -i laporan.pdf /backup/    # -i: tanya sebelum overwrite
cp -n data.csv /backup/       # -n: no clobber, tidak timpa
cp -u catatan.txt /backup/    # -u: hanya jika sumber lebih baru
cp --backup=numbered log.txt /backup/
```

```bash
# Contoh -i:
# Struktur awal:
└── laporan.pdf

# Setelah cp -i ke /backup:
/backup
└── laporan.pdf    # (jika jawab 'y')
```

---

## 5. Penanganan Tautan (Links)

```bash
cp -L link.txt salinan.txt   # Salin target link
cp -P link.txt salinan.txt   # Pertahankan symlink
cp --link file.txt hardlink.txt
```

```bash
# Struktur awal:
├── file.txt
└── link.txt -> file.txt

# Hasil cp -P:
├── file.txt
├── link.txt -> file.txt
└── salinan.txt -> file.txt
```

---

## 6. Opsi Lainnya

* **`-t`**: target di awal

  ```bash
  cp -t dest/ file1 file2
  ```
* **`-v`**: verbose

  ```bash
  cp -v file.txt dest/
  ```
* **`--sparse=always`**: efisien untuk file sparse
* **`--parents`**: pertahankan struktur sumber

  ```bash
  cp --parents src/file.txt backup/
  ```

  ```bash
  # Hasil:
  backup
  └── src
      └── file.txt
  ```

---

## 7. Kombinasi Dengan Perintah Lain

### 7.1. `find` + `cp`

```bash
find . -name "*.txt" -exec cp -t semua_txt/ {} +
```

```bash
# Struktur awal:
.
├── a.txt
└── folder
    └── b.txt

# Hasil:
semua_txt
├── a.txt
└── b.txt
```

### 7.2. `tar` + `ssh`

```bash
tar czf - folder/ | ssh remote "tar xzf - -C /dest"
```

---

## 8. Contoh `mv` untuk Memindahkan Subdirektori

> **Tanpa** memasukkan parent directory, hanya memindahkan isi subfolder.

### 8.1. Pindahkan `subproject/` ke `~/Projects/`

```bash
mv parent/subproject ~/Projects/
```

```bash
# Struktur awal:
parent
├── subproject
│   └── code.py
└── other.txt

# Hasil:
parent
└── other.txt

Projects
└── subproject
    └── code.py
```

### 8.2. Pindahkan semua subfolder dari `Archive/` ke `Old/`

```bash
mv Archive/* Old/
```

```bash
# Struktur awal:
Archive
├── 2023
└── 2024

# Hasil:
Archive   # (kosong)
Old
├── 2023
└── 2024
```

---

## 9. Tips dan Best Practices

* Gunakan alias `alias cp='cp -i'` di `.bashrc`
* Lakukan dry-run dengan `echo` sebelum operasi massal
* Backup penting sebelum operasi besar (tar/rsync)
* Waspada saat gunakan `-r` di target yang salah

---

### 10. Lihat Semua Opsi

```bash
cp --help
man cp
```

Dengan ini setiap contoh telah dilengkapi keluaran tree sebelum dan setelah operasi, plus tambahan contoh `mv` untuk memindahkan subdirektori tanpa memasukkan parent. Solusi ini memungkinkan operasi file/folder kompleks dalam satu baris perintah sambil menjaga keamanan dan fleksibilitas. Dan dengan menguasai opsi-opsi di atas, maka bisa memanfaatkan `cp` untuk hampir semua kebutuhan salin-menyalin di Arch Linux, mulai dari operasi sederhana hingga skenario kompleks.
