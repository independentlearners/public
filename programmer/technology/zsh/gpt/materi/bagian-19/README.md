# Pelajaran 18 — Arsitektur Plugin Zsh

Fokus pelajaran ini adalah memahami bagaimana plugin Zsh bekerja, bagaimana plugin dimuat, dan bagaimana membaca struktur kode plugin sebelum memodifikasinya.

Targetnya bukan langsung memasang plugin baru. Targetnya adalah memahami mekanisme yang membuat plugin bisa menambahkan fungsi, alias, completion, keybindings, atau perilaku shell lainnya.

## 1. Apa sebenarnya plugin Zsh?

Plugin Zsh pada dasarnya adalah kumpulan kode dan konfigurasi yang menambahkan kemampuan pada shell. Plugin tidak harus menggunakan format atau sistem khusus.

Sebuah plugin sederhana dapat berupa satu file:

```bash
my-plugin/
└── my-plugin.zsh
```

Isinya bisa sesederhana:

```bash
# my-plugin.zsh

hello-zsh() {
    print -r -- "Fitur dari plugin aktif"
}
```

Ketika file tersebut dimuat:

```bash
source ./my-plugin.zsh
```

fungsi `hello-zsh` tersedia di shell saat ini dan dapat dipanggil:

```bash
hello-zsh
```

Output:

```bash
Fitur dari plugin aktif
```

Jadi, plugin tidak otomatis merupakan program terpisah, executable, atau modul biner. Plugin dapat berupa kode Zsh biasa yang dimuat ke lingkungan shell.

## 2. Komponen yang dapat disediakan plugin

Fungsi dan alias

Menyediakan perintah baru atau jalan pintas untuk menjalankan perintah yang sudah ada.

```bash
alias gs='git status'
```

Keybindings dan widget ZLE

Mengubah cara baris perintah diedit melalui keyboard.

```bash
bindkey -v
```

Contoh mekanisme Zsh yang dapat digunakan plugin; bukan plugin lengkap.

Completion

Menambahkan saran atau penyelesaian argumen untuk perintah tertentu.

```bash
compdef _git mygit
```

Contoh deklarasi completion yang mengasumsikan sistem completion dan fungsi `_git` tersedia.

Hooks

Menjalankan fungsi pada peristiwa tertentu, seperti sebelum prompt ditampilkan atau setelah direktori berubah.

```bash
add-zsh-hook chpwd my_directory_hook
```

Contoh ini mengasumsikan `add-zsh-hook` sudah dimuat.

Satu plugin dapat menggabungkan beberapa komponen tersebut sekaligus.

## 3. `source` dibandingkan dengan `autoload`

Keduanya berkaitan dengan pemuatan kode, tetapi memiliki tujuan berbeda.

### A. `source`: langsung menjalankan file

```bash
source "$HOME/.config/zsh/integrations/git.zsh"
```

Ketika perintah ini dijalankan, Zsh membaca dan mengeksekusi isi file tersebut pada saat itu juga.

Mekanisme ini cocok untuk konfigurasi yang memang perlu segera diterapkan, misalnya:

- Menetapkan opsi.
- Membuat alias.
- Menginisialisasi plugin.
- Mendaftarkan hook.
- Mengatur keybindings.

### B. `autoload`: mendaftarkan fungsi untuk dimuat ketika diperlukan

Misalnya struktur file berikut:

```bash
~/.config/zsh/functions/
└── mkcd
```

Isi file `mkcd`, tanpa pembungkus definisi fungsi:

```bash
# ~/.config/zsh/functions/mkcd

if (( $# != 1 )); then
    print -u2 -- "Penggunaan: mkcd DIREKTORI"
    return 2
fi

mkdir -p -- "$1" && cd -- "$1"
```

Kemudian, di konfigurasi:

```bash
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz mkcd
```

Pada pola autoload fungsi standar ini, Zsh mengetahui lokasi fungsi `mkcd`, tetapi isi file fungsi tidak perlu dimuat pada saat deklarasi `autoload`. Ketika `mkcd` pertama kali dipanggil, Zsh memuat definisinya dari file tersebut.

Contoh pemanggilan:

```bash
mkcd /tmp/zsh-lab
```

Ada dua hal yang perlu dibedakan:

- `fpath` menentukan direktori tempat Zsh mencari file fungsi.
- `autoload -Uz mkcd` menandai `mkcd` sebagai fungsi yang akan dimuat secara otomatis ketika dibutuhkan.

`-U` menonaktifkan ekspansi alias ketika definisi fungsi dimuat. `-z` memilih aturan ekspansi alias Zsh untuk proses autoload.

## 4. Bagaimana plugin manager bekerja?

Plugin manager seperti Zinit, Antidote, atau Oh My Zsh membantu mengelola plugin. Namun, plugin manager bukan mekanisme dasar yang wajib ada agar plugin dapat bekerja.

Secara konseptual, alurnya seperti ini:

Konfigurasi utama (`zshrc`)

Plugin manager atau pemuat manual

Kode plugin dimuat

