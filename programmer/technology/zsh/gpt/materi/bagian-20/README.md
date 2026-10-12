# Pelajaran 19 — Integrasi Terminal dengan Zsh

Dalam pelajaran ini, kita mempelajari hubungan antara Zsh, terminal emulator, dan program eksternal. Fokusnya adalah memahami batas tanggung jawab masing-masing komponen dan bagaimana konfigurasi Zsh dapat memanfaatkan kemampuan terminal.

## 1. Memahami tiga komponen utama

### Stack shell

```
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

```
print -r -- "Halo dari Zsh"
```

Untuk mengubah judul terminal, banyak terminal emulator mendukung urutan kontrol berbasis OSC (Operating System Command). Salah satu bentuk yang umum didukung adalah OSC 0:

```
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

```
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

```
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

```
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

