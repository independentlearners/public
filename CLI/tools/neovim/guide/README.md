# Dokumentasi Komprehensif Neovim

### **1. Fitur Khusus Neovim dibandingkan Vim**

Neovim memiliki beberapa keunggulan dibandingkan Vim tradisional:

- **Arsitektur Asinkron**: Mendukung operasi non-blocking untuk performa yang lebih baik
- **API yang Ekstensibel**: Mendukung integrasi dengan berbagai bahasa pemrograman (Python, Lua, Ruby, JavaScript)
- **Built-in Terminal Emulator**: Terminal terintegrasi yang dapat diakses dengan `:terminal`
- **Floating Windows**: Mendukung jendela mengambang untuk UI yang lebih fleksibel
- **Lua sebagai First-Class Language**: Dukungan penuh untuk konfigurasi dan plugin berbasis Lua

### **2. Pendalaman Konfigurasi Lua**

```lua
-- Struktur konfigurasi modular
-- ~/.config/nvim/
-- ├── init.lua                  -- File utama yang memuat semua modul
-- ├── lua/
-- │   ├── core/                 -- Konfigurasi inti
-- │   │   ├── options.lua       -- Pengaturan dasar
-- │   │   ├── keymaps.lua       -- Pemetaan kunci
-- │   │   └── autocmds.lua      -- Perintah otomatis
-- │   ├── plugins/              -- Konfigurasi plugin
-- │   │   ├── init.lua          -- Inisialisasi plugin
-- │   │   ├── lsp.lua           -- Konfigurasi LSP
-- │   │   └── ...               -- Plugin lainnya
-- │   └── utils/                -- Fungsi utilitas
-- └── after/                    -- Konfigurasi yang dijalankan setelah loading
```

### **3. Optimisasi Performa**

- **Lazy Loading**: Gunakan `lazy.nvim` untuk memuat plugin hanya ketika diperlukan
- **Event-based Loading**: Memuat plugin berdasarkan event tertentu
- **Profiling**: Gunakan `:profile start profile.log` dan `:profile func *` untuk mengidentifikasi bottleneck
- **Gunakan Luajit**: Neovim menggunakan LuaJIT yang jauh lebih cepat dari Lua standar

### **4. Neovim Remote**

```bash
# Instalasi
pip install neovim-remote

# Penggunaan
nvr --remote-tab file.txt  # Buka file di tab baru
nvr --remote-send ':echo "Hello"<CR>'  # Kirim perintah ke instance Neovim
```

### **5. Pengembangan Plugin**

```lua
-- Struktur dasar plugin
local M = {}

function M.setup(opts)
  opts = opts or {}
  -- Konfigurasi plugin
end

function M.method()
  -- Implementasi metode
end

return M
```

### **6. Integrasi dengan Sistem Operasi**

- **Clipboard**: `vim.opt.clipboard = "unnamedplus"` untuk integrasi dengan clipboard sistem
- **Notifikasi**: Gunakan `vim.notify` untuk notifikasi sistem
- **Shada File**: Penyimpanan persistensi data (`:help shada`)

### **7. Troubleshooting dan Diagnostik**

- `:checkhealth` untuk mengecek kesehatan konfigurasi
- `:verbose map <key>` untuk memeriksa pemetaan kunci
- `vim.api.nvim_notify()` untuk mencatat pesan debug

# Kamus Shortcut Komprehensif Neovim

## Mode Normal

### Navigasi Dasar

| Shortcut    | Deskripsi                                       |
| ----------- | ----------------------------------------------- |
| `h`         | Gerak kursor ke kiri                            |
| `j`         | Gerak kursor ke bawah                           |
| `k`         | Gerak kursor ke atas                            |
| `l`         | Gerak kursor ke kanan                           |
| `0`         | Pindah ke awal baris                            |
| `^`         | Pindah ke karakter pertama bukan spasi di baris |
| `$`         | Pindah ke akhir baris                           |
| `gg`        | Pindah ke awal file                             |
| `G`         | Pindah ke akhir file                            |
| `<number>G` | Pindah ke baris nomor tertentu                  |
| `Ctrl-o`    | Kembali ke posisi sebelumnya                    |
| `Ctrl-i`    | Maju ke posisi setelahnya                       |

### Navigasi Kata

| Shortcut | Deskripsi                                                      |
| -------- | -------------------------------------------------------------- |
| `w`      | Pindah ke awal kata berikutnya                                 |
| `W`      | Pindah ke awal kata berikutnya (hanya spasi sebagai pembatas)  |
| `e`      | Pindah ke akhir kata saat ini                                  |
| `E`      | Pindah ke akhir kata saat ini (hanya spasi sebagai pembatas)   |
| `b`      | Pindah ke awal kata sebelumnya                                 |
| `B`      | Pindah ke awal kata sebelumnya (hanya spasi sebagai pembatas)  |
| `ge`     | Pindah ke akhir kata sebelumnya                                |
| `gE`     | Pindah ke akhir kata sebelumnya (hanya spasi sebagai pembatas) |

### Navigasi Layar

| Shortcut | Deskripsi                                |
| -------- | ---------------------------------------- |
| `Ctrl-f` | Gulir satu layar ke bawah                |
| `Ctrl-b` | Gulir satu layar ke atas                 |
| `Ctrl-d` | Gulir setengah layar ke bawah            |
| `Ctrl-u` | Gulir setengah layar ke atas             |
| `Ctrl-e` | Gulir satu baris ke bawah                |
| `Ctrl-y` | Gulir satu baris ke atas                 |
| `zz`     | Posisikan baris saat ini di tengah layar |
| `zt`     | Posisikan baris saat ini di atas layar   |
| `zb`     | Posisikan baris saat ini di bawah layar  |

### Navigasi Pencarian

| Shortcut   | Deskripsi                                   |
| ---------- | ------------------------------------------- |
| `/pattern` | Cari maju untuk pattern                     |
| `?pattern` | Cari mundur untuk pattern                   |
| `n`        | Lanjutkan pencarian ke arah yang sama       |
| `N`        | Lanjutkan pencarian ke arah yang berlawanan |
| `*`        | Cari kata di bawah kursor maju              |
| `#`        | Cari kata di bawah kursor mundur            |
| `g*`       | Cari kata di bawah kursor maju (sebagian)   |
| `g#`       | Cari kata di bawah kursor mundur (sebagian) |

