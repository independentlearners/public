# PID
Berikut adalah dokumentasi lengkap mengenai **PID (Process ID)** di Linux, dengan konteks penggunaan pada **Arch Linux**.

---

## 🧠 Apa Itu PID?

**PID (Process ID)** adalah **identifier unik berupa bilangan bulat non-negatif** yang diberikan oleh kernel Linux kepada setiap proses saat proses tersebut dibuat melalui system call `fork(2)`. Setiap proses dapat mengetahui PID-nya sendiri menggunakan `getpid(2)`, dan tipe data yang digunakan adalah `pid_t` yang didefinisikan di `<sys/types.h>`.

> **Penting:** PID bersifat unik **hanya selama masa hidup proses tersebut**. Setelah proses berakhir, PID dapat didaur ulang (recycle) untuk proses baru.

---

## 🎯 Tujuan PID

Tujuan utama PID adalah **mengidentifikasi proses secara unik** di dalam sistem operasi. PID digunakan dalam berbagai system call untuk menentukan proses mana yang terpengaruh oleh pemanggilan tersebut. Contoh system call yang menggunakan PID antara lain:

- `kill(2)` — mengirim sinyal ke proses
- `ptrace(2)` — debugging proses
- `setpriority(2)` — mengatur prioritas proses
- `setpgid(2)` / `setsid(2)` — mengatur process group / session
- `sigqueue(3)` — mengirim sinyal dengan data tambahan
- `waitpid(2)` — menunggu proses tertentu

---

## ⚙️ Fungsi dan Kegunaan PID

### 1. Identifikasi Proses
PID memungkinkan sistem dan pengguna untuk merujuk ke proses tertentu secara spesifik. Tanpa PID, mustahil untuk membedakan antara dua proses yang menjalankan program yang sama.

### 2. Manajemen Proses
PID digunakan untuk:
- **Menghentikan proses** (`kill <PID>`)
- **Mengubah prioritas** (`renice`)
- **Melacak penggunaan sumber daya** (CPU, memori) per proses
- **Memonitor** proses yang sedang berjalan

### 3. Hubungan Parent-Child
Setiap proses (kecuali PID 1) memiliki **PPID (Parent PID)** yang menunjukkan proses yang membuatnya melalui `fork(2)`. Proses dapat mengetahui PPID-nya dengan `getppid(2)`.

### 4. Session dan Process Group
Setiap proses juga memiliki **Session ID** dan **Process Group ID**. Ini adalah abstraksi yang mendukung job control di shell. Sebuah process group (kadang disebut "job") adalah kumpulan proses yang berbagi Process Group ID yang sama.

---

## 🔢 Nilai Maksimum PID

PID disimpan dalam tipe `pid_t`. Secara historis, nilai maksimum PID adalah **32768** (karena menggunakan `short int`). Namun, kernel Linux modern telah meningkatkan batas ini. Nilai `pid_max` saat ini dapat mencapai **4194304 (2²²)** pada sistem 64-bit modern, termasuk Arch Linux.

Anda dapat memeriksa nilai `pid_max` di Arch Linux dengan:
```bash
cat /proc/sys/kernel/pid_max
```

---

## 🔄 PID Recycling

Setelah proses berakhir, PID-nya **dapat digunakan kembali** oleh proses baru. Kernel Linux menggunakan algoritma yang cenderung **tidak langsung menggunakan kembali PID yang baru saja dibebaskan**, melainkan memilih PID yang sudah lama tidak digunakan.

> **Catatan Keamanan:** PID recycling dapat menyebabkan race condition jika sebuah program menyimpan PID dan kemudian mengirim sinyal ke PID tersebut setelah proses asli berakhir. Kernel modern menyediakan **pidfd** (`/proc/<pid>/`) sebagai handle stabil yang tidak berubah meskipun PID didaur ulang.

---

## 📂 PID di Filesystem `/proc`

Di Arch Linux (dan Linux pada umumnya), informasi setiap proses tersedia melalui **procfs** yang dimount di `/proc`. Setiap proses memiliki direktori sendiri dengan nama PID-nya.

Contoh isi `/proc/<PID>/`:
- `cmdline` — baris perintah proses
- `cwd` — symlink ke direktori kerja saat ini
- `environ` — variabel lingkungan
- `fd/` — direktori berisi file descriptor yang terbuka
- `exe` — symlink ke executable proses
- `maps` — peta memori
- `mem` — akses ke memori proses
- `stat` — status proses (digunakan oleh `ps`)

---

## 🏗️ PID Namespace (Konteks Container)

