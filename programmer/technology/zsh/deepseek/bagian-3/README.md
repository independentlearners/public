# **Materi 3 — Interactive Zsh**
Ini adalah inti dari tujuan: memahami Zsh sebagai *programmable interactive shell*, bukan sekadar bahasa scripting. Di sini kita akan membahas history, completion, ZLE, bindkey, keymap, widget, hook, autoload, dan compinit.

Jangan lompat ke `.zshrc` atau konfigurasi modular dulu. Itu Materi 4. Fokus dulu pada mekanisme interaktifnya.

---

# Materi 3 — Interactive Zsh

## 3.1 Perbedaan Shell Interaktif dan Non-Interaktif

Sebelum masuk ke ZLE, Anda harus paham dulu perbedaan fundamental ini.

### Shell Interaktif

Shell interaktif adalah shell yang membaca perintah dari terminal dan menampilkan prompt.

```zsh
[[ -o INTERACTIVE ]] && echo "ini shell interaktif"
```

Penjelasan kata demi kata:

- `[[` — awal conditional expression.
- `-o` — operator untuk memeriksa *option*.
- `INTERACTIVE` — nama option. Menyala jika shell berjalan di terminal.
- `]]` — akhir conditional.
- `&&` — jika kondisi benar, jalankan perintah berikutnya.
- `echo "ini shell interaktif"` — cetak pesan.

### Shell Non-Interaktif

Shell non-interaktif adalah shell yang menjalankan script. Tidak ada prompt, tidak ada input keyboard.

```zsh
zsh -c 'echo hello'
```

Penjelasan:

- `zsh` — jalankan Zsh.
- `-c` — opsi untuk menjalankan perintah sebagai string.
- `'echo hello'` — perintah yang dijalankan.
- Shell yang dijalankan adalah non-interaktif.

**Mengapa ini penting?**

Karena ZLE, bindkey, dan sebagian besar fitur interaktif **hanya bekerja di shell interaktif**. Jika Anda menaruh `bindkey` di script non-interaktif, tidak akan ada efek.

Karena itu, konfigurasi interaktif biasanya diletakkan di `.zshrc`, bukan `.zshenv`. Kita bahas itu di Materi 4.

---

## 3.2 History

History adalah catatan perintah yang pernah Anda jalankan. Di Zsh, history dikelola oleh builtin `fc`, `history`, dan variabel `HISTFILE`, `HISTSIZE`, `SAVEHIST`.

### Variabel History

```zsh
HISTFILE=~/.zsh_history
```

Penjelasan kata demi kata:

- `HISTFILE` — variabel yang menentukan path file history.
- `=` — operator assignment.
- `~/.zsh_history` — path. Tanda `~` akan diekspansi menjadi `$HOME` karena berada setelah `=` dalam konteks assignment.

```zsh
HISTSIZE=10000
```

Penjelasan:

- `HISTSIZE` — jumlah perintah yang disimpan di memori selama sesi berjalan.
- `10000` — angka. Semakin besar, semakin banyak perintah tersimpan di memori.

```zsh
SAVEHIST=10000
```

Penjelasan:

- `SAVEHIST` — jumlah perintah yang disimpan ke file `HISTFILE` saat shell keluar.
- Jika lebih kecil dari `HISTSIZE`, sebagian history di memori tidak akan tersimpan ke file.

### Perintah History

```zsh
history
```

Penjelasan:

- `history` — builtin Zsh yang menampilkan daftar history dengan nomor urut.
- Output berupa baris bernomor, lalu perintah.

```zsh
history 10
```

Penjelasan:

- `10` — jumlah baris terakhir yang ditampilkan.
- Output: 10 perintah terakhir.

```zsh
fc -l -10
```

Penjelasan:

- `fc` — builtin untuk *fix command*.
- `-l` — list. Menampilkan daftar.
- `-10` — 10 perintah terakhir.
- Ini adalah cara POSIX untuk melihat history.

```zsh
fc -l 100 110
```

Penjelasan:

