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

