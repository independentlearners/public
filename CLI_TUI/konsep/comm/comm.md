Istilah **"COMM"** di Arch Linux bisa merujuk pada beberapa hal yang berbeda, tergantung konteksnya. Berikut adalah tiga arti yang paling umum:

### 1. Perintah `comm` (Membandingkan File)

Ini adalah utilitas baris perintah standar dari paket **`coreutils`** yang sudah terpasang di sistem Arch Linux. Fungsinya adalah **membandingkan dua file yang sudah diurutkan (sorted) baris demi baris**.

**Cara kerja dasar:**
Secara default, `comm` menghasilkan output tiga kolom:
- **Kolom 1:** Baris yang hanya ada di file pertama.
- **Kolom 2:** Baris yang hanya ada di file kedua.
- **Kolom 3:** Baris yang sama di kedua file.

**Opsi yang sering digunakan:**
- `-1`: Sembunyikan kolom 1.
- `-2`: Sembunyikan kolom 2.
- `-3`: Sembunyikan kolom 3.
- `-12`: Hanya tampilkan baris yang sama di kedua file.

**Contoh penggunaan di Arch Linux:**
Perintah ini sangat berguna untuk membandingkan daftar paket. Misalnya, untuk melihat paket yang terinstal tapi tidak ada di grup `base`:
```bash
comm -23 <(pacman -Qqe | sort) <(expac -l '\n' '%E' base | sort)
```
Perintah di atas akan menampilkan paket yang secara eksplisit Anda instal (`-Qqe`) namun bukan bagian dari grup `base`.

> **Tips:** Jika Anda merasa sintaks `comm` sulit diingat, Arch Wiki menyarankan alternatif dari paket **`moreutils`** bernama **`combine`** yang memiliki sintaks lebih sederhana.

### 2. Paket `python-comm` (Untuk Jupyter)

Ini adalah paket Python yang tersedia di repositori resmi Arch Linux (`Extra`). Paket ini menyediakan implementasi **`comm` untuk protokol kernel Jupyter**. Ini adalah komponen yang memungkinkan komunikasi antara frontend (seperti Jupyter Notebook) dan kernel (proses yang menjalankan kode).

Jika Anda menggunakan Jupyter di Arch Linux dan mengalami masalah komunikasi, memastikan paket `python-comm` terinstal bisa menjadi solusinya.

### 3. Komunikasi Serial (COM Port) & Minicom

Dalam konteks perangkat keras, "COMM" sering dikaitkan dengan **port serial (COM port)**. Arch Linux dapat dikonfigurasi untuk diakses melalui **serial console**, misalnya untuk mengelola server headless (tanpa monitor/keyboard).

Untuk berkomunikasi melalui port serial, Anda bisa menggunakan program seperti **Minicom**. Minicom adalah program terminal emulator dan kontrol modem berbasis teks yang tersedia di repositori Arch Linux. Alat ini berguna untuk:
- Mengakses komputer lain melalui kabel serial (misalnya saat jaringan LAN mati).
- Berkomunikasi dengan perangkat seperti switch, router, atau Arduino.

**Kesimpulan:** Jika yang Anda maksud adalah **perintah terminal**, maka `comm` adalah alat untuk membandingkan file. Jika terkait **pemrograman Jupyter**, itu adalah paket `python-comm`. Dan jika terkait **perangkat keras serial**, itu merujuk pada komunikasi via COM port yang bisa diakses dengan Minicom.

Perintah:

```bash
ps -p $$ -o pid,ppid,comm,args
```

Artinya: **tampilkan informasi proses untuk shell yang sedang menjalankan perintah ini**, dengan kolom PID, PPID, nama perintah, dan command line lengkapnya.

Rinciannya:

- `ps` → perintah untuk melihat daftar proses.
- `-p $$` → pilih proses dengan PID sama dengan `$$`.
  - `$$` adalah variabel khusus shell yang berisi **PID dari shell saat ini**.
  - Jadi `ps -p $$` artinya “lihat proses shell yang sedang aktif ini”.
- `-o pid,ppid,comm,args` → tentukan format output:
  - `pid` → Process ID dari shell tersebut.
  - `ppid` → Parent Process ID, yaitu PID proses induk yang menjalankan shell.
  - `comm` → nama command/executable, misalnya `bash`, `zsh`, atau `fish`.
  - `args` → command line lengkap beserta argumennya.

Contoh output kira-kira:

```text
  PID  PPID COMMAND         COMMAND
 5678  1234 bash            bash
```

Atau jika shell dijalankan dengan argumen tertentu, kolom `args` bisa menunjukkan hal seperti:

```text
  PID  PPID COMMAND         COMMAND
 5678  1234 bash            /bin/bash script.sh
```

Jadi, maksud perintah itu adalah:

> “Tampilkan PID, PPID, nama program, dan command line lengkap dari shell yang sedang saya gunakan sekarang.”

Biasanya dipakai untuk debugging, misalnya ingin tahu PID shell, proses induknya, atau bagaimana shell tersebut dipanggil.

# Lebih lanjut

Sedang menjalankan percobaan di sandbox (Ubuntu + procps-ng) untuk memverifikasi perilaku `pid`, `ppid`, `comm`, dan `args` sebelum penjelasannya saya susun. Berikutnya: ronde pertama percobaan.Ronde pertama selesai dan hasilnya konsisten dengan teori. Sekarang ronde kedua: argumen, rename `comm`, proses yatim, zombie, parsing `/proc/PID/stat`, dan opsi `ps`.Semua hasil sesuai prediksi, dan ada satu temuan penting: `echo` menambahkan newline yang ikut tersimpan ke `comm`. Saya ulang dengan `printf`, lalu menguji opsi `ps` dan skrip silsilah.Ada dua verifikasi tambahan yang ingin saya pastikan sebelum menulis: konvensi `-` pada `argv[0]` (login shell) dan sumber field di `/proc/PID/status`.Empat kata ini adalah *keyword format* untuk `ps -o`. Masing-masing menjawab satu pertanyaan tentang sebuah proses: siapa saya, siapa yang melahirkan saya, nama pendek apa yang dicatat kernel untuk saya, dan bagaimana saya dipanggil. Memahami keempatnya sampai ke akar berarti memahami `fork`/`exec`, fondasi dari setiap perintah yang Anda jalankan di shell.

