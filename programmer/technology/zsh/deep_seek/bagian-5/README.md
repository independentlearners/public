# FASE 5 — MODUL 5.1: Fungsi Lanjutan, Hook, dan Autoloading

#### AUDIT KURIKULUM FASE 5 — Sebelum Materi Dimulai

Sebelum masuk ke materi, kita akan melakukan **audit teknis** terhadap Fase 5 yang Anda kirimkan. Audit ini bertujuan memastikan tidak ada lompatan konsep, kesalahan penyusunan, atau prasyarat yang hilang.

## Temuan Audit

| # | Temuan | Jenis | Rekomendasi |
|---|--------|-------|-------------|
| 1 | Fase 5 langsung membahas **anonymous function** dan **parameter expansion flags** tanpa memastikan pembaca sudah menguasai **dasar function Zsh** (`function nama(){}`, `local`, `return`, `$@` vs `$*`). | Prasyarat hilang | Tambahkan **Modul 4.x (prasyarat)**: "Fungsi Dasar & Scope Variabel di Zsh" — atau saya selipkan sebagai **sub-bab 5.1.0 (Pondasi)** di dalam materi ini. |
| 2 | Modul 5.2 membahas **ShellSpec/ZUnit** tetapi tidak menyebut **bagaimana cara meng-assert exit code, stdout, stderr** secara manual dengan `if`/`[[ ]]` sebelum masuk framework. | Lompatan konsep | Tambahkan sub-bab "Testing manual tanpa framework" sebagai jembatan. |
| 3 | Modul 5.3 menyebut `jq`, `curl`, `psql`, `kubectl` tetapi tidak menyebut **penanganan error pipeline** (`pipefail`, `PIPESTATUS`) dan **parsing JSON tanpa jq** (fallback). | Materi tidak lengkap | Tambahkan sub-bab opsional "Fallback tanpa jq" dan "Pipeline error handling". |
| 4 | Tidak ada modul tentang **keamanan script** (quoting, injection, `eval` bahaya, secret handling) padahal 5.3 menyentuh `API_KEY`. | Materi kritis hilang | Tambahkan **Modul 5.4 (usulan)**: "Keamanan Script Zsh & Penanganan Secret". |
| 5 | Tidak ada modul tentang **profiling & startup time** padahal 5.1 membahas autoloading untuk "menghemat waktu startup". | Materi pendukung hilang | Tambahkan sub-bab di 5.1: "Mengukur startup time dengan `zprof`". |
| 6 | Belum ada jembatan ke **Fase 6** (jika ada). | Kurikulum tidak berkelanjutan | Perlu dikonfirmasi: apa isi Fase 6? |

**Kesimpulan audit:** Fase 5 valid secara arah, tetapi **melompat** dari asumsi pembaca sudah mahir fungsi dasar. Karena itu, saya akan **menyisipkan Sub-bab 5.1.0 (Pondasi Fungsi Zsh)** sebagai materi tambahan yang tidak ada di kurikulum asli — sesuai instruksi Anda poin 12.

<!-- Sekarang kita masuk materi. Saya akan **bertahap**: hanya **Modul 5.1** dulu, lalu Anda konfirmasi untuk lanjut ke 5.2. -->

---


<details>
  <summary>📃 Daftar Isi</summary>

---

## 📑 Mini-Daftar Isi Modul 5.1

1. **5.1.0 — Pondasi Fungsi Zsh** *(tambahan audit)*
   - 5.1.0.1 Deklarasi fungsi: 3 gaya penulisan
   - 5.1.0.2 Scope variabel: `local`, `typeset`, global
   - 5.1.0.3 Parameter posisi: `$1`, `$@`, `$*`, `$#`
   - 5.1.0.4 Return value vs `echo`
2. **5.1.1 — Anonymous Functions**
3. **5.1.2 — Hook Functions: `chpwd`, `precmd`, `preexec`**
   - 5.1.2.1 `chpwd` — saat direktori berubah
   - 5.1.2.2 `precmd` — sebelum prompt
   - 5.1.2.3 `preexec` — sebelum perintah
   - 5.1.2.4 Hook lain yang jarang dibahas: `periodic`, `zshexit`, `TRAPDEBUG`
4. **5.1.3 — Autoloading & `fpath`**
   - 5.1.3.1 Konsep `fpath`
   - 5.1.3.2 `autoload -Uz`
   - 5.1.3.3 Konvensi file fungsi
   - 5.1.3.4 `autoload` vs `source` — kapan pakai yang mana
5. **5.1.4 — Parameter Expansion Flags**
   - 5.1.4.1 Filosofi `${(flag)var}`
   - 5.1.4.2 `(j)`, `(s)`, `(k)`, `(v)`
   - 5.1.4.3 Flag lain penting: `(q)`, `(Q)`, `(L)`, `(U)`, `(C)`, `(z)`
6. **5.1.5 — Manipulasi Array Lanjutan**
7. **5.1.6 — Associative Array & Iterasi**
8. **5.1.7 — Profiling Startup dengan `zprof`** *(tambahan audit)*
9. **Tips, Kesalahan Umum, Referensi**

</details>

---

## 5.1.0 — Pondasi Fungsi Zsh *(Materi Tambahan Audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada di kurikulum asli** Anda, tetapi saya tambahkan karena tanpa ini, Modul 5.1 akan terasa seperti melompat. Di sini kita membangun fondasi: bagaimana mendeklarasikan fungsi, bagaimana variabel berperilaku di dalam fungsi, dan bagaimana nilai dikembalikan. Semua materi lanjutan (anonymous function, hook, autoload) berdiri di atas fondasi ini.

### Konsep Kunci & Filosofi

Bayangkan fungsi seperti **resep masakan**. Anda beri nama resep (`nama_fungsi`), beri daftar bahan (parameter), lalu resep itu menghasilkan hidangan (output). Di Zsh, "resep" ini bisa dipanggil berkali-kali tanpa menulis ulang langkah-langkahnya.

Filosofi penting Zsh: **fungsi adalah warga kelas satu (first-class citizen)**. Artinya fungsi bisa diperlakukan seperti perintah biasa — dipanggil, dialihkan outputnya, di-pipe, bahkan dijadikan hook.

### Sintaks Dasar

**Tiga gaya mendeklarasikan fungsi di Zsh:**

```bash
# Gaya 1: Paling umum (POSIX-compatible)
nama_fungsi() {
    echo "Halo dari fungsi"
}

# Gaya 2: Dengan keyword 'function'
function nama_fungsi {
    echo "Halo dari fungsi"
}

# Gaya 3: Hybrid (keyword + tanda kurung)
function nama_fungsi() {
    echo "Halo dari fungsi"
}
```

**Perbedaan halus yang jarang dibahas:**
- Gaya 1 & 3: nama fungsi **tidak boleh** mengandung karakter khusus seperti `-` (kecuali dengan `setopt` tertentu).
- Gaya 2: memungkinkan nama fungsi berisi karakter seperti `-`, `+`, `:` (berguna untuk fungsi seperti `git-status`).
- Gaya 2 juga memungkinkan **multiple names** dalam satu deklarasi: `function a b c { ... }`.

**Penjelasan sintaks per elemen:**

| Elemen | Arti |
|--------|------|
| `nama_fungsi` | Identifier; huruf, angka, underscore. Tidak boleh diawali angka. |
| `()` | Penanda bahwa ini deklarasi fungsi (gaya POSIX). |
| `{ ... }` | Body fungsi — daftar perintah yang dijalankan. |
| `function` | Keyword opsional Zsh; memberi fleksibilitas nama. |

### Scope Variabel

Ini **krusial** dan sering jadi sumber bug.

```bash
global_var="aku global"

contoh_scope() {
    local dalam_var="aku lokal"
    global_var="aku diubah dari dalam fungsi"
    echo "$dalam_var"   # Bisa diakses di sini
    echo "$global_var"  # Bisa diakses
}

contoh_scope
echo "$global_var"      # Output: aku diubah dari dalam fungsi
echo "$dalam_var"       # Output: (kosong) — variabel lokal sudah hilang
```

**Aturan:**
- Tanpa `local`, variabel yang di-assign di dalam fungsi **mengubah variabel global** dengan nama sama (jika ada) atau **membuat global baru**.
- `local` membuat variabel hanya hidup di dalam fungsi dan fungsi anak yang dipanggilnya.
- `typeset` di Zsh = alias untuk `local` (dalam konteks fungsi). Di luar fungsi, `typeset` membuat variabel global bertipe.

**Variasi `local` lanjutan:**

```bash
local -a arr          # array lokal
local -A map          # associative array lokal
local -i angka=10     # integer lokal (aritmetika otomatis)
local -r KONSTANTA=5  # read-only (tidak bisa diubah)
local -x EXPORTED=1   # otomatis di-export ke child process
local -h              # 'hide' — tidak muncul di `typeset` output (jarang dipakai)
```

### Parameter Posisi

```bash
tampilkan_args() {
    echo "Jumlah argumen: $#"
    echo "Argumen 1: $1"
    echo "Argumen 2: $2"
    echo "Semua via \$@: $@"
    echo "Semua via \$*: $*"
    echo "Nama fungsi: $0"
}

tampilkan_args apel jeruk mangga
```

**Penjelasan mendalam `$@` vs `$*`:**

| Ekspresi | Perilaku |
|----------|----------|
| `$@` (tanpa kutip) | Setiap argumen dipisah oleh IFS → bisa pecah aneh jika ada spasi |
| `"$@"` (dengan kutip) | **Setiap argumen tetap utuh** → cara aman |
| `$*` | Semua argumen digabung jadi satu string dengan IFS |
| `"$*"` | Sama, tapi tetap satu string |

**Praktik terbaik:** Selalu pakai `"$@"` untuk meneruskan argumen.

```bash
panggil_ulang() {
    perintah_lain "$@"   # Aman meski argumen ada spasi
}
```

### Return Value vs `echo`

Kesalahan umum pemula: mengira `return` mengembalikan string seperti di Python.

```bash
# SALAH (pemahaman keliru)
hitung() {
    return "5"   # return hanya menerima ANGKA (0-255)
}

# BENAR — return untuk status
cek_file() {
    if [[ -f "$1" ]]; then
        return 0   # sukses
    else
        return 1   # gagal
    fi
}

# BENAR — output data lewat stdout
ambil_nama() {
    echo "Budi"
}

nama=$(ambil_nama)   # Tangkap via command substitution
```

**Aturan:**
- `return N` → exit code fungsi (0 = sukses, non-0 = gagal). N harus 0–255.
- Untuk mengembalikan **data**, gunakan `echo`/`print` lalu tangkap dengan `$(...)`.
- Untuk mengembalikan **array**, gunakan `print -l` atau teknik `reply` (dibahas di 5.1.4).

### Terminologi Esensial 5.1.0

- **Function body**: blok `{ ... }` berisi perintah.
- **Local scope**: wilayah di mana variabel hanya terlihat di dalam fungsi.
- **Positional parameter**: argumen berdasarkan posisi (`$1`, `$2`, ...).
- **Exit status**: kode numerik 0–255 hasil akhir fungsi/perintah.
- **Command substitution**: `$(...)` — menangkap stdout sebagai string.

### Potensi Kesalahan Umum 5.1.0

| Kesalahan | Solusi |
|-----------|--------|
| Lupa `local` → variabel bocor ke global | Selalu deklarasikan `local` di awal fungsi |
| Pakai `$@` tanpa kutip → argumen ber-spasi pecah | Pakai `"$@"` |
| `return "string"` → error | Gunakan `echo` + `$(...)` |
| Lupa `}` penutup → syntax error | Indentasi rapi, gunakan editor dengan zsh syntax |

### Visualisasi yang Direkomendasikan

> Diagram **scope bertingkat (nested boxes)**: kotak terluar = global scope, kotak dalam = function scope, kotak lebih dalam = nested function scope. Ini akan sangat membantu memahami di mana variabel "hidup".

### Hubungan dengan Modul Lain

Fondasi ini adalah **prasyarat langsung** untuk:
- 5.1.1 Anonymous function (fungsi tanpa nama).
- 5.1.2 Hook (fungsi yang dipanggil otomatis).
- 5.1.3 Autoload (fungsi yang dimuat dari file).
- 5.2 Testing (menguji fungsi).

### Sumber Referensi 5.1.0

- Zsh Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html
- Zsh Parameters: https://zsh.sourceforge.io/Doc/Release/Parameters.html
- Bash vs Zsh function differences: https://scriptingosx.com/2019/06/moving-to-zsh-part-6-functions/

---

## 5.1.1 — Anonymous Functions

### Deskripsi Konkret & Peran dalam Kurikulum

Anonymous function adalah fungsi **tanpa nama** yang **langsung dieksekusi saat didefinisikan**. Ini adalah fitur yang jarang ada di Bash dan menjadi salah satu keunggulan Zsh. Perannya di kurikulum: mengajarkan gaya fungsional (functional style) dan isolasi scope sekali pakai.

### Konsep Kunci & Filosofi Mendalam

Bayangkan Anda ingin memasak satu porsi kecil, tapi tidak ingin mengotori seluruh dapur. Anonymous function seperti **dapur sementara sekali pakai**: Anda siapkan bahan, masak, lalu dapur itu hilang — tidak ada nama yang tertinggal di memori.

Filosofinya:
1. **Isolasi**: Variabel `local` di dalam anonymous function tidak bocor ke luar.
2. **Kesempatan sekali pakai**: Cocok untuk setup sementara, misalnya `mktemp -d` lalu `cd`.
3. **Ekspresi langsung**: Tidak perlu memberi nama jika hanya dipakai sekali.

### Sintaks Dasar

```bash
# Bentuk paling dasar
() {
    echo "Aku dieksekusi langsung"
}

# Dengan argumen
() {
    echo "Argumen pertama: $1"
    echo "Semua: $@"
} apel jeruk mangga

# Dengan isolasi variabel
() {
    local temp=$(mktemp -d)
    cd "$temp"
    echo "Kerja di: $PWD"
}
echo "Sekarang di: $PWD"   # Kembali ke direktori semula
```

**Penjelasan sintaks per elemen:**

| Elemen | Arti |
|--------|------|
| `()` | Pasangan kurung kosong — penanda anonymous function (tanpa nama). |
| `{ ... }` | Body fungsi. |
| Argumen setelah `}` | Diteruskan sebagai `$1`, `$2`, dst. ke dalam fungsi. |
| Eksekusi | Terjadi **segera** setelah `}` ditutup. |

### Contoh Studi Kasus: Setup Sementara

Kasus nyata: Anda ingin meng-clone repo, build, lalu copy hasilnya — tanpa meninggalkan direktori kerja berubah.

```bash
#!/bin/zsh
set -e

build_project() {
    () {
        local workdir=$(mktemp -d)
        cd "$workdir"
        git clone --depth=1 "$1" .
        make build
        cp -r dist/* "$OLDPWD/out/"
    } "$1"
    echo "Build selesai di $PWD"
}

build_project https://github.com/user/repo.git
```

**Alur kerja:**
```bash
[Shell utama]
    │
    ├─► Panggil build_project
    │       │
    │       └─► Anonymous function
    │               ├─ mktemp -d → workdir
    │               ├─ cd workdir
    │               ├─ git clone
    │               ├─ make build
    │               ├─ cp hasil ke $OLDPWD/out/
    │               └─ [selesai, workdir tetap ada di disk]
    │       ◄── Kembali ke shell utama, $PWD tidak berubah
    └─► Lanjut
```

### Terminologi Esensial 5.1.1

- **Anonymous function**: Fungsi tanpa identifier, dieksekusi langsung.
- **IIFE (Immediately Invoked Function Expression)**: Istilah dari JavaScript untuk pola serupa; di Zsh setara dengan `() { ... }`.
- **Isolasi scope**: Variabel lokal tidak bocor ke luar.
- **`$OLDPWD`**: Variabel Zsh berisi direktori sebelumnya (sebelum `cd` terakhir).

### Struktur Pembelajaran Internal (Mini TOC 5.1.1)

1. Bentuk dasar `() { ... }`
2. Meneruskan argumen ke anonymous function
3. Isolasi variabel & direktori
4. Pola IIFE untuk setup sementara
5. Kapan **tidak** pakai anonymous function

### Rekomendasi Visualisasi

> Diagram alur **"kotak scope"**: shell utama sebagai kotak besar, anonymous function sebagai kotak kecil di dalamnya yang hilang setelah selesai. Ini membantu memahami isolasi.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.0 (fungsi dasar, `local`).
- **Dipakai di**: 5.1.2 (hook sering ditulis sebagai anonymous function), 5.2 (setup test sekali pakai).

### Sumber Referensi 5.1.1

- Zsh Anonymous Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html#Anonymous-Functions
- Artikel: https://scriptingosx.com/2019/07/moving-to-zsh-part-7-functions/

### Tips & Praktik Terbaik 5.1.1

- Gunakan anonymous function untuk **setup sementara** (mktemp, cd, cleanup).
- Jangan pakai untuk logika yang perlu dipanggil berulang — beri nama.
- Selalu `local` variabel di dalamnya.
- Untuk cleanup otomatis, kombinasikan dengan `trap` (dibahas di modul lain).

### Potensi Kesalahan Umum 5.1.1

| Kesalahan | Solusi |
|-----------|--------|
| Lupa `local` → variabel bocor | Selalu `local var=...` |
| Berharap bisa memanggil anonymous function lagi | Anonymous function sekali pakai — beri nama jika perlu dipanggil ulang |
| Argumen tidak terbaca | Pastikan argumen ditulis **setelah** `}` penutup, bukan di dalam `{}` |
| Salah indentasi → syntax error | Gunakan editor dengan plugin zsh |

---

## 5.1.2 — Hook Functions

### Deskripsi Konkret & Peran dalam Kurikulum

Hook function adalah fungsi yang **dipanggil otomatis oleh Zsh** pada event tertentu. Ini adalah salah satu fitur paling kuat Zsh dan alasan banyak developer pindah dari Bash. Perannya: memungkinkan Anda "mendengarkan" event shell dan bereaksi — misalnya menampilkan info git di prompt, mencatat perintah, atau membersihkan file sementara.

### Konsep Kunci & Filosofi Mendalam

Bayangkan hook seperti **sensor gerak di rumah**: Anda tidak perlu memantau terus-menerus; sensor akan memanggil lampu saat ada gerakan. Sama halnya, Anda tidak perlu menulis loop untuk memeriksa "apakah direktori berubah?" — cukup definisikan `chpwd()` dan Zsh akan memanggilnya otomatis.

Filosofi:
1. **Event-driven**: Anda mendefinisikan reaksi, bukan menulis polling.
2. **Non-invasif**: Anda tidak mengubah perintah asli; Anda menambah perilaku.
3. **Composable**: Banyak hook bisa dipasang bersamaan.

### 5.1.2.1 — `chpwd` (Change Print Working Directory)

**Kapan dipanggil:** Setiap kali direktori kerja berubah (setelah `cd`, `pushd`, `popd`).

**Sintaks:**

```bash
chpwd() {
    echo "📁 Pindah ke: $PWD"
    # Contoh nyata: auto-activate virtualenv
    if [[ -f .venv/bin/activate ]]; then
        source .venv/bin/activate
    fi
    # Contoh: tampilkan isi direktori
    ls -la
}
```

**Penjelasan per baris:**

| Baris | Arti |
|-------|------|
| `chpwd() {` | Deklarasi hook `chpwd`. Zsh akan memanggilnya otomatis. |
| `echo "📁 Pindah ke: $PWD"` | `$PWD` = variabel bawaan Zsh berisi direktori saat ini. |
| `if [[ -f .venv/bin/activate ]]` | Cek apakah file ada (`-f` = file reguler). |
| `source .venv/bin/activate` | Aktifkan virtualenv Python. |
| `ls -la` | Tampilkan isi direktori. |

