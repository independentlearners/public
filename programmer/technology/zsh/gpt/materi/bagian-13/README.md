# Lesson 12 — History di Zsh

History adalah mekanisme Zsh untuk menyimpan dan mengelola perintah yang pernah dijalankan. Untuk konfigurasi shell interaktif, history bukan sekadar daftar perintah: perilakunya dapat diatur melalui variabel dan opsi Zsh.

Materi ini berfokus pada empat hal: lokasi penyimpanan, batas jumlah entri, opsi history, dan berbagi riwayat antar-sesi terminal.

## 1. Tiga variabel utama

| Variabel   | Fungsi                                                |
| ---------- | ----------------------------------------------------- |
| `HISTFILE` | Lokasi file untuk menyimpan riwayat perintah.         |
| `HISTSIZE` | Jumlah entri yang disimpan dalam history aktif shell. |
| `SAVEHIST` | Jumlah entri history yang disimpan ke file.           |

Contoh konfigurasi:

```
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
```

Cara kerjanya:

- `HISTFILE` menentukan file riwayat, dalam contoh ini `~/.zsh_history`.
- `HISTSIZE` menentukan kapasitas history yang tersedia selama sesi shell.
- `SAVEHIST` menentukan jumlah entri yang dipertahankan dalam penyimpanan history.

Nilai `HISTSIZE` dan `SAVEHIST` tidak harus sama. Jika kapasitas aktif lebih besar daripada jumlah yang disimpan, sebagian entri aktif mungkin tidak dipertahankan ke file setelah sesi berakhir.

## 2. Mengatur opsi history

Zsh menyediakan opsi bawaan yang mengubah cara entri history dicatat dan disimpan.

Contoh:

```
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
```

- `HIST_IGNORE_DUPS` mengabaikan perintah yang sama dengan entri sebelumnya sesuai aturan opsi ini.
- `HIST_IGNORE_SPACE` mengabaikan perintah yang diawali spasi.
- `APPEND_HISTORY` menambahkan entri ke file history, alih-alih sekadar menulis ulang file dengan pendekatan standar opsi tersebut.

Perhatikan bahwa `HIST_IGNORE_SPACE` bukan mekanisme keamanan. Perintah yang tidak dicatat dalam history tetap dapat muncul di log lain, tercatat oleh program eksternal, atau terlihat dalam proses yang sedang berjalan.

## 3. Berbagi history antar-sesi

Jika Anda membuka beberapa terminal Zsh, setiap terminal dapat memiliki sesi history sendiri. Opsi berikut mengubah cara sesi-sesi itu berbagi riwayat.

```
setopt SHARE_HISTORY
```

`SHARE_HISTORY` memungkinkan sesi Zsh membaca entri baru dari file history dan menambahkan perintah baru ke penyimpanan tersebut. Ini berguna ketika Anda bekerja di beberapa terminal sekaligus.

Opsi terkait lainnya:

```
setopt INC_APPEND_HISTORY
```

Opsi ini menambahkan perintah ke file history saat perintah selesai, tanpa harus menunggu shell keluar.

Jangan mengaktifkan semua opsi history secara acak. Tentukan perilaku yang diinginkan terlebih dahulu. Untuk konfigurasi awal, Anda dapat memilih `SHARE_HISTORY` atau menggunakan `INC_APPEND_HISTORY` jika hanya membutuhkan penambahan entri secara bertahap.

## 4. Membaca history

Gunakan perintah berikut untuk melihat riwayat perintah:

```
fc -l -10
```

Ini menampilkan sepuluh entri history terakhir beserta nomor entri. Anda juga dapat menggunakan:

```
history
```

History juga mendukung ekspansi perintah:

```
!!
```

`!!` merujuk ke perintah sebelumnya. Ekspansi history dapat mempercepat pekerjaan, tetapi periksa hasil ekspansinya sebelum menjalankan ulang perintah yang berisiko, khususnya perintah yang menghapus atau mengubah file.

## 5. Menempatkan pengaturan dalam konfigurasi modular

Karena konfigurasi Anda menggunakan struktur modular, pengaturan history dapat ditempatkan dalam `~/.config/zsh/history.zsh`:

```
# Lokasi dan kapasitas history.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Mengatur perilaku penyimpanan history.
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
```

Pastikan file ini dimuat dari `zshrc`:

```
if [[ -r "$HOME/.config/zsh/history.zsh" ]]; then
    source "$HOME/.config/zsh/history.zsh"
fi
```

`source` menjalankan isi file dalam shell saat ini, sehingga variabel dan opsi yang ditetapkan dapat memengaruhi sesi interaktif tersebut.

## 6. Memeriksa konfigurasi

Setelah memuat pengaturan, periksa nilainya:

```
print -r -- "$HISTFILE"
print -r -- "$HISTSIZE"
print -r -- "$SAVEHIST"

[[ -o HIST_IGNORE_DUPS ]] && print -r -- "HIST_IGNORE_DUPS aktif"
[[ -o HIST_IGNORE_SPACE ]] && print -r -- "HIST_IGNORE_SPACE aktif"
[[ -o SHARE_HISTORY ]] && print -r -- "SHARE_HISTORY aktif"
```

Jika ingin menguji perubahan konfigurasi, buka terminal Zsh baru atau muat ulang konfigurasi dengan `source ~/.config/zsh/zshrc` jika file tersebut memang merupakan konfigurasi utama Anda. Perhatikan bahwa pemuatan ulang dapat mengulangi efek samping konfigurasi lain.

## Inti pelajaran

- `HISTFILE`, `HISTSIZE`, dan `SAVEHIST` mengatur lokasi serta kapasitas history.
- `setopt` mengubah perilaku pencatatan dan penyimpanan riwayat.
- `SHARE_HISTORY` berguna ketika beberapa terminal Zsh digunakan bersamaan.
- History tidak boleh dianggap sebagai penyimpanan rahasia atau mekanisme keamanan.

Materi selanjutnya: Lesson 13 — Prompt Zsh, membahas variabel `PROMPT`/`RPROMPT`, escape sequence prompt Zsh, dan bagaimana prompt dapat dikembangkan sebelum mempelajari integrasi prompt yang lebih kompleks.


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md

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

