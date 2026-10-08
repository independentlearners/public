**Tidak, tidak semua shell berperilaku persis dengan empat kombinasi tersebut.** Model `login/non-login` × `interactive/non-interactive` adalah **paradigma yang terutama berlaku untuk shell Unix-like turunan Bourne/POSIX** (seperti `sh`, `bash`, `dash`, `zsh`, `ksh`). Shell seperti **`fish`** mengadopsi sebagian besar konsep ini tetapi dengan penyederhanaan. **PowerShell** memiliki model yang fundamentally berbeda. **WSL** bukanlah shell itu sendiri, melainkan lingkungan yang menjalankan shell Linux, sehingga aturan shell Linux tetap berlaku di dalamnya.

Berikut penjelasan lengkapnya.

---

## 1. Matriks Empat Kombinasi (Shell Unix-like)

Untuk shell seperti `bash`, `sh`, `dash`, `zsh`, dan `ksh`, kombinasi ini ditentukan oleh **dua sumbu independen**:

| | **Interactive** | **Non-Interactive** |
|---|---|---|
| **Login** | Konsol/SSH login. Membaca `/etc/profile` → `~/.bash_profile` → `~/.profile` | `ssh host 'perintah'` (stdin bukan tty). Tetap dianggap login karena `argv[0]` diawali `-` atau opsi `--login` |
| **Non-Login** | Tab terminal baru di GUI. Membaca `~/.bashrc` | Menjalankan skrip: `bash script.sh`. Membaca `$BASH_ENV` jika diset |

### Cara shell menentukan statusnya

- **Login**: Shell memeriksa karakter pertama dari `argv[0]`. Jika diawali dengan `-` (misalnya `-bash`), shell dianggap login. Opsi `--login` atau `-l` juga memaksa mode ini. Sistem biasanya melakukan ini secara otomatis saat login pertama.
- **Interactive**: Shell dianggap interaktif jika **stdin dan stderr terhubung ke terminal (tty)** dan tidak ada argumen non-opsi yang diberikan. Opsi `-i` dapat memaksa mode interaktif.

### File startup yang dibaca

Perbedaan utama antara keempat kombinasi ini terletak pada **file konfigurasi mana yang dieksekusi saat startup**. Untuk `bash`:

- **Login + Interactive**: `/etc/profile` → `~/.bash_profile` → `~/.bash_login` → `~/.profile` (yang pertama ditemukan).
- **Non-Login + Interactive**: `~/.bashrc`.
- **Login + Non-Interactive**: Sama seperti login interaktif, tetapi eksekusi perintah datang dari stdin, bukan prompt. Beberapa shell mungkin melewatkan bagian tertentu dari profil.
- **Non-Login + Non-Interactive**: Hanya membaca `$BASH_ENV` jika variabel tersebut diset.

**Kesalahan umum**: Menaruh variabel lingkungan hanya di `~/.bashrc`. Shell non-login interaktif akan membacanya, tetapi banyak alur login (seperti SSH) tidak. Untuk variabel yang harus ada di mana-mana, gunakan `/etc/environment` atau file profil login.

### `sh` dan `dash`

`sh` sering merupakan symlink ke shell POSIX yang ringan (di Debian/Ubuntu biasanya `dash`). `dash` mengikuti aturan yang sama: login jika `argv[0]` diawali `-`, interaktif jika stdin adalah tty dan tidak ada argumen. `dash` membaca `~/.profile` untuk login dan `$ENV` untuk shell interaktif. Namun, `dash` **tidak memiliki fitur interaktif yang kaya** dan jarang digunakan sebagai shell login default untuk pengguna; biasanya hanya untuk skrip.

### `zsh`

`zsh` juga mengikuti model empat kombinasi. File startup-nya berbeda: `.zprofile` (login), `.zshrc` (interaktif), `.zshenv` (selalu), dan `.zlogin`/`.zlogout`. Konsepnya sama: login/non-login dan interaktif/non-interaktif menentukan file mana yang dibaca.

### `fish`

`fish` **mengadopsi konsep ini tetapi dengan penyederhanaan**. `fish` memiliki opsi `--login` dan `--interactive` yang eksplisit. Namun, `fish` **tidak memiliki pemisahan file startup yang rumit** seperti bash. Ia menggunakan `config.fish` yang dijalankan untuk semua sesi, dan pengguna dapat memeriksa status dengan `status --is-login` dan `status --is-interactive` untuk menjalankan perintah kondisional. Jadi, meskipun `fish` mengenali status login dan interaktif, **model konfigurasinya tidak sepenuhnya identik** dengan bash.

---

## 2. PowerShell: Model yang Berbeda

