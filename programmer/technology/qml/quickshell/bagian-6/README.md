# Kurikulum Fase 5

---

## Audit

Sebelum masuk ke materi, ada beberapa **lonjakan konseptual dan celah teknis** yang perlu disadari agar fase ini tidak menjadi “jembatan runtuh”:

| Celah | Dampak | Rekomendasi |
|---|---|---|
| **Tidak ada jembatan C++ untuk pembaca non-C++** | Modul 5.1 langsung memakai `Q_OBJECT`, `QML_ELEMENT`, `uname()`, dan CMake tanpa menjelaskan model memori Qt atau siklus hidup objek QML | Tambahkan **Modul 5.0: Dasar C++ untuk QML** — kelas, header, pointer/reference, dan model parent-child Qt |
| **`IpcHandler` hanya disebut di Capstone, tidak diajarkan** | Persyaratan capstone “semua aksi via `qs ipc call`” tidak punya fondasi di modul mana pun | Naikkan `IpcHandler` menjadi sub-modul eksplisit di **5.1** atau **2.5** |
| **Tidak ada pembahasan *symbol visibility* dan ABI** | Plugin C++ yang dibangun dengan Qt berbeda bisa crash saat runtime | Tambahkan peringatan ABI dan `-fvisibility=hidden` di **5.1** |
| **Perf/`heaptrack` tidak dijelaskan cara membaca output** | Pembaca bisa menjalankan alat tetapi tidak tahu apa yang harus dicari | Tambahkan **contoh membaca `perf report` dan `heaptrack_gui`** di **5.2** |
| **Tidak ada *reproducible build* secara praktis** | `SOURCE_DATE_EPOCH` hanya disebut sekilas | Tambahkan contoh `PKGBUILD` dan `nix build` yang deterministik di **5.3** |
| **Tidak ada *smoke test* yang konkret** | CI hanya `qmllint`, padahal capstone menuntut uji asap | Tambahkan contoh *headless smoke test* dengan `quickshell -c` dan exit code di **5.3** |

> Materi di bawah ini **sudah mengisi celah-celah tersebut** tanpa mengubah urutan fase. Setiap penambahan ditandai dengan **[Tambahan]** .

---

## Modul 5.1 — Plugin C++ dan Backend Kustom

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara **memperluas runtime Quickshell dengan kode C++ native** ketika QML, `Process`, dan modul bawaan tidak lagi cukup. Perannya adalah menjadi **pintu keluar terakhir** dari abstraksi QML: ketika Anda butuh membaca data kernel yang tidak terekspos D-Bus, memanggil `ioctl` secara langsung, atau melakukan komputasi numerik berat yang tidak praktis di JavaScript, Anda menulis kelas C++, mendaftarkannya sebagai tipe QML, dan memanggilnya dari QML seolah-olah itu komponen bawaan.

**Mengapa penting:** Quickshell sendiri dibangun dari C++ dan mengekspos fungsionalitasnya ke QML melalui `qt_add_qml_module`. Memahami mekanisme ini berarti Anda memahami **cara kerja internal Quickshell**, bukan sekadar memakainya. Ini juga satu-satunya cara untuk berkontribusi ke upstream dalam bentuk modul baru.

---

### 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “QML adalah dasbor, C++ adalah mesin.”** QML dirancang untuk *mendeskripsikan* tampilan dan perilaku secara deklaratif. Ia sangat baik dalam binding, animasi, dan tata letak. Namun QML bukan bahasa sistem: ia tidak punya akses langsung ke syscall, tidak punya tipe data numerik 64-bit yang efisien, dan tidak bisa melakukan pointer arithmetic. Ketika kebutuhan Anda menyentuh **batas kernel–userspace**, Anda harus turun ke C++.

**Prinsip “super kontrol, super tanggung jawab.”** Kode C++ di plugin berjalan **di dalam proses Quickshell**, tanpa sandbox QML, tanpa pembatasan akses berkas, tanpa pembatasan jaringan. Setiap baris C++ yang Anda tulis adalah kode dengan hak penuh atas sesi pengguna. Inilah mengapa kurikulum menekankan **audit keamanan** sebagai bagian tak terpisahkan dari modul ini, bukan sebagai lampiran opsional.

**Model parent-child Qt: fondasi manajemen memori.** Di Qt, `QObject` membentuk pohon kepemilikan. Ketika Anda membuat `QObject` dengan parent, parent akan menghapus child-nya saat parent dihancurkan. Ini adalah **garbage collection deterministik berbasis kepemilikan**, bukan *tracing GC* seperti di Java atau Go. Memahami ini krusial: jika Anda lupa memberi parent pada objek yang dialokasikan dengan `new`, Anda mendapatkan *memory leak*; jika Anda memberi parent pada objek yang sudah dimiliki pihak lain, Anda mendapatkan *double free*.

---

### 3. Sintaks Dasar / Contoh Implementasi Inti

#### 3.1 Header C++: mendefinisikan tipe QML

```cpp
// kernelinfo.hpp
#pragma once
#include <sys/utsname.h>          // uname() — syscall wrapper glibc
#include <QObject>                // basis semua objek yang bisa "hidup" di Qt
#include <QString>                // string Unicode Qt (bukan std::string)
#include <QtQml/qqmlregistration.h> // makro QML_ELEMENT

class KernelInfo : public QObject {
    Q_OBJECT                      // wajib: mengaktifkan meta-object system
    QML_ELEMENT                   // daftarkan kelas ini sebagai tipe QML
    Q_PROPERTY(QString release READ release CONSTANT) // properti QML read-only

public:
    explicit KernelInfo(QObject* parent = nullptr) : QObject(parent) {
        struct utsname u {};      // zero-initialize: hindari sampah memori
        if (uname(&u) == 0) {     // 0 = sukses; -1 = gagal (errno di-set)
            m_release = QString::fromLocal8Bit(u.release);
        }
    }

    QString release() const { return m_release; } // getter untuk Q_PROPERTY

private:
    QString m_release;            // nilai disimpan saat konstruksi (CONSTANT)
};
```

**Penjelasan kata demi kata:**

| Elemen | Fungsi | Jika dihilangkan |
|---|---|---|
| `#pragma once` | Mencegah header di-include dua kali | *Redefinition error* saat kompilasi |
| `#include <sys/utsname.h>` | Deklarasi `uname()` dan `struct utsname` | Kompilasi gagal: `utsname` tidak dikenal |
| `Q_OBJECT` | Menghasilkan kode *moc*: meta-object, signal/slot, property system | Kelas tidak bisa punya signal/slot; `Q_PROPERTY` diabaikan |
| `QML_ELEMENT` | Memberi tahu `qt_add_qml_module` untuk mendaftarkan kelas dengan nama kelas (`KernelInfo`) | Tipe tidak muncul di QML: `KernelInfo is not a type` |
| `Q_PROPERTY(... CONSTANT)` | Mendefinisikan properti `release` yang bisa dibaca QML; `CONSTANT` berarti nilainya tidak pernah berubah setelah konstruksi | QML tidak bisa mengikat `ki.release`; atau binding terus dievaluasi ulang tanpa perlu |
| `explicit` | Mencegah konversi implisit dari `QObject*` ke `KernelInfo` | Konstruktor bisa dipanggil tidak sengaja dengan pointer |
| `uname(&u)` | Mengisi `u` dengan informasi sistem: `sysname`, `nodename`, `release`, `version`, `machine` | — |
| `QString::fromLocal8Bit` | Mengonversi `char*` locale-dependent ke `QString` Unicode | Karakter non-ASCII bisa rusak |

> **Mengapa `CONSTANT`?** Rilis kernel tidak berubah selama sistem hidup (kecuali `kexec` atau livepatch, yang tetap tidak mengubah string `release`). Menandai `CONSTANT` memberi tahu mesin QML bahwa binding pada properti ini **tidak perlu pernah dievaluasi ulang**, sehingga QML bisa mengoptimalkannya.

#### 3.2 CMake: membangun modul QML

```cmake
cmake_minimum_required(VERSION 3.21)
project(kernelinfo LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Qml)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_qml_module(kernelinfo
    URI KernelInfo          # namespace impor di QML: import KernelInfo
    VERSION 1.0
    SOURCES kernelinfo.hpp
)
```

**Penjelasan per baris:**

- `qt_add_qml_module` adalah **fungsi CMake dari Qt 6** yang secara otomatis: (a) menjalankan `moc` pada header, (b) menghasilkan `qmldir` dan `*.qmltypes`, (c) mengompilasi QML ke bytecode dengan `qmlcachegen`, dan (d) menautkan semuanya menjadi plugin QML.
- `URI KernelInfo` menentukan **nama modul**. Di QML, Anda menulis `import KernelInfo`. URI tidak harus sama dengan nama proyek, tetapi sebaiknya konsisten.
- Quickshell sendiri menggunakan pola yang sama untuk modul internalnya, misalnya `qt_add_qml_module(quickshell-core URI Quickshell VERSION 0.1 ...)`.

#### 3.3 QML: memakai tipe

```qml
import KernelInfo
import QtQuick

Item {
    KernelInfo { id: ki }

    Text {
        text: ki.release
        color: 'white'
    }
}
```

**Penjelasan:** `KernelInfo { id: ki }` membuat **instance** kelas C++ di dalam pohon objek QML. Karena `KernelInfo` adalah `QObject` dengan parent QML, ia akan dihancurkan otomatis saat `Item` induk dihancurkan. Binding `text: ki.release` membaca properti `release` melalui meta-object system.

#### 3.4 Menambahkan properti kedua (nama host)

```cpp
Q_PROPERTY(QString hostname READ hostname CONSTANT)

QString hostname() const { return m_hostname; }

// di konstruktor:
m_hostname = QString::fromLocal8Bit(u.nodename);
```

Ini memenuhi latihan “tambahkan properti kedua.” Di QML: `text: ki.hostname`.

#### 3.5 [Tambahan] Properti dinamis: signal dan `NOTIFY`

`CONSTANT` hanya cocok untuk nilai yang tidak pernah berubah. Untuk nilai yang bisa berubah (mis. suhu CPU), Anda perlu **signal notifikasi**:

```cpp
Q_PROPERTY(double temperature READ temperature NOTIFY temperatureChanged)

double temperature() const { return m_temperature; }

signals:
    void temperatureChanged();

// di suatu tempat (mis. QTimer):
m_temperature = bacaSuhu();
emit temperatureChanged();   // QML akan mengevaluasi ulang binding
```

**Aturan emas:** setiap `Q_PROPERTY` yang tidak `CONSTANT` **wajib** punya `NOTIFY signal`. Tanpa itu, QML tidak akan tahu kapan harus memperbarui binding — nilai akan “beku” pada pembacaan pertama.

---

### 4. Terminologi Esensial

| Istilah | Definisi | Konteks |
|---|---|---|
| **Meta-object system** | Sistem runtime Qt yang menyimpan informasi tentang kelas: nama properti, signal, slot, tipe | Diaktifkan oleh `Q_OBJECT` dan `moc` |
| **`moc`** (Meta-Object Compiler) | Preprocessor yang membaca header dan menghasilkan kode C++ untuk meta-object | Dijalankan otomatis oleh CMake |
| **`QML_ELEMENT`** | Makro yang mendaftarkan kelas C++ sebagai tipe QML dengan nama kelasnya | Alternatif: `QML_NAMED_ELEMENT(nama)` untuk nama kustom |
| **`Q_PROPERTY`** | Makro yang mendefinisikan properti yang bisa dibaca/ditulis/diikat dari QML | Sintaks: `Q_PROPERTY(tipe nama READ getter [WRITE setter] [NOTIFY signal])` |
| **`CONSTANT`** | Atribut `Q_PROPERTY` yang menyatakan nilai tidak pernah berubah | Mengizinkan optimasi binding |
| **Plugin QML** | Pustaka dinamis (`.so`) yang berisi tipe QML tambahan | Dimuat saat `import` |
| **ABI** (Application Binary Interface) | Kontrak level biner antara kompilator dan pustaka: ukuran tipe, urutan field, konvensi pemanggilan | Quickshell **harus dibangun ulang** untuk setiap rilis Qt karena memakai API privat Qt |
| **Sanitizer** | Instrumen kompilator yang mendeteksi galat memori saat runtime | `-fsanitize=address,undefined` |
| **ASan** (AddressSanitizer) | Mendeteksi *use-after-free*, *buffer overflow*, *double free* | Overhead ~2×; tidak untuk produksi |
| **UBSan** (UndefinedBehaviorSanitizer) | Mendeteksi *signed integer overflow*, *null dereference*, *misaligned access* | Overhead rendah; bisa digabung dengan ASan |

---

### 5. Struktur Pembelajaran Internal

1. Kapan C++ dibutuhkan (dan kapan tidak)
2. Model memori Qt: parent-child dan siklus hidup objek
3. Mendaftarkan tipe C++ ke QML: `QML_ELEMENT`, `QML_NAMED_ELEMENT`, `QML_UNCREATABLE`
4. Properti, signal, slot, dan `NOTIFY`
5. Membangun dengan CMake: `qt_add_qml_module` dan jalur impor
6. Audit keamanan C++: validasi masukan, batas buffer, sanitizer, hardening
7. Debugging dengan `gdb` dan membaca *core dump*
8. **[Tambahan]** `IpcHandler`: mengekspos fungsi C++/QML ke `qs ipc call`

---

### 6. Rekomendasi Visualisasi

```text
┌────────────────────────────────────────────────────────────┐
│                     Proses Quickshell                      │
│                                                            │
│  ┌──────────────┐      ┌──────────────────────────────┐    │
│  │  QML Engine  │      │      C++ Plugin (.so)        │    │
│  │              │      │                              │    │
│  │  import      │─────►│  KernelInfo (QObject)        │    │
│  │  KernelInfo  │      │   ├─ Q_PROPERTY release      │    │
│  │              │◄─────│   ├─ Q_PROPERTY hostname     │    │
│  │  Text {      │ meta │   └─ signal ...              │    │
│  │   text:      │object│                              │    │
│  │   ki.release │      │  uname() ──► kernel          │    │
│  │  }           │      │                              │    │
│  └──────────────┘      └──────────────────────────────┘    │
│         │                         │                        │
│         │                         │                        │
│         ▼                         ▼                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Parent-child tree (QObject ownership)              │   │
│  │  Item (QML) ──parent──► KernelInfo (C++)            │   │
│  │  Saat Item dihancurkan → KernelInfo ikut dihancurkan│   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────┘
```

---

### 7. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **1.2** (`Process`, `SplitParser`) | Jika CLI sudah cukup, **jangan** menulis C++. Modul 5.1 adalah eskalasi dari 1.2. |
| **2.3–2.4** (modul layanan Quickshell) | Sebelum menulis plugin, periksa apakah layanan sudah punya modul bawaan. |
| **4.1** (sandbox) | Plugin C++ **tidak bisa** disandbox dengan `bwrap` karena berjalan di proses yang sama. Ini memperkuat alasan untuk audit ketat. |
| **5.3** (deployment) | Plugin C++ menambah dependensi build-time dan runtime yang harus dideklarasikan di PKGBUILD/flake. |

---

### 8. Sumber Referensi