### Navigasi Teks Spesifik

| Shortcut | Deskripsi                            |
| -------- | ------------------------------------ |
| `%`      | Pindah ke pasangan kurung yang cocok |
| `[[`     | Pindah ke awal bagian sebelumnya     |
| `]]`     | Pindah ke awal bagian berikutnya     |
| `[]`     | Pindah ke akhir bagian sebelumnya    |
| `][`     | Pindah ke akhir bagian berikutnya    |
| `{`      | Pindah ke paragraf sebelumnya        |
| `}`      | Pindah ke paragraf berikutnya        |
| `(`      | Pindah ke kalimat sebelumnya         |
| `)`      | Pindah ke kalimat berikutnya         |

### Navigasi Tanda (Marks)

| Shortcut       | Deskripsi                                                                |
| -------------- | ------------------------------------------------------------------------ |
| `m{a-zA-Z}`    | Tetapkan tanda dengan nama {a-zA-Z}                                      |
| `'{a-zA-Z}`    | Pindah ke baris tanda {a-zA-Z}                                           |
| `` `{a-zA-Z}`` | Pindah ke posisi tanda {a-zA-Z}                                          |
| ` ` ``         | Pindah ke posisi sebelum lompatan terakhir                               |
| `` `. ``       | Pindah ke posisi edit terakhir                                           |
| `` `0 ``       | Pindah ke posisi saat terakhir keluar dari file                          |
| `` `" ``       | Pindah ke posisi saat terakhir keluar dari file (bekerja di antara file) |
| `` `[ ``       | Pindah ke awal operasi terakhir                                          |
| `` `] ``       | Pindah ke akhir operasi terakhir                                         |

### Mengedit Teks

| Shortcut      | Deskripsi                                                          |
| ------------- | ------------------------------------------------------------------ |
| `i`           | Masuk ke mode insert di posisi kursor                              |
| `I`           | Masuk ke mode insert di awal baris                                 |
| `a`           | Masuk ke mode insert setelah kursor                                |
| `A`           | Masuk ke mode insert di akhir baris                                |
| `o`           | Buka baris baru di bawah dan masuk ke mode insert                  |
| `O`           | Buka baris baru di atas dan masuk ke mode insert                   |
| `r`           | Ganti karakter di bawah kursor                                     |
| `R`           | Masuk ke mode replace                                              |
| `s`           | Hapus karakter di bawah kursor dan masuk ke mode insert            |
| `S`           | Hapus baris dan masuk ke mode insert                               |
| `C`           | Hapus dari kursor hingga akhir baris dan masuk ke mode insert      |
| `cc`          | Hapus baris dan masuk ke mode insert                               |
| `cw`          | Hapus kata dan masuk ke mode insert                                |
| `ciw`         | Hapus kata di bawah kursor dan masuk ke mode insert                |
| `ci"`         | Hapus teks di dalam tanda kutip dan masuk ke mode insert           |
| `ci(`         | Hapus teks di dalam kurung dan masuk ke mode insert                |
| `ct{char}`    | Hapus hingga karakter {char} dan masuk ke mode insert              |
| `cf{char}`    | Hapus hingga dan termasuk karakter {char} dan masuk ke mode insert |
| `c/{pattern}` | Hapus hingga pattern dan masuk ke mode insert                      |

### Menghapus Teks

| Shortcut      | Deskripsi                                 |
| ------------- | ----------------------------------------- |
| `x`           | Hapus karakter di bawah kursor            |
| `X`           | Hapus karakter sebelum kursor             |
| `dw`          | Hapus kata                                |
| `diw`         | Hapus kata di bawah kursor                |
| `di"`         | Hapus teks di dalam tanda kutip           |
| `di(`         | Hapus teks di dalam kurung                |
| `dd`          | Hapus baris                               |
| `D`           | Hapus dari kursor hingga akhir baris      |
| `dt{char}`    | Hapus hingga karakter {char}              |
| `df{char}`    | Hapus hingga dan termasuk karakter {char} |
| `d/{pattern}` | Hapus hingga pattern                      |
| `d{motion}`   | Hapus teks yang dicakup oleh motion       |
| `{n}dd`       | Hapus n baris                             |

### Salin dan Tempel

| Shortcut    | Deskripsi                                                            |
| ----------- | -------------------------------------------------------------------- |
| `yy`        | Salin baris saat ini                                                 |
| `Y`         | Salin baris saat ini (sama dengan yy)                                |
| `y$`        | Salin dari kursor hingga akhir baris                                 |
| `yw`        | Salin kata                                                           |
| `yiw`       | Salin kata di bawah kursor                                           |
| `yi"`       | Salin teks di dalam tanda kutip                                      |
| `yi(`       | Salin teks di dalam kurung                                           |
| `y{motion}` | Salin teks yang dicakup oleh motion                                  |
| `{n}yy`     | Salin n baris                                                        |
| `p`         | Tempel setelah kursor                                                |
| `P`         | Tempel sebelum kursor                                                |
| `]p`        | Tempel dengan indentasi yang disesuaikan                             |
| `gp`        | Tempel setelah kursor dan letakkan kursor setelah teks yang ditempel |
| `gP`        | Tempel sebelum kursor dan letakkan kursor setelah teks yang ditempel |

### Undo dan Redo

| Shortcut          | Deskripsi                                               |
| ----------------- | ------------------------------------------------------- |
| `u`               | Batalkan perubahan terakhir                             |
| `Ctrl-r`          | Ulangi perubahan yang dibatalkan                        |
| `U`               | Batalkan semua perubahan pada baris saat ini            |
| `g-`              | Kembali ke perubahan sebelumnya                         |
| `g+`              | Maju ke perubahan berikutnya                            |
| `:earlier {time}` | Kembali ke keadaan sebelumnya (misalnya `:earlier 10m`) |
| `:later {time}`   | Maju ke keadaan berikutnya (misalnya `:later 10m`)      |

### Indentasi

