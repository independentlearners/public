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

