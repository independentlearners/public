# Fase 4 · Modul 4.1 — Item dan Primitif Visual

*Pembuka Fase 4: Dasar Visual Qt Quick.*

---

## A. Audit singkat

**Fase 4 secara keseluruhan:**

- Urutan 4.1 → 4.4 logis: bentuk (4.1), posisi (4.2), bahan (4.3), interaksi (4.4).
- **Prasyarat tersembunyi.** 4.3.6 memakai CMake dan `qt_add_qml_module`, padahal dasar C++ dan CMake ada di Modul 10.1. Catatan fase memang menyuruh memulai jalur C++ paralel. Penegasan: kerjakan setidaknya 10.1 sebelum 4.3.6.
- Fase ini belum memuat positioner (`Row`, `Column`, `Grid`, `Flow`) maupun `Layouts`. Itu sah bila ada di fase berikutnya; Disini hanya mencatatnya agar tidak terlewati.
- Pada 4.4 kurikulum memakai `Keys` untuk tombol `Q`. Untuk pintasan tingkat jendela, tipe `Shortcut` lebih tepat. Dibahas di 4.4.

**Modul 4.1, terverifikasi:**

- `Item` memang tak punya tampilan, tetapi mendefinisikan atribut yang dipakai semua item visual: posisi, ukuran, anchors, dan penanganan key.
- `import QtQuick` cukup untuk memakai `Window` di Qt 6. Contoh kurikulum sah. (Di Qt 5 diperlukan `QtQuick.Window`.)
- `Window` bukan `Item`. Item yang Anda taruh di dalamnya menjadi anak `contentItem`, akar tak terlihat dari scene, sehingga `parent` item itu adalah `contentItem`.
- `visible: false` menghentikan penerimaan input dan penggambaran, sedangkan `opacity: 0` tidak mengubah penerimaan input.
- Aturan `z` di kurikulum benar: `z` lebih tinggi di atas, `z` sama menurut urutan deklarasi, `z` negatif di bawah isi induknya.
- `clip` bawaannya `false`, memotong gambar item dan anak-anaknya ke persegi batasnya, dan dapat memengaruhi performa.

**Perlu dikoreksi atau dilengkapi:**

1. **Frasa kesalahan umum soal `visible` dan `opacity` ambigu.** Kalimatnya benar tetapi tak menjelaskan apa bedanya. Telah ditambahkan tabel perbandingan `visible`, `opacity`, dan `enabled` di 4.1.3.
2. **4.1.2 terlalu tipis.** `Rectangle` punya `border`, `gradient`, `radius` (dan radius per sudut sejak Qt 6.7). `Text` punya aturan ukuran, `elide`, `wrapMode`, dan peringatan keamanan: secara bawaan `Text` menebak apakah isinya markup, dan dokumentasi 6.12 memperingatkan bahwa mode ini dapat memuat gambar lewat jaringan. `Image` cukup diperkenalkan di sini (detail di 4.3).
3. **Hierarki induk-anak belum dibahas sebagai properti.** `parent`, `children`, `data`, dan `resources` adalah inti dari hierarki yang disebut di konsep. TAMBAHAN 4.1.6.
4. **`Window` perlu lebih dari satu kalimat.** `visible` bawaannya `false`, `contentItem`, atribut terlampir `Window`, `ApplicationWindow`, dan perilaku akar `Item` saat dijalankan dengan `qml`. Diperluas di 4.1.5.
5. **Cara item sampai ke layar tidak disebut.** Tanpa gambaran scene graph, biaya `clip` dan `opacity` terasa tanpa alasan. TAMBAHAN 4.1.7, lengkap dengan alat diagnosis `QSG_VISUALIZE`.
6. **Ukuran bawaan 0 × 0** adalah penyebab terbesar “Rectangle tak muncul”. Telah dimasukkan ke tabel kesalahan.

**TAMBAHAN:**

- **4.1.6** `parent`, `children`, `data`, `resources`, dan memindahkan item.
- **4.1.7** Dari item ke piksel: scene graph dan alat diagnosis.

---

<details>
  <summary>📃 Daftar Isi</summary>

---

## B. Daftar isi Modul 4.1 (diperbarui)

- **4.1.1** `Item` dan hierarki `[diperluas]`
- **4.1.2** `Rectangle`, `Text`, `Image` `[diperluas]`
- **4.1.3** `visible`, `opacity`, `enabled` `[diperluas]`
- **4.1.4** `clip` dan biayanya
- **4.1.5** `Window` dan item akar `[diperluas]`
- **4.1.6** `parent`, `children`, `data`, `resources` `[TAMBAHAN]`
- **4.1.7** Dari item ke piksel: scene graph dan alat diagnosis `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 4.1.1 → 4.1.2 → 4.1.3 → 4.1.4 → 4.1.5 → 4.1.6 → 4.1.7.

</details>

---

## C. Peta besar

```
 Window                      jendela tingkat atas (BUKAN Item)
   |
   +-- contentItem           akar tak terlihat dari scene
         |
         +-- Item (akar)            x, y relatif ke contentItem
               |
               +-- Rectangle        x, y relatif ke Item akar
               |     +-- Text       x, y relatif ke Rectangle
               +-- Text

 Urutan GAMBAR : dari akar ke daun; saudara yang lebih akhir di atas (kecuali z)
 Urutan INPUT  : dari yang paling atas ke bawah, berhenti di yang menerimanya
```

**Filosofinya:** antarmuka Qt Quick adalah pohon objek. Setiap simpul adalah sebuah papan, dan induk menentukan tiga hal untuk anak-anaknya: koordinat, urutan gambar, dan visibilitas. Merancang tampilan berarti merancang pohon. Pohon yang rapi mudah dibaca, diperiksa, dan dioptimalkan; pohon yang berantakan menyimpan item tak terlihat yang tetap diproses.

**Cara menjalankan contoh:**

- Dengan jendela di sesi grafis Anda: `qml nama.qml`.
- Tanpa jendela, hanya log: `QT_QPA_PLATFORM=offscreen qml nama.qml`. Berkas yang akarnya `Item` akan dibungkus jendela oleh `qml` `[uji]`.
- Peringatan statis: `qmllint nama.qml` (di Arch bisa `qmllint6`).

---

## D. Materi

### 4.1.1 `Item` dan hierarki

*Setiap antarmuka besar dimulai dari satu papan kosong.*

**Konsep.** `Item` adalah tipe dasar semua item visual di Qt Quick. Ia tidak punya tampilan, tetapi mendefinisikan atribut bersama: `x` dan `y`, `width` dan `height`, anchors, dan penanganan key. Karena tak menggambar apa pun, `Item` dipakai sebagai wadah yang mengelompokkan item lain di bawah satu akar.

Tiga sifat yang perlu Anda ingat:

- Ukuran bawaan `Item` adalah 0 × 0. Anak-anaknya tetap tergambar walau berada di luar batas induk, selama `clip` tidak aktif (4.1.4).
- `x` dan `y` sebuah anak dihitung relatif terhadap induknya, bukan terhadap jendela.
- Posisi, urutan gambar, dan visibilitas anak mengikuti induknya.

**Peragaan: hierarki dan koordinat relatif.**

```qml
import QtQuick

