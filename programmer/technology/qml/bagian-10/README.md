# Fase 9

## Audit Singkat

**Terverifikasi benar**
- Fusion memang style bawaan di Linux. Klaim tabel Modul 9.2 sudah tepat.
- Qt 6.12 LTS dirilis 30 September 2026, dan StyleKit masuk Qt Labs sebagai API styling berbasis QML untuk aplikasi hibrida Widgets + Qt Quick. Penandaan "eksperimental (Qt Labs)" di kurikulum sesuai.

**Perlu koreksi**
- Modul 9.2 menyebut Qt 6.12 "mengenalkan style Native baru". Menurut dokumentasi 6.12, `QtQuick.Controls.Native` adalah impor compile-time yang otomatis mengimpor style bawaan platform. Jika memakainya, jangan mengimpor style lain atau `QtQuick.Controls` run-time. Jadi ini mekanisme pemilihan, bukan tampilan visual baru. Redaksinya sebaiknya dipindah ke 9.2.2 sebagai cara pemilihan kelima.
- Tabel style 9.2 belum mencatat bahwa style macOS masih mengembalikan sebagian kontrol (BusyIndicator, DelayButton, PageIndicator, RangeSlider, Switch, TabBar, Tumbler) ke Fusion, dan tidak cocok dikustomisasi. Ini perlu ditambahkan.
- Kontrol baru tidak diberi penanda versi: `SearchField` sejak Qt 6.10 dan `DoubleSpinBox` sejak Qt 6.11. Keduanya belum ada di kurikulum.

**Kekurangan cakupan Modul 9.1 (ditambahkan sebagai TAMBAHAN)**
`Label`, `TextArea`, `RadioButton`/`ButtonGroup`, `RangeSlider`, `Dial`, `Tumbler`, `ProgressBar`/`BusyIndicator`, `ToolBar`/`ToolButton`/`ToolTip`, `Pane`/`Frame`/`GroupBox`, `MenuBar`, dan terutama `Action` + `Shortcut`. Yang terakhir ini tulang punggung antarmuka yang digerakkan keyboard. Ada juga konsep `focusPolicy`, `visualFocus`, dan focus scope yang menjadi dasar 9.1.7.

**Catatan Fase 9 untuk modul berikutnya.** Dialog native (`FileDialog`, `MessageDialog`) belum ada di 9.3.4, dan variabel lingkungan aksesibilitas Linux untuk Orca belum ada di 9.4.6. Keduanya saya verifikasi saat tiba di modulnya. Prasyarat dan urutan tidak ada yang meloncat: 9.1 memakai Layouts (5.2) dan keyboard (6.3), dan 9.3.6 merujuk 8.2 yang sudah selesai.

---

# Modul 9.1 — Controls Dasar

> *Satu kontrol dipahami sampai ke akarnya, ribuan antarmuka ikut terbuka.*

<details>
  <summary>📃 Daftar Isi</summary>

## Daftar isi Modul 9.1 (pembaruan, salin ke README)


| No | Sub-topik |
| --- | --- |
| 9.1.0 | Anatomi `Control` dan pondasi sintaks `[TAMBAHAN]` |
| 9.1.1 | `ApplicationWindow` dan `Page` (+ `header`, `footer`, `MenuBar`, `ToolBar`) |
| 9.1.2 | Tombol dan pilihan (`Button`, `CheckBox`, `RadioButton`, `Switch`, `ButtonGroup`) + `Action`/`Shortcut`/`ToolTip` `[TAMBAHAN]` |
| 9.1.3 | Input teks (`TextField`, `TextArea`, `Label`, `SearchField [≥6.10]`) |
| 9.1.4 | `Slider`, `SpinBox`, `DoubleSpinBox [≥6.11]`, `ComboBox` + `RangeSlider`, `Dial`, `Tumbler`, `ProgressBar` `[TAMBAHAN]` |
| 9.1.5 | `ScrollView` (+ `ScrollBar`, `SplitView`, `Pane`/`Frame`/`GroupBox`) |
| 9.1.6 | Controls dengan Layouts |
| 9.1.7 | Urutan Tab, fokus, dan focus scope |
| 9.1.8 | Lab terpadu: formulir keyboard-first `[TAMBAHAN]` |

</details>

## Deskripsi dan peran dalam kurikulum

`QtQuick.Controls` adalah pustaka komponen antarmuka siap pakai. Selama Fase 4–8 Anda membangun dari primitif (`Rectangle`, `Text`, `MouseArea`). Mulai Fase 9, Anda memakai komponen yang sudah membawa tiga hal sekaligus:

- perilaku: fokus, hover, tekan, keyboard;
- tampilan yang mengikuti style;
- sambungan ke teknologi bantu (pembaca layar).

Modul ini penting karena menjadi dasar 9.2 (style), 9.3 (navigasi), dan 9.4 (aksesibilitas). Tanpa pemahaman anatomi `Control`, kustomisasi di 9.2 hanya tebak-tebakan.

## Konsep kunci dan filosofi

**Analogi non-IT.** `Control` adalah perabot pabrikan. Sebuah kursi sudah punya sandaran, dudukan, dan kaki yang kokoh (perilaku), lalu Anda memilih warna dan bahannya (style). Membuat kursi dari kardus (`Rectangle` + `TapHandler`) tampak mirip, tetapi tidak bisa diduduki dengan benar: tidak bisa dijangkau keyboard, tidak dikenali pembaca layar, dan tidak punya status fokus.

**Filosofi.** Perilaku dipisah dari tampilan:
- *template* (logika) berada di `Control`;
- *style* (rupa) berada di `background` dan `contentItem`.

Prinsip ini sejalan dengan gaya Anda: modular dan abstrak. Logika tetap utuh, kulit bisa diganti.

## 9.1.0 Anatomi `Control` dan pondasi sintaks `[TAMBAHAN]`

> *Fondasi yang kuat membuat bangunan setinggi apa pun tidak gentar.*

**Pondasi sintaks QML yang dipakai di seluruh modul**
- **Deklarasi objek:** `Tipe { ... }`. Contoh: `Button { }` membuat objek `Button`.
- **Properti:** `nama: nilai`. Jika nilainya ekspresi, ia menjadi *binding* yang otomatis dihitung ulang saat dependensinya berubah, misalnya `enabled: nama.text.length > 0`.
- **`id`:** nama objek di dalam satu berkas, dipakai untuk saling merujuk.
- **Signal handler:** `onNamaSignal:`. Contoh: `onClicked:` bereaksi pada sinyal `clicked`.
- **Properti terlampir (*attached property*):** properti yang "ditempelkan" tipe lain ke objek Anda, ditulis `Tipe.properti`. Contoh: `Layout.fillWidth`, `KeyNavigation.tab`, `ButtonGroup.group`.
- **`parent`:** objek visual induk langsung.

**Bagian-bagian `Control`.** Properti yang dimiliki setiap Control (menurut dokumentasi tipe `Control`): `background`, `contentItem`, `padding` dan turunannya, `font`, `palette`, `locale`, `mirrored`, `spacing`, `hoverEnabled`, `hovered`, `focusPolicy`, `focusReason`, `visualFocus`, `wheelEnabled`, `availableWidth`, dan `availableHeight`.

```
+------------------------- Control ----------------------------+
| background  (Item, biasanya Rectangle)                       |
|   +---------------- padding ------------------------------+  |
|   |  contentItem  (Text / Row / Item apa pun)             |  |
|   +-------------------------------------------------------+  |
+--------------------------------------------------------------+
implicitWidth = implicitContentWidth + leftPadding + rightPadding
```

**Silsilah tipe yang perlu dihafal**

```
Window ---- ApplicationWindow                (jendela tingkat atas)
Text   ---- Label                            (teks yang mengikuti style)
TextInput - TextField   TextEdit - TextArea  (bukan Control, tetapi punya
                                              background, padding, placeholder)
Item
 +-- Control
      +-- AbstractButton  (text, checkable, checked, down, clicked, toggled)
      |     +-- Button  (ToolButton, RoundButton = varian)
      |     +-- CheckBox / RadioButton / Switch / DelayButton
      +-- Slider / RangeSlider / Dial / SpinBox / DoubleSpinBox
      +-- ComboBox / Tumbler / ProgressBar / BusyIndicator
      +-- Pane
      |     +-- Frame -- GroupBox
      |     +-- Page / ToolBar / ScrollView
      +-- Container -- TabBar / SwipeView
Popup  (QObject terpisah; dibahas di Modul 9.3)
```

Bedah istilah: **`implicit...`** adalah ukuran "yang diinginkan" kontrol dari isinya. **`padding`** adalah jarak isi ke tepi. **`inset`** menggeser `background` terhadap tepi kontrol.

**Opsi lain untuk membuat elemen interaktif**

| Pilihan | Kapan dipakai | Harga yang dibayar |
| --- | --- | --- |
| `Button` (Controls) | Hampir selalu | Ikut style |
| `Rectangle` + `TapHandler`/`MouseArea` | Prototipe, elemen dekoratif | Tak ada fokus, keyboard, atau aksesibilitas bawaan |
| `Button` dengan `contentItem`/`background` kustom | Tampilan khusus (9.2) | Perlu menjaga status `down`/`hovered`/`visualFocus` |
| Kontrol sendiri dari `T.Button` (`QtQuick.Templates`) | Membuat sistem desain sendiri (9.2.6) | Pekerjaan lebih banyak, kendali penuh |

**Perintah terminal di Arch Linux**

```bash
sudo pacman -S --needed qt6-declarative qt6-base qt6-wayland    # runtime QML + Controls
pacman -Ql qt6-declarative | rg 'bin/(qml|qmllint|qmlformat)'   # cek nama biner
qml6 Kontrol.qml                      # jalankan berkas QML (alternatif: /usr/lib/qt6/bin/qml)
QT_QUICK_CONTROLS_STYLE=Basic qml6 Kontrol.qml   # paksa style
QT_QPA_PLATFORM=wayland qml6 Kontrol.qml         # pilih backend (alternatif: xcb)
qmllint6 Kontrol.qml                  # linter statis (Modul 8.4)
qmlformat6 -i Kontrol.qml             # rapikan berkas di tempat
```

| Perintah | Tujuan |
| --- | --- |
| `pacman -S --needed` | Pasang tanpa memasang ulang yang sudah ada |
| `pacman -Ql paket \| rg ...` | Melihat berkas yang dipasang paket |
| `qml6` | Runtime QML mandiri untuk uji cepat tanpa CMake |
| `QT_QUICK_CONTROLS_STYLE` | Memilih style lewat lingkungan (dibahas di 9.2) |
| `QT_QPA_PLATFORM` | Memilih plugin platform: `wayland` atau `xcb` (X11) |

Nama `qml6`/`qmllint6` mengikuti konvensi pengemasan Arch. Jika tidak ditemukan, pakai path penuh di `/usr/lib/qt6/bin/`.

**Isolasi (opsional, sesuai prinsip keamanan Anda).** Aplikasi uji tidak butuh jaringan, jadi jalankan tanpa jaringan: `firejail --net=none qml6 Kontrol.qml`. Hasilnya tergantung konfigurasi Wayland/X11 Anda, jadi uji sendiri.

## 9.1.1 `ApplicationWindow` dan `Page`

> *Jendela yang tertata adalah rumah yang rapi bagi semua kontrol.*

`ApplicationWindow` adalah jendela tingkat atas yang menambahkan fitur Controls ke `Window`:
- slot `menuBar`, `header`, dan `footer`;
- `contentItem` sebagai area isi;
- lapisan `overlay` untuk popup.

`Page` adalah halaman bergaya dengan `header` dan `footer` sendiri. Ia sangat berguna di dalam `StackView` (9.3).

```qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: jendela
    visible: true; width: 520; height: 340; title: 'Jendela Utama'

    menuBar: MenuBar {
        Menu {
            title: '&Berkas'
            Action { text: '&Keluar'; shortcut: 'Ctrl+Q'; onTriggered: Qt.quit() }
        }
    }
    header: ToolBar {
        Label { text: jendela.title; anchors.centerIn: parent }
    }
    footer: ToolBar {
        Label { text: 'Siap'; x: 12; anchors.verticalCenter: parent.verticalCenter }
    }

    Page {
        id: beranda
        anchors.fill: parent
        title: 'Beranda'
        header: Label { text: beranda.title; padding: 10; font.bold: true }
        Label { anchors.centerIn: parent; text: 'Isi halaman' }
    }
}
```

**Bedah kode**
- `import QtQuick` memberi `Item`/`Rectangle`; `import QtQuick.Controls` memberi semua kontrol bergaya.
- `ApplicationWindow { ... }` adalah akar berkas. `visible: true` wajib agar jendela tampil.
- `width`/`height` adalah ukuran awal; `title` adalah judul jendela.
- `menuBar: MenuBar { Menu { ... } }` memasang bilah menu. `&` pada `'&Berkas'` menandai *mnemonik*, sehingga Alt+B membuka menu.
- `Action { text, shortcut, onTriggered }` mendefinisikan perintah. `shortcut: 'Ctrl+Q'` adalah pintasan keyboard, dan `Qt.quit()` mengakhiri aplikasi.
- `header:`/`footer:` menerima satu item. `ToolBar` adalah bilah gaya, dan `Label` adalah teks bergaya.
- `anchors.centerIn: parent` memusatkan label; di dalam `ToolBar`, `parent` adalah area isinya.
- `Page { anchors.fill: parent }` mengisi seluruh area isi jendela. `title` dipakai `StackView` nanti.
- Anak langsung `Page` otomatis masuk ke `contentItem`-nya.

**Opsi lain**
- **`Window` murni** (`import QtQuick.Window`) bila tak butuh header/footer/menu/overlay. Popup Controls tidak akan punya lapisan `overlay`.
- **`Pane`** sebagai wadah polos bergaya.
- **Tanpa `Page`:** letakkan isi langsung di `ApplicationWindow`, lebih sederhana untuk jendela tunggal.

**Jebakan**
- Lupa `visible: true`: proses jalan tetapi tak ada jendela.
- `Page` tanpa ukuran di luar `StackView`: isinya 0×0.
- `anchors` di dalam `ToolBar` memakai `parent` yang berarti area isi, bukan jendela.

## 9.1.2 Tombol dan pilihan

> *Satu klik kecil, satu keputusan besar. Rancanglah dengan teliti.*

**Konsep.** Semua tombol mewarisi `AbstractButton`. Properti kuncinya:
- `text`, `checkable`, `checked`, `down`, `pressed`, `hovered`;
- sinyal `clicked()` dan `toggled()`.

`toggled` hanya dipancarkan saat *pengguna* mengubah status. Perubahan lewat kode tidak memancarkannya, jadi aman dari putaran tak berujung.

`Action` adalah satu "perintah" (teks, pintasan, status aktif) yang bisa dipakai banyak kontrol sekaligus. Ini inti antarmuka keyboard-centric: logika ditulis sekali, dan tombol, menu, serta pintasan semuanya menunjuk ke sana.

Fragmen ini dipasang di kerangka uji berikut (dipakai juga oleh 9.1.3–9.1.7).

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true; width: 480; height: 360; title: 'Lab 9.1'
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 10
        // >>> tempel fragmen di sini <<<
    }
}
```

```qml
Action {
    id: simpanAksi
    text: 'Simpan'
    shortcut: 'Ctrl+S'
    onTriggered: console.log('simpan via Action')
}

Button { action: simpanAksi; ToolTip.visible: hovered; ToolTip.text: 'Ctrl+S' }

CheckBox {
    text: 'Saya setuju'
    onToggled: console.log('setuju =', checked)
}

ButtonGroup { id: grupPeran }
RowLayout {
    RadioButton { text: 'Admin';  ButtonGroup.group: grupPeran }
    RadioButton { text: 'Editor'; ButtonGroup.group: grupPeran; checked: true }
}

Switch { text: 'Mode aman'; checked: true }
```

**Bedah kode**
- `Action { id; text; shortcut; onTriggered }`: objek non-visual. `shortcut: 'Ctrl+S'` adalah *key sequence*.
- `Button { action: simpanAksi }` membuat tombol mengambil teks, status `enabled`, dan pintasan dari `Action`.
- `ToolTip.visible: hovered` dan `ToolTip.text` adalah properti terlampir `ToolTip`. Petunjuk muncul saat kursor di atas tombol.
- `CheckBox` adalah kotak centang. `onToggled` aktif hanya karena aksi pengguna, dan `checked` berisi status terbarunya.
- `ButtonGroup { id }` mengelompokkan tombol agar eksklusif. Tiap `RadioButton` bergabung lewat `ButtonGroup.group: grupPeran`.
- `checked: true` menetapkan pilihan awal.
- `Switch` adalah sakelar hidup/mati dengan semantik yang sama seperti `CheckBox`.

**Opsi lain**

```qml
// (1) Anti-pola: tak ada fokus, Space, atau peran aksesibel
Rectangle {
    width: 100; height: 36; radius: 6; color: 'steelblue'
    Text { anchors.centerIn: parent; text: 'Kirim' }
    TapHandler { onTapped: console.log('klik') }
}

// (2) Menambah tombol Enter pada Button (aktivasi bawaan umumnya Space)
Button {
    text: 'OK'
    Keys.onReturnPressed: clicked()
    Keys.onEnterPressed:  clicked()
}

// (3) Pintasan mandiri tanpa Action
Shortcut { sequence: 'Ctrl+K'; onActivated: console.log('pintasan') }
```

| Varian | Tujuan |
| --- | --- |
| `ToolButton` | Tombol bilah alat, ringkas |
| `RoundButton` | Tombol bulat/ikon |
| `DelayButton` | Perlu ditahan agar aman, cocok untuk aksi destruktif |
| `Button { flat: true }` | Tombol tanpa latar |
| `Button { highlighted: true }` | Penekanan visual untuk aksi utama |

**Jebakan**
- Memakai `onClicked` pada `CheckBox` untuk melacak status. Gunakan `onToggled`/`onCheckedChanged`.
- `RadioButton` tanpa kelompok jelas: gunakan `ButtonGroup` bila radio tersebar di beberapa induk.
- Tombol aksi destruktif tanpa penghalang: pertimbangkan `DelayButton` atau dialog konfirmasi (9.3).

## 9.1.3 Input teks

> *Setiap karakter yang diketik adalah data. Perlakukan dengan hormat dan curiga.*

**Konsep**
- `TextField` adalah satu baris, dan `TextArea` adalah banyak baris. Keduanya mewarisi `TextInput`/`TextEdit` dari Fase 4.4, lalu menambah `background`, `padding`, dan `placeholderText`.
- `Label` adalah `Text` yang otomatis mengikuti `font` dan `palette` style. Dalam aplikasi Controls, pakai `Label`, bukan `Text`.
- `SearchField` `[≥6.10]` adalah kolom pencarian dengan ikon cari/hapus dan popup saran.
- `placeholderText` di `SearchField` baru ada sejak 6.12. Pada 6.10/6.11 properti itu tidak tersedia.

```qml
Label { text: 'Nama pengguna'; font.bold: true }
TextField {
    id: nama
    Layout.fillWidth: true
    placeholderText: 'huruf kecil, angka, _ atau -'
    validator: RegularExpressionValidator { regularExpression: /[a-z_][a-z0-9_-]{0,31}/ }
    onAccepted: sandi.forceActiveFocus()
}

TextField {
    id: sandi
    Layout.fillWidth: true
    placeholderText: 'Kata sandi'
    echoMode: TextInput.Password
    inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
}

