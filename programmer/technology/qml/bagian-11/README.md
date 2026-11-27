# Fase 10
## Audit Singkat Fase 10

Saya memeriksa klaim kurikulum terhadap dokumentasi Qt 6.12. Temuan untuk modul 10.2–10.7 saya catat sekarang dan akan saya tangani saat modulnya tiba.

**Terverifikasi benar**
- **10.4, pemetaan tipe.** Keterangan "`QVariantList` dapat diubah di tempat sejak 6.5, `QVariantMap` sejak 6.9" tepat. Array-like hasil konversi dari C++ menyediakan metode array, tetapi `Array.isArray()` tetap `false`.
- **10.3.** `#include <QtQml/qqmlregistration.h>` sah bila Anda menautkan QtQml. Header itu menyertakan `qqmlintegration.h`. Penggunaan `FINAL` pada `Q_PROPERTY` dianjurkan: properti `FINAL` tidak bisa ditimpa, sehingga menghindari penimpaan tak sengaja.

**Perlu koreksi atau penajaman**
1. **10.4, tanggal dan waktu.** Kurikulum menulis "`QDate`/`QDateTime` ↔ `Date` (berbasis UTC)". Itu terlalu kasar. `QDate` dipetakan ke awal hari dalam UTC dengan aturan pemetaan balik yang agak eksentrik, dan dokumentasi menyarankan properti `QDateTime` agar Anda yang mengendalikan UTC atau waktu lokal. `QTime` menjadi `Date` dengan komponen tanggal buatan yang tak boleh diandalkan.
2. **Kepemilikan data (belum ada di kurikulum).** Data yang berpindah dari C++ ke QML tetap dimiliki C++, kecuali `QObject` yang dikembalikan dari pemanggilan method C++ eksplisit: mesin QML mengambil alih kepemilikannya, kecuali ia punya induk atau Anda menetapkan `CppOwnership`. Ini sumber *crash* dan kebocoran yang paling umum. Masuk ke 10.2.5 dan 10.4.
3. **10.3, makro.** `QML_UNCREATABLE` tak lengkap tanpa argumennya: ia membutuhkan teks alasan, dipakai bersama `QML_ELEMENT` atau `QML_NAMED_ELEMENT`. Tambahkan juga `QML_ANONYMOUS`, `QML_INTERFACE`, `QML_VALUE_TYPE`, `QML_ADDED_IN_VERSION`, `Q_CLASSINFO("DefaultProperty", ...)`, `QQmlListProperty`, dan `QQmlParserStatus`. Dokumentasi mencatat tipe bernilai (`Q_GADGET`) harus bernama huruf kecil, dapat dibuat default, dan dapat disalin.
4. **10.2–10.4, enum.** Belum ada. Enum yang dipakai di QML perlu `Q_ENUM`, kelasnya terdaftar, dan nama nilainya berawalan huruf kapital. Masuk ke 10.3/10.4.
5. **10.5, model.** Dua alat modern belum disebut. `QRangeModel` (sejak 6.10) mengimplementasikan `QAbstractItemModel` untuk range C++ apa pun. QML `SortFilterProxyModel` (`import QtQml.Models`, sejak 6.10) berstatus *Preliminary* (bisa berubah). Tambahkan sebagai alternatif subkelas manual dan sebagai pengganti proxy C++ untuk kasus sederhana.
6. **10.6, keamanan proses.** Kurikulum benar menyarankan argumen terpisah tanpa shell. Tambahkan bahwa itu tidak menutup *argument injection*, dan sertakan `QSaveFile`, `QLockFile`, `QTemporaryFile`, `QStandardPaths` (XDG), dan `QCommandLineParser`.
7. **10.7, konkurensi.** Tambahkan `QFuture::then()`, `QPromise`, dan *render thread* Qt Quick.

**Modul 10.1 (modul ini)**
- Kode contoh valid dan dapat dikompilasi. Satu catatan: `qDebug()` mencetak `QString` dengan tanda kutip, jadi hasilnya `"Kopi" 15000`.
- **Daftar isi kurang.** Terminologi menyebut *parent ownership*, tetapi daftar isi tak punya bagiannya. Saya tambahkan 10.1.8. Saya juga menambah 10.1.9 (toolchain dan sanitizer) dan 10.1.10 (lab).
- **Gaya Qt 6 kurang.** Tambahkan `u"..."_s` (`Qt::StringLiterals`, Qt ≥ 6.4), `QStringView`, `qsizetype`, dan `std::as_const`.
- **Estimasi.** Kurikulum sendiri mencatat 8–12 minggu paruh waktu bagi pemula C++. Modul ini memberi peta dan latihan, bukan pengganti latihan berminggu-minggu.

<details>
  <summary>📃 Daftar Isi</summary>

---
## Daftar isi Modul 10.1 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 10.1.1 | Tipe, nilai, referensi, pointer (+ `auto`, *structured binding*, `enum class`) |
| 10.1.2 | RAII dan smart pointer (+ `std::move`) |
| 10.1.3 | `const` dan referensi `const&` |
| 10.1.4 | Lambda dan fungsi sebagai nilai |
| 10.1.5 | Template dasar |
| 10.1.6 | Header vs sumber dan build |
| 10.1.7 | Gaya Qt: `QString`, `QList`, `QStringLiteral`, `u"..."_s` |
| 10.1.8 | Kepemilikan di dunia Qt: induk-anak, `QPointer`, `deleteLater` `[TAMBAHAN]` |
| 10.1.9 | Toolchain, peringatan kompilator, dan sanitizer `[TAMBAHAN]` |
| 10.1.10 | Lab terpadu: Toko Kopi + lab keselamatan memori `[TAMBAHAN]` |


</details>

---

# Modul 10.1 — C++ Dasar untuk Qt (jalur paralel)

## Deskripsi dan peran dalam kurikulum

QML tidak bisa membaca berkas, mengatur proses, atau menghitung berat. Pekerjaan itu hidup di backend C++. Fase 10 menghubungkan keduanya: C++ mengekspos objek, QML memakainya. Anda tak perlu menjadi ahli C++ untuk itu. Yang dibutuhkan adalah **kompetensi minimum yang aman**: memahami siapa pemilik sebuah objek, kapan ia dihancurkan, dan apa yang terjadi saat disalin.

Kesalahan C++ bukan sekadar *bug*. Pointer menggantung, akses di luar batas, dan *use-after-free* adalah kelas kerentanan keamanan utama. Prinsip keamanan dan isolasi yang Anda anut dimulai dari sini: *membuat kesalahan kepemilikan menjadi mustahil lewat desain*.

## Konsep kunci dan filosofi

**Analogi RAII.** RAII adalah kunci kamar hotel dengan kartu. Saat kartu diberikan (objek dibuat), kamar menjadi milik Anda. Saat kartu keluar dari jangkauan (objek mati), kamar otomatis dikembalikan, bahkan bila Anda terburu-buru atau terjadi galat. Tak ada "lupa checkout".

**Tiga pertanyaan untuk setiap objek C++:**

```
1. Siapa PEMILIKNYA?      (siapa yang menghancurkannya)
2. Berapa LAMA hidupnya?  (kapan ia dibuat dan dihancurkan)
3. Apa yang terjadi saat DISALIN? (salinan penuh, dibagi, atau dilarang)
```

**Dua tradisi kepemilikan di Qt**

```
C++ Standar                      Qt
-----------------------------    ---------------------------------
RAII + std::unique_ptr           pohon induk-anak (QObject)
std::shared_ptr (jarang)         QPointer / QSharedPointer
nilai (value semantics)          implicit sharing (QString, QList)
```

Aturannya: pakai smart pointer untuk objek biasa, dan pohon induk-anak untuk `QObject`. Jangan mencampur keduanya tanpa sadar.

**Pondasi sintaks yang dipakai**
- `#include`: menyalin isi header ke berkas Anda saat kompilasi.
- `::`: operator cakupan (`std::unique_ptr`, `Qt::StringLiterals`).
- `->` dan `*`: akses lewat pointer; `.`: akses lewat nilai atau referensi.
- `{ ... }`: blok cakupan, tempat RAII bekerja.

## 9.1 → 10.1.1 Tipe, nilai, referensi, pointer

> *Satu pointer yang dipahami lebih bernilai daripada seribu yang ditebak.*

**Konsep.** Tiga cara memberikan variabel ke fungsi:

| Cara | Sintaks | Arti |
| --- | --- | --- |
| Nilai | `void f(int x)` | Salinan. Perubahan tak memengaruhi aslinya. |
| Referensi | `void f(int &x)` | Alias untuk objek asli. Tak bisa null, tak bisa dipindah ke objek lain. |
| Pointer | `void f(int *x)` | Alamat objek. Bisa `nullptr`, bisa menunjuk ke objek lain. |

```cpp
#include <QDebug>

void naikkanHarga(int harga)       { harga += 1000; }             // salinan
void naikkanHargaRef(int &harga)   { harga += 1000; }             // referensi
void naikkanHargaPtr(int *harga)   { if (harga) *harga += 1000; } // pointer

int main()
{
    int h = 15000;
    naikkanHarga(h);      qDebug() << h;   // 15000 (aslinya tak berubah)
    naikkanHargaRef(h);   qDebug() << h;   // 16000
    naikkanHargaPtr(&h);  qDebug() << h;   // 17000
}
```

**Bedah kode**
- `#include <QDebug>` membawa `qDebug()`, pencetak debug Qt.
- `void naikkanHarga(int harga)`: parameter `harga` adalah salinan dari argumen. `harga += 1000` hanya mengubah salinan itu.
- `int &harga`: tanda `&` setelah tipe berarti referensi. Parameter adalah nama lain untuk `h` di `main`.
- `int *harga`: tanda `*` setelah tipe berarti pointer, yaitu alamat sebuah `int`. `if (harga)` memeriksa tidak null. `*harga` (dereferensi) mengakses nilai di alamat itu.
- `&h` di pemanggilan: operator *alamat-dari*, mengambil alamat `h`.
- `main()` adalah titik masuk program.

**Peta memori (tumpukan)**

```
 alamat   isi
 0x7ffe10  h = 17000   <- 'naikkanHarga' menerima salinan (tempat lain)
                          'naikkanHargaRef' menerima alias ke 0x7ffe10
                          'naikkanHargaPtr' menerima alamat 0x7ffe10
```

**Sintaks modern yang sering muncul di kode Qt**

```cpp
auto p = std::pair{ QStringLiteral("Kopi"), 15000 };   // 'auto' menyimpulkan tipe
const auto [nama, harga] = p;                          // structured binding (C++17)
enum class Status { Siap, Sibuk };                     // enum bercakupan, aman dari bentrok nama
```

- `auto` meminta kompilator menyimpulkan tipe dari ekspresi. Ia tak mengurangi keamanan tipe.
- `const auto [nama, harga] = p;` membongkar pasangan menjadi dua nama.
- `enum class` membuat nilai hanya dikenal lewat `Status::Siap`, bukan `Siap` telanjang.

**Opsi lain**
- **Kembalikan nilai** daripada mengubah parameter: `int naik(int h) { return h + 1000; }`. Ini paling mudah dibaca.
- **`std::optional<int>`** bila hasilnya "mungkin tidak ada", sebagai ganti pointer null.
- **Struct hasil** atau `std::pair`/`std::tuple` untuk beberapa nilai.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Pointer tak diinisialisasi atau menggantung | `nullptr` dan periksa; pakai referensi atau smart pointer |
| Mengembalikan referensi ke variabel lokal | Kembalikan nilai |
| Variabel tak diinisialisasi (`int x;`) | Selalu beri nilai awal (`int x = 0;`) |
| Aritmetika pointer manual | Pakai kontainer (`QList`, `std::vector`) |

## 10.1.2 RAII dan smart pointer

> *Kekuatan sejati adalah pelepasan yang tak bisa terlupa.*

**Konsep.** Objek C++ memiliki konstruktor (saat lahir) dan destruktor (saat mati). Di cakupan `{ }`, objek lokal dihancurkan otomatis dengan urutan terbalik dari deklarasinya. RAII (*Resource Acquisition Is Initialization*) memanfaatkan ini: **sumber daya diperoleh di konstruktor dan dilepas di destruktor**.

| Smart pointer | Pemilik | Pakai untuk |
| --- | --- | --- |
| `std::unique_ptr<T>` | Tunggal, tak bisa disalin, hanya dipindah | Pilihan bawaan untuk objek di heap |
| `std::shared_ptr<T>` | Banyak (hitungan referensi) | Kepemilikan benar-benar bersama (jarang) |
| `std::weak_ptr<T>` | Tak memiliki | Menunjuk tanpa memperpanjang umur, memutus siklus |

```cpp
#include <QDebug>
#include <memory>

struct Sumber {
    Sumber()  { qDebug() << "dibuka"; }
    ~Sumber() { qDebug() << "ditutup"; }
};

std::unique_ptr<Sumber> buat() { return std::make_unique<Sumber>(); }
void ambilAlih(std::unique_ptr<Sumber> p) { qDebug() << "dimiliki fungsi ini"; }

int main()
{
    Sumber a;                                                   // di tumpukan
    auto b = std::make_unique<Sumber>();                        // di heap, pemilik tunggal
    std::shared_ptr<Sumber> c = std::make_shared<Sumber>();     // pemilik bersama
    auto d = c;                                                 // hitungan = 2
    qDebug() << "use_count:" << c.use_count();

    auto e = buat();                                            // kepemilikan dikembalikan
    ambilAlih(std::move(e));                                    // dipindah; 'e' kini kosong
    qDebug() << "e kosong?" << (e == nullptr);
}   // akhir blok: d, c, b, a dilepas OTOMATIS (urutan terbalik)
```

**Bedah kode**
- `struct Sumber { ... }`: tipe sederhana dengan konstruktor `Sumber()` dan destruktor `~Sumber()` (tanda `~`). Keduanya mencetak pesan agar kita melihat kapan objek lahir dan mati.
- `std::make_unique<Sumber>()` membuat objek di heap dan langsung membungkusnya di `unique_ptr`. Ini pengganti `new Sumber`.
- `std::make_shared<Sumber>()` membuat objek dengan hitungan referensi. `auto d = c;` menyalin pointer, hitungan menjadi 2. `c.use_count()` membacanya.
- `std::move(e)` bukan "memindahkan data" melainkan *mengizinkan* kepemilikan dipindah. Setelah `ambilAlih`, `e` kosong (`nullptr`) dan `p` di dalam fungsi yang memiliki objek, lalu menghancurkannya saat fungsi selesai.
- Di akhir `main`, semua yang masih hidup dilepas otomatis. Tak ada `delete` yang ditulis.

**Aturan praktis kepemilikan**
- **Bawaan:** nilai biasa atau `unique_ptr`.
- **Parameter fungsi:** pointer/referensi mentah berarti "pinjam, bukan miliki". `unique_ptr` berarti "serahkan kepada saya".
- **Rule of zero:** bila kelas hanya berisi anggota yang mengelola dirinya (`QString`, `QList`, smart pointer), jangan tulis destruktor atau salinan manual.

**Opsi lain di Qt**
- `QScopedPointer<T>`: padanan Qt untuk `unique_ptr`.
- `QSharedPointer<T>`: padanan `shared_ptr`.
- `QPointer<T>`: khusus `QObject`, otomatis null bila objek dihapus (10.1.8).

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| `new` tanpa pemilik jelas | `make_unique` atau induk-anak Qt |
| `delete` dua kali | Jangan `delete` manual; smart pointer |
| `shared_ptr` dibuat dari pointer mentah yang sama dua kali | `make_shared`, tak pernah dari mentah ganda |
| Siklus `shared_ptr` (A menunjuk B, B menunjuk A) | `weak_ptr` untuk salah satu arah |
| Memakai objek setelah `std::move` | Anggap objek itu "kosong" dan jangan dibaca |

## 10.1.3 `const` dan referensi `const&`

> *Janji untuk tidak mengubah adalah janji yang dibuat sekali dan dipegang selamanya.*

**Konsep.** `const` adalah kontrak yang diperiksa kompilator: "ini tidak akan diubah". `const&` memberi akses baca tanpa menyalin.

```cpp
#include <QDebug>
#include <QStringList>

class Keranjang
{
public:
    void tambah(const QString &nama, int harga)         // (1) const& untuk tipe besar
    {
        m_nama.append(nama);
        m_total += harga;
    }
    int total() const { return m_total; }               // (2) metode const
    const QStringList &daftar() const { return m_nama; }// (3) kembalikan const&: tanpa salin

private:
    QStringList m_nama;
    int m_total = 0;
};

void cetak(const Keranjang &k)                          // (4) hanya metode const yang boleh dipanggil
{
    qDebug() << k.total() << k.daftar();
}
```

**Bedah kode**
1. `const QString &nama`: pinjam tanpa menyalin dan tanpa izin mengubah. Standar Qt untuk parameter teks dan kontainer.
2. `int total() const`: kata `const` setelah tanda kurung berarti metode ini tak mengubah objek. Ini wajib bila objeknya dipegang lewat `const&`.
3. `const QStringList &daftar() const`: mengembalikan referensi ke anggota tanpa menyalin, dan penerima tak bisa mengubahnya.
4. `void cetak(const Keranjang &k)`: kompilator menolak bila `cetak` mencoba memanggil metode non-`const`.
- `int m_total = 0;` adalah *default member initializer*, nilai awal yang aman.

**Konvensi Qt.** Getter bernama sama dengan properti dan `const` (`QString pesan() const`). Setter menerima `const T &` (`void setPesan(const QString &p)`). Ini yang akan Anda tulis di 10.2.

**Opsi lain**
- **Terima nilai lalu pindahkan** (*sink parameter*): `void set(QString p) { m_p = std::move(p); }`. Efisien bila pemanggil sering memberi sementara (*temporary*).
- **`constexpr`** untuk nilai yang dihitung saat kompilasi.
- **`mutable`** untuk anggota yang boleh berubah dalam metode `const` (cache), jarang diperlukan.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Menyimpan `const&` yang menunjuk ke objek sementara | Salin ke variabel nilai, atau pastikan sumbernya lebih panjang umur |
| Melupakan `const` pada getter | Selalu tandai metode pembaca sebagai `const` |
| Membuang `const` dengan `const_cast` | Rancang ulang; hampir selalu pertanda desain keliru |

## 10.1.4 Lambda dan fungsi sebagai nilai

> *Fungsi yang bisa dibawa-bawa membuat kode sependek niatnya.*

**Konsep.** Lambda adalah fungsi tanpa nama yang dapat ditulis di tempat, menangkap variabel sekitarnya, dan dikirim sebagai nilai. Bentuk: `[tangkapan](parameter) { badan }`.

```cpp
#include <QList>
#include <algorithm>
#include <iterator>

struct Produk { QString nama; int harga = 0; };

QList<Produk> mahalSaja(const QList<Produk> &semua, int batas)
{
    QList<Produk> hasil;
    std::copy_if(semua.cbegin(), semua.cend(), std::back_inserter(hasil),
                 [batas](const Produk &p) { return p.harga > batas; });   // menangkap 'batas'

    std::sort(hasil.begin(), hasil.end(),
              [](const Produk &a, const Produk &b) { return a.harga < b.harga; });
    return hasil;
}
```

**Bedah kode**
- `std::copy_if(awal, akhir, tujuan, kondisi)` menyalin elemen yang memenuhi `kondisi` ke `tujuan`.
- `semua.cbegin()`/`cend()` adalah iterator konstan, awal dan akhir kontainer.
- `std::back_inserter(hasil)` membuat iterator yang memanggil `hasil.push_back(...)`.
- `[batas](const Produk &p) { return p.harga > batas; }` adalah lambda: `[batas]` menangkap salinan `batas`, parameternya `const Produk &p`, dan hasilnya `bool`.
- `std::sort(awal, akhir, pembanding)` mengurutkan. Lambda kedua `[]` tak menangkap apa pun, hanya membandingkan harga.

**Daftar tangkapan**

| Tulisan | Arti |
| --- | --- |
| `[]` | Tak menangkap apa pun |
| `[x]` / `[&x]` | Salinan `x` / referensi ke `x` |
| `[=]` / `[&]` | Salin semua / referensi semua yang dipakai (hati-hati) |
| `[this]` | Menangkap pointer objek saat ini |
| `[p = std::move(ptr)]` | Pindahkan ke dalam lambda (*init capture*) |

**Opsi lain**
- **Fungsi biasa atau pointer fungsi** untuk logika yang dipakai berulang.
- **`std::function<bool(const Produk&)>`** bila perlu menyimpan lambda di variabel dengan tipe tetap (sedikit lebih berat).
- **Functor** (kelas dengan `operator()`) untuk logika berstatus.

**Jebakan dan solusi.** Ini yang paling berbahaya di Qt.
- Lambda yang disimpan lalu dijalankan *nanti* (sinyal, async, thread) tidak boleh menangkap referensi ke variabel lokal. Variabelnya sudah mati saat lambda jalan. Tangkap **salinan** atau objek berumur panjang.
- `[=]` di dalam metode kelas ikut menangkap `this` secara implisit pada pola lama. Tulis `[this]` atau tangkapan eksplisit agar niat jelas.
- Saat menyambung sinyal Qt dengan lambda (10.2), selalu beri **objek konteks** agar sambungan putus bersama objeknya.

## 10.1.5 Template dasar

> *Tulis sekali, pakai untuk semua tipe.*

**Konsep.** Template adalah cetakan kode yang diisi tipe saat kompilasi. `QList<int>`, `QList<QString>`, `std::unique_ptr<T>` semuanya template. Kompilator menghasilkan kode terpisah untuk tiap tipe yang dipakai, tanpa biaya waktu-jalan tambahan.

```cpp
#include <utility>

template <typename T>
T lebihBesar(const T &a, const T &b) { return (a < b) ? b : a; }

template <typename T>
class Kotak
{
public:
    explicit Kotak(T nilai) : m_nilai(std::move(nilai)) {}
    const T &nilai() const { return m_nilai; }

private:
    T m_nilai;
};

// Pemakaian:
// lebihBesar(8000, 12000)               -> T = int
// lebihBesar(QString("a"), QString("b")) -> T = QString (butuh operator<)
// Kotak<QString> k(QStringLiteral("Kopi"));
```

**Bedah kode**
- `template <typename T>` membuka cetakan dengan parameter tipe bernama `T`.
- `T lebihBesar(const T &a, const T &b)`: `T` diisi kompilator dari argumen (*type deduction*). Ekspresi `(a < b) ? b : a` memakai operator kondisi.
- `class Kotak`: kelas template. `explicit` mencegah konversi implisit dari `T` ke `Kotak`.
- `m_nilai(std::move(nilai))` memindahkan argumen ke anggota (*member initializer list*).
- Syarat implisit: tipe `T` harus mendukung operasi yang dipakai (di sini `<`). Bila tidak, galatnya muncul saat kompilasi.

**Hal yang perlu diketahui**
- Definisi template biasanya ditaruh **di header**, karena kompilator butuh melihatnya saat membuat versi untuk tipe baru.
- Pesan galat template panjang. Baca dari galat pertama dan carikan baris Anda sendiri di dalamnya.
- Template yang sudah ada seringkali cukup: `std::max`, `std::min`, `QList<T>`.
- `Q_OBJECT` tak bisa dipakai pada kelas template (10.2).

**Opsi lain**
- **Kelebihan beban fungsi** (*overload*) bila hanya perlu dua-tiga tipe.
- **`std::variant`** atau pewarisan bila tipenya tak diketahui saat kompilasi.

**Jebakan dan solusi.** Definisi template di `.cpp` menyebabkan galat tautan, jadi taruh di header. Menulis template untuk sesuatu yang hanya dipakai sekali berarti terlalu rumit.

## 10.1.6 Header vs sumber dan build

> *Struktur yang rapi adalah separuh dari program yang benar.*

**Konsep.** C++ memisahkan **deklarasi** ("fungsi ini ada dan begini tanda tangannya") di berkas header `.h` dari **definisi** ("begini isinya") di berkas sumber `.cpp`. Proses build:

```
produk.h ──┐
produk.cpp ┴─ kompilator ─> produk.o ─┐
main.cpp ──── kompilator ──> main.o ──┴─ penaut (linker) ─> program
                                          (Qt6::Core ikut ditautkan)
```

```cpp
// produk.h
#pragma once                       // cegah header disertakan dua kali
#include <QList>
#include <QString>

struct Produk { QString nama; int harga = 0; };

QList<Produk> mahalSaja(const QList<Produk> &semua, int batas);   // deklarasi saja
```

```cpp
// produk.cpp
#include "produk.h"                // tanda kutip: berkas milik proyek
#include <algorithm>

QList<Produk> mahalSaja(const QList<Produk> &semua, int batas)    // definisi
{
    QList<Produk> hasil;
    std::copy_if(semua.cbegin(), semua.cend(), std::back_inserter(hasil),
                 [batas](const Produk &p) { return p.harga > batas; });
    return hasil;
}
```

**Bedah kode**
- `#pragma once` memastikan header hanya diproses sekali per berkas sumber. Alternatif klasik: *include guard* `#ifndef`.
- `#include <QList>` (kurung sudut) untuk pustaka sistem/Qt, `#include "produk.h"` (kutip) untuk berkas proyek.
- Header menaruh **deklarasi**. Definisi fungsi non-`inline` di header menyebabkan galat "multiple definition" saat penautan bila header dipakai di dua `.cpp`.
- Deklarasi maju (*forward declaration*, `class Backend;`) cukup bila header hanya memakai pointer atau referensi, dan mempercepat kompilasi.

**Dua jenis galat**

| Galat | Tahap | Contoh |
| --- | --- | --- |
| Kompilasi | Kompilator | Tanda `;` hilang, tipe salah |
| Tautan | Penaut | `undefined reference to ...` (definisi tak ditemukan) |

Di Qt, galat klasik `undefined reference to vtable for Backend` biasanya berarti header kelas ber-`Q_OBJECT` tak diproses MOC. Pastikan berkasnya ada di target CMake (10.2).

**CMake minimum**

```cmake
cmake_minimum_required(VERSION 3.21)
project(tokokopi LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core)
qt_standard_project_setup()

qt_add_executable(tokokopi main.cpp produk.cpp produk.h)
target_link_libraries(tokokopi PRIVATE Qt6::Core)
target_compile_options(tokokopi PRIVATE -Wall -Wextra -Wpedantic)
```

- `find_package(Qt6 ... Core)` mencari Qt, `qt_standard_project_setup()` memasang bawaan modern (termasuk MOC otomatis).
- `qt_add_executable` membuat program dari daftar berkas. Header ikut didaftarkan agar dilihat alat Qt.
- `target_link_libraries(... Qt6::Core)` menautkan modul Core.
- `-Wall -Wextra -Wpedantic` menyalakan peringatan (GCC/Clang).

**Jalan pintas tanpa CMake (uji cepat)**

```bash
g++ -std=c++17 -Wall -Wextra -fPIC -o kopi main.cpp $(pkg-config --cflags --libs Qt6Core)
```

Argumen `-fPIC` dibutuhkan karena Qt dibangun sebagai pustaka posisi-independen, dan `pkg-config` mengisi opsi `-I`/`-l` Qt.

**Opsi lain.** Proyek header-only (semua di header, cocok untuk template), atau pustaka terpisah lewat `qt_add_library`.

## 10.1.7 Gaya Qt: `QString`, `QList`, `QStringLiteral`

> *Mengenal alat sendiri adalah setengah dari keterampilan.*

**Konsep**
- **`QString`**: teks Unicode (UTF-16) dengan banyak metode. Qt melakukan **implicit sharing** (*copy-on-write*): menyalin `QString` murah karena data dibagi. Salinan nyata baru dibuat saat salah satunya diubah.
- **`QList<T>`**: kontainer berurutan berisi elemen berdempetan di memori. Di Qt 6, `QList` dan `QVector` sudah sama. `size()` mengembalikan `qsizetype` (bertanda).
- **`QStringLiteral("...")`**: membuat `QString` dari literal tanpa alokasi saat berjalan. Sejak Qt 6.4 ada `u"..."_s` yang setara dan lebih ringkas.

```
a = "Kopi" ──┐                     a ─> [Kopi]
b = a        ├─ berbagi data   ->  b = a
b.append(...) ─ detach (salin)  ->  a ─> [Kopi]   b ─> [Kopi Susu]
```

```cpp
#include <QDebug>
#include <QList>
#include <QString>
#include <utility>

using namespace Qt::StringLiterals;

int main()
{
    QString a = u"Kopi"_s;             // literal compile-time (Qt ≥ 6.4)
    QString b = a;                     // salinan murah: berbagi data
    b.append(u" Susu"_s);              // di sini terjadi detach
    qDebug() << a << b;                // "Kopi" "Kopi Susu"
    qDebug().noquote() << a << b;      // Kopi Kopi Susu

    QList<int> harga = { 15000, 8000, 12000 };
    for (int h : std::as_const(harga)) // as_const: cegah detach tak sengaja
        qDebug() << h;

    qDebug() << QStringLiteral("Total item: %1").arg(harga.size());
}
```

**Bedah kode**
- `using namespace Qt::StringLiterals;` membuka literal `_s`. Ini ditaruh di `.cpp` atau cakupan fungsi, bukan di header.
- `u"Kopi"_s` membuat `QString` dari literal UTF-16. Awalan `u` adalah literal teks UTF-16 standar C++.
- `qDebug() << a << b;` mencetak string berkutip (diagnosis). `.noquote()` menghilangkannya.
- `QList<int> harga = { ... }` memakai inisialisasi daftar.
- `std::as_const(harga)` mengubah `harga` menjadi `const`. Range-for atas kontainer non-const bisa memicu salinan (*detach*), `as_const` mencegahnya.
- `QStringLiteral("Total item: %1").arg(...)` memakai penanda posisi `%1`, yang sama seperti `qsTr` di QML.

**Pemetaan ke QML (dibahas penuh di 10.4)**
- `QString` ↔ `string`, `int` ↔ `int`, `QList<int>` ↔ array-like.

**Opsi lain**
- **`QStringView`/`QLatin1StringView`**: tampilan baca-saja atas teks, tanpa alokasi. Bagus untuk parameter fungsi yang hanya membaca.
- **`std::string`**: untuk berinteraksi dengan pustaka non-Qt. Konversi `QString::fromStdString()` dan `toStdString()`.
- **`QByteArray`**: untuk byte mentah dan teks UTF-8, mis. data jaringan atau keluaran proses (10.6).
- **`QHash`/`QMap`**: kamus (tak berurutan / berurutan).

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| `QString("teks")` dari `const char*` memicu konversi dari ASCII | Pakai `u"..."_s` atau `QStringLiteral`; pertimbangkan `QT_NO_CAST_FROM_ASCII` |
| Menggabung `+` berulang di loop | `QString::arg`, `QStringList::join`, atau `QStringBuilder` |
| Range-for atas kontainer non-const | `std::as_const(kontainer)` |
| Membandingkan `size()` (bertanda) dengan `unsigned` | Pakai `qsizetype`/`int` secara konsisten |
| `qDebug()` dikira mencetak tanpa kutip | `.noquote()` untuk keluaran manusia |

## 10.1.8 Kepemilikan di dunia Qt: induk-anak, `QPointer`, `deleteLater` `[TAMBAHAN]`

> *Dalam pohon yang sehat, tiap daun tahu siapa batangnya.*

**Konsep.** `QObject` punya pohon: konstruktor menerima `QObject *parent`. Induk menghancurkan semua anaknya saat dirinya dihancurkan. Inilah mekanisme kepemilikan Qt, dan dasar untuk 10.2.5.

```cpp
#include <QCoreApplication>
#include <QDebug>
#include <QObject>
#include <QPointer>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    auto *induk = new QObject;
    auto *anak  = new QObject(induk);              // anak dimiliki induk
    anak->setObjectName(QStringLiteral("anak"));
    QPointer<QObject> aman = anak;                 // pointer "lemah" khusus QObject

    delete induk;                                  // anak ikut dihapus otomatis
    qDebug() << "aman null?" << aman.isNull();     // true
}
```

**Bedah kode**
- `new QObject(induk)`: argumen menjadikan `induk` sebagai orang tua. Tak ada `delete anak` yang ditulis.
- `QPointer<QObject> aman = anak;` menyimpan penunjuk yang otomatis menjadi null bila objeknya dihancurkan. Itu beda dengan pointer mentah, yang menggantung.
- `delete induk;` menghancurkan induk beserta anak. `aman.isNull()` bernilai `true`.
- `QCoreApplication` diperlukan untuk fitur yang butuh *event loop* (dasar `deleteLater`, sinyal lintas thread, dll.).

