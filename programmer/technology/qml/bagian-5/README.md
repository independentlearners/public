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
5. **Z-order hanya disebut sekilas.** Fakta kuncinya: `z` hanya membandingkan item bersaudara, jadi anak tak bisa melampaui saudara induknya. Saya tambahkan percobaan dan catatan keamanan soal overlay di 4.2.5.
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

---

### 4.2.3 Anchors dan margin

*Janji relatif adalah cara membuat tata letak yang tak rapuh.*

**Konsep.** Setiap item punya tujuh garis jangkar. Anda mengikat sebuah garis milik item ini ke garis milik item lain, dan mesin menjaga janji itu setiap kali sesuatu berubah. Dua jangkar pada sumbu yang sama (misalnya `left` dan `right`) sekaligus menentukan ukuran item.

| Properti | Arti |
| --- | --- |
| `anchors.left`, `right`, `top`, `bottom` | Mengikat tepi item ke garis item lain |
| `anchors.horizontalCenter`, `verticalCenter` | Mengikat garis tengah |
| `anchors.baseline` | Mengikat garis dasar teks |
| `anchors.fill` | Setara empat jangkar ke tepi item target |
| `anchors.centerIn` | Setara dua jangkar tengah ke item target |
| `leftMargin`, `rightMargin`, `topMargin`, `bottomMargin`, `margins` | Ruang kosong di **luar** jangkar |
| `horizontalCenterOffset`, `verticalCenterOffset`, `baselineOffset` | Menggeser garis tengah atau baseline |
| `alignWhenCentered` | Membulatkan posisi tengah ke piksel utuh (bawaan `true`) |

Perhatikan dua aturan margin dari dokumentasi: margin adalah ruang kosong di sisi luar jangkar, dan margin hanya berlaku bila item memang berjangkar pada sisi itu. Margin bukan cara umum memberi bantalan pada sebuah item.

**Peragaan 1: contoh kurikulum, dikembangkan.**

```qml
import QtQuick

Rectangle {
    id: akar
    width: 320; height: 200; color: '#222'

    Rectangle {
        id: kotak
        width: 80; height: 80; color: 'tomato'
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
    }
    Rectangle {
        id: hijau
        width: 80; height: 80; color: 'seagreen'
        anchors { left: kotak.right; verticalCenter: kotak.verticalCenter; leftMargin: 8 }
    }
    Rectangle {                                   // mengisi sisa ruang di kanan
        id: biru
        color: 'steelblue'
        anchors {
            left: hijau.right; right: parent.right
            top: parent.top; bottom: parent.bottom
            margins: 8
        }
    }

    Timer {
        interval: 100; running: true
        onTriggered: {
            console.log(kotak.x, hijau.x, hijau.y)                        // 16 104 60
            console.log(biru.x, biru.y, biru.width, biru.height)          // 192 8 120 184
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml anchors.qml
```

Dugaan keluaran: `16 104 60` lalu `192 8 120 184` `[uji]`.

**Bedah kode:**

- `anchors { left: parent.left; ... }`: sintaks kelompok properti, sama dengan menulis `anchors.left: ...` satu per satu.
- `parent.left`: garis kiri milik induk. Nilai di sebelah kanan titik dua selalu berupa garis jangkar item lain, bukan angka.
- `leftMargin: 16`: menyisakan 16 piksel kosong di sisi luar jangkar kiri, sehingga `kotak.x` adalah 0 + 16.
- `verticalCenter: parent.verticalCenter`: pusat vertikal `kotak` sejajar dengan pusat vertikal induk. Tingginya 200 dan tinggi `kotak` 80, jadi `y` adalah 100 − 40 = 60.
- `left: kotak.right; leftMargin: 8`: tepi kiri `hijau` berada di tepi kanan `kotak` (16 + 80 = 96) ditambah 8, yaitu 104.
- `biru` tak punya `width` dan `height`. Dua jangkar horizontal (kiri `hijau.right`, kanan `parent.right`) dan dua jangkar vertikal menentukan ukurannya. `margins: 8` berlaku untuk keempat sisi: kiri 184 + 8 = 192, kanan 320 − 8 = 312 (lebar 120), atas 8, bawah 200 − 8 = 192 (tinggi 184).
- `Timer`: anchors baru diterapkan saat komponen selesai, jadi nilai dibaca setelah jeda singkat (3.3).

```
 akar 320 x 200
 +----------------------------------------------------------+
 |   +------+   +------+   +--------------------------------+ |
 |16 | kotak| 8 | hijau| 8 |             biru               | |8
 |-->|80x80 |<->|80x80 |<->|  mengisi sisa ruang, margin 8  | |
 |   +------+   +------+   +--------------------------------+ |
 +----------------------------------------------------------+
  kotak dan hijau berpusat vertikal; biru dibatasi empat jangkar
```

**Peragaan 2: baseline, offset, dan `centerIn`** (dengan jendela).

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 160; color: '#202020'

    Text {
        id: besar
        x: 20; y: 20
        text: 'Besar'; color: 'white'; font.pixelSize: 40
    }
    Text {
        anchors { left: besar.right; leftMargin: 8; baseline: besar.baseline }
        text: 'kecil'; color: 'gold'; font.pixelSize: 14
    }
    Rectangle {
        width: 120; height: 40; color: 'steelblue'
        anchors {
            horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: 60
            bottom: parent.bottom; bottomMargin: 16
        }
    }
    Rectangle {
        width: 60; height: 60; color: 'seagreen'
        anchors.centerIn: parent
    }
}
```

**Bedah kode:**

- `baseline: besar.baseline`: teks kecil duduk di garis dasar yang sama dengan teks besar, bukan di tepi atasnya. Hasilnya dua ukuran huruf tampak sebaris.
- `horizontalCenterOffset: 60`: menggeser pusat horizontal 60 piksel ke kanan dari pusat induk. Offset hanya berlaku untuk jangkar tengah dan baseline.
- `bottom: parent.bottom; bottomMargin: 16`: tepi bawah 16 piksel di atas tepi bawah induk.
- `anchors.centerIn: parent`: persegi hijau di tengah induk, setara `horizontalCenter` dan `verticalCenter` sekaligus.
- `parent` untuk item di dalam `Window` adalah `contentItem` (4.1.5).

**`alignWhenCentered`.** Dokumentasi: bila bernilai `true` (bawaan), item yang dipusatkan dan berukuran ganjil diletakkan pada piksel utuh, bukan setengah piksel, sehingga tampak tajam. Pada kasus tertentu ini tak diinginkan, misalnya saat item diputar karena pusat yang dibulatkan dapat menimbulkan getaran. Matikan dengan `anchors.alignWhenCentered: false` (4.2.6).

**Opsi lain, membuat item memenuhi induknya:**

| Cara | Catatan |
| --- | --- |
| `anchors.fill: parent` | Paling ringkas; mendukung `margins` |
| Empat jangkar tepi | Sama dengan `fill`, tetapi margin bisa berbeda per sisi |
| `width: parent.width; height: parent.height` | Binding ukuran; tak mendukung margin dan bukan janji relatif |
| `Layout.fillWidth` di `Layouts` | Fase berikutnya |

| Kesalahan | Solusi |
| --- | --- |
| Menulis `leftMargin` tanpa `anchors.left` | Margin tak berlaku. Pasang jangkarnya juga |
| Mengira margin sama dengan padding di dalam item | Margin berada di luar jangkar, bukan di dalam item |
| Memberi `width` pada item yang sudah berjangkar kiri dan kanan | Hasil tak terdefinisi (4.2.4). Hapus `width` |
| Mengharap `anchors` bekerja segera di `onCompleted` | Baca setelah jeda singkat (3.3) |

**Referensi:** [Positioning with Anchors](https://doc.qt.io/qt-6/qtquick-positioning-anchors.html) · [Item: anchors](https://doc.qt.io/qt-6/qml-qtquick-item.html)

---

### 4.2.4 Aturan anchors (hanya ke induk atau saudara)

*Aturan yang dihafal cukup untuk lulus, aturan yang dipahami cukup untuk tak pernah debugging semalaman.*

**Aturan 1: hanya induk langsung dan saudara.** Demi performa, sebuah item hanya boleh berjangkar pada induknya sendiri atau item yang sama-sama anak induk itu.

```qml
Item {
    Item {
        id: grup1
        Rectangle { id: rect1; width: 50; height: 50 }
    }
    Item {
        id: grup2
        Rectangle { id: rect2; width: 50; height: 50; anchors.left: rect1.right }   // tidak sah
    }
}
```

`rect1` adalah anak `grup1`, bukan saudara maupun induk `rect2`. Qt menghasilkan peringatan sejenis `Cannot anchor to an item that isn't a parent or sibling` `[uji]` (bunyi persisnya dapat berbeda).

| Perbaikan | Kapan |
| --- | --- |
| Jadikan keduanya saudara (satu induk) | Struktur memang bisa diratakan |
| Jangkarkan kedua item ke leluhur bersama | Keduanya perlu mengikuti item di luar kelompoknya |
| Pakai `mapToItem` di sebuah binding | Hanya bila tak ada pilihan lain; hilangkan sifat jangkarnya |

**Aturan 2: jangan mencampur posisi mutlak dan jangkar.** Dokumentasi menyatakan hasilnya tak terdefinisi pada kombinasi berikut:

| Kombinasi | Mengapa bermasalah |
| --- | --- |
| `x` + `anchors.left` | Tak jelas apakah posisi dari `x` atau dari jangkar |
| `anchors.left` + `anchors.right` + `width` | Tak jelas apakah lebar dari `width` atau dari dua jangkar |
| `y` + `anchors.top`, atau `anchors.top` + `bottom` + `height` | Sama, pada sumbu vertikal |
| `anchors.fill` + `width` atau `height` | Tak jelas siapa yang menentukan |
| Jangkar + item yang ditata `Row`, `Column`, atau `Grid` | Positioner mengatur `x` dan `y` |

Untuk beralih dari jangkar ke posisi mutlak, lepas jangkar dengan menugaskan `undefined`. Perhatikan: kurikulum menyebut `x` “diabaikan”. Dokumentasi menyebutnya **tak terdefinisi**, jadi jangan bergantung pada perilaku tertentu.

**Aturan 3: tak ada tiga jangkar pada satu sumbu.** `left`, `right`, dan `horizontalCenter` sekaligus bertentangan. Qt memperingatkan dengan teks sejenis `Cannot specify left, right, and horizontalCenter anchors` `[uji]`.

**Aturan 4: jangan membuat lingkaran.** Dua item yang saling menjangkar membuat loop yang tak dapat diselesaikan.

```qml
Item {
    width: 300; height: 100
    Rectangle { id: p; width: 50; height: 50; anchors.left: q.right }
    Rectangle { id: q; width: 50; height: 50; anchors.left: p.right }   // lingkaran
}
```

Dugaan: Qt mencetak peringatan `Possible anchor loop detected on horizontal anchor` `[uji]`. Kode sumber Qt memiliki varian serupa untuk `fill` dan `centerIn`. Perbaikannya: putus salah satu arah.

**Aturan 5: ubah jangkar saat berjalan dengan urutan yang benar.** Dokumentasi memperingatkan bahwa mengubah jangkar lewat JavaScript harus diurutkan: lepas yang tak diperlukan dulu, baru pasang yang baru.

```qml
import QtQuick

Item {
    width: 300; height: 120

    Rectangle {
        id: salah
        width: 50; height: 50
        anchors.left: parent.left
        function keKanan() {
            anchors.right = parent.right     // dua jangkar horizontal aktif: item melebar
            anchors.left = undefined         // lebar hasil pelebaran bertahan
        }
    }
    Rectangle {
        id: benar
        y: 60; width: 50; height: 50
        anchors.left: parent.left
        function keKanan() {
            anchors.left = undefined         // lepas yang lama dulu
            anchors.right = parent.right         // baru pasang yang baru
        }
    }

    Timer {
        interval: 100; running: true
        onTriggered: {
            salah.keKanan(); benar.keKanan()
            console.log('salah:', salah.x, salah.width)     // 0 300
            console.log('benar:', benar.x, benar.width)     // 250 50
            Qt.quit()
        }
    }
}
```

Dugaan keluaran: `salah: 0 300` dan `benar: 250 50` `[uji]`.

**Bedah kode:**

- `anchors.right = parent.right` di dalam fungsi: menugaskan garis jangkar secara imperatif. Di JS, sisi kanan tanda sama adalah nilai garis jangkar milik induk.
- Pada `salah`: setelah jangkar kanan dipasang, ada dua jangkar horizontal sekaligus, sehingga item direntangkan memenuhi induk. Saat jangkar kiri dilepas, lebar 300 hasil rentangan tetap bertahan.
- Pada `benar`: jangkar kiri dilepas lebih dulu, lalu jangkar kanan dipasang. Item tetap berukuran 50 dan menempel di kanan, jadi `x` = 300 − 50 = 250.
- `anchors.left = undefined`: cara melepas jangkar.

**Jangan mengubah jangkar lewat binding kondisional.** Urutan evaluasi binding tak terdefinisi, sehingga ekspresi seperti `anchors.left: kondisi ? undefined : parent.left` yang dipasangkan dengan `anchors.right` pasangannya dapat membuat kedua jangkar aktif bersamaan. Item akhirnya melebar ke seluruh induk. Untuk perubahan jangkar yang terkait state, dokumentasi merekomendasikan `AnchorChanges`:

```qml
Rectangle {
    id: rect
    width: 50; height: 50
    anchors.left: parent.left

    states: State {
        name: 'kanan'
        AnchorChanges { target: rect; anchors.left: undefined; anchors.right: parent.right }
    }
}
```

`State` dan `AnchorChanges` dibahas di fase animasi dan state. Di sini cukup Anda tahu bahwa `AnchorChanges` mengurus urutan secara internal, dan bahwa `AnchorAnimation` dapat menganimasikannya `[uji]` untuk detail pemakaiannya.

| Kesalahan | Solusi |
| --- | --- |
| Menjangkar ke item yang bukan induk atau saudara | Ratakan struktur, atau jangkar ke leluhur bersama |
| Memadukan `x` dengan `anchors.left` | Pilih satu. Lepas jangkar dengan `undefined` bila beralih |
| Menambah jangkar baru sebelum melepas yang lama | Lepas dulu, pasang kemudian |
| Mengubah jangkar lewat binding kondisional | Pakai `AnchorChanges` di dalam `State` |
| Dua item saling menjangkar | Putus salah satu arah |