| Shortcut    | Deskripsi                                        |
| ----------- | ------------------------------------------------ |
| `>>`        | Indentasi baris saat ini ke kanan                |
| `<<`        | Indentasi baris saat ini ke kiri                 |
| `>%`        | Indentasi blok di dalam kurung ke kanan          |
| `<%`        | Indentasi blok di dalam kurung ke kiri           |
| `>{motion}` | Indentasi teks yang dicakup oleh motion ke kanan |
| `<{motion}` | Indentasi teks yang dicakup oleh motion ke kiri  |
| `={motion}` | Auto-indentasi teks yang dicakup oleh motion     |
| `=G`        | Auto-indentasi hingga akhir file                 |
| `gg=G`      | Auto-indentasi seluruh file                      |

### Kasus Teks

| Shortcut     | Deskripsi                                         |
| ------------ | ------------------------------------------------- |
| `~`          | Ubah kasus karakter di bawah kursor               |
| `g~{motion}` | Ubah kasus teks yang dicakup oleh motion          |
| `g~~`        | Ubah kasus seluruh baris                          |
| `gU{motion}` | Ubah teks yang dicakup oleh motion ke huruf besar |
| `gUU`        | Ubah seluruh baris ke huruf besar                 |
| `gu{motion}` | Ubah teks yang dicakup oleh motion ke huruf kecil |
| `guu`        | Ubah seluruh baris ke huruf kecil                 |

### Macros

| Shortcut     | Deskripsi                                          |
| ------------ | -------------------------------------------------- |
| `q{a-z}`     | Mulai merekam macro ke register {a-z}              |
| `q`          | Hentikan perekaman macro                           |
| `@{a-z}`     | Jalankan macro dari register {a-z}                 |
| `@@`         | Jalankan macro terakhir                            |
| `{n}@{a-z}`  | Jalankan macro dari register {a-z} sebanyak n kali |
| `:registers` | Tampilkan isi semua register termasuk macro        |

### Lipatan (Folding)

| Shortcut     | Deskripsi                                        |
| ------------ | ------------------------------------------------ |
| `zf{motion}` | Buat lipatan untuk teks yang dicakup oleh motion |
| `zd`         | Hapus lipatan di bawah kursor                    |
| `zD`         | Hapus lipatan secara rekursif                    |
| `zo`         | Buka lipatan di bawah kursor                     |
| `zO`         | Buka lipatan secara rekursif                     |
| `zc`         | Tutup lipatan di bawah kursor                    |
| `zC`         | Tutup lipatan secara rekursif                    |
| `za`         | Toggle lipatan di bawah kursor                   |
| `zA`         | Toggle lipatan secara rekursif                   |
| `zr`         | Kurangi level lipatan di seluruh file            |
| `zR`         | Buka semua lipatan                               |
| `zm`         | Tambah level lipatan di seluruh file             |
| `zM`         | Tutup semua lipatan                              |
| `zn`         | Nonaktifkan lipatan                              |
| `zN`         | Aktifkan lipatan                                 |
| `zi`         | Toggle lipatan                                   |

### Register

| Shortcut | Deskripsi                                        |
| -------- | ------------------------------------------------ |
| `"{a-z}` | Pilih register {a-z} untuk operasi berikutnya    |
| `"0p`    | Tempel dari register 0 (berisi salin terakhir)   |
| `"1p`    | Tempel dari register 1 (berisi hapus terakhir)   |
| `"+y`    | Salin ke clipboard sistem                        |
| `"+p`    | Tempel dari clipboard sistem                     |
| `"*y`    | Salin ke clipboard pilihan                       |
| `"*p`    | Tempel dari clipboard pilihan                    |
| `"_d`    | Hapus tanpa menyimpan ke register ("black hole") |
| `:reg`   | Tampilkan isi semua register                     |

### Text Objects

| Shortcut       | Deskripsi                                               |
| -------------- | ------------------------------------------------------- |
| `iw`           | Inner word (kata tanpa spasi)                           |
| `aw`           | A word (kata dengan spasi)                              |
| `is`           | Inner sentence (kalimat tanpa spasi)                    |
| `as`           | A sentence (kalimat dengan spasi)                       |
| `ip`           | Inner paragraph (paragraf tanpa baris kosong)           |
| `ap`           | A paragraph (paragraf dengan baris kosong)              |
| `i"`           | Inner double quotes (teks di dalam tanda kutip ganda)   |
| `a"`           | A double quotes (teks termasuk tanda kutip ganda)       |
| `i'`           | Inner single quotes (teks di dalam tanda kutip tunggal) |
| `a'`           | A single quotes (teks termasuk tanda kutip tunggal)     |
| `i(` atau `i)` | Inner parentheses (teks di dalam kurung)                |
| `a(` atau `a)` | A parentheses (teks termasuk kurung)                    |
| `i[` atau `i]` | Inner brackets (teks di dalam kurung siku)              |
| `a[` atau `a]` | A brackets (teks termasuk kurung siku)                  |
| `i{` atau `i}` | Inner braces (teks di dalam kurung kurawal)             |
| `a{` atau `a}` | A braces (teks termasuk kurung kurawal)                 |
| `it`           | Inner tag (teks di dalam tag HTML/XML)                  |
| `at`           | A tag (teks termasuk tag HTML/XML)                      |
| `i>`           | Inner angle brackets (teks di dalam tanda <>)           |
| `a>`           | A angle brackets (teks termasuk tanda <>)               |
| `i\``          | Inner backticks (teks di dalam backticks)               |
| `a\``          | A backticks (teks termasuk backticks)                   |

### Window Management

| Shortcut    | Deskripsi                             |
| ----------- | ------------------------------------- |
| `Ctrl-w s`  | Split window horizontal               |
| `Ctrl-w v`  | Split window vertikal                 |
| `Ctrl-w w`  | Siklus antara window                  |
| `Ctrl-w h`  | Pindah ke window di kiri              |
| `Ctrl-w j`  | Pindah ke window di bawah             |
| `Ctrl-w k`  | Pindah ke window di atas              |
| `Ctrl-w l`  | Pindah ke window di kanan             |
| `Ctrl-w c`  | Tutup window saat ini                 |
| `Ctrl-w o`  | Tutup semua window kecuali saat ini   |
| `Ctrl-w =`  | Sesuaikan ukuran semua window         |
| `Ctrl-w _`  | Maksimalkan tinggi window saat ini    |
| `Ctrl-w \|` | Maksimalkan lebar window saat ini     |
| `Ctrl-w +`  | Tambah tinggi window saat ini         |
| `Ctrl-w -`  | Kurangi tinggi window saat ini        |
| `Ctrl-w >`  | Tambah lebar window saat ini          |
| `Ctrl-w <`  | Kurangi lebar window saat ini         |
| `Ctrl-w x`  | Tukar posisi dengan window berikutnya |
| `Ctrl-w r`  | Rotasi window                         |
| `Ctrl-w T`  | Pindahkan window ke tab baru          |
| `Ctrl-w z`  | Tutup preview window                  |

