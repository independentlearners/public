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

# Modul 7.3: Objek Dinamis (`Loader`, `Component`, dan `Instantiator`)

*Fase 7: Model, View, dan Arsitektur Data*

## Daftar isi modul ini

1. Audit singkat sebelum materi
2. Fondasi: peran modul, konsep dan filosofi, terminologi, peta visual
3. **7.3.1** `Loader`
4. **7.3.2** `Component.createObject()`
5. **7.3.3** `Qt.createComponent()` dan status loading
6. **7.3.4** `Instantiator`
7. **7.3.5** `destroy()` dan kepemilikan
8. **7.3.6** Risiko `Qt.createQmlObject`
9. **7.3.7** (TAMBAHAN) Inkubasi asinkron: `incubateObject()`
10. **7.3.8** (TAMBAHAN) Pola pabrik objek yang aman
11. Penutup: hubungan modul, tabel kesalahan, latihan, cek pemahaman, referensi

---

## 1. Audit singkat

Saya membaca bagian 7.3 terhadap dokumentasi Qt 6.12 (`Dynamic QML Object Creation`, `Loader`, `Component`, `Instantiator`, `Handling Untrusted Data`).

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Prasyarat: 3.4 (scope, id, konteks), 5.1 (`Component`), 6.3 (fokus), 7.1.3 (`ObjectModel`), 7.2 (`Loader` dalam delegate) | Aman, tidak ada loncatan | Tidak ada |
| 2 | Contoh kurikulum | Valid | Diverifikasi. `Loader` di akhir contoh sengaja tidak aktif, jadi hanya memperlihatkan sifat. Dibahas penuh di 7.3.1 |
| 3 | "Parent vs owner" | Benar tetapi tipis | Dilengkapi di 7.3.5: tanpa parent, umur objek ditentukan referensi JavaScript (GC) |
| 4 | Status `Component` (`Null`/`Ready`/`Loading`/`Error`), `errorString()` | Kurang | Dilengkapi di 7.3.3 |
| 5 | `Loader`: aturan ukuran, fokus, sinyal dari objek termuat, `setSource`, konteks dalam delegate | Kurang | Dilengkapi di 7.3.1 |
| 6 | `Instantiator`: variabel `index`, induk visual, `objectAdded`/`objectRemoved` | Tipis | Dilengkapi di 7.3.4 |
| 7 | `incubateObject()` (pembuatan asinkron) | Belum ada | TAMBAHAN 7.3.7 |
| 8 | Keamanan: hanya satu peringatan | Perlu diperluas | 7.3.6 dan TAMBAHAN 7.3.8 (daftar putih, batas jumlah, pembersihan) |
| 9 | `ObjectModel` + `createObject()` (janji dari 7.1.3) | Tertunda | Dipenuhi di 7.3.8 |
| 10 | Catatan build statis untuk `createQmlObject` | Belum ada | 7.3.6 |

**Pembaruan daftar isi kurikulum 7.3:** 7.3.1 sampai 7.3.6 tetap, ditambah **7.3.7** (Inkubasi asinkron) dan **7.3.8** (Pola pabrik objek yang aman).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Sejauh ini hampir semua objek QML dideklarasikan **statis**: ditulis di berkas dan dibuat saat aplikasi dimulai. Modul ini mengajarkan membuat objek **saat runtime**: menunda pembuatan sampai diperlukan, membuatnya sebagai reaksi pada klik atau data, dan menghancurkannya dengan benar. Dampaknya nyata: waktu start yang lebih cepat, memori yang lebih hemat, dan antarmuka yang bisa menyesuaikan diri.

Modul ini juga **gerbang menuju keamanan Fase 13**. Kemampuan membuat objek dari teks atau URL adalah kemampuan mengeksekusi kode, jadi di sinilah kebiasaan "daftar putih dan validasi" harus mulai tertanam.

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Pembuatan objek dinamis seperti **memesan kue dari cetakan**. Cetakan (`Component`) disiapkan sekali. Kue (objek) dipesan sesuai kebutuhan, tidak disiapkan semuanya sebelumnya. Tetapi ada dua tanggung jawab. Pertama, kue harus **ditaruh di meja** (diberi parent), kalau tidak, tak ada yang melihatnya. Kedua, kue yang basi harus **dibuang** (`destroy()`), kalau tidak, dapur penuh.

Prinsip yang mendasarinya:

1. **Cetakan terpisah dari kue.** `Component` adalah definisi. `createObject()` dan `Loader` adalah tindakan membuat instance.
2. **Setiap objek harus punya pemilik yang jelas.** Pemilik menentukan siapa yang berhak dan wajib menghancurkannya.
3. **Alat yang tepat untuk tugas yang tepat.** `Loader` untuk satu bagian UI. `Instantiator` untuk banyak objek dari model. `createObject()` untuk pembuatan imperatif. `createQmlObject()` hampir tak pernah.
4. **Perspektif keamanan.** Dokumentasi Qt menegaskan bahwa QML tidak memiliki konsep domain privasi terpisah: kode apa pun yang dimuat, dari jarak jauh maupun lokal, dapat mengakses semua data dalam lingkupnya. Karena itu pembuatan dinamis tidak boleh digerakkan oleh data tak tepercaya.
5. **Modularitas.** Komponen yang bisa dibuat dinamis harus punya API yang jelas (`required property`, sinyal), selaras dengan Modul 5.1.

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **Pembuatan dinamis** | Membuat objek QML saat runtime, bukan lewat deklarasi statis. |
| **`Component`** | Definisi (cetakan) yang bisa diinstansiasi. Bisa inline atau dari berkas. |
| **`createObject(parent, props)`** | Metode `Component` untuk membuat satu instance. |
| **`Qt.createComponent(url)`** | Membuat `Component` dari URL berkas QML. |
| **`Qt.createQmlObject(teks, parent, path)`** | Membuat objek dari **string** QML. Lambat dan berbahaya. |
| **`Loader`** | Item yang memuat dan membuang subpohon QML sesuai kebutuhan. |
| **`Instantiator`** | Pembuat banyak objek dari model, tanpa tata letak (`QtQml.Models`). |
| **`status`** | Keadaan pemuatan: `Null`, `Ready`, `Loading`, `Error`. |
| **Inkubator** | Objek yang membuat instance secara asinkron (`incubateObject`). |
| **Parent** | Induk objek (QObject) dan, untuk `Item`, induk visual. |
| **Pemilik (owner)** | Pihak yang menentukan umur objek: parent, atau referensi JavaScript bila tanpa parent. |
| **Creation context** | Konteks (id dan properti) tempat komponen dideklarasikan. Menentukan nama apa yang terlihat oleh objek hasil buatan. |
| **`destroy(delay)`** | Menjadwalkan penghancuran objek dinamis. Hanya untuk objek yang dibuat secara dinamis. |
| **GC (garbage collector)** | Pembersih memori JavaScript. Dapat menghancurkan objek tanpa parent yang tak lagi dirujuk. |
| **Daftar putih (allow-list)** | Daftar eksplisit apa yang boleh dimuat. Selain itu ditolak. |

### 2.4 Peta visual

**Diagram A: memilih alat**

```
Perlu membuat objek saat runtime?
 |
 +-- menunda / mengganti SATU bagian UI (halaman, panel, tab) ... Loader
 +-- banyak objek mengikuti model atau jumlah
 |     +-- visual berulang, butuh tata letak dan gulir ......... Repeater / ListView (7.2)
 |     +-- nirvisual, atau induk visual diatur sendiri ......... Instantiator
 +-- digerakkan logika imperatif (klik, event, data tervalidasi) Component.createObject()
 +-- komponen dimuat dari berkas/URL, perlu menunggu status ... Qt.createComponent() + status
 +-- ingin tidak membekukan UI saat membuat objek besar ....... incubateObject()
 +-- QML disusun sebagai teks saat runtime ................... Qt.createQmlObject()  (HINDARI)
```

**Diagram B: siklus hidup objek dinamis dan kepemilikannya**

```
 Component (cetakan)
     |  createObject(parent, props)
     v
 [objek hidup]
     |-- punya parent ----> umur terikat parent: parent dihancurkan -> objek ikut hancur
     |-- parent = null ---> umur terikat REFERENSI JS: referensi hilang -> GC boleh menghancurkan
     |
     +-- destroy(delay) --> dijadwalkan (antara akhir blok skrip dan frame berikutnya)
                                 |
                                 v
                    Component.onDestruction -> objek hilang
```

**Diagram C: status `Loader`**

```
 active=false / source kosong ---> Null
          | active=true + source/sourceComponent valid
          v
   asynchronous=true: Loading ---> Ready (sinyal loaded) ---> item tersedia
          |                              |
          +--> Error                     +-- ganti source / active=false
                                              -> objek lama DIHANCURKAN -> Null (atau Loading baru)
```

---

## 3. 7.3.1 `Loader`

> Memuat saat dibutuhkan adalah seni menghemat tanpa terasa.

### 3.1 Dasar sintaks

`Loader` memuat subpohon QML dari berkas (`source`) atau dari `Component` (`sourceComponent`). Ia berguna untuk menunda pembuatan: halaman yang baru dibuka, panel yang jarang dipakai, atau konten tab yang aktif saja.

**Contoh A: memuat, menerima sinyal, melepas**

```qml
import QtQuick

Item {
    id: root
    width: 320; height: 160

    Component {
        id: panelKomponen
        Rectangle {
            id: panel
            signal pesan(string teks)
            color: '#3498db'
            Text { anchors.centerIn: parent; color: 'white'; text: 'Panel dimuat' }
            MouseArea { anchors.fill: parent; onClicked: panel.pesan('diklik') }
        }
    }

    Loader {
        id: pemuat
        anchors.fill: parent
        active: false
        sourceComponent: panelKomponen
        onLoaded: console.log('dimuat, status =', status, '| ukuran =', item.width, 'x', item.height)
    }

    Connections {
        target: pemuat.item
        function onPesan(teks) { console.log('dari panel:', teks) }
    }

    Timer {
        interval: 300; running: true
        onTriggered: {
            console.log('status sebelum:', pemuat.status)
            pemuat.active = true
        }
    }
    Timer {
        interval: 900; running: true
        onTriggered: {
            pemuat.active = false
            console.log('status sesudah dilepas:', pemuat.status, '| item =', pemuat.item)
            Qt.quit()
        }
    }
}
```

**Keluaran yang diharapkan** (jalankan tanpa klik; di jendela, klik panel untuk memunculkan baris `dari panel`):

```
qml: status sebelum: 0
qml: dimuat, status = 1 | ukuran = 320 x 160
qml: status sesudah dilepas: 0 | item = null
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `Component { id: panelKomponen ... }` | Cetakan inline. Tidak dirender sampai diminta. `Component` bukan turunan `Item`, jadi tak bisa di-anchor. |
| `signal pesan(string teks)` | Sinyal kustom di item yang akan dimuat. |
| `Loader { id: pemuat }` | Pemuat. Ia sendiri adalah `Item`. |
| `anchors.fill: parent` | Ukuran eksplisit untuk `Loader`: item termuat **diubah ukurannya mengikuti Loader**. |
| `active: false` | Tidak membuat apa pun dulu. Bawaannya `true`. |
| `sourceComponent: panelKomponen` | Komponen yang akan dibuat saat `active` menjadi benar. |
| `onLoaded:` | Handler sinyal `loaded()`, terpancar saat status menjadi `Ready`. |
| `status`, `item` | Properti baca-saja: keadaan pemuatan dan objek termuat. |
| `Connections { target: pemuat.item }` | Mendengarkan sinyal dari objek yang dimuat. Target berubah saat `item` berubah. |
| `function onPesan(teks)` | Handler untuk sinyal `pesan`. |
| `Timer { interval; running }` | Memicu aksi tertunda agar urutannya terlihat. |
| `pemuat.active = false` | Melepas objek: objek termuat dihancurkan, `status` kembali `Null`. |

### 3.2 Properti dan perilaku utama

| Properti / metode | Fungsi | Catatan |
|---|---|---|
| `source` | URL berkas QML | String kosong membuang objek |
| `sourceComponent` | Objek `Component` | `undefined` membuang objek |
| `active` | Mengaktifkan atau menonaktifkan pemuatan | Default `true`. Saat dinonaktifkan, objek dibuang tetapi `source` tetap diingat |
| `asynchronous` | Membuat objek bertahap di beberapa frame | Default `false`. Dengan `source`, kompilasi juga di thread latar |
| `status` | `Null`/`Ready`/`Loading`/`Error` | Untuk berkas lokal, status langsung `Ready` atau `Error` |
| `progress` | 0.0 sampai 1.0 | Relevan untuk pemuatan jaringan |
| `item` | Objek termuat | Boleh tipe apa pun, tak harus `Item` |
| `loaded()` | Sinyal sukses | Tetap terpancar untuk berkas lokal walau tak ada `onStatusChanged` |
| `setSource(url, props)` | Memuat dengan properti awal | Tidak memicu `Behavior` pada properti awal |

Perubahan `source` atau `sourceComponent` selalu **menghancurkan objek lama**.

### 3.3 Aturan ukuran `Loader`

- Jika `Loader` **tanpa ukuran eksplisit**, ia mengikuti ukuran item termuat.
- Jika `Loader` **berukuran eksplisit** (`width`/`height`/anchors), item termuat diubah ukurannya mengikuti `Loader`.

Dalam kedua kasus ukuran keduanya identik, sehingga meng-anchor ke `Loader` sama dengan meng-anchor ke item termuat. Dengan komponen non-`Item`, aturan ini tidak berlaku.

### 3.4 Fokus dan tombol

`Loader` adalah **focus scope**. Agar anak-anaknya mendapat fokus aktif, `focus: true` harus diatur pada `Loader` **dan** pada item di dalam objek yang dimuat. Tombol yang ditangani sebaiknya diterima dengan `event.accepted = true` agar tidak merambat ke induk.

### 3.5 `Loader` di dalam delegate: jebakan konteks

Dokumentasi memperingatkan satu jebakan. Komponen yang dimuat `Loader` diinstansiasi dengan **creation context** tempat `Component`-nya dideklarasikan, bukan konteks delegate. Akibatnya `index` (dan role model) dari delegate tak terlihat dari komponen yang dideklarasikan di luar delegate.

| Solusi | Contoh |
|---|---|
| Pindahkan komponen **inline** ke dalam delegate | `sourceComponent: Component { Text { text: index } }` |
| Pindahkan ke **berkas terpisah** | `source: 'MyComponent.qml'` |
| Berikan data sebagai **properti `Loader`** (Loader menjadi context object komponen) | `property int modelIndex: index` lalu `text: modelIndex` |
| Dengan `ComponentBehavior: Bound`: rujuk lewat **id delegate** (cara yang dipakai di 7.2.7 dan 7.2.11) | `text: baris.catatan` |

### 3.6 Opsi lain untuk logika yang sama (memuat konten saat dibutuhkan)

| Opsi | Kapan dipakai |
|---|---|
| `Loader { source: ... }` | Satu bagian UI, dimuat dari berkas |
| `Loader { sourceComponent: ... }` | Komponen sudah ada di berkas yang sama |
| `Loader { active: kondisi }` | Memuat hanya saat kondisi benar (tab aktif) |
| `StackView` (Qt Quick Controls) | Navigasi halaman dengan riwayat |
| `Component.createObject()` | Anda ingin kendali penuh atas parent dan umur |

Jebakan: D9, D10, D11, D17.

---

## 4. 7.3.2 `Component.createObject()`

> Satu cetakan, banyak kue: tanggung jawab ada pada pemesan.

### 4.1 Dasar

`createObject(parent, properties)` membuat satu instance dari `Component` dan mengembalikannya. Argumen:

- **`parent`**: induk objek, boleh `Item` atau non-visual (`QtObject`). Hanya objek visual yang berinduk visual yang akan tampil. Boleh `null`.
- **`properties`** (opsional): peta nama ke nilai awal, diterapkan **sebelum pembuatan selesai**. Ini lebih efisien daripada mengatur properti sesudahnya dan mencegah galat binding bila suatu properti harus terisi lebih dulu.

Mengembalikan `null` jika gagal.

**Contoh B: contoh kurikulum, dengan log**

```qml
import QtQuick