PID namespace adalah fitur kernel Linux yang **mengisolasi ruang nomor PID**. Ini berarti proses di namespace PID yang berbeda **dapat memiliki PID yang sama**.

### Karakteristik PID Namespace:
- PID dalam namespace baru **dimulai dari 1**, seperti sistem mandiri
- Proses pertama dalam namespace baru (dibuat dengan `clone(2)` + `CLONE_NEWPID` atau `unshare(2)`) menjadi **"init"** untuk namespace tersebut
- Jika proses "init" dalam namespace berakhir, kernel akan **menghentikan semua proses** di namespace tersebut dengan `SIGKILL`
- PID namespace memungkinkan **container** untuk di-suspend/resume dan dimigrasi ke host baru sambil mempertahankan PID yang sama

Di Arch Linux, PID namespace digunakan oleh **systemd-nspawn** dan alat container lainnya. Bahkan `arch-chroot` menggunakan PID namespace untuk membersihkan proses yang tersisa saat keluar dari chroot.

---

## 🏛️ PID 1 dan systemd di Arch Linux

Di Arch Linux, **systemd berjalan sebagai PID 1** — proses pertama yang dijalankan kernel saat boot. systemd bertanggung jawab untuk memulai dan memelihara layanan user-space.

### Melihat Status PID dengan systemd:
```bash
systemctl status <pid>
```
Perintah ini menampilkan status proses, termasuk cgroup slice, memori, dan proses induk.

### PID File di systemd:
Untuk layanan yang menggunakan `Type=forking`, systemd dapat menggunakan direktif `PIDFile=` untuk melacak proses utama layanan. PID file biasanya terletak di `/run/`.

---

## 🛠️ Alat Manajemen PID di Arch Linux

Arch Linux menyediakan paket **`procps-ng`** yang berisi berbagai utilitas untuk manajemen proses:

| Perintah | Fungsi |
|----------|--------|
| `ps` | Menampilkan informasi proses termasuk PID dan penggunaan sumber daya |
| `top` | Tampilan real-time dinamis dari proses yang berjalan |
| `htop` | Versi interaktif yang lebih user-friendly dari `top` (perlu diinstal) |
| `pgrep` | Mencari proses berdasarkan nama atau atribut lain |
| `pkill` | Mengirim sinyal ke proses berdasarkan nama (default: SIGTERM) |
| `kill` | Mengirim sinyal ke proses berdasarkan PID |
| `pmap` | Menampilkan peta memori proses |
| `pwdx` | Menampilkan direktori kerja saat ini dari proses |

### Contoh Penggunaan:
```bash
# Melihat semua proses dengan PID
ps aux

# Mencari PID berdasarkan nama proses
pgrep firefox

# Menghentikan proses berdasarkan PID
kill 1234

# Menghentikan proses berdasarkan nama
pkill firefox
```

---

## 📊 Ringkasan

| Aspek | Keterangan |
|-------|------------|
| **Definisi** | Identifier unik bilangan bulat non-negatif untuk setiap proses |
| **Tipe Data** | `pid_t` (biasanya `int`) |
| **Maksimum** | Hingga 4194304 (2²²) pada kernel modern |
| **Recycling** | PID dapat digunakan kembali setelah proses berakhir |
| **PID 1** | systemd (init process) di Arch Linux |
| **Namespace** | Mengisolasi ruang PID untuk container |
| **Filesystem** | `/proc/<PID>/` menyediakan informasi proses |
| **Alat Utama** | `ps`, `top`, `htop`, `pgrep`, `pkill`, `kill` |

---

Dokumentasi ini mencakup aspek fundamental hingga lanjutan PID di Linux dengan penekanan pada implementasi di Arch Linux. Untuk informasi lebih detail, Anda dapat merujuk ke halaman manual `man 7 credentials`, `man 7 pid_namespaces`, dan `man 1 pgrep`. Untuk pendalaman lebih lanjut mengenai PID, kita akan membahas beberapa aspek teknis dan lanjutan yang mungkin belum banyak tersentuh, dengan fokus pada implementasi di Arch Linux.

### 🧬 `pidfd`: Menangani PID dengan Aman

Anda mungkin sudah tahu bahwa PID bisa didaur ulang (di-*recycle*). Masalahnya, ini bisa menjadi celah keamanan. Bayangkan sebuah program menyimpan PID dari sebuah proses, lalu proses itu mati dan PID-nya digunakan oleh proses baru. Jika program tadi mengirim sinyal ke PID tersebut, sinyal itu akan salah alamat, berpotensi menyebabkan masalah keamanan (CVE).

