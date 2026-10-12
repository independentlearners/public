# FASE 3: GLOBBING, COMPLETION, DAN KONFIGURASI

**Level:** Menengah | **Durasi:** 4–5 minggu | **Jam:** ~30–40 jam

---

# Modul 3.1: Globbing dan Pattern Matching Lanjutan

<details>
  <summary>📃 Daftar Isi</summary>

## Daftar Isi Internal (Mini-Daftar Isi)

1. **Wildcard Dasar**: `*`, `?`, `[...]`, dan `[^...]`
2. **Recursive Globbing dengan `**`** — termasuk `***/` dan `GLOB_STAR_SHORT`
3. **Glob Qualifiers — Tipe File dan Permission** — `.`, `/`, `@`, `x`, `r`, `w`, dan lainnya
4. **Glob Qualifiers — Ukuran, Waktu, dan Kepemilikan** — `L`, `m`, `a`, `c`, `U`, `G`, `u`, `g`
5. **Sorting dan Pembatasan Hasil** — `o`/`O`, `[1,5]`, `Y`, `n`
6. **Negasi dan Exclusion Patterns** — `^`, `~`, dan `EXTENDED_GLOB`
7. **Opsi `NULL_GLOB`, `NOMATCH`, dan `GLOB_STAR_SHORT`** *(tambahan audit)*
8. **Glob Qualifiers sebagai Saklar Lokal — `N` dan `D`** *(tambahan audit)*

</details>

---

## 1. Wildcard Dasar: `*`, `?`, `[...]`, dan `[^...]`

### Deskripsi Konkret & Peran dalam Kurikulum

Wildcard dasar adalah fondasi seluruh sistem globbing di Zsh. Tanpa menguasai ini, mustahil memahami glob qualifiers yang merupakan "lapisan lanjutan" di atasnya. Dalam konteks kurikulum Fase 3, bagian ini adalah **prasyarat mutlak** untuk semua sub-bagian berikutnya. Di Bash pun wildcard dasar ini ada, tetapi Zsh memiliki beberapa perbedaan penting dalam perilakunya yang perlu dipahami sejak awal.

### Konsep Kunci & Filosofi Mendalam

Bayangkan Anda memiliki tumpukan dokumen di lemari arsip, dan Anda ingin mengambil beberapa dokumen tanpa menyebutkan satu per satu nama lengkapnya. Itulah esensi globbing: **shell "membaca" pola yang Anda tulis, membandingkannya dengan nama-nama file yang ada, dan menggantinya dengan daftar file yang cocok** sebelum perintah dijalankan.

Filosofinya: *"Jangan suruh saya mengetik apa yang bisa saya deskripsikan."* Alih-alih mengetik `file1.txt file2.txt file3.txt`, Anda cukup menulis `file?.txt`. Shell yang bekerja, bukan Anda.

Yang membedakan Zsh dari shell lain adalah Zsh memandang globbing sebagai **bahasa pencarian file yang lengkap**, bukan sekadar fitur tambahan. Di Bash, globbing adalah "bonus"; di Zsh, globbing adalah "warga kelas satu".

### Sintaks Dasar dan Contoh

```bash
# * — mencocokkan nol atau lebih karakter (tidak melewati /)
ls *.txt                    # Semua file berakhiran .txt
ls foo*                     # Semua file yang diawali "foo"
ls *bar*                    # Semua file yang mengandung "bar"

# ? — mencocokkan tepat satu karakter
ls file?.txt                # file1.txt, fileA.txt, file_.txt
ls file??.txt               # file01.txt, fileAB.txt

# [...] — mencocokkan satu karakter dari himpunan
ls file[123].txt            # file1.txt, file2.txt, file3.txt
ls file[a-z].txt            # filea.txt ... filez.txt
ls file[A-Za-z].txt         # Huruf besar atau kecil

# [^...] — mencocokkan satu karakter BUKAN dari himpunan (negasi karakter)
ls file[^0-9].txt           # fileA.txt (bukan file1.txt)
```

**Penjelasan kata demi kata:**

- `*` — Dalam Zsh, `*` **tidak** mencocokkan file yang diawali dengan titik (hidden file) secara default. Untuk itu, Anda perlu `setopt GLOB_DOTS` atau menggunakan glob qualifier `(D)`. Ini berbeda dari ekspektasi banyak pengguna Bash.
- `?` — Selalu tepat satu karakter. Tidak bisa nol, tidak bisa dua. Jika Anda ingin "nol atau satu", gunakan `(foo|)` dengan `EXTENDED_GLOB`, atau `(#c0,1)`.
- `[...]` — Jika Anda ingin menyertakan `]` di dalam himpunan, letakkan di awal: `[]abc]`. Untuk `-`, letakkan di awal atau akhir: `[-abc]`.
- `[^...]` — Zsh menggunakan `^` (bukan `!` seperti Bash) untuk negasi di dalam tanda kurung. Meskipun `[!...]` juga didukung untuk kompatibilitas.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Globbing** | Ekspansi pola wildcard menjadi daftar nama file yang cocok. Nama lain: *filename generation* (istilah resmi di manual Zsh). |
| **Wildcard** | Karakter khusus (`*`, `?`, `[...]`) yang memiliki makna pola, bukan makna literal. |
| **Filename Generation** | Istilah teknis Zsh untuk globbing. Ini adalah ekspansi **terakhir** yang dilakukan shell, setelah semua ekspansi lain (parameter, command substitution, arithmetic, brace). |
| **GLOB_DOTS** | Opsi shell yang membuat `*` juga mencocokkan file tersembunyi (yang diawali titik). |
| **NOMATCH** | Opsi (aktif secara default) yang menyebabkan shell **error** jika pola glob tidak menemukan hasil. |
| **NULL_GLOB** | Opsi yang membuat pola glob yang gagal **menghilang** (bukan error), menggantikan dirinya dengan string kosong. |

### Diagram Alur: Bagaimana Globbing Bekerja

```bash
Anda mengetik: ls *.txt
        │
        ▼
Shell melakukan ekspansi dalam urutan:
  1. History Expansion (jika interaktif)
  2. Alias Expansion
  3. Process Substitution
  4. Parameter Expansion ($var)
  5. Command Substitution ($(cmd))
  6. Arithmetic Expansion ($((...)))
  7. Brace Expansion ({a,b})
        │
        ▼
  8. Filename Generation / GLOBBING ← ★ ini dia
        │
        ▼
Shell membaca direktori, mencocokkan "*.txt"
dengan nama-nama file yang ada
        │
        ▼
Hasil: file1.txt file2.txt file3.txt
        │
        ▼
Perintah akhir yang dijalankan: ls file1.txt file2.txt file3.txt
```

> **Visualisasi diagram alur urutan ekspansi shell [History → Alias → Process Sub → Parameter → Command Sub → Arithmetic → Brace → Globbing] akan sangat membantu di sini.** Diagram ini menunjukkan mengapa `*.txt` di dalam tanda kutip `'*.txt'` atau `"*.txt"` **tidak** di-glob — karena quoting mencegah globbing dilakukan.

### Hubungan dengan Modul Lain

- **Prasyarat untuk**: Seluruh sisa Modul 3.1 (glob qualifiers, recursive globbing, extended globbing).
- **Terhubung ke**: Modul 3.2 (Completion) — sistem completion menggunakan mekanisme pattern matching yang sama untuk menawarkan saran.
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — opsi seperti `GLOB_DOTS` dan `NOMATCH` diatur di `.zshrc`.

### Sumber Referensi

- Zsh Manual — Filename Generation: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation 
- An Introduction to the Z Shell — Filename Generation: https://zsh.sourceforge.io/Intro/intro.html 
- Zsh FAQ — Pattern Characters: https://zsh.sourceforge.io/FAQ/zshfaq03.html

### Tips dan Praktik Terbaik

1. **Selalu kutip glob saat ingin literal**: Jika Anda ingin `echo "*.txt"` menampilkan string literal `*.txt` (bukan daftar file), gunakan tanda kutip tunggal `'*.txt'` atau escape `\*.txt`.
2. **Gunakan `setopt GLOB_DOTS` dengan hati-hati**: Ini akan membuat `*` juga mencocokkan `.git`, `.config`, dan semua file tersembunyi. Kadang berguna, kadang berbahaya.
3. **Manfaatkan `print -l` untuk debugging**: Daripada `ls`, gunakan `print -l *.txt` untuk melihat hasil glob satu per satu, terutama ketika nama file mengandung spasi atau karakter khusus.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `*.txt` tidak menemukan file tersembunyi | Zsh secara default tidak mengikutsertakan file hidden | `setopt GLOB_DOTS` atau gunakan `*(D)` |
| `ls *.txt` error "no matches found" | Opsi `NOMATCH` aktif (default) | `setopt NULL_GLOB` atau tambahkan `(N)` di akhir pola |
| `echo *.txt` menampilkan `*.txt` literal | Tidak ada file yang cocok, dan `NULL_GLOB` aktif | Periksa apakah ada file `.txt` di direktori saat ini |
| Pola dengan spasi tidak berfungsi | Spasi dianggap pemisah argumen | Quote pola: `ls "my file*.txt"` |

### Latihan Praktis

```bash
# Buat struktur file untuk latihan
mkdir -p /tmp/zsh-glob-lab && cd /tmp/zsh-glob-lab
touch file1.txt file2.txt fileA.txt file01.txt .hidden.txt
mkdir -p subdir/subsubdir
touch subdir/file3.txt subdir/subsubdir/file4.txt

# Latihan 1: Wildcard dasar
ls *.txt                    # Apa yang muncul? Apakah .hidden.txt muncul?
ls file?.txt                # file1.txt, file2.txt, fileA.txt — mengapa file01.txt tidak?
ls file[0-9].txt            # file1.txt, file2.txt — mengapa fileA.txt tidak?

# Latihan 2: Negasi karakter
ls file[^0-9].txt           # fileA.txt

# Latihan 3: Bandingkan dengan Bash (jika ada)
# Di Bash: ls [^0-9]* → tidak berfungsi, harus menggunakan [!0-9]*
```

---

## 2. Recursive Globbing dengan `**`

### Deskripsi Konkret & Peran dalam Kurikulum

Recursive globbing adalah fitur yang membuat Zsh menonjol dibandingkan shell tradisional. Dengan `**`, Anda dapat mencari file di seluruh pohon direktori **tanpa** menggunakan perintah eksternal seperti `find`. Dalam konteks kurikulum, ini adalah **jembatan** antara globbing dasar dan glob qualifiers lanjutan, karena `**` sering dikombinasikan dengan qualifiers untuk seleksi yang sangat presisi.

### Konsep Kunci & Filosofi Mendalam

`**` adalah operator yang mengubah pertanyaan dari *"Apa saja file di direktori ini?"* menjadi *"Apa saja file di direktori ini **dan semua subdirektori di bawahnya**, secara rekursif?"*

Filosofinya: *"Mengapa harus membuka setiap pintu secara manual ketika Anda bisa mengatakan 'buka semua pintu di gedung ini'?"*

Secara teknis, `**/` setara dengan `(*/)#` dalam sintaks Zsh. Artinya: "nol atau lebih direktori yang cocok dengan `*`, masing-masing diikuti oleh `/`". Karena itu, `**/*.txt` mencocokkan:
- `*.txt` di direktori saat ini (nol direktori perantara)
- `dir/*.txt` (satu direktori perantara)
- `dir/subdir/*.txt` (dua direktori perantara)
- ... dan seterusnya, tanpa batas kedalaman.

**Perbedaan krusial dengan Bash**: Di Bash, `**` hanya berfungsi jika Anda mengaktifkan `shopt -s globstar` terlebih dahulu. Di Zsh, `**` adalah fitur bawaan yang aktif secara default. Ini adalah salah satu alasan mengapa banyak pengguna berpindah dari Bash ke Zsh.

### Sintaks Dasar dan Contoh

```bash
# **/ — rekursif melalui semua subdirektori
ls **/*.txt                 # Semua .txt di direktori ini dan semua subdir
ls **/*.log                 # Semua .log secara rekursif

# **/f* — mencari file yang diawali "f" di semua level
ls **/f*                    # file.h, foo.c, stuff/xxx/foobar, dll.

# ***/ — rekursif dan IKUTI symbolic links
ls ***/*.txt                # Sama seperti **/ tetapi mengikuti symlink

# GLOB_STAR_SHORT — singkatan: **.c setara dengan **/*.c
setopt GLOB_STAR_SHORT
ls **.c                     # Sama dengan **/*.c
```

**Penjelasan mendalam tentang `**` dan `***`:**

- `**/` — Rekursif melalui subdirektori, **tidak** mengikuti symbolic link. Artinya, jika ada direktori yang merupakan symlink ke direktori lain, Zsh tidak akan masuk ke dalamnya.
- `***/` — Sama seperti `**/`, tetapi **mengikuti** symbolic link. Ini berguna ketika Anda memiliki struktur direktori yang melibatkan symlink dan ingin menjangkaunya.
- `**.c` (dengan `GLOB_STAR_SHORT`) — Singkatan untuk `**/*.c`. Opsi ini mengubah perilaku: jika `**` tidak diikuti langsung oleh `/`, Zsh memperlakukannya seolah-olah ada `/` setelahnya.

**Mengapa `**/` penting?** Karena ini menghilangkan kebutuhan akan `find` untuk sebagian besar kasus. Bandingkan:

```bash
# Dengan find (POSIX, bekerja di shell apa pun)
find . -name '*.txt' -type f

# Dengan Zsh globbing — lebih pendek, lebih cepat (built-in), lebih ekspresif
ls **/*.txt(D.)
# (D = termasuk hidden, . = hanya file reguler)
```

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Recursive Globbing** | Pencarian file yang menelusuri semua subdirektori di bawah direktori saat ini. |
| **`**/`** | Operator Zsh untuk rekursif globbing. Setara dengan `(*/)#`. Tidak mengikuti symlink. |
| **`***/`** | Varian yang mengikuti symbolic link. |
| **`(*/)#`** | Bentuk eksplisit dari `**/`. `#` berarti "nol atau lebih" dalam sintaks glob Zsh (memerlukan `EXTENDED_GLOB`). |
| **Symlink** | *Symbolic link* — file khusus yang menunjuk ke file atau direktori lain. |
| **`GLOB_STAR_SHORT`** | Opsi Zsh yang membuat `**` tanpa trailing `/` diperlakukan sebagai `**/`. |

### Diagram Pohon: Cara Kerja `**/`

Misalkan struktur direktori:

```bash
project/
├── main.c
├── README.md
├── src/
│   ├── utils.c
│   ├── utils.h
│   └── lib/
│       └── helper.c
└── tests/
    └── test_main.c
```

Ketika Anda menjalankan `ls **/*.c` dari dalam `project/`:

```bash
**/  mencocokkan:
  ├── (nol direktori) → main.c  ✅
  ├── src/ → src/utils.c        ✅
  ├── src/lib/ → src/lib/helper.c ✅
  └── tests/ → tests/test_main.c ✅
```

Hasil: `main.c  src/utils.c  src/lib/helper.c  tests/test_main.c`

> **Visualisasi diagram pohon [project/ dengan cabang src/, lib/, tests/] dan jalur yang dilalui `**/` akan sangat membantu di sini.** Diagram ini menunjukkan bagaimana `**/` "menyelami" setiap cabang pohon secara rekursif.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Wildcard dasar (Sub-bagian 1).
- **Prasyarat untuk**: Glob qualifiers (Sub-bagian 3–5) — `**` sering dikombinasikan dengan qualifiers seperti `(.)`, `(om)`, `(Lk+100)`.
- **Terhubung ke**: Modul 3.3 — opsi `GLOB_STAR_SHORT` diatur di `.zshrc`.

### Sumber Referensi

- Zsh Manual — Recursive Globbing: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing 
- Zsh Manual — `GLOB_STAR_SHORT`: https://zsh.sourceforge.io/Doc/Release/Options.html#index-GLOBSTARSHORT
- Origin and Evolution of the Globstar (Mergify): https://mergify.com/blog/origin-and-evolution-of-the-globstar 

### Tips dan Praktik Terbaik

1. **Gunakan `(N)` atau `setopt NULL_GLOB` dengan `**`**: Karena `**` sering tidak menemukan hasil di direktori yang dalam, `NOMATCH` akan menyebabkan error. `(N)` membuat pola "menghilang" jika tidak ada hasil.
2. **Hati-hati dengan `***/`**: Mengikuti symlink bisa menyebabkan loop tak terbatas jika ada symlink sirkular. Gunakan hanya jika Anda yakin struktur direktori Anda aman.
3. **Kombinasikan dengan glob qualifiers**: `**/*.log(om[1,3])` adalah cara paling elegan untuk mendapatkan 3 file log terbaru secara rekursif.
4. **Untuk performa**: `**` di direktori yang sangat besar (misalnya `/`) bisa lambat. Batasi dengan direktori spesifik: `~/projects/**/*.c`, bukan `/**/*.c`.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `**/*.txt` tidak menemukan file di direktori saat ini | Zsh **memang** mencocokkan direktori saat ini (nol direktori) | Periksa apakah file ada. Jika tidak, gunakan `(N)`. |
| `***/` menyebabkan "too many levels of symbolic links" | Symlink sirkular | Hindari `***/` di direktori dengan symlink yang tidak terpercaya |
| `**.c` tidak berfungsi | `GLOB_STAR_SHORT` belum diaktifkan | `setopt GLOB_STAR_SHORT` atau tulis `**/*.c` |
| Perintah lambat karena `**` | Direktori sangat besar atau kedalaman berlebihan | Batasi dengan subdirektori spesifik: `project/src/**/*.c` |

### Latihan Praktis

```bash
# Menggunakan struktur direktori dari latihan sebelumnya
cd /tmp/zsh-glob-lab

# Latihan 1: Recursive globbing dasar
ls **/*.txt                 # Semua .txt secara rekursif
ls **/f*                    # Semua file yang diawali f di semua level

# Latihan 2: Bandingkan dengan *
ls *.txt                    # Hanya di direktori saat ini

# Latihan 3: GLOB_STAR_SHORT
setopt GLOB_STAR_SHORT
ls **.txt                   # Sama dengan **/*.txt
unsetopt GLOB_STAR_SHORT    # Kembalikan ke perilaku normal

# Latihan 4: ***/ dengan symlink
ln -s subdir linkdir
ls **/*.txt                 # Apakah linkdir/file3.txt muncul? (tidak)
ls ***/*.txt                # Apakah linkdir/file3.txt muncul? (ya)
```

---

## 3. Glob Qualifiers — Tipe File dan Permission

### Deskripsi Konkret & Peran dalam Kurikulum

Glob qualifiers adalah **jantung** dari sistem globbing Zsh yang membedakannya secara fundamental dari shell lain. Jika wildcard dasar menjawab pertanyaan *"file apa yang cocok dengan pola nama ini?"*, glob qualifiers menjawab pertanyaan lanjutan: *"dari file-file yang cocok dengan pola nama, mana yang juga memenuhi kriteria tipe, permission, ukuran, waktu, atau atribut lainnya?"*

Dalam konteks kurikulum Fase 3, sub-bagian ini adalah **inti dari Modul 3.1**. Tanpa menguasai glob qualifiers, Anda hanya menggunakan Zsh seperti Bash dengan sintaks yang sedikit berbeda. Dengan menguasainya, Anda membuka kemampuan seleksi file yang tidak dimiliki shell lain secara native.

### Konsep Kunci & Filosofi Mendalam

Bayangkan Anda memiliki tumpukan kartu di meja. Wildcard dasar memungkinkan Anda berkata: *"Ambilkan semua kartu yang bergambar hati."* Glob qualifiers memungkinkan Anda berkata: *"Ambilkan semua kartu yang bergambar hati, **yang berwarna merah**, **yang nilainya lebih dari 5**, dan **yang paling baru saya beli**."*

Filosofi desainnya adalah **pemisahan antara "apa yang dicari" dan "bagaimana memfilternya"**. Pola nama file menentukan kandidat awal; qualifiers menentukan filter yang diterapkan pada kandidat tersebut. Ini adalah pola desain yang sangat bersih: *pattern → filter → hasil*.

Secara implementasi, Zsh melakukan langkah berikut:
1. Membaca direktori dan mencocokkan nama file dengan pola.
2. Untuk setiap file yang cocok, menjalankan `stat()` (system call) untuk mendapatkan metadata.
3. Menerapkan qualifiers satu per satu (secara logika AND — semua harus terpenuhi).
4. Mengembalikan daftar file yang lolos semua filter.

**Mengapa ini revolusioner?** Karena di shell tradisional, Anda perlu memanggil `find` atau `ls -l | grep` untuk melakukan hal yang sama. Zsh melakukan semuanya di dalam shell, tanpa proses eksternal, tanpa pipe, dan dengan sintaks yang jauh lebih ringkas.

### Sintaks Dasar dan Contoh

```bash
# Tipe file
ls *(.)                 # Hanya file reguler (bukan direktori, bukan symlink)
ls *(/)                 # Hanya direktori
ls *(@)                 # Hanya symbolic links
ls *(=)                 # Hanya sockets
ls *(p)                 # Hanya named pipes (FIFOs)
ls *(%b)                # Hanya block special files
ls *(%c)                # Hanya character special files
ls *(%)                 # Hanya device files (block atau character)

# Permission — owner
ls *(r)                 # Owner-readable
ls *(w)                 # Owner-writable
ls *(x)                 # Owner-executable

# Permission — group
ls *(A)                 # Group-readable
ls *(I)                 # Group-writable
ls *(E)                 # Group-executable

# Permission — world (others)
ls *(R)                 # World-readable
ls *(W)                 # World-writable
ls *(X)                 # World-executable

# Special permission bits
ls *(s)                 # Setuid files
ls *(S)                 # Setgid files
ls *(t)                 # Sticky bit

# Permission octal (spesifik)
ls *(600)               # Permission tepat 600 (rw-------)
ls *(+x)                # Setidaknya executable (owner)
ls *(-w)                # Tidak writable (owner)
ls *(?r)                # Owner-readable, bit lain tidak dicek
```

**Penjelasan kata demi kata — qualifier permission:**

- `*(r)` — Huruf `r` di dalam tanda kurung adalah qualifier. Ini **bukan** pola nama file. Tanda bintang `*` adalah pola yang mencocokkan semua file, lalu qualifier `(r)` memfilter hanya yang owner-readable. Hasilnya adalah "semua file yang dapat dibaca oleh pemiliknya".
- `*(x)` — Owner-executable. Ini mencocokkan file yang memiliki bit `0100` (octal) atau `0010` atau `0001` dalam mode-nya. Artinya, file yang executable oleh owner, group, atau others. **Catatan**: `*(x)` mencocokkan jika **salah satu** dari ketiga bit executable terpenuhi.
- `*(X)` — World-executable. Hanya mencocokkan file yang executable oleh "others" (bit `0001`). Jika Anda ingin file yang executable oleh owner tetapi tidak oleh others, gunakan `*(x^X)` (dengan `EXTENDED_GLOB`).
- `*(s)` — Setuid. File yang memiliki bit setuid (`04000`). Ketika file seperti ini dijalankan, ia berjalan dengan hak akses pemilik file, bukan pengguna yang menjalankannya.
- `*(t)` — Sticky bit. Sering digunakan pada direktori `/tmp` agar hanya pemilik file yang bisa menghapus file-nya sendiri.

**Mengapa ada tiga set permission?** Sistem operasi Unix/Linux mengenal konsep **triad permission**: owner, group, others. Zsh memetakan huruf ke setiap kategori:
- Huruf kecil (`r`, `w`, `x`) = owner
- Huruf kapital awal (`A`, `I`, `E`) = group (kecuali `E` yang mudah dikelirukan dengan `X`)
- Huruf kapital akhir (`R`, `W`, `X`) = world/others

Ini adalah konvensi yang perlu dihafal. Trik: "huruf kecil untuk saya sendiri, huruf kapital untuk orang lain."

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Glob Qualifier** | Ekspresi dalam tanda kurung di akhir pola glob yang memfilter hasil berdasarkan atribut file. |
| **`stat()`** | System call untuk mendapatkan metadata file (tipe, permission, ukuran, waktu, kepemilikan). Zsh memanggil ini secara internal untuk setiap qualifier. |
| **File Reguler** | File "biasa" — bukan direktori, bukan symlink, bukan device. Qualifier: `.` |
| **Symlink** | *Symbolic link* — file yang menunjuk ke file/direktori lain. Qualifier: `@` |
| **FIFO** | *Named pipe* — mekanisme komunikasi antarproses. Qualifier: `p` |
| **Socket** | Titik komunikasi jaringan/lokal. Qualifier: `=` |
| **Setuid/Setgid** | Bit permission khusus yang mengubah hak akses saat eksekusi. Qualifier: `s` (setuid), `S` (setgid). |
| **Sticky Bit** | Bit permission pada direktori yang membatasi penghapusan file. Qualifier: `t` |

### Diagram Alur: Pattern → Qualifier → Hasil

```bash
Pola:    *(.x)     ← "File reguler DAN owner-executable"
        │   │
        │   └── Qualifier: x (owner-executable)
        └────── Qualifier: . (file reguler)

Langkah eksekusi:
  1. Zsh membaca direktori, mencocokkan "*" → [fileA, fileB, dirC, linkD]
  2. Untuk fileA: stat() → tipe = reguler, mode = 0755 → LOLOS (.x)
  3. Untuk fileB: stat() → tipe = reguler, mode = 0644 → GAGAL (tidak x)
  4. Untuk dirC:  stat() → tipe = direktori → GAGAL (bukan .)
  5. Untuk linkD: stat() → tipe = symlink → GAGAL (bukan .)
  6. Hasil: [fileA]

Dengan menggabungkan qualifier, Anda memfilter dengan logika AND.
```

> **Tabel visual yang merangkum semua glob qualifier tipe file dan permission [kolom: Qualifier, Arti, Contoh, Hasil] akan sangat membantu di sini.** Tabel ini akan menjadi referensi cepat yang sangat berguna.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Wildcard dasar (Sub-bagian 1), Recursive globbing (Sub-bagian 2).
- **Prasyarat untuk**: Glob qualifiers ukuran/waktu (Sub-bagian 4), sorting (Sub-bagian 5), negasi (Sub-bagian 6).
- **Terhubung ke**: Modul 3.2 (Completion) — completion untuk `chmod`, `find`, dan perintah file-related menggunakan qualifier-nya sendiri.
- **Terhubung ke**: Modul 3.3 — tidak ada opsi `.zshrc` khusus untuk tipe file, tetapi pemahaman ini diperlukan untuk menulis fungsi shell yang menggunakan glob qualifiers.

### Sumber Referensi

- Zsh Manual — Glob Qualifiers (tipe file): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- Zsh Manual — Glob Qualifiers (permission): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- An Introduction to the Z Shell — Glob Qualifiers: https://zsh.sourceforge.io/Intro/intro.html 

### Tips dan Praktik Terbaik

1. **Gunakan `*(.)` untuk "hanya file biasa"**: Ini adalah qualifier yang paling sering digunakan. Tanpa ini, `*` juga mencocokkan direktori, yang sering tidak diinginkan.
2. **Kombinasikan dengan `D` untuk file tersembunyi**: `*(D.)` berarti "file reguler, termasuk yang tersembunyi".
3. **Hati-hati dengan `*(x)` vs `*(X)`**: `x` = owner-executable, `X` = world-executable. Seringkali yang Anda maksud adalah `x`.
4. **Gunakan `*(/)` untuk direktori**: Sangat berguna ketika Anda ingin `cd` ke dalam direktori yang cocok pola. Contoh: `cd *(/^F)` — pindah ke direktori pertama yang tidak kosong.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `*(x)` tidak menemukan file yang "bisa dijalankan" | `x` = owner-executable, bukan "executable oleh siapa pun" | Gunakan `*(xX)` atau `*(x)` jika Anda pemilik file |
| `*(r)` tidak berfungsi pada symlink | Symlink tidak memiliki permission sendiri; permission ada pada target | Gunakan `*(-r)` untuk "follow symlink dan cek target" |
| Qualifier `(/)` tidak menemukan direktori yang diinginkan | Direktori kosong dikecualikan jika Anda menggunakan `F` | Gunakan `(/^F)` untuk direktori kosong |
| Lupa bahwa qualifiers adalah AND | `*(.x)` berarti "reguler DAN executable" | Untuk OR, gunakan tanda `|` di dalam qualifier: `*(.|/)` |

### Latihan Praktis

