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