**Contoh studi kasus nyata:** Auto-switch Node version dengan `nvm` saat masuk direktori proyek.

```bash
chpwd() {
    if [[ -f .nvmrc ]]; then
        local node_version=$(cat .nvmrc)
        nvm use "$node_version" 2>/dev/null
    fi
}
```

### 5.1.2.2 — `precmd` (Pre-Command / Pre-Prompt)

**Kapan dipanggil:** Sebelum setiap prompt ditampilkan (setelah perintah selesai, sebelum Anda mengetik perintah baru).

**Sintaks:**

```bash
precmd() {
    # Tampilkan waktu
    echo "⏰ $(date +%H:%M:%S)"
    
    # Tampilkan status git
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch=$(git branch --show-current)
        local status=$(git status --porcelain | wc -l)
        echo "🌿 $branch ($status perubahan)"
    fi
}
```

**Penjelasan per baris:**

| Baris | Arti |
|-------|------|
| `precmd() {` | Deklarasi hook. |
| `$(date +%H:%M:%S)` | Command substitution: jalankan `date`, tangkap output. |
| `git rev-parse --is-inside-work-tree` | Cek apakah kita di dalam repo git. |
| `&>/dev/null` | Buang stdout & stderr ke `/dev/null` (tidak tampil). |
| `git branch --show-current` | Nama branch aktif. |
| `git status --porcelain \| wc -l` | Hitung jumlah file berubah. |

**Penting:** `precmd` dijalankan **setiap kali** prompt muncul. Jangan taruh perintah berat (seperti `find /`) karena akan memperlambat shell.

### 5.1.2.3 — `preexec` (Pre-Execution)

**Kapan dipanggil:** Setelah Anda menekan Enter, **sebelum** perintah dieksekusi.

**Sintaks:**

```bash
preexec() {
    # $1 = perintah asli (string utuh)
    # $2 = perintah setelah alias expansion
    # $3 = perintah setelah ekspansi penuh (history expansion)
    echo "▶️  Menjalankan: $1"
    
    # Contoh: catat ke log
    echo "$(date +%s) $1" >> ~/.zsh_command_log
    
    # Contoh: timer
    _cmd_start_time=$EPOCHSECONDS
}
```

**Penjelasan per baris:**

| Baris | Arti |
|-------|------|
| `preexec() {` | Deklarasi hook. |
| `$1` | Perintah asli yang diketik user. |
| `$2` | Perintah setelah alias di-expand. |
| `$3` | Perintah setelah history expansion (`!!`, `!$`). |
| `$EPOCHSECONDS` | Variabel Zsh berisi Unix timestamp (detik). |
| `>> ~/.zsh_command_log` | Append ke file log. |

**Kombinasi `preexec` + `precmd` untuk timer perintah:**

```bash
preexec() {
    _cmd_start=$EPOCHSECONDS
}

precmd() {
    if [[ -n "$_cmd_start" ]]; then
        local durasi=$((EPOCHSECONDS - _cmd_start))
        (( durasi > 5 )) && echo "⏱️  Perintah memakan ${durasi}s"
        unset _cmd_start
    fi
}
```

### 5.1.2.4 — Hook Lain yang Jarang Dibahas

Ini bagian **opsional** yang jarang muncul di tutorial, tetapi penting untuk penguasaan menyeluruh.

**a) `periodic`** — dipanggil setiap `$PERIOD` detik (default 60).

```bash
periodic() {
    echo "Cek berkala: $(date)"
}
PERIOD=30   # Setiap 30 detik
```

**b) `zshexit`** — dipanggil saat shell akan keluar.

```bash
zshexit() {
    echo "Membersihkan file sementara..."
    rm -rf /tmp/zsh_temp_$$
}
```

**c) `TRAPDEBUG`** — dipanggil sebelum **setiap** perintah sederhana (sangat verbose).

```bash
TRAPDEBUG() {
    echo "DEBUG: akan menjalankan: $ZSH_DEBUG_CMD"
}
```

**d) `TRAPEXIT`** — mirip `zshexit` tapi bisa di-set per fungsi.

```bash
contoh() {
    trap 'echo "Fungsi selesai"' EXIT
    echo "Kerja..."
}
```

**e) `zsh_directory_name`** — untuk named directory (`~nama`).

```bash
zsh_directory_name() {
    if [[ "$1" == "d" && "$2" == "proyek" ]]; then
        reply=(/home/user/proyek)
    fi
}
# Sekarang bisa: cd ~proyek
```

### Terminologi Esensial 5.1.2

- **Hook**: Fungsi yang dipanggil otomatis oleh event.
- **`chpwd`**: Hook saat direktori berubah.
- **`precmd`**: Hook sebelum prompt.
- **`preexec`**: Hook sebelum perintah dieksekusi.
- **`periodic`**: Hook berkala.
- **`zshexit`**: Hook saat keluar shell.
- **`TRAPDEBUG`**: Hook debug per perintah.
- **`$PWD`**: Direktori kerja saat ini.
- **`$EPOCHSECONDS`**: Unix timestamp detik.
- **`$OLDPWD`**: Direktori sebelumnya.

### Struktur Pembelajaran Internal (Mini TOC 5.1.2)

1. Filosofi event-driven di Zsh
2. `chpwd` — use case: virtualenv, nvm, auto-ls
3. `precmd` — use case: git status, waktu, notifikasi
4. `preexec` — use case: logging, timer
5. `periodic`, `zshexit`, `TRAPDEBUG`, `TRAPEXIT` (opsional)
6. Menghindari konflik antar hook (menggunakan `add-zsh-hook`)

### Menghindari Konflik Hook: `add-zsh-hook`

Jika Anda punya banyak plugin (oh-my-zsh, prezto) yang mendefinisikan `chpwd`, hanya yang terakhir bertahan. Solusi: gunakan `add-zsh-hook`.

```bash
autoload -Uz add-zsh-hook

my_chpwd() {
    echo "Chpwd saya!"
}

add-zsh-hook chpwd my_chpwd
```

**Penjelasan:**
- `autoload -Uz add-zsh-hook`: muat fungsi `add-zsh-hook` dari `fpath`.
- `add-zsh-hook chpwd my_chpwd`: tambahkan `my_chpwd` ke daftar hook `chpwd` tanpa menimpa yang lain.

### Rekomendasi Visualisasi

> Diagram **timeline** akan sangat membantu: `[prompt] → preexec → [perintah] → precmd → [prompt]`. Tambahkan `chpwd` sebagai cabang saat `cd` dijalankan.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.0, 5.1.1.
- **Terkait**: 5.1.3 (autoload `add-zsh-hook`), 5.1.7 (profiling startup).
- **Dipakai di**: 5.3 (integrasi — misalnya hook `chpwd` untuk auto-export env).

### Sumber Referensi 5.1.2

- Zsh Hook Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
- `add-zsh-hook`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Manipulating-Hook-Functions
- Artikel: https://zsh.sourceforge.io/Guide/zshguide04.html

### Tips & Praktik Terbaik 5.1.2

- Jangan taruh perintah berat di `precmd` — shell jadi lambat.
- Gunakan `add-zsh-hook` untuk kompatibilitas dengan plugin lain.
- Selalu uji hook dengan `echo` dulu sebelum menambah logika.
- Simpan hook di file terpisah (mis. `~/.zsh/hooks.zsh`) lalu `source`.

### Potensi Kesalahan Umum 5.1.2

| Kesalahan | Solusi |
|-----------|--------|
| `precmd` lambat → prompt delay | Batasi perintah; cache hasil git |
| Hook ditimpa plugin | Gunakan `add-zsh-hook` |
| `chpwd` infinite loop (mis. `cd` di dalam `chpwd`) | Jangan `cd` di dalam `chpwd` tanpa guard |
| Lupa `local` → variabel bocor | Selalu `local` |

---

## 5.1.3 — Autoloading & `fpath`

### Deskripsi Konkret & Peran dalam Kurikulum

Autoloading adalah teknik **memuat fungsi hanya saat pertama kali dipanggil**, bukan saat shell start. Ini menghemat waktu startup, terutama jika Anda punya ratusan fungsi. Perannya: mengajarkan arsitektur modular dan optimasi.

### Konsep Kunci & Filosofi Mendalam

Bayangkan perpustakaan. Tanpa autoload, Anda harus membawa **semua buku** ke meja saat masuk (startup lambat). Dengan autoload, Anda hanya mengambil buku saat ingin membacanya (startup cepat, load on demand).

Filosofi:
1. **Lazy loading**: Muat saat dibutuhkan.
2. **Modularitas**: Setiap fungsi di file terpisah.
3. **Kompatibilitas**: Standar Zsh sejak lama.

### 5.1.3.1 — Konsep `fpath`

`fpath` adalah **array direktori** tempat Zsh mencari fungsi yang di-autoload. Mirip `$PATH` untuk executable, tapi untuk fungsi.

```bash
echo $fpath
# Output contoh:
# /usr/share/zsh/functions
# /usr/share/zsh/site-functions
# ...
```

**Menambah direktori:**

```bash
fpath=(~/.zsh/functions $fpath)
```

**Penjelasan:**
- `fpath=(...)`: assign array.
- `~/.zsh/functions`: direktori baru.
- `$fpath`: nilai lama, di-append.
- Hasil: direktori baru **di depan** (prioritas lebih tinggi).

### 5.1.3.2 — `autoload -Uz`

```bash
autoload -Uz nama_fungsi
```

**Penjelasan flag:**

| Flag | Arti |
|------|------|
| `-U` | **No alias expansion** — jangan expand alias saat memuat. |
| `-z` | **Zsh-style** — file di-compile dalam mode Zsh native (bukan KSH emulation). |
| `-X` | (Opsional) error jika fungsi tidak ditemukan. |
| `-w` | (Opsional) tandai sebagai "widget" untuk ZLE. |

**Praktik terbaik:** Selalu pakai `-Uz`.

### 5.1.3.3 — Konvensi File Fungsi

**Struktur direktori:**

```bash
~/.zsh/
├── functions/
│   ├── git-status
│   ├── mkcd
│   ├── extract
│   └── backup
└── .zshrc
```

**Isi file `~/.zsh/functions/mkcd`:**

```bash
# Fungsi: mkcd — buat direktori lalu masuk ke dalamnya
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

**Isi file `~/.zsh/functions/extract`:**

```bash
# Fungsi: extract — ekstrak berbagai format arsip
extract() {
    if [[ ! -f "$1" ]]; then
        echo "File tidak ditemukan: $1" >&2
        return 1
    fi
    case "$1" in
        *.tar.gz|*.tgz)  tar xzf "$1" ;;
        *.tar.bz2)       tar xjf "$1" ;;
        *.zip)           unzip "$1" ;;
        *.rar)           unrar x "$1" ;;
        *)               echo "Format tidak dikenal" >&2; return 1 ;;
    esac
}
```

**Di `.zshrc`:**

```bash
fpath=(~/.zsh/functions $fpath)
autoload -Uz mkcd extract git-status backup
```

### 5.1.3.4 — `autoload` vs `source`

| Aspek | `autoload` | `source` |
|-------|-----------|----------|
| Kapan dimuat | Saat pertama dipanggil | Segera saat `source` |
| Startup time | Cepat | Lambat jika banyak |
| Cocok untuk | Fungsi yang jarang dipakai | Fungsi yang selalu dipakai |
| File | Satu fungsi per file | Bisa banyak fungsi |

**Kapan pakai yang mana:**
- Fungsi yang **selalu** dipakai (mis. `ls` alias, prompt) → `source` atau definisi langsung.
- Fungsi yang **jarang** dipakai (mis. `backup`, `extract`) → `autoload`.

### Contoh Studi Kasus: Library Fungsi Pribadi

```bash
# ~/.zshrc
fpath=(~/.zsh/functions $fpath)

