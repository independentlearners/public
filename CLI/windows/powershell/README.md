# Kesamaan dan perbedaan perintah terminal di Windows (CMD/PowerShell), Linux, dan macOS:

### **1. Kesamaan Dasar**

Linux dan macOS memiliki kesamaan tinggi karena keduanya berbasis Unix, sementara Windows (CMD/PowerShell) memiliki sintaks berbeda. Namun, ada beberapa overlap melalui alat lintas platform.

#### **Perintah yang Sama/Sinonim di Tiga OS**

| Fungsi               | Windows (CMD) | Windows (PowerShell)   | Linux/macOS  |
| -------------------- | ------------- | ---------------------- | ------------ |
| Ganti direktori      | `cd`          | `cd`                   | `cd`         |
| List direktori       | `dir`         | `Get-ChildItem`/`ls`   | `ls`         |
| Buat direktori       | `mkdir`       | `mkdir`                | `mkdir`      |
| Hapus file           | `del`         | `Remove-Item`          | `rm`         |
| Hapus direktori      | `rmdir /s`    | `Remove-Item -Recurse` | `rm -r`      |
| Salin file           | `copy`        | `Copy-Item`            | `cp`         |
| Pindahkan file       | `move`        | `Move-Item`            | `mv`         |
| Buka teks editor     | `notepad`     | `notepad`              | `nano`/`vim` |
| Lihat isi file       | `type`        | `Get-Content`/`cat`    | `cat`        |
| Cari teks dalam file | `find`        | `Select-String`        | `grep`       |

---

### **2. Perbedaan Signifikan**

#### **a. Manajemen Jaringan**

| Fungsi     | Windows (CMD) | Linux/macOS            |
| ---------- | ------------- | ---------------------- |
| Cek IP     | `ipconfig`    | `ifconfig` atau `ip a` |
| Ping       | `ping`        | `ping`                 |
| Traceroute | `tracert`     | `traceroute`           |
| DNS Lookup | `nslookup`    | `dig` atau `nslookup`  |

#### **b. Manajemen Proses**

| Fungsi              | Windows (CMD)     | Linux/macOS  |
| ------------------- | ----------------- | ------------ |
| List proses         | `tasklist`        | `ps aux`     |
| Hentikan proses     | `taskkill /PID X` | `kill X`     |
| Monitor sumber daya | `taskmgr` (GUI)   | `top`/`htop` |

#### **c. Pencarian File**

| Fungsi               | Windows (CMD)    | Linux/macOS            |
| -------------------- | ---------------- | ---------------------- |
| Cari file            | `dir /s "nama*"` | `find / -name "nama*"` |
| Cari teks dalam file | `findstr`        | `grep -r "teks"`       |

#### **d. Hak Akses (Permissions)**

| Fungsi           | Linux/macOS        | Windows (PowerShell)         |
| ---------------- | ------------------ | ---------------------------- |
| Ubah hak akses   | `chmod 755 file`   | `icacls file /grant User:RW` |
| Ubah kepemilikan | `chown user:group` | `TakeOwn /F file`            |

---

### **3. Alat Lintas Platform yang Menyamakan Pengalaman**

#### **a. Windows Subsystem for Linux (WSL)**

Memungkinkan pengguna Windows menjalankan perintah Linux (misal: `apt`, `grep`, `ssh`) secara native.  
Contoh:

```bash
wsl ls -l /mnt/c/Users
```

#### **b. PowerShell Core**

Versi cross-platform PowerShell yang bisa dijalankan di Linux/macOS:

```powershell
# Di Linux/macOS
pwsh
Get-ChildItem | Where-Object { $_.Name -match "*.txt" }
```

#### **c. Alat Universal**

Beberapa perintah/tools bekerja di semua OS:  
| Alat | Contoh Perintah | Keterangan |
|--------------------------|---------------------|--------------------------------|
| **Git** | `git clone` | Version control system |
| **Python** | `python script.py` | Bahasa pemrograman |
| **Curl** | `curl https://...` | Transfer data via URL |
| **Docker** | `docker run` | Kontainerisasi aplikasi |
| **Homebrew** | `brew install` | Package manager (macOS/Linux) |
| **Chocolatey** | `choco install` | Package manager (Windows) |

---

### **4. Tabel Perbandingan Lengkap**

#### **Operasi File**

| Operasi         | Windows (CMD)     | Linux/macOS            | PowerShell                             |
| --------------- | ----------------- | ---------------------- | -------------------------------------- |
| List file       | `dir`             | `ls -l`                | `Get-ChildItem`                        |
| Salin file      | `copy src dest`   | `cp src dest`          | `Copy-Item src dest`                   |
| Hapus direktori | `rmdir /s /q dir` | `rm -rf dir`           | `Remove-Item -Recurse -Force dir`      |
| Cari file       | `dir /s /b *.txt` | `find . -name "*.txt"` | `Get-ChildItem -Recurse -Filter *.txt` |

#### **Manajemen Paket**

| Sistem        | Windows             | Linux (Debian)              | macOS              |
| ------------- | ------------------- | --------------------------- | ------------------ |
| Install paket | `choco install pkg` | `apt install pkg`           | `brew install pkg` |
| Update sistem | `choco upgrade all` | `apt update && apt upgrade` | `brew upgrade`     |

#### **Variabel Lingkungan**

| Operasi       | Windows (CMD)   | Linux/macOS        | PowerShell           |
| ------------- | --------------- | ------------------ | -------------------- |
| Set variabel  | `set VAR=value` | `export VAR=value` | `$env:VAR = "value"` |
| Baca variabel | `echo %VAR%`    | `echo $VAR`        | `$env:VAR`           |

---

### **5. Contoh Skrip yang Bekerja di Semua OS**

#### **Bash (Linux/macOS/WSL)**

```bash
#!/bin/bash
echo "Hello from Unix-like OS!"
```

#### **PowerShell (Windows/Linux/macOS)**

```powershell
Write-Host "Hello from PowerShell!"
```

#### **Python (Universal)**

```python
import os
print(f"Hello from {os.name}!")
```

---

### **6. Kesimpulan**

- **Linux vs macOS**: 95% kompatibel karena keduanya Unix-like.
- **Windows**: Perintah native (CMD/PowerShell) berbeda, tetapi bisa disamakan dengan:
  - **WSL** untuk ekosistem Linux di Windows.
  - **PowerShell Core** untuk sintaks yang lebih Unix-like.
  - **Alat universal** (Git, Python, Docker).

Dengan alat modern seperti WSL dan PowerShell Core, gap antara Windows dan Unix-like OS semakin menyempit.

> By Deepseek
