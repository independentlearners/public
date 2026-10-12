# Lesson 08 — Functions & Autoload

Fokus lesson ini adalah memahami bagaimana fungsi Zsh didefinisikan, menerima argumen, mengelola variabel, mengembalikan status, dan dimuat dari file terpisah. Ini merupakan fondasi untuk membaca konfigurasi modular dan kode plugin Zsh.

## 08.1 — Anatomi fungsi Zsh

Fungsi mengelompokkan serangkaian perintah di bawah satu nama agar dapat dipanggil kembali.

```bash
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

```bash
show_args() {
    print -r -- "Argumen pertama: $1"
    print -r -- "Argumen kedua: $2"
    print -r -- "Jumlah argumen: $#"
}

show_args git status
```

Hasil:

```bash
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

```bash
run_command() {
    command "$@"
}
```

Misalnya:

```bash
run_command ls -l /tmp
```

Fungsi meneruskan `ls`, `-l`, dan `/tmp` sebagai tiga argumen terpisah. Ini lebih aman daripada menyusun perintah menjadi satu string lalu menjalankannya dengan `eval`.

## 08.3 — Variabel lokal dan global

Variabel yang dibuat di dalam fungsi tidak otomatis menjadi lokal. Jika Anda ingin variabel hanya digunakan oleh fungsi tersebut, deklarasikan dengan `local`.

```bash
message="Variabel global"

show_message() {
    local message="Variabel lokal"
    print -r -- "$message"
}

show_message
print -r -- "$message"
```

Hasil:

```bash
Variabel lokal
Variabel global
```

Ketika fungsi dipanggil, `local message` membuat parameter lokal yang menutupi parameter global bernama sama selama cakupan lokal tersebut berlaku.

Tanpa `local`, assignment di dalam fungsi dapat mengubah variabel yang sudah ada di cakupan luar atau membuat parameter yang tetap tersedia setelah fungsi selesai.

Untuk konfigurasi Zsh, gunakan variabel lokal bagi nilai sementara yang hanya diperlukan oleh satu fungsi. Ini mengurangi benturan nama antara fungsi-fungsi berbeda.

## 08.4 — Status keluar dan `return`

Fungsi dapat memberikan status keluar kepada pemanggil menggunakan `return`.

```bash
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

```bash
~/.config/zsh/
├── .zshrc
└── functions/
    └── mkcd
```

Isi file `~/.config/zsh/functions/mkcd`:

```bash
mkdir -- "$1" && cd -- "$1"
```

Ini adalah isi fungsi dalam format native Zsh untuk autoload, bukan deklarasi pembungkus `mkcd() { ... }`.

Dalam sesi Zsh, jalankan:

```bash
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz mkcd
```

Sekarang Anda dapat memanggil:

```bash
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

```bash
show_args() {
    print -r -- "Jumlah argumen: $#"

    for arg in "$@"; do
        print -r -- "Argumen: $arg"
    done
}

show_args git status "file dengan spasi.txt"
```

Hasilnya berupa tiga argumen terpisah:

```bash
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

```bash
run_command() {
    command "$@"
}

run_command ls -l "/tmp"
```

`"$@"` memastikan setiap argumen diteruskan secara terpisah. Karena itu, spasi di dalam nama berkas atau direktori tidak otomatis memecah satu argumen menjadi beberapa bagian.

### 08.8 Memisahkan keluaran dan status fungsi

Fungsi dapat menghasilkan teks sekaligus mengembalikan status keluar. Keduanya memiliki tujuan berbeda.

```bash
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

```bash
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

```bash
temporary_option() {
    setopt EXTENDED_GLOB
}
```

Fungsi tersebut mengaktifkan `EXTENDED_GLOB`, tetapi tidak secara eksplisit mengembalikan keadaan opsi sebelumnya.

Untuk fungsi yang memang dirancang menggunakan sintaks dan perilaku native Zsh, gunakan:

```bash
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

```bash
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

```bash
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

```bash
~/.config/zsh/
├── zshrc
└── functions/
    └── mkcd
```

Isi berkas `~/.config/zsh/functions/mkcd`:

```bash
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

```bash
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

# Functions & Autoload (lanjutan)

Bagian ini masih membahas fungsi Zsh sebelum berpindah ke arsitektur startup dan konfigurasi modular. Fokusnya adalah bagaimana fungsi menerima argumen, mempertahankan status kegagalan, mengisolasi perilaku melalui options, dan diorganisasi sebagai fungsi autoload.

## 08.7 Meneruskan argumen dengan benar

Dalam fungsi Zsh, `$1`, `$2`, dan seterusnya mengacu pada argumen individual. `$#` menyatakan jumlah argumen. Untuk meneruskan seluruh argumen, gunakan `"$@"`.

