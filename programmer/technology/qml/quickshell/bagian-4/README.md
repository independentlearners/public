# Kurikulum Fase 3
### Audit
Fase 3 terdiri dari tiga modul yang saling bergantung secara berurutan: **Modul 3.1** membangun fondasi arsitektur (di mana kode boleh tinggal dan siapa boleh mengimpor siapa), **Modul 3.2** mengisi fondasi itu dengan perilaku reaktif yang benar (binding, signal, state machine), dan **Modul 3.3** menjaga fondasi dan isinya tetap sehat seiring waktu (linting, smoke test, review). Urutannya sudah benar: Anda tidak bisa mendeteksi binding loop secara bermakna sebelum punya pemisahan service/UI yang jelas, dan Anda tidak bisa menulis smoke test yang berguna sebelum shell Anda punya entry point dan modul yang terpisah.

Dari segi cakupan, kurikulum sudah menyentuh poin-poin esensial Quickshell: `ShellRoot`, `pragma Singleton`, `Singleton`, `PwObjectTracker`, `Binding`, `Connections`, `states`/`transitions`, `qmllint`, `Process` dengan `clearEnvironment`, dan uji asap headless dengan Sway. Yang **belum secara eksplisit** masuk daftar namun sangat relevan untuk kedalaman fase ini adalah: mekanisme **`qmldir` dan auto-synthesis** di Quickshell (bagaimana `pragma Singleton` benar-benar ditemukan oleh engine), perbedaan **optimized vs non-optimized binding** di QML, teknik **cache computed value** untuk binding mahal, dan **`ComponentBehavior: Bound`** yang sering muncul di service Quickshell modern. Saya akan menyisipkan poin-poin ini sebagai **tambahan** di tempat yang tepat, dengan penanda khusus, tanpa mengubah struktur kurikulum.

Satu catatan teknis: contoh `qmllint` di kurikulum mengarah ke Qt 6, tetapi Quickshell saat ini berjalan di atas Qt 6 dan `qmllint` yang relevan adalah yang disertakan dengan Qt 6 tersebut; pastikan versi `qmllint` cocok dengan versi Qt yang dipakai Quickshell Anda (biasanya dicek dengan `quickshell --version` atau `qtpaths --qt-version`). Saya akan sebutkan ini di Modul 3.3.

---

## Modul 3.1 — Arsitektur Shell yang Skalabel

> *"Satu titik audit, satu titik ganti, satu titik uji."*

### Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. Deskripsi konkret dan peran dalam kurikulum
2. Konsep kunci dan filosofi mendalam: mengapa arah dependensi adalah segalanya
3. Struktur direktori yang skalabel: bedah pohon `my-shell/`
4. `ShellRoot` dan siklus hidup shell
5. Pola service singleton: `pragma Singleton`, `Singleton`, dan `qmldir`
6. Studi kasus `services/Audio.qml`: bedah kata per kata
7. Kapan memakai injeksi properti dibanding singleton
8. Mempelajari shell open-source: protokol audit sebelum menjalankan
9. Terminologi esensial
10. Latihan dan checkpoint
11. Hubungan dengan modul lain
12. Referensi lengkap
13. Tips dan praktik terbaik
14. Potensi kesalahan umum dan solusi

---

### 1. Deskripsi Konkret dan Peran dalam Kurikulum

Modul ini mengajarkan Anda **memisahkan kode berdasarkan tanggung jawab, bukan berdasarkan jenis file**. Sebelum modul ini, Anda mungkin menulis bar dengan logika audio, baterai, dan workspace bercampur di satu file. Setelah modul ini, setiap domain sistem punya satu "pintu masuk" resmi (`services/`), dan setiap komponen UI hanya boleh mengetuk pintu itu, tidak memanjat jendela ke sistem.

Perannya dalam kurikulum: ini adalah **modul fondasi arsitektural** untuk seluruh sisa Fase 3 dan fase-fase berikutnya. Tanpa pemisahan ini, Modul 3.2 (manajemen state) akan mengajarkan Anda memperbaiki binding loop di kode yang sudah kacau, dan Modul 3.3 (kualitas kode) akan memeriksa kode yang tidak punya batas audit yang jelas. Dengan modul ini, dua modul berikutnya punya sasaran yang tajam.

---

### 2. Konsep Kunci dan Filosofi Mendalam: Mengapa Arah Dependensi adalah Segalanya

Bayangkan sebuah restoran. **Pemasok** mengantar bahan mentah (sistem operasi, PipeWire, baterai, workspace compositor). **Koki** mengolah bahan itu menjadi hidangan siap saji (service: volume, persentase baterai, daftar workspace). **Pelayan** membawa hidangan ke meja (UI: bar, slider, indikator). Aturan restoran yang sehat: **pelayan tidak boleh pergi sendiri ke pasar**. Jika pelayan boleh berbelanja sendiri, maka (a) setiap pelayan perlu tahu cara memilih bahan yang baik — pengetahuan yang seharusnya cukup dimiliki koki, (b) ketika pemasok berubah, semua pelayan harus dilatih ulang, dan (c) tidak ada satu titik pun di mana Anda bisa memeriksa apakah bahan yang masuk aman.

Dalam Quickshell, "pergi ke pasar" berarti mengimpor `Quickshell.Services.*` atau membuat `Process` langsung dari komponen UI. Aturan intinya:

```
UI  ──baca properti──►  services  ──►  modul sistem / Process
▲                                          │
└────────── tidak boleh langsung ──────────┘
```

**Mengapa ini bukan sekadar "gaya kode"?** Karena Quickshell adalah konfigurasi yang berjalan dengan hak penuh pengguna. Setiap `Process` yang Anda jalankan adalah eksekusi kode arbitrer dengan kredensial Anda. Jika komponen UI — yang jumlahnya puluhan dan terus berubah — boleh membuat `Process`, maka permukaan serangan Anda adalah seluruh direktori `components/` dan `modules/`. Jika hanya `services/` yang boleh, permukaan itu menyusut menjadi satu direktori kecil yang bisa Anda audit baris per baris. Inilah yang dimaksud kurikulum dengan **"satu titik audit keamanan"**.

Filosofi ini bertumpu pada tiga prinsip yang disebutkan dalam persona Anda: **modular** (setiap bagian punya batas), **abstrak** (UI tidak perlu tahu apakah audio datang dari PipeWire, PulseAudio, atau mock test), dan **super kontrol** (Anda memilih secara sadar di mana sistem disentuh, bukan menyerahkannya pada kebiasaan).

---

### 3. Struktur Direktori yang Skalabel: Bedah Pohon `my-shell/`

```text
~/.config/quickshell/my-shell/
├── shell.qml            # entry point: merakit modul
├── services/            # singleton: Audio.qml, Battery.qml, Workspaces.qml
├── components/          # UI reusable: Clock.qml, VolumeSlider.qml
├── modules/             # fitur utuh: bar/, launcher/, notifications/, lock/
└── config/              # Theme.qml, Settings.qml
```

**Penjelasan kata per kata dan baris per baris:**

- **`shell.qml`** — Ini adalah **root file**, titik masuk yang dijalankan Quickshell. Secara konvensi bernama `shell.qml`, dan secara default Quickshell mencarinya di `~/.config/quickshell/shell.qml`. File ini **bukan** tempat menaruh logika; ia adalah **perakit**: mengimpor modul-modul dan menempatkannya di dalam `ShellRoot`. Anggap `shell.qml` sebagai *wiring diagram* — ia menghubungkan kabel, bukan menghasilkan listrik.

- **`services/`** — Direktori **satu-satunya** yang boleh mengimpor `Quickshell.Services.*`, `Quickshell.Io`, atau membuat `Process`. Isinya adalah **singleton non-visual**: tidak mewarisi `Rectangle`, `Item`, atau `Text`; mewarisi `Singleton` atau `QtObject`. Setiap file di sini mewakili satu domain sistem (audio, baterai, workspace, notifikasi, kecerahan). Karena Quickshell memetakan `import qs.services` ke direktori `services/` di bawah shell root, nama direktori ini menjadi bagian dari namespace import.

- **`components/`** — UI **reusable** yang tidak tahu dari mana datanya berasal. `VolumeSlider.qml` menerima nilai volume lewat properti (atau membaca `Audio.volume`), tetapi **tidak pernah** mengimpor `Quickshell.Services.Pipewire`. Komponen di sini adalah "pelayan": tahu cara menyajikan, tidak tahu cara berbelanja. Komponen yang baik bersifat **stateless** — mereka membaca data dari service dan merender, tanpa memiliki state sistem.

- **`modules/`** — **Fitur utuh** yang merangkai beberapa komponen dan service menjadi satu unit fungsional: satu direktori `bar/` berisi `Bar.qml` dan subkomponennya; `launcher/` berisi logika peluncuran aplikasi; `lock/` berisi layar kunci. Perbedaan dengan `components/` adalah **skala dan kohesi**: `components/Clock.qml` bisa dipakai di bar, di dashboard, dan di lock screen; `modules/bar/` adalah fitur "bar" itu sendiri, yang *menggunakan* `Clock.qml`. Modul boleh mengimpor `components/` dan `services/`, tetapi tetap tidak boleh mengimpor sistem secara langsung.

- **`config/`** — **`Theme.qml`** (warna, radius, font, spasi) dan **`Settings.qml`** (preferensi pengguna: ukuran bar, posisi, perilaku). Ini adalah **data deklaratif**, bukan logika. Service dan komponen membaca dari sini; `config/` tidak mengimpor sistem dan tidak melakukan efek samping. Memisahkan `Theme.qml` dari komponen berarti mengubah tema tidak menyentuh satu baris pun logika UI.

**Mengapa struktur ini skalabel?** Karena **arah dependensi dapat diaudit secara mekanis**. Anda bisa menjalankan `grep -R "Quickshell.Services" components/ modules/` dan hasilnya harus kosong. Anda bisa menjalankan `grep -R "Process" components/ modules/` dan hasilnya harus kosong. Jika suatu hari ada komponen yang butuh data baru, Anda menambahkannya ke service yang relevan — bukan menambahkan import sistem ke komponen. Ini adalah **audit satu baris perintah**, dan itulah wujud nyata "satu titik audit keamanan" yang disebut kurikulum.

> **Tambahan di luar daftar eksplisit kurikulum:** Quickshell secara otomatis **menyintesis `qmldir`** untuk direktori-direktori di bawah shell root yang belum memilikinya, sehingga `import qs.services` bekerja tanpa Anda menulis file registrasi manual. Ini adalah kemudahan sekaligus jebakan: jika Anda tidak sengaja menamai direktori dengan huruf besar atau meletakkannya di luar root, auto-synthesis bisa tidak menemukannya. Simpan direktori pada level atas root dan gunakan nama lowercase untuk direktori modul.

---

### 4. `ShellRoot` dan Siklus Hidup Shell

`ShellRoot` adalah **elemen akar opsional** konfigurasi Quickshell: elemen yang membungkus seluruh isi shell dan memungkinkan beberapa pengaturan ditentukan inline. Dokumentasi resmi menyebutnya "Optional root config element, allowing some settings to be specified inline". Secara teknis, `ShellRoot` adalah turunan dari `Scope` — ia **bukan elemen visual** (tidak punya `width`, `height`, atau `color`), melainkan **kontainer non-visual** yang memegang semua objek visual dan non-visual shell Anda.

```qml
// shell.qml
import Quickshell
import qs.modules.bar
import qs.modules.launcher

ShellRoot {
    Bar {}
    Launcher {}
}
```

**Bedah sintaksis:**

- **`import Quickshell`** — Mengimpor modul inti Quickshell, yang menyediakan tipe `ShellRoot`, `Singleton`, dan utilitas global. Tanpa baris ini, `ShellRoot` tidak dikenali.

- **`import qs.modules.bar`** — Mengimpor direktori `modules/bar/` sebagai modul QML. Awalan `qs.` adalah **skema URL khusus Quickshell** yang memetakan ke shell root Anda. Jadi `qs.modules.bar` berarti "di dalam shell root saya, masuk ke `modules/`, lalu `bar/`". Ini bukan import jalur file relatif biasa; ini adalah modul namespace yang disintesis oleh Quickshell. Konsekuensinya: setiap direktori yang ingin Anda impor dengan `qs.*` harus berada di bawah root dan (secara konvensi) memiliki setidaknya satu file QML yang namanya cocok dengan nama direktori atau mendefinisikan tipe yang diekspor.

- **`ShellRoot { ... }`** — Membuka scope root. Semua yang ada di dalamnya adalah bagian dari shell. `Bar {}` dan `Launcher {}` adalah **instansiasi komponen** yang diimpor di atas. Quickshell akan membuat instance `Bar` dan `Launcher` saat shell dimuat, dan keduanya hidup selama shell berjalan (kecuali Anda secara eksplisit menghancurkannya dengan `Loader` atau `destroy()`).

- **`Bar {}`** — Memanggil konstruktor komponen `Bar` tanpa argumen. Jika `Bar.qml` punya properti wajib, Anda akan menuliskannya di sini: `Bar { position: "top" }`. Ini adalah **injeksi properti** pada tingkat perakitan — salah satu bentuk dependency injection yang akan kita bahas di poin 7.

**Siklus hidup `ShellRoot`** secara garis besar:

```
Quickshell start
   │
   ▼
Muat shell.qml
   │
   ▼
Buat ShellRoot
   │
   ├─► Instansiasi anak-anak (Bar, Launcher, ...)
   │       │
   │       ▼
   │   Component.onCompleted (anak)
   │
   ▼
Component.onCompleted (ShellRoot)  ← di sini Anda bisa memaksa inisialisasi service
   │
   ▼
Shell berjalan (event loop)
   │
   ▼
Quickshell exit / reload
   │
   ▼
Component.onDestruction (ShellRoot)
```

Poin penting yang sering terlewat: **service singleton diinstansiasi secara lazy pada akses pertama**, bukan saat `shell.qml` dimuat. Artinya, jika `Audio` singleton hanya dibaca oleh `VolumeSlider` yang baru dibuat ketika bar ditampilkan, maka `Audio` (dan koneksi PipeWire-nya) baru dibuat saat itu. Jika Anda ingin sebuah service **selalu siap** sejak awal — misalnya service yang memantau idle atau mendeteksi layar penuh — Anda harus **memaksanya diinisialisasi** di `ShellRoot`:

```qml
ShellRoot {
    // Paksa service tertentu hidup sejak awal
    property var _audio: Audio      // akses pertama memicu instansiasi
    property var _idle: IdleService

    Component.onCompleted: {
        // Panggil metode inisialisasi eksplisit jika service punya
        Audio.reload()
    }

    Bar {}
    Launcher {}
}
```

Pola `property var _audio: Audio` terlihat aneh, tetapi ini adalah cara deklaratif untuk **memicu akses** ke singleton tanpa membuat elemen visual. Alternatif yang lebih eksplisit adalah memanggil `Audio.someMethod()` di `Component.onCompleted`, yang juga memicu instansiasi. Shell open-source seperti `quickshell-ii-niri` menggunakan pola ini secara eksplisit: beberapa service dipaksa hidup di `ShellRoot` karena alasan fungsional, bukan karena UI membutuhkannya saat itu.

> **Tambahan di luar daftar eksplisit kurikulum:** `ShellRoot` adalah turunan `Scope`, dan `Scope` adalah tipe yang juga digunakan oleh `Variants` untuk membuat beberapa instance jendela per layar. Jika Anda ingin shell yang sama muncul di beberapa monitor dengan konfigurasi berbeda per layar, `Variants` di dalam `ShellRoot` adalah alatnya. Ini belum relevan untuk Modul 3.1, tetapi akan berguna saat Anda membangun bar multi-monitor di fase berikutnya.

---

### 5. Pola Service Singleton: `pragma Singleton`, `Singleton`, dan `qmldir`

Ada tiga lapisan yang harus dipahami agar "service singleton" bukan sekadar mantra.

**Lapisan pertama: `pragma Singleton`.** Ini adalah **direktif file** yang memberi tahu QML engine bahwa file ini adalah singleton — satu instance global, bukan komponen yang bisa diinstansiasi berkali-kali. Tanpa `pragma Singleton`, file `Audio.qml` akan menjadi komponen biasa yang setiap kali ditulis `Audio {}` akan membuat instance baru. Dengan `pragma Singleton`, Anda **tidak pernah** menulis `Audio {}`; Anda cukup menulis `Audio.volume`.

**Lapisan kedua: `Singleton` sebagai tipe dasar.** Quickshell menyediakan tipe `Singleton` yang merupakan turunan `QtObject` dengan dukungan **reload-aware singleton registry**. Ini bukan sekadar `QtObject` biasa: ketika Quickshell melakukan hot reload, `Singleton` mendaftarkan dirinya ke `SingletonRegistry` berdasarkan URL-nya, sehingga state dapat dipertahankan atau diinisialisasi ulang dengan benar antar generasi engine. Jika Anda menulis `QtObject` dengan `pragma Singleton` di Quickshell, itu **hampir** berfungsi, tetapi Anda kehilangan integrasi reload yang halus. **Gunakan `Singleton` dari `Quickshell`, bukan `QtObject`, untuk service.**