Solusinya adalah **`pidfd` (PID file descriptor)**. Diperkenalkan pada Linux kernel v5.3, `pidfd` adalah sebuah *file descriptor* yang merujuk secara stabil ke satu proses spesifik.

*   **Cara Kerja**: `pidfd` bukan sekadar angka PID. Ini adalah *handle* yang menunjuk ke struktur `struct pid` di kernel, sehingga tetap valid meskipun PID aslinya sudah didaur ulang.
*   **Fungsi**: `pidfd` memungkinkan Anda mengirim sinyal (`pidfd_send_signal`), menunggu proses, atau melakukan operasi lain dengan aman, tanpa risiko salah sasaran.
*   **Penggunaan**: Anda bisa mendapatkan `pidfd` saat proses dibuat (dengan flag `CLONE_PIDFD` pada `clone()`) atau untuk proses yang sudah ada menggunakan system call `pidfd_open()`.

Penerapannya sudah luas, misalnya di `systemd`, `dbus`, dan `polkit`, untuk memastikan autentikasi dan manajemen proses yang aman.

### 📦 PID Namespace: Isolasi Proses di Arch Linux

Konsep PID namespace sangat penting, terutama jika Anda menggunakan container atau `systemd-nspawn` di Arch Linux.

*   **Isolasi**: PID namespace membuat ruang PID yang terisolasi. Artinya, proses di dalam namespace yang berbeda **boleh memiliki PID yang sama**.
*   **Proses Init**: Proses pertama yang dibuat dalam namespace baru akan mendapatkan **PID 1**. Proses ini menjadi "init" untuk namespace tersebut. Jika proses PID 1 ini berhenti, seluruh proses lain di namespace itu akan dihentikan paksa oleh kernel dengan sinyal `SIGKILL`.
*   **Nesting**: PID namespace bisa bersarang (*nested*). Setiap namespace memiliki induk, kecuali namespace root. Ini memungkinkan hierarki isolasi yang kompleks, seperti container di dalam container.

### ⚙️ systemd sebagai PID 1 di Arch Linux

Di Arch Linux, **systemd** berjalan sebagai **PID 1**. Ini adalah proses pertama yang dijalankan kernel setelah boot dan bertanggung jawab untuk memulai serta mengelola seluruh layanan sistem.

*   **Pelacakan Proses**: systemd tidak hanya mengelola layanan; ia juga melacak proses menggunakan **control groups (cgroups)**. Ini memungkinkannya untuk mengelompokkan dan memantau proses terkait secara efisien.
*   **Perintah Berguna**: Untuk melihat detail proses berdasarkan PID, Anda bisa menggunakan perintah `systemctl status <PID>`. Perintah ini akan menampilkan informasi seperti `cgroup slice`, penggunaan memori, dan proses induknya.

### 🔢 Batas Maksimum PID (`pid_max`)

Secara historis, jumlah maksimum PID terbatas pada 32768. Namun, kernel Linux modern telah meningkatkannya secara signifikan.

*   **Nilai Saat Ini**: Batas maksimum (`PID_MAX_LIMIT`) dapat mencapai **4.194.304 (2²²)** pada sistem 64-bit.
*   **Konfigurasi**: Anda dapat memeriksa nilai `pid_max` yang aktif di sistem Arch Linux Anda dengan perintah:
    ```bash
    cat /proc/sys/kernel/pid_max
    ```

### 🛠️ Alat Manajemen Proses di Arch Linux (`procps-ng`)

Arch Linux menyediakan paket **`procps-ng`** yang berisi berbagai utilitas penting untuk manajemen proses. Beberapa alat yang paling sering digunakan antara lain:

| Perintah | Deskripsi |
| :--- | :--- |
| `ps` | Menampilkan snapshot informasi proses, termasuk PID, penggunaan CPU, dan memori. |
| `top` | Menampilkan tampilan real-time dinamis dari proses yang berjalan di sistem. |
| `pgrep` | Mencari PID proses berdasarkan nama atau atribut lainnya. |
| `pkill` | Mengirim sinyal ke proses berdasarkan nama atau atribut lainnya (default: `SIGTERM`). |
| `pmap` | Menampilkan peta memori dari sebuah proses. |
| `pwdx` | Menampilkan direktori kerja saat ini dari sebuah proses. |


Mari kita bedah lebih dalam mengenai identifier proses di Linux, mulai dari definisi teknisnya hingga bagaimana identifier ini sering dimanfaatkan dalam konteks *offensive security* atau *hacking* (ethical hacking/pentesting). Memahami hal ini krusial, baik untuk administrasi sistem maupun untuk pertahanan.