Item {
    id: root
    width: 300; height: 200

    Component {
        id: kotakKomponen
        Rectangle {
            width: 40; height: 40; color: 'tomato'
            Component.onDestruction: console.log('kotak dihancurkan')
        }
    }

    function tambahKotak(posisiX) {
        const obj = kotakKomponen.createObject(root, { x: posisiX, y: 20 })
        if (!obj) console.warn('gagal membuat objek')
        return obj
    }

    Component.onCompleted: {
        const k = tambahKotak(30)
        tambahKotak(100)
        console.log('anak root =', root.children.length)
        k.destroy(500)
    }

    Timer {
        interval: 900; running: true
        onTriggered: {
            console.log('anak root setelah =', root.children.length)
            Qt.quit()
        }
    }
}
```

**Keluaran yang diharapkan:**

```
qml: anak root = 2
qml: kotak dihancurkan
qml: anak root setelah = 1
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `function tambahKotak(posisiX)` | Fungsi pembuat. Harus berada **di dalam** objek QML (D1). |
| `kotakKomponen.createObject(root, {...})` | Membuat Rectangle baru berinduk `root`, dengan `x` dan `y` awal. |
| `if (!obj)` | `createObject` bisa mengembalikan `null`. Selalu periksa (D2). |
| `Component.onCompleted` | Dijalankan setelah `root` selesai dibuat. Urutan antarpenangan tidak terdefinisi. |
| `k.destroy(500)` | Menjadwalkan penghancuran sekitar 500 ms kemudian. |
| `root.children.length` | Jumlah anak **visual** (`Item`) dari `root`. |
| `Component.onDestruction` | Dipanggil saat objek mulai dihancurkan. |

### 4.2 Properti awal dan `Qt.binding`

Properti awal bisa berupa nilai atau **binding** lewat `Qt.binding`:

```qml
const obj = kotakKomponen.createObject(root, {
    x: 10,
    width: Qt.binding(() => root.width / 4)     // mengikuti root.width
})
```

`required property` yang tak diisi lewat argumen ini membuat pembuatan gagal (`null`) dengan pesan galat. Itu cara yang baik untuk memastikan kontrak komponen dipenuhi.

### 4.3 Opsi lain untuk membuat komponen

| Opsi | Catatan |
|---|---|
| `Component { id: x ... }` | Anonim, tak bisa dipakai sebagai tipe properti |
| **Inline component**: `component Kotak: Rectangle { ... }` | Bertipe dan bernama (Qt 6). Disarankan dokumentasi bila butuh nama tipe |
| Berkas `Kotak.qml` + `Qt.createComponent('Kotak.qml')` | Terbaik untuk komponen besar atau dipakai ulang |

Jebakan: D1, D2, D3, D4, D12.

---

## 5. 7.3.3 `Qt.createComponent()` dan status loading

> Menunggu dengan sabar lebih murah daripada memperbaiki kecelakaan.

`Qt.createComponent(url)` membuat objek `Component` dari berkas QML. Jalur relatif dihitung **terhadap berkas tempat fungsi dipanggil**.

**Status `Component`:**

| Status | Arti |
|---|---|
| `Component.Null` | Tak ada data |
| `Component.Loading` | Sedang dimuat |
| `Component.Ready` | Siap membuat instance |
| `Component.Error` | Gagal. `errorString()` menjelaskan alasannya |

Untuk berkas lokal, status biasanya langsung `Ready`. Untuk URL jaringan, URL jarak jauh selalu dimuat secara asinkron, sehingga Anda **harus** menunggu status berubah.

**Contoh C: pemuatan yang aman dengan pemeriksaan status**

Berkas `Sprite.qml`:

```qml
import QtQuick
Rectangle { width: 80; height: 50; color: 'steelblue' }
```

Berkas utama (di folder yang sama):

```qml
import QtQuick

Item {
    id: root
    width: 300; height: 200

    property var komponen: null

    function buat() {
        komponen = Qt.createComponent('Sprite.qml')
        if (komponen.status === Component.Ready)
            selesai()
        else if (komponen.status === Component.Loading)
            komponen.statusChanged.connect(selesai)
        else
            console.warn('galat memuat:', komponen.errorString())
    }

    function selesai() {
        if (komponen.status === Component.Ready) {
            const s = komponen.createObject(root, { x: 100, y: 100 })
            console.log(s ? 'berhasil dibuat' : 'createObject gagal')
        } else if (komponen.status === Component.Error) {
            console.warn('galat memuat:', komponen.errorString())
        }
    }

    Component.onCompleted: buat()
    Timer { interval: 300; running: true; onTriggered: Qt.quit() }
}
```

Hasilnya `qml: berhasil dibuat`. Ubah nama berkas menjadi yang tak ada untuk melihat `Component.Error` dan teks `errorString()` yang menyebut berkas dan lokasi galat.

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `property var komponen` | Menyimpan `Component` agar tidak lepas selagi menunggu. |
| `komponen.statusChanged.connect(selesai)` | Menyambungkan sinyal perubahan status ke fungsi `selesai`. |
| `komponen.errorString()` | Deskripsi galat: berkas, lokasi, alasan. |
| `s ? ... : ...` | Operator ternary: pesan bergantung pada ada atau tidaknya objek. |

**Opsi lain:**

| Opsi | Catatan |
|---|---|
| `Qt.createComponent(url)` + status | Imperatif, fleksibel |
| `Loader { source: url }` | Menangani status dan siklus hidup untuk Anda |
| Inline `Component {}` | Tak perlu menunggu, selalu siap |

`Qt.createComponent` juga menerima argumen opsional untuk mode pemuatan dan parent. Lihat dokumentasi objek `Qt` pada versi Anda.

Jebakan: D2, D8.

---

## 6. 7.3.4 `Instantiator`

> Ketika data menentukan berapa banyak, jangan menulis ulang kodenya.

`Instantiator` (modul `QtQml.Models`) membuat **banyak objek dari satu template** berdasarkan `model`. Ia mirip `Repeater`, tetapi tanpa tata letak dan boleh membuat objek non-visual.

**Fakta dari dokumentasi:**

- Objek yang dibuatnya **diparent ke `Instantiator`** dan dikelola olehnya. Ia dapat menghancurkannya bila propertinya berubah.
- `model` boleh berupa angka, model (`ListModel`, `QAbstractItemModel`), daftar string, atau daftar objek. Default `1`.
- `delegate` adalah properti default.
- Di dalam delegate tersedia `index`.
- `active` (default `true`), `asynchronous` (default `false`), `count`, `object` (objek pertama), `objectAt(i)`.
- Sinyal `objectAdded(index, object)` dan `objectRemoved(index, object)`. Jangan menyimpan referensi `object` dari `objectRemoved`, karena objek segera dihapus.

**Contoh D: objek visual dari model**

```qml
import QtQuick
import QtQml.Models

Item {
    id: root
    width: 320; height: 100

    ListModel {
        id: warna
        ListElement { nama: 'Merah'; kode: '#e74c3c' }
        ListElement { nama: 'Hijau'; kode: '#2ecc71' }
        ListElement { nama: 'Biru';  kode: '#3498db' }
    }

    Row {
        id: baris
        spacing: 8
    }

    Instantiator {
        id: pabrik
        model: warna
        delegate: Rectangle {
            required property string nama
            required property string kode
            required property int index
            parent: baris
            width: 60; height: 60
            radius: 6
            color: kode
        }
        onObjectAdded: (index, object) => console.log('ditambah', index, object.nama)
        onObjectRemoved: (index, object) => console.log('dilepas', index)
    }

    Timer {
        interval: 300; running: true
        onTriggered: {
            warna.append({ nama: 'Kuning', kode: '#f1c40f' })
            warna.remove(0)
        }
    }
    Timer {
        interval: 700; running: true
        onTriggered: { console.log('count =', pabrik.count); Qt.quit() }
    }
}
```

**Keluaran yang diharapkan** (urutan tiga baris awal bisa berbeda):

```
qml: ditambah 0 Merah
qml: ditambah 1 Hijau
qml: ditambah 2 Biru
qml: ditambah 3 Kuning
qml: dilepas 0
qml: count = 3
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `import QtQml.Models` | Modul tempat `Instantiator` berada. |
| `Instantiator { model: warna }` | Membuat satu objek per baris `ListModel`. |
| `delegate: Rectangle {...}` | Template. Boleh juga ditulis sebagai anak langsung karena `delegate` adalah properti default. |
| `required property ...` | Kontrak data dari model (sama seperti 7.2.4). |
| `parent: baris` | `Instantiator` **bukan `Item`**, jadi objek visual tak punya induk visual sampai Anda mengaturnya. Di sini `Row` menata mereka (D15). |
| `onObjectAdded: (index, object) => ...` | Sinyal tiap objek baru. |
| `warna.append(...)` dan `warna.remove(0)` | Perubahan model otomatis menambah dan melepas objek. |

**Kegunaan khas `Instantiator`:** membuat objek non-visual dari data, seperti `Connections`, `Shortcut`, atau item menu. Setelah objek dibuat, `onObjectAdded` dipakai untuk menyisipkannya ke wadah yang tepat.

**Opsi lain:**

| Opsi | Kapan |
|---|---|
| `Repeater` | Visual berulang dalam positioner (tanpa virtualisasi) |
| `ListView`/`GridView` | Daftar panjang (virtualisasi) |
| `Instantiator` | Banyak objek, terutama non-visual, atau induk diatur sendiri |
| Loop + `createObject()` | Kendali penuh, tetapi Anda yang mengurus umur objek |

Jebakan: D7, D15, D16.

---

## 7. 7.3.5 `destroy()` dan kepemilikan

> Siapa yang membuat, dia yang menjaga umurnya.

### 7.1 Aturan `destroy()`

- `destroy(delay)` menjadwalkan penghancuran. Argumen `delay` (milidetik, default 0) bersifat perkiraan.
- Objek **tidak dihancurkan seketika**. Pembersihan terjadi antara akhir blok skrip dan frame berikutnya.
- Aman memanggil `destroy()` dari dalam objek itu sendiri (misalnya animasi yang selesai lalu `rect.destroy()`).
- **Hanya objek yang dibuat dinamis yang boleh di-`destroy()`.** Pada objek yang dideklarasikan statis, itu menghasilkan galat.
- **Jangan** menghancurkan secara manual objek yang dibuat oleh pabrik kenyamanan seperti `Loader`, `Repeater`, dan `Instantiator`. Hindari juga menghancurkan objek yang tidak Anda buat sendiri.
- Untuk UI sederhana, menyetel `opacity` atau `visible` bisa cukup. Menghancurkan baru bermanfaat bila objek dinamis sangat banyak.

### 7.2 Parent vs pemilik

| Cara pembuatan | Parent | Pemilik / penentu umur | Yang harus Anda lakukan |
|---|---|---|---|
| `createObject(root, ...)` | `root` | `root`: objek hancur bersama `root`, atau saat `destroy()` | `destroy()` bila tak lagi perlu |
| `createObject(null, ...)` | Tidak ada | **Referensi JavaScript**: bila hilang, GC boleh menghancurkan objek | **Simpan referensi** (registri) dan atur parent visual bila perlu |
| `Loader` | `Loader` | `Loader` | Jangan destroy. Ubah `active` atau `source` |
| `Instantiator` | `Instantiator` | `Instantiator` | Jangan destroy. Ubah model atau `active` |
| `Repeater` / view | View | View | Jangan destroy |
| `Qt.createQmlObject(.., parent)` | `parent` | Sama dengan `createObject` | `destroy()` |
| Dideklarasikan statis | | Berkas QML | Tidak boleh `destroy()` |

Mengatur `Item.parent` setelahnya **tidak mengubah kepemilikan**, hanya induk visual.

### 7.3 Creation context harus hidup lebih lama

Binding dan penangan sinyal pada objek dinamis bergantung pada **creation context**. Jika konteks itu dihancurkan lebih dulu, binding dan penangan di objek dinamis berhenti bekerja. Konteks pembuatan bergantung pada caranya:

| Cara | Creation context |
|---|---|
| `Qt.createComponent()` | Konteks tempat metode dipanggil |
| `Qt.createQmlObject()` | Konteks objek parent yang diberikan |
| `Component {}` lalu `createObject()` / `incubateObject()` | Konteks tempat `Component` dideklarasikan |

Objek dinamis juga **tidak punya `id`** di QML. Rujuk lewat variabel JavaScript atau registri.

### 7.4 Pola: registri objek

```qml
property var kotak: []                         // registri: Anda pemilik referensinya