### Tab Management

| Shortcut                 | Deskripsi                        |
| ------------------------ | -------------------------------- |
| `:tabnew`                | Buka tab baru                    |
| `:tabnext` atau `gt`     | Pindah ke tab berikutnya         |
| `:tabprevious` atau `gT` | Pindah ke tab sebelumnya         |
| `{n}gt`                  | Pindah ke tab ke-n               |
| `:tabfirst`              | Pindah ke tab pertama            |
| `:tablast`               | Pindah ke tab terakhir           |
| `:tabclose`              | Tutup tab saat ini               |
| `:tabonly`               | Tutup semua tab kecuali saat ini |
| `:tabmove {n}`           | Pindahkan tab ke posisi n        |
| `:tab split`             | Buka buffer saat ini di tab baru |

## Mode Insert

### Navigasi dan Editing

| Shortcut              | Deskripsi                                |
| --------------------- | ---------------------------------------- |
| `Esc` atau `Ctrl-[`   | Keluar dari mode insert ke mode normal   |
| `Ctrl-o`              | Masuk ke mode normal untuk satu perintah |
| `Ctrl-h`              | Hapus karakter sebelumnya                |
| `Ctrl-w`              | Hapus kata sebelumnya                    |
| `Ctrl-u`              | Hapus hingga awal baris                  |
| `Ctrl-j` atau `Enter` | Mulai baris baru                         |
| `Ctrl-t`              | Indentasi baris saat ini (satu level)    |
| `Ctrl-d`              | De-indentasi baris saat ini (satu level) |
| `Ctrl-n`              | Autocomplete kata berikutnya             |
| `Ctrl-p`              | Autocomplete kata sebelumnya             |
| `Ctrl-x Ctrl-l`       | Autocomplete baris                       |
| `Ctrl-x Ctrl-f`       | Autocomplete nama file                   |
| `Ctrl-x Ctrl-o`       | Autocomplete omni (konteks-sadar)        |
| `Ctrl-e`              | Batalkan autocomplete                    |
| `Ctrl-y`              | Konfirmasi autocomplete yang dipilih     |
| `Ctrl-r {register}`   | Sisipkan konten dari register            |
| `Ctrl-r =`            | Sisipkan hasil ekspresi                  |
| `Ctrl-v {code}`       | Sisipkan karakter berdasarkan kode       |
| `Ctrl-k {digraph}`    | Sisipkan karakter berdasarkan digraph    |
| `Ctrl-a`              | Sisipkan teks yang terakhir disisipkan   |

## Mode Visual

### Seleksi

| Shortcut                 | Deskripsi                                         |
| ------------------------ | ------------------------------------------------- |
| `v`                      | Mulai mode visual (seleksi karakter)              |
| `V`                      | Mulai mode visual line (seleksi baris)            |
| `Ctrl-v`                 | Mulai mode visual block (seleksi blok)            |
| `gv`                     | Mulai ulang visual mode dengan seleksi sebelumnya |
| `o`                      | Pindah ke ujung lain seleksi                      |
| `O`                      | Pindah ke ujung lain seleksi (mode visual block)  |
| `aw`                     | Seleksi kata dengan spasi                         |
| `iw`                     | Seleksi kata tanpa spasi                          |
| `as`                     | Seleksi kalimat dengan spasi                      |
| `is`                     | Seleksi kalimat tanpa spasi                       |
| `ap`                     | Seleksi paragraf dengan baris kosong              |
| `ip`                     | Seleksi paragraf tanpa baris kosong               |
| `ab` atau `a(` atau `a)` | Seleksi blok kurung dengan kurung                 |
| `ib` atau `i(` atau `i)` | Seleksi blok kurung tanpa kurung                  |
| `aB` atau `a{` atau `a}` | Seleksi blok kurung kurawal dengan kurung         |
| `iB` atau `i{` atau `i}` | Seleksi blok kurung kurawal tanpa kurung          |
| `at`                     | Seleksi tag HTML dengan tag                       |
| `it`                     | Seleksi tag HTML tanpa tag                        |

### Manipulasi

| Shortcut     | Deskripsi                                              |
| ------------ | ------------------------------------------------------ |
| `d` atau `x` | Hapus seleksi                                          |
| `y`          | Salin seleksi                                          |
| `c`          | Ubah seleksi                                           |
| `>`          | Indentasi seleksi ke kanan                             |
| `<`          | Indentasi seleksi ke kiri                              |
| `=`          | Auto-indentasi seleksi                                 |
| `~`          | Ubah kasus seleksi                                     |
| `u`          | Ubah seleksi ke huruf kecil                            |
| `U`          | Ubah seleksi ke huruf besar                            |
| `J`          | Gabungkan baris yang dipilih                           |
| `!`          | Filter seleksi melalui perintah eksternal              |
| `:`          | Mulai perintah pada baris yang dipilih                 |
| `r`          | Ganti seleksi dengan karakter                          |
| `s`          | Hapus seleksi dan masuk ke mode insert                 |
| `S`          | Hapus seleksi dan masuk ke mode insert (baris)         |
| `p`          | Ganti seleksi dengan register                          |
| `Ctrl-a`     | Tambahkan angka di seleksi                             |
| `Ctrl-x`     | Kurangi angka di seleksi                               |
| `g Ctrl-a`   | Tambahkan angka berurutan di seleksi                   |
| `g Ctrl-x`   | Kurangi angka berurutan di seleksi                     |
| `I`          | Masuk ke mode insert di awal blok (mode visual block)  |
| `A`          | Masuk ke mode insert di akhir blok (mode visual block) |

## Mode Command

### File Operations