```bash
cd /tmp/zsh-glob-lab

# Latihan 1: Tipe file
ls *(.)                     # Hanya file reguler
ls *(/)                     # Hanya direktori
ls *(@)                     # Hanya symlink (buat dulu: ln -s file1.txt link1)

# Latihan 2: Permission
chmod 755 file1.txt         # Buat file1.txt executable oleh owner
ls *(x)                     # file1.txt muncul?
ls *(r)                     # Semua file muncul (semuanya readable)

# Latihan 3: Kombinasi
ls *(.x)                    # File reguler DAN owner-executable
ls *(D.)                    # File reguler termasuk tersembunyi

# Latihan 4: Bandingkan tanpa qualifier
ls *                        # Semua file (termasuk direktori)
```

---

## 4. Glob Qualifiers — Ukuran, Waktu, dan Kepemilikan

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini melengkapi "filter" globbing dengan dimensi yang lebih kaya: **ukuran file**, **waktu akses/modifikasi**, dan **kepemilikan**. Jika sub-bagian 3 menjawab *"file jenis apa?"*, sub-bagian 4 menjawab *"file dengan ukuran berapa, kapan terakhir diubah, dan milik siapa?"*

Dalam kurikulum, bagian ini adalah **jembatan** antara globbing dasar dan sistem sorting (sub-bagian 5). Banyak penggunaan `om[1,5]` (5 file terbaru) bergantung pada pemahaman qualifier `m` (modification time) yang dibahas di sini.

### Konsep Kunci & Filosofi Mendalam

Pikirkan perpustakaan dengan jutaan buku. Anda bisa mencari berdasarkan judul (wildcard), genre (tipe file). Tapi bagaimana jika Anda ingin mencari: *"Semua buku yang tebalnya lebih dari 500 halaman, yang saya baca dalam seminggu terakhir, dan yang saya sendiri yang beli?"* Itulah yang dilakukan qualifier ukuran, waktu, dan kepemilikan.

Filosofi kuncinya: **metadata file adalah data**. Ketika Anda menulis `*(Lk+100)`, Anda tidak sedang "menyuruh shell mencari file besar". Anda sedang **meminta shell membaca metadata setiap file, membandingkannya dengan kriteria numerik, dan mengembalikan yang cocok**. Ini adalah query database yang dijalankan oleh shell terhadap filesystem.

### Sintaks Dasar dan Contoh

```bash
# === UKURAN FILE (L = Length) ===
ls *(L0)                    # File kosong (0 byte)
ls *(Lk+100)                # File lebih dari 100 KB
ls *(Lk-100)                # File kurang dari 100 KB
ls *(Lm+1)                  # File lebih dari 1 MB
ls *(Lm-1)                  # File kurang dari 1 MB
ls *(Lp+10)                 # File lebih dari 10 blok (512 byte) = 5 KB

# Unit: k/K (kilobyte), m/M (megabyte), g/G (gigabyte), t/T (terabyte), p/P (block 512B)
ls *(Lk+500)                # File > 500 KB
ls *(Lg+1)                  # File > 1 GB

# === WAKTU MODIFIKASI (m = modification) ===
ls *(m-7)                   # Dimodifikasi dalam 7 hari terakhir
ls *(m+7)                   # Dimodifikasi lebih dari 7 hari yang lalu
ls *(m0)                    # Dimodifikasi hari ini
ls *(mh-5)                  # Dimodifikasi dalam 5 jam terakhir (h = hours)
ls *(mm-30)                 # Dimodifikasi dalam 30 menit terakhir (m = minutes)
ls *(ms-60)                 # Dimodifikasi dalam 60 detik terakhir (s = seconds)
ls *(mw-2)                  # Dimodifikasi dalam 2 minggu terakhir (w = weeks)
ls *(mM-1)                  # Dimodifikasi dalam 1 bulan terakhir (M = months, 30 hari)

# === WAKTU AKSES (a = access) ===
ls *(a-1)                   # Diakses dalam 1 hari terakhir
ls *(ah-2)                  # Diakses dalam 2 jam terakhir

# === WAKTU PERUBAHAN INODE (c = inode change) ===
ls *(c-1)                   # Inode berubah dalam 1 hari terakhir

# === KEPEMILIKAN ===
ls *(U)                     # Dimiliki oleh effective user ID (Anda)
ls *(G)                     # Dimiliki oleh effective group ID
ls *(u:root:)               # Dimiliki oleh user "root"
ls *(u[1000])               # Dimiliki oleh user ID 1000
ls *(g:wheel:)              # Dimiliki oleh group "wheel"
ls *(g[100])                # Dimiliki oleh group ID 100

# === JUMLAH LINK ===
ls *(l+1)                   # File dengan lebih dari 1 hard link
ls *(l2)                    # File dengan tepat 2 hard link
```

**Penjelasan mendalam tentang qualifier waktu:**

Qualifier `m`, `a`, dan `c` menggunakan format:

```bash
m[unit][+|-]N

m   = modification time (waktu modifikasi)
a   = access time (waktu akses terakhir)
c   = inode change time (waktu perubahan metadata)

unit (opsional):
  (kosong) = hari (default)
  M = bulan (30 hari)
  w = minggu
  d = hari
  h = jam
  m = menit
  s = detik

+  = "lebih dari" (strictly greater)
-  = "kurang dari" (strictly less)
(kosong) = "tepat"

N  = angka
```

Contoh: `*(mh-5)` berarti:
- `m` — modification time
- `h` — unit jam
- `-` — kurang dari
- `5` — 5

Jadi: "File yang dimodifikasi **kurang dari** 5 jam yang lalu" = dimodifikasi dalam 5 jam terakhir.

**Trik menghafal**: Tanda `+` = "lebih tua dari" (waktu yang lebih lama), tanda `-` = "lebih baru dari" (waktu yang lebih singkat). Ini konsisten dengan cara berpikir: jika saya mengatakan "m+7", saya mencari file yang sudah lama tidak disentuh (lebih dari 7 hari).

**Peringatan tentang fraksi waktu**: Dokumentasi Zsh menyatakan bahwa "bagian fraksional dari perbedaan antara waktu akses dan waktu sekarang diabaikan." Artinya, `*(ah-5)` akan mencocokkan file yang diakses antara 0 dan 5 jam yang lalu, tetapi jika sudah 5 jam 30 menit, itu dihitung sebagai 5 jam (bukan 5.5), sehingga **tidak** cocok dengan `ah-5` (karena `-5` berarti strictly less than 5 jam, dan 5 jam 30 menit dianggap 5 jam, yang **tidak** strictly less). Hati-hati dengan boundary ini. 

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`L` (Length)** | Qualifier untuk ukuran file. Unit: k/K, m/M, g/G, t/T, p/P (block). |
| **`m` (Modification)** | Qualifier untuk waktu modifikasi terakhir. |
| **`a` (Access)** | Qualifier untuk waktu akses terakhir. |
| **`c` (Inode Change)** | Qualifier untuk waktu perubahan inode (metadata). |
| **Hard Link** | Nama tambahan untuk file yang sama di filesystem. Jumlah link = qualifier `l`. |
| **Effective UID** | User ID yang digunakan proses untuk menentukan hak akses. Qualifier: `U`. |
| **Effective GID** | Group ID efektif. Qualifier: `G`. |
| **`l[-|+]ct`** | Qualifier jumlah hard link. `l2` = tepat 2, `l+2` = lebih dari 2, `l-2` = kurang dari 2.  |

### Diagram Alur: Qualifier Ukuran sebagai Filter Numerik

```bash
Pola: *(.Lk+100m-1)   ← "File reguler, > 100 KB, < 1 MB, dimodifikasi < 1 hari"

Breakdown:
  *         → semua file
  (         → mulai qualifiers
  .         → tipe: file reguler
  Lk+100    → ukuran > 100 KB
  m-1       → modifikasi < 1 hari (24 jam terakhir)
  )         → akhir qualifiers

Eksekusi:
  fileA.txt:  stat → 50 KB, 2 hari lalu   → GAGAL (ukuran terlalu kecil)
  fileB.txt:  stat → 150 KB, 12 jam lalu   → LOLOS ✅
  fileC.txt:  stat → 200 KB, 5 hari lalu   → GAGAL (terlalu tua)
  fileD.jpg:  stat → 500 KB, 1 jam lalu    → LOLOS ✅
  dirE/:      stat → direktori              → GAGAL (bukan file reguler)

Hasil: fileB.txt fileD.jpg
```

> **Tabel visual yang merangkum qualifier ukuran/waktu [kolom: Qualifier, Arti, Satuan, Contoh, Hasil] akan sangat membantu di sini.** Tabel ini adalah referensi cepat yang tidak boleh dilewatkan.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Glob qualifiers tipe file (Sub-bagian 3).
- **Prasyarat untuk**: Sorting dan pembatasan hasil (Sub-bagian 5) — `om[1,5]` memerlukan pemahaman `m`.
- **Terhubung ke**: Modul 3.2 (Completion) — sistem completion untuk `find -size`, `find -mtime`, dan sejenisnya.
- **Terhubung ke**: Modul 3.3 — tidak ada opsi `.zshrc` khusus, tetapi fungsi shell yang menggunakan qualifier ini adalah bagian dari konfigurasi yang baik.

### Sumber Referensi

- Zsh Manual — Glob Qualifiers (ukuran): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- Zsh Manual — Glob Qualifiers (waktu): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- Zsh Manual — Glob Qualifiers (kepemilikan): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 

### Tips dan Praktik Terbaik

1. **Gunakan unit yang tepat**: `Lk+100` lebih mudah dibaca daripada `L+102400`. Jangan ragu menggunakan unit.
2. **Ingat bahwa `+` dan `-` adalah "strict"**: `Lk+100` tidak mencakup file yang tepat 100 KB. Gunakan `Lk100` untuk "tepat 100 KB" atau `Lk+99` untuk "≥ 100 KB" (dengan asumsi ukuran dalam satuan KB).
3. **Kombinasikan dengan sorting**: `*(.m-1om[1,5])` = 5 file reguler terbaru yang dimodifikasi dalam 24 jam terakhir.
4. **Perhatikan timezone**: Qualifier waktu menggunakan waktu lokal sistem. Pastikan timezone Anda benar jika bekerja dengan file dari sistem lain.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `*(Lk+100)` tidak menemukan file 100.000 byte | File 100.000 byte = ~97.7 KB, bukan 100 KB | Gunakan unit byte: `*(L+100000)` atau periksa ulang ukuran |
| `*(m-7)` tidak mencocokkan file yang baru saja diubah | `m-7` = strictly less than 7 hari; jika baru saja diubah, harusnya cocok | Pastikan file ada. Jika masih tidak cocok, cek timezone atau gunakan `m-0`. |
| `*(u:root:)` error "unknown user" | User "root" tidak ada di sistem (misalnya di macOS yang menggunakan "toor" atau nama lain) | Gunakan `u[0]` (UID root biasanya 0) atau cek dengan `id -un` |
| Bingung antara `m` (modification) dan `M` (month) | `m` = menit **atau** modifikasi; `M` = bulan | Konteks menentukan: `mh-5` = 5 jam yang lalu; `mM-1` = 1 bulan yang lalu |

### Latihan Praktis

```bash
cd /tmp/zsh-glob-lab

# Buat file dengan ukuran berbeda
dd if=/dev/zero of=small.bin bs=1024 count=1 2>/dev/null      # 1 KB
dd if=/dev/zero of=medium.bin bs=1024 count=200 2>/dev/null   # 200 KB
dd if=/dev/zero of=large.bin bs=1024 count=2000 2>/dev/null   # ~2 MB

# Latihan 1: Ukuran
ls *(Lk+100)                # medium.bin, large.bin
ls *(Lm+1)                  # large.bin
ls *(Lk-10)                 # small.bin

# Latihan 2: Waktu
touch -t 202501010000 oldfile.txt
ls *(m+30)                  # oldfile.txt (lebih dari 30 hari)
ls *(m-1)                   # File yang baru dibuat

# Latihan 3: Kepemilikan
ls *(U)                     # File milik Anda
ls *(u:$(whoami):)          # Sama, dengan nama user

# Latihan 4: Kombinasi
ls *(.Lk+100m-1)            # File reguler > 100 KB, < 1 hari
```

---

## 5. Sorting dan Pembatasan Hasil

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini mengajarkan cara **mengurutkan** dan **membatasi jumlah** hasil glob. Jika sub-bagian 3 dan 4 adalah tentang *filter*, sub-bagian 5 adalah tentang *ordering* dan *limit*. Ini adalah "lapisan terakhir" dalam pipeline globbing: setelah Anda memfilter file berdasarkan tipe, ukuran, dan waktu, Anda mungkin ingin *"beri saya 5 yang terbaru"* atau *"urutkan berdasarkan ukuran, terbesar dulu."*

Dalam kurikulum, ini adalah **puncak** dari Modul 3.1. Penggunaan `om[1,5]` (5 file terbaru) adalah salah satu idiom Zsh yang paling sering digunakan dalam praktik sehari-hari.

### Konsep Kunci & Filosofi Mendalam

Bayangkan Anda adalah seorang manajer yang meminta asisten: *"Ambilkan semua laporan dari lemari arsip, **urutkan berdasarkan tanggal**, dan **beri saya 3 yang paling baru**."* Asisten Anda (shell) melakukan langkah berikut:
1. **Kumpulkan** semua kandidat (globbing).
2. **Filter** berdasarkan kriteria (qualifiers tipe/ukuran/waktu).
3. **Urutkan** berdasarkan kriteria (qualifier `o`).
4. **Potong** hasilnya (qualifier `[1,3]`).

Filosofinya: **"Jangan berikan semua; berikan yang paling relevan."** Dalam dunia nyata, kita jarang membutuhkan *semua* file yang cocok dengan pola. Kita biasanya membutuhkan *N teratas* berdasarkan beberapa kriteria. Zsh memahami ini dan menyediakannya secara built-in.

**Yang perlu dipahami**: Sorting dan pembatasan adalah qualifier yang **diterapkan setelah semua filter lain**. Artinya, `*(.om[1,5])` berarti: "filter hanya file reguler, urutkan berdasarkan modifikasi terbaru, ambil 5 teratas."

### Sintaks Dasar dan Contoh

```bash
# === SORTING ===
# o = order (ascending/terkecil dulu), O = reverse order (terbesar dulu)

# Berdasarkan nama
ls *(on)                    # Urutkan berdasarkan nama (ascending) — ini default
ls *(On)                    # Urutkan berdasarkan nama (descending)

# Berdasarkan ukuran
ls *(oL)                    # Urutkan berdasarkan ukuran (terkecil dulu)
ls *(OL)                    # Urutkan berdasarkan ukuran (terbesar dulu)

# Berdasarkan waktu modifikasi
ls *(om)                    # Urutkan berdasarkan mtime (terlama dulu)
ls *(Om)                    # Urutkan berdasarkan mtime (terbaru dulu)

# Berdasarkan waktu akses
ls *(oa)                    # Urutkan berdasarkan atime (terlama dulu)
ls *(Oa)                    # Urutkan berdasarkan atime (terbaru dulu)

# Berdasarkan inode change
ls *(oc)                    # Urutkan berdasarkan ctime
ls *(Oc)                    # Urutkan berdasarkan ctime (terbaru dulu)

# Numeric sorting (untuk nama file dengan angka)
ls *(on)                    # Default: lexical — file10 < file2
ls *(n)                     # Numeric: file2 < file10
ls *(On)                    # Numeric descending

# === PEMBATASAN HASIL ===
ls *(om[1])                 # 1 file terbaru (paling baru)
ls *(om[1,5])               # 5 file terbaru
ls *(Om[1,10])              # 10 file terlama (ascending, ambil 10 pertama)
ls *(OL[1,3])               # 3 file terbesar

# === KOMBINASI ===
ls **/*.log(om[1,3])        # 3 log terbaru secara rekursif
ls **/*.txt(.OL[1,5])       # 5 file .txt terbesar secara rekursif
ls *(.om[1,5])              # 5 file reguler terbaru

# === Y (short-circuit / limit traversal) ===
ls *(NY1)                   # Ambil 1 file (berhenti setelah menemukan 1)
ls *(.NY5)                  # Ambil 5 file reguler, berhenti setelah 5
```

**Penjelasan mendalam tentang sorting:**

- `o` dan `O` adalah **prefix** untuk qualifier sorting. Huruf setelah `o`/`O` menentukan kriteria:
  - `n` = name (nama, lexical atau numeric tergantung opsi `NUMERIC_GLOB_SORT`)
  - `L` = length/size (ukuran)
  - `m` = modification time (waktu modifikasi)
  - `a` = access time (waktu akses)
  - `c` = inode change time (waktu perubahan inode)
  - `d` = depth (kedalaman direktori, berguna dengan `**`)

- `o` = **ascending** (naik): terkecil/terlama/terendah dulu.
- `O` = **descending** (turun): terbesar/terbaru/tertinggi dulu.

**Trik menghafal**: `o` = "order" (urut naik), `O` = "Order" (huruf besar = urut turun).

**Penjelasan tentang `[1,5]`:**

Tanda kurung siku setelah qualifier sorting adalah **array subscript** yang diterapkan pada hasil glob. Ini adalah fitur Zsh yang memungkinkan Anda "mengiris" hasil glob seperti mengiris array.

- `[1]` = elemen pertama (file teratas setelah sorting)
- `[1,5]` = elemen 1 sampai 5
- `[-1]` = elemen terakhir
- `[2,-1]` = elemen kedua sampai terakhir

Kombinasi `om[1]` adalah idiom paling terkenal: "urutkan berdasarkan mtime ascending (terlama dulu), lalu ambil elemen pertama" — tapi tunggu, itu memberikan **file terlama**, bukan terbaru. Untuk file terbaru, gunakan `Om[1]`:

```bash
ls *(Om[1])     # File TERBARU (sort descending, ambil pertama)
ls *(om[1])     # File TERLAMA (sort ascending, ambil pertama)
```

**Penting**: Banyak orang salah mengira `om[1]` = terbaru. Sebenarnya `om` = ascending (terlama dulu), jadi `om[1]` = terlama. Untuk terbaru, gunakan `Om[1]` (capital O). 

**Y qualifier — short-circuit mode:**

Qualifier `Y` (bukan `y`) adalah qualifier pembatasan yang **berbeda** dari `[1,n]`. Perbedaannya:

- `[1,n]` — **mengumpulkan semua** hasil, **mengurutkan**, lalu **memotong** n pertama. Bekerja setelah semua file ditemukan.
- `Yn` — **berhenti mencari** setelah menemukan n file. Ini lebih cepat untuk direktori besar karena tidak perlu memproses semua file terlebih dahulu.

```bash
ls *(NY1)       # Berhenti setelah 1 file ditemukan (tidak peduli urutan)
ls *(.omY1)     # Urutkan berdasarkan mtime, tapi berhenti setelah 1? 
                 # Sebenarnya Y dan o bisa digabung: Yn implies oN jika tidak ada o.
```

Dokumentasi Zsh menyatakan: "Yn enables short-circuit mode: the pattern will expand to at most n filenames. If more than n matches exist, only the first n matches in directory traversal order will be considered. Implies oN when no oc qualifier is used." 

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`o`** | Order — sorting ascending (naik). |
| **`O`** | Order — sorting descending (turun). |
| **`on`** | Sort by name. |
| **`oL`** | Sort by size (length). |
| **`om`** | Sort by modification time. |
| **`oa`** | Sort by access time. |
| **`oc`** | Sort by inode change time. |
| **`od`** | Sort by depth (kedalaman direktori). |
| **`[1,n]`** | Array subscript — slice hasil glob. |
| **`Yn`** | Short-circuit: berhenti setelah n file ditemukan. |
| **`NUMERIC_GLOB_SORT`** | Opsi yang membuat sorting `n` (numeric) alih-alih lexical. |

### Diagram Alur: Sorting → Limit → Hasil

```bash
Pola: *(.Om[1,3])   ← "3 file reguler terbaru"

Langkah:
  1. Glob: *  → [a.txt, b.txt, c.txt, d.txt, e.txt]
  2. Filter: .  → [a.txt, b.txt, c.txt, d.txt, e.txt] (semua file reguler)
  3. Sort: Om  → urutkan berdasarkan mtime descending (terbaru dulu)
       → [e.txt (baru saja), c.txt (1 jam), b.txt (1 hari),
          d.txt (3 hari), a.txt (1 minggu)]
  4. Slice: [1,3] → ambil elemen 1..3
       → [e.txt, c.txt, b.txt]

Hasil: e.txt c.txt b.txt
```

> **Diagram alur [Glob → Filter → Sort → Slice → Hasil] dengan contoh konkret akan sangat membantu di sini.** Diagram ini memperjelas urutan operasi qualifiers.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Glob qualifiers ukuran/waktu (Sub-bagian 4).
- **Prasyarat untuk**: Negasi dan exclusion (Sub-bagian 6) — kombinasi sorting dengan exclusion adalah pola umum.
- **Terhubung ke**: Modul 3.2 (Completion) — completion untuk perintah yang menggunakan glob qualifiers.
- **Terhubung ke**: Modul 3.3 — `NUMERIC_GLOB_SORT` diatur di `.zshrc`.

### Sumber Referensi

- Zsh Manual — Glob Qualifiers (sorting): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- Zsh Manual — `Yn` short-circuit: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- Zsh Manual — Array Subscripts: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Array-Subscripts

### Tips dan Praktik Terbaik

1. **Hafal `Om[1]` = terbaru, `om[1]` = terlama**: Ini adalah sumber kebingungan terbesar. Gunakan huruf kapital `O` untuk "terbaru/terbesar" (descending).
2. **Gunakan `oL`/`OL` untuk file besar**: `*(OL[1,10])` adalah cara tercepat mendapatkan 10 file terbesar di direktori.
3. **`Y` untuk performa**: Jika Anda hanya butuh 5 file dan tidak peduli urutannya, gunakan `*(NY5)` — ini berhenti setelah 5 file, menghemat waktu di direktori besar.
4. **Kombinasikan dengan recursive globbing**: `**/*.log(Om[1,3])` = 3 file log terbaru secara rekursif. Ini adalah idiom yang sangat kuat.
5. **Hati-hati dengan `om` tanpa `N`**: Jika tidak ada file yang cocok, `NOMATCH` akan error. Selalu tambahkan `N` untuk keamanan: `*(N.om[1,5])`.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `*(om[1])` memberikan file terlama, bukan terbaru | `om` = ascending (terlama dulu) | Gunakan `*(Om[1])` untuk terbaru |
| `*(om[1,5])` error "no matches found" | Tidak ada file yang cocok dan `NOMATCH` aktif | Tambahkan `N`: `*(Nom[1,5])` |
| `*(n)` tidak numeric sort | Opsi `NUMERIC_GLOB_SORT` tidak aktif | `setopt NUMERIC_GLOB_SORT` atau gunakan `*(on)` dengan opsi aktif |
| `Yn` tidak berfungsi di dalam qualifier lain | Urutan qualifier penting; `Y` harus muncul sebelum `o` | `*(.NY5)` atau `*(.Y5)` — `N` dulu, lalu `Y` |
| Sorting `od` (depth) tidak berfungsi tanpa `**` | `od` memerlukan recursive globbing | Gunakan `**/*(od)` — sortir berdasarkan kedalaman |

### Latihan Praktis

```bash
cd /tmp/zsh-glob-lab

# Buat beberapa file dengan ukuran dan waktu berbeda
for i in {1..5}; do
  dd if=/dev/zero of=file$i.dat bs=1024 count=$((i*100)) 2>/dev/null
  touch -t 2025010${i}0000 file$i.dat
done

# Latihan 1: Sorting ukuran
ls *(oL)                    # Terkecil dulu
ls *(OL)                    # Terbesar dulu

# Latihan 2: Sorting waktu
ls *(om)                    # Terlama dulu
ls *(Om)                    # Terbaru dulu

# Latihan 3: Pembatasan
ls *(Om[1])                 # 1 file terbaru
ls *(Om[1,3])               # 3 file terbaru
ls *(OL[1,2])               # 2 file terbesar

# Latihan 4: Kombinasi recursive
ls **/*.dat(Om[1,3])        # 3 file .dat terbaru secara rekursif

# Latihan 5: Numeric sort
ls *(n)                     # file1, file2, ..., file5 (numeric)
ls *(on)                    # Tanpa NUMERIC_GLOB_SORT: file1, file2, file3, file4, file5 (lexical juga sama)
                            # Coba buat file10.dat, file2.dat untuk melihat bedanya
```

---

## 6. Negasi dan Exclusion Patterns

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini mengajarkan cara **mengecualikan** file dari hasil glob. Jika sub-bagian sebelumnya adalah tentang "memilih", sub-bagian ini adalah tentang "menolak". Negasi adalah alat yang sangat kuat karena dalam praktik nyata, kita sering ingin *"semua file kecuali ini"*.

Dalam kurikulum, ini adalah **pelengkap** untuk semua sub-bagian sebelumnya. Anda bisa memiliki pola yang sangat spesifik untuk file yang ingin Anda ambil, dan kemudian menambahkan negasi untuk mengecualikan pengecualian.

### Konsep Kunci & Filosofi Mendalam

Filosofi negasi: **"Definisikan dengan apa yang bukan."** Kadang lebih mudah mengatakan "semua kecuali .tmp" daripada mendaftar semua ekstensi yang diizinkan. Negasi memberi Anda kekuatan ekspresif itu.

Zsh menyediakan dua operator negasi utama, keduanya memerlukan `setopt EXTENDED_GLOB`:
- `^` — Negasi sederhana: "cocokkan apa pun **kecuali** pola ini."
- `~` — Exclusion: "cocokkan pola A, **tetapi kecualikan** pola B."

Perbedaan filosofisnya:
- `^pat` = *"Apa pun selain pat"* — ini adalah operator **unary** (satu operand).
- `patA~patB` = *"patA, tapi bukan patB"* — ini adalah operator **binary** (dua operand).

`^` adalah "aku tahu persis apa yang tidak kuinginkan." `~` adalah "aku tahu apa yang kuinginkan, tapi ada beberapa yang tidak kuinginkan dari itu."

**Mengapa memerlukan `EXTENDED_GLOB`?** Karena `^` dan `~` adalah karakter yang sering muncul dalam nama file (misalnya file dengan tanda `^` di namanya). Mengaktifkan `EXTENDED_GLOB` adalah "kontrak" yang menyatakan: "Saya sadar bahwa karakter-karakter ini sekarang memiliki makna khusus."

### Sintaks Dasar dan Contoh

```bash
setopt EXTENDED_GLOB    # Wajib untuk ^ dan ~

# === NEGASI SEDERHANA (^) ===
ls ^*.txt               # Semua file KECUALI .txt
ls ^*.tmp               # Semua file KECUALI .tmp
ls ^*test*              # Semua file KECUALI yang mengandung "test"
ls ^.*                 # Semua file KECUALI yang diawali titik (hidden)
ls ^Makefile            # Semua file KECUALI "Makefile"

# === EXCLUSION BINARY (~) ===
ls *.c~bar.c            # Semua .c KECUALI bar.c
ls *.c~f*               # Semua .c KECUALI yang diawali f
ls *.txt~*test*         # Semua .txt KECUALI yang mengandung "test"
ls **/*.log~**/old/*    # Semua .log KECUALI yang ada di direktori old/

# === KOMBINASI DENGAN GLOB QUALIFIERS ===
ls *(.x)~*.sh           # File reguler executable, KECUALI .sh
ls *(/)~^src            # Direktori, KECUALI yang bernama "src"

# === EXCLUDE MULTIPLE PATTERNS ===
ls ^*.{jpg,png}         # Exclude .jpg DAN .png (brace expansion)
ls *~*test*~*.tmp       # Kecualikan test DAN tmp
```

**Penjelasan mendalam tentang `^` vs `~`:**

Dari FAQ Zsh (diterjemahkan dari mailing list oleh Peter Stephenson):

> `^` berarti "apa pun kecuali pola yang mengikutinya". Anda bisa membayangkan `^pat` seperti `*` kecuali bahwa ia tidak cocok dengan `pat`. Jadi, `myfile^.txt` cocok dengan apa pun yang diawali `myfile` kecuali `myfile.txt`. Karena bekerja dengan pola, bukan hanya string, `myfile^*.c` cocok dengan apa pun yang diawali `myfile` kecuali yang berakhiran `.c` — sehingga cocok dengan `myfile1.h` tetapi tidak `myfile1.c`.
>
> Juga seperti `*`, `^` tidak cocok melintasi direktori jika Anda mencocokkan file saat globbing. Jadi `^dir1/^file1` cocok dengan subdirektori apa pun dari direktori saat ini kecuali yang bernama `dir1`, dan di dalam direktori apa pun yang cocok, ia memilih file apa pun kecuali yang bernama `file1`. 