- `100` — mulai dari nomor 100.
- `110` — sampai nomor 110.
- Menampilkan range.

### Memanggil Ulang Perintah

```zsh
!!
```

Penjelasan:

- `!!` — event designator. Mengacu pada perintah terakhir.
- Contoh: jika perintah terakhir adalah `ls -la`, maka `!!` akan menjalankan `ls -la` lagi.
- Sering digunakan sebagai `sudo !!` jika perintah sebelumnya butuh sudo.

```zsh
!$ 
```

Penjelasan:

- `!$` — argumen terakhir dari perintah sebelumnya.
- Contoh: `mkdir proyek` lalu `cd !$` akan menjalankan `cd proyek`.

```zsh
!100
```

Penjelasan:

- `!100` — jalankan perintah dengan nomor history 100.

```zsh
!ls
```

Penjelasan:

- `!ls` — jalankan perintah terakhir yang dimulai dengan `ls`.

### Search History Interaktif

```text
Ctrl+R
```

Penjelasan:

- Tekan `Ctrl+R` di prompt Zsh.
- Anda masuk ke mode *reverse search*.
- Ketik sebagian perintah, lalu tekan `Ctrl+R` lagi untuk mencari kemunculan sebelumnya.
- Tekan `Enter` untuk menjalankan, atau `Ctrl+G` untuk membatalkan.

Ini adalah fitur ZLE yang akan kita bahas lebih dalam.

### Option History

Beberapa option history yang penting.

```zsh
setopt HIST_IGNORE_DUPS
```

Penjelasan:

- `HIST_IGNORE_DUPS` — tidak menyimpan duplikat berturut-turut.
- Jika Anda menjalankan `ls` dua kali, hanya satu yang tersimpan.

```zsh
setopt HIST_IGNORE_ALL_DUPS
```

Penjelasan:

- Menghapus semua duplikat, bukan hanya berturut-turut.
- Jika Anda pernah menjalankan `ls` kapan saja, maka `ls` baru akan dihapus dari history.

```zsh
setopt HIST_IGNORE_SPACE
```

Penjelasan:

- Perintah yang dimulai dengan spasi tidak disimpan ke history.
- Berguna untuk perintah yang mengandung data sensitif.

```zsh
setopt HIST_REDUCE_BLANKS
```

Penjelasan:

- Menghapus spasi berlebih sebelum menyimpan.
- `ls    -la` akan disimpan sebagai `ls -la`.

```zsh
setopt HIST_VERIFY
```

Penjelasan:

- Setelah ekspansi history (misalnya `!!`), perintah tidak langsung dijalankan. Anda diberi kesempatan untuk melihat dan mengeditnya.

```zsh
setopt SHARE_HISTORY
```

Penjelasan:

- Berbagi history antar sesi Zsh yang sedang berjalan.
- Sesi terminal baru akan melihat perintah dari sesi lama.

```zsh
setopt INC_APPEND_HISTORY
```

Penjelasan:

- Menambahkan perintah ke file history segera setelah dijalankan, bukan saat shell keluar.
- Berguna jika Anda sering membuka banyak terminal.

```zsh
setopt EXTENDED_HISTORY
```

Penjelasan:

- Menyimpan timestamp di file history.
- Format: `: <timestamp>:<duration>;<command>`.
- Berguna untuk analisis history nanti.

---

## 3.3 Completion System

Completion adalah fitur yang menebak perintah, argumen, opsi, dan path saat Anda menekan `Tab`.

Di Bash, completion diatur oleh `bash-completion` dan fungsi-fungsi yang didaftarkan. Di Zsh, sistem completion adalah modul native yang jauh lebih kaya, disebut **compsys**.

### compinit

Untuk mengaktifkan completion, Anda harus menjalankan:

```zsh
autoload -Uz compinit
compinit
```

Penjelasan kata demi kata:

