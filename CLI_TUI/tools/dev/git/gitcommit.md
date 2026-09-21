Kalau mau ada judul + deskripsi panjang, ada 3 cara:

### 1. Cara paling cepat: pakai `-m` 2 kali
Ini yang paling sering dipakai.

```bash
git commit -m "Pesan pada judul" -m "Deskripsi yang lebih panjang di sini"
```

`-m` kedua otomatis jadi body dan dikasih baris kosong sama Git.

Hasilnya di `git log` jadi gini:
```
Pesan pada judul

Deskripsi yang lebih panjang di sini
```

Kalau mau beberapa paragraf, tinggal tambah `-m` lagi:

```bash
git commit -m "fix: perbaiki bug login" -m "Sebelumnya login gagal kalau email pakai huruf besar." -m "Sekarang email di-lowercase dulu sebelum cek database. Fixes #123"
```

### 2. Cara paling proper: buka editor
Jangan pakai `-m` sama sekali:

```bash
git commit
```

Nanti bakal kebuka editor (nano / vim / VS Code). Tinggal tulis gini:

```
Pesan pada judul

Deskripsi panjangnya di sini. Jelaskan WHAT dan WHY,
bukan cuma WHAT. Boleh beberapa baris.

Kenapa perubahannya perlu, dampaknya apa, dll.
```

Aturan standarnya:
* Baris pertama: judul, maksimal 50 karakter
* Baris kedua: kosongin
* Baris ketiga dst: deskripsi, usahakan 72 karakter per baris biar rapi

Simpan, close editor, langsung ke-commit.

> Biar editornya enak, set dulu: `git config --global core.editor "code --wait"`

### 3. Cara multi-baris langsung di terminal

```bash
git commit -m "Pesan pada judul

Ini deskripsi panjangnya.
Bisa beberapa baris sekaligus."
```

Pakai tanda kutip dua dan enter langsung di dalam kutipnya.

---

**Rekomendasi gue:** biasain pakai cara nomor 2 (`git commit` aja). Lebih rapi dan kamu bisa lihat diff file yang diubah kalau pakai `git commit -v`.

Udah terlanjur commit cuma judul aja? Tambahin deskripsinya pakai:

```bash
git commit --amend
```
Nanti editor kebuka lagi, tinggal tambahin body-nya.
