# Modul 8.1: Modul QML, URI, dan Import

*Fase 8: Modul QML dan Arsitektur Aplikasi*

<details>
  <summary>📃 Daftar Isi</summary>

---

## Daftar isi modul ini

1. Audit singkat sebelum materi
2. Fondasi: peran modul, konsep dan filosofi, terminologi, peta visual
3. Proyek contoh lengkap (dipakai di seluruh sub-bab)
4. **8.1.1** Anatomi modul
5. **8.1.2** URI dan struktur folder
6. **8.1.3** `qmldir` dan pembuatannya otomatis
7. **8.1.4** Import path dan `QML_IMPORT_TRACE`
8. **8.1.5** Modul statis vs plugin
9. **8.1.6** Aturan dependensi antarmodul
10. **8.1.7** (TAMBAHAN) Jenis import: modul, direktori, JavaScript, dan kualifikasi `as`
11. **8.1.8** (TAMBAHAN) Kebijakan CMake (QTP) dan `loadFromModule`
12. **8.1.9** (TAMBAHAN) Keamanan: import path sebagai batas kepercayaan
13. Penutup: hubungan modul, tabel kesalahan, latihan, cek pemahaman, referensi

</details>

---

## 1. Audit singkat

Saya membaca bagian 8.1 terhadap dokumentasi Qt 6.12 (`QML Modules`, `qt_add_qml_module`, `qmldir`, `Import Statements`, `Building a QML application`, `Building a reusable QML module`, kebijakan QTP0004).

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Pohon contoh: `Components/AppButton.qml` dengan URI `MyApp.Components` | **Tidak sesuai dokumentasi** | Untuk modul berupa pustaka, struktur folder sumber harus mengikuti *target path* (URI dengan titik diganti garis miring). `qt_add_qml_module` mengeluarkan peringatan bila tidak cocok. Folder yang benar adalah `MyApp/Components/`. Pohon dikoreksi di bagian 3 |
| 2 | `App/Main.qml` sebagai modul `MyApp.App` | Boleh, tetapi ada jebakan | Bila *backing target* adalah executable, struktur folder tidak wajib mengikuti URI. Namun jalur resource file = awalan + target path + jalur relatif dari folder CMake, sehingga mendaftarkan `App/Main.qml` dari folder akar menghasilkan `App/App/Main.qml` di resource. Solusi: beri `App/` `CMakeLists.txt` sendiri (bagian 3) |
| 3 | "Menautkan pustaka modul sesuai pola backing library dan plugin" | Terlalu ringkas | Dijelaskan: menaut langsung ke backing library sudah cukup, plugin bersifat opsional. Plugin statis baru wajib ditautkan pada build statis (8.1.5) |
| 4 | "Import tanpa versi" dan "dependensi siklik" ada di terminologi | Tak dijelaskan | Dijelaskan di 8.1.6 dan 8.1.7 |
| 5 | Kebijakan CMake (QTP0001, QTP0004) | Belum ada | Ditambahkan di 8.1.8. Berpengaruh langsung pada jalur resource dan visibilitas tipe antar subfolder |
| 6 | Singleton (`Theme.qml` pada latihan) | Perlu satu langkah tambahan | `pragma Singleton` saja tidak cukup. Properti sumber `QT_QML_SINGLETON_TYPE` juga wajib (8.1.3) |
| 7 | `QML_IMPORT_PATH` | Kurang | Tidak boleh memuat jalur `qrc:`, dan `qml` punya opsi `-I`. Ditambahkan di 8.1.4 |
| 8 | Keamanan import path | Belum ada | TAMBAHAN 8.1.9: Qt menganggap semua berkas di import path tepercaya |
| 9 | Tooling | Perlu `IMPORT_PATH` | `qmllint` dan kompilasi QML perlu tahu letak modul dependensi (8.1.4) |
| 10 | Pohon Modul 8.3 (`qml/App`, `qml/Components`) | **Akan bermasalah serupa** | Dicatat sekarang agar disesuaikan saat sampai di Modul 8.3 |

**Pembaruan daftar isi kurikulum 8.1:** 8.1.1 sampai 8.1.6 tetap, ditambah **8.1.7** (Jenis import), **8.1.8** (Kebijakan CMake dan `loadFromModule`), dan **8.1.9** (Keamanan import path).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Selama ini kode QML tinggal dalam satu folder. Itu cukup untuk latihan, tetapi tidak untuk proyek yang tumbuh. Modul ini mengajarkan cara memecah aplikasi menjadi **modul QML bernama**, masing-masing punya identitas (URI), daftar tipe yang diekspor, dan lokasi yang dapat ditemukan mesin. Ini fondasi seluruh Fase 8: arsitektur (8.2), struktur proyek (8.3), dan disiplin kualitas (8.4) semuanya bertumpu pada batas modul yang jelas.

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Modul adalah **buku di perpustakaan**:

| Perpustakaan | Modul QML |
|---|---|
| Judul buku yang unik | **URI** (`MyApp.Components`) |
| Daftar isi | **`qmldir`**: tipe apa saja yang diekspor |
| Isi buku | Berkas QML, JavaScript, dan kode C++ |
| Rak penyimpanan | **Import path** |
| Meminjam buku | **`import`** |
| Petugas yang mengambilkan buku bila Anda tidak membawanya | **Plugin** (dimuat dinamis) |

Prinsip yang mendasarinya:

1. **Batas yang eksplisit.** Modul memaksa kita menyatakan apa yang diekspor dan apa yang dibutuhkan. Dengan begitu ketergantungan terlihat, bukan tersembunyi.
2. **Satu tanggung jawab per modul.** Modul yang fokus mudah diuji, diganti, dan dipahami. Dokumentasi menyebut modul sebagai unit fungsi yang mandiri secara logis.
3. **Arah ketergantungan satu arah.** Lapisan atas boleh memakai lapisan bawah, tidak sebaliknya (8.1.6).
4. **Konvensi lebih baik daripada konfigurasi.** Bila struktur folder mengikuti URI, mesin dan alat bekerja tanpa pengaturan tambahan.
5. **Keamanan: yang ada di import path dianggap tepercaya.** Dokumentasi Qt menyatakan bahwa semua berkas di bawah import path dianggap berasal dari sumber tepercaya. Karena itu isi dan izin folder tersebut adalah urusan keamanan (8.1.9).

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **Modul QML (identified module)** | Kumpulan tipe QML, resource JavaScript, dan (opsional) kode C++ dalam sebuah *type namespace*, diidentifikasi URI. |
| **URI** | Identitas modul dalam notasi titik, misalnya `MyApp.Components`. Tiap segmen harus berupa *identifier* ECMAScript yang valid. |
| **Target path** | URI dengan titik diganti `/` (`MyApp/Components`). Menjadi nama folder dan jalur resource. |
| **`qmldir`** | Berkas teks "daftar isi" modul. Ada dua jenis: definisi modul, dan daftar isi folder (*directory listing*). |
| **Import path** | Daftar lokasi tempat mesin mencari modul. |
| **`QML_IMPORT_PATH`** | Variabel lingkungan untuk menambah import path. |
| **`QML_IMPORT_TRACE`** | Variabel lingkungan untuk menampilkan jejak proses pencarian modul. |
| **Backing target / library** | Target (pustaka) yang berisi seluruh isi modul: kode C++, berkas QML terkompilasi, resource. |
| **Plugin modul** | Pustaka kecil yang dimuat saat runtime bila aplikasi tidak menaut langsung ke backing library. |
| **Plugin opsional (`optional plugin`)** | Plugin yang tidak dimuat bila tipe modul sudah tersedia lewat tautan langsung. |
| **Import tanpa versi** | `import MyApp.Components` tanpa nomor. Mengambil versi terbaru modul. |
| **Implicit import** | Impor otomatis folder tempat sebuah berkas QML berada. |
| **Directory import** | `import "../Components"`: mengimpor folder berkas QML langsung. |
| **Singleton** | Tipe yang hanya punya satu instance (mis. `Theme`). Butuh `pragma Singleton` dan pendaftaran di `qmldir`. |
| **Dependensi siklik** | A mengimpor B dan B mengimpor A (langsung atau melingkar). Harus dihindari. |
| **Kebijakan QTP** | Kebijakan CMake Qt (`QTP0001`, `QTP0004`, ...) yang mengatur perilaku bawaan generasi modul. |

### 2.4 Peta visual

**Diagram A: anatomi sebuah modul**

```
 Modul "MyApp.Components"           (URI)
 |
 +-- AppButton.qml   \
 +-- Theme.qml        >--- berkas QML --(dikompilasi, ditanam di backing library)
 |                   /
 +-- qmldir                  daftar isi: module, tipe, singleton, plugin, typeinfo
 +-- *.qmltypes              deskripsi tipe untuk alat (qmllint, editor)
 +-- plugin (opsional)       pustaka kecil pemuat dinamis
```

**Diagram B: cara mesin mencari modul**

```
import MyApp.Components
   |
   v  URI -> target path  "MyApp/Components"
   v  telusuri import path berurutan:
        platform bundle (macOS/Android)
        direktori biner aplikasi
        qrc:/qt-project.org/imports
        qrc:/qt/qml                  <-- modul dari qt_add_qml_module (QTP0001) ada di sini
        QML2_IMPORT_PATH (usang)
        QML_IMPORT_PATH
        QLibraryInfo::QmlImportsPath (modul bawaan Qt)
        + jalur tambahan: opsi -I (alat qml), QQmlEngine::addImportPath()
   v  ketemu  <jalur>/MyApp/Components/qmldir ?
        ya    -> baca tipe; pustaka/plugin mendaftarkan tipe C++
        tidak -> galat: module "MyApp.Components" is not installed
```

**Diagram C: target build pada proyek contoh**

```
 appMiniapp  (executable; backing target modul MyApp.App)
     |
     |  target_link_libraries
     v
 MyAppComponents  (backing library; modul MyApp.Components)
     ^
     |  (dimuat dinamis HANYA bila tidak tertaut langsung)
 MyAppComponentsplugin  (plugin opsional yang sepele)
     |
     v
 Qt6::Quick
```

**Diagram D: lapisan dan arah ketergantungan**

```
 App  -->  Features  -->  Components  -->  Core
 (panah = "boleh mengimpor")
 tidak boleh ada panah balik, tidak boleh ada siklus
```

---

## 3. Proyek contoh lengkap

Proyek ini mempraktikkan seluruh Modul 8.1. Pohonnya sudah dikoreksi sesuai audit:

```
miniapp/
├── CMakeLists.txt                  # akar: proyek, kebijakan, add_subdirectory
├── App/
│   ├── CMakeLists.txt              # executable + modul MyApp.App
│   ├── main.cpp
│   └── Main.qml
└── MyApp/
    └── Components/
        ├── CMakeLists.txt          # pustaka + modul MyApp.Components
        ├── AppButton.qml
        └── Theme.qml
```

Persiapan di Arch (sesuaikan bila sebagian sudah terpasang):

```bash
sudo pacman -S --needed cmake ninja qt6-base qt6-declarative
```

**`CMakeLists.txt` (akar):**

```cmake
cmake_minimum_required(VERSION 3.21)
project(miniapp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(MyApp/Components)
add_subdirectory(App)
```

**`MyApp/Components/CMakeLists.txt`:**

```cmake
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(MyAppComponents
    URI MyApp.Components
    QML_FILES
        AppButton.qml
        Theme.qml
)

target_link_libraries(MyAppComponents PRIVATE Qt6::Quick)
```

**`App/CMakeLists.txt`:**

```cmake
qt_add_executable(appMiniapp main.cpp)

qt_add_qml_module(appMiniapp
    URI MyApp.App
    QML_FILES
        Main.qml
    IMPORT_PATH ${CMAKE_BINARY_DIR}
)

target_link_libraries(appMiniapp PRIVATE
    Qt6::Quick
    MyAppComponents
)

# Hanya untuk build statis (Qt dibangun statis): tautkan juga plugin modulnya
# target_link_libraries(appMiniapp PRIVATE MyAppComponentsplugin)
```

**`App/main.cpp`:**

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    engine.loadFromModule("MyApp.App", "Main");
    return app.exec();
}
```

**`App/Main.qml`:**

```qml
import QtQuick
import MyApp.Components

Window {
    width: 320; height: 180
    visible: true
    title: 'Miniapp'
    color: Theme.latar

    AppButton {
        anchors.centerIn: parent
        label: 'OK'
        onKlik: console.log('tombol diklik')
    }
}
```

**`MyApp/Components/Theme.qml`:**

```qml
pragma Singleton
import QtQuick

QtObject {
    readonly property color latar: '#1e1e2e'
    readonly property color aksen: '#89b4fa'
    readonly property color teks: '#cdd6f4'
    readonly property int jari: 8
}
```

**`MyApp/Components/AppButton.qml`:**

```qml
import QtQuick

Rectangle {
    id: root
    property string label: ''
    signal klik()

    implicitWidth: teks.implicitWidth + 4 * Theme.jari
    implicitHeight: teks.implicitHeight + 2 * Theme.jari
    radius: Theme.jari
    color: Theme.aksen

    Text {
        id: teks
        anchors.centerIn: parent
        text: root.label
        color: Theme.latar
        textFormat: Text.PlainText
    }
    TapHandler { onTapped: root.klik() }
}
```

**Membangun dan menjalankan:**

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
./build/App/appMiniapp
```

Sebuah jendela dengan tombol "OK" muncul. Klik tombol itu dan terminal mencetak `qml: tombol diklik`.

**Uji asap tanpa jendela** (berguna untuk skrip dan CI). Kode keluar `124` berarti aplikasi masih hidup setelah 3 detik (modul termuat). Kode `255` berarti pemuatan gagal:

```bash
timeout 3 env QT_QPA_PLATFORM=offscreen ./build/App/appMiniapp; echo "kode keluar: $?"
```

Bila konteks grafis gagal dibuat, tambahkan `QT_QUICK_BACKEND=software`.

---

## 4. 8.1.1 Anatomi modul

> Tahu isi buku sebelum menulis bab pertamanya.

Menurut dokumentasi, sebuah modul QML menyediakan tipe dan resource JavaScript berversi dalam sebuah type namespace. Tipenya bisa didefinisikan di QML maupun C++. Manfaatnya:

- Berbagi tipe umum dalam satu proyek (kelompok komponen UI untuk banyak jendela).
- Mendistribusikan pustaka berbasis QML.
- Memodularkan fitur sehingga aplikasi hanya memuat yang dibutuhkan.
- Memberi versi pada tipe dan resource.

Setiap berkas QML yang diawali huruf kapital otomatis mendefinisikan sebuah tipe yang dapat dipakai berkas lain di modul yang sama (`AppButton.qml` menjadi tipe `AppButton`).

**Tiga cara mendefinisikan modul, dari yang dianjurkan:**

| Cara | Kapan |
|---|---|
| **CMake `qt_add_qml_module`** | **Default.** Menangani pendaftaran tipe, kompilasi resource, `qmldir`, linting |
| `qmldir` manual | Hanya bila harus memakai `qmake` |
| Directory import (tanpa modul formal) | Berbagi komponen sederhana lewat folder (8.1.7) |

**Peran tiap berkas dalam proyek contoh:**

| Berkas | Peran |
|---|---|
| `MyApp/Components/CMakeLists.txt` | Mendefinisikan modul `MyApp.Components` |
| `AppButton.qml`, `Theme.qml` | Tipe yang diekspor |
| `qmldir` (dibuat otomatis di folder build) | Daftar isi modul |
| `App/CMakeLists.txt` | Mendefinisikan modul `MyApp.App` di executable |
| `Main.qml` | Titik masuk, memakai `import MyApp.Components` |

**Penjelasan kata demi kata untuk `qt_add_qml_module` komponen:**

| Potongan | Arti |
|---|---|
| `MyAppComponents` | Nama *backing target*. Berupa pustaka, dibuat otomatis karena belum ada. |
| `URI MyApp.Components` | Identitas modul. Dipakai di `import` dan di baris `module` pada `qmldir`. |
| `QML_FILES` | Berkas QML, `.js`, atau `.mjs` anggota modul. Dikompilasi ke bytecode dan ditanam di backing target. |
| `set_source_files_properties(... QT_QML_SINGLETON_TYPE TRUE)` | Menandai `Theme.qml` sebagai singleton di `qmldir`. Harus dipanggil **sebelum** `qt_add_qml_module`. |
| `target_link_libraries(... Qt6::Quick)` | Modul memakai `QtQuick`, jadi pustaka Quick ditautkan. |

Jebakan: M1, M13.

---

## 5. 8.1.2 URI dan struktur folder

> Nama yang konsisten adalah dokumentasi yang tak pernah usang.

**Aturan URI** (dari dokumentasi `qt_add_qml_module`):

- Notasi titik, misalnya `QtQuick.Layouts`.
- Tiap segmen harus *identifier* ECMAScript yang sah: tidak diawali angka dan tidak mengandung tanda minus.
- Karena URI diterjemahkan menjadi nama folder, batasi ke huruf Latin alfanumerik, garis bawah, dan titik.
- URI dipakai sebagai baris `module` di `qmldir`, dan menjadi *target path* dengan mengganti titik menjadi `/`.

**Aturan folder:**

- **Modul berupa pustaka:** folder sumber tempat `qt_add_qml_module` dipanggil harus mengikuti target path, dan **nama harus persis sama** termasuk huruf besar-kecil. Untuk `MyApp.Components` itu `MyApp/Components/`. Bila tidak cocok, CMake mengeluarkan peringatan.
- **Modul berupa executable:** struktur tidak wajib mengikuti URI.
- Tata letak ini dicerminkan di folder build. Karena itu Anda dapat memberikan jalur folder build ke alat `qml` lewat `-I` dan plugin akan ditemukan.

**Contoh pemetaan URI ke folder:**

| URI | Folder sumber (modul pustaka) |
|---|---|
| `MyApp.Components` | `MyApp/Components/` |
| `MyApp.Core` | `MyApp/Core/` |
| `MyApp.Features.Tugas` | `MyApp/Features/Tugas/` |

**Jalur resource:** setiap berkas ditempatkan di resource pada `awalan + target path + jalur relatif`. Dengan kebijakan QTP0001, awalan bawaan adalah `/qt/qml/`, sehingga `AppButton.qml` berada di `qrc:/qt/qml/MyApp/Components/AppButton.qml`. Jalur itu sudah termasuk import path bawaan, jadi modul ditemukan tanpa konfigurasi tambahan.

**Opsi lain untuk logika yang sama (menentukan lokasi):**

| Opsi | Catatan |
|---|---|
| Folder mengikuti URI (default) | Dianjurkan, bekerja tanpa pengaturan |
| `RESOURCE_PREFIX` kustom | Bila diubah, **tambahkan juga ke import path** agar modul ditemukan |
| `OUTPUT_DIRECTORY` dan `QT_QML_OUTPUT_DIRECTORY` | Tata letak kustom pada disk. Biasanya tak perlu |
| Properti sumber `QT_RESOURCE_ALIAS` | Bila berkas berada di folder berbeda dari lokasi resource yang diinginkan |

Jebakan: M2, M8, M9.

---

## 6. 8.1.3 `qmldir` dan pembuatannya otomatis

> Daftar isi yang dibuat mesin tak pernah lupa satu bab pun.

