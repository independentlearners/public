# FASE 0 — Fondasi: Linux, Wayland, QML, dan Qt6

**Level:** Pemula · **Estimasi:** 5–7 minggu · **Prasyarat:** Arch Linux terpasang (atau VM dari Fase −1.3) dan terminal dasar.

Fase ini adalah **lapisan batuan** tempat seluruh shell Anda berdiri. Setiap modul di sini akan dipakai berulang kali di Fase 1–5. Kesalahan memahami fondasi akan muncul sebagai bug yang sulit dilacak di Fase 2 dan seterusnya. Jangan terburu-buru.

**Struktur Pembelajaran Fase 0:**
1. **Modul 0.1** — Arch Linux, Keamanan Wayland, dan Higiene AUR
2. **Modul 0.2** — QML: Bahasa Deklaratif untuk Antarmuka
3. **Modul 0.3** — Qt6 dan QtQuick: Fondasi di Balik Quickshell
4. **Modul 0.4** — JavaScript di QML, Animasi, dan Membaca Referensi

**Hubungan dengan modul lain:** 0.1 memberi Anda **lingkungan dan model ancaman**; 0.2 memberi **bahasa** untuk menulis shell; 0.3 memberi **mesin** yang menjalankannya; 0.4 memberi **keterampilan meta** untuk memecahkan masalah sendiri. Tanpa 0.4, Anda akan bergantung pada contoh orang lain selamanya.

---

## Modul 0.1 — Arch Linux, Keamanan Wayland, dan Higiene AUR

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membangun **lingkungan kerja keyboard-driven** di Arch Linux (shell, multiplexer, `pacman`), memahami **model keamanan Wayland** (isolasi input, protokol istimewa, `security-context`), dan menerapkan **kebiasaan audit AUR** sebelum memasang `quickshell-git`. Peran praktisnya: setelah modul ini, Anda memiliki sistem yang **dapat diaudit**, **terisolasi secara default**, dan **tidak bergantung pada GUI yang tidak transparan**.

### 2. Konsep Kunci & Filosofi Mendalam

**Analogi:** Compositor Wayland adalah **manajer gedung** yang mengendalikan semua pintu dan jendela. Aplikasi adalah penyewa yang tidak boleh mengintip unit lain. Di X11, setiap penyewa punya kunci master untuk semua pintu; di Wayland, kunci master hanya dipegang manajer gedung.

**Mengapa Wayland lebih aman secara default:**
Di X11, klien mana pun dapat membaca input keyboard global dan menangkap layar klien lain — ini adalah desain, bukan bug. Di Wayland, compositor memegang rendering dan input. Klien hanya menerima event yang ditujukan kepadanya. **Isolasi input adalah bawaan**. Namun, **protokol istimewa** seperti `zwlr_layer_shell_v1` (panel), `ext-session-lock-v1` (lockscreen), `screencopy`, dan `virtual-keyboard` memberi kuasa lebih. Compositor dapat membatasi siapa yang boleh memakainya, tetapi dukungan `security-context-v1` berbeda antar compositor.

**Filosofi higiene AUR:** PKGBUILD adalah **skrip yang berjalan dengan hak akses Anda**. Di AUR, skrip ini ditulis pihak ketiga dan **tidak dikurasi**. "Membaca sebelum membangun" bukan paranoia; itu adalah bentuk **least privilege kognitif**: Anda hanya memberikan kepercayaan setelah verifikasi.

### 3. Sintaks Dasar / Contoh Implementasi Inti

**Contoh 1 — Memeriksa sesi dan protokol.**

```bash
echo $XDG_SESSION_TYPE
wayland-info | grep -E 'layer_shell|session_lock|security_context'
```

*Penjelasan kata demi kata:*

- `echo` — mencetak teks ke terminal.
- `$XDG_SESSION_TYPE` — variabel lingkungan yang diatur compositor; nilainya `wayland` bila sesi berjalan di Wayland.
- `|` — pipe; mengalihkan stdout program kiri ke stdin program kanan.
- `grep` — menyaring baris yang cocok dengan pola.
- `-E` — mengaktifkan extended regular expression, sehingga `|` di dalam pola berarti "atau".
- `layer_shell` — nama protokol `zwlr_layer_shell_v1` (panel).
- `session_lock` — protokol `ext-session-lock-v1` (lockscreen).
- `security_context` — protokol `security-context-v1` (pembatasan klien).

**Contoh 2 — Audit PKGBUILD AUR.**

```bash
git clone https://aur.archlinux.org/quickshell-git.git
cd quickshell-git
less PKGBUILD
git log --stat
pkgctl build
```

*Penjelasan:*

- `git clone` — menyalin repositori AUR ke lokal.
- `cd` — berpindah direktori.
- `less PKGBUILD` — membuka berkas PKGBUILD dengan pager; Anda memeriksa `source=`, `sha256sums=`, `build()`, `package()`, dan berkas `.install`.
- `git log --stat` — melihat riwayat commit beserta berkas yang berubah; commit mencurigakan sering terlihat di sini.
- `pkgctl build` — dari paket `devtools`; membangun di **chroot bersih** sehingga dependensi build tidak mencemari sistem host. Alternatif: `makepkg -si` (langsung di host, kurang terisolasi).

**Opsi alternatif untuk audit AUR:**

| Perintah | Tujuan |
|---|---|
| `namcap PKGBUILD` | Memeriksa kesalahan umum dan dependensi yang hilang. |
| `shellcheck PKGBUILD` | Menganalisis skrip shell untuk pola berbahaya. |
| `git diff HEAD~5..HEAD -- PKGBUILD` | Melihat perubahan PKGBUILD dalam lima commit terakhir. |
| `makepkg --printsrcinfo` | Menampilkan metadata paket tanpa membangun. |

### 4. Terminologi Esensial & Penjelasan Detil

