# Fase 5 · Modul 5.1 — Komponen sebagai API

*Kurikulum Qt 6 QML · Fase 5 (Komponen, Layout, dan Styling) · Modul 1 dari 3 (5.1 → 5.2 → 5.3)*

## Daftar Isi Modul 5.1

- Audit singkat Fase 5 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 5.1.1 Prinsip: properti masuk, signal keluar
- 5.1.2 `root` sebagai id konvensional
- 5.1.3 Ukuran implisit
- 5.1.4 Menghindari akses ke induk
- 5.1.5 Konvensi penamaan dan gaya kode (beserta alat: qmllint, qmlformat, qmlls)
- 5.1.6 \[TAMBAHAN\] Keyboard, fokus, dan aksesibilitas
- 5.1.7 \[TAMBAHAN\] Opsi implementasi lain untuk logika yang sama
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Referensi tambahan

## Audit Singkat Fase 5 (sebelum materi dimulai)

Urutan Fase 5 (komponen → layout → tema) logis dan tidak melompat: 5.2 memakai `implicitWidth` yang diajarkan di 5.1, dan 5.3 mengganti angka mentah (`#2563eb`, `6`, `8`) dari 5.1 dengan token tema. Temuan yang dibereskan sebelum materi ditulis:

1. **\[Koreksi\] Latihan 5.1.** Latihan meminta “menambahkan properti `enabled`”, padahal `enabled` sudah properti bawaan setiap `Item`. Mendeklarasikan ulang properti bernama sama menimpa dan mengaburkan yang bawaan. Perbaikan: latihan diubah menjadi *memakai* `enabled` bawaan.
2. **\[Klarifikasi\] “Tidak boleh membaca `parent`”.** Rumusan ini mudah disalahpahami. `parent` milik *anak di dalam komponen* sah dipakai (contoh: `anchors.centerIn: parent` pada `Text` di dalam `AppButton`, karena induknya adalah `root` yang berada di berkas yang sama). Yang dihindari adalah `parent` milik objek *root*, sebab itu adalah pihak luar yang tidak dikenal komponen. Dijelaskan di 5.1.4.
3. **\[Tambahan\] 5.1.6 Keyboard, fokus, aksesibilitas.** `AppButton` pada contoh kurikulum hanya bereaksi pada pointer (mouse/sentuh). Tanpa fokus keyboard dan peran aksesibilitas, komponen itu tidak bisa dipakai tanpa mouse, padahal “API” sebuah komponen mencakup juga perilakunya.
4. **\[Tambahan\] 5.1.7 Opsi implementasi lain.** Kurikulum hanya menunjukkan satu cara (root `Rectangle`). Ditambahkan: root `Item` (menyembunyikan API `Rectangle`), turunan `Button` dari Qt Quick Controls, `property alias`, `component` inline, dan `MouseArea` sebagai pengganti `TapHandler`.
5. **\[Tambahan\] Alat di 5.1.5.** Konvensi gaya tanpa alat sulit ditegakkan, maka ditambahkan `qmllint`, `qmlformat`, dan `qmlls`.
6. **\[Catatan\] Cek pemahaman 5.1** memakai kata “tidak boleh”; dilunakkan menjadi “sebaiknya tidak” beserta pengecualiannya.

Catatan awal untuk modul berikutnya (dibahas saat gilirannya, tidak dikerjakan sekarang): 5.2 belum menyebut `StackLayout` (anggota `QtQuick.Layouts`), properti `Layout.row/column/rowSpan/columnSpan` pada `GridLayout`, dan perilaku item `visible: false`. 5.3 punya rujukan maju ke Modul 10.3 (wajar, cukup ditandai sebagai rujukan maju) dan perlu catatan versi untuk `Qt.styleHints.colorScheme`.

**Daftar Modul 5.1 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

<details>
  <summary>📃 Daftar Isi</summary>

- 5.1.1 Prinsip: properti masuk, signal keluar
- 5.1.2 `root` sebagai id konvensional
- 5.1.3 Ukuran implisit
- 5.1.4 Menghindari akses ke induk
- 5.1.5 Konvensi penamaan dan gaya kode
- &#91;+\] 5.1.6 Keyboard, fokus, dan aksesibilitas
- &#91;+\] 5.1.7 Opsi implementasi lain

---

</details>

**Asumsi prasyarat.** Fase 3 (properti, binding, signal, scope dan id; Modul 3.4) serta Fase 4 (`Item`/`Rectangle`/`Text` di 4.1, anchors di 4.2, input dasar di 4.4). `TapHandler` diperkenalkan ulang secara singkat di 5.1.1 bila belum terasa akrab.

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini mengajarkan cara mengubah potongan UI yang berulang (tombol, kartu, baris daftar) menjadi *tipe QML baru* yang punya antarmuka jelas: apa yang boleh dimasukkan dari luar (properti), apa yang dikabarkan ke luar (signal), dan apa yang disembunyikan (anak-anak internal dan id internal).

### Peran dalam kurikulum

Sampai Fase 4 Anda menulis *objek*. Mulai Fase 5 Anda merancang *tipe*. Dua modul berikutnya bergantung langsung padanya: Layout (5.2) menanyakan ukuran implisit komponen, dan Tema (5.3) dibaca oleh komponen. Komponen yang rapi membuat keduanya nyaris otomatis; komponen yang berantakan membuat keduanya penuh tambalan.

### Konsep kunci dan filosofi

- **Analogi remote TV (dan stopkontak).** Anda hanya tahu tombolnya: pengaturan yang Anda berikan (properti) dan kabar ‘tombol ditekan’ (signal). Pabrikan boleh mengganti seluruh isi remote kapan saja selama tombolnya tetap sama. Stopkontak bekerja serupa: bentuk lubangnya adalah kontrak, kabel di dinding adalah urusan pemasang.
- **Penyembunyian informasi (information hiding).** Gagasan David Parnas (1972): pecah sistem berdasarkan keputusan desain yang *mungkin berubah*, lalu kunci keputusan itu di balik antarmuka yang stabil. Di QML: isi komponen boleh berubah, API tidak.
- **Data turun, kejadian naik.** Nilai mengalir ke bawah lewat properti (reaktif, berbasis binding); kabar mengalir ke atas lewat signal. Arah tunggal membuat aliran data bisa dilacak, dan ini menentukan ketika aplikasi membesar.
- **Sudut pandang keamanan.** API komponen adalah *batas kepercayaan*. Komponen yang menjangkau `parent` sembarangan mirip proses yang memegang *ambient authority* (hak yang tidak pernah diberikan secara eksplisit): sulit diaudit, rapuh, dan efek sampingnya tersembunyi. Komponen yang hanya memakai apa yang diberikan lewat properti menerapkan *prinsip hak akses minimum* (least privilege) dalam skala UI.
- **Jujur soal batas QML.** QML tidak punya pengubah `private`. Semua properti yang dideklarasikan di root bisa dibaca dan ditulis siapa pun. “Privat” di QML adalah *konvensi* (dibahas di 5.1.5), bukan paksaan kompilator.

Peta batas API (ASCII):

```
 Pemakai (Main.qml)
 +--------------------------------------------------+
 | AppButton { label: 'Simpan'                      |
 |             onClicked: console.log('disimpan') } |
 +-------+-----------------------------^------------+
         | properti (data TURUN)       | signal (kabar NAIK)
         v                             |
 AppButton.qml
 +--------------------------------------------------+
 | root                                             |
 |  +- label           <- API publik (masuk)        |
 |  +- clicked()       <- API publik (keluar)       |
 |  +- Text#teks       <- internal (tersembunyi)    |
 |  +- TapHandler#tap  <- internal (tersembunyi)    |
 +--------------------------------------------------+
```

## 5.1.1 Prinsip: properti masuk, signal keluar

### Dasar yang melandasinya: apa itu komponen QML?

Setiap berkas `.qml` yang namanya diawali huruf kapital otomatis menjadi *tipe* yang bisa dipakai oleh berkas lain dalam direktori atau modul yang sama. Nama tipe adalah nama berkas tanpa `.qml`: `AppButton.qml` menjadi `AppButton`. Objek paling luar di dalam berkas disebut *root*, dan jenis root menentukan *tipe dasar* (base type). Di balik layar `Rectangle` adalah kelas C++ `QQuickRectangle`; QML engine membuat tipe turunan baru yang menambahkan properti dan signal yang Anda deklarasikan.

```
 AppButton.qml        (berkas teks: deklarasi)
      |  dibaca QML engine (dikompilasi lebih dulu oleh CMake bila lewat qt_add_qml_module)
      v
 tipe 'AppButton'     (cetak biru; nama = nama berkas tanpa .qml)
      |  instansiasi:  AppButton { ... }
      v
 objek #1   objek #2   objek #3 ...   (masing-masing punya nilai properti sendiri)
```

Dari Fase 3 Anda sudah tahu properti, binding, dan signal. Di sini ketiganya dipakai sebagai *kontrak*: properti adalah pintu masuk, signal adalah pintu keluar.

### Sintaks dasar

```
[required] [readonly] property <tipe> <nama> [: <ekspresi>]   // deklarasi properti
property alias <nama>: <id>.<properti>                         // alias: nama lain bagi properti anak
signal <nama>([<tipe> <param>, ...])                           // deklarasi signal
on<Nama>: <ekspresi atau blok JS>                              // handler untuk signal <nama>
on<Nama>Changed: ...                                           // handler perubahan properti <nama>
```

### Contoh inti: `AppButton.qml`

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

Pemakaian: `AppButton { label: 'Simpan'; onClicked: console.log('disimpan') }`

### Bedah kode (kata demi kata)

- `import QtQuick` — `import` memuat sebuah *modul* agar nama tipenya dikenali. `QtQuick` adalah modul berisi `Rectangle`, `Text`, `TapHandler`, dan kawan-kawan. Di Qt 6 nomor versi boleh dihilangkan (otomatis versi terpasang terbaru); gaya lama `import QtQuick 2.15` masih sah tetapi tidak perlu.
- `Rectangle { ... }` — *objek root* sekaligus tipe dasar `AppButton`. Konsekuensinya: seluruh properti `Rectangle` (`color`, `radius`, `border`, `width`, ...) ikut menjadi API publik `AppButton`. Praktis, tetapi “membocor”; 5.1.7 membahas alternatifnya.
- `id: root` — memberi nama pada objek agar bisa dirujuk dari dalam berkas ini (detail di 5.1.2).
- `required property string label` — `property` mendeklarasikan properti baru; `string` adalah tipenya (teks); `label` namanya; `required` memaksa pemakai mengisinya saat objek dibuat. Bila lupa, komponen gagal dibuat dengan galat berbunyi “Required property label was not initialized”.
- `signal clicked()` — mendeklarasikan signal bernama `clicked` tanpa parameter. Pemakai otomatis mendapat handler `onClicked`.
- `implicitWidth: teks.implicitWidth + 32` — sebuah *binding*: lebar alami = lebar alami teks + 32 piksel (16 kiri + 16 kanan). Nilainya ikut berubah ketika `label` berubah. `teks` merujuk id `Text` di bawah.
- `implicitHeight: 40` — tinggi alami tetap 40 piksel.
- `radius: 6` — sudut membulat 6 piksel (properti bawaan `Rectangle`).
- `color: tap.pressed ? '#1d4ed8' : '#2563eb'` — ekspresi kondisional `kondisi ? jikaBenar : jikaSalah` (operator ternary JavaScript). `tap.pressed` bernilai benar selama jari atau mouse menekan, dan binding dihitung ulang otomatis. `#RRGGBB` adalah kode warna heksadesimal. Catatan: bentuk dengan alfa di QML adalah `#AARRGGBB` (alfa di depan, kebalikan CSS).
- `Text { id: teks; ... }` — objek anak. `anchors.centerIn: parent` memusatkan teks dalam induknya (`parent` di sini adalah `root`, sah karena masih dalam berkas yang sama). `text: root.label` mengikat teks ke properti API. `color: 'white'` memakai nama warna standar SVG.
- `TapHandler { id: tap; onTapped: root.clicked() }` — *Pointer Handler* nonvisual yang mendeteksi “tap” (tekan lalu lepas dengan gerakan kecil; berlaku untuk mouse, sentuh, dan pena). `pressed` benar selama ditekan. `onTapped` adalah handler untuk signal `tapped`; badannya `root.clicked()` memanggil signal seperti fungsi, artinya *memancarkan* (emit) signal itu.
- Baris pemakaian — tanda `;` memisahkan pernyataan pada satu baris; `console.log` mencetak ke terminal dengan awalan `qml:`.

### Mengapa properti masuk dan signal keluar?

- **Properti masuk bersifat reaktif.** Pemakai boleh mengikat `label` ke apa pun (`label: model.nama`), dan komponen otomatis mengikuti.
- **Signal keluar menjaga komponen tetap bodoh dengan baik.** Komponen tidak tahu siapa pendengarnya: nol, satu, atau banyak. Ini pola *observer* / *publish–subscribe* dan inilah yang membuat komponen bisa dipakai ulang.
- **Komponen melapor, pemakai memutuskan.** Komponen tidak mengubah state milik pemakai; ia hanya mengabarkan bahwa sesuatu terjadi.

### Pilihan deklarasi properti (opsi lain)

- `required property T x` — dipakai bila tidak ada nilai awal yang masuk akal (misalnya label tombol).
- `property T x: nilai` — dipakai bila ada nilai bawaan yang wajar (misalnya `property bool dark: false`).
- `readonly property T x: ekspresi` — keluaran terhitung milik komponen; pemakai boleh membaca tetapi tidak menulis (misalnya `readonly property bool pressed: tap.pressed`).
- `property alias x: anak.properti` — meneruskan properti anak apa adanya (dibahas di 5.1.7).

### Variasi: signal berparameter

```qml
// di AppButton.qml
signal activated(string label)
TapHandler { onTapped: root.activated(root.label) }

// di pemakai
AppButton { label: 'Simpan'; onActivated: (label) => console.log('aktif:', label) }
```

Signal boleh membawa data. Qt 6 menganjurkan nama parameter *eksplisit* lewat fungsi panah `(label) => ...`; cara lama (nama parameter otomatis “disuntikkan” ke handler) kini cenderung diperingatkan oleh `qmllint`.

### Menjalankannya

```qml
// Main.qml
import QtQuick

Window {
    width: 320; height: 120
    visible: true
    title: 'Uji AppButton'

    AppButton {
        anchors.centerIn: parent
        label: 'Simpan'
        onClicked: console.log('disimpan')
    }
}
```

`Window` adalah jendela tingkat atas (di Qt 6 cukup `import QtQuick`); `visible: true` wajib agar tampil. Perhatikan `anchors.centerIn: parent` di sini ditulis oleh *pemakai*: penempatan adalah urusan pemakai, bukan komponen.

```bash
# Cara 1 — tercepat, tanpa CMake (AppButton.qml di folder yang sama otomatis dikenali)
qml6 Main.qml

# Cara 2 — lewat proyek CMake 'hello' (daftarkan AppButton.qml di QML_FILES)
cmake -S . -B build -G Ninja && cmake --build build && ./build/hello

# Cara 3 — uji tanpa layar (CI atau sesi SSH): berhasil bila berjalan sampai timeout (kode keluar 124)
QT_QPA_PLATFORM=offscreen timeout 3 qml6 Main.qml; echo $?
```

Catatan Arch Linux: paket `qt6-declarative` biasanya memasang perkakas dengan akhiran `6` (`qml6`, `qmllint6`, `qmlformat6`, `qmlls6`). Bila ragu, periksa dengan `pacman -Ql qt6-declarative | grep bin/`.

### Alur satu klik (ASCII)

```
 Pengguna        TapHandler#tap         root (AppButton)         Pemakai (Main.qml)
    |  tekan  ->      |                        |                         |
    |                 | pressed = true ------> | color dihitung ulang    |
    |  lepas  ->      |                        |                         |
    |                 | tapped() ------------> | root.clicked() -------> | onClicked: console.log(...)
```

