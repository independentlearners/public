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

1. **\[Klarifikasi\] Bentrok nama `State`.** `State` ada di dua modul: `QtQuick` (keadaan visual) dan `QtQml.StateMachine` (mesin keadaan untuk logika). Memakai keduanya tanpa alias membuat nama saling menimpa. Solusi: `import QtQml.StateMachine as DSM` lalu `DSM.State`, `DSM.StateMachine`, `DSM.SignalTransition`. Dijelaskan di 6.1.5.
2. **\[Peringatan paket\] Modul `StateMachine` terpisah.** Di Arch Linux, tipe QML `QtQml.StateMachine` tidak ikut `qt6-declarative`; ia berasal dari paket `qt6-scxml` (daftar berkas paket itu memuat pustaka `QtStateMachine` dan `QtStateMachineQml`). Pasang dengan `sudo pacman -S qt6-scxml` bila belum ada.
3. **\[Tambahan\] Fitur yang belum tercakup:** `ParentChange`, `State.extend`, `PropertyChanges.restoreEntryValues` dan `explicit`, aturan bila beberapa `when` bernilai benar sekaligus, aturan pencocokan `Transition` (`from`, `to`, `reversible`, `enabled`), `StateGroup` untuk objek non-`Item`. Masuk ke 6.1.1 sampai 6.1.4.
4. **\[Klarifikasi\] Latihan tak menyebut pemicu.** “State kedua `nonaktif`” tidak mengatakan bagaimana state itu dimasuki. Ditentukan: `when: !kotak.enabled`, dengan transisi berbeda untuk masuk-keluar.
5. **\[Klarifikasi\] `states: State { ... }` tanpa kurung siku** sah: properti `states` adalah daftar, dan satu elemen boleh ditulis langsung.
6. **\[Tambahan\] 6.1.6 dan 6.1.7.** Panduan memilih antara State, `Behavior`, dan animasi imperatif; serta cara memakai State di dalam komponen buatan sendiri tanpa membocorkan API (menyambung Modul 5.1 dan 5.3).

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