| Shortcut           | Deskripsi                                         |
| ------------------ | ------------------------------------------------- |
| `:e [file]`        | Edit file                                         |
| `:w`               | Simpan file                                       |
| `:w [file]`        | Simpan sebagai file                               |
| `:w!`              | Paksa simpan file                                 |
| `:q`               | Keluar                                            |
| `:q!`              | Paksa keluar tanpa menyimpan                      |
| `:wq` atau `:x`    | Simpan dan keluar                                 |
| `:wa`              | Simpan semua file                                 |
| `:qa`              | Keluar dari semua file                            |
| `:wqa`             | Simpan semua file dan keluar                      |
| `:saveas [file]`   | Simpan sebagai file                               |
| `:r [file]`        | Baca file dan sisipkan di bawah kursor            |
| `:r! [command]`    | Baca output perintah dan sisipkan di bawah kursor |
| `:cd [dir]`        | Ubah direktori kerja                              |
| `:pwd`             | Tampilkan direktori kerja saat ini                |
| `:ls`              | Tampilkan daftar buffer                           |
| `:bn`              | Pindah ke buffer berikutnya                       |
| `:bp`              | Pindah ke buffer sebelumnya                       |
| `:bd`              | Hapus buffer                                      |
| `:b [number]`      | Pindah ke buffer tertentu                         |
| `:ball`            | Buka semua buffer                                 |
| `:bufdo [command]` | Jalankan perintah pada semua buffer               |
| `:set [option]`    | Atur opsi                                         |
| `:!`               | Jalankan perintah shell                           |

### Pencarian dan Penggantian

| Shortcut                    | Deskripsi                                                            |
| --------------------------- | -------------------------------------------------------------------- |
| `:s/old/new/`               | Ganti 'old' dengan 'new' pada baris saat ini                         |
| `:s/old/new/g`              | Ganti semua 'old' dengan 'new' pada baris saat ini                   |
| `:s/old/new/gc`             | Ganti semua 'old' dengan 'new' pada baris saat ini dengan konfirmasi |
| `:%s/old/new/g`             | Ganti semua 'old' dengan 'new' di seluruh file                       |
| `:%s/old/new/gc`            | Ganti semua 'old' dengan 'new' di seluruh file dengan konfirmasi     |
| `:%s/old/new/gi`            | Ganti semua 'old' dengan 'new' di seluruh file (case insensitive)    |
| `:g/pattern/d`              | Hapus semua baris yang mengandung 'pattern'                          |
| `:g!/pattern/d`             | Hapus semua baris yang tidak mengandung 'pattern'                    |
| `:g/pattern/s/old/new/g`    | Pada baris yang mengandung 'pattern', ganti 'old' dengan 'new'       |
| `:vimgrep /pattern/ {file}` | Cari 'pattern' di file                                               |
| `:copen`                    | Buka quickfix window                                                 |
| `:cnext`                    | Pindah ke hasil berikutnya                                           |
| `:cprev`                    | Pindah ke hasil sebelumnya                                           |
| `:cdo [command]`            | Jalankan perintah pada setiap hasil                                  |

### Neovim Terminal

| Shortcut               | Deskripsi                                                    |
| ---------------------- | ------------------------------------------------------------ |
| `:terminal`            | Buka terminal terintegrasi                                   |
| `i` atau `a`           | Masuk ke mode terminal (normal -> terminal)                  |
| `<C-\><C-n>`           | Keluar dari mode terminal (terminal -> normal)               |
| `<C-\><C-o>`           | Jalankan satu perintah normal mode, lalu kembali ke terminal |
| `:terminal {cmd}`      | Buka terminal dan jalankan perintah                          |
| `:split term://{cmd}`  | Buka terminal di split horizontal                            |
| `:vsplit term://{cmd}` | Buka terminal di split vertikal                              |
| `:tabnew term://{cmd}` | Buka terminal di tab baru                                    |
| `:terminal ++rows={n}` | Buka terminal dengan n baris                                 |
| `:terminal ++cols={n}` | Buka terminal dengan n kolom                                 |
| `:terminal ++curwin`   | Buka terminal di window saat ini                             |
| `:terminal ++hidden`   | Buka terminal tersembunyi                                    |
| `:terminal ++shell`    | Buka terminal dengan shell default                           |
| `:terminal ++close`    | Tutup terminal setelah perintah selesai                      |
| `:terminal ++noclose`  | Jangan tutup terminal setelah perintah selesai               |

### LSP (Language Server Protocol)

| Shortcut      | Deskripsi                      |
| ------------- | ------------------------------ |
| `gd`          | Pergi ke definisi              |
| `gD`          | Pergi ke deklarasi             |
| `gi`          | Pergi ke implementasi          |
| `gr`          | Pergi ke referensi             |
| `K`           | Tampilkan hover informasi      |
| `<C-k>`       | Tampilkan signature help       |
| `<Leader>rn`  | Ganti nama                     |
| `<Leader>ca`  | Tampilkan code actions         |
| `<Leader>f`   | Format dokumen                 |
| `<Leader>qf`  | Quick fix                      |
| `[d`          | Pergi ke diagnostik sebelumnya |
| `]d`          | Pergi ke diagnostik berikutnya |
| `<Leader>e`   | Tampilkan diagnostik di line   |
| `<Leader>wa`  | Tambahkan folder ke workspace  |
| `<Leader>wr`  | Hapus folder dari workspace    |
| `<Leader>wl`  | Tampilkan folder workspace     |
| `:LspInfo`    | Tampilkan informasi LSP        |
| `:LspStart`   | Mulai server LSP               |
| `:LspStop`    | Hentikan server LSP            |
| `:LspRestart` | Restart server LSP             |

### Telescope (Fuzzy Finder)

