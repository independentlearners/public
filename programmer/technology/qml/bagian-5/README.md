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

**Catatan tautan:** halaman Positioning with Anchors (6.12) saya buka langsung. Fakta tentang `alignWhenCentered`, `implicitWidth`, dan `dumpItemTree()` saya baca lewat hasil pencarian dari dokumentasi Item beberapa versi Qt (5.x dan 6.5) serta kode sumber Qt, sehingga tandai `[uji]` pada versi Anda. Bunyi pesan peringatan `Cannot anchor to an item that isn't a parent or sibling` dan `Cannot specify left, right, and horizontalCenter anchors` saya tulis dari ingatan akan kode sumber Qt dan tidak saya verifikasi dalam sesi ini. Halaman AnchorChanges dan Item Positioners muncul sebagai tautan di halaman yang saya buka tetapi tidak saya buka satu per satu. Bila ada yang tidak terbuka, kabari saya.


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

