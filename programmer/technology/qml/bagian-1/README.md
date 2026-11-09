# Materi Mendalam Mastery Qt 6 — Fase 0: Fondasi Lingkungan

*Dokumentasi belajar mandiri, disusun bertahap · 5 November 2026 · Acuan: Kurikulum Mastery Qt 6 — QML & Qt Quick (Edisi Revisi 4 November 2026) · Target Qt 6.12 LTS (minimal 6.8) · Arch Linux, terminal-centric*

## Cara membaca dokumen ini

Dokumen ini tumbuh bertahap: setiap giliran menambah satu bagian, dan bagian lama hanya diubah bila audit menemukan kesalahan.

| Bagian | Isi | Status |
| --- | --- | --- |
| 1. Audit Fase 0 | Pemeriksaan teknis sebelum materi dimulai | Selesai |
| 2. Fase 0 (tingkat fase) | Peran, filosofi, peta, hubungan antarfase | Selesai |
| 3. Modul 0.0 — Orientasi untuk Pemula | Sub-bagian 0.0.1 sampai 0.0.9 | Ditulis di dokumen ini |
| Modul 0.1 (bagian 5), 0.2 (bagian 6), 0.3 (bagian 7), dan penutup Fase 0 (bagian 8) | Ekosistem, build, runtime | Selesai. Berikutnya: Fase 1, menunggu konfirmasi Anda |

**Konvensi.**

- Baris berawalan `$` adalah perintah yang Anda ketik (tanpa tanda `$`). Baris tanpa `$` di bawahnya adalah keluaran.
- Setiap kode diikuti tabel **Kata demi kata** yang menerangkan tiap bagiannya.
- **\[TAMBAHAN\]** menandai materi yang tidak ada di kurikulum asli; alasan logisnya selalu dituliskan.
- ⚠ menandai perintah yang mengubah sistem atau memerlukan hak istimewa.
- Tautan berasal dari dokumentasi resmi atau sumber mapan, tetapi belum diuji otomatis (lihat batas verifikasi di Bagian E kurikulum). Bila ada yang mati, cari judulnya di situs yang sama.

## 1. Audit Fase 0

Sebelum materi dimulai, Fase 0 diperiksa terhadap urutan prasyarat dan akurasi. Yang penting adalah temuan dan tindakannya.

1. **Loncatan ke Modul 0.3.** Modul 0.3 memakai `2>&1 | head -50` dan bentuk `VARIABEL=nilai perintah`, tetapi Modul 0.0 tidak mengajarkan redirect, pipe, maupun prefiks variabel. Pembelajar Jalur A akan membaca perintah yang belum ia pahami. *Tindakan:* tambah sub-bagian pipe/redirect dan perluas bagian environment.
2. **Latihan commit akan gagal.** Latihan Modul 0.0 (init, commit) gagal di instalasi baru bila `user.name` dan `user.email` git belum diatur. *Tindakan:* ajarkan `git config` lebih dulu.
3. **Hitungan tidak sinkron.** Deskripsi menyebut empat konsep, sedangkan daftar isi memuat lima butir. *Tindakan:* ditetapkan lima butir inti ditambah empat tambahan; Deskripsi di kurikulum sebaiknya diubah menjadi lima konsep inti.
4. **sudo disebut, tetapi tidak diajarkan.** Bagian Kesalahan umum memperingatkan `sudo`, padahal izin file dan pengguna belum dibahas. *Tindakan:* sub-bagian izin dan sudo.
5. **Tidak ada cara mandiri mencari bantuan.** Belum ada `man`, `--help`, maupun editor. Untuk jalur terminal-centric, editor modal adalah kebutuhan dasar. *Tindakan:* sub-bagian bantuan dan editor.
6. **Keamanan rantai pasok.** Bagian 4 memasang paket dengan pacman, tetapi kehati-hatian terhadap sumber (AUR, skrip unduhan) belum diajarkan. Sesuai prinsip keamanan dan isolasi, ini perlu ada sejak hari pertama. *Tindakan:* sub-bagian kebiasaan aman.
7. **Catatan untuk Modul 0.2 (belum diubah).** Membangun di folder `build/` di dalam repositori git berarti `build/` harus masuk `.gitignore`. Konsepnya diajarkan di sini; penerapannya di 0.2.
8. **Estimasi.** Fase 0 selama 1–2 minggu realistis untuk Jalur B. Untuk Jalur A dengan tambahan di atas, usulan: 2–3 minggu. Bagian 2 kurikulum sebaiknya diperbarui.
9. **Klaim yang belum saya verifikasi.** Tabel Bagian 4 menyebut bahwa Qt 6.12 menjadikan hot reload fitur bawaan engine untuk `qmlpreview`. Ini di luar Fase 0, tetapi perlu dicocokkan dengan dokumentasi resmi sebelum dipakai di modul berikutnya; tandai **\[uji dulu\]**.

**Daftar isi Modul 0.0 yang diperbarui.** Urutannya diubah mengikuti urutan belajar (pipe dan izin harus dipahami sebelum git dan pesan error):

| No. baru | Judul | Asal |
| --- | --- | --- |
| 0.0.1 | Program, compiler, interpreter | Asli 0.0.1 |
| 0.0.2 | Event loop dan mengapa UI bisa macet | Asli 0.0.2 |
| 0.0.3 | Terminal: path, proses, environment | Asli 0.0.3, diperluas |
| 0.0.4 | Pipe, redirect, dan penyaring teks | **\[TAMBAHAN\]** |
| 0.0.5 | Izin file, pengguna, dan sudo | **\[TAMBAHAN\]** |
| 0.0.6 | Git minimum: config, init, add, commit, diff, log, restore | Asli 0.0.4, diperluas |
| 0.0.7 | Membaca pesan error | Asli 0.0.5 |
| 0.0.8 | Mencari bantuan sendiri dan editor modal | **\[TAMBAHAN\]** |
| 0.0.9 | Kebiasaan aman: sumber paket dan skrip | **\[TAMBAHAN\]** |

## 2. Fase 0 — Fondasi Lingkungan (tingkat fase)

**Daftar isi bagian ini:** 2.1 Deskripsi dan peran · 2.2 Konsep kunci dan filosofi · 2.3 Peta Fase 0 · 2.4 Hubungan dengan fase lain · 2.5 Kriteria lulus · 2.6 Kesalahan umum tingkat fase · 2.7 Referensi

### 2.1 Deskripsi dan peran dalam kurikulum

Fase 0 mengajarkan **cara bekerja**, bukan cara memprogram. Isinya enam kemampuan: (1) memahami apa itu program, compiler, dan event loop; (2) bekerja di terminal dengan sadar, bukan menyalin buta; (3) mencatat setiap perubahan dengan git; (4) memetakan Qt, QML, dan Qt Quick; (5) membangun dan menjalankan aplikasi pertama dengan CMake; (6) mendiagnosa lingkungan saat sesuatu tidak berjalan.

Peran dalam kurikulum: Fase 1–14 mengandaikan Anda tidak lagi berhenti pada pesan *command not found* atau jendela yang tidak muncul. Kebuntuan awal pembelajar Qt sering bukan soal QML, melainkan soal lingkungan: modul tidak ditemukan, platform plugin salah, driver grafis bermasalah. Fase 0 mengubah kebuntuan itu dari misteri menjadi langkah diagnosa yang berurutan.

### 2.2 Konsep kunci dan filosofi

Empat gagasan yang mendasari seluruh fase:

1. **Filosofi Unix.** Program kecil yang melakukan satu hal dengan baik, disambungkan lewat teks. `qml`, `qmllint`, `qmlformat`, `cmake`, `git` semuanya mengikuti pola ini. Anda tidak mencari satu aplikasi serba bisa; Anda merangkai alat kecil.
2. **Observabilitas.** Yang tidak bisa dilihat tidak bisa diperbaiki. Karena itu kita belajar membaca keluaran, kode keluar (exit code), log, dan variabel diagnostik.
3. **Reproduksibilitas dan isolasi.** Build di folder terpisah, riwayat di git, lingkungan dicatat sebagai teks. Orang lain (atau Anda enam bulan lagi) bisa mengulang hasilnya. Ini juga dasar keamanan: Anda tahu persis apa yang dijalankan, dengan hak apa, dari sumber mana.
4. **Kontrol lewat teks dan keyboard.** Klik tidak bisa direkam, ditinjau, atau diulang; perintah bisa. Seluruh kurikulum dirancang agar setiap langkah dapat ditulis sebagai baris teks.

**Analogi untuk non-IT:** sebelum membangun rumah, seorang tukang mengenali alatnya, merapikan meja kerja, dan menyiapkan buku catatan. Fase 0 adalah meja kerja dan buku catatan itu.

### 2.3 Peta Fase 0

```
 FASE 0 — FONDASI LINGKUNGAN

 +------------------------------------------------------------+
 | 0.0 ORIENTASI                      "cara bekerja"          |
 |   program | event loop | terminal | pipe | izin | git      |
 |   baca error | bantuan & editor | kebiasaan aman           |
 +----------------------------+-------------------------------+
                              v
 +------------------------------------------------------------+
 | 0.1 EKOSISTEM                      "apa yang saya pelajari"|
 |   Qt vs QML vs Qt Quick | modul | lisensi | rilis          |
 +----------------------------+-------------------------------+
                              v
 +------------------------------------------------------------+
 | 0.2 BUILD PERTAMA                  "membuat sesuatu jalan" |
 |   satu file -> CMake -> executable -> modul QML (URI)      |
 +----------------------------+-------------------------------+
                              v
 +------------------------------------------------------------+
 | 0.3 RUNTIME & DIAGNOSA          "bila tidak jalan, mengapa"|
 |  startup | platform plugin | RHI | variabel diagnostik     |
 +------------------------------------------------------------+
```

### 2.4 Hubungan dengan fase lain

| Konsep dari Fase 0 | Dipakai kembali di |
| --- | --- |
| Terminal, PATH, environment | Modul 0.3, alur kerja Bagian 4, Modul 13.3 (packaging) |
| Git | Semua proyek (Bagian C), Modul 8.4, 13.4, 14.6 |
| Event loop | Fase 3 (binding, signal), Modul 7.4, 10.7, 11.1 |
| Compiler vs interpreter | Fase 2 (JavaScript), Fase 10 (C++), Modul 11.5 (kompilasi QML) |
| Membaca pesan error | Modul 12.1, 14.6 |
| Izin, sudo, sumber paket | Modul 13.1 (keamanan), 13.3 (deployment) |

### 2.5 Kriteria lulus Fase 0

Anda lulus bila dapat melakukan semuanya **tanpa melihat catatan**:

- Menjelaskan perbedaan compiler dan interpreter, serta di mana C++, JavaScript, dan QML berada di antaranya.
- Menjelaskan event loop dan memprediksi kapan sebuah UI akan tampak macet.
- Bernavigasi di terminal, menyambung perintah dengan pipe, dan membaca exit code.
- Membuat repositori git, membuat commit yang bermakna, melihat diff, dan membatalkan perubahan.
- Membaca pesan error dari atas ke bawah dan menemukan file serta baris penyebabnya.
- Membangun proyek CMake Qt, menjalankannya, dan mendiagnosanya dengan variabel lingkungan (Modul 0.2–0.3).

### 2.6 Kesalahan umum tingkat fase

- **Melompat langsung ke QML.** Gejala: terhenti pada hal sepele (`qml: command not found`). Solusi: selesaikan Fase 0 dulu; ia hanya 2–3 minggu.
- **Menyalin perintah tanpa memahami.** Gejala: sistem berubah dan Anda tidak tahu mengapa. Solusi: untuk tiap perintah baru, jalankan `man` atau `--help` dan baca satu kalimat deskripsinya.
- **Menunda git.** Gejala: perubahan yang rusak tidak bisa dikembalikan. Solusi: `git init` di folder belajar pada hari pertama.
- **Bekerja sebagai root.** Gejala: file milik root di folder rumah, izin berantakan. Solusi: bekerja sebagai pengguna biasa; pakai `sudo` hanya untuk satu perintah yang memang butuh.
- **Mencampur sumber Qt.** Gejala: versi Qt bentrok (paket sistem versus installer lain). Solusi: pakai paket pacman seperti Bagian 4 sampai Anda paham alasannya.

### 2.7 Referensi tingkat fase

- [Pro Git (buku, gratis)](https://git-scm.com/book/en/v2)
- [Arch Wiki: Command-line shell](https://wiki.archlinux.org/title/Command-line_shell)
- [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt)
- [The Linux Command Line — William Shotts](https://linuxcommand.org/tlcl.php)
- [The Missing Semester of Your CS Education (MIT)](https://missing.csail.mit.edu/)
- [Dokumentasi Qt 6](https://doc.qt.io/qt-6/)

## 3. Modul 0.0 — Orientasi untuk Pemula (Jalur A)

**Daftar isi modul ini:** 3.1 Deskripsi dan peran · 3.2 Filosofi modul · 3.3 Visual: perjalanan sebuah perintah · 3.4 Daftar isi sub-bagian · 3.5 Estimasi waktu · lalu 0.0.1 sampai 0.0.9

### 3.1 Deskripsi dan peran

Modul ini mengajarkan hal-hal yang sering dianggap sudah dikenal: apa itu program, bagaimana program diterjemahkan agar bisa dijalankan, mengapa aplikasi grafis hidup di dalam sebuah putaran (event loop), dan cara bekerja di terminal dengan aman dan terdokumentasi (path, proses, environment, pipe, izin, git, membaca error). Pembelajar Jalur B (sudah bisa memprogram) cukup membaca sekilas 0.0.1–0.0.3 dan mengerjakan 0.0.4–0.0.9 sebagai penyegar.

### 3.2 Filosofi modul

**Komputer itu literal.** Ia melakukan persis yang diperintahkan, bukan yang dimaksudkan. Seluruh keterampilan modul ini adalah belajar menyampaikan maksud dengan presisi, lalu membaca jawaban komputer dengan teliti. Pesan error bukan hukuman; ia adalah komputer yang jujur menyebutkan di mana maksud Anda dan perintah Anda berbeda.

### 3.3 Visual: perjalanan sebuah perintah

```
 Anda (keyboard)
      | menekan tombol
      v
 Terminal emulator     jendela teks (foot, kitty, alacritty, dll.)
      | teks
      v
 Shell (bash)          membaca baris, memecah jadi kata,
      |                mencari program di daftar $PATH
      | fork + exec    (membuat proses baru dan memuat program)
      v
 Proses baru           mis. ls, git, qml
      | system call    (meminta layanan kernel)
      v
 Kernel Linux          berkas, memori, jaringan, GPU, jendela
      |
      v
 Keluaran kembali ke terminal:
   stdout (hasil biasa)   stderr (pesan error)   exit code -> $?
```

**Tiga istilah yang sering tertukar:** *terminal emulator* adalah jendelanya; *shell* adalah penerjemah baris perintah di dalamnya (bash, zsh, fish); *console/TTY* adalah terminal asli kernel yang muncul dengan Ctrl+Alt+F-angka. Perintah `echo $0` menampilkan nama shell yang sedang Anda pakai.

### 3.4 Daftar isi sub-bagian

Lihat tabel di Bagian 1. Tiap sub-bagian di bawah memakai urutan yang sama: motivasi singkat, daftar isi mini, deskripsi dan peran, konsep dan filosofi, fondasi, contoh dengan penjelasan kata demi kata, opsi lain, visual, terminologi, tips, kesalahan umum, hubungan modul, latihan dan cek pemahaman, referensi.

### 3.5 Estimasi waktu

| Sub-bagian | Jalur A | Jalur B |
| --- | --- | --- |
| 0.0.1–0.0.2 | 3–4 jam | 30 menit |
| 0.0.3–0.0.5 | 6–8 jam | 1 jam |
| 0.0.6–0.0.7 | 5–6 jam | 1 jam |
| 0.0.8–0.0.9 | 4–5 jam | 1 jam |

---

## 0.0.1 Program, compiler, interpreter

*Semangat: setiap ahli pernah bertanya “apa itu program?” — pertanyaan itu adalah pintu masuknya.*

**Daftar isi 0.0.1:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Fondasi: dari instruksi ke CPU · d. Contoh 1: dikompilasi (C) · e. Contoh 2: diinterpretasi (Python) · f. Contoh 3: hibrida (QML) · g. Logika sama, bahasa berbeda · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan dengan modul lain · m. Latihan dan cek pemahaman · n. Referensi

### a. Deskripsi dan peran

Bagian ini menjelaskan bagaimana teks yang Anda tulis berubah menjadi tindakan komputer. Penting karena Qt memakai **tiga** cara eksekusi sekaligus: C++ (dikompilasi), JavaScript (dijalankan mesin JS), dan QML (dibaca engine lalu diubah menjadi objek dan bytecode). Memahami ini menjelaskan mengapa QML bisa diubah tanpa kompilasi ulang sedangkan C++ tidak, mengapa ada `qmlcachegen` (Modul 11.5), dan mengapa ada error yang muncul saat build dan ada yang baru muncul saat aplikasi berjalan.

### b. Konsep dan filosofi

**Program adalah resep:** urutan instruksi yang bisa dijalankan komputer. Komputer hanya mengerti instruksi biner, jadi harus ada penerjemah:

- **Compiler** menerjemahkan seluruh resep ke bahasa mesin *sekali*, lalu Anda menjalankan hasilnya berkali-kali. Seperti menerjemahkan seluruh buku masak sebelum memasak: awal lambat, pelaksanaan cepat.
- **Interpreter** membaca resep sambil memasak, tiap kali dijalankan. Awal cepat, pelaksanaan lebih lambat, tetapi mudah diubah dan dicoba.
- **Hibrida** menerjemahkan resep menjadi catatan ringkas (bytecode) yang dibaca mesin virtual, kadang dengan JIT yang menerjemahkan bagian yang sering dipakai ke bahasa mesin saat berjalan.

**Filosofi:** tidak ada yang lebih baik secara mutlak. Pilihan adalah kompromi antara kecepatan eksekusi, kecepatan menulis, dan kemudahan mengubah. Qt sengaja memadukannya: bagian berat di C++, bagian yang sering berubah di QML.

### c. Fondasi: dari instruksi ke CPU

CPU membaca instruksi dari memori satu per satu (siklus *fetch, decode, execute*). Himpunan instruksi yang dikenalnya disebut **ISA** (Instruction Set Architecture), misalnya x86-64 untuk kebanyakan PC dan ARM64 untuk banyak perangkat seluler dan papan kecil. Program biner untuk satu ISA tidak berjalan di ISA lain. Menulis biner langsung tidak manusiawi, sehingga lahirlah bahasa tingkat tinggi beserta penerjemahnya. Di Linux, file program dikemas dalam format **ELF**; saat Anda menjalankannya, kernel memuatnya ke memori dan membuat sebuah **proses**.

### d. Contoh 1: dikompilasi (C)

```bash
$ mkdir -p ~/Development/qt-learning/00-orientasi && cd ~/Development/qt-learning/00-orientasi
$ cat > halo.c << 'EOF'
#include <stdio.h>

int main(void)
{
    printf("Halo dari program yang dikompilasi\n");
    return 0;
}
EOF
$ gcc -Wall -o halo halo.c
$ ./halo
Halo dari program yang dikompilasi
$ echo $?
0
$ file halo
halo: ELF 64-bit LSB pie executable, x86-64, ...
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `mkdir -p` | Membuat folder; `-p` ikut membuat folder induk dan tidak error bila sudah ada. |
| `cd` | Pindah ke folder itu. |
| `&&` | Jalankan perintah kanan hanya bila perintah kiri sukses (exit code 0). |
| `cat > halo.c << 'EOF'` … `EOF` | *Here-document*: semua baris sampai kata `EOF` ditulis ke `halo.c`. Tanda kutip pada `'EOF'` mencegah shell mengubah isi (misalnya `$`). |
| `#include <stdio.h>` | Menyertakan deklarasi pustaka input/output standar (dikerjakan preprocessor). |
| `int main(void)` | Titik masuk program. `int` berarti mengembalikan bilangan bulat ke sistem; `void` berarti tanpa argumen. |
| `printf(...)` | Mencetak teks ke stdout; urutan backslash-n di dalam teks berarti pindah baris. |
| `return 0;` | Kode keluar 0 = sukses. |
| `gcc -Wall -o halo halo.c` | Kompilasi. `-Wall` menyalakan peringatan umum, `-o halo` menamai hasil, `halo.c` adalah sumber. |
| `./halo` | Menjalankan file di folder saat ini. `./` wajib karena folder saat ini tidak ada di `$PATH`. |
| `echo $?` | Menampilkan exit code perintah terakhir. |
| `file halo` | Menampilkan jenis file; hasilnya menunjukkan ELF, yaitu format executable Linux. |

### e. Contoh 2: diinterpretasi (Python)

```bash
$ cat > halo.py << 'EOF'
print('Halo dari program yang diinterpretasi')
EOF
$ python halo.py
Halo dari program yang diinterpretasi
```

| Bagian | Arti |
| --- | --- |
| `print(...)` | Fungsi bawaan yang mencetak teks. |
| `python halo.py` | Menjalankan interpreter Python dengan `halo.py` sebagai masukan. Tidak ada file hasil; setiap dijalankan, kode dibaca ulang. |

Bila `python` belum terpasang: ⚠ `sudo pacman -S python`.

### f. Contoh 3: hibrida (QML)

Simpan sebagai `Main.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: console.log('Halo dari QML')
}
```

```bash
$ qml Main.qml
qml: Halo dari QML
```

| Bagian | Arti |
| --- | --- |
| `import QtQuick` | Memuat modul tipe Qt Quick (tanpa nomor versi di Qt 6). |
| `Item { ... }` | Objek dasar visual tanpa tampilan; di sini hanya wadah. |
| `Component.onCompleted` | Handler yang dijalankan sekali setelah objek selesai dibuat. |
| `console.log(...)` | Fungsi JavaScript yang mencetak ke terminal dengan awalan `qml:`. |
| `qml Main.qml` | Menjalankan dokumen QML tanpa proyek C++. Sebuah jendela kosong muncul; hentikan dengan Ctrl+C di terminal. Bila `qml` tidak ditemukan, ikuti pemeriksaan nama executable di Bagian 4 kurikulum. |

### g. Logika sama, bahasa berbeda

| Bahasa | Kode | Cara menjalankan | Model |
| --- | --- | --- | --- |
| Bash | `echo 'Halo'` | `bash halo.sh` | Interpreter |
| Python | `print('Halo')` | `python halo.py` | Bytecode + VM |
| C | `puts("Halo");` di dalam `main` | `gcc -o halo halo.c && ./halo` | Dikompilasi |
| QML + JS | `Component.onCompleted: console.log('Halo')` | `qml Main.qml` | Hibrida |

### h. Visual

```
KOMPILASI (C, C++)  — penerjemahan SEKALI, saat build
 halo.c --> [preprocessor] --> [compiler] --> [assembler] --> halo.o
                                                    |
                         pustaka (libc, Qt, ...) --> [linker] --> halo (ELF)
                                                                    |
                                                      ./halo  (CPU langsung)

INTERPRETASI (bash, Python)  — penerjemahan SETIAP dijalankan
 halo.py --> [interpreter] --> baca --> terjemah --> kerjakan --> ...

HIBRIDA (QML + JavaScript di Qt)
 Main.qml --> [engine QML: parse] --> [bytecode / cache]
          --> [mesin JS Qt: interpreter + JIT dasar bila didukung]
          --> objek Qt (C++) --> scene graph --> layar
```

### i. Terminologi

| Istilah | Arti | Contoh |
| --- | --- | --- |
| Kode sumber | Teks yang ditulis manusia | `halo.c` |
| Bahasa mesin | Instruksi biner yang dipahami CPU | isi `halo` |
| Compiler | Penerjemah seluruh sumber ke bahasa mesin | `gcc` |
| Assembler | Mengubah bahasa rakitan menjadi kode mesin | bagian dari rantai `gcc` |
| Linker | Menyatukan potongan kode dan pustaka menjadi satu executable | bagian dari rantai `gcc` |
| Interpreter | Pembaca dan pelaksana kode saat berjalan | `python` |
| Bytecode | Bentuk perantara ringkas untuk mesin virtual | `.pyc`, cache QML |
| JIT / AOT | Dikompilasi saat berjalan / sebelum berjalan | mesin JS / `gcc` |
| Runtime | Lingkungan yang menjalankan program | engine QML |
| ELF | Format executable Linux | `halo` |
| Library (pustaka) | Kode siap pakai yang dipanggil program | `libQt6Core.so` |
| Build-time / run-time | Saat membangun / saat berjalan | error compiler vs error `qml` |

### j. Tips dan praktik terbaik

- Satu folder percobaan per topik (`00-orientasi`, `01-qml-dasar`, ...); jangan menumpuk file di home.
- Nyalakan peringatan compiler sejak awal: `-Wall -Wextra`. Peringatan hari ini adalah bug besok.
- Biasakan memeriksa `echo $?` setelah perintah penting; skrip dan CMake bergantung pada kode keluar.
- Bedakan sumber error: dari compiler atau CMake (saat build), atau dari `qml` dan aplikasi (saat berjalan).

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `bash: halo: command not found` | Lupa `./` | Jalankan `./halo` |
| `Permission denied` saat `./halo` | Bit eksekusi hilang | `chmod +x halo` (dibahas 0.0.5) |
| `gcc: command not found` | Toolchain belum terpasang | Ikuti pemasangan di Bagian 4 kurikulum |
| Mengubah `halo.c` tetapi hasil lama muncul | Lupa kompilasi ulang | Jalankan `gcc` lagi (nanti diotomatisasi CMake) |
| Mengira QML dikompilasi seperti C | Salah model mental | Ingat: engine membaca QML saat berjalan; cache hanya optimasi |

### l. Hubungan dengan modul lain

Prasyarat untuk: 0.0.2 (mengapa ada putaran event), Modul 0.2 (CMake mengatur kompilasi), Fase 2 (JavaScript di QML), Fase 10 (C++), Modul 11.5 (kompilasi QML dengan `qmlcachegen` dan `qmltc`).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Ubah teks di `halo.c`, kompilasi ulang, dan jalankan. Lalu ubah teks di `halo.py` dan jalankan tanpa langkah kompilasi. Catat perbedaan alur kerjanya.

**Cek pemahaman.** (1) Mengapa program C harus dikompilasi ulang setelah diubah, sedangkan skrip Python tidak? (2) Di mana posisi QML di antara keduanya?

### n. Referensi

- [Crafting Interpreters (buku, gratis)](https://craftinginterpreters.com/)
- [GCC: Overall Options](https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html) · [GCC: Warning Options](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html)
- [Python: Using the interpreter](https://docs.python.org/3/tutorial/interpreter.html)
- [Wikipedia: Compiler](https://en.wikipedia.org/wiki/Compiler) · [Interpreter](<https://en.wikipedia.org/wiki/Interpreter_(computing)>) · [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
- [man elf(5)](https://man7.org/linux/man-pages/man5/elf.5.html)
- [Qt QML](https://doc.qt.io/qt-6/qtqml-index.html)

---

## 0.0.2 Event loop dan mengapa UI bisa macet

*Semangat: antarmuka yang lancar bukan keajaiban, melainkan disiplin kecil yang dijaga setiap milidetik.*

**Daftar isi 0.0.2:** a. Deskripsi dan peran · b. Konsep dan analogi · c. Fondasi: thread GUI dan antrean event · d. Contoh 1: UI yang macet · e. Contoh 2: perbaikan dengan potongan kerja · f. Event loop tanpa Qt (Python) · g. Opsi lain untuk kerja berat · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan dengan modul lain · m. Latihan dan cek pemahaman · n. Referensi

### a. Deskripsi dan peran

Event loop adalah putaran yang menjadi jantung setiap aplikasi interaktif. Binding, signal, animasi, timer, dan hasil jaringan di QML semuanya dijalankan melalui putaran ini. Memahaminya mencegah salah paham paling umum: *kode saya benar, tetapi jendela membeku*.

### b. Konsep dan analogi

**Analogi pelayan restoran.** Program biasa berjalan dari awal sampai akhir lalu selesai. Aplikasi grafis berbeda: ia menunggu kejadian (klik, ketikan, timer, data tiba) lalu menanggapinya. Pelayan terus berkeliling; pelanggan memanggil, pelayan segera menanggapi, lalu kembali berkeliling. Bila pelayan terjebak tiga menit di satu meja, meja lain tidak dilayani; bagi mereka restoran *macet*.

**Filosofi.** Pemrograman berbasis kejadian (*event-driven*) menukar kendali: bukan Anda yang memutuskan kapan kode jalan, melainkan dunia luar. Aturan emasnya: **setiap handler harus selesai cepat dan menyerahkan giliran kembali**. Anggaran untuk 60 bingkai per detik adalah 1000 ms / 60, sekitar 16,7 ms per bingkai.

### c. Fondasi: thread GUI dan antrean event

Sistem operasi mengirim kejadian ke aplikasi lewat platform plugin Qt. Qt menaruhnya di sebuah antrean. `QGuiApplication::exec()` (yang Anda lihat di `main.cpp` Modul 0.2) memulai putaran yang mengambil satu kejadian, memanggil penanganannya, lalu mengambil berikutnya. Thread yang menjalankan putaran ini disebut **thread GUI** atau main thread. Seluruh QML dan JavaScript Anda berjalan di thread ini. Animasi QML digerakkan dari thread GUI juga, sehingga ikut berhenti ketika thread itu sibuk. Penggambaran pada platform tertentu dilakukan di thread render terpisah (Modul 11.1), tetapi ia tetap bergantung pada thread GUI untuk menyiapkan isi bingkai.

### d. Contoh 1: UI yang macet

Simpan sebagai `Main.qml`, jalankan `qml Main.qml`. Kotak putih bergerak bolak-balik; klik di mana saja pada jendela dan perhatikan kotak berhenti sekitar tiga detik.

```qml
import QtQuick

Rectangle {
    width: 320
    height: 160
    color: 'steelblue'

    Rectangle {
        id: kotak
        width: 40
        height: 40
        y: 60
        color: 'white'

        NumberAnimation on x {
            from: 0
            to: 280
            duration: 2000
            loops: Animation.Infinite
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            const mulai = Date.now()
            while (Date.now() - mulai < 3000) { }   // sibuk menunggu 3 detik
            console.log('selesai')
        }
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `Rectangle { ... }` | Persegi panjang berwarna; di sini juga menjadi akar (induk) seluruh isi. |
| `width`, `height`, `color` | Properti ukuran dan warna. Nilai `'steelblue'` adalah nama warna. |
| `id: kotak` | Nama untuk merujuk objek ini dari tempat lain di dokumen. |
| `NumberAnimation on x` | Pasang animasi angka langsung pada properti `x` (kiri-kanan). |
| `from`, `to`, `duration`, `loops` | Mulai 0, berakhir 280, tiap lintasan 2000 ms, berulang tanpa henti. |
| `MouseArea` | Area yang menangkap input mouse; `anchors.fill: parent` membuatnya menutupi seluruh induk. |
| `onClicked: { ... }` | Handler yang dijalankan setiap klik. |
| `const mulai = Date.now()` | Simpan waktu sekarang dalam milidetik; `const` berarti tidak diubah lagi. |
| `while (...) { }` | Putaran kosong yang terus memeriksa waktu: *busy-wait*. Selama ia berjalan, thread GUI tidak bisa melayani apa pun. |
| `console.log('selesai')` | Cetak ke terminal. |

### e. Contoh 2: perbaikan dengan potongan kerja

Pekerjaan berat dipecah menjadi potongan kecil. Setiap potongan selesai cepat, lalu putaran sempat melayani yang lain. Ganti blok `MouseArea` pada Contoh 1 dengan dua blok ini, di dalam `Rectangle` akar:

```qml
Timer {
    id: pekerja
    interval: 0
    repeat: true
    property int terproses: 0
    readonly property int total: 3000000

    onTriggered: {
        let i = terproses
        const batas = Math.min(i + 50000, total)
        for (; i < batas; ++i) { /* kerja kecil per langkah */ }
        terproses = i
        if (terproses >= total) {
            running = false
            console.log('selesai')
        }
    }
}

MouseArea {
    anchors.fill: parent
    onClicked: pekerja.running = true
}
```

| Bagian | Arti |
| --- | --- |
| `Timer` | Objek yang memancarkan sinyal `triggered` secara berkala melalui event loop; **bukan** thread. |
| `interval: 0` | Picu secepat mungkin, tetapi tiap picu tetap lewat antrean sehingga event lain mendapat giliran. |
| `repeat: true` | Ulangi terus sampai `running` dimatikan. |
| `property int terproses` | Penghitung kemajuan yang disimpan di antara potongan. |
| `readonly property int total` | Total pekerjaan; `readonly` melarang diubah. |
| `let i = terproses` | Salin ke variabel lokal agar tidak memicu pemberitahuan perubahan pada tiap iterasi. |
| `Math.min(i + 50000, total)` | Batas potongan ini: paling banyak 50.000 langkah. |
| `running = false` | Hentikan timer setelah semua selesai. |

Kotak kini terus bergerak selama pekerjaan berjalan. Besar potongan (50.000) disesuaikan dengan pengukuran; tujuannya tiap potongan jauh di bawah 16 ms.

### f. Event loop tanpa Qt (Python)

Contoh netral ini memperlihatkan mekanismenya tanpa grafis.

```python
import asyncio
import time

async def detak():
    for i in range(5):
        print('detak', i)
        await asyncio.sleep(0.5)

async def main():
    tugas = asyncio.create_task(detak())
    await asyncio.sleep(0.6)
    time.sleep(2)          # MEMBLOKIR seluruh loop
    await tugas

asyncio.run(main())
```

| Bagian | Arti |
| --- | --- |
| `async def` | Mendefinisikan korutin: fungsi yang boleh berhenti sementara dan menyerahkan giliran. |
| `await asyncio.sleep(0.5)` | Menunggu **sambil menyerahkan giliran** ke loop. |
| `create_task` | Menjadwalkan korutin agar berjalan di loop. |
| `time.sleep(2)` | Menunggu **tanpa** menyerahkan giliran: loop beku dua detik. |
| `asyncio.run(main())` | Membuat dan menjalankan event loop sampai `main` selesai. |

Prediksi: `detak 0` pada detik 0, `detak 1` pada 0,5, lalu hening sampai sekitar 2,6 detik. Setelah itu `detak 2` muncul terlambat. Itulah wujud *macet* yang sama dengan Contoh 1.

Pola umum semua event loop dalam pseudokode:

```text
selama aplikasi hidup:
    kejadian = tunggu_kejadian_berikutnya()
    panggil_penanganan(kejadian)
```

### g. Opsi lain untuk kerja berat

| Pendekatan | Kapan dipakai | Catatan |
| --- | --- | --- |
| Potong kerja dengan `Timer` | Kerja ringan sampai sedang, murni JavaScript | Sederhana; tetap di thread GUI |
| `WorkerScript` | Kerja JavaScript berat yang terisolasi | Thread terpisah; pesan lewat `sendMessage` (Modul 7.4) |
| `XMLHttpRequest` asinkron | Jaringan dan I/O | Tidak memblokir; hindari mode sinkron |
| Thread C++ (`QThread`, `QtConcurrent`) | Kerja CPU berat | Modul 10.7 |
| Model C++ dan sinyal | Data besar | Modul 10.5 |

### h. Visual

```
          THREAD GUI (satu putaran, satu giliran per kejadian)

 OS --> [ antrean event ] --> ambil satu --> jalankan handler --> kembali
 klik    klik, tombol,                              |
 timer   timer, animasi,                            +-- selesai < 16 ms : lancar
 data    pembaruan layar                            |
                                                    +-- 3 detik : antrean menumpuk
                                                        => animasi berhenti
                                                        => klik tak dijawab
                                                        => jendela tampak MACET

 Anggaran bingkai 60 FPS: 1000 ms / 60 = sekitar 16,7 ms
```

### i. Terminologi

| Istilah | Arti | Contoh |
| --- | --- | --- |
| Event (kejadian) | Sesuatu yang terjadi dan perlu ditanggapi | klik, tombol, timer |
| Event loop | Putaran yang mengambil dan menangani event | `exec()` pada Qt |
| Event-driven | Alur program ditentukan oleh kejadian | aplikasi GUI |
| Handler | Kode yang menanggapi satu jenis event | `onClicked` |
| Thread GUI / main thread | Thread yang menjalankan event loop dan QML | semua kode QML |
| Blocking / non-blocking | Menahan giliran / melepas giliran | `time.sleep` / `await` |
| Busy-wait | Menunggu dengan terus memeriksa tanpa melepas giliran | `while (...) { }` |
| Anggaran bingkai | Waktu maksimal per gambar agar mulus | sekitar 16,7 ms pada 60 FPS |
| Asinkron | Memulai kerja, dilanjutkan nanti lewat event | XHR |
| Antrean (queue) | Urutan menunggu giliran | antrean event |

### j. Tips dan praktik terbaik

- Anggap thread GUI sebagai sumber daya langka: setiap milidetik di handler dibayar dengan kelancaran UI.
- Ukur sebelum menebak: bungkus kode dengan `console.time('nama')` dan `console.timeEnd('nama')`.
- Pekerjaan I/O selalu asinkron; pekerjaan CPU berat dipindah ke thread lain (Fase 10).
- Tampilkan indikator kemajuan untuk kerja panjang agar pengguna tahu aplikasi hidup.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| UI beku saat memproses data | Perulangan panjang di handler | Potong kerja atau pindah ke `WorkerScript`/thread |
| Mengira `Timer` berjalan paralel | `Timer` hanya menjadwalkan di thread GUI | Pakai thread bila butuh paralel sungguhan |
| `while (true)` menunggu kondisi | Menunggu dengan memblokir | Gunakan sinyal atau `Timer` |
| Animasi patah-patah setelah menambah fitur | Handler melebihi 16 ms | Ukur dengan `console.time`, lalu optimasi (Modul 11.4) |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 3.1–3.2 (binding dan signal dijalankan lewat putaran ini), 6.2 (animasi), 7.4 (data asinkron dan `WorkerScript`), 10.7 (thread), dan 11.1 (render loop).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan Contoh 1, klik, lalu amati. Ubah 3000 menjadi 500 dan 6000 dan catat dampaknya. Ganti dengan Contoh 2 dan bandingkan.

**Cek pemahaman.** (1) Mengapa kotak berhenti padahal animasi tidak diubah sama sekali? (2) Mengapa `Timer` dengan potongan kecil lebih baik daripada satu perulangan panjang? (3) Apa bedanya `await asyncio.sleep` dengan `time.sleep`?

### n. Referensi

- [The Event System (Qt)](https://doc.qt.io/qt-6/eventsandfilters.html) · [QEventLoop](https://doc.qt.io/qt-6/qeventloop.html)
- [Qt Quick: Performance considerations](https://doc.qt.io/qt-6/qtquick-performance.html)
- [Timer (QML)](https://doc.qt.io/qt-6/qml-qtqml-timer.html) · [WorkerScript](https://doc.qt.io/qt-6/qml-qtquick-workerscript.html)
- [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html)
- [Python asyncio: Event Loop](https://docs.python.org/3/library/asyncio-eventloop.html)
- [Wikipedia: Event loop](https://en.wikipedia.org/wiki/Event_loop)

---

## 0.0.3 Terminal: path, proses, environment

*Semangat: keyboard adalah tuas Anda; terminal adalah mesin yang menanggapinya tanpa tawar-menawar.*

**Daftar isi 0.0.3:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Fondasi: filesystem, proses, warisan environment · d. Navigasi dan path · e. Proses, sinyal, exit code · f. Environment variable · g. Pintasan keyboard (readline) · h. Opsi lain: alat modern · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan dengan modul lain · n. Latihan dan cek pemahaman · o. Referensi

### a. Deskripsi dan peran

Bagian ini mengajarkan bahasa kerja harian: bergerak di sistem berkas, mengelola program yang berjalan, dan mengatur pengaturan bernama (environment) yang diwariskan antarproses. Seluruh kurikulum dikerjakan dari sini; Modul 0.3 mengandalkan variabel lingkungan sebagai alat diagnosa utama.

### b. Konsep dan filosofi

Shell adalah penerjemah antara maksud Anda dan kernel. Setiap perintah mengikuti pola: **nama** diikuti **opsi** (biasanya berawalan `-` atau `--`) diikuti **argumen**. Filosofi Unix: banyak alat kecil yang setiap satunya patuh dan dapat diprediksi, sehingga bisa dirangkai. Kekuatannya ada pada keteraturan; kelemahannya, alat ini tidak bertanya “yakin?” sebelum menghapus.

### c. Fondasi: filesystem, proses, warisan environment

- **Filesystem Linux** berupa satu pohon dengan akar `/`. Tidak ada huruf drive. Tata letaknya dibakukan dalam FHS.
- **Proses** adalah program yang sedang berjalan, punya nomor **PID**, induk (**PPID**), dan folder kerja.
- **Environment** adalah tabel pasangan nama-nilai yang disalin dari proses induk ke proses anak saat dibuat. Perubahan di anak **tidak** kembali ke induk. Inilah akar masalah klasik “variabel sudah saya atur, tetapi tidak berpengaruh”.

### d. Navigasi dan path

```bash
$ pwd
/home/anda
$ ls -la
$ cd ~/Development/qt-learning
$ mkdir -p proyek/uji
$ touch catatan.md
$ cp catatan.md salinan.md
$ mv salinan.md proyek/uji/
$ ls proyek/uji
$ rm -i proyek/uji/salinan.md
$ rmdir proyek/uji
$ cd ..
$ cd -
```

| Bagian | Arti |
| --- | --- |
| `pwd` | Cetak folder kerja saat ini (*print working directory*). |
| `ls -la` | Daftar isi. `-l` format panjang (izin, pemilik, ukuran, waktu), `-a` termasuk file tersembunyi (berawalan titik). |
| `cd ~/Development/qt-learning` | Pindah folder. `~` berarti folder rumah Anda. |
| `mkdir -p proyek/uji` | Buat folder bertingkat sekaligus. |
| `touch catatan.md` | Buat file kosong (atau perbarui waktunya bila sudah ada). |
| `cp A B` | Salin A menjadi B. |
| `mv A tujuan/` | Pindah (atau ganti nama) A. |
| `rm -i` | Hapus dengan konfirmasi `-i`. **Tidak ada tempat sampah**; yang dihapus hilang. |
| `rmdir` | Hapus folder **kosong**; aman karena menolak folder berisi. |
| `cd ..` | Naik satu tingkat. |
| `cd -` | Kembali ke folder sebelumnya. |

**Path.** *Absolut* diawali `/` dan sama dari mana pun (`/home/anda/catatan.md`). *Relatif* bergantung folder kerja (`proyek/uji`, `./catatan.md`, `../lain`). Simbol khusus: `.` folder ini, `..` induk, `~` rumah, `-` folder sebelumnya (hanya untuk `cd`). **Glob**: `*.qml` (semua file berakhiran .qml), `?` (satu karakter), diperluas oleh shell sebelum perintah dijalankan.

### e. Proses, sinyal, exit code

```bash
$ sleep 300 &
[1] 4821
$ jobs
$ pgrep -a sleep
$ ps -o pid,ppid,stat,etime,cmd -p 4821
$ kill 4821
$ echo $?
```

| Bagian | Arti |
| --- | --- |
| `sleep 300 &` | Jalankan di latar belakang; `&` mengembalikan prompt. Shell menampilkan nomor job dan PID. |
| `jobs` | Daftar job latar belakang milik shell ini. |
| `pgrep -a sleep` | Cari proses berdasarkan nama; `-a` menampilkan perintah lengkap. |
| `ps -o ...  -p PID` | Tampilkan kolom terpilih untuk satu proses. |
| `kill PID` | Kirim sinyal SIGTERM: permintaan sopan untuk berhenti. |
| `kill -9 PID` | Kirim SIGKILL: dipaksa, tanpa kesempatan bersih-bersih. Pilihan **terakhir**. |
| `echo $?` | Exit code perintah terakhir. |

**Pintasan dan kode.** Ctrl+C mengirim SIGINT (hentikan); Ctrl+Z menunda proses (lanjutkan dengan `fg` atau `bg`); Ctrl+D menandai akhir input (EOF) dan menutup shell di prompt kosong.

| Exit code | Arti umum |
| --- | --- |
| 0 | Sukses |
| 1–125 | Kegagalan khusus program |
| 126 | Ditemukan, tetapi tidak bisa dieksekusi (izin) |
| 127 | Perintah tidak ditemukan |
| 130 | Dihentikan oleh Ctrl+C (128 + 2) |

### f. Environment variable

```bash
$ printenv HOME
$ echo $PATH
$ MYVAR=halo
$ bash -c 'echo [$MYVAR]'
[]
$ export MYVAR
$ bash -c 'echo [$MYVAR]'
[halo]
$ MYVAR=sementara bash -c 'echo [$MYVAR]'
[sementara]
$ echo $MYVAR
halo
$ command -v qml
$ export PATH="$HOME/.local/bin:$PATH"
```

| Bagian | Arti |
| --- | --- |
| `printenv HOME` | Tampilkan nilai satu variabel environment. |
| `$PATH` | Daftar folder (dipisah `:`) tempat shell mencari program saat Anda mengetik nama perintah. |
| `MYVAR=halo` | Variabel **shell**: hanya hidup di shell ini, tidak diwariskan. Tanpa spasi di sekitar `=`. |
| `bash -c '...'` | Jalankan shell anak untuk membuktikan apa yang diwariskan. Tanda kutip tunggal mencegah shell induk mengganti `$MYVAR` lebih dulu. |
| `export MYVAR` | Jadikan variabel itu **environment**: diwariskan ke anak berikutnya. |
| `MYVAR=sementara perintah` | **Prefiks**: nilai hanya berlaku untuk satu perintah itu. Inilah bentuk `QT_QPA_PLATFORM=xcb qml Main.qml` di Modul 0.3. |
| `command -v qml` | Tampilkan lokasi yang akan dipakai untuk `qml`; kosong berarti tidak ditemukan. |
| `export PATH="$HOME/.local/bin:$PATH"` | Tambahkan folder di depan PATH tanpa menghapus isi lama. Kutip ganda menjaga spasi. |

**Membuat permanen.** Tulis `export ...` di `~/.bashrc` (shell interaktif) atau `~/.bash_profile`/`~/.profile` (shell login). Banyak pengaturan Arch membuat `.bash_profile` memuat `.bashrc`; periksa milik Anda. Perhatian: aplikasi yang diluncurkan dari compositor atau launcher **tidak** membaca `.bashrc`; untuk itu gunakan mekanisme sesi (mis. `~/.config/environment.d/` pada sesi systemd user). Inilah penyebab “variabel diatur di shell lain dari tempat aplikasi dijalankan” yang diperingatkan Modul 0.3.

**Kutip.** Kutip tunggal `'...'` = harfiah, tidak ada penggantian. Kutip ganda `"..."` = `$variabel` tetap diganti, spasi dijaga. Tanpa kutip, spasi memecah argumen dan glob diperluas.

### g. Pintasan keyboard (readline)

| Pintasan | Fungsi |
| --- | --- |
| Tab | Lengkapi nama; tekan dua kali untuk melihat pilihan |
| Ctrl+A / Ctrl+E | Awal / akhir baris |
| Alt+B / Alt+F | Mundur / maju satu kata |
| Ctrl+W / Ctrl+U / Ctrl+K | Hapus kata ke belakang / ke awal baris / ke akhir baris |
| Ctrl+R | Cari mundur di riwayat perintah |
| Ctrl+L | Bersihkan layar |
| `!!` | Ulangi perintah sebelumnya (mis. `sudo !!`) |

### h. Opsi lain: alat modern

Alat bawaan (coreutils) selalu tersedia dan dipakai di skrip. Alat berikut meringankan kerja interaktif; ⚠ pasang dengan `sudo pacman -S --needed <paket>` setelah memeriksa `pacman -Si <paket>`.

| Kebutuhan | Bawaan | Alternatif | Catatan |
| --- | --- | --- | --- |
| Daftar file | `ls` | `eza`, `lsd` | Warna, ikon, pohon (`eza --tree`) |
| Pohon folder | `tree` | `eza --tree` |  |
| Lihat file | `cat`, `less` | `bat` | Penyorotan sintaks |
| Cari file | `find` | `fd` | Sintaks lebih ringkas |
| Cari isi | `grep` | `ripgrep` (`rg`) | Cepat, menghormati `.gitignore` |
| Pindah folder | `cd` | `zoxide`, `fzf` | Lompat ke folder yang sering dipakai |
| Proses | `top` | `htop`, `btop` | Tampilan interaktif |
| Banyak panel |  | `tmux`, `zellij` | Sesi terminal yang bisa dilepas dan disambung lagi |
| Berkas TUI |  | `yazi`, `ranger` | Navigasi penuh keyboard |

Catatan praktik: jangan membuat `alias` yang mengganti perilaku perintah standar (mis. `alias ls=eza`) di dalam **skrip**; pakai di sesi interaktif saja.

### i. Visual

```
/
├── home/
│   └── anda/                    <- ~ (folder rumah)
│       ├── Development/qt-learning/
│       ├── .bashrc              <- berawalan titik = tersembunyi
│       └── .config/
├── etc/                         konfigurasi sistem
├── usr/
│   ├── bin/                     program
│   └── lib/                     pustaka (termasuk Qt)
├── tmp/                         sementara
└── var/                         data yang berubah (log, cache)

WARISAN ENVIRONMENT
 shell induk (PATH=..., HOME=..., MYVAR=halo setelah export)
   |-- proses anak (qml, git, bash -c) --> menerima SALINAN
   |-- MYVAR=nilai perintah ------------> hanya untuk satu proses itu
   x   perubahan di anak TIDAK kembali ke induk
```

### j. Terminologi

| Istilah | Arti | Contoh |
| --- | --- | --- |
| Path absolut / relatif | Alamat penuh dari `/` / alamat dari folder kerja | `/home/anda/a.md` / `../a.md` |
| Folder kerja (cwd) | Lokasi shell saat ini | hasil `pwd` |
| File titik (dotfile) | File konfigurasi tersembunyi | `.bashrc`, `.gitignore` |
| PID / PPID | Nomor proses / nomor induknya | `4821` |
| Foreground / background | Proses di depan / di belakang | `perintah &` |
| Sinyal | Pesan singkat dari/ke proses | SIGTERM, SIGINT, SIGKILL |
| Exit code | Bilangan hasil akhir proses | `$?` |
| Shell variable | Variabel yang tidak diwariskan | `MYVAR=halo` |
| Environment variable | Variabel yang diwariskan ke proses anak | `export MYVAR` |
| Glob | Pola nama file yang diperluas shell | `*.qml` |

### k. Tips dan praktik terbaik

- Jalankan `pwd` dan `ls` sebelum perintah yang menghapus atau memindahkan.
- Gunakan Tab hampir setiap kali: lebih cepat, dan salah ketik nyaris mustahil.
- Rangkai dengan `&&` agar perintah berikutnya hanya jalan bila yang pertama sukses: `cd proyek && rm -i *.tmp`.
- Simpan catatan perintah penting di `catatan.md` repositori belajar Anda.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Menghapus terlalu banyak | `rm -rf "$DIR"/*` saat `DIR` kosong menjadi `/*` | Pakai `"${DIR:?}"` agar perintah gagal bila kosong; biasakan `rm -i` |
| File bernama dengan spasi terpecah | Argumen tanpa kutip | Beri kutip: `"nama file.txt"` |
| Perintah lanjut di folder salah | `cd` gagal tetapi baris berikutnya tetap jalan | Pakai `cd ... && ...` |
| Semua perintah “hilang” | `export PATH=/folder` tanpa `:$PATH` | Selalu sertakan nilai lama: `PATH="/folder:$PATH"`; buka shell baru untuk pulih |
| Variabel tidak berpengaruh | Diatur di shell lain atau tanpa `export` | Atur di shell yang sama, atau pakai prefiks |
| `Permission denied` | Izin atau pemilik | Lihat 0.0.5 |

### m. Hubungan dengan modul lain

Prasyarat untuk 0.0.4 (pipe), 0.0.5 (izin), 0.0.6 (git bekerja di folder kerja), Modul 0.2 (folder build), Modul 0.3 (variabel diagnostik), alur kerja Bagian 4, dan Modul 13.3 (packaging).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** (1) Buat `~/Development/qt-learning/00-orientasi/uji` dan pindahkan sebuah file ke dalamnya, lalu hapus dengan aman. (2) Atur `LATIHAN=satu`, buktikan dengan `bash -c` bahwa ia belum diwariskan, lalu `export` dan buktikan lagi. (3) Jalankan `sleep 60 &`, temukan PID-nya, hentikan dengan `kill`, dan periksa `$?`.

**Cek pemahaman.** (1) Apa bedanya shell variable dan environment variable? (2) Mengapa `./halo` perlu `./`? (3) Mengapa mengubah variabel di terminal A tidak mengubah aplikasi yang sudah berjalan di terminal B?

### o. Referensi

- [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
- [Arch Wiki: Bash](https://wiki.archlinux.org/title/Bash) · [Environment variables](https://wiki.archlinux.org/title/Environment_variables) · [XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory)
- [GNU Coreutils manual](https://www.gnu.org/software/coreutils/manual/coreutils.html)
- [man hier(7): tata letak filesystem](https://man7.org/linux/man-pages/man7/hier.7.html) · [man signal(7)](https://man7.org/linux/man-pages/man7/signal.7.html)
- [Readline User Manual](https://tiswww.case.edu/php/chet/readline/rluserman.html)
- [The Linux Command Line](https://linuxcommand.org/tlcl.php) · [explainshell](https://explainshell.com/)

---

## 0.0.4 Pipe, redirect, dan penyaring teks \[TAMBAHAN\]

**Mengapa ditambahkan:** Modul 0.3 memakai `2>&1 | head -50` tanpa pernah mengajarkannya, dan membaca pesan error panjang (0.0.7) hampir mustahil tanpa keterampilan ini. Urutan belajarnya logis: setelah bisa menjalankan perintah (0.0.3), belajar menyambung dan menyimpan keluarannya.

*Semangat: satu alat kecil itu biasa; dua alat yang tersambung adalah kekuatan.*

**Daftar isi 0.0.4:** a. Deskripsi dan peran · b. Konsep: tiga aliran standar · c. Redirect · d. Pipe · e. Penyaring teks · f. Penerapan pada Qt · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Setiap program mengeluarkan teks. Keterampilan ini mengajarkan cara **menyimpan**, **menyaring**, dan **menyambung** teks itu. Ia mengubah keluaran 500 baris menjadi tiga baris yang Anda cari.

### b. Konsep: tiga aliran standar

Setiap proses lahir dengan tiga saluran: **stdin** (masukan, nomor 0), **stdout** (keluaran biasa, nomor 1), dan **stderr** (keluaran galat/peringatan, nomor 2). Nomor itu disebut *file descriptor*. Secara bawaan stdin tersambung ke keyboard dan stdout/stderr ke layar, sehingga keduanya tampak tercampur. Pemisahan dua aliran keluaran adalah keputusan desain yang disengaja: hasil dapat dipipakan ke program lain sementara peringatan tetap terlihat. **Redirect** mengalihkan saluran ke file; **pipe** menyambung stdout satu proses ke stdin proses lain.

### c. Redirect

```bash
$ ls -la > daftar.txt
$ echo 'baris tambahan' >> daftar.txt
$ ls /tidak-ada 2> galat.txt
$ ls /tidak-ada /tmp > hasil.txt 2> galat.txt
$ ls /tidak-ada /tmp > semua.txt 2>&1
$ ls /tidak-ada /tmp &> semua.txt
$ ls /tidak-ada /tmp > /dev/null 2>&1
$ wc -l < daftar.txt
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `> file` | Alihkan stdout ke file. **Menimpa** isi lama tanpa bertanya. |
| `>> file` | Alihkan stdout dengan **menambahkan** di akhir file. |
| `2> file` | Alihkan stderr (saluran 2) ke file. |
| `> hasil.txt 2> galat.txt` | Pisahkan: hasil ke satu file, galat ke file lain. |
| `> semua.txt 2>&1` | stdout ke file, lalu “saluran 2 ikut ke tempat saluran 1 berada”. **Urutan penting**: `2>&1` harus setelah `> file`. |
| `&> file` | Singkatan bash untuk keduanya sekaligus. |
| `/dev/null` | Berkas khusus yang membuang semua yang ditulis ke sana. |
| `< file` | Alihkan stdin dari file. |

### d. Pipe

Tanda pipa menyambung stdout perintah kiri ke stdin perintah kanan. Hanya **stdout** yang lewat; stderr tetap ke layar kecuali dialihkan.

```bash
$ ls -la /usr/bin | less
$ ls -la /usr/bin | head -5
$ ls -la /usr/bin | wc -l
$ ls /tidak-ada /tmp 2>&1 | head -3
$ ls /tidak-ada /tmp |& head -3
```

- `perintah | less` — tampilkan keluaran di pager yang bisa digulir; `q` keluar, `/kata` mencari, `n` hasil berikutnya.
- `| head -5` — ambil 5 baris pertama; `tail -5` mengambil 5 baris terakhir.
- `| wc -l` — hitung baris (*word count*, opsi `-l` = lines).
- `2>&1 | head -3` — gabungkan stderr ke stdout **sebelum** masuk pipa, sehingga kedua jenis keluaran terbawa. `|&` adalah singkatan bash.

### e. Penyaring teks

```bash
$ grep -n 'export' ~/.bashrc
$ grep -rn 'Rectangle' --include='*.qml' .
$ grep -i 'error' semua.txt
$ sort daftar.txt
$ sort daftar.txt | uniq -c | sort -rn | head -3
$ ls /tmp | tee daftar-tmp.txt | wc -l
$ tail -f /tmp/contoh.log
```

| Perintah | Fungsi |
| --- | --- |
| `grep POLA file` | Cetak baris yang cocok. `-n` nomor baris, `-i` abaikan huruf besar/kecil, `-r` rekursif, `--include='*.qml'` batasi jenis file. |
| `sort` | Urutkan baris. `-r` terbalik, `-n` numerik. |
| `uniq -c` | Gabungkan baris berurutan yang sama dan hitung (**butuh `sort` dulu**). |
| `tee file` | Simpan salinan aliran ke file **sambil** meneruskannya ke pipa. |
| `tail -f` | Ikuti file yang terus bertambah (log berjalan); Ctrl+C untuk berhenti. |

### f. Penerapan pada Qt

```bash
$ QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | head -50
$ QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | grep -i 'QtQuick'
$ qml Main.qml &> log.txt
```

Baris pertama persis perintah Modul 0.3. Jejak import ditulis ke **stderr**. Tanpa `2>&1`, pipa hanya membawa stdout dan jejak 500 baris tetap membanjiri layar. Dengan `2>&1`, `head -50` memotongnya menjadi 50 baris. Awalan `QML_IMPORT_TRACE=1` adalah prefiks variabel dari 0.0.3.

### g. Opsi lain

| Tujuan | Bawaan | Alternatif | Catatan |
| --- | --- | --- | --- |
| Lihat panjang | `less` | `bat --paging=always` | `bat` menyorot sintaks |
| Cari teks | `grep -rn` | `rg` (ripgrep) | Lebih cepat, hormati `.gitignore` |
| Potong baris | `head`, `tail` | `sed -n '1,50p'`, `awk 'NR<=50'` | Lebih fleksibel |
| Kolom rapi |  | `column -t` | Merapikan tabel teks |
| Potong kolom |  | `cut -d: -f1` | Mengambil bidang tertentu |
| JSON |  | `jq` | Penyaring JSON (paket `jq`) |
| Log sistem |  | `journalctl -f` | Mengikuti log systemd |

### h. Visual

```
            +-----------+  stdout (1)  +---> layar / file / pipa
  stdin (0) |  PROSES   |-------------+
  --------->|           |  stderr (2)  +---> layar (bawaan)
            +-----------+-------------+

  cmd > f         : stdout -> file f
  cmd 2> g        : stderr -> file g
  cmd > f 2>&1    : stdout -> f, stderr -> ke tempat stdout (f)
  cmd1 | cmd2     : stdout cmd1 -> stdin cmd2
  cmd1 2>&1 | cmd2: stdout + stderr cmd1 -> stdin cmd2
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| stdin / stdout / stderr | Saluran masukan / keluaran / galat standar (0 / 1 / 2) |
| File descriptor | Nomor yang mewakili saluran terbuka milik proses |
| Redirect | Mengalihkan saluran ke atau dari file |
| Pipe, pipeline | Penyambung stdout ke stdin; rangkaian beberapa proses |
| Filter | Program yang membaca stdin dan menulis stdout (`grep`, `sort`) |
| Pager | Penampil halaman demi halaman (`less`) |
| `/dev/null` | Berkas pembuang |

### j. Tips dan praktik terbaik

- Sebelum `> file`, pastikan file itu tidak berharga: tanda `>` menimpa tanpa tanya. Aktifkan pengaman `set -o noclobber` di sesi interaktif (paksa tulis dengan `>|`).
- Simpan log percobaan Qt dengan `&> log.txt`, lalu cari dengan `grep`. Jangan membaca ratusan baris dengan mata.
- Pilih `grep POLA file` daripada `cat file | grep POLA`; hasilnya sama, prosesnya lebih sedikit.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Pesan error tetap membanjiri layar | Hanya stdout yang masuk pipa | Tambah `2>&1` sebelum pipa |
| `> f 2>&1` berbeda dengan `2>&1 > f` | Urutan menentukan tujuan salinan | Tulis `> f 2>&1` |
| `sudo perintah > /root/file` ditolak | Redirect dikerjakan shell **Anda**, bukan sudo | ` perintah  ` dialirkan ke `  sudo tee /root/file ` lewat pipa, atau `sudo sh -c '...'` |
| `uniq -c` hasilnya acak | Belum diurutkan | Pipakan lewat `sort` dulu |
| File penting hilang isinya | Tertimpa `>` | `noclobber`, dan git (0.0.6) |

### l. Hubungan dengan modul lain

Prasyarat untuk 0.0.7 (membaca error), Modul 0.3 (log diagnostik), 12.1 (debugging), dan skrip validasi tautan di Bagian E kurikulum.

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `ls /tidak-ada /tmp` dan catat. Lalu pisahkan stdout dan stderr ke dua file, gabungkan ke satu file, dan hitung barisnya dengan `wc -l`. Terakhir jalankan contoh `QML_IMPORT_TRACE=1` dengan `Main.qml` sederhana dan simpan hasilnya ke `log.txt`.

**Cek pemahaman.** (1) Apa yang dibawa pipa, stdout atau stderr? (2) Mengapa `2>&1` harus ditulis setelah `> file`? (3) Apa bedanya `>` dan `>>`?

### n. Referensi

- [Bash: Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html) · [Bash: Pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html)
- [GNU grep manual](https://www.gnu.org/software/grep/manual/grep.html)
- [Arch Wiki: Core utilities](https://wiki.archlinux.org/title/Core_utilities)
- [ripgrep](https://github.com/BurntSushi/ripgrep) · [Wikipedia: Pipeline (Unix)](<https://en.wikipedia.org/wiki/Pipeline_(Unix)>)

---

## 0.0.5 Izin file, pengguna, dan sudo \[TAMBAHAN\]

**Mengapa ditambahkan:** Kesalahan umum Modul 0.0 memperingatkan `sudo`, 0.0.1 dan 0.0.3 sudah memunculkan `Permission denied` dan exit code 126, tetapi izin file belum diajarkan. Ini juga fondasi keamanan untuk Modul 13.1.

*Semangat: kekuatan besar menuntut kebiasaan kecil yang disiplin.*

**Daftar isi 0.0.5:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Membaca izin · d. Mengubah izin dan pemilik · e. sudo dengan disiplin · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Linux adalah sistem multi-pengguna: tiap berkas punya pemilik, kelompok, dan aturan siapa boleh membaca, menulis, atau menjalankan. Pemahaman ini mencegah dua hal yang sering menjebak pemula: perintah yang gagal karena izin, dan kebiasaan memakai `sudo` untuk menyelesaikan segala hal sehingga sistem rusak pelan-pelan.

### b. Konsep dan filosofi

**Prinsip hak istimewa minimum (*least privilege*):** setiap proses dan pengguna hanya memiliki hak yang benar-benar dibutuhkan. Pengguna **root** (UID 0) melewati semua pemeriksaan izin, sehingga salah ketik oleh root bisa menghancurkan sistem. `sudo` meminjamkan hak root untuk **satu perintah** dan mencatatnya; itu lebih aman daripada bekerja sebagai root terus-menerus.

### c. Membaca izin

```bash
$ id
$ ls -l halo catatan.md
-rwxr-xr-x 1 anda anda 15960 Nov  5 10:00 halo
-rw-r--r-- 1 anda anda    42 Nov  5 10:05 catatan.md
$ stat -c '%A %a %U:%G %n' halo catatan.md
$ umask
```

| Bagian | Arti |
| --- | --- |
| `id` | Menampilkan UID, GID, dan grup tempat Anda berada. |
| `-rwxr-xr-x` | Karakter pertama: jenis (`-` file, `d` folder, `l` tautan). Lalu tiga tiga: izin **pemilik**, **grup**, **lainnya**. |
| `r`, `w`, `x` | Baca, tulis, eksekusi. Angkanya 4, 2, 1. `rwx` = 7, `r-x` = 5, `r--` = 4. |
| `755`, `644` | Bentuk oktal: 755 = `rwxr-xr-x`, 644 = `rw-r--r--`. |
| `anda anda` | Pemilik dan grup file. |
| `stat -c ...` | Cetak izin dalam bentuk simbol (`%A`), oktal (`%a`), dan pemilik (`%U:%G`). |
| `umask` | Topeng yang menentukan izin bawaan file baru; umumnya `0022` sehingga file baru menjadi 644 dan folder 755. |

**Pada folder:** `r` boleh melihat daftar isi, `w` boleh membuat atau menghapus isi, `x` boleh masuk (traversal). Folder tanpa `x` tidak bisa dimasuki.

### d. Mengubah izin dan pemilik

```bash
$ chmod +x script.sh
$ chmod u+x,go-w script.sh
$ chmod 644 catatan.md
$ chmod 755 halo
$ find ~/Development -user root
$ sudo chown -R anda:anda ~/Development/qt-learning
```

- `chmod +x` — beri hak eksekusi. Bentuk simbolik: `u` pemilik, `g` grup, `o` lainnya, `a` semua; `+` tambah, `-` cabut, `=` tetapkan.
- `chmod 644` — tetapkan sekaligus dengan angka.
- `find ~/Development -user root` — cari file milik root di folder kerja (tanda `sudo` pernah salah dipakai).
- `sudo chown -R anda:anda ...` — kembalikan kepemilikan secara rekursif (`-R`). ⚠ periksa path dulu.

### e. sudo dengan disiplin

```bash
$ sudo -l
$ sudo pacman -Syu
$ sudoedit /etc/hosts
$ sudo -k
```

- `sudo -l` — daftar hak yang Anda miliki lewat sudo.
- `sudo pacman -Syu` — contoh sah: memperbarui sistem membutuhkan hak root. ⚠
- `sudoedit` (atau `sudo -e`) — menyunting file sistem memakai editor **Anda**, dengan hak root hanya saat menyimpan; lebih aman daripada `sudo nvim`.
- `sudo -k` — lupakan kredensial sudo yang tersimpan.

**Aturan disiplin:** (1) jangan memakai sudo untuk `qml`, `cmake`, `git`, atau build apa pun; (2) jangan menjalankan aplikasi grafis dengan sudo; (3) baca perintah sebelum menekan Enter; (4) edit sudoers hanya lewat `visudo`.

### f. Opsi lain

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Naik hak | `sudo` | Standar, log jelas |
| Naik hak | `doas` (paket `opendoas`) | Lebih kecil dan sederhana |
| Naik hak | `run0` (systemd 256 ke atas) | Alternatif bawaan systemd |
| Beralih pengguna | `su -` | Memerlukan kata sandi pengguna tujuan |
| Izin lebih rinci | `setfacl`, `getfacl` (ACL) | Izin per pengguna tertentu |
| Kunci berkas | `chattr +i` | Berkas tak dapat diubah, bahkan oleh root |
| Tambah grup | `usermod -aG grup pengguna` | ⚠ perlu login ulang |

### g. Visual

```
   -    r w x    r - x    r - x
   |    +---+    +---+    +---+
   |    pemilik   grup    lainnya
   +-- jenis: - file, d folder, l tautan

   r = 4   w = 2   x = 1
   rwx = 7     r-x = 5     r-- = 4     --- = 0
   755  =  pemilik 7, grup 5, lainnya 5

   Pengguna biasa --sudo--> satu perintah dengan hak root --> kembali
   (bukan: login sebagai root sepanjang hari)
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| UID / GID | Nomor identitas pengguna / grup |
| Pemilik, grup, lainnya | Tiga kelas pemegang izin |
| Mode | Kumpulan bit izin sebuah file |
| Oktal | Penulisan izin dengan angka 0–7 per kelas |
| root | Pengguna dengan UID 0, tanpa batasan |
| sudo / sudoers | Alat meminjam hak / berkas aturannya |
| Least privilege | Hanya hak yang diperlukan |
| setuid | Bit khusus: program berjalan dengan hak pemiliknya (tampak sebagai `s`, misalnya pada `sudo`); sengaja langka |
| ACL | Daftar kontrol akses yang lebih rinci dari tiga kelas |

### i. Tips dan praktik terbaik

- Bekerja sebagai pengguna biasa; gunakan `sudo` per perintah, bukan `sudo -i` atau `su` sepanjang hari.
- Skrip pribadi: `chmod 755` (atau `700` bila rahasia). Berkas rahasia seperti kunci: `600`.
- Bila `Permission denied`, baca `ls -l` file **dan** folder induknya sebelum mencoba sudo.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `chmod -R 777` “agar jalan” | Menghapus semua batas keamanan | Cari penyebab asli; beri hanya izin yang dibutuhkan |
| Folder `build/` milik root | `sudo cmake --build` atau `sudo make` | `sudo chown -R anda:anda build`, lalu jangan ulangi |
| `bash: ./skrip: Permission denied` | Bit eksekusi hilang | `chmod +x skrip` |
| `.git` milik root | `sudo git ...` | Kembalikan dengan `chown`; jangan pakai sudo untuk git |
| `sudo` mengubah `$HOME` atau env | sudo membersihkan environment | Jalankan tanpa sudo bila tidak perlu root |

### k. Hubungan dengan modul lain

Prasyarat untuk 0.0.6 (kepemilikan `.git`), Modul 0.2 (folder build milik Anda), 13.1 (keamanan aplikasi), dan 13.3 (izin saat packaging).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat `latihan.sh` berisi satu baris `echo halo`. Jalankan `./latihan.sh` dan amati galatnya; tambahkan izin eksekusi dan ulangi. Terjemahkan `rw-r-----` ke bentuk oktal, lalu verifikasi dengan `chmod` dan `stat`.

**Cek pemahaman.** (1) Apa arti `755`? (2) Mengapa `sudo cmake --build` merusak folder build? (3) Mengapa `sudoedit` lebih aman daripada `sudo nvim`?

### m. Referensi

- [Arch Wiki: File permissions and attributes](https://wiki.archlinux.org/title/File_permissions_and_attributes) · [Arch Wiki: sudo](https://wiki.archlinux.org/title/Sudo)
- [GNU Coreutils: chmod invocation](https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html)
- [man credentials(7)](https://man7.org/linux/man-pages/man7/credentials.7.html) · [Dokumentasi sudo](https://www.sudo.ws/docs/man/sudo.man/)
- [Wikipedia: Principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege)

---

## 0.0.6 Git minimum: config, init, add, commit, diff, log, restore

*Semangat: riwayat adalah mesin waktu pribadi Anda — dipasang sekali, menyelamatkan berkali-kali.*

**Daftar isi 0.0.6:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Fondasi: snapshot dan hash · d. Identitas (`git config`) · e. init, status, add, commit · f. diff dan log · g. Membatalkan (restore, revert) · h. `.gitignore` · i. Pesan commit yang baik · j. Opsi lain · k. Visual · l. Terminologi · m. Tips · n. Kesalahan umum · o. Hubungan · p. Latihan dan cek · q. Referensi

### a. Deskripsi dan peran

Git mencatat riwayat perubahan sebuah folder. Anda akan memakainya di setiap proyek kurikulum (Bagian C), dan Qt sendiri dikembangkan dengan git, sehingga kemampuan membaca riwayat juga menjadi bekal Modul 14.5–14.6. Di tahap ini Anda hanya butuh sebelas perintah.

### b. Konsep dan filosofi

Git tidak menyimpan *selisih*, melainkan **potret (snapshot)** seluruh proyek tiap kali Anda melakukan commit, dan menautkannya ke potret sebelumnya. Dari situ lahir tiga prinsip: setiap keadaan lama bisa dipulihkan; setiap perubahan dapat diperiksa sebelum disimpan; dan riwayat itu *bukti* yang dapat diaudit. Git memisahkan **apa yang Anda ubah** (working tree) dari **apa yang akan disimpan** (staging area) agar satu commit hanya berisi satu maksud.

### c. Fondasi: snapshot dan hash

Setiap commit diberi **hash** (sidik jari) yang dihitung dari isinya; mengubah satu huruf di riwayat mengubah hash seluruh rantai sesudahnya. Karena itu riwayat git tahan manipulasi diam-diam. Seluruh riwayat disimpan di folder tersembunyi `.git` di akar proyek; menghapus `.git` berarti kehilangan riwayat.

### d. Identitas (`git config`)

Git menolak commit sebelum mengetahui siapa Anda. Ini yang membuat latihan tanpa langkah ini gagal.

```bash
$ git config --global user.name 'Nama Anda'
$ git config --global user.email 'anda@example.com'
$ git config --global init.defaultBranch main
$ git config --global --list
```

| Bagian | Arti |
| --- | --- |
| `--global` | Berlaku untuk semua repositori milik Anda (disimpan di `~/.gitconfig`). Tanpa opsi ini, berlaku untuk satu repositori. |
| `user.name`, `user.email` | Identitas yang dicetak di setiap commit. Alamat ini tampak di riwayat; bila repositori nanti dipublikasikan, gunakan alamat khusus atau alamat noreply sesuai prinsip anonimitas. |
| `init.defaultBranch main` | Nama cabang awal untuk repositori baru. |
| `--list` | Tampilkan semua pengaturan aktif. |

### e. init, status, add, commit

```bash
$ cd ~/Development/qt-learning
$ git init
Initialized empty Git repository in /home/anda/Development/qt-learning/.git/
$ echo '# Catatan belajar Qt' > catatan.md
$ git status
$ git add catatan.md
$ git status
$ git commit -m 'Tambah catatan awal'
```

| Bagian | Arti |
| --- | --- |
| `git init` | Menjadikan folder ini repositori: membuat `.git`. Aman dijalankan; tidak menyentuh file Anda. |
| `echo '...' > catatan.md` | Membuat file (lihat 0.0.4: redirect `>`). |
| `git status` | **Perintah yang paling sering dipakai.** Menampilkan: file belum dilacak (*untracked*), diubah (*modified*), dan sudah disiapkan (*staged*). |
| `git add catatan.md` | Pindahkan perubahan file itu ke staging area. |
| `git commit -m '...'` | Simpan potret dari isi staging area dengan pesan. Tanpa `-m`, git membuka editor. |

### f. diff dan log

```bash
$ echo 'Qt memakai QML.' >> catatan.md
$ git diff
$ git add catatan.md
$ git diff --staged
$ git commit -m 'Catat hubungan Qt dan QML'
$ git log --oneline --graph --decorate
$ git show --stat HEAD
```

| Bagian | Arti |
| --- | --- |
| `git diff` | Selisih antara working tree dan staging area. Baris berawalan `+` ditambah, `-` dihapus; blok disebut *hunk*. |
| `git diff --staged` | Selisih staging area terhadap commit terakhir: **apa yang akan masuk commit**. Periksa ini sebelum commit. |
| `git log --oneline --graph --decorate` | Riwayat ringkas satu baris per commit, dengan grafik cabang dan label (`HEAD`, `main`). |
| `git show --stat HEAD` | Rincian commit terakhir dan file yang terdampak. |
| `HEAD` | Penunjuk ke commit tempat Anda berada sekarang. |

### g. Membatalkan (restore, revert)

```bash
$ git restore catatan.md
$ git restore --staged catatan.md
$ git revert HEAD
```

- `git restore file` — buang perubahan yang belum di-stage dan kembalikan file seperti commit terakhir. ⚠ **Tidak bisa dibatalkan.**
- `git restore --staged file` — batalkan `git add`; isi file tidak berubah.
- `git revert HEAD` — buat commit **baru** yang membatalkan commit terakhir; riwayat tetap utuh sehingga aman.
- Hindari dulu `git reset --hard`: ia menghapus perubahan tanpa jejak.

### h. `.gitignore`

File yang tidak boleh dilacak: hasil build, biner, dan rahasia. Modul 0.2 membangun di `build/`, jadi daftarkan sekarang.

```bash
$ cat > .gitignore << 'EOF'
build/
*.o
00-orientasi/halo
log.txt
EOF
$ git add .gitignore
$ git commit -m 'Abaikan hasil build dan log'
```

| Pola | Arti |
| --- | --- |
| `build/` | Abaikan folder bernama `build` beserta isinya. |
| `*.o` | Abaikan semua berkas berakhiran `.o` (objek kompilasi). |
| `00-orientasi/halo` | Abaikan satu file biner tertentu. |
| `log.txt` | Abaikan file log. |

Peringatan keamanan: **jangan pernah** meng-commit kata sandi, token, atau kunci. Begitu masuk riwayat, ia tetap tersimpan walau file dihapus kemudian.

### i. Pesan commit yang baik

Baris pertama singkat (sekitar 50 karakter), bentuk perintah, menjawab **mengapa/apa maksudnya**: `Catat hubungan Qt dan QML`, bukan `ubah file`. Satu commit = satu maksud. Format lanjutan yang umum: Conventional Commits (`feat:`, `fix:`, `docs:`).

### j. Opsi lain

| Kebutuhan | Perintah/alat | Catatan |
| --- | --- | --- |
| Pilih potongan perubahan | `git add -p` | Memecah satu file menjadi beberapa commit |
| Commit semua file terlacak | `git commit -am '...'` | Tidak mencakup file baru |
| Cabang | `git switch -c nama` | Percobaan terisolasi |
| Simpan sementara | `git stash` | Menyisihkan pekerjaan belum selesai |
| Antarmuka TUI | `lazygit`, `tig` | Penuh keyboard |
| Diff berwarna | `delta` | Pager untuk diff dan log |
| Sistem lain | `jj` (Jujutsu), `hg`, `fossil` | Git tetap standar ekosistem Qt |

### k. Visual

```
 [ Working tree ] --git add--> [ Staging area ] --git commit--> [ Repositori ]
        ^                            |                                |
        +<-- git restore --staged ---+                                |
        +<--------- git restore (dari commit terakhir) --------------+

 Riwayat: tiap commit = potret + penunjuk ke commit sebelumnya
   A <-- B <-- C <-- D        <- HEAD (cabang main)
```

### l. Terminologi

| Istilah | Arti |
| --- | --- |
| Repositori | Folder beserta riwayatnya (`.git`) |
| Working tree | File yang sedang Anda edit |
| Staging area (index) | Daftar perubahan yang akan masuk commit berikutnya |
| Commit | Satu potret riwayat dengan pesan dan penulis |
| Hash | Sidik jari unik commit |
| HEAD | Commit tempat Anda berada |
| Branch (cabang) | Penunjuk bergerak ke ujung satu jalur riwayat |
| Tracked / untracked | Dilacak / belum dilacak git |
| Hunk | Satu blok selisih pada diff |

### m. Tips dan praktik terbaik

- Jalankan `git status` sebelum dan sesudah setiap langkah, sampai menjadi refleks.
- Commit kecil dan sering; satu commit satu maksud.
- Selalu `git diff --staged` sebelum commit untuk memastikan hanya yang dimaksud yang masuk.
- Mulai dari proyek pertama: `git init` dan `.gitignore` sebelum menulis kode.

### n. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `Please tell me who you are` / `unable to auto-detect email address` | Identitas belum diatur | Jalankan `git config --global user.name` dan `user.email` |
| `nothing added to commit but untracked files present` | Lupa `git add` | `git add <file>`, lalu commit |
| Muncul editor aneh saat commit | Tanpa `-m` dan editor bawaan vim | Pakai `-m`, atau atur `core.editor` |
| Folder `build/` ikut tercatat | `.gitignore` belum ada | Buat `.gitignore`; bila sudah terlanjur, `git rm -r --cached build` |
| Perubahan hilang setelah `restore` | `restore` membuang perubahan belum disimpan | Commit dulu sebelum bereksperimen |
| `fatal: not a git repository` | Bukan di dalam repositori | `pwd`, `cd` ke akar proyek, atau `git init` |

### o. Hubungan dengan modul lain

Prasyarat untuk semua proyek (Bagian C), Modul 0.2 (`build/` di `.gitignore`), 8.4 (disiplin kualitas), 13.4 (rekayasa perangkat lunak), dan 14.6 (membaca riwayat proyek asing).

### p. Latihan dan cek pemahaman

**Latihan 15 menit** (dari kurikulum, dilengkapi): atur identitas; di `qt-learning`, `git init`; buat `catatan.md` dan commit; ubah satu baris; lihat `git diff`; commit lagi; lalu ubah file sekali lagi, `git restore`, dan pastikan perubahan hilang. Akhiri dengan `git log --oneline`.

**Cek pemahaman.** (1) Apa bedanya `git diff` dan `git diff --staged`? (2) Mengapa `git revert` lebih aman daripada `git reset --hard`? (3) Mengapa `build/` perlu masuk `.gitignore`?

### q. Referensi

- [Pro Git: Git Basics](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository)
- [git config](https://git-scm.com/docs/git-config) · [git init](https://git-scm.com/docs/git-init) · [git add](https://git-scm.com/docs/git-add) · [git commit](https://git-scm.com/docs/git-commit) · [git diff](https://git-scm.com/docs/git-diff) · [git log](https://git-scm.com/docs/git-log) · [git restore](https://git-scm.com/docs/git-restore) · [git revert](https://git-scm.com/docs/git-revert) · [gitignore](https://git-scm.com/docs/gitignore)
- [Arch Wiki: Git](https://wiki.archlinux.org/title/Git)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [lazygit](https://github.com/jesseduffield/lazygit) · [tig](https://jonas.github.io/tig/)

---

## 0.0.7 Membaca pesan error

*Semangat: pesan error adalah petunjuk yang jujur — baca sampai habis, dan ia menunjukkan jalannya.*

**Daftar isi 0.0.7:** a. Deskripsi dan peran · b. Konsep: anatomi pesan · c. Metode lima langkah · d. Contoh nyata dari lima alat · e. Kamus pesan umum · f. Alat bantu membaca · g. Opsi lain untuk menggali lebih dalam · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Keterampilan terpenting pemula bukan menghafal sintaks, melainkan membaca keluhan komputer dengan tenang. Hampir setiap kebuntuan di Fase 1–14 akan tampak sebagai sebuah pesan; yang membedakan pemula dan ahli adalah kecepatan memahaminya.

### b. Konsep: anatomi pesan

Pesan yang baik biasanya memuat empat bagian: **lokasi** (`file:baris:kolom`), **tingkat** (*error* menghentikan, *warning* memperingatkan, *note* menambah keterangan), **kalimat pesan**, dan kadang **konteks** (potongan baris dengan penanda `^`). Dua fakta penting: **error pertama biasanya penyebab**, sedangkan error berikutnya sering akibat berantai; dan pesan ditulis oleh manusia untuk manusia, jadi baca secara harfiah.

Jenis kegagalan, dari yang paling mudah ke paling sulit: kesalahan *sintaks* (tanda baca, kurung), nama *tidak ditemukan* (salah eja, belum diimpor), *tipe/nilai* salah, kegagalan *lingkungan* (berkas, modul, izin, driver), dan kesalahan *logika* (tidak ada pesan sama sekali; Anda perlu debugging, Modul 12.1).

### c. Metode lima langkah

1. **Baca dari atas.** Cari error pertama, bukan yang terakhir.
2. **Temukan lokasi.** Buka `file:baris:kolom` (di editor: `nvim +6 Main.qml`).
3. **Baca kalimatnya harfiah.** Perhatikan kata kunci: *not found*, *not defined*, *Cannot assign*, *Permission denied*.
4. **Ubah satu hal, jalankan ulang.** Mengubah banyak hal sekaligus menghilangkan bukti.
5. **Bila buntu, reduksi.** Kecilkan masalah menjadi contoh minimal; bila bertanya ke orang lain, sertakan pesan persis (tanpa data pribadi) dan versi Qt.

### d. Contoh nyata dari lima alat

Redaksi tepatnya dapat sedikit berbeda antar versi; polanya yang penting.

```text
$ qmll Main.qml
bash: qmll: command not found

$ gcc halo.c
halo.c:5:5: error: implicit declaration of function 'prinf'

$ qml Main.qml
file:///home/anda/qt-learning/Main.qml:6:5: Cannot assign to non-existent property "colr"

$ qml Main.qml
file:///home/anda/qt-learning/Main.qml:9: ReferenceError: lebar is not defined

$ git status
fatal: not a git repository (or any of the parent directories): .git
```

| Pesan | Dibaca sebagai | Langkah pertama |
| --- | --- | --- |
| `bash: qmll: command not found` (exit 127) | Shell tidak menemukan program bernama itu | Periksa ejaan; `command -v qml`; periksa `$PATH`; mungkin paket belum terpasang |
| `error: implicit declaration of function 'prinf'` | Kompiler tidak mengenal nama itu | Salah eja (`printf`) atau lupa `#include` |
| `Cannot assign to non-existent property "colr"` | Objek tidak punya properti itu | Salah eja `color`; cek dokumentasi tipe |
| `ReferenceError: lebar is not defined` | JavaScript tidak menemukan nama itu pada scope | Nama salah, atau perlu `id.` / `parent.` di depannya |
| `module "X" is not installed` | Engine tidak menemukan modul yang diimpor | Ejaan import; paket Qt belum terpasang; `QML_IMPORT_TRACE=1` |
| `Permission denied` (exit 126) | Ada, tetapi tidak boleh | `ls -l`; lihat 0.0.5 |
| `No such file or directory` | Path salah atau berkas tidak ada | `pwd`, `ls`, periksa path relatif |
| `fatal: not a git repository` | Anda di luar repositori | `pwd`; `cd` ke akar proyek atau `git init` |
| `undefined reference to ...` | Tahap *linker* tidak menemukan fungsi | Pustaka belum ditautkan (`target_link_libraries`, Modul 0.2) |

Untuk CMake, pesan berbentuk `CMake Error at CMakeLists.txt:5 (find_package):` diikuti penjelasan. Lokasi ada di baris pertama; sebabnya sering berupa paket yang tidak ditemukan.

### e. Alat bantu membaca

```bash
$ cmake --build build 2>&1 | less
$ cmake --build build &> build.log
$ grep -n -m1 -B2 -A6 'error' build.log
$ echo $?
```

- `2>&1 | less` — gabungkan stderr, lalu gulir di pager (lihat 0.0.4).
- `&> build.log` — simpan semua keluaran untuk dibaca atau dikirim.
- `grep -n -m1 -B2 -A6 'error'` — tampilkan **kemunculan pertama** (`-m1`) kata *error* dengan nomor baris (`-n`), dua baris sebelumnya (`-B2`) dan enam baris sesudahnya (`-A6`).
- `echo $?` — kode keluar perintah terakhir; 0 berarti sukses.

### f. Opsi lain untuk menggali lebih dalam

| Kebutuhan | Perintah | Kegunaan |
| --- | --- | --- |
| Lihat perintah build lengkap | `cmake --build build --verbose` atau `ninja -v` | Menampilkan baris kompilasi sebenarnya |
| Berkas apa yang dicari program | `strace -f -e trace=openat qml Main.qml` | Menunjukkan path yang dicoba dibuka (paket `strace`) |
| Pustaka apa yang dibutuhkan | `ldd ./build/hello` | Menampilkan pustaka dinamis yang gagal ditemukan |
| Plugin dan modul Qt | `QT_DEBUG_PLUGINS=1`, `QML_IMPORT_TRACE=1` | Jejak pemuatan (Modul 0.3) |
| Analisis statis QML | `qmllint Main.qml` | Menangkap banyak galat sebelum dijalankan |

### g. Visual

```
 Error muncul
    |
    v
 Baca dari ATAS: error pertama
    |
    v
 Ada file:baris:kolom? --ya--> buka lokasinya (nvim +BARIS file)
    | tidak
    v
 Kata kunci pesan --> hipotesis --> ubah SATU hal --> jalankan ulang
    |
    +-- sembuh? --> commit (0.0.6)
    +-- belum?  --> reduksi ke contoh minimal --> dokumentasi / cari
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Error / warning / note | Kegagalan / peringatan / catatan tambahan |
| Diagnostik | Istilah umum untuk pesan dari kompiler atau alat analisis |
| Compile-time / link-time / run-time | Terdeteksi saat kompilasi / penautan / berjalan |
| Stack trace | Daftar pemanggilan fungsi saat kegagalan terjadi |
| Exit code | Angka hasil akhir proses |
| Contoh minimal (MRE) | Versi sekecil mungkin yang masih memunculkan masalah |

### i. Tips dan praktik terbaik

- Jalankan `qmllint` sebelum `qml`; ia menangkap salah eja properti dan nama tak dikenal tanpa menjalankan aplikasi.
- Simpan log lengkap ke file sebelum mengubah apa pun.
- Sebelum membagikan log secara daring, hapus nama pengguna, nama host, dan path pribadi (prinsip anonimitas).
- Bila pesan tampak mustahil, periksa asumsi lingkungan: shell yang sama, folder yang sama, versi yang sama.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Mengejar error terakhir | Error awal menyebabkan rentetan | Selalu mulai dari yang pertama |
| Memperbaiki lima hal sekaligus | Tidak tahu mana yang berpengaruh | Satu perubahan per percobaan; commit tiap keberhasilan |
| Mengabaikan warning | Warning hari ini menjadi bug esok | Bersihkan sampai nol |
| Langsung `sudo` saat `Permission denied` | Menutupi, bukan memahami | Baca izin dulu (0.0.5) |
| Menyalin pesan sebagian ke pencarian | Konteks hilang | Salin pesan penuh dengan versi Qt |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 0.3 (diagnosa lingkungan), 1.1 (membaca galat sintaks QML), 8.4 dan 12.2 (`qmllint`), 12.1 (debugging), dan 14.6 (menelusuri proyek asing).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat lima kesalahan sengaja satu per satu dan catat pesan serta perbaikannya: (1) ketik `qmll Main.qml`; (2) salah eja `colr` di sebuah `Rectangle`; (3) tulis `import QtQuik`; (4) hapus satu kurung kurawal penutup; (5) jalankan `git status` di luar repositori.

**Cek pemahaman.** (1) Mengapa kita membaca error dari atas? (2) Apa beda `command not found` dan `Permission denied`? (3) Apa fungsi `grep -m1 -B2 -A6`?

### m. Referensi

- [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- [Arch Wiki: General troubleshooting](https://wiki.archlinux.org/title/General_troubleshooting)
- [GCC: Diagnostic Message Formatting](https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Message-Formatting-Options.html)
- [Stack Overflow: Minimal reproducible example](https://stackoverflow.com/help/minimal-reproducible-example)

---

## 0.0.8 Mencari bantuan sendiri dan editor modal \[TAMBAHAN\]

**Mengapa ditambahkan:** Bagian 4 kurikulum menyatakan seluruh materi bisa dikerjakan dari terminal dan editor modal, tetapi tidak ada pengantar cara membaca manual atau memakai editor. Tanpa keduanya, Fase 1 (menulis `Main.qml`) terhenti pada hal teknis.

*Semangat: yang belajar memancing tidak pernah kelaparan.*

**Daftar isi 0.0.8:** a. Deskripsi dan peran · b. Konsep: bantuan berlapis · c. Sumber bantuan di terminal · d. Editor modal: Vim/Neovim · e. Editor lain dan `$EDITOR` · f. Visual · g. Terminologi · h. Tips · i. Kesalahan umum · j. Hubungan · k. Latihan dan cek · l. Referensi

### a. Deskripsi dan peran

Dua keterampilan yang membuat Anda mandiri: menemukan jawaban dari alat itu sendiri, dan menyunting teks dengan keyboard secepat berpikir.

### b. Konsep: bantuan berlapis

Urutan bertanya yang sehat, dari yang tercepat dan terdekat ke yang terluas: **`--help`** (ringkas, di alat itu sendiri) → **`man`** (lengkap) → **Arch Wiki** → **dokumentasi resmi** (Qt) → **komunitas**. Semakin dekat sumbernya dengan versi yang terpasang, semakin kecil risiko salah versi.

### c. Sumber bantuan di terminal

```bash
$ git --help
$ man grep
$ man 5 passwd
$ man -k permission
$ type -a ls
$ pacman -Qi qt6-declarative
$ pacman -Ql qt6-declarative | grep '/bin/'
$ pacman -Qo "$(command -v qml)"
```

| Bagian | Arti |
| --- | --- |
| `--help` / `-h` | Ringkasan opsi; hampir semua alat menyediakan salah satunya. |
| `man grep` | Buka halaman manual di pager: `j`/`k` atau panah untuk gulir, `/kata` untuk mencari, `n` hasil berikutnya, `q` keluar. |
| `man 5 passwd` | Pilih **seksi** manual: 1 perintah, 5 format berkas, 7 konsep, 8 administrasi. |
| `man -k kata` | Cari halaman berdasarkan kata kunci (sama dengan `apropos`); memerlukan indeks `mandb`. |
| `type -a ls` | Tunjukkan semua arti nama `ls`: alias, fungsi, atau program. |
| `pacman -Qi paket` | Informasi paket terpasang: versi, dependensi, ukuran. |
| `pacman -Ql paket` | Daftar berkas milik paket; disaring `grep '/bin/'` menemukan nama executable sebenarnya (ini cara Bagian 4 menemukan nama `qml`). |
| `pacman -Qo path` | Paket mana yang memiliki berkas itu. |

Pelengkap: paket `tealdeer` (perintah `tldr`) memberi contoh pendek yang praktis.

### d. Editor modal: Vim/Neovim

Editor modal memisahkan **mode**: Anda tidak selalu mengetik; sering Anda *memberi perintah penyuntingan*. Itulah sumber kecepatannya, dan sumber kebingungan awal. Perintahnya berupa **kata kerja + objek** yang bisa digabung (`d` hapus + `w` kata = hapus satu kata; `ci"` ubah isi dalam tanda kutip).

```bash
$ vimtutor
$ nvim Main.qml
```

| Mode / tombol | Fungsi |
| --- | --- |
| Normal (awal) | Navigasi dan perintah; kembali ke sini dengan `Esc` |
| `i` / `a` / `o` | Masuk Insert: sebelum kursor / sesudah kursor / baris baru di bawah |
| `h` `j` `k` `l` | Kiri, bawah, atas, kanan |
| `w` `b` | Maju / mundur satu kata |
| `0` `$` | Awal / akhir baris |
| `gg` `G` | Awal / akhir berkas |
| `:6` lalu Enter | Lompat ke baris 6 |
| `dd` / `yy` / `p` | Hapus baris / salin baris / tempel |
| `u` / `Ctrl+r` | Urungkan / ulangi |
| `/kata` lalu `n` | Cari dan lanjut ke hasil berikutnya |
| `:%s/lama/baru/g` | Ganti semua `lama` menjadi `baru` |
| `:w` / `:q` / `:wq` / `:q!` | Simpan / keluar / simpan dan keluar / keluar tanpa menyimpan |

Paket: ⚠ `sudo pacman -S neovim` (atau `vim`). `vimtutor` adalah tutorial interaktif 30 menit; kerjakan sekali penuh.

### e. Editor lain dan `$EDITOR`

| Editor | Karakter | Keluar/simpan |
| --- | --- | --- |
| `nano` | Paling sederhana, petunjuk tampil di bawah | Ctrl+O simpan, Ctrl+X keluar |
| `micro` | Pintasan ala GUI modern, mudah dipelajari | Ctrl+S, Ctrl+Q |
| `helix` (`hx`) | Modal dengan pola *pilih dulu, lalu aksi*; dukungan LSP bawaan | `:w`, `:q` |
| `emacs -nw` | Sangat ekstensibel, berbasis pintasan Ctrl/Alt | Ctrl+X Ctrl+S, Ctrl+X Ctrl+C |

Atur editor bawaan untuk alat lain (git, `sudoedit`, `crontab -e`):

```bash
$ export EDITOR=nvim
$ export VISUAL=nvim
$ git config --global core.editor nvim
```

Tulis `export` di `~/.bashrc` agar permanen (0.0.3).

### f. Visual

```
 BANTUAN BERLAPIS (dari dekat ke luas)
  --help  -->  man  -->  Arch Wiki  -->  doc.qt.io  -->  komunitas

 MODE VIM
            i / a / o                    :
  NORMAL  ------------>  INSERT    NORMAL ------> COMMAND (:w :q)
    ^  <------ Esc ------+            ^  <-- Enter / Esc --+
    |  v / V
    v
  VISUAL (memilih teks)
```

### g. Terminologi

| Istilah | Arti |
| --- | --- |
| Manual page / seksi | Dokumen bantuan per perintah / pengelompokan nomor 1–8 |
| Pager | Penampil berhalaman (`less`) |
| Editor modal | Editor dengan beberapa mode berbeda |
| Buffer | Isi berkas yang dimuat editor di memori |
| LSP | *Language Server Protocol*; bahasa-ke-editor, dipakai `qmlls` (Modul 12.2) |
| `$EDITOR` | Variabel yang menyatakan editor bawaan |

### h. Tips dan praktik terbaik

- Biasakan membaca satu halaman `man` utuh sekali sebulan; Anda akan terkejut oleh fitur yang terlewat.
- Bangun konfigurasi editor sedikit demi sedikit; hindari menyalin konfigurasi raksasa yang tidak Anda pahami (kontrol dan keamanan).
- Pakai `sudoedit` untuk berkas sistem (0.0.5).

### i. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| “Terjebak” di Vim | Tidak tahu cara keluar | Tekan `Esc`, ketik `:q!` lalu Enter |
| Teks acak berubah saat mengetik | Mengetik di mode Normal | Tekan `i` dulu; periksa indikator mode |
| Peringatan *swap file exists* | Sesi sebelumnya tertutup tidak wajar | Pulihkan atau hapus file `.swp` setelah memeriksa |
| `man` tidak menemukan halaman | Paket manual belum terpasang | Pasang `man-db` dan `man-pages` |

### j. Hubungan dengan modul lain

Prasyarat untuk Fase 1 (menulis QML), 0.0.6 (editor pesan commit), 12.2 (`qmlformat` dan `qmlls` di editor).

### k. Latihan dan cek pemahaman

**Latihan 15 menit.** Kerjakan bab 1–2 `vimtutor`. Lalu buat `Main.qml` berisi contoh `Rectangle` dari 0.0.2 memakai `nvim`; simpan, lompat ke baris 6, cari kata `color`, dan ganti nilainya dengan `:%s`. Gunakan `pacman -Ql qt6-declarative` untuk menemukan nama executable `qml` di mesin Anda.

**Cek pemahaman.** (1) Apa urutan pencarian bantuan yang sehat? (2) Bagaimana keluar dari Vim tanpa menyimpan? (3) Apa fungsi `$EDITOR`?

### l. Referensi

- [Neovim: dokumentasi pengguna](https://neovim.io/doc/user/) · [Arch Wiki: Vim](https://wiki.archlinux.org/title/Vim) · [Arch Wiki: Neovim](https://wiki.archlinux.org/title/Neovim)
- [Arch Wiki: Man page](https://wiki.archlinux.org/title/Man_page)
- [GNU nano](https://www.nano-editor.org/docs.php) · [Helix](https://docs.helix-editor.com/) · [tldr](https://tldr.sh/)

---

## 0.0.9 Kebiasaan aman: sumber paket dan skrip \[TAMBAHAN\]

**Mengapa ditambahkan:** Bagian 4 kurikulum meminta `sudo pacman -S ...`, dan Anda baru saja belajar sudo di 0.0.5. Sebelum memasang apa pun, tanamkan kebiasaan memverifikasi. Ini juga fondasi Modul 13.1 (keamanan) dan 14.3 (plugin), serta sesuai prinsip isolasi dan kontrol.

*Semangat: disiplin kecil hari ini adalah benteng terbesar besok.*

**Daftar isi 0.0.9:** a. Deskripsi dan peran · b. Konsep: rantai kepercayaan · c. Memeriksa paket sebelum memasang (pacman) · d. AUR: baca sebelum bangun · e. Skrip unduhan: jangan `curl | sh` · f. Isolasi · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Setiap program yang Anda jalankan berjalan dengan **hak Anda**: ia bisa membaca `~/.ssh`, `~/.config`, dan seluruh proyek Anda. Karena itu pertanyaan “dari mana ini datang dan siapa yang menjaminnya?” perlu diajukan sebelum perintah dijalankan.

### b. Konsep: rantai kepercayaan

Perangkat lunak sampai ke Anda lewat rantai: penulis asli (*upstream*) → maintainer paket → mirror → `pacman` (memeriksa tanda tangan) → Anda. Setiap mata rantai adalah titik kepercayaan sekaligus titik serangan (*supply chain*). Model ancaman sederhananya: *apa yang bisa dilakukan program ini dengan hak saya, dan siapa yang bisa mengubahnya di tengah jalan?* Jawabannya melahirkan empat kebiasaan: **sumber resmi dulu**, **verifikasi**, **baca sebelum jalankan**, dan **hak serta isolasi minimal**.

Kaitan dengan Qt: QML adalah kode yang *dieksekusi* (JavaScript dan pemuatan plugin). Jangan menjalankan `qml` pada berkas yang tidak Anda percayai, dan jangan menambah folder tak dikenal ke `QML_IMPORT_PATH` (dibahas di Modul 13.1).

### c. Memeriksa paket sebelum memasang (pacman)

```bash
$ pacman -Si qt6-declarative
$ pacman -Qi qt6-declarative
$ pacman -Ql qt6-declarative | head
$ pacman -Qk qt6-declarative
$ sudo pacman -Syu
```

| Bagian | Arti |
| --- | --- |
| `-Si` | Informasi paket dari repositori (versi, dependensi, ukuran) **sebelum** dipasang. |
| `-Qi` | Informasi paket yang sudah terpasang. |
| `-Ql` | Daftar berkas milik paket terpasang. |
| `-Qk` | Periksa integritas berkas paket terpasang (apakah ada yang hilang atau berubah). |
| `sudo pacman -Syu` | ⚠ Sinkronkan basis data dan perbarui **seluruh** sistem. Di Arch, jangan pernah memakai `-Sy` lalu memasang paket tanpa `u`: pembaruan parsial tidak didukung dan dapat merusak sistem. |

Paket dari repositori resmi diverifikasi tanda tangannya oleh `pacman` memakai keyring; jangan mematikan pemeriksaan tanda tangan.

### d. AUR: baca sebelum bangun

AUR (*Arch User Repository*) berisi resep (`PKGBUILD`) yang ditulis pengguna, **bukan** paket jadi yang diperiksa tim Arch. Membangunnya menjalankan skrip dengan hak Anda.

```bash
$ git clone https://aur.archlinux.org/nama-paket.git
$ cd nama-paket
$ less PKGBUILD
$ makepkg --printsrcinfo | head -20
```

- `git clone ...` — unduh resep ke folder lokal. Mengunduh belum menjalankan apa pun.
- `less PKGBUILD` — **baca** semua: dari mana sumbernya (`source=`), apakah ada checksum (`sha256sums=`), dan apakah ada perintah aneh (unduhan tambahan, `curl`, `sudo`).
- `makepkg --printsrcinfo` — cetak metadata resep tanpa membangunnya.
- Jangan menjalankan `makepkg` sebagai root (alat ini menolaknya); itu pagar yang disengaja.

### e. Skrip unduhan: jangan `curl | sh`

Pola `curl URL | sh` (apalagi `| sudo sh`) menjalankan kode yang belum pernah Anda lihat. Ganti dengan empat langkah:

```bash
$ curl -fsSLo pasang.sh https://contoh.example/pasang.sh
$ less pasang.sh
$ sha256sum pasang.sh
$ bash pasang.sh
```

| Bagian | Arti |
| --- | --- |
| `curl -fsSLo pasang.sh URL` | Unduh ke berkas. `-f` gagal pada error HTTP, `-s` senyap, `-S` tetap tampilkan galat, `-L` ikuti pengalihan, `-o` nama berkas keluaran. |
| `less pasang.sh` | Baca dulu. |
| `sha256sum` | Hitung sidik jari berkas untuk dibandingkan dengan nilai resmi dari penerbit (dari kanal terpisah). |
| `bash pasang.sh` | Baru dijalankan; **tanpa sudo** bila memungkinkan. |

### f. Isolasi

Untuk sesuatu yang belum bisa dipercaya penuh, kurangi akibatnya: jalankan di folder khusus, di pengguna terpisah, di *sandbox*, kontainer, atau mesin virtual. Pilihan dibahas di bawah; di tahap ini cukup mengenali bahwa pilihan itu ada dan kapan dipakai.

### g. Opsi lain

| Kebutuhan | Alat | Catatan |
| --- | --- | --- |
| Sandbox ringan | `bubblewrap` (`bwrap`), `firejail` | Membatasi berkas dan jaringan yang terlihat oleh proses |
| Kontainer | `podman` | Lingkungan terpisah tanpa daemon berhak root |
| Lingkungan sistem terpisah | `systemd-nspawn` | Menjalankan sistem terpisah di folder |
| Mesin virtual | `qemu` + KVM | Isolasi terkuat; berat |
| Paket Python | `python -m venv` | Hindari `sudo pip install` ke sistem |
| Verifikasi tanda tangan | `gpg --verify` | Memeriksa tanda tangan berkas unduhan |

### h. Visual

```
 penulis (upstream) --> maintainer --> mirror --> pacman (cek tanda tangan)
                                                      |
                                                      v
                       program berjalan dengan HAK ANDA
                                                      |
                                                      v
                 data Anda: ~/.ssh   ~/.config   proyek   riwayat git

 Makin ke kanan, makin besar akibat bila ada mata rantai yang disusupi.
 Pagar: sumber resmi + verifikasi + baca dulu + hak minimal + isolasi.
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Repositori resmi (`core`, `extra`) | Paket yang dikelola dan ditandatangani tim Arch |
| AUR | Kumpulan resep komunitas, tanpa jaminan |
| `PKGBUILD` | Skrip resep pembuatan paket |
| `makepkg` | Alat membangun paket dari `PKGBUILD` |
| Checksum | Sidik jari berkas untuk memeriksa keutuhan |
| Tanda tangan GPG | Bukti kriptografis siapa yang menerbitkan |
| Supply chain | Rantai penyampaian perangkat lunak ke pengguna |
| Sandbox | Ruang terbatas untuk menjalankan program |
| Pembaruan parsial | Memasang paket tanpa memperbarui sistem; tidak didukung di Arch |

### j. Tips dan praktik terbaik

- Dahulukan paket repositori resmi; AUR hanya bila perlu, dan setiap pembaruan PKGBUILD dibaca ulang.
- Pasang Qt dari paket sistem (Bagian 4) sampai Anda paham alasan memakai yang lain; mencampur sumber membuat versi bentrok.
- Perbarui sistem secara berkala dan menyeluruh (`pacman -Syu`) daripada menunda berbulan-bulan.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Sistem rusak setelah memasang paket | `-Sy` lalu `-S` tanpa `u` | Selalu `-Syu` |
| Memasang AUR tanpa membaca | Percaya buta pada popularitas | Baca `PKGBUILD` dan sumber sebelum membangun |
| `curl ... \| sudo bash` | Menjalankan kode tak dikenal dengan hak root | Unduh, baca, verifikasi, jalankan tanpa root |
| `sudo pip install` | Mengotori paket sistem | Pakai `venv` |
| Qt dari installer lain bercampur paket sistem | Dua versi Qt di jalur berbeda | Pilih satu sumber dan konsisten (cek dengan `QT_DEBUG_PLUGINS=1`) |

### l. Hubungan dengan modul lain

Prasyarat untuk Bagian 4 (pemasangan), 0.0.5 (sudo), 13.1 (keamanan aplikasi), 13.3 (distribusi paket), dan 14.3 (plugin: kepercayaan terhadap kode yang dimuat).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Untuk `qt6-declarative`, jalankan `-Si`, `-Qi`, `-Ql`, `-Qk` dan catat ukuran, dependensi, serta lokasi executable `qml`. Lalu pilih satu paket AUR kecil, unduh resepnya **tanpa membangun**, dan tuliskan tiga hal yang Anda periksa di `PKGBUILD`.

**Cek pemahaman.** (1) Mengapa `-Sy` tanpa `u` berbahaya di Arch? (2) Apa perbedaan paket repositori resmi dan paket AUR dari sisi jaminan? (3) Mengapa `curl | sh` buruk dan apa gantinya?

### n. Referensi

- [Arch Wiki: pacman](https://wiki.archlinux.org/title/Pacman) · [Package signing](https://wiki.archlinux.org/title/Pacman/Package_signing)
- [Arch Wiki: AUR](https://wiki.archlinux.org/title/Arch_User_Repository) · [PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) · [makepkg](https://wiki.archlinux.org/title/Makepkg)
- [Arch Wiki: Security](https://wiki.archlinux.org/title/Security) · [System maintenance](https://wiki.archlinux.org/title/System_maintenance)
- [Arch Wiki: Bubblewrap](https://wiki.archlinux.org/title/Bubblewrap)
- [curl: manual](https://curl.se/docs/manpage.html)

---

## 4. Penutup Modul 0.0

**Daftar isi bagian ini:** 4.1 Peta konsep · 4.2 Latihan terpadu · 4.3 Cek pemahaman modul · 4.4 Hubungan ke modul berikutnya · 4.5 Pembaruan yang diusulkan untuk kurikulum · 4.6 Status dan langkah berikutnya

### 4.1 Peta konsep

```
                    0.0.1 Program, compiler, interpreter
                                   |
                    0.0.2 Event loop  (mengapa UI macet)
                                   |
   0.0.3 Terminal ---> 0.0.4 Pipe/redirect ---> 0.0.5 Izin & sudo
            |                      |                    |
            +----------+-----------+--------------------+
                       v
               0.0.6 Git  ----->  0.0.7 Membaca error
                       |                   |
                       v                   v
        0.0.8 Bantuan & editor ----> 0.0.9 Kebiasaan aman
                                   |
                                   v
                       Modul 0.1 -> 0.2 -> 0.3
```

### 4.2 Latihan terpadu

Di folder `~/Development/qt-learning` (15–30 menit): (1) atur identitas git dan `git init`; (2) buat `.gitignore` dengan `build/`; (3) simpan contoh Contoh 1 dari 0.0.2 sebagai `Main.qml` dengan editor modal; (4) jalankan `qmllint Main.qml` dan `qml Main.qml`, simpan semua keluaran ke `log.txt` dengan `&>`; (5) sengaja salah eja `color` menjadi `colr`, baca pesannya, perbaiki; (6) `git diff`, lalu commit dengan pesan yang bermakna; (7) tulis di `catatan.md` tiga perintah baru yang Anda pelajari.

### 4.3 Cek pemahaman modul

1. Mengapa program C harus dikompilasi ulang, sedangkan skrip Python tidak?
2. Mengapa jendela tampak macet saat satu handler berjalan lama, dan bagaimana memecahnya?
3. Apa beda variabel shell dan environment? Tulis perintah yang membuktikannya.
4. Mengapa `2>&1` penting pada `QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | head -50`?
5. Apa arti `rwxr-x---` dalam oktal, dan siapa yang bisa menjalankan berkasnya?
6. Apa perbedaan `git diff` dan `git diff --staged`?
7. Sebutkan tiga hal yang Anda periksa sebelum memasang paket AUR.

### 4.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 0.0 |
| --- | --- |
| 0.1 Ekosistem | Perintah `qml`, membaca dokumentasi, konsep deklaratif vs imperatif (0.0.1) |
| 0.2 Build pertama | Folder build, `.gitignore`, izin, kompilasi (0.0.1, 0.0.5, 0.0.6) |
| 0.3 Runtime & diagnosa | Variabel lingkungan, pipe, redirect, pembacaan error (0.0.3, 0.0.4, 0.0.7) |
| Fase 1 | Editor modal, `qmllint`, git, event loop sebagai model mental |

### 4.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda (blok untuk Modul 0.0). Bagian lain tidak berubah.

**Deskripsi.** Mengajarkan lima konsep inti yang biasanya dianggap sudah dikenal (program, compiler dan interpreter, event loop, terminal, git) ditambah empat keterampilan pendukung (pipe dan redirect, izin dan sudo, bantuan dan editor modal, kebiasaan aman).

**Daftar isi.** 0.0.1 Program, compiler, interpreter · 0.0.2 Event loop dan mengapa UI bisa macet · 0.0.3 Terminal: path, proses, environment · 0.0.4 Pipe, redirect, dan penyaring teks · 0.0.5 Izin file, pengguna, dan sudo · 0.0.6 Git minimum: config, init, add, commit, diff, log, restore · 0.0.7 Membaca pesan error · 0.0.8 Mencari bantuan sendiri dan editor modal · 0.0.9 Kebiasaan aman: sumber paket dan skrip

**Kesalahan umum (tambahan).** Commit gagal karena identitas git belum diatur; `sudo` untuk build sehingga folder `build/` milik root; `2>&1` tertukar urutannya; menjalankan `curl | sh`.

**Latihan 15 menit.** Atur identitas git; buat folder `qt-learning`; `git init`; buat `.gitignore` berisi `build/`; buat `catatan.md`; commit; ubah satu baris; lihat `git diff`; commit lagi.

**Estimasi Fase 0.** Jalur B: 1–2 minggu. Jalur A: 2–3 minggu.

### 4.6 Status dan langkah berikutnya

| Bagian | Status |
| --- | --- |
| Audit Fase 0 | Selesai |
| Fase 0 (tingkat fase) | Selesai |
| Modul 0.0 (0.0.1–0.0.9) | **Selesai** |
| Modul 0.1 — Ekosistem Qt, QML, dan Qt Quick | Berikutnya, menunggu konfirmasi |
| Modul 0.2, 0.3 | Setelah 0.1 |

---

## 5. Modul 0.1 — Ekosistem Qt, QML, dan Qt Quick

**Daftar isi bagian ini:** 5.1 Audit Modul 0.1 · 5.2 Deskripsi dan peran · 5.3 Filosofi modul · 5.4 Visual: peta ekosistem · 5.5 Daftar isi sub-bagian yang diperbarui · 5.6 Estimasi waktu · lalu 0.1.1 sampai 0.1.7

### 5.1 Audit Modul 0.1

Diperiksa pada 5 November 2026 terhadap dokumentasi dan blog resmi Qt, serta halaman paket Arch.

**Terverifikasi (tidak perlu diubah):**

- `qmlsc` hanya untuk pelanggan komersial. Dokumentasi Qt Quick Compiler menyebut `qmltc` dan `qmlcachegen` tersedia untuk semua versi Qt, sedangkan `qmlsc` untuk pelanggan komersial.
- Qt 6.12 adalah LTS, dirilis 30 September 2026, dengan pemeliharaan lima tahun.
- Hot reload kini bawaan engine QML di 6.12 dan `qmlpreview` dibangun ulang di atasnya. Ini menutup butir 9 audit Fase 0: klaim Bagian 4 kurikulum benar menurut blog rilis resmi. Perilaku nyatanya tetap diuji di Modul 12.
- Arch menyediakan `qt6-declarative` 6.12.0-2 (dibangun 21 Oktober 2026), sehingga target kurikulum Qt 6.12 sesuai dengan paket distro.

**Perlu dikoreksi atau dilengkapi:**

1. **LTS tidak berarti semua patch terbuka.** Patch LTS lanjutan segera tersedia hanya bagi pelanggan komersial; halaman rilis Qt menandai Qt 6.8.8 sebagai *commercial only*. Terminologi LTS di Modul 0.1 diberi nuansa ini.
2. **Import tanpa nomor versi bersifat opsional, bukan “tidak lagi” dipakai.** Pertanyaan Cek pemahaman nomor 2 diperbaiki dan dibuktikan lewat percobaan (0.1.5).
3. **Lisensi lebih luas dari `qmlsc`.** Pada Qt open source, empat belas modul tersedia di bawah GPLv3, bukan LGPLv3 (antara lain Qt Quick 3D, Qt Graphs, Qt Canvas Painter, Qt Quick Timeline, Qt Lottie Animation, Qt Virtual Keyboard). Ini menentukan apakah aplikasi tertutup boleh didistribusikan. Ditambahkan di 0.1.3.
4. **Janji kompatibilitas dan status modul belum ada.** Qt menjanjikan kompatibilitas source dan binary dalam satu versi mayor, dengan pengecualian modul *Technology Preview*. Ditambahkan di 0.1.2 dan 0.1.4.
5. **Peta paket Arch ke modul Qt belum ada.** Pembelajar tidak tahu paket mana memuat modul apa. Ditambahkan di 0.1.2.
6. **Dua sub-bagian tambahan** agar peta ekosistem utuh: 0.1.6 (Qt Quick dibanding Qt Widgets dan bahasa lain yang memakai Qt) dan 0.1.7 (sumber Qt dan perkakas: paket distro, installer resmi, Qt Creator).
7. **Fakta rilis yang bergerak.** Dukungan standar Qt 6.10 berakhir 7 Oktober 2026 (sudah lewat); Qt 6.11 didukung sampai 17 Maret 2027. Fakta ini dicatat bertanggal di 0.1.4, karena cepat usang.

### 5.2 Deskripsi dan peran dalam kurikulum

Modul ini memetakan seluruh bagian yang akan Anda sentuh: Qt, QML, JavaScript, Qt Quick, Qt Quick Controls, dan C++, beserta lisensi dan siklus rilisnya. Perannya adalah **peta sebelum perjalanan**. Tanpa peta ini, pembelajar sering menyalin kode dari dokumentasi Qt 5, mencampur Widgets dengan Qt Quick, atau mendistribusikan aplikasi dengan lisensi yang tidak cocok.

### 5.3 Filosofi modul

**Lapisan dan pemisahan tugas.** Qt tersusun berlapis: lapisan bawah menyembunyikan perbedaan sistem operasi, lapisan atas menyatakan antarmuka. QML memisahkan *apa yang diinginkan* (deklaratif) dari *bagaimana melakukannya* (imperatif, di JavaScript atau C++). Satu pertanyaan akan menemani seluruh kurikulum: *tugas ini milik lapisan yang mana?*

### 5.4 Visual: peta ekosistem

```
  APLIKASI ANDA
 +-------------------------------------------------------------+
 | QML (deklaratif)  +  JavaScript (imperatif, di dalam QML)   |
 +-------------------------------------------------------------+
 | Qt Quick | Qt Quick Controls | Layouts | Dialogs | 3D | ...  |
 +-------------------------------------------------------------+
 | Qt QML   engine: tipe, binding, signal, modul               |
 +-------------------------------------------------------------+
 | Qt GUI   jendela, input, font, gambar, RHI (grafis)         |
 | Qt Core  QObject, event loop, thread, file, string          |
 +-------------------------------------------------------------+
 | Platform (QPA): Wayland | X11 (xcb) | offscreen | ...       |
 +-------------------------------------------------------------+
 | Linux: kernel, driver GPU (Mesa), compositor                |
 +-------------------------------------------------------------+
   C++ (backend, tipe kustom) menempel pada Qt Core dan Qt QML
```

### 5.5 Daftar isi sub-bagian yang diperbarui

| No. | Judul | Asal |
| --- | --- | --- |
| 0.1.1 | Qt, QML, dan Qt Quick: tiga hal yang berbeda | Asli 0.1.1 |
| 0.1.2 | Modul inti, add-on, status modul, dan peta paket Arch | Asli 0.1.2, diperluas |
| 0.1.3 | Lisensi dan edisi | Asli 0.1.3, diperluas |
| 0.1.4 | Siklus rilis, LTS, dan janji kompatibilitas | Asli 0.1.4, diperluas |
| 0.1.5 | Membaca dokumentasi Qt 6 dan menghindari jebakan Qt 5 | Asli 0.1.5, diperluas |
| 0.1.6 | Qt Quick dibanding Qt Widgets, dan bahasa lain yang memakai Qt | **\[TAMBAHAN\]** |
| 0.1.7 | Sumber Qt dan perkakas: paket distro, installer, Qt Creator | **\[TAMBAHAN\]** |

### 5.6 Estimasi waktu

Jalur A: 8–12 jam; Jalur B: 3–4 jam (0.1.6–0.1.7 dapat dibaca sekilas).

---

## 0.1.1 Qt, QML, dan Qt Quick: tiga hal yang berbeda

*Semangat: nama yang tepat adalah separuh dari pemahaman.*

**Daftar isi 0.1.1:** a. Deskripsi dan peran · b. Konsep dan analogi · c. Fondasi: deklaratif, imperatif, dan meta-object · d. Contoh 1: binding bekerja · e. Contoh 2: tiga cara menjaga satu hubungan · f. Contoh 3: QML bukan JSON dan bukan JavaScript · g. Logika sama di tumpukan lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini membedakan tiga istilah yang sering dipakai bergantian padahal berbeda: **Qt** (kerangka kerja), **QML** (bahasa), dan **Qt Quick** (kumpulan tipe visual). Dua istilah pendamping: **Qt Quick Controls** (kontrol siap pakai) dan **JavaScript** (bahasa skrip di dalam QML). Membedakannya mencegah salah mencari dokumentasi, salah memasang paket, dan salah mengharapkan perilaku.

### b. Konsep dan analogi

**Analogi dapur** (dari kurikulum, dilengkapi): Qt adalah *dapur lengkap* beserta pemasoknya. QML adalah *menu* yang menyatakan hidangan apa yang diinginkan. Qt Quick adalah *daftar bahan dan peralatan visual* yang boleh disebut di menu (piring, nampan, lampu). Qt Quick Controls adalah *hidangan siap saji* (tombol, kolom isian). C++ adalah *koki* yang menguasai teknik sulit. JavaScript adalah *catatan kecil pelayan* untuk kasus khusus. Sebagian besar waktu Anda menulis menu, dan memanggil koki hanya saat perlu.

| Istilah | Jenisnya | Satu kalimat |
| --- | --- | --- |
| Qt | Kerangka kerja (pustaka C++ dan alat) | Menyediakan objek, event, jaringan, berkas, grafis lintas platform |
| QML | Bahasa deklaratif | Menyatakan objek, properti, hubungan antarnilai, dan hierarkinya |
| Qt Quick | Modul tipe visual berbasis QML | Item, input, animasi, model-view, scene graph |
| Qt Quick Controls | Modul kontrol dan style | Button, TextField, ScrollView, dan gaya tampilannya |
| JavaScript | Bahasa imperatif | Langkah-langkah di dalam handler dan fungsi QML |

### c. Fondasi: deklaratif, imperatif, dan meta-object

- **Imperatif** menyatakan *langkah*: “hitung tinggi, simpan, lalu ulangi setiap kali lebar berubah”. **Deklaratif** menyatakan *hubungan*: “tinggi selalu setengah lebar”. Engine yang menjaga hubungan itu tetap benar.
- Hubungan itu bisa dijaga karena objek QML adalah objek Qt (`QObject`) yang punya **properti** dan **signal** pemberitahuan perubahan. Saat sebuah properti berubah, ia memancarkan signal; engine mencatat ekspresi mana yang membaca properti itu dan menghitung ulang bila perlu. Sistem yang menyediakan ini bernama **meta-object system** (dibahas mendalam di Modul 10.2).
- Qt Quick menggambar lewat **scene graph** (Modul 11.1): pohon node yang diteruskan ke GPU lewat lapisan RHI.

### d. Contoh 1: binding bekerja

Simpan sebagai `Main.qml`, jalankan `qml Main.qml`, lalu klik jendela beberapa kali.

```qml
import QtQuick

Item {
    width: 480
    height: 240

    Rectangle {
        id: kartu
        width: 120
        height: width / 2
        color: 'steelblue'

        Text {
            anchors.centerIn: parent
            text: kartu.width + ' x ' + kartu.height
            color: 'white'
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: kartu.width += 40
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `import QtQuick` | Memuat modul Qt Quick; di Qt 6 nomor versi boleh dihilangkan. |
| `Item { ... }` | Objek visual dasar tanpa gambar; di sini menjadi akar dan wadah. |
| `width: 480`, `height: 240` | Properti dengan nilai tetap. |
| `Rectangle { id: kartu ... }` | Objek anak; `id` memberi nama agar bisa dirujuk. |
| `height: width / 2` | **Binding**: ekspresi, bukan perintah. Tinggi akan dihitung ulang setiap lebar berubah. |
| `text: kartu.width + ' x ' + kartu.height` | Binding juga: teks mengikuti dua properti sekaligus. |
| `anchors.centerIn: parent` | Letakkan di tengah induk, juga sebuah hubungan yang dijaga. |
| `MouseArea` | Menangkap klik; `anchors.fill: parent` membuatnya menutupi seluruh `Item`. |
| `onClicked: kartu.width += 40` | Handler imperatif: **satu langkah** yang menambah lebar. Tinggi dan teks ikut berubah tanpa Anda menyentuhnya. |

### e. Contoh 2: tiga cara menjaga satu hubungan

Tujuan sama: tinggi selalu setengah lebar.

```qml
// Cara 1 — deklaratif (disarankan)
Rectangle {
    id: a
    width: 120
    height: width / 2
}

// Cara 2 — imperatif lewat handler perubahan
Rectangle {
    id: b
    width: 120
    height: 60
    onWidthChanged: height = width / 2
}

// Cara 3 — imperatif lewat fungsi yang dipanggil manual
Rectangle {
    id: c
    width: 120
    height: 60
    function sesuaikan() { height = width / 2 }
}
```

| Cara | Kelebihan | Kelemahan |
| --- | --- | --- |
| 1. Binding | Ringkas, selalu benar, engine yang menjaga | Perlu memahami bahwa ia ekspresi |
| 2. `onWidthChanged` | Terlihat eksplisit | Nilai awal harus ditulis dua kali (`60` dan rumus); mudah lupa |
| 3. Fungsi manual | Dikendalikan penuh | Setiap pemanggil wajib ingat memanggilnya; mudah usang |

Peringatan penting: menulis `height = 100` secara imperatif pada properti yang punya binding **memutuskan binding itu**. Ini sumber bug klasik dan dibahas di Modul 3.1. Anda bisa melihatnya dengan `QT_LOGGING_RULES=qt.qml.binding.removal.info=true qml Main.qml`.

### f. Contoh 3: QML bukan JSON dan bukan JavaScript

```qml
// QML
Rectangle {
    id: kotak
    width: 100
    height: width * 2
    color: 'red'
    MouseArea { anchors.fill: parent; onClicked: kotak.color = 'blue' }
}
```

```json
{ "width": 100, "color": "red" }
```

```js
const kotak = { width: 100, color: 'red' }
```

| Ciri | QML | JSON | JavaScript |
| --- | --- | --- | --- |
| Objek bertipe (`Rectangle`) | Ya | Tidak, hanya data | Tidak, objek biasa |
| Nilai berupa hubungan (`width * 2`) | Ya (binding) | Tidak | Tidak (dihitung sekali) |
| Hierarki anak bersarang | Ya | Ya, tetapi tanpa makna tipe | Ya, sebagai data |
| Handler kejadian (`onClicked`) | Ya | Tidak | Lewat pustaka lain |
| Dapat dijalankan sendiri | Ya (lewat engine) | Tidak | Ya (lewat mesin JS) |

### g. Logika sama di tumpukan lain

Untuk membandingkan: “lebar berubah, tinggi mengikuti” di tumpukan lain. Potongan ini hanya ilustrasi; Anda tidak perlu menjalankannya sekarang.

| Tumpukan | Cara menjaga hubungan | Sifat |
| --- | --- | --- |
| QML (Qt Quick) | `height: width / 2` | Deklaratif |
| Qt Widgets (C++) | `connect(slider, &QSlider::valueChanged, this, [=](int w){ kotak->resize(w, w / 2); });` | Imperatif: Anda menulis aksi pada setiap perubahan |
| PySide6 (Python) | `slider.valueChanged.connect(lambda w: kotak.resize(w, w // 2))` | Imperatif, sintaks Python |
| Web (CSS) | `aspect-ratio: 2 / 1;` | Deklaratif, pada ekosistem lain |

### h. Visual

```
  Anda menulis:   height: width / 2
                          |
                          v
  Engine mencatat: "height bergantung pada width"
                          |
  width berubah ----> signal widthChanged ----> hitung ulang height
                                                    |
                                          signal heightChanged ----> teks, layout,
                                                                      gambar ikut menyesuaikan
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Framework | Kerangka kerja: pustaka besar yang mengatur alur aplikasi |
| Modul | Paket pustaka Qt yang dimuat dengan `import` (QML) atau `find_package` (CMake) |
| Tipe / objek | Jenis dan instans di QML, misalnya `Rectangle` dan `kartu` |
| Properti | Nilai bernama milik objek (`width`, `color`) |
| Binding | Ekspresi yang menjadi nilai properti dan dihitung ulang otomatis |
| Signal / handler | Pemberitahuan kejadian / kode yang menanggapinya (`onClicked`) |
| `id` | Nama untuk merujuk objek dari dalam dokumen yang sama |
| Item | Tipe visual dasar Qt Quick |
| Deklaratif / imperatif | Menyatakan hubungan / menyatakan langkah |

### j. Tips dan praktik terbaik

- Gunakan nama yang tepat saat mencari: “QML Rectangle”, bukan “Qt Rectangle” (itu bisa berarti `QRect` di C++).
- Dahulukan binding; tulis handler imperatif hanya untuk reaksi atas kejadian (klik, data tiba).
- Beri `id` seperlunya dan pendek; banyak `id` pada akar berarti struktur belum dipikirkan.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Menganggap QML sama dengan JavaScript | Sintaks tampak mirip | Ingat: QML punya tipe, hierarki, dan binding; JavaScript hanya hidup di ekspresi dan handler |
| Mencampur dokumentasi Qt Widgets dan Qt Quick | Nama kelas mirip (`QPushButton` dan `Button`) | Periksa modul pada halaman (QtWidgets atau QtQuick) |
| Binding “menghilang” setelah klik | Penugasan imperatif memutus binding | Pakai `Binding {}` atau `Qt.binding()` (Modul 3.1) |
| Menulis `window.width` seperti di peramban | Mengira ini web | QML tidak punya DOM atau `window` peramban (Fase B0) |

### l. Hubungan dengan modul lain

Prasyarat untuk 0.1.2 (modul-modul yang menyusun tumpukan ini), Fase 1 (sintaks QML), Fase 2 (JavaScript di dalam QML), Modul 3.1 (property binding mendalam), dan Modul 10.2 (meta-object system).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** (dari kurikulum, dilengkapi) Ubah `height` menjadi dua pertiga lebar, lalu jelaskan dengan kata sendiri mengapa Anda tidak perlu menghitung ulang di mana pun. Tambahkan satu `Text` kedua yang menampilkan luas (`width * height`). Terakhir, ubah ke Cara 2 dan buktikan bahwa nilai awal harus ditulis dua kali.

**Cek pemahaman.** (1) Mana yang deklaratif: `height: width / 2`, atau `onWidthChanged: height = width / 2`? (2) Apa bedanya Qt, QML, dan Qt Quick dalam satu kalimat masing-masing? (3) Apa akibat menulis `kartu.height = 100` di sebuah handler?

### n. Referensi

- [Qt QML](https://doc.qt.io/qt-6/qtqml-index.html) · [Qt Quick](https://doc.qt.io/qt-6/qtquick-index.html) · [QML Applications](https://doc.qt.io/qt-6/qmlapplications.html)
- [QML Syntax Basics](https://doc.qt.io/qt-6/qtqml-syntax-basics.html) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html)
- [The Meta-Object System](https://doc.qt.io/qt-6/metaobjects.html)
- [Wikipedia: Declarative programming](https://en.wikipedia.org/wiki/Declarative_programming) · [Imperative programming](https://en.wikipedia.org/wiki/Imperative_programming)

---

## 0.1.2 Modul inti, add-on, status modul, dan peta paket Arch

*Semangat: yang mengenal perkakasnya bekerja lebih ringan.*

**Daftar isi 0.1.2:** a. Deskripsi dan peran · b. Konsep: Essentials, Add-Ons, Preview, Labs, Deprecated · c. Modul yang paling sering dipakai · d. Peta paket Arch ke modul · e. Contoh: dari import QML ke paket · f. Memeriksa apa yang terpasang · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Qt bukan satu pustaka, melainkan banyak **modul** yang dirilis dengan nomor versi yang sama. Bagian ini mengajarkan cara membaca peta modul itu, memahami status kematangannya, dan menghubungkan empat nama untuk hal yang sama: **nama import QML**, **komponen CMake**, **paket Arch**, dan **halaman dokumentasi**. Tanpa peta ini, `module "X" is not installed` terasa seperti misteri.

### b. Konsep: Essentials, Add-Ons, Preview, Labs, Deprecated

Dokumentasi Qt membagi modul menurut peran dan kematangan:

| Kategori | Arti | Janji kompatibilitas |
| --- | --- | --- |
| **Qt Essentials** | Fondasi: selalu ada dan berguna bagi sebagian besar aplikasi (Core, GUI, Network, QML, Quick, Quick Controls, Widgets, ...) | Kompatibel source dan binary selama seluruh Qt 6 (modul pengujian hanya source) |
| **Qt Add-Ons** | Fungsi lebih khusus (Multimedia, Quick 3D, Graphs, ...) | Ditentukan **per modul** |
| **Add-On Technology Preview** | Masih dikembangkan, tersedia untuk dicoba | **Tidak ada** janji source maupun binary |
| **Qt Labs** | Tipe eksperimental (mis. `Qt.labs.*`, Labs StyleKit) | Tidak ada janji |
| **Deprecated** | Dipertahankan agar kode lama jalan, tidak dipelihara, bisa dihapus di mayor berikutnya | Jangan dipakai di kode baru |
| **Extension Modules** | Fungsi di atas komponen pihak ketiga besar (mis. WebEngine, PDF), jadwal rilis boleh berbeda | Mengikuti halaman masing-masing |

Poin penting: modul **Technology Preview** dan **Deprecated** tidak termasuk dalam paket komersial resmi Qt. Contoh pergeseran status yang berlaku saat ini (diverifikasi dari halaman modul Qt dan blog Qt 6.12):

- Qt Charts dan Qt Data Visualization berstatus deprecated; penggantinya **Qt Graphs**.
- Qt 3D digantikan oleh **Qt Quick 3D**.
- **Qt Canvas Painter**: API inti keluar dari Technology Preview di Qt 6.12; elemen baru `Canvas2D` masih preview.

Status dapat berubah di tiap rilis; selalu cek halaman *Qt Modules* untuk versi yang Anda pakai.

### c. Modul yang paling sering dipakai

| Modul | Peran | Kapan Anda bertemu |
| --- | --- | --- |
| Qt Core | Objek, event loop, thread, berkas, string | Selalu; Fase 3 dan 10 |
| Qt GUI | Jendela, input, font, gambar, RHI | Selalu |
| Qt QML | Engine QML dan tipe dasar | Fase 1–3 |
| Qt Quick | Tipe visual, animasi, model-view | Fase 4–7 |
| Qt Quick Controls | Kontrol siap pakai dan style | Fase 9 |
| Qt Quick Layouts | `RowLayout`, `ColumnLayout`, `GridLayout` | Fase 5 |
| Qt Quick Dialogs | Dialog berkas, warna, pesan | Fase 9 |
| Qt Network | Jaringan | Fase 7 dan 10 |
| Qt Shader Tools | Alat shader (`qsb`) | Fase 11 |
| Qt Multimedia | Audio dan video | Saat dibutuhkan |
| Qt SVG | Dukungan SVG | Saat dibutuhkan |
| Qt 5 Compatibility | Jembatan ke API Qt 5, mis. Graphical Effects | Saat memakai tutorial lama |
| Qt Wayland | Plugin platform Wayland | Modul 0.3 dan 13.2 |

### d. Peta paket Arch ke modul

Nama paket berikut dikonfirmasi dari halaman paket Arch (grup `qt6`) dan daftar dependensi `qt6-declarative` 6.12.0-2 per 5 November 2026. Pembagian isi per paket dapat berubah; selalu verifikasi dengan `pacman -Ql`.

| Paket Arch | Isi pokok | Lisensi pada Qt open source |
| --- | --- | --- |
| `qt6-base` | Core, GUI, Network, Widgets, Sql, Test, Concurrent, D-Bus | LGPLv3 / GPLv3 |
| `qt6-declarative` | Qt QML, Qt Quick, Controls, Layouts, Dialogs, Quick Test, alat `qml*` | LGPLv3 / GPLv3 |
| `qt6-tools` | Assistant, Designer, Linguist, alat pendukung | GPLv3 dengan Qt GPL exception (alat) |
| `qt6-shadertools` | Alat shader | LGPLv3 / GPLv3 |
| `qt6-5compat` | Qt 5 Compatibility APIs | LGPLv3 / GPLv3 |
| `qt6-svg` | Qt SVG; opsional untuk `QtQuickVectorImage` dan `svgtoqml` | LGPLv3 / GPLv3 |
| `qt6-imageformats` | Plugin format gambar tambahan | LGPLv3 / GPLv3 |
| `qt6-wayland` | Plugin platform Wayland | LGPLv3 / GPLv3 |
| `qt6-multimedia` (+ `qt6-multimedia-ffmpeg`) | Audio dan video | LGPLv3 / GPLv3 |
| `qt6-quick3d`, `qt6-quick3dphysics`, `qt6-quicktimeline`, `qt6-canvaspainter`, `qt6-graphs`, `qt6-virtualkeyboard` | Add-on yang pada Qt open source berlisensi **GPLv3** | GPLv3 (lihat 0.1.3) |
| `qt6-charts`, `qt6-datavis3d` | Deprecated, diganti Qt Graphs | Periksa halaman paket |
| `qt6-webengine` | WebEngine (berbasis Chromium), berat | Mengikuti halaman WebEngine |

### e. Contoh: dari import QML ke paket

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 360
    height: 200
    title: 'Peta modul'

    ColumnLayout {
        anchors.centerIn: parent
        Label { text: 'Tiga modul dalam satu jendela' }
        Button { text: 'Klik saya' }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `import QtQuick` | Memuat Item, Text, dan teman-temannya (modul Qt Quick). |
| `import QtQuick.Controls` | Memuat `ApplicationWindow`, `Label`, `Button` (Qt Quick Controls). |
| `import QtQuick.Layouts` | Memuat `ColumnLayout` (Qt Quick Layouts). |
| `ApplicationWindow` | Jendela aplikasi dengan dukungan header dan footer dari Controls. |
| `ColumnLayout`, `Label`, `Button` | Tata letak kolom, teks, dan tombol. |

Keempat nama untuk tiga hal yang sama:

| Kebutuhan | Import QML | Komponen CMake | Paket Arch |
| --- | --- | --- | --- |
| `Item`, `Text`, `Rectangle` | `QtQuick` | `Quick` | `qt6-declarative` |
| `Button`, `ApplicationWindow` | `QtQuick.Controls` | `QuickControls2` | `qt6-declarative` |
| `ColumnLayout` | `QtQuick.Layouts` | `QuickLayouts` | `qt6-declarative` |
| `FileDialog` | `QtQuick.Dialogs` | `QuickDialogs2` | `qt6-declarative` |
| `Video`, `MediaPlayer` | `QtMultimedia` | `Multimedia` | `qt6-multimedia` |
| `View3D` | `QtQuick3D` | `Quick3D` | `qt6-quick3d` |

Nama komponen CMake tertulis di bagian *CMake* pada halaman tiap modul; cocokkan dengan itu bila ragu. Menulis `import QtQuick.Controlz` memunculkan `module "QtQuick.Controlz" is not installed`: salah eja, atau paketnya belum terpasang.

### f. Memeriksa apa yang terpasang

```bash
$ pacman -Sg qt6
$ pacman -Qs '^qt6-'
$ qmake6 -query QT_INSTALL_QML
$ ls "$(qmake6 -query QT_INSTALL_QML)"
$ sudo pacman -Fy
$ pacman -F qmllint
```

| Bagian | Arti |
| --- | --- |
| `pacman -Sg qt6` | Daftar semua paket di grup `qt6` pada repositori. |
| `pacman -Qs '^qt6-'` | Paket terpasang yang namanya diawali `qt6-`. |
| `qmake6 -query QT_INSTALL_QML` | Menampilkan folder tempat modul QML terpasang di mesin Anda. |
| `ls "$(...)"` | Daftar isi folder itu: setiap sub-folder adalah modul QML yang bisa di-`import`. Kutip ganda menjaga spasi bila ada. |
| `sudo pacman -Fy` | ⚠ Sinkronkan basis data berkas (sekali dulu). |
| `pacman -F qmllint` | Menunjukkan paket mana yang memuat berkas bernama `qmllint`. |

### g. Opsi lain

| Pertanyaan | Cara lain |
| --- | --- |
| Modul QML apa yang tersedia? | `QML_IMPORT_TRACE=1 qml Main.qml` menampilkan pencarian import; dokumentasi *Qt Modules* menampilkan peta resminya |
| Paket apa yang membawa berkas ini? | `pacman -Qo /path/berkas` (terpasang) atau `pacman -F nama` (belum tentu terpasang) |
| Apa saja dependensi suatu paket? | `pacman -Si paket` atau `pactree paket` (paket `pacman-contrib`) |
| Fitur Qt apa yang aktif? | Berkas konfigurasi di folder instalasi Qt; juga ringkasan konfigurasi per modul |

### h. Visual

```
  Nama yang Anda tulis            Dicari di mana?
  ---------------------------     -----------------------------------
  import QtQuick.Controls   -->   QML_IMPORT_PATH + folder QML Qt
  Qt6::QuickControls2       -->   find_package(Qt6 COMPONENTS ...)
  qt6-declarative           -->   pacman (repositori extra)
  halaman doc.qt.io         -->   Qt Modules -> modul -> CMake / QML Types

   Essentials (selalu ada)
      +-- Add-Ons (khusus)
            +-- Technology Preview / Labs (tanpa janji)
            +-- Deprecated (jangan untuk kode baru)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Qt Essentials / Add-Ons | Modul inti / modul khusus |
| Technology Preview | Modul awal tanpa janji kompatibilitas |
| Qt Labs | Tipe eksperimental yang dapat berubah |
| Deprecated | Usang, dipertahankan sementara |
| Extension module | Modul di atas komponen pihak ketiga besar |
| URI import | Nama modul QML, mis. `QtQuick.Controls` |
| Komponen CMake | Nama untuk `find_package(Qt6 COMPONENTS ...)` |
| Source / binary compatible | Dapat dikompilasi ulang / dijalankan tanpa kompilasi ulang |

### j. Tips dan praktik terbaik

- Pasang hanya modul yang dibutuhkan proyek; setiap modul tambahan memperbesar permukaan serangan dan ukuran distribusi.
- Hindari modul Technology Preview dan Labs untuk kode produksi; pasang pengaman berupa versi Qt yang dipin di CMake.
- Untuk grafik data baru, mulai dari Qt Graphs, bukan Qt Charts.
- Catat URI import dan paket Arch di `catatan.md` setiap memakai modul baru.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `module "QtMultimedia" is not installed` | Paket `qt6-multimedia` belum terpasang | `pacman -F` atau tabel di atas; pasang paketnya |
| `module "Qt.labs.platform" ...` hilang | Modul Labs dipindah atau diganti | Baca halaman modul untuk penggantinya |
| Kode dari tutorial memakai `QtGraphicalEffects` | Modul Qt 5 | Pakai `Qt5Compat.GraphicalEffects` (`qt6-5compat`) atau `QtQuick.Effects` |
| Memakai Qt Charts untuk proyek baru | Tutorial lama | Pertimbangkan Qt Graphs |
| Membangun dengan modul yang tidak ada di CMake | Komponen salah eja | Salin nama dari bagian *CMake* di halaman modul |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 0.2 (`find_package` dan `qt_add_qml_module`), 0.3 (plugin platform dan RHI), Fase 9 (Controls), Modul 10.3 (modul C++ yang diregistrasikan ke QML), dan 14.4 (pustaka UI sendiri).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan contoh `Main.qml` di atas. Lalu: (1) catat keluaran `ls "$(qmake6 -query QT_INSTALL_QML)"`; (2) ubah salah satu import menjadi salah eja dan baca pesan error; (3) isi tabel milik Anda sendiri: untuk tiga modul yang paling mungkin Anda pakai, tuliskan URI import, komponen CMake, paket Arch.

**Cek pemahaman.** (1) Apa beda Essentials dan Add-Ons? (2) Mengapa modul Technology Preview berisiko untuk produk? (3) Perintah apa yang memberi tahu paket mana yang membawa `qmllint`?

### n. Referensi

- [Qt Modules (semua modul Qt 6)](https://doc.qt.io/qt-6/qtmodules.html) · [Qt Framework product information](https://doc.qt.io/qt-6.12/qt-framework-product-information.html)
- [Qt Releases: janji kompatibilitas](https://doc.qt.io/qt-6/qt-releases.html)
- [Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-index.html) · [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html)
- [Qt Labs StyleKit](https://doc.qt.io/qt-6/qtlabsstylekit-index.html) · [Qt Graphs](https://doc.qt.io/qt-6/qtgraphs-index.html)
- [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt) · [Arch Wiki: pacman, mencari berkas](https://wiki.archlinux.org/title/Pacman)

---

## 0.1.3 Lisensi dan edisi

**Catatan:** bagian ini peta orientasi berdasarkan dokumentasi lisensi resmi Qt per 5 November 2026. Saya bukan pengacara dan ini bukan nasihat hukum; keputusan distribusi sungguhan perlu dibaca langsung pada teks lisensi dan, bila taruhannya besar, dikonsultasikan ke ahli hukum.

*Semangat: perangkat lunak yang baik pantas didistribusikan dengan benar.*

**Daftar isi 0.1.3:** a. Deskripsi dan peran · b. Konsep: tiga jalur lisensi · c. Modul GPL-only pada Qt open source · d. Alat, dokumentasi, contoh · e. Praktik kepatuhan LGPL secara garis besar · f. Memeriksa lisensi di mesin Anda · g. Peta keputusan · h. Edisi dan produk · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Sebelum menulis aplikasi yang akan dibagikan, Anda perlu tahu aturan mainnya. Lisensi menentukan apa yang boleh Anda distribusikan, bagaimana, dan kewajiban apa yang menyertainya. Modul ini mencegah kejutan di akhir proyek, ketika mengganti pustaka sudah mahal.

### b. Konsep: tiga jalur lisensi

Menurut halaman *Qt Licensing*, Qt tersedia dalam tiga jalur:

| Jalur | Cocok untuk | Intinya |
| --- | --- | --- |
| **Komersial** | Perangkat lunak proprietari yang tidak ingin atau tidak bisa memenuhi syarat LGPLv3 | Satu lisensi komersial untuk **semua** modul |
| **LGPLv3 (atau GPLv3)** | Aplikasi yang dapat memenuhi syarat LGPLv3 / GPLv3 | Gratis, dengan kewajiban terhadap pengguna akhir |
| **Qt Marketplace License** | Komponen pihak ketiga di Qt Marketplace | Mengikuti perjanjian marketplace |

**Filosofi.** Copyleft membagikan kebebasan melintasi rantai distribusi: siapa yang menerima program berhak mendapat sumber atau cara mengganti pustakanya. Lisensi komersial menukar kewajiban itu dengan biaya. Tidak ada jalur yang “benar”; yang ada hanyalah jalur yang cocok dengan produk dan kemampuan Anda memenuhinya.

### c. Modul GPL-only pada Qt open source

Bagian ini yang paling sering terlewat: pada Qt open source, **sebagian modul tidak tersedia di bawah LGPL**, melainkan GPLv3. Daftar yang ditampilkan halaman lisensi Qt 6.12:

| Modul GPLv3 (open source) |
| --- |
| Qt Canvas Painter, Qt CoAP, Qt Graphs, Qt GRPC |
| Qt HTTP Server, Qt Lottie Animation, Qt MQTT, Qt Network Authorization |
| Qt Qml Compiler, Qt Quick 3D, Qt Quick 3D Physics, Qt Quick Timeline |
| Qt Virtual Keyboard, Qt Wayland Compositor |

Akibatnya: aplikasi tertutup yang memakai, misalnya, Qt Quick 3D atau Qt Graphs tidak dapat memanfaatkan jalur LGPL; opsinya adalah merilis aplikasi di bawah GPLv3 atau memakai lisensi komersial. Bagi pelanggan komersial, semua modul tersedia di bawah satu lisensi.

Nama “Qt Qml Compiler” di daftar ini jangan dicampur dengan `qmlsc`: dokumentasi Qt Quick Compiler menyebut `qmltc` dan `qmlcachegen` tersedia untuk semua versi Qt, sedangkan `qmlsc` hanya untuk pelanggan komersial. Detail dibahas di Modul 11.5.

### d. Alat, dokumentasi, contoh

| Bagian | Lisensi |
| --- | --- |
| Qt tools and utilities (`qmllint`, `qmlformat`, ...) | Komersial, atau GPLv3 dengan **Qt GPL exception 1.0** |
| Dokumentasi Qt | Komersial, atau GNU Free Documentation License 1.3 |
| Contoh kode Qt | Komersial, atau BSD-3-clause |
| Kode pihak ketiga di dalam Qt | Lisensi aslinya; daftar di *Third-Party Code Used in Qt* |
| Lisensi pendidikan | Tersedia bagi pelajar dan pengajar di institusi yang memenuhi syarat |

Pengecualian GPL pada alat (Qt GPL exception) dimaksudkan agar keluaran alat tersebut tidak otomatis menularkan GPL; baca teks pengecualiannya langsung.

### e. Praktik kepatuhan LGPL secara garis besar

Ini gambaran umum yang lazim dibahas; selalu cocokkan dengan teks resmi:

- **Tautkan Qt secara dinamis** (pustaka `.so` yang bisa diganti pengguna). Penautan statis membuat kewajiban jauh lebih rumit.
- **Sertakan teks lisensi dan pemberitahuan hak cipta** Qt dan komponen pihak ketiganya dalam distribusi.
- **Sediakan sumber Qt** yang Anda pakai (dan perubahan Anda terhadapnya) atau tawaran tertulis untuk itu.
- **Izinkan pengguna mengganti Qt** dengan versi yang dimodifikasi. LGPLv3 menambahkan syarat soal informasi pemasangan, yang menyulitkan perangkat yang terkunci; produk jenis itu biasanya memilih lisensi komersial.
- Mulai Qt 6.8, Qt menyediakan *Software Bill of Materials* (SBOM) dalam format SPDX 2.3 untuk komponen pihak ketiga di dalamnya, membantu menyusun daftar pemberitahuan.

### f. Memeriksa lisensi di mesin Anda

```bash
$ pacman -Qi qt6-declarative | grep -i '^Licenses'
$ pacman -Si qt6-quick3d | grep -i '^Licenses'
$ ldd ./build/hello | grep -i qt
```

| Bagian | Arti |
| --- | --- |
| `pacman -Qi paket` | Informasi paket terpasang, termasuk baris `Licenses`. |
| `pacman -Si paket` | Informasi paket dari repositori (bisa untuk yang belum terpasang). |
| `grep -i '^Licenses'` | Ambil baris lisensi saja. Pada `qt6-declarative` Anda akan melihat kombinasi GPL, LGPL, dan lisensi komersial karena Qt ditawarkan dalam beberapa jalur. |
| `ldd ./build/hello` | Menampilkan pustaka dinamis yang ditautkan hasil build (Modul 0.2); baris `libQt6...` membuktikan penautan dinamis. |

### g. Peta keputusan

Ini orientasi, bukan nasihat hukum.

| Situasi | Jalur yang biasanya dipertimbangkan |
| --- | --- |
| Belajar, hobi, proyek open source | Qt open source (LGPLv3 / GPLv3) cukup |
| Aplikasi tertutup, hanya modul LGPL, dapat dipenuhi syarat LGPL | LGPLv3 mungkin cocok; verifikasi kewajiban |
| Aplikasi tertutup memakai modul GPL-only (Quick 3D, Graphs, ...) | Lisensi komersial, atau rilis aplikasi sebagai GPLv3 |
| Perangkat tertutup yang tidak boleh diganti pustakanya | Umumnya lisensi komersial |
| Perlu patch LTS segera, dukungan, atau jaminan respons | Lisensi komersial |

### h. Edisi dan produk

Qt Group menawarkan beberapa lini produk: **Qt Framework** (desktop, seluler, tertanam), **Qt for MCUs** (mikrokontroler, penomoran dan jadwal rilis terpisah), **Qt Creator** (IDE), **Qt Design Studio** (alat desain), serta produk jaminan kualitas. Qt Creator dan Qt Design Studio punya penomoran versi sendiri, bukan versi Qt. Untuk kurikulum ini, yang relevan adalah Qt Framework dan alat baris perintah.

### i. Visual

```
  Ingin mendistribusikan aplikasi?
          |
          +-- Memakai modul GPL-only (Quick 3D, Graphs, ...)?
          |        |-- ya  --> komersial, atau rilis GPLv3
          |        '-- tidak
          |
          +-- Bisa memenuhi syarat LGPLv3 (dinamis, sumber, penggantian)?
          |        |-- ya  --> Qt open source (LGPLv3)
          |        '-- tidak --> komersial
          |
          '-- Perlu LTS patch segera / dukungan / SLA? --> komersial
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| LGPLv3 | Lisensi copyleft untuk pustaka; mengizinkan aplikasi tertutup dengan syarat |
| GPLv3 | Copyleft kuat; karya turunan wajib GPLv3 juga |
| Copyleft | Kewajiban meneruskan kebebasan ke penerima |
| Lisensi komersial | Perjanjian berbayar tanpa kewajiban copyleft |
| Qt GPL exception 1.0 | Pengecualian pada GPL untuk alat Qt |
| Tautan dinamis / statis | Pustaka terpisah yang dimuat saat jalan / disatukan ke executable |
| SBOM | Daftar komponen perangkat lunak beserta lisensinya |
| Technology Preview | Status modul awal; tidak termasuk penawaran komersial |

### k. Tips dan praktik terbaik

- Putuskan jalur lisensi **sebelum** memilih modul besar seperti Quick 3D atau Graphs.
- Catat lisensi setiap dependensi di `catatan.md` atau berkas `THIRD_PARTY.md` sejak awal.
- Simpan teks lisensi dan SBOM bersama artefak rilis.
- Bila ragu, tanyakan; salah menafsirkan lisensi lebih mahal daripada bertanya.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Mengira “Qt gratis jadi bebas apa saja” | Mengabaikan kewajiban LGPL | Baca halaman *Open Source LGPL obligations* |
| Mengira semua modul LGPL | Tidak membaca daftar GPL-only | Periksa daftar di 0.1.3-c sebelum memilih modul |
| Menautkan Qt secara statis lalu menutup sumber | Tidak memahami konsekuensinya | Tautkan dinamis, atau pilih lisensi komersial |
| Tidak menyertakan pemberitahuan lisensi | Terlewat saat packaging | Jadikan bagian dari daftar periksa rilis (Modul 13.3) |
| Mengira alat GPL menulari aplikasi Anda | Salah membaca pengecualian | Baca Qt GPL exception 1.0 |

### m. Hubungan dengan modul lain

Prasyarat untuk Modul 11.5 (`qmlsc`, `qmltc`, `qmlcachegen`), 13.3 (packaging dan pemberitahuan lisensi), 13.4 (rekayasa perangkat lunak), dan 14.4 (pustaka UI yang akan didistribusikan).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan perintah di bagian f untuk `qt6-base`, `qt6-declarative`, dan `qt6-quick3d`. Bandingkan baris `Licenses`-nya. Lalu isi tabel: untuk proyek hipotetis aplikasi tertutup yang menampilkan model 3D, jalur lisensi mana yang perlu dipertimbangkan, dan mengapa?

**Cek pemahaman.** (1) Sebutkan tiga jalur lisensi Qt. (2) Mengapa Qt Quick 3D mengubah pilihan lisensi aplikasi tertutup? (3) Apa bedanya `qmlcachegen` dan `qmlsc` dari sisi ketersediaan?

### o. Referensi

- [Qt Licensing (Qt 6)](https://doc.qt.io/qt-6/licensing.html)
- [GNU LGPL v3 di dokumentasi Qt](https://doc.qt.io/qt-6/lgpl.html) · [GNU GPL v3](https://doc.qt.io/qt-6/gpl.html) · [Qt GPL exception 1.0](https://doc.qt.io/qt-6/qt-gpl-exception-1-0.html)
- [Third-Party Code Used in Qt](https://doc.qt.io/qt-6/licenses-used-in-qt.html) · [Software Bill of Materials](https://doc.qt.io/qt-6/sbom.html)
- [Qt: open source LGPL obligations](https://www.qt.io/licensing/open-source-lgpl-obligations) · [Harga dan paket](https://www.qt.io/pricing) · [Lisensi pendidikan](https://www.qt.io/qt-educational-license)
- [Qt Quick Compiler: qmltc, qmlcachegen, qmlsc](https://doc.qt.io/qt-6/qtqml-qtquick-compiler-tech.html)
- [Teks GNU LGPL 3.0](https://www.gnu.org/licenses/lgpl-3.0.html) · [GNU GPL FAQ](https://www.gnu.org/licenses/gpl-faq.html)

---

## 0.1.4 Siklus rilis, LTS, dan janji kompatibilitas

*Semangat: yang memahami jadwal tidak pernah terkejut oleh pembaruan.*

**Daftar isi 0.1.4:** a. Deskripsi dan peran · b. Konsep: penomoran dan irama rilis · c. LTS dan batasnya · d. Janji kompatibilitas · e. Fakta rilis bertanggal 5 November 2026 · f. Contoh: memeriksa dan mengunci versi · g. Opsi lain mengelola versi · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini menjawab tiga pertanyaan praktis: versi Qt mana yang harus saya pakai, sampai kapan ia dipelihara, dan apa yang dijanjikan tidak akan rusak saat saya memperbarui. Jawabannya menentukan nomor versi minimum di `CMakeLists.txt` (Modul 0.2) dan strategi pembaruan jangka panjang (Modul 13.3).

### b. Konsep: penomoran dan irama rilis

Qt memakai *semantic versioning*: `mayor.minor.patch`, misalnya `6.12.0`.

| Jenis | Kapan terjadi | Isi |
| --- | --- | --- |
| Mayor | Jarang: Qt 4.0.0 pada 2005, Qt 5.0.0 pada 2012, Qt 6.0.0 pada 2020 | Perubahan besar pada struktur modul dan API |
| Minor | Dua kali setahun | Fungsi baru dan perbaikan |
| Patch | Dua atau tiga per minor, sampai minor berikutnya terbit | Perbaikan bug dan keamanan, dokumentasi, performa |

Pengecualian: perbaikan keamanan dapat memicu patch lebih lambat, dan versi LTS mendapat patch lebih lama. Modul seperti Qt Creator, Qt Design Studio, dan Qt for MCUs dirilis terpisah dengan penomoran sendiri.

### c. LTS dan batasnya

**LTS** (*Long-Term Support*) adalah minor tertentu yang dipelihara lebih lama. Sejak Qt 6.8, **setiap minor keempat** menjadi LTS (sebelumnya setiap minor ketiga), sehingga ada LTS baru kira-kira tiap dua tahun, dengan dukungan komersial lima tahun sejak rilis x.y.0. Halaman rilis resmi menambahkan batas penting: **patch awal sebuah LTS juga tersedia bagi pengguna open source, tetapi akses langsung ke rilis LTS lanjutan terbatas pada pelanggan komersial**. Karena itu halaman yang sama menandai Qt 6.8.8 sebagai *commercial only*.

Dampaknya bagi Anda: LTS bukan jaminan “patch gratis selama lima tahun”. Sebagai pengguna Arch, Anda mengikuti rilis stabil terbaru dari paket distro, sehingga LTS lebih relevan bagi yang mendistribusikan produk dan membutuhkan dukungan.

### d. Janji kompatibilitas

- **Source compatible:** aplikasi yang dikompilasi dengan Qt 6.0.0 seharusnya tetap bisa dikompilasi dengan rilis Qt 6 lain (mungkin dengan peringatan *deprecated*). Dikecualikan: modul atau API Technology Preview, “under development”, “subject to change”, dan pra-rilis. Ada pengecualian yang dicatat pada dokumen QUIP-6.
- **Binary compatible (mundur):** aplikasi yang dikompilasi dengan Qt 6.0.0 seharusnya tetap berjalan dengan rilis Qt 6 lain, **tetapi tidak selalu sebaliknya**. Syaratnya: toolchain dan lingkungan sistem yang sama, build dinamis, dan konfigurasi Qt yang sama; pra-rilis serta modul Technology Preview dikecualikan.

Arti praktisnya: dibangun dengan 6.8 lalu dijalankan di 6.12 aman; dibangun dengan 6.12 lalu dijalankan di 6.8 tidak dijamin.

### e. Fakta rilis bertanggal 5 November 2026

Diambil dari halaman *Qt Releases* dan blog rilis Qt 6.12. Bagian ini cepat usang; verifikasi ulang sebelum mengandalkannya.

| Versi | Rilis patch terbaru | Dukungan standar hingga | Catatan |
| --- | --- | --- | --- |
| Qt 6.12 (LTS) | 6.12.0 (30 September 2026) | 30 September 2031 | Target kurikulum; paket Arch 6.12.0-2 |
| Qt 6.11 | 6.11.3 | 17 Maret 2027 | Patch terakhir seri ini menurut blog Qt |
| Qt 6.10 | 6.10.3 | 7 Oktober 2026 | Dukungan standar sudah berakhir |
| Qt 6.8 (LTS) | 6.8.8 (khusus komersial) | 8 Oktober 2029 | Versi minimum kurikulum |

**Sorotan Qt 6.12** (blog resmi): hot reload bawaan engine QML (alat `qmlpreview` dibangun ulang di atasnya); Qt Canvas Painter keluar dari Technology Preview dan menghadirkan `Canvas2D` (masih preview); Labs StyleKit untuk menata Widgets dan Qt Quick dari satu sumber; peningkatan `QRangeModel`; dukungan HarmonyOS; gaya `QtQuick.Controls.Native`; kontrol baru seperti Safe Area, Context Menu, Search Field, Double Spin Box, serta tata letak FlexBox; pernyataan kesesuaian EU Cyber Resilience Act untuk Qt komersial 6.12.

### f. Contoh: memeriksa dan mengunci versi

```bash
$ pacman -Q qt6-base qt6-declarative
$ qmake6 --version
$ pacman -Qi qt6-declarative | grep -E '^(Version|Build Date)'
```

| Bagian | Arti |
| --- | --- |
| `pacman -Q paket ...` | Versi paket terpasang; beberapa paket sekaligus. |
| `qmake6 --version` | Versi Qt yang ditemukan alat qmake (cara Bagian 4 memeriksa nama executable). |
| `grep -E '^(Version\|Build Date)'` | Ambil hanya baris versi dan tanggal build; `-E` memakai pola regex lanjutan, `^` berarti awal baris. |

Mengunci versi minimum dalam proyek:

```cmake
find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.8)
```

| Bagian | Arti |
| --- | --- |
| `find_package(Qt6 6.8 ...)` | Minta Qt 6 dengan versi paling rendah 6.8; configure gagal bila yang terpasang lebih rendah. |
| `REQUIRED` | Hentikan configure bila tidak ditemukan. |
| `COMPONENTS Quick` | Modul yang dibutuhkan. |
| `qt_standard_project_setup(REQUIRES 6.8)` | Pengaturan standar proyek Qt, sekaligus memaksa versi minimum. |

Untuk kode C++ yang harus mendukung beberapa versi:

```cpp
#include <QtGlobal>

#if QT_VERSION >= QT_VERSION_CHECK(6, 8, 0)
    // kode untuk Qt 6.8 ke atas
#else
    // cadangan untuk versi lebih lama
#endif
```

| Bagian | Arti |
| --- | --- |
| `QT_VERSION` | Makro berisi versi Qt saat kompilasi dalam bentuk satu angka. |
| `QT_VERSION_CHECK(6, 8, 0)` | Membuat angka pembanding untuk versi 6.8.0. |
| `#if ... #else ... #endif` | Pilih blok kode pada waktu kompilasi. |

Di dokumentasi dan kurikulum, penanda `[≥6.5]` berarti fitur tersedia sejak Qt 6.5.

### g. Opsi lain mengelola versi

| Strategi | Kegunaan | Catatan |
| --- | --- | --- |
| Rolling Arch (paket distro) | Selalu versi stabil terbaru | Terbaik untuk belajar; pembaruan menyeluruh (`pacman -Syu`) |
| Qt Online Installer resmi | Memilih versi Qt tertentu, pasang berdampingan | Perlu Qt Account; jangan campur dengan paket sistem |
| Kontainer (`podman`) dengan Qt tetap | Menguji terhadap versi minimum | Lingkungan dapat diulang; isolasi baik |
| Membangun dari source | Kontrol penuh, versi apa pun | Waktu dan ruang besar |
| Arsip paket Arch (Arch Linux Archive) | Kembali ke versi lama sementara | Bukan strategi jangka panjang |

### h. Visual

```
  Minor dua kali setahun; LTS tiap minor ke-4 (aturan ini berlaku sejak 6.8)

  6.8 LTS --- 6.9 --- 6.10 --- 6.11 --- 6.12 LTS --- 6.13 --- 6.14 --- 6.15 --- 6.16 LTS
  Okt 2024                              30 Sep 2026                               (perkiraan
                                                                                 dari aturan)
  Dukungan standar tiap minor biasa = 1 tahun; LTS sejak 6.8 = 5 tahun
  Patch LTS lanjutan: segera untuk komersial, terbatas untuk open source
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Semantic versioning | Skema `mayor.minor.patch` dengan arti tiap bagian |
| LTS | Long-Term Support: minor yang dipelihara lebih lama |
| Standard / Extended Support | Dukungan komersial biasa / lanjutan berbayar setelahnya |
| Source / binary compatibility | Kompatibel pada tingkat kode / berkas hasil kompilasi |
| ABI | Antarmuka biner antara program dan pustaka |
| QUIP | Qt Unified Improvement Proposal, dokumen proses Qt |
| Pra-rilis | Alpha, beta, release candidate: tanpa janji kompatibilitas |
| EOL | End of life: akhir dukungan |

### j. Tips dan praktik terbaik

- Tetapkan minimum yang Anda uji (di kurikulum: 6.8) dan jangan memakai fitur bertanda lebih baru tanpa penjaga versi.
- Bacalah dokumen *What's New* setiap rilis minor; hanya sepuluh menit dan menghemat berjam-jam.
- Ikuti pemberitahuan keamanan Qt (diterbitkan di blog dan halaman *Security*) dan perbarui secara teratur.
- Untuk produk yang didistribusikan: dokumentasikan versi Qt tepat pada setiap rilis (SBOM).

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Mengira LTS berarti patch gratis lima tahun | Tidak membaca batas akses LTS | Baca halaman *Qt Releases*; pertimbangkan lisensi komersial bila butuh |
| Aplikasi gagal jalan di mesin lain | Dibangun dengan Qt lebih baru dari yang terpasang di sana | Bangun dengan versi minimum, atau sertakan Qt (Modul 13.3) |
| Memakai API Technology Preview di produk | Tidak memeriksa status | Cek *Since* dan penanda Technology Preview di dokumentasi |
| Memperbarui tanpa membaca catatan | Anggapan semua kompatibel | Baca *What's New* dan daftar deprecated |
| Mencampur Qt dari dua sumber | Dua versi pada satu sistem | Pilih satu sumber (Bagian 4 memakai paket distro) |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 0.2 (`qt_standard_project_setup(REQUIRES ...)`), 13.1 (pembaruan keamanan), 13.3 (packaging dan versi yang disertakan), dan 14.5 (membaca source Qt untuk versi tertentu).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** (1) Catat keluaran ketiga perintah di bagian f di mesin Anda. (2) Dari tabel di bagian e, hitung sisa masa dukungan standar Qt 6.11 dan Qt 6.12 dari hari ini. (3) Buka dokumen *What's New in Qt 6.12* dan tuliskan tiga fitur beserta fase kurikulum yang akan membahasnya.

**Cek pemahaman.** (1) Apa arti `6.12.0`? (2) Aplikasi dibangun dengan Qt 6.8 dan dijalankan dengan 6.12: apakah dijamin? Sebaliknya? (3) Mengapa LTS tidak otomatis berarti patch gratis untuk pengguna open source?

### n. Referensi

- [Qt Releases](https://doc.qt.io/qt-6/qt-releases.html) · [Qt LTS](https://www.qt.io/development/qt-framework/qt-lts)
- [Blog: Qt 6.12 LTS Released](https://www.qt.io/blog/qt-6.12-released) · [Blog: Hot reload di Qt 6.12](https://www.qt.io/blog/hot-reload-in-qt-6.12)
- [What's New in Qt 6.12](https://doc.qt.io/qt-6/whatsnew612.html) · [What's new in Qt 6](https://doc.qt.io/qt-6/whatsnewqt6.html)
- [QUIP-6](https://contribute.qt-project.org/quips/6) · [Semantic Versioning](https://semver.org/)
- [Qt Security](https://doc.qt.io/qt-6/security.html)
- [CMake: find\_package](https://cmake.org/cmake/help/latest/command/find_package.html)

---

## 0.1.5 Membaca dokumentasi Qt 6 dan menghindari jebakan Qt 5

*Semangat: yang pandai membaca dokumentasi tidak pernah benar-benar sendirian.*

**Daftar isi 0.1.5:** a. Deskripsi dan peran · b. Konsep: tiga jenis dokumentasi · c. Anatomi halaman tipe QML · d. Skema URL dan versi · e. Dokumentasi di terminal dan secara offline · f. Jebakan Qt 5 menuju Qt 6 · g. Contoh: bukti import tanpa versi · h. Opsi lain mencari jawaban · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Dokumentasi resmi Qt adalah sumber paling berwenang, tetapi hasil pencarian sering menampilkan halaman Qt 5 atau tutorial lama. Bagian ini mengajarkan cara membaca halaman referensi dengan cepat dan mengenali kode usang sebelum menyalinnya.

### b. Konsep: tiga jenis dokumentasi

| Jenis | Isi | Kapan dipakai |
| --- | --- | --- |
| **Referensi** | Daftar tipe, properti, signal, metode, kelas C++ | Saat tahu apa yang dicari |
| **Overview / topik** | Penjelasan konsep (mis. *Property Binding*) | Saat belajar konsep |
| **Contoh dan tutorial** | Kode lengkap yang bisa dijalankan | Saat butuh pola kerja |

Halaman *Qt Product Information* mengurutkan sumber informasi menurut otoritas: dokumentasi teknis Qt (bagian dari source Qt) berada di atas. Artinya, bila blog, forum, dan dokumentasi bertentangan, dokumentasi versi Anda yang menang.

### c. Anatomi halaman tipe QML

Buka halaman `Rectangle` dan temukan bagian-bagian ini:

| Bagian | Fungsi |
| --- | --- |
| **Import Statement** | Baris `import` yang dibutuhkan (mis. `import QtQuick`) |
| **Inherits** (dan *Inherited By*) | Rantai pewarisan; properti induk berlaku juga (mis. `Item`) |
| Daftar **Properties, Attached Properties, Signals, Methods** | Ringkasan seluruh anggota |
| **Detailed Description** | Penjelasan dan contoh kode |
| **Property Documentation** | Rincian per properti dengan penanda seperti *read-only*, *default*, *required* |
| **Since Qt 6.x** | Versi pertama yang menyediakan anggota itu |
| **Obsolete / deprecated** | Anggota usang beserta penggantinya |

Tiga pertanyaan wajib sebelum memakai apa pun: *modul apa yang harus diimpor, sejak versi berapa tersedia, dan apakah berstatus preview atau deprecated?*

### d. Skema URL dan versi

| URL | Isi |
| --- | --- |
| `https://doc.qt.io/qt-6/` | Dokumentasi Qt 6 (periksa nomor versi di halaman) |
| `https://doc.qt.io/qt-6.8/` | Qt 6.8 secara spesifik; ganti angka untuk versi lain |
| `https://doc.qt.io/qt-5/` | Qt 5: **hindari** untuk proyek baru |
| `https://doc.qt.io/archives` | Arsip versi lama |
| `https://doc-snapshots.qt.io/` | Snapshot pengembangan (belum rilis) |

Bila hasil pencarian membawa Anda ke `.../qt-5/...`, ganti `qt-5` menjadi `qt-6` pada alamat dan periksa apakah halaman padanannya ada.

### e. Dokumentasi di terminal dan secara offline

```bash
$ w3m https://doc.qt.io/qt-6/qml-qtquick-rectangle.html
$ qmake6 -query QT_INSTALL_DOCS
$ pacman -Si qt6-doc
$ sudo pacman -S qt6-doc
```

| Bagian | Arti |
| --- | --- |
| `w3m URL` | Peramban teks di terminal (paket `w3m`; alternatif `lynx`, `links`). Gerakan dengan keyboard; `q` untuk keluar. |
| `qmake6 -query QT_INSTALL_DOCS` | Folder tempat dokumentasi offline Qt dipasang. |
| `pacman -Si qt6-doc` | Informasi paket dokumentasi offline di repositori Arch: ukuran unduhan sekitar 199 MiB dan terpasang sekitar 476 MiB pada versi yang saya periksa. |
| `sudo pacman -S qt6-doc` | ⚠ Memasang dokumentasi offline. Versinya dapat tertinggal dari paket Qt; cek dengan `pacman -Qi qt6-doc`. |

Qt Assistant (paket `qt6-tools`) membaca berkas bantuan `.qch` secara grafis; nama executable-nya cek dengan `pacman -Ql qt6-tools`, sesuai prinsip Bagian 4: jangan menebak nama.

### f. Jebakan Qt 5 menuju Qt 6

| Kode lama (Qt 5) | Qt 6 | Dibahas di |
| --- | --- | --- |
| `import QtQuick 2.15` | `import QtQuick` (nomor versi opsional) | 0.1.5-g |
| `import QtQuick.Controls 2.15` | `import QtQuick.Controls` | 0.1.5-g |
| `import QtQuick.Window 2.15` | `Window` tersedia dari `QtQuick`; **\[uji dulu\]** hapus import itu dan jalankan | Fase 1 |
| `QtGraphicalEffects` | `Qt5Compat.GraphicalEffects` (paket `qt6-5compat`), atau `MultiEffect` dari `QtQuick.Effects` (≥6.5) | Modul 6.4 |
| Style Controls bernama *Default* | Bernama *Basic* | Modul 9.2 |
| Proyek `qmake` (`.pro`) | CMake dengan `qt_add_executable` dan `qt_add_qml_module` | Modul 0.2 |
| `qmlRegisterType` manual | `QML_ELEMENT` dan registrasi lewat `qt_add_qml_module` | Modul 10.3 |
| `Connections { onSinyal: ... }` | Sintaks baru `function onSinyal() { ... }` di dalam `Connections` | Modul 3.2 |
| Parameter signal “masuk sendiri” ke handler | Deklarasikan parameter secara eksplisit | Modul 3.2 |
| Delegate memakai nama `index`, `modelData` secara implisit | `required property` | Modul 7.2 |

Baris yang berbunyi “deprecated” di Qt 5.15 sudah dipertahankan beberapa rilis di Qt 6 dengan peringatan, tetapi tidak dijamin selamanya. Anggap peringatan itu sebagai tugas.

### g. Contoh: bukti import tanpa versi

Cobalah tiga berkas `Main.qml` satu per satu dengan `qml Main.qml` dan catat apa yang terjadi.

```qml
// Percobaan A
import QtQuick 2.15
Rectangle { width: 200; height: 100; color: 'tomato' }
```

```qml
// Percobaan B
import QtQuick
Rectangle { width: 200; height: 100; color: 'tomato' }
```

```qml
// Percobaan C
import QtQuick 6.99
Rectangle { width: 200; height: 100; color: 'tomato' }
```

| Percobaan | Dugaan hasil (**\[uji dulu\]**, buktikan sendiri) | Pelajaran |
| --- | --- | --- |
| A | Berjalan; import berversi lama masih dikenali | Nomor versi lama tidak otomatis salah |
| B | Berjalan | Tanpa nomor: memuat versi terbaru modul |
| C | Galat bahwa versi itu tidak terpasang | Nomor versi adalah *syarat minimum*, bukan hiasan |

Jadi jawaban yang tepat untuk Cek pemahaman kurikulum adalah: di Qt 6 nomor versi **opsional**; tanpa nomor, engine memakai versi terbaru yang terpasang. Nomor versi masih berguna untuk membatasi minimum, misalnya `import QtQuick 6.8`.

### h. Opsi lain mencari jawaban

| Kebutuhan | Sumber | Catatan |
| --- | --- | --- |
| Tidak tahu nama tipe | Halaman *Qt Modules* dan *QML Types* per modul | Telusuri dari daftar modul |
| Perilaku tidak sesuai dokumentasi | [Bug tracker Qt](https://bugreports.qt.io/) | Cari dulu sebelum membuat laporan |
| Pertanyaan umum | [Forum Qt](https://forum.qt.io/) | Sertakan versi Qt, platform, dan contoh minimal |
| Detail implementasi | [Source Qt di code.qt.io](https://code.qt.io/cgit/qt/) | Dibahas di Modul 14.5 |
| Catatan rilis | `qtreleasenotes` di code.qt.io | Daftar perbaikan per rilis |
| Sumber komunitas | Blog Qt dan KDAB | Bandingkan selalu dengan dokumentasi versi Anda |

### i. Visual

```
  Hasil pencarian ----> adakah "qt-5" di URL?  --ya--> ganti ke qt-6 / cari padanannya
                                 | tidak
                                 v
                  periksa 3 hal pada halaman:
                    [Import Statement]  [Since Qt 6.x]  [Preview / Deprecated?]
                                 |
                                 v
              salin contoh --> jalankan dengan qml --> jalankan qmllint
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Referensi / overview / contoh | Tiga jenis dokumentasi |
| QML type | Halaman untuk tipe QML (mis. `Rectangle`) |
| Import Statement | Baris import yang diperlukan tipe itu |
| Since | Versi pertama yang menyediakan fitur |
| Obsolete / deprecated | Usang, ada penggantinya |
| `.qch` | Berkas bantuan terkompilasi yang dibaca Qt Assistant |
| Technology Preview | Status API yang belum stabil |

### k. Tips dan praktik terbaik

- Biasakan membaca dari halaman *QML Types* di modul terkait, lalu ke *Detailed Description*.
- Setiap kali menyalin kode, jalankan dengan `qml` dan `qmllint`; lihat peringatan deprecated.
- Catat versi dokumentasi yang Anda baca di `catatan.md`.
- Contoh kode Qt berlisensi BSD-3-clause (0.1.3), sehingga aman dipelajari dan dikembangkan.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Kode dari Stack Overflow tidak jalan | Jawaban untuk Qt 5 | Periksa tanggal dan versi; cari padanan Qt 6 |
| Mencari `Rectangle` malah menemukan `QRect` | Mencari kelas C++ | Tambahkan kata QML dan modul |
| `module "QtGraphicalEffects" is not installed` | Modul Qt 5 | Gunakan `qt6-5compat` atau `MultiEffect` |
| Mengikuti tutorial qmake untuk proyek baru | Tutorial lama | Ikuti CMake (Modul 0.2) |
| Menganggap semua warning deprecated bisa diabaikan | Menunda utang teknis | Perbaiki bertahap dengan `qmllint` |

### m. Hubungan dengan modul lain

Prasyarat untuk setiap fase berikutnya: setiap modul menyediakan bagian *Referensi* yang mengandalkan keterampilan ini. Tabel jebakan di bagian f menunjuk ke Modul 3.2, 6.4, 7.2, 9.2, dan 10.3.

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Buka halaman `Rectangle` (di peramban atau `w3m`) dan jawab: (1) modul apa yang diimpor? (2) tipe apa yang diwarisinya? (3) sejak versi berapa properti per-sudut tersedia, bila ada? (4) properti mana yang bertanda *read-only*? Lalu jalankan Percobaan A, B, C di bagian g dan catat hasil sebenarnya di mesin Anda.

**Cek pemahaman.** (1) Apakah `import QtQuick` tanpa nomor versi artinya nomor versi “dilarang”? (2) Di mana menemukan sejak versi berapa sebuah properti ada? (3) Apa penggantian `QtGraphicalEffects` di Qt 6?

### o. Referensi

- [Qt QML Type: Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html)
- [Qt Framework product information](https://doc.qt.io/qt-6.12/qt-framework-product-information.html)
- [Porting to Qt 6](https://doc.qt.io/qt-6/portingguide.html) · [What's new in Qt 6](https://doc.qt.io/qt-6/whatsnewqt6.html)
- [QML Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html)
- [Qt Bug Tracker](https://bugreports.qt.io/) · [Forum Qt](https://forum.qt.io/) · [Source Qt](https://code.qt.io/cgit/qt/)
- [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt)

---

## 0.1.6 Qt Quick dibanding Qt Widgets, dan bahasa lain yang memakai Qt \[TAMBAHAN\]

**Mengapa ditambahkan:** kurikulum berfokus pada Qt Quick, tetapi banyak tutorial, kode lama, dan alat memakai **Qt Widgets**. Tanpa peta ini, pembelajar menyalin `QPushButton` ke QML atau mencampur dua tumpukan tanpa sadar. Juga perlu tahu bahwa Qt dapat dipakai dari bahasa selain C++.

*Semangat: memilih alat yang tepat adalah separuh pekerjaan.*

**Daftar isi 0.1.6:** a. Deskripsi dan peran · b. Dua teknologi UI Qt · c. Peta pilihan · d. Tiga pintu masuk C++ untuk QML · e. Contoh: tombol yang sama di Widgets dan QML · f. Bahasa lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Qt menyediakan dua cara membangun antarmuka grafis. **Qt Widgets** adalah teknologi klasik berbasis C++: Anda menyusun objek widget (`QPushButton`, `QLineEdit`) dalam hierarki dan menulis logika imperatif. **Qt Quick** (kurikulum ini) menyusun item deklaratif di QML dan menggambarnya lewat scene graph.

### b. Dua teknologi UI Qt

| Aspek | Qt Widgets | Qt Quick |
| --- | --- | --- |
| Bahasa utama | C++ (atau Python) | QML dan JavaScript, backend C++ |
| Gaya | Imperatif, hierarki widget | Deklaratif, item dan binding |
| Rendering | Umumnya `QPainter` (raster, CPU) | Scene graph lewat RHI (GPU) |
| Cocok untuk | Alat desktop dengan banyak formulir, tabel, dan editor; tampilan mengikuti style platform | UI dinamis, animasi, sentuh, tertanam, tampilan kustom |
| Tampilan native | Mengikuti style platform | Controls punya style sendiri; Qt 6.12 menambah style `QtQuick.Controls.Native` |
| Paket Arch | `qt6-base` | `qt6-declarative` |
| Kelas aplikasi C++ | `QApplication` | `QGuiApplication` |

Keduanya dapat hidup berdampingan dalam satu program.

### c. Peta pilihan

```
  UI apa yang Anda bangun?
   |
   +-- Formulir padat, tabel, editor, nuansa native -----> Qt Widgets
   |
   +-- Animasi, sentuh, tertanam, tampilan kustom -------> Qt Quick (kurikulum ini)
   |
   '-- Campuran ----> QML di dalam Widgets (QQuickWidget)
                      atau gaya bersama lewat StyleKit (Labs, Qt 6.12)
```

Peta ini panduan awal, bukan hukum; Modul 14.7 memperdalam keputusan memilih modul Qt.

### d. Tiga pintu masuk C++ untuk QML

| Kelas | Dipakai untuk | Akar dokumen QML |
| --- | --- | --- |
| `QQmlApplicationEngine` | Aplikasi QML murni; dipakai di `main.cpp` Modul 0.2 | `Window` atau `ApplicationWindow` |
| `QQuickView` | Menampilkan satu item QML dalam satu jendela | `Item` atau turunannya |
| `QQuickWidget` | Menanam QML di dalam jendela Widgets (modul Qt Quick Widgets) | `Item` atau turunannya |

Catatan penting: bila program memakai Widgets, kelas aplikasinya harus `QApplication`; aplikasi QML murni cukup `QGuiApplication`.

### e. Contoh: tombol yang sama di Widgets dan QML

Qt Widgets (C++). Contoh ini hanya untuk perbandingan; Anda tidak perlu membangunnya sekarang.

```cpp
#include <QApplication>
#include <QDebug>
#include <QPushButton>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QPushButton tombol("Klik saya");
    QObject::connect(&tombol, &QPushButton::clicked, []() {
        qDebug() << "diklik";
    });

    tombol.show();
    return app.exec();
}
```

| Bagian | Arti |
| --- | --- |
| `QApplication app(argc, argv)` | Menyiapkan aplikasi Widgets dan event loop. |
| `QPushButton tombol("Klik saya")` | Membuat objek tombol dengan teks. |
| `QObject::connect(&tombol, &QPushButton::clicked, ...)` | Hubungkan signal `clicked` ke fungsi anonim (lambda). |
| `tombol.show()` | Menampilkan widget sebagai jendela. |
| `app.exec()` | Menjalankan event loop (0.0.2). |

Qt Quick Controls (QML), dijalankan dengan `qml Main.qml`:

```qml
import QtQuick.Controls

Button {
    text: 'Klik saya'
    onClicked: console.log('diklik')
}
```

| Bagian | Arti |
| --- | --- |
| `import QtQuick.Controls` | Memuat tipe `Button`. |
| `Button { ... }` | Objek tombol; tidak ada kode penyiapan aplikasi. |
| `text: 'Klik saya'` | Properti teks. |
| `onClicked: console.log('diklik')` | Handler signal `clicked`. |

Perbedaannya: di Widgets Anda menulis program yang memanggil API; di QML Anda mendeskripsikan objek dan engine yang menjalankannya.

### f. Bahasa lain

| Bahasa | Cara | Catatan |
| --- | --- | --- |
| C++ | Qt native | Bahasa utama Qt; Fase 10 |
| Python | Qt for Python (**PySide6**), proyek resmi Qt | Paket `pip` membawa Qt sendiri; pakai `venv` agar tidak bentrok dengan Qt sistem. Cari di Arch: `pacman -Ss pyside6` |
| Rust | CXX-Qt (KDAB); Qt Bridge for Rust | Blog Qt menyebut Qt Bridge for Rust berstatus 0.3 Beta pada 23 September 2026; verifikasi statusnya sebelum dipakai |
| JavaScript | Hanya di dalam QML | Bukan Node.js dan bukan peramban |
| Lainnya | Binding komunitas | Kualitas dan dukungan beragam |

### g. Visual

```
  QT WIDGETS                          QT QUICK
  ----------                          --------
  C++ / Python                        QML + JavaScript   (+ C++ backend)
  hierarki QWidget                    hierarki Item
  QPainter (raster)                   scene graph --> RHI --> GPU
  QApplication                        QGuiApplication
         \                              /
          +---- bisa digabung: QQuickWidget ----+
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Widget | Elemen UI klasik Qt Widgets |
| `QPainter` | Kelas menggambar 2D berbasis CPU |
| Scene graph | Pohon node gambar Qt Quick yang dikirim ke GPU |
| `QApplication` / `QGuiApplication` | Kelas aplikasi untuk Widgets / untuk non-Widgets |
| Binding bahasa | Pustaka yang menghubungkan Qt ke bahasa lain |
| Lambda | Fungsi anonim, sering dipakai sebagai penerima signal |

### i. Tips dan praktik terbaik

- Saat membaca tutorial, periksa baris `#include`: `<QtWidgets>` atau `<QPushButton>` berarti tumpukan Widgets, bukan QML.
- Mulai proyek baru dengan satu tumpukan; gabungkan hanya bila ada alasan jelas.
- Gunakan alat yang tepat untuk tiap bagian: Qt Designer untuk Widgets, QML untuk Quick.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `QPushButton is not a type` di QML | Tipe Widgets tidak ada di QML | Pakai `Button` dari `QtQuick.Controls` |
| Program crash saat menambah widget ke aplikasi `QGuiApplication` | Widgets membutuhkan `QApplication` | Ganti kelas aplikasi dan tautkan `Qt6::Widgets` |
| Tutorial memakai file `.ui` | Itu format Qt Designer untuk Widgets | Abaikan untuk QML |
| Dua gaya UI tampak tidak seragam | Style Widgets dan Quick berbeda | Pelajari StyleKit (Labs, 6.12) atau seragamkan manual |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 0.2 (pemilihan `QGuiApplication` di `main.cpp`), Fase 9 (Quick Controls), Modul 10.6 (integrasi sistem), dan Modul 14.7 (peta keputusan modul Qt).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan contoh `Button` dengan `qml Main.qml` dan klik tombolnya. Lalu cari halaman dokumentasi `QPushButton` dan `Button` (QML) dan bandingkan: modulnya, cara menangani klik, dan penandaan *Since*.

**Cek pemahaman.** (1) Apa perbedaan dasar Widgets dan Qt Quick dalam gaya penulisan? (2) Kelas aplikasi apa yang dibutuhkan bila program memakai Widgets? (3) Apa fungsi `QQuickWidget`?

### m. Referensi

- [Qt Widgets](https://doc.qt.io/qt-6/qtwidgets-index.html) · [Qt Quick Widgets](https://doc.qt.io/qt-6/qtquickwidgets-index.html)
- [QQmlApplicationEngine](https://doc.qt.io/qt-6/qqmlapplicationengine.html) · [QQuickView](https://doc.qt.io/qt-6/qquickview.html) · [QQuickWidget](https://doc.qt.io/qt-6/qquickwidget.html)
- [Qt Labs StyleKit](https://doc.qt.io/qt-6/qtlabsstylekit-index.html)
- [Qt for Python (PySide6)](https://doc.qt.io/qtforpython-6/) · [CXX-Qt](https://kdab.github.io/cxx-qt/book/)

---

## 0.1.7 Sumber Qt dan perkakas: paket distro, installer, Qt Creator \[TAMBAHAN\]

**Mengapa ditambahkan:** Bagian 4 kurikulum memasang Qt dari paket Arch, tetapi tutorial di luar sana menyebut *Qt Online Installer*, Qt Creator, dan Qt Design Studio. Pembelajar perlu tahu kapan masing-masing cocok, dan mengapa mencampur sumber Qt menimbulkan galat yang membingungkan.

*Semangat: kendalikan alatnya, jangan biarkan alat mengendalikan Anda.*

**Daftar isi 0.1.7:** a. Deskripsi dan peran · b. Tiga sumber Qt · c. Perkakas: baris perintah dan IDE · d. Contoh: Qt mana yang sedang aktif · e. Memakai Qt dari installer tanpa merusak sistem · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Pertanyaan “Qt saya datang dari mana?” menentukan versi, lisensi, jalur plugin, dan cara memperbaruinya. Menguasai jawabannya mencegah kelas galat yang paling melelahkan: dua Qt dalam satu sistem.

### b. Tiga sumber Qt

| Sumber | Cara | Kelebihan | Kelemahan |
| --- | --- | --- | --- |
| **Paket distro** (Arch) | `pacman -S qt6-base qt6-declarative ...` | Terintegrasi dengan sistem, pembaruan lewat `pacman`, tanda tangan diverifikasi | Hanya satu versi; mengikuti rilis Arch |
| **Qt Online Installer** (resmi) | Unduh dari qt.io, pilih versi dan komponen | Banyak versi berdampingan; paket komponen lengkap | Perlu Qt Account (periksa syarat terkini); terpasang di luar `pacman` |
| **Build dari source** | `git` dan CMake | Kontrol penuh, versi apa pun | Lama dan besar; perlu paham konfigurasi |

Kurikulum ini memakai **paket distro**: paling sederhana, paling aman, dan paling mudah diaudit.

### c. Perkakas: baris perintah dan IDE

| Kebutuhan | Baris perintah | IDE / alat grafis |
| --- | --- | --- |
| Menjalankan QML | `qml Main.qml` | Qt Creator |
| Analisis dan format | `qmllint`, `qmlformat` | Terintegrasi di Qt Creator |
| Bantuan editor | `qmlls` (language server) | Qt Creator, atau editor Anda via LSP |
| Build | `cmake`, `ninja` | Qt Creator memakai CMake juga |
| Debug | `gdb` | Debugger Qt Creator |
| Profiling QML | `qmlprofiler` | Tampilan QML Profiler di Qt Creator |
| Dokumentasi | `w3m` / peramban | Qt Assistant |
| Desain UI visual |  | Qt Design Studio (produk terpisah) |
| Terjemahan | `lupdate`, `lrelease` | Qt Linguist |

Qt Creator dan Qt Design Studio dirilis dengan penomoran sendiri, terpisah dari versi Qt. IDE bukan syarat; Qt Creator berguna sebagai pelengkap, terutama untuk profiler dan debugger visual.

### d. Contoh: Qt mana yang sedang aktif

```bash
$ qmake6 -query QT_INSTALL_PREFIX
$ command -v qml qmake6 cmake
$ echo "$CMAKE_PREFIX_PATH"
$ env | grep -E '^(QT_|QML)'
$ ldd ./build/hello | grep -i 'libQt6Core'
```

| Bagian | Arti |
| --- | --- |
| `qmake6 -query QT_INSTALL_PREFIX` | Folder induk instalasi Qt yang ditemukan; pada paket Arch umumnya `/usr`. |
| `command -v qml qmake6 cmake` | Lokasi tiap program yang akan dijalankan; jalur di bawah `~/Qt` menandakan installer. |
| `echo "$CMAKE_PREFIX_PATH"` | Jalur tambahan pencarian paket CMake; kosong berarti hanya jalur sistem. |
| `env \| grep -E '^(QT_\|QML)'` | Semua variabel lingkungan berawalan `QT_` atau `QML`: jejak pengaturan yang memengaruhi Qt. |
| `ldd ./build/hello \| grep -i 'libQt6Core'` | Pustaka Qt Core mana yang benar-benar dimuat hasil build (Modul 0.2). |

### e. Memakai Qt dari installer tanpa merusak sistem

```bash
$ cmake -S . -B build -G Ninja -DCMAKE_PREFIX_PATH=$HOME/Qt/VERSI/gcc_64
$ ldd ./build/hello | grep -i 'libQt6Core'
```

| Bagian | Arti |
| --- | --- |
| `-DCMAKE_PREFIX_PATH=...` | Memberi tahu CMake di mana mencari Qt. `VERSI` dan `gcc_64` mengikuti folder yang dibuat installer; sesuaikan dengan mesin Anda. |
| `ldd ...` | Bukti bahwa yang dimuat adalah Qt dari `~/Qt`, bukan dari `/usr`. |

Penting: jangan mengekspor `LD_LIBRARY_PATH` atau `QT_PLUGIN_PATH` secara global di `~/.bashrc` untuk Qt installer; itu memengaruhi **semua** aplikasi Qt di sistem Anda. Batasi pada satu perintah dengan prefiks variabel (0.0.3).

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Beberapa versi Qt untuk uji | Qt Online Installer, atau kontainer `podman` per versi | Kontainer menjaga sistem utama bersih |
| Skrip pembantu CMake dari Qt | `qt-cmake` (di folder `bin` instalasi Qt) | Mengatur prefix path otomatis; cari dengan `pacman -Ql` atau di folder installer |
| Editor modal dengan dukungan QML | Neovim atau Helix dengan `qmlls` | Konfigurasi di Modul 12.2; periksa nama executable dulu |
| Dokumentasi grafis offline | Qt Assistant dari `qt6-tools`, `qt6-doc` | Lihat 0.1.5-e |
| Python | PySide6 di `venv` | Membawa Qt sendiri; jangan campur |

### g. Visual

```
   SATU sumber Qt per proyek:

   [ paket Arch ]           /usr/lib/qt6/...          <-- dipakai kurikulum ini
   [ Qt Online Installer ]  ~/Qt/VERSI/gcc_64/...     <-- bila perlu versi tertentu
   [ build dari source ]    ~/qt-src/.../install/...  <-- bila perlu kontrol penuh

   Dicampur  -->  plugin dan pustaka dari dua versi saling bertabrakan
             -->  galat "Cannot mix incompatible Qt library ..."
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Qt Online Installer | Pemasang resmi Qt dari qt.io |
| Qt Account | Akun pengguna di qt.io untuk unduhan dan lisensi |
| Prefix path | Folder induk instalasi Qt |
| `CMAKE_PREFIX_PATH` | Variabel CMake untuk jalur pencarian paket |
| LSP / `qmlls` | Protokol server bahasa / server bahasa QML |
| IDE | Lingkungan pengembangan terpadu (Qt Creator) |
| `qt-cmake` | Pembungkus `cmake` bawaan Qt |

### i. Tips dan praktik terbaik

- Satu proyek, satu Qt. Catat sumber dan versi Qt di `catatan.md` atau README proyek.
- Setelah mengubah jalur Qt, hapus folder `build/` dan konfigurasi ulang dari nol.
- Bila perlu menguji versi minimum (6.8), pakai kontainer atau installer di folder terpisah, jangan menimpa paket sistem.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `Cannot mix incompatible Qt library ...` | Dua versi Qt dimuat bersamaan | Periksa `ldd` dan variabel `LD_LIBRARY_PATH`/`QT_PLUGIN_PATH`; satukan sumber |
| CMake menemukan Qt yang salah | `CMAKE_PREFIX_PATH` atau cache lama | Hapus `build/`, tetapkan prefix secara eksplisit |
| PySide6 dan aplikasi C++ memakai Qt berbeda | `pip` membawa Qt sendiri | Pakai `venv`; jangan campur proses |
| `qml: command not found` setelah memasang dari installer | Jalur `bin` Qt belum ada di `PATH` | Panggil dengan path penuh, atau tambah `PATH` hanya di sesi itu |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 0.2 (CMake mencari Qt), 0.3 (diagnosa jalur plugin dan pustaka), 12.2 (`qmlls` di editor), 13.3 (packaging: Qt mana yang disertakan), dan 14.5 (membangun Qt dari source untuk dibaca).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan seluruh perintah di bagian d dan catat hasilnya. Tuliskan di `catatan.md`: sumber Qt Anda, prefix-nya, dan lokasi `qml`, `qmllint`, `cmake`.

**Cek pemahaman.** (1) Mengapa kurikulum memilih paket distro? (2) Apa risiko mengatur `LD_LIBRARY_PATH` global untuk Qt installer? (3) Perintah apa yang membuktikan Qt mana yang dimuat sebuah executable?

### m. Referensi

- [Download Qt](https://www.qt.io/download) · [Getting Started with Qt](https://doc.qt.io/qt-6/gettingstarted.html)
- [Building Qt Sources](https://doc.qt.io/qt-6/build-sources.html)
- [Qt Creator Manual](https://doc.qt.io/qtcreator/index.html) · [Qt Design Studio](https://doc.qt.io/qtdesignstudio/index.html)
- [qmlls: QML Language Server](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html)
- [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt)

---

## 5.7 Penutup Modul 0.1

**Daftar isi bagian ini:** 5.7.1 Peta konsep · 5.7.2 Latihan terpadu · 5.7.3 Cek pemahaman modul · 5.7.4 Hubungan ke modul berikutnya · 5.7.5 Pembaruan yang diusulkan untuk kurikulum · 5.7.6 Status dan langkah berikutnya

### 5.7.1 Peta konsep

```
   0.1.1 Qt / QML / Qt Quick  (nama dan peran)
            |
   0.1.2 Modul + status + paket Arch
            |
      +-----+------+
      v            v
   0.1.3 Lisensi   0.1.4 Rilis, LTS, kompatibilitas
      |            |
      +-----+------+
            v
   0.1.5 Dokumentasi Qt 6 + jebakan Qt 5
            |
      +-----+------+
      v            v
   0.1.6 Quick vs Widgets   0.1.7 Sumber Qt dan perkakas
            |
            v
        Modul 0.2 (build pertama)
```

### 5.7.2 Latihan terpadu

Di `~/Development/qt-learning/01-ekosistem` (30 menit): (1) jalankan contoh binding di 0.1.1 dan Percobaan A, B, C di 0.1.5; (2) tulis di `catatan.md` tabel pribadi: modul yang akan Anda pakai, URI import, komponen CMake, paket Arch, lisensi (dari `pacman -Qi`), dan sejak versi Qt berapa; (3) catat sumber dan versi Qt Anda (0.1.4 dan 0.1.7); (4) commit dengan pesan yang bermakna (0.0.6).

### 5.7.3 Cek pemahaman modul

1. Bedakan Qt, QML, Qt Quick, dan Qt Quick Controls dalam satu kalimat masing-masing.
2. Tulis hubungan deklaratif “lebar dua kali tinggi” dan jelaskan mengapa ia lebih baik daripada handler imperatif.
3. Apa arti status Technology Preview, dan mengapa ia tidak cocok untuk produk?
4. Mengapa aplikasi tertutup yang memakai Qt Quick 3D memerlukan perhatian khusus soal lisensi?
5. Apakah dukungan LTS berarti patch gratis untuk semua? Jelaskan.
6. Aplikasi dibangun dengan Qt 6.8 dan dijalankan dengan Qt 6.12: aman? Sebaliknya?
7. Mengapa import `QtQuick` tanpa nomor versi tetap valid di Qt 6, dan kapan nomor versi masih berguna?
8. Sebutkan tiga jebakan Qt 5 yang dapat Anda kenali dari sebuah tutorial.
9. Apa beda `QApplication` dan `QGuiApplication`?
10. Bagaimana membuktikan Qt mana yang dimuat sebuah executable?

### 5.7.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 0.1 |
| --- | --- |
| 0.2 Build pertama | Nama modul dan komponen CMake (0.1.2), versi minimum (0.1.4), pilihan `QGuiApplication` (0.1.6), sumber Qt (0.1.7) |
| 0.3 Runtime dan diagnosa | Peta lapisan (5.4), plugin platform dan paket (0.1.2), jalur Qt (0.1.7) |
| Fase 1 Bahasa QML | Pemahaman deklaratif vs imperatif dan binding (0.1.1), membaca dokumentasi (0.1.5) |
| Fase 11 Rendering dan performa | `qmltc`, `qmlcachegen`, `qmlsc` dan lisensinya (0.1.3) |
| Fase 13 Keamanan dan deployment | Lisensi, SBOM, siklus rilis, pembaruan keamanan (0.1.3, 0.1.4) |

### 5.7.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda sebagai pengganti bagian yang sesuai pada Modul 0.1.

**Deskripsi.** Memetakan hubungan Qt, QML, JavaScript, Qt Quick, Qt Quick Controls, dan C++ (diagram di Bagian 1), kategori modul dan statusnya (Essentials, Add-Ons, Technology Preview, Deprecated), lisensi, siklus rilis dan LTS, serta cara membaca dokumentasi Qt 6.

**Terminologi (pengganti LTS dan lisensi).** LTS (Long-Term Support): setiap minor keempat sejak Qt 6.8, dukungan komersial lima tahun; patch LTS lanjutan segera hanya untuk pelanggan komersial (mis. Qt 6.8.8). Lisensi: Qt tersedia secara komersial, LGPLv3, dan GPLv3; pada Qt open source, empat belas modul (antara lain Quick 3D, Graphs, Canvas Painter, Quick Timeline, Lottie, Virtual Keyboard) hanya tersedia di bawah GPLv3. Di antara kompiler QML, qmltc dan qmlcachegen tersedia untuk semua; qmlsc hanya komersial.

**Daftar isi.** 0.1.1 Qt, QML, dan Qt Quick · 0.1.2 Modul inti, add-on, status modul, peta paket Arch · 0.1.3 Lisensi dan edisi · 0.1.4 Siklus rilis, LTS, janji kompatibilitas · 0.1.5 Membaca dokumentasi Qt 6 dan jebakan Qt 5 · 0.1.6 Qt Quick dibanding Qt Widgets dan bahasa lain · 0.1.7 Sumber Qt dan perkakas

**Kesalahan umum (tambahan).** Mengira semua modul LGPL; mengira LTS berarti patch gratis; memakai modul Technology Preview atau Labs di produk; mencampur Qt dari dua sumber; memakai QtGraphicalEffects atau proyek qmake untuk proyek baru.

**Cek pemahaman (koreksi no. 2).** Mengapa nomor versi pada import Qt 6 bersifat opsional, dan kapan masih berguna menuliskannya?

### 5.7.6 Status dan langkah berikutnya

| Bagian | Status |
| --- | --- |
| Modul 0.0 (0.0.1–0.0.9) | Selesai |
| Modul 0.1 (0.1.1–0.1.7) | **Selesai** |
| Modul 0.2 — Build Pertama: Dari Satu File ke Proyek CMake | Berikutnya, menunggu konfirmasi |
| Modul 0.3 — Runtime, Bootstrap, dan Diagnosa Lingkungan | Setelah 0.2 |

---

## 6. Modul 0.2 — Build Pertama: Dari Satu File ke Proyek CMake

**Daftar isi bagian ini:** 6.1 Audit Modul 0.2 · 6.2 Deskripsi dan peran · 6.3 Filosofi modul · 6.4 Visual: dari file ke jendela · 6.5 Daftar isi sub-bagian yang diperbarui · 6.6 Estimasi waktu · lalu 0.2.1 sampai 0.2.8

### 6.1 Audit Modul 0.2

Diperiksa pada 5 November 2026 terhadap dokumentasi resmi Qt 6.12 (`qt_add_qml_module`, `qt_standard_project_setup`, kebijakan CMake Qt, QML Language Server) dan contoh *Building a QML application*. Saya tidak menjalankan build di mesin Anda; isi folder `build/` karena itu ditandai **\[amati\]**, artinya buktikan dengan `ls`.

**Terverifikasi (tidak perlu diubah):**

- Di Qt 6, tipe `Window` cukup dengan `import QtQuick`. Halaman tipe `Window` menyebut baris impor itu, dan plugin `QtQuick.Window` dihapus pada pengembangan Qt 6. Ini menutup tanda **\[uji dulu\]** di tabel jebakan Qt 5 (0.1.5-f).
- `loadFromModule` ada sejak Qt 6.5, dan berkas yang dimuat harus berawalan huruf besar (`Main.qml`).
- Bila executable menjadi *backing target* modul QML, tidak ada plugin yang dibuat. `qmlcachegen` berjalan otomatis, dan dibuat target `<target>_qmllint` serta `all_qmllint`.
- `qt_standard_project_setup(REQUIRES 6.8)` mengaktifkan kebijakan QTP0001 sampai QTP0005. QTP0001 membuat awalan resource bawaan menjadi `:/qt/qml/`, yaitu jalur impor bawaan engine. Inilah alasan `loadFromModule` menemukan modul tanpa pengaturan tambahan.

**Perlu dikoreksi atau dilengkapi:**

1. **URI dan nama target hanya berbeda huruf besar-kecil.** Contoh kurikulum memakai target `hello` dan URI `Hello`. Panduan migrasi resmi Qt menyatakan URI modul harus berbeda dari nama target agar tidak bertabrakan di folder build. Alasannya nyata: untuk executable, folder keluaran modul bawaan adalah *target path* (URI dengan titik diganti garis miring) di bawah folder build, yaitu `build/Hello`, sedangkan executable-nya `build/hello`. Di Linux (nama berkas peka huruf besar-kecil) keduanya berbeda, tetapi di macOS dan Windows (umumnya tidak peka) keduanya bentrok. **Saran:** target `apphello`, URI `Hello`. Seluruh Modul 0.2 memakai nama ini; contoh `./build/hello` di bagian lain kurikulum menjadi `./build/apphello`.
2. **`VERSION 1.0` tidak diperlukan.** Dokumentasi menyarankan menghilangkan `VERSION` bila tidak butuh, karena versi internal modul QML punya kelemahan mendasar; bawaannya versi tertinggi. Pada modul aplikasi, `VERSION` hanya menambah hal yang harus dijaga.
3. **Standar C++ tidak dinyatakan.** Contoh resmi menetapkan `CMAKE_CXX_STANDARD 17` dan `CMAKE_CXX_STANDARD_REQUIRED ON`. Ditambahkan agar niat proyek terbaca jelas.
4. **`find_package` tanpa versi.** Contoh resmi menulis `find_package(Qt6 6.5 ...)` bersama `qt_standard_project_setup(REQUIRES 6.5)`. Padanan bagi kurikulum ini: `find_package(Qt6 6.8 ...)`.
5. **Alat kerja yang belum ada:** `.gitignore` untuk `build/` (sudah dijanjikan di 0.0.6), `compile_commands.json`, CMake Presets, cara menghubungkan `qmlls` ke build, dan tipe build serta peringatan kompilator. Ditambahkan sebagai 0.2.7 dan 0.2.8.
6. **Urutan penjelasan.** Kurikulum menaruh “configure, build, run” di 0.2.5, padahal 0.2.2 sudah memakainya. Model dua tahap itu kini diperkenalkan sejak 0.2.1.
7. **Catatan Qt 6.12.** `qt_add_qml_module` mendapat opsi `NO_GENERATE_QTCONF` dan `NO_GENERATE_AOT_VALIDATION` (keduanya sejak 6.12), dan kebijakan QTP0006 sampai QTP0008 ditambahkan. Tidak mengubah contoh inti; dicatat di 0.2.4 dan 0.2.8.

### 6.2 Deskripsi dan peran dalam kurikulum

Modul ini mengubah Anda dari penguji satu berkas (`qml Main.qml`) menjadi pembangun proyek: Anda akan memahami setiap berkas dan baris yang membuat sebuah aplikasi Qt Quick lahir dari tiga berkas kecil, bagaimana C++ menemukan QML, dan bagaimana menambah berkas baru tanpa tersesat. Hampir semua fase berikutnya (modul QML di Fase 8, C++ di Fase 10, rendering di Fase 11, deployment di Fase 13) berdiri di atas pola ini.

### 6.3 Filosofi modul

**Deskripsikan, jangan perintahkan.** CMake sama seperti QML: Anda menyatakan *apa* yang ada (target, sumber, hubungan) dan alat yang memutuskan *bagaimana* membangunnya. **Pisahkan yang dibuat manusia dari yang dibuat mesin.** Source adalah milik Anda dan masuk git; folder `build/` milik mesin, boleh dihapus kapan saja dan tidak pernah di-commit.

### 6.4 Visual: dari file ke jendela

```
  TULISAN ANDA                 PERENCANA            PEMASAK              HASIL
  ----------------             ----------           ---------            -----------
  CMakeLists.txt  ---+
  main.cpp           +-->  cmake (configure)  --> build.ninja --> ninja --> build/apphello
  Main.qml        ---+     membaca resep,         daftar tugas   menjalankan   (executable)
                           mencari Qt             lengkap        moc, rcc,
                                                                 qmlcachegen,
                                                                 g++, linker
                                                                       |
                                                  ./build/apphello ----+----> jendela Qt Quick
```

### 6.5 Daftar isi sub-bagian yang diperbarui

| No. | Judul | Asal |
| --- | --- | --- |
| 0.2.1 | Struktur proyek dan model kerja CMake | Asli 0.2.1, diperluas |
| 0.2.2 | `CMakeLists.txt` baris demi baris | Asli 0.2.2 |
| 0.2.3 | `main.cpp` dan engine | Asli 0.2.3 |
| 0.2.4 | Modul QML dan URI | Asli 0.2.4 |
| 0.2.5 | Configure, build, run | Asli 0.2.5 |
| 0.2.6 | Mendaftarkan file baru (`QML_FILES`, `SOURCES`, `RESOURCES`) | Asli 0.2.6 |
| 0.2.7 | Alat kerja proyek: compile\_commands, Presets, lint, qmlls | **\[TAMBAHAN\]** |
| 0.2.8 | Build bersih dan aman: tipe build, peringatan, .gitignore, diagnosa | **\[TAMBAHAN\]** |

### 6.6 Estimasi waktu

Jalur A: 10–14 jam; Jalur B: 4–5 jam (0.2.7 dan 0.2.8 dapat dibaca sekilas).

---

## 0.2.1 Struktur proyek dan model kerja CMake

*Semangat: yang tahu persis isi setiap berkasnya tidak akan takut pada build.*

**Daftar isi 0.2.1:** a. Deskripsi dan peran · b. Konsep dan analogi · c. Fondasi: out-of-source, generator, cache · d. Contoh: membuat kerangka proyek · e. Isi folder build **\[amati\]** · f. Opsi struktur lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Bagian ini memperkenalkan tiga berkas yang menjadi tulang punggung aplikasi, dan model kerja yang membuatnya hidup. Memahami model ini lebih dulu menjadikan 0.2.2 sampai 0.2.8 terasa seperti variasi, bukan misteri baru.

### b. Konsep dan analogi

**CMake adalah perencana; Ninja adalah juru masak.** CMake membaca resep (`CMakeLists.txt`), mencari bahan (Qt, kompilator), lalu menulis daftar tugas lengkap (`build.ninja`). Ninja hanya mengerjakan daftar itu secepat mungkin dan hanya yang perlu dikerjakan ulang. Anda hampir tidak pernah menulis perintah kompilator sendiri.

| Berkas | Peran | Dibaca oleh |
| --- | --- | --- |
| `CMakeLists.txt` | Resep: target apa, sumber apa, bergantung pada apa | CMake saat configure |
| `main.cpp` | Titik masuk C++: membuat aplikasi dan engine, memuat QML | Kompilator C++ |
| `Main.qml` | Antarmuka: objek, properti, binding | Engine QML saat aplikasi berjalan (juga dikompilasi menjadi cache bytecode saat build) |

### c. Fondasi: out-of-source, generator, cache

- **Build di luar folder source (*out-of-source*).** Semua berkas buatan mesin ditaruh di folder terpisah (`build/`). Source tetap bersih, dan Anda dapat menghapus `build/` tanpa kehilangan pekerjaan.
- **Dua tahap.** *Configure* (`cmake -S . -B build`): CMake menjalankan `CMakeLists.txt` dari atas ke bawah seperti skrip, mencari Qt, dan menghasilkan berkas untuk alat build (generator). *Build* (`cmake --build build`): alat build (Ninja) menjalankan perintah sebenarnya.
- **Generator** menentukan format daftar tugas: `Ninja` (cepat, disarankan), `Unix Makefiles` (klasik). Ia dipilih sekali saat configure.
- **Cache** (`build/CMakeCache.txt`) menyimpan pilihan seperti tipe build dan lokasi Qt, sehingga configure berikutnya cepat dan konsisten. Pilihan dari `-D...` tersimpan di sini.
- Qt menambahkan tahap otomatis di dalam build: **moc** (menghasilkan kode meta-object untuk kelas C++ ber-`Q_OBJECT`), **rcc** (menanam berkas ke dalam executable sebagai resource), **qmlcachegen** (mengompilasi QML menjadi bytecode), dan pencatat tipe untuk QML. Semuanya dipicu oleh `qt_standard_project_setup` dan `qt_add_qml_module`.

### d. Contoh: membuat kerangka proyek

```bash
$ mkdir -p ~/Development/qt-learning/hello && cd ~/Development/qt-learning/hello
$ touch CMakeLists.txt main.cpp Main.qml
$ cat > .gitignore << 'EOF'
build/
.cache/
compile_commands.json
CMakeLists.txt.user
EOF
$ ls -A
$ git status
```

| Bagian | Arti |
| --- | --- |
| `mkdir -p ... && cd ...` | Buat folder proyek lalu masuk (0.0.3). |
| `touch` | Membuat tiga berkas kosong yang akan kita isi di 0.2.2–0.2.4. |
| `cat > .gitignore << 'EOF'` | Menulis daftar yang tidak boleh dilacak git (0.0.6). |
| `build/` | Abaikan folder bernama `build` di kedalaman mana pun. |
| `.cache/` | Abaikan cache alat bahasa (clangd) yang akan muncul di 0.2.7. |
| `compile_commands.json` | Abaikan berkas sambungan untuk editor (0.2.7). |
| `CMakeLists.txt.user` | Abaikan pengaturan pribadi Qt Creator bila Anda memakainya. |
| `ls -A` | Lihat semua berkas termasuk yang tersembunyi, kecuali `.` dan `..`. |
| `git status` | Pastikan hanya berkas yang Anda maksud yang akan dilacak. |

Bila repositori induk `qt-learning` sudah punya `.gitignore` berisi `build/`, aturan itu sudah berlaku untuk subfolder; berkas kedua ini tetap berguna sebagai dokumentasi proyek.

### e. Isi folder build \[amati\]

Setelah 0.2.5 selesai, jalankan `ls -A build`. Anda akan melihat antara lain: `build.ninja` (daftar tugas), `CMakeCache.txt` (cache), `CMakeFiles/` (catatan internal), `apphello` (executable), `apphello_autogen/` (keluaran moc), dan `Hello/` (berkas modul QML hasil generate: `qmldir` dan berkas tipe). Isi pasti dapat berbeda antar versi; tujuan latihannya ialah membiasakan diri **melihat** apa yang diproduksi mesin.

### f. Opsi struktur lain

| Struktur | Cocok untuk | Catatan |
| --- | --- | --- |
| Datar (kurikulum ini) | Proyek kecil dan pembelajaran | Semua berkas di satu folder |
| `src/` dan `qml/` | Proyek menengah | Pisahkan C++ dari QML; atur path di `CMakeLists.txt` |
| Satu folder per modul QML, masing-masing punya `CMakeLists.txt` | Aplikasi besar | Dibahas di Modul 8; dokumentasi menyarankan struktur sumber mengikuti URI modul |
| Monorepo dengan beberapa aplikasi dan pustaka | Organisasi besar | `add_subdirectory` |
| Build di dalam folder source (*in-source*) | **Hindari** | Mengotori source, menyulitkan git |

### g. Visual

```
  hello/                            <-- yang Anda tulis dan commit
  |-- CMakeLists.txt
  |-- main.cpp
  |-- Main.qml
  |-- .gitignore
  '-- build/                        <-- yang mesin buat; JANGAN di-commit
      |-- CMakeCache.txt
      |-- build.ninja
      |-- apphello                  <-- executable
      '-- Hello/ (qmldir, ...)      <-- berkas modul QML hasil generate
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| CMake | Generator sistem build: membaca `CMakeLists.txt`, menghasilkan berkas untuk alat build |
| Ninja | Alat build cepat yang menjalankan daftar tugas |
| Generator | Format keluaran CMake (`Ninja`, `Unix Makefiles`) |
| Configure / generate / build | Membaca resep / menulis daftar tugas / menjalankannya |
| Out-of-source | Build di folder terpisah dari source |
| Cache | `CMakeCache.txt`, tempat pilihan konfigurasi disimpan |
| Target | Satuan yang dibangun: executable, pustaka |
| moc / rcc / qmlcachegen | Alat Qt di dalam build: meta-object / resource / bytecode QML |

### i. Tips dan praktik terbaik

- Satu proyek, satu `build/`. Untuk varian lain, pakai folder berbeda (`build-release/`) dan tambahkan ke `.gitignore`.
- Sebelum `rm -rf build`, jalankan `pwd` dan baca perintahnya sekali lagi (0.0.3).
- Jangan menyunting apa pun di dalam `build/`; semuanya akan dibuat ulang.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `CMakeCache.txt` ada di folder source | Menjalankan `cmake .` (in-source) | Hapus berkas buatan itu dan ulangi dengan `-S . -B build` |
| `build/` ikut ter-commit | `.gitignore` belum ada | Buat `.gitignore`; `git rm -r --cached build` |
| Hasil build aneh setelah mengganti Qt atau kompilator | Cache lama | Hapus `build/` dan configure ulang |
| Menyunting `build.ninja` | Mengira itu resep | Itu keluaran; ubah `CMakeLists.txt` |

### k. Hubungan dengan modul lain

Prasyarat untuk seluruh 0.2.2–0.2.8, Modul 0.3 (diagnosa berawal dari pengetahuan tentang apa yang dibuat build), Modul 8.3 (struktur multi-modul), dan Modul 13.3 (instalasi dan packaging).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat kerangka proyek seperti di bagian d, lalu `git add .gitignore` dan commit. Setelah 0.2.5, kembali ke bagian e dan catat isi `build/` milik Anda.

**Cek pemahaman.** (1) Apa beda configure dan build? (2) Mengapa `build/` tidak boleh di-commit? (3) Apa yang disimpan `CMakeCache.txt`?

### m. Referensi

- [CMake: Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html) · [cmake(1)](https://cmake.org/cmake/help/latest/manual/cmake.1.html)
- [CMake: Generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html) · [Ninja manual](https://ninja-build.org/manual.html)
- [Qt: Build with CMake](https://doc.qt.io/qt-6/cmake-manual.html) · [CMake Integration for QML](https://doc.qt.io/qt-6/qtqml-cmake-integration.html)
- [Arch Wiki: CMake](https://wiki.archlinux.org/title/CMake)

---

## 0.2.2 CMakeLists.txt baris demi baris

*Semangat: setiap baris yang Anda pahami adalah satu rahasia yang tidak lagi menakutkan.*

**Daftar isi 0.2.2:** a. Deskripsi dan peran · b. Mini-primer bahasa CMake · c. Berkas lengkap · d. Penjelasan baris demi baris · e. Beda dengan versi kurikulum · f. PRIVATE, PUBLIC, INTERFACE · g. Opsi lain menulis berkas yang sama · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

`CMakeLists.txt` adalah resep proyek. Pada Qt 6 resep ini pendek karena Qt menyediakan perintah tingkat tinggi. Memahami tiap barisnya membuat Anda mampu memperbaikinya sendiri ketika build gagal.

### b. Mini-primer bahasa CMake

CMake adalah bahasa skrip kecil yang dijalankan *sekali* saat configure, dari atas ke bawah.

| Unsur | Contoh | Arti |
| --- | --- | --- |
| Perintah | `project(HelloQt LANGUAGES CXX)` | Nama perintah (tidak peka huruf besar-kecil), lalu argumen dalam tanda kurung, dipisahkan spasi |
| Kata kunci | `REQUIRED`, `PRIVATE`, `URI` | Penanda khusus yang biasanya ditulis huruf besar; membuat argumen berikutnya bermakna |
| Variabel | `set(CMAKE_CXX_STANDARD 17)` dan `${CMAKE_CXX_STANDARD}` | Nilai bernama; dibaca dengan `${...}` |
| Target | `apphello` | Satuan yang dibangun (executable atau pustaka) |
| Properti | `AUTOMOC`, `LINK_LIBRARIES` | Pengaturan yang menempel pada target |
| Komentar | `# catatan` | Diabaikan |

Cara pandang modern (*target-based*): jangan mengatur variabel global untuk segalanya; buat target, lalu tempelkan sumber, pustaka, dan opsi **pada target itu**.

### c. Berkas lengkap (versi yang disarankan)

```cmake
cmake_minimum_required(VERSION 3.21)
project(HelloQt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(apphello main.cpp)

qt_add_qml_module(apphello
    URI Hello
    QML_FILES Main.qml
)

target_link_libraries(apphello PRIVATE Qt6::Quick)
```

### d. Penjelasan baris demi baris

| Baris | Penjelasan |
| --- | --- |
| `cmake_minimum_required(VERSION 3.21)` | Menyatakan versi CMake terendah yang boleh membaca berkas ini dan mengaktifkan perilaku (*policy*) CMake sesuai versi itu. Selalu baris pertama. Bila CMake terpasang lebih tua, configure berhenti dengan pesan jelas. 3.21 juga cukup baru untuk Presets versi 3 (0.2.7). |
| `project(HelloQt VERSION 0.1 LANGUAGES CXX)` | Menamai proyek (`HelloQt`), memberi versi, dan menyatakan bahasa yang dipakai: hanya C++. Membatasi bahasa mempercepat configure karena CMake tidak mencari kompilator C. Nama proyek berbeda dari nama target. |
| `set(CMAKE_CXX_STANDARD 17)` | Meminta standar C++17 (Qt 6 memerlukan C++17 atau lebih baru). |
| `set(CMAKE_CXX_STANDARD_REQUIRED ON)` | Bila kompilator tidak mendukung C++17, berhenti, jangan diam-diam turun standar. |
| `find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)` | Mencari paket Qt 6 versi minimal 6.8. CMake mencari berkas `Qt6Config.cmake` di jalur sistem dan di `CMAKE_PREFIX_PATH`. `REQUIRED` menghentikan configure bila tidak ketemu. `COMPONENTS Quick` memuat modul Qt Quick sekaligus modul yang diandalkannya (Qml, Gui, Core). Hasilnya: target seperti `Qt6::Quick` dan perintah seperti `qt_add_qml_module`. |
| `qt_standard_project_setup(REQUIRES 6.8)` | Mengatur bawaan proyek Qt (dokumentasi resmi): `CMAKE_AUTOMOC` dan `CMAKE_AUTOUIC` aktif bila belum ditetapkan; modul `GNUInstallDirs` dimuat; `CMAKE_INSTALL_RPATH` dilengkapi di platform selain Apple dan Windows; folder IDE diaktifkan. `REQUIRES 6.8` mengaktifkan kebijakan Qt QTP0001 sampai QTP0005 dan membuat Qt yang lebih lama dari 6.8 menjadi error. Harus dipanggil setelah `find_package(Qt6)` dan sebelum target dibuat. |
| `qt_add_executable(apphello main.cpp)` | Membuat target executable `apphello` dari `main.cpp` dan menyelesaikan pengaturan khusus platform (pembungkus untuk `add_executable` yang aman untuk Qt). Nama target juga menjadi nama berkas hasil: `build/apphello`. |
| `qt_add_qml_module(apphello ...)` | Menjadikan target `apphello` sebuah **modul QML**. Dibahas rinci di 0.2.4. |
| `URI Hello` | Nama modul. Tidak boleh sama dengan nama target. |
| `QML_FILES Main.qml` | Daftar berkas QML modul. Berkas ini dikompilasi menjadi bytecode, ditanam ke executable, dan diperiksa `qmllint` lewat target `apphello_qmllint`. |
| `target_link_libraries(apphello PRIVATE Qt6::Quick)` | Menautkan `apphello` dengan pustaka Qt Quick; juga membawa folder header dan opsi kompilasi yang dibutuhkan. `PRIVATE` dijelaskan di bagian f. |

### e. Beda dengan versi kurikulum

| Versi kurikulum | Versi di sini | Alasan |
| --- | --- | --- |
| `qt_add_executable(hello ...)` | `qt_add_executable(apphello ...)` | URI harus berbeda dari nama target (0.2.4) |
| `find_package(Qt6 REQUIRED ...)` | `find_package(Qt6 6.8 REQUIRED ...)` | Versi minimum dinyatakan di tempat yang dibaca CMake |
| Tanpa standar C++ | `CMAKE_CXX_STANDARD 17` dan `..._REQUIRED ON` | Niat proyek terbaca jelas; mengikuti contoh resmi |
| `VERSION 1.0` pada modul | Dihilangkan | Dokumentasi menyarankan menghilangkan `VERSION` bila tidak perlu |
| `project(HelloQt LANGUAGES CXX)` | Ditambah `VERSION 0.1` | Versi proyek berguna untuk packaging (Modul 13.3) |

### f. PRIVATE, PUBLIC, INTERFACE

Kata kunci pada `target_link_libraries` menjawab: *siapa yang butuh pustaka ini?*

| Kata kunci | Arti | Contoh |
| --- | --- | --- |
| `PRIVATE` | Hanya target ini yang memakainya | Executable menaut Qt Quick |
| `PUBLIC` | Target ini **dan** yang menaut ke target ini | Pustaka yang header-nya memakai Qt |
| `INTERFACE` | Hanya yang menaut ke target ini | Pustaka hanya-header |

Pada executable yang tidak dipakai target lain, `PRIVATE` adalah pilihan yang benar.

### g. Opsi lain menulis berkas yang sama

| Pendekatan | Gambaran | Kapan |
| --- | --- | --- |
| Perintah Qt tingkat tinggi (di sini) | `qt_add_executable` dan `qt_add_qml_module` | Standar Qt 6; disarankan |
| Perintah CMake dasar | `add_executable`, lalu `qt_add_resources` dan sebagainya secara manual | Memahami apa yang terjadi di balik layar; kontrol penuh, lebih panjang |
| Target tanpa versi | `find_package(Qt REQUIRED ...)` dan `Qt::Quick` | Kode yang harus dibangun dengan Qt 5 dan 6 sekaligus |
| Proyek `qmake` (`.pro`) | `QT += quick` | Warisan; untuk proyek baru gunakan CMake |
| Pustaka terpisah | Modul di pustaka sendiri | Modul 8: untuk aplikasi besar |

### h. Visual

```
  project(HelloQt)
      |
  find_package(Qt6 6.8 ...)  ---> menyediakan: Qt6::Quick, qt_add_executable,
      |                                         qt_add_qml_module, ...
  qt_standard_project_setup(REQUIRES 6.8)  ---> AUTOMOC, RPATH, kebijakan QTP0001-0005
      |
  qt_add_executable(apphello)  ---> TARGET apphello (executable)
      |
  qt_add_qml_module(apphello URI Hello ...)  ---> apphello menjadi modul QML "Hello"
      |
  target_link_libraries(apphello PRIVATE Qt6::Quick)  ---> menaut Qt Quick
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Target | Satuan yang dibangun dengan sumber, opsi, dan hubungan |
| Backing target | Target yang menampung isi sebuah modul QML (di sini executable) |
| Properti target | Pengaturan melekat pada target |
| Policy | Saklar perilaku CMake atau Qt yang menjaga kompatibilitas |
| `Qt6::Quick` | Target impor hasil `find_package`, mewakili pustaka Qt Quick |
| AUTOMOC | Menjalankan moc otomatis pada berkas yang membutuhkannya |
| RPATH | Jalur pencarian pustaka yang ditanam di executable |

### j. Tips dan praktik terbaik

- Pakai gaya target-based: sumber, pustaka, dan opsi selalu ditempelkan pada target, bukan pada variabel global.
- Hindari `file(GLOB ...)` untuk daftar sumber: CMake tidak tahu berkas baru muncul sehingga build tidak diperbarui; tulis daftar secara eksplisit (0.2.6).
- Tulis satu argumen per baris bila panjang, dan jaga pembatas indentasi agar mudah di-diff di git.
- Pin versi minimum Qt di `find_package` **dan** `qt_standard_project_setup(REQUIRES ...)` dengan angka yang sama.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `Could not find a package configuration file provided by "Qt6"` | Qt tidak di jalur pencarian | Pasang `qt6-base`/`qt6-declarative`, atau tetapkan `-DCMAKE_PREFIX_PATH=...` (0.1.7) |
| `Unknown CMake command "qt_add_qml_module"` | Komponen `Qml` tidak dimuat | Pastikan `COMPONENTS Quick` (Quick memuat Qml) atau tambahkan `Qml` |
| `qt_standard_project_setup` dipanggil setelah target dibuat | Urutan salah | Panggil tepat setelah `find_package(Qt6)` |
| `undefined reference to ...` saat tautan | Lupa `target_link_libraries` | Tambahkan pustaka Qt yang dipakai kode |
| Hasil build tidak mengikuti perubahan | Cache lama | Hapus `build/` dan configure ulang |
| Salah mengetik nama target di `target_link_libraries` | Target tidak ada, CMake menganggapnya nama pustaka | Samakan persis dengan nama di `qt_add_executable` |

### l. Hubungan dengan modul lain

Prasyarat untuk 0.2.3 (kode C++ yang dibangun target ini), 0.2.4 (modul QML), 0.2.6 (menambah berkas), Modul 8.3 (CMake multi-modul), Modul 10.3 (registrasi C++ lewat `SOURCES`), dan Modul 13.3 (perintah `install`).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Isi `CMakeLists.txt` dengan versi di bagian c. Pada salinan terpisah, ubah satu baris dengan sengaja (misalnya `find_package(Qt6 9.9 ...)`, atau salah ketik `COMPONENTS Quik`) dan catat pesan error CMake. Kembalikan ke versi benar.

**Cek pemahaman.** (1) Mengapa nama target dan URI harus berbeda? (2) Apa yang `REQUIRES 6.8` lakukan? (3) Apa bedanya `PRIVATE` dan `PUBLIC`?

### n. Referensi

- [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [qt\_standard\_project\_setup](https://doc.qt.io/qt-6/qt-standard-project-setup.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html)
- [Qt CMake policies](https://doc.qt.io/qt-6/qt-cmake-policies.html) · [qt\_policy](https://doc.qt.io/qt-6/qt-policy.html)
- [CMake: cmake-language](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html) · [target\_link\_libraries](https://cmake.org/cmake/help/latest/command/target_link_libraries.html) · [find\_package](https://cmake.org/cmake/help/latest/command/find_package.html)
- [Qt: Get started with CMake](https://doc.qt.io/qt-6/cmake-get-started.html)

---

## 0.2.3 main.cpp dan engine

*Semangat: dua puluh baris C++ yang paling sering Anda tulis, dan sekali dipahami tidak perlu dibuka lagi.*

**Daftar isi 0.2.3:** a. Deskripsi dan peran · b. Konsep: aplikasi, engine, event loop · c. Kode lengkap · d. Penjelasan kata demi kata · e. Mengapa `QueuedConnection` dan `exit(-1)` · f. Opsi lain memuat QML · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

`main.cpp` adalah jembatan antara sistem operasi dan QML. Tugasnya hanya tiga: membuat objek aplikasi, membuat engine QML dan memintanya memuat tipe `Main`, lalu menjalankan event loop. Pada proyek besar pun file ini hampir tidak berubah; kerumitan hidup di QML dan di kelas C++ lain.

### b. Konsep: aplikasi, engine, event loop

- **Objek aplikasi** (`QGuiApplication`) mengelola hal-hal yang berlaku untuk seluruh proses: argumen baris perintah, koneksi ke sistem jendela, dan **event loop** (0.0.2). Tanpanya tidak ada jendela dan tidak ada input.
- **Engine QML** (`QQmlApplicationEngine`) membaca dokumen QML, membuat objek yang dideskripsikannya, dan menjaga binding tetap hidup. Bila dokumen berakar `Window` atau `ApplicationWindow`, jendelanya otomatis ditampilkan.
- Urutan wajib: aplikasi dibuat **sebelum** engine, dan `exec()` dipanggil **terakhir**.

### c. Kode lengkap

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Hello", "Main");   // [≥6.5]

    return app.exec();
}
```

### d. Penjelasan kata demi kata

| Bagian | Arti |
| --- | --- |
| `#include <QGuiApplication>` | Menyalin deklarasi kelas aplikasi untuk program tanpa Widgets (0.1.6). |
| `#include <QQmlApplicationEngine>` | Menyalin deklarasi engine. |
| `int main(int argc, char *argv[])` | Titik masuk (0.0.1). `argc` jumlah argumen; `argv` daftar argumennya sebagai teks C. Qt membaca opsinya sendiri dari sini, misalnya `-platform offscreen` (0.3). |
| `QGuiApplication app(argc, argv);` | Membuat objek aplikasi di tumpukan (*stack*); hidupnya sampai akhir `main`. |
| `QQmlApplicationEngine engine;` | Membuat engine. Dibuat setelah `app`, sehingga hancur lebih dulu. |
| `QObject::connect(` | Menghubungkan sebuah signal ke sebuah penerima (Fase 3 dan 10). |
| `&engine, &QQmlApplicationEngine::objectCreationFailed,` | Pengirim: `engine`; signal yang ditunggu: gagal membuat objek dari QML. Tanda `&` di depan nama kelas mengambil alamat fungsi anggota. |
| `&app,` | *Context object*: penerima. Bila `app` hancur, koneksi ikut putus. |
| `[]() { QCoreApplication::exit(-1); },` | **Lambda**: fungsi tanpa nama. `[]` tanpa tangkapan variabel, `()` tanpa parameter, isi di dalam `{}`. Dipanggil saat signal terpancar; meminta aplikasi keluar dengan kode -1. |
| `Qt::QueuedConnection);` | Jenis koneksi: panggilan lambda dijadwalkan lewat event loop, bukan langsung. |
| `engine.loadFromModule("Hello", "Main");` | Muat tipe QML `Main` dari modul `Hello`. Argumen pertama harus sama persis dengan `URI` di CMake; kedua adalah nama berkas tanpa `.qml`, berawalan huruf besar. Ada sejak Qt 6.5. |
| `return app.exec();` | Menjalankan event loop sampai aplikasi selesai; nilai kembaliannya menjadi exit code proses. |

### e. Mengapa `QueuedConnection` dan `exit(-1)`

Kegagalan dapat terjadi **di dalam** `loadFromModule`, yaitu sebelum `exec()` dipanggil. Pada saat itu event loop belum berjalan, dan `QCoreApplication::exit` yang dipanggil sebelum loop berjalan tidak berefek. Dengan `Qt::QueuedConnection`, panggilan ditunda sampai loop mulai, sehingga `exit(-1)` benar-benar dijalankan. Hasilnya: bila QML gagal dimuat, program berhenti dengan exit code kegagalan (nilai -1 tampak sebagai 255 di shell), bukan menggantung dengan jendela kosong atau tanpa jendela. Anda dapat membuktikannya dengan `echo $?` (0.0.3).

### f. Opsi lain memuat QML

```cpp
// Opsi 1 — memuat lewat URL resource (gaya lama, tetap sah)
const QUrl url(QStringLiteral("qrc:/qt/qml/Hello/Main.qml"));
engine.load(url);
if (engine.rootObjects().isEmpty())
    return -1;

// Opsi 2 — satu jendela dari akar bertipe Item (butuh <QQuickView>)
QQuickView view;
view.setResizeMode(QQuickView::SizeRootObjectToView);
view.setSource(QUrl(QStringLiteral("qrc:/qt/qml/Hello/Main.qml")));
view.show();
```

| Pendekatan | Kelebihan | Kelemahan |
| --- | --- | --- |
| `loadFromModule` (disarankan) | Memakai nama modul, bukan path resource; tahan terhadap perubahan prefiks | Qt 6.5 ke atas |
| `engine.load(QUrl(...))` | Bekerja di Qt lama; path eksplisit | Bergantung pada prefiks resource; `rootObjects().isEmpty()` perlu dicek manual |
| `QQuickView` | Mudah dipakai untuk satu jendela | Akar harus `Item`, bukan `Window` |
| `QQuickWidget` | QML di dalam jendela Widgets (0.1.6) | Butuh `QApplication` dan Qt Widgets |
| Alat `qml` | Tanpa C++ sama sekali | Hanya untuk eksperimen (0.0.1) |
| `engine.addImportPath(...)` | Memuat modul di lokasi lain | Perlu tahu jalurnya; lihat 0.2.4 |

### g. Visual

```
  main()
    |
    +-- QGuiApplication app      <-- sistem jendela + event loop siap dibuat
    |
    +-- QQmlApplicationEngine engine
    |       |-- connect(objectCreationFailed --> exit(-1))   (dijadwalkan lewat loop)
    |       '-- loadFromModule("Hello", "Main")
    |              |-- cari modul Hello di jalur impor (qrc:/qt/qml)
    |              |-- temukan tipe Main (Main.qml)
    |              '-- buat objek akar (Window) --> tampil
    |
    '-- app.exec()               <-- loop berputar; klik, ketik, animasi
            |
            '-- jendela ditutup --> exec() kembali --> exit code
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| `argc` / `argv` | Jumlah argumen / daftar argumen program |
| `QGuiApplication` | Kelas aplikasi untuk program grafis tanpa Widgets |
| `QQmlApplicationEngine` | Engine yang memuat QML dan mengelola jendela aplikasi |
| Signal / slot | Pemberitahuan kejadian / penerimanya (Fase 3) |
| Lambda | Fungsi tanpa nama yang ditulis di tempat pemakaiannya |
| Context object | Objek yang masa hidupnya membatasi sebuah koneksi |
| `QueuedConnection` | Panggilan dijadwalkan lewat event loop penerima |
| Objek akar (root object) | Objek paling luar di dokumen QML |
| Exit code | Angka hasil proses; 0 sukses |

### i. Tips dan praktik terbaik

- Jaga `main.cpp` pendek. Logika bisnis ditaruh di kelas terpisah (Fase 10), bukan di `main`.
- Pertahankan pola `objectCreationFailed` dan `exit(-1)`: ia membuat kegagalan memuat QML terlihat di skrip dan CI.
- Selalu jalankan `echo $?` setelah menjalankan aplikasi untuk mengetahui apakah keluar bersih.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Proses berjalan tetapi tidak ada jendela | Akar QML bukan `Window` dan dimuat lewat `QQmlApplicationEngine` | Jadikan akar `Window` atau `ApplicationWindow` |
| Keluar langsung dengan 255 | Modul atau tipe gagal dimuat (`objectCreationFailed`) | Baca pesan di terminal: ejaan URI dan nama tipe; lihat 0.2.4 |
| `fatal error: QGuiApplication: No such file` | Qt tidak ditautkan atau jalur header tidak diatur | `target_link_libraries(... Qt6::Quick)`; periksa `find_package` |
| Jendela tidak pernah muncul dan program langsung selesai | Lupa `app.exec()` | Panggil `return app.exec();` |
| Crash saat menutup | Urutan hidup salah: engine dibuat sebelum aplikasi | Buat aplikasi dulu, baru engine |
| Tidak bisa memuat `main` | Nama tipe diawali huruf kecil | Nama berkas dan tipe diawali huruf besar |

### k. Hubungan dengan modul lain

Prasyarat untuk 0.2.4 (modul yang dimuat), Modul 0.3 (opsi `-platform` dan plugin platform), Modul 9.3 (memilih style sebelum engine dibuat), Modul 10.2 sampai 10.4 (memperkenalkan objek C++ ke QML), dan Modul 13.2 (integrasi OS).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** (1) Jalankan aplikasi dan catat `echo $?`. (2) Ubah argumen pertama menjadi `"Helo"`, bangun ulang, jalankan, dan catat pesan serta exit code. (3) Kembalikan. (4) Ubah argumen kedua menjadi `"main"` dan amati.

**Cek pemahaman.** (1) Mengapa `exit` diantrekan? (2) Mengapa `app` harus dibuat sebelum `engine`? (3) Apa yang terjadi bila akar QML adalah `Item` biasa?

### m. Referensi

- [QQmlApplicationEngine](https://doc.qt.io/qt-6/qqmlapplicationengine.html) · [QGuiApplication](https://doc.qt.io/qt-6/qguiapplication.html) · [QCoreApplication::exit](https://doc.qt.io/qt-6/qcoreapplication.html#exit)
- [Signals and Slots](https://doc.qt.io/qt-6/signalsandslots.html) · [Qt::ConnectionType](https://doc.qt.io/qt-6/qt.html#ConnectionType-enum)
- [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [QQuickView](https://doc.qt.io/qt-6/qquickview.html)
- [cppreference: Lambda expressions](https://en.cppreference.com/w/cpp/language/lambda)

---

## 0.2.4 Modul QML dan URI

*Semangat: nama yang tepat membuat semua bagian saling menemukan.*

**Daftar isi 0.2.4:** a. Deskripsi dan peran · b. Konsep: modul, URI, jalur impor · c. `Main.qml` kata demi kata · d. Satu nama, banyak tempat · e. Apa yang dibuat `qt_add_qml_module` **\[amati\]** · f. Mengamati sendiri · g. Opsi lain mengatur modul · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini menjawab pertanyaan kunci kurikulum: *di mana tipe `Main` didefinisikan dan bagaimana C++ menemukannya?* Jawabannya adalah modul QML: kumpulan tipe yang diberi nama (URI), dikemas ke dalam executable, dan ditemukan engine lewat jalur impor.

### b. Konsep: modul, URI, jalur impor

- **Modul QML** adalah kumpulan tipe (berkas `.qml`, tipe C++, berkas pendukung) dengan satu nama. `QtQuick` dan `QtQuick.Controls` adalah modul; `Hello` adalah modul milik Anda.
- **URI** adalah nama modul dalam notasi titik. Setiap segmen harus berupa pengenal ECMAScript yang sah (tidak diawali angka, tanpa tanda minus); batasi pada huruf latin, angka, garis bawah, dan titik. Gaya umum: `com.contoh.Hello`.
- **Target path** adalah URI dengan titik diganti garis miring (`Hello` menjadi `Hello`, `com.contoh.Hello` menjadi `com/contoh/Hello`).
- **Jalur impor (import path)** adalah daftar tempat engine mencari modul. `/qt/qml/` di dalam resource adalah bagian dari jalur bawaan engine.
- **Resource** adalah berkas yang ditanam ke dalam executable. Berkas `Main.qml` pada akhirnya berada di resource `:/qt/qml/Hello/Main.qml`.

Kebijakan **QTP0001** (aktif lewat `qt_standard_project_setup(REQUIRES 6.8)`) menetapkan awalan resource bawaan menjadi `/qt/qml/`. Tanpa kebijakan itu, awalannya `/`, dan modul tidak berada di jalur impor bawaan sehingga harus diatur manual.

### c. Main.qml kata demi kata

```qml
import QtQuick

Window {
    visible: true
    width: 640
    height: 360
    title: qsTr('Hello Qt 6')

    Text {
        anchors.centerIn: parent
        text: 'Hello Qt 6'
    }
}
```

| Bagian | Arti |
| --- | --- |
| `import QtQuick` | Di Qt 6, impor ini sudah cukup untuk `Window` dan `Text`; tidak perlu `import QtQuick.Window`. |
| `Window { ... }` | Jendela tingkat atas. Karena akar adalah `Window`, engine langsung menampilkannya. |
| `visible: true` | Jendela tersembunyi secara bawaan; baris ini menampilkannya. |
| `width: 640`, `height: 360` | Ukuran awal. |
| `title: qsTr('Hello Qt 6')` | Judul jendela. `qsTr` menandai teks agar bisa diterjemahkan (Modul 9.4); tanpa terjemahan terpasang ia mengembalikan teks aslinya. |
| `Text { ... }` | Objek anak berupa teks. |
| `anchors.centerIn: parent` | Letakkan di tengah induknya (hubungan yang dijaga engine, 0.1.1). |

### d. Satu nama, banyak tempat

Beberapa tempat harus **cocok persis**, dan satu pasangan harus **berbeda**:

| Tempat | Nilai pada contoh | Harus |
| --- | --- | --- |
| `URI` di `qt_add_qml_module` | `Hello` | Sama dengan yang di bawah |
| Argumen pertama `loadFromModule` | `"Hello"` | Sama dengan `URI` |
| `import Hello` di modul QML lain | `Hello` | Sama dengan `URI` |
| Folder hasil generate | `build/Hello/` | Mengikuti URI (target path) |
| Resource | `:/qt/qml/Hello/Main.qml` | Awalan `/qt/qml/` + target path + nama berkas |
| Nama berkas QML dan argumen kedua | `Main.qml` dan `"Main"` | Sama; diawali huruf besar |
| **Nama target** | `apphello` | **Berbeda** dari URI (panduan resmi) agar tidak bertabrakan di folder build |

### e. Apa yang dibuat qt\_add\_qml\_module \[amati\]

| Hasil | Fungsi |
| --- | --- |
| Bytecode QML di dalam executable | Mempercepat pemuatan (`qmlcachegen` otomatis); berkas QML asli tetap ditanam sebagai resource |
| `build/Hello/qmldir` | Daftar tipe modul beserta jalurnya |
| Berkas informasi tipe (`.qmltypes`) | Dipakai `qmllint` dan editor |
| Target `apphello_qmllint` dan `all_qmllint` | Menjalankan `qmllint` pada berkas modul |
| Tidak ada plugin terpisah | Karena executable sendiri yang menjadi modul |

Isi pasti tiap berkas dapat berbeda antar versi; periksa sendiri pada bagian f.

### f. Mengamati sendiri

```bash
$ ls build/Hello
$ cat build/Hello/qmldir
$ QML_IMPORT_TRACE=1 ./build/apphello 2>&1 | grep -i hello | head
$ cmake --build build --target apphello_qmllint
```

| Bagian | Arti |
| --- | --- |
| `ls build/Hello` | Berkas modul hasil generate. |
| `cat build/Hello/qmldir` | Anda akan melihat antara lain nama modul (`module Hello`), jalur resource, dan satu baris untuk tipe `Main`. |
| `QML_IMPORT_TRACE=1 ...` | Jejak pencarian impor (Modul 0.3); disaring dengan `grep` dan dipotong dengan `head` (0.0.4). |
| `--target apphello_qmllint` | Menjalankan `qmllint` pada `Main.qml` lewat target yang dibuat otomatis. |

### g. Opsi lain mengatur modul

| Pendekatan | Gambaran | Kapan |
| --- | --- | --- |
| Executable sebagai modul (di sini) | `qt_add_qml_module(apphello ...)` | Aplikasi kecil dan menengah |
| Modul sebagai pustaka terpisah | `qt_add_qml_module(mylib ...)` dengan plugin | Dipakai ulang oleh banyak aplikasi (Modul 8) |
| Prefiks sendiri | `RESOURCE_PREFIX /perusahaan/qml` | Perlu menambahkan prefiks itu ke jalur impor engine; sebaiknya andalkan QTP0001 |
| Tanpa folder target | `NO_RESOURCE_TARGET_PATH` (hanya untuk executable) | Letakkan berkas langsung di bawah prefiks |
| Impor direktori (gaya lama) | `import "components"` | Warisan; modul lebih dapat diperiksa dan dirawat |
| Jalur impor tambahan saat pengembangan | `QML_IMPORT_PATH`, `engine.addImportPath(...)` | Menguji modul di luar executable |

Catatan Qt 6.12: bila Anda memakai kata kunci `TARGET` pada `DEPENDENCIES`/`IMPORTS` (perlu kebijakan QTP0005, sudah aktif oleh `REQUIRES 6.8`), `qt_add_qml_module` pada executable otomatis menghasilkan berkas `qt.conf` yang mengatur jalur impor; opsi `NO_GENERATE_QTCONF` (sejak 6.12) mematikannya. Belum perlu untuk contoh ini.

### h. Visual

```
  CMake                                   C++                          QML
  -----                                   ---                          ---
  qt_add_qml_module(apphello              engine.loadFromModule(       import Hello
      URI Hello           <--- sama --->      "Hello", "Main")  <---  (dari modul lain)
      QML_FILES Main.qml                              |
  )                                                   v
       |                              cari modul "Hello" di jalur impor
       v                                              |
  resource :/qt/qml/Hello/Main.qml  <-----------------+
  (ditanam di executable, dengan bytecode)
  folder build/Hello/ : qmldir, .qmltypes
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Modul QML | Kumpulan tipe dengan satu nama |
| URI | Nama modul dalam notasi titik |
| Target path | URI dengan titik diganti garis miring |
| `qmldir` | Berkas yang mendefinisikan isi modul |
| `.qmltypes` | Berkas informasi tipe untuk alat |
| Jalur impor | Tempat engine mencari modul |
| Resource | Berkas yang ditanam ke executable (`:/...` atau `qrc:/...`) |
| Backing target | Target yang menampung modul (di sini executable) |
| Implicit import | Berkas dalam modul yang sama saling melihat tanpa `import` |

### j. Tips dan praktik terbaik

- Pilih URI sekali dan jangan ubah-ubah; ia tersebar di CMake, C++, dan seluruh `import`.
- Gunakan gaya nama terbalik (*reverse-DNS*) bila modul akan dibagikan (`com.contoh.Hello`); untuk belajar, nama sederhana cukup.
- Berikan nama modul yang menggambarkan fungsi, bukan nama aplikasi saja, bila modul berpotensi dipakai ulang.
- Pakai `QML_IMPORT_TRACE=1` pertama kali saat sebuah modul “tidak ditemukan”.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `module "Hello" is not installed` | URI di C++ berbeda dari URI di CMake (misalnya salah huruf) | Samakan persis, termasuk huruf besar-kecil |
| Tipe `Main` tidak ditemukan | Berkas bernama `main.qml` | Beri nama `Main.qml` dan perbarui `QML_FILES` |
| Modul tidak ditemukan padahal URI cocok | Kebijakan QTP0001 tidak aktif sehingga awalan resource `/` | Pastikan `qt_standard_project_setup(REQUIRES 6.8)` ada |
| Perubahan di `Main.qml` tidak terlihat | QML ditanam di executable; belum dibangun ulang | `cmake --build build`, lalu jalankan lagi (berbeda dengan `qml Main.qml` yang membaca berkas langsung) |
| Folder atau berkas aneh di `build/` pada macOS atau Windows | URI dan nama target hanya berbeda huruf besar-kecil | Pakai nama berbeda (`apphello`, `Hello`) |
| Mengubah URI di CMake tetapi lupa di C++ | Tiga tempat yang harus sinkron | Cari semua kemunculan dengan `grep -rn Hello --include='*.cpp' --include='*.txt' --include='*.qml' .` |

### l. Hubungan dengan modul lain

Prasyarat untuk 0.2.6 (menambah tipe baru ke modul), Fase 8 (modul QML dan arsitektur multi-modul), Modul 10.3 (registrasi tipe C++ ke modul yang sama), Modul 12.2 (`qmllint` memahami modul lewat `.qmltypes`), dan Modul 13.3 (modul saat deployment).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Setelah 0.2.5 berjalan: (1) lakukan percobaan di bagian f dan catat isi `qmldir`; (2) ubah `URI` di CMake menjadi `Halo` tanpa mengubah C++, bangun, jalankan, dan catat pesan serta exit code; (3) kembalikan; (4) ubah teks di `Main.qml`, jalankan **tanpa** membangun, lalu bangun dan jalankan lagi; jelaskan bedanya.

**Cek pemahaman.** (1) Di mana `Main` didefinisikan dan bagaimana C++ menemukannya? (2) Mengapa nama target dan URI harus berbeda? (3) Apa fungsi kebijakan QTP0001?

### n. Referensi

- [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [Qt CMake policy QTP0001](https://doc.qt.io/qt-6/qt-cmake-policy-qtp0001.html)
- [Tying it all together with CMake](https://doc.qt.io/qt-6/qtqml-modules-cmake-integration.html) · [Writing QML Modules](https://doc.qt.io/qt-6/qtqml-writing-a-module.html)
- [Module Definition qmldir Files](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html) · [QML Import Statements dan Import Path](https://doc.qt.io/qt-6/qtqml-syntax-imports.html)
- [Identified Modules](https://doc.qt.io/qt-6/qtqml-modules-identifiedmodules.html) · [QML Window type](https://doc.qt.io/qt-6/qml-qtquick-window.html)
- [Porting QML to qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt6-port-to-qt-add-qml-module.html)

---

## 0.2.5 Configure, build, run

*Semangat: tiga perintah yang akan Anda ketik ribuan kali, dan pantas dipahami sekali dengan benar.*

**Daftar isi 0.2.5:** a. Deskripsi dan peran · b. Konsep: tiga perintah, tiga tahap · c. Sesi lengkap · d. Penjelasan opsi · e. Membaca keluaran build · f. Siklus kerja harian · g. Membersihkan dan membangun ulang · h. Menemukan target dan pengaturan **\[amati\]** · i. Opsi lain · j. Visual · k. Terminologi · l. Tips · m. Kesalahan umum · n. Hubungan · o. Latihan dan cek · p. Referensi

### a. Deskripsi dan peran

Bagian ini adalah kebiasaan harian: menyiapkan build, membangun, menjalankan, dan memahami apa yang terjadi di tiap langkah. Setelah ini Anda mampu mendiagnosa sebagian besar kegagalan build hanya dengan membaca keluaran dan tahu tahap mana yang gagal.

### b. Konsep: tiga perintah, tiga tahap

| Tahap | Perintah | Siapa yang bekerja | Hasil |
| --- | --- | --- | --- |
| Configure + generate | `cmake -S . -B build ...` | CMake | `build/build.ninja`, `CMakeCache.txt`, berkas modul QML |
| Build | `cmake --build build` | Ninja (dipanggil CMake) | `build/apphello` |
| Run | `./build/apphello` | Anda | Jendela Qt Quick |

Configure hanya perlu diulang saat `CMakeLists.txt` atau pilihan konfigurasi berubah; dan dengan Ninja, build akan menjalankannya ulang sendiri bila ia mendeteksi `CMakeLists.txt` berubah.

### c. Sesi lengkap

```bash
$ cd ~/Development/qt-learning/hello
$ cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
$ cmake --build build
$ ./build/apphello
$ echo $?
0
```

Setelah jendela muncul dan Anda menutupnya, `echo $?` menampilkan `0` (keluar bersih).

### d. Penjelasan opsi

| Bagian | Arti |
| --- | --- |
| `cmake` | Alat utama. |
| `-S .` | *Source directory*: folder berisi `CMakeLists.txt` utama. `.` berarti folder ini. |
| `-B build` | *Build directory*: tempat semua hasil. Dibuat bila belum ada. |
| `-G Ninja` | Pilih generator Ninja. Hanya perlu saat pertama kali; tersimpan di cache. |
| `-DCMAKE_BUILD_TYPE=Debug` | Mengisi variabel cache. `Debug` menyertakan informasi debug dan tanpa optimasi. Pada generator satu-konfigurasi (Ninja, Makefile), tipe build ditetapkan **saat configure**. |
| `cmake --build build` | Menjalankan alat build (Ninja) di folder `build`. Opsi umum: `-j N` (jumlah tugas paralel), `--target NAMA`, `--verbose` (tampilkan perintah penuh), `--clean-first`. |
| `./build/apphello` | Menjalankan hasil. Nama berkas = nama target di `qt_add_executable`. |

### e. Membaca keluaran build

Keluaran Ninja berbentuk `[nomor/total] Aksi ...`, misalnya tahap yang membangun berkas objek C++, menghasilkan kode meta-object, menanam resource, dan menaut. Pada build pertama banyak tahap berjalan; pada build berikutnya hanya yang berubah. Bila tidak ada perubahan, Ninja menjawab dengan pesan bahwa tidak ada pekerjaan yang perlu dilakukan. Kegagalan ditandai baris yang berawalan `FAILED:` dan kemudian pesan kompilator (0.0.7); **baca error pertama**.

### f. Siklus kerja harian

| Anda mengubah | Yang perlu dilakukan |
| --- | --- |
| `Main.qml` atau berkas QML | `cmake --build build`, lalu jalankan. QML ditanam di executable, jadi perlu dibangun ulang. Untuk iterasi cepat: `qml Main.qml` (0.0.1), atau hot reload Qt 6.12 (Modul 12) |
| `main.cpp` atau berkas C++ | `cmake --build build`, lalu jalankan |
| `CMakeLists.txt` | `cmake --build build` (configure ulang otomatis), atau jalankan `cmake -S . -B build` secara eksplisit |
| Pilihan konfigurasi (tipe build, prefix Qt) | Jalankan `cmake -S . -B build -D...` lagi |
| Berkas baru | Daftarkan dulu (0.2.6), lalu bangun |

### g. Membersihkan dan membangun ulang

```bash
$ cmake --build build --target clean
$ pwd
$ rm -rf ./build
$ cmake --fresh -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
```

| Bagian | Arti |
| --- | --- |
| `--target clean` | Hapus hasil kompilasi, tetapi pertahankan konfigurasi. |
| `pwd` lalu `rm -rf ./build` | Pastikan Anda di folder proyek, baru hapus seluruh folder build (0.0.3). Pilihan paling pasti, tanpa risiko cache basi. |
| `--fresh` | Konfigurasi ulang dari awal: menghapus `CMakeCache.txt` dan `CMakeFiles/` yang lama (CMake 3.24 ke atas). |

### h. Menemukan target dan pengaturan \[amati\]

```bash
$ cmake --build build --target help
$ ninja -C build -t targets all | head -20
$ cmake -N -L build | head -20
```

| Bagian | Arti |
| --- | --- |
| `--target help` | Daftar target yang dapat dibangun; Anda akan melihat antara lain `apphello`, `apphello_qmllint`, `all_qmllint`. |
| `ninja -C build -t targets all` | Memanggil Ninja langsung (`-C` pindah folder, `-t targets` mode alat) untuk daftar target dan keluarannya. |
| `cmake -N -L build` | `-N`: hanya lihat, jangan jalankan configure; `-L`: tampilkan variabel cache yang tidak lanjutan. Berguna untuk memeriksa tipe build dan lokasi Qt. |

### i. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Generator berbeda | `-G "Unix Makefiles"` | Klasik; sedikit lebih lambat dari Ninja |
| Banyak konfigurasi tanpa folder baru | `-G "Ninja Multi-Config"` | Pilih tipe saat build: `--config Release` |
| Tipe build lain | `Release`, `RelWithDebInfo`, `MinSizeRel` | Lihat 0.2.8 |
| Paralelisme | `cmake --build build -j 8` | Bawaan Ninja sudah paralel; atur bila RAM terbatas |
| Memanggil alat build langsung | `ninja -C build`, `make -C build` | Sama dengan `--build`, kurang portabel |
| Mempercepat build ulang | `-DCMAKE_CXX_COMPILER_LAUNCHER=ccache` | Perlu paket `ccache`; berguna di proyek besar |
| Satu perintah ringkas | CMake Presets: `cmake --preset debug` | Lihat 0.2.7 |
| Qt dari lokasi lain | `-DCMAKE_PREFIX_PATH=...` | Lihat 0.1.7 |

### j. Visual

```
   siklus harian

   edit (.qml / .cpp / CMakeLists.txt)
         |
         v
   cmake --build build ------> error? --ya--> baca error PERTAMA (0.0.7), perbaiki, ulangi
         |                       |
         | sukses                '--- tidak jelas? reduksi, atau --verbose
         v
   ./build/apphello ---------> perilaku salah? --> qmllint, QML_IMPORT_TRACE (0.3), debug (Fase 12)
         |
         v
   git diff, commit (0.0.6)
```

### k. Terminologi

| Istilah | Arti |
| --- | --- |
| Configure | Membaca `CMakeLists.txt` dan menulis daftar tugas |
| Build | Menjalankan daftar tugas |
| Build type | Jenis kompilasi: Debug, Release, dan sebagainya |
| Single-config / multi-config | Satu tipe per folder build / banyak tipe dalam satu folder |
| Inkremental | Hanya mengerjakan ulang yang berubah |
| Target (build) | Satuan yang dapat dibangun lewat `--target` |
| Cache variable | Pilihan yang diingat CMake antar-configure |
| `-j` | Jumlah tugas paralel |

### l. Tips dan praktik terbaik

- Biasakan `--build` daripada memanggil Ninja langsung; perintah itu sama di semua generator.
- Bila perilaku aneh muncul setelah mengubah Qt, kompilator, atau opsi besar: hapus `build/`, lalu configure ulang.
- Simpan baris configure Anda di `catatan.md` atau di Presets (0.2.7) agar dapat diulang persis.
- Jalankan `echo $?` setelah build dan setelah aplikasi; kode keluar adalah bahasa yang dipakai skrip dan CI.

### m. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `CMake Error: The source directory ... does not appear to contain CMakeLists.txt` | `-S` menunjuk folder yang salah | `pwd`, `ls`; masuk ke folder proyek |
| `CMake Error: Could not create named generator Ninja` | Ninja belum terpasang | `sudo pacman -S ninja` (⚠) |
| `No CMAKE_CXX_COMPILER could be found` | Kompilator belum terpasang | Pasang `gcc` (Bagian 4) |
| `CMake Error at CMakeLists.txt:N (find_package): Could not find a package configuration file provided by "Qt6"` | Qt tidak ditemukan | Pasang paket Qt; atau `-DCMAKE_PREFIX_PATH=...` |
| `ninja: error: loading 'build.ninja': No such file or directory` | Belum configure, atau salah `-C` | Jalankan configure dulu; periksa folder |
| `bash: ./build/hello: No such file or directory` | Nama target berbeda dari yang diketik | Gunakan nama target: `./build/apphello` |
| Mengubah `-DCMAKE_BUILD_TYPE` tetapi tak berefek | Folder build lama memegang cache lama | Ulangi configure dengan `-D...`, atau `--fresh` |
| Build lambat sekali | Satu tugas pada satu waktu atau tanpa cache kompilasi | Pastikan Ninja dipakai; pertimbangkan `ccache` |
| Jendela tidak muncul padahal build sukses | Masalah runtime, bukan build | Lihat 0.2.3-j, lalu Modul 0.3 |

### n. Hubungan dengan modul lain

Prasyarat untuk 0.2.6 dan 0.2.7, seluruh latihan berikutnya yang memakai proyek CMake, Modul 0.3 (diagnosa saat build sukses tetapi aplikasi gagal), Modul 12.3 (menjalankan uji lewat `ctest`), dan Modul 13.3 (build rilis).

### o. Latihan dan cek pemahaman

**Latihan 15 menit.** Lakukan sesi di bagian c dari awal. Lalu: (1) jalankan `cmake --build build` lagi tanpa mengubah apa pun dan catat responsnya; (2) tambahkan satu spasi di `main.cpp` dan bangun lagi; amati apa yang dikerjakan ulang; (3) jalankan `--target help` dan catat target `*_qmllint`; (4) jalankan `rm -rf ./build` dengan aman dan ulangi dari awal; catat berapa lama build penuh.

**Cek pemahaman.** (1) Perintah mana yang mengatur tipe build, dan kapan efeknya? (2) Mengapa perubahan di `Main.qml` perlu `cmake --build`? (3) Mengapa `rm -rf build` aman, dan apa yang harus diperiksa sebelumnya?

### p. Referensi

- [cmake(1): perintah dan opsi](https://cmake.org/cmake/help/latest/manual/cmake.1.html) · [CMAKE\_BUILD\_TYPE](https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html)
- [Ninja manual](https://ninja-build.org/manual.html) · [Arch Wiki: CMake](https://wiki.archlinux.org/title/CMake)
- [Qt: Get started with CMake](https://doc.qt.io/qt-6/cmake-get-started.html) · [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html)
- [ccache](https://ccache.dev/)

---

## 0.2.6 Mendaftarkan file baru: QML\_FILES, SOURCES, RESOURCES

*Semangat: setiap berkas baru adalah satu langkah kecil, dan Anda sekarang tahu cara melangkahnya.*

**Daftar isi 0.2.6:** a. Deskripsi dan peran · b. Konsep: apa yang masuk ke daftar mana · c. Latihan terpandu: `Panel.qml` · d. Subfolder, gambar, dan C++ · e. Menambah berkas secara kondisional · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Aplikasi tumbuh dengan menambah berkas. Bagian ini mengajarkan bahwa setiap berkas harus **didaftarkan**, dan apa tepatnya yang terjadi jika tidak. Ini sumber kebingungan nomor satu setelah URI.

### b. Konsep: apa yang masuk ke daftar mana

| Kata kunci | Untuk | Perlakuan |
| --- | --- | --- |
| `QML_FILES` | Berkas `.qml`, `.js`, `.mjs` | Dikompilasi menjadi bytecode, ditanam ke executable, diperiksa `qmllint`, dan didaftarkan di `qmldir` |
| `SOURCES` | Berkas C++ (`.h`, `.cpp`) | Sama dengan menambah sumber ke target; untuk tipe C++ yang diekspos ke QML (Modul 10.3) |
| `RESOURCES` | Berkas pendukung (gambar, suara, font) | Ditanam ke executable di bawah prefiks yang sama dengan berkas QML |

Untuk executable, jalur resource tiap berkas adalah **awalan** (`:/qt/qml/`) + **target path** (`Hello`) + **jalur relatif berkas terhadap folder `CMakeLists.txt`**.

### c. Latihan terpandu: Panel.qml

**Langkah 1.** Buat `Panel.qml`:

```qml
import QtQuick

Rectangle {
    width: 200
    height: 80
    color: 'steelblue'

    Text {
        anchors.centerIn: parent
        text: 'Panel saya'
        color: 'white'
    }
}
```

**Langkah 2.** Daftarkan di `CMakeLists.txt`:

```cmake
qt_add_qml_module(apphello
    URI Hello
    QML_FILES
        Main.qml
        Panel.qml
)
```

**Langkah 3.** Pakai di `Main.qml`, di dalam `Window`:

```qml
    Panel { x: 20; y: 20 }
```

**Langkah 4.** Bangun dan jalankan:

```bash
$ cmake --build build
$ ./build/apphello
```

| Bagian | Arti |
| --- | --- |
| `Panel.qml` | Berkas tipe baru bernama `Panel` (huruf pertama besar, aturan 0.2.3). |
| `QML_FILES Main.qml Panel.qml` | Daftar semua berkas QML modul `Hello`; satu berkas per baris agar diff git rapi. |
| `Panel { x: 20; y: 20 }` | Memakai tipe `Panel` tanpa `import`, karena `Main.qml` dan `Panel.qml` berada dalam **modul yang sama** (impor implisit). |
| `cmake --build build` | Mendeteksi `CMakeLists.txt` berubah, configure ulang otomatis, lalu membangun. |

**Percobaan penting.** Ulangi tanpa Langkah 2 (tidak mendaftarkan `Panel.qml`) lalu bangun. Anda akan mendapat galat sejenis `Panel is not a type`. Padahal `qml Main.qml` di folder yang sama **bisa** menjalankannya, karena alat `qml` membaca folder secara langsung. Perbedaan ini adalah jebakan klasik: yang bekerja di `qml` belum tentu bekerja di aplikasi, karena aplikasi hanya melihat apa yang didaftarkan ke modul.

### d. Subfolder, gambar, dan C++

```cmake
qt_add_qml_module(apphello
    URI Hello
    QML_FILES
        Main.qml
        Panel.qml
        components/Card.qml
    RESOURCES
        img/logo.png
    SOURCES
        backend.h
        backend.cpp
)
```

```qml
Image {
    source: 'img/logo.png'
    width: 64
    height: 64
}
```

| Bagian | Arti |
| --- | --- |
| `components/Card.qml` | Berkas di subfolder; jalur resource-nya `:/qt/qml/Hello/components/Card.qml`. Berkas tetap bagian modul `Hello`; tipe `Card` dapat dipakai dari modul yang sama. Dengan kebijakan QTP0004 (aktif oleh `REQUIRES 6.8`), berkas di subfolder juga dapat melihat tipe lain di modulnya. Buktikan dengan `cat build/Hello/qmldir` **\[amati\]**. |
| `RESOURCES img/logo.png` | Menanam gambar ke executable di bawah prefiks yang sama. |
| `source: 'img/logo.png'` | Jalur **relatif terhadap berkas QML** yang memuatnya; di aplikasi yang dibangun, jalur itu menjadi resource, sedangkan di `qml` ia menjadi jalur berkas. |
| `SOURCES backend.h backend.cpp` | Menambah sumber C++ ke target; akan dipakai untuk tipe C++ di QML (Modul 10.3, memerlukan AUTOMOC yang sudah aktif). |

Bila lokasi berkas di source berbeda dari lokasi yang Anda inginkan di resource, atur properti sumber `QT_RESOURCE_ALIAS` **sebelum** berkas ditambahkan (dokumentasi `qt_add_qml_module`). Kebutuhan ini jarang; jaga susunan source agar sama dengan susunan resource.

### e. Menambah berkas secara kondisional

```cmake
qt_add_qml_module(apphello
    URI Hello
    QML_FILES Main.qml
)

if(UNIX)
    qt_target_qml_sources(apphello QML_FILES LinuxOnly.qml)
endif()
```

| Bagian | Arti |
| --- | --- |
| `if(UNIX) ... endif()` | Blok kondisional CMake: hanya berlaku di sistem Unix, termasuk Linux. |
| `qt_target_qml_sources(apphello QML_FILES ...)` | Menambah berkas QML ke modul **setelah** `qt_add_qml_module` dipanggil. Cocok untuk berkas kondisional atau dari subfolder yang baru ditambahkan. Berkas bisa diatur agar dilewati oleh lint, kompilasi bytecode, atau `qmldir`. |

**Singleton** (Fase 8): berkas QML bertipe singleton wajib diberi properti sumber `QT_QML_SINGLETON_TYPE` bernilai `TRUE` **sebelum** modul dibuat, di samping `pragma Singleton` di dalam berkas.

### f. Opsi lain

| Pendekatan | Gambaran | Catatan |
| --- | --- | --- |
| Daftar eksplisit (disarankan) | Tulis tiap berkas di `QML_FILES` | CMake tahu persis kapan daftar berubah |
| `file(GLOB ...)` | Kumpulkan otomatis dengan pola | Tidak dianjurkan: berkas baru tidak memicu configure ulang; `CONFIGURE_DEPENDS` mengurangi masalah, tetapi daftar eksplisit lebih jelas |
| `qt_target_qml_sources` | Menambah berkas bertahap atau kondisional | Dibahas di atas |
| `qt_add_resources` | Menanam berkas ke resource secara manual | Gaya Qt lama; `RESOURCES` biasanya sudah cukup |
| Modul terpisah per folder | Folder dengan `CMakeLists.txt` sendiri | Aplikasi besar (Modul 8) |

### g. Visual

```
   source (folder hello/)               resource di dalam executable
   ----------------------               --------------------------------------------
   Main.qml                  ----->     :/qt/qml/Hello/Main.qml
   Panel.qml                 ----->     :/qt/qml/Hello/Panel.qml
   components/Card.qml       ----->     :/qt/qml/Hello/components/Card.qml
   img/logo.png              ----->     :/qt/qml/Hello/img/logo.png
   backend.cpp / backend.h   ----->     dikompilasi ke executable (bukan resource)

   yang TIDAK terdaftar  ---> tidak ada di resource ---> "X is not a type" / "Cannot open ..."
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| `QML_FILES` | Daftar berkas QML dan JavaScript modul |
| `SOURCES` | Daftar berkas C++ untuk target |
| `RESOURCES` | Daftar berkas pendukung yang ditanam |
| Impor implisit | Berkas satu modul saling melihat tanpa `import` |
| `QT_RESOURCE_ALIAS` | Properti sumber untuk menetapkan jalur resource |
| Singleton | Tipe dengan satu instans bersama (Fase 8) |
| Glob | Pengumpulan berkas otomatis berdasarkan pola |

### i. Tips dan praktik terbaik

- Biasakan tiga langkah sebagai satu paket: buat berkas, daftarkan di CMake, baru pakai. Commit ketiganya bersama.
- Satu berkas per baris di daftar; urut abjad membantu menemukan duplikat.
- Jaga susunan source sama dengan susunan resource; jangan terburu memakai `QT_RESOURCE_ALIAS`.
- Setelah menambah berkas, jalankan `cmake --build build --target all_qmllint` untuk mendapat saran dini.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `Panel is not a type` di aplikasi, tetapi jalan di `qml` | `Panel.qml` belum ada di `QML_FILES` | Daftarkan; bangun ulang |
| `Cannot open: qrc:/qt/qml/Hello/img/logo.png` | Gambar tidak ada di `RESOURCES` atau jalur salah | Daftarkan; periksa jalur relatif dan huruf besar-kecil |
| Berkas ditambahkan, tidak ada yang berubah | Lupa membangun, atau berkas salah folder | `cmake --build build`; cek `ls` dan `qmldir` |
| Tipe diawali huruf kecil tidak dikenali | Nama berkas `panel.qml` | Ganti nama menjadi `Panel.qml` dan perbarui daftar |
| Perubahan di berkas `.js` tidak tampil | Berkas JS belum di `QML_FILES` | Daftarkan; nama berkas JS yang akan dipakai sebagai komponen diawali huruf besar |
| Daftar berkas panjang dan berantakan | Tidak ada konvensi | Satu baris per berkas, urut abjad |

### k. Hubungan dengan modul lain

Prasyarat untuk Fase 1 sampai 5 (setiap komponen baru), Modul 4.3 (resource dan gambar), Modul 5.1 (komponen), Modul 8.1 sampai 8.3 (modul dan CMake multi-modul), Modul 10.3 (`SOURCES` dan registrasi tipe C++), dan Modul 12.3 (berkas uji).

### l. Latihan dan cek pemahaman

**Latihan 15 menit** (dari kurikulum, dilengkapi). Kerjakan Langkah 1–4 di atas. Lalu: (1) lakukan percobaan tanpa mendaftarkan `Panel.qml` dan catat pesan; (2) jalankan `qml Main.qml` dan jelaskan mengapa ia berhasil; (3) tambahkan `components/Card.qml`, daftarkan, dan pakai `Card {}`; (4) buka `build/Hello/qmldir` dan cari `Card`.

**Cek pemahaman.** (1) Apa yang terjadi bila `Panel.qml` tidak didaftarkan? (2) Mengapa `qml Main.qml` dan aplikasi yang dibangun bisa berperilaku berbeda? (3) Kapan memakai `qt_target_qml_sources` daripada `QML_FILES`?

### m. Referensi

- [qt\_add\_qml\_module: menambah sumber dan resource](https://doc.qt.io/qt-6/qt-add-qml-module.html#adding-sources-and-resources-to-the-module) · [qt\_target\_qml\_sources](https://doc.qt.io/qt-6/qt-target-qml-sources.html)
- [Qt CMake policy QTP0004](https://doc.qt.io/qt-6/qt-cmake-policy-qtp0004.html)
- [Resource system Qt](https://doc.qt.io/qt-6/resources.html) · [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html)
- [CMake: file(GLOB)](https://cmake.org/cmake/help/latest/command/file.html#glob)

---

## 0.2.7 Alat kerja proyek: compile\_commands, lint, qmlls, Presets \[TAMBAHAN\]

**Mengapa ditambahkan:** Bagian 4 kurikulum menyatakan `qmllint` wajib dijalankan sebelum commit dan meminta Anda menghubungkan `qmlls` ke editor, tetapi tidak menunjukkan caranya dari proyek CMake. Untuk pekerja terminal dan editor modal, empat sambungan ini mengubah proyek dari “bisa dibangun” menjadi “nyaman dikerjakan”.

*Semangat: alat yang disetel baik membuat Anda bergerak secepat berpikir.*

**Daftar isi 0.2.7:** a. Deskripsi dan peran · b. `compile_commands.json` untuk C++ · c. Lint dari CMake · d. `qmlls` dan folder build · e. CMake Presets · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Editor yang cerdas (penyelesaian kode, lompat ke definisi, tanda galat sebelum build) membutuhkan dua hal: **bagaimana tiap berkas C++ dikompilasi** dan **di mana modul QML buatan Anda berada**. Keduanya hanya diketahui build. Bagian ini mengalirkan informasi itu ke editor Anda.

### b. compile\_commands.json untuk C++

```bash
$ cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
$ ln -sf build/compile_commands.json compile_commands.json
$ ls -l compile_commands.json
```

| Bagian | Arti |
| --- | --- |
| `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` | Minta CMake menulis `build/compile_commands.json`: daftar perintah kompilasi tiap berkas (didukung generator Ninja dan Makefile). |
| `ln -sf SUMBER TUJUAN` | Membuat tautan simbolik (*symlink*) di akar proyek yang menunjuk ke berkas itu; `-s` simbolik, `-f` timpa bila sudah ada. |
| `ls -l` | Memastikan tautan menunjuk ke tempat yang benar (tampil sebagai `->`). |

Server bahasa C++ seperti `clangd` (paket `clang`; cek dengan `pacman -F clangd`) membaca berkas ini. Berkas itu sudah ada di `.gitignore` sejak 0.2.1.

### c. Lint dari CMake

```bash
$ cmake --build build --target apphello_qmllint
$ cmake --build build --target all_qmllint
$ qmllint Main.qml
$ qmlformat -i Main.qml
```

| Bagian | Arti |
| --- | --- |
| `--target apphello_qmllint` | Target yang dibuat otomatis oleh `qt_add_qml_module`; menjalankan `qmllint` pada berkas `QML_FILES` dengan informasi tipe modul yang tepat. |
| `--target all_qmllint` | Menjalankan seluruh target lint sekaligus. |
| `qmllint Main.qml` | Lint satu berkas langsung (cepat, tetapi tidak selalu tahu modul buatan Anda). |
| `qmlformat -i Main.qml` | Memformat berkas di tempat (`-i` = *in place*). Jalankan **setelah** commit agar diff pemformatan terpisah dari perubahan isi. |

Biasakan `all_qmllint` sebelum setiap commit (0.0.6). Target global `dump_qml_context_properties` ikut dibuat otomatis bagi `qmllint` untuk memberi peringatan tentang context properties.

### d. qmlls dan folder build

`qmlls` (QML Language Server) memberi penyelesaian kode, lompat ke definisi, dan diagnostik langsung di editor. Agar mengenali modul buatan Anda, ia perlu tahu **folder build**. Cara memberitahunya, menurut dokumentasi `qmlls` Qt 6.12:

| Cara | Keterangan |
| --- | --- |
| Opsi `--build-dir <folder>` | Berlaku untuk seluruh workspace; prioritas tertinggi bersama variabel lingkungan dan ekstensi LSP |
| Variabel lingkungan `QMLLS_BUILD_DIRS` | Daftar folder build |
| Ekstensi LSP `AddBuildDirs` | Dikirim oleh editor/klien |
| Berkas `.qmlls.ini` dengan `buildDir=...` | Prioritas terendah; pada Qt 6.10 ke atas tidak wajib diisi |
| Variabel CMake `QT_QML_GENERATE_QMLLS_INI=ON` | Membuat `.qmlls.ini` otomatis (diperkenalkan 6.7); **dinyatakan deprecated sejak Qt 6.10, tanpa pengganti yang perlu** |

```bash
$ command -v qmlls qmlls6
$ qmlls --build-dir build
```

| Bagian | Arti |
| --- | --- |
| `command -v qmlls qmlls6` | Periksa nama executable di mesin Anda (Bagian 4: jangan menebak). |
| `qmlls --build-dir build` | Contoh manual; dalam praktik editor yang menjalankan `qmlls` dan meneruskan opsinya (konfigurasi editor di Modul 12.2). |

Bila Anda memakai Qt 6.7 sampai 6.9 dan memilih `.qmlls.ini`, tambahkan `**/.qmlls.ini` ke `.gitignore` (dokumentasi menekankan pola `**` karena berkas dibuat di tiap subfolder modul).

**Perhatian keamanan:** `qmlls` dapat memanggil CMake sendiri untuk menyiapkan informasi build (ada opsi `--no-cmake-calls` dan `no-cmake-calls=true` di `.qmlls.ini` untuk mematikannya). Menjalankan CMake berarti menjalankan **kode** dari `CMakeLists.txt`. Buka di editor hanya proyek yang Anda percayai, atau matikan panggilan otomatis itu untuk proyek asing (Modul 13.1 dan 14.6).

### e. CMake Presets

Presets menyimpan perintah configure dan build sebagai berkas JSON yang ikut di git, sehingga semua orang (dan Anda enam bulan lagi) menjalankan perintah yang sama. Simpan sebagai `CMakePresets.json`:

```json
{
  "version": 3,
  "configurePresets": [
    {
      "name": "debug",
      "displayName": "Debug (Ninja)",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/debug",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
      }
    },
    {
      "name": "release",
      "inherits": "debug",
      "displayName": "Release (Ninja)",
      "binaryDir": "${sourceDir}/build/release",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    }
  ],
  "buildPresets": [
    { "name": "debug", "configurePreset": "debug" },
    { "name": "release", "configurePreset": "release" }
  ]
}
```

```bash
$ cmake --list-presets
$ cmake --preset debug
$ cmake --build --preset debug
$ ./build/debug/apphello
```

| Bagian | Arti |
| --- | --- |
| `"version": 3` | Versi format Presets; versi 3 memerlukan CMake 3.21 (sesuai `cmake_minimum_required` kita). |
| `configurePresets` | Daftar preset untuk tahap configure. |
| `"name"`, `"displayName"` | Nama untuk perintah, dan label manusiawi. |
| `"generator": "Ninja"` | Sama dengan `-G Ninja`. |
| `"binaryDir": "${sourceDir}/build/debug"` | Sama dengan `-B`; `${sourceDir}` adalah makro Presets untuk folder source. Satu folder per konfigurasi. |
| `"cacheVariables"` | Sama dengan `-D...`; nilai ditulis sebagai teks. |
| `"inherits": "debug"` | Preset `release` mewarisi semua isi `debug`, lalu menimpa yang dinyatakan (di sini tipe build dan folder). |
| `buildPresets` | Preset untuk tahap build; tiap preset menunjuk preset configure-nya. |
| `--list-presets` | Menampilkan preset yang tersedia. |
| `--preset debug` / `--build --preset debug` | Configure dan build memakai preset. |

Pengaturan pribadi (misalnya `CMAKE_PREFIX_PATH` yang khusus mesin Anda) ditaruh di `CMakeUserPresets.json`, berkas pendamping yang tidak boleh di-commit (sudah ada di `.gitignore` di 0.2.8).

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Mengubah variabel cache lewat antarmuka teks | `ccmake build` | TUI bawaan CMake bila terpasang; cek `command -v ccmake` |
| Antarmuka grafis | `cmake-gui`, Qt Creator | IDE mengelola “kit” (kombinasi Qt dan kompilator) |
| Perintah ringkas tanpa Presets | Skrip `Makefile` pembungkus atau `just` | `make debug` menjalankan dua perintah CMake |
| Lingkungan per proyek | `direnv` | Mengatur variabel lingkungan otomatis saat masuk folder |
| Banyak proyek | `CMakeUserPresets.json` untuk preferensi pribadi | Jangan di-commit |
| Server bahasa QML di Qt Creator | Terintegrasi | Tidak perlu `qmlls` manual |

### g. Visual

```
  CMake build  ------------------------------+
   |-- build/compile_commands.json --------->|  clangd  --> editor (C++)
   |-- build/Hello/qmldir, *.qmltypes ------>|  qmlls   --> editor (QML)   <-- perlu tahu folder build
   '-- target apphello_qmllint, all_qmllint ->|  qmllint --> terminal / CI

  CMakePresets.json (di git)  --->  cmake --preset debug  --->  build/debug/
  CMakeUserPresets.json (lokal, tidak di git)  --->  pengaturan pribadi mesin ini
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| `compile_commands.json` | Daftar perintah kompilasi tiap berkas untuk alat analisis |
| `clangd` | Server bahasa C/C++ |
| `qmlls` | Server bahasa QML |
| LSP | Language Server Protocol |
| Symlink | Tautan simbolik ke berkas lain |
| Preset | Konfigurasi bernama yang disimpan di JSON |
| `${sourceDir}` | Makro Presets: folder source |
| Build directory | Folder hasil build; dikenali `qmlls` |

### i. Tips dan praktik terbaik

- Satu folder build per konfigurasi (`build/debug`, `build/release`); jangan bergantian di folder yang sama.
- Commit `CMakePresets.json`; jangan commit `CMakeUserPresets.json`.
- Setelah memindahkan folder build atau mengganti Qt, jalankan ulang configure agar `qmlls` dan `clangd` membaca informasi yang segar.
- Lint sebelum commit; format setelah commit terpisah.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Editor tidak mengenali `#include <QGuiApplication>` | `compile_commands.json` tidak ditemukan | Aktifkan `CMAKE_EXPORT_COMPILE_COMMANDS`, buat symlink di akar proyek |
| `qmlls` tidak mengenal modul `Hello` | Folder build tidak diketahui | Berikan `--build-dir`, atau atur klien LSP Anda |
| `CMake Error: Could not read presets` | JSON tidak valid atau versi terlalu tinggi | Periksa tanda koma dan kutip; `cmake --version` dan `"version"` |
| `.qmlls.ini` ikut ter-commit | Tidak masuk `.gitignore` | Tambahkan `**/.qmlls.ini` |
| Editor menunjuk build lama | Cache `clangd` atau symlink usang | Hapus `.cache/`; buat ulang symlink |
| `qmllint` memberi banyak peringatan “module not found” | Dijalankan tanpa informasi build | Pakai target `all_qmllint` atau berikan jalur impor |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 12.2 (`qmllint`, `qmlformat`, `qmlls` secara mendalam), Modul 12.3 (`ctest` dan Presets uji), 13.3 (preset rilis), dan 14.6 (membuka proyek asing dengan aman).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat `CMakePresets.json` seperti di atas, jalankan `cmake --list-presets`, `cmake --preset debug`, dan `cmake --build --preset debug`. Jalankan `./build/debug/apphello`. Lalu jalankan `all_qmllint`, dan buat symlink `compile_commands.json` yang benar untuk folder `build/debug`.

**Cek pemahaman.** (1) Informasi apa yang dibutuhkan editor dari build? (2) Mengapa `CMakeUserPresets.json` tidak di-commit? (3) Mengapa membuka proyek asing di editor yang memanggil CMake otomatis berisiko?

### m. Referensi

- [cmake-presets(7)](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) · [CMAKE\_EXPORT\_COMPILE\_COMMANDS](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html)
- [QML Language Server (qmlls)](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html) · [QT\_QML\_GENERATE\_QMLLS\_INI](https://doc.qt.io/qt-6/cmake-variable-qt-qml-generate-qmlls-ini.html)
- [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html)
- [clangd](https://clangd.llvm.org/) · [ccmake](https://cmake.org/cmake/help/latest/manual/ccmake.1.html)

---

## 0.2.8 Build bersih dan aman: tipe build, peringatan, diagnosa \[TAMBAHAN\]

**Mengapa ditambahkan:** kurikulum hanya menyebut `Debug`, tidak menjelaskan tipe lain dan peringatan kompilator, dan tidak menyentuh keamanan build. Bagian ini juga merangkum peta diagnosa kegagalan yang dipakai di seluruh fase berikutnya.

*Semangat: build yang bersih adalah janji kepada diri sendiri di masa depan.*

**Daftar isi 0.2.8:** a. Deskripsi dan peran · b. Tipe build · c. Peringatan kompilator · d. `.gitignore` lengkap · e. Mencatat lingkungan · f. Keamanan build · g. Peta diagnosa kegagalan · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Build yang baik dapat diulang, bersuara keras saat ada yang salah, dan tidak membuka pintu bagi kode yang tidak Anda niatkan. Bagian ini menetapkan kebiasaan itu sebelum proyek membesar.

### b. Tipe build

| Tipe | Bendera kompilator GCC bawaan CMake | Dipakai untuk |
| --- | --- | --- |
| `Debug` | `-g` (tanpa optimasi) | Belajar, debugging (Modul 12.1) |
| `Release` | `-O3 -DNDEBUG` | Mengukur performa, distribusi (Modul 11.4, 13.3) |
| `RelWithDebInfo` | `-O2 -g -DNDEBUG` | Profiling: cepat, tetapi masih punya simbol |
| `MinSizeRel` | `-Os -DNDEBUG` | Ukuran terkecil |

`NDEBUG` mematikan `assert` biasa, dan Qt pada konfigurasi non-Debug umumnya ikut mematikan pemeriksaan debug-nya. Konsekuensinya: **jangan mengukur performa pada `Debug`** dan **jangan menguji perilaku debugging pada `Release`**. Tipe ditetapkan saat configure pada generator satu-konfigurasi (0.2.5).

### c. Peringatan kompilator

```cmake
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(apphello PRIVATE -Wall -Wextra -Wpedantic)
endif()
```

| Bagian | Arti |
| --- | --- |
| `if(CMAKE_CXX_COMPILER_ID MATCHES "GNU\|Clang")` | Hanya jalankan blok bila kompilatornya GCC atau Clang; `MATCHES` memakai pola regex, `\|` berarti “atau”. |
| `target_compile_options(apphello PRIVATE ...)` | Menempelkan opsi kompilator **pada target** (bukan global), hanya untuk `apphello`. |
| `-Wall -Wextra -Wpedantic` | Peringatan umum, tambahan, dan kepatuhan standar. |

Untuk CI atau saat Anda ingin keras pada diri sendiri: tambahkan `-DCMAKE_COMPILE_WARNING_AS_ERROR=ON` saat configure (CMake 3.24 ke atas) agar peringatan menggagalkan build. Jangan menyalakan `-Werror` secara permanen pada proyek yang dibangun orang lain dengan kompilator berbeda.

### d. .gitignore lengkap

```
build/
.cache/
compile_commands.json
CMakeLists.txt.user
CMakeUserPresets.json
**/.qmlls.ini
```

| Pola | Arti |
| --- | --- |
| `build/` | Seluruh folder build (termasuk `build/debug`). |
| `.cache/` | Cache `clangd`. |
| `compile_commands.json` | Symlink atau salinan di akar proyek. |
| `CMakeLists.txt.user` | Pengaturan pribadi Qt Creator. |
| `CMakeUserPresets.json` | Preset pribadi. |
| `**/.qmlls.ini` | Berkas buatan untuk `qmlls`; `**` karena dapat muncul di tiap subfolder. |

### e. Mencatat lingkungan

```bash
$ { cmake --version | head -1; g++ --version | head -1; qmake6 --version | tail -1; pacman -Q qt6-base qt6-declarative; } > build-env.txt
$ cat build-env.txt
```

| Bagian | Arti |
| --- | --- |
| `{ ...; ...; } > berkas` | Kelompokkan beberapa perintah dan alihkan **seluruh** keluarannya ke satu berkas (0.0.4). |
| `... \| head -1` | Ambil baris pertama saja. |
| `qmake6 --version \| tail -1` | Ambil baris terakhir (baris versi Qt); periksa hasilnya di mesin Anda. |
| `pacman -Q ...` | Versi paket terpasang. |

Simpan `build-env.txt` di repositori bila ingin menelusuri “dulu berhasil dengan versi apa”.

### f. Keamanan build

- **CMake menjalankan kode.** `CMakeLists.txt` adalah skrip: ia bisa menjalankan perintah (`execute_process`), mengunduh (`file(DOWNLOAD)`, `FetchContent`). Membangun proyek orang lain berarti menjalankan kodenya dengan hak Anda. Baca dulu (0.0.9), dan jangan pernah `sudo cmake`.
- **Sematkan unduhan.** Bila Anda memakai `FetchContent`, pin ke commit atau checksum tertentu, bukan cabang yang bergerak.
- **Percayai jalur impor.** Dokumentasi `qt_add_qml_module` menyatakan Qt menganggap seluruh berkas di bawah `IMPORT_PATH` berasal dari sumber tepercaya. Jangan menambahkan folder yang bisa ditulis pihak lain.
- **Build rilis dikeraskan.** Opsi kompilator pengeras (*stack protector*, `_FORTIFY_SOURCE`, PIE, RELRO) dibahas di Modul 13.1. Di tahap ini cukup tahu bahwa ia ada.
- **`DISCARD_QML_CONTENTS`** membuang isi sumber QML dari executable untuk mengurangi ukuran, tetapi bukan perlindungan keamanan: bytecode tetap dapat diperiksa, dan hasilnya terikat pada versi Qt tertentu.

### g. Peta diagnosa kegagalan

| Tahap | Ciri pesan | Langkah pertama |
| --- | --- | --- |
| Configure | `CMake Error at CMakeLists.txt:N (perintah)` | Buka baris N; periksa ejaan, paket yang hilang, versi |
| Generate | `CMake Generate step failed` | Baca pesan **sebelumnya** |
| Kompilasi C++ | `FAILED: ... .o` lalu `error:` dari `g++` | Error **pertama**; header tidak ada berarti pustaka belum ditautkan |
| Alat Qt (moc, rcc, qmlcachegen) | Pesan dari alat itu dengan nama berkas dan baris | Galat sintaks QML dapat tertangkap di sini; buka berkas dan baris yang disebut |
| Tautan | `undefined reference to ...` | `target_link_libraries`, atau fungsi memang belum ditulis |
| Menjalankan | Exit code 255, pesan engine, jendela tidak muncul | 0.2.3-j, 0.2.4-k, lalu Modul 0.3 |

Untuk melihat perintah penuh yang dijalankan: `cmake --build build --verbose` (atau `-v`). Untuk mengulang dari nol: `cmake --fresh` atau hapus `build/` dengan aman (0.2.5-g).

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Kompilator berbeda | `-DCMAKE_CXX_COMPILER=clang++` | Paket `clang`; peringatan dan pesan berbeda membantu menemukan kesalahan |
| Penaut lebih cepat | `-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld` atau `mold` | Berguna di proyek besar |
| Cache kompilasi | `-DCMAKE_CXX_COMPILER_LAUNCHER=ccache` | Mengurangi waktu build ulang |
| Pemeriksa memori (Debug) | `-fsanitize=address,undefined` pada opsi kompilasi dan tautan target | Untuk fase C++; biasanya hanya di Debug |
| Analisis statis | `CMAKE_CXX_CLANG_TIDY` | Membutuhkan `clang-tidy` |
| Lingkungan terisolasi | Build di dalam kontainer `podman` | Reproduksibilitas dan isolasi (0.0.9) |
| Warna dan keterbacaan | `-DCMAKE_COLOR_DIAGNOSTICS=ON` | Pesan kompilator berwarna |

### i. Visual

```
  CONFIGURE  ---> GENERATE ---> KOMPILASI ---> ALAT QT ---> TAUTAN ---> JALAN
  (cmake)         (cmake)       (g++)          (moc, rcc,   (ld)        (apphello)
                                               qmlcachegen)
      |               |             |              |           |            |
   CMake Error     Generate     FAILED/error    pesan alat   undefined    exit 255 /
   at ...:N        failed       dari g++        + berkas:    reference    engine error
                                                baris

   Selalu: error PERTAMA, di tahap PERTAMA yang gagal.
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Tipe build | Debug, Release, RelWithDebInfo, MinSizeRel |
| `NDEBUG` | Makro yang mematikan `assert` |
| Peringatan kompilator | Pemberitahuan kode mencurigakan |
| Sanitizer | Alat deteksi kesalahan memori atau perilaku tak terdefinisi saat berjalan |
| `FetchContent` | Perintah CMake untuk mengunduh dependensi saat configure |
| Supply chain | Rantai penyampaian kode yang Anda bangun (0.0.9) |
| Hardening | Opsi kompilator yang mempersulit eksploitasi |
| Reproduksibel | Dapat menghasilkan hasil yang sama dari masukan yang sama |

### k. Tips dan praktik terbaik

- Mulailah proyek baru dengan `-Wall -Wextra`; membersihkan peringatan sejak awal jauh lebih murah daripada belakangan.
- Ukur performa hanya pada `Release` atau `RelWithDebInfo`.
- Catat versi alat (`build-env.txt`) setiap kali build “baik” berhasil.
- Jangan menyalin `CMakeLists.txt` dari internet tanpa membacanya; ia akan dijalankan.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Aplikasi terasa lambat | Diukur pada `Debug` | Bangun `Release` atau `RelWithDebInfo` |
| `assert` tidak bekerja | Build `Release` (`NDEBUG`) | Uji di `Debug` |
| Variabel `CMAKE_BUILD_TYPE` diabaikan | Folder build lama atau generator multi-konfigurasi | Configure ulang di folder baru; atau `--config` |
| `-Werror` menggagalkan build di mesin lain | Kompilator berbeda menghasilkan peringatan berbeda | Gunakan hanya di CI Anda sendiri |
| `FetchContent` mengambil versi berbeda hari ini | Mengikuti cabang bergerak | Sematkan ke commit atau checksum |
| Menjalankan `sudo cmake` | Mengira perlu hak istimewa | Jangan; perbaiki izin (0.0.5) |

### m. Hubungan dengan modul lain

Prasyarat untuk Modul 11.4 (mengukur performa), 12.1 (debugging dan sanitizer), 13.1 (hardening dan keamanan build), 13.3 (build rilis dan packaging), dan 14.6 (membangun proyek asing dengan aman).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Tambahkan blok peringatan ke `CMakeLists.txt`, bangun, dan perhatikan apakah ada peringatan. Lalu buat `build-env.txt`, lengkapi `.gitignore`, dan commit dengan pesan yang bermakna. Terakhir, bangun satu konfigurasi `release` (lewat preset di 0.2.7) dan bandingkan ukuran `build/release/apphello` dengan `build/debug/apphello` memakai `ls -lh`.

**Cek pemahaman.** (1) Mengapa tidak mengukur performa pada `Debug`? (2) Mengapa membangun proyek asing berisiko? (3) Pesan apa yang Anda baca lebih dulu saat build gagal di banyak tempat?

### o. Referensi

- [CMAKE\_BUILD\_TYPE](https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html) · [target\_compile\_options](https://cmake.org/cmake/help/latest/command/target_compile_options.html) · [CMAKE\_COMPILE\_WARNING\_AS\_ERROR](https://cmake.org/cmake/help/latest/variable/CMAKE_COMPILE_WARNING_AS_ERROR.html)
- [FetchContent](https://cmake.org/cmake/help/latest/module/FetchContent.html) · [GCC: Warning Options](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html)
- [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) · [Arch Wiki: Security](https://wiki.archlinux.org/title/Security)
- [qt\_add\_qml\_module: IMPORT\_PATH dan DISCARD\_QML\_CONTENTS](https://doc.qt.io/qt-6/qt-add-qml-module.html)

---

## 6.7 Penutup Modul 0.2

**Daftar isi bagian ini:** 6.7.1 Peta konsep · 6.7.2 Latihan terpadu · 6.7.3 Cek pemahaman modul · 6.7.4 Hubungan ke modul berikutnya · 6.7.5 Pembaruan yang diusulkan untuk kurikulum · 6.7.6 Status dan langkah berikutnya

### 6.7.1 Peta konsep

```
   0.2.1 Struktur + model kerja (configure -> build -> run)
            |
   0.2.2 CMakeLists.txt  ------------------+
            |                               |
   0.2.3 main.cpp + engine                  |
            |                               |
   0.2.4 Modul QML + URI  <-----------------+
            |
   0.2.5 Configure, build, run (siklus harian)
            |
   0.2.6 Mendaftarkan berkas baru
            |
      +-----+------+
      v            v
   0.2.7 Alat     0.2.8 Build bersih,
   kerja          aman, diagnosa
            |
            v
        Modul 0.3 (runtime dan diagnosa)
```

### 6.7.2 Latihan terpadu

Di folder baru `~/Development/qt-learning/02-build` (30–45 menit), **tanpa menyalin dari dokumen ini**: (1) buat tiga berkas dan `.gitignore` dari ingatan; (2) tulis `CMakeLists.txt` dengan target `apphello` dan URI `Hello`; (3) bangun lewat Presets; (4) tambahkan `Panel.qml` dan daftarkan; (5) sengaja salah ejaan URI di `main.cpp` dan baca pesan serta `echo $?`; (6) jalankan `all_qmllint` dan `qmlformat -i`; (7) buat `build-env.txt`; (8) commit dengan pesan bermakna dan periksa `git status` bersih.

### 6.7.3 Cek pemahaman modul

1. Jelaskan perbedaan configure, build, dan run, dan perintah untuk tiap tahap.
2. Mengapa folder `build/` tidak di-commit dan aman dihapus?
3. Apa yang dilakukan `qt_standard_project_setup(REQUIRES 6.8)` (sebutkan tiga efek)?
4. Mengapa nama target dan URI harus berbeda?
5. Di mana tipe `Main` didefinisikan dan bagaimana C++ menemukannya?
6. Mengapa `exit(-1)` dihubungkan dengan `Qt::QueuedConnection`?
7. Apa yang terjadi bila `Panel.qml` tidak didaftarkan, dan mengapa `qml Main.qml` tetap bisa menjalankannya?
8. Perintah apa yang menampilkan daftar target, dan target mana yang menjalankan lint?
9. Mengapa tidak mengukur performa pada `Debug`?
10. Mengapa CMake dan `qmlls` memerlukan kewaspadaan terhadap proyek asing?

### 6.7.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 0.2 |
| --- | --- |
| 0.3 Runtime dan diagnosa | Executable hasil build, folder build, alur configure dan run, peta diagnosa (0.2.8) |
| Fase 1 Bahasa QML | Siklus edit, build, run (0.2.5), `qmllint` dan `qmlformat` (0.2.7) |
| Fase 4 Dasar visual | Resource dan gambar lewat `RESOURCES` (0.2.6) |
| Fase 8 Modul QML dan arsitektur | URI, modul, `qt_target_qml_sources`, singleton (0.2.4, 0.2.6) |
| Fase 10 C++/QML | `SOURCES`, AUTOMOC, `loadFromModule` (0.2.2, 0.2.3, 0.2.6) |
| Fase 11 Rendering | `qmlcachegen` dan tipe build (0.2.4, 0.2.8) |
| Fase 12 Testing dan kualitas | Lint, Presets, `ctest`, sanitizer (0.2.7, 0.2.8) |
| Fase 13 Keamanan dan deployment | Build rilis, hardening, keamanan build (0.2.8) |

### 6.7.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda sebagai pengganti bagian yang sesuai pada Modul 0.2. Tambahan: ganti `./build/hello` menjadi `./build/apphello` di bagian lain kurikulum (mis. Modul 0.3), dan perbarui Cek pemahaman nomor 1 pada Modul 0.1.

**Contoh minimal.** Struktur proyek `hello/`: `CMakeLists.txt`, `main.cpp`, `Main.qml`. Nama target sengaja berbeda dari URI modul (`apphello` dan `Hello`): dokumentasi Qt menyatakan URI harus berbeda dari nama target agar tidak bertabrakan di folder build, dan pada sistem berkas yang tidak peka huruf besar-kecil `hello` dan `Hello` bertabrakan.

`CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.21)
project(HelloQt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(apphello main.cpp)

qt_add_qml_module(apphello
    URI Hello
    QML_FILES Main.qml
)

target_link_libraries(apphello PRIVATE Qt6::Quick)
```

Catatan: `VERSION` pada `qt_add_qml_module` dihilangkan karena dokumentasi menyarankan tidak memakainya bila tidak perlu. `main.cpp` dan `Main.qml` tidak berubah.

Cara menjalankan:

```
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
./build/apphello
```

**Daftar isi.** 0.2.1 Struktur proyek dan model kerja CMake · 0.2.2 `CMakeLists.txt` baris demi baris · 0.2.3 `main.cpp` dan engine · 0.2.4 Modul QML dan URI · 0.2.5 Configure, build, run · 0.2.6 Mendaftarkan file baru (QML\_FILES, SOURCES, RESOURCES) · 0.2.7 Alat kerja proyek: compile\_commands, lint, qmlls, Presets · 0.2.8 Build bersih dan aman: tipe build, peringatan, diagnosa

**Kesalahan umum (tambahan).** URI sama dengan nama target (hanya beda huruf besar-kecil); `build/` ikut ter-commit; mengubah QML tanpa membangun ulang; mengira `qml Main.qml` dan aplikasi yang dibangun berperilaku sama; menjalankan `sudo cmake`; mengukur performa pada Debug.

**Estimasi.** Jalur A 10–14 jam; Jalur B 4–5 jam.

### 6.7.6 Status dan langkah berikutnya

| Bagian | Status |
| --- | --- |
| Modul 0.0 (0.0.1–0.0.9) | Selesai |
| Modul 0.1 (0.1.1–0.1.7) | Selesai |
| Modul 0.2 (0.2.1–0.2.8) | **Selesai** |
| Modul 0.3 — Runtime, Bootstrap, dan Diagnosa Lingkungan | Berikutnya, menunggu konfirmasi |

---

## 7. Modul 0.3 — Runtime, Bootstrap, dan Diagnosa Lingkungan

**Daftar isi bagian ini:** 7.1 Audit Modul 0.3 · 7.2 Deskripsi dan peran · 7.3 Filosofi modul · 7.4 Visual: tujuh tahap menuju jendela · 7.5 Daftar isi sub-bagian yang diperbarui · 7.6 Estimasi waktu · lalu 0.3.1 sampai 0.3.7

### 7.1 Audit Modul 0.3

Diperiksa pada 5 November 2026 terhadap dokumentasi Qt (Qt Platform Abstraction, Qt Quick Scene Graph, Scene Graph Adaptations, persyaratan grafis Qt Quick 3D untuk daftar variabel RHI, QLoggingCategory) serta catatan komunitas untuk pesan galat nyata. Saya tidak memiliki akses ke mesin dan GPU Anda, jadi seluruh keluaran ditandai **\[amati\]**.

**Terverifikasi (tidak perlu diubah):**

- `QT_QUICK_BACKEND` (dan nama lamanya `QMLSCENE_DEVICE`) memilih adaptasi scene graph: `rhi` (bawaan), `software`, atau `openvg`. Sejak Qt 6.0 model berbasis RHI adalah bawaan dan tidak ada lagi jalur OpenGL langsung.
- `QSG_RHI_BACKEND` menerima `vulkan`, `metal`, `opengl`, `d3d11`, `d3d12`; bawaan: Direct3D 11 di Windows, Metal di macOS, **OpenGL di platform lain** (termasuk Linux).
- `QSG_INFO=1` mencetak informasi sistem saat scene graph diinisialisasi; kategori log `qt.scenegraph.general` menampilkan informasi serupa, termasuk render loop yang dipakai. Render loop ada dua: `basic` (satu thread) dan `threaded`, dipaksa lewat `QSG_RENDER_LOOP`.
- `QSG_RHI_DEBUG_LAYER=1` mengaktifkan lapisan validasi API grafis (Vulkan, Direct3D) bila tersedia.
- Adaptasi `software` tidak mendukung konten 3D.
- Plugin platform dipilih Qt menurut platform, dan dapat ditimpa dengan `QT_QPA_PLATFORM` atau `-platform`; daftar dipisah titik koma dicoba berurutan sampai ada yang tersedia.
- Aturan logging berbentuk `kategori[.tipe]=true|false`, dibaca dari `QT_LOGGING_RULES`, berkas `qtlogging.ini` pada folder QtProject, atau `QT_LOGGING_CONF`; format pesan diatur `QT_MESSAGE_PATTERN`.
- `Qt.platform.pluginName` tersedia di QML (properti `pluginName` pada objek platform Qt).

**Perlu dikoreksi atau dilengkapi:**

1. **Dua lapisan “backend” tercampur.** Tabel Terminologi menyebut backend (OpenGL, Vulkan, software) dalam satu daftar. Padahal OpenGL dan Vulkan adalah **backend RHI** (dipilih `QSG_RHI_BACKEND`), sedangkan `software` adalah **adaptasi scene graph** yang berbeda (dipilih `QT_QUICK_BACKEND`) dan memakai raster paint engine. Perbedaannya menentukan uji diagnosa; dijelaskan di 0.3.3.
2. **Variabel penting belum ada:** `QSG_RENDER_LOOP`, `QSG_RHI_DEBUG_LAYER`, `QT_FATAL_WARNINGS`, dan kategori `qt.scenegraph.general`. Ditambahkan di 0.3.3 dan 0.3.4.
3. **“Mengatur variabel di shell lain dari tempat aplikasi dijalankan”** disebut sebagai kesalahan umum tetapi tidak diajarkan. Ditambahkan sebagai 0.3.7.
4. **“Mengubah banyak variabel sekaligus”** disebut, tetapi tidak ada protokol yang mencegahnya. Ditambahkan sebagai 0.3.6.
5. **Cara membuktikan plugin yang dipakai** (`Qt.platform.pluginName`) dan **lingkungan tanpa layar** (`offscreen`, SSH, CI) tidak ada. Ditambahkan di 0.3.2.
6. **Plugin bawaan Wayland atau X11 tidak dinyatakan, dengan sengaja.** Dokumentasi QPA hanya menyatakan Qt memilih plugin bawaan menurut platform; sumber pihak ketiga bertentangan (sebagian menyebut bawaan X11, sebagian Wayland dengan fallback), dan perilaku dapat berbeda antar versi dan desktop. Modul ini mengajarkan cara **membuktikan** plugin yang aktif, bukan menghafal bawaan.
7. **Contoh memakai `qml Main.qml` saja.** Setelah Modul 0.2, pola yang sama berlaku untuk `./build/apphello`; variabel lingkungan bekerja identik.
8. **Referensi.** Halaman *Qt Quick Scene Graph* dan *Scene Graph Adaptations* terverifikasi ada. Tautan *Prototyping, Debugging, and Profiling* di kurikulum belum saya verifikasi; cocokkan sebelum dipakai.

### 7.2 Deskripsi dan peran dalam kurikulum

Modul ini menjawab pertanyaan yang pasti datang: *aplikasi saya tidak tampil, atau tampil rusak, atau lambat, di mesin ini saja; mengapa?* Anda akan belajar urutan kejadian dari `main()` sampai bingkai pertama, memilih dan memaksa plugin platform serta renderer, dan memakai variabel lingkungan dan log sebagai alat ukur. Ini penutup Fase 0, dan sekaligus bekal untuk Modul 11 (rendering), 12 (debugging), dan 13 (deployment).

### 7.3 Filosofi modul

**Diagnosa adalah eksperimen, bukan tebak-tebakan.** Setiap gejala punya tahap penyebab; setiap tahap punya alat ukur; setiap uji mengubah **satu** hal. Kesimpulan hanya sah bila bisa diulang. **Kontrol datang dari kemampuan melihat:** tidak ada variabel “sihir”, hanya cara menyuruh Qt mengatakan apa yang sedang ia pilih.

### 7.4 Visual: tujuh tahap menuju jendela

```
  [0] proses lahir          kernel + penaut dinamis memuat libQt6*.so
        |                   gagal: "error while loading shared libraries"
  [1] QGuiApplication       memuat plugin platform (wayland / xcb / offscreen), menyambung ke server tampilan
        |                   gagal: "could not load the Qt platform plugin"
  [2] QQmlApplicationEngine menyusun jalur impor, menyiapkan cache QML
        |                   gagal: modul tidak ditemukan
  [3] loadFromModule        memuat tipe Main, membuat objek, mengevaluasi binding
        |                   gagal: "failed to load component", exit 255
  [4] Window dibuat         jendela platform muncul; scene graph + RHI dipilih saat pertama tampil
        |                   gagal: jendela kosong, crash di driver
  [5] render loop           basic atau threaded; bingkai disusun dan ditukar (swap)
        |                   gagal: berkedip, lambat, tampilan rusak
  [6] exec()                event loop berputar sampai jendela ditutup
```

### 7.5 Daftar isi sub-bagian yang diperbarui

| No. | Judul | Asal |
| --- | --- | --- |
| 0.3.1 | Urutan startup aplikasi Qt Quick | Asli 0.3.1, diperluas |
| 0.3.2 | Plugin platform: Wayland, X11, dan tanpa layar | Asli 0.3.2, diperluas |
| 0.3.3 | Renderer dan backend RHI, termasuk software | Asli 0.3.3, diperluas |
| 0.3.4 | Variabel lingkungan diagnostik | Asli 0.3.4, diperluas |
| 0.3.5 | Membaca log dan kategori logging | Asli 0.3.5 |
| 0.3.6 | Protokol diagnosa terisolasi dan laporan masalah | **\[TAMBAHAN\]** |
| 0.3.7 | Dari mana lingkungan berasal: shell, launcher, sesi | **\[TAMBAHAN\]** |

### 7.6 Estimasi waktu

Jalur A: 10–14 jam; Jalur B: 4–5 jam.

---

## 0.3.1 Urutan startup aplikasi Qt Quick

*Semangat: yang tahu urutan kejadiannya selalu tahu ke mana harus melihat.*

**Daftar isi 0.3.1:** a. Deskripsi dan peran · b. Konsep: toko yang dibuka berurutan · c. Tujuh tahap dan bukti tiap tahap · d. Contoh: satu jalankan, banyak penanda **\[amati\]** · e. Peta gejala ke tahap · f. Opsi lain mengamati startup · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Banyak masalah tampak serupa (“tidak ada jendela”) padahal berasal dari tahap berbeda. Peta urutan startup memberi Anda daftar periksa: selidiki tahap demi tahap dan berhenti di yang pertama gagal.

### b. Konsep: toko yang dibuka berurutan

Analogi kurikulum, dilengkapi: (0) bangunan berdiri dan listrik menyala (proses lahir, pustaka dimuat); (1) `QGuiApplication` menyiapkan toko (plugin platform, koneksi ke sistem jendela); (2) `QQmlApplicationEngine` menyewa penerjemah QML (jalur impor, cache); (3) `loadFromModule` memuat menu (tipe `Main`); (4) etalase dipasang (jendela dan scene graph di atas RHI); (5) kasir bekerja tiap bingkai (render loop); (6) toko buka sampai ditutup (`exec()`). Bila etalase kosong, periksa tiap tahap **berurutan**, jangan loncat.

### c. Tujuh tahap dan bukti tiap tahap

| Tahap | Siapa bekerja | Bukti yang bisa diminta | Kegagalan khas |
| --- | --- | --- | --- |
| 0. Proses lahir | Kernel, penaut dinamis | `ldd ./build/apphello`, `LD_DEBUG=libs` | `error while loading shared libraries: libQt6Quick.so.6: cannot open shared object file` |
| 1. Platform | `QGuiApplication`, plugin QPA | `QT_DEBUG_PLUGINS=1`, `QT_LOGGING_RULES=qt.qpa.*=true`, `Qt.platform.pluginName` | `could not load the Qt platform plugin ...`, daftar plugin yang tersedia |
| 2. Engine | `QQmlEngine` | `QML_IMPORT_TRACE=1` | Jalur impor tidak memuat modul Anda |
| 3. Memuat QML | `loadFromModule`, kompilasi QML | Pesan engine, `echo $?` (255) | `module "X" is not installed`, `X is not a type` |
| 4. Jendela dan RHI | Plugin platform, scene graph | `QSG_INFO=1`, `qt.scenegraph.general` | Jendela kosong, crash di driver |
| 5. Render loop | Thread GUI dan render | `qt.scenegraph.general` (loop), `QSG_RENDER_LOOP` | Berkedip, CPU 100%, lambat |
| 6. Event loop | `exec()` | Respons terhadap input | UI macet (0.0.2) |

### d. Contoh: satu jalankan, banyak penanda \[amati\]

```bash
$ QT_DEBUG_PLUGINS=1 QSG_INFO=1 QML_IMPORT_TRACE=1 timeout 8 ./build/apphello &> startup.log
$ echo $?
124
$ wc -l startup.log
$ grep -n -i -E 'platform|xcb|wayland|rhi|opengl|vulkan' startup.log | head -20
$ grep -n -i 'hello' startup.log | head -10
```

| Bagian | Arti |
| --- | --- |
| `QT_DEBUG_PLUGINS=1 QSG_INFO=1 QML_IMPORT_TRACE=1` | Tiga prefiks variabel (0.0.3) yang menyalakan jejak pemuatan plugin, informasi scene graph, dan jejak impor QML sekaligus. Ini penyederhanaan untuk **mengamati**; saat menyelidiki masalah, ubah satu per satu (0.3.6). |
| `timeout 8 ./build/apphello` | Menjalankan program, dan membunuhnya setelah 8 detik agar skrip tidak menunggu. |
| `&> startup.log` | Menyimpan stdout dan stderr ke berkas (0.0.4). |
| `echo $?` → `124` | Kode keluar `timeout` saat ia memaksa berhenti. Itu **bagus**: aplikasi bertahan hidup selama 8 detik. Kode lain berarti aplikasi berhenti sendiri (255 = gagal memuat QML). |
| `grep -n -i -E '...' startup.log \| head -20` | Cari baris yang menyebut plugin platform dan grafis, lengkap dengan nomor baris, tanpa membedakan huruf besar-kecil. |
| `grep -n -i 'hello' ...` | Lihat bagaimana modul `Hello` ditemukan. |

Nomor baris pada hasil `grep` memperlihatkan **urutan**: plugin platform muncul sebelum jejak impor, dan informasi scene graph muncul belakangan, pada saat jendela pertama tampil. Itu bukti urutan di bagian c.

### e. Peta gejala ke tahap

| Gejala | Tahap yang dicurigai | Langkah pertama |
| --- | --- | --- |
| Tidak ada keluaran sama sekali, langsung keluar | 0 atau 1 | `ldd`, `QT_DEBUG_PLUGINS=1` |
| Pesan tentang plugin platform | 1 | 0.3.2 |
| `module ... is not installed` | 2 atau 3 | `QML_IMPORT_TRACE=1` dan 0.2.4 |
| `echo $?` menunjukkan 255 | 3 | Baca pesan engine |
| Jendela muncul tetapi kosong atau rusak | 4 | 0.3.3 (`QSG_INFO`, backend) |
| Berkedip atau lambat | 5 | `qt.scenegraph.general`, 0.3.3 |
| Jendela ada tetapi tidak merespons | 6 | 0.0.2 |

### f. Opsi lain mengamati startup

| Alat | Kegunaan | Catatan |
| --- | --- | --- |
| `strace -f -tt -e trace=openat,connect ./build/apphello` | Garis waktu pembukaan berkas dan koneksi ke server tampilan | Paket `strace`; keluaran panjang, saring dengan `grep` |
| `LD_DEBUG=libs ./build/apphello 2>&1 \| head -40` | Pustaka mana dimuat dari mana (glibc) | Tahap 0 |
| `ltrace`, `perf` | Analisis lanjutan | Di luar Fase 0 |
| Qt Creator | Profiler dan log terintegrasi | Opsional |
| `QT_LOGGING_RULES` | Kategori log rinci | 0.3.5 |

### g. Visual

```
  waktu --->
  [0 proses] [1 platform] [2 engine] [3 QML] [4 jendela+RHI] [5 bingkai ...] [6 event loop]
      |           |            |         |           |                |
   ldd         qt.qpa      IMPORT_TRACE  exit 255   QSG_INFO     qt.scenegraph.general
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Penaut dinamis (`ld.so`) | Pemuat pustaka bersama saat program mulai |
| QPA | Qt Platform Abstraction, lapisan antara Qt dan sistem jendela |
| Jalur impor | Tempat engine mencari modul QML |
| Unit terkompilasi / cache | Bytecode QML hasil `qmlcachegen` atau cache disk |
| RHI | Rendering Hardware Interface, abstraksi API grafis di bawah scene graph |
| Expose | Saat jendela pertama kali benar-benar tampil di layar |
| Render loop | Pengatur kapan dan di thread mana bingkai dirender |
| `timeout` | Alat yang membunuh perintah setelah waktu tertentu (kode keluar 124) |

### i. Tips dan praktik terbaik

- Mulai diagnosa dari tahap **terendah** yang gagal; tahap berikutnya sering baru bermakna setelah yang sebelumnya sehat.
- Simpan log dari run yang baik; membandingkannya dengan run yang buruk memakai `diff -u` sering lebih cepat daripada membaca (0.3.6).
- Selalu gunakan `timeout` saat menjalankan aplikasi dalam skrip.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Menyalahkan QML padahal jendela bahkan tidak muncul | Tahap 1 atau 4 gagal | Uji dengan QML kosong (`Window { visible: true }`) |
| Menyalahkan GPU padahal modul tidak ditemukan | Tahap 2 atau 3 | Baca pesan engine dulu |
| Menganggap `exit code 124` sebagai kegagalan | Itu kode `timeout` | Tafsirkan: 124 berarti bertahan, bukan crash |
| Membaca log dari bawah ke atas | Kehilangan urutan sebab | Baca dari atas; error pertama (0.0.7) |
| Menyalakan semua log dan tenggelam | Terlalu banyak keluaran | Nyalakan satu kategori, saring dengan `grep` |

### k. Hubungan dengan modul lain

Prasyarat untuk 0.3.2 sampai 0.3.7, Modul 0.0.2 (event loop), 0.2.3 (urutan di `main.cpp`), Modul 11.1 (render loop dan scene graph), dan Modul 12.1 (debugging).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan contoh di bagian d. Buat tabel milik Anda: untuk tiap tahap 1–4, tulis nomor baris pertama di `startup.log` yang menyinggungnya. Lalu ubah URI di `main.cpp` menjadi salah eja, bangun, jalankan lagi, dan tentukan di tahap mana ia gagal.

**Cek pemahaman.** (1) Sebutkan tiga bukti yang Anda minta dari tahap 1, 2, dan 4. (2) Mengapa `echo $?` bernilai 124 pada contoh dan bukan 0? (3) Jendela kosong: tahap mana yang pertama dicurigai?

### m. Referensi

- [Qt Platform Abstraction](https://doc.qt.io/qt-6/qpa.html) · [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html)
- [Scene Graph Adaptations](https://doc.qt.io/qt-6/qtquick-visualcanvas-adaptations.html) · [QML Import Path](https://doc.qt.io/qt-6/qtqml-syntax-imports.html)
- [ld.so(8)](https://man7.org/linux/man-pages/man8/ld.so.8.html) · [strace](https://strace.io/)
- [timeout (coreutils)](https://www.gnu.org/software/coreutils/manual/html_node/timeout-invocation.html)

---

## 0.3.2 Plugin platform: Wayland, X11, dan tanpa layar

*Semangat: setiap jendela yang muncul adalah hasil negosiasi yang Anda kini bisa saksikan.*

**Daftar isi 0.3.2:** a. Deskripsi dan peran · b. Konsep: QPA dan server tampilan · c. Menemukan plugin yang aktif · d. Memaksa dan memilih cadangan · e. Tanpa layar: offscreen, SSH, CI · f. Bila plugin gagal dimuat · g. Beda perilaku Wayland dan X11 · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Qt tidak menggambar langsung ke layar; ia berbicara dengan sistem jendela lewat **plugin platform** (QPA). Di Linux ada dua yang utama: **wayland** dan **xcb** (X11). Memilih dan membuktikan plugin yang aktif memisahkan masalah “Qt” dari masalah “desktop”.

### b. Konsep: QPA dan server tampilan

- **QPA** adalah lapisan yang menerjemahkan kebutuhan Qt (buat jendela, terima input, minta konteks grafis) ke bahasa sistem jendela.
- Plugin yang umum di Linux: `wayland`, `xcb`, `offscreen` (tanpa layar), `minimal`, dan untuk perangkat tertanam `eglfs`, `linuxfb`, `vkkhrdisplay`, serta `vnc`. Daftar sebenarnya muncul pada pesan galat “Available platform plugins are: ...”.
- Di Arch, plugin Wayland berasal dari paket `qt6-wayland`; plugin `xcb` ikut `qt6-base`. Menjalankan klien X11 di sesi Wayland memerlukan **XWayland** (paket `xorg-xwayland`).
- **Keamanan:** pada Wayland, tiap klien terisolasi dari klien lain (tidak dapat mengintip input atau isi jendela klien lain tanpa izin compositor); pada X11, klien mana pun dapat membaca input dan layar klien lain. Itu alasan kuat memilih Wayland bila memungkinkan.

### c. Menemukan plugin yang aktif

```bash
$ echo "$XDG_SESSION_TYPE" "$WAYLAND_DISPLAY" "$DISPLAY"
$ pacman -Q qt6-wayland
```

Simpan sebagai `Plugin.qml`, jalankan `qml Plugin.qml`:

```qml
import QtQuick

Window {
    visible: true
    width: 420
    height: 160
    title: 'Plugin platform'

    Column {
        anchors.centerIn: parent
        spacing: 8
        Text { text: 'plugin: ' + Qt.platform.pluginName }
        Text { text: 'os: ' + Qt.platform.os }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `echo ... $XDG_SESSION_TYPE $WAYLAND_DISPLAY $DISPLAY` | Jenis sesi dan variabel koneksi: `wayland` atau `x11`; `WAYLAND_DISPLAY` terisi di Wayland; `DISPLAY` terisi bila X11 atau XWayland tersedia. Tanda kutip menjaga bila kosong. |
| `pacman -Q qt6-wayland` | Apakah plugin Wayland terpasang. |
| `Qt.platform.pluginName` | Nama plugin platform yang **sedang dipakai** (mis. `wayland` atau `xcb`) **\[amati\]**. |
| `Qt.platform.os` | Sistem operasi (`linux`). |
| `Column { ... spacing: 8 }` | Menyusun dua teks vertikal dengan jarak 8. |

Jalankan tanpa mengatur apa pun dan catat hasilnya: itulah plugin bawaan pada mesin dan versi Qt Anda.

### d. Memaksa dan memilih cadangan

```bash
$ QT_QPA_PLATFORM=wayland qml Plugin.qml
$ QT_QPA_PLATFORM=xcb qml Plugin.qml
$ QT_QPA_PLATFORM='wayland;xcb' qml Plugin.qml
$ qml -platform xcb Plugin.qml
```

| Bagian | Arti |
| --- | --- |
| `QT_QPA_PLATFORM=wayland` | Paksa plugin Wayland; gagal bila tidak tersedia atau tidak ada compositor Wayland. |
| `QT_QPA_PLATFORM=xcb` | Paksa X11. Di sesi Wayland, ini berjalan lewat XWayland. |
| `'wayland;xcb'` | **Daftar cadangan**: coba `wayland`, bila tidak tersedia pakai `xcb`. Tanda kutip wajib karena `;` adalah pemisah perintah shell. |
| `-platform xcb` | Setara lewat argumen baris perintah, yang dibaca `QGuiApplication` (0.2.3). Prioritas lebih tinggi daripada variabel. |

### e. Tanpa layar: offscreen, SSH, CI

```bash
$ QT_QPA_PLATFORM=offscreen timeout 5 qml Plugin.qml
$ echo $?
```

`offscreen` membuat jendela di memori tanpa menampilkannya; berguna untuk pengujian otomatis dan CI (Modul 12.3), dan satu-satunya pilihan masuk akal di sesi SSH tanpa server tampilan. Dalam contoh ini `Qt.platform.pluginName` bernilai `offscreen` dan tidak ada jendela yang terlihat.

### f. Bila plugin gagal dimuat

Dua bentuk pesan galat yang nyata:

```text
This application failed to start because no Qt platform plugin could be initialized.
Available platform plugins are: xcb, wayland, offscreen, minimal, ...

qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
```

| Pesan | Artinya | Tindakan |
| --- | --- | --- |
| `no Qt platform plugin could be initialized` + daftar | Plugin yang diminta tidak ada dalam daftar | Pasang paketnya (`qt6-wayland`), atau pilih plugin dari daftar |
| `Could not load ... "xcb" ... even though it was found` | Plugin ada, tetapi **pustaka yang dibutuhkannya** hilang | Periksa dependensi plugin (di bawah) |

Memeriksa dependensi plugin:

```bash
$ ldd "$(qmake6 -query QT_INSTALL_PLUGINS)/platforms/libqxcb.so" | grep 'not found'
$ QT_DEBUG_PLUGINS=1 QT_QPA_PLATFORM=xcb timeout 5 qml Plugin.qml 2>&1 | grep -i -E 'cannot|not found|fail'
```

| Bagian | Arti |
| --- | --- |
| `qmake6 -query QT_INSTALL_PLUGINS` | Folder plugin Qt di mesin Anda. |
| `.../platforms/libqxcb.so` | Berkas plugin xcb. |
| `ldd ... \| grep 'not found'` | Menampilkan pustaka yang dibutuhkan plugin tetapi tidak ditemukan; pustaka itulah yang harus dipasang. Sejak Qt 6.5 plugin xcb membutuhkan pustaka xcb-cursor (paket Arch `xcb-util-cursor`), sebagai contoh. |
| `QT_DEBUG_PLUGINS=1 ...` | Jejak pemuatan plugin; saring baris yang menyebut kegagalan. |

### g. Beda perilaku Wayland dan X11

| Aspek | Wayland | X11 (xcb) |
| --- | --- | --- |
| Posisi jendela (`x`, `y`) | Klien tidak menentukan posisi absolut; compositor yang memutuskan | Dihormati |
| Dekorasi jendela | Sering digambar klien; `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` mematikannya | Digambar window manager |
| Isolasi klien | Kuat | Lemah |
| Skala layar | Per layar dan pecahan; `QT_SCALE_FACTOR` untuk uji | Bergantung konfigurasi DPI |
| Pengambilan layar dan pintasan global | Perlu izin atau protokol compositor | Bebas, dan itulah masalah keamanannya |

Kolom ini rangkuman umum; konfirmasi perilaku di compositor Anda **\[amati\]**.

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Jalankan tanpa desktop | `eglfs`, `linuxfb` | Perangkat tertanam |
| Layar jarak jauh | `vnc` | Server VNC bawaan Qt |
| Uji otomatis | `offscreen`, `minimal` | Tanpa layar |
| Debug protokol Wayland | `WAYLAND_DEBUG=1` | Mencetak percakapan klien dan compositor |
| Fallback aman | `QT_QPA_PLATFORM='wayland;xcb'` | Lebih aman daripada memaksa satu plugin secara global |

### i. Visual

```
  QML / Qt Quick
        |
  Qt GUI --- QPA (antarmuka plugin)
                 |------------------+------------------+----------------+
            plugin xcb         plugin wayland     plugin offscreen   eglfs/linuxfb/...
                 |                   |                  |
              server X11        compositor Wayland    (memori saja)
                 |                   |
             (XWayland <-------------+   bila klien X11 di sesi Wayland)
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| QPA / plugin platform | Lapisan dan modul penghubung Qt ke sistem jendela |
| `xcb` | Plugin Qt untuk X11 lewat pustaka XCB |
| `wayland` | Plugin Qt untuk Wayland |
| XWayland | Server X11 yang berjalan di dalam sesi Wayland |
| Compositor | Program yang menyusun jendela di Wayland |
| `offscreen` | Plugin tanpa layar |
| Daftar cadangan | Beberapa plugin dipisah `;`, dicoba berurutan |
| `Qt.platform.pluginName` | Nama plugin yang aktif, dibaca dari QML |

### k. Tips dan praktik terbaik

- Jangan mengatur `QT_QPA_PLATFORM` secara global untuk satu plugin; aplikasi yang tidak punya plugin itu akan gagal start. Gunakan prefiks per perintah atau daftar cadangan.
- Sebelum menyalahkan Qt, uji aplikasi Qt lain di plugin yang sama; bila ikut bermasalah, sumbernya desktop atau driver.
- Catat `XDG_SESSION_TYPE` dan `Qt.platform.pluginName` di setiap laporan masalah (0.3.6).

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `no Qt platform plugin could be initialized` | Plugin yang diminta tidak ada | Pasang `qt6-wayland` atau pilih plugin dari daftar |
| `Could not load ... xcb ... even though it was found` | Pustaka dependensi plugin hilang | `ldd ... \| grep 'not found'`, lalu pasang paket yang sesuai |
| `xcb` gagal di sesi Wayland | XWayland tidak tersedia | Pasang `xorg-xwayland` atau pakai `wayland` |
| Jendela tidak bisa dipindahkan lewat `x` dan `y` | Perilaku Wayland | Biarkan compositor menaruh jendela |
| Aplikasi gagal di SSH | Tidak ada server tampilan | Gunakan `offscreen` |
| Dekorasi ganda atau hilang | Perbedaan dekorasi sisi klien dan sisi server | Uji `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` |

### m. Hubungan dengan modul lain

Prasyarat untuk 0.3.3 (renderer bergantung pada plugin), 0.3.7 (di mana variabel diatur), Modul 9.3 (style), Modul 12.3 (pengujian dengan `offscreen`), Modul 13.2 (integrasi desktop), dan 13.1 (isolasi dan keamanan).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Plugin.qml` tanpa variabel dan catat `Qt.platform.pluginName`. Lalu jalankan dengan `wayland`, `xcb`, dan `offscreen` (dengan `timeout`), catat hasil dan exit code tiap kombinasi, serta pesan galat bila ada.

**Cek pemahaman.** (1) Bagaimana membuktikan plugin yang sedang dipakai? (2) Mengapa `'wayland;xcb'` perlu tanda kutip? (3) Apa arti `Could not load ... even though it was found` dan bagaimana menelusurinya?

### o. Referensi

- [Qt Platform Abstraction](https://doc.qt.io/qt-6/qpa.html) · [QGuiApplication](https://doc.qt.io/qt-6/qguiapplication.html)
- [Qt for Linux/X11](https://doc.qt.io/qt-6/linux.html) · [Qt Wayland](https://doc.qt.io/qt-6/wayland-and-qt.html)
- [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt) · [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland) · [Arch Wiki: Xorg dan XWayland](https://wiki.archlinux.org/title/Wayland#Xwayland)
- [Wayland: dokumentasi protokol](https://wayland.freedesktop.org/docs/html/)

---

## 0.3.3 Renderer dan backend RHI, termasuk software

*Semangat: setelah bisa menanyai renderer apa yang ia pilih, tampilan rusak berhenti menjadi misteri.*

**Daftar isi 0.3.3:** a. Deskripsi dan peran · b. Konsep: scene graph, RHI, backend, adaptasi software · c. Menanyai renderer **\[amati\]** · d. Memilih backend dan render loop · e. Uji pemisah: QML, Qt, atau GPU? · f. Memeriksa GPU dan driver · g. Memaksa lewat C++ · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Setelah jendela ada (0.3.2), sesuatu harus menggambar isinya. Bagian ini menjelaskan siapa yang menggambar, bagaimana memilihnya, dan bagaimana membuktikan bahwa sebuah masalah tampilan berasal dari GPU atau driver, bukan dari QML Anda.

### b. Konsep: scene graph, RHI, backend, adaptasi software

- **Scene graph** adalah pohon node yang mewakili apa yang akan digambar (Modul 11.1).
- **RHI (Rendering Hardware Interface)** adalah lapisan abstraksi Qt: scene graph berbicara ke RHI, dan RHI menerjemahkannya ke API grafis. Sejak Qt 6.0 jalur RHI adalah bawaan dan **tidak ada lagi jalur OpenGL langsung**.
- **Backend RHI** adalah API grafis yang dipakai di bawah RHI: `opengl`, `vulkan`, `metal`, `d3d11`, `d3d12`. Bawaannya menurut platform: Direct3D 11 di Windows, Metal di macOS, **OpenGL di platform lain, termasuk Linux**. Dipilih dengan `QSG_RHI_BACKEND`.
- **Adaptasi software** adalah renderer **terpisah** yang memakai *raster paint engine* (CPU) alih-alih GPU. Dipilih dengan `QT_QUICK_BACKEND=software` (nama lama: `QMLSCENE_DEVICE`). Ia memiliki keterbatasan fitur; dokumentasi menyatakan ia tidak mendukung konten 3D.
- **Render loop**: `basic` (satu thread) atau `threaded` (penggambaran di thread terpisah). Qt memilih menurut platform dan driver; dipaksa dengan `QSG_RENDER_LOOP`.

Koreksi terhadap tabel Terminologi kurikulum: OpenGL dan Vulkan adalah **backend RHI**, dan `software` adalah **adaptasi** yang berbeda; mengujinya memberi kesimpulan yang berbeda (bagian e).

### c. Menanyai renderer \[amati\]

Simpan sebagai `Gpu.qml`:

```qml
import QtQuick

Window {
    visible: true
    width: 480
    height: 270
    color: '#101820'

    Rectangle {
        anchors.centerIn: parent
        width: 140
        height: 140
        radius: 24
        layer.enabled: true
        layer.smooth: true

        gradient: Gradient {
            GradientStop { position: 0.0; color: '#f2aa4c' }
            GradientStop { position: 1.0; color: '#e8505b' }
        }

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 4000
            loops: Animation.Infinite
        }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `color: '#101820'` | Latar jendela gelap. |
| `radius: 24` | Sudut membulat. |
| `layer.enabled: true`, `layer.smooth: true` | Item digambar ke tekstur tersendiri lalu dipakai di layar, fitur yang bergantung pada jalur GPU (Modul 11). |
| `gradient: Gradient { GradientStop { ... } }` | Gradasi dua warna. |
| `RotationAnimation on rotation { ... }` | Memutar item terus-menerus, agar kerusakan tampilan tampak saat bergerak. |

```bash
$ QSG_INFO=1 timeout 6 qml Gpu.qml 2>&1 | head -20
$ QSG_RHI_BACKEND=opengl QSG_INFO=1 timeout 6 qml Gpu.qml 2>&1 | head -20
$ QSG_RHI_BACKEND=vulkan QSG_INFO=1 timeout 6 qml Gpu.qml 2>&1 | head -20
$ QT_QUICK_BACKEND=software QSG_INFO=1 timeout 6 qml Gpu.qml 2>&1 | head -20
$ LIBGL_ALWAYS_SOFTWARE=1 QSG_INFO=1 timeout 6 qml Gpu.qml 2>&1 | head -20
```

| Perintah | Menguji |
| --- | --- |
| `QSG_INFO=1 ...` (tanpa pilihan) | **Bawaan** mesin Anda: backend RHI apa, perangkat dan driver apa, versi berapa. |
| `QSG_RHI_BACKEND=opengl` | Paksa OpenGL (bawaan Linux). |
| `QSG_RHI_BACKEND=vulkan` | Paksa Vulkan; menurut dokumentasi, bila API yang diminta tidak tersedia, inisialisasi gagal (tidak diam-diam turun). |
| `QT_QUICK_BACKEND=software` | Renderer CPU; menghindari GPU dan driver sama sekali. |
| `LIBGL_ALWAYS_SOFTWARE=1` | Variabel Mesa: OpenGL tetap lewat RHI, tetapi diterjemahkan Mesa ke CPU (`llvmpipe`); menguji **driver**, bukan jalur Qt. |
| `timeout 6 ... \| head -20` | Aplikasi dibunuh setelah 6 detik, dan keluaran dipotong. Anda juga perlu mengamati jendela secara visual sebelum ia berhenti. |

Baris keluaran `QSG_INFO` menyebut antara lain backend, vendor, renderer, dan versi **\[amati\]**; salin ke `catatan.md` untuk tiap kombinasi.

### d. Memilih backend dan render loop

```bash
$ QSG_RENDER_LOOP=basic QT_LOGGING_RULES='qt.scenegraph.general=true' timeout 6 qml Gpu.qml 2>&1 | head -20
$ QSG_RENDER_LOOP=threaded QT_LOGGING_RULES='qt.scenegraph.general=true' timeout 6 qml Gpu.qml 2>&1 | head -20
$ QSG_RHI_BACKEND=vulkan QSG_RHI_DEBUG_LAYER=1 timeout 6 qml Gpu.qml 2>&1 | head -30
```

| Bagian | Arti |
| --- | --- |
| `QSG_RENDER_LOOP=basic` | Paksa render loop satu-thread. Dipakai bila sistem tidak dapat mensinkronkan ke vsync dengan baik: menurut dokumentasi, loop `threaded` mengandalkan pembatasan oleh API grafis, dan tanpanya animasi bisa berjalan terlalu cepat dengan CPU 100%. |
| `QSG_RENDER_LOOP=threaded` | Paksa penggambaran di thread terpisah. |
| `QT_LOGGING_RULES='qt.scenegraph.general=true'` | Menyalakan kategori log scene graph; di antaranya menyebut render loop yang sedang dipakai. Tanda kutip tunggal menjaga `=` dan titik dari shell. |
| `QSG_RHI_DEBUG_LAYER=1` | Mengaktifkan lapisan validasi API grafis (Vulkan, Direct3D) bila tersedia; di Arch untuk Vulkan umumnya paket `vulkan-validation-layers`. |

### e. Uji pemisah: QML, Qt, atau GPU?

Pertanyaan kurikulum: *bagaimana membuktikan masalah tampilan berasal dari GPU, bukan dari QML?* Jawabannya adalah rangkaian uji yang mengubah **satu** lapisan pada satu waktu:

| Urutan | Uji | Bila masalah **hilang** | Bila masalah **tetap** |
| --- | --- | --- | --- |
| 1 | `Window { visible: true }` kosong atau `Gpu.qml` sederhana | QML Anda perlu dicurigai (fitur tertentu) | Bukan QML Anda: lanjut ke 2 |
| 2 | `QT_QUICK_BACKEND=software` | Masalah ada di jalur GPU Qt (RHI, driver, backend) | Bukan GPU: kembali ke QML, plugin platform, atau data |
| 3 | `LIBGL_ALWAYS_SOFTWARE=1` | Driver OpenGL fisik bermasalah | Masalah bukan di driver OpenGL |
| 4 | Ganti `QSG_RHI_BACKEND` (opengl dan vulkan) | Masalah spesifik satu API grafis | Masalah di luar pilihan API |
| 5 | Ganti `QSG_RENDER_LOOP` | Interaksi vsync, thread, atau compositor | Tidak terkait render loop |
| 6 | Ganti `QT_QPA_PLATFORM` (wayland dan xcb) | Masalah pada integrasi plugin platform | Tidak terkait plugin |

Peringatan penting: adaptasi `software` **tidak** setara fitur. Bila QML yang diuji memakai fitur yang tidak ada di software (3D, sebagian efek), hasilnya menyesatkan. Karena itu uji pada QML sesederhana mungkin (`Gpu.qml`), lalu naikkan kompleksitas sedikit demi sedikit. Dan jangan membandingkan performa software dengan GPU.

### f. Memeriksa GPU dan driver

```bash
$ lspci -k | grep -A3 -E 'VGA|3D'
$ glxinfo -B | head -20
$ vulkaninfo --summary | head -30
```

| Perintah | Arti |
| --- | --- |
| `lspci -k` | Daftar perangkat PCI dengan **driver kernel** yang dipakai (paket `pciutils`). Disaring ke kartu grafis. |
| `glxinfo -B` | Ringkasan OpenGL (vendor, renderer, versi); paket `mesa-utils`. |
| `vulkaninfo --summary` | Perangkat dan driver Vulkan yang terdeteksi; paket `vulkan-tools`. Kosong atau galat berarti tidak ada driver Vulkan yang terpasang, dan `QSG_RHI_BACKEND=vulkan` akan gagal. |

Paket driver di Arch berbeda menurut perangkat keras (Mesa untuk Intel dan AMD, paket `nvidia-utils` untuk NVIDIA, dan seterusnya); rujuk Arch Wiki untuk GPU Anda sebelum memasang.

### g. Memaksa lewat C++

```cpp
#include <QQuickWindow>
#include <QSGRendererInterface>

// di main(), sebelum membuat jendela mana pun:
QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
```

| Bagian | Arti |
| --- | --- |
| `QQuickWindow::setGraphicsApi(...)` | Meminta API grafis tertentu dari kode. Dokumentasi: panggil sedini mungkin di `main()`, sebelum membuat `QQuickWindow`. |
| `QSGRendererInterface::OpenGL` | Nilai enum; alternatif `Vulkan`, `Metal`, `Direct3D11`, dan lain-lain. |

Untuk **diagnosa**, pakai variabel lingkungan (tidak mengubah kode). Memaksa API di kode hanya bila produk Anda memang bergantung pada satu API (Modul 11.3).

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Lihat overdraw dan batching | `QSG_VISUALIZE=overdraw` dan sejenisnya | Perkakas performa, dibahas di Modul 11.4 |
| Profil GPU | Alat vendor, `RenderDoc` | Lanjut; di luar Fase 0 |
| Backend OpenVG | `QT_QUICK_BACKEND=openvg` | Hanya untuk perangkat tertanam khusus |
| Memaksa lewat kode | `QQuickWindow::setSceneGraphBackend(...)` | Dipanggil dini di `main()` |
| Grafis tanpa GPU | `LIBGL_ALWAYS_SOFTWARE=1` | Bagi server atau mesin tanpa GPU |

### i. Visual

```
  QML (Item, Rectangle, Text ...)
        |
   Scene Graph  (pohon node)
        |
  +-----+---------------------------+
  |  RHI (bawaan Qt 6)              |   adaptasi software (terpisah)
  |   |-- backend opengl  (Linux)   |        |
  |   |-- backend vulkan            |   raster paint engine (CPU)
  |   |-- metal / d3d11 / d3d12     |   (tanpa 3D)
  +---+-----------------------------+
      |
   driver (Mesa, NVIDIA, ...)   <--- LIBGL_ALWAYS_SOFTWARE=1 mengalihkan OpenGL ke CPU
      |
     GPU
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| RHI | Lapisan abstraksi API grafis Qt |
| Backend RHI | API di bawah RHI: OpenGL, Vulkan, Metal, Direct3D |
| Adaptasi scene graph | Renderer alternatif: `rhi` (bawaan), `software`, `openvg` |
| Software renderer | Penggambaran CPU memakai raster paint engine |
| `llvmpipe` | Implementasi OpenGL perangkat lunak dari Mesa |
| Render loop | `basic` atau `threaded` |
| Vsync | Sinkronisasi gambar dengan penyegaran layar |
| Validation layer | Lapisan debug API grafis yang memeriksa kesalahan pemakaian |
| Overdraw | Piksel yang digambar berkali-kali |

### k. Tips dan praktik terbaik

- Gunakan satu QML kecil dan stabil untuk uji renderer; jangan menguji dengan aplikasi penuh.
- Salin keluaran `QSG_INFO` ke laporan masalah apa pun yang menyangkut tampilan.
- Anggap driver tidak terduga: bawa selalu cadangan `QT_QUICK_BACKEND=software` untuk pembuktian.
- Jangan menyimpulkan dari satu kombinasi; matriks di 0.3.6 menjaga Anda tetap jujur.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Menyamakan `software` dengan OpenGL tanpa GPU | Dua hal berbeda | Software = adaptasi raster; `LIBGL_ALWAYS_SOFTWARE` = OpenGL di CPU |
| `QSG_RHI_BACKEND=vulkan` gagal | Tidak ada driver Vulkan | `vulkaninfo --summary`; pasang driver, atau pakai `opengl` |
| Menulis `Vulkan` berhuruf besar | Nilai ditulis huruf kecil di dokumentasi | Tulis `vulkan`, `opengl` |
| Menyimpulkan “GPU rusak” dari satu uji | Software tak setara fitur | Lakukan seluruh urutan di bagian e |
| CPU 100% dan animasi terlalu cepat | Loop `threaded` tanpa vsync | Uji `QSG_RENDER_LOOP=basic` |
| Mengatur variabel tetapi tidak berefek | Salah ketik nama (diabaikan diam-diam) | Cek ejaan dengan `env`; 0.3.4 |

### m. Hubungan dengan modul lain

Prasyarat untuk 0.3.6 (protokol), Modul 11.1 (scene graph), 11.3 (grafis dan shader), 11.4 (performa), dan 13.2 (pengujian di mesin target).

### n. Latihan dan cek pemahaman

**Latihan 15 menit** (dari kurikulum, dilengkapi). Jalankan `Gpu.qml` dengan tiga kombinasi: bawaan, `QT_QUICK_BACKEND=software`, dan `QSG_RHI_BACKEND=vulkan` (bila ada). Untuk masing-masing catat keluaran `QSG_INFO=1`, kesan visual, dan exit code. Lalu isi matriks di bagian e dengan hasil Anda.

**Cek pemahaman.** (1) Apa beda backend RHI dan adaptasi software? (2) Bagaimana membuktikan masalah tampilan berasal dari GPU, bukan dari QML? (3) Apa fungsi `LIBGL_ALWAYS_SOFTWARE=1`, dan apa yang diujinya?

### o. Referensi

- [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [Scene Graph Adaptations](https://doc.qt.io/qt-6/qtquick-visualcanvas-adaptations.html)
- [Qt Quick 3D Graphics Requirements: variabel `QSG_*`](https://doc.qt.io/qt-6/qtquick3d-requirements.html)
- [Software Adaptation](https://doc.qt.io/qt-6/qtquick-visualcanvas-adaptations-software.html) · [QQuickWindow](https://doc.qt.io/qt-6/qquickwindow.html)
- [Arch Wiki: Vulkan](https://wiki.archlinux.org/title/Vulkan) · [OpenGL](https://wiki.archlinux.org/title/OpenGL)
- [Mesa: variabel lingkungan](https://docs.mesa3d.org/envvars.html)

---

## 0.3.4 Variabel lingkungan diagnostik

*Semangat: setiap variabel adalah satu tuas; yang tahu tuasnya tidak pernah panik.*

**Daftar isi 0.3.4:** a. Deskripsi dan peran · b. Katalog variabel · c. Melihat, menghapus, dan mengisolasi lingkungan · d. Variabel yang membuka pintu: peringatan keamanan · e. Pola kerja · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Qt dan sistem di bawahnya dapat diatur dan diamati lewat variabel lingkungan, tanpa mengubah satu baris kode pun. Ini alat diagnosa paling murah, dan juga sumber kebingungan terbesar karena nama yang salah ketik **diabaikan diam-diam**.

### b. Katalog variabel

Status: ✔ = terverifikasi pada dokumentasi atau halaman yang saya baca pada 5 November 2026; ○ = umum dipakai, tetapi uji dan baca dokumentasinya untuk versi Anda.

**Platform dan plugin**

| Variabel | Fungsi | Contoh | Status |
| --- | --- | --- | --- |
| `QT_QPA_PLATFORM` | Pilih plugin platform; boleh daftar dipisah `;` | `wayland`, `xcb`, `offscreen`, `'wayland;xcb'` | ✔ |
| `QT_DEBUG_PLUGINS` | Jejak pencarian dan pemuatan plugin | `1` | ✔ |
| `QT_PLUGIN_PATH` | Folder tambahan pencarian plugin | `/jalur/plugin` | ○ |
| `WAYLAND_DEBUG` | Percakapan protokol Wayland (libwayland) | `1` | ✔ |

**Renderer**

| Variabel | Fungsi | Contoh | Status |
| --- | --- | --- | --- |
| `QT_QUICK_BACKEND` | Pilih adaptasi scene graph | `software`, `openvg`, `rhi` | ✔ |
| `QSG_RHI_BACKEND` | Pilih backend RHI | `opengl`, `vulkan` | ✔ |
| `QSG_INFO` | Cetak informasi sistem scene graph | `1` | ✔ |
| `QSG_RENDER_LOOP` | Paksa render loop | `basic`, `threaded` | ✔ |
| `QSG_RHI_DEBUG_LAYER` | Lapisan validasi API grafis | `1` | ✔ |
| `LIBGL_ALWAYS_SOFTWARE` | OpenGL di CPU lewat Mesa | `1` | ○ |

**QML**

| Variabel | Fungsi | Contoh | Status |
| --- | --- | --- | --- |
| `QML_IMPORT_TRACE` | Jejak pencarian modul | `1` | ✔ |
| `QML_IMPORT_PATH` | Jalur impor tambahan | `/jalur/modul` | ✔ |
| `QML_DISABLE_DISK_CACHE` | Matikan cache disk QML (untuk menguji dampak cache) | `1` | ○ |
| `QT_QUICK_CONTROLS_STYLE` | Pilih style Controls | `Material`, `Basic` | ○ |

**Log dan kegagalan**

| Variabel | Fungsi | Contoh | Status |
| --- | --- | --- | --- |
| `QT_LOGGING_RULES` | Aturan kategori log | `'qt.qpa.*=true'` | ✔ |
| `QT_LOGGING_CONF` | Berkas aturan log | `/jalur/log.ini` | ✔ |
| `QT_MESSAGE_PATTERN` | Format pesan | `'%{time hh:mm:ss.zzz} %{message}'` | ✔ |
| `QT_FATAL_WARNINGS` | Peringatan Qt menjadi fatal (berguna di uji) | `1` | ○ |

**Tampilan dan sistem**

| Variabel | Fungsi | Contoh | Status |
| --- | --- | --- | --- |
| `QT_SCALE_FACTOR` | Skala global untuk uji | `1.5` | ○ |
| `QT_QPA_PLATFORMTHEME` | Tema platform (dialog dan palet) | nama tema | ○ |
| `QT_WAYLAND_DISABLE_WINDOWDECORATION` | Matikan dekorasi sisi klien Wayland | `1` | ○ |
| `LD_DEBUG` | Jejak penaut dinamis (glibc) | `libs` | ○ |

### c. Melihat, menghapus, dan mengisolasi lingkungan

```bash
$ env | sort | grep -E '^(QT_|QML|QSG|XDG_SESSION|WAYLAND|DISPLAY)'
$ printenv QT_QPA_PLATFORM || echo '(tidak diatur)'
$ env -u QT_QPA_PLATFORM qml Main.qml
$ env -i HOME="$HOME" PATH="$PATH" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" WAYLAND_DISPLAY="$WAYLAND_DISPLAY" DISPLAY="$DISPLAY" qml Main.qml
$ QT_QPA_PLATFROM=xcb qml Plugin.qml
```

| Bagian | Arti |
| --- | --- |
| `env \| sort \| grep -E '...'` | Daftar variabel lingkungan yang relevan; `-E` memakai pola regex lanjutan. |
| `printenv NAMA \|\| echo ...` | Tampilkan satu variabel; `printenv` berakhir dengan kode 1 bila tidak ada, sehingga `\|\|` menjalankan `echo`. |
| `env -u NAMA perintah` | Jalankan perintah **tanpa** variabel itu (hapus sementara, hanya untuk satu perintah). |
| `env -i NAMA=nilai ... perintah` | Jalankan dengan lingkungan **bersih**: hanya variabel yang Anda sebut; membuktikan apakah pengaturan lingkungan lama yang menjadi penyebab. `XDG_RUNTIME_DIR` dan `WAYLAND_DISPLAY` diperlukan agar klien Wayland menemukan compositor. |
| `QT_QPA_PLATFROM=xcb` | **Salah ketik sengaja** (`PLATFROM`). Qt tidak memprotes; variabel itu tidak dikenali dan diabaikan. Periksa `Qt.platform.pluginName` untuk melihat bahwa pengaturan tidak berlaku. |

### d. Variabel yang membuka pintu: peringatan keamanan

Beberapa variabel mengubah **kode apa yang dimuat**. Di tangan yang salah, atau di tempat yang salah (profil shell global), ia mengubah aplikasi menjadi pemuat kode asing:

| Variabel | Risiko |
| --- | --- |
| `LD_LIBRARY_PATH`, `LD_PRELOAD` | Pustaka dari folder yang ditunjuk dimuat lebih dulu atau menggantikan yang asli |
| `QT_PLUGIN_PATH`, `QT_QPA_PLATFORM_PLUGIN_PATH` | Plugin Qt (termasuk platform) dimuat dari folder yang ditunjuk |
| `QML_IMPORT_PATH` | Modul QML, yang dapat berisi JavaScript dan plugin, dimuat dari folder itu; dokumentasi Qt menyatakan berkas di jalur impor dianggap tepercaya |

Aturan: jangan mengekspor variabel ini secara global (`~/.bashrc`, sesi), jangan menunjuk folder yang dapat ditulis pihak lain, dan selalu gunakan prefiks per perintah (0.0.3). Pembahasan lanjut di Modul 13.1.

### e. Pola kerja

1. **Catat baseline:** `env` yang relevan dan hasil jalan tanpa variabel apa pun.
2. **Ubah satu variabel** per percobaan; kembalikan sebelum mencoba yang lain.
3. **Verifikasi bahwa variabel berlaku** (ejaan, `Qt.platform.pluginName`, `QSG_INFO`).
4. **Catat hasil, bukan kesan:** exit code, baris log kunci, dan tangkapan layar bila perlu.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Lingkungan tetap per proyek | `direnv`, atau skrip `run.sh` pembungkus | Satu tempat mencatat pengaturan; mudah di-commit |
| Lingkungan tetap per aplikasi | Berkas `.desktop` dengan `Exec=env VAR=...` | 0.3.7 |
| Aturan log tetap | `qtlogging.ini` | 0.3.5 |
| Pengaturan lewat kode | `qputenv("NAMA", "nilai")` di `main()` sebelum `QGuiApplication` | Hanya bila produk memerlukan; uji, jangan diam-diam |
| Mencatat lingkungan satu run | `env \| sort > env-run.txt` | Dibandingkan dengan `diff` |

### g. Visual

```
  shell (variabel diatur dengan prefiks atau export)
     |
     +--> qml / apphello   <---- membaca variabel SAAT START
               |                 (mengubah variabel sesudahnya tidak berpengaruh)
               +--> proses anak mewarisi salinan

  Qt membaca:  QT_QPA_PLATFORM -> plugin | QSG_* -> renderer | QML_* -> engine | QT_LOGGING_* -> log
  Nama salah ketik  -->  diabaikan DIAM-DIAM
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Variabel lingkungan | Pengaturan bernama yang diwariskan ke proses (0.0.3) |
| Prefiks variabel | `VAR=nilai perintah`: berlaku hanya untuk satu perintah |
| `env -u` / `env -i` | Hapus satu variabel / mulai dari lingkungan kosong |
| Baseline | Hasil acuan tanpa perubahan |
| Isolasi | Mengubah hanya satu faktor per percobaan |
| Permukaan serangan | Titik tempat pihak lain dapat memengaruhi program |

### i. Tips dan praktik terbaik

- Simpan matriks pengaturan di skrip, bukan di ingatan.
- Setelah selesai menyelidiki, pastikan tidak ada variabel yang tertinggal di shell (`env | grep -E '^(QT_|QSG)'`).
- Salin pengaturan penyelesaian masalah ke `catatan.md` beserta versi Qt dan driver.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Variabel tidak berefek | Salah ketik, atau diatur di shell lain | Cek ejaan; cek lingkungan proses (0.3.7) |
| Hasil berubah-ubah antar sesi | Variabel tertinggal dari `export` lama | `env \| grep`; buka shell baru |
| Mengubah banyak variabel sekaligus | Ingin cepat | Satu per percobaan; matriks |
| `;` dipotong shell | Tanda kutip tidak dipakai | `'wayland;xcb'` |
| Menaruh `LD_LIBRARY_PATH` di `~/.bashrc` | Mencoba “memperbaiki” satu aplikasi | Pakai prefiks per perintah |
| Mengira variabel di terminal memengaruhi aplikasi dari launcher | Lingkungan diwariskan, bukan dibagikan | 0.3.7 |

### k. Hubungan dengan modul lain

Prasyarat untuk 0.3.5 (log), 0.3.6 (protokol), 0.3.7 (asal lingkungan), Modul 12.1 (debugging), 12.3 (`QT_FATAL_WARNINGS` di uji), dan 13.1 (keamanan).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** (1) Jalankan `env | sort | grep ...` dan catat variabel `QT_`/`QSG_` yang aktif di shell Anda. (2) Jalankan `Plugin.qml` dengan `QT_QPA_PLATFROM=xcb` (salah ketik) dan buktikan lewat `Qt.platform.pluginName` bahwa ia tak berlaku; ulangi dengan ejaan benar. (3) Jalankan dengan `env -i ...` dan bandingkan hasilnya dengan baseline.

**Cek pemahaman.** (1) Mengapa nama variabel yang salah ketik berbahaya untuk diagnosa? (2) Apa bedanya `env -u` dan `env -i`? (3) Mengapa `LD_LIBRARY_PATH` tidak boleh diekspor global?

### m. Referensi

- [Qt Platform Abstraction](https://doc.qt.io/qt-6/qpa.html) · [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [Scene Graph Adaptations](https://doc.qt.io/qt-6/qtquick-visualcanvas-adaptations.html)
- [QLoggingCategory](https://doc.qt.io/qt-6/qloggingcategory.html) · [Debugging Techniques (QT\_MESSAGE\_PATTERN)](https://doc.qt.io/qt-6/debug.html)
- [Arch Wiki: Environment variables](https://wiki.archlinux.org/title/Environment_variables) · [env(1)](https://www.gnu.org/software/coreutils/manual/html_node/env-invocation.html)
- [ld.so(8)](https://man7.org/linux/man-pages/man8/ld.so.8.html)

---

## 0.3.5 Membaca log dan kategori logging

*Semangat: log adalah cerita yang ditulis program tentang dirinya sendiri; belajarlah membacanya dengan teliti.*

**Daftar isi 0.3.5:** a. Deskripsi dan peran · b. Konsep: tingkat, kategori, aturan · c. Mengamati tingkat pesan · d. Menyalakan kategori Qt · e. Contoh nyata: binding yang terputus · f. Mengatur format dan menyimpan aturan · g. Strategi membaca log · h. Logging di kode Anda · i. Opsi lain · j. Visual · k. Terminologi · l. Tips · m. Kesalahan umum · n. Hubungan · o. Latihan dan cek · p. Referensi

### a. Deskripsi dan peran

Sebagian besar pengetahuan Qt tentang masalah Anda tidak tampil secara bawaan. Ia disimpan di **kategori logging** yang bisa dinyalakan satu per satu. Bagian ini mengajarkan cara menyalakan hanya yang perlu, mengatur tampilannya, dan membandingkan hasil antar-run.

### b. Konsep: tingkat, kategori, aturan

- **Tingkat pesan:** `debug`, `info`, `warning`, `critical`, `fatal`. Pesan `fatal` menghentikan program dan tidak dapat dimatikan.
- **Kategori** adalah nama bertitik yang mengelompokkan pesan, misalnya `qt.qpa.plugin` atau `qt.scenegraph.general`. Kategori Qt yang berawalan `qt.` umumnya mematikan pesan `debug` dan `info` secara bawaan, supaya keluaran tetap sepi.
- **Aturan** menyalakan atau mematikan kategori. Bentuknya `kategori[.tipe]=true|false`, dipisah `;` bila banyak, dengan tanda `*` sebagai wildcard di awal atau akhir.
- Urutan pembacaan aturan (dokumentasi `QLoggingCategory`), yang **belakangan menang**: `qtlogging.ini` di folder data, `QtProject/qtlogging.ini`, `setFilterRules()` di kode, berkas dari `QT_LOGGING_CONF`, dan terakhir `QT_LOGGING_RULES`. Variabel lingkungan paling kuat, jadi paling cocok untuk uji sementara.

### c. Mengamati tingkat pesan

Simpan sebagai `Logs.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        console.debug('debug')
        console.log('log biasa')
        console.info('info')
        console.warn('peringatan')
        console.error('galat')
    }
}
```

```bash
$ QT_MESSAGE_PATTERN='[%{type}] %{category}: %{message}' timeout 3 qml Logs.qml
```

| Bagian | Arti |
| --- | --- |
| `console.debug/log/info/warn/error` | Fungsi logging JavaScript di QML; masing-masing menjadi pesan Qt bertingkat berbeda (error menjadi tingkat kritis). |
| `QT_MESSAGE_PATTERN='...'` | Mengatur format pesan. `%{type}` tingkat, `%{category}` kategori, `%{message}` isi. |
| `timeout 3` | Hentikan setelah 3 detik; jendela kosong dari akar `Item` tak perlu ditutup manual. |

Catat tingkat dan kategori yang tercetak untuk tiap baris **\[amati\]**; itulah petunjuk bagaimana Qt memetakan `console.*` ke tingkat pesannya di versi Anda.

Token format yang umum: `%{time yyyy.MM.dd hh:mm:ss.zzz}`, `%{type}`, `%{category}`, `%{message}`, `%{file}`, `%{line}`, `%{function}`, `%{pid}`, `%{appname}`, dan penyaring kondisional seperti `%{if-debug}...%{endif}`; `%{backtrace}` menambahkan jejak panggilan.

### d. Menyalakan kategori Qt

```bash
$ QT_LOGGING_RULES='qt.qpa.*=true' timeout 5 qml Plugin.qml &> qpa.log
$ wc -l qpa.log
$ QT_LOGGING_RULES='qt.scenegraph.general=true' timeout 5 qml Gpu.qml 2>&1 | head -10
$ QT_LOGGING_RULES='qt.qml.diskcache=true' timeout 5 qml Gpu.qml 2>&1 | head -10
$ QT_DEBUG_PLUGINS=1 timeout 5 qml Plugin.qml 2>&1 | head -10
```

| Bagian | Arti |
| --- | --- |
| `qt.qpa.*=true` | Nyalakan **semua** kategori yang berawalan `qt.qpa.` (platform). Hasilnya bisa panjang; sebab itu `&>` ke berkas, lalu `wc -l` dan `grep`. |
| `qt.scenegraph.general=true` | Informasi scene graph, termasuk render loop yang dipakai (0.3.3). |
| `qt.qml.diskcache=true` | Informasi tentang cache disk QML: apakah cache dipakai atau tidak. |
| `QT_DEBUG_PLUGINS=1` | Pintasan yang menyalakan kategori pemuatan plugin (`qt.core.plugin.*`); jejak yang Anda lihat di 0.3.2. |

Kategori yang terlihat dalam diskusi dan daftar komunitas, antara lain: `qt.qpa.events` dan `qt.quick.hover.trace` (**sangat** verbose; hindari kecuali perlu), `qt.qml.binding.removal`, `qt.qml.diskcache`, `qt.qpa.fonts`, `qt.qpa.gl`. Daftar sebenarnya ada di versi Qt Anda; jangan menebak nama, tanyakan dokumentasi modul terkait.

### e. Contoh nyata: binding yang terputus

Ini contoh dari 0.1.1. Simpan sebagai `Rebind.qml`:

```qml
import QtQuick

Rectangle {
    id: kotak
    width: 200
    height: width / 2
    color: 'steelblue'

    MouseArea {
        anchors.fill: parent
        onClicked: kotak.height = 100
    }
}
```

```bash
$ QT_LOGGING_RULES='qt.qml.binding.removal.info=true' qml Rebind.qml
```

Klik jendela. Penugasan `kotak.height = 100` memutus binding `width / 2`, dan kategori `qt.qml.binding.removal` mencatat bahwa sebuah binding ditimpa **\[amati\]**: pesannya menyebut properti dan lokasi berkas. Tanpa kategori ini, Anda hanya melihat bahwa tinggi “tidak lagi mengikuti lebar”. Inilah bedanya diagnosa yang berbasis bukti dan firasat.

### f. Mengatur format dan menyimpan aturan

```ini
[Rules]
*.debug=false
qt.qpa.plugin=true
```

Simpan sebagai `~/.config/QtProject/qtlogging.ini` untuk aturan permanen, atau sebagai berkas lain yang ditunjuk `QT_LOGGING_CONF`:

```bash
$ mkdir -p ~/.config/QtProject
$ ls ~/.config/QtProject
$ QT_LOGGING_CONF=$PWD/qtlogging.ini qml Main.qml
```

| Bagian | Arti |
| --- | --- |
| `[Rules]` | Bagian berkas yang memuat aturan. |
| `*.debug=false` | Matikan semua pesan `debug`. |
| `qt.qpa.plugin=true` | Nyalakan seluruh pesan kategori itu (semua tingkat). |
| `~/.config/QtProject/qtlogging.ini` | Berkas aturan pribadi; berlaku untuk **semua** aplikasi Qt Anda. Periksa isinya bila ada keluaran log yang tak Anda kenali. |
| `QT_LOGGING_CONF=...` | Berkas aturan khusus untuk satu run; lebih kuat dari berkas pribadi, lebih lemah dari `QT_LOGGING_RULES`. |

### g. Strategi membaca log

1. **Baca dari atas**, error pertama (0.0.7).
2. **Kurangi bising di sumbernya**: nyalakan satu kategori, bukan semuanya.
3. **Saring** dengan `grep -i -E 'warn|error|fail|cannot'`.
4. **Buat keluaran yang dapat dibandingkan**: pakai pola pesan tanpa waktu dan pid (`QT_MESSAGE_PATTERN='%{category}: %{message}'`), simpan dua run ke berkas, lalu:

```bash
$ diff -u bagus.log buruk.log | less
```

5. **Hitung, jangan hanya lihat**: `grep -c 'binding' log` mencacah kemunculan; `sort log | uniq -c | sort -rn | head` memperlihatkan pesan yang berulang.
6. **Bersihkan data pribadi** (nama pengguna, nama host, path rumah, IP) sebelum membagikan log ke luar (0.0.7).

### h. Logging di kode Anda

```cpp
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(lcApp, "app.network", QtInfoMsg)

void contoh()
{
    qCInfo(lcApp) << "terhubung";
    qCDebug(lcApp) << "detail yang ramai";
}
```

| Bagian | Arti |
| --- | --- |
| `Q_LOGGING_CATEGORY(lcApp, "app.network", QtInfoMsg)` | Mendefinisikan kategori bernama `app.network`; argumen ketiga menetapkan tingkat paling rendah yang aktif bawaan (`QtInfoMsg` mematikan `debug`). |
| `qCInfo(lcApp)`, `qCDebug(lcApp)` | Mencatat pesan pada kategori itu dengan tingkat info dan debug. |
| `app.network.debug=true` | Aturan yang menyalakan pesan debug kategori Anda tanpa membangun ulang. |

Praktik terbaik: beri nama kategori mengikuti struktur aplikasi (`app.network`, `app.ui`, `app.storage`) supaya pengguna dan Anda dapat menyalakan bagiannya masing-masing. QML punya tipe `LoggingCategory` untuk hal serupa; modul impornya dapat berbeda antar versi, jadi periksa dokumentasi versi Anda (Modul 12.1).

### i. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Peringatan Qt menjadi galat | `QT_FATAL_WARNINGS=1` | Aplikasi berhenti pada peringatan pertama; berguna di uji dan di bawah debugger |
| Log aplikasi yang dijalankan systemd | `journalctl --user -f` | Bila aplikasi dijalankan sebagai layanan pengguna |
| Log ke berkas dari kode | Pasang `qInstallMessageHandler` | Modul 12.1 |
| Log kinerja | Profiler dan `console.time` | Modul 11.4 |
| Rekam sesi terminal | `script`, atau `tee log.txt` | Bukti run lengkap |

### j. Visual

```
  kode / Qt  --pesan(kategori, tingkat)-->  [ FILTER aturan ]  --> [ FORMAT pola ]  --> stderr
                                                ^                        ^
          urutan aturan: qtlogging.ini -> QtProject/qtlogging.ini -> setFilterRules
                         -> QT_LOGGING_CONF -> QT_LOGGING_RULES  (yang terakhir menang)
                                                                  QT_MESSAGE_PATTERN
```

### k. Terminologi

| Istilah | Arti |
| --- | --- |
| Kategori logging | Nama bertitik yang mengelompokkan pesan |
| Tingkat | debug, info, warning, critical, fatal |
| Aturan penyaring | kategori\[.tipe\]=true atau false |
| Wildcard | `*` untuk mencocokkan awalan atau akhiran nama |
| `QT_MESSAGE_PATTERN` | Pola format keluaran pesan |
| `qtlogging.ini` | Berkas aturan logging persisten |
| Message handler | Fungsi yang menerima semua pesan sebelum dicetak |
| Verbose | Sangat ramai; sering dimatikan |

### l. Tips dan praktik terbaik

- Nyalakan kategori secukupnya, simpan ke berkas, baru saring; jangan menggulir ribuan baris.
- Jangan menaruh aturan sementara di `qtlogging.ini` pribadi; Anda akan lupa dan bingung beberapa bulan lagi.
- Jangan mencatat rahasia (kata sandi, token) ke log, termasuk lewat `console.log`.
- Beri kategori sendiri untuk aplikasi Anda dari awal.

### m. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Kategori dinyalakan tetapi tidak ada keluaran | Salah nama kategori, atau perlu `.debug` atau `.info` | Cek ejaan; coba `kategori=true` atau `kategori.debug=true` |
| Log terlalu panjang | Wildcard terlalu luas (`qt.*`) atau kategori verbose | Persempit; hindari `qt.qpa.events*` |
| Keluaran log hilang dari layar | Aplikasi dijalankan dari launcher, tanpa terminal | Jalankan dari terminal, atau arahkan ke berkas |
| Aturan tidak berlaku | Ditimpa sumber yang lebih kuat | Ingat urutan: `QT_LOGGING_RULES` paling akhir |
| `diff` penuh perbedaan waktu | Pola pesan memuat waktu dan pid | Pakai pola tanpa waktu |
| Mengira `console.error` menghentikan program | Ia hanya mencatat | Hentikan dengan `QT_FATAL_WARNINGS` atau logika Anda |

### n. Hubungan dengan modul lain

Prasyarat untuk 0.3.6 (matriks dan perbandingan), Modul 3.1 (binding removal), 11.4 (log performa), 12.1 (message handler dan `LoggingCategory`), dan 12.3 (`QT_FATAL_WARNINGS` pada pengujian).

### o. Latihan dan cek pemahaman

**Latihan 15 menit.** (1) Jalankan `Logs.qml` dengan pola pesan di bagian c dan catat tingkat serta kategori tiap baris. (2) Jalankan `Rebind.qml` dengan kategori `qt.qml.binding.removal.info`, klik jendela, dan salin pesannya. (3) Simpan dua run `Plugin.qml` (`wayland` dan `xcb`) dengan pola `'%{category}: %{message}'`, dan bandingkan dengan `diff -u`.

**Cek pemahaman.** (1) Dari mana saja aturan logging dibaca, dan mana yang menang? (2) Mengapa `qt.qpa.events` berbahaya dinyalakan tanpa pikir? (3) Bagaimana membuat dua log dapat dibandingkan dengan `diff`?

### p. Referensi

- [QLoggingCategory](https://doc.qt.io/qt-6/qloggingcategory.html) · [Debugging Techniques: QT\_MESSAGE\_PATTERN](https://doc.qt.io/qt-6/debug.html)
- [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html) · [Console API (QML)](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)
- [KDE: Using Error Messages (QT\_LOGGING\_RULES, QT\_MESSAGE\_PATTERN)](https://community.kde.org/Guidelines_and_HOWTOs/Debugging/Using_Error_Messages)
- [diff(1)](https://www.gnu.org/software/diffutils/manual/html_node/Invoking-diff.html) · [journalctl](https://man7.org/linux/man-pages/man1/journalctl.1.html)

---

## 0.3.6 Protokol diagnosa terisolasi dan laporan masalah \[TAMBAHAN\]

**Mengapa ditambahkan:** kurikulum menyebut “mengubah banyak variabel sekaligus sehingga penyebab tidak terisolasi” sebagai kesalahan umum, tetapi tidak membekali cara menghindarinya. Bagian ini adalah protokolnya: matriks eksperimen yang otomatis, cara membandingkannya, dan cara melaporkan hasilnya kepada orang lain secara berguna.

*Semangat: yang bekerja dengan protokol tidak pernah kehilangan arah.*

**Daftar isi 0.3.6:** a. Deskripsi dan peran · b. Protokol lima langkah · c. Skrip matriks `diag.sh` · d. Membaca hasil · e. Bisect berdasarkan tahap · f. Mengumpulkan lingkungan · g. Templat laporan masalah · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Menebak itu mahal; mengukur itu murah. Protokol ini membuat setiap dugaan menjadi satu baris pada tabel hasil, dan menyisakan bukti yang dapat diperiksa orang lain.

### b. Protokol lima langkah

1. **Reproduksi minimal.** Cari QML sekecil mungkin yang masih memperlihatkan masalah (`Window { visible: true }` atau `Gpu.qml`).
2. **Baseline.** Jalankan tanpa variabel apa pun dan catat hasil, exit code, dan log.
3. **Matriks, satu faktor per baris.** Ubah plugin platform, backend, render loop, atau lingkungan, **satu** pada satu waktu, dengan `timeout`.
4. **Bandingkan.** `diff` antar-log; hitung baris; cari kata *error*, *failed*, *cannot*.
5. **Simpulkan dan catat.** Tulis apa yang terbukti, apa yang dibantah, dan apa yang belum diketahui.

### c. Skrip matriks diag.sh

```bash
#!/usr/bin/env bash
# diag.sh: jalankan satu QML pada beberapa kombinasi, simpan log per kombinasi
set -u
berkas=${1:-Gpu.qml}
mkdir -p diag-logs

jalankan() {
    local nama=$1
    shift
    env QSG_INFO=1 QT_MESSAGE_PATTERN='%{category}: %{message}' "$@" \
        timeout 8 qml "$berkas" &> "diag-logs/$nama.log"
    local kode=$?
    local baris
    baris=$(wc -l < "diag-logs/$nama.log")
    printf '%-10s exit=%s baris=%s\n' "$nama" "$kode" "$baris"
}

jalankan bawaan
jalankan xcb       QT_QPA_PLATFORM=xcb
jalankan wayland   QT_QPA_PLATFORM=wayland
jalankan offscreen QT_QPA_PLATFORM=offscreen
jalankan software  QT_QUICK_BACKEND=software
jalankan opengl    QSG_RHI_BACKEND=opengl
jalankan vulkan    QSG_RHI_BACKEND=vulkan
jalankan basic     QSG_RENDER_LOOP=basic
```

```bash
$ chmod +x diag.sh
$ ./diag.sh Gpu.qml
$ grep -l -i -E 'error|fail|cannot' diag-logs/*.log
$ diff -u diag-logs/bawaan.log diag-logs/software.log | less
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `#!/usr/bin/env bash` | *Shebang*: baris pertama yang memberi tahu sistem bahwa skrip ini dijalankan dengan bash. |
| `set -u` | Berhenti dengan pesan bila memakai variabel yang belum diatur (menangkap salah ketik). |
| `berkas=${1:-Gpu.qml}` | Argumen pertama skrip, dengan `Gpu.qml` sebagai nilai bawaan bila kosong. |
| `mkdir -p diag-logs` | Folder penampung log. |
| `jalankan() { ... }` | Mendefinisikan fungsi; dipanggil dengan nama diikuti argumennya. |
| `local nama=$1` lalu `shift` | Ambil argumen pertama sebagai nama kombinasi, lalu buang dari daftar sehingga `"$@"` hanya berisi pasangan `VARIABEL=nilai`. |
| `env QSG_INFO=1 ... "$@" timeout 8 qml ...` | Jalankan `qml` dengan variabel dasar (informasi scene graph, pola pesan deterministik) ditambah variabel khas kombinasi, selama maksimal 8 detik. Garis miring terbalik di ujung baris hanya melanjutkan perintah. |
| `&> "diag-logs/$nama.log"` | Simpan semua keluaran ke berkas log kombinasi itu. |
| `local kode=$?` | Tangkap exit code **segera**, sebelum perintah lain menimpanya. |
| `wc -l < berkas` | Hitung jumlah baris log. |
| `printf '%-10s ...\n'` | Cetak baris ringkas berformat rapi. |
| `jalankan xcb QT_QPA_PLATFORM=xcb` | Satu baris matriks: namanya, lalu variabel yang diubah. |

### d. Membaca hasil

| Exit code | Arti |
| --- | --- |
| `124` | Dibunuh `timeout` setelah 8 detik: aplikasi **bertahan hidup** (baik) |
| `0` | Berhenti sendiri dengan bersih |
| `255` | Gagal memuat QML (0.2.3) |
| `134` | Berhenti lewat `abort` (128 + 6): crash atau galat fatal |
| `139` | *Segmentation fault* (128 + 11): crash |
| Lainnya | Baca log kombinasi itu |

Tabel hasil milik Anda, contoh bentuknya:

| Kombinasi | Exit | Kesan visual | Catatan log |
| --- | --- | --- | --- |
| bawaan | 124 | normal | backend: ... |
| software | 124 | normal tanpa efek tertentu | ... |
| vulkan | 1 | tidak muncul | pesan driver ... |

**Cara menyimpulkan:** bila hanya satu baris yang menyimpang, satu faktor itulah yang berperan. Bila beberapa menyimpang, baca log terpendek terlebih dahulu.

### e. Bisect berdasarkan tahap

Bila gejalanya belum jelas, bagi dua dengan tahap di 0.3.1: apakah proses sampai tahap 1? tahap 3? tahap 4? Tiap jawaban membuang setengah ruang dugaan, sama seperti `git bisect` membuang setengah riwayat commit.

### f. Mengumpulkan lingkungan

```bash
$ { uname -sr; pacman -Q qt6-base qt6-declarative; echo "session=$XDG_SESSION_TYPE"; lspci -k | grep -A3 -E 'VGA|3D'; env | sort | grep -E '^(QT_|QML|QSG)'; } > lingkungan.txt
$ cat lingkungan.txt
```

| Bagian | Arti |
| --- | --- |
| `{ ...; } > lingkungan.txt` | Kelompokkan perintah, alihkan seluruh keluaran ke satu berkas (0.2.8). |
| `uname -sr` | Nama dan versi kernel. |
| `pacman -Q ...` | Versi paket Qt. |
| `echo "session=..."` | Jenis sesi. |
| `lspci -k ... \| grep ...` | GPU dan driver kernelnya. |
| `env \| sort \| grep ...` | Variabel Qt yang aktif. |

### g. Templat laporan masalah

## Ringkasan
Satu kalimat: apa yang terjadi dan apa yang diharapkan.

## Lingkungan
- Distro dan kernel:
- Qt (pacman -Q qt6-base qt6-declarative):
- Sesi dan compositor, plugin platform (Qt.platform.pluginName):
- GPU dan driver (lspci -k, glxinfo -B, vulkaninfo --summary):
- Variabel lingkungan aktif (env | grep ...):

## Langkah reproduksi minimal
1. QML minimal terlampir
2. Perintah yang dijalankan

## Hasil
- Diharapkan:
- Aktual:

## Matriks diagnosa
(tabel dari diag.sh)

## Log relevan
(dipotong dan dibersihkan dari data pribadi)

Laporkan ke tempat yang tepat: masalah di Qt ke [bug tracker Qt](https://bugreports.qt.io/); masalah pemaketan atau integrasi distro ke pelacak Arch (lihat panduan di Arch Wiki). Cari laporan serupa dulu.

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Bisect riwayat kode | `git bisect` | Menemukan commit yang memulai masalah (0.0.6) |
| Matriks lebih luas | Loop `for` pada skrip | Hati-hati dengan ledakan kombinasi |
| Lingkungan benar-benar bersih | Kontainer `podman` atau pengguna uji | Memisahkan masalah mesin dari masalah kode |
| Rekaman sesi | `script sesi.log` | Merekam seluruh sesi terminal |
| Uji otomatis | `ctest` dengan `offscreen` | Modul 12.3 |

### i. Visual

```
  gejala --> [1 minimal] --> [2 baseline] --> [3 matriks: 1 faktor / baris]
                                                  |
                                  +---------------+---------------+
                                  v                               v
                          satu baris menyimpang            banyak baris menyimpang
                                  |                               |
                          faktor itu penyebab           baca log terpendek, ulangi dari tahap rendah
                                  |
                         [4 diff] --> [5 catat + laporkan]
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Reproduksi minimal (MRE) | Contoh sekecil mungkin yang masih memunculkan masalah |
| Baseline | Hasil acuan tanpa perubahan |
| Matriks eksperimen | Tabel kombinasi yang diuji |
| Bisect | Pencarian biner penyebab dengan membagi dua ruang dugaan |
| Fungsi shell | Blok perintah bernama di skrip |
| `shift` | Membuang argumen pertama dari daftar argumen |
| Exit code 124 | Dibunuh oleh `timeout` |

### k. Tips dan praktik terbaik

- Simpan `diag.sh` dan `Gpu.qml` di repositori belajar Anda; pakai ulang di setiap mesin.
- Jalankan skrip dua kali untuk memastikan hasil dapat diulang sebelum menyimpulkan.
- Jangan memperluas matriks sebelum memahami baris yang ada.
- Tulis kesimpulan sebagai kalimat yang dapat dibantah (“masalah hilang pada `software`, jadi jalur GPU Qt terlibat”).

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Hasil tidak konsisten | Satu run, tanpa pengulangan | Ulangi tiga kali |
| Seluruh kombinasi “gagal” | Masalah di baseline atau QML | Perbaiki baseline dulu (0.3.1) |
| Kesimpulan terlalu cepat | Mengubah dua faktor sekaligus | Satu faktor per baris |
| Skrip berhenti `unbound variable` | `set -u` menangkap salah ketik | Perbaiki nama variabel |
| Log berisi data pribadi dan sudah dikirim | Lupa membersihkan | Sunting dulu; tinjau sebelum dibagikan |
| `vulkan` gagal padahal `opengl` baik | Tidak ada driver Vulkan | Itu temuan, bukan kegagalan skrip; catat |

### m. Hubungan dengan modul lain

Prasyarat untuk Modul 12.1 (debugging), 12.3 (uji otomatis), 13.2 (uji di mesin target), dan 14.6 (menyelidiki proyek asing).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Salin `diag.sh` dan `Gpu.qml`, jalankan, dan isi tabel hasil. Pilih satu baris yang menyimpang (mis. `vulkan` atau `wayland`), lalu jalankan `diff -u` terhadap `bawaan.log` dan tulis satu kalimat kesimpulan beserta bukti barisnya. Buat `lingkungan.txt`.

**Cek pemahaman.** (1) Mengapa satu faktor per percobaan? (2) Apa arti exit code 124, 134, dan 139? (3) Apa saja isi minimum laporan masalah?

### o. Referensi

- [Bash: Shell Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html) · [Bash: The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
- [Arch Wiki: Bug reporting guidelines](https://wiki.archlinux.org/title/Bug_reporting_guidelines) · [Qt Bug Tracker](https://bugreports.qt.io/)
- [Stack Overflow: Minimal reproducible example](https://stackoverflow.com/help/minimal-reproducible-example) · [git bisect](https://git-scm.com/docs/git-bisect)
- [signal(7): nomor sinyal](https://man7.org/linux/man-pages/man7/signal.7.html)

---

## 0.3.7 Dari mana lingkungan berasal: shell, launcher, sesi \[TAMBAHAN\]

**Mengapa ditambahkan:** kurikulum memperingatkan “mengatur variabel lingkungan di shell lain dari tempat aplikasi dijalankan” tetapi tidak mengajarkan bagaimana mengetahui dari mana lingkungan sebuah aplikasi berasal dan bagaimana membuktikannya. Ini kelanjutan langsung dari 0.0.3.

*Semangat: kontrol sejati adalah mengetahui dari mana setiap nilai datang.*

**Daftar isi 0.3.7:** a. Deskripsi dan peran · b. Konsep: lingkungan diwariskan, bukan dibagikan · c. Memeriksa lingkungan proses yang berjalan · d. Sumber lingkungan di sesi Linux · e. Mengatur secara permanen, secara terkendali · f. tmux dan SSH · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

“Saya sudah mengatur variabelnya, tetapi tidak berpengaruh” hampir selalu berarti **aplikasi itu tidak memperoleh variabelnya**. Bagian ini mengajarkan cara memeriksa lingkungan yang benar-benar diterima sebuah proses, dan jalur mana yang dapat memberinya variabel.

### b. Konsep: lingkungan diwariskan, bukan dibagikan

Setiap proses menerima **salinan** lingkungan induknya saat dibuat (0.0.3). Maka lingkungan sebuah aplikasi bergantung pada **siapa yang meluncurkannya**: terminal Anda (shell), launcher desktop, compositor, atau manajer layanan. Mengubah variabel di terminal A tidak mengubah apa pun pada aplikasi yang sudah berjalan, dan tidak pada aplikasi yang diluncurkan oleh peluncur lain.

### c. Memeriksa lingkungan proses yang berjalan

```bash
$ ./build/apphello &
$ pgrep -n apphello
$ tr '\0' '\n' < /proc/$(pgrep -n apphello)/environ | grep -E '^(QT_|QSG|QML|WAYLAND|DISPLAY|XDG_SESSION)'
$ kill %1
```

| Bagian | Arti |
| --- | --- |
| `./build/apphello &` | Jalankan di latar belakang (0.0.3); `%1` adalah nomor jobnya. |
| `pgrep -n apphello` | PID proses **terbaru** bernama itu. |
| `/proc/PID/environ` | Berkas virtual berisi lingkungan proses **pada saat ia dimulai**; hanya terbaca oleh pemiliknya. Variabel dipisah karakter NUL. |
| `tr '\0' '\n'` | Ubah pemisah NUL menjadi baris baru agar terbaca. |
| `$(pgrep -n apphello)` | Substitusi perintah: hasilnya (PID) disisipkan ke dalam path. |
| `grep -E '...'` | Saring variabel yang relevan. |
| `kill %1` | Hentikan job latar belakang. |

Inilah **bukti**: bila `QT_QPA_PLATFORM` tidak ada di sini, aplikasi itu tidak pernah menerimanya, apa pun yang Anda ketik di terminal lain. Nilai di berkas ini tidak ikut berubah bila proses sendiri memanggil `setenv` belakangan; ia menunjukkan keadaan awal.

### d. Sumber lingkungan di sesi Linux

| Sumber | Berlaku untuk | Memeriksanya |
| --- | --- | --- |
| Shell interaktif (`~/.bashrc`) | Perintah yang Anda ketik di shell itu dan anak-anaknya | `env` di shell itu |
| Shell login (`~/.profile`, `~/.bash_profile`) | Sesi yang memuatnya; tergantung display manager | `env` di shell login |
| Lingkungan pengguna systemd (`~/.config/environment.d/*.conf`) | Layanan dan aplikasi yang dimulai lewat systemd pengguna; banyak sesi desktop mengimpornya | `systemctl --user show-environment` |
| Konfigurasi compositor atau window manager | Aplikasi yang diluncurkan compositor | Dokumentasi compositor Anda |
| Berkas `.desktop` (`Exec=env VAR=... aplikasi`) | Aplikasi yang diluncurkan dari menu aplikasi | Isi berkas dan `/proc/PID/environ` |
| Skrip pembungkus | Hanya aplikasi yang diluncurkan lewat skrip itu | Isi skrip |
| `dbus-update-activation-environment` | Aplikasi yang diaktifkan lewat D-Bus | Dokumentasi D-Bus dan sesi Anda |

Mekanisme persis berbeda antar desktop dan compositor; selalu verifikasi dengan `/proc/PID/environ` pada aplikasi yang nyata, bukan dengan asumsi.

### e. Mengatur secara permanen, secara terkendali

Skrip pembungkus pribadi, paling mudah diaudit dan dikendalikan, simpan sebagai `~/.local/bin/apphello-xcb`:

```bash
#!/usr/bin/env bash
exec env QT_QPA_PLATFORM=xcb "$HOME/Development/qt-learning/hello/build/apphello" "$@"
```

```bash
$ chmod 755 ~/.local/bin/apphello-xcb
$ command -v apphello-xcb
```

| Bagian | Arti |
| --- | --- |
| `exec` | Ganti proses skrip dengan aplikasi, sehingga tidak ada shell perantara yang tersisa. |
| `env QT_QPA_PLATFORM=xcb ...` | Jalankan aplikasi dengan variabel itu hanya untuk dirinya. |
| `"$@"` | Teruskan semua argumen yang diberikan ke skrip. |
| `chmod 755` | Izin eksekusi (0.0.5). |
| `command -v` | Pastikan `~/.local/bin` ada di `PATH` dan skrip ditemukan. |

Untuk meluncurkan dari menu, berkas `~/.local/share/applications/apphello.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Hello Qt (xcb)
Exec=env QT_QPA_PLATFORM=xcb /home/anda/Development/qt-learning/hello/build/apphello
Terminal=false
```

Pengaturan **global** lewat `~/.config/environment.d/50-qt.conf` berisi baris `NAMA=nilai` berlaku untuk seluruh sesi setelah login ulang. Pakai hanya untuk nilai yang benar-benar aman bagi semua aplikasi, misalnya daftar cadangan `QT_QPA_PLATFORM=wayland;xcb`; **jangan** memaksa satu plugin secara global (0.3.2) atau menaruh variabel pemuat kode di sini (0.3.4).

### f. tmux dan SSH

- **tmux** menyimpan lingkungan saat sesinya dibuat. Setelah login ulang, `WAYLAND_DISPLAY` atau `DISPLAY` di dalam sesi tmux lama dapat usang, sehingga aplikasi gagal menemukan server tampilan. Periksa dengan `tmux show-environment` dan atur ulang di panel yang bermasalah; opsi `update-environment` pada tmux menentukan variabel mana yang disegarkan saat menyambung kembali.
- **SSH** biasanya tidak membawa variabel tampilan. Untuk menjalankan aplikasi Qt tanpa layar gunakan `QT_QPA_PLATFORM=offscreen`; untuk benar-benar menampilkan, butuh pengaturan terpisah (forwarding) yang di luar Fase 0.

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Lihat lingkungan tanpa menjalankan aplikasi | `systemctl --user show-environment` | Lingkungan manajer layanan pengguna |
| Lihat variabel proses lain | `/proc/PID/environ` | Hanya milik pengguna yang sama |
| Bandingkan dua lingkungan | `diff <(tr '\0' '\n' < /proc/A/environ) <(tr '\0' '\n' < /proc/B/environ)` | Sintaks `<( )` adalah *process substitution* bash |
| Lingkungan per direktori | `direnv` | Mengatur otomatis saat masuk folder |
| Debug peluncuran | `strace -f -e trace=execve` | Melihat perintah dan lingkungan yang diteruskan |

### h. Visual

```
  display manager / login
        |
        +--> shell login (~/.profile) -----+
        +--> systemd --user (environment.d)+--> compositor --> launcher ---> aplikasi (lingkungan SALINAN)
        |                                  |
        |                                  '--> terminal --> shell (~/.bashrc) --> aplikasi dari terminal
        '--> .desktop Exec=env ... / skrip pembungkus --> aplikasi

  yang pasti benar: /proc/PID/environ  pada aplikasi yang nyata
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Lingkungan proses | Tabel nama-nilai milik satu proses |
| `/proc/PID/environ` | Lingkungan proses pada saat dimulai |
| Shell login / interaktif | Jenis shell yang membaca berkas konfigurasi berbeda |
| `environment.d` | Mekanisme pengaturan lingkungan sesi pengguna systemd |
| Launcher | Program peluncur aplikasi dari menu |
| Process substitution | `<( )` yang memperlakukan keluaran perintah sebagai berkas |
| Skrip pembungkus | Skrip kecil yang mengatur lingkungan lalu menjalankan aplikasi |

### j. Tips dan praktik terbaik

- Bukti didahulukan: periksa `/proc/PID/environ` sebelum menyimpulkan apa pun tentang variabel.
- Atur variabel sedekat mungkin dengan aplikasi yang membutuhkannya: prefiks, lalu skrip pembungkus, lalu `.desktop`; global adalah pilihan terakhir.
- Simpan skrip pembungkus di git dan baca ulang saat mengubahnya.
- Setelah login ulang, buka shell dan sesi tmux **baru** untuk menghindari lingkungan usang.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Variabel diatur, aplikasi dari launcher tidak terpengaruh | Variabel hanya ada di shell | Atur di `.desktop`, skrip pembungkus, atau `environment.d` |
| `.bashrc` tidak dibaca oleh aplikasi grafis | Aplikasi tidak diluncurkan dari shell interaktif | Jangan bergantung padanya untuk aplikasi GUI |
| Aplikasi gagal start karena plugin global | `QT_QPA_PLATFORM` dipaksa untuk semua | Gunakan daftar cadangan atau per aplikasi |
| tmux: aplikasi tak menemukan tampilan | Variabel usang | `tmux show-environment`, atur ulang |
| Variabel pemuat kode di `environment.d` | Kemudahan yang berisiko | Hapus; gunakan prefiks per perintah |
| Mengira nilai di `environ` akan ikut berubah | Itu keadaan awal | Mulai ulang aplikasi setelah mengubah lingkungan peluncurnya |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 13.1 (keamanan lingkungan), 13.2 (peluncuran di desktop), 13.3 (skrip dan berkas `.desktop` saat packaging), dan 14.6 (menyelidiki aplikasi lain).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** (1) Jalankan `apphello` dengan `QT_QPA_PLATFORM=xcb` sebagai prefiks dan buktikan lewat `/proc/PID/environ` bahwa variabel itu ada; ulangi tanpa prefiks. (2) Buat skrip pembungkus `apphello-xcb` dan buktikan hal yang sama. (3) Bila memakai tmux, bandingkan `tmux show-environment` dengan `env` di shell login.

**Cek pemahaman.** (1) Mengapa variabel di terminal A tidak memengaruhi aplikasi dari launcher? (2) Bagaimana membuktikan variabel apa yang diterima suatu proses? (3) Mengapa pengaturan global `QT_QPA_PLATFORM` berisiko?

### n. Referensi

- [Arch Wiki: Environment variables](https://wiki.archlinux.org/title/Environment_variables) · [Arch Wiki: systemd/User](https://wiki.archlinux.org/title/Systemd/User)
- [environment.d(5)](https://man7.org/linux/man-pages/man5/environment.d.5.html) · [proc\_pid\_environ(5)](https://man7.org/linux/man-pages/man5/proc_pid_environ.5.html)
- [Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/latest/) · [tmux: Environment](https://github.com/tmux/tmux/wiki/Getting-Started#environment)
- [Bash: Process Substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html)

---

## 7.7 Penutup Modul 0.3

**Daftar isi bagian ini:** 7.7.1 Peta konsep · 7.7.2 Latihan terpadu · 7.7.3 Cek pemahaman modul · 7.7.4 Hubungan ke modul berikutnya · 7.7.5 Pembaruan yang diusulkan untuk kurikulum · 7.7.6 Status

### 7.7.1 Peta konsep

```
   0.3.1 Tujuh tahap startup  (peta: di mana gagal?)
        |
        +-- 0.3.2 Plugin platform      (tahap 1)
        +-- 0.3.3 Renderer, RHI, software (tahap 4 dan 5)
        |
   0.3.4 Variabel diagnostik (tuas)        0.3.5 Log dan kategori (mata)
        |                                        |
        +------------------+---------------------+
                           v
        0.3.6 Protokol: satu faktor per percobaan + laporan
                           |
        0.3.7 Dari mana lingkungan berasal (bukti: /proc/PID/environ)
                           |
                           v
                   Penutup Fase 0  -->  Fase 1
```

### 7.7.2 Latihan terpadu

Di folder proyek `hello` (45–60 menit): (1) jalankan `Plugin.qml` dan `Gpu.qml` dan catat `Qt.platform.pluginName` serta `QSG_INFO`; (2) jalankan `diag.sh` dan isi tabel hasil; (3) sengaja salah eja URI di `main.cpp`, bangun, dan tentukan tahap kegagalan dari `startup.log` (0.3.1); (4) jalankan dengan `QT_QPA_PLATFROM=xcb` (salah ketik), dan buktikan variabel itu diabaikan; (5) buat skrip pembungkus `apphello-xcb` dan buktikan lingkungannya lewat `/proc/PID/environ`; (6) buat `lingkungan.txt`; (7) tambahkan `diag-logs/` ke `.gitignore`, commit `diag.sh`, `Plugin.qml`, `Gpu.qml`, dan `.gitignore` dengan pesan yang bermakna.

### 7.7.3 Cek pemahaman modul

1. Sebutkan tujuh tahap startup dan satu bukti untuk masing-masing.
2. Bagaimana membuktikan plugin platform yang sedang dipakai sebuah aplikasi Qt Quick?
3. Apa beda backend RHI dan adaptasi software? Sebutkan variabel yang memilih masing-masing.
4. Bagaimana membuktikan bahwa masalah tampilan berasal dari GPU, bukan dari QML?
5. Apa fungsi `QML_IMPORT_TRACE`, dan pada tahap berapa ia berguna?
6. Mengapa nama variabel yang salah ketik berbahaya, dan bagaimana mendeteksinya?
7. Dari mana saja aturan logging dibaca, dan mana yang menang bila bentrok?
8. Mengapa mengubah banyak variabel sekaligus merusak diagnosa? Jelaskan protokol alternatifnya.
9. Mengapa variabel di terminal A tidak memengaruhi aplikasi dari launcher, dan bagaimana membuktikannya?
10. Sebutkan tiga variabel yang mengubah kode apa yang dimuat, dan mengapa tidak boleh diekspor global.

### 7.7.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 0.3 |
| --- | --- |
| Fase 1 sampai 6 | Kemampuan mendiagnosa saat contoh tidak tampil: tahap, bukti, matriks |
| Fase 9 Controls | `QT_QUICK_CONTROLS_STYLE`, `QT_QPA_PLATFORMTHEME`, perilaku Wayland dan X11 (0.3.2, 0.3.4) |
| Fase 10 C++/QML | Urutan startup (0.3.1), `QQuickWindow::setGraphicsApi` (0.3.3) |
| Fase 11 Rendering | RHI, render loop, software, `qt.scenegraph.general` (0.3.3) |
| Fase 12 Testing | `offscreen`, `QT_FATAL_WARNINGS`, log (0.3.2, 0.3.5), protokol (0.3.6) |
| Fase 13 Deployment | Asal lingkungan, skrip pembungkus dan `.desktop`, risiko variabel (0.3.4, 0.3.7) |

### 7.7.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda sebagai pengganti atau tambahan pada Modul 0.3.

**Konsep & analogi (tambahan).** Tujuh tahap: proses lahir, platform, engine, memuat QML, jendela dan RHI, render loop, event loop. Periksa berurutan dan berhenti pada tahap pertama yang gagal.

**Contoh minimal (pengganti).**

```
QT_QPA_PLATFORM=wayland qml Main.qml
QT_QPA_PLATFORM=xcb qml Main.qml
QT_QPA_PLATFORM=offscreen timeout 5 qml Main.qml
QT_QUICK_BACKEND=software qml Main.qml
QSG_RHI_BACKEND=vulkan QSG_INFO=1 qml Main.qml
QSG_RENDER_LOOP=basic QT_LOGGING_RULES='qt.scenegraph.general=true' qml Main.qml
QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | head -50
```

Pola yang sama berlaku untuk `./build/apphello`.

**Terminologi (pengganti).** Platform plugin (QPA, lapisan antara Qt dan sistem jendela); RHI (abstraksi API grafis); backend RHI (OpenGL, Vulkan, Metal, Direct3D; dipilih dengan `QSG_RHI_BACKEND`; bawaan Linux: OpenGL); adaptasi software (renderer raster di CPU, dipilih dengan `QT_QUICK_BACKEND=software`; bukan backend RHI dan tidak mendukung 3D); render loop (`basic` atau `threaded`; `QSG_RENDER_LOOP`); kategori logging (`QT_LOGGING_RULES`); import trace (log pencarian modul).

**Daftar isi.** 0.3.1 Urutan startup aplikasi Qt Quick · 0.3.2 Plugin platform: Wayland, X11, dan tanpa layar · 0.3.3 Renderer dan backend RHI, termasuk software · 0.3.4 Variabel lingkungan diagnostik · 0.3.5 Membaca log dan kategori logging · 0.3.6 Protokol diagnosa terisolasi dan laporan masalah · 0.3.7 Dari mana lingkungan berasal

**Kesalahan umum (tambahan).** Menyamakan adaptasi software dengan backend OpenGL; menyimpulkan dari satu uji; salah ketik nama variabel yang diabaikan diam-diam; memaksa `QT_QPA_PLATFORM` secara global; mengekspor `LD_LIBRARY_PATH` atau `QT_PLUGIN_PATH` global; mengira variabel di terminal berlaku untuk aplikasi dari launcher.

**Latihan 15 menit (pengganti).** Jalankan satu `Main.qml` dengan tiga kombinasi platform atau backend memakai `timeout`, catat keluaran `QSG_INFO=1`, exit code, dan kesan visual masing-masing; buktikan plugin yang dipakai dengan `Qt.platform.pluginName`.

**Cek pemahaman (tambahan).** (3) Apa beda backend RHI dan adaptasi software? (4) Bagaimana membuktikan variabel apa yang diterima suatu proses?

**Referensi (tambahan).** [Qt Platform Abstraction](https://doc.qt.io/qt-6/qpa.html) · [Scene Graph Adaptations](https://doc.qt.io/qt-6/qtquick-visualcanvas-adaptations.html) · [QLoggingCategory](https://doc.qt.io/qt-6/qloggingcategory.html)

### 7.7.6 Status

| Bagian | Status |
| --- | --- |
| Modul 0.0 (0.0.1–0.0.9) | Selesai |
| Modul 0.1 (0.1.1–0.1.7) | Selesai |
| Modul 0.2 (0.2.1–0.2.8) | Selesai |
| Modul 0.3 (0.3.1–0.3.7) | **Selesai** |
| Fase 0 secara keseluruhan | **Selesai** (lihat bagian 8) |

---

## 8. Penutup Fase 0

**Daftar isi bagian ini:** 8.1 Ringkasan fase · 8.2 Kriteria lulus · 8.3 Ujian akhir Fase 0 · 8.4 Daftar pembaruan kurikulum terkonsolidasi · 8.5 Hal yang masih perlu Anda verifikasi · 8.6 Langkah berikutnya

### 8.1 Ringkasan fase

| Modul | Sub-bagian | Dari kurikulum | Tambahan | Hasil utama |
| --- | --- | --- | --- | --- |
| 0.0 Orientasi | 9 | 5 | 4 | Terminal, git, pipe, izin, membaca error, bantuan, kebiasaan aman |
| 0.1 Ekosistem | 7 | 5 | 2 | Peta Qt, modul, lisensi, rilis, dokumentasi, sumber dan perkakas |
| 0.2 Build pertama | 8 | 6 | 2 | Proyek CMake yang dapat dibangun, dikembangkan, dan diperiksa |
| 0.3 Runtime dan diagnosa | 7 | 5 | 2 | Diagnosa berbasis bukti dari proses sampai bingkai |
| **Jumlah** | **31** | **21** | **10** |  |

### 8.2 Kriteria lulus

Anda lulus Fase 0 bila dapat melakukan semuanya **tanpa melihat catatan** (acuan di Bagian 2.5, kini diperluas):

- Menjelaskan compiler, interpreter, dan di mana C++, JavaScript, dan QML berada (0.0.1).
- Menjelaskan event loop dan memprediksi kapan UI macet (0.0.2).
- Bernavigasi, menyambung perintah dengan pipe, membaca exit code, dan memeriksa izin (0.0.3–0.0.5).
- Membuat repositori git, commit bermakna, melihat diff, membatalkan perubahan (0.0.6).
- Membaca pesan error dari atas dan menemukan baris sumbernya (0.0.7).
- Membedakan Qt, QML, dan Qt Quick; membaca peta modul, lisensi, dan jadwal rilis (0.1.1–0.1.4).
- Membuat dan membangun proyek CMake Qt dari nol, menambah berkas QML, dan menjalankan lint (0.2.1–0.2.8).
- Menyebut tahap startup yang gagal dan membuktikannya dengan log, variabel, dan matriks eksperimen (0.3.1–0.3.7).
- Menjelaskan mengapa sebuah variabel lingkungan berlaku atau tidak berlaku bagi sebuah proses (0.0.3, 0.3.7).

### 8.3 Ujian akhir Fase 0

**Proyek `hello-diag`** (2–3 jam), dikerjakan di folder baru tanpa menyalin dari dokumen:

1. Buat repositori git baru dengan identitas, `.gitignore`, dan commit awal. *(0.0.6, 0.2.8)*
2. Buat proyek CMake dengan target `apphello` dan URI `Hello`, jendela yang menampilkan `Qt.platform.pluginName` dan satu `Panel.qml` yang terdaftar. *(0.2, 0.3.2)*
3. Bangun lewat `CMakePresets.json` (debug dan release) dan jalankan `all_qmllint` serta `qmlformat`. *(0.2.7)*
4. Buat `diag.sh` yang menjalankan lima kombinasi, mencatat exit code, dan menyimpan log. *(0.3.6)*
5. Sengaja rusakkan tiga hal (URI di `main.cpp`, nama berkas QML berawalan huruf kecil, plugin platform yang tidak ada) dan tulis, untuk tiap kerusakan: tahap, bukti, dan perbaikan. *(0.3.1, 0.2.4)*
6. Tulis `README.md` singkat: cara membangun, versi minimum Qt, lisensi modul yang dipakai, dan versi Qt yang diuji. *(0.1.3, 0.1.4)*
7. Commit dengan pesan bermakna; `git status` harus bersih dan `build/` tidak ikut ter-commit.

**Rubrik singkat:** bangun dari nol berhasil (30%); tiga kerusakan terdiagnosa dengan bukti (30%); repositori bersih dan terdokumentasi (20%); keamanan dan kebiasaan (tanpa `sudo` untuk build, tanpa variabel global berisiko) (20%).

### 8.4 Daftar pembaruan kurikulum terkonsolidasi

Ringkasan seluruh perubahan yang diusulkan pada README. Blok siap tempel ada di bagian yang disebut.

| Bagian README | Perubahan | Di dokumen ini |
| --- | --- | --- |
| Bagian 2 (estimasi) | Fase 0: Jalur B 1–2 minggu; **Jalur A 2–3 minggu** | 1 (audit butir 8) |
| Modul 0.0 | Deskripsi lima konsep inti ditambah empat pendukung; daftar isi 9 sub dengan urutan baru; kesalahan umum; latihan | 4.5 |
| Modul 0.1 | Deskripsi; terminologi LTS dan lisensi; daftar isi 7 sub; kesalahan umum; Cek pemahaman no. 2 | 5.7.5 |
| Modul 0.2 | Contoh minimal: target `apphello` dan URI `Hello`, tanpa `VERSION`, `find_package(Qt6 6.8 ...)`; daftar isi 8 sub; kesalahan umum | 6.7.5 |
| Modul 0.3 | Terminologi (backend RHI dan adaptasi software); contoh minimal; daftar isi 7 sub; latihan; cek pemahaman | 7.7.5 |
| Seluruh kurikulum | Ganti `./build/hello` menjadi `./build/apphello` | 6.1 butir 1 |
| Bagian 4 | Klaim hot reload dan `qmlpreview` di Qt 6.12 terverifikasi lewat blog resmi; `QT_QML_GENERATE_QMLLS_INI` dinyatakan deprecated sejak Qt 6.10 | 5.1, 0.2.7-d |
| Bagian E (validasi tautan) | Periksa tautan *Prototyping, Debugging, and Profiling* | 7.1 butir 8 |

**Catatan konsistensi di dokumen ini.** Beberapa contoh di 0.1.3-f dan 0.1.7-d, e ditulis sebelum penamaan target diperbaiki di Modul 0.2 dan memakai `./build/hello`. Bacalah sebagai `./build/apphello`.

### 8.5 Hal yang masih perlu Anda verifikasi

Saya tidak memiliki akses ke mesin dan GPU Anda, dan tautan belum diuji otomatis. Yang perlu Anda buktikan sendiri:

- **Keluaran khas mesin:** isi `build/` dan `build/Hello/qmldir` (0.2.1, 0.2.4); keluaran `QSG_INFO` dan `qt.scenegraph.general` (0.3.3); nilai `Qt.platform.pluginName` bawaan (0.3.2); tingkat dan kategori pesan `console.*` (0.3.5); pesan `qt.qml.binding.removal` (0.3.5).
- **Hasil percobaan bertanda \[uji dulu\] atau \[amati\]:** percobaan impor versi di 0.1.5-g; plugin xcb dan pustaka xcb-cursor di 0.3.2; berhasil atau tidaknya `QSG_RHI_BACKEND=vulkan` di mesin Anda.
- **Variabel bertanda ○ di 0.3.4:** `QML_DISABLE_DISK_CACHE`, `QT_FATAL_WARNINGS`, `QT_SCALE_FACTOR`, `QT_QPA_PLATFORMTHEME`, `QT_WAYLAND_DISABLE_WINDOWDECORATION`, `LIBGL_ALWAYS_SOFTWARE`: umum dipakai, tetapi tidak saya verifikasi di dokumentasi hari ini.
- **Nama executable dan paket:** `qml`, `qmlls`, `assistant`, `ccmake`, `clangd` (selalu cek dengan `command -v` dan `pacman -F`).
- **Tautan:** terutama halaman yang saya susun dari pola alamat Qt (mis. `qtqml-tooling-qmlformat.html`, `qtquick-visualcanvas-adaptations-software.html`). Bila ada yang mati, cari judulnya di doc.qt.io.

### 8.6 Langkah berikutnya

**Fase 1 — Bahasa QML** (estimasi di kurikulum: 2–3 minggu), terdiri dari empat modul:

| Modul | Judul |
| --- | --- |
| 1.1 | Sintaks Dasar dan Struktur Dokumen |
| 1.2 | Tipe Data dan Sistem Tipe |
| 1.3 | Properti, Alias, dan Atribut Objek |
| 1.4 | Komponen dan Reuse |

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../qml.md
[selanjutnya]: ../bagian-2/README.md

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