- **Wayland:** Protokol display modern; compositor memegang rendering dan input. Pengganti X11.
- **Compositor:** Program yang mengelola jendela, input, dan rendering (Hyprland, Sway, Niri). Di Wayland, compositor adalah **server display**.
- **Protokol istimewa:** Ekstensi Wayland yang memberi kuasa lebih dari sekadar menggambar jendela. Contoh: `zwlr_layer_shell_v1` (panel), `ext-session-lock-v1` (lockscreen), `zwlr_screencopy_manager_v1` (tangkapan layar), `zwp_virtual_keyboard_manager_v1` (keyboard virtual).
- **XDG Base Directory:** Standar lokasi konfigurasi (`~/.config`), data (`~/.local/share`), cache (`~/.cache`), dan state (`~/.local/state`). Quickshell memakai standar ini untuk mencari konfigurasi.
- **PKGBUILD:** Skrip build paket Arch. Di repositori resmi, dikurasi; di AUR, ditulis pengguna dan **tidak dikurasi**.
- **`security-context-v1`:** Protokol yang memungkinkan compositor membatasi klien berdasarkan konteks keamanan (mis. sandbox). Dukungan berbeda antar compositor.
- **Chroot bersih:** Lingkungan build terisolasi yang hanya berisi dependensi minimal; mencegah PKGBUILD berbahaya menyentuh `$HOME` atau sistem host.

### 5. Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. Instalasi Arch dan `base-devel`.
2. `pacman`, AUR, dan higiene AUR (audit PKGBUILD, chroot bersih).
3. Shell scripting untuk otomatisasi (`bash`/`zsh`).
4. `tmux`: sesi, pane, keybinding.
5. Arsitektur Wayland dan implikasi keamanannya (isolasi input, protokol istimewa, `security-context`).

### 6. Rekomendasi Visualisasi (ASCII)

```text
Shell/Aplikasi (klien) ──protokol Wayland──► Compositor ──DRM/KMS + libinput──► Kernel ──► GPU · Layar · Input
        ▲                                        │
        └────── event input (hanya ke yang fokus) ┘

Batas keamanan:
[Klien A]  [Klien B]  [Klien C]     ← tidak bisa saling mengintip input/layar
     \        |        /
      \       |       /
    ┌──▼──────▼──────▼──┐
    │   Compositor      │  ← memegang semua input & rendering
    │  (Hyprland/Sway)  │
    └────────┬──────────┘
             │ protokol istimewa (layer-shell, screencopy, lock)
             ▼
    [Klien dengan izin khusus]  ← risiko bila tidak diaudit
```

### 7. Hubungan dengan Modul Lain

- **0.1 → 0.2:** Lingkungan Arch dan terminal yang siap adalah prasyarat untuk menjalankan `quickshell -p hello.qml`.
- **0.1 → 1.1:** Struktur `~/.config` dan `$XDG_CONFIG_DIRS` yang dipelajari di sini langsung dipakai Quickshell untuk mencari `shell.qml`.
- **0.1 → 2.1:** Pemahaman protokol Wayland dan layer-shell adalah fondasi untuk `PanelWindow` dan `WlrLayershell`.
- **0.1 → 4.1:** Model ancaman dan higiene AUR adalah benang merah menuju threat model dan sandbox.

### 8. Sumber Referensi Lengkap

