# LATIHAN

Berikut deskripsi lanjutan dengan fokus pada **globbing Zsh** dan **lingkungan pelatihan Zsh yang terisolasi**.

***

# Eksperimen Ketiga: Globbing di Zsh

## Tujuan

Memahami perbedaan antara glob biasa `*` dan recursive globbing `**/` di Zsh, serta membuat lingkungan latihan yang tidak mengganggu konfigurasi Zsh utama Anda.

Globbing adalah mekanisme *filename generation*: shell mengubah pola seperti `*.txt` menjadi daftar file yang cocok sebelum perintah dijalankan. Zsh mendukung recursive globbing melalui `**/`, dan fitur pola lanjutan lain melalui opsi `EXTENDED_GLOB`. [zsh.sourceforge](https://zsh.sourceforge.io/Guide/zshguide.html)

## 1. Siapkan direktori latihan

Jalankan perintah berikut:

```zsh
mkdir -p /tmp/zsh-glob/a/b
touch /tmp/zsh-glob/a/one.txt
touch /tmp/zsh-glob/a/b/two.txt
touch /tmp/zsh-glob/a/three.md
cd /tmp/zsh-glob
```

Struktur direktorinya menjadi:

```text
/tmp/zsh-glob
├── a
│   ├── b
│   │   └── two.txt
│   ├── one.txt
│   └── three.md
```

## 2. Glob biasa: `*.txt`

Coba:

```zsh
print -rl -- *.txt
```

Hasil yang diharapkan:

```text
zsh: no matches found: *.txt
```

`*.txt` hanya mencari file `.txt` **langsung di direktori saat ini**. Karena `one.txt` berada di dalam `a/`, pola ini tidak menemukan apa pun. 

## 3. Recursive globbing: `**/*.txt`

Coba:

```zsh
print -rl -- **/*.txt
```

Hasil yang diharapkan:

```text
a/one.txt
a/b/two.txt
```

Pola `**/` berarti “nol atau lebih level direktori”, sehingga `**/*.txt` mencakup file `.txt` di direktori saat ini maupun di seluruh subdirektori. [zsh](https://www.zsh.org/mla/announce/msg00083.html)

`three.md` tidak muncul karena polanya hanya mencari `*.txt`.

## 4. Mengaktifkan `EXTENDED_GLOB`

Untuk eksperimen ini, aktifkan opsi berikut di sesi Zsh:

```zsh
setopt EXTENDED_GLOB
```

`EXTENDED_GLOB` menambahkan operator pola seperti `^`, `~`, dan `#`. Opsi ini berguna untuk pola lanjutan, tetapi **tidak diperlukan** untuk `**/*.txt` karena recursive globbing sudah didukung Zsh secara bawaan. [zsh](https://www.zsh.org/mla/announce/msg00083.html)

Contoh penggunaan lanjutan setelah opsi aktif:

```zsh
print -rl -- **/*.txt~*two*
```

Pola tersebut mencari semua `.txt` kecuali yang mengandung `two` pada path-nya. Operator `~` hanya tersedia ketika `EXTENDED_GLOB` aktif. [zsh](https://www.zsh.org/mla/announce/msg00083.html)

## 5. Lingkungan pelatihan terisolasi

Jangan langsung menambahkan `setopt EXTENDED_GLOB` ke `~/.zshrc` untuk keperluan latihan, karena itu akan berlaku untuk semua sesi Zsh berikutnya. Gunakan `ZDOTDIR` agar Zsh membaca konfigurasi dari direktori khusus. 

Buat direktori dan konfigurasi minimal:

```zsh
mkdir -p ~/zsh-training

cat > ~/zsh-training/.zshrc <<'EOF'
setopt EXTENDED_GLOB
PROMPT='latihan> '
EOF
```

> **Catata Untuk Pemula :** Saya sendiri lebih suka menggunakan direktori /tmp untuk lingkungan ini, tetapi langkah itu relatif, nantinya anda bisa menghapus dir `~/zsh-training` setelah latihan selesai, alasan saya lebih suka menggunakan dir /tmp adalah karena saya tidak butuh menghapus secara manual semua yang sudah saya buat disana sebab seperti yang mungkin telah anda pahami dari dir `/tmp` dan itulah alasan utamanya. Jadi nantinya setelah selesai berlatih, ketika anda menggunakan dir `~/zsh-training` sebagai tempat terisolasi, hapus dir `~/zsh-training` setelahnya sebab ini membuat workflow kita lebih berasih.

Jalankan shell pelatihan:

```zsh
ZDOTDIR=~/zsh-training zsh -d
```

Opsi `-d` menonaktifkan pembacaan file startup global seperti `/etc/zprofile` dan `/etc/zshrc`, sehingga lingkungan latihan lebih bersih. 

Di dalam shell pelatihan, prompt akan berubah menjadi:

```text
latihan> 
```

Kemudian lakukan eksperimen:

```zsh
cd /tmp/zsh-glob
print -rl -- *.txt
print -rl -- **/*.txt
```

Keluar dari lingkungan latihan dengan:

```zsh
exit
```

## 6. Jika konfigurasi utama masih ikut termuat

Jika prompt atau plugin dari `~/.zshrc` masih muncul meskipun Anda sudah memakai `ZDOTDIR`, kemungkinan penyebabnya:

- `~/.zshenv` atau `/etc/zsh/zshenv` menimpa `ZDOTDIR`, misalnya dengan `export ZDOTDIR="$HOME"`.
- `~/zsh-training/.zshrc` masih memuat `source ~/.zshrc`, Oh My Zsh, starship, atau plugin manager.
- Anda menjalankan Zsh sebagai login shell, sehingga file global ikut dibaca.
- `ZDOTDIR` diatur setelah Zsh mulai berjalan, sehingga tidak memengaruhi file startup sesi tersebut. 

Periksa nilai aktifnya:

```zsh
echo "$ZDOTDIR"
```

Lacak file startup yang dibaca:

```zsh
ZDOTDIR=~/zsh-training zsh -x -i -c 'exit' 2>&1 | grep -E 'zshenv|zprofile|zshrc|zlogin|source'
```

## 7. Ringkasan pola

| Pola | Arti | Contoh hasil pada latihan |
|---|---|---|
| `*.txt` | File `.txt` langsung di direktori saat ini | Tidak ada kecocokan |
| `**/*.txt` | File `.txt` di direktori saat ini dan semua subdirektori | `a/one.txt`, `a/b/two.txt` |
| `**/*.md` | File `.md` secara rekursif | `a/three.md` |
| `**/*.txt~*two*` | Semua `.txt` kecuali path yang mengandung `two`; butuh `EXTENDED_GLOB` | `a/one.txt` |

Intinya: gunakan `*` untuk direktori saat ini, `**/` untuk pencarian rekursif, dan `EXTENDED_GLOB` hanya ketika Anda membutuhkan operator pola tambahan. [zsh](https://www.zsh.org/mla/announce/msg00083.html)
