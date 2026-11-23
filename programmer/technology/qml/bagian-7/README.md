# Fase 6 · Modul 6.1 — State dan Transition

*Kurikulum Qt 6 QML · Fase 6 (Interaksi, State, dan Animasi) · Modul 1 dari 4 (6.1 → 6.2 → 6.3 → 6.4)*

<details>
  <summary>📃 Daftar Isi</summary>

---

## Daftar Isi Modul 6.1

- Audit singkat Fase 6 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 6.1.1 `states` dan `PropertyChanges`
- 6.1.2 Berpindah state (`state`, `when`)
- 6.1.3 `transitions`
- 6.1.4 `StateChangeScript`, `AnchorChanges`, dan `ParentChange`
- 6.1.5 `State` vs `StateMachine`
- 6.1.6 \[TAMBAHAN\] Memilih mekanisme: State, Behavior, atau animasi imperatif
- 6.1.7 \[TAMBAHAN\] State di dalam komponen buatan sendiri
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Referensi tambahan

</details>

## Audit Singkat Fase 6 (sebelum materi dimulai)

Urutan Fase 6 logis: state (keadaan) → animasi (gerak) → input lanjut dan keyboard (kendali) → modul ekstra. Hanya Modul 6.1 yang dikerjakan sekarang; temuan untuk modul lain dicatat di bagian akhir audit agar nanti tidak terlewat.

### Temuan untuk Modul 6.1 (dibereskan di materi ini)

1. **Klarifikasi Bentrok nama `State`.** `State` ada di dua modul: `QtQuick` (keadaan visual) dan `QtQml.StateMachine` (mesin keadaan untuk logika). Memakai keduanya tanpa alias membuat nama saling menimpa. Solusi: `import QtQml.StateMachine as DSM` lalu `DSM.State`, `DSM.StateMachine`, `DSM.SignalTransition`. Dijelaskan di 6.1.5.
2. **Peringatan paket Modul `StateMachine` terpisah.** Di Arch Linux, tipe QML `QtQml.StateMachine` tidak ikut `qt6-declarative`; ia berasal dari paket `qt6-scxml` (daftar berkas paket itu memuat pustaka `QtStateMachine` dan `QtStateMachineQml`). Pasang dengan `sudo pacman -S qt6-scxml` bila belum ada.
3. **Tambahan Fitur yang belum tercakup:** `ParentChange`, `State.extend`, `PropertyChanges.restoreEntryValues` dan `explicit`, aturan bila beberapa `when` bernilai benar sekaligus, aturan pencocokan `Transition` (`from`, `to`, `reversible`, `enabled`), `StateGroup` untuk objek non-`Item`. Masuk ke 6.1.1 sampai 6.1.4.
4. **Klarifikasi Latihan tak menyebut pemicu.** “State kedua `nonaktif`” tidak mengatakan bagaimana state itu dimasuki. Ditentukan: `when: !kotak.enabled`, dengan transisi berbeda untuk masuk-keluar.
5. **Klarifikasi `states: State { ... }` tanpa kurung siku** sah: properti `states` adalah daftar, dan satu elemen boleh ditulis langsung.
6. **Tambahan 6.1.6 dan 6.1.7.** Panduan memilih antara State, `Behavior`, dan animasi imperatif; serta cara memakai State di dalam komponen buatan sendiri tanpa membocorkan API (menyambung Modul 5.1 dan 5.3).

### Hasil audit yang paling penting, semuanya sudah diperiksa ke dokumentasi atau blog resmi Qt:

- **Qt Canvas Painter:** kurikulum menyebutnya sebagai satu fitur, padahal ada dua bagian. API C++-nya sudah tidak lagi technology preview di Qt 6.12, tetapi elemen QML `Canvas2D` masih technology preview. Tipenya diimpor lewat `import QtCanvas2D` dan tersedia sejak Qt 6.12.
- **`MultiEffect`:** contoh kurikulum menggambar item dua kali karena sumbernya tidak disembunyikan. `visible: false` membuat sumber tidak dirender sama sekali dan tidak menerima input; `opacity: 0` menyembunyikannya tetapi input tetap diterima.
- **`Settings`:** potongan kurikulum tidak menyebut `import QtCore`. `Qt.labs.settings` sudah deprecated sejak Qt 6.5, dan tipe `Settings` dari QtCore tersedia sejak Qt 6.5.
- **`LocalStorage` bukan penyimpanan privat:** database-nya khusus pengguna dan khusus QML, tetapi dapat diakses semua aplikasi QML. Dokumentasi tidak menjanjikan enkripsi, jadi jangan simpan rahasia di sana.
- **Dialog di Linux:** dialog berkas native hanya tersedia di Linux bila platform theme GTK+ dipakai. Selain itu Qt memakai dialog cadangan yang berupa item di dalam scene, bukan jendela tingkat atas, jadi di window manager tiling dialog muncul di dalam jendela aplikasi dan butuh ruang.
- **`Shapes`:** renderer berbasis kurva (`CurveRenderer`) meminta bentuk dengan kurva asli, sementara bawaannya `GeometryRenderer`. Dokumen juga menjelaskan biaya triangulasi ulang dan saran memakai satu `Shape` dengan banyak `ShapePath`.

### Catatan awal untuk modul berikutnya (belum dikerjakan; dibahas saat gilirannya)

- **6.2:** contoh `TapHandler` memakai `bola.x === 0` yang membaca nilai di *tengah* animasi (rapuh); `SequentialAnimation on y` dengan loop tak berhingga terus berjalan walau item tak terlihat; animator hanya berjalan di thread render bila *render loop* berupa `threaded`, dan nilai properti tidak diperbarui selama animasi berjalan; daftar isi belum memuat `PropertyAction`, `PauseAnimation`, `ScriptAction`, `RotationAnimation`, `SmoothedAnimation`, `PathAnimation`, kendali `start`/`stop`/`pause`, dan sintaks `Animation on`; latihan butuh kode pembebanan thread utama.
- **6.3:** pada contoh `KeyNavigation`, item tidak bisa dijangkau dengan Tab karena tanpa `activeFocusOnTab`; `DragHandler` belum membatasi sumbu y; belum ada `HoverHandler`, `PointHandler`, `gesturePolicy`, `Keys.forwardTo` / `priority`, `Shortcut.context`, dan `focusPolicy` (Qt 6.7 ke atas). Akan ditambahkan pola kendali keyboard bergaya terminal (hjkl).
- **6.4:** pada contoh `MultiEffect` sumber gambar sebaiknya disembunyikan agar tak tergambar dua kali; potongan `Settings` perlu `import QtCore`; `LocalStorage` dan `Settings` tidak terenkripsi, jangan simpan rahasia. **Catatan Qt Canvas Painter (sudah diverifikasi):** C++ `QCanvasPainter` ada sejak Qt 6.11 sebagai technology preview dan resmi didukung di Qt 6.12; API QML `QtCanvas2D` baru di 6.12 dan masih technology preview; paket Arch bernama `qt6-canvaspainter`.

**Daftar Modul 6.1 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

- 6.1.1 `states` dan `PropertyChanges`
- 6.1.2 Berpindah state (`state`, `when`)
- 6.1.3 `transitions`
- 6.1.4 `StateChangeScript`, `AnchorChanges`, dan \[+\] `ParentChange`
- 6.1.5 `State` vs `StateMachine`
- &#91;+\] 6.1.6 Memilih mekanisme: State, Behavior, atau animasi imperatif
- &#91;+\] 6.1.7 State di dalam komponen buatan sendiri

**Asumsi prasyarat.** Fase 3 (properti, binding, signal), Modul 4.1 (`Item`, `Rectangle`), Modul 4.4 (`TapHandler`), dan Fase 5 (komponen sebagai API, `Theme`). Contoh yang memakai `Theme` mengasumsikan singleton dari Modul 5.3 sudah ada.

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini mengajarkan cara menyatakan *keadaan visual* sebuah item sebagai `State` bernama (misalnya ‘normal’, ‘aktif’, ‘nonaktif’) dan cara menganimasikan perpindahan antar-keadaan dengan `Transition`. Anda mendeskripsikan adegan; engine yang menghitung selisih dan menjalankan perpindahannya.

### Peran dalam kurikulum

Fase 5 membuat antarmuka yang rapi dan bertema; Fase 6 membuatnya *hidup*. State adalah bahasa untuk menyatakan “bagaimana tampilan saat X” tanpa menyebar `if` dan penugasan imperatif ke seluruh kode. Ia menjadi dasar animasi (6.2), interaksi keyboard dan fokus (6.3), dan perilaku komponen di proyek nyata.

### Konsep kunci dan filosofi

- **Analogi pengaturan panggung.** State adalah pengaturan panggung satu adegan: lampu, posisi pemain, warna latar. Transition adalah cara panggung berubah antaradegan: tirai turun pelan, atau lampu padam seketika. Sutradara (Anda) mendeskripsikan adegan; kru (engine) mengurus perpindahannya.
- **Deklaratif, bukan imperatif.** Alih-alih menulis “ketika diklik: ubah warna, ubah skala, lalu kembalikan saat selesai”, Anda menulis “adegan ‘aktif’ berwarna hijau dan berskala 1,2”. Pengembalian ke keadaan semula dikerjakan engine.
- **State adalah selisih, bukan salinan.** `State` hanya mencatat *apa yang berbeda* dari keadaan dasar (base state). Itu membuatnya ringkas dan mudah diaudit.
- **Satu keadaan pada satu waktu.** Sebuah item berada tepat di satu state (termasuk state dasar). Ini menghapus kombinasi mustahil seperti “sedang ditekan *dan* nonaktif sekaligus” yang sering muncul bila keadaan disebar di banyak boolean.
- **Keadaan visual berbeda dari alur logika.** `State` menjawab “seperti apa tampilannya”; `StateMachine` menjawab “perpindahan mana yang *sah*” (6.1.5). Mencampur keduanya adalah sumber bug klasik.
- **Sudut pandang keamanan.** Keadaan yang eksplisit dan terbatas mudah diaudit. Untuk alur sensitif (autentikasi, konfirmasi hapus), mesin keadaan yang hanya mengizinkan perpindahan tertentu mencegah jalur ilegal. Itu alasan 6.1.5 penting walau modul ini terutama soal tampilan.

Alur satu perubahan state (ASCII):

```
 state: ''  --(tap)-->  'aktif'
    |
    |  1. engine menghitung selisih:  color: tomato -> seagreen,  scale: 1 -> 1.2
    |  2. engine mencari Transition yang cocok (from / to)
    |  3. engine menjalankan animasi di dalam Transition
    v
 nilai akhir = nilai yang dinyatakan State        (saat keluar state: nilai dikembalikan)
```

## 6.1.1 `states` dan `PropertyChanges`

### Dasar: state dasar dan state bernama

Setiap `Item` memiliki properti `state` (string) dan `states` (daftar `State`). Keadaan awal item, dengan nilai-nilai yang Anda tulis langsung pada propertinya, disebut **state dasar** (*base state*), dan namanya adalah string kosong `''`. Setiap `State` bernama hanyalah daftar *perbedaan* dari state dasar.

```
 state dasar ''                state 'aktif'
 +----------------------+      +--------------------------------+
 | color: tomato        | ---> | PropertyChanges:               |
 | scale: 1             |      |   color -> seagreen            |
 | (nilai yang Anda     |      |   scale -> 1.2                 |
 |  tulis di Rectangle) | <--- | (keluar state: nilai kembali)  |
 +----------------------+      +--------------------------------+
```

### Sintaks dasar

```
states: [
    State {
        name: '<nama>'              // wajib, unik; '' dicadangkan untuk state dasar
        when: <ekspresi>            // opsional: masuk otomatis saat benar (6.1.2)
        extend: '<nama state lain>' // opsional: mewarisi perubahan state lain
        PropertyChanges { target: <id>; <properti>: <nilai>; ... }
    }
]
state: '<nama>'                     // berpindah state; '' = kembali ke state dasar
```

### Contoh inti

```qml
import QtQuick

Rectangle {
    id: kotak
    width: 120; height: 120; color: 'tomato'

    states: State {
        name: 'aktif'
        PropertyChanges { target: kotak; color: 'seagreen'; scale: 1.2 }
    }
    transitions: Transition {
        ColorAnimation { duration: 250 }
        NumberAnimation { property: 'scale'; duration: 250; easing.type: Easing.OutBack }
    }

    TapHandler { onTapped: kotak.state = (kotak.state === 'aktif' ? '' : 'aktif') }
}
```

### Bedah kode (kata demi kata)

- `Rectangle { id: kotak; width: 120; height: 120; color: 'tomato' }` — objek dengan nilai awal. Nilai-nilai inilah **state dasar**.
- `states: State { ... }` — `states` adalah properti bertipe *daftar* `State`. Satu elemen boleh ditulis langsung tanpa kurung siku; untuk banyak state, pakai `states: [ State {...}, State {...} ]`.
- `name: 'aktif'` — nama state; dipakai saat Anda mengisi `kotak.state`.
- `PropertyChanges { target: kotak; color: 'seagreen'; scale: 1.2 }` — saat state aktif, `kotak.color` menjadi hijau laut dan `kotak.scale` menjadi 1,2. `target` menunjuk objek yang diubah (di sini `kotak` lewat id-nya); sisanya adalah pasangan properti-nilai. `scale` adalah properti bawaan `Item` (bawaan 1.0; menskalakan dari titik tengah).
- `transitions: Transition { ... }` — cara berpindah; dibahas di 6.1.3.
- `TapHandler { onTapped: ... }` — menangani ketukan (dari Modul 4.4).
- `kotak.state = (kotak.state === 'aktif' ? '' : 'aktif')` — membaca `state` saat ini; bila `'aktif'`, kembali ke `''` (state dasar), selain itu masuk ke `'aktif'`. `===` adalah kesamaan ketat JavaScript; `a ? b : c` adalah operator ternary.

### Properti `PropertyChanges` yang perlu diketahui

- `target` — objek yang diubah.
- `restoreEntryValues` (bawaan `true`) — saat state ditinggalkan, properti dikembalikan ke nilai (atau binding) yang dimilikinya *sebelum* state diterapkan. Bila `false`, nilai dari state dibiarkan.
- `explicit` (bawaan `false`) — bila `true`, ekspresi nilai dihitung **sekali** saat state dimasuki, bukan dipertahankan sebagai binding yang bereaksi terhadap perubahan.

Perbedaannya terlihat pada binding:

```qml
PropertyChanges { target: kotak; width: parent.width / 2 }                 // tetap binding: ikut berubah
PropertyChanges { target: kotak; explicit: true; width: parent.width / 2 } // dihitung sekali saat masuk
```

### Mewarisi state lain dengan `extend`

```qml
states: [
    State {
        name: 'aktif'
        PropertyChanges { target: kotak; color: 'seagreen' }
    },
    State {
        name: 'aktifBesar'
        extend: 'aktif'                                    // ambil semua perubahan 'aktif' ...
        PropertyChanges { target: kotak; scale: 1.5 }      // ... lalu tambahkan atau timpa
    }
]
```

`extend` menghindari menyalin perubahan yang sama ke banyak state.

### Opsi lain untuk perubahan satu properti

```qml
// Opsi 1 — State (kurikulum): cocok bila BANYAK properti berubah bersama dan ada banyak keadaan
states: State { name: 'aktif'; PropertyChanges { target: kotak; color: 'seagreen' } }

// Opsi 2 — binding bersyarat: cukup untuk satu atau dua properti dan satu boolean
color: aktif ? 'seagreen' : 'tomato'

// Opsi 3 — penugasan imperatif di handler: rapuh, mudah lupa mengembalikan nilai
onTapped: { kotak.color = 'seagreen'; kotak.scale = 1.2 }
```

Opsi 3 adalah yang paling sering menimbulkan bug: Anda sendiri yang harus ingat mengembalikan setiap nilai. Pembahasan lengkap pemilihan ada di 6.1.6.

### Hal yang perlu diperhatikan

- **Nilai harus punya tipe yang cocok.** `scale: 1.2` angka, `color: 'seagreen'` warna.
- **Properti yang tidak bisa diubah lewat `PropertyChanges`:** anchors (pakai `AnchorChanges`, 6.1.4) dan induk (pakai `ParentChange`, 6.1.4).
- **Perubahan imperatif saat state aktif bersifat sementara.** Bila Anda menulis `kotak.color = 'red'` di handler ketika state `'aktif'` sedang berlaku, nilai itu akan digantikan lagi saat state ditinggalkan. Biarkan state yang menjadi satu-satunya pengendali properti yang ia ubah.
- **State bukan tempat logika bisnis.** Ia hanya mendeskripsikan tampilan.