**Contoh perbedaan `^` dan `~`:**

```bash
# Skenario: Ada file: a.c, b.c, c.h, d.h

ls ^*.c                 # b.c? Tidak — hasil: c.h, d.h (semua kecuali .c)
ls *.c~a.c              # Hasil: b.c (semua .c kecuali a.c)

# Skenario: Ada file: foo1.c, foo2.h, bar1.c, bar2.h

ls foo^*.c              # foo2.h (foo + apa pun kecuali .c)
ls foo*.c~foo1.c        # foo2.h? Tidak — foo*.c hanya cocok .c, jadi hasil: (kosong)
                        # karena foo2.h bukan .c
```

**Penting**: `^` adalah operator yang "rakus" — ia mengambil **semua yang mengikutinya** sebagai argumen. Jadi `^*.c` berarti "apa pun kecuali *.c". Jika Anda ingin menggabungkan beberapa negasi, gunakan tanda kurung: `^(pat1|pat2)` dengan `EXTENDED_GLOB`.

**Brace expansion dengan exclusion:**

```bash
ls ^*.{jpg,png}         # Ini bekerja karena brace expansion terjadi SEBELUM globbing
# Setara dengan: ls ^*.jpg ^*.png — tapi tunggu, itu tidak benar.
# Sebenarnya: brace expansion menghasilkan: ^*.jpg ^*.png
# Lalu globbing dilakukan pada masing-masing: semua kecuali .jpg, dan semua kecuali .png
# Hasilnya: file yang TIDAK .jpg DAN TIDAK .png? Tidak — hasilnya adalah UNION.
# Karena dua pola glob menghasilkan daftar terpisah yang digabungkan.

# Untuk "kecuali .jpg DAN .png" yang benar, gunakan:
ls ^*.(jpg|png)         # Dengan EXTENDED_GLOB dan grouping
```

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`^` (Negasi)** | Operator unary: "apa pun kecuali pola ini". Memerlukan `EXTENDED_GLOB`. |
| **`~` (Exclusion)** | Operator binary: "pola A, kecuali pola B". Memerlukan `EXTENDED_GLOB`. |
| **`EXTENDED_GLOB`** | Opsi Zsh yang mengaktifkan `^`, `~`, `#`, dan fitur pattern matching lanjutan. |
| **Brace Expansion** | Ekspansi `{a,b}` menjadi `a b`. Terjadi **sebelum** globbing. |
| **Grouping** | Menggunakan `(...|...)` untuk menggabungkan pola. Memerlukan `EXTENDED_GLOB`. |

### Diagram Alur: Cara Kerja `^` dan `~`

```bash
Contoh: ls ^*.tmp   (setopt EXTENDED_GLOB)

Langkah:
  1. Zsh membaca direktori: [a.txt, b.tmp, c.log, d.tmp, e.txt]
  2. Pattern ^*.tmp berarti: "cocokkan semua yang BUKAN *.tmp"
  3. Untuk setiap file, cek apakah cocok dengan *.tmp:
       a.txt → bukan .tmp → LOLOS ✅
       b.tmp → cocok .tmp → GAGAL ❌
       c.log → bukan .tmp → LOLOS ✅
       d.tmp → cocok .tmp → GAGAL ❌
       e.txt → bukan .tmp → LOLOS ✅
  4. Hasil: [a.txt, c.log, e.txt]

Contoh: ls *.txt~*test*   (setopt EXTENDED_GLOB)

Langkah:
  1. Filter pertama: *.txt → [a.txt, b.txt, test1.txt, mytest.txt]
  2. Filter kedua: ~*test* → KECUALIKAN yang mengandung "test"
  3. Hasil: [a.txt, b.txt]
```

> **Diagram Venn [lingkaran A = semua file, lingkaran B = *.tmp, area yang diarsir = ^*.tmp] akan sangat membantu di sini.** Diagram Venn adalah cara terbaik untuk memvisualisasikan negasi.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Semua sub-bagian sebelumnya di Modul 3.1.
- **Prasyarat untuk**: Modul 3.2 (Completion) — beberapa completion function menggunakan pattern exclusion untuk menyaring saran.
- **Terhubung ke**: Modul 3.3 — `EXTENDED_GLOB` diatur di `.zshrc`.

### Sumber Referensi

- Zsh Manual — `EXTENDED_GLOB`: https://zsh.sourceforge.io/Doc/Release/Options.html#index-EXTENDEDGLOB
- Zsh Manual — Pattern Exclusion: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Operators 
- Zsh FAQ — `^` vs `~`: https://zsh.sourceforge.io/FAQ/zshfaq03.html#l37 
- An Introduction to the Z Shell — Exclusion: https://zsh.sourceforge.io/Intro/intro.html 

### Tips dan Praktik Terbaik

1. **Selalu `setopt EXTENDED_GLOB` di `.zshrc`**: Karena `^` dan `~` sangat berguna, dan tanpa `EXTENDED_GLOB` keduanya tidak berfungsi.
2. **Gunakan `^` untuk "semua kecuali"**: `^*.tmp` lebih ringkas daripada mendaftar semua ekstensi yang diizinkan.
3. **Gunakan `~` untuk "spesifik kecuali"**: `*.c~bar.c` lebih jelas daripada `^*bar.c` yang bisa membingungkan.
4. **Hati-hati dengan urutan**: `*.c~^bar.c` berbeda dari `*.c~bar.c`. Yang pertama: "semua .c kecuali yang bukan bar.c" = "hanya bar.c". Ini jarang yang diinginkan.
5. **Kombinasikan dengan qualifiers**: `*(.x)~*.sh` = file executable reguler kecuali shell script.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `^*.tmp` tidak berfungsi | `EXTENDED_GLOB` belum aktif | `setopt EXTENDED_GLOB` |
| `*.c~bar.c` tidak mengecualikan | `~` dianggap literal (bukan operator) | Pastikan `EXTENDED_GLOB` aktif |
| `^*.(jpg|png)` tidak berfungsi | Grouping `(...|...)` memerlukan `EXTENDED_GLOB` | Aktifkan `EXTENDED_GLOB` |
| `^` mencocokkan terlalu banyak | `^` mengambil semua yang mengikutinya sebagai argumen | Gunakan tanda kurung untuk membatasi: `^(pat1|pat2)` |
| `~` di dalam qualifier dianggap sebagai exclusion | Qualifier dan pattern exclusion berbeda level | Untuk exclude di dalam qualifier, gunakan `^` di dalam qualifier: `*(^F)` |

### Latihan Praktis

```bash
cd /tmp/zsh-glob-lab
setopt EXTENDED_GLOB

# Buat file untuk latihan
touch a.txt b.tmp c.log d.tmp e.txt test1.txt mytest.txt
touch foo1.c foo2.h bar1.c bar2.h

# Latihan 1: Negasi sederhana
ls ^*.tmp                   # Semua kecuali .tmp
ls ^*test*                  # Semua kecuali yang mengandung "test"
ls ^.*                      # Semua kecuali hidden

# Latihan 2: Exclusion binary
ls *.c~foo1.c               # Semua .c kecuali foo1.c
ls *.txt~*test*             # Semua .txt kecuali yang mengandung "test"
ls *.txt~*.tmp              # (tidak ada .txt yang .tmp, tapi lihat hasilnya)

# Latihan 3: Kombinasi dengan qualifier
ls *(.r)~*.tmp              # File reguler readable, kecuali .tmp

# Latihan 4: Grouping
ls ^*.(tmp|log)             # Semua kecuali .tmp DAN .log (dengan EXTENDED_GLOB)
```

---

## 7. Opsi `NULL_GLOB`, `NOMATCH`, dan `GLOB_STAR_SHORT`

*(Sub-bagian tambahan dari audit — tidak ada di daftar isi asli, tetapi penting untuk mencegah lompatan pemahaman)*

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini membahas **opsi shell** yang mengontrol perilaku globbing secara global. Ini bukan qualifier (yang berlaku per-pola), melainkan opsi (yang berlaku untuk seluruh sesi shell). Mengapa penting? Karena tanpa memahami opsi ini, Anda akan sering mendapatkan error "no matches found" yang membingungkan, atau perilaku globbing yang tidak sesuai ekspektasi.

Dalam kurikulum, sub-bagian ini adalah **lapisan konfigurasi** yang menghubungkan Modul 3.1 dengan Modul 3.3 (`.zshrc`). Opsi-opsi ini biasanya diatur di `.zshrc` untuk perilaku globbing yang diinginkan.

### Konsep Kunci & Filosofi Mendalam

Filosofinya: **"Apa yang harus terjadi ketika tidak ada yang cocok?"** Ini adalah pertanyaan filosofis yang dalam tentang error handling. Ada tiga jawaban:
1. **Error** (`NOMATCH` — default): Shell berhenti dan memberi tahu Anda bahwa tidak ada yang cocok.
2. **Hilang** (`NULL_GLOB`): Shell mengganti pola dengan string kosong, dan perintah dijalankan tanpa argumen.
3. **Tetap literal** (`NOMATCH` + quoting): Shell mempertahankan pola sebagai string literal.

Zsh memilih `NOMATCH` sebagai default karena **prinsip keamanan**: jika Anda mengetik `rm *.tmp` dan tidak ada file `.tmp`, Anda **ingin** mengetahui bahwa tidak ada yang dihapus, bukan menjalankan `rm` tanpa argumen (yang mungkin memiliki perilaku berbahaya). Ini berbeda dari Bash yang secara default mempertahankan pola literal.

**GLOB_STAR_SHORT** adalah opsi "sintaksis" yang mengubah cara `**` diperlakukan: tanpa opsi ini, `**.c` tidak berarti apa-apa khusus (tidak sama dengan `**/*.c`); dengan opsi ini, `**.c` adalah singkatan dari `**/*.c`.

### Sintaks Dasar dan Contoh

```bash
# === NOMATCH (default) ===
ls *.nonexistent
# → zsh: no matches found: *.nonexistent

# === NULL_GLOB ===
setopt NULL_GLOB
ls *.nonexistent
# → (tidak ada output, perintah dijalankan tanpa argumen)

# Kembalikan ke NOMATCH
unsetopt NULL_GLOB

# === Per-pattern override ===
ls *(N)                     # Qualifier N = NULL_GLOB untuk pola ini saja
ls *.nonexistent(N)         # Tidak error, menghilang

# === GLOB_STAR_SHORT ===
setopt GLOB_STAR_SHORT
ls **.c                     # Setara dengan **/*.c
ls ***.c                    # Setara dengan ***/*.c (mengikuti symlink)
unsetopt GLOB_STAR_SHORT

# === NOMATCH vs NULL_GLOB dalam praktik ===
# Skenario: direktori kosong
setopt NULL_GLOB
rm *.tmp                    # Aman: tidak ada yang dihapus, tidak ada error
unsetopt NULL_GLOB

# Skenario: Anda ingin error jika tidak ada file
setopt NOMATCH              # default
rm *.tmp                    # Error jika tidak ada .tmp — ini yang Anda inginkan
```

**Penjelasan mendalam tentang `N` qualifier vs `NULL_GLOB` opsi:**

- `setopt NULL_GLOB` — global: semua pola glob di shell ini akan menghilang jika tidak cocok.
- `*(N)` — lokal: hanya pola ini yang menghilang jika tidak cocok.

Kapan menggunakan yang mana?
- **Global** (`NULL_GLOB`): Jika Anda ingin perilaku "aman" secara default di seluruh sesi. Cocok untuk shell scripting di mana Anda tidak ingin error karena tidak ada file.
- **Lokal** (`(N)`): Jika Anda hanya ingin perilaku ini untuk pola tertentu, tetapi tetap ingin error untuk pola lain. Ini adalah praktik terbaik dalam scripting karena eksplisit.

**GLOB_STAR_SHORT** adalah opsi yang relatif jarang diketahui. Dokumentasi Zsh menyatakan:

> "Even shorter forms are available when the option GLOB_STAR_SHORT is set. In that case if no / immediately follows a ** or *** they are treated as if both a / plus a further * are present. Hence: setopt GLOBSTARSHORT; ls -ld -- **.c is equivalent to ls -ld -- **/*.c" 

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`NOMATCH`** | Opsi default: error jika pola glob tidak menemukan hasil. |
| **`NULL_GLOB`** | Opsi: pola glob yang gagal menghilang (bukan error). |
| **`(N)` qualifier** | NULL_GLOB untuk pola tertentu saja. |
| **`GLOB_STAR_SHORT`** | Opsi: `**` tanpa `/` diperlakukan sebagai `**/`. |
| **`N` qualifier** | Sama dengan `NULL_GLOB` tetapi per-pattern. Juga mempengaruhi `om[1]` dan sejenisnya. |
| **`D` qualifier** | Sama dengan `GLOB_DOTS` tetapi per-pattern: sertakan file tersembunyi. |

### Diagram Alur: NOMATCH vs NULL_GLOB

```bash
Anda mengetik: ls *.tmp

Ada file .tmp di direktori?
├── YA → Tampilkan file
└── TIDAK → 
    ├── NOMATCH (default) → Error: "no matches found: *.tmp"
    ├── NULL_GLOB → Perintah dijalankan tanpa argumen: ls
    └── Quoting → Pola dipertahankan literal: ls '*.tmp'
```

> **Diagram pohon keputusan [Ada file? → YA/TIDAK → NOMATCH/NULL_GLOB] akan sangat membantu di sini.** Diagram ini memperjelas perilaku yang berbeda.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Semua sub-bagian sebelumnya (globbing dasar, qualifiers).
- **Prasyarat untuk**: Modul 3.3 (Konfigurasi) — opsi ini diatur di `.zshrc`.
- **Terhubung ke**: Modul 3.2 (Completion) — completion function sering menggunakan `(N)` untuk menghindari error.

### Sumber Referensi

- Zsh Manual — Options: https://zsh.sourceforge.io/Doc/Release/Options.html#Expansion-and-Globbing
- Zsh Manual — `GLOB_STAR_SHORT`: https://zsh.sourceforge.io/Doc/Release/Options.html#index-GLOBSTARSHORT
- Zsh Manual — `NULL_GLOB`: https://zsh.sourceforge.io/Doc/Release/Options.html#index-NULLGLOB

### Tips dan Praktik Terbaik

1. **Jangan set `NULL_GLOB` secara global kecuali Anda tahu risikonya**: `rm *(N)` bisa menghapus lebih banyak dari yang Anda kira jika pola tidak cocok seperti yang diharapkan.
2. **Gunakan `(N)` secara lokal**: Ini adalah praktik terbaik untuk scripting — eksplisit dan tidak mengubah perilaku global.
3. **`setopt GLOB_STAR_SHORT` jika Anda sering menulis `**/`**: Ini menghemat beberapa ketikan dan membuat pola lebih ringkas.
4. **Kombinasikan `(N)` dengan `(D)`**: `*(ND.)` = file reguler, termasuk tersembunyi, tanpa error jika kosong.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `rm *.tmp` error "no matches found" | `NOMATCH` aktif (default) dan tidak ada .tmp | Gunakan `rm *.tmp(N)` atau `setopt NULL_GLOB` |
| `**(N)` tidak berfungsi sebagai `**/*(N)` | `GLOB_STAR_SHORT` belum aktif | `setopt GLOB_STAR_SHORT` atau tulis `**/*(N)` |
| `NULL_GLOB` membuat script menghapus file yang salah | Pola glob menghilang, perintah berjalan tanpa argumen | Gunakan `(N)` per-pattern, bukan global |
| `*(N)` tidak menghilangkan error untuk `om[1]` | `N` hanya berlaku untuk glob, bukan untuk subscript | `N` juga mempengaruhi `om[1]` — jika tidak ada file, hasilnya kosong |

### Latihan Praktis

```bash
cd /tmp/zsh-glob-lab

# Latihan 1: NOMATCH vs NULL_GLOB
ls *.nonexistent             # Error (NOMATCH default)
setopt NULL_GLOB
ls *.nonexistent             # Tidak error, kosong
unsetopt NULL_GLOB

# Latihan 2: Per-pattern N
ls *.nonexistent(N)          # Tidak error
ls *.txt(N)                  # Jika ada .txt, tampil; jika tidak, kosong

# Latihan 3: GLOB_STAR_SHORT
setopt GLOB_STAR_SHORT
ls **.txt                    # Sama dengan **/*.txt
unsetopt GLOB_STAR_SHORT

# Latihan 4: Kombinasi N dengan om[1]
ls *.dat(Nom[1])             # 1 file .dat terbaru, atau kosong jika tidak ada
```

---

## 8. Glob Qualifiers sebagai Saklar Lokal — `N` dan `D`