Perhatikan contoh berikut:

```bash
show_args() {
    print -r -- "Argumen pertama: $1"
    print -r -- "Jumlah argumen: $#"
}

show_args git status
```

Hasilnya:

```bash
Argumen pertama: git
Jumlah argumen: 2
```

Sekarang perhatikan fungsi pembungkus berikut:

```bash
run_command() {
    command "$@"
}

run_command ls -l /tmp
```

Fungsi tersebut meneruskan setiap argumen kepada perintah eksternal yang dijalankan. `command` meminta Zsh menjalankan perintah tanpa memilih fungsi shell bernama sama.

### Perbedaan `"$@"` dan `"$*"`

Misalnya fungsi dipanggil dengan tiga argumen:

```bash
inspect_args() {
    print -r -- "Jumlah argumen: $#"

    for arg in "$@"; do
        print -r -- "Argumen: [$arg]"
    done
}

inspect_args alpha "dua kata" gamma
```

Hasilnya:

```bash
Jumlah argumen: 3
Argumen: [alpha]
Argumen: [dua kata]
Argumen: [gamma]
```

`"$@"` mempertahankan setiap argumen sebagai elemen terpisah, termasuk argumen yang mengandung spasi.

Sebaliknya, `"$*"` menggabungkan seluruh argumen menjadi satu kata setelah ekspansi dalam konteks kutip ganda. Karena itu, untuk meneruskan argumen fungsi atau membangun perulangan atas argumen, pilih `"$@"` sebagai kebiasaan utama.

Tanpa kutip, seperti `$@` atau `$*`, hasilnya dapat mengalami pemisahan kata dan ekspansi glob. Itu berisiko mengubah argumen yang diterima fungsi.

## 08.8 Membedakan output dan exit status

Fungsi shell dapat menghasilkan dua hal yang berbeda:

1. Output, yaitu teks atau data yang ditulis ke stdout.
2. Exit status, yaitu angka yang menunjukkan keberhasilan atau kegagalan.

Contoh:

```bash
get_project_name() {
    print -r -- "zsh-tools"
    return 0
}

name=$(get_project_name)
status=$?

print -r -- "Nama: $name"
print -r -- "Status: $status"
```

`name` menerima output fungsi, sedangkan `status` menerima exit status-nya.

Namun, ada satu detail penting: `status=$?` harus dijalankan segera setelah fungsi selesai jika Anda ingin menyimpan status fungsi tersebut. Perintah lain yang dijalankan sebelumnya dapat menggantinya.

Untuk fungsi yang memeriksa kondisi, biasanya tidak perlu mencetak `true` atau `false`. Cukup gunakan exit status:

```bash
is_directory() {
    [[ -d "$1" ]]
}

if is_directory /tmp; then
    print -r -- "Direktori tersedia"
else
    print -r -- "Direktori tidak tersedia"
fi
```

Di sini, ekspresi `[[ -d "$1" ]]` menentukan status fungsi. Status `0` berarti kondisi benar; status bukan nol berarti kondisi salah.

Prinsipnya: gunakan stdout untuk data dan exit status untuk hasil operasi. Pemisahan ini memudahkan fungsi digunakan kembali oleh fungsi lain, kondisi `if`, maupun command substitution.

## 08.9 Menangani kegagalan tanpa menyembunyikannya

Salah satu kesalahan umum saat menulis fungsi adalah mengabaikan status kegagalan dari perintah di dalamnya.

Contoh yang kurang baik:

```bash
create_project() {
    command mkdir -- "$1"
    print -r -- "Proyek berhasil dibuat"
}
```

Jika `mkdir` gagal, fungsi tetap menjalankan `print` dan memberi pesan seolah-olah operasi berhasil.

Versi yang lebih baik:

```bash
create_project() {
    if (( $# != 1 )); then
        print -u2 -r -- "Penggunaan: create_project NAMA_DIREKTORI"
        return 2
    fi

    command mkdir -- "$1" || return
    print -r -- "Proyek berhasil dibuat"
}
```

Ada beberapa mekanisme yang perlu dipahami:

- `(( $# != 1 ))` memeriksa apakah jumlah argumen bukan satu.
- `print -u2` mengirim pesan ke stderr, bukan stdout.
- `return 2` menghentikan fungsi dengan status yang menunjukkan penggunaan fungsi tidak sesuai.
- `command mkdir -- "$1" || return` menghentikan fungsi jika `mkdir` gagal. Bentuk `return` tanpa angka meneruskan status perintah sebelumnya.

