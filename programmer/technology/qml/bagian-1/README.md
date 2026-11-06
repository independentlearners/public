# Materi Mendalam Mastery Qt 6 — Fase 0: Fondasi Lingkungan

*Dokumentasi belajar mandiri, disusun bertahap · 5 November 2026 · Acuan: Kurikulum Mastery Qt 6 — QML & Qt Quick (Edisi Revisi 4 November 2026) · Target Qt 6.12 LTS (minimal 6.8) · Arch Linux, terminal-centric*

## Cara membaca dokumen ini

Dokumen ini tumbuh bertahap: setiap giliran menambah satu bagian, dan bagian lama hanya diubah bila audit menemukan kesalahan.

| Bagian | Isi | Status |
| --- | --- | --- |
| 1. Audit Fase 0 | Pemeriksaan teknis sebelum materi dimulai | Selesai |
| 2. Fase 0 (tingkat fase) | Peran, filosofi, peta, hubungan antarfase | Selesai |
| 3. Modul 0.0 — Orientasi untuk Pemula | Sub-bagian 0.0.1 sampai 0.0.9 | Ditulis di dokumen ini |
| Modul 0.1, 0.2, 0.3 | Ekosistem, build, runtime | Menunggu konfirmasi Anda |

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
 | 0.0 ORIENTASI                      "cara bekerja"            |
 |   program | event loop | terminal | pipe | izin | git       |
 |   baca error | bantuan & editor | kebiasaan aman           |
 +----------------------------+-------------------------------+
                              v
 +------------------------------------------------------------+
 | 0.1 EKOSISTEM                      "apa yang saya pelajari"  |
 |   Qt vs QML vs Qt Quick | modul | lisensi | rilis            |
 +----------------------------+-------------------------------+
                              v
 +------------------------------------------------------------+
 | 0.2 BUILD PERTAMA                  "membuat sesuatu jalan"   |
 |   satu file -> CMake -> executable -> modul QML (URI)       |
 +----------------------------+-------------------------------+
                              v
 +------------------------------------------------------------+
 | 0.3 RUNTIME & DIAGNOSA             "bila tidak jalan, mengapa"|
 |   startup | platform plugin | RHI | variabel diagnostik     |
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

```markdown
**Deskripsi.** Mengajarkan lima konsep inti yang biasanya dianggap sudah dikenal (program, compiler dan interpreter, event loop, terminal, git) ditambah empat keterampilan pendukung (pipe dan redirect, izin dan sudo, bantuan dan editor modal, kebiasaan aman).

**Daftar isi.** 0.0.1 Program, compiler, interpreter · 0.0.2 Event loop dan mengapa UI bisa macet · 0.0.3 Terminal: path, proses, environment · 0.0.4 Pipe, redirect, dan penyaring teks · 0.0.5 Izin file, pengguna, dan sudo · 0.0.6 Git minimum: config, init, add, commit, diff, log, restore · 0.0.7 Membaca pesan error · 0.0.8 Mencari bantuan sendiri dan editor modal · 0.0.9 Kebiasaan aman: sumber paket dan skrip

**Kesalahan umum (tambahan).** Commit gagal karena identitas git belum diatur; `sudo` untuk build sehingga folder `build/` milik root; `2>&1` tertukar urutannya; menjalankan `curl | sh`.

**Latihan 15 menit.** Atur identitas git; buat folder `qt-learning`; `git init`; buat `.gitignore` berisi `build/`; buat `catatan.md`; commit; ubah satu baris; lihat `git diff`; commit lagi.

**Estimasi Fase 0.** Jalur B: 1–2 minggu. Jalur A: 2–3 minggu.
```

### 4.6 Status dan langkah berikutnya

| Bagian | Status |
| --- | --- |
| Audit Fase 0 | Selesai |
| Fase 0 (tingkat fase) | Selesai |
| Modul 0.0 (0.0.1–0.0.9) | **Selesai** |
| Modul 0.1 — Ekosistem Qt, QML, dan Qt Quick | Berikutnya, menunggu konfirmasi |
| Modul 0.2, 0.3 | Setelah 0.1 |

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
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