`qmldir` adalah berkas teks yang mendaftar tipe, JavaScript, dan plugin modul. Ada dua jenis berkas `qmldir`: **definisi modul** (dibahas di sini) dan **daftar isi folder** (untuk directory import, 8.1.7). Setiap perintah berada di baris sendiri. Baris yang diawali `#` adalah komentar.

Dengan `qt_add_qml_module`, `qmldir` dan berkas typeinfo (`.qmltypes`) **dibuat otomatis** dari argumen dan `QML_FILES`. Dokumentasi menyarankan memakai hasil otomatis karena lebih mudah dirawat dan tidak rawan kesalahan tulis tangan. Opsi `NO_GENERATE_QMLDIR` ada bagi yang terpaksa menulis sendiri.

**Perintah yang dikenal `qmldir` (verifikasi dari dokumentasi):**

| Perintah | Fungsi |
|---|---|
| `module <URI>` | Identitas modul. Harus baris pertama, tepat satu |
| `[singleton] <Tipe> <Versi> <Berkas>` | Mengekspor tipe QML. `singleton` untuk tipe tunggal |
| `internal <Tipe> <Berkas>` | Tipe ada di modul tetapi tidak diekspor ke pemakai |
| `<Id> <Versi> <Berkas.js>` | Mengekspor resource JavaScript |
| `[optional] plugin <Nama> [<Jalur>]` | Menyatakan plugin. `optional` berarti plugin tak perlu dimuat bila tipe sudah tersedia |
| `classname <Kelas>` | Nama kelas plugin C++ (wajib untuk build statis) |
| `typeinfo <Berkas.qmltypes>` | Deskripsi tipe untuk alat |
| `depends <Modul> <Versi>` | Dependensi tersembunyi (untuk paket aplikasi) |
| `import <Modul> [<Versi>]` | Modul lain yang ikut diimpor bersama modul ini |
| `designersupported` | Mendukung Qt Quick Designer |
| `prefer <Jalur>` | Muat berkas dari jalur ini, mis. resource hasil kompilasi |

**Bentuk representatif `qmldir` hasil build** (di `build/MyApp/Components/qmldir`; isi persisnya bergantung versi Qt dan opsi, jadi buka berkas hasil build Anda untuk melihat versi nyata):

```
module MyApp.Components
optional plugin MyAppComponentsplugin
classname MyApp_ComponentsPlugin
typeinfo MyAppComponents.qmltypes
prefer :/qt/qml/MyApp/Components/
singleton Theme <versi> Theme.qml
AppButton <versi> AppButton.qml
```

Nama plugin adalah nama backing target ditambah `plugin`. Nama kelas bawaan adalah URI dengan titik diganti garis bawah, lalu `Plugin`. Bila `VERSION` dihilangkan, Qt memakai versi setinggi mungkin untuk semua tipe.

**Singleton butuh dua langkah (jebakan M4):**

1. Di berkasnya: `pragma Singleton`.
2. Di CMake: `set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)` **sebelum** `qt_add_qml_module`. Properti ini membuat baris `singleton` tertulis di `qmldir`.

**Contoh `qmldir` tulisan tangan** (untuk memahami, bukan untuk dipakai di proyek CMake):

```
module CustomStyles
singleton Style 1.0 Style.qml
Tombol 1.0 Tombol.qml
```

**Berkas `qmltypes`** tidak memengaruhi fungsi modul. Ia hanya memberi alat (editor, `qmllint`) informasi tipe untuk melengkapi kode dan memeriksa galat. Modul yang mendefinisikan tipe C++ sebaiknya menyertakannya, dan dibuat otomatis dari makro `QML_ELEMENT`.

**Opsi lain:**

| Opsi | Catatan |
|---|---|
| `qmldir` otomatis dari CMake | **Default.** Disarankan |
| `NO_GENERATE_QMLDIR` + tulis sendiri | Hanya bila proyek memang harus mengontrol seluruh isinya |
| `qt_target_qml_sources()` | Menambah berkas QML setelah modul dibuat, mis. secara kondisional |

Jebakan: M3, M4, M13.

---

## 7. 8.1.4 Import path dan `QML_IMPORT_TRACE`

> Menemukan jalan lebih cepat bila tahu peta.

### 7.1 Daftar import path bawaan

Menurut dokumentasi, urutan prioritas bawaan adalah:

1. Jalur *bundle* khusus platform (macOS, Android).
2. Direktori biner aplikasi.
3. `qrc:/qt-project.org/imports` di dalam resource.
4. `qrc:/qt/qml` di dalam resource (sejak Qt 6.5).
5. Jalur dari variabel `QML2_IMPORT_PATH` (usang).
6. Jalur dari variabel `QML_IMPORT_PATH`.
7. Lokasi `QLibraryInfo::QmlImportsPath` (modul Qt sendiri).

Jalur tambahan dapat diberikan lewat `QQmlEngine::addImportPath()`, variabel `QML_IMPORT_PATH`, atau, pada alat `qml`, opsi `-I`.

Beberapa aturan penting:

- **Pemisah jalur** pada `QML_IMPORT_PATH`: titik dua (`:`) di Linux, titik koma (`;`) di Windows. Akibatnya **jalur resource dan URL tidak bisa** ditulis di variabel itu karena mengandung titik dua. Tambahkan lewat `QQmlEngine::addImportPath()` di kode.
- Disarankan menaruh modul aplikasi dan pustaka di `qrc:/qt/qml`. Itu otomatis terjadi dengan `qt_add_qml_module` bila QTP0001 aktif.
- Bila atribut `Qt::AA_PluginApplication` diatur, direktori aplikasi, jalur dari variabel lingkungan, dan jalur platform di luar sistem resource dihilangkan secara default.

### 7.2 `IMPORT_PATH` pada CMake

`IMPORT_PATH` pada `qt_add_qml_module` menambah lokasi pencarian bagi **modul dependensi** pada waktu build (linting dan kompilasi). Modul lain harus punya `qmldir` di bawah target path-nya pada salah satu jalur itu. Pada proyek contoh, `IMPORT_PATH ${CMAKE_BINARY_DIR}` membuat `qmllint` menemukan `build/MyApp/Components/qmldir`.

### 7.3 Melacak masalah dengan `QML_IMPORT_TRACE`

Menyetel `QML_IMPORT_TRACE=1` memunculkan keluaran debug dari mekanisme pemuatan import QML, sehingga terlihat jalur mana yang dicoba mesin. Bentuk baris persisnya berbeda antarversi, jadi cari kata kunci yang Anda butuhkan.

```bash
QML_IMPORT_TRACE=1 ./build/App/appMiniapp 2>&1 | grep -i 'MyApp'
```

Cara membaca hasilnya: cari baris yang menyebut `MyApp.Components` dan perhatikan **jalur** tempat modul ditemukan. Bila modul tak ditemukan, tidak ada baris yang menyebut lokasi yang berhasil, dan di situlah masalahnya: URI salah, folder salah, atau import path belum memuat lokasinya.

### 7.4 Menjalankan QML mandiri dengan modul hasil build

Alat `qml` dapat memakai modul di folder build lewat `-I`:

```bash
pacman -Ql qt6-declarative | grep -E 'bin/qml$'       # cari nama biner qml di sistem Anda
```

Misalnya jika bernama `qml`, dan Anda punya `tes.qml`:

```qml
import QtQuick
import MyApp.Components

Window {
    width: 240; height: 120
    visible: true
    color: Theme.latar
    AppButton { anchors.centerIn: parent; label: 'Tes' }
}
```

```bash
QML_IMPORT_TRACE=1 qml -I build tes.qml 2>&1 | grep -i 'MyApp'
```

Alat `qml` menemukan plugin karena tata letak build mencerminkan target path. Jalan lain: `QML_IMPORT_PATH=build qml tes.qml`.

**Opsi lain untuk menambah import path:**

| Opsi | Cocok untuk |
|---|---|
| `qml -I <jalur>` | Menjalankan QML mandiri di terminal |
| `QML_IMPORT_PATH=<jalur>` | Skrip dan CI (tanpa jalur `qrc:`) |
| `QQmlEngine::addImportPath()` | Di kode C++, termasuk jalur `qrc:` |
| `IMPORT_PATH` di CMake | Alat build (linting, kompilasi) |
| Qt Creator | Mengambil dari pengaturan proyek |

Jebakan: M1, M5, M9, M10.

---

## 8. 8.1.5 Modul statis vs plugin

> Satu kode, dua cara dikirim: ditanam atau dimuat.

### 8.1.5.1 Tiga susunan target

| Susunan | Penjelasan | Kapan |
|---|---|---|
| **Backing library + plugin terpisah** (default) | Seluruh fungsi di *backing target*. Plugin hanya pemuat sepele, ditandai `optional` di `qmldir` | **Dianjurkan** untuk sebagian besar modul |
| **Plugin sebagai backing target** (`PLUGIN_TARGET` sama dengan target) | Modul hanya dapat dimuat dinamis, tak bisa ditaut langsung | Jarang. Kinerja pemuatan umumnya lebih buruk |
| **Executable sebagai backing target** | Tidak ada plugin | Modul aplikasi (seperti `MyApp.App`) |

### 8.1.5.2 Mengapa plugin dibuat opsional

Bila aplikasi menaut langsung ke backing library, tipe sudah terdaftar dan plugin tidak perlu dimuat. Dokumentasi menekankan bahwa memuat plugin relatif mahal, dan menyarankan paling banyak satu plugin per modul. Plugin tetap berguna untuk skenario di mana backing library tidak tertaut, misalnya saat Anda menjalankan modul lewat alat `qml` (7.4).

### 8.1.5.3 `STATIC` vs `SHARED`

`qt_add_qml_module` membuat backing target sebagai pustaka bersama bila Qt dibangun bersama, dan statis bila Qt statis, atau sesuai `STATIC`/`SHARED` yang Anda minta. Hal yang perlu diingat:

- **Modul statis** juga menghasilkan plugin statis (kecuali `NO_PLUGIN`). Target yang mengimpor modul statis itu **harus menaut eksplisit ke plugin-nya**: `target_link_libraries(app PRIVATE MyAppComponentsplugin)`.
- Pada penautan statis, kadang perlu `Q_IMPORT_QML_PLUGIN` agar plugin benar-benar tertaut.
- Pada build Qt statis, berkas `.qml` dipindai saat konfigurasi CMake untuk menentukan impor dan tautan. Bila Anda menambah atau mengubah impor di berkas yang sudah ada, jalankan ulang CMake secara eksplisit.
- `NO_IMPORT_SCAN` mematikan pemindaian itu, tetapi Anda lalu bertanggung jawab atas seluruh plugin dan modul yang dipakai.

### 8.1.5.4 Opsi konfigurasi plugin

| Opsi | Efek |
|---|---|
| (default) | Plugin dibuat otomatis, opsional |
| `NO_PLUGIN` | Tidak ada plugin. Modul hanya utuh bila backing library tertaut. Tidak boleh digabung dengan opsi plugin lain |
| `PLUGIN_TARGET <nama>` | Nama plugin kustom |
| `NO_GENERATE_PLUGIN_SOURCE` | Anda menulis kelas plugin sendiri (untuk, misalnya, mendaftarkan image provider) |
| `NO_PLUGIN_OPTIONAL` | Plugin ditulis sebagai wajib di `qmldir`. Biasanya dipasangkan dengan plugin kustom |
| `CLASS_NAME` | Nama kelas plugin |
| `NO_CREATE_PLUGIN_TARGET` | Menunda pembuatan plugin, lalu panggil `qt_add_qml_plugin()` |

### 8.1.5.5 Perilaku yang perlu dihafal

- Qt menyatakan: bila modul tidak punya plugin, ia **hanya berfungsi penuh bila backing library tertaut** ke executable, dan penaut kadang membuang pustaka yang tampak tak terpakai.
- Plugin otomatis hanya mungkin bila modul tak melakukan apa pun selain mendaftarkan tipe.

Jebakan: M5, M6.

---

## 9. 8.1.6 Aturan dependensi antarmodul

> Arah panah yang konsisten adalah arsitektur yang bisa dipahami.

### 9.1 Lapisan dan arah

Modul disusun berlapis. Aturan: **lapisan atas boleh bergantung pada lapisan bawah, tidak sebaliknya**, dan **tidak boleh ada siklus**.

```
App  -->  Features  -->  Components  -->  Core
```

| Lapisan | Isi | Boleh mengimpor |
|---|---|---|
| `Core` | Logika dasar, utilitas, konstanta | Hanya modul Qt |
| `Components` | Komponen UI generik, tema | `Core` |
| `Features` | Satu per fitur (tugas, pengaturan, ...) | `Components`, `Core` |
| `App` | Perakitan, navigasi, titik masuk | Semua di bawahnya |

**Mengapa siklus berbahaya:**

- Saling bergantung berarti tak ada yang bisa dibangun, diuji, atau diganti sendiri.
- Pada tingkat build, CMake umumnya menolak siklus antar-target non-statis.
- Pada tingkat QML, impor melingkar menyulitkan mesin dan alat menentukan urutan.

### 9.2 Menegakkan aturan dengan tiga lapis

1. **CMake:** `target_link_libraries` hanya ke lapisan di bawah. Pelanggaran tampak sebagai galat penautan atau siklus.
2. **`qmllint`:** memeriksa impor yang tidak ditemukan atau tak terdeklarasi.
3. **Skrip pemeriksa impor** (pagar tambahan murah di terminal):

```bash
#!/bin/sh
# cek-lapisan.sh: tegakkan arah ketergantungan antar-lapisan
gagal=0

cek() {   # $1 = folder lapisan, $2 = lapisan terlarang (pola regex)
    [ -d "$1" ] || return 0
    if grep -rEn --include='*.qml' "^[[:space:]]*import[[:space:]]+MyApp\.($2)\b" "$1"; then
        echo "PELANGGARAN: $1 mengimpor lapisan di atasnya" >&2
        gagal=1
    fi
}

cek MyApp/Core        'Components|Features|App'
cek MyApp/Components  'Features|App'
cek MyApp/Features    'App'

exit $gagal
```

Jalankan dari akar proyek: `sh cek-lapisan.sh && echo 'lapisan aman'`. Pada proyek contoh tak ada pelanggaran, sehingga mencetak `lapisan aman`. Skrip ini cocok dipanggil dari hook git dan CI (Modul 8.4).

### 9.3 Menyatakan dependensi di CMake

| Argumen | Arti |
|---|---|
| `IMPORTS` | Modul lain yang diimpor modul ini; ikut diimpor pemakai, ditulis sebagai `import` di `qmldir` |
| `DEPENDENCIES` | Dependensi yang tak perlu diimpor, biasanya di tingkat C++ (mis. tipe C++ yang mewarisi `QQuickItem` membutuhkan `QtQuick`). Lebih ringan dari `IMPORTS` |
| `OPTIONAL_IMPORTS` / `DEFAULT_IMPORTS` | Impor yang mungkin dimuat saat runtime, sebagai petunjuk bagi alat |
| `IMPORT_PATH` | Lokasi pencarian untuk alat |

Kebijakan **QTP0005** (Qt terbaru) memungkinkan merujuk dependensi lewat target CMake (`DEPENDENCIES TARGET OtherModule`), dan URI serta import path ditentukan otomatis. Kata kunci `TARGET` **tidak** otomatis menautkan pustaka dan hanya membangun urutan build, jadi `target_link_libraries` tetap diperlukan. Dependensi transitif juga tidak ditambahkan otomatis.

Jebakan: M7.

---

## 10. 8.1.7 (TAMBAHAN) Jenis import: modul, direktori, JavaScript, dan kualifikasi `as`

> Mengenal semua pintu masuk membuat Anda memilih yang paling tepat.

Ada tiga jenis import:

| Jenis | Sintaks | Kapan |
|---|---|---|
| **Modul** | `import MyApp.Components` (versi opsional) | **Utama** untuk proyek berstruktur |
| **Direktori** | `import "../Components"` | Berbagi komponen sederhana lewat folder |
| **JavaScript** | `import "util.js" as Util` | Fungsi JS (pengenal harus unik dalam dokumen) |

### 10.1 Import tanpa versi

`import MyApp.Components` mengambil versi terbaru modul. Bila hanya versi mayor disebut, versi minor terbaru dari mayor itu yang diambil. Dokumentasi `qt_add_qml_module` menyarankan **menghilangkan `VERSION`** bila tak diperlukan, dan menyebut bahwa pengaturan versi internal modul QML punya kelemahan mendasar. Untuk mengelola versi berbeda, pakai mekanisme manajemen paket di luar QML.

Bila versi dipakai: tipe yang diekspor untuk suatu versi mayor tersedia di versi minor terbaru mayor yang sama, tetapi tidak sebaliknya. Versi yang tak punya tipe terekspor tidak dapat diimpor.

### 10.2 Kualifikasi `as`

Untuk mengatasi benturan nama tipe antarmodul:

```qml
import QtQuick as Quick
import TextWidgets as Teks

Quick.Rectangle {
    Teks.Text { text: 'dari modul sendiri' }
    Quick.Text { text: 'dari Qt Quick' }
}
```

Beberapa modul boleh diimpor ke kualifikasi yang sama. Kualifikasi hanya berlaku dalam berkas itu dan bukan atribut objek.

### 10.3 Directory import

Sebuah folder berisi berkas QML dapat diimpor langsung. Folder lokal tidak butuh `qmldir`. Folder **jarak jauh** wajib punya `qmldir` daftar isi folder karena mesin tak bisa menelusuri isinya. Kekurangan: tanpa versi, tanpa identitas, dan struktur rentan salah jalur, sehingga untuk proyek yang tumbuh modul formal lebih baik.

### 10.4 JavaScript dari modul

Modul dapat mengekspor berkas JS dengan baris `<Id> <Versi> <Berkas.js>` di `qmldir`. Pemakai mengimpor modulnya lalu memakai pengenal itu, misalnya `Util.format(...)`.

**Opsi lain untuk berbagi komponen:**

| Opsi | Kapan |
|---|---|
| Satu folder, tanpa modul | Prototipe kecil |
| Directory import | Berbagi kecil, tanpa versi |
| **Modul (CMake)** | **Proyek yang tumbuh** |
| Inline component (`component Nama: Tipe {}`) | Komponen kecil yang hanya dipakai satu berkas |

---

## 11. 8.1.8 (TAMBAHAN) Kebijakan CMake (QTP) dan `loadFromModule`

> Aturan bawaan yang diketahui adalah aturan yang tak mengejutkan.

### 11.1 Kebijakan yang memengaruhi modul

| Kebijakan | Efek bila `NEW` |
|---|---|
| **QTP0001** | `RESOURCE_PREFIX` bawaan menjadi `/qt/qml/`, yaitu import path bawaan, sehingga modul langsung ditemukan |
| **QTP0004** (Qt 6.8) | Setiap subfolder berisi QML mendapat `qmldir` tambahan dengan `prefer`, sehingga komponen di subfolder berbeda dalam satu modul saling terlihat |
| **QTP0005** | Dependensi dapat dirujuk lewat `TARGET` pada `IMPORTS`, `DEPENDENCIES`, dst. |

Cara mengaktifkan:

```cmake
qt_standard_project_setup(REQUIRES 6.8)   # mengaktifkan QTP0001 dan QTP0004
# atau satu per satu:
qt_policy(SET QTP0004 NEW)
```