# Autoload semua fungsi di direktori
for f in ~/.zsh/functions/*(N:t); do
    autoload -Uz "$f"
done
```

**Penjelasan:**
- `*(N:t)`: glob dengan flag `N` (nullglob — jangan error jika kosong), `:t` (tail — ambil nama file saja).
- Loop memuat semua fungsi di direktori.

### Terminologi Esensial 5.1.3

- **`fpath`**: Array direktori pencarian fungsi.
- **`autoload`**: Tandai fungsi untuk dimuat saat dipanggil.
- **Lazy loading**: Memuat saat dibutuhkan.
- **`-Uz`**: Flag standar untuk `autoload`.
- **Nullglob (`N`)**: Glob flag agar tidak error jika tidak ada match.

### Struktur Pembelajaran Internal (Mini TOC 5.1.3)

1. Filosofi lazy loading
2. `fpath` — array direktori
3. `autoload -Uz` — flag dan artinya
4. Konvensi file & direktori
5. `autoload` vs `source`
6. Autoload massal dengan glob
7. Kompilasi fungsi (`.zwc`) untuk kecepatan

### Autoload + Kompilasi (`.zwc`)

Zsh bisa meng-compile fungsi jadi bytecode (`.zwc`) untuk load lebih cepat.

```bash
# Compile semua fungsi di direktori
autoload -Uz zrecompile
zrecompile -p ~/.zsh/functions/*
```

**Penjelasan:**
- `zrecompile`: fungsi bawaan Zsh untuk compile.
- `-p`: preserve (jaga file asli).
- Hasil: file `.zwc` di samping file asli.

### Rekomendasi Visualisasi

> Diagram **pohon direktori + alur pencarian**: `fpath` sebagai daftar kotak, Zsh mencari dari kiri ke kanan. Ini membantu memahami prioritas.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.0.
- **Terkait**: 5.1.2 (`add-zsh-hook` di-autoload), 5.1.7 (profiling).
- **Dipakai di**: 5.3 (fungsi integrasi API).

### Sumber Referensi 5.1.3

- Zsh Autoloading: https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions
- `fpath`: https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-fpath
- `zrecompile`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html

### Tips & Praktik Terbaik 5.1.3

- Selalu pakai `autoload -Uz`.
- Satu fungsi per file, nama file = nama fungsi.
- Compile dengan `zrecompile` untuk startup lebih cepat.
- Jangan autoload fungsi yang selalu dipakai — tidak ada gunanya.

### Potensi Kesalahan Umum 5.1.3

| Kesalahan | Solusi |
|-----------|--------|
| Lupa tambah `fpath` → fungsi tidak ditemukan | Selalu set `fpath` sebelum `autoload` |
| Nama file ≠ nama fungsi | Samakan persis |
| Fungsi tidak ter-compile | Jalankan `zrecompile` |
| Pakai `autoload` tanpa `-Uz` → perilaku aneh | Selalu `-Uz` |

---

## 5.1.4 — Parameter Expansion Flags

### Deskripsi Konkret & Peran dalam Kurikulum

Parameter expansion flags adalah **modifier** dalam `${(flag)var}` yang memungkinkan manipulasi string/array tanpa perintah eksternal (`sed`, `awk`). Ini adalah fitur paling kuat Zsh dan pembeda utama dari Bash. Perannya: mengajarkan manipulasi data native.

### Konsep Kunci & Filosofi Mendalam

Bayangkan Anda punya **pisau Swiss Army** untuk data. Daripada memanggil `sed`, `awk`, `cut` berkali-kali (proses baru = lambat), Anda pakai flag bawaan Zsh (in-process = cepat).

Filosofi:
1. **In-process**: Tidak spawn process baru.
2. **Komposabel**: Flag bisa digabung: `(j:,::)`.
3. **Ekspresif**: Kode lebih pendek dan jelas.

### 5.1.4.1 — Filosofi `${(flag)var}`

**Bentuk umum:**

```bash
${(flag)variable}
${(flag1)(flag2)variable}
```

**Penjelasan:**
- `${...}`: parameter expansion.
- `(flag)`: modifier.
- `variable`: nama variabel.
- Bisa juga: `${(flag)${ekspresi}}` — nested.

### 5.1.4.2 — `(j)`, `(s)`, `(k)`, `(v)`

**`(j:sep:)` — Join array jadi string**

```bash
local -a arr=(satu dua tiga)
echo ${(j:,:)arr}       # satu,dua,tiga
echo ${(j: - :)arr}     # satu - dua - tiga
echo ${(j::)arr}        # satuduatiga
```

| Bagian | Arti |
|--------|------|
| `j` | Join |
| `:,:` | Separator = `,` |
| `arr` | Array yang di-join |

**`(s:sep:)` — Split string jadi array**

```bash
local str="satu,dua,tiga"
local -a arr=(${(s:,:)str})
echo $arr[1]   # satu
echo $arr[2]   # dua
```

**`(k)` — Keys dari associative array**

```bash
local -A map
map=(apel merah jeruk oranye)
echo ${(k)map}    # apel jeruk (keys)
```

**`(v)` — Values dari associative array**

```bash
echo ${(v)map}    # merah oranye
```

### 5.1.4.3 — Flag Lain Penting

**`(q)` — Quote untuk shell**

```bash
local str="hello world"
echo ${(q)str}    # 'hello world' (siap di-eval)
```

**`(Q)` — Unquote**

```bash
local quoted="'hello world'"
echo ${(Q)quoted}  # hello world
```

**`(L)` — Lowercase**

```bash
echo ${(L)var}    # huruf kecil
```

**`(U)` — Uppercase**

```bash
echo ${(U)var}    # HURUF BESAR
```

**`(C)` — Capitalize**

```bash
echo ${(C)var}    # Huruf Awal Kapital
```

**`(z)` — Split seperti shell parsing**

```bash
local cmd="ls -la /tmp"
local -a parts=(${(z)cmd})
echo $parts[1]   # ls
echo $parts[2]   # -la
```

**`(f)` — Split per baris**

```bash
local multiline=$'baris1\nbaris2\nbaris3'
local -a lines=(${(f)multiline})
echo $lines[1]   # baris1
```

**`(o)` — Sort ascending**

```bash
local -a arr=(c a b)
echo ${(o)arr}   # a b c
```

**`(O)` — Sort descending**

```bash
echo ${(O)arr}   # c b a
```

**`(u)` — Unique**

```bash
local -a arr=(a b a c b)
echo ${(u)arr}   # a b c
```

**`(n)` — Numeric sort**

```bash
local -a arr=(10 2 30 1)
echo ${(on)arr}  # 1 2 10 30
```

**Kombinasi flag:**

```bash
local -a arr=(B a C b A c)
echo ${(ou)arr}      # a b c (sort + unique)
echo ${(Oa)arr}      # c b a C B A (sort descending, case-sensitive)
echo ${(L)${(j:,:)arr}}  # b,a,c,b,a,c (lowercase + join)
```

### Contoh Studi Kasus: Parse CSV Sederhana

```bash
#!/bin/zsh
parse_csv() {
    local line="$1"
    local -a fields=(${(s:,:)line})
    for i in {1..$#fields}; do
        echo "Field $i: $fields[$i]"
    done
}

parse_csv "Budi,25,Jakarta,Programmer"
```

**Output:**
```bash
Field 1: Budi
Field 2: 25
Field 3: Jakarta
Field 4: Programmer
```

### Terminologi Esensial 5.1.4

- **Parameter expansion**: `${...}`.
- **Flag**: Modifier di dalam `(...)`.
- **Join (`j`)**: Gabung array jadi string.
- **Split (`s`)**: Pecah string jadi array.
- **Keys (`k`)**: Kunci associative array.
- **Values (`v`)**: Nilai associative array.
- **Quote (`q`)**: Bungkus agar aman di shell.
- **Unquote (`Q`)**: Lepas quote.

### Struktur Pembelajaran Internal (Mini TOC 5.1.4)

1. Filosofi `${(flag)var}`
2. `(j)`, `(s)` — join & split
3. `(k)`, `(v)` — associative array
4. `(q)`, `(Q)` — quote/unquote
5. `(L)`, `(U)`, `(C)` — case conversion
6. `(z)`, `(f)` — parsing
7. `(o)`, `(O)`, `(u)`, `(n)` — sort & unique
8. Kombinasi flag
9. Nested expansion

### Rekomendasi Visualisasi

> Tabel **"flag → efek → contoh"** akan sangat membantu. Visualisasi **transformasi string** (input → flag → output) juga berguna.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.0.
- **Terkait**: 5.1.5 (array), 5.1.6 (assoc array).
- **Dipakai di**: 5.3 (parsing JSON, CSV).

### Sumber Referensi 5.1.4

- Zsh Parameter Expansion Flags: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion-Flags
- Cheat sheet: https://gist.github.com/ClementNerma/1dd94cb0f1884b9c1d05e4a02d0c2c4a

### Tips & Praktik Terbaik 5.1.4

- Hafalkan flag yang sering dipakai: `j`, `s`, `k`, `v`, `q`, `L`, `U`.
- Gunakan `${(q)var}` sebelum `eval` untuk keamanan.
- Kombinasikan flag untuk operasi kompleks dalam satu baris.
- Untuk parsing berat, tetap pakai `awk`/`jq` — flag Zsh untuk kasus sederhana.

### Potensi Kesalahan Umum 5.1.4

| Kesalahan | Solusi |
|-----------|--------|
| Lupa tanda kurung: `$j:,:arr` | Selalu `${(j:,:)arr}` |
| Flag case-sensitive: `(J)` bukan `(j)` | Perhatikan huruf besar/kecil |
| Separator multi-karakter | Gunakan `(j:,:)` atau `(j:SEP:)` |
| Nested expansion salah | Gunakan `${(L)${(j:,:)arr}}` |

---

## 5.1.5 — Manipulasi Array Lanjutan

### Deskripsi Konkret & Peran dalam Kurikulum

Zsh memiliki array **1-indexed** (bukan 0-indexed seperti Bash/Python), dan mendukung slicing, filtering, dan operasi lanjutan. Perannya: mengajarkan struktur data native Zsh.

### Konsep Kunci & Filosofi Mendalam

Array Zsh seperti **deretan kotak bernomor yang dimulai dari 1**. Kotak 0 = nama array itu sendiri (atau elemen terakhir di beberapa konteks). Ini membingungkan pemula, tapi konsisten dengan tradisi shell.

### Sintaks Dasar

```bash
# Deklarasi
local -a arr
arr=(satu dua tiga empat lima)

# Akses
echo $arr[1]       # satu (1-indexed!)
echo $arr[-1]      # lima (dari belakang)
echo $arr[2,4]     # dua tiga empat (slice)
echo $#arr         # 5 (jumlah elemen)
echo $arr[@]       # semua elemen
echo $arr[*]       # semua sebagai satu string

# Modifikasi
arr[1]="SATU"      # ganti elemen
arr+=(enam)        # append
arr[3]=()          # hapus elemen 3
arr[2,4]=()        # hapus elemen 2–4

# Splice (sisipkan)
arr[2,0]=(baru)    # sisipkan 'baru' di posisi 2
```

### Operasi Lanjutan

**Filter dengan glob:**

```bash
local -a files=(*.txt)
echo ${(M)files:#*.md}   # hanya yang match *.md
echo ${files:#*.txt}     # hapus yang match *.txt
```

**Penjelasan:**
- `${(M)arr:#pattern}` — keep yang match.
- `${arr:#pattern}` — remove yang match.

**Map/filter dengan `(#b)` dan backreference:**

```bash
local -a arr=(a1 b2 c3 d4)
for item in $arr; do
    if [[ $item =~ '([a-z])([0-9])' ]]; then
        echo "Huruf: $match[1], Angka: $match[2]"
    fi
done
```

**Penjelasan:**
- `=~` — regex match.
- `$match[1]`, `$match[2]` — grup tangkapan.

**Iterasi aman:**

```bash
# Cara 1: for-in
for item in "${arr[@]}"; do
    echo "$item"
done

# Cara 2: index
for i in {1..$#arr}; do
    echo "$i: $arr[$i]"
done

# Cara 3: while dengan shift
local -a copy=("${arr[@]}")
while (( $#copy )); do
    echo "$copy[1]"
    shift copy
done
```

### Contoh Studi Kasus: Deduplikasi & Sort

```bash
#!/bin/zsh
local -a log_lines=(
    "2024-01-01 ERROR foo"
    "2024-01-01 INFO bar"
    "2024-01-02 ERROR baz"
    "2024-01-01 ERROR foo"
)

# Ambil level unik
local -a levels=(${(u)${(f)log_lines}[2]})
echo "Level unik: $levels"

# Filter ERROR saja
local -a errors=(${(M)log_lines:#*ERROR*})
echo "Jumlah error: $#errors"
```

### Terminologi Esensial 5.1.5

- **1-indexed**: Array Zsh dimulai dari 1.
- **Slice**: `arr[2,4]` — ambil sebagian.
- **Splice**: `arr[2,0]=(x)` — sisipkan.
- **Glob filter**: `${arr:#pattern}`.
- **`${(M)arr:#pat}`**: Keep match.
- **`${(u)arr}`**: Unique.

### Struktur Pembelajaran Internal (Mini TOC 5.1.5)

1. Array 1-indexed — perbedaan dari Bash
2. Akses, slice, negatif index
3. Modifikasi: replace, append, delete, splice
4. Filter glob `${arr:#pat}`
5. Iterasi: for-in, index, while-shift
6. Array multidimensi (emulasi)

### Rekomendasi Visualisasi

> Diagram **kotak bernomor 1..N** dengan panah untuk slice/splice. Ini sangat membantu memahami 1-indexing.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.0, 5.1.4.
- **Terkait**: 5.1.6 (assoc array).
- **Dipakai di**: 5.3 (parsing data).

### Sumber Referensi 5.1.5

- Zsh Arrays: https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters
- Array manipulation: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Array-Subscript-Flags

### Tips & Praktik Terbaik 5.1.5

- Ingat: 1-indexed.
- Pakai `"${arr[@]}"` untuk iterasi aman.
- `${(u)arr}` untuk dedup.
- `${(o)arr}` / `${(O)arr}` untuk sort.

### Potensi Kesalahan Umum 5.1.5

| Kesalahan | Solusi |
|-----------|--------|
| Pakai `$arr[0]` → kosong | Mulai dari `$arr[1]` |
| `$arr` tanpa `[@]` → hanya elemen 1 | Pakai `$arr[@]` |
| Lupa kutip → spasi pecah | `"${arr[@]}"` |

---

## 5.1.6 — Associative Array & Iterasi

### Deskripsi Konkret & Peran dalam Kurikulum

Associative array (map/dictionary) memetakan **key → value**. Perannya: mengajarkan struktur data key-value native Zsh.

### Konsep Kunci & Filosofi Mendalam

Bayangkan **buku telepon**: Anda cari nomor berdasarkan nama. Associative array persis begitu — akses O(1) berdasarkan key.

### Sintaks Dasar

```bash
# Deklarasi
local -A map
map=(apel merah jeruk oranye mangga hijau)

# Akses
echo $map[apel]      # merah
echo ${map[jeruk]}   # oranye

# Tambah/modifikasi
map[pisang]="kuning"

# Hapus
unset "map[apel]"

# Cek key ada
if (( ${+map[jeruk]} )); then
    echo "Key jeruk ada"
fi

# Keys & values
echo ${(k)map}       # semua keys
echo ${(v)map}       # semua values
echo ${(kv)map}      # keys dan values bergantian
```

### Iterasi

```bash
# Iterasi key
for key in ${(k)map}; do
    echo "$key → $map[$key]"
done

# Iterasi value
for val in ${(v)map}; do
    echo "$val"
done

# Iterasi key-value
for key val in ${(kv)map}; do
    echo "$key = $val"
done
```

**Penjelasan `(kv)`:**
- Menghasilkan array: `key1 value1 key2 value2 ...`
- `for key val in ...` mengambil dua per iterasi.

### Contoh Studi Kasus: Konfigurasi

```bash
#!/bin/zsh
typeset -A config
config=(
    host "localhost"
    port "5432"
    user "admin"
    db "produksi"
)

# Bangun connection string
local conn="postgres://${config[user]}@${config[host]}:${config[port]}/${config[db]}"
echo "$conn"
```

### Terminologi Esensial 5.1.6

- **Associative array**: Map key-value.
- **`-A`**: Flag deklarasi assoc array.
- **`${+map[key]}`**: Cek keberadaan key (1 jika ada).
- **`(k)`, `(v)`, `(kv)`**: Keys, values, key-value pairs.

### Struktur Pembelajaran Internal (Mini TOC 5.1.6)

1. Filosofi map
2. Deklarasi `local -A`
3. Akses, tambah, hapus
4. Cek keberadaan key
5. Iterasi (key, value, kv)
6. Nested assoc array (emulasi)
7. Sort keys

### Sort Keys

```bash
for key in ${(ok)map}; do
    echo "$key = $map[$key]"
done
```

**Penjelasan:** `(o)` sort, `(k)` keys → sort keys.

### Rekomendasi Visualisasi

> Diagram **tabel dua kolom** (key | value) dengan panah. Visualisasi **hash function** (key → index) akan membantu untuk yang ingin mendalami.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.4, 5.1.5.
- **Dipakai di**: 5.3 (parsing JSON ke map).

### Sumber Referensi 5.1.6

- Zsh Associative Arrays: https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters

### Tips & Praktik Terbaik 5.1.6

- Selalu `local -A` di dalam fungsi.
- Pakai `${+map[key]}` untuk cek.
- Untuk nested, gunakan key gabungan seperti `parent:child`.

### Potensi Kesalahan Umum 5.1.6

| Kesalahan | Solusi |
|-----------|--------|
| Lupa `-A` → jadi array biasa | Selalu `local -A` |
| Pakai `$map[key]` tanpa `${}` di string | Gunakan `${map[key]}` |
| Key dengan spasi | Quote: `map["my key"]="val"` |

---

## 5.1.7 — Profiling Startup dengan `zprof` *(Materi Tambahan Audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

`zprof` adalah modul bawaan Zsh untuk mengukur **waktu eksekusi fungsi saat startup**. Ini penting karena autoloading & hook sering memperlambat shell tanpa disadari.

### Sintaks Dasar

```bash
# Di paling atas ~/.zshrc
zmodload zsh/zprof

# ... definisi fungsi, hook, dll ...

# Di paling bawah ~/.zshrc
zprof
```

**Output contoh:**
```bash
num  calls                time                       self            name
 1)    1          45.20    45.20   30.15%     45.20    45.20   30.15%  compinit
 2)    1          20.10    20.10   13.40%     20.10    20.10   13.40%  nvm_load
 ...
```

**Penjelasan kolom:**
- `num`: urutan.
- `calls`: berapa kali dipanggil.
- `time`: total waktu (ms).
- `self`: waktu di fungsi itu sendiri (tanpa anak).
- `name`: nama fungsi.

### Tips

- Jalankan `zsh -i -c exit` untuk mengukur startup.
- Gunakan `time zsh -i -c exit` untuk total.
- Target startup ideal: < 100ms.

### Sumber Referensi

- Zsh Profiling: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#The-zsh_002fzprof-Module

---

## Penutup Modul 5.1

### Rangkuman Keterampilan

Setelah Modul 5.1, Anda harus mampu:
- Menulis fungsi Zsh dengan scope yang benar.
- Menggunakan anonymous function untuk isolasi.
- Memasang hook (`chpwd`, `precmd`, `preexec`) dengan `add-zsh-hook`.
- Membuat library fungsi dengan `fpath` + `autoload`.
- Memanipulasi string/array dengan parameter expansion flags.
- Mengelola array & associative array.
- Mengukur startup dengan `zprof`.

### Visualisasi Keseluruhan Modul 5.1

> Diagram **arsitektur shell Zsh** akan sangat membantu:
> ```
> [.zshrc]
>    │
>    ├─► fpath += ~/.zsh/functions
>    ├─► autoload -Uz func1 func2
>    ├─► add-zsh-hook chpwd my_chpwd
>    │
>    └─► [Shell siap]
>            │
>            ├─► preexec (sebelum perintah)
>            ├─► [perintah dieksekusi]
>            ├─► precmd (sebelum prompt)
>            └─► [prompt]
> ```

### Referensi Lengkap Modul 5.1

- Zsh Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html
- Zsh Expansion: https://zsh.sourceforge.io/Doc/Release/Expansion.html
- Zsh Parameters: https://zsh.sourceforge.io/Doc/Release/Parameters.html
- Zsh Hook Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
- `add-zsh-hook`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Manipulating-Hook-Functions
- `zprof`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#The-zsh_002fzprof-Module
- Zsh Guide (Peter Stephenson): https://zsh.sourceforge.io/Guide/
- Scripting OSX — Moving to Zsh: https://scriptingosx.com/2019/06/moving-to-zsh-part-6-functions/

---

## ✅ Daftar yang telah diselesaikan

Modul **5.1** sudah selesai dengan cakupan:
- ✅ Pondasi fungsi (tambahan audit)
- ✅ Anonymous function
- ✅ Hook (`chpwd`, `precmd`, `preexec`, + hook jarang)
- ✅ Autoloading & `fpath`
- ✅ Parameter expansion flags
- ✅ Array & associative array lanjutan
- ✅ Profiling `zprof` (tambahan audit)

---

### Pada Modul 5.2 kita akan membahas:
- Testing manual tanpa framework (jembatan)
- ShellSpec (instalasi, sintaks BDD, matcher)
- ZUnit
- zsh-test-runner
- CI/CD (GitHub Actions)
- Code coverage (`kcov`)
- Diagram piramida testing

---

# FASE 5 — MODUL 5.2: Testing dan Quality Assurance

<details>
  <summary>📃 Daftar Isi</summary>

---

## 📑 Mini-Daftar Isi Modul 5.2

1. **5.2.0 — Mengapa Testing Script Shell Penting** *(Pondasi Filosofis)*
2. **5.2.1 — Testing Manual Tanpa Framework** *(Jembatan Audit)*
3. **5.2.2 — ShellSpec: BDD Testing Framework**
   - 5.2.2.1 Instalasi & Setup
   - 5.2.2.2 Struktur Test: `Describe`, `It`, `When`, `The`
   - 5.2.2.3 Matcher: `eq`, `include`, `be success`, dll.
   - 5.2.2.4 Mocking & Stubbing
   - 5.2.2.5 Code Coverage dengan ShellSpec
   - 5.2.2.6 CI/CD Integration
4. **5.2.3 — ZUnit: Unit Testing Khusus Zsh**
5. **5.2.4 — zsh-test-runner: Alternatif Ringan**
6. **5.2.5 — Code Coverage dengan `kcov`**
7. **5.2.6 — Piramida Testing untuk Script Shell**
8. **5.2.7 — CI/CD untuk Script Shell** *(GitHub Actions)*
9. **Tips, Kesalahan Umum, Referensi**

</details>

---

## 5.2.0 — Mengapa Testing Script Shell Penting

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada di kurikulum asli** Anda, tetapi saya tambahkan sebagai pondasi filosofis. Sebelum masuk ke alat testing, pembaca harus memahami **mengapa** testing script shell itu krusial. Tanpa ini, framework seperti ShellSpec hanya jadi alat tanpa makna.

### Konsep Kunci & Filosofi Mendalam

**Analogi sederhana:** Bayangkan Anda membangun jembatan. Tanpa uji beban, jembatan mungkin berdiri hari ini, tapi runtuh saat ada truk lewat. Script shell sama — tanpa test, script mungkin "jalan di laptop saya", tapi gagal di production saat environment berbeda.

**Tiga alasan utama testing script shell:**

1. **Refactoring aman.** Tanpa test, setiap perubahan adalah risiko. Dengan test, Anda bisa ubah kode dengan percaya diri — jika test tetap lulus, perilaku tidak berubah.
2. **Dokumentasi hidup.** Test menunjukkan cara script digunakan. Lebih baik dari komentar yang basi.
3. **Deteksi regresi dini.** Bug yang ditemukan saat development jauh lebih murah diperbaiki daripada saat production.

**Filosofi shell testing:**
- Script shell sering dianggap "second-class citizen" — ditulis cepat, tanpa test. Ini bahaya.
- Script shell sering **mengelola data kritikal** (deployment, backup, migrasi database).
- Script shell sulit di-debug (tidak ada IDE, tidak ada debugger visual).

### Sintaks Dasar / Ilustrasi Konsep

**Contoh script tanpa test — berbahaya:**

```bash
#!/bin/zsh
# backup.sh — tanpa test
backup() {
    local src="$1"
    local dest="$2"
    tar czf "$dest/backup-$(date +%Y%m%d).tar.gz" "$src"
    echo "Backup selesai"
}
```

**Pertanyaan yang tidak terjawab:**
- Apa yang terjadi jika `$src` tidak ada?
- Apa yang terjadi jika `$dest` tidak writable?
- Apa yang terjadi jika tanggal sama di dua run berbeda?
- Apakah exit code benar?

**Dengan test, semua pertanyaan itu dijawab:**

```bash
# spec/backup_spec.sh
Describe 'backup'
    It 'gagal jika source tidak ada'
        When call backup /tidak/ada /tmp
        The status should be failure
        The stderr should include 'source tidak ditemukan'
    End

    It 'berhasil membackup direktori'
        setup() { mkdir -p /tmp/src; echo data > /tmp/src/file; }
        Before 'setup'

        When call backup /tmp/src /tmp/dest
        The status should be success
        The output should include 'Backup selesai'
    End
End
```

### Terminologi Esensial 5.2.0

- **Regresi**: Bug yang muncul kembali setelah diperbaiki, atau bug baru akibat perubahan.
- **Refactoring**: Mengubah struktur kode tanpa mengubah perilaku.
- **Test suite**: Kumpulan test.
- **Test case**: Satu skenario pengujian.
- **Assertion**: Pernyataan yang harus benar agar test lulus.

### Struktur Pembelajaran Internal (Mini TOC 5.2.0)

1. Analogi jembatan — mengapa test penting
2. Tiga alasan: refactoring, dokumentasi, regresi
3. Bahaya script shell tanpa test
4. Contoh: sebelum vs sesudah test
5. Kapan **tidak** perlu test (script sekali pakai)

### Rekomendasi Visualisasi

> Diagram **biaya bug** (cost of bug) akan sangat membantu: sumbu X = fase (development → testing → production), sumbu Y = biaya perbaikan. Kurva naik eksponensial. Ini menunjukkan mengapa test dini penting.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1 (fungsi dasar — test menguji fungsi).
- **Terkait**: 5.2.1 (testing manual), 5.2.2 (ShellSpec).
- **Dipakai di**: 5.3 (integrasi — test script integrasi API).

### Sumber Referensi 5.2.0

- "Why Test Shell Scripts?" — https://github.com/koalaman/shellcheck/wiki/Why-Test
- Google Testing Blog: https://testing.googleblog.com/
- "The Cost of Bugs" — https://www.ibm.com/docs/en/rational-clearquest

---

## 5.2.1 — Testing Manual Tanpa Framework *(Jembatan Audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada di kurikulum asli** Anda, tetapi saya tambahkan sebagai jembatan. Sebelum pakai ShellSpec/ZUnit, pembaca harus paham **bagaimana test bekerja secara manual**. Ini membangun intuisi tentang apa yang framework lakukan di balik layar.

### Konsep Kunci & Filosofi Mendalam

Testing manual = menulis `if` yang memeriksa apakah output/exit code sesuai harapan. Framework hanya **mengotomatisasi** pola ini.

**Filosofi:** Jangan lompat ke alat sebelum paham konsep. Framework seperti ShellSpec hanyalah lapisan di atas `[[ ]]`, `$?`, dan `$(...)`.

### Sintaks Dasar

**Pola test manual paling sederhana:**

```bash
#!/bin/zsh

# Fungsi yang akan diuji
tambah() {
    echo $(( $1 + $2 ))
}

# Test manual
test_tambah() {
    local hasil=$(tambah 2 3)
    if [[ "$hasil" == "5" ]]; then
        echo "✅ PASS: tambah 2 3 = 5"
        return 0
    else
        echo "❌ FAIL: tambah 2 3 = $hasil (harusnya 5)"
        return 1
    fi
}

test_tambah
```

**Penjelasan per baris:**

| Baris | Arti |
|-------|------|
| `tambah() {` | Fungsi yang diuji. |
| `echo $(( $1 + $2 ))` | Aritmetika Zsh. |
| `local hasil=$(tambah 2 3)` | Tangkap output fungsi. |
| `[[ "$hasil" == "5" ]]` | Assertion: cek apakah hasil sama dengan 5. |
| `return 0` | Sukses. |
| `return 1` | Gagal. |

**Test manual untuk exit code:**

```bash
cek_file() {
    [[ -f "$1" ]] && return 0 || return 1
}

test_cek_file_ada() {
    touch /tmp/test_file
    if cek_file /tmp/test_file; then
        echo "✅ PASS: file ada"
    else
        echo "❌ FAIL: file ada tapi cek_file return gagal"
    fi
    rm /tmp/test_file
}

test_cek_file_tidak_ada() {
    if cek_file /tmp/tidak_ada_xyz; then
        echo "❌ FAIL: file tidak ada tapi cek_file return sukses"
    else
        echo "✅ PASS: file tidak ada"
    fi
}
```

**Test manual untuk stderr:**

```bash
fungsi_error() {
    echo "pesan error" >&2
    return 1
}

test_error_message() {
    local stderr_output
    stderr_output=$(fungsi_error 2>&1 >/dev/null)
    if [[ "$stderr_output" == *"error"* ]]; then
        echo "✅ PASS: stderr mengandung 'error'"
    else
        echo "❌ FAIL: stderr = '$stderr_output'"
    fi
}
```

**Penjelasan:**
- `2>&1 >/dev/null`: Redirect stderr ke stdout, lalu stdout ke `/dev/null`. Hasilnya hanya stderr yang tertangkap.
- `*"error"*`: Pattern matching (glob) — cek apakah string mengandung "error".

### Contoh Studi Kasus: Test Suite Manual

```bash
#!/bin/zsh
# test_suite.sh — tanpa framework

PASS=0
FAIL=0

assert_eq() {
    local actual="$1"
    local expected="$2"
    local msg="$3"
    if [[ "$actual" == "$expected" ]]; then
        ((PASS++))
        echo "  ✅ $msg"
    else
        ((FAIL++))
        echo "  ❌ $msg (dapat: '$actual', harap: '$expected')"
    fi
}

# --- Test cases ---
echo "Testing kalkulator:"

assert_eq "$(tambah 2 3)" "5" "tambah 2+3"
assert_eq "$(tambah -1 1)" "0" "tambah -1+1"
assert_eq "$(tambah 0 0)" "0" "tambah 0+0"

echo ""
echo "Hasil: $PASS pass, $FAIL fail"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
```

**Penjelasan:**
- `((PASS++))`: Aritmetika increment.
- `[[ $FAIL -eq 0 ]]`: Cek apakah tidak ada fail.
- `exit 0` / `exit 1`: Exit code untuk CI.

### Terminologi Esensial 5.2.1

- **Assertion**: Pernyataan yang harus benar.
- **Test harness**: Infrastruktur yang menjalankan test.
- **Fixture**: Data/setup yang diperlukan test.
- **Setup/Teardown**: Kode sebelum/sesudah test.
- **Exit code**: 0 = sukses, non-0 = gagal.

### Struktur Pembelajaran Internal (Mini TOC 5.2.1)

1. Pola `if [[ ... ]]` untuk assertion
2. Test exit code dengan `$?`
3. Test stdout dengan `$(...)`
4. Test stderr dengan `2>&1 >/dev/null`
5. Test suite manual dengan counter PASS/FAIL
6. Setup/teardown manual

### Rekomendasi Visualisasi

> Diagram **alur test manual**: `[setup] → [jalankan fungsi] → [tangkau output] → [assertion] → [report]`. Ini adalah pola yang sama yang dipakai framework.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1 (fungsi).
- **Terkait**: 5.2.2 (ShellSpec mengotomatisasi pola ini).
- **Dipakai di**: 5.3 (test integrasi API).

### Sumber Referensi 5.2.1

- "Testing Bash Scripts" — https://dev.to/melezhik/testing-bash-scripts-3d5f
- "How to Test Shell Scripts" — https://www.baeldung.com/linux/testing-shell-scripts

### Tips & Praktik Terbaik 5.2.1

- Mulai dari test manual untuk memahami konsep.
- Setelah paham, pindah ke framework untuk otomatisasi.
- Selalu bersihkan file sementara di teardown.
- Gunakan `trap` untuk cleanup otomatis.

### Potensi Kesalahan Umum 5.2.1

| Kesalahan | Solusi |
|-----------|--------|
| Lupa cleanup → test saling mengganggu | Selalu teardown |
| `$?` dibaca setelah perintah lain | Simpan `$?` ke variabel dulu |
| Test bergantung pada environment | Isolasi dengan `mktemp -d` |
| Tidak cek exit code | Selalu cek `$?` atau `return` |

---

## 5.2.2 — ShellSpec: BDD Testing Framework

### Deskripsi Konkret & Peran dalam Kurikulum

ShellSpec adalah **framework testing BDD (Behavior-Driven Development)** untuk shell — mendukung dash, bash, ksh, zsh, dan semua shell POSIX. Ini adalah framework paling populer untuk testing script shell saat ini. Perannya: mengajarkan testing profesional dengan sintaks yang mirip bahasa manusia.

### Konsep Kunci & Filosofi Mendalam

**BDD (Behavior-Driven Development):** Pendekatan testing di mana test ditulis dalam bahasa yang **mendekati bahasa manusia**, fokus pada **perilaku** yang diharapkan, bukan implementasi.

**Filosofi ShellSpec:**
1. **Test sebagai dokumentasi.** Test ShellSpec dibaca seperti cerita: "Describe kalkulator, It menjumlahkan dua angka, When call tambah 2 3, The output should eq 5."
2. **Isolasi.** Setiap test berjalan di sub-shell, tidak saling mengganggu.
3. **Portabilitas.** Bisa jalan di shell apa pun.
4. **Mocking native.** Bisa mengganti fungsi dengan mock.

### 5.2.2.1 — Instalasi & Setup

```bash
# Metode 1: Install script (universal)
curl -fsSL https://git.io/shellspec | sh

# Metode 2: Homebrew
brew install shellspec

# Metode 3: Manual git clone
git clone https://github.com/shellspec/shellspec.git ~/.shellspec
export PATH="$HOME/.shellspec:$PATH"
```

**Verifikasi:**

```bash
shellspec --version
# Output: ShellSpec 0.28.1
```

**Struktur proyek:**

```bash
proyek/
├── lib/
│   └── kalkulator.sh        # kode yang diuji
├── spec/
│   ├── kalkulator_spec.sh   # test
│   └── spec_helper.sh       # helper (opsional)
└── .shellspec               # konfigurasi (opsional)
```

### 5.2.2.2 — Struktur Test: `Describe`, `It`, `When`, `The`

**Sintaks lengkap:**

```bash
#!/usr/bin/env shellspec
# spec/kalkulator_spec.sh

Describe 'kalkulator'
    Describe 'tambah'
        It 'menjumlahkan dua angka positif'
            When call tambah 2 3
            The output should eq 5
            The status should be success
        End

        It 'menangani angka negatif'
            When call tambah -1 1
            The output should eq 0
        End
    End

    Describe 'bagi'
        It 'membagi dua angka'
            When call bagi 10 2
            The output should eq 5
        End

        It 'gagal jika pembagi nol'
            When call bagi 10 0
            The status should be failure
            The stderr should include 'tidak bisa dibagi nol'
        End
    End
End
```

**Penjelasan setiap block:**

| Block | Arti |
|-------|------|
| `Describe '...'` | Grup test (konteks). Bisa nested. |
| `It '...'` | Satu test case. |
| `When call ...` | Cara memanggil fungsi yang diuji. |
| `The output should eq ...` | Assertion pada stdout. |
| `The status should be success` | Assertion pada exit code. |
| `The stderr should include ...` | Assertion pada stderr. |
| `End` | Penutup blok (Describe/It). |

**Cara menjalankan:**

```bash
# Jalankan semua test
shellspec

# Jalankan file spesifik
shellspec spec/kalkulator_spec.sh

# Jalankan dengan format dokumentasi
shellspec --format documentation

# Jalankan test yang match pattern
shellspec --example 'menjumlahkan'
```

**Output contoh:**

```bash
kalkulator
  tambah
    ✓ menjumlahkan dua angka positif
    ✓ menangani angka negatif
  bagi
    ✓ membagi dua angka
    ✓ gagal jika pembagi nol

4 examples, 0 failures
```

### 5.2.2.3 — Matcher: `eq`, `include`, `be success`, dll.

**Matcher adalah "kata kerja" yang membandingkan hasil dengan harapan.**

| Matcher | Arti | Contoh |
|---------|------|--------|
| `eq` | Sama persis | `The output should eq 5` |
| `include` | Mengandung substring | `The output should include 'sukses'` |
| `start with` | Dimulai dengan | `The output should start with 'OK'` |
| `end with` | Diakhiri dengan | `The output should end with 'selesai'` |
| `be success` | Exit code 0 | `The status should be success` |
| `be failure` | Exit code non-0 | `The status should be failure` |
| `be exist` | File ada | `The file should be exist` |
| `be empty` | String kosong | `The output should be empty` |
| `be present` | Tidak kosong | `The output should be present` |
| `match` | Regex match | `The output should match '^[0-9]+$'` |
| `satisfy` | Predikat kustom | `The value should satisfy 'is_number'` |

**Contoh penggunaan lanjutan:**

```bash
It 'output adalah angka'
    When call hitung 10 20
    The output should match '[0-9]+'
End

It 'file backup dibuat'
    When call backup /tmp/src /tmp/dest
    The file /tmp/dest/backup-*.tar.gz should be exist
End
```

### 5.2.2.4 — Mocking & Stubbing

**Mocking:** Mengganti fungsi/command dengan versi palsu untuk test.

```bash
Describe 'kirim_email'
    # Mock curl
    curl() {
        echo '{"status": "ok"}'
        return 0
    }

    It 'mengirim email via API'
        When call kirim_email "test@example.com" "Halo"
        The status should be success
        The output should include 'Email terkirim'
    End
End
```

**Stubbing dengan `Before`:**

```bash
Describe 'proses_data'
    setup() {
        # Buat file sementara
        echo "data test" > /tmp/test_input.txt
    }

    cleanup() {
        rm -f /tmp/test_input.txt /tmp/test_output.txt
    }

    Before 'setup'
    After 'cleanup'

    It 'memproses file input'
        When call proses_data /tmp/test_input.txt /tmp/test_output.txt
        The status should be success
        The file /tmp/test_output.txt should be exist
    End
End
```

**Penjelasan:**
- `Before 'setup'`: Jalankan `setup` sebelum setiap `It`.
- `After 'cleanup'`: Jalankan `cleanup` setelah setiap `It`.
- Bisa juga `BeforeAll` / `AfterAll` untuk sekali per `Describe`.

### 5.2.2.5 — Code Coverage dengan ShellSpec

ShellSpec punya dukungan native untuk code coverage via `kcov`.

```bash
# Install kcov dulu (Linux)
sudo apt install kcov

# Jalankan dengan coverage
shellspec --kcov

# Output: coverage/ directory dengan laporan HTML
```

**Konfigurasi `.shellspec`:**

```bash
--kcov
--kcov-options "--include-path=lib/,bin/"
```

**Penjelasan:**
- `--include-path`: Hanya hitung coverage untuk direktori ini.
- `--kcov-options`: Opsi tambahan untuk kcov.

### 5.2.2.6 — CI/CD Integration

**GitHub Actions workflow:**

```yaml
# .github/workflows/test.yml
name: Test Shell Scripts
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install ShellSpec
        run: curl -fsSL https://git.io/shellspec | sh -s -- -y

      - name: Run tests
        run: shellspec --format documentation
```

**Penjelasan:**
- `on: [push, pull_request]`: Jalankan saat push atau PR.
- `shellspec --format documentation`: Output verbose untuk log CI.

**Dengan coverage:**

```yaml
      - name: Install kcov
        run: sudo apt-get install -y kcov

      - name: Run tests with coverage
        run: shellspec --kcov

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: coverage/*.xml
```

### Terminologi Esensial 5.2.2

- **BDD**: Behavior-Driven Development.
- **Describe/It**: Blok test.
- **When call**: Cara memanggil fungsi.
- **The ... should ...**: Assertion.
- **Matcher**: Kata kerja assertion (`eq`, `include`, dll).
- **Mock**: Fungsi palsu.
- **Stub**: Versi sederhana dari mock.
- **`Before`/`After`**: Hook setup/teardown.
- **kcov**: Alat code coverage.

### Struktur Pembelajaran Internal (Mini TOC 5.2.2)

1. Filosofi BDD
2. Instalasi & struktur proyek
3. `Describe`, `It`, `When`, `The`
4. Matcher lengkap
5. Mocking & stubbing
6. Setup/teardown (`Before`, `After`)
7. Code coverage (`--kcov`)
8. CI/CD integration
9. Parameterized test (`Parameters`)

### Rekomendasi Visualisasi

> Diagram **struktur test ShellSpec**: kotak `Describe` berisi kotak `It`, di dalam `It` ada `When` dan `The`. Ini sangat membantu memahami hierarki.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1 (fungsi), 5.2.1 (testing manual).
- **Terkait**: 5.2.3 (ZUnit), 5.2.4 (ztr).
- **Dipakai di**: 5.3 (test integrasi API).

### Sumber Referensi 5.2.2

- ShellSpec Official: https://shellspec.info/
- GitHub: https://github.com/shellspec/shellspec
- Demo: https://shellspec.info/demo.html
- Zsh Testing Guideline: https://github.com/jim60105/image-dataset-prep-tools/blob/master/docs/zsh-testing-guideline.md

### Tips & Praktik Terbaik 5.2.2

- Mulai dari test sederhana — jangan langsung coverage 100%.
- Gunakan `--format documentation` saat development untuk output jelas.
- Isolasi test dengan `mktemp -d` — jangan bergantung pada direktori kerja.
- Mock command eksternal (`curl`, `git`) agar test cepat dan deterministik.
- Jalankan `shellspec` sebelum commit.

### Potensi Kesalahan Umum 5.2.2

| Kesalahan | Solusi |
|-----------|--------|
| Test saling mengganggu | Selalu isolasi dengan `Before`/`After` |
| `When call` tidak menangkap output | Pastikan fungsi `echo` ke stdout |
| Mock bocor ke test lain | Definisikan mock di dalam `Describe` yang sama |
| Coverage 0% | Pastikan `--include-path` benar |

---

## 5.2.3 — ZUnit: Unit Testing Khusus Zsh

### Deskripsi Konkret & Peran dalam Kurikulum

ZUnit adalah **framework unit testing yang dirancang khusus untuk Zsh**, terinspirasi oleh BATS (Bash Automated Testing System). Perannya: alternatif ShellSpec untuk yang ingin testing lebih native Zsh.

### Konsep Kunci & Filosofi Mendalam

ZUnit lebih **minimalis** dari ShellSpec. Tidak ada sintaks BDD (`Describe`/`It`). Sebaliknya, Anda menulis fungsi test dengan nama yang diawali `test_`, dan ZUnit akan menjalankannya.

**Filosofi:** "Test adalah fungsi Zsh biasa. Jangan tambah lapisan sintaks yang tidak perlu."

### Sintaks Dasar

**File test harus punya shebang:**

```bash
#!/usr/bin/env zunit
# tests/kalkulator.zunit
```

**Penjelasan:** Shebang `#!/usr/bin/env zunit` **wajib** ada, atau ZUnit tidak akan menjalankan file tersebut.

**Struktur test:**

```bash
#!/usr/bin/env zunit

@setup {
    # Setup sebelum setiap test
    export TEST_DIR=$(mktemp -d)
}

@teardown {
    # Cleanup setelah setiap test
    rm -rf "$TEST_DIR"
}

@test 'tambah menjumlahkan dua angka' {
    result=$(tambah 2 3)
    assert_equal "$result" "5"
}

@test 'tambah menangani negatif' {
    result=$(tambah -1 1)
    assert_equal "$result" "0"
}

@test 'bagi gagal jika pembagi nol' {
    run bagi 10 0
    assert_failure
    assert_output_contains 'tidak bisa dibagi nol'
}
```

**Penjelasan:**

| Elemen | Arti |
|--------|------|
| `@setup { ... }` | Dijalankan sebelum setiap test. |
| `@teardown { ... }` | Dijalankan setelah setiap test. |
| `@test '...' { ... }` | Satu test case. |
| `assert_equal` | Cek kesamaan. |
| `assert_failure` | Cek exit code non-0. |
| `assert_output_contains` | Cek output mengandung substring. |
| `run` | Jalankan fungsi dan tangkap output/exit code. |

**Cara menjalankan:**

```bash
# Jalankan semua test
zunit

# Jalankan file spesifik
zunit tests/kalkulator.zunit
```

**Output:**

```bash
Running tests/kalkulator.zunit
 ✓ tambah menjumlahkan dua angka
 ✓ tambah menangani negatif
 ✓ bagi gagal jika pembagi nol

3 tests, 0 failures
```

### Matcher ZUnit

| Assertion | Arti |
|-----------|------|
| `assert_equal actual expected` | Sama persis |
| `assert_success` | Exit code 0 |
| `assert_failure` | Exit code non-0 |
| `assert_output 'teks'` | Output sama persis |
| `assert_output_contains 'teks'` | Output mengandung |
| `assert_file_exists 'path'` | File ada |
| `assert_file_not_exists 'path'` | File tidak ada |

### Terminologi Esensial 5.2.3

- **ZUnit**: Framework unit testing Zsh.
- **`@test`**: Deklarasi test case.
- **`@setup`/`@teardown`**: Hook setup/cleanup.
- **Assertion**: Fungsi cek (`assert_equal`, dll).
- **Shebang**: Baris `#!/usr/bin/env zunit` di awal file.

### Struktur Pembelajaran Internal (Mini TOC 5.2.3)

1. Filosofi ZUnit vs ShellSpec
2. Instalasi & shebang
3. `@test`, `@setup`, `@teardown`
4. Assertion lengkap
5. Menjalankan test
6. CI integration

### Rekomendasi Visualisasi

> Diagram **perbandingan ShellSpec vs ZUnit**: ShellSpec punya layer BDD, ZUnit langsung ke fungsi. Ini membantu memilih.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1, 5.2.1.
- **Terkait**: 5.2.2 (ShellSpec), 5.2.4 (ztr).
- **Dipakai di**: 5.3.

### Sumber Referensi 5.2.3

- ZUnit GitHub: https://github.com/z-shell/zunit
- ZUnit Docs: https://wiki.zshell.dev/community/zunit
- ZUnit Website: https://zunit.xyz/

### Tips & Praktik Terbaik 5.2.3

- Selalu pakai `@setup`/`@teardown` untuk isolasi.
- Gunakan `run` untuk menangkap output + exit code sekaligus.
- ZUnit cocok untuk proyek Zsh-native; jika butuh portabilitas, pilih ShellSpec.

### Potensi Kesalahan Umum 5.2.3

| Kesalahan | Solusi |
|-----------|--------|
| Lupa shebang `zunit` | Tambahkan di baris pertama |
| Test bergantung pada state global | Selalu setup/teardown |
| `assert_output` gagal karena trailing newline | Gunakan `assert_output_contains` |

---

## 5.2.4 — zsh-test-runner: Alternatif Ringan

### Deskripsi Konkret & Peran dalam Kurikulum

`zsh-test-runner` (ztr) adalah framework testing **ringan** untuk Zsh, dengan fokus pada **kesederhanaan** dan **coverage report**. Perannya: alternatif minimalis yang tidak memaksa sintaks BDD.

### Konsep Kunci & Filosofi Mendalam

**Filosofi ztr:** "Shell sudah punya `[[ ]]`, `(( ))`, dan `test`. Kenapa harus belajar sintaks assertion baru?"

Artinya: Anda menulis assertion dengan `[[ ]]` biasa, dan ztr hanya **menjalankan** dan **melaporkan** hasilnya.

### Sintaks Dasar

**Instalasi:**

```bash
brew install olets/tap/zsh-test-runner
```

Atau manual:

```bash
git clone https://github.com/olets/zsh-test-runner
```

**Test inline:**

```bash
ztr test 'tambah 2+3' {
    local result=$(tambah 2 3)
    [[ "$result" == "5" ]]
}
```

**Penjelasan:**
- `ztr test 'nama' { ... }`: Deklarasi test.
- Di dalam `{ }`: Anda menulis kode Zsh biasa.
- Assertion: `[[ ... ]]` — jika exit code 0, test lulus.

**Test suite file:**

```bash
#!/usr/bin/env zsh
# tests/kalkulator.ztr.zsh

ztr test 'tambah 2+3' {
    [[ "$(tambah 2 3)" == "5" ]]
}

ztr test 'tambah -1+1' {
    [[ "$(tambah -1 1)" == "0" ]]
}

ztr test 'bagi 10/0 gagal' {
    local result
    result=$(bagi 10 0 2>&1)
    local exit_code=$?
    [[ $exit_code -ne 0 ]]
    [[ "$result" == *"tidak bisa dibagi nol"* ]]
}
```

**Menjalankan:**

```bash
ztr run tests/kalkulator.ztr.zsh
```

**Coverage:**

```bash
ztr coverage tests/kalkulator.ztr.zsh
```

### Terminologi Esensial 5.2.4

- **ztr**: zsh-test-runner.
- **Inline test**: Test yang ditulis langsung di command line.
- **Test suite**: Kumpulan test di file.
- **Coverage**: Laporan cakupan test.

### Struktur Pembelajaran Internal (Mini TOC 5.2.4)

1. Filosofi "no new syntax"
2. Instalasi
3. Test inline
4. Test suite file
5. Coverage report

### Rekomendasi Visualisasi

> Diagram **perbandingan tiga framework** (ShellSpec, ZUnit, ztr) dalam tabel: sintaks, kurva belajar, fitur.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1, 5.2.1.
- **Terkait**: 5.2.2, 5.2.3.

### Sumber Referensi 5.2.4

- GitHub: https://github.com/olets/zsh-test-runner
- Docs: https://zsh-test-runner.olets.dev/

### Tips & Praktik Terbaik 5.2.4

- Cocok untuk proyek kecil yang tidak ingin overhead framework.
- Gunakan `ztr coverage` untuk laporan cepat.
- Assertion pakai `[[ ]]` biasa — tidak perlu belajar API baru.

### Potensi Kesalahan Umum 5.2.4

| Kesalahan | Solusi |
|-----------|--------|
| Lupa `[[ ]]` → test selalu lulus | Selalu akhiri dengan assertion |
| Coverage tidak jalan | Pastikan `ztr coverage` dipanggil benar |

---

## 5.2.5 — Code Coverage dengan `kcov`

### Deskripsi Konkret & Peran dalam Kurikulum

`kcov` adalah alat **code coverage** untuk shell script (dan bahasa lain). Perannya: mengukur berapa persen kode yang diuji.

### Konsep Kunci & Filosofi Mendalam

**Code coverage** menjawab: "Dari semua baris kode, berapa yang dieksekusi saat test?"

**Filosofi:** Coverage tinggi bukan tujuan akhir — tapi coverage rendah adalah tanda bahaya. Target realistis: 80–90%.

### Sintaks Dasar

**Instalasi:**

```bash
# Debian/Ubuntu
sudo apt install kcov

# macOS
brew install kcov
```

**Penggunaan dasar:**

```bash
kcov coverage-dir script.sh arg1 arg2
```

**Penjelasan:**
- `coverage-dir`: Direktori output.
- `script.sh`: Script yang dijalankan.
- Output: HTML report di `coverage-dir/`.

**Dengan ShellSpec:**

```bash
shellspec --kcov
```

**Dengan opsi include/exclude:**

```bash
kcov --include-path=lib/,bin/ --exclude-path=tests/ coverage-dir shellspec
```

**Penjelasan:**
- `--include-path`: Hanya hitung file di direktori ini.
- `--exclude-path`: Abaikan direktori ini.

### Terminologi Esensial 5.2.5

- **Code coverage**: Persentase kode yang dieksekusi test.
- **Line coverage**: Berapa baris yang dieksekusi.
- **Branch coverage**: Berapa cabang (if/else) yang dieksekusi.
- **`kcov`**: Alat coverage.

### Struktur Pembelajaran Internal (Mini TOC 5.2.5)

1. Filosofi coverage
2. Instalasi kcov
3. Penggunaan dasar
4. Integrasi dengan ShellSpec
5. Include/exclude path
6. CI integration

### Rekomendasi Visualisasi

> Diagram **laporan coverage HTML**: bar hijau (tercover), merah (tidak). Ini membantu memahami output kcov.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.2.2 (ShellSpec).
- **Terkait**: 5.2.7 (CI/CD).

### Sumber Referensi 5.2.5

- kcov GitHub: https://github.com/SimonKagstrom/kcov
- Man page: https://manpages.debian.org/testing/kcov/kcov.1.en.html

### Tips & Praktik Terbaik 5.2.5

- Jangan kejar 100% — fokus pada logika kritikal.
- Exclude kode boilerplate dari coverage.
- Jalankan coverage di CI untuk track trend.

### Potensi Kesalahan Umum 5.2.5

| Kesalahan | Solusi |
|-----------|--------|
| Coverage 0% | Cek `--include-path` |
| Coverage tinggi tapi bug lolos | Tambah assertion, bukan hanya eksekusi |

---

## 5.2.6 — Piramida Testing untuk Script Shell

### Deskripsi Konkret & Peran dalam Kurikulum

Piramida testing adalah **model mental** untuk membagi test ke tiga level. Ini **tidak ada di kurikulum asli** Anda, tapi saya tambahkan karena konsep ini disebutkan di bagian "Visualisasi yang Direkomendasikan" pada Modul 5.2 asli.

### Konsep Kunci & Filosofi Mendalam

```bash
        /\
       /  \
      / E2E \        ← Sedikit, lambat, mahal
     /--------\
    / Integration \   ← Sedang
   /--------------\
  /   Unit Tests    \  ← Banyak, cepat, murah
 /--------------------\
```

**Filosofi:**
- **Unit test** (dasar): Test fungsi individual. Cepat, banyak.
- **Integration test** (tengah): Test interaksi antar komponen. Sedang.
- **E2E test** (atas): Test alur pengguna lengkap. Lambat, sedikit.

**Untuk script shell:**
- **Unit**: Test `tambah()`, `bagi()`.
- **Integration**: Test `backup()` yang memanggil `tar` dan `date`.
- **E2E**: Test `deploy.sh` yang memanggil `git`, `docker`, `kubectl`.

### Sintaks Dasar / Ilustrasi

**Unit test:**

```bash
It 'tambah 2+3 = 5'
    When call tambah 2 3
    The output should eq 5
End
```

**Integration test:**

```bash
It 'backup membuat file tar.gz'
    When call backup /tmp/src /tmp/dest
    The file /tmp/dest/backup-*.tar.gz should be exist
End
```

**E2E test:**

```bash
It 'deploy.sh berhasil deploy ke staging'
    When run script deploy.sh staging
    The status should be success
    The output should include 'Deploy selesai'
End
```

### Terminologi Esensial 5.2.6

- **Unit test**: Test komponen terkecil.
- **Integration test**: Test interaksi.
- **E2E test**: Test end-to-end.
- **Test pyramid**: Model distribusi test.

### Struktur Pembelajaran Internal (Mini TOC 5.2.6)

1. Filosofi piramida
2. Unit test untuk shell
3. Integration test untuk shell
4. E2E test untuk shell
5. Kapan pakai level mana

### Rekomendasi Visualisasi

> Diagram piramida dengan contoh Zsh di setiap level — ini adalah visualisasi yang direkomendasikan di kurikulum asli.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.2.0–5.2.5.
- **Terkait**: 5.2.7 (CI/CD menjalankan semua level).

### Sumber Referensi 5.2.6

- Martin Fowler — Test Pyramid: https://martinfowler.com/articles/practical-test-pyramid.html
- "Testing Shell Scripts" — https://github.com/koalaman/shellcheck

### Tips & Praktik Terbaik 5.2.6

- 70% unit, 20% integration, 10% E2E.
- E2E mahal — jangan berlebihan.
- Unit test harus cepat (< 1 detik per test).

### Potensi Kesalahan Umum 5.2.6

| Kesalahan | Solusi |
|-----------|--------|
| Terlalu banyak E2E → CI lambat | Pindah ke unit/integration |
| Tidak ada unit test | Mulai dari fungsi terkecil |

---

## 5.2.7 — CI/CD untuk Script Shell (GitHub Actions)

### Deskripsi Konkret & Peran dalam Kurikulum

CI/CD (Continuous Integration/Continuous Deployment) menjalankan test **otomatis** setiap push/PR. Perannya: memastikan kode selalu teruji sebelum merge.

### Konsep Kunci & Filosofi Mendalam

**Filosofi:** "Jika test tidak jalan otomatis, test itu tidak ada." Developer lupa menjalankan test manual. CI memaksa disiplin.

### Sintaks Dasar

**Workflow dasar:**

```yaml
# .github/workflows/test.yml
name: Shell Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install ShellSpec
        run: curl -fsSL https://git.io/shellspec | sh -s -- -y

      - name: Run tests
        run: shellspec --format documentation

      - name: Install ShellCheck
        run: sudo apt-get install -y shellcheck

      - name: Lint
        run: shellcheck **/*.sh