**Lapisan ketiga: registrasi `qmldir`.** Di QML murni (Qt tanpa Quickshell), singleton harus didaftarkan secara eksplisit di file `qmldir`:

```
// qmldir (QML murni)
singleton Audio 1.0 Audio.qml
```

Di Quickshell, Anda **tidak perlu menulis ini secara manual** untuk direktori di bawah shell root, karena Quickshell menyintesis `qmldir` secara otomatis. Namun, Anda perlu tahu bahwa mekanisme ini ada, karena ketika auto-synthesis gagal (misalnya karena direktori berada di luar root, atau ada file dengan nama yang bertabrakan), gejala yang muncul adalah "type not found" atau "Audio is not defined" — bukan pesan yang secara langsung mengatakan "qmldir hilang". Memahami lapisan ini membuat Anda bisa mendiagnosis kegagalan import dengan tepat.

**Contoh lengkap `services/Audio.qml`:**

```qml
pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0

    function setVolume(v: real): void {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(v, 1))
    }

    PwObjectTracker {
        objects: [sink]
    }
}
```

**Bedah kata per kata:**

- **`pragma Singleton`** — Direktif di baris paling atas file. Memberi tahu engine: file ini adalah singleton. Harus berada **sebelum** import apa pun (secara praktik, di baris pertama atau setelah komentar). Jika diletakkan setelah import, engine akan mengabaikannya atau memberi error.

- **`import Quickshell`** — Mengimpor tipe `Singleton` dari Quickshell. Tanpa ini, `Singleton` tidak dikenali.

- **`import Quickshell.Services.Pipewire`** — Mengimpor modul PipeWire Quickshell. Inilah **satu-satunya import sistem** di file ini, dan itulah intinya: seluruh shell Anda hanya boleh menyentuh PipeWire lewat file ini (atau service audio lain yang setara). Modul ini menyediakan tipe `Pipewire` (singleton QtObject), `PwNode`, `PwObjectTracker`, dan lain-lain.

- **`Singleton { ... }`** — Badan service. Root elemen adalah `Singleton`, bukan `Item` atau `Rectangle`. Konsekuensinya: service **tidak punya** properti visual seperti `width`, `height`, `color`, `anchors`. Ini adalah **kontrak non-visual** yang memaksa service untuk fokus pada data dan perilaku.

- **`readonly property var sink: Pipewire.defaultAudioSink`** — Mendefinisikan properti **read-only** `sink` yang nilainya adalah **binding** ke `Pipewire.defaultAudioSink`. 
  - `readonly` berarti komponen UI **tidak bisa** menulis `Audio.sink = ...`. Mereka hanya bisa membaca. Ini adalah **enkapsulasi satu arah**: state sistem hanya berubah lewat metode service, bukan lewat penulisan properti dari luar.
  - `var` digunakan karena tipe `PwNode` bisa `null` (ketika belum ada sink default). Di QML, `var` adalah tipe paling permisif; alternatifnya adalah `PwNode` tetapi Anda harus menangani null dengan hati-hati. Untuk properti yang bisa null, `var` adalah pilihan pragmatis. **Namun**, jika Anda ingin `qmllint` dan tooling bekerja maksimal, Anda bisa menulis `readonly property PwNode sink: Pipewire.defaultAudioSink` dan menangani null di tempat pemakaian. Trade-off ini akan dibahas di Modul 3.3.
  - Binding ini berarti: **setiap kali** `Pipewire.defaultAudioSink` berubah (misalnya pengguna mengganti output audio dari speaker ke headphone), `Audio.sink` **otomatis** ikut berubah, dan semua UI yang membaca `Audio.sink` akan menerima notifikasi perubahan. Inilah **reaktivitas** yang menjadi fondasi Modul 3.2.

- **`readonly property real volume: sink?.audio?.volume ?? 0`** — Properti turunan yang menghitung volume dari `sink`. 
  - `sink?.audio?.volume` adalah **optional chaining**: jika `sink` null, ekspresi berhenti dan menghasilkan `undefined` tanpa error; jika `sink` ada tetapi `audio` null, juga berhenti. Ini adalah cara aman membaca rantai properti yang bisa putus.
  - `?? 0` adalah **nullish coalescing**: jika sisi kiri `null` atau `undefined`, gunakan `0`. Jadi ketika belum ada sink, `volume` bernilai `0` — bukan error, bukan `undefined` yang membingungkan UI.
  - Binding ini **bergantung pada** `sink`, `sink.audio`, dan `sink.audio.volume`. Ketika salah satu berubah, `volume` dihitung ulang. Jika `sink` diganti, binding otomatis terhubung ke `sink` yang baru. Inilah keajaiban dan risiko binding QML: Anda harus memahami **apa yang memicu evaluasi ulang**, yang akan menjadi topik utama Modul 3.2.

- **`function setVolume(v: real): void { ... }`** — Metode publik service. Ini adalah **satu-satunya pintu** untuk mengubah volume dari UI.
  - `v: real` — Parameter bertipe `real` (angka floating-point). Anotasi tipe membantu `qmllint` dan dokumentasi, meskipun QML tidak selalu menegakkannya saat runtime.
  - `: void` — Menandakan fungsi tidak mengembalikan nilai. Ini adalah anotasi opsional tetapi berguna untuk keterbacaan dan tooling.
  - `if (sink?.audio)` — **Guard clause**: jika tidak ada sink atau tidak ada audio, jangan lakukan apa pun. Ini mencegah error ketika `setVolume` dipanggil sebelum PipeWire siap (misalnya saat shell baru start). Perhatikan bahwa `Pipewire.ready` bisa `false` pada awalnya; service yang baik menangani keadaan ini dengan anggun, bukan crash.
  - `sink.audio.volume = Math.max(0, Math.min(v, 1))` — **Clamping**: pastikan volume selalu di antara `0` dan `1`. PipeWire mengharapkan volume dalam rentang ini; nilai di luar rentang bisa menyebabkan perilaku tak terduga. `Math.min(v, 1)` membatasi atas, `Math.max(0, ...)` membatasi bawah. Ini adalah **validasi di batas sistem** — UI boleh mengirim nilai apa pun, service yang menjaganya tetap valid.
  - Perhatikan: fungsi ini **menulis** ke `sink.audio.volume`, yang merupakan properti dari `PwNode`. Inilah **satu-satunya tempat** di seluruh shell Anda yang boleh menulis ke volume PipeWire. Jika nanti Anda ingin mengganti backend audio ke PulseAudio, Anda mengubah **satu file ini**, dan seluruh UI tetap bekerja karena UI hanya memanggil `Audio.setVolume()` dan membaca `Audio.volume`. Inilah yang dimaksud checkpoint kurikulum: *"mengganti sumber audio hanya mengubah satu berkas."*

- **`PwObjectTracker { objects: [sink] }`** — Ini adalah elemen Quickshell yang **melacak siklus hidup** objek PipeWire. 
  - `objects: [sink]` — Daftar objek yang dilacak: dalam hal ini, sink default.
  - Mengapa perlu? Karena `PwNode` adalah objek yang bisa **hilang** (misalnya headphone dicabut). `PwObjectTracker` memastikan Quickshell memegang referensi yang valid dan membersihkan sumber daya ketika objek hilang. Tanpa tracker, Anda bisa mengalami **dangling reference** atau kebocoran. Ini adalah detail yang sering terlewat di tutorial, tetapi krusial untuk service audio yang stabil.
  - **Catatan:** `PwObjectTracker` adalah elemen non-visual; ia bisa hidup di dalam `Singleton` karena tidak memerlukan parent visual.

**Alternatif implementasi untuk logika yang sama (sesuai instruksi Anda):**

| Pendekatan | Contoh | Kapan dipakai |
|---|---|---|
| **Service singleton** (contoh di atas) | `Audio.volume`, `Audio.setVolume()` | State global yang dibaca banyak komponen; domain sistem yang perlu dienkapsulasi. |
| **Injeksi properti** | `VolumeSlider { volume: Audio.volume; onVolumeRequested: Audio.setVolume(v) }` | Ketika komponen harus **tidak tahu** dari mana volume berasal; berguna untuk testing dan reuse. |
| **`Binding` element** | `Binding { target: slider; property: "value"; value: Audio.volume }` | Ketika Anda perlu **mematikan binding sementara** (`when:`) tanpa memutus ekspresi secara permanen. |
| **`Connections` + fungsi** | `Connections { target: Audio; function onVolumeChanged() { ... } }` | Ketika Anda perlu **melakukan efek samping** (misalnya menampilkan OSD) saat nilai berubah, bukan sekadar membaca nilai. |

Pendekatan service singleton adalah **default** untuk domain sistem; injeksi properti dan `Binding` adalah alat untuk kasus-kasus khusus yang akan dibahas di poin 7 dan Modul 3.2.

---

### 6. Studi Kasus `services/Audio.qml`: Ringkasan Alur Data

```text
Pengguna menggeser slider
        │
        ▼
VolumeSlider.onMoved(value)        ← UI, komponen reusable
        │
        ▼
Audio.setVolume(value)             ← service, satu-satunya penulis
        │
        ▼
sink.audio.volume = clamp(value)   ← PipeWire (sistem)
        │
        ▼
PipeWire memancarkan perubahan
        │
        ▼
Audio.volume (binding) dihitung ulang
        │
        ▼
VolumeSlider.value (binding) ikut berubah
        │
        ▼
Tampilan slider menyesuaikan      ← reaktivitas kembali ke UI
```

Perhatikan bahwa **UI tidak pernah menyentuh `sink.audio.volume` secara langsung**. Ia hanya memanggil `Audio.setVolume()`. Perubahan mengalir kembali ke UI **bukan** karena UI menulis ulang nilainya, tetapi karena `Audio.volume` adalah binding yang bergantung pada `sink.audio.volume`. Ini adalah **sirkuit tertutup yang aman**: satu pintu masuk, satu pintu keluar, dan UI tidak bisa "memutar balik" nilai sistem tanpa melewati service.

---

### 7. Kapan Memakai Injeksi Properti Dibanding Singleton

Ini adalah pertanyaan desain yang akan terus muncul. Aturan praktisnya:

| Gunakan **singleton** ketika... | Gunakan **injeksi properti** ketika... |
|---|---|
| State bersifat **global** dan dibaca banyak komponen di berbagai modul | State bersifat **lokal** untuk satu komponen atau satu subtree |
| Domain sistem **tunggal** (hanya ada satu volume audio default) | Anda ingin komponen **tidak bergantung** pada service tertentu (misalnya untuk testing atau reuse) |
| Anda ingin **satu titik audit** untuk domain tersebut | Anda ingin **komposisi eksplisit**: siapa memberikan data ke siapa terlihat di `shell.qml` |
| Service perlu **hidup lama** dan bertahan antar reload | Data hanya perlu hidup selama komponen induk hidup |

**Contoh injeksi properti:**

```qml
// components/VolumeSlider.qml
Item {
    property real volume: 0
    signal volumeRequested(real value)

    Slider {
        value: parent.volume
        onMoved: parent.volumeRequested(value)
    }
}
```

```qml
// modules/bar/Bar.qml
VolumeSlider {
    volume: Audio.volume
    onVolumeRequested: (v) => Audio.setVolume(v)
}
```

Di sini, `VolumeSlider` **tidak mengimpor** `Audio` sama sekali. Ia hanya tahu: "saya punya properti `volume`, dan saya memancarkan `volumeRequested` ketika pengguna menggeser." Siapa pun yang merakit `VolumeSlider` — `Bar.qml` — yang menghubungkannya ke `Audio`. Keuntungannya: `VolumeSlider` bisa diuji dengan nilai palsu (`volume: 0.5`), bisa dipakai untuk mengontrol kecerahan layar (dengan mengganti handler), dan tidak punya ketergantungan pada PipeWire. Kerugiannya: perakitan menjadi lebih verbose, dan jika ada 20 komponen yang butuh `Audio`, Anda menulis 20 baris injeksi.

**Kapan singleton lebih baik?** Ketika hampir semua komponen di shell butuh data yang sama dan injeksi properti menjadi upacara yang tidak menambah kejelasan. Volume audio adalah contoh klasik: hampir setiap modul (bar, OSD, pengaturan) butuh `Audio`, sehingga singleton `Audio` adalah abstraksi yang tepat. Sebaliknya, **state lokal** seperti "apakah panel ini terbuka" tidak boleh menjadi singleton global; itu adalah state komponen, dan injeksi properti (atau `property bool expanded` di komponen itu sendiri) adalah pilihan yang benar.

> **Tambahan di luar daftar eksplisit kurikulum:** Quickshell menyediakan `ComponentBehavior: Bound` yang memungkinkan komponen mengakses properti dari root file dengan cara yang lebih aman dan lebih mudah dibaca tooling. Ini bukan pengganti injeksi properti, tetapi sering dipakai bersamaan dengan singleton. Contoh: `pragma ComponentBehavior: Bound` di awal file membuat referensi ke `id` root tidak ambigu saat komponen di-instansiasi ulang. Ini akan muncul lagi di Modul 3.2 dan 3.3.

---

### 8. Mempelajari Shell Open-Source: Protokol Audit Sebelum Menjalankan

Kurikulum menekankan: **baca dan audit kodenya sebelum menjalankannya.** Ini bukan paranoia; ini adalah konsekuensi langsung dari model keamanan Quickshell. Shell adalah kode yang berjalan dengan hak penuh Anda, bisa menjalankan `Process`, membaca berkas, dan mengirim data ke jaringan. Menjalankan shell orang lain tanpa audit sama dengan menjalankan skrip `curl | bash` tanpa membaca isinya.

**Protokol audit minimum sebelum menjalankan shell open-source:**

1. **Cari semua `Process` dan `Quickshell.Io`.** Jalankan `grep -R "Process" .` dan `grep -R "Quickshell.Io" .` di direktori shell. Setiap kemunculan adalah titik di mana kode arbitrer bisa dijalankan. Periksa: apakah perintahnya berupa **daftar argumen** (`["cmd", "arg"]`) atau **string shell** (`"cmd arg"`)? Quickshell mendukung keduanya, tetapi hanya daftar argumen yang aman dari shell injection. Periksa juga apakah `clearEnvironment: true` digunakan ketika menjalankan perintah yang tidak memerlukan environment pengguna.
2. **Cari semua endpoint jaringan.** `grep -R "http" .`, `grep -R "Socket" .`, `grep -R "curl" .`. Apakah shell mengirim data keluar? Ke mana? Apakah data itu bisa mencakup kredensial atau isi clipboard?
3. **Cari semua operasi berkas.** `grep -R "FileView" .`, `grep -R "readFile" .`, `grep -R "writeFile" .`. Apakah shell membaca `~/.ssh/`, `~/.config/`, atau berkas sensitif lain tanpa alasan yang jelas?
4. **Periksa `qmldir` dan import.** Apakah ada import dari path yang tidak Anda kenal? Apakah ada plugin C++ yang disertakan?
5. **Jalankan di lingkungan terisolasi terlebih dahulu.** Gunakan compositor headless (Sway dengan `WLR_BACKENDS=headless`) atau VM. Jangan langsung menjalankannya di sesi utama Anda.

Shell open-source yang disebut kurikulum — **Caelestia** dan **Noctalia** — adalah contoh yang baik untuk dipelajari **setelah** Anda memahami polanya. Keduanya menggunakan service layer, tetapi dengan pendekatan yang berbeda: Caelestia cenderung pada service yang lebih eksplisit dan modular, sementara Noctalia mengandalkan beberapa singleton besar. Membaca keduanya secara berdampingan akan memberi Anda rasa tentang **trade-off** antara "banyak service kecil" dan "sedikit service besar". Jangan menyalin mentah-mentah; ambil pola, bukan kode.

---

