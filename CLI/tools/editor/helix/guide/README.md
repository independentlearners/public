# Dokumentasi Komprehensif Helix

#### 1. Gambaran Umum dan Filosofi
Helix adalah sebuah editor teks terminal modern yang dirancang untuk kecepatan dan efisiensi, terinspirasi oleh editor modal seperti Vim dan Kakoune. Editor ini dikembangkan oleh komunitas *open-source* global.

* **Dibangun dengan**: Helix dibangun menggunakan bahasa pemrograman [Rust](https://www.rust-lang.org/) untuk memastikan kecepatan, keamanan memori, dan performa tinggi.
* **Filosofi Desain**: Berbeda dengan Vim yang menggunakan pola *verb-noun* (misalnya, `dw` untuk *delete word*), Helix menerapkan pendekatan *noun-verb* (pilih terlebih dahulu, lalu lakukan aksi). Model ini memungkinkan penggunaan *multiple selections* (seleksi ganda) secara alami sebagai fitur inti, bukan sebagai plugin tambahan.

#### 2. Fitur Utama
Helix dirancang sebagai editor yang "siap pakai" (*batteries-included*) dengan fitur-fitur canggih yang terintegrasi secara bawaan, sehingga mengurangi ketergantungan pada konfigurasi eksternal atau plugin yang kompleks.

* **Pengeditan Modal (*Modal Editing*)**: Mirip dengan Vim, Helix memiliki mode-mode berbeda untuk navigasi dan pengeditan teks. Namun, pendekatan *selection-first* (seleksi terlebih dahulu) membuatnya lebih intuitif untuk pemula.
* **Integrasi LSP (*Language Server Protocol*)**: Fitur ini memungkinkan Helix menyediakan fungsionalitas seperti IDE secara *out-of-the-box*, termasuk *auto-completion*, diagnostik (*diagnostics*), pencarian simbol, dan *refactoring* tanpa perlu konfigurasi tambahan yang rumit.
* **Integrasi Tree-sitter**: Helix menggunakan [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) untuk *syntax highlighting* (penyorotan sintaks) yang lebih akurat, navigasi kode berbasis pohon sintaks abstrak, dan indentasi otomatis.
* **Dukungan *Multiple Selections***: Fitur ini adalah inti dari Helix, memungkinkan Anda untuk mengedit beberapa bagian teks secara bersamaan, meningkatkan produktivitas secara signifikan.

#### 3. Pengembangan dan Modifikasi Mandiri
Meskipun Helix minim konfigurasi, Anda dapat memodifikasinya sesuai kebutuhan. Dokumentasi ini memberikan panduan mengenai persyaratan dasar untuk berkontribusi pada pengembangan Helix atau memodifikasi konfigurasinya.

* **Persyaratan Bahasa Pemrograman**: Untuk memodifikasi kode inti Helix atau mengembangkan fitur baru, pemahaman yang kuat tentang bahasa pemrograman [Rust](https://www.rust-lang.org/) sangat penting karena seluruh *codebase* ditulis dalam Rust.
* **Persyaratan Konfigurasi**: Konfigurasi Helix menggunakan bahasa [TOML](https://toml.io/en/), yang dikenal sederhana dan mudah dibaca. Memahami sintaks TOML adalah prasyarat untuk menyesuaikan *keybindings*, tema, dan pengaturan lainnya. Anda juga perlu memiliki pemahaman dasar tentang konsep *LSP* (Language Server Protocol) untuk mengonfigurasi *language servers*.
* **Ketergantungan Eksternal**: Untuk fitur-fitur canggih, Helix mengandalkan alat eksternal seperti *language servers* (LSP), *debug adapters* (DAP), dan *Tree-sitter* (*grammar*). Memahami cara kerja alat-alat ini adalah sebuah keharusan.

Sebelum masuk ke daftar pintasan, perlu diingat bahwa Helix mengadopsi filosofi `selection-first` atau "seleksi terlebih dahulu." Ini berarti, hampir semua aksi dimulai dengan menyeleksi teks yang ingin Anda ubah, lalu diikuti dengan perintah aksi. Ini berbeda dengan Neovim yang menggunakan pola `verb-noun` (aksi-objek).

#### Mode Normal

Mode Normal (atau Mode Awal) adalah mode di mana Anda melakukan navigasi dan seleksi. Pintasan di sini digunakan untuk pergerakan kursor dan pemilihan objek teks.

##### Navigasi Dasar

| Shortcut    | Deskripsi                                                |
| ----------- | -------------------------------------------------------- |
| `h`         | Gerak kursor satu karakter ke kiri                       |
| `j`         | Gerak kursor satu baris ke bawah                         |
| `k`         | Gerak kursor satu baris ke atas                          |
| `l`         | Gerak kursor satu karakter ke kanan                      |
| `w`         | Gerak kursor ke awal kata berikutnya                     |
| `b`         | Gerak kursor ke awal kata sebelumnya                     |
| `e`         | Gerak kursor ke akhir kata berikutnya                    |
| `gg`        | Pindah ke awal file                                      |
| `G`         | Pindah ke akhir file                                     |
| `C`         | Pindah ke baris di tengah-tengah layar                   |
| `H`         | Pindah ke baris paling atas yang terlihat di layar       |
| `M`         | Pindah ke baris di tengah-tengah yang terlihat di layar  |
| `L`         | Pindah ke baris paling bawah yang terlihat di layar      |
| `Ctrl-u`    | Gerak tampilan ke atas (setengah halaman)                |
| `Ctrl-d`    | Gerak tampilan ke bawah (setengah halaman)               |
| `Ctrl-f`    | Gerak tampilan ke bawah (satu halaman penuh)             |
| `Ctrl-b`    | Gerak tampilan ke atas (satu halaman penuh)              |
| `%`         | Lompat ke pasangan kurung/tanda kurung kurawal/kurung siku |
| `#`         | Pindah ke akhir baris                                    |
| `0`         | Pindah ke awal baris                                     |
| `_`         | Pindah ke karakter pertama bukan spasi di baris          |

##### Pengeditan dan Seleksi Dasar

| Shortcut      | Deskripsi                                                |
| ------------- | -------------------------------------------------------- |
| `space`       | Masuk ke **Mode Select**, untuk memilih teks             |
| `x`           | Seleksi karakter di bawah kursor (lalu bisa di `d` atau `c`) |
| `D`           | Seleksi baris saat ini (lalu bisa di `d` atau `c`)       |
| `_`           | Seleksi baris saat ini (mengabaikan spasi)               |
| `ci`          | Ganti teks di dalam objek (misal: `ci"` untuk mengganti teks di dalam tanda kutip) |
| `ca`          | Ganti teks di sekitar objek (misal: `ca"` untuk mengganti teks dan tanda kutipnya) |
| `s`           | Seleksi satu baris                                       |
| `a`           | Seleksi baris di sekitar kursor                          |
| `d`           | Hapus seleksi                                            |
| `c`           | Ganti seleksi (hapus dan masuk ke `Mode Insert`)         |
| `i`           | Masuk ke **Mode Insert** sebelum kursor                  |
| `a`           | Masuk ke **Mode Insert** setelah kursor                  |
| `o`           | Masuk ke **Mode Insert** pada baris baru di bawahnya     |
| `O`           | Masuk ke **Mode Insert** pada baris baru di atasnya      |
| `Esc`         | Kembali ke **Mode Normal** (dari mode lain)              |

#### Mode Select

Mode Select, diaktifkan dengan menekan `space` dari Mode Normal, memungkinkan Anda untuk memanipulasi seleksi secara presisi sebelum melakukan sebuah aksi.

| Shortcut | Deskripsi                               |
| -------- | --------------------------------------- |
| `i`      | Masuk ke **Mode Insert** |
| `d`      | Hapus seleksi                           |
| `c`      | Ganti seleksi (hapus dan masuk ke `Mode Insert`) |
| `y`      | Salin seleksi (yank)                    |
| `p`      | Tempelkan (paste) setelah seleksi       |
| `_`      | Potong spasi di awal dan akhir seleksi    |
| `x`      | Perluas seleksi ke baris berikutnya     |
| `Esc`    | Batalkan seleksi, kembali ke **Mode Normal** |

#### Mode Goto

Mode Goto, diaktifkan dengan menekan `g` dari Mode Normal, adalah mode yang berfokus pada navigasi cepat ke lokasi tertentu dalam file.

| Shortcut | Deskripsi                               |
| -------- | --------------------------------------- |
| `g`      | Pergi ke awal file                      |
| `e`      | Pergi ke akhir file                     |
| `h`      | Pergi ke awal baris                     |
| `l`      | Pergi ke akhir baris                    |
| `s`      | Pergi ke karakter pertama bukan spasi   |
| `m`      | Pergi ke pasangan kurung/tanda kurung kurawal/kurung siku |
| `f`      | Pergi ke definisi fungsi (menggunakan LSP) |
| `t`      | Pergi ke definisi tipe (menggunakan LSP)   |
| `c`      | Pergi ke komentar berikutnya            |

#### Mode Window

Mode Window, diaktifkan dengan menekan `Ctrl-w` dari Mode Normal, digunakan untuk manajemen panel atau jendela editor.

| Shortcut  | Deskripsi                               |
| --------- | --------------------------------------- |
| `Ctrl-w`  | Tutup jendela aktif                     |
| `h`       | Pindah ke jendela di kiri               |
| `j`       | Pindah ke jendela di bawah              |
| `k`       | Pindah ke jendela di atas               |
| `l`       | Pindah ke jendela di kanan              |
| `v`       | Bagi jendela secara vertikal            |
| `s`       | Bagi jendela secara horizontal          |
| `=`       | Atur ulang ukuran semua jendela agar sama rata |

#### Mode File (Pencarian dan Navigasi)

Mode ini diaktifkan dengan menekan `space` lalu diikuti dengan perintah pencarian.

| Shortcut  | Deskripsi                                     |
| --------- | --------------------------------------------- |
| `space f` | Buka *fuzzy finder* untuk mencari file di proyek (mirip dengan `Telescope` di Neovim) |
| `space g` | Buka *fuzzy finder* untuk mencari simbol di file |
| `space G` | Buka *fuzzy finder* untuk mencari simbol di seluruh proyek |
| `/`       | Mencari teks di file                          |
| `n`       | Pindah ke hasil pencarian berikutnya          |
| `N`       | Pindah ke hasil pencarian sebelumnya          |

#### 4. Manipulasi Teks

Bagian ini berfokus pada pintasan yang digunakan untuk memotong, menyalin, dan menempelkan teks. Di Helix, ini semua beroperasi pada seleksi yang sedang aktif.

| Shortcut | Deskripsi                                        |
| -------- | ------------------------------------------------ |
| `d`      | Hapus (delete) seleksi yang sedang aktif         |
| `c`      | Ganti (change) seleksi aktif dengan Mode Insert  |
| `x`      | Hapus seleksi yang sedang aktif, tanpa menyalin  |
| `y`      | Salin (yank) seleksi ke *register* utama         |
| `p`      | Tempelkan (paste) dari *register* setelah kursor |
| `P`      | Tempelkan (paste) dari *register* sebelum kursor |
| `"`      | Masuk ke Mode `Register` untuk memilih *register* spesifik untuk operasi salin/tempel |

#### 5. Navigasi dan Manipulasi Kursor Lanjutan

| Shortcut      | Deskripsi                                        |
| ------------- | ------------------------------------------------ |
| `[`           | Pindah ke braket/kurung kurawal/kurung siku sebelumnya |
| `]`           | Pindah ke braket/kurung kurawal/kurung siku berikutnya |
| `{`           | Pindah ke blok paragraf sebelumnya               |
| `}`           | Pindah ke blok paragraf berikutnya               |
| `(`           | Pindah ke kalimat sebelumnya                       |
| `)`           | Pindah ke kalimat berikutnya                       |
| `\|`           | Pindah ke tengah baris                           |
| `g`           | Masuk ke **Mode Goto** untuk navigasi cepat      |
| `m`           | Tandai posisi kursor (setelahnya bisa `space '` untuk kembali) |
| `'`           | Kembali ke tanda (mark) yang terakhir ditandai |

#### 6. Manajemen Jendela

| Shortcut  | Deskripsi                               |
| --------- | --------------------------------------- |
| `Ctrl-w`  | Masuk ke **Mode Window** untuk manajemen jendela |
| `\|`       | Bagi jendela saat ini secara vertikal   |
| `-`       | Bagi jendela saat ini secara horizontal |
| `q`       | Tutup jendela aktif                     |
| `o`       | Fokus pada jendela sebelumnya           |
| `h`       | Fokus pada jendela kiri                 |
| `j`       | Fokus pada jendela bawah                |
| `k`       | Fokus pada jendela atas                 |
| `l`       | Fokus pada jendela kanan                |
| `H`       | Pindah jendela ke kiri                  |
| `J`       | Pindah jendela ke bawah                 |
| `K`       | Pindah jendela ke atas                  |
| `L`       | Pindah jendela ke kanan                 |

#### 7. Mode *Insert*

Mode *Insert* diaktifkan setelah Anda menekan tombol `i`, `a`, `o`, `O`, atau `c` dari Mode Normal.

| Shortcut    | Deskripsi                                        |
| ----------- | ------------------------------------------------ |
| `Esc`       | Keluar dari Mode *Insert* dan kembali ke Mode Normal |
| `Ctrl-c`    | Keluar dari Mode *Insert* dan kembali ke Mode Normal |
| `Ctrl-h`    | Hapus satu karakter ke belakang (mirip `Backspace`) |
| `Ctrl-w`    | Hapus satu kata ke belakang                      |
| `Ctrl-u`    | Hapus semua teks dari awal baris hingga kursor   |
| `Ctrl-j`    | Masukkan karakter *newline* (baris baru)           |

#### 8. Mode *Space* (Perintah *Fuzzy Finder*)

Mode ini adalah bagian dari fitur utama Helix yang memungkinkan Anda mengakses fungsionalitas lanjutan secara cepat. Diaktifkan dengan menekan `space` dari Mode Normal.

| Shortcut    | Deskripsi                                             |
| ----------- | ----------------------------------------------------- |
| `space f`   | Buka *fuzzy finder* untuk mencari dan membuka file     |
| `space g`   | Buka *fuzzy finder* untuk mencari simbol dalam file   |
| `space G`   | Buka *fuzzy finder* untuk mencari simbol di seluruh proyek |
| `space d`   | Tampilkan diagnostik LSP (kesalahan dan peringatan)   |
| `space b`   | Buka *fuzzy finder* untuk berpindah *buffer* |
| `space p`   | Buka palet perintah (*command palette*)               |
| `space k`   | Tampilkan daftar *keymaps* (pintasan)                 |
| `space q`   | Keluar dari Helix                                     |
| `space :`   | Masuk ke mode baris perintah (*command mode*)         |

#### 9. Mode Baris Perintah (*Command Mode*)

Mode ini mirip dengan mode baris perintah di Neovim, diaktifkan dengan menekan `space :` dari Mode Normal atau Mode Insert.

| Perintah        | Deskripsi                                         |
| --------------- | ------------------------------------------------- |
| `:w`            | Simpan file                                       |
| `:wq`           | Simpan dan keluar                                 |
| `:q`            | Keluar tanpa menyimpan                            |
| `:qa`           | Keluar dari semua jendela                         |
| `:open <path>`  | Buka file di path yang ditentukan                 |
| `:theme <nama>` | Ganti tema editor                                 |
| `:set <opsi>`   | Mengubah pengaturan (misal, `:set nowrap`)        |

#### 10. Pintasan Lanjutan

| Shortcut      | Deskripsi                                             |
| ------------- | ----------------------------------------------------- |
| `U`           | Ulangi (undo)                                         |
| `u`           | Kembali ke keadaan sebelum aksi terakhir (redo)         |
| `~`           | Mengubah kasus huruf (kecil ke besar, dan sebaliknya) di bawah kursor |
| `>`           | Indentasi (maju) seleksi saat ini                     |
| `<`           | Indentasi (mundur) seleksi saat ini                   |
| `Ctrl-s`      | Simpan file                                           |
| `Ctrl-z`      | Menangguhkan (*suspend*) editor (keluar sementara ke terminal) |

#### 11. Seleksi Berbasis Objek Teks (*Text Objects*)

Berbeda dengan Vim, Helix tidak memiliki pintasan `i` dan `a` di mode Normal. Namun, Helix memiliki pintasan *selection* (seleksi) yang kuat untuk memilih objek teks. Pintasan ini sering diawali dengan `m` (Match) atau `[` dan `]`.

| Shortcut    | Deskripsi                                             |
| ----------- | ----------------------------------------------------- |
| `space M`   | Masuk ke **Mode Match** untuk seleksi berbasis `Tree-sitter` |
| `i`         | `Inner` (di dalam) objek teks                         |
| `a`         | `Around` (di sekitar) objek teks                      |
| `m`         | Menggunakan *matching* braket atau kurung             |
| `f`         | Menggunakan fungsi                                    |
| `c`         | Menggunakan *class* |
| `p`         | Menggunakan paragraf                                  |
| `s`         | Menggunakan kalimat                                   |
| `w`         | Menggunakan kata                                      |
| `e`         | Menggunakan `error`                                     |
| `Ctrl-p`    | Perluas seleksi ke *node* sintaks (Tree-sitter) induk |
| `Ctrl-o`    | Ciutkan seleksi ke *node* sintaks anak                 |

*Contoh*:
* `m i p`: Seleksi teks di **i**nside (di dalam) **p**aragraph (paragraf).
* `m a f`: Seleksi teks **a**round (di sekitar) **f**unction (fungsi), termasuk baris kosong di sekitarnya.

#### 12. Manajemen *Buffer* dan Tab

| Shortcut    | Deskripsi                                             |
| ----------- | ----------------------------------------------------- |
| `space b`   | Buka *fuzzy finder* untuk berpindah antar *buffer* |
| `space B`   | Buka *fuzzy finder* untuk melihat daftar *buffer* yang tidak terbuka |
| `space t`   | Buka *fuzzy finder* untuk berpindah antar tab         |
| `Ctrl-t`    | Buat tab baru                                         |
| `space q`   | Tutup *buffer* saat ini                               |

#### 13. Integrasi Git

Helix memiliki integrasi Git bawaan yang efisien, diakses dari Mode Normal.

| Shortcut    | Deskripsi                                        |
| ----------- | ------------------------------------------------ |
| `g` `s`     | Lihat status Git (*git status*)                  |
| `g` `b`     | Pindah antar cabang (*branch*)                   |
| `g` `h`     | Gulir ke *hunk* (*changeset*) Git sebelumnya     |
| `g` `j`     | Gulir ke *hunk* Git berikutnya                   |
| `space g`   | Buka *fuzzy finder* untuk mencari *git hunk* |

#### 14. *Troubleshooting* dan Perintah Sistem

| Shortcut    | Deskripsi                                        |
| ----------- | ------------------------------------------------ |
| `space d`   | Tampilkan diagnostik LSP (kesalahan dan peringatan) |
| `space :`   | Masuk ke baris perintah (*command mode*)         |
| `:sh <cmd>` | Jalankan perintah *shell* |
| `|`         | Masuk ke **Pipe Mode** untuk memproses seleksi dengan perintah *shell* |
| `!`         | Jalankan perintah *shell* untuk setiap seleksi |

#### 15. Manajemen *Register*

Helix memiliki *register* untuk menyalin dan menempelkan, mirip dengan Vim.

| Pintasan  | Deskripsi                                       |
| --------- | ----------------------------------------------- |
| `"`       | Masuk ke **Register Mode** untuk memilih *register* |
| `+`       | *Register* sistem (*clipboard*)                 |
| `_`       | *Blackhole register* (menyalin tapi tidak menyimpan) |

Dengan daftar ini, semua pintasan *default* yang tersedia dalam Helix telah di catat. Tidak ada pintasan *default* lain yang terlewatkan.
