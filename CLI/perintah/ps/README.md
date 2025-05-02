# ps

#### Penjelasan lebih dalam tentang perintah `ps`, mencakup konsep dan teknik lanjutan yang lebih detail yang mungkin dapat memperkuat sebuah pemahaman tentang fleksibilitas dan kekuatan `ps`.

---

### **1. Perbedaan Sintaksis: BSD vs UNIX (GNU)**

Perintah `ps` memiliki dua gaya penulisan opsi yang berbeda, tergantung pada sistem:

- **BSD Style** (tanpa tanda `-`):  
  Contoh: `ps aux`, `ps axo pid,comm`.
- **UNIX/GNU Style** (dengan tanda `-`):  
  Contoh: `ps -e`, `ps -eo pid,cmd`, `ps --forest`.

**Catatan:**  
Di Linux (termasuk Arch Linux), `ps` mendukung **kedua gaya** tersebut, tetapi kombinasi keduanya (misal: `ps aux -o pid`) bisa menyebabkan konflik. Pastikan konsistensi gaya penulisan.

---

### **2. Kode Status Proses (STAT) Lengkap**

Kolom `STAT` menunjukkan status proses dengan kombinasi kode. Berikut daftar lengkapnya:

| Kode                         | Arti                                                                  |
| ---------------------------- | --------------------------------------------------------------------- |
| `R`                          | Running atau Runnable (proses aktif atau dalam antrian CPU).          |
| `S`                          | Interruptible Sleep (menunggu event, bisa dihentikan).                |
| `D`                          | Uninterruptible Sleep (biasanya menunggu I/O, tidak bisa dihentikan). |
| `Z`                          | Zombie (proses anak yang telah selesai, tetapi belum di-reap).        |
| `T`                          | Stopped (dijeda oleh signal seperti `SIGSTOP`).                       |
| `t`                          | Tracing stop (proses sedang di-debug, e.g., dengan `gdb`).            |
| `X`                          | Dead (proses yang sudah mati dan tidak bisa dijalankan ulang).        |
| `I`                          | Idle (proses kernel thread yang tidak aktif).                         |
| **Tambahan** (kode sekunder) |
| `<`                          | Proses dengan prioritas tinggi (nice value negatif).                  |
| `N`                          | Proses dengan prioritas rendah (nice value positif).                  |
| `L`                          | Memiliki pages locked di memori (untuk real-time atau kernel).        |
| `s`                          | Session leader (proses yang memimpin sesi terminal).                  |
| `l`                          | Multi-threaded (menggunakan CLONE_THREAD, seperti thread NPTL).       |
| `+`                          | Proses berada di **foreground group** dari terminal.                  |

Contoh kombinasi:

- `Ss`: Proses sleeping (S) dan session leader (s).
- `R+`: Proses running (R) di foreground (+).
- `D<`: Proses dalam uninterruptible sleep (D) dengan prioritas tinggi (<).

---

### **3. Format Output Kustom**

Anda bisa menentukan kolom yang ingin ditampilkan dengan opsi `-o` atau `--format`.  
**Contoh:**

```bash
ps -eo pid,ppid,user,ni,pri,pcpu,pmem,stat,cmd --sort=-pcpu
```

- **Penjelasan Kolom Tambahan:**
  - `ppid`: Parent Process ID.
  - `ni`: Nice value (prioritas user-space).
  - `pri`: Priority (prioritas kernel-space).
  - `pcpu`: Persentase penggunaan CPU.
  - `pmem`: Persentase penggunaan memori.

**Daftar Kolom Lengkap:**  
Lihat daftar lengkap dengan:

```bash
ps L
```

---

### **4. Menampilkan Thread dan Proses Hierarchy**

- **Thread (LWP - Lightweight Processes):**  
  Gunakan `-L` untuk melihat thread:

  ```bash
  ps -eLf  # Menampilkan thread dengan format penuh.
  ps -o pid,lwp,comm -L  # Menampilkan PID, LWP (Thread ID), dan perintah.
  ```

