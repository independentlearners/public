# Kurikulum Komprehensif: Quickshell, QML, dan Ekosistem Wayland untuk Shell Desktop Keyboard-Driven

*Revisi pasca-audit · diverifikasi terhadap dokumentasi Quickshell v0.3.x · 3 November 2026*

Kurikulum ini dirancang untuk **power user Arch Linux** yang bekerja di lingkungan **CLI/TUI**, mengutamakan **kontrol keyboard penuh**, **keamanan**, **isolasi**, dan **anonimitas**, dengan prinsip **monolitik, modular, abstrak, dan super kontrol**. Quickshell bukan sekadar bar atau panel: ia adalah **toolkit berbasis QtQuick/QML** untuk membangun seluruh komponen desktop (bar, launcher, notification daemon, lockscreen, greeter) di atas **Wayland compositor** seperti Hyprland, Sway, atau Niri. Anda memprogram shell Anda sendiri, bukan sekadar mengatur tema.

> **Filosofi Inti:** Shell adalah **program**, bukan konfigurasi. Setiap piksel, binding, dan interaksi harus dapat dikontrol lewat kode dan keyboard. Keamanan dicapai lewat **isolasi proses**, **least privilege**, dan **auditabilitas kode**, bukan lewat GUI yang tidak transparan.

Empat prinsip dipakai sebagai kriteria desain di seluruh modul:

| Prinsip | Arti praktis di Quickshell |
| --- | --- |
| **Monolitik** | Satu proses shell menyatukan bar, launcher, notifikasi, dan lockscreen, tetapi setiap bagian tetap dapat diaudit sendiri. |
| **Modular** | Pisahkan `services/` (logika sistem), `components/` (UI), dan `config/` (preferensi). |
| **Abstrak** | Deskripsikan *apa* yang diinginkan (deklaratif); biarkan runtime mengurus *bagaimana*. |
| **Super kontrol** | Setiap aksi dapat dipicu keyboard dan IPC (`qs ipc call`), tanpa ketergantungan pada mouse. |

---

## Cara Memakai Kurikulum Ini

**Dua jalur belajar.** *Jalur A* (power user yang sudah nyaman dengan terminal dan Arch) mulai dari Fase 0. *Jalur B* (pemula atau non-IT) mulai dari **Fase −1**, yang menyiapkan keterampilan dasar dan laboratorium yang aman.

**Template setiap modul:** Deskripsi Konkret → Analogi → Konsep Dasar dan Filosofi → Sintaks Dasar/Contoh → Terminologi Kunci → Daftar Isi → Latihan dan Checkpoint → Sumber Referensi → Visualisasi.

**Aturan kerja:**

1. Jangan lanjut ke modul berikutnya sebelum *checkpoint* modul ini lulus.
2. Contoh kode adalah **kerangka minimalis**. API Quickshell berkembang antarversi, jadi verifikasi setiap tipe pada halaman referensi versi yang terpasang (`quickshell --version`). Pola alamat halaman tipe: `https://quickshell.org/docs/types/<Modul>/<Tipe>` (contoh: `Quickshell.Io/Process`).
3. Ragu dengan nilai atau skala sebuah properti? Cetak dengan `console.log(...)` sebelum mempercayainya.
4. Jalankan eksperimen berisiko (lockscreen, sandbox) di **VM atau sesi cadangan**, bukan di sesi utama Anda.

---

## Prasyarat

- **Jalur A:** Arch Linux terpasang (dengan `base-devel`), compositor Wayland yang mendukung `wlr-layer-shell` (Hyprland, Sway, Niri), navigasi terminal, editor modal (`vim`/`nvim`/`helix`), `pacman`, dan `git`.
- **Jalur B:** tidak ada prasyarat teknis selain komputer yang mampu menjalankan mesin virtual dan kemauan mengetik perintah. Fase −1 membangun sisanya.
- **Komitmen keamanan (semua jalur):** tidak menjalankan konfigurasi, skrip, atau PKGBUILD dari sumber tidak tepercaya sebelum membacanya, dan memahami bahwa **konfigurasi Quickshell adalah kode yang berjalan dengan hak akses Anda**.

---

## Alat Esensial

| Kategori | Alat | Catatan |
| --- | --- | --- |
| **Editor/IDE** | Neovim atau Helix + `qmlls` | `qmlls` ada di paket `qt6-declarative` (biasanya di `/usr/lib/qt6/bin/`). Buat berkas kosong `.qmlls.ini` di folder shell agar Quickshell mengisinya untuk LSP. |
| **Multiplexer** | `tmux` atau `zellij` | Menjalankan Quickshell, log, dan editor dalam satu sesi keyboard-driven. |
| **Build** | `cmake`, `ninja`, `gcc` | Untuk build dari source dan plugin C++. |
| **Qt6** | `qt6-base`, `qt6-declarative`, `qt6-wayland`, `qt6-svg`, `qt6-imageformats`, `qt6-multimedia`, `qt6-5compat` | Dependensi Quickshell dan efek visual. |
| **Compositor** | Hyprland, Sway, Niri | Hyprland: modul `Quickshell.Hyprland`. Sway/i3: modul `Quickshell.I3`. Lainnya: lewat `Process` ke CLI compositor. |
| **Inspeksi Wayland** | `wayland-utils` (`wayland-info`) | Melihat protokol yang disediakan compositor. |
| **Audit/Isolasi** | `strace`, `bubblewrap`, `xdg-dbus-proxy`, `systemd-analyze` | Analisis syscall, sandbox, penyaringan D-Bus, skor hardening unit. |
| **Debug/Profiling** | `gdb`, `perf`, `heaptrack`, `valgrind` | Crash, CPU, dan memori. |
| **Kualitas** | `qmllint` | Linting statis QML. |
| **Laboratorium** | QEMU/KVM (`virt-manager`) | VM aman untuk eksperimen (Fase −1.3). |

---

## Struktur Fase dan Estimasi Waktu

| Fase | Level | Estimasi | Fokus |
| --- | --- | --- | --- |
| **−1** (opsional) | Prapemula | 3–4 minggu | Terminal, konsep pemrograman, JavaScript dasar, lab VM |
| **0** | Pemula | 5–7 minggu | Linux, keamanan Wayland, QML, Qt6, JavaScript dan animasi |
| **1** | Pemula–Menengah | 5 minggu | `shell.qml`, `PanelWindow`, `Variants`, `Process`, komponen, debugging, autostart |
| **2** | Menengah | 8–10 minggu | Layer-shell, fokus keyboard, IPC, layanan desktop, notifikasi/tray/launcher, persistensi |
| **3** | Mahir | 6–7 minggu | Arsitektur, state, kualitas kode |
| **4** | Mahir–Expert | 6–8 minggu | Threat model, sandbox, lockscreen, PAM, greetd, hardening sesi |
| **5** | Expert/Enterprise | 8+ minggu | Plugin C++, performa, deployment, CI/CD, upstream |
| **Capstone** | Penguasaan | 4–6 minggu | Shell mandiri end-to-end |

**Total Jalur A:** 42–51+ minggu (±10–12 bulan). Jalur B menambah 3–4 minggu. Dengan 10–15 jam/minggu, kebutuhan total ±420–770 jam.

---

## Model Ancaman Singkat (Benang Merah Keamanan)

Keamanan tidak boleh baru muncul di Fase 4. Sejak awal, pegang peta ini dan tanyakan di setiap modul: *aset apa yang saya lindungi, dari siapa, dan di batas mana?*

```text
[Anda / keyboard]
      │
┌─────▼──────────────────────────────────┐
│ Compositor (Hyprland/Sway/Niri)        │ ← batas #1: protokol Wayland istimewa
│  ┌──────────────────────────────────┐  │
│  │ Quickshell (QML = kode!)         │  │ ← batas #2: hak akses pengguna penuh
│  │  └─ Process / helper             │  │ ← batas #3: sandbox (bwrap / systemd)
│  └──────────────────────────────────┘  │
└─────┬──────────────────────────────────┘
      │ D-Bus · socket IPC · PAM
[Layanan sistem: PipeWire, UPower, logind, PAM]
```

| Ancaman | Contoh | Mitigasi | Modul |
| --- | --- | --- | --- |
| Konfigurasi berbahaya | Config pihak ketiga memanggil `Process` atau membaca berkas pribadi | Baca seluruh kode sebelum dijalankan; jalankan di VM | 4.1 |
| Rantai pasok | PKGBUILD AUR atau GitHub Action berubah isinya | Audit PKGBUILD, build di chroot bersih, pin Action ke commit SHA | 0.1, 5.3 |
| Kebocoran lingkungan | Variabel rahasia diwariskan ke proses anak | `clearEnvironment: true` + daftar putih variabel | 1.2, 4.1 |
| Bypass lockscreen | Memakai fokus keyboard eksklusif sebagai pengganti kunci sesi | Gunakan `WlSessionLock`, bukan `WlrKeyboardFocus.Exclusive` | 4.2 |
| Klien Wayland berhak istimewa | Klien memakai screencopy atau virtual-keyboard | Batasi lewat security-context bila compositor mendukung | 0.1, 2.1 |
| Jejak data | Kredensial atau path pribadi masuk ke log | Jangan mencatat input sensitif; periksa isi log | 1.4, 4.2 |