**Pegangan**
- **Objek di heap dengan induk:** serahkan kepemilikan ke pohon, jangan `delete` manual.
- **`deleteLater()`:** hapus objek nanti, saat kendali kembali ke event loop. Wajib bila objek dihapus dari dalam slot atau sinyalnya sendiri.
- **Objek di tumpukan sebagai anak** berbahaya: induk akan menghapus objek tumpukan itu (*double free*). Pastikan induk dihancurkan lebih dulu, atau hindari pola ini.
- **Penunjuk "mungkin sudah mati":** `QPointer`. Untuk `QObject` yang dimiliki pohon, hindari `shared_ptr`.

**Opsi lain.** `QScopedPointer`/`std::unique_ptr` untuk `QObject` tanpa induk; `QSharedPointer` bila benar-benar dibagi. Jangan satu objek punya induk *dan* dibungkus smart pointer yang akan menghapusnya juga.

**Jebakan dan solusi.** Mencampur kepemilikan (induk dan `unique_ptr` sekaligus) menyebabkan *double delete*. `delete` pada objek yang sedang menjalankan slotnya menyebabkan *crash*. Gunakan `deleteLater()`.

## 10.1.9 Toolchain, peringatan kompilator, dan sanitizer `[TAMBAHAN]`

> *Alat yang baik membuat kesalahan terlihat sebelum merugikan siapa pun.*

**Konsep.** C++ memberi Anda kendali penuh, termasuk untuk berbuat salah dengan senyap. Alat berikut mengubah kesalahan senyap menjadi pesan jelas, dan itu bagian dari mentalitas keamanan.

```bash
sudo pacman -S --needed base-devel cmake ninja gdb valgrind clang qt6-base
pkg-config --modversion Qt6Core                 # versi Qt yang terpasang
g++ --version && clang++ --version

# build dengan sanitizer: mendeteksi use-after-free, overflow, perilaku tak terdefinisi
cmake -S . -B build-asan -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer -Wall -Wextra"
cmake --build build-asan && ./build-asan/tokokopi

# editor berbasis terminal: ekspor database kompilasi untuk clangd (LSP)
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

| Alat | Fungsi |
| --- | --- |
| `-Wall -Wextra -Wpedantic` | Peringatan kompilator; anggap peringatan sebagai calon bug |
| `-fsanitize=address` (ASan) | Mendeteksi *use-after-free*, *buffer overflow* |
| `-fsanitize=undefined` (UBSan) | Mendeteksi perilaku tak terdefinisi (mis. *overflow* bilangan bertanda) |
| `-D_GLIBCXX_ASSERTIONS` | Menyalakan pemeriksaan batas pada kontainer libstdc++ |
| `valgrind --leak-check=full ./prog` | Mendeteksi kebocoran (lebih lambat dari ASan) |
| `gdb` | Debugger; kompilasi dengan `-g` |
| `clangd` | Server bahasa untuk editor terminal (Neovim, Helix) |
| `clang-tidy`, `clazy` | Analisis statis; `clazy` khusus idiom Qt (periksa `pacman -Ss clazy`) |

**Catatan.** Qt 6 mensyaratkan C++17 sebagai dasar. `Debug` dan `Release` dibangun berbeda: sebagian asersi Qt (`Q_ASSERT`) hanya hidup di Debug.

**Jebakan.** Menjalankan hanya build Release dan baru terkejut di produksi. Uji dengan sanitizer secara rutin.

## 10.1.10 Lab terpadu `[TAMBAHAN]`

**Lab 1: Toko Kopi.** Memenuhi latihan kurikulum (tiga produk di `QList<Produk>` dan cetak yang harganya di atas 10000), dengan header/sumber terpisah, lambda, `unique_ptr`, `const&`, dan template.

```cpp
// produk.h
#pragma once
#include <QList>
#include <QString>

struct Produk { QString nama; int harga = 0; };

QList<Produk> mahalSaja(const QList<Produk> &semua, int batas);

template <typename T>
T lebihBesar(const T &a, const T &b) { return (a < b) ? b : a; }
```

```cpp
// produk.cpp
#include "produk.h"
#include <algorithm>
#include <iterator>

QList<Produk> mahalSaja(const QList<Produk> &semua, int batas)
{
    QList<Produk> hasil;
    std::copy_if(semua.cbegin(), semua.cend(), std::back_inserter(hasil),
                 [batas](const Produk &p) { return p.harga > batas; });
    std::sort(hasil.begin(), hasil.end(),
              [](const Produk &a, const Produk &b) { return a.harga < b.harga; });
    return hasil;
}
```

```cpp
// main.cpp
#include "produk.h"
#include <QDebug>
#include <memory>
#include <utility>

using namespace Qt::StringLiterals;

class Kasir
{
public:
    explicit Kasir(QList<Produk> daftar) : m_daftar(std::move(daftar)) {}

    int total() const
    {
        int t = 0;
        for (const Produk &p : std::as_const(m_daftar))
            t += p.harga;
        return t;
    }
    const QList<Produk> &daftar() const { return m_daftar; }

private:
    QList<Produk> m_daftar;
};

int main()
{
    const QList<Produk> semua = {
        { u"Kopi"_s, 15000 }, { u"Teh"_s, 8000 }, { u"Susu"_s, 12000 }
    };

    auto kasir = std::make_unique<Kasir>(mahalSaja(semua, 10000));
    for (const Produk &p : kasir->daftar())
        qDebug().noquote() << p.nama << p.harga;

    qDebug() << "total:" << kasir->total();
    qDebug() << "terbesar:" << lebihBesar(8000, 12000);
}
```

CMake memakai berkas dari 10.1.6, dan keluarannya:

```
Susu 12000
Kopi 15000
total: 27000
terbesar: 12000
```

**Bedah ringkas**
- `mahalSaja(semua, 10000)` menyaring harga di atas 10000 lalu mengurutkan naik. Hasilnya Susu lalu Kopi.
- `explicit Kasir(QList<Produk> daftar) : m_daftar(std::move(daftar))` menerima nilai lalu memindahkannya, tanpa salinan tambahan.
- `std::make_unique<Kasir>(...)` memberi `kasir` kepemilikan tunggal. Tak ada `delete`.
- `const QList<Produk> &daftar() const` membaca tanpa menyalin.
- `lebihBesar(8000, 12000)`: `T` disimpulkan sebagai `int`.

**Lab 2: keselamatan memori (sengaja salah).** Tujuannya melihat sanitizer bekerja. Buat berkas terpisah `rusak.cpp`:

```cpp
#include <QDebug>

int main()
{
    int *p = new int(5);
    delete p;
    qDebug() << *p;          // use-after-free: perilaku tak terdefinisi
}
```

```bash
g++ -std=c++17 -g -fsanitize=address,undefined -fPIC -o rusak rusak.cpp $(pkg-config --cflags --libs Qt6Core)
./rusak                      # ASan menghentikan program dan menunjuk baris yang salah
```

Perbaiki dengan `auto p = std::make_unique<int>(5);` dan perhatikan bahwa kesalahan itu tak bisa lagi ditulis.

**Latihan tambahan**
1. Tambahkan `Q_INVOKABLE`-gaya metode `tambah(const Produk &)` di `Kasir` dan pastikan tetap tanpa `delete` manual.
2. Ganti lambda `[batas]` dengan fungsi biasa dan bandingkan.
3. Bungkus `Kasir` dalam `std::shared_ptr`, cetak `use_count()`, lalu pikirkan apakah itu perlu.
4. Gunakan `QPointer` untuk `QObject` anak di Lab 8 dan amati hasilnya setelah induk dihapus.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Nilai / referensi / pointer** | Salinan / alias / alamat sebuah objek |
| **Tumpukan (stack) / heap** | Memori otomatis berumur cakupan / memori dinamis |
| **RAII** | Sumber daya diperoleh di konstruktor, dilepas di destruktor |
| **`std::unique_ptr`** | Pemilik tunggal, tak bisa disalin, bisa dipindah |
| **`std::shared_ptr` / `weak_ptr`** | Pemilik bersama berhitung referensi / penunjuk tanpa kepemilikan |
| **`std::move`** | Mengizinkan pemindahan kepemilikan, bukan memindahkan data itu sendiri |
| **`const` correctness** | Menandai apa yang tak diubah, diperiksa kompilator |
| **Lambda** | Fungsi tanpa nama yang bisa menangkap variabel |
| **Template** | Cetakan kode berparameter tipe |
| **Header / sumber** | Berkas deklarasi / definisi |
| **ODR** | *One Definition Rule*: satu definisi per entitas |
| **Implicit sharing** | Salinan murah berbagi data hingga ada yang mengubah |
| **Detach** | Saat data bersama benar-benar disalin |
| **Parent ownership** | Induk `QObject` menghancurkan anak-anaknya |
| **`QPointer`** | Penunjuk `QObject` yang otomatis null |
| **Sanitizer (ASan/UBSan)** | Instrumentasi kompilator pendeteksi bug memori/perilaku |

## Hubungan dengan modul lain

- **Prasyarat:** Fase 8.3 (CMake), dasar pemrograman umum. Idealnya dikerjakan paralel sejak Fase 4, seperti yang dicatat kurikulum.
- **Menjadi dasar untuk:** 10.2 (`QObject`, `Q_PROPERTY` memakai `const&`, getter `const`, parent ownership), 10.3 (registrasi tipe memakai header dan CMake), 10.4 (kepemilikan objek lintas C++/QML), 10.5 (`QList<Item>` dan `const&` di model), 10.6 (`QProcess` dan RAII), 10.7 (lambda dan salinan yang aman lintas thread).

## Tips dan praktik terbaik

1. **Jangan tulis `delete`.** Pakai nilai, `unique_ptr`, atau pohon induk-anak.
2. **Parameter besar: `const T &`.** Getter: `const`. Nilai kembalian: nilai bila murah.
3. **Inisialisasi semuanya.** `int x = 0;`, `Produk p{};`.
4. **Lambda yang berumur panjang menangkap salinan,** bukan referensi lokal.
5. **`std::as_const` untuk range-for** atas kontainer Qt.
6. **Nyalakan peringatan dan sanitizer** di build pengembangan. Jadikan kebiasaan.
7. **Satu pemilik per objek.** Jangan campur induk-anak dan smart pointer.
8. **Pilih tipe Qt di batas dengan QML,** standar C++ di dalam logika murni.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| `new` tanpa pemilik jelas | Kebocoran memori | `make_unique` atau induk Qt |
| Menyimpan pointer/referensi ke objek sementara | *Use-after-free* | Salin nilai, atau pastikan masa hidup |
| Mengembalikan referensi ke lokal | Perilaku tak terdefinisi | Kembalikan nilai |
| Lambda menangkap `[&]` lalu dijalankan nanti | Akses ke variabel mati | Tangkap salinan atau objek berumur panjang |
| Mengubah kontainer saat sedang diiterasi | Iterator tak valid | Salin dulu, atau pakai indeks/`erase`-`remove` |
| Definisi non-`inline` di header | Galat tautan *multiple definition* | Pindah ke `.cpp` atau tandai `inline` |
| Lupa menambah berkas `.cpp` ke CMake | `undefined reference` | Daftarkan di `qt_add_executable` |
| Objek tumpukan sebagai anak `QObject` | *Double free* | Alokasikan di heap, atau urutkan penghancuran |
| `delete` objek di dalam slotnya sendiri | *Crash* | `deleteLater()` |
| Mengira C++ bisa dikuasai dalam beberapa hari | Frustrasi dan bug | Sisihkan 8–12 minggu paruh waktu, latih tiap hari |

## Cek pemahaman: jawaban

**Mengapa `std::unique_ptr` lebih aman daripada `new` mentah?**
- **Kepemilikan tertulis di tipe.** `unique_ptr` menyatakan "tepat satu pemilik, dan dia yang menghancurkan". `new` mentah hanya mengembalikan alamat, sehingga siapa yang wajib `delete` hanya ada di kepala atau dokumentasi.
- **Pelepasan otomatis dan tahan galat.** Destruktor `unique_ptr` jalan saat cakupan berakhir, termasuk lewat `return` dini atau pengecualian. Dengan `new`, setiap jalur keluar harus ingat `delete`.
- **Kesalahan tak bisa ditulis.** `unique_ptr` tak bisa disalin, jadi *double delete* lewat salinan ditolak kompilator. Perpindahan harus eksplisit lewat `std::move`.
- Hasil akhirnya: kebocoran, *double free*, dan banyak *use-after-free* berhenti menjadi kemungkinan dan menjadi galat kompilasi.

## Referensi

*Modul ini sebagian besar C++ standar. Untuk bagian Qt, saya memeriksa dokumentasi Qt 6.12 (konversi tipe, registrasi tipe, `QRangeModel`, `SortFilterProxyModel`). Tautan lain mengikuti pola URL resmi.*

- **Dari kurikulum:** [learncpp.com](https://www.learncpp.com/) · [cppreference](https://en.cppreference.com/w/) · [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- **Smart pointer dan kepemilikan:** [std::unique_ptr](https://en.cppreference.com/w/cpp/memory/unique_ptr) · [std::shared_ptr](https://en.cppreference.com/w/cpp/memory/shared_ptr) · [Object Trees & Ownership (Qt)](https://doc.qt.io/qt-6/objecttrees.html) · [QPointer](https://doc.qt.io/qt-6/qpointer.html) · [QScopedPointer](https://doc.qt.io/qt-6/qscopedpointer.html) · [QSharedPointer](https://doc.qt.io/qt-6/qsharedpointer.html)
- **Gaya Qt:** [QString](https://doc.qt.io/qt-6/qstring.html) · [QList](https://doc.qt.io/qt-6/qlist.html) · [Implicit Sharing](https://doc.qt.io/qt-6/implicit-sharing.html) · [Qt String Literals](https://doc.qt.io/qt-6/qstring.html#qs-string-literals) · [QDebug](https://doc.qt.io/qt-6/qdebug.html)
- **Lambda dan template:** [Lambda expressions](https://en.cppreference.com/w/cpp/language/lambda) · [Templates](https://en.cppreference.com/w/cpp/language/templates)
- **Build dan alat:** [Qt dengan CMake](https://doc.qt.io/qt-6/cmake-get-started.html) · [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) · [clangd](https://clangd.llvm.org/) · [clazy](https://github.com/KDE/clazy) · [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)
- **Pratinjau Fase 10:** [Data Type Conversion QML↔C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html) · [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) · [QRangeModel](https://doc.qt.io/qt-6/qrangemodel.html) · [SortFilterProxyModel (QML)](https://doc.qt.io/qt-6/qml-qtqml-models-sortfilterproxymodel.html)

---

# Audit Singkat Modul 10.2

**Terverifikasi benar**
- Sintaks `Q_PROPERTY(... READ ... WRITE ... NOTIFY ... FINAL)` valid. Dokumentasi menegaskan `NOTIFY` perlu ada agar properti dapat dipakai dalam binding QML.
- Peringatan "setter tanpa memeriksa nilai sama" tepat. Sinyal `NOTIFY` hanya boleh dipancarkan bila nilai benar-benar berubah, supaya binding tidak dievaluasi ulang tanpa perlu. Pemeriksaan yang sama juga mencegah putaran tak berujung pada koneksi siklik.
- Peringatan "lupa `Q_OBJECT`" tepat. Tautan yang gagal dengan pesan `undefined reference to vtable` biasanya berarti kode hasil moc tak dikompilasi atau tak ditautkan.
- Jenis koneksi *direct* dan *queued* memang dasar. Pada koneksi queued, kode setelah `emit` langsung berlanjut dan slot dijalankan belakangan.

**Perlu penajaman atau penambahan**
1. **Atribut `Q_PROPERTY` terlalu sedikit.** Kurikulum hanya memuat `READ`, `WRITE`, `NOTIFY`, `FINAL`. Tambahkan:
   - `MEMBER`
   - `RESET`
   - `CONSTANT`
   - `REQUIRED`
   - `REVISION`
   - `BINDABLE` (sejak 6.0)
   - `FINAL`, `VIRTUAL`, `OVERRIDE`

   `CONSTANT` tidak boleh punya `WRITE` ataupun `NOTIFY`. `REQUIRED` tidak dipaksakan moc, tetapi di QML kelas dengan properti `REQUIRED` tak bisa dibuat sebelum semua properti itu diisi. `FINAL`, `VIRTUAL`, dan `OVERRIDE` belum dipaksakan moc, dan terutama dipakai oleh runtime QML dan alat bantu.
2. **Pengecualian `NOTIFY` yang halus.** `NOTIFY` terpancar otomatis saat properti diubah lewat API Qt (`setProperty`, `QMetaProperty`), tetapi tidak saat Anda mengubah anggota `MEMBER` secara langsung. Ini jebakan nyata.
3. **Properti terikat Qt 6 (belum ada di kurikulum).** `QProperty`, `Q_OBJECT_BINDABLE_PROPERTY`, dan `BINDABLE` adalah jalur modern. `Q_PROPERTY` tanpa `BINDABLE` pun bisa dipakai dalam binding C++ asal punya `NOTIFY`, lewat pembungkus `QBindable`. Saya tambahkan sebagai 10.2.7.
4. **Batasan moc.** Kelas template tak bisa memakai `Q_OBJECT`. Pada pewarisan ganda, `QObject` harus yang pertama. Pointer fungsi tak boleh jadi parameter signal/slot. Enum dan typedef di signal/slot harus dikualifikasi penuh. Kelas bersarang tak boleh punya signal/slot. Masuk ke 10.2.1.
5. **Keluarga cara `connect` terlalu sempit.** Tambahkan:
   - sintaks pointer fungsi vs string
   - lambda dengan objek konteks
   - sinyal berlebih (*overload*) lewat `qOverload`
   - `Qt::UniqueConnection`
   - `QT_NO_KEYWORDS` dengan `Q_SIGNALS`/`Q_SLOTS`/`Q_EMIT`
6. **Kepemilikan lebih luas dari "induk menghancurkan anak".** `QQuickItem` memiliki *induk visual* yang bisa berbeda dari induk `QObject`. Objek yang dikembalikan dari method C++ ke QML bisa berpindah kepemilikan ke mesin QML. Kedua hal ini ada di 10.2.5.
7. **Kata penutup 10.2.6.** Daftar isi merujuk ke Modul 10.7. Di sini hanya dasar aturannya. Detail thread menunggu 10.7.
8. **Pengujian.** Kurikulum belum menyebut pengujian sinyal (`QSignalSpy`). Saya tambahkan di 10.2.8.

## Daftar isi Modul 10.2 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 10.2.1 | `Q_OBJECT` dan MOC (+ batasan moc, AUTOMOC, melihat keluaran moc) |
| 10.2.2 | `Q_PROPERTY` lengkap dengan `NOTIFY` (+ `MEMBER`, `CONSTANT`, `RESET`, `REQUIRED`, properti dinamis, `Q_ENUM`) |
| 10.2.3 | Signal dan slot (+ gaya `connect`, lambda dan konteks, *overload*, putus koneksi) |
| 10.2.4 | `Q_INVOKABLE` (+ slot vs invokable, `invokeMethod`) |
| 10.2.5 | Hierarki objek dan kepemilikan (+ induk visual, kepemilikan ke QML) |
| 10.2.6 | Jenis koneksi dan *thread affinity* (pengantar; detail di 10.7) |
| 10.2.7 | Properti terikat Qt 6: `BINDABLE`, `QProperty` `[TAMBAHAN]` |
| 10.2.8 | Introspeksi meta-object, `qobject_cast`, dan uji sinyal `[TAMBAHAN]` |
| 10.2.9 | Lab terpadu: `Backend` yang siap diekspos ke QML `[TAMBAHAN]` |

---

# Modul 10.2 — QObject, Meta-Object, Properti, dan Signal/Slot

## Deskripsi dan peran dalam kurikulum

Modul 10.1 memberi Anda C++ yang aman. Modul ini memberi **kemampuan yang membuat C++ bisa "dilihat" oleh QML**. QML tidak membaca kode C++ Anda. Ia membaca *metadata*: nama properti, nama signal, nama method, dan cara memanggilnya. Metadata itu dibuat oleh moc dari kelas `QObject` Anda. Tanpa fondasi ini, 10.3 (registrasi tipe), 10.4 (pemakaian dari QML), 10.5 (model), dan 10.7 (thread) tidak punya pijakan.

## Konsep kunci dan filosofi

**Analogi.** MOC membaca kelas Anda dan membuat kartu identitas (meta-object). Di kartu itu tercatat nama kelas, daftar properti, signal, dan method, serta "cara memanggil" masing-masing. QML hanya membaca kartu itu. Tanpa kartu, QML tidak bisa melihat apa pun di dalam kelas.

```
                      (waktu build)                       (waktu berjalan)
backend.h --moc--> moc_backend.cpp ---+                  QML / invokeMethod /
 (Anda tulis)      (kartu identitas)  +-- link -> prog -> setProperty / connect
backend.cpp --compile--> backend.o ---+                  membaca kartu itu
```

**Tiga pilar** (kelas dasar `QObject`, makro `Q_OBJECT`, dan Meta-Object Compiler `moc`). Hasilnya: signal-slot, properti, introspeksi tipe saat berjalan, dan terjemahan teks. Semua fitur itu ada di satu kerangka yang sama.

**Pola komunikasi "properti, signal, perintah".** Rancang backend untuk QML dengan tiga hal:

```
 QML  --(baca/ikat)-->  PROPERTI  (keadaan)         + NOTIFY: "keadaan berubah"
 QML  --(panggil)---->  Q_INVOKABLE (perintah)
 C++  --(emit)------->  SIGNAL (peristiwa/hasil)    ke QML/C++ lain
```

**Pondasi sintaks yang dipakai**
- `class X : public QObject`: pewarisan publik dari `QObject`.
- `signals:` / `slots:` / `emit`: kata kunci buatan Qt (makro biasa) yang dibaca moc.
- `&Kelas::anggota`: pointer ke fungsi anggota (dipakai oleh `connect`).
- `Q_...`: makro yang dibaca moc (bukan C++ murni).

## 10.2.1 `Q_OBJECT` dan MOC

> *Satu makro kecil membuka seluruh dunia Qt.*

**Konsep.** `Q_OBJECT` memberi tahu moc: "baca kelas ini dan buatkan kartunya". Dokumentasi menyarankan semua subkelas `QObject` memakai `Q_OBJECT`, meski belum memakai signal, slot, atau properti, karena tanpa itu `QMetaObject::className()` hanya melaporkan nama leluhur terdekat yang bermeta-kode.

**Apa saja yang didapat dari `Q_OBJECT`:** `metaObject()`, `className()`, `inherits()`, `tr()` untuk terjemahan, `setProperty()`/`property()`, serta `qobject_cast`.

```cpp
class Backend : public QObject
{
    Q_OBJECT                       // ← baris ini yang dibaca moc
public:
    explicit Backend(QObject *parent = nullptr) : QObject(parent) {}
};
```

**Bedah kode**
- `class Backend : public QObject`: pewarisan dari `QObject` (wajib untuk `Q_OBJECT`).
- `Q_OBJECT` diperluas preprosesor menjadi deklarasi fungsi (mis. `metaObject()`, `qt_metacall`) yang *definisinya* dibuatkan moc.
- `explicit Backend(QObject *parent = nullptr)`: konstruktor standar Qt. Parameter `parent` menyambung ke pohon kepemilikan (10.2.5), dan `explicit` mencegah konversi implisit.

**Build dan moc**
- Dengan CMake, `qt_standard_project_setup()` mengaktifkan `AUTOMOC`. Dengan `AUTOMOC` aktif, CMake memindai berkas header dan sumber saat build lalu menjalankan moc seperlunya. Anda tidak menjalankan moc manual.
- Kelas `Q_OBJECT` yang dideklarasikan di berkas `.cpp` perlu `#include "namaberkas.moc"` di akhir berkas itu.
- Dokumentasi menyarankan memasukkan berkas moc di akhir berkas sumber yang bersangkutan, karena kode moc ikut dikompilasi bersama kodenya dan header tak diparsing dua kali. Moc yang tak disertakan dikumpulkan CMake dalam satu berkas `mocs_compilation.cpp`.

**Melihat sendiri apa yang dibuat moc**

```bash
# lokasi biner moc di Arch bisa dicek dengan: pacman -Ql qt6-base | rg '/moc$'
/usr/lib/qt6/moc backend.h -o moc_backend.cpp
rg 'QMetaObject::activate|staticMetaObject' moc_backend.cpp | head
# atau cari keluaran AUTOMOC di direktori build:
find build -name 'moc_backend.cpp'
```

Di berkas itu Anda akan melihat bahwa memanggil sebuah signal sama dengan memanggil fungsi buatan moc yang meneruskan ke `QMetaObject::activate(...)`. Kata `emit` hanya dekorasi: signal otomatis dibuat moc dan tidak boleh Anda implementasikan di berkas `.cpp`.

**Batasan moc (wajib dihafal)**
- Kelas template tak bisa memakai `Q_OBJECT`. Pewarisan ganda: `QObject` harus yang pertama.
- Pointer fungsi tidak boleh menjadi parameter signal/slot.
- Enum/typedef di signal/slot dikualifikasi penuh (`MyClass::Error`).
- Kelas bersarang tak boleh punya signal/slot.
- Hanya signal dan slot yang boleh di bagian `signals:`/`slots:`.

**Opsi lain**
- **`Q_GADGET`:** metadata untuk struct/kelas nilai tanpa `QObject` (properti dan enum, tanpa signal).
- **`Q_NAMESPACE`:** enum dalam namespace.
- Keduanya muncul lagi di 10.3/10.4.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| `undefined reference to vtable for X` | Header belum ada di target CMake, `AUTOMOC` mati, atau lupa `#include "x.moc"` untuk kelas di `.cpp` |
| `Q_OBJECT` pada template | Pisahkan: basis non-template ber-`Q_OBJECT`, template di bawahnya |
| Kata `signals`/`slots` bentrok dengan pustaka lain | Pakai `QT_NO_KEYWORDS` dan `Q_SIGNALS`/`Q_SLOTS`/`Q_EMIT` (10.2.3) |
| Mengubah header lalu moc tak ikut | Bersihkan build dan konfigurasi ulang; periksa `AUTOMOC` |

## 10.2.2 `Q_PROPERTY` lengkap dengan `NOTIFY`

> *Properti yang jujur selalu memberi kabar saat berubah.*

**Konsep.** Properti Qt adalah "anggota data dengan kemampuan tambahan": bisa dibaca/ditulis lewat nama (string), bisa diamati perubahannya, dan bisa diikat di QML. Ia ada di meta-object, bukan sekadar di kelas C++.

**Sintaks lengkap** (`READ`, `WRITE`, `MEMBER`, `RESET`, `NOTIFY`, `REVISION`, `DESIGNABLE`, `SCRIPTABLE`, `STORED`, `USER`, `BINDABLE`, `CONSTANT`, `FINAL`, `VIRTUAL`, `OVERRIDE`, `REQUIRED`):

```cpp
Q_PROPERTY(QString pesan  READ pesan WRITE setPesan NOTIFY pesanChanged FINAL)  // klasik
Q_PROPERTY(QString nama   MEMBER m_nama NOTIFY namaChanged)                      // tanpa getter/setter
Q_PROPERTY(int     versi  READ versi CONSTANT)                                   // tak pernah berubah
Q_PROPERTY(int     batas  READ batas WRITE setBatas RESET resetBatas NOTIFY batasChanged)
Q_PROPERTY(QString kunci  READ kunci WRITE setKunci NOTIFY kunciChanged REQUIRED)
```

**Aturan tiap atribut**

| Atribut | Aturan |
| --- | --- |
| `READ` | Wajib bila tak ada `MEMBER`. Idealnya fungsi `const` yang mengembalikan tipe properti atau referensi `const` ke tipe itu. |
| `WRITE` | Opsional. Mengembalikan `void` dan menerima tepat satu argumen. Properti hanya-baca tak punya `WRITE`. |
| `MEMBER` | Menjadikan anggota data terbaca dan tertulis tanpa getter/setter. `NOTIFY` untuk `MEMBER` menerima nol atau satu parameter bertipe sama. |
| `RESET` | Fungsi `void` tanpa parameter yang mengembalikan properti ke nilai bawaan kontekstual. |
| `NOTIFY` | Signal yang dipancarkan **hanya bila nilai berubah**. |
| `CONSTANT` | Nilai tak berubah selama objek hidup. Tak boleh punya `WRITE` atau `NOTIFY`. |
| `REQUIRED` | Pengguna kelas harus mengisinya. Tidak dipaksakan moc, tetapi dipaksakan saat membuat objek di QML. |
| `REVISION` | Properti ada sejak versi API tertentu (10.3). |

**Bedah kode setter standar (dari kurikulum, dengan alasan)**

```cpp
void Backend::setPesan(const QString &p)
{
    if (m_pesan == p) return;      // (1) tak ada perubahan = tak ada sinyal
    m_pesan = p;                   // (2) ubah nilai SEBELUM memberi kabar
    emit pesanChanged();           // (3) beri tahu pengamat (binding QML, koneksi)
}
```

1. Tanpa pemeriksaan nilai sama, binding QML dievaluasi ulang tanpa perlu, bahkan bisa berputar tak berujung pada koneksi siklik.
2. Urutan penting: pengamat yang dipanggil oleh `emit` akan membaca nilai baru.
3. `emit` hanyalah dekorasi, lalu panggilan fungsi buatan moc.

**Properti dinamis dan akses lewat nama**

```cpp
b.setProperty("pesan", QStringLiteral("halo"));   // lewat WRITE: sinyal NOTIFY terpancar
qDebug() << b.property("pesan");                   // QVariant("halo")
b.setProperty("catatan", 42);                      // properti BARU per-instans (dinamis); mengembalikan false
```

`setProperty` dengan nama yang belum ada menambahkan properti dinamis pada instans itu, tetapi tetap mengembalikan `false`, jadi `false` tak berarti gagal. Akses lewat `WRITE` langsung lebih cepat dan memberi diagnosis saat kompilasi, sedangkan akses lewat nama berguna bila kelasnya tak diketahui saat kompilasi.

**Enum dan `Q_ENUM`**

```cpp
enum class Status { Siap, Sibuk };
Q_ENUM(Status)                     // daftarkan ke meta-object (wajib bila dipakai di QML)
Q_PROPERTY(Status status READ status NOTIFY statusChanged FINAL)
```

`Q_ENUM` membuat nama enumerator tersedia sebagai string untuk `setProperty`. Penggunaannya di QML dibahas di 10.3/10.4.

**Jenis tipe properti.** Tipenya bisa tipe apa pun yang didukung `QVariant` atau tipe kustom yang terdaftar (`Q_DECLARE_METATYPE`). `QMap` dan `QList` sebagai tipe properti adalah sinonim `QVariantMap` dan `QVariantList` karena alasan historis.

**Opsi lain**
- **`MEMBER` + `NOTIFY`:** sangat ringkas, tetapi perubahan lewat anggota langsung tidak memancarkan sinyal, jadi gunakan setter sendiri atau `BINDABLE` (10.2.7).
- **`CONSTANT`:** untuk objek yang dibuat sekali (konfigurasi, singleton).
- **Properti hanya-baca turunan:** `READ` + `NOTIFY` tanpa `WRITE`, diubah oleh logika internal.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Properti tanpa `NOTIFY` | Binding QML tak pernah diperbarui | Tambah `NOTIFY`, atau `CONSTANT` bila memang tetap |
| `emit` tanpa mengubah nilai dulu | Pengamat membaca nilai lama | Ubah nilai, lalu `emit` |
| `emit` walau nilai sama | Evaluasi ulang berlebih | `if (sama) return;` |
| Mengubah anggota `MEMBER` langsung | Tak ada sinyal | Gunakan setter, atau `setProperty`/`BINDABLE` |
| `NOTIFY` menunjuk signal yang tak ada | Galat moc | Deklarasikan signal di bagian `signals:` |
| Memakai `WRITE` untuk `CONSTANT` | Galat moc/logika | `CONSTANT` tak boleh `WRITE`/`NOTIFY` |
| Getter yang mengubah keadaan | Perilaku tak terduga | Getter `const` dan murni |

## 10.2.3 Signal dan slot

> *Siapa pun boleh mendengar. Pemancar tak perlu tahu siapa.*

**Konsep.** Signal adalah *peristiwa* yang dipancarkan objek saat keadaannya berubah. Slot adalah fungsi yang dipanggil sebagai tanggapan. Mekanismenya bersifat longgar: pemancar tak tahu dan tak peduli siapa penerimanya. Tanda tangan signal harus cocok dengan slot, kecuali slot boleh menerima argumen lebih sedikit karena mengabaikan sisanya.

