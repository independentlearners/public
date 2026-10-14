# Pelajaran 19 — Integrasi Terminal dengan Zsh

Dalam pelajaran ini, kita mempelajari hubungan antara Zsh, terminal emulator, dan program eksternal. Fokusnya adalah memahami batas tanggung jawab masing-masing komponen dan bagaimana konfigurasi Zsh dapat memanfaatkan kemampuan terminal.

## 1. Memahami tiga komponen utama

### Stack shell

```bash
Sistem Interaktif
├── Terminal emulator
│   ├── Foot, Alacritty, Kitty
│   └── Menampilkan teks dan meneruskan input keyboard.
│
├── Zsh
│   ├── Shell interaktif
│   └── Membaca perintah, menjalankan program, mengelola ekspansi,
│       dan mengatur interaksi melalui ZLE.
│
└── Program eksternal
    ├── Git, fzf, zoxide, yazi
    └── Menyediakan kemampuan yang dipanggil atau diintegrasikan oleh shell.

┌─────────────────────────────────────────────┐
│ Terminal emulator - Foot, Alacritty, Kitty  │
│ Menampilkan teks dan meneruskan input       │
│  ┌───────────────────────────────────────┐  │
│  │ Zsh - Shell interaktif                │  │
│  │ Membaca perintah, menjalankan program │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │ Program eksternal               │  │  │
│  │  │ Git, fzf, zoxide, yazi          │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

Ketiganya berbeda:

- Terminal emulator menangani antarmuka terminal.
- Zsh memproses perintah dan mengelola sesi shell.
- Program eksternal melakukan tugas khusus yang tidak harus ditangani oleh Zsh sendiri.

Contohnya, `fzf` adalah program pencarian interaktif. Zsh dapat memanggilnya dan menghubungkan hasilnya dengan baris perintah, tetapi antarmuka pencarian `fzf` bukan fitur bawaan Zsh.

## 2. Bagaimana Zsh berkomunikasi dengan terminal?

Terminal menyediakan antarmuka yang dapat digunakan program melalui input, output, dan urutan kontrol terminal.

Misalnya, Zsh dapat menampilkan teks menggunakan:

```bash
print -r -- "Halo dari Zsh"
```

Untuk mengubah judul terminal, banyak terminal emulator mendukung urutan kontrol berbasis OSC (Operating System Command). Salah satu bentuk yang umum didukung adalah OSC 0:

```bash
print -Pn '\e]0;Zsh Lab\a'
```

Bagian-bagiannya:

- `print`: builtin untuk menampilkan keluaran.
- `-P`: mengaktifkan ekspansi prompt.
- `-n`: tidak menambahkan newline.
- `\e`: karakter ESC.
- `]0;`: urutan kontrol OSC 0 untuk menetapkan judul ikon dan jendela pada terminal yang mendukungnya.
- `Zsh Lab`: teks judul.
- `\a`: karakter BEL yang mengakhiri urutan tersebut.

Dukungan dan perilaku persisnya bergantung pada terminal emulator dan konfigurasinya. Urutan kontrol terminal bukan fitur yang dijamin seragam di semua terminal.

Anda dapat mencoba perintah ini pada terminal uji. Jika judul tidak berubah, itu belum tentu menunjukkan kesalahan pada Zsh.

## 3. Menggunakan informasi terminal dari Zsh

Zsh dapat membaca sejumlah variabel lingkungan yang memberi informasi tentang sesi terminal.

Contoh:

```bash
print -r -- "TERM=$TERM"
print -r -- "TTY=$(tty)"
print -r -- "ZSH_VERSION=$ZSH_VERSION"
```

Penjelasan:

- `$TERM` memberi tahu program jenis kemampuan terminal yang diharapkan. Nilainya bukan selalu nama terminal emulator secara langsung.
- `tty` menampilkan nama terminal perangkat yang terhubung dengan input standar, jika ada.
- `$ZSH_VERSION` menunjukkan versi Zsh yang sedang berjalan.

Pada sesi terminal interaktif, hasil `tty` biasanya berupa perangkat seperti `/dev/pts/2`. Nomor dan nama perangkat dapat berbeda setiap sesi.

Pemeriksaan ini berguna ketika Anda mendiagnosis masalah keybindings, warna, atau perilaku program terminal.

## 4. Integrasi dengan program eksternal

Konfigurasi Zsh sering menyediakan integrasi agar program eksternal lebih nyaman digunakan.

Contoh yang relevan dengan lingkungan Anda:

| Program | Peran                      | Bentuk integrasi                                                        |
| ------- | -------------------------- | ----------------------------------------------------------------------- |
| Git     | Kontrol versi              | Alias, fungsi, completion, prompt                                       |
| fzf     | Pencarian fuzzy interaktif | Fungsi pencarian dan keybindings                                        |
| zoxide  | Navigasi direktori         | Fungsi atau perintah `z`                                                |
| yazi    | File manager terminal      | Fungsi untuk membuka file manager dan kembali ke direktori yang dipilih |

Integrasi tidak selalu berarti sekadar membuat alias. Beberapa program menyediakan kode khusus untuk shell tertentu.

Sebagai contoh, integrasi zoxide dapat menggunakan inisialisasi yang menghasilkan fungsi shell. Fungsi tersebut memungkinkan perintah `z` mengubah direktori shell saat ini.

Hal ini penting karena program eksternal biasa tidak dapat mengubah direktori kerja shell induknya hanya dengan menjalankan `cd` pada proses terpisah. Integrasi shell mengatasi persoalan tersebut dengan menjalankan perubahan direktori di lingkungan shell yang aktif.

## 5. Contoh praktis: fungsi pembuka yazi

File manager seperti yazi berjalan sebagai proses eksternal. Untuk mengubah direktori kerja Zsh setelah yazi ditutup, integrasi shell biasanya perlu menangkap direktori tujuan lalu melakukan `cd` dari shell itu sendiri.

Berikut ilustrasi mekanismenya, bukan pengganti integrasi resmi yazi:

```bash
yazi-cd-demo() {
    local cwd_file
    cwd_file=$(mktemp) || return 1

    yazi --cwd-file="$cwd_file"
    local status=$?

    if [[ -s "$cwd_file" ]]; then
        local new_dir
        IFS= read -r new_dir < "$cwd_file"

        if [[ -n "$new_dir" && -d "$new_dir" ]]; then
            builtin cd -- "$new_dir"
        fi
    fi

    command rm -f -- "$cwd_file"
    return "$status"
}
```

Ada beberapa konsep yang perlu diperhatikan:

1. `mktemp` membuat file sementara untuk menyimpan direktori tujuan.
2. Yazi berjalan sebagai program eksternal.
3. `--cwd-file` meminta Yazi menulis direktori yang dipilih ke file tersebut.
4. Zsh membaca hasilnya, kemudian menjalankan `cd` pada shell aktif.
5. File sementara dibersihkan setelah digunakan.

Contoh ini mengasumsikan versi Yazi Anda mendukung `--cwd-file`. Untuk penggunaan nyata, penanganan status keluar, sinyal, dan pembersihan file sementara perlu disesuaikan dengan kebutuhan. Jangan mengganti integrasi yazi yang sudah berfungsi tanpa memeriksa implementasi yang sekarang.

## 6. Latihan

Jalankan perintah berikut dari terminal Zsh:

```bash
print -r -- "Shell: $SHELL"
print -r -- "Versi: $ZSH_VERSION"
print -r -- "Terminal: $TERM"
tty
```

Kemudian jawab pertanyaan berikut.

1\. Komponen mana yang bertanggung jawab memproses perintah shell?

Terminal emulator

Zsh

Window manager

2\. Mengapa fungsi shell berguna untuk integrasi file manager?

Agar program eksternal dapat langsung mengubah direktori shell induk

Agar shell dapat melakukan cd sendiri berdasarkan hasil program eksternal

Agar terminal emulator tidak perlu berjalan

3\. Apakah nilai TERM selalu merupakan nama terminal emulator?

Ya

Tidak

Ulangi latihan

Target pelajaran: Anda dapat membedakan terminal emulator, shell, dan program eksternal; memahami penggunaan variabel terminal; serta menjelaskan mengapa integrasi tertentu harus berjalan di dalam shell aktif.

Pelajaran berikutnya adalah Pelajaran 20 — Membangun Fitur Produktivitas Sendiri, dengan fokus menggabungkan fungsi, parameter expansion, hooks, dan mekanisme interaktif Zsh untuk membuat fitur yang benar-benar berguna.

# Pelajaran 20 — Membangun Fitur Produktivitas Sendiri

Tujuan tahap ini adalah mulai menggabungkan mekanisme Zsh yang sudah dipelajari—fungsi, parameter expansion, hooks, konfigurasi modular, dan integrasi program eksternal—menjadi fitur yang benar-benar berguna.

Prinsip utamanya: pahami mekanismenya terlebih dahulu, lalu implementasikan fiturnya. Jangan langsung bergantung pada plugin untuk sesuatu yang bisa dibangun dengan fungsi Zsh sederhana.

## 1. Tentukan kebutuhan sebelum menulis kode

Misalnya, Anda ingin membuat perintah `mkcd` yang:

1. Menerima nama direktori sebagai argumen.
2. Membuat direktori tersebut jika belum ada.
3. Langsung berpindah ke direktori itu.
4. Menampilkan kegagalan jika pembuatan atau perpindahan direktori tidak berhasil.

Alur kerjanya:

Panggil `mkcd nama-direktori`

Validasi argumen

Buat direktori

Pindah ke direktori

Pola ini juga berguna saat membangun fitur lain: tentukan input, proses, keluaran, dan perilaku ketika terjadi kesalahan.

## 2. Implementasikan sebagai fungsi Zsh

```
mkcd() {
    if (( $# != 1 )); then
        print -u2 -- "Penggunaan: mkcd <direktori>"
        return 2
    fi

    mkdir -p -- "$1" || return $?
    builtin cd -- "$1"
}
```

Mari kita bedah setiap bagian.

\| Kode | Tujuan | |---|---| | `mkcd() { ... }` | Mendefinisikan fungsi bernama `mkcd`. | | `(( $# != 1 ))` | Memeriksa apakah jumlah argumen bukan satu. `$#` berisi jumlah argumen fungsi. | | `print -u2 -- ...` | Mengirim pesan penggunaan ke stderr, yaitu file descriptor 2. | | `return 2` | Mengakhiri fungsi dengan status yang menandakan penggunaan argumen tidak valid. | | `mkdir -p -- "$1"` | Membuat direktori beserta direktori induknya jika diperlukan. | | `|| return $?` | Jika `mkdir` gagal, hentikan fungsi dan teruskan status kegagalannya. | | `builtin cd -- "$1"` | Memanggil builtin `cd` milik Zsh untuk berpindah direktori. |

Ada beberapa konsep penting di sini:

- `"$1"` diberi tanda kutip agar nama direktori yang mengandung spasi tetap diperlakukan sebagai satu argumen.
- `--` menandai akhir opsi untuk perintah yang mendukungnya, sehingga nama yang diawali tanda minus tidak keliru dianggap sebagai opsi.
- `builtin cd` memastikan kita memanggil builtin shell. Perubahan direktori harus dilakukan di shell yang sedang berjalan, bukan di proses eksternal terpisah.
- `return $?` harus dieksekusi langsung setelah kegagalan yang ingin diteruskan karena `$?` menyimpan status perintah terakhir.

## 3. Tempatkan dalam konfigurasi modular

Karena konfigurasi Anda menggunakan `~/.config/zsh/`, fungsi ini cocok diletakkan di:

```
~/.config/zsh/
├── zshrc
└── functions.zsh
```

Tambahkan fungsi `mkcd` ke `functions.zsh`, lalu pastikan `zshrc` memuatnya:

```
[[ -r "$ZDOTDIR/functions.zsh" ]] &&
    source "$ZDOTDIR/functions.zsh"
```

Jangan langsung menganggap `$ZDOTDIR` selalu menunjuk ke `~/.config/zsh`. Periksa terlebih dahulu:

```
print -r -- "${ZDOTDIR:-$HOME}"
```

Jika `ZDOTDIR` tidak ditetapkan, ekspresi tersebut menggunakan `$HOME`. Sesuaikan lokasi file dengan konfigurasi aktual Anda.

## 4. Uji perilakunya

Setelah memuat ulang konfigurasi atau membuka sesi Zsh baru, jalankan:

```
mkcd ~/tmp/zsh-lab/nested
pwd
```

Lalu uji kondisi berikut:

```
mkcd
print -r -- $?
```

Seharusnya fungsi menampilkan petunjuk penggunaan dan mengembalikan status `2`.

Uji juga dengan direktori yang mengandung spasi:

```
mkcd "$HOME/tmp/zsh lab"
```

Untuk menguji kegagalan, coba gunakan lokasi yang tidak dapat ditulisi oleh pengguna Anda. Hasilnya bergantung pada izin filesystem dan kondisi sistem.

## 5. Latihan analisis

Sebelum lanjut, coba jawab tiga pertanyaan ini.

1\. Mengapa kita menggunakan `"$1"` dan bukan `$1` tanpa tanda kutip?

Agar nilai argumen tetap satu kata meskipun mengandung spasi.

Agar fungsi berjalan sebagai proses baru.

Agar argumen otomatis diekspor ke environment.

2\. Mengapa `cd` harus dijalankan oleh shell saat ini?

Karena direktori kerja shell induk tidak berubah ketika proses anak berpindah direktori.

Karena `cd` hanya tersedia pada shell login.

Karena `mkdir` tidak dapat membuat direktori.

3\. Apa yang terjadi ketika `mkdir` gagal?

Fungsi tetap menjalankan `cd`.

Fungsi mengembalikan status kegagalan `mkdir` dan berhenti.

Zsh otomatis menutup sesi.

Periksa jawaban

Setelah latihan ini, tahap berikutnya adalah Pelajaran 21 — Membaca Source Code Plugin Zsh. Di sana kita akan mempelajari cara menemukan entry point plugin, melacak fungsi dan hooks yang digunakan, serta memahami bagaimana suatu fitur dibangun dari mekanisme Zsh yang telah Anda pelajari.

# Pelajaran 21 — Membaca Source Code Plugin Zsh

Target pelajaran ini adalah memahami bagaimana membaca plugin Zsh untuk menemukan entry point, melacak fungsi yang dipanggil, dan mengenali mekanisme Zsh yang membentuk fitur plugin.

Anda tidak perlu langsung memahami seluruh repositori. Mulailah dengan menelusuri alur eksekusinya.

## 1. Kenali struktur plugin

Sebuah plugin dapat memiliki struktur seperti berikut:

```
example-plugin/
├── README.md
├── example-plugin.plugin.zsh
├── functions/
│   └── example-command
└── completions/
    └── _example-command
```

| Bagian         | Yang perlu diperiksa                                 |
| -------------- | ---------------------------------------------------- |
| `README.md`    | Tujuan, cara instalasi, konfigurasi, dan penggunaan. |
| `*.plugin.zsh` | File yang biasanya menjadi titik masuk plugin.       |
| `functions/`   | Fungsi yang mungkin didaftarkan melalui `autoload`.  |
| `completions/` | Fungsi completion untuk melengkapi argumen perintah. |

Struktur tersebut hanya contoh. Tidak semua plugin menggunakan nama file atau direktori yang sama.

## 2. Baca file utama terlebih dahulu

Ketika membuka repositori plugin, cari pola berikut:

```
source ...
autoload -Uz ...
fpath=(...)
compinit
compdef ...
bindkey ...
zle -N ...
add-zsh-hook ...
setopt ...
```

Setiap pola memberikan petunjuk berbeda:

- `source`: menjalankan file konfigurasi lain dalam shell saat ini.
- `autoload -Uz`: mendaftarkan fungsi agar dapat dimuat ketika dipanggil.
- `fpath`: menentukan direktori tempat Zsh mencari fungsi autoload.
- `compdef`: menghubungkan fungsi completion dengan perintah.
- `bindkey` dan `zle -N`: berkaitan dengan widget serta pemetaan tombol di ZLE.
- `add-zsh-hook`: mendaftarkan fungsi pada hook Zsh.

Jangan menyimpulkan fungsi sebuah plugin hanya dari nama file. Telusuri apa yang benar-benar dilakukan kodenya.

## 3. Telusuri kode dengan perintah terminal

Misalkan repositori plugin sudah tersedia di direktori `plugin-dir`. Masuk ke direktori tersebut:

```
cd plugin-dir
```

Lihat struktur file:

```
find . -maxdepth 3 -type f -print
```

Cari mekanisme Zsh yang relevan:

```
grep -nRE \
  'source |autoload|fpath|compdef|bindkey|zle -N|add-zsh-hook|setopt' \
  --include='*.zsh' --include='_*' .
```

Arti argumennya:

- `-n`: tampilkan nomor baris.
- `-R`: telusuri direktori secara rekursif.
- `-E`: gunakan pola regular expression yang diperluas.
- `--include`: batasi pencarian ke pola nama file yang ditentukan.
- `.`: mulai pencarian dari direktori saat ini.

Perintah ini hanya membantu menemukan titik yang menarik; ia bukan parser Zsh. Hasilnya bisa mencakup komentar atau kode yang tidak aktif.

Setelah menemukan file yang relevan, baca rentang barisnya:

```
sed -n '1,120p' example-plugin.plugin.zsh
```

Ganti nama file dengan file yang benar-benar ditemukan. Hindari langsung menjalankan `source` pada plugin yang belum Anda percaya, karena kode tersebut dapat mengubah konfigurasi shell atau menjalankan perintah eksternal.

## 4. Latihan membaca plugin mini

Perhatikan contoh berikut:

```
# example.plugin.zsh
plugin_greet() {
    print -r -- "Halo, $1"
}

alias pgreet=plugin_greet
```

Ini plugin sederhana yang mendefinisikan fungsi dan alias.

Ketika file tersebut dimuat:

```
source ./example.plugin.zsh
```

Zsh menjalankan definisi fungsi dan alias itu dalam shell saat ini. Setelahnya, Anda dapat mencoba:

```
plugin_greet Zsh
pgreet Zsh
```

Keduanya memanggil fungsi yang sama. Namun, alias bukan mekanisme yang sama dengan fungsi: alias melakukan substitusi teks pada saat parsing perintah, sedangkan fungsi menjalankan isi fungsi ketika dipanggil.

Sekarang perhatikan variasi berikut:

```
# example.plugin.zsh
fpath=( "$PWD/functions" $fpath )
autoload -Uz plugin_greet
```

Dengan file fungsi terpisah:

```
# functions/plugin_greet
print -r -- "Halo, $1"
```

Ketika `plugin_greet` dipanggil, Zsh mencari file fungsi melalui `$fpath` dan memuatnya sesuai mekanisme autoload. File fungsi tersebut tidak perlu mendefinisikan `plugin_greet()` secara eksplisit; isi file menjadi tubuh fungsi autoload.

Perbedaan penting: pada contoh pertama, `source` langsung menjalankan file utama. Pada contoh kedua, `autoload` menunda pemuatan isi fungsi hingga fungsi dipanggil.

## 5. Buat catatan analisis untuk setiap plugin

Gunakan urutan ini ketika membaca plugin sungguhan:

1. Tujuan: fitur apa yang disediakan?
2. Entry point: file mana yang dimuat oleh pengguna atau plugin manager?
3. Pemuatan: apakah menggunakan `source`, `autoload`, atau keduanya?
4. Mekanisme: apakah plugin memakai hooks, completion, ZLE, alias, atau fungsi biasa?
5. Ketergantungan: program eksternal, modul Zsh, variabel, atau plugin lain apa yang diperlukan?
6. Efek samping: apakah plugin mengubah options, `PATH`, keybindings, atau perilaku shell?
7. Pengujian: bagaimana memeriksa sintaks dan perilakunya tanpa merusak konfigurasi aktif?

Untuk pemeriksaan sintaks sebuah file:

```
zsh -n example-plugin.plugin.zsh
```

`-n` meminta Zsh memeriksa sintaks tanpa mengeksekusi isi file. Namun, pemeriksaan ini tidak membuktikan bahwa semua fungsi akan bekerja dengan benar.

## Latihan

Pilih satu plugin Zsh yang Anda gunakan atau tertarik pelajari. Temukan file utamanya, lalu jawab:

- File mana yang menjadi entry point?
- Apakah ia memakai `source` atau `autoload`?
- Apakah ada penggunaan `add-zsh-hook`, `compdef`, atau `bindkey`?
- Fitur apa yang benar-benar dihasilkan oleh kode tersebut?

Jika Anda belum memilih plugin, lanjutkan ke Pelajaran 22 — Memodifikasi Plugin yang Sudah Ada, yang membahas cara menentukan lokasi perubahan, memahami ketergantungan, dan menguji modifikasi secara terkontrol.

# Pelajaran 22 — Memodifikasi Plugin Zsh yang Sudah Ada

Tujuan pelajaran ini adalah memahami cara mengubah perilaku plugin yang sudah tersedia tanpa langsung menulis ulang seluruh plugin. Ini merupakan tahap lanjutan dari membaca source code: Anda mulai menghubungkan kode yang ditemukan dengan perubahan fitur yang diinginkan.

## 1. Tentukan perubahan yang ingin dibuat

Sebelum mengubah kode, rumuskan kebutuhan secara spesifik.

Contoh: sebuah plugin memiliki fungsi yang menampilkan pesan setelah berpindah direktori. Anda ingin mengubahnya agar pesan hanya muncul ketika direktori berubah ke lokasi tertentu.

Alur analisisnya:

Perilaku plugin saat ini

Temukan fungsi atau hook yang mengaturnya

Ubah logika sekecil mungkin

Uji perilaku lama dan baru

Jangan mulai dengan mengedit file secara acak. Temukan dahulu hubungan antara entry point, fungsi yang dipanggil, dan mekanisme Zsh yang terlibat.

## 2. Temukan kode yang bertanggung jawab

Misalkan plugin menggunakan hook `chpwd`, yaitu hook yang dijalankan ketika direktori kerja berubah.

Contoh kode plugin:

```
plugin_directory_changed() {
    print -r -- "Direktori baru: $PWD"
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd plugin_directory_changed
```

Untuk memahami perilakunya, perhatikan dua bagian:

- `plugin_directory_changed()` mendefinisikan tindakan yang akan dijalankan.
- `add-zsh-hook chpwd plugin_directory_changed` mendaftarkan fungsi tersebut agar dipanggil oleh mekanisme hook `chpwd`.

Jika Anda ingin mengubah isi pesan, fungsi pertama adalah titik perubahan yang relevan. Jika ingin mengubah kapan fungsi dijalankan, periksa pendaftaran hook dan kondisi di dalam fungsinya.

## 3. Modifikasi perilaku dengan perubahan minimal

Misalnya, Anda hanya ingin menampilkan pesan ketika direktori baru berada di bawah `~/Projects`.

```
plugin_directory_changed() {
    if [[ "$PWD" == "$HOME"/Projects(|/*) ]]; then
        print -r -- "Direktori proyek: $PWD"
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd plugin_directory_changed
```

Pola `(|/*)` adalah pola glob Zsh yang memungkinkan bagian setelah `Projects` kosong atau berupa `/` diikuti karakter lainnya. Karena itu, pola ini mencocokkan `~/Projects` dan subdirektorinya.

Perhatikan bahwa contoh ini menggambarkan modifikasi logika. Jika plugin asli sudah mendaftarkan hook tersebut, jangan menyalin seluruh contoh ke konfigurasi Anda tanpa memeriksa apakah hook akan didaftarkan dua kali.

## 4. Lindungi konfigurasi asli

Sebelum memodifikasi plugin sungguhan, periksa status repositori dan buat perubahan pada branch atau salinan kerja yang terpisah.

Jika plugin dikelola menggunakan Git:

```
git status
git diff
```

Setelah mengubah file:

```
git diff --check
git diff
```

Perintah-perintah ini membantu Anda memeriksa perubahan dan menemukan masalah whitespace. Untuk memeriksa sintaks file Zsh:

```
zsh -n path/to/plugin.zsh
```

Ganti path contoh dengan file yang sebenarnya. Pemeriksaan sintaks tidak menguji seluruh perilaku plugin atau ketergantungannya.

Catatan desain: jika plugin dikelola plugin manager dan pembaruan dapat menimpa perubahan lokal, pertimbangkan untuk membuat fork, menggunakan mekanisme override yang didukung plugin, atau menempatkan perubahan di konfigurasi Anda sendiri. Pilih berdasarkan struktur plugin yang sebenarnya.

## 5. Latihan analisis

Anda menemukan kode berikut dalam sebuah plugin:

```
plugin_chpwd() {
    print -r -- "$PWD"
}

add-zsh-hook chpwd plugin_chpwd
```

Anda ingin agar fungsi tersebut hanya menampilkan direktori ketika nama direktori terakhir adalah `src`.

Coba tentukan:

1. Bagian kode mana yang perlu diubah?
2. Kondisi Zsh apa yang dapat digunakan untuk memeriksa nama direktori?
3. Mengapa Anda perlu memeriksa apakah plugin sudah mendaftarkan hook sebelum menambahkan pendaftaran baru?

Pelajaran selanjutnya adalah Pelajaran 23 — Membangun Plugin Zsh Sendiri, yaitu menyusun file entry point, fungsi, dan integrasi konfigurasi menjadi plugin kecil yang dapat dipelihara.

# Pelajaran 23 — Membangun Plugin Zsh Sendiri

Tujuan pelajaran ini adalah memahami bagaimana menyusun fungsi, entry point, dan integrasi konfigurasi menjadi plugin Zsh kecil yang dapat dikembangkan tanpa harus bergantung pada plugin manager.

Kita akan membuat plugin sederhana bernama `project-tools` yang menyediakan perintah `croot` untuk berpindah ke direktori proyek yang telah ditentukan.

## 1. Rancang struktur plugin

Pisahkan file pemuatan plugin dari implementasi fungsi.

```
project-tools/
├── project-tools.plugin.zsh
└── functions/
    └── croot
```

Tanggung jawab setiap file:

- `project-tools.plugin.zsh`: menambahkan direktori fungsi ke `$fpath` dan mendaftarkan fungsi autoload.
- `functions/croot`: berisi implementasi perintah `croot`.

Pemisahan ini membantu ketika plugin berkembang dan memiliki lebih banyak fungsi.

## 2. Buat file implementasi fungsi

Buat direktori dan file:

```
mkdir -p project-tools/functions
```

Isi `project-tools/functions/croot` dengan:

```
# Pindah ke direktori proyek.
croot() {
    local project_dir="$HOME/Projects"

    if [[ ! -d "$project_dir" ]]; then
        print -u2 -- "Direktori proyek tidak ditemukan: $project_dir"
        return 1
    fi

    builtin cd -- "$project_dir"
}
```

Penjelasan bagian penting:

- `local project_dir=...` menyimpan lokasi proyek sebagai variabel lokal fungsi.
- `[[ ! -d "$project_dir" ]]` memeriksa apakah direktori tersebut tidak ada atau bukan direktori.
- `print -u2` mengirim pesan kesalahan ke stderr.
- `return 1` mengakhiri fungsi dengan status kegagalan.
- `builtin cd` mengubah direktori kerja shell yang sedang berjalan.

Catatan: file fungsi autoload biasanya berisi tubuh fungsi secara langsung, bukan pembungkus `croot() { ... }`. Jadi, bentuk yang benar untuk file `functions/croot` adalah:

```
local project_dir="$HOME/Projects"

if [[ ! -d "$project_dir" ]]; then
    print -u2 -- "Direktori proyek tidak ditemukan: $project_dir"
    return 1
fi

builtin cd -- "$project_dir"
```

Zsh memuat isi file tersebut sebagai implementasi fungsi ketika `croot` dipanggil.

## 3. Buat entry point plugin

Isi `project-tools/project-tools.plugin.zsh` dengan:

```
# Menambahkan direktori fungsi plugin ke jalur autoload.
fpath=( "${0:A:h}/functions" $fpath )

# Mendaftarkan fungsi agar dimuat saat pertama kali dipanggil.
autoload -Uz croot
```

Arti ekspresi `${0:A:h}`:

- `$0` mengacu pada nama file atau konteks pemanggilan yang sedang digunakan.
- Modifier `:A` menghasilkan path absolut yang dinormalisasi.
- Modifier `:h` mengambil bagian direktori induk dari path tersebut.

Dalam entry point ini, ekspresi tersebut digunakan untuk menemukan direktori `functions` relatif terhadap file plugin, sehingga plugin tidak bergantung pada direktori kerja saat ini.

`autoload -Uz croot` mendaftarkan fungsi untuk pemuatan tertunda. Opsi `-U` mencegah ekspansi alias ketika fungsi dimuat, sedangkan `-z` menggunakan aturan ekspansi alias gaya Zsh untuk autoload.

## 4. Muat dan uji plugin

Dari direktori tempat folder `project-tools` berada, jalankan:

```
source ./project-tools/project-tools.plugin.zsh
```

Lalu uji:

```
whence -v croot
croot
pwd
```

`whence -v` membantu memeriksa bagaimana Zsh mengenali `croot`. Setelah memanggil `croot`, `pwd` seharusnya menunjukkan direktori `~/Projects`, jika direktori tersebut tersedia.

Untuk memeriksa sintaks file secara terpisah:

```
zsh -n project-tools/project-tools.plugin.zsh
zsh -n project-tools/functions/croot
```

Perlu diingat, pemeriksaan sintaks tidak memastikan bahwa semua path atau ketergantungan benar.

## 5. Integrasikan dengan konfigurasi modular

Jika ingin memuat plugin ini secara lokal, Anda dapat menambahkan pemanggilan `source` ke konfigurasi Zsh Anda. Untuk penggunaan permanen, simpan plugin di lokasi yang stabil dalam repositori dotfiles, lalu sesuaikan path pemuatannya.

Hindari memasukkan direktori plugin ke `$fpath` setelah fungsi autoload sudah dipanggil untuk pertama kali tanpa memahami cache fungsi yang telah dimuat. Untuk eksperimen, sesi Zsh baru adalah cara sederhana memastikan pengujian dimulai dari keadaan bersih.

## 6. Tantangan pengembangan

Sebelum menambahkan fitur lain, pastikan Anda memahami alur ini:

```
project-tools.plugin.zsh
        │
        ├── menambahkan functions/ ke $fpath
        │
        └── autoload -Uz croot
                     │
                     ▼
             fungsi croot dipanggil
                     │
                     ▼
              file functions/croot
                     │
                     ▼
             validasi direktori
                     │
                     ▼
               builtin cd
```

Latihan berikutnya: modifikasi `croot` agar dapat menerima nama proyek sebagai argumen, misalnya `croot dotfiles`, dan berpindah ke `~/Projects/dotfiles`. Pertimbangkan validasi jumlah argumen, direktori yang tidak ada, serta quoting path.

Pelajaran berikutnya adalah Pelajaran 24 — Membangun Personal Zsh Framework, yaitu menyusun kumpulan plugin, fungsi, completion, hooks, dan konfigurasi modular menjadi kerangka Zsh pribadi yang konsisten.

# Pelajaran 24 — Membangun Personal Zsh Framework

Tujuan pelajaran ini adalah menyatukan materi sebelumnya menjadi arsitektur konfigurasi Zsh pribadi yang mudah dipahami, diuji, dikembangkan, dan dipelihara.

Personal Zsh Framework bukan berarti harus membuat framework besar atau mengganti plugin manager. Pada tahap ini, yang terpenting adalah membangun struktur yang jelas dan memahami bagaimana setiap bagian berinteraksi.

## 1. Gambaran arsitektur

Roadmap dalam dokumen Beralih Ke Zsh mengarahkan konfigurasi ke struktur modular seperti berikut:

```
~/.config/zsh/
├── zshrc
├── aliases.zsh
├── functions.zsh
├── options.zsh
├── completion.zsh
├── keybinds.zsh
├── history.zsh
├── prompt.zsh
└── integrations/
    ├── git.zsh
    ├── fzf.zsh
    ├── zoxide.zsh
    └── yazi.zsh
```

Setiap file memiliki tanggung jawab berbeda.

| File                         | Tanggung jawab                                 |
| ---------------------------- | ---------------------------------------------- |
| `zshrc`                      | Titik masuk dan pengatur urutan pemuatan       |
| `options.zsh`                | Perilaku shell melalui `setopt` dan `unsetopt` |
| `environment.zsh` (opsional) | Variabel lingkungan dan `PATH`                 |
| `history.zsh`                | Penyimpanan dan perilaku history               |
| `aliases.zsh`                | Alias perintah                                 |
| `functions.zsh`              | Fungsi buatan sendiri                          |
| `completion.zsh`             | Inisialisasi dan konfigurasi completion        |
| `keybinds.zsh`               | Binding tombol dan keymap                      |
| `prompt.zsh`                 | Prompt, jika tidak dikelola Starship           |
| `integrations/`              | Konfigurasi program eksternal                  |

Nama file bukan aturan wajib Zsh. Anda bebas menentukan nama dan pembagiannya; Zsh hanya perlu diberi instruksi untuk memuat file tersebut.

## 2. Peran file utama `zshrc`

Karena `~/.zshrc` Anda sudah mengarah ke `~/.config/zsh/zshrc`, file `zshrc` tersebut dapat berfungsi sebagai pengatur konfigurasi modular.

Contoh sederhana:

```
# Menentukan direktori konfigurasi.
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Memuat konfigurasi berdasarkan urutan yang ditentukan.
source "$ZSH_CONFIG_DIR/options.zsh"
source "$ZSH_CONFIG_DIR/history.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/functions.zsh"
source "$ZSH_CONFIG_DIR/keybinds.zsh"
source "$ZSH_CONFIG_DIR/completion.zsh"
```

Ini contoh arsitektur, bukan instruksi untuk langsung mengganti `zshrc` Anda. Nama file harus disesuaikan dengan struktur yang benar-benar ada.

### Mengapa urutan pemuatan penting?

`source` menjalankan isi file di dalam proses shell saat ini. Karena itu, suatu file dapat bergantung pada variabel, fungsi, atau fitur yang sudah dimuat sebelumnya.

Contohnya, jika sebuah integrasi menggunakan fungsi `mkcd`, fungsi itu harus sudah tersedia ketika integrasi tersebut membutuhkannya.

Prinsipnya:

- Muat konfigurasi dasar sebelum konfigurasi yang bergantung padanya.
- Inisialisasi completion hanya sekali jika plugin manager sudah mengelolanya.
- Hindari memuat integrasi yang sama melalui dua jalur berbeda.
- Jangan mengandalkan urutan wildcard seperti `source "$ZSH_CONFIG_DIR"/*.zsh` ketika urutan pemuatan penting.

## 3. Pisahkan konfigurasi inti dan integrasi eksternal

Ada perbedaan penting antara fitur yang Anda buat sendiri dan fitur yang disediakan program eksternal.

Misalnya:

```
Zsh configuration
│
├── Core
│   ├── options
│   ├── history
│   ├── aliases
│   ├── functions
│   └── keybindings
│
└── Integrations
    ├── Git
    ├── fzf
    ├── zoxide
    └── yazi
```

Konfigurasi inti sebaiknya tetap berfungsi meskipun salah satu program eksternal tidak terpasang. Integrasi dapat memeriksa ketersediaan program sebelum menjalankan inisialisasinya.

Contoh pola pemeriksaan:

```
if (( $+commands[fzf] )); then
    # Inisialisasi integrasi fzf di sini.
fi
```

Penjelasannya:

- `$commands` adalah associative array khusus Zsh yang memetakan nama perintah yang tersedia ke lokasinya.
- `$+commands[fzf]` memeriksa apakah elemen `fzf` tersedia.
- `(( ... ))` mengevaluasi ekspresi aritmetika; dalam konteks ini, nilai nonnol berarti kondisi terpenuhi.

Pola ini membantu konfigurasi tetap dapat digunakan pada mesin yang tidak memiliki seluruh dependensi.

## 4. Bedakan `source`, `autoload`, dan plugin manager

Ketiganya tidak memiliki fungsi yang sama.

| Mekanisme                  | Peran                                                                                   |
| -------------------------- | --------------------------------------------------------------------------------------- |
| `source file.zsh`          | Langsung menjalankan isi file                                                           |
| `autoload -Uz nama_fungsi` | Mendaftarkan fungsi untuk dimuat saat dipanggil, melalui `$fpath`                       |
| Plugin manager             | Mengelola pengambilan, pembaruan, dan pemuatan plugin sesuai kemampuan manager tersebut |

Misalnya, fungsi yang jarang digunakan dapat diletakkan dalam direktori `functions/` dan dimuat melalui `autoload`. Fungsi itu tidak harus didefinisikan langsung di `zshrc`.

Sebaliknya, konfigurasi yang perlu segera mengatur opsi shell biasanya dimuat dengan `source`.

Prinsip desainnya adalah memilih mekanisme berdasarkan kebutuhan, bukan menggunakan satu mekanisme untuk semuanya.

## 5. Tambahkan fitur tanpa membuat konfigurasi sulit dirawat

Framework pribadi pada akhirnya dapat memiliki:

- Fungsi untuk pekerjaan sehari-hari.
- Custom completion untuk perintah buatan sendiri.
- Custom ZLE widgets untuk memodifikasi command line.
- Hooks untuk menjalankan fungsi pada peristiwa tertentu.
- Integrasi Git, fzf, zoxide, dan yazi.
- Prompt khusus atau integrasi Starship.

Namun, jangan langsung membuat semua fitur itu dalam satu file besar. Setiap fitur baru sebaiknya memiliki tanggung jawab yang jelas, dapat diuji secara terpisah, dan tidak mengubah perilaku yang tidak berkaitan.

## 6. Cara menguji perubahan konfigurasi

Sebelum memuat konfigurasi yang baru, lakukan pemeriksaan sintaks pada file yang diubah:

```
zsh -n "$HOME/.config/zsh/zshrc"
```

`-n` meminta Zsh memeriksa sintaks tanpa menjalankan isi skrip. Pemeriksaan ini tidak menjamin bahwa semua perintah, dependensi, atau logika konfigurasi akan berjalan dengan benar.

Untuk menguji startup interaktif tanpa menutup sesi Zsh yang sedang digunakan:

```
zsh -lic exit
```

Perintah tersebut menjalankan shell login interaktif dan kemudian keluar. Perlu diingat, kode startup tetap dieksekusi sehingga dapat memicu efek samping dari konfigurasi Anda.

Setelah mengubah file dalam repository dotfiles, periksa perubahannya:

```
git -C "$HOME/dotfiles" diff --check
git -C "$HOME/dotfiles" diff
```

Perintah pertama memeriksa masalah whitespace yang umum dalam diff; perintah kedua menampilkan perubahan untuk ditinjau.

## 7. Latihan mandiri

Kerjakan bertahap. Tidak perlu membuat framework baru dari nol jika konfigurasi modular Anda sudah ada.

Checklist latihan

0 dari 5

Petakan konfigurasi yang ada

Catat file utama, file modular, integrasi eksternal, dan urutan pemuatannya.

Identifikasi dependensi

Tentukan file mana yang bergantung pada fungsi, variabel, atau fitur dari file lain.

Periksa inisialisasi ganda

Cari pemanggilan compinit, pemuatan plugin, dan binding yang mungkin didaftarkan lebih dari sekali.

Uji satu perubahan kecil

Ubah satu bagian, jalankan pemeriksaan sintaks, lalu uji pada sesi Zsh baru.

Dokumentasikan arsitektur

Tulis alasan setiap file dipisahkan dan mengapa urutan pemuatannya seperti itu.

Kesimpulan: personal framework yang baik bukan yang memiliki paling banyak plugin, melainkan yang mekanismenya dapat Anda jelaskan dan modifikasinya dapat Anda uji.

Tahap berikutnya dalam roadmap adalah mendalami custom ZLE widgets. Di sana Anda akan mulai memprogram editor command line Zsh sendiri menggunakan `BUFFER`, `CURSOR`, `zle -N`, dan `bindkey`—landasan untuk membuat fitur interaktif yang lebih kompleks.

> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
<!-- > - **[Selanjutnya][selanjutnya]** -->
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-15/README.md
<!-- [selanjutnya]: ../bagian-17/README.md -->

<!-- [selanjutnya]: ../bagian-3/README.md -->

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

