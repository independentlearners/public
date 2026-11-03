## Kurikulum Komprehensif: Quickshell, QML, dan Ekosistem Wayland untuk Shell Desktop Minimalis-Keyboard-Driven

Kurikulum ini dirancang khusus untuk **power user Arch Linux** yang beroperasi di lingkungan **CLI/TUI**, mengutamakan **kontrol keyboard penuh**, **keamanan**, **isolasi**, dan **anonimitas**, serta memiliki prinsip **monolitik, modular, abstrak, dan super kontrol**. Quickshell bukan sekadar “bar” atau “panel”—ia adalah **toolkit low-level berbasis QtQuick/QML** untuk membangun seluruh komponen desktop (bar, widget, lockscreen, notification daemon, display manager) yang berjalan **di atas Wayland compositor** seperti Hyprland atau Sway. Anda akan memprogram shell Anda sendiri, bukan sekadar mengonfigurasi tema.

> **Filosofi Inti Kurikulum:** Shell adalah **program**, bukan konfigurasi. Setiap piksel, setiap binding, dan setiap interaksi harus dapat dikontrol melalui kode dan keyboard. Keamanan dicapai melalui **isolasi proses**, **least privilege**, dan **auditabilitas kode**—bukan melalui GUI yang tidak transparan.

---

## Prasyarat

Sebelum memulai, Anda harus memiliki:

- **Arch Linux** terpasang dan berjalan (disarankan dengan `base-devel`).
- **Wayland compositor** yang mendukung `wlr-layer-shell` (Hyprland, Sway, atau Niri).
- **Pemahaman dasar terminal**: navigasi filesystem, editing file dengan `vim`/`neovim`, manajemen paket `pacman`, dan `git`.
- **Pemahaman dasar pemrograman**: variabel, fungsi, objek, dan event. (Tidak harus C++ atau QML; kurikulum akan mengajarkannya dari nol.)
- **Komitmen terhadap prinsip keamanan**: tidak menjalankan skrip dari sumber tidak tepercaya tanpa audit, dan memahami konsep sandboxing serta isolasi proses.

---

## Alat Esensial

| Kategori | Alat | Catatan |
|---|---|---|
| **Editor/IDE** | Neovim atau Helix dengan **QML LSP** (`qmlls`) | Quickshell menyediakan konfigurasi LSP untuk Neovim, Emacs, Helix, dan VS Code. |
| **Terminal Multiplexer** | `tmux` atau `zellij` | Menjalankan Quickshell, log, dan editor dalam satu sesi keyboard-driven. |
| **Build Tools** | `cmake`, `ninja`, `gcc` | Diperlukan jika membangun Quickshell dari source atau mengembangkan plugin C++. |
| **Qt6** | `qt6-base`, `qt6-declarative`, `qt6-wayland`, `qt6-svg` | Dependensi inti Quickshell. |
| **Compositor** | Hyprland atau Sway | Quickshell menyediakan integrasi workspace dan IPC khusus untuk keduanya. |
| **Audit/Security** | `strace`, `bubblewrap`, `firejail` | Untuk analisis syscall dan isolasi proses shell. |
| **Debugging** | `gdb`, `qtcreator` (hanya untuk debugging, bukan GUI utama) | Quickshell memiliki crash handler dan dukungan debugging. |

---

## Struktur Fase dan Estimasi Waktu

| Fase | Level | Estimasi Waktu | Fokus |
|---|---|---|---|
| **0** | Pemula | 4–6 minggu | Fondasi Linux, Wayland, QML, dan Qt6 |
| **1** | Pemula–Menengah | 4 minggu | Dasar Quickshell: `shell.qml`, `PanelWindow`, `Process`, `Timer` |
| **2** | Menengah | 6–8 minggu | Integrasi sistem: Wayland layer-shell, IPC compositor, PipeWire, MPRIS, BlueZ, UPower |
| **3** | Mahir | 6 minggu | Arsitektur modular, komponen reusable, singletons, manajemen state |
| **4** | Mahir–Expert | 4–6 minggu | Keamanan, isolasi, sandboxing, PAM, lockscreen, greetd |
| **5** | Expert/Enterprise | 8+ minggu | Optimasi performa, plugin C++, deployment, CI/CD, kontribusi upstream |

**Total estimasi:** 32–38 minggu (sekitar 8–9 bulan) untuk mencapai tingkat expert dengan studi konsisten ~10–15 jam/minggu.

---

## [Fase 0 — Fondasi: Linux, Wayland, QML, dan Qt6][0]

**Level:** Pemula  
**Estimasi:** 4–6 minggu  
**Prasyarat:** Arch Linux terpasang, terminal dasar.

### Modul 0.1 — Arch Linux dan Filosofi CLI/TUI

**Deskripsi Konkret:**  
Membangun lingkungan kerja yang sepenuhnya dapat dikontrol melalui keyboard: shell (`zsh`/`fish`), terminal multiplexer, dan manajemen paket. Anda akan memahami mengapa Arch Linux—dengan filosofi KISS dan kontrol penuh—cocok untuk pengembangan shell Wayland.

**Konsep Dasar dan Filosofi:**  
Arch Linux memberikan kontrol granular atas setiap paket. Berbeda dengan distro yang menyembunyikan detail, Arch memaksa Anda memahami dependensi. Ini selaras dengan prinsip **super kontrol**: Anda harus tahu apa yang berjalan di sistem Anda, termasuk setiap dependensi Quickshell.

**Sintaks Dasar/Contoh Implementasi Inti:**
```bash
# Instalasi dependensi dasar Qt6 dan Wayland
sudo pacman -S --needed base-devel qt6-base qt6-declarative qt6-wayland qt6-svg cmake ninja git

# Verifikasi Wayland berjalan
echo $XDG_SESSION_TYPE   # harus "wayland"
```

**Terminologi Kunci:**
- **Wayland**: Protokol display server modern yang menggantikan X11; compositor bertanggung jawab penuh atas rendering dan input.
- **Compositor**: Program yang mengelola jendela, input, dan rendering (Hyprland, Sway).
- **XDG Base Directory**: Standar lokasi konfigurasi (`~/.config`), data (`~/.local/share`), dan cache (`~/.cache`).

