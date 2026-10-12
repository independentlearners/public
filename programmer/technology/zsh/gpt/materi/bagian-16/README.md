# Lesson 15 — ZLE (Zsh Line Editor)

ZLE adalah singkatan dari Zsh Line Editor. Ini adalah komponen Zsh yang mengelola baris perintah yang sedang Anda edit sebelum dikirim untuk dieksekusi.

ZLE merupakan fondasi penting untuk tujuan Anda: membuat fitur keyboard sendiri, memodifikasi input perintah, dan memahami cara kerja plugin produktivitas Zsh.

## 1. Memahami posisi ZLE

Saat Anda mengetik perintah di terminal, alurnya secara sederhana seperti ini:

```
Keyboard
│
└─▶ Karakter dan tombol yang ditekan
     │
     ├─▶ [SEBELUM Enter] ZLE
     │      │
     │      └─▶ Mengedit baris, memindahkan kursor, menjalankan widget
     │
     └─▶ [SESUDAH Enter] Zsh memproses perintah
            │
            └─▶ Setelah Anda menekan EnterContohnya, ketika Anda mengetik:


```
```
print -r -- "Halo"
```

ZLE mengelola teks tersebut ketika Anda mengetik, menghapus karakter, memindahkan kursor, atau mengedit argumen. Setelah Anda menekan Enter, Zsh memproses baris perintah itu.

Artinya, ZLE mengelola proses penyuntingan input interaktif, bukan menggantikan interpreter Zsh.

## 2. Widget: fungsi yang dapat dijalankan melalui ZLE

ZLE menyediakan widget, yaitu operasi yang dapat dipanggil untuk melakukan tindakan pada editor baris perintah.

Beberapa contoh widget bawaan:

- `backward-char` — memindahkan kursor ke kiri.
- `forward-char` — memindahkan kursor ke kanan.
- `backward-delete-char` — menghapus karakter sebelum kursor.
- `accept-line` — menerima baris perintah, biasanya ketika Enter ditekan.
- `clear-screen` — membersihkan tampilan layar terminal.

Anda dapat memeriksa binding tombol yang tersedia:

```
bindkey
```

Untuk memeriksa binding tombol tertentu, misalnya Ctrl+A:

```
bindkey '^A'
```

Hasilnya bergantung pada keymap aktif dan konfigurasi Anda.

## 3. Keymap dan `bindkey`

Keymap adalah kumpulan pemetaan antara input keyboard dan widget. Zsh dapat memiliki keymap berbeda untuk perilaku seperti mode emacs dan vi.

Karena konfigurasi Anda menggunakan vi mode, periksa keymap yang tersedia:

```
bindkey -l
```

Kemudian periksa keymap aktif:

```
bindkey -L
```

Untuk melihat pemetaan dalam keymap vi insert, Anda dapat mencoba:

```
bindkey -M viins
```

Jika keymap `viins` tersedia, perintah tersebut menampilkan binding yang terkait dengan mode insert vi.

Pemetaan tombol dapat diubah dengan `bindkey`. Misalnya, binding berikut menghubungkan Ctrl+X dengan widget `clear-screen` pada keymap saat ini:

```
bindkey '^X' clear-screen
```

Gunakan contoh tersebut hanya untuk percobaan. Binding Ctrl+X yang sudah ada bisa tertimpa, sehingga sebaiknya periksa binding lama sebelum mengubah konfigurasi permanen.

## 4. Membuat widget ZLE sendiri

Sekarang kita membuat fitur sederhana. Ketika Anda menekan Ctrl+G, ZLE akan mengganti isi baris perintah dengan teks yang telah ditentukan.

```
zsh_lesson_widget() {
    BUFFER='print -r -- "Halo dari ZLE"'
    CURSOR=${#BUFFER}
}

zle -N zsh_lesson_widget
bindkey '^G' zsh_lesson_widget
```

Jalankan kode tersebut di terminal Zsh interaktif.

Cara kerjanya:

1. `zsh_lesson_widget()` mendefinisikan fungsi shell.
2. `BUFFER` adalah parameter khusus ZLE yang berisi teks baris perintah yang sedang diedit.
3. `CURSOR` menentukan posisi kursor di dalam buffer. `${#BUFFER}` menempatkannya di akhir teks.
4. `zle -N zsh_lesson_widget` mendaftarkan fungsi sebagai widget ZLE.
5. `bindkey '^G' zsh_lesson_widget` menghubungkan Ctrl+G dengan widget pada keymap saat ini.

Setelah kode dimuat, tekan Ctrl+G saat prompt siap menerima input. Teks perintah akan muncul di baris input, tetapi tidak langsung dijalankan. Tekan Enter jika ingin mengeksekusinya.