Angka `2` di sini merupakan konvensi untuk kesalahan penggunaan, bukan aturan yang diwajibkan Zsh. Yang penting adalah mendokumentasikan arti status yang digunakan oleh fungsi.

### Mengapa tidak selalu memakai `setopt ERR_EXIT`?

Jangan mengandalkan `ERR_EXIT` atau `set -e` sebagai pengganti desain penanganan error yang jelas. Perilakunya bergantung pada konteks eksekusi, seperti kondisi `if`, daftar `&&`/`||`, dan fungsi yang dipanggil dari konteks tertentu.

Untuk fungsi yang nantinya menjadi bagian dari konfigurasi Zsh atau plugin, pola yang lebih mudah dianalisis adalah:

1. Validasi argumen.
2. Jalankan operasi.
3. Periksa status operasi.
4. Kembalikan status kegagalan jika perlu.
5. Tampilkan pesan sukses hanya setelah operasi berhasil.

## 08.10 `emulate -L zsh`: menjaga perilaku fungsi

Zsh memiliki banyak options yang dapat mengubah cara perintah dan ekspansi bekerja. Fungsi yang berjalan dalam sesi interaktif dapat dipengaruhi oleh options yang diaktifkan di `.zshrc` atau oleh konfigurasi plugin lain.

Contoh:

```bash
my_function() {
    emulate -L zsh

    # Isi fungsi diletakkan di sini.
}
```

`emulate -L zsh` melakukan dua hal penting:

- Menetapkan perilaku emulasi Zsh untuk fungsi tersebut.
- Melokalkan perubahan options agar tidak menjadi perubahan permanen pada lingkungan pemanggil setelah fungsi selesai.

Dengan demikian, fungsi dapat lebih konsisten ketika dipanggil dari sesi yang memiliki konfigurasi berbeda. Ini sangat berguna saat mengembangkan fungsi mandiri atau plugin.

Perlu dibedakan: `emulate -L zsh` tidak mengisolasi seluruh lingkungan fungsi. Ia bukan sandbox, dan tidak otomatis membatalkan perubahan filesystem, variabel global yang sengaja diubah, atau efek eksternal dari perintah yang dijalankan.

Contoh yang mengubah option secara lokal:

```bash
show_glob_behavior() {
    emulate -L zsh
    setopt EXTENDED_GLOB

    print -r -- "Extended glob aktif di fungsi ini"
}
```

Di sini, perubahan option dilokalkan. Setelah fungsi kembali, keadaan option pada pemanggil dipulihkan.

## 08.11 Praktik fungsi yang baik: contoh `mkcd`

Fungsi `mkcd` membuat direktori, lalu berpindah ke direktori tersebut. Kita dapat menggabungkan beberapa konsep sebelumnya menjadi satu contoh.

```bash
mkcd() {
    emulate -L zsh

    if (( $# != 1 )); then
        print -u2 -r -- "Penggunaan: mkcd DIREKTORI"
        return 2
    fi

    command mkdir -p -- "$1" || return
    builtin cd -- "$1"
}
```

Pemakaian:

```bash
mkcd proyek-baru
```

Alurnya:

1. `emulate -L zsh` menjaga perilaku options fungsi tetap terlokalisasi.
2. Pemeriksaan `$#` memastikan hanya satu argumen yang diberikan.
3. `mkdir -p` membuat direktori beserta direktori induk yang belum ada.
4. `|| return` menghentikan fungsi jika pembuatan direktori gagal.
5. `builtin cd` menggunakan builtin Zsh untuk berpindah direktori di dalam shell saat ini.

Mengapa menggunakan `builtin cd`, bukan menjalankan program eksternal `cd`? Karena direktori kerja merupakan keadaan proses shell. Program eksternal yang berjalan sebagai proses terpisah tidak dapat mengubah direktori kerja shell pemanggil.

Mengapa memakai `--`? Itu menandai akhir opsi perintah. Dengan demikian, argumen seperti `-nama-direktori` tidak langsung ditafsirkan sebagai opsi oleh `mkdir` atau `cd`.

Catatan: `mkdir -p` tidak menghapus isi direktori yang sudah ada. Jika direktori tujuan telah tersedia, fungsi tetap mencoba berpindah ke sana.

## 08.12 Memindahkan fungsi ke sistem autoload

Setelah fungsi bekerja, kita dapat memisahkan definisinya dari file utama konfigurasi. Inilah salah satu alasan `autoload` berguna.

Struktur direktori:

```bash
~/.config/zsh/
├── zshrc
└── functions/
    └── mkcd
```

Isi `~/.config/zsh/functions/mkcd`:

```bash
emulate -L zsh

if (( $# != 1 )); then
    print -u2 -r -- "Penggunaan: mkcd DIREKTORI"
    return 2
fi

command mkdir -p -- "$1" || return
builtin cd -- "$1"
```

Perhatikan bahwa file tersebut berisi badan fungsi, bukan pembungkus `mkcd() { ... }`. Ini merupakan format autoload native Zsh yang digunakan pada contoh ini.

Agar Zsh dapat menemukannya, tambahkan direktori fungsi ke `fpath` dan daftarkan fungsi tersebut:

```bash
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz mkcd
```

Setelah itu:

```bash
mkcd proyek-baru
```

Zsh akan memuat definisi fungsi ketika fungsi tersebut pertama kali dipanggil.

Makna opsi `autoload -Uz`:

- `-U`: mencegah ekspansi alias ketika definisi fungsi dimuat.
- `-z`: menggunakan gaya autoload native Zsh.

`fpath` adalah array direktori tempat Zsh mencari fungsi autoload. Urutannya penting: direktori yang berada lebih awal diperiksa lebih dahulu.

### Apa yang sebenarnya ditunda oleh autoload?

Perintah berikut:

```bash
autoload -Uz mkcd
```

tidak langsung menjalankan badan fungsi `mkcd`. Perintah itu mendaftarkan nama fungsi agar Zsh dapat memuat definisinya ketika dibutuhkan.

Ini berbeda dari:

```bash
source "$HOME/.config/zsh/functions/mkcd"
```

`source` membaca dan menjalankan file saat itu juga dalam shell saat ini. File `mkcd` pada contoh kita tidak ditulis sebagai deklarasi fungsi biasa, sehingga `source` file itu secara langsung bukan pengganti yang tepat untuk mekanisme autoload tersebut.

Autoload juga bukan berarti fungsi akan selalu dimuat ulang setiap kali dipanggil. Setelah definisinya dimuat, Zsh biasanya menggunakan fungsi yang sudah tersedia dalam sesi itu.

## 08.13 Memeriksa fungsi autoload

Ketika mengembangkan konfigurasi, Anda perlu membedakan tiga hal: apakah direktori pencarian sudah benar, apakah nama fungsi sudah didaftarkan, dan apakah definisinya sudah dimuat.

Gunakan perintah berikut untuk memeriksa keadaan tersebut.

| Perintah              | Tujuan                                             |
| --------------------- | -------------------------------------------------- |
| `print -rl -- $fpath` | Menampilkan direktori pencarian fungsi             |
| `whence -w mkcd`      | Memeriksa jenis perintah atau fungsi yang dikenali |
| `whence -v mkcd`      | Menampilkan informasi tentang nama tersebut        |
| `functions mkcd`      | Menampilkan definisi fungsi yang tersedia          |

Untuk melihat apakah Zsh dapat menemukan file fungsi, periksa lokasi yang sesuai:

```bash
print -r -- "$HOME/.config/zsh/functions/mkcd"
[[ -r "$HOME/.config/zsh/functions/mkcd" ]] \
    && print -r -- "File dapat dibaca"
```

Pemeriksaan ini memastikan file dapat dibaca, tetapi belum membuktikan bahwa `fpath` dan deklarasi autoload sudah benar. Periksa keduanya secara terpisah saat melakukan debugging.

## 08.14 Ringkasan alur kerja fungsi Zsh

- 1. Tentukan antarmuka fungsi

Argumen, output, dan arti exit status

- 2. Validasi input

Periksa jumlah argumen dan kondisi awal

- 3. Jalankan operasi

Pertahankan argumen dengan quoting dan periksa kegagalan

- 4. Pisahkan dan organisasikan

Gunakan autoload jika fungsi layak ditempatkan pada file terpisah

Pola ini menjadi fondasi untuk membaca fungsi dalam plugin Zsh: identifikasi inputnya, ikuti alur eksekusinya, cari cara menangani kegagalan, lalu periksa bagaimana fungsi dimuat dan dipanggil.

## Status Pelajaran 08

Materi utama Functions & Autoload telah mencakup definisi fungsi, argumen, cakupan variabel, `return`, penanganan kegagalan, `emulate -L zsh`, serta organisasi fungsi melalui `fpath` dan `autoload`.

Tahap berikutnya sesuai urutan kurikulum adalah Pelajaran 09 — Startup Architecture. Di sana kita akan mempelajari kapan `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`, dan `.zlogout` dijalankan, bagaimana membedakan shell login dengan shell interaktif, dan bagaimana alur startup memengaruhi pemuatan konfigurasi. Setelah memahami urutan tersebut, barulah konfigurasi modular dibangun di atas fondasi yang benar.

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

