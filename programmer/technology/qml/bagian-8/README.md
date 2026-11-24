# Modul 7.1: Model Data

*Fase 7: Model, View, dan Arsitektur Data*

<details>
  <summary>📃 Daftar Isi</summary>

## Daftar isi modul ini

---

1. Audit singkat sebelum materi
2. Peran modul, konsep dan filosofi, terminologi, peta visual
3. **7.1.1** `ListModel` dan seluruh API-nya
4. **7.1.2** Array, angka, dan objek sebagai model
5. **7.1.3** `ObjectModel`
6. **7.1.4** Kapan model harus pindah ke C++
7. **7.1.5** Memfilter dan mengurutkan
8. **7.1.6** (TAMBAHAN) Model lain: `XmlListModel`, `TableModel`, `TreeModel`
9. **7.1.7** (TAMBAHAN) Memantau perubahan model, dengan studi kasus keranjang
10. Hubungan dengan modul lain, kesalahan umum, latihan, cek pemahaman, referensi

</details>

---

## 1. Audit singkat

Saya membaca bagian 7.1 terhadap dokumentasi Qt 6.12 dan prasyarat dari fase sebelumnya.

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Prasyarat: Modul 2.x (array, objek, fungsi), 3.x (properti, binding, sinyal), 5.1 (Component) | Aman, tidak ada loncatan | Tidak ada |
| 2 | "Tipe role ditentukan data pertama" | Benar tetapi kurang | Yang terkunci oleh data pertama adalah **himpunan role dan tipenya**. Role baru yang muncul belakangan tidak ditangani view. Ditambahkan di 7.1.1 |
| 3 | `dynamicRoles`, `sync()`, role berisi list bersarang | Belum ada | Ditambahkan di 7.1.1 |
| 4 | `get()` tidak boleh dipakai di binding | Belum ada | Ditambahkan, menjadi dasar 7.1.7 |
| 5 | Objek tunggal sebagai model, `XmlListModel`, `TableModel`, `TreeModel` | Belum ada | TAMBAHAN di 7.1.2 dan 7.1.6 |
| 6 | 7.1.5 hanya menyebut proxy model dari C++ | Sebagian usang | Sejak Qt 6.10 ada `SortFilterProxyModel` di QML (pratinjau). Ditambahkan beserta peringatan stabilitas |
| 7 | Import tidak disebut | Ambigu | Tipe model ada di modul `QtQml.Models` |
| 8 | Menulis data balik dari delegate (`delegateModelAccess`) | Belum ada | Ditunda ke Modul 7.2 |

**Pembaruan daftar isi kurikulum 7.1:** 7.1.1 sampai 7.1.5 tetap, ditambah **7.1.6** (Model lain) dan **7.1.7** (Memantau perubahan model).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Modul ini menjawab satu pertanyaan: **di mana data hidup, dan bagaimana ia berubah dengan aman?** Tanpa model yang benar, UI dinamis berubah menjadi tumpukan variabel yang saling menyalin dan saling bertentangan.

Modul ini adalah fondasi seluruh Fase 7:

- 7.2 menampilkan model lewat view dan delegate.
- 7.3 membuat objek dinamis, dan `ObjectModel` menjembatani keduanya.
- 7.4 mengisi model dari jaringan.
- 10.5 membangun model di C++.
- 13.1 memagari data tak tepercaya yang masuk ke model.

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Bayangkan gudang berlabel. Setiap rak adalah satu baris data. Setiap rak punya kotak bernama (`nama`, `harga`), dan itulah **role**. Etalase toko (view) hanya menampilkan isi rak yang terlihat pelanggan. Etalase tidak perlu tahu cara gudang diisi. Kalau petugas gudang mengganti isi rak, ia menekan bel, dan etalase memperbarui dirinya. Bel itu adalah **sinyal**.

Prinsip yang mendasarinya:

1. **Pemisahan tanggung jawab (Model-View-Delegate).** Model memegang data dan strukturnya. View adalah wadah penampil. Delegate menentukan wujud satu unit data. Dengan begitu `ListView` bisa diganti `GridView` tanpa menyentuh data.
2. **Satu sumber kebenaran.** UI adalah fungsi dari data, bukan sebaliknya. Jangan menyimpan salinan data di dalam delegate.
3. **Model sebagai gerbang tunggal perubahan.** Semua mutasi lewat API sempit (`append`, `set`, `remove`, ...). Ini mudah diaudit, dan sejalan dengan prinsip modular dan kontrol penuh.
4. **Perspektif keamanan.** Data dari luar (jaringan, berkas) tidak boleh langsung masuk model. Pasang **gerbang validasi** di depan model, seperti petugas bea cukai. Gerbang itu memeriksa bentuk, tipe, rentang, dan jumlah.
5. **Isolasi.** Model tidak tahu view. Karena itu model bisa diuji tanpa antarmuka grafis (lihat latihan, yang berjalan *headless*).

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **Model** | Wadah data berstruktur yang bisa dibaca view. |
| **View** | Komponen penampil koleksi (`ListView`, `GridView`, `PathView`, `TableView`, `TreeView`), dibahas di 7.2. |
| **Delegate** | Cetakan visual satu baris/sel, dibuat view untuk tiap unit data. |
| **Role** | Satu "kolom bernama" pada baris model, misalnya `nama`. Delegate mengikatkan diri ke role. |
| **Baris / elemen** | Satu entri model, diakses lewat indeks 0..count-1. |
| **`index`** | Nomor baris. Bernilai -1 bila baris sudah dihapus dari model. |
| **`count`** | Properti baca-saja berisi jumlah baris. |
| **`modelData`** | Role tunggal tanpa nama untuk model tanpa role bernama (array string, integer). |
| **`QAbstractItemModel`** | Kelas dasar C++ semua model Qt. `ListModel` adalah turunannya (`QAbstractListModel`). |
| **Proxy model** | Model "lapisan" di atas model lain, untuk menyaring/mengurutkan tanpa mengubah sumber. |
| **Model reset** | Pemberitahuan "seluruh isi berubah". View membangun ulang semuanya, sehingga mahal. |
| **`dynamicRoles`** | Mode `ListModel` yang membolehkan tipe role berbeda antarbaris, dengan biaya kinerja. |
| **Gerbang validasi** | Fungsi yang memeriksa dan menormalkan data mentah sebelum masuk model. |

### 2.4 Peta visual

**Diagram A: arsitektur dan aliran data**

```
   SUMBER DATA                  MODEL                    VIEW                 DELEGATE
 (JS/jaringan/C++)         (baris x role)          (ListView, dll.)        (cetakan 1 baris)
        |                        |                        |                      |
        |--[gerbang validasi]--> |                        |                      |
        |   append/set/remove    |                        |                      |
        |                        |------- sinyal -------> |                      |
        |                        |  rowsInserted,         |-- buat/daur ulang -->|
        |                        |  dataChanged, ...      |                      |
        |                        |<----- baca role -------|<-- required property-|
```

**Diagram B: anatomi `ListModel`**

```
 ListModel { id: produk }          role "nama"     role "harga"
 +-------+                        +-----------+   +-----------+
 | index |                        |  string   |   |  number   |  <- tipe & himpunan role
 +-------+                        +-----------+   +-----------+     dikunci oleh data pertama
 |   0   | ---------------------> |  'Kopi'   |   |   15000   |
 |   1   | ---------------------> |  'Teh'    |   |    8000   |
 |   2   | ---------------------> |  'Susu'   |   |   12000   |
 +-------+                        +-----------+   +-----------+
 count = 3  (read-only)
```

**Diagram C: memilih jenis model**

```
Butuh data untuk view?
 |
 +-- hanya ulang N kali, tanpa data? ---------------> model: N          (integer)
 +-- daftar nilai sederhana, kecil? -----------------> model: ['a','b']  (array)
 +-- isi item = ITEM VISUAL berbeda-beda? -----------> ObjectModel
 +-- data terstruktur, diubah lewat QML? ------------> ListModel
 |       +-- ratusan baris --------------------------> ListModel (cukup)
 |       +-- ribuan / sering berubah / multi-thread -> model C++ (QAbstractListModel)
 +-- data tabel baris x kolom? ----------------------> TableModel (labs) / QAbstractTableModel
 +-- perlu filter/urut di atas model? ---------------> proxy model (C++ stabil / QML pratinjau)
```

---

## 3. 7.1.1 `ListModel` dan API-nya

> Rak yang tertib hari ini adalah laporan yang benar besok.

### 3.1 Dasar sintaks

`ListModel` berisi kumpulan `ListElement`. Tiap `ListElement` adalah satu baris, dan propertinya menjadi role. Tipe ini ada di modul `QtQml.Models`. Contoh di dokumentasi Qt bekerja hanya dengan `import QtQuick`, tetapi saya menyarankan menulis `import QtQml.Models` secara eksplisit agar jelas dari mana tipenya berasal.

**Contoh A: deklarasi statis**

```qml
import QtQuick
import QtQml.Models

Item {
    ListModel {
        id: produk
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh'; harga: 8000 }
    }
}
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `import QtQuick` | Memuat tipe dasar Qt Quick (`Item`, dll.). |
| `import QtQml.Models` | Memuat tipe model (`ListModel`, `ListElement`, `ObjectModel`, ...). |
| `Item { ... }` | Objek akar. Hanya wadah, tidak menggambar apa pun. |
| `ListModel { ... }` | Membuat objek model. Ia nirvisual (tidak tampil). |
| `id: produk` | Nama acuan model di seluruh berkas ini. View akan menulis `model: produk`. |
| `ListElement { ... }` | Satu baris data. |
| `nama: 'Kopi'` | Membuat role `nama` bertipe string bernilai `Kopi`. |
| `;` | Pemisah beberapa properti dalam satu baris. |
| `harga: 15000` | Role `harga` bertipe number. |

**Aturan `ListElement`:**

- Role harus diawali huruf kecil.
- Nilainya harus konstanta sederhana: string, angka, boolean, atau enum. Ekspresi dan binding tidak boleh dipakai.
- Role sebaiknya sama di semua elemen.
- Role boleh berisi list bersarang, yaitu `ListElement` di dalam `ListElement`.

**Contoh B: seluruh API dalam satu skrip uji**

```qml
import QtQuick
import QtQml.Models

Item {
    ListModel {
        id: produk
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh'; harga: 8000 }
    }

    function cetak(label) {
        const baris = []
        for (let i = 0; i < produk.count; ++i)
            baris.push(produk.get(i).nama + '=' + produk.get(i).harga)
        console.log(label + ' | count=' + produk.count + ' | ' + baris.join(', '))
    }

    Component.onCompleted: {
        cetak('awal')
        produk.append({ nama: 'Susu', harga: 12000 })
        cetak('append')
        produk.insert(1, { nama: 'Cokelat', harga: 20000 })
        cetak('insert(1)')
        produk.set(0, { harga: 16000 })
        cetak('set(0)')
        produk.setProperty(2, 'harga', 9000)
        cetak('setProperty(2)')
        produk.move(0, 3, 1)
        cetak('move(0,3,1)')
        produk.remove(1, 2)
        cetak('remove(1,2)')
        produk.clear()
        cetak('clear')
        Qt.quit()
    }
}
```

**Keluaran yang diharapkan** (urutan baris pasti, awalan `qml:` ditambahkan oleh pelari QML):

```
qml: awal | count=2 | Kopi=15000, Teh=8000
qml: append | count=3 | Kopi=15000, Teh=8000, Susu=12000
qml: insert(1) | count=4 | Kopi=15000, Cokelat=20000, Teh=8000, Susu=12000
qml: set(0) | count=4 | Kopi=16000, Cokelat=20000, Teh=8000, Susu=12000
qml: setProperty(2) | count=4 | Kopi=16000, Cokelat=20000, Teh=9000, Susu=12000
qml: move(0,3,1) | count=4 | Cokelat=20000, Teh=9000, Susu=12000, Kopi=16000
qml: remove(1,2) | count=2 | Cokelat=20000, Kopi=16000
qml: clear | count=0 |
```

**Penjelasan kode:**

| Bagian | Arti |
|---|---|
| `function cetak(label)` | Fungsi pembantu di objek akar. Fungsi harus berada **di dalam** objek QML, bukan di luar. |
| `const baris = []` | Array JavaScript kosong penampung teks. `const` berarti variabelnya tidak boleh diganti nilainya. |
| `for (let i = 0; i < produk.count; ++i)` | Iterasi indeks 0 sampai count-1. `++i` menambah i satu per putaran. |
| `produk.get(i).nama` | `get(i)` mengembalikan objek baris. `.nama` membaca rolenya. |
| `baris.join(', ')` | Menggabungkan elemen array menjadi satu string dengan pemisah koma. |
| `Component.onCompleted` | Dijalankan sekali ketika komponen selesai dibuat. |
| `Qt.quit()` | Mengakhiri aplikasi, sehingga skrip uji selesai sendiri. |

### 3.2 Referensi API

| Metode | Perilaku | Catatan |
|---|---|---|
| `append(dict)` | Menambah baris di akhir | Bila model kosong, baris ini menentukan role |
| `insert(index, dict)` | Menyisip di `index` | `index` boleh sama dengan `count` (setara append) |
| `set(index, dict)` | Mengganti beberapa role sekaligus | Role yang tidak disebut tidak berubah. `index == count` berarti menambah baris baru |
| `setProperty(index, role, nilai)` | Mengubah satu role | `index` harus ada |
| `move(from, to, n)` | Memindah `n` baris | Kedua rentang harus ada |
| `remove(index, count = 1)` | Menghapus `count` baris | Argumen kedua opsional |
| `clear()` | Mengosongkan model | Juga membatalkan semua objek hasil `get()` dan mereset himpunan role |
| `get(index)` | Mengembalikan objek baris yang "hidup" | Boleh dibaca dan diubah. **Jangan** dipakai di binding atau disimpan lama |
| `sync()` | Menulis perubahan dari thread kerja | Wajib dipanggil di `WorkerScript` |
| `count` | Jumlah baris (baca-saja) | |
| `dynamicRoles` | Mengizinkan tipe role berbeda antarbaris | Harus diset **sebelum** data masuk, dari thread utama, tidak bisa untuk data statis `ListElement`, dan sekitar 4-6x lebih lambat |

### 3.3 Himpunan role dikunci oleh data pertama

Untuk model yang diisi lewat JavaScript, baris pertama yang masuk menentukan role dan tipenya. Role yang muncul belakangan tidak ditangani view. Tipe satu role yang sudah terkunci juga tidak bisa diganti, misalnya angka yang lalu diberi string. `clear()` mereset kunci itu. Properti `dynamicRoles` melonggarkan aturan ini, tetapi dengan harga kinerja.

```qml
ListModel { id: m }
Component.onCompleted: {
    m.append({ nama: 'Kopi', harga: 15000 })   // role terkunci: nama (string), harga (number)
    m.append({ nama: 'Teh', harga: 'murah' })  // ditolak: harga sudah Number
    m.clear()                                  // reset kunci
    m.append({ nama: 'Teh', harga: 'murah' })  // sekarang sah, role baru terkunci ulang
}
```

### 3.4 Role berisi list, dan properti kustom

```qml
ListModel {
    property string mataUang: 'IDR'          // properti kustom pada model
    ListElement {
        nama: 'Kopi'
        tag: [ ListElement { teks: 'panas' }, ListElement { teks: 'pahit' } ]
    }
}
```

Role `tag` menjadi model bersarang. Aksesnya `produk.get(0).tag.get(1).teks`. Untuk membangun baris bersarang dari JavaScript, berikan array objek: `append({ nama: 'Teh', tag: [{ teks: 'dingin' }] })`.

### 3.5 Opsi lain untuk logika yang sama (mengubah nilai)

| Opsi | Kapan dipakai |
|---|---|
| `m.setProperty(i, 'harga', v)` | Mengubah satu role. Paling eksplisit |
| `m.set(i, { harga: v, stok: 3 })` | Mengubah beberapa role sekaligus |
| `m.get(i).harga = v` | Gaya objek. Hati-hati, objeknya hidup dan bisa tidak valid |
| `model.harga = v` dari delegate | Menulis dari tampilan (bergantung `delegateModelAccess`, Modul 7.2) |
| Bangun ulang dengan `clear()` lalu `append` | Sumber berganti total. Memicu reset, jadi mahal |

### 3.6 Praktik terbaik dan jebakan

- Bungkus semua mutasi dalam fungsi bernama (`tambah`, `hapusAt`) agar ada satu pintu masuk. Itu tempat validasi dan batas jumlah.
- Pakai nama role yang spesifik (`namaProduk`, bukan `name`/`color`/`index`), supaya tidak bentrok dengan properti delegate.
- Jebakan: P1, P2, P4, P5, P6, P7, P8, P9, dan P11 pada tabel di bagian 10.

---

## 4. 7.1.2 Array, angka, dan objek sebagai model

> Alat paling sederhana sering cukup untuk pekerjaan yang paling sering.

Tidak semua daftar butuh `ListModel`. Qt Quick menerima beberapa bentuk sebagai model:

| Bentuk | Role yang diterima delegate | Contoh |
|---|---|---|
| Integer `N` | Hanya `index` (tanpa data) | `model: 5` |
| Array nilai sederhana | `modelData` (satu nilai) | `model: ['a', 'b']` |
| Array objek JS | Setiap kunci objek menjadi role | `model: [{nama:'Kopi'}]` |
| Objek tunggal | Properti objek menjadi role (satu baris) | `model: myText` |

Batas model integer adalah 100.000.000 item, tetapi jangan mengujinya: Repeater tidak memvirtualisasi.

**Contoh: array biasa tidak memberi tahu apa pun saat berubah**

```qml
import QtQuick