- `autoload` — builtin Zsh untuk memuat fungsi secara otomatis.
- `-U` — jangan ekspansi alias saat memuat.
- `-z` — gunakan format Zsh native.
- `compinit` — nama fungsi yang di-autoload.
- Setelah `autoload -Uz compinit`, Anda bisa memanggil `compinit`.
- `compinit` — inisialisasi sistem completion. Ia akan memindai `$fpath` untuk fungsi completion dan membuat file `~/.zcompdump`.

### fpath

`fpath` adalah array direktori tempat Zsh mencari fungsi autoload, termasuk fungsi completion.

```zsh
print -l $fpath
```

Penjelasan:

- `print` — builtin Zsh untuk mencetak.
- `-l` — cetak setiap elemen array di baris terpisah.
- `$fpath` — array path untuk fungsi autoload.

Secara default, `$fpath` berisi direktori sistem Zsh, misalnya `/usr/share/zsh/functions/Completion`. Jika Anda ingin menambah fungsi completion sendiri, tambahkan direktori ke `$fpath` sebelum `compinit`:

```zsh
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit
```

Penjelasan:

- `fpath=(~/.zsh/completion $fpath)` — tambahkan direktori pribadi di depan.
- Urutan penting: direktori pribadi harus di depan agar fungsi Anda menimpa fungsi sistem.

### zcompdump

Saat pertama kali `compinit` dijalankan, Zsh membuat file:

```text
~/.zcompdump
```

Penjelasan:

- File ini berisi dump dari sistem completion.
- Fungsinya mempercepat startup berikutnya, karena `compinit` tidak perlu memindai semua direktori lagi.
- Jika Anda menambahkan fungsi completion baru dan tidak terdeteksi, hapus file ini dan jalankan `compinit` lagi.

### Completion Dasar

Setelah `compinit` aktif, coba:

```zsh
ls /u<Tab>
```

Penjelasan:

- `ls /u` — mulai mengetik path.
- `<Tab>` — tekan Tab.
- Zsh akan melengkapi menjadi `/usr/` jika hanya itu yang cocok, atau menampilkan pilihan jika ada beberapa.

```zsh
git <Tab>
```

Penjelasan:

- `git ` — perintah dengan spasi.
- `<Tab>` — Zsh akan menampilkan subcommand `git` seperti `add`, `commit`, `push`, dan sebagainya.

Completion bekerja karena ada fungsi completion untuk `git`. Fungsi ini disediakan oleh Zsh atau plugin.

### Menu Completion

```text
Tab Tab
```

Penjelasan:

- Tekan Tab dua kali.
- Jika ada beberapa kandidat, Zsh akan menampilkan menu.
- Anda bisa navigasi dengan panah atau `Ctrl+N`/`Ctrl+P`.

### Option Completion

Beberapa option penting untuk completion.

```zsh
setopt AUTO_MENU
```

Penjelasan:

- Setelah Tab pertama, menu completion muncul otomatis tanpa perlu Tab kedua.

```zsh
setopt AUTO_LIST
```

Penjelasan:

- Menampilkan daftar kandidat saat Tab ambigu.

```zsh
setopt COMPLETE_IN_WORD
```

Penjelasan:

- Completion bekerja di tengah kata, bukan hanya di akhir.

```zsh
setopt ALWAYS_TO_END
```

Penjelasan:

- Kursor dipindah ke akhir kata setelah completion.

```zsh
setopt MENU_COMPLETE
```

Penjelasan:

- Tab langsung memilih kandidat pertama, bukan menampilkan daftar.

---

## 3.4 ZLE — Zsh Line Editor

ZLE adalah **Zsh Line Editor**, yaitu editor baris yang menangani input Anda di prompt. Setiap kali Anda mengetik di Zsh, Anda berinteraksi dengan ZLE.

ZLE memiliki:
- buffer: isi baris yang sedang Anda ketik.
- cursor: posisi kursor.
- keymap: pemetaan tombol ke fungsi.
- widget: fungsi yang bisa dipanggil oleh keymap.

Mental model:

```text
Keyboard
   ↓
Keymap
   ↓
Widget
   ↓
Aksi (modifikasi buffer, kursor, history, dsb)
```

### Buffer

Buffer adalah isi command line saat ini.

