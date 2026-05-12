**Pseudo terminal** (atau *pty*, singkatan dari *pseudo-teletype*) adalah sepasang perangkat lunak virtual dalam sistem operasi (mirip Linux/Unix) yang berfungsi meniru perilaku terminal fisik asli. Jadi `pseudo-terminal` adalah → terminal semu, terminal virtual yang meniru terminal fisik. Bayangkan Anda ingin menjalankan *shell* (seperti bash) dan berinteraksi dengannya, tetapi Anda tidak terhubung ke monitor dan keyboard sungguhan (misalnya melalui SSH, terminal emulator seperti GNOME Terminal, atau aplikasi VS Code). Di sinilah pseudo terminal berperan.

Berikut penjelasan sederhananya:

### 1. Analogi Sederhana
Terminal fisik dulu adalah monitor + keyboard yang terhubung langsung ke komputer. **Pseudo terminal** adalah "terminal palsu" yang dibuat oleh software. Ia memiliki dua ujung:
- **Ujung Master (ptm)**: Digunakan oleh program (misalnya: terminal emulator, SSH server) untuk mengirim perintah dan membaca output.
- **Ujung Slave (pts)**: Digunakan oleh program lain (misalnya: shell Bash, Python REPL) yang mengira dirinya sedang berjalan di terminal fisik.

### 2. Cara Kerja
1.  Anda membuka aplikasi **Terminal Emulator** (seperti `gnome-terminal`, `xterm`, atau `iTerm2`).
2.  Aplikasi tersebut meminta kernel untuk membuat sebuah pseudo terminal.
3.  Kernel membuat sepasang perangkat: `ptm` (master) dan `pts/123` (slave).
4.  Terminal emulator memegang sisi master, lalu menjalankan shell (misal `bash`) dan mengarahkan shell tersebut ke sisi slave (`pts/123`).
5.  Saat Anda mengetik `ls`, terminal emulator mengirim "ls" ke sisi master, kernel meneruskannya ke sisi slave, shell membaca perintah, menjalankannya, lalu mengirim hasilnya balik ke slave → master → tampil di layar Anda.

### 3. Mengapa Pseudo Terminal Penting?
Tanpa pty, semua hal modern berikut akan mustahil:
- **SSH** (Anda login ke server jarak jauh dan mendapat prompt shell).
- **Terminal di dalam GUI** (Terminator, Konsole, CMD/PowerShell modern di Windows via WSL).
- **Multiplexer** seperti `screen` atau `tmux` (yang membuat sesi terminal tetap berjalan meskipun program induknya tertutup).
- **Program yang membutuhkan TTY** (seperti `sudo`, `top`, `vim`, atau `ssh`) – mereka akan error jika tidak dijalankan di dalam pseudo terminal.

### 4. Perbedaan dengan Terminal Biasa
| Fitur | Terminal Fisik (tty) | Pseudo Terminal (pty) |
| :--- | :--- | :--- |
| **Media** | Hardware nyata (port serial, monitor) | Software virtual (dalam kernel) |
| **Contoh** | `/dev/ttyS0` (COM1) | `/dev/pts/2`, `/dev/ttyp0` |
| **Penggunaan** | Konsol lokal, perangkat embedded | SSH, terminal emulator, aplikasi GUI |

### 5. Melihatnya di Sistem Anda
Coba jalankan perintah berikut di terminal Linux:
```bash
tty
```
Outputnya akan seperti: `/dev/pts/4` (itu berarti Anda sedang berada di dalam pseudo terminal).

Kemudian, di terminal lain, jalankan:
```bash
ps aux | grep bash
```
Anda akan melihat setiap sesi bash terikat ke pts yang berbeda.

### Kesimpulan
**Pseudo terminal adalah fondasi dari semua interaksi baris perintah modern.** Ia menjebatani program antarmuka pengguna (terminal emulator, SSH client) dengan program baris perintah (shell, aplikasi CLI) tanpa memerlukan perangkat keras terminal sungguhan.