Item {
    id: root
    property var daftar: ['Kopi', 'Teh']

    Repeater {
        id: pengulang
        model: root.daftar
        delegate: Item {
            required property string modelData
            required property int index
            Component.onCompleted: console.log('dibuat:', index, modelData)
        }
    }

    Timer {
        interval: 200; running: true
        onTriggered: {
            root.daftar.push('Susu')                          // (1) diubah di tempat
            console.log('setelah push, count =', pengulang.count)
            root.daftar = root.daftar.concat(['Cokelat'])     // (2) properti DIGANTI
            console.log('setelah reassign, count =', pengulang.count)
            Qt.quit()
        }
    }
}
```

**Perilaku yang diharapkan** (urutan log awal dapat sedikit berbeda, yang penting perilakunya):

- Awalnya dibuat 2 delegate (`Kopi`, `Teh`).
- Setelah `push`, `count` tetap 2, karena view memegang **salinan** array dan tidak diberi tahu.
- Setelah penggantian properti, delegate dibangun ulang sehingga `count` menjadi 4: `Kopi`, `Teh`, `Susu`, `Cokelat`. Isi array yang sudah di-`push` ikut terbawa.

**Penjelasan kata demi kata:**

| Bagian | Arti |
|---|---|
| `property var daftar: [...]` | Properti bertipe bebas (`var`) yang menyimpan array JS. |
| `Repeater` | Pembuat banyak item dari model. Cocok untuk daftar kecil. Untuk daftar panjang pakai `ListView` (7.2). |
| `required property string modelData` | Menyatakan delegate **wajib** menerima role `modelData` bertipe string. |
| `Timer { running: true }` | Memicu `onTriggered` sekali setelah 200 ms, supaya aksi dijalankan setelah UI selesai dibuat. |
| `.push('Susu')` | Menambah elemen di tempat tanpa mengganti properti, sehingga **tidak ada notifikasi**. |
| `root.daftar = ...concat(...)` | Mengganti seluruh nilai properti. Sinyal perubahan menyala dan view dibangun ulang. |

**Dua pola yang benar:**

```qml
// Pola 1 (disarankan): ganti dengan array baru
root.daftar = [...root.daftar, 'Susu']

// Pola 2: ubah di tempat, lalu umumkan secara manual
root.daftar.push('Susu')
root.daftarChanged()     // menyalakan sinyal; view di-reset penuh
```

Kedua pola membuat view membangun ulang semuanya, sehingga posisi gulir dan `currentIndex` bisa hilang. Untuk daftar yang sering berubah, `ListModel` lebih tepat.

**Menulis balik tidak mengubah array sumber.** Menurut dokumentasi, model bertipe nilai (array JS, angka) disalin ke view. Model yang punya identitas (`ListModel`, turunan `QAbstractItemModel`, objek dan daftar objek QML) tetap menjadi satu-satunya sumber kebenaran.

**Objek tunggal sebagai model:**

```qml
Text { id: contoh; text: 'Halo'; color: '#dd44ee' }
ListView {
    model: contoh                                   // satu baris; properti Text menjadi role
    delegate: Text {
        required property var model                 // dikualifikasi agar `color` tidak bentrok
        text: model.color
    }
}
```

**Opsi lain untuk daftar yang sama:** array JS (sederhana, reassign), `ListModel` (granular), model C++ (skala besar). Pilih sesuai Diagram C.

---

## 5. 7.1.3 `ObjectModel`

> Kadang yang kita susun bukan data, melainkan potongan antarmuka itu sendiri.

`ObjectModel` berisi **item visual jadi**. View yang memakainya tidak butuh `delegate`, karena isi modelnya sudah merupakan item.

```qml
import QtQuick
import QtQml.Models

Item {
    width: 240; height: 140

    ObjectModel {
        id: halaman
        Rectangle { width: 240; height: 40; color: 'tomato';   property string judul: 'Merah' }
        Rectangle { width: 240; height: 40; color: 'seagreen'; property string judul: 'Hijau' }
    }

    ListView {
        anchors.fill: parent
        model: halaman           // tanpa delegate
    }

    Component.onCompleted: {
        console.log(halaman.count, halaman.get(0).judul)   // qml: 2 Merah
        Qt.quit()
    }
}
```

**Penjelasan:**

| Bagian | Arti |
|---|---|
| `ObjectModel { id: halaman ... }` | Model yang anak-anaknya adalah item visual. |
| `property string judul: 'Merah'` | Properti kustom pada item, supaya bisa dibaca lewat `get()`. |
| `model: halaman` | View langsung memakai item itu sebagai isi. |
| `halaman.get(0)` | Mengambil objek item pada indeks 0. |

**API `ObjectModel`:** ia punya `append`, `clear`, `get`, `insert`, `move`, dan `remove`, serta properti terlampir `ObjectModel.index` yang memberi tahu posisi sebuah item di dalam model. Untuk menambah item saat runtime biasanya dipakai `halaman.append(komponen.createObject())`, yang dibahas di Modul 7.3. Di sana pula dibahas siapa yang menghancurkan objek tersebut.

**Karakter penting:** semua item dibuat di muka dan tidak didaur ulang. Satu item hanya bisa tampil di satu tempat. Karena itu `ObjectModel` cocok untuk himpunan kecil dan beragam, seperti halaman wizard, tab, atau panel pengaturan. Ia **tidak** cocok untuk ratusan baris data.

**Opsi lain:** `Repeater` di dalam `Column` (statis), `StackLayout`/`SwipeView` dari Qt Quick Controls (halaman bertumpuk), atau `Loader` (muat saat dibutuhkan, 7.3).

---

## 6. 7.1.4 Kapan model harus pindah ke C++

> Tahu kapan berhenti memakai alat yang nyaman adalah tanda penguasaan.

`ListModel` luar biasa untuk prototipe dan data kecil. Tanda-tanda sudah waktunya C++ (ukur dulu dengan profil, jangan menebak):

1. Data sampai ribuan baris atau lebih, atau berubah dengan sangat sering.
2. Data berasal dari lapisan C++ (basis data, jaringan, sensor), jadi menyalinnya ke JS hanyalah beban.
3. Pembaruan butuh pekerjaan di thread lain. `ListModel` hanya bisa lewat `WorkerScript` plus `sync()`.
4. Butuh tipe yang kuat, validasi ketat, `dataChanged` yang presisi per role, undo/redo, atau reorder dengan logika domain.
5. Model perlu diuji unit tanpa QML.

Qt juga menerima `QStringList`, `QVariantList`, dan `QList<QObject*>` sebagai model. Itu jalur tengah yang mudah, tetapi perubahan umumnya berarti reset penuh. Untuk kontrol sebenarnya pakai `QAbstractListModel`.

**Pratinjau (Modul 10.5 membedahnya secara penuh):**

```cpp
// produkmodel.h
#pragma once
#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>

struct Produk { QString nama; int harga; };

class ProdukModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    enum Role { NamaRole = Qt::UserRole + 1, HargaRole };
    explicit ProdukModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

    int rowCount(const QModelIndex &parent = {}) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void tambah(const QString &nama, int harga);
private:
    QList<Produk> m_data;
};
```

```cpp
// produkmodel.cpp
#include "produkmodel.h"

int ProdukModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_data.size();
}

QVariant ProdukModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
        return {};
    const Produk &p = m_data.at(index.row());
    switch (role) {
    case NamaRole:  return p.nama;
    case HargaRole: return p.harga;
    }
    return {};
}

QHash<int, QByteArray> ProdukModel::roleNames() const
{
    return { { NamaRole, "nama" }, { HargaRole, "harga" } };
}

void ProdukModel::tambah(const QString &nama, int harga)
{
    beginInsertRows({}, m_data.size(), m_data.size());
    m_data.append(Produk{ nama, harga });
    endInsertRows();
}
```

```cmake
qt_add_qml_module(appToko
    URI Toko
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES produkmodel.h produkmodel.cpp
)
```

```qml
import QtQuick
import Toko

ListView {
    model: ProdukModel { id: pm }
    delegate: Text {
        required property string nama
        required property int harga
        text: nama + ' — ' + harga
    }
    Component.onCompleted: pm.tambah('Kopi', 15000)
}
```

**Penjelasan inti:**

| Bagian | Arti |
|---|---|
| `QAbstractListModel` | Kelas dasar C++ untuk model daftar. |
| `QML_ELEMENT` | Mendaftarkan kelas sebagai tipe QML bernama `ProdukModel`. |
| `rowCount` | Jumlah baris. Mengembalikan 0 jika `parent` valid, karena daftar datar tidak punya anak. |
| `data` | Menjawab "nilai role X pada baris Y". |
| `roleNames` | Memetakan nomor role C++ ke nama yang dilihat QML (`nama`, `harga`). |
| `beginInsertRows`/`endInsertRows` | Membungkus perubahan agar sinyal yang benar terkirim ke view. |
| `Q_INVOKABLE` | Membuat metode bisa dipanggil dari QML. |

**Praktik terbaik:** jaga agar model C++ tetap tipis dan terbungkus API yang sempit. Jangan memakai `Q_PROPERTY` bertipe `QObject*` mentah tanpa memikirkan kepemilikan. Detailnya ada di 10.5.

**Pustaka rujukan:** [Using C++ Models with Qt Quick Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-cppmodels.html).

---

## 7. 7.1.5 Memfilter dan mengurutkan

> Jangan merusak sumber untuk mengubah pandangan.

Prinsipnya: **sumber tetap utuh, tampilan yang disaring.** Itulah gunanya proxy model, yaitu lapisan di antara model dan view.

**Opsi A: `QSortFilterProxyModel` di C++ (jalur stabil).**

```cpp
auto *proxy = new QSortFilterProxyModel(this);
proxy->setSourceModel(&m_model);
proxy->setFilterRole(ProdukModel::NamaRole);
proxy->setFilterCaseSensitivity(Qt::CaseInsensitive);
proxy->setFilterFixedString(teks);            // atau setFilterRegularExpression(...)
proxy->setSortRole(ProdukModel::HargaRole);
proxy->sort(0, Qt::AscendingOrder);
```

Proxy ini meneruskan nama role dari model sumbernya, sehingga delegate tidak perlu diubah.

**Opsi B: `SortFilterProxyModel` di QML (pratinjau).** Tipe ini ada di `QtQml.Models` sejak Qt 6.10 dan berstatus tidak final, sehingga API-nya bisa berubah. Satu contoh nyata perubahan itu adalah nama properti sumber. Salinan dokumentasi yang lebih lama menyebut properti `model`, sedangkan dokumentasi 6.12 memakai `sourceModel`. Bentuk fungsi di `FunctionFilter` pun berbeda antarversi. Periksa versi Qt Anda dulu (`pacman -Q qt6-declarative`) dan baca halaman dokumentasi versi itu.

Contoh berikut mengikuti dokumentasi 6.12:

```qml
import QtQuick
import QtQml.Models