Karena Anda menggunakan vi mode, binding juga dapat dipasang secara khusus pada keymap insert:

```
bindkey -M viins '^G' zsh_lesson_widget
```

Periksa binding Ctrl+G yang sudah ada sebelum menggunakannya agar tidak menimpa fungsi tombol yang masih Anda perlukan.

## 5. Memahami `BUFFER`, `LBUFFER`, `RBUFFER`, dan `CURSOR`

Keempat parameter ini penting saat membuat widget yang memodifikasi command line.

| Parameter | Fungsi                                               |
| --------- | ---------------------------------------------------- |
| `BUFFER`  | Seluruh teks pada baris perintah yang sedang diedit. |
| `LBUFFER` | Bagian teks di sebelah kiri kursor.                  |
| `RBUFFER` | Bagian teks di sebelah kanan kursor.                 |
| `CURSOR`  | Posisi kursor di dalam buffer.                       |

Misalnya, jika baris input berisi `git commit` dan kursor berada di antara `git` dan `commit`, `LBUFFER` berisi teks di sebelah kiri kursor, sedangkan `RBUFFER` berisi teks di sebelah kanannya.

Ini memungkinkan Anda membuat fitur seperti menyisipkan teks pada posisi kursor, membungkus teks dengan karakter tertentu, atau memodifikasi sebagian input tanpa mengganti seluruh baris.

Contoh widget yang menambahkan awalan ke input:

```
zsh_prefix_widget() {
    LBUFFER='sudo ' 
}

zle -N zsh_prefix_widget
bindkey '^X^S' zsh_prefix_widget
```

Ketika dipanggil, widget menambahkan `sudo ` di sebelah kiri kursor. Contoh ini hanya untuk demonstrasi; jangan gunakan secara membabi buta pada perintah yang tidak seharusnya dijalankan dengan hak akses lebih tinggi.

## 6. Menempatkan widget dalam konfigurasi modular

Jika widget sudah diuji dan ingin dipertahankan, simpan definisinya dalam file, misalnya:

```
~/.config/zsh/
├── zshrc
└── keybinds.zsh
```

Contoh isi `keybinds.zsh`:

```
zsh_lesson_widget() {
    BUFFER='print -r -- "Halo dari ZLE"'
    CURSOR=${#BUFFER}
}

zle -N zsh_lesson_widget
bindkey -M viins '^G' zsh_lesson_widget
```

Muat file tersebut dari `zshrc` setelah konfigurasi vi mode diaktifkan:

```
if [[ -r "$HOME/.config/zsh/keybinds.zsh" ]]; then
    source "$HOME/.config/zsh/keybinds.zsh"
fi
```

Pemisahan ini membuat definisi widget dan binding keyboard lebih mudah dipelihara daripada mencampurkannya dengan history, prompt, atau pengaturan environment.

## Inti pelajaran

- ZLE mengelola penyuntingan baris perintah interaktif.
- Widget adalah operasi yang dapat dijalankan oleh ZLE.
- Keymap menentukan kumpulan binding tombol yang berlaku.
- `bindkey` menghubungkan input keyboard dengan widget.
- `BUFFER`, `LBUFFER`, `RBUFFER`, dan `CURSOR` memungkinkan widget memanipulasi teks yang sedang diedit.

# Lesson 15 — Hooks di Zsh (Lanjutan)

Hooks memungkinkan Zsh menjalankan fungsi secara otomatis ketika peristiwa tertentu terjadi. Ini merupakan salah satu fondasi penting untuk membangun automation pada interactive shell tanpa harus memanggil fungsi secara manual setiap kali.

#### Versi tree
```
Mental model
└── Event
    ├── Contoh: perintah akan dijalankan
    └── Hook
        ├── Titik pemicu yang disediakan Zsh
        └── Function
            ├── Kode yang didaftarkan untuk event tersebut
            └── Action
```

#### Versi alur

```
Event ──▶ Hook ──▶ Function ──▶ Action
  │         │          │
  │         │          └─ Kode yang didaftarkan untuk event tersebut
  │         │
  │         └─ Titik pemicu yang disediakan Zsh
  │
  └─ Contoh: perintah akan dijalankan
```
Contoh: mencatat aktivitas atau memperbarui status

## 1. Mengapa hooks diperlukan?

Tanpa hooks, Anda biasanya harus memanggil fungsi secara eksplisit:

```
update_status
```

Dengan hooks, Anda dapat meminta Zsh memanggil fungsi tersebut pada waktu tertentu, misalnya setiap kali prompt akan ditampilkan.

Perbedaan mendasarnya:

- Function biasa: dijalankan ketika dipanggil.
- Hook: fungsi yang didaftarkan agar dipanggil oleh mekanisme event Zsh.
- Action: pekerjaan yang dilakukan fungsi tersebut ketika hook berjalan.