### 9. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **`ShellRoot`** | Elemen akar opsional konfigurasi Quickshell; turunan `Scope`, non-visual, membungkus seluruh isi shell. | `ShellRoot { Bar {} }` |
| **`Scope`** | Tipe dasar non-visual yang bisa memuat anak-anak dan mengelola siklus hidupnya. | `ShellRoot` adalah `Scope`; `Variants` juga. |
| **Service singleton** | Singleton QML yang membungkus layanan sistem dan mengekspos state reaktif; non-visual, hidup selama shell. | `Audio`, `Battery`, `Workspaces` |
| **`pragma Singleton`** | Direktif file yang mendeklarasikan file QML sebagai singleton (satu instance global). | Harus di baris awal file. |
| **`Singleton`** | Tipe dasar Quickshell untuk singleton yang reload-aware; turunan `QtObject` dengan integrasi `SingletonRegistry`. | Gunakan ini, bukan `QtObject`, untuk service. |
| **Arah dependensi** | Aturan siapa boleh mengimpor siapa: UI → services → sistem. | `grep -R "Quickshell.Services" components/` harus kosong. |
| **Dependency injection** | Menyerahkan dependensi lewat properti, bukan memanggilnya secara global. | `VolumeSlider { volume: Audio.volume }` |
| **`qmldir`** | File registrasi modul QML; Quickshell menyintesisnya otomatis untuk direktori di bawah root. | Tidak perlu ditulis manual, tetapi perlu dipahami saat debug import. |
| **Auto-synthesis** | Mekanisme Quickshell yang membuat `qmldir` otomatis untuk direktori QML. | Jika import gagal, periksa apakah direktori berada di bawah root. |
| **Lazy instantiation** | Singleton baru dibuat saat pertama kali diakses, bukan saat shell dimuat. | Paksa inisialisasi di `ShellRoot` jika perlu. |
| **`PwObjectTracker`** | Elemen Quickshell yang melacak siklus hidup objek PipeWire dan membersihkan referensi. | `PwObjectTracker { objects: [sink] }` |
| **Optional chaining (`?.`)** | Operator QML/JS yang menghentikan evaluasi jika sisi kiri null/undefined. | `sink?.audio?.volume` |
| **Nullish coalescing (`??`)** | Operator yang memberikan nilai fallback jika sisi kiri null/undefined. | `volume ?? 0` |
| **Clamping** | Membatasi nilai pada rentang valid. | `Math.max(0, Math.min(v, 1))` |
| **Guard clause** | Pemeriksaan awal yang mencegah eksekusi jika kondisi tidak terpenuhi. | `if (sink?.audio) { ... }` |

---

### 10. Latihan dan Checkpoint

**Latihan:** Refaktor bar dari Fase 2 sehingga hanya `services/` yang mengimpor `Quickshell.Services.*`.

Langkah-langkah:

1. **Inventarisasi.** Jalankan `grep -R "Quickshell.Services" .` di seluruh direktori shell Anda. Catat setiap file yang muncul.
2. **Klasifikasi.** Untuk setiap file, tanyakan: apakah ini UI (komponen/modul) atau service? Jika UI, import sistem harus **dipindahkan** ke service.
3. **Buat service.** Untuk setiap domain sistem yang ditemukan (audio, baterai, workspace), buat file di `services/` dengan `pragma Singleton`, `Singleton`, properti `readonly`, dan metode yang diperlukan.
4. **Ganti import di UI.** Di komponen/modul, ganti import `Quickshell.Services.*` dengan import `qs.services` dan akses lewat singleton.
5. **Audit ulang.** Jalankan `grep -R "Quickshell.Services" components/ modules/`. Hasilnya harus **kosong**.
6. **Uji.** Jalankan shell. Pastikan setiap widget masih menampilkan data yang benar dan setiap interaksi masih berfungsi.

**Checkpoint:** Tunjukkan bahwa mengganti sumber audio hanya mengubah satu berkas.

- Buat salinan `services/Audio.qml` sebagai `services/AudioMock.qml` yang mengembalikan volume palsu (misalnya `0.5`) dan tidak mengimpor PipeWire.
- Di `shell.qml`, ganti referensi dari `Audio` ke `AudioMock` (atau gunakan injeksi properti di tingkat perakitan).
- UI — `VolumeSlider`, bar, OSD — **tidak berubah sama sekali**. Itulah buktinya: sumber audio diganti, tetapi UI tetap bekerja karena UI hanya bergantung pada **kontrak** `volume` dan `setVolume`, bukan pada implementasi PipeWire.

Jika UI Anda rusak saat mengganti service, berarti ada kebocoran dependensi: komponen UI masih mengimpor sistem secara langsung, atau masih mengandalkan detail implementasi yang seharusnya tidak diekspos.

---

### 11. Hubungan dengan Modul Lain

- **Prasyarat:** Modul ini membutuhkan Fase 2 (dasar QML, komponen, layout, input). Anda harus sudah nyaman menulis `Item`, `Rectangle`, `Column`, `Row`, dan signal handler sederhana.
- **Modul 3.2 — Manajemen State dan Reaktivitas Lanjutan:** Service yang Anda buat di sini adalah **subjek** dari Modul 3.2. Binding `readonly property real volume: sink?.audio?.volume ?? 0` adalah contoh sempurna dari binding yang harus Anda pahami siklus evaluasinya. Binding loop yang akan Anda deteksi di Modul 3.2 paling sering terjadi **di antara service dan UI** atau **di dalam service itu sendiri**.
- **Modul 3.3 — Kualitas Kode:** Audit arah dependensi yang Anda lakukan di sini menjadi **daftar periksa review** di Modul 3.3. `qmllint` akan membantu menangkap import yang tidak digunakan dan akses properti yang tidak memenuhi syarat, yang sering muncul saat refaktor ke service.
- **Fase berikutnya (Modul 4.x dan seterusnya):** Arsitektur service ini adalah fondasi untuk fitur-fitur yang lebih kompleks: notifikasi (service notifikasi + UI notifikasi), launcher (service pencarian + UI launcher), lock screen (service idle + UI lock). Tanpa pemisahan ini, setiap fitur baru akan menambah kompleksitas ke satu file besar, dan fase berikutnya akan mengajarkan Anda mengelola kompleksitas itu — yang tidak mungkin tanpa fondasi ini.

---

### 12. Referensi Lengkap

- **Quickshell — ShellRoot:** https://quickshell.org/docs/v0.3.1/types/Quickshell/ShellRoot/ — dokumentasi resmi `ShellRoot`, properti `settings`, dan sifat opsionalnya.
- **Quickshell — Shell Files (intro):** https://github.com/quickshell-mirror/quickshell-docs/blob/main/content/docs/configuration/intro.md — penjelasan konvensi `shell.qml` dan `--path`.
- **Quickshell — Pipewire:** https://quickshell.org/docs/v0.3.2/types/Quickshell.Services.Pipewire/Pipewire/ — dokumentasi `Pipewire` singleton, `defaultAudioSink`, `defaultAudioSource`, `ready`.
- **Quickshell — Process:** https://quickshell.org/docs/v0.3.0/types/Quickshell.Io/Process/ — dokumentasi `Process`, `command` sebagai daftar, `clearEnvironment`, `environment`.
- **Quickshell — Singletons (The Quickshell Book):** https://programmersd21.github.io/the_quickshell_book/ — penjelasan `pragma Singleton` dan perbedaannya dengan QML murni.
- **Quickshell — Components vs Services vs Utilities:** https://programmersd21.github.io/the_quickshell_book/part-10-architecture/components-vs-services-vs-utilities — analogi restoran dan pembagian peran komponen/service/utilitas.
- **DeepWiki — Services (quickshell-ii-niri):** https://deepwiki.com/snowarch/quickshell-ii-niri/7-services — contoh nyata service layer, lazy instantiation, forced initialization.
- **DeepWiki — Singleton Registry:** https://deepwiki.com/quickshell-mirror/quickshell/ — mekanisme `SingletonRegistry` dan reload-aware singleton.
- **Qt — QML Coding Conventions:** https://doc.qt.io/qt-6/qml-codingconventions.html — konvensi penamaan properti, sinyal, dan file QML.
- **Qt — QML Object Attributes:** https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html — dasar properti QML, binding, dan signal.

---

### 13. Tips dan Praktik Terbaik

1. **Satu domain, satu service.** Jangan membuat `SystemService` yang menangani audio, baterai, dan workspace sekaligus. Service yang terlalu besar menjadi "gumpalan" baru di dalam `services/`, dan Anda kehilangan manfaat audit. Pisahkan berdasarkan **domain yang bisa berubah secara independen**.

2. **Service tidak boleh punya parent visual.** Jangan meletakkan `Singleton` di dalam `Rectangle` atau `Item` sebagai anak. Singleton adalah objek global; ia tidak memerlukan parent visual. Jika Anda merasa perlu meletakkannya di dalam komponen, itu tanda bahwa state tersebut seharusnya menjadi state komponen, bukan singleton.

3. **Gunakan `readonly` untuk semua properti yang diekspos ke UI.** UI harus membaca, bukan menulis. Satu-satunya penulis adalah metode service. Ini adalah aturan yang paling mudah dilanggar dan paling mahal akibatnya: sekali UI bisa menulis `Audio.volume = 2`, Anda kehilangan jaminan validasi dan audit.

4. **Selalu tangani null di service.** `Pipewire.defaultAudioSink` bisa null saat startup atau saat perangkat audio dicabut. Gunakan optional chaining dan fallback (`?? 0`). Service yang crash karena null adalah service yang belum selesai.

5. **Paksa inisialisasi service yang kritis di `ShellRoot`.** Jika service harus selalu siap (idle monitor, deteksi layar penuh, koneksi socket), akses di `ShellRoot` atau panggil metode inisialisasinya di `Component.onCompleted`. Jangan mengandalkan UI untuk memicunya.

6. **Audit arah dependensi secara otomatis.** Jadikan `grep -R "Quickshell.Services" components/ modules/` sebagai bagian dari skrip pra-commit atau CI Anda. Jika ada hasil, gagalkan. Ini adalah pemeriksaan satu baris yang mencegah kebocoran arsitektur paling umum.

7. **Jangan mengimpor `qs.services` di `services/` secara berlebihan.** Service boleh bergantung pada service lain, tetapi **dependensi antar service harus searah dan minimal**. Jika `Audio` mengimpor `Battery`, dan `Battery` mengimpor `Audio`, Anda punya siklus dependensi yang akan menyulitkan reload dan pengujian. Gambarkan dependensi antar service dan pastikan grafnya asiklik.

8. **Dokumentasikan kontrak service, bukan implementasinya.** Tulis komentar singkat di bagian atas setiap file service: "Menyediakan `volume` (readonly, 0..1) dan `setVolume(v)`; sumber: PipeWire default sink." Ini memudahkan Anda (dan orang lain) mengganti implementasi tanpa membaca seluruh kode.

---

### 14. Potensi Kesalahan Umum dan Solusi

| Kesalahan | Gejala | Penyebab | Solusi |
|---|---|---|---|
| **Lupa `pragma Singleton`** | `Audio is not a type` atau setiap `Audio {}` membuat instance baru | File singleton tidak dideklarasikan sebagai singleton | Tambahkan `pragma Singleton` di baris pertama. |
| **Menggunakan `QtObject` bukan `Singleton`** | Service berfungsi, tetapi hot reload kehilangan state atau menghasilkan error aneh | `QtObject` tidak terdaftar di `SingletonRegistry` Quickshell | Ganti root elemen menjadi `Singleton` dari `Quickshell`. |
| **Meletakkan service di luar shell root** | `module "qs.services" is not installed` atau import gagal | Auto-synthesis `qmldir` hanya berlaku untuk direktori di bawah root | Pindahkan direktori ke bawah shell root, atau daftarkan `qmldir` secara manual. |
| **UI masih mengimpor `Quickshell.Services.*`** | Refaktor tampak berhasil, tetapi mengganti service merusak UI | Kebocoran dependensi | Audit dengan `grep`; pindahkan semua import sistem ke service. |
| **Service crash saat startup** | `TypeError: Cannot read property 'audio' of null` | `Pipewire.defaultAudioSink` null saat shell baru start | Gunakan `sink?.audio?.volume ?? 0` dan guard clause di metode. |
| **Menulis properti service dari UI** | Nilai volume tiba-tiba menjadi `2` atau `NaN` | UI menulis `Audio.volume = ...` meskipun `readonly` (QML kadang tidak menegakkan `readonly` pada `var`) | Jangan pernah mengekspos properti yang bisa ditulis; gunakan metode. Periksa dengan `qmllint`. |
| **Binding loop antara service dan UI** | Log penuh `Binding loop detected`; UI berkedip atau freeze | UI menulis nilai yang juga menjadi sumber binding | Baca lewat binding, tulis lewat handler interaksi (`onMoved`), bukan `onValueChanged`. (Detail di Modul 3.2.) |
| **Mengabaikan `PwObjectTracker`** | Referensi ke `PwNode` menjadi tidak valid setelah perangkat dicabut | Objek PipeWire hilang tanpa pelacakan | Gunakan `PwObjectTracker { objects: [sink] }`. |

---

### Motivasi

Arsitektur yang baik tidak terasa seperti pekerjaan; ia terasa seperti **kelegaan**. Ketika suatu hari Anda ingin mengganti backend audio, menambah fitur notifikasi, atau menyerahkan shell Anda ke orang lain untuk diaudit, Anda tidak perlu membongkar seluruh kode. Anda cukup menunjuk satu direktori dan berkata: "Di sini sistem disentuh. Sisanya hanya membaca." Itulah kekuatan yang Anda bangun hari ini — bukan sekadar kode yang berjalan, tetapi kode yang **dapat Anda pertanggungjawabkan**.

---

kita akan melanjutkan ke **Modul 3.2 — Manajemen State dan Reaktivitas Lanjutan**. Modul ini adalah "jiwa" dari QML: hampir semua perilaku UI yang terasa hidup — slider yang mengikuti volume, OSD yang muncul saat nilai berubah, panel yang membuka dan menutup dengan animasi — semuanya berdiri di atas mekanisme binding, signal, dan state. Di Modul 3.1 Anda membangun **di mana** state boleh tinggal; di sini Anda mempelajari **bagaimana** state mengalir, kapan ia dihitung ulang, dan bagaimana mencegah aliran itu berubah menjadi lingkaran setan.

---

## Modul 3.2 — Manajemen State dan Reaktivitas Lanjutan

> *"Reaktivitas bukan sihir; ia adalah kontrak. Pahami kontraknya, dan Anda mengendalikan UI. Abaikan kontraknya, dan UI mengendalikan Anda."*

### Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. Deskripsi konkret dan peran dalam kurikulum
2. Konsep kunci dan filosofi mendalam: mengapa binding bisa menjadi jebakan
3. Siklus evaluasi binding: apa yang memicu, apa yang tidak
4. Binding loop: cara mendeteksi, membaca peringatan, dan memperbaikinya
5. Elemen `Binding`: binding kondisional dan sementara
6. `Connections`: merespons signal dari objek lain di Qt 6
7. `states` dan `transitions`: state machine sederhana untuk UI
8. Optimasi binding yang mahal dan berjalan setiap frame
9. *(Tambahan)* Optimized vs non-optimized binding dan `ComponentBehavior: Bound`
10. Terminologi esensial
11. Latihan dan checkpoint
12. Hubungan dengan modul lain
13. Referensi lengkap
14. Tips dan praktik terbaik
15. Potensi kesalahan umum dan solusi

---

### 1. Deskripsi Konkret dan Peran dalam Kurikulum

Modul ini mengajarkan Anda **mengelola perilaku dinamis UI secara deklaratif dan aman**. Secara konkret, setelah modul ini Anda harus bisa:

- Menjelaskan mengapa sebuah binding dihitung ulang, dan apa konsekuensinya terhadap performa.
- Mengenali peringatan `Binding loop detected` di log, memahami penyebabnya, dan memperbaikinya tanpa menonaktifkan reaktivitas.
- Menggunakan `Binding` ketika Anda perlu mengubah nilai **hanya pada kondisi tertentu** tanpa kehilangan binding asli.
- Menggunakan `Connections` untuk merespons signal dari service tanpa menulis handler di dalam objek sumber.
- Membangun state machine sederhana dengan `states` dan `transitions` untuk panel, popup, atau lock screen.
- Mengidentifikasi binding mahal dan menggantinya dengan pola yang lebih efisien.

Perannya dalam kurikulum: Modul 3.1 memberi Anda **peta arsitektur**; Modul 3.2 memberi Anda **mesin perilaku**. Tanpa modul ini, service yang Anda buat di Modul 3.1 hanya diam: properti `readonly` tidak berguna jika UI tidak pernah membacanya lewat binding yang benar, dan metode service tidak berguna jika dipanggil dari handler yang salah. Modul 3.3 kemudian akan mengaudit hasil kerja Anda di sini — `qmllint` akan menangkap binding yang tidak perlu, dan smoke test akan menangkap binding loop yang membuat shell gagal start.

---

### 2. Konsep Kunci dan Filosofi Mendalam: Mengapa Binding Bisa Menjadi Jebakan

Bayangkan dua orang yang masing-masing menunggu yang lain bicara lebih dulu. A berkata, "Aku akan menjawab setelah B bicara." B berkata, "Aku akan menjawab setelah A bicara." Tidak ada yang pernah bicara. Itulah **binding loop**: dua properti saling bergantung secara melingkar, sehingga tidak ada nilai final yang pernah tercapai.