Item {
    width: 260; height: 160

    ListModel {
        id: sumber
        ListElement { nama: 'Kopi';  harga: 15000 }
        ListElement { nama: 'Teh';   harga: 8000 }
        ListElement { nama: 'Susu';  harga: 12000 }
    }

    SortFilterProxyModel {
        id: tampilan
        sourceModel: sumber
        sorters: [ RoleSorter { roleName: 'harga' } ]
        filters: [
            FunctionFilter {
                function filter(harga: int) : bool { return harga >= 10000 }
            }
        ]
    }

    ListView {
        anchors.fill: parent
        model: tampilan
        delegate: Text {
            required property string nama
            required property int harga
            text: nama + ' — ' + harga
        }
    }
}
```

**Penjelasan:**

| Bagian | Arti |
|---|---|
| `sourceModel: sumber` | Model asli yang tidak diubah. |
| `sorters: [ RoleSorter { roleName: 'harga' } ]` | Urutkan menurut role `harga`. |
| `filters: [ FunctionFilter { ... } ]` | Daftar filter. Fungsi `filter` mengembalikan `true` jika baris lolos. |
| `function filter(harga: int) : bool` | Dalam dokumentasi 6.12, nama parameter dipetakan ke nama role dan tipenya wajib dianotasi. |
| `ListView { model: tampilan }` | View membaca proxy, bukan sumber. |

Tipe lain di keluarga ini adalah `ValueFilter`, `StringSorter`, dan `FunctionSorter`. Perhatikan bahwa `FunctionSorter` sudah ditandai usang sejak 6.12.

**Opsi C: bangun model kedua lewat JavaScript (data kecil).**

```qml
ListModel { id: sumber }      // berisi seluruh data
ListModel { id: tampil }      // yang ditampilkan

function terapkanFilter(teks) {
    const kunci = teks.toLowerCase()
    tampil.clear()
    for (let i = 0; i < sumber.count; ++i) {
        const b = sumber.get(i)
        if (b.nama.toLowerCase().includes(kunci))
            tampil.append({ nama: b.nama, harga: b.harga })
    }
}
```

Biayanya O(n) tiap panggilan dan view dibangun ulang. Cukup untuk ratusan baris, bukan ribuan.

**Opsi D: menyembunyikan delegate (`visible: false`).** Ini peretasan: indeks tetap menghitung baris tersembunyi dan celahnya perlu diakali. Jangan untuk data nyata.

**Rekomendasi:** C++ stabil untuk produksi dan data besar. Opsi B untuk eksperimen atau proyek yang siap menyesuaikan API. Opsi C untuk data kecil.

---

## 8. 7.1.6 (TAMBAHAN) Model lain

> Menguasai peta model sebelum menjelajah.

**`XmlListModel`.** Membangun model dari XML dengan peran yang didefinisikan lewat `XmlListModelRole`. Di Qt 6 ia perlu `import QtQml.XmlListModel`. Karena ia dapat memuat dari URL, perlakukan sumbernya sebagai data tak tepercaya (HTTPS, validasi hasil).

**`TableModel` dan `TableModelColumn`.** Model tabel sederhana untuk `TableView`, tanpa subkelas C++. Tipe ini ada di `Qt.labs.qmlmodels`, dan modul `Qt.labs.qmlmodels` menyediakan tipe model eksperimental termasuk `TableModel`, `TableModelColumn`, dan `TreeModel`, jadi tanpa jaminan kompatibilitas antarversi.

```qml
import QtQuick
import Qt.labs.qmlmodels

TableView {
    implicitWidth: 240; implicitHeight: 90
    model: TableModel {
        TableModelColumn { display: 'nama' }
        TableModelColumn { display: 'harga' }
        rows: [
            { nama: 'Kopi', harga: 15000 },
            { nama: 'Teh',  harga: 8000 }
        ]
    }
    delegate: Text {
        required property var display
        text: display
        padding: 8
    }
}
```

Urutan `TableModelColumn` menentukan indeks kolom. Data awal diberikan lewat `rows` atau `appendRow()`. Baris diubah dengan `insertRow`, `removeRow`, `moveRow`, dan `getRow`. Kolom `display` memetakan kunci objek baris ke role bawaan Qt. Baris bersarang yang kompleks hanya didukung terbatas. Detail `TableView` ada di 7.2.3.

**`TreeModel`** adalah model pohon eksperimental di modul yang sama. **`DelegateModel`** membungkus model dan delegate sekaligus, dipakai untuk pengelompokan dan pemilihan delegate, dibahas di 7.2.

---

## 9. 7.1.7 (TAMBAHAN) Memantau perubahan model, studi kasus keranjang

> Data yang berubah tanpa kabar adalah sumber bug paling licin.

**Masalahnya.** Binding hanya melacak properti yang dibacanya. Pembacaan lewat `get(i).harga` di dalam binding tidak dilacak, dan objek hasil `get()` memang tidak dijamin tetap valid. Maka `total: hitung()` yang menjumlah isi `ListModel` tidak akan hidup mengikuti `setProperty`. Solusi yang dapat diandalkan adalah **mendengar sinyal model**.

`ListModel` mewarisi `QAbstractListModel`, sehingga sinyal standarnya bisa didengar lewat `Connections`: `dataChanged`, `rowsInserted`, `rowsRemoved`, `rowsMoved`, `modelReset`.

**Diagram D: rantai sinyal pada `append`**

```
produk.append({...})
   |
   v
[model] rowsAboutToBeInserted -> data disimpan -> rowsInserted -> countChanged
                                                      |
                                                      v
                              [view] buat delegate baris baru -> required property terisi
                                                      |
                                                      v
                              [Connections] onRowsInserted -> hitungTotal() -> total berubah
```

**Studi kasus: keranjang kasir dengan gerbang validasi**

```qml
import QtQuick
import QtQml.Models

