# **Globbing**

## **Definisi**

**Globbing** adalah proses *[pattern matching][1]* yang dilakukan **oleh shell** untuk mencocokkan nama file atau path menggunakan [**wildcard** (*glob patterns*)][2] sebelum perintah dijalankan.

> Penting: Globbing ≠ regex. Globbing lebih sederhana dan langsung diterjemahkan ke daftar file.

---

## **Bagaimana kerjanya**

1. Kamu menulis perintah dengan *pattern* (`*`, `?`, `[abc]`, dll).
2. Shell memproses pattern itu → mencari file yang cocok di filesystem.
3. Shell mengganti pattern tersebut dengan daftar hasil sebelum perintah dijalankan.

Contoh di bash/zsh:

```bash
echo *.txt
```

Jika ada `a.txt` dan `b.txt`, shell akan mengubahnya menjadi:

```bash
echo a.txt b.txt
```

---

## **Wildcard umum dalam globbing (POSIX / Bash / Zsh)**

| Pattern                | Arti                                                                         | Contoh                                         |
| ---------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------- |
| `*`                    | Cocokkan **0 atau lebih karakter** (kecuali `/`)                             | `*.txt` → semua file berakhiran `.txt`         |
| `?`                    | Cocokkan **tepat 1 karakter** (kecuali `/`)                                  | `file?.txt` → `file1.txt`, `fileA.txt`         |
| `[abc]`                | Cocokkan **1 karakter dari set**                                             | `file[123].txt` → `file1.txt`, `file2.txt`     |
| `[a-z]`                | Cocokkan karakter dalam **range**                                            | `[a-z]*.sh` → semua file diawali huruf kecil   |
| `[!abc]` atau `[^abc]` | Cocokkan **1 karakter yang bukan** dari set                                  | `file[!0-9].txt`                               |
| `{a,b,c}`              | **Brace expansion**: daftar literal                                          | `{red,blue,green}.txt`                         |
| `**`                   | Recursive match (*hanya di Bash ≥ 4 + `shopt -s globstar` atau Zsh default*) | `**/*.txt` → cari `.txt` di semua subdirektori |

---

## **Di Bash**

* Defaultnya: jika tidak ada match, pattern **tetap ditampilkan** (misalnya `*.zzz` → output `*.zzz`).
* Bisa diubah dengan:

  ```bash
  shopt -s nullglob    # Hapus pattern jika tidak ada match
  shopt -s failglob    # Error jika tidak ada match
  ```

---

## **Di Zsh**

* Zsh punya globbing **lebih kuat** (extended globbing) misalnya `^pattern` untuk negasi, `~` untuk pengecualian, dsb.
* Bisa aktifkan:

  ```zsh
  setopt extendedglob
  ```
* Contoh Zsh khusus:

  ```zsh
  ls ^*.txt   # Semua file kecuali .txt
  ```

---

## **Di PowerShell**

* PowerShell **tidak menggunakan globbing shell POSIX**, tapi punya **wildcard** yang mirip di cmdlets seperti `Get-ChildItem` (`gci`):

  ```powershell
  Get-ChildItem *.txt
  ```
* Pattern matching-nya mengikuti **wildcard .NET**, bukan globbing POSIX.

---

## **Di Lua / Dart**

* **Tidak ada globbing bawaan** di bahasa itu.
* Harus implementasi manual atau pakai library (`glob` di LuaRocks, `package:glob` di Dart).

---

## **Perbedaan Globbing vs Regex**

| Globbing                                          | Regex                                           |
| ------------------------------------------------- | ----------------------------------------------- |
| Lebih sederhana, khusus untuk *filename matching* | Sangat fleksibel, untuk *pattern matching* umum |
| Simbol: `*`, `?`, `[ ]`                           | Simbol: `.`, `+`, `*`, `?`, `[ ]`, `()` dll     |
| Diproses oleh shell sebelum eksekusi perintah     | Diproses oleh program, bukan shell              |

---

## **Contoh Kombinasi Globbing dan Short-Circuit**

```bash
# Jika ada minimal 1 file .log, hapus
ls *.log >/dev/null 2>&1 && rm *.log
```

→ `&&` memastikan `rm` hanya jalan kalau `*.log` match file yang ada.