Filosofi QML adalah **reaktivitas deklaratif**: Anda tidak mengatakan "ketika X berubah, lakukan Y"; Anda mengatakan "Y *adalah* fungsi dari X". Engine yang mengurus kapan harus menghitung ulang. Ini sangat kuat — Anda tidak perlu menulis kode sinkronisasi manual — tetapi juga sangat mudah disalahgunakan. Dua kesalahpahaman paling umum:

**Kesalahpahaman pertama: "Binding adalah fungsi yang dipanggil sekali."** Tidak. Binding adalah **ekspresi yang dievaluasi ulang setiap kali dependensinya berubah**. Dokumentasi Qt menyatakan: *"Whenever a change in any property's dependency is detected, the binding expression is re-evaluated and the new result is applied to the property."* Artinya, setiap properti yang Anda baca di dalam ekspresi binding adalah **dependensi**, dan setiap perubahan pada dependensi itu memicu evaluasi ulang. Jika Anda membaca 10 properti, binding Anda punya 10 pemicu. Jika salah satu pemicu berubah setiap frame (misalnya posisi scroll atau progres animasi), binding Anda berjalan setiap frame — dan itu bisa menjadi mahal.

**Kesalahpahaman kedua: "Saya bisa menulis ke properti yang sama yang saya baca."** Ini adalah resep binding loop. Jika Anda menulis `rect.width: rect.height * 2` dan di tempat lain `rect.height: rect.width / 2`, maka setiap perubahan `width` memicu perubahan `height`, yang memicu perubahan `width`, dan seterusnya. Engine QML mendeteksi ini dan mencetak peringatan `Binding loop detected`, tetapi mendeteksi bukan berarti mencegah: UI Anda bisa berkedip, freeze, atau menggunakan CPU berlebihan sebelum engine menyerah.

**Aturan praktis yang akan menyelamatkan Anda:** **baca lewat binding, tulis lewat handler interaksi.** Jangan pernah menulis ke properti dari dalam `onValueChanged` yang bereaksi terhadap perubahan properti itu sendiri. Tulislah dari `onMoved`, `onClicked`, `onPressed` — handler yang dipicu oleh **interaksi pengguna**, bukan oleh perubahan nilai. Perbedaan `onValueChanged` dan `onMoved` pada `Slider` adalah inti dari checkpoint modul ini, dan akan kita bedah di poin 4.

---

### 3. Siklus Evaluasi Binding: Apa yang Memicu, Apa yang Tidak

Memahami siklus evaluasi binding adalah kunci untuk mendiagnosis hampir semua masalah reaktivitas. Berikut model mentalnya:

```text
Binding expression: volume = sink?.audio?.volume ?? 0
                            │        │        │
                            │        │        └── dependensi 3: volume
                            │        └─────────── dependensi 2: audio
                            └──────────────────── dependensi 1: sink

Setiap dependensi punya "change signal" internal.
Ketika salah satu signal berubah:
  1. Engine menandai binding sebagai "dirty".
  2. Engine menjadwalkan evaluasi ulang (biasanya di event loop berikutnya).
  3. Ekspresi dievaluasi; dependensi baru dicatat.
  4. Nilai baru dibandingkan dengan nilai lama.
  5. Jika berbeda, properti di-update dan notify signal dipancarkan.
```

**Yang memicu evaluasi ulang:** perubahan pada properti yang **dibaca secara langsung** di dalam ekspresi. Dalam contoh di atas, `sink`, `sink.audio`, dan `sink.audio.volume` adalah dependensi. Jika `sink` diganti, binding dievaluasi ulang dan **dependensi baru** dicatat (sink baru, audio baru, volume baru). Ini berarti binding **secara dinamis berpindah** mengikuti objek yang sedang dibaca.

**Yang tidak memicu evaluasi ulang:** perubahan pada properti yang **tidak dibaca**. Jika Anda menulis `volume: sink?.audio?.volume ?? 0`, perubahan pada `sink.name` tidak memicu evaluasi ulang, karena `name` tidak ada dalam ekspresi. Ini adalah **granularitas dependency tracking** yang membuat QML efisien — tetapi juga berarti Anda tidak bisa mengandalkan "perubahan objek secara umum"; Anda harus membaca properti spesifik yang ingin Anda reaksikan.

**Pentingnya siklus hidup objek:** Dokumentasi Qt memperingatkan bahwa *"the developer must make sure that all objects used in the binding expression live longer than the binding."* Dalam konteks Quickshell, ini berarti: jika Anda membuat binding ke objek yang bisa dihancurkan (misalnya `PwNode` yang hilang saat perangkat dicabut), binding harus memiliki mekanisme untuk menangani null atau objek yang tidak lagi valid. Optional chaining (`?.`) dan fallback (`??`) adalah pertahanan pertama; `PwObjectTracker` di Modul 3.1 adalah pertahanan kedua.

**Ilustrasi visual:**

```text
┌──────────────────────────────────────────────────────────────┐
│                    SIKLUS BINDING QML                        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  [Perubahan dependensi]                                      │
│         │                                                    │
│         ▼                                                    │
│  [Binding ditandai dirty]                                    │
│         │                                                    │
│         ▼                                                    │
│  [Evaluasi ulang di event loop]                              │
│         │                                                    │
│         ├──► [Dependensi baru dicatat]                       │
│         │                                                    │
│         ▼                                                    │
│  [Nilai baru vs lama]                                        │
│         │                                                    │
│         ├──► [Sama] ──► tidak ada notifikasi (optimasi)      │
│         │                                                    │
│         ▼                                                    │
│  [Berbeda] --► [Properti di-update] --► [Notify signal]      │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

Perhatikan bahwa engine **membandingkan nilai baru dengan nilai lama** sebelum memancarkan notifikasi. Jika hasil evaluasi sama dengan nilai sebelumnya, tidak ada notifikasi yang dipancarkan. Ini adalah optimasi penting: binding yang sering dievaluasi tetapi menghasilkan nilai yang sama tidak menyebabkan cascading update ke binding lain. Namun, **evaluasi ekspresinya sendiri tetap berjalan**, dan itulah biaya yang harus Anda kendalikan ketika ekspresi mahal.

---

### 4. Binding Loop: Cara Mendeteksi, Membaca Peringatan, dan Memperbaikinya

**Apa itu binding loop?** Binding loop terjadi ketika dua atau lebih properti saling bergantung secara melingkar, sehingga evaluasi satu properti memicu evaluasi properti lain yang pada gilirannya memicu evaluasi properti pertama. Engine QML mendeteksinya dan mencetak peringatan:

```
QML Rectangle: Binding loop detected for property "width"
```

**Mengapa peringatan ini penting?** Karena binding loop bukan sekadar "warning kosmetik". Ia menunjukkan bahwa UI Anda **tidak mencapai keadaan stabil**. Efeknya bisa ringan (satu properti berkedip) atau berat (CPU 100%, UI freeze, shell tidak bisa dioperasikan). Dalam konteks Quickshell — di mana UI Anda adalah **shell itu sendiri** — binding loop yang parah bisa membuat Anda tidak bisa membuka terminal untuk memperbaikinya. Itulah mengapa kurikulum meminta Anda **sengaja membuat** binding loop di lingkungan yang aman, membaca peringatannya, lalu memperbaikinya.

**Cara mendeteksi:**

- **Log.** Quickshell menulis peringatan QML ke output. Jika Anda menjalankan dari terminal, peringatan muncul di sana. Jika Anda menjalankan sebagai service, periksa log jurnal atau file output. `qs log` (jika tersedia) adalah cara yang disarankan kurikulum.
- **Pola di kode.** Cari properti yang ditulis di dalam `onValueChanged` dari properti itu sendiri, atau dua properti yang saling membaca. Contoh: `width: height * 2` dan `height: width / 2` di objek yang sama.
- **Breakpoint di sumber Qt.** Jika Anda membutuhkan backtrace lengkap, Anda bisa memasang breakpoint pada fungsi Qt yang mencetak peringatan `Binding loop detected`. Ini memerlukan Qt dengan debug symbol, tetapi memberikan gambaran paling jelas tentang rantai evaluasinya.

**Contoh binding loop yang disengaja (untuk latihan):**

```qml
// JANGAN DIPAKAI DI PRODUKSI — ini sengaja salah
Slider {
    id: badSlider
    from: 0
    to: 100
    value: badSlider.position * 100   // membaca position
    onPositionChanged: {
        badSlider.position = badSlider.value / 100   // menulis position
    }
}
```

**Mengapa ini loop?** `value` adalah binding yang bergantung pada `position`. Ketika `position` berubah, `value` dihitung ulang. `onPositionChanged` juga berjalan dan menulis `position` dari `value`. Penulisan `position` memicu `onPositionChanged` lagi, yang menulis `position` lagi — lingkaran. Engine akan mendeteksi ini setelah beberapa iterasi dan mencetak peringatan.

**Perbaikan yang benar:**

```qml
Slider {
    id: goodSlider
    from: 0
    to: 100
    value: Audio.volume * 100          // baca lewat binding
    onMoved: Audio.setVolume(value / 100)   // tulis lewat handler interaksi
}
```

**Perbedaan `onValueChanged` dan `onMoved`:**

| Aspek | `onValueChanged` | `onMoved` |
|---|---|---|
| **Dipicu oleh** | Setiap perubahan `value`, termasuk perubahan dari binding atau dari kode lain | Hanya ketika pengguna **menggeser** slider (interaksi langsung) |
| **Risiko loop** | Tinggi: jika handler menulis ke properti yang menjadi sumber `value` | Rendah: handler hanya berjalan pada interaksi pengguna, bukan pada perubahan programatik |
| **Kegunaan** | Memantau perubahan nilai dari sumber mana pun | Merespons niat pengguna untuk mengubah nilai |
| **Kapan dipakai** | Ketika Anda ingin bereaksi terhadap perubahan **tanpa menulis balik** ke sumber yang sama | Ketika Anda ingin **mengirim** perubahan ke service |

Inilah jawaban checkpoint: `onValueChanged` bereaksi terhadap **nilai berubah**, sementara `onMoved` bereaksi terhadap **pengguna menggeser**. Jika Anda menulis `Audio.setVolume(value)` di `onValueChanged`, maka ketika `Audio.volume` berubah dari sumber lain (misalnya media player mengubah volume), handler Anda akan memanggil `setVolume` lagi — potensi loop atau setidaknya penulisan balik yang tidak perlu. Dengan `onMoved`, handler hanya berjalan ketika pengguna benar-benar menggeser slider, sehingga aliran data tetap searah: **UI → service** pada interaksi, dan **service → UI** pada perubahan eksternal, tanpa saling memicu.

**Catatan penting tentang `Binding` dan loop:** Elemen `Binding` dengan `when` bisa **mencegah** sebagian loop dengan menghentikan binding sementara. Namun, `Binding` bukan obat untuk loop yang disebabkan oleh penulisan balik dari handler. Loop harus diperbaiki di **logika aliran data**, bukan dengan menonaktifkan reaktivitas.

---

### 5. Elemen `Binding`: Binding Kondisional dan Sementara

`Binding` adalah elemen QML yang memungkinkan Anda membuat binding **secara dinamis**, termasuk binding yang hanya aktif pada kondisi tertentu. Dokumentasi Qt menjelaskannya: *"In some cases you may want to modify the value of a property when a certain condition is met but leave it unmodified otherwise. Often, it's not possible to do this with direct bindings, as you have to supply values for all possible branches."*

**Masalah yang dipecahkan `Binding`:**

```qml
// Produces warning: "Unable to assign [undefined] to double value"
Rectangle {
    width: if (mouse.pressed) mouse.mouseX   // undefined ketika tidak pressed
}
```

Binding langsung di atas bermasalah karena ketika `mouse.pressed` false, ekspresi tidak menghasilkan nilai yang valid. `Binding` dengan `when` menyelesaikannya:

```qml
Rectangle {
    id: rect
    Binding on width {
        when: mouse.pressed
        value: mouse.mouseX
    }
}
```

**Bedah sintaksis:**

- **`Binding on width { ... }`** — Membuat binding yang menargetkan properti `width` dari objek **induk** (dalam contoh ini, `Rectangle`). Sintaks `on <property>` adalah cara ringkas untuk menargetkan properti di objek yang sama. Alternatifnya adalah `Binding { target: rect; property: "width"; ... }`, yang lebih eksplisit dan berguna ketika target berada di objek lain.
- **`when: mouse.pressed`** — Kondisi yang menentukan apakah binding **aktif**. Ketika `when` bernilai `true`, binding diterapkan dan `width` mengikuti `mouse.mouseX`. Ketika `when` bernilai `false`, binding **dilepas**, dan `width` kembali ke nilai yang dimilikinya sebelum binding aktif (atau ke binding langsung yang sebelumnya ada). Dokumentasi menyatakan: *"The Binding type restores any previously set direct bindings on the property."*
- **`value: mouse.mouseX`** — Ekspresi yang dihitung ketika binding aktif. Ini adalah binding yang sebenarnya; ia dievaluasi ulang setiap kali `mouse.mouseX` berubah selama `when` true.

**Kapan memakai `Binding`:**

1. **Binding kondisional:** Anda ingin properti mengikuti nilai tertentu hanya ketika kondisi terpenuhi, dan kembali ke perilaku normal ketika kondisi tidak terpenuhi. Contoh: slider yang mengikuti volume hanya ketika panel pengaturan terbuka; ketika panel tertutup, slider kembali ke nilai default-nya.
2. **Binding sementara:** Anda ingin "menimpa" binding langsung untuk sementara, lalu mengembalikannya. Contoh: ketika pengguna menyeret slider, Anda menonaktifkan binding ke service dan mengikuti posisi mouse; setelah dilepas, binding ke service diaktifkan kembali.
3. **Binding ke properti yang tidak bisa diakses secara langsung:** Misalnya properti dari objek C++ yang tidak diinstansiasi oleh QML. `Binding` memungkinkan Anda menetapkan dependensi ke properti tersebut.

**Contoh Quickshell yang relevan:**

```qml
// VolumeSlider.qml — saat pengguna menyeret, ikuti mouse; saat tidak, ikuti service
Slider {
    id: slider
    from: 0
    to: 100

    Binding on value {
        when: !slider.pressed
        value: Audio.volume * 100
    }

    onMoved: Audio.setVolume(value / 100)
}
```

Ketika slider **tidak** ditekan, `value` mengikuti `Audio.volume`. Ketika slider ditekan, binding dilepas dan slider mengikuti posisi mouse (perilaku bawaan `Slider`). Ini mencegah "perang" antara posisi mouse dan nilai service saat pengguna menyeret — masalah umum yang kalau tidak ditangani akan menghasilkan slider yang melompat-lompat.

> **Tambahan di luar daftar eksplisit kurikulum:** `Binding` memiliki properti `delayed: true` yang menunda penerapan nilai sampai event queue kosong. Ini berguna untuk mencegah nilai antara yang tidak perlu ketika beberapa dependensi berubah dalam satu frame. Namun, `delayed` memiliki biaya runtime karena membuat proxy, jadi gunakan hanya ketika Anda benar-benar melihat masalah nilai antara.

**Alternatif untuk logika yang sama:**

| Pendekatan | Contoh | Kapan dipakai |
|---|---|---|
| **`Binding` dengan `when`** | `Binding on value { when: !pressed; value: Audio.volume * 100 }` | Binding kondisional yang perlu melepas dan mengembalikan binding asli. |
| **Binding langsung dengan ternary** | `value: pressed ? mouseX : Audio.volume * 100` | Jika kedua cabang menghasilkan nilai yang valid dan Anda tidak perlu melepas binding. |
| **`Connections` + penulisan eksplisit** | `Connections { target: Audio; function onVolumeChanged() { if (!slider.pressed) slider.value = ... } }` | Ketika Anda perlu logika tambahan saat nilai berubah (misalnya animasi). |
| **State machine** | `state: pressed ? "dragging" : "following"` dengan `PropertyChanges` | Ketika perubahan nilai adalah bagian dari keadaan UI yang lebih besar. |

---

### 6. `Connections`: Merespons Signal dari Objek Lain di Qt 6

`Connections` adalah elemen yang memungkinkan Anda membuat koneksi ke signal dari objek lain, terutama ketika Anda perlu merespons signal dari objek yang **bukan induk langsung** atau ketika Anda perlu **beberapa koneksi** ke signal yang sama. Dokumentasi Qt menjelaskan: *"A Connections object creates a connection to a QML signal. When connecting to signals in QML, the usual way is to create an 'on<Signal>' handler... However, it is not possible to connect to a signal in this way in some cases, such as when multiple connections to the same signal are required, creating connections outside the scope of the signal sender, or connecting to targets not defined in QML."*

**Sintaks Qt 6 yang benar:**

```qml
Connections {
    target: Audio
    function onVolumeChanged() {
        osd.show()
    }
}
```

**Bedah sintaksis dan perbedaan dengan Qt 5:**

- **`target: Audio`** — Objek yang signal-nya ingin Anda sambungkan. Dalam contoh ini, singleton `Audio` dari Modul 3.1. Jika `target` tidak di-set, default-nya adalah **induk** dari `Connections`; jika `target: null`, tidak ada koneksi yang dibuat.
- **`function onVolumeChanged() { ... }`** — Di Qt 6, handler signal di dalam `Connections` **harus** ditulis sebagai fungsi dengan kata kunci `function`. Ini adalah perubahan dari Qt 5, di mana Anda bisa menulis `onVolumeChanged: { ... }` tanpa `function`. Dokumentasi Qt 6 menegaskan: *"For backwards compatibility you can also specify the signal handlers without function... This is not recommended. If you specify one signal handler this way, then all signal handlers specified as function in the same Connections object are ignored."*
- **Mengapa perubahan ini penting?** Tanpa `function`, handler di dalam `Connections` diperlakukan sebagai **binding properti** yang dievaluasi ulang, bukan sebagai fungsi yang dipanggil saat signal. Ini bisa menyebabkan perilaku aneh dan sulit didiagnosis. Di Qt 6, selalu gunakan `function onNamaSignal()`.

**Kapan memakai `Connections`:**

1. **Merespons signal dari service tanpa mengubah service.** Service tidak perlu tahu siapa yang mendengarkan; `Connections` adalah pihak yang mendaftar. Ini menjaga service tetap tidak bergantung pada UI.
2. **Beberapa listener untuk satu signal.** Jika tiga komponen perlu merespons `Audio.volumeChanged`, masing-masing bisa memiliki `Connections` sendiri.
3. **Menghubungkan signal ke aksi yang bukan sekadar binding.** Misalnya, saat `Audio.volumeChanged`, tampilkan OSD **dan** perbarui tray icon **dan** catat ke log. Binding hanya bisa menghasilkan nilai; `Connections` bisa menjalankan logika imperatif.

**Contoh Quickshell:**

```qml
// modules/bar/Bar.qml
Connections {
    target: Audio
    function onVolumeChanged() {
        // Tampilkan OSD selama 1.5 detik
        osd.visible = true
        osdTimer.restart()
    }
}

