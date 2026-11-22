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