| Shortcut     | Deskripsi                     |
| ------------ | ----------------------------- |
| `<Leader>ff` | Cari file                     |
| `<Leader>fg` | Live grep                     |
| `<Leader>fb` | Cari buffer                   |
| `<Leader>fh` | Cari bantuan                  |
| `<Leader>fr` | Cari register                 |
| `<Leader>fo` | Cari opsi                     |
| `<Leader>fc` | Cari perintah                 |
| `<Leader>fm` | Cari marks                    |
| `<Leader>fk` | Cari keymaps                  |
| `<Leader>fs` | Cari string                   |
| `<Leader>ft` | Cari tag                      |
| `<C-j>`      | Pindah ke bawah di hasil      |
| `<C-k>`      | Pindah ke atas di hasil       |
| `<C-n>`      | Pindah ke hasil berikutnya    |
| `<C-p>`      | Pindah ke hasil sebelumnya    |
| `<C-c>`      | Tutup Telescope               |
| `<C-u>`      | Scroll preview ke atas        |
| `<C-d>`      | Scroll preview ke bawah       |
| `<C-q>`      | Kirim semua hasil ke quickfix |
| `<Tab>`      | Pilih hasil di mode normal    |
| `<CR>`       | Konfirmasi pilihan            |
| `<C-x>`      | Buka di split horizontal      |
| `<C-v>`      | Buka di split vertikal        |
| `<C-t>`      | Buka di tab baru              |

### Nvim-Tree (File Explorer)

| Shortcut        | Deskripsi                           |
| --------------- | ----------------------------------- |
| `<Leader>e`     | Toggle file explorer                |
| `<CR>` atau `o` | Buka file/folder                    |
| `<C-]>`         | CD ke folder di bawah kursor        |
| `<BS>`          | Tutup folder yang terakhir dibuka   |
| `a`             | Buat file/folder baru               |
| `d`             | Hapus file/folder                   |
| `r`             | Ganti nama file/folder              |
| `x`             | Potong file/folder ke clipboard     |
| `c`             | Salin file/folder ke clipboard      |
| `p`             | Tempel dari clipboard               |
| `y`             | Salin nama file/folder ke clipboard |
| `Y`             | Salin path relatif ke clipboard     |
| `gy`            | Salin path absolut ke clipboard     |
| `<C-v>`         | Buka file di split vertikal         |
| `<C-x>`         | Buka file di split horizontal       |
| `<C-t>`         | Buka file di tab baru               |
| `<Tab>`         | Preview file                        |
| `I`             | Toggle hidden files                 |
| `H`             | Toggle dotfiles                     |
| `R`             | Refresh explorer                    |
| `f`             | Cari file                           |
| `F`             | Cari file (clear filter)            |
| `.`             | Tampilkan bantuan                   |
| `q`             | Tutup explorer                      |

### Debug Adapter Protocol (DAP)

| Shortcut     | Deskripsi                  |
| ------------ | -------------------------- |
| `<Leader>db` | Toggle breakpoint          |
| `<Leader>dB` | Set breakpoint kondisional |
| `<Leader>dr` | Mulai debugging            |
| `<Leader>dc` | Continue                   |
| `<Leader>dn` | Step over                  |
| `<Leader>di` | Step into                  |
| `<Leader>do` | Step out                   |
| `<Leader>dq` | Quit debugging             |
| `<Leader>dh` | Hover variabel             |
| `<Leader>dv` | Lihat variabel             |
| `<Leader>dw` | Widget                     |
| `<Leader>ds` | Scope                      |
| `<Leader>df` | Frame                      |
| `<Leader>dl` | Run last                   |
| `<Leader>dp` | Preview                    |
| `<Leader>dt` | Toggle repl                |
| `<Leader>du` | Toggle UI                  |
| `<Leader>de` | Evaluate                   |
| `<Leader>dx` | Conditional breakpoint     |
| `<Leader>dd` | Show diagnostics           |

### Git Integration

| Shortcut      | Deskripsi                          |
| ------------- | ---------------------------------- |
| `:Git`        | Buka fugitive                      |
| `:Git commit` | Buat commit                        |
| `:Git push`   | Push ke remote                     |
| `:Git pull`   | Pull dari remote                   |
| `:Git blame`  | Tampilkan git blame                |
| `:Git log`    | Tampilkan git log                  |
| `:Git diff`   | Tampilkan git diff                 |
| `:Git status` | Tampilkan git status               |
| `:Git add %`  | Tambahkan file saat ini ke staging |
| `:GitGutter`  | Toggle git gutter                  |
| `[c`          | Lompat ke hunk sebelumnya          |
| `]c`          | Lompat ke hunk berikutnya          |
| `<Leader>hs`  | Stage hunk                         |
| `<Leader>hu`  | Unstage hunk                       |
| `<Leader>hp`  | Preview hunk                       |
| `<Leader>hr`  | Reset hunk                         |
| `<Leader>hR`  | Reset buffer                       |
| `<Leader>hb`  | Blame line                         |
| `<Leader>tb`  | Toggle blame                       |
| `<Leader>hd`  | Diff hunk                          |
| `<Leader>hD`  | Diff buffer                        |

### Treesitter

| Shortcut                 | Deskripsi                   |
| ------------------------ | --------------------------- |
| `:TSInstall {language}`  | Instal parser untuk bahasa  |
| `:TSUpdate`              | Perbarui parser             |
| `:TSBufEnable {module}`  | Aktifkan modul di buffer    |
| `:TSBufDisable {module}` | Nonaktifkan modul di buffer |
| `:TSEnable {module}`     | Aktifkan modul global       |
| `:TSDisable {module}`    | Nonaktifkan modul global    |
| `:TSModuleInfo`          | Tampilkan informasi modul   |
| `zz`                     | Fold toggle                 |
| `[[`                     | Lompat ke fungsi sebelumnya |
| `]]`                     | Lompat ke fungsi berikutnya |
| `[m`                     | Lompat ke method sebelumnya |
| `]m`                     | Lompat ke method berikutnya |
| `[c`                     | Lompat ke class sebelumnya  |
| `]c`                     | Lompat ke class berikutnya  |
| `as`                     | Select outer function       |
| `is`                     | Select inner function       |
| `af`                     | Select outer block          |
| `if`                     | Select inner block          |
| `ac`                     | Select outer class          |
| `ic`                     | Select inner class          |
| `aa`                     | Select outer parameter      |
| `ia`                     | Select inner parameter      |

### Utilitas Lainnya