### 🧬 Hirarki Identifier Proses: PID, PPID, PGID, SID, TGID

Setiap proses di Linux memiliki beberapa identifier yang membentuk sebuah hirarki. Hubungannya dapat digambarkan sebagai berikut:

**Session (SID) -> Process Group (PGID) -> Process (PID)**

*   **PID (Process ID)**: Identifier unik untuk setiap proses. Ini adalah kunci untuk hampir semua operasi yang menargetkan proses tertentu.
*   **PPID (Parent Process ID)**: PID dari proses yang membuat (mem-*fork*) proses ini. Setiap proses (kecuali PID 1) memiliki PPID. Melacak PPID memungkinkan kita membangun pohon proses (*process tree*) untuk melihat asal-usul sebuah program.
*   **PGID (Process Group ID)**: Sekumpulan proses yang terkait (biasanya dari satu *pipeline* perintah) yang berbagi PGID yang sama. Ini digunakan untuk distribusi sinyal dan arbitrase terminal. Proses pertama dalam grup menjadi *process group leader*, dan PID-nya menjadi PGID.
*   **SID (Session ID)**: SID mengelompokkan beberapa *process group*. Sebuah sesi biasanya dimulai saat pengguna login. Proses pertama dalam sesi menjadi *session leader*, dan PID-nya menjadi SID. Sebuah sesi dapat memiliki satu terminal kontrol (TTY).
*   **TGID (Thread Group ID)**: Di Linux, *thread* sebenarnya adalah proses ringan. **TGID adalah PID dari *thread group leader***, yang pada dasarnya adalah PID dari proses utama (seperti yang terlihat oleh pengguna). Semua *thread* dalam satu proses memiliki TGID yang sama, namun masing-masing memiliki **TID (Thread ID)** yang unik.

### 🎯 Fungsi dan Kegunaan Umum

Identifier ini adalah fondasi dari manajemen proses di Linux. Kegunaan normalnya meliputi:
*   **Kontrol Proses**: `kill` atau `pkill` menggunakan PID atau PGID untuk mengirim sinyal.
*   **Job Control**: Shell menggunakan PGID dan SID untuk mengelola *foreground* dan *background jobs*.
*   **Daemonisasi**: Program *daemon* (layanan latar belakang) menggunakan `setsid()` untuk melepaskan diri dari terminal dan menjadi *session leader* baru, memastikan mereka tidak terpengaruh saat terminal ditutup.

### 😈 Pemanfaatan oleh Hacker/Pentester

Dalam konteks *offensive security*, identifier ini bukan hanya untuk manajemen, tetapi menjadi **vektor serangan** dan **sumber informasi** yang kaya.

#### 1. Enumerasi Proses: Mencari Target yang Rentan
Langkah pertama setelah mendapatkan akses awal (*foothold*) di sebuah sistem adalah melakukan enumerasi. Penyerang akan memetakan semua proses yang berjalan beserta pemiliknya (UID) dan hubungan *parent-child*-nya (PPID).

*   **Mencari Proses Privilege**: Penyerang mencari proses yang berjalan sebagai `root` atau pengguna dengan hak istimewa tinggi. Perintah seperti `ps -eo user,pid,ppid,args` atau `pstree -alp` digunakan untuk melihat pohon proses dan menemukan target yang menjanjikan.
*   **Kredensial di Memori Proses**: Proses seperti `vsftpd`, `apache2`, atau `gnome-keyring-daemon` terkadang menyimpan kredensial di memori mereka. Penyerang dapat mencoba membaca memori proses ini (jika memiliki izin) untuk mencuri *password* atau *hash*.
*   **Proses dengan PPID Lintas Pengguna**: Salah satu temuan menarik adalah proses yang dimiliki oleh pengguna *non-root* (misalnya `www-data`) tetapi PPID-nya dimiliki oleh `root`. Ini bisa menjadi indikasi adanya program *SUID* atau *service* yang dipanggil oleh `root` untuk menjalankan proses tersebut. Penyerang dapat memeriksa proses seperti ini untuk mencari kerentanan eskalasi hak akses.

#### 2. Process Injection (T1055)
Ini adalah teknik yang sangat sering digunakan penyerang untuk mengeksekusi kode berbahaya atau mencuri data dari dalam proses yang sah.