- [Qt: Integrasi QML dan C++](https://doc.qt.io/qt-6/qtqml-cppintegration-topic.html) — dasar `QML_ELEMENT`, `Q_PROPERTY`, dan `qt_add_qml_module`.
- [Qt: Menulis Modul QML](https://doc.qt.io/qt-6/qt-add-qml-module.html) — referensi lengkap `qt_add_qml_module`.
- [Qt: Definisi Tipe QML dari C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) — `QML_ELEMENT` vs `QML_NAMED_ELEMENT`.
- [Quickshell DeepWiki: Code Organization](https://deepwiki.com/quickshell-mirror/quickshell/9.2-code-organization-and-module-structure) — struktur modul internal Quickshell.
- [Quickshell Build Instructions](https://github.com/quickshell-mirror/quickshell/blob/master/BUILD.md) — peringatan ABI Qt.

---

### 9. Tips dan Praktik Terbaik

1. **Gunakan `QML_NAMED_ELEMENT` untuk nama yang lebih pendek.** `QML_NAMED_ELEMENT(Kernel)` membuat tipe `Kernel` di QML, bukan `KernelInfo`.
2. **Selalu validasi masukan dari QML.** QML bisa memanggil setter dengan tipe apa pun yang kompatibel; jangan asumsikan rentang nilai.
3. **Jangan alokasikan memori di dalam getter `CONSTANT`.** Getter dipanggil berkali-kali; alokasi di sana adalah pemborosan.
4. **Gunakan `QStringView` atau `QLatin1StringView` untuk string read-only** yang tidak perlu dimiliki.
5. **Bangun dengan `-DCMAKE_BUILD_TYPE=RelWithDebInfo`** untuk produksi: optimasi tetap aktif, tetapi simbol debug tersedia untuk `gdb`.
6. **Aktifkan `-fvisibility=hidden`** dan tandai hanya simbol yang perlu diekspor. Ini mengurangi permukaan serangan dan mempercepat *dynamic linking*.
7. **Uji dengan `ASan` sebelum rilis.** `-fsanitize=address,undefined` menangkap bug yang tidak terlihat saat pengujian normal.

---

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Lupa `Q_OBJECT` | `undefined reference to vtable` atau signal tidak berfungsi | Tambahkan `Q_OBJECT` di deklarasi kelas |
| Lupa `QML_ELEMENT` | `KernelInfo is not a type` di QML | Tambahkan `QML_ELEMENT` dan pastikan header ada di `SOURCES` |
| `Q_PROPERTY` tanpa `NOTIFY` (non-`CONSTANT`) | Nilai di QML tidak pernah berubah | Tambahkan signal `NOTIFY` dan `emit` saat nilai berubah |
| Lupa `emit` | Signal dideklarasikan tetapi tidak pernah dikirim | Panggil `emit namaSignal()` di setiap tempat nilai berubah |
| Plugin tidak ditemukan saat `import` | `module "KernelInfo" is not installed` | Periksa `QML_IMPORT_PATH` atau instal ke `$XDG_DATA_DIRS` yang benar |
| ABI mismatch | Crash saat runtime setelah update Qt | Bangun ulang plugin terhadap versi Qt yang sama dengan Quickshell |
| `new` tanpa parent | Memory leak | Berikan parent (`new Foo(this)`) atau gunakan `std::unique_ptr` untuk objek non-QObject |

---

### 11. [Tambahan] `IpcHandler`: menjembatani C++/QML ke CLI

Persyaratan capstone “semua aksi via `qs ipc call`” membutuhkan `IpcHandler`. Ini adalah tipe QML dari `Quickshell.Io` yang mendaftarkan fungsi dan properti ke **peta IPC per-instance** yang bisa diakses dari CLI.

```qml
import Quickshell.Io

Item {
    Rectangle { id: rect; width: 100; height: 100; color: "red" }

    IpcHandler {
        target: "rect"                          // nama unik di peta IPC

        function setColor(color: color): void { // tipe argumen WAJIB eksplisit
            rect.color = color;
        }
        function getColor(): color {
            return rect.color;
        }
        function setRadius(radius: int): void {
            rect.radius = radius;
            this.radiusChanged(radius);         // signal ke remote listener
        }
        signal radiusChanged(newRadius: int);
    }
}
```

```bash
qs ipc show                     # daftar semua target terdaftar
qs ipc show target rect         # daftar fungsi/signal target "rect"
qs ipc call rect setColor orange
qs ipc call rect getColor       # → #ffffa500
```

**Aturan penting:** argumen dan tipe kembalian **harus dianotasi secara eksplisit**. Tanpa anotasi, fungsi tidak akan terdaftar. Tipe yang didukung: `string`, `int`, `bool`, `real`, `color`.

> **Motivasi:** Setiap baris C++ yang Anda tulis adalah kekuatan yang tidak dimiliki QML — tetapi juga risiko yang tidak dimiliki QML. Kuasai pedang ini, dan Anda tidak lagi dibatasi oleh apa pun yang sudah “dibungkus” orang lain.

---

## Modul 5.2 — Optimasi Performa dan Profiling

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan **metodologi pengukuran** sebelum optimasi: menggunakan `perf` untuk CPU, `heaptrack` untuk memori, dan variabel lingkungan `QSG_*` untuk render. Tujuannya bukan membuat shell “terasa cepat,” tetapi **membuktikan dengan angka** bahwa perubahan tertentu menurunkan penggunaan sumber daya.

**Mengapa penting:** Shell berjalan **terus-menerus** (24/7). Perbedaan 1% CPU antara shell yang dioptimalkan dan tidak, berarti perbedaan 1% baterai per jam — dan pada laptop, itu signifikan. Shell yang boros juga berkontribusi pada *thermal throttling* dan memperpendek usia perangkat.

---

### 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “ukur dulu, jangan menebak.”** Seorang dokter tidak memberi obat sebelum diagnosis. Demikian pula, Anda tidak boleh “mengoptimalkan” bagian kode yang tidak pernah muncul di profil. 90% waktu eksekusi biasanya dihabiskan di 10% kode; tanpa profil, Anda akan mengoptimalkan 90% kode yang tidak penting.

**Prinsip “kerja yang tidak perlu adalah kerja yang paling mahal.”** Kemenangan performa terbesar bukan dari menulis kode C++ yang lebih cepat, tetapi dari **menghilangkan pekerjaan**: mengganti polling dengan modul reaktif (`SystemClock`), menunda pembuatan jendela (`LazyLoader`), dan mengurangi *overdraw*. Ini sejalan dengan filosofi **monolitik yang efisien**: satu proses harus ringan.

**Model mental Scene Graph.** Qt Quick tidak menggambar QML secara langsung. Ia membangun **scene graph** — struktur pohon node render — dan mengirimkannya ke GPU. Setiap perubahan properti yang memengaruhi geometri atau material memicu **sinkronisasi scene graph**, yang bisa mahal. Binding yang dievaluasi ulang setiap frame, atau `anchors` yang berubah setiap piksel animasi, memaksa sinkronisasi berulang.

---

### 3. Sintaks Dasar / Contoh Implementasi Inti

#### 3.1 Profiling CPU dengan `perf`

```bash
# Statistik ringkas: cycles, instructions, cache-misses
perf stat -p $(pgrep -x quickshell)

# Rekam profil selama 30 detik, lalu buka laporan interaktif
perf record -g -p $(pgrep -x quickshell) -- sleep 30
perf report
```

**Cara membaca `perf report`:**

- Kolom **Overhead** menunjukkan persentase waktu CPU yang dihabiskan di fungsi tersebut.
- Kolom **Command** adalah proses (biasanya `quickshell`).
- Kolom **Shared Object** menunjukkan pustaka asal fungsi (`libQt6Quick.so`, `quickshell`, dll.).
- Tekan `Enter` pada suatu fungsi untuk melihat **call graph**: siapa yang memanggilnya dan apa yang dipanggilnya.

> **Yang dicari:** fungsi Qt Quick (`QSG*`, `QQuick*`) dengan overhead tinggi menandakan masalah render; fungsi JavaScript (`QV4::*`) menandakan binding atau `Qt.callLater` yang mahal; fungsi `malloc`/`free` menandakan alokasi berlebihan.

#### 3.2 Profiling memori dengan `heaptrack`

```bash
heaptrack quickshell -c my-shell
# Setelah shell ditutup:
heaptrack_gui /tmp/heaptrack.quickshell.PID.gz
# Atau analisis teks:
heaptrack_print /tmp/heaptrack.quickshell.PID.gz
```

`heaptrack` melacak **setiap alokasi** dan menganotasinya dengan *stack trace*. Yang dicari:

- **Peak memory** dan **leaked memory** di ringkasan.
- **Temporary allocations** tinggi: alokasi yang segera dibebaskan — kandidat untuk *caching* atau `reserve()`.
- **Allocation hotspots**: fungsi yang paling banyak memanggil `malloc`.

> **Mengapa bukan `valgrind`?** `valgrind` memperlambat aplikasi 20–50×; untuk GUI berat seperti Quickshell, interaksi menjadi tidak mungkin. `heaptrack` memiliki overhead jauh lebih rendah dan dirancang untuk aplikasi GUI.

#### 3.3 Variabel lingkungan `QSG_*`

```bash
# Waktu render per frame (cetak ke stderr)
QSG_RENDER_TIMING=1 quickshell -c my-shell

# Visualisasi overdraw: area yang digambar berulang tampil merah/ungu
QSG_VISUALIZE=overdraw quickshell -c my-shell

# Visualisasi batch: efisiensi batching draw call
QSG_VISUALIZE=batches quickshell -c my-shell
```

**Target frame time:** 16.67 ms untuk 60 Hz. Jika `QSG_RENDER_TIMING` konsisten menunjukkan >16 ms saat idle, ada yang salah: mungkin ada animasi yang berjalan terus-menerus, atau *overdraw* ekstrem.

#### 3.4 `LazyLoader`: pembuatan objek tertunda

```qml
LazyLoader {
    active: launcherOpen          // hanya buat isi saat true
    PanelWindow {
        // launcher
    }
}
```

**Mengapa penting:** `PanelWindow` yang selalu ada di pohon objek mengonsumsi memori dan GPU meskipun tidak terlihat. `LazyLoader` menunda pembuatan sampai benar-benar dibutuhkan; saat `active` menjadi `false`, isinya bisa dihancurkan (tergantung properti `active`).

#### 3.5 [Tambahan] Menghindari binding mahal

```qml
// Buruk: dievaluasi ulang setiap kali parent.width, parent.height,
// atau CpuService.usagePercent berubah — dan ekspresinya kompleks
Text {
    text: parent.width * parent.height / CpuService.usagePercent / 100 * 2
}

// Baik: pra-komputasi nilai yang jarang berubah
property int area: parent.width * parent.height
Text {
    text: area / CpuService.usagePercent / 100 * 2
}
```

**Prinsip:** binding QML dievaluasi ulang ketika **salah satu dependensinya** berubah. Jika ekspresi bergantung pada 5 properti, dan salah satunya berubah 60×/detik, seluruh ekspresi dievaluasi 60×/detik. Pra-komputasi memisahkan dependensi yang berubah cepat dari yang lambat.

---

### 4. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **`perf`** | Alat profiling Linux yang membaca *performance counter* perangkat keras dan *software event* |
| **`perf record` / `perf report`** | Merekam sampel profil / membuka laporan interaktif |
| **Call graph** | Pohon pemanggilan fungsi: siapa memanggil siapa |
| **`heaptrack`** | Pelacak alokasi memori dengan overhead rendah, dirancang untuk aplikasi GUI |
| **Overdraw** | Menggambar piksel yang sama lebih dari sekali dalam satu frame; membuang bandwidth GPU |
| **Scene graph** | Struktur data yang dikirim Qt Quick ke GPU untuk dirender |
| **Frame time** | Waktu dari mulai menggambar satu frame hingga selesai; target <16 ms untuk 60 Hz |
| **`LazyLoader`** | Komponen QML yang menunda pembuatan isinya sampai `active` bernilai `true` |
| **Binding loop** | Siklus dependensi antar-binding yang menyebabkan evaluasi tak berujung; Quickshell biasanya mendeteksi dan memperingatkannya |

---

### 5. Struktur Pembelajaran Internal

1. Profiling CPU dengan `perf`: `stat`, `record`, `report`
2. Membaca `perf report`: overhead, call graph, dan hotspot
3. Profiling memori dengan `heaptrack`: peak, leak, dan temporary allocation
4. Variabel `QSG_*`: `RENDER_TIMING`, `VISUALIZE=overdraw`, `VISUALIZE=batches`
5. Menghindari binding dan JavaScript mahal
6. `ListView` vs `Repeater` untuk daftar panjang: delegasi yang di-reuse vs dibuat semua
7. `LazyLoader` dan `Loader`: perbedaan dan kapan memakai masing-masing
8. Benchmark sebelum/sesudah: metodologi dan pelaporan angka
9. **[Tambahan]** `qs ipc call` untuk mengukur responsivitas IPC

---

### 6. Rekomendasi Visualisasi

```text
Alur kerja optimasi:

  ┌─────────┐    ┌──────────────┐    ┌─────────────┐    ┌───────────┐
  │  UKUR   │───►│  TEMUKAN     │───►│   UBAH      │───►│  UKUR     │
  │ (perf,  │    │  HOTSPOT     │    │   SATU HAL  │    │  LAGI     │
  │heaptrack│    │ (call graph, │    │   SAJA      │    │ (angka    │
  │ QSG_*)  │    │  overdraw)   │    │             │    │ sebelum   │
  └─────────┘    └──────────────┘    └─────────────┘    │ vs sesudah│
       ▲                                                └───────────┘
       │                                                     │
       └─────────────────────────────────────────────────────┘
                    (ulangi sampai target tercapai)
```

```text
Overdraw (tampak atas):

  ┌──────────────────────────────────────┐
  │  Latar belakang jendela (1×)         │
  │  ┌────────────────────────────────┐  │
  │  │  Panel bar (2×)                │  │
  │  │  ┌──────────────────────────┐  │  │
  │  │  │  Widget jam (3×)         │  │  │
  │  │  └──────────────────────────┘  │  │
  │  └────────────────────────────────┘  │
  └──────────────────────────────────────┘
  Area gelap = overdraw tinggi.
  Solusi: jadikan latar belakang widget transparan,
  atau gunakan `layer.enabled` dengan hati-hati.
```

---

### 7. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **1.2** (`Process`, polling) | Mengganti polling `date` dengan `SystemClock` adalah optimalisasi paling umum dan paling mudah diukur. |
| **3.2** (binding dan `Connections`) | Binding loop dan `onValueChanged` yang salah adalah sumber utama pemborosan CPU. |
| **5.1** (plugin C++) | Jika profiling menunjukkan hotspot di JavaScript/QML, pindahkan logika berat ke C++. Ini adalah **eskalasi berbasis bukti**, bukan spekulasi. |
| **Capstone** | Persyaratan “hardening yang diukur” dan “pulih otomatis saat crash” membutuhkan baseline performa yang terdokumentasi. |

---

### 8. Sumber Referensi

- [Qt Quick Performance](https://doc.qt.io/qt-6/qtquick-performance.html) — panduan resmi optimasi.
- [perf Wiki](https://perf.wiki.kernel.org/) — dokumentasi `perf`.
- [heaptrack (KDE)](https://github.com/kde/heaptrack) — pelacak memori.
- [The Quickshell Book: Performance Profiling](https://programmersd21.github.io/the_quickshell_book/part-12-advanced/performance-profiling) — contoh praktis untuk Quickshell.
- [Arch Wiki: Improving performance](https://wiki.archlinux.org/title/Improving_performance) — konteks sistem.

---

### 9. Tips dan Praktik Terbaik

1. **Ukur saat idle dan saat sibuk.** Shell yang idle 0% CPU tetapi 40% saat animasi mungkin masih dapat diterima; shell yang idle 5% CPU adalah masalah.
2. **Gunakan `perf stat` untuk baseline cepat**, `perf record` hanya ketika Anda perlu tahu *di mana* waktu dihabiskan.
3. **Jalankan `heaptrack` setidaknya sekali per siklus rilis** untuk menangkap regresi memori.
4. **Jangan mengoptimalkan tanpa angka pembanding.** Catat `perf stat` sebelum dan sesudah setiap perubahan.
5. **Prioritaskan menghilangkan pekerjaan** (polling → reaktif, eager → lazy) di atas mikro-optimasi.
6. **Waspadai `QSG_VISUALIZE=overdraw` pada shell transparan.** Overdraw tinggi belum tentu bug; tetapi jika area yang sama digambar 5×, itu kandidat kuat untuk diperbaiki.
7. **`ListView` untuk daftar >20 item**; `Repeater` membuat semua delegasi sekaligus dan tidak cocok untuk daftar panjang.

---

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mengoptimalkan tanpa profil | Perubahan tidak berdampak atau malah memperburuk | Selalu mulai dari `perf`/`heaptrack` |
| Mengukur dengan build `Debug` | Angka tidak representatif | Gunakan `RelWithDebInfo` |
| Lupa mematikan `QSG_RENDER_TIMING` setelah selesai | Output stderr membanjiri log | Variabel lingkungan hanya aktif per-proses; jangan diekspor global |
| Binding loop tidak terdeteksi | CPU 100%, UI membeku | Periksa log Quickshell; hindari binding yang saling bergantung secara sirkular |
| `LazyLoader` dengan `active: true` permanen | Tidak ada manfaat | Pastikan `active` benar-benar berubah dari `false` ke `true` |
| Mengukur `perf` pada proses yang baru mulai | Sampel tidak cukup | Tunggu shell stabil (5–10 detik) sebelum `perf record` |

---

> **Motivasi:** Angka adalah bahasa paling jujur dalam rekayasa. Ketika Anda bisa menunjukkan “CPU turun dari 4,2% ke 0,3%,” Anda tidak lagi berdebat dengan opini — Anda berbicara dengan bukti.

---

## Modul 5.3 — Deployment, CI/CD, dan Kontribusi Upstream

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menutup kurikulum dengan **mengubah shell dari proyek pribadi menjadi artefak yang dapat dipasang, direproduksi, dan diaudit orang lain**. Cakupannya: PKGBUILD untuk Arch, Nix flake untuk reproduksibilitas, CI untuk linting dan uji asap, keamanan rantai pasok, dan kontribusi ke upstream.

**Mengapa penting:** Shell yang hanya berjalan di mesin Anda tidak dapat diverifikasi orang lain. Deployment yang baik memungkinkan **audit eksternal**, **reproduksi bug**, dan **kolaborasi**. Ini adalah pembeda antara “hobi” dan “rekayasa perangkat lunak.”

---

### 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “segel pada botol obat.”** Ketika Anda mengemas shell, Anda memberi jaminan bahwa isi paket **tidak berubah** sejak Anda menutupnya. Checksum adalah segel itu. Tanpa checksum, siapa pun yang mengubah sumber (atau server yang diretas) dapat menyisipkan kode berbahaya tanpa terdeteksi.

**Prinsip rantai pasok: percaya tetapi verifikasi.** Setiap komponen yang masuk ke build Anda adalah permukaan serangan: sumber tarball, dependensi, GitHub Actions, bahkan tag rilis. **Pin ke SHA commit** menghilangkan kemampuan pihak lain untuk menggeser tag ke commit berbahaya. **Izin minimal** pada CI membatasi kerusakan jika token bocor.

**Reproducibility sebagai auditabilitas.** Nix flake dengan `flake.lock` menjamin bahwa build yang sama menghasilkan output yang sama, di mana pun dan kapan pun. Ini memungkinkan siapa pun **membangun ulang dari sumber** dan membandingkan hash — fondasi dari **reproducible builds** yang menjadi standar keamanan rantai pasok modern.

---

### 3. Sintaks Dasar / Contoh Implementasi Inti

#### 3.1 PKGBUILD yang aman

```bash
pkgname=my-quickshell
pkgver=1.0
pkgrel=1
pkgdesc='Shell Quickshell kustom'
arch=('any')
license=('MIT')
depends=('quickshell' 'qt6-svg' 'qt6-5compat')
source=("$pkgname-$pkgver.tar.gz")
sha256sums=('GANTI_DENGAN_CHECKSUM_ASLI')   # hasilkan dengan: updpkgsums

package() {
    cd "$srcdir/$pkgname-$pkgver"
    install -d "$pkgdir/etc/xdg/quickshell/my-shell"
    cp -r --no-preserve=ownership . "$pkgdir/etc/xdg/quickshell/my-shell/"
}
```

**Penjelasan:**

- `sha256sums` adalah **segel kriptografis**. `updpkgsums` menghitung hash dari `source` dan menuliskannya ke PKGBUILD. Jangan pernah menggunakan `SKIP` — itu meniadakan seluruh tujuan auditabilitas.
- `install -d` membuat direktori tujuan dengan mode default yang aman.
- `cp -r --no-preserve=ownership` menyalin konfigurasi tanpa mempertahankan kepemilikan asli (yang mungkin berisi UID pengguna Anda).
- Instalasi ke `/etc/xdg/quickshell/<nama>` memanfaatkan `$XDG_CONFIG_DIRS` yang dicari Quickshell. Pengguna menjalankan `quickshell -c my-shell`.

#### 3.2 [Tambahan] Reproducible build dengan `SOURCE_DATE_EPOCH`

```bash
# Di PKGBUILD, sebelum build:
export SOURCE_DATE_EPOCH=$(stat -c %Y "$srcdir/$pkgname-$pkgver.tar.gz")
```

Ini membekukan timestamp yang tertanam di artefak build (mis. `__DATE__`, header arsip), sehingga dua build dari sumber yang sama menghasilkan hash yang sama.

#### 3.3 CI dengan GitHub Actions

```yaml
name: CI
on: [push, pull_request]
permissions:
  contents: read                    # izin minimal: hanya baca repo
jobs:
  lint:
    runs-on: ubuntu-latest
    container: archlinux:latest
    steps:
      - uses: actions/checkout@<SHA-COMMIT-LENGKAP>   # pin ke commit, bukan tag
      - run: pacman -Syu --noconfirm qt6-declarative
      - run: find . -name '*.qml' -print0 | xargs -0 /usr/lib/qt6/bin/qmllint
```

**Mengapa pin ke SHA?** Tag seperti `v4` dapat digeser ke commit lain oleh pemilik repositori Action. Jika akun mereka diretas, penyerang dapat menggeser tag ke kode berbahaya, dan CI Anda akan menjalankannya. SHA commit **tidak bisa diubah** — itu adalah bagian dari riwayat Git.

**Mengapa `permissions: contents: read`?** Token `GITHUB_TOKEN` default memiliki izin tulis di banyak cakupan. Jika Action yang Anda gunakan diretas, token itu bisa digunakan untuk memodifikasi repo Anda. Izin minimal membatasi dampak.

#### 3.4 [Tambahan] Smoke test headless

```yaml
      - name: Smoke test
        run: |
          # Jalankan shell, tunggu 10 detik, lalu matikan.
          # Exit code non-zero menandakan shell gagal start.
          timeout 10s quickshell -c my-shell --no-daemon || test $? -eq 124
```

**Penjelasan:** `timeout 10s` mengirim `SIGTERM` setelah 10 detik. Jika shell berjalan stabil, exit code adalah `124` (timeout) — itu **lulus**. Jika shell crash, exit code adalah non-zero selain `124` — itu **gagal**. Ini adalah uji asap minimal yang menangkap error sintaks, impor yang hilang, dan crash saat startup.

#### 3.5 Nix flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, quickshell }: {
    packages.x86_64-linux.default = quickshell.packages.x86_64-linux.default;
  };
}
```

**Penjelasan:**

- `inputs.nixpkgs.follows = "nixpkgs"` memaksa `quickshell` menggunakan `nixpkgs` yang sama dengan flake Anda, menghindari duplikasi dependensi.
- `flake.lock` (dihasilkan otomatis) mengunci versi tepat dari setiap input. Ini adalah **segel reproducibility**.
- Quickshell menyediakan flake bawaan yang dapat digunakan langsung.

---

### 4. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **PKGBUILD** | Skrip bash yang mendefinisikan cara membangun paket Arch: sumber, checksum, dependensi, dan fungsi `package()` |
| **`sha256sums`** | Daftar hash SHA-256 dari setiap sumber; memverifikasi integritas |
| **`updpkgsums`** | Alat yang menghitung ulang checksum dan memperbarui PKGBUILD |
| **Nix flake** | Konfigurasi Nix yang mendefinisikan input (dependensi) dan output (paket) |
| **`flake.lock`** | Berkas yang mengunci versi tepat dari setiap input flake |
| **`qmllint`** | Pemeriksa statis QML: sintaks, impor, dan peringatan |
| **Pin ke SHA** | Mengacu pada commit Git tertentu, bukan tag yang bisa digeser |
| **CI/CD** | *Continuous Integration / Continuous Deployment*: otomatisasi build, uji, dan rilis |
| **Smoke test** | Uji cepat yang memverifikasi fungsionalitas dasar (mis. shell bisa start) |
| **Supply chain** | Seluruh sumber, alat, dan dependensi yang masuk ke perangkat lunak Anda |
| **`SOURCE_DATE_EPOCH`** | Variabel lingkungan yang membekukan timestamp untuk build reproducible |

---

### 5. Struktur Pembelajaran Internal

1. PKGBUILD: struktur, checksum, dan `package()`
2. Membangun di chroot bersih (`makechrootpkg` atau `devtools`)
3. Nix flake: input, output, dan `flake.lock`
4. CI: linting QML dengan `qmllint`
5. **[Tambahan]** Smoke test headless dan exit code
6. Keamanan rantai pasok: pin SHA, tag bertanda tangan, izin minimal
7. Membangun Quickshell dari source (HACKING.md)
8. Berkontribusi ke upstream: mulai dari perbaikan kecil
9. Publikasi ke AUR dan pemeliharaan

---

### 6. Rekomendasi Visualisasi

```text
Alur deployment dan keamanan rantai pasok:

  ┌─────────┐   ┌──────────┐   ┌────────────┐   ┌──────────────┐
  │  Kode   │──►│ qmllint  │──►│ Smoke test │──►│    Paket     │
  │ (repo)  │   │ (sintaks)│   │ (headless) │   │ (PKGBUILD/   │
  └─────────┘   └──────────┘   └────────────┘   │  flake)      │
       │                                        └──────┬───────┘
       │                                               │
       ▼                                               ▼
  ┌───────────────────────────────────────────────────────────┐
  │  CI (izin minimal, semua Action di-pin ke SHA)            │
  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌───────────────┐ │
  │  │ checkout│  │ qmllint │  │ smoke   │  │ build paket   │ │
  │  │ @SHA    │  │         │  │ test    │  │ (reproducible)│ │
  │  └─────────┘  └─────────┘  └─────────┘  └───────┬───────┘ │
  └─────────────────────────────────────────────────┼─────────┘
                                                    │
                                                    ▼
                                        ┌─────────────────────┐
                                        │  Rilis bertanda     │
                                        │  tangan (GPG)       │
                                        └──────────┬──────────┘
                                                   │
                                    ┌──────────────┴──────────────┐
                                    ▼                             ▼
                              ┌──────────┐                 ┌──────────┐
                              │   AUR    │                 │   Nix    │
                              └──────────┘                 └──────────┘
```

---

### 7. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **5.1** (plugin C++) | Jika shell menyertakan plugin C++, PKGBUILD harus mendeklarasikan dependensi Qt yang sesuai dan membangun plugin terhadap Qt yang sama. |
| **5.2** (optimasi) | Smoke test dan CI memastikan bahwa optimasi tidak merusak fungsionalitas. |
| **Capstone** | Persyaratan 9 (PKGBUILD/flake + CI) dan 10 (threat model + README) secara langsung membutuhkan modul ini. |
| **4.1–4.2** (sandbox, lockscreen) | Unit systemd yang dihasilkan oleh deployment harus mencerminkan hardening yang telah diuji di Fase 4. |

---

### 8. Sumber Referensi

- [Arch Wiki: PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) — referensi lengkap.
- [Arch Wiki: Creating packages](https://wiki.archlinux.org/title/Creating_packages) — panduan langkah demi langkah.
- [Nix Flakes (wiki resmi)](https://wiki.nixos.org/wiki/Flakes) — dokumentasi flake.
- [Quickshell Build Instructions](https://github.com/quickshell-mirror/quickshell/blob/master/BUILD.md) — flag `DISTRIBUTOR`, `INSTALL_QML_PREFIX`, dan catatan ABI.
- [Quickshell Installation & Setup](https://quickshell.org/docs/guide/install-setup) — ketersediaan di AUR dan Nixpkgs.
- [GitHub: Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions) — pin SHA dan izin minimal.

---

### 9. Tips dan Praktik Terbaik

1. **Selalu jalankan `updpkgsums` setelah mengubah `source`.** Jangan pernah menulis checksum secara manual.
2. **Bangun di chroot bersih** (`makechrootpkg -c -r $CHROOT`) untuk memastikan tidak ada dependensi tersembunyi dari sistem Anda.
3. **Pin semua Action ke SHA commit lengkap**, bukan tag. Perbarui secara berkala dengan alat seperti Dependabot atau Renovate.
4. **Gunakan `permissions:` minimal** di setiap workflow. Mulai dari `contents: read` dan tambahkan hanya yang benar-benar diperlukan.
5. **Tanda tangani tag rilis dengan GPG** dan verifikasi tanda tangan sebelum mengemas.
6. **Sertakan `flake.lock` dalam repositori** — ini adalah bagian dari reproducibility.
7. **Dokumentasikan cara memasang dan berkontribusi di README** — ini adalah bagian dari rubrik capstone.
8. **Mulai kontribusi upstream dari perbaikan dokumentasi atau typo.** Ini membangun kepercayaan dan pemahaman kode sebelum perubahan yang lebih besar.

---

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `sha256sums=('SKIP')` | Paket dapat dibangun dengan sumber apa pun — tidak ada jaminan integritas | Selalu gunakan checksum asli dari `updpkgsums` |
| Action di-pin ke tag (`@v4`) | Tag bisa digeser ke commit berbahaya | Ganti dengan `@<SHA-COMMIT-LENGKAP>` |
| `permissions: write-all` | Token bocor dapat memodifikasi repo | Gunakan izin minimal per-job |
| Smoke test tidak ada | Crash saat startup tidak terdeteksi hingga pengguna melaporkannya | Tambahkan `timeout` + cek exit code |
| Build tidak reproducible | Hash berbeda setiap build | Set `SOURCE_DATE_EPOCH` dan hindari timestamp dinamis |
| `cp` mempertahankan kepemilikan | File di paket dimiliki UID pengguna build | Gunakan `--no-preserve=ownership` |
| Flake tanpa `nixpkgs.follows` | Duplikasi dependensi dan versi tidak konsisten | Tambahkan `inputs.nixpkgs.follows = "nixpkgs"` |

---

> **Motivasi:** Kode yang tidak dapat dipasang orang lain adalah kode yang tidak dapat dipercaya. Dengan mengemas dan menandatangani shell Anda, Anda tidak hanya membagikan perangkat lunak — Anda membagikan **jaminan** bahwa apa yang Anda tulis adalah apa yang mereka jalankan.

---

## Ringkasan Fase 5

| Modul | Inti | Hasil yang Dapat Diukur |
|---|---|---|
| **5.1** | Plugin C++ via `qt_add_qml_module`, `QML_ELEMENT`, `Q_PROPERTY`, sanitizer, `IpcHandler` | Modul `KernelInfo` dengan dua properti, berjalan di bawah ASan/UBSan tanpa error |
| **5.2** | `perf`, `heaptrack`, `QSG_*`, `LazyLoader`, penghindaran binding mahal | Angka `perf stat` sebelum/sesudah; satu area overdraw yang dihilangkan |
| **5.3** | PKGBUILD aman, Nix flake, CI dengan pin SHA, smoke test, kontribusi upstream | Paket dapat dibangun di chroot bersih; CI lulus; satu perbaikan dokumentasi dikirim ke upstream |

Fase 5 adalah tentang **mengubah penguasaan menjadi bukti**: plugin yang diaudit, optimasi yang terukur, dan paket yang dapat direproduksi. Ini adalah fase yang membedakan “seseorang yang bisa menulis Quickshell” dari “insinyur yang dapat dipercaya untuk membangun dan memelihara shell untuk orang lain.”

---

# Proyek Capstone — Shell Mandiri End-to-End

> **Audit singkat sebelum materi:** Capstone dalam kurikulum asli sudah menyebut 10 persyaratan dan rubrik, tetapi **belum menjelaskan arsitektur integrasi antar-persyaratan**, **urutan pengerjaan yang realistis**, **cara membuktikan setiap kriteria rubrik**, dan **jebakan integrasi** (mis. bagaimana `IpcHandler` berinteraksi dengan `WlSessionLock`, atau bagaimana `bwrap` berinteraksi dengan unit systemd). Materi di bawah mengisi celah tersebut. Setiap penambahan ditandai **[Tambahan]** .

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Capstone adalah **ujian akhir yang bersifat konstruktif**: Anda tidak menjawab soal, Anda membangun sistem. Perannya adalah memaksa Anda **mengintegrasikan seluruh fase** — dari Fase −1 (konsep dasar) hingga Fase 5 (plugin C++, optimasi, deployment) — ke dalam satu artefak yang dapat dijalankan, diaudit, dan dipasang orang lain.

**Mengapa penting:** Setiap modul dalam kurikulum mengajarkan satu keterampilan secara terisolasi. Capstone menguji apakah Anda dapat **menyatukan keterampilan yang terpisah** menjadi sistem yang koheren. Ini adalah pembeda antara “tahu cara memakai `PanelWindow`” dan “bisa membangun shell yang dipakai orang setiap hari.”

**Peran dalam kurikulum:** Capstone adalah **gerbang kelulusan**. Rubriknya bukan sekadar daftar fitur, tetapi **bukti yang dapat diverifikasi**. Anda tidak cukup mengatakan “lockscreen saya aman”; Anda harus menunjukkan bahwa lockscreen **lolos uji `kill -9`**.

---

## 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “sistem, bukan kumpulan fitur.”** Shell yang baik bukan sekumpulan widget yang ditempel. Ia adalah **sistem dengan arah dependensi yang jelas**: UI bergantung pada layanan, layanan bergantung pada sistem. Jika arah ini dilanggar — misalnya widget jam memanggil `Process` secara langsung — sistem menjadi rapuh: sulit diuji, sulit diganti, dan sulit diaudit.

**Prinsip “least privilege pada setiap batas.”** Setiap komponen mendapat hak sekecil mungkin:
- Bar tidak butuh akses ke PAM.
- Launcher tidak butuh akses ke jaringan.
- Proses pembantu yang memproses data tidak tepercaya berjalan di `bwrap`, bukan di proses utama.
- Unit systemd tidak berjalan sebagai root dan tidak memiliki `CAP_SYS_ADMIN`.

**Prinsip “fail-safe, bukan fail-open.”** Ketika lockscreen gagal — PAM error, proses mati, sinyal terputus — sistem harus berakhir pada **keadaan aman** (terkunci), bukan keadaan terbuka. Ini adalah prinsip yang sama dengan *fail-safe* pada sistem kendali nuklir: kegagalan harus menuju keadaan yang tidak berbahaya.

**Prinsip “dapat direproduksi, dapat diaudit.”** Shell yang baik dapat dibangun ulang dari sumber oleh orang lain dan menghasilkan hash yang sama. Ini memungkinkan audit independen dan mencegah *supply chain attack*.

**Model mental arsitektur:** Bayangkan shell sebagai **lapisan bawang**:

```text
┌────────────────────────────────────────────────────────────┐
│  Lapisan 4: UI (QML)                                       │
│  Bar, Launcher, OSD, Lockscreen, Notification popup        │
│  ─ Bergantung pada →                                       │
├────────────────────────────────────────────────────────────┤
│  Lapisan 3: Layanan (QML singleton + C++ bila perlu)       │
│  WorkspaceService, AudioService, BatteryService,           │
│  NotificationService, LauncherService, LockService         │
│  ─ Bergantung pada →                                       │
├────────────────────────────────────────────────────────────┤
│  Lapisan 2: Integrasi Sistem (Process, D-Bus, IPC)         │
│  PipeWire, UPower, MPRIS, Hyprland IPC, PAM, systemd       │
│  ─ Bergantung pada →                                       │
├────────────────────────────────────────────────────────────┤
│  Lapisan 1: Sistem Operasi                                 │
│  Kernel, Wayland compositor, D-Bus daemon, systemd         │
└────────────────────────────────────────────────────────────┘
```

**Aturan arah dependensi:** Lapisan atas boleh bergantung pada lapisan bawah; lapisan bawah **tidak boleh** mengetahui lapisan atas. Bar tidak boleh tahu bahwa ada lockscreen; lockscreen tidak boleh tahu bahwa ada bar.

---

## 3. Sintaks Dasar / Contoh Implementasi Inti

### 3.1 Struktur Direktori Proyek

```text
my-shell/
├── shell.qml                    # entry point: import semua service, buat UI
├── services/                    # Lapisan 3: layanan
│   ├── WorkspaceService.qml     # singleton
│   ├── AudioService.qml
│   ├── BatteryService.qml
│   ├── NotificationService.qml
│   ├── LauncherService.qml
│   └── LockService.qml
├── ui/                          # Lapisan 4: UI
│   ├── Bar.qml
│   ├── Launcher.qml
│   ├── Osd.qml
│   ├── LockScreen.qml
│   └── NotificationPopup.qml
├── helpers/                     # proses pembantu (bwrap)
│   ├── notif-helper.sh
│   └── bwrap-wrapper.sh
├── systemd/
│   └── my-shell.service         # unit systemd --user
├── packaging/
│   ├── PKGBUILD
│   └── flake.nix
├── .github/workflows/ci.yml
├── THREAT_MODEL.md
└── README.md
```

**Penjelasan:** Pemisahan `services/` dan `ui/` **memaksa** arah dependensi. `ui/Bar.qml` mengimpor `services/AudioService.qml`, tetapi `services/AudioService.qml` tidak pernah mengimpor `ui/Bar.qml`.

### 3.2 Singleton Layanan: `AudioService.qml`

```qml
// services/AudioService.qml
pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    // Sumber tunggal kebenaran: satu objek Pipewire untuk seluruh shell
    readonly property PipewireDefaultSink sink: Pipewire.defaultAudioSink

    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property bool muted: sink?.audio?.muted ?? true

    // Semua perubahan volume melewati fungsi ini — tidak ada yang menulis
    // langsung ke sink.audio.volume dari UI.
    function setVolume(v: real): void {
        if (!sink?.audio) return;
        sink.audio.volume = Math.max(0.0, Math.min(1.0, v));
    }

    function toggleMute(): void {
        if (!sink?.audio) return;
        sink.audio.muted = !sink.audio.muted;
    }

    function adjust(delta: real): void {
        setVolume(volume + delta);
    }
}
```

**Penjelasan kata demi kata:**

| Elemen | Fungsi |
|---|---|
| `pragma Singleton` | Menandai berkas ini sebagai singleton; hanya ada satu instance di seluruh shell |
| `Singleton { ... }` | Tipe dasar Quickshell untuk singleton (bukan `Item`, karena tidak punya visual) |
| `readonly property` | Properti yang tidak bisa ditulis dari luar; hanya bisa dibaca |
| `sink?.audio?.volume` | *Optional chaining*: jika `sink` atau `audio` null, ekspresi menghasilkan `undefined` alih-alih error |
| `?? 0.0` | *Nullish coalescing*: jika hasil kiri `null`/`undefined`, gunakan `0.0` |
| `function setVolume` | Fungsi publik yang menjadi **satu-satunya jalur tulis** ke volume |

**Mengapa singleton?** Jika setiap widget membuat `Pipewire` sendiri, Anda memiliki 5 objek yang memantau sink yang sama, 5 koneksi D-Bus, dan 5 sumber kebenaran yang bisa berbeda. Singleton memastikan **satu sumber kebenaran**.

### 3.3 Bar Multi-Monitor: `ui/Bar.qml`

```qml
// ui/Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../services"

Variants {
    // Satu Bar per layar — Variants membuat instance untuk setiap layar
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 32
        color: "#1e1e2e"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8

            WorkspaceWidget { }      // dari services/WorkspaceService.qml
            Item { Layout.fillWidth: true }
            ClockWidget { }
            AudioWidget { }          // membaca AudioService
            BatteryWidget { }        // membaca BatteryService
            TrayWidget { }
        }
    }
}
```

**Penjelasan:**

- `Variants { model: Quickshell.screens }` membuat **satu instance `PanelWindow` untuk setiap layar**. Properti `modelData` berisi objek layar.
- `required property var modelData` mendeklarasikan bahwa properti ini **wajib** diisi oleh `Variants`; tanpa `required`, QML akan menganggapnya opsional dan Anda bisa lupa mengisinya.
- `screen: modelData` menempelkan jendela ke layar yang benar.
- `anchors { top: true; left: true; right: true }` membuat bar menempel di atas dan melebar penuh.
- `implicitHeight: 32` menentukan tinggi bar; `implicit` berarti “tinggi yang disarankan,” bukan “tinggi paksa.”

### 3.4 Launcher dengan Mode Modal

```qml
// ui/Launcher.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../services"

LazyLoader {
    id: launcherLoader
    active: false

    PanelWindow {
        id: win
        anchors { top: true; bottom: true; left: true; right: true }
        color: "#80000000"
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        // Mode modal: menangkap semua input keyboard
        focus: true

        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.6, 600)

            TextField {
                id: query
                Layout.fillWidth: true
                placeholderText: "Cari aplikasi..."
                onTextChanged: LauncherService.filter(text)
                Keys.onEscapePressed: launcherLoader.active = false
                Keys.onDownPressed: results.currentIndex++
                Keys.onUpPressed: results.currentIndex--
                Keys.onReturnPressed: results.activate(results.currentIndex)
            }

            ListView {
                id: results
                Layout.fillWidth: true
                Layout.preferredHeight: 400
                model: LauncherService.filtered
                currentIndex: 0
                delegate: Rectangle {
                    width: results.width
                    height: 40
                    color: index === results.currentIndex ? "#313244" : "transparent"
                    Text { text: modelData.name; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: results.currentIndex = index
                    }
                }
            }
        }
    }
}
```

**Penjelasan elemen kunci:**

| Elemen | Fungsi |
|---|---|
| `LazyLoader` | Menunda pembuatan launcher sampai `active: true` — launcher tidak ada di memori saat tidak dipakai |
| `WlrLayershell.layer: WlrLayer.Overlay` | Menempatkan jendela di atas **semua** jendela lain, termasuk bar |
| `WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive` | Memberi launcher **fokus keyboard eksklusif** — semua input keyboard masuk ke launcher, tidak ke jendela lain |
| `focus: true` | Memberi fokus pada `PanelWindow` sehingga `TextField` menerima input |
| `Keys.onEscapePressed` | Menutup launcher saat `Esc` ditekan |
| `Keys.onReturnPressed` | Mengaktifkan item yang dipilih saat `Enter` ditekan |

**Mengapa mode modal penting?** Tanpa `WlrKeyboardFocus.Exclusive`, input keyboard bisa bocor ke jendela di bawahnya. Ini adalah **bug keamanan**: pengguna mengira sedang mengetik di launcher, tetapi karakter masuk ke terminal di belakangnya.

### 3.5 OSD Volume dengan `LazyLoader`

```qml
// ui/Osd.qml
LazyLoader {
    id: osdLoader
    active: false

    PanelWindow {
        anchors { bottom: true; right: true }
        margins { bottom: 48; right: 24 }
        implicitWidth: 200
        implicitHeight: 60
        color: "transparent"
        exclusiveZone: 0

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: "#1e1e2e"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                Text {
                    text: AudioService.muted ? "🔇" : "🔊"
                    font.pixelSize: 24
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 8
                    radius: 4
                    color: "#45475a"
                    Rectangle {
                        width: parent.width * AudioService.volume
                        height: parent.height
                        radius: 4
                        color: "#89b4fa"
                    }
                }
            }
        }
    }
}

// Di shell.qml: hubungkan ke AudioService
Connections {
    target: AudioService
    function onVolumeChanged() {
        osdLoader.active = true;
        osdTimer.restart();
    }
}

Timer {
    id: osdTimer
    interval: 1500
    onTriggered: osdLoader.active = false
}
```

**Penjelasan:** `LazyLoader` membuat OSD hanya saat volume berubah. Setelah 1,5 detik tanpa perubahan, OSD dihancurkan — memori dan GPU kembali bebas. Ini adalah **pola umum untuk elemen UI sementara**.

### 3.6 `IpcHandler`: Semua Aksi via `qs ipc call`

```qml
// Di shell.qml atau service
import Quickshell.Io

IpcHandler {
    target: "shell"

    function toggleLauncher(): void {
        launcherLoader.active = !launcherLoader.active;
    }
    function lock(): void {
        LockService.lock();
    }
    function volumeUp(): void {
        AudioService.adjust(0.05);
    }
    function volumeDown(): void {
        AudioService.adjust(-0.05);
    }
    function mute(): void {
        AudioService.toggleMute();
    }
    function reload(): void {
        // qs ipc call shell reload
        Quickshell.reload();
    }
}
```

```bash
# Keybind di Hyprland/Sway:
bind = SUPER, Space, exec, qs ipc call shell toggleLauncher
bind = SUPER, L, exec, qs ipc call shell lock
bind = XF86AudioRaiseVolume, exec, qs ipc call shell volumeUp
bind = XF86AudioLowerVolume, exec, qs ipc call shell volumeDown
bind = XF86AudioMute, exec, qs ipc call shell mute
```

**Aturan penting:** Setiap fungsi **wajib** menganotasi tipe argumen dan tipe kembalian. Tanpa anotasi, fungsi tidak terdaftar dan `qs ipc call` akan mengembalikan “method not found.”

### 3.7 Unit systemd `--user` dengan Hardening

```ini
# systemd/my-shell.service
[Unit]
Description=My Quickshell desktop shell
After=graphical-session.target
PartOf=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/quickshell -c my-shell
Restart=on-failure
RestartSec=3
# Hardening:
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=%h/.cache/quickshell %h/.config/quickshell
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictSUIDSGID=true
RestrictRealtime=true
LockPersonality=true
MemoryDenyWriteExecute=true
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM

[Install]
WantedBy=graphical-session.target
```

**Penjelasan direktif hardening:**

| Direktif | Efek | Jika dihilangkan |
|---|---|---|
| `NoNewPrivileges=true` | Proses tidak bisa menaikkan privilege via setuid | Serangan privilege escalation lebih mudah |
| `PrivateTmp=true` | `/tmp` terisolasi per-service | Bug shell bisa membaca `/tmp` proses lain |
| `ProtectSystem=strict` | Seluruh filesystem read-only kecuali yang diizinkan | Shell bisa menulis ke `/usr` jika dieksploitasi |
| `ProtectHome=read-only` | `$HOME` read-only kecuali `ReadWritePaths` | Shell bisa memodifikasi berkas pribadi |
| `MemoryDenyWriteExecute=true` | Tidak ada halaman memori yang writable dan executable | Shellcode injection lebih sulit |
| `SystemCallFilter=@system-service` | Hanya syscall yang lazim untuk service | Syscall berbahaya (mis. `ptrace`, `mount`) diblokir |

**Cara mengukur hardening:** `systemd-analyze security my-shell.service` memberikan skor 0–10 (semakin rendah semakin baik). Dokumentasikan skor sebelum dan sesudah hardening di README.

### 3.8 Proses Pembantu dalam `bwrap`

```bash
#!/usr/bin/env bash
# helpers/bwrap-wrapper.sh
# Membungkus perintah yang memproses data tidak tepercaya.
# Contoh: ekstraksi ikon dari file .desktop yang mungkin berbahaya.

exec bwrap \
    --unshare-all \
    --share-net \
    --die-with-parent \
    --new-session \
    --ro-bind /usr /usr \
    --ro-bind /etc /etc \
    --proc /proc \
    --dev /dev \
    --tmpfs /tmp \
    --ro-bind "$HOME/.local/share/icons" "$HOME/.local/share/icons" \
    --setenv PATH /usr/bin:/bin \
    --chdir /tmp \
    -- "$@"
```

**Penjelasan flag `bwrap`:**

| Flag | Fungsi |
|---|---|
| `--unshare-all` | Memisahkan semua namespace: PID, network, mount, IPC, UTS, user |
| `--share-net` | Kembalikan namespace network (jika helper butuh jaringan; hapus jika tidak) |
| `--die-with-parent` | Helper mati jika shell mati — mencegah proses zombie |
| `--new-session` | Sesi baru; mencegah akses ke TTY shell |
| `--ro-bind` | *Mount read-only*: helper bisa membaca tetapi tidak menulis |
| `--tmpfs /tmp` | `/tmp` kosong dan sementara |
| `--` | Pemisah: semua argumen setelah ini adalah perintah yang dijalankan |

**Mengapa `--unshare-all`?** Helper yang memproses data tidak tepercaya (mis. nama file dari `.desktop` yang bisa berisi *path traversal*) tidak boleh bisa melihat proses lain, jaringan, atau filesystem host. `--unshare-all` memberi isolasi maksimal.

### 3.9 Lockscreen Fail-Safe dengan `WlSessionLock` + PAM

```qml
// services/LockService.qml
pragma Singleton
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import QtQuick

Singleton {
    id: root

    property bool locked: false
    property string errorMessage: ""

    function lock(): void {
        locked = true;
    }

    // WlSessionLock wajib: satu instance per sesi
    WlSessionLock {
        id: sessionLock
        locked: root.locked

        WlSessionLockSurface {
            LockScreen {
                onUnlockRequested: (password) => {
                    pam.start(password);
                }
            }
        }

        onLockedChanged: {
            if (!locked) {
                // Sesi terbuka — reset state
                root.locked = false;
                root.errorMessage = "";
            }
        }
    }

    PamContext {
        id: pam
        config: "login"
        user: Quickshell.env("USER")

        onPamMessage: {
            // PAM meminta input; kita sudah punya password dari UI
            respond(password);
        }
        onCompleted: (result) => {
            if (result === PamResult.Success) {
                root.locked = false;   // buka kunci
            } else {
                root.errorMessage = "Kata sandi salah";
                // JANGAN set locked = false — tetap terkunci
            }
        }
        onError: (err) => {
            // Fail-safe: error PAM = tetap terkunci
            root.errorMessage = "PAM error: " + err;
            // locked tetap true
        }
    }
}
```

**Prinsip fail-safe yang diterapkan:**

1. **Error PAM tidak membuka kunci.** `onError` hanya mencatat pesan; `locked` tetap `true`.
2. **Kata sandi salah tidak membuka kunci.** Hanya `PamResult.Success` yang mengubah `locked` menjadi `false`.
3. **Jika proses shell mati, sesi tetap terkunci.** `WlSessionLock` adalah fitur compositor; shell yang mati tidak membuka lock. Ini adalah **pertahanan di level Wayland**, bukan level QML.
4. **`kill -9` pada shell tidak membuka kunci.** Compositor menahan lock surface sampai proses yang memegang lock benar-benar melepasnya.

> **Catatan penting:** `WlSessionLock` membutuhkan dukungan compositor (Hyprland, Sway, Niri). Jika compositor tidak mendukung `ext-session-lock-v1`, lockscreen **tidak akan berfungsi** dan shell harus menolak berjalan atau menampilkan peringatan.

### 3.10 CI dengan Smoke Test

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
permissions:
  contents: read
jobs:
  lint:
    runs-on: ubuntu-latest
    container: archlinux:latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4.2.2
      - run: pacman -Syu --noconfirm qt6-declarative quickshell
      - name: Lint QML
        run: find . -name '*.qml' -print0 | xargs -0 /usr/lib/qt6/bin/qmllint
      - name: Smoke test (headless)
        run: |
          set +e
          timeout 10s quickshell -c my-shell --no-daemon
          code=$?
          if [ "$code" -eq 124 ]; then
            echo "Shell berjalan stabil selama 10 detik — LULUS"
            exit 0
          else
            echo "Shell crash dengan exit code $code — GAGAL"
            exit 1
          fi
```

**Penjelasan:**

- `set +e` menonaktifkan `errexit` agar `timeout` bisa mengembalikan exit code non-zero tanpa menghentikan skrip.
- `timeout 10s` mengirim `SIGTERM` setelah 10 detik. Jika shell masih berjalan, exit code adalah `124`.
- Jika shell crash, exit code adalah non-zero selain `124` (mis. `139` untuk segfault) — dan CI gagal.

---

## 4. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Capstone** | Proyek akhir yang mengintegrasikan seluruh pembelajaran |
| **Arah dependensi** | Aturan bahwa lapisan atas boleh bergantung pada lapisan bawah, tetapi tidak sebaliknya |
| **Singleton** | Satu instance global yang dapat diakses dari mana saja |
| **`Variants`** | Komponen Quickshell yang membuat instance per item dalam model (mis. per layar) |
| **`LazyLoader`** | Komponen yang menunda pembuatan isinya sampai `active` bernilai `true` |
| **`WlrLayer.Overlay`** | Lapisan Wayland di atas semua jendela lain |
| **`WlrKeyboardFocus.Exclusive`** | Mode keyboard di mana semua input masuk ke jendela ini, tidak bocor ke bawah |
| **`IpcHandler`** | Tipe Quickshell yang mengekspos fungsi QML ke `qs ipc call` |
| **`WlSessionLock`** | Protokol Wayland (`ext-session-lock-v1`) untuk lockscreen yang aman |
| **`PamContext`** | Tipe Quickshell untuk autentikasi PAM |
| **Fail-safe** | Prinsip bahwa kegagalan harus menuju keadaan aman |
| **`bwrap`** | *Bubblewrap*: alat sandbox dari proyek Flatpak |
| **`--unshare-all`** | Flag `bwrap` yang memisahkan semua namespace |
| **Hardening** | Proses memperketat konfigurasi sistem untuk mengurangi permukaan serangan |
| **`systemd-analyze security`** | Alat untuk mengukur tingkat hardening unit systemd |
| **Smoke test** | Uji cepat yang memverifikasi fungsionalitas dasar |
| **Threat model** | Dokumen yang menjelaskan apa yang dilindungi, dari siapa, dan di batas mana |