- **Hierarki Proses (Parent-Child):**
  ```bash
  ps axjf  # Format pohon dengan PPID (Parent PID) dan PGID (Process Group ID).
  ps -eo pid,ppid,cmd --forest  # Tampilan hierarki berbasis PPID.
  ```

---

### **5. Informasi Keamanan dan Kontrol Akses**

- **SELinux Context:**

  ```bash
  ps -eZ  # Menampilkan konteks keamanan SELinux.
  ```

  Contoh output:

  ```
  LABEL                           PID  TTY          TIME CMD
  system_u:system_r:init_t:s0       1  ?        00:00:01 systemd
  ```

- **UID, GID, dan Grup:**
  ```bash
  ps -eo pid,user,group,supgrp  # Menampilkan grup utama dan tambahan.
  ```

---

### **6. Informasi Waktu dan Tanggal**

- **Waktu Proses Dimulai:**

  ```bash
  ps -eo pid,lstart,cmd  # Format: "Mon DD HH:MM:SS YYYY".
  ```

  Contoh output:

  ```
  PID  STARTED        CMD
  1234 Mon Jul 1 08:00:00 2023 /usr/bin/nginx
  ```

- **Waktu Total CPU:**  
  Kolom `TIME` menunjukkan total waktu CPU yang digunakan sejak proses dimulai.  
  Untuk menghitung waktu aktif (elapsed time), gunakan:
  ```bash
  ps -eo pid,etime,cmd  # etime = elapsed time (format: DD-HH:MM:SS).
  ```

---

### **7. Proses dengan Nice Value dan Prioritas**

- **Melihat dan Mengubah Nice Value:**
  ```bash
  ps -eo pid,ni,pri,comm  # ni = nice value, pri = prioritas kernel.
  ```
  - **Nice Value**: Rentang dari `-20` (prioritas tertinggi) hingga `19` (terendah).
  - **Prioritas (PRI)**: Ditentukan oleh kernel (biasanya `80 + nice value`).

---

### **8. Analisis Resource dengan `ps`**

- **Proses dengan Penggunaan CPU/Memori Tertentu:**

  ```bash
  ps -eo pid,pcpu,pmem,comm --sort=-pcpu | awk '$2 > 10 || $3 > 5'  # CPU >10% atau MEM >5%.
  ```

- **Total Penggunaan Memori oleh Semua Proses:**
  ```bash
  ps -eo pmem | awk '{sum += $1} END {print sum "%"}'
  ```

---

### **9. Integrasi Lanjutan dengan Perintah Lain**

- **Mengirim Signal ke Proses Berdasarkan Kriteria:**

  ```bash
  ps -eo pid,cmd | grep "nginx" | awk '{print $1}' | xargs kill -9
  ```

- **Monitoring Real-Time dengan `watch`:**

  ```bash
  watch -n 1 "ps -eo pid,%cpu,%mem,cmd --sort=-%cpu | head -n 10"
  ```

- **Mencari Proses yang Membuka Port Tertentu:**
  ```bash
  ps -e -o pid,cmd | grep "$(lsof -i :80 | awk 'NR>1 {print $2}')"
  ```

---

### **10. Proses Zombie dan Orphan**

- **Identifikasi Zombie:**

  ```bash
  ps -eo stat,pid,cmd | grep -w Z
  ```

- **Proses Orphan (Induk Mati):**  
  Proses yang induknya (PPID) sudah tidak ada. Cari dengan:
  ```bash
  ps -eo ppid,pid,cmd | awk '$1 == 1 {print}'  # Proses dengan PPID = 1 (systemd).
  ```

---

### **11. Proses dalam Namespace atau Container**

- **Proses dalam Container Docker:**
  ```bash
  ps -eo pid,user,cmd --forest | grep -A 2 "docker-containerd"
  ```

---

### **12. Tips Debugging**