Timer {
    id: osdTimer
    interval: 1500
    onTriggered: osd.visible = false
}
```

**Peringatan penting:** `Connections` adalah alat yang kuat, tetapi juga pintu masuk untuk **imperatif yang tidak perlu**. Jika Anda hanya perlu **membaca** nilai, gunakan binding, bukan `Connections`. Gunakan `Connections` hanya ketika Anda perlu **melakukan sesuatu** (efek samping) sebagai respons terhadap signal, dan pastikan efek samping itu tidak menulis balik ke properti yang menjadi sumber signal — itu adalah resep loop.

**Alternatif untuk logika yang sama:**

| Pendekatan | Contoh | Kapan dipakai |
|---|---|---|
| **`Connections`** | `Connections { target: Audio; function onVolumeChanged() { ... } }` | Efek samping sebagai respons signal; beberapa listener; target di luar scope. |
| **Handler langsung di objek** | `Slider { onMoved: ... }` | Ketika Anda memiliki akses langsung ke objek sumber dan hanya perlu satu handler. |
| **Binding deklaratif** | `visible: Audio.volume > 0` | Ketika "respons" Anda sebenarnya adalah nilai turunan, bukan aksi. |
| **Signal dengan parameter** | `function onVolumeChanged(newVolume) { ... }` | Ketika signal membawa data dan Anda perlu menggunakan data itu di handler. |

---

### 7. `states` dan `transitions`: State Machine Sederhana untuk UI

`states` dan `transitions` adalah cara **deklaratif** untuk mendefinisikan keadaan UI yang bernama dan animasi perpindahan antar keadaan. Ini adalah alternatif dari menulis serangkaian `if/else` dan animasi manual.

**Contoh dari kurikulum:**

```qml
Rectangle {
    id: panel
    state: 'closed'
    states: [
        State { name: 'open';   PropertyChanges { target: panel; height: 200 } },
        State { name: 'closed'; PropertyChanges { target: panel; height: 0 } }
    ]
    transitions: Transition {
        NumberAnimation { properties: 'height'; duration: 150 }
    }
}
```

**Bedah sintaksis:**

- **`state: 'closed'`** — Properti yang menentukan **keadaan saat ini**. Nilainya adalah nama salah satu `State` yang didefinisikan. Default-nya adalah string kosong `""` (keadaan dasar), di mana semua properti kembali ke nilai aslinya.
- **`states: [ ... ]`** — Daftar keadaan yang mungkin. Setiap `State` memiliki `name` dan daftar `PropertyChanges`.
- **`State { name: 'open'; PropertyChanges { target: panel; height: 200 } }`** — Mendefinisikan keadaan bernama `'open'`. Ketika `state` bernilai `'open'`, `PropertyChanges` diterapkan: `panel.height` menjadi `200`. Perhatikan bahwa di Qt 6, ada pergeseran praktik menuju `PropertyChanges { panel.height: 200 }` (tanpa `target`), yang lebih ringkas dan lebih mudah dibaca tooling.
- **`Transition { NumberAnimation { properties: 'height'; duration: 150 } }`** — Animasi yang berjalan ketika terjadi **perpindahan** antar keadaan. `properties: 'height'` menentukan properti yang dianimasikan; `duration: 150` menentukan durasi dalam milidetik. Tanpa `Transition`, perubahan keadaan akan **instan** (tidak ada animasi).

**Konsep penting: keadaan dasar (`""`).** Ketika `state` bernilai `""`, semua `PropertyChanges` dari keadaan lain **dibatalkan**, dan properti kembali ke nilai yang didefinisikan di luar `states`. Ini berguna sebagai "keadaan netral". Namun, praktik terbaik menyarankan **mendefinisikan keadaan eksplisit** daripada mengandalkan keadaan dasar, karena keadaan dasar bisa membingungkan ketika ada banyak properti.

**Kapan memakai `states`/`transitions`:**

1. **Panel yang membuka dan menutup** dengan animasi tinggi atau opacity.
2. **Lock screen** yang berpindah dari keadaan terkunci ke keadaan memasukkan sandi ke keadaan terbuka.
3. **Launcher** yang berpindah dari keadaan tersembunyi ke keadaan mencari ke keadaan menampilkan hasil.
4. **Indikator bar** yang berubah warna atau ukuran berdasarkan keadaan baterai (normal, rendah, kritis).

**Praktik terbaik:**

- **Beri nama keadaan yang bermakna.** `'open'`, `'closed'`, `'dragging'` jauh lebih baik daripada `'state1'`, `'state2'`.
- **Gunakan `when` untuk keadaan kondisional.** `State { name: 'critical'; when: Battery.percentage < 5 }` membuat keadaan aktif secara otomatis berdasarkan kondisi, tanpa perlu menulis `state = 'critical'` secara imperatif.
- **Selalu definisikan `Transition` untuk animasi.** Tanpa transisi, perubahan keadaan terasa kasar dan tidak profesional.
- **Hindari mencampur `states` dengan penulisan properti imperatif di handler.** Jika Anda menulis `panel.height = 200` di handler sambil juga memiliki `states`, Anda menciptakan dua sumber kebenaran untuk properti yang sama. Pilih satu: state machine **atau** imperatif, bukan keduanya untuk properti yang sama.

**Ilustrasi state machine:**

```text
        ┌─────────────┐
        │   closed    │  height = 0
        └──────┬──────┘
               │  state = "open"
               ▼
        ┌─────────────┐
        │    open     │  height = 200
        └──────┬──────┘
               │  state = "closed"
               ▼
        ┌─────────────┐
        │   closed    │  height = 0
        └─────────────┘

Transition: NumberAnimation { properties: "height"; duration: 150 }
```

State machine memisahkan **apa** yang berubah (state) dari **bagaimana** perubahan dianimasikan (transition). Ini membuat kode lebih mudah dibaca dan diubah: jika Anda ingin panel membuka ke tinggi yang berbeda, Anda mengubah satu angka di `PropertyChanges`, bukan mencari semua tempat di mana `height` ditulis.

---

### 8. Optimasi Binding yang Mahal dan Berjalan Setiap Frame

Tidak semua binding sama biayanya. Binding yang membaca satu properti sederhana hampir gratis; binding yang memanggil fungsi JavaScript kompleks, melakukan string concatenation, atau mengiterasi array bisa mahal — terutama jika dievaluasi setiap frame. Dokumentasi Qt menekankan pentingnya mencapai **60 FPS** dan menghindari pekerjaan berat di binding atau handler yang berjalan sering.

**Pola binding mahal yang umum:**

| Pola | Mengapa mahal | Solusi |
|---|---|---|
| **Binding yang bergantung pada progres animasi atau posisi scroll** | Dievaluasi setiap frame (60+ kali/detik) | Gunakan `Behavior` atau `SmoothedAnimation`; cache nilai di properti antara. |
| **Ekspresi JavaScript kompleks di binding** | Parsing, eksekusi, dan alokasi objek setiap evaluasi | Sederhanakan ekspresi; pindahkan logika ke fungsi yang di-cache. |
| **Binding yang memicu cascading changes** | Satu perubahan memicu puluhan binding lain | Pecah menjadi properti antara; gunakan `readonly property` untuk nilai yang tidak berubah. |
| **String concatenation atau formatting di hot path** | Alokasi string baru setiap evaluasi | Cache hasil di properti; perbarui hanya ketika input berubah. |
| **Binding ke elemen array yang sering berubah** | Seluruh binding dievaluasi ulang ketika satu elemen berubah | Gunakan properti antara yang menunjuk ke elemen spesifik. |

**Teknik optimasi yang direkomendasikan:**

1. **Cache computed value di properti antara.** Alih-alih menghitung ulang ekspresi mahal di setiap binding, hitung sekali dan simpan di `readonly property`. Binding lain membaca properti yang sudah di-cache itu.

```qml
// Sebelum: ekspresi mahal dievaluasi di setiap binding
Text { text: formatTime(Time.currentDate) }