---

## 5. Struktur Pembelajaran Internal

Capstone ini sebaiknya dikerjakan dalam **urutan yang membuat setiap langkah dapat diuji secara independen**. Berikut urutan yang direkomendasikan:

1. **Minggu 1–2: Fondasi layanan** — buat singleton `WorkspaceService`, `AudioService`, `BatteryService`, `ClockService`; uji masing-masing dengan `Text` sederhana.
2. **Minggu 3: Bar multi-monitor** — integrasikan layanan ke `Bar.qml` dengan `Variants`; uji di VM dua monitor.
3. **Minggu 4: Launcher dan OSD** — launcher keyboard-driven dengan mode modal; OSD dengan `LazyLoader`; hubungkan ke `IpcHandler`.
4. **Minggu 5: Notification daemon dan tray** — `NotificationServer` dengan riwayat; `SystemTray`.
5. **Minggu 6: Lockscreen dan PAM** — `WlSessionLock` + `PamContext`; uji `kill -9` pada shell.
6. **Minggu 7: systemd dan sandbox** — unit `--user` dengan hardening; helper `bwrap`.
7. **Minggu 8: Deployment dan dokumentasi** — PKGBUILD/flake, CI, threat model, README.

**Mengapa urutan ini?** Setiap langkah **bergantung pada langkah sebelumnya** tetapi **dapat diuji secara independen**. Anda tidak perlu lockscreen berfungsi untuk menguji bar. Ini memungkinkan *iterasi cepat* dan *debugging terisolasi*.

---

## 6. Rekomendasi Visualisasi

### 6.1 Arsitektur Integrasi Capstone

```text
┌──────────────────────────────────────────────────────────────────┐
│                         shell.qml (entry)                        │
│                                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │   Bar    │  │ Launcher │  │   OSD    │  │  LockScreen      │  │
│  │(Variants)│  │(LazyLoad)│  │(LazyLoad)│  │ (WlSessionLock)  │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────────┬─────────┘  │
│       │             │             │                 │            │
│       ▼             ▼             ▼                 ▼            │
│  ┌───────────────────────────────────────────────────────────┐   │
│  │                   Services (singleton)                    │   │
│  │  WorkspaceService  AudioService  BatteryService           │   │
│  │  NotificationService  LauncherService  LockService        │   │
│  └──────┬─────────────────┬──────────────────┬───────────────┘   │
│         │                 │                  │                   │
│         ▼                 ▼                  ▼                   │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────┐          │
│  │ Hyprland   │  │  PipeWire    │  │  UPower / PAM    │          │
│  │ IPC        │  │  D-Bus       │  │  D-Bus           │          │
│  └────────────┘  └──────────────┘  └──────────────────┘          │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐   │
│  │  IpcHandler (target: "shell")                             │   │
│  │  ← qs ipc call shell toggleLauncher                       │   │
│  │  ← qs ipc call shell lock                                 │   │
│  │  ← qs ipc call shell volumeUp                             │   │
│  └───────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  systemd --user (my-shell.service)                                  │
│  ├─ Hardening: NoNewPrivileges, ProtectSystem=strict, ...           │
│  └─ Restart=on-failure                                              │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 Alur Lockscreen Fail-Safe

```text
Pengguna menekan SUPER+L
        │
        ▼
qs ipc call shell lock
        │
        ▼
LockService.lock() → locked = true
        │
        ▼
WlSessionLock.locked = true
        │
        ▼
Compositor menahan semua surface, menampilkan lock surface
        │
        ▼
Pengguna mengetik kata sandi
        │
        ▼
PamContext.start(password)
        │
        ├─── Success ──► locked = false ──► sesi terbuka
        │
        ├─── Failure ──► errorMessage = "salah" ──► TETAP TERKUNCI
        │
        └─── Error ────► errorMessage = "PAM error" ──► TETAP TERKUNCI
                                                    (fail-safe)
```

### 6.3 Alur Smoke Test di CI

```text
CI trigger (push/PR)
        │
        ▼
┌───────────────────┐
│ qmllint semua QML │─── gagal ──► CI merah
└─────────┬─────────┘
          │ lulus
          ▼
┌───────────────────────────────┐
│ timeout 10s quickshell -c ... │
└─────────┬─────────────────────┘
          │
          ├── exit 124 (timeout) ──► LULUS (shell stabil 10 detik)
          │
          └── exit ≠ 124 ──────────► GAGAL (crash saat startup)
```

---

## 7. Hubungan dengan Modul Lain

| Persyaratan Capstone | Modul Sumber | Bukti yang Diharapkan |
|---|---|---|
| Bar multi-monitor | 1.2, 2.1, 2.2 | Screenshot di VM dua monitor; `Variants` terlihat di kode |
| Launcher keyboard | 2.4, 2.5, 3.2 | Demo tanpa mouse; `WlrKeyboardFocus.Exclusive` terlihat |
| Notification daemon | 2.4 | Notifikasi muncul; riwayat dapat dibuka |
| OSD `LazyLoader` | 5.2 | `perf stat` menunjukkan memori lebih rendah saat OSD tidak aktif |
| Lockscreen + PAM | 4.2 | `kill -9` pada shell tidak membuka lock |
| `qs ipc call` | 5.1 [Tambahan] | `qs ipc show` menampilkan target `shell`; semua keybind berfungsi |
| systemd hardening | 4.1, 5.3 | `systemd-analyze security` menunjukkan skor < 5 |
| `bwrap` helper | 4.1 | Helper berjalan; `ps aux` menunjukkan namespace terpisah |
| PKGBUILD/flake + CI | 5.3 | Paket dibangun di chroot bersih; CI hijau |
| Threat model + README | 3.3, 4.1 | Dokumen satu halaman; orang lain dapat memasang |

---

## 8. Sumber Referensi

- [Quickshell: WlSessionLock](https://quickshell.org/docs/types/Quickshell.Wayland/WlSessionLock/) — referensi lockscreen.
- [Quickshell: PamContext](https://quickshell.org/docs/types/Quickshell.Services.Pam/PamContext/) — referensi PAM.
- [Quickshell: IpcHandler](https://quickshell.org/docs/types/Quickshell.Io/IpcHandler/) — referensi IPC.
- [Quickshell: Variants](https://quickshell.org/docs/types/Quickshell/Variants/) — referensi multi-monitor.
- [Arch Wiki: systemd/Sandboxing](https://wiki.archlinux.org/title/Systemd/Sandboxing) — direktif hardening.
- [Arch Wiki: Bubblewrap](https://wiki.archlinux.org/title/Bubblewrap) — panduan `bwrap`.
- [systemd-analyze security](https://www.freedesktop.org/software/systemd/man/systemd-analyze.html) — mengukur hardening.
- [Wayland `ext-session-lock-v1`](https://wayland.app/protocols/ext-session-lock-v1) — spesifikasi protokol lockscreen.

---

## 9. Tips dan Praktik Terbaik

1. **Bangun di VM dua monitor sejak awal.** Jangan menunda uji multi-monitor hingga akhir; bug `Variants` dan `screen` lebih mudah didiagnosis saat bar masih sederhana.
2. **Uji lockscreen dengan `kill -9`, bukan `SIGTERM`.** `SIGTERM` memberi kesempatan shell membersihkan diri; `kill -9` mensimulasikan crash keras. Jika lock terbuka, ada bug.
3. **Jalankan `systemd-analyze security` setelah setiap perubahan unit.** Skor adalah metrik objektif; jangan berhenti sampai < 5.
4. **Gunakan `qs ipc show` sebagai dokumentasi hidup.** Setiap fungsi yang diekspos ke CLI adalah bagian dari API shell Anda.
5. **Tulis threat model **sebelum** menulis lockscreen.** Threat model memandu keputusan: apa yang dilindungi (kata sandi, sesi), dari siapa (penyerang lokal, proses lain), di batas mana (PAM, compositor, systemd).
6. **Sertakan `README` yang dapat diikuti orang non-teknis.** Rubrik menilai “orang lain dapat memasang dan menambah satu fitur hanya dari README.”
7. **Simpan `flake.lock` dan checksum di repositori.** Ini adalah bagian dari reproducibility.
8. **Dokumentasikan skor hardening sebelum/sesudah** di README — ini adalah bukti yang diminta rubrik.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Bar dibuat tanpa `Variants` | Hanya muncul di satu monitor | Gunakan `Variants { model: Quickshell.screens }` |
| Launcher tanpa `WlrKeyboardFocus.Exclusive` | Input bocor ke jendela di belakang | Tambahkan `WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive` |
| Lockscreen membuka kunci saat PAM error | Sesi terbuka meski autentikasi gagal | Pastikan `onError` **tidak** mengubah `locked` |
| `IpcHandler` tanpa anotasi tipe | `method not found` di `qs ipc call` | Anotasi semua argumen dan return: `function f(x: int): void` |
| Unit systemd tanpa `Restart=on-failure` | Shell mati dan tidak kembali | Tambahkan `Restart=on-failure` dan `RestartSec=3` |
| `bwrap` tanpa `--die-with-parent` | Proses zombie setelah shell mati | Tambahkan `--die-with-parent` |
| CI tanpa smoke test | Crash saat startup tidak terdeteksi | Tambahkan `timeout` + cek exit code `124` |
| `sha256sums=('SKIP')` | Paket tidak dapat diaudit | Gunakan `updpkgsums` |
| Threat model ditulis setelah kode | Keputusan keamanan tidak konsisten | Tulis threat model **sebelum** lockscreen |
| README tidak dapat diikuti | Rubrik dokumentasi gagal | Uji README di VM bersih |

---

## 11. Rubrik yang Diperluas dan Cara Membuktikan Setiap Kriteria

| Kriteria | Bukti Lulus | Cara Membuktikan |
|---|---|---|
| **Fungsi** | Seluruh persyaratan berjalan di VM bermonitor ganda | Rekam video; jalankan di VM dengan dua monitor virtual (`-device virtio-gpu` × 2) |
| **Keyboard-driven** | Seluruh alur utama tanpa mouse | Demo: nyalakan VM, buka launcher, buka aplikasi, ubah volume, kunci, buka kunci — tanpa menyentuh mouse |
| **Keamanan** | `clearEnvironment` pada setiap `Process`; D-Bus disaring; lockscreen lolos `kill -9` | `grep -r clearEnvironment`; `busctl monitor` menunjukkan filter; `kill -9 $(pgrep quickshell)` lalu cek lock |
| **Arsitektur** | UI → services → sistem terjaga; tidak ada binding loop | `grep -r "import.*ui" services/` harus kosong; log Quickshell bebas “binding loop” |
| **Kualitas** | `qmllint` bersih; smoke test lulus di CI | Screenshot CI hijau; `qmllint` exit 0 |
| **Operasional** | Pulih otomatis saat crash; log bebas kredensial | `kill $(pgrep quickshell)` lalu `systemctl --user status` menunjukkan restart; `journalctl` tidak berisi kata sandi |
| **Dokumentasi** | Orang lain dapat memasang dan menambah satu fitur dari README | Minta orang lain (atau diri Anda di VM bersih) mengikuti README tanpa bantuan |

---

## 12. Rencana Kerja 4–6 Minggu (Diperluas)

| Minggu | Fokus | Deliverable | Kriteria Rubrik yang Dicakup |
|---|---|---|---|
| 1 | Layanan singleton + bar dasar | `AudioService`, `WorkspaceService`, `Bar.qml` satu monitor | Fungsi (awal), Arsitektur (awal) |
| 2 | Multi-monitor + widget lengkap | `Variants`, jam, baterai, tray | Fungsi (bar), Arsitektur |
| 3 | Launcher + OSD + `IpcHandler` | Launcher modal, OSD `LazyLoader`, target `shell` | Keyboard-driven, Operasional (IPC) |
| 4 | Notifikasi + lockscreen | `NotificationServer` + riwayat; `WlSessionLock` + PAM | Fungsi, Keamanan |
| 5 | systemd + `bwrap` + CI | Unit `--user` hardened; helper `bwrap`; CI hijau | Keamanan, Operasional, Kualitas |
| 6 | Deployment + dokumentasi | PKGBUILD/flake, threat model, README | Dokumentasi, Kualitas, Operasional |

---

> **Motivasi:** Capstone bukan tentang membangun shell yang “berfungsi.” Ia tentang membangun shell yang **dapat dipercaya** — oleh Anda, oleh orang lain, dan oleh mesin yang menjalankannya setiap hari. Setiap baris yang Anda tulis di sini adalah bukti bahwa Anda bukan hanya pengguna Quickshell, tetapi **insinyur yang membangun di atasnya**.

---

# Selamat!

Fase 5 dan Capstone telah selesai didalami. Berikutnya dalam kurikulum adalah **Pemetaan Kebutuhan ke Pendekatan (Pohon Keputusan)**, **Glosarium**, **Hasil Pembelajaran**, **Sumber Daya Komunitas**, **Catatan Akhir Keamanan Tinggi**, dan **Catatan Revisi**.

---

# Glosarium — Untuk Pembaca Non-Teknis (Diperluas dan Diperdalam)

> **Audit singkat sebelum materi:** Glosarium dalam kurikulum asli sudah mencakup 31 istilah dasar, tetapi **belum menjelaskan etimologi**, **konteks historis**, **hubungan antar-istilah**, **mengapa istilah itu penting dalam kurikulum**, dan **istilah-istilah yang muncul di Fase 1–5 tetapi tidak masuk glosarium** (mis. `QML_ELEMENT`, `bwrap`, `WlSessionLock`, `qmllint`, `heaptrack`, `perf`, `overdraw`, `IpcHandler`, `Variants`). Materi di bawah mengisi celah tersebut dan mengelompokkan istilah secara tematik agar mudah dipahami pembaca non-teknis. Setiap penambahan ditandai **[Tambahan]** .

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Glosarium adalah **jembatan antara pembaca non-IT dan materi teknis**. Ia bukan kamus lengkap, melainkan **kamus kerja**: istilah-istilah yang benar-benar muncul dalam kurikulum, dijelaskan dengan bahasa yang dapat dipahami seseorang yang belum pernah menyentuh terminal.

**Mengapa penting:** Kurikulum ini ditulis untuk pembaca dengan profil beragam — dari pengguna yang penasaran hingga insinyur keamanan. Tanpa glosarium, pembaca non-IT akan tersesat di modul pertama dan berhenti sebelum mencapai bagian yang menarik. Glosarium memastikan **tidak ada yang tertinggal**.

**Peran dalam kurikulum:** Glosarium adalah **rujukan silang**. Setiap kali Anda menemukan istilah yang tidak dikenal di modul mana pun, Anda dapat kembali ke sini. Ia juga berfungsi sebagai **peta konsep**: dengan membaca glosarium dari awal hingga akhir, Anda mendapatkan gambaran menyeluruh tentang apa yang akan dipelajari.

---

## 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “bahasa adalah infrastruktur.”** Sebelum Anda bisa membangun shell, Anda harus bisa **berbicara tentang shell**. Istilah seperti “compositor,” “layer-shell,” dan “D-Bus” bukan sekadar label; mereka adalah **konsep yang membentuk cara Anda berpikir**. Tanpa istilah yang tepat, Anda akan kesulitan mencari dokumentasi, bertanya di forum, atau memahami pesan error.

**Prinsip “definisi tanpa jargon.”** Setiap definisi dalam glosarium ini harus dapat dipahami **tanpa istilah teknis lain**. Jika suatu definisi membutuhkan istilah lain, istilah itu harus dijelaskan terlebih dahulu atau ditautkan. Ini adalah prinsip yang sama dengan **penulisan dokumentasi yang baik**: pembaca tidak boleh terjebak dalam lingkaran definisi.

**Prinsip “konteks historis memperjelas.”** Banyak istilah dalam kurikulum ini memiliki **sejarah**: Wayland adalah pengganti X11; D-Bus adalah pengganti CORBA; systemd adalah pengganti SysVinit. Mengetahui **mengapa** suatu teknologi ada membantu memahami **apa** yang dilakukannya. Glosarium ini menyertakan konteks historis singkat untuk istilah-istilah kunci.

**Model mental: glosarium sebagai “peta kota.”** Bayangkan kurikulum sebagai kota. Modul adalah jalan; glosarium adalah **peta dengan nama-nama tempat**. Tanpa peta, Anda bisa berjalan tetapi tidak tahu di mana Anda berada. Dengan peta, Anda bisa merencanakan rute dan memahami hubungan antar-tempat.

---

## 3. Struktur Glosarium

Glosarium ini dikelompokkan secara tematik agar mudah dicari:

1. **Konsep Dasar Sistem** — Wayland, compositor, layer-shell, X11, TTY, VM
2. **Qt dan QML** — Qt, QtQuick, QML, binding, signal, singleton, komponen, `QML_ELEMENT`, `Q_PROPERTY`, `Variants`, `LazyLoader`
3. **Proses dan IPC** — proses, IPC, D-Bus, daemon, `Process`, `SplitParser`, `IpcHandler`
4. **Keamanan** — sandbox, namespace, syscall, least privilege, threat model, PAM, fail-safe, `bwrap`, `WlSessionLock`, `clearEnvironment`
5. **Build dan Deployment** — PKGBUILD, AUR, supply chain, CI/CD, `qmllint`, `perf`, `heaptrack`, overdraw, unit systemd, Nix flake
6. **Alat dan Lingkungan** — LSP, linting, hot reload, environment, `SOURCE_DATE_EPOCH`
7. **[Tambahan]** Istilah yang sering muncul tetapi jarang dijelaskan

---

## 4. Glosarium Tematik

### 4.1 Konsep Dasar Sistem

#### Wayland

**Definisi sederhana:** Cara modern program menggambar di layar dan menerima input; pengganti X11.

**Etimologi:** Dinamai menurut **Wayland, Ohio**, kota kecil di Amerika Serikat. Nama ini dipilih sebagai lelucon: “Wayland” terdengar seperti “X11” (X → W, 11 → land). Proyek ini dimulai pada 2008 oleh Kristian Høgsberg, seorang pengembang X11 yang frustrasi dengan keterbatasan X11.

**Konteks historis:** X11 dirancang pada 1984 untuk workstation jaringan. Ia memiliki banyak fitur yang tidak lagi relevan (mis. rendering di server terpisah) dan model keamanan yang lemah (setiap aplikasi bisa membaca input aplikasi lain). Wayland dirancang ulang dari nol dengan prinsip: **kompositor adalah server tampilan**, aplikasi adalah klien yang menggambar ke buffer, dan **input dikirim langsung ke aplikasi yang fokus**.

**Mengapa penting dalam kurikulum:** Quickshell adalah **klien Wayland**. Ia menggambar panel, bar, dan lockscreen melalui protokol Wayland. Tanpa memahami Wayland, Anda tidak akan memahami mengapa `WlrLayershell` ada, mengapa `WlSessionLock` diperlukan, atau mengapa input keyboard bisa “bocor” ke jendela lain.

**Contoh konkret:** Saat Anda menjalankan `quickshell -c my-shell` di Hyprland, Quickshell membuat **permukaan Wayland** (surface) yang ditempelkan ke layar oleh compositor. Compositor menentukan di mana permukaan itu muncul, apakah ia menerima input, dan apakah ia di atas atau di bawah jendela lain.

**Hubungan dengan istilah lain:** Wayland → Compositor → Layer-shell → `WlrLayershell`; Wayland → `WlSessionLock` → Lockscreen.

---

#### Compositor

**Definisi sederhana:** Program yang menyusun semua jendela menjadi satu tampilan dan mengatur input (Hyprland, Sway, Niri).

**Etimologi:** Dari bahasa Latin **componere** (“menyusun bersama”). Dalam grafis komputer, compositing adalah proses menggabungkan beberapa lapisan gambar menjadi satu gambar akhir.

**Konteks historis:** Di X11, compositor adalah **opsi terpisah** (mis. `xcompmgr`, `picom`) yang berjalan di atas window manager. Di Wayland, compositor **adalah** window manager: ia menangani rendering, input, dan manajemen jendela sekaligus. Ini menyederhanakan arsitektur tetapi membuat compositor lebih kompleks.

**Mengapa penting dalam kurikulum:** Quickshell **bukan compositor**; ia adalah klien yang berjalan di atas compositor. Compositor menentukan apakah Quickshell bisa menempelkan bar ke tepi layar (layer-shell), apakah lockscreen berfungsi (`ext-session-lock-v1`), dan apakah IPC workspace tersedia (Hyprland/I3).

**Contoh konkret:** Di Hyprland, compositor adalah `Hyprland`. Di Sway, compositor adalah `sway`. Di Niri, compositor adalah `niri`. Quickshell berjalan di atas salah satunya dan berkomunikasi melalui IPC atau protokol Wayland.

**Hubungan dengan istilah lain:** Wayland → Compositor → Layer-shell; Compositor → IPC → `Quickshell.Hyprland`/`I3`.

---

#### Layer-shell

**Definisi sederhana:** Aturan agar panel/bar dapat menempel di tepi layar dan tidak tertimpa jendela biasa.

**Etimologi:** “Layer” (lapisan) + “shell” (cangkang). Protokol ini bernama `wlr-layer-shell-unstable-v1`, awalnya dikembangkan untuk compositor berbasis `wlroots` (Sway, Wayfire).

**Konteks historis:** Di X11, panel seperti `polybar` atau `i3bar` menggunakan **dock type** (`_NET_WM_WINDOW_TYPE_DOCK`) untuk menempel di tepi layar. Wayland tidak memiliki konsep ini secara bawaan; `wlr-layer-shell` mengisinya. Hyprland dan Sway mendukungnya; GNOME dan KDE memiliki mekanisme sendiri.

**Mengapa penting dalam kurikulum:** `PanelWindow` di Quickshell menggunakan layer-shell untuk menempelkan bar ke tepi layar. Properti seperti `WlrLayershell.layer`, `WlrLayershell.keyboardFocus`, dan `exclusionZone` adalah bagian dari protokol ini.

**Contoh konkret:** `WlrLayershell.layer: WlrLayer.Top` menempatkan bar di atas jendela biasa tetapi di bawah overlay (mis. launcher). `exclusionZone: 32` memberi tahu compositor bahwa area 32 piksel di tepi layar “dipakai” oleh bar, sehingga jendela lain tidak tumpang tindih.

**Hubungan dengan istilah lain:** Wayland → Compositor → Layer-shell → `PanelWindow` → `WlrLayershell`.

---

#### X11

**Definisi sederhana:** Sistem tampilan lama yang digantikan Wayland.

**Etimologi:** “X” adalah nama versi ke-10 dari sistem windowing yang dikembangkan di MIT pada 1984. Versi ke-11 (X11) dirilis pada 1987 dan menjadi standar selama 30+ tahun.

**Konteks historis:** X11 dirancang untuk **komputasi jaringan**: aplikasi bisa berjalan di server dan menampilkan di terminal jarak jauh. Model ini membawa masalah keamanan: setiap aplikasi X11 bisa membaca input semua aplikasi lain (keylogger bawaan). Wayland dirancang untuk mengatasi ini.

**Mengapa penting dalam kurikulum:** Quickshell **tidak berjalan di X11**; ia membutuhkan Wayland. Memahami perbedaan X11/Wayland membantu Anda memahami mengapa Quickshell membutuhkan compositor tertentu dan mengapa beberapa fitur (mis. lockscreen) bergantung pada protokol Wayland.

**Contoh konkret:** Jika Anda menjalankan `quickshell` di sesi X11, ia akan gagal atau berjalan dengan fitur terbatas. Quickshell membutuhkan Wayland untuk layer-shell dan `WlSessionLock`.

**Hubungan dengan istilah lain:** X11 → Wayland (pengganti); Wayland → Compositor → Layer-shell.

---

#### TTY

**Definisi sederhana:** Konsol teks murni; jalur darurat saat sesi grafis bermasalah.

**Etimologi:** “Teletypewriter” — perangkat keras lama yang mencetak teks di kertas. Di Linux, TTY adalah **terminal virtual** yang diakses dengan `Ctrl+Alt+F1` hingga `Ctrl+Alt+F6`.

**Konteks historis:** Sebelum GUI, semua interaksi dengan komputer melalui TTY. Saat ini, TTY masih tersedia sebagai **jalur pemulihan**: jika compositor crash atau lockscreen macet, Anda bisa beralih ke TTY dan memperbaiki sistem.

**Mengapa penting dalam kurikulum:** Jika shell Anda crash dan lockscreen tidak berfungsi, TTY adalah **satu-satunya jalan keluar**. Kurikulum menekankan prosedur pemulihan; TTY adalah bagian dari prosedur itu.

**Contoh konkret:** Saat lockscreen macet, tekan `Ctrl+Alt+F2` untuk masuk ke TTY, login, lalu `killall quickshell` atau `systemctl --user restart my-shell`.

**Hubungan dengan istilah lain:** TTY → Prosedur pemulihan → Fail-safe.

---

#### VM (Virtual Machine)

**Definisi sederhana:** Komputer tiruan di dalam komputer Anda, untuk bereksperimen dengan aman.

**Etimologi:** “Virtual” (tampak seperti nyata tetapi bukan) + “machine” (mesin). Konsepnya berasal dari 1960-an (IBM CP-67), tetapi menjadi populer di desktop pada 2000-an (VMware, VirtualBox, QEMU/KVM).

**Konteks historis:** VM memungkinkan **isolasi**: jika shell Anda crash di VM, host Anda tidak terpengaruh. Ini adalah alasan mengapa kurikulum menekankan pengujian di VM, terutama untuk lockscreen dan sandbox.

**Mengapa penting dalam kurikulum:** Capstone membutuhkan VM bermonitor ganda. Uji lockscreen dengan `kill -9` sebaiknya dilakukan di VM, bukan di mesin utama. VM adalah **laboratorium yang aman**.

**Contoh konkret:** `qemu-system-x86_64 -enable-kvm -m 4G -smp 4 -device virtio-gpu -device virtio-gpu ...` membuat VM dengan dua monitor virtual. Di dalamnya, Anda menguji bar multi-monitor.

**Hubungan dengan istilah lain:** VM → Uji lockscreen → `kill -9` → Fail-safe; VM → Uji multi-monitor → `Variants`.

---

### 4.2 Qt dan QML

#### Qt

**Definisi sederhana:** Perangkat lunak dasar yang menggambar antarmuka Quickshell.

**Etimologi:** Dibuat oleh **Haavard Nord** dan **Eirik Chambe-Eng** pada 1991. Nama “Qt” dipilih karena huruf Q terlihat bagus di font yang mereka gunakan; “t” adalah singkatan dari “toolkit.” Tidak ada hubungan dengan “cute” (meskipun sering disebut demikian).

**Konteks historis:** Qt adalah **framework lintas platform** untuk C++: satu kode, jalan di Linux, Windows, macOS, Android. Quickshell dibangun di atas Qt 6. Memahami Qt berarti memahami **model objek**, **signal/slot**, dan **meta-object system**.

**Mengapa penting dalam kurikulum:** Quickshell adalah **aplikasi Qt**. Setiap tipe QML yang Anda gunakan adalah kelas Qt. Plugin C++ yang Anda tulis adalah kelas Qt. Tanpa memahami Qt, Anda tidak akan memahami mengapa `Q_OBJECT` diperlukan atau mengapa `Q_PROPERTY` bisa diikat dari QML.

**Contoh konkret:** `QObject` adalah basis semua objek Qt. `QString` adalah string Unicode Qt. `Q_PROPERTY` adalah makro yang mendefinisikan properti yang bisa dibaca QML.

**Hubungan dengan istilah lain:** Qt → QtQuick → QML; Qt → `QObject` → `Q_PROPERTY` → Plugin C++.

---

#### QtQuick

**Definisi sederhana:** Modul Qt untuk membuat antarmuka deklaratif dengan QML.

**Etimologi:** “Quick” karena dirancang untuk **antarmuka yang responsif dan animasi yang halus**. Nama awalnya adalah “Qt Declarative” (2008), kemudian diubah menjadi QtQuick.

**Konteks historis:** QtQuick diperkenalkan pada 2010 untuk bersaing dengan Adobe Flash dan Microsoft WPF. Ia menggunakan **scene graph** yang dipercepat GPU, bukan widget tradisional. Quickshell menggunakan QtQuick untuk merender panel dan bar.

**Mengapa penting dalam kurikulum:** Ketika Anda menulis `import QtQuick`, Anda mengimpor tipe dasar seperti `Item`, `Rectangle`, `Text`, `MouseArea`. Memahami QtQuick berarti memahami **scene graph**, **binding**, dan **animasi**.

**Contoh konkret:** `Rectangle { width: 100; height: 100; color: "red" }` adalah tipe QtQuick. `Behavior on color { ColorAnimation { } }` adalah animasi QtQuick.

**Hubungan dengan istilah lain:** Qt → QtQuick → QML → Binding → Scene graph.

---

#### QML

**Definisi sederhana:** Bahasa untuk mendeskripsikan tampilan dan perilakunya secara deklaratif.

**Etimologi:** “Qt Meta-object Language” atau “Qt Modeling Language” — keduanya digunakan. Ia adalah **bahasa deklaratif** seperti CSS atau JSON, tetapi dengan logika JavaScript dan tipe Qt.

**Konteks historis:** QML dirancang untuk **desainer dan pengembang** yang ingin mendeskripsikan UI tanpa menulis C++. Ia menggunakan **binding** untuk menghubungkan properti secara otomatis. Quickshell **sepenuhnya** ditulis dalam QML (dengan beberapa plugin C++).

**Mengapa penting dalam kurikulum:** QML adalah **bahasa utama** kurikulum ini. Setiap modul dari Fase 0 hingga Fase 5 menggunakan QML. Memahami QML berarti memahami **binding**, **signal**, **komponen**, dan **state**.

**Contoh konkret:**
```qml
Rectangle {
    width: 100
    height: width * 2    // binding: height selalu 2× width
    color: "blue"
}
```

**Hubungan dengan istilah lain:** Qt → QtQuick → QML → Binding → Signal → Komponen.

---

#### Binding

**Definisi sederhana:** Hubungan “nilai A selalu mengikuti nilai B” yang dihitung ulang otomatis.

**Etimologi:** Dari bahasa Inggris “bind” (mengikat). Dalam QML, binding adalah **ekspresi** yang dievaluasi ulang ketika dependensinya berubah.

**Konteks historis:** Binding adalah fitur inti QML yang membedakannya dari JavaScript biasa. Di JavaScript, Anda harus **secara manual** memperbarui nilai ketika dependensi berubah. Di QML, binding melakukannya **secara otomatis**.

**Mengapa penting dalam kurikulum:** Binding adalah **kekuatan sekaligus jebakan** QML. Binding yang salah menyebabkan **binding loop** (CPU 100%) atau **pembaruan berlebihan** (boros). Modul 5.2 mengajarkan cara menghindari binding mahal.

**Contoh konkret:**
```qml
Text {
    text: AudioService.volume * 100 + "%"   // binding: diperbarui saat volume berubah
}
```

**Hubungan dengan istilah lain:** QML → Binding → Signal (memicu evaluasi ulang) → Performa (binding mahal).

---

#### Signal

**Definisi sederhana:** Pemberitahuan bahwa sesuatu terjadi (klik, data berubah).

**Etimologi:** Dari bahasa Latin **signum** (“tanda”). Dalam Qt, signal adalah **event** yang dikirim objek ketika state-nya berubah.

**Konteks historis:** Signal/slot adalah **pola observer** yang dibangun ke dalam Qt pada 1992. Ini memungkinkan **decoupling**: objek yang mengirim signal tidak perlu tahu siapa yang menerimanya.

**Mengapa penting dalam kurikulum:** Setiap `Q_PROPERTY` non-`CONSTANT` membutuhkan `NOTIFY signal`. Setiap perubahan state di layanan (mis. volume berubah) mengirim signal yang memicu pembaruan UI.

**Contoh konkret:**
```qml
// Di C++:
signals:
    void volumeChanged();

// Di QML:
Connections {
    target: AudioService
    function onVolumeChanged() { /* ... */ }
}
```

**Hubungan dengan istilah lain:** Qt → Signal → Binding (dipicu oleh signal) → `Connections`.

---

#### Singleton

**Definisi sederhana:** Satu objek tunggal yang bisa dipakai dari mana saja.

**Etimologi:** Dari bahasa Latin **singulus** (“satu”). Dalam pemrograman, singleton adalah pola desain yang memastikan **hanya satu instance** dari suatu kelas.

**Konteks historis:** Pola singleton populer di Java dan C++ pada 1990-an. Di QML, singleton adalah **tipe khusus** yang dideklarasikan dengan `pragma Singleton`.

**Mengapa penting dalam kurikulum:** Layanan seperti `AudioService`, `BatteryService`, dan `WorkspaceService` adalah singleton. Mereka memastikan **satu sumber kebenaran** untuk seluruh shell.

**Contoh konkret:**
```qml
pragma Singleton
import Quickshell
Singleton { /* ... */ }
```

**Hubungan dengan istilah lain:** QML → Singleton → Layanan → Arsitektur (UI → services → sistem).

---

#### Komponen

**Definisi sederhana:** Potongan antarmuka yang bisa dipakai ulang, disimpan dalam berkas sendiri.

**Etimologi:** Dari bahasa Latin **componere** (“menyusun bersama”). Dalam QML, komponen adalah **tipe yang dapat digunakan ulang** yang didefinisikan dalam berkas `.qml`.

**Konteks historis:** Komponen adalah fondasi **reusability** di QML. Sebuah berkas `Bar.qml` adalah komponen yang bisa diinstansiasi sebagai `Bar { }`.

**Mengapa penting dalam kurikulum:** Seluruh kurikulum membangun komponen: `Bar`, `Launcher`, `Osd`, `LockScreen`. Memahami komponen berarti memahami **cara memecah UI menjadi bagian-bagian yang dapat diuji**.

**Contoh konkret:**
```qml
// Bar.qml
import QtQuick
Rectangle { /* ... */ }