```

**Penjelasan setiap bagian:**

| Bagian | Arti |
|--------|------|
| `name` | Nama workflow. |
| `on` | Trigger (push, PR). |
| `jobs.test` | Job bernama `test`. |
| `runs-on` | OS runner. |
| `steps` | Langkah-langkah. |
| `uses: actions/checkout` | Ambil kode. |
| `run` | Jalankan perintah. |

**Dengan coverage:**

```yaml
      - name: Run tests with coverage
        run: shellspec --kcov

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          files: coverage/*.xml
```

### Terminologi Esensial 5.2.7

- **CI**: Continuous Integration.
- **CD**: Continuous Deployment.
- **Workflow**: File YAML di `.github/workflows/`.
- **Job**: Sekumpulan step.
- **Runner**: Mesin yang menjalankan job.
- **ShellCheck**: Linter untuk shell script.

### Struktur Pembelajaran Internal (Mini TOC 5.2.7)

1. Filosofi CI
2. Workflow dasar
3. Matriks OS (Linux, macOS)
4. Coverage upload
5. ShellCheck linting
6. Caching dependencies

### Rekomendasi Visualisasi

> Diagram **alur CI**: `[push] → [checkout] → [install] → [test] → [coverage] → [report]`. Ini membantu memahami pipeline.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.2.2–5.2.5.
- **Terkait**: 5.3 (integrasi — CI untuk test API).

### Sumber Referensi 5.2.7

- GitHub Actions Docs: https://docs.github.com/en/actions
- ShellCheck: https://github.com/koalaman/shellcheck
- Codecov: https://about.codecov.io/

### Tips & Praktik Terbaik 5.2.7

- Jalankan test di **setiap** push/PR.
- Gunakan matriks OS jika script harus jalan di Linux & macOS.
- Cache instalasi framework untuk mempercepat CI.
- Tambahkan badge status di README.

### Potensi Kesalahan Umum 5.2.7

| Kesalahan | Solusi |
|-----------|--------|
| CI gagal karena path salah | Gunakan `pwd` dan `ls` untuk debug |
| Test lulus lokal, gagal CI | Cek perbedaan environment |
| Tidak ada shellcheck | Tambahkan step lint |

---

## Penutup Modul 5.2

### Rangkuman Keterampilan

Setelah Modul 5.2, Anda harus mampu:
- Menjelaskan mengapa testing script shell penting.
- Menulis test manual dengan `[[ ]]` dan `$?`.
- Menggunakan ShellSpec untuk BDD testing.
- Menggunakan ZUnit dan ztr sebagai alternatif.
- Mengukur code coverage dengan kcov.
- Menerapkan piramida testing.
- Menyiapkan CI/CD dengan GitHub Actions.

### Visualisasi Keseluruhan Modul 5.2

> Diagram **alur testing lengkap**:
> ```
> [Tulis script] → [Tulis test manual] → [Pindah ke ShellSpec]
>     → [Tambah coverage] → [Setup CI] → [Monitor]
> ```

### Referensi Lengkap Modul 5.2

- ShellSpec: https://shellspec.info/
- ShellSpec GitHub: https://github.com/shellspec/shellspec
- ZUnit: https://github.com/z-shell/zunit
- zsh-test-runner: https://github.com/olets/zsh-test-runner
- kcov: https://github.com/SimonKagstrom/kcov
- ShellCheck: https://github.com/koalaman/shellcheck
- GitHub Actions: https://docs.github.com/en/actions
- Test Pyramid (Martin Fowler): https://martinfowler.com/articles/practical-test-pyramid.html
- BDD (Dan North): https://dannorth.net/introducing-bdd/

---


## ✅ Daftar yang telah diselesaikan

Modul **5.2** sudah selesai dengan cakupan:
- ✅ Mengapa testing penting (tambahan audit)
- ✅ Testing manual tanpa framework (tambahan audit)
- ✅ ShellSpec: BDD, matcher, mocking, coverage, CI
- ✅ ZUnit: unit testing Zsh
- ✅ zsh-test-runner: alternatif ringan
- ✅ kcov: code coverage
- ✅ Piramida testing (tambahan audit)
- ✅ CI/CD dengan GitHub Actions

**Bereikutnya kita akan lanjutkan ke Modul 5.3 (Integrasi dengan Bahasa Lain dan API Eksternal)**

Kita akan membahas:
- Memanggil Python/Ruby/Node dari Zsh
- Memproses JSON dengan `jq` (dan fallback tanpa jq)
- Interaksi dengan REST API (termasuk error handling)
- Koneksi database (`psql`, `mysql`, `sqlite3`)
- Environment variable untuk konfigurasi (termasuk secret handling)
- Pipeline dengan alat CLI modern
- **Tambahan audit:** Keamanan script (injection, `eval`, quoting)
- **Tambahan audit:** Pipeline error handling (`pipefail`, `PIPESTATUS`)

# FASE 5 — MODUL 5.3: Integrasi dengan Bahasa Lain dan API Eksternal

<details>
  <summary>📃 Daftar Isi</summary>

---

## 📑 Mini-Daftar Isi Modul 5.3

1. **5.3.0 — Mengapa Integrasi Penting** *(Pondasi Filosofis)*
2. **5.3.1 — Memanggil Python/Ruby/Node dari Zsh**
   - 5.3.1.1 Pola dasar: `python3 -c`, `node -e`, `ruby -e`
   - 5.3.1.2 Menangkap output & error
   - 5.3.1.3 Interpreter selection & portabilitas
   - 5.3.1.4 Menggunakan heredoc untuk script inline
3. **5.3.2 — Memproses JSON dengan `jq`**
   - 5.3.2.1 Instalasi & sintaks dasar
   - 5.3.2.2 Filter: `.field`, `.[]`, `map`, `select`
   - 5.3.2.3 Transformasi & konstruksi objek
   - 5.3.2.4 `jq` untuk API response
   - 5.3.2.5 **Fallback tanpa `jq`** *(tambahan audit)*
4. **5.3.3 — Interaksi dengan REST API**
   - 5.3.3.1 `curl` dasar: GET, POST, headers
   - 5.3.3.2 Error handling & retry
   - 5.3.3.3 HTTP status code checking
   - 5.3.3.4 Authentication (Bearer, Basic, API key)
   - 5.3.3.5 Rate limiting & backoff
5. **5.3.4 — Koneksi Database**
   - 5.3.4.1 `psql` (PostgreSQL)
   - 5.3.4.2 `mysql` (MySQL/MariaDB)
   - 5.3.4.3 `sqlite3` (SQLite)
   - 5.3.4.4 Format output & parsing
6. **5.3.5 — Environment Variable untuk Konfigurasi**
   - 5.3.5.1 Pola dasar `export` & `.env`
   - 5.3.5.2 **Penanganan secret yang aman** *(tambahan audit)*
   - 5.3.5.3 `direnv` & auto-loading
7. **5.3.6 — Pipeline dengan Alat CLI Modern**
   - 5.3.6.1 `kubectl` + `jq`
   - 5.3.6.2 `gh` CLI (GitHub)
   - 5.3.6.3 `aws`/`gcloud` CLI
8. **5.3.7 — Pipeline Error Handling** *(tambahan audit)*
   - 5.3.7.1 `pipefail` & `pipestatus` di Zsh
   - 5.3.7.2 Pola aman untuk pipeline
9. **5.3.8 — Keamanan Script Zsh** *(tambahan audit)*
   - 5.3.8.1 Bahaya `eval` & injection
   - 5.3.8.2 Quoting yang benar
   - 5.3.8.3 Zsh-specific risks
10. **Tips, Kesalahan Umum, Referensi**

</details>

---

## 5.3.0 — Mengapa Integrasi Penting

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada di kurikulum asli** Anda, tetapi saya tambahkan sebagai pondasi. Sebelum masuk ke alat integrasi, pembaca harus memahami **mengapa** shell bukan pulau dan bagaimana integrasi mengubah cara kerja.

### Konsep Kunci & Filosofi Mendalam

**Analogi sederhana:** Shell seperti **koordinator proyek**. Ia tidak harus melakukan semua pekerjaan sendiri — ia bisa memanggil spesialis: Python untuk parsing data kompleks, Node untuk operasi async, `jq` untuk JSON, `psql` untuk database.

**Filosofi Unix:** "Write programs that do one thing and do it well. Write programs to work together." — Doug McIlroy. Shell adalah perekat yang menyatukan program-program kecil.

**Mengapa Zsh unggul dalam integrasi:**
1. **Parameter expansion canggih** (5.1.4) — parsing output tanpa `awk`.
2. **Array 1-indexed** (5.1.5) — manipulasi data native.
3. **Hook functions** (5.1.2) — reaksi otomatis pada event.
4. **Autoloading** (5.1.3) — fungsi integrasi dimuat on-demand.

### Sintaks Dasar / Ilustrasi

**Sebelum integrasi (semua di shell):**

```bash
# Parsing JSON dengan sed/awk — rapuh
response='{"nama":"Budi","umur":25}'
nama=$(echo "$response" | sed -n 's/.*"nama":"\([^"]*\)".*/\1/p')
```

**Setelah integrasi (dengan `jq`):**

```bash
# Parsing JSON dengan jq — andal
nama=$(echo "$response" | jq -r '.nama')
```

### Terminologi Esensial 5.3.0

- **Polyglot programming**: Menggunakan beberapa bahasa dalam satu proyek.
- **Inter-process communication**: Komunikasi antar proses (pipe, file, env var).
- **Perekat**: Shell sebagai "lem" yang menyatukan alat.
- **Idempotent**: Operasi yang hasilnya sama meski dijalankan berulang.

### Rekomendasi Visualisasi

> Diagram **arsitektur integrasi**: kotak "Zsh Script" di tengah, dengan panah ke "Python", "Node", "jq", "curl", "psql". Ini menunjukkan shell sebagai hub.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1 (semua sub-modul).
- **Terkait**: 5.2 (test integrasi).
- **Dipakai di**: CI/CD, deployment, automation.

### Sumber Referensi 5.3.0

- "The Unix Philosophy" — https://en.wikipedia.org/wiki/Unix_philosophy
- "The Art of Unix Programming" — Eric S. Raymond

---

## 5.3.1 — Memanggil Python/Ruby/Node dari Zsh

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini mengajarkan cara **memanggil interpreter bahasa lain** dari dalam script Zsh, menangkap output, dan menangani error. Perannya: memperluas kemampuan shell dengan logika yang sulit dilakukan di shell murni.

### Konsep Kunci & Filosofi Mendalam

**Filosofi:** Jangan paksakan shell melakukan segalanya. Jika Anda perlu parsing JSON kompleks, machine learning, atau operasi string canggih — panggil Python. Jika perlu operasi async — panggil Node.

**Tiga pola pemanggilan:**

1. **`-c` / `-e` flag**: Satu baris kode inline.
2. **Heredoc**: Script multi-baris inline.
3. **File terpisah**: Script `.py` / `.js` / `.rb`.

### 5.3.1.1 — Pola Dasar

**Python inline:**

```bash
# Satu ekspresi
python3 -c "print(2 + 3)"                    # Output: 5

