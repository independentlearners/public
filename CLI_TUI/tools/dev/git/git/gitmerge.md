
# Git Merge

Adalah **lokal dan GitHub sama-sama memiliki commit baru**

```text
GitHub  : A ── B
Local   : A ── C

Hasil   : A ── B ── M
               └─ C ─┘
```

Artinya **tidak menghapus perubahan lokal maupun perubahan GitHub**. Cara yang aman adalah `fetch` → `merge` → selesaikan konflik jika ada → `push`.

Di repository lokal, lakukan:

```bash
git status
git fetch origin
git merge origin/main
```

Jika tidak ada konflik, Git akan menggabungkan perubahan dan Anda tinggal:

```bash
git push origin main
```

Jika branch Anda bukan `main`, ganti `main` sesuai branch aktif:

```bash
git branch --show-current
```

### Jika terjadi conflict

Misalnya Git mengatakan:

```text
CONFLICT (content): Merge conflict in lib/example.dart
```

Periksa:

```bash
git status
```

Buka file yang konflik. Anda akan menemukan pola:

```text
<<<<<<< HEAD
perubahan lokal
=======
perubahan dari GitHub
>>>>>>> origin/main
```

Edit menjadi **versi gabungan yang Anda inginkan**, lalu:

```bash
git add .
git commit
git push origin main
```

Jangan gunakan:

```bash
git push --force
```

karena itu bukan mekanisme yang tepat untuk kasus Anda dan berpotensi menimpa riwayat remote.

### Alternatif: rebase

Jika Anda ingin riwayat yang lebih linear:

```bash
git fetch origin
git rebase origin/main
```

Jika konflik:

```bash
git status
```

perbaiki file, kemudian:

```bash
git add .
git rebase --continue
```

Setelah selesai:

```bash
git push origin main
```

Namun untuk kondisi yang Anda jelaskan, **`fetch → merge → push` adalah pendekatan yang paling mudah dipahami**, terutama ketika Anda memang ingin menggabungkan dua perkembangan yang berjalan terpisah.

Struktur sederhananya:

```text
                 ┌── perubahan GitHub
A ───────────────┤
                 └── perubahan lokal
                       ↓
                    merge
                       ↓
                 hasil gabungan
                       ↓
                     push
                       ↓
                    GitHub
```

Jadi, **jangan langsung `git pull` jika Anda ingin memahami setiap tahapnya**. Gunakan:

```bash
git fetch origin
git merge origin/main
git push origin main
```

`fetch` hanya mengambil informasi terbaru dari GitHub; `merge` yang benar-benar menggabungkannya dengan branch lokal.