**Referensi bagian ini:** [Qt Quick States](https://doc.qt.io/qt-6/qtquick-statesanimations-states.html) · [State](https://doc.qt.io/qt-6/qml-qtquick-state.html) · [PropertyChanges](https://doc.qt.io/qt-6/qml-qtquick-propertychanges.html) · [Item (state, states, scale)](https://doc.qt.io/qt-6/qml-qtquick-item.html)

## 6.1.2 Berpindah state (`state`, `when`)

### Dasar: tiga cara memasuki sebuah state

1. **Penugasan imperatif:** `kotak.state = 'aktif'` (dan `''` untuk kembali ke state dasar).
2. **Binding pada `state`:** `state: aktif ? 'aktif' : ''`.
3. **Kondisi `when` di dalam `State`:** state dimasuki otomatis selama ekspresinya benar.

Cara ketiga paling deklaratif dan paling disarankan: keadaan *diturunkan dari data*, bukan diatur manual.

### Contoh inti: `when` dengan properti boolean

```qml
import QtQuick

Rectangle {
    id: kotak
    property bool aktif: false
    width: 120; height: 120; color: 'tomato'

    states: State {
        name: 'aktif'
        when: kotak.aktif
        PropertyChanges { target: kotak; color: 'seagreen'; scale: 1.2 }
    }
    transitions: Transition {
        ColorAnimation { duration: 250 }
        NumberAnimation { property: 'scale'; duration: 250 }
    }

    TapHandler { onTapped: kotak.aktif = !kotak.aktif }
}
```

### Bedah kode (bagian baru)

- `property bool aktif: false` — *data* yang menggerakkan tampilan. Pemakai komponen cukup membalik boolean ini; ia tidak perlu tahu nama state (selaras dengan prinsip “properti masuk” di Modul 5.1).
- `when: kotak.aktif` — ekspresi kondisi. Selama benar, item berada di state `'aktif'`; saat salah, ia kembali ke state dasar (atau state lain yang `when`-nya benar).
- `kotak.aktif = !kotak.aktif` — `!` adalah negasi boolean; handler hanya mengubah *data*, bukan tampilan.

### Bila beberapa `when` bernilai benar sekaligus

```qml
states: [
    State { name: 'nonaktif'; when: !root.enabled;       PropertyChanges { target: root; color: Theme.disabled } },
    State { name: 'ditekan';  when: tap.pressed;         PropertyChanges { target: root; color: Theme.primaryDown } },
    State { name: 'fokus';    when: root.activeFocus;    PropertyChanges { target: root; border.width: 2 } }
]
```

Bila lebih dari satu `when` benar, **state yang tertulis lebih dulu dalam daftar menang**. Karena itu urutan daftar adalah urutan prioritas: letakkan keadaan yang paling menentukan (misalnya `nonaktif`) paling atas. Bila tidak ada `when` yang benar, item kembali ke state dasar.

```
 when benar?   urutan daftar   --> state yang dipakai
 --------------------------------------------------
  nonaktif: ya      1               nonaktif   (menang)
  ditekan:  ya      2
  fokus:    ya      3
  semuanya tidak                    state dasar ''
```

### Memantau state

```qml
onStateChanged: console.log('state sekarang:', state === '' ? '(dasar)' : state)
```

`onStateChanged` adalah handler perubahan properti `state`; berguna untuk melihat apa yang sebenarnya dipilih engine.

### Opsi lain untuk berpindah state

```qml
// Opsi 1 — imperatif (kurikulum): sederhana tetapi Anda yang mengelola semuanya
TapHandler { onTapped: kotak.state = (kotak.state === 'aktif' ? '' : 'aktif') }

// Opsi 2 — binding pada state: state selalu cermin dari data
state: kotak.aktif ? 'aktif' : ''

// Opsi 3 — when di dalam State (disarankan): data menurunkan state
StateX { name: 'aktif'; when: kotak.aktif }
```

(Pada Opsi 3, `StateX` hanyalah penanda; tulis `State` seperti contoh inti di atas.)

### Hal yang perlu diperhatikan

- **Jangan mencampur `when` dengan penugasan imperatif `state = ...` pada item yang sama.** Dua pengendali untuk satu keadaan membuat hasilnya bergantung pada urutan kejadian. Pilih satu.
- **Menugaskan `state` secara imperatif memutus binding `state: ...`** yang sebelumnya ada. Anda tidak akan lagi mendapat pembaruan otomatis.
- **Nama state yang salah ketik** tidak membuat apa-apa berubah dan Qt mencatat peringatan; periksa log terminal.
- **State untuk objek non-`Item`.** Hanya `Item` yang punya `state` dan `states` bawaan. Untuk objek lain (misalnya `QtObject`), gunakan tipe `StateGroup`, yang menyediakan properti yang sama.

**Referensi bagian ini:** [State (when, extend)](https://doc.qt.io/qt-6/qml-qtquick-state.html) · [Qt Quick States](https://doc.qt.io/qt-6/qtquick-statesanimations-states.html) · [StateGroup](https://doc.qt.io/qt-6/qml-qtquick-stategroup.html)

## 6.1.3 `transitions`

### Dasar: apa itu `Transition`?

`State` hanya menyatakan *hasil akhir*. Tanpa transisi, perubahan terjadi seketika (meloncat). `Transition` adalah daftar **animasi yang dijalankan saat state berubah**. Anda tidak menulis “dari berapa ke berapa”: engine sudah tahu nilai awal (nilai saat ini) dan nilai akhir (dari State), dan animasi di dalam `Transition` mengisi langkah di antaranya.

### Sintaks dasar

```
transitions: [
    Transition {
        from: '<state asal>'     // bawaan '*' (sembarang state)
        to:   '<state tujuan>'   // bawaan '*' (sembarang state)
        reversible: false        // true: juga berlaku untuk arah sebaliknya
        enabled: true            // false: transisi ini dimatikan
        <animasi> ...            // dijalankan PARALEL secara bawaan
    }
]
```

### Contoh inti (dari kurikulum, diperjelas)

```qml
transitions: Transition {
    ColorAnimation { duration: 250 }
    NumberAnimation { property: 'scale'; duration: 250; easing.type: Easing.OutBack }
}
```

### Bedah kode (kata demi kata)

- `transitions: Transition { ... }` — `transitions` adalah daftar `Transition`; satu elemen boleh tanpa kurung siku. Karena `from` dan `to` tidak ditulis, keduanya bernilai `'*'` (sembarang): transisi ini berlaku untuk **semua** perpindahan state, ke kedua arah.
- `ColorAnimation { duration: 250 }` — animasi khusus warna selama 250 milidetik. Karena tanpa `target` atau `property`, ia otomatis berlaku pada **semua properti warna yang berubah** dalam perpindahan ini (di sini `color`).
- `NumberAnimation { property: 'scale'; duration: 250; easing.type: Easing.OutBack }` — animasi angka pada properti `scale`. `property: 'scale'` membatasinya hanya pada `scale`. `easing.type: Easing.OutBack` adalah kurva percepatan: bergerak melewati tujuan sedikit lalu kembali (efek “melenting”). Easing dibahas lengkap di Modul 6.2.
- **Paralel.** Kedua animasi di atas berjalan *bersamaan*. Untuk berurutan, bungkus dengan `SequentialAnimation`.

### Menentukan arah dan urutan

```qml
transitions: [
    Transition {
        from: ''; to: 'aktif'
        SequentialAnimation {
            NumberAnimation { property: 'scale'; to: 1.4; duration: 120 }    // melambung dulu
            ParallelAnimation {
                ColorAnimation { duration: 200 }
                NumberAnimation { property: 'scale'; duration: 200 }          // lalu menetap di nilai state (1.2)
            }
        }
    },
    Transition {
        from: 'aktif'; to: ''
        ColorAnimation { duration: 150 }
        NumberAnimation { property: 'scale'; duration: 150 }
    }
]
```

- `from: ''; to: 'aktif'` — hanya berlaku saat berpindah dari state dasar ke `'aktif'`.
- `to: 1.4` — pada animasi pertama, tujuan ditulis eksplisit (melampaui nilai state). Pada animasi kedua `to` tidak ditulis, sehingga otomatis menuju nilai milik state (1,2).
- Garis waktu:

```
  0 ms         120 ms                320 ms
  |--- scale ---|---- scale + warna ---|
  1.0 -> 1.4     1.4 -> 1.2 , tomato -> seagreen
```

### `reversible`

```qml
Transition {
    from: 'a'; to: 'b'
    reversible: true          // juga dipakai saat b -> a, dengan urutan animasi dibalik
    // ...
}
```

Bila `from` dan `to` dibiarkan `'*'`, transisi sudah berlaku dua arah sehingga `reversible` tidak diperlukan. `reversible: true` berguna ketika `from` dan `to` spesifik dan Anda ingin satu definisi untuk kedua arah.

### Transisi mana yang dipilih?

Bila beberapa `Transition` cocok dengan sebuah perpindahan, Qt memilih yang **paling spesifik** (pasangan `from` dan `to` eksplisit lebih diutamakan daripada `'*'`). Jangan menggantungkan diri pada urutan tulis: rancang transisi sehingga saling lepas (misalnya `to: 'aktif'`, `to: 'nonaktif'`, `to: ''`), dan uji.

### Mengapa transisi tidak berjalan? (diagram diagnosis)

```
 Transition tidak tampak berjalan
  |
  +-- state benar-benar berpindah?          TIDAK --> periksa 'when' / penugasan state (onStateChanged)
  |
  +-- from / to cocok dengan perpindahan?   TIDAK --> perpindahan balik belum punya Transition (mis. 'aktif' -> '')
  |
  +-- properti yang dianimasikan berubah?   TIDAK --> nilai di State sama dengan nilai saat ini
  |
  +-- tipe animasi sesuai tipe properti?    TIDAK --> ColorAnimation untuk warna, NumberAnimation untuk angka
  |
  '-- enabled: true dan tidak dikalahkan?   TIDAK --> cek Behavior yang bentrok pada properti yang sama
```

### Aksi non-animasi di dalam transisi

- `PropertyAction` — mengubah properti **seketika** pada titik tertentu dalam urutan (tanpa animasi). Berguna untuk properti yang tak bisa diinterpolasi, seperti `visible`.
- `PauseAnimation` — jeda selama `duration`.
- `ScriptAction` — menjalankan skrip (lihat 6.1.4).

Contoh menyembunyikan item secara halus:

```qml
Rectangle {
    id: kartu
    width: 100; height: 100; color: 'tomato'

    states: State {
        name: 'tersembunyi'
        PropertyChanges { target: kartu; opacity: 0; visible: false }
    }
    transitions: Transition {
        to: 'tersembunyi'
        SequentialAnimation {
            NumberAnimation { property: 'opacity'; duration: 200 }
            PropertyAction { property: 'visible' }        // visible diubah SETELAH pudar selesai
        }
    }
}
```

`visible` adalah boolean dan tak dapat dianimasikan; tanpa `PropertyAction`, item akan langsung hilang dan animasi pudar tak terlihat. `PropertyAction { property: 'visible' }` memakai nilai dari State pada titik itu.

### Opsi lain untuk “animasi saat keadaan berubah”

```qml
// Opsi 1 — Transition (kurikulum): animasi dikelompokkan per perpindahan state
transitions: Transition { ColorAnimation { duration: 250 } }

// Opsi 2 — Behavior: aturan tetap per properti, tanpa konsep state
Behavior on color { ColorAnimation { duration: 250 } }

// Opsi 3 — animasi imperatif: dipicu manual (cocok untuk efek sekali, bukan keadaan)
ColorAnimation { id: anim; target: kotak; property: 'color'; to: 'seagreen'; duration: 250 }
// anim.start()
```

Pemilihan lengkap ada di 6.1.6.

### Hal yang perlu diperhatikan

- **Durasi dari token tema:** `duration: Theme.durationNormal` agar seluruh aplikasi bernapas dengan tempo yang sama (Modul 5.3).
- **Jaga singkat.** Sekitar 120–300 ms terasa responsif; lebih lama terasa lamban.
- **Jangan menganimasikan `width`/`height` di dalam `Layout`** (memicu penataan ulang tiap frame); animasikan `scale`, `opacity`, atau `x`/`y`. Dibahas di Modul 6.2.
- **Transisi hanya berjalan untuk properti yang benar-benar berubah.**

**Referensi bagian ini:** [Transition](https://doc.qt.io/qt-6/qml-qtquick-transition.html) · [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html) · [PropertyAction](https://doc.qt.io/qt-6/qml-qtquick-propertyaction.html) · [SequentialAnimation](https://doc.qt.io/qt-6/qml-qtquick-sequentialanimation.html) · [ColorAnimation](https://doc.qt.io/qt-6/qml-qtquick-coloranimation.html) · [NumberAnimation](https://doc.qt.io/qt-6/qml-qtquick-numberanimation.html)

## 6.1.4 `StateChangeScript`, `AnchorChanges`, dan `ParentChange`

`PropertyChanges` hanya mengubah *properti biasa*. Tiga jenis perubahan lain punya tipe khusus karena sifatnya berbeda: menjalankan skrip, mengubah anchors, dan memindahkan induk.

### 1. `StateChangeScript`: menjalankan skrip saat state dimasuki

```qml
states: State {
    name: 'aktif'
    PropertyChanges { target: kotak; color: 'seagreen' }
    StateChangeScript {
        name: 'catat'
        script: console.log('masuk state aktif')
    }
}
```

- `StateChangeScript` — objek perubahan yang berisi kode JavaScript.
- `name: 'catat'` — nama skrip, agar bisa dirujuk dari transisi.
- `script: console.log(...)` — kode yang dijalankan **saat state dimasuki**. Ia tidak berjalan saat state ditinggalkan; untuk itu pakai `onStateChanged` atau `ScriptAction` di transisi.

Untuk menjalankannya pada titik tertentu dalam animasi, rujuk lewat `ScriptAction`:

```qml
transitions: Transition {
    SequentialAnimation {
        NumberAnimation { property: 'scale'; duration: 200 }
        ScriptAction { scriptName: 'catat' }     // dijalankan SETELAH animasi skala selesai
    }
}
```

Bila sebuah `StateChangeScript` dirujuk oleh `ScriptAction` pada transisi yang berlaku, skrip itu dijalankan oleh `ScriptAction` pada urutannya, bukan seketika saat masuk. Gunakan dengan hemat: logika berat sebaiknya tinggal di fungsi, bukan di dalam state.

### 2. `AnchorChanges`: mengubah anchors antar-state

`anchors` tidak bisa diubah lewat `PropertyChanges` (hanya margin-nya yang bisa). Untuk menambah atau mencabut anchor, pakai `AnchorChanges`, dan untuk menganimasikannya pakai `AnchorAnimation`.

```qml
import QtQuick

Item {
    id: area
    width: 320; height: 120

    Rectangle {
        id: panel
        width: 100; height: 100; color: 'steelblue'
        anchors.left: area.left
        anchors.verticalCenter: area.verticalCenter

        states: State {
            name: 'kanan'
            AnchorChanges {
                target: panel
                anchors.left: undefined
                anchors.right: area.right
            }
        }
        transitions: Transition {
            AnchorAnimation { duration: 300; easing.type: Easing.InOutQuad }
        }

        TapHandler { onTapped: panel.state = (panel.state === 'kanan' ? '' : 'kanan') }
    }
}
```

- `anchors.left: area.left` — state dasar: panel menempel ke kiri.
- `AnchorChanges { target: panel; ... }` — perubahan anchors untuk `panel`.
- `anchors.left: undefined` — *melepas* anchor kiri (mengisi `undefined` mencabutnya). Anchor yang berlawanan tidak boleh aktif bersamaan bila Anda ingin posisi ditentukan satu sisi.
- `anchors.right: area.right` — menempelkan sisi kanan panel ke sisi kanan `area`.
- `AnchorAnimation { duration: 300 }` — animasi khusus perubahan anchors. Tanpa ini, panel meloncat.
- Mengapa `area.left` dan bukan `parent.left`? Rujukan lewat id lebih eksplisit dan tidak bergantung pada siapa induknya (selaras dengan Modul 5.1).

Untuk margin cukup `PropertyChanges { target: panel; anchors.leftMargin: 20 }`.

### 3. `ParentChange`: memindahkan item ke induk lain

```qml
import QtQuick

Row {
    spacing: 20

    Rectangle {
        id: kolomA
        width: 140; height: 140; color: '#e5e7eb'

        Rectangle {
            id: kartu
            x: 10; y: 10; width: 60; height: 60; color: 'tomato'

            states: State {
                name: 'pindah'
                ParentChange { target: kartu; parent: kolomB; x: 10; y: 10 }
            }
            transitions: Transition {
                ParentAnimation { NumberAnimation { properties: 'x,y'; duration: 300 } }
            }

            TapHandler { onTapped: kartu.state = (kartu.state === 'pindah' ? '' : 'pindah') }
        }
    }

    Rectangle { id: kolomB; width: 140; height: 140; color: '#cbd5e1' }
}
```

- `ParentChange { target: kartu; parent: kolomB; x: 10; y: 10 }` — saat state aktif, `kartu` dipindah dari `kolomA` ke `kolomB` dan diletakkan di (10, 10) pada sistem koordinat induk baru. Anda juga bisa mengisi `width`, `height`, `scale`, dan `rotation` agar tampilan tetap terjaga.
- `ParentAnimation { NumberAnimation { properties: 'x,y'; ... } }` — menganimasikan perpindahan seolah item meluncur dari tempat lama ke tempat baru, walau induknya berganti.
- Perhatikan efek samping pergantian induk: koordinat berubah (relatif ke induk baru), urutan gambar (*z*) mengikuti induk baru, dan `clip` induk baru memengaruhi apa yang tampak. Periksa dokumentasi `ParentChange` untuk detail penyesuaian posisi otomatis.

### Peta jenis perubahan dan animasi pasangannya

```
 Yang berubah           Tipe perubahan (di State)     Animasi pasangan (di Transition)
 ---------------------  ----------------------------  --------------------------------------
 properti biasa         PropertyChanges               NumberAnimation, ColorAnimation, ...
 anchors                AnchorChanges                 AnchorAnimation
 induk (parent)         ParentChange                  ParentAnimation
 skrip                  StateChangeScript             ScriptAction
```

**Referensi bagian ini:** [StateChangeScript](https://doc.qt.io/qt-6/qml-qtquick-statechangescript.html) · [ScriptAction](https://doc.qt.io/qt-6/qml-qtquick-scriptaction.html) · [AnchorChanges](https://doc.qt.io/qt-6/qml-qtquick-anchorchanges.html) · [AnchorAnimation](https://doc.qt.io/qt-6/qml-qtquick-anchoranimation.html) · [ParentChange](https://doc.qt.io/qt-6/qml-qtquick-parentchange.html) · [ParentAnimation](https://doc.qt.io/qt-6/qml-qtquick-parentanimation.html)

## 6.1.5 `State` vs `StateMachine`

### Dasar: dua alat dengan nama mirip, tujuan berbeda

- **`State` (modul `QtQuick`)** — menyatakan *keadaan visual* sebuah `Item`: kumpulan perubahan properti. Setiap state bisa dimasuki dari state mana pun; tidak ada konsep “perpindahan yang sah”.
- **`StateMachine` (modul `QtQml.StateMachine`)** — *mesin keadaan terbatas* (finite state machine) untuk **alur logika**: kumpulan state, perpindahan (*transition*) yang **dideklarasikan eksplisit** dengan pemicu (signal atau waktu), aksi saat masuk dan keluar, hierarki, dan riwayat. Hanya perpindahan yang Anda tulis yang bisa terjadi.

```
  State (QtQuick)                    StateMachine (QtQml.StateMachine)
  ------------------------------     --------------------------------------------
  "seperti apa tampilannya?"          "perpindahan mana yang SAH, dipicu apa?"
  sembarang state -> sembarang        hanya perpindahan yang dideklarasikan
  tanpa pemicu (when / penugasan)     pemicu: signal, waktu, kejadian
  perubahan properti                  aksi masuk (onEntered) dan keluar (onExited)
  tanpa hierarki                      state bersarang, paralel, riwayat
```

### Prasyarat pemasangan (Arch Linux)

Tipe QML `StateMachine` datang dari paket `qt6-scxml` (bukan `qt6-declarative`):

```bash
sudo pacman -S qt6-scxml
pacman -Ql qt6-scxml | grep -i statemachine     # memastikan modul StateMachine ada
```

### Mengatasi bentrok nama `State`

Kedua modul mendefinisikan tipe bernama `State`. Impor modul mesin keadaan dengan **alias** agar keduanya bisa hidup berdampingan:

```qml
import QtQuick
import QtQml.StateMachine as DSM      // DSM = nama alias yang Anda pilih

// State visual   -> State { ... }          (dari QtQuick)
// State mesin    -> DSM.State { ... }      (dari QtQml.StateMachine)
```

### Contoh inti: alur koneksi

```qml
import QtQuick
import QtQml.StateMachine as DSM

Item {
    id: root
    signal mulai()
    signal berhasil()
    signal gagal()

    DSM.StateMachine {
        id: mesin
        running: true
        initialState: idle

        DSM.State {
            id: idle
            onEntered: console.log('idle')
            DSM.SignalTransition { targetState: menghubungkan; signal: root.mulai }
        }

        DSM.State {
            id: menghubungkan
            onEntered: console.log('menghubungkan...')
            DSM.SignalTransition { targetState: terhubung; signal: root.berhasil }
            DSM.SignalTransition { targetState: idle; signal: root.gagal }
            DSM.TimeoutTransition { targetState: idle; timeout: 5000 }
        }

        DSM.State {
            id: terhubung
            onEntered: console.log('terhubung')
        }
    }
}
```

### Bedah kode (kata demi kata)

- `import QtQml.StateMachine as DSM` — memuat modul dengan alias `DSM`; semua tipe darinya ditulis `DSM.Nama`.
- `signal mulai()`, `berhasil()`, `gagal()` — tiga peristiwa yang menggerakkan mesin.
- `DSM.StateMachine { running: true; initialState: idle }` — mesin yang langsung berjalan dan dimulai dari state `idle` (dirujuk lewat id).
- `DSM.State { id: idle ... }` — satu keadaan logika. `onEntered` adalah handler untuk signal `entered`, dipanggil setiap kali state dimasuki (ada juga `onExited`).
- `DSM.SignalTransition { targetState: menghubungkan; signal: root.mulai }` — perpindahan: ketika signal `root.mulai` dipancarkan *dan mesin sedang di state ini*, pindah ke `menghubungkan`. Signal yang sama dipancarkan di state lain tidak berpengaruh.
- `DSM.TimeoutTransition { targetState: idle; timeout: 5000 }` — perpindahan otomatis setelah 5000 milidetik di state `menghubungkan` bila tak ada signal lain.
- Tidak ada perpindahan `idle → terhubung` langsung: **jalur itu tidak sah** dan tak bisa terjadi, walau seseorang memancarkan `berhasil()` di state `idle`.

```
          mulai                    berhasil
  [idle] -------> [menghubungkan] ---------> [terhubung]
     ^                  |
     |   gagal / timeout 5 dtk
     +------------------+
```

### Kapan memilih yang mana

```
 Hanya mengubah tampilan satu item?                     --> State (QtQuick)
 Alur dengan aturan perpindahan, pemicu, aksi masuk/keluar,
  atau lebih dari ~3 status yang saling bergantung?     --> StateMachine
 Alur sensitif (autentikasi, konfirmasi hapus, pembayaran)? --> StateMachine: jalur ilegal mustahil
 Kedua-duanya?  --> mesin mengatur LOGIKA; state visual mengikuti (lihat di bawah)
```

### Menyatukan keduanya

```qml
DSM.State {
    id: terhubung
    onEntered: indikator.state = 'hijau'      // mesin menggerakkan state visual
}
```

Mesin menentukan *apa yang sedang terjadi*; state visual menentukan *seperti apa tampilannya saat itu*. Pisahkan keduanya.

### Opsi lain tanpa `StateMachine`

```qml
// Opsi 1 — properti status tunggal + fungsi penjaga perpindahan (tanpa dependensi tambahan)
property string status: 'idle'
function ke(baru) {
    const sah = { idle: ['menghubungkan'], menghubungkan: ['terhubung', 'idle'], terhubung: ['idle'] }
    if (sah[status] && sah[status].indexOf(baru) !== -1)
        status = baru
    else
        console.warn('perpindahan tidak sah:', status, '->', baru)
}

// Opsi 2 — banyak boolean (HINDARI): 3 boolean = 8 kombinasi, sebagian besar mustahil
property bool sedangMenghubungkan; property bool gagal; property bool terhubung

// Opsi 3 — QStateMachine di C++ atau SCXML (QtScxml) untuk logika besar; sama-sama dari paket qt6-scxml
```

Opsi 1 cukup untuk alur kecil dan memberi jaring pengaman yang sama: perpindahan di luar tabel ditolak dan dicatat. Opsi 2 adalah jebakan *ledakan boolean*: setiap boolean baru melipatgandakan kombinasi yang harus Anda jaga agar tidak ada yang mustahil.

### Hal yang perlu diperhatikan

- **Selalu beri alias saat mengimpor `QtQml.StateMachine`** bersama `QtQuick`.
- **Mesin menentukan apa yang boleh terjadi; ia bukan tempat logika bisnis berat.** Aksi berat tetap di fungsi atau model.
- **Pastikan `qt6-scxml` terpasang** di mesin pengembangan dan di paket yang Anda distribusikan.

**Referensi bagian ini:** [Qt State Machine QML Types](https://doc.qt.io/qt-6/qtqml-statemachine-qmlmodule.html) · [Qt State Machine Overview](https://doc.qt.io/qt-6/qtstatemachine-overview.html) · [Qt SCXML](https://doc.qt.io/qt-6/qtscxml-index.html) · [Paket qt6-scxml (Arch)](https://archlinux.org/packages/extra/x86_64/qt6-scxml/) · [Harel, Statecharts: A Visual Formalism for Complex Systems (1987)](<https://doi.org/10.1016/0167-6423(87)90035-9>) · [W3C SCXML](https://www.w3.org/TR/scxml/)

## 6.1.6 \[TAMBAHAN\] Memilih mekanisme: State, Behavior, atau animasi imperatif

*Alasan penambahan:* kurikulum memperkenalkan `State` dan `Behavior` di modul berbeda tanpa panduan memilih. Hasil yang tampak sama bisa dicapai dengan beberapa cara, dan memilih yang keliru adalah sumber kode berbelit.

### Efek yang sama dalam tiga bentuk

```qml
// Bentuk A — binding bersyarat + Behavior (data -> tampilan, tanpa konsep state)
Rectangle {
    id: kotak
    property bool aktif: false
    width: 120; height: 120
    color: aktif ? 'seagreen' : 'tomato'
    scale: aktif ? 1.2 : 1.0
    Behavior on color { ColorAnimation { duration: 250 } }
    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
    TapHandler { onTapped: kotak.aktif = !kotak.aktif }
}

// Bentuk B — State + Transition (kurikulum 6.1)
Rectangle {
    id: kotak
    property bool aktif: false
    width: 120; height: 120; color: 'tomato'
    states: State { name: 'aktif'; when: kotak.aktif
        PropertyChanges { target: kotak; color: 'seagreen'; scale: 1.2 } }
    transitions: Transition {
        ColorAnimation { duration: 250 }
        NumberAnimation { property: 'scale'; duration: 250; easing.type: Easing.OutBack }
    }
    TapHandler { onTapped: kotak.aktif = !kotak.aktif }
}

// Bentuk C — animasi imperatif: efek sekali pakai, bukan keadaan
Rectangle {
    id: kotak
    width: 120; height: 120; color: 'tomato'
    SequentialAnimation {
        id: kedut
        NumberAnimation { target: kotak; property: 'scale'; to: 1.3; duration: 100 }
        NumberAnimation { target: kotak; property: 'scale'; to: 1.0; duration: 100 }
    }
    TapHandler { onTapped: kedut.restart() }
}
```

Bentuk C memakai `restart()` untuk memulai animasi dari awal; ia tidak menyimpan “keadaan”, hanya mengeluarkan gerakan.

### Bandingkan

- **Bentuk A (binding + `Behavior`)** — paling ringkas untuk 1–2 properti yang digerakkan satu boolean. Kekurangan: tidak ada tempat mengelompokkan banyak perubahan; tidak bisa mengubah anchors, induk, atau menjalankan skrip.
- **Bentuk B (State + Transition)** — unggul bila **banyak properti berubah bersama**, ada **lebih dari dua keadaan**, atau perubahan menyangkut anchors, induk, atau skrip. Setiap keadaan punya nama dan bisa dipantau (`onStateChanged`).
- **Bentuk C (imperatif)** — untuk efek *peristiwa* (berkedut, menyala sekejap, bergetar) yang tidak mengubah keadaan menetap.
- **`StateMachine`** — untuk *logika* alur (6.1.5).

```
 Apa yang ingin Anda nyatakan?
  |
  +-- efek sekali (berkedut, bergetar)?                    --> animasi imperatif (Bentuk C)
  |
  +-- 1-2 properti mengikuti satu boolean?                 --> binding + Behavior (Bentuk A)
  |
  +-- banyak properti / banyak keadaan / anchors / induk?  --> State + Transition (Bentuk B)
  |
  '-- aturan perpindahan, pemicu, aksi masuk-keluar?       --> StateMachine
```

### Bentrok antar-mekanisme

Jangan memasang `Behavior` dan animasi `Transition` pada *properti yang sama* tanpa sengaja: dua pengendali animasi untuk satu properti membuat hasilnya sulit diprediksi. Pilih satu per properti.

**Referensi bagian ini:** [Behavior](https://doc.qt.io/qt-6/qml-qtquick-behavior.html) · [Animation (restart, start, stop)](https://doc.qt.io/qt-6/qml-qtquick-animation.html) · [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html)

## 6.1.7 \[TAMBAHAN\] State di dalam komponen buatan sendiri

*Alasan penambahan:* menyambung Modul 5.1 dan 5.3. Komponen yang rapi menyembunyikan keadaan internalnya di balik properti, dan State adalah alat yang cocok untuk itu.

### Contoh: `AppButton` dengan state internal

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

    // tampilan dasar (dari token tema, 5.3)
    implicitWidth: teks.implicitWidth + 2 * Theme.space4
    implicitHeight: Theme.controlHeight
    radius: Theme.radius
    color: Theme.primary
    border.color: Theme.focusRing
    border.width: root.activeFocus ? 2 : 0

    // keadaan internal: urutan daftar = prioritas
    states: [
        State {
            name: 'nonaktif'
            when: !root.enabled
            PropertyChanges { target: root; color: Theme.disabled }
        },
        State {
            name: 'ditekan'
            when: tap.pressed
            PropertyChanges { target: root; color: Theme.primaryDown; scale: 0.97 }
        }
    ]
    transitions: Transition {
        ColorAnimation { duration: Theme.durationFast }
        NumberAnimation { property: 'scale'; duration: Theme.durationFast }
    }

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

### Bedah kode (bagian baru)

- `color: Theme.primary` — warna di **state dasar**; `nonaktif` dan `ditekan` hanya mencatat selisihnya.
- `states: [ ... ]` — dua state yang dikendalikan data lewat `when`, bukan penugasan manual. Pemakai komponen tidak pernah menyentuh nama state; ia cukup mengisi `enabled` atau berinteraksi.
- `when: !root.enabled` — `enabled` adalah properti bawaan `Item` (5.1.7); `!` adalah negasi.
- `when: tap.pressed` — `pressed` dari `TapHandler`.
- Urutan: `nonaktif` ditulis lebih dulu, jadi ia menang bila beberapa `when` benar bersamaan.
- `transitions` memakai durasi dari token `Theme.durationFast`, sehingga tempo animasi seragam dan bisa dipadatkan dari satu tempat.
- `border.width: root.activeFocus ? 2 : 0` — **sengaja tidak dijadikan state.** Lihat bagian berikut.

```
 state dasar '' (normal) --enabled = false--> 'nonaktif'
 state dasar ''          --tap.pressed-----> 'ditekan' --lepas--> kembali
 (fokus keyboard ditangani binding terpisah, bukan state)
```

### Pelajaran penting: state itu eksklusif

Sebuah item berada di **tepat satu** state. Tetapi “ditekan” dan “berfokus” adalah dua aspek yang **independen**: tombol bisa keduanya sekaligus. Bila Anda memaksakan keduanya sebagai state dalam satu daftar, salah satu mengalahkan yang lain (misalnya cincin fokus hilang selagi ditekan). Dua jalan keluar:

```qml
// Jalan 1 — aspek independen cukup dengan binding (dipakai di atas)
border.width: root.activeFocus ? 2 : 0

// Jalan 2 — grup state terpisah untuk aspek independen
StateGroup {
    states: State {
        name: 'fokus'
        when: root.activeFocus
        PropertyChanges { target: root; border.width: 2 }
    }
}
```

`StateGroup` adalah kumpulan state mandiri yang tidak berebut dengan `states` milik item. Aturan praktis: **satu `states` untuk satu sumbu keadaan**.

### Catatan API

`state` adalah properti publik `Item`; karena root `AppButton` adalah `Rectangle`, pemakai *bisa* menimpanya dari luar (`AppButton { state: 'ditekan' }`). Bila itu tidak diinginkan, dokumentasikan bahwa `state` adalah internal, atau gunakan root `Item` dengan `Rectangle` internal (5.1.7 Opsi B) sehingga pemakai hanya melihat API yang Anda sediakan.

**Referensi bagian ini:** [StateGroup](https://doc.qt.io/qt-6/qml-qtquick-stategroup.html) · [Qt Quick States](https://doc.qt.io/qt-6/qtquick-statesanimations-states.html) · [Defining Object Types through QML Documents](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html)

## Terminologi Esensial

- **State** — keadaan visual bernama yang mencatat selisih dari state dasar.
- **State dasar (base state)** — keadaan awal item, bernama string kosong `''`.
- **`PropertyChanges`** — objek di dalam `State` yang mengubah properti sebuah target.
- **`restoreEntryValues`** — perilaku mengembalikan properti ke nilai sebelum state saat state ditinggalkan.
- **`explicit`** — pada `PropertyChanges`, menghitung ekspresi sekali alih-alih mempertahankannya sebagai binding.
- **`when`** — kondisi yang memasukkan state otomatis selama bernilai benar.
- **`extend`** — mewarisi perubahan state lain.
- **Transition** — daftar animasi yang berjalan saat state berubah.
- **`from` / `to`** — state asal dan tujuan yang dicocokkan transisi; `'*'` berarti sembarang.
- **`reversible`** — membuat transisi berlaku juga untuk arah sebaliknya.
- **`PropertyAction`** — mengubah properti seketika di tengah urutan animasi.
- **`StateChangeScript` / `ScriptAction`** — skrip yang dijalankan saat masuk state, dan aksi untuk menjalankannya pada titik tertentu transisi.
- **`AnchorChanges` / `AnchorAnimation`** — perubahan anchors di State dan animasinya.
- **`ParentChange` / `ParentAnimation`** — pemindahan induk di State dan animasinya.
- **`StateGroup`** — kumpulan state mandiri untuk objek non-`Item` atau aspek independen.
- **Finite state machine (mesin keadaan terbatas)** — model dengan himpunan state terbatas dan perpindahan yang dideklarasikan eksplisit.
- **`StateMachine`, `SignalTransition`, `TimeoutTransition`, `FinalState`** — tipe `QtQml.StateMachine`; masing-masing mesin, perpindahan karena signal, karena waktu, dan state akhir.
- **Alias impor (`as DSM`)** — nama pendek untuk menghindari bentrok nama tipe antar-modul.
- **Ledakan boolean** — pertumbuhan kombinasi mustahil ketika keadaan dinyatakan dengan banyak boolean.
- **Keadaan eksklusif** — sifat bahwa item berada di tepat satu state pada satu sumbu.

## Hubungan dengan Modul Lain

- **Prasyarat:** Fase 3 (properti, binding, signal), Modul 4.4 (`TapHandler`), Modul 5.1 (API komponen; `AppButton`), Modul 5.3 (`Theme`; token durasi dan warna).
- **Menuju Modul 6.2 (Animasi):** `Transition` hanya wadah; animasi di dalamnya (`NumberAnimation`, easing, `SequentialAnimation`, animator) dibahas penuh di sana.
- **Menuju Modul 6.3 (Input lanjut dan keyboard):** fokus, tekan, dan hover menghasilkan state; state fokus dan penanganan keyboard saling bergantung.
- **Menuju Modul 6.4 (Qt Quick ekstra):** `Settings` dapat menyimpan pilihan yang memengaruhi state (misalnya tema).
- **Ke jalur C++:** `QStateMachine` adalah padanan C++ dari `StateMachine` QML (modul yang sama).

## Kesalahan Umum dan Solusi

1. **Transisi tidak berjalan.** *Sebab:* `from`/`to` tak cocok (misalnya hanya ada transisi menuju `'aktif'`, tak ada untuk kembali ke `''`), properti tidak benar-benar berubah, tipe animasi tak sesuai, atau `enabled: false`. *Solusi:* ikuti diagram diagnosis di 6.1.3 dan pantau `onStateChanged`.
2. **Mengubah properti di state yang juga dikendalikan pengendali lain.** *Sebab:* `Behavior`, `Binding`, atau penugasan imperatif ikut menulis properti yang sama. *Akibat:* nilai berebut, perubahan hilang saat keluar state. *Solusi:* satu pengendali per properti.
3. **Memakai `State` untuk alur bisnis kompleks.** *Akibat:* perpindahan ilegal tak terhalang. *Solusi:* `StateMachine` (6.1.5) atau tabel perpindahan.
4. **Bentrok nama `State`.** *Sebab:* mengimpor `QtQml.StateMachine` tanpa alias. *Solusi:* `import QtQml.StateMachine as DSM`.
5. **Modul `QtQml.StateMachine` tidak ditemukan.** *Sebab:* paket belum terpasang. *Solusi:* `sudo pacman -S qt6-scxml`.
6. **Dua aspek independen dipaksa dalam satu `states`.** *Akibat:* salah satu mengalahkan yang lain. *Solusi:* binding untuk salah satunya, atau `StateGroup` terpisah (6.1.7).
7. **Mencampur `when` dan penugasan `state` imperatif.** *Akibat:* hasil bergantung urutan kejadian. *Solusi:* pilih satu.
8. **Nama state salah ketik.** *Akibat:* tak ada yang berubah. *Solusi:* periksa log terminal; gunakan satu sumber nama.
9. **Mencoba mengubah anchors lewat `PropertyChanges`.** *Solusi:* `AnchorChanges`, dan `AnchorAnimation` untuk animasinya.
10. **Menganimasikan `visible`.** *Sebab:* boolean tak bisa diinterpolasi. *Solusi:* animasikan `opacity` lalu ubah `visible` dengan `PropertyAction`.
11. **Lupa urutan prioritas `when`.** *Akibat:* state yang diharapkan tak pernah aktif. *Solusi:* letakkan state paling menentukan paling atas.

## Tips dan Praktik Terbaik

- **Turunkan state dari data** (`when: kotak.aktif`), jangan mengelolanya dengan penugasan manual.
- **Beri nama state dengan kata sifat atau keadaan** (`aktif`, `nonaktif`, `ditekan`), bukan kata kerja.
- **Jaga sedikit.** Bila satu item memiliki lebih dari sekitar lima state, mungkin ia memikul dua tanggung jawab.
- **Satu `states` untuk satu sumbu keadaan.** Aspek independen dipisah.
- **Durasi dari token tema** (`Theme.durationFast` / `durationNormal`) agar seragam. Untuk pengguna yang sensitif terhadap gerakan, pertimbangkan token `reduceMotion` yang membuat durasi menjadi 0; menghormati preferensi ini adalah bagian aksesibilitas.
- **Jangan menyandarkan makna pada warna atau gerak saja.** Keadaan nonaktif sebaiknya juga terbaca dari teks, ikon, atau perilaku, bukan hanya warna abu.
- **Keyboard harus memicu keadaan yang sama dengan pointer.** Jangan membuat state yang hanya bisa dicapai dengan mouse.
- **Untuk alur sensitif gunakan mesin keadaan.** Perpindahan yang tidak dideklarasikan tidak bisa terjadi; itu jaring pengaman keamanan yang murah.
- **Amati dengan `onStateChanged`** saat men-debug, lalu hapus bila tak diperlukan.

## Latihan 15 Menit (versi diperbaiki)

*Perbaikan dari audit:* kurikulum menyebut “state kedua `nonaktif`” tanpa pemicu. Di sini pemicunya `when: !kotak.enabled`, dan transisi dibuat berbeda untuk tiap tujuan.

1. Mulai dari contoh inti 6.1.1.
2. Tambahkan state `nonaktif`: warna abu, skala 0,9, dimasuki otomatis saat `kotak.enabled` bernilai salah.
3. Buat transisi masuk-`nonaktif` lebih lambat (500 ms, tanpa efek melenting) daripada masuk-`aktif` (250 ms, `OutBack`).
4. Pastikan perpindahan kembali ke state dasar juga beranimasi.
5. Tambahkan tombol di luar kotak untuk membalik `kotak.enabled` (karena kotak yang nonaktif tidak menerima ketukan).
6. Amati `onStateChanged` di terminal untuk memastikan urutan state.

**Kunci jawaban** (coba dulu sebelum membaca):

```qml
import QtQuick

Item {
    width: 360; height: 200

    Rectangle {
        id: kotak
        x: 20; y: 20; width: 120; height: 120; color: 'tomato'

        states: [
            State {
                name: 'aktif'
                PropertyChanges { target: kotak; color: 'seagreen'; scale: 1.2 }
            },
            State {
                name: 'nonaktif'
                when: !kotak.enabled
                PropertyChanges { target: kotak; color: 'gray'; scale: 0.9 }
            }
        ]

        transitions: [
            Transition {
                to: 'aktif'
                ColorAnimation { duration: 250 }
                NumberAnimation { property: 'scale'; duration: 250; easing.type: Easing.OutBack }
            },
            Transition {
                to: 'nonaktif'
                ColorAnimation { duration: 500 }
                NumberAnimation { property: 'scale'; duration: 500; easing.type: Easing.InOutQuad }
            },
            Transition {
                to: ''
                ColorAnimation { duration: 250 }
                NumberAnimation { property: 'scale'; duration: 250 }
            }
        ]

        onStateChanged: console.log('state:', state === '' ? '(dasar)' : state)

        TapHandler { onTapped: kotak.state = (kotak.state === 'aktif' ? '' : 'aktif') }
    }

    AppButton {
        x: 200; y: 20
        label: kotak.enabled ? 'Nonaktifkan' : 'Aktifkan'
        onClicked: kotak.enabled = !kotak.enabled
    }
}
```

- Tiga `Transition` memakai `to` yang saling lepas (`'aktif'`, `'nonaktif'`, `''`), sehingga tidak ada keraguan transisi mana yang dipilih.
- Transisi `to: ''` dibutuhkan agar kembali ke state dasar juga beranimasi; tanpanya kotak meloncat kembali (inilah gejala “transisi tidak cocok”).
- Karena `nonaktif` dikendalikan `when` dan `aktif` dengan penugasan imperatif, contoh ini sengaja sederhana. Pada kode nyata, jadikan `aktif` juga berbasis data (`when: kotak.aktif`) agar tak ada dua pengendali (lihat 6.1.2).
- Yang akan Anda amati: kotak yang nonaktif tidak bereaksi pada ketukan, mengecil dan memudar lambat ke abu; saat diaktifkan kembali ia kembali ke state dasar dengan animasi 250 ms.

**Tantangan opsional:** tulis ulang kotak itu sebagai komponen dengan properti `aktif` (6.1.2) dan state `nonaktif` internal, seperti `AppButton` di 6.1.7.

## Cek Pemahaman dan Kunci

1. **Kapan `StateMachine` lebih tepat daripada `State`?** *Kunci:* ketika Anda perlu mengatur *alur logika*: perpindahan yang sah dan dipicu secara eksplisit (signal, waktu), aksi saat masuk dan keluar, atau alur sensitif yang tidak boleh melompati langkah. `State` hanya mendeskripsikan tampilan dan bisa dimasuki dari mana saja.
2. **Mengapa `State` disebut “selisih” dari state dasar?** *Kunci:* ia hanya mencatat properti yang *berbeda*; nilai lain tetap dari state dasar, dan saat keluar nilai dikembalikan.
3. **Apa yang terjadi bila dua `when` bernilai benar bersamaan?** *Kunci:* state yang tertulis lebih dulu dalam daftar `states` yang dipakai.
4. **Mengapa transisi “kembali ke state dasar” bisa tidak beranimasi?** *Kunci:* tidak ada `Transition` yang cocok dengan perpindahan itu (mis. hanya `to: 'aktif'`); tambahkan `to: ''` atau transisi wildcard.
5. **Mengapa cincin fokus tidak dijadikan state pada `AppButton`?** *Kunci:* state eksklusif, sedangkan fokus dan tekan adalah aspek independen; fokus ditangani dengan binding atau `StateGroup` terpisah.
6. **Mengapa `QtQml.StateMachine` diimpor dengan alias?** *Kunci:* karena modul itu dan `QtQuick` sama-sama mendefinisikan tipe `State`.

## Referensi Tambahan

- [Qt Quick States](https://doc.qt.io/qt-6/qtquick-statesanimations-states.html)
- [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html)
- [Qt State Machine QML Types](https://doc.qt.io/qt-6/qtqml-statemachine-qmlmodule.html)
- [Qt State Machine Overview](https://doc.qt.io/qt-6/qtstatemachine-overview.html)
- [Qt SCXML](https://doc.qt.io/qt-6/qtscxml-index.html)
- [Statecharts — Harel (1987)](<https://doi.org/10.1016/0167-6423(87)90035-9>)
- [Qt — Arch Wiki](https://wiki.archlinux.org/title/Qt)

---

*Rancang keadaannya dengan jelas; gerakannya akan mengikuti dengan sendirinya.*

# Fase 6 · Modul 6.2 — Animasi

*Kurikulum Qt 6 QML · Fase 6 (Interaksi, State, dan Animasi) · Modul 2 dari 4 (6.1 → 6.2 → 6.3 → 6.4)*

## Daftar Isi Modul 6.2

- Audit singkat Modul 6.2 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 6.2.1 `NumberAnimation`, `ColorAnimation`, `PropertyAnimation`
- 6.2.2 `Behavior`
- 6.2.3 Easing
- 6.2.4 Animasi berurutan dan paralel
- 6.2.5 Animator di render thread
- 6.2.6 `SpringAnimation`
- 6.2.7 Biaya animasi
- 6.2.8 \[TAMBAHAN\] `Animation on <properti>` dan kendali animasi
- 6.2.9 \[TAMBAHAN\] Animasi lain yang jarang dibahas
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Referensi tambahan

## Audit Singkat Modul 6.2 (sebelum materi dimulai)

Urutan Modul 6.2 logis: ia mengisi `Transition` dari 6.1 dengan animasi nyata dan mendahului input di 6.3. Catatan audit untuk Modul 6.3 dan 6.4 tetap seperti yang tercantum di dokumen Modul 6.1. Temuan untuk 6.2 dibereskan di materi ini:

1. **\[Koreksi\] Contoh `bola.x`.** Handler `bola.x = bola.x === 0 ? 200 : 0` membaca nilai `x` *di tengah animasi*. Bila diketuk saat bola belum sampai, `x` bukan 0 maupun 200, sehingga jalannya tidak konsisten. Perbaikan: simpan *niat* dalam sebuah boolean (`kanan`) dan ikat `x: kanan ? 200 : 0`. Dijelaskan di 6.2.2.
2. **\[Perbaikan\] Animasi tak berhingga.** `SequentialAnimation on y` dengan `loops: Animation.Infinite` terus berjalan walau item tak terlihat, menghabiskan CPU dan GPU. Ikat `running` ke visibilitas. Dijelaskan di 6.2.7 dan 6.2.8.
3. **\[Klarifikasi, sudah diverifikasi pada dokumentasi Qt\] Animator.** Animator berjalan di thread render dan tetap bergerak ketika thread GUI tersendat; **nilai properti QML tidak diperbarui selama animasi berjalan** (baru diperbarui setelah selesai); mereka tidak bermanfaat bila *render loop* bukan `threaded`; target harus berbasis `Item`; mereka bisa dipakai di dalam `Transition` tetapi tidak mendukung `reversible`; tipe `Animator` sendiri tak bisa dibuat langsung (pakai turunannya: `XAnimator`, `YAnimator`, `OpacityAnimator`, `ScaleAnimator`, `RotationAnimator`, `UniformAnimator`). Dijelaskan di 6.2.5, termasuk akibatnya pada area ketuk.
4. **\[Klarifikasi\] Latihan.** Perbandingan `NumberAnimation` dan `YAnimator` butuh kode yang membebani thread utama; kurikulum tidak menyediakannya. Disediakan di bagian latihan, bersama catatan resmi Qt bahwa untuk aplikasi nyata pekerjaan berat sebaiknya dipindah dari thread GUI, bukan ditutupi animator.
5. **\[Tambahan\] Yang belum tercakup:** sintaks `Animation on <properti>` dan kendali `start` / `stop` / `pause` / `resume` / `restart` / `complete` (6.2.8); `PauseAnimation`, `PropertyAction`, `ScriptAction`, `RotationAnimation`, `SmoothedAnimation`, `PathAnimation`, dan `Easing.BezierSpline` (6.2.3 dan 6.2.9).
6. **\[Klarifikasi\] `Behavior`** hanya bereaksi pada *perubahan* nilai, bukan nilai awal, dan dapat dimatikan sementara lewat `enabled` (6.2.2).
7. **\[Tambahan\] 6.2.7 diperluas:** properti murah versus mahal untuk dianimasikan, anggaran frame, alat ukur terminal (`QSG_RENDER_TIMING`, `QSG_VISUALIZE`, `QML Profiler`), dan animasi yang bertanggung jawab (gerak berkurang).

**Daftar Modul 6.2 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

- 6.2.1 `NumberAnimation`, `ColorAnimation`, `PropertyAnimation`
- 6.2.2 `Behavior`
- 6.2.3 Easing
- 6.2.4 Animasi berurutan dan paralel
- 6.2.5 Animator di render thread
- 6.2.6 `SpringAnimation`
- 6.2.7 Biaya animasi
- &#91;+\] 6.2.8 `Animation on <properti>` dan kendali animasi
- &#91;+\] 6.2.9 Animasi lain yang jarang dibahas

**Asumsi prasyarat.** Modul 6.1 (`State`, `Transition`), Modul 4.4 (`TapHandler`), dan Fase 5 (`Theme`; contoh yang memakai `Theme.durationFast` mengasumsikan singleton dari Modul 5.3 sudah ada).

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini mengajarkan cara membuat nilai properti *berubah mulus seiring waktu*: animasi dasar (`NumberAnimation`, `ColorAnimation`), aturan tetap (`Behavior`), kurva percepatan (easing), penyusunan berurutan dan paralel, animator yang berjalan di thread render, dan animasi fisika (`SpringAnimation`). Ditambah satu hal yang sering dilupakan: *biaya* sebuah animasi.

### Peran dalam kurikulum

Di 6.1 Anda menyatakan keadaan; di sini Anda menyatakan *gerak* di antara keadaan. Animasi yang baik memberi umpan balik (“tombol ini baru saja ditekan”), menjaga kesinambungan (“panel ini datang dari kanan”), dan mengarahkan perhatian. Animasi yang buruk memperlambat, melelahkan mata, dan menguras daya.

### Konsep kunci dan filosofi

- **Interpolasi.** Animasi hanyalah pengisian nilai di antara dua titik. Anda menyebut tujuan dan durasi; engine mengisi langkah di antaranya. Seperti film animasi: pembuat hanya menggambar gambar kunci, sisanya diisi.
- **Berbasis waktu, bukan berbasis frame.** Qt menghitung nilai dari *waktu yang telah berlalu*, bukan dari jumlah frame. Animasi 400 ms tetap 400 ms di layar 60 Hz maupun 144 Hz; yang berbeda hanya kehalusannya.
- **Gerak adalah informasi.** Gerak menjawab “dari mana dan ke mana”. Bila gerak tidak membawa informasi, ia hiasan, dan hiasan harus murah.
- **Deklaratif.** Seperti state, Anda menyatakan *apa* yang harus terjadi (`Behavior on x`), bukan menghitung posisi tiap frame.
- **Animasi punya biaya.** Setiap frame ia memicu evaluasi binding, penyusunan ulang tata letak, dan penggambaran. Animasi yang berjalan tanpa terlihat mencuri baterai.
- **Kendali pengguna lebih penting daripada gaya.** Sebagian pengguna terganggu atau sakit oleh gerak berlebihan. Animasi bukan fitur yang boleh dipaksakan (dibahas di 6.2.7).

Alur satu animasi (ASCII):

```
  waktu mulai                                            waktu selesai
     |-------------------- duration (ms) ------------------|
  from ---- nilai dihitung tiap frame dari (waktu berlalu / duration) ----> to
                 |
                 +--> kurva easing mengubah 'kecepatan' nilai itu (6.2.3)
```

## 6.2.1 `NumberAnimation`, `ColorAnimation`, `PropertyAnimation`

### Dasar: apa itu animasi properti?

`PropertyAnimation` adalah induk semua animasi yang mengubah properti. Turunannya spesifik tipe:

- `NumberAnimation` — properti bertipe angka (`x`, `y`, `width`, `opacity`, `scale`, `rotation`).
- `ColorAnimation` — properti bertipe warna (`color`).
- `RotationAnimation` — rotasi dengan kendali arah putar (6.2.9).
- `Vector3dAnimation` — vektor tiga dimensi.
- `PropertyAnimation` (induk) — bila tipe tidak diketahui atau beragam.
- `ParentAnimation`, `AnchorAnimation` — sudah Anda temui di 6.1.4.

Praktik umum: gunakan tipe yang paling spesifik, karena maksudnya lebih jelas dan interpolasinya tepat untuk tipe itu.

### Sintaks dasar

```
NumberAnimation {
    target: <id>              // objek yang dianimasikan (atau targets: [a, b])
    property: 'x'             // satu properti (atau properties: 'x,y' untuk beberapa)
    from: <nilai>             // opsional; bawaan: nilai saat animasi mulai
    to: <nilai>               // tujuan
    duration: 250             // milidetik; bawaan 250
    easing.type: Easing.InOutQuad
    running: false            // true: mulai segera; atau panggil start()
}
```

### Contoh inti

```qml
import QtQuick

Window {
    width: 320; height: 120; visible: true

    Rectangle {
        id: kotak
        y: 30; width: 60; height: 60; color: 'tomato'

        NumberAnimation {
            id: geser
            target: kotak
            property: 'x'
            to: 240
            duration: 600
            easing.type: Easing.InOutQuad
        }

        ColorAnimation {
            id: warna
            target: kotak
            property: 'color'
            to: 'seagreen'
            duration: 600
        }

        TapHandler { onTapped: { geser.restart(); warna.restart() } }
    }
}
```

### Bedah kode (kata demi kata)

- `NumberAnimation { id: geser ... }` — objek animasi bernama `geser`. Ia *tidak tampak* dan **tidak berjalan sendiri**: animasi yang dideklarasikan seperti ini menunggu dimulai.
- `target: kotak` — objek yang dianimasikan (dirujuk lewat id).
- `property: 'x'` — nama properti yang diubah, ditulis sebagai string.
- `to: 240` — nilai akhir. `from` tidak ditulis, jadi animasi mulai dari nilai `x` *saat itu*.
- `duration: 600` — lama animasi dalam milidetik.
- `easing.type: Easing.InOutQuad` — kurva percepatan (6.2.3): pelan di awal, cepat di tengah, pelan di akhir.
- `ColorAnimation { property: 'color'; to: 'seagreen' }` — versi khusus warna: nilai diinterpolasi per komponen warna.
- `geser.restart()` — memulai animasi dari awal. Berbeda dengan `start()`: memanggil `start()` pada animasi yang *sedang berjalan* tidak berefek, sedangkan `restart()` menghentikan lalu memulai lagi. Jadi untuk ketukan berulang, `restart()` lebih tepat.
- Setelah selesai, `x` bernilai 240 dan tetap di sana: animasi **mengubah nilai sungguhan** properti, tidak hanya tampilannya.

### Beberapa properti sekaligus

```qml
// satu animasi, dua properti, nilai tujuan sama
NumberAnimation { target: kotak; properties: 'x,y'; to: 100; duration: 300 }

// banyak objek, satu properti
NumberAnimation { targets: [a, b, c]; property: 'opacity'; to: 0; duration: 300 }

// banyak objek, kecuali satu properti tertentu
PropertyAnimation { targets: [a, b]; properties: 'x,y,opacity'; exclude: ['opacity']; to: 0 }
```

- `properties` adalah satu string dengan nama dipisah koma.
- `targets` adalah daftar objek.
- `exclude` mengeluarkan properti tertentu dari yang dianimasikan.

### Opsi lain untuk “menggerakkan kotak”

```qml
// Opsi 1 — NumberAnimation imperatif (di atas): dipicu manual, cocok untuk efek sekali
// Opsi 2 — Behavior (6.2.2): aturan tetap, animasi muncul tiap nilai berubah
// Opsi 3 — State + Transition (6.1): bila banyak properti dan keadaan
// Opsi 4 — XAnimator (6.2.5): sama, tetapi tetap mulus saat thread GUI tersendat
// Opsi 5 — SpringAnimation (6.2.6): gerak berbasis fisika, tanpa durasi tetap
```

### Hal yang perlu diperhatikan

- **Durasi:** sekitar 100–300 ms untuk umpan balik kecil, 300–500 ms untuk perpindahan besar. Lebih lama terasa lamban kecuali memang dekoratif.
- **Gunakan token tema** untuk durasi (`Theme.durationFast`, `Theme.durationNormal`) agar seragam.
- **Animasi mengubah nilai sebenarnya.** Binding yang membaca `x` ikut berubah tiap frame.
- **Jangan menganimasikan properti yang sedang terikat binding** tanpa memahami akibatnya: animasi menimpa binding selama berjalan (6.2.8).

**Referensi bagian ini:** [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html) · [PropertyAnimation](https://doc.qt.io/qt-6/qml-qtquick-propertyanimation.html) · [NumberAnimation](https://doc.qt.io/qt-6/qml-qtquick-numberanimation.html) · [ColorAnimation](https://doc.qt.io/qt-6/qml-qtquick-coloranimation.html) · [Animation (start, restart, running)](https://doc.qt.io/qt-6/qml-qtquick-animation.html)

## 6.2.2 `Behavior`

### Dasar: aturan tetap untuk sebuah properti

`Behavior` mengatakan: “setiap kali properti ini **berubah nilai**, jangan meloncat, tempuh dengan animasi ini”. Anda tidak memulai animasinya; perubahan nilai itulah pemicunya, apa pun sumbernya (penugasan, binding yang dihitung ulang, handler).

```
 x berubah: 0 --> 240   (misalnya karena binding x: kanan ? 240 : 0)
    |
    v
 Behavior mencegat perubahan itu
    |
    v
 animasi menempuh 0 -> 240   (bila berubah lagi di tengah jalan: mulai dari posisi sekarang
                              menuju tujuan baru, tanpa loncatan)
```

### Contoh inti (versi diperbaiki dari kurikulum)

```qml
import QtQuick

Window {
    width: 320; height: 120; visible: true

    Item {
        anchors.fill: parent
        TapHandler { onTapped: bola.kanan = !bola.kanan }

        Rectangle {
            id: bola
            property bool kanan: false

            y: 40; width: 40; height: 40; radius: 20; color: 'steelblue'
            x: kanan ? 240 : 0

            Behavior on x {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `property bool kanan: false` — *niat* (data) yang menggerakkan tampilan. Handler hanya membaliknya; ia tidak menghitung posisi.
- `x: kanan ? 240 : 0` — binding: bila `kanan` benar, `x` 240; selain itu 0. Binding ini menggantikan pola rapuh `bola.x === 0 ? 200 : 0` pada kurikulum: sekarang tidak ada pembacaan nilai di tengah animasi.
- `Behavior on x { ... }` — aturan untuk properti `x` milik objek pemiliknya. Sintaks `Behavior on <properti>`.
- `NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }` — animasi yang dijalankan; **tanpa** `target`, `property`, `from`, `to`: semuanya diisi otomatis dari perubahan yang memicunya.
- `TapHandler` di item seukuran jendela — agar ketukan di mana pun diterima, bukan hanya di bola yang kecil dan bergerak.

### Sifat penting `Behavior`

- **Hanya untuk perubahan.** Nilai awal (`x` saat objek dibuat) tidak dianimasikan.
- **Satu animasi per `Behavior`.** Untuk beberapa, bungkus dengan `ParallelAnimation` atau `SequentialAnimation` (6.2.4).
- **Dapat dimatikan:** `enabled: false` membuat perubahan terjadi seketika. Berguna saat pengguna menyeret:

```qml
Rectangle {
    id: kartu
    width: 80; height: 80; color: 'orchid'

    Behavior on x { enabled: !seret.active; NumberAnimation { duration: 200 } }
    Behavior on y { enabled: !seret.active; NumberAnimation { duration: 200 } }

    DragHandler { id: seret }                       // saat diseret: ikut pointer seketika
    TapHandler { onTapped: { kartu.x = 0; kartu.y = 0 } }   // ketuk: kembali ke asal dengan animasi
}
```

- `DragHandler { id: seret }` — menggeser item induknya mengikuti pointer; `seret.active` benar selama ditarik.
- `enabled: !seret.active` — saat ditarik, tak ada animasi (kartu menempel pada pointer); saat dilepas dan `x`/`y` diubah lewat kode, animasi aktif lagi.

### Opsi lain untuk efek yang sama

```qml
// Opsi 1 — Behavior (di atas): paling ringkas; pemicunya perubahan data
Behavior on x { NumberAnimation { duration: 400 } }

// Opsi 2 — animasi imperatif: Anda memutuskan kapan dan ke mana
NumberAnimation { id: geser; target: bola; property: 'x'; duration: 400 }
// onTapped: { geser.to = bola.x === 0 ? 240 : 0; geser.restart() }   // tetap rapuh bila ditekan di tengah jalan

// Opsi 3 — State + Transition (6.1): bila banyak properti ikut berubah bersama
states: State { name: 'kanan'; when: bola.kanan; PropertyChanges { target: bola; x: 240 } }
transitions: Transition { NumberAnimation { property: 'x'; duration: 400 } }
```

### Hal yang perlu diperhatikan

- **Jangan memasang `Behavior` dan animasi `Transition` pada properti yang sama** tanpa sengaja (6.1.6).
- **Hindari `Behavior` pada `x`/`y`/`width`/`height` item di dalam `Layout` atau positioner**: penataan dan animasi akan berebut menulis properti yang sama. Gunakan transisi `add`/`move` pada positioner (5.2.4) atau animasikan `scale`/`opacity`.
- **`Behavior` tidak bereaksi bila nilai baru sama dengan nilai lama.**
- **Boolean dan string tidak bisa diinterpolasi.** Untuk `visible`, animasikan `opacity` lalu ubah `visible` dengan `PropertyAction` (6.1.3).
- **Animasi yang sedang berjalan dapat dialihkan di tengah jalan**; itu keunggulan `Behavior` dibanding animasi imperatif bertujuan tetap.

**Referensi bagian ini:** [Behavior](https://doc.qt.io/qt-6/qml-qtquick-behavior.html) · [DragHandler](https://doc.qt.io/qt-6/qml-qtquick-draghandler.html) · [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html)

## 6.2.3 Easing

### Dasar: easing adalah kurva waktu→nilai

Secara bawaan nilai bergerak dengan kecepatan konstan (*linear*): terasa mekanis, seperti robot. Benda nyata mempercepat dan memperlambat. **Easing** adalah kurva yang memetakan *progres waktu* (0 sampai 1) ke *progres nilai* (0 sampai 1). Mengganti kurva mengubah “karakter” gerak tanpa mengubah durasi maupun tujuan.

Profil kecepatan beberapa kurva (huruf makin besar = makin cepat; lima irisan waktu):

```
 Linear    : o o o o o        kecepatan konstan
 InQuad    : . . o O O        mulai pelan, makin cepat
 OutQuad   : O O o . .        mulai cepat, melambat di akhir
 InOutQuad : . o O o .        pelan - cepat - pelan
 OutBack   : O o . . ~        melewati tujuan sedikit lalu kembali (~ = melenting)
```

### Sintaks

```
NumberAnimation {
    easing.type: Easing.OutCubic          // pilihan kurva
    easing.amplitude: 1.0                 // kekuatan: Elastic dan Bounce
    easing.period: 0.3                    // periode getaran: Elastic
    easing.overshoot: 1.7                 // seberapa jauh melewati tujuan: Back
    easing.bezierCurve: [cx1, cy1, cx2, cy2, 1, 1]   // khusus Easing.BezierSpline
}
```

### Keluarga kurva

- `Easing.Linear` — kecepatan konstan. Cocok untuk putaran pemuat (*spinner*) dan bilah kemajuan.
- `Quad`, `Cubic`, `Quart`, `Quint` — keluarga polinomial (pangkat 2 sampai 5); makin tinggi pangkat, makin tajam percepatannya. `Cubic` adalah pilihan serbaguna.
- `Sine`, `Expo`, `Circ` — berbasis fungsi sinus, eksponensial, dan lingkaran; karakter makin berbeda.
- `Elastic` — berayun seperti pegas yang meredam (butuh `amplitude` dan `period`).
- `Back` — menarik mundur atau melewati tujuan lalu kembali (`overshoot`).
- `Bounce` — memantul seperti bola.
- `Easing.BezierSpline` — kurva kustom lewat `easing.bezierCurve`.

Setiap keluarga (kecuali `Linear` dan `BezierSpline`) punya empat varian awalan: `In`, `Out`, `InOut`, dan `OutIn` (misalnya `Easing.InQuad`, `Easing.OutQuad`, `Easing.InOutQuad`, `Easing.OutInQuad`).

### Contoh: membandingkan kurva berdampingan

```qml
import QtQuick

Window {
    id: win
    width: 380; height: 250; visible: true
    title: 'Easing'

    property bool kanan: false
    readonly property var jenis: [Easing.Linear, Easing.InQuad, Easing.OutQuad,
                                  Easing.InOutQuad, Easing.OutBack, Easing.OutBounce]
    readonly property var nama: ['Linear', 'InQuad', 'OutQuad', 'InOutQuad', 'OutBack', 'OutBounce']

    Item {
        anchors.fill: parent
        TapHandler { onTapped: win.kanan = !win.kanan }

        Column {
            x: 10; y: 10; spacing: 6

            Repeater {
                model: 6
                Item {
                    id: baris
                    required property int index
                    width: 360; height: 30

                    Text { y: 6; width: 80; text: win.nama[baris.index]; font.pixelSize: 12 }

                    Rectangle {
                        y: 5; width: 20; height: 20; radius: 10; color: 'steelblue'
                        x: 90 + (win.kanan ? 240 : 0)
                        Behavior on x {
                            NumberAnimation { duration: 900; easing.type: win.jenis[baris.index] }
                        }
                    }
                }
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `readonly property var jenis: [Easing.Linear, ...]` — daftar nilai enum easing; `var` karena isinya larik. `Easing.Linear` dan kawan-kawan sebenarnya bilangan bulat.
- `readonly property var nama: [...]` — label teks untuk setiap baris.
- `Repeater { model: 6 }` — membuat enam baris; `required property int index` memberi nomor urut tiap baris (gaya Qt 6).
- `win.nama[baris.index]` — mengambil label ke-`index`; rujukan lewat id `win` (eksplisit, tidak tak-terkualifikasi).
- `x: 90 + (win.kanan ? 240 : 0)` — binding posisi; `Behavior on x` yang menjalankan animasi bila `win.kanan` berganti.
- `easing.type: win.jenis[baris.index]` — setiap titik memakai kurva berbeda dengan durasi sama (900 ms).
- Ketuk di mana saja: keenam titik bergerak bersamaan, dan perbedaan karakter gerak terlihat jelas.

### Easing kustom dengan Bezier

```qml
NumberAnimation {
    duration: 300
    easing.type: Easing.BezierSpline
    easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
}
```

- `Easing.BezierSpline` — mengaktifkan kurva kustom.
- `easing.bezierCurve` — kelompok tiga titik: `[kendali1X, kendali1Y, kendali2X, kendali2Y, akhirX, akhirY]`, dan **titik terakhir harus 1,1**. Kurva dimulai di (0,0). Daftar dapat berisi beberapa segmen berurutan.
- Nilai `[0.2, 0, 0, 1]` mirip kurva *standard* pada pedoman gerak Material 3 (verifikasi nilai pastinya di dokumentasi Material), yang cepat melambat dengan halus.

Agar konsisten, simpan kurva sebagai token (Modul 5.3):

```qml
// di Theme.qml
readonly property var curveStandard: [0.2, 0, 0, 1, 1, 1]
// pemakaian
easing.type: Easing.BezierSpline
easing.bezierCurve: Theme.curveStandard
```

### Memilih kurva (aturan praktis)

- **Elemen masuk** (muncul di layar): `Out*`. Mulai cepat dan melambat: terasa responsif.
- **Elemen keluar:** `In*`. Mulai pelan lalu cepat meninggalkan layar.
- **Perpindahan di dalam layar** (dari A ke B): `InOut*`.
- **Putaran tak berujung:** `Linear`.
- **Bernuansa main-main:** `OutBack`, `OutElastic`, `OutBounce`, hemat dan jangan di antarmuka serius atau sensitif (dialog konfirmasi, peringatan keamanan).
- **Kurva tajam butuh durasi pendek.** `Quint` terasa lama bila dipanjangkan.

### Opsi lain untuk “karakter gerak”

```qml
// Opsi 1 — easing pada animasi berdurasi tetap (di atas)
// Opsi 2 — SpringAnimation (6.2.6): karakter dari fisika pegas, tanpa durasi tetap
// Opsi 3 — SmoothedAnimation (6.2.9): kecepatan terbatas, mulus saat tujuan sering berganti
// Opsi 4 — Easing.BezierSpline: kurva buatan sendiri, konsisten dengan sistem desain
```

**Referensi bagian ini:** [Easing curves (daftar lengkap pada Animator/PropertyAnimation)](https://doc.qt.io/qt-6/qml-qtquick-propertyanimation.html) · [Easing Curves (demo)](https://doc.qt.io/qt-6/qtquick-demos-easing-example.html) · [Material Design — Easing and duration](https://m3.material.io/styles/motion/easing-and-duration/tokens-specs)

## 6.2.4 Animasi berurutan dan paralel

### Dasar: dua cara menyusun animasi

- **`SequentialAnimation`** — menjalankan anak-anaknya *satu per satu*. Total durasi = jumlah durasi anak.
- **`ParallelAnimation`** — menjalankan anak-anaknya *bersamaan*. Total durasi = durasi anak terpanjang.

Keduanya boleh disarangkan, sehingga koreografi apa pun bisa dibangun dari dua blok ini.

```
 Sequential:   |--- A ---|--- B ---|--- C ---|              total = A + B + C

 Parallel:     |--- A ---------|
               |--- B ---|
               |--- C ---------------|                     total = yang terpanjang
```

Pada `Transition` (6.1.3), isinya sudah *paralel* secara bawaan.

### Contoh inti: kartu yang masuk dengan memantul

```qml
import QtQuick

Window {
    width: 320; height: 200; visible: true

    Item {
        anchors.fill: parent
        TapHandler { onTapped: masuk.restart() }

        Rectangle {
            id: kartu
            x: 110; y: 60; width: 100; height: 70; radius: 8; color: 'seagreen'; opacity: 0

            SequentialAnimation {
                id: masuk

                ParallelAnimation {
                    NumberAnimation { target: kartu; property: 'opacity'; from: 0; to: 1; duration: 250 }
                    NumberAnimation { target: kartu; property: 'y'; from: 90; to: 60; duration: 250
                                      easing.type: Easing.OutCubic }
                }
                NumberAnimation { target: kartu; property: 'scale'; to: 1.08; duration: 90 }
                NumberAnimation { target: kartu; property: 'scale'; to: 1.0; duration: 90 }
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `SequentialAnimation { id: masuk ... }` — wadah urutan; tidak tampak dan tidak berjalan sampai dimulai (`masuk.restart()` dari ketukan).
- `ParallelAnimation { ... }` — dua animasi *bersamaan*: memudar masuk (`opacity` 0 ke 1) dan naik (`y` 90 ke 60) selama 250 ms. Karena paralel, total durasinya tetap 250 ms.
- `from:` ditulis eksplisit pada langkah pertama agar setiap pengulangan mulai dari titik yang sama, tidak dari nilai akhir sebelumnya.
- Dua `NumberAnimation` `scale` berurutan — membesar ke 1,08 lalu kembali ke 1,0 selama 90 ms masing-masing: efek “melenting” kecil *setelah* kartu tiba.
- Total durasi: 250 + 90 + 90 = 430 ms.
- Tiap anak punya `target` sendiri: `SequentialAnimation`/`ParallelAnimation` tidak menurunkan `target` ke anak.

### Berurutan dengan jeda dan tindakan

```qml
SequentialAnimation {
    NumberAnimation { target: kartu; property: 'opacity'; to: 1; duration: 200 }
    PauseAnimation { duration: 300 }                         // jeda 300 ms
    ScriptAction { script: console.log('selesai muncul') }   // jalankan kode
    PropertyAction { target: kartu; property: 'visible'; value: false }   // ubah seketika
}
```

- `PauseAnimation { duration: ... }` — menunggu tanpa mengubah apa pun.
- `ScriptAction { script: ... }` — menjalankan kode JavaScript pada titik itu.
- `PropertyAction { target; property; value }` — mengubah properti seketika pada titik itu (cocok untuk `visible` yang tak bisa diinterpolasi).

### Pola bertingkat (stagger)

```qml
Row {
    spacing: 8
    Repeater {
        model: 5
        Rectangle {
            id: item
            required property int index
            width: 40; height: 40; radius: 6; color: 'steelblue'; opacity: 0

            SequentialAnimation {
                running: true
                PauseAnimation { duration: item.index * 80 }       // tiap item menunggu lebih lama
                NumberAnimation { target: item; property: 'opacity'; to: 1; duration: 200 }
            }
        }
    }
}
```

Setiap item menunggu `index * 80` ms sebelum muncul, sehingga daftar “mengalir” masuk satu per satu. Pola ini sangat murah dan efektif untuk daftar atau grid yang pertama kali tampil.

### Pengulangan

```qml
SequentialAnimation {
    loops: 3                       // 3 kali; Animation.Infinite = tanpa henti
    alwaysRunToEnd: true           // bila running diset false, putaran yang berjalan diselesaikan dulu
    // ...
}
```

- `loops: N` — jumlah pengulangan; `Animation.Infinite` untuk tanpa henti (waspadai biaya, 6.2.7).
- `alwaysRunToEnd: true` — bila animasi dihentikan di tengah putaran, putaran itu diselesaikan dulu agar nilai tidak tertinggal di tengah jalan (berlaku bersama `loops`).

### Opsi lain untuk koreografi

```qml
// Opsi 1 — Sequential/Parallel bersarang (di atas): paling fleksibel
// Opsi 2 — Transition (6.1.3): paralel bawaan, dipicu perubahan state
// Opsi 3 — rangkaian Behavior: tiap properti punya aturan sendiri (tanpa koordinasi waktu)
// Opsi 4 — SmoothedAnimation / SpringAnimation: gerak mengikuti tujuan yang terus berubah
```

### Hal yang perlu diperhatikan

- **Mulai dari nilai tetap** (`from`) pada koreografi yang bisa diulang.
- **Satu koreografi, satu pemilik.** Jangan menjalankan dua animasi berbeda pada properti yang sama bersamaan; hasilnya berebut.
- **Hati-hati animasi tak berhingga** pada item yang sering tak terlihat.

**Referensi bagian ini:** [SequentialAnimation](https://doc.qt.io/qt-6/qml-qtquick-sequentialanimation.html) · [ParallelAnimation](https://doc.qt.io/qt-6/qml-qtquick-parallelanimation.html) · [PauseAnimation](https://doc.qt.io/qt-6/qml-qtquick-pauseanimation.html) · [PropertyAction](https://doc.qt.io/qt-6/qml-qtquick-propertyaction.html) · [ScriptAction](https://doc.qt.io/qt-6/qml-qtquick-scriptaction.html) · [Animation (loops, alwaysRunToEnd)](https://doc.qt.io/qt-6/qml-qtquick-animation.html)

## 6.2.5 Animator di render thread

### Dasar: dua thread, dua cara bekerja

Qt Quick punya dua thread penting: **thread GUI** (utama) yang menjalankan QML, binding, dan JavaScript, dan **thread render** yang menggambar *scene graph* (pohon simpul yang mewakili apa yang akan digambar). Animasi biasa (`NumberAnimation` dan kawan-kawan) berjalan di thread GUI: setiap frame ia menulis nilai properti, memicu binding dan penataan, lalu hasilnya disinkronkan ke scene graph. Bila thread GUI tersendat (JavaScript berat, I/O), animasi ikut tersendat.

**Animator** bekerja langsung pada scene graph di thread render. Ia tetap bergerak mulus walaupun thread GUI sedang sibuk.

```
  Thread GUI (utama)                 Thread render
  -------------------------          -----------------------------------
  NumberAnimation:                   Animator:
   hitung nilai tiap frame            menggerakkan simpul scene graph
   -> tulis properti QML              LANGSUNG; properti QML TIDAK berubah
   -> sinkron ke scene graph          sampai animasi selesai
  GUI macet  = animasi macet         GUI macet  = animasi tetap mulus
```

### Jenis animator

- `XAnimator`, `YAnimator` — posisi.
- `OpacityAnimator` — transparansi.
- `ScaleAnimator` — skala.
- `RotationAnimator` — rotasi.
- `UniformAnimator` — uniform shader (untuk `ShaderEffect`).

`Animator` sendiri adalah tipe dasar yang **tidak bisa dibuat langsung**: gunakan salah satu turunannya. Properti umumnya `target`, `from`, `to`, `duration` (bawaan 250 ms), dan `easing`.

### Contoh inti

```qml
import QtQuick

Window {
    width: 200; height: 160; visible: true

    Rectangle {
        id: bola
        x: 80; width: 40; height: 40; radius: 20; color: 'steelblue'

        SequentialAnimation {
            running: bola.visible
            loops: Animation.Infinite
            YAnimator { target: bola; from: 0;   to: 100; duration: 600; easing.type: Easing.InOutQuad }
            YAnimator { target: bola; from: 100; to: 0;   duration: 600; easing.type: Easing.InOutQuad }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `YAnimator { target: bola; from: 0; to: 100; ... }` — menggerakkan `y` bola dari 0 ke 100. `target` **wajib** dan harus berupa `Item` (animator tidak bekerja pada objek non-visual).
- `SequentialAnimation { loops: Animation.Infinite }` — bolak-balik tanpa henti. Karena **semua anaknya animator**, grup ini ikut diperlakukan sebagai animator dan berjalan di thread render bila memungkinkan.
- `running: bola.visible` — mengikat jalannya animasi ke visibilitas bola. Ini memperbaiki catatan audit: animasi tak berhingga tidak lagi berjalan untuk item yang tak terlihat.
- `from:` ditulis eksplisit agar tiap putaran mulai dari titik yang sama.

### Hal-hal yang harus diketahui (sudah diverifikasi pada dokumentasi Qt)

1. **Nilai properti tidak diperbarui selama animasi berjalan.** `bola.y` tetap nilai lama sampai animasi selesai. Akibatnya: binding yang membaca `y` tidak melihat gerakan; `onYChanged` tidak terpanggil; dan **area ketuk (hit-testing) tetap di posisi lama** selama animator bergerak, karena penentuan sasaran ketukan memakai properti item, bukan simpul scene graph.
2. **Tidak ada manfaatnya bila render loop bukan `threaded`.** Pada render loop `basic` (satu thread) animator berjalan sama seperti animasi biasa.
3. **Hanya properti tertentu:** posisi, opasitas, skala, rotasi (dan uniform). Tidak untuk `width`, `height`, `color`, atau properti lain.
4. **Boleh dipakai di dalam `Transition` dan `Behavior`,** tetapi di `Transition` animator tidak mendukung `reversible`.
5. **Target harus berbasis `Item`.**

### Memeriksa dan memaksa render loop (Linux)

```bash
# lihat render loop yang dipakai (kategori log scene graph)
QT_LOGGING_RULES='qt.scenegraph.general=true' qml6 Main.qml

# cara lama yang juga lazim: QSG_INFO=1
QSG_INFO=1 qml6 Main.qml

# memaksa render loop tertentu untuk pengujian
QSG_RENDER_LOOP=threaded qml6 Main.qml
QSG_RENDER_LOOP=basic    qml6 Main.qml
```

Qt memilih render loop berdasarkan platform dan driver grafis. Pada konfigurasi Anda, hasilnya bisa `threaded` atau `basic`; jangan berasumsi, periksa dengan perintah di atas sebelum berkesimpulan tentang manfaat animator.

### Kapan memakai animator

```
 Hanya x, y, opacity, scale, atau rotation?                    TIDAK --> animasi biasa
  |
 Perlu membaca nilai properti selama gerak (binding, hit-test)? YA --> animasi biasa
  |
 Efek dekoratif atau peralihan yang tak boleh tersendat,
  thread GUI kadang sibuk (memuat halaman, JS)?                 YA --> animator
  |
 Render loop-nya threaded?                                    TIDAK --> tak ada manfaat; biasa saja
```

### Catatan penting dari dokumentasi Qt

Qt sendiri menyarankan agar aplikasi **tidak** mengandalkan animator untuk menutupi pekerjaan berat di thread GUI. Rancangan yang lebih baik: pindahkan pekerjaan berat ke luar thread GUI (`WorkerScript`, pemuatan gambar asinkron, thread pekerja atau Qt Concurrent di C++) sehingga seluruh antarmuka tetap responsif. Animator adalah sabuk pengaman, bukan pengganti rancangan yang benar.

### Opsi lain: spinner dengan `RotationAnimator`

```qml
Rectangle {
    id: spinner
    width: 40; height: 40; color: 'tomato'

    RotationAnimator on rotation {
        from: 0; to: 360; duration: 1200
        loops: Animation.Infinite
        running: spinner.visible
    }
}
```

`RotationAnimator on rotation` memakai sintaks “animasi pada properti” (6.2.8): target dan properti terisi otomatis. Putaran tanpa henti adalah contoh klasik yang pantas memakai animator, karena tak butuh nilai `rotation` selama berjalan.

**Referensi bagian ini:** [Animator](https://doc.qt.io/qt-6/qml-qtquick-animator.html) · [XAnimator](https://doc.qt.io/qt-6/qml-qtquick-xanimator.html) · [OpacityAnimator](https://doc.qt.io/qt-6/qml-qtquick-opacityanimator.html) · [RotationAnimator](https://doc.qt.io/qt-6/qml-qtquick-rotationanimator.html) · [Qt Quick Scene Graph (render loop)](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [WorkerScript](https://doc.qt.io/qt-6/qml-qtqml-workerscript-workerscript.html)

## 6.2.6 `SpringAnimation`

### Dasar: gerak dari fisika pegas

`SpringAnimation` membuat sebuah properti *mengejar* nilai tujuan seperti benda yang ditarik pegas: tidak ada durasi tetap; gerak berakhir ketika energinya habis. Tiga gagasan fisika dasar:

- **Pegas** menarik benda ke tujuan; makin jauh, makin kuat tarikannya.
- **Redaman (damping)** meredam ayunan; tanpa redaman, benda berayun selamanya.
- **Massa** menentukan kelembaman; benda berat lebih lambat bereaksi.

### Properti penting

- `spring` — kekakuan pegas. `0` berarti tak ada pegas. Nilai kecil (1–5) terasa lembut; besar terasa kaku dan cepat.
- `damping` — redaman, umumnya antara 0 dan 1. `0` berarti tak ada redaman (berayun terus); mendekati 1 berarti hampir tanpa ayunan.
- `mass` — massa (bawaan 1.0).
- `epsilon` — ambang berhenti: bila selisih ke tujuan lebih kecil dari ini, animasi dianggap selesai.
- `velocity` — batas kecepatan maksimum (0 = tanpa batas).
- `modulus` — untuk nilai yang “melingkar” seperti sudut.

### Contoh inti: bola yang mengejar titik ketukan

```qml
import QtQuick

Window {
    width: 360; height: 200; visible: true

    Item {
        anchors.fill: parent

        TapHandler {
            onTapped: (eventPoint) => {
                bola.tujuanX = eventPoint.position.x - bola.width / 2
                bola.tujuanY = eventPoint.position.y - bola.height / 2
            }
        }

        Rectangle {
            id: bola
            property real tujuanX: 160
            property real tujuanY: 80

            x: tujuanX
            y: tujuanY
            width: 40; height: 40; radius: 20; color: 'tomato'

            Behavior on x { SpringAnimation { spring: 3; damping: 0.25 } }
            Behavior on y { SpringAnimation { spring: 3; damping: 0.25 } }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `onTapped: (eventPoint) => { ... }` — handler ketukan dengan parameter eksplisit (gaya Qt 6). `eventPoint.position` adalah posisi ketukan relatif terhadap item induk handler (di sini seukuran jendela, sehingga sama dengan koordinat jendela).
- `bola.tujuanX = eventPoint.position.x - bola.width / 2` — mengurangi setengah lebar agar *pusat* bola, bukan sudut kirinya, tiba di titik ketukan.
- `x: tujuanX` — binding; perubahan `tujuanX` memicu `Behavior`.
- `SpringAnimation { spring: 3; damping: 0.25 }` — pegas cukup kaku dengan redaman rendah: bola melewati tujuan sedikit, berayun, lalu mereda.
- Tidak ada `duration`: lama gerak ditentukan fisika, bukan jam.

### Menyetel dengan sistematis

```
 spring  naik  -->  lebih cepat dan lebih kaku
 damping naik  -->  ayunan cepat mereda (mendekati 1: nyaris tanpa ayunan)
 damping = 0   -->  berayun selamanya (jangan, kecuali disengaja)
 mass    naik  -->  lebih lamban bereaksi dan lebih lama mereda
```

Mulailah dari `spring: 2; damping: 0.2`, lalu ubah satu angka sekali waktu.

### Pegas versus easing

- **Pegas:** *dapat disela* dengan mulus (tujuan berganti di tengah gerak, kecepatan berlanjut), cocok untuk menyusul pointer, melepas seretan, dan elemen yang tujuannya sering berubah. Kekurangan: durasi tak pasti, sulit disinkronkan dengan animasi lain.
- **Easing berdurasi tetap:** dapat diprediksi dan diselaraskan dalam koreografi (6.2.4); cocok untuk peralihan antarlayar.

### Hal yang perlu diperhatikan

- **`damping: 0` tidak pernah berhenti** dan membuat animasi berjalan terus (biaya, 6.2.7).
- **`epsilon` terlalu kecil** memperpanjang “ekor” gerak yang tak terlihat tetapi tetap menghitung.
- **Hindari pegas di dalam Layout** untuk alasan yang sama dengan `Behavior` (6.2.2).

**Referensi bagian ini:** [SpringAnimation](https://doc.qt.io/qt-6/qml-qtquick-springanimation.html) · [TapHandler](https://doc.qt.io/qt-6/qml-qtquick-taphandler.html)

## 6.2.7 Biaya animasi

### Dasar: anggaran frame

Setiap frame yang ditampilkan harus selesai dikerjakan dalam jatah waktu tertentu. Pada layar 60 Hz jatahnya sekitar 16,7 ms; pada 120 Hz sekitar 8,3 ms; pada 144 Hz sekitar 6,9 ms. Dalam jatah itu thread GUI harus mengevaluasi binding, menjalankan JavaScript, dan menata ulang tata letak, lalu hasilnya disinkronkan dan digambar. Melewati jatah berarti frame terlewat dan gerak terasa patah.

### Properti murah versus mahal untuk dianimasikan

```
 MURAH (umumnya hanya mengubah transformasi pada scene graph)
   x, y (di luar Layout dan positioner), opacity, scale, rotation

 MAHAL (memicu kerja ulang di setiap frame)
   width, height         -> penataan ulang anak, anchors, Layout
   Layout.*, implicit*   -> negosiasi ulang di seluruh Layout
   font.pixelSize, text  -> tata letak ulang glyph
   anchors.*Margin       -> penataan ulang
   layer.enabled, clip   -> tekstur luar-layar, pemotongan
   MultiEffect (blur)    -> beban GPU, apalagi di area luas
```

Aturan praktis: **gunakan `scale` alih-alih mengubah ukuran, dan `opacity` alih-alih `visible`.** Animasi pada `x`/`y` murah, kecuali item berada di dalam `Layout` atau positioner yang ikut menata ulang.

### Penyebab biaya yang sering terlewat

- **Binding yang bergantung pada properti beranimasi.** Contoh: `Text { text: Math.round(bola.x) }` dihitung ulang dan ditata ulang setiap frame.
- **Handler `onXChanged` berat.** Ia terpanggil tiap frame selama `x` dianimasikan.
- **Animasi tak berhingga pada item tak terlihat.** Ikat `running` ke visibilitas (`running: item.visible`). Pada aplikasi desktop, `Qt.application.state` memberi tahu bila aplikasi tidak aktif; periksa perilakunya di platform Anda sebelum bergantung padanya.
- **Ratusan item beranimasi serentak.** Animasikan hanya yang terlihat (delegate daftar yang di luar layar tak perlu bergerak).
- **Overdraw:** banyak lapisan tembus pandang bertumpuk pada area yang sama.
- **Efek pada area luas** (`MultiEffect`, `layer.enabled`).

### Mengukur di terminal

```bash
# waktu sinkron, render, dan swap per frame (keluaran teks)
QSG_RENDER_TIMING=1 qml6 Main.qml

# visualisasi: overdraw (juga tersedia: batches, clip, changes)
QSG_VISUALIZE=overdraw qml6 Main.qml

# bandingkan render loop
QSG_RENDER_LOOP=threaded qml6 Main.qml
QSG_RENDER_LOOP=basic    qml6 Main.qml
```

Untuk analisis rinci, QML Profiler (di Qt Creator) menampilkan kategori Animations (jumlah animasi aktif dan laju frame; animasi thread render di baris terpisah) dan Scene Graph. Qt juga menyertakan perkakas baris perintah `qmlprofiler`; periksa ketersediaannya dengan `pacman -Ql qt6-declarative | grep -i profiler`.

### Menahan diri: animasi yang bertanggung jawab

- **Sebagian pengguna sensitif terhadap gerak** (gangguan vestibular, migrain, kondisi lain). Gerak berlebihan bukan sekadar mengganggu: ia dapat membuat tidak nyaman secara fisik.
- Pedoman WCAG relevan: konten yang bergerak otomatis lebih dari 5 detik harus bisa dijeda atau dihentikan (Pause, Stop, Hide); tidak boleh ada lebih dari tiga kedipan per detik (Three Flashes); dan gerak yang dipicu interaksi sebaiknya bisa dimatikan (Animation from Interactions).
- **Sediakan saklar “kurangi gerakan”** di aplikasi Anda. Sejauh yang diketahui, Qt tidak menyediakan properti QML siap pakai untuk membaca preferensi sistem ini, jadi sediakan pilihan sendiri. Jalur termudah memakai token tema dari Modul 5.3:

```qml
// di Theme.qml
property bool reduceMotion: false
readonly property int durationFast:   reduceMotion ? 0 : 120
readonly property int durationNormal: reduceMotion ? 0 : 240
```

Bila semua animasi mengambil durasi dari token, satu saklar mematikan gerak di seluruh aplikasi (durasi 0 membuat perubahan terjadi seketika). Simpan pilihan pengguna dengan `Settings` (Modul 6.4).

### Opsi lain untuk menjaga biaya

```qml
// Opsi 1 — animasi hanya saat terlihat dan aktif
running: item.visible

// Opsi 2 — ganti animasi mahal dengan murah
// width/height  ->  scale ;  visible  ->  opacity + PropertyAction

// Opsi 3 — animator untuk transformasi dekoratif (6.2.5)
// Opsi 4 — matikan sementara: Behavior { enabled: false }
```

**Referensi bagian ini:** [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html) · [Qt Quick Scene Graph Default Renderer](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph-renderer.html) · [Profiling QML Applications](https://doc.qt.io/qtcreator/creator-qml-performance-monitor.html) · [Qt Quick Performance Considerations](https://doc.qt.io/qt-6/qtquick-performance.html) · [WCAG 2.2.2 Pause, Stop, Hide](https://www.w3.org/WAI/WCAG21/Understanding/pause-stop-hide.html) · [WCAG 2.3.1 Three Flashes](https://www.w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold.html) · [WCAG 2.3.3 Animation from Interactions](https://www.w3.org/WAI/WCAG21/Understanding/animation-from-interactions.html)

## 6.2.8 \[TAMBAHAN\] `Animation on <properti>` dan kendali animasi

*Alasan penambahan:* contoh kurikulum memakai `SequentialAnimation on y` tanpa menjelaskan sintaksnya, dan kendali (mulai, henti, jeda) tidak dibahas.

### Dasar: animasi sebagai sumber nilai properti

Sintaks `Animation on <properti>` menjadikan animasi *sumber nilai* sebuah properti: target dan properti terisi otomatis, dan animasi **mulai sendiri** ketika objek selesai dibuat.

```qml
Rectangle {
    id: lampu
    width: 40; height: 40; radius: 20; color: 'gold'

    SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: lampu.visible
        NumberAnimation { to: 0.3; duration: 800; easing.type: Easing.InOutSine }
        NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
    }
}
```

### Bedah kode (kata demi kata)

- `SequentialAnimation on opacity { ... }` — “animasi berurutan pada properti `opacity`”. Anak-anaknya tidak perlu `target` maupun `property`: keduanya diwarisi dari `on opacity`.
- `loops: Animation.Infinite` — berulang tanpa henti (`Animation.Infinite` bernilai khusus untuk “tak terbatas”).
- `running: lampu.visible` — hanya berjalan selama lampu terlihat (perbaikan catatan audit).
- Dua `NumberAnimation` tanpa `from`: dari nilai saat itu ke 0,3 lalu ke 1,0: efek “napas” lembut selama 1,6 detik per siklus (jauh di bawah ambang kedipan).

### Kapan memilih bentuk `on`

```qml
// Bentuk 'on': target dan properti otomatis; mulai sendiri; cocok untuk efek yang selalu hidup
NumberAnimation on x { to: 200; duration: 1000 }

// Bentuk mandiri: Anda memilih target, kapan mulai, dan dapat dikendalikan lewat id
NumberAnimation { id: geser; target: kotak; property: 'x'; to: 200; duration: 1000 }
```

Pakai bentuk `on` untuk efek yang berjalan sendiri sejak item dibuat (denyut, putaran pemuat); bentuk mandiri untuk animasi yang dipicu peristiwa. **Jangan memberi binding pada properti yang dianimasikan lewat `on`**: dua pengendali untuk satu properti.

### Kendali animasi

Setiap animasi punya properti dan metode kendali yang sama:

- **Properti:** `running` (sedang berjalan), `paused` (dijeda), `loops` (jumlah putaran), `alwaysRunToEnd` (selesaikan putaran berjalan bila dihentikan).
- **Metode:** `start()`, `stop()`, `pause()`, `resume()`, `restart()`, `complete()`.
  - `start()` — mulai; tak berefek bila sudah berjalan.
  - `stop()` — hentikan; nilai properti tertinggal di titik berhenti.
  - `pause()` / `resume()` — jeda dan lanjutkan dari titik jeda.
  - `restart()` — `stop()` lalu `start()`.
  - `complete()` — lompat langsung ke nilai akhir dan selesai.
- **Signal:** `started()`, `stopped()`, `finished()`.

```qml
NumberAnimation {
    id: anim
    target: kotak; property: 'x'; to: 240; duration: 2000
    onStarted: console.log('mulai')
    onFinished: console.log('selesai')
    onStopped: console.log('berhenti')
}
// TapHandler { onTapped: anim.running ? anim.pause() : anim.resume() }
```

Perbedaan tepat antara `stopped` dan `finished` pada penghentian paksa dapat bervariasi menurut versi; uji dengan `console.log` seperti di atas sebelum memakainya untuk logika penting.

**Pilih satu cara mengendalikan:** mengikat `running` ke sebuah ekspresi *atau* memanggil metode (`start`/`stop`), jangan keduanya pada animasi yang sama.

**Referensi bagian ini:** [Animation](https://doc.qt.io/qt-6/qml-qtquick-animation.html) · [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html) · [Property value sources](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

## 6.2.9 \[TAMBAHAN\] Animasi lain yang jarang dibahas

### 1. `RotationAnimation`: memilih arah putar

```qml
Rectangle {
    id: jarum
    width: 6; height: 80; color: 'tomato'
    Behavior on rotation {
        RotationAnimation { duration: 300; direction: RotationAnimation.Shortest }
    }
}
// jarum.rotation = 350  ->  jarum.rotation = 10   (jalur terpendek: 20 derajat, bukan 340)
```

`direction` bernilai `Numerical` (bawaan: menurut selisih angka), `Clockwise`, `Counterclockwise`, atau `Shortest`. Dari 350 ke 10 derajat, `Numerical` memutar mundur 340 derajat, sedangkan `Shortest` hanya 20 derajat maju.

### 2. `SmoothedAnimation`: mengejar tujuan dengan kecepatan terbatas

```qml
Behavior on x { SmoothedAnimation { velocity: 400 } }   // 400 satuan per detik
```

Berbeda dengan `NumberAnimation` yang berdurasi tetap, `SmoothedAnimation` berbasis **kecepatan**: jarak jauh butuh waktu lebih lama, dan bila tujuan berganti di tengah jalan, kecepatan berubah mulus. Properti: `velocity`, `duration`, `maximumEasingTime`, `reversingMode` (`SmoothedAnimation.Eased`, `Immediate`, `Sync`). Tentukan `velocity` *atau* `duration`, bukan keduanya. Cocok untuk kamera, kursor, dan elemen yang menyusul pointer.

### 3. `PathAnimation`: bergerak sepanjang lintasan

```qml
import QtQuick

Window {
    width: 320; height: 160; visible: true

    Item {
        anchors.fill: parent
        TapHandler { onTapped: jalur.restart() }

        Rectangle {
            id: bola
            width: 20; height: 20; radius: 10; color: 'tomato'

            PathAnimation {
                id: jalur
                target: bola
                duration: 1500
                easing.type: Easing.InOutQuad
                anchorPoint: Qt.point(10, 10)      // titik pusat bola yang menempel pada lintasan
                path: Path {
                    startX: 20; startY: 120
                    PathQuad { x: 300; y: 120; controlX: 160; controlY: -40 }
                }
            }
        }
    }
}
```

- `Path { startX; startY; PathQuad { ... } }` — lintasan: titik awal, lalu kurva kuadratik ke (300, 120) dengan satu titik kendali.
- `anchorPoint` — titik pada *item* yang mengikuti lintasan; tanpa ini, sudut kiri atas yang menempel.
- `orientation` (bawaan `PathAnimation.Fixed`) dapat diganti agar item ikut menghadap arah gerak.

### 4. Jenis “animasi” yang bukan interpolasi properti

- `AnimatedImage` — memutar gambar beranimasi (misalnya GIF).
- `AnimatedSprite` dan `SpriteSequence` — animasi berbasis kerangka gambar (sprite sheet).
- `FrameAnimation` (Qt 6.4 ke atas) — memicu handler **setiap frame**, dengan waktu antar-frame sebagai masukan; cocok untuk logika per-frame kustom:

```qml
FrameAnimation {
    running: true
    onTriggered: kotak.rotation += 90 * frameTime     // 90 derajat per detik, apa pun laju framenya
}
```

`frameTime` adalah detik sejak frame sebelumnya sehingga gerak independen dari laju frame. Ini menggantikan pola buruk memakai `Timer` untuk menggerakkan sesuatu: `Timer` tidak tersinkron dengan vsync dan bergerak patah.

### 5. Pengingat jenis lain

- `Vector3dAnimation` — vektor tiga dimensi.
- `ParentAnimation` dan `AnchorAnimation` — sudah dibahas di 6.1.4.
- `UniformAnimator` — uniform shader; muncul bersama `ShaderEffect` (di luar cakupan modul ini).

**Referensi bagian ini:** [RotationAnimation](https://doc.qt.io/qt-6/qml-qtquick-rotationanimation.html) · [SmoothedAnimation](https://doc.qt.io/qt-6/qml-qtquick-smoothedanimation.html) · [PathAnimation](https://doc.qt.io/qt-6/qml-qtquick-pathanimation.html) · [Path](https://doc.qt.io/qt-6/qml-qtquick-path.html) · [FrameAnimation](https://doc.qt.io/qt-6/qml-qtquick-frameanimation.html) · [AnimatedImage](https://doc.qt.io/qt-6/qml-qtquick-animatedimage.html) · [AnimatedSprite](https://doc.qt.io/qt-6/qml-qtquick-animatedsprite.html)

## Terminologi Esensial

- **Animasi** — perubahan nilai properti secara bertahap dari satu nilai ke nilai lain selama waktu tertentu.
- **Interpolasi** — pengisian nilai di antara nilai awal dan akhir.
- **Berbasis waktu** — nilai dihitung dari waktu yang berlalu, bukan dari jumlah frame.
- **`from` / `to` / `duration`** — nilai awal, nilai akhir, dan lama animasi (milidetik; bawaan 250).
- **`PropertyAnimation`** — induk animasi properti; turunannya `NumberAnimation`, `ColorAnimation`, `RotationAnimation`, dan lainnya.
- **`Behavior`** — aturan tetap: setiap perubahan nilai sebuah properti dijalankan dengan animasi.
- **Easing** — kurva yang memetakan progres waktu ke progres nilai.
- **`Easing.BezierSpline`** — easing kustom lewat kurva Bezier (`easing.bezierCurve`).
- **`SequentialAnimation` / `ParallelAnimation`** — animasi berurutan dan bersamaan.
- **`PauseAnimation` / `PropertyAction` / `ScriptAction`** — jeda, perubahan properti seketika, dan menjalankan kode di dalam urutan animasi.
- **`loops` / `Animation.Infinite`** — jumlah putaran / tanpa henti.
- **`alwaysRunToEnd`** — menyelesaikan putaran yang berjalan saat animasi dihentikan.
- **Animator** — animasi khusus (`XAnimator`, `YAnimator`, `OpacityAnimator`, `ScaleAnimator`, `RotationAnimator`, `UniformAnimator`) yang berjalan pada scene graph di thread render.
- **Thread GUI / thread render** — thread yang menjalankan QML dan thread yang menggambar scene graph.
- **Scene graph** — pohon simpul yang mewakili apa yang akan digambar.
- **Render loop (`basic`, `threaded`)** — cara Qt Quick mengatur kapan dan di thread mana frame digambar.
- **`SpringAnimation`** — animasi berbasis pegas (`spring`, `damping`, `mass`, `epsilon`).
- **`SmoothedAnimation`** — animasi berbasis kecepatan yang mulus saat tujuan berganti.
- **`PathAnimation`** — pergerakan item sepanjang `Path`.
- **`FrameAnimation`** — pemicu per frame (Qt 6.4 ke atas).
- **Property value source (`Animation on x`)** — sintaks yang menjadikan animasi sumber nilai sebuah properti.
- **Anggaran frame** — jatah waktu per frame (sekitar 16,7 ms pada 60 Hz).
- **Overdraw** — menggambar piksel yang sama berkali-kali karena tumpang-tindih.
- **Gerak berkurang (reduce motion)** — preferensi aksesibilitas untuk meminimalkan animasi.

## Hubungan dengan Modul Lain

- **Prasyarat:** Modul 6.1 (`State` dan `Transition`: wadah animasi), Modul 4.4 (`TapHandler`), Modul 5.2 (animasi di dalam Layout dan positioner), dan Modul 5.3 (token durasi dan kurva di `Theme`).
- **Menuju Modul 6.3 (Input lanjut dan keyboard):** `DragHandler` dan gestur lain sering dipasangkan dengan `Behavior`, `SpringAnimation`, atau `SmoothedAnimation` untuk melepas seretan dengan mulus; animasi fokus (cincin fokus) juga memakai materi ini.
- **Menuju Modul 6.4 (Qt Quick ekstra):** `MultiEffect` dan `Particles` memperbesar biaya animasi (6.2.7); `Settings` menyimpan pilihan “kurangi gerakan”.
- **Ke jalur C++:** padanan animasi di C++ adalah `QPropertyAnimation` dan `QVariantAnimation`, dengan konsep yang sama (durasi, easing, kurva).

## Kesalahan Umum dan Solusi

1. **Animasi terus berjalan pada item tak terlihat.** *Sebab:* `loops: Animation.Infinite` tanpa `running` terikat. *Solusi:* `running: item.visible` (6.2.7 dan 6.2.8).
2. **Menganimasikan `width`/`height` di dalam `Layout`.** *Akibat:* penataan ulang tiap frame. *Solusi:* animasikan `scale` atau `opacity`, atau gunakan transisi `add`/`move` positioner.
3. **`Behavior` bertabrakan dengan binding, `Transition`, atau animasi lain pada properti yang sama.** *Solusi:* satu pengendali animasi per properti.
4. **`start()` tak berefek.** *Sebab:* animasi sudah berjalan. *Solusi:* `restart()`.
5. **Memutuskan arah dari nilai di tengah animasi** (`bola.x === 0 ? 200 : 0`). *Solusi:* simpan niat dalam boolean dan ikat nilai ke boolean itu (6.2.2).
6. **Menyangka nilai properti berubah saat animator berjalan.** *Akibat:* binding dan area ketuk tidak mengikuti. *Solusi:* pakai animasi biasa bila nilai harus terbaca.
7. **Memakai animator ketika render loop bukan `threaded`.** *Akibat:* tak ada manfaat. *Solusi:* periksa dengan `QT_LOGGING_RULES='qt.scenegraph.general=true'`.
8. **Animator pada properti atau target yang tak didukung.** *Solusi:* hanya posisi, opasitas, skala, rotasi pada `Item`.
9. **Menggerakkan sesuatu dengan `Timer`.** *Akibat:* patah, tak sinkron vsync. *Solusi:* `NumberAnimation`, `Behavior`, atau `FrameAnimation`.
10. **Binding bergantung pada properti beranimasi** (`text: Math.round(bola.x)`). *Akibat:* kerja ulang tiap frame. *Solusi:* hindari, atau perbarui lebih jarang.
11. **`SpringAnimation` dengan `damping: 0`.** *Akibat:* tak pernah berhenti. *Solusi:* beri redaman (mulai 0,2).
12. **Semua hal bergerak dengan durasi panjang.** *Akibat:* antarmuka terasa lamban dan melelahkan. *Solusi:* gerak seperlunya, 120–300 ms.
13. **Lupa `from` pada koreografi berulang.** *Akibat:* mulai dari nilai akhir sebelumnya. *Solusi:* tulis `from` eksplisit.
14. **Mengabaikan preferensi gerak pengguna.** *Solusi:* token `reduceMotion` (6.2.7).

## Tips dan Praktik Terbaik

- **Gerak harus punya tujuan:** umpan balik, kesinambungan, atau arah perhatian. Bila tidak, jangan.
- **Ambil durasi dan kurva dari token tema** (`Theme.durationFast`, `Theme.curveStandard`) agar seluruh aplikasi bergerak dengan karakter yang sama.
- **Masuk dengan `Out`, keluar dengan `In`, berpindah dengan `InOut`.**
- **Prioritaskan properti murah:** `opacity`, `scale`, `x`/`y`.
- **Ikat `running` pada visibilitas** untuk setiap animasi yang berulang.
- **Pilih alat yang tepat:** efek sekali = animasi imperatif; properti mengikuti data = `Behavior`; banyak properti dan keadaan = `State`; tujuan sering berganti = `SpringAnimation` atau `SmoothedAnimation`; logika per frame = `FrameAnimation`.
- **Uji pada thread GUI yang dibebani** dan pada render loop berbeda sebelum menyimpulkan apa pun tentang kehalusan.
- **Ukur, jangan menebak:** `QSG_RENDER_TIMING=1` dan `QSG_VISUALIZE=overdraw` murah dan informatif.
- **Pindahkan pekerjaan berat dari thread GUI,** jangan menutupinya dengan animator.
- **Hormati pengguna:** sediakan saklar kurangi gerakan, hindari kedipan cepat, dan beri cara menjeda animasi yang berjalan lama.
- **Jangan menggantungkan makna pada gerak saja.** Perubahan penting juga perlu tampak lewat teks atau bentuk.

## Latihan 15 Menit (versi diperbaiki)

*Perbaikan dari audit:* kurikulum menyuruh membandingkan `NumberAnimation` dan `YAnimator` saat thread utama dibebani, tetapi tidak menyediakan pembebannya. Di bawah ini berkas uji lengkap beserta pemeriksaan render loop.

1. Simpan berkas uji di bawah sebagai `Main.qml` (atau nama lain) dan jalankan dengan `QT_LOGGING_RULES='qt.scenegraph.general=true' qml6 Main.qml`; catat render loop yang terpakai.
2. Amati kedua bola tanpa beban: keduanya bergerak mulus.
3. Ketuk jendela untuk menyalakan beban pada thread GUI; amati bola mana yang tersendat.
4. Jalankan ulang dengan `QSG_RENDER_LOOP=basic` dan ulangi langkah 3; bandingkan.
5. Ketuk lagi untuk mematikan beban.
6. Jawab: mengapa hasilnya berbeda antar-render loop?

```qml
import QtQuick

Window {
    id: win
    width: 420; height: 260; visible: true
    title: 'Animator vs animasi biasa'

    property bool beban: false

    // beban sengaja di thread GUI: menahan thread utama sekitar 80 ms setiap 100 ms
    Timer {
        interval: 100; repeat: true; running: win.beban
        onTriggered: {
            const t = Date.now()
            while (Date.now() - t < 80) { }
        }
    }

    Item {
        anchors.fill: parent
        TapHandler { onTapped: win.beban = !win.beban }

        Rectangle {
            id: a
            x: 60; width: 40; height: 40; radius: 20; color: 'tomato'
            SequentialAnimation {
                running: a.visible; loops: Animation.Infinite
                NumberAnimation { target: a; property: 'y'; from: 20;  to: 180; duration: 700 }
                NumberAnimation { target: a; property: 'y'; from: 180; to: 20;  duration: 700 }
            }
        }

        Rectangle {
            id: b
            x: 260; width: 40; height: 40; radius: 20; color: 'seagreen'
            SequentialAnimation {
                running: b.visible; loops: Animation.Infinite
                YAnimator { target: b; from: 20;  to: 180; duration: 700 }
                YAnimator { target: b; from: 180; to: 20;  duration: 700 }
            }
        }

        Text { x: 30;  y: 235; text: 'NumberAnimation'; font.pixelSize: 12 }
        Text { x: 240; y: 235; text: 'YAnimator'; font.pixelSize: 12 }
    }
}
```

**Kunci jawaban** (coba dulu sebelum membaca):

- `Timer` dengan `while (Date.now() - t < 80) { }` menahan thread GUI selama 80 ms dari setiap 100 ms: praktis selalu macet. Ini hanya untuk percobaan singkat karena memakai satu inti CPU penuh.
- **Render loop `threaded`:** bola merah (`NumberAnimation`, di thread GUI) tersendat parah atau nyaris diam; bola hijau (`YAnimator`, di thread render) tetap mulus. Ketukan untuk mematikan beban pun terasa tertunda, karena penanganan input juga di thread GUI.
- **Render loop `basic`:** kedua bola tersendat, sebab tidak ada thread render terpisah; animator tidak memberi manfaat (sesuai dokumentasi Qt).
- **Jawaban inti:** animasi biasa menulis nilai properti di thread GUI setiap frame, sehingga ikut macet; animator memperbarui simpul scene graph langsung di thread render yang tidak terblokir, tetapi hanya bila render loop memang memisahkan thread render.
- **Catatan rancangan:** percobaan ini sengaja membebani thread GUI. Pada aplikasi nyata, Qt menyarankan memindahkan pekerjaan berat dari thread GUI alih-alih mengandalkan animator, misalnya dengan `WorkerScript`:

```qml
import QtQml.WorkerScript

WorkerScript {
    id: pekerja
    source: 'kerja.mjs'
    onMessage: (messageObject) => console.log('selesai:', messageObject.nilai)
}
// pekerja.sendMessage({ n: 50000000 })
```

```js
// kerja.mjs
WorkerScript.onMessage = function(pesan) {
    let total = 0
    for (let i = 0; i < pesan.n; i++) total += i
    WorkerScript.sendMessage({ nilai: total })
}
```

(Bentuk `WorkerScript` bergantung pada versi; periksa dokumentasi `WorkerScript` untuk Qt Anda.)

**Tantangan opsional:** ganti `NumberAnimation` merah dengan `SpringAnimation` pada `Behavior on y` dan tambahkan `reduceMotion` dari 6.2.7 sehingga durasi menjadi 0 ketika saklarnya aktif.

## Cek Pemahaman dan Kunci

1. **Mengapa animator lebih tahan beban dibanding animation biasa?** *Kunci:* animator memperbarui simpul scene graph langsung di thread render, yang tidak terblokir saat thread GUI sibuk; animasi biasa menulis properti di thread GUI setiap frame. Syaratnya render loop berupa `threaded`.
2. **Apa harga yang dibayar saat memakai animator?** *Kunci:* nilai properti QML tidak diperbarui selama animasi berjalan, sehingga binding dan penentuan sasaran ketukan tidak mengikuti gerak; hanya properti tertentu pada `Item` yang didukung.
3. **Mengapa `Behavior on x` dengan `x: kanan ? 240 : 0` lebih baik daripada `bola.x = bola.x === 0 ? 200 : 0`?** *Kunci:* yang pertama menyimpan niat dalam data (`kanan`) dan tidak membaca nilai di tengah animasi; yang kedua bergantung pada nilai `x` sesaat sehingga rapuh.
4. **Kapan memilih `SpringAnimation` dan kapan easing berdurasi tetap?** *Kunci:* pegas untuk tujuan yang sering berganti dan perlu disela dengan mulus (menyusul pointer, melepas seretan); easing berdurasi tetap untuk koreografi dan peralihan yang harus dapat diprediksi serta diselaraskan.
5. **Mengapa `scale` dan `opacity` lebih murah daripada `width` dan `height`?** *Kunci:* keduanya hanya mengubah transformasi pada scene graph, sedangkan ukuran memicu penataan ulang anak, anchors, dan Layout setiap frame.
6. **Bagaimana membuat animasi tak berhingga tidak menguras daya?** *Kunci:* ikat `running` ke visibilitas (dan, bila perlu, keadaan aplikasi) sehingga berhenti saat tak terlihat.

## Referensi Tambahan

- [Animation and Transitions in Qt Quick](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html)
- [Animator](https://doc.qt.io/qt-6/qml-qtquick-animator.html)
- [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html)
- [Profiling QML Applications](https://doc.qt.io/qtcreator/creator-qml-performance-monitor.html)
- [Qt Quick Performance Considerations](https://doc.qt.io/qt-6/qtquick-performance.html)
- [Easing Curves (demo)](https://doc.qt.io/qt-6/qtquick-demos-easing-example.html)
- [Material Design — Motion: easing and duration](https://m3.material.io/styles/motion/easing-and-duration/tokens-specs)
- [WCAG 2.1 — Understanding Pause, Stop, Hide](https://www.w3.org/WAI/WCAG21/Understanding/pause-stop-hide.html)
- [Qt — Arch Wiki (variabel lingkungan dan platform)](https://wiki.archlinux.org/title/Qt)

---

*Gerak yang baik nyaris tak disadari: ia hanya membuat segalanya terasa wajar.*

# Fase 6 · Modul 6.3 — Input Lanjut dan Kendali Keyboard

*Kurikulum Qt 6 QML · Fase 6 (Interaksi, State, dan Animasi) · Modul 3 dari 4 (6.1 → 6.2 → 6.3 → 6.4)*

## Daftar Isi Modul 6.3

- Audit singkat Modul 6.3 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 6.3.1 `DragHandler`, `PinchHandler`, `WheelHandler`
- 6.3.2 `Flickable`
- 6.3.3 Fokus, `FocusScope`, `forceActiveFocus()`
- 6.3.4 `KeyNavigation` dan `Keys`
- 6.3.5 `Shortcut` dan pemetaan tombol
- 6.3.6 Rancangan antarmuka yang bisa dioperasikan penuh dari keyboard
- 6.3.7 \[TAMBAHAN\] Pola kendali keyboard bergaya terminal
- 6.3.8 \[TAMBAHAN\] Handler lain dan Handler vs `MouseArea`
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Referensi tambahan

## Audit Singkat Modul 6.3 (sebelum materi dimulai)

Urutan Modul 6.3 logis: setelah keadaan (6.1) dan gerak (6.2), Anda menyelesaikan lingkarannya dengan *kendali*. Catatan audit untuk Modul 6.4 tetap seperti di dokumen Modul 6.1. Temuan untuk 6.3 dibereskan di materi ini:

1. **\[Koreksi\] Contoh `KeyNavigation` tidak bisa dijangkau dengan Tab.** `Rectangle` tidak masuk rantai Tab tanpa `activeFocusOnTab: true`, dan panah kanan/kiri hanya bekerja *setelah* salah satu persegi sudah memegang fokus. Keduanya dibenahi di 6.3.4, termasuk indikator fokus dan perputaran (wrap-around).
2. **\[Perbaikan\] `DragHandler` hanya membatasi sumbu x.** Pada contoh kurikulum persegi bisa diseret bebas secara vertikal, bahkan keluar jendela. Ditambahkan batas sumbu y (atau `yAxis.enabled: false`) di 6.3.1.
3. **\[Klarifikasi, sudah diverifikasi pada dokumentasi Qt\] `Shortcut`.** Konteks bawaannya `Qt.WindowShortcut` (aktif bila jendela induknya aktif); `Qt.ApplicationShortcut` aktif bila salah satu jendela aplikasi aktif; sebuah urutan boleh berisi hingga empat penekanan tombol (akord seperti `Ctrl+E,Ctrl+W`); ada sinyal `activatedAmbiguously`. Pada window manager tiling, kombinasi dengan tombol Mod/Super umumnya dicegat WM sebelum sampai ke aplikasi. Dijelaskan di 6.3.5.
4. **\[Klarifikasi\] `PinchHandler` butuh dua titik sentuh.** Ia tidak aktif dengan mouse biasa; uji dengan layar sentuh atau perangkat yang mengirim gestur pinch (6.3.1).
5. **\[Tambahan, terverifikasi\] Fokus.** `Item.focusPolicy` tersedia sejak Qt 6.7. Pada kontrol Qt Quick Controls, `visualFocus` lebih tepat daripada `activeFocus` untuk menggambar indikator fokus, karena benar hanya bila fokus datang dari keyboard (Tab, Shift+Tab, atau pintasan) dan tidak dari mouse atau sentuhan. Dijelaskan di 6.3.3.
6. **\[Tambahan, terverifikasi\] `TapHandler`.** `gesturePolicy` (`DragThreshold`, `WithinBounds`, `ReleaseWithinBounds`), `longPressThreshold`, `tapCount`, `acceptedButtons`, `acceptedModifiers`; handler dinonaktifkan efektif bila item induknya nonaktif. Di 6.3.8.
7. **\[Tambahan\] Yang belum tercakup:** `HoverHandler`, `PointHandler`, `Keys.forwardTo` / `priority`, `KeyNavigation.priority`, perambatan peristiwa tombol, `Window.activeFocusItem` untuk debug fokus, dan detail `Flickable` (`boundsBehavior`, `flickableDirection`, `interactive`, kendali keyboard).
8. **\[Klarifikasi\] Latihan.** “Urutan Tab/panah yang lengkap tanpa menyentuh mouse” diperjelas menjadi tujuan yang dapat diuji: Tab, Shift+Tab, panah dengan perputaran, Enter/Spasi, dan log fokus.
9. **\[Tambahan\] 6.3.7 dan 6.3.8.** Pola keyboard bergaya terminal (hjkl, `gg`, mode normal/sisip, palet perintah) dan perbandingan Handler dengan `MouseArea`.

### **Temuan audit yang paling penting:**

- **Contoh kurikulum cacat:** persegi `a` dan `b` tidak bisa dijangkau dengan Tab karena tanpa `activeFocusOnTab`. `DragHandler` juga hanya membatasi sumbu x. Keduanya saya perbaiki.
- **Fokus:** `focusPolicy` pada `Item` baru ada sejak Qt 6.7. Untuk cincin fokus pada kontrol Qt Quick Controls, `visualFocus` lebih disarankan daripada `activeFocus`, karena hanya menyala ketika fokus datang dari keyboard, bukan dari mouse atau sentuhan. `Item` biasa tidak punya `visualFocus`, jadi cincin fokus di `AppButton` saya tetap menyala juga saat diklik; untuk perilaku keyboard-saja, turunkan dari `Button` (5.1.7 Opsi C).
- **`Shortcut`:** satu urutan dapat berisi hingga empat penekanan tombol, dan konteks bawaannya hanya aktif saat jendela induknya aktif. Di window manager tiling, kombinasi dengan tombol Mod biasanya dicegat WM lebih dulu (ini catatan saya, belum saya verifikasi di setup Anda).
- **`TapHandler`:** `gesturePolicy` bawaannya `DragThreshold`, yang memakai grab pasif sehingga tidak mengganggu handler lain; `ReleaseWithinBounds` cocok untuk perilaku tombol.
- **Tambahan di luar kurikulum:** pola keyboard bergaya terminal (mode normal/sisip, `gg`/`G`, palet perintah Ctrl+P), dialog modal yang aman, roving focus, serta `HoverHandler`, `PointHandler`, dan perbandingan handler dengan `MouseArea`.

**Daftar Modul 6.3 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

- 6.3.1 `DragHandler`, `PinchHandler`, `WheelHandler`
- 6.3.2 `Flickable`
- 6.3.3 Fokus, `FocusScope`, `forceActiveFocus()`
- 6.3.4 `KeyNavigation` dan `Keys`
- 6.3.5 `Shortcut` dan pemetaan tombol
- 6.3.6 Rancangan antarmuka yang bisa dioperasikan penuh dari keyboard
- &#91;+\] 6.3.7 Pola kendali keyboard bergaya terminal
- &#91;+\] 6.3.8 Handler lain dan Handler vs `MouseArea`

**Asumsi prasyarat.** Modul 4.4 (`TapHandler`), Modul 5.1.6 (fokus dan keyboard pada komponen), Modul 6.1 (`State`), dan Modul 6.2 (`Behavior`, animasi). Contoh yang memakai `Theme` mengasumsikan singleton dari Modul 5.3.

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini menyelesaikan dua sisi masukan: **pointer** (geser, cubit, roda, gulir kinetis lewat `DragHandler`, `PinchHandler`, `WheelHandler`, `Flickable`) dan **keyboard** (fokus, `FocusScope`, `KeyNavigation`, `Keys`, `Shortcut`). Tujuan akhirnya: antarmuka yang bisa dioperasikan penuh dengan keyboard saja, sebagaimana juga dengan pointer.

### Peran dalam kurikulum

Fase 5 membuat antarmuka yang rapi; 6.1 dan 6.2 membuatnya hidup. Tanpa kendali yang baik, ia tetap setengah jadi: tombol yang hanya bisa diklik, daftar yang tak bisa dijelajahi dengan tombol panah, dialog yang menjebak fokus. Modul ini menutup celah itu.

### Konsep kunci dan filosofi

- **Fokus adalah lampu sorot panggung.** Satu item memegangnya dan menerima tombol. `FocusScope` adalah panggung kecil dengan lampu sorotnya sendiri: komponen dapat mengelola fokus internalnya tanpa merebut fokus dari luar.
- **Antarmuka yang hanya bisa dipakai dengan pointer adalah antarmuka yang rusak.** Keyboard bukan fitur tambahan. Ia adalah jalur utama bagi pengguna aksesibilitas, pengguna mahir, otomasi, dan siapa pun yang hidup di terminal dan window manager tiling.
- **Peristiwa pointer dan peristiwa keyboard berjalan dengan cara berbeda.** Pointer dikirim ke item atau handler *di bawah titik sentuh*; keyboard dikirim ke item yang memegang *fokus aktif*, lalu merambat ke induknya bila tidak diterima.
- **Handler dirancang untuk hidup berdampingan.** Beberapa handler dapat menempel pada satu item dan bekerja sama (ketuk dan geser sekaligus), berbeda dengan `MouseArea` yang menutup area dan cenderung eksklusif.
- **Sudut pandang keamanan.** Kendali adalah permukaan serangan dan sumber kecelakaan. Tombol pintas satu tekanan untuk aksi merusak (`Delete`, `D`) tanpa konfirmasi atau undo mengundang bencana; fokus yang bisa “dicuri” elemen tak terduga dapat membuat pengguna mengetik kata sandi di tempat yang salah. Rancang agar aksi berbahaya memerlukan niat yang jelas.

Perambatan peristiwa tombol (ASCII):

```
  Tekan tombol
      |
      v
  item dengan activeFocus   --- menerima peristiwa lebih dulu
      | tidak diterima (event.accepted = false)
      v
  induknya                  --- diberi kesempatan berikutnya
      | tidak diterima
      v
  ... sampai akar jendela   --- bila tak ada yang menerima, peristiwa dibuang
```

## 6.3.1 `DragHandler`, `PinchHandler`, `WheelHandler`

### Dasar: apa itu Input Handler?

*Input Handler* adalah objek **nonvisual** yang ditempelkan ke sebuah item dan menafsirkan peristiwa pointer (mouse, sentuh, pena, touchpad) untuk item itu. Setiap handler mengenali satu jenis gestur: `TapHandler` (ketuk, 4.4), `DragHandler` (geser), `PinchHandler` (cubit), `WheelHandler` (roda), `HoverHandler`, `PointHandler`. Mereka dapat disusun berdampingan pada item yang sama.

Secara konsep, handler mengambil peristiwa dengan dua cara:

```
 grab PASIF      mengintip peristiwa tanpa mengambil alih; handler lain tetap menerimanya
                 (contoh: TapHandler pada pengaturan bawaan)
 grab EKSKLUSIF  mengambil alih sepenuhnya selama gestur berlangsung
                 (contoh: DragHandler setelah melewati ambang geser)
```

Inilah yang membuat `TapHandler` dan `DragHandler` dapat menempel pada item yang sama tanpa saling merusak.

### `DragHandler`: menggeser item

Properti utama: `target` (item yang digeser; bawaan: induk handler), `xAxis` dan `yAxis` (masing-masing punya `enabled`, `minimum`, `maximum`), `active` (hanya-baca; benar selama digeser), `translation`, `centroid`, `dragThreshold`.

```qml
import QtQuick

Window {
    width: 360; height: 240; visible: true

    Rectangle {
        id: arena
        anchors.fill: parent; anchors.margins: 20
        color: '#f1f5f9'; border.color: '#cbd5e1'

        Rectangle {
            id: kartu
            x: 0; y: 0; width: 80; height: 80; radius: 8; color: 'orchid'

            ParallelAnimation {
                id: kembali
                NumberAnimation { target: kartu; property: 'x'; to: 0; duration: 250; easing.type: Easing.OutCubic }
                NumberAnimation { target: kartu; property: 'y'; to: 0; duration: 250; easing.type: Easing.OutCubic }
            }

            DragHandler {
                id: seret
                xAxis.minimum: 0
                xAxis.maximum: arena.width - kartu.width
                yAxis.minimum: 0
                yAxis.maximum: arena.height - kartu.height
                onActiveChanged: if (!active) kembali.restart()
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `Rectangle { id: arena ... }` — area bermain; batas gerak kartu.
- `Rectangle { id: kartu ... }` — item yang akan digeser; handler di dalamnya menargetkan *induknya*, yaitu `kartu`.
- `ParallelAnimation { id: kembali ... }` — dua animasi `x` dan `y` bersamaan menuju 0 (dari 6.2): kartu meluncur kembali ke asal.
- `DragHandler { id: seret }` — handler geser; tanpa `target`, ia menggeser item induknya.
- `xAxis.minimum: 0` dan `xAxis.maximum: arena.width - kartu.width` — batas sumbu x di sistem koordinat induk kartu (yaitu `arena`): kartu tidak bisa keluar dari tepi kiri atau kanan. `yAxis.minimum` dan `yAxis.maximum` melakukan hal serupa untuk sumbu y (perbaikan dari kurikulum yang hanya membatasi x).
- `onActiveChanged: if (!active) kembali.restart()` — saat geseran berakhir (`active` menjadi salah), jalankan animasi kembali. `restart()` memastikan animasi mulai dari awal.
- Mengapa tidak memakai `Behavior` + `enabled: !seret.active` seperti di 6.2? Itu juga bekerja, tetapi urutan evaluasi binding dan handler pada saat `active` berubah tidak dijamin; animasi eksplisit lebih mudah diprediksi.

### Menguncinya dan memakai tanpa target

```qml
DragHandler { xAxis.enabled: false }            // hanya vertikal: sumbu x dimatikan
DragHandler { target: null; onTranslationChanged: console.log(translation) }   // hanya mendeteksi gestur
```

- `xAxis.enabled: false` — mengunci sumbu; kartu hanya bergerak naik-turun.
- `target: null` — handler tidak menggeser apa pun; Anda yang memakai `translation` (selisih sejak awal geseran) untuk menggerakkan sesuatu sendiri.

### `PinchHandler`: mencubit untuk menskala dan memutar

```qml
Rectangle {
    width: 200; height: 200; color: 'steelblue'

    PinchHandler {
        minimumScale: 0.5
        maximumScale: 3
        minimumRotation: -90
        maximumRotation: 90
    }
}
```

- `PinchHandler` bekerja pada **dua titik sentuh atau lebih**: menggeser kedua jari menggeser item, menjauhkan menskala, memutar memutar.
- `minimumScale` / `maximumScale` dan `minimumRotation` / `maximumRotation` membatasi hasilnya.
- **Pengujian:** butuh layar sentuh atau perangkat yang mengirim gestur pinch (misalnya touchpad pada platform yang meneruskannya). Dengan mouse biasa ia tidak aktif. Dukungan gestur touchpad bergantung pada platform dan compositor; verifikasi di sistem Anda.
- Seperti `DragHandler`, `target: null` menjadikannya detektor murni.

### `WheelHandler`: roda mouse dan gulir touchpad

```qml
Rectangle {
    id: kanvas
    width: 200; height: 200; color: 'tomato'

    WheelHandler {
        acceptedModifiers: Qt.ControlModifier
        onWheel: (event) => {
            kanvas.scale = Math.max(0.5, Math.min(3, kanvas.scale + event.angleDelta.y / 1200))
        }
    }
}
```

- `acceptedModifiers: Qt.ControlModifier` — handler hanya bereaksi bila Ctrl ditekan; tanpa Ctrl, roda dibiarkan untuk yang lain (misalnya `Flickable`).
- `onWheel: (event) => { ... }` — handler sinyal `wheel` dengan parameter peristiwa.
- `event.angleDelta.y` — besar putaran roda; satu “klik” roda umumnya bernilai 120, sehingga pembagian 1200 menghasilkan perubahan skala 0,1 per klik.
- `Math.max(0.5, Math.min(3, ...))` — menjepit hasil antara 0,5 dan 3 (JavaScript).
- `WheelHandler` juga menyediakan cara deklaratif (`property`, `rotationScale`) untuk mengikat putaran roda ke sebuah properti tanpa kode; lihat dokumentasi untuk versi Qt Anda.

### Opsi lain untuk menggeser, mencubit, dan roda

```qml
// Opsi 1 — DragHandler (di atas): modern, multi-sentuh, hidup berdampingan dengan handler lain

// Opsi 2 — MouseArea dengan drag (lama, tetap sah, hanya mouse dan sentuh tunggal)
MouseArea {
    anchors.fill: parent
    drag.target: kartu
    drag.minimumX: 0; drag.maximumX: arena.width - kartu.width
}

// Opsi 3 — PinchArea (padanan lama PinchHandler)
// Opsi 4 — Flickable untuk konten yang lebih besar dari viewport (6.3.2)
```

### Hal yang perlu diperhatikan

- **Batas gerak bergantung pada sistem koordinat induk,** bukan jendela.
- **Satu item, banyak handler.** Boleh, tetapi pahami siapa yang menang (6.3.8).
- **Gestur multi-sentuh butuh perangkat yang tepat.** Jangan menyimpulkan “rusak” hanya karena tak bereaksi pada mouse.
- **Keyboard tetap perlu jalur setara.** Bila sebuah item hanya bisa digeser dengan pointer, sediakan cara memindahkannya dengan keyboard (6.3.6).

**Referensi bagian ini:** [Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html) · [DragHandler](https://doc.qt.io/qt-6/qml-qtquick-draghandler.html) · [PinchHandler](https://doc.qt.io/qt-6/qml-qtquick-pinchhandler.html) · [WheelHandler](https://doc.qt.io/qt-6/qml-qtquick-wheelhandler.html) · [Qt Quick Examples: Pointer Handlers](https://doc.qt.io/qt-6/qtquick-pointerhandlers-example.html)

## 6.3.2 `Flickable`

### Dasar: jendela pandang atas konten yang lebih besar

`Flickable` adalah *viewport* (jendela pandang) yang menampilkan sebagian dari konten yang lebih besar dan membiarkan pengguna menggesernya dengan momentum (gulir kinetis): seret, lalu lepas, dan konten terus meluncur sebelum melambat. Ia adalah fondasi `ListView`, `GridView`, dan `ScrollView`.

```
   konten (contentWidth x contentHeight)
  +-------------------------------+
  |        +-------------+        |
  |        |  VIEWPORT   |  <-- ukuran Flickable itu sendiri
  |        |  (contentX, |
  |        |   contentY) |
  |        +-------------+        |
  +-------------------------------+
```

### Properti dan metode penting

- `contentWidth`, `contentHeight` — ukuran konten. Tetapkan secara eksplisit agar tidak bergantung pada tebakan.
- `contentX`, `contentY` — posisi viewport di dalam konten (offset).
- `flickableDirection` — `Flickable.AutoFlickDirection` (bawaan: ditentukan dari ukuran konten), `HorizontalFlick`, `VerticalFlick`, atau `HorizontalAndVerticalFlick`.
- `boundsBehavior` — perilaku di tepi: `Flickable.StopAtBounds`, `DragOverBounds`, `OvershootBounds`, atau `DragAndOvershootBounds` (bawaan).
- `interactive` — `false` mematikan gulir dengan pointer; gulir lewat kode dan keyboard tetap bisa.
- `maximumFlickVelocity`, `flickDeceleration` — menyetel momentum.
- `pressDelay` — menunda penerusan tekanan ke anak, agar sentuhan dapat dibedakan antara ketuk dan menggeser.
- `clip` — bawaannya `false`; setel `true` agar konten tidak tampak di luar viewport.
- `moving`, `flicking`, `dragging` — hanya-baca; keadaan gerak saat ini.
- Metode `flick(xVelocity, yVelocity)`, `cancelFlick()`, `returnToBounds()`.

### Contoh inti: daftar yang dapat digulir dengan pointer dan keyboard

```qml
import QtQuick

Window {
    width: 320; height: 240; visible: true

    Flickable {
        id: gulir
        anchors.fill: parent
        contentWidth: width
        contentHeight: kolom.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        focus: true

        function gulirKe(y) {
            contentY = Math.max(0, Math.min(contentHeight - height, y))
        }

        Keys.onDownPressed: gulirKe(contentY + 60)
        Keys.onUpPressed:   gulirKe(contentY - 60)
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_PageDown)      { gulirKe(contentY + height * 0.9); event.accepted = true }
            else if (event.key === Qt.Key_PageUp)   { gulirKe(contentY - height * 0.9); event.accepted = true }
            else if (event.key === Qt.Key_Home)     { gulirKe(0);                        event.accepted = true }
            else if (event.key === Qt.Key_End)      { gulirKe(contentHeight);            event.accepted = true }
        }

        Column {
            id: kolom
            width: gulir.width
            spacing: 8

            Repeater {
                model: 20
                Rectangle {
                    id: baris
                    required property int index
                    width: kolom.width; height: 48; radius: 6
                    color: Qt.hsla(baris.index / 20, 0.5, 0.6, 1)
                    Text { anchors.centerIn: parent; text: 'Baris ' + (baris.index + 1) }
                }
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `anchors.fill: parent` — `Flickable` memenuhi jendela; ini ukuran **viewport**.
- `contentWidth: width` — konten selebar viewport, sehingga tidak ada gulir horizontal.
- `contentHeight: kolom.implicitHeight` — tinggi konten sama dengan tinggi alami `Column` (jumlah tinggi baris ditambah jarak, dari 5.1.3).
- `clip: true` — memotong konten yang keluar dari viewport.
- `boundsBehavior: Flickable.StopAtBounds` — berhenti tegas di tepi, tanpa memantul.
- `focus: true` — agar `Flickable` memegang fokus awal dan menerima tombol.
- `function gulirKe(y) { ... }` — fungsi pembantu: menjepit `contentY` antara 0 dan `contentHeight - height` agar tak melewati ujung. Fungsi boleh dideklarasikan di dalam objek QML dan dipanggil dari handler.
- `Keys.onDownPressed: gulirKe(contentY + 60)` — panah bawah menggulir 60 piksel. `Keys.onUpPressed` sebaliknya.
- `Keys.onPressed: (event) => { ... }` — menangani PageUp, PageDown, Home, End. Pada handler umum seperti ini, `event.accepted = true` menandai peristiwa sudah ditangani agar tidak merambat ke induk (6.3.4). `height * 0.9` menggulir hampir satu layar, menyisakan sedikit tumpang-tindih agar pembaca tak kehilangan konteks.
- `Column { width: gulir.width }` — **jangan** memakai `anchors.fill: parent` di dalam `Flickable`. Anak yang dideklarasikan di dalam `Flickable` dimasukkan ke `contentItem`, sehingga `parent` adalah `contentItem` (bukan viewport). Beri lebar eksplisit dari `gulir.width`.

### Menambah bilah gulir

```qml
import QtQuick.Controls.Basic

Flickable {
    // ...
    ScrollBar.vertical: ScrollBar { }
}
```

`ScrollBar.vertical` adalah attached property dari Qt Quick Controls pada `Flickable`; bilah muncul di tepi dan dapat diseret.

### Opsi lain untuk menggulir konten

```qml
// Opsi 1 — Flickable (di atas): paling mendasar; Anda mengatur ukuran konten dan keyboard

// Opsi 2 — ScrollView (Qt Quick Controls): membungkus Flickable + ScrollBar
ScrollView { anchors.fill: parent; /* konten */ }

// Opsi 3 — ListView / GridView: untuk daftar berbasis model dengan delegate (materi model data)

// Opsi 4 — WheelHandler + DragHandler pada item biasa: gulir manual, kendali penuh tetapi tanpa momentum
```

### Hal yang perlu diperhatikan

- **`Flickable` tidak menyediakan kendali panah, PageUp, PageDown secara bawaan, sejauh yang saya ketahui.** Tambahkan lewat `Keys` seperti di atas (dan uji di versi Qt Anda).
- **`TapHandler` di dalam `Flickable` tidak mengganggu gulir,** karena handler itu memakai grab pasif (6.3.1); ketuk tetap diterima dan geser tetap menggulir.
- **Setel `contentWidth`/`contentHeight`** agar viewport tahu batasnya.
- **Animasi `contentY`** dapat dihaluskan dengan `Behavior on contentY { enabled: !gulir.moving; NumberAnimation { duration: 120 } }` sehingga lompatan keyboard terasa mulus tanpa mengganggu gulir sentuh; uji perilakunya karena interaksinya bergantung pada versi.

**Referensi bagian ini:** [Flickable](https://doc.qt.io/qt-6/qml-qtquick-flickable.html) · [ScrollBar](https://doc.qt.io/qt-6/qml-qtquick-controls-scrollbar.html) · [ScrollView](https://doc.qt.io/qt-6/qml-qtquick-controls-scrollview.html) · [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html)

## 6.3.3 Fokus, `FocusScope`, `forceActiveFocus()`

### Dasar: satu penerima untuk peristiwa keyboard

Peristiwa keyboard (penekanan tombol) hanya dikirim ke **satu** item pada satu waktu: item yang memegang *fokus aktif*. Tiga istilah yang harus dibedakan:

- `focus` — properti yang Anda atur; artinya “saya ingin fokus *di dalam lingkup fokus saya*”.
- `activeFocus` — properti hanya-baca; benar bila item benar-benar memegang fokus aktif, yaitu ia `focus` di lingkupnya *dan* seluruh lingkup di atasnya (sampai jendela) juga memegang fokus dan jendela sedang aktif.
- **Lingkup fokus (focus scope)** — batas yang membagi pohon item menjadi “panggung” terpisah. Akar jendela adalah lingkup pertama; setiap `FocusScope` membuat lingkup baru.

```
 Window (contentItem = lingkup akar)
 |- Item A              focus: false
 |- FocusScope P        focus: true     <- P pemegang fokus di lingkup akar
 |   |- TextInput T     focus: true     <- T pemegang fokus di lingkup P
 |   '- Item U          focus: false
 '- Item B              focus: false

 Jendela aktif -> P.activeFocus = true  dan  T.activeFocus = true
 (activeFocus butuh rantai fokus lengkap dari item sampai jendela)
```

### Aturan penting

- **Satu `focus: true` per lingkup.** Bila dua item dalam lingkup yang sama sama-sama meminta fokus, yang terakhir meminta mendapatkannya dan yang lain kehilangannya. Inilah penyebab klasik “fokus hilang karena beberapa item mengklaimnya”.
- **`focus: true` saja tidak cukup** bila lingkup induknya tidak sedang memegang fokus. Untuk memindahkan fokus aktif ke sebuah item di mana pun ia berada, pakai `forceActiveFocus()`.
- **Item yang tidak terlihat atau nonaktif tidak dapat memegang fokus.**
- **`forceActiveFocus(alasan)`** menyetel fokus pada item *dan* seluruh lingkup leluhurnya sekaligus. Parameter opsional adalah *alasan fokus* (`Qt.TabFocusReason`, `Qt.MouseFocusReason`, `Qt.ShortcutFocusReason`, `Qt.OtherFocusReason`, dst.).

### Contoh inti: komponen dengan `FocusScope`

```qml
// KolomCari.qml
import QtQuick

FocusScope {
    id: root

    property alias text: input.text
    signal diterima(string teks)

    implicitWidth: 240
    implicitHeight: 32

    Rectangle {
        anchors.fill: parent
        radius: 6
        color: 'white'
        border.width: root.activeFocus ? 2 : 1
        border.color: root.activeFocus ? '#1e40af' : '#94a3b8'

        TextInput {
            id: input
            anchors.fill: parent
            anchors.margins: 6
            focus: true
            font.pixelSize: 14
            onAccepted: root.diterima(text)
            Keys.onEscapePressed: text = ''
        }
    }
}
```

```qml
// pemakai
Column {
    spacing: 8
    KolomCari { id: f1; focus: true }      // fokus awal di kolom pertama
    KolomCari { id: f2 }
}
```

### Bedah kode (kata demi kata)

- `FocusScope { ... }` — akar komponen adalah lingkup fokus. Artinya komponen punya “panggung” sendiri: fokus di dalamnya tidak bentrok dengan fokus di luar.
- `TextInput { focus: true }` — di dalam lingkup ini, `TextInput` adalah pemegang fokus. Ia tidak berebut dengan `focus: true` milik komponen lain karena berada di lingkup berbeda.
- `KolomCari { focus: true }` (di pemakai) — pemakai meminta fokus untuk *komponen*; karena komponen adalah `FocusScope`, permintaan itu diteruskan ke anaknya yang ber-`focus: true`. **Pemakai tidak perlu (dan tidak bisa) tahu id `input` yang tersembunyi.** Ini penerapan prinsip enkapsulasi Modul 5.1 pada fokus.
- `border.width: root.activeFocus ? 2 : 1` — indikator fokus: `activeFocus` pada `FocusScope` benar ketika lingkup itu memegang fokus aktif.
- `onAccepted: root.diterima(text)` — `onAccepted` dipancarkan `TextInput` ketika pengguna menekan Enter; komponen mengabarkannya ke luar lewat signal (properti masuk, signal keluar).
- `Keys.onEscapePressed: text = ''` — Esc mengosongkan kolom; `text` di sini adalah properti `TextInput` itu sendiri.
- `property alias text: input.text` — meneruskan isi ke pemakai (alias dari 5.1.7).

Tanpa `FocusScope`, `KolomCari` bukan lingkup: dua instansnya akan berebut `focus: true` pada `TextInput` mereka di lingkup yang sama, dan pemakai tak punya cara bersih untuk memfokuskan salah satunya.

### Rantai Tab dan kebijakan fokus

- `activeFocusOnTab: true` — memasukkan item ke rantai Tab (Shift+Tab mundur). Urutannya mengikuti urutan anak di pohon, bukan posisi visual (lihat 5.2.7). Item masukan teks seperti `TextInput` umumnya sudah masuk rantai Tab secara bawaan; verifikasi di versi Anda.
- `focusPolicy` pada `Item` (Qt 6.7 ke atas) — mengatur cara item menerima fokus: `Qt.NoFocus`, `Qt.TabFocus`, `Qt.ClickFocus`, `Qt.StrongFocus` (Tab dan klik), `Qt.WheelFocus`. Pada Qt di bawah 6.7, kombinasi `activeFocusOnTab` dan `forceActiveFocus()` saat diklik (seperti di `AppButton`) adalah cara yang setara. Periksa nilai bawaan `focusPolicy` di versi Anda.
- `visualFocus` (hanya pada kontrol Qt Quick Controls) — benar bila kontrol memegang fokus aktif *dan* alasannya Tab, Shift+Tab, atau pintasan. Qt menyarankannya untuk menggambar cincin fokus karena **tidak** menyala ketika fokus datang dari klik mouse atau sentuhan. `Item` biasa tidak punya `visualFocus`; bila Anda ingin perilaku itu pada komponen buatan sendiri, turunkan dari `Button` atau `Control` (5.1.7 Opsi C).

### Alasan fokus

```
 Qt.TabFocusReason      Tab ditekan
 Qt.BacktabFocusReason  Shift+Tab
 Qt.MouseFocusReason    klik mouse atau sentuhan
 Qt.ShortcutFocusReason pintasan (mis. mnemonik label)
 Qt.PopupFocusReason    popup dibuka atau ditutup
 Qt.OtherFocusReason    sebab lain, khas aplikasi
```

### Memantau fokus saat debug

```qml
Window {
    id: win
    onActiveFocusItemChanged: console.log('fokus ->', activeFocusItem)
}
```

`Window.activeFocusItem` memberi tahu item mana yang sedang memegang fokus aktif; mencetaknya tiap berubah adalah cara tercepat membongkar misteri “ke mana fokus pergi?”.

### Opsi lain untuk mengatur fokus komponen

```qml
// Opsi 1 — FocusScope sebagai akar komponen (di atas; disarankan)

// Opsi 2 — metode publik yang memfokuskan bagian dalam
function fokuskan() { input.forceActiveFocus() }
// pemakai: f1.fokuskan()   (lebih langsung, tetapi API bertambah)

// Opsi 3 — turunkan dari kontrol Qt Quick Controls (TextField): fokus, visualFocus, aksesibilitas sudah ditangani

// Opsi 4 — Component.onCompleted: forceActiveFocus()  (fokus saat dibuat; pakai hemat, jangan merebut fokus tanpa alasan)
```

### Hal yang perlu diperhatikan

- **Jangan merebut fokus tanpa alasan.** Memanggil `forceActiveFocus()` saat komponen dimuat dapat merampas fokus dari pengguna yang sedang mengetik di tempat lain.
- **Kembalikan fokus.** Saat dialog atau popup ditutup, kembalikan fokus ke item yang membukanya (6.3.6).
- **Fokus berpindah dengan sendirinya** saat item yang memegangnya disembunyikan atau dinonaktifkan; rancang jalur kembali.
- **Window harus aktif** agar ada fokus aktif. Pada window manager tiling, fokus jendela ditentukan WM.

**Referensi bagian ini:** [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [FocusScope](https://doc.qt.io/qt-6/qml-qtquick-focusscope.html) · [Item (focus, activeFocus, forceActiveFocus, focusPolicy)](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Control (focusPolicy, visualFocus, focusReason)](https://doc.qt.io/qt-6/qml-qtquick-controls-control.html) · [Window (activeFocusItem)](https://doc.qt.io/qt-6/qml-qtquick-window.html) · [TextInput](https://doc.qt.io/qt-6/qml-qtquick-textinput.html)

## 6.3.4 `KeyNavigation` dan `Keys`

### Dasar: dua attached property untuk keyboard

- **`KeyNavigation`** — memindahkan fokus ke item lain saat tombol arah, Tab, atau Shift+Tab ditekan. Anda cukup menunjuk tujuannya.
- **`Keys`** — menangani penekanan tombol itu sendiri (kode yang berjalan), baik tombol tertentu (`Keys.onReturnPressed`) maupun semua tombol (`Keys.onPressed`).

Keduanya adalah *attached property* (5.2.3): ditulis di item yang akan menerima tombol, dan hanya bekerja bila item itu memegang fokus aktif.

### Sintaks

```
KeyNavigation.left / right / up / down / tab / backtab : <item tujuan>
KeyNavigation.priority : KeyNavigation.BeforeItem | KeyNavigation.AfterItem   // bawaan: AfterItem

Keys.onPressed: (event) => { ... }           // semua tombol; event.key, event.text, event.modifiers
Keys.on<Tombol>Pressed: <kode>               // tombol tertentu (ReturnPressed, EscapePressed, UpPressed, ...)
Keys.forwardTo: [ <item>, ... ]              // teruskan peristiwa ke Keys milik item lain
Keys.priority : Keys.BeforeItem | Keys.AfterItem
Keys.onShortcutOverride: (event) => { ... } // klaim tombol sebelum Shortcut
```

### Contoh inti: versi perbaikan dari kurikulum

```qml
import QtQuick

Window {
    visible: true; width: 360; height: 240

    Shortcut { sequence: 'Ctrl+Q'; onActivated: Qt.quit() }

    Rectangle {
        width: 80; height: 80; color: 'orchid'
        DragHandler {
            xAxis.minimum: 0; xAxis.maximum: 280
            yAxis.minimum: 0; yAxis.maximum: 160
        }
    }

    Row {
        y: 150; spacing: 8

        Rectangle {
            id: a
            width: 60; height: 40
            focus: true
            activeFocusOnTab: true
            color: activeFocus ? 'gold' : 'gray'
            border.width: activeFocus ? 2 : 0
            KeyNavigation.right: b
            KeyNavigation.tab: b
        }

        Rectangle {
            id: b
            width: 60; height: 40
            activeFocusOnTab: true
            color: activeFocus ? 'gold' : 'gray'
            border.width: activeFocus ? 2 : 0
            KeyNavigation.left: a
            KeyNavigation.backtab: a
        }
    }
}
```

### Bedah kode (kata demi kata)

- `Shortcut { sequence: 'Ctrl+Q'; onActivated: Qt.quit() }` — pintasan keluar (6.3.5).
- `DragHandler { xAxis...; yAxis... }` — sekarang persegi anggrek terkunci di dalam jendela pada kedua sumbu (perbaikan).
- `focus: true` pada `a` — `a` memegang fokus saat jendela dibuka; tanpanya tak ada penerima tombol sampai pengguna menekan Tab atau mengklik.
- `activeFocusOnTab: true` — memasukkan persegi ke rantai Tab. Tanpanya Tab tidak pernah mendarat di `Rectangle` (ini temuan audit).
- `color: activeFocus ? 'gold' : 'gray'` — `activeFocus` di sini adalah milik persegi itu sendiri; emas berarti memegang fokus.
- `border.width: activeFocus ? 2 : 0` — indikator fokus yang tidak hanya bergantung pada warna (6.3.6).
- `KeyNavigation.right: b` — saat `a` memegang fokus dan panah kanan ditekan, fokus pindah ke `b`.
- `KeyNavigation.tab: b` dan `KeyNavigation.backtab: a` — mengatur secara eksplisit tujuan Tab dan Shift+Tab; hasilnya menggantikan urutan rantai Tab otomatis.

### Keys: menangani tombol sendiri

```qml
Rectangle {
    focus: true

    Keys.onReturnPressed: console.log('Enter utama')
    Keys.onEnterPressed:  console.log('Enter keypad')
    Keys.onEscapePressed: console.log('Esc')

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_H && (event.modifiers & Qt.ControlModifier)) {
            console.log('Ctrl+H')
            event.accepted = true
        }
    }
}
```

- `Keys.onReturnPressed` / `onEnterPressed` / `onEscapePressed` — handler untuk tombol tertentu. Qt membedakan `Return` (Enter utama) dan `Enter` (keypad numerik).
- `Keys.onPressed: (event) => { ... }` — handler umum; `event` bertipe `KeyEvent`.
- `event.key === Qt.Key_H` — `event.key` adalah kode tombol; konstanta `Qt.Key_*` menamainya.
- `event.modifiers & Qt.ControlModifier` — `modifiers` adalah kumpulan bendera (Ctrl, Shift, Alt, Meta); operator `&` menguji apakah Ctrl ikut ditekan.
- `event.accepted = true` — menandai peristiwa sudah ditangani sehingga **tidak** merambat ke induk (lihat diagram di awal modul). Umumnya handler untuk tombol tertentu menerima peristiwa secara otomatis, sedangkan pada handler umum `onPressed` Anda perlu menyetel `accepted` sendiri; verifikasi perilakunya di versi Anda bila ragu.
- Properti lain yang berguna: `event.text` (teks yang dihasilkan tombol), `event.isAutoRepeat` (tombol ditahan).

### Mencegat sebelum item: `priority`

```qml
TextInput {
    Keys.priority: Keys.BeforeItem
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Space) event.accepted = true      // blokir spasi sebelum TextInput memprosesnya
    }
}
```

Secara bawaan (`AfterItem`) handler `Keys` berjalan *setelah* item menangani tombol itu sendiri. Dengan `BeforeItem`, handler berjalan lebih dulu dan, bila menerima peristiwa, item tak pernah melihatnya. `KeyNavigation.priority` memiliki dua nilai yang sama: gunakan `BeforeItem` agar panah kiri/kanan berpindah fokus alih-alih menggerakkan kursor teks.

### Meneruskan peristiwa: `forwardTo`

```qml
Item {
    focus: true
    Keys.forwardTo: [daftar]        // peristiwa tombol juga dikirim ke Keys milik 'daftar'
    // ...
}
```

`Keys.forwardTo` berguna ketika fokus tinggal di satu item (misalnya kolom pencarian) tetapi tombol panah harus juga menggerakkan item lain (daftar hasil).

### Mengklaim tombol dari `Shortcut`: `shortcutOverride`

```qml
TextInput {
    Keys.onShortcutOverride: (event) => { event.accepted = (event.key === Qt.Key_Escape) }
}
```

`Shortcut` bisa mencuri tombol yang sedang dipakai item fokus. Dengan `onShortcutOverride`, item meminta tombol itu untuk dirinya (misalnya Esc di dalam kolom teks) sehingga pintasan jendela tidak ikut aktif. Teks masukan standar sudah melakukannya untuk tombol pengetikan.

### Opsi lain untuk berpindah fokus

```qml
// Opsi 1 — KeyNavigation: deklaratif; cukup tunjuk tujuannya (di atas)
KeyNavigation.right: b

// Opsi 2 — Keys: imperatif; kendali penuh dan dapat bersyarat
Keys.onRightPressed: b.forceActiveFocus(Qt.TabFocusReason)

// Opsi 3 — satu perhentian Tab untuk kelompok, panah di dalamnya (roving focus; 6.3.6)
```

### Hal yang perlu diperhatikan

- **`Keys` dan `KeyNavigation` hanya bekerja pada item yang memegang fokus aktif.** Bila “tombolnya tak bereaksi”, periksa dulu siapa yang memegang fokus (`onActiveFocusItemChanged`).
- **Tombol yang diterima tidak merambat.** Hati-hati menerima tombol yang berguna bagi induk (misalnya Esc untuk menutup dialog).
- **Auto-repeat:** menahan tombol memicu `onPressed` berulang; periksa `event.isAutoRepeat` bila aksi tak boleh berulang.
- **Kolom teks memakai tombol kursor sendiri.** `KeyNavigation` kiri/kanan di dalam `TextInput` bentrok dengan kursor, kecuali Anda memakai `priority` dan syarat tertentu.

**Referensi bagian ini:** [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [KeyNavigation](https://doc.qt.io/qt-6/qml-qtquick-keynavigation.html) · [KeyEvent](https://doc.qt.io/qt-6/qml-qtquick-keyevent.html) · [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · [Qt.Key (enumerasi tombol)](https://doc.qt.io/qt-6/qt.html#Key-enum)

## 6.3.5 `Shortcut` dan pemetaan tombol

### Dasar: pintasan tingkat jendela

`Shortcut` (modul `QtQuick`) adalah objek nonvisual yang memicu sebuah aksi bila kombinasi tombol tertentu ditekan. Bedanya dengan `Keys`:

```
 Keys.onXxxPressed        hanya bila item ITU memegang fokus aktif
 Shortcut (WindowShortcut)       selama jendela induknya aktif, apa pun item yang fokus   <- bawaan
 Shortcut (ApplicationShortcut)  selama salah satu jendela aplikasi aktif
```

Dari dokumentasi Qt (sudah diverifikasi): properti `sequence` (satu urutan) dan `sequences` (beberapa), `context`, `enabled` (bawaan `true`), `autoRepeat` (bawaan `true`), `nativeText` dan `portableText` (teks pintasan untuk ditampilkan atau disimpan); sinyal `activated()` dan `activatedAmbiguously()`. Sebuah urutan dapat berisi **hingga empat penekanan tombol** berurutan, dipisah koma (akord, misalnya `Ctrl+E,Ctrl+W`).

### Contoh inti

```qml
import QtQuick

Window {
    id: win
    width: 380; height: 200; visible: true
    title: 'Pintasan'

    property int hitung: 0

    Shortcut {
        id: simpan
        sequences: [StandardKey.Save, 'Ctrl+Alt+S']
        onActivated: console.log('simpan')
    }

    Shortcut {
        sequence: 'Ctrl+K,Ctrl+C'
        onActivated: console.log('akord: Ctrl+K lalu Ctrl+C')
    }

    Shortcut {
        sequence: 'Ctrl+Q'
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    Shortcut {
        sequence: 'F5'
        enabled: win.hitung < 3
        autoRepeat: false
        onActivated: win.hitung++
    }

    Text {
        anchors.centerIn: parent
        text: 'Simpan: ' + simpan.nativeText + '   |   F5 diterima: ' + win.hitung + ' kali'
    }
}
```

### Bedah kode (kata demi kata)

- `sequences: [StandardKey.Save, 'Ctrl+Alt+S']` — dua jalur ke aksi yang sama. `StandardKey.Save` adalah pintasan *baku platform* untuk “simpan” (biasanya Ctrl+S di Linux); string `'Ctrl+Alt+S'` adalah tambahan buatan sendiri. Qt menyarankan memakai `sequences` untuk tombol baku karena satu `StandardKey` dapat memetakan ke beberapa kombinasi pada platform berbeda.
- `sequence: 'Ctrl+K,Ctrl+C'` — akord dua langkah: tekan Ctrl+K, lepas, lalu Ctrl+C.
- `context: Qt.ApplicationShortcut` — aktif selama salah satu jendela aplikasi aktif (bawaannya `Qt.WindowShortcut`, aktif bila jendela induk pintasan itu aktif).
- `enabled: win.hitung < 3` — pintasan dimatikan setelah tiga kali diterima; `enabled` adalah binding biasa.
- `autoRepeat: false` — menahan F5 tidak memicu berulang.
- `simpan.nativeText` — teks pintasan sesuai platform dan terjemahan; paling baik ditampilkan kepada pengguna (misalnya di petunjuk alat atau menu), sehingga tampilan tak pernah berbeda dari pintasan sebenarnya.

### Akord yang ambigu

```qml
Shortcut { sequence: 'Ctrl+K,Ctrl+C'; onActivated: console.log('komentari') }
Shortcut { sequence: 'Ctrl+K,Ctrl+U'; onActivated: console.log('batal komentar') }
Shortcut {
    sequence: 'Ctrl+K'
    onActivatedAmbiguously: status.text = 'menunggu tombol berikutnya...'
}
```

Setelah Ctrl+K, kedua akord di atas masih mungkin; Qt memancarkan `activatedAmbiguously` dari pintasan yang cocok dengan *awal* lebih dari satu urutan. Gunakan sinyal itu untuk memberi umpan balik (“menunggu tombol berikutnya”) seperti bilah status editor.

### Pemetaan tombol (key mapping) yang dapat diubah

```qml
// Keymap.qml (singleton atau objek biasa)
import QtQuick

QtObject {
    readonly property var bawah: ['J', 'Down']
    readonly property var atas:  ['K', 'Up']
    readonly property var pilih: ['Return', 'Space']
}
```

```qml
Shortcut { sequences: keymap.bawah; onActivated: papan.turun() }
```

Memisahkan *daftar tombol* dari *aksi* membuat pemetaan mudah dibaca, dijadikan petunjuk bantuan, dan kelak dapat disimpan atau diubah pengguna (dengan `Settings`, Modul 6.4). Verifikasi bahwa penugasan larik JS ke `sequences` bekerja di versi Qt Anda; bila tidak, tulis larik secara literal di tiap `Shortcut`.

### Perbedaan dan bentrok

- **`Shortcut` vs `Keys`.** `Shortcut` terpicu tanpa peduli fokus; `Keys` hanya bila fokus. Untuk perilaku yang bergantung konteks (panah di daftar), pakai `Keys`; untuk aksi aplikasi (simpan, keluar, palet perintah), pakai `Shortcut`.
- **Bentrok dengan kolom teks.** Item masukan teks mengklaim tombol pengetikan lewat `ShortcutOverride`, jadi pintasan satu huruf tidak terpicu saat Anda mengetik. Item Anda sendiri dapat melakukan hal serupa dengan `Keys.onShortcutOverride` (6.3.4).
- **Window manager tiling.** Aplikasi hanya menerima tombol yang *diteruskan* WM. Pada i3, sway, dwm, atau Hyprland, kombinasi yang memakai tombol Mod (umumnya Super, kadang Alt) biasanya dicegat WM lebih dulu. Hindari pintasan berbasis `Meta+` dan pertimbangkan `Alt+` dengan hati-hati; pintasan `Ctrl+` dan tombol tunggal dalam konteks fokus lebih aman.
- **Tidak ada pintasan global lintas aplikasi.** Konteks `Shortcut` hanya mencakup jendela aplikasi Anda; pintasan global ditangani oleh WM atau compositor, bukan oleh `Shortcut`.
- **Aksi merusak.** Jangan menaruh aksi tak bisa dibatalkan (hapus, kirim) pada satu tombol tanpa konfirmasi atau undo; pintasan yang tak sengaja tertekan menimbulkan kerugian nyata.

### Opsi lain untuk pintasan

```qml
// Opsi 1 — Shortcut (di atas): tingkat jendela, deklaratif
// Opsi 2 — Keys.onPressed pada item akar yang memegang fokus: bergantung fokus, kendali penuh
// Opsi 3 — Qt Quick Controls Action + MenuItem/ToolButton: pintasan melekat pada aksi yang juga muncul di menu
Action { id: aksiSimpan; text: 'Simpan'; shortcut: StandardKey.Save; onTriggered: console.log('simpan') }
```

**Referensi bagian ini:** [Shortcut](https://doc.qt.io/qt-6/qml-qtquick-shortcut.html) · [QKeySequence](https://doc.qt.io/qt-6/qkeysequence.html) · [Action (Qt Quick Controls)](https://doc.qt.io/qt-6/qml-qtquick-controls-action.html) · [Keys.shortcutOverride](https://doc.qt.io/qt-6/qml-qtquick-keys.html)

## 6.3.6 Rancangan antarmuka yang bisa dioperasikan penuh dari keyboard

### Dasar: keyboard bukan fitur tambahan

Antarmuka dikatakan bisa dioperasikan penuh dari keyboard bila **setiap fungsi yang tersedia dengan pointer juga tersedia dengan keyboard saja**, dengan urutan yang logis dan umpan balik yang jelas. Ini bukan hanya soal aksesibilitas: pengguna mahir, pengguna terminal, otomasi, dan pemakai window manager tiling mengandalkannya.

### Daftar periksa

1. **Dapat dijangkau.** Setiap kontrol bisa mendapat fokus dengan Tab dan Shift+Tab (`activeFocusOnTab`, `focusPolicy`).
2. **Urutan fokus logis.** Mengikuti urutan baca; urutan Tab mengikuti urutan *deklarasi*, bukan posisi visual, kecuali Anda mengaturnya lewat `KeyNavigation.tab`.
3. **Indikator fokus selalu terlihat** dan berkontras cukup (5.3.7). Jangan hanya mengandalkan warna.
4. **Setiap aksi punya jalur keyboard:** Enter atau Spasi untuk mengaktifkan, panah untuk memilih, pintasan untuk aksi umum.
5. **Esc selalu membatalkan atau menutup,** dan fokus **kembali** ke tempat asal.
6. **Tidak ada jebakan fokus.** Pengecualian yang sah: dialog modal yang bisa ditutup dengan Esc.
7. **Satu perhentian Tab untuk kelompok, panah di dalamnya** (*roving focus*) untuk bilah alat, daftar, dan tab; Tab tidak boleh melewati puluhan elemen.
8. **Jangan menyembunyikan fungsi di balik hover atau gestur** yang hanya bisa dilakukan pointer.
9. **Pintasan terdokumentasi, terlihat, dan tidak bentrok.**
10. **Peran dan nama aksesibilitas** (`Accessible.role`, `Accessible.name`; 5.1.6).
11. **Uji “tanpa mouse”.** Jalankan aplikasi dan selesaikan tugas utama tanpa menyentuh mouse.

Pedoman WCAG yang relevan: 2.1.1 Keyboard, 2.1.2 No Keyboard Trap, 2.4.3 Focus Order, dan 2.4.7 Focus Visible.

### Pola 1: satu perhentian Tab, panah di dalam (roving focus)

```qml
// BilahPilihan.qml
import QtQuick

FocusScope {
    id: root

    property var model: []
    property int indeks: 0
    signal dipilih(int indeks)

    activeFocusOnTab: true
    implicitWidth: baris.implicitWidth
    implicitHeight: baris.implicitHeight

    Keys.onLeftPressed:   root.indeks = Math.max(0, root.indeks - 1)
    Keys.onRightPressed:  root.indeks = Math.min(root.model.length - 1, root.indeks + 1)
    Keys.onReturnPressed: root.dipilih(root.indeks)
    Keys.onSpacePressed:  root.dipilih(root.indeks)

    Row {
        id: baris
        spacing: 6

        Repeater {
            model: root.model

            Rectangle {
                id: sel
                required property string modelData
                required property int index

                implicitWidth: label.implicitWidth + 20
                implicitHeight: 30
                radius: 6
                color: sel.index === root.indeks ? '#2563eb' : '#e2e8f0'
                border.width: (sel.index === root.indeks && root.activeFocus) ? 2 : 0
                border.color: '#0f172a'

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: sel.modelData
                    color: sel.index === root.indeks ? 'white' : '#0f172a'
                }

                TapHandler {
                    onTapped: {
                        root.indeks = sel.index
                        root.forceActiveFocus()
                        root.dipilih(sel.index)
                    }
                }
            }
        }
    }
}
```

- `FocusScope` + `activeFocusOnTab: true` — seluruh bilah hanya satu perhentian Tab.
- `Keys.onLeftPressed` / `onRightPressed` — panah menggeser `indeks` (dijepit antara 0 dan jumlah elemen kurang satu); tidak ada fokus yang berpindah antar-elemen, hanya penanda pilihan.
- `Keys.onReturnPressed` / `onSpacePressed` — mengaktifkan elemen terpilih lewat signal `dipilih`.
- Elemen dibuat oleh `Repeater` dengan `required property` untuk `modelData` dan `index`; yang terpilih berwarna biru, dan cincin fokus tampil hanya saat bilah memegang fokus aktif.
- `TapHandler` — klik pointer memilih elemen, meminta fokus bilah, dan mengaktifkannya: jalur pointer dan keyboard menuju aksi yang sama.

### Pola 2: dialog modal yang aman

```qml
// DialogHapus.qml
import QtQuick

FocusScope {
    id: dialog
    property Item pemicu: null
    visible: false

    function buka(dari) {
        pemicu = dari
        visible = true
        batal.forceActiveFocus()          // fokus awal pada aksi AMAN, bukan yang merusak
    }
    function tutup() {
        visible = false
        if (pemicu) pemicu.forceActiveFocus()    // kembalikan fokus ke pembuka dialog
    }

    Keys.onEscapePressed: dialog.tutup()

    Rectangle {
        anchors.fill: parent
        color: 'white'; radius: 8; border.color: '#475569'

        Text { x: 16; y: 16; text: 'Hapus berkas ini?'; font.pixelSize: 16 }

        Row {
            x: 16; y: 60; spacing: 8

            AppButton {
                id: batal
                label: 'Batal'
                KeyNavigation.tab: hapus
                KeyNavigation.backtab: hapus
                onClicked: dialog.tutup()
            }
            AppButton {
                id: hapus
                label: 'Hapus'
                KeyNavigation.tab: batal
                KeyNavigation.backtab: batal
                onClicked: { console.log('dihapus'); dialog.tutup() }
            }
        }
    }
}
```

- `function buka(dari)` — menyimpan siapa yang membuka (`pemicu`), menampilkan dialog, dan memberi fokus ke **Batal**: aksi yang aman. Menekan Enter secara refleks tidak langsung menghapus.
- `function tutup()` — menyembunyikan dialog lalu **mengembalikan fokus** ke `pemicu`, sehingga pengguna keyboard tidak “hilang”.
- `Keys.onEscapePressed: dialog.tutup()` — Esc selalu keluar (tidak ada jebakan fokus).
- `KeyNavigation.tab` dan `backtab` saling menunjuk — fokus berputar di dalam dialog selama modal; ini jebakan *yang sah* karena ada jalan keluar (Esc dan tombol Batal).
- `AppButton` dari Modul 5 dipakai ulang; ia sudah bisa difokuskan dan diaktifkan dengan Enter atau Spasi (5.1.6).

### Pola 3: kesetaraan gestur pointer dan keyboard

```qml
// pointer: Ctrl + roda untuk zoom (6.3.1)
WheelHandler { acceptedModifiers: Qt.ControlModifier; onWheel: (e) => kanvas.scale += e.angleDelta.y / 1200 }

// keyboard: pintasan zoom yang setara
Shortcut { sequences: [StandardKey.ZoomIn];  onActivated: kanvas.scale = Math.min(3, kanvas.scale + 0.1) }
Shortcut { sequences: [StandardKey.ZoomOut]; onActivated: kanvas.scale = Math.max(0.5, kanvas.scale - 0.1) }
```

Setiap gestur pointer yang memberi fungsi (zoom, geser, putar) harus punya padanan keyboard.

### Opsi lain untuk kelompok kontrol

```qml
// Opsi 1 — roving focus dengan satu FocusScope (Pola 1): satu perhentian Tab
// Opsi 2 — tiap elemen perhentian Tab sendiri (activeFocusOnTab pada semuanya): sederhana, tetapi jalan panjang bagi pengguna keyboard
// Opsi 3 — komponen Qt Quick Controls (TabBar, ToolBar, ListView dengan keyboard bawaan): perilaku sudah standar
```

**Referensi bagian ini:** [WCAG 2.1.1 Keyboard](https://www.w3.org/WAI/WCAG21/Understanding/keyboard.html) · [WCAG 2.1.2 No Keyboard Trap](https://www.w3.org/WAI/WCAG21/Understanding/no-keyboard-trap.html) · [WCAG 2.4.3 Focus Order](https://www.w3.org/WAI/WCAG21/Understanding/focus-order.html) · [WCAG 2.4.7 Focus Visible](https://www.w3.org/WAI/WCAG21/Understanding/focus-visible.html) · [Accessibility for Qt Quick Applications](https://doc.qt.io/qt-6/qtquick-accessibility.html) · [WAI-ARIA Authoring Practices: keyboard interface (roving tabindex)](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/)

## 6.3.7 \[TAMBAHAN\] Pola kendali keyboard bergaya terminal

*Alasan penambahan:* Anda hidup di terminal dan window manager tiling; antarmuka yang dikendalikan seperti Vim atau palet perintah adalah nilai tambah nyata, dan semuanya hanya penerapan `Keys`, `Shortcut`, fokus, dan state.

### 1. Mode normal/sisip, hjkl, `gg` dan `G`

```qml
import QtQuick

Window {
    id: win
    width: 360; height: 300; visible: true
    title: 'Mode normal / sisip'

    Item {
        id: papan
        anchors.fill: parent
        focus: true

        property string mode: 'normal'
        property int baris: 0
        property string buffer: ''
        readonly property int jumlah: 10

        Timer { id: lupa; interval: 600; onTriggered: papan.buffer = '' }

        Keys.onPressed: (event) => {
            if (papan.mode === 'sisip') {
                if (event.key === Qt.Key_Escape) { papan.mode = 'normal'; event.accepted = true }
                return
            }
            const shift = (event.modifiers & Qt.ShiftModifier) !== 0
            switch (event.key) {
            case Qt.Key_J: papan.baris = Math.min(papan.jumlah - 1, papan.baris + 1); break
            case Qt.Key_K: papan.baris = Math.max(0, papan.baris - 1); break
            case Qt.Key_G:
                if (shift) { papan.baris = papan.jumlah - 1; papan.buffer = '' }
                else if (papan.buffer === 'g') { papan.baris = 0; papan.buffer = '' }
                else { papan.buffer = 'g'; lupa.restart() }
                break
            case Qt.Key_I: papan.mode = 'sisip'; break
            default: return
            }
            event.accepted = true
        }

        Column {
            x: 16; y: 16; spacing: 4
            Repeater {
                model: papan.jumlah
                Rectangle {
                    id: sel
                    required property int index
                    width: 200; height: 22; radius: 4
                    color: sel.index === papan.baris ? '#2563eb' : '#e2e8f0'
                    Text {
                        x: 8; anchors.verticalCenter: parent.verticalCenter
                        text: 'Baris ' + (sel.index + 1)
                        color: sel.index === papan.baris ? 'white' : '#0f172a'
                    }
                }
            }
        }

        Text {
            x: 16; y: 270
            text: '-- ' + (papan.mode === 'normal' ? 'NORMAL' : 'SISIP') + ' --   ' + papan.buffer
            font.family: 'monospace'
        }
    }
}
```

### Bedah kode (kata demi kata)

- `property string mode: 'normal'` — mode modal sebagai data; `baris` adalah posisi, `buffer` menampung tombol yang belum lengkap (untuk `gg`).
- `Timer { id: lupa; interval: 600 }` — setelah 600 ms tanpa tombol lanjutan, buffer dikosongkan sehingga “g” yang menggantung tak bertahan selamanya.
- `if (papan.mode === 'sisip') { ... return }` — di mode sisip hanya Esc yang ditangani; selainnya dibiarkan (tidak diterima), sehingga bisa ditangani item lain (misalnya kolom teks).
- `const shift = (event.modifiers & Qt.ShiftModifier) !== 0` — menguji apakah Shift ikut ditekan. Kode tombol `Qt.Key_G` sama untuk `g` dan `G`; pembedanya adalah modifier.
- `switch (event.key) { case Qt.Key_J: ... }` — memetakan tombol ke aksi; `break` mengakhiri tiap kasus.
- `case Qt.Key_G:` — tiga cabang: `Shift+G` ke baris terakhir; `g` kedua (buffer sudah `'g'`) ke baris pertama (`gg`); `g` pertama mengisi buffer dan menyalakan timer.
- `default: return` — tombol yang tidak dikenal tidak diterima, sehingga merambat ke induk.
- `event.accepted = true` — hanya tombol yang kita tangani yang diterima.

Penyempurnaan: nyatakan mode sebagai `State` (6.1) agar tampilan berubah otomatis, dan pakai `DSM.StateMachine` (6.1.5) bila mode dan perpindahannya bertambah banyak.

### 2. Palet perintah (Ctrl+P)

```qml
// PaletPerintah.qml
import QtQuick

FocusScope {
    id: root

    property var perintah: []                      // [{ nama: 'Simpan', aksi: () => ... }]
    property int indeks: 0
    property Item sebelumnya: null
    readonly property var terfilter: perintah.filter(
        p => p.nama.toLowerCase().indexOf(input.text.toLowerCase()) !== -1)

    visible: false

    function buka() {
        sebelumnya = root.Window.activeFocusItem
        input.text = ''
        indeks = 0
        visible = true
        input.forceActiveFocus()
    }
    function tutup() {
        visible = false
        if (sebelumnya) sebelumnya.forceActiveFocus()
    }

    Rectangle {
        anchors.fill: parent
        color: 'white'; radius: 8; border.color: '#94a3b8'

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            TextInput {
                id: input
                width: parent.width; height: 28
                focus: true
                font.pixelSize: 14
                onTextChanged: root.indeks = 0
                Keys.onDownPressed: root.indeks = Math.min(root.terfilter.length - 1, root.indeks + 1)
                Keys.onUpPressed:   root.indeks = Math.max(0, root.indeks - 1)
                Keys.onEscapePressed: root.tutup()
                onAccepted: {
                    const p = root.terfilter[root.indeks]
                    root.tutup()
                    if (p) p.aksi()
                }
            }

            Repeater {
                model: root.terfilter
                Rectangle {
                    id: sel
                    required property var modelData
                    required property int index
                    width: parent.width; height: 26; radius: 4
                    color: sel.index === root.indeks ? '#dbeafe' : 'transparent'
                    Text { x: 8; anchors.verticalCenter: parent.verticalCenter; text: sel.modelData.nama }
                }
            }
        }
    }
}
```

```qml
// pemakai
Window {
    width: 360; height: 240; visible: true

    Shortcut { sequence: 'Ctrl+P'; onActivated: palet.buka() }

    PaletPerintah {
        id: palet
        x: 40; y: 30; width: 280; height: 170
        perintah: [
            { nama: 'Simpan',      aksi: () => console.log('simpan') },
            { nama: 'Buka berkas',  aksi: () => console.log('buka') },
            { nama: 'Ganti tema',   aksi: () => console.log('tema') },
            { nama: 'Keluar',       aksi: () => Qt.quit() }
        ]
    }
}
```

### Bedah kode (kata demi kata)

- `property var perintah` — daftar objek JavaScript berisi `nama` dan fungsi `aksi`. Palet tidak tahu *apa* aksinya; ia hanya menjalankannya (properti masuk).
- `readonly property var terfilter: perintah.filter(p => ...)` — binding yang menyaring daftar berdasarkan isi kolom (tanpa membedakan huruf besar-kecil); dihitung ulang tiap `input.text` berubah. `p => ...` adalah fungsi panah JavaScript.
- `visible: false` — palet tersembunyi sampai `buka()` dipanggil; item tak terlihat tidak bisa memegang fokus.
- `function buka()` — mencatat item yang sedang fokus (`Window.activeFocusItem`), mengosongkan kolom, lalu menampilkan dan memfokuskan `input`.
- `function tutup()` — menyembunyikan dan **mengembalikan fokus** ke item sebelumnya (6.3.6).
- `FocusScope` sebagai akar — palet mengelola fokusnya sendiri tanpa bentrok.
- `Keys.onDownPressed` / `onUpPressed` — menggeser sorotan; `Keys.onEscapePressed` menutup; `onAccepted` (Enter) menutup lalu menjalankan aksi terpilih. Menutup *sebelum* menjalankan aksi memastikan fokus sudah kembali bila aksinya membuka sesuatu.
- `Repeater { model: root.terfilter }` dengan `required property var modelData` — satu baris per hasil; `modelData.nama` adalah teks yang tampil.

### 3. Akord dengan `Shortcut` atau dengan buffer sendiri

```qml
// Opsi 1 — Shortcut: deklaratif, hingga empat langkah, ada sinyal ambigu
Shortcut { sequence: 'Ctrl+K,Ctrl+C'; onActivated: komentari() }

// Opsi 2 — buffer + Timer (6.3.7 butir 1): fleksibel, tanpa modifier, batas waktu sendiri
// Opsi 3 — StateMachine (6.1.5): tiap langkah akord adalah state; perpindahan yang tak sah ditolak
```

### Hal yang perlu diperhatikan

- **Aksi merusak butuh konfirmasi atau undo.** Pola seperti `dd` (hapus baris) aman bila ada undo; tanpanya, jangan.
- **Tampilkan mode dan buffer** (seperti baris status Vim) agar pengguna tahu keadaan.
- **Tombol modal harus punya pelarian jelas** (Esc selalu kembali ke mode normal).
- **Jangan menelan tombol yang dibutuhkan fungsi lain** (Tab, Esc untuk dialog, tombol aksesibilitas): terima hanya yang Anda tangani.
- **Sediakan alternatif non-modal** untuk pengguna yang tidak terbiasa dengan gaya Vim.

**Referensi bagian ini:** [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [Shortcut](https://doc.qt.io/qt-6/qml-qtquick-shortcut.html) · [Timer](https://doc.qt.io/qt-6/qml-qtqml-timer.html) · [FocusScope](https://doc.qt.io/qt-6/qml-qtquick-focusscope.html) · [Window (attached activeFocusItem)](https://doc.qt.io/qt-6/qml-qtquick-window.html)

## 6.3.8 \[TAMBAHAN\] Handler lain dan Handler vs `MouseArea`

*Alasan penambahan:* daftar kurikulum hanya menyebut `DragHandler`, `PinchHandler`, `WheelHandler`. Handler lain dan cara memilih antara handler dan `MouseArea` sering menentukan apakah interaksi Anda berjalan mulus di mouse, sentuh, dan pena.

### `HoverHandler`: melayang di atas item

```qml
Rectangle {
    id: sel
    width: 100; height: 40
    color: hover.hovered ? '#dbeafe' : '#f1f5f9'

    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: console.log('klik') }
}
```

- `HoverHandler` — melaporkan `hovered` (benar selama pointer melayang di atas item induknya) dan dapat mengubah bentuk kursor lewat `cursorShape`.
- **Hover tidak ada pada sentuhan dan tidak ada untuk keyboard.** Karena itu jangan menyembunyikan fungsi di balik hover; padanannya bagi keyboard adalah fokus.

### `PointHandler`: melacak titik pointer

```qml
Item {
    anchors.fill: parent
    PointHandler { id: titik }
    Rectangle {
        visible: titik.active
        x: titik.point.position.x - 10; y: titik.point.position.y - 10
        width: 20; height: 20; radius: 10; color: 'tomato'
    }
}
```

`PointHandler` melaporkan satu titik sentuh atau pointer (`point.position`, `active`), berguna untuk penanda, penunjuk laser, atau alat gambar.

### `TapHandler` lebih dalam (sudah diverifikasi pada dokumentasi Qt)

- `gesturePolicy` — syarat ruang bagi sebuah ketukan:
  - `TapHandler.DragThreshold` (bawaan): titik tidak boleh bergeser jauh; memakai grab **pasif**, sehingga tidak mengganggu handler atau item lain. Cocok bila Anda menambahkan `TapHandler` untuk mengubah perilaku kontrol yang sudah ada.
  - `TapHandler.WithinBounds`: ketukan dibatalkan bila titik meninggalkan batas item.
  - `TapHandler.ReleaseWithinBounds`: ketukan hanya sah bila dilepas di dalam batas item; ini perilaku tombol sungguhan (menekan lalu menggeser keluar membatalkan klik). Memakai grab eksklusif saat ditekan.
- `longPressThreshold` — lama tekan (detik) untuk memicu `longPressed()`.
- `tapCount`, `onSingleTapped`, `onDoubleTapped` — ketukan ganda; `exclusiveSignals` (Qt 6.5 ke atas) mengatur apakah tunggal dan ganda saling menyingkirkan.
- `acceptedButtons` — tombol mouse yang diterima (`Qt.LeftButton` bawaan; `Qt.RightButton` untuk klik kanan).
- `acceptedModifiers` — modifier yang harus ditekan (misalnya `Qt.ControlModifier`).
- `acceptedDevices` — jenis perangkat (mouse, stylus, layar sentuh).
- **Bila item induknya nonaktif, handler ikut nonaktif secara efektif,** walau `enabled`-nya sendiri masih `true`. Ini yang membuat tombol `enabled: false` tak bereaksi pada ketukan (5.1.7 dan 6.1).

```qml
Rectangle {
    TapHandler { onTapped: console.log('klik kiri') }
    TapHandler { acceptedButtons: Qt.RightButton; onTapped: console.log('klik kanan') }
    TapHandler { acceptedModifiers: Qt.ControlModifier; onTapped: console.log('Ctrl+klik') }
    TapHandler { onLongPressed: console.log('tekan lama') }
    TapHandler { onDoubleTapped: console.log('klik ganda') }
}
```

Peningkatan untuk `AppButton`: ganti `TapHandler { ... }` dengan `TapHandler { gesturePolicy: TapHandler.ReleaseWithinBounds; ... }` agar menekan lalu menggeser keluar membatalkan klik, seperti tombol asli.

### Handler vs `MouseArea`

```
                         Input Handler                    MouseArea
 ----------------------  -------------------------------  ----------------------------------
 Sifat                   objek nonvisual pada item induk  Item tak terlihat yang menutup area
 Jumlah per item         banyak, hidup berdampingan       satu per area (bertumpuk bila banyak)
 Perangkat               mouse, sentuh, pena, touchpad    terutama mouse (sentuh disintesis)
 Multi-sentuh            ya (PinchHandler, DragHandler)   tidak
 Grab                    pasif atau eksklusif             eksklusif
 Hover dan kursor        HoverHandler, cursorShape        hoverEnabled, containsMouse
 Kode lama / contoh      lebih baru (Qt 5.12 ke atas)     sangat umum, tetap sah
```

Untuk kode baru, pilih handler. `MouseArea` tetap berguna untuk kode lama dan kasus sederhana.

### Opsi lain untuk satu interaksi (klik)

```qml
// Opsi 1 — TapHandler (modern, berdampingan dengan handler lain)
TapHandler { onTapped: aksi() }

// Opsi 2 — MouseArea (lama)
MouseArea { anchors.fill: parent; onClicked: aksi() }

// Opsi 3 — komponen Qt Quick Controls (Button, ItemDelegate): sentuh, mouse, keyboard, aksesibilitas ditangani
Button { text: 'Aksi'; onClicked: aksi() }
```

**Referensi bagian ini:** [TapHandler](https://doc.qt.io/qt-6/qml-qtquick-taphandler.html) · [HoverHandler](https://doc.qt.io/qt-6/qml-qtquick-hoverhandler.html) · [PointHandler](https://doc.qt.io/qt-6/qml-qtquick-pointhandler.html) · [PointerHandler](https://doc.qt.io/qt-6/qml-qtquick-pointerhandler.html) · [MouseArea](https://doc.qt.io/qt-6/qml-qtquick-mousearea.html) · [Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html)

## Terminologi Esensial

- **Input Handler** — objek nonvisual yang menafsirkan peristiwa pointer untuk item induknya (`TapHandler`, `DragHandler`, `PinchHandler`, `WheelHandler`, `HoverHandler`, `PointHandler`).
- **Grab pasif / eksklusif** — pasif: handler mengintip peristiwa tanpa mengganggu penerima lain; eksklusif: handler mengambil alih selama gestur.
- **`DragHandler.target`** — item yang digeser; bawaannya induk handler; `target: null` menjadikannya detektor murni.
- **Sumbu (`xAxis`, `yAxis`)** — kelompok properti (`enabled`, `minimum`, `maximum`) yang membatasi geseran per sumbu.
- **Gestur multi-sentuh** — gestur yang membutuhkan dua titik sentuh atau lebih (cubit).
- **`Flickable`** — jendela pandang yang dapat digeser dengan momentum atas konten yang lebih besar.
- **Viewport / `contentItem`** — area yang terlihat / item penampung konten di dalam `Flickable`.
- **Fokus aktif (`activeFocus`)** — status item yang saat ini menerima peristiwa keyboard.
- **`focus`** — permintaan fokus di dalam lingkup fokus sebuah item.
- **Lingkup fokus / `FocusScope`** — batas yang memberi sebuah subpohon “panggung” fokus sendiri.
- **`forceActiveFocus()`** — memindahkan fokus aktif ke sebuah item beserta seluruh lingkup leluhurnya.
- **Rantai Tab** — urutan item yang dijangkau dengan Tab.
- **`focusPolicy`** — cara item menerima fokus (`NoFocus`, `TabFocus`, `ClickFocus`, `StrongFocus`, `WheelFocus`); pada `Item` sejak Qt 6.7.
- **`visualFocus`** — pada kontrol Qt Quick Controls: fokus aktif dari keyboard, untuk menggambar cincin fokus.
- **Alasan fokus (focus reason)** — penyebab perpindahan fokus (Tab, mouse, pintasan, dst.).
- **`KeyNavigation`** — attached property yang memindahkan fokus ke item lain saat tombol arah atau Tab ditekan.
- **`Keys`** — attached property penangan tombol; `KeyEvent` membawa `key`, `text`, `modifiers`, `accepted`.
- **Perambatan peristiwa (propagation)** — peristiwa yang tidak diterima diteruskan ke induk.
- **`Keys.priority`** — apakah handler `Keys` berjalan sebelum (`BeforeItem`) atau sesudah (`AfterItem`) penanganan item sendiri.
- **`Keys.forwardTo`** — meneruskan peristiwa tombol ke `Keys` milik item lain.
- **`Shortcut`** — pintasan keyboard tingkat jendela atau aplikasi; `context` menentukan cakupannya.
- **Akord (chord)** — urutan hingga empat penekanan tombol sebagai satu pintasan (`Ctrl+K,Ctrl+C`).
- **`StandardKey`** — pintasan baku platform (`StandardKey.Save`, `Quit`, `ZoomIn`).
- **Roving focus** — satu perhentian Tab untuk kelompok kontrol, dengan panah memindahkan pilihan di dalamnya.
- **Jebakan fokus (keyboard trap)** — keadaan di mana fokus tak bisa keluar dari sebuah area dengan keyboard.
- **Mode modal** — gaya kendali di mana arti tombol bergantung pada mode (normal, sisip).
- **Palet perintah** — antarmuka pencarian aksi dengan keyboard.

## Hubungan dengan Modul Lain

- **Prasyarat:** Modul 4.4 (`TapHandler`), Modul 5.1.6 (fokus, keyboard, dan aksesibilitas pada komponen), Modul 5.2 (urutan Tab mengikuti urutan deklarasi), Modul 6.1 (state fokus, state mode), dan Modul 6.2 (animasi pelepasan `DragHandler`, animasi `contentY`).
- **Menuju Modul 6.4 (Qt Quick ekstra):** `Settings` menyimpan pemetaan tombol dan preferensi; `Dialogs` membawa persoalan fokus dialog bawaan; `Shapes` dan `Canvas` sering digabung dengan handler untuk menggambar interaktif.
- **Ke fase berikutnya:** `ListView` dan `GridView` (subkelas `Flickable`) memakai fokus dan `KeyNavigation` secara intensif; Qt Quick Controls menyediakan `visualFocus`, `focusPolicy`, dan perilaku keyboard yang sudah standar.
- **Ke jalur C++:** padanan C++ adalah `QKeyEvent`, `QEvent::ShortcutOverride`, dan filter peristiwa (`installEventFilter`), dengan konsep yang sama.

## Kesalahan Umum dan Solusi

1. **Fokus hilang karena beberapa item mengklaimnya.** *Sebab:* dua item dalam lingkup yang sama sama-sama `focus: true`; yang terakhir menang. *Solusi:* satu `focus: true` per lingkup, dan gunakan `FocusScope` untuk komponen yang dipakai ulang.
2. **Persegi atau item tidak terjangkau dengan Tab.** *Sebab:* tidak ada `activeFocusOnTab: true` (atau `focusPolicy` yang sesuai). *Solusi:* tambahkan, dan pastikan ada indikator fokus.
3. **`Keys` atau `KeyNavigation` tak bereaksi.** *Sebab:* item tidak memegang fokus aktif, atau tombol sudah diterima item di atasnya. *Solusi:* pantau `onActiveFocusItemChanged`; periksa `event.accepted` dan `priority`.
4. **Tombol yang berguna bagi induk ikut ditelan.** *Sebab:* handler menerima semua tombol (`event.accepted = true` tanpa syarat). *Solusi:* terima hanya yang Anda tangani; tombol lain dibiarkan merambat.
5. **`Shortcut` bentrok antar-konteks atau dengan WM.** *Sebab:* urutan yang sama didefinisikan dua kali, atau dicegat WM tiling. *Solusi:* kelola konteks (`WindowShortcut` vs `ApplicationShortcut`), pakai `activatedAmbiguously`, hindari `Meta+` dan hati-hati dengan `Alt+`.
6. **Antarmuka hanya bisa dipakai dengan pointer.** *Solusi:* daftar periksa 6.3.6 dan uji tanpa mouse.
7. **Konten di dalam `Flickable` salah ukuran.** *Sebab:* memakai `anchors.fill: parent` (padahal `parent` adalah `contentItem`) atau lupa `contentWidth`/`contentHeight`. *Solusi:* beri lebar eksplisit dari id `Flickable` dan setel ukuran konten.
8. **`DragHandler` membuat item keluar dari area.** *Sebab:* tanpa batas sumbu. *Solusi:* `xAxis` dan `yAxis` dengan `minimum`/`maximum`.
9. **`PinchHandler` tak bereaksi.** *Sebab:* diuji dengan mouse biasa. *Solusi:* uji dengan layar sentuh atau perangkat yang mengirim gestur pinch.
10. **Fokus tidak kembali setelah dialog ditutup.** *Solusi:* simpan pembuka dan panggil `forceActiveFocus()` padanya saat menutup.
11. **Memfokuskan item yang tak terlihat atau nonaktif.** *Akibat:* tak berpengaruh. *Solusi:* tampilkan dan aktifkan dulu, lalu fokuskan.
12. **Aksi merusak pada satu tombol tanpa konfirmasi atau undo.** *Solusi:* konfirmasi, fokus awal pada aksi aman, atau undo.
13. **Mengandalkan hover untuk fungsi penting.** *Akibat:* tak bisa diakses sentuhan dan keyboard. *Solusi:* sediakan jalur fokus dan ketuk.
14. **`TapHandler` mengganggu `Flickable`.** *Sebab:* kebijakan gestur eksklusif yang tidak perlu. *Solusi:* pertahankan `DragThreshold` (grab pasif) kecuali butuh `ReleaseWithinBounds`.

## Tips dan Praktik Terbaik

- **Rancang jalur keyboard sejak awal,** bukan sebagai tambalan akhir.
- **Satu komponen, satu `FocusScope`** bila ia punya bagian dalam yang dapat difokuskan.
- **Selalu ada indikator fokus** yang berkontras cukup (5.3.7), dan bila memakai kontrol Qt Quick Controls, gunakan `visualFocus`.
- **Pantau fokus saat debug:** `onActiveFocusItemChanged: console.log(activeFocusItem)`.
- **Gunakan `Keys` untuk perilaku yang bergantung fokus, `Shortcut` untuk aksi aplikasi.**
- **Tampilkan pintasan** kepada pengguna dengan `nativeText`.
- **Fokus awal pada aksi yang aman** di dialog yang berisiko.
- **Kembalikan fokus ke pembuka** saat menutup dialog atau palet.
- **Pilih handler, bukan `MouseArea`, untuk kode baru;** pakai `ReleaseWithinBounds` untuk perilaku tombol.
- **Jangan menelan Tab dan Esc** kecuali untuk tujuan yang jelas dan dengan pelarian yang jelas.
- **Uji tanpa mouse, uji pada window manager tiling,** dan uji dengan pembaca layar bila memungkinkan.
- **Untuk aksi berbahaya,** tambah satu langkah niat yang jelas (konfirmasi, tahan tombol, undo).

## Latihan 15 Menit (versi diperbaiki)

*Perbaikan dari audit:* kurikulum menyuruh “menambahkan item ketiga dan membuat urutan Tab/panah yang lengkap tanpa menyentuh mouse”. Di sini tujuannya dirumuskan sebagai hal yang dapat diuji.

1. Mulai dari contoh 6.3.4 (dua persegi `a` dan `b`).
2. Tambahkan persegi ketiga `c`.
3. Pastikan: **Tab** bergerak a → b → c, **Shift+Tab** sebaliknya, **panah kiri/kanan** berputar (c ke kanan menuju a; a ke kiri menuju c), dan **Enter atau Spasi** memicu aksi persegi yang fokus.
4. Beri indikator fokus yang tak hanya bergantung warna.
5. Tambahkan log fokus di `Window` dan pintasan `Ctrl+Q`.
6. Uji tanpa menyentuh mouse sama sekali.

**Kunci jawaban** (coba dulu sebelum membaca):

```qml
import QtQuick

Window {
    id: win
    width: 360; height: 240; visible: true
    title: 'Navigasi keyboard'

    onActiveFocusItemChanged: console.log('fokus ->', activeFocusItem)

    Shortcut { sequence: 'Ctrl+Q'; onActivated: Qt.quit() }

    Row {
        x: 20; y: 100; spacing: 8

        component Kotak: Rectangle {
            id: kotak
            required property string nama
            signal dipilih(string teks)

            width: 80; height: 40; radius: 6
            color: activeFocus ? '#fde68a' : '#e5e7eb'
            border.width: activeFocus ? 2 : 0
            border.color: '#92400e'
            activeFocusOnTab: true

            Text { anchors.centerIn: parent; text: kotak.nama }

            Keys.onReturnPressed: kotak.dipilih(kotak.nama)
            Keys.onSpacePressed:  kotak.dipilih(kotak.nama)

            TapHandler {
                onTapped: { kotak.forceActiveFocus(Qt.MouseFocusReason); kotak.dipilih(kotak.nama) }
            }
        }

        Kotak {
            id: a; nama: 'Satu'; focus: true
            KeyNavigation.right: b; KeyNavigation.left: c
            onDipilih: (teks) => console.log('dipilih', teks)
        }
        Kotak {
            id: b; nama: 'Dua'
            KeyNavigation.right: c; KeyNavigation.left: a
            onDipilih: (teks) => console.log('dipilih', teks)
        }
        Kotak {
            id: c; nama: 'Tiga'
            KeyNavigation.right: a; KeyNavigation.left: b
            onDipilih: (teks) => console.log('dipilih', teks)
        }
    }
}
```

- `component Kotak: Rectangle { ... }` — komponen inline (5.1.7 Opsi D) agar tiga persegi memakai definisi yang sama: `activeFocusOnTab`, indikator fokus, `Keys`, dan `TapHandler` ditulis sekali.
- `focus: true` hanya pada `a` — hanya satu pemegang fokus awal.
- `KeyNavigation.right` / `left` saling menunjuk membentuk lingkaran: dari `c` ke kanan kembali ke `a`, dari `a` ke kiri ke `c` (perputaran).
- Tab dan Shift+Tab mengikuti urutan deklarasi (a, b, c) karena ketiganya `activeFocusOnTab: true`; bila ingin urutan lain, tambahkan `KeyNavigation.tab`/`backtab`.
- Indikator fokus ganda: warna latar **dan** garis tepi; cincin tetap terbaca walau warna tak dibedakan.
- Penanda log: setiap perpindahan fokus tercetak sebagai `fokus -> Kotak...`, dan setiap Enter atau Spasi mencetak `dipilih <nama>`.
- Yang akan Anda amati: dari awal, fokus berada di `a`; panah dan Tab bergerak seperti diharapkan; klik mouse juga memindahkan fokus karena `TapHandler` memanggil `forceActiveFocus`.

**Tantangan opsional:** ubah baris itu menjadi satu perhentian Tab dengan panah di dalamnya, memakai pola `BilahPilihan` di 6.3.6, lalu bandingkan jumlah penekanan Tab yang dibutuhkan untuk melewati bilah.

## Cek Pemahaman dan Kunci

1. **Apa fungsi `FocusScope` dalam komponen yang dipakai ulang?** *Kunci:* ia membuat lingkup fokus sendiri sehingga fokus di dalam komponen tidak berebut dengan komponen lain yang sama-sama memakai `focus: true`, dan pemakai dapat memfokuskan komponen utuh tanpa mengenal item di dalamnya.
2. **Apa beda `focus` dan `activeFocus`?** *Kunci:* `focus` adalah permintaan fokus di dalam lingkup; `activeFocus` benar hanya bila item memegang fokus dan seluruh lingkup di atasnya juga, serta jendela aktif.
3. **Mengapa dua item dengan `focus: true` dalam lingkup yang sama bermasalah?** *Kunci:* hanya satu item per lingkup yang boleh memegang fokus; yang terakhir meminta merebutnya dan yang lain kehilangan.
4. **Apa yang terjadi bila sebuah handler `Keys.onPressed` tidak menyetel `event.accepted`?** *Kunci:* peristiwa dapat merambat ke induk dan ditangani di sana; pada handler umum, setel `accepted = true` hanya untuk tombol yang benar-benar Anda tangani.
5. **Kapan memakai `Qt.ApplicationShortcut` dan kapan `Qt.WindowShortcut`?** *Kunci:* `WindowShortcut` (bawaan) aktif bila jendela induknya aktif; `ApplicationShortcut` aktif bila salah satu jendela aplikasi aktif, cocok untuk aksi seperti keluar.
6. **Mengapa `Rectangle` pada contoh kurikulum tidak bisa dijangkau dengan Tab?** *Kunci:* `Rectangle` tidak masuk rantai Tab tanpa `activeFocusOnTab: true`; `KeyNavigation` hanya bekerja setelah salah satu item memegang fokus.
7. **Mengapa fokus awal di dialog hapus sebaiknya pada Batal?** *Kunci:* agar penekanan Enter yang refleks tidak langsung menjalankan aksi merusak.

## Referensi Tambahan

- [Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html)
- [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html)
- [Shortcut](https://doc.qt.io/qt-6/qml-qtquick-shortcut.html)
- [TapHandler](https://doc.qt.io/qt-6/qml-qtquick-taphandler.html)
- [Flickable](https://doc.qt.io/qt-6/qml-qtquick-flickable.html)
- [Accessibility for Qt Quick Applications](https://doc.qt.io/qt-6/qtquick-accessibility.html)
- [WCAG 2.1 — Keyboard Accessible (Guideline 2.1)](https://www.w3.org/WAI/WCAG21/Understanding/keyboard-accessible.html)
- [Qt — Arch Wiki (variabel lingkungan dan platform)](https://wiki.archlinux.org/title/Qt)

---

*Kendali penuh atas keyboard adalah kendali penuh atas mesin Anda.*

# Fase 6 · Modul 6.4 — Qt Quick Ekstra

*Kurikulum Qt 6 QML · Fase 6 (Interaksi, State, dan Animasi) · Modul 4 dari 4 (6.1 → 6.2 → 6.3 → 6.4)*

## Daftar Isi Modul 6.4

- Audit singkat Modul 6.4 dan daftar yang diperbarui
- Gambaran, peran dalam kurikulum, dan filosofi
- 6.4.1 `Shapes`
- 6.4.2 `MultiEffect`
- 6.4.3 `Particles`
- 6.4.4 `Dialogs`
- 6.4.5 `Settings` dan `LocalStorage`
- 6.4.6 `Canvas` dan opsi baru Qt 6.12 (`Canvas2D`)
- 6.4.7 \[TAMBAHAN\] Memilih alat, biaya, dan batas keamanan
- Terminologi esensial
- Hubungan dengan modul lain
- Kesalahan umum dan solusi
- Tips dan praktik terbaik
- Latihan 15 menit (versi diperbaiki) dan kunci
- Cek pemahaman dan kunci
- Rangkuman Fase 6
- Referensi tambahan

## Audit Singkat Modul 6.4 (sebelum materi dimulai)

Modul 6.4 sengaja berbeda dari tiga modul sebelumnya: ia bukan satu gagasan, melainkan *inventaris peralatan*. Urutannya wajar (gambar → efek → partikel → dialog → penyimpanan → menggambar imperatif). Fakta pada bagian yang rawan berubah (Qt 6.12, `Settings`, dialog native) sudah saya periksa pada dokumentasi dan blog resmi Qt. Temuan:

1. **\[Terverifikasi\] Qt Canvas Painter dan Canvas2D.** Kurikulum menulis “Qt 6.12 menambah Qt Canvas Painter yang dipercepat GPU”. Lebih tepat: API C++ `QCanvasPainter` sudah tidak lagi technology preview di Qt 6.12, sedangkan elemen QML-nya, **`Canvas2D`** (modul `QtCanvas2D`, sejak Qt 6.12), **masih technology preview**: API-nya dapat berubah dan belum ada jaminan kompatibilitas sumber atau biner. Ia menggambar di GPU lewat QRhi, dan API-nya hampir kompatibel dengan `Canvas` Qt Quick (cukup impor `QtCanvas2D` dan ganti nama tipe). Dijelaskan di 6.4.6.
2. **\[Koreksi\] Contoh `MultiEffect`.** `MultiEffect { source: gambar; anchors.fill: gambar }` tanpa menyembunyikan sumbernya menggambar item *dua kali* (sumber dan hasil efek). Dokumentasi menyarankan `visible: false` pada sumber (tak digambar dan tak menerima input) atau `opacity: 0` (tak terlihat tetapi tetap menerima input), atau memakai `layer.effect`. Dijelaskan di 6.4.2.
3. **\[Koreksi\] Potongan `Settings`.** Contoh kurikulum tak menyebut `import QtCore`, dan lokasi penyimpanan baru jelas bila nama aplikasi, organisasi, dan domain diatur (atau `location` diisi). Juga: `Qt.labs.settings` **deprecated sejak Qt 6.5**; pakai `Settings` dari `QtCore`. Dua instans `Settings` tidak saling menyinkronkan nilai. Dijelaskan di 6.4.5.
4. **\[Tambahan, penting untuk keamanan\] `LocalStorage`.** Dokumentasi menyatakan database-nya khusus pengguna dan khusus QML, **tetapi dapat diakses semua aplikasi QML** milik pengguna itu. Ia bukan penyimpanan privat per aplikasi dan bukan tempat rahasia. Dijelaskan di 6.4.5.
5. **\[Terverifikasi\] `Dialogs`.** `FileDialog` native hanya tersedia di Android, iOS, macOS, Windows, dan **Linux bila memakai platform theme GTK+**; selain itu Qt memakai dialog cadangan buatan Qt Quick yang berupa *item di dalam scene*, bukan jendela tingkat atas. Akibatnya di window manager tiling dialog tampil di dalam jendela aplikasi dan butuh ruang. Dijelaskan di 6.4.4.
6. **\[Terverifikasi\] `Shapes`.** `Shape.CurveRenderer` (Qt 6.6 ke atas, diminta lewat `preferredRendererType`) memberi anti-aliasing berkualitas tinggi tanpa biaya multisampling; renderer bawaan (`GeometryRenderer`) melakukan triangulasi di CPU dan menghitung ulang bila geometri berubah; dokumentasi menyarankan satu `Shape` dengan banyak `ShapePath`, bukan banyak `Shape`. `containsMode` berguna bersama Input Handler. Di 6.4.1.
7. **\[Tambahan\] `Particles` dan `Dialogs` tak punya contoh minimal di kurikulum.** Ditambahkan, bersama pertimbangan biaya dan gerak berkurang (6.2.7).
8. **\[Klarifikasi\] Latihan.** “Simpan warna isi dengan `Settings`” diperjelas: butuh `import QtCore`, lokasi berkas yang pasti (agar tak bergantung pada nama organisasi), dan cara memeriksa isi berkas.
9. **\[Tambahan\] 6.4.7.** Panduan memilih alat dan batas keamanan penyimpanan, plus alat lain yang tidak dibahas (`ShaderEffect`, Qt Quick Effect Maker).

**Daftar Modul 6.4 yang diperbarui** (tanda \[+\] = tambahan hasil audit):

- 6.4.1 `Shapes`
- 6.4.2 `MultiEffect`
- 6.4.3 `Particles`
- 6.4.4 `Dialogs`
- 6.4.5 `Settings` dan `LocalStorage`
- 6.4.6 `Canvas` dan opsi baru Qt 6.12 (`Canvas2D`)
- &#91;+\] 6.4.7 Memilih alat, biaya, dan batas keamanan

**Asumsi prasyarat.** Modul 6.2 (animasi dan biaya animasi), Modul 6.3 (handler dan fokus), Modul 5.3 (`Theme`, singleton), dan Modul 4.4 (`TapHandler`). Beberapa contoh memakai Qt Quick Controls (style Basic) hanya sebagai pembungkus.

## Gambaran, Peran, dan Filosofi

### Deskripsi konkret

Modul ini memperkenalkan modul tambahan yang sering dibutuhkan proyek nyata: menggambar bentuk vektor (`Shapes`), efek gambar (`MultiEffect`), partikel (`Particles`), dialog (`Dialogs`), penyimpanan preferensi dan data (`Settings`, `LocalStorage`), dan menggambar imperatif 2D (`Canvas`, dan `Canvas2D` yang baru).

### Peran dalam kurikulum

Qt Quick inti memberi bahan dasar. Modul ini adalah gudang peralatan khusus: tujuannya bukan menghafal semuanya, melainkan **tahu apa yang tersedia** agar Anda tidak menulis ulang dari nol dan tahu *biayanya*. Ia juga menutup Fase 6 (interaksi, state, animasi) dengan hal-hal yang membuat aplikasi terasa utuh: ingat preferensi, tampil bagus, dan bicara kepada pengguna lewat dialog.

### Konsep kunci dan filosofi

- **Pilih alat paling murah yang cukup.** Bentuk vektor tidak butuh `Canvas`; bayangan sederhana tidak butuh partikel; preferensi tidak butuh database.
- **Kenali apa yang ada, lalu ukur biayanya.** Efek, partikel, dan gambar imperatif memakai GPU dan baterai; setiap kemudahan punya harga.
- **Penyimpanan adalah soal kepercayaan.** `Settings` dan `LocalStorage` menulis ke disk *tanpa enkripsi*, dan `LocalStorage` terbuka bagi semua aplikasi QML milik pengguna. Perlakukan keduanya sebagai tempat data yang tak rahasia.
- **Dialog adalah batas kepercayaan.** Nama berkas yang dipilih pengguna masuk ke aplikasi Anda sebagai masukan; validasi, jangan percaya.
- **Fitur baru (technology preview) berarti bisa berubah.** Pakai dengan sadar, isolasi, dan siapkan jalan mundur.

Peta kebutuhan → alat (ASCII):

```
 Bentuk vektor, ikon, grafik sederhana ........ Shapes  (atau Image + SVG)
 Blur, bayangan, warna, mask .................. MultiEffect
 Percikan, asap, api (dekoratif) .............. Particles
 Memilih berkas / folder / warna, pesan ....... Dialogs
 Preferensi (kunci-nilai) ..................... Settings (QtCore)
 Data tabular kecil, dapat dikueri ............ LocalStorage (SQLite)
 Menggambar imperatif 2D ...................... Canvas ; Canvas2D (Qt 6.12, preview)
```

## 6.4.1 `Shapes`

### Dasar: vektor yang digambar GPU

`QtQuick.Shapes` menggambar **bentuk vektor** (garis, kurva, isian, gradien) dari sebuah *path* (lintasan). Berbeda dari `Canvas`, path **tidak pernah dirasterisasi di perangkat lunak**, sehingga tidak ada biaya mengunggah tekstur untuk area luas (dokumentasi Qt). Komponennya:

- `Shape` — wadah (sebuah `Item`).
- `ShapePath` — satu bentuk: gaya garis dan isian, ditambah elemen path.
- Elemen path yang didukung `Shape`: `PathMove`, `PathLine`, `PathQuad`, `PathCubic`, `PathArc`, `PathText`, dan `PathSvg` (data path SVG).

### Sintaks dan properti penting

```
Shape {
    width: ...; height: ...
    preferredRendererType: Shape.CurveRenderer   // opsional (Qt 6.6 ke atas)
    ShapePath {
        strokeColor / strokeWidth                // garis tepi
        fillColor  atau  fillGradient: LinearGradient { ... }   // isian
        strokeStyle: ShapePath.SolidLine | ShapePath.DashLine ; dashPattern: [ ... ]
        fillRule: ShapePath.OddEvenFill | ShapePath.WindingFill
        joinStyle ; capStyle
        startX: ... ; startY: ...                // titik awal
        PathLine { x: ...; y: ... }              // elemen path berurutan
    }
}
```

### Contoh inti (dari kurikulum)

```qml
import QtQuick
import QtQuick.Shapes

Shape {
    width: 120; height: 120
    ShapePath {
        strokeColor: 'white'; strokeWidth: 3; fillColor: 'royalblue'
        startX: 10; startY: 110
        PathLine { x: 60; y: 10 }
        PathLine { x: 110; y: 110 }
        PathLine { x: 10; y: 110 }
    }
}
```

### Bedah kode (kata demi kata)

- `import QtQuick.Shapes` — modul terpisah dari `QtQuick`; tanpa ini `Shape` tidak dikenal.
- `Shape { width: 120; height: 120 }` — area yang ditempati bentuk. Secara bawaan bentuk digambar pada ukuran aslinya, tak peduli ukuran item (`fillMode: Shape.NoResize`).
- `ShapePath { ... }` — satu bentuk di dalam `Shape`.
- `strokeColor: 'white'; strokeWidth: 3` — garis tepi putih setebal 3 piksel.
- `fillColor: 'royalblue'` — isian biru kerajaan.
- `startX: 10; startY: 110` — titik awal lintasan (kiri bawah).
- `PathLine { x: 60; y: 10 }` — garis lurus ke puncak; dua `PathLine` berikutnya ke kanan bawah dan kembali ke titik awal. Setiap elemen berlanjut dari akhir elemen sebelumnya.
- Hasilnya segitiga biru berbingkai putih. Kembali ke `(10, 110)` menutup lintasan secara visual.

### Contoh lebih kaya: gradien, putus-putus, busur, dan kurva halus

```qml
import QtQuick
import QtQuick.Shapes

Shape {
    width: 200; height: 160
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeWidth: 3
        strokeColor: '#1e3a8a'
        fillGradient: LinearGradient {
            x1: 0; y1: 0; x2: 200; y2: 150
            GradientStop { position: 0; color: '#60a5fa' }
            GradientStop { position: 1; color: '#2563eb' }
        }
        startX: 20; startY: 120
        PathLine { x: 100; y: 20 }
        PathLine { x: 180; y: 120 }
        PathLine { x: 20; y: 120 }
    }

    ShapePath {
        strokeWidth: 2
        strokeColor: 'tomato'
        fillColor: 'transparent'
        strokeStyle: ShapePath.DashLine
        dashPattern: [4, 3]
        startX: 20; startY: 145
        PathArc { x: 180; y: 145; radiusX: 100; radiusY: 30 }
    }
}
```

- `preferredRendererType: Shape.CurveRenderer` — meminta renderer berbasis kurva (Qt 6.6 ke atas). Dokumentasi menyatakannya memberi anti-aliasing berkualitas tinggi **tanpa** biaya multisampling dan tanpa triangulasi ulang saat di-zoom; catatan: ia mendekati kurva kubik dengan kurva kuadratik sehingga dapat sedikit berbeda dari bentuk matematis yang tepat. Bila renderer tidak didukung backend, Qt memakai renderer bawaan.
- `fillGradient: LinearGradient { x1; y1; x2; y2; GradientStop ... }` — isian gradien linear dari titik (x1, y1) ke (x2, y2) dengan titik-titik warna `GradientStop` (`position` 0 sampai 1).
- `strokeStyle: ShapePath.DashLine` dan `dashPattern: [4, 3]` — garis putus-putus: 4 satuan garis, 3 kosong (satuan mengikuti lebar garis).
- `PathArc { x; y; radiusX; radiusY }` — busur elips dari posisi sekarang ke `(x, y)`.

### Menerima ketukan hanya di dalam bentuk

```qml
Shape {
    containsMode: Shape.FillContains
    // ... ShapePath segitiga ...
    TapHandler { onTapped: console.log('di dalam segitiga') }
}
```

Secara bawaan `contains()` sebuah `Shape` hanya memeriksa kotak pembatasnya (`Shape.BoundingRectContains`, paling murah). `Shape.FillContains` memeriksa apakah titik berada di dalam isian bentuk, sehingga handler hanya bereaksi pada bentuk sebenarnya. Dokumentasi mengingatkan: makin kompleks dan banyak `ShapePath`, makin mahal pemeriksaannya.

### Opsi lain untuk menggambar bentuk

```qml
// Opsi 1 — Shape + ShapePath + PathLine (di atas): deklaratif, GPU, dapat dianimasikan

// Opsi 2 — PathSvg: data path SVG sebagai satu string (ringkas, mudah disalin dari editor vektor)
Shape {
    ShapePath {
        fillColor: 'royalblue'
        PathSvg { path: 'M10 110 L60 10 L110 110 Z' }
    }
}

// Opsi 3 — Image dengan berkas SVG (butuh dukungan SVG pada Qt; paket qt6-svg di Arch)
Image { source: 'ikon.svg'; sourceSize: Qt.size(64, 64) }

// Opsi 4 — Canvas / Canvas2D (6.4.6): imperatif; bila bentuk dihitung per frame lewat kode
```

### Biaya dan praktik

- **Satu `Shape` dengan banyak `ShapePath`**, bukan banyak `Shape`: dokumentasi menyarankannya.
- **Perubahan elemen path memicu triangulasi ulang** pada renderer bawaan; menganimasikan geometri bentuk rumit berat bagi sistem lemah. `CurveRenderer` menghindari triangulasi ulang saat zoom.
- **`asynchronous: true`** memindahkan pemrosesan path ke thread pekerja agar thread GUI tak tertahan saat bentuk dibuat.
- **`fillMode`** (Qt 6.7 ke atas: `Shape.Stretch`, `PreserveAspectFit`, `PreserveAspectCrop`) menskalakan bentuk mengikuti ukuran item, cocok dengan `PathSvg`.
- **Anti-aliasing alternatif:** `layer.enabled: true; layer.samples: 4` (multisampling) bila tak memakai `CurveRenderer`; lebih berat.

**Referensi bagian ini:** [Qt Quick Shapes](https://doc.qt.io/qt-6/qtquick-shapes-qmlmodule.html) · [Shape](https://doc.qt.io/qt-6/qml-qtquick-shapes-shape.html) · [ShapePath](https://doc.qt.io/qt-6/qml-qtquick-shapes-shapepath.html) · [Path](https://doc.qt.io/qt-6/qml-qtquick-path.html) · [PathSvg](https://doc.qt.io/qt-6/qml-qtquick-pathsvg.html) · [PathArc](https://doc.qt.io/qt-6/qml-qtquick-patharc.html)

## 6.4.2 `MultiEffect`

### Dasar: efek pasca-proses pada sebuah item

`MultiEffect` (modul `QtQuick.Effects`, Qt 6.5 ke atas) adalah pengganti Qt Graphical Effects dari Qt 5: ia menerapkan **efek pasca-proses** pada sebuah item *sumber* dan menggabungkan banyak efek (blur, bayangan, kolorisasi, mask, kecerahan, kontras, saturasi) dalam satu item dan satu shader, sehingga lebih efisien untuk beberapa efek sekaligus.

Poin yang paling sering terlewat (dokumentasi Qt): **`MultiEffect` menggambar item *baru* di samping sumbernya.** Bila sumber dan efeknya sama-sama tampak, keduanya digambar.

```
  sumber (Image / Rectangle / ...)          MultiEffect
       |                                        |
       |  visible: false  -> sumber tak digambar, tak menerima input
       |  opacity: 0      -> sumber tak tampak, TETAP menerima input
       v                                        v
  hanya hasil efek yang terlihat   <----  digambar di posisi yang sama (anchors.fill: sumber)
```

### Sintaks dan efek yang tersedia

```
MultiEffect {
    source: <item>               // sumber
    anchors.fill: <item>         // letakkan di posisi sumber
    brightness / contrast / saturation          // selalu aktif, tanpa biaya tambahan
    colorization ; colorizationColor            // warna isian di atas sumber
    blurEnabled: true ; blur: 0..1 ; blurMax ; blurMultiplier
    shadowEnabled: true ; shadowBlur ; shadowColor ; shadowOpacity ;
    shadowHorizontalOffset ; shadowVerticalOffset ; shadowScale
    maskEnabled: true ; maskSource ; maskInverted ; maskThresholdMin/Max ; maskSpreadAtMin/Max
    autoPaddingEnabled ; paddingRect
}
```

### Contoh inti: kartu dengan bayangan

```qml
import QtQuick
import QtQuick.Effects

Window {
    width: 320; height: 220; visible: true; color: '#e2e8f0'

    Rectangle {
        id: kartu
        x: 50; y: 50; width: 220; height: 100; radius: 12; color: 'white'
        visible: false                  // sumber disembunyikan; hasil efek yang tampil

        Text { anchors.centerIn: parent; text: 'Kartu'; font.pixelSize: 20 }
    }

    MultiEffect {
        source: kartu
        anchors.fill: kartu
        shadowEnabled: true
        shadowColor: '#000000'
        shadowOpacity: 0.35
        shadowBlur: 0.8
        shadowVerticalOffset: 6
        shadowHorizontalOffset: 0
    }
}
```

### Bedah kode (kata demi kata)

- `import QtQuick.Effects` — modul efek (Qt 6.5 ke atas).
- `Rectangle { id: kartu; visible: false }` — sumber efek. `visible: false` menyembunyikannya; teks anaknya tetap ikut menjadi bagian tekstur sumber yang diolah efek.
- `MultiEffect { source: kartu; anchors.fill: kartu }` — item efek di posisi dan ukuran kartu.
- `shadowEnabled: true` — menyalakan efek bayangan; efek lain yang berat (`blur`, `mask`) juga harus dinyalakan eksplisit.
- `shadowColor`, `shadowOpacity: 0.35` — warna dan kepekatan bayangan.
- `shadowBlur: 0.8` — kehalusan tepi bayangan dari 0 (tajam) sampai 1 (sangat halus).
- `shadowVerticalOffset: 6` — bayangan bergeser 6 piksel ke bawah, memberi kesan kartu terangkat.
- **Padding otomatis:** `autoPaddingEnabled` (bawaan `true`) menambah ruang di sekeliling item bila blur atau bayangan aktif agar tak terpotong.
- **Mengapa `visible: false` bermasalah bila kartu perlu diketuk:** item tak terlihat tidak menerima input. Gunakan `opacity: 0` pada sumber, atau letakkan `TapHandler` pada `MultiEffect`.

### Contoh blur dan bentuk lapisan (`layer.effect`)

```qml
// Blur pada gambar: perhatikan 'blurMax' dan 'blur'
Image {
    id: foto
    source: 'foto.jpg'          // ganti dengan berkas Anda
    visible: false
}
MultiEffect {
    source: foto
    anchors.fill: foto
    blurEnabled: true
    blur: 0.6
    blurMax: 32
}

// Bentuk lapisan: efek langsung pada item, tanpa item sumber terpisah
Rectangle {
    width: 80; height: 80; color: 'tomato'
    layer.enabled: true
    layer.effect: MultiEffect { saturation: -1.0 }       // jadi monokrom
}
```

- `blurEnabled: true; blur: 0.6; blurMax: 32` — menyalakan blur; `blur` dari 0 (tak ada) sampai 1 (penuh); `blurMax` adalah radius piksel maksimum yang dicapai saat `blur` bernilai 1.
- `layer.enabled: true; layer.effect: MultiEffect { ... }` — bentuk ringkas: item dirender ke lapisan, lalu efek langsung diterapkan; Anda tidak perlu `source` dan `anchors.fill`.
- `saturation: -1.0` — menghilangkan warna sepenuhnya (monokrom); nilai 0 berarti tak berubah.

### Biaya dan praktik (dari dokumentasi Qt)

- **Blur dan bayangan adalah efek terberat.** Nyalakan hanya efek yang benar-benar dipakai (`blurEnabled`, `shadowEnabled`, `maskEnabled`).
- **Ukuran item sekecil mungkin;** lebih banyak piksel berarti lebih banyak kerja GPU. Saat memburamkan seluruh latar, setel `autoPaddingEnabled: false`, bila tidak efek “tumbuh” keluar jendela.
- **Utamakan `blurMultiplier` ketimbang `blurMax`** untuk radius lebih besar; tidak menambah jumlah pembacaan tekstur.
- **Jangan mengubah `blurEnabled`, `shadowEnabled`, atau `maskEnabled` saat animasi:** mengubahnya mengganti shader. Animasikan `blur`, `shadowOpacity`, dan sejenisnya sebagai gantinya.
- **Hindari sumber yang beranimasi** agar blur tak perlu dibuat ulang tiap frame.
- **Setel `visible: false` pada `MultiEffect` yang sedang tak dipakai** agar efek tak digambar di latar belakang.
- Untuk berbagi satu sumber di banyak efek, memakai sebagian sumber, atau menurunkan resolusi, gabungkan dengan `ShaderEffectSource` (`sourceRect`, `textureSize`).
- Efek yang tidak ada di `MultiEffect`: **Qt Quick Effect Maker** atau `ShaderEffect` untuk shader kustom (di luar cakupan modul ini).

### Opsi lain untuk bayangan dan blur

```qml
// Opsi 1 — MultiEffect (di atas): satu item, banyak efek; modern
// Opsi 2 — bayangan tipuan murah: Rectangle semi-transparan bergeser di belakang kartu
Rectangle { x: kartu.x; y: kartu.y + 4; width: kartu.width; height: kartu.height; radius: 12; color: '#33000000' }
// Opsi 3 — ShaderEffect + shader kustom: kendali penuh, butuh pengetahuan shader
// Opsi 4 — Qt Graphical Effects (Qt 5): digantikan MultiEffect; hindari pada kode baru
```

Opsi 2 sering cukup untuk bayangan statis dan tidak menambah biaya shader.

**Referensi bagian ini:** [MultiEffect](https://doc.qt.io/qt-6/qml-qtquick-effects-multieffect.html) · [Qt Quick Effects](https://doc.qt.io/qt-6/qtquick-effects-qmlmodule.html) · [ShaderEffectSource](https://doc.qt.io/qt-6/qml-qtquick-shadereffectsource.html) · [Item layers (layer.enabled, layer.effect)](https://doc.qt.io/qt-6/qml-qtquick-item.html)

## 6.4.3 `Particles`

### Dasar: banyak objek kecil yang lahir, bergerak, dan mati

Sistem partikel menghasilkan efek seperti percikan, asap, api, salju, atau konfeti dengan menjalankan *banyak* objek kecil yang masing-masing lahir, bergerak sesuai aturan, lalu menghilang. Modulnya `QtQuick.Particles`. Strukturnya terbagi tiga peran yang saling menunjuk satu `ParticleSystem`:

```
 ParticleSystem            jam dan koordinator seluruh sistem (running, paused)
   |-- Emitter             MELAHIRKAN partikel: laju, umur, ukuran, kecepatan awal
   |-- Affector            MEMENGARUHI partikel yang hidup: Gravity, Turbulence, Friction, Age, ...
   '-- Painter             MENGGAMBAR partikel: ImageParticle (dari gambar), ItemParticle (dari item)

 Semua menunjuk sistem yang sama dengan  system: <id>.
 'group' memisahkan kelompok partikel (misalnya api dan asap) dalam satu sistem.
```

### Properti `Emitter` yang sering dipakai

- `emitRate` — partikel per detik. `lifeSpan` — umur partikel dalam milidetik (`lifeSpanVariation` untuk variasi acak).
- `size`, `endSize`, `sizeVariation` — ukuran awal, ukuran akhir, dan variasinya.
- `velocity` — kecepatan awal sebagai arah: `AngleDirection { angle; angleVariation; magnitude; magnitudeVariation }` (sudut dalam derajat: 0 ke kanan, 90 ke bawah, -90 ke atas) atau `PointDirection` atau `TargetDirection`.
- `shape` — area kelahiran (`EllipseShape`, `RectangleShape`, `LineShape`, `MaskShape`).
- `enabled`, serta metode `burst(count)` (ledakan sekali) dan `pulse(durasi)`.

### Contoh inti: air mancur

```qml
import QtQuick
import QtQuick.Particles

Window {
    id: win
    width: 360; height: 300; visible: true; color: '#0f172a'

    property bool kurangiGerak: false

    ParticleSystem {
        id: sistem
        running: win.visible && !win.kurangiGerak
    }

    Emitter {
        system: sistem
        x: 175; y: 260
        width: 10; height: 4
        emitRate: 80
        lifeSpan: 1600
        lifeSpanVariation: 300
        size: 8
        sizeVariation: 4
        velocity: AngleDirection {
            angle: -90; angleVariation: 25
            magnitude: 160; magnitudeVariation: 40
        }
    }

    Gravity {
        system: sistem
        angle: 90
        magnitude: 220
    }

    ItemParticle {
        system: sistem
        delegate: Rectangle { width: 6; height: 6; radius: 3; color: 'gold' }
    }
}
```

### Bedah kode (kata demi kata)

- `import QtQuick.Particles` — modul partikel (terpisah dari `QtQuick`).
- `ParticleSystem { id: sistem; running: ... }` — koordinator. `running` diikat ke visibilitas jendela dan ke saklar `kurangiGerak`, sehingga sistem berhenti saat tak terlihat atau saat pengguna meminta gerak dikurangi (6.2.7).
- `Emitter { system: sistem ... }` — sumber partikel. `x`, `y`, `width`, `height` mendefinisikan *area kelahiran*: lebar 10 dan tinggi 4 di dekat dasar jendela.
- `emitRate: 80` dan `lifeSpan: 1600` — 80 partikel per detik, masing-masing hidup sekitar 1,6 detik; jumlah yang hidup serentak kira-kira laju × umur = sekitar 128. **Ini angka yang menentukan biaya** (lihat di bawah).
- `velocity: AngleDirection { angle: -90; ... }` — meluncur ke atas (-90 derajat) dengan sebaran sudut 25 derajat dan kelajuan sekitar 160 (±40).
- `Gravity { system: sistem; angle: 90; magnitude: 220 }` — *affector* yang menarik partikel ke bawah (90 derajat) sehingga lintasannya melengkung seperti air mancur.
- `ItemParticle { delegate: Rectangle {...} }` — painter yang membuat satu **item QML** per partikel (di sini titik emas kecil). Mudah, tidak butuh berkas gambar, tetapi relatif berat bila partikelnya banyak.

### Ledakan sekali pakai

```qml
Emitter {
    id: ledakan
    system: sistem
    enabled: false                 // tidak memancar terus-menerus
    lifeSpan: 800
    size: 6
    velocity: AngleDirection { angleVariation: 360; magnitude: 140; magnitudeVariation: 60 }
}

TapHandler {
    onTapped: (eventPoint) => {
        ledakan.x = eventPoint.position.x
        ledakan.y = eventPoint.position.y
        ledakan.burst(30)
    }
}
```

- `enabled: false` — emitter tak memancar sendiri.
- `angleVariation: 360` — sebaran ke segala arah.
- `ledakan.burst(30)` — memancarkan 30 partikel sekaligus di posisi ketukan.

### Opsi lain untuk painter dan efek

```qml
// Opsi 1 — ItemParticle (di atas): paling sederhana; satu item per partikel; berat bila banyak

// Opsi 2 — ImageParticle: menggambar dari satu gambar secara terkelompok; jauh lebih hemat
ImageParticle {
    system: sistem
    source: 'qrc:///particleresources/glowdot.png'    // gambar contoh bawaan modul; bila tak ditemukan, pakai gambar Anda
    color: '#fbbf24'; colorVariation: 0.2
}

// Opsi 3 — AnimatedSprite / SpriteSequence: animasi berbasis kerangka gambar, tanpa simulasi fisika
// Opsi 4 — MultiEffect atau ShaderEffect: efek cahaya statis yang jauh lebih murah dari partikel
```

### Biaya dan praktik

- **Jumlah partikel hidup = `emitRate` × `lifeSpan` / 1000.** Mulailah kecil dan naikkan sambil mengukur (6.2.7).
- **Gunakan `ImageParticle`** untuk jumlah besar; `ItemParticle` hanya untuk puluhan.
- **Hentikan sistem saat tak terlihat:** `ParticleSystem.running` (atau `paused`) terikat ke visibilitas.
- **Efek dekoratif:** hormati saklar “kurangi gerakan” dan jangan menjadikannya satu-satunya cara menyampaikan informasi.
- **Hindari banyak `ParticleSystem` terpisah;** satu sistem dengan beberapa `group` lebih hemat.

**Referensi bagian ini:** [Qt Quick Particles](https://doc.qt.io/qt-6/qtquick-particles-qmlmodule.html) · [Using the Qt Quick Particle System](https://doc.qt.io/qt-6/qtquick-particles-qmlmodule.html) · [Emitter](https://doc.qt.io/qt-6/qml-qtquick-particles-emitter.html) · [ParticleSystem](https://doc.qt.io/qt-6/qml-qtquick-particles-particlesystem.html) · [Gravity](https://doc.qt.io/qt-6/qml-qtquick-particles-gravity.html) · [ItemParticle](https://doc.qt.io/qt-6/qml-qtquick-particles-itemparticle.html) · [ImageParticle](https://doc.qt.io/qt-6/qml-qtquick-particles-imageparticle.html)

## 6.4.4 `Dialogs`

### Dasar: dialog sistem dengan cadangan buatan Qt

Modul `QtQuick.Dialogs` menyediakan dialog standar: `FileDialog` (Qt 6.2), `FontDialog` (6.2), `FolderDialog` (6.3), `MessageDialog` (6.3), dan `ColorDialog` (6.4). Rancangannya: pakai dialog **native** bila platform punya, dan bila tidak, jatuh kembali ke dialog buatan Qt Quick.

Fakta yang sudah diverifikasi pada dokumentasi dan blog Qt:

- **`FileDialog` native** tersedia di Android, iOS, macOS, Windows, dan **Linux hanya bila platform theme GTK+ dipakai**.
- Menurut artikel Qt tentang modul ini (periksa dokumentasi versi Anda untuk keadaan terkini): `FontDialog` dan `ColorDialog` native di macOS dan GTK; `MessageDialog` native hanya di iOS dan Android.
- **Dialog cadangan** berbasis Qt Quick Controls (tampil mengikuti style yang dipakai) dan **berupa item di dalam scene, bukan jendela tingkat atas.**
- Opsi `FileDialog.DontUseNativeDialog` memaksa dialog non-native.

Implikasinya bagi pengguna window manager tiling: tanpa platform theme GTK, dialog akan muncul **sebagai lapisan di dalam jendela aplikasi** (bukan jendela terpisah), sehingga membutuhkan ruang yang cukup di jendela induk.

### Contoh inti

```qml
import QtCore
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Dialogs

ApplicationWindow {
    width: 480; height: 320; visible: true
    title: 'Dialog'

    header: ToolBar {
        Row {
            spacing: 8
            Button { text: 'Pilih gambar'; onClicked: fileDialog.open() }
            Button { text: 'Hapus...';     onClicked: konfirmasi.open() }
        }
    }

    Image {
        id: gambar
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    FileDialog {
        id: fileDialog
        title: 'Pilih gambar'
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        nameFilters: ['Gambar (*.png *.jpg *.jpeg)', 'Semua berkas (*)']
        onAccepted: gambar.source = selectedFile
    }

    MessageDialog {
        id: konfirmasi
        title: 'Hapus gambar'
        text: 'Hapus gambar ini?'
        informativeText: 'Tindakan ini tidak dapat dibatalkan.'
        buttons: MessageDialog.Ok | MessageDialog.Cancel
        onAccepted: gambar.source = ''
    }
}
```

### Bedah kode (kata demi kata)

- `import QtCore` — untuk `StandardPaths` (lokasi baku seperti folder Gambar). `import QtQuick.Dialogs` — modul dialog.
- `ApplicationWindow { header: ToolBar { ... } }` — jendela Qt Quick Controls dengan bilah atas; dipakai agar dialog cadangan punya induk yang tepat.
- `FileDialog { id: fileDialog }` — dialog dibuat sekali dan dibuka dengan `open()`; ia tidak muncul sendiri.
- `currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]` — folder awal: lokasi Gambar pertama dari daftar lokasi standar.
- `nameFilters: [...]` — daftar filter berkas, setiap entri berformat “deskripsi (pola)”; catatan dokumentasi: `*.*` bukan filter yang portabel, pakai `*`.
- `onAccepted: gambar.source = selectedFile` — saat pengguna menerima, `selectedFile` (bertipe `url`) dipakai. **Nilai akhir dibaca di `accepted`**: `selectedFile` ikut berubah saat pengguna memilih di tengah dialog.
- `fileMode` (tidak ditulis, bawaannya `FileDialog.OpenFile`) dapat diganti `OpenFiles` (banyak berkas, hasil di `selectedFiles`) atau `SaveFile` (berkas tak harus ada).
- `MessageDialog { text; informativeText; buttons }` — `buttons` memakai bendera standar yang digabung dengan `|`; `onAccepted` untuk tombol penerima (Ok), `onRejected` untuk penolak.

### Dialog lain dan opsi lainnya

```qml
FolderDialog { id: folder; onAccepted: console.log('folder:', selectedFolder) }
ColorDialog  { id: warna;  selectedColor: 'tomato'; onAccepted: kotak.color = selectedColor }
FontDialog   { id: huruf;  onAccepted: teks.font = selectedFont }
```

Nama properti hasil (`selectedFolder`, `selectedColor`, `selectedFont`) mengikuti pola `selectedFile`; periksa dokumentasi versi Anda untuk rincian.

```qml
// Opsi 1 — Qt Quick Dialogs: native bila tersedia, cadangan Qt bila tidak (di atas)
// Opsi 2 — Dialog dari Qt Quick Controls: selalu non-native, di dalam scene, dapat dikustomisasi penuh
Dialog { modal: true; standardButtons: Dialog.Ok | Dialog.Cancel; title: 'Judul'; onAccepted: aksi() }
// Opsi 3 — dialog buatan sendiri dengan FocusScope (6.3.6 Pola 2): kendali keyboard dan fokus penuh
// Opsi 4 — memaksa tampilan seragam: FileDialog { options: FileDialog.DontUseNativeDialog }
```

### Linux, GTK, dan tiling WM

Untuk mendapat dialog berkas native di Linux, Qt perlu platform theme GTK:

```bash
# periksa apakah qt6-base menyebut plugin GTK sebagai dependensi opsional
pacman -Qi qt6-base | grep -i -A3 'optional'

# bila terpasang, jalankan dengan platform theme GTK
QT_QPA_PLATFORMTHEME=gtk3 qml6 Main.qml
```

Nama paket yang dibutuhkan bergantung pada distribusi dan versi; verifikasi dengan `pacman -Qi qt6-base` dan Arch Wiki (bagian Qt). Tanpa itu dialog cadangan Qt dipakai.

### Hal yang perlu diperhatikan (termasuk keamanan)

- **Jangan mengasumsikan dialog native.** Rancang agar dialog cadangan (di dalam scene) juga muat dan terbaca di jendela kecil.
- **Perlakukan hasil pemilihan sebagai masukan tak tepercaya.** `selectedFile` adalah URL; periksa skema (`file:`), jangan memercayai ekstensi sebagai jenis berkas, dan ubah ke path lokal dengan hati-hati (di C++: `QUrl::toLocalFile()`). Secara bawaan dialog menyelesaikan symlink; opsi `FileDialog.DontResolveSymlinks` mengubahnya.
- **Aksi merusak butuh konfirmasi** dengan fokus awal pada aksi aman (6.3.6).
- **Periksa ke mana fokus kembali** setelah dialog tertutup dan, bila perlu, kembalikan sendiri ke elemen pembuka (6.3.6).

**Referensi bagian ini:** [Qt Quick Dialogs](https://doc.qt.io/qt-6/qtquickdialogs-index.html) · [FileDialog](https://doc.qt.io/qt-6/qml-qtquick-dialogs-filedialog.html) · [MessageDialog](https://doc.qt.io/qt-6/qml-qtquick-dialogs-messagedialog.html) · [FolderDialog](https://doc.qt.io/qt-6/qml-qtquick-dialogs-folderdialog.html) · [ColorDialog](https://doc.qt.io/qt-6/qml-qtquick-dialogs-colordialog.html) · [StandardPaths](https://doc.qt.io/qt-6/qml-qtcore-standardpaths.html) · [Dialogs in Qt Quick (blog Qt)](https://www.qt.io/blog/dialogs-in-qt-quick)

## 6.4.5 `Settings` dan `LocalStorage`

### Dasar: dua cara menyimpan yang berbeda

- **`Settings`** — penyimpanan *kunci-nilai* untuk preferensi (tema, ukuran huruf, posisi jendela). Cepat, ringkas, otomatis.
- **`LocalStorage`** — database **SQLite** kecil untuk data *tabular yang dapat dikueri* (catatan, riwayat).

Keduanya menulis ke disk tanpa enkripsi dan keduanya bukan tempat rahasia.

### `Settings` (modul `QtCore`, Qt 6.5 ke atas)

Fakta dari dokumentasi Qt: tipe ini mewarisi `QtObject`; nilai individual dinyatakan sebagai **properti** di dalam elemen `Settings`; hanya tipe nilai yang dikenali `QSettings` yang didukung; implementasinya berbasis `QSettings`. Pendekatan yang direkomendasikan memakai **property alias** agar pembaruan berjalan dua arah otomatis, dengan harga bahwa nilai disimpan **setiap kali nilai alias berubah**. Properti biasa memberi kendali lebih rinci (misalnya menyimpan saat komponen dihancurkan).

- `category: string` — mengelompokkan kunci (menghindari bentrok nama kunci).
- `location: url` — jalur berkas pengaturan; dibuat bila belum ada; bila kosong, format bawaan `QSettings` dipakai, selain itu format INI.
- Metode: `setValue(key, nilai)`, `value(key, nilaiBawaan)`, `sync()` (menulis perubahan yang belum tersimpan dan memuat ulang perubahan oleh aplikasi lain).
- **Identitas aplikasi:** pengaturan dikenali lewat nama aplikasi, organisasi, dan domain, **atau** lewat `location`.
- **Dua instans `Settings` tidak saling menyinkronkan nilai,** walau menunjuk kunci dan kategori yang sama.
- **`Qt.labs.settings` sudah deprecated sejak Qt 6.5**; jangan dipakai pada kode baru.

### Contoh inti: menyimpan pilihan warna

```qml
import QtCore
import QtQuick
import QtQuick.Shapes

Window {
    id: win
    width: 240; height: 220; visible: true
    title: 'Segitiga tersimpan'

    readonly property var palet: ['royalblue', 'tomato', 'seagreen', 'orchid']

    Settings {
        id: pref
        category: 'segitiga'
        location: 'file:///tmp/uji-pengaturan.ini'
        property int indeks: 0
    }

    Item {
        anchors.fill: parent
        TapHandler { onTapped: pref.indeks = (pref.indeks + 1) % win.palet.length }

        Shape {
            anchors.centerIn: parent
            width: 120; height: 120
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: 'white'; strokeWidth: 3
                fillColor: win.palet[pref.indeks]
                startX: 10; startY: 110
                PathLine { x: 60; y: 10 }
                PathLine { x: 110; y: 110 }
                PathLine { x: 10; y: 110 }
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `import QtCore` — sumber tipe `Settings` (Qt 6.5 ke atas). Potongan kurikulum tidak menyebutnya.
- `Settings { category: 'segitiga'; location: 'file:///tmp/uji-pengaturan.ini' }` — `location` menentukan berkas secara eksplisit sehingga contoh tidak bergantung pada nama organisasi dan aplikasi. Format `file:///` adalah bentuk URL berkas lokal.
- `property int indeks: 0` — sebuah pengaturan bernama `indeks` dengan nilai bawaan 0. Nilai bawaan dipakai bila belum ada nilai tersimpan.
- `TapHandler { onTapped: pref.indeks = (pref.indeks + 1) % win.palet.length }` — setiap ketukan menggeser indeks warna secara melingkar (`%` adalah sisa bagi). Karena `indeks` adalah properti `Settings`, perubahannya disimpan.
- `fillColor: win.palet[pref.indeks]` — warna isian diambil dari palet berdasarkan indeks tersimpan.
- Alasan memakai **indeks bilangan bulat**, bukan objek warna: hanya tipe yang dikenali `QSettings` yang didukung, dan bilangan bulat aman di semua platform.

Uji:

```bash
qml6 Main.qml          # ketuk beberapa kali, tutup, lalu jalankan lagi: warna yang sama pulih
cat /tmp/uji-pengaturan.ini
```

Isi berkas (INI) akan memuat bagian `[segitiga]` dengan kunci `indeks`.

### Untuk proyek CMake: identitas aplikasi di `main.cpp`

```cpp
QGuiApplication app(argc, argv);
app.setOrganizationName("Latihan");
app.setOrganizationDomain("latihan.example");
app.setApplicationName("HelloQt");
```

Tanpa `location`, ketiganya menentukan di mana `QSettings` menaruh berkas (di Linux umumnya di bawah `~/.config`). Panggil sebelum membuat engine QML.

### Singleton pengaturan dan penutup lingkaran dengan `Theme`

Qt sendiri menunjukkan pola menjadikan `Settings` sebuah **singleton** yang tersedia di semua berkas QML (contoh To Do List), dengan `QT_QML_SINGLETON_TYPE` pada berkasnya, sama seperti `Theme.qml` di Modul 5.3:

```qml
// AppSettings.qml (daftarkan sebagai singleton di CMake)
pragma Singleton
import QtCore
import QtQuick

Settings {
    category: 'ui'
    property int modeTema: 0              // 0 ikuti sistem, 1 terang, 2 gelap
    property bool kurangiGerak: false
}
```

```qml
// di Theme.qml (Modul 5.3): ikat ke pengaturan tersimpan
property int mode: AppSettings.modeTema
property bool reduceMotion: AppSettings.kurangiGerak
```

Dengan ini pilihan tema dan “kurangi gerakan” bertahan antar-sesi.

### Opsi lain untuk menyimpan preferensi

```qml
// Opsi 1 — property alias: otomatis dua arah; menyimpan tiap perubahan (disarankan)
Settings { property alias lebar: win.width }

// Opsi 2 — properti biasa + simpan saat dihancurkan: kendali lebih rinci
Settings { id: s; property string state: 'active' }
Component.onDestruction: s.state = page.state

// Opsi 3 — setValue / value: kunci dinamis
Settings { id: s }   // s.setValue('tema', 'gelap') ; s.value('tema', 'terang')

// Opsi 4 — berkas JSON buatan sendiri lewat C++ (kendali format, enkripsi, migrasi)
```

### `LocalStorage`: SQLite untuk data tabular

Fakta dari dokumentasi Qt: ia adalah **tipe singleton** untuk membaca dan menulis database SQLite (`import QtQuick.LocalStorage`). Database-nya **khusus pengguna dan khusus QML, tetapi dapat diakses semua aplikasi QML**, disimpan di subdirektori `Databases` pada `QQmlEngine::offlineStoragePath()`. API-nya mengikuti API *sinkron* HTML5 Web Database. Koneksi ditutup otomatis saat garbage collection JavaScript.

```qml
import QtQuick
import QtQuick.LocalStorage

Window {
    id: win
    width: 320; height: 260; visible: true
    title: 'Catatan'

    property var catatan: []

    function db() {
        return LocalStorage.openDatabaseSync('CatatanLatihan', '', 'Catatan kecil', 1000000)
    }

    function muat() {
        const hasil = []
        db().readTransaction(function (tx) {
            const r = tx.executeSql('SELECT id, isi FROM catatan ORDER BY id DESC')
            for (let i = 0; i < r.rows.length; i++)
                hasil.push(r.rows.item(i))
        })
        win.catatan = hasil
    }

    function tambah(isi) {
        db().transaction(function (tx) {
            tx.executeSql('INSERT INTO catatan (isi) VALUES (?)', [isi])
        })
        muat()
    }

    Component.onCompleted: {
        db().transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS catatan (id INTEGER PRIMARY KEY AUTOINCREMENT, isi TEXT)')
        })
        muat()
    }

    Column {
        x: 12; y: 12; spacing: 6; width: parent.width - 24

        Rectangle {
            width: parent.width; height: 28; radius: 4; border.color: '#94a3b8'
            TextInput {
                anchors.fill: parent; anchors.margins: 4
                focus: true
                onAccepted: { if (text.length > 0) { win.tambah(text); text = '' } }
            }
        }

        Repeater {
            model: win.catatan
            Text {
                required property var modelData
                text: modelData.isi
            }
        }
    }
}
```

### Bedah kode (kata demi kata)

- `LocalStorage.openDatabaseSync(nama, versi, deskripsi, perkiraanUkuran)` — membuka atau membuat database. Versi `''` menerima versi apa pun; `1000000` adalah perkiraan ukuran dalam byte.
- `db().transaction(function (tx) { ... })` — transaksi baca-tulis; bila fungsi melempar pengecualian, transaksi **dibatalkan** (rollback).
- `db().readTransaction(...)` — transaksi hanya-baca untuk `SELECT`.
- `tx.executeSql('INSERT ... VALUES (?)', [isi])` — pernyataan SQL dengan **penampung `?`** dan daftar nilai terpisah. Ini kueri berparameter: nilai tidak pernah ditempelkan ke teks SQL, sehingga kebal dari *SQL injection*.
- `r.rows.length` dan `r.rows.item(i)` — hasil kueri: jumlah baris dan baris ke-i (objek dengan kolom sebagai properti).
- `CREATE TABLE IF NOT EXISTS` — membuat tabel hanya bila belum ada, sehingga aman dijalankan tiap aplikasi dibuka.
- `win.catatan = hasil` — menetapkan larik baru ke properti `var`; `Repeater` menggambar ulang daftar.

### Keamanan dan batas `LocalStorage` dan `Settings`

- **`LocalStorage` terbuka bagi aplikasi QML lain milik pengguna yang sama.** Ia bukan penyimpanan privat per aplikasi: aplikasi QML lain dapat membuka database dengan nama yang sama.
- **Tak ada enkripsi yang dijanjikan** pada keduanya (dokumentasi tidak menyebutnya). Anggap isinya tersimpan sebagai teks atau SQLite biasa.
- **Jangan menyimpan rahasia** (kata sandi, token, kunci). Untuk itu pakai brankas kunci sistem (misalnya `libsecret` lewat pustaka dari C++) alih-alih berkas.
- **Selalu gunakan kueri berparameter (`?`)**; jangan menyusun SQL dengan menggabungkan string masukan pengguna.
- **API-nya sinkron:** operasi besar menahan thread GUI. Untuk data besar atau akses jarang, pindahkan ke C++ (`QtSql`) di thread pekerja.
- **Lokasi file:** cari dengan `find ~/.local/share -path '*OfflineStorage*' 2>/dev/null` untuk mengetahui tempat database di mesin Anda.

### Memilih penyimpanan

```
 Preferensi kecil (kunci-nilai)?                          --> Settings
 Data tabular yang dikueri, ukuran kecil, tidak rahasia?  --> LocalStorage (SQLite)
 Data besar, relasi kompleks, kinerja, atau enkripsi?     --> QtSql / pustaka C++ / file terenkripsi
 Rahasia (kata sandi, token)?                             --> brankas kunci sistem; bukan keduanya
```

**Referensi bagian ini:** [Settings (QtCore)](https://doc.qt.io/qt-6/qml-qtcore-settings.html) · [QSettings](https://doc.qt.io/qt-6/qsettings.html) · [Qt Quick Local Storage](https://doc.qt.io/qt-6/qtquick-localstorage-qmlmodule.html) · [StandardPaths](https://doc.qt.io/qt-6/qml-qtcore-standardpaths.html) · [QQmlEngine::offlineStoragePath](https://doc.qt.io/qt-6/qqmlengine.html) · [Qt SQL](https://doc.qt.io/qt-6/qtsql-index.html) · [OWASP: SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)

## 6.4.6 `Canvas` dan opsi baru Qt 6.12 (`Canvas2D`)

### Dasar: menggambar secara imperatif

Berbeda dari `Shapes` yang *deklaratif* (Anda menyatakan bentuknya), `Canvas` bersifat *imperatif*: Anda menulis kode JavaScript yang memberi perintah menggambar satu per satu pada sebuah *context* (kuas), seperti `<canvas>` di HTML. Cocok untuk gambar yang dihitung lewat algoritma: grafik, pengukur (gauge), visualisasi, atau kuas gambar bebas.

```
 Shapes  (deklaratif):  "ada segitiga biru di sini"         -> engine yang menggambar & menggambar ulang
 Canvas  (imperatif):   "pindah ke (10,110), garis ke (60,10), isi"  -> Anda yang memerintah kuas
```

### `Canvas` Qt Quick: contoh pengukur melingkar

```qml
import QtQuick

Canvas {
    id: kanvas
    property real nilai: 0.6
    width: 160; height: 160

    onNilaiChanged: requestPaint()

    onPaint: {
        const ctx = getContext('2d')
        ctx.reset()
        ctx.lineWidth = 12
        ctx.lineCap = 'round'

        ctx.strokeStyle = '#e2e8f0'
        ctx.beginPath()
        ctx.arc(width / 2, height / 2, 60, 0.75 * Math.PI, 2.25 * Math.PI)
        ctx.stroke()

        ctx.strokeStyle = '#2563eb'
        ctx.beginPath()
        ctx.arc(width / 2, height / 2, 60, 0.75 * Math.PI, (0.75 + 1.5 * nilai) * Math.PI)
        ctx.stroke()
    }
}
```

### Bedah kode (kata demi kata)

- `property real nilai: 0.6` — data yang digambar (0 sampai 1).
- `onNilaiChanged: requestPaint()` — `Canvas` **tidak menggambar ulang sendiri** saat data berubah; Anda meminta lewat `requestPaint()`. Ini perbedaan mendasar dari `Shapes`.
- `onPaint: { ... }` — dipanggil saat kanvas perlu digambar. Semua kode menggambar ada di sini.
- `getContext('2d')` — mengambil *context* 2D: objek dengan perintah menggambar bergaya HTML5.
- `ctx.reset()` — mengembalikan context ke keadaan awal (membersihkan keadaan gaya sebelumnya).
- `ctx.lineWidth`, `ctx.lineCap = 'round'`, `ctx.strokeStyle` — gaya garis: tebal, ujung membulat, warna.
- `ctx.beginPath()` lalu `ctx.arc(cx, cy, r, sudutAwal, sudutAkhir)` lalu `ctx.stroke()` — membuat lintasan busur dan menggambarnya. Sudut dalam radian; `Math.PI` adalah setengah putaran. Busur pertama (abu muda) adalah jalur penuh; busur kedua (biru) hanya sampai sejauh `nilai`.

### Apa yang terjadi di balik layar (dan mengapa ada peringatan)

Fakta dari dokumentasi dan blog resmi Qt: `Canvas` Qt Quick menggambar dengan **`QPainter` di CPU ke sebuah `QImage`, lalu mengunggahnya sebagai tekstur**. Setiap pembaruan berarti unggah tekstur, sehingga dokumentasi tidak menyarankannya untuk animasi atau kanvas besar. Properti `renderTarget: Canvas.Image` adalah satu-satunya yang efektif (`FramebufferObject` diabaikan sejak Qt 6.0).

### Opsi baru Qt 6.12: `Canvas2D` (technology preview)

Fakta yang sudah diverifikasi:

- **Modul `QtCanvas2D`, tipe `Canvas2D`, sejak Qt 6.12, berstatus technology preview.** API-nya dapat berubah dan belum ada jaminan kompatibilitas sumber atau biner.
- **Menggambar di GPU** lewat Qt Canvas Painter dan QRhi, langsung ke scene graph; bukan lagi CPU → gambar → tekstur.
- **API hampir sepenuhnya kompatibel dengan `Canvas`** Qt Quick: untuk memindahkan kode lama, impor `QtCanvas2D` dan ganti nama tipe `Canvas` menjadi `Canvas2D`.
- **Perbedaan perilaku penting:** menurut Qt, `Canvas2D` secara bawaan menggambar ulang dari awal setiap frame, sehingga **tak perlu memanggil `clearRect()`** di awal `onPaint` seperti pada HTML Canvas dan `Canvas`. Periksa dokumentasi `Canvas2D` untuk cara mengatur kapan `onPaint` dipanggil.
- **`Canvas2DContext` menerapkan API Canvas 2D W3C** yang sudah dikenal pengembang web (`beginPath()`, `moveTo()`, `lineTo()`, `bezierCurveTo()`, `fill()`, `stroke()`, dan seterusnya).
- Sisi C++ (`QCanvasPainter`) sudah **tidak lagi technology preview di Qt 6.12**, sedangkan `Canvas2D` masih.
- Di Arch Linux, paket C++-nya bernama `qt6-canvaspainter`; periksa apakah modul QML `QtCanvas2D` ikut di dalamnya dengan `pacman -Ql qt6-canvaspainter | grep -i canvas2d`.

```qml
// Sebelum (Qt Quick Canvas)
import QtQuick
Canvas { onPaint: { const ctx = getContext('2d'); /* gambar */ } }

// Sesudah (Canvas2D, Qt 6.12, preview)
import QtQuick
import QtCanvas2D
Canvas2D { onPaint: { const ctx = getContext('2d'); /* gambar yang sama */ } }
```

### Memilih: `Shapes`, `Canvas`, atau `Canvas2D`

```
 Bentuk vektor yang dapat dinyatakan sebagai path, perlu interaksi (handler), dianimasikan?  --> Shapes
 Gambar dihitung dengan algoritma, statis atau jarang berubah, proyek stabil?               --> Canvas
 Gambar dinamis/animasi besar (grafik, gauge halus, kuas bebas) dan Anda menerima preview? --> Canvas2D
 Jalur produksi yang harus stabil dan GPU cepat?                                            --> Shapes, atau C++ QCanvasPainter
```

### Hal yang perlu diperhatikan

- **Jangan memakai `Canvas` untuk yang cukup dengan `Shapes`** (segitiga, lingkaran, garis, gradien).
- **`Canvas` tak memberi tahu perubahan data;** Anda wajib memanggil `requestPaint()`.
- **Isi kanvas tidak terbaca teknologi bantu.** Beri `Accessible.name` dan `Accessible.description` pada kanvas (5.1.6) agar pengguna pembaca layar tahu isinya.
- **`Canvas2D` adalah technology preview.** Isolasi pemakaiannya, jangan bergantung padanya di jalur kritis, dan siapkan jalan mundur ke `Canvas` atau `Shapes`.
- **Pakai `Behavior` pada `nilai` dengan hati-hati:** pada `Canvas` setiap frame animasi memicu pengunggahan tekstur.

**Referensi bagian ini:** [Canvas](https://doc.qt.io/qt-6/qml-qtquick-canvas.html) · [Context2D](https://doc.qt.io/qt-6/qml-qtquick-context2d.html) · [Canvas2D (Qt 6.12)](https://doc.qt.io/qt-6/qml-qtcanvas2d-canvas2d.html) · [Qt Canvas Painter](https://doc.qt.io/qt-6/qtcanvaspainter-index.html) · [Blog Qt: Canvas2D, elemen kanvas QML baru](https://www.qt.io/blog/canvas2d-new-qml-canvas-element-using-qt-canvas-painter) · [Paket qt6-canvaspainter (Arch)](https://archlinux.org/packages/extra/x86_64/qt6-canvaspainter/)

## 6.4.7 \[TAMBAHAN\] Memilih alat, biaya, dan batas keamanan

*Alasan penambahan:* modul ini adalah daftar alat; yang paling berharga adalah penilaian tentang kapan *tidak* memakainya. Bagian ini merangkum biaya dan batas kepercayaan.

### Tangga biaya (kasar, dari murah ke mahal)

```
 murah ---------------------------------------------------------------------------> mahal

 Rectangle, Image, Shape statis
   < Shape yang geometrinya beranimasi (triangulasi ulang)
   < MultiEffect: warna, bayangan sederhana
   < MultiEffect: blur, terutama di area luas
   < Particles: banyak partikel (laju x umur besar)
   < Canvas: menggambar ulang tiap frame di CPU, unggah tekstur
```

Urutan ini bersifat umum; ukur di perangkat Anda (6.2.7: `QSG_RENDER_TIMING`, `QSG_VISUALIZE`).

### Batas keamanan

- **Dialog:** hasil pilihan pengguna adalah masukan tak tepercaya (periksa skema, jangan percaya ekstensi, ubah ke path lokal dengan hati-hati).
- **`Settings`:** teks polos; bukan untuk rahasia. Satu pengguna dapat mengubah berkasnya di luar aplikasi: validasi nilai saat dibaca (rentang, tipe) sebelum dipakai.
- **`LocalStorage`:** terbuka bagi aplikasi QML lain milik pengguna yang sama; bukan privat dan tidak terenkripsi. Gunakan kueri berparameter.
- **Partikel dan efek:** hanya dekoratif; jangan menaruh informasi penting di sana, dan hormati saklar gerak berkurang.
- **Fitur preview (`Canvas2D`):** API bisa berubah; jangan menjadikannya dasar fitur yang tak bisa diganti.

### Alat lain yang tidak dibahas di sini

- `ShaderEffect` dan **Qt Quick Effect Maker** — efek shader kustom bila `MultiEffect` tak cukup.
- `AnimatedSprite`, `SpriteSequence`, `AnimatedImage` — animasi berbasis kerangka gambar (6.2.9).
- Modul lain di luar kurikulum ini (grafik 3D, bagan, dsb.); periksa dokumentasi sebelum memutuskan.

## Terminologi Esensial

- **Path (lintasan)** — urutan titik, garis, dan kurva yang mendefinisikan sebuah bentuk.
- **`Shape` / `ShapePath`** — wadah bentuk vektor / satu bentuk dengan gaya garis dan isian.
- **Renderer (`GeometryRenderer`, `CurveRenderer`, `SoftwareRenderer`)** — cara `Shape` digambar: triangulasi (bawaan), kurva asli (Qt 6.6 ke atas), atau perangkat lunak.
- **Triangulasi** — memecah bentuk menjadi segitiga agar GPU dapat menggambarnya.
- **Anti-aliasing** — menghaluskan tepi bergerigi.
- **`MultiEffect`** — item efek pasca-proses gabungan (blur, bayangan, warna, mask).
- **Item sumber (`source`)** — item yang diolah efek; perlu disembunyikan agar tak tergambar dua kali.
- **`layer.enabled` / `layer.effect`** — merender item ke tekstur, lalu menerapkan efek langsung.
- **Padding otomatis** — penambahan ruang di sekeliling item agar blur atau bayangan tak terpotong.
- **Sistem partikel** — gabungan `ParticleSystem`, `Emitter`, affector, dan painter.
- **`Emitter` / affector / painter** — pelahir partikel / pengubah perilaku partikel hidup / penggambar partikel.
- **`ItemParticle` / `ImageParticle`** — painter berbasis item (berat) / berbasis gambar (hemat).
- **Dialog native / cadangan (fallback)** — dialog milik sistem operasi / dialog buatan Qt Quick di dalam scene.
- **`Settings`** — penyimpanan kunci-nilai berbasis `QSettings` (`QtCore`, Qt 6.5 ke atas).
- **`QSettings`** — kelas C++ penyimpan pengaturan; di Linux umumnya berkas INI.
- **`LocalStorage`** — singleton untuk database SQLite lokal, sinkron.
- **SQL injection** — serangan lewat masukan yang disisipkan ke teks SQL; dicegah dengan kueri berparameter.
- **Kueri berparameter** — SQL dengan penampung (`?`) dan nilai terpisah.
- **`Canvas` / `Context2D`** — area gambar imperatif / objek kuasnya.
- **`Canvas2D` / `QtCanvas2D`** — elemen kanvas baru berbasis GPU di Qt 6.12 (technology preview).
- **Technology preview** — fitur yang bisa dipakai tetapi API-nya dapat berubah tanpa jaminan kompatibilitas.

## Hubungan dengan Modul Lain

- **Prasyarat:** Modul 6.2 (biaya animasi dan alat ukur), Modul 6.3 (handler dan fokus: `containsMode`, `TapHandler` pada `Shape`; dialog dan fokus), Modul 5.3 (singleton `Theme`; `AppSettings` memakai pola yang sama), dan Modul 4.4 (`TapHandler`).
- **Mengikat ke fase sebelumnya:** `Settings` menyimpan `Theme.mode` dan `reduceMotion` (5.3 dan 6.2.7); `ParticleSystem.running` mengikuti `reduceMotion`; dialog memakai pola fokus 6.3.6.
- **Ke fase berikutnya:** `Settings` dan `LocalStorage` membuka pintu ke persistensi data dan model data; dialog ke alur pengguna yang lebih besar; ke jalur C++: `QSettings`, `QtSql`, `QCanvasPainter`, dan `QQuickPaintedItem` adalah padanan yang lebih kuat.

## Kesalahan Umum dan Solusi

1. **Memakai `Canvas` untuk yang cukup dengan `Shapes`.** *Akibat:* CPU dan unggah tekstur sia-sia. *Solusi:* `Shape` + `ShapePath`.
2. **Blur pada area besar atau pada sumber yang beranimasi.** *Akibat:* beban GPU tinggi. *Solusi:* kecilkan item, utamakan `blurMultiplier`, hindari sumber beranimasi, matikan `autoPaddingEnabled` saat memburamkan seluruh latar.
3. **Sumber `MultiEffect` tidak disembunyikan.** *Akibat:* item tergambar dua kali. *Solusi:* `visible: false` (atau `opacity: 0` bila perlu input) atau `layer.effect`.
4. **Mengubah `blurEnabled`, `shadowEnabled`, atau `maskEnabled` saat animasi.** *Akibat:* shader berganti, patah. *Solusi:* animasikan `blur` atau `shadowOpacity`.
5. **Banyak `Shape` terpisah.** *Solusi:* satu `Shape` dengan banyak `ShapePath`.
6. **Menganimasikan geometri bentuk rumit pada renderer bawaan.** *Akibat:* triangulasi ulang tiap frame. *Solusi:* `CurveRenderer`, sederhanakan bentuk, atau animasikan transformasi item.
7. **`Settings` tanpa `import QtCore`, atau memakai `Qt.labs.settings`.** *Solusi:* `import QtCore`; `Qt.labs.settings` sudah deprecated sejak 6.5.
8. **Lupa identitas aplikasi.** *Akibat:* berkas pengaturan di tempat tak terduga. *Solusi:* atur nama organisasi, domain, dan aplikasi di `main.cpp`, atau isi `location`.
9. **Mengharapkan dua `Settings` saling menyinkronkan nilai.** *Solusi:* satu sumber (singleton `AppSettings`) dan `sync()` bila perlu.
10. **Menyimpan rahasia di `Settings` atau `LocalStorage`.** *Solusi:* brankas kunci sistem.
11. **Menyusun SQL dengan menggabungkan string.** *Akibat:* SQL injection. *Solusi:* `executeSql(sql, [nilai])` dengan penampung `?`.
12. **Mengira `LocalStorage` privat per aplikasi.** *Fakta:* dapat diakses semua aplikasi QML pengguna.
13. **Mengandalkan dialog native.** *Akibat:* di Linux tanpa platform theme GTK, dialog cadangan tampil di dalam jendela dan bisa terpotong. *Solusi:* rancang untuk cadangan; atur platform theme bila perlu native.
14. **Mempercayai path dari dialog.** *Solusi:* validasi skema, canonicalize, dan batasi akses.
15. **Partikel terlalu banyak atau berjalan saat tak terlihat.** *Solusi:* hitung `emitRate` × `lifeSpan`, gunakan `ImageParticle`, ikat `running` ke visibilitas dan saklar gerak berkurang.
16. **Membaca `selectedFile` sebelum `accepted`.** *Akibat:* nilai sementara. *Solusi:* ambil nilai akhir di `onAccepted`.
17. **Bergantung pada `Canvas2D` (preview) di jalur kritis.** *Solusi:* isolasi dan siapkan cadangan.

## Tips dan Praktik Terbaik

- **Mulai dari alat paling murah** yang memenuhi kebutuhan; naik hanya bila perlu.
- **Ukur sebelum dan sesudah** menambah efek atau partikel (`QSG_RENDER_TIMING`, `QSG_VISUALIZE=overdraw`).
- **Satu `Shape`, banyak `ShapePath`;** sederhanakan path; pakai `CurveRenderer` untuk kualitas tepi dan zoom.
- **Efek hanya sebagai pelengkap:** pastikan antarmuka tetap terbaca tanpanya.
- **Singleton `AppSettings`** untuk pengaturan lintas berkas, terintegrasi dengan `Theme`.
- **Pakai `location` pada pengujian** agar tidak mengotori pengaturan nyata.
- **Validasi nilai yang dibaca dari penyimpanan** (rentang, tipe); anggap berkas bisa diubah di luar aplikasi.
- **Kueri berparameter selalu,** dan batasi `LocalStorage` ke data kecil dan tak rahasia.
- **Rancang dialog untuk keyboard:** fokus awal aman, Esc menutup, fokus kembali (6.3.6).
- **Perlakukan technology preview dengan hati-hati:** catat versi Qt, isolasi, dan baca catatan rilis tiap pembaruan.
- **Jangan bergantung pada gerak dan efek untuk informasi penting.**

## Latihan 15 Menit (versi diperbaiki)

*Perbaikan dari audit:* “gambar segitiga lalu simpan warnanya” diperjelas dengan `import QtCore`, lokasi berkas yang pasti, cara memeriksa isi berkas, serta pengukuran biaya efek.

1. Jalankan kode contoh di 6.4.5 (segitiga dengan `Settings`). Ketuk beberapa kali, tutup, jalankan lagi: warna yang sama harus pulih.
2. Periksa isi `/tmp/uji-pengaturan.ini`.
3. Hapus berkas itu dan jalankan lagi: warna kembali ke bawaan.
4. Tambahkan bayangan pada segitiga dengan `layer.effect: MultiEffect`, lalu ukur dengan `QSG_RENDER_TIMING=1`.
5. Aktifkan `Shape.CurveRenderer` dan bandingkan tepinya dengan tanpa itu (zoom lewat `scale`).
6. *Tantangan:* pindahkan pengaturan ke singleton `AppSettings` (daftarkan di CMake seperti `Theme.qml`).

**Kunci jawaban** (coba dulu sebelum membaca):

```qml
import QtCore
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes

Window {
    id: win
    width: 240; height: 220; visible: true
    title: 'Segitiga tersimpan'

    readonly property var palet: ['royalblue', 'tomato', 'seagreen', 'orchid']

    Settings {
        id: pref
        category: 'segitiga'
        location: 'file:///tmp/uji-pengaturan.ini'
        property int indeks: 0
    }

    Item {
        anchors.fill: parent
        TapHandler { onTapped: pref.indeks = (pref.indeks + 1) % win.palet.length }

        Shape {
            anchors.centerIn: parent
            width: 120; height: 120
            preferredRendererType: Shape.CurveRenderer

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: '#000000'
                shadowOpacity: 0.4
                shadowBlur: 0.6
                shadowVerticalOffset: 4
            }

            ShapePath {
                strokeColor: 'white'; strokeWidth: 3
                fillColor: win.palet[pref.indeks]
                startX: 10; startY: 110
                PathLine { x: 60; y: 10 }
                PathLine { x: 110; y: 110 }
                PathLine { x: 10; y: 110 }
            }
        }
    }
}
```

- `import QtCore` dan `Settings { location: ... }` — penyimpanan eksplisit di `/tmp`, tidak bergantung pada nama organisasi.
- `layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true ... }` — bayangan diterapkan pada seluruh `Shape` tanpa item sumber terpisah; padding otomatis mencegah bayangan terpotong.
- Isi berkas INI setelah beberapa ketukan: bagian `[segitiga]` dengan `indeks=<angka>`.
- Untuk mengukur: `QSG_RENDER_TIMING=1 qml6 Main.qml`; bandingkan waktu render dengan dan tanpa `layer.effect`. Biaya akan tampak kecil untuk satu bentuk kecil; naikkan ukuran atau jumlah untuk merasakan perbedaannya.

## Cek Pemahaman dan Kunci

1. **Kapan `Shapes` lebih baik daripada `Canvas`?** *Kunci:* untuk bentuk vektor yang dapat dinyatakan sebagai path: deklaratif, digambar di GPU tanpa rasterisasi perangkat lunak dan unggah tekstur, dapat dianimasikan dan diberi handler (`containsMode`). `Canvas` untuk gambar yang dihitung secara imperatif dan jarang berubah.
2. **Mengapa sumber `MultiEffect` perlu disembunyikan, dan apa kekurangannya?** *Kunci:* karena `MultiEffect` menggambar item *baru* di samping sumber; tanpa disembunyikan keduanya tampil. `visible: false` membuat sumber tak menerima input; gunakan `opacity: 0` atau `layer.effect` bila input diperlukan.
3. **Mengapa `Settings` sebaiknya memakai `location` atau identitas aplikasi yang jelas?** *Kunci:* lokasi berkas ditentukan oleh nama aplikasi, organisasi, dan domain, atau oleh `location`; tanpa itu berkas bisa berada di tempat tak terduga atau tercampur dengan aplikasi lain.
4. **Apa risiko `LocalStorage` dibanding berkas biasa?** *Kunci:* database dapat diakses semua aplikasi QML pengguna yang sama dan tidak dienkripsi; dan API-nya sinkron sehingga menahan thread GUI. Gunakan kueri berparameter dan jangan simpan rahasia.
5. **Apa status `Canvas2D` di Qt 6.12 dan apa implikasinya?** *Kunci:* technology preview; API bisa berubah tanpa jaminan kompatibilitas, jadi isolasi pemakaiannya. API C++ `QCanvasPainter` sudah resmi di 6.12.
6. **Bagaimana dialog berkas berperilaku di Linux tanpa platform theme GTK?** *Kunci:* memakai dialog cadangan Qt Quick yang berupa item di dalam scene (bukan jendela terpisah), sehingga butuh ruang cukup di jendela aplikasi.

## Rangkuman Fase 6

```
 6.1 State dan Transition  -->  keadaan visual yang dinyatakan, perpindahan yang dianimasikan
 6.2 Animasi               -->  gerak yang efisien, terukur, dan bertanggung jawab
 6.3 Input dan Keyboard    -->  kendali penuh lewat pointer dan keyboard, fokus yang benar
 6.4 Qt Quick Ekstra       -->  peralatan khusus: bentuk, efek, dialog, penyimpanan, gambar imperatif
```

**Daftar periksa Fase 6** (gunakan saat meninjau kode sendiri):

- **State dan transisi:** keadaan diturunkan dari data (`when`); satu `states` per sumbu keadaan; transisi mencakup arah kembali; alur logika sensitif memakai mesin keadaan.
- **Animasi:** properti murah (`opacity`, `scale`, `x`/`y`); `running` terikat visibilitas; durasi dan kurva dari token tema; saklar “kurangi gerakan”; diukur, bukan ditebak.
- **Input dan keyboard:** semua fungsi punya jalur keyboard; indikator fokus terlihat; tak ada jebakan fokus; fokus kembali ke pembuka dialog; aksi merusak butuh konfirmasi atau undo.
- **Ekstra:** alat paling murah yang cukup; efek diukur; penyimpanan tak berisi rahasia dan memakai kueri berparameter; dialog dirancang untuk cadangan; fitur preview diisolasi.

**Proyek mini opsional** (menyatukan seluruh fase): sebuah *panel pengaturan* dengan komponen buatan sendiri (Fase 5), tombol dan kolom yang berpindah state dengan animasi halus (6.1 dan 6.2), navigasi penuh dengan keyboard dan palet perintah (6.3), serta saklar tema dan pilihan berkas yang tersimpan lewat `Settings` dan `FileDialog` (6.4).

## Referensi Tambahan

- [Qt Quick Shapes](https://doc.qt.io/qt-6/qtquick-shapes-qmlmodule.html)
- [Qt Quick Effects](https://doc.qt.io/qt-6/qtquick-effects-qmlmodule.html)
- [Qt Quick Particles](https://doc.qt.io/qt-6/qtquick-particles-qmlmodule.html)
- [Qt Quick Dialogs](https://doc.qt.io/qt-6/qtquickdialogs-index.html)
- [Settings (QtCore)](https://doc.qt.io/qt-6/qml-qtcore-settings.html)
- [Qt Quick Local Storage](https://doc.qt.io/qt-6/qtquick-localstorage-qmlmodule.html)
- [Canvas2D (Qt 6.12)](https://doc.qt.io/qt-6/qml-qtcanvas2d-canvas2d.html)
- [Qt — Arch Wiki](https://wiki.archlinux.org/title/Qt)
- [Blog Qt](https://www.qt.io/blog)

---

*Alat yang tepat membuat kerja berat terasa ringan; kenali gudangnya, lalu pilih dengan tenang.*

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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