**Metode.** Semua keluaran di bawah adalah hasil nyata dari percobaan di lingkungan uji saya (Ubuntu 24.04, procps-ng 4.0.4, Bash 5.2.21, kernel Linux 6.18). Angka PID di mesin Anda pasti berbeda, yang harus sama adalah polanya. Biasakan **prediksi dulu, jalankan kemudian**: otak yang menebak lalu dikoreksi kenyataan membangun model mental jauh lebih kokoh daripada yang hanya membaca.

**Sumber.** Keempat keyword ini milik kernel Linux dan `ps` (procps-ng), bukan fitur Bash. Karena itu manual Bash saya tautkan untuk sisi Bash (`$$`, `$PPID`, `$BASHPID`, `$!`, `$0`, subshell, pipeline, `exec`), dan man page Arch untuk sisi kernel dan `ps`. Jangkar bagian manual saya verifikasi pada salinan [CWRU](https://tiswww.case.edu/php/chet/bash/bashref.html) (Bash 5.3). Strukturnya sama di versi [GNU](https://www.gnu.org/software/bash/manual/bash.html).

---

## 0. Peta besar

| Keyword | Pertanyaan yang dijawab | Pemilik data | Bisa berubah selama proses hidup? |
|---|---|---|---|
| `pid` | Siapa saya? | Kernel | Tidak, tetap bahkan setelah `exec` |
| `ppid` | Siapa yang melahirkan saya? | Kernel | Ya, hanya lewat *re-parenting* saat induk mati |
| `comm` | Nama pendek apa yang dicatat kernel? | Kernel (diisi saat `exec`) | Ya, oleh `exec` atau oleh proses itu sendiri |
| `args` | Bagaimana saya dipanggil? | Proses itu sendiri (memori `argv`) | Ya, oleh `exec` atau proses menimpa `argv`-nya |

`pid` dan `ppid` adalah fakta yang dijamin kernel, `comm` adalah label, `args` adalah pengakuan proses. Tingkat kepercayaan ini menjadi benang merah seluruh pembahasan.

---

## 1. Fondasi: program, proses, dan tiga kata kerja

**Program** adalah berkas di disk (misalnya `/usr/bin/ls`). **Proses** adalah eksekusi hidup program itu, dengan nomor identitas, memori, file descriptor, dan induk. Proses baru lahir lewat dua langkah terpisah:

- **`fork()`** mengkloning proses pemanggil. Anak adalah salinan persis: `comm` dan `args` sama, hanya `pid` yang baru dan `ppid` = pid induk.
- **`execve()`** mengganti *isi* proses dengan program lain **tanpa membuat proses baru**. `pid` dan `ppid` tetap, `comm` dan `args` diganti.
- **`wait()`** adalah induk menuai status keluar anak. Tanpa ini, anak yang sudah selesai menjadi zombie (§3.4).

| Peristiwa | pid | ppid | comm | args |
|---|---|---|---|---|
| `fork()` (pada anak) | **baru** | = pid induk | salinan | salinan |
| `execve()` | tetap | tetap | **diganti** | **diganti** |
| Induk mati lebih dulu | tetap | **berubah** | tetap | tetap |
| Proses mengganti nama thread | tetap | tetap | **berubah** | tetap |
| Proses menimpa memori `argv` | tetap | tetap | tetap | **berubah** |

Saat Anda mengetik `ls`, Bash melakukan *fork*, anaknya melakukan *exec* `ls`, lalu Bash *wait*. Subshell adalah *fork tanpa exec*. Buktikan dengan percobaan **E0**:

```bash
#!/usr/bin/env bash
echo "A  induk (skrip):"
ps -o pid,ppid,comm,args -p $$
echo
(
  echo "B  anak setelah fork, sebelum exec:"
  ps -o pid,ppid,comm,args -p "$BASHPID"
  echo
  echo "C  anak yang sama setelah exec:"
  exec ps -o pid,ppid,comm,args -p "$BASHPID"
)
```

```
A  induk (skrip):
  PID  PPID COMMAND         COMMAND
  268   267 bash            bash ./e0_fork_exec.sh

B  anak setelah fork, sebelum exec:
  PID  PPID COMMAND         COMMAND
  270   268 bash            bash ./e0_fork_exec.sh

C  anak yang sama setelah exec:
  PID  PPID COMMAND         COMMAND
  270   268 ps              ps -o pid,ppid,comm,args -p 270
```

**Cara membaca.** A→B: PID baru (270), PPID = 268 (PID induk), `comm` dan `args` identik, itulah *fork*. B→C: PID 270 dan PPID 268 tidak berubah, tetapi `comm` dan `args` berganti, itulah *exec*. Dua kolom berjudul `COMMAND` adalah jebakan label: yang kiri `comm`, yang kanan `args` (cara menamai ulang ada di §7).

**Bedah kata per kata:**
- `ps` membaca `/proc` dan mencetak tabel proses.
- `-o` adalah *output format*, yaitu kolom buatan sendiri.
- `pid,ppid,comm,args` adalah satu argumen, dipisah koma tanpa spasi (spasi akan dipecah shell).
- `-p` memilih proses berdasarkan PID.
- `"$BASHPID"` adalah PID proses Bash yang sedang berjalan. Di dalam `( )` isinya PID subshell, bukan skrip.
- `( … )` membuat subshell, yaitu fork tanpa exec.
- `exec` adalah builtin yang mengganti proses saat ini menjadi `ps`. Opsi terkaitnya: `-a nama` (set `argv[0]`), `-l` (awali `argv[0]` dengan `-`), `-c` (lingkungan kosong).

Rujukan: [Executing Commands](https://www.gnu.org/software/bash/manual/bash.html#Executing-Commands) · [Command Search and Execution](https://www.gnu.org/software/bash/manual/bash.html#Command-Search-and-Execution) · [Grouping Commands](https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping) · [Bourne Shell Builtins (`exec`)](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins) · [fork(2)](https://man.archlinux.org/man/fork.2) · [execve(2)](https://man.archlinux.org/man/execve.2) · [wait(2)](https://man.archlinux.org/man/wait.2)

---

## 2. PID: "Siapa saya?"

**Definisi.** PID adalah bilangan bulat positif yang unik di antara proses hidup dalam satu *PID namespace*. Kernel menugaskannya saat `fork`/`clone`, dan ia tidak berubah selama proses hidup. Di `/proc/<pid>/` setiap proses punya direktori sendiri, dan `/proc/self` selalu menunjuk ke proses yang sedang membacanya.

```bash
grep -E '^(Name|Tgid|Pid|PPid|NSpid|Threads):' /proc/$$/status
```
```
Name:	bash
Tgid:	392
Pid:	392
PPid:	389
NSpid:	392
Threads:	1
```
- `Tgid` adalah "PID" menurut pengguna (ID *thread group*), sedangkan `Pid` adalah ID *thread* (TID) di sisi kernel. Pada proses satu thread keduanya sama. Dengan `ps -L` Anda melihat tiap thread, kolom `nlwp` menghitung jumlahnya.
- `NSpid` memuat satu angka per level PID namespace. Di dalam container isinya beberapa angka, angka paling kiri adalah pandangan namespace tempat procfs dipasang.
- `grep -E` memakai regex *extended*, dan `^(…|…):` mencocokkan awal baris.

**Alokasi: berurutan dan melingkar.** Percobaan **E11**:
```bash
for i in 1 2 3 4 5; do /bin/true & printf '%s ' "$!"; done; echo; wait
```
```
359 360 361 362 363
```
Kernel membagikan PID naik satu per satu. Setelah menyentuh `pid_max`, penomoran berputar kembali ke angka rendah (kernel menyisihkan sekitar 300 PID pertama untuk proses awal boot). Cek batasnya dengan `cat /proc/sys/kernel/pid_max` (di lingkungan uji 32768). Batas ini berlaku untuk **proses dan thread sekaligus**, karena TID berbagi ruang penomoran yang sama.

**PID bernilai khusus:**
- **0** adalah *idle/swapper*, tidak tampil di `ps`. Ia dianggap induk PID 1 dan PID 2: pada `ps` keduanya berPPID `0`.
- **1** adalah init (`systemd` di Arch), leluhur seluruh proses userland.
- **2** adalah `kthreadd`, induk semua kernel thread (§3.5).

**PID di dalam Bash** (percobaan **E1**):

| Variabel | Isi | Di dalam subshell |
|---|---|---|
| `$$` | PID shell utama | **tetap** PID shell utama |
| `$BASHPID` | PID proses Bash yang sedang berjalan | **berubah** (PID subshell) |
| `$!` | PID job latar terakhir | — |
| `$PPID` | PPID shell utama (readonly) | **tetap**, tidak ikut berubah |
| `$0` | nama skrip, atau `argv[0]` shell | — |

```bash
#!/usr/bin/env bash
echo "\$\$      = $$"
echo "\$BASHPID = $BASHPID"
echo "\$PPID    = $PPID"
echo "--- di dalam subshell ( ... ) ---"
(
  eu=$BASHPID
  echo "\$\$      = $$"
  echo "\$BASHPID = $BASHPID"
  echo "\$PPID    = $PPID"
  echo "PPid asli = $(awk '/^PPid:/{print $2}' /proc/$eu/status)"
)
```
```
$$      = 278
$BASHPID = 278
$PPID    = 267
--- di dalam subshell ( ... ) ---
$$      = 278
$BASHPID = 279
$PPID    = 267
PPid asli = 278
```
**Temuan:** di dalam subshell `$$` tetap 278 dan `$PPID` tetap 267. Orang tua *sebenarnya* subshell adalah 278 (terbaca dari `/proc`). `$PPID` hanya benar untuk shell utama.

**Bedah kata per kata:**
- `\$\$` adalah backslash yang menetralkan `$` sehingga `$$` tercetak apa adanya.
- `eu=$BASHPID` dicatat **sebelum** `$(…)`, karena command substitution adalah fork baru dan `$BASHPID` di dalamnya akan berisi PID substitusi itu sendiri.
- `awk '/^PPid:/{print $2}'` mencetak kolom ke-2 pada baris yang diawali `PPid:`.

**Bahaya PID reuse.** PID yang sudah selesai bisa dipakai ulang oleh proses lain. `kill "$pid"` yang tertunda bisa menembak proses yang salah, dan `kill -0` hanya membuktikan *ada proses* ber-PID itu, bukan bahwa itu proses Anda. Identitas yang andal adalah pasangan **(PID, waktu mulai)**: lihat `ps -o pid,lstart,etimes,comm -p PID`, atau kolom ke-22 (`starttime`) di `/proc/PID/stat`. Solusi modern: **pidfd** (`pidfd_open(2)`, Linux ≥ 5.3).

Rujukan: [Special Parameters (`$$`, `$!`, `$0`)](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters) · [Bash Variables (`BASHPID`, `PPID`)](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables) · [proc(5)](https://man.archlinux.org/man/proc.5) · [pid_namespaces(7)](https://man.archlinux.org/man/pid_namespaces.7) · [pidfd_open(2)](https://man.archlinux.org/man/pidfd_open.2)

---

## 3. PPID: "Siapa yang melahirkan saya?"

### 3.1 Definisi
PPID adalah PID proses yang melakukan `fork` untuk menciptakan proses ini. Seluruh sistem berbentuk **pohon**. Dari sudut pandang namespace Anda, PID 1 berPPID `0`, artinya tidak punya induk yang terlihat.

### 3.2 Konstruksi Bash mana yang melahirkan anak?

| Konstruksi | Proses baru? | Exec? | Catatan |
|---|---|---|---|
| Perintah eksternal (`ls`) | ya | ya | anak langsung shell |
| Builtin / fungsi shell | tidak | tidak | jalan di proses shell sendiri ([Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)) |
| `cmd &` | ya | ya | `$!` = PID anak ([Lists](https://www.gnu.org/software/bash/manual/bash.html#Lists)) |
| `a \| b \| c` | satu per elemen | ya | semua **bersaudara**, anak shell yang sama ([Pipelines](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)) |
| `( … )` | ya | **tidak** | `comm` dan `args` sama dengan induk |
| `$( … )` | ya | **tidak** | subshell ([Command Substitution](https://www.gnu.org/software/bash/manual/bash.html#Command-Substitution)) |
| `{ …; }` | tidak | tidak | shell yang sama |
| `exec cmd` | tidak | ya | shell *menjadi* `cmd`, PID tetap |
| `bash -c 'satu perintah'` | tidak | ya | optimasi, lihat §9 |

Percobaan **E2**:
```bash
sleep 31 & a=$!
( sleep 32; : ) & b=$!
sleep 33 | sleep 34 & c=$!
sleep 0.5
echo "skrip   : $$"
ps -o pid,ppid,comm,args --ppid $$
echo "--- cucu: anak dari subshell $b ---"
ps -o pid,ppid,comm,args --ppid $b
```
```
skrip   : 281
  PID  PPID COMMAND         COMMAND
  282   281 sleep           sleep 31
  283   281 bash            bash ./e2_anak.sh
  284   281 sleep           sleep 33
  285   281 sleep           sleep 34
  288   281 ps              ps -o pid,ppid,comm,args --ppid 281
--- cucu: anak dari subshell 283 ---
  PID  PPID COMMAND         COMMAND
  287   283 sleep           sleep 32
```
**Bacaan:**
- 282 adalah anak biasa (fork + exec).
- 283 adalah **subshell**: `comm` dan `args` identik dengan skrip (fork tanpa exec), dan ia punya anak sendiri (287, cucu).
- 284 dan 285 adalah elemen pipeline yang **bersaudara**, bukan induk-anak.
- 288 adalah `ps` sendiri, yang juga anak skrip. Pengamat ikut menjadi bagian dari sistem yang diamati.
- 286 tidak tampil karena prosesnya (kemungkinan `sleep 0.5`) sudah selesai.

**Bedah:** `( sleep 32; : )` memakai `:` (perintah kosong yang selalu sukses) agar `sleep` bukan perintah terakhir sehingga subshell tidak langsung ber-*exec*. `--ppid LIST` memilih proses yang induknya ada di LIST. Opsi terkait: `pgrep -P PID` (anak langsung), `pkill -P PID` (kirim sinyal ke semua anak).

### 3.3 Proses yatim (orphan) dan re-parenting
Jika induk mati lebih dulu, kernel mengangkat induk baru: PID 1, atau *subreaper* terdekat (proses yang menetapkan `PR_SET_CHILD_SUBREAPER`, misalnya `systemd --user` pada sesi login Arch). Percobaan **E6**:
```bash
anak=$(bash -c 'sleep 40 >/dev/null 2>&1 & echo $!')
ps -o pid,ppid,comm,args -p "$anak"
```
```
  PID  PPID COMMAND         COMMAND
  334     1 sleep           sleep 40
```
`sleep` yatim, PPID-nya kini `1` (di lingkungan uji PID 1 adalah `process_api`, di Arch umumnya `systemd`). Pengalihan `>/dev/null 2>&1` itu penting: `$(…)` menunggu **EOF pada pipa**, bukan proses berakhir, sehingga tanpa pengalihan `sleep` akan menahan pipa terbuka dan substitusi akan menggantung 40 detik.

### 3.4 Zombie: anak sudah mati, induk belum menuai
Percobaan **E7**:
```bash
bash -c 'sleep 0.2 & exec sleep 6' &
induk=$!
sleep 1
ps -o pid,ppid,stat,comm,args --ppid "$induk"
```
```
  PID  PPID STAT COMMAND         COMMAND
  344   342 Z    sleep           [sleep] <defunct>
```
Anak 344 sudah selesai, tetapi induknya (`exec sleep 6`, yang tidak pernah `wait`) belum menuai status keluarnya. Entri tabel proses tertahan: STAT `Z`, dan `args` menjadi `[sleep] <defunct>` karena `/proc/PID/cmdline` kosong. **PPID menunjuk pelakunya.** Zombie tidak bisa di-`kill` (ia sudah mati). Perbaiki induknya agar memanggil `wait` (di Bash: builtin `wait`), atau matikan induknya agar zombie diwarisi dan dituai PID 1.

### 3.5 Melihat pohon
```bash
ps -e --forest -o pid,ppid,comm,args | head -3
```
```
  PID  PPID COMMAND         COMMAND
    2     0 kthreadd        [kthreadd]
    3     2  \_ pool_workqu  \_ [pool_workqueue_release]
```
- `--forest` menggambar pohon ASCII (`\_`). Prefiksnya ikut memakan lebar kolom `comm`, itulah mengapa nama terpotong lebih pendek.
- Kernel thread tidak punya `cmdline`, sehingga `args` ditampilkan dalam kurung siku `[…]`. Anak-anak `kthreadd` berPPID `2`.
- Alat lain: `pstree -p -a -s $$` (paket `psmisc`: `-p` tampilkan PID, `-a` tampilkan argumen, `-s` tampilkan leluhur), dan `ps -H`.

Rujukan: [Command Execution Environment](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment) · [Job Control Builtins (`wait`)](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins) · [prctl(2) `PR_SET_CHILD_SUBREAPER`](https://man.archlinux.org/man/prctl.2) · [ps(1)](https://man.archlinux.org/man/ps.1)

---

## 4. COMM: "Nama pendek apa yang dicatat kernel?"

### 4.1 Definisi
`comm` adalah nama perintah milik kernel (`task_struct.comm`). Ukurannya 16 byte termasuk NUL, sehingga **maksimal 15 karakter**. Ia terbaca di `/proc/PID/comm`, baris `Name:` di `/proc/PID/status`, dan kolom ke-2 (dalam kurung) di `/proc/PID/stat`.

### 4.2 Diisi dari mana, dan dipotong di mana
Kernel mengisinya saat `execve`, dari **basename path yang diberikan ke execve** (symlink tidak di-resolve). Percobaan **E3**:
```bash
ln -sf "$(command -v sleep)" /tmp/lab/perintah_dengan_nama_sangat_panjang
/tmp/lab/perintah_dengan_nama_sangat_panjang 30 &
pid=$!
ps -o pid,comm,args -p "$pid"
cat "/proc/$pid/comm"
```
```
  PID COMMAND         COMMAND
  295 perintah_dengan /tmp/lab/perintah_dengan_nama_sangat_panjang 30
perintah_dengan
```
`comm` terpotong tepat 15 karakter (`perintah_dengan`), sedangkan `args` utuh.

**Bedah:** `ln -s` membuat tautan simbolik dan `-f` menimpa bila sudah ada. `"$(command -v sleep)"` menghasilkan path `sleep`. Di Termux ganti `/tmp` dengan `$PREFIX/tmp`.

Akibatnya pada pencarian proses:

| Perintah | Hasil nyata |
|---|---|
| `pgrep -x perintah_dengan_nama_sangat_panjang` | peringatan `pgrep: pattern that searches for process name longer than 15 characters will result in zero matches`, status keluar 1 |
| `pgrep -f perintah_dengan_nama_sangat_panjang` | `295` (mencocokkan `args`) |
| `pgrep -x perintah_dengan` | `295` |
| `pgrep -l perintah_dengan` | `295 perintah_dengan` (PID + **comm**) |
| `pgrep -a perintah_dengan` | `295 /tmp/lab/…_panjang 30` (PID + **args**) |

Maknanya: `-x` berarti cocok **persis** (tanpa `-f`, yang dicocokkan adalah `comm`), `-f` berarti cocokkan **seluruh baris perintah** (`args`), `-l` menampilkan PID dan nama, `-a` menampilkan PID dan baris perintah penuh.

### 4.3 Skrip ber-shebang: `comm` ditentukan oleh `execve` yang *terakhir*
Tiga skrip yang isinya sama (`ps -o pid,ppid,comm,args -p $$`):

| Cara menjalankan | comm | args |
|---|---|---|
| `#!/bin/bash` lalu `./s1_langsung.sh` | `s1_langsung.sh` | `/bin/bash ./s1_langsung.sh` |
| `#!/usr/bin/env bash` lalu `./s2_env.sh` | `bash` | `bash ./s2_env.sh` |
| `bash ./s3_tanpa_shebang.sh` | `bash` | `bash ./s3_tanpa_shebang.sh` |

Pada baris pertama kernel menangani `#!` dalam **satu** `execve`, dan path yang diberikan adalah path skrip, jadi `comm` = nama skrip. Pada baris kedua interpreter-nya adalah `env`, yang kemudian melakukan **`execve` kedua** untuk `bash`, sehingga `comm` direset menjadi `bash`. Itulah mengapa `pkill -x namaskrip.sh` hanya bekerja pada gaya shebang langsung, dan `pgrep -f` lebih sering diperlukan untuk skrip. (Ini juga menjelaskan mengapa `comm` skrip pada E0 tampil `bash`.)

### 4.4 `comm` bisa diganti oleh proses itu sendiri
Lewat `prctl(PR_SET_NAME)` atau menulis ke `/proc/self/comm` (hanya thread dalam proses yang sama yang boleh). Percobaan **E5b**:
```bash
printf '%s' hantu > /proc/self/comm
ps -o pid,comm,args -p $$
readlink /proc/$$/exe
```
```
  PID COMMAND         COMMAND
  367 hantu           bash ./e5b_comm_printf.sh
/usr/bin/bash
```
`comm` berganti menjadi `hantu`, tetapi `args` dan berkas eksekutabel asli tidak berubah. **Jebakan nyata:** saat saya memakai `echo hantu > /proc/self/comm`, hasilnya `hantu.` karena newline dari `echo` ikut tersimpan ke `comm`. Pakailah `printf '%s'` atau `echo -n`. Satu proses bisa punya banyak `comm`, karena tiap thread boleh bernama berbeda (lihat `ps -L -o tid,comm`). Aplikasi besar seperti browser memanfaatkannya.

Rujukan: [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts) · [Command Search and Execution](https://www.gnu.org/software/bash/manual/bash.html#Command-Search-and-Execution) · [proc(5)](https://man.archlinux.org/man/proc.5) · [prctl(2)](https://man.archlinux.org/man/prctl.2) · [pgrep(1)](https://man.archlinux.org/man/pgrep.1)

---

## 5. ARGS: "Bagaimana saya dipanggil?"

### 5.1 Definisi
`args` adalah baris perintah lengkap: `argv[0]`, `argv[1]`, …, `argv[n]`. Seluruhnya diteruskan ke `execve(path, argv[], envp[])` dan disimpan di tumpukan (stack) proses baru. Kernel memperlihatkannya di `/proc/PID/cmdline` sebagai string yang dipisah **byte NUL**, lalu `ps` mengubah NUL menjadi spasi.

### 5.2 `argv[0]` adalah kolom bebas
Percobaan **E4(a)**:
```bash
bash -c 'exec -a samaran sleep 30' &
pid=$!
ps -o pid,ppid,comm,args -p "$pid"
readlink /proc/$pid/exe
tr '\0' '\n' < /proc/$pid/cmdline | nl -ba -w2 -s': '
```
```
  PID  PPID COMMAND         COMMAND
  308   307 sleep           samaran 30
/usr/bin/sleep
 1: samaran
 2: 30
```
`comm` tetap `sleep`, `args` berkata `samaran 30`, dan berkas asli tetap `/usr/bin/sleep`. Proses itu "berbohong" lewat `argv[0]`.

**Bedah:**
- `exec -a samaran sleep 30` menjalankan `sleep 30` dengan `argv[0]` = `samaran`. Karena `exec` mempertahankan PID, `$!` dari `&` luar adalah PID `sleep` itu.
- `readlink /proc/$pid/exe` membaca tautan simbolik ke berkas yang sungguh dieksekusi.
- `tr '\0' '\n'` menerjemahkan byte NUL menjadi newline.
- `nl -ba -w2 -s': '` memberi nomor semua baris (`-ba`), lebar angka 2 (`-w2`), dengan pemisah `': '`.

Konvensi serupa: shell login diberi `argv[0]` berawalan `-`, itulah mengapa Anda melihat `-bash` di `ps`. Dengan `exec -l sleep 30` hasilnya nyata:
```
  393 sleep           -sleep 30
```
Manual Bash menyebut `-l` meniru apa yang dilakukan program `login`.

### 5.3 `ps` meratakan argumen
Percobaan **E4(b)**:
```bash
bash -c 'sleep 30; :' 'nol dengan spasi' 'argumen satu' &
pid=$!
ps -o pid,args -p "$pid"
tr '\0' '\n' < /proc/$pid/cmdline | nl -ba -w2 -s': '
```
```
  PID COMMAND
  314 bash -c sleep 30; : nol dengan spasi argumen satu
 1: bash
 2: -c
 3: sleep 30; :
 4: nol dengan spasi
 5: argumen satu
```
`ps` tidak bisa memberi tahu di mana tiap argumen mulai dan berakhir. `/proc/PID/cmdline` bisa. Dua kata terakhir setelah string `-c` menjadi `$0` dan `$1` di dalam shell anak.

### 5.4 Fakta tambahan
- **Ekspansi terjadi sebelum exec.** Shell memecah kata, mengekspansi, dan membuang tanda kutip *sebelum* `execve`. Kernel dan `ps` tidak pernah melihat kutipan ([Shell Operation](https://www.gnu.org/software/bash/manual/bash.html#Shell-Operation), [Quote Removal](https://www.gnu.org/software/bash/manual/bash.html#Quote-Removal)).
- **Proses boleh menimpa memorinya sendiri**, sehingga `args` bisa menjadi judul status: `sshd: user@pts/0`, `postgres: checkpointer`, `nginx: master process`.
- **Batas.** Periksa dengan `getconf ARG_MAX` (di lingkungan uji 2097152 byte untuk total argumen + lingkungan), dan satu string maksimal 131072 byte ([execve(2)](https://man.archlinux.org/man/execve.2)). `ps` memotong sesuai lebar terminal kecuali memakai `-w` atau `-ww`.

Rujukan: [Special Parameters (`$0`)](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters) · [Invoking Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash) · [Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files) · [proc(5)](https://man.archlinux.org/man/proc.5)

---

## 6. Tiga identitas: siapa yang bisa dipercaya?

| | `exe` | `comm` | `args` |
|---|---|---|---|
| Sumber | tautan `/proc/PID/exe` ke berkas yang sungguh dieksekusi | `task_struct.comm` | memori `argv` |
| Ditentukan oleh | kernel | kernel saat `exec`, lalu boleh diganti proses | proses sepenuhnya |
| Panjang | path penuh | 15 karakter | panjang (batas `ARG_MAX`) |
| Layak dipercaya untuk keputusan keamanan? | ya | sebagian | **tidak** |

Aturan detektif: bila cerita sebuah proses tidak masuk akal, periksa `exe` lebih dulu. Di procps-ng 4.0.x `ps` punya keyword `exe` (terverifikasi pada 4.0.4):
```bash
ps -o pid,exe -p $$
```
Di Arch, `/usr/bin/sh` adalah symlink ke `bash`. Prediksikan hasil `sh -c 'readlink /proc/$$/exe; ps -o comm= -p $$'` lalu cek sendiri (§12, latihan 5).

---

## 7. Menguasai `ps -o`: kata per kata

```bash
ps -eo pid,ppid,comm,args
```
- `ps` adalah program.
- `-e` berarti semua proses (sinonim `-A`; versi BSD: `ax`).
- `o` yang menempel setelah `-e` adalah `-o`. Opsi bertipe satu huruf boleh digabung (`-eo` = `-e -o`).
- `pid,ppid,comm,args` adalah daftar kolom.

`ps` menerima tiga gaya opsi: UNIX (`-e`), BSD (`ax`, tanpa tanda minus), dan GNU (`--forest`). Terverifikasi: `ps p $$ o pid,ppid,comm,args` setara dengan `ps -p $$ -o pid,ppid,comm,args`.

| Opsi | Arti | Kaitan dengan empat keyword |
|---|---|---|
| `-e` / `-A` | semua proses | cakupan |
| `-p LIST` | pilih berdasar PID (koma/spasi) | memilih lewat `pid` |
| `--ppid LIST` | pilih proses yang induknya ada di LIST | memilih lewat `ppid` |
| `-C NAMA` | pilih berdasar nama eksekutabel persis | memilih lewat `comm` |
| `-o LIST` | kolom buatan sendiri | memilih kolom |
| `-o kol=JUDUL` | ganti judul kolom | label |
| `--no-headers` | tanpa baris judul | |
| `-f` | format penuh; kolom `CMD` berisi **args** | |
| `c` | paksa `CMD` menjadi **comm** | |
| `--forest` / `-H` | pohon ASCII / indentasi hierarki | visualisasi `ppid` |
| `-L` | tampilkan thread (`LWP`, `NLWP`) | `pid` vs `tid` |
| `-w` / `-ww` | lebar lebih besar / tak terbatas | `args` panjang |
| `--sort=KEY` | urutkan, awalan `-` membalik | misal `--sort=-nlwp` |

**Judul kolom bisa Anda namai sendiri** (terverifikasi):
```bash
ps -o pid=ID -o ppid=INDUK -o comm=NAMA -o args=PERINTAH -p $$
```
```
   ID INDUK NAMA            PERINTAH
  370   364 bash            bash ./e9_ps.sh
```
Jika **semua** judul dikosongkan (`ps -o pid=,ppid=,comm=,args=`), baris header hilang. Ini sangat berguna untuk skrip: `ps -o ppid= -p "$pid"` menghasilkan angka mentah, tinggal dipotong spasinya.

**Keluarga keyword** (judul kolom terverifikasi):

| Keyword | Mengacu pada | Judul |
|---|---|---|
| `comm` | nama eksekutabel (comm) | `COMMAND` |
| `ucmd` | alias bergaya comm | `CMD` |
| `fname` | varian lama (8 byte pertama nama eksekutabel) | `COMMAND` |
| `args` | baris perintah penuh | `COMMAND` |
| `cmd` | alias args | `CMD` |
| `command` | alias args | `COMMAND` |

Jadi `CMD` bisa berisi `comm` atau `args` tergantung tata letaknya. Pastikan dengan melihat isinya, bukan judulnya. `ps` tanpa opsi menampilkan `comm`, `ps -f` menampilkan `args`.

Rujukan: [ps(1)](https://man.archlinux.org/man/ps.1) · [pgrep(1)](https://man.archlinux.org/man/pgrep.1)

---

## 8. Capstone: `silsilah.sh`, menelusuri leluhur proses (Bash murni)

Menyatukan seluruh isi bahasan ini: PPID dibaca dari `/proc`, tanpa `ps`, tanpa proses tambahan.

```bash
#!/usr/bin/env bash
# silsilah.sh — telusuri leluhur sebuah proses sampai ke akar
pid=${1:-$$}

printf '%8s %8s  %s\n' PID PPID COMM
while (( pid > 0 )) && [[ -r /proc/$pid/status ]]; do
    comm=$(< "/proc/$pid/comm")
    while IFS=$': \t' read -r kunci nilai _; do
        [[ $kunci == PPid ]] && { ppid=$nilai; break; }
    done < "/proc/$pid/status"
    printf '%8d %8d  %s\n' "$pid" "$ppid" "$comm"
    pid=$ppid
done
```
```
     PID     PPID  COMM
     387      364  bash
     364        1  sh
       1        0  process_api
```

**Bedah kata per kata:**
- `pid=${1:-$$}`: jika argumen pertama kosong atau tidak ada, pakai `$$` (PID sendiri) ([Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)).
- `printf '%8s %8s  %s\n'`: `%8s` adalah string rata kanan selebar 8, `%s` string biasa, `\n` newline.
- `while (( pid > 0 )) && [[ -r /proc/$pid/status ]]`: dua penjaga. Yang pertama menghentikan loop di akar (0 = tak ada induk). Yang kedua menghentikannya bila entri `/proc` tak terbaca, baik karena prosesnya keburu hilang (*race*) maupun karena disembunyikan sistem (§10).
- `comm=$(< "/proc/$pid/comm")`: bentuk `$(< berkas)` membaca berkas tanpa menjalankan `cat`, menurut manual lebih cepat ([Command Substitution](https://www.gnu.org/software/bash/manual/bash.html#Command-Substitution)).
- `IFS=$': \t' read -r kunci nilai _`: `IFS` hanya berlaku untuk perintah `read` itu. `$': \t'` (ANSI-C quoting) berisi titik dua, spasi, dan tab. `-r` mematikan interpretasi backslash. Baris `PPid:<TAB>364` terpecah menjadi `kunci=PPid`, `nilai=364`, sisanya ke `_` ([Word Splitting](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)).
- `[[ $kunci == PPid ]] && { ppid=$nilai; break; }`: `{ …; }` berjalan di shell yang sama, sehingga `ppid` bertahan. Kalau diganti `( … )`, penugasan akan hilang bersama subshell ([Grouping Commands](https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping)). `break` keluar dari loop `read` terdalam.
- `pid=$ppid`: naik satu generasi, dan loop selalu berhenti karena rantai induk berhingga dan berujung di 0.

---

## 9. Jebakan yang harus Anda hafal di luar kepala

1. **`bash -c 'satu perintah'` melakukan exec tanpa fork**, sehingga `$$` menjadi PID perintah itu sendiri (percobaan **E10**):
   ```bash
   bash -c 'ps -o pid,ppid,comm -p $$'
   bash -c 'ps -o pid,ppid,comm -p $$; true'
   ```
   ```
     PID  PPID COMMAND
     355   354 ps
     PID  PPID COMMAND
     356   354 bash
   ```
   `$$` dievaluasi sebelum exec, lalu PID yang sama dipakai `ps`.
2. **Mem-parsing `/proc/PID/stat` dengan `awk '{print $4}'`.** `comm` ada dalam kurung dan boleh mengandung spasi serta kurung (percobaan **E8**):
   ```bash
   cp "$(command -v sleep)" "/tmp/lab/nama (aneh) x"
   "/tmp/lab/nama (aneh) x" 30 &
   pid=$!
   cut -c1-48 "/proc/$pid/stat"
   awk '{print $4}' "/proc/$pid/stat"
   stat=$(<"/proc/$pid/stat"); rest=${stat##*) }; set -- $rest
   echo "PPID = $2 (state = $1)"
   ```
   ```
   349 (nama (aneh) x) S 346 306 0 0 -1 4194304 109
   x)
   PPID = 346 (state = S)
   ```
   Cara naif memberi `x)`. Solusinya `${stat##*) }`: `##` membuang awalan **terpanjang** yang cocok dengan pola `*) `, sisanya mulai dari `state`, lalu `set -- $rest` (sengaja tanpa kutip) membelahnya ke `$1`, `$2`, dan seterusnya.
3. **`pgrep -x` untuk nama lebih dari 15 karakter** tidak akan pernah cocok (§4.2). Pakai `-f`.
4. **`ps | grep nama` menemukan `grep` itu sendiri.** Pakai `pgrep`. Waspadai juga `pgrep -f`/`pkill -f`: shell induk yang baris perintahnya memuat pola yang sama (misalnya `ssh host 'pkill -f pola'`) bisa ikut tercocokkan.
5. **`$$` dan `$PPID` di subshell** menunjuk shell utama (§2).
6. **`echo > /proc/self/comm`** menyisipkan newline ke `comm` (§4.4).
7. **PID reuse**: jangan simpan PID mentah untuk dipakai berjam-jam kemudian (§2).
8. **Jangan mengambil keputusan keamanan dari `args`.** Gunakan `exe`.

---

## 10. Arch Linux vs Termux

| Aspek | Arch Linux | Termux |
|---|---|---|
| Paket `ps` | `procps-ng` (ps, pgrep, pkill), `psmisc` (pstree) | `procps` dan `psmisc`; pastikan `ps --version` menyebut *procps-ng*, karena `/system/bin/ps` bawaan Android punya keyword berbeda |
| Visibilitas proses | semua proses (kecuali `/proc` dipasang dengan `hidepid`) | Android modern membatasi `/proc`; umumnya hanya proses milik UID Termux yang tampak |
| Akar pohon | PID 1 = `systemd`; yatim diadopsi PID 1 atau `systemd --user` | PID 1 milik Android dan biasanya tak terlihat; `silsilah.sh` berhenti di batas yang terlihat |
| `pid_max` | `cat /proc/sys/kernel/pid_max` (umumnya besar di distro systemd) | ditentukan kernel perangkat; cek sendiri |
| Shebang dan `/tmp` | `#!/usr/bin/env bash` dan `/tmp` normal | tidak ada `/usr/bin/env` maupun `/tmp` bawaan Android; pakai `termux-fix-shebang` dan `$PREFIX/tmp` |
| systemd | `systemctl status` menampilkan `Main PID: N (comm)`, jadi `comm` hadir juga di sana | tidak ada systemd |

---

## 11. Cakrawala ke depan

- **pidfd** (`pidfd_open(2)`, Linux ≥ 5.3): pegangan stabil ke sebuah proses yang kebal terhadap PID reuse.
- **Namespace dan container:** PID yang Anda lihat bergantung pada namespace, dan "masalah PID 1" di container lahir dari tugas init ini ([pid_namespaces(7)](https://man.archlinux.org/man/pid_namespaces.7)).
- **Process group, sesi, dan job control:** `pgid`, `sid`, `tty` adalah sumbu berikutnya setelah `ppid`. Topik lanjutannya adalah [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control) dan [Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals).
- **cgroup:** silsilah `ppid` tidak cukup untuk mengelompokkan proses lintas keturunan. systemd memakai cgroup untuk itu ([cgroups(7)](https://man.archlinux.org/man/cgroups.7)).
- **Melihat fork/exec langsung (opsional):** `strace -f -e trace=process bash -c 'ls >/dev/null; echo selesai'` (di Arch: `sudo pacman -S strace`; di Termux: `pkg install strace`). Saya belum menjalankannya karena `strace` tidak terpasang di lingkungan uji saya, jadi saya tidak menyajikan keluarannya. Tanda `;` mencegah optimasi satu-perintah (§9, butir 1). Cari baris `clone` (lahirnya anak), `execve` (pergantian isi), dan `wait4` (penuaian).

---

## 12. Uji pemahaman

Jelaskan dengan kata-kata Anda sendiri, dan **prediksi sebelum menjalankan**:

1. Mengapa `PID` dan `PPID` identik pada baris B dan C di E0, tetapi `comm` dan `args` berubah? Apa yang dilakukan kernel pada masing-masing langkah?
2. Mengapa `comm` sebuah skrip ber-`#!/usr/bin/env bash` tampil `bash`, sedangkan skrip ber-`#!/bin/bash` tampil sebagai nama skripnya?
3. `pkill -x nama_proses_yang_sangat_panjang` tidak membunuh apa pun. Jelaskan penyebabnya dan dua cara memperbaikinya.
4. Jalankan `silsilah.sh` dari dalam `bash -c '…; true'`, dari dalam `( … )`, dan dari ujung sebuah pipeline. PID mana yang muncul di setiap kasus, dan mengapa?
5. Di Arch, prediksi lalu jalankan `sh -c 'readlink /proc/$$/exe; ps -o comm= -p $$'`. Mengapa dua baris keluarannya berbeda?
6. Buatlah zombie sendiri (E7), temukan induknya hanya dari `PPID`, lalu hapus zombie itu tanpa reboot.

Kirimkan jawaban Anda, terutama nomor 1 dan 2, dan saya akan menguji dan meluruskan model mentalnya. Itulah cara tercepat membuat `fork` dan `exec` melekat sebagai naluri.