Item {
    id: root

    property int total: 0
    readonly property int maksBaris: 100

    ListModel { id: keranjang }       // sengaja kosong: role ditentukan append pertama

    // Gerbang validasi: izinkan hanya bentuk yang dikenal
    function bersihkan(mentah) {
        if (mentah === null || typeof mentah !== 'object') return null
        const nama = typeof mentah.nama === 'string' ? mentah.nama.trim() : ''
        const harga = Number(mentah.harga)
        if (nama === '' || !Number.isFinite(harga) || harga < 0) return null
        return { nama: nama, harga: harga, qty: 1 }
    }

    function tambah(mentah) {
        const bersih = bersihkan(mentah)
        if (bersih === null) {
            console.warn('ditolak:', JSON.stringify(mentah))
            return false
        }
        for (let i = 0; i < keranjang.count; ++i) {
            if (keranjang.get(i).nama === bersih.nama) {
                keranjang.setProperty(i, 'qty', keranjang.get(i).qty + 1)
                return true
            }
        }
        if (keranjang.count >= maksBaris) return false     // batas pertumbuhan
        keranjang.append(bersih)
        return true
    }

    function hapusAt(i) {
        if (i >= 0 && i < keranjang.count) keranjang.remove(i)
    }

    function hitungTotal() {
        let jumlah = 0
        for (let i = 0; i < keranjang.count; ++i) {
            const b = keranjang.get(i)
            jumlah += b.harga * b.qty
        }
        total = jumlah
    }

    Connections {
        target: keranjang
        function onDataChanged()  { root.hitungTotal() }
        function onRowsInserted() { root.hitungTotal() }
        function onRowsRemoved()  { root.hitungTotal() }
        function onModelReset()   { root.hitungTotal() }
    }

    onTotalChanged: console.log('total =', total)

    Component.onCompleted: {
        tambah({ nama: 'Kopi', harga: 15000 })
        tambah({ nama: 'Kopi', harga: 15000 })
        tambah({ nama: 'Teh', harga: 8000 })
        tambah({ nama: '', harga: 'abc' })
        tambah({ nama: 'Susu', harga: -5 })
        hapusAt(0)
        Qt.quit()
    }
}
```

**Keluaran yang diharapkan:**

```
qml: total = 15000
qml: total = 30000
qml: total = 38000
qml: ditolak: {"nama":"","harga":"abc"}
qml: ditolak: {"nama":"Susu","harga":-5}
qml: total = 8000
```

**Penjelasan kata demi kata:**

| Bagian | Arti |
|---|---|
| `readonly property int maksBaris: 100` | Konstanta batas ukuran, untuk mencegah model membengkak tanpa batas. |
| `typeof mentah !== 'object'` | Memeriksa tipe bawaan JS. Bukan objek berarti ditolak. |
| `.trim()` | Membuang spasi di ujung string. |
| `Number(mentah.harga)` | Memaksa jadi angka. `'abc'` menghasilkan `NaN`. |
| `Number.isFinite(harga)` | Benar hanya untuk angka terbatas (bukan `NaN`/`Infinity`). |
| `return null` | Sinyal "ditolak" ke pemanggil. |
| `Connections { target: keranjang ... }` | Mendengar sinyal dari model tertentu. |
| `function onRowsInserted() {...}` | Penangan sinyal. Parameter sinyal boleh dihilangkan jika tidak dipakai. |
| `onTotalChanged:` | Penangan otomatis untuk sinyal perubahan properti `total`. |
| Mengapa `hapusAt(0)` menghapus Kopi? | Kopi ada di indeks 0 karena ditambahkan pertama. Total tersisa harga Teh. |

**Opsi lain untuk logika yang sama:**

| Opsi | Karakter |
|---|---|
| **A. `Connections`** (di atas) | Otomatis, tetapi bergantung pada sinyal yang tepat |
| **B. Panggil `hitungTotal()` di setiap fungsi mutasi** | Paling eksplisit, tanpa "sihir". Cocok bila pintu mutasi memang satu |
| **C. Pola tak-berubah (immutable)** | `property var item: []`, lalu `readonly property int total: item.reduce((s, b) => s + b.harga * b.qty, 0)`, dan mutasi dengan `item = [...item, b]`. Binding bekerja sendiri, tetapi view ikut reset |
| **D. Model C++ dengan `Q_PROPERTY(int total NOTIFY totalChanged)`** | Skala besar. Hitungan ada di satu tempat |

---

## 10. Penutup modul

### 10.1 Hubungan dengan modul lain

- **Prasyarat:** 2.x (array, objek, fungsi), 3.x (properti, binding, sinyal, `Connections`), 5.1 (`Component` sebagai API).
- **7.2 View dan Delegate:** view membaca model ini lewat `required property`, `index`, `delegateModelAccess`, dan `section`.
- **7.3 Objek Dinamis:** `ObjectModel` menerima hasil `createObject()`. `Instantiator` juga memakai `model` untuk membuat objek.
- **7.4 Data Asinkron:** hasil XHR dan `JSON.parse` harus lewat gerbang `bersihkan()` sebelum `append`.
- **10.5 dan 10.7:** model C++ dan pekerjaan berat di thread terpisah.
- **13.1 Keamanan:** validasi input, batas ukuran, dan larangan `Qt.createQmlObject` pada teks tak tepercaya.

### 10.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| P1 | Peringatan role bertipe berbeda, nilai tak tersimpan | Tipe role campuran | Normalkan di gerbang validasi (`Number(...)`), atau `dynamicRoles` (lebih lambat) |
| P2 | Role baru tidak tampil di view | Himpunan role dikunci data pertama | Pastikan baris pertama memuat semua role, atau `clear()` lalu isi ulang |
| P3 | `push`/`splice` tidak mengubah tampilan | Mutasi di tempat tidak memberi notifikasi | Ganti array (`= [...a, x]`) atau panggil `daftarChanged()` |
| P4 | Total/teks basi atau galat aneh | `get()` dipakai di binding atau disimpan | Hitung ulang lewat sinyal (7.1.7) atau di fungsi mutasi |
| P5 | Sebagian baris terlewat saat menghapus dalam loop | Indeks bergeser setelah `remove` | Iterasi **mundur**: `for (let i = m.count - 1; i >= 0; --i)` |
| P6 | Galat saat `insert`/`get`/`set` | Indeks di luar rentang | Periksa `0 <= i < count` (untuk `insert`: `<= count`) |
| P7 | Galat di `ListElement` | Ekspresi atau binding di nilai role | Hanya konstanta. Hitung di JS lalu `append` |
| P8 | Delegate menampilkan nilai properti sendiri, bukan data | Nama role bentrok (`color`, `index`, `model`) | Nama role spesifik, atau `required property var model` lalu `model.color` |
| P9 | Perubahan dari thread kerja tak terlihat | Lupa `sync()` | Panggil `sync()` di worker setelah mengubah |
| P10 | Kode tak dikenal dieksekusi | `Qt.createQmlObject` dengan teks luar | Jangan. Gunakan komponen tetap dan data tervalidasi |
| P11 | Memori terus naik | Tidak ada batas pertumbuhan | Batas jumlah di gerbang (`maksBaris`) |

### 10.3 Latihan 15 menit

**Persiapan terminal (Arch).** Nama biner QML bisa berbeda antarpaket, jadi cari dulu:

```bash
pacman -Q qt6-declarative                                # versi yang terpasang
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmllint|qmlformat)'   # nama biner di sistem Anda
```

Pakai nama yang muncul, misalnya jika bernama `qml`:

```bash
QT_QPA_PLATFORM=offscreen qml latihan71.qml     # jalan tanpa jendela
qmllint latihan71.qml                            # pemeriksaan statis
qmlformat -i latihan71.qml                       # rapikan di tempat
```

Kegunaan masing-masing: `qml` menjalankan berkas, `qmllint` mendeteksi kesalahan dan gaya usang, `qmlformat` menyeragamkan format. `QT_QPA_PLATFORM=offscreen` memberi platform tanpa layar.

**Langkah:**

1. Salin Contoh B (7.1.1) ke `latihan71.qml` dan jalankan. Cocokkan keluarannya baris demi baris.
2. Tambahkan `produk.append({ nama: 'Gula', harga: 'murah' })` setelah `cetak('awal')`. Amati peringatan, lalu cocokkan dengan P1.
3. Ubah menjadi `produk.clear()` diikuti `append` dengan harga string. Mengapa sekarang berhasil?
4. Salin contoh array (7.1.2) dan buktikan perbedaan `push` dengan penggantian properti.
5. Jalankan `qmllint` dan perbaiki setiap peringatan yang muncul.

**Tantangan 10 menit:** tambahkan fungsi `hapusJikaMurah(batas)` pada keranjang yang menghapus semua baris dengan `harga < batas`. Gunakan iterasi mundur (P5).

### 10.4 Cek pemahaman

1. Mengapa model besar sebaiknya berada di C++?
2. Mengapa `push` pada array tidak mengubah tampilan, sedangkan penggantian properti mengubahnya?
3. Mengapa `get()` tidak boleh dipakai dalam binding?
4. Kapan `ObjectModel` lebih tepat dari `ListModel`?
5. Apa yang terkunci oleh data pertama pada `ListModel` yang diisi dari JS?

**Jawaban singkat:**

1. Data tersimpan terstruktur dan bertipe, tanpa konversi bolak-balik ke lapisan JS pada tiap akses. Sinyal bisa presisi per baris atau role. Pekerjaan bisa pindah ke thread lain. Logika bisnis punya satu rumah dan model bisa diuji unit. Ini bukan aturan berhitung ukuran, jadi ukur dengan profil.
2. View memegang salinan array dan hanya mengetahui perubahan saat properti diberi nilai baru (sinyal perubahan menyala).
3. Binding tidak melacak pembacaan lewat `get()`, dan dokumentasi menyatakan objek hasil `get()` tidak dijamin tetap valid. Gunakan sinyal model.
4. Saat isinya adalah item visual jadi yang beragam dan sedikit, seperti halaman wizard atau tab, bukan data berulang.
5. Himpunan role dan tipenya. Reset dengan `clear()`.

### 10.5 Referensi

Tautan `doc.qt.io` berikut saya temukan di halaman dokumentasi Qt 6.12 yang saya baca saat menyusun materi ini. MDN dan qmlbook tidak saya buka ulang, jadi periksa sendiri bila tautannya berubah.

- [Models and Views in Qt Quick](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html)
- [ListModel](https://doc.qt.io/qt-6/qml-qtqml-models-listmodel.html) · [ListElement](https://doc.qt.io/qt-6/qml-qtqml-models-listelement.html)
- [ObjectModel](https://doc.qt.io/qt-6/qml-qtqml-models-objectmodel.html)
- [Qt QML Models (daftar tipe modul)](https://doc.qt.io/qt-6/qtqmlmodels-index.html)
- [SortFilterProxyModel (QML)](https://doc.qt.io/qt-6/qml-qtqml-models-sortfilterproxymodel.html) · [QSortFilterProxyModel (C++)](https://doc.qt.io/qt-6/qsortfilterproxymodel.html)
- [TableModel (Qt.labs.qmlmodels)](https://doc.qt.io/qt-6/qml-qt-labs-qmlmodels-tablemodel.html) · [XmlListModel](https://doc.qt.io/qt-6/qml-qtqml-xmllistmodel-xmllistmodel.html)
- [Using C++ Models with Qt Quick Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-cppmodels.html) · [QAbstractListModel](https://doc.qt.io/qt-6/qabstractlistmodel.html)
- [WorkerScript](https://doc.qt.io/qt-6/qml-qtqml-workerscript-workerscript.html)
- [Qt Quick: Data, models, views, and data storage](https://doc.qt.io/qt-6/qtquick-modelviewsdata-topic.html)
- [MDN: Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
- Tidak resmi: [Qt Academy](https://www.qt.io/academy) · [Qt Forum](https://forum.qt.io/) · [The Qt Quick/QML Book (komunitas)](https://qmlbook.github.io/)

---

# Modul 7.2: View dan Delegate

*Fase 7: Model, View, dan Arsitektur Data*

## Daftar isi modul ini

1. Audit singkat sebelum materi
2. Fondasi: peran modul, konsep dan filosofi, terminologi, peta visual
3. **7.2.1** `ListView` dan `GridView`
4. **7.2.2** `PathView` dan `Repeater`
5. **7.2.3** `TableView`
6. **7.2.4** Delegate dengan `required property`
7. **7.2.5** `currentIndex` dan `highlight`
8. **7.2.6** `cacheBuffer` dan `reuseItems`
9. **7.2.7** Delegate ringan
10. **7.2.8** (TAMBAHAN) Dekorasi view: `header`, `footer`, `section`, scrollbar
11. **7.2.9** (TAMBAHAN) Transisi dan siklus hidup delegate
12. **7.2.10** (TAMBAHAN) Menulis data dari delegate: `delegateModelAccess`
13. **7.2.11** (TAMBAHAN) Mengendalikan view lewat kode dan delegate beragam
14. Penutup: hubungan modul, tabel kesalahan, latihan, cek pemahaman, referensi

---

## 1. Audit singkat

Saya membaca bagian 7.2 terhadap dokumentasi Qt 6.12 (`ListView`, `GridView`, `PathView`, `TableView`, Models and Views) dan prasyaratnya.

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Prasyarat: 7.1 (model), 5.1 (Component), 6.1-6.2 (`Transition`, animasi), 6.3 (`Keys`) | Aman, tidak ada loncatan | Tidak ada |
| 2 | Contoh kurikulum memakai `ListView.view.width` | Benar | Dokumentasi memang melarang `parent.width` di delegate. Dijelaskan di 7.2.1 |
| 3 | "`model.nama` gagal di bawah `pragma ComponentBehavior: Bound`" | Benar | Diverifikasi dan dijelaskan di 7.2.4 |
| 4 | `reuseItems` | Kurang | Defaultnya **berbeda**: `false` di `ListView`/`GridView`, tetapi `TableView` mendaur ulang secara default. Ditambahkan di 7.2.6 |
| 5 | `TableView` hanya disebut nama | Terlalu tipis | Diperluas: ukuran lewat `implicitWidth`, provider, seleksi, edit, header |
| 6 | `header`/`footer`/`section`, transisi, `delayRemove` | Belum ada | TAMBAHAN 7.2.8 dan 7.2.9 |
| 7 | Menulis balik dari delegate (`delegateModelAccess`, Qt 6.10+) | Ditunda dari 7.1 | TAMBAHAN 7.2.10 |
| 8 | `positionViewAtIndex`, `itemAtIndex`, `forceLayout`, delegate beragam | Belum ada | TAMBAHAN 7.2.11 |
| 9 | Teks dari data luar di dalam delegate | Celah keamanan | Ditambahkan di 7.2.7 dan 7.2.11 (`textFormat`) |
| 10 | Komponen Qt Quick Controls (`HorizontalHeaderView`, `TableViewDelegate`, `ScrollBar`) | Di luar Fase 7 | Hanya diperkenalkan sebagai penunjuk |

**Pembaruan daftar isi kurikulum 7.2:** 7.2.1 sampai 7.2.7 tetap, ditambah **7.2.8** (Dekorasi), **7.2.9** (Transisi dan siklus hidup), **7.2.10** (Menulis data dari delegate), dan **7.2.11** (Kendali lewat kode dan delegate beragam).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Modul 7.1 menjawab di mana data hidup. Modul ini menjawab bagaimana data itu **tampil**: dengan tata letak apa, bagaimana pengguna menavigasinya, dan bagaimana ribuan baris bisa tampil mulus. Hampir semua aplikasi nyata memakai daftar, kisi, atau tabel, jadi modul ini dipakai di hampir setiap proyek.

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Bayangkan **jendela kereta** yang menghadap pemandangan sepanjang 5.000 kilometer. Anda tidak membawa seluruh pemandangan ke dalam gerbong. Hanya potongan yang lewat jendela yang "dipasang". Potongan yang sudah lewat dibongkar, atau bahannya dipakai ulang untuk potongan berikutnya. Jendela adalah **view**. Potongan pemandangan adalah **delegate**. Seluruh pemandangan adalah **model**.

Prinsip yang mendasarinya:

1. **Virtualisasi.** View hanya membuat delegate untuk baris yang tampak (ditambah sedikit cadangan). Karena itu satu `ListView` bisa menangani model sangat besar. `Repeater` tidak berbuat demikian.
2. **Delegate tidak menyimpan keadaan.** Delegate bisa dihancurkan atau didaur ulang kapan saja. Semua keadaan yang harus bertahan (centang, nilai, terpilih) disimpan di model. Ini kelanjutan prinsip "satu sumber kebenaran" dari 7.1.
3. **View memiliki tata letak.** Posisi `x`/`y` delegate diatur view. Jangan mengikatnya sendiri.
4. **Kontrak eksplisit.** Delegate menyatakan data yang dibutuhkannya lewat `required property`. Kontrak itu dapat diperiksa alat (`qmllint`) sebelum aplikasi dijalankan.
5. **Perspektif keamanan.** Isi sel adalah antarmuka paling dekat dengan data tak tepercaya. Teks dari luar harus dirender sebagai teks polos, bukan HTML (lihat 7.2.7).

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **View** | Wadah penampil koleksi: `ListView`, `GridView`, `PathView`, `TableView`, `TreeView`. |
| **Delegate** | Cetakan visual satu unit data. View membuat satu instance per baris yang tampak. |
| **Viewport** | Jendela yang terlihat pengguna. |
| **Virtualisasi** | Hanya membuat delegate untuk bagian yang tampak (plus cadangan). |
| **`Flickable`** | Tipe dasar `ListView`/`GridView`/`TableView`. Memberi gulir dan lempar (`contentX`, `contentY`, `contentItem`). |
| **`contentItem`** | Item di dalam `Flickable` tempat semua delegate diletakkan. Itulah `parent` delegate. |
| **Properti terlampir (attached)** | Properti yang "ditempelkan" view ke root delegate, misalnya `ListView.isCurrentItem`, `ListView.view`. |
| **`required property`** | Properti yang wajib diisi dari luar. Dipakai delegate untuk menerima role model. |
| **`index`** | Nomor baris. Bernilai -1 jika baris sudah dihapus dari model. |
| **`modelData`** | Role tunggal untuk model tanpa role bernama (array nilai, integer). |
| **Item saat ini (current)** | Satu baris yang menjadi fokus navigasi: `currentIndex` dan `currentItem`. |
| **`highlight`** | Komponen penanda baris saat ini. Dikelola view. |
| **`section`** | Pengelompokan baris berurutan menurut sebuah role. |
| **Kolam daur ulang (pool)** | Penampungan delegate yang keluar dari viewport untuk dipakai ulang (`reuseItems`). |
| **`cacheBuffer`** | Cadangan delegate di luar viewport, dibuat asinkron. |
| **`ComponentBehavior: Bound`** | `pragma` yang mengikat komponen dalam (termasuk delegate) ke konteks aslinya. |
| **Context property** | Cara lama menyuntikkan role model ke delegate tanpa deklarasi. |
| **`ItemSelectionModel`** | Model yang menyimpan seleksi dan item saat ini (dipakai `TableView`). |

### 2.4 Peta visual

**Diagram A: virtualisasi (`ListView` dengan 5.000 baris)**

```
 MODEL (5000 baris)          VIEW (jendela 200 px)        YANG ADA DI MEMORI
 +----------------+
 |   0 ... 117    |   --- di atas jendela: tidak ada (atau di kolam daur ulang) ---
 |   118          |   +--- cacheBuffer (opsional) ---+  <- delegate cadangan (dibuat async)
 |   119          |   |  [ 119 ]                      |
 |   120  <-tampak|   |  [ 120 ] [ 121 ] [ 122 ] ...  |  <- delegate tampak
 |   121          |   |  [ 126 ]                      |
 |   122 ...      |   +--- cacheBuffer ---------------+
 |   127 ... 4999 |   --- di bawah jendela: belum dibuat ---
 +----------------+

 flick ke bawah: delegate 119 keluar jendela ->
     reuseItems = false : DIHANCURKAN, lalu dibuat baru untuk baris 127
     reuseItems = true  : masuk KOLAM DAUR ULANG, lalu dipakai ulang untuk baris 127
```

**Diagram B: siklus hidup delegate**

```
        dibuat (Component.onCompleted)
              |
              v
        +-> tampil <--------------------------------------+
        |     |                                           |
        |     | keluar dari viewport (+ cacheBuffer)      | ListView.onReused
        |     v                                           | (role model diperbarui,
        |  reuseItems=false -> dihancurkan                |  PROPERTI LAIN TETAP LAMA!)
        |                     (Component.onDestruction)   |
        |  reuseItems=true  -> masuk kolam ---------------+
        |                      (ListView.onPooled)
```

**Diagram C: memilih view**

```
Data berbentuk apa?
 |
 +-- satu dimensi, berderet lurus ........................ ListView
 +-- satu dimensi, berupa kisi ........................... GridView
 +-- satu dimensi, di lintasan melengkung / karusel ...... PathView
 +-- sedikit item (puluhan), tanpa gulir, ukuran tetap ... Repeater di Row/Column/Grid
 +-- tabel (baris x kolom) ............................... TableView
 +-- pohon ............................................... TreeView
 +-- isi = item visual jadi yang beragam ................. ObjectModel (7.1.3) + ListView
```

---

## 3. 7.2.1 `ListView` dan `GridView`

> Satu baris yang rapi adalah dasar bagi seribu baris yang lancar.

### 3.1 Sintaks dasar

**Contoh A: `ListView` dengan delegate modern**

```qml
pragma ComponentBehavior: Bound
import QtQuick