// shell.qml
import QtQuick
Bar { }    // instansiasi komponen
```

**Hubungan dengan istilah lain:** QML → Komponen → Arsitektur (pemisahan UI/services) → Capstone.

---

#### [Tambahan] `QML_ELEMENT`

**Definisi sederhana:** Makro Qt yang mendaftarkan kelas C++ sebagai tipe QML.

**Etimologi:** “QML” + “ELEMENT” (elemen). Makro ini diperkenalkan di Qt 5.15 sebagai cara **deklaratif** untuk mendaftarkan tipe, menggantikan `qmlRegisterType()` manual.

**Mengapa penting dalam kurikulum:** Modul 5.1 menggunakan `QML_ELEMENT` untuk mendaftarkan `KernelInfo` sebagai tipe QML. Tanpa makro ini, tipe tidak akan muncul di QML.

**Contoh konkret:**
```cpp
class KernelInfo : public QObject {
    Q_OBJECT
    QML_ELEMENT    // mendaftarkan sebagai tipe "KernelInfo"
    // ...
};
```

**Hubungan dengan istilah lain:** Qt → `Q_OBJECT` → `QML_ELEMENT` → Plugin C++.

---

#### [Tambahan] `Q_PROPERTY`

**Definisi sederhana:** Makro Qt yang menjadikan anggota kelas properti yang dapat dibaca/diikat dari QML.

**Etimologi:** “Q” (Qt) + “PROPERTY” (properti). Diperkenalkan di Qt 4 (2005) sebagai bagian dari **meta-object system**.

**Mengapa penting dalam kurikulum:** Setiap nilai yang ingin Anda baca dari QML harus dideklarasikan sebagai `Q_PROPERTY`. Tanpa itu, QML tidak bisa mengaksesnya.

**Contoh konkret:**
```cpp
Q_PROPERTY(QString release READ release CONSTANT)
```

**Hubungan dengan istilah lain:** Qt → `Q_PROPERTY` → Binding → Plugin C++.

---

#### [Tambahan] `Variants`

**Definisi sederhana:** Komponen Quickshell yang membuat instance per item dalam model (mis. per layar).

**Etimologi:** Dari bahasa Inggris “variant” (varian). Di Quickshell, `Variants` adalah tipe yang **mengulang** isinya untuk setiap item dalam model.

**Mengapa penting dalam kurikulum:** Bar multi-monitor menggunakan `Variants { model: Quickshell.screens }` untuk membuat satu bar per layar. Tanpa `Variants`, Anda harus membuat bar secara manual untuk setiap layar.

**Contoh konkret:**
```qml
Variants {
    model: Quickshell.screens
    PanelWindow { required property var modelData; screen: modelData }
}
```

**Hubungan dengan istilah lain:** Quickshell → `Variants` → Multi-monitor → Capstone.

---

#### [Tambahan] `LazyLoader`

**Definisi sederhana:** Komponen yang menunda pembuatan isinya sampai `active` bernilai `true`.

**Etimologi:** “Lazy” (malas) + “Loader” (pemuat). Istilah “lazy” dalam pemrograman berarti **menunda pekerjaan sampai benar-benar dibutuhkan**.

**Mengapa penting dalam kurikulum:** OSD volume dan launcher menggunakan `LazyLoader` untuk menghemat memori dan GPU. Ini adalah teknik optimasi utama di Modul 5.2.

**Contoh konkret:**
```qml
LazyLoader {
    active: launcherOpen
    PanelWindow { /* launcher */ }
}
```

**Hubungan dengan istilah lain:** Quickshell → `LazyLoader` → Optimasi → Performa.

---

### 4.3 Proses dan IPC

#### Proses

**Definisi sederhana:** Program yang sedang berjalan.

**Etimologi:** Dari bahasa Latin **processus** (“kemajuan, berjalan maju”). Dalam sistem operasi, proses adalah **instance program** yang memiliki memori, file descriptor, dan thread.

**Konteks historis:** Konsep proses diperkenalkan di sistem Multics (1960-an) dan UNIX (1970-an). Setiap proses memiliki **PID** (Process ID) yang unik.

**Mengapa penting dalam kurikulum:** Quickshell adalah **satu proses** yang menjalankan banyak komponen. `Process` di Quickshell menjalankan **proses anak** (mis. `curl`, `nmcli`). Memahami proses berarti memahami **isolasi**, **environment**, dan **sandbox**.

**Contoh konkret:** `pgrep -x quickshell` menampilkan PID Quickshell. `ps aux | grep quickshell` menampilkan detail proses.

**Hubungan dengan istilah lain:** Proses → `Process` → IPC → D-Bus; Proses → Sandbox → Namespace.

---

#### IPC (Inter-Process Communication)

**Definisi sederhana:** Cara dua program saling berkirim pesan.

**Etimologi:** “Inter” (antara) + “Process” (proses) + “Communication” (komunikasi). Istilah ini diperkenalkan di sistem UNIX pada 1970-an.

**Konteks historis:** IPC mencakup **pipe**, **socket**, **shared memory**, **message queue**, dan **D-Bus**. Setiap mekanisme memiliki trade-off: pipe sederhana tetapi satu arah; socket fleksibel tetapi kompleks; D-Bus terstruktur tetapi berat.

**Mengapa penting dalam kurikulum:** Quickshell berkomunikasi dengan compositor (Hyprland/I3) melalui IPC, dengan PipeWire melalui D-Bus, dan dengan pengguna melalui `qs ipc call`. Memahami IPC berarti memahami **bagaimana shell terhubung ke dunia luar**.

**Contoh konkret:** `qs ipc call shell toggleLauncher` mengirim pesan IPC ke instance Quickshell yang berjalan. `hyprctl dispatch workspace 2` mengirim IPC ke Hyprland.

**Hubungan dengan istilah lain:** Proses → IPC → D-Bus → `IpcHandler`; Compositor → IPC → `Quickshell.Hyprland`.

---

#### D-Bus

**Definisi sederhana:** Sistem pesan antar program di Linux (bus sesi untuk aplikasi Anda, bus sistem untuk layanan sistem).

**Etimologi:** “D” dari **Desktop** (awalnya “D-BUS” adalah singkatan dari “Desktop Bus”). Dibuat pada 2002 oleh Red Hat untuk menggantikan CORBA dan DCOP yang lebih berat.

**Konteks historis:** D-Bus adalah **standar de facto** untuk IPC di Linux desktop. PipeWire, UPower, NetworkManager, MPRIS, dan Notification daemon semuanya berbicara D-Bus. Quickshell membungkus D-Bus dalam tipe QML seperti `Pipewire`, `UPower`, `Mpris`.

**Mengapa penting dalam kurikulum:** Sebagian besar layanan sistem yang diintegrasikan Quickshell menggunakan D-Bus. Memahami D-Bus berarti memahami **bus**, **nama well-known**, **objek path**, dan **interface**.

**Contoh konkret:** `busctl --user list` menampilkan semua nama D-Bus di bus sesi. `dbus-monitor --session` memantau pesan D-Bus secara real-time.

**Hubungan dengan istilah lain:** IPC → D-Bus → `Pipewire`/`UPower`/`Mpris` → Layanan.

---

#### Daemon

**Definisi sederhana:** Program latar belakang yang melayani program lain (mis. penerima notifikasi).

**Etimologi:** Dari bahasa Yunani **daimon** (“roh penjaga”). Di UNIX, daemon adalah proses yang berjalan di latar belakang, tidak terikat ke terminal.

**Konteks historis:** Istilah ini digunakan sejak 1963 (Project MAC di MIT). Daemon biasanya berjalan sebagai service systemd dan mendengarkan permintaan dari klien.

**Mengapa penting dalam kurikulum:** Notification daemon, PipeWire daemon, dan UPower daemon adalah **layanan latar belakang** yang Quickshell gunakan. Memahami daemon berarti memahami **siklus hidup layanan** dan **cara berkomunikasi dengannya**.

**Contoh konkret:** `systemctl --user status pipewire` menampilkan status daemon PipeWire. `pkill -HUP notification-daemon` mengirim sinyal ke daemon notifikasi.

**Hubungan dengan istilah lain:** Proses → Daemon → D-Bus → Layanan; Daemon → Unit systemd.

---

#### [Tambahan] `Process`

**Definisi sederhana:** Tipe Quickshell untuk menjalankan program eksternal.

**Etimologi:** Nama tipe di Quickshell (`Quickshell.Io.Process`) yang membungkus `QProcess` Qt.

**Mengapa penting dalam kurikulum:** `Process` adalah **cabang [3]** dalam pohon keputusan. Hampir semua integrasi CLI (nmcli, brightnessctl, grim) menggunakan `Process`.

**Contoh konkret:**
```qml
Process {
    command: ["nmcli", "-t", "-f", "TYPE,NAME", "connection", "show", "--active"]
    clearEnvironment: true
    stdout: SplitParser { onRead: (line) => { /* ... */ } }
}
```

**Hubungan dengan istilah lain:** Proses → `Process` → `SplitParser` → Pohon keputusan.

---

#### [Tambahan] `SplitParser`

**Definisi sederhana:** Parser yang memecah output per baris.

**Etimologi:** “Split” (memecah) + “Parser” (pengurai). Tipe Quickshell (`Quickshell.Io.SplitParser`) yang memanggil `onRead` untuk setiap baris output.

**Mengapa penting dalam kurikulum:** Hampir semua output CLI berbasis baris. `SplitParser` menyederhanakan parsing dan menghindari buffer overflow.

**Contoh konkret:**
```qml
stdout: SplitParser {
    onRead: (line) => { console.log("Baris:", line) }
}
```

**Hubungan dengan istilah lain:** `Process` → `SplitParser` → Parsing output CLI.

---

#### [Tambahan] `IpcHandler`

**Definisi sederhana:** Tipe Quickshell yang mengekspos fungsi QML ke `qs ipc call`.

**Etimologi:** “IPC” + “Handler” (penangan). Diperkenalkan di Quickshell untuk memungkinkan **kontrol eksternal** atas shell.

**Mengapa penting dalam kurikulum:** Capstone mensyaratkan “semua aksi utama dapat dipanggil lewat `qs ipc call`.” `IpcHandler` adalah mekanisme untuk itu.

**Contoh konkret:**
```qml
IpcHandler {
    target: "shell"
    function toggleLauncher(): void { /* ... */ }
}
```

```bash
qs ipc call shell toggleLauncher
```

**Hubungan dengan istilah lain:** IPC → `IpcHandler` → Keybind → Capstone.

---

### 4.4 Keamanan

#### Sandbox

**Definisi sederhana:** Ruang terisolasi tempat program hanya mendapat akses terbatas.

**Etimologi:** Dari bahasa Inggris “sandbox” (kotak pasir) — area bermain anak yang dibatasi agar tidak keluar. Dalam keamanan komputer, sandbox adalah **lingkungan terbatas** yang mencegah program merusak sistem.

**Konteks historis:** Sandbox modern berasal dari **chroot** (1979), **FreeBSD Jails** (2000), **Linux Namespaces** (2002+), dan **seccomp** (2005). `bwrap` (Bubblewrap) adalah alat sandbox dari proyek Flatpak (2016).

**Mengapa penting dalam kurikulum:** Modul 4.1 mengajarkan sandbox untuk proses pembantu. Plugin C++ **tidak bisa** disandbox karena berjalan di proses yang sama; ini memperkuat alasan untuk audit ketat.

**Contoh konkret:** `bwrap --unshare-all --ro-bind /usr /usr --tmpfs /tmp -- curl ...` menjalankan `curl` di sandbox dengan filesystem read-only.

**Hubungan dengan istilah lain:** Sandbox → Namespace → `bwrap` → Keamanan; Sandbox → Least privilege.

---

#### Namespace

**Definisi sederhana:** Fitur kernel yang membuat program “melihat” sistem yang terpisah.

**Etimologi:** Dari bahasa Latin **nomen** (“nama”) + **spatium** (“ruang”). Dalam Linux, namespace adalah **abstraksi** yang mengisolasi resource: PID, network, mount, IPC, UTS, user, cgroup.

**Konteks historis:** Namespace Linux diperkenalkan secara bertahap: mount (2002), UTS/IPC (2006), PID/network (2008), user (2013), cgroup (2016). Container (Docker, Podman) dibangun di atas namespace.

**Mengapa penting dalam kurikulum:** `bwrap --unshare-all` menggunakan namespace untuk mengisolasi helper. Memahami namespace berarti memahami **bagaimana sandbox bekerja**.

**Contoh konkret:** `unshare --pid --fork --mount-proc bash` membuat shell di namespace PID baru; `ps aux` hanya menampilkan proses di namespace itu.

**Hubungan dengan istilah lain:** Sandbox → Namespace → `bwrap` → Isolasi.

---

#### Syscall

**Definisi sederhana:** Permintaan program kepada kernel.

**Etimologi:** “System” + “call” (panggilan). Syscall adalah **antarmuka** antara userspace dan kernel.

**Konteks historis:** Syscall adalah fondasi semua operasi sistem: membuka file (`open`), membaca (`read`), menulis (`write`), membuat proses (`fork`), mengirim sinyal (`kill`). Linux memiliki ~300+ syscall.

**Mengapa penting dalam kurikulum:** Plugin C++ bisa memanggil syscall langsung (mis. `uname()`). Memahami syscall berarti memahami **batas antara program dan kernel** — dan mengapa plugin C++ berbahaya.

**Contoh konkret:** `strace -e trace=open,read quickshell` menampilkan syscall yang dipanggil Quickshell.

**Hubungan dengan istilah lain:** Syscall → Plugin C++ → Permukaan serangan; Syscall → `seccomp` → Hardening.

---

#### Least privilege

**Definisi sederhana:** Prinsip memberi hak akses sekecil mungkin.

**Etimologi:** Dari bahasa Inggris “least” (paling sedikit) + “privilege” (hak istimewa). Prinsip ini dirumuskan oleh **Jerome Saltzer** pada 1974 dalam makalah “Protection and the Control of Information Sharing in Multics.”

**Konteks historis:** Least privilege adalah **prinsip fundamental keamanan**: setiap komponen harus beroperasi dengan hak minimum yang diperlukan untuk menyelesaikan tugasnya. Ini berlaku untuk proses, pengguna, dan layanan.

**Mengapa penting dalam kurikulum:** Unit systemd dengan `NoNewPrivileges`, `ProtectSystem=strict`, dan `SystemCallFilter` menerapkan least privilege. Helper `bwrap` menerapkan least privilege pada filesystem.

**Contoh konkret:** `ProtectHome=read-only` memberi shell akses baca ke `$HOME`, bukan tulis. `SystemCallFilter=@system-service` membatasi syscall ke yang lazim untuk service.

**Hubungan dengan istilah lain:** Least privilege → Hardening → Unit systemd; Least privilege → Sandbox → `bwrap`.

---

#### Threat model

**Definisi sederhana:** Catatan tertulis tentang apa yang dilindungi, dari siapa, dan di batas mana.

**Etimologi:** “Threat” (ancaman) + “model” (model). Threat modeling adalah **proses sistematis** untuk mengidentifikasi dan memprioritaskan risiko keamanan.

**Konteks historis:** Threat modeling berasal dari **STRIDE** (Microsoft, 1999) dan **DREAD** (Microsoft, 2002). Kerangka lain: **PASTA**, **OCTAVE**, **LINDDUN**. Intinya: **pahami ancaman sebelum menulis kode**.

**Mengapa penting dalam kurikulum:** Capstone mensyaratkan dokumen threat model satu halaman. Threat model memandu keputusan: apa yang dilindungi (kata sandi, sesi), dari siapa (penyerang lokal, proses lain), di batas mana (PAM, compositor, systemd).

**Contoh konkret:**
```markdown
# Threat Model: my-shell

## Aset
- Kata sandi pengguna
- Sesi desktop
- Kredensial jaringan

## Ancaman
- Penyerang lokal dengan akses ke proses shell
- Proses lain yang mencoba membaca input keyboard
- Data tak tepercaya dari .desktop file

## Mitigasi
- Lockscreen fail-safe (WlSessionLock)
- Keyboard focus eksklusif (WlrKeyboardFocus.Exclusive)
- Sandbox helper (bwrap)
- clearEnvironment pada setiap Process
```

**Hubungan dengan istilah lain:** Threat model → Sandbox → Least privilege → Fail-safe → Capstone.

---

#### PAM (Pluggable Authentication Modules)

**Definisi sederhana:** Sistem Linux untuk memeriksa kata sandi dan identitas.

**Etimologi:** “Pluggable” (dapat dipasang) + “Authentication” (autentikasi) + “Modules” (modul). PAM diperkenalkan oleh Sun Microsystems pada 1995.

**Konteks historis:** Sebelum PAM, setiap program (login, su, sudo, sshd) memiliki kode autentikasi sendiri. PAM memisahkan **mekanisme** autentikasi dari **kebijakan**, sehingga administrator bisa mengubah kebijakan (mis. menambah 2FA) tanpa mengubah program.

**Mengapa penting dalam kurikulum:** Lockscreen Quickshell menggunakan PAM untuk memverifikasi kata sandi. `PamContext` adalah tipe QML yang membungkus PAM.

**Contoh konkret:**
```qml
PamContext {
    config: "login"
    user: Quickshell.env("USER")
    onCompleted: (result) => {
        if (result === PamResult.Success) { /* buka kunci */ }
    }
}
```

**Hubungan dengan istilah lain:** PAM → `PamContext` → Lockscreen → Fail-safe.

---

#### Fail-safe

**Definisi sederhana:** Bila komponen gagal, sistem berakhir pada keadaan aman.

**Etimologi:** “Fail” (gagal) + “safe” (aman). Istilah ini berasal dari **rekayasa kendali** (mis. sistem nuklir, penerbangan): jika komponen gagal, sistem harus menuju keadaan yang tidak berbahaya.

**Konteks historis:** Fail-safe adalah kebalikan dari **fail-open** (gagal terbuka). Contoh fail-safe: pintu darurat yang terbuka saat listrik mati. Contoh fail-open: kunci yang terbuka saat baterai habis.

**Mengapa penting dalam kurikulum:** Lockscreen harus **fail-safe**: jika PAM error, jika proses shell mati, jika sinyal terputus — sesi tetap terkunci. Ini adalah prinsip yang membedakan lockscreen aman dari lockscreen palsu.

**Contoh konkret:** `onError` pada `PamContext` **tidak** mengubah `locked` menjadi `false`. `WlSessionLock` menahan lock surface sampai proses yang memegang lock benar-benar melepasnya.

**Hubungan dengan istilah lain:** Fail-safe → Lockscreen → PAM → `WlSessionLock` → Capstone.

---

#### [Tambahan] `bwrap` (Bubblewrap)

**Definisi sederhana:** Alat sandbox dari proyek Flatpak.

**Etimologi:** “Bubble” (gelembung) + “wrap” (membungkus). Dibuat oleh **Alexander Larsson** (Red Hat) pada 2016 untuk Flatpak.

**Mengapa penting dalam kurikulum:** `bwrap` adalah **cabang [3]** dalam pohon keputusan untuk menjalankan proses pembantu yang memproses data tak tepercaya. Flag `--unshare-all` memberikan isolasi maksimal.

**Contoh konkret:** Lihat 3.8 di Capstone.

**Hubungan dengan istilah lain:** Sandbox → Namespace → `bwrap` → Keamanan.

---

#### [Tambahan] `WlSessionLock`

**Definisi sederhana:** Protokol Wayland untuk lockscreen yang aman.

**Etimologi:** “Wl” (Wayland) + “Session Lock” (kunci sesi). Protokol `ext-session-lock-v1` dirancang agar **compositor** menahan lock, bukan aplikasi.

**Mengapa penting dalam kurikulum:** Lockscreen Quickshell menggunakan `WlSessionLock`. Protokol ini memastikan bahwa **jika shell mati, sesi tetap terkunci** — fail-safe di level Wayland.

**Contoh konkret:** Lihat 3.9 di Capstone.

**Hubungan dengan istilah lain:** Wayland → `WlSessionLock` → Lockscreen → Fail-safe.

---

#### [Tambahan] `clearEnvironment`

**Definisi sederhana:** Properti `Process` yang mencegah pewarisan environment shell.

**Etimologi:** “Clear” (bersihkan) + “Environment” (lingkungan). Di Quickshell, `clearEnvironment: true` menghapus semua variabel environment sebelum menjalankan proses anak.

**Mengapa penting dalam kurikulum:** Variabel environment bisa berisi kredensial (mis. `SSH_AUTH_SOCK`, `GPG_AGENT_INFO`). `clearEnvironment: true` mencegah kebocoran ke proses anak.

**Contoh konkret:**
```qml
Process {
    command: ["curl", "..."]
    clearEnvironment: true
}
```

**Hubungan dengan istilah lain:** Environment → `clearEnvironment` → `Process` → Keamanan.

---

### 4.5 Build dan Deployment

#### PKGBUILD

**Definisi sederhana:** Resep pembuatan paket di Arch Linux.

**Etimologi:** “PKG” (package) + “BUILD” (membangun). PKGBUILD adalah **skrip bash** yang mendefinisikan cara membangun paket: sumber, checksum, dependensi, dan fungsi `package()`.

**Konteks historis:** Arch Linux menggunakan **pacman** dan **PKGBUILD** sejak 2002. Berbeda dari `.deb` atau `.rpm` yang berbasis biner, PKGBUILD berbasis **sumber**: pengguna membangun paket dari sumber dengan `makepkg`.

**Mengapa penting dalam kurikulum:** Modul 5.3 mengajarkan PKGBUILD yang aman: checksum, tanpa `SKIP`, `--no-preserve=ownership`. Ini adalah **segel auditabilitas**.

**Contoh konkret:** Lihat 3.1 di Modul 5.3.

**Hubungan dengan istilah lain:** PKGBUILD → AUR → Supply chain → Deployment.

---

#### AUR (Arch User Repository)

**Definisi sederhana:** Gudang resep paket buatan komunitas Arch; harus dibaca sebelum dipakai.

**Etimologi:** “Arch” + “User” + “Repository” (gudang). AUR diluncurkan pada 2005 sebagai pengganti **Trusted User Repository** (TUR).

**Konteks historis:** AUR berisi **PKGBUILD** yang dibuat komunitas, bukan biner. Pengguna harus **membaca PKGBUILD** sebelum membangun — ini adalah prinsip **trust but verify**.

**Mengapa penting dalam kurikulum:** Capstone mensyaratkan publikasi ke AUR. Memahami AUR berarti memahami **tanggung jawab** untuk mengaudit resep sebelum menjalankannya.

**Contoh konkret:** `yay -S my-quickshell` membangun dari AUR. Sebelum itu, baca PKGBUILD di `https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=my-quickshell`.

**Hubungan dengan istilah lain:** AUR → PKGBUILD → Supply chain → Deployment.

---

#### Supply chain (rantai pasok)

**Definisi sederhana:** Seluruh sumber kode dan alat yang masuk ke perangkat lunak Anda.

**Etimologi:** Dari bahasa Inggris “supply chain” (rantai pasokan) — istilah dari manufaktur yang diadopsi ke keamanan perangkat lunak pada 2010-an.

**Konteks historis:** Serangan rantai pasok terkenal: **SolarWinds** (2020), **event-stream** (2018), **xz-utils** (2024). Serangan ini menyisipkan kode berbahaya ke **dependensi** atau **alat build**, bukan ke kode utama.

**Mengapa penting dalam kurikulum:** Modul 5.3 menekankan **pin SHA**, **checksum**, **izin minimal**, dan **tanda tangan tag**. Ini adalah pertahanan terhadap serangan rantai pasok.

**Contoh konkret:** `uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683` (pin ke SHA) vs `uses: actions/checkout@v4` (pin ke tag yang bisa digeser).

**Hubungan dengan istilah lain:** Supply chain → PKGBUILD → AUR → CI/CD → Deployment.

---

#### CI/CD (Continuous Integration / Continuous Deployment)

**Definisi sederhana:** Otomatisasi pemeriksaan, build, dan rilis setiap kali kode berubah.

**Etimologi:** “Continuous” (terus-menerus) + “Integration” (integrasi) + “Deployment” (penerapan). CI diperkenalkan oleh **Grady Booch** pada 1991 dan dipopulerkan oleh **Extreme Programming** (Kent Beck, 1999).

**Konteks historis:** CI/CD mengotomatiskan **linting**, **testing**, dan **build** setiap push. Ini mencegah **regresi** dan memastikan kode selalu dalam keadaan dapat dirilis.

**Mengapa penting dalam kurikulum:** Capstone mensyaratkan CI dengan linting dan smoke test. CI adalah **penjaga kualitas** yang berjalan otomatis.

**Contoh konkret:** Lihat 3.10 di Capstone.

**Hubungan dengan istilah lain:** CI/CD → `qmllint` → Smoke test → Deployment.

---

#### [Tambahan] `qmllint`

**Definisi sederhana:** Pemeriksa statis berkas QML.

**Etimologi:** “QML” + “lint” (serat kain yang mengganggu — metafora untuk “kotoran” dalam kode). `lint` adalah alat yang menganalisis kode **tanpa menjalankannya**.

**Mengapa penting dalam kurikulum:** `qmllint` menangkap error sintaks, impor yang hilang, dan properti yang tidak dikenal **sebelum** kode dijalankan. Ini adalah **pertahanan pertama** dalam CI.

**Contoh konkret:** `qmllint shell.qml` — exit 0 jika bersih, non-zero jika ada error.

**Hubungan dengan istilah lain:** Linting → `qmllint` → CI → Kualitas.

---

#### [Tambahan] `perf`

**Definisi sederhana:** Alat profiling Linux untuk CPU dan event perangkat keras.

**Etimologi:** “Performance” (kinerja). `perf` adalah **antarmuka userspace** untuk **performance counter** kernel Linux.

**Mengapa penting dalam kurikulum:** Modul 5.2 menggunakan `perf stat` dan `perf record` untuk mengukur CPU. Ini adalah **bukti objektif** bahwa optimasi berhasil.

**Contoh konkret:** `perf stat -p $(pgrep -x quickshell)` menampilkan cycles, instructions, cache-misses.

**Hubungan dengan istilah lain:** Profiling → `perf` → Optimasi → Performa.

---

#### [Tambahan] `heaptrack`

**Definisi sederhana:** Pelacak alokasi memori; lebih praktis daripada `valgrind` untuk aplikasi GUI berat.

**Etimologi:** “Heap” (area memori dinamis) + “track” (melacak). Dibuat oleh **Milian Wolff** (KDE) pada 2014.

**Mengapa penting dalam kurikulum:** Modul 5.2 menggunakan `heaptrack` untuk menemukan **peak memory**, **leak**, dan **temporary allocation**.

**Contoh konkret:** `heaptrack quickshell -c my-shell` lalu `heaptrack_gui` untuk analisis.

**Hubungan dengan istilah lain:** Profiling → `heaptrack` → Memori → Optimasi.

---

#### [Tambahan] Overdraw

**Definisi sederhana:** Menggambar piksel yang sama berulang kali.

**Etimologi:** “Over” (berlebih) + “draw” (menggambar). Dalam grafis, overdraw adalah **pemborosan bandwidth GPU** karena piksel yang sama digambar lebih dari sekali.

**Mengapa penting dalam kurikulum:** Modul 5.2 menggunakan `QSG_VISUALIZE=overdraw` untuk memvisualisasikan area yang digambar berulang. Mengurangi overdraw adalah **kemenangan performa** yang besar.

**Contoh konkret:** Latar belakang jendela + panel bar + widget jam = 3× overdraw di area jam.

**Hubungan dengan istilah lain:** Overdraw → `QSG_*` → Optimasi → Performa.

---

#### [Tambahan] Unit systemd

**Definisi sederhana:** Deskripsi layanan yang dijalankan dan diawasi systemd.

**Etimologi:** “Unit” (satuan) — systemd menggunakan unit sebagai **abstraksi** untuk service, socket, mount, timer, dll.

**Mengapa penting dalam kurikulum:** Capstone mensyaratkan shell berjalan sebagai unit `systemd --user` dengan hardening. Unit systemd memastikan shell **otomatis restart** saat crash dan **dibatasi** oleh direktif hardening.

**Contoh konkret:** Lihat 3.7 di Capstone.

**Hubungan dengan istilah lain:** systemd → Unit → Hardening → Capstone.

---

#### [Tambahan] Nix flake

**Definisi sederhana:** Konfigurasi Nix yang reproducible.

**Etimologi:** “Flake” (serpihan) — istilah dari Nix untuk **konfigurasi yang dapat direproduksi**. `flake.lock` mengunci versi tepat dari setiap input.

**Mengapa penting dalam kurikulum:** Modul 5.3 menggunakan Nix flake untuk **reproducibility**. Build yang sama menghasilkan output yang sama, di mana pun dan kapan pun.

**Contoh konkret:** Lihat 3.5 di Modul 5.3.

**Hubungan dengan istilah lain:** Nix → Flake → Reproducibility → Deployment.

---

### 4.6 Alat dan Lingkungan

#### Environment (lingkungan)

**Definisi sederhana:** Kumpulan variabel yang diwariskan ke program yang Anda jalankan.

**Etimologi:** Dari bahasa Prancis **environ** (“sekitar”). Di UNIX, environment adalah **array** variabel `KEY=VALUE` yang diwariskan dari parent ke child.

**Mengapa penting dalam kurikulum:** `clearEnvironment: true` mencegah kebocoran variabel sensitif ke proses anak. `Quickshell.env("USER")` membaca variabel environment.

**Contoh konkret:** `env | grep SSH` menampilkan variabel SSH di environment Anda.

**Hubungan dengan istilah lain:** Environment → `clearEnvironment` → `Process` → Keamanan.

---

#### LSP (Language Server Protocol)

**Definisi sederhana:** Layanan yang memberi editor fitur pintar untuk suatu bahasa pemrograman.

**Etimologi:** “Language” + “Server” + “Protocol”. Diperkenalkan oleh Microsoft pada 2016 untuk **menghubungkan editor dengan bahasa**.

**Mengapa penting dalam kurikulum:** LSP untuk QML (mis. `qmlls`) memberi **autocomplete**, **go-to-definition**, dan **diagnostik** di editor. Ini adalah **alat produktivitas** yang penting.

**Contoh konkret:** `qmlls` adalah language server untuk QML. Editor seperti Neovim, VS Code, atau Kate mendukungnya.

**Hubungan dengan istilah lain:** LSP → `qmlls` → Editor → Produktivitas.

---

#### Linting

**Definisi sederhana:** Pemeriksaan otomatis kode untuk menemukan kesalahan tanpa menjalankannya.

**Etimologi:** Dari “lint” (serat kain yang mengganggu). Istilah ini berasal dari alat **`lint`** di UNIX (1978) yang memeriksa kode C.

**Mengapa penting dalam kurikulum:** `qmllint` adalah **pertahanan pertama** dalam CI. Linting menangkap error sebelum kode dijalankan.

**Contoh konkret:** `qmllint shell.qml`.

**Hubungan dengan istilah lain:** Linting → `qmllint` → CI → Kualitas.

---

#### Hot reload

**Definisi sederhana:** Perubahan kode langsung tampil tanpa menutup-buka program.

**Etimologi:** “Hot” (panas) + “reload” (muat ulang). Dalam pengembangan, hot reload memungkinkan **iterasi cepat** tanpa restart.

**Mengapa penting dalam kurikulum:** Quickshell mendukung hot reload untuk QML. Ini mempercepat **pengembangan** dan **debugging**.

**Contoh konkret:** `quickshell -c my-shell` secara otomatis memuat ulang QML saat berkas berubah (jika didukung).

**Hubungan dengan istilah lain:** Hot reload → Pengembangan → Iterasi.

---

#### [Tambahan] `SOURCE_DATE_EPOCH`

**Definisi sederhana:** Variabel lingkungan yang membekukan timestamp untuk build reproducible.

**Etimologi:** “Source” (sumber) + “Date” (tanggal) + “Epoch” (titik waktu). Standar dari **Reproducible Builds** project.

**Mengapa penting dalam kurikulum:** Modul 5.3 menggunakan `SOURCE_DATE_EPOCH` untuk memastikan build **reproducible**. Tanpa ini, timestamp yang tertanam di artefak membuat hash berbeda setiap build.

**Contoh konkret:**
```bash
export SOURCE_DATE_EPOCH=$(stat -c %Y "$srcdir/$pkgname-$pkgver.tar.gz")
```

**Hubungan dengan istilah lain:** Reproducibility → `SOURCE_DATE_EPOCH` → PKGBUILD → Deployment.

---

## 5. Rekomendasi Visualisasi

### 5.1 Peta Hubungan Antar-Istilah

```text
                        ┌─────────────┐
                        │   Wayland   │
                        └──────┬──────┘
                               │
                    ┌──────────┼──────────┐
                    ▼          ▼          ▼
             ┌──────────┐ ┌────────┐ ┌─────────────┐
             │Compositor│ │Layer-  │ │WlSessionLock│
             │          │ │shell   │ │             │
             └────┬─────┘ └───┬────┘ └──────┬──────┘
                  │           │             │
                  ▼           ▼             ▼
             ┌──────────┐ ┌────────┐ ┌─────────────┐
             │IPC       │ │Panel   │ │Lockscreen   │
             │Hyprland  │ │Window  │ │+ PAM        │
             └────┬─────┘ └───┬────┘ └──────┬──────┘
                  │           │             │
                  └───────────┼─────────────┘
                              ▼
                     ┌─────────────────┐
                     │   Quickshell    │
                     │   (Qt/QML)      │
                     └────────┬────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
       ┌────────────┐  ┌────────────┐  ┌────────────┐
       │  Process   │  │  IpcHandler│  │  Plugin    │
       │  + CLI     │  │  (qs ipc)  │  │  C++       │
       └─────┬──────┘  └─────┬──────┘  └─────┬──────┘
             │               │               │
             ▼               ▼               ▼
       ┌────────────┐  ┌────────────┐  ┌────────────┐
       │  Sandbox   │  │  Keybind   │  │  Audit     │
       │  (bwrap)   │  │  (Hyprland)│  │  (ASan)    │
       └────────────┘  └────────────┘  └────────────┘
```

### 5.2 Skala Abstraksi

```text
Tingkat abstraksi TINGGI (mudah, aman, terbatas)
    ▲
    │  QML murni (Binding, Komponen, Singleton)
    │  Modul Quickshell (Pipewire, Mpris, UPower)
    │  Process + CLI (nmcli, curl, brightnessctl)
    │  Compositor IPC (Hyprland, I3)
    │  Plugin C++ (syscall, /proc, ioctl)
    ▼