```cpp
class Pencacah : public QObject
{
    Q_OBJECT
public:
    explicit Pencacah(QObject *parent = nullptr) : QObject(parent) {}
    int nilai() const { return m_nilai; }

public slots:
    void setNilai(int n)
    {
        if (n == m_nilai) return;       // cegah putaran tak berujung
        m_nilai = n;
        emit nilaiChanged(n);
    }

signals:
    void nilaiChanged(int nilaiBaru);

private:
    int m_nilai = 0;
};

// Pemakaian:
Pencacah a, b;
QObject::connect(&a, &Pencacah::nilaiChanged, &b, &Pencacah::setNilai);
a.setNilai(12);     // a.nilai() == 12 dan b.nilai() == 12
b.setNilai(48);     // b == 48, a tetap 12 (tak ada koneksi balik)
```

**Bedah kode**
- `public slots:` menandai fungsi yang bisa disambungkan sebagai penerima. Slot adalah fungsi C++ biasa yang juga bisa dipanggil langsung.
- `signals:` menandai signal. Tak ada badan fungsi yang Anda tulis. Argumen menyatakan data yang dibawa.
- `emit nilaiChanged(n)` memicu semua koneksi.
- `QObject::connect(pemancar, &Kelas::signal, penerima, &Kelas::slot)` menyambung. Argumen kedua dan keempat adalah pointer fungsi anggota.
- Setter dengan `if (n == m_nilai) return;` mencegah *loop* bila ada koneksi siklik.

**Aturan eksekusi.** Slot yang tersambung pada satu signal dijalankan satu per satu sesuai urutan penyambungannya. Pada koneksi biasa, kode setelah `emit` baru berjalan setelah semua slot selesai. Memancarkan signal sekitar sepuluh kali lebih lambat dari pemanggilan langsung, namun jauh lebih murah dari satu `new`/`delete`, sehingga perbedaannya tak berarti pada aplikasi nyata.

**Gaya `connect`**

```cpp
// (1) Pointer fungsi anggota: diperiksa SAAT KOMPILASI (direkomendasikan)
connect(a, &Pencacah::nilaiChanged, b, &Pencacah::setNilai);

// (2) Lambda + objek konteks 'this'
connect(a, &Pencacah::nilaiChanged, this, [this](int n) { m_log.append(n); });

// (3) Memilih salah satu overload
connect(sumber, &Sumber::berubah, tujuan, qOverload<int>(&Tujuan::tampil));

// (4) Gaya string lama: diperiksa saat BERJALAN
connect(a, SIGNAL(nilaiChanged(int)), b, SLOT(setNilai(int)));

// (5) Flag koneksi
connect(a, &Pencacah::nilaiChanged, b, &Pencacah::setNilai, Qt::UniqueConnection);
connect(a, &Pencacah::nilaiChanged, this, [](int){ /* ... */ }, Qt::SingleShotConnection); // ≥ 6.0

// (6) Memutus
QMetaObject::Connection ikatan = connect(a, &Pencacah::nilaiChanged, b, &Pencacah::setNilai);
disconnect(ikatan);
```

**Bedah ringkas**
- **Gaya 1** adalah yang utama. Kompilator memeriksa kecocokan argumen dan bahkan boleh mengkonversinya secara implisit.
- **Gaya 2:** objek konteks (`this`) memastikan lambda terputus saat konteks dihancurkan, dan menentukan thread tempat penerima dijalankan. Pastikan semua objek yang dipakai di dalam lambda masih hidup saat sinyal dipancarkan.
- **Gaya 3:** bila ada overload, pilih dengan `qOverload<...>()`, `static_cast`, atau bungkus dalam lambda.
- **Gaya 4:** tidak diperiksa kompilator, dan salah ketik baru ketahuan saat berjalan.
- **Gaya 5:** `Qt::UniqueConnection` hanya membuat koneksi bila belum ada duplikat; bila ada, `connect` mengembalikan `false`. Flag ini tidak bisa dipakai dengan lambda.
- **Gaya 6:** simpan `QMetaObject::Connection` bila ingin memutus satu koneksi tertentu.

**Manajemen koneksi otomatis.** Koneksi terputus otomatis bila pemancar atau penerima dihancurkan. Satu catatan: sinyal masih bisa terkirim saat pemusnahan, setelah destruktor kelas turunan selesai tetapi sebelum `~QObject`; pertimbangkan memutus eksplisit di destruktor bila perlu.

**Mencari pemancar.** `QObject::sender()` mengembalikan pemancar dalam sebuah slot. Lambda yang menangkap objek pemancar sering lebih jelas.

**Koneksi sinyal ke sinyal.** Sinyal bisa disambungkan langsung ke sinyal lain, yang memancarkan sinyal kedua seketika.

**Bila pustaka lain memakai kata `signals`/`slots`/`emit`.** Definisikan `QT_NO_KEYWORDS` (di CMake: `target_compile_definitions(app PRIVATE QT_NO_KEYWORDS)`) dan gunakan `Q_SIGNALS`, `Q_SLOTS`, dan `Q_EMIT`. API publik pustaka berbasis Qt sebaiknya memakai `Q_SIGNALS`/`Q_SLOTS`.

**Opsi lain**
- **Fungsi anggota biasa:** dengan gaya pointer fungsi, penerima tak harus berstatus slot. Setiap fungsi anggota bisa disambungkan.
- **Fungsi bebas atau functor:** `connect` juga menerima functor dan lambda C++11.
- **Slot virtual:** diizinkan (dokumentasi menyebut berguna dalam praktik), tetapi pakai seperlunya.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Lambda tanpa objek konteks, menangkap `this` | Selalu beri konteks (`this` atau objek penerima) |
| `[&]` pada lambda yang dijalankan nanti | Tangkap salinan atau objek berumur panjang (10.1.4) |
| Koneksi ganda tak sengaja | `Qt::UniqueConnection` (bukan untuk lambda), atau sambung sekali di konstruktor |
| Setter tanpa pemeriksaan nilai sama + koneksi siklik | `if (sama) return;` |
| String-based `SIGNAL/SLOT` salah ketik | Pindah ke pointer fungsi |
| Menaruh logika berat di slot | Pindahkan ke thread kerja (10.7) |

## 10.2.4 `Q_INVOKABLE`

> *Perintah yang jelas membuat antarmuka tak perlu menebak.*

**Konsep.** `Q_INVOKABLE` menandai method biasa agar tercatat di meta-object, sehingga bisa dipanggil dari QML dan lewat `QMetaObject::invokeMethod`. Slot pun bisa dipanggil dari QML, tetapi `Q_INVOKABLE` tak perlu berada di bagian `slots:` dan cocok untuk "perintah dari UI".

| Mekanisme | Dipanggil dari QML? | Bisa disambungkan sebagai penerima? | Dipakai untuk |
| --- | --- | --- | --- |
| `Q_INVOKABLE void f()` | Ya | Ya (pointer fungsi), tak berstatus slot | Perintah dari UI |
| `public slots: void f()` | Ya | Ya (termasuk gaya string) | Penerima sinyal |
| Fungsi biasa | Tidak | Ya (pointer fungsi) | Logika internal |

```cpp
class Backend : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void tambah();                       // perintah tanpa nilai kembali
    Q_INVOKABLE int  tambahDengan(int n);            // dengan parameter dan hasil
    Q_INVOKABLE QString format(int nilai) const;     // const bila tak mengubah objek
};
```

**Pemanggilan dari C++ lewat meta-object**

```cpp
QMetaObject::invokeMethod(&b, "tambah");                       // lewat nama
QString hasil;
QMetaObject::invokeMethod(&b, "format", Q_RETURN_ARG(QString, hasil), Q_ARG(int, 5));
```

**Bedah kode**
- `invokeMethod(objek, "nama")` mencari method bernama itu di meta-object dan memanggilnya. Nama harus persis, dan method harus `Q_INVOKABLE` atau slot.
- `Q_RETURN_ARG(tipe, variabel)` menampung hasil, `Q_ARG(tipe, nilai)` meneruskan argumen. Qt 6 punya bentuk baru yang lebih ringkas untuk argumen. Periksa dokumentasi `QMetaObject::invokeMethod`.
- Dari QML, panggilannya biasa saja: `backend.tambahDengan(5)` (10.4).

**Tentang tipe parameter dan hasil.** Hanya tipe yang dikenali sistem meta-tipe (dasar Qt, `QVariant`, `QObject*`, tipe terdaftar) yang bisa melintasi QML. Mengembalikan `QObject*` tanpa induk berimplikasi kepemilikan: mesin QML mengambil alih objek yang dikembalikan dari method C++ eksplisit, kecuali ia punya induk atau Anda menetapkan `CppOwnership`. Dibahas penuh di 10.4.

**Konvensi desain**
- **Properti** untuk keadaan, **signal** untuk peristiwa, **`Q_INVOKABLE`** untuk perintah.
- Nama perintah berupa kata kerja (`tambah`, `muatUlang`), dan nama signal berupa kejadian lampau atau `xxxChanged`.
- Jangan membuat perintah yang memblokir. Pekerjaan lama menjadi asinkron dan hasilnya lewat signal (10.7).

**Jebakan dan solusi.** Method `Q_INVOKABLE` yang berat dan sinkron akan membekukan UI. `invokeMethod` dengan nama salah mengembalikan `false` tanpa galat kompilasi, jadi periksa hasilnya. Parameter bertipe tak terdaftar tidak bisa dipanggil dari QML.

## 10.2.5 Hierarki objek dan kepemilikan

> *Kepemilikan yang jelas adalah akar dari program yang tidak bocor.*

**Konsep.** Dari 10.1.8: `QObject` yang dibuat dengan induk ditambahkan ke daftar `children()` induknya dan dihapus saat induknya dihapus. Anda juga boleh menghapus anak sendiri, dan ia otomatis melepas dirinya dari induk.

```
 induk (QObject)
  |-- anak1 (Backend)
  '-- anak2 (QObject)
 delete induk  -->  anak1 dan anak2 ikut dihancurkan (tak ada delete manual)
```

```cpp
static void cetakPohon(const QObject *o, int tingkat = 0)
{
    qDebug().noquote() << QStringLiteral("%1%2 (%3)")
        .arg(QString(tingkat * 2, u' '), o->objectName(),
             QString::fromUtf8(o->metaObject()->className()));
    for (const QObject *anak : o->children())
        cetakPohon(anak, tingkat + 1);
}
```

**Bedah kode**
- `o->children()` mengembalikan daftar anak langsung.
- `QString(tingkat * 2, u' ')` membuat spasi sebanyak indentasi.
- `QStringLiteral("%1%2 (%3)").arg(...)` merakit baris cetakan dengan tiga penanda posisi.
- `o->metaObject()->className()` mengambil nama kelas asli dari meta-object. Ini dasar dari 10.2.1.

**Aturan urutan penghancuran.** Untuk objek di heap, pohon dapat dibangun dan dihancurkan dalam urutan apa pun. Untuk objek di tumpukan, hati-hati: bila induk dibuat setelah anak, induk dihancurkan lebih dulu dan menghapus anak yang ada di tumpukan, lalu anak dihancurkan lagi. Solusinya: buat induk lebih dulu di tumpukan, atau alokasikan anak di heap.

**`QQuickItem` istimewa.** `QQuickItem` memiliki induk visual yang bisa berbeda dari induk `QObject`. Jadi `parent` di QML (induk visual) dan `parent()` di C++ (induk `QObject`) bisa menunjuk objek berbeda. Jangan campurkan keduanya.

**Kepemilikan lintas C++/QML**
- **Data dari C++ ke QML:** kepemilikan tetap di C++, kecuali `QObject` yang dikembalikan dari pemanggilan method C++ eksplisit.
- Mesin QML tak pernah menghapus `QObject` yang punya induk.
- **Aturan praktis:** beri induk pada setiap `QObject` yang Anda berikan ke QML, atau daftarkan sebagai singleton milik mesin (10.3).

**Alat bantu debug.** `dumpObjectTree()` dan `dumpObjectInfo()` berguna saat aplikasi bertingkah aneh. Fungsi ini hanya mencetak bila Qt dibangun dalam mode debug. `cetakPohon` di atas bekerja di semua build.

**Opsi lain**
- `deleteLater()` untuk menghapus objek dengan aman dari dalam slotnya sendiri (10.1.8).
- `QPointer<T>` untuk penunjuk yang menjadi null otomatis.
- `setParent()` untuk memindahkan kepemilikan.

**Jebakan dan solusi.** Objek tumpukan sebagai anak dengan urutan terbalik berarti *double free*. Memberi induk pada objek yang juga dibungkus `unique_ptr` akan menghapusnya dua kali. `QObject` yang dikembalikan tanpa induk dari `Q_INVOKABLE` bisa dihapus oleh GC QML saat Anda masih memakainya.

## 10.2.6 Jenis koneksi dan *thread affinity* (pengantar)

> *Tahu di thread mana sebuah objek hidup sudah separuh dari konkurensi.*

**Konsep.** Setiap `QObject` "tinggal" di satu thread (*thread affinity*). Jenis koneksi menentukan di thread mana slot dijalankan.

| Jenis | Perilaku | Catatan |
| --- | --- | --- |
| `Qt::AutoConnection` (bawaan) | Langsung bila pemancar dan penerima di thread yang sama saat emit, selain itu antre | Pilihan biasa |
| `Qt::DirectConnection` | Slot dipanggil langsung di thread pemancar | Hati-hati data bersama |
| `Qt::QueuedConnection` | Dikirim sebagai event ke event loop thread penerima | Kode setelah `emit` langsung berlanjut. |
| `Qt::BlockingQueuedConnection` | Seperti queued, tetapi pemancar menunggu | Bisa *deadlock* bila satu thread |
| `Qt::UniqueConnection` | Flag: cegah duplikat | Tidak untuk lambda |
| `Qt::SingleShotConnection` | Flag (≥ 6.0): putus setelah satu kali | |

```
 Thread utama (UI)              Thread kerja
 +----------------+  emit      +------------------+
 | Backend (UI)   | <--------- | hasil dihitung   |
 | slot dijalankan|  (queued)  | (tak menyentuh   |
 | di sini        |            |  objek UI)       |
 +----------------+            +------------------+
```

**Aturan inti yang sudah bisa Anda pegang sekarang**
- Objek QML/GUI hidup di thread utama. Jangan menyentuhnya dari thread lain.
- Komunikasi lintas thread lewat signal (koneksi queued otomatis), bukan memanggil method objek lain langsung.
- Tipe argumen sinyal untuk koneksi queued harus dikenal sistem meta-tipe (tipe kustom perlu didaftarkan).

Detail `QThread`, `moveToThread`, `QtConcurrent`, dan race condition ada di Modul 10.7.

## 10.2.7 Properti terikat Qt 6: `BINDABLE`, `QProperty` `[TAMBAHAN]`

> *Biarkan kode menghitung ulang dirinya sendiri, seperti binding QML.*

**Konsep.** Qt 6 membawa binding ala QML ke C++. Properti terikat bernilai konkret atau ditentukan oleh sebuah fungsi C++ (biasanya lambda), dan diperbarui otomatis saat dependensinya berubah. Pelacakan dependensi hanya bekerja pada properti terikat. Bila Anda memakai properti non-bindable dalam ekspresi binding, perubahannya tak memicu pembaruan, dan tak ada peringatan kompilasi maupun runtime.

```cpp
#include <QObject>
#include <QProperty>
#include <QBindable>

class Pengukur : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int lebar  READ lebar  WRITE setLebar  NOTIFY lebarChanged  BINDABLE bindableLebar)
    Q_PROPERTY(int tinggi READ tinggi WRITE setTinggi NOTIFY tinggiChanged BINDABLE bindableTinggi)
    Q_PROPERTY(int luas   READ luas   NOTIFY luasChanged BINDABLE bindableLuas)

public:
    explicit Pengukur(QObject *parent = nullptr) : QObject(parent)
    {
        m_luas.setBinding([this] { return m_lebar.value() * m_tinggi.value(); });
    }

    int lebar() const { return m_lebar.value(); }
    void setLebar(int v) { m_lebar = v; }
    QBindable<int> bindableLebar() { return &m_lebar; }

    int tinggi() const { return m_tinggi.value(); }
    void setTinggi(int v) { m_tinggi = v; }
    QBindable<int> bindableTinggi() { return &m_tinggi; }

    int luas() const { return m_luas.value(); }
    QBindable<int> bindableLuas() { return &m_luas; }

signals:
    void lebarChanged();
    void tinggiChanged();
    void luasChanged();

private:
    Q_OBJECT_BINDABLE_PROPERTY(Pengukur, int, m_lebar,  &Pengukur::lebarChanged)
    Q_OBJECT_BINDABLE_PROPERTY(Pengukur, int, m_tinggi, &Pengukur::tinggiChanged)
    Q_OBJECT_BINDABLE_PROPERTY(Pengukur, int, m_luas,   &Pengukur::luasChanged)
};
```

**Bedah kode**
- `BINDABLE bindableLebar` memberi tahu moc bahwa properti ini bisa diikat dan nama fungsinya mengembalikan `QBindable`.
- `Q_OBJECT_BINDABLE_PROPERTY(Kelas, Tipe, nama, &signal)` mendeklarasikan anggota terikat dan mendaftarkan signal sebagai penangan perubahan. Penangan inilah yang memancarkan `NOTIFY`. Karena itu setter tak perlu `emit`.
- `m_luas.setBinding([this] { ... })` menyatakan: `luas` selalu `lebar × tinggi`. Mengubah `lebar` memperbarui `luas` otomatis dan memancarkan `luasChanged`.
- `QBindable<int> bindableLebar()` membungkus anggota agar bisa diikat dari luar (QML atau C++).

**Aturan getter/setter terikat**
- Setiap jalur kode di getter harus membaca properti dan getter tak boleh menulisnya; gunakan getter trivial.
- Setiap jalur kode di setter harus menulis ke properti, walau nilainya tak berubah; kode lain di setter kemungkinan besar keliru karena tak berjalan saat nilai berubah lewat binding.
- Jangan memakai properti terikat sebagai variabel perantara, karena setiap nilai antara disiarkan ke pengamat; hitung di variabel biasa lalu tulis sekali.
- Sistem properti terikat tidak thread-safe. Jangan memindahkan objek ber-binding ke thread lain.
- Ekspresi binding tak boleh membaca atau menulis properti yang sedang diikatnya (loop evaluasi).

**Opsi lain.** Setter manual klasik (10.2.2) paling sederhana dan cukup untuk sebagian besar kasus. `QProperty<T>` berdiri sendiri (di luar `QObject`) memakai `setBinding`/`onValueChanged`. `READ default`/`WRITE default` menghasilkan akses dari `BINDABLE`, namun `WRITE` hasil generasi tak memancarkan `NOTIFY` secara eksplisit, jadi daftarkan sinyal sebagai penangan perubahan.

**Jebakan.** Mencampur properti bindable dan non-bindable dalam satu ekspresi binding menyebabkan pembaruan senyap yang hilang. Mengira `emit` masih perlu di setter, padahal penangan perubahan sudah memancarkannya. Memakai di atas thread tanpa memperhatikan keterbatasannya.

## 10.2.8 Introspeksi meta-object, `qobject_cast`, dan uji sinyal `[TAMBAHAN]`

> *Memeriksa yang tak terlihat adalah cara menemukan bug sebelum pengguna.*

**Introspeksi** adalah membaca meta-object saat berjalan, yang sama dengan yang dilakukan QML:

```cpp
const QMetaObject *mo = b.metaObject();
qDebug() << "kelas:" << mo->className();
for (int i = mo->propertyOffset(); i < mo->propertyCount(); ++i) {
    const QMetaProperty p = mo->property(i);
    qDebug() << " properti" << p.name() << p.typeName()
             << (p.hasNotifySignal() ? p.notifySignal().methodSignature() : QByteArray("-"));
}
```

**Bedah kode**
- `mo->propertyOffset()` melompati properti milik kelas induk (mis. `objectName` dari `QObject`), sehingga hanya properti kelas ini yang ditampilkan.
- `QMetaProperty` menyimpan nama, tipe, dan apakah ada sinyal `NOTIFY`.
- `p.notifySignal().methodSignature()` mengembalikan nama sinyal dalam bentuk teks.
- Hal yang sama berlaku untuk method (`methodOffset()`, `method(i)`) dan enum (`QMetaEnum::fromType<T>()`).

**`qobject_cast`.** Berperilaku seperti `dynamic_cast`, tetapi tak butuh RTTI dan bekerja lintas batas pustaka dinamis. Mengembalikan pointer valid bila tipenya cocok, selain itu `nullptr`. Pakai untuk mengubah `QObject*` ke tipe turunan dengan aman.

```cpp
if (auto *bk = qobject_cast<Backend *>(obj))
    bk->tambah();
```

**Menguji sinyal dengan `QSignalSpy` (QtTest)**

```cpp
// ujibackend.cpp
#include "backend.h"
#include <QSignalSpy>
#include <QTest>

class UjiBackend : public QObject
{
    Q_OBJECT
private slots:
    void tambahMemancarkanSinyal()
    {
        Backend b;
        QSignalSpy spy(&b, &Backend::hitunganChanged);
        b.tambah();
        QCOMPARE(spy.count(), 1);
    }
    void pesanSamaTidakMemancarkan()
    {
        Backend b;
        b.setPesan(QStringLiteral("x"));
        QSignalSpy spy(&b, &Backend::pesanChanged);
        b.setPesan(QStringLiteral("x"));
        QCOMPARE(spy.count(), 0);
    }
};

QTEST_MAIN(UjiBackend)
#include "ujibackend.moc"
```

```cmake
find_package(Qt6 REQUIRED COMPONENTS Core Test)
qt_add_executable(ujibackend ujibackend.cpp backend.cpp backend.h)
target_link_libraries(ujibackend PRIVATE Qt6::Core Qt6::Test)
enable_testing()
add_test(NAME ujibackend COMMAND ujibackend)
```

**Bedah kode**
- `QSignalSpy spy(&b, &Backend::hitunganChanged)` merekam setiap pemancaran signal itu. `spy.count()` menghitungnya.
- `private slots:` pada kelas uji: Qt Test menjalankan setiap slot privat sebagai satu kasus uji.
- `QTEST_MAIN(...)` menghasilkan `main()`. `#include "ujibackend.moc"` wajib karena kelas `Q_OBJECT` ada di `.cpp`.
- Uji kedua memastikan setter dengan nilai sama tidak memancarkan sinyal, yaitu aturan 10.2.2 yang diuji, bukan dihafal.

**Jalankan:** `cmake --build build && ctest --test-dir build --output-on-failure`.

## 10.2.9 Lab terpadu `[TAMBAHAN]`

Lab ini menjalankan semua materi tanpa QML dulu: properti, sinyal, `invokeMethod`, introspeksi, dan kepemilikan. Registrasi ke QML menyusul di 10.3. Latihan kurikulum (properti `int hitungan` + `Q_INVOKABLE tambah()`) ada di dalamnya.

```cpp
// backend.h
#pragma once
#include <QObject>
#include <QString>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString pesan READ pesan WRITE setPesan NOTIFY pesanChanged FINAL)
    Q_PROPERTY(int hitungan READ hitungan NOTIFY hitunganChanged FINAL)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged FINAL)

public:
    enum class Status { Siap, Sibuk };
    Q_ENUM(Status)

    explicit Backend(QObject *parent = nullptr) : QObject(parent) {}

    QString pesan() const { return m_pesan; }
    void setPesan(const QString &p);

    int hitungan() const { return m_hitungan; }
    Status status() const { return m_status; }

    Q_INVOKABLE void tambah();
    Q_INVOKABLE void muatUlang();

signals:
    void pesanChanged();
    void hitunganChanged();
    void statusChanged();
    void selesai(int hasil);

private:
    void setStatus(Status s);

    QString m_pesan;
    int m_hitungan = 0;
    Status m_status = Status::Siap;
};
```

```cpp
// backend.cpp
#include "backend.h"

void Backend::setPesan(const QString &p)
{
    if (m_pesan == p) return;
    m_pesan = p;
    emit pesanChanged();
}

void Backend::setStatus(Status s)
{
    if (m_status == s) return;
    m_status = s;
    emit statusChanged();
}

void Backend::tambah()
{
    ++m_hitungan;
    emit hitunganChanged();
    if (m_hitungan % 3 == 0)
        emit selesai(m_hitungan);
}

void Backend::muatUlang()
{
    setStatus(Status::Sibuk);
    setPesan(QStringLiteral("dimuat"));
    setStatus(Status::Siap);
}
```

```cpp
// main.cpp
#include "backend.h"
#include <QCoreApplication>
#include <QDebug>
#include <QMetaEnum>
#include <QMetaObject>
#include <QMetaProperty>
#include <QPointer>

static void cetakPohon(const QObject *o, int tingkat = 0)
{
    qDebug().noquote() << QStringLiteral("%1%2 (%3)")
        .arg(QString(tingkat * 2, u' '), o->objectName(),
             QString::fromUtf8(o->metaObject()->className()));
    for (const QObject *anak : o->children())
        cetakPohon(anak, tingkat + 1);
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    Backend b;

    // (1) sinyal -> lambda, dengan objek konteks
    QObject::connect(&b, &Backend::pesanChanged, &b,
                     [&b] { qDebug() << "pesan ->" << b.pesan(); });
    QObject::connect(&b, &Backend::selesai, &b,
                     [](int n) { qDebug() << "selesai pada hitungan" << n; });

    // (2) properti lewat nama (melewati WRITE; NOTIFY terpancar otomatis)
    b.setProperty("pesan", QStringLiteral("halo"));
    b.setProperty("pesan", QStringLiteral("halo"));    // sama: tak ada sinyal

    // (3) method Q_INVOKABLE lewat meta-object
    for (int i = 0; i < 3; ++i)
        QMetaObject::invokeMethod(&b, "tambah");       // pada ke-3: selesai(3)
    b.muatUlang();

    // (4) introspeksi
    const QMetaObject *mo = b.metaObject();
    qDebug() << "kelas:" << mo->className();
    for (int i = mo->propertyOffset(); i < mo->propertyCount(); ++i) {
        const QMetaProperty p = mo->property(i);
        qDebug() << " properti" << p.name() << p.typeName()
                 << (p.hasNotifySignal() ? p.notifySignal().methodSignature() : QByteArray("-"));
    }
    const auto me = QMetaEnum::fromType<Backend::Status>();
    qDebug() << "status:" << me.valueToKey(static_cast<int>(b.status()));

    // (5) kepemilikan induk-anak
    auto *induk = new QObject;
    induk->setObjectName(QStringLiteral("induk"));
    auto *anak1 = new Backend(induk);
    anak1->setObjectName(QStringLiteral("anak1"));
    auto *anak2 = new QObject(induk);
    anak2->setObjectName(QStringLiteral("anak2"));
    QPointer<QObject> pantau = anak2;
    cetakPohon(induk);
    delete induk;                                       // anak ikut dihapus
    qDebug() << "anak2 masih hidup?" << !pantau.isNull();
}
```

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.21)
project(lab102 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core)
qt_standard_project_setup()                       # menyalakan AUTOMOC

qt_add_executable(lab102 main.cpp backend.cpp backend.h)
target_link_libraries(lab102 PRIVATE Qt6::Core)
target_compile_options(lab102 PRIVATE -Wall -Wextra -Wpedantic)
```

```bash
cmake -S . -B build && cmake --build build && ./build/lab102
find build -name 'moc_backend.cpp'          # lihat kartu identitas buatan moc
```

**Perkiraan keluaran** (format tipe enum bisa sedikit berbeda):

```
pesan -> "halo"
selesai pada hitungan 3
pesan -> "dimuat"
kelas: Backend
 properti pesan QString "pesanChanged()"
 properti hitungan int "hitunganChanged()"
 properti status Status "statusChanged()"
status: Siap
induk (QObject)
  anak1 (Backend)
  anak2 (QObject)