ListView {
    id: daftar
    width: 300; height: 200
    clip: true
    spacing: 4

    model: ListModel {
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh';  harga: 8000 }
        ListElement { nama: 'Susu'; harga: 12000 }
    }

    delegate: Rectangle {
        id: baris
        required property string nama
        required property int harga
        required property int index

        width: ListView.view.width
        height: 40
        color: index % 2 === 0 ? '#eeeeee' : '#dddddd'

        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 12
            text: baris.nama + ' — ' + baris.harga
        }
    }
}
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `pragma ComponentBehavior: Bound` | Arahan tingkat berkas: delegate terikat ke konteks aslinya. Dijelaskan di 7.2.4. |
| `import QtQuick` | Memuat `ListView`, `Rectangle`, `Text`. Modul model sudah ikut terimpor lewat QtQuick. |
| `ListView { ... }` | View berbentuk daftar. Turunan `Flickable`, jadi bisa digulir dan dilempar. |
| `width`/`height` | Ukuran viewport. Jika nol, view mungkin tidak memuat delegate sama sekali (V1). |
| `clip: true` | Memotong isi di luar view. View **tidak** memotong otomatis (V2). |
| `spacing: 4` | Jarak 4 piksel antarbaris. |
| `model: ListModel {...}` | Model inline dari 7.1. |
| `delegate: Rectangle {...}` | Cetakan satu baris. Qt membungkusnya otomatis dalam `Component`. |
| `required property string nama` | Kontrak: delegate menerima role `nama` bertipe string. |
| `required property int index` | Nomor baris, disediakan view. |
| `ListView.view.width` | Properti terlampir `view` menunjuk ListView pemilik. Aman dipakai dibanding `parent.width` (lihat di bawah). |
| `height: 40` | View menata baris berdasarkan ukuran **root delegate**. |
| `index % 2 === 0 ? ... : ...` | Operator sisa bagi. Menghasilkan warna selang-seling (zebra). |
| `Text {...}` | Anak delegate. `baris.nama` dikualifikasi dengan id agar jelas asalnya. |

**Mengapa `parent.width` dilarang?** Delegate biasanya berinduk `contentItem` milik view, tetapi induknya bisa berubah, bahkan menjadi `null`, tergantung apakah delegate sedang tampak. Karena itu mengikatnya ke `parent` tidak disarankan. Pakai `ListView.view.width` atau id view (`daftar.width`).

### 3.2 Properti utama `ListView`

| Properti | Fungsi | Default |
|---|---|---|
| `orientation` | `ListView.Vertical` / `ListView.Horizontal` | Vertical |
| `layoutDirection` | Arah horizontal (`Qt.LeftToRight`/`RightToLeft`) | LeftToRight |
| `verticalLayoutDirection` | `ListView.TopToBottom`/`BottomToTop` (pola aplikasi obrolan) | TopToBottom |
| `spacing` | Jarak antaritem | 0 |
| `snapMode` | `NoSnap` / `SnapToItem` / `SnapOneItem` (halaman demi halaman) | NoSnap |
| `keyNavigationWraps` | Navigasi tombol memutar dari ujung ke awal | `false` |
| `count` | Jumlah baris di model (bukan jumlah delegate yang dibuat) | |

### 3.3 `GridView`: kisi

```qml
import QtQuick

GridView {
    id: kisi
    width: 330; height: 220
    cellWidth: 110; cellHeight: 70
    clip: true

    model: 12                         // model integer: hanya ada index

    delegate: Item {
        id: sel
        required property int index
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            radius: 6
            color: '#4a90d9'
            Text { anchors.centerIn: parent; color: 'white'; text: 'Sel ' + sel.index }
        }
    }
}
```

**Perbedaan penting dengan `ListView`:** ukuran sel ditentukan oleh `cellWidth`/`cellHeight` (default 100x100). `GridView` **tidak** mengubah ukuran item berdasarkan root delegate (V8). Itu sebabnya delegate memakai `GridView.view.cellWidth`.

| Properti | Fungsi |
|---|---|
| `flow` | `GridView.FlowLeftToRight` (default, gulir vertikal) atau `FlowTopToBottom` (gulir horizontal) |
| `layoutDirection`, `verticalLayoutDirection` | Menentukan sudut awal tata letak |
| `snapMode` | `NoSnap` / `SnapToRow` / `SnapOneRow` |
| `moveCurrentIndexUp/Down/Left/Right()` | Navigasi dua dimensi |

### 3.4 Opsi lain untuk logika yang sama (menampilkan daftar)

| Opsi | Kapan dipakai |
|---|---|
| `ListView` + `delegate` | Standar: virtualisasi, navigasi, highlight, section |
| `Column` + `Repeater` | Sedikit item tetap, tanpa gulir |
| `Flickable` + `Column` + `Repeater` | Daftar pendek yang butuh gulir, tanpa virtualisasi |
| `ListView` + `ItemDelegate` (Qt Quick Controls) | Delegate bergaya aplikasi dengan hover/klik bawaan |

**Praktik terbaik:** simpan delegate di berkas komponen sendiri (misalnya `ProdukDelegate.qml`) dengan API `required property`. Jebakan: V1, V2, V3, V8.

---

## 4. 7.2.2 `PathView` dan `Repeater`

> Garis lurus melatih dasar, lintasan melengkung melatih imajinasi.

### 4.1 `PathView`: item di lintasan

`PathView` menempatkan delegate sepanjang `path` (garis, kurva). Cocok untuk karusel dan roda pilihan. Ia tidak menangani navigasi tombol otomatis, karena tombol yang tepat bergantung bentuk lintasan. Anda yang memanggil `incrementCurrentIndex()`/`decrementCurrentIndex()`.

```qml
import QtQuick

PathView {
    id: roda
    width: 320; height: 160
    clip: true
    focus: true

    model: ['Kopi', 'Teh', 'Susu', 'Cokelat', 'Jahe']
    pathItemCount: 5
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightRangeMode: PathView.StrictlyEnforceRange

    Keys.onLeftPressed: decrementCurrentIndex()
    Keys.onRightPressed: incrementCurrentIndex()

    path: Path {
        startX: 20; startY: 80
        PathAttribute { name: 'skala'; value: 0.6 }
        PathLine { x: 160; y: 80 }
        PathAttribute { name: 'skala'; value: 1.0 }
        PathLine { x: 300; y: 80 }
        PathAttribute { name: 'skala'; value: 0.6 }
    }

    delegate: Rectangle {
        id: kartu
        required property string modelData
        width: 90; height: 90
        radius: 10
        color: PathView.isCurrentItem ? '#e67e22' : '#95a5a6'
        scale: PathView.skala
        Text { anchors.centerIn: parent; text: kartu.modelData }
    }
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `model: [...]` | Array string. Delegate menerimanya sebagai `modelData`. |
| `pathItemCount: 5` | Jumlah item yang terlihat pada lintasan sekaligus. |
| `preferredHighlightBegin/End: 0.5` | Posisi sorotan sebagai pecahan 0..1 panjang lintasan. 0.5 berarti tengah. |
| `highlightRangeMode: PathView.StrictlyEnforceRange` | Item saat ini selalu berada di rentang sorotan. Ini default `PathView`. |
| `Keys.onLeftPressed:` | Handler tombol kiri. Memajukan atau memundurkan `currentIndex` (butuh `focus: true`). |
| `Path { startX; startY ... }` | Lintasan: titik awal lalu segmen (`PathLine`, `PathQuad`, `PathCubic`, ...). |
| `PathAttribute { name: 'skala'; value: ... }` | Nilai kustom di titik lintasan. Diinterpolasi di antara titik. |
| `PathView.skala` | Properti terlampir bernama sesuai `PathAttribute`. Dipakai untuk `scale`. |
| `PathView.isCurrentItem` | `true` untuk item saat ini. |

Hal lain yang perlu diketahui:

- Delegate harus punya ukuran eksplisit. View menata item berdasarkan ukuran root delegate.
- Mengganti model mereset `offset` dan `currentIndex` ke 0.
- `PathView.onPath` bernilai `false` untuk delegate yang ada tetapi sedang tidak di lintasan (jika `pathItemCount` diatur). Biasanya delegate itu disembunyikan: `visible: PathView.onPath`.
- `movementDirection` mengatur arah pergerakan saat `currentIndex` diatur langsung (`Shortest`, `Positive`, `Negative`).
- Amati sendiri apakah titik lintasan jatuh di pusat delegate. Ini latihan 3 di bagian akhir.

### 4.2 `Repeater`: pembuat item sederhana

`Repeater` membuat **satu delegate untuk setiap elemen model, seluruhnya, tanpa virtualisasi**. Ia dirancang bekerja bersama positioner (`Row`, `Column`, `Grid`).

```qml
import QtQuick

Row {
    spacing: 8
    Repeater {
        id: pengulang
        model: ['A', 'B', 'C']
        delegate: Rectangle {
            id: kotak
            required property string modelData
            width: 40; height: 40
            color: 'orange'
            Text { anchors.centerIn: parent; text: kotak.modelData }
        }
        onItemAdded: (index, item) => console.log('item', index, 'dibuat')
    }
}
```

Beberapa fakta tentang `Repeater`:

- `count` baca-saja. Untuk mengatur jumlah item, gunakan model integer (`model: 24`).
- `itemAt(i)` mengambil item ke-i.
- `onItemAdded`/`onItemRemoved` menandai item masuk dan keluar.
- Template boleh diberikan sebagai anak langsung (seperti contoh Modul 7.1) atau lewat `delegate:`.

**Bukti virtualisasi** (jalankan di terminal; urutan ukuran boleh berbeda antarmesin):

```qml
pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root
    width: 320; height: 200

    property int dibuatListView: 0
    property int dibuatRepeater: 0

    ListView {
        width: 150; height: 200; clip: true
        model: 3000
        delegate: Rectangle {
            id: a
            required property int index
            width: ListView.view.width; height: 30
            color: a.index % 2 ? '#dddddd' : '#eeeeee'
            Component.onCompleted: root.dibuatListView++
        }
    }

    Flickable {
        x: 170; width: 150; height: 200; clip: true
        contentHeight: kolom.height
        Column {
            id: kolom
            Repeater {
                model: 3000
                delegate: Rectangle {
                    id: b
                    required property int index
                    width: 150; height: 30
                    color: b.index % 2 ? '#dddddd' : '#eeeeee'
                    Component.onCompleted: root.dibuatRepeater++
                }
            }
        }
    }

    Timer {
        interval: 800; running: true
        onTriggered: {
            console.log('ListView membuat:', root.dibuatListView, 'delegate')
            console.log('Repeater membuat:', root.dibuatRepeater, 'delegate')
            Qt.quit()
        }
    }
}
```

**Hasil yang diharapkan:** `ListView` hanya membuat sedikit delegate, kira-kira puluhan tergantung tinggi viewport dan `cacheBuffer`. `Repeater` membuat **tepat 3000**. Inilah jawaban untuk "Cek pemahaman" 1.

**Opsi lain:** untuk karusel datar sederhana, `ListView` horizontal dengan `snapMode: ListView.SnapOneItem` jauh lebih ringan daripada `PathView`.

Jebakan: V1, V13.

---

## 5. 7.2.3 `TableView`

> Data tabel adalah daftar yang punya dua sumbu.

### 5.1 Karakter dasar

- `TableView` menampilkan data dua dimensi (baris x kolom) dan, seperti view lain, hanya memuat bagian yang tampak.
- Model **harus** berkolom banyak untuk memanfaatkannya: `TableModel` (7.1.6), atau model C++ turunan `QAbstractItemModel`/`QAbstractTableModel`. `ListModel` hanya mengisi kolom pertama.
- **`TableView` mendaur ulang delegate secara default.** Ini berbeda dari `ListView` dan `GridView`.
- Ia tidak punya header bawaan. Header dibuat dengan `HorizontalHeaderView` dan `VerticalHeaderView` dari Qt Quick Controls.

```qml
import QtQuick
import Qt.labs.qmlmodels