| Shortcut       | Deskripsi                               |
| -------------- | --------------------------------------- |
| `:set spell`   | Aktifkan spell checking                 |
| `:set nospell` | Nonaktifkan spell checking              |
| `z=`           | Tampilkan sugesti untuk kata yang salah |
| `zg`           | Tambahkan kata ke kamus                 |
| `zw`           | Tandai kata sebagai salah               |
| `zuw`          | Hapus kata dari daftar salah            |
| `[s`           | Lompat ke kata yang salah sebelumnya    |
| `]s`           | Lompat ke kata yang salah berikutnya    |
| `:sort`        | Urutkan baris                           |
| `:sort!`       | Urutkan baris terbalik                  |
| `:sort i`      | Urutkan baris (case insensitive)        |
| `:sort u`      | Urutkan baris (hapus duplikat)          |
| `:sort n`      | Urutkan baris (numerik)                 |
| `:retab`       | Konversi tab ke spasi                   |
| `:set list`    | Tampilkan karakter tidak terlihat       |
| `:set nolist`  | Sembunyikan karakter tidak terlihat     |
| `:hardcopy`    | Cetak file                              |
| `:TOhtml`      | Konversi ke HTML                        |
| `:diffthis`    | Bandingkan buffer saat ini              |
| `:diffsplit`   | Bandingkan dengan file lain             |
| `:diffupdate`  | Perbarui diff                           |
| `:checkhealth` | Pemeriksaan kesehatan Neovim            |

### Floating Terminal

| Shortcut       | Deskripsi                           |
| -------------- | ----------------------------------- |
| `<Leader>ft`   | Toggle floating terminal            |
| `<Leader>tn`   | Buat terminal baru                  |
| `<Leader>t1-9` | Pilih terminal 1-9                  |
| `<Esc>`        | Keluar dari mode terminal           |
| `<C-\><C-n>`   | Masuk ke mode normal dari terminal  |
| `<C-h/j/k/l>`  | Navigasi antara terminal dan window |
| `<C-w>`        | Perintah window dalam terminal      |
| `<C-d>`        | Keluar dari terminal                |
| `<Leader>tf`   | Cari dalam terminal                 |

### Whichkey (Bantuan Shortcut)

| Shortcut               | Deskripsi                                           |
| ---------------------- | --------------------------------------------------- |
| `<Leader>`             | Tampilkan bantuan shortcut                          |
| `<Leader>?`            | Tampilkan bantuan shortcut                          |
| `<Leader>wk`           | Tampilkan bantuan keymap                            |
| `:WhichKey`            | Tampilkan bantuan shortcut                          |
| `:WhichKey <leader>`   | Tampilkan bantuan shortcut untuk leader             |
| `:WhichKey <leader> v` | Tampilkan bantuan shortcut untuk leader+v           |
| `:WhichKey ''`         | Tampilkan bantuan shortcut global                   |
| `:WhichKey '' v`       | Tampilkan bantuan shortcut global untuk mode visual |
| `:WhichKey '' i`       | Tampilkan bantuan shortcut global untuk mode insert |

### Neovim Lua API

| Shortcut                          | Deskripsi                      |
| --------------------------------- | ------------------------------ |
| `:lua`                            | Jalankan kode Lua              |
| `:luafile`                        | Jalankan file Lua              |
| `:lua=`                           | Evaluasi ekspresi Lua          |
| `:luado`                          | Jalankan Lua pada setiap baris |
| `:luapad`                         | Buka editor Lua interaktif     |
| `:LuaSnip`                        | Tampilkan snippet Lua          |
| `:TSLspOrganize`                  | Organisir impor                |
| `:TSLspRename`                    | Ganti nama                     |
| `:TSLspImportAll`                 | Impor semua                    |
| `:TSLspFixCurrent`                | Perbaiki masalah saat ini      |
| `:TSHighlightCapturesUnderCursor` | Tampilkan highlight            |
| `:TSPlaygroundToggle`             | Toggle playground              |
| `:TSNodeUnderCursor`              | Tampilkan node di bawah kursor |
| `:TSTextobjectSelect`             | Pilih text object              |

### Session Management

| Shortcut            | Deskripsi               |
| ------------------- | ----------------------- |
| `:mksession {file}` | Buat sesi               |
| `:source {file}`    | Muat sesi               |
| `:SessionSave`      | Simpan sesi             |
| `:SessionLoad`      | Muat sesi               |
| `:SessionDelete`    | Hapus sesi              |
| `:SessionList`      | Tampilkan daftar sesi   |
| `:SessionRestore`   | Pulihkan sesi           |
| `:SessionUpdate`    | Perbarui sesi           |
| `:SessionRename`    | Ganti nama sesi         |
| `:SessionShowLast`  | Tampilkan sesi terakhir |
| `:SessionCleanup`   | Bersihkan sesi          |
| `:SessionSaveAs`    | Simpan sesi sebagai     |
| `:SessionLoadLast`  | Muat sesi terakhir      |
| `:SessionPeek`      | Lihat sesi              |
| `:SessionPin`       | Pin sesi                |
| `:SessionUnpin`     | Unpin sesi              |

### Pengaturan dan Kustomisasi

| Shortcut         | Deskripsi             |
| ---------------- | --------------------- |
| `:set {option}`  | Atur opsi             |
| `:set {option}?` | Tampilkan nilai opsi  |
| `:set {option}&` | Reset opsi ke default |
| `:set all`       | Tampilkan semua opsi  |

---

### **1. Fitur Khusus Neovim (Lengkap)**

