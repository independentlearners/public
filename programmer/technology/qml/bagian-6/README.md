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