```zsh
echo $BUFFER
```

Penjelasan:

- `BUFFER` — variabel khusus ZLE yang berisi seluruh isi baris.
- Namun, `$BUFFER` hanya bermakna di dalam widget ZLE, bukan di prompt biasa. Di prompt biasa, `$BUFFER` kosong.

### CURSOR

```zsh
echo $CURSOR
```

Penjelasan:

- `CURSOR` — variabel ZLE yang berisi posisi kursor.
- Posisi 0 berarti sebelum karakter pertama.
- Posisi `${#BUFFER}` berarti di akhir baris.

---

## 3.5 bindkey

`bindkey` adalah builtin untuk memetakan tombol ke widget ZLE.

### Melihat Keymap

```zsh
bindkey -l
```

Penjelasan:

- `bindkey` — builtin.
- `-l` — list. Menampilkan daftar keymap yang tersedia.
- Output biasanya: `emacs`, `viins`, `vicmd`, `main`, `isearch`, `command`.

### Melihat Binding

```zsh
bindkey -M emacs
```

Penjelasan:

- `-M emacs` — tampilkan binding di keymap `emacs`.
- Output: daftar tombol dan widget yang terikat.

```zsh
bindkey -M viins
```

Penjelasan:

- Tampilkan binding di keymap `viins` (vi insert mode).

### Memilih Keymap

```zsh
bindkey -e
```

Penjelasan:

- `-e` — pilih keymap `emacs`.
- Ini adalah default Zsh.

```zsh
bindkey -v
```

Penjelasan:

- `-v` — pilih keymap `viins` dan `vicmd`.
- Mode vi. Anda harus menekan `Esc` untuk masuk ke mode command.

### Membuat Binding

```zsh
bindkey '^G' my_widget
```

Penjelasan kata demi kata:

- `bindkey` — builtin.
- `'^G'` — tombol. Tanda `^` diikuti huruf berarti tombol Ctrl. `^G` berarti `Ctrl+G`.
- `my_widget` — nama widget ZLE yang akan dijalankan saat tombol ditekan.

Cara menulis tombol:

- `^A` sampai `^Z` — Ctrl+A sampai Ctrl+Z.
- `\e` — Escape.
- `\e[A` — panah atas.
- `\e[B` — panah bawah.
- `\e[C` — panah kanan.
- `\e[D` — panah kiri.
- `^[` — Escape (kombinasi Ctrl+[).

Contoh:

```zsh
bindkey '^[[A' up-line-or-history
```

Penjelasan:

- `^[[A` — escape sequence untuk panah atas.
- `up-line-or-history` — widget yang memindahkan kursor ke baris atas history.

```zsh
bindkey '^R' history-incremental-search-backward
```

Penjelasan:

- `^R` — Ctrl+R.
- `history-incremental-search-backward` — widget untuk pencarian history mundur.

---

## 3.6 Widget

Widget adalah fungsi ZLE yang bisa dipanggil oleh keymap. Ada dua jenis:

1. **Widget bawaan** — sudah disediakan Zsh, misalnya `up-line-or-history`, `backward-delete-char`, `accept-line`.
2. **Widget kustom** — Anda buat sendiri dengan `zle -N`.

### Membuat Widget Kustom

```zsh
my_widget() {
    BUFFER="echo hello"
    CURSOR=${#BUFFER}
}

zle -N my_widget
bindkey '^G' my_widget
```

Penjelasan kata demi kata:

- `my_widget() {` — definisi fungsi. Nama fungsi bebas, tetapi harus sama dengan nama widget.
- `BUFFER="echo hello"` — isi buffer diubah menjadi `echo hello`.
- `CURSOR=${#BUFFER}` — pindahkan kursor ke akhir buffer. `${#BUFFER}` adalah panjang buffer.
- `}` — akhir fungsi.
- `zle -N my_widget` — daftarkan fungsi `my_widget` sebagai widget ZLE. Tanpa ini, `bindkey` tidak bisa mengikat ke fungsi.
- `-N` — opsi untuk membuat widget baru dari fungsi yang sudah ada.
- `bindkey '^G' my_widget` — ikat `Ctrl+G` ke widget `my_widget`.

Setelah ini, menekan `Ctrl+G` di prompt akan mengubah baris menjadi `echo hello` dan kursor di akhir.

### Widget Bawaan Penting

```text
accept-line
```

Penjelasan:

- Menjalankan perintah di buffer. Biasanya terikat ke `Enter`.

```text
self-insert
```

Penjelasan:

- Menyisipkan karakter yang ditekan ke buffer.

```text
backward-delete-char
```

Penjelasan:

- Menghapus karakter sebelum kursor.

```text
history-incremental-search-backward
```

Penjelasan:

- Pencarian history mundur. Terikat ke `Ctrl+R`.

```text
up-line-or-history
```

Penjelasan:

- Jika kursor di baris pertama, pindah ke history sebelumnya. Jika tidak, pindah baris.

```text
down-line-or-history
```

Penjelasan:

- Kebalikan dari `up-line-or-history`.

```text
beginning-of-line
```

Penjelasan:

- Pindahkan kursor ke awal baris. Biasanya `Ctrl+A`.

```text
end-of-line
```

Penjelasan:

- Pindahkan kursor ke akhir baris. Biasanya `Ctrl+E`.

```text
kill-line
```

Penjelasan:

- Hapus dari kursor ke akhir baris. Biasanya `Ctrl+K`.

```text
kill-whole-line
```

Penjelasan:

- Hapus seluruh baris.

```text
undo
```

Penjelasan:

- Urungkan perubahan di buffer. Biasanya `Ctrl+_` atau `Ctrl+Z` di Zsh.

```text
redisplay
```

Penjelasan:

- Tampilkan ulang buffer.

```text
clear-screen
```

Penjelasan:

- Bersihkan layar. Biasanya `Ctrl+L`.

---

## 3.7 Hook

Hook adalah fungsi yang dipanggil secara otomatis pada momen tertentu. Di Zsh, ada beberapa hook penting.

### preexec

`preexec` dipanggil sebelum perintah dijalankan.

```zsh
preexec() {
    echo "Menjalankan: $1"
}
```

Penjelasan:

- `preexec` — nama hook. Zsh akan memanggilnya sebelum mengeksekusi perintah.
- `$1` — perintah yang akan dijalankan.
- `$2` — seluruh baris perintah (dengan argumen).
- `$3` — sama seperti `$2` tetapi tanpa ekspansi.

Berguna untuk logging, timer, atau notifikasi.

### precmd

`precmd` dipanggil sebelum prompt ditampilkan.

```zsh
precmd() {
    echo "Siap menerima perintah"
}
```

Penjelasan:

- `precmd` — nama hook.
- Dipanggil setiap kali Zsh selesai menjalankan perintah dan siap menampilkan prompt lagi.

Berguna untuk memperbarui prompt, mengecek status git, atau menampilkan informasi.

### chpwd

`chpwd` dipanggil setiap kali direktori berubah.

```zsh
chpwd() {
    echo "Direktori sekarang: $PWD"
}
```

Penjelasan:

- `chpwd` — nama hook.
- `$PWD` — variabel yang berisi direktori saat ini.
- Dipanggil setelah `cd`, `pushd`, `popd`, atau `AUTO_CD`.

Berguna untuk menampilkan isi direktori, mengubah prompt, atau mengaktifkan virtualenv.

### zshaddhistory

`zshaddhistory` dipanggil sebelum perintah ditambahkan ke history.

```zsh
zshaddhistory() {
    return 0
}
```

Penjelasan:

- `zshaddhistory` — nama hook.
- `return 0` — perintah disimpan.
- `return 1` — perintah tidak disimpan.
- `$1` — perintah yang akan disimpan.

Berguna untuk memfilter perintah sensitif dari history.

### period

`period` dipanggil secara periodik jika Anda mengaktifkan:

```zsh
TMOUT=60
```

Penjelasan:

- `TMOUT` — interval dalam detik.
- `60` — 60 detik.
- Setelah 60 detik idle, hook `period` dipanggil.

```zsh
period() {
    echo "Sudah 60 detik idle"
}
```

Penjelasan:

- `period` — nama hook.
- Berguna untuk auto-save, refresh, atau notifikasi.

---

## 3.8 Autoload

Autoload adalah mekanisme untuk memuat fungsi dari file saat pertama kali dipanggil. Kita sudah singgung ini di Materi 1, tetapi di sini kita perdalam dalam konteks interaktif.

### Cara Kerja

```zsh
autoload -Uz myfunc
```

Penjelasan:

- `autoload` — builtin.
- `-U` — jangan ekspansi alias.
- `-z` — format Zsh native.
- `myfunc` — nama fungsi.

Setelah ini, Zsh tahu bahwa `myfunc` adalah fungsi yang belum dimuat. Ketika Anda memanggil `myfunc`, Zsh akan:

1. Mencari file bernama `myfunc` di setiap direktori di `$fpath`.
2. Memuat file tersebut.
3. Menjalankan isi file sebagai isi fungsi.
4. Menjalankan fungsi.

### Format File Autoload

File `myfunc` **tidak** berisi:

```zsh
myfunc() {
    echo "hello"
}
```

File `myfunc` berisi **isi fungsi** langsung:

```zsh
echo "hello"
```

Ini adalah perbedaan penting. File autoload adalah *tubuh fungsi*, bukan definisi fungsi.

Jika fungsi Anda membutuhkan variabel lokal, Anda bisa menulis:

```zsh
local name="Cendekiawan"
echo "$name"
```

Zsh akan memperlakukan `local` sebagai deklarasi variabel lokal dalam konteks fungsi yang sedang dimuat.

### Autoload untuk Completion

Autoload paling sering digunakan untuk completion. Setiap fungsi completion Zsh adalah file autoload di `$fpath`. Contoh:

```text
/usr/share/zsh/functions/Completion/Unix/_git
```

Penjelasan:

- File bernama `_git` berisi fungsi completion untuk perintah `git`.
- Ketika Anda mengetik `git <Tab>`, Zsh memuat `_git` dan menjalankannya.

Konvensi nama: fungsi completion diawali underscore, misalnya `_git`, `_ls`, `_docker`.

### Melihat Fungsi yang Di-autoload

```zsh
print -l $fpath
```

Penjelasan:

- Menampilkan semua direktori di `$fpath`.
- Setiap direktori berisi file autoload.

```zsh
ls /usr/share/zsh/functions/Completion/Unix/
```

Penjelasan:

- Melihat file completion yang tersedia di sistem Anda.
- Anda bisa membaca file-file ini untuk memahami cara kerja completion.

---

## 3.9 Praktik: Widget Ctrl+G

Sekarang kita praktikkan sesuai kurikulum.

### Tujuan

Membuat widget yang:
1. Mengubah buffer menjadi `echo hello`.
2. Memindahkan kursor ke akhir buffer.
3. Mengikat ke `Ctrl+G`.

### Langkah 1: Definisikan Fungsi

```zsh
my_widget() {
    BUFFER="echo hello"
    CURSOR=${#BUFFER}
}
```

Penjelasan:

- `my_widget()` — nama fungsi. Nama bebas.
- `{` — awal blok.
- `BUFFER="echo hello"` — ganti isi baris dengan `echo hello`.
- `CURSOR=${#BUFFER}` — pindahkan kursor ke akhir. `${#BUFFER}` adalah panjang string `BUFFER`.
- `}` — akhir blok.

### Langkah 2: Daftarkan sebagai Widget

```zsh
zle -N my_widget
```

Penjelasan:

- `zle` — builtin untuk mengelola ZLE.
- `-N` — opsi untuk membuat widget baru.
- `my_widget` — nama fungsi yang dijadikan widget.

Tanpa langkah ini, `bindkey` akan gagal karena `my_widget` bukan widget yang dikenali ZLE.

### Langkah 3: Ikat ke Tombol

```zsh
bindkey '^G' my_widget
```

Penjelasan:

- `bindkey` — builtin.
- `'^G'` — tombol `Ctrl+G`.
- `my_widget` — widget yang dijalankan.

### Langkah 4: Uji

Tekan `Ctrl+G` di prompt. Buffer akan berubah menjadi `echo hello` dan kursor di akhir. Tekan `Enter` untuk menjalankan.

### Variasi: Widget dengan Input

```zsh
my_widget() {
    local cmd
    cmd=$(date)
    BUFFER="echo $cmd"
    CURSOR=${#BUFFER}
}
```

Penjelasan:

- `local cmd` — deklarasikan variabel lokal.
- `cmd=$(date)` — jalankan `date` dan simpan outputnya.
- `BUFFER="echo $cmd"` — isi buffer dengan `echo` diikuti tanggal.
- `CURSOR=${#BUFFER}` — pindahkan kursor ke akhir.

### Variasi: Widget yang Menjalankan Perintah

```zsh
my_widget() {
    zle accept-line
}
```

Penjelasan:

- `zle accept-line` — panggil widget bawaan `accept-line` dari dalam widget kustom.
- Efeknya sama seperti menekan Enter.

Untuk menjalankan perintah sebelum `accept-line`:

```zsh
my_widget() {
    echo "Widget dipanggil" >&2
    zle accept-line
}
```

Penjelasan:

- `echo "Widget dipanggil" >&2` — cetak ke stderr. Kita pakai `>&2` agar tidak mengganggu buffer.
- `zle accept-line` — jalankan perintah di buffer.

### Variasi: Widget yang Memodifikasi Buffer

```zsh
my_widget() {
    if [[ "$BUFFER" == ls* ]]; then
        BUFFER="ls -la ${BUFFER#ls }"
    fi
    CURSOR=${#BUFFER}
}
```

Penjelasan:

- `if [[ "$BUFFER" == ls* ]]` — cek apakah buffer dimulai dengan `ls`.
- `BUFFER="ls -la ${BUFFER#ls }"` — ganti buffer menjadi `ls -la` diikuti sisa buffer setelah `ls `.
- `${BUFFER#ls }` — parameter expansion untuk menghapus prefix `ls ` dari buffer.
- `CURSOR=${#BUFFER}` — pindahkan kursor ke akhir.

---

## 3.10 Ringkasan Materi 3

- Shell interaktif berbeda dari shell non-interaktif.
- History dikelola oleh `HISTFILE`, `HISTSIZE`, `SAVEHIST`, dan option seperti `HIST_IGNORE_DUPS`, `SHARE_HISTORY`.
- Completion system diaktifkan dengan `autoload -Uz compinit; compinit`.
- `fpath` adalah array direktori fungsi autoload.
- ZLE adalah editor baris Zsh.
- `bindkey` memetakan tombol ke widget.
- Widget adalah fungsi ZLE. Bisa bawaan atau kustom.
- `zle -N` mendaftarkan fungsi sebagai widget.
- Hook penting: `preexec`, `precmd`, `chpwd`, `zshaddhistory`, `period`.
- Autoload memuat fungsi dari file di `$fpath` saat pertama dipanggil.
- Praktik: widget `Ctrl+G` yang mengubah buffer.

---

Sampai di sini **Materi 3 — Interactive Zsh** selesai. Sesuai kurikulum, berikutnya adalah **Materi 4 — Struktur Konfigurasi Zsh**, yang mencakup:
- `.zshenv`
- `.zprofile`
- `.zshrc`
- `.zlogin`
- `.zlogout`
- kapan masing-masing dibaca
- modular configuration
- plugin management
- environment management
- startup optimization
- struktur `~/.config/zsh/`
- file `aliases.zsh`, `functions.zsh`, `options.zsh`, `completion.zsh`, `keybinds.zsh`, `history.zsh`, `prompt.zsh`
- folder `integrations/` dengan `git.zsh`, `fzf.zsh`, `zoxide.zsh`, `yazi.zsh`

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