---

## Fase −1 — Literasi Dasar untuk Pemula (Opsional)

**Level:** Prapemula · **Estimasi:** 3–4 minggu · **Prasyarat:** komputer yang mampu menjalankan mesin virtual.

### Modul −1.1 — Terminal, Filesystem, dan Proses

**Deskripsi Konkret:** Anda belajar bergerak di sistem berkas, membaca izin berkas, menyambung perintah dengan pipe, dan memahami variabel lingkungan. Ini bahan baku hampir semua modul berikutnya (`Process`, `bwrap`, `systemd`).

**Analogi:** Terminal adalah percakapan tertulis dengan komputer: Anda menulis kalimat perintah, komputer membalas dengan teks.

**Konsep Dasar dan Filosofi:** Di Linux, hampir semuanya berupa berkas dan program kecil yang saling disambung. Keluaran satu program dapat menjadi masukan program lain lewat *pipe*, membentuk rantai yang bisa diaudit baris demi baris. Pola pikir inilah yang membuat `Process` di Quickshell terasa natural.

**Sintaks Dasar/Contoh:**

```bash
pwd; ls -la ~                 # di mana saya, apa isinya
mkdir -p ~/lab && cd ~/lab    # buat dan masuk folder
echo halo > catatan.txt       # tulis berkas
cat catatan.txt | wc -c       # sambung dua program dengan pipe
chmod 600 catatan.txt         # hanya pemilik yang boleh baca/tulis
echo $HOME; env | head        # variabel lingkungan
```

**Terminologi Kunci:**

- **Shell:** program yang membaca perintah Anda (`bash`, `zsh`, `fish`); **terminal** adalah jendelanya.
- **Pipe (`|`):** menyambung keluaran satu program ke masukan program lain.
- **Izin berkas:** aturan siapa yang boleh membaca, menulis, atau menjalankan berkas.
- **Variabel lingkungan:** pasangan nama-nilai yang diwariskan ke setiap proses anak.
- **Proses:** program yang sedang berjalan.

**Daftar Isi:**

1. Navigasi dan manipulasi berkas.
2. Izin dan kepemilikan.
3. Pipe dan redirect.
4. Variabel lingkungan dan `PATH`.
5. Melihat dan menghentikan proses (`ps`, `kill`).

**Latihan dan Checkpoint:** Buat folder `~/lab`, tulis tiga berkas, hitung baris gabungannya dengan satu rantai pipe. *Checkpoint:* jelaskan mengapa proses anak bisa membaca variabel yang diatur induknya.