// Sesudah: cache di service atau properti antara
readonly property string formattedTime: formatTime(Time.currentDate)
Text { text: parent.formattedTime }
```

2. **Pecah binding kompleks menjadi properti antara.** Jika satu binding bergantung pada banyak input dan menghasilkan nilai yang digunakan oleh banyak binding lain, pecah menjadi rantai: `inputA → intermediate → final`. Hanya `intermediate` yang dievaluasi ulang ketika `inputA` berubah; `final` hanya dievaluasi ulang ketika `intermediate` berubah.

3. **Gunakan `readonly property` untuk nilai yang tidak berubah setelah pembuatan.** Jika sebuah nilai hanya dihitung sekali (misalnya lebar ikon berdasarkan font), jangan biarkan binding dievaluasi ulang tanpa alasan. `readonly property` memberi tahu engine bahwa properti tidak perlu di-observe untuk perubahan.

4. **Gunakan `Binding` dengan `delayed: true` untuk mencegah nilai antara.** Ketika beberapa dependensi berubah dalam satu frame, `delayed` menunda penerapan sampai semua perubahan selesai, mengurangi jumlah evaluasi dan mencegah UI menampilkan nilai yang tidak konsisten.

5. **Profil sebelum mengoptimalkan.** Dokumentasi Qt menegaskan: *"Attempting to optimize code without profiling is likely to result in very minor rather than significant performance improvements."* Gunakan QML Profiler untuk melihat binding mana yang paling sering dievaluasi dan paling banyak menghabiskan waktu. Jangan menebak.

> **Tambahan di luar daftar eksplisit kurikulum: Optimized vs non-optimized binding.** QML memiliki dua jenis binding: **optimized binding** (dikompilasi oleh `qmlcachegen` menjadi kode C++ yang efisien) dan **non-optimized binding** (dievaluasi sebagai JavaScript setiap kali). Binding yang sederhana — membaca satu properti dan menetapkannya ke properti lain — biasanya optimized. Binding yang melibatkan percabangan kompleks, fungsi JavaScript, atau tipe dinamis cenderung non-optimized. Anda tidak perlu menghafal aturannya; cukup tahu bahwa **memecah binding kompleks menjadi rantai binding sederhana** bukan hanya lebih mudah dibaca, tetapi juga sering lebih cepat karena setiap mata rantai bisa dioptimalkan secara independen.

> **Tambahan di luar daftar eksplisit kurikulum: `ComponentBehavior: Bound`.** Di Quickshell, Anda akan sering melihat `pragma ComponentBehavior: Bound` di awal file. Direktif ini mengubah cara QML menangani referensi ke `id` root ketika komponen di-instansiasi ulang. Secara default, QML menggunakan **unbound** behavior, di mana referensi ke `id` bisa ambigu saat komponen dibuat ulang. Dengan `Bound`, referensi ke `id` selalu terikat ke root komponen, yang membuat kode lebih aman dan lebih mudah dioptimalkan. Ini bukan pengganti binding yang baik, tetapi melengkapinya: binding yang baik + `ComponentBehavior: Bound` = komponen yang dapat diprediksi perilakunya.

---

### 9. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **Binding** | Ekspresi yang menghubungkan properti ke dependensinya; dievaluasi ulang saat dependensi berubah. | `width: parent.width / 2` |
| **Binding loop** | Dua atau lebih properti saling bergantung secara melingkar; engine mencetak peringatan. | `width: height * 2` + `height: width / 2` |
| **Dependency tracking** | Mekanisme engine mencatat properti mana yang dibaca oleh binding. | `sink?.audio?.volume` → tiga dependensi. |
| **`Binding` (elemen)** | Elemen QML untuk membuat binding kondisional/sementara. | `Binding on width { when: pressed; value: mouseX }` |
| **`when`** | Kondisi yang mengaktifkan atau menonaktifkan `Binding`. | `when: !slider.pressed` |
| **`Connections`** | Elemen untuk merespons signal dari objek lain. | `Connections { target: Audio; function onVolumeChanged() { ... } }` |
| **`function onSignalName`** | Sintaks handler signal di dalam `Connections` di Qt 6. | `function onVolumeChanged() { ... }` |
| **`State`** | Keadaan bernama dengan `PropertyChanges`. | `State { name: 'open'; ... }` |
| **`PropertyChanges`** | Perubahan properti yang diterapkan saat state aktif. | `PropertyChanges { panel.height: 200 }` |
| **`Transition`** | Animasi yang berjalan saat berpindah antar state. | `Transition { NumberAnimation { properties: 'height' } }` |
| **`onValueChanged`** | Handler yang dipicu setiap kali nilai properti berubah. | Risiko loop jika menulis balik. |
| **`onMoved`** | Handler interaksi pengguna pada `Slider`. | Aman untuk menulis ke service. |
| **Optimized binding** | Binding yang dikompilasi menjadi kode C++ efisien. | Binding sederhana satu properti. |
| **Non-optimized binding** | Binding yang dievaluasi sebagai JavaScript setiap kali. | Ekspresi kompleks dengan percabangan. |
| **Cascading changes** | Satu perubahan memicu banyak binding lain secara berantai. | Binding yang saling bergantung. |

---

### 10. Latihan dan Checkpoint

**Latihan:** Sengaja buat binding loop pada slider, baca peringatannya di `qs log`, lalu perbaiki dengan `onMoved`.

Langkah-langkah:

1. **Buat slider dengan loop.** Gunakan contoh di poin 4: `value` membaca `position`, dan `onPositionChanged` menulis `position` dari `value`.
2. **Jalankan Quickshell** dan arahkan output ke log: `quickshell -p ./my-shell 2>&1 | tee /tmp/qs.log`.
3. **Cari peringatan.** `grep -i "binding loop" /tmp/qs.log`. Anda akan melihat sesuatu seperti `QML Slider: Binding loop detected for property "position"`.
4. **Baca konteksnya.** Perhatikan properti mana yang disebut dan di file mana. Ini menunjukkan titik awal loop.
5. **Perbaiki.** Ganti `onPositionChanged` dengan `onMoved`, dan pastikan `value` hanya membaca dari service, bukan dari `position` yang juga ditulis.
6. **Uji ulang.** Jalankan lagi dan pastikan peringatan hilang, sambil memastikan slider masih berfungsi: menggeser mengubah volume, dan perubahan volume dari luar (misalnya `wpctl set-volume`) memperbarui posisi slider.

**Checkpoint:** Jelaskan beda `onValueChanged` dan `onMoved` pada `Slider`.

- `onValueChanged` dipicu oleh **setiap** perubahan `value`, termasuk perubahan yang berasal dari binding ke service. Jika Anda menulis ke service di handler ini, Anda menciptakan penulisan balik yang bisa memicu loop atau setidaknya pemborosan.
- `onMoved` dipicu **hanya** ketika pengguna menggeser slider. Ini adalah sinyal **niat pengguna**. Menulis ke service di sini aman karena aliran data searah: interaksi → service, dan service → UI melalui binding terpisah.

Jika Anda bisa menjelaskan perbedaan ini dengan kata-kata sendiri dan menunjukkan kode yang benar, Anda sudah menguasai inti modul ini.

---

### 11. Hubungan dengan Modul Lain

- **Prasyarat:** Modul 3.1 (service singleton, arah dependensi) dan Fase 2 (dasar QML, komponen, input). Anda harus sudah memiliki service `Audio` atau `Battery` yang bisa menjadi target binding dan `Connections`.
- **Modul 3.3 — Kualitas Kode:** Binding loop yang Anda temukan di sini akan menjadi salah satu item dalam daftar periksa review. `qmllint` akan membantu menangkap binding yang tidak perlu dan handler yang tidak memenuhi syarat. Smoke test headless akan menjalankan shell Anda dan memastikan tidak ada binding loop yang membuatnya gagal start.
- **Fase berikutnya:** State machine yang Anda pelajari di sini adalah fondasi untuk fitur-fitur seperti launcher (state: hidden → searching → results), lock screen (state: locked → authenticating → unlocked), dan notification popup (state: hidden → showing → dismissing). Optimasi binding akan menjadi penting ketika Anda membangun bar dengan banyak widget yang diperbarui setiap detik (jam, CPU, memori).

---

### 12. Referensi Lengkap

- **Qt — Property Binding:** https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html — dokumentasi resmi binding, termasuk siklus evaluasi dan dependency tracking.
- **Qt — Bindable Properties:** https://doc.qt.io/qt-6/bindableproperties.html — penjelasan mendalam tentang bagaimana binding bekerja di level C++ dan QML; berguna untuk memahami *mengapa* binding dievaluasi ulang.
- **Qt — Binding QML Type:** https://doc.qt.io/qt-6/qml-qtqml-binding.html — dokumentasi `Binding`, termasuk conditional bindings, `when`, `delayed`, dan multiple targets.
- **Qt — Connections QML Type:** https://doc.qt.io/qt-6/qml-qtqml-connections.html — dokumentasi `Connections`, sintaks Qt 6 `function onSignalName`, dan properti `enabled`/`ignoreUnknownSignals`.
- **Qt — States, Transitions and Animations:** https://doc.qt.io/qt-6/qtquick-statesanimations-states.html — panduan resmi state machine QML.
- **Qt — Best Practices for QML and Qt Quick:** https://doc.qt.io/qt-6/qtquick-bestpractices.html — praktik terbaik, termasuk menghindari binding loop dan optimasi.
- **Qt — QML Performance Considerations:** https://doc.qt.io/qt-6/qtquick-performance.html — panduan performa, profiling, dan optimasi binding.
- **QML Performance Anti-Pattern Reference:** https://github.com/fleasion/fleasion/blob/d8fc62ac21082e944b0a9a8a6b94c3902c259794/.agents/skills/qt-qml-profiler/references/qml-performance-anti-patterns.md — daftar anti-pola performa QML, termasuk binding mahal dan solusinya.
- **The Quickshell Book — State Management:** https://programmersd21.github.io/the_quickshell_book/part-10-architecture/state-management — konteks Quickshell untuk singleton, property passing, signal-based communication, dan anti-pola state.
- **Quickshell — Architecture Patterns (DeepWiki):** https://deepwiki.com/quickshell-mirror/quickshell/1.1-architecture-patterns-and-best-practices — pola reaktivitas dan manajemen state di Quickshell.

---

### 13. Tips dan Praktik Terbaik

1. **Baca lewat binding, tulis lewat handler interaksi.** Ini adalah aturan nomor satu. Binding untuk **membaca** state; handler seperti `onMoved`, `onClicked`, `onPressed` untuk **menulis** niat pengguna ke service. Jangan pernah menulis ke properti dari `onValueChanged` yang bereaksi terhadap properti itu sendiri.

2. **Selalu gunakan `function onSignalName` di `Connections` (Qt 6).** Tanpa `function`, handler Anda diperlakukan sebagai binding, bukan fungsi, dan bisa menyebabkan perilaku yang membingungkan. Ini adalah perubahan sintaks yang mudah terlewat jika Anda belajar dari tutorial Qt 5.

3. **Gunakan `Binding` dengan `when` untuk binding sementara, bukan untuk menambal loop.** `Binding` adalah alat untuk **melepas dan mengembalikan** binding dengan bersih; ia bukan obat untuk loop yang disebabkan oleh penulisan balik. Perbaiki loop di logika aliran data.

4. **Definisikan `Transition` untuk setiap `State`.** Perpindahan state tanpa animasi terasa kasar. Animasi 150–250 ms biasanya cukup untuk panel dan popup; hindari durasi yang terlalu lama karena membuat UI terasa lambat.

5. **Pecah binding kompleks menjadi rantai properti antara.** Ini meningkatkan keterbacaan **dan** performa. Binding yang sederhana lebih mudah dioptimalkan oleh engine daripada ekspresi JavaScript yang kompleks.

6. **Profil sebelum mengoptimalkan.** Jangan menebak binding mana yang mahal. Gunakan QML Profiler untuk melihat data nyata. Optimasi tanpa profil sering kali hanya menambah kompleksitas tanpa manfaat yang signifikan.

7. **Hindari state ganda.** Jangan menyimpan data yang sama di dua tempat (misalnya `slider.value` dan `Audio.volume` sebagai dua sumber kebenaran). Pilih satu sumber kebenaran — biasanya service — dan biarkan UI menjadi cermin melalui binding. Ini adalah prinsip yang sama dengan "satu titik audit" di Modul 3.1, tetapi diterapkan pada state.

8. **Gunakan `readonly property` untuk nilai yang tidak berubah setelah pembuatan.** Ini memberi engine izin untuk tidak melacak perubahan, mengurangi overhead. Jika sebuah nilai hanya dihitung sekali (misalnya lebar ikon berdasarkan font), jadikan `readonly`.

9. **Uji binding loop di lingkungan yang aman.** Jangan pernah membuat binding loop di sesi utama yang sedang Anda gunakan. Gunakan compositor headless (Sway dengan `WLR_BACKENDS=headless`) atau VM, seperti yang akan Anda pelajari di Modul 3.3.

10. **Dokumentasikan aliran state.** Untuk setiap service, tulis komentar singkat: "Properti `X` dibaca oleh komponen `Y` dan `Z`; ditulis hanya oleh metode `setX`." Ini membantu Anda (dan auditor) memahami mengapa binding tertentu ada dan apa yang memicunya.

---

### 14. Potensi Kesalahan Umum dan Solusi

| Kesalahan | Gejala | Penyebab | Solusi |
|---|---|---|---|
| **Menulis ke properti di `onValueChanged`** | `Binding loop detected`; UI berkedip atau freeze | Handler bereaksi terhadap perubahan yang juga ia sebabkan | Ganti dengan `onMoved`/`onClicked`; pisahkan aliran baca dan tulis. |
| **Lupa `function` di `Connections` (Qt 6)** | Handler tidak berjalan, atau berjalan sebagai binding yang aneh | Sintaks Qt 5 yang sudah usang | Tulis `function onSignalName() { ... }`. |
| **Binding ke objek yang bisa dihancurkan tanpa null handling** | `TypeError: Cannot read property ... of null` | Objek hilang saat binding masih hidup | Gunakan optional chaining (`?.`) dan fallback (`??`); gunakan `PwObjectTracker` untuk objek PipeWire. |
| **Mengandalkan `state` imperatif tanpa `states`** | Properti berubah tetapi tidak kembali ke nilai semula | Menulis properti langsung di handler, bukan melalui state machine | Definisikan `State` dan `PropertyChanges`; biarkan engine mengelola transisi. |
| **Binding mahal dievaluasi setiap frame** | CPU tinggi, UI tidak responsif | Binding bergantung pada posisi scroll, progres animasi, atau ekspresi JavaScript kompleks | Cache nilai; pecah menjadi properti antara; gunakan `Behavior`/`SmoothedAnimation`. |
| **Mencampur `states` dengan penulisan properti imperatif** | Perilaku tidak konsisten; state "kacau" | Dua sumber kebenaran untuk properti yang sama | Pilih satu: state machine **atau** imperatif, bukan keduanya. |
| **`Connections` tanpa `target` yang jelas** | Handler berjalan pada objek yang salah atau tidak berjalan | `target` default ke induk, yang mungkin bukan yang Anda maksud | Selalu set `target` secara eksplisit. |
| **Mengabaikan peringatan binding loop karena "masih jalan"** | Suatu hari shell freeze atau crash | Loop yang tidak diperbaiki menumpuk beban | Perlakukan setiap peringatan binding loop sebagai bug yang harus diperbaiki. |

---

### Motivasi

Reaktivitas QML adalah salah satu ide paling elegan dalam pemrograman UI: Anda mendeklarasikan hubungan, dan mesin menjaga konsistensi. Tetapi elegansi itu hanya terasa ketika Anda menghormati kontraknya. Setiap binding yang Anda tulis adalah janji: "properti ini *adalah* fungsi dari dependensi ini." Setiap handler yang Anda tulis adalah tindakan: "pengguna melakukan ini, jadi ubah state." Ketika Anda memisahkan janji dan tindakan dengan benar, UI Anda menjadi sesuatu yang **dapat Anda percaya** — bukan karena Anda mengujinya seribu kali, tetapi karena secara struktural ia tidak bisa menjadi tidak konsisten. Itulah yang sedang Anda bangun: bukan sekadar slider yang berfungsi, tetapi sistem yang **dapat dipahami, diaudit, dan dipertanggungjawabkan**.

---

Kita tiba di **Modul 3.3 — Kualitas Kode: Linting, Pengujian Asap, dan Review**. Jika Modul 3.1 memberi Anda **peta arsitektur** dan Modul 3.2 memberi Anda **mesin perilaku**, modul ini memberi Anda **rem dan sabuk pengaman**. Ia menjawab satu pertanyaan mendasar: bagaimana Anda memastikan bahwa shell yang Anda bangun tetap benar dan aman **seiring bertambahnya fitur** — bukan hanya hari ini, tetapi juga setelah puluhan perubahan, setelah Anda lupa detail implementasi, dan setelah orang lain (atau Anda di masa depan) menyentuh kode yang sama?

---

## Modul 3.3 — Kualitas Kode: Linting, Pengujian Asap, dan Review

> *"Tidak ada yang ditemukan bukan berarti aman. Daftar periksa mencegah kesalahan yang sama berulang."*

### Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. Deskripsi konkret dan peran dalam kurikulum
2. Konsep kunci dan filosofi mendalam: mengapa kualitas adalah keamanan
3. `qmllint` dan kebijakan peringatan: dari "warning" menjadi "error"
4. Uji asap di compositor headless: membuktikan shell bisa menyala
5. Daftar periksa review keamanan: lima pertanyaan yang harus dijawab setiap perubahan
6. Menghubungkan linting dan smoke test ke `git` hook atau CI
7. *(Tambahan)* Mencatat keputusan desain: dokumentasi singkat per modul
8. Terminologi esensial
9. Latihan dan checkpoint
10. Hubungan dengan modul lain
11. Referensi lengkap
12. Tips dan praktik terbaik
13. Potensi kesalahan umum dan solusi

---

### 1. Deskripsi Konkret dan Peran dalam Kurikulum

Modul ini mengajarkan Anda **mengotomatiskan penjagaan kualitas** dan **menyediakan daftar periksa manual** untuk hal-hal yang belum bisa diotomatiskan. Secara konkret, setelah modul ini Anda harus bisa:

- Menjalankan `qmllint` pada shell Anda dan mengonfigurasi kebijakan peringatan — dari yang bersifat informasi hingga yang menggagalkan build.
- Menulis skrip uji asap yang menjalankan Quickshell di **compositor headless** (Sway dengan backend `headless`), menangkap output, dan gagal jika ada error atau fatal.
- Menerapkan **daftar periksa review** lima poin yang disebut kurikulum pada setiap perubahan: `Process` dengan `clearEnvironment` dan daftar argumen, kebocoran kredensial, arah dependensi, binding loop/polling, dan keadaan gagal yang membuat layar terkunci.
- Menghubungkan linting dan smoke test ke **git hook** atau **CI** sehingga pemeriksaan berjalan otomatis, bukan bergantung pada ingatan.

Perannya dalam kurikulum: Modul 3.1 dan 3.2 mengajarkan Anda **membangun**; Modul 3.3 mengajarkan Anda **menjaga**. Tanpa modul ini, shell Anda mungkin berfungsi hari ini tetapi perlahan membusuk: binding loop yang tidak terdeteksi, `Process` yang membocorkan environment, atau import sistem yang bocor ke UI. Modul ini adalah jembatan menuju **Fase 4 dan seterusnya**, di mana kompleksitas meningkat dan biaya kesalahan menjadi lebih tinggi.

---

### 2. Konsep Kunci dan Filosofi Mendalam: Mengapa Kualitas adalah Keamanan

Dalam pengembangan perangkat lunak biasa, bug adalah gangguan. Dalam Quickshell, **bug adalah risiko keamanan**. Mengapa? Karena shell Anda berjalan dengan **hak penuh pengguna**. Ia bisa menjalankan `Process`, membaca berkas, mengakses clipboard, dan berkomunikasi melalui socket. Setiap kesalahan — baik itu binding loop yang membuat shell freeze, `Process` yang menjalankan perintah dengan string shell yang bisa diinjeksi, atau kredensial yang tercetak di log — adalah **permukaan serangan** atau **titik kegagalan** yang bisa membuat sistem Anda tidak dapat dioperasikan.

Filosofi modul ini bertumpu pada tiga gagasan:

**Pertama, otomatiskan yang bisa diotomatiskan.** `qmllint` bisa menangkap kesalahan sintaksis, import yang tidak digunakan, akses properti yang tidak memenuhi syarat, dan pola anti-performa. Smoke test bisa membuktikan bahwa shell setidaknya **bisa menyala** di lingkungan yang terkontrol. Ini adalah pemeriksaan yang murah, cepat, dan konsisten — tidak bergantung pada suasana hati atau ingatan Anda.

**Kedua, daftar periksa untuk yang tidak bisa diotomatiskan.** Tidak ada linter yang bisa mengetahui apakah sebuah `Process` membocorkan kredensial, atau apakah sebuah keadaan gagal membuat layar terkunci. Untuk hal-hal ini, Anda memerlukan **daftar periksa review** yang dibaca dan dijawab setiap kali ada perubahan. Daftar periksa bukan pengganti pemikiran; ia adalah **pengingat** agar pemikiran yang sama tidak terlewat.

**Ketiga, kualitas adalah properti dari proses, bukan dari satu kali kerja.** Anda tidak "mencapai" kualitas sekali dan selesai. Anda **mempertahankannya** melalui pemeriksaan yang berulang. Inilah yang dimaksud kurikulum dengan "kesalahan yang sama berulang" — daftar periksa mencegah Anda mengulangi kesalahan yang sudah Anda pelajari.

---

### 3. `qmllint` dan Kebijakan Peringatan: Dari "Warning" Menjadi "Error"

`qmllint` adalah alat yang disertakan dengan Qt untuk memverifikasi validitas sintaksis file QML dan memperingatkan tentang anti-pola. Dokumentasi Qt menyatakan: *"qmllint is a tool shipped with Qt, that verifies the syntatic validity of QML files. It also warns about some QML anti-patterns."* Secara default, beberapa masalah menghasilkan peringatan yang dicetak dan **mengembalikan exit code non-zero**, sementara masalah minor (seperti import yang tidak digunakan) hanya bersifat informasi dan tidak memengaruhi exit code.

**Apa yang diperiksa `qmllint`?**

Dokumentasi Qt mencantumkan beberapa kategori: **akses properti yang tidak memenuhi syarat** (unqualified accesses), **penggunaan signal handler tanpa signal yang cocok**, **penggunaan statement `with` di QML**, **masalah terkait kompilasi QML**, **import yang tidak digunakan**, **komponen dan properti yang deprecated**, dan banyak lagi. Untuk Quickshell, kategori yang paling relevan adalah:

- **Unqualified access:** Mengakses properti tanpa `id` atau scope yang jelas. Ini sering terjadi di service singleton yang mengekspos properti tanpa `readonly` atau tanpa tipe yang jelas.
- **Unused imports:** Import `Quickshell.Services.Pipewire` di komponen UI yang seharusnya hanya ada di `services/` — ini adalah **kebocoran arsitektur** yang bisa dideteksi linter.
- **Bad signal handler:** Handler `onNamaSignal` yang tidak cocok dengan signal mana pun. Di Qt 6, ini sering terjadi ketika Anda lupa menulis `function` di `Connections` atau salah mengeja nama signal.

**Cara menjalankan `qmllint`:**

```bash
# Linting satu file
qmllint shell.qml

# Linting seluruh direktori (secara rekursif)
find . -name '*.qml' -exec qmllint {} \;