Hooks bukan daemon atau proses latar belakang. Sebagian besar hooks yang akan kita pelajari berjalan sebagai bagian dari aktivitas shell itu sendiri.

## 2. Hook yang penting untuk interactive Zsh

Zsh menyediakan beberapa hook dengan tujuan berbeda.

| Hook       | Kapan dijalankan                                                          |
| ---------- | ------------------------------------------------------------------------- |
| `precmd`   | Sebelum prompt ditampilkan.                                               |
| `preexec`  | Setelah perintah interaktif diterima, sebelum perintah itu dieksekusi.    |
| `chpwd`    | Setelah direktori kerja berhasil berubah.                                 |
| `periodic` | Secara berkala, berdasarkan interval yang dikonfigurasi.                  |
| `zshexit`  | Ketika Zsh keluar secara normal melalui mekanisme exit shell yang sesuai. |

Ketepatan waktu pemanggilan ini penting ketika Anda menentukan event yang sesuai untuk automation.

Contoh penggunaan:

- `precmd`: memperbarui informasi yang akan ditampilkan pada prompt.
- `preexec`: mencatat waktu mulai suatu perintah.
- `chpwd`: memperbarui informasi direktori setelah berpindah direktori.
- `periodic`: menjalankan pemeriksaan berkala saat shell interaktif sedang berjalan.
- `zshexit`: melakukan pembersihan sebelum shell keluar.

## 3. Mendaftarkan fungsi dengan `add-zsh-hook`

Cara yang disarankan untuk mengelola hooks adalah menggunakan fungsi bawaan `add-zsh-hook`.

Pertama, muat fungsi tersebut:

```
autoload -Uz add-zsh-hook
```

Kemudian daftarkan fungsi ke hook yang diinginkan:

```
my_precmd() {
    print -r -- "Prompt akan ditampilkan"
}

add-zsh-hook precmd my_precmd
```

Sekarang, setiap kali Zsh akan menampilkan prompt berikutnya, fungsi `my_precmd` dipanggil.

Mari uraikan mekanismenya:

| Kode                  | Makna                                               |
| --------------------- | --------------------------------------------------- |
| `my_precmd() { ... }` | Mendefinisikan fungsi yang akan menjalankan action. |
| `add-zsh-hook`        | Helper untuk mendaftarkan fungsi ke hook.           |
| `precmd`              | Nama hook yang menjadi pemicu.                      |
| `my_precmd`           | Nama fungsi yang akan dijalankan.                   |

Perhatikan bahwa `add-zsh-hook precmd my_precmd` tidak memanggil fungsi tersebut secara langsung. Baris itu mendaftarkan fungsi untuk dipanggil pada event berikutnya yang sesuai.

### Mengapa tidak cukup membuat fungsi bernama `precmd`?

Zsh mengenal fungsi khusus seperti `precmd` dan `preexec`. Namun, jika Anda mendefinisikan ulang fungsi hook secara langsung, Anda dapat menimpa implementasi sebelumnya, termasuk milik plugin.

Dengan `add-zsh-hook`, beberapa fungsi dapat didaftarkan pada hook yang sama tanpa harus mengganti seluruh implementasi hook. Ini lebih sesuai untuk konfigurasi modular dan sistem plugin.

## 4. Praktik: memahami `precmd`

Coba jalankan kode berikut langsung pada sesi Zsh interaktif:

```
autoload -Uz add-zsh-hook

lesson_precmd() {
    print -r -- "[hook] Prompt berikutnya akan ditampilkan"
}

add-zsh-hook precmd lesson_precmd
```

Setelah fungsi didaftarkan, pesan akan muncul sebelum prompt berikutnya ditampilkan. Pesan juga akan muncul setelah perintah berikutnya selesai dan Zsh kembali menyiapkan prompt.

Untuk memeriksa fungsi yang terdaftar:

```
add-zsh-hook -L precmd
```

Untuk menghapus pendaftaran fungsi tersebut:

```
add-zsh-hook -d precmd lesson_precmd
```

Penghapusan pendaftaran tidak menghapus definisi fungsi `lesson_precmd`; keduanya merupakan hal yang berbeda.

## 5. Memahami `preexec`

Jika `precmd` bekerja sebelum prompt ditampilkan, `preexec` bekerja ketika perintah interaktif akan dieksekusi.

Contoh:

```
lesson_preexec() {
    print -r -- "[hook] Perintah: $1"
}

add-zsh-hook preexec lesson_preexec
```

Coba jalankan:

```
pwd
```

Anda akan melihat pesan hook sebelum hasil dari `pwd` ditampilkan.