function tambah() {
    const o = kotakKomponen.createObject(root, { nomor: ++penghitung })
    if (o) kotak.push(o)
}
function hapusTerakhir() {
    const o = kotak.pop()
    if (o) o.destroy()
}
```

Jebakan: D4, D5, D6, D7, D13.

---

## 8. 7.3.6 Risiko `Qt.createQmlObject`

> Menyusun kode dari teks adalah kemudahan yang harganya paling mahal.

`Qt.createQmlObject(teks, parent, path)` mengompilasi **string QML** lalu membuat objeknya. Argumen ketiga hanya nama berkas untuk pelaporan galat.

```qml
const obj = Qt.createQmlObject(`
    import QtQuick
    Rectangle { color: 'red'; width: 20; height: 20 }
`, parentItem, 'cuplikanDinamis')
```

**Tiga alasan menghindarinya:**

1. **Sangat lambat.** Mesin harus mengompilasi string itu setiap kali dipanggil.
2. **Mudah menghasilkan QML tak valid** saat menyusun kode lewat manipulasi string.
3. **Berbahaya bila teksnya dipengaruhi data luar.** Teks itu **dieksekusi sebagai kode**. Dokumentasi Qt secara eksplisit melarang pembuatan objek dinamis dari sumber tak tepercaya, dan menegaskan bahwa batasan untuk sumber QML statis berlaku sama untuk pembuatan dinamis.

**Pola yang salah (jangan ditiru):**

```qml
// JANGAN: masukan luar disisipkan ke teks QML
const kode = 'import QtQuick\nText { text: "' + masukanPengguna + '" }'
Qt.createQmlObject(kode, root, 'x')
```

Tanda kutip di dalam `masukanPengguna` bisa keluar dari string dan menyisipkan QML atau JavaScript lain. Karena QML tak punya domain privasi terpisah, kode yang tersisip dapat mengakses semua data dalam lingkupnya.

**Pola yang benar:** komponen tetap, data lewat properti.

```qml
Component { id: teksKomponen; Text { required property string isi; text: isi; textFormat: Text.PlainText } }

teksKomponen.createObject(root, { isi: masukanPengguna })   // data tetap data, bukan kode
```

**Catatan lain:**

- Pada build statis, hanya pernyataan `import` di bagian atas berkas yang dipindai. Impor yang hanya ada di dalam string tidak terdeteksi, jadi tulis impor yang sama juga di bagian atas berkas.
- Jalur relatif impor dalam string dihitung terhadap berkas objek parent.
- Prinsip yang sama berlaku untuk `Loader.source`: jangan biarkan URL berasal dari data luar tanpa daftar putih (7.3.8).

**Opsi lain:**

| Kebutuhan | Gunakan |
|---|---|
| Objek dengan variasi isi | Komponen tetap + properti awal |
| Variasi tipe dari kumpulan terbatas | Pilih komponen dari daftar putih (7.3.8) |
| Isi dinamis berupa data | Model + view |

Jebakan: D14, D17.

---

## 9. 7.3.7 (TAMBAHAN) Inkubasi asinkron: `incubateObject()`

> Pekerjaan berat yang tidak membekukan antarmuka adalah bentuk kesopanan.

`Component.incubateObject(parent, properties, mode)` membuat instance **tanpa membekukan UI**. Ia mengembalikan **inkubator** (atau `null` bila gagal). Properti inkubator:

| Properti | Arti |
|---|---|
| `status` | `Component.Ready`, `Component.Loading`, atau `Component.Error` |
| `object` | Objek hasil. Hanya tersedia saat `Ready` |
| `onStatusChanged` | Callback saat status berubah |
| `forceCompletion()` | Menyelesaikan inkubasi secara sinkron |

Mode: `Qt.Synchronous` atau `Qt.Asynchronous` (default asinkron). Walau sinkron diminta, inkubator bisa tetap asinkron bila komponen pemanggilnya sendiri sedang dibuat secara asinkron.

```qml
function buatAsinkron() {
    const inkubator = kotakKomponen.incubateObject(root, { nomor: 99, x: 10, y: 100 })
    if (inkubator === null) { console.warn('inkubasi gagal dimulai'); return }

    if (inkubator.status !== Component.Ready) {
        inkubator.onStatusChanged = function (status) {
            if (status === Component.Ready)
                console.log('siap:', inkubator.object)
            else if (status === Component.Error)
                console.warn('inkubasi galat')
        }
    } else {
        console.log('siap segera:', inkubator.object)
    }
}
```

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `incubateObject(root, {...})` | Meminta pembuatan bertahap berinduk `root`. |
| `inkubator.status !== Component.Ready` | Bisa langsung siap, bisa belum. Tangani keduanya. |
| `inkubator.onStatusChanged = function (status) {...}` | Menetapkan callback yang menerima status baru. |
| `inkubator.object` | Objek jadi. **Jangan** dipakai sebelum `Ready`. |

**Opsi lain untuk menghindari UI beku:** `Loader { asynchronous: true }` untuk satu bagian UI, dan `Instantiator { asynchronous: true }` untuk banyak objek. Sinyal `objectAdded` memberi tahu tiap objek yang siap.

---

## 10. 7.3.8 (TAMBAHAN) Pola pabrik objek yang aman

> Kuasa untuk menciptakan harus dibatasi daftar dan jumlahnya.

Ini penerapan prinsip keamanan dari 7.3.6. Empat pagar yang perlu dipasang:

1. **Daftar putih** untuk apa yang boleh dimuat.
2. **Validasi** kunci dan tipe sebelum dipakai.
3. **Batas jumlah** objek.
4. **Registri dan pembersihan** yang jelas.

**Contoh E: daftar putih untuk `Loader`**

Berkas `Merah.qml` dan `Hijau.qml` berisi `Rectangle` sederhana berwarna masing-masing (di folder yang sama).

```qml
import QtQuick

Item {
    id: root
    width: 320; height: 120

    // Daftar putih: hanya kunci ini yang boleh. Nilai = URL tetap & tepercaya (lokal atau qrc).
    readonly property var registri: ({
        'merah': Qt.resolvedUrl('Merah.qml'),
        'hijau': Qt.resolvedUrl('Hijau.qml')
    })

    function muatPanel(kunci) {
        if (typeof kunci !== 'string'
            || !Object.prototype.hasOwnProperty.call(registri, kunci)) {
            console.warn('ditolak: kunci panel tidak dikenal')
            return false
        }
        pemuat.source = registri[kunci]
        return true
    }

    Loader { id: pemuat; anchors.fill: parent }

    Component.onCompleted: {
        console.log(muatPanel('merah'))         // true
        console.log(muatPanel('constructor'))   // false (ditolak)
        console.log(muatPanel(42))              // false
        console.log(muatPanel('https://x.test/a.qml'))   // false
        Qt.quit()
    }
}
```

**Keluaran yang diharapkan:**

```
qml: true
qml: ditolak: kunci panel tidak dikenal
qml: false
qml: ditolak: kunci panel tidak dikenal
qml: false
qml: ditolak: kunci panel tidak dikenal
qml: false
```

**Penjelasan kata demi kata:**

| Potongan | Arti |
|---|---|
| `readonly property var registri: ({...})` | Peta tetap kunci ke URL. Tanda kurung membuat `{}` terbaca sebagai objek, bukan blok kode. |
| `Qt.resolvedUrl('Merah.qml')` | Mengubah jalur relatif menjadi URL absolut terhadap berkas ini. |
| `typeof kunci !== 'string'` | Menolak tipe yang bukan teks. |
| `Object.prototype.hasOwnProperty.call(registri, kunci)` | Memeriksa kunci **milik objek itu sendiri**. Ini penting. |
| `pemuat.source = registri[kunci]` | URL yang dimuat selalu dari tabel, **tidak pernah** dari masukan. |

**Mengapa bukan `if (registri[kunci])`?** Kunci seperti `'constructor'` atau `'__proto__'` ada di rantai prototipe objek JavaScript, sehingga pemeriksaan naif meloloskan masukan yang tak Anda daftarkan. Itulah tantangan di bagian latihan.

**Contoh F: pabrik dengan batas dan registri (dipakai untuk latihan 7.3)**

```qml
import QtQuick