# Linting dengan import path tambahan (jika shell Anda punya modul di luar default)
qmllint -I ./modules -I ./services shell.qml
```

Dokumentasi Qt menekankan bahwa `qmllint` memerlukan **informasi tipe** yang disediakan oleh modul QML di import path. Direktori saat ini dan import path untuk tipe bawaan Qt digunakan secara default; untuk menambahkan path lain, gunakan flag `-I`. Untuk Quickshell, path `qs.*` biasanya sudah disintesis secara otomatis, tetapi jika Anda memiliki modul di lokasi khusus, Anda perlu menambahkannya.

**Mengonfigurasi kebijakan peringatan:**

`qmllint` sangat dapat dikonfigurasi. Anda bisa mengubah cara setiap kategori diperlakukan — dari `disable`, `info`, `warning`, hingga `error` — melalui **file `.qmllint.ini`** atau opsi command line. Contoh konfigurasi:

```ini
# .qmllint.ini
[General]
AdditionalQmlImportPaths=./modules,./services
DisableDefaultImports=false

[Warnings]
Unqualified=error
UnusedImports=error
BadSignalHandler=error
Deprecated=warning
Compiler=warning
```

**Mengapa menaikkan warning menjadi error?** Karena **warning yang tidak menggagalkan build cenderung diabaikan**. Jika `UnusedImports` hanya informasi, Anda akan menumpuk import yang tidak perlu selama berbulan-bulan. Jika `Unqualified` hanya warning, Anda akan memiliki kode yang sulit dioptimalkan dan sulit dipahami tooling. Dengan menaikkannya menjadi `error`, Anda memaksa diri (dan CI) untuk memperbaikinya **sebelum** perubahan masuk. Ini adalah **kebijakan zero-tolerance** yang menjaga kualitas pada level yang Anda tetapkan.

**Menonaktifkan peringatan secara inline (dengan bijak):**

Kadang-kadang Anda perlu menonaktifkan peringatan untuk baris tertentu. Dokumentasi Qt menyediakan komentar `// qmllint disable` dan `// qmllint enable`:

```qml
Item {
    property string foo

    Item {
        // qmllint disable unqualified
        property string bar: foo   // sengaja unqualified karena alasan tertentu
        // qmllint enable unqualified
    }
}
```

**Peringatan penting:** Dokumentasi Qt menyarankan untuk **menyebutkan kategori spesifik** yang ingin dinonaktifkan, bukan menonaktifkan semua peringatan. Menonaktifkan semua peringatan di suatu blok adalah tanda bahwa Anda menyerah pada kualitas di area itu; lebih baik memahami mengapa peringatan muncul dan memperbaikinya, atau menonaktifkan kategori spesifik dengan alasan yang didokumentasikan.

> **Tambahan di luar daftar eksplisit kurikulum:** `qmllint` memiliki kategori **Compiler** yang memperingatkan kode yang tidak bisa dikompilasi oleh `qmlsc` (QML script compiler). Peringatan ini **tidak aktif secara default**; Anda harus mengaktifkannya dengan `--compiler warning` atau mengonfigurasinya di `.qmllint.ini`. Mengaktifkan kategori ini sangat berharga karena kode yang tidak bisa dikompilasi akan lebih lambat dan kurang dapat dioptimalkan. Untuk shell Quickshell yang mengejar performa, ini adalah pemeriksaan yang layak dijadikan `error`.

---

### 4. Uji Asap di Compositor Headless: Membuktikan Shell Bisa Menyala

**Apa itu smoke test?** Uji cepat yang hanya memastikan program **bisa menyala tanpa galat fatal**. Ia tidak menguji setiap fitur; ia menguji hal yang paling mendasar: apakah shell Anda setidaknya bisa dimuat, diinstansiasi, dan bertahan hidup selama beberapa detik? Jika smoke test gagal, tidak ada gunanya menjalankan pengujian yang lebih mendalam.

**Mengapa headless?** Karena Anda tidak ingin menguji shell di sesi utama Anda — jika shell crash atau membekukan layar, Anda kehilangan akses ke terminal untuk memperbaikinya. **Compositor headless** (Sway dengan `WLR_BACKENDS=headless`) menjalankan compositor tanpa layar fisik, sehingga shell Anda bisa diuji di lingkungan yang terisolasi. Jika terjadi kesalahan, sesi utama Anda tidak terpengaruh.

**Contoh skrip uji asap dari kurikulum:**

```bash
#!/usr/bin/env bash
set -euo pipefail
WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 sway -c /dev/null &
SWAY=$!; sleep 2
export WAYLAND_DISPLAY=wayland-1
timeout 10 quickshell -p ./my-shell > /tmp/qs.out 2>&1 || true
kill $SWAY
! grep -Ei 'error|fatal' /tmp/qs.out
```

**Bedah kata per kata:**

- **`#!/usr/bin/env bash`** — Shebang: menjalankan skrip dengan bash. Ini memastikan kompatibilitas dengan fitur bash seperti `set -euo pipefail`.
- **`set -euo pipefail`** — Tiga mode ketat: `-e` keluar jika ada perintah yang gagal; `-u` error jika ada variabel yang tidak didefinisikan; `-o pipefail` membuat pipeline gagal jika salah satu perintah di dalamnya gagal (bukan hanya perintah terakhir). Ini adalah **praktik terbaik** untuk skrip yang harus dapat diandalkan.
- **`WLR_BACKENDS=headless`** — Memberi tahu wlroots (library di balik Sway) untuk menggunakan backend **headless**: tidak ada GPU, tidak ada layar fisik. Ini adalah kunci isolasi.
- **`WLR_LIBINPUT_NO_DEVICES=1`** — Memberi tahu wlroots untuk **tidak** membuka perangkat input. Di lingkungan headless, tidak ada keyboard atau mouse; tanpa variabel ini, Sway bisa gagal atau menggantung saat mencoba menginisialisasi input.
- **`sway -c /dev/null &`** — Menjalankan Sway dengan konfigurasi kosong (`/dev/null`). `&` menjalankannya di background. Sway adalah compositor yang kompatibel dengan protokol layer-shell yang digunakan Quickshell.
- **`SWAY=$!`** — Menyimpan **PID** dari proses Sway yang baru dijalankan. Ini diperlukan untuk mematikannya nanti.
- **`sleep 2`** — Memberi waktu Sway untuk menginisialisasi socket Wayland. Durasi ini bisa disesuaikan; 2 detik biasanya cukup di mesin cepat, tetapi di CI yang lambat Anda mungkin perlu 3–5 detik.
- **`export WAYLAND_DISPLAY=wayland-1`** — Menetapkan nama socket Wayland yang akan digunakan Quickshell. Sway secara default membuat `wayland-1` di direktori runtime. Jika Anda menjalankan beberapa instance Sway, nomornya bisa berbeda; untuk smoke test sederhana, `wayland-1` adalah asumsi yang wajar.
- **`timeout 10 quickshell -p ./my-shell > /tmp/qs.out 2>&1 || true`** — Menjalankan Quickshell dengan path `./my-shell`, membatasi waktu eksekusi hingga 10 detik. Output (stdout dan stderr) dialihkan ke `/tmp/qs.out`. `|| true` memastikan skrip tidak berhenti jika Quickshell keluar dengan kode non-zero (misalnya karena timeout); kita akan memeriksa log secara terpisah.
- **`kill $SWAY`** — Mematikan Sway setelah pengujian selesai. Ini adalah **pembersihan** yang penting; jika tidak, proses Sway akan menggantung.
- **`! grep -Ei 'error|fatal' /tmp/qs.out`** — Periksa apakah log mengandung kata `error` atau `fatal` (case-insensitive). `!` membalik exit code: jika `grep` **menemukan** error, exit code 1, dan `!` membuatnya menjadi 0 — tetapi kita ingin **gagal** jika ada error. Tunggu, ini perlu diperbaiki: `! grep` akan **berhasil** jika grep **tidak** menemukan apa pun. Jadi baris ini **gagal** (exit code non-zero) jika grep **menemukan** error. Itulah yang kita inginkan: skrip gagal jika ada error di log.

**Contoh nyata dari shell open-source:** Caelestia menggunakan pola serupa di CI mereka: menjalankan Sway headless, menjalankan shell, tidur beberapa detik, dan memeriksa apakah proses shell masih hidup dengan `pgrep`. Perhatikan bahwa pendekatan mereka adalah **memeriksa keberadaan proses** (`pgrep .quickshell-wra`), bukan hanya memeriksa log. Keduanya valid: memeriksa log menangkap error yang dicetak, memeriksa proses menangkap crash yang tidak meninggalkan log. **Praktik terbaik adalah melakukan keduanya.**

**Alternatif dan peningkatan:**

| Pendekatan | Contoh | Kelebihan | Kekurangan |
|---|---|---|---|
| **Memeriksa log** | `grep -Ei 'error\|fatal' /tmp/qs.out` | Menangkap error yang dicetak | Bisa melewatkan crash tanpa log |
| **Memeriksa proses** | `pgrep -f quickshell` setelah beberapa detik | Menangkap crash | Bisa melewatkan error non-fatal |
| **Keduanya** | Log + proses | Cakupan terbaik | Sedikit lebih kompleks |
| **`qs log`** | Jika Quickshell menyediakan perintah log | Format terstruktur | Tergantung versi/tooling |

**Praktik terbaik untuk smoke test:**

1. **Selalu gunakan `timeout`** untuk mencegah shell menggantung selamanya jika terjadi freeze.
2. **Selalu bersihkan** proses Sway dan Quickshell, bahkan jika pengujian gagal. Gunakan `trap` untuk memastikan pembersihan.
3. **Simpan log** ke file yang bisa diperiksa setelah pengujian. Jangan hanya mengandalkan output terminal.
4. **Uji di lingkungan yang bersih** — tidak ada state dari sesi sebelumnya yang bisa memengaruhi hasil.
5. **Jalankan smoke test pada setiap perubahan** melalui hook atau CI, bukan hanya sesekali.

---

### 5. Daftar Periksa Review Keamanan: Lima Pertanyaan yang Harus Dijawab Setiap Perubahan

Daftar periksa ini adalah **jantung manual** dari Modul 3.3. Ia tidak bisa diotomatiskan sepenuhnya, tetapi bisa dijadikan **kebiasaan** yang konsisten. Setiap kali Anda mengubah shell — menambah fitur, merefaktor, atau memperbaiki bug — jawab lima pertanyaan berikut:

**1. Apakah setiap `Process` memakai `clearEnvironment` dan perintah berbentuk daftar argumen?**

Quickshell `Process` **tidak menjalankan perintah di shell**; semua argumen harus berupa nilai terpisah dalam daftar, misalnya `["echo", "hello"]`, bukan `["echo hello"]`. Ini **mencegah shell injection** dan menangani argumen dengan spasi dengan benar. Dokumentasi Quickshell menegaskan: *"This does not run command in a shell. All arguments to the command must be in separate values in the list."*. Jika Anda perlu menjalankan perintah melalui shell, Anda harus secara eksplisit menggunakan `["sh", "-c", <perintah>]` — tetapi ini **mengembalikan risiko injection** dan harus dihindari kecuali benar-benar diperlukan.

`clearEnvironment: true` menghapus semua variabel environment sebelum menerapkan `environment` yang Anda tentukan. Ini penting ketika Anda menjalankan perintah yang tidak memerlukan environment pengguna (misalnya `wpctl`, `pamixer`, atau skrip kecil), karena mencegah kebocoran variabel seperti `SSH_AUTH_SOCK`, `GPG_AGENT_INFO`, atau token API ke proses anak. Dokumentasi DeepWiki menegaskan bahwa Quickshell menyediakan kontrol penuh atas environment, termasuk kemampuan membersihkan environment sistem sebelum eksekusi.

**2. Apakah ada kredensial atau data pribadi yang bisa masuk ke log atau berkas state?**

Periksa setiap `console.log`, setiap output `Process` yang ditangkap, dan setiap berkas yang ditulis. Apakah ada token, kata sandi, kunci SSH, atau isi clipboard yang bisa tercetak? Apakah log disimpan di lokasi yang bisa dibaca oleh proses lain? Apakah `Process` yang Anda jalankan menerima argumen yang mengandung rahasia (yang bisa terlihat di `ps`)? Jika ya, Anda perlu **meredaksi** atau **menghindari** pencatatan data tersebut.

**3. Apakah dependensi hanya mengalir UI → services → sistem?**

Ini adalah audit yang bisa Anda otomatiskan sebagian dengan `grep`:

```bash
# Harus kosong
grep -R "Quickshell.Services" components/ modules/ 2>/dev/null
grep -R "Quickshell.Io" components/ modules/ 2>/dev/null
grep -R "Process" components/ modules/ 2>/dev/null
```

Jika ada hasil, berarti ada komponen UI yang menyentuh sistem secara langsung — kebocoran arsitektur yang harus diperbaiki. Daftar periksa ini adalah penerapan langsung dari prinsip Modul 3.1.

**4. Apakah ada binding loop atau polling yang bisa diganti modul bawaan?**

Cari `onValueChanged` yang menulis ke properti yang sama yang dipantaunya. Cari `Timer` yang berjalan setiap beberapa milidetik untuk memeriksa perubahan yang seharusnya bisa ditangkap oleh signal. Cari binding yang bergantung pada posisi scroll atau progres animasi. Quickshell menyediakan modul bawaan (misalnya `Pipewire`, `Battery`, `Workspaces`) yang sudah menangani perubahan secara reaktif; **polling manual** adalah tanda bahwa Anda melewatkan modul bawaan atau menulis binding yang salah.

**5. Apakah ada keadaan gagal yang membuat layar terkunci atau tak bisa dioperasikan?**

Ini adalah pertanyaan yang paling kritis untuk shell. Bayangkan: apa yang terjadi jika service audio crash? Jika compositor kehilangan koneksi? Jika berkas konfigurasi hilang? Jika lock screen gagal memuat? Apakah Anda masih bisa membuka terminal? Apakah Anda masih bisa login? Apakah ada **jalan keluar** dari keadaan gagal? Shell yang baik memiliki **fail-safe**: misalnya, jika lock screen crash, compositor harus tetap bisa diakses melalui TTY; jika bar crash, jendela harus tetap bisa dioperasikan. Uji skenario kegagalan ini secara sadar, bukan hanya skenario sukses.

**Format daftar periksa yang bisa Anda gunakan:**

```markdown
## Review Checklist — [nama perubahan]

- [ ] Semua `Process` menggunakan daftar argumen dan `clearEnvironment` yang sesuai.
- [ ] Tidak ada kredensial/data pribadi di log atau berkas state.
- [ ] `grep -R "Quickshell.Services" components/ modules/` kosong.
- [ ] Tidak ada binding loop (log bersih) dan tidak ada polling manual yang bisa diganti signal.
- [ ] Keadaan gagal telah diuji: shell tetap bisa dioperasikan atau setidaknya bisa dipulihkan dari TTY.

Catatan:
- ...
```

---

### 6. Menghubungkan Linting dan Smoke Test ke `git` Hook atau CI

Pemeriksaan yang tidak berjalan otomatis **tidak akan berjalan**. Anda mungkin berjanji untuk menjalankan `qmllint` setiap kali, tetapi setelah beberapa minggu, janji itu memudar. Solusinya: **hook** dan **CI**.

**Git hook pre-commit untuk `qmllint`:**

Dokumentasi Qt dan artikel praktik terbaik menyarankan menambahkan `qmllint` sebagai pre-commit hook. Contoh skrip sederhana:

```bash
#!/bin/sh
# .git/hooks/pre-commit

# Cari file QML yang di-stage
if git diff --cached --name-only | grep -E '\.qml$'; then
    echo "Running qmllint on staged QML files..."
    git diff --cached --name-only | grep -E '\.qml$' | while read file; do
        qmllint "$file"
        if [ $? -ne 0 ]; then
            echo "qmllint failed on $file. Fix errors before committing."
            exit 1
        fi
    done
fi
```

**Cara kerja:** Skrip memeriksa apakah ada file `.qml` yang di-stage. Jika ada, ia menjalankan `qmllint` pada setiap file. Jika `qmllint` mengembalikan exit code non-zero (menandakan error), commit **dibatalkan**. Ini memaksa Anda memperbaiki masalah **sebelum** perubahan masuk ke riwayat, bukan setelahnya.

**Alternatif dengan `pre-commit` framework:** Daripada menulis hook manual, Anda bisa menggunakan framework seperti `pre-commit` (Python) yang mengelola hook dengan lebih rapi. Contoh konfigurasi dari proyek QML:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: qmllint
        name: qmllint
        entry: qmllint
        language: system
        files: \.qml$