*   **Melalui `ptrace`**: `ptrace(2)` adalah *system call* yang kuat, awalnya dirancang untuk *debugging*. Penyerang dapat menggunakan `ptrace` untuk menempel (*attach*) ke proses korban (menggunakan PID-nya), lalu memodifikasi register, memori, atau bahkan menyuntikkan *shellcode* dan menjalankannya. Alat seperti `cymothoa` memanfaatkan ini untuk membuat *backdoor* di dalam proses yang sudah berjalan.
*   **Melalui `/proc/[pid]/mem`**: Cara lain adalah dengan langsung mengakses file `mem` di direktori `/proc/<PID>/`. Penyerang dapat membaca (*read*) dan menulis (*write*) ke memori proses korban. Teknik ini, yang dikenal sebagai **Proc Memory Injection (T1055.009)**, melibatkan enumerasi *memory map* proses melalui `/proc/[pid]/maps` untuk menemukan alamat yang dapat ditulis, lalu menimpa instruksi atau data di sana dengan *payload* berbahaya.

#### 3. Session Hijacking (Pembajakan Sesi)
SID dan PGID dapat dieksploitasi untuk mengambil alih sesi pengguna lain yang memiliki hak istimewa lebih tinggi.

*   **Pembajakan `screen` / `tmux`**: `screen` dan `tmux` adalah *terminal multiplexer* yang memungkinkan sesi terminal tetap berjalan meskipun koneksi terputus. Jika seorang administrator meninggalkan sesi `tmux` atau `screen` dalam keadaan *detached* dan *socket*-nya dapat diakses oleh pengguna lain (karena salah konfigurasi izin file), penyerang dapat "menempel" (*attach*) ke sesi tersebut. Secara efektif, penyerang mendapatkan shell dengan hak akses administrator tersebut, tanpa perlu mengeksploitasi kerentanan sama sekali.

#### 4. PID Namespace dan Container Escape
PID namespace adalah fitur isolasi yang membuat container merasa seolah-olah memiliki ruang PID-nya sendiri.

*   **Isolasi**: Proses di dalam container hanya melihat PID di dalam namespace-nya, yang biasanya dimulai dari 1. Ini mencegah container melihat atau berinteraksi dengan proses di *host* atau container lain.
*   **Escape**: Namun, jika terjadi kerentanan atau salah konfigurasi, penyerang dapat keluar dari isolasi ini. Misalnya, dengan menjalankan container dengan flag `--pid=host`, container akan berbagi PID namespace dengan *host*, sehingga penyerang di dalam container bisa melihat dan berinteraksi dengan semua proses di *host*, termasuk proses `root`. Kerentanan seperti CVE-2018-6552 pada `apport` juga menunjukkan bagaimana PID namespace dapat dieksploitasi untuk keluar dari container dan mendapatkan hak akses *root*.

#### 5. PID Recycling: Kerentanan Race Condition
Seperti yang telah dibahas, PID dapat digunakan kembali. Dalam skenario yang sangat spesifik, ini bisa menjadi kerentanan.

*   **CVE-2025-4598 (systemd-coredump)**: Kerentanan ini adalah contoh klasik dari eksploitasi PID *recycling*. Penyerang dapat memaksa sebuah proses *SUID* untuk *crash*. Saat proses *crash*, `systemd-coredump` akan mencoba menganalisis file `/proc/<PID>/auxv` dari proses yang *crash* tersebut. Jika penyerang berhasil membuat PID proses *SUID* yang *crash* itu didaur ulang oleh proses *non-SUID* miliknya sebelum `systemd-coredump` sempat membacanya, maka `systemd-coredump` akan menganalisis proses milik penyerang. Dengan manipulasi lebih lanjut, penyerang dapat mengakses *core dump* dari proses *SUID* yang asli, yang mungkin berisi informasi sensitif seperti *hash* kata sandi atau kunci pribadi.

### 💎 Ringkasan

Bagi seorang *hacker* atau *pentester*, PID, PPID, PGID, dan SID bukan sekadar angka administratif. Mereka adalah **peta harta karun** yang menunjukkan:
*   **Di mana proses berjalan** dan siapa pemiliknya (target potensial).
*   **Bagaimana proses berinteraksi** (jalur eskalasi hak akses).
*   **Bagaimana cara menyusup** ke dalam proses yang sah (process injection).
*   **Bagaimana cara mengambil alih** sesi pengguna lain (session hijacking).

Memahami identifier ini secara mendalam memungkinkan penyerang untuk bergerak secara lateral, meningkatkan hak akses, dan mempertahankan akses mereka di dalam sistem dengan lebih efektif. Bagi para pembela, pengetahuan ini sangat penting untuk mendeteksi aktivitas mencurigakan, seperti proses dengan PPID yang tidak wajar, akses ke `/proc/<PID>/mem`, atau penggunaan `ptrace` yang tidak sah.