Tingkat abstraksi RENDAH (kompleks, berbahaya, penuh kendali)
```

---

## 6. Hubungan dengan Modul Lain

| Kelompok Istilah | Modul Terkait |
|---|---|
| Konsep Dasar Sistem | 0.1–0.4, 1.1, 2.1 |
| Qt dan QML | 0.2–0.4, 3.2, 5.1 |
| Proses dan IPC | 1.2, 2.2, 2.4, 5.1 |
| Keamanan | 3.3, 4.1–4.3, Capstone |
| Build dan Deployment | 5.3, Capstone |
| Alat dan Lingkungan | 1.2, 5.2, 5.3 |

---

## 7. Sumber Referensi

- [Wayland Documentation](https://wayland.freedesktop.org/docs/html/) — spesifikasi Wayland.
- [Qt Documentation](https://doc.qt.io/) — dokumentasi Qt 6.
- [QML Documentation](https://doc.qt.io/qt-6/qmlapplications.html) — dokumentasi QML.
- [D-Bus Specification](https://dbus.freedesktop.org/doc/dbus-specification.html) — spesifikasi D-Bus.
- [Linux Namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) — manual namespace.
- [Bubblewrap](https://github.com/containers/bubblewrap) — repositori `bwrap`.
- [Arch Wiki: PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) — referensi PKGBUILD.
- [Reproducible Builds](https://reproducible-builds.org/) — standar reproducibility.
- [Quickshell Documentation](https://quickshell.org/docs/) — dokumentasi Quickshell.

---

## 8. Tips dan Praktik Terbaik

1. **Gunakan glosarium sebagai rujukan, bukan bacaan linear.** Kembali ke sini setiap kali menemukan istilah yang tidak dikenal.
2. **Jangan hafal definisi; pahami konteksnya.** Setiap istilah memiliki **sejarah** dan **alasan** mengapa ia ada.
3. **Hubungkan istilah dengan modul.** Saat membaca Modul 5.1, buka glosarium untuk `QML_ELEMENT` dan `Q_PROPERTY`.
4. **Gunakan istilah yang tepat dalam diskusi.** “Compositor” bukan “window manager”; “D-Bus” bukan “IPC” secara umum.
5. **Perbarui glosarium Anda sendiri.** Saat menemukan istilah baru yang tidak ada di sini, tambahkan.

---

## 9. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menganggap Wayland = X11 | Bingung mengapa lockscreen butuh `WlSessionLock` | Baca konteks historis Wayland |
| Menganggap Qt = QML | Bingung mengapa perlu C++ | Qt adalah framework; QML adalah bahasa |
| Menganggap D-Bus = IPC | Bingung mengapa `Process` bukan D-Bus | D-Bus adalah **salah satu** IPC |
| Menganggap sandbox = aman | Plugin C++ tetap berbahaya | Sandbox hanya untuk proses terpisah |
| Menganggap `SKIP` checksum = praktis | Paket tidak dapat diaudit | Selalu gunakan checksum asli |
| Menganggap `kill -9` = `SIGTERM` | Lockscreen tampak aman padahal tidak | `kill -9` mensimulasikan crash keras |

---

> **Motivasi:** Setiap istilah yang Anda pahami adalah satu simpul yang terhubung dalam jaringan pengetahuan Anda. Semakin banyak simpul, semakin kuat jaringan itu — dan semakin mudah Anda memahami hal baru.

---

Berikutnya dalam kurikulum adalah **Hasil Pembelajaran (Learning Outcomes)** — menghubungkan setiap *learning outcome* dengan bukti konkret dari seluruh fase — diikuti **Sumber Daya Komunitas**, **Catatan Akhir Keamanan Tinggi**, dan **Catatan Revisi**.

# Hasil Pembelajaran (Learning Outcomes) — Diperluas dan Diperdalam

> **Audit singkat sebelum materi:** Kurikulum asli mencantumkan 9 *learning outcomes* (LO) dalam bentuk daftar ringkas. Yang **belum ada**: (a) **bukti konkret** untuk setiap LO — bagaimana Anda tahu Anda sudah mencapainya; (b) **pemetaan LO ke modul** — di mana keterampilan itu diajarkan; (c) **metode asesmen mandiri** — cara menguji diri sendiri; (d) **tingkat penguasaan** — apa bedanya “cukup” dan “mahir”; (e) **hubungan antar-LO** — LO mana yang menjadi prasyarat LO lain. Materi di bawah mengisi celah tersebut. Setiap penambahan ditandai **[Tambahan]** .

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

*Learning outcomes* adalah **kontrak antara kurikulum dan pembelajar**. Mereka menjawab pertanyaan: “Setelah menyelesaikan semua fase dan capstone, apa yang **pasti** bisa saya lakukan?” Mereka bukan daftar topik (itu tugas modul), melainkan daftar **kemampuan terukur** yang dapat dibuktikan.

**Mengapa penting:** Tanpa LO, Anda bisa menyelesaikan semua modul tetapi tidak tahu apakah Anda benar-benar menguasai materinya. LO adalah **cermin**: ia memantulkan kembali apa yang telah Anda pelajari dalam bentuk yang dapat diuji. Ini juga melindungi Anda dari **ilusi kompetensi** — perasaan “sudah paham” yang tidak terbukti saat menghadapi masalah nyata.

**Peran dalam kurikulum:** LO adalah **puncak piramida**. Di bawahnya ada fase, modul, dan latihan. LO merangkum semuanya menjadi satu set kemampuan yang koheren. Capstone adalah **wahana** untuk membuktikan LO; rubrik capstone adalah **instrumen** pengukurannya.

---

## 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “outcome, bukan output.”** *Output* adalah apa yang Anda hasilkan (mis. “saya menulis 500 baris QML”). *Outcome* adalah apa yang Anda **mampu lakukan** (mis. “saya dapat membangun shell yang lolos uji `kill -9`”). Kurikulum ini berfokus pada outcome: bukan berapa banyak kode yang Anda tulis, tetapi **apa yang dapat Anda lakukan dengan kode itu**.

**Prinsip “bukti, bukan klaim.”** Setiap LO harus dapat dibuktikan dengan **artefak**: kode yang berjalan, video demo, log CI, skor hardening, dokumen threat model. Klaim “saya bisa” tanpa bukti adalah **klaim kosong**. LO ini dirancang agar setiap butirnya memiliki **bukti yang dapat diverifikasi**.

**Prinsip “mastery, bukan completion.”** Menyelesaikan modul bukan berarti menguasainya. LO membedakan **tiga tingkat penguasaan**:

```text
Tingkat 1: CUKUP     — dapat mengikuti contoh, memahami konsep
Tingkat 2: MAMPU     — dapat membangun dari nol tanpa contoh
Tingkat 3: MAHIR     — dapat mengajari orang lain, mengaudit, dan berimprovisasi
```

Capstone menuntut **Tingkat 2** untuk semua LO dan **Tingkat 3** untuk LO yang menjadi inti spesialisasi Anda.

**Model mental: LO sebagai “peta kompetensi.”** Bayangkan LO sebagai **pulau-pulau** dalam kepulauan pengetahuan. Setiap pulau adalah kemampuan; jembatan antar-pulau adalah **hubungan prasyarat**. Anda belum “lulus” sampai Anda dapat **berjalan dari pulau ke pulau** tanpa tersesat — yaitu, menggunakan satu kemampuan untuk mendukung kemampuan lain.

---

## 3. Struktur Pembelajaran Internal

1. Peta LO ke modul dan fase
2. LO 1: Merancang dan membangun shell Wayland
3. LO 2: Mengintegrasikan layanan sistem secara reaktif
4. LO 3: Menyusun threat model dan menerapkan isolasi
5. LO 4: Membangun lockscreen dan greeter yang aman
6. LO 5: Memperluas Quickshell dengan plugin C++
7. LO 6: Mendiagnosis dan mengoptimalkan secara terukur
8. LO 7: Mengemas, menguji, dan mendistribusikan
9. LO 8: Menambahkan fitur apa pun dengan pohon keputusan
10. LO 9: Mengadaptasi kurikulum untuk tujuan lain
11. **[Tambahan]** Matriks asesmen mandiri
12. **[Tambahan]** Hubungan antar-LO (graf prasyarat)

---

## 4. Peta LO ke Modul dan Fase

| LO | Fase/Modul Sumber | Capstone yang Membuktikan |
|---|---|---|
| **LO 1** — Merancang & membangun shell | 0.1–0.4, 1.1–1.2, 2.1–2.2, 3.1–3.2 | Bar multi-monitor, Launcher, OSD |
| **LO 2** — Integrasi layanan sistem | 1.2, 2.2–2.4 | Workspace, Audio, Baterai, Notifikasi, Tray |
| **LO 3** — Threat model & isolasi | 3.3, 4.1, 4.3 | `clearEnvironment`, `bwrap`, D-Bus filter, unit hardened |
| **LO 4** — Lockscreen & greeter aman | 4.2–4.3 | `WlSessionLock` + PAM, uji `kill -9` |
| **LO 5** — Plugin C++ | 5.1 | `KernelInfo` (atau plugin lain) dengan audit ASan |
| **LO 6** — Diagnosis & optimasi | 5.2 | Angka `perf` sebelum/sesudah, overdraw yang dihilangkan |
| **LO 7** — Kemas, uji, distribusi | 5.3 | PKGBUILD/flake, CI hijau, rilis bertanda tangan |
| **LO 8** — Pohon keputusan | Pohon Keputusan, 0.4 | Setiap fitur capstone dipetakan ke cabang yang tepat |
| **LO 9** — Adaptasi kurikulum | Seluruh kurikulum | Dokumen “adaptasi untuk tujuan X” (mis. air-gapped) |

---

## 5. LO 1 — Merancang dan Membangun Shell Desktop Wayland dari Nol

### 5.1 Deskripsi Konkret

Anda mampu **memulai dari direktori kosong** dan menghasilkan shell yang berjalan di compositor Wayland: bar, launcher, OSD, dan setidaknya satu layanan sistem. Anda tidak bergantung pada template atau konfigurasi orang lain; Anda **menulis sendiri** dari `shell.qml` hingga unit systemd.

### 5.2 Konsep Kunci & Filosofi

**“Dari nol” berarti Anda memahami setiap baris.** Bukan berarti Anda tidak boleh membaca contoh, tetapi Anda harus bisa **menjelaskan mengapa** setiap baris ada. Shell yang Anda bangun adalah **milik Anda** — bukan salinan yang tidak Anda pahami.

**Arsitektur sebagai fondasi.** LO ini menguji apakah Anda dapat **menerapkan arah dependensi** (UI → services → sistem) sejak awal, bukan menambalnya di akhir.

### 5.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Shell berjalan dari direktori kosong | Rekam video: `mkdir my-shell && cd my-shell && quickshell -c my-shell` |
| Bar muncul di semua monitor | VM dua monitor; screenshot |
| Launcher terbuka dan menutup | Demo keyboard-only |
| Setidaknya satu layanan sistem berfungsi | Volume berubah via keybind |
| Tidak ada error di log | `journalctl --user -u my-shell` bersih |

### 5.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Shell berjalan dengan mengikuti tutorial |
| **Mampu** | Shell dibangun dari nol tanpa tutorial, dengan arsitektur yang jelas |
| **Mahir** | Dapat mengajari orang lain membangun shell dari nol; dapat mengaudit shell orang lain |

### 5.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Menyalin konfigurasi orang lain tanpa memahami | Tulis ulang dari nol; jelaskan setiap baris |
| Menunda multi-monitor | Uji `Variants` sejak awal |
| Tidak memisahkan UI dan services | Terapkan struktur direktori sejak hari pertama |

---

## 6. LO 2 — Mengintegrasikan Layanan Sistem Secara Reaktif

### 6.1 Deskripsi Konkret

Anda mampu **menghubungkan shell ke layanan sistem** — PipeWire, MPRIS, UPower, Bluetooth, notifikasi, tray, IPC compositor — **secara reaktif**, bukan polling. Anda memahami kapan menggunakan modul Quickshell, kapan `Process` + CLI, dan kapan plugin C++.

### 6.2 Konsep Kunci & Filosofi

**Reaktif berarti “bereaksi terhadap perubahan,” bukan “bertanya terus-menerus.”** Polling setiap detik adalah pemborosan; modul reaktif seperti `SystemClock`, `Pipewire`, `Mpris` mengirim signal saat nilai berubah. Ini adalah **efisiensi berbasis arsitektur**, bukan mikro-optimasi.

**Satu sumber kebenaran.** Setiap layanan adalah **singleton** yang menjadi satu-satunya sumber kebenaran. UI tidak pernah menulis langsung ke layanan; ia memanggil fungsi layanan.

### 6.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Volume berubah via keybind dan UI | Demo: tekan `XF86AudioRaiseVolume`, lihat OSD |
| Workspace mengikuti compositor | Pindah workspace, bar memperbarui |
| Notifikasi muncul dan tersimpan di riwayat | Kirim `notify-send`, lihat popup dan riwayat |
| Tidak ada polling yang tidak perlu | `perf stat` menunjukkan CPU idle rendah |
| Setiap layanan adalah singleton | `grep -r "pragma Singleton" services/` |

### 6.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Satu layanan berfungsi (mis. volume) |
| **Mampu** | Semua layanan capstone berfungsi secara reaktif |
| **Mahir** | Dapat menambahkan layanan baru tanpa mengubah arsitektur |

### 6.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Polling `date` setiap detik | Gunakan `SystemClock` |
| Setiap widget membuat `Pipewire` sendiri | Gunakan singleton `AudioService` |
| Menulis langsung ke `sink.audio.volume` dari UI | Selalu lewat `AudioService.setVolume()` |

---

## 7. LO 3 — Menyusun Threat Model dan Menerapkan Isolasi

### 7.1 Deskripsi Konkret

Anda mampu **menulis threat model satu halaman** yang mengidentifikasi aset, ancaman, dan mitigasi, lalu **menerapkannya** dalam kode: `clearEnvironment: true` pada setiap `Process`, `bwrap` untuk data tak tepercaya, penyaringan D-Bus, dan unit systemd dengan hardening yang **diukur**.

### 7.2 Konsep Kunci & Filosofi

**Threat model adalah dokumen hidup, bukan formalitas.** Ia ditulis **sebelum** kode, diperbarui saat kode berubah, dan dirujuk saat mengambil keputusan. Threat model yang tidak memengaruhi keputusan adalah **dokumen mati**.

**Isolasi berlapis.** Tidak ada satu mekanisme yang cukup. `clearEnvironment` melindungi environment; `bwrap` melindungi filesystem; `SystemCallFilter` melindungi syscall; D-Bus filter melindungi IPC. **Setiap lapisan** mengurangi permukaan serangan.

### 7.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Threat model satu halaman | Berkas `THREAT_MODEL.md` ada dan lengkap |
| `clearEnvironment` di semua `Process` | `grep -r "clearEnvironment" .` menunjukkan semua `Process` |
| Helper berjalan di `bwrap` | `ps aux` menunjukkan namespace terpisah |
| D-Bus disaring | `busctl monitor` menunjukkan filter |
| Skor hardening < 5 | `systemd-analyze security my-shell.service` |

### 7.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Threat model ada; `clearEnvironment` diterapkan |
| **Mampu** | Semua lapisan isolasi diterapkan; skor hardening < 5 |
| **Mahir** | Dapat mengaudit shell orang lain dan menemukan celah isolasi |

### 7.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Threat model ditulis setelah kode | Tulis **sebelum** lockscreen |
| `clearEnvironment` hanya di beberapa `Process` | Terapkan di **semua** `Process` |
| `bwrap` tanpa `--die-with-parent` | Tambahkan flag tersebut |
| Skor hardening tidak diukur | Jalankan `systemd-analyze security` dan catat |

---

## 8. LO 4 — Membangun Lockscreen dan Greeter yang Aman

### 8.1 Deskripsi Konkret

Anda mampu **membangun lockscreen** dengan `WlSessionLock` + PAM yang **fail-safe**: jika PAM error, jika proses shell mati, jika sinyal terputus — sesi tetap terkunci. Anda juga mampu membangun **greeter** dengan `greetd` untuk login awal.

### 8.2 Konsep Kunci & Filosofi

**Fail-safe adalah prinsip, bukan fitur.** Setiap jalur kegagalan harus menuju **keadaan aman** (terkunci), bukan keadaan terbuka. Ini adalah prinsip yang sama dengan sistem kendali nuklir: kegagalan tidak boleh membuka pintu.

**Lockscreen bukan sekadar UI.** Lockscreen adalah **kontrak keamanan** antara pengguna dan sistem. Jika kontrak ini dilanggar — mis. input bocor ke jendela di belakang, atau lock terbuka saat crash — seluruh sesi compromised.

### 8.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Lockscreen berfungsi | Demo: `SUPER+L`, layar terkunci |
| PAM memverifikasi kata sandi | Kata sandi benar membuka; salah tidak |
| `kill -9` tidak membuka lock | `kill -9 $(pgrep quickshell)`; sesi tetap terkunci |
| PAM error tidak membuka lock | Simulasi error PAM; sesi tetap terkunci |
| Input tidak bocor | `WlrKeyboardFocus.Exclusive` terlihat di kode |

### 8.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Lockscreen berfungsi dengan PAM |
| **Mampu** | Lolos uji `kill -9` dan PAM error |
| **Mahir** | Dapat mengaudit lockscreen orang lain; dapat membangun greeter |

### 8.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| `onError` mengubah `locked = false` | `onError` **tidak boleh** mengubah `locked` |
| `WlSessionLock` tidak didukung compositor | Periksa dukungan `ext-session-lock-v1` |
| Input bocor ke jendela belakang | `WlrKeyboardFocus.Exclusive` |
| Lockscreen diuji dengan `SIGTERM` | Uji dengan `kill -9` |

---

## 9. LO 5 — Memperluas Quickshell dengan Plugin C++ dan Mengauditnya

### 9.1 Deskripsi Konkret

Anda mampu **menulis plugin C++** yang mendaftarkan tipe QML, mengekspos properti/signal/fungsi, dan **mengauditnya** dengan sanitizer. Anda juga mampu memutuskan **kapan tidak menulis plugin** — ketika QML, `Process`, atau modul bawaan sudah cukup.

### 9.2 Konsep Kunci & Filosofi

**Eskalasi berbasis bukti.** Plugin C++ adalah **cabang terakhir** dalam pohon keputusan. Anda hanya menulisnya setelah membuktikan bahwa cabang sebelumnya tidak cukup.

**Audit adalah bagian dari penulisan.** Setiap baris C++ adalah **permukaan serangan**. Menulis plugin tanpa audit sama dengan memasang pintu belakang.

### 9.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Plugin berfungsi | `KernelInfo` muncul di QML; `ki.release` terbaca |
| Properti kedua berfungsi | `ki.hostname` terbaca |
| ASan/UBSan bersih | `-fsanitize=address,undefined` tanpa error |
| Audit terdokumentasi | Komentar di kode menjelaskan validasi masukan |
| Keputusan “kapan tidak” terdokumentasi | README menjelaskan mengapa plugin diperlukan |

### 9.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Plugin berfungsi dengan satu properti |
| **Mampu** | Plugin berfungsi dengan ASan bersih; audit terdokumentasi |
| **Mahir** | Dapat mengaudit plugin orang lain; dapat memutuskan kapan plugin tidak perlu |

### 9.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Lupa `Q_OBJECT` | Tambahkan `Q_OBJECT` |
| Lupa `QML_ELEMENT` | Tambahkan `QML_ELEMENT` |
| `Q_PROPERTY` tanpa `NOTIFY` | Tambahkan signal `NOTIFY` |
| Tidak menguji dengan ASan | Selalu uji dengan `-fsanitize=address,undefined` |
| Menulis plugin untuk hal yang bisa dilakukan `Process` | Coba `Process` dulu |

---

## 10. LO 6 — Mendiagnosis dan Mengoptimalkan Shell Secara Terukur

### 10.1 Deskripsi Konkret

Anda mampu **mengukur** penggunaan CPU, memori, dan GPU shell, **menemukan hotspot**, **mengubah** kode, dan **mengukur ulang** untuk membuktikan bahwa perubahan berhasil. Anda tidak mengoptimalkan berdasarkan tebakan; Anda mengoptimalkan berdasarkan **angka**.

### 10.2 Konsep Kunci & Filosofi

**Ukur dulu, jangan menebak.** 90% waktu eksekusi dihabiskan di 10% kode. Tanpa profil, Anda akan mengoptimalkan 90% kode yang tidak penting.

**Kerja yang tidak perlu adalah kerja yang paling mahal.** Kemenangan terbesar bukan dari kode C++ yang lebih cepat, tetapi dari **menghilangkan pekerjaan**: polling → reaktif, eager → lazy, overdraw → transparan.

### 10.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Baseline `perf stat` terdokumentasi | Catat cycles, instructions, cache-misses sebelum perubahan |
| Hotspot ditemukan | `perf report` menunjukkan fungsi dengan overhead tinggi |
| Perubahan dilakukan | Satu polling diganti dengan modul reaktif |
| Angka sesudah terdokumentasi | `perf stat` menunjukkan penurunan |
| Overdraw dihilangkan | `QSG_VISUALIZE=overdraw` sebelum/sesudah |

### 10.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Dapat menjalankan `perf stat` dan `heaptrack` |
| **Mampu** | Dapat menemukan hotspot dan membuktikan perbaikan dengan angka |
| **Mahir** | Dapat mengoptimalkan shell orang lain berdasarkan profil |

### 10.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Mengoptimalkan tanpa profil | Selalu mulai dari `perf`/`heaptrack` |
| Mengukur dengan build `Debug` | Gunakan `RelWithDebInfo` |
| Lupa mengukur ulang | Catat angka sebelum dan sesudah |
| Mengoptimalkan mikro sambil mengabaikan makro | Prioritaskan menghilangkan pekerjaan |

---

## 11. LO 7 — Mengemas, Menguji, dan Mendistribusikan Shell

### 11.1 Deskripsi Konkret

Anda mampu **mengemas** shell sebagai PKGBUILD atau Nix flake, **menguji** dengan CI (linting + smoke test), **mengamankan** rantai pasok (pin SHA, checksum, izin minimal), dan **berkontribusi** ke upstream.

### 11.2 Konsep Kunci & Filosofi

**Segel pada botol obat.** Checksum adalah jaminan bahwa isi paket tidak berubah sejak Anda menutupnya. Tanpa checksum, siapa pun dapat menyisipkan kode berbahaya.

**Reproducibility sebagai auditabilitas.** Build yang sama menghasilkan output yang sama. Ini memungkinkan siapa pun membangun ulang dan membandingkan hash.

### 11.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| PKGBUILD/flake ada | Berkas `PKGBUILD` atau `flake.nix` di repositori |
| Checksum asli | `sha256sums` berisi hash, bukan `SKIP` |
| Build di chroot bersih | `makechrootpkg -c -r $CHROOT` berhasil |
| CI hijau | Screenshot CI; `qmllint` dan smoke test lulus |
| Action di-pin SHA | `grep "uses:" .github/workflows/` menunjukkan SHA |
| Kontribusi upstream | PR/issue di repositori Quickshell |

### 11.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | PKGBUILD berfungsi dengan checksum |
| **Mampu** | CI hijau dengan linting dan smoke test; Action di-pin SHA |
| **Mahir** | Dapat memelihara paket AUR; dapat berkontribusi ke upstream |

### 11.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| `sha256sums=('SKIP')` | Gunakan `updpkgsums` |
| Action di-pin ke tag | Pin ke SHA commit |
| `permissions: write-all` | Gunakan izin minimal |
| Tidak ada smoke test | Tambahkan `timeout` + cek exit code |

---

## 12. LO 8 — Menambahkan Fitur Apa Pun dengan Pohon Keputusan

### 12.1 Deskripsi Konkret

Anda mampu **menghadapi kebutuhan baru** — fitur yang tidak ada di tutorial — dan **memetakannya** ke pendekatan yang tepat: QML murni, modul Quickshell, `Process` + CLI, compositor IPC, atau plugin C++. Anda juga mampu **membaca referensi API** untuk menemukan tipe yang tepat.

### 12.2 Konsep Kunci & Filosofi

**Pohon keputusan adalah kompas.** Ia mencegah over-engineering (plugin C++ untuk hal yang bisa dilakukan `Process`) dan under-engineering (QML untuk hal yang butuh syscall).

**Membaca referensi adalah keterampilan inti.** Pohon keputusan berakhir dengan “cari di referensi.” Anda harus mampu **menavigasi dokumentasi** Quickshell, Qt, dan protokol Wayland.

### 12.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Setiap fitur capstone dipetakan ke cabang | Tabel di README: fitur → cabang → modul |
| Keputusan “kapan tidak” terdokumentasi | README menjelaskan mengapa `Process`, bukan plugin |
| Referensi API digunakan | Komentar kode menautkan dokumentasi |
| Fitur baru ditambahkan tanpa bantuan | Demo: tambahkan fitur yang tidak ada di tutorial |

### 12.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Dapat mengikuti pohon keputusan untuk kebutuhan yang jelas |
| **Mampu** | Dapat memetakan kebutuhan ambigu ke cabang yang tepat |
| **Mahir** | Dapat memperbarui pohon keputusan saat Quickshell menambahkan modul baru |

### 12.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Langsung ke plugin C++ | Coba QML/`Process` dulu |
| Memaksakan QML untuk hal yang butuh CLI | Gunakan `Process` + `SplitParser` |
| Tidak membaca referensi versi Anda | Periksa dokumentasi versi terpasang |
| Mengabaikan cabang “tidak perlu” | Tanyakan: “Apakah ada pengguna nyata?” |

---

## 13. LO 9 — Mengadaptasi Kurikulum untuk Tujuan Lain

### 13.1 Deskripsi Konkret

Anda mampu **mengadaptasi** kurikulum ini untuk tujuan lain — lingkungan *air-gapped*, workstation forensik, kiosk, sistem embedded — dengan menambah modul keamanan dan anonimitas yang sesuai. Anda memahami bahwa kurikulum ini adalah **kerangka**, bukan **doktrin**.

### 13.2 Konsep Kunci & Filosofi

**Kurikulum adalah alat, bukan tujuan.** Tujuan akhirnya bukan “menyelesaikan kurikulum,” tetapi **mampu membangun shell yang sesuai dengan kebutuhan Anda**. Kurikulum ini adalah **peta**, tetapi Anda yang memilih rute.

**Adaptasi membutuhkan pemahaman mendalam.** Anda tidak dapat mengadaptasi kurikulum jika Anda tidak memahami **mengapa** setiap modul ada. Adaptasi adalah **tingkat penguasaan tertinggi**: Anda tidak hanya mengikuti peta, tetapi **menggambar peta baru**.

### 13.3 Bukti Konkret

| Bukti | Cara Membuktikan |
|---|---|
| Dokumen adaptasi | Berkas `ADAPTASI.md` yang menjelaskan tujuan, modul tambahan, dan alasan |
| Modul tambahan diimplementasikan | Mis. anonimitas metadata, build air-gapped |
| Keterbatasan diakui | Dokumen menjelaskan apa yang **tidak** dicakup |
| Referensi tambahan | Tautan ke sumber untuk topik tambahan |

### 13.4 Tingkat Penguasaan

| Tingkat | Indikator |
|---|---|
| **Cukup** | Dapat mengidentifikasi modul yang perlu ditambah |
| **Mampu** | Dapat menulis modul tambahan yang koheren |
| **Mahir** | Dapat merancang kurikulum baru dari nol untuk tujuan tertentu |

### 13.5 Kesalahan Umum

| Kesalahan | Solusi |
|---|---|
| Mengadaptasi tanpa memahami kurikulum asli | Selesaikan dulu semua LO 1–8 |
| Menambah modul tanpa alasan | Setiap modul harus menjawab ancaman/kebutuhan spesifik |
| Tidak mengakui keterbatasan | Dokumentasikan apa yang tidak dicakup |

---

## 14. [Tambahan] Matriks Asesmen Mandiri

Gunakan matriks ini untuk **mengukur diri sendiri** setelah setiap fase. Tandai tingkat penguasaan Anda (C = Cukup, M = Mampu, H = Mahir).

| LO | C | M | H | Bukti yang Dimiliki |
|---|---|---|---|---|
| LO 1 — Shell dari nol | ☐ | ☐ | ☐ | |
| LO 2 — Integrasi reaktif | ☐ | ☐ | ☐ | |
| LO 3 — Threat model & isolasi | ☐ | ☐ | ☐ | |
| LO 4 — Lockscreen aman | ☐ | ☐ | ☐ | |
| LO 5 — Plugin C++ | ☐ | ☐ | ☐ | |
| LO 6 — Optimasi terukur | ☐ | ☐ | ☐ | |
| LO 7 — Kemas & distribusi | ☐ | ☐ | ☐ | |
| LO 8 — Pohon keputusan | ☐ | ☐ | ☐ | |
| LO 9 — Adaptasi kurikulum | ☐ | ☐ | ☐ | |

**Aturan kelulusan:** Semua LO minimal **Mampu**; minimal **tiga LO** pada tingkat **Mahir** (pilih yang menjadi spesialisasi Anda).

---

## 15. [Tambahan] Hubungan Antar-LO (Graf Prasyarat)

```text
                    ┌─────────────────────────────────────────┐
                    │LO 8: Pohon Keputusan (meta-keterampilan)│
                    │ ─ memandu semua LO lain ─               │
                    └────────────────────┬────────────────────┘
                                         │
              ┌──────────────────────────┼──────────────────────────┐
              ▼                          ▼                          ▼
    ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
    │ LO 1: Shell     │      │ LO 2: Integrasi │      │ LO 5: Plugin    │
    │ dari nol        │─────►│ layanan reaktif │─────►│ C++             │
    └────────┬────────┘      └────────┬────────┘      └────────┬────────┘
             │                        │                        │
             ▼                        ▼                        ▼
    ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
    │ LO 3: Threat    │      │ LO 4: Lockscreen│      │ LO 6: Optimasi  │
    │ model & isolasi │◄─────│ aman            │      │ terukur         │
    └────────┬────────┘      └────────┬────────┘      └────────┬────────┘
             │                        │                        │
             └────────────────────────┼────────────────────────┘
                                      ▼
                             ┌─────────────────┐
                             │ LO 7: Kemas &   │
                             │ distribusi      │
                             └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │ LO 9: Adaptasi  │
                             │ kurikulum       │
                             └─────────────────┘
```

**Cara membaca:**

- **LO 8** adalah **meta-keterampilan** yang memandu semua LO lain. Tanpa pohon keputusan, Anda akan memilih pendekatan yang salah.
- **LO 1** adalah **fondasi**: tanpa shell yang berjalan, tidak ada yang bisa diintegrasikan.
- **LO 2** bergantung pada LO 1: layanan diintegrasikan ke shell yang sudah ada.
- **LO 3** dan **LO 4** saling terkait: threat model memandu desain lockscreen; lockscreen menguji threat model.
- **LO 5** adalah **eskalasi** dari LO 2: ketika modul tidak cukup, plugin C++.
- **LO 6** bergantung pada LO 2 dan LO 5: Anda mengoptimalkan layanan dan plugin.
- **LO 7** adalah **puncak**: Anda mengemas semua yang telah dibangun.
- **LO 9** adalah **tingkat tertinggi**: Anda mengadaptasi kurikulum untuk tujuan baru.

---

## 16. Rekomendasi Visualisasi

### 16.1 Piramida Penguasaan

```text
                         ▲
                        / \
                       /   \
                      /     \
                     / LO 9  \        ← Adaptasi (mahir)
                    /─────────\
                   / LO 7 & 8  \     ← Distribusi + pohon keputusan
                  /─────────────\
                 / LO 5 & 6      \    ← Plugin C++ + optimasi
                /─────────────────\
               / LO 3 & 4          \  ← Keamanan + lockscreen
              /─────────────────────\
             / LO 1 & 2              \ ← Fondasi: shell + layanan
            /─────────────────────────\
           / Fase 0–5 (modul, latihan) \ ← Pembelajaran
          /─────────────────────────────\
```

### 16.2 Alur Asesmen Mandiri

```text
Selesai fase
    │
    ▼
┌─────────────────────┐
│ Tandai LO di matriks│
│ (C / M / H)         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐       ┌─────────────────────┐
│ Ada LO < Mampu?     │── Ya ►│ Ulangi modul terkait│
└──────────┬──────────┘       └─────────────────────┘
           │ Tidak
           ▼
┌──────────────────┐          ┌─────────────────────┐
│ ≥3 LO Mahir?     │── Tidak ►│ Pilih spesialisasi  │
└──────────┬───────┘          └─────────────────────┘
           │ Ya
           ▼