**Referensi:** [Positioning with Anchors: Changing Anchors, Restrictions](https://doc.qt.io/qt-6/qtquick-positioning-anchors.html) · [AnchorChanges](https://doc.qt.io/qt-6/qml-qtquick-anchorchanges.html)

---

### 4.2.5 `z` dan urutan gambar

*Yang di atas tidak selalu yang paling besar nomornya, melainkan yang paling dekat ke akar.*

**Konsep.** Aturan dasar (dibahas di 4.1) menurut dokumentasi: `z` menentukan urutan tumpuk item bersaudara. `z` lebih tinggi digambar di atas `z` lebih rendah. `z` yang sama digambar dari bawah ke atas menurut urutan kemunculan di kode. `z` negatif digambar di bawah isi induknya. Nilai bawaannya 0.

Kata kunci pada definisi itu adalah *bersaudara*: `z` hanya membandingkan item yang berinduk sama. Akibatnya, sebuah anak tidak dapat melampaui saudara induknya, seberapa besar pun `z`-nya.

**Percobaan: `z` tak bisa lolos dari induknya.**

```qml
import QtQuick

Window {
    visible: true; width: 300; height: 220; color: '#202020'

    Item {                                       // induk A (z: 0)
        id: a
        x: 20; y: 20; width: 160; height: 120
        Rectangle { anchors.fill: parent; color: 'tomato' }
        Rectangle { z: 100; x: 60; y: 80; width: 100; height: 100; color: 'gold' }   // z besar, tetapi anak A
    }
    Item {                                       // induk B (z: 1), saudara A
        id: b
        z: 1
        x: 120; y: 60; width: 160; height: 120
        Rectangle { anchors.fill: parent; color: 'steelblue' }
    }
}
```

Dugaan: persegi emas (`z: 100`) tetap tertutup biru di area yang tumpang tindih, karena seluruh subpohon A (`z: 0`) digambar di bawah B (`z: 1`). Hanya bagian emas yang menjorok ke luar B yang terlihat `[uji]`. Ubah `a` menjadi `z: 2` dan emas kini berada di atas biru.

**Bedah kode:**

- `Item { id: a ... }` dan `Item { id: b; z: 1 }`: dua item bersaudara. `z` mereka (0 dan 1) menentukan siapa di atas.
- `Rectangle { z: 100 ... }` di dalam `a`: `z` ini hanya berpengaruh terhadap saudaranya di dalam `a` (di sini persegi tomat), bukan terhadap `b`.
- Subpohon sebuah item digambar sebagai satu kesatuan relatif terhadap saudaranya `[uji]`.

```
 Saudara dalam satu induk, diurutkan oleh z:
   root
    +-- A (z 0)  -------- isinya digambar sebagai satu paket
    |     +-- tomat
    |     +-- emas (z 100)   hanya menang atas tomat
    +-- B (z 1)  -------- digambar di atas seluruh paket A
```

**Urutan input mengikuti urutan gambar secara terbalik.** Item yang paling atas diberi kesempatan pertama menerima klik. Bila ia menerimanya, item di bawahnya tak mendapat apa-apa. Itu sebabnya item `opacity: 0` yang berada di atas dapat menelan klik (4.1.3).

**Catatan keamanan.** Karena item teratas menerima input lebih dulu, sebuah item transparan berukuran penuh dengan `z` tinggi dapat menutupi tombol konfirmasi di bawahnya dan menelan atau mengalihkan klik. Ini analog dengan *clickjacking* di web. Pada aplikasi yang memuat QML pihak ketiga atau plugin, periksa siapa yang boleh menaruh item di atas pohon utama, dan jangan memberi komponen luar akses ke akar tempat overlay bisa dipasang.

**Opsi lain, mengatur urutan:**

| Cara | Kapan |
| --- | --- |
| Urutan deklarasi | Paling sederhana; susun item dari bawah ke atas |
| `z` | Mengubah urutan antar saudara tanpa memindahkan baris kode |
| Pindahkan ke induk lain (`parent = ...`) | Item harus keluar dari subpohon induknya (4.1.6) |
| Taruh item yang selalu di atas (dialog, tooltip) sebagai anak akar | Agar tak terperangkap di subpohon induk yang `z`-nya rendah |

| Kesalahan | Solusi |
| --- | --- |
| Memberi `z: 9999` pada anak agar muncul di atas segalanya | Tak bekerja bila induknya kalah. Pindahkan item atau naikkan `z` induknya |
| Mengira `z` membandingkan seluruh pohon | Hanya antar saudara |
| Menumpuk item tak terlihat yang menelan input | Pakai `visible: false` atau `enabled: false` (4.1.3) |
| Mengandalkan urutan deklarasi untuk overlay penting | Beri `z` eksplisit dan taruh di tingkat yang tepat |

**Referensi:** [Item: z](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Important Concepts In Qt Quick: Positioning](https://doc.qt.io/qt-6/qtquick-positioning-topic.html)

---

### 4.2.6 Transformasi dan piksel `[TAMBAHAN]`

*Posisi menentukan di mana sebuah item berada. Transformasi menentukan bagaimana ia tampak berada di sana.*

**Konsep.** Geometri (`x`, `y`, `width`, `height`) dan transformasi adalah dua hal berbeda. Transformasi memutar atau membesarkan tampilan item tanpa mengubah geometrinya.

| Properti | Arti | Bawaan |
| --- | --- | --- |
| `rotation` | Sudut putar dalam derajat, searah jarum jam, di sekitar `transformOrigin` | 0 |
| `scale` | Faktor pembesaran di sekitar `transformOrigin` | 1.0 |
| `transformOrigin` | Titik tumpu transformasi (`Item.TopLeft`, `Top`, `TopRight`, `Left`, `Center`, `Right`, `BottomLeft`, `Bottom`, `BottomRight`) | `Item.Center` `[uji]` |

**Peragaan: geometri tak berubah, posisi visual berubah.**

```qml
import QtQuick

Item {
    id: root
    width: 300; height: 300

    Rectangle {
        id: r
        x: 100; y: 100; width: 100; height: 50
        rotation: 90                                   // searah jarum jam, di sekitar pusatnya
    }
    Rectangle {
        id: s
        width: 20; height: 20
        anchors { left: r.right; verticalCenter: r.verticalCenter }
    }

    Timer {
        interval: 100; running: true
        onTriggered: {
            console.log(r.x, r.y, r.width, r.height)       // 100 100 100 50   (tak berubah)
            const p = r.mapToItem(root, 0, 0)
            console.log(p.x, p.y)                              // 175 75
            console.log(s.x)                               // 200
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml putar.qml
```

Dugaan keluaran: `100 100 100 50`, lalu `175 75`, lalu `200` `[uji]`.

**Bedah kode:**

- `rotation: 90`: persegi 100 × 50 diputar 90 derajat searah jarum jam di sekitar pusatnya, titik (150, 125) di koordinat `root`.
- `r.x, r.y, r.width, r.height`: tetap `100 100 100 50`. Transformasi tak mengubah geometri.
- `r.mapToItem(root, 0, 0)`: memetakan sudut kiri atas lokal `r` ke koordinat `root`, dengan memperhitungkan rotasi. Titik (0, 0) berjarak (−50, −25) dari pusat. Setelah diputar 90° searah jarum jam, ia menjadi (25, −50) dari pusat, yaitu (175, 75) di `root`.
- `s.x` bernilai 200: jangkar `r.right` dihitung dari geometri `r` (100 + 100), bukan dari bentuk setelah rotasi `[uji]`. Item yang berjangkar pada item yang diputar tidak ikut berputar.

**Piksel dan ketajaman.**

- `x`, `y`, `width`, dan `height` boleh pecahan, tetapi tepi yang jatuh di tengah piksel tampak kabur. Bulatkan dengan `Math.round` bila ketajaman penting.
- `anchors.alignWhenCentered` (bawaan `true`) membulatkan posisi item yang dipusatkan ke piksel utuh. Saat item diputar, pembulatan pusat dapat menimbulkan getaran, jadi dokumentasi menyebut ini kadang tak diinginkan. Matikan dengan `anchors.alignWhenCentered: false`.
- `Rectangle` memiliki `border.pixelAligned` untuk menyejajarkan bingkai ke piksel `[uji]`.

**Opsi lain, transformasi yang lebih kompleks:** properti `transform` menerima daftar tipe seperti `Rotation`, `Scale`, `Translate`, dan `Matrix4x4`, untuk titik tumpu berbeda per transformasi atau rotasi tiga dimensi `[uji]`.

| Kesalahan | Solusi |
| --- | --- |
| Mengira `rotation` mengubah `width` dan `height` | Geometri tak berubah. Pakai `mapToItem` atau `childrenRect` untuk batas visual |
| Mengharap item yang berjangkar pada item berputar ikut berputar | Jangkar mengikuti geometri, bukan bentuk visual `[uji]` |
| Memberi `clip: true` pada item yang diputar | Klip berputar lebih mahal (4.1.4). Hindari bila bisa |
| Item yang dipusatkan bergetar saat berputar | Setel `anchors.alignWhenCentered: false` |

**Referensi:** [Item: rotation, scale, transformOrigin](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Item: anchors.alignWhenCentered](https://doc.qt.io/qt-6/qml-qtquick-item.html)

---

### 4.2.7 Memilih mekanisme tata letak dan men-debug geometri `[TAMBAHAN]`

*Alat yang tepat membuat tata letak tak lagi terasa seperti sihir.*

**Konsep.** Qt Quick menyediakan beberapa cara menata item. Memilih yang tepat menentukan seberapa tahan tata letak Anda saat jendela, font, atau isi berubah.

| Mekanisme | Cocok untuk | Catatan |
| --- | --- | --- |
| Koordinat mutlak (`x`, `y`) | Item yang tak pernah bergerak, prototipe cepat | Paling rapuh |
| Binding (`width: parent.width / 2`) | Hubungan matematis sederhana | Bukan janji antar tepi |
| Anchors | Hubungan antar tepi, mengisi, memusatkan | Hanya induk dan saudara; tak ada pembagian ruang rata |
| Positioner (`Row`, `Column`, `Grid`, `Flow`) | Menata anak berurutan | Fase berikutnya; mengatur `x` dan `y` anak |
| `Layouts` (`RowLayout`, `ColumnLayout`, `GridLayout`) | Pembagian ruang, ukuran minimum dan maksimum | Fase berikutnya |

```
 Perlu menata item?
   |
   +-- hubungan antar tepi / mengisi / memusatkan? --> anchors
   +-- deretan item berurutan? ---------------------> Row / Column / Grid (fase berikutnya)
   +-- ruang dibagi rata atau ada ukuran min/maks? --> Layouts (fase berikutnya)
   +-- satu nilai bergantung pada rumus? ------------> binding
   +-- tak pernah bergerak? -------------------------> x dan y
```

**Teknik debugging geometri:**

1. **Garis bantu.** Tempel sementara persegi berbingkai di item yang dicurigai:

```qml
Rectangle {
    anchors.fill: parent
    color: 'transparent'
    border { color: 'magenta'; width: 1 }
    z: 1000
}
```

Ingat aturan 4.2.5: `z` hanya membandingkan saudara. Bila garis bantu tak muncul, mungkin ia terperangkap di subpohon yang tertutup.

2. **Cetak setelah jeda.** Anchors dan ukuran implisit baru stabil setelah komponen selesai. Baca dalam `Timer` atau `Qt.callLater` (3.3.4), bukan langsung di `onCompleted`.
3. **`dumpItemTree()`.** Item memiliki metode `dumpItemTree()` yang tercantum di daftar anggota dokumentasi Qt 6.5. Menurut namanya ia mencetak pohon item ke log, termasuk anak-anaknya. Perilaku persisnya `[uji]`:

```qml
Timer { interval: 200; running: true; onTriggered: { root.dumpItemTree(); Qt.quit() } }
```

4. **Uji perubahan ukuran.** Ubah ukuran jendela lewat kode dan periksa invarian tata letak:

```qml
import QtQuick

Window {
    id: w
    visible: true; width: 320; height: 120

    Rectangle {
        id: a; width: 60; height: 60; color: 'tomato'
        anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
    }
    Rectangle {
        id: b; width: 60; height: 60; color: 'seagreen'
        anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
    }

    Timer {
        interval: 200; running: true
        onTriggered: {
            console.log('sebelum:', b.x, a.y)             // 252 30
            w.width = 640; w.height = 200
            ulang.start()
        }
    }
    Timer {
        id: ulang
        interval: 200
        onTriggered: { console.log('sesudah:', b.x, a.y); Qt.quit() }     // 572 70
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml ukuran.qml
```

Dugaan keluaran: `sebelum: 252 30` lalu `sesudah: 572 70` `[uji]`. Kotak hijau tetap 8 piksel dari tepi kanan (640 − 8 − 60 = 572) dan kotak merah tetap di tengah vertikal ((200 − 60) / 2 = 70).

5. **Alat eksternal.** *GammaRay* (KDAB) menampilkan pohon item dan propertinya langsung. `qmllint` menandai pola yang mencurigakan secara statis.

**Bedah kode (uji ukuran):**

- `w.width = 640; w.height = 200`: mengubah ukuran jendela. Karena `a` dan `b` berjangkar ke induknya, posisi mereka dihitung ulang otomatis.
- Dua `Timer` berurutan: yang kedua memberi waktu loop peristiwa memproses perubahan ukuran sebelum nilai dibaca.
- Angka 252 dan 572 muncul dari rumus lebar jendela dikurangi margin dikurangi lebar kotak. Anda dapat memeriksanya dengan kalkulator.

| Kesalahan | Solusi |
| --- | --- |
| Memilih koordinat mutlak lalu heran tata letak pecah saat ukuran berubah | Pakai anchors atau positioner |
| Mencetak geometri langsung di `onCompleted` | Tunggu sebentar (`Timer`, `Qt.callLater`) |
| Menebak penyebab tata letak aneh | Pasang garis bantu, cetak nilai, jalankan uji ukuran |
| Menggunakan anchors untuk membagi ruang rata | Anchors tak punya pembagian ruang. Pakai positioner atau Layouts nanti |

**Referensi:** [Important Concepts In Qt Quick: Positioning](https://doc.qt.io/qt-6/qtquick-positioning-topic.html) · [Item Positioners](https://doc.qt.io/qt-6/qtquick-positioning-layouts.html) · [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** susun tiga kotak sejajar yang tetap berjarak 8 piksel saat jendela diubah ukurannya.

```qml
import QtQuick

Window {
    id: w
    visible: true; width: 360; height: 140; color: '#202020'

    Rectangle {
        id: a; width: 90; height: 90; color: 'tomato'
        anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
    }
    Rectangle {
        id: b; width: 90; height: 90; color: 'seagreen'
        anchors { left: a.right; leftMargin: 8; verticalCenter: parent.verticalCenter }
    }
    Rectangle {
        id: c; width: 90; height: 90; color: 'steelblue'
        anchors { left: b.right; leftMargin: 8; verticalCenter: parent.verticalCenter }
    }

    Timer {
        interval: 200; running: true
        onTriggered: {
            console.log('jarak:', b.x - (a.x + a.width), c.x - (b.x + b.width))       // 8 8
            w.width = 700
            periksa.start()
        }
    }
    Timer {
        id: periksa
        interval: 200
        onTriggered: {
            console.log('jarak:', b.x - (a.x + a.width), c.x - (b.x + b.width), 'y:', a.y)   // 8 8 y: 25
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml tiga-kotak.qml
```

Dugaan: `jarak: 8 8`, lalu `jarak: 8 8 y: 25` `[uji]`.

**Kunci:** kotak pertama berjangkar ke tepi kiri induk dengan margin 8. Kotak kedua berjangkar ke tepi kanan kotak pertama, dan kotak ketiga ke tepi kanan kotak kedua, masing-masing dengan margin 8. Jarak antarkotak adalah 8 apa pun lebar jendela karena tak ada angka mutlak untuk `x`. Ketiganya berpusat vertikal ((140 − 90) / 2 = 25).

**Variasi: tiga kotak melebar sama lebar.** Anchors saja tak dapat membagi ruang secara rata, jadi pakai binding:

```qml
Rectangle {
    id: a; height: 90; color: 'tomato'
    width: (parent.width - 4 * 8) / 3                       // empat celah 8 piksel, tiga kotak
    anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
}
Rectangle {
    id: b; height: 90; color: 'seagreen'; width: a.width
    anchors { left: a.right; leftMargin: 8; verticalCenter: parent.verticalCenter }
}
Rectangle {
    id: c; height: 90; color: 'steelblue'; width: a.width
    anchors { left: b.right; leftMargin: 8; verticalCenter: parent.verticalCenter }
}
```

Perhatikan bahwa kotak pertama memakai `width` eksplisit bersama satu jangkar horizontal saja (`left`), sehingga tak melanggar aturan 4.2.4. Untuk pembagian ruang yang lebih rapi, positioner dan `Layouts` di fase berikutnya adalah alat yang tepat.

**Cek pemahaman (dari kurikulum):** *Item mana saja yang boleh menjadi target anchors?* Hanya induk langsung dan saudara (item lain yang berinduk sama).

**Pertanyaan tambahan:**

1. *Apa beda margin anchors dan padding?* Margin adalah ruang kosong di luar jangkar dan hanya berlaku bila berjangkar pada sisi itu. Padding adalah ruang di dalam item, dan harus Anda hitung sendiri.
2. *Mengapa `leftMargin` tanpa `anchors.left` tak berefek?* Margin hanya berlaku pada sisi yang berjangkar.
3. *Apa yang terjadi bila `x` dipakai bersama `anchors.left`?* Hasilnya tak terdefinisi. Pilih salah satu.
4. *Mengapa urutan lepas dan pasang jangkar penting?* Memasang jangkar baru sebelum melepas yang lama membuat dua jangkar aktif sekaligus, dan item melebar.
5. *Mengapa anak ber-`z: 100` tertutup saudara induknya?* `z` hanya membandingkan saudara, dan subpohon induk digambar sebagai satu kesatuan.
6. *Mengapa komponen perlu menyatakan `implicitWidth`?* Agar ia punya ukuran alami yang bermakna dan pemakai tetap bebas menimpa.
7. *Mengapa tiga kotak berlebar sama tak dapat dibuat dengan anchors saja?* Anchors mengikat tepi, bukan membagi ruang.

**Tantangan:**

- Buat komponen sebaris `Kartu` dengan `implicitWidth` dan `implicitHeight`, lalu pakai tiga instans dalam satu baris yang berjangkar.
- Bandingkan `x` sebuah persegi 51 × 51 yang dipusatkan di induk 100 × 100 dengan `anchors.alignWhenCentered` bernilai `true` dan `false`. Dugaan: dengan `false` nilainya 24.5, dengan `true` bilangan bulat `[uji]`.

---

## F. Glosarium Modul 4.2

| Istilah | Arti |
| --- | --- |
| Geometri | Posisi dan ukuran item: `x`, `y`, `width`, `height` |
| Koordinat lokal | Koordinat yang diukur dari sudut kiri atas induk |
| Garis jangkar | Salah satu dari tujuh garis tak terlihat pada item: `left`, `horizontalCenter`, `right`, `top`, `verticalCenter`, `baseline`, `bottom` |
| Anchors | Mekanisme mengikat garis jangkar satu item ke garis item lain |
| Margin | Ruang kosong di luar jangkar; hanya berlaku pada sisi yang berjangkar |
| Offset | Pergeseran garis tengah atau baseline |
| `anchors.fill` | Setara empat jangkar ke tepi item target |
| `anchors.centerIn` | Setara dua jangkar tengah |
| `alignWhenCentered` | Membulatkan posisi yang dipusatkan ke piksel utuh |
| `implicitWidth` / `implicitHeight` | Ukuran alami item bila `width` dan `height` tak ditentukan |
| `childrenRect` | Persegi pembatas semua anak, dalam koordinat lokal |
| Anchor loop | Dua item yang saling menjangkar sehingga tak dapat diselesaikan |
| `AnchorChanges` | Tipe untuk mengubah jangkar di dalam `State` dengan urutan yang aman |
| `z` | Urutan tumpuk antar saudara |
| Stacking context | Subpohon yang digambar sebagai satu kesatuan relatif terhadap saudara induknya |
| `rotation` / `scale` / `transformOrigin` | Transformasi tampilan di sekitar titik tumpu |
| Positioner | Tipe yang menata anak berurutan (`Row`, `Column`, `Grid`, `Flow`) |
| Inline component | Komponen yang dideklarasikan di dalam berkas yang sama dengan `component Nama: Tipe { }` |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
| --- | --- |
| **3.1** Property Binding | Anchors adalah hubungan yang diperbarui otomatis; `width: contentWidth` dan jangkar yang saling menunjuk menimbulkan loop |
| **3.3** Lifecycle | Anchors dan ukuran implisit baru stabil setelah selesai; pakai `Timer` atau `Qt.callLater` untuk membaca |
| **3.4** Scope dan konteks | `parent` dan `id` sebagai target jangkar; sintaks kelompok `anchors { }` mengikuti aturan scope biasa |
| **4.1** Item dan primitif | Hierarki, `z`, `clip`, dan `opacity` yang dibahas di sana terus berlaku; 4.2 menambah cara menempatkan dan menata |
| **4.3** Resource | `Image` punya ukuran implisit sendiri, `fillMode` dan `sourceSize` memengaruhi tata letak; **4.3.6 memerlukan Modul 10.1** |
| **4.4** Input dasar | Urutan input mengikuti `z`; ukuran item menentukan area sentuh; idiom `MouseArea { anchors.fill: parent }` |
| **Fase berikutnya** | Positioner, `Layouts`, `State` dengan `AnchorChanges`, dan animasi |
| **Keamanan** | Item overlay berukuran penuh dengan `z` tinggi dapat menelan input; periksa siapa yang boleh menaruhnya |

**Penutup Modul 4.2:** Anda kini dapat menempatkan item dengan janji relatif, tahu aturan yang tak boleh dilanggar, memahami mengapa `z` tak bisa lolos dari induknya, dan punya cara memeriksa tata letak. Modul berikutnya adalah 4.3 — Resource: Gambar, Font, dan URL (bagian 4.3.6 memerlukan Modul 10.1).

---

**Catatan tautan:** Fakta pada halaman Positioning with Anchors (6.12) tentang `alignWhenCentered`, `implicitWidth`, dan `dumpItemTree()` yang mana materi disini diambil lewat hasil pencarian dari dokumentasi Item beberapa versi Qt (5.x dan 6.5) serta kode sumber Qt, sehingga tandai `[uji]` pada versi Anda. Bunyi pesan peringatan `Cannot anchor to an item that isn't a parent or sibling` dan `Cannot specify left, right, and horizontalCenter anchors` ditulis dari kode sumber Qt dan belum verifikasi dalam sesi ini. Halaman AnchorChanges dan Item Positioners muncul sebagai tautan di halaman yang telah ditinjau tetapi belum diuji satu per satu.

# Fase 4 · Modul 4.3 — Resource: Gambar, Font, dan URL

*Melanjutkan Modul 4.2.*

<!-- Saya membaca bagian Modul 4.3 dari kurikulum Fase 4 yang Anda kirim, lalu mengaudit isinya terhadap dokumentasi Qt 6.12 (Image, tipe `url`, `qt_add_qml_module`, Building a QML application) dan dokumentasi Qt untuk `FontLoader` dan `QImageReader`. Seperti sebelumnya, saya tidak menjalankan kode QML dan CMake ini pada Qt, jadi bagian bertanda `[uji]` perlu Anda buktikan sendiri. Satu pengecualian: skrip Python pembuat PNG di bagian C sudah saya jalankan dan periksa (validitas berkas, ukuran, dan hitungan memori). -->

---

## A. Audit singkat

**Terverifikasi:**

- URL relatif dihitung dari URL komponen yang memuatnya. Contoh kurikulum benar.
- Di dalam modul QML, `RESOURCES` pada `qt_add_qml_module` menaruh berkas di bawah akar path yang sama dengan berkas QML, sehingga path relatif dari berkas QML tetap berlaku di dalam binary.
- `Image.asynchronous` hanya berlaku untuk berkas di filesystem lokal. Gambar dari jaringan selalu dimuat asinkron.
- `sourceSize` membatasi jumlah piksel yang disimpan di memori, bukan sekadar ukuran gambar saat digambar. Bila hanya satu dimensi diisi, dimensi lain mengikuti rasio asli.
- Contoh kurikulum `Image { source; asynchronous; fillMode: Image.PreserveAspectFit; sourceSize.width: 128 }` sah.
- `FontLoader` memuat font dari nama atau URL, mengisi `name` otomatis dari `source`, dan melaporkan `status`.
- `Qt.resolvedUrl` mengubah string relatif menjadi `url` absolut menurut berkas pemanggil.

**Perlu dikoreksi atau dilengkapi:**

1. **Skema `qrc`.** Dokumentasi tipe `url` menyatakan bahwa untuk berkas di sistem resource Qt, QML memerlukan `qrc:///`, bukan `:/`. Kurikulum tidak menyebutnya. Masuk 4.3.5.
2. **Prefix resource bergantung pada kebijakan CMake.** Path `qrc:/qt/qml/<URI>` hanya berlaku bila `qt_standard_project_setup(REQUIRES 6.5)` mengaktifkan kebijakan QTP0001. Kurikulum langsung ke `RESOURCES` tanpa menyebut ini. Masuk 4.3.6, yang juga **memerlukan Modul 10.1** (C++ dan CMake).
3. **`asynchronous` bukan obat segalanya.** Ia hanya untuk berkas lokal, gambar baru terlihat setelah siap, dan tata letak tak boleh bergantung pada gambar yang belum ada. `status` dan `progress` perlu dibaca. Diperluas di 4.3.2.
4. **`cache` ada di judul tetapi tak dijelaskan.** Gambar dibagikan: beberapa `Image` dengan `source` sama memakai satu salinan. `cache: false` berguna untuk gambar besar agar tak menyingkirkan gambar UI kecil dari cache. Masuk 4.3.2.
5. **`sourceSize` hanya dikaitkan dengan memori.** Dokumentasi juga menyatakan pengaruhnya pada SVG (ukuran raster), pada JPEG (seluruh gambar tak pernah dimuat), pada `implicitWidth`, dan bahwa mengubahnya saat berjalan memuat ulang sumber. Diperluas di 4.3.3.
6. **Membandingkan `source` dengan string selalu salah.** `logo.source == 'pics/logo.png'` bernilai `false` karena nilai sudah menjadi objek URL. Bandingkan dengan `Qt.resolvedUrl(...)`. Masuk 4.3.5.
7. **Font dari URL jarang diperingatkan.** Font adalah berkas biner yang diurai oleh pustaka font. Untuk keamanan, utamakan font yang dikemas di resource. Masuk 4.3.4 dan 4.3.8.
8. **Latihan memori perlu cara mengukur.** Saya sediakan skrip pembuat gambar uji dan cara membaca memori proses dari terminal (`VmRSS`).
9. **Varian gambar dan batas sumber daya tak dibahas.** Sintaks `@nx` untuk layar beresolusi tinggi, SVG, `AnimatedImage`, EXIF (`autoTransform`), deteksi ekstensi otomatis, dan batas alokasi gambar bawaan Qt (256 MB). TAMBAHAN 4.3.7 dan 4.3.8.

**TAMBAHAN:**

- **4.3.7** Varian dan format: `@nx`, SVG, `AnimatedImage`, EXIF, deteksi ekstensi.
- **4.3.8** Keamanan dan batas sumber daya.

---

## B. Daftar isi Modul 4.3 (diperbarui)

- **4.3.1** `Image` dan `fillMode` `[diperluas]`
- **4.3.2** Pemuatan asinkron, status, dan cache `[diperluas]`
- **4.3.3** `sourceSize` dan memori `[diperluas]`
- **4.3.4** `FontLoader` dan `font` `[diperluas]`
- **4.3.5** URL dan `Qt.resolvedUrl` `[diperluas]`
- **4.3.6** `RESOURCES` di CMake (prasyarat: Modul 10.1) `[diperluas]`
- **4.3.7** Varian dan format `[TAMBAHAN]`
- **4.3.8** Keamanan dan batas sumber daya `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 4.3.1 → 4.3.2 → 4.3.3 → 4.3.4 → 4.3.5 → 4.3.7 → 4.3.8, lalu kerjakan Modul 10.1 sebelum 4.3.6.

---

## C. Peta besar

```
 source: 'images/logo.png'                     (sekadar teks)
      |  url: relatif dihitung dari URL berkas QML yang menulisnya
      v
 qrc:/qt/qml/Lab43/images/logo.png             (di dalam binary; atau file:///..., https://...)
      |  dimuat: sinkron | asynchronous | jaringan (selalu asinkron)
      v
 dekode -> QImage (lebar x tinggi x 4 byte)    <- sourceSize membatasi di titik ini
      |  cache bersama: satu salinan per sumber
      v
 tekstur GPU -> digambar oleh scene graph
```

**Filosofinya:** sebuah resource adalah dependensi dari luar kode Anda. Ia harus dipetakan (dari mana asalnya), dibatasi (seberapa besar ia boleh jadi), dan diverifikasi (apakah ia ada dan dapat dibaca). Aplikasi yang lalai pada salah satunya tampil rusak di satu mesin dan baik-baik saja di mesin lain, atau lebih buruk, mengonsumsi memori tanpa batas dari berkas yang tak Anda kendalikan.

**Persiapan laboratorium.** Simpan skrip ini sebagai `gen_png.py`. Ia membuat PNG dengan pustaka standar Python saja, jadi tak perlu mengunduh apa pun. Polos secara bawaan, atau papan catur 20 piksel bila diberi argumen `papan`.

```python
#!/usr/bin/env python3
# python3 gen_png.py nama.png LEBAR TINGGI          -> warna polos
# python3 gen_png.py nama.png LEBAR TINGGI papan    -> papan catur 20 px
import sys, zlib, struct

def chunk(tipe, data):
    c = struct.pack('>I', len(data)) + tipe + data
    return c + struct.pack('>I', zlib.crc32(tipe + data) & 0xffffffff)

def baris(y, lebar, papan):
    if not papan:
        return b'\x00' + bytes((255, 140, 0)) * lebar
    px = [bytes((255, 140, 0)) if (x // 20 + y // 20) % 2 == 0 else bytes((40, 40, 40))
          for x in range(lebar)]
    return b'\x00' + b''.join(px)

def buat(nama, lebar, tinggi, papan=False):
    z = zlib.compressobj(6)
    idat = b''.join(z.compress(baris(y, lebar, papan)) for y in range(tinggi)) + z.flush()
    png = (b'\x89PNG\r\n\x1a\n'
           + chunk(b'IHDR', struct.pack('>IIBBBBB', lebar, tinggi, 8, 2, 0, 0, 0))
           + chunk(b'IDAT', idat) + chunk(b'IEND', b''))
    with open(nama, 'wb') as f:
        f.write(png)

if __name__ == '__main__':
    nama, lebar, tinggi = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
    buat(nama, lebar, tinggi, len(sys.argv) > 4 and sys.argv[4] == 'papan')
    print(nama, lebar, 'x', tinggi)
```

```bash
mkdir -p lab43 && cd lab43
python3 ../gen_png.py lebar.png 200 100 papan     # 487 byte di disk
python3 ../gen_png.py logo.png 64 64              # 176 byte
python3 ../gen_png.py besar.png 6000 4000         # 79.884 byte di disk
file besar.png                                    # PNG image data, 6000 x 4000
```

Saya sudah menjalankan ketiganya dan memeriksa bahwa hasilnya PNG sah. Perhatikan `besar.png`: hanya sekitar 80 KB di disk, tetapi 6000 × 4000 × 4 byte = 96.000.000 byte, kira-kira 91,6 MiB, begitu didekode di memori. Ketimpangan inilah yang dibahas di 4.3.3 dan 4.3.8.

**Cara menjalankan contoh:** `QT_QPA_PLATFORM=offscreen qml nama.qml` dari direktori `lab43`, agar path relatif ditemukan. Berkas visual: `qml nama.qml`.

---

## D. Materi

### 4.3.1 `Image` dan `fillMode`

*Satu gambar kecil di tempat yang tepat lebih berharga daripada seribu piksel yang tak terpakai.*

**Konsep.** `Image` menampilkan gambar dari sebuah URL (`source`). Ia menerima format standar yang didukung Qt: bitmap seperti PNG dan JPEG, dan format vektor seperti SVG. Untuk gambar beranimasi, dokumentasi menyebut `AnimatedSprite` dan `AnimatedImage` (4.3.7).

Aturan ukuran menurut dokumentasi: bila `width` dan `height` tak ditentukan, `Image` memakai ukuran gambar yang dimuat. Bila ditentukan, gambar diskalakan ke ukuran itu secara bawaan. `fillMode` mengubah perilaku tersebut.

| `fillMode` | Perilaku |
| --- | --- |
| `Image.Stretch` (bawaan) | Gambar diskalakan agar pas |
| `Image.PreserveAspectFit` | Diskalakan seragam agar muat tanpa terpotong |
| `Image.PreserveAspectCrop` | Diskalakan seragam agar memenuhi area, terpotong bila perlu |
| `Image.Tile` | Digandakan horizontal dan vertikal |
| `Image.TileVertically` | Direntangkan horizontal, diulang vertikal |
| `Image.TileHorizontally` | Direntangkan vertikal, diulang horizontal |
| `Image.Pad` | Tidak ditransformasi |

Dua catatan dokumentasi: `clip` bawaannya `false`, sehingga pada `PreserveAspectCrop` item bisa menggambar di luar batasnya kecuali Anda menyetel `clip: true`. Dan `paintedWidth` serta `paintedHeight` melaporkan ukuran yang benar-benar digambar, yang bisa lebih kecil atau lebih besar daripada `width` dan `height` pada mode Fit dan Crop.

**Peragaan 1: angka (tanpa jendela).**

```qml
import QtQuick

Item {
    Image { id: s; source: 'lebar.png'; width: 130; height: 100; fillMode: Image.Stretch }
    Image { id: f; source: 'lebar.png'; width: 130; height: 100; fillMode: Image.PreserveAspectFit }
    Image { id: c; source: 'lebar.png'; width: 130; height: 100; fillMode: Image.PreserveAspectCrop }

    Timer {
        interval: 300; running: true
        onTriggered: {
            console.log('implisit :', s.implicitWidth, s.implicitHeight)    // 200 100
            console.log('stretch  :', s.paintedWidth, s.paintedHeight)      // 130 100
            console.log('fit      :', f.paintedWidth, f.paintedHeight)      // 130 65
            console.log('crop     :', c.paintedWidth, c.paintedHeight)      // 200 100
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml fillmode.qml
```

Dugaan keluaran: `200 100`, `130 100`, `130 65`, dan `200 100` `[uji]`.

**Bedah kode:**

- `source: 'lebar.png'`: URL relatif. Dihitung dari lokasi berkas QML ini (4.3.5).
- `width: 130; height: 100`: kotak tampilan. Gambarnya sendiri berukuran 200 × 100, rasio 2 : 1.
- `Image.Stretch`: gambar dipaksa pas ke 130 × 100, jadi `paintedWidth` dan `paintedHeight` sama dengan kotak.
- `Image.PreserveAspectFit`: skala seragam terkecil yang membuat gambar muat: min(130 / 200, 100 / 100) = 0,65. Hasilnya 130 × 65, dengan ruang kosong di atas dan bawah.
- `Image.PreserveAspectCrop`: skala seragam terbesar yang membuat gambar memenuhi kotak: max(0,65, 1) = 1. Hasilnya 200 × 100, lebih lebar daripada kotak 130, dan bagian lebihnya terpotong bila `clip: true`.
- `implicitWidth` dan `implicitHeight`: ukuran alami gambar (200 × 100), tak berubah oleh `width` dan `height` (4.2.2).
- `Timer`: gambar lokal dimuat sinkron, tetapi pengukuran sebaiknya dibaca setelah jeda singkat (3.3).

**Peragaan 2: lihat bedanya** (dengan jendela).

```qml
import QtQuick

Window {
    visible: true; width: 460; height: 140; color: '#202020'

    Image { x: 10;  y: 20; width: 130; height: 100; source: 'lebar.png'; fillMode: Image.Stretch }
    Image { x: 160; y: 20; width: 130; height: 100; source: 'lebar.png'; fillMode: Image.PreserveAspectFit }
    Image { x: 310; y: 20; width: 130; height: 100; source: 'lebar.png'; fillMode: Image.PreserveAspectCrop; clip: true }
}
```

Dugaan: papan catur kiri tampak melar, tengah utuh dengan jalur kosong di atas dan bawah, kanan terpotong di tepi kiri dan kanan `[uji]`.

**Opsi lain, menampilkan gambar pada kotak berukuran tetap:**

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Gambar utuh tanpa distorsi | `PreserveAspectFit` | Bisa menyisakan ruang kosong |
| Kotak penuh tanpa ruang kosong | `PreserveAspectCrop` + `clip: true` | Sebagian gambar hilang; `clip` punya biaya (4.1.4) |
| Ubin berulang | `Tile`, `TileHorizontally`, `TileVertically` | Tekstur latar |
| Tanpa penskalaan | `Pad` | Ukuran asli |
| Sudut membulat | `Rectangle` + efek penutup (fase lanjut) | Lebih mahal |

| Kesalahan | Solusi |
| --- | --- |
| `PreserveAspectCrop` tanpa `clip` lalu gambar meluap | Setel `clip: true`, atau jaga ukuran agar tak meluap |
| Mengisi `width` dan `height` dengan rasio yang salah lalu heran gambar melar | Pakai `PreserveAspectFit`, atau hitung rasio |
| Mengandalkan `width` untuk menurunkan memori | `width` hanya menskala tampilan. Pakai `sourceSize` (4.3.3) |

**Referensi:** [Image](https://doc.qt.io/qt-6/qml-qtquick-image.html) · [Qt Quick Examples: Image Elements](https://doc.qt.io/qt-6/qtquick-imageelements-example.html)

---

### 4.3.2 Pemuatan asinkron, status, dan cache

*Antarmuka yang tak membeku saat menunggu adalah antarmuka yang dihormati penggunanya.*

**Konsep.** Menurut dokumentasi:

- Secara bawaan, gambar yang tersedia secara lokal dimuat **segera**, dan antarmuka terblokir sampai selesai. Untuk gambar besar, `asynchronous: true` memuatnya di thread berprioritas rendah.
- `asynchronous` hanya berlaku untuk berkas di filesystem lokal. Gambar dari jaringan selalu dimuat asinkron, dengan `progress` dan `status` yang diperbarui.
- Gambar di-*cache* dan dibagi secara internal: bila beberapa `Image` punya `source` yang sama, hanya satu salinan dimuat.
- `cache` bernilai `true` secara bawaan. Menyetelnya `false` berguna untuk gambar besar agar tak menyingkirkan gambar UI kecil dari cache.
- `status` bernilai `Image.Null`, `Image.Loading`, `Image.Ready`, atau `Image.Error`. `progress` berjalan dari 0.0 sampai 1.0.
- Sejak Qt 6.8, `retainWhileLoading: true` mempertahankan gambar lama sampai yang baru siap saat `source` diganti dan pemuatan asinkron, sehingga tak berkedip. Harganya sedikit memori tambahan.

**Peragaan 1: urutan status.**

```qml
import QtQuick

Item {
    function nama(s) {
        return s === Image.Ready ? 'Ready'
             : s === Image.Loading ? 'Loading'
             : s === Image.Error ? 'Error' : 'Null'
    }

    Image {
        source: 'besar.png'; asynchronous: true; sourceSize.width: 600
        onStatusChanged: console.log('async  :', nama(status))
    }
    Image {
        source: 'tidak-ada.png'
        onStatusChanged: console.log('hilang :', nama(status))
    }
    Image {
        source: 'logo.png'
        onStatusChanged: console.log('lokal  :', nama(status))
    }

    Timer { interval: 1500; running: true; onTriggered: Qt.quit() }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml status.qml
```

Dugaan keluaran: `async  : Loading` lalu `async  : Ready`; `hilang : Error` (disertai peringatan bahwa berkas tak dapat dibuka); `lokal  : Ready`. Urutan antarbaris tak dijamin `[uji]`.

**Bedah kode:**

- `function nama(s)`: fungsi bantu yang menerjemahkan nilai `status` menjadi teks. `Image.Ready` dan kawan-kawannya adalah konstanta enumerasi milik tipe `Image`.
- `onStatusChanged`: handler yang jalan setiap `status` berubah. Di dalam handler, `status` adalah milik `Image` itu sendiri (3.4.1).
- `asynchronous: true`: pemuatan berjalan di thread terpisah, jadi kita melihat `Loading` sebelum `Ready`.
- `sourceSize.width: 600`: membatasi piksel yang disimpan (4.3.3).
- Gambar tak ada: statusnya langsung `Error`, tanpa `Loading`, karena berkas lokal diperiksa sinkron.
- `Timer ... Qt.quit()`: memberi waktu gambar asinkron selesai, lalu keluar.

**Peragaan 2: gambar cadangan saat gagal.**

```qml
Image {
    id: avatar
    readonly property url bawaan: Qt.resolvedUrl('avatar-bawaan.png')
    source: 'avatar-pengguna.png'
    onStatusChanged: if (status === Image.Error && source != bawaan) source = bawaan
}
```

- `readonly property url bawaan`: gambar cadangan, diubah menjadi URL absolut agar dapat dibandingkan dengan `source`.
- `source != bawaan`: pengaman agar tak berputar tanpa akhir bila gambar cadangan pun tak ada. Keduanya bertipe `url`, jadi perbandingannya sah (4.3.5).
- `source = bawaan` di dalam handler: penugasan imperatif yang memutus binding `source` (3.1.2). Bila `source` aslinya berupa binding, pakai pola lain, misalnya properti perantara.

**Progres untuk gambar jaringan:** `Text { text: Math.round(gambar.progress * 100) + '%' }` mengikuti `progress` secara reaktif. Tak dapat diuji offline, jadi `[uji]`.

**Opsi lain, strategi pemuatan:**

| Cara | Kapan |
| --- | --- |
| Bawaan (sinkron) | Gambar kecil yang selalu dibutuhkan saat tampil |
| `asynchronous: true` | Gambar besar di filesystem lokal |
| Sumber jaringan | Selalu asinkron; pantau `progress` dan `status` |
| `Loader { active: ... }` | Hindari membuat `Image` sampai dibutuhkan (3.3.5) |
| `retainWhileLoading: true` | Ganti `source` tanpa berkedip (Qt 6.8 ke atas) |
| `cache: false` | Gambar besar atau sekali pakai |

| Kesalahan | Solusi |
| --- | --- |
| Mengira `asynchronous` berlaku untuk jaringan | Jaringan selalu asinkron; propertinya hanya untuk lokal |
| Tata letak bergantung pada ukuran gambar yang belum siap | Tunggu `status === Image.Ready`, atau tentukan ukuran sendiri |
| Tak menangani `Image.Error` | Sediakan gambar cadangan dan catat galatnya |
| Memuat banyak gambar besar sinkron saat startup | Pakai `asynchronous` dan `Loader` |
| Gambar besar menyingkirkan ikon kecil dari cache | `cache: false` pada gambar besar |

**Referensi:** [Image: Performance, asynchronous, cache, status](https://doc.qt.io/qt-6/qml-qtquick-image.html) · [Qt Quick Examples: Image Elements](https://doc.qt.io/qt-6/qtquick-imageelements-example.html)

---

### 4.3.3 `sourceSize` dan memori

*Piksel yang tak pernah tampak tetap membayar sewa di memori.*

**Konsep.** `width` dan `height` hanya menskala **penggambaran** gambar. `sourceSize` menetapkan jumlah piksel maksimum yang **disimpan** untuk gambar yang dimuat, sehingga gambar besar tak memakai memori lebih dari yang perlu. Dokumentasi 6.12 menegaskan beberapa hal:

- Bila ukuran asli gambar lebih besar daripada `sourceSize`, gambar diskalakan turun saat dimuat.
- Bila hanya satu dimensi diisi (lebih dari 0), dimensi lain mengikuti rasio asli.
- Bila keduanya diisi, gambar diskalakan turun agar muat di dalam ukuran itu dengan rasio terjaga (untuk `PreserveAspectCrop` dan `PreserveAspectFit`, ke ukuran optimal untuk pemotongan atau pemuatan).
- Ukuran sebenarnya setelah penskalaan terbaca lewat `implicitWidth` dan `implicitHeight`.
- Untuk gambar vektor (SVG), `sourceSize` menentukan ukuran gambar yang dimuat tanpa memedulikan ukuran bawaannya. Hindari mengubahnya saat berjalan karena merender SVG itu lambat.
- Untuk gambar non-skalar seperti JPEG, hasilnya tak lebih besar daripada nilai itu, dan untuk beberapa format (saat ini hanya JPEG) seluruh gambar tak pernah benar-benar dimuat ke memori.
- Mengubah `sourceSize` saat berjalan memuat ulang sumbernya, bahkan dari jaringan bila tak ada di cache disk. Mengosongkannya ke ukuran alami dilakukan dengan `undefined`.

**Rumus kasar.** Gambar yang telah didekode umumnya menempati lebar × tinggi × 4 byte (satu piksel 32-bit), terlepas dari ukuran berkasnya di disk `[uji]`.

| Gambar | Piksel | Memori kira-kira |
| --- | --- | --- |
| 6000 × 4000 | 24.000.000 | 91,6 MiB |
| 1920 × 1080 | 2.073.600 | 7,9 MiB |
| 600 × 400 | 240.000 | 0,9 MiB |

**Peragaan 1: ukuran implisit (tanpa jendela).**

```qml
import QtQuick

Item {
    Image { id: penuh; source: 'besar.png' }
    Image { id: kecil; source: 'besar.png'; sourceSize.width: 600 }
    Image { id: skala; source: 'besar.png'; width: 600; height: 400 }

    Timer {
        interval: 800; running: true
        onTriggered: {
            console.log('penuh :', penuh.implicitWidth, penuh.implicitHeight)     // 6000 4000
            console.log('kecil :', kecil.implicitWidth, kecil.implicitHeight)     // 600 400
            console.log('skala :', skala.implicitWidth, skala.implicitHeight,
                        skala.width, skala.height)                              // 6000 4000 600 400
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml sourcesize.qml
```

Dugaan keluaran: `6000 4000`, `600 400`, lalu `6000 4000 600 400` `[uji]`.

**Bedah kode:**

- `Image { source: 'besar.png' }`: tanpa batas, gambar dimuat dalam ukuran penuh, 6000 × 4000.
- `sourceSize.width: 600`: hanya lebar diisi, sehingga tinggi mengikuti rasio (4000 × 600 / 6000 = 400). Gambar disimpan di memori sebagai 600 × 400.
- `width: 600; height: 400` pada `skala`: tampilannya sama kecilnya, tetapi `implicitWidth` dan `implicitHeight` tetap 6000 × 4000. Artinya seluruh gambar penuh tetap dimuat. Inilah beda `width` dan `sourceSize`.
- `implicitWidth`, `implicitHeight`: ukuran gambar setelah dimuat, sesuai dokumentasi.

**Peragaan 2: ukur memori dari terminal.**

```bash
cat > penuh.qml <<'EOF'
import QtQuick
Image { source: 'besar.png' }
EOF
cat > kecil.qml <<'EOF'
import QtQuick
Image { source: 'besar.png'; sourceSize.width: 600 }
EOF

for f in penuh kecil; do
    QT_QPA_PLATFORM=offscreen qml $f.qml &
    pid=$!
    sleep 3
    printf '%s: ' "$f"; grep VmRSS /proc/$pid/status
    kill $pid; wait $pid 2>/dev/null
done
```

Dugaan: nilai `VmRSS` untuk `penuh` lebih besar sekitar 90 MiB daripada `kecil` `[uji]`. Angka mutlaknya bergantung pada Qt, driver, dan platform.

**Bedah kode:**

- `cat > penuh.qml <<'EOF' ... EOF`: membuat berkas dari terminal. Tanda kutip pada `'EOF'` mencegah shell mengubah isinya.
- `QT_QPA_PLATFORM=offscreen qml $f.qml &`: menjalankan `qml` di latar belakang tanpa jendela nyata.
- `pid=$!`: menyimpan nomor proses yang baru dijalankan.
- `sleep 3`: memberi waktu gambar dimuat.
- `grep VmRSS /proc/$pid/status`: membaca memori fisik yang dipakai proses itu (*resident set size*) dari pseudo-berkas kernel.
- `kill $pid; wait $pid`: menghentikan proses dan menunggunya selesai.
- Bila `qml` ternyata skrip pembungkus di sistem Anda, `$!` menunjuk ke pembungkusnya dan angkanya menyesatkan `[uji]`. Periksa dengan `file $(which qml)`.

**`sourceClipRect`:** bila hanya sebagian gambar yang diperlukan, kombinasikan dengan `sourceSize`.

```qml
Image {
    source: 'peta-besar.png'
    sourceSize.width: 2048                          // skala dulu ke lebar 2048
    sourceClipRect: Qt.rect(100, 100, 512, 512)     // lalu ambil wilayah 512 x 512
}
```

`sourceSize` menentukan skala, `sourceClipRect` memotongnya. Dokumentasi mencatat bahwa sebagian format dapat menghemat CPU dengan merender wilayah itu saja, sedangkan format lain memuat seluruh gambar dulu lalu memotong. Mengubahnya saat berjalan juga memuat ulang sumber.

**Opsi lain, memilih `sourceSize`:**

| Kebutuhan | Pilihan |
| --- | --- |
| Thumbnail | `sourceSize.width` kecil dan tetap (misalnya 160) |
| Foto layar penuh | Ukuran layar (dikali rasio piksel perangkat bila ingin tajam di layar HiDPI) |
| Isi dari pengguna atau jaringan | Selalu batasi (4.3.8) |
| Ikon SVG | Ukuran tampil; jangan diubah saat berjalan |
| Hanya sebagian gambar | `sourceSize` + `sourceClipRect` |

| Kesalahan | Solusi |
| --- | --- |
| Memakai `width` dan `height` untuk menghemat memori | Itu hanya menskala tampilan. Pakai `sourceSize` |
| Mengikat `sourceSize` ke ukuran yang sering berubah | Setiap perubahan memuat ulang sumber. Pakai nilai tetap |
| Membiarkan foto 24 megapiksel dimuat penuh untuk thumbnail | Batasi dengan `sourceSize` |
| Menilai ukuran berkas di disk sebagai ukuran memori | PNG polos 80 KB bisa menjadi 91 MiB di memori |

**Referensi:** [Image: sourceSize, sourceClipRect](https://doc.qt.io/qt-6/qml-qtquick-image.html) · [QImageReader](https://doc.qt.io/qt-6/qimagereader.html)

---

### 4.3.4 `FontLoader` dan `font`

*Huruf adalah suara sebuah antarmuka. Pastikan Anda tahu dari mana suara itu berasal.*

**Konsep.** `FontLoader` memuat font berdasarkan nama atau URL. Fakta dari dokumentasi:

- `source` adalah URL font yang dimuat, dan `name` adalah nama keluarga font yang terisi otomatis saat Anda memuat lewat `source`.
- Pakai `name` untuk mengisi `font.family` pada `Text`.
- `status` bernilai `FontLoader.Null`, `Ready`, `Loading`, atau `Error`, berguna terutama untuk font dari sumber jarak jauh.
- Anda juga dapat memuat font yang sudah terpasang dengan menulis `name` saja.

Grup `font` pada `Text` menentukan tampilan huruf: `font.family`, `font.pixelSize` atau `font.pointSize` (pilih salah satu, 4.1.2), `font.bold`, `font.italic`, `font.underline`, `font.weight`, dan `font.letterSpacing`. Bila keluarga yang diminta tak ada, Qt memilih pengganti yang bergantung pada platform `[uji]`.

**Peragaan 1: apa yang tersedia di sistem (tanpa jendela).**

```qml
import QtQuick

Item {
    FontLoader { id: huruf; name: 'monospace' }

    Timer {
        interval: 200; running: true
        onTriggered: {
            const daftar = Qt.fontFamilies()
            console.log('jumlah keluarga:', daftar.length)
            console.log('contoh:', daftar.slice(0, 3).join(', '))
            console.log('FontLoader name:', huruf.name)        // monospace
            Qt.quit()
        }
    }
}
```

**Bedah kode:**

- `FontLoader { id: huruf; name: 'monospace' }`: memuat berdasarkan nama keluarga. Tak ada berkas yang dimuat.
- `Qt.fontFamilies()`: fungsi pada objek `Qt` yang mengembalikan daftar nama keluarga font yang tersedia.
- `daftar.slice(0, 3).join(', ')`: tiga nama pertama, digabung dengan koma. Keduanya adalah metode larik JavaScript.
- `huruf.name`: nama yang Anda isi. Hasilnya bergantung pada sistem Anda `[uji]`.

**Peragaan 2: memuat berkas font.** Salin sebuah font dari sistem Anda. Di Arch, `fontconfig` menyediakan alat yang diperlukan:

```bash
fc-list : family file | head -n 5
cp "$(fc-match -f '%{file}' monospace)" fontku.ttf
file fontku.ttf
```

Bila `fc-match` mengembalikan berkas bukan TTF atau OTF (misalnya `.pcf` atau `.ttc`), pilih salah satu dari keluaran `fc-list` yang berakhiran `.ttf`.

```qml
import QtQuick

Item {
    FontLoader { id: huruf; source: 'fontku.ttf' }

    Timer {
        interval: 300; running: true
        onTriggered: {
            console.log('siap:', huruf.status === FontLoader.Ready, '| keluarga:', huruf.name)
            Qt.quit()
        }
    }
}
```

Dugaan: `siap: true | keluarga: <nama keluarga berkas itu>` `[uji]`.

**Memakainya di `Text`:**

```qml
Text {
    text: 'Halo, Qt Quick'
    font.family: huruf.status === FontLoader.Ready ? huruf.name : 'sans-serif'
    font.pixelSize: 24
}
```

Binding `font.family` memilih keluarga yang dimuat bila siap, dan font cadangan bila belum. Karena `status` reaktif, teks berganti sendiri saat font selesai dimuat (3.1).

**Opsi lain, menyediakan font:**

| Cara | Kapan | Catatan |
| --- | --- | --- |
| Font sistem lewat `font.family` | Aplikasi sederhana | Tampilan bergantung pada mesin pengguna |
| `FontLoader` dengan `source` dari resource | Font yang dikemas bersama aplikasi | Disarankan: tampilan seragam dan sumber terkendali |
| `FontLoader` dengan `name` | Memastikan font terpasang tersedia | Tak menambah font baru |
| `FontLoader` dengan URL jaringan | Hindari | Berkas biner tak tepercaya diurai oleh pustaka font (4.3.8) |
| `QFontDatabase::addApplicationFont` (C++) | Memuat font saat startup dari kode | Fase 10 |

| Kesalahan | Solusi |
| --- | --- |
| Mengisi `font.family` sebelum font siap | Ikat ke `status` atau sediakan font cadangan |
| Mengira `FontLoader` mengganti font bawaan seluruh aplikasi | Ia hanya menyediakan font; Anda yang memilihnya lewat `font.family` |
| Memuat font dari URL yang tak tepercaya | Kemas font di resource |
| Mengatur `pixelSize` dan `pointSize` sekaligus | Pilih salah satu |

**Referensi:** [FontLoader](https://doc.qt.io/qt-6/qml-qtquick-fontloader.html) · [Qt Quick Examples: Text Fonts](https://doc.qt.io/qt-6/qtquick-text-fonts-example.html) · [Qt QML Type: fontFamilies](https://doc.qt.io/qt-6/qml-qtqml-qt.html)

---

### 4.3.5 URL dan `Qt.resolvedUrl`

*Alamat yang tepat adalah separuh dari menemukan barangnya.*

**Konsep.** Tipe `url` merujuk ke sebuah lokasi sumber daya. Fakta dari dokumentasi:

- URL boleh absolut (misalnya `http://qt-project.org`) atau relatif (`pics/logo.png`). URL relatif dihitung dari URL komponen yang memuatnya.
- Saat string relatif ditulis ke properti bertipe `url`, ia diubah menjadi objek URL. Karena itu membandingkan `source` dengan string aslinya bernilai `false`. Pakai `Qt.resolvedUrl()` untuk perbandingan dan `toString()` untuk membaca isinya.
- Untuk berkas di sistem resource Qt, QML memerlukan `qrc:///`, bukan `:/`. URL relatif yang dihitung dari dalam berkas resource memakai protokol yang sama.
- Karakter khusus dapat ditulis dengan *percent-encoding* (RFC 3986). Berkas bernama dengan `#` harus dienkode karena `#` dianggap awal fragmen URL.

**Peragaan 1: string bukan URL.**

```qml
import QtQuick

Image {
    id: logo
    source: 'logo.png'

    Component.onCompleted: {
        console.log(logo.source == 'logo.png')                       // false
        console.log(logo.source == Qt.resolvedUrl('logo.png'))       // true
        console.log(logo.source.toString())                          // file:///.../lab43/logo.png
        Qt.quit()
    }
}
```

Dugaan keluaran: `false`, `true`, lalu path absolut berawalan `file:///` `[uji]`.

**Bedah kode:**

- `source: 'logo.png'`: string relatif ditugaskan ke properti bertipe `url`, dan seketika menjadi objek URL absolut.
- `logo.source == 'logo.png'`: membandingkan objek URL dengan string mentah, hasilnya `false`.
- `Qt.resolvedUrl('logo.png')`: mengubah string yang sama menjadi URL absolut dengan aturan yang sama, sehingga perbandingannya `true`.
- `logo.source.toString()`: mengubah URL menjadi teks, yaitu path absolut lengkap dengan skemanya.

**Peragaan 2: relatif terhadap berkas yang menulisnya.** Siapkan struktur berikut.

```bash
mkdir -p widget
python3 ../gen_png.py widget/ikon.png 32 32
```

```qml
// widget/Ikon.qml
import QtQuick

Image {
    source: 'ikon.png'                                    // relatif ke widget/Ikon.qml
    Component.onCompleted: console.log('Ikon memuat:', source.toString())
}
```

```qml
// Main.qml
import QtQuick
import 'widget'

Item {
    Ikon { }
    Timer { interval: 200; running: true; onTriggered: Qt.quit() }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml Main.qml
```

Dugaan: `qml: Ikon memuat: file:///.../lab43/widget/ikon.png` `[uji]`. Jalur menuju `widget/`, bukan `lab43/`, walau `Main.qml` yang dijalankan.

**Bedah kode:**

- `import 'widget'`: impor direktori relatif. Tipe `Ikon` datang dari `widget/Ikon.qml`.
- `source: 'ikon.png'` di `Ikon.qml`: dihitung dari lokasi `Ikon.qml`, yaitu `widget/ikon.png`, bukan dari `Main.qml` dan bukan dari direktori kerja Anda.
- Pemindahan `Ikon.qml` ke folder lain mengubah arti path relatifnya. Itu sebabnya struktur resource dalam modul dijaga sama dengan struktur sumber (4.3.6).

**Skema URL yang dikenal:**

| Bentuk | Contoh | Catatan |
| --- | --- | --- |
| Relatif | `'images/logo.png'` | Dihitung dari berkas QML pemanggil; paling portabel |
| `file:///` | `'file:///home/pengguna/foto.png'` | Path absolut di mesin itu; tak portabel |
| `qrc:///` | `'qrc:///qt/qml/Lab43/images/logo.png'` | Sistem resource Qt; jangan pakai `:/` di QML |
| `https://` | `'https://contoh.org/a.png'` | Jaringan, selalu asinkron; batasi (4.3.8) |
| `image://` | `'image://penyedia/id'` | Penyedia gambar dari C++ (`QQuickImageProvider`, Fase 10) |

Untuk berkas yang namanya mengandung `#`, dokumentasi memberi contoh `Image { source: encodeURIComponent('/tmp/test#1.png') }` agar `#` tak dianggap fragmen.

| Kesalahan | Solusi |
| --- | --- |
| Memakai path absolut ke berkas lokal (`/home/saya/...`) | Pakai URL relatif atau resource |
| Membandingkan `source` dengan string | Pakai `Qt.resolvedUrl(...)` |
| Menulis `':/images/logo.png'` di QML | Tulis `qrc:///...` |
| Mengira path relatif dihitung dari direktori kerja | Dihitung dari berkas QML yang menulisnya |
| Memindahkan berkas QML tanpa memindahkan resource-nya | Jaga struktur tetap sama, atau perbarui path |

**Referensi:** [url (tipe dasar QML)](https://doc.qt.io/qt-6/qml-url.html) · [Qt QML Type: resolvedUrl](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Image: source](https://doc.qt.io/qt-6/qml-qtquick-image.html)

---

### 4.3.6 `RESOURCES` di CMake (prasyarat: Modul 10.1)

*Yang ikut terkemas ke dalam binary tak akan hilang di jalan.*

> **Prasyarat:** bagian ini memakai CMake dan C++ sebagai kerangka, yang dibahas utuh di **Modul 10.1**. Bila Anda belum sampai di sana, baca bagian ini sebagai pratinjau dan kembali mengerjakannya setelah 10.1.

**Konsep.** `qt_add_qml_module` mendefinisikan sebuah modul QML dan mengoordinasikan kompilasi `.qml` ke bytecode, penyematan resource, pemeriksaan `qmllint`, dan pembuatan berkas modul. Fakta dari dokumentasi:

- Bila `qt_standard_project_setup(REQUIRES 6.5)` dipanggil, kebijakan QTP0001 aktif dan `RESOURCE_PREFIX` bawaannya menjadi `/qt/qml/`, yang merupakan jalur impor bawaan mesin QML. Modul Anda tersedia di `qrc:/qt/qml/<URI>`.
- Berkas pada `QML_FILES` dan `RESOURCES` dikemas di bawah akar path yang sama. Path resource sebuah berkas ditentukan oleh path relatifnya terhadap direktori sumber saat ini (`CMAKE_CURRENT_SOURCE_DIR`).
- Karena struktur resource dijaga sama dengan struktur sumber, gambar yang ditulis sebagai path relatif dari berkas QML selalu ditemukan.
- `qt_add_qml_module` juga menjalankan `qmlcachegen` dan membuat target `<nama>_qmllint`.
- Memakai `RESOURCE_PREFIX` khusus tidak dianjurkan kecuali untuk menghindari bentrok nama modul pustaka pihak ketiga.

**Peragaan: proyek minimal.** Susun begini:

```
 proyek43/
   CMakeLists.txt
   main.cpp
   Main.qml
   images/logo.png
```

```bash
mkdir -p proyek43/images && cd proyek43
python3 ../gen_png.py images/logo.png 64 64
```

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.16)
project(App43 VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(app43 main.cpp)

qt_add_qml_module(app43
    URI Lab43
    VERSION 1.0
    QML_FILES Main.qml
    RESOURCES images/logo.png
)

target_link_libraries(app43 PRIVATE Qt6::Quick)
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
                     &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("Lab43", "Main");
    return app.exec();
}
```

```qml
// Main.qml
import QtQuick

Window {
    visible: true; width: 240; height: 160

    Image {
        anchors.centerIn: parent
        source: 'images/logo.png'
        Component.onCompleted: console.log(source)
    }
}
```

```bash
sudo pacman -S --needed qt6-base qt6-declarative cmake ninja
cmake -S . -B build -G Ninja
cmake --build build
./build/app43
cmake --build build --target app43_qmllint
```

Dugaan: jendela kecil dengan persegi oranye, dan log `qml: qrc:/qt/qml/Lab43/images/logo.png` `[uji]` (bentuk persis URL dapat sedikit berbeda).

**Bedah kode:**

- `find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)`: memuat Qt Quick dan, otomatis, Qt Qml yang mendefinisikan `qt_add_qml_module`.
- `qt_standard_project_setup(REQUIRES 6.5)`: menerapkan bawaan proyek Qt standar dan mengaktifkan QTP0001, sehingga prefix resource menjadi `/qt/qml/`.
- `qt_add_executable(app43 main.cpp)`: membuat target aplikasi.
- `qt_add_qml_module(app43 URI Lab43 ...)`: menjadikan aplikasi sebagai modul QML bernama `Lab43`. `QML_FILES` mendaftarkan berkas QML, `RESOURCES` mendaftarkan berkas non-QML seperti gambar.
- `RESOURCES images/logo.png`: menyematkan gambar di bawah akar yang sama, sehingga `'images/logo.png'` dari `Main.qml` menunjuk ke `qrc:/qt/qml/Lab43/images/logo.png`.
- `target_link_libraries(app43 PRIVATE Qt6::Quick)`: menautkan pustaka Qt Quick.
- `engine.loadFromModule("Lab43", "Main")`: memuat tipe `Main` dari modul `Lab43` (Qt 6.5 ke atas).
- `objectCreationFailed`: keluar dengan kode galat bila pemuatan gagal, agar tak diam-diam menggantung.
- `app43_qmllint`: target yang dibuat otomatis untuk menjalankan `qmllint` pada berkas `QML_FILES`.

```
 sumber (disk)             ->   resource (di dalam binary)
 Main.qml                       qrc:/qt/qml/Lab43/Main.qml
 images/logo.png                qrc:/qt/qml/Lab43/images/logo.png
  \_ path relatif dari CMakeLists.txt  \_ /qt/qml/ + URI Lab43 + path itu
```

**Jebakan “jalan di mesin saya”.** Bila Anda lupa mendaftarkan `RESOURCES`, `qml Main.qml` dari direktori sumber tetap menemukan gambar di filesystem, tetapi versi yang dibangun mencari di `qrc:` dan gagal dengan `Image.Error`. Selalu uji versi yang dibangun, dan pakai penanganan `Image.Error` dari 4.3.2.

**Opsi lain, menyertakan berkas ke dalam aplikasi:**

| Cara | Kapan | Catatan |
| --- | --- | --- |
| `RESOURCES` di `qt_add_qml_module` | Standar untuk proyek QML Qt 6 | Dianjurkan |
| `qt_add_resources` dengan berkas `.qrc` | Proyek yang lebih tua atau resource non-modul | Prefix perlu diatur sendiri |
| `QT_RESOURCE_ALIAS` pada berkas sumber | Berkas berada di direktori berbeda dari path resource yang diinginkan | Setel dengan `set_source_files_properties(... PROPERTIES QT_RESOURCE_ALIAS ...)` sebelum `qt_add_qml_module` `[uji]` |
| Berkas di luar binary (`file:///`) | Aset besar yang dikirim terpisah | Harus Anda sebarkan dan lindungi sendiri |

| Kesalahan | Solusi |
| --- | --- |
| Lupa mendaftarkan resource | Tambahkan ke `RESOURCES`, lalu uji versi yang dibangun |
| Tak memakai `qt_standard_project_setup(REQUIRES 6.5)` | Prefix resource tak mengikuti bawaan modern. Panggil dengan `REQUIRES` |
| Mengacu ke `:/...` di QML | Pakai path relatif atau `qrc:///...` |
| Struktur sumber dan resource tak sama | Jaga selaras, atau pakai `QT_RESOURCE_ALIAS` |

**Referensi:** [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [Building a QML application](https://doc.qt.io/qt-6/cmake-build-qml-application.html) · [The Qt Resource System](https://doc.qt.io/qt-6/resources.html)

---

### 4.3.7 Varian dan format `[TAMBAHAN]`

*Satu sumber, banyak layar. Pilih format yang melayani semuanya.*

**Konsep.** Beberapa hal tentang `Image` yang dicatat dokumentasi tetapi tak ada di kurikulum:

- **Sintaks `@nx` untuk resolusi tinggi.** Anda dapat menyediakan varian beresolusi tinggi dengan penamaan seperti `logo@2x.png` di samping `logo.png`. Qt memilih varian yang sesuai dengan rasio piksel layar, melalui mekanisme yang sama dengan `QImageReader`. Penjelasan lengkapnya ada di halaman `QImageReader` `[uji]`.
- **SVG.** Untuk gambar vektor, `sourceSize` menentukan ukuran raster. Atur ke ukuran tampil dan jangan ubah saat berjalan karena merender SVG lambat.
- **Gambar beranimasi.** Dokumentasi menunjuk ke `AnimatedImage` dan `AnimatedSprite`. `Image` sendiri punya `frameCount` dan `currentFrame` untuk gambar berbingkai banyak.
- **EXIF.** `autoTransform` (bawaan `false`) menerapkan metadata orientasi seperti EXIF. Foto dari ponsel sering tampak terputar tanpanya.
- **Deteksi ekstensi otomatis (sejak Qt 5.11).** Bila `source` menunjuk ke berkas lokal atau resource yang tak ada, `Image` mencoba menambahkan ekstensi gambar yang didukung.
- **Tekstur terkompresi.** `PKM`, `KTX`, dan `ASTC` didukung bila driver grafis mendukungnya. Ini topik lanjut.
- **`smooth` dan `mipmap`.** `smooth` (bawaan `true`) menghaluskan saat diskalakan. `mipmap` memberi kualitas lebih baik saat memperkecil, dengan biaya inisialisasi dan render.

**Peragaan 1: deteksi ekstensi (tanpa jendela).**

```qml
import QtQuick

Item {
    Image { id: a; source: 'logo' }            // tak ada berkas bernama logo, tetapi ada logo.png
    Image { id: b; source: 'logo.png' }

    Timer {
        interval: 300; running: true
        onTriggered: {
            console.log('a siap:', a.status === Image.Ready, a.implicitWidth)   // true 64
            console.log('b siap:', b.status === Image.Ready, b.implicitWidth)   // true 64
            Qt.quit()
        }
    }
}
```

Dugaan: dua baris `true 64` `[uji]`. Praktis, tetapi mengaburkan berkas mana yang sebenarnya dimuat. Untuk aplikasi yang menuntut kepastian, tulis nama lengkap.

**Peragaan 2: SVG pada ukuran berbeda.**

```bash
cat > ikon.svg <<'EOF'
<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'>
  <circle cx='50' cy='50' r='40' fill='orange'/>
</svg>
EOF
```

```qml
import QtQuick

Item {
    Image { id: kecil; source: 'ikon.svg'; sourceSize.width: 48;  sourceSize.height: 48 }
    Image { id: besar; source: 'ikon.svg'; sourceSize.width: 480; sourceSize.height: 480 }
    Image { id: asli;  source: 'ikon.svg' }

    Timer {
        interval: 500; running: true
        onTriggered: {
            console.log(kecil.implicitWidth, besar.implicitWidth, asli.implicitWidth)   // 48 480 100
            Qt.quit()
        }
    }
}
```

Dugaan keluaran: `48 480 100` `[uji]`. Bila `status` berakhir `Error` untuk SVG, pasang dukungan SVG Qt (di Arch: `sudo pacman -S qt6-svg`) `[uji]`.

**Bedah kode:**

- `<svg ... width='100' height='100'>`: gambar vektor berukuran bawaan 100 × 100, berisi satu lingkaran.
- `sourceSize.width: 48; sourceSize.height: 48`: SVG dirender pada 48 × 48 piksel, tajam pada ukuran itu.
- `sourceSize` 480 × 480: dirender ulang pada 480 × 480, tetap tajam karena vektor, tetapi menempati memori sekitar 100 kali lebih banyak.
- Tanpa `sourceSize`: dirender pada ukuran bawaannya.

**Opsi lain, format gambar:**

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Foto | JPEG | Beberapa format tak dimuat penuh bila `sourceSize` dibatasi |
| Grafik dengan transparansi | PNG | Tak berkehilangan |
| Ikon yang harus tajam di semua ukuran | SVG + `sourceSize` | Jangan ubah dinamis |
| Layar HiDPI | Varian `@2x` | Qt memilih otomatis `[uji]` |
| Animasi | `AnimatedImage` | Fase lanjut |
| Foto dari ponsel | `autoTransform: true` | Menerapkan orientasi EXIF |

| Kesalahan | Solusi |
| --- | --- |
| Foto ponsel tampak terputar | Setel `autoTransform: true` |
| Ikon SVG buram | Setel `sourceSize` ke ukuran tampil |
| Mengubah `sourceSize` SVG tiap kali jendela berubah | Pakai ukuran tetap, atau debounce |
| Mengandalkan deteksi ekstensi di produksi | Tulis nama lengkap |

**Referensi:** [Image](https://doc.qt.io/qt-6/qml-qtquick-image.html) · [QImageReader: high resolution versions](https://doc.qt.io/qt-6/qimagereader.html#high-resolution-versions-of-images) · [AnimatedImage](https://doc.qt.io/qt-6/qml-qtquick-animatedimage.html)

---

### 4.3.8 Keamanan dan batas sumber daya `[TAMBAHAN]`

*Gambar adalah data dari luar. Perlakukan ia seperti masukan apa pun yang tak Anda tulis sendiri.*

**Konsep.** Dokumentasi `Image` menyebut gambar sebagai pengguna memori terbesar di antarmuka QML, dan meminta agar gambar yang bukan bagian UI dibatasi ukurannya lewat `sourceSize`, terutama untuk konten dari sumber luar atau dari pengguna. Dari sudut pandang keamanan, ada lima permukaan yang perlu dijaga.

**1. Bom dekompresi.** Berkas kecil bisa mengembang menjadi memori besar saat didekode. Qt menyediakan pengaman bawaan di `QImageReader`: batas alokasi 256 MB (bisa diubah dengan `QImageReader::setAllocationLimit` atau variabel lingkungan `QT_IMAGEIO_MAXALLOC`, dalam MB, dengan 0 berarti tanpa batas). Gambar yang melebihinya ditolak dengan pesan `qt.gui.imageio: QImageIOHandler: Rejecting image as it exceeds the current allocation limit of 256 megabytes`. Laporan pengguna Qt menunjukkan batas itu cukup untuk sekitar 85 megapiksel RGB 24-bit `[uji]`.

**Percobaan:**

```bash
python3 ../gen_png.py raksasa.png 12000 9000     # 333 KB di disk, sekitar 309 MiB bila didekode
```

```qml
import QtQuick

Item {
    Image {
        source: 'raksasa.png'; sourceSize.width: 600
        onStatusChanged: console.log('raksasa:',
            status === Image.Error ? 'Error' : status === Image.Ready ? 'Ready' : 'lain')
    }
    Timer { interval: 2000; running: true; onTriggered: Qt.quit() }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml raksasa.qml
QT_IMAGEIO_MAXALLOC=0 QT_QPA_PLATFORM=offscreen qml raksasa.qml     # hanya untuk percobaan
```

Dugaan: pada proses pertama, `qml: raksasa: Error` disertai pesan penolakan di atas. Pada proses kedua, batas dimatikan dan gambar mungkin dimuat, dengan memori besar `[uji]`. Skrip pembuat gambar itu sudah saya jalankan: berkasnya 333 KB, dan 12000 × 9000 × 3 byte ≈ 309 MiB, di atas batas 256 MB. Jangan menaikkan batas ini untuk masukan yang tak tepercaya. Batas itu adalah jaring pengaman Anda.

**2. Sumber yang dikendalikan penyerang.** `Image.source` menerima URL dari skema apa pun yang didukung Qt. Bila nilainya berasal dari masukan pengguna atau data jarak jauh, penyerang dapat memicu permintaan keluar (pelacakan atau pemindaian jaringan internal) atau meraba keberadaan berkas lokal. Pakai daftar izin (*allow-list*), bukan daftar larangan:

```qml
import QtQuick

Item {
    function sumberAman(teks) {
        const u = String(teks)
        return u.startsWith('qrc:/') || u.startsWith('https://gambar.contoh.org/')
    }

    Component.onCompleted: {
        const uji = [
            'qrc:/qt/qml/Lab43/images/logo.png',
            'https://gambar.contoh.org/a.png',
            'https://gambar.contoh.org.jahat.example/a.png',
            'https://gambar.contoh.org@jahat.example/a.png',
            'file:///etc/passwd',
            'http://gambar.contoh.org/a.png'
        ]
        for (const u of uji)
            console.log(sumberAman(u) ? 'BOLEH' : 'TOLAK', u)
        Qt.quit()
    }
}
```

Dugaan: baris 1 dan 2 `BOLEH`, baris 3 sampai 6 `TOLAK` `[uji]`.

**Bedah kode:**

- `String(teks)`: memastikan nilai dibandingkan sebagai teks, apa pun tipenya.
- `startsWith('https://gambar.contoh.org/')`: garis miring di akhir sangat penting. Tanpanya, `https://gambar.contoh.org.jahat.example/` lolos karena awalannya sama.
- Kasus `...org@jahat.example`: setelah `org` datang `@`, bukan `/`, jadi ditolak. Bagian sebelum `@` dalam URL adalah informasi pengguna, bukan host.
- `for (const u of uji)`: perulangan atas setiap elemen larik.
- Pemeriksaan awalan teks adalah penjaga kasar. Untuk validasi yang lebih kokoh, uraikan URL dengan objek `URL` lalu bandingkan `protocol` dan `hostname` secara terpisah `[uji]`.

**3. Font dan sumber jarak jauh lain.** Font adalah berkas biner yang diurai oleh pustaka font. Pemuatan lewat `FontLoader` dari URL jaringan memperluas permukaan serangan. Kemas font di resource (4.3.4).

**4. Teks kaya yang memuat gambar.** Seperti dicatat di 4.1.2, `Text` bawaan dapat memuat gambar lewat jaringan bila ia menebak isinya sebagai markup. Untuk isi tak tepercaya, setel `textFormat: Text.PlainText`.

**5. Resource tertanam bukan rahasia.** Isi `qrc:` tertanam di binary dan dapat diekstrak oleh siapa pun yang memegang berkasnya. Jangan menyimpan kunci API atau data rahasia sebagai resource.

**Pertahanan berlapis, ringkasan:**

| Risiko | Pengendali |
| --- | --- |
| Bom dekompresi | `sourceSize`, batas alokasi bawaan Qt, jangan naikkan untuk masukan luar |
| Permintaan keluar atau pemindaian | Daftar izin skema dan host; filter di tingkat mesin lewat C++ (Fase 10 dan keamanan) |
| Font berbahaya | Hanya font dari resource |
| Teks kaya yang memuat gambar | `textFormat: Text.PlainText` |
| Konsumsi memori berulang | `cache: false` untuk gambar sekali pakai; `asynchronous` untuk masukan pengguna |
| Rahasia di resource | Jangan disimpan sebagai resource |

| Kesalahan | Solusi |
| --- | --- |
| Mengikat `Image.source` langsung ke teks pengguna | Validasi dengan daftar izin, atau tampilkan gambar bawaan |
| Menaikkan `QT_IMAGEIO_MAXALLOC` agar sebuah berkas terbuka | Naikkan hanya di proses yang Anda kendalikan dan untuk berkas tepercaya |
| Mengira ukuran berkas = ukuran memori | PNG 80 KB bisa menjadi 91 MiB; PNG 333 KB bisa menjadi 309 MiB |
| Awalan terlalu longgar pada daftar izin | Sertakan `/` penutup dan uji kasus `@` dan subdomain mirip |
| Menyimpan rahasia di resource | Taruh di penyimpanan rahasia sistem |

**Referensi:** [Image: Performance](https://doc.qt.io/qt-6/qml-qtquick-image.html) · [QImageReader: setAllocationLimit](https://doc.qt.io/qt-6/qimagereader.html#setAllocationLimit) · [Text: textFormat warning](https://doc.qt.io/qt-6/qml-qtquick-text.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** tambahkan satu gambar sebagai resource modul, tampilkan dengan `sourceSize` kecil, dan bandingkan pemakaian memori dengan dan tanpa `sourceSize`.

**Langkah A: perbandingan memori tanpa CMake.** Kerjakan Peragaan 2 di 4.3.3 (`penuh.qml` melawan `kecil.qml`) dan catat dua angka `VmRSS`. Untuk pembanding dasar, ukur juga sebuah berkas kosong:

```bash
cat > kosong.qml <<'EOF'
import QtQuick
Item { }
EOF
QT_QPA_PLATFORM=offscreen qml kosong.qml &
pid=$!; sleep 3; grep VmRSS /proc/$pid/status; kill $pid; wait $pid 2>/dev/null
```

**Langkah B: sebagai resource modul** (setelah Modul 10.1). Di `proyek43`, buat gambar besar dan daftarkan:

```bash
python3 ../gen_png.py images/besar.png 6000 4000
```

Ubah `CMakeLists.txt`: `RESOURCES images/logo.png images/besar.png`. Ganti isi `Main.qml`:

```qml
import QtQuick

Window {
    visible: true; width: 600; height: 400

    Image {
        anchors.fill: parent
        source: 'images/besar.png'
        sourceSize.width: 600            // hapus baris ini untuk perbandingan
        fillMode: Image.PreserveAspectFit
    }
}
```

```bash
cmake --build build
./build/app43 &
pid=$!; sleep 3; grep VmRSS /proc/$pid/status; kill $pid; wait $pid 2>/dev/null
```

Ulangi tanpa baris `sourceSize.width: 600`. Isi tabel berikut dengan angka Anda:

| Skenario | VmRSS (KiB) |
| --- | --- |
| Berkas kosong (pembanding dasar) |  |
| Dengan `sourceSize.width: 600` |  |
| Tanpa `sourceSize` |  |

**Kunci:**

- Secara teori selisihnya mendekati 6000 × 4000 × 4 − 600 × 400 × 4 = 95.040.000 byte, sekitar 90,6 MiB. Angka nyata bervariasi menurut Qt, driver, dan platform `[uji]`, tetapi urutan besarnya (puluhan MiB) harus terlihat.
- Selisih terhadap pembanding dasar menunjukkan biaya gambar itu sendiri, terlepas dari biaya Qt.
- Bila selisihnya kecil, kemungkinan `$!` menunjuk ke proses pembungkus. Periksa dengan `pgrep -a app43`.
- Ingat 4.3.3: `width: 600` tanpa `sourceSize` tidak menurunkan memori, karena seluruh gambar penuh tetap dimuat.

**Cek pemahaman (dari kurikulum):** *Mengapa `sourceSize` penting untuk gambar besar?* Karena gambar didekode menjadi sekitar lebar × tinggi × 4 byte di memori, terlepas dari ukuran berkasnya. `width` dan `height` hanya menskala penggambaran, sedangkan `sourceSize` membatasi piksel yang disimpan. Dokumentasi menyebut gambar sebagai pengguna memori terbesar di UI QML dan menekankan pembatasan untuk konten dari sumber luar atau pengguna.

**Pertanyaan tambahan:**

1. *Apa beda `width: 600` dan `sourceSize.width: 600`?* Yang pertama menskala penggambaran, yang kedua membatasi piksel yang disimpan di memori.
2. *Mengapa `logo.source == 'logo.png'` bernilai `false`?* Nilai itu sudah menjadi objek URL absolut. Bandingkan dengan `Qt.resolvedUrl('logo.png')`.
3. *Dari mana path relatif dihitung?* Dari URL berkas QML yang menulisnya, bukan dari direktori kerja.
4. *Apa arti `asynchronous: true` untuk URL `https`?* Tak berpengaruh: gambar jaringan selalu dimuat asinkron. Properti itu hanya untuk berkas lokal.
5. *Kapan `cache: false` berguna?* Untuk gambar besar atau sekali pakai, agar tak menyingkirkan gambar UI kecil dari cache.
6. *Mengapa `qrc:///` dan bukan `:/` di QML?* QML memerlukan path berbentuk URL, dan URL relatif dari berkas resource memakai protokol yang sama.
7. *Mengapa prefix `/qt/qml/` bergantung pada `qt_standard_project_setup(REQUIRES 6.5)`?* Panggilan itu mengaktifkan kebijakan QTP0001 yang menetapkan prefix bawaan.
8. *Mengapa awalan daftar izin harus diakhiri `/`?* Tanpanya `https://gambar.contoh.org.jahat.example/` lolos karena awalannya sama.
9. *Bagaimana berkas 80 KB dapat memakai 91 MiB?* Kompresi PNG sangat efektif pada gambar polos, tetapi hasil dekode tetap lebar × tinggi × 4 byte.

**Tantangan:**

- Daftarkan sebuah font di `RESOURCES`, muat dengan `FontLoader`, dan pastikan `status` bernilai `Ready` pada versi yang dibangun.
- Tulis ulang `sumberAman` memakai objek `URL` (`protocol` dan `hostname`), lalu uji dengan keenam kasus di 4.3.8 `[uji]`.
- Tambahkan gambar cadangan ke `Image` dari 4.3.2 dan pastikan ia hanya dipakai sekali saat gambar utama gagal.

---

## F. Glosarium Modul 4.3

| Istilah | Arti |
| --- | --- |
| Resource | Berkas yang dikemas ke dalam binary dan diakses lewat `qrc:` |
| `qrc` | Skema URL untuk sistem resource Qt; di QML ditulis `qrc:///` |
| URL relatif | URL yang dihitung dari URL komponen yang menuliskannya |
| Tipe `url` | Tipe dasar QML untuk lokasi sumber daya; string relatif diubah menjadi objek URL |
| `Qt.resolvedUrl` | Mengubah string relatif menjadi URL absolut menurut berkas pemanggil |
| `status` | Keadaan pemuatan: `Null`, `Loading`, `Ready`, `Error` |
| `asynchronous` | Memuat gambar lokal di thread terpisah |
| `cache` | Berbagi salinan gambar yang sama antar `Image` |
| `fillMode` | Cara gambar menyesuaikan diri dengan kotak tampilan |
| `paintedWidth` / `paintedHeight` | Ukuran gambar yang benar-benar digambar |
| `sourceSize` | Batas piksel yang disimpan untuk gambar yang dimuat |
| `sourceClipRect` | Wilayah gambar sumber yang dimuat |
| `VmRSS` | Memori fisik yang dipakai proses, dibaca dari `/proc/PID/status` |
| `FontLoader` | Tipe untuk memuat font dari nama atau URL |
| Keluarga font (*font family*) | Nama yang dipakai `font.family` untuk memilih huruf |
| `qt_add_qml_module` | Perintah CMake yang mendefinisikan modul QML |
| `RESOURCES` | Argumen `qt_add_qml_module` untuk berkas non-QML yang disematkan |
| QTP0001 | Kebijakan CMake Qt yang menetapkan prefix resource bawaan `/qt/qml/` |
| `QT_RESOURCE_ALIAS` | Properti berkas untuk menetapkan path resource yang berbeda dari path sumber |
| `@nx` | Penamaan varian resolusi tinggi, misalnya `logo@2x.png` |
| EXIF | Metadata gambar, termasuk orientasi; diterapkan dengan `autoTransform` |
| Bom dekompresi | Berkas kecil yang mengembang menjadi memori sangat besar saat didekode |
| `QT_IMAGEIO_MAXALLOC` | Variabel lingkungan batas alokasi gambar, dalam MB |
| Daftar izin (*allow-list*) | Daftar sumber yang diizinkan; semua yang lain ditolak |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
| --- | --- |
| **3.1** Property Binding | `font.family` terikat ke `status` `FontLoader`; menugaskan `source` dari JS memutus binding-nya |
| **3.3** Lifecycle | `Loader` menghindari pembuatan `Image` sebelum perlu; baca `status` setelah jeda, bukan langsung di `onCompleted` |
| **3.4** Scope dan konteks | `Qt.resolvedUrl` bekerja menurut berkas pemanggil; handler `onStatusChanged` membaca `status` milik `Image` itu sendiri |
| **4.1** Item dan primitif | `Image` adalah primitif visual; `clip` dan `PreserveAspectCrop`; peringatan `textFormat` pada `Text` |
| **4.2** Geometri dan anchors | `implicitWidth` dan `implicitHeight` `Image`; `fillMode` dan `anchors.fill` menentukan tata letak gambar |
| **4.4** Input dasar | Tombol bergambar dan area sentuh dibangun dari `Image` plus handler |
| **10.1** C++ dan CMake | **Prasyarat 4.3.6**; `qt_add_qml_module` dan `loadFromModule` dibahas utuh di sana |
| **Fase 10 selanjutnya** | `QQuickImageProvider` (`image://`), `QFontDatabase`, dan pembatasan jaringan di tingkat mesin |
| **Keamanan** | Daftar izin sumber, batas alokasi, font dari resource, dan rahasia tak boleh di resource |

**Penutup Modul 4.3:** Anda kini dapat memuat gambar dan font dengan benar, memahami dari mana sebuah URL berasal, membatasi biaya memori gambar, mengemas resource ke dalam modul, dan memperlakukan sumber dari luar dengan curiga yang sehat. Modul berikutnya, dan yang terakhir di Fase 4, adalah 4.4 — Input Dasar: Pointer, Tap, dan Keyboard.

---

**Catatan tautan:** Fakta pada halaman Image (6.12) tentang `qt_add_qml_module` (6.12) dan pola proyek di Building a QML application (6.7 dan 6.8), tipe `url` (Qt 5.x sampai 6.1), `FontLoader` (Qt 5.x), objek `Qt` (6.3), dan batas alokasi gambar (laporan pengguna Qt dan KDE yang mengutip dokumentasi `QImageReader`) saya baca lewat hasil pencarian, jadi tandai `[uji]` pada versi Anda. Skrip `gen_png.py` sudah saya jalankan: `besar.png` valid, 79.884 byte di disk, 6000 × 4000 piksel; `raksasa.png` valid, 333.337 byte, 12000 × 9000 piksel. Halaman The Qt Resource System, QImageReader, AnimatedImage, Text Fonts example, dan Image Elements example tidak saya buka satu per satu. Nama paket Arch (`qt6-base`, `qt6-declarative`, `qt6-svg`, `cmake`, `ninja`) dan format `fc-match` saya tulis dari pengetahuan umum dan tidak saya verifikasi dalam sesi ini. Bila ada yang tidak terbuka, kabari saya.

# Fase 4 · Modul 4.4 — Input Dasar: Pointer, Tap, dan Keyboard

*Penutup Fase 4. Melanjutkan Modul 4.3.*

<!-- Saya membaca bagian Modul 4.4 dari kurikulum Fase 4 yang Anda kirim, lalu mengaudit isinya terhadap dokumentasi Qt 6.12 (Important Concepts In Qt Quick - User Input, Keyboard Focus in Qt Quick, Qt Quick Input Handlers), Qt 6.11 (Mouse Events), serta halaman `Keys`, `TapHandler`, `TestCase`, dan Qt Quick Test dari beberapa versi Qt 6 lewat hasil pencarian. Seperti sebelumnya, saya tidak menjalankan kode ini pada Qt, jadi bagian bertanda `[uji]` perlu Anda buktikan sendiri. -->

---

## A. Audit singkat

**Terverifikasi:**

- Input handler bersifat non-visual, hemat memori, dan dirancang dipakai dalam jumlah banyak: satu handler per aspek interaksi, bekerja atas nama item induknya, dan satu item boleh punya handler tak terbatas. Analogi kurikulum tentang “pengintai” tepat.
- Dokumentasi menyebut input handler sebagai cara yang lebih modern untuk menangani semua perangkat penunjuk. `MouseArea` awalnya dirancang untuk mouse, lalu belakangan juga menangani sentuhan tunggal lewat event mouse sintetis.
- `TapHandler` bawaannya memakai `gesturePolicy: DragThreshold`, yang hanya membutuhkan *passive grab*, sehingga tak mengganggu pengiriman event ke item atau handler lain. Klaim kurikulum bahwa pengintai “tidak mengganggu pengintai lain” benar untuk handler, tetapi tidak untuk `MouseArea` (4.4.4).
- Event keyboard dikirim ke item yang memegang *active focus*. Bila tak ada, event diabaikan. Bila item menerimanya, propagasi berhenti; bila tidak, event naik ke induk sampai ke akar.
- Contoh kurikulum sah: `TapHandler { id: tap; onTapped: ... }` dengan `tap.pressed`, dan `Keys.onPressed: (event) => { ... }` dengan parameter eksplisit.
- Jawaban cek pemahaman benar: tanpa fokus aktif, tombol tak sampai ke item.

**Perlu dikoreksi atau dilengkapi:**

1. **`focus: true` bukan jaminan fokus aktif.** Dalam satu *focus scope* hanya satu item yang memegang fokus, dan QML tak menjamin urutan inisialisasi. Pada komponen yang dipakai ulang, `focus: true` bisa kalah. Contoh kurikulum aman hanya karena ada satu item. Perlu `FocusScope` dan pembedaan `focus` dari `activeFocus`. Diperluas di 4.4.3.
2. **Contoh `Keys.onPressed` tak menyetel `event.accepted`.** Dokumentasi: bila Anda menangani tombol, setel `event.accepted = true` agar tak merambat ke induk. Handler tombol spesifik (misalnya `onReturnPressed`) otomatis menerimanya. Masuk 4.4.3 dan 4.4.4.
3. **`Shortcut` untuk pintasan tingkat jendela.** Kalimat “keluar saat Q ditekan” lebih tepat dengan `Shortcut` bila pintasan harus berlaku tanpa memandang item mana yang berfokus. Masuk 4.4.3 `[uji]`.
4. **Urutan pemrosesan `Keys`.** Secara bawaan (`Keys.BeforeItem`) handler `Keys` berjalan sebelum penanganan bawaan item (misalnya `TextInput`). Kurikulum tak menyebutnya. Masuk 4.4.4.
5. **`TapHandler` lebih dari `onTapped`.** `tapCount`, `doubleTapped`, `longPressed`, `acceptedButtons` (bawaan tombol kiri), `acceptedDevices`, `acceptedModifiers`, dan `gesturePolicy` (`ReleaseWithinBounds` untuk perilaku tombol sungguhan). Diperluas di 4.4.2.
6. **`MouseArea`: `hoverEnabled` bawaannya `false`.** Tanpanya `containsMouse` hanya benar saat tombol ditekan, dan `entered`, `exited`, serta `positionChanged` tak aktif. Masuk 4.4.1.
7. **Pointer vs sentuhan (4.4.5)** perlu dua fakta: `MouseArea` hanya menangani sentuhan tunggal lewat event sintetis, dan `HoverHandler` hanya untuk mouse dan tablet (layar sentuh tak punya hover).
8. **Menguji input dari terminal tak dibahas.** Padahal Qt Quick Test dapat mensimulasikan klik dan tombol tanpa jendela terlihat. TAMBAHAN 4.4.6.
9. **Keamanan input tak dibahas.** Overlay penelan klik, `Keys.forwardTo` dan `priority`, perebutan fokus, pintasan global, dan pencatatan tombol. TAMBAHAN 4.4.7.

**TAMBAHAN:**

- **4.4.6** Menguji input dari terminal.
- **4.4.7** Keamanan dan desain input.

---

## B. Daftar isi Modul 4.4 (diperbarui)

- **4.4.1** `MouseArea` `[diperluas]`
- **4.4.2** `TapHandler` dan `HoverHandler` `[diperluas]`
- **4.4.3** Fokus, `Keys`, dan `Shortcut` `[diperluas]`
- **4.4.4** Propagasi dan penerimaan event `[diperluas]`
- **4.4.5** Pointer vs sentuhan `[diperluas]`
- **4.4.6** Menguji input dari terminal `[TAMBAHAN]`
- **4.4.7** Keamanan dan desain input `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 4.4.1 → 4.4.2 → 4.4.3 → 4.4.4 → 4.4.5 → 4.4.6 → 4.4.7.

---

## C. Peta besar

```
 Perangkat: mouse, layar sentuh, stylus, keyboard
      |
      v  event
 Window
      |
      +-- POINTER (berdasarkan RUANG: siapa yang ada di bawah titik sentuh)
      |     item dari z TERATAS ke bawah. Pada tiap item:
      |       1. handler anak (TapHandler, HoverHandler, ...)
      |       2. item itu sendiri (MouseArea, Flickable, ...)
      |     berhenti di item yang mengambil exclusive grab
      |
      +-- KEYBOARD (berdasarkan FOKUS: siapa yang sedang “berbicara”)
            item dengan ACTIVE FOCUS
               | tak menerima? naik ke induk -> induk -> ... -> akar
               v tak ada yang menerima: event diabaikan
```

**Filosofinya:** input adalah percakapan antara perangkat dan antarmuka. Event pointer berjalan menurut **ruang**: yang berada di atas titik sentuh didengar lebih dulu. Event keyboard berjalan menurut **fokus**: hanya yang sedang memegang fokus didengar. Memahami dua jalur ini memecahkan sebagian besar keluhan “mengapa input saya tak jalan”. Handler memisahkan perilaku dari tampilan: item menyatakan *seperti apa ia tampak*, handler menyatakan *apa yang ia lakukan*, dan keduanya dirakit dari bagian-bagian kecil.

**Cara menjalankan contoh:** contoh interaktif memerlukan jendela nyata: `qml nama.qml`. Pengujian tanpa jendela dengan Qt Quick Test ada di 4.4.6.

---

## D. Materi

### 4.4.1 `MouseArea`

*Setiap interaksi dimulai dari sebuah area yang mau mendengarkan.*

**Konsep.** `MouseArea` adalah item tak terlihat yang menerima event mouse di dalam areanya. Cara tercepat menentukan area adalah `anchors.fill: parent`. Area yang lebih kecil atau lebih besar daripada induk juga boleh. Menurut dokumentasi, ia memancarkan sinyal `canceled`, `clicked`, `doubleClicked`, `entered`, `exited`, `positionChanged`, `pressAndHold`, `pressed`, dan `released`. Parameter handler adalah objek `MouseEvent` (misalnya `mouse.button`), dan `mouse.accepted` mengendalikan penerusan event.

Beberapa gestur harus diaktifkan lebih dulu:

- `acceptedButtons` menentukan tombol mouse yang didengar (bawaan: tombol kiri).
- `hoverEnabled` (bawaan `false`) mengaktifkan event posisi walau tak ada tombol ditekan, sekaligus sinyal `entered`, `exited`, dan `positionChanged`. Tanpanya, `containsMouse` hanya memberi nilai benar saat tombol ditekan.
- `enabled: false` mematikan seluruh area.

**Peragaan: tombol dengan hitungan** (dengan jendela).

```qml
import QtQuick

Window {
    visible: true; width: 320; height: 160

    Rectangle {
        id: tombol
        anchors.centerIn: parent
        width: 160; height: 60; radius: 8
        color: area.pressed ? 'darkorange' : area.containsMouse ? 'gold' : 'orange'

        property int hitung: 0

        Text { anchors.centerIn: parent; text: 'Klik: ' + tombol.hitung }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: (mouse) => {
                tombol.hitung += (mouse.button === Qt.RightButton ? 10 : 1)
            }
        }
    }
}
```

```bash
qml mousearea.qml
```

Dugaan: persegi berubah emas saat kursor masuk, jingga tua saat ditekan; klik kiri menambah 1 dan klik kanan menambah 10 `[uji]`.

**Bedah kode:**

- `property int hitung: 0`: properti milik `Rectangle`, tempat hitungan disimpan. Teks di dalamnya mengikat ke properti itu (3.1).
- `MouseArea { anchors.fill: parent }`: area yang menutupi seluruh persegi. Tanpa ukuran, `MouseArea` tak punya area untuk menerima event (4.1.1).
- `hoverEnabled: true`: tanpanya `area.containsMouse` hanya benar saat tombol ditekan, sehingga warna emas saat melayang tak muncul.
- `acceptedButtons: Qt.LeftButton | Qt.RightButton`: tanda `|` menggabungkan dua nilai bendera. Tanpa tombol kanan di daftar ini, klik kanan diabaikan.
- `cursorShape: Qt.PointingHandCursor`: bentuk kursor saat berada di atas area.
- `onClicked: (mouse) => { ... }`: handler dengan parameter eksplisit (3.2.1). `mouse.button` menyebut tombol mana yang menekan.
- `area.pressed`, `area.containsMouse`: properti reaktif milik `MouseArea` yang dipakai `color` di induknya (3.4.4).

**Opsi lain, merespons klik:**

| Cara | Kapan | Catatan |
| --- | --- | --- |
| `MouseArea` | Interaksi mouse sederhana, kode lama | Sentuhan hanya tunggal dan sintetis |
| `TapHandler` | Kode baru, semua perangkat penunjuk | 4.4.2 |
| `Button` dari Qt Quick Controls | Tombol standar dengan tampilan dan aksesibilitas | Fase kontrol |

| Kesalahan | Solusi |
| --- | --- |
| `MouseArea` tanpa ukuran | Pakai `anchors.fill: parent`, atau beri `width` dan `height` |
| Heran `containsMouse` tak berubah saat melayang | Setel `hoverEnabled: true` |
| Klik kanan tak dikenali | Tambahkan `Qt.RightButton` ke `acceptedButtons` |
| Menaruh logika berat langsung di `onClicked` | Panggil fungsi singkat; pekerjaan berat dipindah dan dijadwalkan (3.3.4) |
| Menumpuk `MouseArea` dan heran yang di bawah tak menerima | Lihat 4.4.4 |

**Referensi:** [Mouse Events](https://doc.qt.io/qt-6/qtquick-input-mouseevents.html) · [MouseArea](https://doc.qt.io/qt-6/qml-qtquick-mousearea.html) · [MouseEvent](https://doc.qt.io/qt-6/qml-qtquick-mouseevent.html)

---

### 4.4.2 `TapHandler` dan `HoverHandler`

*Satu handler untuk satu aspek interaksi: kecil, mudah dibaca, mudah dihapus.*

**Konsep.** Input handler adalah tipe non-visual yang ditaruh di dalam sebuah item dan menangani event atas nama item itu. Daftar lengkapnya menurut dokumentasi: `DragHandler`, `HoverHandler`, `KeyNavigation`, `Keys`, `PinchHandler`, `PointHandler`, `TapHandler`, dan `WheelHandler`. Beberapa handler menambah interaktivitas hanya dengan dideklarasikan. Semuanya memiliki properti yang dapat dipakai dalam binding dan sinyal yang dapat ditangani.

**`TapHandler`** (dokumentasi Qt 6):

- Menangani ketukan di layar sentuh dan klik mouse.
- Gestur ketukan yang sah bergantung pada `gesturePolicy`. Bawaannya `TapHandler.DragThreshold`: tekan dan lepas harus berdekatan dalam ruang dan waktu. Ia memakai *passive grab*, jadi tak mengganggu item atau handler lain.
- `TapHandler.ReleaseWithinBounds` cocok untuk perilaku tombol sungguhan: bila Anda menekan lalu berubah pikiran, menyeret keluar dari tepi membatalkan klik.
- `acceptedButtons` bawaannya `Qt.LeftButton`. `acceptedDevices` dan `acceptedModifiers` membatasi perangkat dan tombol pengubah (Ctrl, Alt, Shift).
- Sinyal: `tapped`, `singleTapped`, `doubleTapped`, `longPressed`, `canceled`, dan `grabChanged`. Properti `tapCount` menghitung ketukan beruntun, dan `pressed` bernilai benar selama titik ditekan. `longPressThreshold` (dalam detik) menentukan lama tekan untuk `longPressed`.
- Ketukan ganda dan seterusnya mengikuti jarak dan selang waktu klik ganda dari pengaturan sistem (`QStyleHints`).

**`HoverHandler`** menangani hover mouse dan tablet. Properti utamanya `hovered`, dan `cursorShape` mengatur bentuk kursor.

**Peragaan: tombol dengan tiga jenis ketukan** (dengan jendela).

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 200

    Rectangle {
        id: kotak
        anchors.centerIn: parent
        width: 160; height: 80; radius: 8
        color: tap.pressed ? 'darkorange' : hover.hovered ? 'gold' : 'orange'
        border.width: 2
        border.color: tap.pressed ? 'black' : 'transparent'

        Text { anchors.centerIn: parent; text: 'ketukan: ' + tap.tapCount }

        HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }

        TapHandler {
            id: tap
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: console.log('tap, jumlah:', tapCount)
            onDoubleTapped: console.log('dobel-tap')
            onLongPressed: console.log('tekan lama')
        }
        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: console.log('klik kanan')
        }
    }
}
```

```bash
qml tap.qml
```

Dugaan: kursor menjadi tangan dan persegi emas saat melayang; klik kiri mencatat `tap, jumlah: 1`; klik kiri dua kali cepat mencatat `dobel-tap`; menahan tombol lebih lama dari `longPressThreshold` mencatat `tekan lama`; klik kanan mencatat `klik kanan` `[uji]`.

**Bedah kode:**

- `HoverHandler { id: hover; cursorShape: ... }`: pengintai hover untuk item induk (`kotak`). `hover.hovered` bernilai `true` saat kursor di atas.
- `color: tap.pressed ? 'darkorange' : hover.hovered ? 'gold' : 'orange'`: dua ekspresi kondisional bersarang. Binding membaca dua handler yang berbeda (3.1.1).
- `TapHandler { id: tap; gesturePolicy: TapHandler.ReleaseWithinBounds }`: perilaku tombol: menyeret keluar sebelum melepas membatalkan ketukan.
- `onTapped: console.log('tap, jumlah:', tapCount)`: di dalam handler, `tapCount` dibaca dari `TapHandler` itu sendiri (3.4.1).
- `onDoubleTapped`, `onLongPressed`: sinyal untuk ketukan ganda dan tekan lama.
- `TapHandler { acceptedButtons: Qt.RightButton }`: handler kedua yang hanya menanggapi tombol kanan. Dokumentasi memberi contoh yang sama: dua handler pada satu item untuk menanggapi klik kiri dan kanan secara berbeda.
- Handler tak punya ukuran dan tak digambar. Area aktifnya adalah area item induknya.

**`DragHandler`** (pratinjau): dengan hanya dideklarasikan, ia membuat item induknya dapat diseret.

```qml
Rectangle {
    width: 80; height: 80; color: 'steelblue'
    DragHandler { xAxis.minimum: 0; xAxis.maximum: 280; yAxis.enabled: false }
}
```

Batasan sumbu (`xAxis.minimum`, `xAxis.maximum`, `yAxis.enabled`) `[uji]` pada versi Anda. Ketiga handler dibahas lebih dalam di fase gestur.

**Modifier dan perangkat:** dokumentasi memberi contoh handler yang hanya aktif bila Ctrl ditekan:

```qml
Item {
    TapHandler { acceptedModifiers: Qt.ControlModifier; onTapped: console.log('ctrl-klik') }
    TapHandler { acceptedModifiers: Qt.NoModifier; onTapped: console.log('klik biasa') }
}
```

**Opsi lain, memilih handler:**

| Kebutuhan | Pilihan |
| --- | --- |
| Klik atau ketuk | `TapHandler` |
| Melayang | `HoverHandler` |
| Menyeret item | `DragHandler` |
| Cubit untuk zoom dan putar | `PinchHandler` |
| Satu titik sentuh mentah | `PointHandler` |
| Roda mouse | `WheelHandler` |
| Tombol keyboard | `Keys`, `KeyNavigation`, `Shortcut` (4.4.3) |

| Kesalahan | Solusi |
| --- | --- |
| Mengharap `TapHandler` bersuara untuk tombol kanan | `acceptedButtons` bawaannya hanya kiri |
| Perilaku tombol yang tak bisa dibatalkan dengan menyeret keluar | Setel `gesturePolicy: TapHandler.ReleaseWithinBounds` |
| Mencampur `MouseArea` dan `TapHandler` pada item yang sama tanpa tujuan | Pilih satu untuk aspek yang sama |
| `HoverHandler` untuk fitur yang harus ada di layar sentuh | Layar sentuh tak punya hover (4.4.5) |

**Referensi:** [Qt Quick Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [TapHandler](https://doc.qt.io/qt-6/qml-qtquick-taphandler.html) · [HoverHandler](https://doc.qt.io/qt-6/qml-qtquick-hoverhandler.html) · [DragHandler](https://doc.qt.io/qt-6/qml-qtquick-draghandler.html)

---

### 4.4.3 Fokus, `Keys`, dan `Shortcut`

*Tombol yang ditekan tak pernah tersesat. Ia hanya sampai ke yang sedang memegang fokus.*

**Konsep.** Alur penanganan tombol menurut dokumentasi 6.12:

1. Qt menerima aksi tombol dan membuat event tombol.
2. Bila sebuah `QQuickWindow` adalah *focus window* aplikasi, event dikirim ke jendela itu.
3. Scene mengirim event ke `Item` yang memegang *active focus*. Bila tak ada item berfokus aktif, event diabaikan.
4. Bila item itu menerima event, propagasi berhenti. Bila tidak, event dikirim ke induknya, terus naik sampai diterima atau akar tercapai.
5. Bila akar tercapai, event diabaikan dan penanganan tombol Qt yang biasa berlanjut.

`Item.activeFocus` menunjukkan apakah sebuah item memegang fokus aktif. Sebuah item meminta fokus dengan menyetel `focus: true`.

**Mengapa `focus: true` saja tak cukup.** Untuk kasus sederhana itu cukup. Namun pada komponen yang dipakai ulang, dokumentasi menunjukkan masalahnya: hanya satu item yang bisa memegang fokus keyboard, dan bila beberapa item menyetel `focus: true` sekaligus, yang terakhir menyetel yang menang. Karena QML tak menjamin properti elemen mana yang diinisialisasi lebih dulu, hasilnya bisa berubah-ubah. Komponen yang diimpor tak bisa mengendalikan fokus di lingkungan pemakainya, dan pemakainya tak tahu apakah komponen itu meminta fokus.

**Focus scope** menyelesaikannya, dan dokumentasi menyebutnya setara *focus proxy* otomatis. Aturannya:

- Di dalam tiap focus scope, satu objek boleh menyetel `focus: true`. Bila lebih dari satu, yang terakhir menang.
- Saat sebuah focus scope menerima fokus aktif, objek di dalamnya yang menyetel `focus` ikut mendapat fokus aktif. Scope dan item di dalamnya sama-sama memiliki `activeFocus`.
- Bila sebuah item melepas fokus (menyetel `focus: false` saat berfokus aktif), sistem tak otomatis memilih item lain. Boleh jadi tak ada fokus aktif sama sekali.
- `FocusScope` bukan tipe visual, sehingga properti visual anaknya (ukuran, posisi) perlu diteruskan ke luar agar tata letak induk bekerja.
- `ListView`, `PathView`, dan `GridView` adalah focus scope, sehingga delegate-nya dapat bereaksi pada tombol tanpa mengganggu bagian aplikasi lain.

**Peragaan 1: contoh kurikulum, diperbaiki** (dengan jendela).

```qml
import QtQuick

Window {
    visible: true; width: 320; height: 160

    Item {
        id: papan
        anchors.fill: parent
        focus: true

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Q) {
                Qt.quit()
                event.accepted = true
            }
        }
        Keys.onEscapePressed: console.log('Esc ditekan')
    }
}
```

```bash
qml tombol.qml
```

Dugaan: tekan Esc dan terminal mencatat `qml: Esc ditekan`; tekan Q dan aplikasi keluar `[uji]`.

**Bedah kode:**

- `focus: true`: `papan` meminta fokus. Karena hanya satu item di sini, ia mendapatkannya. `anchors.fill: parent` memberinya ukuran, walau fokus sendiri tak memerlukan ukuran.
- `Keys.onPressed: (event) => { ... }`: `Keys` adalah atribut terlampir (3.4.4). `onPressed` menangani setiap tombol, dan `event` adalah objek `KeyEvent`.
- `event.key === Qt.Key_Q`: `Qt.Key_Q` adalah konstanta kode tombol Q. Tiga tanda sama membandingkan nilai dan tipe.
- `event.accepted = true`: menandai tombol sudah ditangani agar tak merambat ke induk. Dokumentasi meminta ini bila Anda menangani tombol.
- `Keys.onEscapePressed`: handler untuk satu tombol khusus. Dokumentasi menyatakan handler spesifik seperti ini otomatis menyetel `event.accepted` menjadi `true`.

**Peragaan 2: dua komponen dengan `FocusScope`** (dengan jendela).

```qml
import QtQuick

Window {
    visible: true; width: 260; height: 80

    component Papan: FocusScope {
        id: scope
        property alias warna: rect.color
        width: 100; height: 60

        Rectangle {
            id: rect
            anchors.fill: parent
            focus: true                                  // fokus di dalam scope ini
            border.width: scope.activeFocus ? 4 : 0
            border.color: 'black'
            Keys.onPressed: (event) => console.log('tombol', event.text, 'di', rect.color)
        }
    }

    Papan { id: kiri;  x: 10;  y: 10; warna: 'lightblue'; focus: true }
    Papan { id: kanan; x: 130; y: 10; warna: 'palegreen' }

    Timer {
        interval: 300; running: true
        onTriggered: {
            console.log('awal   :', kiri.focus, kanan.focus)       // true false
            kanan.forceActiveFocus()
            console.log('sesudah:', kiri.focus, kanan.focus)       // false true
            Qt.quit()
        }
    }
}
```

Dugaan keluaran: `awal   : true false` lalu `sesudah: false true` `[uji]`. Bila Anda menghapus `Timer` dan menjalankannya dengan jendela, tombol yang Anda ketik tercatat dengan warna komponen yang berfokus, dan bingkai hitam tampak pada komponen itu.

**Bedah kode:**

- `component Papan: FocusScope { ... }`: komponen sebaris yang diturunkan dari `FocusScope`. Setiap instans menjadi focus scope sendiri.
- `property alias warna: rect.color`: pintu ke warna `Rectangle` di dalam (3.4.2).
- `focus: true` pada `Rectangle` di dalam `Papan`: meminta fokus **dalam scope** itu, bukan dalam seluruh jendela. Karena ada dua scope, kedua `Rectangle` tak berebut.
- `Papan { focus: true }` untuk `kiri`: meminta fokus pada tingkat jendela untuk scope pertama. Hanya satu `Papan` yang menyetelnya.
- `scope.activeFocus`: benar bila scope ini dan rantai induknya memegang fokus aktif.
- `kanan.forceActiveFocus()`: metode `Item` yang memindahkan fokus aktif ke item itu. Setelahnya `kiri.focus` menjadi `false` dan `kanan.focus` menjadi `true`.
- Dua baris log membaca `focus`, bukan `activeFocus`, karena `activeFocus` juga bergantung pada apakah jendelanya aktif di sistem. Pada platform `offscreen` hal ini dapat berbeda `[uji]`.

**`Shortcut` untuk pintasan tingkat jendela.** Bila pintasan harus berlaku tanpa memandang item mana yang berfokus, `Shortcut` lebih tepat daripada `Keys`:

```qml
import QtQuick

Window {
    visible: true; width: 320; height: 160

    Shortcut {
        sequence: 'Ctrl+Q'                  // atau: sequence: StandardKey.Quit
        onActivated: Qt.quit()
    }
}
```

`Shortcut` dan pengaturan `context`-nya (jendela atau seluruh aplikasi) perlu Anda periksa pada versi Qt Anda `[uji]`. Lihat 4.4.7 untuk risiko pintasan tingkat aplikasi.

**`KeyNavigation`.** Atribut terlampir yang memetakan tombol panah dan Tab ke item berikutnya, tanpa kode JavaScript:

```qml
Item {
    Rectangle { id: a; focus: true; KeyNavigation.right: b }
    Rectangle { id: b; KeyNavigation.left: a }
}
```

Dokumentasi menyebutnya mendukung navigasi dengan tombol panah. Detail properti `KeyNavigation` `[uji]`.

**Opsi lain, menangani tombol:**

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Tombol saat item tertentu berfokus | `Keys.onPressed` atau handler spesifik | Perlu fokus aktif |
| Satu tombol khusus (Enter, Esc, panah, spasi) | `Keys.onReturnPressed`, `onEscapePressed`, ... | Otomatis `accepted` |
| Pintasan yang berlaku di seluruh jendela | `Shortcut` | Tak bergantung item berfokus |
| Pindah fokus dengan panah atau Tab | `KeyNavigation` | Tanpa JavaScript |
| Mengetik teks | `TextInput`, `TextEdit` | Menerima tombol sendiri |

| Kesalahan | Solusi |
| --- | --- |
| `focus: true` tetapi tombol tak sampai | Periksa `activeFocus`. Mungkin item lain yang menang atau jendela tak aktif |
| Dua komponen yang dipakai ulang sama-sama `focus: true` | Bungkus dengan `FocusScope`; yang terakhir menyetel yang menang |
| Menangani tombol tanpa `event.accepted = true` | Setel `true`, atau pakai handler spesifik |
| Menaruh `Keys` di item yang tak pernah berfokus | Event tak akan sampai. Beri fokus atau pakai `Shortcut` |
| Mengira melepas fokus memilih item lain otomatis | Tidak. Bisa jadi tak ada fokus aktif |

**Referensi:** [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [KeyNavigation](https://doc.qt.io/qt-6/qml-qtquick-keynavigation.html) · [FocusScope](https://doc.qt.io/qt-6/qml-qtquick-focusscope.html) · [Shortcut](https://doc.qt.io/qt-6/qml-qtquick-shortcut.html)

---

### 4.4.4 Propagasi dan penerimaan event

*Event bergerak mengikuti aturan. Pelajari aturannya, dan Anda bisa memprediksi siapa yang mendengar.*

**Event pointer: menurut ruang.** Menurut dokumentasi input handler:

- Event tekan mouse dan sentuh dikirim dengan mengunjungi item dalam urutan z dari atas ke bawah. Pada tiap item, **handler anaknya dikunjungi dulu, lalu item itu sendiri**.
- Sebuah item hanya dapat mengambil *exclusive grab*: event berikutnya (gerak dan lepas) hanya dikirim ke dia. Handler punya mekanisme tambahan, yaitu *passive grab*. Handler pasif dijamin menerima pembaruan dan pelepasan walau item atau handler lain mengambil grab jenis apa pun.
- Sebagian handler hanya bisa pasif, sebagian membutuhkan exclusive, dan sebagian “mengintai” secara pasif sampai gestur terdeteksi lalu beralih ke exclusive. Perilaku `TapHandler` dapat diatur lewat `gesturePolicy`.

**Akibat praktisnya:** `MouseArea` yang menerima tekan mengambil exclusive grab, sehingga item di bawahnya tak lagi dikunjungi. Handler yang pasif tak menghalangi siapa pun.

**Percobaan: dua item bertumpuk** (dengan jendela, klik di berbagai tempat).

```qml
import QtQuick

Window {
    visible: true; width: 300; height: 200

    Rectangle {
        id: bawah
        x: 20; y: 20; width: 200; height: 140; color: 'steelblue'
        MouseArea { anchors.fill: parent; onClicked: console.log('MouseArea BAWAH') }
        TapHandler { onTapped: console.log('TapHandler BAWAH') }
    }
    Rectangle {
        id: atas
        x: 100; y: 60; width: 160; height: 100; color: 'tomato'
        MouseArea { anchors.fill: parent; onClicked: console.log('MouseArea ATAS') }
        TapHandler { onTapped: console.log('TapHandler ATAS') }
    }
}
```

Dugaan: klik di bagian biru yang tidak tertutup mencatat `TapHandler BAWAH` dan `MouseArea BAWAH`. Klik di area tumpang tindih mencatat hanya `TapHandler ATAS` dan `MouseArea ATAS` (urutan keduanya tak dijamin), dan item `bawah` tak mendengar apa-apa karena `MouseArea ATAS` mengambil exclusive grab sehingga kunjungan berhenti `[uji]`.

**Bedah kode:**

- `atas` dideklarasikan setelah `bawah`, jadi digambar di atasnya dan dikunjungi lebih dulu.
- Pada tiap item, `TapHandler` (handler anak) dikunjungi lebih dulu daripada `MouseArea` (item itu sendiri), sesuai dokumentasi.
- `TapHandler` memakai passive grab, sehingga ia tak menghentikan kunjungan ke `MouseArea` pada item yang sama.
- `MouseArea` menerima tekan dan mengambil exclusive grab. Kunjungan berhenti, sehingga item di bawahnya tak menerima event tekan itu.
- Mengubah z (4.2.5) atau urutan deklarasi akan membalik siapa yang berada di atas.

**Meneruskan klik ke bawah.** Bila `MouseArea` di atas harus membiarkan klik sampai ke bawahnya, ia punya `propagateComposedEvents` untuk event gabungan (`clicked`, `doubleClicked`, `pressAndHold`):

```qml
MouseArea {
    anchors.fill: parent
    propagateComposedEvents: true
    onClicked: (mouse) => { console.log('ATAS melihat klik'); mouse.accepted = false }
}
```

`mouse.accepted = false` menandai bahwa area ini tak menerima klik itu sehingga diteruskan ke area di bawahnya. Perilaku `propagateComposedEvents` perlu Anda uji pada versi Anda `[uji]`. Tekan dan lepas mentah tetap hanya ke area teratas.

**Event keyboard: menurut fokus dan urutan pemrosesan `Keys`.** `Keys` dapat diatur lewat dua properti:

- `Keys.forwardTo`: daftar item yang ikut menerima event tombol.
- `Keys.priority`: `Keys.BeforeItem` (bawaan) atau `Keys.AfterItem`.

Urutan pemrosesan untuk `Keys.BeforeItem` (bawaan), menurut dokumentasi:

1. Item-item di `forwardTo`.
2. Handler tombol spesifik, misalnya `onReturnPressed`.
3. Handler `onPressed` dan `onReleased`.
4. Penanganan bawaan item itu, misalnya penanganan tombol `TextInput`.
5. Item induk.

Untuk `Keys.AfterItem`, penanganan bawaan item (langkah 4) dipindahkan ke urutan paling awal. Bila event diterima di langkah mana pun, propagasi berhenti, dan item yang menerima event lewat `forwardTo` tak meneruskannya ke item berikutnya dalam daftar.

**Percobaan: propagasi tombol** (dengan jendela, ketik `a` lalu `b`).

```qml
import QtQuick

Window {
    visible: true; width: 240; height: 120

    Item {
        id: induk
        anchors.fill: parent
        Keys.onPressed: (event) => console.log('INDUK menerima', event.text)

        Item {
            id: anak
            focus: true
            Keys.onPressed: (event) => {
                console.log('ANAK menerima', event.text)
                if (event.text === 'a') event.accepted = true      // hanya 'a' dihentikan
            }
        }
    }
}
```

Dugaan: tekan `a` mencatat `ANAK menerima a` saja. Tekan `b` mencatat `ANAK menerima b` lalu `INDUK menerima b`, karena tak diterima dan naik ke induk `[uji]`.

**Bedah kode:**

- `anak` memegang fokus (`focus: true`), jadi ia menerima tombol lebih dulu.
- `event.accepted = true` hanya untuk `a`: propagasi berhenti di `anak`. Untuk `b`, `accepted` tetap `false`, sehingga event naik ke `induk`.
- `induk` tak berfokus, tetapi tetap dikunjungi sebagai bagian dari rantai ke akar. Fokus menentukan siapa yang pertama, bukan siapa yang boleh mendengar.
- Menaruh `Keys` di induk adalah cara umum menangkap tombol “sisa” yang tak ditangani anak.

```
 Pointer (menurut ruang)               Keyboard (menurut fokus)
  item teratas                          item dengan active focus
   |- handler anak (pasif/aktif)         |- forwardTo, handler spesifik, onPressed
   |- item itu sendiri                   |- penanganan bawaan item
   v tak diterima? lanjut ke bawah       v tak diterima? naik ke induk
  item di bawahnya                      induk ... akar -> diabaikan
   berhenti di exclusive grab            berhenti di event yang diterima
```

| Kesalahan | Solusi |
| --- | --- |
| Heran `MouseArea` di bawah tak menerima klik | `MouseArea` atas mengambil exclusive grab. Atur z, atau pakai `propagateComposedEvents` |
| Mengira semua handler saling mengganggu | `TapHandler` bawaan pasif dan tak menghalangi yang lain |
| Tombol “bocor” ke induk | Setel `event.accepted = true` di handler yang menangani |
| Handler `Keys` induk tak menerima tombol yang ditangani anak | Itu perilaku benar: yang diterima anak tak naik |
| Lupa bahwa urutan `Keys` bawaan mendahului penanganan item | Pakai `Keys.priority: Keys.AfterItem` bila item harus menangani lebih dulu |

**Referensi:** [Qt Quick Input Handlers: Pointer Grab](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [Keys: Key Handling Priorities](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [Mouse Events](https://doc.qt.io/qt-6/qtquick-input-mouseevents.html)

---

### 4.4.5 Pointer vs sentuhan

*Satu jari bukan satu kursor. Rancanglah untuk keduanya.*

**Konsep.** Dokumentasi menjelaskan dua generasi penanganan perangkat penunjuk:

- `MouseArea` awalnya dirancang untuk mouse. Belakangan ia juga menangani sentuhan **tunggal** dalam bentuk event mouse sintetis, untuk antarmuka sentuh yang sederhana.
- Input handler menangani gestur (ketuk, seret) **dari perangkat mana pun**, dan juga dapat memperlakukan kelas perangkat berbeda dengan cara berbeda.

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Klik atau ketuk saja | `TapHandler` | Berlaku untuk mouse, sentuh, dan stylus |
| Klik mouse berbeda dari ketuk sentuh | `TapHandler` dengan `acceptedDevices` | Dua handler |
| Melayang | `HoverHandler` | Hanya mouse dan tablet |
| Cubit untuk zoom dan putar | `PinchHandler` | Multi-sentuh |
| Menyeret | `DragHandler` | Semua perangkat |
| Roda mouse | `WheelHandler` | Mouse dan touchpad |
| Kode lama dengan sentuhan tunggal | `MouseArea` | Sentuhan hanya sintetis |

**Peragaan: perilaku berbeda per perangkat.** Dokumentasi `TapHandler` memberi pola ini:

```qml
Item {
    TapHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        onTapped: console.log('klik')
    }
    TapHandler {
        acceptedDevices: PointerDevice.TouchScreen
        onTapped: console.log('ketuk')
    }
}
```

**Bedah kode:**

- `acceptedDevices`: bendera kelas perangkat yang boleh mengaktifkan handler. `|` menggabungkan mouse dan stylus.
- Dua `TapHandler` pada satu item: yang pertama hanya mendengar mouse dan stylus, yang kedua hanya layar sentuh. Hasilnya `klik` di komputer dan `ketuk` di layar sentuh.
- Nama enumerasi `PointerDevice` perlu Anda periksa pada versi Qt 6 Anda `[uji]`.

**Area sentuh lebih besar tanpa mengubah tampilan.** `TapHandler` punya properti `margin`, yaitu jarak di luar batas item induk yang masih dapat mengaktifkan handler `[uji]`:

```qml
Rectangle {
    width: 32; height: 32; color: 'steelblue'
    TapHandler { margin: 12; onTapped: console.log('kena') }
}
```

Jari lebih lebar daripada kursor, dan pedoman antarmuka umum (bukan dari dokumentasi Qt) menyarankan area sentuh sekitar 44 hingga 48 piksel. Dengan `margin`, ikon 32 piksel tetap rapi tetapi mudah diketuk.

**Aturan desain:**

- Jangan menyembunyikan hal penting di balik hover. Layar sentuh tak punya hover, jadi informasi atau tombol yang hanya muncul saat melayang tak terjangkau.
- Sediakan padanan untuk klik kanan di sentuh: tekan lama (`TapHandler.longPressed`).
- Uji di kedua jenis perangkat, atau dengan pengujian otomatis (4.4.6).

| Kesalahan | Solusi |
| --- | --- |
| Mengandalkan `MouseArea` untuk gestur multi-sentuh | Pakai `PinchHandler` atau `PointHandler` |
| Fitur penting hanya muncul saat hover | Sediakan jalur ketuk atau tekan lama |
| Area sentuh sekecil kursor | Perbesar item atau pakai `margin` pada handler |
| Mengira `HoverHandler` bekerja di layar sentuh | Hover hanya untuk mouse dan tablet |

**Referensi:** [Qt Quick Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [TapHandler: acceptedDevices](https://doc.qt.io/qt-6/qml-qtquick-taphandler.html) · [Mouse Events](https://doc.qt.io/qt-6/qtquick-input-mouseevents.html)

---

### 4.4.6 Menguji input dari terminal `[TAMBAHAN]`

*Percobaan yang bisa diulang adalah satu-satunya bukti yang pantas dipercaya.*

**Konsep.** Qt Quick Test (`import QtTest`) adalah kerangka uji unit untuk QML. Menurut dokumentasi:

- Uji ditulis sebagai fungsi JavaScript di dalam `TestCase`. Fungsi yang namanya diawali `test_` dijalankan sebagai kasus uji. `name` menjadi awalan nama di keluaran.
- `compare(aktual, harapan)` dan `verify(kondisi)` memeriksa hasil. `SignalSpy` mencatat pemancaran sinyal.
- `keyPress`, `keyRelease`, dan `keyClick` mensimulasikan keyboard. Event dikirim ke item QML yang sedang berfokus, dan Anda boleh memberi kode `Qt.Key_*` atau satu karakter latin1.
- `mousePress`, `mouseRelease`, `mouseClick`, `mouseDoubleClickSequence`, dan `mouseMove` mensimulasikan mouse.
- Event keyboard dan mouse hanya dapat dikirim setelah jendela utama tampil. Pakai `when: windowShown`; mengirim sebelumnya gagal.
- `createTemporaryObject` membuat objek yang dijamin dihancurkan di akhir fungsi uji.
- Menjalankan kasus uji Qt Quick selalu menampilkan jendela, bahkan bila uji tak melibatkan UI. Untuk menghindarinya, jalankan dengan `-platform offscreen`.

Cara menjalankannya: uji diluncurkan oleh *harness* C++ (`QUICK_TEST_MAIN`). Opsi baris perintahnya meliputi `-input` (menjalankan satu berkas atau direktori uji), `-import` (menambah jalur impor QML), `-functions` (daftar fungsi uji), dan `-help`. Instalasi Qt Anda mungkin juga menyertakan alat siap pakai `qmltestrunner` yang menjalankan berkas `tst_*.qml` tanpa harness buatan sendiri `[uji]`.

**Peragaan: membuktikan 4.4.3 dan 4.4.4 tanpa jendela.** Simpan sebagai `tst_input.qml`.

```qml
import QtQuick
import QtTest

Item {
    id: root
    width: 320; height: 240

    property int bawahKlik: 0
    property int atasKlik: 0
    property int tapBawah: 0
    property string tombolTerakhir: ''
    property int indukTerima: 0

    Rectangle {
        id: bawah
        x: 20; y: 20; width: 200; height: 140; color: 'steelblue'
        MouseArea { anchors.fill: parent; onClicked: root.bawahKlik++ }
        TapHandler { onTapped: root.tapBawah++ }
    }
    Rectangle {
        id: atas
        x: 100; y: 60; width: 160; height: 100; color: 'tomato'
        MouseArea { anchors.fill: parent; onClicked: root.atasKlik++ }
    }

    Item {
        id: indukKunci
        Keys.onPressed: (event) => root.indukTerima++

        Item {
            id: anakKunci
            focus: true
            Keys.onPressed: (event) => {
                root.tombolTerakhir = event.text
                if (event.text === 'a') event.accepted = true      // hanya 'a' dihentikan
            }
        }
    }

    TestCase {
        name: 'Input'
        when: windowShown

        function init() {                                       // jalan sebelum tiap uji
            root.bawahKlik = 0; root.atasKlik = 0; root.tapBawah = 0
            root.tombolTerakhir = ''; root.indukTerima = 0
        }

        function test_klik_tumpang_tindih() {
            mouseClick(root, 150, 100)                          // area tumpang tindih
            compare(root.atasKlik, 1)
            compare(root.bawahKlik, 0)                          // yang di bawah tak menerima
        }

        function test_klik_bagian_bawah() {
            mouseClick(root, 40, 40)                            // hanya bagian biru
            compare(root.bawahKlik, 1)
            compare(root.atasKlik, 0)
        }

        function test_tap_handler_bawah() {
            mouseClick(root, 40, 40)
            compare(root.tapBawah, 1)
        }

        function test_tombol_dihentikan_anak() {
            keyClick('a')
            compare(root.tombolTerakhir, 'a')
            compare(root.indukTerima, 0)                        // 'a' berhenti di anak
        }

        function test_tombol_naik_ke_induk() {
            keyClick('b')
            compare(root.tombolTerakhir, 'b')
            compare(root.indukTerima, 1)                        // 'b' tak diterima, naik ke induk
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qmltestrunner -input tst_input.qml
```

Dugaan keluaran: baris `PASS   : Input::test_...()` untuk kelima uji, diakhiri ringkasan `Totals: 7 passed, 0 failed` (termasuk `initTestCase` dan `cleanupTestCase`) `[uji]`. Bila ada yang `FAIL`, itu temuan, bukan kegagalan Anda: catat nilai `Actual` dan `Expected` yang dicetak, lalu bandingkan dengan dugaan di 4.4.4.

**Bedah kode:**

- `import QtTest`: modul pengujian. `TestCase` mewarisi `Item`, jadi boleh ditaruh di dalam pohon yang diuji.
- `Item { id: root; width: 320; height: 240 }`: akar yang diberi ukuran agar mendapat area untuk menerima klik.
- `TestCase { name: 'Input'; when: windowShown }`: kasus uji yang baru berjalan setelah jendela tampil. Tanpanya, event simulasi gagal terkirim.
- `function init()`: dijalankan sebelum tiap fungsi uji. Di sini ia mengembalikan penghitung ke nol agar uji tak saling bergantung urutan.
- `mouseClick(root, 150, 100)`: klik di koordinat (150, 100) di dalam `root`. Titik itu berada di area tumpang tindih `bawah` dan `atas`.
- `compare(root.atasKlik, 1)`: memeriksa bahwa nilai aktual sama dengan yang diharapkan, dan mencetak keduanya bila berbeda.
- `keyClick('a')`: menekan dan melepas tombol A. Event dikirim ke item yang berfokus, yaitu `anakKunci`.
- `compare(root.indukTerima, 0)`: karena `a` diterima di anak, induk tak pernah melihatnya. Pada `b`, `indukTerima` menjadi 1.
- `Keys.onPressed: (event) => root.indukTerima++`: fungsi panah dengan satu ekspresi sebagai badan.

**Alternatif: harness C++ buatan sendiri** (pratinjau Modul 10.1).

```cpp
// tst_input.cpp
#include <QtQuickTest>
QUICK_TEST_MAIN(input)
```

```cmake
cmake_minimum_required(VERSION 3.16)
project(tst_input LANGUAGES CXX)
enable_testing()

find_package(Qt6 REQUIRED COMPONENTS QuickTest Qml)
add_definitions(-DQUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

qt_add_executable(tst_input tst_input.cpp)
target_link_libraries(tst_input PRIVATE Qt6::QuickTest Qt6::Qml)
add_test(NAME tst_input COMMAND tst_input -platform offscreen)
```

```bash
cmake -S . -B build -G Ninja
cmake --build build
./build/tst_input -platform offscreen
./build/tst_input -functions
./build/tst_input -input tst_input.qml
ctest --test-dir build --output-on-failure
```

- `QUICK_TEST_MAIN(input)`: makro yang menghasilkan `main()` penjalan uji. `input` adalah pengenal unik kumpulan uji ini.
- `QUICK_TEST_SOURCE_DIR`: direktori yang dipindai harness secara rekursif untuk berkas `tst_*.qml`. Tanpa definisi ini, direktori kerja yang dipindai.
- `Qt6::QuickTest`: pustaka kerangka uji.
- `add_test(... -platform offscreen)`: mendaftarkan uji ke `ctest` dan menjalankannya tanpa jendela nyata.

**`SignalSpy`** untuk memeriksa bahwa sebuah sinyal terpancar:

```qml
SignalSpy { id: spy; target: area; signalName: 'clicked' }
// di dalam fungsi uji:
mouseClick(area)
compare(spy.count, 1)
```

`SignalSpy` dan perilaku `mouseClick(area)` tanpa koordinat `[uji]` pada versi Anda.

**Daftar perintah simulasi:**

| Fungsi | Gunanya |
| --- | --- |
| `mouseClick(item, x, y, button, modifiers, delay)` | Klik di koordinat dalam item |
| `mousePress`, `mouseRelease`, `mouseMove` | Langkah mouse yang lebih halus |
| `mouseDoubleClickSequence(...)` | Klik ganda |
| `keyClick(key, modifiers, delay)` | Tekan dan lepas |
| `keyPress`, `keyRelease`, `keySequence` | Langkah tombol yang lebih halus |
| `tryCompare(obj, 'properti', nilai)` | Menunggu sampai properti mencapai nilai |
| `wait(ms)`, `waitForRendering(item)` | Memberi waktu pada animasi atau render |
| `createTemporaryObject(component, parent)` | Membuat objek yang otomatis dibersihkan |

| Kesalahan | Solusi |
| --- | --- |
| Mengirim event sebelum jendela tampil | Pakai `when: windowShown` |
| Uji saling memengaruhi lewat status bersama | Reset di `init()` |
| Mengirim tombol ke item yang tak berfokus | Beri `focus` atau panggil `forceActiveFocus()` lebih dulu |
| Tak sengaja menampilkan jendela di server tanpa layar | Jalankan dengan `-platform offscreen` |
| Menganggap koordinat klik relatif ke jendela | Relatif ke item yang Anda berikan |
| Menunggu animasi dengan `wait` tetap | Pakai `tryCompare` pada keadaan akhirnya |

Uji input yang tertulis adalah dokumentasi yang bisa dijalankan: setiap dugaan di modul ini yang berstatus `[uji]` dapat menjadi satu fungsi uji. Jangan menautkan `QtTest` ke aplikasi rilis (4.4.7).

**Referensi:** [Qt Quick Test](https://doc.qt.io/qt-6/qtquicktest-index.html) · [TestCase](https://doc.qt.io/qt-6/qml-qttest-testcase.html) · [SignalSpy](https://doc.qt.io/qt-6/qml-qttest-signalspy.html)

---

### 4.4.7 Keamanan dan desain input `[TAMBAHAN]`

*Setiap jalur yang membawa masukan ke program Anda adalah jalur yang bisa disalahgunakan.*

**Konsep.** Input adalah batas kepercayaan: dari perangkat dan dari komponen lain ke logika Anda. Qt Quick memberi komponen kebebasan besar atas siapa yang menerima apa, dan kebebasan itu adalah permukaan serangan bila ada komponen yang tak sepenuhnya Anda percayai (plugin, QML pihak ketiga, QML yang dimuat dari jaringan).

**Daftar risiko dan pengendalinya:**

| Risiko | Penjelasan | Kontrol |
| --- | --- | --- |
| Overlay penelan klik | Item transparan berukuran penuh dengan `z` tinggi atau `MouseArea` penuh menutupi tombol konfirmasi dan menelan klik (analog *clickjacking*; 4.2.5) | Kendalikan siapa yang boleh menaruh anak di akar; audit `z`; uji klik di area penting (4.4.6) |
| Perebutan fokus | Komponen yang memanggil `forceActiveFocus()` atau menyetel `focus: true` dapat mencuri tombol dari isian sensitif | Batasi dengan `FocusScope`; cari `forceActiveFocus` saat tinjauan kode; jangan memuat QML tak tepercaya di scene yang sama |
| `Keys.forwardTo` dan `priority` | Urutan bawaan memproses item di `forwardTo` paling awal, sebelum penanganan bawaan item seperti `TextInput`. Komponen di daftar itu dapat menyadap ketikan | Jangan masukkan komponen tak tepercaya ke `forwardTo`; hati-hati dengan `Keys.BeforeItem` pada item pembungkus isian |
| Pintasan tingkat aplikasi | `Shortcut` yang berlaku di seluruh aplikasi dapat memicu aksi saat fokus ada di tempat lain | Hindari aksi merusak tanpa konfirmasi; periksa `context` `[uji]` |
| Pencatatan tombol | `console.log(event.text)` di jalur isian kata sandi membocorkan ketikan ke terminal atau log | Jangan mencatat event tombol di jalur sensitif |
| Tombol ditahan | Aksi merusak berulang karena auto-repeat | Abaikan `event.isAutoRepeat`; konfirmasi dua langkah |
| Informasi hanya di hover | Penampil yang menampilkan tujuan tautan hanya saat melayang dapat disalahartikan, dan sentuh tak bisa melihatnya | Tampilkan informasi penting terus-menerus |
| Handler berat | Logika berat di handler input membekukan antarmuka | Panggil fungsi singkat; debounce dengan `Timer` |
| Modul uji di rilis | Fungsi simulasi input tersedia di produksi | Pisahkan target uji; jangan tautkan `QtTest` ke aplikasi rilis |

**Peragaan: aksi merusak dengan pengaman.**

```qml
import QtQuick

Item {
    id: dokumen
    focus: true
    property bool menungguKonfirmasi: false

    Keys.onPressed: (event) => {
        if (event.isAutoRepeat) {                         // abaikan tombol yang ditahan
            event.accepted = true
            return
        }
        if (event.key === Qt.Key_Delete) {
            dokumen.menungguKonfirmasi = true                 // langkah 1: minta konfirmasi
            event.accepted = true
        } else if (event.key === Qt.Key_Y && dokumen.menungguKonfirmasi) {
            console.log('hapus dikonfirmasi')                  // langkah 2: lakukan aksi
            dokumen.menungguKonfirmasi = false
            event.accepted = true
        } else {
            dokumen.menungguKonfirmasi = false                // tombol lain membatalkan
        }
    }
}
```

**Bedah kode:**

- `event.isAutoRepeat`: benar bila event berasal dari tombol yang ditahan, bukan ketukan baru. Menolaknya mencegah aksi berulang tak sengaja.
- `dokumen.menungguKonfirmasi`: keadaan dua langkah. Tombol Delete hanya meminta konfirmasi, dan baru tombol Y yang menjalankan aksi.
- `else { ... = false }`: tombol apa pun selain Delete dan Y membatalkan permintaan, sehingga aksi tak bisa dipicu oleh urutan yang tak disengaja.
- Perhatikan bahwa tak ada `console.log(event.text)`: tombol yang ditekan tak dicatat.

**Prinsip desain:**

- **Kurangi wewenang.** Beri komponen hanya properti dan sinyal yang diperlukan, bukan akses ke akar (3.4.8).
- **Batasi permukaan.** Satu handler per aspek interaksi, dengan penerima yang jelas, lebih mudah diaudit daripada satu `MouseArea` raksasa yang menelan semua.
- **Pisahkan yang tak tepercaya.** QML yang tak sepenuhnya Anda percayai sebaiknya tak berbagi scene, fokus, dan konteks dengan bagian sensitif. Isolasi di proses atau mesin QML terpisah adalah topik fase keamanan.
- **Uji perilaku keamanan.** Uji bahwa klik di area konfirmasi sampai ke tombol yang benar (4.4.6).

| Kesalahan | Solusi |
| --- | --- |
| Mengabaikan `isAutoRepeat` pada aksi merusak | Abaikan, dan minta konfirmasi |
| Mencatat tombol yang ditekan saat debugging lalu lupa menghapus | Hapus sebelum rilis; jangan catat di jalur sensitif |
| Memberi komponen luar akses penuh ke akar scene | Antarmuka sempit lewat properti dan sinyal |
| Menganggap hover sebagai kanal tepercaya | Tampilkan informasi penting terus-menerus |

**Referensi:** [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [Qt Quick Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [Qt Quick Test](https://doc.qt.io/qt-6/qtquicktest-index.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** buat persegi yang berubah warna saat di-hover dan keluar dari aplikasi saat tombol `Q` ditekan.

**Jawaban** (dengan jendela, `qml latihan.qml`):

```qml
import QtQuick

Window {
    visible: true; width: 320; height: 180

    Rectangle {
        id: kotak
        anchors.centerIn: parent
        width: 140; height: 80; radius: 8
        color: hover.hovered ? 'gold' : 'orange'

        HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Q) {
                Qt.quit()
                event.accepted = true
            }
        }
    }
}
```

**Bedah kode:**

- `HoverHandler { id: hover }`: pengintai hover untuk `kotak`. `color` terikat ke `hover.hovered`, sehingga warna berubah otomatis (3.1).
- `Item { anchors.fill: parent; focus: true }`: penerima tombol yang menutupi seluruh jendela. Ia tak punya handler pointer, jadi tak menghalangi hover persegi di bawahnya (4.4.4).
- `Keys.onPressed`: keluar bila tombol Q ditekan, dan menandai event sudah ditangani.

**Variasi 1: `Shortcut`.** Ganti blok `Item` dengan `Shortcut { sequence: 'Q'; onActivated: Qt.quit() }`. Bedanya: pintasan berlaku tanpa bergantung pada item yang berfokus `[uji]`.

**Variasi 2: buktikan lewat uji otomatis** (tanpa jendela). Simpan sebagai `tst_latihan.qml`:

```qml
import QtQuick
import QtTest

Item {
    id: root
    width: 320; height: 180

    Rectangle {
        id: kotak
        anchors.centerIn: parent
        width: 140; height: 80
        color: hover.hovered ? 'gold' : 'orange'
        HoverHandler { id: hover }
    }

    TestCase {
        name: 'Latihan'
        when: windowShown

        function test_hover() {
            mouseMove(root, 5, 5)                                // di luar persegi
            tryCompare(hover, 'hovered', false)
            verify(Qt.colorEqual(kotak.color, 'orange'))

            mouseMove(kotak, 10, 10)                             // di dalam persegi
            tryCompare(hover, 'hovered', true)
            verify(Qt.colorEqual(kotak.color, 'gold'))
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qmltestrunner -input tst_latihan.qml
```

Dugaan: satu uji `PASS` `[uji]`. `mouseMove` dan perilaku hover pada platform `offscreen` perlu Anda periksa.

**Kunci:**

- Hover di item ditangani `HoverHandler`, tanpa `MouseArea` dan tanpa `hoverEnabled`.
- Penerima tombol harus berfokus (`focus: true`) dan harus berada di jalur yang menerima event keyboard. Tanpa fokus, tombol Q diabaikan.
- Item penerima tombol yang menutupi jendela tidak merusak hover karena item tanpa handler pointer tak mengambil grab.

**Cek pemahaman (dari kurikulum):** *Mengapa tombol tidak merespons bila item tidak memegang fokus?* Karena scene mengirim event keyboard hanya ke item yang memegang *active focus*. Bila tak ada item berfokus aktif, event diabaikan. Item yang menangani tombol lewat `Keys` harus berada pada rantai fokus tersebut, atau pintasan dibuat dengan `Shortcut`.

**Pertanyaan tambahan:**

1. *Apa beda `focus` dan `activeFocus`?* `focus` adalah permintaan fokus di dalam focus scope-nya. `activeFocus` menyatakan item benar-benar menerima tombol saat ini, yang juga bergantung pada rantai scope dan jendela aktif.
2. *Mengapa `FocusScope` diperlukan pada komponen yang dipakai ulang?* Agar komponen punya ruang fokusnya sendiri dan tak berebut dengan komponen lain yang juga menyetel `focus: true`.
3. *Kapan harus menyetel `event.accepted = true`?* Saat Anda menangani tombol dan tak ingin ia naik ke induk. Handler spesifik seperti `onReturnPressed` melakukannya otomatis.
4. *Apa urutan pemrosesan `Keys` bawaan?* `forwardTo`, handler spesifik, `onPressed` dan `onReleased`, penanganan bawaan item, lalu induk.
5. *Apa yang terjadi saat Anda mengklik area tumpang tindih dua `MouseArea`?* Yang teratas menerima dan mengambil exclusive grab, sehingga yang di bawah tak mendengar.
6. *Apa beda passive dan exclusive grab?* Passive menjamin handler menerima pembaruan dan pelepasan tanpa menghalangi yang lain. Exclusive membuat event berikutnya hanya ke satu penerima.
7. *Mengapa `containsMouse` tak berubah tanpa `hoverEnabled`?* Tanpa itu, posisi mouse hanya dilaporkan saat tombol ditekan.
8. *Mengapa `HoverHandler` tak berguna di layar sentuh?* Hover hanya untuk mouse dan tablet.
9. *Mengapa uji input memerlukan `when: windowShown`?* Karena event keyboard dan mouse hanya dapat dikirim setelah jendela utama tampil.

**Tantangan:**

- Tambahkan `TapHandler` ketuk ganda yang mengganti warna persegi secara tetap, lalu buktikan dengan `mouseDoubleClickSequence` di uji `[uji]`.
- Batasi `DragHandler` pada sumbu x dan buat persegi tak bisa keluar dari jendela `[uji]`.
- Tulis uji yang membuktikan bahwa item di `Keys.forwardTo` menerima tombol sebelum anak `[uji]`.
- Cari penyalahgunaan potensial di proyek Anda dengan `grep -rn "forceActiveFocus\|forwardTo\|Shortcut" --include='*.qml' .`.

---

## F. Glosarium Modul 4.4

| Istilah | Arti |
| --- | --- |
| Input handler | Tipe non-visual yang menangani event input atas nama item induknya |
| `MouseArea` | Item tak terlihat yang menerima event mouse, dan sentuhan tunggal sintetis |
| `MouseEvent` | Objek parameter sinyal `MouseArea`; memuat `button`, `accepted`, dan lainnya |
| `hoverEnabled` | Mengaktifkan event posisi mouse tanpa tombol ditekan |
| `TapHandler` | Handler untuk ketukan dan klik |
| `HoverHandler` | Handler hover mouse dan tablet |
| `DragHandler` | Handler seret |
| `gesturePolicy` | Aturan pengenalan ketukan dan perilaku grab pada `TapHandler` |
| Passive grab | Grab yang menjamin pembaruan dan pelepasan tanpa menghalangi penerima lain |
| Exclusive grab | Grab yang membuat event berikutnya hanya ke satu penerima |
| Event sintetis | Event mouse yang dibuat dari sentuhan untuk memenuhi `MouseArea` |
| Fokus keyboard | Hak menerima tombol; hanya satu item pada satu waktu |
| `focus` | Permintaan fokus di dalam focus scope |
| `activeFocus` | Menyatakan item benar-benar memegang fokus aktif |
| Focus scope (`FocusScope`) | Ruang fokus tersendiri yang bertindak sebagai proxy otomatis |
| `Keys` | Atribut terlampir untuk menangani tombol |
| `event.accepted` | Menandai event sudah ditangani sehingga tak merambat |
| `Keys.priority` | Menentukan apakah `Keys` berjalan sebelum atau sesudah penanganan bawaan item |
| `Keys.forwardTo` | Daftar item yang ikut menerima event tombol |
| `KeyNavigation` | Atribut terlampir untuk berpindah fokus dengan panah dan Tab |
| `Shortcut` | Pintasan keyboard yang tak bergantung pada item berfokus |
| `TestCase` | Tipe uji di Qt Quick Test |
| `windowShown` | Properti yang menandai jendela uji sudah tampil |
| `SignalSpy` | Pencatat pemancaran sinyal dalam uji |
| Clickjacking | Menipu pengguna agar mengklik sesuatu yang berbeda dari yang tampak |
| Auto-repeat | Pengulangan event tombol yang ditahan |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
| --- | --- |
| **3.1** Property Binding | Properti handler (`pressed`, `hovered`, `tapCount`) langsung dipakai dalam binding |
| **3.2** Signal dan handler | `onTapped`, `onClicked`, `onPressed` adalah handler sinyal; parameter `event` dan `mouse` ditulis eksplisit di Qt 6 |
| **3.3** Lifecycle | Fokus belum stabil di `onCompleted`; `forceActiveFocus()` setelah komponen siap; `Loader` dan fokus |
| **3.4** Scope dan konteks | `Keys` adalah atribut terlampir yang dibaca lewat `id`; handler membaca properti scope object tanpa awalan |
| **4.1** Item dan primitif | `enabled: false` dan `visible: false` menghentikan input, `opacity: 0` tidak |
| **4.2** Geometri dan anchors | Area pointer sama dengan geometri item; urutan `z` menentukan siapa didengar dulu; overlay penelan klik |
| **4.3** Resource | Tombol bergambar dari `Image` ditambah handler; sumber gambar dari pengguna (4.3.8) |
| **Fase berikutnya** | Kontrol siap pakai (`Button`, `TextField`), states dan animasi, gestur lanjutan, `Flickable`, layout |
| **10.1** C++ dan CMake | Harness `QUICK_TEST_MAIN` dan `qt_add_executable` untuk 4.4.6; prasyarat 4.3.6 |
| **Keamanan** | Overlay, perebutan fokus, `forwardTo`, dan pencatatan tombol (4.4.7) |

**Penutup Modul 4.4 dan Fase 4:** dengan modul ini, Fase 4 selesai. Anda kini dapat membaca antarmuka sebagai pohon item (4.1), menempatkannya dengan janji relatif (4.2), memuat sumber daya dengan benar dan aman (4.3), dan menerima input dari pointer dan keyboard dengan pemahaman tentang siapa yang mendengar (4.4). Satu pengingat: bagian 4.3.6 (CMake dan resource modul) menunggu Modul 10.1 dari jalur C++ paralel. Fase berikutnya belum ada di berkas Anda, jadi kirimkan bagian kurikulumnya bila siap melanjutkan.

---

**Catatan tautan:** halaman Important Concepts In Qt Quick - User Input, Keyboard Focus in Qt Quick, dan Qt Quick Input Handlers (semuanya 6.12), serta Mouse Events (6.11), saya buka langsung. Fakta tentang `Keys` (Qt 6.3 sampai 6.10 dan 5.x), `TapHandler` (Qt 5.12 sampai 6.8, termasuk terjemahan), serta `TestCase` dan Qt Quick Test (Qt 5.9 sampai 6.9) saya baca lewat hasil pencarian, jadi tandai `[uji]` pada versi Anda. Halaman MouseArea, MouseEvent, HoverHandler, DragHandler, FocusScope, KeyNavigation, Shortcut, dan SignalSpy tidak saya buka satu per satu. `qmltestrunner` tidak disebut di halaman dokumentasi yang saya baca, jadi saya menandainya `[uji]` dan menyediakan harness C++ sebagai jalur yang terdokumentasi. Perilaku `propagateComposedEvents`, properti `margin` pada handler, batas sumbu `DragHandler`, nama enumerasi `PointerDevice`, konteks `Shortcut`, dan hasil pengujian pada platform `offscreen` saya tulis dari pengetahuan umum dan tidak saya verifikasi dalam sesi ini. Bila ada yang tidak terbuka, kabari saya.

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