- **Melihat Environment Variabel Proses:**

  ```bash
  ps e -o pid,cmd  # Tampilkan variabel lingkungan (kolom panjang).
  ```

- **Melihat Command Line Lengkap:**
  ```bash
  ps -ww -eo pid,cmd  # `-ww` untuk menampilkan command line tanpa truncate.
  ```

---

### **13. Perbedaan `VSZ` vs `RSS`**

- **`VSZ` (Virtual Memory Size):**  
  Total memori virtual yang dialokasikan (termasuk shared libraries).
- **`RSS` (Resident Set Size):**  
  Memori fisik yang benar-benar digunakan.
- **Contoh Analisis:**
  ```bash
  ps -eo pid,vsz,rss,comm --sort=-vsz | head -n 5
  ```

---

### **14. Daftar Opsi Penting Lainnya**

| Opsi         | Deskripsi                                               |
| ------------ | ------------------------------------------------------- |
| `-H`         | Tampilkan hierarki proses (seperti `--forest`).         |
| `-j`         | Tampilkan informasi jobs (PGID, SID).                   |
| `-M`         | Tampilkan informasi security (SELinux).                 |
| `-p <PID>`   | Fokus pada proses dengan PID tertentu.                  |
| `-T`         | Tampilkan proses yang terkait dengan terminal saat ini. |
| `--deselect` | Tampilkan semua proses kecuali yang memenuhi kondisi.   |

---

### **15. Kesimpulan Final**

Perintah `ps` adalah **alat diagnostik terkuat** untuk:

- Melacak penggunaan resource (CPU, memori, I/O).
- Debugging proses zombie, hung process, atau kebocoran memori.
- Analisis keamanan (SELinux, grup pengguna).
- Integrasi dengan skrip untuk otomatisasi sistem.
- Pemantauan real-time dan historis.

Dengan memahami semua opsi dan teknik di atas, Anda dapat menggali informasi proses di level kernel, thread, atau bahkan container, menjadikan `ps` sebagai pisau Swiss Army untuk administrasi sistem Linux.

#

### implementasi dengan perintah aux

Ini akan menampilkan **format output** dan **proses yang ditampilkan**. Berikut penjelasan rinciannya:

---

### **1. Dasar**

- **`ps` tanpa opsi**:  
  Hanya menampilkan proses yang berjalan di terminal saat ini (shell aktif).

  ```bash
  ps
  ```

  Contoh output:

  ```
    PID TTY          TIME CMD
   1234 pts/0    00:00:00 bash
   5678 pts/0    00:00:00 ps
  ```

- **`ps aux`**:  
  Menampilkan **semua proses** dari **semua pengguna**, termasuk proses yang tidak terikat terminal (background/service), dengan format output yang lebih detail.
  ```bash
  ps aux
  ```
  Contoh output:
  ```
  USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  root         1  0.0  0.1 169000 13240 ?        Ss   Jul01   0:08 /usr/lib/systemd/systemd
  ```

---

### **2. Opsi**

- **`a`**:  
  Menampilkan proses dari **semua pengguna** (bukan hanya pengguna saat ini).
- **`u`**:  
  Menampilkan output dalam format **user-friendly** (termasuk kolom seperti `%CPU`, `%MEM`, `VSZ`, `RSS`, dll).
- **`x`**:  
  Menampilkan proses **tanpa terminal** (background/service).

---

### **3. Dengan Opsi Lain**

#### a. **`ps -e` atau `ps -A`**

Menampilkan semua proses, tetapi tanpa detail seperti `ps aux`.

```bash
ps -e
```

Contoh output:

```
  PID TTY          TIME CMD
    1 ?        00:00:08 systemd
    2 ?        00:00:00 kthreadd
```

#### b. **`ps -ef`**

Menampilkan semua proses dengan format yang mirip `ps aux`, tetapi kolomnya sedikit berbeda.

```bash
ps -ef
```

Contoh output:

```
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 Jul01 ?        00:00:08 /usr/lib/systemd/systemd
```

