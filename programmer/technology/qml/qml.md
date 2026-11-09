# Kurikulum Mastery Qt 6 — QML & Qt Quick (Edisi Revisi)

*Edisi revisi 4 November 2026 · Target Qt 6.12 LTS (minimal Qt 6.8) · Jalur terminal-centric di Arch Linux*

## Catatan revisi

Edisi ini menyatukan dua dokumen asli (JavaScript dalam QML dan Mastery Qt 6) menjadi satu kurikulum dan menerapkan seluruh temuan audit.

- **Akurasi:** `pragma ComponentBehavior` dibedakan dari `.pragma library`; `time` dihapus dari tipe dasar, sedangkan `font`, `matrix4x4`, dan `quaternion` ditambahkan; `qmlscene` ditandai deprecated; daftar style Controls diperbarui; delegate memakai `required property`; singleton dilengkapi sisi CMake; `main.cpp` lengkap; aturan `this` mengikuti dokumentasi; klaim yang belum terbukti (`async/await`, BigInt, object spread) ditandai **\[uji dulu\]**.
- **Kelengkapan:** tujuh modul baru: 0.0 Orientasi, 0.3 Runtime & Bootstrap, 6.4 Qt Quick Ekstra, 10.7 Threading, 11.5 Kompilasi QML, 14.6 Menambah Fitur pada Proyek Asing, 14.7 Peta Keputusan Modul Qt.
- **Template tetap** di setiap modul, kini dengan kesalahan umum, latihan, dan cek pemahaman.
- **Struktur:** Dokumen 1 menjadi Bagian B (jalur pendalaman JavaScript) dengan tabel pemetaan; C++ menjadi jalur paralel; estimasi waktu disinkronkan; tabel progres mencakup semua fase.
- **Format:** tautan bersih tanpa parameter pelacak dan dipin ke `/qt-6/`; tanpa gambar eksternal (diagram memakai teks).
- **Batas verifikasi:** klaim teknis yang diaudit dicocokkan dengan dokumentasi resmi Qt, tetapi contoh kode belum dikompilasi dan tautan belum diuji otomatis. Rinciannya dan skrip validasi ada di Bagian E.

## Cara memakai kurikulum ini

Dua jalur belajar memakai materi yang sama:

| Jalur | Untuk siapa | Rute |
| --- | --- | --- |
| A — Dasar | Tanpa latar belakang pemrograman | Modul 0.0 → Fase 0–7, dengan Bagian B Fase 0–9 dibaca paralel. Lanjut Fase 8–9 bila sudah nyaman. |
| B — Penuh | Sudah bisa memprogram | Fase 0–14 berurutan; C++ dipelajari di jalur paralel mulai Fase 4. |

**Template modul.** Setiap modul memuat: *Deskripsi*, *Konsep & analogi*, *Contoh minimal* (dengan cara menjalankan), *Terminologi*, *Daftar isi*, *Kesalahan umum*, *Latihan 15 menit*, *Cek pemahaman*, dan *Referensi*. Kerjakan latihan sebelum membaca referensi.

**Cara menjalankan contoh.** Simpan kode QML sebagai `Main.qml`, lalu jalankan `qml Main.qml` (nama executable di Arch dijelaskan di Bagian 4). CMake baru dipakai mulai Modul 0.2 untuk proyek multi-file.

**Penanda versi.** `[≥6.5]` berarti fitur tersedia sejak Qt 6.5; tanpa penanda berarti sejak Qt 6.0. **\[uji dulu\]** berarti dokumentasi resmi tidak menjaminnya; buktikan dengan satu file uji di `qml`.

## 1. Identitas teknologi dan ruang lingkup

Tiga istilah harus dibedakan:

- **Qt**: framework lintas platform untuk sistem objek, event, jaringan, file, multimedia, dan grafis.
- **QML**: bahasa deklaratif untuk mendeskripsikan objek, properti, hubungan antarnilai, dan hierarki komponen. Sintaksnya mirip JSON, tetapi bukan JSON dan bukan JavaScript biasa.
- **Qt Quick**: modul antarmuka grafis berbasis QML: item visual, input, animasi, model-view, layout, scene graph.

```
Aplikasi Anda
├── QML ............... deklaratif: apa yang ada dan bagaimana saling terhubung
│   └── JavaScript .... imperatif: langkah-langkah, hidup di dalam QML
├── Qt Quick .......... item visual, input, animasi, model-view
├── Qt Quick Controls . komponen siap pakai + style
├── Qt QML ............ engine: tipe, modul, binding, signal
└── Qt Core / C++ ..... QObject, meta-object, thread, jaringan, file
        └── Scene graph → RHI → OpenGL / Vulkan / Metal / Direct3D / Software
```

QML bukan pengganti C++, dan Qt Quick bukan sekadar kumpulan komponen visual: keduanya bekerja dalam satu arsitektur.

| Teknologi | Peran |
| --- | --- |
| C++ | Bahasa native Qt untuk backend dan tipe kustom |
| JavaScript | Logika imperatif di dalam QML |
| CMake | Konfigurasi dan build |
| Meta-Object System | Introspeksi, properti, signal, slot |
| Scene Graph + RHI | Representasi dan rendering grafis lintas backend |

