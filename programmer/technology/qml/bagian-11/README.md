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

 - **[⬆️ Ke Atas](#)**
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