---

## **Tabel Perbandingan Globbing**

| Bahasa / Shell    | Wildcard Dasar                                     | Recursive Match                                        | Negasi                    | Ekspansi Kurung `{}` | Perlakuan jika Tidak Match      | Catatan Khusus                                          |
| ----------------- | -------------------------------------------------- | ------------------------------------------------------ | ------------------------- | -------------------- | ------------------------------- | ------------------------------------------------------- |
| **Bash**          | `*`, `?`, `[set]`                                  | `**` (aktifkan `shopt -s globstar`)                    | `[!set]`                  | `{a,b,c}`            | Default: pattern tetap          | `shopt -s nullglob` untuk hapus, `failglob` untuk error |
| **Zsh**           | Sama seperti Bash + lebih banyak simbol (`^`, `~`) | `**` aktif default                                     | `^pattern` atau `[!set]`  | `{a,b,c}`            | Default: pattern tetap          | `setopt extendedglob` untuk fitur lanjutan              |
| **PowerShell**    | `*`, `?`, `[set]`                                  | `**` (di PowerShell 7, untuk `Get-ChildItem -Recurse`) | `[!set]` di wildcard .NET | `{}` tidak ada       | Tidak match → tidak ada output  | Wildcard diproses oleh cmdlet, bukan shell              |
| **CMD (Windows)** | `*`, `?`                                           | Tidak ada                                              | Tidak ada                 | Tidak ada            | Tidak match → tampilkan pattern | Hanya untuk `dir` dan perintah internal tertentu        |
| **Lua**           | Tidak ada globbing bawaan                          | Tidak ada                                              | Tidak ada                 | Tidak ada            | N/A                             | Gunakan library `lfs` + `glob`                          |
| **Dart**          | Tidak ada globbing bawaan                          | Tidak ada                                              | Tidak ada                 | Tidak ada            | N/A                             | Gunakan package `glob` dari pub.dev                     |

---

## **Simbol Globbing POSIX / Bash / Zsh**

| Simbol   | Arti                            | Contoh           | Match                    |
| -------- | ------------------------------- | ---------------- | ------------------------ |
| `*`      | 0+ karakter kecuali `/`         | `*.txt`          | `a.txt`, `b.txt`         |
| `?`      | Tepat 1 karakter kecuali `/`    | `file?.sh`       | `file1.sh`, `fileA.sh`   |
| `[abc]`  | Tepat 1 karakter dari set       | `file[12].txt`   | `file1.txt`, `file2.txt` |
| `[a-z]`  | Tepat 1 karakter dari range     | `[a-z]*.sh`      | `app.sh`, `run.sh`       |
| `[!set]` | Tepat 1 karakter bukan dari set | `file[!0-9].txt` | `fileA.txt`              |
| `{a,b}`  | Ekspansi literal                | `{red,blue}.txt` | `red.txt`, `blue.txt`    |
| `**`     | Match rekursif (opsional)       | `**/*.md`        | Semua `.md` di subdir    |

---

## **Diagram Alur Proses Globbing**

```
Input Command (User)
       |
       v
Shell Parser
       |
       |-- Apakah ada karakter globbing? (*, ?, [], {}, **)
       |        |
       |        +-- TIDAK → Kirim argumen apa adanya ke program
       |
       +-- IYA → Lakukan pencarian file di filesystem
                 |
                 +-- Ada match? -----> YA --> Ganti pattern dengan daftar hasil --> Kirim ke program
                 |
                 +-- Tidak match? --> (Bash default: tetap tampilkan pattern)
                                        (Bash nullglob: hapus argumen)
                                        (Bash failglob: error)
                                        (Zsh default: tetap tampilkan pattern)
                                        (PowerShell: tidak ada output)
```

---

## **Contoh Implementasi di Bash (ArchLinux)**

```bash
# Aktifkan globstar untuk match rekursif
shopt -s globstar

# Cari semua file .log di semua folder
echo **/*.log

# Hapus file .tmp hanya jika ada
rm *.tmp 2>/dev/null || echo "Tidak ada file .tmp"
```

---

[1]:../pattern-matching/README.md
[2]:../wildcard/README.md
