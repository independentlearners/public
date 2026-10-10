# Lesson 08 — Functions & Autoload

Fokus lesson ini adalah memahami bagaimana fungsi Zsh didefinisikan, menerima argumen, mengelola variabel, mengembalikan status, dan dimuat dari file terpisah. Ini merupakan fondasi untuk membaca konfigurasi modular dan kode plugin Zsh.

## 08.1 — Anatomi fungsi Zsh

Fungsi mengelompokkan serangkaian perintah di bawah satu nama agar dapat dipanggil kembali.

```
greet() {
    print -r -- "Halo dari Zsh"
}

greet
```

Strukturnya:

- `greet` adalah nama fungsi.
- `()` menandai deklarasi fungsi.
- `{ ... }` berisi perintah yang dijalankan saat fungsi dipanggil.
- `greet` pada baris terakhir memanggil fungsi tersebut.

Definisi fungsi tidak langsung menjalankan isi fungsi. Ketika shell membaca definisi itu, ia mengenali dan menyimpan fungsi. Isi fungsi baru dijalankan saat fungsi dipanggil.

Fungsi juga bisa ditulis dengan sintaks `function greet { ... }`, tetapi bentuk `greet() { ... }` sudah cukup untuk sebagian besar contoh yang akan kita gunakan.

## 08.2 — Argumen fungsi

Saat fungsi dipanggil, argumen tersedia melalui parameter posisi, seperti pada scripting shell lainnya.

```
show_args() {
    print -r -- "Argumen pertama: $1"
    print -r -- "Argumen kedua: $2"
    print -r -- "Jumlah argumen: $#"
}

show_args git status
```

Hasil:

```
Argumen pertama: git
Argumen kedua: status
Jumlah argumen: 2
```

Makna parameter yang digunakan:

| Parameter | Makna                                                                 |
| --------- | --------------------------------------------------------------------- |
| `$1`      | Argumen pertama                                                       |
| `$2`      | Argumen kedua                                                         |
| `$#`      | Jumlah argumen                                                        |
| `$@`      | Seluruh argumen                                                       |
| `$*`      | Seluruh argumen dengan perilaku penggabungan yang berbeda dari `"$@"` |

Untuk meneruskan seluruh argumen sebagai argumen terpisah, gunakan `"$@"`:

```
run_command() {
    command "$@"
}
```

Misalnya:

```
run_command ls -l /tmp
```

Fungsi meneruskan `ls`, `-l`, dan `/tmp` sebagai tiga argumen terpisah. Ini lebih aman daripada menyusun perintah menjadi satu string lalu menjalankannya dengan `eval`.

## 08.3 — Variabel lokal dan global

Variabel yang dibuat di dalam fungsi tidak otomatis menjadi lokal. Jika Anda ingin variabel hanya digunakan oleh fungsi tersebut, deklarasikan dengan `local`.

```
message="Variabel global"

show_message() {
    local message="Variabel lokal"
    print -r -- "$message"
}

show_message
print -r -- "$message"
```

Hasil:

```
Variabel lokal
Variabel global
```

Ketika fungsi dipanggil, `local message` membuat parameter lokal yang menutupi parameter global bernama sama selama cakupan lokal tersebut berlaku.

Tanpa `local`, assignment di dalam fungsi dapat mengubah variabel yang sudah ada di cakupan luar atau membuat parameter yang tetap tersedia setelah fungsi selesai.

Untuk konfigurasi Zsh, gunakan variabel lokal bagi nilai sementara yang hanya diperlukan oleh satu fungsi. Ini mengurangi benturan nama antara fungsi-fungsi berbeda.

## 08.4 — Status keluar dan `return`

Fungsi dapat memberikan status keluar kepada pemanggil menggunakan `return`.

```
check_directory() {
    if [[ -d "$1" ]]; then
        return 0
    else
        return 1
    fi
}

if check_directory /tmp; then
    print -r -- "Direktori tersedia"
else
    print -r -- "Direktori tidak ditemukan"
fi
```

Di sini:

- `[[ -d "$1" ]]` memeriksa apakah argumen pertama menunjuk ke direktori yang ada.
- `return 0` menandakan keberhasilan.
- `return 1` menandakan kegagalan.
- `if check_directory /tmp` menguji status keluar fungsi.