anak2 masih hidup? false
```

**Bedah ringkas**
- Bagian (1): dua koneksi lambda dengan `&b` sebagai konteks, sehingga terputus otomatis bila `b` hancur.
- Bagian (2): `setProperty` memakai `WRITE`. Pengisian kedua (nilai sama) tak memancarkan sinyal berkat `if (m_pesan == p) return;`.
- Bagian (3): `invokeMethod` memanggil `Q_INVOKABLE` lewat nama. Sinyal `selesai(3)` terpancar tepat pada panggilan ketiga.
- Bagian (4): membaca kartu identitas, seperti yang dilakukan QML.
- Bagian (5): `delete induk` menghancurkan kedua anak, dan `QPointer` menjadi null otomatis.

**Latihan tambahan**
1. Tambahkan properti `bool aktif` bertipe `MEMBER` + `NOTIFY` dan buktikan bahwa mengubah anggota langsung tidak memancarkan sinyal.
2. Tambahkan properti `CONSTANT int versi` dan coba beri `WRITE`. Lihat galat moc.
3. Jalankan uji `QSignalSpy` dari 10.2.8 dan tambahkan satu kasus untuk sinyal `selesai`.
4. Ganti `hitungan` menjadi properti `BINDABLE` dan tambahkan properti turunan `ganjil` yang selalu mengikutinya.
5. Sengaja hapus `Q_OBJECT` dari `Backend` dan baca galat yang muncul.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **`QObject`** | Kelas dasar yang menyediakan induk-anak, signal-slot, dan properti |
| **`Q_OBJECT`** | Makro yang meminta moc membuat meta-objek kelas |
| **moc** | *Meta-Object Compiler*, membaca header dan menghasilkan kode metadata |
| **Meta-object** | Kartu identitas kelas: nama, properti, signal, method |
| **`Q_PROPERTY`** | Deklarasi properti yang terlihat oleh meta-object |
| **`NOTIFY`** | Signal pemberi kabar perubahan properti |
| **`CONSTANT` / `REQUIRED`** | Properti tak berubah / wajib diisi saat dibuat di QML |
| **`BINDABLE`** | Properti yang mendukung binding C++ (`QProperty`) |
| **Signal / slot** | Peristiwa yang dipancarkan / fungsi penanggap |
| **`emit`** | Kata dekorasi saat memanggil signal |
| **`Q_INVOKABLE`** | Method yang bisa dipanggil lewat meta-object (QML, `invokeMethod`) |
| **Objek konteks** | Argumen ketiga `connect` yang menentukan umur koneksi dan thread penerima |
| **Thread affinity** | Thread tempat sebuah `QObject` hidup |
| **Direct / queued** | Panggilan langsung / dikirim lewat event loop |
| **`qobject_cast`** | *Cast* aman untuk `QObject` tanpa RTTI |
| **Introspeksi** | Membaca meta-object saat berjalan |
| **Properti dinamis** | Properti yang ditambahkan per instans lewat `setProperty` |

## Hubungan dengan modul lain

- **Prasyarat:** 10.1 (RAII, `const`, lambda, header/sumber, pohon induk-anak), 8.3 (CMake).
- **Menjadi dasar untuk:** 10.3 (`QML_ELEMENT` mendaftarkan kelas `QObject` ini), 10.4 (QML membaca properti, memanggil `Q_INVOKABLE`, mendengar sinyal), 10.5 (`QAbstractListModel` adalah `QObject` dengan sinyal `beginInsertRows` dst.), 10.6 (`QProcess` memancarkan sinyal selesai), 10.7 (koneksi queued dan thread affinity).
- **Menyambung ke:** 9.4 (`tr()` dari `Q_OBJECT` untuk terjemahan di C++).

## Tips dan praktik terbaik

1. **Satu aturan untuk setiap properti:** `READ` const, setter memeriksa nilai sama, `NOTIFY` hanya saat benar-benar berubah.
2. **Beri `FINAL` pada properti** yang tak akan di-*override* (dianjurkan dokumentasi QML).
3. **Properti = keadaan, signal = peristiwa, `Q_INVOKABLE` = perintah.** Jangan campur peran.
4. **Pakai sintaks pointer fungsi** untuk `connect`, dan selalu beri objek konteks pada lambda.
5. **Beri `Q_OBJECT` pada semua subkelas `QObject`,** bahkan yang sederhana.
6. **Jangan emit dari luar kelas pemilik signal** (signal itu publik secara teknis, tetapi sebaiknya dipancarkan dari kelasnya sendiri).
7. **Beri induk pada setiap objek yang diserahkan ke QML,** atau daftarkan sebagai singleton (10.3).
8. **Uji sinyal dengan `QSignalSpy`** agar kontrak "kapan kabar dikirim" terjaga.
9. **Bangun dengan peringatan dan sanitizer (10.1.9);** kesalahan kepemilikan terdeteksi lebih awal.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Lupa `Q_OBJECT` | Signal/slot/properti tak terlihat, galat tautan | Tambahkan, dan pastikan moc berjalan (`AUTOMOC`) |
| Setter tanpa pemeriksaan nilai sama | Sinyal berlebih, loop tak berujung | `if (sama) return;` |
| Properti tanpa `NOTIFY` | Binding QML tak pernah diperbarui | `NOTIFY` (atau `CONSTANT`) |
| `emit` sebelum mengubah nilai | Pengamat membaca nilai lama | Ubah nilai lebih dulu |
| Mengubah `MEMBER` langsung | Tak ada sinyal | Setter, `setProperty`, atau `BINDABLE` |
| Lambda tanpa objek konteks | Koneksi tak putus, akses ke objek mati | Beri konteks (`this`) |
| `Qt::UniqueConnection` pada lambda | Tidak berfungsi | Gunakan slot biasa atau jaga sendiri |
| Template ber-`Q_OBJECT` | Galat moc | Pisahkan basis non-template |
| Anak tumpukan dengan urutan terbalik | *Double free* | Induk dulu, atau alokasikan di heap |
| `delete` objek dalam slotnya sendiri | *Crash* | `deleteLater()` |
| Memanggil method `Q_INVOKABLE` berat dari UI | UI membeku | Asinkron (10.7) |
| Signal dipancarkan dari luar pemiliknya | Pengikat logika sulit dilacak | Pancarkan dari kelas pemilik |
| Mengira `QQuickItem::parent` sama dengan `QObject::parent()` | Kepemilikan salah | Bedakan induk visual dan induk objek |

## Cek pemahaman: jawaban

**Apa yang terjadi di QML bila `Q_PROPERTY` tidak punya `NOTIFY`?**
- QML masih bisa membaca nilainya, tetapi **tak punya cara mengetahui bahwa nilainya berubah**. Binding yang bergantung padanya dihitung sekali dan tidak diperbarui lagi.
- Penyebabnya adalah mekanisme binding QML: ia berlangganan ke signal `NOTIFY` untuk tahu kapan harus mengevaluasi ulang. Tanpa signal itu, tak ada yang bisa dilanggani. Dokumentasi bahkan menegaskan bahwa `NOTIFY` harus ditentukan agar properti bisa dipakai dalam binding QML.
- Biasanya konsol QML menampilkan peringatan tentang ekspresi yang bergantung pada properti yang tak bisa dipantau. Periksa log saat menguji.
- Solusinya: tambahkan `NOTIFY` dan pancarkan hanya saat nilai berubah. Bila nilainya memang tak pernah berubah, tandai `CONSTANT`. Pilihan modern: `BINDABLE` dengan `Q_OBJECT_BINDABLE_PROPERTY`.

## Referensi

*Halaman Property System, Meta-Object System, Signals & Slots, Object Trees & Ownership, Bindable Properties, dan moc saya baca langsung dari dokumentasi Qt 6.12. Tautan lain mengikuti pola URL resmi.*

- **Dari kurikulum:** [The Meta-Object System](https://doc.qt.io/qt-6/metaobjects.html) · [The Property System](https://doc.qt.io/qt-6/properties.html) · [Signals & Slots](https://doc.qt.io/qt-6/signalsandslots.html) · [QObject](https://doc.qt.io/qt-6/qobject.html)
- **MOC dan build:** [Using the Meta-Object Compiler (moc)](https://doc.qt.io/qt-6/moc.html) · [Why Does Qt Use Moc?](https://doc.qt.io/qt-6/why-moc.html) · [qt_standard_project_setup](https://doc.qt.io/qt-6/qt-standard-project-setup.html) · [CMake AUTOMOC](https://cmake.org/cmake/help/latest/prop_tgt/AUTOMOC.html)
- **Kepemilikan:** [Object Trees & Ownership](https://doc.qt.io/qt-6/objecttrees.html) · [QPointer](https://doc.qt.io/qt-6/qpointer.html)
- **Properti terikat:** [Qt Bindable Properties](https://doc.qt.io/qt-6/bindableproperties.html) · [QProperty](https://doc.qt.io/qt-6/qproperty.html) · [QObjectBindableProperty](https://doc.qt.io/qt-6/qobjectbindableproperty.html) · [QBindable](https://doc.qt.io/qt-6/qbindable.html)
- **Meta-object API:** [QMetaObject](https://doc.qt.io/qt-6/qmetaobject.html) · [QMetaProperty](https://doc.qt.io/qt-6/qmetaproperty.html) · [QMetaEnum](https://doc.qt.io/qt-6/qmetaenum.html) · [qobject_cast](https://doc.qt.io/qt-6/qobject.html#qobject_cast)
- **Pengujian:** [QSignalSpy](https://doc.qt.io/qt-6/qsignalspy.html) · [Qt Test Overview](https://doc.qt.io/qt-6/qtest-overview.html)
- **Pratinjau 10.3–10.4:** [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) · [Data Type Conversion QML↔C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html)
- **Arch:** [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

# Audit Singkat Modul 10.3

**Terverifikasi benar**
- Jalur modern memang `QML_ELEMENT` + `qt_add_qml_module`. Untuk CMake, berkas yang memuat kelas harus menjadi bagian dari target yang disiapkan dengan `qt_add_qml_module()`. Header di `SOURCES` tepat.
- "Context property ditinggalkan" sesuai dokumentasi. Dokumentasi menyatakan context property sebaiknya dihindari, dan memperkenalkan tipe terdaftar serta singleton sebagai cara umum.
- `#include <QtQml/qqmlregistration.h>` sah bila Anda menautkan QtQml.

**Perlu penajaman atau penambahan**
1. **Prasyarat `AUTOMOC` tak disebut.** Registrasi tipe otomatis dilakukan atas sumber C++ target yang diproses `AUTOMOC`, dan ini mensyaratkan `AUTOMOC` aktif; proyek yang menonaktifkannya harus mengurus sendiri akibatnya. `qt_standard_project_setup()` menyalakannya.
2. **`VERSION 1.0` bukan keharusan.** Dokumentasi menyarankan menghilangkan `VERSION` bila Anda tak membutuhkannya (bawaannya versi tertinggi), karena pemberian versi internal modul QML punya cacat mendasar. Kurikulum memakainya demi kejelasan. Lab saya mengikuti saran dokumentasi.
3. **`QML_UNCREATABLE` butuh argumen.** Argumennya alasan yang dipakai sebagai pesan galat; sejak Qt 6.0, string kosong `""` memberi pesan standar.
4. **Tabel makro kurang.** Tambahkan:
   - `QML_ANONYMOUS`, `QML_INTERFACE` (+ `QML_IMPLEMENTS_INTERFACES`), `QML_UNAVAILABLE`
   - `QML_VALUE_TYPE` (+ `QML_CONSTRUCTIBLE_VALUE` dan `QML_STRUCTURED_VALUE`, keduanya ≥ 6.5)
   - `QML_EXTENDED_NAMESPACE`, `QML_FOREIGN_NAMESPACE`
   - `QML_ADDED_IN_VERSION`, `QML_REMOVED_IN_VERSION`, `QML_EXTRA_VERSION`
   - `QML_SEQUENTIAL_CONTAINER`
   - `Q_NAMESPACE`/`Q_ENUM_NS` untuk enum
5. **Atribut makro yang tersembunyi.**
   - `QML_ATTACHED` tak bisa dialihkan lewat `QML_FOREIGN`, harus ada di tipe yang mengimplementasikan `qmlAttachedProperties()`.
   - Anggota tipe ekstensi diperlakukan sebagai `FINAL`.
   - Nama kelas pada makro harus dikualifikasi penuh, walau Anda sudah di dalam namespace.
   - Dua kelas bernama sama di namespace berbeda yang sama-sama memakai `QML_ELEMENT` bentrok, jadi pakai `QML_NAMED_ELEMENT` untuk salah satunya.
6. **`DEPENDENCIES` belum ada.** Jika kelas Anda memakai atau menurunkan tipe C++ dari modul lain (mis. `QQuickItem` dari QtQuick, atau `QPointF` yang butuh QtQml), modul itu harus dinyatakan di `DEPENDENCIES`, kalau tidak bisa muncul galat lint dan galat kompilasi QML.
7. **Syarat jalur header.** Semua header yang mendeklarasikan tipe QML harus dapat diakses tanpa prefiks dari include path proyek.
8. **Singleton lebih kaya dari satu baris.** Kepemilikan oleh engine, pabrik `create()`, dan jalur instans eksternal ada di 10.3.3.
9. **Fitur khas QML belum ada:** *default property* dan *parent property* lewat `Q_CLASSINFO`, `QQmlListProperty`, `QQmlParserStatus`, revisi/versi, dan *property value source*. Masuk ke 10.3.7.

## Daftar isi Modul 10.3 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 10.3.1 | `QML_ELEMENT` dan modul (+ `QML_NAMED_ELEMENT`, enum lewat `Q_NAMESPACE`, apa yang dibuat `qmltyperegistrar`) |
| 10.3.2 | Mendaftarkan header dan sumber di CMake (`AUTOMOC`, `URI`, `DEPENDENCIES`, jalur header, `qmllint`) |
| 10.3.3 | Singleton C++ (`QML_SINGLETON`, `create()`, instans eksternal) |
| 10.3.4 | Tipe yang tak dapat dibuat: `QML_UNCREATABLE`, `QML_ANONYMOUS`, `QML_INTERFACE`, `QML_UNAVAILABLE` |
| 10.3.5 | *Attached*, *extended*, dan *foreign type* (+ tipe nilai `Q_GADGET`) |
| 10.3.6 | Mengapa `qmlRegisterType` dan context property ditinggalkan |
| 10.3.7 | Fitur khas QML: *default/parent property*, `QQmlListProperty`, `QQmlParserStatus`, revisi/versi `[TAMBAHAN]` |
| 10.3.8 | Lab terpadu: `apphello` dengan `Backend`, `Tema`, `Mode` `[TAMBAHAN]` |

---

# Modul 10.3 — Registrasi Tipe C++ ke QML

## Deskripsi dan peran dalam kurikulum

Di 10.2 Anda membuat `Backend` dengan properti, sinyal, dan `Q_INVOKABLE`. Itu baru separuh jalan: sifat-sifat sebuah `QObject` memang dapat dibaca QML, tetapi kelas itu belum bisa dipakai sebagai tipe data dari QML sebelum didaftarkan ke sistem tipe QML. Registrasi memberi tiga hal:
- kelas dapat dideklarasikan seperti tipe QML biasa (`Backend { }`);
- tipe dan enum-nya bisa dipakai sebagai tipe properti, parameter, dan nilai kembali;
- sebuah singleton dapat diimpor tanpa dibuat manual.

## Konsep kunci dan filosofi

**Analogi.** Registrasi adalah mendaftarkan nama dagang. Setelah terdaftar di sebuah modul, QML memesan objek C++ semudah memesan tipe QML.

**Filosofi.** Registrasi dilakukan **saat build, secara deklaratif**, bukan saat berjalan secara imperatif. Satu makro di kelas memberi tahu alat build siapa Anda. Akibatnya alat bantu (`qmllint`, `qmlls`) dan kompilator QML mengetahui tipe Anda sebelum program jalan.

```
backend.h (QML_ELEMENT)
   |
   +--moc--------------> metadata tipe (JSON) + moc_backend.cpp
                              |
                              +--qmltyperegistrar--> kode registrasi C++  + berkas .qmltypes
                              |                          |                      |
                              |                    dikompilasi & ditautkan   dibaca qmllint/qmlls
                              v
                     program: modul QML "Hello" berisi tipe Backend
```

**Pondasi sintaks.** `QML_ELEMENT` dan kawan-kawannya adalah makro yang dibaca alat build (moc dan `qmltyperegistrar`). Berbeda dengan `Q_OBJECT`, mereka tak mengubah perilaku C++ Anda, hanya menambahkan penanda registrasi.

## 10.3.1 `QML_ELEMENT` dan modul

> *Satu baris deklarasi, ribuan pemakaian.*

**Konsep.** `QML_ELEMENT` menyatakan kelas atau namespace tersedia di QML dengan nama kelasnya sendiri. Dengan `QML_NAMED_ELEMENT(nama)` Anda menentukan nama QML yang berbeda.

```cpp
// backend.h (tambahan dari 10.2)
#include <QtQml/qqmlregistration.h>

class Backend : public QObject
{
    Q_OBJECT
    QML_ELEMENT                       // ← tipe QML bernama "Backend"
    Q_PROPERTY(QString pesan READ pesan WRITE setPesan NOTIFY pesanChanged FINAL)
    // ... (sisanya sama seperti Modul 10.2)
};
```

**Bedah kode**
- `#include <QtQml/qqmlregistration.h>`: header makro registrasi. Header ini menyertakan `qqmlintegration.h`. Bila Anda tak menautkan QtQml, gunakan `QtQmlIntegration/qqmlintegration.h`.
- `QML_ELEMENT` ditaruh di dalam kelas, setelah `Q_OBJECT` (konvensi). Ia menandai kelas untuk dibaca `qmltyperegistrar`.
- Nama tipe QML mengikuti nama kelas, yaitu `Backend`. Semua properti, method `Q_INVOKABLE`, dan enum-nya ikut terekspos.
- Tipe dikelompokkan oleh **modul** (URI di CMake, 10.3.2). QML memakainya dengan `import Hello`.

**Nama kustom dan bentrokan**

```cpp
class SqlEventDatabase : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(EventDatabase)       // di QML: EventDatabase { }
};
```

Bila dua kelas bernama sama berada di namespace berbeda dan keduanya memakai `QML_ELEMENT`, terjadi konflik, jadi pakai `QML_NAMED_ELEMENT` untuk salah satunya. Nama kelas pada makro juga harus dikualifikasi penuh meski sudah di dalam namespace.

**Enum lewat namespace (`Q_NAMESPACE`).** Untuk enum yang tak terikat ke satu kelas:

```cpp
// mode.h
#pragma once
#include <QObject>
#include <QtQml/qqmlregistration.h>

namespace Mode {
    Q_NAMESPACE
    QML_ELEMENT
    enum Tipe { Terang, Gelap };
    Q_ENUM_NS(Tipe)
}
```

`Q_NAMESPACE` dengan `QML_ELEMENT` membuat namespace tersedia dan enum bertanda `Q_ENUM_NS` dapat dipakai. Di QML: `Mode.Gelap`. Nilai enum untuk tipe terdaftar harus berawalan huruf kapital.

**Opsi lain**
- **`QML_ELEMENT` di dalam kelas dengan enum `Q_ENUM`** bila enum memang milik kelas (`Backend.Status.Siap`).
- **Singleton, tak dapat dibuat, dan lain-lain:** 10.3.3–10.3.5.
- **Pendaftaran imperatif** (`qmlRegisterType`): 10.3.6.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Lupa `Q_OBJECT` di kelas ber-`QML_ELEMENT` | Tambahkan (10.2) |
| Nama enum berawalan huruf kecil | Awali dengan huruf kapital |
| Dua kelas senama di namespace berbeda | `QML_NAMED_ELEMENT` |
| Kelas di namespace C++ lalu makro memakai nama pendek | Kualifikasi penuh pada argumen makro |

## 10.3.2 Mendaftarkan header dan sumber di CMake

> *Build yang benar adalah separuh dari registrasi yang berhasil.*

**Konsep.** `qt_add_qml_module` mendefinisikan modul QML yang terdiri atas berkas C++, berkas `.qml`, atau keduanya. Fungsi ini juga mengatur kompilasi QML ke bytecode, embedding resource, pemeriksaan lint, dan pembuatan otomatis berkas kunci modul. Definisinya ada di komponen `Qml` dari paket Qt6.

```cmake
cmake_minimum_required(VERSION 3.21)
project(hello LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)           # AUTOMOC + prefiks resource /qt/qml

qt_add_executable(apphello main.cpp)

qt_add_qml_module(apphello
    URI Hello
    QML_FILES Main.qml
    SOURCES backend.h backend.cpp tema.h mode.h
)

target_link_libraries(apphello PRIVATE Qt6::Quick)
```

**Bedah kode**
- `qt_standard_project_setup(REQUIRES 6.5)` menyalakan `AUTOMOC` dan kebijakan modern. Dengan kebijakan QTP0001 baru (mis. lewat `REQUIRES 6.5`), prefiks resource bawaan menjadi `/qt/qml/`, jalur impor bawaan mesin QML, sehingga modul ditemukan tanpa pengaturan tambahan.
- `qt_add_executable(apphello main.cpp)` membuat program. Ia akan menjadi **target pendukung** modul.
- `URI Hello` adalah nama modul untuk `import Hello`. `URI` ditulis berpola titik, tiap segmen harus nama identifier ECMAScript yang sah, dan sebaiknya dibatasi huruf Latin, angka, garis bawah, dan titik karena akan diterjemahkan ke nama direktori.
- `QML_FILES Main.qml` mendaftarkan berkas QML. Berkas ini dikompilasi ke bytecode dan disimpan di target.
- `SOURCES backend.h ...` setara `target_sources`. Header yang memuat makro registrasi harus ada di sini agar diproses.
- `VERSION` sengaja tidak ditulis (lihat audit).
- Tautkan `Qt6::Quick` untuk aplikasi Qt Quick.

**Target executable sebagai modul.** Bila executable menjadi target pendukung, tak ada plugin terpisah, dan susunan direktori sumber tak harus cocok dengan jalur target modul. Untuk pustaka modul yang dipakai ulang, susun direktori sama dengan URI (`MyThings/Panels/`).

**Yang dihasilkan otomatis**
- Berkas `qmldir` dan berkas typeinfo (`namatarget.qmltypes`) dibuat otomatis, dan sumber C++ dipindai saat build untuk menghasilkan berkas typeinfo dan kode registrasi.
- Opsi `NO_GENERATE_QMLTYPES` dan `NO_GENERATE_QMLDIR` ada, tetapi penggunaan `NO_GENERATE_QMLTYPES` sangat tidak dianjurkan.
- Target lint `<target>_qmllint` dan `all_qmllint` dibuat otomatis bila ada berkas QML.

**`DEPENDENCIES`**

```cmake
qt_add_qml_module(apphello
    URI Hello
    QML_FILES Main.qml
    SOURCES backend.h backend.cpp
    DEPENDENCIES QtQuick                 # bila kelas Anda menurunkan QQuickItem
)
```

Jika kelas Anda memakai tipe C++ dari modul lain, deklarasikan modul itu di `DEPENDENCIES`. Tanpanya, bisa muncul galat lint, galat saat kompilasi tipe, atau galat saat mengompilasi binding ke C++. Pilih `DEPENDENCIES` yang lebih ringan daripada `IMPORTS`.

**Memuat modul di C++**

```cpp
QQmlApplicationEngine engine;
engine.loadFromModule("Hello", "Main");     // URI, nama tipe QML (Main.qml)
```

**Perintah terminal**

```bash
cmake -S . -B build && cmake --build build && ./build/apphello
cmake --build build --target all_qmllint        # lint seluruh modul QML
find build -name '*.qmltypes'                   # lihat tipe yang didaftarkan
```

**Keamanan jalur impor.** `IMPORT_PATH` menambah lokasi pencarian modul QML. Qt menganggap semua berkas di jalur impor berasal dari sumber tepercaya. Jangan menambahkan direktori yang bisa ditulis pengguna atau berasal dari lingkungan yang tak dikendalikan. Untuk rilis, bundel modul ke dalam resource.

**Opsi lain**
- **Modul pustaka terpisah** dengan plugin: untuk modul yang dipakai banyak aplikasi. Susunan yang direkomendasikan untuk kebanyakan modul adalah target pendukung dan target plugin terpisah.
- **Plugin manual:** tidak direkomendasikan oleh dokumentasi.
- **`NAMESPACE`:** menaruh kode registrasi dalam namespace C++ tertentu.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Header tak ada di `SOURCES` | `Backend is not a type` | Daftarkan header di `SOURCES` |
| `AUTOMOC` mati | Registrasi tak dihasilkan | `qt_standard_project_setup()` |
| `URI` di CMake berbeda dari `import` | Modul tak ditemukan | Samakan persis (huruf besar-kecil) |
| Header tak terjangkau dari include path | Galat kompilasi kode registrasi | Tambahkan ke `target_include_directories` |
| `DEPENDENCIES` terlewat | Galat lint/kompilasi QML | Tambahkan modul yang dipakai |
| Mengubah jalur impor ke direktori tak tepercaya | Pemuatan kode QML sembarang | Bundel ke resource |

## 10.3.3 Singleton C++

> *Satu instans, satu sumber kebenaran.*

**Konsep.** Tipe singleton menyediakan properti, sinyal, dan method dalam sebuah namespace tanpa klien perlu membuat instans. Singleton `QObject` dibuat dan dimiliki `QQmlEngine`, dihancurkan saat engine dihancurkan, dan dirujuk lewat nama tipe, bukan `id`. Properti singleton bisa diikat, jadi ia cocok untuk tema atau konfigurasi.

```cpp
// tema.h
#pragma once
#include <QColor>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class Tema : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QColor latar READ latar CONSTANT FINAL)
    Q_PROPERTY(QColor teks  READ teks  CONSTANT FINAL)
    Q_PROPERTY(QColor aksen READ aksen CONSTANT FINAL)

public:
    explicit Tema(QObject *parent = nullptr) : QObject(parent) {}
    QColor latar() const { return QColor(30, 30, 46); }
    QColor teks()  const { return QColor(205, 214, 244); }
    QColor aksen() const { return QColor(137, 180, 250); }
};
```

```qml
import Hello

Rectangle {
    color: Tema.latar          // dipakai lewat nama tipe, tanpa membuat objek
}
```

**Bedah kode**
- `QML_ELEMENT` + `QML_SINGLETON` bersama menyatakan "tipe QML ini adalah singleton". `QML_SINGLETON` hanya berlaku bila tipe ber-`Q_OBJECT` dan tersedia di QML lewat `QML_ELEMENT` atau `QML_NAMED_ELEMENT`.
- Properti `CONSTANT` (10.2.2) cocok untuk nilai yang tak berubah. Bila tema harus bisa berganti, beri `NOTIFY` dan setter.
- Konstruktor `explicit Tema(QObject *parent = nullptr)` bisa dipanggil tanpa argumen, jadi engine dapat membuatnya sendiri.
- `Tema.latar` di QML merujuk instans engine itu. Tidak ada `Tema { id: ... }`.

**Tiga cara menyediakan instans**
1. **Konstruktor bawaan:** seperti di atas. Bila ada konstruktor bawaan dan fungsi pabrik sekaligus, konstruktor bawaan yang dipilih.
2. **Fungsi pabrik statis:** untuk kelas tanpa konstruktor bawaan.

```cpp
static Tema *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine); Q_UNUSED(jsEngine);
    return new Tema;          // engine mengambil alih kepemilikan
}
```
Bentuk tanda tangannya adalah `T *create(QQmlEngine *, QJSEngine *)`, dipanggil saat tipe pertama kali diakses; engine akan menghapus hasilnya.

3. **Instans eksternal** (Anda yang memilikinya):

```cpp
class Layanan : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    QML_UNCREATABLE("Disediakan oleh C++")
public:
    Layanan(Backend *b, QObject *parent) : QObject(parent) {}
};

// di main():
Layanan layanan(&backend, nullptr);
engine.setExternalSingletonInstance("Hello", "Layanan", &layanan);   // sebelum QML mengaksesnya
```

`QML_UNCREATABLE` pada singleton berarti "instans akan diset eksplisit lewat `QQmlEngine::setExternalSingletonInstance` sebelum diakses pertama kali"; ini pengganti `qmlRegisterSingletonInstance`. Engine tak mengambil alih kepemilikan singleton eksternal kecuali Anda memintanya lewat `QJSEngine::setObjectOwnership()`. Argumen persis `setExternalSingletonInstance` (URI dan nama tipe) periksa di dokumentasi `QQmlEngine`.

**Opsi lain**
- **Singleton QML** (`pragma Singleton`, 5.3): untuk tema murni QML.
- **Properti biasa pada objek akar** bila hanya satu jendela memerlukannya.
- **`QJSValue` sebagai singleton:** bisa, tetapi properti singleton jenis itu tak bisa diikat.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Memberi `id` pada singleton atau mencoba `Tema { }` | Galat | Rujuk lewat nama tipe: `Tema.latar` |
| Mengharapkan satu instans lintas beberapa engine | Tiap engine punya instans sendiri | Singleton itu per-engine |
| Singleton tak punya konstruktor bawaan dan pabrik | Tak dapat diakses | Tambah `create()` atau `QML_UNCREATABLE` + instans eksternal |
| Instans eksternal dihapus lebih dulu dari engine | *Use-after-free* | Pastikan umurnya melebihi engine, atau serahkan kepemilikan |
| Mengisi singleton dengan keadaan aplikasi yang makin besar | Keadaan global tersembunyi | Batasi ke tema/konfigurasi/layanan |

## 10.3.4 Tipe yang tak dapat dibuat

> *Tidak semua yang dikenal harus bisa dibuat.*

**Konsep.** Kelas bisa didaftarkan tanpa dapat diinstansiasi, misalnya bila ia antarmuka, kelas dasar, pembawa enum, atau disediakan lewat singleton. Semua tipe C++ yang didaftarkan harus turunan `QObject`, meski tak dapat dibuat.

| Makro | Arti |
| --- | --- |
| `QML_UNCREATABLE("alasan")` + `QML_ELEMENT` | Bernama dan dikenali, tetapi tak bisa dibuat; alasan menjadi pesan galat bila dicoba. |
| `QML_ANONYMOUS` | Tersedia tetapi anonim: tak bisa dibuat atau dipakai mendeklarasikan properti di QML, namun dikenali saat dilempar dari C++. |
| `QML_INTERFACE` | Tipe antarmuka: tak dapat dibuat dan tak bisa dipakai untuk properti QML; properti C++ bertipe ini tetap di-*cast* ke antarmuka otomatis. |
| `QML_UNAVAILABLE` | "Memesan" nama tipe yang tak tersedia agar pengguna mendapat pesan galat yang bermakna. |

```cpp
class Hak : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Hak hanya dibuat oleh C++")      // alasan = pesan galat di QML
public:
    enum Tingkat { Baca, Tulis, Admin };
    Q_ENUM(Tingkat)
};
```

Di QML: `Hak.Admin` bisa dipakai, tetapi `Hak { }` memunculkan pesan di atas.

**Bedah kode**
- `QML_UNCREATABLE("...")` mendaftarkan `Hak` sebagai tipe yang dikenal (untuk enum-nya) tetapi tak bisa dibuat.
- Berguna saat **enum atau atribut terlampir** perlu terekspos tetapi objeknya tak boleh dibuat dari QML.
- Pola ini juga aman untuk keamanan: objek yang punya konsekuensi (hak akses, sesi) dibuat hanya oleh kode C++ tepercaya.

**Opsi lain.** `Q_NAMESPACE` + `QML_ELEMENT` bila hanya enum yang dibutuhkan (10.3.1). Antarmuka berbasis `QML_INTERFACE` dengan `Q_DECLARE_INTERFACE`, bila ada hierarki penerapan antarmuka.

**Jebakan.** Mengira `QML_ANONYMOUS` bisa dipakai di deklarasi QML. Tipe yang didaftarkan tetapi bukan turunan `QObject` tidak bisa (kecuali tipe nilai).

## 10.3.5 *Attached*, *extended*, dan *foreign type*

> *Memperluas tanpa membongkar adalah seni menjaga kompatibilitas.*

### Tipe terlampir (*attached*)

**Konsep.** Properti terlampir (`Keys.onReturnPressed`, `Layout.fillWidth`, `Accessible.name`) adalah atribut yang "ditempelkan" tipe lain ke objek Anda. Ada tiga pihak: *attachee* (objek yang ditempeli), *attaching type* (pemberi nama), dan *attached object type* (objek atribut).

```cpp
class JejakAttached : public QObject
{
    Q_OBJECT
    QML_ANONYMOUS
    Q_PROPERTY(bool dilihat READ dilihat WRITE setDilihat NOTIFY dilihatChanged FINAL)
public:
    explicit JejakAttached(QObject *parent) : QObject(parent) {}
    bool dilihat() const { return m_dilihat; }
    void setDilihat(bool v)
    {
        if (m_dilihat == v) return;
        m_dilihat = v;
        emit dilihatChanged();
    }
signals:
    void dilihatChanged();
private:
    bool m_dilihat = false;
};

class Jejak : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ATTACHED(JejakAttached)
    QML_UNCREATABLE("Jejak hanya untuk properti terlampir")
public:
    static JejakAttached *qmlAttachedProperties(QObject *objek)
    {
        return new JejakAttached(objek);           // di-parent ke objek yang ditempeli
    }
};
```

```qml
Rectangle {
    Jejak.dilihat: true
    Jejak.onDilihatChanged: console.log('berubah')
}
```

**Bedah kode**
- `JejakAttached` adalah *attached object type*: `QML_ANONYMOUS` karena tak dibuat langsung dari QML, hanya dibuat engine.
- `Jejak` adalah *attaching type*: ia mendeklarasikan `QML_ATTACHED(JejakAttached)` dan fungsi statis `qmlAttachedProperties(QObject *)`.
- Engine memanggil fungsi itu paling banyak sekali per objek yang ditempeli dan menyimpan hasilnya. Meng-*parent*-kan hasil ke objek itu lazim, agar tak bocor.
- `QML_UNCREATABLE` karena `Jejak` hanya dipakai sebagai nama pemberi atribut.
- Di C++, `qmlAttachedPropertiesObject<Jejak>(objek)` mengambil objek terlampir.

### Tipe ekstensi (*extended*)

**Konsep.** Objek ekstensi menambah properti pada tipe yang Anda kendalikan tanpa memodifikasinya. Anggotanya digabung transparan dengan kelas target saat dipakai di QML. Meng-ekstensi tipe milik Qt sendiri tidak didukung.

```cpp
class SensorSuhuExt : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString satuan READ satuan CONSTANT FINAL)
public:
    explicit SensorSuhuExt(QObject *sensor) : QObject(sensor) {}
    QString satuan() const { return QStringLiteral("celsius"); }
};

class SensorSuhu : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_EXTENDED(SensorSuhuExt)                  // di QML: SensorSuhu { satuan ... }
    Q_PROPERTY(double nilai READ nilai NOTIFY nilaiChanged FINAL)
    // ...
};
```

Kelas ekstensi dibuat malas pada akses pertama properti terekstensi, dengan objek target sebagai induk. Anggota tipe ekstensi diperlakukan sebagai `FINAL`. Untuk hanya menambah enum, pakai `QML_EXTENDED_NAMESPACE(namespace)`.

### Tipe asing (*foreign*)

**Konsep.** Kelas pihak ketiga yang tak bisa diubah tetap bisa diekspos lewat `QML_FOREIGN`, dalam sebuah struct terpisah yang isinya hanya makro registrasi.

```cpp
#include <tigapihak.h>                            // berisi kelas TigaPihak (QObject, tak boleh diubah)

struct TigaPihakForeign
{
    Q_GADGET
    QML_FOREIGN(TigaPihak)
    QML_NAMED_ELEMENT(TigaPihak)                  // pakai NAMED agar nama QML = TigaPihak
};
```

Dengan `QML_ELEMENT`, nama QML mengikuti struct pembungkus, bukan tipe asing, jadi `QML_NAMED_ELEMENT` biasanya lebih tepat. `QML_ATTACHED` tak bisa dialihkan lewat cara ini. Untuk namespace gunakan `QML_FOREIGN_NAMESPACE`.

### Tipe nilai (`Q_GADGET`)

**Konsep.** Struct sederhana yang disalin, bukan dibagi sebagai objek.

```cpp
class Titik
{
    Q_GADGET
    QML_VALUE_TYPE(titik)                  // nama QML HARUS huruf kecil
    QML_STRUCTURED_VALUE                   // ≥ 6.5: boleh diisi dari objek JS
    Q_PROPERTY(int x MEMBER x)
    Q_PROPERTY(int y MEMBER y)
public:
    int x = 0;
    int y = 0;
};
```

```qml
QtObject { property titik p: ({ x: 4, y: 7 }) }   // kurung agar dibaca sebagai objek JS
```

Tipe nilai bernama huruf kecil. Aturan lain: tak boleh singleton, harus bisa dibuat default dan disalin, tak boleh memakai `QProperty` sebagai anggota, dan tak punya properti terlampir. `QML_CONSTRUCTIBLE_VALUE` (≥ 6.5) mengizinkan konstruktor `Q_INVOKABLE` satu argumen dipakai saat menetapkan nilai JavaScript.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Lupa mem-*parent*-kan objek terlampir | `new JejakAttached(objek)` |
| Mengira ekstensi bisa menimpa anggota | Anggota ekstensi `FINAL`, jangan menimpa |
| Memodifikasi kelas pihak ketiga | Pakai `QML_FOREIGN` |
| Tipe nilai bernama kapital | Nama QML huruf kecil |
| `QML_ATTACHED` lewat `QML_FOREIGN` | Tak didukung, letakkan di tipe yang punya `qmlAttachedProperties()` |