TableView {
    id: tabel
    width: 320; height: 160
    clip: true
    columnSpacing: 1
    rowSpacing: 1

    model: TableModel {
        TableModelColumn { display: 'nama' }
        TableModelColumn { display: 'harga' }
        rows: [
            { nama: 'Kopi', harga: 15000 },
            { nama: 'Teh',  harga: 8000 },
            { nama: 'Susu', harga: 12000 }
        ]
    }

    columnWidthProvider: function (kolom) { return kolom === 0 ? 160 : 100 }

    delegate: Rectangle {
        id: sel
        required property var display
        implicitWidth: 100
        implicitHeight: 36
        color: '#f0f0f0'
        Text { anchors.centerIn: parent; text: sel.display }
    }
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `Qt.labs.qmlmodels` | Modul tipe model eksperimental (`TableModel`). |
| `TableModelColumn { display: 'nama' }` | Kolom 0 membaca kunci `nama` dari tiap objek baris, dan menjadikannya role `display`. |
| `rows: [...]` | Data baris dalam bentuk array objek. |
| `columnWidthProvider: function (kolom)` | Fungsi yang dipanggil `TableView` untuk mengetahui lebar kolom. |
| `required property var display` | Delegate menerima role `display`. |
| `implicitWidth`/`implicitHeight` | Ukuran yang "diinginkan" delegate. **`TableView` mengabaikan `width`/`height` eksplisit** (V9). |

### 5.2 Menentukan ukuran baris dan kolom

Urutan keputusan lebar kolom adalah: `columnWidthProvider` (jika ada), lalu lebar eksplisit dari `setColumnWidth()`, lalu `implicitColumnWidth()` (terbesar di antara delegate yang termuat). Hal yang sama berlaku untuk tinggi baris. Beberapa catatan:

- Provider yang mengembalikan `0` menyembunyikan kolom/baris. Nilai negatif atau `undefined` berarti "hitung dari delegate".
- Jika nilai yang dikembalikan provider berubah untuk baris/kolom yang sedang tampak, panggil `forceLayout()` agar diterapkan.
- Lebar implisit hanya mempertimbangkan delegate yang sedang termuat, sehingga bisa berbeda tergantung posisi gulir. Untuk lebar yang konsisten, pakai provider atau samakan `implicitWidth`.
- Pengguna bisa mengubah ukuran sendiri bila `resizableColumns`/`resizableRows` bernilai `true` (sejak 6.5).

### 5.3 Seleksi, navigasi keyboard, dan edit

Tambahkan `ItemSelectionModel` agar `TableView` mengelola seleksi dan sel saat ini. Delegate yang ingin tahu keadaannya mendeklarasikan `required property bool selected` dan `current` (dan `editing` saat edit):

```qml
import QtQuick
import Qt.labs.qmlmodels
import QtQml.Models

TableView {
    id: tabel
    width: 320; height: 130
    clip: true
    focus: true
    selectionModel: ItemSelectionModel { }
    selectionBehavior: TableView.SelectRows

    model: TableModel {
        TableModelColumn { display: 'nama';  edit: 'nama' }
        TableModelColumn { display: 'harga'; edit: 'harga' }
        rows: [
            { nama: 'Kopi', harga: 15000 },
            { nama: 'Teh',  harga: 8000 }
        ]
    }

    delegate: Rectangle {
        id: sel
        required property bool selected
        required property bool current
        required property var display
        implicitWidth: 120; implicitHeight: 34
        color: selected ? '#a5d6ff' : '#f0f0f0'
        border.width: current ? 2 : 0

        Text { anchors.centerIn: parent; text: sel.display }

        TableView.editDelegate: TextField {
            anchors.fill: parent
            text: sel.display
            TableView.onCommit: sel.display = text
        }
    }
}
```

Perlu `import QtQuick.Controls` agar `TextField` tersedia. Beberapa aturan:

- `selected` dan `current` **harus** `required`, jika tidak diabaikan.
- `selectionBehavior` bisa `SelectCells` (default), `SelectRows`, `SelectColumns`, atau `SelectionDisabled`.
- Tanpa `ItemSelectionModel`, navigasi keyboard tidak aktif.
- Edit dipicu lewat `editTriggers` (default: ketuk ganda atau tombol Enter/Return). Model harus mengembalikan `Qt::ItemIsEditable` dari `flags()`. Edit dimulai juga dengan memanggil `edit(index)`.
- Penulisan balik di `TableView.onCommit`. Menekan Esc membatalkan tanpa memancarkan sinyal itu.

Header: pasangkan `HorizontalHeaderView { syncView: tabel }` sehingga lebar kolom dan gulir horizontalnya sinkron dengan tabel. Teks header berasal dari `headerData()` model sumber (model C++), atau diatur lewat `model` header. Periksa dokumentasi versi Qt Anda untuk detailnya.

**Opsi lain:** `TableViewDelegate` dari Qt Quick Controls sudah menyediakan tampilan `current`/`selected`/edit bergaya aplikasi. Jebakan: V9.

---

## 6. 7.2.4 Delegate dengan `required property`

> Kontrak yang jelas mencegah kejutan di tengah malam.

### 6.1 Cara data masuk ke delegate

| Cara | Sintaks | Status |
|---|---|---|
| **A. `required property` per role** | `required property string nama` | **Disarankan** |
| **B. Objek `model`** | `required property var model`, lalu `model.nama` | Baik untuk nama bentrok atau menulis balik |
| **C. Context property** | `text: nama` (tanpa deklarasi) | Lama; tidak terlihat alat dan tidak bekerja di mode `Bound` |
| **D. `modelData`** | `required property string modelData` | Untuk array nilai dan model satu role |

Aturan pencocokan: jika delegate punya `required property` bernama sama dengan sebuah role, mesin QML mengikatnya ke role itu. Jika ada `required property` apa pun, `model`, `index`, dan `modelData` **tidak otomatis tersedia**: Anda harus mendeklarasikannya juga bila ingin memakainya.

**Contoh A: delegate sebagai komponen berkas**

```qml
// ProdukDelegate.qml
import QtQuick

Rectangle {
    id: root
    required property string nama
    required property int harga
    required property int index

    signal dipilih(int indeks)

    implicitHeight: 40
    color: root.ListView.isCurrentItem ? '#ffd27f' : '#eeeeee'

    Text {
        anchors.verticalCenter: parent.verticalCenter
        x: 12
        text: root.nama + ' — ' + root.harga
        textFormat: Text.PlainText
    }
    TapHandler { onTapped: root.dipilih(root.index) }
}
```

```qml
// Main.qml
import QtQuick

ListView {
    id: daftar
    width: 300; height: 200
    clip: true
    model: ListModel {
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh';  harga: 8000 }
    }
    delegate: ProdukDelegate {
        width: ListView.view.width
        onDipilih: (indeks) => daftar.currentIndex = indeks
    }
}
```

Di sini delegate punya API yang jelas (properti dan sinyal), dan view yang memutuskan reaksi (Modul 5.1). `TapHandler` adalah handler input dari Modul 6.3. `MouseArea` memberi hasil sama.

**Contoh B: nama role bentrok**

```qml
delegate: Text {
    required property var model
    text: model.color            // role `color`, bukan properti color milik Text
    color: 'black'
}
```

Dokumentasi menyebut: bila nama role bentrok dengan properti delegate, kualifikasi dengan `model.` (dan deklarasikan `required property var model`). Solusi yang lebih bersih adalah nama role yang spesifik.

### 6.2 `pragma ComponentBehavior: Bound`

Pragma ini membatasi komponen dalam satu berkas agar hanya membuat objek di konteks aslinya. Ini membuat id dari komponen luar aman dipakai di delegate, dan alat dapat memeriksa tipenya. Konsekuensinya: delegate yang terikat konteks tidak mendapat konteks privat, sehingga data model hanya bisa masuk lewat `required property`, bukan context property. Dokumentasi struktur dokumen QML juga mencatat bahwa nilai bawaan pragma ini adalah `Unbound`, dengan rencana berubah menjadi `Bound` pada versi mendatang (catatan itu dari dokumentasi 6.7, periksa versi Anda). Karena itu membiasakan `Bound` dan `required property` dari sekarang adalah investasi yang aman. `qmllint` memberi peringatan *Unqualified access* untuk pola yang bermasalah, dan artikel Qt tentang pengompilasian QML ke C++ menjelaskan bahwa peringatan itu muncul ketika sebuah nama tidak ditemukan di lingkup terdekat, bukan id, dan bukan nama tipe.

### 6.3 Galat khas

| Pesan | Penyebab | Solusi |
|---|---|---|
| `Required property nama was not initialized` | Tak ada role bernama itu, atau namanya salah | Samakan nama dan tipe dengan role model (V5) |
| `ReferenceError: nama is not defined` | Memakai context property padahal ada `required property`, atau mode `Bound` | Deklarasikan `required property` (V6) |
| `model.nama` bernilai `undefined` | `model` tidak dideklarasikan sebagai `required property var model` | Tambahkan deklarasinya |

**Praktik terbaik:** satu delegate satu berkas, semua input lewat `required property`, semua keluaran lewat sinyal, dan `qmllint` bersih. Jebakan: V5, V6.

---

## 7. 7.2.5 `currentIndex` dan `highlight`

> Fokus yang jelas memudahkan pengguna menemukan arah.

`ListView`, `GridView`, dan `PathView` memiliki satu **item saat ini**:

- `currentIndex` (boleh diubah) dan `currentItem` (baca-saja). Mengatur `currentIndex = -1` menghapus sorotan dan membuat `currentItem` bernilai `null`.
- `ListView.isCurrentItem` (terlampir): benar untuk delegate saat ini.
- `highlight`: komponen penanda, geometri-nya dikelola view agar mengikuti item saat ini.
- Menyalakan navigasi keyboard butuh `focus: true` pada view.

```qml
import QtQuick

ListView {
    id: daftar
    width: 300; height: 200
    clip: true
    focus: true
    keyNavigationWraps: true
    highlightMoveDuration: 150

    model: ListModel {
        ListElement { nama: 'Kopi' }
        ListElement { nama: 'Teh' }
        ListElement { nama: 'Susu' }
        ListElement { nama: 'Cokelat' }
        ListElement { nama: 'Jahe' }
    }

    highlight: Rectangle { color: '#ffd27f'; radius: 4 }

    delegate: Item {
        id: baris
        required property string nama
        required property int index
        width: ListView.view.width
        height: 36

        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 12
            text: baris.nama
            font.bold: baris.ListView.isCurrentItem
        }
        MouseArea {
            anchors.fill: parent
            onClicked: baris.ListView.view.currentIndex = baris.index
        }
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_J) {
            incrementCurrentIndex(); event.accepted = true
        } else if (event.key === Qt.Key_K) {
            decrementCurrentIndex(); event.accepted = true
        } else if (event.key === Qt.Key_G) {
            currentIndex = (event.modifiers & Qt.ShiftModifier) ? count - 1 : 0
            event.accepted = true
        }
    }

    onCurrentIndexChanged: console.log('current =', currentIndex)
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `focus: true` | `ListView` adalah *focus scope* dan menerima tombol bila punya fokus. |
| `keyNavigationWraps: true` | Dari baris terakhir, tombol bawah memutar ke baris pertama. |
| `highlightMoveDuration: 150` | Sorotan bergeser dalam 150 ms. Default kecepatan 400 px/detik dan durasi -1 (ikut kecepatan). |
| `highlight: Rectangle {...}` | Komponen sorotan. Digambar di bawah delegate (z = 0). |
| `baris.ListView.isCurrentItem` | Dari **anak** delegate, properti terlampir harus dibaca lewat id root delegate. Hanya root yang boleh menulis `ListView.isCurrentItem` langsung. |
| `MouseArea { onClicked: ... currentIndex = index }` | View menangani gulir dan lempar tetapi **tidak** mengubah `currentIndex` saat delegate diklik (V10). |
| `Keys.onPressed: (event) => {...}` | Handler tombol umum. `event.accepted = true` menandakan tombol sudah ditangani. |
| `Qt.Key_J` / `Qt.Key_K` | Gaya vim: bawah dan atas. |
| `Qt.Key_G` + `Qt.ShiftModifier` | `g` ke awal, `G` (Shift+g) ke akhir. `&` adalah AND bit-demi-bit untuk memeriksa modifier. |
| `onCurrentIndexChanged:` | Handler perubahan properti. |

Navigasi panah atas/bawah sudah bawaan di `ListView` (`keyNavigationEnabled`, yang secara default mengikuti `interactive`). Jika Anda mengaturnya eksplisit, ia tidak lagi terikat ke `interactive`.

**Properti sorotan lain:**

| Properti | Fungsi |
|---|---|
| `highlightFollowsCurrentItem` | `true` (default): view menggerakkan sorotan. `false`: Anda yang menggerakkan, misalnya dengan `Behavior` + `SpringAnimation` |
| `highlightRangeMode`, `preferredHighlightBegin/End` | Menjaga item saat ini di rentang tertentu (misalnya selalu di tengah). Mode: `NoHighlightRange` (default), `ApplyRange`, `StrictlyEnforceRange` |
| `snapMode` | Tidak memengaruhi `currentIndex`. Pasangkan dengan `StrictlyEnforceRange` agar `currentIndex` mengikuti gulir |

**Opsi lain untuk "menandai baris aktif":**

| Opsi | Catatan |
|---|---|
| `highlight` bawaan | Bergerak halus, dikelola view |
| `color: ListView.isCurrentItem ? ... : ...` di delegate | Tanpa komponen tambahan, tanpa animasi gerak |
| Highlight kustom dengan `highlightFollowsCurrentItem: false` + `SpringAnimation` | Animasi pegas. Anda yang mengikatkan `y` ke `currentItem.y` |

Jebakan: V10.

---

## 8. 7.2.6 `cacheBuffer` dan `reuseItems`

> Kecepatan lahir dari mengukur, bukan menebak.

### 8.1 Fakta dari dokumentasi

- View membuat delegate **sesuai kebutuhan** dan boleh menghancurkannya kapan saja.
- **`cacheBuffer`**: jika lebih dari nol, view boleh mempertahankan delegate cadangan di luar viewport sebanyak yang muat dalam buffer. Delegate cadangan dibuat **asinkron** (bertahap di beberapa frame) dan tidak digambar. Nilai bawaannya bergantung platform dan biasanya lebih dari nol. Ia bukan buffer piksel, hanya jumlah delegate tambahan.
- `cacheBuffer` menunda masalah delegate lambat, ia **bukan** obatnya. Biayanya memori tambahan.
- `displayMarginBeginning/End` berbeda: untuk tata letak UI tertentu, bukan optimasi.
- **`reuseItems`**: delegate yang keluar viewport masuk ke kolam, lalu dipakai ulang. Default `false` pada `ListView`/`GridView`, dan **default aktif pada `TableView`**.
- Saat delegate didaur ulang, hanya properti dari model (termasuk `index` dan semua role) yang diperbarui. **Properti lain tetap bernilai lama** (V4).
- `currentItem` tidak pernah dimasukkan ke kolam.
- Sinyal terlampir `pooled` (masuk kolam) dan `reused` (diambil lagi) tersedia untuk menjeda timer dan animasi atau menyetel ulang keadaan.

### 8.2 Eksperimen terukur

```qml
pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root
    width: 220; height: 200

    property bool pakaiDaurUlang: true      // ubah true/false lalu bandingkan
    property int dibuat: 0
    property int dihancurkan: 0
    property int didaurUlang: 0

    ListView {
        id: lv
        anchors.fill: parent
        clip: true
        model: 5000
        reuseItems: root.pakaiDaurUlang

        delegate: Rectangle {
            id: baris
            required property int index
            width: ListView.view.width; height: 30
            color: baris.index % 2 ? '#dddddd' : '#eeeeee'
            Text { anchors.centerIn: parent; text: baris.index }

            Component.onCompleted: root.dibuat++
            Component.onDestruction: root.dihancurkan++
            ListView.onReused: root.didaurUlang++
        }
    }

    Timer {
        id: gulir
        interval: 16; repeat: true; running: true
        property int langkah: 0
        onTriggered: {
            lv.contentY += 30
            if (++langkah >= 200) {
                stop()
                console.log('reuseItems =', root.pakaiDaurUlang,
                            '| dibuat =', root.dibuat,
                            '| dihancurkan =', root.dihancurkan,
                            '| didaurUlang =', root.didaurUlang)
                Qt.quit()
            }
        }
    }
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `reuseItems: root.pakaiDaurUlang` | Mengaktifkan daur ulang sesuai saklar. |
| `Component.onCompleted` / `Component.onDestruction` | Penghitung pembuatan dan penghancuran delegate. |
| `ListView.onReused` | Penghitung daur ulang (hanya terpancar bila `reuseItems` aktif). |
| `Timer { repeat: true }` | Menggulir 30 piksel tiap 16 ms (sekitar 60 kali per detik), 200 langkah. |
| `lv.contentY += 30` | Menggulir secara programatik. **Hanya untuk eksperimen**: untuk berpindah ke indeks tertentu pakai `positionViewAtIndex()`. |

**Hasil yang diharapkan (kecenderungan, bukan angka pasti):** dengan `reuseItems: true`, jumlah `dibuat` kecil dan `didaurUlang` besar. Dengan `false`, `dibuat` dan `dihancurkan` sama-sama besar dan `didaurUlang` nol.

**Daur ulang tidak selalu aman.** Contoh klasik dari dokumentasi: `CheckDelegate` dengan properti `channelActivated` yang disimpan di delegate. Setelah digulir jauh, keadaannya hilang atau (jika didaur ulang) terbawa dari baris lama. Solusi: simpan keadaan di model, misalnya `checked: model.channelActivated` dan `onClicked: model.channelActivated = checked`.

**Menjeda animasi saat masuk kolam:**

```qml
ListView.onPooled: animasi.pause()
ListView.onReused: animasi.resume()
```

**Opsi tuning:**

| Pengaturan | Efek | Kapan |
|---|---|---|
| `reuseItems: true` | Mengurangi pembuatan/penghancuran | Delegate agak kompleks; pastikan tidak ada keadaan lokal |
| `cacheBuffer: N` | Delegate cadangan asinkron | Gulir cepat menampakkan "kedipan" |
| Delegate lebih ringan | Obat utama | Selalu (7.2.7) |

Jebakan: V4, V7.

---

## 9. 7.2.7 Delegate ringan

> Setiap objek di delegate dikalikan jumlah baris yang tampak.

Jumlah objek dan binding di delegate berpengaruh langsung pada kelancaran gulir. Prinsip-prinsipnya:

1. **Sesedikit mungkin objek.** Hapus pembungkus `Item` yang tak perlu. Satu `Rectangle` berisi satu `Text` lebih murah daripada lima lapis.
2. **Tunda bagian yang jarang dipakai** dengan `Loader` (disarankan dokumentasi).
3. **Hindari kerja berat di binding.** Hitung di model atau di C++, bukan di setiap delegate.
4. **Gambar:** `asynchronous: true` dan `sourceSize` seukuran tampilan, agar gambar besar tidak didekode penuh (Modul 4.3).
5. **Teks dari luar:** `textFormat: Text.PlainText`.
6. **Jeda animasi** pada delegate yang masuk kolam (`onPooled`).
7. **Ukuran bulat** (bilangan bulat) untuk menghindari penjajaran sub-piksel.
8. **Keadaan di model**, bukan di delegate.

**Contoh: rincian dimuat hanya untuk baris saat ini**

```qml
pragma ComponentBehavior: Bound
import QtQuick

ListView {
    id: daftar
    width: 300; height: 220
    clip: true
    focus: true

    model: ListModel {
        ListElement { nama: 'Kopi';  catatan: 'Biji arabika, sangrai medium.' }
        ListElement { nama: 'Teh';   catatan: 'Daun hijau, seduh 3 menit.' }
        ListElement { nama: 'Susu';  catatan: 'Pasteurisasi.' }
    }

    delegate: Item {
        id: baris
        required property string nama
        required property string catatan
        required property int index

        width: ListView.view.width
        height: baris.ListView.isCurrentItem ? 80 : 40

        Text {
            id: judul
            x: 12; y: 10
            text: baris.nama
            textFormat: Text.PlainText
        }
        Loader {
            x: 12; y: 36
            active: baris.ListView.isCurrentItem
            sourceComponent: Component {
                Text {
                    text: baris.catatan
                    textFormat: Text.PlainText
                    width: baris.width - 24
                    wrapMode: Text.Wrap
                }
            }
        }
        MouseArea { anchors.fill: parent; onClicked: daftar.currentIndex = baris.index }
    }
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `Loader { active: ... }` | Hanya memuat item di dalamnya bila `active` benar. Baris lain tidak membayar biayanya. |
| `sourceComponent: Component { ... }` | Komponen yang dimuat. Karena `Bound`, ia boleh memakai id `baris`. |
| `height: ... ? 80 : 40` | Baris saat ini lebih tinggi. View menata ulang sendiri. |
| `textFormat: Text.PlainText` | Teks diperlakukan polos (lihat di bawah). |

**Mengapa `PlainText` penting untuk keamanan?** `Text` secara default (`AutoText`) memeriksa apakah teks tampak seperti HTML. Jika data dari jaringan berisi markup, ia bisa dirender sebagai teks kaya (tautan, gambar). Untuk data tak tepercaya, selalu `Text.PlainText`.

**Alat ukur dari terminal** (variabel lingkungan scene graph yang umum dikenal; ketersediaannya bergantung backend grafis, jadi uji di mesin Anda):

```bash
QSG_RENDER_TIMING=1 qml latihan72.qml      # cetak waktu render per frame
QSG_VISUALIZE=overdraw qml latihan72.qml   # visualisasi lapisan yang saling menimpa
```

Gunakan nama biner `qml` sesuai hasil `pacman -Ql qt6-declarative` (lihat bagian 10.3).

Jebakan: V4, V7, V14.

---

## 10. 7.2.8 (TAMBAHAN) Dekorasi view

> Detail kecil yang rapi membedakan prototipe dari produk.

View dapat dihias dengan `header`, `footer`, dan `section`. Semuanya adalah `Component`.

```qml
import QtQuick
import QtQuick.Controls

ListView {
    id: daftar
    width: 280; height: 240
    clip: true
    ScrollBar.vertical: ScrollBar { }

    model: ListModel {
        ListElement { nama: 'Alice';  tim: 'Crypto' }
        ListElement { nama: 'Bob';    tim: 'Crypto' }
        ListElement { nama: 'Jane';   tim: 'QA' }
        ListElement { nama: 'Victor'; tim: 'QA' }
        ListElement { nama: 'Wendy';  tim: 'Grafis' }
    }

    header: Rectangle {
        width: ListView.view.width; height: 32
        color: '#2c3e50'
        Text { anchors.centerIn: parent; color: 'white'; text: 'Daftar Tim' }
    }

    delegate: Text {
        required property string nama
        text: nama
        font.pixelSize: 18
        leftPadding: 12
    }

    section.property: 'tim'
    section.criteria: ViewSection.FullString
    section.labelPositioning: ViewSection.CurrentLabelAtStart
    section.delegate: Rectangle {
        id: judulBagian
        required property string section
        width: ListView.view.width
        height: 28
        color: '#b0dfb0'
        Text { anchors.verticalCenter: parent.verticalCenter; x: 8; font.bold: true; text: judulBagian.section }
    }
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `ScrollBar.vertical: ScrollBar { }` | Scrollbar terlampir dari Qt Quick Controls. |
| `header: Rectangle {...}` | Komponen di awal daftar. Ikut bergulir (`InlineHeader`, default). |
| `headerPositioning` | `InlineHeader`, `OverlayHeader` (menempel di awal view), `PullBackHeader`. Untuk `Overlay`, beri `z` lebih tinggi dari delegate agar tak tertutup. |
| `section.property: 'tim'` | Role yang menjadi dasar pengelompokan. |
| `section.criteria` | `ViewSection.FullString` (default) atau `FirstCharacter` (huruf pertama, untuk buku alamat). |
| `section.labelPositioning` | `InlineLabels` (default), `CurrentLabelAtStart` (label bagian saat ini menempel), `NextLabelAtEnd` (berimplikasi kinerja karena view harus memindai ke depan). |
| `required property string section` | Delegate bagian menerima judul bagian lewat properti bernama `section`. |

**Penting:** `section` **tidak** mengurutkan model. Jika model tak terurut per bagian, tiap pergantian nilai akan membuat judul baru, sehingga satu bagian bisa muncul berulang (V11). Urutkan modelnya, misalnya dengan proxy (7.1.5).

Z-order bawaan: delegate 1, header 1, footer 1, section delegate 2, highlight 0. Nilai ini hanya berlaku jika `z` adalah 0.

---

## 11. 7.2.9 (TAMBAHAN) Transisi dan siklus hidup delegate

> Perubahan yang bergerak lebih mudah dipahami mata.

View punya properti `Transition` untuk menganimasikan perubahan model: `add`, `remove`, `move`, `populate`, serta `displaced` (item yang tergeser). Ada pula varian spesifik `addDisplaced`, `removeDisplaced`, `moveDisplaced`.

```qml
import QtQuick

ListView {
    id: lv
    width: 260; height: 220
    clip: true
    focus: true
    spacing: 4

    property int nomor: 3

    model: ListModel {
        id: data
        ListElement { judul: 'Tugas 1' }
        ListElement { judul: 'Tugas 2' }
        ListElement { judul: 'Tugas 3' }
    }

    delegate: Rectangle {
        id: kartu
        required property string judul
        width: ListView.view.width; height: 36
        radius: 4
        color: kartu.ListView.isCurrentItem ? '#ffd27f' : '#e6e6e6'
        Text { x: 10; anchors.verticalCenter: parent.verticalCenter; text: kartu.judul }
    }

    add: Transition {
        NumberAnimation { property: 'opacity'; from: 0; to: 1; duration: 250 }
    }
    remove: Transition {
        NumberAnimation { property: 'opacity'; to: 0; duration: 200 }
    }
    displaced: Transition {
        NumberAnimation { properties: 'x,y'; duration: 250; easing.type: Easing.OutCubic }
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_A) {
            lv.nomor++
            data.insert(Math.max(lv.currentIndex, 0), { judul: 'Tugas ' + lv.nomor })
            event.accepted = true
        } else if (event.key === Qt.Key_D && lv.currentIndex >= 0) {
            data.remove(lv.currentIndex)
            event.accepted = true
        }
    }
}
```

**Cara pakai:** jalankan, tekan `a` untuk menyisip baris di posisi saat ini dan `d` untuk menghapus baris saat ini. Ingat bahwa `ListView` secara default menunjuk baris 0 sebagai `currentIndex`.

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `add: Transition {...}` | Berjalan untuk item yang baru ditambahkan (bukan untuk populasi awal). |
| `NumberAnimation { property: 'opacity'; from: 0; to: 1 }` | Memudarkan masuk. Properti target menyimpan nilai akhir (`1`) sebagai nilai awal delegate. |
| `remove: Transition {...}` | Memudarkan keluar. |
| `displaced: Transition {...}` | Menganimasikan item yang bergeser akibat tambah, pindah, atau hapus. |
| `data.insert(Math.max(...), {...})` | Dari 7.1, dengan batas bawah 0 agar aman bila model kosong. |

**Aturan dari dokumentasi:**

- Transisi `add` **tidak boleh menganimasikan tinggi** item baru, karena item di bawahnya akan salah letak. Animasikan `opacity`, `x`, `y`, `scale`.
- Transisi `populate` hanya berlaku untuk pengisian awal atau model yang berganti total (termasuk reset). Jangan mengandalkannya untuk menginisialisasi properti delegate.
- Saat transisi `remove` berjalan, **item sudah tidak ada di model**: data role baris itu tak lagi valid.
- Mengatur `ListView.delayRemove: true` menunda penghancuran delegate sampai animasi selesai.

**Alternatif: animasi hapus lewat sinyal terlampir `onRemove`**

```qml
delegate: Rectangle {
    id: kartu
    ...
    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: kartu; property: 'ListView.delayRemove'; value: true }
        NumberAnimation { target: kartu; property: 'scale'; to: 0; duration: 200; easing.type: Easing.InQuad }
        PropertyAction { target: kartu; property: 'ListView.delayRemove'; value: false }
    }
}
```

**Opsi lain:** tanpa transisi sama sekali (UI instan), `Behavior on y` di delegate (kurang disarankan karena berbenturan dengan tata letak view), atau transisi `Transition` dengan `ParallelAnimation` untuk kombinasi efek. Jebakan: V15, V16.

---

## 12. 7.2.10 (TAMBAHAN) Menulis data dari delegate

> Siapa yang boleh mengubah data menentukan seberapa mudah mengauditnya.

Properti `delegateModelAccess` ada pada `ListView`, `GridView`, dan `TableView` **sejak Qt 6.10**. Nilainya:

| Nilai | Arti |
|---|---|
| `DelegateModel.ReadOnly` | Delegate tidak boleh menulis model lewat jalur apa pun |
| `DelegateModel.ReadWrite` | Boleh menulis lewat context property, objek `model`, **dan required property** |
| `DelegateModel.Qt5ReadWrite` | **Default.** Lewat objek `model` dan context property, **tidak** lewat required property |

Dengan default, mengisi `required property` hanya mengubah nilai lokal dan memutus ikatan ke model. Pada `ReadWrite`, nilai itu merambat ke model tanpa memutus ikatan.

```qml
import QtQuick
import QtQml.Models

ListView {
    id: daftar
    width: 300; height: 120
    clip: true
    delegateModelAccess: DelegateModel.ReadWrite     // Qt 6.10+

    model: ListModel {
        ListElement { nama: 'Kopi'; harga: 15000 }
        ListElement { nama: 'Teh';  harga: 8000 }
    }

    delegate: Row {
        id: baris
        required property string nama
        required property int harga
        spacing: 12

        Text { text: baris.nama; width: 100 }
        TextInput {
            text: baris.harga
            inputMethodHints: Qt.ImhDigitsOnly
            onEditingFinished: {
                const v = parseInt(text)
                if (!isNaN(v) && v >= 0)
                    baris.harga = v          // merambat ke model (ReadWrite)
                else
                    text = baris.harga       // tolak masukan tidak valid
            }
        }
    }
}
```

**Aturan penting dari dokumentasi:** hanya model yang punya identitas yang ikut berubah saat ditulis lewat delegate, yaitu `ListModel`, turunan `QAbstractItemModel`, dan objek atau daftar objek QML. **Array JavaScript dan angka disalin ke view**, sehingga penulisan lewat delegate tidak mengubah sumbernya. Model C++ harus mengimplementasikan `setData()` agar menerima penulisan.

**Opsi untuk mengubah data dari delegate, dari paling longgar ke paling terkendali:**

| Opsi | Catatan |
|---|---|
| `required property var model` lalu `model.harga = v` | Jalur bawaan di default `Qt5ReadWrite` |
| `delegateModelAccess: ReadWrite` + penulisan ke `required property` | Ringkas; butuh Qt 6.10+ |
| Delegate memanggil `data.setProperty(index, 'harga', v)` lewat id model | Eksplisit, tetapi delegate "tahu" model |
| **Delegate memancarkan sinyal `hargaDiubah(index, v)`**, pemilik model yang menulis | **Disarankan untuk aplikasi serius**: satu pintu mutasi, validasi di satu tempat (selaras dengan "gerbang" 7.1) |
| `ReadOnly` | Tampilan murni, paling aman |

Jebakan: V12.

---

## 13. 7.2.11 (TAMBAHAN) Mengendalikan view lewat kode dan delegate beragam

> Kontrol penuh berarti tahu cara memerintah dan cara menunggu.

### 13.1 Metode kendali

| Metode | Fungsi | Catatan |
|---|---|---|
| `positionViewAtIndex(i, mode)` | Menempatkan indeks `i`. Mode: `Beginning`, `Center`, `End`, `Visible`, `Contain`, `SnapPosition` | Cara yang benar. Jangan mengatur `contentY` |
| `positionViewAtBeginning()` / `positionViewAtEnd()` | Awal dan akhir (memperhitungkan header/footer) | |
| `itemAtIndex(i)` | Delegate untuk indeks `i`, atau `null` | **Jangan disimpan**, bisa menjadi `null` kapan saja |
| `indexAt(x, y)` / `itemAt(x, y)` | Dengan koordinat konten (`contentItem`) | Petakan posisi MouseArea dulu |
| `forceLayout()` | Memaksa view menyelaraskan perubahan model sekarang juga | Perubahan model dibatch sekali per frame |
| `incrementCurrentIndex()` / `decrementCurrentIndex()` | Navigasi | |

Semua metode ini hanya dipanggil **setelah komponen selesai** (`Component.onCompleted`).

**Contoh: gulir otomatis ke entri terbaru (log)**

```qml
Connections {
    target: data               // ListModel dari contoh sebelumnya
    function onRowsInserted() {
        lv.forceLayout()       // pastikan layout menyusul perubahan model
        lv.positionViewAtEnd()
    }
}
```

Untuk obrolan atau log yang tumbuh dari bawah, `verticalLayoutDirection: ListView.BottomToTop` sering lebih alami.

### 13.2 Delegate beragam

**Opsi A (stabil): `Loader` dengan pilihan komponen**

```qml
pragma ComponentBehavior: Bound
import QtQuick

ListView {
    id: umpan
    width: 300; height: 200
    clip: true

    model: ListModel {
        ListElement { jenis: 'judul'; isi: 'Berita Hari Ini' }
        ListElement { jenis: 'biasa'; isi: 'Qt 6 terus menambah fitur model dan view.' }
    }

    delegate: Loader {
        id: pemuat
        required property string jenis
        required property string isi
        width: ListView.view.width
        sourceComponent: jenis === 'judul' ? kompJudul : kompBiasa

        Component {
            id: kompJudul
            Text { text: pemuat.isi; font.pixelSize: 22; font.bold: true; textFormat: Text.PlainText }
        }
        Component {
            id: kompBiasa
            Text { text: pemuat.isi; font.pixelSize: 14; wrapMode: Text.Wrap; width: pemuat.width; textFormat: Text.PlainText }
        }
    }
}
```

**Opsi B (eksperimental): `DelegateChooser`** dari `Qt.labs.qmlmodels`. Ia memilih delegate berdasarkan nilai sebuah role:

```qml
import Qt.labs.qmlmodels

DelegateChooser {
    id: pemilih
    role: 'jenis'
    DelegateChoice { roleValue: 'judul'; delegate: Text { /* ... */ } }
    DelegateChoice { roleValue: 'biasa'; delegate: Text { /* ... */ } }
}
// ListView { delegate: pemilih }
```

Modul `Qt.labs.*` bersifat eksperimental dan tanpa jaminan kompatibilitas, jadi uji pada versi Qt Anda sebelum bergantung padanya.

**Opsi C:** satu delegate dengan beberapa anak yang `visible` bergantian. Mudah, tetapi semua anak tetap dibuat (lebih boros).

---

## 14. Penutup modul

### 14.1 Hubungan dengan modul lain

- **Prasyarat:** 7.1 (model, role, sinyal), 5.1 (komponen sebagai API), 6.1-6.2 (`Transition`, `NumberAnimation`), 6.3 (`Keys`, fokus), 3.x (properti, binding, properti terlampir).
- **7.3 Objek Dinamis:** `Loader` (dipakai di 7.2.7 dan 7.2.11) dibahas penuh; `Instantiator` memakai model seperti view tetapi tanpa tata letak.
- **7.4 Data Asinkron:** hasil jaringan masuk ke model lewat gerbang validasi, lalu view menampilkannya.
- **Modul 10.5:** model C++ yang dipakai `ListView`/`TableView` (`roleNames`, `setData`, `flags`).
- **Fase Qt Quick Controls:** `ItemDelegate`, `TableViewDelegate`, `HorizontalHeaderView`, `ScrollBar`, `SelectionRectangle`.
- **Fase 13 (keamanan):** `Text.PlainText`, batas ukuran data, validasi di gerbang.

### 14.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| V1 | Daftar kosong atau delegate tidak muncul | Ukuran view nol (tinggi/lebar 0, anchors tak lengkap) | Beri `width`/`height` atau anchors yang lengkap |
| V2 | Isi meluber keluar view | View tidak memotong otomatis | `clip: true` |
| V3 | Lebar delegate salah atau berubah-ubah | Memakai `parent.width` | `ListView.view.width` atau id view |
| V4 | Keadaan (centang, teks) hilang atau pindah ke baris lain saat gulir | Keadaan disimpan di delegate yang dihancurkan atau didaur ulang | Simpan keadaan di model; setel ulang di `onReused` jika terpaksa |
| V5 | `Required property X was not initialized` | Nama atau tipe `required property` tak cocok dengan role | Samakan dengan role (cek `roleNames`) |
| V6 | `ReferenceError`, atau `model.nama` undefined | Context property di mode `Bound`, atau `model` tak dideklarasikan | `required property` per role, atau `required property var model` |
| V7 | Gulir patah-patah | Delegate berat | Ringankan (7.2.7), `reuseItems`, `cacheBuffer` sebagai pendukung |
| V8 | Ukuran item `GridView` tak sesuai delegate | `GridView` memakai `cellWidth`/`cellHeight` | Atur ukuran sel pada view |
| V9 | Sel `TableView` menumpuk atau berukuran nol | Tidak ada `implicitWidth`/`implicitHeight` (ukuran eksplisit diabaikan) | Set ukuran implisit atau pakai provider |
| V10 | Klik tidak memilih baris | View tidak menangani sentuhan delegate | `MouseArea`/`TapHandler` yang mengatur `currentIndex` |
| V11 | Judul `section` muncul berulang | Model tak terurut menurut role section | Urutkan model (proxy, 7.1.5) |
| V12 | Menulis ke `required property` tak mengubah model | `delegateModelAccess` default `Qt5ReadWrite`; atau sumbernya array JS (disalin) | `ReadWrite` (6.10+), lewat objek `model`, atau sinyal ke pemilik model |
| V13 | `Repeater` lambat untuk data banyak | Tidak ada virtualisasi | Pakai `ListView` |
| V14 | Teks data tampil sebagai HTML atau menarik sumber daya | `Text` default `AutoText` | `textFormat: Text.PlainText` |
| V15 | Item di bawah salah letak saat animasi `add` | Menganimasikan `height` | Animasikan `opacity`/`x`/`y`/`scale` |
| V16 | Data baris tak valid di transisi `remove` | Item sudah keluar dari model | Jangan bergantung pada data model saat itu |

### 14.3 Latihan 15 menit

**Persiapan terminal (Arch).** Cari nama biner QML di sistem Anda:

```bash
pacman -Q qt6-declarative                                       # versi terpasang
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmllint|qmlformat)'   # nama biner
```

Pakai nama yang muncul, misalnya jika `qml`:

```bash
qml latihan72.qml                                        # jalankan dengan jendela (untuk tombol dan klik)
QT_QPA_PLATFORM=offscreen qml latihan72.qml              # tanpa jendela (untuk skrip uji yang mencetak log)
QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software qml latihan72.qml   # bila konteks grafis gagal dibuat
qmllint latihan72.qml                                    # periksa gaya dan kesalahan statis
qmlformat -i latihan72.qml                               # rapikan format di tempat
```

Kegunaan masing-masing: `qml` menjalankan berkas. `QT_QPA_PLATFORM=offscreen` memilih platform tanpa layar. `QT_QUICK_BACKEND=software` memakai perender perangkat lunak. `qmllint` memeriksa kode. `qmlformat` menyeragamkan format.

**Langkah:**

1. Salin contoh 7.2.5 (`highlight` dan `Keys`) ke `latihan72.qml` dan jalankan dengan jendela. Coba `j`, `k`, `g`, `G`, panah, dan klik.
2. Tambahkan `keyNavigationEnabled: false`, lalu ganti navigasi bawaan dengan `Keys.onUpPressed: decrementCurrentIndex()` dan `Keys.onDownPressed: incrementCurrentIndex()`. Cocokkan dengan tugas kurikulum.
3. Salin contoh `PathView` (7.2.2). Amati apakah titik lintasan jatuh di pusat delegate. Coba ubah `y` pada `Path` dan perhatikan hasilnya.
4. Jalankan eksperimen `reuseItems` (7.2.6) dengan `pakaiDaurUlang` bernilai `true` lalu `false`, dan bandingkan tiga angkanya.
5. Jalankan `qmllint` pada semua berkas. Perbaiki setiap peringatan, terutama *Unqualified access*.

**Tantangan 10 menit:** pada contoh 7.2.9, tambahkan `Alt+j` dan `Alt+k` yang menukar baris saat ini dengan tetangganya menggunakan `data.move(...)`, lalu pastikan `currentIndex` mengikuti dan transisi `displaced` terlihat. Periksa `event.modifiers & Qt.AltModifier`.

### 14.4 Cek pemahaman

1. Mengapa `ListView` dapat menangani ribuan baris sedangkan `Repeater` tidak?
2. Mengapa `parent.width` tidak disarankan di dalam delegate?
3. Apa yang terjadi pada keadaan lokal sebuah delegate saat Anda menggulir jauh?
4. Mengapa delegate modern memakai `required property` dibanding `model.nama`?
5. Bagaimana membuat klik pada baris mengubah `currentIndex`?
6. Mengapa `GridView` tidak mengikuti ukuran root delegate, dan apa gantinya?
7. Apa beda default `reuseItems` pada `ListView` dan `TableView`?

**Jawaban singkat:**

1. `ListView` membuat delegate hanya untuk baris yang tampak (plus cadangan) dan menghancurkan atau mendaur ulang sisanya. `Repeater` membuat satu delegate untuk setiap elemen model dan tak pernah memvirtualisasi.
2. `parent` delegate adalah `contentItem` milik view, tetapi bisa berubah dan kadang `null`. Pakai `ListView.view.width` atau id view.
3. Delegate bisa dihancurkan atau, dengan `reuseItems`, dipakai ulang untuk baris lain. Keadaannya hilang atau bocor ke baris lain. Simpan keadaan di model.
4. Kontraknya eksplisit dan dapat diperiksa alat, bekerja dengan `pragma ComponentBehavior: Bound`, dan tidak bergantung pada context property yang tidak terlihat.
5. View tidak menangani sentuhan delegate, jadi pasang `MouseArea` atau `TapHandler` yang mengatur `view.currentIndex = index`.
6. `GridView` memakai `cellWidth`/`cellHeight` untuk menentukan ukuran sel. Atur kedua properti itu pada view.
7. `ListView` (dan `GridView`): `false`. `TableView`: mendaur ulang secara default.

### 14.5 Referensi

Tautan `doc.qt.io` di bawah ini muncul pada halaman dokumentasi Qt 6.12 yang saya baca saat menyusun materi ini. Blog Qt dan halaman struktur dokumen ditemukan lewat pencarian.

- [Models and Views in Qt Quick](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html)
- [ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html) · [GridView](https://doc.qt.io/qt-6/qml-qtquick-gridview.html) · [PathView](https://doc.qt.io/qt-6/qml-qtquick-pathview.html) · [TableView](https://doc.qt.io/qt-6/qml-qtquick-tableview.html) · [Repeater](https://doc.qt.io/qt-6/qml-qtquick-repeater.html)
- [ViewTransition](https://doc.qt.io/qt-6/qml-qtquick-viewtransition.html) · [Qt Quick Examples: Views](https://doc.qt.io/qt-6/qtquick-views-example.html)
- [Structure of a QML Document (pragma ComponentBehavior)](https://doc.qt.io/qt-6/qtqml-documents-structure.html)
- [QML Coding Conventions: Required Properties](https://doc.qt.io/qt-6/qml-codingconventions.html#required-properties)
- [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html)
- [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html) · [DelegateModel](https://doc.qt.io/qt-6/qml-qtqml-models-delegatemodel.html) · [ItemSelectionModel](https://doc.qt.io/qt-6/qml-qtqml-models-itemselectionmodel.html)
- [TableViewDelegate](https://doc.qt.io/qt-6/qml-qtquick-controls-tableviewdelegate.html) · [HorizontalHeaderView](https://doc.qt.io/qt-6/qml-qtquick-controls-horizontalheaderview.html) · [ScrollBar](https://doc.qt.io/qt-6/qml-qtquick-controls-scrollbar.html) · [SelectionRectangle](https://doc.qt.io/qt-6/qml-qtquick-controls-selectionrectangle.html)
- [Compiling QML to C++: Fixing unqualified access (Qt Blog)](https://www.qt.io/blog/compiling-qml-to-c-fixing-unqualfied-access)
- Komunitas: [Qt Forum](https://forum.qt.io/) · [Qt Academy](https://www.qt.io/academy)

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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