Dalam shell, status `0` umumnya berarti berhasil, sedangkan status bukan nol menandakan kegagalan atau kondisi lain.

Perbedaan penting: `return` mengakhiri fungsi dan menetapkan status keluarnya. `exit` mengakhiri proses shell, sehingga jangan mengganti `return` dengan `exit` di fungsi biasa tanpa alasan yang tepat.

## 08.5 — Memuat fungsi dari file dengan `autoload`

Sekarang kita menghubungkan fungsi dengan arsitektur konfigurasi modular.

Tanpa autoload, Anda dapat memuat file fungsi secara langsung dengan `source`. Namun, `source` membaca dan menjalankan isi file saat dipanggil, sedangkan `autoload` menandai nama fungsi agar definisinya dapat dimuat ketika fungsi itu dipanggil.

Contoh struktur:

```
~/.config/zsh/
├── .zshrc
└── functions/
    └── mkcd
```

Isi file `~/.config/zsh/functions/mkcd`:

```
mkdir -- "$1" && cd -- "$1"
```

Ini adalah isi fungsi dalam format native Zsh untuk autoload, bukan deklarasi pembungkus `mkcd() { ... }`.

Dalam sesi Zsh, jalankan:

```
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz mkcd
```

Sekarang Anda dapat memanggil:

```
mkcd proyek-baru
```

Jika operasi berhasil, fungsi membuat direktori `proyek-baru` lalu berpindah ke direktori tersebut.

`fpath` menentukan direktori pencarian file fungsi. `autoload -Uz mkcd` menandai `mkcd` sebagai fungsi autoload dengan opsi yang telah dibahas pada Lesson 07.

Catatan: contoh ini benar-benar membuat direktori baru dan mengubah direktori kerja shell. Uji di direktori yang sesuai.

## 08.6 — Kapan memakai `source` dan kapan memakai `autoload`?

| Aspek           | `source`                                                  | `autoload`                                                      |
| --------------- | --------------------------------------------------------- | --------------------------------------------------------------- |
| Mekanisme       | Membaca dan menjalankan file sekarang                     | Menandai fungsi untuk dimuat saat dipanggil                     |
| Penggunaan umum | Memuat opsi, alias, dan konfigurasi                       | Memisahkan fungsi-fungsi yang dapat dipanggil sesuai kebutuhan  |
| Struktur file   | Biasanya berisi perintah konfigurasi atau definisi fungsi | Umumnya satu file per fungsi dengan format autoload yang sesuai |
| Waktu eksekusi  | Saat file di-source                                       | Saat fungsi autoload pertama kali dipanggil                     |

Untuk `.zshrc` modular, `source` cocok untuk memuat konfigurasi yang memang harus diterapkan saat startup. Autoload berguna ketika Anda memiliki banyak fungsi dan tidak ingin mendefinisikan semuanya secara langsung saat shell dimulai.


<details>
  <summary>📃 Latihan Lesson 08</summary>

---

## Jawab pertanyaan berikut sebelum melanjutkan:

1. Apa perbedaan `$1` dan `$#` di dalam fungsi?
2. Mengapa `local` berguna dalam konfigurasi Zsh?
3. Apa perbedaan `return 1` dan `exit 1`?
4. Mengapa `autoload` dapat membantu mengorganisasi konfigurasi yang berisi banyak fungsi?
5. Dalam contoh `mkcd`, apa fungsi `fpath`, dan kapan isi file `mkcd` dimuat?

</details>

---

Setelah bagian ini, kita akan melanjutkan pendalaman fungsi—termasuk meneruskan argumen, menangani status, dan praktik yang tepat saat mengembangkan fungsi Zsh—sebelum berpindah ke arsitektur startup dan konfigurasi modular sesuai urutan kurikulum.

## Functions & Autoload (lanjutan)

Fokus bagian ini adalah memahami bagaimana fungsi Zsh menerima argumen, menjaga lingkungan eksekusinya, menangani status kegagalan, dan dimuat secara modular. Ini penting ketika nanti membaca fungsi dalam konfigurasi maupun plugin Zsh.

### 08.7 Meneruskan argumen dengan benar

Dalam fungsi Zsh, `"$@"` dan `"$*"` tidak setara ketika diberi tanda kutip.