## 10.3.6 Mengapa `qmlRegisterType` dan context property ditinggalkan

> *Kontrak yang eksplisit mengalahkan keajaiban yang tersembunyi.*

**Tiga cara memasok C++ ke QML, dan peringkatnya**

| Cara | Kapan terdaftar | Diketahui alat bantu? | Peringkat |
| --- | --- | --- | --- |
| **Makro (`QML_ELEMENT`, dst.)** | Saat build (otomatis) | Ya (`.qmltypes`) | Pilihan utama |
| `qmlRegisterType<T>(...)` | Saat berjalan, di `main()` | Tidak | Cara imperatif lama, tak perlu untuk kode baru |
| `setContextProperty("nama", obj)` | Saat berjalan, global | Tidak | Harus dihindari |

**Alasan konkret**
- **Alat bantu buta.** Tipe makro dihasilkan ke `.qmltypes`, sehingga `qmllint` dan `qmlls` tahu isi tipe Anda. Penggunaan context property bahkan sengaja diperingatkan oleh `qmllint` lewat berkas dump context property.
- **Tak ada tipe saat build.** Nama context property baru ada saat berjalan, sehingga kompilator QML tak bisa memeriksa atau mengoptimalkan ekspresi yang bergantung padanya. Ini sambungan ke 9.2.5 (ekspresi dapat dikompilasi ke C++ hanya bila tipenya dikenal).
- **Keadaan global tersembunyi.** Context property adalah variabel global tak bertipe di cakupan QML: rawan bentrok nama, sulit diuji, dan urutan pengaturannya sensitif (harus sebelum QML dimuat).
- **Kepemilikan kabur.** Siapa yang menghapus objek itu? Singleton dan instans eksternal punya aturan eksplisit (10.3.3).
- **Pengganti langsung.** Untuk `qmlRegisterSingletonInstance`, penggantinya adalah `QML_UNCREATABLE` dengan `setExternalSingletonInstance`.

**Peta migrasi**

| Kode lama | Pengganti |
| --- | --- |
| `qmlRegisterType<Backend>("Hello", 1, 0, "Backend")` | `QML_ELEMENT` di kelas + `URI Hello` di CMake |
| `engine.rootContext()->setContextProperty("tema", &tema)` | `QML_SINGLETON` (atau instans eksternal) |
| `setContextProperty("backend", &backend)` | Buat `Backend { id: backend }` di QML, atau singleton |
| Enum yang dipakai bebas | `Q_ENUM` + registrasi kelas, atau `Q_NAMESPACE` |

**Alasan untuk tidak mencari anak QML dari C++.** Mengakses objek QML dari C++ tidak direkomendasikan kecuali untuk pengujian dan prototipe, karena merusak pemisahan antarmuka QML dari logika C++. Dibahas di 10.4.6.

**Jebakan.** Meneruskan tutorial lama yang memakai `setContextProperty` ke kode baru. Mencampur `qmlRegisterType` di `main()` dan `QML_ELEMENT` untuk tipe yang sama menyebabkan registrasi ganda dan bingung nama.

## 10.3.7 Fitur khas QML: *default property*, *parent property*, `QQmlListProperty`, `QQmlParserStatus`, revisi `[TAMBAHAN]`

> *Detail kecil yang membuat tipe C++ Anda terasa asli bagi QML.*

**Properti bawaan (*default property*).** Properti bawaan adalah properti yang menerima anak objek secara otomatis bila tak ditetapkan ke properti tertentu. Ditentukan lewat `Q_CLASSINFO("DefaultProperty", "nama")`.

```cpp
class Butir : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString nama MEMBER m_nama NOTIFY namaChanged FINAL)
signals:
    void namaChanged();
private:
    QString m_nama;
};

class Daftar : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QQmlListProperty<Butir> butir READ butir)
    Q_CLASSINFO("DefaultProperty", "butir")
public:
    QQmlListProperty<Butir> butir() { return QQmlListProperty<Butir>(this, &m_butir); }
private:
    QList<Butir *> m_butir;
};
```

```qml
Daftar {
    Butir { nama: 'Kopi' }
    Butir { nama: 'Teh' }
}
```

**Bedah kode**
- `QQmlListProperty<Butir>` adalah pembungkus daftar yang bisa diisi QML. Bentuk sederhana menerima objek pemilik dan penunjuk ke `QList<Butir *>`.
- `Q_CLASSINFO("DefaultProperty", "butir")` menjadikan `butir` penampung anak. Tanpa itu, Anda harus menulis `butir: [ Butir {...}, Butir {...} ]`.
- Butir-butir itu dimiliki oleh pohon QML (induk objek). Daftar C++ hanya menunjuknya.

**Properti induk (*parent property*).** `Q_CLASSINFO("ParentProperty", "nama")` memberi tahu mesin properti mana yang mewakili induk dalam hierarki QML, sehingga `qmllint` dan alat lain tidak memberi peringatan palsu.

**Notifikasi inisialisasi: `QQmlParserStatus`.** Untuk menunda inisialisasi mahal sampai semua properti terisi:

```cpp
class Pemuat : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_ELEMENT
public:
    void classBegin() override {}
    void componentComplete() override
    {
        // di sini semua properti dari QML sudah terisi: aman memulai pekerjaan
    }
};
```

Kelas turunan `QQmlParserStatus` yang juga diumumkan lewat `Q_INTERFACES` menerima notifikasi pada beberapa tahap pembuatan komponen. Ini setara `Component.onCompleted` tetapi di sisi C++.

**Revisi dan versi.** Revisi memungkinkan properti atau method baru muncul di versi baru sambil tetap kompatibel dengan versi lama. Properti diberi `REVISION(...)`, signal/method diberi `Q_REVISION(...)`, dan revisi dibaca sebagai versi minor dari versi mayor modul. `QML_ADDED_IN_VERSION(major, minor)` menyatakan tipe baru sejak versi itu. Bila modul diimpor dengan versi lebih rendah, tipenya tak terlihat. Contoh konsisten (versi 1.2):

```cpp
class Backend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ADDED_IN_VERSION(1, 2)
    Q_PROPERTY(int akar READ akar NOTIFY akarChanged REVISION(1, 2) FINAL)
signals:
    Q_REVISION(1, 2) void akarChanged();
};
```

Karena `VERSION` modul dihilangkan di lab (anjuran dokumentasi), fitur revisi hanya relevan bila Anda memang menerbitkan modul berversi.

**Property value source (sekilas).** Kelas turunan `QQmlPropertyValueSource` dapat dipakai dengan sintaks `Tipe on properti { }` untuk mengubah nilai properti dari waktu ke waktu; animasi Qt Quick adalah contohnya.

**Jebakan.** `QQmlListProperty` dengan penunjuk ke objek yang dihapus di tengah jalan. Mengisi *default property* dengan objek yang tak dimiliki siapa pun (beri induk). Mengira `componentComplete()` dipanggil bila objek dibuat dari C++ tanpa melewati engine QML.

## 10.3.8 Lab terpadu `[TAMBAHAN]`

Lab ini menjalankan latihan kurikulum (daftarkan `Backend`, buat `Backend { id: backend }` di `Main.qml`, tampilkan `backend.pesan`) dan menambahkan singleton dan enum namespace. Berkas: `CMakeLists.txt`, `main.cpp`, `backend.h`/`backend.cpp` (dari 10.2, plus dua baris), `tema.h`, `mode.h`, `Main.qml`.

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.21)
project(hello LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(apphello main.cpp)

qt_add_qml_module(apphello
    URI Hello
    QML_FILES Main.qml
    SOURCES backend.h backend.cpp tema.h mode.h
)

target_link_libraries(apphello PRIVATE Qt6::Quick)
```

```cpp
// main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, [] { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("Hello", "Main");

    return app.exec();
}
```

`backend.h` dan `backend.cpp`: ambil dari lab 10.2, lalu tambahkan `#include <QtQml/qqmlregistration.h>` dan `QML_ELEMENT` setelah `Q_OBJECT`. `tema.h` dan `mode.h`: dari 10.3.3 dan 10.3.1.

```qml
// Main.qml
import QtQuick
import QtQuick.Controls
import Hello

ApplicationWindow {
    visible: true; width: 420; height: 320
    title: 'Hello C++/QML'
    color: Tema.latar

    Backend { id: backend }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Label {
            text: backend.pesan === '' ? '(kosong)' : backend.pesan
            color: Tema.teks
        }
        Label { text: 'Hitungan: ' + backend.hitungan; color: Tema.teks }
        Label {
            text: backend.status === Backend.Status.Siap ? 'Siap' : 'Sibuk'
            color: Tema.aksen
        }
        Label { text: 'Mode.Gelap = ' + Mode.Gelap; color: Tema.teks }

        Button { text: 'Tambah';     onClicked: backend.tambah() }
        Button { text: 'Muat ulang'; onClicked: backend.muatUlang() }
    }

    Connections {
        target: backend
        function onSelesai(n) { console.log('selesai pada hitungan', n) }
    }
}
```

```bash
cmake -S . -B build && cmake --build build && ./build/apphello
cmake --build build --target all_qmllint
find build -name '*.qmltypes'
```

**Bedah ringkas**
- `Backend { id: backend }` membuat objek C++ dari QML. `backend.pesan` dan `backend.hitungan` adalah properti dengan `NOTIFY`, sehingga label ikut berubah saat tombol ditekan.
- `Backend.Status.Siap` mengakses enum yang terdaftar lewat `Q_ENUM`.
- `Tema.latar` memakai singleton lewat nama tipe, tanpa membuat objek.
- `Mode.Gelap` memakai enum dari namespace yang diekspos.
- `Connections { target: backend; function onSelesai(n) ... }` mendengar sinyal `selesai(int)`. Perhatikan konsol saat tombol "Tambah" ditekan tiga kali.
- `all_qmllint` memeriksa QML Anda terhadap tipe yang didaftarkan. Bila Anda salah mengetik `backend.hitungn`, lint akan mengeluh.

**Percobaan yang disarankan (sengaja merusak)**
1. Hapus `QML_ELEMENT` dari `Backend` lalu bangun ulang. Amati galat di QML ("Backend is not a type" atau serupa).
2. Keluarkan `backend.h` dari `SOURCES`. Amati bedanya.
3. Hapus `qt_standard_project_setup()` dan lihat registrasi tak terbuat (tak ada `AUTOMOC`).
4. Ubah `URI Hello` menjadi `Halo` tanpa mengubah `import`. Amati galat impor.
5. Jalankan dengan `QT_QPA_PLATFORM=offscreen ./build/apphello` untuk melihat hasil tanpa jendela (cocok di CI).

**Latihan tambahan**
1. Ubah `Tema` menjadi singleton yang dapat berganti (`NOTIFY` + `Q_INVOKABLE void gantiMode(Mode::Tipe)`), dan buat jendela mengikutinya.
2. Tambahkan `QML_UNCREATABLE("Hanya dibuat C++")` ke sebuah kelas pembawa enum dan coba membuatnya di QML untuk melihat pesan galat.
3. Tambahkan tipe terlampir `Jejak` dari 10.3.5 dan pakai di sebuah `Rectangle`.
4. Tambahkan tipe nilai `titik` dan sebuah properti `titik posisi` di `Backend`, lalu ubah dari QML.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Modul QML (URI)** | Kelompok tipe bernama; dipakai dengan `import` |
| **`QML_ELEMENT` / `QML_NAMED_ELEMENT`** | Menandai kelas/namespace tersedia di QML (nama kelas / nama kustom) |
| **`qmltyperegistrar`** | Alat yang menghasilkan kode registrasi dan berkas `.qmltypes` |
| **`.qmltypes`** | Berkas deskripsi tipe yang dibaca `qmllint`/`qmlls` |
| **Target pendukung (*backing target*)** | Target CMake yang berisi implementasi modul |
| **Singleton** | Satu instans per engine, dirujuk lewat nama tipe |
| **`create(QQmlEngine*, QJSEngine*)`** | Pabrik statis untuk singleton |
| **Tipe tak dapat dibuat** | Dikenal tetapi tak bisa diinstansiasi dari QML |
| **Anonim / antarmuka** | Dikenal dari C++ tetapi tak dapat dirujuk / tipe antarmuka |
| **Tipe terlampir (*attached*)** | Atribut yang ditempelkan lewat `Tipe.properti` |
| **Tipe ekstensi** | Tambahan properti pada tipe milik Anda tanpa mengubahnya |
| **Tipe asing (*foreign*)** | Tipe yang tak bisa diberi makro, diekspos lewat pembungkus |
| **Tipe nilai (`Q_GADGET`)** | Struct yang disalin; nama QML huruf kecil |
| **Revisi** | Penanda versi minor sebuah anggota |
| **Context property** | Variabel global tak bertipe dari C++ ke QML (hindari) |

## Hubungan dengan modul lain

- **Prasyarat:** 10.2 (`QObject`, properti, `NOTIFY`, `Q_ENUM`, kepemilikan), 8.3 (CMake, `qt_add_qml_module`), 8.4 (`qmllint`).
- **Menjadi dasar untuk:** 10.4 (memakai objek terdaftar dari QML dan konversi tipe), 10.5 (model C++ didaftarkan dengan `QML_ELEMENT`), 10.6 (layanan sistem dibungkus dalam tipe terdaftar), 10.7 (objek kerja didaftarkan dan sinyalnya didengar QML).
- **Menyambung ke:** 5.3 (Singleton tema versi QML), 9.2 (`QQuickStyle` dan atribut terlampir style memakai mekanisme ini), 9.4 (`Accessible` adalah tipe terlampir).

## Tips dan praktik terbaik

1. **Satu baris `QML_ELEMENT` per kelas,** dan header-nya di `SOURCES`.
2. **Biarkan `VERSION` kosong** kecuali Anda menerbitkan modul berversi.
3. **Pakai `QML_SINGLETON` hanya untuk keadaan benar-benar global** (tema, konfigurasi, layanan).
4. **`QML_UNCREATABLE` untuk objek berkonsekuensi** (hak akses, sesi) agar hanya C++ yang membuatnya.
5. **Tulis `FINAL` pada properti** yang tak untuk ditimpa (dianjurkan dokumentasi).
6. **Gunakan `DEPENDENCIES`** untuk modul yang dipakai kelas Anda di sisi C++.
7. **Jalankan `all_qmllint` di CI.** Tipe terdaftar membuat lint jauh lebih berguna.
8. **Jangan menambahkan jalur impor tak tepercaya;** bundel modul ke resource untuk rilis.
9. **Hindari `setContextProperty` dan `findChild` pada pohon QML** di kode baru.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Header tak ada di `SOURCES` | Tipe tak terdaftar | Tambahkan ke `SOURCES` |
| `AUTOMOC` mati | Tak ada kode registrasi | `qt_standard_project_setup()` |
| `URI` ≠ `import` | Modul tak ditemukan | Samakan |
| Nama enum berawalan huruf kecil | Tak dapat diakses | Awali huruf kapital |
| Tipe nilai bernama kapital | Gagal registrasi | Huruf kecil |
| Singleton tanpa konstruktor bawaan dan `create()` | Tak dapat diakses | Tambah `create()` atau instans eksternal |
| `Tema { }` atau `id` pada singleton | Galat | Rujuk lewat nama tipe |
| Lupa `DEPENDENCIES` | Galat lint/kompilasi | Tambahkan |
| Objek terlampir tanpa induk | Kebocoran | `new X(objek)` |
| Dua kelas senama di namespace berbeda | Konflik | `QML_NAMED_ELEMENT` |
| Tipe yang diatur lewat `setContextProperty` | Alat bantu buta, keadaan global | Registrasi tipe atau singleton |
| Menambah direktori tak tepercaya ke jalur impor | Pemuatan kode QML sembarang | Bundel ke resource |

## Cek pemahaman: jawaban

**Mengapa registrasi tipe lebih baik dari context property?**
- **Terlihat oleh alat bantu.** Registrasi lewat makro dibaca saat build dan menghasilkan `.qmltypes`. `qmllint` dan `qmlls` mengenali properti, sinyal, dan method Anda, dan dokumentasi menyatakan context property sebaiknya dihindari serta sengaja diperingatkan oleh `qmllint`.
- **Terikat tipe.** Registrasi memberi mesin metadata tipe lengkap, sehingga tipe dan enum bisa dipakai sebagai tipe properti, parameter, dan nilai kembali. Context property hanyalah nama global yang tipenya baru diketahui saat berjalan.
- **Kepemilikan dan cakupan jelas.** Tipe terdaftar hidup di modul bernama, tak mencemari cakupan global. Singleton punya aturan kepemilikan eksplisit (milik engine atau instans eksternal).
- **Siap diuji dan dirawat.** Tak ada urutan pengaturan rahasia (`setContextProperty` harus sebelum QML dimuat), tak ada bentrok nama global, dan antarmuka C++/QML menjadi kontrak yang bisa diperiksa.

## Referensi

*Halaman Defining QML Types from C++, QML and C++ Integration Overview, `qt_add_qml_module`, `<qqmlintegration.h>`, dan Data Type Conversion saya baca langsung dari dokumentasi Qt 6.12. Tautan lain mengikuti pola URL resmi.*