ScrollView {
    Layout.fillWidth: true; Layout.fillHeight: true
    TextArea { placeholderText: 'Catatan...'; wrapMode: TextArea.Wrap }
}
```

**Bedah kode**
- `validator: RegularExpressionValidator { regularExpression: /.../ }` hanya mengizinkan ketikan yang cocok dengan pola. Pola contoh meniru aturan nama pengguna Linux: diawali huruf kecil atau `_`, lalu hingga 31 karakter huruf kecil, angka, `_`, atau `-`.
- `onAccepted` aktif saat pengguna menekan Enter *dan* isi lolos validator. `sandi.forceActiveFocus()` memindahkan fokus.
- `echoMode: TextInput.Password` menyamarkan karakter. Mode lain: `Normal`, `NoEcho`, `PasswordEchoOnEdit`.
- `inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText` memberi isyarat ke metode input agar tidak menyimpan atau memprediksi isi. Tanda `|` menggabungkan flag.
- `ScrollView { TextArea { } }`: `TextArea` tidak punya bilah gulir sendiri, jadi bungkus dengan `ScrollView`.
- `wrapMode: TextArea.Wrap` membungkus baris panjang.

**Opsi lain**
- **`onTextEdited`** dipicu hanya oleh ketikan pengguna, sedangkan `onTextChanged` juga terpicu saat kode mengubah `text`. Untuk bereaksi pada ketikan, gunakan `onTextEdited`.
- **`onEditingFinished`** dipicu saat fokus hilang atau Enter ditekan, cocok untuk validasi akhir.
- **`inputMask`** (mis. `'000.000.000.000'`) untuk format tetap.
- **`SearchField` `[≥6.10]`:**

```qml
SearchField {
    id: cari
    Layout.fillWidth: true
    suggestionModel: ['pacman', 'paru', 'yay', 'pamac']
    onSearchTriggered: console.log('cari:', cari.text)
}
```

Model saran berupa larik JS cukup untuk demonstrasi. Untuk penyaringan sungguhan Anda butuh model yang tersaring (Fase 7 / proxy model).

**Keamanan.** Jangan `console.log` kata sandi. Jangan simpan sandi di properti yang mudah terbaca, dan hapus segera setelah dipakai. Jika `.qml` dibagikan, jangan taruh rahasia di dalamnya.

**Jebakan**
- `TextField` mengubah ukuran tanpa `Layout.fillWidth` di dalam layout.
- `TextArea` tanpa `ScrollView` memotong teks.
- Mengandalkan validator saja untuk keamanan. Itu hanya kenyamanan UI, validasi sebenarnya tetap di sisi logika.

## 9.1.4 `Slider`, `SpinBox`, `DoubleSpinBox`, `ComboBox`

> *Memilih nilai adalah menentukan arah. Beri pengguna kendali yang presisi.*

**Konsep**
- `Slider` memilih nilai kontinu lewat geser. Properti: `from`, `to`, `value`, `stepSize`, `snapMode`, `orientation`, dan sinyal `moved()` (hanya aksi pengguna).
- `SpinBox` memilih bilangan bulat, bisa `editable`, dengan `from`/`to`/`stepSize`, dan `valueModified()`.
- `DoubleSpinBox` `[≥6.11]`: sama seperti `SpinBox` tetapi untuk nilai pecahan, dengan properti `decimals`, dan bisa diedit.
- `ComboBox` memilih dari daftar. Properti: `model`, `textRole`, `valueRole`, `currentIndex`, `currentText`, `currentValue`, `editable`; sinyal `activated(index)` untuk pilihan pengguna.

```qml
RowLayout {
    ComboBox {
        id: peran
        model: [ { t: 'Admin', v: 'admin' }, { t: 'Editor', v: 'editor' } ]
        textRole: 't'
        valueRole: 'v'
    }
    Slider { id: volume; from: 0; to: 100; stepSize: 5; snapMode: Slider.SnapAlways; value: 50 }
    SpinBox { id: port; from: 1; to: 65535; value: 8080; editable: true }
}
Label { text: peran.currentValue + ' / ' + volume.value + ' / ' + port.value }
```

**Bedah kode**
- `model: [ {...}, {...} ]` adalah larik objek JS, dan setiap objek punya dua peran: `t` dan `v`.
- `textRole: 't'` menentukan peran yang ditampilkan. `valueRole: 'v'` menentukan peran yang dibaca lewat `currentValue`, sehingga tampilan (bisa diterjemahkan) terpisah dari nilai logika.
- `snapMode: Slider.SnapAlways` membuat gagang selalu berhenti pada kelipatan `stepSize` (5).
- `SpinBox { from: 1; to: 65535 }` cocok dengan rentang port jaringan. `editable: true` mengizinkan mengetik langsung.
- `Label { text: ... }` adalah binding. Ia otomatis diperbarui saat salah satu dari ketiganya berubah.

**Opsi lain (desimal sebelum Qt 6.11)**

```qml
SpinBox {
    from: 0; to: 10000; value: 110; stepSize: 10; editable: true
    property real nyata: value / 100
    textFromValue: function(v, loc) { return Number(v / 100).toLocaleString(loc, 'f', 2) }
    valueFromText: function(t, loc) { return Math.round(Number.fromLocaleString(loc, t) * 100) }
}
```

Nilai disimpan sebagai bilangan bulat (×100) lalu ditampilkan sebagai desimal. Mulai Qt 6.11, cukup `DoubleSpinBox { from: 0; to: 100; decimals: 2; value: 1.1; editable: true }`.

**Kontrol tambahan `[TAMBAHAN]`**

| Kontrol | Fungsi | Catatan |
| --- | --- | --- |
| `RangeSlider` | Dua gagang (rentang) | `first.value`, `second.value`; focus scope |
| `Dial` | Kenop putar | Cocok untuk nilai siklik |
| `Tumbler` | Roda pilih bergulir | Mirip pemilih jam |
| `ProgressBar` | Kemajuan | `indeterminate: true` bila tak diketahui |
| `BusyIndicator` | Penanda sibuk | Untuk Fase 7.4 (data asinkron) |

**Jebakan**
- `currentText` dipakai sebagai nilai logika. Bila teks diterjemahkan, logika rusak, jadi pakai `valueRole`/`currentValue`.
- Membaca `currentValue` sebelum model terisi menghasilkan `undefined`.
- `SpinBox` tidak mendukung desimal sebelum 6.11. Gunakan pola ×100 di atas.

## 9.1.5 `ScrollView` (+ `SplitView`, `Pane`/`Frame`/`GroupBox`)

> *Konten tak terbatas butuh jendela yang bijak.*

**Konsep**
- `ScrollView` membungkus satu konten yang lebih besar dari area tampilnya. Ia menyediakan `ScrollBar` bergaya, dan `ScrollBar.vertical`/`ScrollBar.horizontal` bisa diatur kebijakannya (`AsNeeded`, `AlwaysOn`, `AlwaysOff`).
- Untuk daftar panjang, `ListView`/`Flickable` sendiri bisa dipasangi `ScrollBar.vertical: ScrollBar { }`.
- `ListView` punya `keyNavigationEnabled`, sedangkan `Flickable` murni tidak punya navigasi keyboard bawaan. Uji dengan keyboard.

```qml
ScrollView {
    Layout.fillWidth: true; Layout.fillHeight: true
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

    ColumnLayout {
        width: parent.width
        Repeater { model: 30; Label { text: 'Baris ' + (index + 1) } }
    }
}
```

**Bedah kode**
- `clip: true` memotong isi yang meluber.
- `ScrollBar.vertical.policy: ScrollBar.AlwaysOn` memaksa bilah vertikal selalu tampil.
- `ColumnLayout { width: parent.width }`: lebar isi diikat ke area tampil agar tidak muncul gulir horizontal.
- `Repeater { model: 30 }` membuat 30 salinan. `index` adalah nomor urut salinan (mulai 0).

**Opsi lain**
- **`ListView` + `ScrollBar.vertical`:** untuk data berbasis model (virtualisasi, jauh lebih hemat untuk ribuan baris).
- **`SplitView`:** panel dengan pemisah yang bisa diseret. Ia juga focus scope.
- **Wadah bergaya:** `Pane` (latar polos), `Frame` (berbingkai), `GroupBox` (berbingkai + judul).

**Jebakan**
- Beberapa anak langsung di `ScrollView`: hanya satu yang jadi konten. Bungkus dalam satu `ColumnLayout` atau `Item`.
- Lupa `clip: true`.
- Memakai `ScrollView` + `Repeater` untuk ribuan item. Pakai `ListView`.

## 9.1.6 Controls dengan Layouts

> *Tata letak yang baik membuat pengguna tak perlu berpikir.*

**Konsep.** Controls punya ukuran implisit (9.1.0), dan `Layout` memakainya untuk membagi ruang. Properti terlampir `Layout.*` mengatur peran tiap anak:
- `fillWidth`/`fillHeight`
- `preferredWidth`/`minimumWidth`/`maximumWidth`
- `alignment`
- `row`/`column`, `rowSpan`/`columnSpan`

```qml
GridLayout {
    columns: 2; columnSpacing: 12; rowSpacing: 8
    Layout.fillWidth: true

    Label { text: 'Host' }
    TextField { Layout.fillWidth: true }

    Label { text: 'Port' }
    SpinBox { from: 1; to: 65535; value: 22; editable: true }

    Label { text: 'Peran' }
    ComboBox { Layout.fillWidth: true; model: ['admin', 'editor'] }

    Item { Layout.columnSpan: 2; Layout.fillHeight: true }    // pengisi ruang
}
```

```
Kolom 0        Kolom 1
+-----------+---------------------------+
| Host      | [ TextField ............ ] |
| Port      | [ SpinBox ]               |
| Peran     | [ ComboBox ............ v ]|
+-----------+---------------------------+
| (Item pengisi: columnSpan 2, fillHeight)|
+-----------------------------------------+
```

**Bedah kode**
- `GridLayout { columns: 2 }` menyusun anak berurutan: kiri ke kanan, lalu baris berikutnya.
- `columnSpacing`/`rowSpacing` adalah jarak antarkolom dan antarbaris.
- `Layout.fillWidth: true` membuat anak melebar mengisi sisa lebar kolom.
- `Item { Layout.columnSpan: 2; Layout.fillHeight: true }` adalah "pegas" tak terlihat yang mendorong isi ke atas.

**Opsi lain**
- `ColumnLayout`/`RowLayout`: satu sumbu.
- `Column`/`Row`/`Grid` (positioner, Fase 5.2): lebih ringan, tetapi tak membagi ruang sisa.
- `anchors`: untuk relasi spesifik antar-item.
- Blog Qt 6.12 menyebut tipe layout Flexbox baru di antara penambahan terbaru. Nama tipe dan versi persisnya akan saya verifikasi saat Anda memintanya.

**Jebakan**
- `width:`/`height:` pada anak layout diabaikan. Gunakan `Layout.preferredWidth`/`Layout.preferredHeight`.
- Mengatur `anchors` pada anak layout: konflik atau peringatan.
- Mengubah ukuran Controls tanpa `implicitWidth`/`implicitHeight` (di 9.2 saat membuat `background`) membuat layout salah menghitung.

## 9.1.7 Urutan Tab, fokus, dan focus scope

> *Tangan yang tak pernah meninggalkan keyboard adalah tangan yang merdeka.*

**Konsep**
- **Fokus** adalah penerima ketikan. **Rantai Tab** adalah urutan loncatan saat Tab ditekan. Secara bawaan, urutannya mengikuti urutan deklarasi anak di pohon, bukan posisi visual.
- `focusPolicy` mengatur cara kontrol menerima fokus: `Qt.TabFocus`, `Qt.ClickFocus`, `Qt.StrongFocus` (keduanya), `Qt.WheelFocus`, atau `Qt.NoFocus`.
- `visualFocus` bernilai benar jika fokus datang dari keyboard (bukan klik). Gunakan ini untuk menggambar cincin fokus.
- **Focus scope** membuat fokus di dalamnya terisolasi. Kontrol yang berperan sebagai focus scope antara lain `ApplicationWindow`, `ComboBox`, `MenuBar`, `Page`, `Pane`, `Popup`, `RangeSlider`, `ScrollView`, `SearchField`, `SpinBox`, `SplitView`, `StackView`, `SwipeView`, dan `TabBar`.

```qml
TextField { id: a; placeholderText: 'A'; KeyNavigation.tab: c }
TextField { id: b; placeholderText: 'B' }
TextField { id: c; placeholderText: 'C'; KeyNavigation.backtab: a }

Button {
    id: kirim
    text: 'Kirim'
    background: Rectangle {
        radius: 4; color: 'transparent'
        border.width: kirim.visualFocus ? 3 : 1
        border.color: kirim.visualFocus ? 'orange' : 'gray'
    }
}
```

```
Tab ------>   A  ------>  C  ------>  (kontrol berikutnya)
              |            ^
              |  (B dilewati oleh KeyNavigation.tab di A)
              +-- Shift+Tab dari C kembali ke A (KeyNavigation.backtab)
```

**Bedah kode**
- `KeyNavigation.tab: c` (properti terlampir `Item`) berarti "Tab dari A langsung ke C", melewati B. `KeyNavigation.backtab: a` mengatur arah mundur (Shift+Tab).
- `background: Rectangle { ... }` mengganti latar. Ini baru pemanasan untuk 9.2.
- `kirim.visualFocus ? 3 : 1` adalah operator kondisi: bila fokus dari keyboard, bingkai tebal 3 dan berwarna oranye.

**Diagnosis fokus.** Cetak apa yang sedang fokus:

```qml
ApplicationWindow {
    onActiveFocusItemChanged: console.log('fokus ->', activeFocusItem)
    // ...
}
```

**Opsi lain**
- `focus: true` + `forceActiveFocus()` untuk memberi fokus lewat kode.
- `FocusScope { }` untuk membuat wadah fokus sendiri.
- `Keys.onPressed` dan `Keys.onEscapePressed` untuk tombol khusus. Perhatikan bahwa `Keys` hanya bekerja pada item yang sedang fokus.

**Jebakan**
- Urutan Tab "acak" karena urutan deklarasi berbeda dari urutan visual. Susun ulang kode atau pakai `KeyNavigation`.
- `focusPolicy: Qt.NoFocus` pada tombol penting: pengguna keyboard tak bisa menjangkaunya.
- Cincin fokus hilang karena `background` kustom tidak memeriksa `visualFocus`. Itu pelanggaran aksesibilitas.

## 9.1.8 Lab terpadu: formulir keyboard-first `[TAMBAHAN]`

Berkas `Kontrol.qml`. Latihan 15 menit di kurikulum (ComboBox peran, nilai tampil di log saat tombol ditekan) sudah terpenuhi di sini.

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true; width: 420; height: 360; title: 'Controls Lab'

    header: ToolBar {
        Label { anchors.centerIn: parent; text: root.title; font.bold: true }
    }

    Action {
        id: kirimAksi
        text: 'Kirim'
        shortcut: 'Ctrl+Return'
        enabled: nama.acceptableInput && setuju.checked
        onTriggered: console.log('kirim:', nama.text, peran.currentValue, aktif.checked)
    }

    GridLayout {
        anchors.fill: parent; anchors.margins: 16
        columns: 2; columnSpacing: 12; rowSpacing: 10

        Label { text: 'Nama' }
        TextField {
            id: nama
            Layout.fillWidth: true
            placeholderText: 'huruf kecil, angka, _ atau -'
            validator: RegularExpressionValidator { regularExpression: /[a-z_][a-z0-9_-]{0,31}/ }
        }

        Label { text: 'Peran' }
        ComboBox {
            id: peran
            Layout.fillWidth: true
            model: [ { t: 'Admin', v: 'admin' }, { t: 'Editor', v: 'editor' } ]
            textRole: 't'; valueRole: 'v'
        }

        Label { text: 'Aktif' }
        Switch { id: aktif; checked: true }

        CheckBox { id: setuju; Layout.column: 1; text: 'Saya memeriksa data ini' }

        Item { Layout.columnSpan: 2; Layout.fillHeight: true }

        Button {
            Layout.columnSpan: 2; Layout.alignment: Qt.AlignRight
            action: kirimAksi
            highlighted: true
        }
    }
}
```

**Alur kerja**

```
Tab -> Nama -> Peran -> Aktif -> Setuju -> Kirim
Ketik nama valid + centang Setuju -> Action.enabled = true
Ctrl+Enter (atau Space pada tombol) -> onTriggered -> log
```

**Bedah ringkas**
- `enabled: nama.acceptableInput && setuju.checked` adalah binding. Tombol Kirim hidup hanya jika nama lolos validator dan kotak dicentang. `acceptableInput` bernilai benar jika isi cocok penuh dengan validator.
- `Layout.column: 1` memaksa `CheckBox` ke kolom kedua. Tak perlu `Item` pengisi di kolom pertama.
- `Layout.alignment: Qt.AlignRight` meratakan tombol ke kanan.
- Logika ditulis sekali di `Action`. Tombol dan pintasan keyboard memakainya bersama.

**Latihan tambahan**
1. Tambahkan `MenuBar` dengan menu `&Berkas` yang memuat `kirimAksi`.
2. Ganti `Switch` dengan `RadioButton` berkelompok dan lihat bagaimana `ButtonGroup` bekerja.
3. Jalankan dengan `QT_QUICK_CONTROLS_STYLE=Basic` dan `...=Fusion`, lalu bandingkan (pemanasan untuk 9.2).
4. Jalankan `qmllint6 Kontrol.qml` dan perbaiki setiap peringatan.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Control** | Tipe dasar semua kontrol; punya `background`, `contentItem`, `padding`, `font`, `palette`, fokus |
| **contentItem / background** | Isi dan latar sebuah kontrol; keduanya bisa diganti (9.2) |
| **Ukuran implisit** | Ukuran yang "diinginkan" kontrol dari isinya; dipakai layout |
| **Properti terlampir** | Properti yang disediakan tipe lain, ditulis `Tipe.properti` (`Layout.fillWidth`) |
| **Binding** | Properti berisi ekspresi yang dihitung ulang otomatis |
| **Sinyal / handler** | Kejadian (`clicked`) dan penanganannya (`onClicked`) |
| **checked / down / hovered** | Status tercentang / sedang ditekan / kursor di atas |
| **toggled vs clicked** | `toggled` hanya oleh pengguna dan hanya untuk kontrol centang; `clicked` untuk klik |
| **Action** | Perintah tunggal (teks, pintasan, status aktif) yang dipakai banyak kontrol |
| **Key sequence** | Kombinasi tombol, mis. `'Ctrl+S'` |
| **textRole / valueRole** | Peran model untuk tampilan dan untuk nilai logika |
| **Validator / acceptableInput** | Penyaring isi input / apakah isi saat ini sah |
| **echoMode** | Cara karakter ditampilkan (`Password` menyamarkan) |
| **focusPolicy / visualFocus** | Cara kontrol menerima fokus / fokus dari keyboard |
| **Focus scope** | Wilayah fokus terisolasi (`Page`, `ComboBox`, `SpinBox`, dst.) |
| **Rantai Tab** | Urutan loncatan fokus saat menekan Tab |
| **Layout.\*** | Properti terlampir yang mengatur peran anak dalam layout |

## Hubungan dengan modul lain

- **Prasyarat:** 4.4 (`TextInput` dan dasar input), 5.1 (komponen sebagai API), 5.2 (Layouts), 5.3 (tema dan singleton, yang akan Anda sambungkan ke `palette` di 9.2.4), 6.3 (keyboard), 7.1–7.2 (model untuk `ComboBox`/`ListView`), 8.2 (pemisahan logika dari tampilan).
- **Menjadi dasar untuk:** 9.2 (mengganti `contentItem`/`background` dan memilih style), 9.3 (`Page` di dalam `StackView`, popup dan dialog), 9.4 (`Accessible.*`, `qsTr`, dan fokus keyboard sebagai syarat aksesibilitas).
- **Jalur C++ paralel (Modul 10.1):** `ComboBox`/`ListView` nanti memakai model C++, dan `QQuickStyle` dipanggil dari C++ (9.2.2).

## Tips dan praktik terbaik

1. **Satu `Action`, banyak pemakai.** Tombol, menu, dan pintasan menunjuk ke objek yang sama.
2. **Gunakan `Label`, bukan `Text`,** agar font dan warna ikut style serta tema gelap/terang.
3. **Pisahkan nilai dari tampilan** dengan `valueRole`. Teks tampilan boleh diterjemahkan, nilai logika tidak.
4. **Uji dengan keyboard saja** di setiap kontrol: Tab, Shift+Tab, Space, Enter, panah, Esc.
5. **Selalu jalankan `qmllint6`** sebelum menganggap kode selesai.
6. **Jangan simpan atau log data sensitif** (kata sandi, token) di properti atau konsol.
7. **Tetapkan batas pada input** (validator, `maximumLength`) sebagai lapisan pertama. Validasi sungguhan tetap di logika.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| `Rectangle` + `TapHandler` sebagai tombol | Tak ada fokus, Space, atau peran aksesibel | Pakai `Button`; kustomisasi lewat `background`/`contentItem` |
| `width:` pada anak `Layout` | Diabaikan | `Layout.preferredWidth` / `Layout.fillWidth` |
| `onClicked` untuk memantau `CheckBox` | Melewatkan perubahan | `onToggled` atau `onCheckedChanged` |
| `currentText` sebagai nilai logika | Rusak saat diterjemahkan | `valueRole` + `currentValue` |
| `TextArea` tanpa `ScrollView` | Teks terpotong | Bungkus dengan `ScrollView` |
| Banyak anak langsung di `ScrollView` | Hanya satu yang jadi konten | Satu `ColumnLayout`/`Item` pembungkus |
| Lupa `visible: true` | Tak ada jendela | Tambahkan pada `ApplicationWindow` |
| Urutan Tab acak | Pengguna keyboard tersesat | Samakan urutan deklarasi dengan visual atau pakai `KeyNavigation` |
| `background` kustom tanpa `visualFocus` | Cincin fokus hilang | Gambar status fokus di `background` |
| `SpinBox` untuk desimal (< 6.11) | Hanya bilangan bulat | Pola ×100, atau `DoubleSpinBox` (≥ 6.11) |

## Cek pemahaman: jawaban

**Mengapa `Button` lebih baik daripada `Rectangle` dengan `TapHandler`?** `Button` sudah membawa tiga hal yang tidak dimiliki `Rectangle`:
- perilaku (fokus, Space, status `down`/`hovered`);
- gaya yang mengikuti style dan tema;
- peran aksesibel yang dikenali pembaca layar.

`Rectangle` + `TapHandler` hanya menangani klik pointer. Anda harus membangun sisanya sendiri, dan biasanya ada yang terlewat.

## Referensi

*Halaman style dan fokus saya verifikasi lewat pencarian. Tautan tipe lain mengikuti pola URL dokumentasi resmi Qt 6. Jika ada yang berpindah, cari nama tipenya di doc.qt.io.*