**PowerShell tidak memiliki konsep "login shell" yang sama dengan shell Unix.** PowerShell tidak membedakan antara shell login dan non-login berdasarkan `argv[0]` atau opsi `--login`. Sebaliknya, PowerShell **selalu menjalankan profil startup** (kecuali jika opsi `-NoProfile` diberikan).

- **Profil PowerShell** (`$PROFILE`) adalah skrip yang berjalan setiap kali PowerShell dimulai, **baik interaktif maupun non-interaktif**.
- Tidak ada pemisahan file seperti `.bash_profile` vs `.bashrc`. Semua konfigurasi ada di satu atau beberapa file profil.
- Untuk sesi non-interaktif (misalnya, menjalankan skrip dengan `pwsh -File script.ps1`), profil **tetap dimuat** kecuali secara eksplisit dinonaktifkan dengan `-NoProfile`.

Jadi, jika Anda bertanya "apakah PowerShell memiliki empat kombinasi login/non-login × interaktif/non-interaktif?" Jawabannya adalah **tidak**. PowerShell hanya membedakan **interaktif vs non-interaktif** dalam hal perilaku runtime (misalnya, apakah prompt ditampilkan, apakah input dari pengguna diharapkan), tetapi **tidak membedakan login vs non-login** untuk tujuan pemuatan profil.

---

## 3. WSL (Windows Subsystem for Linux)

**WSL bukanlah shell.** WSL adalah lapisan kompatibilitas yang memungkinkan Linux binary dijalankan di Windows. Di dalam WSL, Anda menjalankan **shell Linux** seperti `bash`, `zsh`, atau `fish`. Oleh karena itu, **semua aturan shell Unix-like yang dijelaskan di atas tetap berlaku** di dalam WSL.

- Saat Anda membuka WSL, secara default ia menjalankan shell default distribusi (biasanya `bash`) sebagai **shell login interaktif**.
- Anda dapat menjalankan `wsl -e bash -c "perintah"` untuk sesi **non-interaktif non-login**.
- Anda dapat menjalankan `wsl -e bash --login` untuk memaksa mode **login**.
- Konsep `~/.bashrc`, `~/.profile`, dan `~/.bash_profile` tetap berlaku persis seperti di Linux asli.

Jadi, WSL **mewarisi** model empat kombinasi dari shell Linux yang dijalankannya, tetapi WSL sendiri tidak menambahkan dimensi baru.

---

## 4. Ringkasan: Shell Mana yang Mengikuti Model Ini?

| Shell | Login vs Non-Login? | Interactive vs Non-Interactive? | Catatan |
|---|---|---|---|
| **bash** | Ya, ketat | Ya | Model paling ketat; file startup berbeda per kombinasi |
| **zsh** | Ya | Ya | Mirip bash, file startup berbeda |
| **dash/sh** | Ya (berbasis `argv[0]`) | Ya (berbasis tty) | Minimalis; `$ENV` untuk interaktif |
| **ksh** | Ya | Ya | Mirip bash |
| **fish** | Sebagian | Ya | Opsi `--login`/`--interactive` eksplisit; konfigurasi disederhanakan |
| **PowerShell** | **Tidak** | Ya (perilaku runtime) | Profil selalu dimuat; `-NoProfile` untuk menonaktifkan |
| **WSL** | Tergantung shell Linux di dalamnya | Tergantung shell Linux di dalamnya | WSL hanya lingkungan; shell Linux di dalamnya tetap mengikuti aturannya |

---

## 5. Mengapa Perbedaan Ini Penting?

Memahami perbedaan ini krusial untuk **konfigurasi lingkungan yang konsisten**. Jika Anda menaruh `export PATH=...` hanya di `~/.bashrc`, maka:
- Terminal baru (non-login interaktif) akan mendapatkannya.
- Sesi SSH (login interaktif) **mungkin tidak** mendapatkannya jika `~/.bash_profile` tidak membaca `~/.bashrc`.
- Skrip yang dijalankan dengan `bash script.sh` (non-login non-interaktif) **tidak akan** membacanya sama sekali.

Untuk PowerShell, karena profil selalu dimuat, Anda tidak perlu khawatir tentang "login vs non-login", tetapi Anda harus berhati-hati agar profil tidak mengganggu skrip otomasi (gunakan `-NoProfile` jika perlu).

---

**Kesimpulan:** Empat kombinasi `login/non-login` × `interactive/non-interactive` adalah **model yang berlaku untuk shell Unix-like turunan Bourne/POSIX**, dengan `fish` yang mengadopsinya secara sebagian. **PowerShell memiliki model yang berbeda** dan tidak menerapkan dimensi login/non-login. **WSL mewarisi** model dari shell Linux yang dijalankannya. Jadi, jawaban atas pertanyaan Anda adalah: **tidak, tidak semua shell bekerja dengan cara yang sama.**