```
show_args() {
    print -r -- "Jumlah argumen: $#"

    for arg in "$@"; do
        print -r -- "Argumen: $arg"
    done
}

show_args git status "file dengan spasi.txt"
```

Hasilnya berupa tiga argumen terpisah:

```
Jumlah argumen: 3
Argumen: git
Argumen: status
Argumen: file dengan spasi.txt
```

Perbedaannya:

- `"$@"` mempertahankan setiap argumen sebagai elemen terpisah.
- `"$*"` menggabungkan semua argumen menjadi satu string ketika dikutip.
- Tanpa tanda kutip, keduanya dapat mengalami ekspansi dan pemisahan yang tidak diinginkan.

Untuk fungsi yang meneruskan argumen ke program lain, gunakan pola berikut:

```
run_command() {
    command "$@"
}

run_command ls -l "/tmp"
```

`"$@"` memastikan setiap argumen diteruskan secara terpisah. Karena itu, spasi di dalam nama berkas atau direktori tidak otomatis memecah satu argumen menjadi beberapa bagian.

### 08.8 Memisahkan keluaran dan status fungsi

Fungsi dapat menghasilkan teks sekaligus mengembalikan status keluar. Keduanya memiliki tujuan berbeda.

```
get_shell_name() {
    print -r -- "$SHELL"
    return 0
}

shell_path=$(get_shell_name)
status=$?

print -r -- "Path: $shell_path"
print -r -- "Status: $status"
```

Penjelasannya:

- `print` mengirim teks ke standard output.
- `$(...)` menangkap keluaran standard output sebagai nilai parameter.
- `return 0` menyatakan fungsi selesai dengan status sukses.
- `$?` menyimpan status perintah yang baru selesai dijalankan.

Jika fungsi dipanggil langsung dalam kondisi `if`, statusnya dapat digunakan tanpa mengambil `$?` secara manual:

```
if get_shell_name >/dev/null; then
    print -r -- "Fungsi berhasil"
else
    print -r -- "Fungsi gagal"
fi
```

Prinsip penting: gunakan keluaran untuk memberikan data, sedangkan status keluar untuk menyatakan keberhasilan atau kegagalan. Jangan mengandalkan teks seperti `"berhasil"` sebagai pengganti status keluar.

### 08.9 Menjaga opsi fungsi dengan `emulate -L zsh`

Konfigurasi Zsh dapat mengubah perilaku shell melalui `setopt` dan `unsetopt`. Jika fungsi mengubah opsi tanpa membatasi cakupannya, perubahan tersebut dapat memengaruhi perintah setelah fungsi selesai.

Contoh:

```
temporary_option() {
    setopt EXTENDED_GLOB
}
```

Fungsi tersebut mengaktifkan `EXTENDED_GLOB`, tetapi tidak secara eksplisit mengembalikan keadaan opsi sebelumnya.

Untuk fungsi yang memang dirancang menggunakan sintaks dan perilaku native Zsh, gunakan:

```
my_function() {
    emulate -L zsh

    setopt EXTENDED_GLOB

    # Operasi fungsi
}
```

Arti `emulate -L zsh`:

- `emulate zsh` mengatur perilaku shell agar menggunakan emulasi Zsh.
- `-L` membuat perubahan opsi yang relevan bersifat lokal terhadap cakupan fungsi, lalu memulihkan keadaan sebelumnya ketika fungsi selesai.
- Dengan demikian, pengaturan opsi internal fungsi tidak sengaja menjadi perubahan permanen bagi shell pemanggil.

Ini berguna ketika membuat fungsi mandiri yang harus berperilaku konsisten meskipun pengguna memiliki konfigurasi Zsh yang berbeda.

Catatan: `emulate -L zsh` tidak mengisolasi seluruh efek samping fungsi. Perubahan berkas, variabel yang sengaja dimodifikasi, dan perintah eksternal tetap dapat memengaruhi lingkungan di luar fungsi.

### 08.10 Membuat fungsi `mkcd` yang lebih aman

Sebelumnya, kita membuat fungsi sederhana untuk membuat direktori dan langsung masuk ke dalamnya. Sekarang kita perbaiki dengan validasi argumen dan penanganan kegagalan.

```
mkcd() {
    emulate -L zsh

    if (( $# != 1 )); then
        print -u2 -r -- "Penggunaan: mkcd DIRECTORY"
        return 2
    fi

    command mkdir -p -- "$1" || return
    builtin cd -- "$1"
}
```