┌─────────────────────┐
│ Siap untuk capstone │
└─────────────────────┘
```

---

## 17. Sumber Referensi

- [Quickshell Documentation](https://quickshell.org/docs/) — referensi tipe dan panduan.
- [Qt Documentation](https://doc.qt.io/) — dokumentasi Qt 6.
- [Arch Wiki: PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) — referensi pengemasan.
- [Reproducible Builds](https://reproducible-builds.org/) — standar reproducibility.
- [Wayland `ext-session-lock-v1`](https://wayland.app/protocols/ext-session-lock-v1) — spesifikasi lockscreen.
- [systemd-analyze security](https://www.freedesktop.org/software/systemd/man/systemd-analyze.html) — mengukur hardening.

---

## 18. Tips dan Praktik Terbaik

1. **Gunakan matriks asesmen setelah setiap fase**, bukan hanya di akhir. Ini mencegah “ilusi kompetensi” menumpuk.
2. **Simpan bukti di repositori.** Setiap LO harus memiliki artefak yang dapat dilihat: video, log, screenshot, dokumen.
3. **Jangan mengejar “Mahir” di semua LO.** Pilih **tiga LO** yang menjadi spesialisasi Anda; sisanya cukup “Mampu.”
4. **LO 8 adalah yang paling sering diabaikan.** Pohon keputusan bukan sekadar bacaan; ia harus **diterapkan** di setiap keputusan fitur.
5. **LO 9 hanya mungkin setelah LO 1–8.** Jangan mencoba mengadaptasi kurikulum sebelum menguasai dasarnya.
6. **Gunakan capstone sebagai wahana**, bukan sebagai tujuan. Tujuannya adalah **kemampuan**, bukan **artefak**.
7. **Tinjau matriks setiap bulan.** Kemampuan bisa luntur jika tidak dilatih; tinjauan berkala menjaga ketajaman.
8. **Dokumentasikan perjalanan Anda.** README yang menjelaskan “bagaimana saya mencapai LO X” adalah bukti terbaik.

---

## 19. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menganggap “selesai modul” = “menguasai LO” | Tidak bisa membangun dari nol | Uji dengan matriks asesmen |
| Mengejar “Mahir” di semua LO | Waktu habis, tidak ada spesialisasi | Pilih tiga LO untuk “Mahir” |
| Tidak menyimpan bukti | Tidak bisa membuktikan penguasaan | Simpan artefak di repositori |
| Melewatkan LO 8 | Memilih pendekatan yang salah | Terapkan pohon keputusan di setiap fitur |
| Mencoba LO 9 terlalu awal | Adaptasi tidak koheren | Selesaikan LO 1–8 dulu |
| Menganggap capstone = tujuan | Artefak ada, kemampuan tidak | Fokus pada kemampuan, bukan artefak |

---

> **Motivasi:** *Learning outcome* bukan tentang apa yang telah Anda baca, tetapi tentang apa yang telah Anda **kuasai**. Setiap butir yang Anda tandai “Mampu” adalah satu langkah menjauh dari penonton dan menuju pencipta.

---

Berikutnya dalam kurikulum adalah **Sumber Daya Komunitas dan Sertifikasi**, **Catatan Akhir untuk Pengguna dengan Profil Keamanan Tinggi**, dan **Catatan Revisi (Pasca-Audit)**.

# Sumber Daya Komunitas dan Sertifikasi — Diperluas dan Diperdalam

> **Audit singkat sebelum materi:** Kurikulum asli menyajikan tabel sumber daya dalam bentuk daftar tautan dan catatan singkat. Yang **belum ada**: (a) **kerangka evaluasi kredibilitas** — bagaimana membedakan sumber otoritatif dari sumber sekunder; (b) **etika komunitas** — norma dan praktik yang diharapkan saat berinteraksi di Matrix, Discord, forum, dan repositori; (c) **jalur kontribusi konkret** — dari laporan bug hingga PR yang diterima; (d) **lanskap sertifikasi** — apa yang tersedia, apa yang tidak, dan bagaimana menimbang nilainya; (e) **strategi pembelajaran komunitas** — cara memanfaatkan sumber daya secara efektif tanpa tenggelam. Materi di bawah mengisi celah tersebut. Setiap penambahan ditandai **[Tambahan]** .

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Sumber daya komunitas dan sertifikasi adalah **infrastruktur pendukung** yang menentukan seberapa cepat Anda berkembang setelah kurikulum ini selesai. Kurikulum mengajarkan **fondasi**; komunitas menyediakan **konteks hidup**: masalah nyata, solusi yang telah terbukti, dan orang-orang yang telah menempuh jalan yang sama.

**Mengapa penting:** Tidak ada kurikulum yang dapat mencakup semua kasus tepi. Ketika Anda menghadapi bug yang tidak ada di dokumentasi, atau ingin tahu apakah pendekatan Anda “idiomatik,” komunitas adalah tempat Anda menemukan jawaban. Sertifikasi, di sisi lain, adalah **bukti eksternal** bahwa Anda memiliki pengetahuan yang dapat diverifikasi — berguna untuk karier, tetapi bukan pengganti portofolio.

**Peran dalam kurikulum:** Bagian ini adalah **jembatan keluar**: dari pembelajar yang dipandu menjadi **anggota komunitas yang mandiri**. Ia melengkapi Capstone (yang membuktikan kemampuan) dengan **jejaring dan kredibilitas** yang membantu kemampuan itu diakui.

---

## 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “sumber primer di atas sumber sekunder.”** Dalam ekosistem Quickshell, **kode sumber** dan **dokumentasi resmi** adalah sumber primer; blog, video, dan ringkasan otomatis adalah sumber sekunder. Sumber sekunder berguna untuk **orientasi**, tetapi tidak boleh menjadi **otoritas akhir** — terutama untuk keamanan. Prinsip ini sejalan dengan ajaran kurikulum: “Agregator pihak ketiga bukan sumber otoritatif”.

**Prinsip “kontribusi adalah percakapan, bukan transaksi.”** Berkontribusi ke upstream bukan tentang “mengirim kode dan pergi,” tetapi tentang **memahami kebijakan proyek**, **mengikuti gaya yang ada**, dan **menerima tinjauan**. Quickshell secara eksplisit menyatakan bahwa setiap perubahan **harus dipahami sepenuhnya oleh pengirim** dan **tidak boleh ditulis oleh AI**. Ini adalah norma yang membedakan kontribusi berkualitas dari kebisingan.

**Prinsip “sertifikasi adalah peta, bukan wilayah.”** Sertifikasi Qt Quick mengukur **pengetahuan konseptual** (binding, layout, integrasi C++), tetapi tidak mengukur kemampuan membangun shell yang aman dan dapat dipelihara. Sertifikasi berguna sebagai **titik referensi**, tetapi **portofolio** (repositori, AUR, kontribusi upstream) adalah bukti yang lebih kuat.

**Model mental: komunitas sebagai “laboratorium terbuka.”** Bayangkan komunitas Quickshell sebagai laboratorium tempat orang-orang bereksperimen dengan konfigurasi, melaporkan bug, dan berbagi solusi. Anda tidak perlu menemukan segalanya sendiri; Anda dapat **belajar dari eksperimen orang lain** — tetapi Anda tetap harus **memverifikasi** hasilnya di lingkungan Anda.

---

## 3. Struktur Pembelajaran Internal

1. Kerangka evaluasi kredibilitas sumber
2. Sumber daya resmi Quickshell: dokumentasi, repositori, FAQ
3. Komunitas real-time: Matrix dan Discord
4. Forum dan agregator: r/unixporn, GitHub Discussions, wiki komunitas
5. Dokumentasi ekosistem: Qt, Hyprland, Sway, Arch Wiki
6. **[Tambahan]** Etika komunitas dan norma kontribusi
7. **[Tambahan]** Jalur kontribusi konkret ke upstream
8. **[Tambahan]** Lanskap sertifikasi: Qt Academy, Qt Quick Developer, Qt Quick Specialist
9. **[Tambahan]** Strategi memanfaatkan sumber daya tanpa tenggelam
10. **[Tambahan]** Membangun jejak digital yang kredibel

---

## 4. Kerangka Evaluasi Kredibilitas Sumber

Sebelum menggunakan sumber daya apa pun, evaluasi dengan kerangka **CRAAP** yang diadaptasi untuk ekosistem open-source:

| Kriteria | Pertanyaan | Contoh Quickshell |
|---|---|---|
| **Currency** (Kemutakhiran) | Apakah sumber diperbarui untuk versi Quickshell Anda? | Dokumentasi `quickshell.org/docs/` memiliki versi; periksa apakah sesuai dengan `quickshell --version` |
| **Relevance** (Relevansi) | Apakah sumber menjawab pertanyaan spesifik Anda? | FAQ menjawab pertanyaan umum; tipe referensi menjawab API spesifik |
| **Authority** (Otoritas) | Siapa penulisnya? Apakah mereka pengembang atau pengguna? | Kode sumber dan dokumentasi resmi adalah otoritas tertinggi; blog pribadi adalah pengalaman individu |
| **Accuracy** (Akurasi) | Apakah klaim dapat diverifikasi? | Klaim tentang API harus dapat dicek di dokumentasi atau kode sumber |
| **Purpose** (Tujuan) | Mengapa sumber ini dibuat? | Tutorial untuk belajar; changelog untuk melacak perubahan; issue untuk melaporkan bug |

**Aturan praktis:**

- **Untuk API dan perilaku:** dokumentasi resmi + kode sumber.
- **Untuk “mengapa” dan desain:** diskusi di Matrix/Discord + issue/PR di repositori.
- **Untuk inspirasi:** r/unixporn dan konfigurasi pengguna lain — tetapi **audit sebelum menjalankan**.
- **Untuk troubleshooting:** FAQ, issue yang sudah ada, dan pencarian di GitHub Discussions.

> **Peringatan keamanan:** Konfigurasi Quickshell adalah **kode berhak penuh**. Mengambil konfigurasi dari r/unixporn atau repositori publik tanpa audit sama dengan menjalankan skrip arbitrer dari internet. Selalu baca sebelum menjalankan.

---

## 5. Sumber Daya Resmi Quickshell

### 5.1 Dokumentasi Resmi

**quickshell.org/docs** adalah **sumber primer** untuk semua tipe dan panduan. Struktur dokumentasi mencakup:

- **Guided Introduction** — tutorial langkah demi langkah untuk membuat bar pertama.
- **QML Language Overview** — pengenalan QML untuk pengguna baru.
- **Item Size and Position** — panduan tata letak yang **signifikan berbeda** dari CSS.
- **Quickshell Types** — referensi lengkap setiap tipe, di sidebar kiri.
- **FAQ** — pertanyaan umum, termasuk pengurangan memori dengan `Loader`.

**Cara menggunakannya:** Mulai dari Guided Introduction, lalu skim QML Language Overview, lalu baca Item Size and Position **sebelum** mencoba membuat tata letak sendiri. Ini adalah urutan yang direkomendasikan secara resmi.

### 5.2 Repositori Utama

Repositori Quickshell di-host di **git.outfoxxed.me/quickshell/quickshell** (utama) dan **github.com/quickshell-mirror/quickshell** (mirror). Di dalamnya:

- **HACKING.md** — instruksi pengembangan dan kebijakan gaya.
- **CONTRIBUTING.md** — kebijakan kontribusi: perubahan harus dipahami sepenuhnya, tidak boleh ditulis AI, harus mengikuti gaya yang ada.
- **BUILD.md** — instruksi build dan pengemasan.
- **Lisensi:** GNU LGPL 3. Setiap kontribusi secara default dilisensikan di bawah lisensi yang sama.

### 5.3 FAQ dan Contoh Resmi

FAQ menjawab pertanyaan seperti “Bagaimana mengurangi penggunaan memori?” (jawabannya: gunakan `Loader`). **Official Examples** tersedia di repositori terpisah dan menunjukkan pola yang direkomendasikan.

> **Catatan penting:** Dokumentasi resmi memperingatkan bahwa Quickshell telah **berevolusi signifikan** dan **sebagian besar konfigurasi pengguna tidak mencerminkan praktik terbaik saat ini**. Ini berarti konfigurasi lama di r/unixporn mungkin menggunakan API yang sudah usang atau pola yang tidak lagi direkomendasikan.

---

## 6. Komunitas Real-Time: Matrix dan Discord

### 6.1 Matrix Space

**Tautan:** `https://matrix.to/#/#quickshell:outfoxxed.me`.

Matrix adalah protokol komunikasi terdesentralisasi yang **open-source** dan **end-to-end encrypted** (opsional). Space Quickshell adalah tempat diskusi utama untuk pengembang dan pengguna.

**Mengapa Matrix?** Matrix tidak dimiliki oleh satu perusahaan; siapa pun dapat menjalankan server sendiri. Ini sejalan dengan filosofi **super kontrol** dan **anonimitas** yang ditekankan kurikulum. Untuk pengguna dengan profil keamanan tinggi, Matrix memungkinkan komunikasi tanpa bergantung pada infrastruktur pihak ketiga.

### 6.2 Discord Server

**Tautan:** `https://discord.gg/UtZeT3xNyT`.

Discord adalah platform populer untuk komunitas open-source, tetapi **tidak open-source** dan **tidak terdesentralisasi**. Server Quickshell di Discord **di-bridge** dengan Matrix, sehingga pesan dari kedua platform saling terlihat.

**Kapan memilih mana?**

| Kebutuhan | Matrix | Discord |
|---|---|---|
| Anonimitas | ✅ (dapat menggunakan identitas pseudonim) | ⚠️ (memerlukan akun, tetapi bisa pseudonim) |
| Enkripsi end-to-end | ✅ (opsional per ruangan) | ❌ (hanya transport encryption) |
| Server sendiri | ✅ | ❌ |
| Kemudahan penggunaan | ⚠️ (lebih teknis) | ✅ (UI ramah) |
| Bridge ke platform lain | ✅ (melalui bridge) | ✅ (melalui bridge) |

> **Rekomendasi untuk profil keamanan tinggi:** Gunakan Matrix. Untuk diskusi umum, Discord lebih ramah; tetapi jika Anda menghindari platform terpusat, Matrix adalah pilihan yang selaras dengan prinsip Anda.

### 6.3 Etika Komunitas

**[Tambahan]** Berikut norma yang diharapkan di komunitas Quickshell dan open-source pada umumnya:

1. **Baca FAQ dan dokumentasi sebelum bertanya.** Pertanyaan yang sudah dijawab di FAQ membuang waktu semua orang.
2. **Sertakan konteks:** versi Quickshell (`quickshell --version`), compositor, dan pesan error lengkap.
3. **Jangan meminta orang lain menulis kode Anda.** Tunjukkan apa yang sudah Anda coba dan di mana Anda tersangkut.
4. **Gunakan thread:** Jangan memulai topik baru untuk pertanyaan lanjutan; balas di thread yang sama.
5. **Hargai waktu maintainer:** Mereka adalah sukarelawan. Jawaban mungkin tidak instan.
6. **Jangan membagikan konfigurasi tanpa peringatan keamanan.** Jika Anda membagikan konfigurasi, ingatkan bahwa Quickshell adalah kode berhak penuh dan harus diaudit.

---

## 7. Forum dan Agregator

### 7.1 r/unixporn

**Tautan:** `https://www.reddit.com/r/unixporn/`.

r/unixporn adalah komunitas berbagi **tampilan desktop** — screenshot, konfigurasi, dan “rice.” Ini adalah sumber **inspirasi**, bukan sumber **kebenaran teknis**.

**Peran dalam kurikulum:** Kurikulum menyebut r/unixporn sebagai inspirasi dengan **peringatan eksplisit**: “audit sebelum menjalankan konfigurasi orang lain.” Ini bukan formalitas. Konfigurasi Quickshell dapat menjalankan perintah shell, mengakses berkas, dan berkomunikasi melalui D-Bus. Menjalankannya tanpa audit adalah risiko keamanan nyata.

**Cara menggunakannya dengan aman:**

- **Lihat screenshot** untuk ide desain.
- **Baca kode** sebelum menjalankan: cari `Process`, `command`, `bash -c`, dan akses jaringan.
- **Jangan menyalin seluruh konfigurasi** ke shell utama Anda; uji di VM atau sesi terpisah.
- **Perhatikan versi:** Konfigurasi lama mungkin menggunakan API yang sudah usang.

### 7.2 GitHub Discussions

Repositori Quickshell mirror di GitHub memiliki **Discussions** untuk pertanyaan, ide, dan diskusi umum. Ini adalah tempat yang baik untuk pertanyaan yang tidak mendesak dan dapat dicari orang lain di masa depan.

### 7.3 Wiki Komunitas

Beberapa komunitas menyediakan wiki dan panduan troubleshooting. **[Tambahan]** Namun, wiki komunitas **tidak memiliki otoritas resmi**. Verifikasi klaim dengan dokumentasi resmi atau kode sumber.

---

## 8. Dokumentasi Ekosistem

### 8.1 Qt Documentation

**Tautan:** `https://doc.qt.io/`.

Qt adalah fondasi Quickshell. Dokumentasi Qt mencakup:

- **Qt Quick** — scene graph, animasi, binding.
- **QML** — sintaks, tipe, modul.
- **Integrasi QML-C++** — `QML_ELEMENT`, `Q_PROPERTY`, `qt_add_qml_module`.

**Mengapa penting:** Ketika Quickshell tidak mendokumentasikan perilaku tertentu (mis. cara kerja binding), dokumentasi Qt adalah sumber primer.

### 8.2 Hyprland Wiki

**Tautan:** `https://wiki.hypr.land/`.

Hyprland Wiki mendokumentasikan **IPC** (dua UNIX socket), **layer rules**, dan **event** seperti `openlayer`/`closelayer`. Ini penting untuk integrasi Quickshell dengan Hyprland: `Quickshell.Hyprland` menggunakan IPC ini.

**Peringatan:** IPC Hyprland bersifat **sinkron**; koneksi yang tidak ditutup dapat menyebabkan Hyprland freeze hingga timeout 5 detik. Ini adalah detail yang jarang dibahas tetapi krusial untuk stabilitas.

### 8.3 Sway Wiki

**Tautan:** `https://github.com/swaywm/sway/wiki`.

Quickshell menyediakan integrasi **i3/Sway IPC** melalui `Quickshell.I3`, yang menangani subscription dan reconnection secara otomatis. Sway Wiki mendokumentasikan protokol IPC yang mendasarinya.

### 8.4 Arch Wiki

**Tautan:** `https://wiki.archlinux.org/`.

Arch Wiki adalah **referensi sistem** yang komprehensif: Wayland, systemd, bubblewrap, PKGBUILD, dan AUR. Bahkan jika Anda tidak menggunakan Arch, wiki ini adalah sumber yang sangat berharga untuk **konsep sistem** yang berlaku di semua distribusi Linux.

---

## 9. [Tambahan] Jalur Kontribusi Konkret ke Upstream

### 9.1 Jenis Kontribusi yang Diterima

Berdasarkan `CONTRIBUTING.md` Quickshell, kontribusi yang dapat diterima meliputi:

**Kontribusi kode:**

- Perubahan yang **sepenuhnya dipahami** oleh pengirim.
- Deskripsi perubahan **ditulis sendiri**, bukan oleh AI (ringkasan AI boleh disertakan dalam spoiler).
- Perubahan harus **berdiri sendiri** sebagai satu unit; jangan mencampur beberapa perubahan tidak terkait dalam satu PR.
- Mengikuti pedoman gaya di `HACKING.md`.

**Kontribusi non-kode:**

- **Laporan bug dan crash** — ikuti template issue dan berikan informasi yang diminta.
- **Permintaan fitur** — melalui Issues; periksa apakah sudah ada yang meminta.
- **Jangan membuat perubahan yang tidak substansial** (typo, format yang tidak perlu).

### 9.2 Langkah-langkah Kontribusi

```text
1. Baca CONTRIBUTING.md dan HACKING.md
2. Cari issue yang sudah ada atau buka issue baru
3. Fork repositori (mirror GitHub untuk kemudahan)
4. Buat branch terpisah untuk setiap perubahan
5. Ikuti gaya kode yang ada; jalankan formatter (`just fmt`)
6. Tulis deskripsi PR dalam kata-kata sendiri
7. Ajukan PR; tandai sebagai draft jika masih bergantung pada merge lain
8. Tanggapi tinjauan dengan sopan; revisi sesuai masukan
```

**Alat yang digunakan Quickshell:** `just` untuk tugas pengembangan, dan formatter untuk konsistensi gaya.

### 9.3 Kontribusi Pertama yang Realistis

Untuk kontribusi pertama, pilih **perbaikan kecil yang jelas**:

- Perbaiki typo di dokumentasi.
- Tambahkan contoh penggunaan di komentar kode.
- Laporkan bug dengan reproduksi minimal.
- Perbaiki pesan error yang membingungkan.

**Hindari** kontribusi pertama yang besar dan kompleks; mereka membutuhkan pemahaman mendalam tentang arsitektur dan cenderung ditolak atau memerlukan revisi panjang.

---

## 10. [Tambahan] Lanskap Sertifikasi

### 10.1 Qt Academy

**Tautan:** `https://www.qt.io/academy`.

Qt Academy adalah platform **e-learning gratis** dari Qt Company. Kursus mencakup QML, Qt Quick, dan topik lanjutan.

**Struktur pembelajaran:**

- **QML Beginner Learning Path** — serangkaian kursus yang dirancang untuk pemula.
- **Sertifikat penyelesaian** — tersedia setelah menyelesaikan setidaknya **5 kursus** dari jalur pembelajaran.
- **Kursus gratis** — cukup login dengan akun Qt Academy.

**Nilai praktis:** Qt Academy adalah cara terstruktur untuk mempelajari **dasar-dasar QML** jika Anda merasa kurikulum ini terlalu cepat. Namun, Qt Academy **tidak mencakup Quickshell** — ia mengajarkan Qt/QML umum, bukan tipe atau pola Quickshell.

### 10.2 Sertifikasi Qt Quick

**[Tambahan]** Pada 2025, Qt meluncurkan **Qt Certification Testing Platform** dengan sertifikasi khusus Qt Quick:

| Sertifikasi | Fokus | Level | Format |
|---|---|---|---|
| **Qt Quick Developer (6.8 LTS)** | Konsep QML, layout, interaksi pengguna, Qt Quick Controls, model/view, integrasi QML-C++ | Fundamentals | 50 soal, lulus 65% |
| **Qt Quick Specialist (6.8 LTS)** | Animasi, optimasi performa, pola aplikasi QML, integrasi C++ lanjutan, Scene Graph | Advanced | 30 soal, lulus 60% |

**Harga:** €100 (termasuk VAT jika berlaku), durasi 60 menit.

**Cakupan kurikulum Qt Quick Developer** mencakup topik yang **selaras dengan kurikulum ini**: hierarki elemen, binding, signal, layout, `Loader`, `Repeater`, `ListView`, dan integrasi QML-C++. Ini berarti sertifikasi ini adalah **validasi eksternal** yang relevan.

**Apa yang TIDAK dicakup sertifikasi:**

- Quickshell secara spesifik.
- Keamanan (sandbox, threat model, PAM).
- Deployment (PKGBUILD, Nix, CI).
- Integrasi compositor (Hyprland/I3).

**Kesimpulan:** Sertifikasi Qt Quick berguna sebagai **bukti pengetahuan QML/Qt**, tetapi **bukan pengganti portofolio**. Untuk Quickshell, bukti terkuat tetap **shell yang dipublikasikan** dan **kontribusi upstream**.

### 10.3 Sertifikasi yang Tidak Ada

**Tidak ada sertifikasi resmi Quickshell.** Kurikulum menyatakan ini dengan jelas: “Validasi keahlian lewat portofolio shell yang dipublikasikan (GitHub, AUR) dan kontribusi upstream.” Ini bukan kelemahan, melainkan **realitas ekosistem open-source**: kredibilitas dibangun melalui **karya yang dapat dilihat**, bukan melalui sertifikat.

---

## 11. [Tambahan] Strategi Memanfaatkan Sumber Daya Tanpa Tenggelam

Komunitas open-source bisa **membanjiri**: ratusan pesan Matrix, ribuan konfigurasi r/unixporn, dan diskusi yang tak berujung. Berikut strategi untuk tetap fokus:

1. **Tetapkan tujuan spesifik:** “Saya ingin menyelesaikan bar multi-monitor” — bukan “Saya ingin belajar Quickshell.”
2. **Gunakan pencarian sebelum bertanya:** Cari di FAQ, issue, dan Discussions.
3. **Batasi waktu eksplorasi:** 15 menit untuk inspirasi, lalu kembali ke kode.
4. **Ikuti thread yang relevan**, bukan semua thread.
5. **Simpan tautan yang berguna** di catatan pribadi; jangan mengandalkan ingatan.
6. **Berkontribusi ketika Anda siap**, bukan sebelum Anda memahami dasar-dasarnya.

---

## 12. [Tambahan] Membangun Jejak Digital yang Kredibel

Karena tidak ada sertifikasi Quickshell, **jejak digital** Anda adalah portofolio:

| Artefak | Di Mana | Nilai |
|---|---|---|
| Repositori shell | GitHub/GitLab | Bukti kemampuan membangun |
| Paket AUR | AUR | Bukti kemampuan mengemas |
| PR ke upstream | Repositori Quickshell | Bukti kemampuan berkontribusi |
| Laporan bug yang baik | Issue tracker | Bukti pemahaman sistem |
| Dokumentasi/tutorial | Blog, wiki | Bukti kemampuan mengajar |

**Prinsip:** Setiap artefak harus **dapat diverifikasi** dan **menunjukkan pemahaman**, bukan sekadar “ada.”

---

## 13. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Sumber primer** | Sumber asli: kode sumber, dokumentasi resmi, spesifikasi |
| **Sumber sekunder** | Interpretasi: blog, video, ringkasan otomatis |
| **CRAAP** | Kerangka evaluasi: Currency, Relevance, Authority, Accuracy, Purpose |
| **Matrix** | Protokol komunikasi terdesentralisasi, open-source, E2EE opsional |
| **Bridge** | Koneksi antara dua platform (mis. Matrix ↔ Discord) |
| **Upstream** | Repositori utama tempat kode sumber dipelihara |
| **PR (Pull Request)** | Permintaan untuk menggabungkan perubahan ke upstream |
| **Issue** | Laporan bug atau permintaan fitur |
| **HACKING.md** | Panduan pengembangan dan gaya kode |
| **CONTRIBUTING.md** | Kebijakan kontribusi |
| **Qt Academy** | Platform e-learning gratis dari Qt Company |
| **Qt Quick Developer** | Sertifikasi Qt untuk QML/Qt Quick fundamentals |
| **Qt Quick Specialist** | Sertifikasi Qt lanjutan untuk Qt Quick |
| **Portofolio** | Kumpulan karya yang dapat diverifikasi |

---

## 14. Rekomendasi Visualisasi

### 14.1 Peta Sumber Daya

```text
                        ┌─────────────────────────────┐
                        │     SUMBER PRIMER           │
                        │                             │
                        │  quickshell.org/docs        │
                        │  git.outfoxxed.me/quickshell│
                        │  github.com/quickshell-     │
                        │    mirror/quickshell        │
                        │  Qt Documentation           │
                        │  Hyprland/Sway Wiki         │
                        │  Arch Wiki                  │
                        └─────────────┬───────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │ KOMUNITAS       │     │ AGREGATOR       │     │ SERTIFIKASI     │
    │ REAL-TIME       │     │                 │     │                 │
    │                 │     │ r/unixporn      │     │ Qt Academy      │
    │ Matrix Space    │     │ GitHub          │     │ Qt Quick        │
    │ Discord Server  │     │   Discussions   │     │   Developer     │
    │                 │     │ Wiki komunitas  │     │ Qt Quick        │
    │                 │     │                 │     │   Specialist    │
    └────────┬────────┘     └────────┬────────┘     └────────┬────────┘
             │                       │                       │
             ▼                       ▼                       ▼
    ┌─────────────────────────────────────────────────────────────┐
    │              VERIFIKASI DENGAN SUMBER PRIMER                │
    │  (Jangan pernah menganggap sumber sekunder sebagai otoritas)│
    └─────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
                        ┌─────────────────────────────┐
                        │     PORTOFOLIO ANDA         │
                        │  Repositori, AUR, PR, dll.  │
                        └─────────────────────────────┘
```

### 14.2 Alur Kontribusi

```text
Baca CONTRIBUTING.md
        │
        ▼
Cari issue / buat issue baru
        │
        ▼
Fork → Branch → Perubahan kecil
        │
        ▼
Ikuti gaya (HACKING.md, formatter)
        │
        ▼
Tulis deskripsi PR (kata sendiri)
        │
        ▼
Ajukan PR → Tanggapi tinjauan → Revisi
        │
        ▼
Merge (atau ditolak dengan alasan)
```

---

## 15. Hubungan dengan Modul Lain

| Sumber Daya | Modul Terkait |
|---|---|
| Dokumentasi Quickshell | 0.1–5.3 (semua) |
| Matrix/Discord | 0.4, 5.1 (debugging) |
| r/unixporn | 2.1, 3.1 (inspirasi UI) |
| Qt Documentation | 5.1 (plugin C++) |
| Hyprland/Sway Wiki | 2.2 (IPC compositor) |
| Arch Wiki | 5.3 (PKGBUILD, systemd) |
| Qt Academy | 0.2–0.4 (fondasi QML) |
| Qt Quick Certification | 3.2, 5.1 (validasi QML/C++) |
| Kontribusi upstream | Capstone, LO 7 |

---

## 16. Sumber Referensi