Item {
    id: root
    width: 300; height: 200

    Item {
        id: panel
        x: 50; y: 40                           // relatif terhadap root
        width: 200; height: 100

        Item {
            id: titik
            x: 10; y: 20                       // relatif terhadap panel, bukan root
            width: 10; height: 10
        }
    }

    Component.onCompleted: {
        console.log(titik.parent === panel)                        // true
        console.log(panel.parent === root)                         // true
        const p = titik.mapToItem(root, 0, 0)
        console.log(p.x, p.y)                                      // 60 60
        console.log(root.children.length, panel.children.length)   // 1 1
        Qt.quit()
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml hierarki.qml
```

Dugaan keluaran: `qml: true`, `qml: true`, `qml: 60 60`, `qml: 1 1` `[uji]`.

**Bedah kode:**

- `import QtQuick`: memuat tipe visual (`Item`, `Rectangle`, `Text`, `Window`).
- `Item { id: root ... }`: item akar. `width: 300; height: 200` menetapkan ukurannya; titik koma memisahkan dua properti dalam satu baris.
- `Item { id: panel; x: 50; y: 40 }`: anak langsung `root`. Posisinya (50, 40) diukur dari sudut kiri atas `root`.
- `Item { id: titik; x: 10; y: 20 }`: anak `panel`. Posisinya (10, 20) diukur dari sudut kiri atas `panel`, sehingga posisi aslinya di `root` adalah (60, 60).
- `titik.parent === panel`: properti `parent` menunjuk induk visual. Tiga tanda sama membandingkan identitas objek.
- `titik.mapToItem(root, 0, 0)`: mengubah titik (0, 0) di dalam `titik` menjadi koordinat di dalam `root`. Hasilnya objek titik dengan `x` dan `y`.
- `root.children.length`: `children` berisi anak yang berupa `Item` (visual).
- `const p = ...`: variabel lokal yang tak bisa ditugaskan ulang (3.4.6).

```
 root (0,0)
 +--------------------------------------+
 |    panel (50,40) relatif ke root     |
 |    +-----------------------------+   |
 |    |  titik (10,20) rel. panel   |   |
 |    |    = (60,60) rel. root      |   |
 |    +-----------------------------+   |
 +--------------------------------------+
```

**Opsi lain, memilih wadah:**

| Tipe | Kapan | Catatan |
| --- | --- | --- |
| `Item` | Mengelompokkan tanpa menggambar | Paling ringan; tak punya ukuran sendiri |
| `Rectangle` | Wadah yang juga perlu latar atau bingkai | Menggambar; ikut biaya render |
| `FocusScope` | Wadah yang mengelola fokus keyboard bagi anak-anaknya | Dibahas di 4.4 |
| Positioner (`Row`, `Column`, ...) | Menata anak berurutan | Fase berikutnya |
| `Window.contentItem` | Akar scene sebuah jendela | Dibuat otomatis (4.1.5) |

**Hal yang perlu diingat:**

- Item tak terlihat tetap diproses: properti, binding, dan input tetap berjalan. Wadah yang tak diperlukan sebaiknya dihapus dari pohon.
- Item tanpa ukuran masih bisa memiliki anak yang berukuran. Ia hanya tak punya area sendiri untuk menerima input.

| Kesalahan | Solusi |
| --- | --- |
| Mengira `x` dan `y` anak diukur dari jendela | Selalu relatif ke `parent`. Pakai `mapToItem` untuk konversi |
| Wadah `Item` tanpa ukuran lalu heran `MouseArea` atau `anchors` di dalamnya tak berfungsi | Beri ukuran, atau `anchors.fill: parent` |
| Menumpuk wadah bersarang tanpa alasan | Ratakan pohonnya |

**Referensi:** [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Important Concepts In Qt Quick: Positioning](https://doc.qt.io/qt-6/qtquick-positioning-topic.html)

---

### 4.1.2 `Rectangle`, `Text`, `Image`

*Tiga primitif sudah cukup untuk menggambar hampir semua yang pernah Anda lihat di layar.*

**Konsep.** Primitif visual adalah item yang benar-benar menggambar sesuatu: `Rectangle` mengisi area dengan warna atau gradien dan boleh berbingkai, `Text` menampilkan teks, `Image` menampilkan bitmap.

**`Rectangle`** (dokumentasi 6.12):

- `color` bawaannya putih. Bila `gradient` juga diberikan, gradien yang dipakai.
- `border.width` dan `border.color` menggambar bingkai. Bingkai dirender di dalam batas persegi dan tidak mengubah geometri item atau posisinya terhadap item lain.
- `radius` membulatkan sudut. Sejak Qt 6.7 ada `topLeftRadius`, `topRightRadius`, `bottomLeftRadius`, dan `bottomRightRadius`.
- `antialiasing` bawaannya `true` bila ada `radius`, dan `false` bila tidak. Ia memperhalus tepi dengan biaya render, jadi dokumentasi menyarankan mematikannya pada persegi yang sedang bergerak.

**`Text`:**

- Bila `width` dan `height` tak diatur, `Text` menghitung sendiri ruang yang ia perlukan, dan tanpa `wrapMode` ia memilih satu baris panjang.
- `wrapMode` hanya membungkus bila `width` diatur eksplisit. `elide` juga hanya bekerja bila `width` eksplisit, dan tak bisa dipakai dengan teks kaya.
- `font.pixelSize` menetapkan ukuran dalam piksel, sedangkan `font.pointSize` menetapkan ukuran yang bebas perangkat. Pilih salah satu.
- **Keamanan:** secara bawaan `Text` menebak apakah `text` adalah markup. Bila ia menyimpulkan `StyledText` atau `MarkdownText`, fitur teks kaya aktif, termasuk memuat gambar lewat jaringan. Untuk isi yang dikendalikan pengguna atau tak tepercaya, dokumentasi meminta `textFormat: Text.PlainText` secara eksplisit atau penyaringan tag.

**`Image`:** `source` menentukan berkas, `status` melaporkan `Image.Null`, `Image.Loading`, `Image.Ready`, atau `Image.Error`. Sisanya (`asynchronous`, `sourceSize`, `fillMode`) ada di 4.3.

**Peragaan 1: tiga primitif dalam satu jendela.**

```qml
import QtQuick

Window {
    visible: true; width: 420; height: 260; color: '#1e1e1e'

    Rectangle {
        x: 20; y: 20; width: 120; height: 80
        color: 'goldenrod'; radius: 8
        border.width: 3; border.color: 'white'
    }
    Rectangle {
        x: 160; y: 20; width: 120; height: 80
        gradient: Gradient {
            GradientStop { position: 0.0; color: 'lightsteelblue' }
            GradientStop { position: 1.0; color: 'navy' }
        }
    }
    Rectangle {
        x: 300; y: 20; width: 100; height: 80
        color: 'seagreen'
        topLeftRadius: 24; bottomRightRadius: 24      // Qt 6.7 ke atas
    }
    Text {
        x: 20; y: 120; width: 380
        color: 'white'; font.pixelSize: 16
        wrapMode: Text.WordWrap
        textFormat: Text.PlainText
        text: 'Teks ini lebih panjang daripada lebar item sehingga dibungkus ke baris berikutnya.'
    }
}
```

**Bedah kode:**

- `Window { visible: true; ... color: '#1e1e1e' }`: jendela yang ditampilkan, dengan warna latar heksadesimal. Mengatur `color` jendela lebih efisien daripada menaruh `Rectangle` sebagai latar.
- `color: 'goldenrod'`: warna dapat ditulis sebagai nama warna SVG, `'#rrggbb'`, atau `'#aarrggbb'`.
- `border.width: 3; border.color: 'white'`: sintaks kelompok properti; `border` adalah kelompok, dan `width` serta `color` anggotanya.
- `gradient: Gradient { GradientStop { position: ...; color: ... } }`: gradien terdiri dari titik henti. `position` bernilai 0.0 sampai 1.0 sepanjang gradien (vertikal secara bawaan).
- `topLeftRadius`, `bottomRightRadius`: membulatkan hanya dua sudut. Pada versi Qt di bawah 6.7 properti ini tak dikenal.
- `wrapMode: Text.WordWrap`: membungkus teks pada batas kata. Berlaku karena `width: 380` eksplisit.
- `textFormat: Text.PlainText`: tag dianggap teks biasa, jadi aman untuk isi tak tepercaya.

**Peragaan 2: ukuran implisit dan status (tanpa jendela).** Siapkan berkas gambar kecil. String berikut adalah PNG oranye 16 × 16 lalu periksa dengan `file`.

```bash
echo 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAF0lEQVR4nGP4v5SBJESa6lENoxqGlAYAR8ykEIwdMqUAAAAASUVORK5CYII=' | base64 -d > logo.png
file logo.png        # PNG image data, 16 x 16
```

```qml
import QtQuick

Item {
    Rectangle { id: kotak; color: 'tomato' }                       // tanpa ukuran
    Text { id: t1; text: 'Halo dunia'; font.pixelSize: 20 }
    Text { id: t2; text: 'Halo dunia'; font.pixelSize: 20; width: 40; elide: Text.ElideRight }
    Text { id: t3; text: '<b>tebal</b>' }                          // bawaan: ditebak markup
    Text { id: t4; text: '<b>tebal</b>'; textFormat: Text.PlainText }
    Image { id: hilang; source: 'tidak-ada.png' }
    Image { id: logo; source: 'logo.png' }

    Timer {
        interval: 200; running: true
        onTriggered: {
            console.log('kotak:', kotak.width, kotak.height)                       // 0 0
            console.log('t1 = implisit:', t1.width === t1.implicitWidth)           // true
            console.log('t2:', t2.width, t2.truncated)                             // 40 true
            console.log('t3 lebih sempit:', t3.contentWidth < t4.contentWidth)     // true
            console.log('hilang error:', hilang.status === Image.Error)            // true
            console.log('logo siap:', logo.status === Image.Ready, logo.implicitWidth) // true 16
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml primitif.qml
```

Dugaan: enam baris keluaran seperti di komentar, ditambah satu peringatan bahwa `tidak-ada.png` tak dapat dibuka `[uji]`.

**Bedah kode:**

- `Rectangle { id: kotak; color: 'tomato' }`: tanpa `width` dan `height`, ukurannya 0 × 0, sehingga tak terlihat. Ini penyebab klasik “Rectangle tak muncul”.
- `t1.width === t1.implicitWidth`: karena `width` tak diatur, lebar `Text` sama dengan ukuran yang ia inginkan (`implicitWidth`).
- `width: 40; elide: Text.ElideRight`: lebar eksplisit 40 membuat `elide` bekerja; `truncated` bernilai `true` karena teks dipotong.
- `t3.contentWidth < t4.contentWidth`: `t3` dikira markup dan menampilkan kata `tebal` tebal, sedangkan `t4` menampilkan tag apa adanya, sehingga lebih lebar.
- `Image { source: 'tidak-ada.png' }`: berkas tak ada, `status` menjadi `Image.Error`.
- `logo.implicitWidth`: setelah siap, ukuran implisit `Image` sama dengan ukuran bitmapnya (16).
- `Timer { interval: 200; running: true; onTriggered: ... }`: memberi waktu muat gambar dan tata letak teks sebelum dibaca (3.3).

**Opsi lain, menggambar sesuatu:**

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Persegi, gradien, bingkai | `Rectangle` | Paling murah |
| Bentuk bebas, garis, kurva | `Shape` (`QtQuick.Shapes`) | Fase lanjut |
| Bitmap | `Image` | 4.3 |
| Teks baca-saja | `Text` | Setel `textFormat` bila isi tak tepercaya |
| Teks yang bisa diedit | `TextInput`, `TextEdit` | 4.4 dan fase kontrol |

| Kesalahan | Solusi |
| --- | --- |
| `Rectangle` tak muncul | Beri `width` dan `height`, atau `anchors` |
| `Text` tak membungkus atau tak ter-`elide` | Atur `width` eksplisit |
| Menampilkan teks pengguna dengan `Text` bawaan | Setel `textFormat: Text.PlainText` |
| Mengatur `font.pixelSize` dan `font.pointSize` sekaligus | Pilih salah satu |
| `antialiasing` aktif pada persegi yang bergerak | Matikan saat bergerak, nyalakan saat diam |

**Referensi:** [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html) · [Text](https://doc.qt.io/qt-6/qml-qtquick-text.html) · [Image](https://doc.qt.io/qt-6/qml-qtquick-image.html)

---

### 4.1.3 `visible`, `opacity`, `enabled`

*Menyembunyikan itu mudah. Menyembunyikan dengan benar itu keahlian.*

**Konsep.** Tiga properti ini tampak mirip tetapi mengatur hal yang berbeda: `visible` menentukan apakah item ada di scene, `opacity` menentukan seberapa tembus pandang, dan `enabled` menentukan apakah item menerima input.

| Properti | Tampil | Menerima input | Efek ke anak |
| --- | --- | --- | --- |
| `visible: false` | Tidak | Tidak (sentuh dan mouse berhenti) | Anak ikut tersembunyi |
| `opacity: 0` | Tak tampak | **Tetap menerima** | Opasitas berlaku juga pada anak `[uji]` |
| `enabled: false` | Tetap tampak | Tidak (mouse dan keyboard) `[uji]` | Anak ikut nonaktif `[uji]` |

Dokumentasi menegaskan dua hal: mengubah `opacity` tidak memengaruhi penerimaan input (berbeda dengan `visible` dan `enabled`), dan nilai `visible` tidak berubah hanya karena item keluar layar atau `opacity` menjadi 0. Dengan kata lain, item dengan `opacity: 0` adalah hantu: tak terlihat, tetapi masih menangkap klik.

**Percobaan 1: `visible` diteruskan ke anak (tanpa jendela).**

```qml
import QtQuick

Item {
    id: induk
    Item { id: anakA }
    Item { id: anakB; visible: false }          // sengaja disembunyikan sendiri

    Timer {
        interval: 50; running: true
        onTriggered: {
            induk.visible = false
            console.log(anakA.visible, anakB.visible)   // false false
            induk.visible = true
            console.log(anakA.visible, anakB.visible)   // true false
            Qt.quit()
        }
    }
}
```

Dugaan keluaran: `qml: false false` lalu `qml: true false` `[uji]`. Menyembunyikan induk menyembunyikan semua anak. Saat induk tampil lagi, anak kembali tampil kecuali yang memang disembunyikan sendiri.

**Percobaan 2: siapa yang masih menerima klik.** Jalankan dengan jendela, lalu klik tempat ketiga persegi berada.

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 120

    Rectangle {                                  // A: opacity 0
        x: 10; y: 10; width: 100; height: 100; color: 'tomato'; opacity: 0
        TapHandler { onTapped: console.log('A (opacity 0) tersentuh') }
    }
    Rectangle {                                  // B: visible false
        x: 130; y: 10; width: 100; height: 100; color: 'seagreen'; visible: false
        TapHandler { onTapped: console.log('B (visible false) tersentuh') }
    }
    Rectangle {                                  // C: enabled false
        x: 250; y: 10; width: 100; height: 100; color: 'steelblue'; enabled: false
        TapHandler { onTapped: console.log('C (enabled false) tersentuh') }
    }
}
```

Dugaan: klik area A (yang tak tampak) tetap mencetak log. Klik B tak mencetak apa pun karena item tak ada di scene, dan klik C (tampak, biru) juga tak mencetak apa pun `[uji]`.

**Bedah kode:**

- `TapHandler { onTapped: ... }`: pengintai ketukan yang ditempelkan pada item induknya (4.4). Ia dipakai di sini hanya sebagai penanda apakah item menerima input.
- `opacity: 0`: item tak tampak tetapi tetap berada di scene dan di jalur input.
- `visible: false`: item keluar dari scene sehingga tak menerima input.
- `enabled: false`: item tetap digambar tetapi tak menerima input. Cocok untuk tombol yang terlihat abu-abu.

**Pola yang benar untuk memudarkan lalu menyembunyikan:**

```qml
Rectangle {
    id: panel
    opacity: 0                       // nanti dianimasikan (fase animasi)
    visible: opacity > 0             // saat opacity 0, item berhenti menerima input
}
```

Binding `visible: opacity > 0` menghubungkan keduanya: panel yang sudah sepenuhnya pudar tak lagi menangkap klik. Pola ini dipakai di hampir semua animasi masuk dan keluar.

**Percobaan 3: opasitas grup.** Opasitas diterapkan pada tiap anak secara terpisah. Dengan `layer.enabled`, ia diterapkan pada hasil gabungan.

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 140; color: 'white'

    Item {                                       // tanpa layer
        x: 10; y: 10; width: 160; height: 120; opacity: 0.5
        Rectangle { width: 100; height: 100; color: 'red' }
        Rectangle { x: 40; y: 20; width: 100; height: 100; color: 'blue' }
    }
    Item {                                       // dengan layer
        x: 190; y: 10; width: 160; height: 120; opacity: 0.5
        layer.enabled: true
        Rectangle { width: 100; height: 100; color: 'red' }
        Rectangle { x: 40; y: 20; width: 100; height: 100; color: 'blue' }
    }
}
```

Dugaan: di kiri, bagian merah masih terlihat samar menembus biru pada area tumpang tindih. Di kanan, area itu biru rata karena kedua persegi lebih dulu digabung lalu dipudarkan sekaligus `[uji]`.

**Bedah kode:**

- `opacity: 0.5` pada `Item` wadah: setengah transparan.
- `layer.enabled: true`: item dirender dulu ke tekstur tersendiri, lalu tekstur itu digambar dengan opasitas wadah.
- Biayanya, menurut dokumentasi: scene graph mengalokasikan memori GPU sebesar lebar × tinggi × 4 byte, dan item berlapis tidak dapat dibatch. Banyak item berlapis dapat menimbulkan masalah performa.

**Opsi lain, menyembunyikan sesuatu:**

| Cara | Kapan |
| --- | --- |
| `visible: false` | Item tak diperlukan sekarang dan tak boleh menerima input |
| `opacity` | Animasi pudar masuk dan keluar |
| `enabled: false` | Item tampak tetapi tak dapat dipakai |
| `Loader { active: false }` | Item tak perlu dibuat sama sekali (3.3.5) |
| Menghapus dari pohon (`parent = null`) | Item dipakai lagi nanti (4.1.6) |

| Kesalahan | Solusi |
| --- | --- |
| Menyembunyikan dengan `opacity: 0` lalu heran item masih menangkap klik | Pakai `visible: opacity > 0` atau `visible: false` |
| Memakai `layer.enabled` untuk banyak item | Pakai hanya bila opasitas grup memang diperlukan |
| Mengira `enabled: false` menyembunyikan item | Ia hanya menonaktifkan input |
| Menumpuk item tak terlihat yang tetap diproses | Hapus atau jangan buat (`Loader`) |

**Referensi:** [Item: visible, opacity, enabled](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Qt Quick Scene Graph Default Renderer](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph-renderer.html)

---

### 4.1.4 `clip` dan biayanya

*Memotong itu gratis di benak, mahal di GPU.*

**Konsep.** Dengan `clip: true`, sebuah item memotong gambarnya sendiri dan gambar anak-anaknya ke persegi batasnya. Bawaannya `false`, jadi anak yang meluap tetap terlihat. Dokumentasi memperingatkan bahwa klip dapat memengaruhi performa render.

**Apa yang terjadi di balik layar.** Menurut dokumentasi scene graph, pemotongan umumnya diimplementasikan dengan *stencil buffer*. Bila klipnya persegi sejajar sumbu, renderer dapat memakai *scissor* yang jauh lebih cepat. Bila klip diputar atau bukan persegi, stencil diperlukan. Pengalaman praktik dan diskusi pengembang Qt juga melaporkan bahwa klip dapat menghambat *batching* (penggabungan perintah gambar). Hal ini bisa Anda periksa sendiri di 4.1.7 `[uji]`.

**Peragaan:**

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 160; color: '#202020'

    Rectangle {                                  // tanpa clip: anak meluap
        x: 20; y: 30; width: 120; height: 100; color: '#444'
        Rectangle { x: 80; y: 60; width: 100; height: 80; color: 'tomato' }
    }
    Rectangle {                                  // dengan clip: anak terpotong
        x: 200; y: 30; width: 120; height: 100; color: '#444'
        clip: true
        Rectangle { x: 80; y: 60; width: 100; height: 80; color: 'tomato' }
    }
}
```

```bash
qml klip.qml
QSG_VISUALIZE=clip qml klip.qml
```

**Bedah kode:**

- Persegi pertama: anak merah menjorok keluar dari induk abu-abu dan tetap tergambar penuh.
- Persegi kedua: `clip: true` memotong anak di batas induk, sehingga hanya bagian di dalam yang terlihat.
- `QSG_VISUALIZE=clip`: variabel lingkungan yang membuat scene graph menandai area berklip dengan warna merah di atas scene (4.1.7). Perilaku persisnya `[uji]`.

**Kapan `clip` memang diperlukan:**

- `Image` dengan `fillMode: Image.PreserveAspectCrop`, agar bagian gambar di luar batas tak tergambar (4.3).
- Item yang kontennya bisa lebih besar daripada kerangka tetap, misalnya area yang bisa digulir.

**Opsi lain, mencapai efek serupa tanpa `clip`:**

| Cara | Catatan |
| --- | --- |
| Atur ukuran agar konten tak meluap | Paling murah, dan sering cukup |
| `elide` pada `Text` | Memotong teks tanpa klip |
| `sourceSize` dan `fillMode` pada `Image` | Hindari pemotongan di tingkat gambar |
| `layer.enabled` + efek penutup | Pemotongan berbentuk bebas; lebih mahal (4.1.3) |

| Kesalahan | Solusi |
| --- | --- |
| `clip: true` di semua item | Pakai hanya di tempat yang benar-benar perlu |
| Memutar item berklip | Klip berputar memerlukan stencil; hindari bila bisa |
| Mengira `clip` hanya memotong anak | Ia juga memotong gambar item itu sendiri |

**Referensi:** [Item: clip](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Qt Quick Scene Graph Default Renderer](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph-renderer.html) · [QSGClipNode](https://doc.qt.io/qt-6/qsgclipnode.html)

---

### 4.1.5 `Window` dan item akar

*Tak ada gambar tanpa jendela, dan tak ada jendela tanpa akar.*

**Konsep.** `Window` membuat jendela tingkat atas untuk scene Qt Quick. Fakta dari dokumentasi 6.12:

- `import QtQuick` sudah cukup. Tanpa impor itu Anda mendapat lingkungan QML tanpa akses ke fitur sistem jendela.
- Ia diinstansiasi sebagai `QQuickWindow` di C++, dan `ApplicationWindow` (Qt Quick Controls) mewarisinya.
- `visible` bawaannya `false`, jadi `visible: true` wajib bila jendela ingin ditampilkan.
- `contentItem` adalah akar tak terlihat dari scene. Item yang Anda taruh di properti default `data` menjadi anak `contentItem`, dan `parent`-nya adalah `contentItem`. Objek jenis lain di `data` menjadi resource.
- `color` jendela lebih efisien daripada memasang `Rectangle` sebagai latar.
- Seperti `Text`, `Window` mendukung palet tetapi tidak memakainya secara bawaan.
- `Window` yang dideklarasikan di dalam `Window` lain menjadi jendela *transient* (anak dari jendela luar).
- Atribut terlampir `Window` dapat dipasang pada `Item` mana pun, dan memberi ukuran serta status aktif jendela tempat item itu berada.

**Peragaan:**

```qml
import QtQuick

Window {
    id: jendela
    visible: true; width: 360; height: 240
    color: '#202020'

    Item {
        id: akar
        anchors.fill: parent
        Component.onCompleted: {
            console.log(parent === jendela.contentItem)       // true
            console.log(Window.window === jendela)                // true
            console.log(Window.width, Window.height)              // 360 240
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml jendela.qml
```

Dugaan keluaran: `qml: true`, `qml: true`, `qml: 360 240` `[uji]` (terutama `Window.window`).

**Bedah kode:**

- `Window { id: jendela; visible: true; ... }`: jendela yang tampil, dengan `id` agar bisa dirujuk.
- `Item { id: akar; anchors.fill: parent }`: item akar. `parent` di sini adalah `contentItem` milik jendela, jadi item mengisi seluruh isi jendela.
- `parent === jendela.contentItem`: membuktikan bahwa induk item di dalam `Window` adalah `contentItem`, bukan `Window` itu sendiri.
- `Window.window`, `Window.width`, `Window.height`: atribut terlampir. Ia dibaca dari item yang berada di dalam jendela (3.4.4 membahas mengapa atribut terlampir dibaca lewat `id` atau di scope item sendiri).

**Mengapa `Window` bukan `Item`.** `Window` adalah jendela milik sistem operasi: ia punya judul, bingkai, posisi di layar, dan interaksi dengan window manager. `Item` adalah simpul di dalam pohon scene yang berada di dalam jendela. `Window` tidak punya induk `Item`, tetapi ia memiliki satu akar item (`contentItem`) tempat pohon Anda digantung.

```
  sistem operasi / window manager
        |
   +----+-----------------+
   |  Window (QQuickWindow)|   judul, ukuran, posisi layar, fokus jendela
   |    contentItem        |   akar pohon Item
   |      +-- Item ...     |
   +-----------------------+
```

**Opsi lain, akar aplikasi:**

| Akar | Siapa yang membuat jendela | Kapan |
| --- | --- | --- |
| `Window` | Anda, di QML | Eksperimen dan aplikasi sederhana |
| `ApplicationWindow` | Anda, di QML (butuh `QtQuick.Controls`) | Aplikasi dengan header, footer, dan menu (fase kontrol) |
| `Item` | Host: alat `qml` membungkusnya otomatis `[uji]`, atau `QQuickView` di C++ | Komponen yang dipakai ulang; C++ di Fase 10 |

| Kesalahan | Solusi |
| --- | --- |
| Jendela tak muncul | Setel `visible: true` |
| Memasang `Rectangle` sebagai latar jendela | Setel `color` pada `Window` |
| Menganggap `parent` item akar adalah `Window` | Itu `contentItem`. Rujuk jendela lewat `id` atau atribut terlampir |
| Lupa `import QtQuick` | Tanpa itu `Window` tak tersedia |

**Referensi:** [Window](https://doc.qt.io/qt-6/qml-qtquick-window.html) · [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html)

---

### 4.1.6 `parent`, `children`, `data`, `resources` `[TAMBAHAN]`

*Pohon yang Anda pahami bisa Anda rapikan, dan pohon yang rapi jarang mengejutkan Anda.*

**Konsep.** Hierarki bukan sekadar cara menulis kode. Ia terbaca dan bisa diubah lewat properti `Item`:

- `parent`: induk visual. Mengubahnya memindahkan item ke tempat lain di pohon.
- `children`: daftar anak yang berupa `Item`.
- `data`: properti default, yaitu tempat semua yang Anda tulis di dalam badan item ditampung.
- `resources`: tempat objek yang bukan `Item` (misalnya `Timer` atau `QtObject`) yang ditulis di dalam item.
- Metode bantu: `childAt(x, y)`, `mapToItem`, `mapFromItem`, dan `mapToGlobal`.

**Peragaan 1: tiga daftar.**

```qml
import QtQuick

Item {
    id: root
    Item { id: a }
    Timer { id: jam }
    QtObject { id: bukanItem }

    Component.onCompleted: {
        console.log('data:', root.data.length)             // 3
        console.log('children:', root.children.length)     // 1
        console.log('resources:', root.resources.length)   // 2
        a.parent = null                                     // lepaskan dari hierarki
        console.log('children sesudah:', root.children.length)  // 0
        Qt.quit()
    }
}
```

Dugaan keluaran: `3`, `1`, `2`, lalu `0` `[uji]`.

**Bedah kode:**

- `Item { id: a }`: sebuah `Item`, jadi masuk ke `children`.
- `Timer` dan `QtObject`: bukan `Item`, jadi masuk ke `resources`, tidak ke `children`.
- `root.data.length`: `data` mencakup semuanya (3), karena ia properti default tempat semua isi badan item dikumpulkan.
- `a.parent = null`: menugaskan `parent` ke `null` melepas `a` dari pohon visual, sehingga `children` menjadi kosong.

**Peragaan 2: memindahkan item dan koordinatnya.**

```qml
import QtQuick

Item {
    id: root
    Item { id: kiri;  x: 0;   width: 100; height: 100 }
    Item { id: kanan; x: 200; width: 100; height: 100 }
    Item { id: titik; x: 10; y: 10 }                   // anak root

    Component.onCompleted: {
        console.log(titik.mapToItem(root, 0, 0).x)              // 10
        titik.parent = kanan                                     // pindah ke kanan
        console.log(titik.x, titik.mapToItem(root, 0, 0).x)      // 10 210
        console.log(root.childAt(50, 50) === kiri)               // true
        Qt.quit()
    }
}
```

Dugaan: `10`, lalu `10 210`, lalu `true` `[uji]`.

**Bedah kode:**

- `titik.parent = kanan`: nilai `x` tetap 10, tetapi kini diukur dari `kanan`. Posisi di `root` berubah dari 10 menjadi 210.
- `titik.mapToItem(root, 0, 0).x`: konversi koordinat lokal `titik` ke koordinat `root`.
- `root.childAt(50, 50)`: mengembalikan anak teratas yang memuat titik (50, 50). Di sini `kiri`.
- Pada item yang dipindahkan, urutan gambar ikut berubah: ia menjadi anak terakhir induk barunya, sehingga digambar paling atas di antara saudaranya `[uji]`.

**Hal yang perlu diingat:**

- `parent` adalah induk **visual**. Kepemilikan objek (siapa yang menghancurkannya) adalah hal berbeda, dan melepas `parent` tidak otomatis memindahkan kepemilikan `[uji]` (3.3.3).
- `data` dan `resources` tidak untuk dimanipulasi langsung dalam pemakaian sehari-hari. Cukup baca untuk memahami apa yang ada di pohon.

**Opsi lain, memindahkan atau membuat item di tempat tertentu:**

| Cara | Kapan |
| --- | --- |
| `item.parent = lain` | Pemindahan langsung dari JS |
| `Component.createObject(parent)` | Membuat item baru di induk tertentu (3.3) |
| `Loader` | Memuat dan membuang item sesuai kebutuhan (3.3.5) |
| `ParentChange` dalam `State` | Pemindahan yang dikaitkan dengan state (fase animasi dan state) |

| Kesalahan | Solusi |
| --- | --- |
| Mengira `x` dan `y` ikut berubah saat dipindah | Nilainya sama, tetapi acuannya induk baru. Pakai `mapToItem` untuk mempertahankan posisi visual |
| Mencari `Timer` di `children` | Ada di `resources` |
| Menganggap `parent = null` menghancurkan item | Hanya melepasnya dari pohon. Pakai `destroy()` (3.3.3) |

**Referensi:** [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Dynamic QML Object Creation](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html)

---

### 4.1.7 Dari item ke piksel: scene graph dan alat diagnosis `[TAMBAHAN]`

*Ukur sebelum menebak.*

**Konsep.** Semua item visual Qt Quick digambar lewat *scene graph*, tumpukan render tingkat rendah yang terikat pada API grafis akselerasi seperti OpenGL, Vulkan, Metal, dan Direct 3D. Pohon item Anda diterjemahkan menjadi pohon node render. Item yang punya konten visual menandai dirinya agar dirender scene graph. `Item` biasa tidak punya konten sendiri, jadi ia ringan, tetapi tetap ikut diproses (properti, binding, input).

```
 Pohon QML (item)           Scene graph (node)             GPU
 Window
  +-- Item (wadah) ------>  (tanpa konten sendiri)
  |     +-- Rectangle ---->  node geometri + material  \
  |     +-- Text -------->   node teks (glyph)          +--> batch --> draw call
  +-- Image ------------>   node tekstur              /
```

**Empat sumber biaya yang sudah Anda temui:**

1. Banyak item, termasuk yang tak terlihat tetapi tetap diproses (4.1.1, 4.1.3).
2. `clip` (4.1.4).
3. `layer.enabled` (4.1.3).
4. *Overdraw*: piksel yang digambar berkali-kali karena item bertumpuk.

**Alat: variabel lingkungan.** Pasang sebelum menjalankan `qml`.

| Variabel | Nilai | Fungsi |
| --- | --- | --- |
| `QSG_VISUALIZE` | `clip` | Menandai area berklip dengan merah di atas scene |
| `QSG_VISUALIZE` | `overdraw` | Menampilkan item secara tiga dimensi agar tumpukan dan overdraw terlihat |
| `QSG_VISUALIZE` | `batches` | Mewarnai batch. Sedikit warna unik berarti batching baik |
| `QSG_VISUALIZE` | `changes` | Mengedipkan overlay saat bagian scene graph berubah |
| `QSG_RENDER_TIMING` | `1` | Mencetak waktu render ke log |

```bash
QSG_VISUALIZE=overdraw qml tumpuk.qml
QSG_VISUALIZE=batches  qml tumpuk.qml
QSG_VISUALIZE=clip     qml klip.qml
QSG_RENDER_TIMING=1    qml tumpuk.qml
```

Mode visualisasi memerlukan jendela sungguhan di sesi grafis Anda, bukan `offscreen` `[uji]`. Di luar terminal, alat inspeksi eksternal *GammaRay* (KDAB) dapat menampilkan pohon item dan scene graph secara langsung.

**Aturan praktis:**

- Anggap pohon item sebagai anggaran: setiap item yang tak perlu adalah biaya tanpa hasil.
- Sembunyikan dengan `visible: false`, bukan `opacity: 0`, dan hindari membuat item yang belum diperlukan (`Loader`).
- Pakai `clip` dan `layer.enabled` hanya bila tak ada cara lain.
- Periksa dulu dengan `QSG_VISUALIZE` sebelum mengoptimalkan. Penyebab lambat sering bukan yang Anda duga.

| Kesalahan | Solusi |
| --- | --- |
| Mengoptimalkan tanpa mengukur | Ukur dengan `QSG_VISUALIZE` dan `QSG_RENDER_TIMING` |
| Menjalankan visualisasi dengan `offscreen` lalu tak melihat apa pun | Jalankan di sesi grafis nyata |
| Menyalahkan `Text` atau `Image` padahal masalahnya jumlah item | Hitung item, periksa `batches` |

**Referensi:** [Qt Quick Scene Graph Default Renderer](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph-renderer.html) · [Qt Quick Performance Considerations And Suggestions](https://doc.qt.io/qt-6/qtquick-performance.html) · [QQuickItem](https://doc.qt.io/qt-6/qquickitem.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** susun tiga persegi bertumpuk dengan `z` berbeda dan ubah urutannya hanya lewat `z`.

```qml
import QtQuick

Window {
    visible: true; width: 300; height: 220; color: '#202020'

    Rectangle { id: a; x: 20;  y: 20; width: 120; height: 120; color: 'tomato';    z: 0 }
    Rectangle { id: b; x: 60;  y: 50; width: 120; height: 120; color: 'seagreen';  z: 0 }
    Rectangle { id: c; x: 100; y: 80; width: 120; height: 120; color: 'steelblue'; z: 0 }
}
```

1. Jalankan apa adanya. Dugaan: `c` di atas, `a` di bawah (urutan deklarasi).
2. Ubah `a` menjadi `z: 2`. Dugaan: `a` kini di atas semuanya.
3. Ubah `b` menjadi `z: -1` dan `a` kembali `z: 0`. Dugaan: `b` kini di bawah `a` dan `c`.

**Kunci:** `z` yang sama digambar menurut urutan deklarasi, jadi item yang ditulis belakangan berada di atas. `z` lebih tinggi menang atas `z` lebih rendah di antara saudara. Perhatikan bahwa Anda tak mengubah urutan baris kode sama sekali.

**Percobaan tambahan: `z` negatif terhadap induk.**

```qml
Rectangle {
    width: 100; height: 100; color: 'red'
    Rectangle { z: -1; x: 50; y: 50; width: 100; height: 100; color: 'blue' }
}
```

Anak berwarna biru digambar di bawah isi induknya (merah), karena `z` negatif menempatkan item di bawah isi induk. Pada `z` bawaan (0), anak berada di atas induknya.

**Cek pemahaman (dari kurikulum):**

- *Apa bedanya `Item` dan `Rectangle`?* `Item` tak menggambar apa pun dan dipakai untuk mengelompokkan. `Rectangle` adalah `Item` yang juga menggambar warna, gradien, dan bingkai.
- *Mengapa `Window` bukan `Item`?* `Window` adalah jendela milik sistem operasi dengan judul, bingkai, dan posisi layar. `Item` adalah simpul di dalam pohon scene. `Window` memiliki akar item (`contentItem`), bukan menjadi item.

**Pertanyaan tambahan:**

1. *Apa beda `visible: false` dan `opacity: 0` untuk input?* `visible: false` menghentikan penerimaan input, sedangkan `opacity: 0` tidak.
2. *Mengapa `Rectangle` tanpa `width` dan `height` tak terlihat?* Ukuran bawaannya 0 × 0.
3. *Kapan `wrapMode: Text.WordWrap` tak membungkus?* Saat `width` tak diatur eksplisit.
4. *Mengapa `textFormat: Text.PlainText` penting untuk isi tak tepercaya?* Karena `Text` bawaan menebak markup, dan mode kaya dapat memuat gambar lewat jaringan.
5. *Apa `parent` dari item di dalam `Window`?* `contentItem`, bukan `Window`.
6. *Apa biaya `layer.enabled` dan `clip`?* `layer.enabled` memakai memori GPU sebesar lebar × tinggi × 4 dan tak bisa dibatch. `clip` menambah pekerjaan render dan dapat memengaruhi batching.
7. *Item `opacity: 0` masih menangkap klik. Bagaimana memperbaikinya?* Tambahkan `visible: opacity > 0`.

**Tantangan:**

- Bangun pohon `Window` → akar → tiga panel, dan bandingkan `QSG_VISUALIZE=overdraw` sebelum dan sesudah mengurangi tumpukan item.
- Tampilkan string `'<b>tebal</b>'` dengan `Text` bawaan dan dengan `textFormat: Text.PlainText`, lalu catat bedanya.

---

## F. Glosarium Modul 4.1

| Istilah | Arti |
| --- | --- |
| Item | Tipe dasar semua item visual; tak menggambar sendiri |
| Hierarki visual | Pohon induk-anak yang menentukan koordinat, urutan gambar, dan visibilitas |
| `parent` | Induk visual sebuah item |
| `children` | Daftar anak yang berupa `Item` |
| `data` | Properti default yang menampung seluruh isi badan item |
| `resources` | Daftar objek bukan-Item yang berada di dalam item |
| Item akar | Item paling atas dalam sebuah pohon |
| `contentItem` | Akar tak terlihat dari scene sebuah `Window` |
| Primitif visual | Item yang menggambar sesuatu: `Rectangle`, `Text`, `Image` |
| `visible` | Apakah item berada di scene |
| `opacity` | Tingkat transparansi (0.0 sampai 1.0) |
| `enabled` | Apakah item menerima input |
| `clip` | Memotong gambar item dan anak ke persegi batasnya |
| `z` | Urutan tumpuk antar saudara |
| `implicitWidth` / `implicitHeight` | Ukuran yang diinginkan item sendiri |
| `textFormat` | Cara `Text` menafsirkan isinya: `AutoText`, `PlainText`, `StyledText`, `RichText`, `MarkdownText` |
| Scene graph | Tumpukan render Qt Quick yang menerjemahkan item menjadi node dan batch |
| Overdraw | Piksel yang digambar lebih dari sekali |
| Batching | Penggabungan perintah gambar menjadi lebih sedikit draw call |
| Layer | Item yang dirender ke tekstur tersendiri (`layer.enabled`) |
| Atribut terlampir | Properti yang dipasang tipe lain, misalnya `Window.width` |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
| --- | --- |
| **3.1** Property Binding | Geometri sering diikat (`width: parent.width`); ukuran implisit memicu binding loop (misalnya `Text` dengan `wrapMode` dan `width: contentWidth`) |
| **3.3** Lifecycle | Ukuran dan tata letak belum final di `onCompleted`; `Loader` menghindari pembuatan item; `Qt.callLater` menunda pembacaan |
| **3.4** Scope dan konteks | `parent` dan `id`; atribut terlampir dibaca lewat `id` atau scope item sendiri; `parent` bukan induk lewat scope |
| **4.2** Geometri dan anchors | Melanjutkan: posisi relatif, `implicitWidth`, dan anchors |
| **4.3** Resource | Mendalami `Image`, `sourceSize`, dan CMake; **4.3.6 memerlukan Modul 10.1** |
| **4.4** Input dasar | Handler yang ditempelkan pada item; fokus; urutan input mengikuti pohon |
| **10.1** C++ dan CMake | Jalur paralel; prasyarat untuk 4.3.6 |
| **Keamanan** | `Text` tak tepercaya wajib `PlainText`; pohon item kecil lebih mudah diaudit |

**Penutup Modul 4.1:** Anda kini bisa membaca layar sebagai pohon objek, menggambar tiga primitif, mengatur visibilitas dengan benar, dan memeriksa biaya render dengan alat bawaan Qt. Modul berikutnya adalah 4.2 — Geometri, Anchors, dan Z-Order.

---

**Catatan tautan:** Pada halaman Rectangle (6.12). Fakta tentang `Window`, `Item`, `Text`, dan variabel `QSG_VISUALIZE` telah dibaca lewat hasil pencarian dari beberapa versi Qt (termasuk dokumentasi PySide dan Qt untuk MCU, yang kata-katanya diwarisi dari Qt Quick), jadi tandai `[uji]` pada versi Anda. Halaman Image, Positioning, Qt Quick Scene Graph Default Renderer, Qt Quick Performance, QSGClipNode, QQuickItem, dan Dynamic QML Object Creation tidak dibuka satu per satu. Bila ada yang tidak terbuka, lakukan pendalaman mandiri.

# Fase 4 · Modul 4.2 — Geometri, Anchors, dan Z-Order

*Melanjutkan Modul 4.1.*

<!-- Saya membaca bagian Modul 4.2 dari kurikulum Fase 4 yang Anda kirim, lalu mengaudit isinya terhadap dokumentasi Qt 6.12 (Positioning with Anchors, Item) dan kode sumber anchors Qt. Seperti sebelumnya, saya tidak menjalankan kode ini pada Qt, jadi bagian bertanda `[uji]` perlu Anda buktikan sendiri. -->

---

## A. Audit singkat

**Terverifikasi:**

- Setiap item punya tujuh garis jangkar tak terlihat: `left`, `horizontalCenter`, `right`, `top`, `verticalCenter`, `baseline`, dan `bottom`. Baseline adalah garis tempat teks duduk, dan untuk item tanpa teks sama dengan `top`.
- Margin adalah ruang kosong di sisi luar jangkar, dan hanya berlaku bila item benar-benar berjangkar pada sisi itu. Offset berlaku untuk garis tengah dan baseline.
- Jangkar hanya boleh menuju induk langsung atau saudara, demi performa.
- `anchors.fill` setara dengan empat jangkar, dan `anchors.centerIn` setara dengan dua jangkar tengah.
- Contoh kurikulum benar: kotak hijau berjarak 8 piksel di kanan kotak merah dan sejajar secara vertikal.
- `implicitWidth` dan `implicitHeight` adalah ukuran alami item bila `width` atau `height` tak ditentukan.
- Aturan `z` yang dibahas di 4.1 tetap berlaku.

**Perlu dikoreksi atau dilengkapi:**

1. **“`x` diabaikan” kurang tepat.** Dokumentasi menyebut hasilnya *tak terdefinisi*, bukan diabaikan. Hal yang sama berlaku untuk jangkar kiri dan kanan yang dikombinasikan dengan `width`, untuk `anchors.fill` yang dikombinasikan dengan `width` atau `height`, dan untuk item yang ditata positioner seperti `Row` atau `Grid` yang mengatur `x` dan `y`. Dibenahi di 4.2.4.
2. **“Binding loop lewat anchors” perlu contoh dan nama peringatannya.** Qt melapor `Possible anchor loop detected on ...` (untuk jangkar horizontal, `fill`, dan `centerIn`). Masuk 4.2.4.
3. **Mengubah jangkar saat berjalan punya jebakan urutan** yang tak ada di kurikulum: lepas jangkar lama (`undefined`) dulu, baru pasang yang baru. Jangan mengubah jangkar lewat binding kondisional. Untuk state, pakai `AnchorChanges`. Masuk 4.2.4.
4. **`anchors.alignWhenCentered`** (bawaan `true`) membulatkan posisi tengah ke piksel utuh. Terkait ketajaman gambar dan getaran saat rotasi. Masuk 4.2.3 dan 4.2.6.
5. **Z-order hanya disebut sekilas.** Fakta kuncinya: `z` hanya membandingkan item bersaudara, jadi anak tak bisa melampaui saudara induknya. Telah ditambahkan percobaan dan catatan keamanan soal overlay di 4.2.5.
6. **Transformasi (`rotation`, `scale`, `transformOrigin`) tak dibahas**, padahal ikut menentukan posisi akhir item. TAMBAHAN 4.2.6.
7. **Memilih mekanisme tata letak dan men-debug geometri tak dibahas.** TAMBAHAN 4.2.7. Positioner dan Layouts hanya dikenalkan namanya karena bukan bagian Fase 4.
8. **Sinkron dengan 4.1:** ukuran bawaan 0 × 0 adalah akar keluhan “Rectangle tak muncul”. 4.2.2 menjelaskan mengapa komponen perlu menyatakan ukuran alaminya.

**TAMBAHAN:**

- **4.2.6** Transformasi dan piksel.
- **4.2.7** Memilih mekanisme tata letak dan men-debug geometri.

---

## B. Daftar isi Modul 4.2 (diperbarui)

- **4.2.1** Koordinat dan ukuran
- **4.2.2** `implicitWidth` dan `implicitHeight` `[diperluas]`
- **4.2.3** Anchors dan margin `[diperluas]`
- **4.2.4** Aturan anchors (hanya ke induk atau saudara) `[diperluas]`
- **4.2.5** `z` dan urutan gambar `[diperluas]`
- **4.2.6** Transformasi dan piksel `[TAMBAHAN]`
- **4.2.7** Memilih mekanisme tata letak dan men-debug geometri `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 4.2.1 → 4.2.2 → 4.2.3 → 4.2.4 → 4.2.5 → 4.2.6 → 4.2.7.

---

## C. Peta besar

```
               horizontalCenter
  left               |               right
   |                 |                 |
   v                 v                 v
   +-----------------+-----------------+   <- top
   |                                   |
   +- - - - - - - - -+- - - - - - - - -+   <- verticalCenter
   |                                   |
   +-----------------+-----------------+   <- bottom

   baseline = garis tempat teks duduk (tanpa teks: sama dengan top)
```

```
 Dua cara menempatkan item
   alamat mutlak :  x: 20; y: 40; width: 100        <- koordinat tetap
   janji relatif :  anchors.left: kotak.right       <- ikut bergerak bersama tetangga
   JANGAN campur keduanya pada sumbu yang sama (hasil tak terdefinisi)
```

**Filosofinya:** koordinat adalah alamat mutlak, anchors adalah janji relatif. Alamat mutlak cocok untuk hal yang tak pernah bergerak. Janji relatif bertahan saat ukuran jendela, font, atau isi berubah, dan karena itu hampir semua tata letak yang sehat dibangun dari janji, bukan dari angka.

**Cara menjalankan contoh:** sama seperti 4.1. Berkas visual: `qml nama.qml`. Hanya log: `QT_QPA_PLATFORM=offscreen qml nama.qml`.

---

## D. Materi

### 4.2.1 Koordinat dan ukuran

*Setiap piksel punya alamat. Pelajari sistem alamatnya, dan tata letak berhenti terasa gaib.*

**Konsep.** Posisi dan ukuran sebuah item ditentukan empat properti: `x`, `y`, `width`, dan `height`. Semuanya bertipe `real`, jadi boleh pecahan. Titik asal (0, 0) adalah sudut kiri atas **induk**: `x` bertambah ke kanan dan `y` bertambah ke bawah. `childrenRect` melaporkan posisi dan ukuran gabungan semua anak, dalam koordinat lokal item.

**Peragaan:**

```qml
import QtQuick

Item {
    id: root
    width: 200; height: 100

    Rectangle { id: a; x: 10;    y: 20; width: 50;    height: 30; color: 'red' }
    Rectangle { id: b; x: 100.5; y: 20; width: 50.25; height: 30; color: 'blue' }

    Component.onCompleted: {
        console.log(a.x, a.y, a.width, a.height)                    // 10 20 50 30
        console.log(b.x, b.width)                                   // 100.5 50.25
        const r = root.childrenRect
        console.log(r.x, r.y, r.width, r.height)                    // 10 20 140.75 30
        console.log(a.mapToItem(root, 0, 0).x, a.x + a.width)       // 10 60
        Qt.quit()
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml koordinat.qml
```

Dugaan keluaran: `10 20 50 30`, `100.5 50.25`, `10 20 140.75 30`, lalu `10 60` `[uji]`.

**Bedah kode:**

- `Item { width: 200; height: 100 }`: akar dengan ukuran eksplisit.
- `Rectangle { id: a; x: 10; y: 20; width: 50; height: 30 }`: persegi yang sudut kiri atasnya berada di (10, 20) dari sudut kiri atas `root`.
- `x: 100.5` dan `width: 50.25`: nilai pecahan sah. Tepi yang jatuh di tengah piksel dapat tampak kabur (4.2.6).
- `root.childrenRect`: persegi pembatas semua anak. Tepi kiri terkecil adalah 10 (milik `a`), tepi kanan terbesar adalah 100.5 + 50.25 = 150.75, sehingga lebarnya 140.75. Tepi atas 20 dan tinggi 30.
- `a.mapToItem(root, 0, 0).x`: mengubah titik (0, 0) di dalam `a` menjadi koordinat di `root`, yaitu 10.
- `a.x + a.width`: tepi kanan `a` di koordinat induknya, 60.

```
  root (0,0)
  +-----------------------------------------------+
  |  a (10,20)               b (100.5,20)          |
  |  +----------+            +----------------+    |
  |  |  50 x 30 |            | 50.25 x 30     |    |
  |  +----------+            +----------------+    |
  +-----------------------------------------------+
   childrenRect: x=10 y=20 lebar=140.75 tinggi=30
```

**Hal yang perlu diingat:**

- Satuannya piksel logis. Pada layar beresolusi tinggi Qt memetakannya ke piksel fisik lewat rasio piksel perangkat, sehingga angka yang sama tampak sama besar di layar yang berbeda `[uji]`.
- Koordinat anak selalu relatif ke induk (4.1.1).
- `childrenRect` berguna untuk membuat wadah yang mengikuti isinya. Hati-hati dengan binding loop bila anak ikut bergantung pada ukuran wadah.

| Kesalahan | Solusi |
| --- | --- |
| Mengira `x` dan `y` anak diukur dari jendela | Selalu relatif ke `parent`. Pakai `mapToItem` untuk konversi |
| Memakai koordinat pecahan lalu heran tepi tampak kabur | Bulatkan dengan `Math.round` bila perlu ketajaman (4.2.6) |
| Membuat `width: childrenRect.width` sementara anak bergantung pada `width` wadah | Binding loop. Putus salah satu arah |

**Referensi:** [Item: x, y, width, height, childrenRect](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Important Concepts In Qt Quick: Positioning](https://doc.qt.io/qt-6/qtquick-positioning-topic.html)

---

### 4.2.2 `implicitWidth` dan `implicitHeight`

*Komponen yang baik tahu ukuran idealnya sendiri, dan membiarkan pemakainya menimpa.*

**Konsep.** `implicitWidth` dan `implicitHeight` adalah ukuran alami sebuah item bila `width` atau `height` tak ditentukan. Bagi kebanyakan item nilai bawaannya 0 × 0 (itu sebabnya `Rectangle` tanpa ukuran tak tampak). Beberapa item punya ukuran alami bawaan yang tak dapat ditimpa, misalnya `Image` dan `Text`. Menyatakan ukuran alami berguna saat Anda membuat komponen yang punya ukuran pilihan berdasarkan isinya.

Ini adalah kontrak: komponen berkata “bila tak diminta lain, saya sebesar ini”, dan pemakai bebas menimpa `width` atau `height` kapan pun.

**Peragaan:** komponen sebaris (*inline component*) agar semuanya cukup dalam satu berkas.

```qml
import QtQuick

Item {
    component Kartu: Item {
        id: root
        property alias judul: teks.text
        property int padding: 12

        implicitWidth: teks.implicitWidth + 2 * padding
        implicitHeight: teks.implicitHeight + 2 * padding

        Rectangle { anchors.fill: parent; color: 'steelblue'; radius: 6 }
        Text { id: teks; anchors.centerIn: parent; color: 'white' }
    }

    Kartu { id: k1; judul: 'Halo' }                  // ukuran mengikuti isi
    Kartu { id: k2; judul: 'Halo'; width: 200 }      // lebar ditimpa, tinggi tetap alami

    Timer {
        interval: 100; running: true
        onTriggered: {
            console.log(k1.width === k1.implicitWidth, k1.height === k1.implicitHeight)   // true true
            console.log(k2.width, k2.height === k2.implicitHeight)                        // 200 true
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml kartu.qml
```

Dugaan keluaran: `qml: true true` lalu `qml: 200 true` `[uji]`.

**Bedah kode:**

- `component Kartu: Item { ... }`: komponen sebaris. Sintaksnya `component NamaTipe: TipeDasar { ... }`. Nama tipe wajib berawalan huruf besar.
- `property alias judul: teks.text`: `judul` menjadi pintu ke properti `text` milik `Text` di dalam komponen (3.4.2).
- `implicitWidth: teks.implicitWidth + 2 * padding`: ukuran alami kartu adalah ukuran alami teks ditambah bantalan di kedua sisi. Karena memakai binding, ia ikut berubah saat teks atau `padding` berubah.
- `Rectangle { anchors.fill: parent }`: latar yang selalu menutupi seluruh kartu, berapa pun ukurannya.
- `Text { anchors.centerIn: parent }`: teks selalu di tengah.
- `Kartu { judul: 'Halo' }`: tanpa `width` dan `height` eksplisit, ukuran kartu sama dengan ukuran alaminya.
- `Kartu { width: 200 }`: hanya lebar yang ditimpa. Tinggi tetap mengikuti ukuran alami.

```
 Kartu k1 (alami)             Kartu k2 (width: 200)
 +--------------+             +---------------------------+
 |    Halo      |             |           Halo            |
 +--------------+             +---------------------------+
 tinggi sama: implicitHeight dari isi
```

**Hal yang perlu diingat:**

- Ukuran alami `Text` dapat bergantung pada `width`-nya bila `wrapMode` diaktifkan, sehingga memakai `width: contentWidth` pada teks yang membungkus berisiko binding loop.
- Komponen yang dibuat untuk dipakai ulang sebaiknya selalu menyatakan `implicitWidth` dan `implicitHeight`. Tanpa itu pemakainya harus menebak ukuran.

**Opsi lain, memberi ukuran pada komponen:**

| Cara | Kapan |
| --- | --- |
| `implicitWidth` dan `implicitHeight` dari isi | Komponen yang dipakai ulang |
| `width` dan `height` literal | Item dengan ukuran tetap |
| `width: parent.width` (binding) | Mengikuti induk, tetapi bukan janji relatif sebaik anchors |
| `anchors.fill: parent` | Mengisi induk sepenuhnya (4.2.3) |

| Kesalahan | Solusi |
| --- | --- |
| Komponen tanpa ukuran alami | Nyatakan `implicitWidth` dan `implicitHeight` |
| Menetapkan `width` di dalam komponen padahal pemakai ingin menimpa | Pakai `implicitWidth` agar pemakai bebas menimpa |
| `width: contentWidth` pada `Text` yang membungkus | Putus siklus: atur `width` dari luar, bukan dari `contentWidth` |

**Referensi:** [Item: implicitWidth, implicitHeight](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Defining Object Types through QML Documents](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html)



> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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