Contoh pemakaian:

```
mkcd proyek-baru
```

Mekanismenya:

1. `emulate -L zsh` menjaga perilaku opsi fungsi tetap terlokalisasi.
2. `(( $# != 1 ))` memeriksa apakah jumlah argumen bukan satu.
3. `print -u2` mengirim pesan kesalahan ke standard error, bukan standard output.
4. `return 2` menandai pemanggilan yang tidak valid.
5. `command mkdir -p -- "$1"` menjalankan program `mkdir` dan meneruskan nama direktori sebagai satu argumen.
6. `|| return` menghentikan fungsi jika `mkdir` gagal, dengan meneruskan status kegagalannya.
7. `builtin cd -- "$1"` menggunakan builtin `cd` milik Zsh setelah direktori berhasil dibuat.

Pemisahan `command` dan `builtin` berguna karena keduanya memperjelas jenis perintah yang ingin dijalankan. `command` meminta shell menjalankan perintah tanpa menggunakan fungsi bernama sama, sedangkan `builtin` secara eksplisit memilih builtin shell.

### 08.11 Memindahkan fungsi ke berkas autoload

Setelah fungsi bekerja, kita dapat memisahkannya dari berkas konfigurasi utama.

Struktur:

```
~/.config/zsh/
├── zshrc
└── functions/
    └── mkcd
```

Isi berkas `~/.config/zsh/functions/mkcd`:

```
emulate -L zsh

if (( $# != 1 )); then
    print -u2 -r -- "Penggunaan: mkcd DIRECTORY"
    return 2
fi

command mkdir -p -- "$1" || return
builtin cd -- "$1"
```

Untuk format autoload native Zsh ini, berkas berisi badan fungsi, bukan deklarasi `mkcd() { ... }` yang membungkusnya.

Daftarkan direktori fungsi dan tandai fungsi untuk autoload:

```
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz mkcd
```

`fpath` menentukan direktori tempat Zsh mencari berkas fungsi autoload. Opsi `-U` mencegah ekspansi alias ketika berkas fungsi dimuat, sedangkan `-z` memilih gaya autoload Zsh.

Ketika `mkcd` dipanggil, Zsh mencari dan memuat definisinya jika belum dimuat. Setelah itu, fungsi dapat dipanggil seperti fungsi biasa.

Untuk konfigurasi permanen, masukkan pengaturan `fpath` dan `autoload` tersebut ke berkas konfigurasi yang dimuat saat startup, misalnya `~/.config/zsh/zshrc` jika itulah berkas konfigurasi utama Anda.

Perbedaan konsepnya:

| Mekanisme           | Fungsi                                                            |
| ------------------- | ----------------------------------------------------------------- |
| `source file`       | Membaca dan menjalankan isi berkas saat itu juga.                 |
| `autoload -Uz nama` | Menandai fungsi agar berkas definisinya dimuat ketika diperlukan. |
| `fpath`             | Menentukan lokasi pencarian berkas fungsi autoload.               |

Autoload membantu menghindari pemuatan seluruh implementasi fungsi pada startup. Namun, fungsi yang telah dipanggil dan dimuat biasanya tetap tersedia dalam sesi shell tersebut.

<details>
  <summary>📃 Ringkasan Pelajaran 08</summary>

---

#### Anda sekarang telah mempelajari empat prinsip penting untuk membangun fungsi Zsh yang dapat digunakan kembali:

- Argumen: gunakan `"$@"` untuk meneruskan argumen tanpa menggabungkan atau memecahnya secara tidak sengaja.
- Status: pisahkan data yang dikeluarkan fungsi dari status keberhasilannya.
- Isolasi opsi: gunakan `emulate -L zsh` ketika fungsi perlu mengendalikan perilaku opsi secara lokal.
- Modularitas: gunakan `fpath` dan `autoload -Uz` untuk memisahkan implementasi fungsi dari konfigurasi utama.

</details>

---

Tahap berikutnya dalam kurikulum adalah Pelajaran 09 — Startup Architecture: memahami urutan pemuatan `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`, dan `.zlogout`, serta menentukan tempat yang tepat untuk variabel lingkungan, konfigurasi interaktif, dan pemuatan fungsi.
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

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