Item {
    id: root
    width: 360; height: 200
    focus: true

    property var kotak: []
    property int penghitung: 0
    readonly property int maksKotak: 8

    Component {
        id: kotakKomponen
        Rectangle {
            id: k
            required property int nomor
            width: 40; height: 40
            radius: 6
            color: Qt.hsla((k.nomor * 0.13) % 1, 0.7, 0.55, 1)
            Text { anchors.centerIn: parent; color: 'white'; text: k.nomor }
            Component.onDestruction: console.log('kotak', k.nomor, 'dihancurkan')
        }
    }

    function tambah() {
        if (kotak.length >= maksKotak) { console.warn('batas tercapai'); return null }
        const obj = kotakKomponen.createObject(root, {
            nomor: ++penghitung, x: 10 + kotak.length * 44, y: 20
        })
        if (obj === null) { console.warn('gagal membuat kotak'); return null }
        kotak.push(obj)
        return obj
    }

    function hapusTerakhir() {
        const obj = kotak.pop()
        if (obj) obj.destroy()
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_A)      { tambah();        event.accepted = true }
        else if (event.key === Qt.Key_D) { hapusTerakhir(); event.accepted = true }
    }
}
```

Tekan `a` untuk menambah kotak dan `d` untuk menghapus yang terakhir. Perhatikan log `dihancurkan`.

**Penjelasan:**

| Potongan | Arti |
|---|---|
| `maksKotak` | Batas jumlah objek. Mencegah pertumbuhan tanpa batas. |
| `required property int nomor` | Komponen mewajibkan nomor. Diisi lewat argumen `createObject`. |
| `Qt.hsla(h, s, l, a)` | Membuat warna dari hue/saturasi/lightness/alfa, untuk variasi warna. |
| `kotak.push(obj)` / `kotak.pop()` | Registri: satu-satunya tempat referensi objek disimpan. |
| `obj.destroy()` | Pemilik (registri) menghancurkan objeknya. |

**Integrasi dengan `ObjectModel` (janji dari 7.1.3):** objek hasil `createObject()` dapat dimasukkan ke model berisi item visual:

```qml
halaman.append(komponenHalaman.createObject())   // tanpa parent: simpan referensi dan atur nasib objeknya
```

Dalam kasus ini `ObjectModel` menampung referensi, tetapi **Anda tetap bertanggung jawab** atas penghancurannya bila perlu. Perlakukan model sebagai bagian dari registri.

**Pagar tambahan untuk produksi:**

- Data yang menentukan *jenis* objek (misalnya dari JSON hasil 7.4) harus melewati **gerbang validasi** dan dipetakan ke daftar putih. Jangan pernah dijadikan URL atau teks QML.
- Muat QML hanya dari berkas lokal atau sumber daya Qt (`qrc`). Bila harus lewat jaringan, gunakan HTTPS atau jaringan tepercaya, sesuai anjuran dokumentasi keamanan Qt.
- Tangani kegagalan: periksa `null`, status `Error`, dan batas jumlah.

Jebakan: D5, D14, D17.

---

## 11. Penutup modul

### 11.1 Hubungan dengan modul lain

- **Prasyarat:** 3.4 (scope, id, konteks, yang menjelaskan creation context), 5.1 (`Component`, `required property`), 6.3 (fokus dan `Keys`), 7.1.3 (`ObjectModel`), 7.2 (`Loader` dalam delegate).
- **7.4 Data Asinkron:** hasil jaringan harus lewat validasi, lalu dipetakan ke daftar putih sebelum memilih komponen. Jangan meneruskannya ke `createQmlObject`.
- **Fase 6 (State/Transition):** `Loader.status` bisa dipakai sebagai pemicu `State`.
- **Modul 10.x (C++):** `QQmlComponent` adalah padanan C++ dari `Component`, dipakai bila pembuatan objek dikendalikan dari C++.
- **Fase 13 (keamanan):** daftar putih, validasi masukan, batas sumber daya, dan larangan mengeksekusi kode dari data luar.
- **Qt Quick Controls:** `StackView` mengelola halaman dinamis di atas prinsip yang sama.

### 11.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| D1 | Galat sintaks saat memuat berkas | Fungsi pembuat ditulis di luar objek | Letakkan di dalam objek QML (atau di berkas `.js`) |
| D2 | `createObject` mengembalikan `null` tanpa pesan di aplikasi | Galat QML, `required property` tak terisi, atau komponen belum siap | Selalu periksa `null`, baca keluaran galat di konsol |
| D3 | Objek dibuat tetapi tak terlihat | Tanpa parent visual (parent `null` atau non-`Item`) | Beri parent `Item` yang valid |
| D4 | Objek menghilang sendiri | `createObject(null)` tanpa referensi disimpan (GC) | Simpan referensi di registri, atau beri parent |
| D5 | Memori terus naik | Objek tak pernah dihancurkan, tanpa batas | Registri + `destroy()` + batas jumlah |
| D6 | Galat saat `destroy()` | Objek dideklarasikan statis | Hanya hancurkan objek dinamis |
| D7 | Perilaku aneh setelah `destroy()` manual | Menghancurkan objek milik `Loader`/`Repeater`/`Instantiator` | Ubah `active`/`source`/model, jangan destroy |
| D8 | Komponen jaringan tak bisa dibuat | `createObject` dipanggil saat status `Loading` | Tunggu `statusChanged`, periksa `Ready`, tangani `Error` |
| D9 | `index` atau role tak terlihat di komponen yang dimuat `Loader` di delegate | Creation context komponen bukan delegate | Komponen inline di delegate, berkas terpisah, properti `Loader`, atau rujuk lewat id (dengan `Bound`) |
| D10 | `Loader` kosong | `active: false`, sumber salah, atau status `Error` | Cek `status`, `source`, dan log galat |
| D11 | Tombol tak sampai ke item termuat | `Loader` adalah focus scope | `focus: true` pada `Loader` dan item, serta `event.accepted = true` |
| D12 | Binding awal gagal | Properti diatur setelah pembuatan | Pakai argumen `properties` atau `Qt.binding` |
| D13 | Binding atau sinyal objek dinamis berhenti | Creation context dihancurkan lebih dulu | Pastikan konteks hidup lebih lama dari objek |
| D14 | Kode asing tereksekusi | `createQmlObject` dengan teks dipengaruhi data luar | Komponen tetap + properti; jangan susun QML dari input |
| D15 | Objek `Instantiator` tak tampak | `Instantiator` bukan `Item`, sehingga tak ada induk visual | `parent: wadah` di delegate |
| D16 | Galat saat memakai objek dari `objectRemoved` | Objek segera dihapus | Jangan simpan referensinya |
| D17 | Memuat komponen yang tak diinginkan | `Loader.source` atau kunci berasal dari input tanpa daftar putih | Daftar putih, validasi, URL tetap dari tabel |

### 11.3 Latihan 15 menit

**Persiapan terminal (Arch).** Cari nama biner QML di sistem Anda:

```bash
pacman -Q qt6-declarative
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmllint|qmlformat)'
```

Pakai nama yang muncul, misalnya jika `qml`:

```bash
qml latihan73.qml                                   # dengan jendela (untuk tombol dan klik)
QT_QPA_PLATFORM=offscreen qml latihan73.qml         # tanpa jendela (untuk skrip yang mencetak log)
qmllint latihan73.qml                               # pemeriksaan statis
```

**Langkah:**

1. Salin Contoh F (7.3.8) ke `latihan73.qml` dan jalankan dengan jendela. Tekan `a` beberapa kali sampai batas, lalu `d`. Cocokkan dengan log `dihancurkan`.
2. Sesuai kurikulum: tambahkan dua **tombol** (`Rectangle` dengan `MouseArea` atau `TapHandler`) yang memanggil `tambah()` dan `hapusTerakhir()`. Susun di bagian bawah jendela.
3. **Uji D2:** hapus `nomor: ++penghitung` dari argumen `createObject`. Apa yang terjadi, dan apa kata konsol?
4. **Uji D4:** buat `createObject(null, { nomor: 1 })` tanpa menyimpannya, lalu panggil `gc()`. Amati apakah `Component.onDestruction` berjalan. Hasilnya bisa bergantung versi dan waktu.
5. Jalankan `qmllint latihan73.qml` dan rapikan peringatannya.

**Tantangan 10 menit:** pada Contoh E (7.3.8), ganti pemeriksaan daftar putih dengan versi naif `if (registri[kunci])`. Panggil `muatPanel('constructor')` dan amati perbedaannya. Lalu kembalikan ke versi `hasOwnProperty` dan jelaskan sendiri mengapa yang kedua lebih aman.

### 11.4 Cek pemahaman

1. Apa beda `Loader` dan `createObject()`? Siapa pemilik objek yang dibuat dengan `createObject(parent)`?
2. Mengapa `createObject(null)` tanpa menyimpan referensi berbahaya?
3. Mengapa objek buatan `Loader` tak boleh dihancurkan manual?
4. Mengapa `Qt.createQmlObject` dengan input luar berbahaya, dan apa gantinya?
5. Mengapa komponen yang dimuat `Loader` di dalam delegate bisa kehilangan `index`?
6. Kapan memilih `Instantiator` dibanding `Repeater`?
7. Mengapa `destroy()` tidak langsung menghilangkan objek saat itu juga?

**Jawaban singkat:**

1. `Loader` mengelola satu objek termuat beserta siklus hidupnya (membuang objek lama saat `source` berubah, ukuran, status). `createObject()` membuat satu instance secara imperatif dan Anda yang mengelola umurnya. Pemilik objek `createObject(parent)` adalah `parent`: objek ikut hancur bersama parent, atau bisa dihancurkan sendiri lewat `destroy()`.
2. Tanpa parent, umur objek ditentukan referensi JavaScript. Bila referensi hilang, GC dapat menghancurkannya. Mengatur `Item.parent` kemudian tidak mengubah kepemilikan.
3. Objek itu dikelola `Loader`. Mengubah `active` atau `source` adalah cara yang benar. Menghancurkan manual mengacaukan keadaan pabrik.
4. Teksnya dieksekusi sebagai kode, sehingga masukan yang disisipkan bisa menjadi kode. QML juga tak punya domain privasi terpisah. Ganti dengan komponen tetap dan kirim data lewat properti awal.
5. Karena komponen diinstansiasi dengan creation context tempat `Component` dideklarasikan, bukan konteks delegate. Solusi: komponen inline di delegate, berkas terpisah, properti `Loader`, atau rujukan lewat id.
6. Saat objek tidak butuh tata letak atau virtualisasi `Repeater`, atau non-visual, atau induk visualnya diatur sendiri.
7. Penghancuran dijadwalkan: dilakukan antara akhir blok skrip dan frame berikutnya (atau setelah `delay` bila diberikan).

### 11.5 Referensi

Tautan di bawah ini muncul pada halaman dokumentasi Qt 6.12 yang saya baca saat menyusun materi ini.

- [Dynamic QML Object Creation from JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html)
- [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html) · [Component](https://doc.qt.io/qt-6/qml-qtqml-component.html) · [Instantiator](https://doc.qt.io/qt-6/qml-qtqml-models-instantiator.html)
- [QML Global Object `Qt`](https://doc.qt.io/qt-6/qml-qtqml-qt.html)
- [Handling Untrusted Data](https://doc.qt.io/qt-6/untrusteddata.html) · [Security in Qt](https://doc.qt.io/qt-6/security.html)
- [QML Scope (creation context)](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [Inline components](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html#inline-components)
- [Connecting Signals to Methods and Signals](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#connecting-signals-to-methods-and-signals) · [Connections](https://doc.qt.io/qt-6/qml-qtqml-connections.html)
- [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html)
- [QQmlComponent (C++)](https://doc.qt.io/qt/qqmlcomponent.html)
- [ObjectModel](https://doc.qt.io/qt-6/qml-qtqml-models-objectmodel.html) · [Models and Views in Qt Quick](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html)
- Komunitas: [Qt Forum](https://forum.qt.io/) · [Qt Academy](https://www.qt.io/academy)

---

# Modul 7.4: Data Asinkron (XHR, JSON, dan Pekerjaan Berat)

*Fase 7: Model, View, dan Arsitektur Data*

## Daftar isi modul ini

1. Audit singkat sebelum materi
2. Fondasi: peran modul, konsep dan filosofi, terminologi, peta visual
3. **7.4.1** XHR dan siklus `readyState`
4. **7.4.2** `JSON.parse` dan validasi
5. **7.4.3** Penanganan galat (jaringan, HTTP, parsing)
6. **7.4.4** `Promise` dan keterbatasan `async/await`
7. **7.4.5** `WorkerScript`
8. **7.4.6** Kapan ke C++
9. **7.4.7** (TAMBAHAN) Ketangguhan: timeout, pembatalan, urutan, dan ulang-coba
10. **7.4.8** (TAMBAHAN) Keamanan data jaringan dan studi kasus ujung ke ujung
11. Penutup: hubungan modul, tabel kesalahan, latihan, cek pemahaman, referensi

---

## 1. Audit singkat

Saya membaca bagian 7.4 terhadap dokumentasi Qt 6.12 (`XMLHttpRequest`, JavaScript Host Environment, daftar objek JavaScript, `WorkerScript`).

| # | Temuan | Status | Tindakan |
|---|---|---|---|
| 1 | Prasyarat: 2.x (callback, JSON, `Promise`), 3.x (sinyal), 6.x (`Timer`), 7.1 (gerbang validasi), 7.3 (keamanan dinamis) | Aman, tidak ada loncatan | Tidak ada |
| 2 | Contoh `ambilJson` membungkus `sukses(...)` di dalam `try` | **Cacat kecil** | Galat di dalam callback sukses akan dilaporkan sebagai "JSON tidak valid". Perbaikan: `parse` di dalam `try`, callback di luar (7.4.1) |
| 3 | `status !== 200` dilaporkan sebagai `HTTP <status>` | Menyesatkan | Pada galat jaringan, `status` umumnya bernilai `0`, bukan kode HTTP. Dipisah di 7.4.3 |
| 4 | Hanya status `200` dianggap sukses | Terlalu sempit | Seluruh rentang 2xx umumnya sah (misalnya 204). Dibahas di 7.4.3 |
| 5 | "`async/await` [uji dulu]" | Perlu fakta | Runtime QML mengimplementasikan edisi ke-7 ECMAScript (2016), sedangkan `async/await` baru ada di edisi 2017. `Promise` tersedia. Dikonfirmasi di 7.4.4 |
| 6 | `WorkerScript` tanpa `import` dan berkas `.mjs` | Kurang | Perlu `import QtQml.WorkerScript`. Berkas `.mjs` berjalan sebagai modul ES (mode ketat). Pesan memiliki batasan tipe. Ditambahkan di 7.4.5 |
| 7 | Timeout, pembatalan, balapan respons, ulang-coba | Belum ada | TAMBAHAN 7.4.7 |
| 8 | Keamanan jaringan | Belum ada | TAMBAHAN 7.4.8. XHR QML **tidak menegakkan same-origin policy**, jadi penjagaan host menjadi tugas Anda |
| 9 | `QML_XHR_DUMP`, akses berkas lokal lewat XHR | Belum ada | Dibahas di 7.4.1 dan 7.4.8 |

**Pembaruan daftar isi kurikulum 7.4:** 7.4.1 sampai 7.4.6 tetap, ditambah **7.4.7** (Ketangguhan) dan **7.4.8** (Keamanan data jaringan dan studi kasus ujung ke ujung).

---

## 2. Fondasi modul

### 2.1 Deskripsi konkret dan peran dalam kurikulum

Data nyata hampir selalu datang dari luar: server, berkas, layanan. Modul ini mengajarkan tiga hal: **mengambilnya tanpa membekukan UI**, **memastikan ia layak dipakai** sebelum masuk model (7.1), dan **memindahkan pekerjaan berat** ke tempat yang tidak mengganggu antarmuka. Modul ini menutup Fase 7: model (7.1), view (7.2), objek dinamis (7.3), dan sekarang pasokan datanya.

### 2.2 Konsep kunci dan filosofi

**Analogi untuk non-IT.** Memesan makanan lewat kurir: Anda tidak berdiri menunggu di pintu (UI tetap berjalan), kurir mengabari saat tiba (callback). Pekerjaan berat di thread UI sama dengan pelayan yang berhenti melayani selama memasak. Memindahkannya ke `WorkerScript` sama dengan menyewa juru masak terpisah di dapur belakang.

Prinsip yang mendasarinya:

1. **Asinkron berarti menunggu tanpa memblokir.** `send()` kembali seketika. Hasilnya datang lewat callback di thread UI.
2. **Thread UI hanya untuk UI.** Penguraian dan validasi data besar adalah pekerjaan CPU. Jika dijalankan di thread UI, ia membekukan layar.
3. **Semua yang datang dari jaringan tidak tepercaya.** Ia bisa salah format, terlalu besar, terlambat, atau berbahaya. Perlakukan sebagai **batas kepercayaan** yang dilewati lewat serangkaian gerbang.
4. **Gagal dengan jelas.** Jaringan putus, HTTP 404, dan JSON rusak adalah tiga masalah yang berbeda dan butuh tanggapan berbeda.
5. **Keamanan.** XHR QML tidak menegakkan kebijakan same-origin. Aplikasi bisa meminta ke host mana pun, maka aplikasi sendiri harus membatasi host, skema, ukuran, dan jumlah.

### 2.3 Terminologi esensial

| Istilah | Penjelasan |
|---|---|
| **XHR (`XMLHttpRequest`)** | Objek bawaan untuk permintaan HTTP dari JavaScript. Implementasi sebagian dari standar W3C XHR Level 1. |
| **`readyState`** | Tahap permintaan: `UNSENT` 0, `OPENED` 1, `HEADERS_RECEIVED` 2, `LOADING` 3, `DONE` 4. |
| **`status`** | Kode HTTP respons (200, 404, ...). Bernilai `0` bila tak ada respons HTTP. |
| **Callback** | Fungsi yang dipanggil saat sesuatu selesai atau terjadi. |
| **Thread UI** | Thread yang menggambar dan menangani input. Tidak boleh diblokir. |
| **JSON** | Format teks pertukaran data. `JSON.parse` mengubahnya menjadi objek. `JSON.stringify` kebalikannya. |
| **Batas kepercayaan** | Garis tempat data berpindah dari tak tepercaya ke tepercaya. Harus dijaga validasi. |
| **Gerbang validasi** | Fungsi pemeriksa dan pembersih sebelum data masuk model. |
| **Timeout / `abort()`** | Batas waktu tunggu dan pembatalan permintaan. |
| **Balapan (race condition)** | Respons lama tiba setelah yang baru dan menimpanya. |
| **Backoff** | Jeda ulang-coba yang membesar bertahap. |
| **`WorkerScript`** | Menjalankan JavaScript di thread terpisah dengan mesin JavaScript sendiri. |
| **`.mjs`** | Berkas modul ES. Untuk `WorkerScript`, berjalan dalam mode ketat. |
| **`sync()`** | Metode `ListModel` untuk menyinkronkan perubahan dari thread kerja. |
| **Same-origin policy** | Aturan peramban yang membatasi permintaan lintas asal. **Tidak ditegakkan** oleh XHR QML. |
| **Daftar putih (allow-list)** | Daftar eksplisit yang diizinkan. Selain itu ditolak. |
| **ES7** | Edisi ke-7 ECMAScript (2016). Tingkat bahasa yang diimplementasikan runtime QML. |

### 2.4 Peta visual

**Diagram A: permintaan asinkron dan thread**

```
 Thread UI (satu-satunya yang menyentuh UI)                  Jaringan (di luar thread UI)
 ---------------------------------------------               -------------------------
 req.send() -------------------------------------------->    kirim permintaan
 (UI tetap hidup: animasi, input, render)                    ... menunggu server ...
 <-------- onreadystatechange (HEADERS_RECEIVED, LOADING) -- data tiba
 <-------- onreadystatechange (DONE) ----------------------- selesai
 callback jalan di thread UI -> JSON.parse -> validasi -> model
 (parse + validasi DATA BESAR di thread UI = UI membeku -> pindahkan ke WorkerScript / C++)