**Referensi bagian ini:** [Defining Object Types through QML Documents](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html) · [QML Object Attributes (property, signal, required)](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html) · [TapHandler](https://doc.qt.io/qt-6/qml-qtquick-taphandler.html) · [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html) · [Text](https://doc.qt.io/qt-6/qml-qtquick-text.html)

## 5.1.2 `root` sebagai id konvensional

### Dasar: apa itu `id`?

`id` adalah nama yang Anda berikan pada sebuah objek supaya objek lain di *berkas yang sama* bisa merujuknya. Aturannya: unik dalam satu berkas; diawali huruf kecil atau garis bawah; hanya berisi huruf, angka, dan garis bawah; tidak boleh kata cadangan JavaScript; dan tidak bisa diubah atau di-binding saat program berjalan. `id` bukan properti biasa (tidak ada `objek.id` yang bisa dibaca).

### Cakupan (scope) id

```
 AppButton.qml                         <- satu dokumen = satu lingkup id
 +- Rectangle   (id: root)             <- terlihat dari SEMUA anak di bawahnya
    |- Text        (id: teks)           <- dari sini root dan tap bisa dirujuk
    '- TapHandler  (id: tap)            <- dari sini root dan teks bisa dirujuk

 Main.qml (pemakai)                    <- lingkup id TERPISAH
 +- Window
    '- AppButton (id: btn1)             <- btn1 hanya hidup di Main.qml;
                                           'root' dan 'teks' TIDAK terlihat di sini
```

Akibatnya dua objek `AppButton` yang berbeda sama-sama punya `root` tanpa bertabrakan: `id` bukan variabel global.

### Mengapa dinamai `root`?

- **Terbaca sekilas.** Pembaca langsung tahu: ini objek terluar, yaitu antarmuka komponen. Bandingkan dengan `parent`, yang artinya berganti-ganti menurut posisi.
- **Menghindari akses tak-terkualifikasi.** Pada contoh di bawah, `label` tanpa awalan di dalam `Text` *akan* ditemukan karena QML menelusuri rantai lingkup sampai ke properti root. Namun itu rapuh: bila kelak `Text` mendapat properti bernama sama, maknanya berubah diam-diam. `qmllint` menandainya sebagai “unqualified access”.

```qml
Rectangle {
    id: root
    property string label: ''

    Text { text: label }        // kurang baik: tak-terkualifikasi (rapuh)
    Text { text: root.label }   // baik: eksplisit, aman dari bayangan nama
}
```

Aturan praktis: gunakan `root.` untuk API komponen dan `idAnak.` untuk anak.

### Opsi nama lain

- `root` — paling umum; dipakai di kurikulum ini.
- `control` — konvensi contoh Qt Quick Controls (`id: control`).
- `self` atau `item` — sah, tetapi kurang lazim.

Pilih satu dan konsisten dalam satu proyek; konsistensi lebih berharga daripada pilihan nama itu sendiri.

**Referensi bagian ini:** [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [QML Object Attributes (id)](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html)

## 5.1.3 Ukuran implisit

### Dasar: dua jenis ukuran

Setiap `Item` punya dua pasang ukuran:

- `width` / `height` — ukuran *aktual* yang dipakai untuk menggambar dan menata.
- `implicitWidth` / `implicitHeight` — ukuran *alami*: “segini yang saya butuhkan bila tidak ada yang menentukan”.

Bila `width` tidak pernah diatur, `width` mengikuti `implicitWidth` (begitu pula tinggi). `Text` dan `Image` punya ukuran implisit dari isinya; `Rectangle` murni 0×0 karena tidak punya isi.

```
 Text.implicitWidth ----> root.implicitWidth ----> width  (bila tak diatur)
  (dari isi teks)          (dihitung komponen:         |
                            teks + 32)                  v
                                      pemakai atau Layout boleh menimpa:
                                      width: 200   /   Layout.preferredWidth: 200
```

### Eksperimen: komponen tanpa ukuran implisit

```qml
// TombolTanpaImplisit.qml (hanya untuk eksperimen)
import QtQuick

Rectangle {
    id: root
    required property string label
    color: '#2563eb'; radius: 6
    Text { anchors.centerIn: parent; text: root.label; color: 'white' }
}
```

```qml
// dipakai di Main.qml
Row {
    spacing: 8
    TombolTanpaImplisit { label: 'Simpan' }
    TombolTanpaImplisit { label: 'Batal' }
}
```

Hasilnya: kedua tombol tidak tampak. Sebabnya: `Rectangle` punya ukuran implisit 0×0, `width` ikut menjadi 0, sehingga `Row` menata dua benda selebar nol. Dengan `implicitWidth` dan `implicitHeight` seperti pada `AppButton`, `Row` yang sama langsung menampilkan tombol selebar teksnya masing-masing.

### Aturan emas

> Komponen menetapkan ukuran **implisit**. Pemakai atau Layout menetapkan ukuran **aktual**.

Jangan mengisi `width` atau `height` pada root komponen kecuali Anda memang ingin ukuran terkunci. Itu juga yang membuat `Layout` di Modul 5.2 bekerja: Layout membaca ukuran implisit sebagai ukuran pilihan (`preferred`) bila `Layout.preferredWidth` tidak diisi.

### Opsi lain untuk logika yang sama

```qml
// A. Versi kurikulum: lebar mengikuti teks + 32
implicitWidth: teks.implicitWidth + 32

// B. Dengan lebar minimum 80 px (Math.max = fungsi JavaScript)
implicitWidth: Math.max(80, teks.implicitWidth + 32)

// C. Padding sebagai properti (jalan menuju token tema di Modul 5.3)
readonly property int padding: 16
implicitWidth: teks.implicitWidth + 2 * padding
```

Pada Qt Quick Controls pola yang sama sudah tersedia: `implicitWidth` dihitung dari `implicitContentWidth + leftPadding + rightPadding` (lihat 5.1.7).

### Bahaya: binding loop

Jangan pernah mengikat ukuran implisit ke ukuran aktual (`implicitWidth: width`). Arah ketergantungan harus satu arah: isi → implisit → aktual. Bila dibalik, QML melaporkan “Binding loop detected for property implicitWidth” dan hasilnya tidak terdefinisi.

**Referensi bagian ini:** [Item (implicitWidth, implicitHeight, width)](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Item Positioners](https://doc.qt.io/qt-6/qtquick-positioning-topic.html) · [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html)

## 5.1.4 Menghindari akses ke induk

### Dasar: apa itu `parent`?

Setiap `Item` punya properti `parent`: *induk visual*-nya, yaitu item tempat ia dipasang di pohon tampilan (berbeda dari induk kepemilikan `QObject` di C++). Anak yang ditulis di dalam kurung kurawal sebuah item otomatis memakai item itu sebagai `parent`. Perhatikan: nilai `parent` bergantung pada *di mana komponen dipakai*, bukan di mana ia ditulis.

```
 Komponen dipakai di mana?          Siapa 'parent' dari objek root komponen?
 ---------------------------------  -------------------------------------------
 di dalam Row / Column / Layout     Row / Column / Layout itu
 di dalam Loader                    Loader itu
 sebagai delegate Repeater          induk milik Repeater (bukan Repeater-nya)
 sebagai delegate ListView          contentItem milik ListView (bukan ListView-nya)
 dibuat dengan createObject(null)   null  ->  membaca parent.width = galat
```

Jadi, objek *root* sebuah komponen tidak bisa tahu siapa induknya. Sebaliknya, anak-anak di dalam berkas yang sama selalu tahu induknya, karena Anda sendiri yang menulis pohonnya.

### Contoh buruk: tiga dosa sekaligus

```qml
// LencanaBuruk.qml — terpaku pada induknya
import QtQuick

Rectangle {
    width: parent.width / 2                          // (1) mengandalkan induk punya width
    color: parent.gelap ? 'black' : 'white'          // (2) mengandalkan induk punya properti 'gelap'
    Component.onCompleted: parent.jumlahLencana++    // (3) mengubah state induk diam-diam
}
```

- **(1) Kontrak tak tertulis.** Komponen mensyaratkan induk punya `width` yang bermakna. Tidak ada yang memeriksanya: `parent` bertipe `Item`, jadi `parent.gelap` adalah pencarian dinamis yang baru gagal saat program berjalan (`qmllint` cenderung memperingatkannya, dan kompilator QML tidak bisa mengoptimalkannya).
- **(2) Kopling erat.** Komponen hanya bisa hidup di bawah induk yang kebetulan punya `gelap`. Pindahkan ke `Row` atau `Loader` dan ia rusak.
- **(3) Efek samping tersembunyi.** Pembaca `Panel.qml` tidak melihat apa pun yang mengubah `jumlahLencana`; perubahan itu datang dari berkas lain. Dalam audit kode inilah yang paling mahal: aliran data tidak bisa dilacak.

### Contoh baik: antarmuka eksplisit

```qml
// Lencana.qml
import QtQuick

Rectangle {
    id: root

    property bool gelap: false
    property int jumlah: 0
    signal diminta()

    implicitWidth: teks.implicitWidth + 16
    implicitHeight: 24
    radius: height / 2
    color: root.gelap ? 'black' : 'white'

    Text {
        id: teks
        anchors.centerIn: parent
        text: root.jumlah
        color: root.gelap ? 'white' : 'black'
    }

    TapHandler { onTapped: root.diminta() }
}
```

```qml
// Panel.qml — pemilik state
import QtQuick

Item {
    id: panel
    property int total: 0
    property bool gelap: false

    Lencana {
        x: 8; y: 8
        jumlah: panel.total
        gelap: panel.gelap
        onDiminta: panel.total++
    }
}
```

Bedah singkat:

- `property bool gelap: false` dan `property int jumlah: 0` — masukan dengan nilai bawaan yang wajar; tidak ada yang `required` karena komponen tetap bermakna tanpanya.
- `signal diminta()` — komponen *meminta* penambahan, tidak melakukannya sendiri. Keputusan tetap di pemilik state.
- `radius: height / 2` — memakai `height` milik komponen itu sendiri (bukan milik induk), jadi sah.
- `onDiminta: panel.total++` — yang mengubah `total` adalah `Panel`, pemilik datanya. `++` adalah operator JavaScript penambah satu.
- `x: 8; y: 8` — penempatan ditentukan *pemakai*, bukan `Lencana`.

Pola ini disebut *lifting state up*: state tinggal di leluhur terdekat yang membutuhkannya, mengalir turun lewat properti, dan perubahan naik lewat signal.

### Pengecualian yang dapat diterima

- **`parent` milik anak di dalam berkas yang sama** (contoh: `anchors.centerIn: parent` pada `Text` di `AppButton`). Pohonnya Anda tulis sendiri.
- **Attached property dengan kontrak terdokumentasi**, misalnya `ListView.view` pada delegate (cara resmi mengetahui view pemilik delegate), `Layout.*`, `Keys`, `Accessible`. Ini antarmuka eksplisit, bukan tebakan tentang `parent`.
- **Komponen yang kontraknya memang “mengisi wadahnya”** (misalnya overlay penuh layar). Tetap lebih baik bila pemakai yang menulis `anchors.fill: parent`; bila tidak, dokumentasikan di komentar bagian atas berkas.

### Pengganti yang benar (diagram keputusan)

```
 Komponen saya butuh sesuatu dari luar?
  |
  +-- butuh NILAI (ukuran, warna, mode, data)?  --> properti masuk (required / bernilai bawaan)
  +-- perlu MEMBERI KABAR (diklik, selesai)?    --> signal keluar
  +-- perlu MENGUBAH state di luar?             --> signal; pemakai yang mengubah
  +-- perlu POSISI atau ukuran di wadahnya?     --> serahkan ke pemakai (anchors, Layout.*)
  +-- nilai yang sifatnya GLOBAL (mode gelap)?  --> singleton tema (Modul 5.3), diimpor eksplisit
```

### Opsi lain untuk logika yang sama

- **Properti diisi pemakai** (contoh di atas): paling eksplisit, paling mudah diuji.
- **Singleton tema** untuk nilai global: `color: Theme.gelap ? 'black' : 'white'`. Ketergantungannya tetap *dinyatakan* (nama `Theme` terlihat di kode), tidak tersembunyi di balik `parent`. Dibahas di Modul 5.3.
- **Attached property** buatan pemakai (`Layout.fillWidth: true`) untuk urusan penempatan; komponen cukup memberi ukuran implisit yang baik.

### Audit cepat dengan grep

```bash
# daftar semua baris yang menyentuh 'parent.' lalu telaah satu per satu
grep -nF 'parent.' *.qml

# termasuk anchors.fill: parent dan sejenisnya
grep -nF 'parent' *.qml
```

Pertanyaan audit untuk setiap temuan: apakah ini `parent` milik anak (aman) atau milik root (tersangka)?

**Referensi bagian ini:** [Item.parent](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Repeater](https://doc.qt.io/qt-6/qml-qtquick-repeater.html) · [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html) · [ListView (attached ListView.view)](https://doc.qt.io/qt-6/qml-qtquick-listview.html) · [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html)

## 5.1.5 Konvensi penamaan dan gaya kode

### Dasar: mengapa konvensi penting?

Konvensi adalah kontrak antarmanusia (dan antaralat). QML tidak memaksa urutan atribut atau gaya penamaan, tetapi `qmlformat`, `qmllint`, dokumentasi Qt, dan seluruh contoh resmi mengikuti satu pola. Mengikutinya berarti kode Anda terbaca oleh siapa pun yang pernah membaca kode Qt, dan alat bisa membantu Anda alih-alih mengganggu.

### Aturan inti

- **Nama berkas dan tipe:** `PascalCase` — `AppButton.qml`. Huruf awal kapital *wajib* agar berkas dikenali sebagai tipe.
- **id, properti, signal, fungsi:** `camelCase`, dan `id` selalu diawali huruf kecil.
- **Handler:** `on` + nama signal berhuruf kapital awal (`onClicked`); untuk perubahan properti `on` + nama + `Changed` (`onLabelChanged`).
- **Penamaan makna:** signal = peristiwa (`clicked`, `accepted`, `closed`); properti = kata benda atau sifat (`label`, `checked`, `radius`); fungsi = kata kerja (`reset()`).
- **Urutan atribut dalam satu objek** (Qt QML Coding Conventions): `id` → deklarasi properti → deklarasi signal → fungsi JavaScript → properti objek → anak-anak.
- **Properti berkelompok:** bila memakai beberapa properti dari satu kelompok, pertimbangkan notasi grup (`anchors { left: parent.left; right: parent.right }`) alih-alih `anchors.left: ...` berulang.
- **Indentasi** empat spasi; umumnya satu pernyataan per baris (kurikulum ini memadatkan beberapa pernyataan dengan `;` demi ringkas di contoh, bukan sebagai gaya produksi).
- **Teks yang tampil ke pengguna** dibungkus `qsTr('...')` agar bisa diterjemahkan kelak.
- **Kutip:** pilih satu gaya (kurikulum ini memakai kutip tunggal) dan konsisten.

### Anatomi berkas yang rapi (ASCII)

```
 AppButton.qml
 |- import ...
 '- Rectangle {
     |- id: root
     |- [properti publik]      required property ... / property ...
     |- [signal publik]        signal clicked()
     |- [fungsi]               function ...(...) { ... }
     |- [properti objek]       implicitWidth, color, radius, ...
     '- [anak]                 QtObject { id: priv }  Text {...}  TapHandler {...}
    }
```

### Contoh: `AppButton` versi rapi

```qml
import QtQuick

Rectangle {
    id: root

    // API publik
    required property string label
    signal clicked()

    // Tampilan
    implicitWidth: teks.implicitWidth + 2 * priv.padding
    implicitHeight: 40
    radius: 6
    color: tap.pressed ? '#1d4ed8' : '#2563eb'

    // Internal: jangan disentuh dari luar
    QtObject {
        id: priv
        readonly property int padding: 16
    }

    Text {
        id: teks
        anchors.centerIn: parent
        text: root.label
        color: 'white'
    }

    TapHandler {
        id: tap
        onTapped: root.clicked()
    }
}
```

Bedah bagian baru:

- Komentar `// API publik` dan `// Tampilan` hanya penanda bagian; komentar satu baris di QML ditulis dengan `//`.
- `QtObject { id: priv ... }` — `QtObject` adalah objek paling dasar tanpa tampilan. Dipakai sebagai *ruang nama privat*: semua yang tidak ingin Anda publikasikan ditaruh di dalamnya dan diberi nama `priv`. Ini hanya konvensi: QML tidak melarang pihak luar membaca, tetapi pihak luar tidak bisa merujuk `priv` karena id-nya tidak terlihat dari berkas lain (lihat 5.1.2).
- `readonly property int padding: 16` — nilai tetap bernama; mengganti angka mentah `32` dengan `2 * priv.padding` adalah langkah awal menuju token tema di 5.3.

### Opsi lain untuk “privat”

```qml
// Opsi 1 — awalan garis bawah (ringan, sekadar penanda)
readonly property int _padding: 16

// Opsi 2 — QtObject internal (dipakai di atas; mengelompokkan banyak nilai privat)
QtObject { id: priv; readonly property int padding: 16 }

// Opsi 3 — properti biasa tanpa penanda (HINDARI: tampak sebagai API publik)
property int padding: 16
```

### Alat penegak konvensi

```bash
# Format ulang berkas (-i = in-place). qmlformat memecah satu-baris-banyak-properti menjadi satu per baris.
qmlformat6 -i AppButton.qml

# Analisis statis: akses tak-terkualifikasi, tipe salah, properti tak dikenal, dll.
qmllint6 AppButton.qml

# Dari proyek CMake (qt_add_qml_module membuat target <nama>_qmllint dan all_qmllint)
cmake --build build --target all_qmllint
```

`qmlformat` versi baru juga punya opsi `--normalize` untuk merapikan urutan atribut sesuai konvensi; cek `qmlformat6 --help` untuk versi Qt Anda.

**Editor berbasis terminal (Neovim).** `qmlls` adalah *language server* resmi QML: memberi autocompletion, diagnostik, dan lompat-ke-definisi. Contoh konfigurasi dengan `nvim-lspconfig` (sesuaikan nama biner dan cara konfigurasi dengan versi Neovim Anda):

```lua
require('lspconfig').qmlls.setup({ cmd = { 'qmlls6' } })
```

Untuk proyek CMake, `qmlls` perlu tahu lokasi direktori build; ada opsi `-b` / `--build-dir` pada `qmlls`, dan pada versi Qt yang lebih baru variabel CMake `QT_QML_GENERATE_QMLLS_INI` menghasilkan berkas `.qmlls.ini` otomatis (verifikasi di dokumentasi versi Qt Anda).

**Referensi bagian ini:** [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html) · [qmlls](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html) · [QtObject](https://doc.qt.io/qt-6/qml-qtqml-qtobject.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

## 5.1.6 \[TAMBAHAN\] Keyboard, fokus, dan aksesibilitas

*Alasan penambahan:* API sebuah komponen mencakup perilakunya, bukan hanya properti dan signal-nya. `AppButton` di atas hanya bereaksi pada pointer. Dengan keyboard, tombol itu tidak bisa dijangkau, dan bagi teknologi bantu (pembaca layar) ia hanyalah kotak biru. Sebagai pengguna yang hidup di keyboard, ini cacat serius.

### Dasar: bagaimana fokus bekerja?

Pada satu waktu, hanya satu item dalam jendela yang menerima peristiwa keyboard: item ber-`activeFocus: true`. Properti yang perlu Anda kenal:

- `focus` — item *ingin* fokus di dalam lingkup fokusnya.
- `activeFocus` — *hanya-baca*; benar bila item benar-benar memegang fokus aktif.
- `activeFocusOnTab` — item ikut dalam rantai fokus tombol Tab (dan Shift+Tab untuk mundur). Nilai bawaannya `false`.
- `forceActiveFocus(alasan)` — meminta fokus aktif secara paksa.

Keyboard disalurkan lewat *attached property* `Keys` (misalnya `Keys.onReturnPressed`). Teknologi bantu dilayani lewat attached property `Accessible` (`role`, `name`, dan signal `pressAction`). *Attached property* adalah properti yang “ditempelkan” ke objek oleh tipe lain dengan sintaks `NamaTipe.properti`; Anda akan memakainya lagi sebagai `Layout.*` di Modul 5.2.

### Contoh: `AppButton` yang bisa dipakai tanpa mouse

```qml
import QtQuick

Rectangle {
    id: root

    required property string label
    signal clicked()

    // keyboard dan aksesibilitas
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: root.label
    Accessible.onPressAction: root.clicked()
    Keys.onReturnPressed: root.clicked()
    Keys.onEnterPressed: root.clicked()
    Keys.onSpacePressed: root.clicked()

    // tampilan
    implicitWidth: teks.implicitWidth + 32
    implicitHeight: 40
    radius: 6
    color: tap.pressed ? '#1d4ed8' : '#2563eb'
    border.width: root.activeFocus ? 2 : 0
    border.color: '#93c5fd'

    Text { id: teks; anchors.centerIn: parent; text: root.label; color: 'white' }

    TapHandler {
        id: tap
        onTapped: {
            root.forceActiveFocus(Qt.MouseFocusReason)
            root.clicked()
        }
    }
}
```

### Bedah kode (hanya bagian baru)

- `activeFocusOnTab: true` — memasukkan tombol ke rantai Tab. Tanpa ini keyboard tidak bisa “mendarat” di tombol.
- `Accessible.role: Accessible.Button` — memberi tahu teknologi bantu: ini tombol. `Accessible` adalah attached property; `role` adalah salah satu atribut yang ditempelkan.
- `Accessible.name: root.label` — nama yang dibacakan pembaca layar; diikat ke `label` agar selalu sinkron.
- `Accessible.onPressAction: root.clicked()` — handler signal `pressAction`, yaitu saat teknologi bantu “menekan” tombol; harus memicu aksi yang *sama* dengan klik.
- `Keys.onReturnPressed` / `Keys.onEnterPressed` / `Keys.onSpacePressed` — handler tombol spesifik. Qt membedakan `Return` (Enter utama) dan `Enter` (keypad numerik), maka keduanya ditangani.
- `border.width: root.activeFocus ? 2 : 0` — *indikator fokus visual*. Pengguna keyboard wajib bisa melihat di mana fokus berada.
- `root.forceActiveFocus(Qt.MouseFocusReason)` — klik mouse ikut memindahkan fokus ke tombol; `Qt.MouseFocusReason` mencatat bahwa penyebabnya mouse (dipakai oleh style untuk memutuskan apakah cincin fokus perlu digambar).
- Pada contoh sederhana ini Spasi memicu saat *ditekan*; tombol asli memicu saat *dilepas*. Perbedaan kecil, tetapi itu contoh mengapa menciptakan ulang tombol itu mahal (lihat Opsi C di 5.1.7).

### Mengujinya

```bash
qml6 Main.qml
# Tab -> fokus mendarat di tombol (muncul garis biru muda)
# Enter atau Spasi -> terminal mencetak:  qml: disimpan
# Klik mouse -> fokus pindah dan terminal mencetak hal yang sama
```

Bila ingin menguji pembaca layar pada Linux: aksesibilitas Qt memakai AT-SPI melalui D-Bus dan biasanya aktif otomatis saat pembaca layar berjalan; bila tidak, variabel `QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1` dapat memaksanya (verifikasi sesuai versi Qt Anda).

### Opsi lain untuk logika keyboard yang sama

```qml
// Opsi 1 — satu handler Keys.onPressed untuk banyak tombol
Keys.onPressed: (event) => {
    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
        root.clicked()
        event.accepted = true   // tandai sudah ditangani agar tidak diteruskan ke induk
    }
}

// Opsi 2 — Shortcut: pintasan tingkat jendela, tidak bergantung fokus
Shortcut { sequence: 'Ctrl+S'; onActivated: root.clicked() }
```

`Keys.onPressed` memberi kendali penuh (termasuk pengubah seperti Ctrl) dan satu tempat untuk logika; `Shortcut` cocok untuk pintasan global seperti Ctrl+S yang harus bekerja walau tombol tidak sedang fokus. Pilihlah per kasus: handler fokus untuk perilaku tombol, `Shortcut` untuk pintasan aplikasi.

**Referensi bagian ini:** [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [Accessible](https://doc.qt.io/qt-6/qml-qtquick-accessible.html) · [Accessibility for Qt Quick Applications](https://doc.qt.io/qt-6/qtquick-accessibility.html) · [Shortcut](https://doc.qt.io/qt-6/qml-qtquick-shortcut.html) · [Item (activeFocusOnTab, forceActiveFocus)](https://doc.qt.io/qt-6/qml-qtquick-item.html)

## 5.1.7 \[TAMBAHAN\] Opsi implementasi lain untuk logika yang sama

*Alasan penambahan:* kurikulum hanya menunjukkan satu cara (root `Rectangle` + `TapHandler`). Komponen yang sama (tombol dengan `label` dan `clicked`) bisa dibangun dengan beberapa cara yang berbeda dalam hal seberapa banyak API yang bocor, seberapa banyak kode yang harus Anda pelihara, dan perilaku bawaan apa yang Anda dapat gratis.

### Opsi A — root `Rectangle` (versi kurikulum)

Sudah dibahas di 5.1.1–5.1.6. Kelebihan: paling sederhana, mudah dipahami, tanpa ketergantungan modul tambahan. Kekurangan: seluruh API `Rectangle` (`color`, `border`, `radius`, `gradient`, ...) ikut bocor menjadi API publik, dan perilaku keyboard serta aksesibilitas harus Anda tulis sendiri.

### Opsi B — root `Item` dengan `Rectangle` internal (API ketat)

```qml
import QtQuick

Item {
    id: root

    required property string label
    property color tint: '#2563eb'
    signal clicked()

    implicitWidth: bg.implicitWidth
    implicitHeight: bg.implicitHeight

    Rectangle {
        id: bg
        anchors.fill: parent
        implicitWidth: teks.implicitWidth + 32
        implicitHeight: 40
        radius: 6
        color: tap.pressed ? Qt.darker(root.tint, 1.2) : root.tint

        Text { id: teks; anchors.centerIn: parent; text: root.label; color: 'white' }
    }

    TapHandler { id: tap; onTapped: root.clicked() }
}
```

Bedah bagian yang berbeda:

- `Item` sebagai root — `Item` tidak punya `color`, `radius`, atau `border`. API publik hanya yang Anda deklarasikan: `label`, `tint`, `clicked()` (ditambah properti dasar `Item` seperti `width`, `x`, `enabled`).
- `property color tint` — satu-satunya titik pengaturan warna; tipe `color` menerima nama atau kode heksadesimal.
- `implicitWidth: bg.implicitWidth` — ukuran implisit root *diteruskan* dari tampilan internal. Tidak ada binding loop: `bg.implicitWidth` bergantung pada teks, bukan pada `width`.
- `anchors.fill: parent` pada `bg` — `parent` di sini adalah `root` (anak di berkas yang sama, jadi sah).
- `Qt.darker(root.tint, 1.2)` — fungsi bawaan `Qt` yang mengembalikan warna lebih gelap; faktor di atas 1 menggelapkan.

Kapan dipilih: pustaka UI sendiri, atau komponen yang API-nya perlu diaudit ketat (prinsip hak akses minimum).

### Opsi C — turunan `Button` dari Qt Quick Controls (paling sedikit kode)

```qml
import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    contentItem: Text {
        text: root.text
        color: 'white'
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitWidth: 80
        implicitHeight: 40
        radius: 6
        color: root.down ? '#1d4ed8' : '#2563eb'
        border.width: root.visualFocus ? 2 : 0
        border.color: '#93c5fd'
    }
}
```

Pemakaian: `AppButton { text: 'Simpan'; onClicked: console.log('disimpan') }` — perhatikan namanya `text`, bukan `label`, karena itu properti bawaan `Button`.

Bedah:

- `import QtQuick.Controls.Basic` — mengimpor *style* Basic secara eksplisit. Penyesuaian `background` dan `contentItem` hanya didukung pada style non-native (Basic, Fusion, Material, Universal, dan sejenisnya); style native platform tidak mendukung kustomisasi semacam ini. Alternatifnya `import QtQuick.Controls` biasa lalu memilih style saat dijalankan: `QT_QUICK_CONTROLS_STYLE=Basic qml6 Main.qml`.
- `Button` — turunan `AbstractButton` → `Control`. Anda langsung mendapat `text`, `clicked()`, `pressed`, `down`, `hovered`, `checkable`, `autoRepeat`, `icon`, rantai Tab, aktivasi Spasi/Enter, dan aksesibilitas dasar.
- `contentItem` dan `background` — dua properti bertipe `Item` yang *bisa diganti*: isi (teks/ikon) dan latar. Inilah pola kustomisasi resmi Qt Quick Controls.
- `root.down` — benar saat tombol ditekan (lewat mouse *atau* keyboard); `root.visualFocus` — benar saat fokus perlu digambar (misalnya fokus dari keyboard).
- Tidak ada `implicitWidth` di root: `Control` menghitungnya otomatis dari ukuran implisit isi dan latar ditambah padding. Prinsip 5.1.3 sudah ditangani kerangkanya.

Kapan dipilih: aplikasi nyata. Anda memelihara jauh lebih sedikit kode dan mendapat perilaku yang sudah teruji. Harganya: ketergantungan pada Qt Quick Controls dan keharusan memilih style.

### Opsi D — komponen inline (`component`) untuk pembantu kecil

```qml
// Toolbar.qml
import QtQuick

Row {
    spacing: 8

    component Chip: Rectangle {
        id: chip
        required property string nama
        implicitWidth: t.implicitWidth + 16
        implicitHeight: 24
        radius: 12
        color: '#e5e7eb'
        Text { id: t; anchors.centerIn: parent; text: chip.nama }
    }

    Chip { nama: 'qml' }
    Chip { nama: 'qt6' }
}
```

- `component Chip: Rectangle { ... }` — mendefinisikan tipe baru *di dalam* berkas lain tanpa berkas terpisah. Sintaks: `component Nama: TipeDasar { ... }`.
- Dari berkas lain, tipe ini dapat dirujuk dengan awalan nama berkas: `Toolbar.Chip`.
- Cocok untuk pembantu kecil yang hanya bermakna di satu berkas. Bila tipe mulai dipakai di banyak tempat, pindahkan ke berkas sendiri.
- Catatan lanjut: tanpa pengaturan, komponen inline dapat melihat id milik berkas di sekelilingnya. Untuk perilaku yang lebih ketat tambahkan `pragma ComponentBehavior: Bound` di bagian atas berkas (Qt 6.2 ke atas; lihat dokumentasi struktur dokumen QML).

### Opsi E — `property alias` untuk meneruskan properti anak

```qml
Rectangle {
    id: root
    property alias label: teks.text     // label == teks.text
    signal clicked()

    implicitWidth: teks.implicitWidth + 32
    implicitHeight: 40
    radius: 6
    color: '#2563eb'

    Text { id: teks; anchors.centerIn: parent; color: 'white' }
    TapHandler { onTapped: root.clicked() }
}
```

- `property alias label: teks.text` — `label` adalah *nama lain* bagi `teks.text`: membaca dan menulis `label` sama persis dengan membaca dan menulis `teks.text`. Tidak ada salinan nilai dan tidak ada binding tambahan.
- Kelebihan: ringkas, tanpa pengulangan. Kekurangan: tidak ada tempat untuk validasi atau transformasi nilai, dan API Anda kini melekat pada struktur internal (bila `Text` diganti komponen lain, semantik `label` ikut berubah).
- Cocok untuk meneruskan satu atau dua properti anak apa adanya; kurang cocok sebagai antarmuka yang harus stabil.

### Opsi F — `MouseArea` sebagai pengganti `TapHandler`

```qml
Rectangle {
    id: root
    required property string label
    signal clicked()

    implicitWidth: teks.implicitWidth + 32
    implicitHeight: 40
    radius: 6
    color: area.pressed ? '#1d4ed8' : '#2563eb'

    Text { id: teks; anchors.centerIn: parent; text: root.label; color: 'white' }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
```

- `MouseArea` adalah *Item* tak terlihat yang menangkap peristiwa mouse di area yang diisinya (`anchors.fill: parent` di sini sah: `parent` adalah `root`).
- `hoverEnabled: true` membuat `containsMouse` bekerja; `cursorShape: Qt.PointingHandCursor` mengubah kursor menjadi tangan saat melintas.
- Perbedaan dengan `TapHandler`: `MouseArea` adalah item yang “menutupi” anak di bawahnya dan berorientasi mouse; `TapHandler` adalah Pointer Handler nonvisual yang menangani mouse, sentuh, dan pena secara seragam serta bisa hidup berdampingan dengan handler lain. Untuk kode baru, `TapHandler` biasanya pilihan lebih modern; `MouseArea` tetap sah dan sangat umum di kode lama. `HoverHandler` menyediakan fungsi hover serupa di sisi handler (lihat dokumentasi).

### Peta keputusan

```
 Prototipe cepat / alat internal ............ Opsi A (Rectangle + TapHandler)
 API harus ketat, pustaka UI sendiri ........ Opsi B (Item + Rectangle internal)
 Aplikasi nyata (keyboard, a11y, tema) ...... Opsi C (turunan Button)
 Pembantu kecil satu-berkas ................. Opsi D (component inline)
 Cukup meneruskan 1-2 properti anak ......... Opsi E (property alias)
 Kode lama / perlu hover + kursor sederhana . Opsi F (MouseArea)
```

**Referensi bagian ini:** [Customizing Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-customize.html) · [Styling Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-styles.html) · [Button](https://doc.qt.io/qt-6/qml-qtquick-controls-button.html) · [AbstractButton](https://doc.qt.io/qt-6/qml-qtquick-controls-abstractbutton.html) · [MouseArea](https://doc.qt.io/qt-6/qml-qtquick-mousearea.html) · [Defining Object Types (inline components)](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html) · [Structure of a QML Document (pragma)](https://doc.qt.io/qt-6/qtqml-documents-structure.html)

## Terminologi Esensial

- **Komponen / tipe QML** — berkas `.qml` berawalan huruf kapital yang bisa dipakai berulang, misalnya `AppButton.qml` menjadi tipe `AppButton`.
- **Objek root** — objek paling luar dalam berkas; jenisnya menentukan tipe dasar dan antarmuka komponen.
- **Tipe dasar (base type)** — tipe yang diwarisi komponen, yaitu jenis objek root (misalnya `Rectangle`).
- **`id`** — nama objek yang berlaku dalam satu berkas; dipakai untuk merujuk objek itu dari objek lain di berkas yang sama.
- **Properti** — nilai bernama milik objek yang bisa dibaca, ditulis, dan diamati.
- **`required property`** — properti yang wajib diisi pemakai saat membuat objek; bila tidak, objek gagal dibuat.
- **`readonly property`** — properti yang hanya bisa diisi sekali oleh pendeklarasinya; pemakai tidak boleh menulis.
- **`property alias`** — nama lain bagi properti objek lain (biasanya anak).
- **Signal** — pemberitahuan yang dipancarkan objek saat suatu peristiwa terjadi.
- **Signal handler** — kode `onNamaSignal` yang berjalan saat signal dipancarkan.
- **Memancarkan (emit)** — memicu signal; di QML cukup memanggilnya seperti fungsi (`root.clicked()`).
- **Binding** — ekspresi yang dihitung ulang otomatis ketika nilai yang dirujuknya berubah.
- **Binding loop** — dua nilai saling bergantung sehingga tak ada nilai awal yang dapat dihitung; hasilnya tidak terdefinisi.
- **API publik** — seluruh hal yang boleh disentuh pemakai: properti, signal, fungsi, perilaku.
- **Enkapsulasi / penyembunyian informasi** — menyembunyikan isi di balik API stabil agar isi bebas berubah.
- **Kopling (coupling)** — seberapa erat satu bagian bergantung pada bagian lain; semakin longgar semakin baik.
- **Kohesi (cohesion)** — seberapa padu tanggung jawab dalam satu bagian; semakin padu semakin baik.
- **`parent`** — induk visual sebuah item di pohon tampilan.
- **Attached property** — properti yang “ditempelkan” tipe lain ke objek, ditulis `NamaTipe.properti` (`Keys.onReturnPressed`, `Accessible.role`, `Layout.fillWidth`).
- **Ukuran implisit** — ukuran alami sebuah item (`implicitWidth`, `implicitHeight`); ukuran aktual (`width`, `height`) mengikutinya bila tidak diatur.
- **Pointer Handler** — objek nonvisual (misalnya `TapHandler`) yang menafsirkan peristiwa pointer untuk item induknya.
- **Fokus aktif (`activeFocus`)** — status item yang saat ini menerima peristiwa keyboard.
- **Rantai Tab** — urutan item yang dijangkau dengan tombol Tab; `activeFocusOnTab: true` memasukkan item ke dalamnya.
- **AT-SPI** — protokol aksesibilitas Linux (lewat D-Bus) yang dipakai pembaca layar untuk berbicara dengan aplikasi.
- **`QtObject`** — objek dasar tanpa tampilan; di sini dipakai sebagai ruang nama internal.
- **Komponen inline** — tipe yang didefinisikan di dalam berkas lain dengan kata kunci `component`.
- **`qmllint` / `qmlformat` / `qmlls`** — linter statis, pemformat, dan language server resmi QML.
- **Lifting state up** — menaruh state di leluhur terdekat yang membutuhkannya; turun lewat properti, naik lewat signal.
- **Ambient authority** — hak yang dipegang tanpa pernah diberikan secara eksplisit (di sini: menjangkau `parent` sesukanya).
- **Prinsip hak akses minimum (least privilege)** — bagian sistem hanya memegang akses yang benar-benar dibutuhkan.

## Hubungan dengan Modul Lain

- **Prasyarat:** Fase 3 (properti, binding, signal; Modul 3.4 untuk scope dan id), Modul 4.1 (`Item`, `Rectangle`, `Text`), Modul 4.2 (anchors), Modul 4.4 (input dasar, `TapHandler`).
- **Menuju Modul 5.2 (Positioner dan Layouts):** Layout membaca `implicitWidth` / `implicitHeight` komponen Anda (5.1.3) dan memakai attached property `Layout.*` yang diisi *pemakai* (5.1.4). Komponen tanpa ukuran implisit “hilang” di dalam Layout.
- **Menuju Modul 5.3 (Tema dan Singleton):** angka dan warna mentah (`32`, `6`, `#2563eb`) di `AppButton` akan diganti token `Theme.*`. Opsi “padding sebagai properti” di 5.1.3 dan `priv.padding` di 5.1.5 adalah langkah persiapannya.
- **Jalur C++ (Modul 10.1 dan seterusnya):** prinsipnya sama persis. `Q_PROPERTY` adalah properti masuk, `signals:` adalah signal keluar, dan kelas C++ yang diekspos ke QML tunduk pada pertanyaan desain API yang sama.

## Kesalahan Umum dan Solusi

1. **Tombol tidak tampak di `Row`.** *Sebab:* root `Rectangle` tanpa `implicitWidth` / `implicitHeight` berukuran 0×0. *Solusi:* isi ukuran implisit dari isi (5.1.3).
2. **Galat “Cannot assign to non-existent property onClick”.** *Sebab:* handler untuk signal yang tidak ada, atau salah eja (`onClick` alih-alih `onClicked`). *Solusi:* deklarasikan `signal clicked()` dan pakai nama handler yang tepat.
3. **Galat “Required property label was not initialized”.** *Sebab:* pemakai tidak mengisi properti `required`. *Solusi:* isi propertinya, atau beri nilai bawaan bila tanpa nilai pun komponen masih bermakna.
4. **Peringatan “Binding loop detected for property implicitWidth”.** *Sebab:* ukuran implisit diikat ke ukuran aktual. *Solusi:* hitung implisit hanya dari isi.
5. **Komponen rusak ketika dipindah ke induk lain.** *Sebab:* root membaca `parent.xxx`. *Solusi:* jadikan `xxx` properti masuk; ubah state lewat signal (5.1.4).
6. **API membengkak (semua properti `Rectangle` terpapar).** *Sebab:* root `Rectangle`. *Solusi:* root `Item` dengan tampilan internal, atau alias terbatas (5.1.7 Opsi B dan E).
7. **`property var` dipakai untuk segalanya.** *Sebab:* kemudahan. *Akibat:* tak ada pemeriksaan tipe statis dan kompilasi kurang optimal. *Solusi:* pakai tipe konkret (`string`, `int`, `bool`, `color`, `url`, `Item`).
8. **Mendeklarasikan ulang properti bawaan (`property bool enabled`).** *Sebab:* tidak tahu `Item` sudah punya. *Solusi:* periksa dokumentasi tipe dasar dan pakai yang bawaan.
9. **Mencoba mengubah anak internal dari luar (`btn.teks.text = 'x'`).** *Sebab:* menganggap id internal terlihat. *Akibat:* ReferenceError, karena id hanya berlaku dalam satu berkas. *Solusi:* tambahkan properti publik yang terarah.
10. **Mengakses properti root tanpa `root.`.** *Sebab:* kebiasaan. *Akibat:* rapuh dan diperingatkan `qmllint`. *Solusi:* selalu kualifikasi.
11. **Komponen hanya bisa diklik mouse.** *Sebab:* tidak memikirkan keyboard. *Solusi:* 5.1.6, atau turunkan dari `Button`.

## Tips dan Praktik Terbaik

- **Satu komponen, satu tanggung jawab.** Bila API publik membengkak melewati sekitar tujuh properti, pertimbangkan memecahnya.
- **Nilai bawaan yang aman.** `required` hanya untuk yang tak punya nilai bawaan yang masuk akal.
- **Tulis ringkasan API di bagian atas berkas** (properti, signal, satu contoh pemakaian). Itu dokumentasi termurah yang ada.
- **Bangun galeri uji.** Satu `Gallery.qml` yang menampilkan semua varian komponen, lalu autoreload di terminal: `ls *.qml | entr -r qml6 Gallery.qml` (`entr` ada di repositori Arch; `-r` memulai ulang proses saat berkas berubah).
- **Pilih platform tampilan dengan sadar.** Di Wayland: `QT_QPA_PLATFORM=wayland qml6 Main.qml` (butuh paket `qt6-wayland`); di X11: `QT_QPA_PLATFORM=xcb`; tanpa layar: `QT_QPA_PLATFORM=offscreen`.
- **Telusuri masalah impor:** `QML_IMPORT_TRACE=1 qml6 Main.qml` mencetak bagaimana modul dan tipe dicari.
- **Jalankan `qmllint` otomatis** (pre-commit atau CI) lewat target `all_qmllint`.
- **Perlakukan masukan sebagai tak tepercaya.** Bila komponen menerima `url` atau path dari luar (misalnya gambar avatar), batasi skema yang diizinkan (`qrc:`, `file:`) dan jangan memuat `http(s):` kecuali memang dirancang demikian. Batas API adalah batas kepercayaan.
- **Uji dengan label panjang dan kosong.** Ukuran implisit yang baik tetap masuk akal pada kasus ekstrem; pertimbangkan `elide: Text.ElideRight` pada `Text` bila lebar harus dibatasi.
- **Pikirkan aksesibilitas sejak awal.** Menambahkannya belakangan jauh lebih mahal.

## Latihan 15 Menit (versi diperbaiki)

*Koreksi dari audit:* latihan kurikulum menyuruh “menambahkan properti `enabled`”. `enabled` sudah bawaan `Item`, jadi tugasnya diubah menjadi *memakai* properti bawaan itu.

1. Pakai `AppButton` versi 5.1.6 dan `Main.qml` dari 5.1.1.
2. Tambahkan tombol kedua: `AppButton { label: 'Hapus'; enabled: false }`.
3. Ubah `color` di `AppButton` agar tombol tampak abu-abu ketika `root.enabled` bernilai salah.
4. Klik tombol nonaktif, lalu tekan Tab. Amati terminal dan fokus.
5. Jalankan `qmlformat6 -i AppButton.qml` dan `qmllint6 AppButton.qml`, lalu bereskan temuannya.
6. *Tantangan opsional:* tulis ulang komponen sebagai Opsi B atau Opsi C dan bandingkan jumlah kode serta perilaku keyboard-nya.

**Kunci jawaban** (coba dulu sebelum membaca):

```qml
// Langkah 3 — versi satu ekspresi bersarang
color: !root.enabled ? '#9ca3af' : (tap.pressed ? '#1d4ed8' : '#2563eb')

// Alternatif: biarkan warna apa adanya dan redupkan seluruh komponen
opacity: root.enabled ? 1.0 : 0.5
```

Yang akan Anda amati pada langkah 4: tidak ada tambahan kode untuk memblokir klik, namun klik pada tombol nonaktif tidak mencetak apa pun di terminal, dan Tab melewatinya. Dokumentasi `Item.enabled` menyatakan bahwa properti ini menentukan apakah item menerima peristiwa mouse dan keyboard; `TapHandler` yang menempel padanya ikut tidak menerima peristiwa. Buktikan sendiri lewat eksperimen, itulah cara terbaik mengingatnya.

## Cek Pemahaman dan Kunci

1. **Mengapa komponen sebaiknya tidak membaca `parent.width`?** *Kunci:* `parent` objek root bergantung pada tempat pemakaian (Row, Loader, delegate, bahkan `null`), sehingga komponen menggantungkan diri pada kontrak yang tidak tertulis dan tidak dapat diperiksa alat. Pengecualian: `parent` milik anak di dalam berkas yang sama, atau attached property dengan kontrak terdokumentasi seperti `ListView.view`.
2. **Apa beda `width` dan `implicitWidth`?** *Kunci:* `implicitWidth` adalah ukuran alami yang ditetapkan komponen dari isinya; `width` adalah ukuran aktual yang bisa ditimpa pemakai atau Layout dan mengikuti `implicitWidth` bila tidak diatur.
3. **Apa yang terjadi bila `AppButton` dipakai tanpa `label`?** *Kunci:* karena `required`, objek gagal dibuat dengan galat “Required property label was not initialized”. Bila diberi nilai bawaan, tombol akan tampil tanpa teks.
4. **Mengapa signal dipakai untuk keluaran, bukan memanggil fungsi milik induk?** *Kunci:* komponen tidak tahu siapa pendengarnya. Signal menjaga kopling longgar dan membiarkan pemilik state yang memutuskan perubahan.
5. **Kapan memilih root `Item` ketimbang `Rectangle`?** *Kunci:* ketika API publik harus ketat dan tidak boleh membocorkan properti tampilan seperti `color` atau `border`.

## Referensi Tambahan

- [On the Criteria To Be Used in Decomposing Systems into Modules — D. L. Parnas, 1972](https://doi.org/10.1145/361598.361623)
- [Unix philosophy — Wikipedia](https://en.wikipedia.org/wiki/Unix_philosophy)
- [Qt — Arch Wiki (style, platform, variabel lingkungan)](https://wiki.archlinux.org/title/Qt)
- [entr — jalankan perintah saat berkas berubah](https://eradman.com/entrproject/)
- [Qt Quick Controls — gambaran umum](https://doc.qt.io/qt-6/qtquickcontrols-index.html)
- [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html) (untuk Modul 5.2)

---

*Rancang antarmukanya dengan tenang; ketenangan itulah yang menjaga sistem besar tetap bisa dipahami.*

# Fase 5 · Modul 5.2 — Positioner dan Layouts

*ff**Kurikulum Qt 6 QML · Fase 5 (Komponen, Layout, dan Styling) · Modul 2 dari 3 (5.1 → 5.2 → 5.3)*

## Daftar Isi Modul 5.2

- Audit singkat Modul 5.2 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 5.2.1 `Row` / `Column` / `Grid` / `Flow`
- 5.2.2 `RowLayout` / `ColumnLayout` / `GridLayout`
- 5.2.3 Attached property `Layout`
- 5.2.4 Positioner vs Layout
- 5.2.5 Responsif terhadap ukuran jendela
- 5.2.6 \[TAMBAHAN\] `StackLayout` dan pembagi ruang lain
- 5.2.7 \[TAMBAHAN\] Fitur lanjut dan yang jarang dibahas
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Referensi tambahan

## Audit Singkat Modul 5.2 (sebelum materi dimulai)

Urutan Modul 5.2 logis: ia memakai `implicitWidth` dan `implicitHeight` yang diajarkan di 5.1.3, dan sisi pemakai `Layout.*` yang ditegaskan di 5.1.4. Temuan yang dibereskan:

1. **\[Klarifikasi\] `anchors` dan Layout.** Contoh kurikulum memakai `anchors.fill: parent` pada `RowLayout`, sedangkan bagian kesalahan umum melarang `anchors` pada anak Layout. Keduanya benar. Yang dilarang adalah `anchors` pada *anak yang dikelola Layout*; `RowLayout` di akar jendela bukan anak Layout, jadi boleh. Dijelaskan di 5.2.2.
2. **\[Tambahan\] 5.2.6 `StackLayout`.** Anggota keempat `QtQuick.Layouts` ini belum ada di daftar. Ditambahkan beserta pembanding (`SplitView`, `Loader`).
3. **\[Tambahan\] 5.2.3 dan 5.2.7.** Belum tercakup: `Layout.row` / `column` / `rowSpan` / `columnSpan`, `Layout.margins`, faktor regang (`horizontalStretchFactor`, Qt 6.5 ke atas), `uniformCellSizes` (Qt 6.6 ke atas), `layoutDirection` dan mirroring, serta transisi dan atribut `Positioner.*`.
4. **\[Tambahan\] Perilaku `visible: false` dan `Repeater`.** Cara positioner dan Layout memperlakukan item tak terlihat, serta pemakaian `Repeater` di dalamnya, dimasukkan ke 5.2.1 dan 5.2.2.
5. **\[Klarifikasi\] Tidak ada Layout yang membungkus baris.** Hanya `Flow` (positioner) yang membungkus. Untuk Layout, polanya `GridLayout` dengan `columns` yang terikat ke lebar; dijelaskan di 5.2.5.
6. **\[Klarifikasi\] Latihan `GridLayout`.** Isi form tidak ditentukan. Di sini dipakai `Label` dan `TextField` dari Qt Quick Controls (style Basic) hanya sebagai isi contoh; Controls tidak didalami di modul ini.
7. **\[Tambahan\] 5.2.5.** Ditambahkan ukuran jendela awal dan minimum yang diturunkan dari Layout, termasuk catatan untuk window manager tiling.
8. **\[Asumsi\] `Repeater`.** Dianggap sudah dikenal dari Fase 4; bila belum, diperkenalkan singkat di 5.2.1.

**Daftar Modul 5.2 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

- 5.2.1 `Row` / `Column` / `Grid` / `Flow`
- 5.2.2 `RowLayout` / `ColumnLayout` / `GridLayout`
- 5.2.3 Attached property `Layout`
- 5.2.4 Positioner vs Layout
- 5.2.5 Responsif terhadap ukuran jendela
- &#91;+\] 5.2.6 `StackLayout` dan pembagi ruang lain
- &#91;+\] 5.2.7 Fitur lanjut dan yang jarang dibahas

**Asumsi prasyarat.** Modul 5.1 (ukuran implisit, id, API komponen), Modul 4.1 (`Item`, `Rectangle`, `Text`), Modul 4.2 (anchors), dan dasar properti serta binding dari Fase 3.

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini mengajarkan cara menata banyak item tanpa menghitung koordinat satu per satu: empat *positioner* (`Row`, `Column`, `Grid`, `Flow`) yang hanya menaruh item, dan tiga (plus satu) *Layout* (`RowLayout`, `ColumnLayout`, `GridLayout`, `StackLayout`) yang menaruh *dan* mengatur ukuran item.

### Peran dalam kurikulum

Di 5.1 Anda membuat komponen yang jujur soal ukuran implisitnya. Di sini ukuran itu mulai dipakai: Layout membacanya sebagai ukuran pilihan. Di 5.3 Anda memusatkan spasi dan warna; angka seperti `spacing: 8` dan `margins: 12` di modul ini adalah calon token tema.

### Konsep kunci dan filosofi

- **Analogi rak dan pengatur ruangan.** Positioner seperti rak: barang ditaruh berurutan apa adanya, besar-kecil barang bukan urusannya. Layout seperti pengatur ruangan: ia bertanya “masing-masing butuh berapa?”, lalu membagi ruang yang ada dan mengubah ukuran barang agar semuanya muat.
- **Deklarasikan hubungan, bukan koordinat.** Menulis `x: 137` mengikat tampilan pada satu ukuran jendela, satu skala layar, satu font. Menulis “ini mengisi sisa lebar, itu 80 piksel” tetap benar di ukuran mana pun.
- **Tata letak adalah negosiasi.** Induk menawarkan ruang; anak menyatakan kebutuhan (minimum, pilihan, maksimum); Layout menengahi. Karena itu *anak* yang menyatakan `Layout.*`, bukan induknya.
- **Determinisme.** Tata letak yang diturunkan dari aturan akan bereaksi sama pada ukuran, skala DPI, dan font yang berbeda. Koordinat absolut mudah membuat elemen saling menimpa pada skala tak terduga, dan elemen kritis (misalnya konfirmasi atau peringatan) bisa tertutup tanpa disadari.
- **Hidup di window manager tiling.** Di i3, sway, dwm, atau Hyprland, jendela Anda diubah ukurannya terus-menerus dan tidak selalu menghormati ukuran minimum. Aplikasi yang tata letaknya negosiatif tetap rapi; yang berkoordinat tetap akan terpotong.

Peta mekanisme penataan (dari paling manual ke paling otomatis):

```
 x, y, width, height ......... manual penuh: Anda hitung semuanya
 anchors ..................... hubungan antar-item (tepi atau pusat), bukan pembagian ruang
 Row / Column / Grid / Flow .. posisi otomatis; ukuran anak TIDAK diubah
 RowLayout / ColumnLayout /
 GridLayout / StackLayout .... posisi DAN ukuran dinegosiasikan (min / pilihan / maks)
```

## 5.2.1 `Row` / `Column` / `Grid` / `Flow`

### Dasar: apa itu positioner?

Positioner adalah `Item` khusus yang mengatur posisi anak-anaknya dengan mengisi `x` dan `y` mereka. Ia **tidak mengubah ukuran** anak: ia hanya membaca `width` dan `height` tiap anak (yang, bila tidak diatur, mengikuti ukuran implisit dari 5.1.3) lalu menaruhnya berurutan. Ia memperbarui penataan secara otomatis ketika anak ditambah, dihapus, berganti ukuran, atau berganti `visible`. Positioner sendiri punya ukuran implisit yang diturunkan dari isinya.

```
 Row                 Column      Grid (columns: 3)        Flow (lebar terbatas)
 [A][B][C]           [A]         [A][B][C]                [A][B][C][D]
                     [B]         [D][E][F]                [E][F]
                     [C]
```

### Sintaks dan properti penting

```
Row    { spacing; layoutDirection; padding }              // kiri-ke-kanan (atau sebaliknya)
Column { spacing; padding }                               // atas-ke-bawah
Grid   { columns; rows; rowSpacing; columnSpacing; spacing;
         flow; layoutDirection;
         horizontalItemAlignment; verticalItemAlignment } // kotak berbaris-kolom
Flow   { flow; layoutDirection; spacing }                 // membungkus saat ruang habis
```

- `spacing` — jarak antar-item sepanjang sumbu tata (piksel).
- `padding` — ruang kosong di tepi dalam positioner (juga `leftPadding`, `topPadding`, dst.).
- `layoutDirection` — `Qt.LeftToRight` (bawaan) atau `Qt.RightToLeft`.
- `Grid.columns` / `Grid.rows` — jumlah kolom atau baris; isi eksplisit agar tidak bergantung nilai bawaan. `Grid.flow` — `Grid.LeftToRight` (mengisi per baris) atau `Grid.TopToBottom` (mengisi per kolom).
- `Grid.horizontalItemAlignment` dan `verticalItemAlignment` — perataan item di dalam selnya. Ukuran sel adalah ukuran item terbesar di kolom atau barisnya.
- `Flow` membungkus ketika ruang habis, sehingga **butuh `width` (atau `height`) yang terbatas**; tanpa itu ia tak punya alasan membungkus.

### Contoh inti

```qml
import QtQuick

Window {
    width: 420; height: 360; visible: true
    title: 'Positioner'

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Row {
            spacing: 8
            Repeater {
                model: 4
                Rectangle {
                    required property int index
                    width: 40 + index * 10
                    height: 40
                    color: 'tomato'
                    radius: 4
                }
            }
        }

        Grid {
            columns: 3
            rowSpacing: 8
            columnSpacing: 8
            Repeater {
                model: 6
                Rectangle { width: 56; height: 36; color: 'seagreen' }
            }
        }

        Flow {
            width: parent.width
            spacing: 6
            Repeater {
                model: 12
                Rectangle { width: 70; height: 28; color: 'steelblue' }
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `Window { width: 420; height: 360; visible: true }` — jendela tingkat atas; `visible: true` wajib agar tampil.
- `Column { anchors.fill: parent; anchors.margins: 12; spacing: 12 }` — kolom yang memenuhi jendela dengan margin 12; anak-anaknya (tiga blok) ditumpuk dengan jarak 12. `anchors` di sini sah karena `Column` sendiri bukan anak positioner; ia anak `Window`.
- `Row { spacing: 8 }` — baris dengan jarak 8 antar-isi.
- `Repeater { model: 4; Rectangle {...} }` — `Repeater` membuat salinan delegate sebanyak model (di sini bilangan 4 berarti empat salinan). Item hasilnya dimasukkan sebagai anak dari induk `Repeater` (yaitu `Row`), sehingga ikut ditata positioner.
- `required property int index` — delegate menerima nomor urutnya lewat properti bernama `index`; menandainya `required` adalah gaya Qt 6 yang eksplisit dan aman bagi `qmllint`.
- `width: 40 + index * 10` — tiap kotak sedikit lebih lebar: bukti bahwa `Row` tidak menyeragamkan ukuran, ia hanya menata.
- `Grid { columns: 3 }` — enam kotak disusun menjadi 2 baris × 3 kolom; `rowSpacing` dan `columnSpacing` mengatur jarak per sumbu.
- `Flow { width: parent.width }` — `Flow` diberi lebar agar tahu kapan membungkus; dua belas kotak akan turun ke baris berikutnya saat lebar habis. Di sini `parent.width` sah karena ditulis di berkas yang sama oleh pemakai yang tahu pohonnya (5.1.4).

### Eksperimen: item tak terlihat

```qml
import QtQuick

Window {
    width: 320; height: 100; visible: true

    Item {
        anchors.fill: parent
        TapHandler { onTapped: tengah.visible = !tengah.visible }

        Row {
            x: 10; y: 10; spacing: 8
            Rectangle { width: 60; height: 40; color: 'tomato' }
            Rectangle { id: tengah; width: 60; height: 40; color: 'gold' }
            Rectangle { width: 60; height: 40; color: 'seagreen' }
        }
    }
}
```

Klik jendela: kotak emas menghilang *dan kotak hijau bergeser mengisi tempatnya*. Positioner tidak menyertakan item ber-`visible: false` dalam penataan. Coba ganti dengan `opacity` dan amati apakah celahnya tetap ada; membuktikan sendiri lebih kuat daripada menghafal.

### Opsi lain untuk hasil yang sama

Tiga kotak berjajar dapat dibuat dengan tiga cara:

```qml
// Opsi 1 — positioner (deklaratif, ringkas)
Row {
    spacing: 8
    Rectangle { id: a; width: 60; height: 40; color: 'tomato' }
    Rectangle { id: b; width: 60; height: 40; color: 'gold' }
    Rectangle { id: c; width: 60; height: 40; color: 'seagreen' }
}

// Opsi 2 — anchors berantai (eksplisit, rapuh bila item disisipkan)
Rectangle { id: a; width: 60; height: 40; color: 'tomato' }
Rectangle { id: b; width: 60; height: 40; color: 'gold';     anchors.left: a.right; anchors.leftMargin: 8 }
Rectangle { id: c; width: 60; height: 40; color: 'seagreen'; anchors.left: b.right; anchors.leftMargin: 8 }

// Opsi 3 — binding x manual (paling rapuh: Anda yang menjaga semuanya)
Rectangle { id: a; x: 0;                  width: 60; height: 40; color: 'tomato' }
Rectangle { id: b; x: a.x + a.width + 8;  width: 60; height: 40; color: 'gold' }
Rectangle { id: c; x: b.x + b.width + 8;  width: 60; height: 40; color: 'seagreen' }
```

Opsi 1 adalah yang paling mudah dirawat: menyisipkan item baru tidak mengubah kode item lain. Opsi 2 dan 3 membuat setiap item bergantung pada tetangganya.

### Hal yang perlu diperhatikan

- **Jangan mengisi `x`/`y` atau `anchors` searah sumbu tata pada anak positioner.** Positioner menulis `x`/`y` anak; hasilnya bertabrakan dan Qt mencatat peringatan bernada “Cannot specify ... anchors for items inside Row”.
- **Positioner tidak mengubah ukuran anak.** Anak ber-`width: 0` tetap ber-`width` 0.
- **`Grid` menyamakan ukuran *sel*, bukan ukuran anak.** Item kecil dalam sel besar tetap kecil.
- **`Flow` tanpa lebar tidak pernah membungkus.**

**Referensi bagian ini:** [Item Positioners](https://doc.qt.io/qt-6/qtquick-positioning-topic.html) · [Row](https://doc.qt.io/qt-6/qml-qtquick-row.html) · [Column](https://doc.qt.io/qt-6/qml-qtquick-column.html) · [Grid](https://doc.qt.io/qt-6/qml-qtquick-grid.html) · [Flow](https://doc.qt.io/qt-6/qml-qtquick-flow.html) · [Repeater](https://doc.qt.io/qt-6/qml-qtquick-repeater.html)

## 5.2.2 `RowLayout` / `ColumnLayout` / `GridLayout`

### Dasar: apa bedanya dengan positioner?

Layout berasal dari modul terpisah: `import QtQuick.Layouts`. Selain menaruh anak, Layout **menetapkan ukuran** anak lewat negosiasi tiga angka per sumbu:

```
 Setiap anak melapor ke Layout:
   minimum      <=   pilihan (preferred)   <=   maksimum
   Layout.minimumWidth  Layout.preferredWidth    Layout.maximumWidth
   (bawaan: 0)          (bawaan: implicitWidth)  (bawaan: tak terbatas)

 Layout membagi lebar tersedia W:
   1. mulai dari ukuran pilihan tiap anak
   2. bila total < W : anak ber-fillWidth tumbuh (hingga maksimum)
   3. bila total > W : anak menyusut (hingga minimum)
   4. hasil akhir ditulis Layout ke x, y, width, height tiap anak
```

Di sinilah ukuran implisit dari 5.1.3 berguna: tanpanya, ukuran pilihan komponen Anda adalah 0.

### Sintaks dan properti penting

```
RowLayout    { spacing; layoutDirection; uniformCellSizes }          // satu baris
ColumnLayout { spacing; layoutDirection; uniformCellSizes }          // satu kolom
GridLayout   { columns; rows; columnSpacing; rowSpacing; flow;
               layoutDirection; uniformCellWidths; uniformCellHeights }
```

`uniformCellSizes`, `uniformCellWidths`, dan `uniformCellHeights` tersedia mulai Qt 6.6 (lihat 5.2.7).

### Contoh inti (dari kurikulum)

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

### Bedah kode (kata demi kata)

- `import QtQuick.Layouts` — memuat modul Layout. Tanpa baris ini `RowLayout` dan attached property `Layout` tidak dikenal.
- `RowLayout { anchors.fill: parent; anchors.margins: 12; spacing: 8 }` — layout memenuhi jendela dengan margin 12; jarak antar-anak 8. **`anchors` di sini sah**: `RowLayout` ini adalah *akar* tata letak, anak langsung `Window`, bukan anak Layout lain.
- `Rectangle { color: 'tomato'; Layout.preferredWidth: 80; Layout.fillHeight: true }` — `Layout.preferredWidth: 80` menyatakan “lebar pilihan saya 80” (Rectangle sendiri tak punya ukuran implisit, jadi tanpa ini lebarnya 0). `Layout.fillHeight: true` berarti “saya boleh tumbuh sampai penuh tinggi”. `Layout.` adalah *attached property*: Layout “menempelkan” atribut ini ke anaknya.
- `Rectangle { color: 'seagreen'; Layout.fillWidth: true; Layout.fillHeight: true }` — `Layout.fillWidth: true` berarti “saya mengambil sisa lebar”. Kotak merah tetap 80 (tidak ber-`fillWidth`), kotak hijau menyerap sisanya.

Uji sendiri: tarik tepi jendela. Kotak merah tetap 80 piksel; kotak hijau melebar dan menyempit. Lalu hapus `Layout.preferredWidth: 80` dan lihat kotak merah menjadi 0.

### Aturan penting

- **Anak Layout tidak boleh memakai `anchors`.** Layout yang menulis posisi dan ukuran; `anchors` pada anak membuat perilaku tak terdefinisi, dan Qt mencatat peringatan “Detected anchors on an item that is managed by a layout”. Gunakan `Layout.alignment` untuk perataan.
- **Jangan mengatur `width` / `height` anak Layout untuk mengendalikan ukuran.** Layout akan menimpanya. Gunakan `Layout.preferredWidth`, `Layout.minimumWidth`, `Layout.maximumWidth`, dan `fillWidth`.
- **Item `visible: false` diabaikan Layout** dan ruangnya dibebaskan (seperti positioner); buktikan lewat eksperimen 5.2.1 dengan `RowLayout`.
- **`Layout.*` hanya bermakna bila induk langsungnya Layout.** Menulis `Layout.fillWidth: true` pada anak `Row` tidak melakukan apa-apa, dan tidak ada galat yang memberi tahu Anda.

### Opsi lain untuk logika yang sama

```qml
// Opsi 1 — RowLayout (versi kurikulum): sisa lebar diisi otomatis
RowLayout {
    anchors.fill: parent
    Rectangle { Layout.preferredWidth: 80; Layout.fillHeight: true; color: 'tomato' }
    Rectangle { Layout.fillWidth: true;    Layout.fillHeight: true; color: 'seagreen' }
}

// Opsi 2 — Row + hitung manual (rapuh: angka 88 = 80 + spacing yang harus Anda jaga)
Row {
    anchors.fill: parent; spacing: 8
    Rectangle { width: 80; height: parent.height; color: 'tomato' }
    Rectangle { width: parent.width - 88; height: parent.height; color: 'seagreen' }
}

// Opsi 3 — anchors (tepat, tetapi hanya untuk pola kiri-kanan sederhana)
Rectangle { id: kiri; width: 80; anchors { left: parent.left; top: parent.top; bottom: parent.bottom } color: 'tomato' }
Rectangle { anchors { left: kiri.right; leftMargin: 8; right: parent.right; top: parent.top; bottom: parent.bottom } color: 'seagreen' }
```

Opsi 2 memakai `parent.width` dan angka ajaib; ubah `spacing` dan ia salah. Opsi 3 benar tetapi tidak berskala ke tiga atau lima kolom. Opsi 1 tetap benar tanpa Anda menghitung apa pun.

### `ColumnLayout` dan teks yang membungkus

```qml
ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 8

    Text {
        Layout.fillWidth: true
        text: 'Teks panjang akan turun ke baris berikutnya bila lebar jendela mengecil.'
        wrapMode: Text.WordWrap
    }
    Item { Layout.fillHeight: true }   // pengganjal: mendorong isi di atasnya ke atas
}
```

- `wrapMode: Text.WordWrap` — teks membungkus per kata, *tetapi hanya bila lebarnya dibatasi*. Itu sebabnya `Layout.fillWidth: true` wajib: lebar `Text` menjadi lebar Layout, bukan lebar teks tak-terbungkus.
- `Item { Layout.fillHeight: true }` — “pengganjal” (spacer): item kosong yang menyerap sisa tinggi.

**Referensi bagian ini:** [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html) · [Qt Quick Layouts Overview](https://doc.qt.io/qt-6/qtquicklayouts-overview.html) · [RowLayout](https://doc.qt.io/qt-6/qml-qtquick-layouts-rowlayout.html) · [ColumnLayout](https://doc.qt.io/qt-6/qml-qtquick-layouts-columnlayout.html) · [GridLayout](https://doc.qt.io/qt-6/qml-qtquick-layouts-gridlayout.html) · [Layout (attached)](https://doc.qt.io/qt-6/qml-qtquick-layouts-layout.html)

## 5.2.3 Attached property `Layout`

### Dasar: apa itu attached property (dan mengapa `Layout.` ditulis di anak)?

Attached property adalah atribut yang “ditempelkan” tipe lain ke sebuah objek. Sintaksnya `NamaTipe.properti: nilai`. `Layout` menempelkan atribut ke setiap *anak langsung* Layout (`Layout.fillWidth`, `Layout.preferredWidth`, dst.), karena ukuran kebutuhan adalah pernyataan si anak, bukan perintah induknya. Itu juga sebabnya pada Modul 5.1 komponen tidak menulis `Layout.*` untuk dirinya sendiri: yang menulisnya adalah *pemakai* komponen.

```qml
AppButton {
    label: 'Simpan'
    Layout.fillWidth: true      // ditulis oleh pemakai, bukan di dalam AppButton.qml
    Layout.alignment: Qt.AlignRight
}
```

Membaca nilainya dari luar dilakukan dengan `item.Layout.fillWidth`. Atribut ini hanya berlaku bila induk langsung item adalah sebuah Layout.

### Daftar atribut (dikelompokkan)

- **Ukuran:** `minimumWidth`, `minimumHeight`, `preferredWidth`, `preferredHeight`, `maximumWidth`, `maximumHeight`.
  - `minimum*` bawaannya 0; `maximum*` bawaannya tak terbatas.
  - `preferred*` bernilai negatif (-1) secara bawaan, yang artinya “pakai ukuran implisit item” (5.1.3).
- **Pengisian:** `fillWidth`, `fillHeight`. Bernilai `false` secara bawaan (item bertahan pada ukuran pilihannya); kecuali Layout bersarang, yang secara bawaan `true`. Bila `true`, item tumbuh selebar mungkin sambil menghormati minimum dan maksimum.
- **Perataan:** `alignment` (`Qt.AlignLeft`, `Qt.AlignRight`, `Qt.AlignHCenter`, `Qt.AlignTop`, `Qt.AlignBottom`, `Qt.AlignVCenter`, `Qt.AlignCenter`), digabung dengan operator `|`. Berpengaruh pada item yang tidak memenuhi seluruh selnya.
- **Margin:** `margins` (semua sisi), `leftMargin`, `rightMargin`, `topMargin`, `bottomMargin`. Ruang kosong *di luar* item namun di dalam selnya.
- **Khusus `GridLayout`:** `row`, `column` (penempatan eksplisit), `rowSpan`, `columnSpan` (merentang beberapa sel).
- **Faktor regang (Qt 6.5 ke atas):** `horizontalStretchFactor`, `verticalStretchFactor`. Mengatur pembagian ruang sisa secara proporsional di antara item yang boleh tumbuh. Tersedia mulai Qt 6.5; periksa versi Anda.

### Contoh: form dua kolom dengan rentang dan perataan

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Window {
    visible: true
    title: 'Form'
    width: 360; height: 180
    minimumWidth: 280; minimumHeight: 160

    GridLayout {
        anchors.fill: parent
        anchors.margins: 16
        columns: 2
        columnSpacing: 12
        rowSpacing: 8

        Label { text: 'Nama' }
        TextField { Layout.fillWidth: true; placeholderText: 'Nama lengkap' }

        Label { text: 'Email' }
        TextField { Layout.fillWidth: true; placeholderText: 'nama@contoh.id' }

        Button {
            text: 'Simpan'
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignRight
        }
    }
}
```

### Bedah kode (kata demi kata)

- `import QtQuick.Controls.Basic` — hanya untuk memperoleh `Label`, `TextField`, `Button` sebagai isi contoh. Controls bukan topik modul ini.
- `minimumWidth: 280; minimumHeight: 160` — properti `Window` yang melarang pengguna (dan window manager yang patuh) mengecilkan jendela di bawah ukuran itu.
- `GridLayout { columns: 2 }` — dua kolom; anak-anak mengisi sel dari kiri ke kanan, lalu turun baris. `columnSpacing` dan `rowSpacing` mengatur jarak per sumbu.
- `Label { text: 'Nama' }` — sel (baris 0, kolom 0). Tanpa `fillWidth`, kolom pertama selebar label terlebar (`Email`) karena kolom Grid mengikuti anak terbesarnya.
- `TextField { Layout.fillWidth: true }` — sel (0, 1) menyerap sisa lebar. Karena kolom 2 berisi dua item ber-`fillWidth`, kolom itulah yang melebar saat jendela dilebarkan.
- `Button { Layout.columnSpan: 2; Layout.alignment: Qt.AlignRight }` — tombol merentang dua kolom (`columnSpan: 2`), lalu diratakan ke kanan di dalam rentang itu (`Qt.AlignRight`).

### Opsi lain untuk logika yang sama

```qml
// Opsi 1 — GridLayout (di atas): kolom otomatis sejajar, rentang tersedia

// Opsi 2 — ColumnLayout berisi RowLayout: kolom label harus disejajarkan MANUAL
ColumnLayout {
    RowLayout {
        Label { text: 'Nama'; Layout.preferredWidth: 80 }
        TextField { Layout.fillWidth: true }
    }
    RowLayout {
        Label { text: 'Email'; Layout.preferredWidth: 80 }
        TextField { Layout.fillWidth: true }
    }
}

// Opsi 3 — penempatan eksplisit dengan Layout.row / Layout.column
GridLayout {
    columns: 2
    Label     { text: 'Email'; Layout.row: 1; Layout.column: 0 }
    TextField { Layout.row: 1; Layout.column: 1; Layout.fillWidth: true }
    Label     { text: 'Nama';  Layout.row: 0; Layout.column: 0 }
    TextField { Layout.row: 0; Layout.column: 1; Layout.fillWidth: true }
}
```

Opsi 2 memaksa Anda menjaga angka `80` agar label sejajar; tambah label yang lebih panjang dan sejajarnya rusak. Opsi 3 berguna ketika urutan penulisan di kode berbeda dari urutan tampilan.

### Hal yang perlu diperhatikan

- `Layout.preferredWidth: 80` **bukan** sama dengan `width: 80`: yang pertama adalah *usulan* dalam negosiasi, yang kedua akan ditimpa Layout.
- Bila jendela dikecilkan hingga lebih sempit daripada jumlah ukuran pilihan, Layout memampatkan anak menuju ukuran minimumnya. Anak yang `minimumWidth`-nya 0 bisa menyusut sampai hilang. Eksperimen: kecilkan jendela contoh 5.2.2 dan lihat apa yang terjadi, lalu tahan dengan `Layout.minimumWidth: 40`.
- `Layout.margins` bertambah ke ukuran sel item; ia bukan `anchors.margins`.

**Referensi bagian ini:** [Layout (attached properties)](https://doc.qt.io/qt-6/qml-qtquick-layouts-layout.html) · [Qt Quick Layouts Overview](https://doc.qt.io/qt-6/qtquicklayouts-overview.html) · [Attached properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [GridLayout](https://doc.qt.io/qt-6/qml-qtquick-layouts-gridlayout.html)

## 5.2.4 Positioner vs Layout

### Perbandingan

- **Ukuran anak.** Positioner tidak mengubahnya; Layout menetapkannya lewat negosiasi minimum, pilihan, maksimum.
- **Reaksi terhadap ukuran wadah.** Positioner tidak peduli (kecuali `Flow`, yang membungkus); Layout membagi ulang ruang setiap kali wadah berubah.
- **Fitur penataan.** Layout punya perataan (`alignment`), margin per item, rentang sel (`columnSpan`, `rowSpan`), dan faktor regang. Positioner hanya punya `spacing`, `padding`, dan perataan item pada `Grid`.
- **Pembungkusan baris.** Hanya `Flow` (positioner) yang membungkus; tidak ada “FlowLayout”.
- **Transisi.** Positioner mendukung `add`, `move`, dan `populate` (animasi saat item masuk, bergerak, atau pertama kali muncul); Layout tidak.
- **Beban.** Positioner lebih ringan; Layout melakukan negosiasi tiga ukuran per item dan wajar untuk UI biasa, tetapi sebaiknya jangan disarangkan sangat dalam atau diisi ratusan item sekaligus.
- **Modul.** Positioner ada di `QtQuick`; Layout butuh `import QtQuick.Layouts`.

### Peta keputusan

```
 Apakah ukuran anak harus menyesuaikan ruang yang tersedia?
  |
  +-- YA  --> Layout (RowLayout / ColumnLayout / GridLayout)
  |            |-- ada kolom sejajar atau rentang sel?  --> GridLayout
  |            '-- hanya satu arah?                      --> RowLayout / ColumnLayout
  |
  '-- TIDAK (ukuran anak sudah pasti)
       |-- perlu pembungkusan otomatis?                  --> Flow
       |-- perlu animasi saat item masuk atau pindah?    --> Row / Column / Grid + transisi
       '-- deretan sederhana berukuran tetap?            --> Row / Column / Grid
```

### Contoh pemakaian yang tepat

- **Row:** deretan ikon berukuran tetap pada toolbar.
- **Flow:** kumpulan label (tag) yang harus membungkus ke baris berikutnya.
- **Grid:** papan permainan atau galeri dengan sel seragam.
- **RowLayout:** baris tombol dialog (pengganjal melebar di kiri, tombol berukuran tetap di kanan).
- **ColumnLayout:** kolom halaman dengan bagian atas tetap dan bagian tengah mengisi sisa tinggi.
- **GridLayout:** form berlabel.

### Menggabungkan keduanya

```qml
ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12

    Flow {
        Layout.fillWidth: true
        spacing: 6
        Repeater {
            model: 20
            Rectangle { width: 64; height: 26; radius: 13; color: 'steelblue' }
        }
    }

    Item { Layout.fillHeight: true }
}
```

Polanya umum: `Flow` mendapat lebarnya dari Layout (`Layout.fillWidth: true`) dan membungkus sesuai lebar itu. Satu catatan jujur: karena tinggi `Flow` bergantung pada lebarnya, awasi log terminal; bila muncul peringatan “Detected recursive rearrange”, bungkus `Flow` dalam item bertinggi tetap atau beri `Layout.preferredHeight` yang pasti.

### Transisi pada positioner (sekilas)

```qml
Row {
    spacing: 8
    add:  Transition { NumberAnimation { property: 'opacity'; from: 0; to: 1; duration: 200 } }
    move: Transition { NumberAnimation { properties: 'x,y'; duration: 200 } }
    // ... anak-anak, atau Repeater ...
}
```

`add` dijalankan saat item ditambahkan, `move` saat posisinya bergeser karena perubahan lain. Layout tidak punya padanan ini. Animasi sendiri adalah topik terpisah; di sini cukup tahu bahwa fitur ini hanya ada pada positioner.

**Referensi bagian ini:** [Item Positioners](https://doc.qt.io/qt-6/qtquick-positioning-topic.html) · [Qt Quick Layouts Overview](https://doc.qt.io/qt-6/qtquicklayouts-overview.html) · [Transition](https://doc.qt.io/qt-6/qml-qtquick-transition.html)

## 5.2.5 Responsif terhadap ukuran jendela

### Dasar: apa arti responsif?

Antarmuka responsif tetap benar ketika ukuran jendela, skala layar (DPI), font, atau panjang teks berubah. Di QML ini dicapai dengan menumpuk beberapa teknik dari yang paling sederhana:

1. **Aturan Layout** (`fillWidth`, `minimum`, `maximum`): sudah responsif tanpa kode tambahan.
2. **Binding** pada ukuran (misalnya `columns` bergantung pada `width`) untuk titik patah (*breakpoint*).
3. **`Flow`** untuk konten yang boleh membungkus.
4. **Batas lebar konten** dengan `Layout.maximumWidth`.
5. **Ukuran jendela** yang diturunkan dari isi dan batas minimum yang jelas.

### Contoh inti: grid dengan titik patah

```qml
import QtQuick
import QtQuick.Layouts

Window {
    visible: true
    width: 640; height: 400
    minimumWidth: 240; minimumHeight: 200

    GridLayout {
        id: grid
        anchors.fill: parent
        anchors.margins: 12
        columns: grid.width < 400 ? 1 : (grid.width < 720 ? 2 : 3)
        columnSpacing: 12
        rowSpacing: 12

        Repeater {
            model: 6
            Rectangle {
                required property int index
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                radius: 8
                color: Qt.hsla(index / 6, 0.55, 0.55, 1)
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `minimumWidth: 240; minimumHeight: 200` — batas bawah jendela; ukuran yang tak ingin Anda layani.
- `id: grid` — nama agar `columns` dapat merujuk lebar layout itu sendiri secara eksplisit.
- `columns: grid.width < 400 ? 1 : (grid.width < 720 ? 2 : 3)` — *binding bersyarat bersarang*: lebar di bawah 400 piksel satu kolom, di bawah 720 dua kolom, selain itu tiga. Binding dihitung ulang setiap lebar berubah. Tidak ada binding loop: `columns` memengaruhi tinggi, bukan lebar.
- `Repeater { model: 6 }` — enam kotak sebagai anak `GridLayout` (diteruskan ke Layout, bukan ke Repeater).
- `Layout.fillWidth: true` — tiap kotak mengisi lebar selnya; `Layout.preferredHeight: 90` — tinggi tetap 90.
- `Qt.hsla(index / 6, 0.55, 0.55, 1)` — membuat warna dari Hue, Saturation, Lightness, Alpha (masing-masing 0 sampai 1); membagi `index` dengan 6 membuat enam warna berbeda hanya dengan satu baris.

### Batas lebar konten (kolom terpusat)

```qml
ColumnLayout {
    anchors.fill: parent

    ColumnLayout {
        Layout.fillWidth: true
        Layout.maximumWidth: 600
        Layout.alignment: Qt.AlignHCenter
        // ... konten halaman ...
    }
}
```

Konten melebar mengikuti jendela hingga 600 piksel lalu berhenti dan berada di tengah. Pola yang sama dengan `max-width` + `margin: auto` pada CSS.

### Ukuran jendela yang diturunkan dari Layout

```qml
Window {
    visible: true
    width: layout.implicitWidth + 32
    height: layout.implicitHeight + 32
    minimumWidth: layout.Layout.minimumWidth + 32
    minimumHeight: layout.Layout.minimumHeight + 32

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 16
        // ... isi ...
    }
}
```

- `layout.implicitWidth` — ukuran implisit Layout adalah jumlah ukuran pilihan anak-anaknya; jendela dibuka tepat sebesar isinya (ditambah 32 untuk margin 2 × 16).
- `layout.Layout.minimumWidth` — idiom yang lazim dipakai untuk meminta ukuran minimum Layout sebagai batas jendela. Karena perilakunya bergantung pada versi Qt, **uji**: kecilkan jendela dan pastikan batasnya terasa; bila tidak bekerja, tulis `minimumWidth` secara eksplisit.

### Opsi lain untuk logika responsif

```qml
// Opsi 1 — binding pada columns (di atas): paling ringkas
columns: grid.width < 400 ? 1 : 2

// Opsi 2 — State: perubahan dinyatakan dalam satu blok bernama
states: State {
    name: 'sempit'
    when: root.width < 400
    PropertyChanges { target: grid; columns: 1 }
}

// Opsi 3 — Flow: tanpa titik patah; item membungkus sendiri
Flow { width: parent.width; spacing: 12; /* ... */ }
```

Opsi 2 lebih terbaca ketika banyak properti berubah serentak di satu titik patah. Opsi 3 paling sederhana, tetapi Anda tidak mengendalikan jumlah kolom secara pasti.

### Uji ketahanan (kebiasaan wajib)

```bash
# ukuran jendela: tarik sampai sangat sempit dan sangat lebar
qml6 Main.qml

# skala layar 150 persen
QT_SCALE_FACTOR=1.5 qml6 Main.qml

# platform tertentu
QT_QPA_PLATFORM=wayland qml6 Main.qml
QT_QPA_PLATFORM=xcb     qml6 Main.qml
```

Periksa: teks panjang membungkus atau terpotong rapi, tidak ada item saling menimpa, elemen penting tetap terjangkau pada ukuran minimum.

**Catatan untuk window manager tiling.** Di i3, sway, dwm, atau Hyprland, ukuran jendela ditentukan WM, dan sebagian WM hanya menghormati ukuran minimum pada mode floating. Anggap tata letak Anda akan menerima ukuran apa saja: rancang dengan negosiasi (`fillWidth`, `maximumWidth`), bukan dengan koordinat.

**Referensi bagian ini:** [Qt Quick Layouts Overview](https://doc.qt.io/qt-6/qtquicklayouts-overview.html) · [Window (minimumWidth)](https://doc.qt.io/qt-6/qml-qtquick-window.html) · [States](https://doc.qt.io/qt-6/qml-qtquick-state.html) · [High DPI](https://doc.qt.io/qt-6/highdpi.html) · [Qt (hsla)](https://doc.qt.io/qt-6/qml-qtqml-qt.html)

## 5.2.6 \[TAMBAHAN\] `StackLayout` dan pembagi ruang lain

*Alasan penambahan:* `StackLayout` adalah anggota keempat `QtQuick.Layouts` yang belum ada di daftar kurikulum, dan sering dibutuhkan bersama Layout lain untuk halaman bertab dan wizard.

### Dasar: apa itu `StackLayout`?

`StackLayout` menumpuk semua anaknya pada area yang sama dan hanya **satu** yang tampil, ditentukan `currentIndex` (mulai dari 0). Setiap anak diberi ukuran seluas Layout. Berbeda dengan Layout lain, ia tidak membagi ruang di antara anak, melainkan *menggilir* mana yang terlihat. Semua anak tetap dibuat sejak awal; yang tidak aktif hanya disembunyikan.

```
 StackLayout (currentIndex: 1)
 +-----------+-----------+-----------+
 |  anak 0   |  anak 1   |  anak 2   |   hanya anak 1 yang tampil;
 | (tersembunyi) | (TAMPIL) | (tersembunyi) |   ketiganya ada di memori
 +-----------+-----------+-----------+
```

### Contoh inti: tab dengan `TabBar` + `StackLayout`

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Window {
    visible: true; width: 360; height: 240

    ColumnLayout {
        anchors.fill: parent

        TabBar {
            id: bar
            Layout.fillWidth: true
            TabButton { text: 'Satu' }
            TabButton { text: 'Dua' }
        }

        StackLayout {
            currentIndex: bar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle { color: 'tomato' }
            Rectangle { color: 'seagreen' }
        }
    }
}
```

Bedah:

- `TabBar` + `TabButton` — pasangan kontrol tab dari Qt Quick Controls; `bar.currentIndex` adalah tab yang terpilih.
- `currentIndex: bar.currentIndex` — *binding*: memilih tab otomatis memilih anak `StackLayout` yang sesuai. Urutan `TabButton` dan urutan anak harus sama.
- `Layout.fillWidth` / `Layout.fillHeight` pada `StackLayout` — ia sendiri anak `ColumnLayout`, jadi ia memakai attached property seperti item lain.
- `Rectangle { color: 'tomato' }` tanpa ukuran — sah: `StackLayout` yang menetapkan ukurannya.

### Opsi lain untuk “menampilkan satu dari banyak”

- **`Loader`** — membuat anak hanya saat dibutuhkan (hemat memori untuk halaman berat): `Loader { active: stack.currentIndex === 2; sourceComponent: halamanBerat }`. Harganya: anak dibuat ulang bila dihidupkan lagi.
- **`StackView`** (Qt Quick Controls) — navigasi bergaya tumpukan dengan `push` dan `pop` serta transisi; cocok untuk alur maju-mundur, bukan tab.
- **`SwipeView`** (Qt Quick Controls) — satu halaman dengan geser ke samping.
- **`SplitView`** (Qt Quick Controls) — bukan menggilir, melainkan membagi ruang dengan pembatas yang bisa digeser pengguna:

```qml
import QtQuick.Controls.Basic

SplitView {
    anchors.fill: parent
    orientation: Qt.Horizontal
    Rectangle { SplitView.preferredWidth: 160; SplitView.minimumWidth: 80; color: 'tomato' }
    Rectangle { SplitView.fillWidth: true; color: 'seagreen' }
}
```

Perhatikan jebakan: anak `SplitView` memakai attached property **`SplitView.*`**, bukan `Layout.*`. Menulis `Layout.fillWidth` di sana tidak berefek.

**Referensi bagian ini:** [StackLayout](https://doc.qt.io/qt-6/qml-qtquick-layouts-stacklayout.html) · [TabBar](https://doc.qt.io/qt-6/qml-qtquick-controls-tabbar.html) · [SplitView](https://doc.qt.io/qt-6/qml-qtquick-controls-splitview.html) · [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html)

## 5.2.7 \[TAMBAHAN\] Fitur lanjut dan yang jarang dibahas

*Alasan penambahan:* permintaan Anda agar bagian yang jarang dibahas tetap dicakup. Semua yang berikut opsional untuk dasar, tetapi sering menyelamatkan Anda di proyek nyata.

### 1. Faktor regang (Qt 6.5 ke atas)

```qml
RowLayout {
    Rectangle { Layout.fillWidth: true; Layout.horizontalStretchFactor: 1; color: 'tomato' }
    Rectangle { Layout.fillWidth: true; Layout.horizontalStretchFactor: 2; color: 'seagreen' }
}
```

Bila dua item sama-sama boleh tumbuh, faktor regang menentukan pembagian ruang sisa secara proporsional (kira-kira 1 : 2 pada contoh). Ini cara paling deterministik untuk membuat rasio tetap. Ukur hasilnya dengan eksperimen di versi Qt Anda.

### 2. Sel seragam (Qt 6.6 ke atas)

```qml
RowLayout {
    uniformCellSizes: true       // semua sel disamakan ukurannya
    Button { text: 'Ya' }
    Button { text: 'Mungkin nanti' }
}
```

Berguna untuk baris tombol yang harus tampak sama lebar. `GridLayout` memiliki `uniformCellWidths` dan `uniformCellHeights` untuk hal serupa. Sebelum Qt 6.6 Anda menyamakannya dengan `Layout.preferredWidth` yang sama.

### 3. Arah tata letak dan mirroring (bahasa kanan-ke-kiri)

```qml
Item {
    LayoutMirroring.enabled: true
    LayoutMirroring.childrenInherit: true

    RowLayout {
        // urutan visual terbalik: anak pertama berada di kanan
    }
}
```

`LayoutMirroring` adalah attached property yang membalik tata letak horizontal untuk bahasa seperti Arab dan Ibrani. Pada positioner dan Layout ada juga `layoutDirection`, dan `effectiveLayoutDirection` pada positioner untuk membaca arah yang sedang berlaku. Anda baru perlu memikirkan ini bila aplikasi menargetkan bahasa kanan-ke-kiri, tetapi merancangnya sejak awal jauh lebih murah.

### 4. Atribut `Positioner.*` untuk anak positioner

```qml
Row {
    spacing: 8
    Repeater {
        model: ['A', 'B', 'C']
        Text {
            required property string modelData
            text: modelData + (Positioner.isLastItem ? '' : ' |')
        }
    }
}
```

`Positioner.index`, `Positioner.isFirstItem`, dan `Positioner.isLastItem` adalah attached property *hanya-baca* untuk anak positioner. Contoh di atas menggambar pemisah “|” di antara item tetapi tidak setelah yang terakhir. `modelData` adalah nilai elemen array pada model sederhana.

### 5. Urutan Tab mengikuti urutan deklarasi

Rantai fokus keyboard (Tab) umumnya mengikuti urutan anak dalam pohon, bukan posisi visual. Bila Anda memakai `Layout.row` / `Layout.column` sehingga urutan visual berbeda dari urutan penulisan, pengguna keyboard akan loncat-loncat. Tulis anak berurutan sesuai urutan fokus yang Anda inginkan (lihat 5.1.6).

### 6. Animasi dan beban penataan ulang

Menganimasikan properti Layout (`Layout.preferredWidth`, `spacing`, dll.) memicu penataan ulang setiap frame. Untuk gerak murni, animasikan `x`, `y`, `opacity`, atau `scale` item di dalam sel, dan gunakan transisi `add` / `move` pada positioner bila memungkinkan.

### 7. Teknik debug tata letak

```qml
// sementara: beri garis tepi pada anak yang dicurigai
Rectangle { color: 'transparent'; border.color: 'red'; border.width: 1 /* ... */ }

// atau cetak ukuran yang dinegosiasikan
Component.onCompleted: console.log('w:', width, 'implicit:', implicitWidth,
                                   'pref:', Layout.preferredWidth)
```

Bila isi lebih besar daripada jendela, jangan memaksanya muat: pertimbangkan `ScrollView` atau `Flickable` (dibahas di materi terpisah).

**Referensi bagian ini:** [Layout (stretch factor)](https://doc.qt.io/qt-6/qml-qtquick-layouts-layout.html) · [RowLayout (uniformCellSizes)](https://doc.qt.io/qt-6/qml-qtquick-layouts-rowlayout.html) · [LayoutMirroring](https://doc.qt.io/qt-6/qml-qtquick-layoutmirroring.html) · [Right-to-left User Interfaces](https://doc.qt.io/qt-6/qtquick-positioning-righttoleft.html) · [Positioner (attached)](https://doc.qt.io/qt-6/qml-qtquick-positioner.html)

## Terminologi Esensial

- **Positioner** — item (`Row`, `Column`, `Grid`, `Flow`) yang hanya menaruh anak-anaknya; tidak mengubah ukuran mereka.
- **Layout** — item (`RowLayout`, `ColumnLayout`, `GridLayout`, `StackLayout`) yang menaruh dan menetapkan ukuran anak lewat negosiasi.
- **Negosiasi ukuran** — proses di mana anak melapor minimum, pilihan, maksimum, dan Layout membagi ruang.
- **Ukuran pilihan (preferred)** — ukuran yang diinginkan anak; bawaannya ukuran implisit (5.1.3).
- **`Layout.fillWidth` / `fillHeight`** — izin tumbuh mengisi ruang sisa pada sumbu itu.
- **Attached property** — atribut yang ditempelkan tipe lain (`Layout.*`) ke anak; hanya berlaku bila induk langsungnya tipe yang menempelkan.
- **Spacing** — jarak antar-anak dalam positioner atau Layout; **margin** — ruang di luar satu item; **padding** — ruang di dalam tepi wadah.
- **Cell (sel)** — petak yang ditempati satu anak dalam Grid atau GridLayout.
- **Span** — merentang beberapa sel (`columnSpan`, `rowSpan`).
- **Alignment** — perataan item di dalam selnya.
- **Spacer (pengganjal)** — item kosong ber-`fillWidth` atau `fillHeight` yang menyerap ruang sisa.
- **Breakpoint (titik patah)** — ambang ukuran tempat tata letak berganti bentuk (misalnya 1 kolom menjadi 2).
- **Responsif** — tetap benar saat ukuran, skala, atau konten berubah.
- **Flow** — positioner yang membungkus item ke baris atau kolom berikutnya saat ruang habis.
- **Mirroring** — pembalikan tata letak horizontal untuk bahasa kanan-ke-kiri.
- **Stretch factor** — bobot pembagian ruang sisa di antara item yang boleh tumbuh.
- **Recursive rearrange** — peringatan Layout ketika ukuran anak bergantung pada ukuran yang Layout sendiri tetapkan.
- **`Repeater`** — pembuat salinan delegate sesuai model; hasilnya menjadi anak dari induk `Repeater`.
- **High DPI / skala layar** — penskalaan piksel logis oleh Qt pada layar berkepadatan tinggi (`QT_SCALE_FACTOR` untuk menguji).

## Hubungan dengan Modul Lain

- **Prasyarat:** Modul 5.1 (ukuran implisit, `Layout.*` ditulis pemakai, tanpa `parent` di root komponen), Modul 4.1 dan 4.2 (item dan anchors), dan binding dari Fase 3.
- **Menuju Modul 5.3 (Tema dan Singleton):** angka seperti `spacing: 8`, `margins: 12`, titik patah `400` / `720`, dan `radius: 8` di modul ini menjadi token (`Theme.spacing`, `Theme.breakpointSempit`, dst.).
- **Ke fase berikutnya:** `StackLayout` / `Loader` untuk navigasi halaman; transisi positioner sebagai pintu masuk ke animasi; `ScrollView` / `Flickable` untuk konten yang melebihi ukuran jendela; `Repeater` dan model data untuk daftar dinamis.

## Kesalahan Umum dan Solusi

1. **Kotak tidak tampak di dalam Layout.** *Sebab:* tanpa ukuran pilihan atau implisit. *Solusi:* isi `Layout.preferredWidth` / `preferredHeight`, atau beri komponen ukuran implisit (5.1.3).
2. **`Layout.fillWidth: true` tidak berpengaruh.** *Sebab:* induk langsungnya `Row` / `Column` (positioner), bukan Layout. *Solusi:* ganti menjadi `RowLayout` / `ColumnLayout`.
3. **Peringatan “Detected anchors on an item that is managed by a layout”.** *Sebab:* `anchors` pada anak Layout. *Solusi:* hapus; pakai `Layout.alignment` dan `Layout.margins`.
4. **Ukuran yang ditulis di `width` / `height` diabaikan di Layout.** *Sebab:* Layout menimpanya. *Solusi:* `Layout.preferred*`, `minimum*`, `maximum*`.
5. **`Flow` tidak pernah membungkus.** *Sebab:* tidak ada lebar terbatas. *Solusi:* beri `width` (atau `Layout.fillWidth: true` bila di dalam Layout).
6. **Peringatan “Detected recursive rearrange. Aborting after two iterations.”** *Sebab:* ukuran implisit anak bergantung pada lebar yang Layout tetapkan (misalnya `implicitHeight` terikat ke `width`). *Solusi:* putus lingkarannya: beri `Layout.preferredHeight` pasti, atau jangan ikat `implicit*` ke ukuran aktual (5.1.3).
7. **Teks tidak membungkus dalam Layout.** *Sebab:* tanpa `wrapMode` atau tanpa lebar terbatas. *Solusi:* `wrapMode: Text.WordWrap` dan `Layout.fillWidth: true`.
8. **Galat “RowLayout is not a type”.** *Sebab:* lupa `import QtQuick.Layouts`. *Solusi:* tambahkan impor.
9. **Layout bersarang terlalu dalam.** *Sebab:* menyusun setiap baris sebagai Layout sendiri. *Akibat:* sulit dibaca dan mahal. *Solusi:* ratakan dengan `GridLayout` dan `columnSpan`.
10. **Anak `SplitView` memakai `Layout.*`.** *Sebab:* menyangka sama. *Solusi:* pakai `SplitView.*`.
11. **Jarak ganda.** *Sebab:* `spacing` Layout ditambah `Layout.margins` di anak. *Solusi:* pilih satu mekanisme jarak per hubungan.
12. **Tab melompat-lompat.** *Sebab:* urutan visual berbeda dari urutan deklarasi. *Solusi:* tulis anak sesuai urutan fokus (5.2.7 butir 5).

## Tips dan Praktik Terbaik

- **Mulai dari ukuran implisit yang benar** pada komponen (5.1.3); sisanya hampir gratis.
- **Pilih `Layout.preferredWidth` ketimbang `width`.** Yang pertama adalah usulan; yang kedua ditimpa.
- **Batasi sarang sekitar tiga tingkat.** Lebih dari itu, pertimbangkan `GridLayout` dan rentang.
- **Pakai spacer, bukan koordinat:** `Item { Layout.fillWidth: true }` mendorong item di sebelahnya ke tepi.
- **Tentukan minimum untuk elemen yang tak boleh hilang** (`Layout.minimumWidth`), dan minimum untuk jendela.
- **Satu sumber spasi.** Kumpulkan `spacing` dan `margins` ke satu tempat (token tema di 5.3).
- **Uji ekstrem sebagai kebiasaan:** jendela sangat sempit, sangat lebar, `QT_SCALE_FACTOR=1.5`, label sangat panjang, bahasa kanan-ke-kiri.
- **Awasi log terminal.** Peringatan Layout (anchors, recursive rearrange) hampir selalu menunjuk bug nyata.
- **Jalankan `qmllint`** untuk menangkap `Layout.*` yang salah tempat.
- **Jangan menyembunyikan informasi kritis dengan tata letak.** Pada ukuran minimum, konfirmasi dan peringatan harus tetap terlihat dan terjangkau keyboard.

## Latihan 15 Menit (versi diperbaiki)

*Perbaikan dari audit:* kurikulum hanya berbunyi “form dua kolom yang melebar mengikuti jendela” tanpa isi. Di sini isinya ditentukan dan ditambah satu syarat responsif.

1. Mulai dari form di 5.2.3 (nama, email, tombol Simpan).
2. Tambahkan baris **Telepon** dan **Kota**.
3. Pastikan kolom kedua melebar mengikuti jendela dan label sejajar rapi.
4. Buat form **satu kolom** (label di atas isian) saat lebar jendela di bawah 340 piksel, dan dua kolom di atasnya.
5. Pastikan tombol Simpan tetap di kanan bawah pada kedua bentuk.
6. Uji: jendela sangat sempit, `QT_SCALE_FACTOR=1.5`, lalu jalankan `qmllint6`.

**Kunci jawaban** (coba dulu sebelum membaca):

```qml
GridLayout {
    id: form
    anchors.fill: parent
    anchors.margins: 16
    columns: form.width < 340 ? 1 : 2
    columnSpacing: 12
    rowSpacing: 8

    Label { text: 'Nama' }
    TextField { Layout.fillWidth: true; placeholderText: 'Nama lengkap' }

    Label { text: 'Email' }
    TextField { Layout.fillWidth: true; placeholderText: 'nama@contoh.id' }

    Label { text: 'Telepon' }
    TextField { Layout.fillWidth: true }

    Label { text: 'Kota' }
    TextField { Layout.fillWidth: true }

    Button {
        text: 'Simpan'
        Layout.columnSpan: form.columns
        Layout.alignment: Qt.AlignRight
    }
}
```

Kuncinya ada pada dua baris: `columns` yang terikat ke lebar layout (titik patah), dan `Layout.columnSpan: form.columns` agar tombol selalu merentang seluruh kolom yang ada, berapa pun jumlahnya. Dengan satu kolom, label otomatis berada di atas isian karena urutan sel tetap sama.

**Tantangan opsional:** tulis ulang kolom label dengan pendekatan `ColumnLayout` + `RowLayout` (Opsi 2 di 5.2.3) dan bandingkan perilaku saat label ditambah yang lebih panjang.

## Cek Pemahaman dan Kunci

1. **Apa beda utama `Row` dan `RowLayout`?** *Kunci:* `Row` hanya menaruh anak berdasarkan ukuran yang sudah ada dan tidak mengubahnya; `RowLayout` menegosiasikan dan menetapkan ukuran anak (minimum, pilihan, maksimum) serta bereaksi terhadap ukuran wadah.
2. **Mengapa `Layout.fillWidth: true` pada anak `Row` tidak berefek?** *Kunci:* attached property `Layout` hanya bermakna bila induk langsung adalah sebuah Layout; `Row` tidak membacanya, dan tidak ada galat yang memberi tahu.
3. **Mengapa `anchors` pada anak Layout dilarang?** *Kunci:* Layout yang menulis posisi dan ukuran anak; `anchors` melakukan hal yang sama sehingga dua mekanisme berebut menjadi perilaku tak terdefinisi. Pakai `Layout.alignment` dan `Layout.margins`.
4. **Kapan memilih `Flow`, dan kapan `GridLayout` dengan `columns` terikat?** *Kunci:* `Flow` bila item berukuran tetap dan Anda cukup dengan pembungkusan otomatis tanpa kendali jumlah kolom; `GridLayout` dengan `columns` terikat bila Anda butuh jumlah kolom pasti per titik patah dan item yang mengisi lebar sel.
5. **Bagaimana membuat konten maksimal 600 piksel dan terpusat?** *Kunci:* di dalam Layout, beri anak `Layout.fillWidth: true`, `Layout.maximumWidth: 600`, dan `Layout.alignment: Qt.AlignHCenter`.

## Referensi Tambahan

- [Qt Quick Layouts Overview](https://doc.qt.io/qt-6/qtquicklayouts-overview.html)
- [Item Positioners](https://doc.qt.io/qt-6/qtquick-positioning-topic.html)
- [Right-to-left User Interfaces](https://doc.qt.io/qt-6/qtquick-positioning-righttoleft.html)
- [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) (urutan Tab)
- [High DPI Displays](https://doc.qt.io/qt-6/highdpi.html)
- [Qt — Arch Wiki](https://wiki.archlinux.org/title/Qt) (variabel lingkungan dan style)

---

*Tata letak yang baik tak terlihat: ia hanya terasa benar di ukuran apa pun.*

# Fase 5 · Modul 5.3 — Tema dan Singleton

*Kurikulum Qt 6 QML · Fase 5 (Komponen, Layout, dan Styling) · Modul 3 dari 3 (5.1 → 5.2 → 5.3)*

## Daftar Isi Modul 5.3

- Audit singkat Modul 5.3 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 5.3.1 `pragma Singleton`
- 5.3.2 Mendaftarkan singleton di CMake
- 5.3.3 Design token (warna, spasi, radius, tipografi)
- 5.3.4 Tema gelap/terang
- 5.3.5 Singleton dari C++ (`QML_SINGLETON`, rujukan maju ke Modul 10.3)
- 5.3.6 \[TAMBAHAN\] Alternatif mekanisme tema dan kapan memilihnya
- 5.3.7 \[TAMBAHAN\] Penegakan, migrasi, dan kontras warna
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Rangkuman Fase 5
- Referensi tambahan

## Audit Singkat Modul 5.3 (sebelum materi dimulai)

Urutan Modul 5.3 logis: ia memusatkan angka dan warna yang tersebar di 5.1 dan 5.2. Temuan yang dibereskan:

1. **\[Klarifikasi\] Dua syarat, bukan satu.** Kurikulum sudah benar menyebut `pragma Singleton` *dan* `QT_QML_SINGLETON_TYPE`, tetapi tidak menjelaskan *mengapa* keduanya perlu: yang pertama ditulis di berkas QML, yang kedua mengatur isi `qmldir` (daftar tipe modul). Dijelaskan di 5.3.2 beserta cara memverifikasinya.
2. **\[Tambahan\] Jalur tanpa CMake.** Cara cepat `qml6 Main.qml` yang dipakai di 5.1 dan 5.2 tidak mengenali singleton tanpa berkas `qmldir` tulisan tangan. Ditambahkan di 5.3.2.
3. **\[Tambahan\] 5.3.3 diperdalam.** Token dibagi menurut tingkat (primitif, semantik, komponen), skala spasi, tipografi, durasi gerak, dan titik patah dari 5.2.5, plus aturan penamaan semantik.
4. **\[Peringatan versi dan platform\] 5.3.4.** `Qt.styleHints.colorScheme` butuh Qt 6.5 ke atas, dan di Linux tanpa desktop environment (misalnya window manager tiling) nilainya bisa `Qt.Unknown`. Ditambahkan *override* manual, cara memeriksa apa yang dilaporkan Qt, dan nilai bawaan yang aman.
5. **\[Klarifikasi\] “Jangan menaruh keadaan aplikasi di singleton tema”.** Aturan ini benar tetapi kabur. Dipertegas dengan batas yang jelas: *keadaan gaya* (mode gelap) boleh, *data bisnis dan rahasia* tidak.
6. **\[Tambahan\] 5.3.6.** Alternatif yang tidak ada di kurikulum: `SystemPalette`, tema yang disuntikkan lewat properti (untuk menimpa satu bagian UI), `palette` dan style Qt Quick Controls, serta berkas JavaScript `.pragma library`.
7. **\[Tambahan\] 5.3.7.** Penegakan agar tak ada warna atau angka mentah tersisa (`grep`, `qmllint`), dan pemeriksaan kontras warna.
8. **\[Klarifikasi\] 5.3.5 adalah rujukan maju.** Singleton dari C++ dibahas penuh di Modul 10.3; di sini hanya pengenalan konsep dan potongan kode, jangan dipraktikkan sebelum jalur C++ dimulai.
9. **\[Catatan\] `VERSION 1.0`** pada `qt_add_qml_module` bersifat opsional di Qt 6; dipertahankan sesuai kurikulum.

**Daftar Modul 5.3 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

- 5.3.1 `pragma Singleton`
- 5.3.2 Mendaftarkan singleton di CMake
- 5.3.3 Design token (warna, spasi, radius, tipografi)
- 5.3.4 Tema gelap/terang
- 5.3.5 Singleton dari C++ (rujukan maju ke Modul 10.3)
- &#91;+\] 5.3.6 Alternatif mekanisme tema dan kapan memilihnya
- &#91;+\] 5.3.7 Penegakan, migrasi, dan kontras warna

**Asumsi prasyarat.** Modul 5.1 (`AppButton`, id, API komponen), Modul 5.2 (spasi, margin, titik patah), dan properti serta binding dari Fase 3. Proyek CMake `hello` dari fase sebelumnya sudah bisa dibangun.

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini memusatkan nilai gaya (warna, jarak, radius, ukuran huruf, durasi gerak) ke **satu tempat**: sebuah singleton QML bernama `Theme`, yang dibaca oleh seluruh komponen. Anda belajar membuatnya (`pragma Singleton`), mendaftarkannya agar dikenal (CMake dan `qmldir`), menyusun *design token*, dan menurunkan tema gelap/terang dari satu saklar.

### Peran dalam kurikulum

Di 5.1 `AppButton` memuat angka dan warna mentah (`32`, `6`, `#2563eb`); di 5.2 Anda menulis `spacing: 8`, `margins: 12`, dan titik patah `400` / `720` di banyak tempat. Modul ini menutup Fase 5: satu perubahan di `Theme.qml` mengubah seluruh aplikasi, sehingga komponen (5.1), tata letak (5.2), dan gaya (5.3) bekerja sebagai satu sistem.

### Konsep kunci dan filosofi

- **Analogi buku panduan gaya (dan termostat pusat).** Bayangkan gedung dengan termostat di tiap kamar: mengubah suhu berarti mendatangi seratus kamar. Dengan satu termostat pusat, Anda memutar satu tombol. `Theme` adalah termostat pusat untuk tampilan.
- **Sumber kebenaran tunggal (single source of truth).** Tiap nilai gaya punya tepat satu tempat tinggal. Tidak ada angka yang “kebetulan sama” di dua berkas, sehingga tidak ada yang lupa diubah.
- **Design token: nama bermakna menggantikan angka mentah.** `Theme.primary` menyatakan *peran* (warna aksi utama), sedangkan `#2563eb` hanya menyatakan *nilai*. Ketika desain berubah, peran tetap dan nilai berganti.
- **Konsistensi sebagai fitur keamanan.** Antarmuka yang seragam membuat anomali mudah dikenali: dialog konfirmasi asli selalu tampil dengan gaya yang sama, sehingga tampilan yang “menyimpang” menonjol. Konsistensi juga mengurangi kemungkinan elemen penting (peringatan, tombol hapus) tampil mirip elemen biasa.
- **Jujur soal harga singleton.** Singleton adalah *keadaan global*. Kenyamanannya besar (tidak perlu meneruskan `theme` lewat setiap komponen), tetapi ia menambah kopling tersembunyi dan menyulitkan pengujian atau penimpaan sebagian. Karena itu isinya dibatasi pada hal yang memang global dan hanya-baca: *gaya*. Jangan pernah menaruh rahasia, token autentikasi, atau data pengguna di sana (prinsip hak akses minimum untuk keadaan global).

Alur dari satu tempat ke seluruh aplikasi:

```
 Theme.qml  (singleton, SATU instans per engine)
   |-- mode / dark ---------> warna semantik (primary, surface, ...)
   |-- spasi, radius, font, durasi, titik patah
   |
   +--> AppButton   : color: Theme.primary,  implicitHeight: Theme.controlHeight
   +--> Main.qml    : spacing: Theme.space2,  margins: Theme.space4
   +--> komponen lain...

  ubah SATU token  -->  semua binding yang membacanya dihitung ulang (reaktif)
```

## 5.3.1 `pragma Singleton`

### Dasar: apa itu singleton, dan apa itu `pragma`?

*Singleton* adalah pola desain: sebuah tipe yang hanya punya **satu instans** untuk seluruh program. Di QML, instans itu satu per `QQmlEngine`, dibuat *malas* (lazy) ketika pertama kali dirujuk, dan hidup selama engine hidup. Semua pemakai membaca objek yang sama, sehingga perubahan di satu tempat terlihat di mana-mana.

`pragma` adalah *direktif untuk engine*, bukan kode yang berjalan. Ia memberi tahu bagaimana sebuah dokumen QML harus diperlakukan. `pragma Singleton` berarti “dokumen ini adalah singleton”; ia ditulis di bagian atas berkas, sebelum `import`. (Ada pragma lain seperti `pragma ComponentBehavior: Bound`, yang sudah Anda temui di 5.1.7.)

### Sintaks dan contoh inti: `Theme.qml`

```qml
pragma Singleton
import QtQuick

QtObject {
    readonly property color primary: '#2563eb'
    readonly property int spacing: 8
    readonly property int radius: 6
}
```

Pemakaian di komponen mana pun dalam modul yang sama:

```qml
Rectangle {
    color: Theme.primary
    radius: Theme.radius
}
```

### Bedah kode (kata demi kata)

- `pragma Singleton` — menandai dokumen sebagai singleton. Tanpa baris ini `Theme` akan diperlakukan sebagai tipe biasa yang harus diinstansiasi (`Theme { }`), dan sebaliknya, dengan baris ini ia **tidak bisa** lagi dibuat dengan `Theme { }`.
- `import QtQuick` — memuat modul yang berisi `QtObject` dan tipe warna.
- `QtObject { ... }` — tipe dasar singleton ini. `QtObject` adalah objek paling dasar *tanpa tampilan*: tidak punya `x`, `y`, `width`, atau `parent`. Itu pas untuk tema, karena tema tidak ikut dalam pohon tampilan. (Singleton boleh berbasis `Item`, tetapi hampir tidak pernah diperlukan untuk tema dan menambah beban tanpa manfaat.)
- `readonly property color primary: '#2563eb'` — properti `primary` bertipe `color`, **hanya-baca** bagi pihak luar, bernilai biru. `readonly` melarang `Theme.primary = 'red'` dari luar; objek itu sendiri tetap bebas mengubahnya lewat binding internal (itu yang dipakai tema gelap/terang di 5.3.4).
- `readonly property int spacing: 8` dan `radius: 6` — token ukuran dalam piksel logis.
- `color: Theme.primary` — *binding* ke singleton: bila `Theme.primary` berubah, `color` ikut dihitung ulang.

### Sifat dan siklus hidup

```
 pertama kali ada yang menulis 'Theme.xxx'
        |
        v
 engine membuat SATU objek Theme  ---->  disimpan selama engine hidup
        |
        v
 pemakai lain membaca objek yang SAMA  (tidak ada salinan)
```

- **Satu per engine.** Dua `QQmlEngine` berbeda memiliki dua `Theme` terpisah.
- **Lazy.** Dibuat saat pertama dirujuk; biaya awalnya kecil.
- **Tidak ada `parent`, anchors, atau `id` pemakai.** Ia bukan item, hanya objek.
- **Reaktif.** Binding yang membaca `Theme.x` ikut berubah saat `x` berubah.

### Opsi lain untuk “nilai global bersama”

```qml
// Opsi 1 — QtObject singleton (kurikulum): reaktif, ringan, tipe-aman
pragma Singleton
QtObject { readonly property color primary: '#2563eb' }

// Opsi 2 — singleton berbasis Item: hanya bila perlu anak visual (jarang)
pragma Singleton
Item { readonly property color primary: '#2563eb' }

// Opsi 3 — berkas JavaScript .pragma library: konstanta statis, TIDAK reaktif
.pragma library
var primary = '#2563eb'
```

Opsi 3 mudah tetapi tidak memberi tahu pemakai ketika nilainya berubah, jadi tidak bisa dipakai untuk tema gelap/terang yang berganti saat program berjalan. Alternatif lain (tema yang disuntikkan, `SystemPalette`, style Controls) dibahas di 5.3.6.

### Hal yang perlu diperhatikan

- **Simpan hanya gaya.** Token adalah nilai tampilan yang tidak berubah akibat logika bisnis.
- **Nama bermakna, bukan nilai.** `primary`, bukan `blue`.
- **Hindari properti yang berubah sering.** Singleton bukan tempat menyimpan keadaan berfrekuensi tinggi.

**Referensi bagian ini:** [Structure of a QML Document (pragma)](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [Defining Object Types through QML Documents](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html) · [QtObject](https://doc.qt.io/qt-6/qml-qtqml-qtobject.html) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)

## 5.3.2 Mendaftarkan singleton di CMake

### Dasar: bagaimana QML menemukan tipe? (`qmldir`)

Sebuah modul QML dideskripsikan oleh berkas teks bernama `qmldir`: daftar “nama tipe → berkas”. Engine membacanya untuk tahu tipe apa saja yang ada. Untuk singleton, baris `qmldir`-nya memakai kata kunci `singleton`:

```
module Hello
singleton Theme 1.0 Theme.qml
AppButton 1.0 AppButton.qml
```

Kata kunci itu penting karena engine perlu tahu **sebelum** menjalankan kode apakah sebuah tipe harus dibuat sekali (singleton) atau tiap kali dipakai (tipe biasa). `pragma Singleton` di dalam berkas saja tidak cukup untuk menyampaikannya ke modul; baris `singleton` di `qmldir` yang melakukannya.

Dengan CMake Anda tidak menulis `qmldir` sendiri: `qt_add_qml_module` membuatnya. Tugas Anda hanya memberi tahu CMake bahwa `Theme.qml` adalah singleton, lewat properti berkas `QT_QML_SINGLETON_TYPE`.

### Sintaks dan contoh inti

```cmake
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES Main.qml AppButton.qml Theme.qml
)
```

### Bedah kode (kata demi kata)

- `set_source_files_properties(...)` — perintah bawaan CMake untuk menempelkan properti pada sebuah berkas sumber.
- `Theme.qml` — berkas yang dituju; path relatif terhadap `CMakeLists.txt` yang sama.
- `PROPERTIES` — kata kunci pemisah antara nama berkas dan pasangan properti.
- `QT_QML_SINGLETON_TYPE TRUE` — properti khusus Qt: “berkas ini singleton”. Ketika `qt_add_qml_module` membuat `qmldir`, ia menulis baris `singleton Theme ...` untuk berkas ini.
- `qt_add_qml_module(hello ...)` — membuat modul QML untuk target `hello` (yang sudah Anda buat dengan `qt_add_executable`).
- `URI Hello` — nama modul untuk `import`; juga menentukan lokasi `Hello/qmldir`.
- `VERSION 1.0` — versi modul; di Qt 6 opsional dan boleh dihilangkan.
- `QML_FILES Main.qml AppButton.qml Theme.qml` — seluruh berkas QML modul. Singleton **harus** ikut didaftarkan di sini juga.

**Urutan wajib:** properti berkas harus ditetapkan **sebelum** `qt_add_qml_module` (atau `qt_target_qml_sources`), karena nilainya dibaca saat perintah itu dijalankan. Menaruhnya sesudahnya tidak berefek, dan kegagalannya diam-diam.

Kerangka `CMakeLists.txt` secara utuh (sesuaikan dengan proyek `hello` Anda):

```cmake
cmake_minimum_required(VERSION 3.21)
project(hello LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(hello main.cpp)

set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES Main.qml AppButton.qml Theme.qml
)

target_link_libraries(hello PRIVATE Qt6::Quick)
```

### Memverifikasi pendaftaran

```bash
cmake -S . -B build -G Ninja && cmake --build build
cat build/Hello/qmldir          # lokasi umum; cari baris yang diawali: singleton Theme
./build/hello                   # jalankan; Theme.primary harus terbaca di UI
```

Bila baris `singleton Theme` tidak ada di `qmldir`, properti berkas Anda tidak terbaca (biasanya karena urutan, atau salah nama berkas).

### Alur diagnosis galat

```
 'ReferenceError: Theme is not defined'
  |
  +-- ada baris 'singleton Theme' di qmldir?    TIDAK --> set_source_files_properties salah urutan / salah path
  |
  +-- Theme.qml ada di QML_FILES?               TIDAK --> tambahkan ke qt_add_qml_module
  |
  +-- ada 'pragma Singleton' di Theme.qml?      TIDAK --> tambahkan sebagai baris pertama
  |
  '-- pemakai berada dalam modul yang sama atau mengimpor modul (import Hello)?  TIDAK --> impor modulnya
```

### Opsi lain untuk mendaftarkan

```cmake
# Opsi 1 — properti berkas sebelum qt_add_qml_module (kurikulum)
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
qt_add_qml_module(hello URI Hello QML_FILES Main.qml Theme.qml)

# Opsi 2 — menambah berkas belakangan lewat qt_target_qml_sources (properti tetap harus lebih dulu)
set_source_files_properties(Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
qt_target_qml_sources(hello QML_FILES Theme.qml)
```

Dan bila Anda memakai jalur cepat **tanpa CMake** (`qml6 Main.qml`), tulis `qmldir` sendiri di folder yang sama:

```
singleton Theme 1.0 Theme.qml
AppButton 1.0 AppButton.qml
```

Daftarkan semua tipe lokal yang dipakai bila Anda menulis `qmldir` sendiri; bila ada yang terlewat, `qml6` akan mengeluh bahwa tipe itu tak dikenal. Buktikan di mesin Anda.

**Referensi bagian ini:** [qt\_target\_qml\_sources (QT\_QML\_SINGLETON\_TYPE)](https://doc.qt.io/qt-6/qt-target-qml-sources.html) · [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [Module Definition qmldir Files](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html) · [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [set\_source\_files\_properties (CMake)](https://cmake.org/cmake/help/latest/command/set_source_files_properties.html)

## 5.3.3 Design token (warna, spasi, radius, tipografi)

### Dasar: apa itu design token?

*Design token* adalah nilai desain yang **diberi nama bermakna**: warna, jarak, radius, ukuran huruf, durasi animasi. Konsep ini lahir dari sistem desain (Material Design, Tailwind, dan sejenisnya) agar desainer dan pengembang berbicara memakai nama yang sama. Di QML, token adalah `readonly property` di dalam `Theme`.

Token dapat dipikirkan dalam tiga tingkat:

```
 Tingkat 1: token PRIMITIF   nilai mentah, tanpa makna       blue500 = #2563eb   8   14
       |  dirujuk oleh
       v
 Tingkat 2: token SEMANTIK   makna / peran                   primary   surface   space2
       |  dipakai oleh komponen  <-- inilah antarmuka Theme
       v
 Tingkat 3: token KOMPONEN   (opsional) khusus satu komponen buttonBackground
```

Untuk aplikasi seukuran latihan ini, tingkat 2 sudah cukup; tingkat 1 baru bermanfaat bila palet Anda besar (biru 100–900, abu 100–900, dst.), dan tingkat 3 sebaiknya ditunda sampai benar-benar dibutuhkan.

### Contoh inti: `Theme.qml` lengkap (versi terang)

```qml
pragma Singleton
import QtQuick

QtObject {
    // ===== warna semantik =====
    readonly property color primary:     '#2563eb'
    readonly property color primaryDown: '#1d4ed8'
    readonly property color onPrimary:   '#ffffff'
    readonly property color surface:     '#ffffff'
    readonly property color onSurface:   '#0f172a'
    readonly property color outline:     '#cbd5e1'
    readonly property color focusRing:   onPrimary
    readonly property color disabled:    '#9ca3af'

    // ===== spasi: kelipatan 4 px =====
    readonly property int space1: 4
    readonly property int space2: 8
    readonly property int space3: 12
    readonly property int space4: 16
    readonly property int space5: 20
    readonly property int space6: 24

    // ===== bentuk dan ukuran =====
    readonly property int radius: 6
    readonly property int controlHeight: 40

    // ===== tipografi (piksel logis) =====
    readonly property int fontSmall: 12
    readonly property int fontBody: 14
    readonly property int fontTitle: 20

    // ===== gerak (milidetik) =====
    readonly property int durationFast: 120
    readonly property int durationNormal: 240

    // ===== titik patah (lihat 5.2.5) =====
    readonly property int bpCompact: 400
    readonly property int bpMedium: 720
}
```

### Bedah kode (kata demi kata)

- `// ===== warna semantik =====` — komentar pengelompokan; QML memakai `//` untuk komentar satu baris.
- `readonly property color primary: '#2563eb'` — `primary` adalah *peran* (warna aksi utama), bukan sekadar “biru”. Tipe `color` memastikan nilai valid.
- `primaryDown` — varian keadaan *ditekan*; akhiran menunjukkan keadaan, bukan nilai.
- `onPrimary` — warna isi (teks, ikon) *di atas* `primary`. Pola `onX` (dipinjam dari Material) menjamin pasangan latar-isi selalu dirancang bersama sehingga kontrasnya terjaga.
- `surface` / `onSurface` — latar umum dan isi di atasnya.
- `outline` — garis tepi netral.
- `focusRing: onPrimary` — token ini *merujuk token lain*: cincin fokus memakai warna yang kontras dengan isi tombol. Perhatikan bahwa token boleh dibentuk dari token lain (alasan pemeriksaan kontras ada di 5.3.7).
- `disabled` — warna item nonaktif.
- `space1` .. `space6` — skala spasi kelipatan 4 piksel (`spaceN = N × 4`). Menyederhanakan keputusan: Anda memilih *langkah*, bukan angka bebas.
- `radius: 6`, `controlHeight: 40` — bentuk dan tinggi kontrol standar.
- `fontSmall` / `fontBody` / `fontTitle` — skala tipografi dalam piksel logis (Qt menskalakannya pada layar berkepadatan tinggi). Dipakai sebagai `font.pixelSize: Theme.fontBody`.
- `durationFast` / `durationNormal` — durasi animasi dalam milidetik; dipakai oleh `ColorAnimation` dan kawan-kawan.
- `bpCompact` / `bpMedium` — titik patah dari 5.2.5: `columns: grid.width < Theme.bpCompact ? 1 : 2`.

### Menerapkan token pada `AppButton` (versi akhir Fase 5)

```qml
import QtQuick

Rectangle {
    id: root

    // API publik
    required property string label
    signal clicked()

    // keyboard dan aksesibilitas (5.1.6)
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: root.label
    Accessible.onPressAction: root.clicked()
    Keys.onReturnPressed: root.clicked()
    Keys.onEnterPressed: root.clicked()
    Keys.onSpacePressed: root.clicked()

    // tampilan: seluruhnya dari token
    implicitWidth: teks.implicitWidth + 2 * Theme.space4
    implicitHeight: Theme.controlHeight
    radius: Theme.radius
    color: !root.enabled ? Theme.disabled : (tap.pressed ? Theme.primaryDown : Theme.primary)
    border.width: root.activeFocus ? 2 : 0
    border.color: Theme.focusRing

    Behavior on color { ColorAnimation { duration: Theme.durationFast } }

    Text {
        id: teks
        anchors.centerIn: parent
        text: root.label
        color: Theme.onPrimary
        font.pixelSize: Theme.fontBody
    }

    TapHandler {
        id: tap
        onTapped: {
            root.forceActiveFocus(Qt.MouseFocusReason)
            root.clicked()
        }
    }
}
```

Peta penggantian (sebelum → sesudah):

- `32` (padding kiri-kanan total) → `2 * Theme.space4`
- `40` → `Theme.controlHeight`
- `6` → `Theme.radius`
- `'#2563eb'` → `Theme.primary`; `'#1d4ed8'` → `Theme.primaryDown`
- `'white'` → `Theme.onPrimary`
- `'#93c5fd'` (cincin fokus) → `Theme.focusRing`
- `'#9ca3af'` (nonaktif) → `Theme.disabled`
- (baru) `font.pixelSize: Theme.fontBody` dan `ColorAnimation { duration: Theme.durationFast }`

`Behavior on color { ColorAnimation { ... } }` membuat setiap perubahan `color` (ditekan, nonaktif, ganti tema) berlangsung mulus selama `durationFast` milidetik, alih-alih meloncat.

### Contoh pemakaian di `Main.qml`

```qml
import QtQuick
import QtQuick.Layouts

Window {
    width: 360; height: 160
    visible: true
    title: 'Uji Theme'
    color: Theme.surface

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.space4
        spacing: Theme.space3

        Text {
            text: 'Halo, tema'
            color: Theme.onSurface
            font.pixelSize: Theme.fontTitle
        }

        RowLayout {
            spacing: Theme.space2
            AppButton { label: 'Simpan'; onClicked: console.log('disimpan') }
            AppButton { label: 'Hapus'; enabled: false }
        }

        Item { Layout.fillHeight: true }
    }
}
```

Perhatikan bagaimana Fase 5 menyatu: komponen dengan API bersih (5.1), tata letak negosiatif (5.2), dan semua nilai gaya dari `Theme` (5.3).

### Aturan penamaan token

- **Nama peran, bukan nilai:** `primary`, `danger`, `surface`; bukan `blue`, `red`, `white`.
- **Pasangan `onX`** untuk isi di atas latar `X`.
- **Akhiran keadaan** untuk varian (`primaryDown`, `primaryHover`).
- **Skala bernomor** untuk deret (`space1`..`space6`) agar tak ada perdebatan antara “medium” dan “besar”.
- **Satuan tersirat dari jenis:** jarak dan ukuran dalam piksel logis, durasi dalam milidetik (`duration...`).
- **Mulai kecil.** Tambahkan token ketika satu nilai dipakai berulang di dua tempat atau lebih; hindari token yang dipakai sekali.

### Opsi lain untuk logika yang sama

```qml
// Opsi 1 — properti datar bernama (di atas): paling mudah dibaca dan diperiksa alat statis
readonly property int space2: 8

// Opsi 2 — satuan dasar + fungsi: Theme.sp(3) -> 12
readonly property int unit: 4
function sp(n) { return n * unit }

// Opsi 3 — larik: Theme.space[2] -> 8 (ringkas, tetapi indeks adalah angka ajaib bertipe var)
readonly property var space: [0, 4, 8, 12, 16, 20, 24]

// Opsi 4 — token tipografi sebagai nilai font utuh
readonly property font body: Qt.font({ pixelSize: 14 })
// pemakaian: Text { font: Theme.body }

// Opsi 5 — token primitif internal + token semantik (untuk palet besar)
readonly property QtObject _p: QtObject {
    readonly property color blue500: '#2563eb'
    readonly property color blue700: '#1d4ed8'
}
readonly property color primary: _p.blue500
readonly property color primaryDown: _p.blue700
```

Opsi 2 fleksibel (bahkan mendukung kelipatan bebas), dan QML tetap melacak ketergantungan pada `unit` di dalam fungsi saat binding dievaluasi. Opsi 3 mengorbankan keterbacaan dan pemeriksaan tipe. Opsi 1 adalah titik awal yang disarankan; pindah ke Opsi 5 bila palet Anda membesar.

### Hal yang perlu diperhatikan

- **Satu sumber per nilai.** Bila Anda menulis `8` di komponen, tanyakan: apakah ini `space2`?
- **Piksel logis.** Qt Quick menskalakan otomatis pada layar high-DPI; jangan mengalikan sendiri dengan faktor skala.
- **Pisahkan gaya dari perilaku.** Token menentukan *tampilan*; kapan sesuatu berubah adalah urusan komponen.
- **Jaga tetap kecil.** Puluhan token cukup; ratusan menandakan Anda sedang menciptakan ulang sistem desain.

**Referensi bagian ini:** [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Behavior](https://doc.qt.io/qt-6/qml-qtquick-behavior.html) · [ColorAnimation](https://doc.qt.io/qt-6/qml-qtquick-coloranimation.html) · [Qt.font()](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Design Tokens Community Group (W3C)](https://www.w3.org/community/design-tokens/) · [Material Design — Design tokens](https://m3.material.io/foundations/design-tokens/overview)

## 5.3.4 Tema gelap/terang

### Dasar: dua set nilai, satu nama

Tema gelap dan terang adalah **dua set nilai untuk token semantik yang sama**. Komponen tidak perlu tahu mana yang aktif: ia selalu menulis `Theme.surface`, dan `Theme` memutuskan nilainya berdasarkan satu saklar, `dark`. Karena token adalah binding, mengubah saklar mengubah seluruh aplikasi sekaligus.

Sumber saklar ada dua, dan keduanya dipakai bersama:

1. **Sistem:** `Qt.styleHints.colorScheme` (Qt 6.5 ke atas), bernilai `Qt.Light`, `Qt.Dark`, atau `Qt.Unknown`.
2. **Pilihan pengguna:** properti `mode` di `Theme` (ikuti sistem, paksa terang, paksa gelap).

### Contoh inti: `Theme.qml` lengkap dengan mode gelap

```qml
pragma Singleton
import QtQuick

QtObject {
    id: root

    // ===== saklar =====
    // 0 = ikuti sistem, 1 = terang, 2 = gelap
    property int mode: 0
    readonly property bool dark: (mode === 0) ? (Qt.styleHints.colorScheme === Qt.Dark) : (mode === 2)

    // ===== warna semantik: dua set, satu nama =====
    readonly property color primary:     dark ? '#60a5fa' : '#2563eb'
    readonly property color primaryDown: dark ? '#93c5fd' : '#1d4ed8'
    readonly property color onPrimary:   dark ? '#0f172a' : '#ffffff'
    readonly property color surface:     dark ? '#0f172a' : '#ffffff'
    readonly property color onSurface:   dark ? '#e2e8f0' : '#0f172a'
    readonly property color outline:     dark ? '#334155' : '#cbd5e1'
    readonly property color focusRing:   onPrimary
    readonly property color disabled:    dark ? '#475569' : '#9ca3af'

    // ===== spasi =====
    readonly property int space1: 4
    readonly property int space2: 8
    readonly property int space3: 12
    readonly property int space4: 16
    readonly property int space5: 20
    readonly property int space6: 24

    // ===== bentuk dan ukuran =====
    readonly property int radius: 6
    readonly property int controlHeight: 40

    // ===== tipografi =====
    readonly property int fontSmall: 12
    readonly property int fontBody: 14
    readonly property int fontTitle: 20

    // ===== gerak =====
    readonly property int durationFast: 120
    readonly property int durationNormal: 240

    // ===== titik patah =====
    readonly property int bpCompact: 400
    readonly property int bpMedium: 720
}
```

### Bedah kode (hanya bagian baru)

- `id: root` — nama objek; di sini dipakai bila ada kebutuhan merujuk singleton dari dalam dirinya sendiri (misalnya alias, lihat opsi di bawah).
- `property int mode: 0` — **tidak** `readonly`, karena pengguna boleh mengubahnya. Ini *keadaan gaya*: pilihan tampilan, bukan data bisnis, jadi pantas tinggal di `Theme`.
- `Qt.styleHints` — objek global (`QStyleHints`) berisi petunjuk gaya dari platform; `colorScheme` adalah skema warna yang dilaporkan sistem; `Qt.Dark` adalah nilai enumnya.
- `(mode === 0) ? (...) : (mode === 2)` — operator ternary. Bila mode 0, ikuti sistem; selain itu, gelap hanya bila mode 2. `===` adalah kesamaan ketat JavaScript (tanpa konversi tipe).
- Pada Qt di bawah 6.5 `Qt.styleHints.colorScheme` bernilai `undefined`, sehingga perbandingannya `false` dan `dark` jatuh ke terang. Ini *nilai bawaan yang aman*, bukan galat.
- `dark ? '#60a5fa' : '#2563eb'` — tiap token warna memilih nilainya berdasarkan `dark`.
- `focusRing: onPrimary` — mengikuti `onPrimary` di kedua tema.

Rantai reaktivitasnya:

```
 sistem berganti skema   --> Qt.styleHints.colorScheme berubah
 pengguna memilih mode   --> Theme.mode berubah
                                     |
                                     v
                            Theme.dark dihitung ulang
                                     |
                                     v
                 Theme.primary / surface / onSurface / ... dihitung ulang
                                     |
                                     v
        setiap binding 'color: Theme.xxx' di komponen ikut berubah (otomatis)
```

`readonly` hanya melarang *penulisan dari luar*; nilai tetap boleh berubah karena binding internal. Karena itu `Theme.dark` yang `readonly` tetap berganti saat `mode` atau skema sistem berganti.

### Saklar pengguna

```qml
AppButton {
    label: Theme.dark ? 'Mode terang' : 'Mode gelap'
    onClicked: Theme.mode = Theme.dark ? 1 : 2
}
```

Klik mengubah `mode` menjadi eksplisit (1 atau 2), sehingga pilihan pengguna menimpa skema sistem. Untuk menyediakan kembali pilihan “ikuti sistem”, tambahkan kontrol ketiga yang mengisi `Theme.mode = 0`.

### Memeriksa apa yang dilaporkan Qt di mesin Anda

```bash
cat > /tmp/cs.qml <<'EOF'
import QtQuick
Item {
    Component.onCompleted: {
        console.log('colorScheme =', Qt.styleHints.colorScheme)   // 0 Unknown, 1 Light, 2 Dark
        Qt.quit()
    }
}
EOF
qml6 /tmp/cs.qml
```

**Catatan penting untuk lingkungan terminal-sentris.** Skema warna dilaporkan oleh *tema platform*. Di GNOME atau KDE yang mengaktifkan mode gelap, hasilnya biasanya 2. Di window manager tiling tanpa desktop environment, nilainya dapat 0 (Unknown) atau 1, sehingga “ikuti sistem” tidak berarti apa-apa. Dua cara menyikapinya: (a) sediakan saklar manual dan tentukan `mode` bawaan Anda sendiri; (b) atur tema platform lewat variabel lingkungan seperti `QT_QPA_PLATFORMTHEME` (misalnya dengan `qt6ct`) dan ulangi pemeriksaan di atas. Rinciannya ada di Arch Wiki (bagian konfigurasi Qt di luar KDE Plasma); verifikasi hasilnya dengan skrip itu, jangan berasumsi.

### Opsi lain untuk mode gelap/terang

```qml
// Opsi 1 — ternary per token (di atas): sederhana, tipe-aman, tetapi "dark ?" berulang
readonly property color surface: dark ? '#0f172a' : '#ffffff'

// Opsi 2 — dua palet sebagai objek, satu pemilih
readonly property QtObject _light: QtObject { readonly property color surface: '#ffffff' }
readonly property QtObject _dark:  QtObject { readonly property color surface: '#0f172a' }
readonly property QtObject c: dark ? _dark : _light
// pemakaian: Theme.c.surface   (alat statis tidak tahu isi 'c' karena bertipe QtObject)

// Opsi 3 — mengikuti palet sistem lewat SystemPalette (lihat 5.3.6)
// Opsi 4 — style Qt Quick Controls: Material.theme / Universal.theme (lihat 5.3.6)
```

Opsi 2 memisahkan data dari logika pemilih, tetapi pemakaian `Theme.c.surface` kehilangan pemeriksaan statis oleh `qmllint`. Untuk skala latihan ini, Opsi 1 lebih tepat.

### Menyimpan pilihan pengguna (sekilas)

```qml
import QtCore

// di dalam QtObject Theme
readonly property Settings _store: Settings {
    category: 'tema'
    property alias mode: root.mode
}
```

`Settings` dari modul `QtCore` (Qt 6.5 ke atas) menyimpan nilai ke berkas pengaturan pengguna dan memuatnya kembali saat program dijalankan. Agar lokasi berkasnya jelas, aplikasi perlu mengatur nama organisasi dan nama aplikasi di `main.cpp` (`QCoreApplication::setOrganizationName` dan `setApplicationName`). Anggap ini langkah lanjutan yang diverifikasi di versi Qt Anda.

### Hal yang perlu diperhatikan

- **Jangan mengubah token dari komponen.** Satu-satunya yang boleh mengubah adalah `mode`, lewat jalur yang disengaja (misalnya halaman pengaturan).
- **Uji kedua tema.** Warna yang bagus di terang bisa tak terbaca di gelap; periksa kontras (5.3.7).
- **Animasikan perubahan dengan lembut** lewat `Behavior on color` (sudah ada di `AppButton`), tetapi jangan menganimasikan latar seluruh jendela bila itu mengganggu.
- **Sediakan nilai bawaan yang aman** ketika sistem tidak melaporkan apa-apa.

**Referensi bagian ini:** [QStyleHints (colorScheme)](https://doc.qt.io/qt-6/qstylehints.html) · [Qt namespace (enum ColorScheme)](https://doc.qt.io/qt-6/qt.html) · [Qt QML type (styleHints)](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Settings (QtCore)](https://doc.qt.io/qt-6/qml-qtcore-settings.html) · [Qt — Arch Wiki (konfigurasi di luar KDE Plasma)](https://wiki.archlinux.org/title/Qt)

## 5.3.5 Singleton dari C++ (`QML_SINGLETON`) — rujukan maju ke Modul 10.3

> **Penanda:** bagian ini hanya pengenalan konsep. Pembahasan penuh, termasuk penulisan kelas, registrasi, dan siklus hidup, ada di Modul 10.3. Jangan dipraktikkan sebelum jalur C++ dimulai.

### Dasar: mengapa ada versi C++?

Singleton QML (`Theme.qml`) cocok untuk nilai visual murni. Bila singleton perlu *logika* (membaca berkas konfigurasi, menyimpan pilihan pengguna, mendeteksi tema sistem lewat API platform, diuji unit), kelas C++ yang diekspos sebagai singleton lebih tepat. QML melihatnya persis sama: tetap `Theme.primary`.

### Gambaran kode

```cpp
// theme.h
#pragma once

#include <QColor>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class Theme : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QColor primary READ primary NOTIFY primaryChanged)

public:
    explicit Theme(QObject *parent = nullptr) : QObject(parent) {}
    QColor primary() const { return m_primary; }

signals:
    void primaryChanged();

private:
    QColor m_primary { QColor(0x25, 0x63, 0xeb) };
};
```

```cmake
qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES Main.qml AppButton.qml
    SOURCES theme.h
)
```

### Bedah kode (kata demi kata)

- `#include <QtQml/qqmlregistration.h>` — menyediakan makro registrasi (`QML_ELEMENT`, `QML_SINGLETON`).
- `class Theme : public QObject` — kelas C++ yang diwarisi dari `QObject` agar punya properti, signal, dan sistem meta Qt.
- `Q_OBJECT` — mengaktifkan sistem meta (diproses oleh `moc`).
- `QML_ELEMENT` — mengekspos kelas ini ke QML dengan nama yang sama (`Theme`).
- `QML_SINGLETON` — menandainya sebagai singleton: satu instans per engine. Kelas butuh konstruktor publik tanpa argumen wajib (di sini `Theme(QObject *parent = nullptr)`), atau fungsi pabrik statis.
- `Q_PROPERTY(QColor primary READ primary NOTIFY primaryChanged)` — mendeklarasikan properti `primary` bertipe `QColor`. `READ` menunjuk getter; `NOTIFY` menunjuk signal yang dipancarkan saat nilainya berubah. **Tanpa `NOTIFY`, binding di QML tidak akan diperbarui** ketika nilai berubah.
- `signals: void primaryChanged();` — signal pemberitahuan itu.
- `QColor(0x25, 0x63, 0xeb)` — warna dari tiga komponen heksadesimal (merah, hijau, biru): sama dengan `#2563eb`.
- `SOURCES theme.h` — memasukkan berkas C++ ke modul QML agar registrasinya dibuat otomatis saat build.

### Kapan memilih yang mana

```
 Hanya nilai visual, ingin iterasi cepat tanpa kompilasi ulang? --> Theme.qml (singleton QML)
 Perlu logika, penyimpanan, API platform, atau uji unit?        --> singleton C++
 Keduanya?   --> C++ untuk logika (mode, deteksi skema, penyimpanan),
                 QML untuk token visual yang membaca C++
```

Satu catatan praktis: perubahan pada `Theme.qml` tampak tanpa kompilasi ulang bila Anda memakai jalur `qml6` (lihat 5.3.2) atau kebiasaan `entr`; perubahan C++ selalu menuntut build ulang. Itu alasan token visual enak tinggal di QML.

**Hindari bentrok nama:** jangan mendaftarkan `Theme` di QML *dan* di C++ dalam modul yang sama.

**Referensi bagian ini:** [Defining QML Types from C++ (QML\_SINGLETON)](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html) · [Exposing Attributes of C++ Classes to QML](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppattributes.html) · [The Property System](https://doc.qt.io/qt-6/properties.html) · [qt\_add\_qml\_module (SOURCES)](https://doc.qt.io/qt-6/qt-add-qml-module.html)

## 5.3.6 \[TAMBAHAN\] Alternatif mekanisme tema dan kapan memilihnya

*Alasan penambahan:* singleton hanyalah satu cara. Memahami alternatifnya membuat Anda memilih dengan sadar, dan memberi jalan keluar ketika satu tema global tidak cukup.

### 1. `SystemPalette`: mengikuti palet sistem

```qml
import QtQuick

Rectangle {
    SystemPalette { id: sys; colorGroup: SystemPalette.Active }

    color: sys.window
    Text { text: 'Halo'; color: sys.windowText }
}
```

- `SystemPalette` membaca palet warna platform: `window`, `windowText`, `base`, `text`, `button`, `buttonText`, `highlight`, `highlightedText`, dan lainnya.
- `colorGroup` memilih kelompok (`Active`, `Inactive`, `Disabled`).
- Kelebihan: mengikuti sistem tanpa Anda mendefinisikan warna. Kekurangan: himpunan peran terbatas (tidak ada `primary` atau `danger`), dan di window manager tanpa desktop environment palet bisa tidak mencerminkan preferensi Anda kecuali tema platform diatur (misalnya `qt6ct`).
- Pola gabungan yang baik: token `Theme` diturunkan dari `SystemPalette` untuk peran netral (`surface: sys.window`) dan didefinisikan sendiri untuk peran khas aplikasi (`primary`).

### 2. Tema yang disuntikkan (non-singleton): menimpa satu bagian UI

```qml
// ThemeData.qml (tipe biasa, BUKAN singleton)
import QtQuick

QtObject {
    property bool dark: false
    readonly property color surface:   dark ? '#0f172a' : '#ffffff'
    readonly property color onSurface: dark ? '#e2e8f0' : '#0f172a'
}
```

```qml
// Panel.qml
import QtQuick

Rectangle {
    id: root
    property ThemeData theme: ThemeData {}

    color: root.theme.surface
    Text { text: 'Panel'; color: root.theme.onSurface }
}
```

```qml
// pemakai: panel gelap di dalam aplikasi berlatar terang
Panel { theme: ThemeData { dark: true } }
```

Singleton bersifat global: satu tema untuk seluruh aplikasi. Bila satu bagian harus tampil berbeda (panel gelap di aplikasi terang, atau tema khusus saat pengujian), tema sebagai objek biasa yang diteruskan lewat properti memberi kendali per-bagian dan mudah digantikan dengan data uji. Harganya: Anda harus meneruskannya (props drilling) dan menulis `root.theme.xxx` di setiap komponen. Kompromi umum: nilai bawaan `theme` mengambil dari singleton `Theme`.

### 3. Qt Quick Controls: style dan `palette`

```qml
import QtQuick.Controls.Basic

ApplicationWindow {
    visible: true
    palette.button: '#2563eb'
    palette.buttonText: 'white'

    Button { text: 'Simpan' }   // mewarisi palette dari jendela
}
```

```bash
# memilih style Material atau Universal saat dijalankan
QT_QUICK_CONTROLS_STYLE=Material ./build/hello
```

Pada kontrol standar, mekanisme tema bawaan Qt adalah *style* (Basic, Fusion, Material, Universal, dan lainnya) dan `palette`. Style Material dan Universal juga punya atribut tema sendiri (`Material.theme`, `Universal.theme`). Hubungannya dengan `Theme` singleton: singleton menata komponen *buatan sendiri* (seperti `AppButton`), sedangkan style menata kontrol *bawaan*; keduanya dapat disinkronkan dengan memetakan `Theme.primary` ke `Material.accent`. Periksa dokumentasi `Palette` untuk perilaku versi Qt Anda.

### 4. Berkas JavaScript `.pragma library` (hanya konstanta)

```js
// Konstanta.js
.pragma library
var RADIUS = 6
var SPACE2 = 8
```

Nilai statis yang tidak berubah. Cocok untuk konstanta murni, tetapi **tidak reaktif**: tidak memberi tahu pemakai saat berubah, sehingga tidak bisa dipakai untuk mode gelap/terang yang berganti saat berjalan.

### 5. Context property dari C++ (hindari)

`engine.rootContext()->setContextProperty(...)` membuat objek tersedia sebagai nama global tanpa tipe yang dapat diperiksa alat statis. Di Qt 6 pendekatan modul-dan-singleton yang bertipe (5.3.1 dan 5.3.5) lebih disarankan.

### Ringkasan pilihan

```
 Satu tema global, komponen buatan sendiri .......... Theme singleton (QML)
 Perlu logika atau penyimpanan ...................... singleton C++
 Perlu menimpa satu bagian UI / uji dengan data palsu  tema yang disuntikkan
 Ingin mengikuti palet sistem secara langsung ....... SystemPalette (digabung dengan Theme)
 Memakai kontrol bawaan Qt Quick Controls ........... style dan palette
 Hanya konstanta statis ............................. JS .pragma library
```

**Referensi bagian ini:** [SystemPalette](https://doc.qt.io/qt-6/qml-qtquick-systempalette.html) · [Styling Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-styles.html) · [Material style](https://doc.qt.io/qt-6/qtquickcontrols-material.html) · [Customizing Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-customize.html) · [JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-resources.html)

## 5.3.7 \[TAMBAHAN\] Penegakan, migrasi, dan kontras warna

*Alasan penambahan:* tema hanya berguna bila **tidak ada yang lolos darinya**. Satu warna atau angka mentah yang tertinggal berarti satu tempat yang tidak ikut berubah saat tema berganti.

### Migrasi bertahap

1. **Inventarisasi** nilai mentah yang tersisa (perintah di bawah).
2. **Definisikan token** untuk nilai yang dipakai berulang.
3. **Ganti** nilai mentah dengan token.
4. **Ulangi inventarisasi** sampai bersih.
5. **Jalankan `qmllint`** untuk menangkap rujukan `Theme` yang salah.

```bash
# warna heksadesimal mentah di luar Theme.qml
grep -nE '#[0-9a-fA-F]{6}' *.qml | grep -v Theme.qml

# nama warna mentah yang umum
grep -nwE 'white|black|red|green|blue|tomato' *.qml | grep -v Theme.qml

# spasi, radius, dan padding berupa angka mentah
grep -nE '(spacing|margins|radius|padding):[[:space:]]*[0-9]+' *.qml | grep -v Theme.qml

# analisis statis
qmllint6 *.qml
cmake --build build --target all_qmllint
```

Temuan dengan nilai 0 atau 1 (misalnya `anchors.margins: 0`, `border.width: 1`) biasanya wajar dibiarkan; yang lain perlu ditinjau.

### Kontras warna (aksesibilitas)

Pedoman WCAG 2.1 menyarankan rasio kontras minimal **4,5 : 1** untuk teks normal, **3 : 1** untuk teks besar dan untuk komponen antarmuka serta indikator fokus. Rasionya dihitung dari luminans relatif: `(L1 + 0.05) / (L2 + 0.05)`, dengan `L1` yang lebih terang.

```bash
python3 - <<'EOF'
def lum(h):
    h = h.lstrip('#')
    r, g, b = [int(h[i:i+2], 16) / 255 for i in (0, 2, 4)]
    f = lambda c: c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)

def ratio(a, b):
    la, lb = sorted((lum(a), lum(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)

print('terang: onPrimary di atas primary =', round(ratio('#ffffff', '#2563eb'), 2))
print('gelap : onPrimary di atas primary =', round(ratio('#0f172a', '#60a5fa'), 2))
print('terang: onSurface di atas surface =', round(ratio('#0f172a', '#ffffff'), 2))
print('gelap : onSurface di atas surface =', round(ratio('#e2e8f0', '#0f172a'), 2))
EOF
```

Perkiraan hasilnya sekitar 5 : 1 untuk pasangan terang, sekitar 7 : 1 untuk pasangan gelap, dan jauh di atas 10 : 1 untuk teks di atas latar; jalankan skripnya untuk angka pastinya di mesin Anda.

**Koreksi atas contoh sebelumnya (5.1.6).** Pada contoh `AppButton` di 5.1.6 cincin fokus memakai `#93c5fd`. Dengan skrip yang sama, kontrasnya terhadap biru tombol hanya sekitar 2,9 : 1, di bawah 3 : 1 yang disarankan untuk indikator fokus. Karena `Rectangle` menggambar garis tepinya *di dalam* bidangnya, cincin berada di atas isi tombol; itulah sebabnya `Theme.focusRing` di bagian ini memakai `onPrimary` (putih di tema terang, sekitar 5 : 1 terhadap biru tombol). Prinsipnya: **ukur kontras indikator fokus terhadap warna yang benar-benar bersebelahan dengannya**, jangan memilih “warna yang tampak cantik”.

### Opsi lain untuk menegakkan konsistensi

- **Tinjauan kode** dengan daftar periksa: “adakah warna atau angka mentah?”
- **Pra-komit (pre-commit hook)** yang menjalankan `grep` di atas dan gagal bila ada temuan.
- **`qmllint` di CI** (target `all_qmllint`).
- **Tes visual**: tangkap layar kedua tema di CI dan bandingkan dengan referensi (di luar cakupan modul ini).

**Referensi bagian ini:** [WCAG 2.1 — Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) · [WCAG 2.1 — Non-text Contrast](https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [Rectangle (border)](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html)

## Terminologi Esensial

- **Singleton** — tipe yang hanya punya satu instans untuk seluruh engine.
- **`pragma`** — direktif untuk engine QML yang mengubah cara sebuah dokumen diperlakukan (`pragma Singleton`).
- **`qmldir`** — berkas teks yang mendaftarkan tipe-tipe sebuah modul QML.
- **`QT_QML_SINGLETON_TYPE`** — properti berkas CMake yang membuat `qt_add_qml_module` menulis baris `singleton` di `qmldir`.
- **`QtObject`** — objek dasar tanpa tampilan; tipe dasar yang lazim untuk singleton tema.
- **Design token** — nilai desain bernama (warna, jarak, radius, tipografi, durasi).
- **Token semantik** — token yang dinamai menurut *peran* (`primary`), bukan nilai (`blue`).
- **Token primitif** — nilai mentah bernama yang menjadi bahan token semantik.
- **Pasangan `onX`** — warna isi di atas latar `X` (`onPrimary` di atas `primary`).
- **Skala spasi** — deret jarak berkelipatan tetap (di sini 4 piksel).
- **Piksel logis** — satuan ukuran Qt Quick yang diskalakan otomatis pada layar high-DPI.
- **`readonly property`** — properti yang tidak boleh ditulis dari luar, tetapi dapat berubah lewat binding internal.
- **Binding reaktif** — ekspresi yang dihitung ulang otomatis saat nilai yang dirujuknya berubah.
- **Skema warna (`colorScheme`)** — laporan platform tentang tema terang atau gelap (`Qt.Light`, `Qt.Dark`, `Qt.Unknown`).
- **Mode** — pilihan pengguna atas tema (ikuti sistem, terang, gelap).
- **`SystemPalette`** — tipe QML yang memberi akses ke palet warna platform.
- **Tema yang disuntikkan** — objek tema biasa (bukan singleton) yang diteruskan lewat properti.
- **Props drilling** — meneruskan sebuah nilai lewat banyak lapis komponen.
- **`QML_SINGLETON`** — makro C++ yang mengekspos kelas sebagai singleton QML.
- **`Q_PROPERTY` / `NOTIFY`** — deklarasi properti C++ dan signal pemberitahuan yang membuat binding QML reaktif.
- **Kontras (rasio)** — perbandingan luminans dua warna; ukuran keterbacaan.
- **WCAG** — pedoman aksesibilitas web yang rasio kontrasnya dipakai juga untuk aplikasi.

## Hubungan dengan Modul Lain

- **Prasyarat:** Modul 5.1 (komponen, API, ukuran implisit), Modul 5.2 (spasi, margin, titik patah yang kini menjadi token), serta properti dan binding dari Fase 3.
- **Menuju Modul 10.3 (jalur C++):** konsep singleton sama, hanya sumbernya berbeda; makro `QML_ELEMENT` dan `QML_SINGLETON` dibahas penuh di sana.
- **Ke penggunaan Qt Quick Controls:** pemetaan `Theme` ke style dan `palette` menjadi relevan begitu aplikasi memakai kontrol bawaan.
- **Ke fase berikutnya:** komponen, tata letak, dan tema yang kini terpadu menjadi dasar untuk membangun halaman, navigasi, dan daftar data.

## Kesalahan Umum dan Solusi

1. **“ReferenceError: Theme is not defined”.** *Sebab:* singleton tidak terdaftar atau tidak diimpor. *Solusi:* periksa baris `singleton Theme` di `qmldir` (5.3.2), daftar `QML_FILES`, dan impor modul.
2. **Properti berkas dipasang sesudah `qt_add_qml_module`.** *Sebab:* urutan salah. *Akibat:* diam-diam tidak berlaku. *Solusi:* `set_source_files_properties` harus lebih dulu.
3. **Lupa `pragma Singleton`.** *Akibat:* `Theme` tidak berperilaku sebagai singleton. *Solusi:* jadikan baris pertama berkas.
4. **Mencoba membuat `Theme { }`.** *Sebab:* menganggapnya tipe biasa. *Solusi:* singleton tidak diinstansiasi; baca propertinya langsung (`Theme.primary`).
5. **Menulis ke token `readonly`.** *Akibat:* galat yang menyebut properti hanya-baca. *Solusi:* ubah lewat jalur yang sengaja disediakan (`Theme.mode`), bukan menimpa token.
6. **Menaruh data bisnis atau rahasia di `Theme`.** *Sebab:* singleton terasa praktis. *Akibat:* keadaan global tersembunyi yang sulit diaudit dan berisiko. *Solusi:* `Theme` hanya untuk gaya; data tinggal di model atau lapisan lain.
7. **Warna atau angka mentah tersisa di komponen.** *Solusi:* migrasi dan penegakan di 5.3.7.
8. **“Ikuti sistem” tidak berfungsi di window manager tiling.** *Sebab:* `colorScheme` bernilai `Unknown`. *Solusi:* periksa dengan skrip 5.3.4, sediakan saklar manual dan `mode` bawaan, atau atur tema platform.
9. **Teks tak terbaca di salah satu mode.** *Sebab:* pasangan token tidak diuji. *Solusi:* pakai pasangan `onX` dan ukur kontras (5.3.7).
10. **Dua `Theme` (QML dan C++) bernama sama.** *Solusi:* pilih satu, atau beri nama berbeda (`Theme` untuk token visual, `ThemeSettings` untuk logika).
11. **Mengubah token dari komponen biasa.** *Akibat:* efek samping global yang sulit dilacak. *Solusi:* hanya satu jalur terkontrol yang boleh menulis ke `Theme`.
12. **Menganimasikan semua perubahan warna di seluruh aplikasi.** *Akibat:* boros dan kadang mengganggu. *Solusi:* pasang `Behavior on color` secara selektif pada komponen interaktif.

## Tips dan Praktik Terbaik

- **Token dulu, komponen kemudian.** Tulis `Theme` sebelum menulis komponen baru agar tidak perlu migrasi.
- **Satu pintu untuk perubahan.** Bila `mode` boleh ditulis dari luar, jadikan itu satu-satunya properti yang dapat ditulis; tambahkan fungsi `setMode(m)` bila butuh validasi.
- **Iterasi cepat:** `ls *.qml qmldir | entr -r qml6 Main.qml` memuat ulang tiap Anda menyimpan; mengubah satu token langsung terlihat.
- **Uji kedua tema dan kedua mode** (terang, gelap, ikuti sistem) setiap perubahan besar.
- **Pikirkan kontras sejak memilih warna,** bukan setelah. Ukur dengan skrip 5.3.7.
- **Jangan menyimpan rahasia di singleton** (kata sandi, token, kunci). Singleton adalah keadaan global yang dapat dibaca seluruh QML.
- **Dokumentasikan token** dalam komentar singkat (peran, bukan nilai) agar pembaca tahu kapan memakainya.
- **Pertimbangkan skema warna sistem sebagai nilai bawaan, bukan satu-satunya sumber.** Pengguna tetap perlu saklar.
- **Jaga `Theme.qml` kecil.** Bila tumbuh besar, pecah menjadi beberapa singleton (`Colors`, `Spacing`, `Typography`) atau beberapa berkas.

## Latihan 15 Menit (versi diperbaiki)

*Perbaikan dari audit:* kurikulum berhenti pada “ubah satu token dan lihat efeknya”. Di sini ditambah verifikasi pendaftaran, mode gelap, dan penegakan.

1. Buat `Theme.qml` (versi 5.3.3) dan daftarkan di CMake dengan `QT_QML_SINGLETON_TYPE` **sebelum** `qt_add_qml_module`. Verifikasi bahwa `build/Hello/qmldir` memuat baris `singleton Theme`.
2. Ganti seluruh warna dan angka di `AppButton` dengan token (gunakan peta penggantian di 5.3.3).
3. Ubah satu token, misalnya `primary`, lalu jalankan ulang; seluruh tombol berubah warna.
4. Tambahkan `mode` dan `dark` serta dua set warna (versi 5.3.4) dan sebuah tombol pengalih.
5. Jalankan tiga perintah `grep` di 5.3.7 sampai bersih, lalu `qmllint6 *.qml`.
6. Ukur kontras pasangan warna Anda dengan skrip Python di 5.3.7.

**Kunci jawaban** (coba dulu sebelum membaca):

- `Theme.qml` lengkap: bagian 5.3.4. `AppButton` akhir: bagian 5.3.3.
- `Main.qml`:

```qml
import QtQuick
import QtQuick.Layouts

Window {
    width: 360; height: 180
    visible: true
    title: 'Uji Theme'
    color: Theme.surface

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.space4
        spacing: Theme.space3

        Text { text: 'Halo, tema'; color: Theme.onSurface; font.pixelSize: Theme.fontTitle }

        RowLayout {
            spacing: Theme.space2
            AppButton { label: 'Simpan'; onClicked: console.log('disimpan') }
            AppButton { label: 'Hapus'; enabled: false }
            AppButton {
                label: Theme.dark ? 'Mode terang' : 'Mode gelap'
                onClicked: Theme.mode = Theme.dark ? 1 : 2
            }
        }

        Item { Layout.fillHeight: true }
    }
}
```

- Jalur cepat tanpa CMake: tulis `qmldir` di folder yang sama (`singleton Theme 1.0 Theme.qml` dan `AppButton 1.0 AppButton.qml`), lalu `ls *.qml qmldir | entr -r qml6 Main.qml`.
- Yang akan Anda amati: klik tombol pengalih mengganti seluruh jendela (latar, teks, tombol) sekaligus dengan transisi warna lembut; tombol “Hapus” tetap nonaktif di kedua tema; `grep` tidak menemukan warna mentah di luar `Theme.qml`.

**Tantangan opsional:** tambahkan opsi “ikuti sistem” sebagai tombol ketiga (`Theme.mode = 0`) dan bandingkan perilakunya dengan hasil skrip pemeriksaan `colorScheme` di mesin Anda.

## Cek Pemahaman dan Kunci

1. **Mengapa `Theme.qml` butuh dua hal: `pragma Singleton` dan properti berkas di CMake?** *Kunci:* `pragma Singleton` ditulis di dalam dokumen untuk menandai perilakunya; properti `QT_QML_SINGLETON_TYPE` membuat CMake menulis baris `singleton` di `qmldir`, yaitu cara modul memberi tahu engine bahwa tipe itu singleton sebelum kode berjalan. Tanpa salah satunya, `Theme` tidak dikenal atau tidak berperilaku sebagai singleton.
2. **Mengapa properti berkas harus ditetapkan sebelum `qt_add_qml_module`?** *Kunci:* nilainya dibaca saat `qt_add_qml_module` dijalankan untuk membuat `qmldir`; menetapkannya sesudahnya tidak berefek.
3. **Mengapa token `readonly` tetap bisa berubah saat mode berganti?** *Kunci:* `readonly` hanya melarang penulisan dari luar. Nilai token adalah binding internal yang dihitung ulang ketika `dark` berubah.
4. **Apa yang boleh dan tidak boleh ada di singleton tema?** *Kunci:* boleh keadaan gaya (token, `mode`); tidak boleh data bisnis, data pengguna, atau rahasia.
5. **Mengapa token dinamai menurut peran?** *Kunci:* peran (`primary`) tetap sama ketika nilainya berganti (biru ke hijau, terang ke gelap), sehingga komponen tak perlu diubah.
6. **Apa yang Anda lakukan bila `colorScheme` bernilai `Unknown` di window manager tiling?** *Kunci:* periksa dengan skrip, sediakan saklar manual dan `mode` bawaan yang aman, atau atur tema platform (misalnya `qt6ct`) lalu ukur ulang.

## Rangkuman Fase 5

```
 5.1 Komponen sebagai API   -->  tipe dengan antarmuka jelas (properti masuk, signal keluar)
 5.2 Positioner dan Layouts -->  penataan negosiatif yang bereaksi pada ukuran apa pun
 5.3 Tema dan Singleton     -->  semua nilai gaya dari satu sumber, gelap/terang dari satu saklar
```

**Daftar periksa Fase 5** (gunakan saat meninjau kode sendiri):

- **Komponen:** API publik minimal dan jelas; ukuran implisit terisi; tanpa `parent` di root; bisa dioperasikan keyboard dan punya peran aksesibilitas.
- **Tata letak:** Layout bila ukuran harus dinegosiasikan, positioner bila ukuran pasti; tanpa `anchors` pada anak Layout; `Layout.*` ditulis pemakai; ukuran minimum jendela jelas; diuji pada ukuran dan skala ekstrem.
- **Tema:** tak ada warna atau angka mentah di luar `Theme`; pasangan `onX` terukur kontrasnya; kedua tema diuji; nilai bawaan aman bila sistem tak melaporkan skema.

**Proyek mini opsional** (menyatukan seluruh fase): sebuah *panel pengaturan* dengan form dua kolom yang responsif (5.2), tombol dan kolom isian buatan sendiri dengan API bersih (5.1), dan saklar tema gelap/terang yang mengubah seluruh tampilan (5.3).

## Referensi Tambahan

- [Module Definition qmldir Files](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html)
- [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html)
- [qt\_target\_qml\_sources](https://doc.qt.io/qt-6/qt-target-qml-sources.html)
- [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html)
- [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html)
- [Qt — Arch Wiki](https://wiki.archlinux.org/title/Qt)
- [WCAG 2.1 — Understanding Contrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [Design Tokens Community Group](https://www.w3.org/community/design-tokens/)

---

*Satu sumber kebenaran: ubah satu nilai, dan seluruh dunia yang Anda bangun ikut berubah.*

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
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