Fungsi, hooks, completion, atau widget tersedia

Secara umum, plugin manager dapat menangani pekerjaan seperti:

- Mengunduh dan memperbarui plugin.
- Menentukan kapan dan dalam urutan apa plugin dimuat.
- Mengelola lokasi kode plugin.
- Menyediakan mekanisme untuk memuat plugin secara langsung atau tertunda, sesuai kemampuan manager.

Detailnya berbeda antar-plugin manager. Tidak semua manager mendukung semua fitur tersebut dengan cara yang sama.

### Mengapa urutan plugin penting?

Misalnya, plugin B menggunakan fungsi yang disediakan plugin A.

```bash
plugin A
└── menyediakan fungsi helper

plugin B
└── menggunakan fungsi helper dari plugin A
```

Jika plugin B dijalankan sebelum fungsi helper tersedia, inisialisasinya dapat gagal.

Ketergantungan serupa juga dapat terjadi pada completion, widget ZLE, dan konfigurasi prompt.

Karena itu, ketika membaca konfigurasi plugin, cari tahu:

1. Apa yang disediakan plugin?
2. Apa dependensinya?
3. Bagaimana plugin dimuat?
4. Kapan fungsi atau fiturnya mulai digunakan?

## 5. Cara membaca source code plugin

Ketika membuka repositori plugin, jangan langsung membaca semua file dari atas sampai bawah. Mulailah dari struktur dan titik masuknya.

Misalnya:

```bash
example-plugin/
├── example-plugin.plugin.zsh
├── functions/
│   └── _example
├── completions/
│   └── _example-command
├── README.md
└── LICENSE
```

Nama file di atas hanya ilustrasi, bukan struktur wajib setiap plugin.

| Bagian            | Hal yang perlu diperiksa                                               |
| ----------------- | ---------------------------------------------------------------------- |
| README            | Tujuan, instalasi, konfigurasi, dan dependensi.                        |
| File utama plugin | Inisialisasi, definisi fungsi, hooks, alias, atau keybindings.         |
| `functions/`      | Fungsi yang mungkin dipanggil langsung atau dimuat melalui `autoload`. |
| `completions/`    | Fungsi completion dan bagaimana fungsi tersebut didaftarkan.           |
| Konfigurasi       | Variabel atau opsi yang dapat diubah pengguna.                         |

Saat membaca kode, cari mekanisme Zsh yang sudah dipelajari:

```bash
source
autoload
fpath
compinit
compdef
bindkey
zle
add-zsh-hook
setopt
```

Kemudian ikuti alurnya. Misalnya, jika sebuah plugin memanggil `add-zsh-hook`, cari fungsi yang didaftarkan dan pahami kapan hook tersebut berjalan.

## 6. Praktik: membuat plugin mini

Buat struktur berikut di direktori latihan, bukan langsung di konfigurasi utama:

```bash
zsh-plugin-lab/
├── plugin.zsh
└── functions/
    └── greet
```

Isi `plugin.zsh`:

```bash
fpath=("$HOME/zsh-plugin-lab/functions" $fpath)
autoload -Uz greet
```

Isi `functions/greet`:

```bash
print -r -- "Halo dari fungsi autoload Zsh"
```

Untuk mencoba di shell interaktif:

```bash
source "$HOME/zsh-plugin-lab/plugin.zsh"
whence -v greet
greet
```

Sesuaikan lokasi file jika direktori latihan Anda berbeda.

Perhatikan urutannya: file utama menambahkan direktori ke `fpath`, lalu mendaftarkan fungsi melalui `autoload`. Ketika `greet` dipanggil, Zsh memuat isi file `functions/greet`.

Latihan ini menunjukkan perbedaan antara file inisialisasi plugin dan file fungsi yang dimuat ketika dibutuhkan.

## 7. Pemeriksaan pemahaman

1\. Apakah plugin Zsh wajib menggunakan plugin manager?

Ya, selalu

Tidak, kode plugin dapat dimuat langsung dengan source atau menggunakan mekanisme autoload

Ya, kecuali plugin hanya berisi alias

2\. Apa fungsi fpath dalam contoh autoload?

Menentukan lokasi pencarian file fungsi

Menjalankan semua file dalam direktori

Mengaktifkan sistem completion secara otomatis

3\. Plugin B bergantung pada fungsi dari plugin A. Apa yang harus diperiksa?

Hanya nama file plugin B

Urutan pemuatan dan ketersediaan fungsi dari plugin A

Warna prompt

Ulangi latihan

Target pelajaran: Anda dapat membedakan `source` dan `autoload`, menjelaskan fungsi plugin manager, serta mengidentifikasi titik masuk dan dependensi plugin.

Pelajaran selanjutnya: Pelajaran 19 — Integrasi Terminal, untuk memahami bagaimana Zsh berinteraksi dengan terminal emulator dan bagaimana konfigurasi shell berhubungan dengan fitur seperti direktori kerja, judul terminal, serta integrasi program eksternal.

> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-18/README.md
[selanjutnya]: ../bagian-20/README.md

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

