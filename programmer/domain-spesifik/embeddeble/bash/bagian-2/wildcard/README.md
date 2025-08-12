# **1. Apa Itu Wildcard / Glob Patterns**

Wildcard (atau glob patterns) adalah **pola pencocokan nama file** yang digunakan shell (Bash, Zsh, dsb.) untuk melakukan *filename expansion* sebelum perintah dieksekusi.
⚠️ Penting: Ini bukan regex, dan pencocokan dilakukan oleh shell, **bukan oleh program**.

---

## **2. Simbol Dasar**

| Simbol | Arti                                                   | Contoh           | Hasil                        |
| ------ | ------------------------------------------------------ | ---------------- | ---------------------------- |
| `*`    | Cocokkan 0 atau lebih karakter                         | `*.txt`          | Semua file berakhiran `.txt` |
| `?`    | Cocokkan tepat 1 karakter                              | `file?.txt`      | `file1.txt`, `fileA.txt`     |
| `[ ]`  | Cocokkan satu karakter dari daftar / rentang           | `file[0-9].txt`  | `file1.txt` s/d `file9.txt`  |
| `[! ]` | Cocokkan satu karakter **bukan** dari daftar / rentang | `file[!0-9].txt` | `fileA.txt`, `fileX.txt`     |

---

## **3. Extended Globbing (Bash / Zsh)**

Aktifkan dengan:

```bash
shopt -s extglob   # Bash
setopt extendedglob # Zsh
```

| Pola         | Arti                    | Contoh      |
| ------------ | ----------------------- | ----------- |
| `?(pattern)` | 0 atau 1 kemunculan     | `?(foo)`    |                       
| `*(pattern)` | 0 atau lebih kemunculan | `*(foo bar)`|                       
| `+(pattern)` | 1 atau lebih kemunculan | `+(jpg png)`|                       
| `@(pattern)` | Tepat satu pilihan      | `@(jpg png)`|                       
| `!(pattern)` | Tidak cocok             | `!(tmp bak)`|                       

---

## **4. Perbedaan Globbing vs Pattern Matching vs Regex**

| Fitur    | Globbing                  | Pattern Matching (`[[ ]]`)                 | Regex (`=~`)                     |
| -------- | ------------------------- | ------------------------------------------ | -------------------------------- |
| Eksekusi | Di shell sebelum perintah | Di shell, tanpa akses filesystem           | Di shell atau bahasa pemrograman |
| Lingkup  | Nama file / path          | String                                     | String                           |
| Sintaks  | `*`, `?`, `[ ]`           | Sama (di shell), tapi tidak perlu ada file | `^`, `$`, `.*`, `[...]`, dll.    |
| Kekuatan | Sederhana                 | Sedang                                     | Paling fleksibel                 |

---

## **5. Contoh Bash**

```bash
# Semua .txt
echo *.txt

# File dengan satu digit angka di akhir namanya
echo file?.txt

# Semua kecuali .bak dan .tmp (butuh extglob)
shopt -s extglob
echo !(*.bak|*.tmp)
```

# **Tabel Perbandingan Wildcard (Glob Patterns) Lintas Platform - Bash/Zsh, PowerShell, dan Windows CMD**:

| Pola      | **Bash/Zsh (Linux)**                                                                           | **PowerShell**                                                  | **Windows CMD**                              |                    |
| --------- | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | -------------------------------------------- | ------------------ |
| `*`       | 0 atau lebih karakter (termasuk semua nama file kecuali yang diawali `.` tanpa opsi `dotglob`) | 0 atau lebih karakter (termasuk `.`, tapi tergantung `-Hidden`) | 0 atau lebih karakter                        |                    |
| `?`       | Tepat 1 karakter                                                                               | Tepat 1 karakter                                                | Tepat 1 karakter                             |                    |
| `[abc]`   | Salah satu karakter `a`, `b`, `c`                                                              | Salah satu karakter `a`, `b`, `c`                               | Salah satu karakter `a`, `b`, `c`            |                    |
| `[a-z]`   | Rentang karakter `a` sampai `z`                                                                | Rentang karakter `a` sampai `z`                                 | Rentang karakter `a` sampai `z`              |                    |
| `[!abc]`  | Bukan `a`, `b`, `c`                                                                            | Gunakan `[!abc]` atau `[ ^abc]`                                 | `[!abc]`                                     |                    |
| `[!a-z]`  | Bukan huruf `a` sampai `z`                                                                     | Sama                                                            | Sama                                         |                    |
| `{a,b,c}` | **Brace expansion** (hasilkan semua kombinasi, bukan pencocokan)                               | Tidak ada (gunakan `-like` dengan `*`)                          | Tidak ada                                    |                    |
| `**`      | **Recursive glob** (butuh `shopt -s globstar` di Bash)                                         | Sudah bawaan (misal `Get-ChildItem -Recurse`)                   | Tidak ada, harus pakai `dir /s`              |                    |
| `!(pat)`  | Extended glob: tidak cocok dengan `pat` (Bash/Zsh)                                             | Tidak ada langsung (pakai `-notlike`)                           | Tidak ada langsung                           |                    |
| \`@(pat1  | pat2)\`                                                                                        | Cocok persis salah satu pola                                    | Tidak ada langsung (`-like` hanya satu pola) | Tidak ada langsung |

---

## **Contoh Lintas Platform**

### **Bash/Zsh**

```bash
# Semua file .txt kecuali backup
shopt -s extglob
echo !(*.bak).txt
```

### **PowerShell**

```powershell
# Semua file .txt
Get-ChildItem *.txt

# Semua file .txt kecuali backup
Get-ChildItem *.txt | Where-Object { $_.Name -notlike "*.bak" }
```

### **Windows CMD**

```cmd
:: Semua file .txt
dir *.txt

:: Semua file .txt kecuali .bak (tidak ada langsung, pakai findstr)
dir *.txt | findstr /v ".bak"
```

---