#### c. **`ps -u username`**

Menampilkan proses dari pengguna tertentu.

```bash
ps -u root
```

#### d. **`ps -o`**

Menampilkan kolom kustom.

```bash
ps -o pid,comm,%cpu,%mem
```

Contoh output:

```
  PID COMMAND         %CPU %MEM
    1 systemd          0.0  0.1
    2 kthreadd         0.0  0.0
```

---

### **4. Kapan Menggunakan `ps aux`?**

- **Monitoring sistem**: Untuk melihat semua proses yang berjalan, termasuk yang menggunakan resource tinggi.
- **Debugging**: Untuk mencari proses yang bermasalah (zombie, hung process, dll).
- **Analisis resource**: Untuk melihat penggunaan CPU, memori, dan lainnya.

---

### **5. Kapan Menggunakan Opsi Lain?**

- **`ps -e` atau `ps -A`**: Jika hanya ingin melihat daftar PID dan nama proses.
- **`ps -ef`**: Jika ingin format yang mirip `ps aux` tetapi dengan kolom yang lebih ringkas.
- **`ps -u username`**: Jika hanya ingin melihat proses dari pengguna tertentu.
- **`ps -o`**: Jika ingin menyesuaikan kolom yang ditampilkan.

---

### **6. Kesimpulan**

- **`ps aux`** adalah opsi yang paling lengkap untuk menampilkan semua proses dengan detail resource.
- Opsi lain seperti `ps -e`, `ps -ef`, atau `ps -u` digunakan untuk kasus yang lebih spesifik.
- Pilih opsi yang sesuai dengan kebutuhan Anda: apakah Anda memerlukan detail lengkap (`ps aux`) atau hanya informasi dasar (`ps -e`).

---

### **Apa Itu `ps aux`?**

Perintah `ps aux` adalah kombinasi dari:

- `ps`: **Process Status** (utilitas untuk memantau proses)
- `a`: Tampilkan proses dari semua pengguna
- `u`: Format output yang menampilkan informasi pengguna
- `x`: Sertakan proses tanpa terminal (background processes/service)

---

### **Dasar: Output `ps aux`**

Contoh output:

```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 169316 13172 ?        Ss   Jul01   0:12 /sbin/init
...
```

**Keterangan Kolom:**

- `USER`: Pemilik proses
- `PID`: ID proses
- `%CPU`: Penggunaan CPU
- `%MEM`: Penggunaan RAM
- `VSZ`: Virtual memory size (dalam KB)
- `RSS`: Physical memory usage (dalam KB)
- `TTY`: Terminal terkait
- `STAT`: Status proses (e.g., `S`=sleep, `R`=running, `Z`=zombie)
- `TIME`: Total waktu CPU yang digunakan
- `COMMAND`: Perintah yang dijalankan

---

### **Penggunaan Lanjut dengan Kombinasi Perintah Lain**

#### 1. **Mencari Proses Spesifik (grep)**

```bash
ps aux | grep nginx  # Cari proses yang mengandung kata "nginx"
```

#### 2. **Sortir Proses Berdasarkan Penggunaan Sumber Daya (sort)**

```bash
ps aux --sort=-%cpu | head -n 10  # 10 proses dengan CPU tertinggi
ps aux --sort=-%mem | head -n 10  # 10 proses dengan RAM tertinggi
```

#### 3. **Monitoring Real-Time (watch)**

```bash
watch -n 1 "ps aux --sort=-%mem | head -n 5"  # Update setiap 1 detik
```

#### 4. **Ekstrak Kolom Tertentu (awk)**

```bash
ps aux | awk '{print $1, $2, $3, $4, $11}'  # Tampilkan USER, PID, %CPU, %MEM, COMMAND
```

#### 5. **Menghentikan Proses (kill)**

```bash
ps aux | grep chrome | awk '{print $2}' | xargs kill -9  # Kill semua proses Chrome
```