**Daftar Isi:**
1. Instalasi Arch dan `base-devel`.
2. Manajemen paket dengan `pacman` dan AUR helper (`yay`/`paru`).
3. Shell scripting untuk otomatisasi (`bash`/`zsh`).
4. Terminal multiplexer (`tmux`): sesi, pane, dan keybinding.
5. Wayland vs X11: arsitektur dan implikasi keamanan.

**Sumber Referensi:**
- Arch Wiki: [Installation guide](https://wiki.archlinux.org/title/Installation_guide)
- Arch Wiki: [Wayland](https://wiki.archlinux.org/title/Wayland)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)

**Visualisasi:** Diagram alur arsitektur Wayland (client → compositor → kernel → hardware) direkomendasikan.

---

### Modul 0.2 — QML: Bahasa Deklaratif untuk Antarmuka

**Deskripsi Konkret:**  
Mempelajari sintaks QML dari nol: properti, binding, signal, komponen, dan layout. QML adalah bahasa deklaratif berbasis JavaScript yang digunakan Quickshell untuk mendeskripsikan UI dan perilaku shell.

**Konsep Dasar dan Filosofi:**  
QML memisahkan **deklarasi** (apa yang tampak) dari **logika imperatif** (JavaScript). **Property binding** adalah inti reaktivitas: ketika nilai sumber berubah, nilai turunan diperbarui secara otomatis. Ini memungkinkan shell yang sepenuhnya reaktif terhadap state sistem (baterai, volume, workspace) tanpa polling manual.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
import QtQuick

Rectangle {
    width: 200; height: 100
    color: "black"

    Text {
        anchors.centerIn: parent
        text: "Hello, Quickshell"
        color: "white"
    }
}
```
```qml
// Property binding dan signal handler
Text {
    property int counter: 0
    text: "Count: " + counter

    MouseArea {
        anchors.fill: parent
        onClicked: parent.counter += 1
    }
}
```

**Terminologi Kunci:**
- **QML (Qt Modeling Language):** Bahasa deklaratif untuk membangun UI; setiap elemen adalah objek dengan properti.
- **Property Binding:** Ekspresi yang secara otomatis diperbarui saat dependensinya berubah (misalnya `text: "Count: " + counter`).
- **Signal:** Notifikasi bahwa sesuatu terjadi (misalnya `clicked`); **signal handler** adalah blok kode yang merespons (`onClicked: { ... }`).
- **Komponen:** Tipe QML yang dapat digunakan ulang, didefinisikan dalam file `.qml` terpisah.

**Daftar Isi:**
1. Sintaks dasar QML dan struktur file `.qml`.
2. Properti, tipe data, dan binding.
3. Signal dan signal handler.
4. Positioner dan Layout (`Row`, `Column`, `Grid`, `AnchorLayout`).
5. Model-View-Delegate (dasar).
6. Komponen inline dan file komponen terpisah.

**Sumber Referensi:**
- [QML Language Reference (Quickshell)](https://quickshell.org/docs/v0.3.1/guide/qml-language)
- [Qt QML Documentation](https://doc.qt.io/qt-6/qmlapplications.html)
- [Qt Academy: QML for Beginners (gratis)](https://www.qt.io/academy/course-catalog#qml-for-beginners)

**Visualisasi:** Diagram pohon objek QML (parent-child relationship) sangat direkomendasikan.

---

### Modul 0.3 — Qt6 dan QtQuick: Fondasi di Balik Quickshell

**Deskripsi Konkret:**  
Memahami peran Qt6 sebagai framework C++ di balik Quickshell, serta QtQuick sebagai modul rendering. Anda akan mempelajari cara Quickshell menggunakan QtQuick untuk membuat window, efek, dan animasi.

**Konsep Dasar dan Filosofi:**  
Quickshell dibangun di atas **Qt6/QtQuick**. QtQuick menggunakan scene graph yang dipercepat GPU untuk rendering. Memahami QtQuick membantu Anda mengoptimalkan performa shell dan memahami batasan (misalnya, kapan menggunakan `MultiEffect` vs `qt5compat` untuk blur).

**Sintaks Dasar/Contoh Implementasi Inti:**
```bash
# Instalasi modul Qt6 tambahan untuk Quickshell
sudo pacman -S qt6-svg qt6-imageformats qt6-multimedia qt6-5compat
```
```qml
// Contoh penggunaan MultiEffect (QtQuick Effects)
import QtQuick
import QtQuick.Effects

Rectangle {
    width: 100; height: 100; color: "blue"
    MultiEffect {
        source: parent
        anchors.fill: parent
        blurEnabled: true
        blur: 1.0
    }
}
```

**Terminologi Kunci:**
- **QtQuick:** Modul Qt untuk membangun UI dinamis dengan QML; menggunakan scene graph.
- **Scene Graph:** Struktur data yang dioptimalkan untuk rendering GPU.
- **MultiEffect:** Efek visual modern di Qt6 (blur, shadow, mask) yang lebih efisien daripada `qt5compat`.

**Daftar Isi:**
1. Arsitektur Qt6 dan modul-modulnya.
2. QtQuick vs QtWidgets (dan mengapa Quickshell memilih QtQuick).
3. Modul Qt6 yang relevan untuk Quickshell (`qt6-svg`, `qt6-wayland`, `qt6-multimedia`).
4. Efek visual: `MultiEffect` dan `qt5compat`.
5. Sistem resource Qt dan cara Quickshell memuat file QML.

**Sumber Referensi:**
- [Qt6 Documentation](https://doc.qt.io/qt-6/)
- [Qt Quick Effects](https://doc.qt.io/qt-6/qml-qtquick-effects-multieffect.html)
- [Quickshell Installation & Setup (paket tambahan)](https://quickshell.org/docs/v0.3.1/guide/install-setup/)

---

## [Fase 1 — Dasar Quickshell: Shell Pertama Anda][2]

**Level:** Pemula–Menengah  
**Estimasi:** 4 minggu  
**Prasyarat:** Fase 0 selesai.

### Modul 1.1 — Instalasi dan Struktur Konfigurasi

**Deskripsi Konkret:**  
Menginstal Quickshell di Arch Linux (stable atau `-git`), memahami struktur direktori konfigurasi (`~/.config/quickshell/`), dan menjalankan shell pertama.

**Konsep Dasar dan Filosofi:**  
Quickshell mencari konfigurasi di subfolder `quickshell` dari setiap XDG config path. Setiap subfolder yang berisi `shell.qml` dianggap sebagai konfigurasi terpisah. Ini mendukung **isolasi konfigurasi** dan **modularitas**: Anda dapat memiliki beberapa shell (misalnya, satu untuk bar, satu untuk lockscreen) yang berjalan secara independen.

**Sintaks Dasar/Contoh Implementasi Inti:**
```bash
# Instalasi stable dari repositori Arch
sudo pacman -S quickshell

# Atau versi development (peringatan: bisa rusak saat Qt update)
yay -S quickshell-git
```
```text
~/.config/quickshell/
├── shell.qml          # konfigurasi default
├── bar/
│   └── shell.qml      # konfigurasi "bar"
└── lock/
    └── shell.qml      # konfigurasi "lock"
```
```bash
# Menjalankan konfigurasi tertentu
quickshell -c bar
# Menjalankan file QML langsung
quickshell -p /path/to/custom.qml
```

**Terminologi Kunci:**
- **Config:** Direktori bernama di dalam `~/.config/quickshell/` yang berisi `shell.qml`.
- **`shell.qml`:** Titik masuk (entry point) setiap konfigurasi Quickshell.
- **Hot Reload:** Quickshell memantau file dan memuat ulang konfigurasi secara otomatis saat disimpan.

**Daftar Isi:**
1. Instalasi stable vs `-git` dan risikonya.
2. Struktur direktori `~/.config/quickshell/`.
3. Menjalankan dan memilih konfigurasi (`-c`, `-p`).
4. Hot reload dan alur kerja pengembangan.
5. Instance management dan file locking (isolasi antar instance).

**Sumber Referensi:**
- [Quickshell Installation & Setup](https://quickshell.org/docs/v0.3.1/guide/install-setup/)
- [Quickshell Introduction (Config Files)](https://quickshell.org/docs/v0.3.1/guide/introduction/)
- [Instance and Path Management (DeepWiki)](https://deepwiki.com/quickshell-mirror/quickshell)

---

### Modul 1.2 — PanelWindow, Process, dan Timer

**Deskripsi Konkret:**  
Membuat bar/panel sederhana dengan `PanelWindow`, menjalankan perintah sistem melalui `Process`, dan memperbarui UI secara periodik dengan `Timer`. Ini adalah inti dari shell yang menampilkan informasi sistem (jam, baterai, volume).

**Konsep Dasar dan Filosofi:**  
Quickshell menyediakan `PanelWindow` untuk bar/overlay yang “menempel” di layar (menggunakan layer-shell), dan `Process` untuk berinteraksi dengan sistem tanpa memerlukan kode C++. Pendekatan ini **abstrak**: Anda mendeskripsikan *apa* yang ingin dijalankan, bukan *bagaimana* menjalankannya. Namun, Anda tetap memiliki kontrol penuh melalui argumen dan environment.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
    anchors { top: true; left: true; right: true }
    implicitHeight: 30

    Text {
        id: clock
        anchors.centerIn: parent
        text: "Loading..."
    }

    Process {
        id: dateProc
        command: ["date", "+%H:%M:%S"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: clock.text = this.text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
```
```qml
// Menjalankan perintah dengan environment kustom (untuk isolasi)
Process {
    command: ["sh", "-c", "echo $SECRET"]
    environment: ({ "SECRET": "value" })
}
```

**Terminologi Kunci:**
- **`PanelWindow`:** Window Quickshell yang menggunakan layer-shell; dapat di-anchor ke tepi layar dan mereservasi ruang.
- **`Process`:** Objek QML untuk menjalankan proses eksternal; mendukung stdin/stdout, environment, dan signal.
- **`StdioCollector`:** Mengumpulkan output stdout proses dan memancarkan `streamFinished` saat proses selesai.
- **`Timer`:** Memicu signal `triggered` secara periodik; berguna untuk polling ringan.

**Daftar Isi:**
1. `PanelWindow` dan anchoring.
2. `Process`: command, running, stdout/stdin, environment.
3. `StdioCollector` dan signal `streamFinished`.
4. `Timer` untuk update periodik.
5. Menjalankan perintah dengan hak akses minimal (environment bersih).

**Sumber Referensi:**
- [Quickshell Introduction: Creating Windows](https://quickshell.org/docs/v0.3.1/guide/introduction/#creating-windows)
- [Quickshell Introduction: Running a Process](https://quickshell.org/docs/v0.3.1/guide/introduction/#running-a-process)
- [Quickshell.Io Types](https://quickshell.org/docs/v0.3.1/types/Quickshell.Io/Process)

---

### Modul 1.3 — Komponen Reusable dan Singletons

**Deskripsi Konkret:**  
Memecah shell menjadi komponen-komponen kecil yang dapat digunakan ulang (`Component`, file `.qml` terpisah) dan menggunakan **singleton QML** untuk state global (misalnya, tema, konfigurasi).

**Konsep Dasar dan Filosofi:**  
Prinsip **modular** menuntut pemisahan concerns. Quickshell mendukung singletons melalui `pragma Singleton` dan `qmldir`. Singletons memungkinkan state global (misalnya, `Theme.qml`) diakses dari mana saja tanpa meneruskan properti secara manual. Ini mengurangi coupling dan meningkatkan auditabilitas.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
// components/Clock.qml
import QtQuick
Text {
    property string format: "HH:mm"
    // ...
}
```
```qml
// Theme.qml (singleton)
pragma Singleton
import QtQuick
QtObject {
    readonly property color background: "#1e1e2e"
    readonly property color foreground: "#cdd6f4"
    readonly property int barHeight: 30
}
```
```qml
// Penggunaan
import QtQuick
import "."  // untuk Theme singleton

Rectangle {
    color: Theme.background
    height: Theme.barHeight
}
```

**Terminologi Kunci:**
- **Singleton:** Instance tunggal yang dapat diakses secara global dalam QML; dideklarasikan dengan `pragma Singleton`.
- **`qmldir`:** File yang mendaftarkan komponen dan singleton agar dapat diimpor.
- **Komponen Reusable:** File `.qml` yang mendefinisikan tipe baru; dapat diparameterisasi melalui properti.

**Daftar Isi:**
1. Membuat komponen reusable di file terpisah.
2. Properti dan signal pada komponen.
3. Singleton QML dan `pragma Singleton`.
4. `qmldir` dan manajemen modul.
5. Menghindari “root imports” yang merusak LSP.

**Sumber Referensi:**
- [Quickshell Introduction: Reusable Components & Singletons](https://quickshell.org/docs/v0.3.1/guide/introduction/)
- [QML Singletons (Qt Documentation)](https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html)

---

## [Fase 2 — Integrasi Sistem: Wayland, Compositor, dan Layanan Desktop][3]

**Level:** Menengah  
**Estimasi:** 6–8 minggu  
**Prasyarat:** Fase 1 selesai.

### Modul 2.1 — Wayland Layer-Shell Protocol

**Deskripsi Konkret:**  
Memahami protokol `wlr-layer-shell` yang memungkinkan Quickshell membuat panel, overlay, dan lockscreen yang terintegrasi dengan compositor. Anda akan mempelajari layer (background, bottom, top, overlay) dan cara `PanelWindow` memetakan ke protokol ini.

**Konsep Dasar dan Filosofi:**  
Layer-shell adalah protokol Wayland yang memungkinkan client (seperti Quickshell) untuk “mengklaim” area di layar dan menempatkannya di lapisan tertentu. Ini berbeda dari window biasa: panel tidak memiliki dekorasi dan dapat mereservasi ruang sehingga aplikasi lain tidak tumpang tindih. Ini adalah fondasi **super kontrol** atas tata letak desktop.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
PanelWindow {
    // Quickshell secara internal menggunakan zwlr_layer_shell_v1
    anchors { top: true; left: true; right: true }
    exclusiveZone: 30  // mereservasi 30px agar aplikasi lain tidak tumpang tindih
    // layer: "top" (default untuk panel)
}
```
```bash
# Verifikasi compositor mendukung layer-shell
# Hyprland: aktif secara default
# Sway: aktif secara default
```

**Terminologi Kunci:**
- **`zwlr_layer_shell_v1`:** Protokol Wayland untuk layer surface (panel, overlay).
- **Exclusive Zone:** Area yang “dipesan” oleh panel sehingga compositor tidak menempatkan window lain di sana.
- **Layer:** Tingkatan (background, bottom, top, overlay) yang menentukan urutan rendering.

**Daftar Isi:**
1. Arsitektur Wayland dan peran compositor.
2. Protokol `wlr-layer-shell`: layer, anchor, exclusive zone.
3. `PanelWindow` vs `FloatingWindow`.
4. Layer pada Hyprland dan Sway.
5. Debugging layer-shell dengan `wayland-info`.

**Sumber Referensi:**
- [Wayland Layer Shell Protocol (wlroots)](https://wayland.app/protocols/wlr-layer-shell-unstable-v1)
- [Quickshell Platform Support (DeepWiki)](https://deepwiki.com/quickshell-mirror/quickshell)

**Visualisasi:** Diagram lapisan layar (background → bottom → top → overlay) sangat direkomendasikan.

---

### Modul 2.2 — IPC Compositor: Hyprland dan Sway

**Deskripsi Konkret:**  
Menggunakan integrasi Quickshell dengan IPC Hyprland dan Sway untuk membaca state workspace, monitor, dan jendela secara real-time, serta mengirim perintah ke compositor dari shell.

**Konsep Dasar dan Filosofi:**  
Compositor seperti Hyprland dan Sway menyediakan socket IPC untuk komunikasi dua arah. Quickshell membungkus IPC ini dalam layanan QML (`Quickshell.Hyprland`, `Quickshell.Sway`), sehingga Anda dapat bereaksi terhadap event dan mengontrol compositor tanpa parsing output teks. Ini adalah **otomatisasi keyboard-driven**: Anda dapat memetakan keybinding di compositor untuk memicu aksi di Quickshell melalui `qs ipc call`.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
import Quickshell.Hyprland

Text {
    // Menampilkan workspace aktif
    text: Hyprland.focusedWorkspace?.name ?? "?"
}
```
```qml
// Mengirim perintah ke Hyprland dari Quickshell
Process {
    command: ["hyprctl", "dispatch", "workspace", "2"]
    running: true
}
```
```bash
# Dari terminal, memicu IPC target Quickshell
qs ipc call ctrl toggle
```
```hypr
# hyprland.conf: keybinding untuk mengontrol Quickshell
bind = SUPER, B, exec, qs ipc call bar toggle
```

**Terminologi Kunci:**
- **IPC (Inter-Process Communication):** Mekanisme pertukaran data antar proses; Hyprland menggunakan socket Unix.
- **`Hyprland` singleton:** Layanan QML Quickshell yang menyediakan state compositor secara reaktif.
- **`qs ipc`:** CLI Quickshell untuk mengirim perintah ke instance yang berjalan.

**Daftar Isi:**
1. IPC Hyprland: socket, event, dan dispatcher.
2. Layanan `Quickshell.Hyprland`: workspace, monitor, jendela.
3. IPC Sway dan `SWAYSOCK`.
4. Mengekspos IPC target dari Quickshell (`qs ipc`)。
5. Keybinding compositor untuk mengontrol shell.

**Sumber Referensi:**
- [Hyprland IPC Wiki](https://wiki.hyprland.org/IPC/)
- [Quickshell Hyprland Integration (DeepWiki)](https://deepwiki.com/quickshell-mirror/quickshell)
- [Quickshell Sway Integration (DeepWiki)](https://deepwiki.com/quickshell-mirror/quickshell)

---

### Modul 2.3 — Layanan Desktop: PipeWire, MPRIS, BlueZ, UPower

**Deskripsi Konkret:**  
Mengintegrasikan shell dengan layanan desktop standar: kontrol audio (PipeWire), pemutar media (MPRIS), Bluetooth (BlueZ), dan baterai (UPower). Quickshell menyediakan modul QML siap pakai untuk masing-masing layanan.

**Konsep Dasar dan Filosofi:**  
Quickshell menyediakan **Service Integration Layer** yang menjembatani QML dengan D-Bus, PipeWire, dan protokol desktop lainnya. Ini memungkinkan shell Anda menjadi **monolitik** dalam fungsi (satu shell untuk banyak kontrol) tetapi tetap **modular** dalam kode (setiap layanan adalah modul terpisah). Anda tidak perlu menulis boilerplate D-Bus; cukup menggunakan tipe QML yang disediakan.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

// Kontrol volume PipeWire
Slider {
    from: 0; to: 100
    value: Pipewire.defaultAudioSink?.audio.volume ?? 0
    onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
}

// Menampilkan metadata MPRIS
Text {
    text: Mpris.players.values[0]?.track?.title ?? "No media"
}
```
```qml
import Quickshell.Services.UPower
Text {
    text: UPower.displayDevice?.percentage + "%"
}
```

**Terminologi Kunci:**
- **PipeWire:** Server multimedia modern untuk audio/video; Quickshell menyediakan `Quickshell.Services.Pipewire`.
- **MPRIS:** Spesifikasi D-Bus untuk kontrol pemutar media; Quickshell menyediakan `Quickshell.Services.Mpris`.
- **BlueZ:** Stack Bluetooth Linux; Quickshell menyediakan integrasi untuk kontrol Bluetooth.
- **UPower:** Layanan manajemen daya; Quickshell menyediakan `Quickshell.Services.UPower`.

**Daftar Isi:**
1. Arsitektur D-Bus dan Service Integration Layer Quickshell.
2. PipeWire: node, device, volume, dan routing.
3. MPRIS: player, track, playback control.
4. BlueZ: adapter, device, pairing.
5. UPower: baterai, power profiles.
6. System tray (StatusNotifierItem).

**Sumber Referensi:**
- [Quickshell Services Documentation](https://quickshell.org/docs/v0.3.1/types/Quickshell.Services/)
- [PipeWire Documentation](https://docs.pipewire.org/)
- [MPRIS D-Bus Specification](https://specifications.freedesktop.org/mpris-spec/latest/)
- [UPower Documentation](https://upower.freedesktop.org/docs/)

---

## [Fase 3 — Arsitektur Modular dan Manajemen State][4]

**Level:** Mahir  
**Estimasi:** 6 minggu  
**Prasyarat:** Fase 2 selesai.

### Modul 3.1 — Arsitektur Shell yang Skalabel

**Deskripsi Konkret:**  
Merancang arsitektur shell yang dapat tumbuh: pemisahan layanan (services), komponen UI, dan konfigurasi. Anda akan mempelajari pola yang digunakan oleh shell Quickshell populer (Caelestia, Noctalia) untuk mengelola kompleksitas.

**Konsep Dasar dan Filosofi:**  
Shell yang kompleks cenderung menjadi monolitik yang sulit dirawat. Prinsip **modular** menuntut pemisahan: `services/` untuk logika sistem, `components/` untuk UI reusable, `config/` untuk preferensi, dan `shell.qml` sebagai entry point yang “merakit” semuanya. Ini juga memudahkan audit keamanan: setiap modul dapat diperiksa secara terisolasi.

**Sintaks Dasar/Contoh Implementasi Inti:**
```text
~/.config/quickshell/my-shell/
├── shell.qml          # entry point: merakit services dan UI
├── services/
│   ├── Audio.qml      # singleton layanan audio
│   ├── Battery.qml
│   └── Workspaces.qml
├── components/
│   ├── Bar.qml
│   ├── Clock.qml
│   └── VolumeSlider.qml
└── config/
    └── Theme.qml      # singleton tema
```
```qml
// shell.qml
import QtQuick
import Quickshell
import "services"
import "components"

ShellRoot {
    Bar {
        audio: Audio
        battery: Battery
    }
}
```

**Terminologi Kunci:**
- **`ShellRoot`:** Root element opsional untuk konfigurasi Quickshell; menyediakan akses ke settings dan lifecycle.
- **Service Singleton:** Singleton QML yang membungkus layanan sistem (audio, baterai) dan mengekspos state reaktif.
- **Entry Point:** `shell.qml` yang mengimpor dan merakit modul-modul.

**Daftar Isi:**
1. Struktur direktori yang skalabel.
2. `ShellRoot` dan lifecycle.
3. Pola service singleton.
4. Dependency injection melalui properti QML.
5. Studi kasus: arsitektur Caelestia dan Noctalia.

**Sumber Referensi:**
- [Quickshell Core Types (ShellRoot)](https://quickshell.org/docs/v0.3.1/types/Quickshell/ShellRoot)
- [Quickshell project patterns (SkillsMP)](https://skillsmp.com/skills/quickshell)

---

### Modul 3.2 — Manajemen State dan Reaktivitas Lanjutan

**Deskripsi Konkret:**  
Menguasai property binding, signal, dan state management untuk membangun UI yang sepenuhnya reaktif. Anda akan mempelajari kapan menggunakan binding vs JavaScript imperative, serta cara menghindari binding loop.

**Konsep Dasar dan Filosofi:**  
Reaktivitas QML adalah kekuatan sekaligus jebakan. Binding yang salah dapat menyebabkan loop tak terbatas atau performa buruk. Prinsip **abstrak** menuntut Anda memahami *mengapa* suatu binding dievaluasi ulang, bukan sekadar *bagaimana* menulisnya. Anda akan mempelajari `Binding`, `Connections`, dan pola state machine sederhana.

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
// Binding eksplisit dengan kondisi
Binding {
    target: rect
    property: "color"
    value: mouseArea.containsMouse ? "blue" : "black"
    when: rect.visible
}
```
```qml
// Menghindari binding loop dengan signal handler
Slider {
    id: slider
    onValueChanged: {
        if (audio.volume !== value)
            audio.volume = value
    }
}
```

**Terminologi Kunci:**
- **Binding Loop:** Situasi di mana dua properti saling bergantung secara sirkular.
- **`Binding`:** Elemen QML untuk membuat binding kondisional atau sementara.
- **`Connections`:** Elemen untuk merespons signal dari objek lain tanpa mengubah properti target secara langsung.

**Daftar Isi:**
1. Siklus evaluasi binding.
2. Mendeteksi dan memperbaiki binding loop.
3. `Binding` dan `Connections`.
4. State machine sederhana dengan `states` dan `transitions`.
5. Optimasi performa binding.

**Sumber Referensi:**
- [QML Property Binding (Qt Documentation)](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)
- [QML Best Practices (Qt Academy)](https://www.qt.io/academy/course-catalog#qml-best-practice)

---

## [Fase 4 — Keamanan, Isolasi, dan Anonimitas][5]

**Level:** Mahir–Expert  
**Estimasi:** 4–6 minggu  
**Prasyarat:** Fase 3 selesai.

### Modul 4.1 — Model Keamanan Quickshell dan Isolasi Instance

**Deskripsi Konkret:**  
Memahami model keamanan Quickshell: bagaimana instance diisolasi, bagaimana file locking mencegah konflik, dan bagaimana menjalankan shell dengan hak akses minimal. Anda akan mempelajari sandboxing dengan `bubblewrap` dan teknik isolasi direktori XDG.

**Konsep Dasar dan Filosofi:**  
Quickshell menggunakan **POSIX advisory file locking** (`fcntl`) untuk mencegah beberapa instance menggunakan direktori yang sama. Namun, isolasi sejati memerlukan lebih dari itu: Anda harus membatasi akses filesystem, jaringan, dan D-Bus. Prinsip **least privilege** dan **anonimitas** menuntut shell Anda tidak memiliki akses ke data sensitif yang tidak diperlukan.

**Sintaks Dasar/Contoh Implementasi Inti:**
```bash
# Menjalankan Quickshell dalam bubblewrap dengan akses terbatas
bwrap \
  --ro-bind /usr /usr \
  --ro-bind /lib /lib \
  --ro-bind /lib64 /lib64 \
  --bind ~/.config/quickshell ~/.config/quickshell \
  --tmpfs /tmp \
  --unshare-net \
  --die-with-parent \
  quickshell -c secure-shell
```
```qml
// Membatasi akses Process ke environment minimal
Process {
    command: ["sh", "-c", "cat /proc/loadavg"]
    environment: ({ "PATH": "/usr/bin:/bin" })  // tanpa variabel sensitif
}
```
```qml
// Menggunakan pragma untuk override direktori data (isolasi)
//@ pragma DataDir $BASE/quickshell-secure
```

**Terminologi Kunci:**
- **File Locking:** Mekanisme OS untuk mencegah akses bersamaan ke resource.
- **Bubblewrap (`bwrap`):** Alat sandboxing ringan dari proyek Flatpak; menggunakan namespace Linux.
- **`pragma DataDir`:** Direktif Quickshell untuk mengubah direktori data instance.
- **Least Privilege:** Prinsip memberikan hak akses seminimal mungkin.

**Daftar Isi:**
1. Instance management dan file locking di Quickshell.
2. Isolasi direktori XDG dan `pragma DataDir`.
3. Sandboxing dengan `bubblewrap`: filesystem, jaringan, dan PID namespace.
4. Membatasi `Process` dan environment.
5. Audit akses filesystem dengan `strace`.
6. Anonimitas: menghindari logging yang tidak perlu.

**Sumber Referensi:**
- [Quickshell Instance and Path Management (DeepWiki)](https://deepwiki.com/quickshell-mirror/quickshell)
- [Bubblewrap GitHub](https://github.com/containers/bubblewrap)
- [Quickshell Security Baseline (SkillsMP)](https://skillsmp.com/skills/quickshell-process-action)

**Visualisasi:** Diagram namespace Linux (mount, network, PID) yang digunakan oleh `bubblewrap` sangat direkomendasikan.

---

### Modul 4.2 — Lockscreen, PAM, dan Greetd

**Deskripsi Konkret:**  
Membangun lockscreen aman menggunakan PAM (Pluggable Authentication Modules) dan display manager menggunakan Greetd. Anda akan mempelajari cara Quickshell menangani autentikasi tanpa membocorkan kredensial.

**Konsep Dasar dan Filosofi:**  
Lockscreen adalah komponen keamanan kritis. Quickshell menyediakan integrasi PAM untuk autentikasi dan Greetd untuk display manager. Prinsip **isolasi** menuntut lockscreen berjalan sebagai proses terpisah dengan akses minimal, dan **anonimitas** menuntut tidak ada logging kredensial. Jika Quickshell crash, compositor harus tetap dalam keadaan terkunci (fail-safe).

**Sintaks Dasar/Contoh Implementasi Inti:**
```qml
import Quickshell.Services.Pam

PamContext {
    id: pam
    onAuthenticationSuccess: { /* unlock */ }
    onAuthenticationFailure: { /* show error */ }
}
```
```bash
# Konfigurasi PAM untuk Quickshell lockscreen (contoh)
# /etc/pam.d/quickshell
auth required pam_unix.so
account required pam_unix.so
```
```qml
// Greetd integration (display manager)
import Quickshell.Services.Greetd
```

**Terminologi Kunci:**
- **PAM:** Framework autentikasi Linux; digunakan untuk verifikasi password.
- **Greetd:** Display manager minimalis yang mendukung Wayland.
- **Fail-safe Lock:** Jika proses lockscreen mati, compositor tetap terkunci (menggunakan `ext-session-lock`).

**Daftar Isi:**
1. Arsitektur PAM dan alur autentikasi.
2. `Quickshell.Services.Pam`: konteks dan signal.
3. Membangun lockscreen yang aman.
4. Greetd dan display manager minimalis.
5. Fail-safe locking dengan `ext-session-lock`.
6. Audit keamanan lockscreen.

**Sumber Referensi:**
- [Quickshell PAM Service](https://quickshell.org/docs/v0.3.1/types/Quickshell.Services.Pam/)
- [Greetd Documentation](https://sr.ht/~kennylevinsen/greetd/)
- [PAM Documentation (Linux-PAM)](https://www.linux-pam.org/Linux-PAM-html/)

---

## [Fase 5 — Expert/Enterprise: Optimasi, Ekstensi C++, dan Deployment][6]

**Level:** Expert/Enterprise  
**Estimasi:** 8+ minggu  
**Prasyarat:** Fase 4 selesai.

### Modul 5.1 — Plugin C++ dan Backend Kustom

**Deskripsi Konkret:**  
Memperluas Quickshell dengan plugin C++ untuk fungsionalitas yang tidak tersedia di QML murni (misalnya, akses hardware khusus, algoritma berat, atau integrasi dengan library sistem). Anda akan mempelajari cara Quickshell mengekspos tipe C++ ke QML.

**Konsep Dasar dan Filosofi:**  
Quickshell adalah toolkit C++ yang dapat diperluas. Ketika QML tidak cukup (misalnya, untuk operasi CPU-intensive atau akses API yang tidak diekspos), Anda dapat menulis plugin C++ yang mendaftarkan tipe QML baru. Ini adalah **super kontrol** pada level terendah, tetapi juga meningkatkan risiko keamanan—setiap baris C++ harus diaudit.

**Sintaks Dasar/Contoh Implementasi Inti:**
```cpp
// Contoh sederhana: tipe QML yang mengekspos informasi kernel
#include <QtQml>
#include <QObject>

class KernelInfo : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString version READ version CONSTANT)
public:
    QString version() const { return "6.x"; }
};
```
```cmake
# CMakeLists.txt untuk plugin
qt_add_qml_module(myplugin
    URI MyPlugin
    VERSION 1.0
    QML_FILES MyPlugin.qml
    SOURCES kernelinfo.cpp
)
```

**Terminologi Kunci:**
- **`QML_ELEMENT`:** Makro Qt untuk mendaftarkan kelas C++ sebagai tipe QML.
- **Plugin QML:** Library dinamis yang menyediakan tipe QML tambahan.
- **`qt_add_qml_module`:** Fungsi CMake untuk membangun modul QML dari C++.

**Daftar Isi:**
1. Arsitektur plugin Quickshell.
2. Mendaftarkan tipe C++ ke QML.
3. Property, signal, dan slot di C++.
4. Membangun plugin dengan CMake.
5. Audit keamanan kode C++.
6. Debugging plugin dengan `gdb`.

**Sumber Referensi:**
- [Quickshell HACKING.md (Development)](https://github.com/quickshell-mirror/quickshell/blob/master/HACKING.md)
- [Qt QML C++ Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-topic.html)

---

### Modul 5.2 — Optimasi Performa dan Profiling

**Deskripsi Konkret:**  
Mengoptimalkan shell Quickshell untuk penggunaan CPU, memori, dan GPU yang minimal. Anda akan mempelajari profiling dengan `perf`, `valgrind`, dan Qt Creator, serta teknik mengurangi alokasi memori dan rendering yang tidak perlu.

**Konsep Dasar dan Filosofi:**  
Shell yang berjalan terus-menerus harus efisien. Prinsip **monolitik** tidak berarti boros; justru sebaliknya, satu proses harus dioptimalkan sebaik mungkin. Anda akan mempelajari kapan menggunakan `MultiEffect` vs `qt5compat`, cara menghindari binding yang mahal, dan cara memantau penggunaan resource.

**Sintaks Dasar/Contoh Implementasi Inti:**
```bash
# Profiling dengan perf
perf stat -p $(pgrep quickshell)
# Atau
perf record -g -p $(pgrep quickshell)
```
```qml
// Menggunakan MultiEffect (lebih efisien) daripada efek qt5compat
MultiEffect {
    source: parent
    blurEnabled: true
    blur: 0.5
}
```
```bash
# Memantau memori
valgrind --tool=massif quickshell -c my-shell
```

**Terminologi Kunci:**
- **`perf`:** Alat profiling Linux untuk menghitung event hardware/software.
- **Scene Graph:** Struktur rendering QtQuick; memahami cara kerjanya membantu mengurangi overdraw.
- **Overdraw:** Menggambar piksel yang sama berulang kali; harus diminimalkan.

**Daftar Isi:**
1. Profiling CPU dengan `perf`.
2. Profiling memori dengan `valgrind`/`massif`.
3. Optimasi rendering QtQuick.
4. Menghindari binding dan JavaScript yang mahal.
5. Mengukur frame rate dan latency.
6. Benchmarking shell.

**Sumber Referensi:**
- [Qt Quick Performance Best Practices](https://doc.qt.io/qt-6/qtquick-performance.html)
- [perf Wiki](https://perf.wiki.kernel.org/)

---

### Modul 5.3 — Deployment, CI/CD, dan Kontribusi Upstream

**Deskripsi Konkret:**  
Mengemas shell Quickshell untuk distribusi (AUR, Nix, Flatpak), mengotomatiskan pengujian dengan CI/CD, dan berkontribusi ke proyek Quickshell upstream.

**Konsep Dasar dan Filosofi:**  
Shell yang baik harus dapat direproduksi dan diaudit. Anda akan mempelajari cara membuat PKGBUILD yang aman, menggunakan Nix flakes untuk reproducibility, dan menyiapkan pipeline CI yang menjalankan linting QML serta pengujian sandbox. Ini juga merupakan jalur untuk berkontribusi pada proyek open-source dan memvalidasi keahlian Anda.

**Sintaks Dasar/Contoh Implementasi Inti:**
```bash
# PKGBUILD sederhana untuk shell Quickshell kustom
pkgname=my-quickshell
pkgver=1.0
pkgrel=1
depends=('quickshell' 'qt6-svg')
source=("$pkgname-$pkgver.tar.gz")
package() {
    install -Dm644 shell.qml "$pkgdir/usr/share/quickshell/my-shell/shell.qml"
}
```
```yaml
# .github/workflows/ci.yml
name: CI
on: [push]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: qmllint shell.qml
```
```nix
# flake.nix untuk reproducibility
{
  inputs.quickshell.url = "github:quickshell-mirror/quickshell";
  outputs = { self, nixpkgs, quickshell }: {
    packages.x86_64-linux.default = quickshell.packages.x86_64-linux.default;
  };
}
```

**Terminologi Kunci:**
- **PKGBUILD:** Skrip build paket Arch Linux.
- **Nix Flake:** Konfigurasi Nix yang reproducible dan composable.
- **`qmllint`:** Alat linting statis untuk file QML.
- **CI/CD:** Continuous Integration/Continuous Deployment; otomatisasi build dan test.

**Daftar Isi:**
1. Membuat PKGBUILD untuk shell kustom.
2. Nix flake dan reproducibility.
3. CI/CD untuk linting QML dan pengujian.
4. Menyiapkan environment pengembangan dengan `quickshell-git`.
5. Berkontribusi ke Quickshell upstream (HACKING.md, CONTRIBUTING.md).
6. Publikasi shell ke AUR.

**Sumber Referensi:**
- [Arch PKGBUILD Wiki](https://wiki.archlinux.org/title/PKGBUILD)
- [Nix Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [Quickshell HACKING.md](https://github.com/quickshell-mirror/quickshell/blob/master/HACKING.md)
- [Quickshell CONTRIBUTING.md](https://github.com/quickshell-mirror/quickshell/blob/master/CONTRIBUTING.md)

---

## Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan seluruh kurikulum, Anda akan mampu:

1. **Merancang dan membangun** shell desktop Wayland dari nol menggunakan Quickshell dan QML, sepenuhnya dikontrol melalui keyboard dan kode.
2. **Mengintegrasikan** shell dengan layanan sistem (PipeWire, MPRIS, BlueZ, UPower, Hyprland/Sway IPC) secara reaktif.
3. **Menerapkan prinsip keamanan** dalam pengembangan shell: isolasi instance, sandboxing dengan `bubblewrap`, least privilege, dan audit kode.
4. **Membangun lockscreen dan display manager** yang aman dengan PAM dan Greetd, termasuk fail-safe locking.
5. **Memperluas Quickshell** dengan plugin C++ untuk fungsionalitas kustom.
6. **Mengoptimalkan performa** shell untuk penggunaan resource minimal.
7. **Mengemas dan mendistribusikan** shell melalui AUR, Nix, atau Flatpak, serta berkontribusi ke proyek upstream.
8. **Mengadaptasi** kurikulum ini untuk tujuan lain (misalnya, shell untuk lingkungan air-gapped, shell untuk forensic workstation) dengan menambahkan modul keamanan dan anonimitas tambahan.

---

## Sumber Daya Komunitas dan Sertifikasi

| Sumber Daya | Tautan | Catatan |
|---|---|---|
| **Quickshell Matrix/Discord** | [quickshell.org/community](https://quickshell.org/) (lihat tautan komunitas) | Diskusi langsung dengan pengembang dan pengguna. |
| **GitHub Discussions** | [quickshell-mirror/quickshell/discussions](https://github.com/quickshell-mirror/quickshell/discussions) | Q&A dan showcase. |
| **r/unixporn** | [reddit.com/r/unixporn](https://www.reddit.com/r/unixporn/) | Inspirasi shell Quickshell (cari “quickshell”). |
| **Qt Academy** | [qt.io/academy](https://www.qt.io/academy) | Kursus QML gratis dan bersertifikat (QML for Beginners, Qt Quick). |
| **Hyprland Wiki** | [wiki.hyprland.org](https://wiki.hyprland.org/) | Dokumentasi IPC dan layer-shell. |
| **Sway Wiki** | [github.com/swaywm/sway/wiki](https://github.com/swaywm/sway/wiki) | Integrasi Sway. |
| **Sertifikasi** | Tidak ada sertifikasi resmi Quickshell; validasi keahlian melalui **portofolio shell yang dipublikasikan** (GitHub, AUR) dan kontribusi upstream. | |

---

## Catatan Akhir untuk Pengguna dengan Profil Anda

Kurikulum ini sengaja menghindari ketergantungan pada GUI yang tidak dapat dikustomisasi. Quickshell sendiri adalah **program**, dan Anda mengontrolnya melalui **file QML yang Anda tulis sendiri**. Setiap modul menekankan **auditabilitas** dan **isolasi**. Untuk profil cybersecurity Anda, disarankan menambahkan modul mandiri tentang:

- **Analisis statis QML** dengan `qmllint` dan `semgrep` untuk mendeteksi pola tidak aman.
- **Isolasi D-Bus** menggunakan `xdg-dbus-proxy` untuk membatasi akses shell ke bus sistem.
- **Anonimitas metadata** dengan menghapus timestamp dan path dari file konfigurasi sebelum distribusi.

Dengan menyelesaikan kurikulum ini, Anda tidak hanya akan menguasai Quickshell, tetapi juga memiliki kerangka berpikir untuk **membangun, mengamankan, dan mengaudit** shell Wayland apa pun yang sepenuhnya selaras dengan prinsip **super kontrol berbasis keyboard**.

[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./bagian-4/README.md
[5]: ./bagian-5/README.md
[6]: ./bagian-6/README.md

