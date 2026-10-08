# Invocation

Dalam konteks `zsh`, istilah **invocation** berarti **mode pemanggilan shell**. Zsh tidak selalu dipanggil dengan cara yang sama, dan mode pemanggilannya menentukan file startup mana yang akan dieksekusi.

Terdapat dua sumbu yang independen:

**1. Login vs Non-Login**
Menentukan apakah shell tersebut adalah sesi awal otentikasi pengguna. Login shell bertanggung jawab menyiapkan lingkungan awal.

**2. Interactive vs Non-Interactive**
Menentukan apakah shell terhubung ke terminal dan menunggu input dari pengguna, atau hanya menjalankan perintah dan selesai.

File `~/.zshenv` bersifat khusus karena selalu dibaca pada setiap invocation, berbeda dengan file lain yang tergantung pada modenya.

Berikut adalah empat kombinasi invocation tersebut:

### 1. Login + Interactive
Ini adalah sesi kerja utama Anda. Shell menjadi gerbang awal login dan sekaligus interaktif.

**Karakteristik:** Menginisialisasi seluruh lingkungan pengguna, dari variabel sistem hingga prompt dan alias.
**Contoh:** Login pertama di TTY Linux, koneksi `ssh user@host`, membuka Terminal di macOS, atau perintah `zsh -l -i`.
**File yang dimuat:**
`/etc/zshenv` -> `~/.zshenv` -> `/etc/zprofile` -> `~/.zprofile` -> `/etc/zshrc` -> `~/.zshrc` -> `/etc/zlogin` -> `~/.zlogin`

### 2. Login + Non-Interactive
Shell diposisikan sebagai login shell, tetapi tidak interaktif karena hanya untuk menjalankan satu perintah lalu keluar.

**Karakteristik:** Tetap memuat konfigurasi login seperti `zprofile`, namun tidak memuat `zshrc` karena tidak ada interaksi.
**Contoh:** `ssh user@host 'cat /etc/hosts'`, atau `zsh -l -c 'echo $PATH'`. Mode ini sering digunakan untuk memastikan `PATH` dari manajer versi seperti Homebrew tetap terbawa di sesi remote.
**File yang dimuat:** `/etc/zshenv` -> `~/.zshenv` -> `/etc/zprofile` -> `~/.zprofile` -> `/etc/zlogin` (saat selesai, `zlogout`)

### 3. Non-Login + Interactive
Ini adalah mode yang paling sering Anda gunakan sehari-hari saat bekerja di dalam terminal.

**Karakteristik:** Tidak perlu mengulang proses login, hanya menyiapkan hal-hal yang dibutuhkan untuk interaksi: alias, fungsi, completion, dan tema prompt.
**Contoh:** Membuka tab baru di GNOME Terminal, Konsole, atau terminal di VS Code, atau mengetik `zsh` di dalam shell yang sudah ada.
**File yang dimuat:** `/etc/zshenv` -> `~/.zshenv` -> `/etc/zshrc` -> `~/.zshrc`

### 4. Non-Login + Non-Interactive
Shell murni digunakan sebagai interpreter skrip. Mode ini harus secepat dan sebersih mungkin.

**Karakteristik:** Hanya memuat `zshenv`. Inilah alasan mengapa `zshenv` tidak boleh berisi konfigurasi yang berat.
**Contoh:** `zsh deploy.sh`, `zsh -c 'ls -la'`, atau skrip yang dipanggil oleh aplikasi lain.
**File yang dimuat:** `/etc/zshenv` -> `~/.zshenv` saja.

#### Implikasi Praktis

Karena `zshenv` dieksekusi pada **all invocations**:

* **Tempatkan di `~/.zshenv`:** Hanya variabel lingkungan yang harus diwariskan ke semua proses anak, seperti `PATH`, `EDITOR`, `LANG`, `XDG_*`.
* **Tempatkan di `~/.zprofile`:** Proses yang hanya perlu sekali saat login, seperti `eval "$(/opt/homebrew/bin/brew shellenv)"`.
* **Tempatkan di `~/.zshrc`:** Semua hal interaktif: alias, fungsi, konfigurasi Oh My Zsh, prompt, keybinding, dan inisialisasi `nvm` atau `pyenv`.

Anda dapat memverifikasi mode shell saat ini dengan perintah:

```zsh
if [[ -o login ]]; then echo "Mode: Login"; else echo "Mode: Non-Login"; fi
if [[ -o interactive ]]; then echo "Mode: Interactive"; else echo "Mode: Non-Interactive"; fi
```

[Lebih Lanjut Tentang Prilaku Shell](./more.md)