- **Dari kurikulum:** [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) · [Overview: QML and C++ Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html) · [qt_add_qml_module](https://doc.qt.io/qt-6/qt-add-qml-module.html)
- **Makro registrasi:** [`<qqmlintegration.h>` (QML_ELEMENT dkk.)](https://doc.qt.io/qt-6/qqmlintegration-h.html) · [qmltyperegistrar](https://doc.qt.io/qt-6/qtqml-tooling-qmltyperegistrar.html) · [Singletons in QML](https://doc.qt.io/qt-6/qml-singleton.html)
- **Build:** [qt_standard_project_setup](https://doc.qt.io/qt-6/qt-standard-project-setup.html) · [CMake Integration for QML](https://doc.qt.io/qt-6/qtqml-cmake-integration.html) · [Writing QML Modules](https://doc.qt.io/qt-6/qtqml-writing-a-module.html)
- **Fitur khas:** [QQmlListProperty](https://doc.qt.io/qt-6/qqmllistproperty.html) · [QQmlParserStatus](https://doc.qt.io/qt-6/qqmlparserstatus.html) · [QQmlPropertyValueSource](https://doc.qt.io/qt-6/qqmlpropertyvaluesource.html) · [Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)
- **Alat bantu:** [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [Qt QML Language Server](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html)
- **Tutorial:** [Writing QML Extensions with C++](https://doc.qt.io/qt-6/qtqml-tutorials-extending-qml-example.html) · [Context properties (hindari)](https://doc.qt.io/qt-6/qtqml-cppintegration-contextproperties.html)
- **Arch:** [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

**Modul 10.3 selesai.**

# Audit Singkat Modul 10.4

**Terverifikasi benar**
- Pemetaan `QVariantList` ↔ array dan `QVariantMap` ↔ objek, termasuk tonggak versinya, sesuai dokumentasi. Sejak Qt 6.5 properti `QVariantList` pada tipe C++ bisa diubah di tempat oleh QML, dan sejak 6.9 hal yang sama berlaku untuk `QVariantMap`. Hasil konversinya berupa *array-like* dengan metode array dan `length` yang tersinkron, tetapi `Array.isArray()` tetap mengembalikan `false`.
- Bentuk `Connections { function onPesanChanged() {...} }` adalah gaya Qt 6.
- Prinsip "C++ tidak mencari anak QML" tepat. Dokumentasi memperingatkan bahwa memanipulasi objek QML dari C++ tidak direkomendasikan kecuali untuk pengujian dan prototipe, karena ia merusak pemisahan UI QML dari logika C++.

**Perlu koreksi atau penajaman**
1. **Tanggal dan waktu terlalu kasar.** Kurikulum menulis "`QDate`/`QDateTime` ↔ `Date` (berbasis UTC)". Yang benar:
   - `QDateTime` ↔ `Date` adalah pemetaan langsung.
   - `QDate` dipetakan ke awal hari dalam UTC, dengan aturan pemetaan balik yang agak eksentrik. Karena itu `getUTCDate()` lebih bisa diandalkan daripada `getDate()`.
   - Dokumentasi menyarankan memakai properti `QDateTime` agar sisi C++ yang mengendalikan UTC atau waktu lokal.
   - `QTime` menjadi `Date` dengan komponen tanggal buatan yang tak boleh diandalkan.
   - Dua catatan tambahan: bulan di JavaScript bernomor 0–11 sedangkan Qt 1–12, dan string tanggal tanpa jam ditafsirkan sebagai awal hari UTC, berbeda dari `new Date(y, m, d)` yang memakai waktu lokal.
2. **Kepemilikan objek (belum ada).** Kepemilikan data dari C++ ke QML tetap di C++, kecuali `QObject` yang dikembalikan dari pemanggilan method C++ eksplisit: mesin QML mengambil alih, kecuali ia punya induk atau Anda menetapkan `CppOwnership`. Mesin tak pernah menghapus `QObject` yang punya induk. Masuk ke 10.4.7.
3. **Enum.** Belum ada di kurikulum. `enum class` terdaftar sebagai bercakupan (`Message.Status.Ready`) dan tak bercakupan (`Message.Ready`), dan bila ada bentrok nama, pendaftaran tak bercakupan ditimpa oleh enum yang terakhir. Properti `Q_CLASSINFO` `RegisterEnumClassesUnscoped` dan `RegisterEnumsFromRelatedTypes` mengendalikannya. Method/sinyal berparameter enum hanya bisa dipakai bila enum dan method dideklarasikan di kelas yang sama (atau enum itu dari namespace Qt), dan bila ingin tersambung lewat `connect()` JS, enum harus didaftarkan lewat `qRegisterMetaType()`.
4. **Tipe nilai `Q_GADGET`.** Gadget dikirim sebagai nilai, dan bila QML mengubah satu properti sebuah properti gadget, seluruh gadget dibuat ulang dan dikirim balik ke setter C++.
5. **Penanda tipe properti.** Jangan memakai `typedef` atau `using` untuk tipe di `Q_PROPERTY` karena membingungkan moc dan bisa membuat perbandingan tipe gagal.
6. **Sinyal dan handler.** Handler selalu berbentuk `on<Signal>` dengan huruf pertama kapital, dan contoh dokumentasi memakai fungsi panah dengan parameter eksplisit. Parameter bertipe tak terdaftar tidak akan menimbulkan galat, tetapi nilainya tak bisa diakses di handler. Dua signal bernama sama tak bisa dibedakan, dan hanya yang terakhir terlihat di QML.
7. **Daftar objek.** Properti berisi daftar `QObject` harus memakai `QQmlListProperty`, bukan `QList<T>`. Properti kelompok (*grouped*) punya aturan sendiri (10.4.1).
8. **`QQmlProperty::write` vs `setProperty`.** Beda penting yang belum ada: `QQmlProperty::write()` juga menghapus binding, sedangkan `QObject::setProperty()` tidak.
9. **Antarmuka C++ untuk QML, bukan sebaliknya.** Tambahkan tiga jalur resmi: singleton, *initial properties* dengan `required property`, dan model C++ (dokumentasi menyatakan cara terbaik berinteraksi dengan QML dari C++ adalah mendefinisikan antarmuka di C++ lalu mengaksesnya dari QML sendiri).
10. **Belum ada:** `QJSValue` untuk fungsi callback (`QJSValue` adalah wadah nilai, sedangkan `QJSManagedValue` dianjurkan untuk berinteraksi dengannya), dan `pragma NativeMethodBehavior`.

## Daftar isi Modul 10.4 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 10.4.1 | Properti dan binding ke objek C++ (+ `required property`, properti bertipe objek, `QQmlListProperty`, properti kelompok) |
| 10.4.2 | Memanggil `Q_INVOKABLE` (+ *overload*, `QObject*`, `toString`, hasil asinkron) |
| 10.4.3 | `Connections` ke signal C++ (+ bentuk handler, `connect()` di JS, enum pada signal) |
| 10.4.4 | Konversi tipe dan jebakannya (+ tanggal, enum, tipe nilai, `ArrayBuffer`) |
| 10.4.5 | Memanggil QML dari C++ (`QQmlComponent`, `invokeMethod`, `QQmlProperty`, menyambung sinyal QML) |
| 10.4.6 | Prinsip: C++ tidak mencari anak QML (antarmuka lewat singleton / *initial properties* / model) |
| 10.4.7 | Kepemilikan objek lintas C++/QML `[TAMBAHAN]` |
| 10.4.8 | `QJSValue` dan callback `[TAMBAHAN]` |
| 10.4.9 | Lab terpadu: konversi, kepemilikan, callback, C++→QML `[TAMBAHAN]` |

---

# Modul 10.4 — Memakai Objek C++ dari QML dan Sebaliknya

## Deskripsi dan peran dalam kurikulum

Di 10.2 Anda membuat `QObject` yang "terbaca" meta-object. Di 10.3 Anda mendaftarkannya sebagai tipe QML. Modul ini adalah **praktik pemakaiannya sehari-hari**:
- membaca dan mengikat properti,
- memanggil method,
- mendengar sinyal,
- memahami bagaimana data berubah bentuk saat menyeberang,
- dan kadang menggerakkan QML dari C++.

Modul ini juga tempat jebakan paling mahal: kepemilikan objek yang kabur, tanggal yang bergeser sehari, dan UI yang bergantung pada C++ yang menyelinap ke pohon QML.

## Konsep kunci dan filosofi

**Analogi.** Antarmuka antara dua dunia harus berupa pintu sempit yang jelas. C++ mengekspos objek, QML memakainya. Jangan biarkan C++ menyelinap ke ruang QML mencari anak dengan nama tertentu.

**Tiga peran di batas**

```
                 properti (keadaan)  + NOTIFY
   C++  ------------------------------------------>  QML (tampilan, binding)
 (logika)       Q_INVOKABLE (perintah)  <-----------   (aksi pengguna)
        ------------ signal (peristiwa/hasil) ---->
```

**Lima aturan emas modul ini**
1. Properti untuk keadaan, signal untuk peristiwa, `Q_INVOKABLE` untuk perintah (dari 10.2).
2. Data lewat batas harus bertipe yang dikenali mesin (10.4.4).
3. Tahu siapa pemilik tiap objek yang menyeberang (10.4.7).
4. Arah ketergantungan: **QML memakai C++**, bukan C++ menguasai QML (10.4.6).
5. Semua yang dipanggil dari QML adalah permukaan serangan. Validasi parameter, dan ekspos sesedikit mungkin.

**Pondasi sintaks yang dipakai**
- Di QML, `backend.pesan` membaca properti, `backend.tambah()` memanggil method, dan `onSelesai` menanggapi signal `selesai`.
- Di C++, `QObject::property`, `QMetaObject::invokeMethod`, dan `QObject::connect` berbicara ke meta-object yang sama.
- `required property T nama` di QML menyatakan "nilai ini wajib diberikan dari luar".

## 10.4.1 Properti dan binding ke objek C++

> *Satu ikatan yang benar membuat UI memperbarui dirinya sendiri.*

**Konsep.** Semua properti kelas turunan `QObject` atau `Q_GADGET` dapat diakses dari QML. Binding bekerja karena sinyal `NOTIFY`. Untuk interoperabilitas maksimum, properti yang bisa ditulis sebaiknya punya `NOTIFY` yang dipancarkan setiap kali nilainya berubah. Bila tidak, nilai awalnya terbaca tetapi perubahan berikutnya tidak, dan upaya mengikatnya dari QML menghasilkan peringatan runtime.

```qml
import QtQuick
import QtQuick.Controls
import Hello

Item {
    Backend { id: backend }

    Label { text: backend.pesan }                           // binding: ikut berubah
    Label { text: 'Hitungan: ' + backend.hitungan }          // ekspresi yang bergantung pada properti
    Button { text: 'Atur'; onClicked: backend.pesan = 'baru' }   // menulis lewat WRITE
}
```

**Bedah kode**
- `Backend { id: backend }` membuat objek C++ dari QML (10.3).
- `text: backend.pesan` memanggil `Backend::pesan()` dan berlangganan ke `pesanChanged`. Setiap emit memicu evaluasi ulang.
- `backend.pesan = 'baru'` memanggil `Backend::setPesan()`. Setter yang menjaga nilai sama (10.2) mencegah emit berlebih.

**Tiga cara menyediakan objek backend ke QML**

| Cara | Pemilik | Jangkauan | Cocok untuk |
| --- | --- | --- | --- |
| `Backend { id: backend }` di QML | QML | Komponen itu | Objek sederhana, satu pemakai |
| Singleton `QML_SINGLETON` (10.3.3) | Engine | Seluruh modul | Tema, konfigurasi, layanan |
| *Initial property* dari C++ | C++ | Komponen akar | Backend yang dibuat dan dimiliki C++ |

```cpp
// main.cpp: backend dimiliki C++, dikirim ke QML sebagai properti awal
Backend backend;                                           // dideklarasikan SEBELUM engine
QQmlApplicationEngine engine;
engine.setInitialProperties({ { u"backend"_s, QVariant::fromValue(&backend) } });
engine.loadFromModule("Hello", "Main");
```

```qml
// Main.qml
ApplicationWindow {
    required property Backend backend       // wajib diisi dari luar
    Label { text: backend.pesan }
}
```

Properti `required` melindungi komponen agar tak dibuat tanpa properti itu. Untuk menginisialisasi, panggil `createWithInitialProperties`, `QQmlApplicationEngine::setInitialProperties`, atau `QQuickView::setInitialProperties`. Karena `backend` dideklarasikan sebelum `engine`, ia dihancurkan setelah engine (urutan terbalik), jadi QML tak pernah memegang pointer menggantung.

**Properti bertipe objek**

Properti bertipe objek bisa diakses dari QML bila tipenya terdaftar. Bila `MessageBody` juga terdaftar, Anda dapat menetapkannya dari QML.

```qml
Pesan {
    isi: IsiPesan { teks: 'Halo, dunia!' }     // mengisi properti bertipe objek
}
```

**Daftar objek: `QQmlListProperty`**

Untuk properti berisi daftar `QObject`, gunakan `QQmlListProperty`, bukan `QList<T>`, karena `QList` bukan turunan `QObject` dan tak dapat memberi karakteristik properti QML seperti notifikasi saat daftar berubah. Parameter templat (`Message`) harus terdaftar. Contoh sederhana ada di 10.3.7.

**Properti kelompok (*grouped property*)**

```cpp
class Kredensial : public QObject {          // objek anak
    Q_OBJECT
    QML_ANONYMOUS
    Q_PROPERTY(QString nama  READ nama  WRITE setNama  NOTIFY namaChanged FINAL)
    Q_PROPERTY(QString surel READ surel WRITE setSurel NOTIFY surelChanged FINAL)
    // ...
};

class Akun : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(Kredensial *kredensial READ kredensial CONSTANT FINAL)
public:
    explicit Akun(QObject *parent = nullptr)
        : QObject(parent), m_kredensial(new Kredensial(this)) {}   // dibuat di konstruktor
    Kredensial *kredensial() const { return m_kredensial; }
private:
    Kredensial *m_kredensial;
};
```

```qml
Akun {
    kredensial.nama: 'Alexandra'
    kredensial.surel: 'alexandra@contoh.id'
}
```

Penulisan berkelompok tidak membuat objek, hanya menulis ke objek yang dikembalikan getter. Nama sub-properti dicocokkan dengan tipe yang *dideklarasikan*, dan objek harus sudah ada saat penugasan, kalau tidak muncul galat bahwa properti tak bisa diatur karena null. Praktik baik: jaga objek properti kelompok tetap hanya-baca, dan hindari sintaks kelompok bila Anda juga memanipulasi properti induknya.

**Penanda tipe.** Tulis tipe langsung di `Q_PROPERTY` (`Foo::Enum`), jangan lewat `typedef`/`using`, karena membingungkan moc.

**Opsi lain**
- **`BINDABLE`** (10.2.7) untuk properti yang saling bergantung di sisi C++.
- **`CONSTANT`** untuk sub-objek yang dibuat sekali. Atribut ini hanya untuk properti yang nilainya ditetapkan dan final di konstruktor.
- **Singleton** untuk keadaan global yang memang satu.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Properti dapat ditulis tanpa `NOTIFY` | Tambah `NOTIFY` (atau `CONSTANT` bila memang tetap) |
| Mengubah anggota data langsung dari C++ | Pakai setter/`setProperty`; anggota langsung tak memberi kabar |
| `Q_PROPERTY` dengan tipe `using` | Tulis tipe aslinya |
| Properti kelompok dengan sub-objek `nullptr` | Buat sub-objek di konstruktor |
| `QList<T *>` sebagai tipe properti | `QQmlListProperty<T>` |

## 10.4.2 Memanggil `Q_INVOKABLE`

> *Perintah yang jelas membuat antarmuka tak perlu menebak.*

**Konsep.** Method dapat dipanggil dari QML bila ia method publik bertanda `Q_INVOKABLE`, atau slot publik. Nilai kembalian dikonversi ke nilai JavaScript.

```qml
Button {
    text: 'Hitung'
    onClicked: {
        const hasil = backend.tambahDengan(5)         // Q_INVOKABLE int tambahDengan(int)
        console.log('hasil:', hasil, '| format:', backend.format(hasil))
    }
}
```

**Aturan yang sering dilupakan**
- **Overload:** QML mendukung pemanggilan fungsi C++ yang ditumpuk-nama. Fungsi yang benar dipilih menurut jumlah dan tipe argumen.
- **Parameter `QObject*`:** nilainya dapat diteruskan dari QML dengan `id` objek atau nilai JavaScript `var` yang merujuk ke objek.
- **Mengganti `toString`:** method `Q_INVOKABLE` bernama `toString` tanpa argumen akan dipakai untuk mengubah objek menjadi string menggantikan implementasi JavaScript.
- **Objek `this` pada method C++:** secara historis `this` dari method berbasis C++ terikat mati pada method. Sejak Qt 6.5 Anda bisa memilih perilaku benar dengan menambahkan `pragma NativeMethodBehavior: AcceptThisObject` di dokumen QML. Berguna bila memanggil `child.invoke.call(this)`.

**Perintah yang lama: jangan blokir, kirim hasil lewat signal**

```cpp
class Pemuat : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE void mulai(const QString &kunci);          // kembali segera
signals:
    void hasilSiap(const QString &kunci, int nilai);
    void galat(const QString &pesan);
};
```

```qml
Pemuat {
    id: pemuat
    onHasilSiap: (kunci, nilai) => console.log(kunci, '=', nilai)
    onGalat: (pesan) => console.warn('gagal:', pesan)
}
Button { text: 'Muat'; onClicked: pemuat.mulai('profil') }
```

Pola ini menjaga UI tetap mulus. Bagaimana pekerjaan sebenarnya dijalankan di thread lain dibahas di 10.7.

**Keamanan: setiap `Q_INVOKABLE` adalah titik masuk.**
- Jangan mengekspos perintah generik ("jalankan string ini", "baca berkas ini") yang parameternya bebas.
- Validasi dan batasi setiap parameter dari QML: panjang, rentang, jalur yang diizinkan. Anggap isinya tak tepercaya, terutama bila QML berasal dari plugin atau berkas yang bisa diubah pengguna.
- Beri nama tindakan sempit (`bukaProfil(id)`), bukan fungsi serbaguna (`jalankan(cmd)`). Ini tersambung langsung ke 10.6.

**Opsi lain.** Slot publik (`public slots:`) sama-sama bisa dipanggil dan bisa disambungkan lewat gaya string. `QJSValue` callback (10.4.8) bila hasil dikembalikan ke fungsi.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Method berat dan sinkron | Mulai asinkron, kirim hasil lewat signal (10.7) |
| Parameter bertipe tak dikenal mesin | Pakai tipe dasar/terdaftar, `QVariant`, atau `QJSValue` |
| Mengandalkan overload yang ambigu | Beri nama berbeda |
| Menaruh perintah berbahaya tanpa validasi | Validasi di sisi C++ |
| Mengharapkan `this` kustom pada method C++ | `pragma NativeMethodBehavior: AcceptThisObject` (≥ 6.5) |

## 10.4.3 `Connections` ke signal C++

> *Siapa pun boleh mendengar, pemancar tak perlu tahu siapa.*

**Konsep.** Mesin QML otomatis membuat penangan signal untuk setiap signal tipe turunan `QObject` yang dipakai dari QML. Penangan bernama `on<Signal>` dengan huruf pertama dikapitalkan, dan semua parameter signal tersedia lewat nama parameternya.

```qml
Backend {
    id: backend
    // (1) handler langsung pada objek: bentuk fungsi panah dengan parameter eksplisit
    onSelesai: (hasil) => console.log('selesai:', hasil)
}

// (2) objek terpisah yang mendengarkan target, termasuk target yang bisa berganti
Connections {
    target: backend
    function onSelesai(hasil) { console.log('selesai (Connections):', hasil) }
    function onPesanChanged() { console.log('pesan ->', backend.pesan) }
}
```

**Bedah kode**
- **Bentuk (1)** dipakai bila Anda memiliki objeknya di tempat itu. `(hasil) => ...` memberi nama parameter secara eksplisit, seperti contoh dokumentasi.
- **Bentuk (2)** untuk mendengarkan objek yang dideklarasikan di tempat lain, atau yang `target`-nya berubah. `function onSelesai(hasil)` adalah bentuk Qt 6, dengan nama fungsi `on` + nama signal berawalan kapital.
- Signal tanpa parameter (`pesanChanged`) tak butuh argumen.
- Konvensi penamaan: nama `NOTIFY` yang disarankan `<properti>Changed`, karena handler yang dibuat mesin selalu `on<Properti>Changed` apa pun nama signal C++ yang bersangkutan.

**Menyambung dari JavaScript (dinamis)**

```qml
Component.onCompleted: {
    backend.selesai.connect(function (hasil) { console.log('dinamis:', hasil) })
    // backend.selesai.disconnect(fungsi)   ← untuk memutus
}
```

Bila signal C++ berparameter enum akan disambungkan ke fungsi QML lewat `connect()`, tipe enum itu harus didaftarkan lewat `qRegisterMetaType()`.

**Aturan tentang signal**
- Kelas boleh punya beberapa signal bernama sama, tetapi hanya yang terakhir yang terlihat sebagai signal QML, dan signal bernama sama dengan parameter berbeda tak bisa dibedakan. Beri nama signal yang unik.
- Parameter signal bertipe yang tak didukung mesin tidak menimbulkan galat, tetapi nilainya tak dapat diakses dari handler. Jadi jika parameter tampak `undefined`, periksa kembali tipenya.
- Method/signal berparameter enum hanya dapat dipakai bila enum dan method/signal dideklarasikan di kelas yang sama, atau bila enum itu berasal dari namespace Qt.

**Opsi lain**
- **`Connections { enabled: false }`** untuk menonaktifkan sementara.
- **`target: null`** untuk target yang belum ada.
- **Signal bertanda parameter-nama lama** (`onSelesai: console.log(hasil)` dengan penyuntikan implisit) adalah bentuk lama. Pilih bentuk eksplisit (`(hasil) =>` atau `function onSelesai(hasil)`) agar dapat diperiksa `qmllint`.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Parameter handler `undefined` | Periksa tipe parameter terdaftar, dan pakai nama parameter eksplisit |
| Salah huruf kapital pada nama handler | `onSelesai` untuk `selesai`, `onPesanChanged` untuk `pesanChanged` |
| Dua signal senama dengan argumen berbeda | Beri nama berbeda |
| Menyambung signal berparameter enum dari JS tanpa `qRegisterMetaType` | Daftarkan tipenya |

## 10.4.4 Konversi tipe dan jebakannya

> *Data yang menyeberang selalu berganti pakaian. Kenali pakaiannya.*

**Konsep.** Data yang bertukar antara QML dan C++ dikonversi mesin ke tipe yang tepat, dan ini mensyaratkan tipe itu dikenali mesin.

**Tipe dasar (otomatis)**

| Qt (C++) | QML |
| --- | --- |
| `bool`, `int`/`unsigned int`, `double` | `bool`, `int`, `double` |
| `float`, `qreal` | `real` |
| `QString`, `QUrl` | `string`, `url` |
| `QColor`, `QFont` | `color`, `font` |
| `QDateTime` | `date` |
| `QPoint(F)`, `QSize(F)`, `QRect(F)` | `point`, `size`, `rect` |
| `QMatrix4x4`, `QQuaternion`, `QVector2D/3D/4D` | `matrix4x4`, `quaternion`, `vector2d/3d/4d` |

Kelas dari modul Qt GUI seperti `QColor` dan `QFont` hanya tersedia di QML bila modul Qt Quick disertakan. Banyak tipe ini bisa ditulis dengan string, mis. `sourceSize: "100x200"`.

**Tipe turunan `QObject`.** Kelas turunan `QObject` apa pun dapat dipakai sebagai tipe pertukaran data bila terdaftar di sistem tipe QML. Mesin mendukung tipe yang bisa dibuat maupun tidak.

**Daftar dan peta**

```cpp
Q_INVOKABLE QString ringkas(const QVariantList &l, const QVariantMap &m) const;
```

```qml
console.log(probe.ringkas([1, 'dua', true], { a: 1, b: 2 }))   // array/objek JS ⇄ QVariantList/Map
```

- Dari C++ ke QML, `QVariantList` dan wadah berurutan lain menjadi *array-like* yang punya metode array dan sinkron `length`, namun `Array.isArray()` tetap `false`. Pakai metode array (`.map`, `.filter`), jangan bergantung pada `Array.isArray`.
- Dari QML ke C++, array/objek JS dikonversi otomatis ke `QVariantList`/`QVariantMap`.
- Untuk daftar yang besar atau sering berubah, pakai model C++ (10.5), bukan `QVariantList` yang dikirim bolak-balik.

**Tanggal dan waktu (jebakan besar)**

```qml
console.log(probe.tanggal.getUTCDate(), probe.tanggal.getDate())   // QDate → Date (UTC awal hari)
console.log(probe.waktu.toISOString())                             // QDateTime → Date
```

- Untuk `QDate`, `getUTCFullYear()`, `getUTCMonth()`, dan `getUTCDate()` lebih mungkin memberi hasil yang diharapkan daripada versi tanpa UTC.
- Lebih aman: pakai properti `QDateTime` dan tentukan sendiri UTC atau lokal di sisi C++.
- Bulan JS 0–11, bulan Qt 1–12. Tulis `new Date(2026, 10, 27)` untuk 27 November.

**`QByteArray` ↔ `ArrayBuffer`.** Dikonversi otomatis antara `QByteArray` dan `ArrayBuffer` JavaScript.

**Tipe nilai (`Q_GADGET`).** Kelas yang diberi `Q_GADGET` dapat direpresentasikan sebagai objek JS dengan properti dari `Q_PROPERTY` dan fungsi dari `Q_INVOKABLE`. Registrasi diperlukan untuk gadget karena tak punya basis bersama yang dikenal. Perilaku nilai: bila QML mengubah satu properti sebuah properti gadget, seluruh gadget dibuat ulang dan dikirim kembali ke setter C++.

**Enum**

```cpp
class Pesan : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(Status status READ status NOTIFY statusChanged FINAL)
public:
    enum class Status { Siap, Memuat, Galat };
    Q_ENUM(Status)
    // ...
};
```

```qml
Pesan {
    onStatusChanged: {
        if (status === Pesan.Status.Siap) console.log('siap')     // bercakupan
        // Pesan.Siap juga berlaku (tak bercakupan), selama tak bentrok nama
    }
}
```

Nama nilai enum harus berawalan huruf kapital agar dapat diakses dari QML. Daftarkan kelas induk enum secara eksplisit dengan `QML_ELEMENT`/`QML_NAMED_ELEMENT`, jangan bergantung pada enum yang disuntikkan ke tipe lain lewat tipe properti terkait (`RegisterEnumsFromRelatedTypes`).

**Aturan batas**
- Semua yang dikirim harus bertipe yang dikenal mesin: dasar Qt, tipe terdaftar, `QVariant`, atau `QJSValue`.
- Hindari mengirim struktur besar bolak-balik tiap frame. Kirim *perubahan* (signal), atau pakai model (10.5).
- Konversi bisa menyalin. Untuk data besar, simpan di C++ dan kirim kecil-kecil atau berdasarkan permintaan.

**Opsi lain.** `QJSValue` untuk menyimpan nilai bebas dan fungsi (10.4.8). `QJSEngine::newArray()` bila ingin membuat array JS sebenarnya yang lolos `Array.isArray()` dan tak butuh konversi lagi.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| `Array.isArray(daftar)` bernilai `false` | Pakai metode array (array-like), atau `Array.from(daftar)` bila perlu array asli |
| `QDate` bergeser sehari di zona barat UTC | `getUTC*`, atau pakai `QDateTime` |
| Bulan off-by-one | JS 0–11, Qt 1–12 |
| Enum tak ditemukan | `Q_ENUM`, kelas terdaftar, nama berawalan kapital |
| Parameter signal `undefined` | Daftarkan tipenya |
| Kirim `QVariantList` besar tiap frame | Model C++ atau perubahan bertahap |

## 10.4.5 Memanggil QML dari C++

> *Kadang jembatan dua arah memang diperlukan. Bangun dengan hati-hati.*

**Konsep.** Semua objek QML adalah turunan `QObject`. Mesin QML dapat memakai sistem meta-objek untuk membuat dan memeriksa objek QML apa pun secara dinamis, sehingga objeknya bisa dibaca, ditulis, dipanggil, dan didengar dari C++. Pakai untuk **pengujian dan prototipe**, bukan sebagai arsitektur utama (10.4.6).

**Memuat dokumen**

```cpp
QQmlEngine engine;
QQmlComponent component(&engine, "Hello", "Main");      // modul + nama tipe
QObject *objek = component.create();                      // atau createWithInitialProperties({...})
// ... pakai objek ...
delete objek;                                             // create() tak mengalihkan kepemilikan
```

`QQmlComponent` memuat dokumen QML sebagai objek C++ yang bisa diubah dari kode C++. `QQuickView` melakukan hal serupa sekaligus menampilkannya sebagai jendela. `QQmlComponent::create()` membuat instans baru, sedangkan `QQuickView` membuatnya otomatis dan menyediakan `rootObject()`.

**Membaca dan menulis properti**

```cpp
objek->setProperty("width", 500);                 // tidak menghapus binding
QQmlProperty(objek, "width").write(500);          // menghapus binding juga
qDebug() << QQmlProperty::read(objek, "someNumber").toInt();
```

Beda keduanya: `QQmlProperty::write()` juga menghapus binding, sedangkan `setProperty()` tidak. Bila `width` terikat ke `height` dan Anda memakai `setProperty`, `width` akan diperbarui lagi saat `height` berubah, karena binding masih aktif.

Selalu ubah properti QML lewat `setProperty()`, `QQmlProperty`, atau `QMetaProperty::write()`, supaya mesin tahu perubahannya. Mengubah anggota data langsung melewati meta-objek, sehingga binding tak diperbarui dan penangan `onXxxChanged` tak terpanggil.

**Memanggil fungsi QML**

```qml
// Main.qml
ApplicationWindow {
    function sapa(nama: string): string { return 'Halo ' + nama }
}
```

```cpp
QString balasan;
QMetaObject::invokeMethod(root, "sapa",
                          Q_RETURN_ARG(QString, balasan),
                          Q_ARG(QString, QStringLiteral("dari C++")));
```

Tipe parameter dan hasil dapat dinyatakan setelah titik dua di QML (`msg: string`). Tanpa tipe, atau dengan `var`, Anda harus memakai `QVariant` pada `Q_RETURN_ARG` dan `Q_ARG`.

**Menyambung ke signal QML**

```qml
ApplicationWindow {
    id: root
    signal qmlSignal(msg: string)
}
```

```cpp
class Penerima : public QObject
{
    Q_OBJECT
public slots:
    void terima(const QString &pesan) { qDebug() << "dari QML:" << pesan; }
};

QObject::connect(root, SIGNAL(qmlSignal(QString)), penerima, SLOT(terima(QString)));
```

Semua signal QML otomatis tersedia di C++ dan dapat disambungkan dengan `QObject::connect()` seperti signal C++ biasa. Signal QML tak punya pointer fungsi anggota C++, jadi memakai sintaks string `SIGNAL`/`SLOT`. Tipe objek QML pada parameter signal diterjemahkan menjadi pointer ke kelasnya di C++; untuk itu sambungkan dengan `QVariant` pada signature dan terima di slot sebagai pointer.

**Mencari anak (hindari)**

```cpp
QObject *rect = objek->findChild<QObject *>("rect");      // butuh objectName di QML
if (rect) rect->setProperty("color", "red");
```

Satu `objectName` bisa dimiliki banyak objek (mis. delegate `ListView`), sehingga `findChildren()` dipakai untuk semuanya. Ini cara paling rapuh. Lihat 10.4.6.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Mengira `create()` mengalihkan kepemilikan | Hapus objek atau beri induk sendiri |
| `setProperty` dikira menghapus binding | Pakai `QQmlProperty::write` |
| Mengubah anggota data langsung | Setter / `setProperty` |
| `invokeMethod` tanpa tipe pada fungsi QML bertipe | Cocokkan tipe, atau pakai `QVariant` bila tak bertipe |
| `findChild` pada delegate | `findChildren`, atau jangan lakukan |

## 10.4.6 Prinsip: C++ tidak mencari anak QML

> *Antarmuka yang sempit dan eksplisit membuat kedua dunia bebas berubah.*

**Alasan.** Dengan cara lain, refactoring QML mudah memutus interaksi QML/C++. Memiliki interaksi yang digerakkan dari QML jauh lebih mudah dipikirkan oleh pengguna dan alat seperti `qmllint`. Mengakses QML dari C++ menghasilkan QML yang tak bisa dipahami tanpa memverifikasi secara manual bahwa tak ada kode C++ luar yang mengubah komponennya, dan cakupan akses itu bisa berubah seiring waktu sehingga menjadi beban perawatan.

```
 SALAH (C++ menguasai QML)          BENAR (QML memakai antarmuka C++)
 C++ --findChild--> pohon QML       C++ mengekspos objek/model
 C++ --setProperty--> Rectangle     QML mengikat dan menyambung ke objek itu
 ubah QML => C++ patah              ubah QML => C++ tak terdampak
```

**Dua jalur resmi** (dokumentasi mendefinisikan antarmuka di C++ lalu mengaksesnya dari QML:)

1. **Singleton:** daftarkan antarmuka dengan `QML_SINGLETON`. Pakai bila antarmuka dibutuhkan di lebih dari komponen akar, karena meneruskan objek ke bawah memerlukan properti eksplisit atau akses tanpa kualifikasi yang lambat dan tak disarankan.
2. **Initial properties:** tandai antarmuka `QML_UNCREATABLE`, berikan ke komponen akar lewat `createWithInitialProperties()`/`setInitialProperties()`, dan pakai `required property` di QML. Metode ini dipilih bila antarmuka hanya perlu tersedia bagi komponen akar, dan memudahkan sambungan signal/slot dari sisi C++.

Bila keduanya tak cukup: pertimbangkan model C++.

**Mengubah keadaan singleton dari C++.** Gunakan `QQmlEngine::singletonInstance<T *>(modul, tipe)`.

```cpp
auto *tema = engine.singletonInstance<Tema *>("Hello", "Tema");
```

**Aturan praktis**
- Mulai dari pertanyaan: "Apakah QML bisa memakai objek C++ ini?" Bukan: "Bagaimana C++ memanipulasi tombol itu?"
- Boleh memakai akses C++→QML untuk pengujian otomatis, prototipe, dan alat bantu pengembangan.

## 10.4.7 Kepemilikan objek lintas C++/QML `[TAMBAHAN]`

> *Siapa yang menghapus objek ini? Jawablah sebelum menulis baris pertama.*

**Aturan inti** (kepemilikan data dari C++ ke QML tetap di C++, kecuali `QObject` dari method C++ eksplisit, yang diambil mesin QML kecuali punya induk atau `CppOwnership` ditetapkan; mesin tak pernah menghapus `QObject` berinduk).

| Situasi | Pemilik | Catatan |
| --- | --- | --- |
| `Probe { }` di QML | QML (pohon objek QML) | Dihancurkan bersama komponennya |
| `Q_INVOKABLE QObject *buat()` tanpa induk | Mesin QML (JS GC) | Dihancurkan saat tak lagi dirujuk |
| `Q_INVOKABLE QObject *buat()` dengan induk | Induk (C++) | Mesin tak menghapus |
| Objek yang dikirim lewat properti/sinyal | C++ | Tetap milik C++ |
| Setelah `QQmlEngine::setObjectOwnership(o, QQmlEngine::CppOwnership)` | C++ | Mesin tak akan menghapus |
| `QQmlComponent::create()` | Pemanggil | Anda yang menghapus (`delete`) |
| Singleton buatan engine | Engine | Dihancurkan bersama engine |

```cpp
Q_INVOKABLE QObject *buat(bool beriInduk)
{
    auto *o = new QObject(beriInduk ? this : nullptr);
    return o;       // beriInduk=false → dimiliki mesin QML dan dihancurkan oleh GC
}
```

**Dua bahaya simetris**
- **Kebocoran:** objek tanpa induk yang kepemilikannya tidak jelas, disimpan C++ sementara mesin mengira boleh membuangnya, atau sebaliknya.
- **Kerusakan:** C++ menyimpan pointer mentah ke objek yang kemudian dihapus GC QML (*use-after-free*).

**Pegangan**
1. Beri induk pada objek yang diserahkan ke QML, atau tetapkan `CppOwnership` secara eksplisit bila C++ yang menyimpannya.
2. Jangan simpan pointer mentah ke objek hasil `Q_INVOKABLE` tanpa induk. Pakai `QPointer`.
3. Objek yang dibuat C++ lalu dikirim ke QML sebaiknya dimiliki C++ lewat induk.
4. Waspadai `destroyed`: tak aman memanggil fungsi `QObject` pada objek yang sedang dihancurkan dalam sinyal `destroyed`. Tangkap datanya sebelum itu.

**Jebakan.** Mengembalikan `new X` dari `Q_INVOKABLE` tanpa induk dan menyimpannya di anggota C++. Menyimpan `QObject*` dari sinyal tanpa `QPointer`.

## 10.4.8 `QJSValue` dan callback `[TAMBAHAN]`

> *Fungsi yang bisa dibawa lintas dunia memberi fleksibilitas, dengan tanggung jawabnya.*

**Konsep.** `QJSValue` adalah wadah tipe Qt/JavaScript, termasuk fungsi, array, dan objek, dipakai untuk mengirim nilai ke dan dari engine. `QJSManagedValue` dipakai untuk berinteraksi dengan nilai JavaScript, dan hidup singkat. Aturannya: **simpan dengan `QJSValue`, bekerja dengan `QJSManagedValue`.**

```cpp
Q_INVOKABLE void hitungLalu(int n, const QJSValue &callback)
{
    QJSManagedValue fn(callback, qjsEngine(this));         // engine dari objek terdaftar
    if (!fn.isFunction()) return;
    fn.call({ QJSValue(n * 2) });                          // panggil fungsi JS dari C++
}
```

```qml
probe.hitungLalu(21, function (hasil) { console.log('callback menerima', hasil) })   // 42
```

**Bedah kode**
- `const QJSValue &callback` menerima fungsi JS apa pun dari QML.
- `qjsEngine(this)` mendapatkan engine dari objek `QObject` yang terdaftar.
- `QJSManagedValue fn(callback, engine)` membungkus nilai agar bisa dipanggil. Konstruktornya mensyaratkan pointer `QJSEngine`.
- `fn.call({...})` memanggil fungsi dengan argumen. `QJSManagedValue` sebaiknya dibuat sementara di tumpukan dan dibuang setelah selesai, jangan dipakai sebagai tipe antarmuka (parameter, nilai kembali, atau properti).
- Pengecualian JS di dalam callback tidak otomatis melempar ke C++. `QJSManagedValue` membiarkan pengecualian tetap utuh, dan `QJSEngine::catchError` dipakai untuk menanganinya.

**Kapan callback, kapan signal?**

| Kebutuhan | Pilihan |
| --- | --- |
| Hasil satu kali untuk satu pemanggil | Callback `QJSValue` |
| Banyak pendengar atau hasil berulang | Signal |
| Hasil dari thread lain | Signal (queued) lalu panggil callback di thread engine |

**Jebakan.** Memanggil `QJSValue` dari thread lain (engine hanya aman di thread-nya). Menyimpan callback tanpa memikirkan siklus hidup. Mengabaikan galat yang dilempar callback.

## 10.4.9 Lab terpadu `[TAMBAHAN]`

Lab ini melanjutkan `apphello` dari 10.3 dan melatih konversi tipe, kepemilikan, callback, dan C++→QML. Berkas baru: `probe.h`, `penerima.h`. `backend.h/.cpp`, `tema.h`, `mode.h` tetap.

```cpp
// probe.h
#pragma once
#include <QByteArray>
#include <QDate>
#include <QDateTime>
#include <QDebug>
#include <QJSManagedValue>
#include <QJSValue>
#include <QObject>
#include <QQmlEngine>
#include <QTimeZone>
#include <QVariantList>
#include <QVariantMap>
#include <QtQml/qqmlregistration.h>

class Probe : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QDate tanggal READ tanggal CONSTANT FINAL)
    Q_PROPERTY(QDateTime waktu READ waktu CONSTANT FINAL)
    Q_PROPERTY(QVariantList daftar READ daftar CONSTANT FINAL)
    Q_PROPERTY(QByteArray biner READ biner CONSTANT FINAL)

public:
    explicit Probe(QObject *parent = nullptr) : QObject(parent) {}

    QDate tanggal() const { return QDate(2026, 11, 27); }
    QDateTime waktu() const
    {
        return QDateTime(QDate(2026, 11, 27), QTime(8, 30), QTimeZone::UTC);
    }
    QVariantList daftar() const { return { 10, QStringLiteral("botol"), true }; }
    QByteArray biner() const { return QByteArray("\x01\x02\x03", 3); }

    Q_INVOKABLE QString ringkas(const QVariantList &l, const QVariantMap &m) const
    {
        return QStringLiteral("daftar=%1 elemen, peta=%2 kunci").arg(l.size()).arg(m.size());
    }

    Q_INVOKABLE QObject *buat(bool beriInduk)
    {
        auto *o = new QObject(beriInduk ? this : nullptr);
        const QString nama = beriInduk ? QStringLiteral("berinduk")
                                       : QStringLiteral("tanpa-induk");
        o->setObjectName(nama);
        connect(o, &QObject::destroyed, [nama] { qDebug() << "dihancurkan:" << nama; });
        return o;
    }

    Q_INVOKABLE void hitungLalu(int n, const QJSValue &callback)
    {
        QJSManagedValue fn(callback, qjsEngine(this));
        if (!fn.isFunction()) return;
        fn.call({ QJSValue(n * 2) });
    }
};
```

```cpp
// penerima.h
#pragma once
#include <QDebug>
#include <QObject>

class Penerima : public QObject
{
    Q_OBJECT
public:
    explicit Penerima(QObject *parent = nullptr) : QObject(parent) {}
public slots:
    void terima(const QString &pesan) { qDebug() << "C++ menerima dari QML:" << pesan; }
};
```

```cpp
// main.cpp
#include "penerima.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, [] { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("Hello", "Main");

    // --- C++ -> QML (hanya untuk uji/pembelajaran; lihat 10.4.6) ---
    if (QObject *root = engine.rootObjects().value(0)) {
        QString balasan;
        QMetaObject::invokeMethod(root, "sapa",
                                  Q_RETURN_ARG(QString, balasan),
                                  Q_ARG(QString, QStringLiteral("dari C++")));
        qDebug() << "QML membalas:" << balasan;

        auto *penerima = new Penerima(root);               // anak root: dihapus bersama root
        QObject::connect(root, SIGNAL(qmlSignal(QString)), penerima, SLOT(terima(QString)));
    }

    return app.exec();
}
```

Tambahkan `probe.h penerima.h` ke `SOURCES` di `CMakeLists.txt` (dari 10.3.8).

```qml
// Main.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Hello

ApplicationWindow {
    id: root
    visible: true; width: 560; height: 520
    title: 'Lab 10.4'
    color: Tema.latar

    signal qmlSignal(msg: string)
    function sapa(nama: string): string { return 'Halo ' + nama }

    property var anak: null

    Backend { id: backend }
    Probe { id: probe }

    Component.onCompleted: {
        console.log('QDate  : UTC', probe.tanggal.getUTCDate(), '| lokal', probe.tanggal.getDate())
        console.log('QDateTime:', probe.waktu.toISOString())
        console.log('daftar : isArray =', Array.isArray(probe.daftar), '| panjang', probe.daftar.length, '|', probe.daftar[1])
        console.log('biner  : ArrayBuffer =', probe.biner instanceof ArrayBuffer, '| byteLength', probe.biner.byteLength)
        console.log(probe.ringkas([1, 'dua', true], { a: 1, b: 2 }))
        probe.hitungLalu(21, function (hasil) { console.log('callback menerima', hasil) })
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Label { text: 'Pesan: ' + backend.pesan; color: Tema.teks }
        Label { text: 'Hitungan: ' + backend.hitungan; color: Tema.teks }
        Label { text: backend.status === Backend.Status.Siap ? 'Siap' : 'Sibuk'; color: Tema.aksen }

        Button { text: 'Tambah'; onClicked: backend.tambah() }
        Button { text: 'Muat ulang'; onClicked: backend.muatUlang() }
        Button { text: 'Kirim sinyal QML ke C++'; onClicked: root.qmlSignal('klik dari QML') }
        Button { text: 'Anak berinduk'; onClicked: root.anak = probe.buat(true) }
        Button {
            text: 'Anak tanpa induk lalu GC'
            onClicked: { root.anak = probe.buat(false); root.anak = null; gc() }
        }
    }

    Connections {
        target: backend
        function onSelesai(hasil) { console.log('selesai pada hitungan', hasil) }
    }
}
```

```bash
cmake -S . -B build && cmake --build build && ./build/apphello
TZ=America/Los_Angeles ./build/apphello          # lihat QDate bergeser di zona barat UTC
```

**Yang diamati**
1. `QDate  : UTC 27 | lokal 27` di zona Anda, dan **`lokal 26`** dengan `TZ=America/Los_Angeles`. `UTC` selalu 27. Ini demonstrasi jebakan `QDate`.
2. `daftar : isArray = false`, tetapi `.length` dan indeks bekerja.
3. `biner : ArrayBuffer = true`, `byteLength 3`.
4. `callback menerima 42`: C++ memanggil fungsi JS.
5. Klik "Anak berinduk": tak ada pesan dihancurkan. Anak itu milik `probe` dan baru mati bersama `probe`.
6. Klik "Anak tanpa induk lalu GC": muncul `dihancurkan: tanpa-induk`. Objek tak berinduk dimiliki mesin QML dan dibuang GC.
7. Klik "Kirim sinyal QML ke C++": konsol menampilkan `C++ menerima dari QML: klik dari QML`.
8. Klik "Tambah" tiga kali: pada klik ketiga muncul `selesai pada hitungan 3`.
9. Saat start, `QML membalas: Halo dari C++` dicetak oleh `main.cpp`.

**Percobaan yang disarankan (sengaja merusak)**
1. Hapus `NOTIFY` dari properti `hitungan` dan amati label berhenti memperbarui, plus peringatan binding.
2. Ganti `getUTCDate()` dengan `getDate()` dan jalankan dengan `TZ` lain.
3. Beri `buat(false)` induk dengan `QQmlEngine::setObjectOwnership(o, QQmlEngine::CppOwnership)` dan amati bahwa objek tak dihapus GC.
4. Ubah `Q_ARG(QString, ...)` menjadi tipe yang salah di `invokeMethod` dan lihat kegagalannya (nilai kembali `false`).
5. Ganti `onSelesai` dengan bentuk lama (penyuntikan implisit) dan jalankan `qmllint`.

**Latihan tambahan**
1. Tambahkan `Q_PROPERTY(QDateTime ...)` yang dapat ditulis, dan kirim `new Date()` dari QML. Periksa nilainya di C++.
2. Buat tipe `Q_GADGET` bernama `titik` dan ubah propertinya dari QML. Amati bahwa seluruh gadget dikirim ulang.
3. Kirim `enum class` melalui signal dan sambungkan lewat `backend.sinyal.connect(...)` di JS. Daftarkan tipenya bila perlu.
4. Pindahkan `Backend` menjadi initial property dengan `setInitialProperties` dan `required property`.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Binding** | Ekspresi QML yang dievaluasi ulang saat dependensinya berubah |
| **`NOTIFY`** | Signal yang menandai perubahan properti, dasar binding |
| **Handler `onXxx`** | Penanggap signal yang dibuat otomatis oleh mesin |
| **`Connections`** | Objek QML yang mendengarkan signal target |
| **`required property`** | Properti yang wajib diisi dari luar |
| **Initial property** | Properti yang diberikan C++ saat membuat komponen |
| **Array-like** | Objek mirip array hasil konversi wadah C++ (bukan `Array.isArray`) |
| **`QVariant`** | Wadah nilai generik Qt |
| **`QJSValue` / `QJSManagedValue`** | Wadah nilai JS / pembungkus untuk berinteraksi dengannya |
| **`Q_GADGET`** | Tipe nilai berbasis meta-objek, dikirim sebagai salinan |
| **`QQmlComponent`** | Pemuat dokumen QML dari C++ |
| **`QQmlProperty`** | Akses properti QML dari C++ yang sadar binding |
| **Kepemilikan (*ownership*)** | Pihak yang bertanggung jawab menghapus objek |
| **`CppOwnership` / `JavaScriptOwnership`** | Penanda pemilik objek di mesin QML |
| **Antarmuka C++ berpusat QML** | C++ mengekspos objek, QML yang menggunakannya |

## Hubungan dengan modul lain

- **Prasyarat:** 10.2 (properti, signal, `Q_INVOKABLE`, kepemilikan), 10.3 (registrasi tipe, singleton, `required property`), 9.x (komponen QML), 4.x–5.x (binding dan sinyal QML).
- **Menjadi dasar untuk:** 10.5 (model C++ adalah objek yang dikirim ke QML, dan perubahan model memakai sinyal), 10.6 (layanan sistem dibungkus dalam objek yang diekspos lewat antarmuka sempit), 10.7 (hasil kerja thread dikirim lewat sinyal, callback harus dipanggil di thread engine).
- **Menyambung ke:** 9.4 (`qsTr` di QML dan `tr()` di C++), 8.4 (`qmllint` memanfaatkan tipe terdaftar dan bentuk handler eksplisit).

## Tips dan praktik terbaik

1. **QML yang memakai C++,** bukan sebaliknya. Ekspos antarmuka kecil lewat singleton atau initial property.
2. **Properti yang bisa ditulis selalu punya `NOTIFY`** yang dipancarkan hanya saat nilai berubah.
3. **Pakai bentuk handler eksplisit** (`(x) =>` atau `function onX(x)`).
4. **Pakai `QDateTime`, bukan `QDate`,** untuk tanggal yang melintas batas; baca `getUTC*` bila perlu.
5. **Jangan kirim struktur besar bolak-balik.** Gunakan model (10.5) atau sinyal perubahan.
6. **Tentukan pemilik tiap objek yang menyeberang.** Beri induk, atau `CppOwnership`.
7. **Ekspos perintah sempit dan validasi semua parameter dari QML.**
8. **Perintah lama berarti asinkron + signal hasil,** bukan method yang memblokir.
9. **Akses C++→QML hanya untuk pengujian/prototipe,** dan simpan di bagian terpisah dari kode produksi.
10. **Jalankan `qmllint`** untuk menangkap kesalahan akses yang tak diketahui.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Properti tulis tanpa `NOTIFY` | Binding tak diperbarui, peringatan | Tambah `NOTIFY` |
| `findChild` pada pohon QML | Rapuh saat QML berubah | Antarmuka via singleton/initial property/model |
| `Array.isArray` pada daftar C++ | `false` | Pakai metode array (array-like) |
| `QDate` bergeser sehari | Tanggal salah di zona barat | `getUTC*` atau `QDateTime` |
| Bulan off-by-one | Bulan keliru | JS 0–11, Qt 1–12 |
| Parameter signal `undefined` | Tak bisa dipakai | Daftarkan tipenya |
| Enum tak terlihat | `undefined` | `Q_ENUM` + kelas terdaftar + nama kapital |
| Mengembalikan `new QObject` tanpa induk lalu menyimpannya | *Use-after-free* | Induk atau `CppOwnership`, atau `QPointer` |
| `setProperty` dikira menghapus binding | Binding masih aktif | `QQmlProperty::write` |
| Mengubah anggota data langsung | Tak ada notifikasi | Setter/`setProperty` |
| `create()` tanpa `delete` | Kebocoran | Hapus atau beri induk |
| `Q_INVOKABLE` serbaguna tanpa validasi | Titik masuk serangan | Perintah sempit + validasi |
| Struktur besar bolak-balik tiap frame | UI lambat | Model C++, perubahan bertahap |

## Cek pemahaman: jawaban

**Mengapa C++ sebaiknya tidak memanggil `findChild` di pohon QML?**
- **Merusak pemisahan.** QML dibuat untuk tampilan dan C++ untuk logika. `findChild` membuat logika C++ bergantung pada nama dan struktur pohon QML, sehingga mengubah tata letak QML bisa memutus C++ tanpa peringatan kompilator. Refactoring QML mudah memutus interaksi QML/C++ pada cara itu.
- **Sulit dipahami dan diperiksa.** Interaksi yang digerakkan QML lebih mudah dipikirkan oleh manusia dan alat seperti `qmllint`. Bila C++ mengubah komponen QML dari luar, QML-nya tak bisa dipahami tanpa memeriksa seluruh C++.
- **Beban perawatan.** Cakupan akses itu bisa berubah seiring waktu, sehingga menjadi beban yang terus tumbuh. Ada juga jebakan teknis: banyak objek bisa berbagi satu `objectName` (delegate `ListView`), dan objek itu bisa dibuat dan dihancurkan kapan saja.
- **Alternatif yang benar:** C++ mengekspos antarmuka sempit (singleton atau initial property bertipe terdaftar, atau model C++), dan QML yang memakainya. Dokumentasi hanya menyisakan akses langsung untuk pengujian dan prototipe.

## Referensi

*Halaman Data Type Conversion, Exposing Attributes of C++ Types, Exposing State from C++, Interacting with QML Objects from C++, dan Integrating with JavaScript values saya baca langsung dari dokumentasi Qt 6.12. Tautan lain mengikuti pola URL resmi.*

- **Dari kurikulum:** [Data Type Conversion](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html) · [Exposing Attributes of C++ Classes](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppattributes.html)
- **Pendamping:** [Exposing State from C++ to QML](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppstate.html) · [Interacting with QML Objects from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-interactqmlfromcpp.html) · [Integrating with JavaScript values from C++](https://doc.qt.io/qt-6/qtqml-integrating-with-js-values-from-cpp.html) · [Overview: QML and C++ Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html)
- **QML:** [Connections](https://doc.qt.io/qt-6/qml-qtqml-connections.html) · [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Required Properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html#required-properties) · [QML Sequence Types](https://doc.qt.io/qt-6/qtqml-typesystem-sequencetypes.html) · [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)
- **C++:** [QQmlComponent](https://doc.qt.io/qt-6/qqmlcomponent.html) · [QQmlProperty](https://doc.qt.io/qt-6/qqmlproperty.html) · [QQmlEngine](https://doc.qt.io/qt-6/qqmlengine.html) · [QQmlListProperty](https://doc.qt.io/qt-6/qqmllistproperty.html) · [QJSValue](https://doc.qt.io/qt-6/qjsvalue.html) · [QJSManagedValue](https://doc.qt.io/qt-6/qjsmanagedvalue.html) · [QMetaObject::invokeMethod](https://doc.qt.io/qt-6/qmetaobject.html#invokeMethod)
- **Tutorial:** [Writing QML Extensions with C++](https://doc.qt.io/qt-6/qtqml-tutorials-extending-qml-example.html)
- **Arch:** [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

**Modul 10.4 selesai.**

---

# Audit Singkat Modul 10.5

**Terverifikasi benar**
- Kerangka dasar tepat. Saat membuat subkelas `QAbstractListModel`, Anda wajib menyediakan `rowCount()` dan `data()`. Bila model dipakai di QML dan butuh role selain bawaan, `roleNames()` harus ditimpa.
- `rowCount` yang mengembalikan 0 untuk *parent* valid adalah praktik list-model yang benar.
- Peringatan "ubah data tanpa `beginInsertRows`/`endInsertRows`" benar. Sinyal privat dari fungsi begin/end memberi komponen terhubung kesempatan bertindak sebelum data hilang. Penanganan seleksi hanya benar bila fungsi-fungsi itu dipanggil, dan view bisa berakhir di keadaan tak valid jika tidak.
- Peringatan "role tak terdaftar" dan "`QVariant` kosong lalu delegate kosong" tepat. Bila tak ada nilai untuk dikembalikan, kembalikan `QVariant` tak valid.

**Perlu penajaman atau penambahan**
1. **Pemeriksaan indeks.** Kurikulum memakai `!index.isValid() || index.row() >= size`. Dokumentasi menyediakan `checkIndex()` sebagai alat bantu debug yang mengembalikan boolean dan bisa dipakai dalam `Q_ASSERT`, dengan opsi `IndexIsValid` dan `ParentIsInvalid` yang cocok untuk model datar. Indeks ilegal adalah perilaku tak terdefinisi, jadi jangan mengandalkan pemrograman defensif.
2. **`dataChanged` bisa dipersempit.** Argumen `roles` menyatakan role mana yang berubah. Daftar kosong berarti semua role dianggap berubah. Kurikulum 10.5.4 hanya menyebutnya sekilas.
3. **Edit dari QML.** `setData()` perlu `flags()` yang mengembalikan `ItemIsEditable`, dan `dataChanged()` harus dipancarkan secara eksplisit. Berbeda dengan view C++, `setData()` baru terpanggil dari QML bila delegate menetapkan nilai baru ke properti model yang bersangkutan.
4. **Memindah dan mereset belum ada.** `beginMoveRows()` mengembalikan `false` bila pemindahan tak sah (mis. tujuan di dalam rentang sumber), dan Anda harus membatalkan pemindahan. `beginResetModel()`/`endResetModel()` dipakai bila data berubah drastis, tetapi item aktif dan seleksi menjadi tak valid.
5. **Pembaruan bertahap (10.5.6).** Model yang mengisi data bertahap menimpa `canFetchMore()` dan `fetchMore()`, dan bila `fetchMore()` menambah baris, `beginInsertRows()`/`endInsertRows()` wajib dipanggil.
6. **Keamanan thread.** `QAbstractItemModel` tidak thread-safe. API model hanya boleh dipanggil dari thread tempat model hidup. Thread latar boleh mengisi data, tetapi hasilnya harus diantrikan dan diterapkan di thread utama lewat koneksi queued. Ini tersambung langsung ke 10.7.
7. **Alternatif tanpa subkelas (belum ada).**
   - Model dapat berupa `QStringList`, `QVariantList`, daftar `QObject*`, atau `QAbstractItemModel`. Tiga yang pertama cocok untuk data sederhana.
   - Tak ada cara bagi view untuk mengetahui isi `QList` berubah; Anda harus mereset model dengan menetapkan ulang properti `model`.
   - `QRangeModel` (sejak Qt 6.10) menerapkan `QAbstractItemModel` untuk range C++ apa pun, sebagai list, tabel, atau pohon.
8. **Proxy.** C++ `QSortFilterProxyModel` sudah ada di kurikulum. QML `SortFilterProxyModel` (`import QtQml.Models`, sejak 6.10) berstatus *Preliminary* dan dinyatakan tech preview yang bisa berubah atau dihapus. Sumber modelnya baru mendukung `QAbstractItemModel`. Cocok untuk kasus sederhana, tetapi jangan dijadikan fondasi produksi sebelum stabil.
9. **Pengujian.** Kurikulum belum menyebut `QAbstractItemModelTester`. Saya tambahkan (10.5.8), dan saya tandai bahwa nama kelas itu berasal dari pengetahuan umum Qt, bukan halaman yang saya baca di sini.
10. **Edit nilai kembalian `Q_INVOKABLE`.** Parameter dari QML tak tepercaya. Batasi rentangnya (contoh: jumlah isian di lab).

## Daftar isi Modul 10.5 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 10.5.1 | Kerangka `QAbstractListModel` (+ `QModelIndex`, `checkIndex`, registrasi `QML_ELEMENT`) |
| 10.5.2 | `roleNames` dan `data` (+ role bawaan, `QVariant` tak valid) |
| 10.5.3 | Menambah, menghapus, memindah, dan mereset baris dengan benar |
| 10.5.4 | `setData`, `flags`, dan `dataChanged` (+ edit dari QML) |
| 10.5.5 | Sortir dan filter dengan proxy model (C++ dan QML `SortFilterProxyModel`) |
| 10.5.6 | Model besar dan pembaruan bertahap (batch, `fetchMore`, thread, `ListView`) |
| 10.5.7 | Alternatif tanpa subkelas: `QStringList`/`QObjectList`/`QRangeModel` `[TAMBAHAN]` |
| 10.5.8 | Menguji model: `QAbstractItemModelTester`, `QSignalSpy` `[TAMBAHAN]` |
| 10.5.9 | Lab terpadu: `PerangkatModel` + proxy + `ListView` `[TAMBAHAN]` |

---

# Modul 10.5 — Model C++ dengan `QAbstractListModel`

## Deskripsi dan peran dalam kurikulum

Backend Anda sering mengelola **kumpulan data**: perangkat, pesan, proses, berkas. `ListView`, `TableView`, dan `Repeater` di QML membutuhkan *model*. Modul ini membuat model berkinerja tinggi di C++ yang:
- memegang datanya sendiri,
- memberi tahu view tepat saat dan seperlunya ada yang berubah,
- dan dapat diurut, disaring, serta diedit dari QML.

Modul ini menyambung 7.2 (delegate dan `required property`) dengan 10.2–10.4 (properti, sinyal, tipe terdaftar).

## Konsep kunci dan filosofi

**Analogi.** Model C++ adalah pustakawan yang memegang katalog. View menanyakan "berapa baris?" dan "apa isi baris ke-n untuk role ini?", dan pustakawan wajib mengabari bila ada buku masuk atau keluar. Bila pustakawan diam-diam menukar buku tanpa memberi kabar, pengunjung (view) masih memegang daftar lama dan tersesat.

**Kontrak model (tiga janji)**

```
  VIEW (ListView)                     MODEL (QAbstractListModel)
  "berapa baris?"    ------------>    rowCount()
  "isi baris n, role r?" -------->    data(index, role)
  <-- "baris disisipkan/dihapus/diubah" -- begin*/end*/dataChanged
  (view tidak pernah mengintip m_data langsung)
```

**Dua sumbu perubahan**
- **Struktur** (jumlah dan urutan baris): `begin/endInsertRows`, `begin/endRemoveRows`, `begin/endMoveRows`, `begin/endResetModel`, `layoutChanged`.
- **Isi** (nilai di baris yang ada): `dataChanged`.

**Pondasi sintaks**
- `QModelIndex`: alamat sebuah sel (baris, kolom, induk). Untuk model daftar, kolom selalu 0 dan induk tak valid.
- **Role**: bilangan bulat yang menandai "sisi data" sebuah baris (nama, aktif). Role kustom dimulai dari `Qt::UserRole + 1`.
- `override`: kata kunci C++ yang menegaskan bahwa fungsi menimpa fungsi virtual dari kelas induk. Kompilator akan menolak bila tanda tangannya salah.

## 10.5.1 Kerangka `QAbstractListModel`

> *Fondasi yang rapi membuat sepuluh ribu baris tak terasa.*

**Konsep.** `QAbstractListModel` menyediakan antarmuka standar untuk model yang menyajikan datanya sebagai urutan item datar tanpa hierarki. Ia tak dipakai langsung, dan harus diwariskan. Ia tidak cocok untuk tree view; untuk itu wariskan `QAbstractItemModel`. Bila perlu banyak kolom, pertimbangkan `QAbstractTableModel`.

```cpp
// perangkatmodel.h  (rangka; isi lengkap ada di lab 10.5.9)
#pragma once
#include <QAbstractListModel>
#include <QList>
#include <QString>
#include <QtQml/qqmlregistration.h>

class PerangkatModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    enum Role { KodeRole = Qt::UserRole + 1, NamaRole, AktifRole };
    Q_ENUM(Role)

    explicit PerangkatModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const { return rowCount(); }

signals:
    void countChanged();

private:
    struct Item { int kode; QString nama; bool aktif; };
    QList<Item> m_data;
    int m_kodeBerikut = 1;
};
```

**Bedah kode**
- `QML_ELEMENT` mendaftarkan model sebagai tipe QML (10.3), sehingga bisa ditulis `PerangkatModel { id: sumber }`. Alternatifnya, mengirim model ke view lewat properti `required model`.
- `enum Role { ... = Qt::UserRole + 1 }` mendefinisikan role kustom. Penomoran dimulai dari `Qt::UserRole` ke atas agar tak bentrok dengan role bawaan Qt.
- `Q_ENUM(Role)` membuat nama role terlihat di meta-object (berguna untuk uji dan alat bantu).
- `rowCount(...) const override`: jumlah baris. Tanda `const` wajib karena view memanggilnya lewat referensi konstan.
- `data(...) const override`: nilai satu role untuk satu baris.
- `roleNames() const override`: peta role ke nama untuk QML.
- `Q_PROPERTY(int count ...)`: `ListView.count` ada di QML, tetapi memberi model sebuah `count` sendiri memudahkan label dan tombol yang bergantung pada jumlah.
- `struct Item`: tipe data internal. Tak perlu terlihat di QML.

**`QModelIndex` dalam model daftar**
- `index.row()` adalah posisi baris. `index.column()` selalu 0.
- Sebuah indeks hanya sah bila modelnya adalah model ini, barisnya ≥ 0 dan < jumlah baris induknya, dan demikian pula kolomnya.
- Untuk daftar, kolom tunggal, dan `columnCount()` bawaan sudah menyatakannya.

**Opsi lain**
- **`QAbstractTableModel`** bila datanya bertabel (banyak kolom) untuk `TableView`.
- **`QAbstractItemModel`** bila datanya berhierarki (pohon).
- **`QRangeModel`** (10.5.7) bila cukup membungkus kontainer C++.

**Jebakan dan solusi**

| Jebakan | Solusi |
| --- | --- |
| Lupa `override` dan salah tanda tangan | Pakai `override` agar kompilator memeriksa |
| `rowCount` tak mengembalikan 0 untuk *parent* valid | `parent.isValid() ? 0 : size` |
| Role bernomor di bawah `Qt::UserRole` | Mulai `Qt::UserRole + 1` |
| Model tak terdaftar ke QML | `QML_ELEMENT` + header di `SOURCES` (10.3) |

## 10.5.2 `roleNames` dan `data`

> *Nama yang jelas membuat delegate terbaca sendiri.*

**Konsep.** QML memakai role sebagai **nama properti** di delegate. `roleNames()` menerjemahkan nomor role ke nama itu. Role subkelas `QAbstractItemModel` diekspos ke QML dengan menimpa `roleNames()`.

```cpp
QHash<int, QByteArray> PerangkatModel::roleNames() const
{
    auto roles = QAbstractListModel::roleNames();    // pertahankan "display", "edit", dst.
    roles[KodeRole]  = "kode";
    roles[NamaRole]  = "nama";
    roles[AktifRole] = "aktif";
    return roles;
}

QVariant PerangkatModel::data(const QModelIndex &index, int role) const
{
    if (!checkIndex(index, CheckIndexOption::IndexIsValid | CheckIndexOption::ParentIsInvalid))
        return {};

    const Item &it = m_data.at(index.row());
    switch (role) {
    case KodeRole:        return it.kode;
    case NamaRole:        return it.nama;
    case AktifRole:       return it.aktif;
    case Qt::DisplayRole: return it.nama;     // tampilan standar untuk view lain
    }
    return {};                                  // role tak dikenal: QVariant tak valid
}
```

**Bedah kode**
- `QAbstractListModel::roleNames()` memanggil implementasi induk untuk mempertahankan role bawaan (`display`, `decoration`, `edit`, dan seterusnya). Lalu kita tambahkan role kustom.
- Nama role adalah `QByteArray` (`"nama"`). Nama itulah yang menjadi properti di delegate.
- `checkIndex(...)` memverifikasi indeks sah. Bila tidak, `data()` mengembalikan `{}` (`QVariant` tak valid). Bila gagal, peringatan dicetak di kategori log `qt.core.qabstractitemmodel.checkindex`.
- `const Item &it = m_data.at(...)` mengambil data tanpa menyalin (10.1.3).
- `switch (role)` memilih role. `return it.kode;` mengonversi `int` ke `QVariant` secara implisit.
- Mengembalikan `{}` di akhir berarti "model tak punya nilai untuk role itu".

**Memakainya di QML**

```qml
ListView {
    model: sumber
    delegate: ItemDelegate {
        required property string nama
        required property bool aktif
        required property int kode
        text: nama + (aktif ? '' : ' (nonaktif)')
    }
}
```

Properti `required` di delegate dipakai untuk menetapkan nilai model langsung di komponen QML. Nama properti harus sama persis dengan nama role.

**Opsi lain**
- **`modelData`** hanya untuk model sederhana (`QStringList`, `QObject*`). `QStringList` menyajikan isinya lewat role `modelData`.
- **Satu role "peta"** (`QVariantMap`) untuk banyak atribut: praktis, tetapi lebih lambat dan tak diperiksa tipe. Hindari untuk model besar.
- **`multiData`** (Qt 6.0): mengambil beberapa role sekaligus agar lebih efisien, opsional.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Role tak terdaftar di `roleNames` | Properti `undefined` di delegate | Daftarkan semua role |
| `data()` melakukan pekerjaan berat | Scroll patah-patah | Hitung sebelumnya, simpan di item |
| Mengembalikan `QVariant` kosong untuk role valid | Delegate kosong | Kembalikan nilainya, `{}` hanya untuk role tak dikenal |
| Nama role bentrok dengan kata terpakai (`id`) | Perilaku tak terduga | Pakai nama lain (`kode`) |
| Tanpa `checkIndex` | Perilaku tak terdefinisi bila indeks ilegal | Pakai `checkIndex` |

## 10.5.3 Menambah, menghapus, memindah, dan mereset baris

> *Setiap perubahan struktur adalah janji kepada view. Tepati janjinya.*

**Aturan emas.** `beginInsertRows()` harus dipanggil sebelum data disisipkan ke struktur data, dan `endInsertRows()` segera sesudahnya. Hal yang sama berlaku untuk `beginRemoveRows()`/`endRemoveRows()`.

```
 view tahu : [A, B, C]            model.m_data : [A, B, C]
 beginInsertRows(0..., 3, 3)  --> view bersiap (rowsAboutToBeInserted)
 m_data.append(D)                 model.m_data : [A, B, C, D]
 endInsertRows()              --> view membuat delegate baru (rowsInserted)
 view tahu : [A, B, C, D]
```

**Tambah satu**

```cpp
void PerangkatModel::tambah(const QString &nama)
{
    const int n = rowCount();
    beginInsertRows({}, n, n);                          // parent tak valid, baris n..n
    m_data.append({ m_kodeBerikut++, nama, true });
    endInsertRows();
    emit countChanged();
}
```

`first` dan `last` adalah nomor baris yang akan dimiliki baris baru setelah disisipkan. Menyisipkan tiga baris sebelum baris 2 berarti `beginInsertRows(parent, 2, 4)`. Menambahkan dua baris pada koleksi berisi empat baris berarti `beginInsertRows(parent, 4, 5)`.

**Tambah banyak sekaligus (satu pemberitahuan)**

```cpp
void PerangkatModel::isiBanyak(int jumlah)
{
    jumlah = qBound(0, jumlah, 100'000);                // parameter dari QML: batasi
    if (jumlah == 0) return;

    const int awal = rowCount();
    beginInsertRows({}, awal, awal + jumlah - 1);       // SATU pemberitahuan untuk semuanya
    for (int i = 0; i < jumlah; ++i) {
        const int kode = m_kodeBerikut++;
        m_data.append({ kode, QStringLiteral("Perangkat %1").arg(kode), i % 2 == 0 });
    }
    endInsertRows();
    emit countChanged();
}
```

Memanggil begin/end sekali untuk banyak baris jauh lebih murah daripada sekali per baris, karena view hanya memperbarui sekali.

**Hapus**

```cpp
void PerangkatModel::hapus(int baris)
{
    if (baris < 0 || baris >= rowCount()) return;
    beginRemoveRows({}, baris, baris);
    m_data.removeAt(baris);
    endRemoveRows();
    emit countChanged();
}

void PerangkatModel::hapusKode(int kode)                 // aman terhadap proxy/urutan
{
    for (int i = 0; i < rowCount(); ++i)
        if (m_data.at(i).kode == kode) { hapus(i); return; }
}
```

`beginRemoveRows()` dipanggil sebelum baris dibuang dari struktur data, dan `endRemoveRows()` segera sesudahnya. `hapusKode` memakai **kode stabil**, bukan indeks. Alasannya dibahas di 10.5.5: bila di antara view dan model ada proxy, indeks di delegate bukan indeks di model sumber.

**Pindah**

```cpp
void PerangkatModel::pindah(int dari, int ke)
{
    if (dari == ke || dari < 0 || ke < 0 || dari >= rowCount() || ke >= rowCount())
        return;
    const int tujuan = ke > dari ? ke + 1 : ke;         // aturan semantik beginMoveRows
    if (!beginMoveRows({}, dari, dari, {}, tujuan)) return;
    m_data.move(dari, ke);
    endMoveRows();
}
```

**Aturan pindah** (bila memindahkan baris ke bawah dalam induk yang sama, baris ditempatkan *sebelum* indeks tujuan; untuk memindahkan baris 0 dan 1 menjadi 1 dan 2, `destinationChild` harus 3. `beginMoveRows()` mengembalikan `false` bila tujuan berada dalam rentang sumber (atau sumber + 1), sehingga Anda harus membatalkan pemindahan.) Karena itu `tujuan = ke + 1` saat menggeser ke bawah.

**Reset (palu terakhir)**

```cpp
void PerangkatModel::bersihkan()
{
    beginResetModel();
    m_data.clear();
    endResetModel();
    emit countChanged();
}
```

Reset berarti semua data lama yang pernah dilaporkan model menjadi tak valid dan harus ditanyakan ulang; item aktif dan seleksi menjadi tak valid. Pakai bila data berubah drastis, bukan untuk perubahan satu-dua baris.

**Pilih operasi yang tepat**

| Perubahan | Panggilan |
| --- | --- |
| 1+ baris ditambah | `beginInsertRows` / `endInsertRows` (sekali untuk seluruh rentang) |
| 1+ baris dihapus | `beginRemoveRows` / `endRemoveRows` |
| Baris dipindah | `beginMoveRows` / `endMoveRows` |
| Nilai di baris yang ada | `dataChanged` (10.5.4) |
| Data diganti total | `beginResetModel` / `endResetModel` |
| Urutan berubah (sort) | `layoutAboutToBeChanged` + perbarui indeks persisten + `layoutChanged` |

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Mengubah `m_data` tanpa `begin/end` | View tak sinkron, seleksi salah, bisa *crash* | Selalu bungkus dengan `begin/end` |
| `begin` dipanggil setelah mengubah data | View melihat data setengah jadi | `begin` sebelum, `end` segera sesudah |
| Rentang `first/last` keliru | Delegate duplikat atau hilang | `first` = baris baru pertama, `last` = terakhir |
| Satu `begin/end` per baris di loop | Lambat | Satu pasang untuk seluruh rentang |
| Mengabaikan hasil `beginMoveRows` | Kerusakan indeks persisten | Batalkan bila `false` |
| Indeks baris dipakai setelah model berubah | Menghapus baris yang salah | Pakai kode stabil |
| Menyentuh model dari thread lain | *Race* dan *crash* | Antrikan ke thread utama (10.5.6) |

## 10.5.4 `setData`, `flags`, dan `dataChanged`

> *Data yang bisa diubah harus jujur memberi kabar bahwa ia berubah.*

**Konsep.** Untuk model yang bisa diedit: Anda harus menyediakan `setData()` dan mengimplementasikan `flags()` agar mengembalikan nilai yang memuat `Qt::ItemIsEditable`. Sinyal `dataChanged()` harus dipancarkan secara eksplisit saat menimpa `setData()`.

```cpp
bool PerangkatModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!checkIndex(index, CheckIndexOption::IndexIsValid | CheckIndexOption::ParentIsInvalid))
        return false;

    Item &it = m_data[index.row()];
    switch (role) {
    case NamaRole: {
        const QString n = value.toString().trimmed();
        if (n.isEmpty()) return false;                   // tolak nilai tak sah
        if (n != it.nama) {
            it.nama = n;
            emit dataChanged(index, index, { NamaRole, Qt::DisplayRole });
        }
        return true;
    }
    case AktifRole: {
        const bool a = value.toBool();
        if (a != it.aktif) {
            it.aktif = a;
            emit dataChanged(index, index, { AktifRole });
        }
        return true;
    }
    }
    return false;                                         // role tak bisa diubah
}

Qt::ItemFlags PerangkatModel::flags(const QModelIndex &index) const
{
    auto f = QAbstractListModel::flags(index);
    if (index.isValid()) f |= Qt::ItemIsEditable;
    return f;
}
```

**Bedah kode**
- `setData` menerima indeks, nilai baru, dan role. Mengembalikan `true` bila diterima, `false` bila ditolak.
- Validasi di sini: nama dipangkas (`trimmed()`) dan ditolak bila kosong. Selalu validasi input dari UI.
- `if (n != it.nama)`: hanya memancarkan `dataChanged` bila nilai benar-benar berubah, seperti aturan setter di 10.2.
- `emit dataChanged(index, index, { NamaRole, Qt::DisplayRole })`: `index, index` berarti satu sel. Argumen ketiga menyebut role yang berubah. Daftar role kosong berarti semua role dianggap berubah. Menyebut role spesifik menghemat evaluasi ulang di delegate.
- `flags` memanggil versi induk lalu menambah `Qt::ItemIsEditable`.

**Mengedit dari QML**

```qml
delegate: ItemDelegate {
    id: baris
    required property var model
    contentItem: RowLayout {
        Label { text: baris.model.nama; Layout.fillWidth: true }
        Switch {
            checked: baris.model.aktif
            onToggled: baris.model.aktif = checked        // → memanggil setData(AktifRole)
        }
    }
}
```

Penugasan nilai baru ke properti model yang bersangkutan inilah yang memanggil `setData()` dari delegate. Bila `setData` mengembalikan `false`, nilai di model tak berubah.

**Memperbarui dari C++ (di luar `setData`)**

Bila Anda mengubah item dari dalam model (mis. status berubah karena pekerjaan selesai), Anda tetap wajib memancarkan `dataChanged` agar view tahu:

```cpp
void PerangkatModel::setAktifKode(int kode, bool aktif)
{
    const int baris = cariBaris(kode);
    if (baris < 0 || m_data[baris].aktif == aktif) return;
    m_data[baris].aktif = aktif;
    const QModelIndex idx = index(baris);
    emit dataChanged(idx, idx, { AktifRole });
}
```

**Opsi lain**
- `setItemData` / `itemData` untuk beberapa role sekaligus.
- Properti `QObject` per item dengan `NOTIFY` (lihat `QRangeModel::autoConnectPolicy`, 10.5.7), tetapi biaya memori per item besar.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Lupa `emit dataChanged` di `setData` | UI tak berubah | Pancarkan, dengan role yang tepat |
| Lupa `ItemIsEditable` di `flags` | Editor tak aktif di view C++ | Tambahkan flag |
| Memancarkan `dataChanged` tanpa perubahan | Pembaruan berlebih | `if (berubah)` |
| `setData` menerima input tanpa validasi | Data rusak | Validasi dan tolak (`return false`) |
| `dataChanged` dengan indeks dari model sumber ke proxy | Indeks keliru | Pancarkan dari model yang mengubahnya |

## 10.5.5 Sortir dan filter dengan proxy model

> *Satu sumber kebenaran, banyak sudut pandang.*

**Konsep.** Jangan mengurutkan atau menyaring `m_data` untuk satu tampilan. Biarkan model sumber tetap apa adanya, dan tempatkan **proxy** di antara model dan view. Proxy menerjemahkan indeks sumber ke indeks proxy.

```
 PerangkatModel  --->  QSortFilterProxyModel  --->  ListView
 (data asli)           (urut + saring)             (menampilkan hasilnya)
```

**C++ `QSortFilterProxyModel`**

```cpp
// perangkatproxy.h
#pragma once
#include "perangkatmodel.h"
#include <QSortFilterProxyModel>
#include <QtQml/qqmlregistration.h>

class PerangkatProxy : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString teks READ teks WRITE setTeks NOTIFY teksChanged FINAL)

public:
    explicit PerangkatProxy(QObject *parent = nullptr) : QSortFilterProxyModel(parent)
    {
        setFilterRole(PerangkatModel::NamaRole);
        setSortRole(PerangkatModel::NamaRole);
        setFilterCaseSensitivity(Qt::CaseInsensitive);
        sort(0);                                        // urut naik berdasarkan sortRole
    }

    QString teks() const { return m_teks; }
    void setTeks(const QString &t)
    {
        if (t == m_teks) return;
        m_teks = t;
        setFilterFixedString(t);                        // teks apa adanya, bukan regex
        emit teksChanged();
    }

signals:
    void teksChanged();

private:
    QString m_teks;
};
```

**Bedah kode**
- `QSortFilterProxyModel` adalah kelas Qt siap pakai. `setSourceModel` (atau properti `sourceModel` dari QML) menyambungkannya ke model sumber.
- `setFilterRole(...)` dan `setSortRole(...)` memilih role yang dipakai untuk menyaring dan mengurutkan.
- `setFilterFixedString(t)` menyaring dengan teks apa adanya. Ini jauh lebih aman daripada `setFilterRegularExpression(t)` untuk masukan pengguna, karena karakter khusus regex tak menyebabkan galat atau pola mahal.
- `sort(0)` menyalakan pengurutan. Bawaan `dynamicSortFilter` aktif, sehingga proxy mengikuti perubahan di model sumber otomatis.

```qml
PerangkatModel { id: sumber }
PerangkatProxy { id: proxy; sourceModel: sumber; teks: cari.text }

ListView { model: proxy; /* ... */ }
```

**Jebakan indeks (sangat penting).** Indeks (`index`) di delegate adalah indeks **proxy**, bukan indeks model sumber. Memanggil `sumber.hapus(index)` dari delegate berarti menghapus baris yang salah begitu urutan atau saringan berubah. Dua solusi:
- **Kode stabil:** gunakan role `kode` dan `hapusKode(kode)` (seperti di atas).
- **Petakan indeks:** `proxy.mapToSource(proxy.index(i, 0)).row()` (di C++), atau bungkus dalam `Q_INVOKABLE` proxy.

**QML `SortFilterProxyModel` `[≥6.10, Preliminary]`**

```qml
import QtQml.Models

SortFilterProxyModel {
    id: sfpm
    model: sumber
    sorters: [ RoleSorter { roleName: 'nama' } ]
    filters: [ FunctionFilter {
        component Data: QtObject { property bool aktif }
        function filter(data: Data): bool { return data.aktif }
    } ]
}
```

Sorter dan filter diatur lewat properti `sorters` dan `filters`; sorter yang tersedia antara lain `RoleSorter`, `StringSorter`, `FunctionSorter`, dan filter `ValueFilter` serta `FunctionFilter`. Proxy ini mengurutkan dan menyaring ulang secara dinamis saat model sumber berubah, dan bisa dimatikan lewat `dynamicSortFilter`. API ini tech preview dan bisa berubah atau dihapus. Untuk produksi, pakai proxy C++.

**Opsi lain**
- **`QSortFilterProxyModel` langsung di `main()`** lalu dikirim sebagai properti awal.
- **Mengurutkan sumber sendiri** (`layoutAboutToBeChanged` + `changePersistentIndex` + `layoutChanged`) bila hanya satu tampilan dan urutan itu bagian dari model. Bila Anda menulis `sort()`, `compareData()` (sejak 6.12) menyediakan perbandingan bernilai tertib lemah yang aman untuk `std::sort`.
- **Beberapa proxy** untuk beberapa tampilan dari satu sumber.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| Memakai `index` delegate untuk menyunting model sumber | Baris yang salah terhapus/berubah | Kode stabil, atau `mapToSource` |
| Filter dari input pengguna lewat regex | Karakter khusus mengubah arti, pola mahal | `setFilterFixedString` |
| `QML SortFilterProxyModel` di produksi | API bisa berubah | Proxy C++ |
| Mengurutkan `m_data` mentah tanpa memberi tahu view | View tak sinkron | `layoutChanged`, atau pakai proxy |
| Proxy tanpa `sourceModel` | Daftar kosong | Tetapkan `sourceModel` |

## 10.5.6 Model besar dan pembaruan bertahap

> *Kinerja adalah janji yang ditepati satu baris pada satu waktu.*

**Prinsip kinerja**
1. **Granularitas pemberitahuan.** Satu `begin/endInsertRows` untuk satu rentang, bukan satu per baris.
2. **Pilih operasi paling sempit.** `dataChanged` untuk satu sel lebih murah daripada reset.
3. **`data()` cepat.** Hanya pencarian dan pengembalian nilai, tanpa komputasi atau I/O.
4. **View yang virtual.** `ListView` hanya membuat delegate untuk yang terlihat (plus penyangga).
5. **Jangan `Q_INVOKABLE get(row)` ke `QVariantMap` per delegate.** Memakai role jauh lebih efisien.

**Tips `ListView`**

```qml
ListView {
    model: proxy
    clip: true
    reuseItems: true          // daur ulang delegate yang keluar layar
    cacheBuffer: 200          // penyangga piksel di luar area terlihat; sesuaikan
    delegate: /* delegate ringan: sedikit item, tanpa Loader berat */
}
```

Delegate yang ringan (sedikit anak, binding sederhana) lebih penting daripada trik apa pun.

**Pemuatan bertahap (`canFetchMore` / `fetchMore`)**

Untuk model yang mengisi data bertahap, timpa `fetchMore()` dan `canFetchMore()`. Bila `fetchMore()` menambah baris, `beginInsertRows()` dan `endInsertRows()` harus dipanggil. Kedua fungsi ini bisa dipanggil lewat sistem meta-objek dan dari QML (invokable).

```cpp
bool canFetchMore(const QModelIndex &parent) const override
{
    return !parent.isValid() && m_dimuat < m_total;
}

void fetchMore(const QModelIndex &parent) override
{
    if (parent.isValid()) return;
    const int n = std::min(100, m_total - m_dimuat);
    if (n <= 0) return;
    beginInsertRows({}, m_dimuat, m_dimuat + n - 1);
    // ... ambil n item berikutnya dari sumber data ...
    m_dimuat += n;
    endInsertRows();
}
```

Agar `rowCount` konsisten, ia harus mengembalikan jumlah yang **sudah dimuat** (`m_dimuat`), bukan total. Untuk QML, sediakan pembungkus sendiri dan panggil dari `ListView`:

```cpp
Q_INVOKABLE void muatLagi() { if (canFetchMore({})) fetchMore({}); }
```

```qml
ListView {
    onAtYEndChanged: if (atYEnd) sumber.muatLagi()      // muat saat mencapai ujung
}
```

**Thread dan data berat**
- API model hanya boleh dipanggil dari thread tempat model hidup. Thread latar boleh mengisi atau mengubah isi model, tetapi tak boleh memanggil API model secara langsung; antrikan pembaruan dan terapkan di thread utama lewat koneksi queued.
- Pola: pekerjaan menghasilkan `QList<Item>` di thread kerja → signal (queued) → slot di model menerapkan satu `beginInsertRows` besar di thread utama. Detailnya di 10.7.

**Reset vs perubahan granular**
- Data baru seluruhnya (pencarian baru): reset (`beginResetModel`) wajar.
- Perubahan kecil berulang (tick tiap detik): `dataChanged` dengan role spesifik.
- Perubahan beruntun besar: kumpulkan jadi satu batch.

**Batas dan keamanan.** Batasi ukuran tiap isian dari QML (`qBound`), dan batasi total baris yang bisa tumbuh dari masukan tak tepercaya, agar UI tak bisa dipaksa menghabiskan memori.

**Opsi lain.** `QRangeModel` (10.5.7) menyederhanakan banyak operasi struktur. Untuk dataset yang sangat besar dan statis, pertimbangkan memuat dari basis data per halaman (`SQL` model) dan hanya menampilkan jendelanya.

**Jebakan dan solusi**

| Jebakan | Akibat | Solusi |
| --- | --- | --- |
| `begin/endInsertRows` per baris di loop | Lambat | Satu pasang untuk rentang |
| `data()` berat | Scroll tersendat | Pre-komputasi |
| Reset untuk perubahan kecil | Seleksi hilang, kedip | `dataChanged`/insert/remove |
| `rowCount()` mengembalikan total, bukan yang dimuat | View meminta baris yang belum ada | Kembalikan jumlah yang dimuat |
| Mengubah model dari thread kerja | *Crash* | Sinyal queued ke thread utama |
| Delegate berat dengan banyak `Loader` | UI lambat | Sederhanakan delegate, `reuseItems` |

## 10.5.7 Alternatif tanpa subkelas `[TAMBAHAN]`

> *Pilih alat terkecil yang cukup untuk pekerjaannya.*

| Pilihan | Cocok untuk | Catatan |
| --- | --- | --- |
| `ListModel` (QML) | Data statis kecil, prototipe | Murni QML |
| `QStringList` / `QVariantList` | Daftar sederhana | Akses lewat `modelData` |
| `QList<QObject*>` | Daftar objek dengan properti | Properti jadi role; view tak tahu `QList` berubah, jadi reset dengan menetapkan ulang `model` |
| **`QRangeModel`** | Membungkus kontainer C++ jadi model | Sejak 6.10; tanpa subkelas |
| `QAbstractListModel` subkelas | Kontrol penuh, notifikasi presisi, validasi | Paling banyak kode |

**`QRangeModel` `[≥6.10]`**

`QRangeModel` mengubah data pada tipe C++ yang dapat diiterasi berurutan menjadi tersedia bagi kerangka model/view Qt. Barisnya ditafsirkan sebagai list, tabel, atau pohon tergantung tipe elemen. Rancangan yang relevan untuk model daftar bergaya Anda:

```cpp
class Perangkat
{
    Q_GADGET
    Q_PROPERTY(QString nama MEMBER nama)
    Q_PROPERTY(bool aktif MEMBER aktif)
public:
    QString nama;
    bool aktif = true;
};

template <>
struct QRangeModel::RowOptions<Perangkat>
{
    static constexpr auto rowCategory = QRangeModel::RowCategory::MultiRoleItem;   // 1 baris = 1 item multi-role
};

QList<Perangkat> data = { ... };
QRangeModel model(&data);                        // pointer: perubahan lewat model mengubah 'data'
```

**Hal penting tentang `QRangeModel`**
- Rentang diberikan lewat nilai (disalin), pointer, atau `std::ref`. Cara pembuatan menentukan apakah perubahan lewat API model mengubah data asli.
- Setelah model dibuat dan diberikan ke view, rentang aslinya tak boleh diubah langsung; view tak diberi tahu, dan perubahan struktur bisa merusak indeks persisten. `QRangeModelAdapter` disarankan untuk interaksi yang aman.
- Pemanggil harus menjamin umur rentang lebih panjang dari umur model.
- Bila baris berupa gadget atau `QObject`, `roleNames` otomatis berisi nama properti (dari `Qt::UserRole` ke atas) plus role `modelData` untuk instansnya. Dalam daftar, tipe ini bawaan menjadi baris multi-kolom, dan `MultiRoleItem` memaksanya jadi item multi-role.
- Mengakses properti lewat sistem properti membawa overhead runtime; untuk model kritis kinerja, protokol tuple memberi kode akses saat kompilasi.
- Item `QObject` punya overhead memori signifikan.
- `autoConnectPolicy` (sejak 6.11) bisa menyambungkan sinyal perubahan properti `QObject` ke `dataChanged` otomatis, dengan biaya memori yang bisa besar.

**Kapan memilih yang mana?**
- Prototipe atau data kecil statis: `ListModel`, `QStringList`.
- Data nyata di C++ dengan struktur sederhana: `QRangeModel`.
- Notifikasi presisi, validasi, perilaku khusus, atau data yang berasal dari sumber luar: subkelas `QAbstractListModel` seperti modul ini.

## 10.5.8 Menguji model: `QAbstractItemModelTester`, `QSignalSpy` `[TAMBAHAN]`

> *Model yang tak diuji adalah bug yang menunggu seleksi pertama.*

**Konsep.** Kesalahan model sering muncul jauh dari penyebabnya (delegate tampak aneh, seleksi melompat). `QAbstractItemModelTester` (dari QtTest) memeriksa kontrak model setiap kali model berubah. (Saya tandai: nama dan API ini berasal dari pengetahuan umum Qt, bukan halaman yang saya baca di sesi ini. Periksa dokumentasi `QAbstractItemModelTester`.) `QSignalSpy` memverifikasi bahwa sinyal yang tepat terpancar.

```cpp
// ujimodel.cpp
#include "perangkatmodel.h"
#include <QAbstractItemModelTester>
#include <QSignalSpy>
#include <QTest>

class UjiModel : public QObject
{
    Q_OBJECT
private slots:
    void kontrakModel()
    {
        PerangkatModel m;
        QAbstractItemModelTester tester(&m, QAbstractItemModelTester::FailureReportingMode::QtTest);
        m.tambah(QStringLiteral("A"));
        m.isiBanyak(10);
        m.pindah(0, 5);
        m.hapus(0);
        m.bersihkan();                      // tester ikut memeriksa setiap perubahan
    }

    void isiBanyakSatuNotifikasi()
    {
        PerangkatModel m;
        QSignalSpy spy(&m, SIGNAL(rowsInserted(QModelIndex,int,int)));
        m.isiBanyak(10);
        QCOMPARE(m.rowCount(), 10);
        QCOMPARE(spy.count(), 1);           // satu begin/end untuk sepuluh baris
    }

    void aktifSamaTidakMemancarkan()
    {
        PerangkatModel m;
        m.tambah(QStringLiteral("A"));
        QSignalSpy spy(&m, SIGNAL(dataChanged(QModelIndex,QModelIndex,QList<int>)));
        m.setData(m.index(0), true,  PerangkatModel::AktifRole);   // sudah true
        QCOMPARE(spy.count(), 0);
        m.setData(m.index(0), false, PerangkatModel::AktifRole);
        QCOMPARE(spy.count(), 1);
    }
};

QTEST_MAIN(UjiModel)
#include "ujimodel.moc"
```

```cmake
find_package(Qt6 REQUIRED COMPONENTS Core Qml Test)
qt_add_executable(ujimodel ujimodel.cpp perangkatmodel.cpp perangkatmodel.h)
target_link_libraries(ujimodel PRIVATE Qt6::Core Qt6::Qml Qt6::Test)
enable_testing()
add_test(NAME ujimodel COMMAND ujimodel)
```

```bash
cmake --build build && QT_QPA_PLATFORM=offscreen ctest --test-dir build --output-on-failure
```

**Bedah kode**
- `QAbstractItemModelTester tester(&m, ...)` memantau model `m`, dan melaporkan pelanggaran kontrak (mis. `rowCount` tak cocok dengan notifikasi).
- Mode `QtTest` melaporkan lewat kegagalan uji Qt Test.
- `QSignalSpy(&m, SIGNAL(...))` memakai sintaks string karena sinyal model bersifat privat. `spy.count()` menghitung pemancaran.
- Uji `isiBanyakSatuNotifikasi` menegakkan prinsip kinerja 10.5.6 sebagai kontrak.
- Uji `aktifSamaTidakMemancarkan` menegakkan aturan 10.5.4: tanpa perubahan, tanpa sinyal.
- `QT_QPA_PLATFORM=offscreen` menjalankan tanpa tampilan (CI).

**Jebakan.** Tidak menguji `begin/end` pada operasi kasus tepi (hapus baris terakhir, pindah ke ujung). Hanya menguji lewat UI manual.

## 10.5.9 Lab terpadu `[TAMBAHAN]`

Proyek baru `labmodel`: model `PerangkatModel` (dengan `tambah`, `isiBanyak`, `hapus`, `hapusKode`, `pindah`, `bersihkan`, `setData`), proxy `PerangkatProxy`, dan antarmuka. Latihan kurikulum (`Q_INVOKABLE void hapus(int baris)`) ada di dalamnya.

```cpp
// perangkatmodel.h
#pragma once
#include <QAbstractListModel>
#include <QList>
#include <QString>
#include <QtQml/qqmlregistration.h>

class PerangkatModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    enum Role { KodeRole = Qt::UserRole + 1, NamaRole, AktifRole };
    Q_ENUM(Role)

    explicit PerangkatModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const { return rowCount(); }

    Q_INVOKABLE void tambah(const QString &nama);
    Q_INVOKABLE void isiBanyak(int jumlah);
    Q_INVOKABLE void hapus(int baris);
    Q_INVOKABLE void hapusKode(int kode);
    Q_INVOKABLE void pindah(int dari, int ke);
    Q_INVOKABLE void bersihkan();

signals:
    void countChanged();

private:
    struct Item { int kode; QString nama; bool aktif; };
    int cariBaris(int kode) const;

    QList<Item> m_data;
    int m_kodeBerikut = 1;
};
```

```cpp
// perangkatmodel.cpp
#include "perangkatmodel.h"

PerangkatModel::PerangkatModel(QObject *parent) : QAbstractListModel(parent) {}

int PerangkatModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : static_cast<int>(m_data.size());
}

QVariant PerangkatModel::data(const QModelIndex &index, int role) const
{
    if (!checkIndex(index, CheckIndexOption::IndexIsValid | CheckIndexOption::ParentIsInvalid))
        return {};
    const Item &it = m_data.at(index.row());
    switch (role) {
    case KodeRole:        return it.kode;
    case NamaRole:        return it.nama;
    case AktifRole:       return it.aktif;
    case Qt::DisplayRole: return it.nama;
    }
    return {};
}

bool PerangkatModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!checkIndex(index, CheckIndexOption::IndexIsValid | CheckIndexOption::ParentIsInvalid))
        return false;
    Item &it = m_data[index.row()];
    switch (role) {
    case NamaRole: {
        const QString n = value.toString().trimmed();
        if (n.isEmpty()) return false;
        if (n != it.nama) {
            it.nama = n;
            emit dataChanged(index, index, { NamaRole, Qt::DisplayRole });
        }
        return true;
    }
    case AktifRole: {
        const bool a = value.toBool();
        if (a != it.aktif) {
            it.aktif = a;
            emit dataChanged(index, index, { AktifRole });
        }
        return true;
    }
    }
    return false;
}

Qt::ItemFlags PerangkatModel::flags(const QModelIndex &index) const
{
    auto f = QAbstractListModel::flags(index);
    if (index.isValid()) f |= Qt::ItemIsEditable;
    return f;
}

QHash<int, QByteArray> PerangkatModel::roleNames() const
{
    auto roles = QAbstractListModel::roleNames();
    roles[KodeRole]  = "kode";
    roles[NamaRole]  = "nama";
    roles[AktifRole] = "aktif";
    return roles;
}

int PerangkatModel::cariBaris(int kode) const
{
    for (int i = 0; i < m_data.size(); ++i)
        if (m_data.at(i).kode == kode) return i;
    return -1;
}

void PerangkatModel::tambah(const QString &nama)
{
    const QString n = nama.trimmed();
    if (n.isEmpty()) return;
    const int baris = rowCount();
    beginInsertRows({}, baris, baris);
    m_data.append({ m_kodeBerikut++, n, true });
    endInsertRows();
    emit countChanged();
}

void PerangkatModel::isiBanyak(int jumlah)
{
    jumlah = qBound(0, jumlah, 100'000);
    if (jumlah == 0) return;
    const int awal = rowCount();
    beginInsertRows({}, awal, awal + jumlah - 1);
    for (int i = 0; i < jumlah; ++i) {
        const int kode = m_kodeBerikut++;
        m_data.append({ kode, QStringLiteral("Perangkat %1").arg(kode), i % 2 == 0 });
    }
    endInsertRows();
    emit countChanged();
}

void PerangkatModel::hapus(int baris)
{
    if (baris < 0 || baris >= rowCount()) return;
    beginRemoveRows({}, baris, baris);
    m_data.removeAt(baris);
    endRemoveRows();
    emit countChanged();
}

void PerangkatModel::hapusKode(int kode)
{
    const int baris = cariBaris(kode);
    if (baris >= 0) hapus(baris);
}

void PerangkatModel::pindah(int dari, int ke)
{
    if (dari == ke || dari < 0 || ke < 0 || dari >= rowCount() || ke >= rowCount())
        return;
    const int tujuan = ke > dari ? ke + 1 : ke;
    if (!beginMoveRows({}, dari, dari, {}, tujuan)) return;
    m_data.move(dari, ke);
    endMoveRows();
}

void PerangkatModel::bersihkan()
{
    beginResetModel();
    m_data.clear();
    endResetModel();
    emit countChanged();
}
```

```cpp
// perangkatproxy.h
#pragma once
#include "perangkatmodel.h"
#include <QSortFilterProxyModel>
#include <QtQml/qqmlregistration.h>

class PerangkatProxy : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString teks READ teks WRITE setTeks NOTIFY teksChanged FINAL)

public:
    explicit PerangkatProxy(QObject *parent = nullptr) : QSortFilterProxyModel(parent)
    {
        setFilterRole(PerangkatModel::NamaRole);
        setSortRole(PerangkatModel::NamaRole);
        setFilterCaseSensitivity(Qt::CaseInsensitive);
        sort(0);
    }

    QString teks() const { return m_teks; }
    void setTeks(const QString &t)
    {
        if (t == m_teks) return;
        m_teks = t;
        setFilterFixedString(t);
        emit teksChanged();
    }

signals:
    void teksChanged();

private:
    QString m_teks;
};
```

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.21)
project(labmodel LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(applabmodel main.cpp)

qt_add_qml_module(applabmodel
    URI LabModel
    QML_FILES Main.qml
    SOURCES perangkatmodel.h perangkatmodel.cpp perangkatproxy.h
)

target_link_libraries(applabmodel PRIVATE Qt6::Quick)
```

`main.cpp` sama seperti di 10.3, dengan `engine.loadFromModule("LabModel", "Main");`.

```qml
// Main.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LabModel

ApplicationWindow {
    visible: true; width: 460; height: 560; title: 'Lab 10.5'

    PerangkatModel { id: sumber }
    PerangkatProxy { id: proxy; sourceModel: sumber; teks: cari.text }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        TextField { id: cari; Layout.fillWidth: true; placeholderText: 'Cari nama...' }

        RowLayout {
            TextField {
                id: nama
                Layout.fillWidth: true
                placeholderText: 'Perangkat baru'
                onAccepted: tombolTambah.clicked()
            }
            Button {
                id: tombolTambah
                text: 'Tambah'
                enabled: nama.text.trim().length > 0
                onClicked: { sumber.tambah(nama.text); nama.clear() }
            }
        }

        RowLayout {
            Button { text: 'Isi 1000'; onClicked: sumber.isiBanyak(1000) }
            Button { text: 'Kosongkan'; onClicked: sumber.bersihkan() }
            Label { text: sumber.count + ' item, ' + lihat.count + ' tampil' }
        }

        ListView {
            id: lihat
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            reuseItems: true
            model: proxy
            ScrollBar.vertical: ScrollBar { }

            delegate: ItemDelegate {
                id: baris
                required property var model
                width: ListView.view.width

                contentItem: RowLayout {
                    Label { text: baris.model.nama; Layout.fillWidth: true; elide: Text.ElideRight }
                    Switch {
                        checked: baris.model.aktif
                        onToggled: baris.model.aktif = checked        // → setData(AktifRole)
                    }
                    ToolButton {
                        text: 'Hapus'
                        onClicked: sumber.hapusKode(baris.model.kode)  // kode stabil, bukan index
                    }
                }
            }
        }
    }
}
```

```bash
cmake -S . -B build && cmake --build build && ./build/applabmodel
```

**Yang diamati**
1. Ketik nama lalu Enter: baris muncul terurut alfabet (proxy). Ketik di kolom cari: daftar tersaring.
2. "Isi 1000" lalu gulir: mulus karena `ListView` hanya membuat delegate yang terlihat.
3. Geser `Switch`: nilai `aktif` berubah lewat `setData`. Bila Anda menambah log di `setData`, Anda melihat hanya satu `dataChanged` per perubahan.
4. Saat daftar tersaring, klik "Hapus": baris yang benar terhapus berkat `hapusKode`. Ganti dengan `sumber.hapus(baris.index)` untuk melihat baris yang salah terhapus.
5. "Kosongkan": reset, seluruh daftar bersih.
6. Label jumlah menunjukkan `count` model sumber vs `count` tampilan (hasil saringan).

**Percobaan yang disarankan (sengaja merusak)**
1. Hapus `beginInsertRows`/`endInsertRows` di `tambah` dan perhatikan view tak menampilkan baris baru (atau menampilkan keadaan kacau).
2. Ubah `setFilterFixedString` menjadi `setFilterRegularExpression(t)` lalu ketik `(` di kolom cari. Lihat perilakunya.
3. Hapus `roleNames()` dan lihat properti delegate jadi `undefined`.
4. Panggil `beginInsertRows` per baris di `isiBanyak` dan ukur perbedaan kecepatan dengan 100.000 baris.
5. Jalankan dengan `QT_LOGGING_RULES='qt.core.qabstractitemmodel.checkindex=true'` dan sengaja panggil `data()` dengan indeks ilegal untuk melihat peringatan `checkIndex`.

**Latihan tambahan**
1. Tambahkan `Q_INVOKABLE void setAktifKode(int kode, bool aktif)` yang memancarkan `dataChanged` dengan role `AktifRole`, lalu panggil dari tombol.
2. Tambahkan tombol "Naik" dan "Turun" yang memanggil `pindah`. Perhatikan perilakunya bila proxy mengurutkan nama (urutan proxy menang).
3. Ganti `PerangkatModel` dengan `QRangeModel` untuk daftar `Perangkat` gadget dan bandingkan jumlah kode.
4. Ubah proxy menjadi `SortFilterProxyModel` QML (≥6.10) dan bandingkan.
5. Tulis uji `QAbstractItemModelTester` dari 10.5.8.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Model / view / delegate** | Data / penampil / cetakan tampilan satu item |
| **`QModelIndex`** | Alamat satu sel: baris, kolom, induk |
| **Role** | Sisi data sebuah item (nama, aktif); nomor dari `Qt::UserRole + 1` |
| **`roleNames`** | Peta nomor role ke nama properti untuk QML |
| **`rowCount` / `data`** | Jumlah baris / nilai satu role satu baris |
| **`begin*` / `end*`** | Pemberitahuan perubahan struktur sebelum dan sesudahnya |
| **`dataChanged`** | Pemberitahuan perubahan isi sel |
| **Reset** | Pemberitahuan "semua berubah", membatalkan seleksi |
| **Proxy model** | Lapisan di antara model dan view untuk sortir/filter |
| **`mapToSource`** | Mengubah indeks proxy menjadi indeks model sumber |
| **`canFetchMore` / `fetchMore`** | Mekanisme pemuatan bertahap |
| **`QRangeModel`** | Model siap pakai atas kontainer C++ (≥ 6.10) |
| **Persistent index** | Indeks yang tetap valid saat model berubah |
| **Kode stabil** | Pengenal unik item yang tak berubah saat urutan berubah |

## Hubungan dengan modul lain

- **Prasyarat:** 10.1 (RAII, `const&`, `QList`), 10.2 (properti, sinyal, `Q_INVOKABLE`), 10.3 (`QML_ELEMENT`, `qt_add_qml_module`), 10.4 (memakai objek C++ di QML, parameter tak tepercaya), 7.2 (delegate, `required property`, `ListView`).
- **Menjadi dasar untuk:** 10.6 (daftar proses/berkas/koneksi disajikan sebagai model), 10.7 (pembaruan model dari thread kerja lewat sinyal queued).
- **Menyambung ke:** 9.4 (`Accessible` pada baris daftar, teks terlokalisasi lewat `tr`), 9.1 (`ListView` + `ScrollBar`).

## Tips dan praktik terbaik

1. **Sumber kebenaran tunggal di model.** Jangan menyimpan salinan keadaan baris di delegate.
2. **Setiap perubahan struktur lewat `begin/end`.** Tanpa pengecualian.
3. **Pancarkan `dataChanged` hanya bila berubah,** dengan rentang dan role yang tersempit.
4. **Pakai kode stabil untuk operasi dari UI,** bukan indeks, terutama dengan proxy.
5. **Satu batch, satu pemberitahuan** untuk banyak baris.
6. **`data()` cepat dan murni.** Hitung sebelumnya.
7. **Validasi di `setData` dan `Q_INVOKABLE`.** Parameter dari QML tak tepercaya, batasi rentang dan ukuran.
8. **Saring teks pengguna dengan `setFilterFixedString`,** bukan regex.
9. **Uji model dengan `QAbstractItemModelTester` dan `QSignalSpy`.**
10. **Pilih alat terkecil yang cukup:** `ListModel`, `QRangeModel`, baru subkelas.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Ubah `m_data` tanpa `begin/end` | View tak sinkron, *crash* | Bungkus dengan `begin/end` |
| `roleNames` tak lengkap | Properti `undefined` | Daftarkan semua role |
| `data()` mengembalikan `QVariant` kosong untuk role valid | Delegate kosong | Kembalikan nilainya |
| Lupa `emit dataChanged` | UI tak berubah | Pancarkan dengan role tepat |
| `dataChanged` tanpa perubahan | Evaluasi berlebih | Cek perubahan |
| Memakai `index` delegate pada model sumber lewat proxy | Menyunting baris yang salah | Kode stabil / `mapToSource` |
| Reset untuk perubahan kecil | Seleksi hilang | `insert/remove/dataChanged` |
| `begin/endInsertRows` per baris | Lambat | Satu rentang |
| `rowCount` ≠ jumlah yang dimuat | View meminta baris tak ada | Kembalikan jumlah termuat |
| Menyentuh model dari thread kerja | Race, crash | Antrikan ke thread utama |
| Mengabaikan hasil `beginMoveRows` | Indeks persisten rusak | Batalkan bila `false` |
| Mengubah range `QRangeModel` langsung | View tak diberi tahu | Lewat API model atau `QRangeModelAdapter` |
| Filter regex dari input pengguna | Perilaku tak terduga | `setFilterFixedString` |

## Cek pemahaman: jawaban

**Apa yang rusak bila Anda mengubah `m_data` tanpa memanggil `beginInsertRows`?**
- **View kehilangan sinkronisasi.** Model dan view punya "kesepakatan" tentang jumlah baris. Tanpa `beginInsertRows`/`endInsertRows`, tak ada sinyal `rowsAboutToBeInserted`/`rowsInserted`. `ListView` tak membuat delegate untuk baris baru dan masih menyimpan daftar lama, sehingga baris yang ditambahkan tak muncul.
- **Indeks dan seleksi rusak.** Fungsi begin/end juga memungkinkan model mengelola indeks persisten dengan benar, dan Anda harus memanggilnya bila ingin seleksi ditangani dengan benar. Item aktif dan seleksi bisa menunjuk baris yang salah.
- **Risiko *crash*.** Dokumentasi memperingatkan bahwa view atau proxy bisa berakhir di keadaan tak valid bila tak menangani sinyal sebelum data disisipkan. Bila `rowCount()` kemudian mengembalikan angka yang lebih besar dari yang diketahui view, view akan memanggil `data()` untuk baris yang belum ia siapkan, atau sebaliknya. Ini bisa memicu akses tak sah atau galat.
- **Solusi:** selalu `beginInsertRows(parent, first, last)` sebelum menyisipkan dan `endInsertRows()` segera sesudahnya. Untuk banyak baris, satu pasang begin/end.

## Referensi

*Halaman QAbstractListModel, QAbstractItemModel, QRangeModel, dan SortFilterProxyModel saya baca langsung dari dokumentasi Qt (6.12, kecuali SortFilterProxyModel dari 6.10). Pola tipe QML dari halaman "Using C++ Models with Qt Quick Views" saya verifikasi lewat hasil pencarian. Tautan lain mengikuti pola URL resmi.*

- **Dari kurikulum:** [QAbstractListModel](https://doc.qt.io/qt-6/qabstractlistmodel.html) · [QAbstractItemModel](https://doc.qt.io/qt-6/qabstractitemmodel.html) · [Model/View Programming](https://doc.qt.io/qt-6/model-view-programming.html)
- **Dengan Qt Quick:** [Using C++ Models with Qt Quick Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-cppmodels.html) · [Qt Quick Models and Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html) · [ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html) · [Model Subclassing Reference](https://doc.qt.io/qt-6/model-view-programming.html#model-subclassing-reference)
- **Alternatif:** [QRangeModel](https://doc.qt.io/qt-6/qrangemodel.html) · [QRangeModelAdapter](https://doc.qt.io/qt-6/qrangemodeladapter.html) · [SortFilterProxyModel (QML)](https://doc.qt.io/qt-6/qml-qtqml-models-sortfilterproxymodel.html) · [QSortFilterProxyModel](https://doc.qt.io/qt-6/qsortfilterproxymodel.html) · [QAbstractTableModel](https://doc.qt.io/qt-6/qabstracttablemodel.html)
- **Pengujian:** [QAbstractItemModelTester](https://doc.qt.io/qt-6/qabstractitemmodeltester.html) · [QSignalSpy](https://doc.qt.io/qt-6/qsignalspy.html)
- **Pendukung:** [QModelIndex](https://doc.qt.io/qt-6/qmodelindex.html) · [Qt::ItemDataRole](https://doc.qt.io/qt-6/qt.html#ItemDataRole-enum) · [Thread dan QObject](https://doc.qt.io/qt-6/threads-qobject.html)
- **Arch:** [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

**Modul 10.5 selesai.** Berikutnya, **Modul 10.6 (API Native dan Integrasi Sistem)**

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

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