```

Framework ini menangani instalasi, pembaruan, dan eksekusi hook, sehingga Anda tidak perlu menulis skrip shell manual.

**Integrasi ke CI:**

Hook hanya berjalan di mesin lokal dan bisa dilewati (`git commit --no-verify`). CI adalah **lapisan pertahanan kedua** yang tidak bisa dilewati. Contoh workflow GitHub Actions yang menjalankan `qmllint` dan smoke test:

```yaml
name: QML Quality
on: [push, pull_request]

jobs:
  lint-and-smoke:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Qt and Quickshell dependencies
        run: |
          # Instalasi Qt, qmllint, dan dependensi Quickshell
          # (detail tergantung distro/CI image)

      - name: Run qmllint
        run: |
          find . -name '*.qml' -exec qmllint {} \;

      - name: Smoke test on Sway headless
        env:
          WLR_BACKENDS: headless
          WLR_LIBINPUT_NO_DEVICES: 1
          WAYLAND_DISPLAY: wayland-1
        run: |
          # Jalankan Sway headless, Quickshell, periksa log/proses
          ./scripts/smoke-test.sh
```

**Shell open-source sebagai contoh:** Caelestia menjalankan smoke test di CI mereka dengan Sway headless, menjalankan shell, dan memeriksa apakah proses masih hidup setelah beberapa detik. Ini adalah pola yang bisa Anda adaptasi: **CI menjalankan apa yang Anda tidak ingin jalankan secara manual setiap kali**.

> **Tambahan di luar daftar eksplisit kurikulum:** Selain `qmllint`, pertimbangkan **`qmlformat`** untuk menjaga konsistensi gaya kode. `qmlformat` adalah alat Qt yang memformat file QML secara otomatis. Dalam proyek tim, ini menghilangkan perdebatan tentang spasi dan indentasi, dan membuat diff lebih bersih. Anda bisa menjalankannya sebagai pre-commit hook atau CI step, sama seperti `qmllint`. Namun, berhati-hatilah: `qmlformat` bisa mengubah kode secara signifikan pada pertama kali dijalankan; lakukan pada seluruh codebase dalam satu commit terpisah agar diff perubahan fungsional tidak tercampur dengan perubahan format.

---

### 7. *(Tambahan)* Mencatat Keputusan Desain: Dokumentasi Singkat per Modul

Kurikulum menyebutkan "mencatat keputusan desain (catatan singkat per modul)" sebagai bagian dari daftar isi, tetapi tidak memberikan detail. Ini adalah praktik yang **sangat berharga** dan sering diabaikan. Ketika Anda membuat keputusan arsitektur — mengapa `Audio` menjadi singleton, mengapa `VolumeSlider` menerima injeksi properti, mengapa binding tertentu menggunakan `Binding` dengan `when` — **tuliskan alasannya**. Bukan dokumentasi API yang panjang, tetapi **catatan singkat** yang menjawab: "Apa yang saya putuskan, mengapa, dan apa alternatif yang saya tolak?"

Contoh catatan:

```markdown
## services/Audio.qml — Catatan Desain

- **Keputusan:** `Audio` adalah singleton global, bukan injeksi properti.
- **Alasan:** Hampir semua modul (bar, OSD, pengaturan) membutuhkan volume. Injeksi properti di 20 tempat akan menjadi upacara tanpa manfaat.
- **Alternatif yang ditolak:** Service per-komponen (terlalu banyak duplikasi); membaca `Pipewire` langsung dari UI (melanggar arah dependensi).
- **Risiko:** Singleton sulit diuji secara terisolasi. Mitigasi: kontrak `volume`/`setVolume` bisa dimock di masa depan.
```

Catatan seperti ini **menyelamatkan Anda di masa depan** ketika Anda lupa mengapa Anda membuat keputusan tertentu, dan **membantu auditor** memahami bahwa keputusan itu disengaja, bukan kebetulan.

---

### 8. Terminologi Esensial

| Istilah | Definisi | Contoh/ Catatan |
|---|---|---|
| **`qmllint`** | Alat Qt untuk memverifikasi sintaks QML dan memperingatkan anti-pola. | `qmllint shell.qml` |
| **`.qmllint.ini`** | File konfigurasi untuk kebijakan peringatan `qmllint`. | `Unqualified=error` |
| **Unqualified access** | Mengakses properti tanpa `id` atau scope yang jelas. | Sering di service singleton. |
| **Unused import** | Import yang tidak digunakan di file QML. | Indikasi kebocoran arsitektur jika di UI. |
| **Bad signal handler** | Handler `onNamaSignal` yang tidak cocok dengan signal. | Sering karena lupa `function` di `Connections`. |
| **Smoke test** | Uji cepat yang memastikan program bisa menyala tanpa galat fatal. | Menjalankan shell di Sway headless selama beberapa detik. |
| **Headless** | Berjalan tanpa layar fisik. | `WLR_BACKENDS=headless` |
| **`WLR_BACKENDS`** | Variabel environment wlroots untuk memilih backend. | `headless` untuk pengujian. |
| **`WLR_LIBINPUT_NO_DEVICES`** | Variabel environment wlroots untuk menonaktifkan perangkat input. | `1` di lingkungan headless. |
| **`clearEnvironment`** | Properti `Process` untuk menghapus environment sebelum eksekusi. | `clearEnvironment: true` |
| **Daftar argumen** | `Process.command` sebagai daftar string, bukan string shell. | `["echo", "hello"]` |
| **Shell injection** | Serangan yang mengeksploitasi string shell yang tidak di-escape. | Dicegah oleh daftar argumen. |
| **Pre-commit hook** | Skrip yang berjalan sebelum commit diizinkan. | Menjalankan `qmllint` pada file yang di-stage. |
| **CI (Continuous Integration)** | Layanan yang menjalankan pengujian otomatis pada setiap push/PR. | GitHub Actions, GitLab CI. |
| **Regresi** | Perilaku yang tadinya benar lalu rusak karena perubahan. | Ditangkap oleh smoke test dan review. |
| **Fail-safe** | Keadaan gagal yang masih memungkinkan pemulihan. | TTY tetap bisa diakses jika lock screen crash. |

---

### 9. Latihan dan Checkpoint

**Latihan:** Buat skrip uji asap dan hubungkan ke `git` hook atau CI.

Langkah-langkah:

1. **Tulis skrip smoke test** berdasarkan contoh di poin 4. Pastikan skrip:
   - Menggunakan `set -euo pipefail`.
   - Menjalankan Sway headless dengan `WLR_BACKENDS=headless` dan `WLR_LIBINPUT_NO_DEVICES=1`.
   - Menjalankan Quickshell dengan `timeout`.
   - Memeriksa log untuk `error`/`fatal` **dan** memeriksa apakah proses masih hidup.
   - Membersihkan proses Sway dan Quickshell dengan `trap`.
2. **Uji skrip secara manual** di terminal. Pastikan ia berhasil ketika shell sehat, dan gagal ketika Anda sengaja menambahkan error (misalnya import yang tidak ada).
3. **Tambahkan pre-commit hook** yang menjalankan `qmllint` pada file QML yang di-stage. Uji dengan melakukan commit pada file yang memiliki warning `Unqualified`.
4. **Tambahkan CI step** yang menjalankan smoke test. Push ke repositori dan lihat hasilnya di CI.
5. **Dokumentasikan** hasilnya: error apa yang tertangkap oleh skrip Anda?

**Checkpoint:** Tunjukkan satu galat yang tertangkap oleh skrip Anda sebelum sampai ke sesi utama.

Contoh: Anda sengaja menghapus import `Quickshell` dari `shell.qml`. Smoke test menjalankan Quickshell di Sway headless, dan log mengandung `Type ShellRoot unavailable` atau `error: module "Quickshell" is not installed`. Karena skrip memeriksa log dan menemukan `error`, skrip gagal — **sebelum** Anda mencoba menjalankannya di sesi utama dan kehilangan akses ke terminal. Itulah bukti bahwa smoke test bekerja.

Jika Anda bisa menunjukkan satu galat yang tertangkap oleh skrip Anda, Anda sudah menguasai inti modul ini.

---

### 10. Hubungan dengan Modul Lain

- **Prasyarat:** Modul 3.1 (service singleton, arah dependensi) dan Modul 3.2 (binding, signal, state machine). Anda harus sudah memiliki shell yang berfungsi dengan struktur direktori yang jelas agar `qmllint` dan smoke test punya sasaran yang bermakna.
- **Modul 3.1:** Audit arah dependensi yang Anda lakukan di Modul 3.1 menjadi **daftar periksa review** di sini. `grep -R "Quickshell.Services" components/ modules/` adalah alat yang sama, digunakan dengan disiplin yang lebih ketat.
- **Modul 3.2:** Binding loop yang Anda pelajari di Modul 3.2 adalah salah satu hal yang diperiksa oleh smoke test (log bersih dari `Binding loop detected`) dan daftar periksa review (tidak ada binding yang menulis balik ke sumbernya).
- **Fase berikutnya:** Modul 3.3 adalah **fondasi kualitas** untuk semua fase berikutnya. Ketika Anda membangun fitur yang lebih kompleks (notifikasi, launcher, lock screen), smoke test dan daftar periksa review akan menjadi **jaring pengaman** yang menangkap regresi sebelum Anda kehilangan akses ke sesi. Di Modul 5.3 (sesuai kurikulum), Anda akan memperdalam integrasi CI dan otomatisasi.

---

### 11. Referensi Lengkap

- **Qt — `qmllint` (dokumentasi resmi):** https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html — dokumentasi lengkap `qmllint`, kategori peringatan, dan konfigurasi.
- **Qt — `qmllint` (archives Qt 6.6):** https://doc.qt.io/archives/qt-6.6/qtquick-tool-qmllint.html — versi arsip dengan penjelasan konfigurasi `.qmllint.ini` dan inline directives.
- **Qt — QML Lint Warning and Errors:** https://doc.qt.io/qt-6/qmllint-warnings-and-errors.html — panduan memperbaiki setiap kategori peringatan `qmllint`.
- **Qt — `qmlformat`:** https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html — alat formatter QML untuk konsistensi gaya.
- **Quickshell — `Process`:** https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/Process — dokumentasi `Process`, `command` sebagai daftar, `clearEnvironment`, dan peringatan shell injection.
- **Quickshell — Migration Guide (Process API):** https://programmersd21.github.io/the_quickshell_book/ — penjelasan perubahan API `Process` dari string ke array argumen (v0.2.0+) untuk menghindari shell injection.
- **DeepWiki — IO and IPC Subsystems:** https://deepwiki.com/quickshell-mirror/quickshell/7-development-and-contributing — detail implementasi `Process` di Quickshell, termasuk `clearEnvironment` dan lifecycle management.
- **QML Linting: Why You Shouldn't Skip It:** https://runebook.dev/en/docs/qt/cmake-source-file-property-qt-qml-skip-qmllint — artikel praktik terbaik tentang integrasi `qmllint` ke pre-commit hook dan build.
- **Caelestia — Smoke test di CI:** https://atomgit.com/gh_mirrors/shell78/shell/blob/main/.github/workflows/update-flake-inputs.yml — contoh nyata smoke test Sway headless di CI.
- **Sway — Wiki:** https://github.com/swaywm/sway/wiki — dokumentasi Sway, termasuk opsi headless dan konfigurasi minimal.
- **wlroots — Environment variables:** https://gitlab.freedesktop.org/wlroots/wlroots — dokumentasi `WLR_BACKENDS`, `WLR_LIBINPUT_NO_DEVICES`, dan variabel headless lainnya.
- **pre-commit framework:** https://pre-commit.com/ — framework untuk mengelola git hook (opsional, tetapi direkomendasikan untuk proyek yang lebih besar).

---

### 12. Tips dan Praktik Terbaik

1. **Jalankan `qmllint` pada setiap file QML, bukan hanya `shell.qml`.** Gunakan `find . -name '*.qml' -exec qmllint {} \;` atau integrasikan ke build system. Shell terdiri dari banyak file; memeriksa satu file tidak cukup.

2. **Naikkan peringatan penting menjadi `error` di `.qmllint.ini`.** `Unqualified`, `UnusedImports`, dan `BadSignalHandler` adalah kandidat kuat untuk dijadikan `error`. Jangan biarkan warning menumpuk; mereka akan tenggelam dalam noise.

3. **Gunakan `// qmllint disable` dengan kategori spesifik, bukan menonaktifkan semua.** Dokumentasi Qt menyarankan menyebutkan kategori yang ingin dinonaktifkan. Menonaktifkan semua peringatan di suatu blok adalah tanda bahwa Anda menyerah pada kualitas di area itu.

4. **Aktifkan kategori `Compiler` untuk menangkap kode yang tidak bisa dikompilasi.** Ini membantu performa dan memastikan shell Anda dapat dioptimalkan oleh `qmlsc`.

5. **Selalu gunakan `timeout` di smoke test.** Shell yang menggantung karena binding loop atau deadlock bisa berjalan selamanya tanpa `timeout`. Batasi durasi pengujian.

6. **Selalu bersihkan proses dengan `trap`.** Jika smoke test gagal di tengah jalan, proses Sway dan Quickshell harus tetap dimatikan. Gunakan `trap 'kill $SWAY 2>/dev/null' EXIT` untuk memastikan pembersihan.

7. **Periksa log dan proses, bukan hanya salah satunya.** Log menangkap error yang dicetak; proses menangkap crash yang tidak meninggalkan log. Keduanya adalah sinyal yang berbeda dan berharga.

8. **Jadikan pre-commit hook cepat.** Hook yang lambat membuat Anda tergoda untuk menggunakan `--no-verify`. Jalankan `qmllint` hanya pada file yang di-stage, bukan seluruh codebase, dan simpan smoke test yang lebih berat untuk CI.

9. **Jangan pernah melewati daftar periksa review hanya karena "perubahannya kecil".** Perubahan kecil bisa menjadi penyebab regresi besar. Daftar periksa adalah **pengingat**, bukan birokrasi; ia memastikan Anda memikirkan hal yang sama setiap kali.

10. **Dokumentasikan keputusan desain saat Anda membuatnya.** Jangan menunggu sampai Anda lupa. Catatan singkat 3–5 baris per modul akan menghemat waktu Anda di masa depan dan membantu auditor memahami niat Anda.

---

### 13. Potensi Kesalahan Umum dan Solusi

| Kesalahan | Gejala | Penyebab | Solusi |
|---|---|---|---|
| **Mengabaikan warning `qmllint` karena "masih jalan"** | Kode menumpuk masalah; performa menurun; sulit dioptimalkan | Warning tidak menggagalkan build | Naikkan menjadi `error` di `.qmllint.ini`; perbaiki sebelum commit. |
| **Smoke test berjalan selamanya** | CI menggantung; tidak ada feedback | Tidak ada `timeout` | Selalu gunakan `timeout` pada perintah Quickshell. |
| **Proses Sway/Quickshell tertinggal setelah smoke test** | Port/socket bentrok pada pengujian berikutnya | Tidak ada pembersihan | Gunakan `trap` untuk memastikan `kill` berjalan. |
| **`Process` menggunakan string shell** | Potensi shell injection; argumen dengan spasi rusak | `command: "echo hello"` bukan `["echo", "hello"]` | Selalu gunakan daftar argumen. |
| **Kredensial tercetak di log** | Token/kata sandi terlihat di `journalctl` atau file log | Tidak ada audit log | Redaksi data sensitif; jangan pernah mencatat kredensial. |
| **Pre-commit hook terlalu lambat** | Menggunakan `--no-verify`; hook dilewati | Menjalankan linting seluruh codebase | Hanya lint file yang di-stage; pindahkan pengujian berat ke CI. |
| **Smoke test tidak pernah dijalankan** | Regresi lolos ke sesi utama | Hook/CI tidak dikonfigurasi | Integrasikan ke pre-commit dan CI; jadikan bagian dari alur kerja. |
| **Daftar periksa review diabaikan** | Kebocoran arsitektur, kredensial, atau binding loop lolos | Tidak ada kebiasaan review | Biasakan menjawab lima pertanyaan setiap perubahan; dokumentasikan jawabannya. |

---

### Motivasi

Kualitas bukan tentang kesempurnaan; ia tentang **kejujuran**. Setiap kali Anda menjalankan `qmllint`, setiap kali Anda menjalankan smoke test, setiap kali Anda menjawab daftar periksa review, Anda sedang berkata kepada diri Anda sendiri: "Saya tidak akan menipu diri sendiri bahwa kode ini benar hanya karena ia berjalan sekali." Shell yang baik dibangun oleh orang yang **tidak percaya pada ingatannya sendiri** — dan karena itu, membangun sistem yang mengingatkannya. Hari ini Anda membangun sistem itu. Besok, sistem itu akan menyelamatkan Anda.

---

### Selamat!

Modul 3.3 selesai. Anda telah menyelesaikan seluruh dari Fase 3 : Anda memiliki **arsitektur** (3.1), **perilaku** (3.2), dan **penjagaan kualitas** (3.3).

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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