- [Quickshell Documentation](https://quickshell.org/docs/) — dokumentasi resmi.
- [Quickshell Repositori Utama](https://git.outfoxxed.me/quickshell/quickshell) — kode sumber.
- [Quickshell GitHub Mirror](https://github.com/quickshell-mirror/quickshell) — mirror untuk kontribusi.
- [Quickshell CONTRIBUTING.md](https://github.com/quickshell-mirror/quickshell/blob/master/CONTRIBUTING.md) — kebijakan kontribusi.
- [Quickshell FAQ](https://quickshell.org/docs/guide/faq) — pertanyaan umum.
- [Qt Documentation](https://doc.qt.io/) — dokumentasi Qt.
- [Qt Academy](https://www.qt.io/academy) — kursus gratis.
- [Qt Quick Certification](https://www.qt.io/blog/qt-quick-certification-tests-published) — pengumuman sertifikasi.
- [Hyprland Wiki: IPC](https://wiki.hypr.land/IPC/) — dokumentasi IPC.
- [Sway Wiki](https://github.com/swaywm/sway/wiki) — dokumentasi Sway.
- [Arch Wiki](https://wiki.archlinux.org/) — referensi sistem.

---

## 17. Tips dan Praktik Terbaik

1. **Selalu verifikasi dengan sumber primer.** Sumber sekunder adalah orientasi, bukan otoritas.
2. **Audit konfigurasi sebelum menjalankan.** Quickshell adalah kode berhak penuh.
3. **Gunakan Matrix untuk anonimitas**, Discord untuk kemudahan.
4. **Baca CONTRIBUTING.md sebelum berkontribusi.** Quickshell memiliki kebijakan ketat tentang pemahaman dan AI.
5. **Mulai kontribusi dari yang kecil.** Dokumentasi, typo, laporan bug.
6. **Qt Academy gratis dan terstruktur** — gunakan jika Anda butuh fondasi QML.
7. **Sertifikasi Qt Quick adalah validasi parsial**, bukan pengganti portofolio.
8. **Bangun jejak digital yang dapat diverifikasi:** repositori, AUR, PR.
9. **Jangan tenggelam di komunitas.** Tetapkan tujuan spesifik dan batasi waktu eksplorasi.
10. **Hargai maintainer.** Mereka sukarelawan; jawaban tidak instan.

---

## 18. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menjalankan konfigurasi r/unixporn tanpa audit | Risiko keamanan | Baca kode sebelum menjalankan; uji di VM |
| Menganggap blog = dokumentasi | Menggunakan API usang | Verifikasi dengan dokumentasi resmi |
| Bertanya tanpa membaca FAQ | Waktu terbuang | Cari dulu, baru bertanya |
| Mengirim PR tanpa membaca CONTRIBUTING | PR ditolak | Baca kebijakan; ikuti gaya |
| Menganggap sertifikasi = penguasaan | Tidak bisa membangun shell | Sertifikasi hanya validasi parsial |
| Mengandalkan AI untuk deskripsi PR | Dilarang oleh Quickshell | Tulis sendiri; AI hanya untuk konteks |
| Tenggelam di komunitas | Tidak ada kemajuan | Tetapkan tujuan dan batas waktu |
| Tidak menyimpan tautan berguna | Mengulang pencarian | Simpan catatan pribadi |

---

> **Motivasi:** Komunitas adalah **akselerator**, bukan pengganti kerja keras. Setiap pertanyaan yang Anda tanyakan dengan baik, setiap bug yang Anda laporkan dengan jelas, dan setiap PR yang Anda ajukan dengan pemahaman adalah **kontribusi** — bukan hanya pada proyek, tetapi pada ekosistem yang membuat proyek itu hidup.

---

Berikutnya dalam kurikulum adalah **Catatan Akhir untuk Pengguna dengan Profil Keamanan Tinggi** — memperdalam anonimitas metadata, build reproducible dengan `SOURCE_DATE_EPOCH`, isolasi D-Bus dengan `xdg-dbus-proxy`, dan analisis statis QML — diikuti **Catatan Revisi (Pasca-Audit)**.

# Catatan Akhir untuk Pengguna dengan Profil Keamanan Tinggi — Diperluas dan Diperdalam

> **Audit singkat sebelum materi:** Kurikulum asli menyebut topik-topik ini secara singkat: `xdg-dbus-proxy`, `SOURCE_DATE_EPOCH`, analisis statis QML, dan anonimitas metadata. Yang **belum ada**: (a) **mengapa** setiap topik penting untuk profil keamanan tinggi; (b) **cara konkret** menerapkannya, bukan sekadar menyebut alat; (c) **batas** dari setiap mekanisme — apa yang **tidak** bisa dilindungi; (d) **hubungan** antara topik-topik ini dan fase sebelumnya; (e) **model ancaman** yang menjadi dasar semua keputusan. Materi di bawah mengisi celah tersebut. Setiap penambahan ditandai **[Tambahan]** .

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini adalah **lapisan pertahanan terakhir** dari kurikulum. Fase 1–5 mengajarkan cara membangun shell yang aman untuk pengguna umum; bagian ini mengajarkan cara membangun shell yang **tetap aman bahkan ketika pengguna adalah target**, ketika metadata adalah risiko, dan ketika rantai pasok tidak dapat dipercaya sepenuhnya.

**Mengapa penting:** Shell desktop adalah **program dengan hak penuh atas sesi pengguna**. Ia membaca clipboard, menerima input keyboard, mengakses berkas, dan berkomunikasi melalui D-Bus. Bagi pengguna dengan profil keamanan tinggi — jurnalis, peneliti, aktivis, atau siapa pun yang menghadapi ancaman targeted — shell bukan sekadar alat produktivitas; ia adalah **permukaan serangan yang harus diperkecil**.

**Peran dalam kurikulum:** Bagian ini adalah **puncak dari LO 3** (threat model dan isolasi) dan **LO 9** (adaptasi kurikulum). Ia tidak mengajarkan keterampilan baru; ia mengajarkan **cara menerapkan keterampilan yang sudah ada dengan standar yang lebih tinggi**.

---

## 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “keamanan berlapis, bukan keamanan tunggal.”** Tidak ada satu mekanisme yang cukup. `clearEnvironment` melindungi environment; `bwrap` melindungi filesystem; `xdg-dbus-proxy` melindungi IPC; `SOURCE_DATE_EPOCH` melindungi reproducibility; analisis statis melindungi dari kesalahan yang tidak terlihat. **Setiap lapisan** mengurangi permukaan serangan, tetapi **tidak ada lapisan yang sempurna**.

**Prinsip “asumsi terburuk.”** Jika Anda tidak dapat membuktikan bahwa suatu komponen aman, anggap komponen itu **tidak aman**. Ini adalah **prinsip paranoid** yang menjadi fondasi keamanan tingkat tinggi. Plugin QML dari internet? Anggap berbahaya sampai diaudit. Konfigurasi dari r/unixporn? Anggap berbahaya sampai dibaca. Dependensi yang tidak di-pin? Anggap dapat berubah.

**Prinsip “anonimitas bukan sekadar menyembunyikan identitas.”** Anonimitas metadata berarti **menghilangkan jejak** yang dapat menghubungkan artefak dengan Anda: path pribadi, timestamp, nama pengguna, alamat IP, dan pola build. Ini relevan untuk **artefak yang dibagikan** (paket, repositori, konfigurasi), bukan hanya untuk komunikasi.

**Model mental: shell sebagai “benteng dengan banyak pintu.”** Setiap fitur adalah pintu. Setiap pintu harus **dikunci** (least privilege), **diawasi** (audit), dan **dibatasi** (sandbox). Bagian ini adalah tentang **pintu-pintu yang sering terlupakan**: D-Bus, metadata, dan rantai pasok.

---

## 3. Struktur Pembelajaran Internal

1. Model ancaman untuk profil keamanan tinggi
2. Isolasi D-Bus dengan `xdg-dbus-proxy`
3. Anonimitas metadata: menghilangkan jejak dari artefak
4. Build reproducible dengan `SOURCE_DATE_EPOCH`
5. Analisis statis QML: `qmllint`, `qml_static_analyzer`, dan batasannya
6. **[Tambahan]** Batas fundamental QML: mengapa sandbox tidak mungkin
7. **[Tambahan]** Audit plugin C++: daftar periksa minimum
8. **[Tambahan]** Integrasi semua lapisan: daftar periksa akhir

---

## 4. Model Ancaman untuk Profil Keamanan Tinggi

Sebelum menerapkan mekanisme apa pun, Anda harus **menulis model ancaman**. Berikut kerangka yang diperluas dari STRIDE, disesuaikan untuk shell desktop:

| Kategori Ancaman | Contoh dalam Shell | Aset yang Terancam | Mitigasi |
|---|---|---|---|
| **Spoofing** | Plugin palsu yang meniru nama plugin resmi | Integritas shell | Pin checksum, verifikasi tanda tangan, audit kode |
| **Tampering** | Modifikasi paket dalam perjalanan | Integritas artefak | `sha256sums`, tanda tangan GPG, TLS |
| **Repudiation** | Tindakan shell tidak tercatat | Auditabilitas | Log tanpa kredensial, `journalctl` |
| **Information disclosure** | Kebocoran kata sandi via environment, clipboard, D-Bus | Kerahasiaan | `clearEnvironment`, `xdg-dbus-proxy`, anonimitas metadata |
| **Denial of service** | Plugin yang mengalokasikan memori tanpa batas | Ketersediaan | `systemd` `MemoryMax`, batas proses |
| **Elevation of privilege** | Plugin C++ yang mengeksploitasi bug Qt | Integritas sistem | `bwrap`, `NoNewPrivileges`, `SystemCallFilter` |

**Aturan emas:** Setiap fitur yang Anda tambahkan harus **dipetakan ke setidaknya satu kategori ancaman** dan **memiliki mitigasi**. Jika tidak, fitur itu adalah **risiko yang tidak termitigasi**.

---

## 5. Isolasi D-Bus dengan `xdg-dbus-proxy`

### 5.1 Mengapa D-Bus adalah Permukaan Serangan

D-Bus adalah **sistem saraf** desktop Linux. Melalui D-Bus, shell dapat:
- Membaca notifikasi (yang mungkin berisi token autentikasi).
- Mengontrol media player (MPRIS).
- Mengakses clipboard.
- Berkomunikasi dengan Portal (akses berkas, screenshot).
- Memanggil layanan sistem (UPower, NetworkManager).

**Masalahnya:** Setiap proses di bus sesi dapat **mendengarkan** signal dari proses lain dan **memanggil** metode pada nama well-known. Tanpa filter, plugin berbahaya dapat **membaca semua notifikasi**, **mengambil alih MPRIS**, atau **mengakses Portal** tanpa sepengetahuan pengguna.

### 5.2 Cara Kerja `xdg-dbus-proxy`

`xdg-dbus-proxy` adalah **proxy penyaring** yang duduk di antara klien dan bus sesi. Klien terhubung ke socket proxy, bukan langsung ke bus. Proxy memeriksa setiap pesan dan **meneruskan atau membuang** berdasarkan kebijakan.

```text
Tanpa proxy:
Klien ──────────────────────────────────► Bus Sesi
         (semua pesan diteruskan)

Dengan proxy:
Klien ──► Socket Proxy ──► [Filter] ──► Bus Sesi
                           │
                           ├─ SEE  : klien bisa melihat nama
                           ├─ TALK : klien bisa memanggil metode
                           └─ OWN  : klien bisa memiliki nama
```

**Tiga tingkat kebijakan:**

| Tingkat | Arti | Contoh |
|---|---|---|
| **SEE** | Klien dapat melihat nama di `ListNames`, memanggil `GetNameOwner`, melihat `NameOwnerChanged` | Cukup untuk mengetahui apakah layanan berjalan |
| **TALK** | Klien dapat memanggil metode dan menerima broadcast signal | Diperlukan untuk menggunakan layanan |
| **OWN** | Klien dapat meminta nama (`RequestName`) | Diperlukan untuk **menyediakan** layanan (mis. notification daemon) |

### 5.3 Contoh Konkret: Menjalankan Helper dengan D-Bus Terfilter

```bash
#!/usr/bin/env bash
# helpers/bwrap-dbus-wrapper.sh
# Menjalankan helper di bwrap + xdg-dbus-proxy.
# Helper hanya boleh TALK ke PipeWire dan MPRIS, tidak lebih.

set -euo pipefail

APP_NAME="my-helper"
APP_FOLDER="${XDG_RUNTIME_DIR}/app/${APP_NAME}"
mkdir -p "$APP_FOLDER"

REAL_BUS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"
PROXY_SOCKET="${APP_FOLDER}/bus-proxy"

# 1. Jalankan xdg-dbus-proxy di latar belakang.
#    --filter: aktifkan mode filtering
#    --talk=org.freedesktop.portal.Flatpak: izinkan Portal Flatpak
#    --talk=org.mpris.MediaPlayer2.*: izinkan MPRIS
xdg-dbus-proxy \
    "$REAL_BUS" \
    "$PROXY_SOCKET" \
    --filter \
    --talk=org.freedesktop.portal.Flatpak \
    --talk=org.mpris.MediaPlayer2.* \
    &
PROXY_PID=$!

trap 'kill "$PROXY_PID" 2>/dev/null || true' EXIT

# 2. Tunggu socket proxy siap (polling singkat).
for _ in $(seq 1 50); do
    [[ -S "$PROXY_SOCKET" ]] && break
    sleep 0.05
done

# 3. Jalankan helper di bwrap dengan DBUS_SESSION_BUS_ADDRESS
#    diarahkan ke proxy, bukan ke bus asli.
exec bwrap \
    --unshare-all \
    --share-net \
    --die-with-parent \
    --new-session \
    --ro-bind /usr /usr \
    --ro-bind /etc /etc \
    --proc /proc \
    --dev /dev \
    --tmpfs /tmp \
    --bind "$APP_FOLDER" "$APP_FOLDER" \
    --setenv DBUS_SESSION_BUS_ADDRESS "unix:path=${PROXY_SOCKET}" \
    --setenv PATH /usr/bin:/bin \
    --chdir /tmp \
    -- "$@"
```

**Penjelasan kata demi kata:**

| Elemen | Fungsi |
|---|---|
| `APP_FOLDER` | Direktori runtime per-aplikasi; socket proxy diletakkan di sini |
| `REAL_BUS` | Alamat bus sesi asli (biasanya `/run/user/UID/bus`) |
| `PROXY_SOCKET` | Socket tempat klien terhubung; **bukan** bus asli |
| `xdg-dbus-proxy ... &` | Menjalankan proxy di latar belakang |
| `--filter` | Mengaktifkan mode filtering (tanpa ini, semua pesan diteruskan) |
| `--talk=org.mpris.MediaPlayer2.*` | Hanya mengizinkan TALK ke MPRIS; nama lain tidak terlihat |
| `trap 'kill ...' EXIT` | Memastikan proxy dimatikan saat skrip berakhir |
| `DBUS_SESSION_BUS_ADDRESS=unix:path=${PROXY_SOCKET}` | Mengarahkan helper ke proxy, **bukan** ke bus asli |
| `--bind "$APP_FOLDER"` | Helper perlu akses ke socket proxy |

**Verifikasi:** Jalankan `busctl --address=unix:path=$PROXY_SOCKET list` — hanya nama yang diizinkan (dan nama dasar D-Bus) yang muncul.

### 5.4 Batasan `xdg-dbus-proxy`

| Batasan | Implikasi |
|---|---|
| **Memfilter pesan, bukan isi** | Jika klien diizinkan TALK ke suatu nama, ia bisa memanggil **semua** metode pada nama itu. Filtering per-metode tidak didukung secara langsung. |
| **Memerlukan `.flatpak-info` untuk Portal** | Untuk mengakses Portal, helper harus **berpura-pura** menjadi Flatpak. Ini adalah **workaround**, bukan solusi arsitektural. |
| **Tidak melindungi dari bug di bus itu sendiri** | Jika `dbus-daemon` vulnerable, proxy tidak membantu. |
| **Kompleksitas operasional** | Setiap helper membutuhkan proxy sendiri; lupa menjalankan proxy berarti helper **tidak bisa** berkomunikasi. |

> **Peringatan dari Arch Wiki:** “Running untrusted code is never safe, even in a sandbox, even with Portals.” `xdg-dbus-proxy` **mengurangi** permukaan serangan, tetapi **tidak menghilangkannya**.

---

## 6. Anonimitas Metadata

### 6.1 Mengapa Metadata Penting

Ketika Anda membagikan paket, repositori, atau konfigurasi, Anda membagikan **lebih dari kode**. Anda membagikan:

- **Path pribadi:** `/home/namaanda/...` di skrip, konfigurasi, dan log build.
- **Timestamp:** Kapan Anda membangun, kapan Anda commit, kapan Anda terakhir mengedit.
- **Nama pengguna dan hostname:** Di komentar, log, dan artefak build.
- **Pola build:** Versi pustaka, urutan kompilasi, dan environment yang dapat menjadi **fingerprint**.

**Risiko:** Metadata dapat menghubungkan **artefak anonim** dengan **identitas nyata**. Ini adalah risiko yang sama dengan metadata dokumen (penulis, revisi) atau metadata foto (GPS, kamera).

### 6.2 Praktik Anonimitas Metadata

| Praktik | Alat | Kapan |
|---|---|---|
| Hapus path pribadi | `sed`, `grep -r`, `rg` | Sebelum commit |
| Hapus timestamp dari arsip | `tar --mtime`, `SOURCE_DATE_EPOCH` | Saat membuat tarball |
| Hapus nama pengguna dari commit | `git commit --author="Anon <anon@example.com>"` | Saat kontribusi anonim |
| Hapus hostname dari log | `systemd` `LogExtraFields`, filter log | Saat berbagi log |
| Hapus metadata EXIF dari screenshot | `exiftool -all=` | Sebelum membagikan screenshot |
| Gunakan `SOURCE_DATE_EPOCH` | `export SOURCE_DATE_EPOCH=...` | Saat build reproducible |

### 6.3 Contoh: Membersihkan Repositori dari Path Pribadi

```bash
# Cari path pribadi di seluruh repositori
rg -n '/home/[^/]+' . --hidden --glob '!.git'

# Ganti dengan placeholder
find . -type f \( -name '*.qml' -o -name '*.sh' -o -name '*.md' \) \
    -exec sed -i 's|/home/[^/]\+|/home/user|g' {} +
```

**Penjelasan:** `rg` mencari path absolut yang mengandung `/home/`; `sed` menggantinya dengan `/home/user`. Ini adalah **higiene dasar** yang sering terlupakan.

---

## 7. Build Reproducible dengan `SOURCE_DATE_EPOCH`

### 7.1 Mengapa Reproducibility adalah Fitur Keamanan

Build yang **tidak reproducible** menghasilkan hash yang berbeda setiap kali dibangun, bahkan dari sumber yang sama. Ini berarti:
- Anda **tidak bisa** memverifikasi bahwa paket yang Anda unduh dibangun dari sumber yang Anda lihat.
- Penyerang dapat **menyisipkan kode** saat build tanpa mengubah hash sumber.
- Audit independen **tidak mungkin** karena setiap build unik.

**Build reproducible** menjamin bahwa build yang sama menghasilkan **output yang sama**, sehingga siapa pun dapat membangun ulang dan **membandingkan hash**.

### 7.2 Cara Kerja `SOURCE_DATE_EPOCH`

`SOURCE_DATE_EPOCH` adalah **timestamp Unix** yang dibekukan. Ketika variabel ini di-set, alat build menggunakan nilai ini **alih-alih waktu saat ini** untuk semua timestamp yang tertanam di artefak (mis. `__DATE__`, header arsip, metadata paket).

```bash
# Di PKGBUILD, sebelum build:
export SOURCE_DATE_EPOCH=$(stat -c %Y "$srcdir/$pkgname-$pkgver.tar.gz")
```

**Penjelasan:** `stat -c %Y` mengambil **waktu modifikasi** dari tarball sumber. Ini adalah nilai yang **deterministik**: siapa pun yang memiliki tarball yang sama akan mendapatkan timestamp yang sama.

**Alternatif:** Gunakan timestamp dari commit Git:

```bash
export SOURCE_DATE_EPOCH=$(git -C "$srcdir/$pkgname" log -1 --format=%ct)
```

### 7.3 Verifikasi Reproducibility

```bash
# Build dua kali di lingkungan yang sama
makepkg -f
sha256sum my-quickshell-*.pkg.tar.zst > hash1

makepkg -f
sha256sum my-quickshell-*.pkg.tar.zst > hash2

diff hash1 hash2 && echo "REPRODUCIBLE"
```

**Jika hash berbeda:** Periksa timestamp yang tidak dibekukan, urutan file yang tidak deterministik, atau path yang mengandung direktori build sementara.

### 7.4 Batasan Reproducibility

| Batasan | Implikasi |
|---|---|
| **Bergantung pada alat build** | Tidak semua alat menghormati `SOURCE_DATE_EPOCH`; beberapa membutuhkan patch. |
| **Bergantung pada environment** | Versi pustaka, locale, dan urutan filesystem dapat memengaruhi output. |
| **Tidak menjamin keamanan** | Reproducible build membuktikan **korespondensi sumber-output**, bukan **keamanan sumber**. Sumber yang berbahaya tetap berbahaya meskipun reproducible. |

---

## 8. Analisis Statis QML

### 8.1 `qmllint`: Kekuatan dan Batasan

`qmllint` adalah alat **resmi Qt** untuk analisis statis QML. Ia mendeteksi:
- Kesalahan sintaks.
- Impor yang hilang.
- Properti yang tidak dikenal.
- Signal handler yang salah nama.

**Batasan `qmllint`:**

| Batasan | Implikasi |
|---|---|
| **Tidak melakukan type-checking ekspresi kompleks** | Ekspresi JavaScript yang kompleks tidak diperiksa tipe hasilnya |
| **Tidak melacak tipe return fungsi** | Fungsi yang mengembalikan tipe salah tidak terdeteksi |
| **Properti `var` tidak diperiksa** | `var` adalah **escape hatch** yang melewati semua pemeriksaan |
| **Bergantung pada impor yang ter-resolve** | Jika `qmldir` tidak ditemukan, analyzer tidak bisa memeriksa tipe |

**Kesimpulan:** `qmllint` adalah **pertahanan pertama**, bukan **pertahanan terakhir**. Ia menangkap kesalahan umum, tetapi tidak menangkap **logika berbahaya**.

### 8.2 `qml_static_analyzer`: Alternatif yang Lebih Ketat

`qml_static_analyzer` adalah alat **eksperimental** yang dibuat karena `qmllint` menghasilkan terlalu banyak **false positive**. Ia mendeteksi:

- **Property redefinition** — properti yang sudah didefinisikan Qt didefinisikan ulang.
- **Property type mismatch** — `property int foo: false`.
- **Assignment to unknown property** — `Layout.notExist: true`.
- **Unknown signal handler** — `onStatussChanged` (typo).
- **Unknown C++ member** — `diskManager.nonExisting`.

**Keterbatasan:** Seperti `qmllint`, alat ini **tidak melakukan type-checking ekspresi kompleks** dan **tidak melacak tipe return fungsi**.

### 8.3 [Tambahan] Mengapa Analisis Statis Tidak Cukup untuk Keamanan

Analisis statis QML **tidak dapat** mendeteksi:

| Ancaman | Mengapa Tidak Terdeteksi |
|---|---|
| **Pemanggilan `Process` dengan perintah berbahaya** | `command: ["sh", "-c", "..." ]` adalah sintaks yang valid; analyzer tidak tahu apakah perintah itu berbahaya |
| **Akses berkas via `Image` atau `Loader`** | Path absolut ke berkas sensitif valid secara sintaks |
| **Eksfiltrasi data via jaringan** | `XMLHttpRequest` atau `Process` dengan `curl` valid secara sintaks |
| **Penggunaan `eval` atau `Function`** | JavaScript dinamis valid secara sintaks |

**Kesimpulan:** Analisis statis **mengurangi** kesalahan yang tidak disengaja, tetapi **tidak menggantikan audit manual** untuk kode yang tidak tepercaya.

---

## 9. [Tambahan] Batas Fundamental QML: Mengapa Sandbox Tidak Mungkin

Ini adalah **kebenaran yang harus dipahami** sebelum Anda mengandalkan QML sebagai “aman”:

**QML tidak memiliki model sandbox.** Thread diskusi Qt dari 2011 menyatakan dengan jelas: “there is no way to have any protection” untuk plugin QML yang berjalan di aplikasi C++. QML dapat:
- Membuka path absolut apa pun via `Image`, `Loader`, atau `Process`.
- Mengimpor plugin C++ yang berjalan dengan hak penuh.
- Mengakses jaringan melalui `XMLHttpRequest` atau `Process`.

**Model keamanan Qt adalah “rantai kepercayaan”:**

> “The QML security model is that QML content is a chain of trusted content: the user installs QML ... developers producing QML content should not execute arbitrary downloaded JavaScript, nor instantiate arbitrary downloaded QML elements.”

**Implikasi untuk Quickshell:** Setiap plugin QML yang Anda jalankan **berjalan di proses Quickshell** dengan **hak penuh pengguna**. Ini berarti:
- Plugin dapat membaca `~/.ssh/`.
- Plugin dapat mengirim data ke internet.
- Plugin dapat memodifikasi berkas konfigurasi Anda.

**Artikel tentang Omarchy (distribusi berbasis Quickshell) menyatakan:**

> “when you install a third-party Omarchy plugin, you are executing arbitrary QML/JavaScript inside the long-running Quickshell process, with full access to everything your user account can touch”.

**Kesimpulan:** **Jangan pernah** menjalankan plugin QML dari sumber yang tidak Anda percaya. Tidak ada sandbox QML. Satu-satunya pertahanan adalah **audit kode**.

---

## 10. [Tambahan] Audit Plugin C++: Daftar Periksa Minimum

Jika Anda **harus** menggunakan plugin C++ (mis. dari pihak ketiga), audit dengan daftar periksa ini:

| Pemeriksaan | Mengapa |
|---|---|
| **Apakah plugin memanggil syscall berbahaya?** | `ptrace`, `mount`, `reboot`, `kexec_load` tidak diperlukan untuk shell |
| **Apakah plugin membuka berkas di luar direktori yang diharapkan?** | Akses ke `~/.ssh/`, `~/.gnupg/`, atau `/etc/shadow` adalah red flag |
| **Apakah plugin membuat koneksi jaringan?** | Shell tidak perlu koneksi keluar kecuali untuk fitur tertentu (mis. cuaca) |
| **Apakah plugin menggunakan `system()` atau `popen()`?** | Ini adalah vektor **command injection** |
| **Apakah plugin memvalidasi input dari QML?** | Input QML bisa berisi path traversal atau format string |
| **Apakah plugin dibangun dengan `-fvisibility=hidden`?** | Simbol yang tidak perlu diekspor memperbesar permukaan serangan |
| **Apakah plugin diuji dengan ASan/UBSan?** | Bug memori adalah **backdoor** yang tidak disengaja |

**Aturan:** Jika plugin **tidak memenuhi** salah satu pemeriksaan ini, **jangan gunakan**. Tidak ada kompromi untuk plugin C++.

---

## 11. [Tambahan] Integrasi Semua Lapisan: Daftar Periksa Akhir

Berikut adalah daftar periksa **lengkap** untuk shell dengan profil keamanan tinggi:

```text
□ Threat model ditulis dan diperbarui
□ Setiap Process memiliki clearEnvironment: true
□ Proses pembantu berjalan di bwrap dengan --unshare-all
□ xdg-dbus-proxy digunakan untuk helper yang membutuhkan D-Bus
□ Tidak ada plugin QML/C++ dari sumber yang tidak diaudit
□ Semua plugin C++ lolos daftar periksa audit
□ PKGBUILD menggunakan sha256sums asli (bukan SKIP)
□ SOURCE_DATE_EPOCH di-set untuk build reproducible
□ Unit systemd memiliki hardening (NoNewPrivileges, ProtectSystem, dll.)
□ Skor systemd-analyze security < 5
□ Lockscreen lolos uji kill -9 dan PAM error
□ WlrKeyboardFocus.Exclusive digunakan untuk launcher
□ Tidak ada path pribadi di artefak yang dibagikan
□ qmllint dan qml_static_analyzer bersih
□ Log tidak mengandung kredensial
□ CI menggunakan Action yang di-pin ke SHA
□ CI memiliki izin minimal (contents: read)
```

---

## 12. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Profil keamanan tinggi** | Konteks di mana pengguna menghadapi ancaman targeted, bukan hanya malware oportunistik |
| **`xdg-dbus-proxy`** | Proxy penyaring D-Bus yang menerapkan kebijakan SEE/TALK/OWN |
| **SEE** | Kebijakan D-Bus: klien dapat melihat nama dan memanggil `GetNameOwner` |
| **TALK** | Kebijakan D-Bus: klien dapat memanggil metode dan menerima signal |
| **OWN** | Kebijakan D-Bus: klien dapat meminta nama (`RequestName`) |
| **`.flatpak-info`** | Berkas yang membuat program dianggap sebagai Flatpak oleh Portal |
| **`SOURCE_DATE_EPOCH`** | Timestamp Unix yang dibekukan untuk build reproducible |
| **Reproducible build** | Build yang menghasilkan output identik dari sumber identik |
| **Metadata** | Informasi tentang artefak: path, timestamp, pengguna, hostname |
| **`qml_static_analyzer`** | Alat analisis statis QML alternatif yang lebih ketat dari `qmllint` |
| **Rantai kepercayaan** | Model keamanan Qt: QML content adalah trusted chain |
| **Full trust** | Hak penuh atas sesi pengguna; tidak ada sandbox |

---

## 13. Rekomendasi Visualisasi

### 13.1 Lapisan Pertahanan Shell Profil Tinggi

```text
┌─────────────────────────────────────────────────────────────┐
│  Lapisan 5: Anonimitas Metadata                             │
│  SOURCE_DATE_EPOCH, hapus path pribadi, commit anonim       │
│  ─ Melindungi: identitas dan pola build ─                   │
├─────────────────────────────────────────────────────────────┤
│  Lapisan 4: Rantai Pasok                                    │
│  sha256sums, pin SHA, tanda tangan GPG, CI izin minimal     │
│  ─ Melindungi: integritas artefak ─                         │
├─────────────────────────────────────────────────────────────┤
│  Lapisan 3: Isolasi IPC                                     │
│  xdg-dbus-proxy (SEE/TALK/OWN), D-Bus filter                │
│  ─ Melindungi: kebocoran data via D-Bus ─                   │
├─────────────────────────────────────────────────────────────┤
│  Lapisan 2: Sandbox Proses                                  │
│  bwrap --unshare-all, seccomp, systemd hardening            │
│  ─ Melindungi: akses filesystem dan syscall ─               │
├─────────────────────────────────────────────────────────────┤
│  Lapisan 1: Higiene Kode                                    │
│  clearEnvironment, validasi input, audit plugin C++         │
│  ─ Melindungi: kebocoran environment dan bug memori ─       │
├─────────────────────────────────────────────────────────────┤
│  Lapisan 0: Model Ancaman                                   │
│  Aset, ancaman, mitigasi — ditulis sebelum kode             │
│  ─ Menentukan semua lapisan di atas ─                       │
└─────────────────────────────────────────────────────────────┘
```

### 13.2 Alur Filter D-Bus

```text
Klien (helper) ──► Socket Proxy ──► [xdg-dbus-proxy] ──► Bus Sesi
                                        │
                                        ├─ Pesan ke org.mpris.* → DITERUSKAN
                                        ├─ Pesan ke org.freedesktop.portal.* → DITERUSKAN
                                        ├─ Pesan ke org.freedesktop.secrets → DIBUANG
                                        └─ Broadcast signal dari nama lain → DIBUANG
```

---

## 14. Hubungan dengan Modul Lain

| Topik | Modul Sumber | Hubungan |
|---|---|---|
| Threat model | 3.3, 4.1 | Fondasi semua keputusan keamanan |
| `bwrap` | 4.1 | Sandbox proses; `xdg-dbus-proxy` melengkapinya |
| `clearEnvironment` | 1.2, 4.1 | Higiene dasar yang wajib |
| Lockscreen fail-safe | 4.2 | Menerapkan prinsip fail-safe |
| PKGBUILD dan checksum | 5.3 | Rantai pasok |
| CI dan pin SHA | 5.3 | Rantai pasok |
| `qmllint` | 5.2, 5.3 | Analisis statis |
| Plugin C++ | 5.1 | Audit plugin |
| Capstone | Capstone | Semua lapisan diintegrasikan |

---

## 15. Sumber Referensi

- [xdg-dbus-proxy man page](https://man.archlinux.org/man/xdg-dbus-proxy.1.en) — referensi kebijakan SEE/TALK/OWN.
- [Arch Wiki: Bubblewrap](https://wiki.archlinux.org/title/Bubblewrap) — integrasi `xdg-dbus-proxy` dengan `bwrap`.
- [Arch Package Guidelines](https://wiki.archlinux.org/title/Arch_package_guidelines) — `SOURCE_DATE_EPOCH`.
- [Reproducible Builds: SOURCE_DATE_EPOCH](https://reproducible-builds.org/docs/source-date-epoch/) — spesifikasi.
- [qml_static_analyzer](https://github.com/qarmin/qml_static_analyzer) — alat analisis statis QML.
- [Qt QML Security](https://www.slac.stanford.edu/) — model rantai kepercayaan.
- [Omarchy Plugin Vetting](https://www.daveknowstech.com/2026/09/03/vetting-omarchy-plugins-before-they-run-on-your-machine/) — model ancaman plugin Quickshell.
- [Qt-qml: QML and Sandboxing](https://lists.qt-project.org/pipermail/qt-qml/2011-July/002821.html) — batas fundamental QML.

---

## 16. Tips dan Praktik Terbaik

1. **Tulis threat model sebelum menulis kode.** Ini bukan formalitas; ini adalah **kompas**.
2. **Gunakan `xdg-dbus-proxy` untuk setiap helper** yang membutuhkan D-Bus. Jangan biarkan helper mengakses bus penuh.
3. **Selalu set `SOURCE_DATE_EPOCH`** di PKGBUILD. Verifikasi dengan build ganda.
4. **Jangan pernah menjalankan plugin QML dari internet tanpa audit.** Tidak ada sandbox QML.
5. **Audit plugin C++ dengan daftar periksa.** Jika ragu, jangan gunakan.
6. **Bersihkan path pribadi dari repositori** sebelum commit.
7. **Gunakan `qml_static_analyzer` sebagai pelengkap `qmllint`**, bukan pengganti.
8. **Dokumentasikan setiap lapisan** di README. Keamanan yang tidak terdokumentasi sulit diaudit.
9. **Uji dengan asumsi terburuk.** Jika plugin berbahaya, apa yang bisa dilakukannya? Mitigasi apa yang dimiliki?
10. **Perbarui model ancaman** saat fitur baru ditambahkan.

---

## 17. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menganggap QML aman | Plugin berbahaya membaca `~/.ssh/` | Audit kode; jangan jalankan plugin tak tepercaya |
| Menganggap `bwrap` cukup | Helper masih bisa mengakses D-Bus | Tambahkan `xdg-dbus-proxy` |
| Lupa `--filter` pada `xdg-dbus-proxy` | Semua pesan diteruskan | Selalu gunakan `--filter` |
| Tidak set `SOURCE_DATE_EPOCH` | Hash berbeda setiap build | Set dan verifikasi |
| Mengandalkan `qmllint` untuk keamanan | Logika berbahaya lolos | Audit manual; `qmllint` hanya sintaks |
| Membagikan log dengan path pribadi | Kebocoran identitas | Bersihkan log sebelum dibagikan |
| Plugin C++ tanpa ASan | Bug memori tidak terdeteksi | Uji dengan `-fsanitize=address,undefined` |

---

> **Motivasi:** Keamanan bukan tentang membuat sistem yang tidak dapat ditembus — itu tidak ada. Keamanan adalah tentang membuat **setiap pintu terkunci, setiap jejak terhapus, dan setiap lapisan diperiksa**. Dalam dunia di mana Anda adalah target, **paranoia adalah profesionalisme**.

---

# Catatan Revisi (Pasca-Audit) — Diperluas dan Diperdalam

> **Audit singkat sebelum materi:** Kurikulum asli menyajikan tabel temuan audit dan perbaikan, plus daftar butir yang perlu diverifikasi. Yang **belum ada**: (a) **metodologi audit** — bagaimana temuan ditemukan, bukan hanya apa temuannya; (b) **penjelasan mendalam per temuan** — mengapa itu error, apa bentuk benarnya, dan bagaimana memverifikasi; (c) **prosedur verifikasi versi** — langkah konkret untuk mengecek setiap butir yang ditandai; (d) **proses pemeliharaan** — bagaimana kurikulum ini tetap akurat saat Quickshell berevolusi; (e) **template audit** yang dapat digunakan untuk dokumentasi lain. Materi di bawah mengisi celah tersebut. Setiap penambahan ditandai **[Tambahan]** .

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Catatan revisi adalah **jejak epistemik** dari kurikulum: ia mencatat apa yang **salah**, **mengapa** salah, dan **bagaimana** diperbaiki. Ia bukan sekadar lampiran; ia adalah **bukti bahwa kurikulum ini diaudit**, bukan ditulis sekali lalu ditinggalkan.

**Mengapa penting:** Dokumentasi teknis yang tidak memiliki catatan revisi adalah **dokumentasi yang tidak dapat dipercaya**. Tanpa catatan revisi, pembaca tidak tahu apakah suatu klaim sudah diverifikasi, masih berupa asumsi, atau sudah usang. Catatan revisi memberi **transparansi** tentang tingkat keyakinan setiap bagian.

**Peran dalam kurikulum:** Ini adalah **penutup yang jujur**. Kurikulum yang baik tidak mengklaim sempurna; ia mengakui keterbatasannya dan menunjukkan **cara memperbaikinya**. Catatan revisi adalah **kontrak kejujuran** antara penulis dan pembaca.

---

## 2. Konsep Kunci & Filosofi Mendalam

**Filosofi “dokumentasi sebagai artefak hidup.”** Dokumentasi teknis bukan monumen; ia adalah **organisme** yang berevolusi bersama kode yang dijelaskannya. Quickshell berkembang cepat — API berubah, modul ditambahkan, nama tipe diganti. Dokumentasi yang tidak diperbarui menjadi **liabilitas**: ia menyesatkan pembaca dan merusak kepercayaan.

**Prinsip “kesalahan yang terdokumentasi lebih baik daripada kesalahan yang tersembunyi.”** Setiap temuan audit adalah **kesempatan belajar**. Dengan mendokumentasikan kesalahan, penulis mengakui bahwa ia manusia, dan pembaca belajar **apa yang harus diwaspadai**. Ini sejalan dengan budaya open-source: **bug report bukan aib, tetapi kontribusi**.

**Prinsip “verifikasi menggantikan asumsi.”** Setiap klaim tentang API Quickshell harus **diverifikasi terhadap versi yang terpasang**, bukan terhadap ingatan atau dokumentasi terbaru. Quickshell memiliki **versi yang berbeda** di berbagai distribusi; API yang ada di `master` mungkin belum ada di rilis stabil, dan sebaliknya. Catatan revisi menandai butir-butir yang **masih berupa asumsi**.

**Model mental: catatan revisi sebagai “log buku laboratorium.”** Seorang ilmuwan mencatat bukan hanya hasil yang berhasil, tetapi juga **kesalahan, hipotesis yang salah, dan prosedur yang gagal**. Catatan ini memungkinkan **replikasi** dan **audit**. Catatan revisi kurikulum adalah hal yang sama: log perjalanan intelektual dari versi yang salah menuju versi yang lebih benar.

---

## 3. Struktur Pembelajaran Internal

1. Metodologi audit: bagaimana temuan ditemukan
2. Klasifikasi temuan: kesalahan faktual, kesalahan konseptual, kesalahan sintaks, kelalaian
3. Analisis mendalam per temuan (22 butir)
4. Prosedur verifikasi versi: 7 butir yang ditandai
5. **[Tambahan]** Template audit untuk dokumentasi lain
6. **[Tambahan]** Proses pemeliharaan: bagaimana menjaga kurikulum tetap akurat
7. **[Tambahan]** Etika dokumentasi: mengakui ketidakpastian
8. **[Tambahan]** Pelajaran dari audit: pola kesalahan yang berulang

---

## 4. Metodologi Audit

**[Tambahan]** Sebelum membahas temuan, penting untuk memahami **bagaimana** temuan ditemukan. Audit kurikulum ini menggunakan **lima lapisan pemeriksaan**:

| Lapisan | Metode | Contoh Temuan |
|---|---|---|
| **1. Verifikasi sintaks** | Setiap contoh kode dijalankan di lingkungan nyata | `AnchorLayout` tidak ada → diganti `anchors`/`Layouts` |
| **2. Verifikasi API** | Setiap tipe, properti, dan signal dicek di dokumentasi versi terpasang | `PamContext` sinyal salah → ditulis ulang |
| **3. Verifikasi konsep** | Setiap penjelasan konseptual diuji terhadap perilaku aktual | “Model keamanan” menyesatkan → diperbaiki |
| **4. Verifikasi kelengkapan** | Setiap topik yang disebut di Capstone dicek apakah diajarkan | `IpcHandler` hanya di Capstone → ditambahkan di 5.1 |
| **5. Verifikasi keamanan** | Setiap contoh yang menyentuh keamanan diaudit ulang | `bwrap` tidak berjalan → ditulis ulang |

**Pelajaran metodologis:** Audit yang baik **tidak berhenti pada “apakah kode berjalan”**. Kode bisa berjalan tetapi **mengajarkan pola yang salah**. Audit harus memeriksa **kebenaran faktual**, **kebenaran konseptual**, dan **kelengkapan pedagogis**.

---

## 5. Klasifikasi Temuan

**[Tambahan]** Temuan audit dapat diklasifikasikan menjadi empat kategori. Memahami kategori membantu memprioritaskan perbaikan:

| Kategori | Definisi | Tingkat Keparahan | Contoh |
|---|---|---|---|
| **Kesalahan faktual** | Klaim tentang API/perilaku yang salah | Tinggi — pembaca akan gagal | `Quickshell.Sway` tidak ada |
| **Kesalahan konseptual** | Model mental yang menyesatkan | Tinggi — pembaca akan salah paham | “Model keamanan QML” |
| **Kesalahan sintaks** | Kode yang tidak dapat dikompilasi/dijalankan | Sedang — pembaca akan error | `AnchorLayout` tidak ada |
| **Kelalaian** | Topik yang hilang atau tidak lengkap | Sedang — pembaca akan bingung | `IpcHandler` tidak diajarkan |

**Prioritas perbaikan:** Kesalahan faktual dan konseptual **harus** diperbaiki segera; kesalahan sintaks dan kelalaian **sebaiknya** diperbaiki sebelum rilis berikutnya.

---

## 6. Analisis Mendalam per Temuan

### 6.1 `PamContext` Memakai Sinyal yang Tidak Ada

**Temuan:** Versi awal menggunakan sinyal `start` pada `PamContext`, yang tidak ada.

**Mengapa salah:** `PamContext` di Quickshell memiliki alur yang spesifik: `start()` adalah **metode**, bukan sinyal; pesan PAM dikirim melalui sinyal `pamMessage`; respons dikirim melalui `respond()`; hasil akhir dikirim melalui `completed(PamResult)`.

**Bentuk benar:**

```qml
PamContext {
    onPamMessage: (msg) => { respond(password); }
    onCompleted: (result) => {
        if (result === PamResult.Success) { /* buka kunci */ }
    }
}
```

**Cara memverifikasi:** Buka dokumentasi `PamContext` untuk versi Quickshell Anda; periksa daftar sinyal dan metode. Jika `pamMessage` tidak ada, versi Anda mungkin menggunakan API yang berbeda — periksa changelog.

**Pelajaran:** **Jangan menebak nama sinyal.** Setiap sinyal harus diverifikasi di dokumentasi atau kode sumber.

---

### 6.2 `WlSessionLock` Tidak Ada

**Temuan:** Versi awal tidak menyebut `WlSessionLock` sama sekali, padahal lockscreen aman membutuhkannya.

**Mengapa salah:** Tanpa `WlSessionLock`, lockscreen hanya **UI di atas jendela lain** — dapat ditembus dengan `kill` atau compositor restart. `WlSessionLock` adalah protokol Wayland yang membuat **compositor** menahan lock, bukan aplikasi.

**Bentuk benar:** `WlSessionLock` + `WlSessionLockSurface` + PAM, dengan prinsip fail-safe.

**Cara memverifikasi:** Periksa apakah compositor Anda mendukung `ext-session-lock-v1` (`wayland-info | grep session-lock`). Jika tidak, lockscreen aman **tidak mungkin** dengan compositor tersebut.

**Pelajaran:** **Keamanan bukan fitur tambahan.** Lockscreen yang tidak menggunakan `WlSessionLock` adalah **lockscreen palsu** — ia terlihat aman tetapi tidak.

---

### 6.3 `PwObjectTracker` dan Skala Volume

**Temuan:** Versi awal menggunakan `PwObjectTracker` yang tidak ada, dan skala volume salah (0–100 vs 0–1).

**Mengapa salah:** Quickshell menggunakan **tracker** untuk mengelola siklus hidup objek PipeWire; skala volume PipeWire adalah **0.0–1.0**, bukan 0–100. Menggunakan skala yang salah menyebabkan volume selalu 100× terlalu besar atau terlalu kecil.

**Bentuk benar:**

```qml
readonly property real volume: sink?.audio?.volume ?? 0.0   // 0.0–1.0
function setVolume(v: real): void {
    sink.audio.volume = Math.max(0.0, Math.min(1.0, v));
}
```

**Cara memverifikasi:** Periksa dokumentasi `Pipewire` untuk properti `volume`; periksa apakah ada `PwObjectTracker` di versi Anda. Jika tidak, gunakan pola yang direkomendasikan dokumentasi.

**Pelajaran:** **Skala numerik adalah sumber bug yang umum.** Selalu verifikasi apakah API menggunakan 0–1, 0–100, atau skala lain.

---

### 6.4 `track.title` Salah

**Temuan:** Versi awal menggunakan `track.title`, yang tidak ada di MPRIS Quickshell.

**Mengapa salah:** Properti yang benar adalah `trackTitle` (camelCase), bukan `title`. Ini adalah **kesalahan penamaan** yang menyebabkan binding gagal.

**Bentuk benar:**

```qml
Text { text: Mpris.players.values[0]?.trackTitle ?? "—" }
```

**Cara memverifikasi:** Periksa dokumentasi `Mpris` untuk daftar properti. Jika `trackTitle` tidak ada, periksa apakah versi Anda menggunakan nama lain.

**Pelajaran:** **Nama properti adalah kontrak.** Salah satu huruf salah, binding gagal tanpa error yang jelas.

---

### 6.5 `UPower.percentage` Dikalikan 100

**Temuan:** Versi awal mengasumsikan `UPower.percentage` adalah 0–100, padahal bisa 0–1 (atau sebaliknya, tergantung versi).

**Mengapa salah:** Skala `percentage` berbeda antar versi dan antar binding. Mengasumsikan skala yang salah menghasilkan tampilan “10000%” atau “0.5%”.

**Bentuk benar:**

```qml
Text { text: Math.round(UPower.displayDevice.percentage * 100) + "%" }
```

**Cara memverifikasi:** Cetak nilai mentah (`console.log(UPower.displayDevice.percentage)`) dan periksa skalanya. Jika nilainya 0.5, kalikan 100; jika 50, jangan.

**Pelajaran:** **Jangan mengasumsikan skala.** Selalu verifikasi dengan mencetak nilai mentah.

---

### 6.6 `Quickshell.Sway` Tidak Ada

**Temuan:** Versi awal menyebut `Quickshell.Sway`, yang tidak ada.

**Mengapa salah:** Quickshell menyediakan **`Quickshell.I3`** untuk i3/Sway IPC. Tidak ada modul `Quickshell.Sway` terpisah.

**Bentuk benar:**

```qml
import Quickshell.I3
I3 { /* ... */ }
```

**Cara memverifikasi:** Periksa daftar modul di dokumentasi Quickshell. Jika `Sway` tidak ada, gunakan `I3`.

**Pelajaran:** **Nama modul adalah fakta, bukan asumsi.** Verifikasi di dokumentasi.

---

### 6.7 `environment` Tidak Membersihkan Lingkungan

**Temuan:** Versi awal menggunakan `environment` tanpa membersihkan variabel sensitif.

**Mengapa salah:** `environment` **menambahkan** variabel, tetapi **tidak menghapus** variabel yang sudah ada. Untuk membersihkan, gunakan `clearEnvironment: true`.

**Bentuk benar:**

```qml
Process {
    command: ["curl", "..."]
    clearEnvironment: true
}
```

**Cara memverifikasi:** Jalankan proses dan periksa `/proc/<pid>/environ`; pastikan tidak ada variabel sensitif.

**Pelajaran:** **“Membersihkan” bukan “menambahkan.”** `clearEnvironment` adalah satu-satunya cara yang benar.

---

### 6.8 Contoh `bwrap` Tidak Berjalan

**Temuan:** Contoh `bwrap` di versi awal tidak berjalan karena masalah pewarisan sandbox dan D-Bus.

**Mengapa salah:** `bwrap` dengan `--unshare-all` memisahkan namespace, termasuk **D-Bus**. Jika helper membutuhkan D-Bus, ia tidak bisa mengaksesnya. Selain itu, contoh awal tidak menyertakan `--die-with-parent`, sehingga helper bisa menjadi zombie.

**Bentuk benar:** `bwrap --unshare-all --share-net --die-with-parent ...` + `xdg-dbus-proxy` jika helper membutuhkan D-Bus.

**Cara memverifikasi:** Jalankan helper dan periksa `ps aux`; pastikan namespace terpisah dan tidak ada zombie.

**Pelajaran:** **Sandbox adalah sistem, bukan flag.** Setiap flag memiliki konsekuensi; `--unshare-all` memutus D-Bus, yang mungkin tidak Anda inginkan.

---

### 6.9 “Model Keamanan” Menyesatkan

**Temuan:** Versi awal menyebut “model keamanan QML” seolah QML memiliki sandbox.

**Mengapa salah:** QML **tidak memiliki sandbox**. Konfigurasi QML adalah **kode berhak penuh**. Menyebutnya “model keamanan” menyesatkan pembaca dan membuat mereka mengira plugin QML aman.

**Bentuk benar:** Modul 4.1 menegaskan: “konfigurasi QML adalah kode berhak penuh; kunci instance bukan keamanan.”

**Cara memverifikasi:** Baca diskusi Qt tentang sandbox QML; tidak ada mekanisme sandbox.

**Pelajaran:** **Jangan menciptakan keamanan palsu.** Jika tidak ada sandbox, katakan tidak ada.

---

### 6.10 `// layer: 'top'` Salah

**Temuan:** Versi awal menggunakan `// layer: 'top'` sebagai komentar, bukan properti.

**Mengapa salah:** Layer di Quickshell didefinisikan melalui `WlrLayershell.layer: WlrLayer.Top`, bukan komentar. Komentar tidak memiliki efek.

**Bentuk benar:**

```qml
WlrLayershell.layer: WlrLayer.Top
WlrLayershell.exclusionMode: ExclusionMode.Ignore
```

**Cara memverifikasi:** Periksa dokumentasi `WlrLayershell` untuk properti `layer` dan `exclusionMode`.

**Pelajaran:** **Komentar bukan kode.** Jika Anda ingin efek, tulis properti.

---

### 6.11 `AnchorLayout` Tidak Ada

**Temuan:** Versi awal menggunakan `AnchorLayout`, yang tidak ada di QML.

**Mengapa salah:** QML menggunakan `anchors` (untuk positioning) atau `QtQuick.Layouts` (untuk layout). Tidak ada `AnchorLayout`.

**Bentuk benar:**

```qml
// Anchors:
Rectangle {
    anchors.centerIn: parent
}

// Layouts:
RowLayout {
    Layout.fillWidth: true
}
```

**Cara memverifikasi:** Periksa dokumentasi Qt Quick; tidak ada `AnchorLayout`.

**Pelajaran:** **Jangan mengarang tipe.** Jika tidak ada di dokumentasi, tidak ada.

---

### 6.12 `MultiEffect` dengan Sumber Melingkar

**Temuan:** Versi awal menggunakan `MultiEffect` dengan sumber melingkar (circular source), yang menyebabkan binding loop.

**Mengapa salah:** `MultiEffect` yang menggunakan dirinya sendiri sebagai sumber menciptakan **siklus dependensi**, yang menyebabkan evaluasi tak berujung.

**Bentuk benar:** Gunakan `layer.enabled` pada item sumber, bukan `MultiEffect` yang merujuk ke dirinya sendiri.

**Cara memverifikasi:** Periksa log Quickshell untuk “binding loop”; jika ada, perbaiki dependensi.

**Pelajaran:** **Siklus dependensi adalah bug, bukan fitur.** Setiap binding harus memiliki arah yang jelas.

---

### 6.13 Contoh Pertama Tidak Bisa Dijalankan

**Temuan:** Contoh pertama di versi awal tidak bisa dijalankan karena menggunakan tipe yang tidak ada di konteks awal.

**Mengapa salah:** Contoh pertama harus **dapat dijalankan** oleh pembaca yang baru memulai. Menggunakan `FloatingWindow` dan `quickshell -p` memastikan contoh berjalan.

**Bentuk benar:**

```qml
import Quickshell
FloatingWindow {
    Text { text: "Halo, Quickshell!" }
}
```

```bash
quickshell -p
```

**Cara memverifikasi:** Jalankan contoh di lingkungan bersih; pastikan tidak ada error.

**Pelajaran:** **Contoh pertama adalah janji.** Jika contoh pertama gagal, pembaca akan berhenti.

---

### 6.14 `Connections` dan `onValueChanged`

**Temuan:** Versi awal menggunakan `onValueChanged` di `Connections`, yang salah.

**Mengapa salah:** Di `Connections`, signal handler harus berupa **fungsi** dengan nama `onX`, bukan properti. Sintaks yang benar adalah `function onValueChanged() { }`.

**Bentuk benar:**

```qml
Connections {
    target: AudioService
    function onVolumeChanged() { /* ... */ }
}
```

**Cara memverifikasi:** Periksa dokumentasi `Connections` untuk sintaks signal handler.

**Pelajaran:** **Sintaks signal handler berbeda di `Connections`.** Gunakan `function onX()`.

---

### 6.15 Polling `date` Tiap Detik

**Temuan:** Versi awal menggunakan `Process` dengan `date` setiap detik untuk jam.

**Mengapa salah:** Polling setiap detik adalah **pemborosan CPU** dan **tidak akurat**. `SystemClock` adalah modul reaktif yang memperbarui secara otomatis.

**Bentuk benar:**

```qml
import Quickshell
SystemClock {
    id: clock
    precision: SystemClock.Seconds
}
Text { text: clock.date.toLocaleTimeString() }
```

**Cara memverifikasi:** Bandingkan `perf stat` dengan polling vs `SystemClock`; `SystemClock` jauh lebih rendah.

**Pelajaran:** **Reaktif lebih baik daripada polling.** Gunakan modul yang sudah ada.

---

### 6.16 Plugin C++ Ditulis Seolah API Khusus

**Temuan:** Versi awal menulis plugin C++ seolah-olah Quickshell memiliki API plugin khusus, padahal mekanismenya adalah **modul QML Qt standar**.

**Mengapa salah:** Quickshell tidak memiliki API plugin khusus; ia menggunakan `qt_add_qml_module` standar. Menulis seolah-olah ada API khusus menyesatkan pembaca.

**Bentuk benar:** Modul 5.1 menggunakan `qt_add_qml_module` dengan `QML_ELEMENT`, dan mencatat bahwa mekanisme pemuatan pastinya perlu diverifikasi di `HACKING.md`.

**Cara memverifikasi:** Baca `HACKING.md` dan dokumentasi Qt untuk `qt_add_qml_module`.

**Pelajaran:** **Jangan menciptakan API yang tidak ada.** Gunakan mekanisme standar.

---

### 6.17 Flake Tanpa `nixpkgs`, `SKIP`, Action Tanpa Pin

**Temuan:** Versi awal memiliki tiga masalah: flake tanpa input `nixpkgs`, `sha256sums=('SKIP')`, dan Action tanpa pin SHA.

**Mengapa salah:**

- Flake tanpa `nixpkgs` tidak dapat di-build.
- `SKIP` meniadakan auditabilitas.
- Action tanpa pin SHA rentan terhadap supply chain attack.

**Bentuk benar:** Flake dengan `inputs.nixpkgs`, `sha256sums` asli, Action di-pin ke SHA.

**Cara memverifikasi:** `nix flake check`; `updpkgsums`; `grep "uses:" .github/workflows/`.

**Pelajaran:** **Reproducibility dan keamanan rantai pasok adalah fondasi, bukan tambahan.**

---

### 6.18 `semgrep` untuk QML

**Temuan:** Versi awal menyarankan `semgrep` untuk analisis QML tanpa catatan batasan.

**Mengapa salah:** `semgrep` tidak mendukung QML secara resmi; menggunakannya memerlukan **pola teks generik**, yang kurang akurat.

**Bentuk benar:** Catatan batasan: “QML belum menjadi bahasa yang didukung resmi; gunakan mode generik dengan hati-hati.”

**Cara memverifikasi:** Periksa daftar bahasa yang didukung `semgrep`.

**Pelajaran:** **Jangan merekomendasikan alat di luar kemampuannya.**

---

### 6.19 Sumber Pihak Ketiga dan Tautan Terkunci Versi

**Temuan:** Versi awal menggunakan sumber pihak ketiga dan tautan yang terkunci ke versi tertentu.

**Mengapa salah:** Sumber pihak ketiga tidak otoritatif; tautan terkunci versi cepat usang.

**Bentuk benar:** Sumber primer (dokumentasi resmi, kode sumber) dan tautan tanpa versi.

**Cara memverifikasi:** Periksa apakah tautan mengarah ke dokumentasi resmi.

**Pelajaran:** **Sumber primer adalah fondasi.** Sumber sekunder hanya untuk orientasi.

---

### 6.20 Topik Hilang

**Temuan:** Versi awal tidak mencakup `Variants`, `IpcHandler`, `GlobalShortcut`, fokus keyboard, notifikasi, tray, launcher, persistensi, debugging, autostart, `WlSessionLock`, greetd, hardening, dan uji asap.

**Mengapa salah:** Topik-topik ini **wajib** untuk Capstone. Tanpa mereka, pembaca tidak dapat menyelesaikan Capstone.

**Bentuk benar:** Topik-topik ini ditambahkan ke modul yang sesuai.

**Cara memverifikasi:** Petakan setiap persyaratan Capstone ke modul yang mengajarkannya.

**Pelajaran:** **Kelengkapan adalah syarat, bukan bonus.** Setiap persyaratan harus memiliki modul.

---

### 6.21 Non-IT, Latihan, dan Penguasaan

**Temuan:** Versi awal tidak memiliki Fase −1, analogi, glosarium, latihan, atau capstone dengan rubrik.

**Mengapa salah:** Kurikulum tanpa fondasi untuk non-IT akan kehilangan pembaca di modul pertama.

**Bentuk benar:** Fase −1, analogi, glosarium, latihan, dan capstone dengan rubrik ditambahkan.

**Cara memverifikasi:** Uji kurikulum dengan pembaca non-IT; pastikan mereka dapat mengikuti.

**Pelajaran:** **Aksesibilitas adalah fitur, bukan kompromi.**

---

### 6.22 Tautan Judul Fase

**Temuan:** Format `[Fase ...][n]` dipertahankan, tetapi `[0]` dan `[-1]` tidak terdefinisi.

**Mengapa salah:** Tautan yang tidak terdefinisi menyebabkan navigasi rusak.

**Bentuk benar:** `[0]` mengarah ke `bagian-1`; `[-1]` untuk Fase −1 mengarah ke `bagian-0`.

**Cara memverifikasi:** Klik setiap tautan; pastikan mengarah ke bagian yang benar.

**Pelajaran:** **Navigasi adalah bagian dari dokumentasi.** Tautan yang rusak merusak pengalaman.

---

## 7. Prosedur Verifikasi Versi: 7 Butir yang Ditandai

Berikut adalah **prosedur konkret** untuk memverifikasi setiap butir yang masih berupa asumsi. Setiap prosedur mencakup: **apa yang diperiksa**, **bagaimana memeriksa**, dan **apa yang dilakukan jika berbeda**.

### 7.1 Skala Volume PipeWire

**Yang diperiksa:** Apakah `sink.audio.volume` menggunakan skala 0.0–1.0 atau 0–100.

**Cara memeriksa:**

```qml
Component.onCompleted: console.log("Volume mentah:", sink?.audio?.volume)
```

**Jika berbeda:** Jika nilainya 50 untuk volume 50%, gunakan skala 0–100 dan sesuaikan `setVolume`.

### 7.2 Persentase UPower

**Yang diperiksa:** Apakah `UPower.displayDevice.percentage` adalah 0.0–1.0 atau 0–100.

**Cara memeriksa:**

```qml
Component.onCompleted: console.log("Baterai mentah:", UPower.displayDevice.percentage)
```

**Jika berbeda:** Sesuaikan pengali (`* 100` atau tidak).

### 7.3 Nama Modul Bluetooth

**Yang diperiksa:** Apakah modul bernama `Quickshell.Bluetooth` dan tipe utamanya.

**Cara memeriksa:** Buka dokumentasi Quickshell versi Anda; cari “Bluetooth” di daftar tipe.

**Jika berbeda:** Gunakan nama yang benar; jika tidak ada, gunakan `Process` + `bluetoothctl`.

### 7.4 Impor `qs.` dan Singleton Tanpa `qmldir`

**Yang diperiksa:** Apakah impor seperti `import qs.services` berfungsi tanpa `qmldir`.

**Cara memeriksa:** Coba impor di shell Anda; periksa apakah ada error “module not found”.

**Jika berbeda:** Tambahkan `qmldir` atau gunakan jalur impor eksplisit.

### 7.5 Mekanisme Pemuatan Plugin C++

**Yang diperiksa:** Apakah plugin C++ dimuat melalui `qt_add_qml_module` dan jalur impor QML.

**Cara memeriksa:** Baca `HACKING.md` dan dokumentasi Qt; coba build plugin sederhana dan impor di QML.

**Jika berbeda:** Ikuti mekanisme yang didokumentasikan; jangan mengarang.

### 7.6 Nama Sinyal Greetd

**Yang diperiksa:** Apakah sinyal Greetd bernama `onReady`, `onResponse`, atau lainnya.

**Cara memeriksa:** Buka dokumentasi `Quickshell.Services.Greetd`; periksa daftar sinyal.

**Jika berbeda:** Gunakan nama yang benar; jika tidak ada, gunakan `Process` + `greetd` IPC.

### 7.7 Properti `NotificationServer`

**Yang diperiksa:** Apakah `NotificationServer` memiliki properti seperti `notifications`, `trackedNotifications`, atau lainnya.

**Cara memeriksa:** Buka dokumentasi `NotificationServer`; periksa daftar properti.

**Jika berbeda:** Gunakan properti yang benar; jika tidak ada, gunakan D-Bus langsung.

### 7.8 Opsi Verbositas `-v`

**Yang diperiksa:** Apakah `quickshell -v` meningkatkan verbositas atau menampilkan versi.

**Cara memeriksa:** Jalankan `quickshell --help`; periksa opsi.

**Jika berbeda:** Gunakan opsi yang benar; jika tidak ada, gunakan `journalctl` untuk log.

---

## 8. [Tambahan] Template Audit untuk Dokumentasi Lain

Berikut adalah template yang dapat digunakan untuk mengaudit dokumentasi teknis apa pun:

```markdown
# Audit Dokumentasi: [Nama Proyek]

## Metadata
- Versi proyek: [versi]
- Tanggal audit: [tanggal]
- Auditor: [nama]

## Ringkasan
- Total temuan: [n]
- Kesalahan faktual: [n]
- Kesalahan konseptual: [n]
- Kesalahan sintaks: [n]
- Kelalaian: [n]

## Temuan
| # | Kategori | Lokasi | Deskripsi | Perbaikan | Status |
|---|---|---|---|---|---|
| 1 | Faktual | Modul X | ... | ... | Diperbaiki |
| 2 | Konseptual | Modul Y | ... | ... | Diperbaiki |

## Butir yang Perlu Verifikasi
| # | Butir | Cara Verifikasi | Status |
|---|---|---|---|
| 1 | ... | ... | Belum |

## Pelajaran
- [Pola kesalahan yang berulang]
- [Rekomendasi untuk audit berikutnya]
```

---

## 9. [Tambahan] Proses Pemeliharaan

Kurikulum ini adalah **artefak hidup**. Berikut adalah proses yang direkomendasikan untuk menjaganya tetap akurat:

```text
┌─────────────────────────────────────────────────────────────┐
│  1. Pantau rilis Quickshell                                 │
│     - Ikuti changelog di repositori                         │
│     - Perhatikan breaking changes                           │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  2. Verifikasi butir yang ditandai                          │
│     - Jalankan prosedur di bagian 7                         │
│     - Perbarui jika berbeda                                 │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  3. Audit ulang contoh kode                                 │
│     - Jalankan setiap contoh                                │
│     - Perbaiki yang gagal                                   │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  4. Perbarui catatan revisi                                 │
│     - Tambahkan temuan baru                                 │
│     - Tandai yang sudah diverifikasi                        │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  5. Rilis versi baru kurikulum                              │
│     - Catat tanggal dan versi Quickshell yang diverifikasi  │
└─────────────────────────────────────────────────────────────┘
```

**Frekuensi:** Audit ringan setiap rilis Quickshell; audit penuh setiap perubahan mayor.

---

## 10. [Tambahan] Etika Dokumentasi: Mengakui Ketidakpastian

Dokumentasi yang baik **mengakui ketidakpastian**. Berikut adalah frasa yang dapat digunakan:

| Tingkat Keyakinan | Frasa | Contoh |
|---|---|---|
| **Terverifikasi** | “Berdasarkan dokumentasi versi X” | “Menurut dokumentasi Quickshell 0.2, `PamContext` memiliki sinyal `pamMessage`.” |
| **Keyakinan tinggi** | “Setahu saya” | “Setahu saya, mekanismenya adalah `qt_add_qml_module`.” |
| **Perlu verifikasi** | “Verifikasi di versi Anda” | “Skala volume PipeWire perlu diverifikasi di versi Anda.” |
| **Tidak pasti** | “Saya tidak yakin” | “Saya tidak yakin apakah `-v` meningkatkan verbositas atau menampilkan versi.” |

**Prinsip:** **Lebih baik mengakui ketidakpastian daripada menyesatkan.** Pembaca akan menghargai kejujuran.

---

## 11. [Tambahan] Pelajaran dari Audit: Pola Kesalahan Berulang

Audit ini mengungkap **pola kesalahan** yang berulang. Mengenali pola membantu mencegahnya di masa depan:

| Pola | Contoh | Pencegahan |
|---|---|---|
| **Mengarang API** | `AnchorLayout`, `Quickshell.Sway` | Verifikasi setiap tipe di dokumentasi |
| **Mengarang sinyal** | `PamContext.start` | Periksa daftar sinyal |
| **Mengasumsikan skala** | `UPower.percentage`, volume PipeWire | Cetak nilai mentah |
| **Mengasumsikan keamanan** | “Model keamanan QML” | Baca diskusi keamanan Qt |
| **Mengabaikan konsekuensi sandbox** | `bwrap` tanpa D-Bus | Uji sandbox secara menyeluruh |
| **Menggunakan sintaks yang salah** | `onValueChanged` di `Connections` | Periksa dokumentasi sintaks |
| **Melewatkan topik wajib** | `IpcHandler` | Petakan persyaratan ke modul |
| **Mengandalkan sumber sekunder** | Blog, ringkasan otomatis | Verifikasi dengan sumber primer |

**Pelajaran umum:** **Sebagian besar kesalahan berasal dari asumsi yang tidak diverifikasi.** Verifikasi adalah obatnya.

---

## 12. Terminologi Esensial

| Istilah | Definisi |
|---|---|
| **Audit** | Pemeriksaan sistematis terhadap dokumentasi untuk menemukan kesalahan dan kelalaian |
| **Temuan** | Satu kesalahan atau kelalaian yang ditemukan dalam audit |
| **Kesalahan faktual** | Klaim yang salah tentang API atau perilaku |
| **Kesalahan konseptual** | Model mental yang menyesatkan |
| **Kesalahan sintaks** | Kode yang tidak dapat dijalankan |
| **Kelalaian** | Topik yang hilang atau tidak lengkap |
| **Verifikasi** | Proses memeriksa klaim terhadap sumber primer |
| **Sumber primer** | Dokumentasi resmi, kode sumber, spesifikasi |
| **Sumber sekunder** | Blog, video, ringkasan otomatis |
| **Butir yang ditandai** | Klaim yang masih berupa asumsi dan perlu diverifikasi |
| **Artefak hidup** | Dokumentasi yang diperbarui secara berkala |
| **Template audit** | Kerangka untuk melakukan audit dokumentasi |

---

## 13. Rekomendasi Visualisasi

### 13.1 Alur Audit

```text
┌─────────────────┐
│  Kumpulkan      │
│  klaim dari     │
│  dokumentasi    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│  Verifikasi     │────►│  Temuan:        │
│  terhadap       │     │  faktual /      │
│  sumber primer  │     │  konseptual /   │
└────────┬────────┘     │  sintaks /      │
         │              │  kelalaian      │
         ▼              └────────┬────────┘
┌─────────────────┐              │
│  Uji contoh     │              │
│  kode           │              │
└────────┬────────┘              │
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│  Perbaiki       │◄────│  Klasifikasi    │
│  dokumentasi    │     │  dan prioritas  │
└────────┬────────┘     └─────────────────┘
         │
         ▼
┌─────────────────┐
│  Perbarui       │
│  catatan revisi │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Verifikasi     │
│  ulang          │
└─────────────────┘
```

### 13.2 Siklus Pemeliharaan

```text
        ┌──────────────────────────────┐
        │   Rilis Quickshell baru      │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │   Audit ringan               │
        │   (verifikasi butir ditandai)│
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │   Perubahan mayor?           │
        └──────┬───────────────┬───────┘
               │ Ya            │ Tidak
               ▼               ▼
    ┌──────────────────┐  ┌──────────────────┐
    │  Audit penuh     │  │  Perbarui catatan│
    │  (semua contoh)  │  │  revisi          │
    └────────┬─────────┘  └────────┬─────────┘
             │                     │
             └──────────┬──────────┘
                        ▼
             ┌──────────────────────┐
             │  Rilis kurikulum     │
             │  versi baru          │
             └──────────────────────┘
```

---

## 14. Hubungan dengan Modul Lain

| Topik | Modul Sumber | Hubungan |
|---|---|---|
| `PamContext` | 4.2 | Lockscreen |
| `WlSessionLock` | 4.2 | Lockscreen fail-safe |
| Volume PipeWire | 2.3 | Audio |
| UPower | 2.3 | Baterai |
| `Quickshell.I3` | 2.2 | Compositor IPC |
| `clearEnvironment` | 1.2, 4.1 | Keamanan |
| `bwrap` | 4.1 | Sandbox |
| Model keamanan QML | 3.3, 4.1 | Threat model |
| `WlrLayershell` | 2.1 | Bar |
| `AnchorLayout` | 0.3 | Layout |
| `MultiEffect` | 0.3 | Efek visual |
| Contoh pertama | 0.1 | Onboarding |
| `Connections` | 3.2 | Binding |
| `SystemClock` | 1.2 | Jam |
| Plugin C++ | 5.1 | Ekstensi |
| Flake/PKGBUILD | 5.3 | Deployment |
| `semgrep` | Catatan keamanan | Analisis statis |
| Sumber | Semua | Referensi |
| Topik hilang | Semua | Kelengkapan |
| Non-IT | Fase −1, Glosarium | Aksesibilitas |
| Tautan | Semua | Navigasi |

---

## 15. Sumber Referensi

- [Quickshell HACKING.md](https://github.com/quickshell-mirror/quickshell/blob/master/HACKING.md) — mekanisme plugin dan gaya kode.
- [Quickshell Changelog](https://github.com/quickshell-mirror/quickshell/releases) — perubahan API antar versi.
- [Qt QML Security](https://lists.qt-project.org/pipermail/qt-qml/2011-July/002821.html) — diskusi sandbox QML.
- [xdg-dbus-proxy](https://man.archlinux.org/man/xdg-dbus-proxy.1.en) — referensi proxy D-Bus.
- [Reproducible Builds](https://reproducible-builds.org/) — standar reproducibility.

---

## 16. Tips dan Praktik Terbaik

1. **Audit secara berkala**, bukan sekali. Setiap rilis Quickshell adalah kesempatan audit.
2. **Verifikasi dengan sumber primer**, bukan ingatan.
3. **Uji setiap contoh** di lingkungan bersih.
4. **Dokumentasikan ketidakpastian** dengan frasa yang tepat.
5. **Klasifikasikan temuan** untuk memprioritaskan perbaikan.
6. **Gunakan template audit** untuk konsistensi.
7. **Pelajari pola kesalahan** untuk mencegahnya.
8. **Perbarui catatan revisi** setiap kali ada temuan baru.
9. **Uji dengan pembaca non-IT** untuk memastikan aksesibilitas.
10. **Rayakan perbaikan**, bukan hanya temuan. Setiap perbaikan adalah kemajuan.

---

## 17. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak mengaudit | Dokumentasi usang | Audit berkala |
| Mengandalkan ingatan | Klaim salah | Verifikasi dengan sumber primer |
| Tidak menguji contoh | Contoh gagal | Uji setiap contoh |
| Menyembunyikan ketidakpastian | Pembaca tersesat | Akui ketidakpastian |
| Tidak mengklasifikasikan temuan | Prioritas salah | Klasifikasikan |
| Tidak memperbarui catatan revisi | Temuan terlupakan | Perbarui setiap audit |
| Mengabaikan pembaca non-IT | Kurikulum tidak dapat diakses | Uji dengan non-IT |
| Tidak memverifikasi versi | Klaim tidak akurat | Verifikasi butir yang ditandai |

---

> **Motivasi:** Dokumentasi yang jujur tentang kesalahannya sendiri adalah **dokumentasi yang paling dapat dipercaya**. Setiap temuan yang diperbaiki adalah satu langkah menuju pemahaman yang lebih benar — dan setiap pembaca yang belajar dari kesalahan itu adalah **bukti bahwa audit ini layak dilakukan**.

---

## Penutup Kurikulum

Dengan selesainya **Catatan Revisi (Pasca-Audit)** , seluruh bagian kurikulum telah didalami:

| Bagian | Status |
|---|---|
| Fase 5 — Modul 5.1, 5.2, 5.3 | ✅ Selesai |
| Proyek Capstone | ✅ Selesai |
| Pohon Keputusan | ✅ Selesai |
| Glosarium | ✅ Selesai |
| Hasil Pembelajaran | ✅ Selesai |
| Sumber Daya Komunitas | ✅ Selesai |
| Catatan Akhir Keamanan Tinggi | ✅ Selesai |
| Catatan Revisi | ✅ Selesai |

Kurikulum ini kini lengkap dari **Fase −1** (fondasi non-IT) hingga **Catatan Revisi** (pemeliharaan dokumentasi). Ia bukan dokumen statis; ia adalah **artefak hidup** yang harus diperbarui seiring evolusi Quickshell.

**Langkah berikutnya ada di tangan Anda:**

1. **Mulai dari Fase −1** jika Anda baru memulai.
2. **Lompat ke Fase 5** jika Anda sudah memiliki fondasi.
3. **Gunakan Capstone** sebagai wahana untuk membuktikan penguasaan.
4. **Audit ulang** kurikulum ini terhadap versi Quickshell Anda.
5. **Berkontribusi** ke upstream — mulai dari perbaikan kecil.

> **Motivasi terakhir:** Kurikulum ini adalah **peta**, bukan **wilayah**. Ia menunjukkan jalan, tetapi Anda yang harus berjalan. Setiap modul yang Anda selesaikan, setiap bug yang Anda perbaiki, dan setiap fitur yang Anda bangun adalah **satu langkah menjauh dari penonton dan menuju pencipta**. Selamat berkarya.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../quickshell.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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