Referensi: [Qt 6](https://doc.qt.io/qt-6/) · [Qt QML](https://doc.qt.io/qt-6/qtqml-index.html) · [Qt Quick](https://doc.qt.io/qt-6/qtquick-index.html)

## 2. Peta perjalanan

Estimasi mengasumsikan 15–25 jam per minggu. Angka di bawah adalah jumlah dari estimasi tiap fase, sehingga tabel tahap dan tabel fase selalu sinkron. Jalur A menambah sekitar 1,5–2 kali lipat waktu.

| Fase | Tingkat | Estimasi | Fokus |
| --- | --- | --- | --- |
| 0 Fondasi lingkungan | Foundation | 1–2 mgg | Orientasi, ekosistem, build, runtime |
| 1 Bahasa QML | Foundation | 2–3 mgg | Sintaks, tipe, properti, komponen |
| 2 JavaScript untuk QML | Foundation | 2–3 mgg | Ekspresi, fungsi, modul, batas eksekusi |
| 3 Model objek & reaktivitas | Intermediate | 2–3 mgg | Binding, signal, lifecycle, scope |
| 4 Dasar visual Qt Quick | Intermediate | 2–3 mgg | Item, geometri, resource, input |
| 5 Komponen, layout, styling | Intermediate | 2 mgg | Komponen, positioner, layout, tema |
| 6 Interaksi, state, animasi | Intermediate | 2–3 mgg | State, animasi, input lanjut, ekstra |
| 7 Model, view, arsitektur data | Advanced | 2–3 mgg | Model, delegate, objek dinamis, data async |
| 8 Modul QML & arsitektur | Advanced | 2–3 mgg | Modul, arsitektur, CMake |
| 9 Controls & UI lanjut | Advanced | 2–3 mgg | Controls, kustomisasi, navigasi, aksesibilitas |
| 10 Interoperabilitas C++/QML | Expert | 3–4 mgg | QObject, registrasi, model, API native, thread |
| 11 Rendering & performa | Expert | 3–4 mgg | Scene graph, RHI, shader, profiling, kompilasi |
| 12 Testing & kualitas | Expert | 2–3 mgg | Debug, analisis statis, uji, profiling |
| 13 Keamanan & deployment | Enterprise | 3–4 mgg | Keamanan, integrasi OS, paket, rekayasa |
| 14 Mastery | Mastery | 3–6 mgg | Tipe, QQuickItem, plugin, framework, proyek asing |

| Tahap | Fase | Estimasi |
| --- | --- | --- |
| Foundation | 0–2 | 5–8 mgg |
| Intermediate | 3–6 | 8–11 mgg |
| Advanced | 7–9 | 6–9 mgg |
| Expert | 10–12 | 8–11 mgg |
| Enterprise & Mastery | 13–14 | 6–10 mgg |
| **Total** | 0–14 | **33–49 mgg** |

**Jalur C++ paralel.** C++ tidak boleh dipaksa masuk dalam 3–4 minggu Fase 10. Mulai Fase 4, sisihkan 3–5 jam per minggu untuk C++ dasar (Modul 10.1). Bila C++ benar-benar baru, tambahkan 4–8 minggu pada total.

**Pemetaan Bagian B (pendalaman JavaScript).**

| Bagian B | Dibaca bersama |
| --- | --- |
| B0–B7 (sintaks, tipe, fungsi, array, objek) | Modul 2.1 |
| B8 (scope, closure) | Modul 3.4 |
| B9 (JavaScript dalam dokumen QML) | Modul 2.2 |
| B10 (global object, API) | Modul 2.4 |
| B11 (binding) | Modul 3.1 |
| B12 (signal) | Modul 3.2 |
| B13 (resource, modul `.js`) | Modul 2.3 |
| B14 (tipe data, konversi) | Modul 1.2 |
| B15 (asinkron) | Modul 7.4 |
| B16 (JavaScript ↔ C++) | Modul 10.4 |
| B17 (lifecycle, memori) | Modul 3.3 dan 7.3 |
| B18 (debug, optimasi) | Modul 12.1, 12.2, 11.4 |
| B19 (arsitektur logika) | Modul 8.2 dan 14.6 |

## 3. Prasyarat

| Kompetensi | Jalur A | Jalur B | Keterangan |
| --- | --- | --- | --- |
| Terminal Linux | Diajarkan di Modul 0.0 | Wajib | Navigasi, path, proses, environment |
| Dasar pemrograman | Diajarkan bertahap (Fase 1–2, Bagian B) | Wajib | Variabel, fungsi, kondisi, perulangan |
| Matematika dasar | Wajib | Wajib | Koordinat, persentase, geometri |
| JavaScript | Bertahap | Bertahap | Hanya bagian yang dipakai QML |
| OOP | Bertahap | Bertahap | Class, object, inheritance |
| C++ | Tidak perlu sampai Fase 10 | Jalur paralel mulai Fase 4 | QObject, memori, template, thread |
| CMake | Bertahap (Modul 0.2) | Bertahap | Dibutuhkan untuk proyek multi-file |
| Grafis | Tidak perlu | Opsional, perlu di Fase 11 | Shader, GPU |

Urutan bahasa yang disarankan: QML dulu, JavaScript sebagai pendamping, C++ saat batas QML terasa, GLSL saat masuk shader. Bash dan Lua boleh dipakai sebagai alat bantu, bukan prasyarat.

## 4. Lingkungan pengembangan (Arch Linux)

IDE grafis bukan syarat. Seluruh kurikulum bisa dikerjakan dari terminal dan editor modal.

```
sudo pacman -Syu
sudo pacman -S --needed qt6-base qt6-declarative qt6-tools qt6-shadertools cmake ninja gcc gdb git pkgconf
```

Paket opsional, pasang sesuai kebutuhan modul: `qt6-5compat`, `qt6-svg`, `qt6-imageformats`, `qt6-wayland`, `qt6-multimedia`.

**Nama executable berbeda antar distro dan versi.** Jangan menebak. Periksa:

```
qmake6 --version
cmake --version
pacman -Q | grep '^qt6-'
pacman -Ql qt6-declarative qt6-tools | grep '/bin/'
```

Bila `qml` tidak ditemukan, cari namanya dari daftar terakhir (misalnya `qml6`) dan pakai nama itu di seluruh kurikulum.

| Tool | Fungsi | Catatan |
| --- | --- | --- |
| `qml` | Menjalankan dokumen QML tanpa proyek C++ | Jalur eksperimen utama. Pengganti `qmlscene`. |
| `qmlscene` | Peninjau QML warisan | **Deprecated di Qt 6**: mencetak peringatan agar memakai `qml`. Jangan dipakai. |
| `qmllint` | Analisis statis | Wajib; dijalankan sebelum commit |
| `qmlformat` | Pemformat kode | `qmlformat -i Main.qml` |
| `qmlls` | Language server | Hubungkan ke editor Anda; baca dokumentasi qmlls untuk informasi build yang dibutuhkan |
| `qmlcachegen` | Kompiler cache/bytecode | Dipanggil otomatis oleh CMake |
| `qmltc` | Kompiler tipe QML ke C++ | Lanjutan (Modul 11.5) |
| `qmltestrunner` | Menjalankan Qt Quick Test | Modul 12.3 |
| `qmlpreview` | Pratinjau langsung (hot reload) dari CLI | Qt 6.12 menjadikan hot reload fitur bawaan engine |
| `qmlprofiler` | Profiler QML | Dapat dipakai dari CLI atau Qt Creator |
| `cmake`, `ninja` | Konfigurasi dan eksekusi build |  |
| `gdb` | Debugging native |  |

**Variabel lingkungan yang wajib dikenal.**

| Variabel | Fungsi |
| --- | --- |
| `QT_QPA_PLATFORM` | Memilih platform plugin: `wayland`, `xcb`, `offscreen` |
| `QT_QUICK_BACKEND=software` | Memaksa renderer software (untuk diagnosa GPU/driver) |
| `QSG_RHI_BACKEND` | Memilih backend RHI: `opengl`, `vulkan`, dan lainnya |
| `QSG_INFO=1` | Mencetak informasi scene graph dan renderer |
| `QSG_VISUALIZE` | Visualisasi batching, clipping, overdraw (`batches`, `clip`, `changes`, `overdraw`) |
| `QSG_RENDER_LOOP` | Memilih render loop: `basic` atau `threaded` |
| `QML_IMPORT_TRACE=1` | Melacak pencarian import |
| `QML_IMPORT_PATH` | Menambah jalur pencarian modul QML |
| `QT_LOGGING_RULES` | Mengaktifkan kategori log, mis. `qt.qml.binding.removal.info=true` |
| `QT_QUICK_CONTROLS_STYLE` | Memilih style Controls |
| `QML_XHR_ALLOW_FILE_READ=1` | Mengizinkan XMLHttpRequest membaca file lokal (default mati) |
| `QML_DISABLE_DISK_CACHE=1` | Mematikan cache disk QML saat mendiagnosa |
| `QT_DEBUG_PLUGINS=1` | Melacak pemuatan plugin |

**Alur kerja.** Mulai dari satu file, naik ke proyek hanya saat perlu.

```
# Tahap 1: eksperimen satu file
qml Main.qml
qmllint Main.qml
qmlformat -i Main.qml

# Tahap 2: proyek CMake (Modul 0.2)
mkdir -p ~/Development/qt-learning && cd ~/Development/qt-learning
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
./build/hello
```

`qt_add_qml_module` otomatis membuat target `<nama>_qmllint` dan `all_qmllint`, sehingga analisis statis ikut dalam build.

## Glosarium

| Istilah | Arti singkat |
| --- | --- |
| Binding | Hubungan yang membuat sebuah properti selalu mengikuti hasil ekspresi |
| Property | Atribut objek yang menyimpan keadaan |
| Alias | Properti yang meneruskan akses ke properti lain |
| Signal | Pemberitahuan bahwa sesuatu terjadi |
| Slot | Fungsi penerima signal di sisi C++ |
| Handler | Kode yang berjalan saat signal dipancarkan (`onClicked`) |
| Item | Objek visual dasar di Qt Quick |
| Component | Definisi objek yang bisa dibuat berulang kali |
| Instance | Satu objek hasil pembuatan dari sebuah component |
| Model | Penyedia data untuk view |
| View | Penampil data berbentuk daftar atau grid |
| Delegate | Template visual untuk satu entri data |
| Role | Nama atribut data dalam model |
| Scope | Wilayah tempat sebuah nama dikenali |
| Context | Lingkungan nama yang dibawa sebuah komponen saat dibuat |
| ID | Nama objek yang berlaku di dalam satu dokumen QML |
| Attached property | Properti yang ditempelkan pada objek lain (`Layout.fillWidth`) |
| Singleton | Objek yang hanya dibuat satu kali per engine |
| QObject | Kelas dasar Qt yang mendukung signal, properti, dan hierarki objek |
| Meta-object | Metadata kelas yang dibuat saat build untuk introspeksi |
| MOC | Meta-Object Compiler, pembuat meta-object |
| Event loop | Putaran yang menunggu dan memproses kejadian |
| Scene graph | Pohon node grafis yang dirender GPU |
| RHI | Rendering Hardware Interface, lapisan abstraksi API grafis Qt |
| Shader | Program kecil yang berjalan di GPU |
| `qsb` | Format dan alat shader terkompilasi Qt |
| Compiler | Penerjemah kode sumber menjadi kode mesin |
| Linker | Penghubung hasil kompilasi dengan library |
| Build system | Pengatur proses pembuatan aplikasi (CMake) |
| Target | Hasil build: executable atau library |
| URI | Nama unik modul QML (`MyCompany.Controls`) |
| Import path | Lokasi pencarian modul QML |
| Plugin | Library yang dimuat saat runtime untuk menambah kemampuan |
| Thread affinity | Thread tempat sebuah QObject hidup |
| Garbage collector | Pembersih memori otomatis untuk objek JavaScript |
| LSP | Language Server Protocol: layanan analisis kode untuk editor |
| Linter | Alat analisis statis yang mencari pola buruk |
| Hot reload | Perubahan kode tampil di aplikasi yang sedang berjalan |

## [Fase 0 — Fondasi Lingkungan][0]

*Tujuan: memahami ekosistem, membangun dan menjalankan aplikasi pertama, dan mampu mendiagnosa lingkungan. Estimasi: 1–2 minggu.*

### Modul 0.0 — Orientasi untuk Pemula (Jalur A)

**Deskripsi.** Mengajarkan empat konsep yang biasanya dianggap sudah dikenal: apa itu program, apa itu compiler dan runtime, apa itu event loop, dan cara bekerja di terminal (path, proses, environment, git).

**Konsep & analogi.** Program adalah resep: urutan instruksi yang bisa dijalankan komputer. Compiler menerjemahkan seluruh resep ke bahasa mesin sebelum memasak; interpreter membaca resep sambil memasak. Event loop adalah pelayan restoran yang terus berkeliling: pelanggan memanggil (klik, ketikan, timer), pelayan segera menanggapi, lalu kembali berkeliling. Aplikasi grafis hidup di dalam putaran itu. Bila pelayan terjebak lama di satu meja (kode yang berjalan lama), semua meja lain menunggu dan jendela tampak macet.

**Contoh minimal.**

```
pwd                 # di mana saya sekarang
ls -la              # isi folder
mkdir -p ~/Development/qt-learning && cd ~/Development/qt-learning
echo $PATH          # daftar folder tempat program dicari
git init && git status
```

Cara menjalankan: ketik baris demi baris di terminal dan amati keluaran tiap perintah.

**Terminologi.** Path (alamat file); proses (program yang sedang berjalan); environment variable (pengaturan bernama yang diwariskan ke proses); repository (folder yang riwayat perubahannya dilacak git); commit (satu titik simpan riwayat).

**Daftar isi.** 0.0.1 Program, compiler, interpreter · 0.0.2 Event loop dan mengapa UI bisa macet · 0.0.3 Terminal: path, proses, environment · 0.0.4 Git minimum: init, add, commit, diff, log · 0.0.5 Membaca pesan error

**Kesalahan umum.** Menyalin perintah berawalan `sudo` tanpa memahaminya; menganggap pesan error sebagai kegagalan pribadi, padahal ia petunjuk; bekerja tanpa git sehingga tidak bisa kembali.

**Latihan 15 menit.** Buat folder `qt-learning`, inisialisasi git, buat `catatan.md`, commit, ubah satu baris, lihat `git diff`, lalu commit lagi.

**Cek pemahaman.** (1) Mengapa jendela aplikasi bisa tampak macet ketika satu fungsi berjalan lama? (2) Apa beda compiler dan interpreter?

**Referensi.** [Pro Git](https://git-scm.com/book/en/v2) · [Arch Wiki: Command-line shell](https://wiki.archlinux.org/title/Command-line_shell)

### Modul 0.1 — Ekosistem Qt, QML, dan Qt Quick

**Deskripsi.** Memetakan hubungan Qt, QML, JavaScript, Qt Quick, Qt Quick Controls, dan C++ (diagram di Bagian 1), serta mengenali lisensi dan siklus rilis.

**Konsep & analogi.** Qt adalah dapur lengkap; QML adalah menu yang menyatakan hidangan apa yang diinginkan; C++ adalah koki yang menguasai teknik sulit; JavaScript adalah catatan kecil pelayan untuk kasus khusus. Sebagian besar waktu Anda menulis menu (QML) dan memanggil koki (C++) hanya saat perlu.

**Contoh minimal.** Simpan sebagai `Main.qml`, jalankan `qml Main.qml`:

```qml
import QtQuick

Rectangle {
    width: 300
    height: width / 2     // selalu setengah lebar; engine menjaganya otomatis
    color: 'steelblue'
}
```

Gaya imperatif (konsep): hitung tinggi sekali, lalu ubah manual setiap kali lebar berubah. Gaya deklaratif memindahkan tugas pelacakan itu ke engine.

**Terminologi.** Deklaratif (menyatakan hubungan); imperatif (menyatakan langkah); runtime; LTS (Long Term Support, versi yang dipelihara lebih lama, mis. 6.8 dan 6.12); lisensi (Qt tersedia secara open source dan komersial; beberapa add-on, seperti `qmlsc`, hanya komersial).

**Daftar isi.** 0.1.1 Qt vs QML vs Qt Quick · 0.1.2 Modul inti dan add-on · 0.1.3 Lisensi dan edisi · 0.1.4 Siklus rilis dan LTS · 0.1.5 Membaca dokumentasi Qt 6 (hindari halaman Qt 5)

**Kesalahan umum.** Mencampur dokumentasi Qt 5 dan Qt 6 (Qt 5 memakai `import QtQuick 2.15`; Qt 6 cukup `import QtQuick`); mengira QML sama dengan JavaScript; mengabaikan syarat lisensi saat mendistribusikan aplikasi.

**Latihan 15 menit.** Ubah tinggi menjadi dua pertiga lebar, lalu jelaskan dengan kata sendiri mengapa Anda tidak perlu menghitung ulang di mana pun.

**Cek pemahaman.** (1) Mana yang deklaratif: `height: width / 2` atau `tinggi = lebar / 2` di dalam fungsi yang dipanggil manual? (2) Mengapa import Qt 6 tidak lagi memakai nomor versi?

**Referensi.** [Qt QML](https://doc.qt.io/qt-6/qtqml-index.html) · [Qt Quick](https://doc.qt.io/qt-6/qtquick-index.html) · [Lisensi Qt](https://www.qt.io/licensing/) · [Blog Qt](https://www.qt.io/blog)

### Modul 0.2 — Build Pertama: Dari Satu File ke Proyek CMake

**Deskripsi.** Membangun aplikasi Qt Quick minimal dengan CMake, dari struktur file sampai eksekusi, dan memahami peran setiap bagian.

**Konsep & analogi.** CMake adalah perencana: ia menulis daftar tugas, bukan memasak. Ninja memasak sesuai daftar itu. `qt_add_qml_module` mengemas file QML menjadi modul bernama (URI) yang dapat dimuat engine.

**Contoh minimal.** Struktur:

```
hello/
├── CMakeLists.txt
├── main.cpp
└── Main.qml
```

`CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.21)
project(HelloQt LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(hello main.cpp)

qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(hello PRIVATE Qt6::Quick)
```

`main.cpp`:

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

`Main.qml`:

```qml
import QtQuick

Window {
    visible: true
    width: 640
    height: 360
    title: qsTr('Hello Qt 6')

    Text { anchors.centerIn: parent; text: 'Hello Qt 6' }
}
```

Cara menjalankan (nama executable mengikuti target `hello`):

```
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
./build/hello
```

Sebelum CMake, Anda tetap dapat menguji `Main.qml` langsung dengan `qml Main.qml`.

**Terminologi.** `qt_add_executable` (membuat target executable); `qt_add_qml_module` (membuat modul QML dan meregistrasikan file); URI (nama unik modul; di sini `Hello`); `loadFromModule` (memuat tipe `Main` dari modul `Hello`); tahap configure vs build; build directory (folder terpisah dari source).

**Daftar isi.** 0.2.1 Struktur proyek · 0.2.2 `CMakeLists.txt` baris demi baris · 0.2.3 `main.cpp` dan engine · 0.2.4 Modul QML dan URI · 0.2.5 Configure, build, run · 0.2.6 Mendaftarkan file baru (QML\_FILES, SOURCES, RESOURCES)

**Kesalahan umum.** Nama executable tidak sama dengan nama target (`hello`, bukan `myapp`); URI di CMake berbeda dengan URI di `loadFromModule`; lupa memasukkan file QML baru ke `QML_FILES`; membangun di dalam folder source.

**Latihan 15 menit.** Tambahkan `Panel.qml` (satu `Rectangle`), daftarkan di `QML_FILES`, pakai di `Main.qml`, lalu `cmake --build build` dan jalankan.

**Cek pemahaman.** (1) Di mana tipe `Main` didefinisikan dan bagaimana C++ menemukannya? (2) Apa yang terjadi bila `Panel.qml` tidak didaftarkan?

**Referensi.** [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [qt\_standard\_project\_setup](https://doc.qt.io/qt-6/qt-standard-project-setup.html) · [Tutorial CMake](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)

### Modul 0.3 — Runtime, Bootstrap, dan Diagnosa Lingkungan *(baru)*

**Deskripsi.** Memahami apa yang terjadi dari `main()` sampai jendela tampil, memilih platform dan renderer, dan mendiagnosa masalah dengan variabel lingkungan.

**Konsep & analogi.** Membuka toko: (1) `QGuiApplication` menyiapkan toko (event loop, platform); (2) `QQmlApplicationEngine` menyewa penerjemah QML; (3) `loadFromModule` memuat menu; (4) scene graph menggambar etalase lewat RHI yang memilih jalur (OpenGL, Vulkan, software). Bila etalase kosong, periksa tiap tahap berurutan.

**Contoh minimal.**

```
QT_QPA_PLATFORM=wayland qml Main.qml
QT_QPA_PLATFORM=xcb qml Main.qml
QT_QUICK_BACKEND=software qml Main.qml
QSG_INFO=1 qml Main.qml
QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | head -50
```

| Gejala | Dugaan awal | Uji |
| --- | --- | --- |
| Jendela tidak muncul / crash | Platform plugin atau driver GPU | Ganti `QT_QPA_PLATFORM`, coba `QT_QUICK_BACKEND=software` |
| `module is not installed` | Import path salah | `QML_IMPORT_TRACE=1`, periksa `QML_IMPORT_PATH` |
| Tampilan rusak hanya di satu mesin | Backend RHI | Bandingkan `QSG_INFO=1` dan `QSG_RHI_BACKEND` |
| Plugin tidak termuat | Jalur plugin atau dependensi | `QT_DEBUG_PLUGINS=1` |

**Terminologi.** Platform plugin (QPA, lapisan antara Qt dan sistem jendela); RHI (abstraksi API grafis); backend (OpenGL, Vulkan, software, dst.); render loop (`basic` atau `threaded`); import trace (log pencarian modul).

**Daftar isi.** 0.3.1 Urutan startup aplikasi Qt Quick · 0.3.2 Platform plugin: Wayland vs X11 · 0.3.3 Renderer dan backend RHI, termasuk software · 0.3.4 Variabel lingkungan diagnostik · 0.3.5 Membaca log dan kategori logging

**Kesalahan umum.** Menganggap aplikasi rusak padahal masalahnya driver atau platform plugin; mengatur variabel lingkungan di shell lain dari tempat aplikasi dijalankan; mengubah banyak variabel sekaligus sehingga penyebab tidak terisolasi.

**Latihan 15 menit.** Jalankan satu `Main.qml` dengan tiga kombinasi platform atau backend dan catat keluaran `QSG_INFO=1` untuk masing-masing.

**Cek pemahaman.** (1) Bagaimana membuktikan bahwa masalah tampilan berasal dari GPU, bukan dari QML? (2) Apa fungsi `QML_IMPORT_TRACE`?

**Referensi.** [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html) · [Prototyping, Debugging, and Profiling](https://doc.qt.io/qt-6/qtqml-prototyping-debugging-profiling.html) · [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt)

## [Fase 1 — Bahasa QML][1]

*Tujuan: membaca dan menulis dokumen QML dengan benar. Estimasi: 2–3 minggu.*

### Modul 1.1 — Sintaks Dasar dan Struktur Dokumen

**Deskripsi.** Struktur file `.qml`: import, object tree, properti, `id`, komentar, dan konvensi nama file.

**Konsep & analogi.** Satu file `.qml` mendefinisikan satu tipe. Nama file berawalan huruf besar menjadi nama tipe, dan file hanya punya satu root object. Anggap file QML sebagai denah satu ruangan: root adalah ruangannya, anak-anaknya adalah isinya. Di QML Anda mendeskripsikan keadaan, bukan memerintahkan langkah.

**Contoh minimal.**

```qml
import QtQuick

Rectangle {                // root object
    id: root
    width: 300; height: 200
    color: '#1e1e2e'

    Text {                 // child object
        anchors.centerIn: parent
        text: 'Halo QML'
        color: 'white'
    }
}
```

**Terminologi.** Object (instance sebuah tipe); property (atribut bernilai); id (nama objek di dalam satu dokumen); root object (objek paling luar); child (objek di dalam); import (memuat modul); pragma (arahan dokumen, ditulis sebelum import).

**Daftar isi.** 1.1.1 Struktur dokumen (pragma, import, root) · 1.1.2 Objek dan hierarki · 1.1.3 Properti dasar · 1.1.4 `id` dan referensi · 1.1.5 Komentar dan `qmlformat` · 1.1.6 Konvensi nama file

**Kesalahan umum.** Dua root object dalam satu file; nama file berawalan huruf kecil yang diharapkan menjadi tipe; lupa `import QtQuick`.

**Latihan 15 menit.** Ubah warna dan teks, jalankan dengan `qml`, rapikan dengan `qmlformat -i`, lalu jalankan `qmllint`.

**Cek pemahaman.** (1) Apa yang terjadi bila file bernama `button.qml`? (2) Mengapa satu file hanya boleh punya satu root?

**Referensi.** [QML Syntax Basics](https://doc.qt.io/qt-6/qtqml-syntax-basics.html) · [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html)

### Modul 1.2 — Tipe Data dan Sistem Tipe

**Deskripsi.** Tipe dasar QML dan cara memilih tipe yang tepat untuk sebuah properti.

**Konsep & analogi.** Tipe adalah label pada kotak: ia menentukan isi yang boleh masuk dan bagaimana isi diubah bentuk. `var` adalah kotak tanpa label; fleksibel, tetapi engine dan linter tidak bisa membantu Anda.

| Tipe | Isi | Catatan |
| --- | --- | --- |
| `bool`, `int`, `real` / `double`, `string` | Nilai primitif | `real` dan `double` setara |
| `url` | Alamat file atau jaringan | Relatif terhadap dokumen |
| `color` | Warna | `'red'`, `'#rrggbb'`, `Qt.rgba(...)` |
| `date` | Tanggal dan waktu | Berbasis `Date` JavaScript. **Tidak ada tipe `time` terpisah**; QTime menjadi `Date` |
| `font` | Kelompok properti font | `font.pixelSize` |
| `point`, `size`, `rect` | Geometri | `Qt.point`, `Qt.size`, `Qt.rect` |
| `vector2d`, `vector3d`, `vector4d`, `matrix4x4`, `quaternion` | Matematika 2D/3D | Banyak dipakai di Qt Quick 3D dan shader |
| `list<T>`, `var`, enum | Koleksi, nilai bebas, pencacahan | Utamakan tipe terketik |

**Contoh minimal.**

```qml
import QtQuick

Item {
    property int jumlah: 3
    property real harga: 12.5
    property string nama: 'Kopi'
    property bool aktif: true
    property color warna: '#2a9d8f'
    property point posisi: Qt.point(10, 20)
    property rect area: Qt.rect(0, 0, 100, 50)
    property var bebas: ({ kunci: 'nilai' })
    property list<Item> daftar

    Component.onCompleted: console.log(jumlah * harga, nama, warna, posisi.x)
}
```

**Terminologi.** Basic type (tipe bawaan nilai); value type; object type; `var` (tipe longgar); enumeration; konversi implisit (engine mengubah tipe otomatis).

**Daftar isi.** 1.2.1 Primitif · 1.2.2 Geometri dan warna · 1.2.3 `date` dan konversi QDate/QTime · 1.2.4 `list` dan `var` · 1.2.5 Enum · 1.2.6 Konversi dan jebakan

**Jebakan konversi.** Bulan JavaScript bernomor 0–11, sedangkan Qt 1–12. Konversi QDate dan Date bergantung pada UTC. Array-like hasil konversi dari C++ tidak lolos `Array.isArray()`. Perbandingan `real` memakai `===` rawan galat pecahan (`0.1 + 0.2`).

**Kesalahan umum.** Memakai `var` untuk semuanya; mencari tipe `time`; mengabaikan jebakan konversi di atas.

**Latihan 15 menit.** Tulis delapan properti dengan tipe berbeda, cetak nilai dan `typeof` masing-masing.

**Cek pemahaman.** (1) Apa pengganti tipe `time`? (2) Mengapa properti terketik lebih baik daripada `var`?

**Referensi.** [QML Basic Types](https://doc.qt.io/qt-6/qtqml-typesystem-basictypes.html) · [Data Type Conversion QML↔C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html)

### Modul 1.3 — Properti, Alias, dan Atribut Objek

**Deskripsi.** Deklarasi properti, `readonly`, `required`, `default`, alias, group properties, dan attached properties.

**Konsep & analogi.** Properti adalah kotak bernama yang mengumumkan setiap perubahan isinya. Alias adalah pintu pintas ke kotak lain; ia tidak menyimpan nilai sendiri.

**Contoh minimal.** `Panel.qml`:

```qml
import QtQuick

Rectangle {
    id: root
    required property string judul          // wajib diisi pemakai
    readonly property int minimum: 10       // tidak bisa diubah setelah inisialisasi
    property alias warnaLatar: root.color   // pintu pintas ke properti sendiri
    default property alias isi: kolom.data  // anak langsung masuk ke kolom

    width: 240; height: 120
    Column {
        id: kolom
        anchors.fill: parent
        Text { text: root.judul }
    }
}
```

Pemakaian: `Panel { judul: 'Satu'; Text { text: 'anak' } }`.

QML tidak punya modifier `private`. Pola umum: simpan keadaan internal dalam anak `QtObject` ber-id `d`, mis. `QtObject { id: d; property int hitung: 0 }`.

**Terminologi.** `required property` (harus diberi nilai pemakai); `readonly`; alias; default property; group property (`font.pixelSize`); attached property (`Layout.fillWidth`); change signal (`onJudulChanged`).

**Daftar isi.** 1.3.1 Deklarasi dan tipe · 1.3.2 `readonly` dan `required` · 1.3.3 Alias dan default property · 1.3.4 Group properties · 1.3.5 Attached properties · 1.3.6 Handler perubahan `onXChanged` · 1.3.7 Pola private lewat `QtObject`

**Kesalahan umum.** Mengira `readonly` bisa diubah dari luar; alias ke properti yang tidak ada; menimpa binding dengan assignment (dibahas di Modul 3.1).

**Latihan 15 menit.** Buat `Panel.qml` seperti di atas dan pakai dua kali dengan judul berbeda, satu berisi anak `Text`.

**Cek pemahaman.** (1) Apa beda properti biasa dan alias? (2) Mengapa `required` lebih aman daripada nilai default kosong?

**Referensi.** [Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

### Modul 1.4 — Komponen dan Reuse

**Deskripsi.** File QML sebagai tipe, instansiasi berulang, dan inline component.

**Konsep & analogi.** Komponen adalah cetakan kue; instance adalah kuenya. Satu cetakan, banyak kue, dan mengubah cetakan mengubah semuanya.

**Contoh minimal.**

```qml
import QtQuick

Item {
    component Chip: Rectangle {
        property string label
        width: 80; height: 28; radius: 14
        color: 'lightsteelblue'
        Text { anchors.centerIn: parent; text: parent.label }
    }

    Row { spacing: 8; Chip { label: 'A' } Chip { label: 'B' } }
}
```

**Terminologi.** Komponen; instance; inline component (`component Nama: Tipe { }`); type name; tipe `Component` (dibahas di Modul 7.3).

**Daftar isi.** 1.4.1 File sebagai tipe · 1.4.2 Inline component · 1.4.3 Properti sebagai antarmuka komponen · 1.4.4 Kapan memecah komponen

**Kesalahan umum.** Menyalin-tempel blok yang sama alih-alih membuat tipe; komponen yang mengakses `id` di luar dokumennya (tidak bisa); antarmuka komponen terlalu bocor.

**Latihan 15 menit.** Ekstrak blok berulang dari Main.qml ke `Chip.qml` dan ke inline component; bandingkan keduanya.

**Cek pemahaman.** Kapan inline component lebih tepat dari file terpisah?

**Referensi.** [Defining Object Types through QML Documents](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html) · [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html)

## [Fase 2 — JavaScript untuk QML (Fondasi)][2]

*Tujuan: memakai JavaScript secukupnya dan benar di dalam QML. Estimasi: 2–3 minggu. Pendalaman lengkap ada di Bagian B.*

JavaScript di QML berjalan di lingkungan khusus, bukan peramban: tidak ada `document`, `window`, atau DOM. Runtime mengimplementasikan ECMAScript edisi ke-7 dengan beberapa tambahan. `??` tersedia sejak Qt 5.15, `?.` sejak 6.2, dan pemisah numerik sejak 6.8.

### Modul 2.1 — Dasar JavaScript yang Dipakai QML

**Deskripsi.** Bagian JavaScript yang benar-benar dipakai: `const`/`let`, tipe primitif, fungsi dan arrow function, array, objek, template literal, destructuring, `??`, `?.`, dan `try/catch`.

**Konsep & analogi.** JavaScript adalah catatan tangan di margin menu QML: dipakai secukupnya untuk logika yang tidak bisa dinyatakan sebagai hubungan.

**Contoh minimal.**

```qml
import QtQuick

Item {
    function format(item) {
        const { nama, harga = 0 } = item          // destructuring dengan nilai default
        return `${nama}: ${harga}`                // template literal
    }

    Component.onCompleted: {
        const data = [{ nama: 'Kopi', harga: 15000 }, { nama: 'Teh' }]
        console.log(data.map(format).join(' | '))
        console.log(data[1]?.alias ?? 'tanpa alias')  // ?. dan ??
    }
}
```

**Terminologi.** `const`/`let`/`var`; arrow function; destructuring; template literal; nullish coalescing (`??`); optional chaining (`?.`); temporal dead zone (akses `let`/`const` sebelum deklarasi).

**Daftar isi.** 2.1.1 Variabel dan scope · 2.1.2 Tipe dan konversi · 2.1.3 Fungsi dan arrow function · 2.1.4 Array: `map`, `filter`, `reduce`, `find` · 2.1.5 Objek dan destructuring · 2.1.6 String dan template literal · 2.1.7 `??` dan `?.` · 2.1.8 `try/catch` · 2.1.9 Fitur yang harus diuji dulu

**Fitur yang harus diuji dulu \[uji dulu\].** Object spread `{...obj}` adalah fitur ES2018, di luar edisi ke-7. BigInt tidak saya temukan di daftar objek resmi. `async/await` tidak didukung menurut sumber yang saya temukan (diskusi milis Qt untuk Qt 6.4.1 dan QTBUG-58620) dan belum ada konfirmasi untuk 6.12. `setTimeout` tidak bawaan di QML; pakai `Timer` atau `Qt.callLater`. Buktikan masing-masing dengan satu file uji di `qml` sebelum mengandalkannya. Sebaliknya, `Map`, `Set`, `WeakMap`, `WeakSet`, `Symbol`, dan `Promise` tercantum di daftar resmi.

**Kesalahan umum.** Memakai API peramban; `==` alih-alih `===`; mengira mengubah isi array otomatis memicu pembaruan binding (lihat Modul 3.1).

**Latihan 15 menit.** Tulis fungsi yang menyaring daftar produk berharga di atas 10000 lalu mencetak namanya.

**Cek pemahaman.** Apa beda `??` dan `||`? (`??` hanya untuk `null`/`undefined`; `||` juga untuk `0`, `''`, `false`.)

**Referensi.** [JavaScript Expressions in QML](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html) · [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [MDN JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)

### Modul 2.2 — JavaScript di dalam Dokumen QML

**Deskripsi.** Tiga tempat JavaScript hidup di QML: ekspresi binding, signal handler, dan fungsi pada objek, plus aturan `this` dan scope.

**Konsep & analogi.** Binding adalah rumus sel spreadsheet (dihitung ulang otomatis). Handler adalah tombol jalankan (sekali per kejadian). Fungsi adalah makro bernama.

**Contoh minimal.**

```qml
import QtQuick

Rectangle {
    id: root
    property int hitungan: 0
    width: 200; height: width / 2                       // ekspresi binding
    color: hitungan % 2 === 0 ? 'tomato' : 'seagreen'   // binding bersyarat

    function tambah(n = 1) { hitungan += n }            // fungsi pada objek

    MouseArea { anchors.fill: parent; onClicked: root.tambah() }  // signal handler
}
```

**Aturan `this`.** Menurut dokumentasi resmi, `this` bernilai `undefined` di sebagian besar konteks QML. Hanya di binding, signal handler, dan fungsi yang dideklarasikan di QML ia merujuk ke scope object. Akibatnya jangan bergantung pada `this`; rujuk objek lewat `id`.

**Terminologi.** Binding expression; signal handler; method; scope object; `this`; blok JavaScript.

**Daftar isi.** 2.2.1 Binding expression · 2.2.2 Signal handler dan blok · 2.2.3 Fungsi (parameter default, anotasi tipe) · 2.2.4 `this` dan scope · 2.2.5 Fungsi pembantu · 2.2.6 `Component.onCompleted`

**Kesalahan umum.** Assignment `hitungan = 5` di handler yang memutus binding (Modul 3.1); mengandalkan `this`; menaruh logika berat di binding yang dievaluasi berulang.

**Latihan 15 menit.** Tambahkan `Text` yang menampilkan `hitungan` lewat binding dan perhatikan ia ikut berubah saat diklik.

**Cek pemahaman.** Kapan sebuah binding dievaluasi ulang? (Saat salah satu properti yang dibacanya berubah.)

**Referensi.** [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html) · [JavaScript Expressions in QML](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html)

### Modul 2.3 — File JavaScript dan Pragma

**Deskripsi.** File `.js`, `.pragma library`, import JavaScript, dan pragma dokumen QML. Dua jenis pragma ini sering tertukar.

**Konsep & analogi.** `.pragma library` (dengan titik) menjadikan file `.js` perpustakaan bersama: satu salinan, tanpa akses ke scope pengimpor. Tanpa itu, setiap import mendapat salinan sendiri. `pragma ...` (tanpa titik) adalah arahan untuk dokumen `.qml`.

**Contoh minimal.** `MathUtils.js`:

```js
.pragma library

function clamp(nilai, min, max) {
    return Math.min(Math.max(nilai, min), max)
}
```

`Main.qml`:

```qml
import QtQuick
import 'MathUtils.js' as MathUtils

Item {
    Component.onCompleted: console.log(MathUtils.clamp(15, 0, 10))   // 10
}
```

Dalam proyek CMake, daftarkan `MathUtils.js` di `QML_FILES`.

| Pragma dokumen QML | Fungsi |
| --- | --- |
| `pragma Singleton` | Menjadikan tipe singleton (butuh pendaftaran di CMake, Modul 5.3) |
| `pragma ComponentBehavior: Bound` `[≥6.4]` | Komponen inline terikat ke konteks pembuatnya; delegate harus memakai `required property` |
| `pragma FunctionSignatureBehavior` `[≥6.5]` | Mengatur penanganan signature fungsi |
| `pragma ListPropertyAssignBehavior`, `NativeMethodBehavior`, `ValueTypeBehavior` | Mengatur perilaku assignment list, pemanggilan method native, dan value type |
| `pragma Translator` `[≥6.7]` | Menentukan objek penerjemah |

**Terminologi.** `.pragma library`; `pragma` dokumen; singleton; shared state (keadaan bersama).

**Daftar isi.** 2.3.1 File `.js` · 2.3.2 `.pragma library` · 2.3.3 `import ... as` · 2.3.4 `.import` di dalam `.js` · 2.3.5 Pragma dokumen QML · 2.3.6 JavaScript vs QML vs C++

**Kesalahan umum.** Menulis `.pragma ComponentBehavior` (yang benar: `pragma ComponentBehavior: Bound` di file `.qml`); `.pragma library` yang mencoba mengakses `id` QML; lupa mendaftarkan `.js` di CMake.

**Latihan 15 menit.** Buat `MathUtils.js`, panggil dari `Main.qml`, lalu jelaskan konsekuensi konsep bila `.pragma library` dihapus.

**Cek pemahaman.** Apa beda `.pragma library` dan `pragma Singleton`?

**Referensi.** [Defining JavaScript Resources](https://doc.qt.io/qt-6/qtqml-javascript-resources.html) · [Importing JavaScript Resources](https://doc.qt.io/qt-6/qtqml-javascript-imports.html) · [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html)

### Modul 2.4 — Lingkungan Host JavaScript dan Batasnya

**Deskripsi.** Apa yang tersedia (objek global QML, `Qt`, `console`, `XMLHttpRequest`, `JSON`, `Math`, `Date`, `Promise`, `Map`, `Set`), apa yang tidak (DOM, `window`, `document`), dan di mana data disimpan (`Settings`, `QtQuick.LocalStorage`).

**Konsep & analogi.** JavaScript di QML adalah tamu di rumah engine: boleh memakai perabot Qt, tetapi ini bukan peramban.

**Contoh minimal.**

```qml
import QtQuick

Item {
    Timer {
        interval: 1000; running: true
        onTriggered: console.log('satu detik berlalu')
    }

    Component.onCompleted: {
        // dugaan: undefined undefined function. Buktikan sendiri di versi Qt Anda.
        console.log(typeof document, typeof fetch, typeof XMLHttpRequest)
    }
}
```

| Kebutuhan | Pakai di QML |
| --- | --- |
| Menunda aksi | `Timer`, `Qt.callLater` |
| Permintaan HTTP | `XMLHttpRequest` |
| Penyimpanan kecil | `Settings` (modul `QtCore`, `[≥6.5]`; sebelumnya `Qt.labs.settings`) atau `QtQuick.LocalStorage` (antarmuka JavaScript ke SQLite) |
| Baca/tulis file | API Qt lewat C++ (XHR file lokal dimatikan secara default) |
| Data terstruktur | `JSON.parse`, `JSON.stringify` |

**Terminologi.** Host environment; global object; DOM; XMLHttpRequest (XHR); Promise; event loop.

**Daftar isi.** 2.4.1 Yang tersedia · 2.4.2 Yang tidak ada · 2.4.3 Objek `Qt` · 2.4.4 `console` · 2.4.5 XHR dan `QML_XHR_ALLOW_FILE_READ` · 2.4.6 Penyimpanan data · 2.4.7 `Timer` vs penunda lain

**Kesalahan umum.** Menulis kode gaya peramban; mencoba `localStorage` global; membaca file lokal lewat XHR tanpa mengaktifkan variabel lingkungannya (dan tanpa menimbang risikonya, lihat Modul 13.1).

**Latihan 15 menit.** Jalankan contoh; ubah agar aplikasi keluar setelah satu detik memakai `Qt.quit()`.

**Cek pemahaman.** Bagaimana menunda aksi satu detik di QML? Bagaimana menyimpan preferensi pengguna?

**Referensi.** [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [Qt (global object)](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Settings](https://doc.qt.io/qt-6/qml-qtcore-settings.html)

## [Fase 3 — Model Objek dan Reaktivitas][3]

*Tujuan: memahami bagaimana QML menjaga nilai tetap sinkron: binding, signal, lifecycle, dan scope. Estimasi: 2–3 minggu.*

### Modul 3.1 — Property Binding

**Deskripsi.** Cara kerja binding, pelacakan dependensi, perbedaan binding dan assignment, tipe `Binding`, `Qt.binding()`, dan binding loop.

**Konsep & analogi.** Binding adalah rumus sel spreadsheet: engine mencatat sel mana yang dibaca dan menghitung ulang otomatis. Assignment adalah menimpa rumus dengan angka mati: sel berhenti mengikuti.

**Contoh minimal.**

```qml
import QtQuick

Item {
    property int a: 2
    property int b: 3
    property int total: a + b                  // binding

    Component.onCompleted: {
        console.log(total)                     // 5
        a = 10; console.log(total)             // 13: binding ikut berubah
        total = 100                            // assignment: binding DIPUTUS
        a = 20; console.log(total)             // tetap 100
        total = Qt.binding(function() { return a + b })  // pulihkan binding
        console.log(total)                     // 23
    }
}
```

Untuk mengikat properti dari luar objeknya atau secara bersyarat, pakai elemen `Binding`:

```qml
Binding { target: label; property: 'text'; value: input.text; when: input.activeFocus }
```

Binding loop terjadi saat dua properti saling bergantung (`width: height` dan `height: width`); engine mencetak peringatan *Binding loop detected*. Selesaikan dengan memutus salah satu arah.

**Jebakan array dan objek.** `daftar.push(x)` mengubah isi tanpa memicu notifikasi. Isi ulang propertinya: `daftar = [...daftar, x]` agar binding yang bergantung padanya dievaluasi ulang.

**Terminologi.** Binding; dependensi; breaking a binding; binding loop; `Binding`; `Qt.binding`; change notification.

**Daftar isi.** 3.1.1 Cara engine melacak dependensi · 3.1.2 Binding vs assignment · 3.1.3 `Binding` dan `Qt.binding` · 3.1.4 Binding loop · 3.1.5 Array dan objek · 3.1.6 Biaya binding (logika berat, evaluasi berulang)

**Kesalahan umum.** Memakai assignment di handler lalu heran binding berhenti; menaruh fungsi mahal di binding; mengira `push` memicu pembaruan.

**Latihan 15 menit.** Jalankan contoh, lalu sebabkan binding loop dengan sengaja dan baca peringatannya.

**Cek pemahaman.** (1) Mengapa `total = 100` memutus binding? (2) Bagaimana memulihkannya?

**Referensi.** [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Binding](https://doc.qt.io/qt-6/qml-qtqml-binding.html)

### Modul 3.2 — Signal, Handler, dan Connections

**Deskripsi.** Mendeklarasikan signal, menanganinya, menyambungkan antarobjek, dan memakai `Connections`.

**Konsep & analogi.** Signal adalah bel pintu: pemilik tidak peduli siapa yang akan membuka. Handler adalah orang yang menanggapi bel. Satu bel bisa didengar banyak orang.

**Contoh minimal.**

```qml
import QtQuick

Item {
    id: root
    signal pesanTerkirim(string isi)

    onPesanTerkirim: (isi) => console.log('diterima:', isi)

    Connections {
        target: root
        function onPesanTerkirim(isi) { console.log('connections:', isi) }
    }

    Component.onCompleted: {
        pesanTerkirim.connect(function(isi) { console.log('connect():', isi) })
        pesanTerkirim('halo')
    }
}
```

Gunakan parameter eksplisit pada handler (`(isi) => ...` atau `function(isi)`). Injeksi parameter implisit sudah ditinggalkan di Qt 6, dan sintaks lama `onSinyal:` di dalam `Connections` juga usang; pakai `function onSinyal() { }`.

**Terminologi.** Signal; handler (`onNama`); `Connections`; `connect()` / `disconnect()`; change signal (`onXChanged`).

**Daftar isi.** 3.2.1 Deklarasi signal dan parameter · 3.2.2 Handler · 3.2.3 `Connections` modern · 3.2.4 `connect`/`disconnect` dan rantai signal · 3.2.5 Signal dari C++ (pratinjau Fase 10) · 3.2.6 Rekursi tak sengaja pada change handler

**Kesalahan umum.** Mengubah properti di dalam change handler-nya sendiri sehingga rekursi; `Connections` tanpa `target` yang valid; lupa `disconnect` pada koneksi manual.

**Latihan 15 menit.** Buat komponen dengan signal `selesai(int hasil)`, sambungkan ke dua handler berbeda, dan cetak urutan pemanggilannya.

**Cek pemahaman.** Mengapa `Connections` lebih rapi daripada `connect()` manual untuk target yang berubah-ubah?

**Referensi.** [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html) · [Connections](https://doc.qt.io/qt-6/qml-qtqml-connections.html)

### Modul 3.3 — Lifecycle Objek

**Deskripsi.** Urutan pembuatan dan penghancuran objek, `Component.onCompleted`, `Component.onDestruction`, `destroy()`, dan `Qt.callLater`.

**Konsep & analogi.** Objek seperti tamu pesta: datang (dibuat), menyiapkan diri (properti dan binding diinisialisasi), lalu dinyatakan siap (`onCompleted`), dan akhirnya pulang (`onDestruction`).

**Contoh minimal.**

```qml
import QtQuick

Item {
    Component.onCompleted: console.log('induk siap')
    Component.onDestruction: console.log('induk dihancurkan')

    Rectangle {
        Component.onCompleted: console.log('anak siap')
    }
}
```

Urutan `onCompleted` antarobjek tidak boleh diandalkan. Jika perlu menunda pekerjaan sampai pembuatan selesai, gunakan `Qt.callLater(fungsi)`, yang juga menggabungkan panggilan berulang menjadi satu.

**Terminologi.** Lifecycle; `Component.onCompleted`; `Component.onDestruction`; `destroy()`; `Qt.callLater`.

**Daftar isi.** 3.3.1 Fase pembuatan objek · 3.3.2 `onCompleted` dan sifat urutannya · 3.3.3 Penghancuran dan `destroy()` · 3.3.4 `Qt.callLater` · 3.3.5 `Loader` dan objek yang dibuat tertunda (dasar)

**Kesalahan umum.** Mengandalkan urutan `onCompleted` antarsibling; melakukan pekerjaan berat di `onCompleted` sehingga startup lambat; mengakses objek yang sudah dihancurkan.

**Latihan 15 menit.** Jalankan contoh, tambahkan dua anak lagi, dan amati bahwa Anda tidak boleh berasumsi urutan keluarannya.

**Cek pemahaman.** Kapan `Qt.callLater` lebih tepat daripada memanggil fungsi langsung?

**Referensi.** [Component](https://doc.qt.io/qt-6/qml-qtqml-component.html) · [Dynamic QML Object Creation](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html)

### Modul 3.4 — Scope, ID, dan Konteks

**Deskripsi.** Bagaimana sebuah nama di ekspresi QML dicari, apa itu `id`, dan mengapa akses berkualifikasi lebih aman.

**Konsep & analogi.** Mencari nama seperti mencari barang: pertama di saku sendiri (variabel lokal), lalu di meja kerja (properti objek), lalu di ruangan (id dan root komponen), baru di gudang (konteks global).

**Contoh minimal.**

```qml
import QtQuick

Item {
    id: root
    property int nilai: 1

    Rectangle {
        property int nilai: 2          // menutupi (shadow) properti root
        Text { text: root.nilai + ' vs ' + parent.nilai }   // 1 vs 2
    }
}
```

Akses tanpa kualifikasi (`nilai` saja) bergantung pada urutan pencarian, lebih lambat, dan diperingatkan oleh `qmllint`. Context property (`setContextProperty`) masih tersedia tetapi menyulitkan compiler dan alat analisis statis; hindari untuk kode baru.

**Terminologi.** Scope chain; shadowing; unqualified access (akses tanpa kualifikasi); `id`; context property.

**Daftar isi.** 3.4.1 Urutan pencarian nama · 3.4.2 `id` dan batasnya (satu dokumen) · 3.4.3 Shadowing · 3.4.4 Akses berkualifikasi · 3.4.5 Context property dan alternatifnya · 3.4.6 Closure di JavaScript (Bagian B8)

**Kesalahan umum.** Nama properti sama di anak dan induk; memakai `id` dari dokumen lain; mengandalkan context property global.

**Latihan 15 menit.** Ubah contoh agar `Text` menampilkan `nilai` dari tiga tingkat, dan lihat apa yang dikeluhkan `qmllint` bila kualifikasi dihilangkan.

**Cek pemahaman.** Mengapa `root.nilai` lebih baik daripada `nilai`?

**Referensi.** [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [Exposing C++ Attributes (context property)](https://doc.qt.io/qt-6/qtqml-cppintegration-contextproperties.html)

## [Fase 4 — Dasar Visual Qt Quick][4]
*Tujuan: membangun tampilan dasar dengan item, geometri, resource, dan input. Estimasi: 2–3 minggu. Mulai jalur C++ paralel di fase ini (Modul 10.1).*

### Modul 4.1 — Item dan Primitif Visual

**Deskripsi.** `Item` sebagai wadah tak terlihat dan primitif visual: `Rectangle`, `Text`, `Image`, serta hubungan `Window` dengan item.

**Konsep & analogi.** `Item` adalah papan kosong yang bisa diisi; `Rectangle` papan berwarna; `Text` papan bertulisan. Hierarki induk-anak menentukan posisi relatif, urutan gambar, dan visibilitas. `Window` bukan `Item`: ia jendela yang menampung item akar.

**Contoh minimal.**

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 240
    Item {
        anchors.fill: parent
        Rectangle { x: 20; y: 20; width: 120; height: 80; color: 'goldenrod'; radius: 8 }
        Text { x: 20; y: 120; text: 'Item, Rectangle, Text'; font.pixelSize: 18 }
    }
}
```

**Terminologi.** Item; hierarki visual; `visible` dan `opacity`; `clip`; `z`; item akar.

**Daftar isi.** 4.1.1 `Item` dan hierarki · 4.1.2 `Rectangle`, `Text`, `Image` · 4.1.3 `visible`, `opacity`, `enabled` · 4.1.4 `clip` dan biayanya · 4.1.5 `Window` dan item akar

**Kesalahan umum.** Mengira `visible: false` sama dengan `opacity: 0` untuk input (keduanya berbeda efeknya); menumpuk item tak terlihat yang tetap diproses; `clip: true` di mana-mana.

**Latihan 15 menit.** Susun tiga persegi bertumpuk dengan `z` berbeda dan ubah urutannya hanya lewat `z`.

**Cek pemahaman.** Apa bedanya `Item` dan `Rectangle`? Mengapa `Window` bukan `Item`?

**Referensi.** [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html) · [Text](https://doc.qt.io/qt-6/qml-qtquick-text.html)

### Modul 4.2 — Geometri, Anchors, dan Z-Order

**Deskripsi.** Menentukan posisi dan ukuran dengan `x`, `y`, `width`, `height`, `implicitWidth`, dan `anchors`.

**Konsep & analogi.** Koordinat adalah alamat mutlak; anchors adalah janji relatif (“selalu 16 piksel di kanan tetangga saya”). Janji relatif bertahan saat ukuran jendela berubah.

**Contoh minimal.**

```qml
import QtQuick

Rectangle {
    width: 320; height: 200; color: '#222'

    Rectangle {
        id: kotak
        width: 80; height: 80; color: 'tomato'
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
    }
    Rectangle {
        width: 80; height: 80; color: 'seagreen'
        anchors { left: kotak.right; verticalCenter: kotak.verticalCenter; leftMargin: 8 }
    }
}
```

**Terminologi.** Anchors; margin; `implicitWidth`/`implicitHeight` (ukuran yang diinginkan item sendiri); `anchors.fill`; `anchors.centerIn`.

**Daftar isi.** 4.2.1 Koordinat dan ukuran · 4.2.2 `implicitWidth`/`implicitHeight` · 4.2.3 Anchors dan margin · 4.2.4 Aturan anchors (hanya ke induk atau saudara) · 4.2.5 `z` dan urutan gambar

**Kesalahan umum.** Memadukan `anchors.left` dengan `x` pada item yang sama (`x` diabaikan); menjangkar ke item yang bukan induk atau saudara; membuat binding loop lewat anchors.

**Latihan 15 menit.** Susun tiga kotak sejajar yang tetap berjarak 8 piksel saat jendela diubah ukurannya.

**Cek pemahaman.** Item mana saja yang boleh menjadi target anchors?

**Referensi.** [Positioning with Anchors](https://doc.qt.io/qt-6/qtquick-positioning-anchors.html) · [Important Concepts In Qt Quick: Positioning](https://doc.qt.io/qt-6/qtquick-positioning-topic.html)

### Modul 4.3 — Resource: Gambar, Font, dan URL

**Deskripsi.** Memuat gambar dan font, memahami resolusi URL, dan memasukkan resource ke modul QML lewat CMake.

**Konsep & analogi.** URL relatif dihitung dari lokasi file QML yang menulisnya, seperti alamat relatif terhadap rumah, bukan terhadap kota. Di dalam modul, resource dikemas ke dalam binary dan dirujuk dengan path relatif dari file QML.

**Contoh minimal.**

```qml
Image {
    source: 'images/logo.png'
    asynchronous: true
    fillMode: Image.PreserveAspectFit
    sourceSize.width: 128
}
```

CMake: tambahkan `RESOURCES images/logo.png` pada `qt_add_qml_module`.

**Terminologi.** URL relatif; resource (file yang dikemas ke binary); `asynchronous`; `sourceSize` (ukuran decode); `FontLoader`; `Qt.resolvedUrl`.

**Daftar isi.** 4.3.1 `Image` dan `fillMode` · 4.3.2 Pemuatan asinkron dan cache · 4.3.3 `sourceSize` dan memori · 4.3.4 `FontLoader` dan `font` · 4.3.5 URL dan `Qt.resolvedUrl` · 4.3.6 `RESOURCES` di CMake

**Kesalahan umum.** Memakai path absolut ke file lokal; lupa mendaftarkan resource; memuat gambar besar tanpa `sourceSize` sehingga memori membengkak.

**Latihan 15 menit.** Tambahkan satu gambar sebagai resource modul, tampilkan dengan `sourceSize` kecil, dan bandingkan pemakaian memori dengan dan tanpa `sourceSize`.

**Cek pemahaman.** Mengapa `sourceSize` penting untuk gambar besar?

**Referensi.** [Image](https://doc.qt.io/qt-6/qml-qtquick-image.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html)

### Modul 4.4 — Input Dasar: Pointer, Tap, dan Keyboard

**Deskripsi.** Menangani klik, sentuhan, hover, dan tombol keyboard dengan `MouseArea`, input handlers, dan `Keys`.

**Konsep & analogi.** Input handler seperti pengintai yang ditempel pada item: ia hanya memperhatikan kejadian jenisnya sendiri dan tidak mengganggu pengintai lain. Fokus keyboard hanya dimiliki satu item pada satu waktu.

**Contoh minimal.**

```qml
import QtQuick

Window {
    visible: true; width: 320; height: 160

    Rectangle {
        anchors.centerIn: parent
        width: 120; height: 60
        color: tap.pressed ? 'darkorange' : 'orange'
        Text { anchors.centerIn: parent; text: 'Tekan' }
        TapHandler { id: tap; onTapped: console.log('tap') }
    }

    Item {
        focus: true
        Keys.onPressed: (event) => { if (event.key === Qt.Key_Q) Qt.quit() }
    }
}
```

**Terminologi.** `MouseArea`; input handler (`TapHandler`, `HoverHandler`, `DragHandler`); fokus; `Keys`; event.

**Daftar isi.** 4.4.1 `MouseArea` · 4.4.2 `TapHandler` dan `HoverHandler` · 4.4.3 Fokus dan `Keys` · 4.4.4 Propagasi dan penerimaan event · 4.4.5 Pointer vs sentuhan

**Kesalahan umum.** Item penerima key tidak punya `focus`; `MouseArea` menumpuk dan saling menelan event; menaruh logika berat di handler input.

**Latihan 15 menit.** Buat persegi yang berubah warna saat di-hover dan keluar dari aplikasi saat tombol `Q` ditekan.

**Cek pemahaman.** Mengapa tombol tidak merespons bila item tidak memegang fokus?

**Referensi.** [Important Concepts In Qt Quick: Input](https://doc.qt.io/qt-6/qtquick-input-topic.html) · [Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html)

## [Fase 5 — Komponen, Layout, dan Styling][5]

*Tujuan: merancang komponen dengan antarmuka bersih, menata tampilan responsif, dan memusatkan tema. Estimasi: 2 minggu.*

### Modul 5.1 — Komponen sebagai API

**Deskripsi.** Merancang komponen yang antarmukanya jelas: properti sebagai masukan, signal sebagai keluaran, internal tersembunyi.

**Konsep & analogi.** Komponen seperti stopkontak: pemakai hanya tahu bentuk lubangnya (properti dan signal), bukan kabel di dalam dinding. Komponen yang membaca `parent.apa-pun` terpaku pada satu tempat pemasangan.

**Contoh minimal.** `AppButton.qml`:

```qml
import QtQuick

Rectangle {
    id: root
    required property string label
    signal clicked()

    implicitWidth: teks.implicitWidth + 32
    implicitHeight: 40
    radius: 6
    color: tap.pressed ? '#1d4ed8' : '#2563eb'

    Text { id: teks; anchors.centerIn: parent; text: root.label; color: 'white' }
    TapHandler { id: tap; onTapped: root.clicked() }
}
```

Pemakaian: `AppButton { label: 'Simpan'; onClicked: console.log('disimpan') }`.

**Terminologi.** Antarmuka komponen; enkapsulasi; `required property`; signal keluaran; `implicitWidth`.

**Daftar isi.** 5.1.1 Prinsip: properti masuk, signal keluar · 5.1.2 `root` sebagai id konvensional · 5.1.3 Ukuran implisit · 5.1.4 Menghindari akses ke induk · 5.1.5 Konvensi penamaan dan gaya kode

**Kesalahan umum.** Komponen yang mengubah properti induknya langsung; terlalu banyak properti publik; tidak memberi `implicitWidth` sehingga layout tak tahu ukurannya.

**Latihan 15 menit.** Tambahkan properti `enabled` visual (warna abu saat nonaktif) tanpa mengubah cara pemakaian yang ada.

**Cek pemahaman.** Mengapa komponen tidak boleh membaca `parent.width`?

**Referensi.** [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [Defining Object Types](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html)

### Modul 5.2 — Positioner dan Layouts

**Deskripsi.** `Row`, `Column`, `Grid`, `Flow` (positioner) dan `RowLayout`, `ColumnLayout`, `GridLayout` (Layouts), serta kapan memakai masing-masing.

**Konsep & analogi.** Positioner adalah rak yang hanya menata barang apa adanya. Layout adalah pengatur ruangan yang juga mengubah ukuran barang agar muat. Aturan praktis: bila ukuran anak harus ikut menyesuaikan ruang, pakai Layout.

**Contoh minimal.**

```qml
import QtQuick
import QtQuick.Layouts

Window {
    visible: true; width: 400; height: 120

    RowLayout {
        anchors.fill: parent; anchors.margins: 12; spacing: 8
        Rectangle { color: 'tomato'; Layout.preferredWidth: 80; Layout.fillHeight: true }
        Rectangle { color: 'seagreen'; Layout.fillWidth: true; Layout.fillHeight: true }
    }
}
```

**Terminologi.** Positioner; Layout; attached property `Layout.*` (`fillWidth`, `fillHeight`, `preferredWidth`, `minimumWidth`, `alignment`); spacing.

**Daftar isi.** 5.2.1 `Row`/`Column`/`Grid`/`Flow` · 5.2.2 `RowLayout`/`ColumnLayout`/`GridLayout` · 5.2.3 Attached property `Layout` · 5.2.4 Positioner vs Layout · 5.2.5 Responsif terhadap ukuran jendela

**Kesalahan umum.** Memakai `anchors` pada anak langsung Layout (pakai `Layout.*`); mengharapkan `Row` mengubah ukuran anak; layout bersarang berlebihan.

**Latihan 15 menit.** Buat form dua kolom yang melebar mengikuti jendela dengan `GridLayout`.

**Cek pemahaman.** Kapan `Row` cukup dan kapan perlu `RowLayout`?

**Referensi.** [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html) · [Item Positioners](https://doc.qt.io/qt-6/qtquick-positioning-topic.html)

### Modul 5.3 — Tema dan Singleton

**Deskripsi.** Memusatkan warna, ukuran, dan spasi dalam satu singleton, termasuk pendaftarannya di CMake.

**Konsep & analogi.** Tema adalah satu buku panduan gaya yang dibaca semua komponen. Mengubah satu entri mengubah seluruh aplikasi, tanpa mencari angka yang tersebar.

**Contoh minimal.** `Theme.qml`:

```qml
pragma Singleton
import QtQuick

QtObject {
    readonly property color primary: '#2563eb'
    readonly property int spacing: 8
    readonly property int radius: 6
}
```

CMake (properti file harus diatur **sebelum** `qt_add_qml_module`):

```cmake
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES Main.qml AppButton.qml Theme.qml
)
```

Pemakaian: `color: Theme.primary`. Untuk tema gelap/terang, buat properti `dark` pada singleton dan turunkan warna lewat binding; ikuti skema warna sistem lewat `Qt.styleHints.colorScheme` `[≥6.5]`.

**Terminologi.** Singleton; `pragma Singleton`; `QT_QML_SINGLETON_TYPE`; design token (nilai gaya bernama); skema warna.

**Daftar isi.** 5.3.1 `pragma Singleton` · 5.3.2 Mendaftarkan singleton di CMake · 5.3.3 Design token (warna, spasi, radius, tipografi) · 5.3.4 Tema gelap/terang · 5.3.5 Singleton dari C++ (`QML_SINGLETON`, Modul 10.3)

**Kesalahan umum.** Lupa `QT_QML_SINGLETON_TYPE` sehingga singleton tidak terdaftar; mengatur properti file sesudah `qt_add_qml_module`; menaruh keadaan aplikasi (bukan gaya) di singleton tema.

**Latihan 15 menit.** Buat `Theme.qml`, ganti seluruh warna di `AppButton` dengan token, lalu ubah satu token dan lihat efeknya di seluruh aplikasi.

**Cek pemahaman.** Mengapa `Theme.qml` butuh dua hal: `pragma Singleton` dan properti file di CMake?

**Referensi.** [qt\_target\_qml\_sources](https://doc.qt.io/qt-6/qt-target-qml-sources.html) · [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html)

## [Fase 6 — Interaksi, State, dan Animasi][6]
*Tujuan: membuat antarmuka hidup dan bisa dikendalikan penuh lewat pointer maupun keyboard. Estimasi: 2–3 minggu.*

### Modul 6.1 — State dan Transition

**Deskripsi.** Mengelompokkan perubahan properti ke dalam `State` bernama dan menganimasikan perpindahannya dengan `Transition`.

**Konsep & analogi.** State adalah pengaturan panggung untuk satu adegan (lampu, posisi, warna). Transition adalah cara panggung berubah antaradegan. Anda mendeskripsikan adegan, engine mengurus perpindahannya.

**Contoh minimal.**

```qml
import QtQuick

Rectangle {
    id: kotak
    width: 120; height: 120; color: 'tomato'

    states: State {
        name: 'aktif'
        PropertyChanges { target: kotak; color: 'seagreen'; scale: 1.2 }
    }
    transitions: Transition {
        ColorAnimation { duration: 250 }
        NumberAnimation { property: 'scale'; duration: 250; easing.type: Easing.OutBack }
    }

    TapHandler { onTapped: kotak.state = (kotak.state === 'aktif' ? '' : 'aktif') }
}
```

`State` mengatur keadaan visual sebuah item. Ini berbeda dari kerangka mesin keadaan terbatas (`StateMachine`, `SignalTransition`) di modul `QtQml.StateMachine`, yang dipakai untuk alur logika aplikasi.

**Terminologi.** `State`; `PropertyChanges`; `Transition`; state default (string kosong); `when` (kondisi otomatis); finite state machine.

**Daftar isi.** 6.1.1 `states` dan `PropertyChanges` · 6.1.2 Berpindah state (`state`, `when`) · 6.1.3 `transitions` · 6.1.4 `StateChangeScript` dan `AnchorChanges` · 6.1.5 `State` vs `StateMachine`

**Kesalahan umum.** Mengubah properti di state yang juga dikendalikan binding lain; transition yang tidak cocok dengan perubahan sehingga tidak berjalan; memakai `State` untuk alur bisnis kompleks.

**Latihan 15 menit.** Tambahkan state kedua `'nonaktif'` dengan warna abu dan transisi yang berbeda.

**Cek pemahaman.** Kapan `StateMachine` lebih tepat daripada `State`?

**Referensi.** [Qt Quick States](https://doc.qt.io/qt-6/qtquick-statesanimations-states.html) · [Qt State Machine QML Types](https://doc.qt.io/qt-6/qtqml-statemachine-qmlmodule.html)

### Modul 6.2 — Animasi

**Deskripsi.** `Behavior`, `NumberAnimation` dan kerabatnya, animasi berurutan dan paralel, easing, serta animator yang berjalan di render thread.

**Konsep & analogi.** Animasi adalah interpolasi: Anda menyebut tujuan dan durasi, engine mengisi langkah di antaranya. `Behavior` adalah aturan tetap: setiap kali properti ini berubah, tempuh dengan animasi.

**Contoh minimal.**

```qml
import QtQuick

Rectangle {
    id: bola
    width: 40; height: 40; radius: 20; color: 'steelblue'

    Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }

    SequentialAnimation on y {
        loops: Animation.Infinite
        NumberAnimation { to: 100; duration: 600 }
        NumberAnimation { to: 0; duration: 600 }
    }

    TapHandler { onTapped: bola.x = bola.x === 0 ? 200 : 0 }
}
```

Untuk properti tertentu, animator (`XAnimator`, `YAnimator`, `OpacityAnimator`, `ScaleAnimator`, `RotationAnimator`) berjalan di render thread sehingga tetap mulus saat thread utama sibuk.

**Terminologi.** `Animation`; `Behavior`; easing; `SequentialAnimation`/`ParallelAnimation`; animator; `loops`.

**Daftar isi.** 6.2.1 `NumberAnimation`, `ColorAnimation`, `PropertyAnimation` · 6.2.2 `Behavior` · 6.2.3 Easing · 6.2.4 Animasi berurutan dan paralel · 6.2.5 Animator di render thread · 6.2.6 `SpringAnimation` · 6.2.7 Biaya animasi

**Kesalahan umum.** Menganimasikan `width`/`height` di dalam Layout (memicu penataan ulang tiap frame); `Behavior` bertabrakan dengan binding; animasi tak berhenti pada item tak terlihat.

**Latihan 15 menit.** Ganti `NumberAnimation` pada `y` dengan `YAnimator` dan bandingkan kehalusannya saat Anda membebani thread utama dengan loop berat.

**Cek pemahaman.** Mengapa animator lebih tahan beban dibanding animation biasa?

**Referensi.** [Animation and Transitions](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html) · [Animator](https://doc.qt.io/qt-6/qml-qtquick-animator.html)

### Modul 6.3 — Input Lanjut dan Kendali Keyboard

**Deskripsi.** `DragHandler`, `PinchHandler`, `WheelHandler`, `Flickable`, `FocusScope`, `KeyNavigation`, dan `Shortcut`.

**Konsep & analogi.** Fokus adalah sorotan lampu panggung: satu item memegangnya dan menerima tombol. `FocusScope` adalah panggung kecil dengan sorotannya sendiri, sehingga komponen bisa mengelola fokus internalnya tanpa merebut fokus dari luar.

**Contoh minimal.**

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 240

    Shortcut { sequence: 'Ctrl+Q'; onActivated: Qt.quit() }

    Rectangle {
        width: 80; height: 80; color: 'orchid'
        DragHandler { xAxis.minimum: 0; xAxis.maximum: 280 }
    }

    Row {
        y: 150; spacing: 8
        Rectangle {
            id: a; width: 60; height: 40; focus: true
            color: activeFocus ? 'gold' : 'gray'
            KeyNavigation.right: b
        }
        Rectangle {
            id: b; width: 60; height: 40
            color: activeFocus ? 'gold' : 'gray'
            KeyNavigation.left: a
        }
    }
}
```

**Terminologi.** Input handler; `activeFocus`; `FocusScope`; `KeyNavigation`; `Shortcut`; gestur.

**Daftar isi.** 6.3.1 `DragHandler`, `PinchHandler`, `WheelHandler` · 6.3.2 `Flickable` · 6.3.3 Fokus, `FocusScope`, `forceActiveFocus()` · 6.3.4 `KeyNavigation` dan `Keys` · 6.3.5 `Shortcut` dan pemetaan tombol · 6.3.6 Rancangan antarmuka yang bisa dioperasikan penuh dari keyboard

**Kesalahan umum.** Fokus hilang karena beberapa item mengklaimnya; `Shortcut` konflik antarkonteks; antarmuka hanya bisa dipakai dengan pointer.

**Latihan 15 menit.** Tambahkan item ketiga ke baris navigasi dan buat urutan Tab/panah yang lengkap tanpa menyentuh mouse.

**Cek pemahaman.** Apa fungsi `FocusScope` dalam komponen yang dipakai ulang?

**Referensi.** [Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [Shortcut](https://doc.qt.io/qt-6/qml-qtquick-shortcut.html)

### Modul 6.4 — Qt Quick Ekstra *(baru)*

**Deskripsi.** Modul tambahan yang sering dibutuhkan proyek nyata: `Shapes`, `MultiEffect`, `Particles`, `Dialogs`, `Settings`, `LocalStorage`, dan opsi menggambar 2D.

**Konsep & analogi.** Qt Quick inti memberi bahan dasar; modul ekstra adalah peralatan khusus di gudang. Kenali apa yang ada agar tidak menulis ulang dari nol.

**Contoh minimal.** Bentuk vektor dengan `Shapes`:

```qml
import QtQuick
import QtQuick.Shapes

Shape {
    width: 120; height: 120
    ShapePath {
        strokeColor: 'white'; strokeWidth: 3; fillColor: 'royalblue'
        startX: 10; startY: 110
        PathLine { x: 60; y: 10 }
        PathLine { x: 110; y: 110 }
        PathLine { x: 10; y: 110 }
    }
}
```

Efek gambar `[≥6.5]`: `import QtQuick.Effects`, lalu `MultiEffect { source: gambar; anchors.fill: gambar; blurEnabled: true; blur: 0.6; blurMax: 32 }`.

Preferensi pengguna (`QtCore`, `[≥6.5]`): `Settings { id: pref; category: 'ui'; property string tema: 'gelap' }`. Atur `QCoreApplication::setOrganizationName` dan `setApplicationName` di C++ agar lokasi penyimpanannya benar.

| Kebutuhan | Pilihan |
| --- | --- |
| Bentuk vektor | `Shapes` |
| Blur, bayangan, warna | `MultiEffect` |
| Partikel | `QtQuick.Particles` |
| Dialog file/pesan | `QtQuick.Dialogs` |
| Preferensi | `Settings` (`QtCore`) |
| Data tabular kecil | `QtQuick.LocalStorage` (SQLite) |
| Menggambar imperatif 2D | `Canvas`; Qt 6.12 menambah Qt Canvas Painter yang dipercepat GPU `[≥6.12]` (baca catatan rilis) |

**Terminologi.** `Shape`/`ShapePath`; `MultiEffect`; `Particles`; dialog native; `Settings`.

**Daftar isi.** 6.4.1 `Shapes` · 6.4.2 `MultiEffect` · 6.4.3 `Particles` · 6.4.4 `Dialogs` · 6.4.5 `Settings` dan `LocalStorage` · 6.4.6 `Canvas` dan opsi baru Qt 6.12

**Kesalahan umum.** Memakai `Canvas` untuk hal yang cukup dengan `Shapes`; blur pada area besar yang membebani GPU; lupa nama organisasi sehingga `Settings` menulis ke tempat tak terduga.

**Latihan 15 menit.** Gambar segitiga di atas lalu simpan warna isinya dengan `Settings` dan pulihkan saat aplikasi dibuka lagi.

**Cek pemahaman.** Kapan `Shapes` lebih baik daripada `Canvas`?

**Referensi.** [Qt Quick Shapes](https://doc.qt.io/qt-6/qtquick-shapes-qmlmodule.html) · [Qt Quick Effects](https://doc.qt.io/qt-6/qtquick-effects-qmlmodule.html) · [Settings](https://doc.qt.io/qt-6/qml-qtcore-settings.html) · [Blog Qt](https://www.qt.io/blog)

## [Fase 7 — Model, View, dan Arsitektur Data][7]

*Tujuan: menampilkan dan mengelola data dinamis dengan benar. Estimasi: 2–3 minggu.*

### Modul 7.1 — Model Data

**Deskripsi.** Sumber data untuk view: `ListModel`, array JavaScript, angka, `ObjectModel`, dan model C++ (pratinjau Modul 10.5).

**Konsep & analogi.** Model adalah gudang berlabel: setiap rak (baris) punya kotak bernama (role). View hanyalah etalase yang menampilkan isi rak tanpa tahu cara gudang diisi.

**Contoh minimal.**

```qml
import QtQuick

Item {
    ListModel {
        id: produk
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh'; harga: 8000 }
    }

    Component.onCompleted: {
        produk.append({ nama: 'Susu', harga: 12000 })
        produk.setProperty(0, 'harga', 16000)
        console.log(produk.count, produk.get(0).nama)
    }
}
```

Jaga tipe tiap role tetap konsisten antarbaris; `ListModel` menentukan tipe role dari data yang pertama kali masuk.

**Terminologi.** Model; role; `ListModel`/`ListElement`; `count`; model C++ (`QAbstractListModel`).

**Daftar isi.** 7.1.1 `ListModel` dan API (`append`, `insert`, `remove`, `set`, `setProperty`, `move`, `clear`, `get`) · 7.1.2 Array dan angka sebagai model · 7.1.3 `ObjectModel` · 7.1.4 Kapan model harus pindah ke C++ · 7.1.5 Memfilter dan mengurutkan (proxy model dari C++)

**Kesalahan umum.** Role bertipe campuran; memodifikasi array JavaScript lalu berharap view berubah (reassign propertinya); memasukkan data besar langsung dari JavaScript.

**Latihan 15 menit.** Tambah, ubah, dan hapus baris dari kode, lalu cetak `count` setelah tiap operasi.

**Cek pemahaman.** Mengapa model besar sebaiknya berada di C++?

**Referensi.** [Models and Views in Qt Quick](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html) · [ListModel](https://doc.qt.io/qt-6/qml-qtqml-models-listmodel.html)

### Modul 7.2 — View dan Delegate

**Deskripsi.** `ListView`, `GridView`, `PathView`, `TableView`, `Repeater`, dan delegate yang benar di Qt 6.

**Konsep & analogi.** View adalah mesin cetak halaman: ia hanya mencetak baris yang tampak dan mendaur ulang cetakan saat Anda menggulir. Delegate adalah cetakan satu baris.

**Contoh minimal.**

```qml
import QtQuick

ListView {
    width: 300; height: 200; clip: true

    model: ListModel {
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh'; harga: 8000 }
    }

    delegate: Rectangle {
        id: baris
        required property string nama
        required property int harga
        required property int index

        width: ListView.view.width; height: 40
        color: index % 2 === 0 ? '#eeeeee' : '#dddddd'

        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 12
            text: baris.nama + ' — ' + baris.harga
        }
    }
}
```

Delegate modern memakai `required property` untuk setiap role. Pola lama `model.nama` gagal bila dokumen memakai `pragma ComponentBehavior: Bound` dan memicu peringatan `qmllint`.

**Terminologi.** View; delegate; `required property`; `index`; attached `ListView.view` dan `ListView.isCurrentItem`; `highlight`; `cacheBuffer`; `reuseItems`.

**Daftar isi.** 7.2.1 `ListView` dan `GridView` · 7.2.2 `PathView` dan `Repeater` · 7.2.3 `TableView` · 7.2.4 Delegate dengan `required property` · 7.2.5 `currentIndex` dan `highlight` · 7.2.6 `cacheBuffer` dan `reuseItems` · 7.2.7 Delegate ringan

**Kesalahan umum.** Memakai `model.nama` tanpa kualifikasi; delegate berat (banyak anak, gambar besar); `clip` terlupa sehingga isi keluar dari view; memakai `Repeater` untuk daftar panjang.

**Latihan 15 menit.** Tambahkan `highlight` dan navigasi keyboard (`Keys.onUpPressed`/`onDownPressed` mengubah `currentIndex`).

**Cek pemahaman.** Mengapa `ListView` dapat menangani ribuan baris sedangkan `Repeater` tidak?

**Referensi.** [ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html) · [TableView](https://doc.qt.io/qt-6/qml-qtquick-tableview.html) · [Models and Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html)

### Modul 7.3 — Objek Dinamis: Loader, Component, dan Instantiator

**Deskripsi.** Membuat objek QML saat runtime dengan `Loader`, `Component.createObject()`, `Qt.createComponent()`, dan `Instantiator`, serta menghancurkannya dengan benar.

**Konsep & analogi.** Pembuatan dinamis seperti memesan kue dari cetakan sesuai kebutuhan, bukan menyiapkan semua kue sebelumnya. Anda juga bertanggung jawab membuangnya.

**Contoh minimal.**

```qml
import QtQuick

Item {
    id: root
    width: 300; height: 200

    Component {
        id: kotakKomponen
        Rectangle { width: 40; height: 40; color: 'tomato' }
    }

    function tambahKotak(posisiX) {
        const obj = kotakKomponen.createObject(root, { x: posisiX, y: 20 })
        if (!obj) console.warn('gagal membuat objek')
        return obj
    }

    Component.onCompleted: {
        const k = tambahKotak(30)
        tambahKotak(100)
        k.destroy(500)      // dihancurkan setelah 500 ms
    }

    Loader { active: false; asynchronous: true; sourceComponent: kotakKomponen }
}
```

`Qt.createQmlObject()` mengeksekusi teks sebagai kode QML. Jangan pernah memberinya string dari sumber tak tepercaya (lihat Modul 13.1).

**Terminologi.** `Loader` (`active`, `source`, `sourceComponent`, `asynchronous`); `Component`; `createObject`; `Instantiator`; parent vs owner; `destroy()`.

**Daftar isi.** 7.3.1 `Loader` · 7.3.2 `Component.createObject()` · 7.3.3 `Qt.createComponent()` dan status loading · 7.3.4 `Instantiator` · 7.3.5 `destroy()` dan kepemilikan · 7.3.6 Risiko `Qt.createQmlObject`

**Kesalahan umum.** Fungsi pembuat ditulis di luar objek (bukan QML valid; harus berada di dalam objek); tidak memeriksa hasil `createObject`; kebocoran objek karena tidak pernah dihancurkan.

**Latihan 15 menit.** Buat tombol yang menambah kotak baru dengan `createObject` dan tombol lain yang menghapus kotak terakhir.

**Cek pemahaman.** Apa bedanya `Loader` dan `createObject`? Siapa pemilik objek yang dibuat dengan `createObject(parent)`?

**Referensi.** [Dynamic QML Object Creation](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html) · [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html) · [Instantiator](https://doc.qt.io/qt-6/qml-qtqml-models-instantiator.html)

### Modul 7.4 — Data Asinkron: XHR, JSON, dan Pekerjaan Berat

**Deskripsi.** Mengambil data jaringan dengan `XMLHttpRequest`, mengurai JSON, menangani galat, dan memindahkan pekerjaan berat dari thread UI.

**Konsep & analogi.** Permintaan jaringan seperti memesan makanan lewat kurir: Anda tidak berdiri menunggu di pintu (UI tetap berjalan), kurir mengabari saat tiba (callback). Pekerjaan berat di thread UI sama dengan pelayan yang berhenti melayani selama memasak.

**Contoh minimal.**

```qml
import QtQuick

Item {
    function ambilJson(url, sukses, gagal) {
        const req = new XMLHttpRequest()
        req.onreadystatechange = function() {
            if (req.readyState !== XMLHttpRequest.DONE) return
            if (req.status === 200) {
                try { sukses(JSON.parse(req.responseText)) }
                catch (e) { gagal('JSON tidak valid: ' + e) }
            } else {
                gagal('HTTP ' + req.status)
            }
        }
        req.open('GET', url)
        req.send()
    }

    Component.onCompleted: ambilJson('https://example.com/data.json', console.log, console.warn)
}
```

`Promise` tersedia di lingkungan QML, tetapi pola yang paling terbukti tetap callback dan signal. `async/await` **\[uji dulu\]** (lihat Modul 2.1). Untuk pekerjaan berat, pakai `WorkerScript` atau pindahkan ke C++ (Modul 10.7).

**Terminologi.** `XMLHttpRequest`; `readyState`; status HTTP; `JSON.parse`; callback; `WorkerScript`; thread UI.

**Daftar isi.** 7.4.1 XHR dan siklus `readyState` · 7.4.2 `JSON.parse` dan validasi · 7.4.3 Penanganan galat (jaringan, HTTP, parsing) · 7.4.4 `Promise` dan keterbatasan `async/await` · 7.4.5 `WorkerScript` · 7.4.6 Kapan ke C++

**Kesalahan umum.** Tidak menangani `status` selain 200; menganggap respons selalu JSON valid; parsing data besar di thread UI hingga antarmuka macet; memasukkan hasil jaringan langsung ke `Qt.createQmlObject`.

**Latihan 15 menit.** Ubah `ambilJson` agar mengembalikan galat berbeda untuk jaringan putus, HTTP 404, dan JSON rusak.

**Cek pemahaman.** Mengapa respons jaringan harus divalidasi sebelum dipakai?

**Referensi.** [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [WorkerScript](https://doc.qt.io/qt-6/qml-qtqml-workerscript-workerscript.html) · [MDN: XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)

## [Fase 8 — Modul QML dan Arsitektur Aplikasi][8]

*Tujuan: menyusun proyek yang bisa tumbuh tanpa berantakan. Estimasi: 2–3 minggu.*

### Modul 8.1 — Modul QML, URI, dan Import

**Deskripsi.** Memecah aplikasi menjadi modul QML bernama dan mengatur cara modul ditemukan.

**Konsep & analogi.** Modul adalah buku di perpustakaan: punya judul unik (URI), daftar isi (tipe yang diekspor), dan lokasi di rak (import path). Aplikasi meminjam dengan `import`.

**Contoh minimal.** Dua modul dalam satu proyek:

```
app/
├── CMakeLists.txt
├── main.cpp
├── App/Main.qml                 # modul MyApp.App
└── Components/AppButton.qml     # modul MyApp.Components
```

Di `Main.qml`: `import MyApp.Components` lalu `AppButton { label: 'OK' }`. Di CMake, satu `qt_add_qml_module` per modul, dan aplikasi menautkan pustaka modul sesuai pola backing library dan plugin yang dijelaskan di dokumentasi `qt_add_qml_module`.

```
App  →  Features  →  Components  →  Core
(tidak boleh ada panah balik; tidak ada siklus)
```

**Terminologi.** URI; `qmldir`; import path (`QML_IMPORT_PATH`); import tanpa versi; backing library; plugin modul; dependensi siklik.

**Daftar isi.** 8.1.1 Anatomi modul · 8.1.2 URI dan struktur folder · 8.1.3 `qmldir` dan pembuatannya otomatis · 8.1.4 Import path dan `QML_IMPORT_TRACE` · 8.1.5 Modul statis vs plugin · 8.1.6 Aturan dependensi antarmodul

**Kesalahan umum.** URI tidak cocok dengan struktur folder; modul saling mengimpor (siklus); lupa menautkan target modul statis.

**Latihan 15 menit.** Pindahkan `AppButton.qml` dan `Theme.qml` ke modul `MyApp.Components` dan impor dari modul aplikasi.

**Cek pemahaman.** Bagaimana `QML_IMPORT_TRACE` membantu saat modul tidak ditemukan?

**Referensi.** [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html) · [qmldir](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html)

### Modul 8.2 — Arsitektur Aplikasi

**Deskripsi.** Memisahkan tampilan, logika presentasi, domain, dan data; memilih tempat menyimpan keadaan.

**Konsep & analogi.** Aplikasi seperti restoran: ruang makan (UI), kasir dan pelayan (logika presentasi), dapur (domain), gudang (data). Pelanggan tidak masuk gudang, dan dapur tidak peduli warna taplak meja. Aturan praktis: properti turun, signal naik, satu sumber kebenaran.

**Contoh minimal.** Store sederhana sebagai singleton:

```qml
// Store.qml
pragma Singleton
import QtQuick

QtObject {
    property var daftarTugas: []
    signal tugasBerubah()

    function tambah(judul) {
        daftarTugas = [...daftarTugas, { judul, selesai: false }]
        tugasBerubah()
    }
}
```

Untuk aplikasi nyata, ganti `var` dengan model bertipe (`ListModel` atau model C++) agar tooling dan performa terbantu.

**Terminologi.** Layering; MVC/MVVM; single source of truth; controller/store; dependency direction.

**Daftar isi.** 8.2.1 Layering · 8.2.2 MVC/MVVM di QML · 8.2.3 Store/state terpusat · 8.2.4 Navigasi sebagai tanggung jawab tersendiri · 8.2.5 Penanganan galat lintas layer · 8.2.6 Logika di QML vs di C++

**Kesalahan umum.** Logika bisnis di delegate; keadaan tersebar di banyak komponen; UI mengubah data langsung tanpa melalui layer yang bertanggung jawab.

**Latihan 15 menit.** Pindahkan logika tambah/hapus tugas dari delegate ke `Store.qml` dan biarkan delegate hanya memanggil fungsi store.

**Cek pemahaman.** Mengapa satu sumber kebenaran mengurangi bug sinkronisasi?

**Referensi.** [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [Qt Quick Best Practices](https://doc.qt.io/qt-6/qtquick-bestpractices.html)

### Modul 8.3 — Struktur Proyek dan CMake Lanjutan

**Deskripsi.** Menata folder, target, dan alat bantu build untuk proyek multi-modul.

**Konsep & analogi.** Proyek yang rapi seperti dapur yang tertata: orang baru langsung tahu di mana pisau dan di mana piring.

**Contoh minimal.**

```
app/
├── CMakeLists.txt
├── CMakePresets.json
├── src/            # C++
├── qml/
│   ├── App/
│   └── Components/
└── tests/
```

Build lewat preset: `cmake --preset debug && cmake --build --preset debug`. Aktifkan `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` agar `clangd` memahami kode C++. Jalankan `cmake --build build --target all_qmllint` untuk analisis statis seluruh modul QML.

**Terminologi.** Target; preset (`CMakePresets.json`); out-of-source build; `compile_commands.json`; `QML_FILES`, `SOURCES`, `RESOURCES`.

**Daftar isi.** 8.3.1 Tata letak folder · 8.3.2 `QML_FILES`, `SOURCES`, `RESOURCES` · 8.3.3 Banyak modul dan target · 8.3.4 Preset dan konfigurasi Debug/Release · 8.3.5 `compile_commands.json` untuk clangd · 8.3.6 `qmllint` sebagai target build

**Kesalahan umum.** Semua file di satu folder; build di dalam source; tidak memisahkan konfigurasi Debug dan Release.

**Latihan 15 menit.** Tambahkan preset `debug`, jalankan lewat `cmake --preset`, lalu jalankan `all_qmllint`.

**Cek pemahaman.** Mengapa build di luar source direktori lebih aman?

**Referensi.** [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [CMake Presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)

### Modul 8.4 — Konvensi, Linting, dan Disiplin Kualitas

**Deskripsi.** Menjaga kode konsisten dengan `qmlformat`, `qmllint`, dan pemeriksaan otomatis sebelum commit.

**Konsep & analogi.** Linter adalah korektor naskah yang tidak pernah lelah: ia menangkap kesalahan sebelum pembaca melihatnya.

**Contoh minimal.** Hook `pre-commit` sederhana (simpan sebagai `.git/hooks/pre-commit` dan buat executable):

```
#!/bin/sh
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.qml$')
[ -z "$files" ] && exit 0
qmllint $files || exit 1
```

Konvensi inti: `id: root` untuk akar komponen; urutan atribut (id, properti, signal, handler, fungsi, anak); akses berkualifikasi; tanpa logika berat di binding.

**Terminologi.** Linter; formatter; hook; CI (continuous integration); konvensi gaya.

**Daftar isi.** 8.4.1 Urutan atribut dan penamaan · 8.4.2 `qmlformat` · 8.4.3 `qmllint` dan peringatan umum · 8.4.4 Hook git · 8.4.5 CI sederhana

**Kesalahan umum.** Mengabaikan peringatan `qmllint` karena aplikasi tetap jalan; tidak menyepakati format sehingga diff penuh derau.

**Latihan 15 menit.** Pasang hook di atas pada repo latihan dan coba commit file dengan peringatan `qmllint`.

**Cek pemahaman.** Mengapa peringatan `qmllint` perlu diperlakukan serius walau aplikasi berjalan?

**Referensi.** [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html)

## [Fase 9 — Qt Quick Controls dan UI Lanjut][9]

*Tujuan: membangun antarmuka aplikasi lengkap yang konsisten, bisa dikustomisasi, dan dapat diakses. Estimasi: 2–3 minggu.*

### Modul 9.1 — Controls Dasar

**Deskripsi.** Komponen siap pakai di `QtQuick.Controls`: `ApplicationWindow`, `Button`, `TextField`, `CheckBox`, `Switch`, `ComboBox`, `Slider`, `ScrollView`, dan kerabatnya.

**Konsep & analogi.** Controls adalah perabot pabrikan: sudah punya perilaku (fokus, hover, keyboard) dan tampilan. Anda hanya menyusunnya, lalu menyesuaikannya bila perlu (Modul 9.2).

**Contoh minimal.**

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true; width: 360; height: 220; title: 'Controls'

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 8

        TextField { id: nama; Layout.fillWidth: true; placeholderText: 'Nama' }
        Switch { id: aktif; text: 'Aktif' }
        Button {
            text: 'Kirim'
            enabled: nama.text.length > 0
            onClicked: console.log(nama.text, aktif.checked)
        }
    }
}
```

**Terminologi.** `Control`; `ApplicationWindow`; `checked`/`down`/`hovered`; `activeFocusOnTab`; `contentItem` dan `background`.

**Daftar isi.** 9.1.1 `ApplicationWindow` dan `Page` · 9.1.2 Tombol dan pilihan · 9.1.3 Input teks · 9.1.4 `Slider`, `SpinBox`, `ComboBox` · 9.1.5 `ScrollView` · 9.1.6 Controls dengan Layouts · 9.1.7 Urutan Tab

**Kesalahan umum.** Mengubah ukuran Controls tanpa `implicitWidth`; memakai `Rectangle` + `TapHandler` untuk tombol sehingga kehilangan perilaku keyboard dan aksesibilitas; mengabaikan urutan Tab.

**Latihan 15 menit.** Tambahkan `ComboBox` pilihan peran dan tampilkan nilainya di log saat tombol ditekan.

**Cek pemahaman.** Mengapa `Button` lebih baik daripada `Rectangle` dengan `TapHandler`?

**Referensi.** [Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-index.html) · [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html)

### Modul 9.2 — Style dan Kustomisasi Controls

**Deskripsi.** Memilih style, mengganti tampilan satu kontrol, dan memahami dampaknya pada performa.

**Konsep & analogi.** Style adalah kostum seluruh pemain; kustomisasi adalah mengubah kostum satu pemain. Kostum pabrikan tertentu (native) tidak boleh dijahit ulang.

| Style | Catatan |
| --- | --- |
| Basic | Dasar yang ringan dan ideal untuk dikustomisasi |
| Fusion | Bawaan di Linux desktop |
| Material, Universal, Imagine | Style siap pakai yang dapat dikustomisasi |
| FluentWinUI3 `[≥6.7]` | Gaya Windows 11 |
| Windows, macOS, iOS (native) | Mengikuti platform; **tidak mendukung kustomisasi** |

Qt 6.12 juga mengenalkan style Native baru dan StyleKit eksperimental (Qt Labs); baca catatan rilis sebelum mengandalkannya.

Cara memilih style: variabel lingkungan `QT_QUICK_CONTROLS_STYLE`; argumen `-style`; file `qtquickcontrols2.conf`; atau memanggil `QQuickStyle::setStyle()` di C++ sebelum engine dibuat (tautkan `Qt6::QuickControls2`).

```
[Controls]
Style=Basic
```

Pemilihan style saat runtime membuat compiler QML tidak bisa menghasilkan C++ untuk binding properti Controls. Bila Anda berkustomisasi, impor style secara eksplisit, misalnya `import QtQuick.Controls.Basic`.

**Contoh minimal.**

```qml
import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control
    text: 'Simpan'

    contentItem: Text {
        text: control.text; color: 'white'
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        implicitWidth: 100; implicitHeight: 40; radius: 6
        color: control.down ? '#1d4ed8' : control.hovered ? '#3b82f6' : '#2563eb'
    }
}
```

**Terminologi.** Style; `QQuickStyle`; `qtquickcontrols2.conf`; `contentItem`; `background`; palette; impor style eksplisit.

**Daftar isi.** 9.2.1 Daftar style dan karakternya · 9.2.2 Empat cara memilih style · 9.2.3 Kustomisasi `contentItem` dan `background` · 9.2.4 Palette dan font · 9.2.5 Dampak ke performa dan kompilasi QML · 9.2.6 Membuat style sendiri

**Kesalahan umum.** Mencoba mengustomisasi style native; mengira style Default dan Basic dua hal berbeda di Qt 6 (Default lama telah menjadi Basic); mengatur style setelah engine dibuat.

**Latihan 15 menit.** Jalankan contoh Controls di Modul 9.1 dengan tiga style berbeda lewat `QT_QUICK_CONTROLS_STYLE` dan bandingkan.

**Cek pemahaman.** Mengapa style native tidak boleh dikustomisasi, dan apa dampak memilih style saat runtime?

**Referensi.** [Styling Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-styles.html) · [Customizing Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-customize.html)

### Modul 9.3 — Navigasi dan Popup

**Deskripsi.** `StackView`, `SwipeView`, `TabBar`, `Drawer`, dan `Popup`/`Dialog`/`Menu`.

**Konsep & analogi.** `StackView` seperti tumpukan kartu: membuka halaman baru menaruh kartu di atas, kembali mengambilnya. `SwipeView` seperti deretan kartu yang digeser sejajar.

**Contoh minimal.**

```qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true; width: 360; height: 240

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: Page {
            title: 'Beranda'
            Button { anchors.centerIn: parent; text: 'Buka detail'; onClicked: stack.push(detail) }
        }
    }

    Component {
        id: detail
        Page {
            title: 'Detail'
            Button { anchors.centerIn: parent; text: 'Kembali'; onClicked: stack.pop() }
        }
    }
}
```

**Terminologi.** `StackView` (`push`, `pop`, `replace`); `SwipeView`; `Drawer`; `Popup`; modal; navigasi.

**Daftar isi.** 9.3.1 `StackView` · 9.3.2 `SwipeView` dan `TabBar` · 9.3.3 `Drawer` · 9.3.4 `Popup`, `Dialog`, `Menu` · 9.3.5 Tombol Escape dan navigasi keyboard · 9.3.6 Pemisahan logika navigasi (Modul 8.2)

**Kesalahan umum.** Menumpuk halaman tanpa batas; memuat semua halaman di awal; navigasi yang tak bisa dioperasikan dari keyboard.

**Latihan 15 menit.** Tambahkan halaman ketiga dan tombol Escape yang memanggil `stack.pop()`.

**Cek pemahaman.** Kapan `SwipeView` lebih tepat dari `StackView`?

**Referensi.** [StackView](https://doc.qt.io/qt-6/qml-qtquick-controls-stackview.html) · [Popup](https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html)

### Modul 9.4 — Aksesibilitas, Internasionalisasi, dan DPI

**Deskripsi.** Membuat aplikasi dapat dipakai semua orang, dalam banyak bahasa, di layar mana pun.

**Konsep & analogi.** Aksesibilitas adalah pintu yang bisa dilalui kursi roda sekaligus orang berdiri. Internasionalisasi adalah menu yang bisa diganti bahasa tanpa membongkar dapur. Antarmuka yang penuh kendali keyboard sekaligus menjadi dasar aksesibilitas.

**Contoh minimal.**

```qml
Button {
    text: qsTr('Simpan')
    Accessible.name: qsTr('Simpan dokumen')
    Accessible.description: qsTr('Menyimpan perubahan ke disk')
}
```

Di CMake, buat berkas terjemahan dengan `qt_add_translations(hello TS_FILES hello_id.ts)`; ekstrak teks dengan `lupdate`, terjemahkan di Qt Linguist, kompilasi dengan `lrelease`.

Qt 6 selalu menyalakan penskalaan high-DPI: gunakan ukuran independen-perangkat dan jangan menulis piksel mutlak untuk jarak penting. Uji aksesibilitas di Linux dengan pembaca layar Orca.

**Terminologi.** `Accessible` (`name`, `description`, `role`); `qsTr`; file `.ts` dan `.qm`; high-DPI; AT-SPI.

**Daftar isi.** 9.4.1 Atribut `Accessible` · 9.4.2 Navigasi keyboard penuh · 9.4.3 `qsTr` dan alur terjemahan · 9.4.4 Format tanggal, angka, dan pluralisasi · 9.4.5 High-DPI dan font · 9.4.6 Uji dengan Orca

**Kesalahan umum.** Teks tanpa `qsTr`; string digabung manual sehingga tak bisa diterjemahkan; ikon tanpa nama aksesibel; mengandalkan warna saja untuk menyampaikan status.

**Latihan 15 menit.** Bungkus semua teks di contoh Controls dengan `qsTr`, buat `hello_id.ts`, dan terjemahkan satu string.

**Cek pemahaman.** Mengapa navigasi keyboard penuh termasuk aksesibilitas?

**Referensi.** [Accessibility](https://doc.qt.io/qt-6/accessible.html) · [Internationalization](https://doc.qt.io/qt-6/internationalization.html) · [Qt Linguist](https://doc.qt.io/qt-6/qtlinguist-index.html)

## [Fase 10 — Interoperabilitas C++ dan QML][10]

*Tujuan: menghubungkan backend C++ dengan antarmuka QML secara bersih, aman, dan cepat. Estimasi: 3–4 minggu, dengan syarat Modul 10.1 sudah dikerjakan di jalur paralel sejak Fase 4.*

### Modul 10.1 — C++ Dasar untuk Qt (jalur paralel)

**Deskripsi.** Kompetensi C++ minimum untuk membaca dan menulis backend Qt: nilai vs referensi, pointer, RAII, smart pointer, `const`, lambda, template dasar.

**Konsep & analogi.** RAII adalah kunci kamar hotel dengan kartu: sumber daya (kamar) otomatis dikembalikan ketika kartu (objek) keluar dari jangkauan. Di Qt, `QObject` punya mekanisme tambahan: induk menghancurkan anaknya.

**Contoh minimal.**

```cpp
#include <QString>
#include <QDebug>
#include <memory>

struct Produk { QString nama; int harga; };

int main()
{
    auto p = std::make_unique<Produk>(Produk{QStringLiteral("Kopi"), 15000});
    qDebug() << p->nama << p->harga;   // pemilik tunggal; dibebaskan otomatis
}
```

**Terminologi.** RAII; `std::unique_ptr`; `const` correctness; lambda; implicit sharing (`QString`, `QList`); parent ownership.

**Daftar isi.** 10.1.1 Tipe, nilai, referensi, pointer · 10.1.2 RAII dan smart pointer · 10.1.3 `const` dan referensi `const&` · 10.1.4 Lambda dan fungsi sebagai nilai · 10.1.5 Template dasar · 10.1.6 Header vs sumber dan build · 10.1.7 Gaya Qt: `QString`, `QList`, `QStringLiteral`

**Kesalahan umum.** `new` tanpa pemilik jelas; menyimpan pointer ke objek sementara; mengira C++ dapat dipelajari dalam beberapa hari. Bila C++ baru bagi Anda, sisihkan 8–12 minggu paruh waktu.

**Latihan 15 menit.** Ubah contoh agar menyimpan tiga produk di `QList<Produk>` dan mencetak yang harganya di atas 10000.

**Cek pemahaman.** Mengapa `std::unique_ptr` lebih aman daripada `new` mentah?

**Referensi.** [learncpp.com](https://www.learncpp.com/) · [cppreference](https://en.cppreference.com/w/) · [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)

### Modul 10.2 — QObject, Meta-Object, Properti, dan Signal/Slot

**Deskripsi.** Fondasi yang membuat objek C++ bisa dipakai QML: `Q_OBJECT`, `Q_PROPERTY`, signal, slot, `Q_INVOKABLE`, dan kepemilikan induk-anak.

**Konsep & analogi.** MOC membaca kelas Anda dan membuat “kartu identitas” (meta-object) yang memberi tahu QML nama properti, signal, dan method. Tanpa kartu itu, QML tidak bisa melihat apa pun di dalam kelas.

**Contoh minimal.** `backend.h`:

```cpp
#pragma once
#include <QObject>
#include <QString>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString pesan READ pesan WRITE setPesan NOTIFY pesanChanged FINAL)

public:
    explicit Backend(QObject *parent = nullptr) : QObject(parent) {}

    QString pesan() const { return m_pesan; }
    void setPesan(const QString &p)
    {
        if (m_pesan == p) return;
        m_pesan = p;
        emit pesanChanged();
    }

    Q_INVOKABLE void muatUlang() { setPesan(QStringLiteral("dimuat")); }

signals:
    void pesanChanged();

private:
    QString m_pesan;
};
```

**Terminologi.** `Q_OBJECT`; MOC; `Q_PROPERTY` (`READ`, `WRITE`, `NOTIFY`, `FINAL`); `Q_INVOKABLE`; signal dan slot; parent ownership; jenis koneksi (direct, queued).

**Daftar isi.** 10.2.1 `Q_OBJECT` dan MOC · 10.2.2 `Q_PROPERTY` lengkap dengan `NOTIFY` · 10.2.3 Signal dan slot · 10.2.4 `Q_INVOKABLE` · 10.2.5 Hierarki objek dan kepemilikan · 10.2.6 Jenis koneksi dan thread affinity (Modul 10.7)

**Kesalahan umum.** Menulis setter tanpa memeriksa nilai sama (memicu sinyal berlebih); properti tanpa `NOTIFY` sehingga binding tak pernah diperbarui; lupa `Q_OBJECT`.

**Latihan 15 menit.** Tambahkan properti `int hitungan` dengan `NOTIFY` dan method `Q_INVOKABLE tambah()`.

**Cek pemahaman.** Apa yang terjadi di QML bila `Q_PROPERTY` tidak punya `NOTIFY`?

**Referensi.** [The Meta-Object System](https://doc.qt.io/qt-6/metaobjects.html) · [The Property System](https://doc.qt.io/qt-6/properties.html) · [Signals & Slots](https://doc.qt.io/qt-6/signalsandslots.html) · [QObject](https://doc.qt.io/qt-6/qobject.html)

### Modul 10.3 — Registrasi Tipe C++ ke QML

**Deskripsi.** Mengekspos kelas C++ sebagai tipe QML dengan `QML_ELEMENT` dan kawan-kawannya, tanpa `qmlRegisterType` dan tanpa context property.

**Konsep & analogi.** Registrasi adalah mendaftarkan nama dagang: setelah terdaftar di modul, QML memesan objek C++ semudah memesan tipe QML.

**Contoh minimal.** Tambahkan dua baris ke `Backend`:

```cpp
#include <QtQml/qqmlregistration.h>
// di dalam class Backend, setelah Q_OBJECT:
QML_ELEMENT
```

Daftarkan header di CMake:

```cmake
qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES backend.h
)
```

Di QML (modul yang sama atau dengan `import Hello`): `Backend { id: backend }`.

| Makro | Fungsi |
| --- | --- |
| `QML_ELEMENT` / `QML_NAMED_ELEMENT` | Tipe yang bisa dibuat di QML (dengan nama kelas atau nama kustom) |
| `QML_SINGLETON` | Satu instance per engine |
| `QML_UNCREATABLE` | Dapat dirujuk tetapi tidak bisa dibuat dari QML |
| `QML_ATTACHED` | Properti tempelan (`Tipe.properti`) |
| `QML_EXTENDED`, `QML_FOREIGN` | Memperluas atau mengekspos kelas yang tak bisa diubah |

**Terminologi.** `QML_ELEMENT`; modul QML; URI; `QML_SINGLETON`; attached type; foreign type.

**Daftar isi.** 10.3.1 `QML_ELEMENT` dan modul · 10.3.2 Mendaftarkan header dan sumber di CMake · 10.3.3 Singleton C++ · 10.3.4 Tipe yang tak dapat dibuat (`QML_UNCREATABLE`) · 10.3.5 Attached, extended, dan foreign type · 10.3.6 Mengapa `qmlRegisterType` dan context property ditinggalkan

**Kesalahan umum.** Lupa menaruh header di `SOURCES`; URI di CMake berbeda dari yang diimpor; tetap memakai `setContextProperty` untuk kode baru.

**Latihan 15 menit.** Daftarkan `Backend`, buat `Backend { id: backend }` di `Main.qml`, dan tampilkan `backend.pesan` di sebuah `Text`.

**Cek pemahaman.** Mengapa registrasi tipe lebih baik dari context property?

**Referensi.** [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) · [Overview: QML and C++ Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html)

### Modul 10.4 — Memakai Objek C++ dari QML dan Sebaliknya

**Deskripsi.** Membaca properti, memanggil method, menyambung signal C++ dari QML, dan (sedapat mungkin) menghindari C++ mengutak-atik pohon QML.

**Konsep & analogi.** Antarmuka antara dua dunia harus berupa pintu sempit yang jelas: C++ mengekspos objek, QML memakainya. Jangan biarkan C++ menyelinap ke ruang QML mencari anak dengan nama tertentu.

**Contoh minimal.**

```qml
import QtQuick
import Hello

Item {
    Backend { id: backend }

    Text { text: backend.pesan }
    TapHandler { onTapped: backend.muatUlang() }

    Connections {
        target: backend
        function onPesanChanged() { console.log('pesan:', backend.pesan) }
    }
}
```

**Pemetaan tipe.** `QString` ↔ `string`; `int`/`double` ↔ `int`/`real`; `QVariantList` ↔ array JavaScript (dapat diubah di tempat sejak 6.5); `QVariantMap` ↔ objek (diubah di tempat sejak 6.9); `QDate`/`QDateTime` ↔ `Date` (berbasis UTC); `QTime` ↔ `Date`. Array-like dari C++ tidak lolos `Array.isArray()`.

**Terminologi.** Konversi tipe; `QVariant`; `QJSValue`; `QMetaObject::invokeMethod`; `QQmlProperty`; `Connections`.

**Daftar isi.** 10.4.1 Properti dan binding ke objek C++ · 10.4.2 Memanggil `Q_INVOKABLE` · 10.4.3 `Connections` ke signal C++ · 10.4.4 Konversi tipe dan jebakannya · 10.4.5 Memanggil QML dari C++ (`invokeMethod`, `QQmlProperty`) · 10.4.6 Prinsip: C++ tidak mencari anak QML

**Kesalahan umum.** Mengandalkan `findChild` pada pohon QML; mengabaikan jebakan `Array.isArray`; mengirim struktur besar bolak-balik tiap frame.

**Latihan 15 menit.** Tambahkan signal `selesai(int hasil)` di `Backend` dan tangani di QML lewat `Connections`.

**Cek pemahaman.** Mengapa C++ sebaiknya tidak memanggil `findChild` di pohon QML?

**Referensi.** [Data Type Conversion](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html) · [Exposing Attributes of C++ Classes](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppattributes.html)

### Modul 10.5 — Model C++ dengan QAbstractListModel

**Deskripsi.** Membuat model data berkinerja tinggi di C++ untuk `ListView` dan kawan-kawan.

**Konsep & analogi.** Model C++ adalah pustakawan yang memegang katalog: view menanyakan “berapa baris?” dan “apa isi baris ke-n untuk role ini?”, dan pustakawan wajib mengabari bila ada buku masuk atau keluar.

**Contoh minimal.** `perangkatmodel.h`:

```cpp
#pragma once
#include <QAbstractListModel>
#include <QList>
#include <QtQml/qqmlregistration.h>

class PerangkatModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum Role { NamaRole = Qt::UserRole + 1, AktifRole };
    struct Item { QString nama; bool aktif; };

    explicit PerangkatModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

    int rowCount(const QModelIndex &parent = {}) const override
    {
        return parent.isValid() ? 0 : static_cast<int>(m_data.size());
    }

    QVariant data(const QModelIndex &index, int role) const override
    {
        if (!index.isValid() || index.row() >= m_data.size()) return {};
        const Item &it = m_data.at(index.row());
        switch (role) {
        case NamaRole: return it.nama;
        case AktifRole: return it.aktif;
        }
        return {};
    }

    QHash<int, QByteArray> roleNames() const override
    {
        return { { NamaRole, "nama" }, { AktifRole, "aktif" } };
    }

    Q_INVOKABLE void tambah(const QString &nama)
    {
        const int n = static_cast<int>(m_data.size());
        beginInsertRows({}, n, n);
        m_data.append({ nama, true });
        endInsertRows();
    }

private:
    QList<Item> m_data;
};
```

Di QML, delegate memakai `required property string nama` dan `required property bool aktif` (Modul 7.2).

**Terminologi.** `QAbstractListModel`; role dan `roleNames`; `beginInsertRows`/`endInsertRows`; `dataChanged`; proxy model (`QSortFilterProxyModel`).

**Daftar isi.** 10.5.1 Kerangka `QAbstractListModel` · 10.5.2 `roleNames` dan `data` · 10.5.3 Menambah dan menghapus baris yang benar · 10.5.4 `setData` dan `dataChanged` · 10.5.5 Sortir dan filter dengan proxy model · 10.5.6 Model besar dan pembaruan bertahap

**Kesalahan umum.** Mengubah data tanpa `beginInsertRows`/`endInsertRows` sehingga view tidak sinkron; role yang tidak terdaftar di `roleNames`; mengembalikan `QVariant` kosong lalu heran delegate kosong.

**Latihan 15 menit.** Tambahkan `Q_INVOKABLE void hapus(int baris)` dengan `beginRemoveRows`/`endRemoveRows`.

**Cek pemahaman.** Apa yang rusak bila Anda mengubah `m_data` tanpa memanggil `beginInsertRows`?

**Referensi.** [QAbstractListModel](https://doc.qt.io/qt-6/qabstractlistmodel.html) · [QAbstractItemModel](https://doc.qt.io/qt-6/qabstractitemmodel.html) · [Model/View Programming](https://doc.qt.io/qt-6/model-view-programming.html)

### Modul 10.6 — API Native dan Integrasi Sistem

**Deskripsi.** Mengakses proses, file, jaringan, dan layanan sistem lewat API Qt, termasuk D-Bus yang sentral di desktop Linux.

**Konsep & analogi.** API Qt adalah penerjemah ke sistem operasi: Anda berbicara satu bahasa, penerjemah mengurus dialek Linux, Windows, atau macOS. Pendekatan Qt menjaga portabilitas; pemanggilan POSIX langsung hanya bila Qt tak menyediakannya.

**Contoh minimal.**

```cpp
#include <QProcess>
#include <QDebug>

void contoh()
{
    QProcess proses;
    proses.start(QStringLiteral("uname"), { QStringLiteral("-r") });  // argumen terpisah, tanpa shell
    proses.waitForFinished(2000);   // hanya untuk demo; di UI pakai sinyal finished
    qDebug() << proses.readAllStandardOutput().trimmed();
}
```

Jelajahi layanan D-Bus dari terminal: `busctl --user list` dan `busctl --user tree <nama-layanan>`. Di C++, `QtDBus` (`QDBusInterface`, adaptor) memakai konsep yang sama.

**Terminologi.** `QProcess`; `QFile`/`QDir`/`QStandardPaths`; `QSettings`; `QNetworkAccessManager`; D-Bus (bus pesan antarproses di Linux); `QFileSystemWatcher`.

**Daftar isi.** 10.6.1 `QProcess` dan eksekusi aman · 10.6.2 `QFile`, `QDir`, `QStandardPaths` · 10.6.3 `QSettings` · 10.6.4 Jaringan (`QNetworkAccessManager`) · 10.6.5 D-Bus · 10.6.6 Pemantauan file · 10.6.7 Kapan POSIX langsung layak

**Kesalahan umum.** Merakit string perintah shell dari input pengguna (rentan injeksi); memblokir thread UI dengan `waitFor...`; mengabaikan kode keluar dan galat proses.

**Latihan 15 menit.** Bungkus `QProcess` dalam `Q_INVOKABLE` yang memancarkan signal saat proses selesai, tanpa memblokir UI.

**Cek pemahaman.** Mengapa argumen `QProcess` diberikan sebagai daftar, bukan satu string?

**Referensi.** [QProcess](https://doc.qt.io/qt-6/qprocess.html) · [Qt D-Bus](https://doc.qt.io/qt-6/qtdbus-index.html) · [Qt Network](https://doc.qt.io/qt-6/qtnetwork-index.html)

### Modul 10.7 — Threading dan Konkurensi *(baru)*

**Deskripsi.** Menjalankan pekerjaan berat tanpa membekukan UI, dan aturan thread yang tidak boleh dilanggar.

**Konsep & analogi.** Thread UI adalah pelayan tunggal di ruang makan. Pekerjaan berat dikirim ke dapur belakang (thread lain). Dapur tidak boleh keluar menata meja sendiri; hasilnya diantar lewat pesan (signal).

**Aturan inti.** Objek QML dan objek GUI hidup di thread utama. Jangan menyentuhnya dari thread lain. Komunikasi lintas thread lewat signal (koneksi queued).

**Contoh minimal.** Potongan di dalam kelas `Backend` (anggap `setHasil(int)` sudah ada; tautkan `Qt6::Concurrent`):

```cpp
#include <QtConcurrent>
#include <QFutureWatcher>

void Backend::hitungBerat()
{
    auto *watcher = new QFutureWatcher<int>(this);
    connect(watcher, &QFutureWatcher<int>::finished, this, [this, watcher] {
        setHasil(watcher->result());      // kembali ke thread utama lewat watcher
        watcher->deleteLater();
    });
    watcher->setFuture(QtConcurrent::run([] {
        int s = 0;
        for (int i = 0; i < 100000000; ++i) s += i % 7;
        return s;
    }));
}
```

**Terminologi.** Thread affinity; `QThread`; worker object (`moveToThread`); `QtConcurrent::run`; `QFutureWatcher`; koneksi queued; `WorkerScript` (untuk JavaScript).

**Daftar isi.** 10.7.1 Thread utama dan aturan UI · 10.7.2 `QtConcurrent::run` dan `QFutureWatcher` · 10.7.3 `QThread` dan worker object · 10.7.4 `QThreadPool` · 10.7.5 Signal lintas thread · 10.7.6 `WorkerScript` · 10.7.7 Race condition dan penguncian dasar

**Kesalahan umum.** Mengubah properti QML dari thread kerja; mewarisi `QThread` lalu menaruh slot di dalamnya; berbagi data tanpa sinkronisasi.

**Latihan 15 menit.** Panggil `hitungBerat()` dari tombol, lalu tampilkan hasilnya di `Text` sambil memastikan animasi di layar tetap mulus.

**Cek pemahaman.** Mengapa hasil perhitungan tidak boleh langsung menulis ke objek QML dari thread kerja?

**Referensi.** [Threading and Concurrent Programming](https://doc.qt.io/qt-6/thread-basics.html) · [Qt Concurrent](https://doc.qt.io/qt-6/qtconcurrent-index.html) · [QThread](https://doc.qt.io/qt-6/qthread.html)

## [Fase 11 — Rendering dan Performa][11]

*Tujuan: memahami bagaimana frame digambar, lalu mengukur dan memperbaiki performa berdasarkan data. Estimasi: 3–4 minggu. Aturan utama: ukur dulu, baru ubah.*

### Modul 11.1 — Scene Graph dan Render Loop

**Deskripsi.** Bagaimana item QML menjadi node scene graph, bagaimana node digabung (batching), dan bagaimana thread GUI dan thread render bekerja sama.

**Konsep & analogi.** Thread GUI adalah penulis naskah: ia memutuskan apa yang tampil. Thread render adalah panggung: ia menggambar berdasarkan salinan naskah. Fase sinkronisasi adalah momen singkat saat naskah diserahkan; hanya di momen itu kedua thread bersentuhan.

```
Thread GUI    : event → binding → polish → sync ─┐
Thread render :                                   └→ render → swap (vsync)
```

**Contoh minimal (diagnosa dari terminal).**

```
QSG_INFO=1 qml Main.qml
QSG_VISUALIZE=batches qml Main.qml
QSG_RENDER_LOOP=basic qml Main.qml
```

**Terminologi.** Scene graph; node; batch (penggabungan perintah gambar); material; polish; sync; render loop (`basic` atau `threaded`); frame time (pada 60 Hz anggaran 16,6 ms).

**Daftar isi.** 11.1.1 Dari item ke node · 11.1.2 Batching dan hal yang memecahnya · 11.1.3 Render loop `basic` dan `threaded` · 11.1.4 Polish dan sync · 11.1.5 Visualisasi (`QSG_VISUALIZE`) · 11.1.6 Layer, clip, dan opacity

**Kesalahan umum.** Mengira semua kode QML berjalan di thread render; memakai `clip` dan `layer.enabled` di mana-mana; mengoptimalkan tanpa melihat `QSG_VISUALIZE`.

**Latihan 15 menit.** Jalankan `QSG_VISUALIZE=batches` pada layar daftar dan catat berapa batch yang terbentuk sebelum dan sesudah menghapus `clip`.

**Cek pemahaman.** Pada fase mana thread GUI dan render bersentuhan?

**Referensi.** [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [Scene Graph Renderer](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph-renderer.html)

### Modul 11.2 — Backend Grafis (RHI) dan Renderer Software

**Deskripsi.** Qt Quick menggambar lewat RHI yang dapat memakai OpenGL, Vulkan, Metal, Direct3D 11/12, atau renderer software.

**Konsep & analogi.** RHI adalah juru bahasa grafis: Qt berbicara satu bahasa, RHI menerjemahkan ke dialek API yang tersedia. Renderer software adalah jalur darurat tanpa GPU.

**Contoh minimal.**

```
QSG_RHI_BACKEND=opengl qml Main.qml
QSG_RHI_BACKEND=vulkan qml Main.qml
QT_QUICK_BACKEND=software qml Main.qml
```

Di C++, `QQuickWindow::setGraphicsApi()` memilih API secara eksplisit dan harus dipanggil sebelum jendela dibuat. Renderer software tidak mendukung fitur berbasis shader (misalnya `ShaderEffect`) dan berguna untuk diagnosa atau perangkat tanpa GPU.

**Terminologi.** RHI; backend (OpenGL, Vulkan, Metal, Direct3D, software); `QQuickWindow::setGraphicsApi`; driver GPU; fallback.

**Daftar isi.** 11.2.1 Peran RHI · 11.2.2 Memilih backend (variabel lingkungan dan C++) · 11.2.3 Perilaku antar-backend · 11.2.4 Renderer software dan batasannya · 11.2.5 Diagnosa masalah driver

**Kesalahan umum.** Menganggap bug rendering pasti bug QML padahal berasal dari driver; memanggil `setGraphicsApi` terlambat; tidak menyiapkan fallback software.

**Latihan 15 menit.** Bandingkan tampilan dan keluaran `QSG_INFO=1` pada dua backend berbeda, lalu pada renderer software.

**Cek pemahaman.** Fitur apa yang hilang pada renderer software?

**Referensi.** [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [Qt RHI](https://doc.qt.io/qt-6/qrhi.html)

### Modul 11.3 — Shader dan Efek Kustom

**Deskripsi.** `ShaderEffect` dan pipeline shader Qt 6: menulis shader, mengompilasinya ke format `.qsb`, dan memakainya dari QML.

**Konsep & analogi.** Shader adalah resep kecil yang dijalankan GPU untuk setiap piksel secara paralel. Qt 6 tidak memakai GLSL OpenGL mentah: shader ditulis dalam GLSL gaya Vulkan lalu dikompilasi `qsb` menjadi format yang dipahami tiap backend.

**Contoh minimal.** `tint.frag`:

```glsl
#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 tint;
};
layout(binding = 1) uniform sampler2D source;

void main() {
    vec4 c = texture(source, qt_TexCoord0);
    fragColor = vec4(mix(c.rgb, tint.rgb, tint.a), c.a) * qt_Opacity;
}
```

Kompilasi (nama executable `qsb` berasal dari `qt6-shadertools`; periksa dengan `pacman -Ql qt6-shadertools | grep /bin/`):

```
qsb --qt6 -o tint.frag.qsb tint.frag
```

`Main.qml` (jalankan dari folder yang sama dengan `qml Main.qml`; ganti `foto.png` dengan gambar Anda):

```qml
import QtQuick

ShaderEffect {
    width: 200; height: 200
    property variant source: Image { source: 'foto.png'; visible: false }
    property color tint: Qt.rgba(1, 0.4, 0, 0.5)
    fragmentShader: 'tint.frag.qsb'
}
```

Di proyek CMake, gunakan `qt_add_shaders` agar kompilasi shader menjadi bagian build, dan rujuk hasilnya lewat path resource.

**Terminologi.** Shader; fragment dan vertex shader; uniform; sampler; SPIR-V; `.qsb`; `std140` (aturan tata letak uniform).

**Daftar isi.** 11.3.1 Alur shader di Qt 6 · 11.3.2 Menulis fragment shader · 11.3.3 `qsb` dan `qt_add_shaders` · 11.3.4 `ShaderEffect` dan properti sebagai uniform · 11.3.5 Vertex shader dasar · 11.3.6 Batas: renderer software

**Kesalahan umum.** Memakai shader OpenGL lama tanpa konversi; urutan uniform tidak sesuai urutan properti; memakai `ShaderEffect` untuk efek sederhana yang dapat dilakukan `MultiEffect`.

**Latihan 15 menit.** Ubah shader agar menghasilkan gambar hitam-putih, kompilasi ulang, dan jalankan.

**Cek pemahaman.** Mengapa shader Qt 6 harus dikompilasi menjadi `.qsb`?

**Referensi.** [ShaderEffect](https://doc.qt.io/qt-6/qml-qtquick-shadereffect.html) · [Qt Shader Tools](https://doc.qt.io/qt-6/qtshadertools-index.html) · [qsb](https://doc.qt.io/qt-6/qtshadertools-qsb.html)

### Modul 11.4 — Profiling dan Optimasi

**Deskripsi.** Mengukur dengan profiler, membaca hasilnya, dan memperbaiki sumber masalah yang sebenarnya.

**Konsep & analogi.** Optimasi tanpa profiler seperti menebak penyakit tanpa pemeriksaan. Siklusnya: ukur → buat hipotesis → ubah satu hal → ukur lagi.

**Contoh minimal.** Siapkan build yang boleh diprofil (infrastruktur debug dan profil hanya untuk lingkungan pengembangan):

```
cmake -S . -B build-profil -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo
```

Tambahkan definisi `QT_QML_DEBUG` pada target untuk build ini saja, jalankan aplikasi dari Qt Creator atau dengan `qmlprofiler`, lalu baca timeline binding, JavaScript, dan rendering.

| Gejala | Penyebab umum | Perbaikan |
| --- | --- | --- |
| Scroll tersendat | Delegate berat, gambar besar | Delegate ringan, `sourceSize`, `reuseItems` |
| Frame time naik saat animasi | Layout dihitung ulang | Animasikan properti non-layout, pakai animator |
| CPU tinggi saat diam | Binding atau timer berlebih | Hapus evaluasi yang tak perlu |
| Banyak batch | `clip`, `layer`, opacity bertingkat | Kurangi pemecah batch (`QSG_VISUALIZE=batches`) |

**Terminologi.** Profiler; frame time; evaluasi binding; overdraw; `layer.enabled`; hot path.

**Daftar isi.** 11.4.1 Menyiapkan build untuk profil · 11.4.2 QML Profiler · 11.4.3 Membaca timeline · 11.4.4 Pemicu umum (binding, delegate, gambar) · 11.4.5 Memori dan kebocoran objek · 11.4.6 Disiplin: satu perubahan, satu pengukuran

**Kesalahan umum.** Mengoptimalkan berdasarkan firasat; profil di build Debug (angka tidak representatif); mengaktifkan infrastruktur debug di build rilis.

**Latihan 15 menit.** Profil daftar 1000 baris dengan dan tanpa `reuseItems`, lalu bandingkan.

**Cek pemahaman.** Mengapa build untuk profil harus berbeda dari build Debug dan juga dari build rilis?

**Referensi.** [Prototyping, Debugging, and Profiling](https://doc.qt.io/qt-6/qtqml-prototyping-debugging-profiling.html) · [Qt Quick Performance](https://doc.qt.io/qt-6/qtquick-performance.html)

### Modul 11.5 — Kompilasi QML *(baru)*

**Deskripsi.** Bagaimana QML dikompilasi menjadi bytecode atau C++, dan cara menulis QML yang dapat dikompilasi.

**Konsep & analogi.** QML yang diinterpretasi seperti membaca resep sambil memasak; QML yang dikompilasi seperti resep yang sudah dihafal. Semakin jelas tipe yang Anda tulis, semakin banyak yang bisa dihafal engine.

| Alat | Fungsi | Catatan |
| --- | --- | --- |
| `qmlcachegen` | Bytecode dan cache | Otomatis lewat CMake; gratis |
| `qmltc` | Kompilasi tipe QML ke C++ | Lihat dokumentasi untuk status dan batasannya |
| `qmlsc` | Kompilasi skrip (menghasilkan kode native) | **Hanya di add-on komersial** Qt Quick Compiler Extensions |

Aturan menulis QML yang ramah kompilasi: beri anotasi tipe pada fungsi dan parameter (anotasi tipe ditegakkan sejak Qt 6.7), pakai `required property`, akses berkualifikasi, `pragma ComponentBehavior: Bound`, hindari context property dan pemilihan style saat runtime untuk binding Controls.

**Contoh minimal.**

```qml
import QtQuick

Item {
    function kuadrat(x: real): real { return x * x }
    function lebarDari(obj: QtObject): real { return (obj as Item)?.width ?? 0 }
}
```

**Terminologi.** Bytecode; cache; `qmlcachegen`; `qmltc`; `qmlsc`; anotasi tipe; type assertion (`as`).

**Daftar isi.** 11.5.1 Jalur kompilasi QML · 11.5.2 `qmlcachegen` dan CMake · 11.5.3 `qmltc` · 11.5.4 `qmlsc` dan lisensinya · 11.5.5 Anotasi tipe dan `as` · 11.5.6 Aturan QML ramah kompilasi · 11.5.7 Membaca peringatan `qmllint`

**Kesalahan umum.** Mengandalkan `qmlsc` tanpa lisensi komersial; fungsi tanpa anotasi tipe; akses tanpa kualifikasi yang menggagalkan optimasi.

**Latihan 15 menit.** Beri anotasi tipe pada tiga fungsi di proyek latihan dan jalankan `all_qmllint` sebelum dan sesudah.

**Cek pemahaman.** Mengapa `qmlsc` tidak tersedia untuk semua pengguna Qt?

**Referensi.** [Qt Quick Compiler](https://doc.qt.io/qt-6/qtqml-qtquick-compiler-tech.html) · [QML Script Compiler](https://doc.qt.io/qt-6/qtqml-qml-script-compiler.html)

## [Fase 12 — Testing dan Kualitas][12]

*Tujuan: menemukan masalah lebih awal dan menjaga kualitas dengan proses yang bisa diulang. Estimasi: 2–3 minggu.*

### Modul 12.1 — Debugging QML

**Deskripsi.** Teknik mencari bug di QML dan di perbatasan C++.

**Konsep & analogi.** Debugging adalah investigasi: kumpulkan bukti (log, jejak), persempit lokasi, uji hipotesis. `console.trace()` adalah kamera pengawas yang menunjukkan siapa memanggil siapa.

**Contoh minimal.**

```qml
import QtQuick

Item {
    property int a: 1
    onAChanged: console.trace()      // jejak pemanggilan setiap perubahan

    Component.onCompleted: {
        console.time('uji')
        a = 2
        console.timeEnd('uji')
        console.assert(a === 2, 'a harus 2')
    }
}
```

Alat tambahan: `QML_IMPORT_TRACE=1` (modul tak ditemukan), `QT_LOGGING_RULES='qt.qml.binding.removal.info=true'` (binding yang tak sengaja terputus), pratinjau langsung lewat `qmlpreview` dan, di Qt 6.12, hot reload bawaan; `gdb` untuk sisi C++. Infrastruktur debug QML membuka layanan debug, jadi hanya aktifkan di lingkungan aman.

**Terminologi.** `console.*` (`log`, `warn`, `error`, `assert`, `trace`, `time`); breakpoint; jejak tumpukan; kategori logging; hot reload.

**Daftar isi.** 12.1.1 API `console` · 12.1.2 Membaca peringatan runtime (binding loop, tipe) · 12.1.3 Kategori logging · 12.1.4 Debugger di Qt Creator · 12.1.5 Pratinjau dan hot reload · 12.1.6 Debugging sisi C++ dengan `gdb` · 12.1.7 Keamanan infrastruktur debug

**Kesalahan umum.** Meninggalkan `console.log` di jalur panas; menebak tanpa log; mengaktifkan debug port di build rilis.

**Latihan 15 menit.** Sebabkan binding terputus karena assignment, lalu temukan kejadiannya dengan `QT_LOGGING_RULES`.

**Cek pemahaman.** Mengapa debug port QML tidak boleh aktif di build rilis?

**Referensi.** [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html) · [Prototyping, Debugging, and Profiling](https://doc.qt.io/qt-6/qtqml-prototyping-debugging-profiling.html) · [GDB](https://sourceware.org/gdb/documentation/)

### Modul 12.2 — Analisis Statis dan Pemformatan

**Deskripsi.** `qmllint`, `qmlformat`, `qmlls`, dan peringatan compiler C++.

**Konsep & analogi.** Linter adalah inspektur bangunan: ia mencari retakan sebelum penghuni masuk. Peringatan yang diabaikan hari ini adalah bug besok.

**Contoh minimal.**

```
qmllint Main.qml
qmllint --help          # lihat kategori peringatan yang tersedia
qmlformat -i Main.qml
cmake --build build --target all_qmllint
```

Hubungkan `qmlls` ke editor Anda agar peringatan muncul saat mengetik. Untuk C++, aktifkan `-Wall -Wextra` dan pertimbangkan `clang-tidy` lewat `compile_commands.json`.

**Terminologi.** Linter; formatter; language server; peringatan vs galat; unqualified access.

**Daftar isi.** 12.2.1 `qmllint` dan kategori peringatan · 12.2.2 Peringatan paling sering (akses tanpa kualifikasi, import tak terpakai, tipe tak dikenal) · 12.2.3 `qmlformat` · 12.2.4 `qmlls` di editor · 12.2.5 Analisis statis C++ · 12.2.6 Mengintegrasikan ke build dan hook git

**Kesalahan umum.** Memadamkan peringatan dengan menyembunyikannya, bukan memperbaikinya; tidak memperbaiki import sehingga alat tak mengenali tipe.

**Latihan 15 menit.** Jalankan `all_qmllint` pada proyek latihan dan perbaiki tiga peringatan teratas.

**Cek pemahaman.** Mengapa akses tanpa kualifikasi dipermasalahkan oleh `qmllint`?

**Referensi.** [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html) · [qmlls](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html)

### Modul 12.3 — Qt Quick Test

**Deskripsi.** Menguji komponen QML dengan `TestCase`, `compare`, `verify`, `tryCompare`, simulasi input, dan `SignalSpy`.

**Konsep & analogi.** Uji otomatis adalah jaring pengaman akrobat: Anda boleh bereksperimen berani karena ada yang menangkap bila jatuh.

**Contoh minimal.** `tst_math.qml`:

```qml
import QtQuick
import QtTest

TestCase {
    name: 'Matematika'

    function test_tambah() { compare(2 + 2, 4) }
    function test_panjang() { verify('qml'.length === 3, 'panjang harus 3') }
}
```

Jalankan cepat dengan `qmltestrunner -input tst_math.qml` (periksa nama executable di sistem Anda). Untuk proyek, buat executable uji dengan:

```cpp
#include <QtQuickTest>
QUICK_TEST_MAIN(contoh)
```

dan daftarkan lewat `add_test` di CMake dengan tautan ke `Qt6::QuickTest`.

**Terminologi.** `TestCase`; `compare`/`verify`/`tryCompare`; `SignalSpy`; `mouseClick`/`keyClick`; `QUICK_TEST_MAIN`; `ctest`.

**Daftar isi.** 12.3.1 `TestCase` dan penamaan fungsi `test_` · 12.3.2 Assertion · 12.3.3 `tryCompare` dan sifat asinkron · 12.3.4 Simulasi input · 12.3.5 `SignalSpy` · 12.3.6 `QUICK_TEST_MAIN` dan `ctest`

**Kesalahan umum.** Tes yang bergantung pada waktu (pakai `tryCompare`); tes yang berbagi keadaan; tidak membuat objek sementara untuk tiap tes.

**Latihan 15 menit.** Tulis uji untuk `AppButton` (Modul 5.1) yang memeriksa bahwa signal `clicked` dipancarkan saat tap disimulasikan.

**Cek pemahaman.** Kapan memakai `tryCompare` alih-alih `compare`?

**Referensi.** [Qt Quick Test](https://doc.qt.io/qt-6/qtquicktest-index.html) · [CTest](https://cmake.org/cmake/help/latest/manual/ctest.1.html)

### Modul 12.4 — Strategi Pengujian dan Kualitas

**Deskripsi.** Menyusun lapisan uji dan proses yang menjaga kualitas dari waktu ke waktu.

**Konsep & analogi.** Piramida uji: banyak uji kecil yang cepat di dasar (unit), sedikit uji menyeluruh yang lambat di puncak (antarmuka). Terbalik berarti lambat dan rapuh.

**Contoh minimal.** Jalankan seluruh uji tanpa jendela (headless):

```
QT_QPA_PLATFORM=offscreen ctest --test-dir build --output-on-failure
```

| Lapisan | Contoh | Alat |
| --- | --- | --- |
| Unit | Logika C++, fungsi JavaScript murni | Qt Test, `qmltestrunner` |
| Komponen | Satu komponen QML dengan input simulasi | Qt Quick Test |
| Integrasi | Backend + UI bersama | Qt Quick Test, uji end-to-end terskrip |
| Manual terarah | Aksesibilitas, tampilan lintas platform | Daftar periksa, Orca |

**Terminologi.** Piramida uji; mock; flaky test; headless; cakupan (coverage); CI.

**Daftar isi.** 12.4.1 Piramida uji · 12.4.2 Mock dan data uji · 12.4.3 Uji headless dengan `offscreen` · 12.4.4 Menangani tes yang tidak stabil · 12.4.5 Cakupan kode · 12.4.6 Review kode dan definisi selesai

**Kesalahan umum.** Hanya uji manual; tes yang bergantung pada urutan eksekusi; mengejar angka cakupan alih-alih perilaku penting.

**Latihan 15 menit.** Jalankan seluruh uji dengan `offscreen` dan catat berapa lama waktunya; tandai satu uji yang paling lambat.

**Cek pemahaman.** Mengapa uji antarmuka sebaiknya sedikit dibanding uji unit?

**Referensi.** [Qt Test](https://doc.qt.io/qt-6/qtest-overview.html) · [Qt Quick Test](https://doc.qt.io/qt-6/qtquicktest-index.html)

## [Fase 13 — Keamanan, Integrasi, dan Deployment][13]

*Tujuan: membuat aplikasi aman, terintegrasi dengan sistem, dan dapat didistribusikan. Estimasi: 3–4 minggu.*

### Modul 13.1 — Keamanan Aplikasi Qt/QML

**Deskripsi.** Memodelkan ancaman dan menutup celah yang khas di aplikasi Qt/QML.

**Konsep & analogi.** Keamanan adalah mengunci pintu yang benar-benar dipakai penyusup, bukan semua pintu secara merata. Mulailah dengan bertanya: apa yang berharga, siapa yang menginginkannya, dan lewat mana mereka bisa masuk?

**Contoh minimal.** Membatasi `Loader` agar hanya memuat dari resource internal:

```qml
import QtQuick

Loader {
    function muat(u: url) {
        if (!u.toString().startsWith('qrc:/')) {
            console.warn('ditolak:', u)
            return
        }
        source = u
    }
}
```

| Risiko | Mitigasi |
| --- | --- |
| Eksekusi kode dari string tak tepercaya (`Qt.createQmlObject`, `eval`, `Loader` dengan URL pengguna) | Jangan pernah mengeksekusi input mentah; whitelist sumber |
| Infrastruktur debug QML aktif di rilis | Hanya aktifkan di build pengembangan |
| Pembacaan file lokal lewat XHR | Biarkan `QML_XHR_ALLOW_FILE_READ` mati kecuali benar-benar perlu |
| Injeksi lewat `QML_IMPORT_PATH`, `QT_PLUGIN_PATH` | Jangan percaya environment dari proses yang tidak tepercaya; kunci jalur plugin pada aplikasi istimewa |
| Eksekusi perintah dari input pengguna | `QProcess` dengan daftar argumen, bukan string shell |
| Rahasia di kode atau konfigurasi | Simpan di keyring sistem; jangan commit ke git |
| Lalu lintas jaringan | TLS dengan verifikasi sertifikat aktif; jangan pernah mematikan verifikasi |
| Aplikasi berhak besar | Prinsip hak minimum, isolasi (bubblewrap, firejail, Flatpak) |
| Isolasi tampilan | Wayland memisahkan klien dengan lebih baik daripada X11, tempat klien dapat memantau input klien lain |

**Terminologi.** Threat model; trust boundary; least privilege; injeksi; sandbox; supply chain.

**Daftar isi.** 13.1.1 Threat modeling sederhana · 13.1.2 Input tak tepercaya dan eksekusi kode · 13.1.3 Debug, XHR, dan jalur import · 13.1.4 Jaringan dan TLS · 13.1.5 Rahasia dan penyimpanan · 13.1.6 Isolasi dan sandbox · 13.1.7 Rantai pasok dependensi

**Kesalahan umum.** Menganggap aplikasi desktop lokal tidak perlu validasi input; membiarkan opsi debug; mematikan verifikasi TLS demi kemudahan pengujian.

**Latihan 15 menit.** Gambar threat model satu halaman untuk proyek latihan Anda: aset, aktor, batas kepercayaan, tiga ancaman teratas, dan mitigasinya.

**Cek pemahaman.** Mengapa `Qt.createQmlObject` dengan string dari pengguna berbahaya?

**Referensi.** [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling) · [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/) · [Arch Wiki: Security](https://wiki.archlinux.org/title/Security) · [Arch Wiki: Bubblewrap](https://wiki.archlinux.org/title/Bubblewrap) · [Qt Network](https://doc.qt.io/qt-6/qtnetwork-index.html)

### Modul 13.2 — Integrasi Platform Desktop Linux

**Deskripsi.** Terintegrasi dengan lingkungan desktop: notifikasi, ikon tray, entri aplikasi, portal, layanan systemd, dan direktori XDG.

**Konsep & analogi.** Aplikasi yang baik adalah tetangga yang baik: ia memakai fasilitas bersama (D-Bus, XDG, portal) alih-alih membangun sendiri di halaman orang.

| Kebutuhan | Pendekatan |
| --- | --- |
| Notifikasi | D-Bus `org.freedesktop.Notifications` (Modul 10.6) |
| Ikon tray | StatusNotifierItem lewat D-Bus |
| Entri menu aplikasi | Berkas `.desktop` dan ikon |
| Akses file dengan izin | xdg-desktop-portal |
| Layanan latar | systemd user service |
| Lokasi data | `QStandardPaths` (direktori XDG) |
| Konfigurasi | `QSettings` atau berkas terstruktur (JSON, TOML) atau SQLite |
| Shell/panel Wayland | Toolkit berbasis QML seperti Quickshell (bahas di dokumen Quickshell) |

**Contoh minimal.** `hello.desktop`:

```
[Desktop Entry]
Type=Application
Name=Hello Qt
Exec=hello
Icon=hello
Categories=Utility;
```

**Terminologi.** XDG; `.desktop`; portal; StatusNotifierItem; unit systemd; layer-shell.

**Daftar isi.** 13.2.1 Direktori XDG dan `QStandardPaths` · 13.2.2 Berkas `.desktop` dan ikon · 13.2.3 Notifikasi dan tray lewat D-Bus · 13.2.4 Portal · 13.2.5 Layanan systemd user · 13.2.6 Perbedaan Wayland dan X11 untuk aplikasi

**Kesalahan umum.** Menulis file ke `$HOME` langsung alih-alih direktori XDG; mengandalkan fitur X11 (mis. posisi jendela mutlak) di Wayland.

**Latihan 15 menit.** Pasang `hello.desktop` di `~/.local/share/applications` dan pastikan aplikasi muncul di peluncur Anda.

**Cek pemahaman.** Apa fungsi portal bagi aplikasi yang disandbox?

**Referensi.** [Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/latest/) · [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/) · [Arch Wiki: Qt](https://wiki.archlinux.org/title/Qt) · [Quickshell](https://quickshell.org/)

### Modul 13.3 — Packaging dan Deployment

**Deskripsi.** Mengemas aplikasi menjadi paket yang bisa dipasang: paket distro (PKGBUILD), AppImage, Flatpak, dan skrip deploy Qt.

**Konsep & analogi.** Packaging adalah memasukkan masakan ke kotak antar lengkap dengan petunjuk: pelanggan tidak perlu tahu cara memasak.

**Contoh minimal.** Aturan instalasi CMake (tambahkan ke `CMakeLists.txt`):

```cmake
install(TARGETS hello RUNTIME DESTINATION bin)
install(FILES hello.desktop DESTINATION share/applications)
```

`PKGBUILD` minimal untuk Arch (ganti `source` dan checksum dengan nilai nyata):

```
pkgname=hello-qt
pkgver=0.1.0
pkgrel=1
pkgdesc='Aplikasi contoh Qt Quick'
arch=('x86_64')
license=('MIT')
depends=('qt6-base' 'qt6-declarative')
makedepends=('cmake' 'ninja')
source=("$pkgname-$pkgver.tar.gz")
sha256sums=('SKIP')

build() {
  cmake -S "$pkgname-$pkgver" -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
  cmake --build build
}

package() {
  DESTDIR="$pkgdir" cmake --install build
}
```

Untuk platform tanpa manajer paket sistem, `qt_generate_deploy_qml_app_script` `[≥6.3]` membuat skrip yang mengumpulkan dependensi Qt. Di Linux, pilihan lain adalah AppImage atau Flatpak dengan runtime KDE.

**Terminologi.** `PKGBUILD`; `makepkg`; AppImage; Flatpak; runtime; skrip deploy; build reprodusibel.

**Daftar isi.** 13.3.1 Aturan `install` CMake · 13.3.2 `PKGBUILD` dan `makepkg` · 13.3.3 Skrip deploy Qt · 13.3.4 AppImage · 13.3.5 Flatpak · 13.3.6 Pembuatan build rilis dan pengujian paket

**Kesalahan umum.** Checksum `SKIP` untuk rilis publik; lupa dependensi runtime di `depends`; tidak menguji paket di lingkungan bersih.

**Latihan 15 menit.** Bangun paket dengan `makepkg` dari sumber lokal, pasang, dan jalankan dari peluncur.

**Cek pemahaman.** Mengapa paket harus diuji di lingkungan bersih?

**Referensi.** [Arch Wiki: Creating packages](https://wiki.archlinux.org/title/Creating_packages) · [Arch Wiki: PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) · [qt\_generate\_deploy\_qml\_app\_script](https://doc.qt.io/qt-6/qt-generate-deploy-qml-app-script.html) · [Flatpak docs](https://docs.flatpak.org/) · [AppImage docs](https://docs.appimage.org/)

### Modul 13.4 — Rekayasa Perangkat Lunak

**Deskripsi.** Praktik yang menjaga proyek tetap sehat: versi, git, logging, dokumentasi, dan rilis.

**Konsep & analogi.** Kode adalah taman: tanpa perawatan rutin ia menjadi hutan. Praktik rekayasa adalah jadwal perawatan.

**Contoh minimal.** Logging terkategori di C++:

```cpp
#include <QLoggingCategory>
Q_LOGGING_CATEGORY(lcBackend, "app.backend")

void mulai() { qCInfo(lcBackend) << "dimulai"; }
```

Aktifkan hanya kategori yang diperlukan: `QT_LOGGING_RULES='app.backend.debug=true'`.

**Terminologi.** Semantic versioning; branch; code review; changelog; ADR (catatan keputusan arsitektur); kategori logging; CI.

**Daftar isi.** 13.4.1 Versi semantik · 13.4.2 Alur git dan commit yang bersih · 13.4.3 Logging terkategori · 13.4.4 Dokumentasi dan ADR · 13.4.5 CI sederhana · 13.4.6 Proses rilis dan changelog · 13.4.7 Kebijakan dependensi

**Kesalahan umum.** Commit besar tanpa pesan jelas; log tak terkategori sehingga tak bisa disaring; tidak mencatat alasan keputusan arsitektur.

**Latihan 15 menit.** Tulis satu ADR (konteks, keputusan, konsekuensi) untuk pilihan arsitektur di proyek latihan Anda.

**Cek pemahaman.** Apa manfaat kategori logging dibanding `qDebug` biasa?

**Referensi.** [Semantic Versioning](https://semver.org/) · [Pro Git](https://git-scm.com/book/en/v2) · [Qt Logging](https://doc.qt.io/qt-6/qloggingcategory.html)

## [Fase 14 — Mastery][14]

*Tujuan: mampu memperluas Qt itu sendiri dan menambahkan fitur pada proyek apa pun, termasuk yang bukan buatan Anda. Estimasi: 3–6 minggu, bersifat iteratif.*

### Modul 14.1 — Tipe Kustom Tingkat Lanjut

**Deskripsi.** Value type, attached type, extended type, foreign type, enum, `QQmlParserStatus`, `QQmlListProperty`, dan properti bindable Qt 6.

**Konsep & analogi.** Tipe kustom adalah kosakata baru yang Anda tambahkan ke bahasa QML. Properti bindable seperti sel spreadsheet di sisi C++: ia ikut dalam sistem binding, tidak hanya memancarkan signal.

**Contoh minimal.** Properti bindable:

```cpp
#include <QObject>
#include <QProperty>
#include <QBindable>
#include <QtQml/qqmlregistration.h>

class Penghitung : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int nilai READ nilai WRITE setNilai NOTIFY nilaiChanged BINDABLE bindableNilai)

public:
    int nilai() const { return m_nilai; }
    void setNilai(int v) { m_nilai = v; }
    QBindable<int> bindableNilai() { return &m_nilai; }

signals:
    void nilaiChanged();

private:
    Q_OBJECT_BINDABLE_PROPERTY(Penghitung, int, m_nilai, &Penghitung::nilaiChanged)
};
```

Value type sederhana: struct dengan `Q_GADGET`, `QML_VALUE_TYPE(titik)` (nama diawali huruf kecil), dan `Q_PROPERTY(double x MEMBER x)`.

**Terminologi.** Value type (`Q_GADGET`); attached type (`QML_ATTACHED`); extended type (`QML_EXTENDED`); foreign type (`QML_FOREIGN`); `Q_ENUM`; `QQmlListProperty`; bindable property.

**Daftar isi.** 14.1.1 Value type dengan `Q_GADGET` · 14.1.2 Enum di QML (`Q_ENUM`) · 14.1.3 Attached type · 14.1.4 Extended dan foreign type · 14.1.5 `QQmlListProperty` · 14.1.6 `QQmlParserStatus` · 14.1.7 Properti bindable (`QProperty`)

**Kesalahan umum.** Nama value type berawalan huruf besar; lupa `NOTIFY` atau `BINDABLE` sehingga binding tak terpicu; menyalahgunakan `QML_FOREIGN` untuk kelas yang sebenarnya bisa diubah.

**Latihan 15 menit.** Tambahkan `Penghitung` ke modul Anda dan ikat nilainya ke `Text` di QML.

**Cek pemahaman.** Apa kelebihan `QProperty` dibanding properti biasa dengan `emit` manual?

**Referensi.** [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) · [Qt Bindable Properties](https://doc.qt.io/qt-6/bindableproperties.html)

### Modul 14.2 — QQuickItem Kustom dan Scene Graph

**Deskripsi.** Membuat item visual sendiri di C++: dari `QQuickPaintedItem` yang sederhana sampai `updatePaintNode` dengan node scene graph.

**Konsep & analogi.** `QQuickPaintedItem` adalah melukis dengan kuas di kanvas lalu menempelkan kanvas itu ke panggung: mudah, tetapi lebih berat. `updatePaintNode` adalah menyusun properti panggung langsung: lebih rumit, tetapi paling efisien.

**Contoh minimal.**

```cpp
#include <QQuickPaintedItem>
#include <QPainter>
#include <QtQml/qqmlregistration.h>

class Lingkaran : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit Lingkaran(QQuickItem *parent = nullptr) : QQuickPaintedItem(parent) {}

    void paint(QPainter *painter) override
    {
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setBrush(QColor(70, 130, 180));
        painter->drawEllipse(boundingRect());
    }
};
```

Tautkan `Qt6::Quick`. Di QML: `Lingkaran { width: 100; height: 100 }`.

**Terminologi.** `QQuickItem`; `QQuickPaintedItem`; `updatePaintNode`; `QSGNode`; `ItemHasContents`; `update()`; thread render.

**Daftar isi.** 14.2.1 Subclass `QQuickItem` · 14.2.2 `QQuickPaintedItem` dan batasannya · 14.2.3 `updatePaintNode` dan node (`QSGGeometryNode`, material) · 14.2.4 Properti dan `update()` · 14.2.5 Aturan thread render · 14.2.6 Input pada item kustom

**Kesalahan umum.** Mengakses objek GUI dari `updatePaintNode` selain di fase sinkronisasi; lupa `setFlag(ItemHasContents)` pada item berbasis node; memakai `QQuickPaintedItem` untuk gambar besar yang sering diperbarui.

**Latihan 15 menit.** Tambahkan properti `warna` ke `Lingkaran` dengan `NOTIFY` dan panggil `update()` saat berubah.

**Cek pemahaman.** Mengapa `QQuickPaintedItem` lebih lambat daripada node scene graph?

**Referensi.** [QQuickItem](https://doc.qt.io/qt-6/qquickitem.html) · [QQuickPaintedItem](https://doc.qt.io/qt-6/qquickpainteditem.html) · [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html)

### Modul 14.3 — Plugin dan Arsitektur Modular

**Deskripsi.** Plugin modul QML dan plugin C++ aplikasi: antarmuka, pemuatan, versi, dan risiko keamanannya.

**Konsep & analogi.** Plugin adalah stopkontak tambahan di dinding aplikasi: siapa pun yang mencolokkan perangkat harus mengikuti bentuk stopkontaknya. Perangkat yang dicolok bisa menjalankan kode apa saja di rumah Anda, jadi percayai hanya yang Anda kenal.

**Contoh minimal.** Antarmuka plugin C++:

```cpp
#include <QString>
#include <QtPlugin>

class IModul
{
public:
    virtual ~IModul() = default;
    virtual QString nama() const = 0;
};

Q_DECLARE_INTERFACE(IModul, "id.contoh.IModul/1.0")
```

Plugin mengimplementasikan antarmuka itu dan menandai dirinya dengan `Q_PLUGIN_METADATA(IID "id.contoh.IModul/1.0")`; aplikasi memuatnya dengan `QPluginLoader`.

**Terminologi.** Plugin; `QPluginLoader`; `Q_DECLARE_INTERFACE`; IID; plugin modul QML; ABI.

**Daftar isi.** 14.3.1 Plugin modul QML (dinamis vs statis) · 14.3.2 Antarmuka plugin C++ · 14.3.3 `QPluginLoader` · 14.3.4 Versi API dan kompatibilitas · 14.3.5 Keamanan plugin (kode tak tepercaya) · 14.3.6 Kapan tidak memakai plugin

**Kesalahan umum.** Memuat plugin dari direktori yang bisa ditulis pengguna lain; mengubah antarmuka tanpa menaikkan versi; plugin untuk hal yang cukup dengan modul statis.

**Latihan 15 menit.** Rancang (di atas kertas) antarmuka plugin untuk fitur ekspor di proyek Anda dan tentukan aturan versinya.

**Cek pemahaman.** Mengapa direktori plugin harus dilindungi dari penulisan oleh pihak lain?

**Referensi.** [How to Create Qt Plugins](https://doc.qt.io/qt-6/plugins-howto.html) · [QPluginLoader](https://doc.qt.io/qt-6/qpluginloader.html)

### Modul 14.4 — Membangun Pustaka UI dan Design System

**Deskripsi.** Mengemas komponen menjadi pustaka yang bisa dipakai banyak aplikasi: API stabil, tema, dokumentasi, tes, dan versi.

**Konsep & analogi.** Pustaka UI adalah toko perabot dengan katalog: pembeli (pengembang lain) memilih dari katalog, tidak membongkar pabrik. Katalog yang berubah-ubah merugikan semua pembeli.

| Aspek | Praktik |
| --- | --- |
| API | Properti masuk, signal keluar, `required property` untuk yang wajib |
| Tema | Token di singleton (Modul 5.3), tidak ada nilai mentah di komponen |
| Aksesibilitas | Navigasi keyboard dan `Accessible` sebagai syarat dasar komponen |
| Tes | Satu berkas Qt Quick Test per komponen |
| Dokumentasi | Satu halaman per komponen: tujuan, properti, contoh |
| Versi | Semantic versioning dan changelog |

**Terminologi.** Design system; design token; API stabil; breaking change; galeri contoh.

**Daftar isi.** 14.4.1 Prinsip desain API · 14.4.2 Modul pustaka dan token · 14.4.3 Aksesibilitas bawaan · 14.4.4 Tes per komponen · 14.4.5 Dokumentasi dan galeri contoh · 14.4.6 Versi dan pensiun fitur

**Kesalahan umum.** Komponen yang bergantung pada struktur aplikasi tertentu; perubahan API tanpa peringatan; tidak ada contoh sehingga pemakai menebak.

**Latihan 15 menit.** Pilih tiga komponen dari proyek latihan, tulis halaman dokumentasi singkat untuk masing-masing, dan perbaiki API yang terasa janggal.

**Cek pemahaman.** Apa yang dimaksud breaking change pada komponen UI?

**Referensi.** [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [Semantic Versioning](https://semver.org/)

### Modul 14.5 — Membaca dan Belajar dari Source Qt

**Deskripsi.** Menelusuri implementasi Qt untuk memahami perilaku yang tak terjelaskan dokumentasi, dan berkontribusi balik.

**Konsep & analogi.** Dokumentasi adalah peta; source code adalah medan sebenarnya. Pada saat peta kurang jelas, medanlah yang menjawab.

**Contoh minimal.**

```
git clone https://code.qt.io/qt/qtdeclarative.git
cd qtdeclarative
ls src                       # qml, quick, quickcontrols, ...
rg -n 'class QQuickRectangle' src/quick
```

Pola membaca: mulai dari halaman dokumentasi tipe, buka headernya, lalu berkas `.cpp`; baca juga uji di `tests/auto` untuk melihat perilaku yang dijamin.

**Terminologi.** Repository; `qtdeclarative`; header publik vs privat (`_p.h`); uji otomatis; Gerrit; laporan bug.

**Daftar isi.** 14.5.1 Peta repository Qt · 14.5.2 Alat bantu (ripgrep, clangd) · 14.5.3 Dari dokumentasi ke implementasi · 14.5.4 Membaca uji sebagai spesifikasi · 14.5.5 Melaporkan bug yang baik (reproduksi minimal) · 14.5.6 Panduan kontribusi

**Kesalahan umum.** Mengandalkan detail implementasi yang tidak dijamin; memakai header privat di aplikasi; melaporkan bug tanpa contoh minimal.

**Latihan 15 menit.** Telusuri bagaimana `Rectangle` diimplementasikan dan tulis catatan satu paragraf tentang jalur dari properti `color` sampai node scene graph.

**Cek pemahaman.** Mengapa melaporkan bug dengan contoh minimal mempercepat perbaikannya?

**Referensi.** [qtdeclarative di GitHub](https://github.com/qt/qtdeclarative) · [Qt Bug Tracker](https://bugreports.qt.io/) · [Qt Forum](https://forum.qt.io/)

### Modul 14.6 — Menambah Fitur pada Proyek Asing *(baru)*

**Deskripsi.** Metodologi terstruktur untuk menambahkan atau memperbaiki fitur di basis kode QML/Qt yang bukan buatan Anda, tanpa merusak yang sudah ada. Ini modul kunci bagi tujuan “bisa menambah fitur pada proyek apa pun”.

**Konsep & analogi.** Seperti dokter di rumah sakit baru: periksa dulu, jangan langsung operasi. Pahami arsitektur, temukan titik ekstensi, buat prototipe terisolasi, lalu operasi sekecil mungkin dan tinggalkan catatan rapi.

| Langkah | Tindakan | Keluaran |
| --- | --- | --- |
| 1. Pahami tujuan | Tulis satu paragraf: apa yang harus berubah dan kriteria selesai | Kriteria penerimaan |
| 2. Petakan repo | Baca README dan struktur folder; `rg` untuk kata kunci; `qmllint` dan `QML_IMPORT_TRACE=1` untuk melihat modul | Peta singkat arsitektur |
| 3. Temukan titik ekstensi | Cari akar komponen, singleton, model, registrasi C++ terkait | Daftar berkas yang harus disentuh |
| 4. Prototipe terisolasi | Buat satu berkas QML yang menjalankan ide Anda dengan `qml` | Prototipe yang berjalan |
| 5. Implementasi kecil | Ubah seminimal mungkin; ikuti gaya yang ada; satu perubahan logis per commit | Commit bersih |
| 6. Uji | Jalankan uji yang ada, tambah uji baru, jalankan `qmllint` | Uji hijau, tanpa peringatan baru |
| 7. Dokumentasikan | Perbarui dokumen dan changelog; tulis alasan keputusan | Pull request yang bisa ditinjau |

**Contoh minimal (jalur kerja).**

```
git switch -c fitur-salin-tombol
rg -n 'ListView' qml/
QML_IMPORT_TRACE=1 qml prototipe.qml 2>&1 | head -30
git add -p && git commit
```

**Terminologi.** Titik ekstensi; reproduksi minimal; kriteria penerimaan; regresi; diff yang fokus.

**Daftar isi.** 14.6.1 Memahami tujuan dan kriteria selesai · 14.6.2 Memetakan proyek asing · 14.6.3 Menemukan titik ekstensi · 14.6.4 Prototipe terisolasi · 14.6.5 Perubahan kecil dan commit bersih · 14.6.6 Uji dan pencegahan regresi · 14.6.7 Dokumentasi dan tinjauan

**Kesalahan umum.** Memformat ulang seluruh berkas sehingga diff tak terbaca; mengubah arsitektur untuk fitur kecil; tidak menjalankan uji yang sudah ada.

**Latihan 15 menit.** Pilih proyek QML open source kecil, tambahkan satu fitur kecil (mis. tombol salin) mengikuti tujuh langkah di atas, dan tulis deskripsi perubahan satu paragraf.

**Cek pemahaman.** Mengapa prototipe terisolasi dibuat sebelum mengubah proyek asli?

**Referensi.** [Pro Git](https://git-scm.com/book/en/v2) · [Qt Contribution Guidelines](https://wiki.qt.io/Qt_Contribution_Guidelines) · [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html)

### Modul 14.7 — Peta Keputusan Modul Qt *(baru)*

**Deskripsi.** Memilih modul Qt yang tepat untuk kebutuhan di luar Qt Quick inti, dan cara mempelajari modul baru dengan cepat.

**Konsep & analogi.** Qt adalah kota dengan banyak distrik. Anda tidak perlu mengenal semuanya, tetapi harus tahu cara membaca peta dan bertanya arah.

| Kebutuhan | Modul | Catatan |
| --- | --- | --- |
| 3D | Qt Quick 3D | Terintegrasi dengan Qt Quick |
| Grafik dan visualisasi data | Qt Graphs, Qt Charts | Periksa lisensi masing-masing |
| Konten web | Qt WebEngine | Berbasis Chromium; berat |
| Audio dan video | Qt Multimedia | Backend bergantung platform |
| Wayland compositor | Qt Wayland Compositor | Untuk membangun compositor |
| Serial dan Bluetooth | Qt SerialPort, Qt Bluetooth |  |
| Basis data | Qt SQL |  |
| Lokasi dan peta | Qt Positioning, Qt Location |  |

Beberapa modul add-on dilisensikan GPLv3 atau komersial saja. Periksa lisensi modul sebelum memakainya di aplikasi tertutup.

**Protokol mempelajari modul baru (30–60 menit).** (1) Baca halaman overview modul dan daftar tipe QML-nya. (2) Jalankan satu contoh resmi dari terminal. (3) Tulis prototipe satu berkas yang memakai satu fitur. (4) Baca header atau API untuk celah yang tak terjawab. (5) Ukur dampak performa, ukuran binary, dan lisensi sebelum memutuskan.

**Terminologi.** Modul add-on; backend; lisensi (LGPL, GPL, komersial); overview; example.

**Daftar isi.** 14.7.1 Peta modul Qt · 14.7.2 Lisensi dan dampaknya · 14.7.3 Protokol 30–60 menit · 14.7.4 Menilai biaya (ukuran, performa, dependensi) · 14.7.5 Kapan membangun sendiri vs memakai modul

**Kesalahan umum.** Menambahkan modul berat untuk kebutuhan kecil; melewatkan pemeriksaan lisensi; tidak menguji di platform target.

**Latihan 15 menit.** Pilih satu modul yang belum Anda kenal, jalankan satu contoh resminya, dan tulis tiga kalimat tentang kapan Anda akan memakainya.

**Cek pemahaman.** Mengapa lisensi modul perlu diperiksa sebelum dipakai?

**Referensi.** [All Qt Modules](https://doc.qt.io/qt-6/qtmodules.html) · [Lisensi Qt](https://www.qt.io/licensing/)

## Bagian B — Jalur Pendalaman: JavaScript dalam QML

Bagian ini menggantikan dokumen pertama (20 fase berisi daftar kata kunci). Setiap fase kini memiliki konsep, contoh, jebakan, dan latihan. Format ringkas: **Tujuan · Konsep · Contoh · Jebakan · Latihan · Dibaca bersama**. Istilah ada di Glosarium dan di modul padanannya (lihat tabel pemetaan di Bagian 2). Contoh dijalankan dengan `qml Main.qml`. Estimasi total jalur ini: 12–18 minggu paruh waktu, dikerjakan paralel dengan fase utama.

### Fase B0 — Orientasi

**Tujuan.** Memahami peran JavaScript di QML. **Konsep.** QML menyatakan struktur; JavaScript menambahkan perilaku. Di QML ia bukan peramban: tanpa DOM dan tanpa `window`. **Contoh.**

```qml
import QtQuick
Item { Component.onCompleted: console.log(1 + 1) }
```

**Jebakan.** Mencari tutorial peramban dan menyalin API-nya. **Latihan.** Jalankan contoh dan cetak hasil tiga ekspresi berbeda. **Dibaca bersama.** Modul 2.1.

### Fase B1 — Sintaks Dasar

**Tujuan.** Membaca dan menulis pernyataan JavaScript dengan benar. **Konsep.** Pernyataan dan ekspresi, komentar, peka huruf besar-kecil, titik koma opsional (tetapi konsistenlah). **Contoh.**

```js
const nama = 'Qt'   // pernyataan
let n = 2 + 3       // ekspresi di sisi kanan
```

**Jebakan.** Baris yang diawali tanda kurung atau backtick tanpa titik koma bisa tersambung ke baris sebelumnya. **Latihan.** Tulis lima pernyataan dan beri komentar penjelasan. **Dibaca bersama.** Modul 2.1.

### Fase B2 — Tipe Data dan Konversi

**Tujuan.** Memahami tipe primitif dan aturan konversi. **Konsep.** `number` (floating point), `string`, `boolean`, `null`, `undefined`, `Symbol`. `typeof` menyebut tipe. Nilai falsy: `0`, `''`, `false`, `null`, `undefined`, `NaN`. **Contoh.**

```js
console.log(typeof 3, typeof 'a', typeof null, 0.1 + 0.2 === 0.3, 0 == '', 0 === '')
```

**Jebakan.** `==` melakukan konversi diam-diam; selalu pakai `===`. BigInt **\[uji dulu\]**. **Latihan.** Tebak lalu verifikasi hasil contoh. **Dibaca bersama.** Modul 1.2.

### Fase B3 — Operator dan Alur Kontrol

**Tujuan.** Mengendalikan alur program. **Konsep.** Aritmetika (termasuk `**`), logika, ternary, `??`, `?.`, `if`/`switch`, `for`, `for...of`, `while`. **Contoh.**

```js
for (const x of [1, 2, 3]) if (x % 2) console.log(x ** 2)
const alias = pengguna?.profil?.alias ?? 'anonim'
```

**Jebakan.** `for...in` pada array menghasilkan indeks sebagai string; pakai `for...of`. **Latihan.** Tulis FizzBuzz memakai `for...of`. **Dibaca bersama.** Modul 2.1.

### Fase B4 — Fungsi

**Tujuan.** Menulis fungsi yang bersih. **Konsep.** Deklarasi, ekspresi, arrow function, parameter default, rest parameter. Di QML, fungsi pada objek bisa diberi anotasi tipe. **Contoh.**

```qml
Item {
    function jumlah(...angka) { return angka.reduce((a, b) => a + b, 0) }
    function sapa(nama = 'dunia') { return `halo ${nama}` }
}
```

**Jebakan.** Mengandalkan `this` (Modul 2.2). **Latihan.** Tulis fungsi `rata(...angka)` dan uji dengan tiga kasus. **Dibaca bersama.** Modul 2.2.

### Fase B5 — Array

**Tujuan.** Mengolah koleksi data secara fungsional. **Konsep.** `map`, `filter`, `reduce`, `find`, `some`, `every`, `includes`, spread array. Mengubah isi array di tempat tidak memicu binding. **Contoh.**

```js
const harga = [15000, 8000, 12000]
const mahal = harga.filter(h => h > 10000).map(h => h * 1.1)
let daftar = [1, 2]; daftar = [...daftar, 3]   // reassign agar binding terpicu
```

**Jebakan.** `sort()` tanpa pembanding mengurutkan sebagai string; `flat`/`flatMap` **\[uji dulu\]**. **Latihan.** Urutkan angka menurun dengan pembanding. **Dibaca bersama.** Modul 3.1.

### Fase B6 — Objek dan JSON

**Tujuan.** Memodelkan data dengan objek. **Konsep.** Literal, shorthand, kunci terhitung, `Object.keys/values/entries/assign`, destructuring, `JSON.parse/stringify`. **Contoh.**

```js
const p = { nama: 'Kopi', harga: 15000 }
const { nama, ...sisa } = p            // rest pada destructuring
console.log(JSON.stringify(p), Object.entries(p))
```

**Jebakan.** Object spread `{...a}` **\[uji dulu\]**; `JSON.parse` melempar galat pada JSON rusak. **Latihan.** Parse JSON dengan `try/catch` dan tangani galat. **Dibaca bersama.** Modul 2.1 dan 7.4.

### Fase B7 — String dan Template Literal

**Tujuan.** Mengolah teks dan menyusun pesan. **Konsep.** `slice`, `split`, `replace`, `startsWith`, `includes`, `padStart`, template literal, dan `qsTr('Halo %1').arg(nama)` untuk teks yang diterjemahkan. **Contoh.**

```js
const pesan = qsTr('Halo %1, ada %2 pesan').arg('Jon').arg(3)
```

**Jebakan.** Menyusun kalimat dengan `+` membuat terjemahan mustahil. **Latihan.** Format tabel harga rata kanan dengan `padStart`. **Dibaca bersama.** Modul 9.4.

### Fase B8 — Scope dan Closure

**Tujuan.** Memahami umur dan jangkauan variabel. **Konsep.** `let`/`const` berlingkup blok; `var` berlingkup fungsi; hoisting; temporal dead zone; closure adalah fungsi yang membawa variabel lingkungannya. **Contoh.**

```js
function buatPenghitung() { let n = 0; return () => ++n }
const a = buatPenghitung(); a(); console.log(a())   // 2
```

**Jebakan.** Closure di handler yang menahan objek besar sehingga tak pernah dibebaskan. **Latihan.** Buat dua penghitung independen dan buktikan keadaannya tak saling memengaruhi. **Dibaca bersama.** Modul 3.4.

### Fase B9 — JavaScript di Dalam Dokumen QML

**Tujuan.** Menempatkan JavaScript pada tempat yang tepat. **Konsep.** Ekspresi binding, signal handler, fungsi pada objek; aturan `this`; `Component.onCompleted`. **Contoh.**

```qml
Rectangle {
    id: root
    property int n: 0
    color: n > 2 ? 'tomato' : 'steelblue'
    TapHandler { onTapped: root.n++ }
}
```

**Jebakan.** Assignment memutus binding. **Latihan.** Ubah contoh agar warna berubah setiap tiga ketukan. **Dibaca bersama.** Modul 2.2.

### Fase B10 — Global Object dan API Bawaan

**Tujuan.** Mengenal perkakas yang sudah tersedia. **Konsep.** Objek global `Qt` (`Qt.callLater`, `Qt.binding`, `Qt.rgba`, `Qt.resolvedUrl`, `Qt.formatDateTime`, `Qt.quit`), `console`, `Math`, `Date`, `JSON`, `RegExp`, `Map`, `Set`. Tidak ada DOM. **Contoh.**

```js
console.log(Qt.formatDateTime(new Date(), 'yyyy-MM-dd HH:mm'))
Qt.callLater(() => console.log('nanti'))
```

**Jebakan.** Bulan `Date` bernomor 0–11; format tanggal dipengaruhi locale. **Latihan.** Cetak tanggal hari ini dalam tiga format berbeda. **Dibaca bersama.** Modul 2.4.

### Fase B11 — JavaScript dan Reaktivitas

**Tujuan.** Memahami bagaimana JavaScript ikut dalam sistem binding. **Konsep.** Fungsi yang dipanggil dari sebuah binding juga mencatat dependensi: setiap properti yang dibaca selama evaluasi dianggap dependensi. **Contoh.**

```qml
Item {
    property int a: 1
    property int b: 2
    function jumlah() { return a + b }
    property int hasil: jumlah()      // bergantung pada a dan b
}
```

**Jebakan.** Efek samping (assignment) di dalam binding; dependensi yang berubah dinamis karena cabang kondisi. **Latihan.** Ubah `a` dari handler dan amati `hasil`. **Dibaca bersama.** Modul 3.1.

### Fase B12 — JavaScript dan Signal

**Tujuan.** Menangani dan memancarkan signal dari JavaScript. **Konsep.** Handler dengan parameter eksplisit, `connect`/`disconnect`, memanggil signal seperti fungsi, dan sifat reentrant-nya. **Contoh.**

```qml
Item {
    id: root
    signal hitung(int n)
    onHitung: (n) => { if (n < 3) hitung(n + 1); console.log(n) }
    Component.onCompleted: hitung(0)
}
```

**Jebakan.** Rekursi tak terbatas antar-handler. **Latihan.** Prediksi urutan keluaran contoh (jawabannya 3, 2, 1, 0) lalu verifikasi dan jelaskan alasannya. **Dibaca bersama.** Modul 3.2.

### Fase B13 — Modul dan Resource JavaScript

**Tujuan.** Memecah logika ke berkas `.js`. **Konsep.** `.pragma library` untuk pustaka bersama, `import 'x.js' as X` dari QML, dan `.import` di dalam berkas `.js`. Berkas `.mjs` memakai sintaks ES module (`export`/`import`) **\[uji dulu\]** pada versi Qt Anda. **Contoh.**

```js
// util.mjs
export function kuadrat(x) { return x * x }
// pemakai.mjs
import { kuadrat } from './util.mjs'
```

**Jebakan.** Mengira `.pragma library` dapat mengakses `id` QML; lupa mendaftarkan berkas di CMake. **Latihan.** Pecah fungsi bantu dari satu proyek ke `Logic.js`. **Dibaca bersama.** Modul 2.3.

### Fase B14 — Tipe Data dan Konversi QML ↔ JavaScript

**Tujuan.** Menghindari kejutan tipe antar dua dunia. **Konsep.** `int`/`real` ↔ number; `string` ↔ string; `bool` ↔ boolean; `url` dan `color` perlu `toString()` untuk teks; `point`, `rect`, `size` adalah value type; `var` yang berisi objek menyimpan referensi. **Contoh.**

```qml
Item {
    property point p: Qt.point(1, 2)
    Component.onCompleted: {
        let q = p
        q.x = 99
        console.log(p.x, q.x)    // dugaan: 1 99 (value type disalin). Buktikan di versi Qt Anda.
    }
}
```

**Jebakan.** Array-like dari C++ tidak lolos `Array.isArray()`; QDate dan Date berbasis UTC; bulan 0–11 vs 1–12. **Latihan.** Buat tabel tipe QML dan wujudnya di JavaScript berdasarkan percobaan Anda sendiri. **Dibaca bersama.** Modul 1.2 dan 10.4.

### Fase B15 — Pemrograman Asinkron

**Tujuan.** Menangani pekerjaan yang selesai kelak tanpa membekukan UI. **Konsep.** Event loop, callback, `Timer`, XHR, `Promise` (tercantum di daftar objek resmi), `WorkerScript`. `async/await` **\[uji dulu\]**. **Contoh.**

```qml
Item {
    function ambil(url) {
        return new Promise((resolve, reject) => {
            const r = new XMLHttpRequest()
            r.onreadystatechange = () => {
                if (r.readyState !== XMLHttpRequest.DONE) return
                if (r.status === 200) resolve(r.responseText)
                else reject(new Error('HTTP ' + r.status))
            }
            r.open('GET', url)
            r.send()
        })
    }

    Component.onCompleted: ambil('https://example.com/data.json')
        .then(JSON.parse)
        .then(console.log)
        .catch(e => console.warn(e))
}
```

**Jebakan.** Lupa menangani galat; pekerjaan berat di thread UI. **Latihan.** Tambahkan batas waktu dengan `Timer` yang menolak janji bila terlalu lama. **Dibaca bersama.** Modul 7.4.

### Fase B16 — JavaScript dan C++

**Tujuan.** Menjembatani JavaScript dan C++ dengan aman. **Konsep.** Konversi tipe lewat `QVariant`; callback JavaScript diterima C++ sebagai `QJSValue`; `QJSEngine` dipakai bila Anda menanamkan mesin skrip tanpa QML. **Contoh.**

```cpp
Q_INVOKABLE void ambilData(const QJSValue &callback)
{
    if (!callback.isCallable()) return;
    QJSValue cb = callback;                       // salinan agar bisa dipanggil
    cb.call({ QJSValue(QStringLiteral("selesai")) });
}
```

**Jebakan.** Memanggil callback setelah objek pemiliknya dihancurkan; memanggil dari thread selain thread engine. **Latihan.** Panggil callback itu dari QML dengan fungsi anonim dan cetak hasilnya. **Dibaca bersama.** Modul 10.4.

### Fase B17 — Lifecycle dan Memori

**Tujuan.** Menghindari kebocoran dan akses ke objek yang sudah hilang. **Konsep.** Objek JavaScript dibersihkan garbage collector. Objek `QObject` punya kepemilikan: dimiliki C++ atau dimiliki JavaScript (`QQmlEngine::ObjectOwnership`); objek hasil `createObject(parent)` dimiliki `parent`. Closure dan koneksi yang tersisa dapat menahan objek. **Contoh.**

```qml
Item {
    Component.onCompleted: {
        for (let i = 0; i < 1000; i++) { const o = {}; o.self = o }   // siklus objek JS aman
        gc()                                                          // hanya untuk eksperimen
    }
}
```

**Jebakan.** Handler yang menahan objek besar; `destroy()` tanpa memutus rujukan. **Latihan.** Buat dan hancurkan 1000 objek dinamis, lalu pantau memori sebelum dan sesudah. **Dibaca bersama.** Modul 3.3 dan 7.3.

### Fase B18 — Debug dan Optimasi JavaScript

**Tujuan.** Menemukan dan memperbaiki JavaScript yang lambat atau salah. **Konsep.** Ukur dengan `console.time` dan profiler, hindari binding berat, memoisasi, gabungkan pembaruan dengan `Qt.callLater`, beri anotasi tipe, dan pindahkan pekerjaan berat ke `WorkerScript` atau C++. **Contoh.**

```js
const cache = new Map()
function mahal(n) {
    if (!cache.has(n)) cache.set(n, hitung(n))
    return cache.get(n)
}
```

**Jebakan.** Optimasi dini tanpa pengukuran; cache yang tidak pernah dibersihkan. **Latihan.** Ukur sebuah fungsi dengan dan tanpa cache memakai `console.time`. **Dibaca bersama.** Modul 12.1, 12.2, dan 11.4.

### Fase B19 — Arsitektur Logika

**Tujuan.** Menempatkan logika di tempat yang dapat diuji dan dirawat. **Konsep.** Fungsi murni di `Logic.js` (`.pragma library`), keadaan di store, I/O di tepi, dan uji dengan Qt Quick Test. **Contoh.**

```js
// Logic.js
.pragma library
function totalKeranjang(item) {
    return item.reduce((jml, i) => jml + i.harga * i.jumlah, 0)
}
```

```qml
// tst_logic.qml
import QtQuick
import QtTest
import 'Logic.js' as Logic

TestCase {
    name: 'Logic'
    function test_total() { compare(Logic.totalKeranjang([{ harga: 10, jumlah: 2 }]), 20) }
}
```

**Jebakan.** Logika tersebar di delegate dan handler; fungsi dengan efek samping tersembunyi. **Latihan.** Ekstrak tiga fungsi murni dari proyek Anda dan tulis uji untuk masing-masing. **Dibaca bersama.** Modul 8.2 dan 14.6.

## Bagian C — Proyek Praktik

Setiap proyek memuat spesifikasi, hasil yang diserahkan, dan kriteria penerimaan yang dapat diperiksa dengan perintah atau pengukuran. Proyek dikerjakan berurutan dan masing-masing bertumpu pada yang sebelumnya.

| Proyek | Fase | Intisari |
| --- | --- | --- |
| 01 | 0–2 | Konverter Satuan |
| 02 | 3–5 | Pustaka Komponen dan Dasbor |
| 03 | 6–7 | Pencatat Tugas Penuh-Keyboard |
| 04 | 8–10 | Penampil Layanan systemd User dengan Backend C++ |
| 05 | 11–12 | Optimasi dan Kualitas |
| 06 | 13–14 | Capstone: Rilis, Keamanan, dan Kontribusi |

### Proyek 01 — Konverter Satuan (Fase 0–2)

**Spesifikasi.** Satu berkas `Main.qml` berisi empat konversi (suhu, panjang, massa, data), input angka lewat `TextInput`, validasi input, hasil real-time lewat binding, dan logika di fungsi murni.

**Kriteria penerimaan.** (1) `qml Main.qml` berjalan tanpa peringatan. (2) `qmllint Main.qml` bersih. (3) Input tidak valid tidak membuat aplikasi rusak dan menampilkan pesan. (4) Tabel sedikitnya 10 kasus uji manual dengan hasil benar. (5) Properti bertipe jelas tidak memakai `var`.

### Proyek 02 — Pustaka Komponen dan Dasbor (Fase 3–5)

**Spesifikasi.** Modul `MyApp.Components` berisi `AppButton`, `Card`, `StatTile`, dan singleton `Theme`; dasbor responsif memakai `RowLayout` dan `GridLayout`.

**Kriteria penerimaan.** (1) Dibangun dengan CMake sebagai modul terpisah. (2) Mengubah satu token di `Theme` mengubah seluruh tampilan. (3) Tampilan benar pada lebar jendela 320, 800, dan 1280 piksel. (4) `all_qmllint` bersih. (5) Setiap komponen memakai `required property` dan tidak membaca `parent`.

### Proyek 03 — Pencatat Tugas Penuh-Keyboard (Fase 6–7)

**Spesifikasi.** `ListModel` dan `ListView` untuk tambah, ubah, hapus, dan tandai selesai; animasi masuk-keluar; persistensi dengan `Settings` atau `LocalStorage`.

**Kriteria penerimaan.** (1) Semua fungsi dapat dilakukan tanpa mouse. (2) Data bertahan setelah aplikasi dimulai ulang. (3) Tidak ada peringatan *binding loop*. (4) Delegate memakai `required property`. (5) Dengan 1000 item, scroll tetap mulus: tidak ada frame yang melebihi anggaran 16,6 ms pada mesin Anda, dicatat dengan profiler.

### Proyek 04 — Penampil Layanan systemd User dengan Backend C++ (Fase 8–10)

**Spesifikasi.** Model C++ (`QAbstractListModel`) yang diisi dari keluaran `systemctl --user list-units --type=service --no-legend --plain` lewat `QProcess`; antarmuka Controls dengan filter dan tombol muat ulang. Hanya baca, tanpa mengubah layanan.

**Kriteria penerimaan.** (1) UI tidak membeku saat memuat: tidak ada frame lebih dari 33 ms selama pemuatan. (2) Parser keluaran diuji, minimal lima kasus termasuk keluaran kosong dan baris rusak. (3) `QProcess` memakai daftar argumen, tidak ada string shell. (4) Tidak ada context property; tipe didaftarkan dengan `QML_ELEMENT`. (5) Seluruh peringatan `qmllint` dan compiler C++ nol.

### Proyek 05 — Optimasi dan Kualitas (Fase 11–12)

**Spesifikasi.** Ambil Proyek 03 atau 04, profil, temukan tiga hambatan, perbaiki, dan tambahkan pengujian.

**Kriteria penerimaan.** (1) Laporan sebelum/sesudah dengan angka (frame time, CPU, memori). (2) Sedikitnya satu perbaikan menurunkan metrik pilihan Anda minimal 20 persen. (3) Sedikitnya sepuluh uji otomatis; `QT_QPA_PLATFORM=offscreen ctest --test-dir build` hijau. (4) `all_qmllint` tanpa peringatan. (5) Build profil terpisah dari build rilis dan `QT_QML_DEBUG` tidak ada di rilis.

### Proyek 06 — Capstone: Rilis, Keamanan, dan Kontribusi (Fase 13–14)

**Spesifikasi.** (a) Paketkan Proyek 04 dengan `PKGBUILD` dan `.desktop`. (b) Tulis threat model satu halaman. (c) Tambahkan satu fitur pada proyek QML open source mengikuti Modul 14.6. (d) Opsional: varian Quickshell.

**Kriteria penerimaan.** (1) Paket terpasang dan berjalan di lingkungan bersih (chroot atau container). (2) Threat model memuat aset, aktor, batas kepercayaan, tiga ancaman, dan mitigasinya. (3) Patch fitur lolos uji proyek asal dan `qmllint`. (4) Deskripsi perubahan menjelaskan tujuan, pendekatan, dan pengujian.

### Varian Quickshell (opsional untuk Proyek 04–06)

Quickshell adalah toolkit berbasis QML untuk membangun komponen shell desktop seperti bar, peluncur, dan pusat notifikasi. Seluruh fondasi kurikulum ini (binding, signal, komponen, model, performa) berlaku langsung. Kerjakan varian ini dengan menggantikan antarmuka Proyek 04 oleh komponen shell yang menampilkan data yang sama, lalu pelajari tipe khususnya dari dokumentasi resminya.

**Referensi.** [Quickshell](https://quickshell.org/)

## Bagian D — Validasi Kompetensi dan Kelulusan

### Hasil belajar per tahap

| Tahap | Setelah menyelesaikannya, Anda mampu |
| --- | --- |
| Foundation (Fase 0–2) | Membaca dan menulis QML dan JavaScript dasar; menjalankan dan mendiagnosa aplikasi kecil dengan `qml`; menjelaskan beda binding dan assignment |
| Intermediate (Fase 3–6) | Merancang komponen dengan API bersih; menata layout responsif; membuat state dan animasi; memusatkan tema; mengoperasikan antarmuka penuh dari keyboard |
| Advanced (Fase 7–9) | Memakai model dan view dengan benar; membuat objek dinamis dengan aman; menyusun modul QML dan arsitektur; membangun aplikasi Controls yang dapat diakses dan diterjemahkan |
| Expert (Fase 10–12) | Menghubungkan backend C++ dengan QML; menjalankan pekerjaan berat di thread terpisah; memprofil dan mengoptimalkan; menulis uji otomatis |
| Enterprise dan Mastery (Fase 13–14) | Mengamankan, memaketkan, dan merilis aplikasi; memperluas Qt dengan tipe kustom; menambah fitur pada proyek yang bukan buatan Anda |

### Standar kelulusan

Anda dinyatakan lulus bila semua syarat berikut terpenuhi:

1. Keenam proyek (Bagian C) memenuhi seluruh kriteria penerimaan masing-masing.
2. Skor rubrik rata-rata sedikitnya 75 dari 100 pada Proyek 04–06.
3. Lulus **ujian kemandirian**: dalam 8 jam kerja, tanpa bantuan langsung, tambahkan satu fitur sesuai spesifikasi pada proyek QML open source yang belum pernah Anda lihat, mengikuti Modul 14.6, dengan uji baru dan `qmllint` tanpa peringatan baru.
4. Dapat menjelaskan secara lisan, tanpa catatan, lima topik pilihan penguji dari Fase 3, 7, 10, 11, dan 13.

### Rubrik penilaian (100 poin)

| Aspek | Bobot | Indikator |
| --- | --- | --- |
| Fungsionalitas | 25 | Seluruh kriteria penerimaan terpenuhi; kasus tepi ditangani |
| Kualitas kode | 20 | `qmllint` dan peringatan compiler nol; konvensi diikuti; tidak ada duplikasi |
| Arsitektur | 15 | Layering jelas; antarmuka komponen bersih; dependensi satu arah |
| Performa | 10 | Anggaran frame dipenuhi; tidak ada pekerjaan berat di thread UI |
| Keamanan | 10 | Input divalidasi; tidak ada eksekusi dari sumber tak tepercaya; hak minimum |
| Pengujian | 10 | Uji otomatis bermakna; dapat dijalankan headless |
| Dokumentasi | 10 | README, keputusan arsitektur, dan cara menjalankan |

Interpretasi skor: 90–100 mastery; 75–89 mahir; 60–74 cakap; di bawah 60 ulangi fase yang lemah.

### Tabel progres

| Fase | Selesai | Proyek terkait | Tanggal |
| --- | --- | --- | --- |
| 0 Fondasi lingkungan | ☐ | 01 |  |
| 1 Bahasa QML | ☐ | 01 |  |
| 2 JavaScript untuk QML | ☐ | 01 |  |
| 3 Model objek dan reaktivitas | ☐ | 02 |  |
| 4 Dasar visual | ☐ | 02 |  |
| 5 Komponen, layout, styling | ☐ | 02 |  |
| 6 Interaksi, state, animasi | ☐ | 03 |  |
| 7 Model, view, data | ☐ | 03 |  |
| 8 Modul dan arsitektur | ☐ | 04 |  |
| 9 Controls dan UI lanjut | ☐ | 04 |  |
| 10 Interoperabilitas C++/QML | ☐ | 04 |  |
| 11 Rendering dan performa | ☐ | 05 |  |
| 12 Testing dan kualitas | ☐ | 05 |  |
| 13 Keamanan dan deployment | ☐ | 06 |  |
| 14 Mastery | ☐ | 06 + ujian kemandirian |  |
| Bagian B (B0–B9) | ☐ | dibaca bersama Fase 1–4 |  |
| Bagian B (B10–B19) | ☐ | dibaca bersama Fase 7–12 |  |

## Strategi Belajar

- **Jalankan sebelum membaca.** Ketik dan jalankan contoh lebih dulu, baru baca penjelasannya. Pengalaman lebih dulu membuat penjelasan melekat.
- **Pola 70/30.** Sekitar 70 persen waktu untuk praktik dan 30 persen untuk membaca.
- **Aturan tiga langkah.** Baca, tiru, ubah, lalu bangun ulang dari nol tanpa melihat.
- **Jurnal belajar di git.** Catat setiap galat, penyebabnya, dan perbaikannya. Jurnal itu menjadi referensi pribadi yang paling berharga.
- **Pengulangan berjarak.** Ulangi *Cek pemahaman* pada hari ke-1, ke-7, dan ke-30 setelah menyelesaikan sebuah modul.
- **Baca source Qt mingguan.** Satu tipe per minggu, dengan pola di Modul 14.5.
- **Latih kendali keyboard.** Kuasai pintasan editor dan terminal Anda; antarmuka yang Anda bangun juga harus bisa dioperasikan penuh dari keyboard.
- **Ukur sebelum mengoptimalkan.** Jangan mengubah apa pun berdasarkan firasat.
- **Minta bantuan dengan reproduksi minimal.** Saat bertanya di forum atau melapor bug, sertakan satu berkas QML terkecil yang memperlihatkan masalah.
- **Jalur A.** Mulai dari Modul 0.0, sediakan 1,5–2 kali waktu, dan belajarlah berpasangan bila memungkinkan.

## Bagian E — Kontrol Kualitas Dokumen

### Batas verifikasi (baca dulu)

Konsep, perilaku, dan versi fitur yang dicantumkan telah dicocokkan dengan dokumentasi resmi Qt pada bagian yang memuat klaim yang diaudit. Namun **contoh kode belum dikompilasi atau dijalankan** oleh penyusun pada Qt 6.12, dan **tautan belum diuji otomatis**. Jalankan setiap contoh sekali pada versi Qt target Anda dan jalankan skrip tautan di bawah sebelum mengandalkannya. Hal yang diketahui belum pasti ditandai **\[uji dulu\]**.

### Skrip validasi tautan

Unduh dokumen ini sebagai Markdown (misalnya `kurikulum.md`), lalu jalankan:

```
grep -oE 'https?://[^ )>]+' kurikulum.md | sort -u | xargs -P8 -I{} curl -s -o /dev/null -L --max-time 15 -w '%{http_code} {}\n' {} | grep -v '^200'
```

Hasil selain 200 perlu diperiksa manual; sebagian situs menolak `curl` meski halamannya valid.

### Kebijakan versi dokumentasi

Tautan memakai `/qt-6/` yang selalu mengarah ke rilis terbaru. Bila Anda memerlukan keterulangan, pin ke versi tertentu (misalnya `/qt-6.12/`) di seluruh dokumen sekaligus, jangan sebagian.

### Daftar periksa tiap rilis dokumen

1. Tidak ada parameter pelacak (`utm_source`) di tautan.
2. Setiap contoh kode sudah dijalankan pada versi Qt target.
3. Setiap modul memuat sembilan unsur template.
4. Estimasi per fase dan tabel tahap sinkron.
5. Tanggal dan versi target di bagian atas diperbarui setiap kali Qt merilis versi LTS baru.
6. Penanda **\[uji dulu\]** ditinjau ulang: hapus bila sudah terbukti, pertahankan bila belum.

## Bagian F — Jejak Perbaikan Audit

| Temuan audit | Perbaikan | Lokasi |
| --- | --- | --- |
| `.pragma ComponentBehavior` keliru | Dibedakan dari `.pragma library`; tabel pragma dokumen | Modul 2.3 |
| `time` bukan tipe dasar; `font`, `matrix4x4`, `quaternion` hilang | Tabel tipe dasar diperbaiki | Modul 1.2 |
| `qmlscene` deprecated | Ditandai deprecated; `qml` jalur utama | Bagian 4 |
| Daftar style Controls usang | Style diperbarui, FluentWinUI3, kustomisasi native, dampak kompilasi | Modul 9.2 |
| Delegate memakai `model.x` | Memakai `required property` | Modul 7.2 |
| Singleton tanpa sisi CMake | Properti `QT_QML_SINGLETON_TYPE` | Modul 5.3 |
| `main.cpp` tidak ada, nama target salah | `main.cpp` lengkap, nama target konsisten | Modul 0.2 |
| Fungsi di luar objek | Dipindah ke dalam objek | Modul 7.3 |
| Aturan `this` | Mengikuti dokumentasi resmi | Modul 2.2, Fase B9 |
| `async/await`, BigInt, object spread | Ditandai **\[uji dulu\]** | Modul 2.1, 7.4, Fase B6, B13, B15 |
| Tautan kompiler dan debugging tidak valid | URL diganti ke halaman yang terverifikasi | Modul 11.4, 11.5, 12.1 |
| `qmlsc` disarankan tanpa menyebut lisensi | Dinyatakan hanya komersial; `qmlcachegen` sebagai jalur gratis | Modul 11.5 |
| Runtime dan variabel lingkungan | Modul baru dan tabel variabel | Modul 0.3, Bagian 4 |
| Kompilasi QML | Modul baru | Modul 11.5 |
| Threading | Modul baru | Modul 10.7 |
| C++ Qt 6 modern | Bindable, value type, attached, extended, foreign | Modul 14.1 |
| Modul Qt Quick ekstra, fitur Qt 6.12 | Modul baru dan penanda versi | Modul 6.4, 9.2, 12.1 |
| Keamanan debug, XHR, jalur import, isolasi | Tabel risiko dan mitigasi | Modul 13.1 |
| Distribusi Arch | `PKGBUILD` dan `.desktop` | Modul 13.2, 13.3 |
| Jebakan konversi tipe | Dimasukkan ke modul terkait | Modul 1.2, 10.4, Fase B14 |
| Template tidak konsisten | Sembilan unsur di setiap modul | Seluruh modul |
| Dokumen 1 berupa daftar kata kunci | Ditulis ulang dengan konsep, contoh, jebakan, latihan | Bagian B |
| Tidak ramah non-IT | Modul 0.0, Jalur A, glosarium, template dengan analogi | Bagian Cara memakai, Modul 0.0, Glosarium |
| Tidak ada metodologi memodifikasi proyek asing | Modul dan ujian kemandirian | Modul 14.6, Bagian D |
| Tidak ada peta modul Qt lain | Modul baru | Modul 14.7 |
| Proyek tanpa kriteria terukur | Spesifikasi dan kriteria penerimaan | Bagian C |
| Tumpang tindih dokumen, urutan, estimasi, C++ | Pemetaan, jalur C++ paralel, estimasi disinkronkan | Bagian 2 |
| Tabel progres hanya sebagian fase | Mencakup seluruh fase | Bagian D |
| Tautan berparameter pelacak, gambar eksternal, versi campur | Tautan bersih, tanpa gambar, kebijakan versi | Seluruh dokumen, Bagian E |

## Penutup

Kurikulum ini memandang penguasaan sebagai kemampuan membuktikan, bukan menghafal: setiap konsep punya contoh yang bisa dijalankan, setiap fase punya latihan dan pengukuran, dan setiap proyek punya kriteria yang bisa diperiksa dengan perintah. Tujuan akhirnya adalah kemandirian: bila Anda sanggup membuka proyek yang belum pernah Anda lihat, memahami arsitekturnya, dan menambahkan fitur dengan aman, Anda telah melewati batas dari mahir menuju mastery.

[Quickshell](./quickshell/quickshell.md)

[0]: ./bagian-1/README.md
[1]: ./bagian-2/README.md
[2]: ./bagian-3/README.md
[3]: ./bagian-4/README.md
[4]: ./bagian-5/README.md
[5]: ./bagian-6/README.md
[6]: ./bagian-7/README.md
[7]: ./bagian-8/README.md
[8]: ./bagian-9/README.md
[9]: ./bagian-10/README.md
[10]: ./bagian-11/README.md
[11]: ./bagian-12/README.md
[12]: ./bagian-13/README.md
[13]: ./bagian-14/README.md
[14]: ./bagian-15/README.md