- **MessagePack RPC**: Arsitektur client-server untuk integrasi eksternal
- **Headless Mode**: Mode tanpa UI untuk scripting (`nvim --headless`)
- **Extended Marks**: Mendukung 58 jenis mark (a-zA-Z)
- **Job Control**: API untuk manajemen proses latar belakang
- **Built-in LSP Client**: Tanpa plugin tambahan (vs Vim's coc.nvim)
- **Tree-sitter Integration**: Parsing sintaksis real-time
- **XDG Base Directory**: Standar lokasi konfigurasi modern

### **2. Pendalaman Konfigurasi Lua (Tambahan)**

```lua
-- Contoh konfigurasi LSP lengkap
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  -- Mappings LSP
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
  -- Format on save
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.lua',
    callback = function() vim.lsp.buf.format() end
  })
end

lspconfig.pyright.setup { on_attach = on_attach }
```

### **3. Optimisasi Performa (Tambahan)**

- **Startup Profiling**:
  ```bash
  nvim --startuptime nvim.log
  ```
- **Disable Unused Providers**:
  ```lua
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  ```
- **Compiled Lua**:
  ```lua
  -- Gunakan :LuaCacheGen untuk precompile
  vim.loader.enable()
  ```

### **4. Neovim Remote (Tambahan)**

- **Advanced Usage**:

  ```bash
  # Edit file dalam instance yang sedang berjalan
  nvr -s --remote-silent +"set ft=lua" file.lua

  # Integrasi dengan SSH
  ssh user@host nvr --servername ssh --remote-expr 'expand("%:p")'
  ```

### **5. Pengembangan Plugin (Tambahan)**

```lua
-- Contoh plugin dengan autocommand
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.md',
  callback = function()
    vim.bo.textwidth = 80
    vim.bo.spell = true
  end
})

-- Expose command
vim.api.nvim_create_user_command('HelloWorld', function()
  print("Hello from Neovim!")
end, {})
```

### **6. Integrasi Sistem Operasi (Tambahan)**

- **File Watcher**:
  ```lua
  vim.loop.new_fs_event():start("file.txt", {}, function()
    print("File changed!")
  end)
  ```
- **Process Management**:
  ```lua
  local handle = vim.loop.spawn('ls', { args = {'-l'} }, function() end)
  ```

---

### **8. Advanced Text Manipulation**

#### **Regular Expressions**

| Pattern | Deskripsi           |
| ------- | ------------------- |
| `\v`    | Very magic mode     |
| `\V`    | Very non-magic mode |
| `\zs`   | Start of match      |
| `\ze`   | End of match        |
| `\%^`   | Beginning of file   |
| `\%$`   | End of file         |
| `\C`    | Case-sensitive      |
| `\c`    | Case-insensitive    |

#### **Global Command**

```vim
:g/^#/d            " Hapus semua komentar
:g/^\s*$/d         " Hapus baris kosong
:g/pattern/norm @a " Jalankan macro pada baris matching
```

### **9. Advanced Window Management**

#### **Window Layouts**

```vim
:windo set wrap    " Terapkan ke semua window
:argdo %s/old/new/ " Operasi pada semua buffer
```

#### **Window Creation**

| Command             | Deskripsi                         |
| ------------------- | --------------------------------- |
| `:new +300vsp file` | Buka file dengan lebar 300 kolom  |
| `:sbuffer N`        | Buka buffer N di split horizontal |
| `:vert sbuffer N`   | Buka buffer N di split vertikal   |

### **10. Vimscript ↔ Lua Interop**

#### **Conversion Table**

| Vimscript           | Lua Equivalent                     |
| ------------------- | ---------------------------------- |
| `set number`        | `vim.opt.number = true`            |
| `let mapleader=" "` | `vim.g.mapleader = " "`            |
| `nnoremap x y`      | `vim.keymap.set('n', 'x', 'y')`    |
| `autocmd ...`       | `vim.api.nvim_create_autocmd(...)` |

#### **API Bridges**

```lua
-- Akses Vimscript dari Lua
vim.api.nvim_eval('expand("%:p")')

-- Akses Lua dari Vimscript
:lua print(vim.inspect(vim.api.nvim_list_wins()))
```

### **11. Security Features**

#### **Sandboxing**

```vim
:set secure         " Disable unsafe commands
:set nomodeline     " Disable modeline parsing
```

#### **Restricted Mode**

```bash
nvim -Z             # Mode terbatas (no shell commands)
```

### **12. Advanced Debugging**

#### **Lua Debugger**

```lua
-- Gunakan MobDebug
require('mobdebug').start()
```

#### **Vimscript Profiling**

```vim
:profile start profile.log
:profile func *
:profile file *
" Jalankan operasi
:profile pause
```

### **13. Cross-Platform Considerations**

#### **Windows Specific**

```vim
" Path handling
set shell=pwsh
set shellcmdflag=-c
set shellquote=\"
set shellxquote=
```

#### **WSL Integration**

```bash
# Buka file WSL dari Windows
nvim.exe $(wslpath -w ~/.config/nvim/init.lua)
```

---

## **Tambahan Kamus Shortcut**

### **Core Shortcuts yang Terlewat**

| Mode    | Shortcut     | Deskripsi                       |
| ------- | ------------ | ------------------------------- |
| Normal  | `gq{motion}` | Format teks                     |
| Normal  | `gqq`        | Format baris saat ini           |
| Normal  | `gf`         | Buka file di bawah kursor       |
| Normal  | `ga`         | Tampilkan info karakter Unicode |
| Normal  | `gCtrl-g`    | Tampilkan info dokumen          |
| Normal  | `Ctrl-^`     | Beralih ke buffer alternatif    |
| Insert  | `Ctrl-r "`   | Tempel dari register            |
| Command | `:make`      | Jalankan Makefile               |
| Visual  | `gq`         | Format seleksi                  |

### **Advanced Text Objects**

| Shortcut | Deskripsi                  |
| -------- | -------------------------- |
| `iL`     | Inner line (tanpa newline) |
| `aL`     | A line (dengan newline)    |
| `iC`     | Inner class (OOP)          |
| `aC`     | A class (OOP)              |
| `iM`     | Inner method (OOP)         |
| `aM`     | A method (OOP)             |

### **Advanced Registers**

| Register | Deskripsi             |
| -------- | --------------------- |
| `"%`     | Nama file saat ini    |
| `"#`     | Nama file alternatif  |
| `".`     | Terakhir dimasukkan   |
| `":`     | Terakhir command-line |
| `"/`     | Terakhir pencarian    |
| `"=`     | Expression register   |

---

## **Lampiran: Best Practices**

1. **Version Control**:
   ```bash
   ln -s ~/.config/nvim ~/dotfiles/nvim
   ```
2. **Backup Strategy**:

   ```lua
   vim.opt.backupdir = os.getenv('HOME') .. '/.nvim/backup//'
   vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undo//'
   ```

3. **Secure Configuration**:

   ```lua
   vim.opt.modeline = false
   vim.opt.secure = true
   ```

4. **Performance Checklist**:
   - Gunakan `:LuaCacheGen` setelah perubahan konfig
   - Hindari blocking calls di Lua
   - Gunakan `vim.schedule` untuk operasi async

Saat ini, dokumentasi mungkin sudah menjadi lebih komprehensif mencakup 100% fitur inti Neovim dan praktik tingkat lanjut. Untuk referensi lengkap, selalu gunakan `:help` di dalam Neovim.