**Contoh efek QTP0004:** bila modul punya `controls/MyButton.qml` dan `views/MyView.qml`, tanpa QTP0004 (`OLD`) `MyView` tidak menemukan `MyButton` kecuali dengan `import MyModule` eksplisit. Dengan `NEW`, keduanya saling terlihat. Qt 6.8 memberi peringatan bila kebijakan tak diatur secara eksplisit.

### 11.2 `loadFromModule`

Sejak Qt 6.5, memuat titik masuk lewat **URI modul dan nama tipe**, bukan jalur berkas:

```cpp
engine.loadFromModule("MyApp.App", "Main");
```

Keuntungannya: tidak ada jalur `qrc:/...` yang ditulis tangan, dan modul ditemukan lewat import path seperti biasa. Alternatifnya `engine.load(QUrl("qrc:/qt/qml/MyApp/App/Main.qml"))` lebih rapuh terhadap perubahan struktur.

---

## 12. 8.1.9 (TAMBAHAN) Keamanan: import path sebagai batas kepercayaan

> Siapa yang bisa menaruh berkas di rak, dialah yang bisa menulis kode Anda.

Dokumentasi menyatakan: **Qt menganggap semua berkas di bawah import path berasal dari sumber tepercaya.** Sebuah modul yang ditemukan di import path dapat berisi QML dan plugin C++. Artinya, siapa pun yang bisa menaruh berkas di salah satu lokasi itu dapat menjalankan kode di dalam aplikasi Anda.

**Praktik yang aman:**

| Praktik | Alasan |
|---|---|
| Tanam modul aplikasi di resource (`qrc:/qt/qml`, hasil default) | Tidak bisa diganti pengguna biasa |
| Kunci izin folder yang masuk import path (tidak dapat ditulis pengguna lain) | Mencegah penyisipan modul |
| Hati-hati dengan `QML_IMPORT_PATH` dan opsi `-I` pada lingkungan produksi | Variabel lingkungan bisa diubah oleh yang menjalankan aplikasi |
| Jangan memasukkan folder unduhan, `/tmp`, atau folder dapat-tulis ke import path | Itu jalur masuk kode asing |
| Jangan memuat modul QML dari jaringan tanpa saluran tepercaya | Direktori jarak jauh juga dieksekusi |
| Plugin C++ hanya dari sumber yang Anda bangun dan tanda tangani | Plugin berjalan sebagai kode asli |
| Pertimbangkan penggunaan bawaan tanpa variabel lingkungan untuk aplikasi terkeraskan | Kurangi permukaan serangan |
| Jangan mengaktifkan infrastruktur debug QML (`QT_QML_DEBUG`) di rilis | Dokumentasi memperingatkan ia dapat membahayakan integritas aplikasi dan sistem |

**Praktik tambahan bagi lingkungan yang ketat:** bangun rilis dengan Qt yang Anda kontrol, sertakan modul di resource, dan nonaktifkan jalur pencarian eksternal yang tak dibutuhkan. Detail penguatan penyebaran dibahas pada fase keamanan.

Jebakan: M12.

---

## 13. Penutup modul

### 13.1 Hubungan dengan modul lain

- **Prasyarat:** 5.1 (komponen dan API), 5.3 (tema dan singleton, yang di sini dipindah ke modul), 3.4 (scope dan konteks), jalur C++ dasar (`main.cpp` dan `QQmlApplicationEngine`).
- **8.2 Arsitektur Aplikasi:** batas modul menjadi tulang punggung lapisan. Aturan arah ketergantungan (8.1.6) dipakai di sana.
- **8.3 Struktur Proyek dan CMake Lanjutan:** menambah folder `src/`, preset, banyak target, dan `all_qmllint`. **Catatan dari audit:** tata letak `qml/App` dan `qml/Components` harus mengikuti target path untuk modul pustaka.
- **8.4 Konvensi, Linting, dan Disiplin Kualitas:** `qmllint` dan hook git memanfaatkan modul yang tertata (termasuk skrip `cek-lapisan.sh`).
- **Fase 10 (C++):** tipe C++ didaftarkan ke modul lewat `QML_ELEMENT`, dan plugin kustom (`NO_GENERATE_PLUGIN_SOURCE`) dibahas di sana.
- **Fase 13 (keamanan):** import path sebagai batas kepercayaan.

### 13.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| M1 | `module "X" is not installed` | URI di `import` berbeda dari URI di CMake, target belum tertaut, atau import path tak memuat lokasinya | Samakan URI, tautkan target, jalankan dengan `QML_IMPORT_TRACE=1` |
| M2 | Peringatan CMake soal struktur folder | Folder sumber modul pustaka tak mengikuti target path | Folder = URI dengan titik menjadi garis miring (`MyApp/Components/`) |
| M3 | Tipe tak ditemukan antarsubfolder padahal satu modul | Implicit import subfolder (QTP0004 `OLD`) | `qt_standard_project_setup(REQUIRES 6.8)` atau `qt_policy(SET QTP0004 NEW)` |
| M4 | Singleton tak dikenali | Hanya `pragma Singleton` tanpa `QT_QML_SINGLETON_TYPE`, atau sebaliknya | Lakukan keduanya, properti sebelum `qt_add_qml_module` |
| M5 | Modul jalan di IDE tetapi gagal di terminal | Import path tak diatur untuk `qml` | `qml -I build ...` atau `QML_IMPORT_PATH=build` |
| M6 | Modul tak termuat pada build statis | Plugin statis tak tertaut | `target_link_libraries(app PRIVATE <target>plugin)` dan, bila perlu, `Q_IMPORT_QML_PLUGIN` |
| M7 | Siklus antar-modul | Lapisan bawah mengimpor lapisan atas | Arah panah ke bawah; periksa dengan `cek-lapisan.sh` |
| M8 | Berkas tersimpan di `App/App/Main.qml` di resource | Mendaftarkan `App/Main.qml` dari CMake folder akar pada modul executable | Letakkan `CMakeLists.txt` di folder yang sama dengan berkasnya |
| M9 | Modul tak ditemukan setelah mengganti `RESOURCE_PREFIX` | Awalan baru tidak ada di import path | Pakai QTP0001 default, atau tambahkan awalan ke import path |
| M10 | `QML_IMPORT_PATH` dengan `qrc:/...` tak bekerja | Titik dua dianggap pemisah | Gunakan `QQmlEngine::addImportPath()` di kode |
| M11 | Versi internal modul menjadi beban | Memakai versi untuk mengatur kompatibilitas | Hilangkan `VERSION`, import tanpa versi, kelola versi lewat manajemen paket |
| M12 | Kode tak dikenal berjalan | Folder tak tepercaya berada di import path | Hanya folder tepercaya dan terkunci izinnya |
| M13 | Tipe baru tak ada walau berkasnya ada | Berkas tak didaftarkan di `QML_FILES`, atau CMake belum dijalankan ulang | Daftarkan di `QML_FILES` dan konfigurasi ulang |

### 13.3 Latihan 15 menit

**Persiapan:** pakai proyek contoh (bagian 3). Untuk melatih refaktor, mulailah dari keadaan "sebelum": satu modul di `App/` berisi `Main.qml`, `AppButton.qml`, dan `Theme.qml`.

```cmake
# App/CMakeLists.txt, keadaan "sebelum"
qt_add_executable(appMiniapp main.cpp)
qt_add_qml_module(appMiniapp
    URI MyApp.App
    QML_FILES Main.qml AppButton.qml Theme.qml
)
target_link_libraries(appMiniapp PRIVATE Qt6::Quick)
```

**Langkah:**

1. Sesuai kurikulum: buat `MyApp/Components/`, **pindahkan** `AppButton.qml` dan `Theme.qml` ke sana, dan buat `MyApp/Components/CMakeLists.txt` seperti di bagian 3 (jangan lupa properti singleton).
2. Tambahkan `add_subdirectory(MyApp/Components)` di akar, dan `MyAppComponents` plus `IMPORT_PATH ${CMAKE_BINARY_DIR}` di `App/CMakeLists.txt`. Hapus `AppButton.qml` dan `Theme.qml` dari `QML_FILES` modul app.
3. Tambahkan `import MyApp.Components` di `Main.qml`. Bangun dan jalankan.
4. Jalankan uji asap (bagian 3). Pastikan kode keluar `124`.
5. **Percobaan:** (a) ubah `import MyApp.Components` menjadi `import MyApp.Component` lalu jalankan uji asap, dan perhatikan kode keluar serta pesan galat. (b) Kembalikan, lalu jalankan `QML_IMPORT_TRACE=1 ./build/App/appMiniapp 2>&1 | grep -i MyApp`. (c) Hapus baris `set_source_files_properties(Theme.qml ...)` dan lihat apa yang terjadi pada `Theme`, lalu kembalikan. (d) Ganti nama folder `MyApp/Components` menjadi `Components` dan konfigurasi ulang untuk melihat peringatan struktur folder. Kembalikan setelahnya.
6. Jalankan `sh cek-lapisan.sh && echo 'lapisan aman'` dan `cmake --build build --target all_qmllint`.

**Tantangan 10 menit:** tambahkan modul `MyApp.Core` (`MyApp/Core/`) berisi singleton `Konfig.qml` (misalnya `readonly property string namaApp`). Buat `Components` mengimpornya, dan pastikan `cek-lapisan.sh` lolos. Lalu **sengaja** buat `Core` mengimpor `MyApp.Components` untuk melihat skrip mencegat pelanggaran dan bagaimana konfigurasi build bereaksi. Kembalikan ke keadaan benar.

### 13.4 Cek pemahaman

1. Bagaimana `QML_IMPORT_TRACE` membantu saat modul tidak ditemukan?
2. Mengapa folder sumber modul pustaka harus mengikuti URI?
3. Apa beda *backing library* dan plugin, dan kapan plugin dibutuhkan?
4. Mengapa singleton butuh dua langkah?
5. Mengapa `QML_IMPORT_PATH` tak bisa memuat jalur `qrc:`?
6. Mengapa dependensi siklik harus dihindari, dan bagaimana mencegatnya?
7. Mengapa import path adalah soal keamanan?

**Jawaban singkat:**

1. Ia menampilkan jejak pencarian mesin. Terlihat jalur mana yang dicoba dan di mana modul ditemukan. Bila tak ada baris keberhasilan, masalahnya URI, folder, atau import path.
2. Mesin dan alat menurunkan lokasi modul dari URI (titik menjadi garis miring). Bila folder tak cocok, CMake memperingatkan dan tooling bisa gagal menemukan modul.
3. Backing library berisi seluruh fungsi modul dan bisa ditaut langsung. Plugin adalah pemuat kecil untuk kasus modul tak tertaut (misalnya alat `qml`), dan pada build statis harus ditaut eksplisit.
4. `pragma Singleton` menandai berkasnya sebagai singleton, sedangkan `QT_QML_SINGLETON_TYPE` membuat baris `singleton` tertulis di `qmldir`. Keduanya dibutuhkan agar modul mengekspornya sebagai singleton.
5. Variabel itu memakai titik dua sebagai pemisah, sedangkan jalur dan URL resource mengandung titik dua. Jalur seperti itu harus ditambahkan lewat `QQmlEngine::addImportPath()`.
6. Siklus membuat modul saling terkunci: tak bisa dibangun, diuji, atau diganti sendiri, dan menyulitkan penaut serta alat. Cegat lewat arah `target_link_libraries`, `qmllint`, dan skrip pemeriksa impor.
7. Qt menganggap semua berkas di import path tepercaya. Siapa pun yang bisa menaruh modul di sana bisa menjalankan kode dalam aplikasi.

### 13.5 Referensi

Tautan `doc.qt.io` berikut saya temukan di halaman dokumentasi Qt 6.12 yang saya baca saat menyusun materi ini. Tautan CMake dari kurikulum tidak saya buka ulang.