#### 6. **Cek Proses dengan PPID Tertentu**

```bash
ps -f --ppid 1234  # Tampilkan proses dengan Parent PID 1234
```

#### 7. **Analisis Penggunaan Memory (pmap)**

```bash
ps aux | grep mysql | awk '{print $2}' | xargs pmap -x  # Detail memory untuk proses MySQL
```

#### 8. **Prioritas Proses (nice/renice)**

```bash
ps aux | grep ffmpeg | awk '{print $2}' | xargs renice -n 19 -p  # Set prioritas rendah
```

#### 9. **Cek Proses yang Menggunakan Port (lsof/netstat)**

```bash
ps aux | grep $(lsof -i :80 | awk 'NR==2 {print $2}')  # Cek proses di port 80
```

#### 10. **Simpan ke File (tee)**

```bash
ps aux --sort=-%cpu | tee process_list.txt  # Simpan output ke file
```

---

### **Advanced Scripting**

#### Contoh 1: **Kill Proses Zombie**

```bash
ps aux | awk '$8=="Z" {print $2}' | xargs kill -9
```

#### Contoh 2: **Monitoring CPU/Memory dengan Threshold**

```bash
ps aux | awk '{if ($3 > 50.0) print "CPU High:", $11, $3; else if ($4 > 50.0) print "Memory High:", $11, $4}'
```

#### Contoh 3: **Cek Proses dengan Waktu CPU Terlama**

```bash
ps aux --sort=-time | head -n 5
```

---

### **Integrasi dengan Systemd (Arch Linux)**

- Cek apakah proses adalah **service**:
  ```bash
  ps aux | grep nginx && systemctl status nginx
  ```

---

### **Catatan Penting**

1. **Perbedaan `ps aux` vs `ps -aux`**:

   - `ps aux` adalah format BSD (tanpa tanda `-`).
   - Di beberapa sistem, `ps -aux` bisa merujuk ke proses user `x`, tetapi di Arch Linux, keduanya biasanya dianggap sama.

2. **Visualisasi dengan `htop`/`btop`**:

   ```bash
   sudo pacman -S htop btop  # Install di Arch Linux
   htop  # Alternatif interaktif untuk `ps aux`
   ```

3. **Debugging dengan `strace`**:
   ```bash
   strace -p $(ps aux | grep apache | awk 'NR==1 {print $2}')  # Lacak syscall proses
   ```

---

### **Kesimpulan**

`ps aux` adalah alat inti untuk:

- Identifikasi proses "resource-hungry"
- Debugging masalah sistem
- Otomatisasi task melalui scripting
- Integrasi dengan utilitas lain (`grep`, `awk`, `sort`, dll).

Di Arch Linux, pastikan paket `procps-ng` terinstall untuk fitur lengkap `ps`.

Berikut penjelasan mendetail tentang **kombinasi opsi `aux`** (tanpa perintah `ps`) dan kemampuannya dalam konteks utilitas `ps` di Linux (Arch Linux):

---

### **Pemahaman Konsep: Opsi `aux`**

Kombinasi `aux` **bukanlah perintah mandiri**, melainkan **kumpulan opsi/flags** yang digunakan bersama perintah `ps` untuk mengontrol output yang dihasilkan.  
**Opsi ini berasal dari sintaks BSD** (berbeda dengan sintaks UNIX standar yang menggunakan tanda `-`).

---

### **Dekomposisi Makna `a`, `u`, dan `x`**

#### 1. **Opsi `a` (All Users)**

- **Fungsi**: Menampilkan proses dari **semua pengguna** (tidak terbatas pada user yang sedang login).
- **Default**: Tanpa `a`, `ps` hanya menampilkan proses milik user yang menjalankan perintah.
- **Contoh Pengaruh**:
  ```bash
  ps a    # Proses dari semua user + proses dengan terminal
  ps aux  # Proses dari semua user + proses tanpa terminal
  ```

#### 2. **Opsi `u` (User-Oriented Format)**