**Sumber Referensi:** [Arch Wiki: Core utilities](https://wiki.archlinux.org/title/Core_utilities) · [Arch Wiki: File permissions and attributes](https://wiki.archlinux.org/title/File_permissions_and_attributes)

---

### Modul −1.2 — Konsep Pemrograman dan JavaScript Dasar

**Deskripsi Konkret:** Memahami variabel, fungsi, objek, array, dan event, memakai JavaScript, karena QML menanamkan JavaScript di dalam ekspresinya.

**Analogi:** Variabel adalah kotak berlabel; fungsi adalah resep yang bisa dipakai berulang; event adalah bel pintu yang memicu resep tertentu.

**Konsep Dasar dan Filosofi:** Program adalah rangkaian keputusan dan transformasi data. JavaScript modern memberi alat ringkas (fungsi panah, `map`, optional chaining) yang akan Anda lihat di hampir setiap konfigurasi Quickshell.

**Sintaks Dasar/Contoh** (jalankan dengan `node`, `sudo pacman -S nodejs`):

```js
const tugas = ['mandi', 'sarapan', 'kerja'];            // array
const besar = tugas.map(t => t.toUpperCase());            // fungsi panah + map
const info = { nama: 'budi', aktif: true };               // objek
console.log(`Halo ${info.nama}`, info.profil?.umur ?? 'tidak diketahui');  // ?. dan ??
```

**Terminologi Kunci:**

- **Variabel:** nama untuk sebuah nilai (`const` tidak bisa diubah, `let` bisa).
- **Fungsi:** blok kode bernama yang menerima masukan dan memberi hasil.
- **Objek / Array:** kumpulan data berpasangan nama-nilai / berurutan.
- **Optional chaining (`?.`) dan nullish coalescing (`??`):** akses aman terhadap nilai yang mungkin kosong, dan nilai cadangan.
- **Event:** kejadian (klik, tombol ditekan) yang memicu kode.

**Daftar Isi:**

1. Tipe data dan variabel.
2. Fungsi dan fungsi panah.
3. Objek, array, dan metode `map`/`filter`.
4. `?.`, `??`, dan template literal.
5. Membaca pesan galat.

**Latihan dan Checkpoint:** Tulis fungsi yang menyaring daftar nama berawalan huruf tertentu. *Checkpoint:* jelaskan perbedaan `undefined` dan `null`, dan apa yang dilakukan `?.`.

**Sumber Referensi:** [MDN: JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)

---

### Modul −1.3 — Laboratorium Aman: VM Arch dan Snapshot

**Deskripsi Konkret:** Menyiapkan mesin virtual Arch Linux dengan snapshot, supaya setiap eksperimen (lockscreen, sandbox, konfigurasi compositor) bisa dibatalkan seketika.

**Analogi:** VM adalah ruang uji coba berdinding kaca: apa pun yang rusak di dalamnya tidak menyentuh rumah Anda, dan tombol *undo* selalu tersedia.

**Konsep Dasar dan Filosofi:** Prinsip *isolasi* dimulai dari cara Anda belajar. Kesalahan pada lockscreen atau sandbox bisa mengunci Anda dari sesi sendiri; di VM, risikonya nol.

**Sintaks Dasar/Contoh:**

```bash
sudo pacman -S --needed qemu-full virt-manager libvirt dnsmasq
sudo systemctl enable --now libvirtd.service
# di virt-manager: pilih video virtio dengan 3D aktif, lalu ambil snapshot sebelum tiap eksperimen
```

**Terminologi Kunci:**

- **VM (mesin virtual):** komputer tiruan yang berjalan di dalam komputer Anda.
- **Snapshot:** titik simpan keadaan VM yang bisa dipulihkan.
- **TTY:** konsol teks murni, jalur penyelamat bila sesi grafis bermasalah.

**Daftar Isi:**

1. QEMU/KVM dan `libvirt`.
2. Memasang Arch di VM.
3. Snapshot dan pemulihan.
4. Berpindah ke TTY (`Ctrl+Alt+F3`) sebagai jalur penyelamat.

**Latihan dan Checkpoint:** Pasang Arch minimal di VM, ambil snapshot, hapus sembarang berkas sistem, lalu pulihkan. *Checkpoint:* tunjukkan cara masuk ke TTY dan menghentikan proses grafis yang macet.

**Sumber Referensi:** [Arch Wiki: QEMU](https://wiki.archlinux.org/title/QEMU) · [Arch Wiki: libvirt](https://wiki.archlinux.org/title/Libvirt)

---

## Fase 0 — Fondasi: Linux, Wayland, QML, dan Qt6

**Level:** Pemula · **Estimasi:** 5–7 minggu · **Prasyarat:** Arch Linux terpasang (atau VM dari Fase −1.3) dan terminal dasar.

### Modul 0.1 — Arch Linux, Keamanan Wayland, dan Higiene AUR

**Deskripsi Konkret:** Membangun lingkungan kerja keyboard-driven (shell, multiplexer, `pacman`), memahami model keamanan Wayland, dan menerapkan kebiasaan audit AUR sebelum memasang `quickshell-git`.

**Analogi:** Compositor Wayland adalah manajer gedung: ia mengendalikan semua pintu dan jendela; aplikasi hanya penyewa yang tidak boleh mengintip unit lain.

**Konsep Dasar dan Filosofi:** Arch memberi kontrol granular dan memaksa Anda memahami dependensi, selaras dengan prinsip *super kontrol*. Di X11 setiap klien dapat membaca input dan layar klien lain; di Wayland isolasi itu adalah bawaan. Namun protokol istimewa (layer-shell, screencopy, virtual-keyboard) tetap tersedia bagi klien yang diizinkan compositor. Pembatasannya lewat protokol *security-context* dan dukungannya berbeda antar compositor, jadi **periksa milik Anda**. AUR berisi skrip kiriman pengguna: pasang hanya setelah dibaca.

**Sintaks Dasar/Contoh:**

```bash
sudo pacman -S --needed base-devel git qt6-base qt6-declarative qt6-wayland qt6-svg cmake ninja wayland-utils
echo $XDG_SESSION_TYPE                                                # harus: wayland
wayland-info | grep -E 'layer_shell|session_lock|security_context'    # protokol yang tersedia
```

```bash
# higiene AUR: baca sebelum membangun
git clone https://aur.archlinux.org/quickshell-git.git && cd quickshell-git
less PKGBUILD            # periksa source=, build(), package(), dan skrip .install
git log --stat           # riwayat perubahan
pkgctl build             # build di chroot bersih (paket devtools); alternatif: makepkg -si
```

**Terminologi Kunci:**

- **Wayland:** protokol display modern pengganti X11; compositor memegang rendering dan input.
- **Compositor:** program pengelola jendela, input, dan rendering (Hyprland, Sway, Niri).
- **Protokol istimewa:** ekstensi Wayland yang memberi kuasa lebih (mis. `zwlr_layer_shell_v1`).
- **XDG Base Directory:** standar lokasi konfigurasi (`~/.config`), data (`~/.local/share`), cache (`~/.cache`).
- **PKGBUILD:** skrip build paket Arch; di AUR, ditulis pihak ketiga.

**Daftar Isi:**

1. Instalasi Arch dan `base-devel`.
2. `pacman`, AUR, dan **higiene AUR** (audit PKGBUILD, chroot bersih).
3. Shell scripting untuk otomatisasi (`bash`/`zsh`).
4. `tmux`: sesi, pane, keybinding.
5. Arsitektur Wayland dan **implikasi keamanannya** (isolasi input, protokol istimewa, security-context).

**Latihan dan Checkpoint:** Jalankan `wayland-info` dan catat protokol yang tersedia di compositor Anda; audit satu PKGBUILD AUR dan tulis tiga hal yang Anda periksa. *Checkpoint:* jelaskan mengapa klien Wayland biasa tidak dapat membaca ketikan klien lain, dan protokol mana yang mengecualikan hal itu.

**Sumber Referensi:** [Arch Wiki: Installation guide](https://wiki.archlinux.org/title/Installation_guide) · [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland) · [Arch Wiki: AUR](https://wiki.archlinux.org/title/Arch_User_Repository) · [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) · [Protokol security-context-v1](https://wayland.app/protocols/security-context-v1)

**Visualisasi:**

```text
Shell/Aplikasi (klien) ──protokol Wayland──► Compositor ──DRM/KMS + libinput──► Kernel ──► GPU · Layar · Input
        ▲                                        │
        └────── event input (hanya ke yang fokus) ┘
```

---

### Modul 0.2 — QML: Bahasa Deklaratif untuk Antarmuka

**Deskripsi Konkret:** Mempelajari sintaks QML dari nol: properti, binding, signal, komponen, layout, dan model-view-delegate. QML mendeskripsikan UI dan perilaku shell Quickshell.

**Analogi:** Seperti lembar kerja spreadsheet: sel yang bergantung pada sel lain dihitung ulang otomatis. Binding QML bekerja dengan cara yang sama.

**Konsep Dasar dan Filosofi:** QML memisahkan **deklarasi** (apa yang tampak) dari **logika imperatif** (JavaScript di dalam ekspresi). **Property binding** adalah inti reaktivitas: ketika nilai sumber berubah, nilai turunan diperbarui otomatis. Shell bereaksi terhadap state sistem (baterai, volume, workspace) tanpa polling manual.

**Sintaks Dasar/Contoh:**

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

```qml
// Binding dan signal handler
Text {
    property int counter: 0
    text: 'Count: ' + counter          // binding: diperbarui otomatis
    color: 'white'
    MouseArea { anchors.fill: parent; onClicked: parent.counter += 1 }
}
```

```qml
// Layout dan model-view-delegate
import QtQuick.Layouts
RowLayout {
    spacing: 8
    Repeater {
        model: ['alpha', 'beta', 'gamma']
        delegate: Text { required property string modelData; text: modelData; color: 'white' }
    }
}
```

> `Rectangle` polos tidak bisa dijalankan Quickshell: akar berkas harus berupa window (`FloatingWindow`/`PanelWindow`). Alternatif: `qml6` dari paket `qt6-declarative`.

**Terminologi Kunci:**

- **QML:** bahasa deklaratif untuk UI; setiap elemen adalah objek dengan properti.
- **Property binding:** ekspresi yang dihitung ulang saat dependensinya berubah.
- **Signal / signal handler:** notifikasi bahwa sesuatu terjadi (`clicked`) / blok kode yang merespons (`onClicked`).
- **Anchors:** aturan penempelan elemen ke elemen lain atau induknya (`anchors.fill`, `anchors.centerIn`).
- **Positioner dan Layout:** `Row`/`Column`/`Grid`/`Flow` menata anak berurutan; `RowLayout`/`ColumnLayout`/`GridLayout` (QtQuick.Layouts) menata dengan ukuran fleksibel.
- **Model-View-Delegate:** `model` = data, `Repeater`/`ListView` = penyaji, `delegate` = tampilan satu item.

**Daftar Isi:**

1. Sintaks dasar dan struktur berkas `.qml`.
2. Properti, tipe data, dan binding.
3. Signal dan signal handler.
4. Anchors, positioner, dan layout.
5. Model-View-Delegate (`Repeater`, `ListView`).
6. Komponen inline dan berkas komponen terpisah.

**Latihan dan Checkpoint:** Buat jendela dengan tiga tombol (tambah, kurang, reset) untuk sebuah counter. *Checkpoint:* jelaskan mengapa teks berubah tanpa Anda memanggil fungsi apa pun.

**Sumber Referensi:** [Qt QML Documentation](https://doc.qt.io/qt-6/qmlapplications.html) · [Qt Academy](https://www.qt.io/academy) (kursus QML gratis) · panduan *QML Language* di [quickshell.org/docs](https://quickshell.org/docs/)

**Visualisasi:**

```text
FloatingWindow
└─ Text  (text ← terikat ke counter)
   └─ MouseArea (onClicked → counter += 1 → binding menghitung ulang text)
```

---

### Modul 0.3 — Qt6 dan QtQuick: Fondasi di Balik Quickshell

**Deskripsi Konkret:** Memahami Qt6 sebagai framework C++ di balik Quickshell dan QtQuick sebagai modul rendering: window, efek, dan animasi.

**Analogi:** Qt adalah mesin dan rangka mobil; QML adalah dasbor dan setir yang Anda pegang.

**Konsep Dasar dan Filosofi:** QtQuick menggambar lewat *scene graph* yang dipercepat GPU. Memahami ini membantu Anda mengoptimalkan performa dan mengenali batas: misalnya `MultiEffect` hanya mengaburkan isi item Anda sendiri; mengaburkan *latar di belakang jendela* adalah urusan compositor.

**Sintaks Dasar/Contoh:**

```bash
sudo pacman -S qt6-svg qt6-imageformats qt6-multimedia qt6-5compat
```

```qml
// MultiEffect: sumber terpisah, TIDAK menjadikan induk sebagai source
import QtQuick
import QtQuick.Effects

Item {
    width: 120; height: 120
    Rectangle { id: src; anchors.fill: parent; color: 'royalblue'; radius: 16; visible: false }
    MultiEffect { source: src; anchors.fill: src; blurEnabled: true; blurMax: 32; blur: 1.0 }
}
```

**Terminologi Kunci:**

- **QtQuick:** modul Qt untuk UI dinamis dengan QML.
- **Scene graph:** struktur data rendering yang dioptimalkan untuk GPU.
- **MultiEffect:** efek visual modern Qt6 (blur, shadow, mask); lebih efisien daripada efek lama di `qt5compat`.
- **Overdraw:** menggambar piksel yang sama berulang kali; harus diminimalkan.

**Daftar Isi:**

1. Arsitektur Qt6 dan modul-modulnya.
2. QtQuick vs QtWidgets (mengapa Quickshell memilih QtQuick).
3. Modul Qt6 yang relevan (`qt6-svg`, `qt6-wayland`, `qt6-multimedia`).
4. Efek visual: `MultiEffect` dan `qt5compat`.
5. Jendela transparan: `color: 'transparent'` dan peran compositor untuk blur latar.
6. Sistem resource Qt dan cara Quickshell memuat berkas QML.

**Latihan dan Checkpoint:** Beri bayangan (shadow) pada sebuah kartu dengan `MultiEffect`. *Checkpoint:* jelaskan mengapa sumber efek tidak boleh sama dengan induk yang memuat efek itu.

**Sumber Referensi:** [Qt6 Documentation](https://doc.qt.io/qt-6/) · [MultiEffect](https://doc.qt.io/qt-6/qml-qtquick-effects-multieffect.html) · panduan *Install & Setup* di [quickshell.org/docs](https://quickshell.org/docs/)

---

### Modul 0.4 — JavaScript di QML, Animasi, dan Cara Membaca Dokumentasi Referensi

**Deskripsi Konkret:** Memakai JavaScript di dalam ekspresi QML, membuat animasi halus, dan, yang paling penting untuk penguasaan, **membaca halaman referensi tipe Quickshell sendiri** sehingga Anda tidak bergantung pada contoh orang lain.

**Analogi:** Referensi API adalah kamus; contoh kode hanyalah kalimat contoh. Penguasaan berarti bisa menyusun kalimat sendiri dari kamus.

**Konsep Dasar dan Filosofi:** Kemampuan menambah fitur apa pun bergantung pada satu keterampilan: memetakan kebutuhan ke tipe yang tepat lalu membaca *Properties*, *Functions*, dan *Signals* tipe itu. Label `readonly`, `uncreatable`, dan `singleton` menjelaskan cara tipe dipakai. Bila sebuah entri tertulis *No details provided*, baca kode sumbernya.

**Sintaks Dasar/Contoh:**

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

**Terminologi Kunci:**

- **Ekspresi JavaScript:** potongan JS di dalam binding atau handler.
- **`Behavior`:** animasi otomatis setiap kali sebuah properti berubah.
- **`Component.onCompleted`:** kode yang berjalan setelah objek selesai dibuat.
- **Singleton (di referensi):** tipe yang langsung dipakai tanpa dibuat instansinya, mis. `Pipewire`.

**Daftar Isi:**

1. JavaScript dalam binding dan handler (`?.`, `??`, fungsi panah).
2. `Behavior`, `NumberAnimation`, `states`, dan `transitions`.
3. `Component.onCompleted` dan siklus hidup objek.
4. Membaca halaman referensi tipe Quickshell.
5. Memeriksa nilai dengan `console.log(JSON.stringify(obj))`.

**Latihan dan Checkpoint:** Pilih tipe `SystemClock`, baca halamannya, dan tulis dari nol sebuah jam tanpa menyalin contoh. *Checkpoint:* tunjukkan di halaman referensi mana Anda mengetahui sebuah properti bersifat `readonly`.

**Sumber Referensi:** [Qt: QML dan JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-topic.html) · [Qt: Animasi](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html) · [Referensi tipe Quickshell](https://quickshell.org/docs/)

---

## Fase 1 — Dasar Quickshell: Shell Pertama Anda

**Level:** Pemula–Menengah · **Estimasi:** 5 minggu · **Prasyarat:** Fase 0 selesai.

### Modul 1.1 — Instalasi dan Struktur Konfigurasi

**Deskripsi Konkret:** Memasang Quickshell di Arch (stabil atau `-git`), memahami struktur direktori konfigurasi, dan menjalankan shell pertama dengan *hot reload*.

**Analogi:** Setiap folder konfigurasi adalah satu “profil” shell yang berdiri sendiri; Anda bisa menyimpan beberapa profil dan menjalankan yang Anda butuhkan.

**Konsep Dasar dan Filosofi:** Quickshell mencari subfolder `quickshell` di `$XDG_CONFIG_HOME` dan di setiap path `$XDG_CONFIG_DIRS` (mis. `/etc/xdg/quickshell`, jalur yang dipakai paket sistem). Subfolder yang berisi `shell.qml` dianggap satu konfigurasi, sehingga bar dan lockscreen dapat berjalan sebagai instance terpisah (**modular**). Quickshell melacak instance yang berjalan dan menguncinya agar tidak saling bentrok; ini mekanisme anti-duplikasi, **bukan batas keamanan**.

**Sintaks Dasar/Contoh:**

```bash
sudo pacman -S quickshell          # versi stabil dari repositori resmi Arch
# alternatif: quickshell-git (AUR) — audit PKGBUILD dulu (Modul 0.1); dapat rusak saat Qt diperbarui
quickshell --version
```

```text
~/.config/quickshell/
├── shell.qml          # konfigurasi default
├── bar/shell.qml      # konfigurasi bernama 'bar'
└── lock/shell.qml     # konfigurasi bernama 'lock'
```

```bash
quickshell -c bar                  # jalankan konfigurasi bernama
quickshell -p /path/custom.qml     # jalankan berkas atau folder QML langsung
qs list                            # daftar instance yang sedang berjalan
```

**Terminologi Kunci:**

- **Config:** folder bernama di dalam `~/.config/quickshell/` yang berisi `shell.qml`.
- **`shell.qml`:** titik masuk (entry point) setiap konfigurasi.
- **Hot reload:** Quickshell memantau berkas dan memuat ulang otomatis saat disimpan.
- **Instance:** satu proses Quickshell yang sedang berjalan; `qs` adalah singkatan dari `quickshell`.

**Daftar Isi:**

1. Stabil vs `-git` beserta risikonya.
2. Struktur `~/.config/quickshell/` dan `$XDG_CONFIG_DIRS`.
3. Menjalankan dan memilih konfigurasi (`-c`, `-p`).
4. Hot reload dan alur kerja pengembangan.
5. Instance dan penguncian (`qs list`) — dan mengapa itu bukan keamanan.

**Latihan dan Checkpoint:** Jalankan `hello.qml` dari Modul 0.2, lalu buat dua konfigurasi bernama berbeda. *Checkpoint:* jelaskan perbedaan `-c` dan `-p`, dan mengapa penguncian instance tidak melindungi Anda dari konfigurasi berbahaya.

**Sumber Referensi:** [Dokumentasi Quickshell](https://quickshell.org/docs/) (Install & Setup, Introduction) · [Repositori utama](https://git.outfoxxed.me/quickshell/quickshell) · [Mirror GitHub](https://github.com/quickshell-mirror/quickshell)

---

### Modul 1.2 — PanelWindow, Variants, Process, dan SystemClock

**Deskripsi Konkret:** Membuat bar yang tampil di **setiap monitor**, menampilkan jam dengan `SystemClock`, dan berinteraksi dengan sistem lewat `Process` (sekali jalan maupun streaming).

**Analogi:** `Variants` adalah mesin fotokopi: satu rancangan bar diperbanyak otomatis untuk setiap layar yang tersambung.

**Konsep Dasar dan Filosofi:** `PanelWindow` memakai layer-shell untuk menempel di tepi layar. `Variants` membuat satu instance per elemen model (di sini: `Quickshell.screens`) dan menyesuaikan diri saat monitor dicabut atau dipasang. `Process` memberi kontrol penuh tanpa C++, tetapi **proses anak mewarisi seluruh lingkungan Anda** kecuali dibersihkan; di situlah *least privilege* dimulai. Untuk data yang sudah disediakan Quickshell (waktu, baterai, volume), pakai modulnya, bukan memanggil program berulang-ulang.

**Sintaks Dasar/Contoh:**

```qml
// shell.qml — bar multi-monitor dengan jam
import Quickshell
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property var modelData
            screen: modelData
            anchors { top: true; left: true; right: true }
            implicitHeight: 30
            color: 'transparent'

            SystemClock { id: clock; precision: SystemClock.Seconds }

            Text {
                anchors.centerIn: parent
                color: 'white'
                text: Qt.formatDateTime(clock.date, 'HH:mm:ss')
            }
        }
    }
}
```

```qml
// Process: sekali jalan dan streaming per baris
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    property string nowPlaying: ''

    Process {                                   // streaming: proses panjang, satu event per baris
        command: ['playerctl', '--follow', 'metadata', '--format', '{{title}}']
        running: true
        stdout: SplitParser { onRead: data => nowPlaying = data }
    }

    Process {                                   // sekali jalan, lingkungan dibersihkan
        command: ['cat', '/proc/loadavg']
        clearEnvironment: true                  // tanpa ini, environment induk TETAP diwariskan
        environment: ({ PATH: '/usr/bin' })     // hanya variabel ini yang diteruskan
        running: true
        stdout: StdioCollector { onStreamFinished: console.log(this.text.trim()) }
    }
}
```

> Untuk perintah satu kali yang tidak perlu dipantau (dan boleh hidup lebih lama dari shell), gunakan `Quickshell.execDetached(['notify-send', 'halo'])`.

**Terminologi Kunci:**

- **`PanelWindow`:** window layer-shell yang menempel di tepi layar dan dapat memesan ruang.
- **`Variants`:** membuat satu instance kerangka per elemen model; pola standar multi-monitor.
- **`SystemClock`:** sumber waktu bawaan yang efisien; mengganti polling `date` setiap detik.
- **`Process`:** menjalankan program eksternal; `command` adalah daftar argumen, bukan satu string shell.
- **`StdioCollector` / `SplitParser`:** mengumpulkan seluruh keluaran saat proses selesai / membaca per baris saat proses berjalan.
- **`clearEnvironment`:** membuang lingkungan induk sebelum `environment` diterapkan (bawaan: `false`).

**Daftar Isi:**

1. `PanelWindow`, anchoring, dan `color: 'transparent'`.
2. `Variants` dan `Quickshell.screens`.
3. `SystemClock` vs polling.
4. `Process`: `command`, `running`, `stdout`, `stdin`, `environment`, `clearEnvironment`.
5. `StdioCollector` vs `SplitParser`; `execDetached`.
6. Menjalankan perintah dengan hak minimal.

**Latihan dan Checkpoint:** Bangun bar dengan jam dan load average di setiap monitor (uji dengan monitor virtual atau VM bermonitor ganda). *Checkpoint:* jelaskan mengapa `environment: ({ PATH: ... })` saja belum menghapus variabel rahasia, dan kapan memilih `SplitParser`.

**Sumber Referensi:** [Process](https://quickshell.org/docs/types/Quickshell.Io/Process) · panduan *Introduction* (Creating Windows, Running a Process) di [quickshell.org/docs](https://quickshell.org/docs/)

**Visualisasi:**

```text
Quickshell.screens = [ DP-1, HDMI-A-1 ]
        │  Variants
        ├──► PanelWindow (screen = DP-1)
        └──► PanelWindow (screen = HDMI-A-1)
```

---

### Modul 1.3 — Komponen Reusable, Singleton, dan Impor

**Deskripsi Konkret:** Memecah shell menjadi komponen kecil (berkas `.qml` terpisah) dan memakai **singleton** untuk state global yang statis, seperti tema.

**Analogi:** Komponen adalah batu bata Lego bernama; singleton adalah papan pengumuman tunggal yang dibaca semua orang.

**Konsep Dasar dan Filosofi:** Prinsip **modular** menuntut pemisahan concern. Nama berkas berawalan huruf besar menjadi nama tipe (`Clock.qml` → `Clock`). Singleton cocok untuk nilai global yang *statis* (warna, ukuran), bukan untuk menyembunyikan ketergantungan antarlayanan; ketergantungan dinamis sebaiknya dikirim eksplisit lewat properti (dibahas di Modul 3.1). Quickshell menyediakan impor relatif terhadap root shell dengan awalan `qs.` (mis. `import qs.services`) dan setahu saya tidak mewajibkan `qmldir` manual untuk singleton; **verifikasi di panduan resmi versi Anda**. Impor jenis ini juga membantu LSP menyelesaikan tipe (pastikan `.qmlls.ini` ada, Modul 1.4).

**Sintaks Dasar/Contoh:**

```qml
// services/Theme.qml
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color background: '#1e1e2e'
    readonly property color foreground: '#cdd6f4'
    readonly property int barHeight: 30
}
```

```qml
// components/Clock.qml
import QtQuick
import qs.services

Text {
    property string format: 'HH:mm'
    color: Theme.foreground
}
```

```qml
// shell.qml (cuplikan)
import qs.components
// ...
Clock { format: 'HH:mm:ss' }
```

**Terminologi Kunci:**

- **Komponen reusable:** berkas `.qml` yang mendefinisikan tipe baru; dapat diparameterisasi lewat properti.
- **Singleton:** satu instance global, dideklarasikan dengan `pragma Singleton`.
- **Impor `qs.`:** impor folder relatif terhadap root shell.
- **`qmldir`:** berkas pendaftaran modul Qt standar.

**Daftar Isi:**

1. Berkas komponen dan penamaan tipe.
2. Properti dan signal pada komponen.
3. `pragma Singleton` dan tipe `Singleton`.
4. Impor `qs.` dan struktur folder.
5. Kapan singleton tepat, kapan properti eksplisit lebih baik.

**Latihan dan Checkpoint:** Pindahkan jam dari Modul 1.2 menjadi komponen `Clock` dengan properti `format`, dan warna dari singleton `Theme`. *Checkpoint:* beri satu contoh nilai yang pantas jadi singleton dan satu yang tidak.

**Sumber Referensi:** Panduan *Introduction* (Reusable Components, Singletons) di [quickshell.org/docs](https://quickshell.org/docs/) · [Qt: Singleton dan direktori impor](https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html)

---

### Modul 1.4 — Debugging, Logging, LSP, dan Autostart

**Deskripsi Konkret:** Menemukan dan memperbaiki galat sendiri, menyalakan LSP di editor, dan menjalankan shell otomatis saat sesi dimulai dengan pengawasan (restart saat crash).

**Analogi:** Log adalah kotak hitam pesawat; autostart dengan supervisi adalah teknisi jaga yang menyalakan ulang mesin bila mati.

**Konsep Dasar dan Filosofi:** Penguasaan berarti mampu mendiagnosis sendiri. Mulai dari log Quickshell, lalu linting statis, lalu `console.log`, lalu debugger. Dari sisi keamanan, log bisa memuat path, keluaran proses, dan data pribadi: **jangan mencetak kredensial atau input sensitif**, dan periksa isi log sebelum membagikannya.

**Sintaks Dasar/Contoh:**

```bash
touch ~/.config/quickshell/my-shell/.qmlls.ini    # Quickshell mengisinya; aktifkan qmlls di editor
qs log                                            # log instance yang sedang berjalan
quickshell -c my-shell -v                         # lebih rinci (cek quickshell --help)
/usr/lib/qt6/bin/qmllint shell.qml                # linting statis
```

```ini
# ~/.config/systemd/user/quickshell.service
[Unit]
Description=Quickshell
PartOf=graphical-session.target
After=graphical-session.target

[Service]
ExecStart=/usr/bin/quickshell -c my-shell
Restart=on-failure
NoNewPrivileges=yes

[Install]
WantedBy=graphical-session.target
```

```bash
systemctl --user enable --now quickshell.service
journalctl --user -u quickshell -f
```

> Alternatif tanpa systemd: Hyprland `exec-once = quickshell -c my-shell`; Sway `exec quickshell -c my-shell`. `graphical-session.target` hanya aktif bila compositor mengaktifkannya (mis. lewat `uwsm`).

**Terminologi Kunci:**

- **LSP (Language Server Protocol):** layanan yang memberi editor fitur pintar (autocomplete, galat) untuk bahasa tertentu; untuk QML bernama `qmlls`.
- **Linting:** pemeriksaan statis kode tanpa menjalankannya (`qmllint`).
- **Unit systemd (user):** deskripsi layanan yang dijalankan dan diawasi per pengguna.
- **Crash handler:** mekanisme Quickshell yang menangkap crash dan menyimpan laporan.

**Daftar Isi:**

1. Membaca log (`qs log`) dan tingkat verbositas.
2. `qmllint` dan `.qmlls.ini` untuk LSP.
3. `console.log`, inspeksi nilai, dan `gdb` untuk crash.
4. Autostart: `exec-once`/`exec` vs unit `systemd --user`.
5. Kebersihan log (anonimitas) dan pemulihan saat crash.

**Latihan dan Checkpoint:** Sengaja buat satu galat sintaks dan satu galat runtime, temukan keduanya lewat log dan `qmllint`; jadikan shell Anda layanan systemd. *Checkpoint:* matikan proses Quickshell dengan `kill` dan buktikan ia hidup kembali.

**Sumber Referensi:** Panduan *Language Server* dan *Debugging* di [quickshell.org/docs](https://quickshell.org/docs/) · [Arch Wiki: systemd/User](https://wiki.archlinux.org/title/Systemd/User) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)

---

## Fase 2 — Integrasi Sistem: Wayland, Compositor, dan Layanan Desktop

**Level:** Menengah · **Estimasi:** 8–10 minggu · **Prasyarat:** Fase 1 selesai.

### Modul 2.1 — Wayland Layer-Shell, Fokus Keyboard, dan Transparansi

**Deskripsi Konkret:** Memahami protokol `wlr-layer-shell`: layer, anchor, zona eksklusif, dan **mode fokus keyboard**, fondasi shell yang sepenuhnya dikendalikan keyboard.

**Analogi:** Layer-shell adalah denah gedung dengan lantai tetap (background, bottom, top, overlay); panel “menyewa” tepi lantai tertentu sehingga jendela lain tidak menimpanya.

**Konsep Dasar dan Filosofi:** Panel tidak punya dekorasi dan dapat memesan ruang. Lapisan ditentukan lewat attached property `WlrLayershell` (modul `Quickshell.Wayland`). Pada Quickshell, `exclusionMode` biasanya mengatur ruang yang dipesan secara otomatis dari tinggi dan anchor. Mode fokus keyboard menentukan apakah jendela Anda menerima ketikan: `None`, `OnDemand`, atau `Exclusive`. **Peringatan:** `Exclusive` mengunci keyboard untuk jendela itu, tetapi **bukan** mekanisme kunci sesi yang aman (lihat Modul 4.2).

**Sintaks Dasar/Contoh:**

```qml
import Quickshell
import Quickshell.Wayland

PanelWindow {
    anchors { top: true; left: true; right: true }
    implicitHeight: 30
    exclusionMode: ExclusionMode.Auto            // ruang dipesan otomatis
    WlrLayershell.layer: WlrLayer.Top            // Background | Bottom | Top | Overlay
    WlrLayershell.namespace: 'my-shell-bar'      // dipakai aturan layer di compositor
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
}
```

```bash
wayland-info | grep layer_shell    # compositor menyediakan zwlr_layer_shell_v1?
hyprctl layers                     # (Hyprland) daftar layer surface yang aktif
```

**Terminologi Kunci:**

- **`zwlr_layer_shell_v1`:** protokol Wayland untuk layer surface (panel, overlay).
- **Exclusive zone / `exclusionMode`:** ruang yang dipesan agar jendela lain tidak menimpa panel.
- **`WlrKeyboardFocus`:** mode fokus keyboard layer surface: `None`, `OnDemand`, `Exclusive`.
- **Namespace:** nama layer yang dipakai compositor untuk aturan khusus (mis. blur).

**Daftar Isi:**

1. Arsitektur Wayland dan peran compositor.
2. Layer, anchor, `exclusionMode`.
3. Fokus keyboard layer surface dan penanganan tombol (`Keys.onPressed`; lihat Modul 2.5).
4. `PanelWindow` vs `FloatingWindow` vs `PopupWindow`.
5. Transparansi dan aturan layer compositor (blur latar).
6. Debugging dengan `wayland-info` dan alat compositor.

**Latihan dan Checkpoint:** Buat overlay yang muncul di layer `Overlay` dan menerima ketikan hanya saat dipanggil. *Checkpoint:* jelaskan mengapa `Exclusive` tidak boleh dipakai sebagai lockscreen.

**Sumber Referensi:** [wlr-layer-shell](https://wayland.app/protocols/wlr-layer-shell-unstable-v1) · [WlrKeyboardFocus](https://quickshell.org/docs/types/Quickshell.Wayland/WlrKeyboardFocus)

**Visualisasi:**

```text
Overlay   ─ notifikasi, launcher
Top       ─ bar/panel          (jendela aplikasi di bawah ini)
Bottom    ─ widget desktop
Background─ wallpaper
```

---

### Modul 2.2 — IPC Compositor: Hyprland, Sway/i3, `IpcHandler`, dan Pintasan Global

**Deskripsi Konkret:** Membaca state workspace dan monitor, mengirim perintah ke compositor, dan **mengekspos aksi shell Anda ke keyboard** lewat `IpcHandler` dan pintasan global.

**Analogi:** IPC adalah interkom antar ruangan: shell dan compositor saling menelepon tanpa perlu membaca teks mentah dari layar.

**Konsep Dasar dan Filosofi:** Hyprland dan Sway menyediakan socket IPC. Quickshell membungkusnya: `Quickshell.Hyprland` untuk Hyprland dan **`Quickshell.I3` untuk i3 dan Sway** (tidak ada modul bernama `Quickshell.Sway`). Arah sebaliknya, dari keyboard ke shell, memakai `IpcHandler` + `qs ipc call`, atau `GlobalShortcut` pada Hyprland. Inilah jantung **super kontrol berbasis keyboard**.

**Sintaks Dasar/Contoh:**

```qml
// Hyprland: state reaktif dan perintah lewat modul
import Quickshell.Hyprland
Text { text: Hyprland.focusedWorkspace?.name ?? '?'; color: 'white' }
// Hyprland.dispatch('workspace 2')
```

```qml
// i3/Sway
import Quickshell.I3
// I3.dispatch('workspace 2')       // menjalankan perintah i3/Sway
```

```qml
// Mengekspos aksi ke keyboard/CLI
import Quickshell.Io

IpcHandler {
    target: 'bar'
    function toggle(): void { bar.visible = !bar.visible }   // 'bar' = id PanelWindow Anda
    function isVisible(): bool { return bar.visible }
}
```

```bash
qs ipc show                  # daftar target dan fungsi yang diekspos
qs ipc call bar toggle       # panggil dari terminal atau keybind
```

```text
# hyprland.conf
bind = SUPER, B, exec, qs ipc call bar toggle
# sway config
bindsym $mod+b exec qs ipc call bar toggle
```

```qml
// Hyprland: pintasan global langsung ke shell
import Quickshell.Hyprland
GlobalShortcut {
    appid: 'quickshell'; name: 'launcher'
    onPressed: launcher.visible = !launcher.visible
}
// hyprland.conf: bind = SUPER, space, global, quickshell:launcher
```

**Terminologi Kunci:**

- **IPC (Inter-Process Communication):** pertukaran data antar proses; Hyprland dan Sway memakai socket Unix.
- **`Hyprland` / `I3` (singleton):** layanan QML yang memberi state dan dispatcher compositor.
- **`IpcHandler`:** objek QML yang mengekspos fungsi bertipe agar dapat dipanggil dengan `qs ipc call`.
- **`GlobalShortcut`:** pintasan global lewat protokol khusus Hyprland; Sway tidak punya padanannya, gunakan `IpcHandler`.

**Daftar Isi:**

1. Socket IPC Hyprland: event dan dispatcher.
2. `Quickshell.Hyprland`: workspace, monitor, jendela.
3. `Quickshell.I3` untuk Sway/i3 dan `SWAYSOCK`.
4. `IpcHandler` dan `qs ipc`.
5. `GlobalShortcut` dan keybind compositor.

**Latihan dan Checkpoint:** Ekspos tiga aksi (`toggle`, `show`, `hide`) lewat `IpcHandler` dan pasang keybind untuk masing-masing. *Checkpoint:* jelaskan mengapa fungsi `IpcHandler` wajib memiliki tipe parameter dan tipe kembalian yang eksplisit.

**Sumber Referensi:** [Hyprland IPC](https://wiki.hyprland.org/IPC/) · [Quickshell.I3](https://quickshell.org/docs/types/Quickshell.I3/I3) · panduan *IPC* di [quickshell.org/docs](https://quickshell.org/docs/)

---

### Modul 2.3 — Layanan Desktop: PipeWire, MPRIS, UPower, dan Bluetooth

**Deskripsi Konkret:** Mengintegrasikan shell dengan audio (PipeWire), pemutar media (MPRIS), baterai (UPower), dan Bluetooth, memakai modul QML siap pakai tanpa boilerplate D-Bus.

**Analogi:** Setiap layanan adalah pusat informasi yang sudah ada; modul Quickshell adalah loket yang menerjemahkan jawabannya ke bahasa QML.

**Konsep Dasar dan Filosofi:** Quickshell menjembatani QML dengan D-Bus dan PipeWire sehingga shell **monolitik** dalam fungsi tetapi **modular** dalam kode. Tiga jebakan akurasi: (1) properti audio node PipeWire **tidak valid sebelum node “di-bind”** lewat `PwObjectTracker`; (2) skala nilai (volume, persentase baterai) harus diverifikasi, jangan diasumsikan; (3) properti MPRIS bernama `trackTitle`, bukan `track.title`.

**Sintaks Dasar/Contoh:**

```qml
// PipeWire: kontrol volume
import QtQuick.Controls
import Quickshell.Services.Pipewire

Item {
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: [sink] }           // WAJIB: tanpa ini properti audio tidak valid
    Slider {
        from: 0; to: 1.0                          // skala float (umumnya 1.0 = 100%); uji dengan console.log
        value: sink?.audio?.volume ?? 0
        onMoved: if (sink?.audio) sink.audio.volume = value
    }
}
```

```qml
// MPRIS dan UPower
import Quickshell.Services.Mpris
import Quickshell.Services.UPower

Text { text: Mpris.players.values[0]?.trackTitle || 'Tidak ada media'; color: 'white' }
Text {
    readonly property var bat: UPower.displayDevice
    text: Math.round((bat?.percentage ?? 0) * 100) + '%'   // verifikasi skala 0–1 dengan console.log
    color: 'white'
}
```

```qml
// Bluetooth (modul terpisah dari Services.*; periksa referensi versi Anda)
import Quickshell.Bluetooth
Text { text: Bluetooth.defaultAdapter?.enabled ? 'BT aktif' : 'BT mati'; color: 'white' }
```

> **Keselamatan:** batasi volume maksimum di kode (mis. `Math.min(value, 1.0)`); nilai salah skala dapat memicu volume berlebihan.

**Terminologi Kunci:**

- **D-Bus:** sistem pesan antar program di Linux; dipakai MPRIS, UPower, BlueZ, dan banyak layanan desktop.
- **PipeWire:** server multimedia modern; `Pipewire.defaultAudioSink` adalah keluaran audio bawaan.
- **`PwObjectTracker`:** mengikat objek PipeWire agar propertinya valid.
- **MPRIS:** spesifikasi D-Bus untuk mengontrol pemutar media.
- **UPower:** layanan informasi daya dan baterai; `UPower.displayDevice` adalah perangkat ringkasan.
- **BlueZ:** stack Bluetooth Linux.

**Daftar Isi:**

1. Arsitektur D-Bus dan lapisan integrasi layanan Quickshell.
2. PipeWire: node, `PwObjectTracker`, volume, routing.
3. MPRIS: player, `trackTitle`, kontrol pemutaran.
4. UPower: baterai dan profil daya.
5. Bluetooth: adapter dan perangkat.
6. Memverifikasi skala dan nilai kosong (`?.`, `??`).

**Latihan dan Checkpoint:** Buat widget volume dengan tombol mute dan batas maksimum, serta widget media yang menampilkan judul dan tombol putar/jeda. *Checkpoint:* jelaskan apa yang terjadi bila `PwObjectTracker` dihilangkan, dan bagaimana Anda memastikan skala volume.

**Sumber Referensi:** [Pipewire (Quickshell)](https://quickshell.org/docs/types/Quickshell.Services.Pipewire/Pipewire) · [MprisPlayer](https://quickshell.org/docs/types/Quickshell.Services.Mpris/MprisPlayer) · [UPowerDevice](https://quickshell.org/docs/types/Quickshell.Services.UPower/UPowerDevice) · [Dokumentasi PipeWire](https://docs.pipewire.org/) · [Spesifikasi MPRIS](https://specifications.freedesktop.org/mpris-spec/latest/) · [UPower](https://upower.freedesktop.org/docs/)

---

### Modul 2.4 — Notifikasi, System Tray, dan Launcher

**Deskripsi Konkret:** Membangun tiga komponen desktop yang paling sering dibutuhkan: *notification daemon*, area *system tray*, dan *launcher* aplikasi berbasis keyboard.

**Analogi:** Notification daemon adalah resepsionis yang menerima semua pesan masuk; tray adalah papan ikon program latar belakang; launcher adalah mesin pencari yang hanya mengenal aplikasi terpasang.

**Konsep Dasar dan Filosofi:** Ketiganya berbicara dengan protokol desktop (D-Bus: `org.freedesktop.Notifications`, StatusNotifierItem, berkas `.desktop`). Quickshell membungkusnya menjadi tipe QML. Karena hanya satu program yang boleh menjadi notification daemon, **hentikan daemon lama** (dunst, mako) sebelum menjalankan milik Anda. Aplikasi yang diluncurkan mewarisi lingkungan sesi, jadi shell sebaiknya **tidak menyimpan rahasia** di environment-nya.

**Sintaks Dasar/Contoh:**

```qml
// Notifikasi: shell Anda menjadi notification daemon
import Quickshell.Services.Notifications

NotificationServer {
    id: server
    keepOnReload: true
    bodySupported: true
    actionsSupported: true
    imageSupported: true
    onNotification: notif => { notif.tracked = true }    // tanpa 'tracked', notifikasi dibuang
}
// tampilkan: Repeater { model: server.trackedNotifications; delegate: ... modelData.summary / modelData.body }
```

```qml
// System tray
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Row {
    Repeater {
        model: SystemTray.items
        delegate: IconImage {
            required property var modelData
            source: modelData.icon
            implicitSize: 18
            MouseArea { anchors.fill: parent; onClicked: modelData.activate() }
        }
    }
}
```

```qml
// Launcher: filter DesktopEntries
import Quickshell
import QtQuick

Item {
    property string query: ''
    ScriptModel {
        id: results
        values: DesktopEntries.applications.values
            .filter(e => e.name.toLowerCase().includes(query.toLowerCase()))
            .slice(0, 8)
    }
    ListView {
        anchors.fill: parent
        model: results
        delegate: Text { required property var modelData; text: modelData.name; color: 'white' }
    }
    // Enter: results.values[0]?.execute()
}
```

```bash
busctl --user list | grep -i Notifications     # siapa yang saat ini memegang nama notifikasi?
```

> Nama properti tiap tipe dapat berubah antarversi; cocokkan dengan halaman referensi `NotificationServer`, `SystemTrayItem`, dan `DesktopEntry`.

**Terminologi Kunci:**

- **Notification daemon:** program yang menerima dan menampilkan notifikasi desktop.
- **StatusNotifierItem (tray):** protokol D-Bus tempat aplikasi mendaftarkan ikon latar belakangnya.
- **Desktop entry (`.desktop`):** berkas yang mendeskripsikan aplikasi terpasang (nama, ikon, perintah).
- **`ScriptModel`:** model yang nilainya dihitung dari ekspresi JavaScript dan diperbarui efisien.

**Daftar Isi:**

1. `NotificationServer`: pelacakan, aksi, dan urgensi.
2. Tampilan notifikasi (popup, riwayat) dan batas waktu.
3. `SystemTray`: ikon, aksi, dan menu.
4. `DesktopEntries`, `ScriptModel`, dan pencarian fuzzy sederhana.
5. Peluncuran aplikasi dan lingkungan yang diwariskan.

**Latihan dan Checkpoint:** Buat popup notifikasi yang hilang otomatis dan launcher yang meluncurkan aplikasi dengan Enter. *Checkpoint:* kirim `notify-send halo` dan tunjukkan notifikasinya tampil di shell Anda, bukan di daemon lain.

**Sumber Referensi:** Modul `Quickshell.Services.Notifications`, `Quickshell.Services.SystemTray`, dan tipe `DesktopEntries` di [quickshell.org/docs](https://quickshell.org/docs/) · [Spesifikasi Desktop Notifications](https://specifications.freedesktop.org/notification-spec/latest/) · [Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/latest/)

---

### Modul 2.5 — Navigasi Keyboard-Driven dan Persistensi State

**Deskripsi Konkret:** Membangun antarmuka yang bisa dioperasikan penuh dengan keyboard (fokus, pintasan, mode ala vim) dan menyimpan preferensi agar bertahan setelah restart.

**Analogi:** Fokus keyboard adalah “siapa yang sedang memegang mikrofon”; hanya satu elemen yang menerima ketikan pada satu waktu.

**Konsep Dasar dan Filosofi:** Di QML, elemen yang berfokus menerima event `Keys.*`. Pada layer-shell, jendela hanya menerima ketikan bila mode fokusnya mengizinkan (Modul 2.1). Prinsipnya: **minta fokus eksklusif hanya selama launcher terbuka, lepaskan saat ditutup.** Untuk persistensi, `FileView` membaca/menulis berkas dan `JsonAdapter` memetakan JSON ke properti; simpan **preferensi saja, bukan rahasia**.

**Sintaks Dasar/Contoh:**

```qml
// Launcher overlay yang dikendalikan keyboard
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: launcher
    visible: false
    implicitWidth: 480; implicitHeight: 320
    color: 'transparent'
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: launcher.visible = false
        Keys.onPressed: event => {
            if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_J) {
                list.incrementCurrentIndex(); event.accepted = true
            }
        }
        ListView {
            id: list
            anchors.fill: parent
            model: ['satu', 'dua', 'tiga']
            delegate: Text { required property string modelData; text: modelData; color: 'white' }
        }
    }
}
```

```qml
// Persistensi: simpan dan muat preferensi
import Quickshell
import Quickshell.Io

FileView {
    path: Quickshell.statePath('settings.json')
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    adapter: JsonAdapter {
        property bool barVisible: true
        property string theme: 'dark'
    }
}
```

**Terminologi Kunci:**

- **Fokus (`focus`):** elemen yang saat ini menerima event keyboard.
- **`Keys.onPressed`:** handler untuk setiap tombol; set `event.accepted = true` agar tidak diteruskan.
- **Mode modal:** pola ala vim, di mana satu tombol berarti hal berbeda di mode berbeda (mis. `normal` vs `insert`), disimpan sebagai properti `mode`.
- **`FileView` / `JsonAdapter`:** membaca-menulis berkas / memetakan JSON ke properti QML.

**Daftar Isi:**

1. Rantai fokus dan `Keys.*`.
2. Mode fokus layer-shell dan siklus buka-tutup.
3. Pintasan satu jendela vs global (`GlobalShortcut`, `IpcHandler`).
4. Mode modal ala vim.
5. `FileView`, `JsonAdapter`, dan `Quickshell.statePath`.
6. Izin berkas dan apa yang tidak boleh disimpan.

**Latihan dan Checkpoint:** Tambahkan mode `normal`/`insert` ke launcher (`j`/`k` bergerak, `i` mengetik) dan simpan tema terakhir ke `settings.json`. *Checkpoint:* jelaskan mengapa fokus eksklusif harus dilepas saat jendela tertutup.

**Sumber Referensi:** [Qt: Keyboard focus in Qt Quick](https://doc.qt.io/qt-6/qtquick-input-focus.html) · tipe `FileView`, `JsonAdapter`, dan `WlrLayershell` di [quickshell.org/docs](https://quickshell.org/docs/)

---

## Fase 3 — Arsitektur Modular dan Manajemen State

**Level:** Mahir · **Estimasi:** 6–7 minggu · **Prasyarat:** Fase 2 selesai.

### Modul 3.1 — Arsitektur Shell yang Skalabel

**Deskripsi Konkret:** Merancang arsitektur yang bisa tumbuh: layanan (services) terpisah dari komponen UI dan konfigurasi, dengan arah dependensi yang jelas dan dapat diaudit.

**Analogi:** Dapur restoran: pemasok (sistem) → koki (services) → pelayan (UI). Pelayan tidak berbelanja sendiri ke pasar.

**Konsep Dasar dan Filosofi:** Shell kompleks mudah menjadi gumpalan sulit dirawat. Aturan inti: **UI → services → sistem**. Hanya `services/` yang mengimpor modul sistem (`Quickshell.Services.*`, `Process`); komponen UI hanya membaca properti service. Hasilnya: satu titik audit keamanan, satu titik untuk mengganti implementasi, dan UI yang mudah diuji. Singleton service boleh dipakai langsung oleh UI selama dependensinya searah.

**Sintaks Dasar/Contoh:**

```text
~/.config/quickshell/my-shell/
├── shell.qml            # entry point: merakit modul
├── services/            # singleton: Audio.qml, Battery.qml, Workspaces.qml
├── components/          # UI reusable: Clock.qml, VolumeSlider.qml
├── modules/             # fitur utuh: bar/, launcher/, notifications/, lock/
└── config/              # Theme.qml, Settings.qml
```

```qml
// services/Audio.qml — satu-satunya tempat yang menyentuh PipeWire
pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    function setVolume(v: real): void {
        if (sink?.audio) sink.audio.volume = Math.max(0, Math.min(v, 1))
    }
    PwObjectTracker { objects: [sink] }
}
```

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

**Terminologi Kunci:**

- **`ShellRoot`:** elemen akar opsional konfigurasi Quickshell.
- **Service singleton:** singleton QML yang membungkus layanan sistem dan mengekspos state reaktif.
- **Arah dependensi:** aturan siapa boleh mengimpor siapa; di sini UI → services → sistem.
- **Dependency injection:** menyerahkan dependensi lewat properti, bukan memanggilnya secara global.

**Daftar Isi:**

1. Struktur direktori yang skalabel.
2. `ShellRoot` dan siklus hidup.
3. Pola service singleton dan arah dependensi.
4. Kapan memakai injeksi properti dibanding singleton.
5. Mempelajari shell open-source (mis. Caelestia, Noctalia): **baca dan audit kodenya sebelum menjalankannya.**

**Latihan dan Checkpoint:** Refaktor bar dari Fase 2 sehingga hanya `services/` yang mengimpor `Quickshell.Services.*`. *Checkpoint:* tunjukkan bahwa mengganti sumber audio hanya mengubah satu berkas.

**Sumber Referensi:** [ShellRoot](https://quickshell.org/docs/types/Quickshell/ShellRoot) · [Qt: QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html)

**Visualisasi:**

```text
UI (components, modules) ──baca properti──► services (singleton) ──► modul sistem / Process
                  ▲ tidak boleh langsung ke sistem ✕
```

---

### Modul 3.2 — Manajemen State dan Reaktivitas Lanjutan

**Deskripsi Konkret:** Menguasai binding, signal, dan state machine sederhana untuk UI yang sepenuhnya reaktif, serta menghindari binding loop dan performa buruk.

**Analogi:** Binding loop seperti dua orang yang masing-masing menunggu yang lain bicara lebih dulu: tidak ada yang pernah selesai.

**Konsep Dasar dan Filosofi:** Reaktivitas QML adalah kekuatan sekaligus jebakan. Anda harus memahami *mengapa* sebuah binding dihitung ulang, bukan sekadar menulisnya. Aturan praktis: **baca lewat binding, tulis lewat handler interaksi** (`onMoved`, `onClicked`), bukan lewat `onValueChanged` yang ikut terpicu saat nilai berubah dari luar.

**Sintaks Dasar/Contoh:**

```qml
// Binding kondisional
Binding { target: rect; property: 'color'; value: 'blue'; when: mouse.containsMouse }

// Connections (Qt 6): handler berbentuk fungsi
Connections {
    target: Audio
    function onVolumeChanged() { osd.show() }
}

// Hindari loop: tulis hanya saat pengguna menggeser
Slider { value: Audio.volume; onMoved: Audio.setVolume(value) }
```

```qml
// State machine sederhana
Rectangle {
    id: panel
    state: 'closed'
    states: [
        State { name: 'open';   PropertyChanges { target: panel; height: 200 } },
        State { name: 'closed'; PropertyChanges { target: panel; height: 0 } }
    ]
    transitions: Transition { NumberAnimation { properties: 'height'; duration: 150 } }
}
```

**Terminologi Kunci:**

- **Binding loop:** dua properti saling bergantung secara melingkar.
- **`Binding`:** elemen untuk binding kondisional atau sementara (`when`).
- **`Connections`:** merespons signal dari objek lain; di Qt 6 handler ditulis sebagai `function onNamaSignal() {}`.
- **State / Transition:** keadaan bernama dan animasi perpindahan antar keadaan.

**Daftar Isi:**

1. Siklus evaluasi binding.
2. Mendeteksi dan memperbaiki binding loop (cari peringatan di log).
3. `Binding` dan `Connections`.
4. `states` dan `transitions`.
5. Optimasi binding yang mahal.

**Latihan dan Checkpoint:** Sengaja buat binding loop pada slider, baca peringatannya di `qs log`, lalu perbaiki dengan `onMoved`. *Checkpoint:* jelaskan beda `onValueChanged` dan `onMoved` pada `Slider`.

**Sumber Referensi:** [Qt: Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [Qt: Best Practices for QML and Qt Quick](https://doc.qt.io/qt-6/qtquick-bestpractices.html)

---

### Modul 3.3 — Kualitas Kode: Linting, Pengujian Asap, dan Review

**Deskripsi Konkret:** Menjaga shell tetap benar dan aman seiring bertambahnya fitur: linting, uji asap (smoke test) di compositor headless, dan daftar periksa review.

**Analogi:** Seperti pemeriksaan sebelum penerbangan: tidak ada yang ditemukan bukan berarti aman, tetapi daftar periksa mencegah kesalahan yang sama berulang.

**Konsep Dasar dan Filosofi:** Karena konfigurasi adalah kode yang berhak penuh, kualitas adalah keamanan. Otomatiskan yang bisa diotomatiskan; sisanya masuk daftar periksa review.

**Sintaks Dasar/Contoh:**

```bash
#!/usr/bin/env bash
# Sketsa uji asap: sesuaikan nama socket dan jalur
set -euo pipefail
WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 sway -c /dev/null &
SWAY=$!; sleep 2
export WAYLAND_DISPLAY=wayland-1
timeout 10 quickshell -p ./my-shell > /tmp/qs.out 2>&1 || true
kill $SWAY
! grep -Ei 'error|fatal' /tmp/qs.out
```

**Daftar Periksa Review (setiap perubahan):**

- Apakah setiap `Process` memakai `clearEnvironment` dan perintah berbentuk daftar argumen?
- Apakah ada kredensial atau data pribadi yang bisa masuk ke log atau berkas state?
- Apakah dependensi hanya mengalir UI → services → sistem?
- Apakah ada binding loop atau polling yang bisa diganti modul bawaan?
- Apakah ada keadaan gagal yang membuat layar terkunci atau tak bisa dioperasikan?

**Terminologi Kunci:**

- **Smoke test:** uji cepat yang hanya memastikan program bisa menyala tanpa galat.
- **Headless:** berjalan tanpa layar fisik.
- **Regresi:** perilaku yang tadinya benar lalu rusak karena perubahan.

**Daftar Isi:**

1. `qmllint` dan kebijakan peringatan.
2. Uji asap di compositor headless.
3. Daftar periksa review keamanan.
4. Mencatat keputusan desain (catatan singkat per modul).

**Latihan dan Checkpoint:** Buat skrip uji asap dan hubungkan ke `git` hook atau CI (Modul 5.3). *Checkpoint:* tunjukkan satu galat yang tertangkap oleh skrip Anda sebelum sampai ke sesi utama.

**Sumber Referensi:** [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [Sway](https://github.com/swaywm/sway/wiki) (opsi headless wlroots)