# Import & logic
python3 -c "
import json
data = {'nama': 'Budi', 'umur': 25}
print(json.dumps(data))
"
```

**Penjelasan:**
- `python3 -c "..."`: Jalankan kode Python dari string.
- Kutip ganda `"..."` memungkinkan `$` di-expand oleh shell — hati-hati dengan variabel Python.
- Untuk menghindari ekspansi shell, gunakan kutip tunggal: `python3 -c 'print("$HOME")'` → mencetak `$HOME` literal.

**Node inline:**

```bash
node -e "console.log(process.platform)"
node -e "
const os = require('os');
console.log(os.cpus().length);
"
```

**Ruby inline:**

```bash
ruby -e "puts 2 + 3"
ruby -e "
require 'json'
data = {nama: 'Budi', umur: 25}
puts data.to_json
"
```

### 5.3.1.2 — Menangkap Output & Error

**Menangkap stdout:**

```bash
hasil=$(python3 -c "print('hello')")
echo "Hasil: $hasil"   # Hasil: hello
```

**Menangkap exit code:**

```bash
python3 -c "import sys; sys.exit(1)"
echo "Exit: $?"   # Exit: 1
```

**Menangkap stderr:**

```bash
error=$(python3 -c "import sys; print('error', file=sys.stderr)" 2>&1)
echo "$error"   # error
```

**Penjelasan `2>&1`:**
- `2`: file descriptor stderr.
- `1`: file descriptor stdout.
- `2>&1`: arahkan stderr ke stdout — sehingga `$(...)` menangkap keduanya.

**Menangkap stdout & stderr terpisah:**

```bash
stdout=$(python3 -c "
import sys
print('ke stdout')
print('ke stderr', file=sys.stderr)
" 2>/tmp/err)
stderr=$(cat /tmp/err)
```

**Penjelasan:** Redirect stderr ke file sementara, lalu baca.

### 5.3.1.3 — Interpreter Selection & Portabilitas

**Gunakan `command -v` untuk cek ketersediaan:**

```bash
if command -v python3 &>/dev/null; then
    PY=python3
elif command -v python &>/dev/null; then
    PY=python
else
    echo "Python tidak ditemukan" >&2
    return 1
fi

$PY -c "print('ok')"
```

**Penjelasan:**
- `command -v python3`: cek apakah `python3` ada di `$PATH`.
- `&>/dev/null`: buang stdout & stderr.
- `$PY`: variabel berisi interpreter yang tersedia.

**Fallback berantai:**

```bash
run_script() {
    local interpreter
    for interpreter in python3 python; do
        if command -v "$interpreter" &>/dev/null; then
            "$interpreter" -c "$1"
            return $?
        fi
    done
    echo "Tidak ada interpreter Python" >&2
    return 1
}

run_script "print('hello')"
```

### 5.3.1.4 — Menggunakan Heredoc untuk Script Inline

**Sintaks heredoc:**

```bash
python3 <<'EOF'
import json
data = {'nama': 'Budi', 'umur': 25}
print(json.dumps(data, indent=2))
EOF
```

**Penjelasan:**
- `<<'EOF'`: heredoc dengan **kutip tunggal** — tidak ada ekspansi shell.
- `<<EOF` (tanpa kutip): `$VAR` di-expand oleh shell.
- `EOF`: penanda akhir (bisa diganti apa saja).

**Dengan ekspansi shell:**

```bash
nama="Budi"
python3 <<EOF
print("Halo, $nama")
EOF
# Output: Halo, Budi
```

**Praktik terbaik:** Gunakan `<<'EOF'` untuk script yang punya banyak `$` (variabel Python, template string).

**Node dengan heredoc:**

```bash
node <<'EOF'
const data = { nama: 'Budi', umur: 25 };
console.log(JSON.stringify(data));
EOF
```

### Contoh Studi Kasus: Analisis Data Sederhana

```bash
#!/bin/zsh

analisis_log() {
    local log_file="$1"
    
    # Python untuk analisis kompleks
    python3 <<EOF
import re
from collections import Counter

with open('$log_file') as f:
    lines = f.readlines()

# Hitung error per level
levels = Counter()
for line in lines:
    m = re.search(r'(ERROR|WARN|INFO)', line)
    if m:
        levels[m.group(1)] += 1

for level, count in levels.most_common():
    print(f"{level}: {count}")
EOF
}

analisis_log "/var/log/app.log"
```

**Penjelasan:**
- `<<EOF` (tanpa kutip): `$log_file` di-expand oleh shell.
- Python membaca file dan menganalisis.
- Output: `ERROR: 5`, `WARN: 12`, `INFO: 100`.

### Terminologi Esensial 5.3.1

- **Interpreter**: Program yang menjalankan kode (Python, Node, Ruby).
- **Inline code**: Kode yang ditulis langsung di command line.
- **Heredoc**: Blok teks multi-baris.
- **`-c` / `-e`**: Flag untuk kode inline.
- **Command substitution**: `$(...)` — menangkap output.
- **`2>&1`**: Redirect stderr ke stdout.

### Struktur Pembelajaran Internal (Mini TOC 5.3.1)

1. Filosofi polyglot
2. Pola dasar `-c` / `-e`
3. Menangkap output & error
4. Interpreter selection & portabilitas
5. Heredoc: inline vs ekspansi
6. Studi kasus: analisis log

### Rekomendasi Visualisasi

> Diagram **alur pemanggilan**: `[Zsh] → spawn process → [Python] → stdout/stderr → [Zsh]`. Ini membantu memahami bahwa proses terpisah.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.0 (fungsi), 5.1.1 (anonymous function).
- **Terkait**: 5.3.2 (parsing JSON output Python).
- **Dipakai di**: 5.3.7 (pipeline error handling).

### Sumber Referensi 5.3.1

- Python `-c` docs: https://docs.python.org/3/using/cmdline.html#cmdoption-c
- Node `-e` docs: https://nodejs.org/api/cli.html#-e---eval-script
- Ruby `-e` docs: https://ruby-doc.org/stdlib/libdoc/optparse/rdoc/OptionParser.html
- "Running Python from Shell" — https://realpython.com/python-subprocess/

### Tips & Praktik Terbaik 5.3.1

- Gunakan `<<'EOF'` untuk script tanpa ekspansi shell.
- Cek ketersediaan interpreter dengan `command -v`.
- Simpan script panjang di file `.py` — jangan inline.
- Selalu tangkap exit code: `$?` atau `if ! ...; then`.

### Potensi Kesalahan Umum 5.3.1

| Kesalahan | Solusi |
|-----------|--------|
| Kutip ganda → `$VAR` di-expand shell | Gunakan kutip tunggal atau `<<'EOF'` |
| Lupa `print()` → tidak ada output | Pastikan Python mencetak ke stdout |
| Interpreter tidak ada | Cek dengan `command -v` |
| Heredoc tidak ditutup | Pastikan `EOF` di baris sendiri |

---

## 5.3.2 — Memproses JSON dengan `jq`

### Deskripsi Konkret & Peran dalam Kurikulum

`jq` adalah **prosesor JSON command-line** yang ringan dan fleksibel. Perannya: mengajarkan parsing JSON yang andal — keterampilan krusial untuk integrasi API.

### Konsep Kunci & Filosofi Mendalam

**Analogi:** `jq` adalah **`sed` untuk JSON**. Sama seperti `sed` memproses teks baris demi baris, `jq` memproses JSON node demi node.

**Filosofi:**
1. **Filter-based**: Anda menulis "filter" yang mentransformasi input.
2. **Composable**: Filter bisa di-pipe: `.items[] | select(.aktif) | .nama`.
3. **Non-destruktif**: `jq` tidak mengubah file — output ke stdout.

### 5.3.2.1 — Instalasi & Sintaks Dasar

**Instalasi:**

```bash
# macOS
brew install jq

# Debian/Ubuntu
sudo apt install jq

# Verifikasi
jq --version
```

**Sintaks dasar:**

```bash
echo '{"nama":"Budi","umur":25}' | jq '.'
# Output: objek terformat

echo '{"nama":"Budi","umur":25}' | jq '.nama'
# Output: "Budi"

echo '{"nama":"Budi","umur":25}' | jq -r '.nama'
# Output: Budi (tanpa kutip)
```

**Penjelasan flag:**
- `-r`: **raw output** — string tanpa kutip.
- `-c`: **compact** — output satu baris.
- `-n`: **null input** — jangan baca stdin.
- `-e`: **exit status** — exit 1 jika output null/false.
- `-s`: **slurp** — gabung semua input jadi array.

### 5.3.2.2 — Filter: `.field`, `.[]`, `map`, `select`

**Akses field:**

```bash
echo '{"user":{"nama":"Budi"}}' | jq '.user.nama'
# "Budi"

echo '{"user":{"nama":"Budi"}}' | jq '.user.nama | length'
# 4
```

**Iterasi array:**

```bash
echo '[1,2,3,4,5]' | jq '.[]'
# 1
# 2
# 3
# 4
# 5

echo '[{"id":1},{"id":2}]' | jq '.[].id'
# 1
# 2
```

**`map`: transformasi setiap elemen:**

```bash
echo '[{"harga":100},{"harga":200}]' | jq 'map(.harga)'
# [100, 200]

echo '[{"harga":100},{"harga":200}]' | jq 'map(.harga) | add'
# 300
```

**`select`: filter berdasarkan kondisi:**

```bash
echo '[{"nama":"Budi","umur":25},{"nama":"Ani","umur":17}]' \
    | jq '.[] | select(.umur >= 18) | .nama'
# "Budi"
```

**`map(select(...))`:**

```bash
echo '[{"aktif":true,"nama":"A"},{"aktif":false,"nama":"B"}]' \
    | jq 'map(select(.aktif)) | .[].nama'
# "A"
```

### 5.3.2.3 — Transformasi & Konstruksi Objek

**Membuat objek baru:**

```bash
echo '{"nama":"Budi","umur":25}' | jq '{nama: .nama, usia: .umur}'
# {"nama":"Budi","usia":25}
```

**Array construction:**

```bash
echo '{"a":1,"b":2}' | jq '[.a, .b]'
# [1,2]
```

**String interpolation:**

```bash
echo '{"nama":"Budi","umur":25}' | jq '"\(.nama) berumur \(.umur) tahun"'
# "Budi berumur 25 tahun"
```

**Penjelasan:** `\(...)` — interpolasi di dalam string `jq`.

**Group by:**

```bash
echo '[{"kategori":"A","nilai":1},{"kategori":"A","nilai":2},{"kategori":"B","nilai":3}]' \
    | jq 'group_by(.kategori) | map({kategori: .[0].kategori, total: map(.nilai) | add})'
# [{"kategori":"A","total":3},{"kategori":"B","total":3}]
```

### 5.3.2.4 — `jq` untuk API Response

**Pola umum:**

```bash
# Ambil nama user dari GitHub API
curl -s https://api.github.com/users/octocat | jq -r '.name'

# Ambil semua repo names
curl -s https://api.github.com/users/octocat/repos | jq -r '.[].name'

# Filter repo yang bukan fork
curl -s https://api.github.com/users/octocat/repos \
    | jq -r '.[] | select(.fork == false) | .name'

# Ambil field tertentu jadi CSV
curl -s https://api.github.com/users/octocat/repos \
    | jq -r '.[] | [.name, .stargazers_count] | @csv'
```

**Penjelasan `@csv`:**
- `@csv`: format array sebagai CSV.
- `@tsv`: TSV.
- `@json`: JSON.

**Contoh dengan `--arg`:**

```bash
# Kirim variabel shell ke jq
nama="Budi"
echo '{"users":[{"nama":"Budi"},{"nama":"Ani"}]}' \
    | jq --arg n "$nama" '.users[] | select(.nama == $n)'
```

**Penjelasan:** `--arg n "$nama"` mendefinisikan `$n` di dalam `jq`.

### 5.3.2.5 — Fallback Tanpa `jq` *(Materi Tambahan Audit)*

**Situasi:** `jq` tidak tersedia di server. Solusi:

**1. Python `json.tool`:**

```bash
echo '{"nama":"Budi"}' | python3 -m json.tool
# {
#     "nama": "Budi"
# }

# Parsing field
echo '{"nama":"Budi"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['nama'])"
```

**2. Node:**

```bash
echo '{"nama":"Budi"}' | node -e "
let data = '';
process.stdin.on('data', c => data += c);
process.stdin.on('end', () => {
    console.log(JSON.parse(data).nama);
});
"
```

**3. `json_pp` (Perl):**

```bash
echo '{"nama":"Budi"}' | json_pp
```

**4. Zsh native (terbatas):**

```bash
# Untuk JSON sederhana, bisa pakai parameter expansion
response='{"nama":"Budi","umur":25}'
nama=${response#*\"nama\":\"}
nama=${nama%%\"*}
echo "$nama"   # Budi
```

**Penjelasan:**
- `${var#pattern}`: hapus prefix terpendek yang match.
- `${var%%pattern}`: hapus suffix terpanjang yang match.
- **Peringatan:** Rapuh — hanya untuk JSON yang sangat sederhana.

### Contoh Studi Kasus: Pipeline API → CSV

```bash
#!/bin/zsh

fetch_users() {
    local page=1
    while true; do
        local response=$(curl -s "https://api.example.com/users?page=$page")
        local count=$(echo "$response" | jq '.data | length')
        
        [[ "$count" -eq 0 ]] && break
        
        echo "$response" | jq -r '.data[] | [.id, .nama, .email] | @csv'
        ((page++))
    done
}

fetch_users > users.csv
```

### Terminologi Esensial 5.3.2

- **`jq`**: Prosesor JSON command-line.
- **Filter**: Ekspresi `jq` (`.nama`, `.[]`).
- **`map`**: Transformasi array.
- **`select`**: Filter array.
- **`@csv`**: Format sebagai CSV.
- **`-r`**: Raw output.
- **`--arg`**: Kirim variabel shell ke `jq`.

### Struktur Pembelajaran Internal (Mini TOC 5.3.2)

1. Filosofi `jq` sebagai `sed` JSON
2. Instalasi & sintaks dasar
3. Filter: `.field`, `.[]`, `map`, `select`
4. Transformasi & konstruksi objek
5. `jq` untuk API response
6. Fallback tanpa `jq`
7. Studi kasus: pipeline API → CSV

### Rekomendasi Visualisasi

> Diagram **alur filter `jq`**: input JSON → filter 1 → filter 2 → output. Ini menunjukkan komposisi filter.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.3.1 (memanggil Python).
- **Terkait**: 5.3.3 (API), 5.3.6 (kubectl).
- **Dipakai di**: CI/CD, automation.

### Sumber Referensi 5.3.2

- `jq` Manual: https://stedolan.github.io/jq/manual/
- `jq` Playground: https://jqplay.org/
- "jq Tutorial" — https://programminghistorian.org/en/lessons/json-and-jq
- Python `json.tool`: https://docs.python.org/3/library/json.html#module-json.tool

### Tips & Praktik Terbaik 5.3.2

- Selalu pakai `-r` untuk output string.
- Gunakan `--arg` untuk variabel shell — jangan interpolasi langsung.
- Test filter di `jqplay.org` sebelum masuk script.
- Untuk JSON besar, gunakan `jq -c` untuk hemat memori.

### Potensi Kesalahan Umum 5.3.2

| Kesalahan | Solusi |
|-----------|--------|
| Lupa `-r` → output dengan kutip | Tambahkan `-r` |
| `jq` tidak ada di server | Fallback ke Python/Node |
| Interpolasi `$var` di filter | Gunakan `--arg` |
| JSON invalid | Validasi dengan `jq .` dulu |

---

## 5.3.3 — Interaksi dengan REST API

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini mengajarkan **memanggil REST API** dari Zsh menggunakan `curl`, termasuk error handling, authentication, dan retry. Perannya: membuka pintu integrasi dengan layanan eksternal.

### Konsep Kunci & Filosofi Mendalam

**REST (Representational State Transfer):** Gaya arsitektur API yang menggunakan HTTP method (GET, POST, PUT, DELETE) untuk operasi CRUD.

**Filosofi:**
1. **Stateless**: Setiap request independen.
2. **Resource-based**: URL merepresentasikan resource.
3. **HTTP method semantik**: GET = baca, POST = buat, PUT = update, DELETE = hapus.

### 5.3.3.1 — `curl` Dasar

**GET request:**

```bash
curl -s https://api.example.com/resource
```

**Penjelasan flag:**
- `-s`: silent — sembunyikan progress.
- `-S`: show error — tampilkan error meski silent.
- `-f`: fail — exit non-0 jika HTTP ≥ 400.
- `-L`: follow redirect.
- `-o file`: output ke file.
- `-O`: output ke file dengan nama dari URL.
- `-w "%{http_code}"`: tampilkan HTTP status code.

**Headers:**

```bash
curl -s -H "Authorization: Bearer $TOKEN" \
     -H "Accept: application/json" \
     https://api.example.com/resource
```

**POST dengan JSON:**

```bash
curl -s -X POST \
     -H "Content-Type: application/json" \
     -d '{"nama":"Budi","umur":25}' \
     https://api.example.com/users
```

**POST dari file:**

```bash
curl -s -X POST \
     -H "Content-Type: application/json" \
     -d @data.json \
     https://api.example.com/users
```

**Penjelasan `@data.json`:** `@` menandakan baca dari file.

**PUT & DELETE:**

```bash
curl -s -X PUT -H "Content-Type: application/json" \
     -d '{"nama":"Budi Baru"}' \
     https://api.example.com/users/1

curl -s -X DELETE https://api.example.com/users/1
```

### 5.3.3.2 — Error Handling & Retry

**`--fail` untuk HTTP error:**

```bash
if curl -sf https://api.example.com/resource -o response.json; then
    echo "Sukses"
else
    echo "Gagal (exit: $?)"
fi
```

**Penjelasan `-f`:**
- Tanpa `-f`: `curl` sukses meski HTTP 404 — exit code 0.
- Dengan `-f`: `curl` exit 22 jika HTTP ≥ 400.

**Retry otomatis:**

```bash
curl -s --retry 3 --retry-delay 2 --retry-connrefused \
     https://api.example.com/resource
```

**Penjelasan:**
- `--retry 3`: Coba 3 kali.
- `--retry-delay 2`: Tunggu 2 detik antar retry.
- `--retry-connrefused`: Retry jika koneksi ditolak.
- `--retry-max-time 30`: Batas total waktu retry.

**Retry hanya pada 5xx:**

```bash
curl -s --retry 3 --retry-all-errors \
     https://api.example.com/resource
```

**Penjelasan `--retry-all-errors`:** Retry pada semua error (termasuk 4xx) — hati-hati, bisa memperparah rate limit.

**Gabung `--fail` + `--retry`:**

```bash
curl -sf --retry 3 --retry-delay 1 \
     https://api.example.com/resource
```

### 5.3.3.3 — HTTP Status Code Checking

**Mendapatkan status code:**

```bash
status=$(curl -s -o /dev/null -w "%{http_code}" https://api.example.com/resource)
echo "Status: $status"
```

**Penjelasan:**
- `-o /dev/null`: Buang body.
- `-w "%{http_code}"`: Tampilkan status code.
- Hasil: `200`, `404`, `500`, dst.

**Switch berdasarkan status:**

```bash
status=$(curl -s -o response.json -w "%{http_code}" https://api.example.com/resource)
case "$status" in
    200) echo "OK" ;;
    404) echo "Tidak ditemukan" ;;
    401) echo "Unauthorized" ;;
    429) echo "Rate limited — tunggu" ;;
    5*)  echo "Server error" ;;
    *)   echo "Status tak dikenal: $status" ;;
esac
```

### 5.3.3.4 — Authentication

**Bearer token:**

```bash
TOKEN="your_token_here"
curl -s -H "Authorization: Bearer $TOKEN" https://api.example.com/resource
```

**Basic auth:**

```bash
curl -s -u "user:password" https://api.example.com/resource
```

**Penjelasan:** `-u` otomatis encode base64.

**API key di query:**

```bash
curl -s "https://api.example.com/resource?api_key=$API_KEY"
```

**API key di header:**

```bash
curl -s -H "X-API-Key: $API_KEY" https://api.example.com/resource
```

**OAuth2 client credentials:**

```bash
# 1. Dapatkan token
TOKEN=$(curl -s -X POST \
    -d "grant_type=client_credentials" \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    https://auth.example.com/oauth/token | jq -r '.access_token')

# 2. Gunakan token
curl -s -H "Authorization: Bearer $TOKEN" https://api.example.com/resource
```

### 5.3.3.5 — Rate Limiting & Backoff

**Deteksi rate limit:**

```bash
# Cek header rate limit
curl -sI https://api.example.com/resource | grep -i 'x-ratelimit'
```

**Backoff manual:**

```bash
call_api() {
    local url="$1"
    local max_retries=3
    local delay=1
    
    for (( i=1; i<=max_retries; i++ )); do
        local status=$(curl -s -o response.json -w "%{http_code}" "$url")
        
        if [[ "$status" == "200" ]]; then
            cat response.json
            return 0
        elif [[ "$status" == "429" ]]; then
            echo "Rate limited. Tunggu ${delay}s..." >&2
            sleep "$delay"
            ((delay *= 2))   # Exponential backoff
        else
            echo "Error: $status" >&2
            return 1
        fi
    done
    
    echo "Max retry tercapai" >&2
    return 1
}
```

**Penjelasan:**
- `((delay *= 2))`: Exponential backoff.
- Loop hingga `max_retries`.

### Contoh Studi Kasus: Fungsi API Reusable

```bash
#!/bin/zsh

api_call() {
    local method="$1"
    local endpoint="$2"
    local data="${3:-}"
    
    local url="${API_BASE_URL}${endpoint}"
    local args=(-s -X "$method" -H "Authorization: Bearer $API_TOKEN")
    
    [[ -n "$data" ]] && args+=(-H "Content-Type: application/json" -d "$data")
    
    local response
    response=$(curl "${args[@]}" -w "\n%{http_code}" "$url")
    
    local body=$(echo "$response" | head -n -1)
    local status=$(echo "$response" | tail -n 1)
    
    if [[ "$status" =~ ^2 ]]; then
        echo "$body"
        return 0
    else
        echo "API error $status: $body" >&2
        return 1
    fi
}

# Penggunaan
export API_BASE_URL="https://api.example.com"
export API_TOKEN="xxx"

api_call GET "/users" | jq '.'
api_call POST "/users" '{"nama":"Budi"}'
```

### Terminologi Esensial 5.3.3

- **REST**: Arsitektur API HTTP.
- **`curl`**: Alat transfer data URL.
- **`-f`**: Fail pada HTTP error.
- **`-w`**: Format output.
- **Bearer token**: Skema auth.
- **Basic auth**: User:password base64.
- **Rate limit**: Batas request per waktu.
- **Exponential backoff**: Delay bertambah eksponensial.

### Struktur Pembelajaran Internal (Mini TOC 5.3.3)

1. Filosofi REST
2. `curl` dasar: GET, POST, headers
3. Error handling & retry
4. HTTP status code checking
5. Authentication
6. Rate limiting & backoff
7. Studi kasus: fungsi API reusable

### Rekomendasi Visualisasi

> Diagram **alur request/response**: `[Zsh] → curl → [API] → response → jq → [output]`. Tambahkan cabang error handling.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.3.2 (`jq`).
- **Terkait**: 5.3.4 (database), 5.3.7 (pipeline error).
- **Dipakai di**: CI/CD, automation.

### Sumber Referensi 5.3.3

- `curl` Man Page: https://curl.se/docs/manpage.html
- "Everything curl" — https://everything.curl.dev/
- REST API Tutorial: https://restfulapi.net/
- HTTP Status Codes: https://httpstatuses.com/

### Tips & Praktik Terbaik 5.3.3

- Selalu pakai `-s` untuk script (bersih).
- Gunakan `-f` untuk mendeteksi HTTP error.
- Simpan token di environment variable — jangan hardcode.
- Gunakan `--retry` untuk request network.
- Cek `429` — jangan hammer API.

### Potensi Kesalahan Umum 5.3.3

| Kesalahan | Solusi |
|-----------|--------|
| `curl` sukses meski 404 | Tambahkan `-f` |
| Token hardcode | Gunakan env var |
| Rate limit terlampaui | Exponential backoff |
| Lupa `-H Content-Type` | Selalu set untuk POST JSON |

---

## 5.3.4 — Koneksi Database

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini mengajarkan **berinteraksi dengan database** dari Zsh: PostgreSQL (`psql`), MySQL (`mysql`), dan SQLite (`sqlite3`). Perannya: otomatisasi query dan migrasi.

### Konsep Kunci & Filosofi Mendalam

**Filosofi:** Database adalah sumber kebenaran data. Shell bisa jadi jembatan antara database dan alat lain (CSV, API).

**Tiga mode:**
1. **Interaktif**: Ketik query langsung.
2. **Batch**: `-c "SELECT ..."`.
3. **Script**: Dari file `.sql`.

### 5.3.4.1 — `psql` (PostgreSQL)

**Koneksi:**

```bash
psql -h localhost -U user -d dbname
```

**Penjelasan:**
- `-h`: host.
- `-U`: user.
- `-d`: database.
- `-p`: port (default 5432).

**Batch query:**

```bash
psql -h localhost -U user -d db -c "SELECT * FROM users;"
```

**CSV output:**

```bash
psql -h localhost -U user -d db --csv -c "SELECT * FROM users;"
```

**Penjelasan `--csv`:** Tersedia sejak PostgreSQL 12.

**Alternatif format:**

```bash
psql -t -A -F"," -c "SELECT id, nama FROM users;"
```

**Penjelasan:**
- `-t`: tuples only (tanpa header).
- `-A`: unaligned (tanpa padding).
- `-F","`: field separator = koma.

**Dari file:**

```bash
psql -h localhost -U user -d db -f script.sql
```

**Dengan environment variable:**

```bash
export PGHOST=localhost
export PGUSER=user
export PGDATABASE=db
export PGPASSWORD=secret

psql -c "SELECT 1"
```

**Penjelasan:** `psql` otomatis membaca `PG*` env var.

### 5.3.4.2 — `mysql` (MySQL/MariaDB)

**Koneksi:**

```bash
mysql -h localhost -u user -p dbname
```

**Batch query:**

```bash
mysql -h localhost -u user -psecret db -e "SELECT * FROM users;"
```

**Penjelasan:** `-psecret` tanpa spasi (langsung password). Untuk aman, gunakan prompt: `-p` saja.

**Output tab-separated:**

```bash
mysql -h localhost -u user -p db -e "SELECT * FROM users;" -B
```

**Penjelasan `-B`:** Batch mode — output tab-separated, satu baris per record.

**Dari file:**

```bash
mysql -h localhost -u user -p db < script.sql
```

**Dengan config file:**

```ini
# ~/.my.cnf
[client]
host=localhost
user=myuser
password=mypass
database=mydb
```

```bash
mysql -e "SELECT 1"   # Otomatis baca ~/.my.cnf
```

### 5.3.4.3 — `sqlite3` (SQLite)

**Koneksi:**

```bash
sqlite3 db.sqlite
```

**Penjelasan:** Jika file tidak ada, `sqlite3` akan membuatnya.

**Batch query:**

```bash
sqlite3 db.sqlite "SELECT * FROM users;"
```

**Output CSV:**

```bash
sqlite3 -csv db.sqlite "SELECT * FROM users;"
```

**Output header:**

```bash
sqlite3 -header -csv db.sqlite "SELECT * FROM users;"
```

**Dari file:**

```bash
sqlite3 db.sqlite < script.sql
```

**Perintah dot (meta-command):**

```bash
sqlite3 db.sqlite <<'EOF'
.mode csv
.headers on
.output users.csv
SELECT * FROM users;
EOF
```

**Penjelasan:**
- `.mode csv`: Format CSV.
- `.headers on`: Tampilkan header.
- `.output file`: Redirect ke file.

### 5.3.4.4 — Format Output & Parsing

**CSV → array Zsh:**

```bash
# Ambil data sebagai CSV
csv=$(psql --csv -t -c "SELECT id, nama FROM users;")

# Parse ke array
while IFS=, read -r id nama; do
    echo "ID: $id, Nama: $nama"
done <<< "$csv"
```

**Penjelasan:**
- `IFS=,`: Internal Field Separator = koma.
- `read -r id nama`: Baca dua field.
- `<<< "$csv"`: Here-string.

**JSON output (PostgreSQL):**

```bash
psql -t -A -c "SELECT json_agg(t) FROM (SELECT * FROM users) t;"
```

**Penjelasan:** `json_agg` menghasilkan array JSON — bisa di-pipe ke `jq`.

### Contoh Studi Kasus: Migrasi Data

```bash
#!/bin/zsh

migrasi() {
    local source_db="$1"
    local target_db="$2"
    
    # Export dari source
    echo "Export dari $source_db..."
    sqlite3 -csv -header "$source_db" "SELECT * FROM users;" > /tmp/users.csv
    
    # Import ke target
    echo "Import ke $target_db..."
    sqlite3 "$target_db" <<'EOF'
.mode csv
.import /tmp/users.csv users
EOF
    
    # Verifikasi
    local count=$(sqlite3 "$target_db" "SELECT COUNT(*) FROM users;")
    echo "Total: $count rows"
}

migrasi source.sqlite target.sqlite
```

### Terminologi Esensial 5.3.4

- **`psql`**: Client PostgreSQL.
- **`mysql`**: Client MySQL/MariaDB.
- **`sqlite3`**: Client SQLite.
- **CSV**: Comma-Separated Values.
- **Batch mode**: Non-interaktif.
- **Meta-command**: Perintah `.` di sqlite3.
- **`PG*` env var**: Konfigurasi psql.

### Struktur Pembelajaran Internal (Mini TOC 5.3.4)

1. Filosofi shell + database
2. `psql`: koneksi, batch, CSV
3. `mysql`: koneksi, batch, config
4. `sqlite3`: koneksi, dot commands
5. Format output & parsing
6. Studi kasus: migrasi data

### Rekomendasi Visualisasi

> Diagram **alur database**: `[Zsh] → psql/mysql/sqlite3 → [DB] → output → parse`. Ini menunjukkan shell sebagai jembatan.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.3.1, 5.3.2.
- **Terkait**: 5.3.3 (API), 5.3.7 (pipeline).
- **Dipakai di**: Deployment, backup.

### Sumber Referensi 5.3.4

- `psql` Docs: https://www.postgresql.org/docs/current/app-psql.html
- `mysql` Docs: https://dev.mysql.com/doc/refman/8.0/en/mysql.html
- `sqlite3` CLI: https://sqlite.org/cli.html
- PostgreSQL `--csv`: https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMAND-PSET

### Tips & Praktik Terbaik 5.3.4

- Gunakan `PG*` env var untuk psql — jangan hardcode.
- Pakai `--csv` untuk parsing mudah.
- Untuk password, gunakan `.pgpass` atau `.my.cnf` — jangan di command line.
- Selalu verifikasi count setelah migrasi.

### Potensi Kesalahan Umum 5.3.4

| Kesalahan | Solusi |
|-----------|--------|
| Password di command line (terlihat di `ps`) | Gunakan `.pgpass` / `.my.cnf` |
| CSV parsing gagal karena koma di field | Gunakan quote atau JSON output |
| Lupa `-t` → header ikut terparse | Tambahkan `-t` |
| SQL injection | Gunakan parameterized query |

---

## 5.3.5 — Environment Variable untuk Konfigurasi

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini mengajarkan **mengelola environment variable** untuk konfigurasi dan secret. Perannya: memisahkan konfigurasi dari kode.

### Konsep Kunci & Filosofi Mendalam

**Filosofi 12-factor app:** "Store config in the environment." Kode harus sama di semua environment — hanya env var yang berbeda.

**Dua jenis:**
1. **Konfigurasi**: `API_URL`, `LOG_LEVEL`.
2. **Secret**: `API_KEY`, `DB_PASSWORD`.

### 5.3.5.1 — Pola Dasar

**Set sementara:**

```bash
export API_URL="https://api.example.com"
curl "$API_URL/users"
```

**Set permanen (`~/.zshrc`):**

```bash
export EDITOR="nvim"
export PATH="$HOME/bin:$PATH"
```

**Reload:**

```bash
source ~/.zshrc
```

**`~/.zshenv` vs `~/.zshrc`:**
- `.zshenv`: Dibaca **setiap** shell (interaktif & non-interaktif).
- `.zshrc`: Hanya shell interaktif.

**Untuk script non-interaktif, gunakan `.zshenv`:**

```bash
# ~/.zshenv
export API_URL="https://api.example.com"
```

**Baca `.env` file:**

```bash
# .env
API_URL=https://api.example.com
API_KEY=secret123

# Baca di script
set -a   # Auto-export
source .env
set +a
```

**Penjelasan:**
- `set -a`: Semua variabel yang di-set otomatis di-export.
- `source .env`: Baca file.
- `set +a`: Matikan auto-export.

### 5.3.5.2 — Penanganan Secret yang Aman *(Materi Tambahan Audit)*

**Prinsip:**
1. **Jangan commit secret ke git.**
2. **Jangan hardcode di script.**
3. **Jangan echo secret ke log.**

**`.gitignore`:**

```bash
.env
*.key
*.pem
secrets/
```

**Cek secret di git history:**

```bash
git log -p | grep -i 'password\|api_key\|secret'
```

**Gunakan password manager:**

```bash
# 1Password CLI
export API_KEY=$(op read "op://Vault/Item/field")

# pass (GPG-based)
export API_KEY=$(pass show api/example)

# Bitwarden
export API_KEY=$(bw get password api-key)
```

**`direnv` — auto-load per direktori:**

```bash
# Install
brew install direnv

# ~/.zshrc
eval "$(direnv hook zsh)"

# .envrc di proyek
export API_KEY="secret"
```

**Penjelasan:** `direnv` otomatis load `.envrc` saat masuk direktori, unload saat keluar.

**File secret dengan permission ketat:**

```bash
# Buat file secret
umask 077   # Hanya owner yang bisa baca
echo "API_KEY=secret" > ~/.secrets/api_key

# Baca di script
source ~/.secrets/api_key
```

**Penjelasan `umask 077`:** File baru hanya bisa dibaca owner.

**Mask secret di log:**

```bash
log() {
    local msg="$1"
    # Mask nilai env var yang sensitif
    msg="${msg//$API_KEY/***}"
    echo "$msg" >&2
}
```

### 5.3.5.3 — `direnv` & Auto-Loading

**Struktur proyek:**

```bash
proyek/
├── .envrc          # Konfigurasi direnv
├── .env            # Secret (gitignored)
└── script.sh
```

**`.envrc`:**

```bash
# Load .env
dotenv

# Set variabel
export API_URL="https://api.example.com"
export LOG_LEVEL="debug"

# Tambah ke PATH
PATH_add bin
```

**Penjelasan:**
- `dotenv`: Load `.env`.
- `PATH_add bin`: Tambah `bin/` ke `$PATH`.

### Contoh Studi Kasus: Konfigurasi Multi-Environment

```bash
#!/bin/zsh

# Tentukan environment
ENV="${APP_ENV:-development}"

# Load config sesuai environment
case "$ENV" in
    production)
        source ~/.config/app/production.env
        ;;
    staging)
        source ~/.config/app/staging.env
        ;;
    *)
        source ~/.config/app/development.env
        ;;
esac

# Validasi variabel wajib
for var in API_URL API_KEY DB_URL; do
    if [[ -z "${(P)var}" ]]; then
        echo "Error: $var tidak di-set" >&2
        exit 1
    fi
done

echo "Menjalankan di $ENV..."
```

**Penjelasan `${(P)var}`:** **Indirect expansion** — ambil nilai variabel yang namanya ada di `$var`.

### Terminologi Esensial 5.3.5

- **Environment variable**: Variabel yang diwariskan ke child process.
- **`export`**: Tandai variabel untuk diwariskan.
- **`.env`**: File berisi env var.
- **`direnv`**: Auto-load env per direktori.
- **`umask`**: Permission default file baru.
- **Secret**: Data sensitif (password, token).

### Struktur Pembelajaran Internal (Mini TOC 5.3.5)

1. Filosofi 12-factor
2. `export` & `.zshrc`
3. `.zshenv` vs `.zshrc`
4. Baca `.env` dengan `set -a`
5. Secret handling yang aman
6. `direnv` & auto-loading
7. Studi kasus: multi-environment

### Rekomendasi Visualisasi

> Diagram **alur env var**: `[.env] → [direnv] → [shell env] → [script]`. Tambahkan cabang "secret manager" untuk secret.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.5 (array), 5.1.4 (parameter expansion).
- **Terkait**: 5.3.3 (API auth), 5.3.4 (DB credential).
- **Dipakai di**: CI/CD, deployment.

### Sumber Referensi 5.3.5

- "12-Factor App" — https://12factor.net/config
- `direnv`: https://direnv.net/
- Zsh Startup Files: https://zsh.sourceforge.io/Doc/Release/Files.html
- 1Password CLI: https://developer.1password.com/docs/cli/
- `pass`: https://www.passwordstore.org/

### Tips & Praktik Terbaik 5.3.5

- Jangan commit `.env` — tambahkan ke `.gitignore`.
- Gunakan `direnv` untuk proyek.
- Gunakan password manager untuk secret produksi.
- Validasi env var wajib di awal script.
- Gunakan `umask 077` untuk file secret.

### Potensi Kesalahan Umum 5.3.5

| Kesalahan | Solusi |
|-----------|--------|
| Secret di git | `.gitignore` + rotate |
| `source .env` tanpa `set -a` → tidak di-export | Tambahkan `set -a` |
| Env var tidak ada di script non-interaktif | Gunakan `.zshenv` |
| Echo secret ke log | Mask dengan `//$SECRET/***` |

---

## 5.3.6 — Pipeline dengan Alat CLI Modern

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini mengajarkan **menggabungkan alat CLI modern** dalam pipeline. Perannya: otomatisasi operasi cloud, container, dan platform.

### Konsep Kunci & Filosofi Mendalam

**Filosofi pipeline:** Output satu alat = input alat lain. Unix pipe (`|`) adalah perekat.

**Alat modern:**
- `kubectl` (Kubernetes).
- `gh` (GitHub).
- `aws` / `gcloud` / `az`.
- `docker`.

### 5.3.6.1 — `kubectl` + `jq`

**Ambil nama pod:**

```bash
kubectl get pods -o json | jq -r '.items[].metadata.name'
```

**Filter pod running:**

```bash
kubectl get pods -o json \
    | jq -r '.items[] | select(.status.phase == "Running") | .metadata.name'
```

**Ambil image:**

```bash
kubectl get pods -o json \
    | jq -r '.items[] | [.metadata.name, .spec.containers[0].image] | @tsv'
```

**Format custom:**

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
```

**Penjelasan:** `-o custom-columns` — format output tanpa `jq`.

### 5.3.6.2 — `gh` CLI (GitHub)

**List PR:**

```bash
gh pr list --json number,title,author \
    | jq -r '.[] | "#\(.number) \(.title) by \(.author.login)"'
```

**Buat issue:**

```bash
gh issue create --title "Bug: ..." --body "Deskripsi..." --label bug
```

**Lihat repo:**

```bash
gh repo view --json name,description,stargazerCount
```

**API langsung:**

```bash
gh api repos/owner/repo/pulls | jq -r '.[].title'
```

**Penjelasan:** `gh api` memanggil GitHub REST API dengan auth otomatis.

### 5.3.6.3 — `aws` / `gcloud` CLI

**AWS S3:**

```bash
aws s3 ls s3://bucket/ --recursive | awk '{print $4}'

# Output JSON
aws s3api list-objects-v2 --bucket mybucket \
    | jq -r '.Contents[].Key'
```

**AWS EC2:**

```bash
aws ec2 describe-instances \
    | jq -r '.Reservations[].Instances[] | [.InstanceId, .State.Name] | @tsv'
```

**gcloud:**

```bash
gcloud compute instances list --format=json \
    | jq -r '.[] | [.name, .status] | @tsv'
```

**Penjelasan `--format=json`:** Output JSON untuk di-pipe ke `jq`.

### Contoh Studi Kasus: Dashboard Cluster

```bash
#!/bin/zsh

dashboard() {
    echo "=== Pods ==="
    kubectl get pods -o json \
        | jq -r '.items[] | [.metadata.name, .status.phase] | @tsv' \
        | column -t
    
    echo ""
    echo "=== Nodes ==="
    kubectl get nodes -o json \
        | jq -r '.items[] | [.metadata.name, .status.capacity.cpu, .status.capacity.memory] | @tsv' \
        | column -t
}

dashboard
```

**Penjelasan `column -t`:** Format output jadi tabel rapi.

### Terminologi Esensial 5.3.6

- **`kubectl`**: CLI Kubernetes.
- **`gh`**: CLI GitHub.
- **`aws` / `gcloud`**: CLI cloud.
- **`-o json`**: Format output JSON.
- **`column -t`**: Format tabel.
- **`@tsv`**: Format TSV di `jq`.

### Struktur Pembelajaran Internal (Mini TOC 5.3.6)

1. Filosofi pipeline
2. `kubectl` + `jq`
3. `gh` CLI
4. `aws` / `gcloud`
5. Studi kasus: dashboard cluster

### Rekomendasi Visualisasi

> Diagram **pipeline**: `[kubectl] → jq → column → [output]`. Ini menunjukkan alur data.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.3.2 (`jq`).
- **Terkait**: 5.3.7 (pipeline error).
- **Dipakai di**: CI/CD, monitoring.

### Sumber Referensi 5.3.6

- `kubectl` Docs: https://kubernetes.io/docs/reference/kubectl/
- `gh` CLI: https://cli.github.com/manual/
- AWS CLI: https://aws.amazon.com/cli/
- gcloud: https://cloud.google.com/sdk/gcloud

### Tips & Praktik Terbaik 5.3.6

- Gunakan `-o json` untuk parsing fleksibel.
- `jq -r` untuk raw output.
- `column -t` untuk tampilan tabel.
- Simpan fungsi reusable di `~/.zsh/functions/`.

### Potensi Kesalahan Umum 5.3.6

| Kesalahan | Solusi |
|-----------|--------|
| `kubectl` output tabel → sulit parse | Gunakan `-o json` |
| `jq` error karena output bukan JSON | Cek dengan `jq .` dulu |
| Auth expired | Refresh token/credential |

---

## 5.3.7 — Pipeline Error Handling *(Materi Tambahan Audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada di kurikulum asli** Anda, tetapi saya tambahkan karena pipeline tanpa error handling adalah sumber bug yang sering terlewat. Ini melengkapi 5.3.6.

### Konsep Kunci & Filosofi Mendalam

**Masalah default:** Exit code pipeline = exit code perintah **terakhir**. Jika `curl` gagal tapi `jq` sukses, pipeline dianggap sukses.

```bash
false | true
echo $?   # 0 — padahal false gagal!
```

**Filosofi:** Shell default "optimis" — anggap sukses kecuali perintah terakhir gagal. Untuk pipeline kritikal, ini bahaya.

### 5.3.7.1 — `pipefail` & `pipestatus` di Zsh

**`setopt pipefail`:**

```bash
setopt pipefail
false | true
echo $?   # 1 — sekarang mendeteksi kegagalan
```

**Penjelasan:** Dengan `pipefail`, exit code pipeline = exit code **terakhir yang non-zero**.

**`pipestatus` (Zsh) vs `PIPESTATUS` (Bash):**

```bash
# Zsh — lowercase, 1-indexed
false | true | false
echo "${pipestatus[@]}"   # 1 0 1
echo "${pipestatus[1]}"   # 1
```

**Penjelasan penting:**
- Zsh: `pipestatus` (lowercase), index dari **1**.
- Bash: `PIPESTATUS` (uppercase), index dari **0**.
- **Jangan** pakai `${PIPESTATUS[0]}` di Zsh — kosong.

**Cek setiap stage:**

```bash
setopt pipefail

curl -s https://api.example.com/data | jq '.items' | head -5

if [[ "${pipestatus[1]}" -ne 0 ]]; then
    echo "curl gagal" >&2
    exit 1
fi
if [[ "${pipestatus[2]}" -ne 0 ]]; then
    echo "jq gagal" >&2
    exit 1
fi
```

### 5.3.7.2 — Pola Aman untuk Pipeline

**1. `set -e` + `setopt pipefail`:**

```bash
#!/bin/zsh
set -e
setopt pipefail

# Script berhenti jika ada yang gagal
curl -s https://api.example.com/data | jq '.items'
```

**Penjelasan:**
- `set -e`: Exit on error.
- `setopt pipefail`: Pipeline gagal jika ada stage gagal.

**2. Simpan exit code sebelum perintah lain:**

```bash
result=$(curl -s https://api.example.com/data)
curl_status=$?
jq_status=$?

if [[ $curl_status -ne 0 ]]; then
    echo "curl gagal: $curl_status" >&2
    exit 1
fi
```

**Penjelasan:** `$?` harus disimpan **segera** — perintah berikutnya menimpa.

**3. `if` dengan pipeline:**

```bash
if ! curl -sf https://api.example.com/data | jq -e '.items'; then
    echo "Pipeline gagal" >&2
    exit 1
fi
```

**Penjelasan `jq -e`:** Exit 1 jika output null/false.

**4. `trap` untuk cleanup:**

```bash
#!/bin/zsh
set -e
setopt pipefail

cleanup() {
    rm -f /tmp/temp_*
}
trap cleanup EXIT

curl -s https://api.example.com/data > /tmp/temp_data
jq '.items' /tmp/temp_data
```

**Penjelasan:** `trap cleanup EXIT` memastikan cleanup dijalankan meski script gagal.

**5. Logging setiap stage:**

```bash
run_pipeline() {
    local status
    
    curl -s https://api.example.com/data | jq '.items' | tee /tmp/out.json
    status=("${pipestatus[@]}")
    
    local i=1
    for code in "${status[@]}"; do
        [[ "$code" -ne 0 ]] && echo "Stage $i gagal (exit $code)" >&2
        ((i++))
    done
    
    return ${status[-1]}
}
```

### Contoh Studi Kasus: Pipeline API → Database

```bash
#!/bin/zsh
set -e
setopt pipefail

sync_users() {
    local response
    
    # 1. Fetch dari API
    response=$(curl -sf https://api.example.com/users) || {
        echo "Gagal fetch API" >&2
        return 1
    }
    
    # 2. Parse JSON
    local users
    users=$(echo "$response" | jq -r '.users[] | [.id, .nama, .email] | @csv') || {
        echo "Gagal parse JSON" >&2
        return 1
    }
    
    # 3. Import ke database
    echo "$users" | psql -d mydb -c "COPY users FROM STDIN CSV;" || {
        echo "Gagal import DB" >&2
        return 1
    }
    
    echo "Sync selesai: $(echo "$users" | wc -l) users"
}

sync_users
```

### Terminologi Esensial 5.3.7

- **`setopt pipefail`**: Exit pipeline jika stage gagal.
- **`pipestatus`**: Array exit code tiap stage (Zsh, 1-indexed).
- **`PIPESTATUS`**: Versi Bash (0-indexed).
- **`set -e`**: Exit on error.
- **`trap ... EXIT`**: Cleanup saat exit.
- **`jq -e`**: Exit 1 jika null/false.

### Struktur Pembelajaran Internal (Mini TOC 5.3.7)

1. Masalah default pipeline
2. `setopt pipefail`
3. `pipestatus` vs `PIPESTATUS`
4. Cek setiap stage
5. Pola aman: `set -e` + `trap`
6. Studi kasus: API → DB

### Rekomendasi Visualisasi

> Diagram **pipeline dengan exit code**: setiap kotak punya exit code sendiri. Ini menunjukkan mengapa `pipefail` penting.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.3.3 (curl), 5.3.4 (DB).
- **Terkait**: 5.3.6 (pipeline CLI).
- **Dipakai di**: Semua script produksi.

### Sumber Referensi 5.3.7

- Zsh `pipestatus`: https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-pipestatus
- Zsh Options: https://zsh.sourceforge.io/Doc/Release/Options.html
- "Bash Pitfalls" — https://mywiki.wooledge.org/BashPitfalls

### Tips & Praktik Terbaik 5.3.7

- Selalu `setopt pipefail` di script kritikal.
- Simpan `$?` segera setelah perintah.
- Gunakan `trap ... EXIT` untuk cleanup.
- Ingat: Zsh `pipestatus` 1-indexed, Bash `PIPESTATUS` 0-indexed.

### Potensi Kesalahan Umum 5.3.7

| Kesalahan | Solusi |
|-----------|--------|
| `${PIPESTATUS[0]}` di Zsh → kosong | Gunakan `${pipestatus[1]}` |
| `$?` setelah perintah lain → nilai salah | Simpan segera |
| Lupa `pipefail` → error tersembunyi | Tambahkan `setopt pipefail` |

---

## 5.3.8 — Keamanan Script Zsh *(Materi Tambahan Audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak ada di kurikulum asli** Anda, tetapi saya tambahkan karena keamanan adalah aspek kritis yang sering diabaikan. Ini melengkapi semua modul 5.3.

### Konsep Kunci & Filosofi Mendalam

**Filosofi:** Script shell berjalan dengan **hak user**. Jika script rentan, penyerang bisa mengeksekusi kode arbitrer dengan hak yang sama.

**Tiga vektor serangan utama:**
1. **Command injection**: Input user di-`eval` atau di-interpolasi ke perintah.
2. **Path traversal**: Input `../../etc/passwd`.
3. **Prompt injection**: Input berisi escape sequence.

### 5.3.8.1 — Bahaya `eval` & Injection

**`eval` mengeksekusi string sebagai kode:**

```bash
# BAHAYA
user_input="rm -rf /"
eval "$user_input"   # Menghapus seluruh filesystem!
```

**Mengapa `eval` berbahaya:**
- Input tidak dipercaya → kode arbitrer.
- Quoting sulit → mudah salah.
- Sama dengan `system()` di C.

**Alternatif aman:**

```bash
# JANGAN
eval "ls $user_input"

# GUNAKAN — array
args=("$user_input")
ls "${args[@]}"
```

**Jika `eval` terpaksa:**

```bash
# Sanitasi: hanya alphanumeric
if [[ "$user_input" =~ ^[a-zA-Z0-9_]+$ ]]; then
    eval "$user_input"
else
    echo "Input tidak valid" >&2
    return 1
fi
```

**Penjelasan:** Regex `^[a-zA-Z0-9_]+$` memastikan hanya karakter aman.

### 5.3.8.2 — Quoting yang Benar

**Selalu quote variabel:**

```bash
# BAHAYA — jika $file berisi spasi
rm $file

# AMAN
rm "$file"
```

**Penjelasan:** Tanpa quote, shell melakukan **word splitting** — `file="a b"` jadi dua argumen.

**Quote dalam array:**

```bash
# AMAN
args=("-f" "$file" "--output" "$out")
command "${args[@]}"
```

**Jangan pakai `eval` untuk quote:**

```bash
# BAHAYA
eval "command '$user_input'"

# AMAN — array
command "$user_input"
```

**Zsh-specific: `${(q)var}`:**

```bash
# Quote untuk shell
quoted="${(q)user_input}"
# Hasil: string yang aman untuk eval
```

**Penjelasan:** `${(q)var}` — flag `q` menambahkan quote yang diperlukan.

### 5.3.8.3 — Zsh-Specific Risks

**1. Glob qualifiers `(e:)` dan `(+)`:**

```bash
# BAHAYA — eksekusi kode saat glob
ls *(e:'echo hacked':)
```

**Penjelasan:** Glob qualifier `(e:...)` mengeksekusi kode. Jangan gunakan dengan input user.

**2. `PROMPT_SUBST` dan prompt injection:**

```bash
# BAHAYA — jika branch name berisi escape
setopt prompt_subst
PS1='$(git branch --show-current) $ '
```

**Solusi:**

```bash
# Escape % dan $ di output
precmd() {
    local branch=$(git branch --show-current)
    branch="${branch//\%/%%}"   # Escape %
    PS1="${branch} $ "
}
```

**3. `zmodload` dan modul berbahaya:**

```bash
# BAHAYA — bisa buka socket
zmodload zsh/net/tcp
```

**4. `source` file dari direktori yang tidak aman:**

```bash
# BAHAYA — file bisa dimodifikasi
source /tmp/user_script.zsh

# AMAN — verifikasi permission
if [[ -O /tmp/user_script.zsh ]]; then
    source /tmp/user_script.zsh
fi
```

**Penjelasan `-O`:** Cek apakah file dimiliki oleh user saat ini.

### Contoh Studi Kasus: Sanitasi Input

```bash
#!/bin/zsh

validate_input() {
    local input="$1"
    
    # Hanya alphanumeric dan dash
    if [[ ! "$input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Input tidak valid: $input" >&2
        return 1
    fi
    
    echo "$input"
}

# Penggunaan
user_file=$(validate_input "$1") || exit 1
cat "/safe/path/$user_file"
```

### Terminologi Esensial 5.3.8

- **Command injection**: Eksekusi kode arbitrer via input.
- **`eval`**: Eksekusi string sebagai kode.
- **Word splitting**: Pemecahan string jadi kata.
- **Quoting**: Melindungi dari word splitting.
- **`${(q)var}`**: Quote otomatis.
- **Glob qualifier**: Modifier glob `(...)`.
- **`PROMPT_SUBST`**: Substitusi di prompt.

### Struktur Pembelajaran Internal (Mini TOC 5.3.8)

1. Filosofi keamanan script
2. Bahaya `eval`
3. Alternatif `eval`
4. Quoting yang benar
5. Zsh-specific risks
6. Sanitasi input
7. Studi kasus

### Rekomendasi Visualisasi

> Diagram **vektor serangan**: input → `eval` → eksekusi. Ini menunjukkan alur serangan.

### Hubungan dengan Modul Lain

- **Prasyarat**: 5.1.4 (parameter expansion), 5.1.5 (array).
- **Terkait**: 5.3.5 (secret handling).
- **Dipakai di**: Semua script produksi.

### Sumber Referensi 5.3.8

- "Bash Pitfalls" — https://mywiki.wooledge.org/BashPitfalls
- Zsh Glob Qualifiers: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
- OWASP Command Injection: https://owasp.org/www-community/attacks/Command_Injection
- Zsh Security: https://zsh.sourceforge.io/Doc/Release/Options.html

### Tips & Praktik Terbaik 5.3.8

- Hindari `eval` — gunakan array.
- Selalu quote `"$var"`.
- Sanitasi input dengan regex.
- Jangan `source` file yang tidak dipercaya.
- Gunakan `${(q)var}` untuk quote.

### Potensi Kesalahan Umum 5.3.8

| Kesalahan | Solusi |
|-----------|--------|
| `eval "$user_input"` | Gunakan array |
| `rm $file` | `rm "$file"` |
| Glob qualifier dengan input user | Validasi dulu |
| Source file world-writable | Cek `-O` |

---

## Penutup Modul 5.3

### Rangkuman Keterampilan

Setelah Modul 5.3, Anda harus mampu:
- Memanggil Python/Node/Ruby dari Zsh.
- Memproses JSON dengan `jq` (dan fallback).
- Berinteraksi dengan REST API (GET/POST, auth, retry).
- Query database (`psql`, `mysql`, `sqlite3`).
- Mengelola environment variable & secret dengan aman.
- Membangun pipeline dengan alat CLI modern.
- Menangani error pipeline dengan `pipefail` & `pipestatus`.
- Menulis script Zsh yang aman.

### Visualisasi Keseluruhan Modul 5.3

> Diagram **arsitektur integrasi lengkap**:
> ```
> [Zsh Script]
>     │
>     ├─► Python/Node (logika kompleks)
>     ├─► jq (parsing JSON)
>     ├─► curl (REST API)
>     ├─► psql/mysql/sqlite3 (database)
>     ├─► kubectl/gh/aws (CLI modern)
>     │
>     └─► Semua di-pipeline dengan error handling
> ```

### Referensi Lengkap Modul 5.3

- `jq` Manual: https://stedolan.github.io/jq/manual/
- `curl` Man Page: https://curl.se/docs/manpage.html
- `psql` Docs: https://www.postgresql.org/docs/current/app-psql.html
- `sqlite3` CLI: https://sqlite.org/cli.html
- `direnv`: https://direnv.net/
- 12-Factor App: https://12factor.net/config
- Zsh `pipestatus`: https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-pipestatus
- Bash Pitfalls: https://mywiki.wooledge.org/BashPitfalls
- OWASP Command Injection: https://owasp.org/www-community/attacks/Command_Injection

---


# ✅ Selamat! anda telah menyelesaikan

Modul **5.3** dengan cakupan:
- ✅ Mengapa integrasi penting (tambahan audit)
- ✅ Memanggil Python/Ruby/Node
- ✅ `jq` + fallback tanpa `jq`
- ✅ REST API: curl, retry, auth, rate limit
- ✅ Database: psql, mysql, sqlite3
- ✅ Environment variable & secret handling
- ✅ Pipeline CLI modern (kubectl, gh, aws)
- ✅ Pipeline error handling (`pipefail`, `pipestatus`) — tambahan audit
- ✅ Keamanan script Zsh — tambahan audit

---

<!-- **Apakah Anda ingin saya lanjutkan ke Fase berikutnya?** Jika ada Fase 6 dalam kurikulum Anda, silakan berikan isinya. Jika tidak, saya bisa: -->
<!-- - Membuat **rangkuman eksekutif Fase 5**. -->
<!-- - Membuat **proyek akhir Fase 5** (integrasi semua konsep). -->
<!-- - Membahas **topik lanjutan** yang belum tercakup. -->

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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