- **Fungsi**: Menampilkan output dengan **informasi detail pengguna** (USER, %CPU, %MEM, dll).
- **Perubahan Output**:
  - Tanpa `u`: Output hanya menampilkan PID, TTY, TIME, dan COMMAND.
  - Dengan `u`: Menambahkan kolom USER, %CPU, %MEM, dan lainnya.

#### 3. **Opsi `x` (Include Non-Terminal Processes)**

- **Fungsi**: Menyertakan proses yang **tidak terikat terminal** (background services, daemon).
- **Contoh Proses**:
  - `systemd` (PID 1)
  - Web server (nginx/apache)
  - Database (postgresql/mysql)

---

### **Apa yang Bisa Dilakukan dengan Kombinasi `aux`?**

Kombinasi ini memungkinkan **pengawasan sistem secara holistik** dengan cara:

#### 1. **Melihat Seluruh Proses di Sistem**

- **Cakupan**:
  - Proses dari **semua user** (termasuk `root`).
  - Proses **background** (tanpa terminal).
  - Proses **foreground** (yang sedang berjalan di shell).

#### 2. **Identifikasi Masalah Performa**

- **Deteksi**:
  - Proses dengan **beban CPU tinggi** (kolom `%CPU`).
  - Proses yang **memakan RAM** (kolom `%MEM`).
  - Proses **zombie** (STAT = `Z`).

#### 3. **Dukungan untuk Analisis Lanjut**

- **Integrasi**: Output `ps aux` bisa diproses dengan:
  - `grep` → Filter proses spesifik.
  - `awk` → Ekstrak kolom tertentu.
  - `sort` → Urutkan berdasarkan kriteria.
  - `xargs` → Operasikan PID ke perintah lain (e.g., `kill`).

---

### **Batasan dan Skop Penggunaan**

1. **Tidak Bisa Berdiri Sendiri**:

   - `aux` **harus** digunakan dengan `ps` (tidak ada perintah bernama `aux`).

2. **Hanya Menampilkan Informasi**:

   - `aux` **tidak** bisa mengubah/mengontrol proses secara langsung (hanya untuk monitoring).

3. **Tergantung Hak Akses**:

   - Untuk melihat proses milik user lain (e.g., `root`), diperlukan izin **sudo**.

4. **Tidak Real-Time**:
   - Output `ps aux` bersifat **statis** (snapshot saat perintah dijalankan).
   - Untuk monitoring real-time, gunakan `top`, `htop`, atau `watch ps aux`.

---

### **Contoh Implementasi `aux` dalam Skenario Nyata**

#### 1. **Mencari Proses yang Menggunakan Port 80**

```bash
ps aux | grep $(sudo lsof -i :80 | awk 'NR==2 {print $2}')
```

- **Penjelasan**:
  - `lsof` mencari PID proses di port 80.
  - `ps aux` menampilkan detail PID tersebut.

#### 2. **Membandingkan Penggunaan CPU Sebelum/Sesudah**

```bash
ps aux --sort=-%cpu > before.txt
# Jalankan proses berat...
ps aux --sort=-%cpu > after.txt
diff before.txt after.txt
```

#### 3. **Membuat Laporan Pengguna RAM**

```bash
ps aux --sort=-%mem | awk '{print $1, $4, $11}' | head -n 10 > memory_report.txt
```

---

### **Kesimpulan**

Kombinasi `aux` pada perintah `ps` adalah **alat wajib** untuk:

1. **Pemantauan sistem menyeluruh**.
2. **Dasar troubleshooting performa**.
3. **Integrasi dengan pipeline Unix/Linux**.

Meskipun tidak bisa digunakan tanpa `ps`, kombinasi opsi ini adalah **fondasi untuk memahami kinerja sistem** di Arch Linux atau distribusi lainnya. Untuk kontrol lebih lanjut, kombinasikan dengan utilitas seperti `grep`, `awk`, atau `systemctl`.