```

**Diagram B: lapis pertahanan data jaringan**

```
 Internet / berkas / pengguna  (TIDAK TEPERCAYA)
        |
        v
 [1] Gerbang URL       : skema + host + awalan (daftar putih), HTTPS
 [2] Gerbang transport : status 2xx, batas waktu, batas ukuran
 [3] Gerbang format    : JSON.parse di try/catch
 [4] Gerbang bentuk    : tipe, rentang, kunci dikenal, batas jumlah
 [5] Gerbang tampilan  : Text.PlainText, tanpa createQmlObject, tanpa Loader dari data
        |
        v
 Model (7.1)  ->  View (7.2)
```

**Diagram C: memilih alat untuk pekerjaan berat**

```
Pekerjaan berat?
 +-- menunggu jaringan / IO ......................... XHR (sudah asinkron, tak perlu thread)
 +-- CPU berat di JS, hasil kecil sampai sedang ...... WorkerScript
 +-- CPU berat + data besar / perlu kecepatan & tipe . C++ (QtConcurrent / QThread, Modul 10.7)
 +-- TLS khusus, upload besar, WebSocket, otentikasi . C++ QtNetwork / QtWebSockets
```

---

## 3. 7.4.1 XHR dan siklus `readyState`

> Menunggu dengan elegan adalah keterampilan, bukan kelemahan.

### 3.1 Empat langkah dasar

Menurut dokumentasi Qt, langkahnya: buat objek `XMLHttpRequest`, pasang callback `onreadystatechange`, panggil `open(metode, url)`, lalu `send()`. Di callback, periksa `readyState === DONE` sebelum membaca `response`, `responseText`, atau `responseXML`.

**Contoh A: contoh kurikulum, dijelaskan kata demi kata**

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

| Potongan | Arti |
|---|---|
| `function ambilJson(url, sukses, gagal)` | Fungsi di dalam objek. `sukses` dan `gagal` adalah callback dari pemanggil. |
| `new XMLHttpRequest()` | Membuat objek permintaan. Satu objek untuk satu permintaan. |
| `req.onreadystatechange = function() {...}` | Callback yang dipanggil **setiap kali `readyState` berubah**. |
| `XMLHttpRequest.DONE` | Konstanta tahap akhir (4). Hanya saat itu respons utuh siap. |
| `req.status === 200` | Kode HTTP "OK". |
| `JSON.parse(req.responseText)` | Mengurai teks menjadi objek. Melempar `SyntaxError` bila teks tak valid. |
| `try { ... } catch (e) { ... }` | Menangkap galat parse. |
| `req.open('GET', url)` | Menentukan metode dan alamat. Wajib sebelum `send()`. |
| `req.send()` | Mengirim. Kembali seketika, hasil datang lewat callback. |
| `console.log, console.warn` | Dua fungsi bawaan dipakai sebagai callback demi singkat. |

**Perbaikan hasil audit** (tiga hal: parse di `try` saja, galat jaringan terpisah, rentang 2xx):

```qml
function ambilJson(url, sukses, gagal) {
    const req = new XMLHttpRequest()
    req.onreadystatechange = function () {
        if (req.readyState !== XMLHttpRequest.DONE) return

        if (req.status === 0) { gagal('jaringan', 'tidak ada respons'); return }
        if (req.status < 200 || req.status >= 300) { gagal('http', 'HTTP ' + req.status); return }

        let data
        try { data = JSON.parse(req.responseText) }
        catch (e) { gagal('json', 'JSON tidak valid: ' + e.message); return }

        sukses(data)          // di luar try: galat di sini bukan "JSON rusak"
    }
    req.open('GET', url)
    req.send()
}
```

### 3.2 Siklus `readyState`

```
 UNSENT(0) --open()--> OPENED(1) --send()--> HEADERS_RECEIVED(2) --> LOADING(3) --> DONE(4)
     ^                                                                      (LOADING bisa berulang)
     +------------------------------- abort() ------------------------------ (kembali ke UNSENT)
```

Setiap perubahan memancarkan `readystatechange`. Untuk mengamatinya:

```qml
req.onreadystatechange = function () { console.log('readyState =', req.readyState) }
```

Biasanya terlihat urutan 1, 2, 3, 4. Tahap 3 bisa muncul lebih dari sekali untuk respons besar.

### 3.3 Metode dan properti penting

| Anggota | Fungsi |
|---|---|
| `open(metode, url, async)` | Argumen ketiga default `true` (asinkron) |
| `send(data)` | Argumen opsional untuk badan (POST) |
| `setRequestHeader(nama, nilai)` | Menambah header pada permintaan berikutnya |
| `getResponseHeader(nama)` / `getAllResponseHeaders()` | Membaca header respons |
| `abort()` | Membatalkan. `readyState` kembali `UNSENT` dan sinyal dipancarkan |
| `responseText` | Isi respons sebagai teks (UTF-16) |
| `response` / `responseType` | String, `ArrayBuffer`, atau `Document` tergantung tipe respons |
| `responseURL` | URL akhir setelah pengalihan (redirect) |
| `status` / `statusText` | Kode dan pesan HTTP |

**Contoh POST dengan header:**

```qml
const req = new XMLHttpRequest()
req.onreadystatechange = function () { /* ... seperti di atas ... */ }
req.open('POST', 'https://api.contoh.id/v1/produk')
req.setRequestHeader('Content-Type', 'application/json')
req.setRequestHeader('Authorization', 'Bearer ' + token)    // token tidak pernah di URL
req.send(JSON.stringify({ nama: 'Kopi', harga: 15000 }))
```

### 3.4 Fakta lingkungan yang perlu diketahui

- XHR QML adalah implementasi **sebagian** dari XHR Level 1 dan **tidak menegakkan same-origin policy**.
- Pustaka peramban seperti `window`, DOM, dan `fetch` **tidak ada** di lingkungan QML. Yang tersedia: `XMLHttpRequest` dan `Timer`.
- Membaca atau menulis **berkas lokal** lewat XHR dinonaktifkan secara default. Mengaktifkannya butuh variabel lingkungan `QML_XHR_ALLOW_FILE_READ` atau `QML_XHR_ALLOW_FILE_WRITE` bernilai `1`, dan dokumentasi memperingatkan agar dipakai hanya pada aplikasi yang menjalankan QML dan JavaScript tepercaya.
- `QML_XHR_DUMP=1` mencatat metode, URL, badan permintaan dan respons, serta galat jaringan. Alat debug yang bagus, tetapi **jangan dipakai di produksi** karena bisa membocorkan token (7.4.8).

### 3.5 Opsi lain untuk logika yang sama (mengambil data)

| Opsi | Catatan |
|---|---|
| XHR + callback | Paling terbukti di QML |
| XHR dibungkus `Promise` (7.4.4) | Rantai `.then/.catch` |
| Komponen `PermintaanJson` (7.4.3) | Sinyal `berhasil` dan `gagal`, timeout bawaan |
| C++ `QNetworkAccessManager` (7.4.6) | Kontrol penuh, TLS, unggah besar |

Jebakan: J2, J3, J4, J9, J13.

---

## 4. 7.4.2 `JSON.parse` dan validasi

> Percaya itu mahal. Memeriksa itu murah.

`JSON.parse(teks)` **hanya memeriksa sintaks**, bukan makna. Data yang sintaksnya benar tetap bisa memiliki bentuk yang salah: kunci hilang, tipe salah, nilai di luar rentang, atau jumlah baris yang ekstrem. Itu sebabnya perlu **gerbang bentuk** sebelum data masuk model.

Catatan runtime: operator `?.` (sejak Qt 6.2) dan `??` (sejak Qt 5.15) tersedia di QML dan berguna untuk validasi.

**Contoh B: gerbang bentuk yang ketat**

```qml
import QtQuick

Item {
    function bersihkanProduk(mentah) {
        if (mentah === null || typeof mentah !== 'object' || Array.isArray(mentah)) return null

        const nama = typeof mentah.nama === 'string' ? mentah.nama.trim() : ''
        const harga = mentah.harga

        if (nama === '' || nama.length > 80) return null
        if (typeof harga !== 'number' || !Number.isFinite(harga) || harga < 0 || harga > 1e9) return null

        return { nama: nama, harga: Math.round(harga) }    // hanya kunci yang dikenal
    }

    Component.onCompleted: {
        const uji = [
            { nama: 'Kopi', harga: 15000 },
            { nama: '  Teh ', harga: 8000.4 },
            { nama: '', harga: 5 },
            { nama: 'Susu', harga: '12000' },
            { nama: 'X', harga: -1 },
            null, 42, [1, 2],
            { nama: 'Y'.repeat(100), harga: 1 }
        ]
        for (let i = 0; i < uji.length; ++i)
            console.log(i, JSON.stringify(bersihkanProduk(uji[i])))
        Qt.quit()
    }
}
```

**Keluaran yang diharapkan:**

```
qml: 0 {"nama":"Kopi","harga":15000}
qml: 1 {"nama":"Teh","harga":8000}
qml: 2 null
qml: 3 null
qml: 4 null
qml: 5 null
qml: 6 null
qml: 7 null
qml: 8 null
```

| Potongan | Arti |
|---|---|
| `mentah === null \|\| typeof mentah !== 'object' \|\| Array.isArray(mentah)` | Hanya objek biasa yang lolos. `typeof null` adalah `'object'` dan array juga `'object'`, jadi keduanya perlu diperiksa eksplisit. |
| `mentah.nama.trim()` | Membuang spasi di ujung. |
| `typeof harga !== 'number'` | **Tidak** memaksa string menjadi angka. `'12000'` ditolak. Ini keputusan kontrak: ketat lebih aman, sedangkan Modul 7.1 memakai `Number()` yang lebih longgar. |
| `Number.isFinite` | Menolak `NaN` dan `Infinity`. |
| `1e9` | Notasi ilmiah: 1.000.000.000 sebagai batas atas. |
| `return { nama, harga }` | Objek **baru** hanya berisi kunci yang dikenal. Kunci asing, termasuk kunci seperti `__proto__`, tidak ikut terbawa. |

**Gerbang untuk daftar** (batas jumlah dan penghitungan penolakan):

```qml
function bersihkanDaftar(data, maks) {
    if (!Array.isArray(data)) return null
    const hasil = []
    let ditolak = 0
    for (let i = 0; i < data.length; ++i) {
        if (hasil.length >= maks) { ditolak += data.length - i; break }
        const b = bersihkanProduk(data[i])
        if (b === null) ++ditolak
        else hasil.push(b)
    }
    return { item: hasil, ditolak: ditolak }
}
```

Kesalahan umum dalam validasi: memakai `if (obj.harga)` (nol dianggap salah), tidak membatasi panjang string dan jumlah baris, menyalin objek mentah ke model (`produk.append(data[i])`), dan tidak menangani `null`.

**Opsi lain untuk pemeriksaan bentuk:**

| Opsi | Catatan |
|---|---|
| Fungsi pembersih buatan sendiri (di atas) | Sederhana, bisa disesuaikan |
| Tabel skema (`{ nama: 'string', harga: 'number' }`) + pemeriksa generik | Lebih ringkas untuk banyak jenis data |
| Validasi di C++ (`QJsonDocument`) | Untuk data besar atau skema ketat (7.4.6) |

Jebakan: J5, J16, J18.

---

## 5. 7.4.3 Penanganan galat (jaringan, HTTP, parsing)

> Galat yang diberi nama sudah setengah diselesaikan.

Tiga jenis kegagalan yang berbeda, dan sebuah klasifikasi yang rapi:

| Jenis | Ciri | Penanganan lazim |
|---|---|---|
| `jaringan` | `status === 0`: tak ada respons HTTP (putus, ditolak, DNS gagal) | Informasikan, tawarkan coba lagi |
| `http` | `status` di luar 2xx (404, 500, ...) | 4xx: galat permintaan. 5xx: galat server (boleh coba lagi) |
| `json` | `JSON.parse` melempar galat | Respons rusak: jangan coba lagi tanpa alasan |
| `bentuk` | JSON sah tetapi tidak sesuai skema | Tolak, catat |
| `timeout` | Batas waktu terlewati | Bisa coba lagi |
| `ukuran` | Respons melewati batas | Tolak |
| `batal` | Dibatalkan pengguna atau kode | Abaikan |

Pada galat jaringan, `status` umumnya bernilai `0`. Konfirmasi di mesin Anda dengan lab di bawah dan `QML_XHR_DUMP=1`.

### 5.1 Komponen `PermintaanJson`

Pola yang sering dipakai ulang sebaiknya dibungkus komponen (Modul 5.1) dengan API yang jelas: properti, sinyal, dan metode.

```qml
// PermintaanJson.qml
import QtQuick