- [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html) · [Module Definition qmldir Files](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html)
- [qt_add_qml_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [Tying it all together with CMake](https://doc.qt.io/qt-6/qtqml-modules-cmake-integration.html) · [Writing QML Modules](https://doc.qt.io/qt-6/qtqml-writing-a-module.html)
- [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [Building a reusable QML module](https://doc.qt.io/qt-6/cmake-build-reusable-qml-module.html)
- [Import Statements (termasuk QML Import Path)](https://doc.qt.io/qt-6/qtqml-syntax-imports.html) · [Importing QML Document Directories](https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html)
- [Identified Modules](https://doc.qt.io/qt-6/qtqml-modules-identifiedmodules.html) · [Creating C++ Plugins For QML](https://doc.qt.io/qt-6/qtqml-modules-cppplugins.html)
- [Debugging QML Applications (QML_IMPORT_TRACE)](https://doc.qt.io/qt-6/qtquick-debugging.html#debugging-module-imports)
- [QTP0004](https://doc.qt.io/qt-6/qt-cmake-policy-qtp0004.html) · [QTP0001](https://doc.qt.io/qt-6/qt-cmake-policy-qtp0001.html) · [QTP0005](https://doc.qt.io/qt-6/qt-cmake-policy-qtp0005.html) · [qt_standard_project_setup](https://doc.qt.io/qt-6/qt-standard-project-setup.html) · [qt_policy](https://doc.qt.io/qt-6/qt-policy.html)
- [Modernizing QML Modules](https://doc.qt.io/qt-6/qt6-modernize-qml-modules.html) · [Port QML modules to CMake](https://doc.qt.io/qt-6/qt6-port-to-qt-add-qml-module.html)
- [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- Komunitas: [Qt Forum](https://forum.qt.io/) · [Qt Academy](https://www.qt.io/academy)

---

# Modul 8.2: Arsitektur Aplikasi

*Fase 8: Modul QML dan Arsitektur Aplikasi*

## Daftar isi modul ini

1. Audit singkat sebelum materi
2. Fondasi: peran modul, konsep dan filosofi, terminologi, peta visual
3. Proyek contoh: aplikasi tugas berlapis (dipakai di seluruh sub-bab)
4. **8.2.1** Layering
5. **8.2.2** MVC/MVVM di QML
6. **8.2.3** Store dan state terpusat
7. **8.2.4** Navigasi sebagai tanggung jawab tersendiri
8. **8.2.5** Penanganan galat lintas layer
9. **8.2.6** Logika di QML vs di C++
10. **8.2.7** (TAMBAHAN) Injeksi dependensi dan pengujian
11. **8.2.8** (TAMBAHAN) Aliran data satu arah dan pencegahan loop umpan balik
12. **8.2.9** (TAMBAHAN) Keamanan arsitektur: batas kepercayaan antarlapisan
13. Penutup: hubungan modul, tabel kesalahan, latihan, cek pemahaman, referensi

---

## 1. Audit singkat

Saya membaca bagian 8.2 terhadap dokumentasi Qt 6.12 (*Best Practices for QML and Qt Quick*, *QML and C++ Integration*, `StackView`, `LoggingCategory`) dan terhadap Modul 8.1.

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Prasyarat: 8.1 (modul dan singleton), 7.1-7.2 (model dan view), 5.1, 6.3 (`Keys`, fokus) | Aman, tidak ada loncatan | Tidak ada |
| 2 | `Store.qml` memakai `property var` | Bertentangan dengan Best Practices | Dokumentasi menyarankan tipe konkret. `var` membuat lokasi galat menyesatkan dan menghalangi analisis statis. Diganti `ListModel` bertipe, sesuai catatan kurikulum sendiri |
| 3 | `signal tugasBerubah()` | Redundan | Mengubah properti sudah memancarkan sinyal perubahan otomatis (`daftarTugasChanged`). Sinyal manual dipertahankan hanya untuk **peristiwa** (misalnya `galat`) |
| 4 | `{ judul, selesai: false }` tanpa identitas | Rapuh | Baris diidentifikasi lewat judul. Ditambahkan `uid`. Catatan: **`id` tak bisa dipakai sebagai nama properti atau role** karena kata kunci QML |
| 5 | Tanpa validasi dan batas | Celah | Store adalah gerbang domain (kelanjutan 7.1.1 dan 7.4.2). Aturan di UI (`maximumLength`) hanya petunjuk, bukan keamanan |
| 6 | Singleton global | Perlu ditimbang | Praktis, tetapi menyulitkan pengujian dan melanggar arah lapisan bila diimpor komponen generik (8.1.6). Dibahas di 8.2.7 |
| 7 | Store yang membuka `ListModel` bisa dimutasi siapa pun | **Kebocoran pintu tunggal** | `readonly` hanya mengunci rujukan, bukan isinya. Solusi sejati: model C++ baca-saja. Di QML murni dijaga lewat skrip pemeriksa (8.2.9) |
| 8 | 8.2.5 tanpa mekanisme konkret | Kurang | Ditambahkan taksonomi galat, kode galat stabil, dan `LoggingCategory` |
| 9 | 8.2.4: `StackView` | Perlu fakta | Kepemilikan item, larangan anchor di akar item, dan *deep linking* ditambahkan. Navigasi dibuat satu pintu dengan daftar putih rute (kelanjutan 7.3.8) |
| 10 | 8.2.6: arah panduan Qt | Perlu rujukan | Qt menyarankan UI di QML, logika bisnis di C++, dan C++ tidak boleh menjangkau objek QML. Ditambahkan |
| 11 | Terminologi "MVC/MVVM" | Rawan salah paham | "Model/View" di Qt (7.1-7.2) adalah konsep **item model**, bukan MVC. Dijelaskan di 8.2.2 |
| 12 | Letak store dalam struktur modul 8.1 | Belum dipetakan | Store hidup di `MyApp.Features.Tugas`. Komponen generik (`Components`) tidak boleh mengimpornya |

**Pembaruan daftar isi kurikulum 8.2:** 8.2.1 sampai 8.2.6 tetap, ditambah **8.2.7** (Injeksi dependensi dan pengujian), **8.2.8** (Aliran satu arah), dan **8.2.9** (Keamanan arsitektur).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Modul 8.1 menjawab bagaimana kode dipecah menjadi modul. Modul ini menjawab **apa yang ditaruh di tiap bagian** dan **siapa boleh memanggil siapa**. Tanpa jawaban itu, aplikasi cepat berubah menjadi tumpukan komponen yang saling mengutak-atik data, di mana satu perubahan kecil merusak lima tempat. Hasil modul ini langsung dipakai oleh 8.3 (tata letak proyek) dan 8.4 (disiplin kualitas).

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Aplikasi seperti restoran:

| Restoran | Lapisan aplikasi |
|---|---|
| Ruang makan | **UI**: apa yang dilihat dan disentuh pengguna |
| Kasir dan pelayan | **Presentasi**: menerima pesanan, mengantar hasil, menjelaskan masalah |
| Dapur | **Domain**: aturan nyata (resep, takaran, batas) |
| Gudang | **Data**: tempat bahan tersimpan |

Pelanggan tidak masuk gudang, dan dapur tidak peduli warna taplak meja. Setiap lapisan hanya bicara dengan tetangganya.

Prinsip yang mendasarinya:

1. **Pemisahan tanggung jawab.** UI tidak menyimpan aturan bisnis. Domain tidak tahu tombol. Perubahan di satu lapisan tidak merembet.
2. **Properti turun, sinyal naik.** Keadaan mengalir dari store ke UI lewat properti dan binding. Niat pengguna naik dari UI ke store lewat sinyal atau pemanggilan fungsi.
3. **Satu sumber kebenaran.** Setiap fakta disimpan di satu tempat. Yang lain diturunkan lewat binding. Itulah mengapa bug sinkronisasi berkurang.
4. **Arah ketergantungan satu arah.** Mengikuti panah di 8.1.6: lapisan atas boleh memakai lapisan bawah, tidak sebaliknya.
5. **Pintu mutasi tunggal.** Data hanya berubah lewat perintah yang divalidasi.
6. **Keamanan.** Tiap lapisan tidak mempercayai lapisan di atasnya. Validasi ada di domain, bukan hanya di UI.

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **Layering** | Membagi aplikasi menjadi lapisan dengan tanggung jawab dan arah ketergantungan tertentu. |
| **MVC** | Model-View-Controller: controller menengahi input pengguna dan model. |
| **MVVM** | Model-View-ViewModel: ViewModel menyediakan properti turunan dan perintah, binding menghubungkannya ke View. |
| **Model/View (Qt)** | Konsep **item model** (`ListModel`, `QAbstractItemModel`) dan view, dibahas di 7.1-7.2. **Bukan** sinonim MVC. |
| **Store / state terpusat** | Objek yang memegang keadaan sebuah fitur dan menyediakan perintah untuk mengubahnya. |
| **Single source of truth** | Setiap fakta punya satu rumah. |
| **Perintah (command)** | Fungsi atau sinyal yang meminta perubahan. |
| **Keadaan turunan** | Nilai yang dihitung dari keadaan lain lewat binding (`jumlahSelesai`). |
| **Kode galat** | Penanda stabil untuk kegagalan (`judul_kosong`), terpisah dari teks tampilan. |
| **Dependency direction** | Arah siapa mengimpor siapa. |
| **Injeksi dependensi (DI)** | Memberikan dependensi dari luar (properti), bukan mengambilnya sendiri dari global. |
| **Router** | Objek yang memegang urusan navigasi. |
| **Interaction signal** | Sinyal yang hanya terpancar bila **pengguna** berinteraksi (`moved`, `textEdited`), berbeda dari sinyal perubahan nilai. |

### 2.4 Peta visual

**Diagram A: lapisan dan arah ketergantungan**

```
 +---------------------------+
 | UI           (View, Delegate, Components) |   <- hanya bicara dengan Presentasi
 +------------+--------------+
              |  properti turun (binding)  ^  sinyal / panggilan fungsi naik
              v                            |
 +---------------------------+
 | Presentasi   (Store / ViewModel)         |   <- keadaan layar, perintah, terjemah galat
 +------------+--------------+
              |
              v
 +---------------------------+
 | Domain       (aturan, validasi, batas)   |   <- tak tahu apa pun tentang UI
 +------------+--------------+
              |
              v
 +---------------------------+
 | Data         (jaringan, berkas, DB)      |   <- 7.4, dan C++ (Fase 10)
 +---------------------------+
```

**Diagram B: aliran satu arah**

```
 Pengguna --(klik/ketik)--> UI --perintah--> Store --memvalidasi--> Domain/Data
                             ^                  |
                             |  properti/binding |  hasil + keadaan baru
                             +------------------+
 (UI tidak menyalin data, ia hanya MENAMPILKAN properti store)
```

**Diagram C: pemetaan lapisan ke modul 8.1**

```
 App          ->  MyApp.App              (perakitan, router, titik masuk)
 Features     ->  MyApp.Features.Tugas   (TugasStore, TugasView, TugasDelegate)
 Components   ->  MyApp.Components       (komponen generik: tak tahu "tugas")
 Core         ->  MyApp.Core             (log, konstanta, utilitas domain)
 (panah import: dari atas ke bawah saja)
```

**Diagram D: memilih tempat logika**

```
Logika ini...
 +-- murni tampilan (warna, animasi, tata letak) ........... QML
 +-- keadaan layar ringan + perintah sederhana ............. QML (Store/ViewModel)
 +-- aturan bisnis penting, data besar, perhitungan berat .. C++
 +-- I/O, jaringan lanjutan, kripto, rahasia ............... C++
 +-- butuh uji unit tanpa UI, tipe kuat, banyak thread ...... C++
```

---

## 3. Proyek contoh: aplikasi tugas berlapis

Aplikasi ini mempraktikkan seluruh modul. Semua berkas ada di **satu folder** agar bisa dijalankan cepat dengan alat `qml`. Penempatan di modul 8.1 dibahas di 8.2.1.

```
tugas/
├── Main.qml              # perakitan + terjemahan galat (UI)
├── TugasView.qml         # ListView (fitur)
├── TugasDelegate.qml     # satu baris (UI murni, tanpa tahu store)
├── TugasStore.qml        # state + perintah + aturan (presentasi/domain)
└── uji_store.qml         # uji tanpa UI
```

### 3.1 Keadaan "sebelum" (anti-pola, dari kesalahan umum kurikulum)

```qml
import QtQuick

Item {
    width: 360; height: 260
    property int selesaiCount: 0

    ListModel { id: data }

    ListView {
        anchors { fill: parent; margins: 8 }
        model: data
        delegate: Rectangle {
            id: baris
            required property int index
            required property string judul
            required property bool selesai
            width: ListView.view.width; height: 34
            color: '#eeeeee'
            Text { x: 8; anchors.verticalCenter: parent.verticalCenter; text: baris.judul }

            TapHandler {
                onTapped: {                                  // logika bisnis di delegate
                    data.setProperty(baris.index, 'selesai', !baris.selesai)
                    let n = 0
                    for (let i = 0; i < data.count; ++i) if (data.get(i).selesai) ++n
                    selesaiCount = n                         // keadaan turunan dihitung manual
                }
            }
            TapHandler {
                acceptedButtons: Qt.RightButton
                onTapped: data.remove(baris.index)           // UI mengubah data langsung
            }
        }
    }
    Component.onCompleted: {
        data.append({ judul: 'A', selesai: false })
        data.append({ judul: 'B', selesai: false })
    }
}
```

Masalahnya: aturan ada di delegate, `selesaiCount` harus dihitung ulang di setiap tempat yang mengubah data (lupa satu saja dan angkanya salah), UI mengubah data tanpa validasi, dan tidak ada tempat untuk menguji logika tanpa UI.

### 3.2 `TugasStore.qml`

```qml
import QtQuick
import QtQml.Models

QtObject {
    id: root

    // ===== keadaan: sumber kebenaran tunggal =====
    readonly property ListModel tugas: ListModel { }
    readonly property int jumlah: tugas.count
    readonly property int jumlahSelesai: _selesai
    readonly property bool semuaSelesai: jumlah > 0 && jumlahSelesai === jumlah
    readonly property int maksTugas: 200
    readonly property int maksPanjang: 120

    // ===== peristiwa (BUKAN "data berubah"; itu sudah disediakan binding) =====
    signal galat(string kode)

    // ===== perintah: satu-satunya pintu mutasi =====
    function tambah(judul) {
        const j = typeof judul === 'string' ? judul.trim() : ''
        if (j === '') return _tolak('judul_kosong')
        if (j.length > maksPanjang) return _tolak('judul_terlalu_panjang')
        if (tugas.count >= maksTugas) return _tolak('batas_tercapai')
        tugas.append({ uid: _uidBerikut++, judul: j, selesai: false })
        _segarkan()
        return true
    }

    function alihkanSelesai(uid) {
        const i = _cari(uid)
        if (i < 0) return _tolak('tidak_ditemukan')
        tugas.setProperty(i, 'selesai', !tugas.get(i).selesai)
        _segarkan()
        return true
    }

    function hapus(uid) {
        const i = _cari(uid)
        if (i < 0) return _tolak('tidak_ditemukan')
        tugas.remove(i)
        _segarkan()
        return true
    }

    // ===== internal =====
    property int _selesai: 0
    property int _uidBerikut: 1

    readonly property LoggingCategory _log: LoggingCategory {
        name: 'miniapp.tugas'
        defaultLogLevel: LoggingCategory.Info
    }

    function _cari(uid) {
        for (let i = 0; i < tugas.count; ++i)
            if (tugas.get(i).uid === uid) return i
        return -1
    }

    function _segarkan() {
        let n = 0
        for (let i = 0; i < tugas.count; ++i)
            if (tugas.get(i).selesai) ++n
        _selesai = n
    }

    function _tolak(kode) {
        console.warn(_log, 'ditolak:', kode)
        galat(kode)
        return false
    }
}
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `QtObject` | Objek nirvisual: store tak punya tampilan. |
| `readonly property ListModel tugas: ListModel { }` | Model bertipe (bukan `var`), dibuat di tempat. `readonly` mengunci **rujukan** ke model, bukan isinya (lihat 8.2.9). |
| `readonly property int jumlah: tugas.count` | Keadaan turunan: binding yang hidup mengikuti `count`. |
| `jumlahSelesai: _selesai` | Dihitung ulang di satu tempat (`_segarkan`) setiap perintah selesai. |
| `signal galat(string kode)` | Sinyal **peristiwa**. Membawa kode stabil, bukan teks tampilan. |
| `typeof judul === 'string' ? judul.trim() : ''` | Gerbang masukan: bukan string berarti kosong. |
| `return _tolak('...')` | Penolakan seragam: catat, pancarkan sinyal, kembalikan `false`. |
| `uid: _uidBerikut++` | Identitas stabil, naik tiap tambah. Hanya penambahan yang sah yang menghabiskan nomor. |
| Role `uid` (bukan `id`) | `id` adalah kata kunci QML dan tidak bisa menjadi nama properti. |
| Awalan `_` | Konvensi "privat". |
| `LoggingCategory { name; defaultLogLevel }` | Kategori log bernama (di `QtQml`). Pesan bisa disaring lewat konfigurasi. |
| `console.warn(_log, 'ditolak:', kode)` | Kategori diberikan sebagai argumen pertama. |

### 3.3 `TugasDelegate.qml` (UI murni)

```qml
import QtQuick

Rectangle {
    id: root
    required property int uid
    required property string judul
    required property bool selesai

    signal alihkan(int uid)
    signal hapus(int uid)

    implicitHeight: 38
    radius: 4
    color: root.ListView.isCurrentItem ? '#ffd27f' : '#eeeeee'

    Text {
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        text: root.judul
        font.strikeout: root.selesai
        opacity: root.selesai ? 0.5 : 1
        textFormat: Text.PlainText
    }

    TapHandler { onTapped: root.alihkan(root.uid) }
    TapHandler { acceptedButtons: Qt.RightButton; onTapped: root.hapus(root.uid) }
}
```

Delegate ini tak mengenal store, hanya data (`required property`) dan niat (sinyal). Karena itu ia mudah dipakai ulang dan diuji.

### 3.4 `TugasView.qml`

```qml
import QtQuick

ListView {
    id: root
    required property TugasStore store

    clip: true
    spacing: 4
    model: root.store.tugas

    delegate: TugasDelegate {
        width: ListView.view.width
        onAlihkan: (uid) => root.store.alihkanSelesai(uid)
        onHapus: (uid) => root.store.hapus(uid)
    }

    Keys.onPressed: (event) => {
        if (root.currentIndex < 0) return
        const uid = root.store.tugas.get(root.currentIndex).uid
        if (event.key === Qt.Key_Space) {
            root.store.alihkanSelesai(uid); event.accepted = true
        } else if (event.key === Qt.Key_Delete) {
            root.store.hapus(uid); event.accepted = true
        }
    }
}
```

### 3.5 `Main.qml`

```qml
import QtQuick

Item {
    id: root
    width: 360; height: 320

    property string pesan: ''

    function terjemah(kode) {                      // presentasi: kode -> teks yang bisa diterjemahkan
        switch (kode) {
        case 'judul_kosong':          return qsTr('Judul tidak boleh kosong')
        case 'judul_terlalu_panjang': return qsTr('Judul terlalu panjang')
        case 'batas_tercapai':        return qsTr('Daftar penuh')
        case 'tidak_ditemukan':       return qsTr('Tugas tidak ditemukan')
        default:                      return qsTr('Terjadi galat')
        }
    }

    TugasStore {
        id: tugasStore
        onGalat: (kode) => {
            root.pesan = root.terjemah(kode)
            redamPesan.restart()
        }
    }

    Timer { id: redamPesan; interval: 2500; onTriggered: root.pesan = '' }

    Rectangle {
        x: 8; y: 8
        width: parent.width - 16; height: 32
        color: 'white'; border.color: '#999999'

        TextInput {
            id: input
            anchors { fill: parent; margins: 6 }
            maximumLength: 200
            focus: true
            KeyNavigation.tab: daftar
            Keys.onReturnPressed: { if (tugasStore.tambah(text)) text = '' }
        }
    }

    TugasView {
        id: daftar
        x: 8; y: 48
        width: parent.width - 16
        height: parent.height - 48 - 56
        store: tugasStore
        KeyNavigation.backtab: input
    }

    Text {
        x: 8; y: parent.height - 48
        text: qsTr('%1 tugas, %2 selesai').arg(tugasStore.jumlah).arg(tugasStore.jumlahSelesai)
    }
    Text {
        x: 8; y: parent.height - 28
        color: '#c0392b'
        text: root.pesan
        textFormat: Text.PlainText
    }
}
```

Id store diberi nama `tugasStore`, bukan `store`, agar `store: tugasStore` tidak ambigu dengan properti `store` milik `TugasView`.

**Menjalankan.** Cari nama biner QML seperti di modul sebelumnya, lalu jalankan dengan jendela:

```bash
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmllint|qmlformat)$'
qml Main.qml
```

Ketik judul lalu Enter untuk menambah. Tab memindahkan fokus ke daftar. Panah memilih baris, Spasi mengalihkan selesai, Delete menghapus. Klik kiri mengalihkan selesai dan klik kanan menghapus.

### 3.6 `uji_store.qml`: menguji logika tanpa UI

```qml
import QtQuick

Item {
    TugasStore {
        id: store
        onGalat: (kode) => console.log('galat:', kode)
    }

    Component.onCompleted: {
        console.log(store.tambah('Belajar QML'))
        console.log(store.tambah('   '))
        console.log(store.tambah('x'.repeat(200)))
        store.tambah('Tulis catatan')
        store.alihkanSelesai(1)
        console.log('jumlah =', store.jumlah, '| selesai =', store.jumlahSelesai)
        store.hapus(2)
        store.hapus(99)
        console.log('jumlah =', store.jumlah, '| selesai =', store.jumlahSelesai)
        Qt.quit()
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml uji_store.qml
```

**Keluaran yang diharapkan** (baris dengan awalan `miniapp.tugas:` berasal dari kategori log. Bentuk persisnya bergantung `QT_MESSAGE_PATTERN`):

```
qml: true
miniapp.tugas: ditolak: judul_kosong
qml: galat: judul_kosong
qml: false
miniapp.tugas: ditolak: judul_terlalu_panjang
qml: galat: judul_terlalu_panjang
qml: false
qml: jumlah = 2 | selesai = 1
miniapp.tugas: ditolak: tidak_ditemukan
qml: galat: tidak_ditemukan
qml: jumlah = 1 | selesai = 1
```

Seluruh logika ini terbukti tanpa satu pun elemen visual. Itulah nilai praktis pemisahan lapisan.

---

## 4. 8.2.1 Layering

> Lapisan yang jelas membuat perubahan menjadi lokal.

### 4.1 Empat lapisan dan wujudnya

| Lapisan | Tugas | Wujud | Letak di modul 8.1 | Boleh bergantung pada |
|---|---|---|---|---|
| **UI** | Rupa dan input | `Window`, view, delegate, komponen generik | `Components`, view di `Features`, `App` | Presentasi (lewat properti dan sinyal) |
| **Presentasi** | Keadaan layar, perintah, penerjemahan galat | Store / ViewModel (`QtObject` QML atau `QObject` C++) | `Features` | Domain |
| **Domain** | Aturan nyata: validasi, batas, entitas | Fungsi murni JS atau kelas C++ | `Core` | Data |
| **Data** | Simpan dan ambil: jaringan (7.4), berkas, DB | C++ (`QtNetwork`, `QtSql`), XHR | `Core` atau backend C++ | Tidak ada di atasnya |

**Pada proyek kecil**, presentasi dan domain boleh berdiam di satu store (seperti `TugasStore`). Saat tumbuh, pecah: aturan murni dipindah ke fungsi domain yang bisa diuji sendiri, akses data ke repositori, dan store hanya mengoordinasi.

### 4.2 Aturan emas

1. **Komponen generik tidak tahu domain.** `AppButton` tak boleh mengimpor `TugasStore`. Ia menerima properti dan memancarkan sinyal.
2. **Delegate tidak tahu store.** Data masuk lewat `required property`, niat keluar lewat sinyal. Perekatnya ada di view (`TugasView`).
3. **Store tidak tahu UI.** Ia tak menyebut `Window`, `Item`, atau warna. Ia memancarkan kode galat, bukan teks tampilan.
4. **Domain tidak tahu store.** Ia hanya fungsi dan aturan.

### 4.3 Menegakkan arah lapisan

Gunakan skrip `cek-lapisan.sh` dari 8.1.6, dan tambahkan aturan khusus bahwa `Components` tidak boleh menyebut tipe store:

```bash
# komponen generik tidak boleh mengenal store
if grep -rEn --include='*.qml' 'Store\b' MyApp/Components; then
    echo 'PELANGGARAN: Components menyebut Store' >&2; exit 1
fi
```

**Opsi lain untuk membagi aplikasi:**

| Opsi | Catatan |
|---|---|
| Berlapis (di atas) | Default. Cocok untuk sebagian besar aplikasi |
| Per fitur ("vertical slice") | Tiap fitur memuat UI, store, dan domainnya sendiri. Lapisan lintas fitur hanya `Core` dan `Components` |
| Tanpa lapisan (semua di satu QML) | Hanya prototipe sangat kecil |

Jebakan: R1, R2, R7.

---

## 5. 8.2.2 MVC/MVVM di QML

> Nama pola kurang penting dibanding aliran tanggung jawabnya.

### 5.1 Dua istilah yang sering tertukar

**Model/View di Qt** (7.1-7.2) adalah mekanisme **item model**: `ListModel` atau `QAbstractItemModel` sebagai data dan `ListView` sebagai penampil. **MVC/MVVM** adalah pola arsitektur aplikasi. Keduanya bisa dipakai bersamaan, tetapi bukan hal yang sama.

### 5.2 Pemetaan

| Pola | Model | View | Penghubung |
|---|---|---|---|
| **MVC** | Data dan aturan | Tampilan QML | **Controller** menangani input, memperbarui model, memilih view |
| **MVVM** | Data dan aturan (domain) | Tampilan QML yang deklaratif | **ViewModel** menyediakan properti turunan dan perintah. **Binding** menghubungkan View ke ViewModel |

QML condong ke **MVVM** karena binding properti adalah mekanisme pengikatan data bawaan. Pada `TugasStore`:

| Peran MVVM | Wujud |
|---|---|
| View | `Main.qml`, `TugasView`, `TugasDelegate` |
| ViewModel | `TugasStore` (properti `jumlah`, `jumlahSelesai`, `semuaSelesai`, dan perintah) |
| Model/domain | Aturan di dalam fungsi `tambah` (validasi, batas) dan, saat tumbuh, modul domain |

**Keadaan turunan adalah ciri khas ViewModel.** UI tidak menghitung `semuaSelesai`. Ia cukup mengikat:

```qml
CheckBox { checked: tugasStore.semuaSelesai }          // butuh QtQuick.Controls
Text { text: qsTr('Semua selesai!'); visible: tugasStore.semuaSelesai }
```

**Opsi lain:**

| Opsi | Kapan |
|---|---|
| MVVM (Store sebagai ViewModel) | Default untuk QML |
| MVC (controller imperatif) | Alur input kompleks yang berurutan |
| Aksi/reducer (`dispatch({ jenis, muatan })`) | Banyak sumber perubahan yang butuh jejak audit. Hindari bila berlebihan |

Jebakan: R2, R5.

---

## 6. 8.2.3 Store dan state terpusat

> Satu rumah untuk satu fakta, dan satu pintu untuk mengubahnya.

### 6.1 Ciri store yang baik

1. **Keadaan tunggal.** Tiap fakta disimpan sekali.
2. **Pintu tunggal.** Perubahan hanya lewat perintah (`tambah`, `hapus`, ...) yang memvalidasi masukan.
3. **Turunan lewat binding.** Nilai yang bisa dihitung tidak disimpan ganda.
4. **Antarmuka sempit.** Fungsi dan properti yang perlu saja. Detail memakai awalan `_`.
5. **Tipe konkret.** Dokumentasi menyarankan menghindari `property var`: bila nilai bertipe salah diberikan, galat menunjuk ke deklarasi properti, bukan ke tempat salah assign, dan analisis statis tak bisa membantu.
6. **Satu store per fitur.** Hindari "store dewa" yang memuat segalanya.
7. **Sinyal untuk peristiwa.** Perubahan nilai sudah disiarkan properti. Sinyal manual dipakai untuk kejadian (`galat`, `tugasDitambah`).

### 6.2 Versi singleton (sesuai contoh kurikulum)

Untuk membuat store global, isinya sama persis dengan `TugasStore.qml`, dengan satu baris tambahan di paling atas:

```qml
pragma Singleton
import QtQuick
import QtQml.Models

QtObject { /* isi sama dengan TugasStore.qml */ }
```

Di CMake (Modul 8.1.3), sebelum `qt_add_qml_module`:

```cmake
set_source_files_properties(TugasStore.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
```

Penggunaan: `TugasStore.tambah('...')`. Ini lebih ringkas daripada meneruskan referensi, tetapi punya harga (8.2.7).

### 6.3 Pilihan wujud store

| Opsi | Kelebihan | Kekurangan |
|---|---|---|
| **A. Singleton QML** (kurikulum) | Ringkas, global | Keadaan bersama, sulit diuji, mendorong impor sembarangan |
| **B. Instance + injeksi** (proyek contoh) | Mudah diuji dan diganti | Perlu meneruskan referensi |
| **C. `QObject` C++** (singleton atau didorong ke QML) | Tipe kuat, kinerja, aman thread | Perlu C++ (8.2.6) |
| **D. Model C++ baca-saja** | Pintu mutasi benar-benar tunggal | Butuh C++ (10.5) |

Jebakan: R2, R4, R5, R6.

---

## 7. 8.2.4 Navigasi sebagai tanggung jawab tersendiri

> Siapa yang menentukan ke mana pengguna pergi harus jelas satu orang.

Navigasi (halaman mana tampil, bagaimana kembali) adalah urusan tersendiri. Bila `push` dan `pop` tersebar di semua komponen, alur aplikasi mustahil dipahami. Satukan di satu **router**.

### 7.1 Fakta `StackView`

`StackView` (Qt Quick Controls, `import QtQuick.Controls`) menyediakan navigasi berbasis tumpukan:

- Operasi utama: `push()`, `pop()`, dan `replace()`. Item teratas adalah yang tampil. `pop()` pada tumpukan berkedalaman 1 atau 0 tidak berbuat apa pun.
- Properti: `depth`, `currentItem`, `empty`, `busy`, `initialItem`.
- `push(item, properties, operation)` menerima item, `Component`, atau URL. **Mendorong sebuah larik** menambahkan semua isinya (berguna untuk deep linking) dan hanya item terakhir yang dimuat.
- Sejak 6.7 ada `popToIndex`, `popToItem`, dan `popCurrentItem`.
- Menggunakan anchor pada akar item yang didorong ke StackView tidak didukung, karena transisi menganimasikan posisi. Anchor pada anak-anaknya tetap normal.
- **Kepemilikan:** StackView hanya memiliki item yang ia buat sendiri dari `Component` atau URL. Item yang Anda dorong sebagai objek tidak dihancurkan olehnya (selaras dengan 7.3.5).
- StackView tidak mewarisi ukuran implisit dari item yang didorong.
- Sinyal terlampir: `activated`, `deactivated`, `removed`, dan lainnya.

### 7.2 Router dengan daftar putih rute

```qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: jendela
    width: 320; height: 220
    visible: true

    QtObject {
        id: router
        // Daftar putih: hanya nama ini yang bisa dibuka
        readonly property var rute: ({
            'beranda': halamanBeranda,
            'detail': halamanDetail
        })

        function buka(nama, properti) {
            if (typeof nama !== 'string'
                || !Object.prototype.hasOwnProperty.call(rute, nama)) {
                console.warn('rute tidak dikenal:', nama)
                return false
            }
            tumpukan.push(rute[nama], properti || {})
            return true
        }

        function kembali() {
            if (tumpukan.depth > 1) tumpukan.pop()
        }
    }

    Component {
        id: halamanBeranda
        Item {
            Column {
                anchors.centerIn: parent
                spacing: 8
                Text { text: 'Beranda'; font.bold: true }
                Button { text: 'Buka detail'; onClicked: router.buka('detail', { judul: 'Tugas #1' }) }
            }
        }
    }

    Component {
        id: halamanDetail
        Item {
            required property string judul
            Column {
                anchors.centerIn: parent
                spacing: 8
                Text { text: 'Detail: ' + parent.parent.judul; textFormat: Text.PlainText }
                Button { text: 'Kembali'; onClicked: router.kembali() }
            }
        }
    }

    StackView {
        id: tumpukan
        anchors.fill: parent
        initialItem: halamanBeranda
    }

    Shortcut { sequence: 'Esc'; onActivated: router.kembali() }

    Component.onCompleted: router.buka('constructor')
}
```

**Keluaran di terminal:** `qml: rute tidak dikenal: constructor`. Penolakan nama rute yang bukan milik objek itu adalah praktik yang sama dengan daftar putih di 7.3.8.

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `rute: ({ 'beranda': halamanBeranda, ... })` | Peta nama ke `Component`. Daftar putih. Tanda kurung membuat `{}` terbaca sebagai objek. |
| `hasOwnProperty.call(rute, nama)` | Menolak nama dari rantai prototipe (`constructor`, `__proto__`). |
| `tumpukan.push(rute[nama], properti \|\| {})` | Mendorong komponen dengan properti awal. |
| `required property string judul` | Halaman mendeklarasikan data yang dibutuhkannya. |
| `parent.parent.judul` | Dari `Text` ke `Column` ke akar `Item`. Cara ini rapuh, jadi di proyek nyata beri id pada akar halaman. |
| `Shortcut { sequence: 'Esc' }` | Pintasan keyboard untuk "kembali". |
| `anchors.fill: parent` pada `StackView` | Anchor pada StackView sendiri boleh. Larangannya hanya pada akar item yang didorong. |

**Pola yang lebih bersih:** halaman hanya **memancarkan niat** (`signal bukaDetail(string judul)`) dan satu tempat perakitan (di `App`) yang menyambungkannya ke router. Dengan begitu halaman tak mengenal router, sama seperti delegate yang tak mengenal store.

**Opsi lain untuk navigasi:**

| Opsi | Kapan |
|---|---|
| `StackView` + router | Alur maju-mundur (default) |
| `SwipeView` / `TabBar` | Beberapa halaman sejajar |
| `Loader` dengan `source` dari daftar putih | Satu area yang berganti konten |
| `Drawer` / `Popup` | Panel sementara |

Jebakan: R13, R14.

---

## 8. 8.2.5 Penanganan galat lintas layer

> Galat yang dijelaskan dengan benar tidak membuat pengguna panik dan tidak membocorkan rahasia.

### 8.1 Tiga jenis galat

| Jenis | Contoh | Penanganan |
|---|---|---|
| **Galat domain** (aturan dilanggar) | Judul kosong, daftar penuh | Tolak, beri kode, tampilkan pesan ramah |
| **Galat teknis** (lingkungan gagal) | Jaringan putus, disk penuh, JSON rusak | Terjemahkan ke kode, tawarkan coba lagi, catat |
| **Galat pemrograman** (bug) | `undefined` di binding, indeks di luar rentang | Catat jelas, perbaiki. Jangan ditelan |

### 8.2 Aturan lintas lapisan

1. **Setiap lapisan menangani yang ia pahami.** Data hanya tahu "koneksi ditolak", domain tahu "judul kosong".
2. **Terjemahkan sebelum naik.** Galat teknis dari Data menjadi kode domain (`gagal_memuat`) sebelum sampai ke Presentasi. Jangan membocorkan jalur berkas, kueri SQL, atau trace ke UI.
3. **Kode galat stabil, teks di UI.** Store mengirim `judul_kosong`. `Main.qml` menerjemahkannya dengan `qsTr()`. Dokumentasi menyarankan semua string yang tampil ke pengguna dibuat dapat diterjemahkan sejak awal.
4. **Jangan menelan galat.** Setiap penolakan dicatat (log) dan disiarkan (sinyal).
5. **Jangan mencatat rahasia.** Catat kode dan identitas non-sensitif, bukan token atau isi pribadi.

### 8.3 Mekanisme yang tersedia

| Mekanisme | Contoh |
|---|---|
| Nilai kembali + sinyal | `tambah()` mengembalikan `false` dan memancarkan `galat('judul_kosong')` |
| Objek hasil | `{ ok: true, nilai: ... }` atau `{ ok: false, kode: '...' }`, seperti di 7.4.5 |
| `throw` / `try-catch` JS | Di dalam domain untuk alur luar biasa. Tangkap di batas lapisan |
| Penangan global di C++ | `qInstallMessageHandler` untuk pesan log dan sinyal `warnings` dari engine |

### 8.4 Log berkategori

Kategori log dapat diberikan sebagai argumen pertama `console.log()` dan kawan-kawannya, dan nama kategorinya akan dipakai sebagai kategori log. Dokumentasi juga menyarankan menaruh banyak definisi `LoggingCategory` dalam sebuah singleton karena pembuatan objek itu mahal:

```qml
// MyApp/Core/Log.qml
pragma Singleton
import QtQml

QtObject {
    readonly property LoggingCategory app: LoggingCategory {
        name: 'miniapp.app'; defaultLogLevel: LoggingCategory.Info
    }
    readonly property LoggingCategory tugas: LoggingCategory {
        name: 'miniapp.tugas'; defaultLogLevel: LoggingCategory.Info
    }
}
```

Pemakaian: `console.warn(Log.tugas, 'ditolak:', kode)`. Properti `name` dan `defaultLogLevel` harus ditetapkan saat deklarasi dan tidak bisa diubah kemudian. Penyaringan saat runtime tanpa kompilasi ulang:

```bash
QT_LOGGING_RULES='miniapp.tugas.debug=true' qml Main.qml     # nyalakan tingkat debug
QT_LOGGING_RULES='miniapp.*=false' qml Main.qml              # bungkam seluruh kategori miniapp
```

**Opsi lain:**

| Opsi | Kapan |
|---|---|
| Kode galat + sinyal (di atas) | UI perlu bereaksi |
| Objek hasil | Alur fungsional bertahap |
| `throw`/`catch` | Domain internal, alur luar biasa |
| Dialog global (`Popup`) | Galat yang menghentikan alur |

Jebakan: R9, R10, R11.

---

## 9. 8.2.6 Logika di QML vs di C++

> Pilih bahasa menurut tugasnya, bukan menurut kebiasaan.

### 9.1 Panduan resmi

Dokumentasi Qt menyarankan UI ditulis di QML (deklaratif, ringkas, enak untuk prototipe) dan logika bisnis di bahasa bertipe kuat seperti C++. Untuk data kecil dan statis, model QML cukup. Untuk data besar dan dinamis, gunakan C++. Dokumentasi integrasi QML dan C++ menegaskan bahwa kekuatan integrasi ini adalah mengimplementasikan UI di QML terpisah dari logika dan data di C++, dan pemisahan itu gagal bila sisi C++ mulai memanipulasi QML secara langsung.

### 9.2 Matriks keputusan

| Pertimbangan | QML | C++ |
|---|---|---|
| Tampilan, animasi, tata letak | **Ya** | Tidak |
| Keadaan layar dan perintah ringan | Cukup | Opsional |
| Aturan bisnis penting | Terbatas | **Lebih baik** (tipe kuat, uji unit) |
| Data besar, perhitungan berat | Hindari | **Ya** |
| Thread dan I/O lanjutan | Terbatas (`WorkerScript`) | **Ya** |
| Rahasia (kunci, token) | **Jangan** | **Ya** |
| Kecepatan iterasi desain | **Ya** | Lambat |
| Refaktor | Mudah | Lebih berat |

### 9.3 Cara mengekspos C++ ke QML

Dokumentasi menyarankan menjaga tipe C++ **tidak sadar akan QML** dengan "mendorong" rujukan ke QML, lewat `required property` yang diisi dengan `QQmlApplicationEngine::setInitialProperties`, atau lewat satu atau beberapa singleton.

```cpp
// tugasstore.h
#pragma once
#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class TugasStore : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int jumlah READ jumlah NOTIFY jumlahBerubah FINAL)
public:
    explicit TugasStore(QObject *parent = nullptr) : QObject(parent) {}

    int jumlah() const { return m_judul.size(); }

    Q_INVOKABLE bool tambah(const QString &judul)
    {
        const QString j = judul.trimmed();
        if (j.isEmpty() || j.size() > 120 || m_judul.size() >= 1000) {
            emit galat(QStringLiteral("ditolak"));
            return false;
        }
        m_judul.append(j);
        emit jumlahBerubah();
        return true;
    }

signals:
    void jumlahBerubah();
    void galat(const QString &kode);

private:
    QStringList m_judul;
};
```

```cpp
// main.cpp (cuplikan): C++ mendorong rujukan ke QML
TugasStore store;                       // dideklarasikan SEBELUM engine: dihancurkan sesudahnya
QQmlApplicationEngine engine;
engine.setInitialProperties({ { QStringLiteral("store"), QVariant::fromValue(&store) } });
engine.loadFromModule("MyApp.App", "Main");
```

```qml
// Main.qml: QML menerima, tidak "meraih"
required property TugasStore store
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `QML_ELEMENT` | Mendaftarkan kelas sebagai tipe QML (modul 8.1). |
| `Q_PROPERTY(... NOTIFY ... FINAL)` | Properti yang bisa diikat dari QML. `NOTIFY` memberi tahu perubahan. |
| `Q_INVOKABLE` | Metode yang bisa dipanggil dari QML. |
| `setInitialProperties` | Mengisi `required property` pada objek akar sebelum dibuat. |
| `QVariant::fromValue(&store)` | Membungkus penunjuk objek untuk diberikan ke QML. |
| Urutan deklarasi | Objek yang dirujuk harus hidup lebih lama dari engine. |

**Opsi lain mengekspos C++:** singleton (`QML_SINGLETON` bersama `QML_ELEMENT`), tipe yang dibuat di QML (`QML_ELEMENT`), atau context property. Yang terakhir **tidak dianjurkan**: tak terlihat alat dan memicu kerapuhan di mode `Bound` (7.2.4). Rincian ada di Fase 10 dan di dokumentasi *Choosing the Correct Integration Method Between C++ and QML*.

Jebakan: R3, R16.

---

## 10. 8.2.7 (TAMBAHAN) Injeksi dependensi dan pengujian

> Yang mudah diganti mudah diuji.

**Singleton vs injeksi:**

| | Singleton global | Injeksi (`required property`) |
|---|---|---|
| Akses | Dari mana pun | Hanya yang diberi |
| Pengujian | Keadaan bersama antar-uji, butuh `reset()` | Beri tiruan (fake) per uji |
| Arah ketergantungan | Mudah dilanggar (siapa pun mengimpor) | Terlihat di API komponen |
| Kesederhanaan | Tinggi | Perlu meneruskan referensi |
| Cocok untuk | Layanan tanpa keadaan (tema, log, konfigurasi) | **Store dengan keadaan** |

**Aturan praktis:** singleton untuk hal tanpa keadaan atau yang memang tunggal (`Theme`, `Log`, `Konfig`). Injeksi untuk store berkeadaan.

**Menguji view dengan store tiruan:** karena `TugasView` hanya butuh sesuatu yang bertipe `TugasStore`, uji dapat memberinya instance baru yang diisi sesuai skenario. Untuk menguji tanpa UI sama sekali, gunakan skrip seperti `uji_store.qml` (3.6).

**Pengujian terstruktur:** `QtTest` menyediakan `TestCase` dan runner `qmltestrunner`. Cari binernya dengan perintah yang sama:

```bash
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmltestrunner)$'
```

Pengujian terstruktur dibahas pada modul pengujian di fase berikutnya, jadi di sini cukup memakai skrip pencetak log.

---

## 11. 8.2.8 (TAMBAHAN) Aliran data satu arah dan pencegahan loop umpan balik

> Saat dua pihak saling mengabari, siapkan aturan siapa yang berhak berbicara.

Aliran sehat: **keadaan turun** (store ke UI lewat binding), **niat naik** (UI ke store lewat perintah). Masalah muncul bila UI menulis balik setiap kali nilainya berubah.

Dokumentasi Best Practices menyarankan **sinyal interaksi** dibanding sinyal perubahan nilai. Contoh `Slider`: `valueChanged` dipancarkan juga saat nilai berubah karena pembulatan atau pembatasan otomatis, dan itu dapat memicu kaskade peristiwa. `moved` hanya terpancar saat **pengguna** menggerakkan kontrol.

```qml
Slider {
    value: store.volume                  // keadaan turun
    onMoved: store.setVolume(value)      // niat naik, hanya saat pengguna menggerakkan
    // JANGAN: onValueChanged: store.setVolume(value)   <- rawan kaskade
}
```

Pada kolom teks, padanannya `textEdited` (dipancarkan saat pengguna mengubah teks), bukan `textChanged`:

```qml
TextInput {
    text: store.kataKunci
    onTextEdited: store.setKataKunci(text)
}
```

**Aturan tambahan dari dokumentasi:**

- **Utamakan binding deklaratif dibanding penugasan imperatif.** `Component.onCompleted: color = 'red'` lebih lambat, menunda galat ke runtime, menimpa binding yang ada, dan mengganggu tooling. Tulis `color: 'red'`.
- **Jangan menyimpan keadaan di delegate** (7.2). Simpan di model atau store.

Jebakan: R2, R12.

---

## 12. 8.2.9 (TAMBAHAN) Keamanan arsitektur: batas kepercayaan antarlapisan

> Tiap pintu butuh penjaga sendiri, jangan berharap penjaga di depan sudah cukup.

| Prinsip | Penerapan |
|---|---|
| **Jangan percaya lapisan atas** | Store tetap memvalidasi walau UI sudah membatasi. `maximumLength: 200` di UI hanyalah kenyamanan, aturan sebenarnya (120) ada di store |
| **Pintu mutasi tunggal** | Hanya perintah store yang boleh mengubah data |
| **Hak akses minimum** | Antarmuka store sempit. Detail memakai awalan `_` dan tidak dipakai di luar |
| **Rahasia di C++** | Token dan kunci tidak ditaruh di QML. Kode klien bukan tempat rahasia |
| **Log aman** | Catat kode dan identitas non-sensitif, jangan token atau isi pribadi |
| **Batas ukuran dan jumlah** | `maksTugas`, `maksPanjang` di domain |
| **Teks tampilan polos** | `Text.PlainText` untuk data dari luar |
| **Daftar putih** | Rute dan komponen yang boleh dibuka (7.3.8, 8.2.4) |

**Kebocoran pintu tunggal pada store QML murni.** `readonly property ListModel tugas` hanya mengunci rujukannya. Siapa pun yang memegang store masih bisa memanggil `store.tugas.append(...)` dan melewati validasi. Di QML murni, jaga dengan disiplin dan pagar otomatis. Skrip `cek-mutasi.sh` ini melaporkan mutasi di luar store:

```bash
#!/bin/sh
# cek-mutasi.sh: model hanya boleh diubah di TugasStore.qml
if grep -rEn --include='*.qml' --exclude='TugasStore.qml' \
     '\.tugas\.(append|insert|remove|clear|set|setProperty|move)\(' .; then
    echo 'PELANGGARAN: model diubah di luar TugasStore' >&2
    exit 1
fi
echo 'pintu mutasi aman'
```

Solusi sejati: **model C++ baca-saja** (hanya `rowCount()`, `data()`, dan `roleNames()` tanpa metode penulisan), sehingga QML tidak mampu mengubahnya (Modul 10.5).

---

## 13. Penutup modul

### 13.1 Hubungan dengan modul lain

- **Prasyarat:** 8.1 (modul, singleton, arah ketergantungan), 7.1-7.2 (model, view, `required property`), 7.3.8 (daftar putih), 7.4 (galat jaringan), 5.1 (komponen sebagai API).
- **8.3 Struktur Proyek dan CMake Lanjutan:** menaruh folder `qml/` dan `src/` untuk lapisan ini. Ingat catatan dari 8.1 tentang folder modul pustaka yang harus mengikuti URI.
- **8.4 Konvensi, Linting, dan Disiplin Kualitas:** skrip `cek-lapisan.sh` dan `cek-mutasi.sh` menjadi bahan hook git dan CI.
- **Modul 10.5:** model C++ baca-saja dan `QAbstractListModel`.
- **Fase 10 (C++):** `QML_SINGLETON`, `setInitialProperties`, dan menaruh logika di C++.
- **Modul pengujian (fase berikutnya):** `QtTest` dan uji store tanpa UI.
- **Fase 13 (keamanan):** batas kepercayaan, validasi di domain, rahasia di C++.

### 13.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| R1 | Logika tersebar di delegate | Aturan bisnis ditulis di handler UI | Pindahkan ke store. Delegate hanya memancarkan sinyal |
| R2 | Angka tak sinkron di beberapa tempat | Keadaan disalin ke banyak komponen | Satu sumber kebenaran. Turunkan lewat binding |
| R3 | Data berubah tanpa validasi | UI memanggil `model.append` langsung | Hanya lewat perintah store. Skrip `cek-mutasi.sh` atau model C++ baca-saja |
| R4 | Galat tipe sulit dilacak | `property var` untuk keadaan | Tipe konkret (`ListModel`, tipe C++) |
| R5 | Sinyal ganda dan bingung | `signal xBerubah()` manual padahal ada sinyal otomatis | Pakai sinyal perubahan properti. Sinyal manual hanya untuk peristiwa |
| R6 | Satu store raksasa | Semua fitur di satu tempat | Satu store per fitur dengan antarmuka sempit |
| R7 | Komponen generik mengenal domain | `AppButton` mengimpor atau menyebut store | Komponen hanya menerima properti dan memancarkan sinyal |
| R8 | Uji saling mengotori | Singleton berkeadaan bersama | Injeksi, atau sediakan `reset()` |
| R9 | Pesan galat bercampur dengan logika | Teks tampilan dikirim dari domain | Kode stabil di domain. Terjemahan `qsTr()` di UI |
| R10 | Galat menghilang | Ditelan tanpa log atau sinyal | Log berkategori dan sinyal |
| R11 | Rahasia atau jalur internal tampil | Detail teknis dibocorkan ke UI atau log | Terjemahkan ke kode. Jangan catat rahasia |
| R12 | Nilai berloncatan atau berulang | `onValueChanged`/`onTextChanged` menulis balik | Sinyal interaksi (`onMoved`, `onTextEdited`) |
| R13 | Alur aplikasi tak terlacak | `push`/`pop` tersebar | Satu router dengan daftar putih rute |
| R14 | Transisi `StackView` rusak | Anchor pada akar item yang didorong | Pakai ukuran biasa pada akar, anchor pada anak |
| R15 | Data buruk lolos | Validasi hanya di UI | Aturan di domain dan store |
| R16 | Refaktor QML merusak C++ | C++ meraih objek QML (`findChild`) | Dorong rujukan ke QML (`required property`, `setInitialProperties`) |

### 13.3 Latihan 15 menit

**Persiapan terminal** (nama biner dari `pacman -Ql`, seperti di 3.5):

```bash
qml Main.qml                                          # dengan jendela
QT_QPA_PLATFORM=offscreen qml uji_store.qml           # uji tanpa UI
qmllint Main.qml TugasStore.qml TugasView.qml TugasDelegate.qml
```

**Langkah:**

1. Salin keadaan "sebelum" (3.1) ke `sebelum.qml` dan jalankan. Klik baris untuk mengalihkan selesai.
2. Sesuai kurikulum: **pindahkan** logika tambah/hapus/alih dari delegate ke `TugasStore.qml` (3.2), dan ubah delegate menjadi seperti `TugasDelegate.qml`, yang hanya memanggil fungsi store lewat sinyal.
3. Jalankan `uji_store.qml` dan cocokkan keluarannya dengan 3.6.
4. Jalankan `Main.qml`. Coba menambah judul kosong dan judul 150 karakter, dan amati pesan di UI serta log di terminal.
5. Jalankan dengan `QT_LOGGING_RULES='miniapp.*=false'` dan perhatikan log kategori `miniapp.tugas` ikut terbungkam, sementara pesan UI tetap tampil.
6. Jalankan `qmllint` dan rapikan peringatannya.

**Tantangan 10 menit:** (a) tulis `cek-mutasi.sh` (8.2.9), lalu **sengaja** menambah `tugasStore.tugas.append(...)` di `Main.qml` dan lihat skrip menangkapnya. (b) Ubah `TugasStore` menjadi singleton dengan menaruhnya di proyek 8.1 (`MyApp.Features.Tugas`), lalu pastikan `AppButton` di `MyApp.Components` tetap **tidak** menyebut store (jalankan `cek-lapisan.sh`). (c) Tambahkan router (8.2.4) dengan halaman "detail tugas", dan pastikan rute selain daftar putih ditolak.

### 13.4 Cek pemahaman

1. Mengapa satu sumber kebenaran mengurangi bug sinkronisasi?
2. Mengapa delegate sebaiknya tidak mengenal store?
3. Apa beda "Model/View" di Qt dengan MVC/MVVM?
4. Mengapa store mengirim **kode** galat dan bukan teks?
5. Mengapa `property var` tidak disarankan untuk keadaan?
6. Mengapa `onMoved` lebih aman daripada `onValueChanged` untuk menulis ke store?
7. Mengapa `readonly property ListModel` belum cukup menjaga pintu mutasi tunggal?
8. Kapan logika sebaiknya pindah ke C++?

**Jawaban singkat:**

1. Setiap fakta punya satu rumah. Salinan di tempat lain hanya turunan lewat binding, sehingga tak bisa menyimpang satu sama lain.
2. Delegate yang hanya menerima data dan memancarkan niat mudah dipakai ulang dan diuji. Perekatnya di view.
3. Model/View di Qt adalah mekanisme item model dan view (7.1-7.2). MVC/MVVM adalah pola pembagian tanggung jawab aplikasi. Keduanya dapat dipakai bersama.
4. Kode stabil dapat diterjemahkan di UI (`qsTr`), diuji, dan tidak membocorkan detail internal.
5. Galat tipe menunjuk ke deklarasi properti, bukan ke tempat salah assign, dan analisis statis tak bisa memeriksanya.
6. `valueChanged` juga terpancar saat nilai berubah otomatis (pembulatan, pembatasan), memicu kaskade. `moved` hanya terpancar saat pengguna berinteraksi.
7. `readonly` mengunci rujukan, bukan isi. Siapa pun yang memegang store masih bisa memanggil `append` dan lain-lain. Solusi sejati adalah model C++ baca-saja.
8. Saat butuh aturan bisnis penting, data besar, kinerja, thread, rahasia, atau uji unit tanpa UI. UI dan keadaan layar ringan tetap di QML.

### 13.5 Referensi

Tautan di bawah ini muncul pada halaman dokumentasi Qt 6.12 yang saya baca saat menyusun materi ini. Tautan kurikulum (*QML Coding Conventions*, *Qt Quick Best Practices*) sudah saya baca langsung.

- [Best Practices for QML and Qt Quick](https://doc.qt.io/qt-6/qtquick-bestpractices.html) · [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html)
- [Overview: QML and C++ Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html) · [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html)
- [QQmlApplicationEngine::setInitialProperties](https://doc.qt.io/qt-6/qqmlapplicationengine.html#setInitialProperties)
- [StackView](https://doc.qt.io/qt-6/qml-qtquick-controls-stackview.html) · [LoggingCategory](https://doc.qt.io/qt-6/qml-qtqml-loggingcategory.html)
- [ListView: Avoid Storing State in Delegates](https://doc.qt.io/qt-6/qml-qtquick-listview.html#avoid-storing-state-in-delegates)
- [Writing Source Code for Translation](https://doc.qt.io/qt-6/i18n-source-translation.html)
- Dari modul sebelumnya: [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html) · [Handling Untrusted Data](https://doc.qt.io/qt-6/untrusteddata.html)
- Komunitas: [Qt Forum](https://forum.qt.io/) · [Qt Academy](https://www.qt.io/academy)

---

# Modul 8.3: Struktur Proyek dan CMake Lanjutan

*Fase 8: Modul QML dan Arsitektur Aplikasi*

## Daftar isi modul ini

1. Audit singkat sebelum materi
2. Fondasi: peran modul, konsep dan filosofi, terminologi, peta visual
3. Proyek contoh lengkap (dipakai di seluruh sub-bab)
4. **8.3.1** Tata letak folder
5. **8.3.2** `QML_FILES`, `SOURCES`, `RESOURCES`
6. **8.3.3** Banyak modul dan target
7. **8.3.4** Preset dan konfigurasi Debug/Release
8. **8.3.5** `compile_commands.json` untuk clangd
9. **8.3.6** `qmllint` sebagai target build
10. **8.3.7** (TAMBAHAN) Varian build: sanitizer dan pengerasan (hardening)
11. **8.3.8** (TAMBAHAN) Integrasi editor terminal, `.gitignore`, dan pengujian di CMake
12. Penutup: hubungan modul, tabel kesalahan, latihan, cek pemahaman, referensi

---

## 1. Audit singkat

Saya membaca bagian 8.3 terhadap dokumentasi *CMake Presets* (CMake 4.5), Qt 6.12 (`qt_add_qml_module`, *Building a QML application*, *Best Practices*, `QT_QML_GENERATE_QMLLS_INI`), dan terhadap temuan Modul 8.1.

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Prasyarat: 8.1 (modul, URI, folder), 8.2 (lapisan), dasar CMake | Aman, tidak ada loncatan | Tidak ada |
| 2 | Pohon `qml/App` dan `qml/Components` | **Tidak sesuai target path** (sudah diperingatkan di audit 8.1) | Untuk modul pustaka, folder harus mengikuti URI. Dikoreksi menjadi `qml/MyApp/App/` dan `qml/MyApp/Components/` |
| 3 | Executable sebagai modul `MyApp.App` (8.1) vs pohon 8.3 yang punya `src/` | Perlu direkonsiliasi | Executable dibuat **tipis** (`src/main.cpp` saja). Modul `MyApp.App` menjadi pustaka QML biasa yang dimuat lewat `loadFromModule`. Konsisten dengan aturan "satu folder = satu modul" |
| 4 | `cmake --preset debug && cmake --build --preset debug` | Benar, tetapi butuh preset build bernama `debug` | Preset konfigurasi dan preset build adalah dua daftar terpisah. Keduanya ditulis di 8.3.4 |
| 5 | `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` di baris perintah | Lebih baik di preset | Dipindah ke `cacheVariables` agar tak terlupa dan terdokumentasi |
| 6 | `all_qmllint` | Berfungsi, tetapi butuh `IMPORT_PATH` | Lint memerlukan lokasi modul dependensi. Ditambahkan `QT_QML_OUTPUT_DIRECTORY` dan `IMPORT_PATH` |
| 7 | Pengaturan editor untuk QML | Perlu diperbarui | Variabel `QT_QML_GENERATE_QMLLS_INI` **usang sejak Qt 6.10**. Dibahas di 8.3.6 |
| 8 | Pustaka modul bisa "hilang" saat dijalankan | Belum ada | Penaut dapat membuang pustaka yang tampak tak terpakai. Ditambahkan pemeriksaan `ldd` di 8.3.3 |
| 9 | Varian build (sanitizer, hardening) | Belum ada | TAMBAHAN 8.3.7 |
| 10 | Pengujian dan `tests/` | Folder ada, isi belum | TAMBAHAN 8.3.8: CTest, test preset, workflow preset |
| 11 | `.gitignore`, `CMakeUserPresets.json`, rahasia di preset | Belum ada | 8.3.8 |

**Pembaruan daftar isi kurikulum 8.3:** 8.3.1 sampai 8.3.6 tetap, ditambah **8.3.7** (Varian build dan hardening) dan **8.3.8** (Integrasi editor, `.gitignore`, dan pengujian).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Modul 8.1 memecah kode menjadi modul, dan 8.2 membagi tanggung jawab antarlapisan. Modul ini menjawab bagaimana semua itu **ditata di disk dan dibangun dengan andal**: folder mana berisi apa, target mana bergantung pada target mana, dan bagaimana setiap orang (dan setiap CI) membangun proyek dengan cara yang sama persis. Tanpa disiplin ini, pola "bekerja di mesin saya" muncul dan jadwal rilis tersendat.

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Proyek yang rapi seperti dapur yang tertata: orang baru langsung tahu di mana pisau dan piring. Tiap benda punya tempat tetap, dan hasil masakan (build) tidak pernah diletakkan di dalam laci bumbu (source).

Prinsip yang mendasarinya:

1. **Struktur adalah dokumentasi.** Folder yang konsisten mengurangi kebutuhan menjelaskan.
2. **Pisahkan source dari build.** Build adalah turunan yang bisa dibuang kapan saja. Source adalah satu-satunya yang berharga.
3. **Perilaku dibuat eksplisit dan dapat dibagikan.** Preset menuliskan "cara membangun" dalam berkas yang masuk Git, bukan di ingatan seseorang.
4. **Satu perintah, satu hasil.** `cmake --preset debug` memberi hasil identik di laptop, di CI, dan di mesin kolega.
5. **Otomasi menegakkan disiplin.** Lint, uji lapisan, dan uji asap dijalankan sebagai bagian dari build, bukan niat baik.
6. **Keamanan rantai build.** Preset yang masuk repo tidak boleh memuat rahasia. Rilis dibangun dengan flag pengerasan yang diverifikasi. Sanitizer dipakai di pengembangan.

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **Target** | Unit yang dibangun CMake: executable, pustaka, atau target kustom (`all_qmllint`). |
| **Backing target** | Target pustaka yang menampung isi sebuah modul QML (8.1). |
| **Out-of-source build** | Membangun di folder terpisah dari source. |
| **Preset** | Konfigurasi bernama di `CMakePresets.json` untuk configure, build, test, package, atau workflow. |
| **`CMakeUserPresets.json`** | Preset pribadi pengembang. **Tidak** dikomit ke Git. |
| **Hidden preset** | Preset yang hanya dipakai sebagai induk pewarisan, tidak bisa dijalankan langsung. |
| **`inherits`** | Pewarisan antar-preset. |
| **Workflow preset** | Rangkaian configure, build, test, package dalam satu perintah. |
| **`compile_commands.json`** | Basis data perintah kompilasi, dibaca `clangd` untuk memahami kode C++. |
| **`QML_FILES`** | Daftar berkas QML, `.js`, atau `.mjs` anggota modul. |
| **`SOURCES`** | Berkas C++ anggota modul. |
| **`RESOURCES`** | Berkas non-QML (gambar, font, data) yang ditanam di resource modul. |
| **`all_qmllint`** | Target yang menjalankan `qmllint` untuk semua modul QML. |
| **`QT_QML_OUTPUT_DIRECTORY`** | Variabel yang memusatkan lokasi keluaran semua modul QML di folder build. |
| **Sanitizer** | Alat deteksi galat memori dan perilaku tak terdefinisi saat runtime (`-fsanitize=...`). |
| **Hardening** | Flag kompilasi dan penaut yang mempersulit eksploitasi. |

### 2.4 Peta visual

**Diagram A: target dan dependensinya**

```
 appMiniapp            (src/            : executable tipis, hanya main.cpp)
   |
   +--> MyAppApp         (qml/MyApp/App        : modul MyApp.App)
   |        |
   |        v
   +--> MyAppComponents  (qml/MyApp/Components : modul MyApp.Components)
            |
            v
         Qt6::Quick
 (panah = "bergantung pada"; tidak ada panah balik)
```

**Diagram B: pewarisan preset**

```
 base (hidden)   Ninja, binaryDir = build/${presetName}, compile_commands
   |
   +-- debug             CMAKE_BUILD_TYPE=Debug
   |      +-- asan       + sanitizer
   +-- release           CMAKE_BUILD_TYPE=Release
          +-- release-hardened   + flag pengerasan

 buildPresets : debug | release | asan | lint (target all_qmllint)
 testPresets  : debug
 workflow ci  : configure(debug) -> build(debug) -> build(lint) -> test(debug)
```

**Diagram C: source dan build terpisah**

```
 app/                                   app/build/<preset>/        (diabaikan Git)
  |-- CMakeLists.txt                      |-- CMakeCache.txt
  |-- CMakePresets.json                   |-- compile_commands.json
  |-- src/        qml/        tests/      |-- qml/MyApp/Components/qmldir
  +-- (hanya ini yang masuk Git)          +-- src/appMiniapp
 buang build = rm -rf build/<preset>  -> source tak tersentuh
```

**Diagram D: jalur resource sebuah berkas**

```
 sumber : qml/MyApp/Components/AppButton.qml
 resource: awalan  +  target path    +  jalur relatif
           /qt/qml  +  MyApp/Components +  AppButton.qml
        => qrc:/qt/qml/MyApp/Components/AppButton.qml
```

---

## 3. Proyek contoh lengkap

Ini evolusi proyek `miniapp` dari Modul 8.1, dengan executable yang dibuat tipis dan struktur yang sudah dikoreksi:

```
app/
├── CMakeLists.txt
├── CMakePresets.json
├── .gitignore
├── src/
│   ├── CMakeLists.txt
│   └── main.cpp
├── qml/
│   └── MyApp/
│       ├── App/
│       │   ├── CMakeLists.txt        # modul MyApp.App
│       │   └── Main.qml
│       └── Components/
│           ├── CMakeLists.txt        # modul MyApp.Components
│           ├── AppButton.qml
│           └── Theme.qml
├── tests/
│   └── CMakeLists.txt
└── tools/
    └── cek-lapisan.sh
```

**`CMakeLists.txt` (akar):**

```cmake
cmake_minimum_required(VERSION 3.25)
project(miniapp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# semua modul QML dikeluarkan ke satu pohon di folder build
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(qml/MyApp/Components)
add_subdirectory(qml/MyApp/App)
add_subdirectory(src)

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
```

**`qml/MyApp/Components/CMakeLists.txt`:**

```cmake
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(MyAppComponents
    URI MyApp.Components
    QML_FILES
        AppButton.qml
        Theme.qml
)

target_link_libraries(MyAppComponents PRIVATE Qt6::Quick)
```

**`qml/MyApp/App/CMakeLists.txt`:**

```cmake
qt_add_qml_module(MyAppApp
    URI MyApp.App
    QML_FILES
        Main.qml
    IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY}
)

target_link_libraries(MyAppApp PRIVATE
    Qt6::Quick
    MyAppComponents
)
```

**`src/CMakeLists.txt`:**

```cmake
qt_add_executable(appMiniapp main.cpp)

target_link_libraries(appMiniapp PRIVATE
    Qt6::Quick
    MyAppApp
    MyAppComponents
)

# Hanya untuk Qt statis: tautkan juga plugin tiap modul
# target_link_libraries(appMiniapp PRIVATE MyAppAppplugin MyAppComponentsplugin)
```

**`src/main.cpp`:**

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    engine.loadFromModule("MyApp.App", "Main");
    return app.exec();
}
```

`Main.qml`, `AppButton.qml`, dan `Theme.qml` sama dengan Modul 8.1 (`Main.qml` tetap memakai `import MyApp.Components`).

**`CMakePresets.json`:**

```json
{
  "version": 6,
  "cmakeMinimumRequired": { "major": 3, "minor": 25, "patch": 0 },
  "configurePresets": [
    {
      "name": "base",
      "hidden": true,
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/${presetName}",
      "cacheVariables": {
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
      }
    },
    {
      "name": "debug",
      "displayName": "Debug",
      "inherits": "base",
      "cacheVariables": { "CMAKE_BUILD_TYPE": "Debug" }
    },
    {
      "name": "release",
      "displayName": "Release",
      "inherits": "base",
      "cacheVariables": { "CMAKE_BUILD_TYPE": "Release" }
    },
    {
      "name": "asan",
      "displayName": "Debug + AddressSanitizer + UBSan",
      "inherits": "debug",
      "cacheVariables": {
        "CMAKE_CXX_FLAGS": "-fsanitize=address,undefined -fno-omit-frame-pointer"
      }
    }
  ],
  "buildPresets": [
    { "name": "debug",   "configurePreset": "debug" },
    { "name": "release", "configurePreset": "release" },
    { "name": "asan",    "configurePreset": "asan" },
    { "name": "lint",    "configurePreset": "debug", "targets": ["all_qmllint"] }
  ],
  "testPresets": [
    {
      "name": "debug",
      "configurePreset": "debug",
      "output": { "outputOnFailure": true },
      "execution": { "noTestsAction": "error", "stopOnFailure": true }
    }
  ],
  "workflowPresets": [
    {
      "name": "ci",
      "steps": [
        { "type": "configure", "name": "debug" },
        { "type": "build",     "name": "debug" },
        { "type": "build",     "name": "lint" },
        { "type": "test",      "name": "debug" }
      ]
    }
  ]
}
```

**`.gitignore`:**

```
build/
CMakeUserPresets.json
**/.qmlls.ini
.cache/
compile_commands.json
```

**`tests/CMakeLists.txt`:**

```cmake
add_test(NAME qmllint
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all_qmllint)

add_test(NAME lapisan
    COMMAND sh ${PROJECT_SOURCE_DIR}/tools/cek-lapisan.sh
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

# uji asap: aplikasi harus masih hidup setelah 3 detik (kode keluar 124 dari timeout)
add_test(NAME asap
    COMMAND sh -c "timeout 3 $<TARGET_FILE:appMiniapp>; [ $? -eq 124 ]")
set_tests_properties(asap PROPERTIES
    ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software")
```

**`tools/cek-lapisan.sh`** (versi dari 8.1.6, disesuaikan ke jalur baru):

```bash
#!/bin/sh
gagal=0

cek() {   # $1 = folder lapisan, $2 = lapisan terlarang
    [ -d "$1" ] || return 0
    if grep -rEn --include='*.qml' "^[[:space:]]*import[[:space:]]+MyApp\.($2)\b" "$1"; then
        echo "PELANGGARAN: $1 mengimpor lapisan di atasnya" >&2
        gagal=1
    fi
}

cek qml/MyApp/Core        'Components|Features|App'
cek qml/MyApp/Components  'Features|App'
cek qml/MyApp/Features    'App'

exit $gagal
```

**Alur kerja harian di terminal:**

```bash
cmake --list-presets                 # preset konfigurasi yang tersedia
cmake --build --list-presets         # preset build yang tersedia
cmake --preset debug                 # configure ke build/debug
cmake --build --preset debug         # bangun
./build/debug/src/appMiniapp         # jalankan
ctest --preset debug                 # uji
cmake --workflow --preset ci         # semuanya sekaligus (configure, build, lint, test)
```

---

## 4. 8.3.1 Tata letak folder

> Tempat yang tetap membuat tangan menemukan sendiri.

### 4.1 Peran tiap folder

| Folder | Isi | Aturan |
|---|---|---|
| `qml/` | Seluruh modul QML, satu folder per modul, mengikuti URI | Folder = URI dengan titik menjadi garis miring (`qml/MyApp/Components/`) |
| `src/` | C++ non-modul: `main.cpp`, kode domain atau data murni | Tak boleh bergantung pada UI |
| `tests/` | Pengujian | Menguji lewat target, bukan dengan menyalin kode |
| `tools/` | Skrip bantu (lint lapisan, pemeriksa mutasi) | Skrip kecil dan dapat dibaca |
| `build/` | Keluaran build per preset | Tidak pernah dikomit |
| akar | `CMakeLists.txt`, `CMakePresets.json`, `.gitignore` | Sedikit dan jelas |

### 4.2 Aturan yang perlu dihafal

1. **Satu folder, satu modul QML.** Berkas QML modul **harus** berada di folder yang sama dengan `CMakeLists.txt` yang memanggil `qt_add_qml_module`. Dokumentasi Best Practices menegaskan bahwa bila tidak, *implicit import* berkas berbeda dari modul tempat ia berada, dan itu sumber kesalahan yang sering.
2. **Folder modul pustaka mengikuti target path.** Peringatan CMake akan muncul bila tidak (8.1.2).
3. **C++ yang tidak mendefinisikan tipe QML** boleh menjadi pustaka biasa di `src/`. **C++ yang mengekspor tipe QML** (`QML_ELEMENT`) ditaruh di folder modulnya dan didaftarkan lewat `SOURCES`.
4. **Executable dibuat tipis.** Hanya `main.cpp` dan penautan. Logika dan antarmuka ada di modul.
5. **Hanya yang dihasilkan manusia masuk Git.** Hasil build, basis data kompilasi, dan berkas konfigurasi lokal tidak.

### 4.3 Opsi lain untuk menata proyek

| Opsi | Catatan |
|---|---|
| Tata letak di atas (`qml/`, `src/`, `tests/`) | Default untuk aplikasi multi-modul |
| Per fitur ("vertical slice") | Folder fitur memuat QML, C++, dan uji sendiri. Cocok untuk tim besar |
| Datar (satu folder) | Hanya prototipe |
| Banyak repo | Bila modul berbagi antarproduk. Biayanya: koordinasi versi |

Jebakan: C1, C4, C5.

---

## 5. 8.3.2 `QML_FILES`, `SOURCES`, `RESOURCES`

> Setiap berkas harus punya alamat yang diketahui build.

`qt_add_qml_module` menerima beberapa daftar berkas dengan peran berbeda:

| Argumen | Isi | Catatan |
|---|---|---|
| `QML_FILES` | `.qml`, `.js`, `.mjs` anggota modul | Dikompilasi lebih awal (*ahead of time*) dan ditanam di backing target |
| `SOURCES` | `.cpp` dan `.h` yang mendefinisikan tipe C++ modul | Ditambahkan ke backing target. `AUTOMOC` memprosesnya |
| `RESOURCES` | Berkas non-QML: gambar, font, data | Ditanam di resource pada jalur `awalan + target path + jalur relatif` |

**Contoh dengan ketiganya** (modul `MyApp.Components` yang kelak punya gambar dan tipe C++):

```cmake
qt_add_qml_module(MyAppComponents
    URI MyApp.Components
    QML_FILES
        AppButton.qml
        Theme.qml
    SOURCES
        pengukur.h
        pengukur.cpp
    RESOURCES
        images/logo.svg
)
```

Dari `AppButton.qml`, gambar dirujuk **relatif** terhadap berkas itu: `Image { source: 'images/logo.svg' }` (hasilnya `qrc:/qt/qml/MyApp/Components/images/logo.svg`).

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `QML_FILES AppButton.qml Theme.qml` | Daftar tipe QML modul. Berkas berawalan huruf kapital menjadi tipe. |
| `SOURCES pengukur.h pengukur.cpp` | Kode C++ modul, misalnya kelas dengan `QML_ELEMENT`. |
| `RESOURCES images/logo.svg` | Aset yang ikut tertanam di biner, tidak dibaca dari disk saat runtime. |
| Jalur relatif `images/logo.svg` | Tampil di resource di bawah `.../MyApp/Components/images/logo.svg`. |

Bagi file yang sudah ada tetapi baru ditambahkan: **konfigurasi ulang CMake** agar `qmldir` dan daftar tipe diperbarui (M13 di 8.1). Menambah berkas setelah modul dibuat dapat memakai `qt_target_qml_sources()`.

**Mengapa resource dan bukan baca dari disk?** Dokumentasi Best Practices menjelaskan sistem resource Qt sebagai cara membuat aset tersedia tanpa bergantung pada kebijakan keamanan sistem berkas tiap OS. Dari sisi keamanan, aset yang tertanam juga tidak bisa diganti pengguna biasa.

**Opsi lain:**

| Opsi | Catatan |
|---|---|
| `RESOURCES` pada modul | **Default** untuk aset yang dipakai modul |
| `qt_add_resources()` | Resource umum di luar modul |
| Aset dibaca dari disk | Hanya untuk data yang memang diganti pengguna. Perlakukan sebagai tak tepercaya |

Jebakan: C5, C14.

---

## 6. 8.3.3 Banyak modul dan target

> Graf dependensi yang jelas menghindari perang saudara antar-target.

### 6.1 Pola dasar

- **Satu modul QML = satu backing target pustaka** (`MyAppComponents`).
- **Executable tipis** menaut ke target modul yang dipakai langsung (`MyAppApp`, `MyAppComponents`).
- Modul bergantung hanya ke modul **di bawahnya** (aturan 8.1.6).
- Penamaan: pustaka `MyApp<Nama>`, executable `app<Nama>` (konvensi Qt), dan plugin otomatis `<target>plugin`.

### 6.2 `QT_QML_OUTPUT_DIRECTORY` dan `IMPORT_PATH`

`set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)` mengumpulkan semua modul QML di `build/<preset>/qml/MyApp/...`. Dengan begitu satu jalur (`${QT_QML_OUTPUT_DIRECTORY}`) cukup untuk `IMPORT_PATH` modul yang bergantung pada modul lain, dan untuk alat seperti `qml -I build/debug/qml`.

### 6.3 Memeriksa graf dependensi

```bash
cmake --build --preset debug --target help          # daftar target yang tersedia
cmake --preset debug --graphviz=build/graf.dot      # keluarkan graf dependensi target
dot -Tpng build/graf.dot -o build/graf.png          # (butuh paket graphviz)
```

Opsi `--graphviz` menulis berkas dengan semua dependensi pustaka dan executable proyek. Graf ini berguna untuk membuktikan bahwa **tidak ada siklus** dan arah panahnya benar.

### 6.4 Jebakan penaut: pustaka modul "hilang" saat dijalankan

Dokumentasi `qt_add_qml_module` memperingatkan bahwa penaut bisa membuang pustaka yang tampak tak terpakai. Gejalanya: aplikasi jalan di mesin Anda tetapi gagal dengan `module "MyApp.Components" is not installed` di mesin lain atau toolchain lain. Pemeriksaan di terminal:

```bash
ldd build/debug/src/appMiniapp | grep -i myapp
```

Bila pustaka modul tidak muncul padahal seharusnya tertaut, ada beberapa jalan keluar:

| Opsi | Catatan |
|---|---|
| Tautkan juga **plugin** modul (`MyAppComponentsplugin`) | Wajib pada Qt statis |
| `-Wl,--no-as-needed` pada executable | Mencegah penaut membuang pustaka |
| Pastikan executable memakai setidaknya satu simbol modul | Misalnya lewat tipe C++ |

Uji asap di tests (`asap`) menangkap masalah ini lebih awal.

### 6.5 Opsi lain untuk mengelola banyak modul

| Opsi | Kapan |
|---|---|
| `add_subdirectory` per modul (di atas) | Standar |
| `FetchContent` / paket eksternal | Modul pihak ketiga. Pin versinya |
| Satu target besar | Tidak dianjurkan: kehilangan batas modul |

Jebakan: C4, C6, C7.

---

## 7. 8.3.4 Preset dan konfigurasi Debug/Release

> Perintah yang sama untuk semua orang adalah bentuk kesopanan engineering.

### 7.1 Apa dan mengapa

`CMakePresets.json` adalah berkas JSON di akar proyek untuk membagikan cara membangun. Dokumentasi CMake menyebutnya cocok untuk mendukung build CI dan pengembang yang sering memakai konfigurasi sama. Ada dua berkas: **`CMakePresets.json`** (seluruh proyek, boleh dikomit) dan **`CMakeUserPresets.json`** (lokal pengembang, **tidak** dikomit). `CMakeUserPresets.json` otomatis menyertakan `CMakePresets.json`, sehingga bisa mewarisinya.

### 7.2 Jenis preset

| Jenis | Dipanggil dengan | Fungsi |
|---|---|---|
| `configurePresets` | `cmake --preset <nama>` | Generator, folder build, variabel cache |
| `buildPresets` | `cmake --build --preset <nama>` | Target, jumlah job, konfigurasi |
| `testPresets` | `ctest --preset <nama>` | Filter, keluaran, eksekusi uji |
| `packagePresets` | `cpack --preset <nama>` | Pengemasan |
| `workflowPresets` | `cmake --workflow --preset <nama>` | Rangkaian configure, build, test, package |

Nama preset boleh sama antarjenis (preset build `debug` dan preset configure `debug` tidak bertabrakan).

### 7.3 Kolom yang penting

| Kolom | Arti |
|---|---|
| `hidden: true` | Hanya induk pewarisan. Tidak dapat dipanggil langsung, tidak wajib punya `generator`/`binaryDir` |
| `inherits` | Mewarisi semua kolom induk (kecuali `name`, `hidden`, `inherits`, `description`, `displayName`). Bila bentrok, induk yang lebih awal dalam daftar menang |
| `generator` | Mis. `Ninja`. Opsional sejak preset versi 3 |
| `binaryDir` | Jalur relatif dihitung dari source. Mendukung makro |
| `cacheVariables` | Nilai awal variabel cache. Diwarisi (gabungan). Nilai `null` membatalkan nilai warisan |
| `environment` | Variabel lingkungan untuk preset. Boleh merujuk satu sama lain |
| `condition` | Mengaktifkan preset hanya bila kondisi benar (mis. `${hostSystemName}`) |
| Build: `configurePreset`, `targets`, `jobs`, `verbose` | Menunjuk configure preset (folder build mengikutinya), memilih target |
| Test: `output.outputOnFailure`, `execution.noTestsAction`, `stopOnFailure` | Kebijakan keluaran dan kegagalan |

**Makro yang dipakai:** `${sourceDir}` (folder source), `${presetName}` (nama preset yang sedang dipakai, dievaluasi pada preset yang dijalankan walau kolomnya diwarisi), `${hostSystemName}`, `$env{NAMA}` dan `$penv{NAMA}` (lingkungan, `$penv` hanya dari proses induk sehingga bisa menambah ke `PATH`).

### 7.4 Penjelasan preset proyek contoh

| Potongan | Arti |
|---|---|
| `"version": 6` | Versi skema preset. Versi 6 (CMake 3.25) menambah package dan workflow preset. Versi lebih tinggi butuh CMake lebih baru |
| `base` (`hidden`) | Memusatkan generator, `binaryDir`, dan `CMAKE_EXPORT_COMPILE_COMMANDS` |
| `binaryDir: ${sourceDir}/build/${presetName}` | Satu folder build per preset: `build/debug`, `build/release`, `build/asan` |
| `debug` / `release` | Mewarisi `base` dan hanya menambah `CMAKE_BUILD_TYPE` |
| `asan` | Mewarisi `debug` dan menambah flag sanitizer |
| Preset build `lint` | Menjalankan target `all_qmllint` pada konfigurasi `debug` |
| Workflow `ci` | Configure lalu build, lint, dan uji. **Langkah pertama harus configure**, langkah berikutnya build, test, atau package yang `configurePreset`-nya sama |

### 7.5 Debug vs Release

| Tipe build | Karakter | Pakai untuk |
|---|---|---|
| `Debug` | Simbol debug, tanpa optimasi | Pengembangan harian |
| `Release` | Optimasi penuh, tanpa simbol | Rilis |
| `RelWithDebInfo` | Optimasi + simbol | Pelacakan galat di build teroptimasi |

`CMAKE_BUILD_TYPE` diingat di **cache** satu folder build. Karena itu satu folder build tidak boleh dipakai bolak-balik untuk dua tipe (C3). Dengan `binaryDir` per preset, masalah itu hilang.

### 7.6 Preset pribadi

`CMakeUserPresets.json` (di `.gitignore`) untuk kebutuhan lokal:

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "dev-clang",
      "inherits": "debug",
      "environment": { "CC": "clang", "CXX": "clang++" }
    }
  ]
}
```

**Aturan keamanan:** `CMakePresets.json` dikomit, jadi **jangan menaruh rahasia, token, atau jalur pribadi** di dalamnya. Letakkan hal lokal di `CMakeUserPresets.json`, dan rahasia di variabel lingkungan di luar repo.

### 7.7 Opsi lain untuk membangun

| Opsi | Catatan |
|---|---|
| Preset (di atas) | **Default**: terdokumentasi dan dapat dibagikan |
| `cmake -S . -B build -G Ninja -D...` | Baik untuk percobaan sekali pakai |
| Qt Creator | Membaca preset, tetapi dasarnya tetap CMake |
| `Makefile` pembungkus / skrip `build.sh` | Hanya sebagai lapisan tipis di atas preset |

Jebakan: C2, C3, C9, C10, C11.

---

## 8. 8.3.5 `compile_commands.json` untuk clangd

> Editor yang paham kode adalah rekan kerja yang tak pernah lelah.

`clangd` (server bahasa C++) tidak membangun apa pun. Ia butuh **basis data kompilasi** untuk tahu flag, jalur include, dan definisi tiap berkas. CMake membuatnya bila `CMAKE_EXPORT_COMPILE_COMMANDS` aktif, dan hanya untuk generator Makefile dan Ninja. Karena itu variabel ini diletakkan di preset `base`, sehingga selalu aktif.

**Mengarahkan `clangd` ke berkas itu:**

```bash
cmake --preset debug                                # menghasilkan build/debug/compile_commands.json
ln -sf build/debug/compile_commands.json .          # pintasan di akar proyek
```

Alternatif tanpa symlink: berkas `.clangd` di akar proyek:

```yaml
CompileFlags:
  CompilationDatabase: build/debug
```

atau argumen `clangd --compile-commands-dir=build/debug`. Basis data hanya mencakup berkas yang dibangun preset itu. Bila Anda berganti ke `release`, arahkan ulang.

**Opsi lain:**

| Opsi | Catatan |
|---|---|
| Symlink di akar | Paling sederhana. Tambahkan ke `.gitignore` |
| `.clangd` dengan `CompilationDatabase` | Tanpa symlink, mudah diganti |
| `--compile-commands-dir` | Dari konfigurasi editor |
| Qt Creator | Memakai model kode sendiri |

Jebakan: C8.

---

## 9. 8.3.6 `qmllint` sebagai target build

> Peringatan yang dijalankan otomatis lebih ampuh daripada niat baik.

`qt_add_qml_module` membuat target lint untuk tiap modul, dan target gabungan **`all_qmllint`** yang menjalankannya untuk seluruh modul QML. Karena butuh tahu letak modul dependensi, pastikan modul yang mengimpor modul lain memberi `IMPORT_PATH` (8.1.4) dan semua modul memakai `QT_QML_OUTPUT_DIRECTORY` yang sama.

```bash
cmake --build --preset lint                          # lewat preset build
cmake --build build/debug --target all_qmllint       # padanan langsung
```

Mengapa lint perlu dijalankan lewat build dan bukan hanya `qmllint file.qml`: build tahu import path, struktur modul, dan tipe C++ yang terdaftar, sehingga hasilnya lebih akurat. Untuk pemeriksaan cepat satu berkas, `qmllint` langsung tetap berguna (periksa `qmllint --help` untuk opsi `-I`).

**Integrasi editor (`qmlls`).** Server bahasa QML bernama `qmlls`. Ia perlu tahu folder build agar menemukan modul buatan sendiri. Qt pernah menyediakan variabel `QT_QML_GENERATE_QMLLS_INI` yang menulis berkas `.qmlls.ini` di tiap folder modul. Perubahannya: variabel itu sudah usang sejak Qt 6.10 dan tak ada penggantinya yang perlu dipasang, dan dokumentasinya mencatat bahwa berkas `.qmlls.ini` hanya valid untuk konfigurasi terakhir sehingga sebaiknya diabaikan oleh Git. Jika Anda memakai Qt lebih lama dan masih membutuhkannya, variabel itu menulis `.qmlls.ini` yang berisi jalur folder build terakhir, dan sebaiknya diberikan lewat IDE atau baris perintah (`-DQT_QML_GENERATE_QMLLS_INI=ON`), bukan ditetapkan di proyek. Untuk Qt 6.10 ke atas, periksa dokumentasi *QML Language Server* tentang cara memberi tahu folder build (misalnya lewat `qmlls --help`).

Penegakan di CI: jadikan `lint` salah satu langkah workflow `ci` (sudah ada) dan, bila ingin gagal pada peringatan, periksa kode keluar `qmllint` di mesin Anda dan opsi ambang peringatannya (`qmllint --help`).

**Opsi lain:**

| Opsi | Kapan |
|---|---|
| `all_qmllint` lewat preset | **Default** di CI dan lokal |
| `qmllint` langsung | Pemeriksaan cepat satu berkas |
| `qmlls` di editor | Umpan balik saat menulis |
| Hook `pre-commit` | Modul 8.4 |

Jebakan: C6, C12.

---

## 10. 8.3.7 (TAMBAHAN) Varian build: sanitizer dan pengerasan

> Rilis yang aman dimulai dari build yang diperiksa keras.

### 10.1 Sanitizer (pengembangan)

Preset `asan` memakai `-fsanitize=address,undefined`. AddressSanitizer menangkap galat memori (penggunaan setelah dibebaskan, tulis di luar batas). UBSan menangkap perilaku tak terdefinisi. Catatan praktis:

```bash
cmake --preset asan
cmake --build --preset asan
ASAN_OPTIONS=detect_leaks=0 ./build/asan/src/appMiniapp     # bila laporan kebocoran Qt/driver terlalu bising
```

Sanitizer memperlambat dan menambah memori. Pakai saat pengembangan dan CI, bukan rilis.

### 10.2 Pengerasan rilis

Preset rilis yang memperkeras biner (tambahkan ke `configurePresets`):

```json
{
  "name": "release-hardened",
  "displayName": "Release + hardening",
  "inherits": "release",
  "cacheVariables": {
    "CMAKE_CXX_FLAGS": "-fstack-protector-strong -fstack-clash-protection -D_FORTIFY_SOURCE=3",
    "CMAKE_EXE_LINKER_FLAGS": "-Wl,-z,relro,-z,now",
    "CMAKE_SHARED_LINKER_FLAGS": "-Wl,-z,relro,-z,now"
  }
}
```

| Flag | Fungsi |
|---|---|
| `-fstack-protector-strong` | Canary pada fungsi berisiko untuk menangkap luapan tumpukan |
| `-fstack-clash-protection` | Mencegah serangan tabrakan tumpukan |
| `-D_FORTIFY_SOURCE=3` | Pemeriksaan batas tambahan pada fungsi libc (butuh optimasi, GCC 12+) |
| `-Wl,-z,relro,-z,now` | Relokasi hanya-baca dan *immediate binding*: GOT tak bisa ditimpa |

**Verifikasi di terminal**, jangan percaya flag begitu saja:

```bash
readelf -h build/release-hardened/src/appMiniapp | grep Type          # DYN = PIE
readelf -l build/release-hardened/src/appMiniapp | grep GNU_RELRO     # ada = RELRO aktif
readelf -d build/release-hardened/src/appMiniapp | grep BIND_NOW      # ada = now aktif
```

Flag lain seperti `-fcf-protection` khusus arsitektur x86. Cocokkan dengan toolchain Anda sebelum menambahkannya. Banyak distribusi (termasuk toolchain Arch) sudah mengaktifkan sebagian dari ini secara default, jadi verifikasi hasil akhir dengan `readelf`.

### 10.3 Aturan rilis terkait Qt

- **Jangan** mengaktifkan infrastruktur debug QML di rilis (peringatan dari 8.1.9).
- Pin versi Qt minimum (`find_package(Qt6 6.8 REQUIRED ...)`) dan catat versi persis di log build.
- Bangun rilis dari preset yang sama di CI sehingga hasilnya dapat direproduksi.

**Opsi lain:**

| Opsi | Catatan |
|---|---|
| Preset hardening khusus | **Default** untuk rilis |
| `RelWithDebInfo` + `strip` terpisah | Simpan simbol untuk analisis kegagalan |
| `ThreadSanitizer` (`-fsanitize=thread`) | Aplikasi multithread. Tidak digabung dengan ASan |
| `ccache` (`CMAKE_CXX_COMPILER_LAUNCHER`) | Mempercepat build ulang, bukan keamanan |

Jebakan: C13, C15.

---

## 11. 8.3.8 (TAMBAHAN) Integrasi editor terminal, `.gitignore`, dan pengujian di CMake

> Alur kerja yang mulus adalah hasil dari banyak berkas kecil yang tepat.

### 11.1 Editor terminal

Rangkaian alat ringan yang melengkapi alur terminal:

| Alat | Tugas | Pengaturan |
|---|---|---|
| `clangd` | Pemahaman kode C++ | `compile_commands.json` (8.3.5) |
| `qmlls` | Pemahaman kode QML | Folder build (8.3.6) |
| `qmlformat` | Format QML | Modul 8.4 |
| `qmllint` / `all_qmllint` | Pemeriksaan | 8.3.6 |
| `ninja` | Build cepat | Generator di preset |
| `ctest` | Uji | Test preset |

### 11.2 `.gitignore`

Isi yang disarankan (sudah di proyek contoh):

```
build/
CMakeUserPresets.json
**/.qmlls.ini
.cache/
compile_commands.json
```

Alasan: `build/` adalah turunan. `CMakeUserPresets.json` bersifat lokal. `.qmlls.ini` hanya valid untuk konfigurasi terakhir (dokumentasi Qt menyarankan pola `**/.qmlls.ini`). `.cache/` adalah indeks `clangd`. `compile_commands.json` di akar adalah symlink lokal.

### 11.3 Pengujian di CMake

`include(CTest)` dan `add_test(...)` mendaftarkan uji, dan test preset menjalankannya. `tests/CMakeLists.txt` di proyek contoh memuat tiga uji yang menegakkan disiplin tanpa mengandalkan ingatan:

| Uji | Memeriksa |
|---|---|
| `qmllint` | Menjalankan target `all_qmllint` |
| `lapisan` | `tools/cek-lapisan.sh`: arah ketergantungan (8.1.6) |
| `asap` | Aplikasi masih hidup setelah 3 detik di lingkungan tanpa layar (kode keluar `124` dari `timeout`) |

Uji unit dengan `QtTest` dibahas pada modul pengujian di fase berikutnya. Dengan struktur ini, `ctest --preset debug` dan `cmake --workflow --preset ci` sudah cukup untuk memastikan perubahan tidak merusak struktur.

**Opsi lain:**

| Opsi | Catatan |
|---|---|
| `CTest` + preset | **Default**. Satu pintu |
| Skrip `make check` | Hanya pembungkus |
| Hook git (`pre-commit`) | Modul 8.4. Menangkap sebelum komit |

Jebakan: C10, C12.

---

## 12. Penutup modul

### 12.1 Hubungan dengan modul lain

- **Prasyarat:** 8.1 (modul, URI, folder mengikuti target path, import path), 8.2 (lapisan dan skrip pemeriksa), dasar CMake dan C++ (`main.cpp`).
- **8.4 Konvensi, Linting, dan Disiplin Kualitas:** `qmllint`, `qmlformat`, hook `pre-commit`, dan CI memakai preset dan target yang disiapkan di sini.
- **Fase 10 (C++):** `SOURCES` dan `QML_ELEMENT`, pustaka C++ non-modul di `src/`, dan model C++ baca-saja (8.2.9).
- **Modul pengujian (fase berikutnya):** test preset dan `QtTest`.
- **Fase deployment dan rilis:** `Release`, hardening, dan pengemasan (`cpack --preset`).
- **Fase 13 (keamanan):** rantai build, pengerasan biner, sanitizer, dan manajemen rahasia.

### 12.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| C1 | Proyek sulit dipahami dan berubah-ubah | Semua berkas di satu folder | Satu folder per modul dalam `qml/` |
| C2 | `git status` penuh berkas aneh, cache saling mengotori | Build di dalam source | Out-of-source lewat `binaryDir` preset. `build/` di `.gitignore` |
| C3 | Build Release tetap berisi simbol Debug, atau sebaliknya | Satu folder build dipakai untuk dua tipe (`CMAKE_BUILD_TYPE` terkunci di cache) | `binaryDir` per preset (`build/${presetName}`) |
| C4 | Peringatan CMake soal struktur folder | Folder modul pustaka tak mengikuti target path | Folder = URI dengan titik menjadi garis miring |
| C5 | Tipe tak ditemukan antar-berkas satu modul | Berkas QML di folder berbeda dari `CMakeLists.txt` modul | Taruh berkas QML di folder yang sama |
| C6 | `qmllint` mengeluh modul tak ditemukan | Tak ada `IMPORT_PATH`, atau keluaran modul tersebar | `QT_QML_OUTPUT_DIRECTORY` tunggal dan `IMPORT_PATH` |
| C7 | Modul hilang saat dijalankan di mesin lain | Penaut membuang pustaka yang tampak tak terpakai | `ldd`, tautkan plugin, atau `-Wl,--no-as-needed`. Uji asap |
| C8 | `clangd` tak mengenali jalur include | Tak ada `compile_commands.json`, atau generator bukan Makefile/Ninja | Aktifkan `CMAKE_EXPORT_COMPILE_COMMANDS` di preset. Arahkan `clangd` ke folder yang benar |
| C9 | CMake menolak membaca preset | Versi skema preset lebih tinggi dari CMake terpasang | `cmake --version`. Versi 6 butuh CMake 3.25 |
| C10 | Jalur atau env pribadi tersebar ke tim | `CMakeUserPresets.json` ikut terkomit | `.gitignore` dan pisahkan dari `CMakePresets.json` |
| C11 | Token terlihat di riwayat Git | Rahasia ditulis di preset | Jangan taruh rahasia di preset. Gunakan variabel lingkungan di luar repo |
| C12 | `.qmlls.ini` ikut Git atau usang | Variabel generasi `.qmlls.ini` (usang sejak 6.10) | `**/.qmlls.ini` di `.gitignore`. Beri tahu `qmlls` folder build lewat cara terbaru |
| C13 | Build ulang lambat | Tanpa Ninja atau cache kompilasi | Generator Ninja. `ccache` opsional |
| C14 | Tipe QML baru tak muncul | Berkas tak didaftarkan di `QML_FILES`, atau CMake belum dikonfigurasi ulang | Daftarkan dan konfigurasi ulang |
| C15 | Kompilasi gagal pada flag hardening | Flag tak cocok dengan arsitektur atau versi kompilator | Cocokkan dengan toolchain. Verifikasi dengan `readelf` |

### 12.3 Latihan 15 menit

**Persiapan terminal (Arch):**

```bash
sudo pacman -S --needed cmake ninja qt6-base qt6-declarative
cmake --version                        # pastikan >= 3.25 untuk preset versi 6
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmllint|qmlformat)$'
```

**Langkah:**

1. Mulai dari proyek Modul 8.1 (`miniapp`). Susun ulang menjadi pohon di bagian 3: `git mv` folder `MyApp/Components` ke `qml/MyApp/Components`, pindahkan `Main.qml` ke `qml/MyApp/App/`, dan buat `src/main.cpp` dengan `CMakeLists.txt`-nya.
2. Tulis `CMakeLists.txt` akar dan `CMakeLists.txt` tiap folder seperti di bagian 3. **Tambahkan** `CMakePresets.json` dengan preset `debug` (sesuai kurikulum).
3. Jalankan `cmake --list-presets`, lalu `cmake --preset debug` dan `cmake --build --preset debug`. Jalankan `./build/debug/src/appMiniapp`.
4. Sesuai kurikulum, jalankan `cmake --build build/debug --target all_qmllint` atau lewat preset `lint`: `cmake --build --preset lint`. Perbaiki peringatan yang muncul.
5. Buat `.gitignore`, `tests/CMakeLists.txt`, dan `tools/cek-lapisan.sh`. Jalankan `ctest --preset debug` setelah menambah test preset.
6. Jalankan `cmake --workflow --preset ci` dan pastikan seluruh langkah lolos.
7. Buat symlink `compile_commands.json` dan konfirmasi `clangd` mengenali berkas `main.cpp`.
8. Periksa `ldd build/debug/src/appMiniapp | grep -i myapp`, dan catat apa yang terlihat.

**Tantangan 10 menit:** (a) tambahkan preset `asan` dan jalankan aplikasi dengan sanitizer. (b) Tambahkan `release-hardened`, bangun, dan verifikasi tiga perintah `readelf` di 8.3.7. (c) Hapus sengaja satu dependensi (`MyAppComponents` dari `target_link_libraries`), jalankan uji asap, dan jelaskan gejalanya. (d) Hasilkan graf dengan `--graphviz`, lalu pastikan tidak ada siklus.

### 12.4 Cek pemahaman

1. Mengapa build di luar source direktori lebih aman?
2. Mengapa `CMAKE_BUILD_TYPE` membuat satu folder build tak boleh dipakai untuk dua tipe?
3. Mengapa folder modul QML harus mengikuti URI?
4. Apa guna preset `hidden` dan `inherits`?
5. Mengapa `CMakeUserPresets.json` tidak dikomit, dan apa yang tak boleh ada di `CMakePresets.json`?
6. Apa fungsi `compile_commands.json`, dan generator mana yang menghasilkannya?
7. Mengapa executable dibuat tipis?
8. Bagaimana mendeteksi bahwa pustaka modul dibuang penaut?

**Jawaban singkat:**

1. Source tetap bersih: hasil build, cache, dan berkas turunan tidak bercampur dengan kode yang berharga. Build dapat dibuang dengan `rm -rf build/<preset>` tanpa risiko, dan Git tak tercemari.
2. Nilainya disimpan di cache folder itu. Mengubahnya tanpa membuang folder membuat hasil campur aduk. Satu folder per preset menghilangkan masalah.
3. Alat dan mesin menurunkan lokasi modul dari URI. Bila tak cocok, CMake memperingatkan dan tooling bisa gagal menemukan modul.
4. `hidden` menandai preset yang hanya jadi induk. `inherits` memusatkan pengaturan bersama (generator, folder build, variabel) dan menghindari duplikasi.
5. Karena berisi jalur atau lingkungan lokal yang berbeda per orang. `CMakePresets.json` dibagikan, jadi tak boleh memuat rahasia, token, atau jalur pribadi.
6. Basis data perintah kompilasi per berkas, dipakai `clangd`. Dihasilkan oleh generator Makefile dan Ninja bila `CMAKE_EXPORT_COMPILE_COMMANDS` aktif.
7. Logika dan antarmuka berada di modul yang dapat diuji, diganti, dan dipakai ulang. Executable hanya merakit dan menjalankan.
8. Jalankan `ldd` pada executable dan cari pustaka modul. Uji asap juga akan gagal bila modul tak termuat.

### 12.5 Referensi

Tautan CMake dan Qt berikut saya baca langsung atau temukan di halaman dokumentasi yang saya baca saat menyusun materi ini. Tautan *clangd* dan beberapa dokumentasi CMake tidak saya buka ulang.

- [CMake Presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) · [cmake(1)](https://cmake.org/cmake/help/latest/manual/cmake.1.html) · [ctest(1)](https://cmake.org/cmake/help/latest/manual/ctest.1.html)
- [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [Building a reusable QML module](https://doc.qt.io/qt-6/cmake-build-reusable-qml-module.html)
- [qt_add_qml_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html)
- [QT_QML_GENERATE_QMLLS_INI](https://doc.qt.io/qt-6/cmake-variable-qt-qml-generate-qmlls-ini.html)
- [Best Practices for QML and Qt Quick](https://doc.qt.io/qt-6/qtquick-bestpractices.html)
- [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- Tidak dibuka ulang: [CMAKE_EXPORT_COMPILE_COMMANDS](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html) · [clangd](https://clangd.llvm.org/)
- Komunitas: [Qt Forum](https://forum.qt.io/) · [Qt Academy](https://www.qt.io/academy)

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
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