- [Qt Quick Controls (indeks)](https://doc.qt.io/qt-6/qtquickcontrols-index.html) · [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html)
- [Styling Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-styles.html) · [Focus Management in Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-focus.html) · [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html)
- Tipe: [Control](https://doc.qt.io/qt-6/qml-qtquick-controls-control.html) · [ApplicationWindow](https://doc.qt.io/qt-6/qml-qtquick-controls-applicationwindow.html) · [Page](https://doc.qt.io/qt-6/qml-qtquick-controls-page.html) · [AbstractButton](https://doc.qt.io/qt-6/qml-qtquick-controls-abstractbutton.html) · [Button](https://doc.qt.io/qt-6/qml-qtquick-controls-button.html) · [Action](https://doc.qt.io/qt-6/qml-qtquick-controls-action.html) · [ButtonGroup](https://doc.qt.io/qt-6/qml-qtquick-controls-buttongroup.html) · [CheckBox](https://doc.qt.io/qt-6/qml-qtquick-controls-checkbox.html) · [RadioButton](https://doc.qt.io/qt-6/qml-qtquick-controls-radiobutton.html) · [Switch](https://doc.qt.io/qt-6/qml-qtquick-controls-switch.html) · [TextField](https://doc.qt.io/qt-6/qml-qtquick-controls-textfield.html) · [TextArea](https://doc.qt.io/qt-6/qml-qtquick-controls-textarea.html) · [Label](https://doc.qt.io/qt-6/qml-qtquick-controls-label.html) · [SearchField](https://doc.qt.io/qt-6/qml-qtquick-controls-searchfield.html) · [Slider](https://doc.qt.io/qt-6/qml-qtquick-controls-slider.html) · [SpinBox](https://doc.qt.io/qt-6/qml-qtquick-controls-spinbox.html) · [DoubleSpinBox](https://doc.qt.io/qt-6/qml-qtquick-controls-doublespinbox.html) · [ComboBox](https://doc.qt.io/qt-6/qml-qtquick-controls-combobox.html) · [RangeSlider](https://doc.qt.io/qt-6/qml-qtquick-controls-rangeslider.html) · [ScrollView](https://doc.qt.io/qt-6/qml-qtquick-controls-scrollview.html) · [SplitView](https://doc.qt.io/qt-6/qml-qtquick-controls-splitview.html)
- Pendukung: [KeyNavigation](https://doc.qt.io/qt-6/qml-qtquick-keynavigation.html) · [RegularExpressionValidator](https://doc.qt.io/qt-6/qml-qtquick-regularexpressionvalidator.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- Rilis 6.12: [Qt 6.12 LTS Released](https://www.qt.io/blog/qt-6.12-released) · [What's New in Qt 6.12](https://doc.qt.io/qt-6/whatsnew612.html) · [Diskusi StyleKit](https://forum.qt.io/topic/165049/stylekit)
- Arch: [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

# Audit Singkat Modul 9.2

**Terverifikasi benar**
- Style "Default" memang diganti nama menjadi "Basic" di Qt 6. Aplikasi Qt 5 yang tidak menyebut style tetapi mengustomisasi kontrol sebaiknya menyebut Basic secara eksplisit. Poin "Kesalahan umum" kurikulum akurat.
- Pemilihan style saat runtime membuat compiler QML tidak bisa menghasilkan C++ untuk binding properti tipe Controls. Compiler tetap bisa melakukannya untuk tipe dari modul lain. Klaim kurikulum benar, dan perbedaan "tipe Controls saja" perlu dipertahankan.
- Fusion bawaan Linux dan status StyleKit (Qt Labs, eksperimental) sudah saya konfirmasi di audit 9.1.

**Perlu koreksi**
1. **FluentWinUI3 `[≥6.7]` keliru.** Halaman style menyebut "Since: Qt 6.8". Tabel perlu diubah menjadi `[≥6.8]`. Tabel juga perlu mencatat bahwa style ini bukan native, tampil hampir sama di semua platform, memakai aset gambar, dan sebagian elemennya mungkin tak bisa dikustomisasi.
2. **Empat cara memilih style belum punya prioritas.** Urutan prioritas dari tertinggi ke terendah: `QQuickStyle::setStyle()`, argumen `-style`, variabel `QT_QUICK_CONTROLS_STYLE`, lalu `qtquickcontrols2.conf`. Urutan di kurikulum berbeda dari urutan prioritas ini, jadi harus ditambahkan.
3. **"Native tidak mendukung kustomisasi".** Dokumentasi menyebut secara eksplisit style macOS dan Windows tidak cocok dikustomisasi. iOS tidak disebut di catatan itu. Perlakukan iOS dengan hati-hati, bukan sebagai fakta mutlak.
4. **Imagine.** Kolom "dapat dikustomisasi" kurang tepat. Imagine dikustomisasi dengan mengganti aset gambar lewat konvensi nama berkas `<kontrol>-<elemen>-<status>`. Ini mekanisme berbeda dari mengganti `background`.
5. **"Style Native" (6.12)** adalah impor compile-time ke style bawaan platform, bukan tampilan baru (lihat audit 9.1). Ia masuk ke 9.2.2.

**TAMBAHAN yang ditambahkan ke Modul 9.2**
Prioritas pemilihan, impor compile-time vs run-time, *fallback style*, `QT_QUICK_CONTROLS_CONF`, atribut terlampir Material/Universal (+ varian Dense), pewarisan palette/font, konfigurasi `[Material]`/`[Imagine]`/`Font\`/`Palette\`, aturan performa style kustom, tipe `T.*` dari `QtQuick.Templates`, file selector, dan StyleKit sebagai catatan.

**Prasyarat dan urutan:** tidak ada yang meloncat. 9.2 membutuhkan `background`/`contentItem` dari 9.1.0, dan CMake dari 8.3 untuk resource konfigurasi.

## Daftar isi Modul 9.2 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 9.2.1 | Daftar style dan karakternya (+ FluentWinUI3 `[≥6.8]`, Imagine berbasis aset) |
| 9.2.2 | Cara memilih style: empat cara + prioritas + compile-time/`Native` + *fallback* `[TAMBAHAN]` |
| 9.2.3 | Kustomisasi `contentItem` dan `background` (tiga cara, anatomi per kontrol) |
| 9.2.4 | Palette, font, dan atribut style (Material/Universal, varian Dense) |
| 9.2.5 | Dampak ke performa dan kompilasi QML |
| 9.2.6 | Membuat style sendiri (`T.*`, `qmldir`, aturan performa, atribut terlampir C++) |
| 9.2.7 | File selector dan StyleKit `[TAMBAHAN]` |
| 9.2.8 | Lab terpadu: bandingkan style, konfigurasi, style kustom `[TAMBAHAN]` |

---

# Modul 9.2 — Style dan Kustomisasi Controls

## Deskripsi dan peran dalam kurikulum

Di 9.1 Anda memakai kontrol apa adanya. Modul ini menjawab tiga pertanyaan:
- **Bagaimana memilih rupa seluruh aplikasi?** (style)
- **Bagaimana mengubah satu kontrol saja?** (kustomisasi)
- **Apa harganya?** (performa dan kompilasi)

Ini menentukan apakah aplikasi Anda tampak konsisten atau tambal-sulam, dan apakah sistem desain Anda bisa dirawat.

## Konsep kunci dan filosofi

**Analogi.** Style adalah kostum seluruh pemain, dan kustomisasi adalah mengubah kostum satu pemain. Kostum pabrikan tertentu (native) tidak boleh dijahit ulang. Alasannya, style macOS kadang menggambar isi dan latar sekaligus ke satu item `background`, sehingga tidak serasi dengan `contentItem` kustom.

**Filosofi.** Satu prinsip dipegang sepanjang modul: *ubah sedikit mungkin, di tempat serendah mungkin, dengan sumber tunggal.*

```
Terpusat ------------------------------------------- Terlokal
conf / env      style kustom      file sendiri      inline
(seluruh app)   (seluruh app)     (1 jenis)         (1 objek)
```

**Pondasi sintaks yang dipakai**
- **Impor bernama:** `import QtQuick.Controls.Basic` mengimpor style Basic secara eksplisit.
- **Atribut terlampir:** `Material.theme: Material.Dark` menempelkan atribut milik style ke objek.
- **Tipe `T.Button`:** *template* tanpa tampilan dari `QtQuick.Templates`, bahan dasar style.
- **`qmldir`:** daftar tipe sebuah modul QML.

## 9.2.1 Daftar style dan karakternya

> *Kenali semua kostum sebelum menjahit kostum sendiri.*

- **Basic.** Style ringan serba guna dengan performa maksimum. Ini fondasi terbaik untuk kustomisasi.
- **Fusion.** Style lintas platform dengan nuansa desktop. Ini bawaan di Linux.
- **Imagine.** Berbasis aset gambar. Aset diganti dengan menyediakan direktori gambar dan mengikuti pola nama `<kontrol>-<elemen>-<status>`. Bagian status bersifat opsional.
- **Material.** Bukan style native Android, melainkan implementasi lintas platform yang tampil nyaris sama di mana-mana. Ia membutuhkan sumber daya lebih banyak daripada Basic.
- **Universal.** Berbasis pedoman desain Microsoft, juga lebih berat daripada Basic.
- **FluentWinUI3 `[≥6.8]`.** Gaya Fluent/WinUI 3 (lihat koreksi di audit).
- **Windows, macOS, iOS.** Tampilan native yang hanya tersedia di platformnya masing-masing. Hindari mengustomisasinya.

Bawaan per platform bila Anda tidak memilih: Android Material, iOS style iOS, Linux Fusion, macOS style macOS, Windows style Windows. Platform lain memakai Basic.

```
Pilih style untuk apa?
 |-- Dasar untuk sistem desain sendiri ------> Basic
 |-- Rasa desktop + dasar kustomisasi -------> Fusion
 |-- Desainer menyuplai aset 9-patch --------> Imagine
 |-- Tema siap pakai (gelap/terang, aksen) --> Material / Universal
 '-- Ikuti platform persis ------------------> style native (jangan dikustomisasi)
```

**Jebakan.** Mengira Material adalah "native Android". Mengira iOS/Windows/macOS bisa dikustomisasi bebas.

## 9.2.2 Cara memilih style

> *Satu keputusan di tempat yang benar menghemat seratus perbaikan.*

**Dua mekanisme dasar**
- **Run-time selection.** Anda mengimpor `QtQuick.Controls`, dan plugin memilih style yang ditetapkan saat berjalan. Manfaatnya, satu biner bisa mendukung banyak style.
- **Compile-time selection.** Anda mengimpor style langsung, mis. `QtQuick.Controls.Material`. Manfaatnya, compiler QML tahu style yang dipakai dan bisa menghasilkan C++ untuk binding. Satu executable hanya mendukung satu style.

**Empat cara run-time (prioritas tertinggi ke terendah)**

```
 TERTINGGI  1. QQuickStyle::setStyle("Basic")      C++, sebelum QML dimuat
     |      2. -style Basic                         argumen baris perintah
     |      3. QT_QUICK_CONTROLS_STYLE=Basic        variabel lingkungan
 TERENDAH   4. qtquickcontrols2.conf                [Controls] Style=Basic
 (Impor compile-time menimpa semuanya.)
```

Prioritasnya mengikuti urutan itu. Misalnya, `QQuickStyle` selalu menang atas argumen baris perintah. Jika impor compile-time dicampur dengan run-time, compile-time yang menimpa.

```bash
# (3) variabel lingkungan
QT_QUICK_CONTROLS_STYLE=Fusion qml6 Kontrol.qml
# (4) berkas konfigurasi di lokasi kustom
QT_QUICK_CONTROLS_CONF=$PWD/qtquickcontrols2.conf qml6 Kontrol.qml
```

```ini
# qtquickcontrols2.conf
[Controls]
Style=Basic
FallbackStyle=Basic
```

Secara bawaan berkas konfigurasi dimuat dari resource aplikasi di `:/qtquickcontrols2.conf`, dan variabel `QT_QUICK_CONTROLS_CONF` menentukan lokasi lain. Untuk rilis, masukkan berkasnya ke resource (CMake dari Modul 8.3):

```cmake
qt_add_resources(app "konfigurasi" PREFIX "/" FILES qtquickcontrols2.conf)
```

```cpp
// main.cpp  (C++, jalur Modul 10.1)
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");              // SEBELUM QML dimuat
    QQmlApplicationEngine engine;
    engine.loadFromModule("App", "Main");        // sesuaikan dengan URI proyek Anda
    return app.exec();
}
```

Tautkan `Qt6::QuickControls2` di CMake (`find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)`).

**Bedah kode**
- `#include <QQuickStyle>` membawa kelas `QQuickStyle`.
- `QQuickStyle::setStyle("Basic")` menetapkan style. Panggil sebelum QML yang mengimpor Controls dimuat.
- `engine.loadFromModule("App", "Main")` memuat tipe `Main` dari modul `App`.
- `Qt6::QuickControls2` adalah pustaka tempat `QQuickStyle` berada.

**Compile-time**

```qml
// Satu style tertentu:
import QtQuick.Controls.Basic

// Atau style bawaan platform:
import QtQuick.Controls.Native
```

`QtQuick.Controls.Native` mengimpor style bawaan platform target. Jika memakainya, jangan impor style lain maupun `QtQuick.Controls` run-time.

**Fallback style.** Style yang dipakai untuk kontrol yang tidak diimplementasikan style utama. Diatur lewat `FallbackStyle` di berkas konfigurasi, dan secara bawaan Basic. Ada juga `QQuickStyle::setFallbackStyle()` dan `QT_QUICK_CONTROLS_FALLBACK_STYLE`.

**Aturan impor ganda (penting).** Style yang Anda inginkan harus diimpor lebih dulu sebelum impor Controls lain. Style yang terakhir diimpor adalah yang sebenarnya dipakai. Jangan pernah mengimpor dua style berbeda secara eksplisit dalam satu aplikasi.

**Opsi lain**

| Cara | Cocok untuk | Kelemahan |
| --- | --- | --- |
| Impor compile-time | Performa, satu tampilan tetap | Tidak bisa ganti style saat berjalan |
| `QQuickStyle::setStyle()` | Aplikasi C++ yang mengunci style | Harus sebelum QML dimuat |
| `-style` | Uji cepat | Tidak permanen |
| Variabel lingkungan | Preferensi sistem/CI/uji | Mengubah perilaku tanpa jejak di kode |
| `qtquickcontrols2.conf` | Pengaturan terpusat + atribut style | Harus ada di resource atau lewat env |

**Jebakan**
- Menetapkan style setelah QML dimuat: tidak berefek.
- Menaruh `conf` di luar resource tanpa `QT_QUICK_CONTROLS_CONF`: tidak terbaca.
- Mencampur impor `Controls` dan beberapa style.

## 9.2.3 Kustomisasi `contentItem` dan `background`

> *Sentuhan kecil di tempat yang tepat mengubah seluruh rasa.*

**Konsep.** Qt Quick Controls berupa hierarki item, dan implementasi QML default tiap item bisa diganti dengan versi kustom. Karena item penyusun sebuah kontrol dirancang bekerja bersama, Anda mungkin perlu mengganti beberapa item sekaligus. Tidak semua style bisa dikustomisasi.

**Cara 1: inline (sekali pakai)**

```qml
import QtQuick
import QtQuick.Controls.Basic

ApplicationWindow {
    visible: true; width: 360; height: 160; title: 'Kustomisasi'

    Button {
        id: simpan
        anchors.centerIn: parent
        text: 'Simpan'

        contentItem: Text {
            text: simpan.text
            font: simpan.font
            color: simpan.enabled ? 'white' : '#9ca3af'
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            implicitWidth: 120; implicitHeight: 40; radius: 6
            color: !simpan.enabled ? '#374151'
                 : simpan.down     ? '#1d4ed8'
                 : simpan.hovered  ? '#3b82f6' : '#2563eb'
            border.width: simpan.visualFocus ? 3 : 0
            border.color: '#f59e0b'
        }
    }
}
```

**Bedah kode**
- `import QtQuick.Controls.Basic` mengunci style Basic (compile-time) supaya kustomisasi tampil konsisten.
- `contentItem: Text { ... }` mengganti isi tombol. `text: simpan.text` dan `font: simpan.font` mengambil nilai dari kontrolnya, sehingga tetap tunduk pada `text` dan `font` luar.
- `color: simpan.enabled ? ...` membuat teks pudar saat nonaktif.
- `elide: Text.ElideRight` memotong teks panjang dengan "...".
- `background: Rectangle { ... }` mengganti latar. `implicitWidth`/`implicitHeight` memberi ukuran yang diinginkan agar layout tidak salah hitung (9.1.0).
- Rantai `? :` membaca status secara berurutan: nonaktif, ditekan (`down`), kursor di atas (`hovered`), lalu normal.
- `visualFocus` menggambar cincin fokus oranye hanya untuk fokus keyboard (9.1.7).

**Cara 2: berkas sendiri**

```qml
// MyButton.qml  (satu folder dengan pemakainya)
import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control
    property color warna: '#2563eb'            // API baru (Modul 5.1)

    contentItem: Text {
        text: control.text; font: control.font; color: 'white'
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        implicitWidth: 100; implicitHeight: 40; radius: 6
        color: control.down ? Qt.darker(control.warna, 1.3) : control.warna
    }
}
```

Pemakaian: `MyButton { text: 'Simpan'; warna: '#16a34a' }`. `property color warna` menambah API baru. `Qt.darker(warna, 1.3)` menggelapkan warna.

**Cara 3: folder dengan namespace**

```qml
import QtQuick.Controls.Basic
import 'controls' as MyControls

ApplicationWindow {
    MyControls.Button { text: 'Simpan' }
}
```

Dengan namespace, Anda bisa menamai kontrol sesuai pasangannya di modul Controls. Ketiga cara ini tidak bisa mengustomisasi `ToolTip` terlampir. Itu harus menjadi bagian dari style Anda sendiri (9.2.6).

**Anatomi item per kontrol** (rujukan: bagian *Customization Reference* di dokumentasi)

| Kontrol | Item yang bisa diganti |
| --- | --- |
| Button, ToolButton, ProgressBar, ScrollBar | `background`, `contentItem` |
| CheckBox, RadioButton, Switch | `background`, `contentItem`, `indicator` |
| Slider, Dial | `background`, `handle` |
| RangeSlider | `background`, `first.handle`, `second.handle` |
| SpinBox | `background`, `contentItem`, `up.indicator`, `down.indicator` |
| ComboBox | `background`, `contentItem`, `indicator`, `popup`, `delegate` |
| TextField, TextArea, Pane, Frame, Page | `background` |
| GroupBox | `background`, `label` |

**Opsi lain**
- Untuk mengubah warna teks saja, cukup properti langsung: `Label { color: '...' }`.
- Untuk mengubah warna banyak kontrol sekaligus, pakai palette (9.2.4), jangan menyalin `background` ke mana-mana.
- Untuk tampilan sistemik, buat style sendiri (9.2.6).

**Jebakan**
- Mengganti `background` tanpa `implicitWidth`/`implicitHeight`: ukuran jadi 0.
- Mengganti `contentItem` tanpa memikirkan padding dan `elide`.
- Mengustomisasi style native: hasilnya tidak terduga.
- Lupa memakai `visualFocus` sehingga pengguna keyboard kehilangan petunjuk fokus.

## 9.2.4 Palette, font, dan atribut style

> *Warna dan huruf yang konsisten adalah bahasa yang dipahami semua orang.*

**Palette**
- Palette terdiri dari tiga grup warna: `active`, `disabled`, dan `inactive`. Grup `active` adalah bawaan, dan warnanya dipakai grup lain bila tidak ditentukan.
- Warna yang tidak Anda tentukan diisi dari `SystemPalette`, atau dari style yang sedang dipakai.
- Beberapa style memakai sebagian warna palette, tetapi banyak style memakai warna independen. Jadi cek dulu apakah style Anda membaca role yang Anda ubah.
- Di Qt 6 API palette dipindah ke `QQuickItem`, sehingga semua item (dan juga `Window` dan `Popup`) punya properti `palette`.

```qml
ApplicationWindow {
    visible: true; width: 360; height: 160
    palette.buttonText: 'salmon'               // semua grup
    palette.disabled.buttonText: 'lavender'    // hanya saat nonaktif

    Column {
        anchors.centerIn: parent; spacing: 8
        Button { text: 'Aktif' }
        Button { text: 'Nonaktif'; enabled: false }
    }
}
```

**Bedah kode**
- `palette.buttonText` adalah role warna teks tombol. Karena grup `active` menjadi bawaan, nilai ini berlaku untuk grup lain juga.
- `palette.disabled.buttonText` menimpa khusus kondisi nonaktif.
- Nilai di `ApplicationWindow` diwariskan ke semua anak.

Pola menyambungkan Singleton tema (Modul 5.3). Sesuaikan nama anggota dengan Singleton Anda:

```qml
palette {
    window: Tema.latar
    windowText: Tema.teks
    button: Tema.permukaan
    buttonText: Tema.teks
    highlight: Tema.aksen
}
```

**Font**
Atur sekali di akar, dan anak mewarisinya:

```qml
ApplicationWindow {
    font.family: 'JetBrains Mono'     // contoh; ganti dengan font terpasang di sistem Anda
    font.pixelSize: 15
}
```

**Atribut style (Material)**
- `theme`, `primary`, `accent`, `foreground`, dan `background` merambat ke anak seperti font. `elevation`, `roundedScale`, dan `containerStyle` tidak merambat.
- `Material.theme` bernilai `Light` (bawaan), `Dark`, atau `System`. Aksen bawaan Pink dan primary bawaan Indigo.
- Atribut yang diatur di QML menang atas env dan berkas konfigurasi.

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    visible: true; width: 360; height: 200
    Material.theme: Material.Dark
    Material.accent: Material.Teal
    Column {
        anchors.centerIn: parent; spacing: 8
        Button { text: 'Biasa' }
        Button { text: 'Sorot'; highlighted: true }
        Pane { Material.elevation: 6; Label { text: 'Kartu' } }
    }
}
```

Atribut Material hanya berefek bila aplikasi dijalankan dengan style Material. Dengan style lain, kode yang sama tetap jalan. Karena itu, file selector bisa dipakai untuk tweak spesifik-style tanpa membuat ketergantungan keras pada style.

**Varian Dense (Material)**
Varian padat membuat kontrol dan font lebih kecil, dan direkomendasikan untuk desktop. Aktifkan lewat `QT_QUICK_CONTROLS_MATERIAL_VARIANT=Dense` atau `Variant=Dense` di `conf`.

**Konfigurasi terpusat**

```ini
[Controls]
Style=Material

[Material]
Theme=Dark
Accent=Teal
Primary=BlueGrey
Variant=Dense

[Universal]
Theme=System
Accent=Violet

[Basic]
Font\Family=Monospace
Font\PixelSize=15
Palette\Window=#1e1e2e
Palette\WindowText=#cdd6f4
```

Berkas konfigurasi mengenal bagian `Controls`, `Imagine`, `Material`, dan `Universal`, serta sub-grup `Font` dan `Palette` untuk tiap style. Nilai di sini menjadi bawaan yang bisa ditimpa kode QML.

**Imagine: ganti aset**

```bash
mkdir imagine-assets      # taruh button-background.9.png, checkbox-indicator.png, dst.
QT_QUICK_CONTROLS_STYLE=Imagine \
QT_QUICK_CONTROLS_IMAGINE_PATH=$PWD/imagine-assets qml6 Kontrol.qml
```

`QT_QUICK_CONTROLS_IMAGINE_PATH` menunjuk direktori aset Imagine, dan bila tidak diisi dipakai aset bawaan. Dalam berkas konfigurasi: `[Imagine]` lalu `Path=imagine-assets`. Berkas `.9.png` adalah gambar 9-patch yang bisa diregangkan tanpa merusak sudut.

**Opsi lain**

| Sumber | Cakupan | Ketika |
| --- | --- | --- |
| Properti di objek (`color`, `font`) | Satu objek | Pengecualian |
| `palette`/`font` di akar | Satu jendela/subpohon | Tema aplikasi |
| Atribut style (`Material.*`) | Subpohon, khusus style itu | Tema sesuai style |
| `qtquickcontrols2.conf` | Seluruh aplikasi | Bawaan terpusat |
| Env `QT_QUICK_CONTROLS_*` | Seluruh proses | Uji, CI, preferensi sistem |

**Jebakan**
- Mengubah `palette.button` pada style yang tak membacanya: tidak terlihat.
- `Material.*` tanpa mengimpor `QtQuick.Controls.Material`: tidak tersedia.
- Menaruh warna "ajaib" di mana-mana. Satukan lewat palette atau Singleton.
- Menulis `Font\Family` dengan salah tulis (`Font.Family`): bagian konfigurasi diabaikan.

## 9.2.5 Dampak ke performa dan kompilasi QML

> *Cepat bukan kebetulan, melainkan keputusan yang diambil sejak awal.*

**Konsep**
- Run-time selection membuat compiler tidak tahu style mana yang dipakai, sehingga tak bisa menghasilkan C++ untuk binding properti tipe Controls. Compile-time selection sebaliknya.
- Compile-time selection juga membuat plugin `QtQuick.Controls` tidak terpakai dan tak perlu disertakan saat deployment.
- Basic adalah style dengan performa maksimum. Material dan Universal membutuhkan lebih banyak sumber daya.

```
                    RUN-TIME                       COMPILE-TIME
import           QtQuick.Controls          QtQuick.Controls.<Style> / .Native
style berubah?   ya (env, conf, C++)       tidak (terkunci di kode)
satu biner       banyak style              satu style
binding Controls  ditafsirkan               dikompilasi ke C++
```

**Aturan praktis**
1. Aplikasi dengan satu tampilan tetap: **compile-time** (impor style eksplisit, mis. Basic).
2. Aplikasi yang membiarkan pengguna memilih style: **run-time**, dan terima konsekuensinya.
3. Jangan mencampur. Jika terpaksa (mis. memuat QML pihak ketiga), impor style yang diinginkan lebih dulu sebelum impor Controls lain.
4. Gunakan `qmllint6` (Modul 8.4) untuk melihat peringatan sebelum rilis.

**Jebakan**
- Memakai `import QtQuick.Controls` di berkas style kustom: itu mencegah kode QML dikompilasi oleh compiler.
- Mengira run-time selection memperlambat seluruh aplikasi. Dampaknya terbatas pada binding tipe Controls, bukan modul lain.

## 9.2.6 Membuat style sendiri

> *Siapa yang membuat sistem desainnya sendiri memegang kemudi atas rupa aplikasinya.*

**Definisi style.** Style adalah sekumpulan berkas QML dalam satu direktori. Syarat pemakaiannya ada empat:
1. Minimal satu berkas bernama sesuai kontrol, mis. `Button.qml`.
2. Tiap berkas memakai tipe terkait dari `QtQuick.Templates` sebagai akar. Jika memakai tipe dari `QtQuick.Controls`, kontrolnya akan mencoba menurunkan dirinya sendiri.
3. Ada berkas `qmldir` di sebelahnya.
4. Direktori ada di jalur impor QML.

Di Qt 6, semua tipe yang diimplementasikan sebuah style harus dideklarasikan di `qmldir`. Tutorial Qt 5 yang hanya menaruh satu `Button.qml` sudah usang.

```
MyStyle/
|-- qmldir
`-- Button.qml
main.qml
```

```
# MyStyle/qmldir
module MyStyle
Button 2.15 Button.qml
import QtQuick.Controls.Basic auto
```

Baris `import ... auto` mengimpor *fallback*, sesuai contoh dokumentasi.

```qml
// MyStyle/Button.qml
import QtQuick
import QtQuick.Templates as T

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 12

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.palette.buttonText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        radius: 6
        color: control.down ? control.palette.dark : control.palette.button
        border.width: control.visualFocus ? 3 : 1
        border.color: control.visualFocus ? control.palette.highlight : control.palette.mid
    }
}
```

```qml
// main.qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true; width: 360; height: 160; title: 'Uji MyStyle'
    Button { anchors.centerIn: parent; text: 'Halo' }
}
```

```bash
QML_IMPORT_PATH=$PWD QT_QUICK_CONTROLS_STYLE=MyStyle qml6 main.qml
```

**Bedah kode**
- `import QtQuick.Templates as T` mengimpor template dengan alias `T`. `T.Button` adalah logika tombol tanpa tampilan.
- `implicitWidth: Math.max(...)` menghitung ukuran dari latar dan isi, ditambah inset dan padding. Pola ini mengikuti style bawaan.
- `padding: 12` memberi jarak isi ke tepi.
- `control.palette.buttonText` / `.button` / `.dark` / `.mid` / `.highlight` membaca role palette, sehingga style Anda ikut tema (9.2.4).
- `visualFocus` menggambar cincin fokus keyboard.
- `QML_IMPORT_PATH=$PWD` menambahkan direktori sekarang ke jalur impor, dan `QT_QUICK_CONTROLS_STYLE=MyStyle` memilih style. Nama style harus sama persis dengan nama direktori, termasuk huruf besar-kecil.

**Aturan performa style (wajib dipahami)**
- Jangan beri `id` pada implementasi `background`/`contentItem` di style. Qt hanya membuat item kustom bila tak ada `id`, sehingga pembuatan kontrol lebih cepat. Dengan `id`, kedua item (bawaan dan kustom) dibuat.
- Tetapkan item kustom secara deklaratif. Penugasan imperatif menyisakan item yatim.
- Jika Anda memakai `ScrollView` dan ingin `ScrollBar` kustom, implementasikan `ScrollBar.qml` dan `ScrollView.qml` keduanya.
- Fallback bawaan adalah Basic, dan style lain bisa dijadikan fallback lewat `QQuickStyle`.

**Atribut terlampir kustom (jalur C++).** Atribut terlampir cocok untuk properti yang berlaku di semua kontrol, mis. `theme` di Material dan Universal. Dokumentasi memberi contoh `MyStyle.elevation` dengan kelas C++ dan efek bayangan. Ini dibahas ulang di Modul 10.x.

**Opsi lain**
- **Satu modul per style** bila aplikasi memuat banyak style: modul akan dimuat sesuai kebutuhan.
- **Menyalin** `Button.qml` bawaan Basic sebagai titik awal (jalur dokumentasi: `$QTDIR/qml/QtQuick/Controls/Basic/Button.qml`). Di Arch, cek dulu dengan `pacman -Ql qt6-declarative | rg 'Basic/Button.qml'`. Jika tidak ada di disk, ambil dari [sumber Qt](https://code.qt.io/cgit/qt/qtdeclarative.git/tree/src/quickcontrols/basic).

**Jebakan**
- Akar berkas memakai `Button` dari `QtQuick.Controls`: kontrol menurunkan dirinya sendiri.
- Nama direktori style tak cocok dengan argumen (`mystyle` vs `MyStyle`).
- Lupa mendaftarkan tipe di `qmldir`.
- Direktori tak ada di jalur impor.
- Nama direktori file selector di Qt 6 berhuruf kapital: `+Material`, bukan `+material`.

## 9.2.7 File selector dan StyleKit `[TAMBAHAN]`

> *Pengecualian yang rapi adalah tanda arsitektur yang sehat.*

- **File selector.** Menyediakan berkas khusus-style tanpa ketergantungan keras: tata letak `+Material/HalamanUtama.qml` di samping `HalamanUtama.qml`. Di Qt 6 nama direktori selector berhuruf kapital. Rujukan: [Using File Selectors](https://doc.qt.io/qt-6.12/qtquickcontrols-fileselectors.html).
- **StyleKit.** Modul Qt Labs untuk mendefinisikan satu style lengkap dari satu objek Style, dengan dukungan tema dan transisi berbasis status. Statusnya Technology Preview. Di Qt 6.12 ia ada di Labs, dan dapat menyatukan gaya aplikasi yang memakai Widgets dan Qt Quick. Jangan dijadikan fondasi produksi sebelum API-nya stabil.

## 9.2.8 Lab terpadu `[TAMBAHAN]`

**Lab 1 (latihan di kurikulum): bandingkan tiga style lewat env**

```bash
ls /usr/lib/qt6/qml/QtQuick/Controls      # style yang terpasang (cek jalur di sistem Anda)
for s in Basic Fusion Material; do
  echo "== $s =="
  QT_QUICK_CONTROLS_STYLE=$s qml6 Kontrol.qml     # tutup jendela untuk lanjut
done
```

Perhatikan perbedaan ukuran, padding, cincin fokus, dan animasi. Jalankan `Kontrol.qml` dari Lab 9.1.8.

**Lab 2: uji prioritas**

```ini
# qtquickcontrols2.conf
[Controls]
Style=Material
[Material]
Theme=Dark
Accent=Teal
Variant=Dense
```

```bash
QT_QUICK_CONTROLS_CONF=$PWD/qtquickcontrols2.conf qml6 Kontrol.qml                  # Material (conf)
QT_QUICK_CONTROLS_CONF=$PWD/qtquickcontrols2.conf \
QT_QUICK_CONTROLS_STYLE=Basic qml6 Kontrol.qml                                      # Basic (env menang)
```

Hipotesis dari prioritas: pada percobaan kedua, env menang atas `conf`. Jika `conf` tidak terbaca lewat path berkas, uji dari resource (lihat 9.2.2).

**Lab 3: `MyStyle`**
Buat style dari 9.2.6, lalu bandingkan tampilannya dengan Basic.

**Lab 4 (tantangan):** tambahkan `CheckBox.qml` ke `MyStyle` (akar `T.CheckBox`, tambahkan `indicator`), daftarkan di `qmldir`, dan jalankan `Kontrol.qml` dengan style itu.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Style** | Kumpulan implementasi kontrol yang menentukan rupa dan perilaku visual |
| **Template (`T.`)** | Logika kontrol tanpa tampilan, dari `QtQuick.Templates` |
| **Run-time / compile-time selection** | Style dipilih saat berjalan / dikunci lewat impor |
| **Fallback style** | Style cadangan untuk kontrol yang tak diimplementasikan style utama |
| **`qtquickcontrols2.conf`** | Berkas konfigurasi style, dimuat dari resource |
| **Atribut terlampir style** | `Material.theme`, dsb., hanya efektif bila style terpilih |
| **Palette / ColorGroup** | Kumpulan warna role (`active`, `disabled`, `inactive`) |
| **SystemPalette** | Warna dari tema sistem |
| **9-patch** | Gambar peregangan dengan sudut tetap (Imagine) |
| **File selector** | Pemilihan berkas berdasar suffix lingkungan (`+Material`) |
| **`qmldir`** | Daftar tipe dan versi dari sebuah modul QML |
| **Import path** | Daftar direktori tempat modul QML dicari |
| **`implicitWidth/Height`** | Ukuran yang diinginkan item, dipakai layout |

## Hubungan dengan modul lain

- **Prasyarat:** 9.1 (anatomi `Control`, `visualFocus`), 5.1 (komponen sebagai API untuk `MyButton`), 5.3 (Singleton tema untuk palette), 8.3 (CMake dan resource `conf`), 8.4 (`qmllint`).
- **Mendukung:** 9.3 (Popup/Dialog/Menu juga memakai `background`/`contentItem`, dan `StackView` punya transisi bisa dikustomisasi), 9.4 (kontras warna, ukuran font, high-DPI).
- **Jalur C++ (Modul 10.1):** `QQuickStyle::setStyle()`, `setFallbackStyle()`, dan atribut terlampir kustom dari C++.

## Tips dan praktik terbaik

1. **Mulai dari Basic.** Ia paling ringan dan paling mudah diturunkan.
2. **Pilih satu mekanisme pemilihan** (compile-time atau run-time) dan jangan campur.
3. **Satukan warna** lewat palette atau Singleton, bukan literal tersebar.
4. **Jaga cincin fokus** (`visualFocus`) pada setiap `background` kustom.
5. **Uji dengan semua style** target (loop `for` di Lab 1) sebelum rilis.
6. **Dense untuk desktop** bila memakai Material.
7. **Bundel style dan `conf` ke resource** saat rilis.
8. **Perlakukan env sebagai permukaan serangan.** `QML_IMPORT_PATH` dan `QT_QUICK_CONTROLS_STYLE` memengaruhi kode QML mana yang dimuat. Di lingkungan sandbox atau layanan, kendalikan env dan bundel style dalam resource agar tak memuat QML dari lokasi tak tepercaya. Ini praktik hardening umum, bukan sesuatu yang dipaksakan Qt.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Mengustomisasi style native (Windows/macOS) | Tampilan tak terduga | Basis pada Basic/Fusion/Imagine/Material/Universal |
| Mengimpor dua style | Tema (font, palette) tak sesuai | Satu style, impor paling awal |
| `setStyle()` setelah QML dimuat | Tak berefek | Panggil sebelum QML dimuat |
| Mengira "Default" dan "Basic" berbeda di Qt 6 | Bingung tutorial Qt 5 | Default lama = Basic |
| `id` pada `background` di style | Item ganda, pembuatan lebih lambat | Hapus `id` |
| `import QtQuick.Controls` di berkas style | Tak bisa dikompilasi | Pakai `QtQuick.Templates` |
| Menaruh `conf` di luar resource | Tak terbaca | Resource, atau `QT_QUICK_CONTROLS_CONF` |
| `+material` huruf kecil (gaya Qt 5) | Selector tak cocok | `+Material` |
| `Material.*` tanpa impor Material | Atribut tak ada | Impor `QtQuick.Controls.Material` |
| Mengubah palette di style yang tak membacanya | Tak terlihat | Cek role yang dipakai style |
| `background` tanpa ukuran implisit | Ukuran 0 | Isi `implicitWidth`/`implicitHeight` |
| FluentWinUI3 dianggap tersedia di 6.7 | Gagal di Qt lama | Butuh Qt ≥ 6.8 |

## Cek pemahaman: jawaban

**Mengapa style native tidak boleh dikustomisasi, dan apa dampak memilih style saat runtime?**
- **Style native:** menggambar isi dan latar dengan kerangka kerja platform, kadang ke satu item `background`, sehingga tak serasi dengan `contentItem` kustom. Selain itu, tampilannya mengikuti tema platform dan bisa berubah antar versi minor Qt. Basis yang aman adalah style lintas platform seperti Basic atau Fusion.
- **Dampak run-time selection:** compiler QML tidak tahu style mana yang dipakai, sehingga tak bisa menghasilkan C++ untuk binding properti tipe Controls. Imbalannya, satu biner bisa mendukung banyak style.

## Referensi

*Halaman style, konfigurasi, env, kustomisasi, palette, Material, dan Imagine saya baca langsung dari dokumentasi Qt 6.12. Tautan lain mengikuti pola URL resmi.*

- [Styling Qt Quick Controls](https://doc.qt.io/qt-6.12/qtquickcontrols-styles.html) · [Customizing Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-customize.html) · [Qt Quick Controls Configuration File](https://doc.qt.io/qt-6.12/qtquickcontrols-configuration.html) · [Supported Environment Variables](https://doc.qt.io/qt-6.12/qtquickcontrols-environment.html) · [Using File Selectors](https://doc.qt.io/qt-6.12/qtquickcontrols-fileselectors.html)
- Style: [Basic](https://doc.qt.io/qt-6.12/qtquickcontrols-basic.html) · [Fusion](https://doc.qt.io/qt-6.12/qtquickcontrols-fusion.html) · [Imagine](https://doc.qt.io/qt-6.12/qtquickcontrols-imagine.html) · [Material](https://doc.qt.io/qt-6.12/qtquickcontrols-material.html) · [Universal](https://doc.qt.io/qt-6.12/qtquickcontrols-universal.html) · [FluentWinUI3](https://doc.qt.io/qt-6/qtquickcontrols-fluentwinui3.html) · [macOS](https://doc.qt.io/qt-6.12/qtquickcontrols-macos.html)
- API: [QQuickStyle](https://doc.qt.io/qt-6.12/qquickstyle.html) · [Palette](https://doc.qt.io/qt-6.12/qml-qtquick-palette.html) · [QtQuick.Templates](https://doc.qt.io/qt-6/qtquicktemplates2-index.html) · [Perubahan Qt Quick Controls di Qt 6](https://doc.qt.io/qt-6/qtquickcontrols-changes-qt6.html)
- Rilis dan StyleKit: [Qt 6.12 LTS Released](https://www.qt.io/blog/qt-6.12-released) · [Qt Labs StyleKit](https://doc.qt.io/qt-6/qtlabsstylekit-index.html) · [Diskusi StyleKit](https://forum.qt.io/topic/165049/stylekit)
- Arch: [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

# Audit Singkat Modul 9.3

**Terverifikasi benar**
- Contoh kurikulum (`StackView` + `Component` + `Page`, `stack.push(detail)`) valid. `push()` menerima `Item`, `Component`, atau `url`, dan pushing `Component` membuat instans yang dihancurkan saat di-pop.
- "Menumpuk halaman tanpa batas" dan "memuat semua halaman di awal" adalah jebakan nyata, dan keduanya punya solusi API (lihat 9.3.1 dan 9.3.2).

**Perlu koreksi atau penajaman**
1. **`Popup` bukan `Item`.** Popup mewarisi `QtObject`, dan diturunkan menjadi `Dialog`, `Drawer`, `Menu`, dan `ToolTip`. Ini harus ada di konsep dasar 9.3.4.
2. **`stack.pop()` di latihan.** Jika QML dikompilasi, dokumentasi menyarankan fungsi bertipe kuat: `popToItem`, `popToIndex`, `popCurrentItem` (sejak 6.7), serta `pushItem`, `pushItems`, dan `replaceCurrentItem`. Ini terhubung langsung ke 9.2.5. Latihan sebaiknya memakai `popCurrentItem()`.
3. **Tombol Escape.** Kurikulum tidak menyebut bahwa Popup menutup sendiri dengan Escape bila ia punya `activeFocus`, `closePolicy` mengandung `CloseOnEscape`, dan tombolnya adalah *cancel* standar. `focus` Popup bawaannya `false`. Ini harus masuk ke 9.3.5.
4. **Jenis popup (≥6.8).** Sejak Qt 6.8, `popupType` memilih `Item`, `Window`, atau `Native`. Tidak ada di kurikulum, dan menentukan perilaku di WM Anda.

**TAMBAHAN yang ditambahkan ke Modul 9.3**
`popupType`, `closePolicy`, `Overlay`, `ContextMenu` (≥6.9), `DialogButtonBox`/`standardButtons`, *item ownership* `StackView`, atribut terlampir `StackView.*`/`SwipeView.*`, sinkronisasi `TabBar`+`SwipeView`, `PageIndicator`, dan dialog sistem `QtQuick.Dialogs`. Modul `QtQuick.Dialogs` sejak Qt 6.2 menyediakan `ColorDialog`, `FileDialog`, `FolderDialog`, `FontDialog`, dan `MessageDialog`. Ini menutup catatan "dialog native" dari audit 9.1.

**Prasyarat dan urutan:** tidak ada yang meloncat. 9.3 memakai fokus (9.1.7), `Page`/`ApplicationWindow` (9.1.1), dan merujuk 8.2.

## Daftar isi Modul 9.3 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 9.3.1 | `StackView`: push/pop/replace, deep linking, *ownership*, transisi, atribut terlampir |
| 9.3.2 | `SwipeView`, `TabBar`, `PageIndicator` + pemuatan malas `[TAMBAHAN]` |
| 9.3.3 | `Drawer` (+ mode panel permanen) |
| 9.3.4 | `Popup`, `Dialog`, `Menu` (+ `popupType [≥6.8]`, `ContextMenu [≥6.9]`) |
| 9.3.5 | Tombol Escape dan navigasi keyboard |
| 9.3.6 | Pemisahan logika navigasi (Modul 8.2) |
| 9.3.7 | Dialog sistem `QtQuick.Dialogs` `[TAMBAHAN]` |
| 9.3.8 | Lab terpadu: aplikasi tiga layar `[TAMBAHAN]` |

---

# Modul 9.3 — Navigasi dan Popup

## Deskripsi dan peran dalam kurikulum

Aplikasi sungguhan punya banyak layar. Modul ini menjawab tiga pertanyaan:
- **Bagaimana berpindah antar layar?** (`StackView`, `SwipeView`, `TabBar`, `Drawer`)
- **Bagaimana menampilkan sesuatu di atas layar tanpa berpindah?** (`Popup`, `Dialog`, `Menu`)
- **Bagaimana semuanya tetap bisa dioperasikan dari keyboard?** (9.3.5)

Modul ini menyambung 9.1 (fokus dan layout) ke 9.4 (aksesibilitas).

## Konsep kunci dan filosofi

**Analogi.** `StackView` seperti tumpukan kartu: membuka halaman baru menaruh kartu di atas, kembali mengambilnya. `SwipeView` seperti deretan kartu sejajar yang digeser. `Popup` seperti kertas tempel di atas meja: ia tidak mengubah tumpukan, hanya menutupi sebagian.

**Dua jenis navigasi**

```
HIERARKIS (ada "kembali")          SEJAJAR (ada "sebelah")
StackView                          SwipeView / TabBar / StackLayout
[Beranda] -> [Daftar] -> [Detail]  [Umum] [Tampilan] [Lanjutan]
 push ->                            geser / pilih tab
 <- pop
```

**Lapisan di atas layar (overlay)**

```
+--------------------------------------------+
| ApplicationWindow                          |
|   header                                   |
|   contentItem  <- StackView/SwipeView      |
|   footer                                   |
|   overlay (lapisan Popup, Dialog, Drawer,  |
|            Menu, ToolTip)                  |
+--------------------------------------------+
```

## 9.3.1 `StackView`

> *Perjalanan terjauh bermula dari satu `push()`.*

**Konsep.** `StackView` adalah model navigasi berbasis tumpukan dengan tiga operasi utama: `push()` (maju), `pop()` (mundur), dan `replace()` (ganti item teratas). Item teratas adalah yang tampil (`currentItem`).

```qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true; width: 360; height: 240; title: 'StackView'

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: beranda
    }

    Component {
        id: beranda
        Page {
            title: 'Beranda'
            Button {
                anchors.centerIn: parent
                text: 'Buka detail'
                onClicked: stack.push(detail, { nomor: 7 })
            }
        }
    }

    Component {
        id: detail
        Page {
            property int nomor: 0
            title: 'Detail'
            Column {
                anchors.centerIn: parent; spacing: 8
                Label { text: 'Detail #' + nomor }
                Button { text: 'Kembali'; onClicked: stack.popCurrentItem() }
            }
        }
    }
}
```

**Bedah kode**
- `StackView { id: stack; anchors.fill: parent }` adalah wadah tumpukan yang memenuhi jendela.
- `initialItem: beranda` adalah halaman pertama. `initialItem` boleh berupa `Item`, `Component`, atau `url`, dan setara dengan memanggil `push()` saat komponen selesai.
- `Component { id: beranda; Page { ... } }` adalah *cetakan* halaman. Ia belum dibuat sampai di-push.
- `stack.push(detail, { nomor: 7 })` menumpuk halaman. Argumen kedua adalah peta nilai awal. Untuk item yang dibuat dinamis, nilai awal diterapkan sebelum pembuatan selesai, lebih efisien daripada mengatur properti sesudahnya.
- `property int nomor: 0` pada `Page` adalah properti yang menerima nilai awal tadi.
- `stack.popCurrentItem()` membuang halaman teratas. Ini sama dengan `popToIndex(currentIndex - 1)`, tersedia sejak 6.7.

**Operasi inti dan hasilnya** (tumpukan awal `[A, B, C]`)

| Operasi | Hasil | Catatan |
| --- | --- | --- |
| `push(D)` | `[A, B, C, D]` | Bila tumpukan kosong, tanpa transisi; selain itu transisi *push*. |
| `pop()` | `[A, B]` | Pada kedalaman 1 atau 0, tidak berbuat apa-apa; kosongkan dengan `clear()`. |
| `pop(null)` | `[A]` | "Unwind" ke dasar tumpukan. |
| `replace(D)` | `[A, B, D]` | Ganti teratas; transisi *replace*. |
| `push([D, E, F])` | `[A, B, C, D, E, F]` | Deep linking: hanya item terakhir yang dimuat, sisanya dimuat saat dibutuhkan. |

```
push(D)             pop()               replace(D)
[A,B,C] -> [A,B,C,D]  [A,B,C] -> [A,B]    [A,B,C] -> [A,B,D]
                C keluar                  C diganti D
```

**Atribut terlampir pada halaman**
- `StackView.status` bernilai `Inactive`, `Deactivating`, `Activating`, atau `Active`.
- `StackView.index` adalah posisi halaman, dan `StackView.view` adalah `StackView` yang memilikinya.
- Sinyal siklus hidup: `activating`, `activated`, `deactivating`, `deactivated`, `removed`.

```qml
Page {
    StackView.onActivated: forceActiveFocus()      // pindahkan fokus ke halaman baru
    StackView.onRemoved: console.log('halaman dilepas')
}
```

**Kepemilikan (*ownership*) item.** Ini sumber kebocoran memori yang umum.
- `StackView` hanya menghancurkan item yang ia buat sendiri dari `Component` atau `url`. Item instans yang Anda `push` tak pernah dihancurkan olehnya.
- Sinyal `StackView.onRemoved` bisa dipakai untuk menghancurkan item itu dengan aman.
- Item yang sudah ada di tumpukan tidak di-push lagi.

**Transisi**
Enam properti mengatur animasi: `pushEnter`, `pushExit`, `popEnter`, `popExit`, `replaceEnter`, `replaceExit`. Animasi saling memengaruhi, jadi mengubah satu dan membiarkan yang lain bisa memberi hasil tak terduga. Contoh efek pudar untuk push dan pop:

```qml
StackView {
    id: stack
    anchors.fill: parent
    pushEnter: Transition { PropertyAnimation { property: 'opacity'; from: 0; to: 1; duration: 150 } }
    pushExit:  Transition { PropertyAnimation { property: 'opacity'; from: 1; to: 0; duration: 150 } }
    popEnter:  Transition { PropertyAnimation { property: 'opacity'; from: 0; to: 1; duration: 150 } }
    popExit:   Transition { PropertyAnimation { property: 'opacity'; from: 1; to: 0; duration: 150 } }
}
```

Operasi tanpa animasi: `stack.push(halaman, {}, StackView.Immediate)`. Ini pas untuk pengguna yang tak suka animasi.

**Aturan ukuran dan jangkar**
- Anchors pada akar item yang ditambahkan ke `StackView` tidak didukung karena transisi menganimasikan posisi. Anchors pada anak-anaknya tetap normal.
- `StackView` tidak mewarisi ukuran implisit dari item yang di-push. Karena itu, memakainya sebagai isi `Dialog` memerlukan `implicitWidth`/`implicitHeight` atau ukuran eksplisit.

**Opsi lain**

```qml
// (1) Fungsi bertipe kuat (≥6.7), disarankan bila QML dikompilasi (Modul 9.2.5)
stack.pushItem(detail, { nomor: 7 })
stack.pushItems([ halamanA, halamanB ])
stack.replaceCurrentItem(halamanC)
stack.popToIndex(0)

// (2) Navigasi dari dalam halaman tanpa id tumpukan
StackView.view.push(detail)

// (3) Halaman dari berkas: StackView membuatnya dan menghancurkannya saat di-pop
stack.push('Detail.qml', { nomor: 7 })

// (4) StackLayout: semua halaman langsung dibuat, hanya satu tampil (tanpa riwayat)
StackLayout { currentIndex: 0; Item { } Item { } }
```

**Jebakan**
- Mem-push `Component` yang sama berulang sehingga tumpukan menggunung. Cek `stack.currentItem` atau gunakan `replace`.
- Meletakkan `anchors` pada akar halaman.
- Mem-push instans lalu mengira `StackView` akan menghancurkannya.
- `pop()` di kedalaman 1 dikira "keluar aplikasi".
- Melewatkan data sensitif (token, sandi) sebagai parameter halaman. Properti itu hidup selama halaman hidup.

## 9.3.2 `SwipeView`, `TabBar`, `PageIndicator`

> *Yang sejajar tak perlu ditumpuk, cukup digeser.*

**Konsep**
- `SwipeView` memberi navigasi berbasis geser: satu halaman tampil, pengguna menggeser ke samping. Ia sendiri tidak tampil, dan disarankan dipadukan dengan `PageIndicator`.
- `TabBar` adalah bilah tab (`TabButton`). Keduanya `Container` dan berbagi `currentIndex`.
- Gabungan `TabBar` + `SwipeView` adalah pola paling umum untuk halaman sejajar.

```qml
Page {
    header: TabBar {
        id: tab
        currentIndex: swipe.currentIndex
        TabButton { text: 'Umum' }
        TabButton { text: 'Tampilan' }
        TabButton { text: 'Lanjutan' }
    }

    SwipeView {
        id: swipe
        anchors.fill: parent
        currentIndex: tab.currentIndex

        Repeater {
            model: ['Umum', 'Tampilan', 'Lanjutan']
            Loader {
                id: halaman
                required property string modelData
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                sourceComponent: Label {
                    text: 'Halaman ' + halaman.modelData
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    PageIndicator {
        count: swipe.count
        currentIndex: swipe.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
```

**Bedah kode**
- `header: TabBar { ... }` memasang bilah tab di kepala `Page`.
- `currentIndex: swipe.currentIndex` dan `currentIndex: tab.currentIndex` adalah dua binding timbal balik, sehingga memilih tab menggeser halaman dan menggeser halaman menandai tab.
- `Repeater { model: [...] }` membuat satu `Loader` per elemen.
- `required property string modelData` menerima elemen larik dari `Repeater`.
- `SwipeView.isCurrentItem`, `.isNextItem`, `.isPreviousItem` adalah atribut terlampir. Rumus `active` ini menjaga paling banyak tiga halaman terinstansiasi sekaligus.
- `sourceComponent: Label { ... }` adalah halaman yang dimuat saat `active` benar. Saat menjadi `false`, ia dibongkar.
- `PageIndicator` adalah titik penunjuk halaman.

**Aturan penting**
- `SwipeView` mengambil alih geometri anak: `anchors` pada akar halaman tak didukung, dan `width`/`height` akan ditimpa.
- Untuk dua `currentIndex` yang saling terhubung, hindari mengatur `currentIndex` langsung dari kode agar binding tak putus. Gunakan `setCurrentIndex()`.
- Halaman bisa ditambah, disisipkan, dipindah, dan dihapus saat berjalan lewat metode `Container` (`addItem`, `insertItem`, `moveItem`, `removeItem`).
- `interactive: false` mematikan geser. `orientation: Qt.Vertical` mengubah arah.

**Keyboard.** `SwipeView` tidak otomatis menyediakan pintasan yang nyaman untuk desktop. Tambahkan sendiri:

```qml
Shortcut { sequence: 'Ctrl+PgDown'; onActivated: swipe.incrementCurrentIndex() }
Shortcut { sequence: 'Ctrl+PgUp';   onActivated: swipe.decrementCurrentIndex() }
```

**Opsi lain**
- `StackLayout` untuk halaman sejajar tanpa gestur geser. Semua halaman dibuat sekali.
- `Loader` tunggal dengan `source:` yang diganti, untuk satu halaman aktif.
- `TabBar` + `StackView` bila tiap tab punya riwayat sendiri.

**Jebakan**
- Memuat semua halaman di awal. Pakai `Loader` seperti di atas.
- Mengubah `currentIndex` langsung sehingga binding timbal balik putus. Pakai `setCurrentIndex()`.
- Menaruh `anchors` pada akar halaman `SwipeView`.

## 9.3.3 `Drawer`

> *Yang jarang dibutuhkan cukup bersembunyi di tepi.*

**Konsep**
- `Drawer` adalah panel samping berbasis geser, jenis `Popup` khusus yang berada di salah satu tepi jendela. Secara bawaan ia dipindah ke `overlay` jendela dan memakai koordinat jendela.
- `edge` bawaan adalah `Qt.LeftEdge`, `interactive` bawaan `true`, dan `position` bernilai 0.0 (tertutup) sampai 1.0 (terbuka penuh).
- `dragMargin` adalah jarak dari tepi layar tempat drag membuka drawer. Nilai 0 atau kurang mencegah pembukaan lewat drag.

```qml
ApplicationWindow {
    id: root
    visible: true; width: 480; height: 320
    header: ToolBar {
        ToolButton { text: 'Menu'; onClicked: laci.open() }
    }

    Drawer {
        id: laci
        y: root.header.height
        width: 0.5 * root.width
        height: root.height - root.header.height
        focus: true

        ColumnLayout {
            anchors.fill: parent
            ItemDelegate { Layout.fillWidth: true; text: 'Beranda';    onClicked: laci.close() }
            ItemDelegate { Layout.fillWidth: true; text: 'Pengaturan'; onClicked: laci.close() }
            Item { Layout.fillHeight: true }
        }
    }
}
```

Tambahkan `import QtQuick.Layouts`. Letak `y` dan `height` mengikuti contoh dokumentasi agar drawer muncul di bawah header.

**Bedah kode**
- `laci.open()` dan `laci.close()` adalah metode `Popup`. Penarikan dengan mouse atau sentuhan hanya salah satu cara.
- `y: root.header.height` dan `height: root.height - root.header.height` menempatkan drawer di bawah header. Anda tidak bisa mengatur `x` (atau margin horizontal) pada drawer di tepi kiri/kanan, maupun `y` pada tepi atas/bawah.
- `focus: true` memberi drawer fokus agar Escape menutupnya.
- `ItemDelegate` adalah baris yang bisa diklik. `Item { Layout.fillHeight: true }` adalah pengisi ruang.

**Keyboard dan desktop.** Drag dari tepi adalah gestur sentuh/mouse. Untuk antarmuka keyboard, sediakan pintasan:

```qml
Shortcut { sequence: 'F9'; onActivated: laci.visible ? laci.close() : laci.open() }
```

**Mode panel permanen (opsional).** Drawer dapat dijadikan panel samping permanen dengan membuatnya non-modal dan non-interaktif.

```qml
Drawer {
    id: panel
    width: 200; height: root.height
    modal: false; interactive: false
    closePolicy: Popup.NoAutoClose
    visible: true
}
StackView { anchors.fill: parent; anchors.leftMargin: panel.width * panel.position }
```

`anchors.leftMargin` menggeser isi agar tidak tertutup panel. Di sebagian platform, tepi tertentu dicadangkan untuk gestur sistem sehingga tak bisa dipakai.

**Jebakan**
- Drawer tak pernah terbuka di desktop karena hanya mengandalkan drag. Tambahkan tombol atau pintasan.
- Mencoba mengatur `x` drawer kiri/kanan.
- Isi drawer tanpa `focus: true` sehingga Escape tak menutupnya.

## 9.3.4 `Popup`, `Dialog`, `Menu`

> *Interupsi yang baik singkat, jelas, dan mudah ditutup.*

**Konsep dasar `Popup`**
- Popup bukan `Item`: ia mewarisi `QtObject`, dan anak-anak yang dideklarasikan di dalamnya otomatis dipasang ke `contentItem`. Item yang dibuat dinamis harus di-parent eksplisit ke `contentItem`.
- Bila tidak memakai jendela popup, `contentItem` dipindah ke `overlay` jendela agar tampil di depan segalanya. Tugas overlay mencegat event untuk item di bawah popup modal dan menutup popup menurut `closePolicy`.
- `modal` mencegah event menembus ke item di bawah, dan `dim` (redup) mengikuti `modal` kecuali diatur sendiri.

```qml
Button { text: 'Info'; onClicked: info.open() }

Popup {
    id: info
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    padding: 16
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    enter: Transition { NumberAnimation { property: 'opacity'; from: 0; to: 1; duration: 120 } }
    exit:  Transition { NumberAnimation { property: 'opacity'; from: 1; to: 0; duration: 120 } }

    ColumnLayout {
        Label { text: 'Popup modal' }
        Button { text: 'Tutup'; onClicked: info.close() }
    }
}
```

**Bedah kode**
- `Popup { id: info }` adalah objek non-visual sampai dibuka. `info.open()` dan `info.close()` mengatur tampilan.
- `anchors.centerIn: Overlay.overlay` memusatkan popup di jendela. Popup hanya bisa dipusatkan terhadap induk langsung atau overlay jendela; selain itu menghasilkan peringatan.
- `modal: true` memblokir interaksi di bawahnya.
- `focus: true` agar popup menerima fokus. Bawaannya `false`.
- `closePolicy` adalah gabungan flag: bawaannya `CloseOnEscape | CloseOnPressOutside`. Flag lain: `NoAutoClose`, `CloseOnPressOutsideParent`, `CloseOnReleaseOutside`, `CloseOnReleaseOutsideParent`, dan `CloseMultiple` untuk popup bersarang.
- `enter`/`exit` adalah `Transition` pembuka dan penutup. Setelah transisi keluar, `opacity` dan `scale` dikembalikan ke nilai awal.
- Isi dengan satu `ColumnLayout` membuat ukuran popup mengikuti isi. Dengan dua item, atur `contentWidth`/`contentHeight` sendiri.

**Jenis popup `[≥6.8]`**

| `popupType` | Arti |
| --- | --- |
| `Popup.Item` | Item di scene yang sama (bawaan umumnya) |
| `Popup.Window` | Jendela terpisah (`Qt::Popup`), bisa keluar dari batas jendela induk |
| `Popup.Native` | Popup native platform, dirender platform |

`Item` didukung di semua platform. `Window` dan `Native` umumnya hanya di desktop. Bila tak didukung, jatuh ke tingkat di bawahnya. Menu di dalam menubar native juga native, dan submenu mengikuti jenis menu induknya. Jika Anda mengustomisasi popup (mis. mengganti delegate), pertimbangkan `Popup.Window` agar perubahan terlihat. Pada popup native, delegate QML tak dipakai. Ini menghubungkan ke 9.2.3 dan 9.2.6.

**Pewarisan properti popup.** Popup mewarisi font, palette, dan atribut terlampir lewat jendelanya, bukan lewat induk objek atau visualnya. Popup juga tidak menurunkan propertinya ke popup anak. Jika popup Anda tampak tidak mengikuti tema pohonnya, inilah penyebabnya. Atur palette/font di `ApplicationWindow`, atau teruskan eksplisit.

**Perilaku popup tertutup.** Saat popup tertutup, ia tidak punya jendela dan anak-anaknya tidak di-*polish*. Karena itu, `ListView` di popup tertutup tidak dapat diandalkan untuk memperbarui `count`. Simpan hitungan di model.

**`Dialog`**
- `Dialog` adalah popup untuk tugas dan komunikasi singkat, terdiri atas `header`, `contentItem`, dan `footer`. Judulnya (`title`) ditampilkan di header, dan tombol standar dikelola oleh `DialogButtonBox` di footer.
- Dialog punya fokus secara bawaan.

```qml
Dialog {
    id: konfirmasi
    title: 'Keluar tanpa menyimpan?'
    modal: true
    anchors.centerIn: Overlay.overlay
    standardButtons: Dialog.Ok | Dialog.Cancel

    onOpened: standardButton(Dialog.Cancel).forceActiveFocus()
    onAccepted: console.log('dikonfirmasi')
    onRejected: console.log('dibatalkan')

    Label { text: 'Perubahan yang belum disimpan akan hilang.' }
}
```

**Bedah kode**
- `standardButtons: Dialog.Ok | Dialog.Cancel` memilih tombol standar. Tombolnya ditata sesuai konvensi platform pengguna.
- `onAccepted`/`onRejected` mengikuti peran tombol. Sinyal ini tidak dipancarkan bila dialog ditutup lewat `close()` atau `visible = false`.
- `onOpened: standardButton(Dialog.Cancel).forceActiveFocus()` memberi fokus awal ke tombol aman. Ini penting untuk dialog destruktif, supaya Enter yang terlanjur tidak langsung mengonfirmasi.
- Tombol lain: `Apply` memicu `applied`, `Discard` memicu `discarded`, `Reset` memicu `reset`, `Help` memicu `helpRequested`. Tombol `Yes`/`No` dipetakan ke peran *accept* dan *reject* di `DialogButtonBox`.
- Metode: `accept()`, `reject()`, `done(result)`, dan `standardButton(button)` yang mengembalikan tombolnya atau `null`.

**`Menu`**

```qml
Button { id: tombolBerkas; text: 'Berkas'; onClicked: menuBerkas.popup(tombolBerkas, 0, tombolBerkas.height) }

Menu {
    id: menuBerkas
    Action { text: '&Baru';  shortcut: StandardKey.New;  onTriggered: console.log('baru') }
    Action { text: '&Buka…'; shortcut: StandardKey.Open }
    MenuSeparator { }
    Menu {
        title: 'Terbaru'
        Action { text: 'a.txt' }
        Action { text: 'b.txt' }
    }
    MenuSeparator { }
    Action { text: '&Keluar'; shortcut: StandardKey.Quit; onTriggered: Qt.quit() }
}
```

**Bedah kode**
- `Menu { Action { ... } }` menjadikan `Action` (dari 9.1.2) sebagai butir menu. Perintah, pintasan, dan status aktif dipakai bersama.
- `MenuSeparator { }` adalah garis pemisah. `Menu { title: ... }` di dalam menu menjadi submenu.
- `shortcut: StandardKey.New` memakai pintasan standar platform (mis. Ctrl+N).
- `menuBerkas.popup(tombolBerkas, 0, tombolBerkas.height)` membuka menu relatif ke tombol. `&` menandai mnemonik.

**`ContextMenu` `[≥6.9]`**
Atribut terlampir `ContextMenu` membuka menu konteks dengan cara yang sesuai platform. `ContextMenu` sejak Qt 6.9 dan dapat dipasang pada item mana pun.

```qml
Label {
    text: 'Klik kanan di sini (atau tombol Menu)'
    ContextMenu.menu: Menu {
        MenuItem { text: 'Salin';  onTriggered: console.log('salin') }
        MenuItem { text: 'Tempel' }
    }
}
```

Dua catatan:
- `ContextMenu` membuat `Menu` secara malas (hanya saat diminta). Karena itu, `Menu` yang dideklarasikan langsung di situ sebaiknya tidak diberi `id`, sebab `id` menghilangkan optimasi itu.
- Bila `Menu` dibuka lewat `TapHandler` atau cara lain, `ContextMenu` tidak ikut terbuka. Ini menjaga aplikasi lama tetap bekerja.

**Latar redup (`Overlay`)**
Efek redup popup modal didefinisikan lewat `Overlay.modal`, dan popup non-modal lewat `Overlay.modeless`. Pasang di `ApplicationWindow`:

```qml
ApplicationWindow { Overlay.modal: Rectangle { color: '#aa000000' } }
```

**Opsi lain**

| Kebutuhan | Pilihan |
| --- | --- |
| Pesan singkat tanpa tombol | `ToolTip` atau `Popup` non-modal |
| Konfirmasi | `Dialog` modal (atau `MessageDialog`, 9.3.7) |
| Daftar perintah | `Menu` / `ContextMenu` |
| Menu aplikasi | `MenuBar` (lihat 9.1.1) |
| Isi kompleks | `Popup` + layout sendiri |

**Jebakan**
- Popup bukan `Item`, jadi `anchors` biasa dan sifat visual tak sama.
- `anchors.centerIn` ke item selain induk atau overlay.
- Menaruh `id` pada `Menu` yang dipasang ke `ContextMenu.menu`.
- Mengandalkan font/palette induk visual untuk popup.
- Dialog destruktif dengan fokus awal pada tombol berbahaya.

## 9.3.5 Tombol Escape dan navigasi keyboard

> *Keyboard adalah bahasa ibu bagi mereka yang tak menyentuh mouse.*

**Perilaku bawaan Popup.** Popup menutup sendiri bila punya `activeFocus`, `closePolicy`-nya mengandung `CloseOnEscape`, dan pengguna menekan tombol *cancel* standar (biasanya Escape). Untuk mencegahnya: jangan beri popup fokus, hilangkan `CloseOnEscape` dari `closePolicy`, atau tangani `Keys.escapePressed` pada anak popup sehingga ia menerima event lebih dulu.

**`StackView` tidak punya Escape bawaan.** Pola yang saya sarankan:

```qml
StackView {
    id: stack
    anchors.fill: parent
    focus: true
    Keys.onEscapePressed: if (depth > 1) popCurrentItem()
}
```

```qml
// di setiap halaman yang di-push:
Page { StackView.onActivated: forceActiveFocus() }
```

**Bedah kode**
- `Keys.onEscapePressed` adalah penanganan tombol Escape. Event dari item yang fokus merambat ke induknya sampai ada yang menerima, sehingga `StackView` menangkapnya bila tidak ada anak yang menerima.
- `focus: true` memberi fokus awal pada `StackView`.
- `StackView.onActivated: forceActiveFocus()` memindahkan fokus ke halaman yang baru aktif. Tanpa ini, fokus bisa tertinggal di halaman yang sudah hilang. `Page` adalah focus scope (lihat 9.1.7).
- Popup yang terbuka menerima Escape lebih dulu, jadi Escape menutup popup dan baru berikutnya menutup halaman.

**Alternatif: `Shortcut`**

```qml
Shortcut {
    sequence: 'Escape'
    enabled: stack.depth > 1 && !dialogHapus.visible && !laci.visible
    onActivated: stack.popCurrentItem()
}
```

`Shortcut` tidak peduli fokus. Ia lebih mudah menulisnya, tetapi bisa menangkap Escape yang seharusnya menutup popup. Beri syarat `enabled` seperti di atas, dan uji di aplikasi Anda.

**Peta tombol standar**

| Tombol | Hasil |
| --- | --- |
| Escape | Tutup popup/dialog/menu, lalu mundur satu halaman |
| Tab / Shift+Tab | Pindah fokus (9.1.7) |
| Space / Enter | Aktifkan tombol (umumnya Space; tergantung tema platform) |
| Panah di `Menu` | Pindah butir; Enter memilih |
| F9 (contoh) | Buka/tutup `Drawer` |
| Menu key / Shift+F10 | Menu konteks (`ContextMenu`, ≥6.9) |

**Catatan WM tiling.** `Popup.Item` hidup di dalam jendela utama, jadi tidak pernah menjadi jendela sendiri dan aman di WM tiling. `Popup.Window` dan dialog sistem (9.3.7) membuat jendela tingkat atas. Cara WM Anda memperlakukannya (mengambang atau ditata) harus diuji, dan sebagian WM butuh aturan mengambang.

**Jebakan**
- Escape tidak berfungsi karena `focus` tak diberikan (Popup bawaannya `false`).
- Fokus tertinggal di halaman yang sudah tidak ada setelah `pop`.
- `Shortcut` Escape bertabrakan dengan popup.
- Navigasi hanya bisa lewat mouse atau gestur.

## 9.3.6 Pemisahan logika navigasi (Modul 8.2)

> *Rute adalah data, bukan pecahan kode di tiap tombol.*

**Konsep.** Jika setiap halaman memanggil `stack.push(...)` langsung, halaman terikat pada satu `StackView` dan pada daftar rute di mana-mana. Pisahkan:
- **tampilan** (halaman) tidak tahu tumpukan;
- **logika** (objek navigasi) menyimpan daftar rute dan operasi tumpukan.

```
Halaman --nav.buka('detail', {...})--> Navigasi --> StackView
Halaman --nav.kembali()-------------> Navigasi --> StackView
        (tahu nama rute)             (tahu komponen dan aturan)
```

```qml
QtObject {
    id: nav
    readonly property var rute: ({ detail: cDetail, pengaturan: cPengaturan })

    function buka(nama, props) {
        const c = rute[nama]
        if (!c) { console.warn('rute tak dikenal:', nama); return }
        stack.push(c, props || {})
    }
    function kembali() { if (stack.depth > 1) stack.popCurrentItem() }
    function keAwal()  { stack.popToIndex(0) }
}
```

**Bedah kode**
- `readonly property var rute: ({ ... })` adalah peta nama rute ke komponen halaman (tanda kurung agar dibaca sebagai objek, bukan blok).
- `buka(nama, props)` mencari rute di peta. Nama yang tidak ada ditolak dengan peringatan, sehingga peta menjadi daftar putih.
- `kembali()` aman karena memeriksa `depth`.
- `keAwal()` memakai `popToIndex(0)` bertipe kuat (≥6.7).

**Keamanan.** Jika rute bisa datang dari luar (argumen CLI, D-Bus, tautan dalam), validasi lewat daftar putih seperti di atas. Jangan menaruh data rahasia pada parameter rute.

**Opsi lain**
- **Singleton `Navigasi`** (seperti Singleton tema di 5.3): `pragma Singleton`, didaftarkan di CMake dengan `QT_QML_SINGLETON_TYPE`. Cocok untuk aplikasi besar, tetapi perlu registrasi di build.
- **Sinyal dari halaman:** halaman memancarkan `signal minta(string tujuan)`, dan cangkang (jendela utama) yang memutuskan rute. Halaman benar-benar tak tahu navigasi.
- **`StackView.view`** (9.3.1) untuk kasus kecil.

**Jebakan**
- Menyebar `stack.push(...)` ke setiap tombol.
- Rute berupa string bebas tanpa daftar putih.
- Menyimpan status UI (`currentIndex`) di tampilan dan di logika sekaligus. Pilih satu sumber kebenaran.

## 9.3.7 Dialog sistem `QtQuick.Dialogs` `[TAMBAHAN]`

> *Beberapa pekerjaan lebih baik diserahkan kepada sistem.*

**Konsep.** Modul `QtQuick.Dialogs` memungkinkan membuat dan berinteraksi dengan dialog sistem dari QML. Dialog fallback (bila platform tak punya dialog native) diimplementasikan sebagai item di scene, bukan jendela tingkat atas, dan didasarkan pada Qt Quick Controls sehingga mengikuti style.

`FileDialog` native tersedia di Android, iOS, Linux (bila berjalan dengan tema platform GTK+), macOS, dan Windows. Selain itu, dipakai implementasi Qt Quick. Di Arch dengan WM minimalis (tanpa tema GTK), Anda biasanya akan melihat dialog fallback Qt Quick. Cek plugin tema yang terpasang:

```bash
ls /usr/lib/qt6/plugins/platformthemes     # lokasi bisa berbeda; lihat apa yang terpasang
```

```qml
import QtCore
import QtQuick.Dialogs

FileDialog {
    id: pilihBerkas
    title: 'Pilih berkas'
    currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    nameFilters: ['Teks (*.txt)', 'Semua (*)']
    onAccepted: console.log('dipilih:', selectedFile)
}
// pilihBerkas.open()
```

**Bedah kode**
- `import QtCore` membawa `StandardPaths`, dan `import QtQuick.Dialogs` membawa dialog sistem.
- `currentFolder` adalah folder awal, di sini folder rumah. `[0]` mengambil elemen pertama daftar jalur.
- `nameFilters` membatasi jenis berkas.
- `onAccepted` memakai `selectedFile` (bertipe `url`).
- Opsi `FileDialog.DontUseNativeDialog` memaksa implementasi Qt Quick non-native.

`MessageDialog` bekerja serupa (`text`, `buttons`, `onAccepted`). Periksa properti persisnya di dokumentasi sebelum dipakai.

**Pilih yang mana?**

| Kebutuhan | Pilihan |
| --- | --- |
| Dialog dengan isi bebas, serasi style | `Dialog` (Controls) |
| Konfirmasi standar | `Dialog` atau `MessageDialog` |
| Pilih berkas/folder/warna/font | `QtQuick.Dialogs` |
| Selalu tampil di dalam jendela (aman di WM tiling) | `Dialog` Controls, atau `DontUseNativeDialog` |

## 9.3.8 Lab terpadu `[TAMBAHAN]`

Berkas `Navigasi.qml`: tiga layar (`Beranda`, `Detail`, `Pengaturan`), `Drawer`, `Dialog` konfirmasi, menu konteks, `TabBar` + `SwipeView`, Escape, dan F9. Ini memenuhi latihan kurikulum (halaman ketiga dan tombol Escape).

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true; width: 560; height: 420; title: 'Lab 9.3'

    // ---------- logika navigasi (tanpa tampilan) ----------
    QtObject {
        id: nav
        readonly property var rute: ({ detail: cDetail, pengaturan: cPengaturan })

        function buka(nama, props) {
            const c = rute[nama]
            if (!c) { console.warn('rute tak dikenal:', nama); return }
            stack.push(c, props || {})
        }
        function kembali() { if (stack.depth > 1) stack.popCurrentItem() }
        function keAwal()  { stack.popToIndex(0) }
        function tanyaHapus(nomor) { dialogHapus.nomor = nomor; dialogHapus.open() }
    }

    Shortcut { sequence: 'F9'; onActivated: laci.visible ? laci.close() : laci.open() }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton { text: 'Menu'; onClicked: laci.open() }
            ToolButton { text: 'Kembali'; enabled: stack.depth > 1; onClicked: nav.kembali() }
            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                text: stack.currentItem ? stack.currentItem.title : ''
            }
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: cBeranda
        focus: true
        Keys.onEscapePressed: nav.kembali()
    }

    Drawer {
        id: laci
        y: root.header.height
        width: 0.4 * root.width
        height: root.height - root.header.height
        focus: true
        ColumnLayout {
            anchors.fill: parent
            ItemDelegate { Layout.fillWidth: true; text: 'Beranda';    onClicked: { nav.keAwal(); laci.close() } }
            ItemDelegate { Layout.fillWidth: true; text: 'Pengaturan'; onClicked: { nav.buka('pengaturan'); laci.close() } }
            Item { Layout.fillHeight: true }
        }
    }

    Dialog {
        id: dialogHapus
        property int nomor: 0
        title: 'Hapus item?'
        modal: true
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok | Dialog.Cancel
        onOpened: standardButton(Dialog.Cancel).forceActiveFocus()
        onAccepted: { console.log('hapus #' + nomor); nav.kembali() }
        Label { text: 'Item #' + dialogHapus.nomor + ' akan dihapus.' }
    }

    // ---------- halaman ----------
    Component {
        id: cBeranda
        Page {
            title: 'Beranda'
            StackView.onActivated: forceActiveFocus()
            ColumnLayout {
                anchors.centerIn: parent
                Label { text: 'Kedalaman tumpukan: ' + stack.depth }
                Button { text: 'Buka detail #7'; onClicked: nav.buka('detail', { nomor: 7 }) }
                Button { text: 'Pengaturan'; onClicked: nav.buka('pengaturan') }
            }
        }
    }

    Component {
        id: cDetail
        Page {
            property int nomor: 0
            title: 'Detail #' + nomor
            StackView.onActivated: forceActiveFocus()
            ColumnLayout {
                anchors.centerIn: parent
                Label {
                    text: 'Klik kanan di sini (atau tombol Menu)'
                    ContextMenu.menu: Menu {
                        MenuItem { text: 'Salin nomor'; onTriggered: console.log('salin', nomor) }
                    }
                }
                Button { text: 'Hapus…'; onClicked: nav.tanyaHapus(nomor) }
            }
        }
    }

    Component {
        id: cPengaturan
        Page {
            title: 'Pengaturan'
            StackView.onActivated: forceActiveFocus()
            header: TabBar {
                id: tab
                currentIndex: swipe.currentIndex
                TabButton { text: 'Umum' }
                TabButton { text: 'Tampilan' }
            }
            SwipeView {
                id: swipe
                anchors.fill: parent
                currentIndex: tab.currentIndex
                Repeater {
                    model: ['Pengaturan umum', 'Pengaturan tampilan']
                    Loader {
                        id: halaman
                        required property string modelData
                        active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                        sourceComponent: Label {
                            text: halaman.modelData
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
```

```bash
qml6 Navigasi.qml                                        # Fusion (bawaan Linux)
QT_QUICK_CONTROLS_STYLE=Basic qml6 Navigasi.qml          # bandingkan
qmllint6 Navigasi.qml                                    # akan memperingatkan akses id lintas-komponen
```

`ContextMenu` membutuhkan Qt ≥ 6.9. Peringatan `qmllint` soal akses tak terkualifikasi adalah materi Modul 8.4 (`pragma ComponentBehavior: Bound` dan `required property`).

**Alur uji keyboard**

```
Tab -> Beranda: tombol "Buka detail" -> Enter/Space -> Detail
Esc -> kembali ke Beranda          F9 -> buka/tutup Drawer
Detail: "Hapus..." -> Dialog; fokus awal ada di "Cancel"; Esc menutup
Shift+F10 / tombol Menu di label -> menu konteks
```

**Latihan tambahan**
1. Tambahkan halaman ketiga `cAbout` dan daftarkan di `rute`.
2. Ganti semua `stack.push(...)` dengan `stack.pushItem(...)` dan lihat apa yang `qmllint6` katakan.
3. Aktifkan `popupType: Popup.Window` pada sebuah `Menu`, lalu amati bagaimana WM Anda memperlakukannya.
4. Coba `StackLayout` sebagai pengganti `StackView` dan bandingkan perilaku riwayatnya.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Navigasi hierarkis** | Ada konsep "kembali" (tumpukan) |
| **`push` / `pop` / `replace`** | Tambah / buang teratas / ganti teratas pada `StackView` |
| **Deep linking** | Memulai atau mengubah tumpukan ke keadaan tertentu langsung |
| **Item ownership** | Siapa yang menghancurkan item (`StackView` hanya yang ia buat) |
| **Container** | Induk `TabBar`/`SwipeView` yang menyimpan `currentIndex` |
| **Loader** | Pemuat komponen sesuai kebutuhan (`active`, `sourceComponent`) |
| **Overlay** | Lapisan di atas isi jendela untuk popup |
| **Modal / modeless** | Memblokir / tidak memblokir interaksi di bawahnya |
| **`closePolicy`** | Aturan kapan popup menutup otomatis |
| **`popupType`** | `Item`, `Window`, atau `Native` (≥6.8) |
| **Focus scope** | Wilayah fokus terisolasi (`Page`, `StackView`, `Popup`) |
| **`standardButtons`** | Tombol standar `Dialog` (`Ok`, `Cancel`, `Discard`, dst.) |
| **Mnemonik** | Huruf bergaris bawah (`&Berkas`) untuk Alt+huruf |

## Hubungan dengan modul lain

- **Prasyarat:** 9.1 (fokus, `Page`, `ApplicationWindow`, `Action`), 9.2 (style memengaruhi tampilan popup; 9.2.5 terkait fungsi bertipe `pushItem`), 8.2 (pemisahan logika dan tampilan), 7.x (model untuk daftar di halaman), 5.3 (Singleton).
- **Mendukung:** 9.4 (fokus dan keyboard sebagai dasar aksesibilitas; `Accessible` pada tombol navigasi; terjemahan judul halaman/dialog), 8.4 (`qmllint` untuk akses lintas-komponen), jalur C++ (Modul 10.x): pemicu rute dari C++.

## Tips dan praktik terbaik

1. **Satu `StackView` per alur utama** dan akses lewat satu objek `nav`.
2. **Push `Component`/`url`, bukan instans**, agar `StackView` yang menghancurkan halaman.
3. **Muat halaman `SwipeView` dengan `Loader`** bila halamannya berat.
4. **Beri semua popup `focus: true`** bila ingin Escape bekerja, dan jangan hapus `CloseOnEscape` tanpa alasan.
5. **Dialog destruktif**: fokus awal pada tombol aman, dan teks tombol jelas (`Hapus`, bukan `Ok`).
6. **Daftar putih rute** untuk apa pun yang bisa datang dari luar proses.
7. **Sediakan pintasan keyboard** untuk setiap navigasi berbasis gestur (Drawer, SwipeView).
8. **Uji `popupType: Popup.Window`** di WM Anda sebelum memilihnya.
9. **Gunakan fungsi bertipe** (`pushItem`, `popToIndex`, `replaceCurrentItem`) bila QML dikompilasi.

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Menumpuk halaman tanpa batas | Memori naik, riwayat panjang | `replace`, `popToIndex`, atau cek halaman saat ini |
| Memuat semua halaman di awal | Start lambat | `Component`/`url` di `StackView`, `Loader` di `SwipeView` |
| `anchors` pada akar halaman | Transisi/geser rusak | Pakai anchors pada anak, bukan akarnya |
| Push instans lalu tak dihancurkan | Kebocoran | Push `Component`/`url`, atau `StackView.onRemoved: destroy()` |
| `currentIndex` diatur langsung | Binding `TabBar`↔`SwipeView` putus | `setCurrentIndex()` |
| Popup tanpa `focus` | Escape tak menutup | `focus: true` |
| Popup tak ikut tema | Font/palette beda | Atur di `ApplicationWindow` atau teruskan eksplisit |
| `Menu` ber-`id` pada `ContextMenu.menu` | Pembuatan malas tak terjadi | Hapus `id`, atau definisikan terpisah dan tunjuk |
| `Shortcut` Escape bentrok popup | Popup dan halaman menutup sekaligus | Beri syarat `enabled`, atau pakai `Keys.onEscapePressed` |
| Drawer hanya bisa di-drag | Tak terpakai di desktop | Tombol dan pintasan keyboard |
| Dialog destruktif dengan fokus pada konfirmasi | Konfirmasi tak sengaja | Fokus awal ke tombol Batal |
| Rute dari input luar tanpa validasi | Penyalahgunaan navigasi | Daftar putih seperti `nav.rute` |

## Cek pemahaman: jawaban

**Kapan `SwipeView` lebih tepat dari `StackView`?**
- **`SwipeView`:** halaman *sejajar* dan setara (tab, onboarding, karusel), tanpa konsep "kembali ke halaman sebelumnya". Pengguna berpindah ke samping, dan semua halaman adalah sibling. Gunakan `Loader` bila halamannya berat.
- **`StackView`:** alur *hierarkis* atau menukik (daftar ke detail ke edit), dengan riwayat dan tombol kembali. `StackView` juga membuat dan menghancurkan halaman per push dan pop, sehingga hemat memori.
- **Rumus cepat:** ada "kembali"? Pakai `StackView`. Ada "sebelah"? Pakai `SwipeView` atau `TabBar`.

## Referensi

*Halaman Popup, StackView, Dialog, Drawer, SwipeView, ContextMenu, dan QtQuick.Dialogs saya baca langsung dari dokumentasi Qt 6.12. Tautan lain mengikuti pola URL resmi.*

Modul 9.4 adalah modul penutup Fase 9. Urutannya sama: audit singkat, materi penuh, lalu berhenti untuk konfirmasi.

---

# Audit Singkat Modul 9.4

**Terverifikasi benar**
- Qt 6 tidak lagi membutuhkan flag untuk menyalakan penskalaan high-DPI. Klaim kurikulum ("selalu menyala") tepat.
- Alur `lupdate`, Qt Linguist, `lrelease` valid. Qt Quick dan C++ memakai sistem lokalisasi yang sama, termasuk berkas `.ts` dan `.qm`.
- `qt_add_translations(hello TS_FILES hello_id.ts)` masih sah. Berkas `.ts` boleh disebut lewat `TS_FILES`, tetapi lebih nyaman membiarkan perintah ini menentukan jalurnya sendiri.
- Daftar kesalahan umum (teks tanpa `qsTr`, string digabung manual, ikon tanpa nama aksesibel, hanya warna) semuanya valid.

**Perlu koreksi atau penajaman**
1. **Bahasa sumber dan bahasa target bertabrakan.** Contoh kurikulum menulis `qsTr('Simpan')` (sumber Indonesia), lalu membuat `hello_id.ts` dan meminta "terjemahkan satu string". Itu menerjemahkan Indonesia ke Indonesia. Pilih salah satu: sumber Inggris + target `id`, atau sumber Indonesia + target `en`. Bahasa sumber diatur lewat `I18N_SOURCE_LANGUAGE` dan bahasa target lewat `I18N_TRANSLATED_LANGUAGES` pada `qt_standard_project_setup`. Lab saya memakai sumber `id` dan target `en`.
2. **Alur CMake modern belum ada.** Tambahkan `find_package(Qt6 ... LinguistTools)`, `qt_standard_project_setup(I18N_TRANSLATED_LANGUAGES ...)`, dan `qt_add_translations(target)`. `.qm` otomatis di-embed dan dapat diakses di prefix resource `:/i18n`. Berkas `.ts` khusus bentuk jamak untuk bahasa sumber dibuat otomatis kecuali `NO_GENERATE_PLURALS_TS_FILE` diberikan. Perintah ini juga membuat target `update_translations`.
3. **Uji Orca butuh langkah pengaktifan.** Di Unix/X11 aplikasi baru menjadi aksesibel bila properti D-Bus `org.a11y.Status.IsEnabled` dan `ScreenReaderEnabled` bernilai true, atau bila variabel `QT_LINUX_ACCESSIBILITY_ALWAYS_ON` diatur. Variabel itu ada biayanya: laporan upstream menyebut dampak performa yang besar bila selalu menyala. Jadi hanya untuk uji.
4. **Atribut `Accessible` terlalu sedikit.** Terminologi kurikulum (`name`, `description`, `role`) perlu ditambah. Properti lain: `ignored`, `focusable`, `checkable`/`checked`, dan `id` untuk uji UI (`id` bawaannya mengikuti `id` objek QML). `labelledBy`/`labelFor` ada sejak 6.10. Ada juga sinyal aksi (`pressAction`, `toggleAction`, `increaseAction`, `decreaseAction`), dan metode `Accessible.announce()` sejak Qt 6.8.
5. **Fungsi penanda terjemahan terlalu sedikit.** QML mengenal `qsTr()`, `qsTranslate()`, `qsTrId()`, `QT_TR_NOOP()`, `QT_TRANSLATE_NOOP()`, dan `QT_TRID_NOOP()`. Tambahkan `Qt.uiLanguage` dan `retranslate()`.
6. **Kerentanan terjemahan.** Terjemahan Qt dikontribusikan komunitas tanpa jaminan, dan bisa salah hingga berbahaya. Dokumentasi menyarankan mengaudit terjemahan yang Anda sertakan. Ini masuk ke praktik terbaik.
7. **Catatan koreksi dari saya (Modul 9.1.2).** Saya menulis tombol diaktifkan "umumnya Space". Dokumentasi aksesibilitas Qt Quick menyebut tombol bisa dijangkau dengan Tab dan diaktifkan dengan Return atau Enter. Tombol aktivasi sebenarnya bergantung pada tema platform, jadi uji di sistem Anda.

**TAMBAHAN yang ditambahkan ke Modul 9.4**
RTL dan *mirroring*, WCAG kontras beserta fungsi hitungnya, `QT_TR_NOOP`/`qsTrId`, terjemahan modul Qt, pergantian bahasa saat berjalan (`retranslate`), `FontMetrics` sebagai satuan `em`, variabel lingkungan DPI, dan `accerciser`.

**Prasyarat dan urutan:** tidak ada yang meloncat. 9.4 memakai fokus (9.1.7, 9.3.5), CMake (8.3), dan Controls (9.1).

## Daftar isi Modul 9.4 (pembaruan, salin ke README)

| No | Sub-topik |
| --- | --- |
| 9.4.1 | Atribut `Accessible` (`name`, `description`, `role`, `ignored`, `focusable`, aksi, `announce`) |
| 9.4.2 | Navigasi keyboard penuh |
| 9.4.3 | `qsTr` dan alur terjemahan (CMake, `lupdate`, Linguist, `lrelease`, modul Qt, pergantian bahasa) |
| 9.4.4 | Format tanggal, angka, mata uang, dan pluralisasi |
| 9.4.5 | High-DPI dan font (`em`, aset `@2x`, variabel lingkungan) |
| 9.4.6 | Uji dengan Orca dan `accerciser` |
| 9.4.7 | RTL dan *mirroring* `[TAMBAHAN]` |
| 9.4.8 | Kontras, warna, dan preferensi sistem `[TAMBAHAN]` |
| 9.4.9 | Lab terpadu: aplikasi yang dapat diterjemahkan dan diaksesibel `[TAMBAHAN]` |

---

# Modul 9.4 — Aksesibilitas, Internasionalisasi, dan DPI

## Deskripsi dan peran dalam kurikulum

Tiga topik ini punya satu tujuan: **aplikasi yang dapat dipakai siapa saja, dalam bahasa apa pun, di layar apa pun.** Modul ini menutup Fase 9. 9.1 memberi kontrol, 9.2 memberi rupa, 9.3 memberi alur, dan 9.4 menjaga semuanya tetap bisa dipakai oleh orang, bahasa, dan perangkat yang berbeda.

## Konsep kunci dan filosofi

**Analogi.** Aksesibilitas adalah pintu yang bisa dilalui kursi roda sekaligus orang berdiri. Internasionalisasi adalah menu yang bisa diganti bahasa tanpa membongkar dapur. High-DPI adalah peta yang tetap terbaca di kertas kecil maupun papan besar.

**Filosofi.** Tiga hal itu bukan "fitur tambahan". Aksesibilitas Qt mencakup UI yang skalabel, navigasi keyboard, warna dan kontras yang memadai, bunyi dan suara, serta dukungan alat bantu seperti pembaca layar. Akibat praktisnya: antarmuka berbasis keyboard, yang Anda sukai, adalah fondasi aksesibilitas, bukan pengecualian.

**Tiga kategori metadata yang dibaca alat bantu** (properti, aksi, dan relasi/navigasi):

```
Pembaca layar <----------------------> Aplikasi Qt (AT-SPI via D-Bus)
  membaca  : name, description, role, checked, value
  memicu   : pressAction, toggleAction, increaseAction
  menjelajah: hubungan item (induk, anak, fokus, labelledBy)
```

**Pondasi sintaks yang dipakai**
- **Atribut terlampir `Accessible`:** `Accessible.name: '...'` menempelkan metadata ke item.
- **Fungsi `qsTr('teks')`:** menandai teks agar bisa diterjemahkan.
- **Penanda `%1`, `%n`:** `%1` untuk sisipan nilai (`.arg()`), `%n` untuk bilangan jamak.
- **Objek `Locale`:** aturan format sebuah bahasa/negara.

## 9.4.1 Atribut `Accessible`

> *Satu nama yang jujur membuka antarmuka bagi mereka yang tak melihatnya.*

**Konsep.** Kontrol bawaan sudah punya fitur aksesibilitas, misalnya tombol bisa dijangkau dengan Tab. Karena itu memakai kontrol standar adalah awal yang baik. Anda hanya perlu memperjelas peran item QML bila perlu. Properti terpenting tipe `Accessible` adalah `name`, `description`, dan `role`.

- **`name`** harus singkat, jelas, terbaca manusia, dan tidak menyebut jenis kontrolnya, hanya namanya.
- **`description`** lebih panjang dan menjelaskan fungsi.
- **`role`** adalah jenis semantik (`Accessible.Button`, `Accessible.CheckBox`, dan seterusnya).
- Prinsip "label dalam nama": nama aksesibel sebaiknya memuat teks yang terlihat. `'Simpan dokumen'` untuk tombol `'Simpan'` aman, tetapi `'Kirim'` untuk tombol `'Simpan'` membingungkan pengguna perintah suara.

**Peran dan kewajibannya**

| Peran | Properti dan aksi yang diharapkan |
| --- | --- |
| `Button`, `CheckBox`, `RadioButton` | `pressAction` (setara klik); centang: `checkable`, `checked`, `toggleAction` |
| `Slider`, `SpinBox`, `Dial`, `ScrollBar` | nilai dan batas, serta `increaseAction`/`decreaseAction` |
| Semua elemen interaktif | `focusable` dan `focused`; ini penting walau di perangkat sentuh, karena pembaca layar sering punya fokus virtual yang berpindah antar item |

**Kontrol bawaan vs item kustom**

```qml
// (1) Tombol ikon: tak punya teks -> beri nama
ToolButton {
    icon.name: 'list-add'
    Accessible.name: qsTr('Tambah barang')
    Accessible.description: qsTr('Menambah jumlah barang satu')
    onClicked: root.jumlah++
}

// (2) Kontrol kustom: HARUS menyatakan peran, nama, fokus, dan aksi
Rectangle {
    id: kustom
    activeFocusOnTab: true
    implicitWidth: 8 * root.em; implicitHeight: 2.5 * root.em
    radius: 0.4 * root.em
    color: activeFocus ? '#1d4ed8' : '#2563eb'
    function aksi() { root.jumlah = 0 }

    Label { anchors.centerIn: parent; text: qsTr('Reset'); color: 'white' }
    TapHandler { onTapped: kustom.aksi() }
    Keys.onSpacePressed: aksi()
    Keys.onReturnPressed: aksi()

    Accessible.role: Accessible.Button
    Accessible.name: qsTr('Reset jumlah')
    Accessible.focusable: true
    Accessible.onPressAction: aksi()
}
```

**Bedah kode**
- `icon.name: 'list-add'` memilih ikon tema. Ia tak punya teks, jadi `Accessible.name` wajib ada.
- `activeFocusOnTab: true` memasukkan `Rectangle` ke rantai Tab (9.1.7).
- `TapHandler` melayani mouse dan sentuhan. `Keys.onSpacePressed` dan `Keys.onReturnPressed` melayani keyboard.
- `Accessible.role: Accessible.Button` menyatakan "ini tombol". Contoh dokumentasi untuk `Rectangle` sebagai tombol memakai peran `Button`, nama dari label, deskripsi, dan `onPressAction`.
- `Accessible.onPressAction: aksi()` dipanggil alat bantu. Efeknya harus sama dengan klik atau ketukan.
- Tanpa keempat hal itu (peran, nama, fokus, aksi), pembaca layar tidak tahu `Rectangle` itu tombol.

**Mengelompokkan atau menyembunyikan**
Dua label yang berdampingan secara visual tetapi item terpisah dapat diperlakukan sebagai satu, dengan menandai tiap label `Accessible.ignored: true` dan memberi nama pada induknya.

```qml
Row {
    Accessible.role: Accessible.StaticText
    Accessible.name: kecepatan.text + ' ' + qsTr('meter per detik')
    Label { id: kecepatan; text: qsTr('Kecepatan: %1').arg(5); Accessible.ignored: true }
    Label { text: qsTr('m/s'); Accessible.ignored: true }
}
```

**Media non-teks.** Teks pada dasarnya aksesibel, tetapi gambar, video, dan audio tidak. Mereka butuh metadata. Beri `role` (mis. `Chart`), `name`, dan `description` yang menyebut isinya.

**Label terkait `[≥6.10]`**

```qml
Label { id: lblNama; text: qsTr('Nama') }
TextField { Accessible.labelledBy: lblNama }
```

**Pengumuman dinamis `[≥6.8]`.** `Accessible.announce()` diperkenalkan di Qt 6.8. Tingkat kesopanan pengumuman: `Polite` atau `Assertive`. Pakai untuk perubahan penting yang tak mengubah fokus (pesan galat, selesai menyimpan). Periksa argumen persisnya di dokumentasi.

**Opsi lain**
- Pakai `Label`/`Text` untuk teks. Keduanya otomatis terbaca.
- Pakai `Button`/`CheckBox` standar, bukan merakit dari `Rectangle`.
- Untuk uji UI otomatis, `Accessible.id` memberi pengenal stabil.

**Jebakan**
- Ikon tanpa `Accessible.name`.
- `name` berisi jenis kontrol ("Tombol Simpan"). Pembaca layar sudah menyebut perannya.
- Kontrol kustom tanpa `role`/`focusable`/`onPressAction`.
- Dekorasi yang tak bermakna tetapi dibaca. Gunakan `Accessible.ignored: true`.

## 9.4.2 Navigasi keyboard penuh

> *Hormati keyboard, dan seluruh pengguna akan menghormati antarmuka Anda.*

**Konsep.** Navigasi keyboard penuh adalah syarat aksesibilitas. Jangan hanya bergantung pada mouse atau sentuhan. Izinkan navigasi keyboard dan sediakan pintasan untuk fungsi yang sering dipakai. Banyak pengguna (motorik terbatas, pembaca layar, pengguna mahir, dan Anda sendiri) tidak memakai pointer.

**Daftar periksa**

| Syarat | Cara |
| --- | --- |
| Semua kontrol terjangkau dengan Tab | `focusPolicy`, `activeFocusOnTab` (9.1.7) |
| Urutan Tab logis | Urutan deklarasi atau `KeyNavigation` |
| Fokus terlihat | `visualFocus` pada `background` (9.2.3) |
| Tidak ada jebakan keyboard | Popup modal harus bisa ditutup dengan Escape (9.3.5) |
| Tindakan penting punya pintasan | `Action` + `shortcut` + `ToolTip` |
| Mnemonik pada menu | `'&Berkas'` (Alt+B) |
| Fokus dipindah saat halaman berganti | `StackView.onActivated: forceActiveFocus()` (9.3.5) |

```qml
Action {
    id: simpanAksi
    text: qsTr('&Simpan')
    shortcut: StandardKey.Save
    onTriggered: console.log('simpan')
}

Button {
    action: simpanAksi
    ToolTip.visible: hovered || visualFocus
    ToolTip.text: simpanAksi.text.replace('&', '') + '  (' + qsTr('Ctrl+S') + ')'
}
```

**Bedah kode**
- `StandardKey.Save` memakai pintasan standar platform (biasanya Ctrl+S).
- `ToolTip.visible: hovered || visualFocus` menampilkan petunjuk saat kursor di atas *atau* fokus datang dari keyboard. Pengguna keyboard ikut melihat pintasannya.
- `text.replace('&', '')` membuang penanda mnemonik dari teks tooltip.

**Protokol uji tanpa mouse (lakukan setiap rilis)**
1. Cabut atau abaikan mouse. Jalankan aplikasi.
2. Tab dari awal sampai akhir. Semua kontrol terjangkau, urutan masuk akal, fokus terlihat.
3. Aktifkan setiap kontrol dengan keyboard (Space/Enter).
4. Buka setiap popup/dialog, lalu tutup dengan Escape. Fokus kembali ke pemicunya.
5. Uji semua pintasan.

**Opsi lain**
- `Keys.forwardTo` untuk meneruskan tombol ke item lain.
- `FocusScope` untuk wilayah fokus sendiri.
- `Shortcut` untuk pintasan global, dengan syarat `enabled` agar tak bentrok popup (9.3.5).

**Jebakan**
- Kontrol kustom tanpa `activeFocusOnTab`.
- Cincin fokus dihapus karena dianggap "jelek".
- Satu-satunya cara memicu tindakan hanya lewat hover atau klik kanan.
- Fokus tertinggal di halaman yang sudah hilang.

## 9.4.3 `qsTr` dan alur terjemahan

> *Satu kalimat yang bisa diterjemahkan membuka satu bahasa lagi bagi dunia.*

**Konsep.** Internasionalisasi (*i18n*) menyiapkan kode agar bisa diadaptasi. Lokalisasi (*l10n*) menyesuaikan untuk wilayah tertentu dengan menerjemahkan dan mengatur format. Internasionalisasi berarti merancang aplikasi agar dapat diadaptasi ke berbagai bahasa dan wilayah tanpa perubahan rekayasa. Dokumen QML selalu berkode UTF-8, dan `lupdate` juga mengharapkan sumber UTF-8.

**Aturan penandaan**

```qml
// SALAH: potongan tak bisa diterjemahkan; urutan kata berbeda tiap bahasa
text: qsTr('Halo ') + nama + qsTr(', Anda punya ') + n + qsTr(' pesan')

// BENAR: satu kalimat utuh dengan penanda posisi
text: qsTr('Halo, %1! Anda punya %2 pesan.').arg(nama).arg(n)

// Dengan disambiguasi (konteks makna):
text: qsTr('Buka', 'perintah menu')

// Data daftar: tandai saat deklarasi, terjemahkan saat tampil
readonly property var peran: [ QT_TR_NOOP('Admin'), QT_TR_NOOP('Editor') ]
// ... ComboBox { model: peran.map(p => qsTr(p)) }
```

**Bedah kode**
- `qsTr('...')` mengambil teks sumber, lalu mengembalikan terjemahan bila ada. Bila tidak, ia mengembalikan teks sumber itu sendiri.
- `%1`, `%2` adalah penanda posisi yang diisi `.arg(nilai)` secara berurutan.
- Argumen kedua `qsTr` adalah disambiguasi. Dua teks sama dengan makna berbeda diterjemahkan terpisah.
- `QT_TR_NOOP('Admin')` hanya menandai teks untuk `lupdate`. Terjemahannya dilakukan nanti dengan `qsTr(nilai)`. Pola ini dipakai dokumentasi untuk teks di model data.

**Alur kerja, dari kode sampai pengguna**

```
Kode QML (qsTr) --lupdate--> .ts (XML) --Qt Linguist--> .ts terjemahan
                                   --lrelease--> .qm (biner) --embed--> :/i18n/ --QTranslator--> UI
```

**Opsi 1: ID-based.** `qsTrId('id_simpan')` dengan `lrelease -idbased`. Untuk terjemahan berbasis ID, teruskan `LRELEASE_OPTIONS -idbased` ke `qt_add_translations`. Cocok untuk proyek besar dengan banyak bahasa.

**Konfigurasi CMake (modern)**

```cmake
find_package(Qt6 REQUIRED COMPONENTS Quick LinguistTools)
qt_standard_project_setup(
    I18N_SOURCE_LANGUAGE id          # bahasa teks di kode
    I18N_TRANSLATED_LANGUAGES en     # bahasa target
)
qt_add_translations(lab94)           # buat .ts, kompilasi .qm, embed ke :/i18n
```

`I18N_SOURCE_LANGUAGE` bawaannya `en`. Bila `qt_add_translations` tak memakai `TS_FILES`, nama berkas `.ts` mengikuti nama proyek, mis. `lab94_en.ts`.

```bash
cmake --build build --target update_translations    # ekstrak string baru ke .ts
linguist6 lab94_en.ts                                # terjemahkan (atau /usr/lib/qt6/bin/linguist)
cmake --build build                                  # kompilasi .qm dan embed
LANGUAGE=en ./build/lab94                            # jalankan dengan bahasa Inggris
```

| Perintah | Tujuan |
| --- | --- |
| `update_translations` | Memanggil `lupdate`: memindai sumber dan memperbarui `.ts` |
| `linguist6` | Qt Linguist, aplikasi penerjemah |
| `lrelease` (otomatis di build) | Mengubah `.ts` menjadi `.qm` |
| `LANGUAGE=en` | Memilih bahasa antarmuka saat uji |

Jika bahasanya tak berubah, cek `locale -a` dan variabel `LANG`/`LC_ALL`/`LANGUAGE`.

**Memuat terjemahan di C++.** Sisipkan di `main()` sebelum `QQmlApplicationEngine`:

```cpp
QTranslator appTr;
for (const QString &bahasa : QLocale::system().uiLanguages()) {
    if (appTr.load(":/i18n/lab94_" + QLocale(bahasa).name())) {
        app.installTranslator(&appTr);
        break;
    }
}
```

`uiLanguages()` mengembalikan daftar bahasa pilihan pengguna berurutan. Loop mencoba tiap bahasa hingga satu berkas `.qm` ditemukan. `:/i18n/` adalah lokasi resource tempat `qt_add_translations` menaruh `.qm`.

**Terjemahan modul Qt.** Tombol standar `Dialog` dan teks bawaan Controls berasal dari katalog Qt, bukan dari aplikasi Anda. Katalog untuk Qt Quick dan Qt Quick Controls berada di `qtdeclarative`. Pemuatannya memakai `QTranslator::load` dengan `QLibraryInfo::path(QLibraryInfo::TranslationsPath)`, lalu `installTranslator`.

```cpp
QTranslator qtTr;
if (qtTr.load(QLocale::system(), QStringLiteral("qtbase"), QStringLiteral("_"),
              QLibraryInfo::path(QLibraryInfo::TranslationsPath)))
    app.installTranslator(&qtTr);
// ulangi untuk "qtdeclarative" (Qt Quick Controls)
```

Cek yang terpasang di sistem Anda: `ls /usr/share/qt6/translations | rg '_id'` (lokasi bisa berbeda).

**Pergantian bahasa saat berjalan**
- Ganti translator dengan `installTranslator`/`removeTranslator`, lalu panggil `QQmlEngine::retranslate()` agar semua binding yang memakai terjemahan dievaluasi ulang.
- Bila Anda memakai `QQmlApplicationEngine` dan `Qt.uiLanguage` berubah, `retranslate()` dipanggil otomatis.

```cpp
qApp->removeTranslator(&appTr);
if (appTr.load(":/i18n/lab94_" + kode)) qApp->installTranslator(&appTr);
engine.retranslate();
```

**Jebakan pergantian bahasa.** Setelah perbaikan binding di Qt 6, `retranslate()` mengevaluasi ulang binding QML, tetapi tidak bisa mendeteksi string terjemahan yang datang dari C++. Teks dari C++ perlu properti ber-notify sendiri. Laporan lain menyebut teks di `PropertyChanges` tak ikut diterjemahkan ulang pada kasus tertentu. Uji di versi Qt Anda.

**Keamanan.** Terjemahan Qt komunitas dapat keliru sampai berbahaya, dan disarankan mengaudit terjemahan yang Anda kirim. Perlakukan berkas `.ts` yang Anda terima dari pihak lain sebagai masukan tak tepercaya: tinjau diff-nya sebelum `lrelease`.

**Jebakan**
- Menggabung potongan kalimat.
- Mengubah teks sumber sedikit saja, sehingga terjemahan lama menjadi yatim. Jalankan `update_translations` dan tinjau yang berubah.
- Lupa memuat terjemahan modul Qt, sehingga tombol "Cancel" tetap Inggris.
- Memakai bahasa sumber yang sama dengan bahasa target.

## 9.4.4 Format tanggal, angka, mata uang, dan pluralisasi

> *Angka yang sama ditulis berbeda di tiap negeri, dan keduanya benar.*

**Konsep.** Bahasa bukan satu-satunya yang berubah. Pemisah desimal, format tanggal, mata uang, dan bentuk jamak ikut berubah. Gunakan objek `Locale`, bukan format yang Anda tulis sendiri. `QLocale` mengonversi angka dan string menurut berbagai bahasa. `Qt.locale()` mengembalikan objek `Locale` dengan informasi lokal, termasuk properti `name`.

```qml
function ringkas(kode) {
    const l = kode ? Qt.locale(kode) : Qt.locale()
    return l.name
         + ' | ' + l.toString(root.waktu, Locale.ShortFormat)
         + ' | ' + root.harga.toLocaleString(l, 'f', 2)
         + ' | ' + l.toCurrencyString(root.harga)
}
```

**Bedah kode**
- `Qt.locale()` mengambil locale sistem, dan `Qt.locale('id_ID')` memilih locale tertentu.
- `l.name` adalah kode locale (`id_ID`, `en_US`).
- `l.toString(tanggal, Locale.ShortFormat)` memformat tanggal/waktu menurut aturan locale.
- `harga.toLocaleString(l, 'f', 2)` memformat angka dengan format tetap (`'f'`) dan dua desimal sesuai pemisah locale.
- `l.toCurrencyString(harga)` memformat mata uang sesuai locale.

Hasil yang diharapkan: `id_ID` memakai titik untuk pemisah ribuan dan koma untuk desimal, sedangkan `en_US` sebaliknya. Lab akan menampilkannya berdampingan.

**Membaca input pengguna.** `Number.fromLocaleString(locale, teks)` mengurai angka sesuai locale. Ini yang dipakai `SpinBox` desimal di 9.1.4. Jangan `parseFloat` pada input yang mungkin memakai koma.

**Pluralisasi.** Gunakan `%n` dan argumen ketiga `qsTr`:

```qml
Label { text: qsTr('%n barang', '', root.jumlah) }
```

`%n` diganti bilangan. Jumlah bentuk jamak bergantung bahasa: bahasa Inggris dua bentuk (`1 item`, `2 items`), bahasa Indonesia umumnya satu, dan bahasa lain bisa lebih banyak. Qt Linguist menampilkan kolom sesuai bahasa target. Bentuk di `.ts`:

```xml
<message numerus="yes">
    <source>%n barang</source>
    <translation>
        <numerusform>%n item</numerusform>
        <numerusform>%n items</numerusform>
    </translation>
</message>
```

Rujukan aturannya ada di halaman *Translation Rules for Plural Forms* di dokumentasi Qt. Karena bahasa sumber juga butuh penanganan jamak, `qt_add_translations` membuat berkas `.ts` khusus jamak untuk bahasa sumber secara otomatis.

**Opsi lain**
- **Mengurutkan teks.** Perbandingan string berbeda tiap bahasa. `QCollator` (C++) membandingkan string menurut algoritma kolasi yang dilokalkan.
- **Kalimat dengan banyak angka dan jenis** (`%1 file dan %2 folder`): pisahkan menjadi dua `qsTr` jamak atau gunakan kalimat netral.
- **Tanggal berformat khusus:** `l.toString(tanggal, 'dd MMMM yyyy')`, tetapi urutan dan nama bulan tetap mengikuti `l`.

**Jebakan**
- `n == 1 ? 'barang' : 'barang-barang'` ditulis tangan.
- Format tanggal ditulis tangan (`dd/MM/yyyy`).
- `parseFloat` pada input berlokal koma.
- Mata uang diberi simbol tetap `'Rp'` di semua locale.

## 9.4.5 High-DPI dan font

> *Layar boleh berganti, ketajaman dan keterbacaan harus tetap.*

**Konsep.** Qt memakai model di mana koordinat aplikasi tidak bergantung pada resolusi perangkat. Aplikasi bekerja dalam piksel independen-perangkat yang dipetakan ke piksel fisik lewat faktor skala, disebut *device pixel ratio*. Jadi 200 unit di layar 2x menjadi 400 piksel fisik. Rasio ini tersedia per jendela (`QWindow::devicePixelRatio()`) atau per layar. Qt 6 secara bawaan sadar-DPI per-monitor di Windows.

**Tiga aturan emas**
1. **Ukuran dalam satuan relatif**, bukan piksel mutlak.
2. **Aset gambar dalam beberapa resolusi** atau vektor.
3. **Ikuti font dan skala sistem** (jangan kunci ukuran font).

**Satuan `em` dari `FontMetrics`**

```qml
ApplicationWindow {
    id: root
    FontMetrics { id: fm; font: root.font }
    readonly property real em: fm.height        // tinggi satu baris teks

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.em
        spacing: 0.6 * root.em
        Button { Layout.preferredHeight: 2.5 * root.em; text: qsTr('Simpan') }
    }
}
```

**Bedah kode**
- `FontMetrics { font: root.font }` mengukur font yang dipakai jendela.
- `fm.height` adalah tinggi baris teks dalam piksel logis.
- `em` dipakai sebagai satuan jarak dan ukuran. Bila pengguna memperbesar font sistem, margin, tinggi tombol, dan jarak ikut membesar. Qt mendukung ini lewat sistem layout dinamis, dan kontrol bawaan memakai font serta ukuran font yang diatur sistem operasi.

**Aset gambar**
- Aset resolusi tinggi memakai konvensi nama khusus, misalnya `logo@2x.png`, dan Qt memilih versi terbaik saat berjalan.
- Gambar vektor (SVG) tak butuh versi `@2x`. Tetapkan `sourceSize` agar dirender pada ukuran logis yang diinginkan.

```qml
Image { source: 'logo.svg'; sourceSize.width: 6 * root.em }
```

**Pengujian dan konfigurasi di Arch**

```bash
QT_SCALE_FACTOR=2 qml6 Main.qml            # simulasi skala 2x
QT_FONT_DPI=144 qml6 Main.qml              # skala logis lewat DPI font (basis 96)
QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough qml6 Main.qml   # lihat skala pecahan apa adanya
xrdb -merge <<< 'Xft.dpi: 144'             # X11: skala global (jalankan sebelum aplikasi)
swaymsg output '*' scale 2                 # Sway/Wayland: contoh; sesuaikan dengan compositor Anda
```

| Variabel/pengaturan | Efek |
| --- | --- |
| `QT_SCALE_FACTOR` | Faktor skala global untuk pengujian. |
| `QT_FONT_DPI` | Mengatur DPI logis, dengan basis 96, dan UI diskalakan sesuainya. |
| `Xft.dpi` (X11) | DPI logis global dari pengaturan/resource X. |
| `QT_USE_PHYSICAL_DPI=1` | Memaksa memakai DPI fisik RandR (X11), dibulatkan ke bilangan bulat. |
| Wayland | Qt membaca `wl_output::scale`, yang bilangan bulat. Skala diatur di compositor. |

Skala bilangan bulat memberi hasil terbaik, dan skala pecahan bisa menimbulkan artefak. Bila terjadi, `QGuiApplication::setHighDpiScaleFactorRoundingPolicy()` membatasi skala yang terlihat aplikasi.

**Catatan.** Qt tidak menyediakan fasilitas pengguna akhir untuk mengatur perilaku high-DPI. Pengaturan dilakukan lewat pengaturan layar platform agar semua aplikasi sepakat. Karena itu, jangan menaruh pengatur skala di aplikasi Anda.

**Informasi layar di QML**

```qml
Label {
    text: qsTr('DPR %1 | layar %2x%3 | 1 em = %4 px')
          .arg(Screen.devicePixelRatio).arg(Screen.width).arg(Screen.height).arg(root.em.toFixed(1))
}
```

`Screen` adalah objek terlampir yang menyajikan data layar tempat item berada.

**Target klik.** Model piksel independen-perangkat tidak menangani perbedaan antara target sentuh dan target mouse. Pastikan kontrol cukup besar untuk jari bila aplikasi dipakai di layar sentuh.

**Jebakan**
- Margin dan font dalam piksel mutlak (`font.pixelSize: 14`, `margins: 20`).
- Hanya menguji di skala 1x.
- Gambar bitmap tanpa versi `@2x` sehingga tampak buram.
- Mengunci ukuran jendela dan tombol dalam piksel sehingga teks terpotong saat font diperbesar.

## 9.4.6 Uji dengan Orca dan `accerciser`

> *Mendengar aplikasi Anda sendiri adalah cara tercepat menemukan lubangnya.*

**Konsep.** Qt di Linux mengekspos struktur UI lewat AT-SPI (D-Bus). Pembaca layar Orca membacanya. Syaratnya: properti D-Bus `IsEnabled` dan `ScreenReaderEnabled` bernilai true, atau variabel `QT_LINUX_ACCESSIBILITY_ALWAYS_ON` diatur. Menyalakan Orca biasanya sudah memenuhinya.

```bash
sudo pacman -S --needed at-spi2-core orca accerciser   # periksa nama paket: pacman -Ss orca
orca &                                  # nyalakan pembaca layar lebih dulu
qml6 Main.qml &                         # jalankan aplikasi SETELAH Orca aktif
orca -l                                 # daftar aplikasi aksesibel yang terlihat Orca
accerciser                              # inspeksi pohon aksesibilitas (role, name, state, action)

# Alternatif tanpa Orca (HANYA untuk uji; ada biaya performa):
QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1 qml6 Main.qml
busctl --user list | rg a11y            # periksa layanan bus aksesibilitas aktif
```

**Catatan.** Variabel lama `QT_ACCESSIBILITY=1` berasal dari era Qt 4/5 awal. Jangan memakainya untuk Qt 6.

**Prosedur uji**
1. Dengarkan tiap kontrol saat fokus. Nama dan perannya masuk akal? Ikon tanpa nama terdengar sebagai "tombol" saja.
2. Tab melalui seluruh jendela. Urutan baca logis? Tidak ada kontrol terlewat?
3. Aktifkan kontrol kustom lewat Orca. `onPressAction` bekerja?
4. Ubah status (centang, geser). Perubahan dibacakan?
5. Buka dialog. Fokus berpindah ke dialog, dan kembali saat ditutup?
6. Bandingkan dengan pohon di `accerciser`. Elemen dekoratif seharusnya `ignored`.

**Opsi lain**
- **`accerciser`** menampilkan pohon aksesibilitas tanpa suara.
- **Sesi X11 vs Wayland.** Dukungan fitur Orca (terutama tombol global) dapat berbeda antar-compositor. Jika ragu, uji dengan `QT_QPA_PLATFORM=xcb`.
- **Pengujian UI otomatis** memanfaatkan `Accessible.id`.

**Jebakan**
- Menjalankan aplikasi sebelum Orca lalu mengira Qt tak aksesibel.
- Menyalakan `QT_LINUX_ACCESSIBILITY_ALWAYS_ON` di produksi.
- Mengandalkan hanya inspeksi visual tanpa pernah mendengar hasilnya.

## 9.4.7 RTL dan *mirroring* `[TAMBAHAN]`

> *Bahasa yang ditulis dari kanan ke kiri juga berhak atas antarmuka yang wajar.*

**Konsep.** Bahasa Arab dan Ibrani ditulis dari kanan ke kiri, kecuali angka dan teks Inggris di dalamnya yang tetap kiri-ke-kanan. Layout ikut dicerminkan: tombol "kembali" pindah ke kanan, dan urutan kolom terbalik.

```qml
ColumnLayout {                      // akar antarmuka
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    // ... RowLayout, Button, dsb. ikut tercermin
}
```

**Bedah kode**
- `Qt.application.layoutDirection` adalah arah tata letak aplikasi (`Qt.LeftToRight` atau `Qt.RightToLeft`).
- `LayoutMirroring.enabled` mencerminkan layout item ini, dan `childrenInherit: true` menurunkannya ke anak-anaknya.
- Kontrol memiliki properti `mirrored` (9.1.0) yang mengikuti pencerminan.

**Tips**
- Ikon berarah (panah) perlu versi cermin, sedangkan ikon netral tidak.
- Teks tetap diatur penampil teks Qt sesuai kaidah bidirectional (UAX #9).
- Uji dengan `LayoutMirroring.enabled: true` dipaksa dan bahasa Arab di `qsTr`.

## 9.4.8 Kontras, warna, dan preferensi sistem `[TAMBAHAN]`

> *Warna yang indah belum tentu terbaca. Yang terbaca pasti indah.*

**Konsep.** Aksesibilitas visual bukan hanya "ukuran besar". Beri kontras yang cukup, perhatikan buta warna, dukung skema warna berbeda atau hormati warna dan tema dari sistem, dan jangan bergantung pada warna saja untuk menyampaikan informasi.

**Ambang WCAG 2.x (Level AA)**

| Jenis | Rasio minimum |
| --- | --- |
| Teks biasa | 4,5 : 1 |
| Teks besar (18 pt, atau 14 pt tebal) | 3 : 1 |
| Komponen UI dan grafik (ikon, garis tepi kolom, penunjuk fokus) | 3 : 1 |

Nilai tidak boleh dibulatkan. 4,499:1 tidak memenuhi 4,5:1. Contohnya, abu-abu `#777777` pada putih (4,47:1) gagal.

**Fungsi penghitung kontras (rumus luminansi relatif WCAG)**

```qml
function lin(v) { return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4) }
function lum(w) { const c = Qt.color(w); return 0.2126 * lin(c.r) + 0.7152 * lin(c.g) + 0.0722 * lin(c.b) }
function rasio(a, b) {
    const x = lum(a), y = lum(b)
    return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05)
}
```

**Bedah kode**
- `Qt.color(w)` menormalkan nama warna (`'white'`) atau kode hex menjadi objek warna dengan komponen `r`, `g`, `b` bernilai 0 sampai 1.
- `lin(v)` mengubah nilai sRGB menjadi linear. Ini koreksi gamma.
- `lum(w)` menghitung luminansi relatif dengan bobot mata manusia (hijau paling berpengaruh).
- `rasio(a, b)` adalah (terang + 0,05) / (gelap + 0,05).

**Koreksi untuk contoh saya di Modul 9.2.** Tombol biru memakai warna dasar `#2563eb` dan hover `#3b82f6` dengan teks putih. Perkiraan hitung manual saya: dasar sekitar 5,2:1 (lolos) tetapi hover sekitar 3,7:1 (gagal 4,5:1). Hover yang lebih terang justru mengurangi kontras teks putih. Jalankan fungsi di atas untuk memastikan. Perbaikannya, buat hover lebih *gelap* (mis. `Qt.darker('#2563eb', 1.15)`), bukan lebih terang.

**Jangan hanya warna.** Status "galat" jangan hanya merah. Tambahkan ikon, teks, atau pola. Link jangan hanya dibedakan lewat warna.

**Ikuti tema sistem.** Kontrol Qt secara bawaan memakai palet warna sistem. Jangan menimpa seluruh palet tanpa alasan (9.2.4). Pada Qt ≥ 6.5 skema terang/gelap sistem bisa dibaca lewat `Application.styleHints.colorScheme`.

**Bunyi dan suara.** Jangan hanya mengandalkan notifikasi bunyi. Qt Multimedia dan Qt TextToSpeech tersedia sebagai tambahan.

## 9.4.9 Lab terpadu `[TAMBAHAN]`

Lab ini memenuhi latihan kurikulum (bungkus teks dengan `qsTr`, buat `.ts`, terjemahkan satu string), dengan koreksi bahasa sumber dari audit. Buat tiga berkas: `CMakeLists.txt`, `main.cpp`, `Main.qml`.

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.21)
project(lab94 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick LinguistTools)
qt_standard_project_setup(
    I18N_SOURCE_LANGUAGE id
    I18N_TRANSLATED_LANGUAGES en
)

qt_add_executable(lab94 main.cpp)
qt_add_qml_module(lab94
    URI Lab94
    VERSION 1.0
    QML_FILES Main.qml
)
qt_add_translations(lab94)
target_link_libraries(lab94 PRIVATE Qt6::Quick)
```

```cpp
// main.cpp
#include <QGuiApplication>
#include <QLibraryInfo>
#include <QLocale>
#include <QQmlApplicationEngine>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QTranslator appTr;                                   // terjemahan aplikasi (:/i18n)
    for (const QString &bahasa : QLocale::system().uiLanguages()) {
        if (appTr.load(":/i18n/lab94_" + QLocale(bahasa).name())) {
            app.installTranslator(&appTr);
            break;
        }
    }

    QTranslator qtTr;                                    // terjemahan modul Qt (qtbase)
    if (qtTr.load(QLocale::system(), QStringLiteral("qtbase"), QStringLiteral("_"),
                  QLibraryInfo::path(QLibraryInfo::TranslationsPath)))
        app.installTranslator(&qtTr);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, [] { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("Lab94", "Main");
    return app.exec();
}
```

```qml
// Main.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true; width: 600; height: 560
    title: qsTr('Lab 9.4')

    FontMetrics { id: fm; font: root.font }
    readonly property real em: fm.height

    property int jumlah: 3
    property real harga: 1234567.891
    property date waktu: new Date()
    property string nama: 'Rani'

    // --- kontras WCAG ---
    function lin(v) { return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4) }
    function lum(w) { const c = Qt.color(w); return 0.2126 * lin(c.r) + 0.7152 * lin(c.g) + 0.0722 * lin(c.b) }
    function rasio(a, b) { const x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05) }

    // --- format per locale ---
    function ringkas(kode) {
        const l = kode ? Qt.locale(kode) : Qt.locale()
        return l.name + ' | ' + l.toString(root.waktu, Locale.ShortFormat)
             + ' | ' + root.harga.toLocaleString(l, 'f', 2)
             + ' | ' + l.toCurrencyString(root.harga)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.em
        spacing: 0.6 * root.em

        Label {
            text: qsTr('Halo, %1! Anda punya %2 pesan.').arg(root.nama).arg(root.jumlah)
            font.bold: true
        }

        RowLayout {
            spacing: 0.6 * root.em
            Label { text: qsTr('%n barang', '', root.jumlah) }
            SpinBox {
                from: 0; to: 10; value: root.jumlah
                onValueModified: root.jumlah = value
                Accessible.name: qsTr('Jumlah barang')
            }
            ToolButton {
                icon.name: 'list-add'
                Accessible.name: qsTr('Tambah barang')
                Accessible.description: qsTr('Menambah jumlah barang satu')
                onClicked: root.jumlah++
            }
            Rectangle {
                id: kustom
                activeFocusOnTab: true
                implicitWidth: 8 * root.em; implicitHeight: 2.5 * root.em
                radius: 0.4 * root.em
                color: activeFocus ? '#1d4ed8' : '#2563eb'
                border.width: activeFocus ? 0.2 * root.em : 0
                border.color: '#f59e0b'
                function aksi() { root.jumlah = 0 }

                Label { anchors.centerIn: parent; text: qsTr('Reset'); color: 'white' }
                TapHandler { onTapped: kustom.aksi() }
                Keys.onSpacePressed: aksi()
                Keys.onReturnPressed: aksi()

                Accessible.role: Accessible.Button
                Accessible.name: qsTr('Reset jumlah')
                Accessible.focusable: true
                Accessible.onPressAction: aksi()
            }
        }

        Label { text: qsTr('Locale | tanggal | angka | mata uang'); font.bold: true }
        Repeater {
            model: ['', 'id_ID', 'en_US', 'de_DE']
            Label { required property string modelData; text: root.ringkas(modelData) }
        }

        Label { text: qsTr('Kontras putih / #2563eb = %1 : 1').arg(root.rasio('white', '#2563eb').toFixed(2)) }
        Label { text: qsTr('Kontras putih / #3b82f6 = %1 : 1').arg(root.rasio('white', '#3b82f6').toFixed(2)) }

        Label {
            text: qsTr('DPR %1 | layar %2x%3 | 1 em = %4 px')
                  .arg(Screen.devicePixelRatio).arg(Screen.width).arg(Screen.height).arg(root.em.toFixed(1))
        }

        Item { Layout.fillHeight: true }
    }
}
```

**Menjalankan**

```bash
qml6 Main.qml                                          # uji cepat tanpa terjemahan (qsTr = sumber)

cmake -S . -B build
cmake --build build --target update_translations       # buat lab94_en.ts dan lab94_id.ts (jamak)
linguist6 lab94_en.ts                                  # terjemahkan ke Inggris
cmake --build build
./build/lab94                                          # sumber Indonesia
LANGUAGE=en ./build/lab94                              # Inggris

QT_SCALE_FACTOR=2 ./build/lab94                        # uji skala
QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1 ./build/lab94       # uji aksesibilitas (lalu Orca/accerciser)
```

**Isi terjemahan yang disarankan (konteks `Main`)**

| Sumber (id) | Terjemahan (en) |
| --- | --- |
| `Halo, %1! Anda punya %2 pesan.` | `Hello, %1! You have %2 messages.` |
| `%n barang` | `%n item` / `%n items` (dua bentuk) |
| `Jumlah barang` | `Item count` |
| `Tambah barang` | `Add item` |
| `Reset jumlah` | `Reset count` |

**Cek hasilnya**
1. **i18n:** bahasa Inggris tampil dan bentuk jamak benar untuk 1 dan 3.
2. **l10n:** baris `id_ID`, `en_US`, `de_DE` menunjukkan pemisah desimal berbeda.
3. **a11y:** semua kontrol terjangkau dengan Tab, termasuk `Rectangle` kustom. Orca membacakan nama yang benar.
4. **DPI:** `QT_SCALE_FACTOR=2` memperbesar seluruh UI tanpa teks terpotong.
5. **Kontras:** baris kedua memperlihatkan rasio hover biru di bawah 4,5.

**Latihan tambahan**
1. Ganti bahasa sumber menjadi `en` dan target `id`, lalu bandingkan berkas `.ts` yang dihasilkan.
2. Perbaiki warna hover agar kontras ≥ 4,5:1 menggunakan fungsi `rasio`.
3. Tambahkan `Accessible.labelledBy` pada sebuah `TextField` dan periksa di `accerciser` (butuh Qt ≥ 6.10).
4. Aktifkan `LayoutMirroring` dan perhatikan urutan `RowLayout`.

## Terminologi esensial

| Istilah | Penjelasan |
| --- | --- |
| **Aksesibilitas (a11y)** | Membuat aplikasi dapat dipakai orang dengan beragam kemampuan |
| **AT-SPI** | Antarmuka aksesibilitas Linux lewat D-Bus yang dibaca pembaca layar |
| **Pembaca layar (Orca)** | Alat bantu yang membacakan UI dan memicu aksinya |
| **`Accessible`** | Atribut terlampir QML untuk metadata aksesibilitas |
| **Peran (`role`)** | Jenis semantik elemen (Button, CheckBox, Chart, StaticText) |
| **`ignored`** | Menyembunyikan item dari alat bantu |
| **i18n / l10n** | Internasionalisasi (menyiapkan) / lokalisasi (menyesuaikan wilayah) |
| **`qsTr` / `qsTrId`** | Penanda teks terjemahan berbasis kalimat / berbasis ID |
| **`.ts` / `.qm`** | Berkas sumber terjemahan (XML) / hasil kompilasi biner |
| **`lupdate` / `lrelease` / Linguist** | Ekstrak string / kompilasi / aplikasi penerjemah |
| **`%1` / `%n`** | Penanda posisi nilai / penanda bilangan jamak |
| **Locale** | Aturan bahasa dan wilayah (format tanggal, angka, mata uang) |
| **DPR** | *Device pixel ratio*: rasio piksel fisik terhadap piksel logis |
| **`em`** | Satuan relatif terhadap tinggi font |
| **RTL / mirroring** | Tulisan kanan-ke-kiri / pencerminan layout |
| **Kontras WCAG** | Rasio luminansi teks terhadap latar |

## Hubungan dengan modul lain

- **Prasyarat:** 9.1 (fokus, kontrol, `Action`), 9.2 (`palette`, kontras tema), 9.3 (fokus saat navigasi, popup yang bisa ditutup), 8.3 (CMake dan resource), 5.2 (layout dinamis).
- **Menyambung ke:** jalur C++ (Modul 10.x) untuk `QTranslator`, `QQmlEngine::retranslate()`, dan `QLocale`; pengujian dan CI (`qmllint`, uji UI dengan `Accessible.id`); Fase berikutnya dalam kurikulum.

## Tips dan praktik terbaik

1. **Tulis `qsTr` dengan kalimat utuh,** tanpa menggabung potongan.
2. **Pilih satu bahasa sumber** dan jangan menamai target sama dengan sumber.
3. **Biarkan `Locale` yang memformat** tanggal, angka, dan mata uang.
4. **Ukuran dalam `em`,** gambar dalam vektor atau `@2x`.
5. **Beri nama aksesibel pada semua ikon,** dan nama harus memuat label yang terlihat.
6. **Tes tanpa mouse dan dengan Orca** setiap rilis. Jadikan bagian dari daftar periksa.
7. **Jaga kontras ≥ 4,5:1 untuk teks** dan ≥ 3:1 untuk komponen UI. Hitung, jangan menebak.
8. **Jangan hanya warna** untuk status.
9. **Audit berkas `.ts` dari pihak luar** sebelum dikompilasi.
10. **Gunakan `QT_LINUX_ACCESSIBILITY_ALWAYS_ON` hanya saat uji.**

## Kesalahan umum dan solusi

| Kesalahan | Akibat | Solusi |
| --- | --- | --- |
| Teks tanpa `qsTr` | Tak bisa diterjemahkan | Bungkus semua teks tampil |
| String digabung manual | Urutan kata salah di bahasa lain | `qsTr('... %1 ...').arg(...)` |
| Bahasa sumber = bahasa target | Terjemahan tak berarti | Pilih sumber dan target berbeda |
| Jamak ditulis `n == 1 ? ...` | Salah untuk bahasa lain | `%n` + `qsTr(…, '', n)` |
| Format tanggal/angka ditulis tangan | Salah di locale lain | `Locale` |
| Ikon tanpa `Accessible.name` | Pembaca layar hanya bilang "tombol" | Beri `Accessible.name` |
| Kontrol kustom tanpa `role`/`focusable` | Tak terdeteksi | Nyatakan peran, nama, fokus, aksi |
| `name` berisi jenis kontrol | Terbaca ganda | Hanya nama |
| Cincin fokus dihapus | Pengguna keyboard tersesat | Gambar fokus di `background` |
| Ukuran dalam piksel mutlak | UI terpotong di DPI/font berbeda | `em`, layout, `implicit*` |
| Gambar tanpa `@2x` | Buram di layar high-DPI | Tambah `@2x` atau SVG |
| Hanya warna untuk status | Tak terbaca penderita buta warna | Tambah ikon atau teks |
| Orca dijalankan setelah aplikasi | Aplikasi tak terdeteksi | Nyalakan Orca dulu, atau pakai variabel uji |
| Lupa terjemahan modul Qt | Tombol dialog tetap Inggris | Muat `qtbase`/`qtdeclarative` |
| Teks dari C++ tak ikut `retranslate` | Bahasa tak berganti penuh | Sediakan properti ber-notify, uji versi Qt |

## Cek pemahaman: jawaban

**Mengapa navigasi keyboard penuh termasuk aksesibilitas?**
- Banyak pengguna tidak dapat atau tidak mau memakai pointer: tunanetra yang memakai pembaca layar, pengguna dengan keterbatasan motorik, dan pengguna dengan alat bantu masukan khusus. Semuanya berinteraksi lewat keyboard atau perangkat yang meniru keyboard.
- Alat bantu seperti pembaca layar bekerja berdasarkan fokus dan aksi: pindah fokus, baca nama, picu aksi. Tanpa kontrol yang dapat difokuskan dan diaktifkan dari keyboard, alat bantu tak punya cara memandu pengguna. Karena itu, kontrol harus `focusable`, punya urutan logis, dan fokus terlihat.
- Antarmuka yang penuh kendali keyboard, seperti yang Anda sukai, otomatis menjadi dasar aksesibilitas. Selebihnya tinggal melengkapi metadata (`name`, `role`, `description`).

## Referensi

*Halaman Accessibility, Accessibility for Qt Quick, Internationalization, Localizing, qt_add_translations, High DPI, QAccessible, dan tipe Accessible/Qt saya baca dari dokumentasi Qt 6. Tautan lain mengikuti pola URL resmi.*

- Aksesibilitas: [Accessibility](https://doc.qt.io/qt-6/accessible.html) · [Accessibility for Qt Quick Applications](https://doc.qt.io/qt-6/accessible-qtquick.html) · [Accessible (QML)](https://doc.qt.io/qt-6/qml-qtquick-accessible.html) · [QAccessible](https://doc.qt.io/qt-6/qaccessible.html)
- Internasionalisasi: [Internationalization with Qt](https://doc.qt.io/qt-6/internationalization.html) · [Localizing Applications](https://doc.qt.io/qt-6/localization.html) · [Internationalization and Localization with Qt Quick](https://doc.qt.io/qt-6/qtquick-internationalization.html) · [Writing Source Code for Translation](https://doc.qt.io/qt-6/i18n-source-translation.html) · [Plural Rules](https://doc.qt.io/qt-6/i18n-plural-rules.html) · [ID-based i18n](https://doc.qt.io/qt-6/linguist-id-based-i18n.html)
- Alat: [Qt Linguist Manual](https://doc.qt.io/qt-6/qtlinguist-index.html) · [qt_add_translations](https://doc.qt.io/qt-6/qtlinguist-cmake-qt-add-translations.html) · [Qt (QML): qsTr, uiLanguage, locale](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Locale (QML)](https://doc.qt.io/qt-6/qml-qtqml-locale.html) · [QLocale](https://doc.qt.io/qt-6/qlocale.html)
- DPI: [High DPI](https://doc.qt.io/qt-6/highdpi.html) · [FontMetrics](https://doc.qt.io/qt-6/qml-qtquick-fontmetrics.html) · [LayoutMirroring](https://doc.qt.io/qt-6/qml-qtquick-layoutmirroring.html)
- Kontras: [WCAG 2.2 SC 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) · [WebAIM: Contrast and Color](https://webaim.org/articles/contrast/)
- Linux: [Orca (ArchWiki: Accessibility)](https://wiki.archlinux.org/title/Accessibility) · [Qt di ArchWiki](https://wiki.archlinux.org/title/Qt)

---

**Modul 9.4 selesai, dan dengan itu seluruh Fase 9 (Modul 9.1–9.4) tuntas.** Mau memperdalam salah satu modul Fase 9, atau kirim bagian kurikulum berikutnya (Fase 10) untuk dikerjakan?
- [StackView](https://doc.qt.io/qt-6/qml-qtquick-controls-stackview.html) · [SwipeView](https://doc.qt.io/qt-6/qml-qtquick-controls-swipeview.html) · [TabBar](https://doc.qt.io/qt-6/qml-qtquick-controls-tabbar.html) · [PageIndicator](https://doc.qt.io/qt-6/qml-qtquick-controls-pageindicator.html) · [Drawer](https://doc.qt.io/qt-6/qml-qtquick-controls-drawer.html)
- [Popup](https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html) · [Dialog](https://doc.qt.io/qt-6/qml-qtquick-controls-dialog.html) · [DialogButtonBox](https://doc.qt.io/qt-6/qml-qtquick-controls-dialogbuttonbox.html) · [Menu](https://doc.qt.io/qt-6/qml-qtquick-controls-menu.html) · [ContextMenu](https://doc.qt.io/qt-6/qml-qtquick-controls-contextmenu.html) · [Overlay](https://doc.qt.io/qt-6/qml-qtquick-controls-overlay.html)
- Ikhtisar: [Popup Controls](https://doc.qt.io/qt-6/qtquickcontrols-popups.html) · [Navigation Controls](https://doc.qt.io/qt-6/qtquickcontrols-navigation.html) · [Container Controls](https://doc.qt.io/qt-6/qtquickcontrols-containers.html) · [Focus Management](https://doc.qt.io/qt-6/qtquickcontrols-focus.html)
- Dialog sistem: [Qt Quick Dialogs](https://doc.qt.io/qt-6/qtquick-dialogs-qmlmodule.html) · [FileDialog](https://doc.qt.io/qt-6/qml-qtquick-dialogs-filedialog.html) · [Dialogs in Qt Quick (blog)](https://www.qt.io/blog/dialogs-in-qt-quick)
- Pendukung: [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html) · [Keys](https://doc.qt.io/qt-6/qml-qtquick-keys.html) · [StackLayout](https://doc.qt.io/qt-6/qml-qtquick-layouts-stacklayout.html) · [Keyboard Focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html)

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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