QtObject {
    id: root

    property int batasWaktuMs: 5000
    property int maksByte: 1000000
    readonly property bool sibuk: !_selesai

    signal berhasil(var data)
    signal gagal(string jenis, string pesan, int status)

    property bool _selesai: true
    property var _req: null

    property Timer _pewaktu: Timer {
        interval: root.batasWaktuMs
        onTriggered: {
            if (root._req) root._req.abort()
            root._akhiri('timeout', 'batas waktu ' + root.batasWaktuMs + ' ms terlewati', 0)
        }
    }

    function ambil(url) {
        if (!_selesai) return false
        _selesai = false
        const req = new XMLHttpRequest()
        _req = req

        req.onreadystatechange = function () {
            if (root._req !== req) return

            if (req.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                const panjang = parseInt(req.getResponseHeader('content-length'))
                if (!isNaN(panjang) && panjang > root.maksByte) {
                    req.abort()
                    root._akhiri('ukuran', 'respons terlalu besar', 0)
                }
                return
            }
            if (req.readyState !== XMLHttpRequest.DONE) return

            const status = req.status
            if (status === 0)
                return root._akhiri('jaringan', 'tidak ada respons (putus atau ditolak)', 0)
            if (status < 200 || status >= 300)
                return root._akhiri('http', 'HTTP ' + status, status)

            const teks = req.responseText
            if (teks.length > root.maksByte)
                return root._akhiri('ukuran', 'respons terlalu besar', status)

            let data
            try { data = JSON.parse(teks) }
            catch (e) { return root._akhiri('json', 'JSON tidak valid: ' + e.message, status) }

            root._akhiri(null, '', status, data)
        }

        req.open('GET', url)
        req.send()
        _pewaktu.restart()
        return true
    }

    function batal() {
        if (_req) _req.abort()
        _akhiri('batal', 'dibatalkan', 0)
    }

    function _akhiri(jenis, pesan, status, data) {
        if (_selesai) return
        _selesai = true
        _pewaktu.stop()
        _req = null
        if (jenis === null) berhasil(data)
        else gagal(jenis, pesan, status)
    }
}
```

**Penjelasan kata demi kata (bagian kunci):**

| Potongan | Arti |
|---|---|
| `QtObject` | Objek nirvisual. Komponen ini tidak menampilkan apa pun. |
| `signal berhasil(var data)` / `gagal(...)` | Keluaran komponen. Pemakai memasang `onBerhasil` dan `onGagal`. |
| `property Timer _pewaktu: Timer {...}` | Pewaktu sebagai properti berisi objek. Mengimplementasikan timeout. |
| Awalan `_` | Konvensi "privat". Bukan penegakan, hanya kesepakatan. |
| `root._req !== req` | Penjaga: abaikan peristiwa dari permintaan yang sudah usai atau digantikan. |
| `HEADERS_RECEIVED` + `content-length` | Menolak respons besar **sebelum** diunduh seluruhnya, bila server mengirim panjangnya. Respons berpotongan tidak punya header ini, jadi ada pemeriksaan kedua setelah selesai. |
| `req.abort()` | Membatalkan unduhan. |
| `_akhiri(...)` | **Satu-satunya** pintu keluar. Menjamin sinyal terpancar tepat sekali, pewaktu berhenti, dan referensi dilepas. |
| `return root._akhiri(...)` | Keluar dari handler setelah memanggil pintu keluar. |
| `jenis === null` | Cara internal menandakan sukses. |

### 5.2 Lab terminal: tiga galat berbeda

Siapkan server lokal (terminal pertama):

```bash
mkdir -p ~/lab74 && cd ~/lab74
cat > data.json <<'EOF'
[
  {"nama": "Kopi", "harga": 15000},
  {"nama": "Teh", "harga": 8000},
  {"nama": "", "harga": 1},
  {"nama": "Susu", "harga": "12000"},
  {"nama": "Cokelat", "harga": 20000}
]
EOF
printf '{"nama": "Kopi", "harga": \n' > rusak.json
python -m http.server 8000 --bind 127.0.0.1
```

Berkas pengujian `main.qml` di folder yang sama dengan `PermintaanJson.qml`:

```qml
import QtQuick

Item {
    id: root
    width: 320; height: 100

    PermintaanJson {
        id: permintaan
        batasWaktuMs: 2000
        onBerhasil: (data) => console.log('OK:', JSON.stringify(data).length, 'karakter')
        onGagal: (jenis, pesan, status) =>
            console.log('GAGAL [' + jenis + ']', pesan, '(status ' + status + ')')
    }

    property var daftarUji: [
        'http://127.0.0.1:8000/data.json',
        'http://127.0.0.1:8000/tidak-ada.json',
        'http://127.0.0.1:8000/rusak.json'
    ]
    property int langkah: 0

    Timer {
        interval: 400; repeat: true; running: true
        onTriggered: {
            if (permintaan.sibuk) return
            if (root.langkah >= root.daftarUji.length) { Qt.quit(); return }
            permintaan.ambil(root.daftarUji[root.langkah++])
        }
    }
}
```

Jalankan di terminal kedua (nama biner lihat bagian 11.3):

```bash
QT_QPA_PLATFORM=offscreen qml main.qml
```

**Keluaran yang diharapkan** (server hidup):

```
qml: OK: 189 karakter
qml: GAGAL [http] HTTP 404 (status 404)
qml: GAGAL [json] JSON tidak valid: <pesan dari mesin JSON> (status 200)
```

Panjang karakter pada baris pertama bergantung pada isi berkas Anda. Lalu **hentikan server** (Ctrl+C di terminal pertama) dan jalankan ulang. Ketiga permintaan semestinya menjadi `GAGAL [jaringan] ... (status 0)`. Untuk mengamati alasan jaringan di balik layar, tambahkan `QML_XHR_DUMP=1` di depan perintah.

**Uji timeout:** server yang menerima koneksi tetapi tidak pernah menjawab:

```bash
python -c "import socket,time; s=socket.socket(); s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); s.bind(('127.0.0.1', 8001)); s.listen(); c,_=s.accept(); time.sleep(30)"
```

Arahkan satu permintaan ke `http://127.0.0.1:8001/x`. Setelah 2 detik muncul `GAGAL [timeout]`.

Jebakan: J1, J2, J3, J4, J7.

---

## 6. 7.4.4 `Promise` dan keterbatasan `async/await`

> Alat yang tersedia lebih berharga daripada alat yang diharapkan.

Fakta dari dokumentasi: runtime QML mengimplementasikan **ECMAScript edisi ke-7**. `Promise` ada dalam daftar objek yang didukung. `async/await` baru muncul di edisi 2017, sehingga **tidak termasuk** tingkat bahasa itu. Sesuai catatan kurikulum, uji pada versi Qt Anda: tulis fungsi `async` di sebuah berkas lalu jalankan `qmllint`. Hasil yang diharapkan: galat sintaks. Demikian pula `Promise.prototype.finally` (2018) dan `Promise.allSettled` (2020) bukan bagian ES7, jadi jangan diandalkan tanpa uji.

Lingkungan QML juga **tidak menyediakan** `setTimeout` dan `fetch`. Gunakan `Timer` dan XHR.

**Membungkus XHR dengan `Promise`:**

```qml
function ambilJsonJanji(url) {
    return new Promise(function (resolve, reject) {
        ambilJson(url, resolve, function (jenis, pesan) {
            reject({ jenis: jenis, pesan: pesan })
        })
    })
}

Component.onCompleted: {
    ambilJsonJanji('http://127.0.0.1:8000/data.json')
        .then(function (d) { console.log('janji OK:', d.length, 'baris'); return d })
        .catch(function (e) { console.log('janji GAGAL:', e.jenis) })
}
```

Keluaran: `qml: janji OK: 5 baris`, dengan `ambilJson` dari 7.4.1 dan berkas `data.json` dari lab.

| Potongan | Arti |
|---|---|
| `new Promise(function (resolve, reject) {...})` | "Janji" yang bisa dipenuhi (`resolve`) atau ditolak (`reject`). |
| `.then(fungsi)` | Dijalankan saat janji dipenuhi. Boleh dirantai. |
| `.catch(fungsi)` | Dijalankan saat janji ditolak, atau saat ada galat di rantai sebelumnya. |
| `Promise.all([a, b])` | Menunggu semua janji (paralel). Ditolak bila satu ditolak. |

**Callback, sinyal, atau `Promise`?** Dokumentasi tidak melarang `Promise`, tetapi pola yang paling terbukti dan paling mudah diperiksa alat di QML adalah **sinyal dan callback**, sebagaimana catatan kurikulum. Perbedaan perilaku yang penting: galat di dalam `.then` akan jatuh ke `.catch`, sedangkan galat di callback biasa tidak. Dan penolakan tanpa `.catch` bisa lenyap diam-diam, jadi **selalu** tambahkan `.catch`.

**Opsi lain:**

| Opsi | Cocok untuk |
|---|---|
| Sinyal dan callback | Alur UI umum |
| `Promise` + `.then/.catch` | Merangkai beberapa langkah, `Promise.all` |
| Mesin status (`State`, Modul 6.1) | UI yang bereaksi pada keadaan `memuat/siap/galat` |

Jebakan: J8, J9.

---

## 7. 7.4.5 `WorkerScript`

> Biarkan thread UI hanya melakukan yang hanya ia bisa lakukan.

`WorkerScript` (modul `QtQml.WorkerScript`) menjalankan JavaScript di **thread terpisah**. Cocok untuk pekerjaan CPU berat dalam JS tanpa membekukan layar.

**Aturan dari dokumentasi:**

- `import QtQml.WorkerScript` wajib.
- `source` menunjuk berkas yang mengimplementasikan `WorkerScript.onMessage`. Ekstensi **`.mjs`** berarti modul ES dalam mode ketat. Ekstensi `.js` berarti skrip biasa non-ketat.
- Setiap `WorkerScript` memiliki **mesin JavaScript sendiri**, terisolasi sempurna dan aman thread, tetapi boros memori bila banyak. Bagi satu worker untuk beberapa tugas.
- Worker **tidak dapat** mengakses properti, metode, atau context property objek QML.
- Pesan (`sendMessage`) hanya boleh berisi: boolean, angka, string, objek dan array JavaScript, atau objek `ListModel`. Semuanya **disalin**, kecuali `ListModel`.

**Contoh C: pekerjaan berat dan bukti UI tetap hidup**

`berat.mjs`:

```js
function prima(n) {
    if (n < 2) return false
    for (let i = 2; i * i <= n; ++i) if (n % i === 0) return false
    return true
}

WorkerScript.onMessage = function (pesan) {
    let jumlah = 0
    for (let k = 2; k <= pesan.batas; ++k) if (prima(k)) ++jumlah
    WorkerScript.sendMessage({ batas: pesan.batas, jumlah: jumlah })
}
```

`main.qml`:

```qml
import QtQuick
import QtQml.WorkerScript

Item {
    id: root
    width: 300; height: 160
    focus: true

    property int frame: 0
    property double mulai: 0
    property int batas: 300000        // sesuaikan agar kerja terasa beberapa detik di mesin Anda

    Rectangle {
        x: 20; y: 20; width: 40; height: 40; color: 'tomato'
        RotationAnimation on rotation { from: 0; to: 360; duration: 1000; loops: Animation.Infinite }
        onRotationChanged: root.frame++
    }

    Text { id: hasil; x: 20; y: 90; text: 'Tekan P (pekerja) atau U (thread UI)' }

    WorkerScript {
        id: pekerja
        source: 'berat.mjs'
        onMessage: (m) => root.selesai('pekerja', m.jumlah)
    }

    function prima(n) {
        if (n < 2) return false
        for (let i = 2; i * i <= n; ++i) if (n % i === 0) return false
        return true
    }

    function selesai(mode, jumlah) {
        const ms = Date.now() - mulai
        hasil.text = mode + ': ' + jumlah + ' prima'
        console.log('mode =', mode, '| ms =', ms, '| frame animasi selama kerja =', frame)
    }

    function mulaiUkur() { frame = 0; mulai = Date.now() }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_P) {
            mulaiUkur()
            pekerja.sendMessage({ batas: batas })
            event.accepted = true
        } else if (event.key === Qt.Key_U) {
            mulaiUkur()
            let j = 0
            for (let k = 2; k <= batas; ++k) if (prima(k)) ++j
            selesai('thread-UI', j)
            event.accepted = true
        }
    }
}
```

Jalankan **dengan jendela**. Tekan `P`: kotak merah terus berputar, dan `frame animasi selama kerja` bernilai besar. Tekan `U`: layar membeku selama kerja, dan jumlah frame yang tercatat kecil atau nol. Fungsi `prima` diduplikasi hanya untuk demonstrasi.

| Potongan | Arti |
|---|---|
| `RotationAnimation on rotation {...}` | Animasi tanpa akhir pada properti `rotation`. |
| `onRotationChanged: root.frame++` | Menghitung berapa kali animasi benar-benar menggambar ulang. |
| `pekerja.sendMessage({ batas: batas })` | Mengirim objek ke worker (disalin). |
| `onMessage: (m) => ...` | Menerima jawaban worker. |
| `WorkerScript.onMessage = function (pesan)` | Handler di sisi worker. |
| `WorkerScript.sendMessage({...})` | Jawaban dari worker ke thread UI. |
| `Date.now()` | Penanda waktu dalam milidetik. |

**Contoh D: worker mengisi `ListModel`**

`isi_model.mjs`:

```js
function bersihkanProduk(mentah) {
    if (mentah === null || typeof mentah !== 'object' || Array.isArray(mentah)) return null
    const nama = typeof mentah.nama === 'string' ? mentah.nama.trim() : ''
    const harga = mentah.harga
    if (nama === '' || nama.length > 80) return null
    if (typeof harga !== 'number' || !Number.isFinite(harga) || harga < 0 || harga > 1e9) return null
    return { nama: nama, harga: Math.round(harga) }
}

WorkerScript.onMessage = function (pesan) {
    let data
    try { data = JSON.parse(pesan.teks) }
    catch (e) {
        WorkerScript.sendMessage({ ok: false, jenis: 'json', pesan: e.message })
        return
    }
    if (!Array.isArray(data)) {
        WorkerScript.sendMessage({ ok: false, jenis: 'bentuk', pesan: 'bukan array' })
        return
    }

    pesan.model.clear()
    let diterima = 0
    let ditolak = 0
    for (let i = 0; i < data.length; ++i) {
        if (diterima >= pesan.maks) { ditolak += data.length - i; break }
        const b = bersihkanProduk(data[i])
        if (b === null) { ++ditolak; continue }
        pesan.model.append(b)
        ++diterima
    }
    pesan.model.sync()
    WorkerScript.sendMessage({ ok: true, diterima: diterima, ditolak: ditolak })
}
```

`main.qml`:

```qml
import QtQuick
import QtQml.WorkerScript

Item {
    id: root
    width: 300; height: 120

    ListModel { id: produk }

    WorkerScript {
        id: pekerja
        source: 'isi_model.mjs'
        onMessage: (m) => {
            console.log('worker selesai:', JSON.stringify(m), '| count model =', produk.count)
            Qt.quit()
        }
    }

    Component.onCompleted: {
        const mentah = JSON.stringify([
            { nama: 'Kopi', harga: 15000 },
            { nama: '', harga: 1 },
            { nama: 'Teh', harga: 8000 }
        ])
        pekerja.sendMessage({ model: produk, teks: mentah, maks: 500 })
    }
}
```

**Keluaran yang diharapkan** (urutan kunci JSON bisa berbeda; `count` biasanya sudah 2 saat pesan tiba):

```
qml: worker selesai: {"ok":true,"diterima":2,"ditolak":1} | count model = 2
```

| Potongan | Arti |
|---|---|
| `pesan.model` | `ListModel` yang dikirim lewat pesan. Satu-satunya objek QML yang diizinkan, dan perubahannya **tidak disalin** tetapi dibagi. |
| `pesan.model.sync()` | **Wajib** setelah mengubah model dari thread kerja agar perubahan terlihat di thread UI (J11). |
| Gerbang validasi di dalam worker | Penguraian dan pembersihan terjadi di worker. Hanya data bersih yang masuk model. |
| `ok`, `jenis`, `pesan` | Struktur jawaban galat yang konsisten dengan 7.4.3. |

**Opsi lain untuk pekerjaan berat:**

| Opsi | Catatan |
|---|---|
| `WorkerScript` | Mudah, terisolasi, hanya JS. Pesan disalin |
| Memecah pekerjaan dengan `Timer` (potongan kecil per tick) | Tetap di thread UI, tetapi tak membeku total. Cocok untuk pekerjaan ringan-sedang |
| Thread di C++ (`QtConcurrent`, `QThread`) | Skala besar (7.4.6, Modul 10.7) |

Jebakan: J1, J10, J11, J12, J19.

---

## 8. 7.4.6 Kapan ke C++

> Alat paling tepat adalah yang paling cocok dengan beban kerja, bukan yang paling nyaman.

Pindah ke C++ bila:

1. Data **besar** (ratusan ribu baris atau berkas besar) dan parse/validasi JavaScript terasa lambat atau memakan memori.
2. Perlu **kontrol TLS**: sertifikat khusus, pinning, konfigurasi cipher. Dokumentasi XHR QML tidak menyediakan API untuk itu. `QtNetwork` menyediakan (`QSslConfiguration`).
3. Perlu **unggah/unduh besar dengan kemajuan**, proksi, otentikasi (OAuth), atau **WebSocket** (`QtWebSockets`).
4. Data menjadi **model bertipe kuat** (`QAbstractListModel`, 7.1.4) yang dibagi dengan logika C++.
5. Perlu **multithreading terstruktur** dan pengujian unit.

**Pratinjau (Modul 10.7 membahasnya penuh):** pengambil JSON di C++ yang menolak skema selain HTTPS.

```cpp
// pengambil.h (cuplikan)
#pragma once
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QUrl>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

class Pengambil : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Pengambil(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void ambil(const QUrl &url)
    {
        if (url.scheme() != QLatin1String("https")) {
            emit gagal(QStringLiteral("url"), QStringLiteral("hanya https"));
            return;
        }
        QNetworkReply *balasan = m_nam.get(QNetworkRequest(url));
        connect(balasan, &QNetworkReply::finished, this, [this, balasan] {
            balasan->deleteLater();
            if (balasan->error() != QNetworkReply::NoError) {
                emit gagal(QStringLiteral("jaringan"), balasan->errorString());
                return;
            }
            QJsonParseError galat;
            const QJsonDocument dok = QJsonDocument::fromJson(balasan->readAll(), &galat);
            if (galat.error != QJsonParseError::NoError || !dok.isArray()) {
                emit gagal(QStringLiteral("json"), galat.errorString());
                return;
            }
            emit berhasil(dok.array().toVariantList());
        });
    }

signals:
    void berhasil(const QVariantList &data);
    void gagal(const QString &jenis, const QString &pesan);

private:
    QNetworkAccessManager m_nam;
};
```

| Potongan | Arti |
|---|---|
| `QML_ELEMENT` | Menjadikan kelas tersedia sebagai tipe QML. |
| `Q_INVOKABLE` | Metode bisa dipanggil dari QML. |
| `QNetworkAccessManager` | Pengelola permintaan jaringan Qt. |
| `connect(balasan, &QNetworkReply::finished, ...)` | Menangani selesainya balasan secara asinkron. |
| `balasan->deleteLater()` | Membersihkan objek balasan dengan aman. |
| `QJsonDocument::fromJson(..., &galat)` | Parse JSON dengan laporan galat terperinci. |
| `signals:` | Sinyal yang akan ditangkap QML (`onBerhasil`, `onGagal`). |

Proyek CMake perlu menautkan modul jaringan (`Qt6::Network`).

---

## 9. 7.4.7 (TAMBAHAN) Ketangguhan: timeout, pembatalan, urutan, dan ulang-coba

> Jaringan yang andal tidak ada. Yang ada hanya aplikasi yang tangguh.

### 9.1 Timeout dan pembatalan

Sudah ada di `PermintaanJson` (7.4.3): `batasWaktuMs` dan `batal()`. Ingat bahwa XHR QML tidak mendokumentasikan properti `timeout` dan sinyal `onerror`/`ontimeout`, sehingga timeout dibuat sendiri dengan `Timer` dan `abort()`.

### 9.2 Balapan respons: yang terbaru menang

Pengguna mengetik cepat: permintaan A (lambat) dan B (cepat) berangkat. Jika A tiba setelah B, hasil usang menimpa hasil baru. Solusinya **nomor urut**:

```qml
property int nomorTerakhir: 0

function cari(kata) {
    const nomor = ++nomorTerakhir
    ambilJson('http://127.0.0.1:8000/cari?q=' + encodeURIComponent(kata),
        function (data) {
            if (nomor !== nomorTerakhir) return        // ada permintaan yang lebih baru: abaikan
            terapkan(data)
        },
        tanganiGalat)
}
```

`encodeURIComponent` melindungi URL dari karakter khusus dalam masukan pengguna. Lengkapi dengan **debounce** (menunda sampai pengguna berhenti mengetik):

```qml
Timer {
    id: tunda
    interval: 300
    onTriggered: root.cari(kolom.text)
}
// di setiap perubahan teks:  tunda.restart()
```

### 9.3 Ulang-coba dengan backoff

```qml
property int percobaan: 0

Timer { id: jedaUlang; onTriggered: root.coba() }

function coba() { permintaan.ambil(url) }

function jadwalkanUlang() {
    if (percobaan >= 3) { gagalTotal(); return }
    jedaUlang.interval = Math.min(1000 * Math.pow(2, percobaan), 8000)   // 1s, 2s, 4s (maks 8s)
    ++percobaan
    jedaUlang.start()
}
```

**Aturan ulang-coba:**

- Hanya untuk galat **sementara**: `jaringan`, `timeout`, dan HTTP 5xx.
- **Jangan** ulangi untuk 4xx, `json`, atau `bentuk`: hasilnya tak akan berubah.
- Hanya untuk permintaan **idempoten** (GET, bukan POST yang membuat sesuatu).
- Beri batas jumlah percobaan dan batas jeda.

Jebakan: J6, J7.

---

## 10. 7.4.8 (TAMBAHAN) Keamanan data jaringan dan studi kasus ujung ke ujung

> Kepercayaan diberikan sedikit demi sedikit, dan hanya setelah diperiksa.

### 10.1 Daftar periksa keamanan

| Area | Praktik |
|---|---|
| **Transport** | HTTPS. Muat sumber daya dari berkas lokal atau `qrc`, dan bila perlu lewat jaringan, gunakan HTTPS atau jaringan tepercaya (anjuran dokumentasi Qt) |
| **Host dan URL** | XHR tidak menegakkan same-origin. Batasi dengan **daftar putih awalan URL**. Periksa `responseURL` bila ada pengalihan |
| **Rahasia** | Token di header `Authorization`, **bukan** di URL. Jangan memakai `QML_XHR_DUMP` di produksi |
| **Berkas lokal** | Biarkan `QML_XHR_ALLOW_FILE_READ/WRITE` mati, kecuali pada aplikasi yang menjalankan QML tepercaya |
| **Ukuran dan jumlah** | Batas `content-length`, panjang teks, jumlah baris, panjang string |
| **Bentuk** | Gerbang validasi (7.4.2). Salin hanya kunci yang dikenal |
| **Tampilan** | `Text.PlainText`. Jangan jadikan data URL `Loader.source` atau teks `Qt.createQmlObject` (7.3) |
| **Isolasi** | Parse data besar di worker agar kegagalannya tidak membekukan UI |

**Daftar putih URL:**

```qml
readonly property var awalanDiizinkan: ['https://api.contoh.id/v1/', 'http://127.0.0.1:8000/']

function urlAman(url) {
    return typeof url === 'string' && awalanDiizinkan.some(a => url.startsWith(a))
}
```

Awalan **harus** menyertakan garis miring setelah host. Awalan seperti `https://api.contoh.id` tanpa garis miring bisa dicocokkan oleh host yang berbeda, misalnya `https://api.contoh.id.penyerang.example/`. Alamat lab `http://127.0.0.1:8000/` sengaja dibuat untuk pengujian lokal. Di produksi, jangan izinkan HTTP polos.

### 10.2 Studi kasus: dari jaringan ke layar

Studi kasus ini merangkai seluruh Fase 7: gerbang validasi (7.1), `ListView` dengan keadaan (7.2), daftar putih (7.3), dan XHR yang tangguh (7.4).

Pakai server lab dan `PermintaanJson.qml` dari 7.4.3. `main.qml`:

```qml
pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root
    width: 360; height: 280
    focus: true

    property string keadaan: 'idle'          // idle | memuat | siap | kosong | galat
    property string pesanGalat: ''
    readonly property int maksBaris: 500
    readonly property var awalanDiizinkan: ['http://127.0.0.1:8000/']

    ListModel { id: produk }

    function urlAman(url) {
        return typeof url === 'string' && awalanDiizinkan.some(a => url.startsWith(a))
    }

    function bersihkanProduk(mentah) {
        if (mentah === null || typeof mentah !== 'object' || Array.isArray(mentah)) return null
        const nama = typeof mentah.nama === 'string' ? mentah.nama.trim() : ''
        const harga = mentah.harga
        if (nama === '' || nama.length > 80) return null
        if (typeof harga !== 'number' || !Number.isFinite(harga) || harga < 0 || harga > 1e9) return null
        return { nama: nama, harga: Math.round(harga) }
    }

    function terapkan(data) {
        if (!Array.isArray(data)) { gagalkan('bentuk', 'respons bukan array'); return }
        produk.clear()
        let ditolak = 0
        for (let i = 0; i < data.length; ++i) {
            if (produk.count >= maksBaris) { ditolak += data.length - i; break }
            const b = bersihkanProduk(data[i])
            if (b === null) ++ditolak
            else produk.append(b)
        }
        keadaan = produk.count > 0 ? 'siap' : 'kosong'
        console.log('diterima:', produk.count, '| ditolak:', ditolak)
    }

    function gagalkan(jenis, pesan) {
        keadaan = 'galat'
        pesanGalat = '[' + jenis + '] ' + pesan
        console.warn(pesanGalat)
    }

    function muat(url) {
        if (!urlAman(url)) { gagalkan('url', 'URL tidak diizinkan'); return }
        keadaan = 'memuat'
        if (!permintaan.ambil(url)) console.warn('permintaan sebelumnya masih berjalan')
    }

    PermintaanJson {
        id: permintaan
        batasWaktuMs: 3000
        onBerhasil: (data) => root.terapkan(data)
        onGagal: (jenis, pesan, status) =>
            root.gagalkan(jenis, pesan + (status ? ' (status ' + status + ')' : ''))
    }

    ListView {
        anchors { fill: parent; margins: 8 }
        clip: true
        spacing: 4
        visible: root.keadaan === 'siap'
        model: produk
        delegate: Rectangle {
            id: baris
            required property string nama
            required property int harga
            width: ListView.view.width; height: 34; radius: 4; color: '#eeeeee'
            Text {
                x: 10; anchors.verticalCenter: parent.verticalCenter
                textFormat: Text.PlainText
                text: baris.nama + ' — ' + baris.harga
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.keadaan !== 'siap'
        textFormat: Text.PlainText
        text: root.keadaan === 'memuat' ? 'Memuat…'
            : root.keadaan === 'galat' ? 'Galat: ' + root.pesanGalat
            : root.keadaan === 'kosong' ? 'Tidak ada data'
            : 'R = muat | X = 404 | J = JSON rusak | E = URL terlarang'
    }

    Keys.onPressed: (event) => {
        const url = 'http://127.0.0.1:8000/'
        if (event.key === Qt.Key_R)      root.muat(url + 'data.json')
        else if (event.key === Qt.Key_X) root.muat(url + 'tidak-ada.json')
        else if (event.key === Qt.Key_J) root.muat(url + 'rusak.json')
        else if (event.key === Qt.Key_E) root.muat('http://penyerang.example/x.json')
        else return
        event.accepted = true
    }
}
```

**Keluaran di terminal saat menekan `R`** (dengan `data.json` dari lab, yang berisi 5 baris dengan 2 baris tak valid):

```
qml: diterima: 3 | ditolak: 2
```

Tekan `X` memunculkan `[http] HTTP 404 (status 404)`. Tekan `J` memunculkan `[json] JSON tidak valid: ...`. Tekan `E` memunculkan `[url] URL tidak diizinkan` **tanpa** pernah mengirim permintaan.

**Penjelasan alur:**

| Tahap | Gerbang |
|---|---|
| `muat(url)` | Gerbang URL (`urlAman`) |
| `PermintaanJson` | Gerbang transport (status 2xx, timeout, ukuran) dan format (`JSON.parse`) |
| `terapkan(data)` | Gerbang bentuk (`bersihkanProduk`, batas `maksBaris`) |
| Delegate | Gerbang tampilan (`Text.PlainText`) |
| `keadaan` | Satu variabel yang menentukan apa yang tampil: memuat, siap, kosong, atau galat |

Jebakan: J13, J14, J15, J16, J17, J18.

---

## 11. Penutup modul

### 11.1 Hubungan dengan modul lain

- **Prasyarat:** 2.x (JSON, callback, `Promise`), 3.x (sinyal), 5.1 (komponen sebagai API, dipakai untuk `PermintaanJson`), 6.x (`Timer`, `State`), 7.1 (gerbang validasi dan `ListModel`), 7.3 (daftar putih dan larangan mengeksekusi data).
- **Fase 7 berakhir di sini.** Alur lengkapnya: **jaringan (7.4) → gerbang → model (7.1) → view (7.2) → objek dinamis bila perlu (7.3)**.
- **Modul 10.x (C++):** `QNetworkAccessManager`, `QJsonDocument`, model C++, dan thread terstruktur (10.5, 10.7).
- **Fase 13 (keamanan):** daftar putih URL, validasi masukan, batas sumber daya, rahasia dan token.

### 11.2 Tabel kesalahan umum

| ID | Gejala | Penyebab | Solusi |
|---|---|---|---|
| J1 | UI membeku saat memproses data | Parse dan validasi data besar di thread UI | `WorkerScript` atau C++ |
| J2 | Galat jaringan tampil sebagai "HTTP 0" | `status === 0` tidak dibedakan | Cabangkan: 0 jaringan, di luar 2xx HTTP |
| J3 | Respons sah 204/206 dianggap gagal | Hanya menerima `status === 200` | Terima rentang 2xx sesuai kontrak API |
| J4 | Galat di callback sukses dilaporkan "JSON tidak valid" | `try` membungkus callback | `parse` di `try`, callback di luar |
| J5 | Aplikasi rusak karena data tak terduga | Menganggap JSON selalu sesuai bentuk | Gerbang bentuk (7.4.2) |
| J6 | Hasil lama menimpa hasil baru | Balapan respons | Nomor urut, `abort()`, debounce |
| J7 | Aplikasi menunggu selamanya | Tidak ada timeout | `Timer` + `abort()` |
| J8 | Galat sintaks pada `async`/`await` atau `.finally` | Runtime mengimplementasikan ES7 | `Promise` `.then/.catch` atau callback; uji dulu |
| J9 | `fetch`, `setTimeout`, atau `window` tak dikenal | Lingkungan QML bukan peramban | XHR dan `Timer` |
| J10 | `WorkerScript` tak berfungsi | Lupa `import QtQml.WorkerScript`, jalur `source` salah, atau worker mengakses objek QML | Impor modul, periksa jalur, kirim data lewat pesan |
| J11 | Perubahan `ListModel` dari worker tak terlihat | Lupa `sync()` | Panggil `model.sync()` setelah mengubah |
| J12 | Pesan ke worker gagal | Mengirim tipe yang tak diizinkan (objek QML selain `ListModel`) | Kirim boolean, angka, string, objek dan array JS, atau `ListModel` |
| J13 | XHR gagal membaca berkas lokal | Akses berkas dinonaktifkan secara default | Pakai `qrc`; env var hanya untuk QML tepercaya |
| J14 | Token bocor | Token di URL atau log (`QML_XHR_DUMP`) | Header `Authorization`; matikan dump di produksi |
| J15 | Aplikasi meminta host tak terduga | XHR tak menegakkan same-origin; URL dari data | Daftar putih awalan URL |
| J16 | Teks dari server tampil sebagai HTML | `Text` default `AutoText` | `textFormat: Text.PlainText` |
| J17 | Kode asing berjalan | Respons dimasukkan ke `Qt.createQmlObject` atau `Loader.source` | Jangan; daftar putih (7.3) |
| J18 | Memori melonjak | Respons raksasa atau jumlah baris tak terbatas | Batas `content-length`, panjang, dan jumlah baris |
| J19 | Memori boros | Banyak `WorkerScript` (satu mesin JS tiap worker) | Bagi satu worker untuk beberapa tugas |

### 11.3 Latihan 15 menit

**Persiapan terminal (Arch).** Cari nama biner QML:

```bash
pacman -Q qt6-declarative
pacman -Ql qt6-declarative | grep -E 'bin/(qml|qmllint|qmlformat)'
```

Pakai nama yang muncul, misalnya jika `qml`:

```bash
qml main.qml                                   # dengan jendela (untuk tombol)
QT_QPA_PLATFORM=offscreen qml main.qml         # tanpa jendela (untuk skrip yang mencetak log)
QML_XHR_DUMP=1 QT_QPA_PLATFORM=offscreen qml main.qml    # tampilkan rincian permintaan
qmllint main.qml
```

**Langkah:**

1. Siapkan lab seperti di 7.4.3: `data.json`, `rusak.json`, dan server `python -m http.server 8000 --bind 127.0.0.1`.
2. Sesuai kurikulum: ubah `ambilJson` (7.4.1) agar mengembalikan galat berbeda untuk **jaringan putus**, **HTTP 404**, dan **JSON rusak**. Uji ketiganya: `data.json` (sukses), `tidak-ada.json` (404), `rusak.json` (JSON rusak). Lalu hentikan server untuk menguji jaringan putus.
3. Jalankan `main.qml` dari 7.4.3 dan cocokkan keluarannya. Ulangi dengan `QML_XHR_DUMP=1` dan perhatikan apa yang dicatat.
4. Jalankan studi kasus 7.4.8. Tekan `R`, `X`, `J`, `E` dan amati keadaan UI serta log.
5. Jalankan `qmllint` pada semua berkas dan rapikan peringatannya.

**Tantangan 10 menit:** uji timeout dengan server yang tidak pernah menjawab (perintah `python -c ...` di 7.4.3), lalu tambahkan **ulang-coba dengan backoff** (7.4.7) sehingga `timeout` dicoba ulang tiga kali sebelum menyerah, sementara `http 404` tidak diulang. Setelah itu jalankan Contoh C (7.4.5), bandingkan `P` dan `U`, lalu jelaskan hasilnya dengan kata-kata Anda sendiri.

### 11.4 Cek pemahaman

1. Mengapa respons jaringan harus divalidasi sebelum dipakai?
2. Apa beda `status === 0` dengan `status === 404`?
3. Mengapa `parse` sebaiknya di dalam `try` saja dan bukan callback sukses?
4. Kapan memilih `WorkerScript` dibanding XHR, dan kapan C++?
5. Mengapa XHR QML tak menegakkan same-origin policy, sehingga aplikasi perlu daftar putih URL?
6. Mengapa `sync()` diperlukan setelah mengubah `ListModel` di worker?
7. Bagaimana mencegah hasil permintaan lama menimpa hasil baru?

**Jawaban singkat:**

1. `JSON.parse` hanya menjamin sintaks, bukan makna. Data luar bisa salah bentuk, terlalu besar, atau berbahaya. Gerbang validasi menjaga model dan UI.
2. `0` berarti tidak ada respons HTTP sama sekali (jaringan putus, ditolak). `404` berarti server menjawab bahwa sumber tidak ada. Penanganannya berbeda.
3. Jika callback ikut di dalam `try`, galat di kode Anda sendiri akan disalahlaporkan sebagai JSON rusak. Parse yang terisolasi menjaga diagnosis tetap benar.
4. XHR untuk menunggu jaringan (sudah asinkron). `WorkerScript` untuk pekerjaan CPU berat dalam JS. C++ untuk data sangat besar, TLS khusus, WebSocket, atau thread terstruktur.
5. Dokumentasi menyatakan XHR QML tidak menegakkan kebijakan itu. Tanpa pagar dari aplikasi, kode bisa meminta ke host mana pun, termasuk yang dipengaruhi data luar.
6. Worker berjalan di thread lain. `sync()` mendorong perubahan agar terlihat di thread UI.
7. Beri tiap permintaan nomor urut dan abaikan hasil yang nomornya bukan yang terbaru, atau `abort()` permintaan lama dan tambahkan debounce.

### 11.5 Referensi

Tautan `doc.qt.io` di bawah ini muncul pada halaman dokumentasi Qt 6.12 yang saya baca saat menyusun materi ini. Tautan MDN dan Qt Network tidak saya buka ulang, jadi periksa sendiri bila berubah.

- [The XMLHttpRequest JavaScript Object](https://doc.qt.io/qt-6/qml-qtqml-xmlhttprequest.html)
- [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html)
- [WorkerScript](https://doc.qt.io/qt-6/qml-qtqml-workerscript-workerscript.html) · [ListModel (termasuk `sync()`)](https://doc.qt.io/qt-6/qml-qtqml-models-listmodel.html)
- [Handling Untrusted Data](https://doc.qt.io/qt-6/untrusteddata.html) · [Security in Qt](https://doc.qt.io/qt-6/security.html)
- [Dynamic QML Object Creation from JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html)
- [W3C XMLHttpRequest Level 1](https://www.w3.org/TR/2014/WD-XMLHttpRequest-20140130/) · [ECMA-262](https://www.ecma-international.org/publications-and-standards/standards/ecma-262/)
- [MDN: XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) · [MDN: Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) · [MDN: JSON.parse](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse)
- C++: [QNetworkAccessManager](https://doc.qt.io/qt-6/qnetworkaccessmanager.html) · [QJsonDocument](https://doc.qt.io/qt-6/qjsondocument.html)
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