*(Sub-bagian tambahan dari audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

Qualifier `N` dan `D` adalah "saklar lokal" yang mengubah perilaku globbing untuk **satu pola tertentu**. Mereka bukan filter (seperti `.` atau `/`), melainkan **pengubah perilaku**:
- `N` — NULL_GLOB lokal: pola menghilang jika tidak cocok.
- `D` — GLOB_DOTS lokal: sertakan file tersembunyi.

Dalam kurikulum, sub-bagian ini melengkapi Sub-bagian 7 dengan memberikan kontrol per-pola. Ini adalah praktik terbaik dalam scripting: **jangan mengubah perilaku global jika Anda hanya membutuhkan perubahan untuk satu pola**.

### Konsep Kunci & Filosofi Mendalam

Filosofi desain Zsh adalah **"kontrol granular"**. Daripada memaksa Anda memilih antara perilaku global atau tidak sama sekali, Zsh memberikan qualifier yang mengubah perilaku **hanya untuk pola itu**. Ini sejalan dengan prinsip Unix: *"Lakukan satu hal dengan baik, dan berikan kontrol kepada pengguna."*

`N` dan `D` adalah contoh sempurna dari filosofi ini:
- `N` — "Saya ingin pola ini aman jika tidak ada hasil."
- `D` — "Saya ingin pola ini juga melihat file tersembunyi."

Keduanya bisa dikombinasikan: `*(ND.)` = "file reguler, termasuk tersembunyi, tanpa error jika kosong."

### Sintaks Dasar dan Contoh

```bash
# === N — NULL_GLOB lokal ===
ls *.txt(N)                 # Tidak error jika tidak ada .txt
ls *(N)                     # Tidak error jika direktori kosong
ls *(.Nom[1])               # File reguler, no error, 1 terbaru

# === D — GLOB_DOTS lokal ===
ls *(D)                     # Semua file TERMASUK yang tersembunyi
ls *(D.)                    # File reguler termasuk tersembunyi
ls **(D/)                   # Semua direktori termasuk tersembunyi

# === KOMBINASI ===
ls *(ND.)                   # File reguler, termasuk hidden, no error
ls *(ND/)                   # Direktori, termasuk hidden, no error
ls *(N.D)                   # Sama (urutan tidak penting)
```

**Penjelasan mendalam tentang `N`:**

Qualifier `N` **juga** mempengaruhi subscript `[1]`, `[1,5]`, dan sejenisnya. Jika Anda menulis `*(Nom[1])` dan tidak ada file yang cocok, `N` mencegah error, dan hasilnya adalah kosong (bukan error). Tanpa `N`, `*(om[1])` akan error jika direktori kosong.

Ini sangat penting dalam scripting: Anda sering ingin "ambil file terbaru, tapi jangan error jika tidak ada."

**Penjelasan mendalam tentang `D`:**

Secara default, Zsh **tidak** mencocokkan file yang diawali dengan titik (`.`) menggunakan `*`. Ini adalah perilaku yang diwarisi dari shell tradisional dan dianggap "aman" karena file tersembunyi biasanya adalah file konfigurasi yang tidak ingin Anda sentuh secara tidak sengaja.

Qualifier `D` mengubah ini untuk pola tertentu: `*(D)` = "semua file, termasuk yang tersembunyi."

**Mengapa `D` bukan `GLOB_DOTS`?** Karena `GLOB_DOTS` adalah opsi global. Jika Anda hanya ingin melihat file tersembunyi untuk satu pola, menggunakan `D` lebih baik.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`N` qualifier** | NULL_GLOB lokal: pola menghilang jika tidak cocok. Juga mempengaruhi subscript. |
| **`D` qualifier** | GLOB_DOTS lokal: sertakan file tersembunyi (yang diawali titik). |
| **`GLOB_DOTS`** | Opsi global: semua pola glob akan mencocokkan file tersembunyi. |
| **`NULL_GLOB`** | Opsi global: semua pola glob yang gagal akan menghilang. |
| **Hidden file** | File yang diawali dengan `.` (titik), seperti `.zshrc`, `.gitconfig`. |

### Diagram Alur: `N` dan `D` dalam Aksi

```bash
Direktori: [.hidden.txt, a.txt, b.txt, .git/, subdir/]

# Tanpa qualifier
ls *          → a.txt b.txt subdir/     (hidden tidak muncul)

# Dengan D
ls *(D)       → .hidden.txt a.txt b.txt .git/ subdir/    (hidden muncul)

# Dengan N (dan tidak ada file yang cocok)
ls *.nonexistent(N)   → (kosong, tidak error)

# Kombinasi
ls *(ND.)     → .hidden.txt a.txt b.txt  (file reguler + hidden, no error)
```

> **Tabel visual [Qualifier, Efek Global vs Lokal, Contoh] akan sangat membantu di sini.** Tabel ini memperjelas perbedaan antara opsi global (`setopt`) dan qualifier lokal.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 7 (opsi globbing).
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — `GLOB_DOTS` dan `NULL_GLOB` diatur di `.zshrc`.
- **Terhubung ke**: Modul 3.2 (Completion) — completion function sering menggunakan `(N)` dan `(D)`.

### Sumber Referensi

- Zsh Manual — Glob Qualifiers (N dan D): https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers 
- Zsh Manual — `GLOB_DOTS`: https://zsh.sourceforge.io/Doc/Release/Options.html#index-GLOBDOTS
- Zsh Manual — `NULL_GLOB`: https://zsh.sourceforge.io/Doc/Release/Options.html#index-NULLGLOB

### Tips dan Praktik Terbaik

1. **Selalu gunakan `(N)` dalam script**: Jika Anda menulis script yang menggunakan glob, tambahkan `(N)` untuk mencegah error yang tidak perlu.
2. **`(D)` untuk file konfigurasi**: Ketika Anda ingin melihat file seperti `.zshrc`, `.gitconfig`, gunakan `*(D)`.
3. **Kombinasikan `(ND.)` untuk "file reguler, termasuk hidden, tanpa error"**: Ini adalah pola yang sangat berguna dalam praktik sehari-hari.
4. **Jangan bingung `N` dengan `^`**: `N` = "no error if empty"; `^` = "exclude pattern". Keduanya berbeda.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `*(N)` masih error | `N` ditulis setelah qualifier lain yang menyebabkan error | Letakkan `N` di awal qualifiers: `*(N.om[1])` |
| `*(D)` tidak menemukan file tersembunyi | `D` hanya berlaku jika ada file tersembunyi | Periksa apakah direktori benar-benar memiliki file tersembunyi |
| `*(N)` dan `om[1]` bersama-sama tidak berfungsi | `N` mempengaruhi subscript, tetapi urutan qualifier penting | `*(Nom[1])` — `N` dulu, lalu `om[1]` |
| `D` dianggap sebagai pattern, bukan qualifier | `D` di dalam `(...)` dianggap qualifier, tetapi jika tidak ada qualifier lain, bisa ambigu | Pastikan `D` ada di dalam tanda kurung yang benar: `*(D)` bukan `*D` |

### Latihan Praktis

```bash
cd /tmp/zsh-glob-lab

# Latihan 1: N
ls *.nonexistent(N)          # Tidak error
ls *.txt(N)                  # Munculkan .txt jika ada

# Latihan 2: D
ls *(D)                      # Semua termasuk hidden
ls *(D.)                     # File reguler termasuk hidden

# Latihan 3: Kombinasi
ls *(ND.)                    # File reguler, hidden, no error
ls *(ND/)                    # Direktori, hidden, no error

# Latihan 4: Praktik script
# Buat script yang aman
cat > /tmp/safe_list.zsh << 'EOF'
#!/usr/bin/env zsh
# Ambil 3 file .log terbaru, atau kosong jika tidak ada
files=(**/*.log(Nom[1,3]))
if (( ${#files} )); then
    print -l "File log terbaru:"
    print -l "${files[@]}"
else
    print "Tidak ada file log ditemukan."
fi
EOF
chmod +x /tmp/safe_list.zsh
/tmp/safe_list.zsh
```

---

## Ringkasan Modul 3.1

| Sub-bagian | Fokus | Qualifier Utama |
|------------|-------|-----------------|
| 1 | Wildcard dasar | `*`, `?`, `[...]`, `[^...]` |
| 2 | Recursive globbing | `**/`, `***/`, `GLOB_STAR_SHORT` |
| 3 | Tipe file & permission | `.`, `/`, `@`, `x`, `r`, `w`, `X`, `R`, `W`, dll. |
| 4 | Ukuran, waktu, kepemilikan | `L`, `m`, `a`, `c`, `U`, `G`, `u`, `g` |
| 5 | Sorting & pembatasan | `o`, `O`, `[1,n]`, `Y`, `n` |
| 6 | Negasi & exclusion | `^`, `~`, `EXTENDED_GLOB` |
| 7 | Opsi global *(tambahan)* | `NULL_GLOB`, `NOMATCH`, `GLOB_STAR_SHORT` |
| 8 | Saklar lokal *(tambahan)* | `N`, `D` |

---

## Hubungan Modul 3.1 dengan Modul Berikutnya

Modul 3.1 (Globbing) adalah **fondasi** untuk Modul 3.2 (Completion). Sistem completion Zsh menggunakan mekanisme pattern matching yang sama untuk memahami konteks command line dan menawarkan saran. Pemahaman yang kuat tentang glob qualifiers akan sangat membantu ketika Anda menulis completion function sendiri, karena Anda akan sering menggunakan `_files`, `_directories`, dan helper completion lainnya yang menerima glob qualifiers sebagai argumen.

Modul 3.1 juga **terhubung erat** dengan Modul 3.3 (Konfigurasi). Opsi seperti `EXTENDED_GLOB`, `NULL_GLOB`, `GLOB_DOTS`, dan `NUMERIC_GLOB_SORT` adalah opsi shell yang biasanya diatur di `.zshrc`. Tanpa memahami opsi-opsi ini, konfigurasi `.zshrc` Anda tidak akan optimal.

---

## Referensi Lengkap Modul 3.1

1. **Zsh Manual — Expansion**: https://zsh.sourceforge.io/Doc/Release/Expansion.html
2. **Zsh Manual — Options**: https://zsh.sourceforge.io/Doc/Release/Options.html
3. **An Introduction to the Z Shell**: https://zsh.sourceforge.io/Intro/intro.html
4. **Zsh FAQ — Pattern Matching**: https://zsh.sourceforge.io/FAQ/zshfaq03.html
5. **Glob Qualifier Examples (Mailing List)**: https://zsh.org/mla/users/2014/msg00517.html
6. **Recursive Globbing Discussion**: https://www.zsh.org/mla/users/2004/msg00467.html
7. **Origin of Globstar (Mergify)**: https://mergify.com/blog/origin-and-evolution-of-the-globstar
8. **Zsh: Tab Complete Glob Qualifiers (Adam Johnson)**: https://adamj.eu/tech/2026/10/02/zsh-tab-complete-glob-qualifiers/

---

## ✅ Daftar yang telah diselesaikan

Materi Modul 3.1 di atas sudah mencakup seluruh sub-bagian dari :

- Inisialisasi completion dengan `compinit`
- Konfigurasi `zstyle` untuk completion
- Completion untuk command yang ada (`compdef`)
- Menulis completion function sendiri
- Context-sensitive completion
- Menu selection dan matcher

---

# Modul 3.2: Sistem Completion yang Dapat Diprogram

**Level:** Menengah | **Durasi:** ~8–10 jam | **Prasyarat:** Modul 3.1 (Globbing dan Pattern Matching)


## Daftar Isi Internal (Mini-Daftar Isi)

1. **Inisialisasi Completion System: `compinit`** — fondasi seluruh sistem completion
2. **Konfigurasi dengan `zstyle`** — kontrol terpusat atas perilaku completion
3. **Context dan Tag: Memahami "Di Mana Kita Berada"** — struktur `:completion:function:completer:command:argument:tag`
4. **Completion untuk Command yang Ada: `compdef` dan `_arguments`** — mendaftarkan dan mendefinisikan completion
5. **Menulis Completion Function Sendiri** — dari `_describe` hingga `_arguments`
6. **Context-Sensitive Completion Lanjutan** — `_values`, `_files`, dan helper lainnya
7. **Menu Selection dan Matcher** — `menu select`, `matcher-list`, dan `list-colors`
8. **Debugging dan Audit Completion System** *(tambahan audit)* — `_complete_help`, `compaudit`, dan troubleshooting


## Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **jantung pengalaman interaktif Zsh**: sistem completion yang dapat diprogram. Ini adalah fitur yang paling membedakan Zsh dari Bash secara praktis. Di Bash, Anda perlu menulis fungsi completion yang relatif primitif dengan `COMPREPLY`; di Zsh, Anda memiliki **kerangka kerja lengkap** yang memahami konteks command line secara semantik .

Dalam konteks kurikulum Fase 3, Modul 3.2 adalah **puncak dari pengalaman interaktif**. Modul 3.1 mengajarkan bagaimana *memilih file* dengan presisi; Modul 3.2 mengajarkan bagaimana Zsh *memahami apa yang sedang Anda ketik* dan menawarkan saran yang relevan. Keduanya saling melengkapi: glob qualifiers adalah tentang *pattern matching terhadap filesystem*; completion adalah tentang *pattern matching terhadap command line*.

Modul ini juga merupakan **prasyarat tidak langsung** untuk Modul 3.3 (Konfigurasi), karena sebagian besar konfigurasi `.zshrc` yang bermakna melibatkan `compinit` dan `zstyle`.


## 1. Inisialisasi Completion System: `compinit`

### Deskripsi Konkret & Peran dalam Kurikulum

`compinit` adalah **pintu masuk** ke seluruh sistem completion Zsh. Tanpa memanggilnya, Zsh hanya memiliki completion dasar yang terbatas (mirip Bash). Dengan memanggilnya, Zsh mengaktifkan kerangka kerja `compsys` yang lengkap: ratusan fungsi completion untuk perintah umum, mekanisme context dan tag, serta kemampuan untuk menulis completion sendiri.

Dalam kurikulum, sub-bagian ini adalah **langkah pertama yang wajib**. Ini adalah "saklar" yang mengubah Zsh dari shell biasa menjadi shell dengan completion cerdas.

### Konsep Kunci & Filosofi Mendalam

Bayangkan `compinit` sebagai **membuka perpustakaan**. Sebelum dibuka, Anda hanya bisa menebak-nebak di mana buku berada. Setelah dibuka, ada katalog, indeks, dan pustakawan yang memahami apa yang Anda cari.

Secara teknis, `compinit` melakukan beberapa hal :
1. **Mendefinisikan fungsi utilitas** yang diperlukan oleh completion system.
2. **Menyiapkan autoloading** untuk semua fungsi completion yang ada di `fpath`.
3. **Mendefinisikan ulang semua widget** yang terkait dengan completion (TAB, dll.) agar menggunakan sistem baru.
4. **Membuat dump file** (`.zcompdump`) untuk mempercepat inisialisasi berikutnya.

**Mengapa perlu `compinit` secara eksplisit?** Karena Zsh tidak mengaktifkan completion system secara otomatis. Ini adalah keputusan desain: completion system adalah fitur "opt-in" yang memerlukan konfigurasi. Tanpa `compinit`, Anda hanya mendapatkan completion dasar yang tidak jauh berbeda dari Bash.

**Filosofi dump file**: `compinit` membaca ratusan file fungsi completion saat pertama kali dijalankan. Ini memakan waktu. Untuk mempercepat, Zsh "membekukan" state yang sudah dibaca ke dalam file `.zcompdump`. Pada startup berikutnya, Zsh membaca dump file (jauh lebih cepat) alih-alih memproses ulang semua file. Ini adalah trade-off antara startup time dan akurasi: jika Anda menambah fungsi completion baru, Anda perlu menghapus dump file agar `compinit` mengenali perubahan .

### Sintaks Dasar dan Contoh

```bash
# === INISIALISASI DASAR ===
autoload -Uz compinit && compinit

# === DENGAN OPSI ===
# -u: abaikan security check (gunakan hanya jika Anda yakin)
# -i: silently ignore insecure files
# -C: skip check untuk fungsi baru (dump file hanya dibuat jika belum ada)
# -d dumpfile: tentukan lokasi dump file secara eksplisit
autoload -Uz compinit && compinit -u -d ~/.zcompdump

# === REBUILD DUMP FILE ===
rm -f ~/.zcompdump && compinit

# === CEK APAKAH compinit SUDAH DIMUAT ===
# Dalam script, Anda bisa cek dengan:
if (( ${+functions[compinit]} )); then
    print "compinit tersedia"
fi

# === UNTUK BASH COMPATIBILITY ===
autoload -Uz bashcompinit && bashcompinit
```

**Penjelasan kata demi kata:**

- `autoload -Uz compinit` — Perintah `autoload` menandai `compinit` sebagai fungsi yang akan dimuat saat pertama kali dipanggil. Flag `-U` mencegah alias expansion saat memuat; flag `-z` membuat fungsi berjalan dalam mode Zsh-native (bukan mode kompatibilitas Ksh). Ini adalah idiom standar untuk memuat fungsi completion.
- `&& compinit` — Jika `autoload` berhasil, panggil `compinit` untuk menginisialisasi sistem.
- `-u` — Menonaktifkan security check. Zsh secara default memeriksa apakah file completion dimiliki oleh root atau user saat ini, dan apakah direktori tidak world-writable. Jika ada yang mencurigakan, Zsh akan bertanya. Opsi `-u` melewati ini .
- `-d ~/.zcompdump` — Menentukan lokasi dump file secara eksplisit.
- `bashcompinit` — Fungsi kompatibilitas yang memungkinkan Anda menggunakan completion scripts yang ditulis untuk Bash .

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`compinit`** | Fungsi yang menginisialisasi completion system Zsh. |
| **`.zcompdump`** | File dump yang menyimpan state completion untuk mempercepat startup. |
| **`fpath`** | Array yang berisi direktori tempat Zsh mencari fungsi autoload. Completion functions biasanya ada di `$fpath` dengan nama yang diawali underscore. |
| **Autoload** | Mekanisme Zsh untuk memuat fungsi saat pertama kali dipanggil, bukan saat didefinisikan. |
| **`compinstall`** | Fungsi interaktif untuk mengonfigurasi completion system dan menulis konfigurasi ke `.zshrc` . |
| **`compaudit`** | Fungsi untuk menjalankan security check secara manual . |

### Diagram Alur: Proses Inisialisasi

```bash
Anda menjalankan: autoload -Uz compinit && compinit
        │
        ▼
compinit mencari fungsi completion di direktori $fpath
        │
        ├── Jika .zcompdump ada dan up-to-date:
        │       └── Baca dump file (cepat)
        │
        └── Jika .zcompdump tidak ada atau sudah usang:
                └── Baca semua file completion (lambat)
                └── Buat .zcompdump baru
        │
        ▼
compinit mendefinisikan ulang widget completion (TAB, dll.)
        │
        ▼
Sistem completion siap digunakan
```

> **Visualisasi diagram alur [compinit → cek dump → baca/buat → redefine widgets → siap] akan sangat membantu di sini.** Diagram ini memperjelas mengapa startup pertama terasa lambat dan mengapa dump file penting.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Modul 3.1 (Globbing) — pemahaman pattern matching membantu memahami cara completion bekerja.
- **Prasyarat untuk**: Semua sub-bagian berikutnya di Modul 3.2. Tanpa `compinit`, tidak ada `zstyle`, tidak ada `compdef`, tidak ada completion function.
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — `compinit` biasanya dipanggil dari `.zshrc`.

### Sumber Referensi

- Zsh Manual — Initialization: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Initialization 
- Zsh Manual — `compinit` details: https://zsh.sourceforge.io/Doc/Release/Completion-System.html 
- Ubuntu Manpage — `compinit` security: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 

### Tips dan Praktik Terbaik

1. **Selalu gunakan `autoload -Uz compinit && compinit`**: Jangan hanya `compinit` tanpa `autoload` — ini adalah praktik terbaik untuk memastikan fungsi dimuat dengan benar.
2. **Hapus `.zcompdump` setelah menginstal plugin completion baru**: Jika Anda menambah `zsh-completions` atau plugin serupa, hapus dump file agar `compinit` mengenali fungsi baru .
3. **Jangan panggil `compinit` dua kali**: Ini dapat menyebabkan masalah. Jika menggunakan framework seperti Oh-My-Zsh, pastikan Anda tidak memanggil `compinit` secara manual setelah framework memanggilnya .
4. **Gunakan `-C` untuk startup lebih cepat**: Jika Anda sering membuka shell baru, `compinit -C` akan mempercepat startup dengan melewati check untuk fungsi baru (dump file hanya dibuat jika belum ada) .

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| "compinit: function definition file not found" | `fpath` tidak berisi direktori completion | Tambahkan `fpath+=(/usr/share/zsh/functions)` atau path yang sesuai |
| "compinit: insecure directories and files" | Security check menemukan file yang tidak aman | `compinit -u` untuk melewati, atau perbaiki permission |
| Completion tidak berfungsi setelah menambah fungsi | Dump file tidak mengenali fungsi baru | `rm -f ~/.zcompdump && compinit` |
| Startup lambat setiap kali | `compinit` dipanggil berulang kali | Pastikan hanya dipanggil sekali di `.zshrc` |

### Latihan Praktis

```bash
# Latihan 1: Inisialisasi dasar
autoload -Uz compinit && compinit
# Coba ketik: ls --<TAB> — apakah muncul opsi?

# Latihan 2: Cek dump file
ls -la ~/.zcompdump

# Latihan 3: Rebuild dump
rm -f ~/.zcompdump && compinit

# Latihan 4: Security check
compaudit  # Jalankan untuk melihat apakah ada direktori yang tidak aman
```


## 2. Konfigurasi dengan `zstyle`

### Deskripsi Konkret & Peran dalam Kurikulum

`zstyle` adalah **mekanisme konfigurasi universal** untuk completion system (dan modul Zsh lainnya). Jika `compinit` adalah "membuka perpustakaan", `zstyle` adalah "mengatur bagaimana pustakawan bekerja": apakah dia harus menampilkan deskripsi, bagaimana dia mengurutkan hasil, apakah dia harus mengoreksi ejaan, dan seterusnya.

Dalam kurikulum, `zstyle` adalah **alat kontrol utama** untuk completion. Tanpa `zstyle`, Anda hanya mendapatkan perilaku default. Dengan `zstyle`, Anda dapat menyesuaikan hampir setiap aspek completion.

### Konsep Kunci & Filosofi Mendalam

Filosofi `zstyle` adalah **"konfigurasi berbasis konteks"**. Alih-alih memiliki serangkaian opsi global seperti `setopt`, `zstyle` memungkinkan Anda menentukan **di mana** konfigurasi berlaku. Anda bisa mengatur perilaku yang berbeda untuk perintah yang berbeda, argumen yang berbeda, atau bahkan tag yang berbeda.

Struktur `zstyle` adalah:
```bash
zstyle <context-pattern> <style-name> <value>
```

**Context pattern** adalah string yang mendeskripsikan "di mana" style berlaku. Ini menggunakan format `:completion:function:completer:command:argument:tag` . Misalnya:
- `:completion:*` — semua completion
- `:completion:*:*:git:*` — completion untuk perintah `git`
- `:completion:*:*:kill:*:jobs` — completion untuk job argument di perintah `kill`

**Style name** adalah nama pengaturan, seperti `menu`, `matcher-list`, `verbose`, `list-colors`.

**Value** adalah nilai yang diberikan.

Filosofi kuncinya: **semakin spesifik pattern, semakin tinggi prioritasnya**. Jika Anda mengatur `:completion:*` verbose yes dan `:completion:*:*:kill:*` verbose no, maka perintah `kill` akan menggunakan `verbose no` karena pattern-nya lebih spesifik .

### Sintaks Dasar dan Contoh

```bash
# === STYLE DASAR ===
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes

# === STYLE SPESIFIK PER COMMAND ===
# Matikan verbose untuk kill (tampilkan hanya nomor job/PID)
zstyle ':completion:*:*:kill:*' verbose no

# === STYLE DENGAN TAG ===
# Hanya untuk tag "jobs" di kill
zstyle ':completion:*:*:kill:*:jobs' verbose no

# === STYLE DENGAN -e (EVALUASI DINAMIS) ===
# Nilai style dihitung setiap kali dibutuhkan
zstyle -e ':completion:*' hosts 'reply=($myhosts)'

# === STYLE UNTUK MATCHER ===
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*'
# Matcher pertama: case-insensitive
# Matcher kedua: fuzzy matching (mengabaikan . _ - di awal kata)

# === STYLE UNTUK LIST COLORS ===
# Gunakan warna LS_COLORS untuk daftar completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Untuk direktori, gunakan warna khusus
zstyle ':completion:*:default' list-colors 'di=01;34' 'ln=01;36'
```

**Penjelasan mendalam tentang `zstyle`:**

- `zstyle ':completion:*' menu select` — Style `menu` dengan nilai `select`. Ini mengaktifkan menu selection: ketika ada beberapa kandidat, Anda bisa memilih dengan arrow keys, bukan hanya mengetik. Nilai `select` berarti menu selection dimulai segera (jika ada beberapa match) .
- `zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'` — Style `matcher-list` mendefinisikan matcher yang digunakan. Matcher `m:{a-zA-Z}={A-Za-z}` berarti case-insensitive matching: `foo` akan cocok dengan `Foo`, `FOO`, dll.
- `zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"` — Menggunakan `LS_COLORS` untuk mewarnai daftar completion. `${(s.:.)LS_COLORS}` adalah parameter expansion Zsh yang memecah string `LS_COLORS` berdasarkan `:` menjadi array.

**Style `matcher-list` secara lebih detail:**

`matcher-list` adalah style yang sangat kuat. Nilainya adalah daftar spesifikasi yang dipisahkan oleh spasi. Setiap spesifikasi adalah "matcher" yang akan dicoba secara berurutan. Jika matcher pertama tidak menemukan hasil, matcher kedua dicoba, dan seterusnya .

Format matcher:
```bash
m:<pattern>=<replacement>   # Map satu pola ke pola lain
r:<pattern>=<replacement>   # Replace pola dengan replacement
b:<pattern>=<replacement>   # Both (map dan replace)
```

Contoh:
- `m:{a-zA-Z}={A-Za-z}` — case-insensitive (map huruf besar/kecil)
- `r:|[._-]=* r:|=*` — fuzzy matching: `_` dianggap sebagai `*` sehingga `foo_bar` bisa dicocokkan dengan `foobar` (karena `_` dianggap wildcard).

**Peringatan performa**: Setiap elemen di `matcher-list` menyebabkan completion dijalankan ulang. "One to three strings will give acceptable performance" . Jangan gunakan terlalu banyak matcher.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`zstyle`** | Builtin Zsh untuk mengonfigurasi modul berbasis context. |
| **Context pattern** | String yang mendeskripsikan "di mana" style berlaku, dengan format `:completion:function:completer:command:argument:tag`. |
| **Style name** | Nama pengaturan, seperti `menu`, `matcher-list`, `verbose`. |
| **Tag** | Label yang mengkategorikan jenis match, seperti `files`, `directories`, `options`, `jobs`. |
| **`matcher-list`** | Style yang mendefinisikan daftar matcher untuk case-insensitivity dan fuzzy matching. |
| **`menu`** | Style yang mengontrol menu completion/selection. |
| **`list-colors`** | Style untuk mewarnai daftar completion. |
| **`verbose`** | Style untuk menampilkan deskripsi lengkap atau singkat. |

### Diagram Alur: Cara `zstyle` Bekerja

```bash
Anda mengetik: kill -<TAB>
        │
        ▼
Completion system membangun context string:
  :completion::complete:kill:option-1:options
        │
        ▼
System mencari style yang cocok, dari yang paling spesifik:
  1. ':completion:*:*:kill:*:options' — tidak ada
  2. ':completion:*:*:kill:*' — verbose no ← COCOK
  3. ':completion:*' — verbose yes
        │
        ▼
Gunakan nilai dari pattern yang paling spesifik: verbose no
        │
        ▼
Tampilkan opsi tanpa deskripsi lengkap
```

> **Visualisasi diagram [Context string → cari pattern paling spesifik → gunakan nilai] akan sangat membantu di sini.** Diagram ini memperjelas mengapa urutan pattern penting.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 1 (`compinit`).
- **Prasyarat untuk**: Semua sub-bagian berikutnya — `compdef` dan completion function sering menggunakan `zstyle` untuk konfigurasi.
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — `zstyle` biasanya didefinisikan di `.zshrc`.

### Sumber Referensi

- Zsh Manual — Styles: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Styles 
- Zsh Manual — `matcher-list`: https://zsh.sourceforge.io/Doc/zsh_a4.pdf 
- Zsh Manual — `menu` style: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 

### Tips dan Praktik Terbaik

1. **Mulai dengan konfigurasi minimal**: `menu select` dan `matcher-list 'm:{a-zA-Z}={A-Za-z}'` sudah memberikan pengalaman yang jauh lebih baik dari default.
2. **Gunakan `list-colors`**: Ini membuat daftar completion lebih mudah dibaca.
3. **Hati-hati dengan `matcher-list` yang terlalu banyak**: Performa bisa turun drastis.
4. **Gunakan `-e` untuk style dinamis**: Jika nilai style perlu dihitung setiap kali (misalnya daftar host dari file), gunakan `zstyle -e`.
5. **Jangan gunakan pattern `*` sendirian**: Selalu gunakan `:completion:*` untuk menghindari konflik dengan modul lain .

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Style tidak berpengaruh | Pattern terlalu spesifik atau terlalu umum | Gunakan `_complete_help` (Ctrl+X h) untuk melihat context aktual |
| `menu select` tidak berfungsi | `menu-select` widget tidak dimuat | Pastikan `zsh/complist` dimuat sebelum `compinit`  |
| Matcher case-insensitive tidak bekerja | `matcher-list` tidak di-set atau typo | Cek dengan `zstyle -L ':completion:*' matcher-list` |
| Performa completion lambat | `matcher-list` terlalu banyak elemen | Kurangi menjadi 1–3 matcher  |

### Latihan Praktis

```bash
# Latihan 1: Konfigurasi dasar
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Latihan 2: Coba case-insensitive
# Ketik: ls Doc<TAB> — apakah menemukan "documents" atau "Documents"?

# Latihan 3: Lihat style yang aktif
zstyle -L ':completion:*'

# Latihan 4: Style spesifik
zstyle ':completion:*:*:kill:*' verbose no
# Ketik: kill -<TAB> — apakah deskripsi hilang?
```


## 3. Context dan Tag: Memahami "Di Mana Kita Berada"

### Deskripsi Konkret & Peran dalam Kurikulum

Context dan tag adalah **kerangka konseptual** yang memungkinkan completion system Zsh memahami di mana Anda berada di command line. Tanpa memahami context, Anda tidak akan bisa menulis `zstyle` yang tepat atau men-debug mengapa completion tertentu tidak berfungsi.

Dalam kurikulum, sub-bagian ini adalah **jembatan antara konfigurasi dan penulisan completion function**. Anda perlu memahami context untuk menulis `zstyle` yang efektif, dan Anda perlu memahami tag untuk menulis completion function yang benar.

### Konsep Kunci & Filosofi Mendalam

Bayangkan Anda berada di sebuah restoran. Pelayan (completion system) perlu tahu:
- **Di restoran mana?** (function)
- **Siapa pelayannya?** (completer)
- **Menu apa yang sedang dilihat?** (command)
- **Di bagian menu mana?** (argument)
- **Jenis makanan apa?** (tag)

Itulah context. Setiap kali Anda menekan TAB, completion system membangun string context yang mendeskripsikan **secara tepat** posisi Anda. String ini memiliki format :

```bash
:completion:<function>:<completer>:<command>:<argument>:<tag>
```

**Enam field:**

1. **`:completion:`** — Literal. Menandakan bahwa ini adalah context untuk completion system. Field ini membedakan dari modul lain seperti `zle` atau `zftp`.
2. **`<function>`** — Nama widget jika completion dipanggil dari widget khusus. Biasanya kosong.
3. **`<completer>`** — Nama completer yang aktif. Biasanya `complete`, `correct`, atau `approximate`.
4. **`<command>`** — Nama perintah yang sedang di-complete. Misalnya `git`, `kill`, `cd`.
5. **`<argument>`** — Argumen ke berapa. Format `argument-n` untuk argumen biasa, `option-opt-n` untuk argumen ke opsi.
6. **`<tag>`** — Jenis match yang sedang dihasilkan. Misalnya `files`, `directories`, `options`, `jobs`.

**Contoh context lengkap:**
```bash
:completion::complete:dvips:option-o-1:files
```
Artinya: "Completion normal sedang dilakukan untuk argumen pertama dari opsi `-o` pada perintah `dvips`, dan tipe match adalah files" .

**Tag** adalah konsep yang lebih halus. Satu completion function bisa menghasilkan beberapa **jenis** match, masing-masing dengan tag berbeda. Misalnya, completion untuk `cd` bisa menghasilkan `local-directories` (subdirektori dari cwd) dan `path-directories` (direktori dari `$cdpath`). Keduanya memiliki tag berbeda, sehingga Anda bisa mengonfigurasi style yang berbeda untuk masing-masing .

**Mengapa tag penting?** Karena `zstyle` bekerja pada level tag. Anda bisa mengatakan: "Untuk completion `kill`, matikan verbose hanya untuk tag `jobs`, tetapi biarkan verbose untuk tag `processes`" .

### Sintaks Dasar dan Contoh

```bash
# === MELIHAT CONTEXT AKTUAL ===
# Tekan Ctrl+X h saat completion aktif (setelah menekan TAB)
# Ini akan menampilkan context dan tag yang tersedia

# Atau gunakan _complete_help:
# Ketik: git <Ctrl+X> h
# Output: :completion::complete:git:argument-1:...

# === CONTOH STYLE BERDASARKAN CONTEXT ===
# Semua completion: verbose
zstyle ':completion:*' verbose yes

# Untuk kill: matikan verbose (hanya nomor job/PID)
zstyle ':completion:*:*:kill:*' verbose no

# Untuk kill, hanya tag "jobs": matikan verbose
zstyle ':completion:*:*:kill:*:jobs' verbose no

# Untuk kill, tag "processes": tetap verbose
zstyle ':completion:*:*:kill:*:processes' verbose yes

# === CONTOH TAG UMUM ===
# files — file biasa
# directories — direktori
# options — opsi perintah
# commands — nama perintah
# builtins — builtin commands
# jobs — job di shell
# processes — proses sistem
# users — nama user
# groups — nama group
# hosts — hostname
# colors — nama warna

# === MELIHAT TAG YANG TERSEDIA ===
# Gunakan _complete_help (Ctrl+X h) untuk melihat tag aktual
# atau baca dokumentasi untuk fungsi completion tertentu
```

**Penjelasan mendalam tentang `_complete_help`:**

`_complete_help` adalah bindable command yang sangat berguna untuk debugging. Ketika Anda menekan `Ctrl+X h` (default binding), Zsh menampilkan context string dan daftar tag yang tersedia untuk posisi cursor saat ini. Ini adalah cara **paling akurat** untuk mengetahui pattern `zstyle` yang harus Anda gunakan .

Contoh output:
```bash
tags in context :completion::complete:git::
    commands  (_git_commands)
    ...
tags in context :completion::complete:git:argument-1::
    ...
```

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Context** | String yang mendeskripsikan posisi di command line, dengan format `:completion:function:completer:command:argument:tag`. |
| **Tag** | Label yang mengkategorikan jenis match dalam context tertentu. |
| **`_complete_help`** | Bindable command untuk menampilkan context dan tag aktual. |
| **Completer** | Fungsi yang mengontrol bagaimana completion dilakukan (complete, correct, approximate). |
| **`argument-n`** | Format context field untuk argumen ke-n. |
| **`option-opt-n`** | Format context field untuk argumen ke-n dari opsi `opt`. |

### Diagram Alur: Konstruksi Context

```bash
Anda mengetik: git commit -m <TAB>
        │
        ▼
Context dibangun secara bertahap:
  1. Mulai dengan: :completion:
  2. Tambahkan function (kosong): :completion::
  3. Tambahkan completer: :completion::complete:
  4. Tambahkan command: :completion::complete:git:
  5. Tambahkan argument: :completion::complete:git:option-m-1:
  6. Tambahkan tag: :completion::complete:git:option-m-1:messages

Context akhir: :completion::complete:git:option-m-1:messages
```

> **Diagram alur [komponen context dibangun bertahap] akan sangat membantu di sini.** Diagram ini memperjelas mengapa context string memiliki banyak titik dua.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 2 (`zstyle`).
- **Prasyarat untuk**: Sub-bagian 4 (`compdef` dan `_arguments`) — completion function menggunakan context untuk menentukan perilaku.
- **Terhubung ke**: Sub-bagian 8 (Debugging) — `_complete_help` adalah alat debugging utama.

### Sumber Referensi

- Zsh Manual — Context: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System-Configuration 
- Zsh Manual — Tags: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Standard-Tags 
- Zsh Manual — `_complete_help`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html 

### Tips dan Praktik Terbaik

1. **Gunakan `_complete_help` (Ctrl+X h) secara rutin**: Ini adalah cara terbaik untuk mengetahui context dan tag aktual.
2. **Mulai dengan pattern yang umum, lalu spesifik**: `:completion:*` dulu, lalu tambahkan spesifikasi jika perlu.
3. **Perhatikan urutan field**: `:completion:function:completer:command:argument:tag` — jika Anda ingin menargetkan tag, Anda perlu mengisi field sebelumnya (meskipun dengan `*`).
4. **Gunakan wildcard `*` dengan bijak**: `:completion:*:*:kill:*` adalah pattern yang umum untuk "semua completion untuk kill, apapun argumennya".

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Style tidak cocok dengan context | Pattern terlalu umum atau terlalu spesifik | Gunakan `_complete_help` untuk melihat context aktual |
| Lupa field | Menulis `:completion:*:kill` bukan `:completion:*:*:kill:*` | Ingat format 6 field |
| Tag tidak berfungsi | Tag tidak ada di context tersebut | Cek dengan `_complete_help` |
| Mengira `*` mencocokkan semua | `*` di context pattern cocok dengan field, bukan seluruh string | Gunakan `:completion:*` untuk semua |

### Latihan Praktis

```bash
# Latihan 1: Lihat context aktual
# Ketik: git <Ctrl+X> h
# Catat context string yang muncul

# Latihan 2: Lihat tag yang tersedia
# Ketik: kill -<Ctrl+X> h
# Catat tag yang muncul (jobs, processes, dll.)

# Latihan 3: Style berdasarkan tag
zstyle ':completion:*:*:kill:*:jobs' verbose no
# Ketik: kill -<TAB> — apakah deskripsi job hilang?

# Latihan 4: Bandingkan context
# Ketik: cd <Ctrl+X> h
# Bandingkan dengan: kill -<Ctrl+X> h
# Apa perbedaan command dan argument field?
```


## 4. Completion untuk Command yang Ada: `compdef` dan `_arguments`

### Deskripsi Konkret & Peran dalam Kurikulum

`compdef` dan `_arguments` adalah **alat untuk mendaftarkan dan mendefinisikan** completion untuk perintah tertentu. `compdef` menghubungkan perintah dengan fungsi completion; `_arguments` adalah fungsi helper yang memudahkan penulisan completion untuk perintah dengan opsi dan argumen.

Dalam kurikulum, sub-bagian ini adalah **langkah praktis pertama** dalam menulis completion sendiri. Setelah memahami context dan tag (sub-bagian 3), Anda sekarang siap untuk **membuat** completion, bukan hanya mengonfigurasi yang sudah ada.

### Konsep Kunci & Filosofi Mendalam

Filosofi `compdef` adalah **"resep untuk setiap perintah"**. Setiap perintah memiliki "resep" completion-nya sendiri. `compdef` adalah cara Anda mengatakan: "Ketika user mengetik `mycommand` dan menekan TAB, gunakan resep `_mycommand`."

Filosofi `_arguments` adalah **"deklarasi, bukan imperatif"**. Alih-alih menulis kode yang secara manual memeriksa setiap opsi dan argumen, Anda **mendeklarasikan** struktur perintah Anda, dan `_arguments` menangani sisanya. Ini adalah pola desain yang mirip dengan HTML: Anda mendeskripsikan *apa* yang Anda inginkan, bukan *bagaimana* mencapainya.

**Mengapa `_arguments` penting?** Karena menulis completion manual untuk perintah dengan banyak opsi adalah mimpi buruk. `_arguments` menyediakan:
- Parsing otomatis untuk opsi (`-a`, `--all`, `-a=value`, dll.)
- Deskripsi otomatis untuk setiap opsi
- Penanganan mutually exclusive options
- Penanganan opsi yang memerlukan argumen
- Integrasi dengan helper lain seperti `_files`, `_values`

### Sintaks Dasar dan Contoh

```bash
# === MENDEFINISIKAN COMPLETION FUNCTION SEDERHANA ===
_my_command() {
    local -a options
    options=(
        '--help:Membuka bantuan'
        '--version:Menampilkan versi'
        '--output=:File output'
        '--verbose:Mode verbose'
        '--quiet:Mode senyap'
    )
    _describe 'options' options
}

# === MENDAFTARKAN DENGAN compdef ===
compdef _my_command my_command

# === MENGGUNAKAN _arguments ===
_my_command_args() {
    _arguments \
        '(-h --help)'{-h,--help}'[Membuka bantuan]' \
        '(-V --version)'{-V,--version}'[Menampilkan versi]' \
        '(-o --output)'{-o,--output}'[File output]:file:_files' \
        '(-v --verbose)'{-v,--verbose}'[Mode verbose]' \
        '(-q --quiet)'{-q,--quiet}'[Mode senyap]' \
        '*:file:_files'
}
compdef _my_command_args my_command

# === _arguments DENGAN DESKRIPSI DAN HELPER ===
_my_git_like() {
    _arguments -C \
        '1: :->cmds' \
        '*:: :->args' && return 0
    
    case $state in
        cmds)
            _values 'command' \
                'init[Membuat repository baru]' \
                'add[Tambah file ke staging]' \
                'commit[Commit perubahan]' \
                'push[Push ke remote]' \
                'pull[Pull dari remote]'
            ;;
        args)
            case $words[1] in
                add)
                    _files
                    ;;
                commit)
                    _arguments '-m[Pesan commit]:message:'
                    ;;
            esac
            ;;
    esac
}
compdef _my_git_like my_git

# === _arguments DENGAN OPTIONS YANG MUTUALLY EXCLUSIVE ===
_my_exclusive() {
    _arguments \
        '(-a --all)'{-a,--all}'[Semua item]' \
        '(-s --some)'{-s,--some}'[Beberapa item]' \
        '--' \
        '*:file:_files'
}
```

**Penjelasan mendalam tentang `_arguments`:**

`_arguments` menerima daftar **spec** (spesifikasi) sebagai argumen. Setiap spec mendeskripsikan satu opsi atau argumen. Format umum:

```bash
'[-]option[description]:message:action'
```

- **`[-]option`** — Opsi, bisa `-a` atau `--all`. Tanda kurung siku `(-a --all)` menunjukkan mutually exclusive options.
- **`[description]`** — Deskripsi yang ditampilkan saat completion.
- **`:message:action`** — Jika opsi memerlukan argumen, tentukan pesan dan action (helper seperti `_files` atau `_values`).

**Contoh:** `'(-o --output)'{-o,--output}'[File output]:file:_files'`

- `(-o --output)` — `-o` dan `--output` adalah mutually exclusive (tidak bisa digunakan bersamaan).
- `{-o,--output}` — Brace expansion: dua opsi dengan perilaku sama.
- `[File output]` — Deskripsi.
- `:file:_files` — Opsi ini memerlukan argumen bertipe file, gunakan `_files` untuk completion.

**`_describe` vs `_arguments`:**

- `_describe` adalah helper sederhana untuk menampilkan daftar item dengan deskripsi. Cocok untuk opsi sederhana.
- `_arguments` adalah kerangka kerja lengkap untuk parsing command line. Cocok untuk perintah dengan banyak opsi dan argumen.

**`_values`:**

`_values` adalah helper untuk menampilkan daftar nilai. Format: `_values 'description' 'value1[desc1]' 'value2[desc2]' ...`

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`compdef`** | Perintah untuk mendaftarkan fungsi completion untuk perintah. |
| **`_arguments`** | Fungsi helper untuk mendefinisikan completion perintah dengan opsi. |
| **`_describe`** | Fungsi helper untuk menampilkan daftar item dengan deskripsi. |
| **`_values`** | Fungsi helper untuk menampilkan daftar nilai. |
| **`_files`** | Fungsi helper untuk completion file. |
| **Spec** | Spesifikasi dalam `_arguments` yang mendeskripsikan satu opsi/argumen. |
| **`state`** | Variabel yang digunakan dalam `_arguments -C` untuk menentukan state saat ini. |
| **`words`** | Array yang berisi kata-kata di command line. |

### Diagram Alur: Cara `compdef` dan `_arguments` Bekerja

```bash
User mengetik: my_command --o<TAB>
        │
        ▼
Zsh mencari completion function untuk "my_command"
        │
        ▼
compdef telah mendaftarkan: _my_command_args
        │
        ▼
Zsh memanggil _my_command_args
        │
        ▼
_arguments mem-parsing command line:
  - Melihat kata saat ini: "--o"
  - Mencocokkan dengan spec: '(-o --output)'{-o,--output}'...'
  - Menemukan match: --output
        │
        ▼
Menampilkan saran: --output
```

> **Diagram alur [compdef → _my_command_args → _arguments parsing → hasil] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 3 (Context dan Tag).
- **Prasyarat untuk**: Sub-bagian 5 (Menulis Completion Function Sendiri).
- **Terhubung ke**: Modul 3.1 (Globbing) — `_files` menggunakan glob qualifiers internal.

### Sumber Referensi

- Zsh Manual — `compdef`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Autoloaded-files 
- Zsh Manual — `_arguments`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- Zsh Completion Examples (GitHub): https://github.com/zsh-users/zsh-completions 

### Tips dan Praktik Terbaik

1. **Gunakan `_arguments` untuk perintah kompleks**: Ini menghemat waktu dan mengurangi bug.
2. **Manfaatkan brace expansion untuk opsi pendek/panjang**: `{-h,--help}` lebih ringkas daripada `-h --help`.
3. **Selalu sediakan deskripsi**: Deskripsi membuat completion jauh lebih berguna.
4. **Gunakan `_files` untuk argumen file**: Ini otomatis menangani glob qualifiers, direktori, dan file tersembunyi.
5. **Test dengan `_complete_help`**: Setelah menulis completion, gunakan `Ctrl+X h` untuk memastikan context dan tag sudah benar.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Completion tidak muncul | `compdef` tidak dipanggil atau nama salah | Pastikan `compdef _func command` dipanggil |
| `_arguments` error "parse error" | Spec tidak valid | Cek format spec, pastikan kutip benar |
| Deskripsi tidak muncul | Format `[description]` salah | Pastikan deskripsi dalam tanda kurung siku `[]` |
| Opsi yang sama muncul dua kali | Brace expansion salah | Gunakan `{-o,--output}` bukan `{-o,--output}` dengan spasi |

### Latihan Praktis

```bash
# Latihan 1: Buat completion sederhana
_my_ls() {
    _arguments \
        '-l[List format]' \
        '-a[Show hidden]' \
        '-h[Human readable]' \
        '*:file:_files'
}
compdef _my_ls my_ls

# Latihan 2: Buat completion dengan subcommand
_my_tool() {
    local -a subcmds
    subcmds=(
        'build:Build project'
        'run:Run project'
        'test:Run tests'
    )
    _describe 'subcommand' subcmds
}
compdef _my_tool my_tool

# Latihan 3: Test dengan _complete_help
# Ketik: my_ls -<Ctrl+X> h
# Lihat context dan tag
```


## 5. Menulis Completion Function Sendiri

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini adalah **inti dari Modul 3.2**. Setelah memahami `compinit`, `zstyle`, context, dan `compdef`, sekarang saatnya **membuat** completion function dari nol. Ini adalah keterampilan yang membedakan pengguna Zsh biasa dari pengguna Zsh expert.

Dalam kurikulum, ini adalah **puncak keterampilan completion**. Anda akan belajar menulis fungsi yang memahami struktur perintah, memvalidasi input, dan memberikan saran yang cerdas.

### Konsep Kunci & Filosofi Mendalam

Filosofi menulis completion function adalah **"empati terhadap pengguna"**. Ketika Anda menulis completion, Anda sedang memprediksi: *"Apa yang mungkin ingin diketik pengguna setelah ini?"* Completion yang baik adalah completion yang **mengurangi friksi** — pengguna tidak perlu mengingat opsi, path file, atau nilai yang valid.

Secara teknis, completion function adalah **fungsi shell biasa** yang:
1. Menerima informasi tentang command line saat ini (via variabel seperti `$words`, `$CURRENT`, `$state`).
2. Menghasilkan daftar kandidat menggunakan helper seperti `_describe`, `_arguments`, `_values`, `compadd`.
3. Mengembalikan kontrol ke sistem completion.

**Perbedaan kunci dari Bash**: Di Bash, Anda mengisi array `COMPREPLY` dengan string kandidat. Di Zsh, Anda menggunakan `compadd` (atau helper yang memanggil `compadd`) yang memungkinkan **deskripsi terpisah** dari nilai kandidat . Ini adalah fitur yang sangat powerful: Anda bisa menampilkan `--output: File output` sementara yang dimasukkan ke command line hanya `--output`.

### Sintaks Dasar dan Contoh

```bash
# === STRUKTUR DASAR COMPLETION FUNCTION ===
_my_completion() {
    local -a options values
    local curcontext="$curcontext" state line
    
    # Parsing dengan _arguments
    _arguments -C \
        '1: :->first_arg' \
        '2: :->second_arg' \
        '*: :->rest' && return 0
    
    # Menentukan apa yang ditampilkan berdasarkan state
    case $state in
        first_arg)
            _values 'first argument' \
                'apple[Buah apel]' \
                'banana[Buah pisang]' \
                'cherry[Buah ceri]'
            ;;
        second_arg)
            _files
            ;;
        rest)
            _files -/
            ;;
    esac
}

# === MENGGUNAKAN compadd LANGSUNG ===
_my_compadd() {
    local -a fruits
    fruits=(
        'apple:Buah apel'
        'banana:Buah pisang'
        'cherry:Buah ceri'
    )
    
    # Pisahkan nama dan deskripsi
    local -a names descs
    for item in "${fruits[@]}"; do
        names+=("${item%%:*}")
        descs+=("${item#*:}")
    done
    
    compadd -d descs -- "${names[@]}"
}

# === COMPLETION DENGAN KONDISI ===
_my_conditional() {
    if [[ $words[CURRENT-1] == "--format" ]]; then
        _values 'format' 'json' 'yaml' 'xml'
    else
        _files
    fi
}

# === COMPLETION DENGAN DYNAMIC VALUES ===
_my_dynamic() {
    local -a branches
    branches=($(git branch --format='%(refname:short)' 2>/dev/null))
    
    if (( ${#branches} )); then
        _describe 'branch' branches
    else
        _message 'no branches found'
    fi
}

# === MENDAFTARKAN ===
compdef _my_completion my_command
compdef _my_compadd my_compadd
compdef _my_conditional my_conditional
compdef _my_dynamic my_dynamic
```

**Penjelasan mendalam tentang `compadd`:**

`compadd` adalah **building block** dari semua completion function. Helper seperti `_describe`, `_arguments`, dan `_values` pada akhirnya memanggil `compadd`. Memahami `compadd` berarti memahami apa yang sebenarnya terjadi.

```bash
compadd [options] -- <matches...>
```

Opsi penting:
- `-d array` — Array deskripsi paralel. `descs[i]` adalah deskripsi untuk `matches[i]`.
- `-a array` — Gunakan array sebagai daftar match.
- `-J group` — Kelompokkan match dalam grup bernama.
- `-X explanation` — Penjelasan untuk grup.
- `--` — Akhir opsi, mulai match.

**Mengapa deskripsi terpisah penting?** Karena Anda bisa menampilkan deskripsi yang informatif tanpa mengganggu apa yang dimasukkan ke command line. Di Bash, Anda harus "mengakali" dengan menyertakan deskripsi dalam string kandidat dan berharap Bash tidak memasukkannya. Di Zsh, ini ditangani secara native .

**Variabel penting dalam completion function:**

- `$words` — Array kata-kata di command line.
- `$CURRENT` — Index kata saat ini.
- `$state` — State saat ini (dari `_arguments -C`).
- `$curcontext` — Context string saat ini.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`compadd`** | Builtin untuk menambahkan kandidat completion. |
| **`_describe`** | Helper untuk menampilkan daftar dengan deskripsi. |
| **`_values`** | Helper untuk menampilkan daftar nilai. |
| **`_files`** | Helper untuk completion file. |
| **`_message`** | Helper untuk menampilkan pesan. |
| **`$words`** | Array kata-kata di command line. |
| **`$CURRENT`** | Index kata saat ini (1-based). |
| **`$state`** | State dari `_arguments -C`. |
| **`-d descs`** | Opsi `compadd` untuk array deskripsi paralel. |

### Diagram Alur: Dari TAB ke Hasil

```bash
User mengetik: my_command apple<TAB>
        │
        ▼
Zsh memanggil completion function: _my_completion
        │
        ▼
_my_completion menggunakan _arguments untuk parsing:
  - $state = "first_arg"
  - $words = (my_command apple)
  - $CURRENT = 2
        │
        ▼
case $state: first_arg → _values 'first argument' ...
        │
        ▼
_values memanggil compadd dengan nama dan deskripsi
        │
        ▼
Zsh menampilkan:
  apple    Buah apel
  banana   Buah pisang
  cherry   Buah ceri
```

> **Diagram alur [TAB → function → _arguments → _values → compadd → display] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 4 (`compdef` dan `_arguments`).
- **Prasyarat untuk**: Sub-bagian 6 (Context-Sensitive Completion).
- **Terhubung ke**: Modul 3.1 — `_files` menggunakan glob qualifiers internal.

### Sumber Referensi

- Zsh Manual — Completion Functions: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- Zsh Completion How-to: https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org 
- GeekNews — Menulis completion di Bash dan Zsh: https://id.news.hada.io/topic?id=22492 

### Tips dan Praktik Terbaik

1. **Gunakan `_arguments` untuk perintah kompleks**: Ini menghemat waktu dan mengurangi bug.
2. **Manfaatkan `_describe` untuk daftar sederhana**: Tidak perlu `_arguments` untuk semua kasus.
3. **Selalu sediakan fallback**: Jika completion dinamis gagal (misalnya `git branch` error), sediakan `_message` atau `_files`.
4. **Test dengan `_complete_help`**: Setelah menulis completion, gunakan `Ctrl+X h` untuk memastikan context dan tag benar.
5. **Gunakan `compadd -d` untuk deskripsi terpisah**: Ini adalah fitur kunci Zsh yang membedakannya dari Bash.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Completion tidak muncul | Fungsi tidak dipanggil atau error | Cek dengan `zsh -x` atau tambahkan `print` debugging |
| Deskripsi tidak muncul | `compadd` tanpa `-d` | Gunakan `compadd -d descs -- names` |
| `_arguments` error | Spec tidak valid | Cek format, pastikan kutip benar |
| Completion lambat | Fungsi menjalankan perintah eksternal (git, dll.) | Cache hasil atau gunakan `_message` untuk sementara |

### Latihan Praktis

```bash
# Latihan 1: Completion sederhana dengan compadd
_my_fruits() {
    local -a fruits descs
    fruits=(apple banana cherry)
    descs=('Buah apel' 'Buah pisang' 'Buah ceri')
    compadd -d descs -- "${fruits[@]}"
}
compdef _my_fruits my_fruits

# Latihan 2: Completion dengan _values
_my_colors() {
    _values 'color' \
        'red[Merah]' \
        'green[Hijau]' \
        'blue[Biru]'
}
compdef _my_colors my_colors

# Latihan 3: Completion dinamis
_my_branches() {
    local -a branches
    branches=($(git branch --format='%(refname:short)' 2>/dev/null))
    (( ${#branches} )) && _describe 'branch' branches || _message 'no branches'
}
compdef _my_branches my_branches

# Latihan 4: Test
# Ketik: my_fruits <TAB>
# Ketik: my_colors <TAB>
```


## 6. Context-Sensitive Completion Lanjutan

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini memperdalam kemampuan completion function untuk **beradaptasi dengan konteks**. Completion yang baik tidak hanya menampilkan daftar statis; ia memahami **di mana** Anda berada dan menyesuaikan saran.

Dalam kurikulum, ini adalah **pengembangan dari sub-bagian 5**. Anda akan belajar menggunakan helper lanjutan seperti `_values`, `_files`, `_regex_arguments`, dan teknik untuk menangani subcommand.

### Konsep Kunci & Filosofi Mendalam

Filosofi context-sensitive completion adalah **"satu perintah, banyak konteks"**. Perintah `git` memiliki puluhan subcommand, masing-masing dengan opsi dan argumen sendiri. Completion yang baik harus memahami: "Jika user mengetik `git commit`, maka dia mungkin ingin mengetik pesan commit; jika `git checkout`, maka dia mungkin ingin mengetik nama branch."

**Teknik utama**: Menggunakan `_arguments -C` untuk "mengalihkan" state berdasarkan posisi command line. Ketika state berubah, completion function dapat memberikan saran yang berbeda.

### Sintaks Dasar dan Contoh

```bash
# === COMPLETION UNTUK SUBCOMMAND ===
_my_tool() {
    local -a subcmds
    local curcontext="$curcontext" state line
    
    _arguments -C \
        '1: :->cmds' \
        '*:: :->args' && return 0
    
    case $state in
        cmds)
            subcmds=(
                'build:Build project'
                'run:Run project'
                'test:Run tests'
                'clean:Clean artifacts'
            )
            _describe 'subcommand' subcmds
            ;;
        args)
            case $words[1] in
                build)
                    _arguments \
                        '--release[Build in release mode]' \
                        '--target=[Target platform]:target:(linux macos windows)'
                    ;;
                run)
                    _arguments \
                        '--port=[Port number]:port:' \
                        '--host=[Host address]:host:'
                    ;;
                test)
                    _arguments \
                        '--filter=[Test filter]:pattern:' \
                        '--verbose[Verbose output]'
                    ;;
                clean)
                    _arguments '--all[Clean everything]'
                    ;;
            esac
            ;;
    esac
}
compdef _my_tool my_tool

# === MENGGUNAKAN _files DENGAN OPSI ===
_my_file_selector() {
    _arguments \
        '--type=[File type]:type:(text binary)' \
        '*:file:_files' \
        '*:directory:_files -/'
}

# === MENGGUNAKAN _values UNTUK KEY-VALUE ===
_my_config() {
    _values 'config option' \
        'debug[Debug mode]:debug:(true false)' \
        'port[Port number]:port:' \
        'host[Host address]:host:'
}

# === COMPLETION DENGAN _regex_arguments ===
_my_regex() {
    _regex_arguments _my_regex_cmd \
        /$'build'/ /$'--release'/ \
        /$'run'/ /$'--port='[0-9]##/ \
        /$'test'/ /$'--filter='[^[:space:]]##/
}
```

**Penjelasan mendalam tentang `_arguments -C`:**

Opsi `-C` pada `_arguments` mengaktifkan **"command state" mode**. Dalam mode ini, `_arguments` tidak hanya mem-parsing opsi, tetapi juga **memecah command line menjadi state** berdasarkan spec yang Anda berikan .

Format spec untuk state: `'<position>: :-><state_name>'`

Contoh: `'1: :->cmds'` berarti: "Argumen pertama (posisi 1) akan mengubah state menjadi `cmds`."

Setelah `_arguments -C` selesai, variabel `$state` berisi nama state saat ini. Anda kemudian menggunakan `case $state` untuk menampilkan saran yang sesuai.

**`words` dan `CURRENT`:**

- `$words[1]` — Kata pertama setelah perintah. Dalam `my_tool build`, `$words[1]` adalah `build`.
- `$CURRENT` — Index kata saat ini. Jika cursor di akhir baris, `$CURRENT` adalah jumlah kata.

**`_regex_arguments`:**

Helper lanjutan untuk mendefinisikan completion berdasarkan **pola regex** pada command line. Ini berguna untuk perintah dengan sintaks yang sangat terstruktur. Namun, `_regex_arguments` jarang digunakan dan memiliki kurva belajar yang curam; kebanyakan completion menggunakan `_arguments -C` .

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`-C`** | Opsi `_arguments` untuk command state mode. |
| **`state`** | Variabel yang berisi state saat ini. |
| **`$words`** | Array kata-kata di command line. |
| **`$CURRENT`** | Index kata saat ini. |
| **`_regex_arguments`** | Helper untuk completion berbasis regex. |
| **`_files -/`** | `_files` dengan opsi `-/` untuk hanya direktori. |
| **`_values`** | Helper untuk key-value completion. |

### Diagram Alur: Subcommand Completion

```bash
User mengetik: my_tool build --<TAB>
        │
        ▼
_my_tool dipanggil
        │
        ▼
_arguments -C:
  - Parsing: my_tool build --
  - $state = "args" (karena argumen pertama "build" cocok dengan '*:: :->args')
  - $words = (my_tool build --)
  - $CURRENT = 3
        │
        ▼
case $state: args → case $words[1]: build → _arguments '--release' '--target='
        │
        ▼
Tampilkan: --release  --target=
```

> **Diagram alur [command line → _arguments -C → state → case → helper] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 5 (Menulis Completion Function).
- **Prasyarat untuk**: Sub-bagian 7 (Menu Selection dan Matcher).
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — completion function biasanya disimpan di file terpisah dan di-autoload.

### Sumber Referensi

- Zsh Manual — `_arguments`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- Zsh Completion How-to: https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org 
- Zsh Manual — `_regex_arguments`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

### Tips dan Praktik Terbaik

1. **Gunakan `_arguments -C` untuk subcommand**: Ini adalah pola standar untuk perintah seperti `git`, `docker`, `kubectl`.
2. **Gunakan `$words[1]` untuk menentukan subcommand**: Setelah state `args`, `$words[1]` adalah subcommand.
3. **Sediakan fallback**: Jika subcommand tidak dikenali, gunakan `_files` atau `_message`.
4. **Hindari `_regex_arguments` kecuali perlu**: Kurva belajar curam, dan `_arguments -C` biasanya cukup.
5. **Gunakan `_values` untuk key-value**: Format `key[desc]:value_action` sangat cocok untuk konfigurasi.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Subcommand tidak dikenali | `$words[1]` tidak di-set dengan benar | Pastikan `_arguments -C` dengan spec `'*:: :->args'` |
| State tidak berubah | Spec `_arguments` salah | Pastikan `'1: :->cmds'` dan `'*:: :->args'` |
| `_files -/` tidak berfungsi | Opsi `-/` tidak didukung di versi Zsh lama | Gunakan `_files -g '*(/)'` sebagai alternatif |
| Completion muncul di posisi yang salah | `$CURRENT` tidak diperhatikan | Gunakan `(( CURRENT == 2 ))` untuk posisi tertentu |

### Latihan Praktis

```bash
# Latihan 1: Completion dengan subcommand
_my_cli() {
    local state
    _arguments -C \
        '1: :->cmd' \
        '*:: :->args' && return 0
    
    case $state in
        cmd)
            _values 'command' 'start' 'stop' 'restart' 'status'
            ;;
        args)
            case $words[1] in
                start|restart)
                    _arguments '--port=[Port]:port:'
                    ;;
                stop)
                    _arguments '--force[Force stop]'
                    ;;
                status)
                    _arguments '--verbose[Verbose]'
                    ;;
            esac
            ;;
    esac
}
compdef _my_cli my_cli

# Latihan 2: Test
# Ketik: my_cli <TAB> — muncul start, stop, restart, status
# Ketik: my_cli start --<TAB> — muncul --port=
# Ketik: my_cli stop --<TAB> — muncul --force
```


## 7. Menu Selection dan Matcher

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini membahas **pengalaman pengguna** dari completion: bagaimana daftar kandidat ditampilkan, bagaimana Anda memilih di antara mereka, dan bagaimana sistem mencocokkan input Anda dengan kandidat.

Dalam kurikulum, ini adalah **lapisan UX** dari Modul 3.2. Setelah Anda bisa menulis completion function (sub-bagian 5–6), sekarang saatnya membuat pengalaman completion **nyaman dan menyenangkan**.

### Konsep Kunci & Filosofi Mendalam

Filosofi menu selection adalah **"jangan paksa pengguna mengetik lengkap"**. Jika ada 10 kandidat dan pengguna ingin yang ke-7, mengapa harus mengetik nama lengkapnya? Dengan menu selection, pengguna bisa menggunakan arrow keys untuk memilih.

Filosofi matcher adalah **"maafkan kesalahan kecil"**. Jika pengguna mengetik `Foo` tetapi file bernama `foo`, sistem harus tetap menemukannya. Matcher memungkinkan **case-insensitive** dan **fuzzy** matching.

**Style `menu`:**

Style `menu` mengontrol perilaku menu completion/selection :

- `menu yes` — Aktifkan menu completion. Setelah completion pertama, TAB berikutnya akan mengganti kandidat.
- `menu select` — Aktifkan menu selection. Kandidat ditampilkan dalam menu interaktif yang bisa dinavigasi dengan arrow keys.
- `menu select=5` — Aktifkan menu selection hanya jika ada **setidaknya 5** kandidat.
- `menu no` — Nonaktifkan menu completion.
- `menu yes=long` — Aktifkan menu completion jika daftar tidak muat di layar.

**Style `matcher-list`:**

Style `matcher-list` mendefinisikan **daftar matcher** yang dicoba secara berurutan . Setiap matcher adalah spesifikasi yang mengubah cara input dicocokkan dengan kandidat.

Format matcher:
- `m:<pattern>=<replacement>` — Map: ganti pola dengan replacement.
- `r:<pattern>=<replacement>` — Replace: ganti pola dengan replacement (seperti sed).
- `b:<pattern>=<replacement>` — Both: map dan replace.

**Contoh matcher umum:**

```bash
# Case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Fuzzy: abaikan . _ - di awal
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'

# Kombinasi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
```

### Sintaks Dasar dan Contoh

```bash
# === MENU SELECTION ===
# Menu selection dasar: tampilkan menu, navigasi dengan arrow keys
zstyle ':completion:*' menu select

# Menu selection hanya jika >= 5 kandidat
zstyle ':completion:*' menu select=5

# Menu selection hanya jika daftar tidak muat di layar
zstyle ':completion:*' menu select=long

# Menu completion (bukan selection): TAB mengganti kandidat
zstyle ':completion:*' menu yes

# === MATCHER ===
# Case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case-insensitive + fuzzy (abaikan . _ -)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'

# Case-insensitive + partial word matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*'

# === LIST COLORS ===
# Gunakan LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Warna khusus untuk direktori
zstyle ':completion:*:default' list-colors 'di=01;34' 'ln=01;36'

# === LIST PROMPT ===
# Prompt saat daftar tidak muat di layar
zstyle ':completion:*' list-prompt '%S%p at %l% s'
zstyle ':completion:*' select-prompt '%S%p at %l% s'
```

**Penjelasan mendalam tentang `menu select` vs `menu yes`:**

- `menu yes` — **Menu completion**: Kandidat pertama dimasukkan ke command line. Menekan TAB lagi akan mengganti dengan kandidat berikutnya. Command line **berubah** setiap kali TAB ditekan.
- `menu select` — **Menu selection**: Daftar kandidat ditampilkan dalam menu. Anda menggunakan arrow keys untuk memilih, dan Enter untuk mengonfirmasi. Command line **tidak berubah** sampai Anda memilih.

Menu selection lebih disukai karena lebih interaktif dan tidak mengubah command line sampai Anda yakin.

**Penjelasan mendalam tentang `list-colors`:**

`list-colors` menggunakan format yang sama dengan `LS_COLORS`: `key=value` dipisahkan oleh `:`.

- `di=01;34` — Direktori: bold blue.
- `ln=01;36` — Symlink: bold cyan.
- `ex=01;32` — Executable: bold green.
- `*.tar=01;31` — File .tar: bold red.

`${(s.:.)LS_COLORS}` adalah Zsh parameter expansion yang memecah `$LS_COLORS` (yang dipisahkan oleh `:`) menjadi array.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`menu`** | Style yang mengontrol menu completion/selection. |
| **`select`** | Nilai untuk `menu` yang mengaktifkan menu selection. |
| **`select=n`** | Aktifkan menu selection hanya jika ada >= n kandidat. |
| **`matcher-list`** | Style yang mendefinisikan daftar matcher. |
| **`m:pattern=replacement`** | Map matcher: mengubah input. |
| **`r:pattern=replacement`** | Replace matcher: mengganti input. |
| **`list-colors`** | Style untuk mewarnai daftar completion. |
| **`list-prompt`** | Style untuk prompt saat daftar tidak muat. |

### Diagram Alur: Menu Selection

```bash
User mengetik: git checkout <TAB>
        │
        ▼
Completion menghasilkan 20 branch
        │
        ▼
menu select aktif → tampilkan menu interaktif:

  ┌─────────────────────────────┐
  │ main                        │
  │ feature/login               │
  │ feature/logout              │
  │ bugfix/issue-123            │
  │ ...                         │
  └─────────────────────────────┘

User menekan ↓↓↓ dan Enter
        │
        ▼
Command line menjadi: git checkout feature/logout
```

> **Diagram visual menu selection [kotak dengan daftar kandidat, highlight pada pilihan] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 6 (Context-Sensitive Completion).
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — style ini biasanya didefinisikan di `.zshrc`.
- **Terhubung ke**: Modul 3.1 (Globbing) — matcher menggunakan konsep pattern matching yang sama.

### Sumber Referensi

- Zsh Manual — `menu` style: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 
- Zsh Manual — `matcher-list`: https://zsh.sourceforge.io/Doc/zsh_a4.pdf 
- Zsh Manual — `list-colors`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

### Tips dan Praktik Terbaik

1. **Gunakan `menu select`**: Ini memberikan pengalaman terbaik. Jika terlalu agresif, gunakan `select=5`.
2. **Selalu gunakan case-insensitive matcher**: `m:{a-zA-Z}={A-Za-z}` adalah konfigurasi wajib.
3. **Hati-hati dengan fuzzy matcher**: Performa bisa turun. Gunakan 1–3 matcher maksimal .
4. **Gunakan `list-colors`**: Ini membuat daftar completion jauh lebih mudah dibaca.
5. **Test dengan `menu select=long`**: Jika Anda tidak suka menu selalu muncul, ini hanya menampilkan menu ketika daftar panjang.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Menu tidak muncul | `menu select` tidak di-set atau `zsh/complist` tidak dimuat | Pastikan `zmodload zsh/complist` sebelum `compinit` |
| Matcher tidak bekerja | `matcher-list` tidak di-set atau typo | Cek dengan `zstyle -L ':completion:*' matcher-list` |
| Warna tidak muncul | `list-colors` tidak di-set atau `LS_COLORS` kosong | Set `list-colors` secara manual |
| Performa lambat | Terlalu banyak matcher | Kurangi menjadi 1–3  |

### Latihan Praktis

```bash
# Latihan 1: Aktifkan menu selection
zstyle ':completion:*' menu select

# Latihan 2: Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Ketik: ls Doc<TAB> — apakah menemukan "documents"?

# Latihan 3: Warna
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Ketik: ls <TAB> — apakah direktori berwarna biru?

# Latihan 4: Fuzzy matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
# Ketik: ls foo_bar<TAB> — apakah menemukan "foobar"?
```


## 8. Debugging dan Audit Completion System

*(Sub-bagian tambahan dari audit — tidak ada di daftar isi asli, tetapi penting untuk troubleshooting)*

### Deskripsi Konkret & Peran dalam Kurikulum

Sub-bagian ini membahas **alat dan teknik untuk men-debug** completion system. Ketika completion tidak berfungsi seperti yang diharapkan, Anda perlu tahu bagaimana mencari tahu **mengapa**.

Dalam kurikulum, ini adalah **keterampilan praktis** yang melengkapi Modul 3.2. Completion yang kompleks (seperti yang Anda tulis sendiri) hampir pasti memiliki bug; kemampuan untuk men-debug adalah yang membedakan pengguna yang frustrasi dari pengguna yang produktif.

### Konsep Kunci & Filosofi Mendalam

Filosofi debugging completion adalah **"jangan menebak; lihat."** Completion system Zsh sangat transparan: Anda bisa melihat context string, tag, fungsi yang dipanggil, dan nilai variabel. Menggunakan alat ini secara sistematis akan menghemat waktu.

**Alat utama:**

1. **`_complete_help` (Ctrl+X h)** — Menampilkan context dan tag aktual. Ini adalah alat pertama yang harus Anda gunakan.
2. **`compaudit`** — Menjalankan security check. Berguna jika Anda mengalami masalah dengan file completion yang tidak dimuat .
3. **`zstyle -L`** — Menampilkan style yang aktif.
4. **`zsh -x`** — Menjalankan shell dengan trace; berguna untuk melacak pemanggilan fungsi.

### Sintaks Dasar dan Contoh

```bash
# === _complete_help ===
# Binding default: Ctrl+X h
# Tekan saat completion aktif (setelah menekan TAB)
# Output: context string dan daftar tag

# Contoh output:
# tags in context :completion::complete:git::
#     commands  (_git_commands)
#     ...
# tags in context :completion::complete:git:argument-1::
#     ...

# === compaudit ===
compaudit
# Output: direktori yang tidak aman, jika ada

# === zstyle -L ===
# Lihat semua style yang aktif
zstyle -L

# Lihat style spesifik
zstyle -L ':completion:*' matcher-list
zstyle -L ':completion:*' menu

# === DEBUG DENGAN ZSH -X ===
zsh -x
# Ketik: git <TAB>
# Output: trace pemanggilan fungsi

# === CEK APAKAH FUNGSI COMPDEF ADA ===
# Cek apakah completion function terdaftar
print ${_comps[my_command]}
# atau
whence -v _my_command

# === TEST COMPLETION FUNCTION SECARA LANGSUNG ===
# Panggil fungsi completion dengan variabel yang sesuai
_words=(my_command --)
_CURRENT=2
_my_command
# Output: daftar kandidat (jika fungsi benar)
```

**Penjelasan mendalam tentang `_complete_help`:**

`_complete_help` adalah bindable command yang menampilkan:
1. **Context string** untuk posisi cursor saat ini.
2. **Daftar tag** yang tersedia, beserta fungsi yang menghasilkan tag tersebut.

Ini adalah cara **paling akurat** untuk mengetahui pattern `zstyle` yang harus Anda gunakan. Jika Anda ingin mengonfigurasi style untuk tag tertentu, `_complete_help` akan memberitahu Anda nama tag yang tepat .

**Cara membaca output `_complete_help`:**

```bash
tags in context :completion::complete:git::
    commands  (_git_commands)
    ...
tags in context :completion::complete:git:argument-1::
    ...
```

- `:completion::complete:git::` — Context untuk argumen pertama (command).
- `commands` — Tag.
- `_git_commands` — Fungsi yang menghasilkan tag ini.

Untuk mengonfigurasi style untuk tag `commands` di context ini:
```bash
zstyle ':completion::complete:git:argument-1:commands' <style> <value>
```

**Penjelasan tentang `compaudit`:**

`compaudit` menjalankan security check yang sama dengan `compinit` . Ini berguna jika:
- Anda mendapatkan pesan "insecure directories" saat startup.
- Completion tidak berfungsi dan Anda curiga ada masalah permission.

Output `compaudit` adalah daftar direktori yang tidak aman. Untuk memperbaiki, Anda bisa:
- Mengubah permission direktori.
- Menjalankan `compinit -u` untuk melewati check.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`_complete_help`** | Bindable command untuk menampilkan context dan tag. |
| **`compaudit`** | Fungsi untuk menjalankan security check. |
| **`zstyle -L`** | Opsi untuk menampilkan style yang aktif. |
| **`zsh -x`** | Menjalankan Zsh dengan trace. |
| **`_comps`** | Array yang memetakan perintah ke completion function. |

### Diagram Alur: Debugging Completion

```bash
Completion tidak berfungsi
        │
        ▼
1. Cek context dengan _complete_help (Ctrl+X h)
        │
        ├── Context tidak sesuai harapan?
        │       └── Perbaiki completion function atau zstyle
        │
        └── Context sesuai?
                │
                ▼
2. Cek style dengan zstyle -L
        │
        ├── Style tidak ada?
        │       └── Tambahkan style
        │
        └── Style ada?
                │
                ▼
3. Cek fungsi dengan whence -v _my_function
        │
        ├── Fungsi tidak ada?
        │       └── Pastikan compdef dan autoload
        │
        └── Fungsi ada?
                │
                ▼
4. Trace dengan zsh -x
        │
        └── Lihat error atau nilai variabel yang salah
```

> **Diagram alur [masalah → _complete_help → zstyle -L → whence → zsh -x] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Semua sub-bagian Modul 3.2.
- **Terhubung ke**: Modul 3.3 (Konfigurasi) — debugging sering melibatkan konfigurasi `.zshrc`.

### Sumber Referensi

- Zsh Manual — `_complete_help`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html 
- Zsh Manual — `compaudit`: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 
- Zsh Manual — Debugging: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

### Tips dan Praktik Terbaik

1. **Biasakan menggunakan `_complete_help`**: Ini adalah alat debugging #1 untuk completion.
2. **Gunakan `zstyle -L` untuk memverifikasi konfigurasi**: Terkadang style yang Anda pikir sudah di-set ternyata tidak.
3. **Gunakan `whence -v` untuk memastikan fungsi ada**: Jika fungsi tidak ada, completion tidak akan berfungsi.
4. **Gunakan `zsh -x` dengan hati-hati**: Output bisa sangat banyak. Gunakan `zsh -x 2>&1 | grep my_func` untuk memfilter.
5. **Hapus `.zcompdump` jika ada masalah aneh**: Terkadang dump file yang usang menyebabkan masalah.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `_complete_help` tidak berfungsi | Binding tidak ada | Bind secara manual: `bindkey '^Xh' _complete_help` |
| Context tidak sesuai | Completion function tidak menggunakan `_arguments -C` | Perbaiki function |
| Style tidak berpengaruh | Pattern tidak cocok | Gunakan `_complete_help` untuk context aktual |
| Fungsi tidak dipanggil | `compdef` tidak dipanggil atau nama salah | Cek dengan `print ${_comps[my_command]}` |

### Latihan Praktis

```bash
# Latihan 1: _complete_help
# Ketik: git <Ctrl+X> h
# Catat context string

# Latihan 2: zstyle -L
zstyle -L ':completion:*' menu
zstyle -L ':completion:*' matcher-list

# Latihan 3: Cek fungsi
whence -v _git
print ${_comps[git]}

# Latihan 4: Trace
# zsh -x 2>&1 | grep my_command
# (Ketik: my_command <TAB>, lalu Ctrl+C)
```


## Ringkasan Modul 3.2

| Sub-bagian | Fokus | Alat Utama |
|------------|-------|-----------|
| 1 | Inisialisasi | `compinit`, `.zcompdump` |
| 2 | Konfigurasi | `zstyle` |
| 3 | Context dan Tag | `:completion:function:completer:command:argument:tag` |
| 4 | `compdef` dan `_arguments` | `compdef`, `_arguments`, `_describe` |
| 5 | Menulis Completion Function | `compadd`, `_describe`, `_values` |
| 6 | Context-Sensitive Completion | `_arguments -C`, `$state`, `$words` |
| 7 | Menu Selection dan Matcher | `menu select`, `matcher-list`, `list-colors` |
| 8 | Debugging *(tambahan)* | `_complete_help`, `compaudit`, `zstyle -L` |


## Hubungan Modul 3.2 dengan Modul Berikutnya

Modul 3.2 (Completion) **terhubung erat** dengan Modul 3.3 (Konfigurasi):

1. **`compinit` dan `zstyle` didefinisikan di `.zshrc`**: Modul 3.3 akan membahas di mana dan bagaimana mengatur konfigurasi ini dalam file startup.

2. **Completion function adalah bagian dari konfigurasi**: Ketika Anda menulis completion function sendiri, Anda perlu menyimpannya di file terpisah dan menambahkannya ke `fpath` — ini adalah topik Modul 3.3.

3. **Opsi shell terkait completion**: Opsi seperti `AUTO_MENU`, `MENU_COMPLETE`, `NO_CASE_GLOB` adalah opsi shell yang diatur dengan `setopt` — topik Modul 3.3.

4. **Organisasi `.zshrc`**: Modul 3.3 akan mengajarkan cara mengorganisir `.zshrc` secara modular, termasuk memisahkan konfigurasi completion ke file terpisah.


## Referensi Lengkap Modul 3.2

1. **Zsh Manual — Completion System**: https://zsh.sourceforge.io/Doc/Release/Completion-System.html 
2. **Zsh Manual — Completion Widgets**: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
3. **Ubuntu Manpage — zshcompsys**: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 
4. **Debian Manpage — zshall**: https://manpages.debian.org/unstable/zsh-common/zshall.1.en.html 
5. **zsh-completions GitHub**: https://github.com/zsh-users/zsh-completions 
6. **GeekNews — Menulis completion di Bash dan Zsh**: https://id.news.hada.io/topic?id=22492 
7. **Arch Manpage — compinit**: https://man.archlinux.org/man/zshcompsys.1.en.raw 
8. **Zsh FAQ**: https://zsh.sourceforge.io/FAQ/

## ✅ Daftar yang telah diselesaikan

Materi Modul 3.2 di atas sudah mencakup seluruh sub-bagian dari:

- Urutan pembacaan file startup: `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`
- Opsi shell: `setopt` dan `unsetopt`
- Aliases: efisien vs berbahaya
- PATH dan environment variables
- Fungsi startup dan autoloading
- Organisasi `.zshrc` yang modular

Berikutnya kita akan melanjutkan ke **Modul 3.3: Konfigurasi Zsh — `.zshrc`, Opsi, dan Startup Files**.

---

# Modul 3.3: Konfigurasi Zsh — `.zshrc`, Opsi, dan Startup Files

**Level:** Menengah | **Durasi:** ~6–8 jam | **Prasyarat:** Modul 3.1 dan 3.2


## Daftar Isi Internal (Mini-Daftar Isi)

1. **Arsitektur Startup Zsh: Urutan Pembacaan File** — `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`, `.zlogout`
2. **Opsi Shell: `setopt` dan `unsetopt`** — kontrol perilaku shell secara mendalam
3. **Aliases: Efisien vs Berbahaya** — kapan alias membantu, kapan merusak
4. **PATH dan Environment Variables** — mengelola variabel lingkungan dengan benar
5. **Fungsi Startup dan Autoloading** — `fpath`, `autoload`, dan organisasi fungsi
6. **Organisasi `.zshrc` yang Modular** — struktur `zsh.d/` dan pemuatan berurutan
7. **Optimasi Startup: `zcompile`** *(tambahan audit)* — kompilasi file konfigurasi untuk startup lebih cepat
8. **Keamanan Konfigurasi Zsh** *(tambahan audit)* — permission, `compaudit`, dan praktik aman


## Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **puncak Fase 3**. Setelah Anda menguasai globbing (Modul 3.1) dan completion (Modul 3.2), sekarang saatnya **mengintegrasikan semuanya** ke dalam konfigurasi yang persisten dan terorganisir. Modul ini menjawab pertanyaan: *"Bagaimana saya membuat semua pengetahuan ini menjadi bagian dari lingkungan shell sehari-hari saya?"*

Dalam konteks kurikulum, Modul 3.3 adalah **penghubung antara teori dan praktik**. Semua opsi globbing (`EXTENDED_GLOB`, `NULL_GLOB`), semua konfigurasi completion (`zstyle`, `compinit`), dan semua fungsi kustom yang Anda tulis **harus ditempatkan di file startup yang tepat**. Tanpa memahami arsitektur startup Zsh, Anda akan menempatkan konfigurasi di file yang salah dan bertanya-tanya mengapa tidak berfungsi.


## 1. Arsitektur Startup Zsh: Urutan Pembacaan File

### Deskripsi Konkret & Peran dalam Kurikulum

Zsh membaca **beberapa file** saat startup, tergantung pada apakah shell bersifat *login*, *interaktif*, atau keduanya. Memahami urutan ini adalah **fondasi mutlak** untuk konfigurasi yang benar. Jika Anda menempatkan `export PATH` di `.zshrc` tetapi shell Anda adalah login shell non-interaktif (misalnya untuk script), PATH tersebut tidak akan tersedia.

Dalam kurikulum, sub-bagian ini adalah **prasyarat untuk semua sub-bagian berikutnya**. Anda tidak bisa mengonfigurasi `.zshrc` dengan benar jika Anda tidak tahu kapan `.zshrc` dibaca relatif terhadap file lain.

### Konsep Kunci & Filosofi Mendalam

Filosofi desain Zsh adalah **pemisahan tanggung jawab berdasarkan konteks**. Setiap file startup memiliki "wilayah kekuasaan" sendiri:

- **`.zshenv`** — Selalu dibaca, untuk **semua** shell (login, interaktif, non-interaktif, script). Ini adalah tempat untuk **environment variables** yang harus tersedia bahkan di script.
- **`.zprofile`** — Dibaca hanya untuk **login shell**. Ini adalah tempat untuk konfigurasi yang hanya perlu dijalankan sekali saat login, seperti `PATH` tambahan atau inisialisasi SSH agent.
- **`.zshrc`** — Dibaca hanya untuk **shell interaktif**. Ini adalah tempat untuk **konfigurasi interaktif**: alias, fungsi, prompt, completion, keybindings.
- **`.zlogin`** — Dibaca setelah `.zshrc` untuk **login shell**. Jarang digunakan; biasanya untuk perintah yang harus dijalankan setelah semua konfigurasi interaktif selesai.
- **`.zlogout`** — Dibaca saat **login shell keluar**. Untuk membersihkan resource, mencetak pesan perpisahan, dll.

**Mengapa pemisahan ini penting?** Bayangkan Anda menjalankan script shell yang menggunakan Zsh. Script tersebut bukan login shell dan bukan interaktif. Zsh hanya akan membaca `.zshenv` (dan file global). Jika Anda menaruh `export EDITOR=nvim` di `.zshrc`, script tersebut tidak akan memiliki `$EDITOR`. Jika Anda menaruhnya di `.zshenv`, script akan memilikinya. Inilah mengapa pemahaman urutan ini **krusial**.

**Logika urutan lengkap** (dari dokumentasi resmi Zsh):

1. `/etc/zshenv` — **selalu**, tidak bisa di-override
2. `$ZDOTDIR/.zshenv` — **selalu** (kecuali `RCS` di-unset)
3. `/etc/zprofile` — hanya jika **login shell**
4. `$ZDOTDIR/.zprofile` — hanya jika **login shell**
5. `/etc/zshrc` — hanya jika **interaktif**
6. `$ZDOTDIR/.zshrc` — hanya jika **interaktif**
7. `/etc/zlogin` — hanya jika **login shell**
8. `$ZDOTDIR/.zlogin` — hanya jika **login shell**

**Saat keluar:**

9. `$ZDOTDIR/.zlogout`
10. `/etc/zlogout`

**Catatan tentang `$ZDOTDIR`**: Jika `$ZDOTDIR` tidak di-set, Zsh menggunakan `$HOME`. Anda bisa mengatur `$ZDOTDIR` untuk menempatkan semua file dotfiles di direktori kustom (misalnya `~/.config/zsh/`).

### Sintaks Dasar dan Contoh

```bash
# === MELIHAT URUTAN FILE YANG DIBACA ===
# Jalankan Zsh dengan xtrace untuk melihat file mana yang dibaca
zsh -x -i -c 'exit' 2>&1 | grep -E '\.(zshenv|zprofile|zshrc|zlogin)'

# === MENGATUR ZDOTDIR ===
# Di ~/.zshenv (file pertama yang dibaca):
export ZDOTDIR="$HOME/.config/zsh"

# Sekarang Zsh akan mencari:
#   ~/.config/zsh/.zshenv
#   ~/.config/zsh/.zprofile
#   ~/.config/zsh/.zshrc
#   ~/.config/zsh/.zlogin
#   ~/.config/zsh/.zlogout

# === STRUKTUR DIREKTORI YANG DIREKOMENDASIKAN ===
# ~/.config/zsh/
# ├── .zshenv          → environment variables minimal
# ├── .zprofile        → PATH tambahan, SSH agent
# ├── .zshrc           → konfigurasi interaktif utama
# ├── .zlogin          → perintah setelah login
# ├── .zlogout         → cleanup saat logout
# └── zsh.d/           → modul konfigurasi (dibahas di sub-bagian 6)

# === ISI FILE YANG TEPAT ===

# ~/.zshenv — MINIMAL. Hanya environment variables.
# File ini dibaca oleh SEMUA shell, termasuk script. Jaga tetap kecil.
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="id_ID.UTF-8"
export LC_ALL="id_ID.UTF-8"

# ~/.zprofile — LOGIN SHELL ONLY.
# Untuk PATH tambahan dan inisialisasi sekali per login.
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export GOPATH="$HOME/go"

# Mulai SSH agent (hanya sekali per login)
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# ~/.zshrc — INTERACTIVE SHELL ONLY.
# Untuk alias, fungsi, prompt, completion, keybindings.
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB NULL_GLOB GLOB_DOTS
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

# Load completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Aliases
alias ll='ls -la'
alias gs='git status'
alias reload='exec zsh'

# Prompt (contoh sederhana)
autoload -Uz promptinit && promptinit
PS1='%n@%m:%~%# '

# ~/.zlogin — SETELAH .zshrc untuk login shell.
# Sangat jarang digunakan. Contoh: cetak pesan selamat datang.
print "Selamat datang, $USER. Ada $(ls -1 ~/todo 2>/dev/null | wc -l) item todo."

# ~/.zlogout — SAAT LOGOUT.
# Contoh: simpan history, bersihkan.
print "Sampai jumpa!"
```

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Login Shell** | Shell yang dijalankan saat login pertama (misalnya setelah SSH, atau `zsh -l`). Membaca `.zprofile` dan `.zlogin`. |
| **Interactive Shell** | Shell yang menerima input dari pengguna (terminal). Membaca `.zshrc`. |
| **Non-interactive Shell** | Shell yang menjalankan script (tanpa input pengguna). Hanya membaca `.zshenv`. |
| **`$ZDOTDIR`** | Variabel yang menentukan direktori tempat Zsh mencari file dotfiles. Default: `$HOME`. |
| **`RCS`** | Opsi shell yang mengontrol apakah file startup dibaca. Jika di-unset, semua file startup (kecuali `/etc/zshenv`) tidak dibaca. |
| **`GLOBAL_RCS`** | Opsi shell yang mengontrol apakah file startup global (di `/etc`) dibaca. |
| **`.zwc`** | File terkompilasi dari file Zsh (dibahas di sub-bagian 7). |

### Diagram Alur: Urutan Pembacaan File Startup

```bash
Zsh dimulai
    │
    ▼
┌─────────────────────────────────────┐
│ /etc/zshenv                         │  ← SELALU (tidak bisa di-override)
│ $ZDOTDIR/.zshenv                    │  ← SELALU
└─────────────────────────────────────┘
    │
    ▼
Apakah login shell?
    │
    ├── YA ──→ ┌─────────────────────────────────────┐
    │          │ /etc/zprofile                       │
    │          │ $ZDOTDIR/.zprofile                  │
    │          └─────────────────────────────────────┘
    │
    ▼
Apakah interaktif?
    │
    ├── YA ──→ ┌─────────────────────────────────────┐
    │          │ /etc/zshrc                          │
    │          │ $ZDOTDIR/.zshrc                     │
    │          └─────────────────────────────────────┘
    │
    ▼
Apakah login shell?
    │
    ├── YA ──→ ┌─────────────────────────────────────┐
    │          │ /etc/zlogin                         │
    │          │ $ZDOTDIR/.zlogin                    │
    │          └─────────────────────────────────────┘
    │
    ▼
Shell siap digunakan
    │
    ▼
Saat keluar (login shell):
    │
    ├──→ $ZDOTDIR/.zlogout
    └──→ /etc/zlogout
```

> **Diagram alur [Zsh start → cek login → cek interaktif → file yang dibaca] akan sangat membantu di sini.** Diagram ini adalah referensi visual yang harus dihafal oleh setiap pengguna Zsh.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Semua modul sebelumnya (1.x, 2.x, 3.1, 3.2).
- **Prasyarat untuk**: Semua sub-bagian berikutnya di Modul 3.3.
- **Terhubung ke**: Modul 3.1 — opsi globbing (`EXTENDED_GLOB`, dll.) harus ditempatkan di `.zshrc`.
- **Terhubung ke**: Modul 3.2 — `compinit` dan `zstyle` harus ditempatkan di `.zshrc`.

### Sumber Referensi

- Zsh Manual — Startup/Shutdown Files: https://zsh.sourceforge.io/Doc/Release/Files.html 
- FreeBSD Manpage — zshall (Startup/Shutdown Files): https://man.freebsd.org/cgi/man.cgi?query=zshall 
- An Introduction to the Z Shell — Startup Files: https://zsh.sourceforge.io/Intro/intro.html 

### Tips dan Praktik Terbaik

1. **Jaga `.zshenv` tetap minimal**: File ini dibaca oleh **setiap** shell, termasuk script yang berjalan cepat. Jangan letakkan konfigurasi berat di sini.
2. **Letakkan `PATH` di `.zprofile`, bukan `.zshrc`**: `PATH` adalah environment variable yang harus tersedia untuk semua proses anak, bukan hanya shell interaktif.
3. **Letakkan konfigurasi interaktif di `.zshrc`**: Alias, prompt, completion, dan keybindings tidak diperlukan untuk script.
4. **Gunakan `$ZDOTDIR` untuk organisasi**: Ini memungkinkan Anda menempatkan semua dotfiles di satu direktori yang rapi.
5. **Test dengan `zsh -l` dan `zsh -i`**: Untuk memastikan konfigurasi Anda berfungsi di berbagai mode shell.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| `$EDITOR` tidak tersedia di script | Diletakkan di `.zshrc` (tidak dibaca script) | Pindahkan ke `.zshenv` |
| `PATH` tidak diperbarui setelah login | Diletakkan di `.zshrc` tetapi shell bukan interaktif | Pindahkan ke `.zprofile` |
| Konfigurasi di `.zshrc` tidak dibaca | Shell dijalankan dengan `zsh -c` (non-interaktif) | Gunakan `zsh -i -c` atau pindahkan ke `.zshenv` |
| `.zprofile` tidak dibaca | Shell bukan login shell | Gunakan `zsh -l` atau login melalui SSH |
| Dua kali `compinit` | `compinit` dipanggil di `.zshrc` dan framework juga memanggilnya | Cek dengan `grep compinit ~/.zshrc` |


## 2. Opsi Shell: `setopt` dan `unsetopt`

### Deskripsi Konkret & Peran dalam Kurikulum

`setopt` dan `unsetopt` adalah **kendali utama perilaku shell**. Zsh memiliki ratusan opsi yang mengontrol segala hal: dari cara globbing bekerja, bagaimana history disimpan, apakah `cd` bisa dilakukan tanpa mengetik `cd`, hingga format prompt.

Dalam kurikulum, sub-bagian ini adalah **tempat di mana semua opsi dari Modul 3.1 dan 3.2 menjadi permanen**. Opsi seperti `EXTENDED_GLOB`, `NULL_GLOB`, dan `SHARE_HISTORY` harus di-set di `.zshrc` agar berlaku di setiap sesi.

### Konsep Kunci & Filosofi Mendalam

Filosofi `setopt` adalah **"kontrol granular tanpa batas"**. Zsh percaya bahwa pengguna harus bisa menyesuaikan **setiap aspek** perilaku shell. Ini berbeda dari Bash yang memiliki opsi terbatas.

**Nama opsi bersifat case-insensitive dan underscore diabaikan** . Artinya, `AUTO_CD`, `autocd`, dan `auto_cd` semuanya merujuk ke opsi yang sama. Ini memudahkan penulisan: Anda bisa menggunakan gaya yang konsisten.

**Cara menonaktifkan opsi**: Ada dua cara :
1. `unsetopt AUTO_CD` — perintah terpisah.
2. `setopt NO_AUTO_CD` — prefix `NO` pada nama opsi.

Keduanya setara. Prefix `NO` berguna ketika Anda ingin menonaktifkan opsi dalam satu baris `setopt`.

**Peringatan penting**: Berbeda dengan `set -o`, nama opsi yang salah pada `setopt` **tidak** membatalkan eksekusi shell. Ini karena `setopt` bukan POSIX special builtin . Jadi, jika Anda typo, Anda tidak akan mendapatkan error yang jelas — opsi tersebut hanya tidak akan di-set. Selalu verifikasi dengan `setopt` (tanpa argumen) untuk melihat opsi yang aktif.

### Sintaks Dasar dan Contoh

```bash
# === MELIHAT OPSI YANG AKTIF ===
setopt                      # Tampilkan semua opsi yang aktif
setopt | grep GLOB          # Filter opsi yang mengandung "GLOB"

# === MENGAKTIFKAN OPSI ===
setopt AUTO_CD              # cd tanpa mengetik "cd"
setopt EXTENDED_GLOB        # Aktifkan ^ dan ~ untuk globbing
setopt NULL_GLOB            # Pola glob yang gagal menghilang (bukan error)

# === MENONAKTIFKAN OPSI ===
unsetopt AUTO_CD            # Cara 1
setopt NO_AUTO_CD           # Cara 2 (setara)

# === OPSI REKOMENDASI UNTUK .zshrc ===

# --- Navigasi Direktori ---
setopt AUTO_CD              # cd tanpa "cd"
setopt AUTO_PUSHD           # cd menyimpan direktori lama ke stack
setopt PUSHD_IGNORE_DUPS    # Hindari duplikasi di stack
setopt PUSHD_SILENT         # Jangan cetak stack setelah pushd/popd
setopt CD_SILENT            # Jangan cetak direktori setelah cd

# --- Globbing dan Ekspansi ---
setopt EXTENDED_GLOB        # ^, ~, # untuk pattern matching
setopt GLOB_DOTS            # Sertakan file hidden dalam glob (hati-hati!)
setopt NULL_GLOB            # Pola glob yang gagal menghilang
setopt NOMATCH              # (default) Error jika pola glob tidak cocok

# --- History ---
setopt HIST_IGNORE_ALL_DUPS # Hapus duplikat lama dari history
setopt HIST_IGNORE_SPACE    # Jangan simpan perintah yang diawali spasi
setopt HIST_REDUCE_BLANKS   # Hapus spasi berlebih dari history
setopt HIST_VERIFY          # Tampilkan perintah sebelum eksekusi (history expansion)
setopt SHARE_HISTORY        # Bagikan history antar terminal
setopt APPEND_HISTORY       # Tambahkan ke history, jangan timpa
setopt EXTENDED_HISTORY     # Simpan timestamp di history

# --- Koreksi dan UX ---
setopt CORRECT              # Koreksi ejaan perintah otomatis
setopt INTERACTIVE_COMMENTS # Izinkan komentar (#) di shell interaktif
setopt NO_BEEP              # Matikan beep
setopt PROMPT_SUBST         # Izinkan substitusi di prompt

# --- Keamanan ---
setopt NO_CLOBBER           # Cegah > menimpa file yang ada
```

**Penjelasan mendalam tentang opsi kunci:**

- **`AUTO_CD`** — Jika Anda mengetik `Documents` (sebuah direktori) dan menekan Enter, Zsh akan melakukan `cd Documents` secara otomatis. Ini menghemat ketikan.
- **`AUTO_PUSHD`** — Setiap `cd` akan mendorong direktori lama ke **directory stack**. Anda bisa kembali dengan `cd -` atau `popd`. Ini sangat berguna untuk navigasi bolak-balik.
- **`EXTENDED_GLOB`** — Mengaktifkan `^` (negasi), `~` (exclusion), dan `#` (repetisi) dalam pattern matching. **Wajib** jika Anda menggunakan teknik dari Modul 3.1 sub-bagian 6.
- **`SHARE_HISTORY`** — Semua terminal Zsh berbagai history yang sama. Jika Anda mengetik perintah di terminal A, perintah itu akan muncul di history terminal B. Ini sangat berguna saat bekerja dengan banyak tab.
- **`HIST_IGNORE_ALL_DUPS`** — Menghapus duplikat **lama** dari history. Jika Anda menjalankan `ls` 10 kali, hanya yang terakhir yang tersimpan.
- **`NO_CLOBBER`** — Mencegah `>` menimpa file yang sudah ada. Gunakan `>|` atau `>!` untuk memaksa menimpa. Ini adalah pengaman yang sangat berguna.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`setopt`** | Builtin Zsh untuk mengaktifkan opsi shell. |
| **`unsetopt`** | Builtin untuk menonaktifkan opsi. |
| **Prefix `NO`** | Alternatif untuk `unsetopt`: `setopt NO_AUTO_CD`. |
| **Directory Stack** | Tumpukan direktori yang dikunjungi, dikelola dengan `pushd`/`popd`. |
| **History Expansion** | Fitur `!!`, `!$`, dll. untuk merujuk perintah sebelumnya. |
| **`PROMPT_SUBST`** | Mengizinkan `$var` dan `$(cmd)` di dalam prompt. |

### Diagram Alur: Opsi sebagai Saklar Perilaku

```bash
Opsi: AUTO_CD
    │
    ├── ON  → Ketik "Documents" → Zsh melakukan cd Documents
    │
    └── OFF → Ketik "Documents" → Zsh mencoba menjalankan perintah "Documents" → error

Opsi: EXTENDED_GLOB
    │
    ├── ON  → ^*.tmp berfungsi sebagai negasi glob
    │
    └── OFF → ^*.tmp dianggap literal atau error

Opsi: SHARE_HISTORY
    │
    ├── ON  → Terminal A dan B berbagi history
    │
    └── OFF → Setiap terminal memiliki history terpisah
```

> **Tabel visual [Opsi, ON, OFF, Dampak] akan sangat membantu di sini.** Tabel ini adalah referensi cepat untuk memahami efek setiap opsi.

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 1 (Startup Files) — opsi harus di-set di file yang tepat.
- **Terhubung ke**: Modul 3.1 — `EXTENDED_GLOB`, `GLOB_DOTS`, `NULL_GLOB` adalah opsi yang mempengaruhi globbing.
- **Terhubung ke**: Modul 3.2 — completion system juga dipengaruhi oleh beberapa opsi shell.

### Sumber Referensi

- Zsh Manual — Options: https://zsh.sourceforge.io/Doc/Release/Options.html 
- Linux Command Library — setopt: https://linuxcommandlibrary.com/man/setopt 
- GitHub — durant/environment (opsi Zsh): https://github.com/durant/environment 

### Tips dan Praktik Terbaik

1. **Mulai dengan opsi minimal**: Jangan aktifkan semua opsi sekaligus. Tambahkan satu per satu dan rasakan dampaknya.
2. **Gunakan `setopt` tanpa argumen untuk verifikasi**: Setelah menambah opsi di `.zshrc`, jalankan `setopt` untuk memastikan opsi tersebut aktif.
3. **Hati-hati dengan `GLOB_DOTS`**: Opsi ini membuat `*` mencocokkan file hidden, yang bisa berbahaya untuk perintah seperti `rm *`.
4. **`NO_CLOBBER` adalah pengaman yang direkomendasikan**: Ini mencegah Anda tidak sengaja menimpa file penting.
5. **`SHARE_HISTORY` sangat berguna untuk multi-terminal**: Jika Anda sering bekerja dengan banyak tab, aktifkan ini.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Opsi tidak berpengaruh | Typo nama opsi (setopt tidak error) | Gunakan `setopt` tanpa argumen untuk verifikasi |
| `AUTO_CD` membuat perintah salah dieksekusi | Ada direktori dengan nama yang sama dengan perintah | `unsetopt AUTO_CD` jika mengganggu |
| `SHARE_HISTORY` menyebabkan history kacau | Dua terminal menulis bersamaan | Ini normal; gunakan `HIST_IGNORE_ALL_DUPS` untuk mengurangi duplikat |
| `NO_CLOBBER` menghalangi `>` yang disengaja | Opsi aktif | Gunakan `>\|` untuk memaksa menimpa |
| `EXTENDED_GLOB` mengubah perilaku `^` | `^` sebelumnya literal, sekarang negasi | Sesuaikan pattern yang menggunakan `^` literal |


## 3. Aliases: Efisien vs Berbahaya

### Deskripsi Konkret & Peran dalam Kurikulum

Aliases adalah **jalan pintas** untuk perintah yang sering digunakan. Mereka adalah cara paling sederhana untuk mengurangi friksi dalam penggunaan shell sehari-hari.

Dalam kurikulum, sub-bagian ini adalah **lapisan kenyamanan**. Setelah Anda mengonfigurasi opsi dan startup files, aliases adalah sentuhan akhir yang membuat shell terasa "milik Anda".

### Konsep Kunci & Filosofi Mendalam

Filosofi aliases adalah **"DRY: Don't Repeat Yourself"**. Jika Anda mengetik `git status` 50 kali sehari, mengapa tidak mengetik `gs` saja?

Namun, ada filosofi tandingan: **"Aliases adalah makro yang tidak higienis"** . Mereka dapat menyebabkan kebingungan, terutama dalam script yang dibagikan. Orang lain yang membaca script Anda mungkin tidak tahu bahwa `gs` adalah alias untuk `git status`. Ini adalah alasan mengapa banyak panduan merekomendasikan **fungsi** daripada alias untuk perintah yang kompleks.

**Prinsip utama**: 
- **Alias** — untuk **shortcut sederhana** tanpa logika. Contoh: `alias ll='ls -la'`.
- **Fungsi** — untuk **logika kompleks**. Contoh: `mkcd() { mkdir -p "$1" && cd "$1" }`.

**Bahaya alias**:
1. **Overriding perintah standar** — `alias rm='rm -i'` mengubah perilaku `rm` secara global. Ini bisa membingungkan dan **tidak bekerja di script** (karena script biasanya tidak membaca `.zshrc`).
2. **Alias rekursif** — `alias ls='ls --color'` aman karena Zsh tahu untuk tidak mengganti `ls` di dalam definisi alias itu sendiri. Tetapi dalam kasus tertentu, rekursi bisa terjadi.
3. **Alias yang mengandung pipe** — `alias foo='bar | baz'` adalah praktik yang buruk karena alias tidak bisa menerima argumen tambahan dengan benar. Gunakan fungsi.
4. **Alias vs Fungsi** — Jika Anda mendefinisikan fungsi dengan nama yang sama dengan alias, **fungsi tidak akan menggantikan alias** . Ini adalah sumber kebingungan.

### Sintaks Dasar dan Contoh

```bash
# === ALIAS SEDERHANA (AMAN) ===
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias reload='exec zsh'
alias ..='cd ..'
alias ...='cd ../..'

# === ALIAS UNTUK KOREKSI TYPO ===
alias gti='git'
alias gis='git'
alias mkae='make'

# === ALIAS YANG BERBAHAYA / TIDAK DIREKOMENDASIKAN ===
# ❌ Jangan lakukan ini:
alias rm='rm -i'            # Mengubah perilaku rm secara global
alias cp='cp -i'            # Sama, mengubah perilaku standar
alias mv='mv -i'            # Sama
alias ls='ls --color=auto'  # Bisa menyebabkan masalah di beberapa sistem

# ✅ Alternatif yang lebih baik (fungsi):
rm() {
    command rm -i "$@"
}
# Tetapi ini masih mengubah perilaku global. Lebih baik:
alias del='rm -i'           # Nama baru, bukan override

# === ALIAS DENGAN ARGUMEN (TIDAK DIDUKUNG) ===
# ❌ Alias tidak bisa menerima argumen seperti fungsi:
alias grep='grep --color=auto'  # Ini OK karena tidak perlu argumen tambahan

# ❌ Ini TIDAK berfungsi seperti yang diharapkan:
alias mkcd='mkdir -p $1 && cd $1'  # $1 tidak akan diisi!

# ✅ Gunakan fungsi sebagai gantinya:
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# === MELIHAT ALIAS YANG AKTIF ===
alias                       # Tampilkan semua alias
alias ll                    # Tampilkan alias "ll" spesifik

# === MENGHAPUS ALIAS ===
unalias ll                  # Hapus alias "ll"
unalias -a                  # Hapus SEMUA alias (hati-hati!)
```

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Alias** | Nama pendek untuk perintah yang lebih panjang. |
| **`unalias`** | Perintah untuk menghapus alias. |
| **`command`** | Builtin untuk menjalankan perintah asli, melewati alias/fungsi. |
| **Global Alias** | Alias yang berlaku di mana saja, bukan hanya di awal perintah (jarang digunakan, berbahaya). |
| **Fungsi** | Blok kode yang dapat menerima argumen, lebih powerful daripada alias. |

### Diagram Alur: Alias vs Fungsi

```bash
Anda mengetik: ll

Sistem memeriksa:
  1. Apakah "ll" adalah alias? → YA → Ganti dengan "ls -la"
  2. Apakah "ll" adalah fungsi? → Jika ya, fungsi dijalankan
  3. Apakah "ll" adalah builtin? → Jika ya, builtin dijalankan
  4. Apakah "ll" adalah perintah eksternal? → Jika ya, cari di PATH

Prioritas: Alias > Fungsi > Builtin > Perintah eksternal
(Ini adalah salah satu alasan mengapa alias bisa membingungkan)
```

> **Diagram alur [resolusi nama perintah: alias → fungsi → builtin → PATH] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 1 (Startup Files) — alias harus di `.zshrc`.
- **Terhubung ke**: Sub-bagian 5 (Fungsi) — fungsi adalah alternatif yang lebih powerful untuk alias.
- **Terhubung ke**: Modul 3.1 — beberapa alias mungkin menggunakan glob qualifiers.

### Sumber Referensi

- Zsh Manual — Aliases: https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Aliasing 
- ZSH Configuration Conventions: https://raw.githubusercontent.com 
- Zsh Mailing List — Global Alias Discussion: https://zsh.org/mla/users/2023/msg00101.html 

### Tips dan Praktik Terbaik

1. **Gunakan alias hanya untuk shortcut sederhana**: Jika ada logika (kondisi, pipe, argumen), gunakan fungsi.
2. **Jangan override perintah standar**: Alih-alih `alias rm='rm -i'`, gunakan `alias del='rm -i'`.
3. **Beri nama yang jelas**: `alias gs='git status'` lebih baik daripada `alias s='git status'` (yang bisa bentrok).
4. **Dokumentasikan alias Anda**: Di `.zshrc`, beri komentar untuk setiap alias.
5. **Test alias di shell interaktif**: Sebelum menaruh di `.zshrc`, test dulu di command line.
6. **Hindari global alias**: Mereka adalah "makro yang tidak higienis" dan dapat menyebabkan perilaku tak terduga .

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Alias tidak berfungsi di script | Script tidak membaca `.zshrc` | Definisikan fungsi, bukan alias |
| Alias rekursif | `alias ls='ls -la'` | Zsh menangani ini dengan baik, tetapi hati-hati |
| Fungsi tidak menggantikan alias | Alias sudah ada dengan nama yang sama | `unalias nama` dulu, lalu definisikan fungsi |
| `$1` tidak berfungsi di alias | Alias tidak menerima argumen | Gunakan fungsi |
| Alias hilang setelah restart | Tidak diletakkan di `.zshrc` | Tambahkan ke `.zshrc` |


## 4. PATH dan Environment Variables

### Deskripsi Konkret & Peran dalam Kurikulum

`PATH` dan environment variables adalah **jembatan antara shell dan sistem operasi**. Mereka menentukan di mana shell mencari perintah, editor default apa yang digunakan, bahasa apa yang ditampilkan, dan banyak lagi.

Dalam kurikulum, sub-bagian ini adalah **koneksi ke dunia luar**. Semua pengetahuan Zsh tidak akan berguna jika Anda tidak bisa menjalankan perintah yang Anda butuhkan karena `PATH` salah.

### Konsep Kunci & Filosofi Mendalam

Filosofi environment variables adalah **"konfigurasi melalui lingkungan"**. Alih-alih hard-code path di setiap program, program membaca environment variables untuk mengetahui preferensi pengguna. Ini adalah prinsip desain Unix yang mendalam: **program harus dapat dikonfigurasi tanpa diubah**.

**`PATH`** adalah environment variable yang paling penting. Ini adalah daftar direktori yang dipisahkan oleh `:` yang memberi tahu shell di mana harus mencari perintah yang dapat dieksekusi.

**Urutan `PATH` penting**: Direktori pertama memiliki prioritas tertinggi. Jika ada `python` di `/usr/bin` dan `/usr/local/bin`, dan `/usr/local/bin` muncul lebih dulu di `PATH`, maka `python` dari `/usr/local/bin` yang akan dijalankan.

**Di mana menempatkan environment variables?**
- **`.zshenv`** — Untuk variabel yang harus tersedia di **semua** shell (termasuk script). Contoh: `EDITOR`, `LANG`.
- **`.zprofile`** — Untuk `PATH` dan variabel yang hanya perlu di-set sekali per login. Contoh: `PATH`, `GOPATH`.
- **`.zshrc`** — Untuk variabel yang hanya relevan untuk shell interaktif. Contoh: `PROMPT`, variabel tema.

**Mengapa tidak menaruh semuanya di `.zshrc`?** Karena script tidak membaca `.zshrc`. Jika Anda menaruh `EDITOR` di `.zshrc`, script yang memanggil `$EDITOR` tidak akan menemukannya. Jika Anda menaruh `PATH` di `.zshrc`, script juga tidak akan menemukan perintah yang ada di path tambahan tersebut.

### Sintaks Dasar dan Contoh

```bash
# === MELIHAT ENVIRONMENT VARIABLES ===
printenv                    # Tampilkan semua environment variables
echo $PATH                  # Tampilkan PATH
printenv PATH               # Cara lain

# === MENGAKTIFKAN VARIABEL (SEMENTARA) ===
export EDITOR="nvim"        # Hanya untuk sesi ini
export MY_VAR="value"       # Variabel biasa

# === PATH — MENAMBAH DIREKTORI ===
# Tambah di DEPAN (prioritas tertinggi)
export PATH="$HOME/.local/bin:$PATH"

# Tambah di BELAKANG (prioritas terendah)
export PATH="$PATH:$HOME/.local/bin"

# Tambah beberapa direktori sekaligus
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# Hindari duplikasi di PATH
typeset -U path             # "U" = unique
path=("$HOME/.local/bin" $path)

# === VARIABEL YANG DIREKOMENDASIKAN ===

# ~/.zshenv — untuk SEMUA shell
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LANG="id_ID.UTF-8"
export LC_ALL="id_ID.UTF-8"

# ~/.zprofile — untuk LOGIN SHELL (PATH)
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

# ~/.zshrc — untuk INTERACTIVE SHELL
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# === VARIABEL DENGAN NILAI DINAMIS ===
# Gunakan $() untuk nilai yang dihitung
export GIT_AUTHOR_NAME="$(git config user.name)"
export GIT_AUTHOR_EMAIL="$(git config user.email)"

# === CEK APAKAH VARIABEL SUDAH ADA ===
if [[ -z "$EDITOR" ]]; then
    export EDITOR="nvim"
fi

# === MENGHAPUS VARIABEL ===
unset MY_VAR
```

**Penjelasan mendalam tentang `typeset -U path`:**

Zsh memiliki keunikan: variabel `path` (huruf kecil) adalah **array** yang terhubung dengan `PATH` (huruf besar). Mengubah `path` akan mengubah `PATH`, dan sebaliknya .

```bash
# path adalah array
path=("/usr/local/bin" "/usr/bin" "/bin")
echo $PATH
# Output: /usr/local/bin:/usr/bin:/bin

# typeset -U path membuat array unik (tidak ada duplikat)
typeset -U path
path=("/usr/bin" "/usr/local/bin" "/usr/bin")
echo $PATH
# Output: /usr/bin:/usr/local/bin
```

Ini adalah fitur Zsh yang sangat berguna: Anda bisa mengelola `PATH` sebagai array, bukan string yang dipisahkan `:`. Ini memudahkan penambahan, penghapusan, dan pengecekan duplikat.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Environment Variable** | Variabel yang tersedia untuk semua proses anak. |
| **`export`** | Perintah untuk membuat variabel menjadi environment variable. |
| **`PATH`** | Daftar direktori yang dicari shell untuk menemukan perintah. |
| **`path`** | Array Zsh yang terhubung dengan `PATH`. |
| **`typeset -U`** | Membuat array unik (tidak ada duplikat). |
| **`printenv`** | Perintah untuk menampilkan environment variables. |
| **`unset`** | Menghapus variabel. |

### Diagram Alur: Resolusi Perintah dengan PATH

```bash
Anda mengetik: python3

Shell mencari di setiap direktori di $PATH secara berurutan:
  /home/user/.local/bin/python3  → tidak ada
  /home/user/go/bin/python3      → tidak ada
  /usr/local/bin/python3         → ADA! ✅

Shell menjalankan /usr/local/bin/python3
```

> **Diagram alur [PATH resolution: cek setiap direktori secara berurutan] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 1 (Startup Files) — environment variables harus di file yang tepat.
- **Terhubung ke**: Modul 3.2 — completion untuk `PATH` dan environment variables.
- **Terhubung ke**: Sub-bagian 5 (Fungsi) — fungsi sering menggunakan environment variables.

### Sumber Referensi

- PhoenixNAP — How to Set Environment Variables in Zsh: https://phoenixnap.com/kb/zsh-environment-variables 
- Hoop.dev — Managing Environment Variables in Zsh: https://hoop.dev 
- Zsh Manual — Parameters: https://zsh.sourceforge.io/Doc/Release/Parameters.html 

### Tips dan Praktik Terbaik

1. **Gunakan `typeset -U path` untuk menghindari duplikasi**: Ini adalah fitur Zsh yang sangat berguna.
2. **Urutan PATH penting**: Direktori yang ingin Anda prioritaskan harus di depan.
3. **Test dengan `which` atau `type`**: `which python3` akan menunjukkan path mana yang digunakan.
4. **Jangan menaruh `PATH` di `.zshrc`**: Script tidak akan menemukannya. Letakkan di `.zprofile` atau `.zshenv`.
5. **Gunakan `$HOME` bukan `~` di `export`**: `~` tidak selalu diperluas dengan benar di semua konteks.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Perintah tidak ditemukan | PATH tidak mencakup direktori yang benar | `echo $PATH` dan bandingkan |
| PATH duplikat | Menambahkan path berulang kali | `typeset -U path` atau restart shell |
| `$EDITOR` kosong di script | Diletakkan di `.zshrc` | Pindahkan ke `.zshenv` |
| PATH tidak diperbarui | Diletakkan di file yang salah | Pastikan di `.zprofile` atau `.zshenv` |
| `~` tidak diperluas | Digunakan di `export` tanpa quote | Gunakan `$HOME` atau quote dengan benar |


## 5. Fungsi Startup dan Autoloading

### Deskripsi Konkret & Peran dalam Kurikulum

Fungsi adalah **blok kode yang dapat digunakan kembali** dengan nama. Mereka lebih powerful daripada alias karena dapat menerima argumen, memiliki logika, dan dapat di-autoload (dimuat saat dibutuhkan, bukan saat startup).

Dalam kurikulum, sub-bagian ini adalah **langkah menuju modularitas**. Dengan fungsi, Anda dapat memecah konfigurasi Anda menjadi komponen-komponen yang dapat digunakan kembali. Dengan autoloading, Anda dapat memuat fungsi hanya saat dibutuhkan, mengurangi waktu startup.

### Konsep Kunci & Filosofi Mendalam

Filosofi fungsi adalah **"abstraksi"**. Alih-alih mengetik serangkaian perintah setiap kali, Anda mendefinisikannya sekali dan memanggilnya dengan nama.

Filosofi autoloading adalah **"lazy loading"**. Tidak semua fungsi perlu dimuat saat shell startup. Fungsi yang jarang digunakan dapat "dibekukan" dalam file terpisah dan dimuat hanya saat pertama kali dipanggil. Ini adalah trade-off antara **waktu startup** dan **ketersediaan langsung**.

**Bagaimana autoloading bekerja**:

1. Anda menambahkan direktori ke `$fpath` — array direktori yang dicari Zsh untuk fungsi autoload.
2. Anda menandai fungsi sebagai autoload dengan `autoload -Uz namafungsi`.
3. Saat fungsi pertama kali dipanggil, Zsh mencari file `namafungsi` di setiap direktori di `$fpath`.
4. File tersebut dibaca dan dieksekusi. Untuk fungsi autoload, file biasanya berisi **tubuh fungsi** (bukan definisi fungsi lengkap).

**Format file fungsi autoload**:

```bash
# File: ~/.zsh/functions/mkcd
# TIDAK perlu "mkcd() {" di awal
# Langsung isi fungsi:
mkdir -p "$1" && cd "$1"
```

Dokumentasi Zsh menyatakan: "A function can be marked as undefined using the `autoload` builtin. Such a function has no body. When the function is first executed, the shell searches for its definition using the elements of the `fpath` variable".

**`autoload -Uz`**:
- `-U` — Suppress alias expansion saat membaca file. **Direkomendasikan** untuk fungsi yang disediakan Zsh.
- `-z` — Mark fungsi sebagai Zsh-native (bukan Ksh-style autoload).

### Sintaks Dasar dan Contoh

```bash
# === FUNGSI DASAR DI .zshrc ===
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Fungsi dengan validasi
gclone() {
    if [[ -z "$1" ]]; then
        print "Usage: gclone <repo-url>" >&2
        return 1
    fi
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Fungsi dengan deskripsi (untuk completion)
# Gunakan format: #compdef namafungsi
```

```bash
# === AUTOLOADING ===

# 1. Buat direktori untuk fungsi
mkdir -p ~/.zsh/functions

# 2. Tambahkan ke fpath (di .zshrc)
fpath=(~/.zsh/functions $fpath)

# 3. Buat file fungsi (TANPA definisi fungsi lengkap)
cat > ~/.zsh/functions/mkcd << 'EOF'
mkdir -p "$1" && cd "$1"
EOF

# 4. Tandai sebagai autoload (di .zshrc)
autoload -Uz mkcd

# Sekarang mkcd akan dimuat hanya saat pertama kali dipanggil

# === AUTOLOAD BANYAK FUNGSI SEKALIGUS ===
for func in ~/.zsh/functions/*(N.:t); do
    autoload -Uz "$func"
done

# Penjelasan:
#   ~/.zsh/functions/*  — semua file di direktori
#   (N)                 — NULL_GLOB (jangan error jika kosong)
#   .                   — hanya file reguler
#   :t                  — tail (nama file saja, tanpa path)
```

**Penjelasan mendalam tentang `fpath`:**

`fpath` adalah **array** direktori tempat Zsh mencari fungsi autoload. Ini mirip dengan `PATH` tetapi untuk fungsi, bukan perintah eksternal.

```bash
# Lihat fpath saat ini
print -l $fpath

# Tambah direktori di DEPAN (prioritas tertinggi)
fpath=(~/.zsh/functions $fpath)

# Tambah di BELAKANG
fpath+=(~/.zsh/functions)

# Hindari duplikasi
typeset -U fpath
```

**Mengapa `fpath` penting?** Karena Zsh mencari file fungsi di `fpath` dalam urutan yang sama seperti `PATH`. Jika ada fungsi dengan nama yang sama di dua direktori, yang pertama ditemukan yang digunakan.

**File `.zwc` — kompilasi fungsi**:

`zcompile` adalah builtin yang mengompilasi file Zsh menjadi **bytecode** (file `.zwc`). File `.zwc` dimuat lebih cepat daripada file teks asli, karena Zsh tidak perlu mem-parsing ulang.

```bash
# Kompilasi satu file
zcompile ~/.zsh/functions/mkcd

# Ini menghasilkan ~/.zsh/functions/mkcd.zwc

# Kompilasi semua file di direktori
zcompile ~/.zsh/functions/*

# Kompilasi dengan opsi -U (untuk autoload)
zcompile -U ~/.zsh/functions/mkcd

# Hapus file .zwc jika ada masalah
rm ~/.zsh/functions/*.zwc
```

**Catatan penting**: File `.zwc` hanya digunakan jika **lebih baru** dari file asli. Jika Anda mengubah file asli, Anda perlu mengompilasi ulang. Dokumentasi Zsh menyatakan: "If a compiled file exists (named for the original file plus the .zwc extension) and it is newer than the original file, the compiled file will be used instead".

**Apakah `zcompile` benar-benar mempercepat startup?** Ini adalah topik yang diperdebatkan. Beberapa pengembang melaporkan bahwa untuk fungsi autoload, perbedaannya **tidak signifikan** karena fungsi autoload sudah "lazy loaded" — mereka tidak dimuat saat startup. Namun, untuk file yang **selalu dibaca** (seperti `.zshrc` itu sendiri), `zcompile` bisa memberikan percepatan.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`fpath`** | Array direktori tempat Zsh mencari fungsi autoload. |
| **`autoload`** | Builtin untuk menandai fungsi sebagai autoload. |
| **`-U`** | Opsi `autoload` untuk suppress alias expansion. |
| **`-z`** | Opsi `autoload` untuk Zsh-native style. |
| **`zcompile`** | Builtin untuk mengompilasi file Zsh menjadi `.zwc`. |
| **`.zwc`** | File bytecode Zsh. |
| **Lazy Loading** | Memuat fungsi hanya saat dibutuhkan. |

### Diagram Alur: Autoloading

```bash
Anda mengetik: mkcd Documents

Shell mencari perintah "mkcd":
  1. Apakah ada alias? → Tidak
  2. Apakah ada fungsi? → Ya, tetapi autoload (belum dimuat)
  3. Cari file "mkcd" di setiap direktori di $fpath:
       ~/.zsh/functions/mkcd  → DITEMUKAN! ✅
  4. Baca file, definisikan fungsi, jalankan
  5. Fungsi sekarang dimuat di memori (untuk panggilan berikutnya)

Output: direktori Documents dibuat dan Anda masuk ke dalamnya
```

> **Diagram alur [panggilan mkcd → cari di fpath → muat → jalankan] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 3 (Aliases) — fungsi adalah alternatif yang lebih powerful.
- **Prasyarat untuk**: Sub-bagian 6 (Organisasi Modular).
- **Terhubung ke**: Modul 3.2 — completion function juga di-autoload.
- **Terhubung ke**: Sub-bagian 7 (zcompile) — kompilasi fungsi untuk startup lebih cepat.

### Sumber Referensi

- Zsh Manual — Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html 
- Zsh Manual — Autoloading Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions 
- Ubuntu Manpage — zshmisc: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshmisc.1.html 

### Tips dan Praktik Terbaik

1. **Gunakan autoload untuk fungsi yang jarang digunakan**: Fungsi seperti `mkcd` atau `gclone` tidak perlu dimuat saat startup.
2. **Simpan fungsi di `~/.zsh/functions/`**: Ini adalah konvensi yang umum dan mudah diingat.
3. **Gunakan `autoload -Uz`**: Opsi `-U` mencegah alias expansion yang tidak diinginkan.
4. **Kompilasi dengan `zcompile` jika startup terasa lambat**: Test dulu apakah ada perbedaan. Jangan kompilasi secara membabi buta.
5. **Dokumentasikan fungsi Anda**: Tambahkan komentar di file fungsi atau di `.zshrc`.
6. **Gunakan `#compdef` untuk completion**: Jika fungsi Anda memiliki completion, tambahkan `#compdef namafungsi` di baris pertama file fungsi.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Fungsi autoload tidak ditemukan | `fpath` tidak mencakup direktori fungsi | `print -l $fpath` untuk verifikasi |
| File fungsi berisi definisi lengkap | Autoload mengharapkan hanya tubuh fungsi | Hapus `namafungsi() {` dan `}` dari file |
| `zcompile` tidak mempercepat | Fungsi autoload sudah lazy-loaded | Tidak perlu dikompilasi; fokus pada file yang selalu dibaca |
| File `.zwc` usang | File asli diubah setelah kompilasi | `zcompile` ulang atau hapus `.zwc` |
| Alias expansion di file autoload | Tidak menggunakan `-U` | Gunakan `autoload -Uz` |


## 6. Organisasi `.zshrc` yang Modular

### Deskripsi Konkret & Peran dalam Kurikulum

Saat konfigurasi Zsh Anda tumbuh, `.zshrc` tunggal bisa menjadi **ratusan baris** yang sulit dipelihara. Organisasi modular memecah `.zshrc` menjadi **file-file kecil** yang masing-masing menangani satu aspek konfigurasi.

Dalam kurikulum, sub-bagian ini adalah **puncak dari Modul 3.3**. Ini adalah cara Anda mengelola kompleksitas dan membuat konfigurasi yang **dapat dipelihara jangka panjang**.

### Konsep Kunci & Filosofi Mendalam

Filosofi modularitas adalah **"pemisahan tanggung jawab"**. Setiap file memiliki satu pekerjaan:
- `01-options.zsh` — opsi shell
- `02-aliases.zsh` — alias
- `03-functions.zsh` — fungsi
- `04-completion.zsh` — konfigurasi completion
- `05-prompt.zsh` — prompt
- `06-plugins.zsh` — plugin manager

**Mengapa numbered prefix?** Karena urutan pemuatan penting. `01-options.zsh` harus dimuat sebelum `04-completion.zsh` karena completion menggunakan opsi yang di-set di file pertama. Prefix angka memastikan urutan yang deterministik.

**Struktur direktori yang direkomendasikan**:

```bash
~/.config/zsh/
├── .zshenv              → environment variables minimal
├── .zprofile            → PATH, SSH agent
├── .zshrc               → entry point: source semua modul
├── .zlogin              → pesan selamat datang
├── .zlogout             → cleanup
└── zsh.d/               → direktori modul
    ├── 00-init.zsh      → inisialisasi awal
    ├── 01-options.zsh   → setopt
    ├── 02-aliases.zsh   → alias
    ├── 03-functions.zsh → fungsi
    ├── 04-completion.zsh→ compinit dan zstyle
    ├── 05-prompt.zsh    → prompt
    ├── 06-plugins.zsh   → plugin manager (jika ada)
    └── 99-local.zsh     → override lokal (tidak di-commit)
```

**`.zshrc` sebagai entry point**:

`.zshrc` utama hanya berisi loop yang memuat semua file di `zsh.d/` secara berurutan. Ini adalah pola yang digunakan oleh banyak pengguna Zsh expert.

### Sintaks Dasar dan Contoh

```bash
# === ~/.zshrc — ENTRY POINT ===
# File ini hanya memuat modul dari zsh.d/

# Tentukan direktori modul
ZSH_MODULES="${ZDOTDIR:-$HOME}/zsh.d"

# Muat semua file .zsh di zsh.d/ secara berurutan
if [[ -d "$ZSH_MODULES" ]]; then
    for config in "$ZSH_MODULES"/*.zsh(N); do
        source "$config"
    done
fi

# === ~/.config/zsh/zsh.d/01-options.zsh ===
# Opsi shell
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB NULL_GLOB
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY
setopt NO_CLOBBER CORRECT

# === ~/.config/zsh/zsh.d/02-aliases.zsh ===
# Aliases
alias ll='ls -la'
alias gs='git status'
alias reload='exec zsh'
alias ..='cd ..'

# === ~/.config/zsh/zsh.d/03-functions.zsh ===
# Fungsi
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# === ~/.config/zsh/zsh.d/04-completion.zsh ===
# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# === ~/.config/zsh/zsh.d/05-prompt.zsh ===
# Prompt
autoload -Uz promptinit && promptinit
PS1='%F{green}%n@%m%f:%F{blue}%~%f%# '

# === ~/.config/zsh/zsh.d/99-local.zsh ===
# Override lokal — JANGAN di-commit ke Git
# File ini untuk konfigurasi yang spesifik mesin
export WORK_VPN="vpn.company.com"
alias work-ssh='ssh user@$WORK_VPN'
```

**Penjelasan loop pemuatan:**

```bash
for config in "$ZSH_MODULES"/*.zsh(N); do
    source "$config"
done
```

- `"$ZSH_MODULES"/*.zsh` — Glob semua file `.zsh` di direktori.
- `(N)` — Qualifier `NULL_GLOB`: jika tidak ada file `.zsh`, jangan error.
- `source "$config"` — Baca dan eksekusi file dalam konteks shell saat ini.

**Keuntungan loop ini**: Anda tidak perlu memperbarui `.zshrc` setiap kali menambah modul baru. Cukup letakkan file baru di `zsh.d/` dengan prefix angka yang sesuai.

**Alternatif: Pemuatan dengan fungsi**:

```bash
# Fungsi untuk memuat modul dengan aman
load_module() {
    local module="$1"
    if [[ -f "$ZSH_MODULES/$module" ]]; then
        source "$ZSH_MODULES/$module"
    else
        print "Warning: module $module not found" >&2
    fi
}

# Muat modul satu per satu (lebih eksplisit)
load_module 01-options.zsh
load_module 02-aliases.zsh
load_module 03-functions.zsh
load_module 04-completion.zsh
load_module 05-prompt.zsh
```

**Keuntungan pendekatan eksplisit**: Anda memiliki kontrol penuh atas urutan dan dapat menangani error dengan lebih baik. Kekurangannya: Anda perlu memperbarui `.zshrc` setiap kali menambah modul.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **Modular** | Dipecah menjadi komponen-komponen kecil yang independen. |
| **Numbered Prefix** | Prefix angka untuk menentukan urutan pemuatan. |
| **Entry Point** | File utama yang memuat semua modul. |
| **`source`** | Builtin untuk membaca dan mengeksekusi file dalam konteks shell saat ini. |
| **`zsh.d/`** | Konvensi direktori untuk modul konfigurasi Zsh. |

### Diagram Pohon: Struktur Konfigurasi Modular

```bash
~/.config/zsh/
│
├── .zshenv ──────────────→ Environment variables (SEMUA shell)
│
├── .zprofile ────────────→ PATH, SSH agent (LOGIN shell)
│
├── .zshrc ───────────────→ Entry point (INTERACTIVE shell)
│   │
│   └── sources ↓
│
└── zsh.d/
    ├── 00-init.zsh ──────→ Inisialisasi awal (ZDOTDIR, dll.)
    ├── 01-options.zsh ───→ setopt: AUTO_CD, EXTENDED_GLOB, dll.
    ├── 02-aliases.zsh ───→ alias: ll, gs, reload, dll.
    ├── 03-functions.zsh ─→ mkcd, gclone, dll.
    ├── 04-completion.zsh → compinit, zstyle
    ├── 05-prompt.zsh ────→ PS1, promptinit
    ├── 06-plugins.zsh ───→ Plugin manager
    └── 99-local.zsh ─────→ Override lokal (tidak di-commit)
```

> **Diagram pohon [struktur direktori .config/zsh/ dengan alur pemuatan] akan sangat membantu di sini.**

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Semua sub-bagian Modul 3.3.
- **Terhubung ke**: Modul 3.1 — opsi globbing di `01-options.zsh`.
- **Terhubung ke**: Modul 3.2 — konfigurasi completion di `04-completion.zsh`.
- **Terhubung ke**: Sub-bagian 5 (Fungsi) — fungsi di `03-functions.zsh`.

### Sumber Referensi

- GitHub — zdot: Modular zsh rc files: https://github.com/georgeharker/zdot 
- GitHub — dotfiles-best-practices: https://tomevault.io 
- Shellforge — Modular shell configurations: https://pkg.go.dev 

### Tips dan Praktik Terbaik

1. **Gunakan numbered prefix**: `01-`, `02-`, dst. untuk urutan yang deterministik.
2. **Pisahkan `99-local.zsh`**: Untuk konfigurasi spesifik mesin yang tidak boleh di-commit ke Git.
3. **Jangan terlalu banyak modul**: 5–10 modul adalah jumlah yang wajar. Terlalu banyak modul justru membingungkan.
4. **Gunakan `(N)` pada glob pemuatan**: Untuk menghindari error jika direktori kosong.
5. **Test setelah setiap perubahan**: Setelah menambah modul, jalankan `exec zsh` dan pastikan tidak ada error.
6. **Gunakan `zcompile` untuk modul**: Jika startup terasa lambat, kompilasi modul-modul.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Modul tidak dimuat | Prefix angka salah atau file tidak ada | `ls zsh.d/` untuk verifikasi |
| Urutan pemuatan salah | Tidak menggunakan prefix angka | Gunakan `01-`, `02-`, dst. |
| Konfigurasi di `99-local.zsh` hilang | Di-commit dan ditimpa | Pastikan `99-local.zsh` ada di `.gitignore` |
| Error "no matches found" | Glob `*.zsh` tidak menemukan file | Gunakan `(N)` qualifier |
| Konfigurasi lambat | Terlalu banyak modul atau perintah berat | Profil dengan `zsh -x` atau `zprof` |


## 7. Optimasi Startup: `zcompile`

*(Sub-bagian tambahan dari audit — tidak ada di daftar isi asli, tetapi penting untuk performa)*

### Deskripsi Konkret & Peran dalam Kurikulum

`zcompile` adalah builtin Zsh yang mengompilasi file konfigurasi menjadi **bytecode** (file `.zwc`). File `.zwc` dimuat lebih cepat karena Zsh tidak perlu mem-parsing teks asli setiap kali.

Dalam kurikulum, sub-bagian ini adalah **optimasi tingkat lanjut**. Ini adalah topik yang jarang dibahas tetapi sangat berguna bagi pengguna yang menginginkan startup shell di bawah 100ms.

### Konsep Kunci & Filosofi Mendalam

Filosofi `zcompile` adalah **"parse sekali, jalankan berkali-kali"**. Setiap kali Zsh startup, ia harus mem-parsing file `.zshrc` dan file modul. Parsing ini memakan waktu. Dengan `zcompile`, Anda "membekukan" hasil parsing ke dalam bytecode, sehingga startup hanya perlu membaca bytecode.

**Kapan `zcompile` berguna?**
- **Untuk file yang selalu dibaca**: `.zshrc`, `01-options.zsh`, `02-aliases.zsh`. Ini memberikan percepatan yang signifikan.
- **Untuk file completion**: `compinit` membaca banyak file. Kompilasi bisa mempercepat.
- **Untuk fungsi autoload**: **Tidak signifikan** karena fungsi autoload sudah "lazy loaded" — mereka tidak dibaca saat startup.

**Trade-off**: File `.zwc` harus dikompilasi ulang setiap kali file asli berubah. Jika Anda lupa mengompilasi ulang, Zsh akan menggunakan file `.zwc` yang usang (karena Zsh memilih file yang lebih baru, tetapi jika `.zwc` lebih baru dari asli, ia menggunakan `.zwc`).

### Sintaks Dasar dan Contoh

```bash
# === KOMPILASI SATU FILE ===
zcompile ~/.zshrc
# Menghasilkan ~/.zshrc.zwc

# === KOMPILASI DENGAN OPSI -U ===
# -U: suppress alias expansion (direkomendasikan untuk autoload)
zcompile -U ~/.zsh/functions/mkcd

# === KOMPILASI SEMUA FILE DI DIREKTORI ===
zcompile ~/.config/zsh/zsh.d/*.zsh

# === CEK FILE .zwc ===
ls -la ~/.config/zsh/zsh.d/*.zwc

# === HAPUS FILE .zwc ===
rm ~/.config/zsh/zsh.d/*.zwc

# === AUTO-KOMPILASI DI .zshrc ===
# Fungsi untuk mengompilasi jika file asli lebih baru
autoload -Uz zrecompile

# zrecompile adalah fungsi Zsh yang menangani kompilasi otomatis
zrecompile -p ~/.zshrc
zrecompile -p ~/.config/zsh/zsh.d/*.zsh

# Opsi:
#   -p  → hanya kompilasi jika file asli lebih baru dari .zwc
#   -q  → quiet
#   -R  → rekursif

# === KOMPILASI COMPLETION ===
# Ini bisa mempercepat startup compinit
zcompile ~/.zcompdump
```

**Penjelasan mendalam tentang `zrecompile`:**

`zrecompile` adalah fungsi yang disediakan Zsh (di `$fpath`) yang menangani kompilasi otomatis. Ini adalah cara yang lebih baik daripada memanggil `zcompile` secara manual, karena:

1. **Deteksi otomatis**: `zrecompile -p` hanya mengompilasi jika file asli lebih baru dari `.zwc`.
2. **Manajemen dump file**: `zrecompile` juga menangani file `.zwc` untuk `compinit`.
3. **Aman**: Tidak akan mengompilasi ulang jika tidak perlu.

**Mengapa `zrecompile` lebih baik?** Karena Anda bisa menambahkannya ke `.zshrc` dan membiarkannya menangani kompilasi secara otomatis. Tidak perlu mengingat untuk mengompilasi ulang setelah mengubah konfigurasi.

**Apakah `zcompile` benar-benar mempercepat?** Ini tergantung. Beberapa pengembang melaporkan bahwa untuk `.zshrc` yang kompleks, `zcompile` bisa mengurangi startup time **10–20ms**. Untuk konfigurasi sederhana, perbedaannya tidak terasa. Yang terbaik adalah **mengukur sendiri**:

```bash
# Ukur startup time
time zsh -i -c exit

# Setelah zcompile
time zsh -i -c exit
```

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`zcompile`** | Builtin untuk mengompilasi file Zsh menjadi bytecode. |
| **`.zwc`** | File bytecode Zsh. |
| **`zrecompile`** | Fungsi untuk kompilasi otomatis. |
| **`-p`** | Opsi `zrecompile`: kompilasi hanya jika perlu. |
| **`-U`** | Opsi `zcompile`: suppress alias expansion. |

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 5 (Fungsi) dan 6 (Modular).
- **Terhubung ke**: Sub-bagian 8 (Keamanan) — file `.zwc` juga perlu diperhatikan permission-nya.

### Sumber Referensi

- Zsh Manual — `zcompile`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zrecompile 
- GitHub — zush (auto-compilation): https://github.com/shyndman/zush 
- Zsh Mailing List — Speeding up ZSH startup: https://zsh.org/mla/users/2005/msg00423.html 

### Tips dan Praktik Terbaik

1. **Mulai dengan `zrecompile -p` di `.zshrc`**: Ini adalah cara termudah untuk mendapatkan manfaat `zcompile` tanpa kerumitan.
2. **Jangan kompilasi fungsi autoload**: Tidak ada manfaat signifikan karena fungsi autoload sudah lazy-loaded.
3. **Ukur sebelum dan sesudah**: Jangan berasumsi; gunakan `time zsh -i -c exit` untuk mengukur.
4. **Hati-hati dengan file `.zwc` usang**: Jika Anda mengubah `.zshrc`, pastikan `.zwc` dikompilasi ulang. `zrecompile -p` menangani ini.
5. **Hapus `.zwc` jika ada masalah aneh**: Terkadang file `.zwc` yang korup menyebabkan masalah. Hapus dan biarkan Zsh membaca file asli.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Perubahan `.zshrc` tidak berpengaruh | File `.zwc` usang | `rm ~/.zshrc.zwc` atau `zrecompile -p ~/.zshrc` |
| Startup tidak lebih cepat | Tidak ada perbedaan signifikan | Tidak perlu `zcompile`; fokus pada hal lain |
| Error "permission denied" saat kompilasi | File `.zwc` tidak bisa ditulis | Periksa permission direktori |
| `zcompile` gagal | Syntax error di file | Perbaiki syntax terlebih dahulu |


## 8. Keamanan Konfigurasi Zsh

*(Sub-bagian tambahan dari audit)*

### Deskripsi Konkret & Peran dalam Kurikulum

Konfigurasi Zsh Anda adalah **kunci kerajaan** Anda. Jika seseorang bisa memodifikasi `.zshrc` Anda, mereka bisa menjalankan perintah apa pun atas nama Anda. Sub-bagian ini membahas **praktik keamanan** dalam mengelola konfigurasi Zsh.

Dalam kurikulum, ini adalah **lapisan kesadaran** yang harus dimiliki setiap pengguna Zsh. Ini melengkapi semua sub-bagian sebelumnya dengan memastikan bahwa konfigurasi Anda **aman** dan **tidak rentan** terhadap serangan.

### Konsep Kunci & Filosofi Mendalam

Filosofi keamanan Zsh adalah **"percaya tetapi verifikasi"**. Zsh memiliki mekanisme keamanan internal (`compaudit`) yang memeriksa apakah file completion dimiliki oleh user yang tepat dan tidak world-writable. Namun, keamanan juga bergantung pada praktik Anda:

1. **Permission file**: File konfigurasi harus dimiliki oleh Anda dan tidak writable oleh orang lain.
2. **Sumber alias**: Jangan pernah mengambil alias dari sumber yang tidak terpercaya. Alias bisa mengandung perintah berbahaya.
3. **`compaudit`**: Gunakan untuk memverifikasi keamanan direktori completion.
4. **Git dan dotfiles**: Jika Anda menyimpan dotfiles di Git, pastikan tidak ada informasi sensitif (API keys, password) yang ter-commit.

**Mengapa `compaudit` penting?** Karena Zsh secara default **menolak** memuat file completion yang tidak aman. Jika direktori completion dimiliki oleh user lain atau world-writable, Zsh akan menampilkan error saat startup. `compaudit` membantu Anda mengidentifikasi dan memperbaiki masalah ini .

### Sintaks Dasar dan Contoh

```bash
# === CEK KEAMANAN FILE KONFIGURASI ===
ls -la ~/.zshrc ~/.zshenv ~/.zprofile
# Pastikan permission adalah 644 atau 600
# -rw-r--r-- 1 user user  ... .zshrc   ← AMAN
# -rw-rw-rw- 1 user user  ... .zshrc   ← TIDAK AMAN

# Perbaiki permission
chmod 644 ~/.zshrc
chmod 600 ~/.zshenv

# === COMPAUDIT ===
compaudit
# Jika ada output, itu adalah direktori yang tidak aman
# Contoh output:
# /usr/local/share/zsh/site-functions
# /usr/local/share/zsh/site-functions/_docker

# Perbaiki permission
chmod 755 /usr/local/share/zsh/site-functions
chmod 644 /usr/local/share/zsh/site-functions/_docker

# === MELEWATI SECURITY CHECK (TIDAK DIREKOMENDASIKAN) ===
# Hanya jika Anda yakin sistem aman
compinit -u

# === CEK APAKAH FILE DOTFILES DI-COMMIT ===
# Di direktori dotfiles Anda
git status
# Pastikan tidak ada file sensitif
# Tambahkan ke .gitignore:
echo '99-local.zsh' >> .gitignore
echo '.zshenv.local' >> .gitignore

# === PRAKTIK AMAN UNTUK ALIAS ===
# ❌ JANGAN:
# alias curl='curl --insecure'     # Menonaktifkan verifikasi SSL
# alias wget='wget --no-check-certificate'
# alias sudo='sudo '               # Bisa menyebabkan masalah keamanan

# ✅ LAKUKAN:
alias ll='ls -la'
alias gs='git status'
alias reload='exec zsh'

# === CEK ALIAS YANG MUNGKIN BERBAHAYA ===
alias | grep -E '(rm|sudo|curl|wget|ssh)'
# Periksa apakah ada yang mencurigakan
```

**Penjelasan mendalam tentang `compaudit`:**

`compaudit` menjalankan security check yang sama dengan `compinit`. Ini memeriksa:
1. Apakah direktori di `fpath` dimiliki oleh user saat ini atau root.
2. Apakah direktori tidak world-writable.
3. Apakah file completion tidak world-writable.

Jika ada masalah, `compaudit` akan menampilkan daftar direktori/file yang tidak aman. Anda kemudian bisa memperbaiki permission dengan `chmod`.

**Mengapa Zsh peduli?** Karena file completion dieksekusi sebagai shell code. Jika file completion bisa dimodifikasi oleh user lain, mereka bisa menyisipkan kode berbahaya yang akan dijalankan saat Anda menekan TAB.

### Terminologi Esensial

| Istilah | Penjelasan |
|---------|-----------|
| **`compaudit`** | Fungsi untuk menjalankan security check. |
| **`compinit -u`** | Opsi untuk melewati security check (tidak direkomendasikan). |
| **World-writable** | File/direktori yang bisa ditulis oleh semua user. |
| **Permission 644** | `rw-r--r--` — owner bisa baca/tulis, others hanya baca. |
| **Permission 600** | `rw-------` — hanya owner yang bisa baca/tulis. |

### Hubungan dengan Modul Lain

- **Prasyarat dari**: Sub-bagian 1 (Startup Files).
- **Terhubung ke**: Modul 3.2 — `compinit` dan `compaudit`.
- **Terhubung ke**: Sub-bagian 7 (zcompile) — file `.zwc` juga perlu permission yang aman.

### Sumber Referensi

- Ubuntu Manpage — zshcompsys (compaudit): https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 
- Zsh Manual — `compaudit`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html 
- Yisu — Linux Aliases安全使用指南: https://m.yisu.com 

### Tips dan Praktik Terbaik

1. **Jalankan `compaudit` secara rutin**: Setelah menginstal plugin atau menambah `fpath`, jalankan `compaudit` untuk memastikan tidak ada masalah.
2. **Gunakan permission 644 untuk file konfigurasi**: Cukup untuk dibaca, tetapi tidak bisa diubah oleh orang lain.
3. **Jangan gunakan `compinit -u` kecuali terpaksa**: Ini melewati security check. Jika Anda melakukannya, pastikan Anda tahu risikonya.
4. **Gunakan `.gitignore` untuk file lokal**: Jangan pernah commit `99-local.zsh` atau file yang berisi API keys.
5. **Audit alias secara berkala**: `alias | grep -E '(rm|sudo|curl|wget|ssh)'` untuk memeriksa apakah ada alias yang mencurigakan.
6. **Jangan pernah mengambil `.zshrc` dari internet tanpa memeriksa**: Ini adalah vektor serangan yang umum.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| "insecure directories" saat startup | Direktori completion world-writable | `compaudit` dan perbaiki permission |
| `compinit` menolak memuat | File completion tidak aman | `chmod 644` pada file, `chmod 755` pada direktori |
| API key ter-commit ke Git | Tidak ada `.gitignore` | Tambahkan file sensitif ke `.gitignore` |
| Alias berbahaya dari sumber tidak terpercaya | Mengambil `.zshrc` dari internet | Selalu periksa sebelum menggunakan |


## Ringkasan Modul 3.3

| Sub-bagian | Fokus | File Utama |
|------------|-------|-----------|
| 1 | Arsitektur Startup | `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin` |
| 2 | Opsi Shell | `setopt`, `unsetopt` |
| 3 | Aliases | `alias`, `unalias` |
| 4 | PATH & Environment Variables | `export`, `path`, `typeset -U` |
| 5 | Fungsi & Autoloading | `fpath`, `autoload`, `zcompile` |
| 6 | Organisasi Modular | `zsh.d/`, numbered prefix |
| 7 | Optimasi Startup *(tambahan)* | `zcompile`, `zrecompile` |
| 8 | Keamanan Konfigurasi *(tambahan)* | `compaudit`, permission |


## Hubungan Modul 3.3 dengan Fase Berikutnya

Modul 3.3 adalah **penutup Fase 3**. Setelah menyelesaikan modul ini, Anda memiliki:

1. **Fondasi globbing** (Modul 3.1) — kemampuan memilih file dengan presisi.
2. **Completion system** (Modul 3.2) — pengalaman interaktif yang cerdas.
3. **Konfigurasi persisten** (Modul 3.3) — semua pengetahuan di atas menjadi bagian dari lingkungan sehari-hari.

Fase berikutnya (Fase 4, jika ada) biasanya akan membahas **topik lanjutan** seperti:
- **Zsh Line Editor (ZLE)** — kustomisasi keybindings, widget, dan editor.
- **Prompt lanjutan** — Powerlevel10k, Starship, dan prompt kustom.
- **Plugin manager** — Zinit, Antigen, Oh-My-Zsh.
- **Scripting lanjutan** — array, associative array, dan pemrograman shell.
- **Integrasi dengan tools modern** — fzf, ripgrep, fd, bat.

Semua topik ini **membangun di atas fondasi** yang telah Anda kuasai di Fase 3.


## Referensi Lengkap Modul 3.3

1. **Zsh Manual — Files (Startup/Shutdown)**: https://zsh.sourceforge.io/Doc/Release/Files.html 
2. **Zsh Manual — Options**: https://zsh.sourceforge.io/Doc/Release/Options.html 
3. **Zsh Manual — Functions**: https://zsh.sourceforge.io/Doc/Release/Functions.html 
4. **Zsh Manual — Parameters**: https://zsh.sourceforge.io/Doc/Release/Parameters.html 
5. **FreeBSD Manpage — zshall**: https://man.freebsd.org/cgi/man.cgi?query=zshall 
6. **Linux Command Library — setopt**: https://linuxcommandlibrary.com/man/setopt 
7. **PhoenixNAP — How to Set Environment Variables in Zsh**: https://phoenixnap.com/kb/zsh-environment-variables 
8. **GitHub — durant/environment**: https://github.com/durant/environment 
9. **GitHub — zdot (Modular zsh)**: https://github.com/georgeharker/zdot 
10. **Zsh Mailing List — Speeding up ZSH startup**: https://zsh.org/mla/users/2005/msg00423.html 
11. **Ubuntu Manpage — zshcompsys**: https://manpages.ubuntu.com/manpages/mantic/en/man1/zshcompsys.1.html 
12. **Yisu — Linux Aliases安全使用指南**: https://m.yisu.com 


## Konfirmasi Penyelesaian Fase 3

Dengan selesainya Modul 3.3, **Fase 3: Globbing, Completion, dan Konfigurasi** telah selesai sepenuhnya. Anda sekarang memiliki pemahaman yang komprehensif tentang:

- ✅ **Globbing lanjutan** — wildcard, recursive globbing, glob qualifiers, sorting, negasi, dan opsi globbing.
- ✅ **Sistem completion** — `compinit`, `zstyle`, context dan tag, `compdef`, `_arguments`, menulis completion function, menu selection, dan debugging.
- ✅ **Konfigurasi Zsh** — startup files, opsi shell, aliases, PATH, environment variables, fungsi, autoloading, organisasi modular, optimasi startup, dan keamanan.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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