Pada `preexec`, argumen pertama (`$1`) berisi representasi baris perintah yang akan dieksekusi. Hook ini berguna untuk pencatatan aktivitas, pengukuran waktu perintah, atau integrasi dengan sistem pemantauan terminal.

Namun, ada batasan penting: jangan menganggap setiap perintah yang tercatat pasti berhasil. `preexec` berjalan sebelum eksekusi, sehingga status akhir perintah belum diketahui.

## 6. Memahami `chpwd`

Hook `chpwd` dipanggil setelah direktori kerja berhasil berubah.

```
lesson_chpwd() {
    print -r -- "[hook] Direktori sekarang: $PWD"
}

add-zsh-hook chpwd lesson_chpwd
```

Kemudian:

```
cd /tmp
```

Jika perpindahan direktori berhasil, Zsh menjalankan `lesson_chpwd` dan variabel `$PWD` berisi direktori kerja yang baru.

Hook ini cocok untuk automation yang bergantung pada direktori, misalnya memperbarui informasi proyek atau menyesuaikan tampilan prompt berdasarkan lokasi kerja.

Jika direktori tidak berubah karena `cd` gagal, hook `chpwd` tidak dijalankan untuk perubahan tersebut.

## 7. Memahami `periodic`

Hook `periodic` dipanggil secara berkala ketika shell interaktif menunggu input, berdasarkan interval yang ditentukan oleh parameter `PERIOD`.

Contoh:

```
PERIOD=60

lesson_periodic() {
    print -r -- "[hook] Pemeriksaan berkala"
}

add-zsh-hook periodic lesson_periodic
```

`PERIOD=60` menentukan interval dalam detik. Dalam praktiknya, pemanggilan bergantung pada aktivitas shell; ini bukan timer presisi yang menjamin eksekusi tepat setiap 60 detik, bahkan ketika shell sibuk menjalankan perintah.

Gunakan hook ini untuk pemeriksaan ringan. Jangan menaruh pekerjaan berat di dalamnya karena dapat mengganggu pengalaman interaktif.

## 8. Menguji dan membersihkan eksperimen

Semua contoh di atas dapat dicoba dalam sesi Zsh saat ini. Untuk membersihkan pendaftaran hook, jalankan:

```
add-zsh-hook -d precmd lesson_precmd
add-zsh-hook -d preexec lesson_preexec
add-zsh-hook -d chpwd lesson_chpwd
add-zsh-hook -d periodic lesson_periodic
```

Jika Anda juga ingin menghapus fungsi eksperimen dari sesi saat ini:

```
unfunction lesson_precmd lesson_preexec lesson_chpwd lesson_periodic
```

Jangan langsung memasukkan semua contoh ke `~/.config/zsh` sebelum Anda memahami perilakunya. Khususnya, hook `precmd` dan `preexec` bisa berjalan sangat sering.

## 9. Prinsip desain hooks

Ketika membangun automation, perhatikan empat hal berikut:

1. Pilih event yang tepat. Gunakan `chpwd` untuk perubahan direktori, bukan `precmd` jika action hanya diperlukan ketika direktori berubah.
2. Jaga fungsi tetap ringan. Fungsi yang berjalan sebelum setiap prompt dapat memperlambat shell.
3. Hindari konflik. Gunakan `add-zsh-hook` agar fungsi dari konfigurasi lain tidak mudah tertimpa.
4. Bedakan pemicu dan action. Hook menentukan kapan fungsi dipanggil; isi fungsi menentukan pekerjaan yang dilakukan.

Contoh arsitektur yang lebih modular:

```
~/.config/zsh/
├── zshrc
└── hooks.zsh
```

Isi `hooks.zsh` dapat memuat fungsi-fungsi hook dan pendaftarannya. Kemudian `zshrc` cukup memuat file tersebut dengan `source`, seperti pola konfigurasi modular yang telah dipelajari sebelumnya.

## Ringkasan

Hooks menghubungkan event internal Zsh dengan fungsi buatan Anda:

```
Event
  ↓
Hook
  ↓
Fungsi yang didaftarkan
  ↓
Action
```

Perbedaan yang perlu diingat:

- `precmd`: sebelum prompt.
- `preexec`: sebelum perintah interaktif dieksekusi.
- `chpwd`: setelah direktori berubah.
- `periodic`: pemeriksaan berkala saat shell interaktif menunggu input.
- `zshexit`: saat shell keluar secara normal.

Setelah memahami mekanisme ini, Anda memiliki dasar untuk membuat automation yang bereaksi terhadap aktivitas shell. Tahap berikutnya adalah Lesson 16 — Zsh Modules (`zmodload`), untuk mengenal kemampuan tambahan yang dapat dimuat melalui sistem modul Zsh.
> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-15/README.md
[selanjutnya]: ../bagian-17/README.md

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