- [Arch Wiki: Installation guide](https://wiki.archlinux.org/title/Installation_guide)
- [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland)
- [Arch Wiki: AUR](https://wiki.archlinux.org/title/Arch_User_Repository)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)
- [Protokol security-context-v1](https://wayland.app/protocols/security-context-v1)
- [Arch Wiki: Bubblewrap](https://wiki.archlinux.org/title/Bubblewrap) (untuk Modul 4.1)

### 9. Tips dan Praktik Terbaik

- **Selalu `git log --stat` sebelum `makepkg`.** Perubahan PKGBUILD yang mencurigakan sering terlihat sebagai commit yang menambahkan `curl | bash` atau mengubah `source=` ke URL non-resmi.
- **Gunakan `pkgctl build` untuk paket AUR yang belum Anda percayai.** Chroot bersih mencegah PKGBUILD menyentuh `$HOME` atau menginstal dependensi berbahaya ke sistem host.
- **Jangan pernah menjalankan `makepkg` sebagai root.** `makepkg` menolak, tetapi jangan mencoba mengakalinya.
- **Periksa `wayland-info` setelah setiap pembaruan compositor.** Protokol yang tersedia bisa berubah; shell Anda harus menyesuaikan.

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menjalankan `quickshell` di sesi X11 | Quickshell gagal atau berperilaku aneh | Periksa `echo $XDG_SESSION_TYPE`; pastikan `wayland`. |
| Memasang `quickshell-git` tanpa audit | Risiko rantai pasok | Audit PKGBUILD, gunakan chroot bersih. |
| Mengira AUR "resmi" | Rasa aman palsu | AUR adalah repositori pengguna; tidak ada kurasi. |
| Tidak memeriksa protokol `ext-session-lock-v1` | Lockscreen tidak berfungsi di compositor tertentu | Jalankan `wayland-info | grep session_lock` sebelum membangun lockscreen. |

### 11. Latihan dan Checkpoint

**Latihan:** Jalankan `wayland-info` dan catat protokol yang tersedia di compositor Anda. Audit satu PKGBUILD AUR (boleh `quickshell-git`) dan tulis tiga hal yang Anda periksa.

**Checkpoint:** Jelaskan mengapa klien Wayland biasa tidak dapat membaca ketikan klien lain, dan protokol mana yang mengecualikan hal itu.

**Jawaban checkpoint:** Karena di Wayland, compositor adalah satu-satunya yang menerima event input dari kernel dan hanya meneruskannya ke klien yang fokus. Pengecualian: protokol seperti `zwp_virtual_keyboard_manager_v1` (keyboard virtual) dan `zwlr_screencopy_manager_v1` (tangkapan layar) memberi klien kemampuan istimewa — dan compositor dapat membatasinya lewat `security-context` atau kebijakan internal.

### 12. Motivasi

> *"Sistem yang Anda pahami sampai ke akarnya adalah sistem yang tidak bisa menipu Anda. Hari ini Anda belajar membaca jejak — besok Anda akan menulis aturannya sendiri."*

---

## Modul 0.2 — QML: Bahasa Deklaratif untuk Antarmuka

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan **sintaks QML dari nol**: properti, binding, signal, komponen, layout, dan model-view-delegate. QML adalah bahasa yang mendeskripsikan **apa** yang tampak dan **bagaimana** ia bereaksi, bukan **bagaimana** menggambarnya langkah demi langkah. Perannya: setelah modul ini, Anda dapat menulis jendela Quickshell sederhana dan memahami mengapa teks berubah tanpa Anda memanggil fungsi apa pun.

### 2. Konsep Kunci & Filosofi Mendalam

**Analogi:** QML seperti **lembar kerja spreadsheet**. Sel A1 berisi `=B1+C1`. Ketika B1 berubah, A1 otomatis dihitung ulang. Anda tidak menulis "setelah B1 berubah, panggil fungsi untuk memperbarui A1" — Anda **mendeklarasikan hubungan**, dan runtime mengurus pembaruan.

**Property binding adalah inti reaktivitas QML.** Ini bukan sekadar "variabel yang diperbarui"; ini adalah **graf dependensi** yang dilacak runtime. Ketika ekspresi `text: 'Count: ' + counter` dievaluasi, QML mencatat bahwa `text` bergantung pada `counter`. Ketika `counter` berubah, QML menandai `text` kotor dan menghitung ulang pada frame berikutnya. Tidak ada polling, tidak ada `setText()` manual.

**Deklaratif vs imperatif:**
- **Deklaratif:** "Text ini menampilkan `counter`." Anda mendeskripsikan keadaan yang diinginkan.
- **Imperatif:** "Ketika tombol diklik, ambil nilai counter, tambah satu, lalu panggil `setText`." Anda mendeskripsikan langkah-langkah.

QML menggabungkan keduanya: **binding untuk keadaan**, **handler untuk aksi**. Ini adalah pembagian kerja yang bersih dan menjadi fondasi arsitektur shell Anda nanti.

### 3. Sintaks Dasar / Contoh Implementasi Inti

**Contoh 1 — Jendela Quickshell pertama.**

```qml
// hello.qml — jalankan: quickshell -p hello.qml
import QtQuick
import Quickshell

FloatingWindow {
    implicitWidth: 240; implicitHeight: 100
    color: 'black'
    Text { anchors.centerIn: parent; text: 'Halo, Quickshell'; color: 'white' }
}
```

*Penjelasan kata demi kata:*

- `import QtQuick` — mengimpor modul QtQuick yang menyediakan `Text`, `Rectangle`, `Item`, dll.
- `import Quickshell` — mengimpor modul Quickshell yang menyediakan `FloatingWindow`, `PanelWindow`, `ShellRoot`, dll.
- `FloatingWindow { ... }` — mendeklarasikan objek root bertipe `FloatingWindow`. Quickshell **mewajibkan** root berkas berupa window (`FloatingWindow`/`PanelWindow`); `Rectangle` polos tidak bisa dijalankan sebagai program Quickshell.
- `implicitWidth: 240` — lebar yang disarankan; window dapat membesar bila konten memaksa.
- `;` — pemisah pernyataan; dalam QML, baris baru biasanya cukup, tetapi `;` memungkinkan dua properti pada satu baris.
- `color: 'black'` — properti `color` dari `FloatingWindow`; latar belakang jendela.
- `Text { ... }` — objek anak; secara otomatis menjadi child dari `FloatingWindow`.
- `anchors.centerIn: parent` — menempelkan `Text` ke tengah parent (`FloatingWindow`). `anchors` adalah sistem penempatan QML.
- `text: 'Halo, Quickshell'` — properti `text` dari `Text`; string literal.
- `color: 'white'` — warna teks.

**Contoh 2 — Binding dan signal handler.**

```qml
Text {
    property int counter: 0
    text: 'Count: ' + counter
    color: 'white'
    MouseArea { anchors.fill: parent; onClicked: parent.counter += 1 }
}
```

*Penjelasan:*

- `property int counter: 0` — mendeklarasikan **properti kustom** `counter` bertipe `int` dengan nilai awal `0`. Properti ini dapat di-bind dan diubah dari luar.
- `text: 'Count: ' + counter` — **binding**. Ekspresi ini bergantung pada `counter`. Ketika `counter` berubah, `text` dihitung ulang otomatis. Tidak ada `onCounterChanged` yang perlu ditulis.
- `MouseArea { ... }` — area tak terlihat yang menangkap event mouse.
- `anchors.fill: parent` — mengisi seluruh parent (`Text`). `parent` di sini adalah `Text` karena `MouseArea` adalah anak `Text`.
- `onClicked: parent.counter += 1` — **signal handler** untuk sinyal `clicked`. `parent` mengacu pada `Text` (induk `MouseArea`), sehingga `parent.counter` adalah properti `counter` dari `Text`. `+= 1` menambah satu. Setelah perubahan ini, binding `text` otomatis diperbarui.

**Contoh 3 — Layout dan model-view-delegate.**

```qml
import QtQuick.Layouts
RowLayout {
    spacing: 8
    Repeater {
        model: ['alpha', 'beta', 'gamma']
        delegate: Text { required property string modelData; text: modelData; color: 'white' }
    }
}
```

*Penjelasan:*

- `import QtQuick.Layouts` — mengimpor modul layout (`RowLayout`, `ColumnLayout`, `GridLayout`).
- `RowLayout { ... }` — menata anak secara horizontal dengan ukuran fleksibel.
- `spacing: 8` — jarak antar anak dalam piksel.
- `Repeater { ... }` — **positioner** yang membuat satu instance `delegate` untuk setiap elemen `model`.
- `model: ['alpha', 'beta', 'gamma']` — model berupa array JavaScript. Setiap elemen menjadi `modelData` di delegate.
- `delegate: Text { ... }` — komponen yang dibuat berulang.
- `required property string modelData` — **wajib** dideklarasikan `required` agar QML meng-inject nilai dari model. Tanpa `required`, `modelData` tidak terdefinisi di QML modern. Tipe `string` memastikan nilai diperlakukan sebagai string.
- `text: modelData` — menampilkan nilai dari model.
- `color: 'white'` — warna teks.

**Opsi alternatif untuk logika yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Menampilkan daftar statis | `Repeater` + `Row`/`Column` | Paling sederhana; semua item dibuat sekaligus. |
| Daftar panjang yang dapat di-scroll | `ListView` | Hanya item yang terlihat yang dibuat (virtualisasi). |
| Daftar dengan data dinamis | `Repeater` + `ListModel` | `ListModel` dapat diubah dari JavaScript. |
| Daftar dengan filter/pencarian | `ScriptModel` (Quickshell) | Nilai dihitung dari ekspresi JS dan diperbarui efisien; diperkenalkan di Modul 2.4. |

### 4. Terminologi Esensial & Penjelasan Detil

- **QML:** Bahasa deklaratif untuk UI; setiap elemen adalah objek dengan properti.
- **Property binding:** Ekspresi yang dihitung ulang saat dependensinya berubah. Inti reaktivitas QML.
- **Signal:** Notifikasi bahwa sesuatu terjadi (`clicked`, `pressed`, `textChanged`).
- **Signal handler:** Blok kode yang merespons sinyal (`onClicked: { ... }`).
- **Anchors:** Aturan penempelan elemen ke elemen lain atau induknya (`anchors.fill`, `anchors.centerIn`, `anchors.top`).
- **Positioner:** `Row`, `Column`, `Grid`, `Flow` — menata anak berurutan tanpa ukuran fleksibel.
- **Layout:** `RowLayout`, `ColumnLayout`, `GridLayout` (dari `QtQuick.Layouts`) — menata dengan ukuran fleksibel dan `Layout.*` attached properties.
- **Model-View-Delegate:** Pola di mana `model` adalah data, `View` (atau `Repeater`) adalah penyaji, dan `delegate` adalah tampilan satu item.
- **`required property`:** Deklarasi properti yang **harus** diisi dari luar (oleh model atau parent). Tanpa `required`, properti memiliki nilai default dan tidak ter-inject dengan benar dalam konteks model.
- **`implicitWidth` / `implicitHeight`:** Ukuran yang disarankan; berbeda dari `width`/`height` yang merupakan ukuran aktual.

### 5. Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. Sintaks dasar dan struktur berkas `.qml`.
2. Properti, tipe data, dan binding.
3. Signal dan signal handler.
4. Anchors, positioner, dan layout.
5. Model-View-Delegate (`Repeater`, `ListView`).
6. Komponen inline dan berkas komponen terpisah.

### 6. Rekomendasi Visualisasi (ASCII)

```text
FloatingWindow
└─ Text  (text ← terikat ke counter)
   └─ MouseArea (onClicked → counter += 1 → binding menghitung ulang text)

Graf dependensi binding:
counter ──► text: 'Count: ' + counter
   ▲                    │
   │                    ▼
onClicked ──────► (diperbarui otomatis)
```

### 7. Hubungan dengan Modul Lain

- **0.2 → 0.4:** Binding dan signal adalah fondasi untuk animasi (`Behavior`) dan `Component.onCompleted` yang dibahas di 0.4.
- **0.2 → 1.2:** `PanelWindow` dan `SystemClock` memakai binding yang sama; jam diperbarui karena `clock.date` berubah dan `text` terikat padanya.
- **0.2 → 3.2:** Binding loop dan `Connections` adalah pendalaman dari mekanisme binding yang dipelajari di sini.

### 8. Sumber Referensi Lengkap

- [Qt QML Documentation](https://doc.qt.io/qt-6/qmlapplications.html)
- [Qt: QML Language](https://doc.qt.io/qt-6/qtqml-language.html)
- [Qt: Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)
- [Qt Academy](https://www.qt.io/academy) — kursus QML gratis
- [Quickshell: QML Language Guide](https://quickshell.org/docs/guide/qml-language)

### 9. Tips dan Praktik Terbaik

- **Gunakan `required property` di delegate.** Ini bukan opsional di QML modern; tanpa `required`, `modelData` tidak ter-inject dengan benar.
- **Jangan menulis `onCounterChanged: text = ...`.** Binding sudah melakukan itu. Menambahkan handler imperatif untuk hal yang sama akan menyebabkan **binding loop** atau pembaruan ganda.
- **Bedakan `width` dan `implicitWidth`.** `width` adalah ukuran aktual; `implicitWidth` adalah saran. Layout memakai `implicitWidth` untuk menghitung ukuran.
- **Gunakan `Layout.fillWidth: true` di dalam `RowLayout`** untuk membuat elemen mengisi ruang tersisa.

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menjalankan `Rectangle` sebagai root Quickshell | Error: root harus window | Gunakan `FloatingWindow` atau `PanelWindow`; atau jalankan dengan `qml6` (Qt) untuk menguji komponen UI murni. |
| Lupa `required` pada `modelData` | Delegate menampilkan `undefined` | Tambahkan `required property string modelData`. |
| Menulis `text = '...'` alih-alih `text: '...'` | Error sintaks | QML memakai `:` untuk binding, bukan `=`. |
| Binding loop | Peringatan "Binding loop detected" di log | Periksa apakah dua properti saling bergantung; gunakan `onMoved` atau `Binding { when: ... }`. |

### 11. Latihan dan Checkpoint

**Latihan:** Buat jendela dengan tiga tombol (tambah, kurang, reset) untuk sebuah counter. Tampilkan nilai counter di `Text`.

**Checkpoint:** Jelaskan mengapa teks berubah tanpa Anda memanggil fungsi apa pun.

**Jawaban ringkas:** Karena `text` adalah **binding** yang bergantung pada `counter`. Ketika `counter` diubah oleh handler `onClicked`, QML menandai binding `text` kotor dan menghitung ulang secara otomatis pada frame berikutnya. Tidak ada pemanggilan fungsi eksplisit; reaktivitas adalah bawaan QML.

### 12. Motivasi

> *"Setiap baris QML yang Anda tulis adalah pernyataan tentang bagaimana dunia seharusnya bekerja. Mulailah dari yang kecil — satu binding, satu signal — dan biarkan sistem bekerja untuk Anda."*

---

## Modul 0.3 — Qt6 dan QtQuick: Fondasi di Balik Quickshell

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menjelaskan **Qt6 sebagai framework C++** di balik Quickshell dan **QtQuick sebagai modul rendering**: window, efek, animasi, dan scene graph. Perannya: setelah modul ini, Anda memahami **mengapa** Quickshell memilih QtQuick, **apa** yang terjadi saat Anda menulis `MultiEffect`, dan **batas** antara apa yang bisa dilakukan QML dan apa yang harus diserahkan ke compositor.

### 2. Konsep Kunci & Filosofi Mendalam

**Analogi:** Qt adalah **mesin dan rangka mobil**; QML adalah **dasbor dan setir** yang Anda pegang. Anda tidak perlu tahu cara kerja mesin untuk mengemudi, tetapi pemahaman dasar tentang mesin membantu Anda mengenali kapan mobil perlu servis dan kapan Anda harus berhenti menginjak gas.

**QtQuick menggambar lewat scene graph yang dipercepat GPU.** Setiap item QML (Rectangle, Text, Image) menjadi node dalam pohon scene graph. Renderer QtQuick mengubah pohon ini menjadi perintah GPU. Sejak Qt 6.0, model rendering berbasis RHI menjadi default, dan tidak ada opsi untuk kembali ke OpenGL langsung. Memahami ini membantu Anda:
- Mengenali mengapa **overdraw** (menggambar piksel yang sama berulang kali) mahal.
- Memahami mengapa `MultiEffect` **hanya mengaburkan isi item Anda sendiri**, bukan latar di belakang jendela — mengaburkan latar adalah urusan compositor (mis. blur layer di Hyprland).
- Memilih antara efek yang dipercepat GPU dan efek yang memaksa render ke CPU.

**Mengapa Quickshell memilih QtQuick, bukan QtWidgets:**
- QtWidgets dirancang untuk aplikasi desktop tradisional dengan kontrol native; sulit dikustomisasi secara mendalam.
- QtQuick dirancang untuk UI dinamis dengan animasi, transisi, dan efek GPU; deklaratif dan sangat dapat dikustomisasi.
- Quickshell membutuhkan **kontrol piksel penuh** dan **integrasi Wayland** (layer-shell, lockscreen) yang tidak disediakan QtWidgets.

### 3. Sintaks Dasar / Contoh Implementasi Inti

**Contoh 1 — Memasang modul Qt6 yang relevan.**

```bash
sudo pacman -S qt6-svg qt6-imageformats qt6-multimedia qt6-5compat
```

*Penjelasan:*

- `qt6-svg` — dukungan rendering SVG (ikon vektor). Qt 6.8 memperkenalkan `VectorImage` untuk menampilkan SVG langsung di scene graph.
- `qt6-imageformats` — format gambar tambahan (WebP, AVIF, dll.).
- `qt6-multimedia` — pemutaran audio/video; relevan untuk widget media.
- `qt6-5compat` — kompatibilitas dengan API Qt5; menyediakan efek lama seperti `GaussianBlur` (meskipun `MultiEffect` lebih disarankan di Qt6).

**Contoh 2 — `MultiEffect` untuk bayangan/blur.**

```qml
import QtQuick
import QtQuick.Effects

Item {
    width: 120; height: 120
    Rectangle { id: src; anchors.fill: parent; color: 'royalblue'; radius: 16; visible: false }
    MultiEffect { source: src; anchors.fill: src; blurEnabled: true; blurMax: 32; blur: 1.0 }
}
```

*Penjelasan kata demi kata:*

- `import QtQuick.Effects` — mengimpor modul efek Qt6 (`MultiEffect`, `DropShadow`, dll.).
- `Item { ... }` — kontainer tak terlihat dengan ukuran.
- `Rectangle { id: src; ... }` — **sumber efek**. `id: src` memberi nama agar dapat dirujuk. `visible: false` menyembunyikan Rectangle asli; hanya efek yang terlihat.
- `MultiEffect { ... }` — efek visual. `source: src` menunjuk ke Rectangle sumber. **Penting:** `source` **tidak boleh** menjadi induk dari `MultiEffect` itu sendiri; itu akan menciptakan siklus. `source` harus item **saudara** atau item lain yang bukan induk.
- `anchors.fill: src` — efek mengisi area yang sama dengan sumber.
- `blurEnabled: true` — mengaktifkan blur.
- `blurMax: 32` — radius blur maksimum dalam piksel.
- `blur: 1.0` — kekuatan blur (0.0–1.0).

**Opsi alternatif untuk efek visual:**

| Efek | Pendekatan Qt6 | Catatan |
|---|---|---|
| Blur | `MultiEffect { blurEnabled: true }` | Dipercepat GPU; hanya isi item sendiri. |
| Bayangan | `MultiEffect { shadowEnabled: true }` atau `DropShadow` | `DropShadow` lebih sederhana untuk bayangan saja. |
| Blur latar belakang jendela | Aturan compositor (mis. `blurls` di Hyprland) | Bukan tugas QML; compositor yang mengaburkan layer di belakang jendela. |
| Efek lama Qt5 | `qt6-5compat` (`GaussianBlur`) | Lebih lambat; gunakan hanya bila `MultiEffect` tidak mencukupi. |

### 4. Terminologi Esensial & Penjelasan Detil

- **Qt6:** Framework C++ lintas platform untuk UI, jaringan, multimedia, dan lainnya. Quickshell dibangun di atasnya.
- **QtQuick:** Modul Qt untuk UI dinamis dengan QML. Menggambar lewat scene graph yang dipercepat GPU.
- **Scene graph:** Struktur data pohon yang merepresentasikan semua item visual; dioptimalkan untuk rendering GPU.
- **`MultiEffect`:** Efek visual modern Qt6 (blur, shadow, mask); lebih efisien daripada efek lama di `qt5compat`.
- **Overdraw:** Menggambar piksel yang sama berulang kali; harus diminimalkan. Dapat divisualisasikan dengan `QSG_VISUALIZE=overdraw`.
- **GPU acceleration:** Rendering yang memakai GPU, bukan CPU; lebih cepat untuk animasi dan efek.
- **`visible: false`:** Menyembunyikan item dari rendering tetapi tetap membuatnya ada di scene graph; berguna untuk sumber efek.

### 5. Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. Arsitektur Qt6 dan modul-modulnya.
2. QtQuick vs QtWidgets (mengapa Quickshell memilih QtQuick).
3. Modul Qt6 yang relevan (`qt6-svg`, `qt6-wayland`, `qt6-multimedia`).
4. Efek visual: `MultiEffect` dan `qt5compat`.
5. Jendela transparan: `color: 'transparent'` dan peran compositor untuk blur latar.
6. Sistem resource Qt dan cara Quickshell memuat berkas QML.

### 6. Rekomendasi Visualisasi (ASCII)

```text
QML (deklaratif)
   │
   ▼
QtQuick scene graph (pohon item)
   │
   ▼
Renderer QtQuick ──► GPU (OpenGL/Vulkan/RHI) ──► Layar
   │
   └─ MultiEffect: efek pada isi item sendiri
      (bukan latar di belakang jendela — itu urusan compositor)

Batas tanggung jawab:
QML/QtQuick: isi jendela Anda
Compositor: latar di belakang jendela, blur layer, posisi panel
```

### 7. Hubungan dengan Modul Lain

- **0.3 → 0.4:** `MultiEffect` dan animasi adalah alat yang akan Anda pakai di 0.4 untuk membuat UI dinamis.
- **0.3 → 2.1:** Memahami bahwa blur latar adalah urusan compositor menjelaskan mengapa `PanelWindow` memakai `color: 'transparent'` dan mengandalkan aturan layer compositor.
- **0.3 → 5.2:** Overdraw dan scene graph adalah dasar untuk optimasi performa.

### 8. Sumber Referensi Lengkap

- [Qt6 Documentation](https://doc.qt.io/qt-6/)
- [MultiEffect](https://doc.qt.io/qt-6/qml-qtquick-effects-multieffect.html)
- [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html)
- [Quickshell: Install & Setup](https://quickshell.org/docs/)

### 9. Tips dan Praktik Terbaik

- **Gunakan `visible: false` pada sumber `MultiEffect`**, bukan `opacity: 0`. `opacity: 0` masih menggambar (overdraw); `visible: false` melewati rendering sepenuhnya.
- **Jangan membuat `source` dari `MultiEffect` menjadi induknya sendiri.** Ini menyebabkan siklus dan error.
- **Untuk blur latar belakang jendela, gunakan aturan compositor.** Contoh Hyprland: `layerrule = blur, my-shell-bar`. Quickshell tidak bisa mengaburkan apa pun di belakang jendelanya karena itu di luar scene graph-nya.
- **Periksa `QSG_RENDER_TIMING=1`** bila animasi terasa lambat; ini menunjukkan waktu render per frame.

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `source: parent` pada `MultiEffect` | Siklus; error atau efek tidak muncul | Gunakan item saudara sebagai sumber. |
| Mengira `MultiEffect` bisa mengaburkan wallpaper | Tidak ada efek pada latar | Gunakan aturan blur compositor. |
| Lupa `visible: false` pada sumber | Rectangle asli menutupi efek | Set `visible: false`. |
| Memakai `GaussianBlur` dari `qt5compat` | Performa buruk | Beralih ke `MultiEffect`. |

### 11. Latihan dan Checkpoint

**Latihan:** Beri bayangan pada sebuah kartu dengan `MultiEffect`. Bandingkan dengan `DropShadow`.

**Checkpoint:** Jelaskan mengapa sumber efek tidak boleh sama dengan induk yang memuat efek itu.

**Jawaban ringkas:** Karena `MultiEffect` membaca isi `source` untuk menghasilkan efek. Jika `source` adalah induk, membaca isi induk berarti membaca efek itu sendiri — siklus tak terdefinisi. Sumber harus berupa item yang sudah selesai dirender sebelum efek diterapkan.

### 12. Motivasi

> *"Memahami mesin di balik layar memberi Anda keberanian untuk membongkar dan merakit ulang. QtQuick adalah mesin Anda — pelajari suaranya, dan ia akan mengikuti perintah Anda."*

---

## Modul 0.4 — JavaScript di QML, Animasi, dan Membaca Referensi

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan **JavaScript di dalam ekspresi QML**, **animasi halus** dengan `Behavior` dan `states`/`transitions`, dan — yang paling penting — **cara membaca halaman referensi tipe Quickshell sendiri** sehingga Anda tidak bergantung pada contoh orang lain. Perannya: ini adalah **keterampilan meta** yang menentukan apakah Anda bisa menambah fitur apa pun atau hanya bisa menyalin konfigurasi yang sudah ada.

### 2. Konsep Kunci & Filosofi Mendalam

**Analogi:** Referensi API adalah **kamus**; contoh kode hanyalah **kalimat contoh**. Penguasaan berarti bisa menyusun kalimat sendiri dari kamus, bahkan ketika tidak ada contoh untuk kalimat yang Anda butuhkan.

**Mengapa membaca referensi lebih penting daripada menyalin contoh:**
- Contoh cepat usang; API Quickshell berkembang antarversi.
- Contoh mungkin menyembunyikan asumsi (mis. skala volume, properti yang wajib di-bind).
- Referensi memberi Anda **label penting**: `readonly` (tidak bisa ditulis), `uncreatable` (tidak bisa dibuat langsung; harus diakses lewat singleton atau properti), `singleton` (satu instance global), `default` (properti default yang bisa diisi dengan anak).

**Cara membaca halaman tipe Quickshell:**
1. **Judul dan tipe dasar:** Mis. `BluetoothAdapter: QtObject uncreatable`. `uncreatable` berarti Anda tidak bisa menulis `BluetoothAdapter { }`; Anda harus mengaksesnya lewat `Bluetooth.defaultAdapter` atau `adapter.devices`.
2. **Import:** Baris `import Quickshell.Bluetooth` memberitahu modul yang harus diimpor.
3. **Properties:** Daftar properti beserta tipe dan deskripsi. Perhatikan `readonly` dan peringatan (mis. "invalid unless bound using PwObjectTracker").
4. **Functions:** Fungsi yang dapat dipanggil dari QML.
5. **Signals:** Sinyal yang dapat direspons dengan `onNamaSignal`.

### 3. Sintaks Dasar / Contoh Implementasi Inti

**Contoh 1 — JavaScript dalam binding dan handler.**

```qml
import QtQuick

Rectangle {
    id: box
    width: 80; height: 80
    color: hover.hovered ? 'tomato' : 'steelblue'
    Behavior on color { ColorAnimation { duration: 150 } }
    HoverHandler { id: hover }
    Component.onCompleted: console.log('dibuat:', width, height)
}
```

*Penjelasan kata demi kata:*

- `id: box` — memberi nama objek agar dapat dirujuk.
- `color: hover.hovered ? 'tomato' : 'steelblue'` — **ekspresi JavaScript** di dalam binding. `hover.hovered` adalah boolean; operator `? :` (ternary) memilih warna. Binding ini bergantung pada `hover.hovered`; ketika hover berubah, warna diperbarui otomatis.
- `Behavior on color { ... }` — **animasi otomatis** setiap kali properti `color` berubah. `ColorAnimation { duration: 150 }` menganimasikan transisi warna selama 150 ms. Anda tidak perlu memanggil animasi secara manual.
- `HoverHandler { id: hover }` — handler yang mendeteksi hover mouse. `hover.hovered` menjadi `true` saat mouse di atas `Rectangle`.
- `Component.onCompleted: console.log('dibuat:', width, height)` — **handler siklus hidup** yang berjalan setelah objek selesai dibuat. Berguna untuk inisialisasi, logging, atau memeriksa nilai properti.

**Contoh 2 — `states` dan `transitions`.**

```qml
Rectangle {
    id: panel
    width: 200; height: 40
    color: 'black'
    state: 'closed'
    states: [
        State {
            name: 'open'
            PropertyChanges { target: panel; height: 200; color: 'steelblue' }
        },
        State {
            name: 'closed'
            PropertyChanges { target: panel; height: 40; color: 'black' }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: 'height'; duration: 150 }
        ColorAnimation { properties: 'color'; duration: 150 }
    }
}
```

*Penjelasan:*

- `state: 'closed'` — keadaan awal.
- `states: [ ... ]` — daftar keadaan bernama. Setiap `State` berisi `PropertyChanges` yang menentukan nilai properti saat keadaan itu aktif.
- `PropertyChanges { target: panel; height: 200 }` — mengubah `height` dari `panel` menjadi 200 saat state `open` aktif.
- `transitions: Transition { ... }` — animasi yang berjalan saat berpindah antar keadaan. `NumberAnimation` menganimasikan `height`; `ColorAnimation` menganimasikan `color`. **Catatan:** Qt merekomendasikan `Transition` (bukan `Behavior`) untuk menganimasikan perubahan yang disebabkan oleh pergantian state, untuk menghindari perilaku tak terdefinisi.
- Untuk berpindah state, set `panel.state = 'open'` dari handler (mis. `MouseArea.onClicked`).

**Contoh 3 — Membaca referensi: `SystemClock`.**

Setelah membaca halaman `SystemClock` di referensi Quickshell, Anda menemukan properti `date` (readonly) dan `precision`. Anda dapat menulis jam tanpa menyalin contoh:

```qml
import Quickshell
import QtQuick

SystemClock {
    id: clock
    precision: SystemClock.Seconds
}
Text {
    text: Qt.formatDateTime(clock.date, 'HH:mm:ss')
    color: 'white'
}
```

*Penjelasan:*

- `SystemClock` — tipe Quickshell yang menyediakan waktu secara efisien (bukan polling `date` setiap detik). Dokumentasi menyatakan pembaruan terjadi dalam ±50 ms dari perubahan jam sistem.
- `precision: SystemClock.Seconds` — enum yang menentukan resolusi pembaruan (detik). Default-nya juga `Seconds`.
- `clock.date` — properti `date` yang diperbarui sesuai presisi. Binding `text` bergantung padanya.
- `Qt.formatDateTime(clock.date, 'HH:mm:ss')` — fungsi Qt untuk memformat tanggal/waktu menjadi string.

**Opsi alternatif untuk animasi:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Animasi otomatis saat properti berubah | `Behavior on <property>` | Paling ringkas; cocok untuk perubahan sederhana. |
| Animasi antar keadaan bernama | `states` + `transitions` | Cocok untuk UI dengan mode (buka/tutup, normal/insert). |
| Animasi manual sekali jalan | `NumberAnimation { target; property; to; running: true }` | Kontrol penuh; harus dijalankan eksplisit. |
| Animasi berbasis fisika | `SpringAnimation`, `Flickable` | Gerakan natural; cocok untuk scroll dan tarik. |

### 4. Terminologi Esensial & Penjelasan Detil

- **Ekspresi JavaScript:** Potongan JS di dalam binding atau handler. QML menanamkan mesin JavaScript; Anda dapat memakai `?.`, `??`, fungsi panah, `map`, `filter`, dll.
- **`Behavior`:** Animasi otomatis setiap kali sebuah properti berubah. Tidak perlu memicu animasi secara manual.
- **`Component.onCompleted`:** Kode yang berjalan setelah objek selesai dibuat. Berguna untuk inisialisasi dan logging.
- **Singleton (di referensi):** Tipe yang langsung dipakai tanpa dibuat instansinya, mis. `Pipewire`, `Bluetooth`, `SystemClock` (bukan singleton, tetapi sering diakses langsung).
- **`readonly`:** Properti yang tidak dapat ditulis dari QML; hanya dapat dibaca.
- **`uncreatable`:** Tipe yang tidak dapat dibuat dengan `NamaTipe { }`; harus diakses lewat singleton atau properti objek lain.
- **`default` (properti):** Properti yang dapat diisi dengan anak-anak objek tanpa menyebut nama properti. Contoh: `WlSessionLock.surface` adalah properti default, sehingga `WlSessionLockSurface { }` di dalam `WlSessionLock` otomatis mengisi `surface`.
- **`states` / `transitions`:** Keadaan bernama dan animasi perpindahan antar keadaan.

### 5. Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. JavaScript dalam binding dan handler (`?.`, `??`, fungsi panah).
2. `Behavior`, `NumberAnimation`, `states`, dan `transitions`.
3. `Component.onCompleted` dan siklus hidup objek.
4. Membaca halaman referensi tipe Quickshell.
5. Memeriksa nilai dengan `console.log(JSON.stringify(obj))`.

### 6. Rekomendasi Visualisasi (ASCII)

```text
Alur membaca referensi:
1. Judul & tipe dasar ──► singleton? uncreatable? readonly?
2. Import ──────────────► modul yang dibutuhkan
3. Properties ──────────► tipe, readonly, peringatan
4. Functions ───────────► parameter, nilai kembali
5. Signals ─────────────► onNamaSignal di QML

Contoh: SystemClock
┌─────────────────────────────┐
│ SystemClock                 │
│ Properties:                 │
│   date: date (readonly)     │
│   precision: enum           │
│ Signals:                    │
│   dateChanged               │
└─────────────────────────────┘
        │
        ▼
Text { text: Qt.formatDateTime(clock.date, 'HH:mm:ss') }
```

### 7. Hubungan dengan Modul Lain

- **0.4 → 1.2:** `SystemClock` dan `Process` adalah tipe pertama yang akan Anda baca referensinya secara mandiri.
- **0.4 → 1.3:** Singleton `Theme` dan komponen reusable adalah aplikasi langsung dari `pragma Singleton` dan struktur berkas.
- **0.4 → 3.2:** `Behavior` dan `states` adalah dasar untuk state machine dan animasi UI yang kompleks.
- **0.4 → 5.2:** `Behavior` yang mahal adalah target optimasi; memahami animasi membantu Anda mengukur biayanya.

### 8. Sumber Referensi Lengkap

- [Qt: QML dan JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-topic.html)
- [Qt: Animasi](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html)
- [Qt: Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)
- [Referensi tipe Quickshell](https://quickshell.org/docs/)
- [SystemClock](https://quickshell.org/docs/types/Quickshell/SystemClock)
- [MDN: JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)

### 9. Tips dan Praktik Terbaik

- **Mulai dari halaman referensi, bukan dari contoh.** Contoh cepat usang; referensi adalah sumber kebenaran.
- **Perhatikan label `readonly` dan `uncreatable`.** Ini menentukan cara Anda mengakses tipe.
- **Gunakan `console.log(JSON.stringify(obj))`** untuk memeriksa struktur objek yang kompleks. Jangan mencetak objek mentah; `JSON.stringify` memberi representasi yang dapat dibaca.
- **Jangan mencampur binding dan handler imperatif untuk properti yang sama.** Pilih satu: binding untuk nilai yang diturunkan, handler untuk aksi pengguna.

### 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menyalin contoh tanpa membaca referensi | Properti tidak ada di versi terpasang | Baca halaman tipe; cocokkan dengan `quickshell --version`. |
| Mengira `SystemClock` perlu di-poll | Jam tidak diperbarui atau CPU boros | Gunakan `SystemClock`; jangan polling `date`. |
| Menulis `onDateChanged` untuk memperbarui teks | Binding ganda; loop | Cukup binding `text: Qt.formatDateTime(clock.date, ...)`. |
| Mengabaikan peringatan "No details provided" | Tidak tahu cara memakai tipe | Baca kode sumber atau contoh di repositori. |

### 11. Latihan dan Checkpoint

**Latihan:** Pilih tipe `SystemClock`, baca halamannya, dan tulis dari nol sebuah jam tanpa menyalin contoh. Tambahkan `Behavior` agar perubahan menit dianimasikan.

**Checkpoint:** Tunjukkan di halaman referensi mana Anda mengetahui sebuah properti bersifat `readonly`.

**Jawaban ringkas:** Di bagian **Properties**, properti `readonly` ditandai dengan label `readonly` setelah tipe. Contoh: `date : date readonly` pada `SystemClock`. Anda juga dapat melihatnya di kode sumber (`Q_PROPERTY(... READ ... CONSTANT)` atau tanpa `WRITE`).

### 12. Motivasi

> *"Kemampuan membaca kamus adalah kebebasan. Ketika Anda bisa membaca referensi sendiri, tidak ada fitur yang mustahil — hanya belum Anda cari."*

---


> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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

