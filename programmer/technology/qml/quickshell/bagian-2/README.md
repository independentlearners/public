# Kurikulum Fase 1
### 🔍 Audit
**Temuan Audit:**

1. **Modul 1.1 — Ketidakjelasan `-p` vs `-c`**: Kurikulum sudah menyebutkan `-c` dan `-p`, tetapi tidak menjelaskan secara eksplisit bahwa `-p` menerima **file QML mentah** atau **direktori di luar XDG**, sedangkan `-c` hanya untuk **config bernama di dalam `$XDG_CONFIG_HOME/quickshell/`**. Ini perlu diperjelas karena merupakan sumber kebingungan umum.

2. **Modul 1.2 — `Variants` dan `delegate`**: Contoh yang diberikan menggunakan `model` dan `required property var modelData`, tetapi tidak menjelaskan bahwa `Variants` juga bisa menggunakan `delegate: Component { ... }` untuk kontrol lebih besar. Selain itu, properti `screen: modelData` perlu dijelaskan dalam konteks `ShellScreen`.

3. **Modul 1.3 — Singleton dan `qmldir`**: Kurikulum menyebutkan "setahu saya tidak mewajibkan `qmldir` manual untuk singleton; **verifikasi di panduan resmi**". Ini perlu diverifikasi: Quickshell **tidak memerlukan `qmldir` manual** untuk singleton dalam konfigurasi shell; `pragma Singleton` dan tipe `Singleton` sudah cukup. Namun, untuk modul QML yang didistribusikan sebagai library terpisah, `qmldir` mungkin diperlukan.

4. **Modul 1.4 — `qs log` vs `quickshell log`**: Perintah yang benar adalah `quickshell log` (atau `qs log` jika `qs` adalah alias/simlink). Kurikulum menulis `qs log` tanpa menjelaskan asal-usul alias tersebut. Perlu dicatat bahwa `qs` hanyalah nama pendek yang umum digunakan, bukan binary terpisah.

5. **Kekurangan yang Perlu Ditambahkan**:
   - **Poin keamanan `Process`**: Kurikulum sudah menyebut `clearEnvironment`, tetapi tidak membahas **sandboxing** lebih lanjut (misalnya, menjalankan proses dengan `bwrap` atau `systemd-run --scope` untuk isolasi).
   - **Penanganan error pada `Process`**: Tidak ada pembahasan tentang properti `onExited`, `onRunningChanged`, atau cara mendeteksi kegagalan proses.
   - **`Quickshell.execDetached`**: Sudah disebutkan, tetapi perlu dijelaskan kapan harus menggunakan ini vs `Process` (misalnya, untuk notifikasi yang tidak perlu dipantau).
   - **Manajemen state dengan `Quickshell.stateDir`**: Belum ada pembahasan tentang cara menyimpan state persisten antar-reload.

**Rekomendasi Pembaruan Kurikulum:**
- Tambahkan sub-poin di Modul 1.2: "6. Penanganan error dan lifecycle Process (`onExited`, `onRunningChanged`)."
- Tambahkan sub-poin di Modul 1.2: "7. `Quickshell.execDetached` vs `Process`: kapan memilih yang mana."
- Tambahkan sub-poin di Modul 1.3: "6. `Quickshell.stateDir` dan persistensi state antar-reload."
- Tambahkan sub-poin di Modul 1.4: "6. Sandboxing proses dengan `systemd-run --scope` atau `bwrap`."

Dengan audit ini, kita akan melanjutkan ke **Modul 1.1** dengan pemahaman yang lebih lengkap. Saya akan mengembangkan materi secara bertahap, dimulai dari Modul 1.1, dan mengonfirmasi untuk melanjutkan ke modul berikutnya.

---

# Fase 1 — Dasar Quickshell: Shell Pertama Anda

> *"Kontrol sejati lahir dari pemahaman, bukan dari sekadar mengetik perintah."*

## Modul 1.1 — Instalasi dan Struktur Konfigurasi

### 📋 Daftar Isi Internal

1. Stabil vs `-git`: filosofi dan risiko.
2. Struktur `$XDG_CONFIG_HOME/quickshell/` dan `$XDG_CONFIG_DIRS`.
3. Menjalankan konfigurasi: `-c` vs `-p`.
4. Hot reload: siklus pengembangan.
5. Instance dan penguncian: `qs list`, `--no-duplicate`.
6. Audit keamanan konfigurasi.

---

### 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **pintu masuk** ke seluruh ekosistem Quickshell. Di sini Anda tidak hanya belajar "cara menginstal", tetapi memahami **kontrak antara Quickshell dan sistem operasi** tentang di mana konfigurasi harus diletakkan, bagaimana instance dikelola, dan mengapa pemisahan konfigurasi menjadi kunci modularitas. Tanpa penguasaan modul ini, modul-modul berikutnya akan terasa seperti potongan kode yang tidak saling terhubung.

**Peran dalam kurikulum:** Modul 1.1 adalah **fondasi operasional**. Ia menyediakan peta direktori, mekanisme pemilihan konfigurasi, dan alat diagnostik dasar (`qs list`) yang akan Anda gunakan di setiap modul selanjutnya. Jika Modul 1.2 adalah "tubuh" shell, Modul 1.1 adalah "rumah" tempat tubuh itu tinggal.

---

### 2. Konsep Kunci & Filosofi Mendalam

#### 🧩 Filosofi Modularitas Quickshell

Bayangkan Quickshell sebagai **sebuah gedung apartemen**, bukan rumah tunggal. Setiap apartemen (config) memiliki pintu masuk sendiri (`shell.qml`), penghuni sendiri (instance), dan aturan sendiri. Anda bisa memiliki beberapa apartemen di gedung yang sama (`~/.config/quickshell/`) dan memilih apartemen mana yang ingin Anda tempati (`-c`). Filosofi ini memungkinkan:

- **Isolasi kegagalan**: Jika bar crash, lockscreen tetap berjalan karena mereka adalah instance terpisah.
- **Pengembangan bertahap**: Anda bisa mengembangkan `bar` tanpa mengganggu `lock`.
- **Distribusi**: Anda bisa membagikan satu config tanpa harus menyertakan seluruh dotfiles Anda.

#### 🔐 Penguncian Instance: Anti-Duplikasi, Bukan Keamanan

Quickshell melacak instance yang sedang berjalan dan **menguncinya** agar konfigurasi yang sama tidak dijalankan dua kali secara bersamaan. Ini adalah **mekanisme anti-duplikasi**, bukan **batas keamanan** (sandbox). Artinya:

- Penguncian mencegah Anda tidak sengaja menjalankan dua bar yang sama.
- Penguncian **tidak** mencegah konfigurasi berbahaya (misalnya, yang membaca `~/.ssh/id_rsa` dan mengirimkannya ke jaringan) untuk dijalankan **pertama kali**.
- Keamanan sejati harus datang dari **audit kode**, **least privilege**, dan **sandboxing proses**, bukan dari mekanisme penguncian Quickshell.

#### 📂 XDG Base Directory Specification

Quickshell mengikuti **XDG Base Directory Specification**, sebuah standar freedesktop.org yang mendefinisikan di mana aplikasi harus menyimpan file konfigurasi, data, dan cache. Ini bukan sekadar konvensi; ini adalah **kontrak sistem** yang memungkinkan:

- **Portabilitas**: Konfigurasi Anda tetap di `$HOME`, tidak tersebar di `/etc`.
- **Isolasi pengguna**: Setiap pengguna memiliki konfigurasinya sendiri.
- **Overriding sistem**: Administrator dapat menyediakan konfigurasi default di `/etc/xdg/quickshell/` yang bisa ditimpa pengguna di `~/.config/quickshell/`.

**Path resolution order** (dari prioritas tertinggi ke terendah):
1. `$XDG_CONFIG_HOME/quickshell/` (biasanya `~/.config/quickshell/`)
2. Setiap path di `$XDG_CONFIG_DIRS/quickshell/` (biasanya `/etc/xdg/quickshell/`)

Jika `shell.qml` ada di `$XDG_CONFIG_HOME/quickshell/` (base folder), maka subfolder **tidak dianggap** sebagai config terpisah. Ini adalah detail penting yang jarang dibahas: **kehadiran `shell.qml` di root `quickshell/` "menaungi" subfolder**.

---

### 3. Sintaks Dasar / Contoh Implementasi Inti

#### Instalasi Stabil vs `-git`

```bash
# ✅ Stabil (direkomendasikan untuk produksi)
sudo pacman -S quickshell

# ⚠️ Git (hanya jika Anda membutuhkan fitur terbaru)
# Audit PKGBUILD terlebih dahulu!
yay -S quickshell-git

# Verifikasi
quickshell --version
```

**Penjelasan kata per kata:**
- `sudo pacman -S quickshell`: `-S` adalah operasi sinkronisasi (install) di pacman. `quickshell` adalah nama paket di repositori resmi Arch.
- `yay -S quickshell-git`: `yay` adalah AUR helper. `quickshell-git` melacak **master branch** dan bisa **rusak saat Qt diperbarui** karena AUR tidak memiliki mekanisme untuk memaksa rebuild otomatis.

**Risiko `-git`:** Setiap `pacman -Syu` yang memperbarui Qt dapat menyebabkan Quickshell `-git` crash karena ABI berubah. Quickshell akan mencoba memperingatkan Anda, tetapi solusinya adalah **reinstall paket** (`yay -S quickshell-git` lagi). Ini bukan bug, melainkan konsekuensi dari melacak branch pengembangan.

#### Struktur Direktori

```text
~/.config/quickshell/
├── shell.qml              # ⚠️ Jika ada di sini, subfolder DIABAIKAN sebagai config terpisah
├── bar/
│   └── shell.qml          # Config bernama "bar"
├── lock/
│   └── shell.qml          # Config bernama "lock"
└── my-shell/
    ├── shell.qml          # Config bernama "my-shell"
    ├── components/
    │   └── Clock.qml
    └── services/
        └── Theme.qml
```

**Penjelasan:**
- Folder `bar/`, `lock/`, `my-shell/` masing-masing adalah **config terpisah** karena berisi `shell.qml`.
- Jika Anda membuat `~/.config/quickshell/shell.qml` (langsung di root), maka `bar/`, `lock/`, dan `my-shell/` **tidak akan dikenali** sebagai config terpisah. Ini adalah perilaku "menaungi" yang perlu diwaspadai.

#### Menjalankan Konfigurasi: `-c` vs `-p`

```bash
# Menjalankan config bernama "bar" (harus ada di ~/.config/quickshell/bar/shell.qml)
quickshell -c bar

# Menjalankan file QML langsung (di luar XDG)
quickshell -p /path/to/custom.qml

# Menjalankan direktori QML langsung (di luar XDG)
quickshell -p /path/to/custom-shell/
```

**Perbedaan fundamental:**

| Aspek | `-c <name>` | `-p <path>` |
|---|---|---|
| Lokasi | Harus di `$XDG_CONFIG_HOME/quickshell/<name>/` atau `$XDG_CONFIG_DIRS/quickshell/<name>/` | Di mana saja di filesystem |
| Entry point | `<name>/shell.qml` | File `.qml` atau direktori (mencari `shell.qml` di dalamnya) |
| Hot reload | ✅ Ya | ✅ Ya |
| Cocok untuk | Konfigurasi permanen, distribusi dotfiles | Eksperimen cepat, pengembangan, file tunggal |

**Sumber:** Dokumentasi resmi menyatakan: *"A specific configuration can be picked using the `--config` or `-c` argument... Configs located at other paths outside XDG standard, including raw qml files, can be run with `--path` or `-p`."*

#### Instance Management

```bash
# Daftar instance yang sedang berjalan
qs list
# atau
quickshell list

# Menjalankan tanpa duplikasi (gagal jika sudah ada instance untuk config yang sama)
quickshell -c bar --no-duplicate
```

**`qs` vs `quickshell`:** `qs` hanyalah **nama pendek** yang umum digunakan (sering kali symlink ke `quickshell`). Tidak ada binary `qs` terpisah; ini adalah alias komunitas. Jika `qs` tidak tersedia di sistem Anda, gunakan `quickshell`.

#### Hot Reload

Hot reload **aktif secara default** (`Quickshell.watchFiles = true`). Setiap kali Anda menyimpan file yang merupakan bagian dari konfigurasi, Quickshell akan memuat ulang **komponen yang berubah** tanpa me-restart seluruh shell.

**Cara kerja:** Quickshell memantau file melalui `inotify` (Linux). Ketika file berubah, ia memicu reload pada level QML engine. Ini berarti **state runtime** (misalnya, nilai properti yang diubah saat runtime) **hilang** saat reload, kecuali Anda menyimpannya secara eksplisit (misalnya, di `Quickshell.stateDir`).

---

### 4. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh/Konteks |
|---|---|---|
| **Config** | Folder bernama di dalam `quickshell/` yang berisi `shell.qml` sebagai entry point. | `bar/`, `lock/`, `my-shell/` |
| **`shell.qml`** | Titik masuk setiap konfigurasi. Quickshell mencari file ini untuk memulai. | `~/.config/quickshell/bar/shell.qml` |
| **Hot reload** | Kemampuan memuat ulang kode secara otomatis saat file disimpan, tanpa restart manual. | Aktif secara default; edit file → simpan → shell ter-reload. |
| **Instance** | Satu proses Quickshell yang sedang berjalan, mewakili satu config. | `qs list` menampilkan instance yang aktif. |
| **`--no-duplicate`** | Flag yang mencegah menjalankan instance kedua untuk config yang sama. | Berguna untuk autostart agar tidak dobel. |
| **XDG Base Directory** | Standar freedesktop.org untuk lokasi file konfigurasi, data, dan cache. | `$XDG_CONFIG_HOME` (default: `~/.config`) |
| **`$XDG_CONFIG_DIRS`** | Daftar direktori konfigurasi sistem (default: `/etc/xdg`). | Administrator bisa menaruh config default di sini. |

---

### 5. Rekomendasi Visualisasi

#### Pohon Direktori dan Resolusi Config

```text
$XDG_CONFIG_HOME (~/.config)
└── quickshell/
    ├── shell.qml          ← JIKA ADA: subfolder DIABAIKAN
    ├── bar/               ← Config "bar"
    │   ├── shell.qml      ← Entry point
    │   ├── components/
    │   └── services/
    ├── lock/              ← Config "lock"
    │   └── shell.qml
    └── my-shell/          ← Config "my-shell"
        └── shell.qml

$XDG_CONFIG_DIRS (/etc/xdg)
└── quickshell/
    └── default/           ← Config sistem (bisa ditimpa user)
        └── shell.qml

Resolusi: quickshell -c bar  →  ~/.config/quickshell/bar/shell.qml
           quickshell -p /tmp/test.qml  →  /tmp/test.qml
```

#### Alur Keputusan: `-c` vs `-p`

```text
Apakah konfigurasi berada di ~/.config/quickshell/<name>/?
├── YA → Gunakan `quickshell -c <name>`
└── TIDAK → Apakah Anda ingin menjalankan file/folder QML langsung?
    ├── YA → Gunakan `quickshell -p <path>`
    └── TIDAK → Pindahkan konfigurasi ke ~/.config/quickshell/<name>/
```

---

### 6. Hubungan dengan Modul Lain

- **Modul 1.2** bergantung pada pemahaman `-c` untuk menjalankan config `bar` yang akan Anda buat. Tanpa mengetahui cara memilih config, Anda tidak bisa menguji bar multi-monitor.
- **Modul 1.3** menggunakan struktur folder di dalam config (`components/`, `services/`) yang diperkenalkan di sini.
- **Modul 1.4** menggunakan `qs list` untuk mendiagnosis instance yang crash dan memerlukan pemahaman tentang hot reload untuk debugging.

---

### 7. Sumber Referensi Lengkap

- **Dokumentasi Resmi — Installation & Setup**: [https://quickshell.org/docs/v0.3.1/guide/install-setup/](https://quickshell.org/docs/v0.3.1/guide/install-setup/) — Mencakup instalasi Arch, peringatan AUR, dan dependensi opsional.
- **Dokumentasi Resmi — Introduction (Config Files)**: [https://quickshell.org/docs/v0.3.1/guide/introduction/](https://quickshell.org/docs/v0.3.1/guide/introduction/) — Penjelasan resmi tentang `-c` dan `-p`.
- **XDG Base Directory Specification**: [https://specifications.freedesktop.org/basedir-spec/latest/](https://specifications.freedesktop.org/basedir-spec/latest/) — Standar yang mendasari path resolution.
- **Arch Wiki — pacman**: [https://wiki.archlinux.org/title/pacman](https://wiki.archlinux.org/title/pacman) — Referensi untuk `pacman -S`.
- **Quickshell — Quickshell Type (screens, watchFiles)**: [https://quickshell.org/docs/v0.1.0/types/Quickshell/Quickshell/](https://quickshell.org/docs/v0.1.0/types/Quickshell/Quickshell/) — Properti `screens`, `watchFiles`, dan direktori data/state.

---

### 8. Tips dan Praktik Terbaik

1. **Gunakan `-git` hanya di lingkungan pengembangan.** Untuk penggunaan sehari-hari, stabil lebih aman. Jika Anda menggunakan `-git`, **pin versi** dengan `yay -S quickshell-git` dan hindari `-git` di sistem produksi.
2. **Selalu audit PKGBUILD AUR** sebelum menginstal. Gunakan `yay -G quickshell-git` lalu periksa isi PKGBUILD.
3. **Jangan letakkan `shell.qml` di root `quickshell/`** kecuali Anda benar-benar ingin "menaungi" subfolder. Ini adalah sumber kebingungan umum.
4. **Gunakan `--no-duplicate` di autostart** (Modul 1.4) untuk mencegah instance ganda saat login.
5. **Simpan config di Git** (dotfiles repository) agar mudah di-rollback jika ada perubahan yang merusak.
6. **Untuk eksperimen cepat**, gunakan `-p` dengan file di `/tmp/` atau `~/playground/` agar tidak mengotori `~/.config/quickshell/`.

---

### 9. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| **Menaruh `shell.qml` di root `quickshell/`** | Subfolder `bar/`, `lock/` tidak dikenali sebagai config terpisah. | Hapus `~/.config/quickshell/shell.qml` atau pindahkan ke subfolder. |
| **Menggunakan `-c` untuk file di luar XDG** | Error: config tidak ditemukan. | Gunakan `-p /path/to/file.qml` sebagai gantinya. |
| **Mengira `qs` adalah binary terpisah** | `qs: command not found`. | Gunakan `quickshell` atau buat symlink: `ln -s $(which quickshell) ~/.local/bin/qs`. |
| **Menginstal `-git` lalu bingung saat crash setelah update Qt** | Quickshell crash dengan error ABI. | Reinstall `quickshell-git` (`yay -S quickshell-git`). |
| **Mengira penguncian instance = keamanan** | Menjalankan config berbahaya tanpa audit. | Pahami bahwa penguncian hanya mencegah duplikasi; audit kode dan gunakan sandboxing. |
| **Hot reload tidak berfungsi** | Perubahan file tidak terlihat. | Pastikan `Quickshell.watchFiles` tidak di-set `false`. Periksa apakah file berada di dalam direktori config. |

---

### 10. Latihan dan Checkpoint

**Latihan:**
1. Instal Quickshell stabil.
2. Buat dua config bernama: `hello` (dari Modul 0.2) dan `test` (kosong dengan `ShellRoot {}`).
3. Jalankan `hello` dengan `-c hello`, lalu `test` dengan `-c test`. Amati `qs list`.
4. Coba jalankan file QML di `/tmp/hello.qml` dengan `-p /tmp/hello.qml`.
5. Hapus `hello` saat masih berjalan, lalu coba jalankan lagi. Apa yang terjadi?

**Checkpoint:**
- Jelaskan perbedaan `-c` dan `-p` dalam satu kalimat masing-masing.
- Mengapa penguncian instance **bukan** mekanisme keamanan?
- Apa yang terjadi jika Anda menaruh `shell.qml` di `~/.config/quickshell/shell.qml` dan juga memiliki subfolder `bar/shell.qml`?

**Jawaban singkat:**
- `-c` memilih config bernama di dalam XDG; `-p` menjalankan file/folder QML di path arbitrer.
- Penguncian hanya mencegah duplikasi instance, tidak memvalidasi atau membatasi perilaku kode.
- Subfolder `bar/` **tidak akan dianggap** sebagai config terpisah karena root `shell.qml` "menaungi" subfolder.

---

> *"Setiap baris konfigurasi adalah pernyataan tentang bagaimana Anda ingin komputer Anda berperilaku. Mulailah dari tempat yang benar."*

---

# Modul 1.2 — `PanelWindow`, `Variants`, `Process`, dan `SystemClock`

> *"Bar yang baik bukan yang paling indah, tetapi yang paling jujur tentang apa yang sedang terjadi di sistem Anda."*

---
## 📋 Daftar Isi Internal

1. `PanelWindow`: layer-shell, anchoring, dan reservasi ruang.
2. `Variants` dan `Quickshell.screens`: pola multi-monitor.
3. `SystemClock`: waktu bawaan tanpa polling.
4. `Process`: menjalankan program eksternal dengan benar.
5. `StdioCollector` vs `SplitParser`; `Quickshell.execDetached`.
6. Penanganan error dan lifecycle `Process` — **tambahan audit**.
7. Sandboxing proses dengan hak minimal — **tambahan audit**.
8. Studi kasus: bar multi-monitor dengan jam dan load average.
9. Terminologi, visualisasi, hubungan modul, referensi, tips, kesalahan umum, latihan.

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengubah Quickshell dari “sesuatu yang berjalan” menjadi **antarmuka yang benar-benar terlihat dan bereaksi terhadap sistem**. Anda akan membuat bar yang muncul di **setiap monitor**, menampilkan waktu dengan `SystemClock`, dan menjalankan perintah eksternal dengan `Process` — baik sekali jalan maupun streaming.

**Peran dalam kurikulum:** Modul 1.2 adalah **jembatan antara konfigurasi dan antarmuka nyata**. Modul 1.1 mengajarkan di mana konfigurasi tinggal; Modul 1.2 mengajarkan bagaimana konfigurasi itu “tampil” dan “berbicara” dengan sistem. Tanpa penguasaan `PanelWindow`, `Variants`, dan `Process`, modul-modul berikutnya tidak akan memiliki kanvas untuk menempatkan komponen, maupun sumber data untuk ditampilkan.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 🧱 `PanelWindow`: Jendela yang Tahu Tempatnya

`PanelWindow` adalah **jendela tanpa dekorasi** yang “menempel” di tepi layar melalui **anchors**. Ia menggunakan **layer-shell** pada Wayland (atau EWMH struts pada X11) untuk memberi tahu compositor: “Saya adalah panel; saya ingin menempati tepi atas layar dan, jika perlu, memesan ruang agar jendela lain tidak menutupinya.”

Filosofi pentingnya:

- **Anchoring eksplisit**: Semua anchor **nonaktif secara default**. Ini adalah pengaman: jika semua anchor aktif secara default, panel yang salah konfigurasi bisa menutupi seluruh layar.
- **Dua anchor berlawanan** (misalnya `left: true` dan `right: true`) memaksa dimensi yang sesuai (lebar) menjadi **selebar layar**. Ini bukan bug; ini adalah cara layer-shell menentukan ukuran panel yang membentang.
- **`exclusiveZone`** adalah “klaim ruang”. Ketika diatur, panel tidak sekadar menimpa konten, tetapi **memesan ruang** sehingga jendela lain didorong ke bawah/ke samping. Ini memerlukan **1 atau 3 anchor** agar berlaku.

### 🧬 `Variants`: Mesin Fotokopi yang Sadar Konteks

`Variants` bukan `Repeater`. `Repeater` membuat banyak **`Item`** di dalam scene graph; `Variants` membuat banyak **objek non-`Item`** — termasuk `PanelWindow` — dan bertindak sebagai **reload scope**. Setiap nilai unik dalam `model` akan membuat satu instance `delegate` dengan properti `modelData` berisi nilai tersebut.

Analogi: `Variants` adalah **mesin fotokopi** yang mengambil satu rancangan bar dan memperbanyaknya untuk setiap layar yang terdeteksi. Ketika monitor dicabut atau dipasang, `Quickshell.screens` berubah, dan `Variants` menyesuaikan jumlah instance secara otomatis.

### 🕰️ `SystemClock`: Sumber Waktu yang Hemat

`SystemClock` adalah **view ke jam sistem** yang memperbarui diri pada interval jam, menit, atau detik sesuai `precision`. Default-nya adalah `SystemClock.Seconds`. Ia **tidak** melakukan polling ke `date` setiap detik; ia terintegrasi dengan perubahan jam sistem dan memperbarui dalam **±50 ms** dari perubahan.

Filosofi: **jangan memanggil program eksternal untuk data yang sudah disediakan Quickshell**. Ini bukan hanya soal efisiensi; ini soal **least privilege** — semakin sedikit proses yang dijalankan, semakin kecil permukaan serangan.

### ⚙️ `Process`: Kontrol Penuh, Tanggung Jawab Penuh

`Process` menjalankan program eksternal dengan `command` berupa **daftar argumen**, bukan satu string shell. Artinya, Anda **tidak** perlu quoting, tetapi juga **tidak bisa** mengandalkan fitur shell seperti pipe, glob, atau `&&` kecuali Anda secara eksplisit menjalankan shell (`["sh", "-c", "..."]`).

Dua mode utama:

- **Sekali jalan**: proses pendek, output dikumpulkan dengan `StdioCollector`, lalu proses selesai.
- **Streaming**: proses panjang (misalnya `playerctl --follow`), output dibaca per baris dengan `SplitParser`.

Filosofi keamanan: **proses anak mewarisi seluruh environment induk** kecuali dibersihkan. `clearEnvironment: true` adalah pintu masuk menuju **least privilege**, tetapi bukan sandbox penuh — masih ada filesystem, network, dan syscall yang sama.

---

## 3. Sintaks Dasar / Contoh Implementasi Inti

### 3.1 `PanelWindow` Minimal

```qml
import Quickshell
import QtQuick

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 30
        color: "transparent"

        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Halo, panel!"
        }
    }
}
```

**Penjelasan kata per kata:**

- `ShellRoot`: root object untuk konfigurasi Quickshell; menandakan bahwa ini adalah entry point shell.
- `PanelWindow`: jendela layer-shell yang menempel di tepi layar.
- `anchors.top: true`: menempel ke atas layar.
- `anchors.left: true` + `anchors.right: true`: dua anchor berlawanan; lebar panel dipaksa **sama dengan lebar layar**.
- `implicitHeight: 30`: tinggi yang diinginkan panel; layer-shell akan memberi tinggi ini kecuali `exclusiveZone` mengubah perilaku.
- `color: "transparent"`: latar transparan; anak-anak panel yang akan menggambar latar sendiri.
- `Text { anchors.centerIn: parent }`: teks ditempatkan di tengah panel.

**Catatan penting:** `PanelWindow` bukan `Item` biasa. Ia adalah `QsWindow` yang menggunakan layer-shell. Karena itu, ia tidak bisa diletakkan di dalam `Item` biasa; ia harus berada di root atau di dalam `Variants`.

---

### 3.2 `Variants` Multi-Monitor

```qml
import Quickshell
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: "transparent"

            Text {
                anchors.centerIn: parent
                color: "white"
                text: modelData.name
            }
        }
    }
}
```

**Penjelasan:**

- `Variants { model: Quickshell.screens ... }`: `Quickshell.screens` adalah daftar `ShellScreen` yang terdeteksi.
- Anak langsung `PanelWindow` menjadi **`delegate` default** dari `Variants`. Artinya, `Variants` membuat satu `PanelWindow` untuk setiap elemen `model`.
- `required property var modelData`: setiap instance menerima satu elemen model. `required` memastikan properti ini **wajib diisi** oleh `Variants`; jika tidak, QML akan melaporkan error.
- `screen: modelData`: menetapkan panel ke layar tertentu. `modelData` di sini adalah `ShellScreen`.
- `text: modelData.name`: menampilkan nama layar (misalnya `DP-1`, `HDMI-A-1`) untuk membuktikan bahwa setiap panel berada di monitor yang benar.

**Alternatif `delegate` eksplisit:**

```qml
Variants {
    model: Quickshell.screens
    delegate: Component {
        PanelWindow {
            required property var modelData
            screen: modelData
            // ...
        }
    }
}
```

Keduanya valid. Anak langsung lebih ringkas; `delegate: Component { ... }` lebih eksplisit dan memudahkan pemisahan komponen.

---

### 3.3 `SystemClock`

```qml
SystemClock {
    id: clock
    precision: SystemClock.Seconds
}

Text {
    text: Qt.formatDateTime(clock.date, "HH:mm:ss")
}
```

**Penjelasan:**

- `precision: SystemClock.Seconds`: memperbarui setiap detik. Pilihan lain: `SystemClock.Minutes`, `SystemClock.Hours`.
- `clock.date`: objek `Date` yang selalu diperbarui. **Jangan** membuat `new Date()` sendiri; itu bisa berbeda hingga satu detik dari `clock.date`.
- `Qt.formatDateTime(date, format)`: fungsi Qt untuk memformat tanggal/waktu. Format `"HH:mm:ss"` menghasilkan jam 24-jam dengan detik.

---

### 3.4 `Process` Sekali Jalan dengan `StdioCollector`

```qml
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    Process {
        id: loadavg
        command: ["cat", "/proc/loadavg"]
        clearEnvironment: true
        environment: ({ PATH: "/usr/bin" })
        running: true

        stdout: StdioCollector {
            onStreamFinished: console.log(this.text.trim())
        }
    }
}
```

**Penjelasan:**

- `command: ["cat", "/proc/loadavg"]`: daftar argumen. Tidak ada shell; `cat` dipanggil langsung.
- `clearEnvironment: true`: **membuang seluruh environment induk** sebelum `environment` diterapkan.
- `environment: ({ PATH: "/usr/bin" })`: hanya `PATH` yang tersedia untuk proses anak.
- `running: true`: memulai proses segera.
- `stdout: StdioCollector { ... }`: mengumpulkan **seluruh** output sampai proses selesai.
- `onStreamFinished`: sinyal yang dipanggil ketika stream selesai; `this.text` berisi output mentah.

**Mengapa `({ ... })` dibungkus tanda kurung?** Dalam QML/JavaScript, `{ ... }` di awal ekspresi bisa dianggap sebagai blok, bukan objek. Tanda kurung memaksa parser memperlakukannya sebagai objek.

---

### 3.5 `Process` Streaming dengan `SplitParser`

```qml
Process {
    command: ["playerctl", "--follow", "metadata", "--format", "{{title}}"]
    running: true

    stdout: SplitParser {
        onRead: data => {
            console.log("Judul sekarang:", data)
        }
    }
}
```

**Penjelasan:**

- `playerctl --follow ...`: proses panjang yang terus mengeluarkan baris saat metadata berubah.
- `SplitParser`: membaca output **per baris** dan memanggil `onRead` setiap kali satu baris selesai.
- `data`: string satu baris (tanpa newline).
- Ini adalah pola yang tepat untuk **streaming**, karena `StdioCollector` tidak akan pernah “selesai” sampai proses berhenti.

---

### 3.6 `Quickshell.execDetached`

```qml
Quickshell.execDetached(["notify-send", "Halo dari Quickshell"])
```

**Penjelasan:**

- `execDetached` menjalankan proses **tanpa objek `Process`**, dan proses tersebut **tidak dibunuh** ketika Quickshell mati atau konfigurasi dimuat ulang.
- Cocok untuk **fire-and-forget**: notifikasi, membuka aplikasi, mengirim perintah ke daemon.
- **Tidak** berjalan di shell. Jika Anda memerlukan shell, gunakan `["sh", "-c", "..."]` — tetapi berhati-hatilah terhadap injeksi jika string dibangun dari input pengguna.

---

## 4. Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi | Contoh/Konteks |
|---|---|---|
| **`PanelWindow`** | Jendela layer-shell tanpa dekorasi yang menempel di tepi layar dan dapat memesan ruang. | Bar, HUD, widget sudut. |
| **`Variants`** | Pembuat instance dinamis untuk objek non-`Item`; bertindak sebagai reload scope. | Satu `PanelWindow` per `Quickshell.screens`. |
| **`modelData`** | Properti pada delegate yang berisi satu elemen dari `model`. | `ShellScreen` untuk satu monitor. |
| **`ShellScreen`** | Tipe yang mewakili satu layar; memiliki properti seperti `name`, `width`, `height`. | `modelData.name` → `"DP-1"`. |
| **`SystemClock`** | Sumber waktu bawaan yang memperbarui pada interval tertentu. | `clock.date`, `clock.hours`. |
| **`Process`** | Objek untuk menjalankan program eksternal dengan `command` berupa daftar argumen. | `["cat", "/proc/loadavg"]`. |
| **`StdioCollector`** | Parser yang mengumpulkan seluruh output sampai proses selesai. | Sekali jalan: `cat`, `date`. |
| **`SplitParser`** | Parser yang membaca output per baris saat proses berjalan. | Streaming: `playerctl --follow`. |
| **`clearEnvironment`** | Flag untuk membuang environment induk sebelum `environment` diterapkan. | `true` → hanya variabel di `environment` yang terlihat. |
| **`execDetached`** | Menjalankan proses tanpa `Process`; proses tidak dibunuh saat Quickshell mati. | `notify-send`, membuka aplikasi. |
| **`exclusiveZone`** | Jumlah ruang yang dipesan panel relatif terhadap anchor. | `30` → jendela lain didorong 30px. |
| **`onExited`** | Sinyal `Process` saat proses selesai; menerima `exitCode` dan `exitStatus`. | Deteksi kegagalan perintah. |
| **`onRunningChanged`** | Sinyal `Process` saat `running` berubah; sering dipakai untuk restart loop. | `if (!running) running = true`. |

---

## 5. Rekomendasi Visualisasi

### 5.1 Arsitektur `Variants` Multi-Monitor

```text
Quickshell.screens = [ DP-1, HDMI-A-1 ]
        │
        │  Variants { model: Quickshell.screens }
        │
        ├──► PanelWindow (screen = DP-1)
        │       ├── SystemClock
        │       └── Text (jam)
        │
        └──► PanelWindow (screen = HDMI-A-1)
                ├── SystemClock
                └── Text (jam)
```

**Penjelasan:** Satu rancangan `PanelWindow` diperbanyak oleh `Variants`; masing-masing instance terikat ke satu `ShellScreen`. Jika monitor dicabut, `Quickshell.screens` berubah dan instance yang sesuai dihancurkan.

### 5.2 Alur `Process` Sekali Jalan vs Streaming

```text
SEKALI JALAN                         STREAMING
─────────────                        ─────────
Process                              Process
  command: ["cat", file]               command: ["playerctl", "--follow"]
  running: true                        running: true
       │                                    │
       ▼                                    ▼
  StdioCollector                       SplitParser
  (kumpulkan semua)                    (baca per baris)
       │                                    │
       ▼                                    ▼
  onStreamFinished                     onRead(data)
  (setelah proses selesai)             (setiap baris)
```

### 5.3 Keputusan: `Process` vs `execDetached`

```text
Apakah Anda perlu memantau output / status proses?
├── YA → Gunakan Process
│         ├── Output pendek & perlu diproses setelah selesai → StdioCollector
│         └── Output streaming per baris → SplitParser
└── TIDAK → Apakah proses boleh hidup lebih lama dari Quickshell?
    ├── YA → Gunakan Quickshell.execDetached
    └── TIDAK → Process dengan running: true juga cukup
```

---

## 6. Penanganan Error dan Lifecycle `Process` — Tambahan Audit

Ini adalah bagian yang **tidak ada secara eksplisit** dalam daftar isi kurikulum asli, tetapi krusial untuk penggunaan `Process` secara profesional.

### 6.1 `onExited`: Mendeteksi Kegagalan

```qml
Process {
    command: ["test", "-f", "/etc/passwd"]
    running: true

    onExited: (exitCode, exitStatus) => {
        if (exitCode !== 0) {
            console.warn("Perintah gagal dengan kode:", exitCode)
        }
    }
}
```

**Penjelasan:**

- `onExited` adalah sinyal yang dipancarkan saat proses selesai.
- `exitCode`: kode keluar proses (0 = sukses, non-0 = gagal).
- `exitStatus`: status keluar (normal, crash, dll.).
- **Penting:** Jangan mengandalkan `exitCode` jika proses dijalankan di lingkungan yang mewarisi `SIGCHLD` yang diabaikan (misalnya, beberapa compositor). Ada laporan bahwa `exitCode` bisa selalu 0 dengan `CrashExit` dalam kondisi tertentu. Untuk keputusan kritis, verifikasi output atau gunakan mekanisme tambahan.

### 6.2 `onRunningChanged`: Restart Loop

```qml
Process {
    command: ["sleep", "1"]
    running: true

    onRunningChanged: {
        if (!running) {
            running = true
        }
    }
}
```

**Penjelasan:**

- Setiap kali `running` berubah menjadi `false` (proses selesai), handler langsung menyetelnya kembali ke `true`, menciptakan **loop**.
- Ini adalah pola resmi yang disebutkan dokumentasi untuk menjalankan proses berulang.
- **Hati-hati:** loop tanpa jeda dapat membebani CPU. Tambahkan `Timer` atau `sleep` di dalam perintah.

### 6.3 `startDetached()` pada `Process`

Selain `Quickshell.execDetached`, objek `Process` juga memiliki `startDetached()` untuk menjalankan proses yang **tidak dibunuh** saat Quickshell mati. Ini berguna jika Anda tetap ingin menggunakan `Process` untuk konfigurasi, tetapi prosesnya harus bertahan.

---

## 7. Sandboxing Proses dengan Hak Minimal — Tambahan Audit

`clearEnvironment` hanyalah **langkah pertama**. Untuk isolasi yang lebih kuat, jalankan proses melalui alat sandbox:

### 7.1 `systemd-run --user --scope`

```qml
Process {
    command: [
        "systemd-run", "--user", "--scope", "--quiet",
        "--property=NoNewPrivileges=yes",
        "--property=PrivateTmp=yes",
        "--", "cat", "/proc/loadavg"
    ]
    running: true
    stdout: StdioCollector { onStreamFinished: console.log(this.text.trim()) }
}
```

**Penjelasan:**

- `systemd-run --user --scope`: menjalankan perintah dalam **scope** systemd user, sehingga Anda bisa menerapkan properti keamanan.
- `NoNewPrivileges=yes`: mencegah proses menaikkan privilege (misalnya, via setuid).
- `PrivateTmp=yes`: memberikan `/tmp` privat, mengurangi risiko serangan symlink.
- `--`: memisahkan opsi `systemd-run` dari perintah yang dijalankan.

### 7.2 `bwrap` (bubblewrap)

```qml
Process {
    command: [
        "bwrap",
        "--ro-bind", "/usr", "/usr",
        "--ro-bind", "/etc", "/etc",
        "--proc", "/proc",
        "--dev", "/dev",
        "--unshare-all",
        "--die-with-parent",
        "--", "cat", "/proc/loadavg"
    ]
    running: true
    stdout: StdioCollector { onStreamFinished: console.log(this.text.trim()) }
}
```

**Penjelasan:**

- `bwrap`: sandbox ringan dari proyek Flatpak.
- `--ro-bind /usr /usr`: mount read-only; proses tidak bisa mengubah binary sistem.
- `--unshare-all`: memisahkan namespace (network, PID, IPC, dll.).
- `--die-with-parent`: proses mati jika Quickshell mati.
- Ini adalah **isolasi nyata**, bukan sekadar pembersihan environment.

**Catatan:** Tidak semua perintah cocok untuk sandbox ketat. `playerctl` memerlukan akses ke D-Bus sesi; sandbox harus dikonfigurasi agar D-Bus tetap tersedia. Gunakan sandbox hanya untuk perintah yang tidak memerlukan akses luas.

---

## 8. Studi Kasus: Bar Multi-Monitor dengan Jam dan Load Average

```qml
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: "transparent"

            SystemClock {
                id: clock
                precision: SystemClock.Seconds
            }

            Row {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    color: "white"
                    text: Qt.formatDateTime(clock.date, "HH:mm:ss")
                }

                Text {
                    id: loadText
                    color: "white"
                    text: "load: …"
                }
            }

            Process {
                command: ["cat", "/proc/loadavg"]
                clearEnvironment: true
                environment: ({ PATH: "/usr/bin" })
                running: true

                stdout: StdioCollector {
                    onStreamFinished: {
                        loadText.text = "load: " + this.text.trim().split(" ")[0]
                    }
                }
            }
        }
    }
}
```

**Penjelasan alur:**

1. `Variants` membuat satu `PanelWindow` per layar.
2. Setiap panel memiliki `SystemClock` sendiri, sehingga jam selalu akurat di semua monitor.
3. Setiap panel menjalankan `Process` sendiri untuk membaca `/proc/loadavg`. Ini sedikit boros (satu proses per monitor), tetapi sederhana dan terisolasi.
4. `clearEnvironment: true` dan `environment: ({ PATH: "/usr/bin" })` memastikan proses hanya melihat `PATH`.
5. `StdioCollector` mengumpulkan output, lalu `split(" ")[0]` mengambil nilai load average pertama (1 menit).

**Optimasi:** Jika Anda ingin satu proses untuk semua monitor, pindahkan `Process` ke luar `Variants` dan gunakan properti bersama. Namun, untuk studi kasus ini, isolasi per panel lebih mudah dipahami.

---

## 9. Hubungan dengan Modul Lain

- **Modul 1.3** akan memecah `PanelWindow` dan `Text` menjadi komponen reusable (`Clock.qml`, `Bar.qml`) serta singleton (`Theme.qml`). Pemahaman `Variants` dan properti `modelData` sangat penting agar komponen tetap dapat diparameterisasi per monitor.
- **Modul 1.4** akan menggunakan `Process` untuk menjalankan `qmllint`, `gdb`, dan alat diagnostik lainnya. Penanganan `onExited` dan `onRunningChanged` yang diperkenalkan di sini akan langsung terpakai.
- **Modul 3.1** (ketergantungan dinamis) akan memperdalam kapan state global (singleton) tepat dan kapan dependency injection lewat properti lebih baik. `Variants` adalah contoh awal “komposisi eksplisit”.

---

## 10. Sumber Referensi Lengkap

- **`PanelWindow` — dokumentasi resmi**: [https://quickshell.org/docs/v0.2.0/types/Quickshell/PanelWindow/](https://quickshell.org/docs/v0.2.0/types/Quickshell/PanelWindow/) — anchors, `exclusiveZone`, `focusable`, `aboveWindows`.
- **`Variants` — dokumentasi resmi**: [https://quickshell.org/docs/v0.3.2/types/Quickshell/Variants/](https://quickshell.org/docs/v0.3.2/types/Quickshell/Variants/) — `model`, `delegate`, `instances`, dan peringatan bug reload.
- **`SystemClock` — dokumentasi resmi**: [https://quickshell.org/docs/v0.3.1/types/Quickshell/SystemClock](https://quickshell.org/docs/v0.3.1/types/Quickshell/SystemClock) — `precision`, `date`, peringatan ±50 ms.
- **`Process` — dokumentasi resmi**: [https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/Process/](https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/Process/) — `command`, `clearEnvironment`, `environment`, `stdinEnabled`, sinyal `exited`/`started`.
- **`StdioCollector`**: [https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/StdioCollector/](https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/StdioCollector/) — `text`, `onStreamFinished`.
- **`SplitParser`**: [https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/SplitParser/](https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/SplitParser/) — `onRead`.
- **`Quickshell.execDetached`**: [https://quickshell.org/docs/](https://quickshell.org/docs/) — cari “execDetached”; disebutkan dalam catatan rilis dan `DesktopEntry`.
- **Qt `Repeater` vs `Variants`**: [https://doc.qt.io/qt-6/qml-qtquick-repeater.html](https://doc.qt.io/qt-6/qml-qtquick-repeater.html) — pembanding konseptual.
- **`systemd-run` — Arch Wiki**: [https://wiki.archlinux.org/title/Systemd-run](https://wiki.archlinux.org/title/Systemd-run) — sandboxing dengan scope dan properti keamanan.
- **bubblewrap**: [https://github.com/containers/bubblewrap](https://github.com/containers/bubblewrap) — sandbox ringan untuk proses.

---

## 11. Tips dan Praktik Terbaik

1. **Selalu mulai `PanelWindow` dengan anchor minimal.** Jangan aktifkan semua anchor sekaligus kecuali Anda benar-benar ingin panel menutupi seluruh layar.
2. **Gunakan `required property` untuk `modelData` di dalam `Variants`.** Ini memberi error QML yang jelas jika delegate tidak menerima data.
3. **Jangan polling `date` setiap detik.** Gunakan `SystemClock` dengan `precision` yang sesuai. Jika Anda hanya menampilkan jam tanpa detik, gunakan `SystemClock.Minutes` untuk mengurangi pembaruan.
4. **Untuk perintah sekali jalan yang outputnya kecil**, gunakan `StdioCollector`. Untuk streaming, gunakan `SplitParser`.
5. **Selalu tangani `onExited` untuk perintah yang bisa gagal.** Jangan biarkan kegagalan senyap.
6. **Gunakan `clearEnvironment: true` untuk perintah yang tidak memerlukan environment pengguna.** Ini mengurangi kebocoran rahasia (misalnya, token di environment).
7. **Jangan membangun `command` dari input pengguna tanpa validasi.** `Process` tidak menjalankan shell, tetapi jika Anda menggunakan `["sh", "-c", userInput]`, Anda membuka celah injeksi.
8. **Untuk notifikasi dan peluncuran aplikasi**, gunakan `Quickshell.execDetached` agar proses tidak mati saat shell di-reload.
9. **Untuk proses yang memerlukan isolasi lebih kuat**, pertimbangkan `systemd-run --scope` atau `bwrap`. Uji terlebih dahulu; beberapa perintah memerlukan akses yang tidak tersedia di sandbox.
10. **Pantau log (`quickshell log`) saat mengembangkan `Process`.** Output `console.log` dari `StdioCollector`/`SplitParser` akan muncul di sana.

---

## 12. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| **Menganggap `Variants` seperti `Repeater`** | Mencoba meletakkan `Item` di dalam `Variants` dan bingung mengapa tidak tampil. | `Variants` untuk objek non-`Item`; gunakan `Repeater` untuk `Item` di dalam scene graph. |
| **Tidak menambahkan `required` pada `modelData`** | Error runtime “modelData is not defined” atau nilai `undefined`. | Gunakan `required property var modelData` atau `required property ShellScreen modelData`. |
| **Menggunakan `StdioCollector` untuk proses streaming** | Callback tidak pernah dipanggil karena proses tidak selesai. | Gunakan `SplitParser` untuk streaming. |
| **Mengira `command` adalah string shell** | Pipe, `&&`, dan glob tidak berfungsi. | Gunakan daftar argumen; jika perlu shell, gunakan `["sh", "-c", "..."]`. |
| **Lupa `clearEnvironment`** | Proses anak melihat seluruh environment induk, termasuk rahasia. | Set `clearEnvironment: true` dan definisikan `environment` minimal. |
| **Mengira `clearEnvironment` adalah sandbox** | Proses masih bisa mengakses filesystem dan network. | Gunakan `bwrap` atau `systemd-run --scope` untuk isolasi nyata. |
| **Tidak menangani `onExited`** | Kegagalan perintah tidak terdeteksi. | Tambahkan `onExited` dan periksa `exitCode`. |
| **Menggunakan `execDetached` untuk proses yang perlu dipantau** | Tidak ada output/status yang bisa dibaca. | Gunakan `Process` jika Anda perlu memantau. |
| **Mengira `SystemClock` selalu tepat hingga milidetik** | Perbedaan kecil saat membandingkan dengan `date`. | Pahami peringatan ±50 ms; gunakan `clock.date` secara konsisten. |
| **Panel tidak memesan ruang** | Jendela lain menutupi panel. | Atur `exclusiveZone` dengan 1 atau 3 anchor. |
| **Panel menutupi seluruh layar** | Semua anchor aktif secara tidak sengaja. | Periksa anchor; default-nya nonaktif, tetapi konfigurasi eksplisit bisa mengaktifkan semuanya. |

---

## 13. Latihan dan Checkpoint

### Latihan

1. **Bar multi-monitor**: Buat `PanelWindow` di setiap monitor yang menampilkan nama layar dan jam dengan `SystemClock.Seconds`.
2. **Load average**: Tambahkan `Process` yang membaca `/proc/loadavg` dengan `clearEnvironment: true` dan `environment: ({ PATH: "/usr/bin" })`.
3. **Streaming**: Ganti `Process` load average dengan `playerctl --follow` dan tampilkan judul lagu menggunakan `SplitParser`.
4. **Error handling**: Tambahkan `onExited` pada `Process` load average dan cetak peringatan jika `exitCode !== 0`.
5. **Detached**: Buat tombol (atau panggilan di `Component.onCompleted`) yang menjalankan `Quickshell.execDetached(["notify-send", "Halo"])` dan amati bahwa notifikasi tetap muncul meskipun shell di-reload.
6. **Sandbox (opsional)**: Jalankan `cat /proc/loadavg` melalui `systemd-run --user --scope --property=NoNewPrivileges=yes` dan bandingkan hasilnya.

### Checkpoint

- Jelaskan mengapa `environment: ({ PATH: "/usr/bin" })` **saja** belum menghapus variabel rahasia.
- Kapan Anda memilih `SplitParser` daripada `StdioCollector`?
- Apa perbedaan `Process` dan `Quickshell.execDetached` dari sudut pandang lifecycle?
- Mengapa `exclusiveZone` memerlukan 1 atau 3 anchor?
- Apa yang terjadi jika `modelData` tidak dideklarasikan sebagai `required`?

**Jawaban singkat:**

- `environment` **menambahkan/menimpa** variabel, tetapi tidak menghapus yang lain kecuali `clearEnvironment: true`.
- `SplitParser` untuk output streaming per baris; `StdioCollector` untuk output yang dikumpulkan sampai proses selesai.
- `Process` dikelola oleh Quickshell dan bisa dipantau; `execDetached` tidak memiliki objek, tidak bisa dipantau, dan tidak dibunuh saat Quickshell mati.
- `exclusiveZone` mendefinisikan ruang relatif terhadap anchor; dengan hanya 2 anchor berlawanan, dimensi dipaksa penuh sehingga zona tidak masuk akal.
- Tanpa `required`, properti `modelData` bisa `undefined` dan error baru muncul saat runtime, bukan saat kompilasi QML.

---

> *"Panel yang hebat tidak lahir dari widget yang rumit, tetapi dari pemahaman yang jernih tentang di mana ia berdiri dan data apa yang ia bawa."*

---

# Modul 1.3 — Komponen Reusable, Singleton, dan Impor

## 📋 Daftar Isi Internal

1. Deskripsi konkret dan peran dalam kurikulum.
2. Filosofi modularitas: mengapa satu file bukan solusi.
3. Setiap `.qml` adalah komponen: penamaan dan properti.
4. Impor `qs.` vs `root:/` vs relatif — dan mengapa `root:/` harus ditinggalkan.
5. `qmldir`: kapan perlu, kapan tidak — **klarifikasi audit**.
6. Singleton: `pragma Singleton` dan tipe `Singleton`.
7. Kapan singleton tepat, kapan justru anti-pattern.
8. State persisten dengan `Quickshell.stateDir` — **tambahan audit**.
9. Studi kasus: refactor bar Modul 1.2 menjadi komponen + singleton.
10. Terminologi esensial.
11. Visualisasi.
12. Hubungan dengan modul lain.
13. Referensi lengkap.
14. Tips dan praktik terbaik.
15. Potensi kesalahan umum dan solusi.
16. Latihan dan checkpoint.
17. Motivasi penutup.

---

## 1. Deskripsi Konkret dan Peran dalam Kurikulum

Modul ini mengajarkan Anda **memecah shell menjadi bagian-bagian kecil yang dapat digunakan ulang**, lalu **membagikan state global yang statis** melalui singleton, dan **menghubungkan semuanya dengan sistem impor Quickshell yang benar**.

Jika Modul 1.2 menghasilkan bar yang berfungsi tetapi ditulis dalam satu file, Modul 1.3 mengubahnya menjadi **arsitektur yang dapat tumbuh**: `Theme.qml` menyimpan warna dan ukuran, `Clock.qml` menjadi komponen jam yang dapat diparameterisasi, `Bar.qml` merakit keduanya, dan `shell.qml` hanya menjadi entry point tipis yang memasang bar di setiap layar.

**Peran dalam kurikulum:** Modul ini adalah **transisi dari “kode yang berjalan” menjadi “kode yang dapat dipelihara”**. Ia menyiapkan fondasi untuk Modul 1.4 (LSP dan debugging), Modul 2.x (services), dan Modul 3.1 (dependency injection). Tanpa pemahaman impor dan singleton, shell Anda akan menjadi satu file raksasa yang sulit di-debug dan sulit dikembangkan.

---

## 2. Filosofi Modularitas: Mengapa Satu File Bukan Solusi

Bayangkan sebuah bar dengan jam, indikator baterai, volume, workspace, dan tray. Jika semuanya ditulis dalam `shell.qml`, setiap kali Anda memperbaiki satu label, **seluruh file dievaluasi ulang** saat hot reload. Belum lagi jika Anda ingin menampilkan jam yang sama di layar kedua dengan format berbeda: Anda harus menyalin kode, dan salinan itu akan menyimpang seiring waktu.

Modularitas menyelesaikan tiga masalah:

1. **Kognitif**: Anda hanya perlu membaca file yang relevan.
2. **Reuse**: satu `Clock.qml` dapat dipakai di bar, lockscreen, dan OSD.
3. **Isolasi perubahan**: mengubah `Theme.qml` tidak memaksa Anda menyentuh `Bar.qml`.

Dalam QML, modularitas dicapai melalui **file komponen** dan **singleton**. Quickshell menambahkan sistem impor `qs.` yang membuat komponen di dalam direktori shell dapat diimpor dengan path yang stabil dan dikenali LSP.

---

## 3. Setiap `.qml` adalah Komponen: Penamaan dan Properti

Aturan pertama QML: **nama file menjadi nama tipe**. File `Clock.qml` mendefinisikan tipe `Clock`. File `Theme.qml` mendefinisikan tipe `Theme`. Konvensi yang dianjurkan adalah **PascalCase** untuk nama file yang mendefinisikan tipe, karena QML membedakan tipe (huruf besar) dari properti dan id (huruf kecil).

```text
components/
├── Clock.qml      → tipe Clock
├── Bar.qml        → tipe Bar
└── Icon.qml       → tipe Icon
```

Komponen dapat **diparameterisasi** melalui properti:

```qml
// components/Clock.qml
import Quickshell
import QtQuick
import qs.services

Text {
    id: root

    property string format: "HH:mm"

    color: Theme.foreground
    text: Qt.formatDateTime(clock.date, root.format)

    SystemClock {
        id: clock
        precision: root.format.includes("ss")
            ? SystemClock.Seconds
            : SystemClock.Minutes
    }
}
```

**Penjelasan kata per kata:**

- `property string format: "HH:mm"`: properti publik yang dapat diisi oleh pemakai komponen. Ini adalah **API komponen**.
- `color: Theme.foreground`: mengambil warna dari singleton `Theme`. Karena `Theme` adalah singleton, semua komponen membaca instance yang sama.
- `text: Qt.formatDateTime(clock.date, root.format)`: memformat `clock.date` sesuai `format`. `root.format` digunakan agar tidak ambigu dengan properti `format` milik tipe lain.
- `SystemClock { id: clock; precision: ... }`: sumber waktu bawaan Quickshell. `precision` dipilih secara dinamis: jika format memuat `"ss"`, perbarui setiap detik; jika tidak, cukup setiap menit.
- `root.format.includes("ss")`: metode JavaScript `String.includes` untuk mendeteksi apakah format meminta detik. Ini adalah contoh kecil **logika konfigurasi** yang membuat komponen lebih fleksibel tanpa menambah properti baru.

**Mengapa `id: root`?** `id` adalah nama internal untuk merujuk objek dari dalam file yang sama. `root` adalah konvensi umum untuk objek akar komponen. Ia tidak terlihat dari luar; dari luar, komponen diakses melalui nama tipenya dan propertinya.

---

## 4. Impor `qs.` vs `root:/` vs Relatif

### 4.1 Impor Relatif Biasa

File di **direktori yang sama** dapat saling merujuk tanpa impor eksplisit:

```qml
// components/Bar.qml
import Quickshell
import QtQuick
import qs.services

PanelWindow {
    // Clock tersedia karena berada di folder yang sama
    Clock { anchors.centerIn: parent }
}
```

Ini adalah perilaku standar QML: semua file `.qml` dalam satu direktori berada dalam **namespace direktori** yang sama. Namun, file di **subdirektori** tidak otomatis tersedia; Anda perlu mengimpor direktori tersebut.

### 4.2 Impor `root:/` — Fitur Lama yang Harus Ditinggalkan

Banyak konfigurasi lama menggunakan:

```qml
import "root:/components"
```

Ini adalah fitur lama Quickshell. Dokumentasi resmi memperingatkan bahwa impor `root:/` **akan merusak LSP dan singleton**; penggantinya adalah `import qs.` . Jika Anda masih melihat `root:/` di dotfiles orang lain, itu adalah tanda konfigurasi lama.

### 4.3 Impor `qs.` — Standar Quickshell 0.2+

Sejak Quickshell 0.2, sintaks yang benar adalah:

```qml
import qs.path.to.module
```

Di mana `path/to/module` adalah path relatif terhadap **root shell** (`qs`), yaitu direktori yang berisi `shell.qml` . Quickshell memetakan `import qs.Foo.Bar` ke direktori `Foo/Bar` di bawah shell root .

Contoh:

```qml
// shell.qml
import Quickshell
import qs.components

ShellRoot {
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
```

**Penjelasan:**

- `import qs.components`: mengimpor **modul** `components/` relatif terhadap direktori `shell.qml`. Semua tipe di dalamnya (`Bar`, `Clock`, dll.) menjadi tersedia.
- `import qs.services`: mengimpor `services/` sehingga `Theme` dapat diakses.
- `qs` **bukan** `~/.config/quickshell/`, melainkan **shell root** dari konfigurasi yang sedang berjalan. Jika konfigurasi Anda ada di `~/.config/quickshell/my-shell/`, maka `qs.components` berarti `my-shell/components/`.

**Mengapa `qs.` lebih baik?**

1. **Stabil terhadap lokasi**: path tidak bergantung pada `../` yang rapuh.
2. **Dikenali LSP**: `qmlls` dapat menyelesaikan tipe dan memberi autocomplete.
3. **Singleton bekerja dengan benar**: impor `root:/` dapat membuat singleton kehilangan identitasnya.

### 4.4 Perbandingan Tiga Gaya Impor

| Gaya | Contoh | Status | Catatan |
|---|---|---|---|
| Relatif sibling | `Clock {}` tanpa impor | ✅ Standar QML | Hanya untuk file di direktori yang sama. |
| Relatif eksplisit | `import "../components"` | ⚠️ Boleh, tetapi rapuh | Path berubah jika struktur folder berubah. |
| `root:/` | `import "root:/components"` | ❌ Lama | Merusak LSP dan singleton. |
| `qs.` | `import qs.components` | ✅ Direkomendasikan | Relatif terhadap shell root; dikenali LSP. |

---

## 5. `qmldir`: Kapan Perlu, Kapan Tidak — Klarifikasi Audit

Kurikulum asli menyatakan: *“setahu saya tidak mewajibkan `qmldir` manual untuk singleton; verifikasi di panduan resmi versi Anda.”* Audit ini menjawabnya secara eksplisit.

### 5.1 Di Qt QML Biasa, `qmldir` Diperlukan

Dalam Qt QML standar, singleton **harus** didaftarkan melalui C++ atau melalui file `qmldir`:

```text
// qmldir (Qt QML biasa)
module MyModule
singleton Theme 1.0 Theme.qml
```

Tanpa `qmldir`, QML engine tidak tahu bahwa `Theme.qml` adalah singleton .

### 5.2 Di Quickshell, `qmldir` **Tidak** Dibuat Manual

Quickshell memindai direktori shell dan **mensintesis `qmldir` secara otomatis** saat runtime. Karena protokol `qsintercept://`, `qmldir` selalu diperlukan, tetapi Quickshell yang membuatnya untuk Anda . Bahkan ada peringatan eksplisit di dotfiles komunitas: *“Do NOT create a qmldir file — QuickShell synthesises one automatically”* .

**Konsekuensi praktis:**

- Anda **cukup** menambahkan `pragma Singleton` di file dan mengimpornya melalui `import qs.services`. Tidak perlu membuat `qmldir`.
- Jika Anda membuat `qmldir` manual, Anda berisiko **konflik** dengan yang disintesis Quickshell, atau setidaknya membuat konfigurasi lebih rapuh.

### 5.3 Pengecualian: `qmllint` dan LSP

`qmllint` adalah alat statis yang **tidak menjalankan Quickshell scanner**. Ia tidak tahu bahwa Quickshell akan mensintesis `qmldir`. Akibatnya, `qmllint` mungkin tidak dapat menyelesaikan `import qs.services` secara statis.

Ada dua solusi:

1. **Untuk LSP (`qmlls`)**: buat file `.qmlls.ini` di shell root. Quickshell akan mendeteksinya dan mengisinya dengan konfigurasi LSP yang benar, termasuk path impor . File ini bersifat **system-dependent** dan sebaiknya di-`gitignore` .
2. **Untuk `qmllint`**: Anda dapat menghasilkan `qmldir` tiruan untuk keperluan linting saja, bukan untuk runtime. Skrip komunitas melakukan ini: ia menulis satu `qmldir` per direktori yang berisi komponen, semata-mata agar `qmllint` dapat menyelesaikan impor `qs.*` secara statis .

**Ringkasan audit:**

| Konteks | `qmldir` manual? | Alasan |
|---|---|---|
| Runtime Quickshell | ❌ Tidak | Quickshell mensintesis otomatis. |
| `qmllint` statis | ⚠️ Mungkin perlu (generated) | `qmllint` tidak menjalankan scanner Quickshell. |
| LSP `qmlls` | ❌ Tidak; gunakan `.qmlls.ini` | Quickshell mengisi konfigurasi LSP. |
| Modul QML eksternal di `QML2_IMPORT_PATH` | ✅ Ya | Di luar shell root; bukan tanggung jawab scanner Quickshell. |

---

## 6. Singleton: `pragma Singleton` dan Tipe `Singleton`

### 6.1 Deklarasi Dasar

```qml
// services/Theme.qml
pragma Singleton

import Quickshell

Singleton {
    readonly property color background: "#1e1e2e"
    readonly property color foreground: "#cdd6f4"
    readonly property color accent: "#89b4fa"
    readonly property color surface: "#313244"

    readonly property int barHeight: 30
    readonly property int spacing: 8
    readonly property int radius: 6
}
```

**Penjelasan kata per kata:**

- `pragma Singleton`: direktif QML yang memberitahu engine bahwa file ini mendefinisikan **satu instance global**, bukan tipe yang dapat diinstansiasi berkali-kali. Direktif ini harus berada di bagian atas file, sebelum impor dan sebelum tipe root.
- `import Quickshell`: diperlukan untuk tipe `Singleton`.
- `Singleton`: tipe dasar dari Quickshell untuk singleton. Semua singleton sebaiknya mewarisi tipe ini . `Singleton` adalah **non-visual**; ia tidak memiliki rendering, tidak memerlukan parent window, dan tidak menambah beban scene graph.
- `readonly property color background`: properti `color` yang **hanya bisa dibaca** dari luar. Ini adalah praktik terbaik: singleton yang dapat dimutasi dari banyak tempat adalah resep kekacauan .
- `readonly property int barHeight`: konstanta bertipe `int`; lebih baik daripada angka literal yang tersebar.

### 6.2 Mengapa `readonly`?

Bayangkan `Theme.background` dapat diubah oleh `Bar.qml`, `Clock.qml`, dan `Lockscreen.qml` secara bersamaan. Ketika warna menjadi salah, Anda tidak tahu **siapa yang mengubahnya**. Dengan `readonly`, perubahan hanya dapat dilakukan melalui **metode terkontrol** di dalam singleton itu sendiri:

```qml
pragma Singleton
import Quickshell

Singleton {
    property color _background: "#1e1e2e"
    readonly property color background: _background

    function setBackground(c: color): void {
        _background = c
    }
}
```

Namun, bahkan metode terkontrol sebaiknya digunakan dengan hati-hati. Untuk tema yang benar-benar statis, `readonly` saja sudah cukup.

### 6.3 Singleton Non-Visual: Jangan Gunakan `Item`

Kesalahan umum adalah mendeklarasikan singleton dengan `Item`:

```qml
// ❌ Salah
pragma Singleton
import QtQuick
Item {
    property color background: "#1e1e2e"
}
```

`Item` adalah tipe visual yang memerlukan parent dan memiliki overhead rendering. Singleton harus **non-visual**; warisi `Singleton` atau `QtObject`, bukan `Item` atau `Rectangle` .

### 6.4 Siklus Hidup Singleton

QML engine membuat instance singleton **pada akses pertama** dan menggunakannya kembali untuk semua impor berikutnya. Artinya:

- Jika tidak ada komponen yang mengakses `Theme`, singleton tidak dibuat.
- Urutan akses pertama menentukan kapan inisialisasi terjadi.
- Singleton hidup selama QML engine hidup; pada hot reload, engine dapat membuat ulang singleton, sehingga state runtime-nya bisa hilang kecuali dipersistenkan (lihat Bagian 8).

---

## 7. Kapan Singleton Tepat, Kapan Justru Anti-Pattern

### 7.1 Kapan Singleton Tepat

| Kebutuhan | Contoh | Alasan |
|---|---|---|
| Konfigurasi statis | Warna, ukuran bar, spacing, radius | Nilai tidak berubah saat runtime; dibaca banyak komponen. |
| Data perangkat keras global | CPU usage, memori, baterai | Satu sumber data untuk semua konsumen; menghindari polling ganda. |
| Layanan eksternal | Cuaca, network manager, MPRIS | Satu koneksi/state yang dibagi. |
| Event bus global | Sinyal yang didengarkan banyak komponen | Satu kanal komunikasi. |
| Cache sumber daya | Lookup ikon, font | Menghemat biaya berulang. |

### 7.2 Kapan Singleton **Tidak** Tepat

| Skenario | Alternatif | Alasan |
|---|---|---|
| Komponen dengan state lokal | Tipe QML biasa | State hanya relevan untuk satu instance. |
| Fungsi utilitas murni | File `.js` | Tidak perlu state; singleton menambah kompleksitas. |
| Data yang berbeda per layar | `Variants` + `modelData` | Singleton akan membagikan nilai yang sama ke semua layar. |
| State sementara/modal | Properti lokal pada parent | Singleton membuat state “bocor” ke seluruh shell. |
| Dependensi dinamis antar layanan | Properti eksplisit / dependency injection | Singleton menyembunyikan ketergantungan dan menyulitkan pengujian. |

### 7.3 Anti-Pattern: Singleton sebagai Service Locator

Menggunakan singleton untuk **menyembunyikan dependensi** adalah anti-pattern:

```qml
// ❌ Sulit diuji dan dipahami
Singleton {
    property var audioService: AudioService {}
    property var networkService: NetworkService {}
}
```

Komponen yang mengakses `Global.audioService` tidak menyatakan dependensinya secara eksplisit. Lebih baik mengirim dependensi melalui properti:

```qml
// ✅ Dependensi eksplisit
VolumeWidget {
    audio: AudioService {}
}
```

Ini akan dibahas lebih dalam di Modul 3.1.

### 7.4 Anti-Pattern: Singleton dengan State yang Dapat Dimutasi

Jika beberapa komponen dapat menulis ke properti singleton yang sama, Anda kehilangan **kepemilikan state**. Gunakan `readonly` dan, jika mutasi diperlukan, sediakan metode yang terkontrol dan terdokumentasi .

### 7.5 Anti-Pattern: Dependensi Sirkular

Singleton A mengimpor B, dan B mengimpor A. Ini dapat menyebabkan **deadlock inisialisasi**. Pecahkan siklus dengan menggabungkan keduanya atau memperkenalkan singleton ketiga yang menjadi perantara .

---

## 8. State Persisten dengan `Quickshell.stateDir` — Tambahan Audit

Singleton hidup selama QML engine hidup. Saat hot reload, engine dapat membuat ulang singleton, sehingga nilai yang diubah saat runtime **hilang**. Untuk state yang harus bertahan antar-reload dan antar-restart, gunakan `Quickshell.stateDir`.

`Quickshell.stateDir` adalah direktori state per-shell, biasanya `~/.local/state/quickshell/by-shell/<shell-id>`. Nilainya dapat ditimpa dengan `//@ pragma StateDir $BASE/path` di root QML .

```qml
pragma Singleton
import Quickshell

Singleton {
    readonly property string stateFile: Quickshell.stateDir + "/theme-state.json"
}
```

**Penjelasan:**

- `Quickshell.stateDir`: path direktori state yang disediakan Quickshell. Berbeda dari `dataDir` (untuk data jangka panjang) dan `cacheDir` (untuk cache yang boleh hilang).
- `stateFile`: path file JSON untuk menyimpan state kecil, misalnya varian tema terakhir.
- Untuk membaca/menulis, gunakan `FileView` atau `Process`; implementasi detailnya akan dibahas saat modul I/O. Yang penting di sini adalah **prinsip**: jangan menyimpan state persisten di dalam singleton tanpa mekanisme persistensi.

**Peringatan keamanan:** `stateDir` dapat dibaca oleh proses lain dengan hak yang sama. Jangan menyimpan token, kata sandi, atau data sensitif di sana.

---

## 9. Studi Kasus: Refactor Bar Modul 1.2

### 9.1 Struktur Akhir

```text
my-shell/
├── shell.qml
├── components/
│   ├── Bar.qml
│   └── Clock.qml
└── services/
    └── Theme.qml
```

### 9.2 `services/Theme.qml`

```qml
pragma Singleton

import Quickshell

Singleton {
    readonly property color background: "#1e1e2e"
    readonly property color foreground: "#cdd6f4"
    readonly property int barHeight: 30
}
```

### 9.3 `components/Clock.qml`

```qml
import Quickshell
import QtQuick
import qs.services

Text {
    id: root

    property string format: "HH:mm"

    color: Theme.foreground
    text: Qt.formatDateTime(clock.date, root.format)

    SystemClock {
        id: clock
        precision: root.format.includes("ss")
            ? SystemClock.Seconds
            : SystemClock.Minutes
    }
}
```

### 9.4 `components/Bar.qml`

```qml
import Quickshell
import QtQuick
import qs.services

PanelWindow {
    required property var modelData

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    color: "transparent"

    Clock {
        anchors.centerIn: parent
        format: "HH:mm:ss"
    }
}
```

**Penjelasan:**

- `required property var modelData`: wajib ada karena `Bar` digunakan di dalam `Variants`; `Variants` akan mengisi properti ini dengan `ShellScreen`.
- `screen: modelData`: menempatkan panel di layar yang sesuai.
- `implicitHeight: Theme.barHeight`: tinggi bar diambil dari singleton, bukan angka literal.
- `Clock { format: "HH:mm:ss" }`: komponen jam digunakan ulang dengan format yang berbeda dari default.

### 9.5 `shell.qml`

```qml
import Quickshell
import qs.components

ShellRoot {
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
```

**Penjelasan:**

- `import qs.components`: mengimpor folder `components/` relatif terhadap `shell.qml`.
- `Variants { model: Quickshell.screens; Bar {} }`: satu `Bar` per layar. `Variants` menyuntikkan `modelData` ke properti `required` di `Bar`.

### 9.6 Alur Dependensi

```text
shell.qml
   │  import qs.components
   ▼
Bar.qml ──import qs.services──► Theme.qml (singleton)
   │
   │  Clock tersedia karena satu direktori
   ▼
Clock.qml ──import qs.services──► Theme.qml (instance yang sama)
```

**Penjelasan:** `Theme` hanya dibuat sekali. `Bar` dan `Clock` membaca instance yang sama. Jika warna `Theme.foreground` diubah saat pengembangan dan hot reload terjadi, kedua komponen melihat perubahan yang sama.

---

## 10. Terminologi Esensial

| Istilah | Definisi | Contoh/Konteks |
|---|---|---|
| **Komponen reusable** | File `.qml` yang mendefinisikan tipe baru dan dapat diparameterisasi. | `Clock.qml` → `Clock { format: "HH:mm:ss" }` |
| **`pragma Singleton`** | Direktif QML yang menandai file sebagai singleton. | `pragma Singleton` di awal `Theme.qml`. |
| **`Singleton`** | Tipe dasar Quickshell untuk singleton non-visual. | `Singleton { readonly property color ... }` |
| **`qs.` import** | Impor modul relatif terhadap shell root. | `import qs.services` |
| **Shell root** | Direktori yang berisi `shell.qml`; titik nol bagi `qs.` | `~/.config/quickshell/my-shell/` |
| **`qmldir`** | File pendaftaran modul QML standar. | Tidak dibuat manual di Quickshell runtime. |
| **Synthesized `qmldir`** | `qmldir` yang dibuat otomatis oleh Quickshell saat runtime. | Memungkinkan `import qs.services` tanpa file manual. |
| **Root import** | Impor lama `import "root:/..."`. | Merusak LSP dan singleton; gunakan `qs.` |
| **`.qmlls.ini`** | File konfigurasi LSP yang diisi Quickshell. | Harus di-`gitignore`. |
| **`Quickshell.stateDir`** | Direktori state per-shell yang persisten. | `~/.local/state/quickshell/by-shell/<id>/` |
| **Property injection** | Mengirim dependensi lewat properti secara eksplisit. | `VolumeWidget { audio: audioService }` |
| **Service locator** | Anti-pattern menyembunyikan dependensi di singleton global. | `Global.audioService` |
| **Circular dependency** | Singleton A bergantung pada B, B pada A. | Menyebabkan deadlock inisialisasi. |

---

## 11. Visualisasi

### 11.1 Pohon Impor dan Kepemilikan Singleton

```text
my-shell/                          ← shell root (qs)
├── shell.qml                      ← import qs.components
├── components/
│   ├── Bar.qml                    ← import qs.services → Theme
│   └── Clock.qml                  ← import qs.services → Theme (instance sama)
└── services/
    └── Theme.qml                  ← pragma Singleton; satu instance global
```

### 11.2 Keputusan: Singleton atau Bukan?

```text
Apakah nilai/state ini:
├── Statis dan dibaca banyak komponen?
│   └── YA → Singleton (readonly)
├── Berbeda per layar?
│   └── YA → Variants + modelData
├── Hanya relevan untuk satu instance komponen?
│   └── YA → Properti lokal biasa
├── Fungsi murni tanpa state?
│   └── YA → File .js
└── Dependensi dinamis yang perlu diganti saat pengujian?
    └── YA → Property injection, bukan singleton
```

### 11.3 Alur Impor yang Benar

```text
shell.qml
   │
   │  import qs.components   ✅
   │  import "root:/..."     ❌ (merusak LSP & singleton)
   ▼
components/Bar.qml
   │
   │  import qs.services     ✅
   ▼
services/Theme.qml (singleton)
```

---

## 12. Hubungan dengan Modul Lain

- **Modul 1.4 (Debugging, LSP, Autostart)**: `.qmlls.ini` dan impor `qs.` yang diperkenalkan di sini adalah prasyarat agar LSP dapat menyelesaikan tipe dan singleton. Tanpa `qs.`, `qmlls` akan melaporkan error palsu.
- **Modul 2.x (Services)**: singleton adalah tulang punggung services. Pemahaman `readonly`, lifecycle, dan anti-pattern di sini akan langsung terpakai.
- **Modul 3.1 (Dependency Injection)**: Modul 1.3 memperkenalkan kapan singleton **tidak** tepat. Modul 3.1 akan memperdalam property injection dan pengujian.
- **Modul 1.2 (`Variants`)**: `Bar.qml` menggunakan `required property var modelData` yang diperkenalkan di Modul 1.2. Jika Anda melewatkan Modul 1.2, bagian ini akan terasa membingungkan.

---

## 13. Referensi Lengkap

- **Quickshell Introduction — Config Files & Root Imports**: [https://quickshell.org/docs/v0.3.1/guide/introduction/](https://quickshell.org/docs/v0.3.1/guide/introduction/) — peringatan `root:/` merusak LSP dan singleton .
- **Quickshell Changelog v0.2.0 — Root-Relative Imports & `.qmlls.ini`**: [https://github.com/quickshell-mirror/quickshell/blob/9b0f339b19057f4731bf3b48293307d7ef241671/changelog/v0.2.0.md](https://github.com/quickshell-mirror/quickshell/blob/9b0f339b19057f4731bf3b48293307d7ef241671/changelog/v0.2.0.md) — sintaks `import qs.path.to.module` dan konfigurasi LSP .
- **Quickshell — Singleton Type**: [https://quickshell.org/docs/v0.2.0/types/Quickshell/Singleton/](https://quickshell.org/docs/v0.2.0/types/Quickshell/Singleton/) — semua singleton sebaiknya mewarisi tipe ini .
- **Quickshell — Quickshell Type (`stateDir`, `shellDir`, `screens`)**: [https://quickshell.org/docs/v0.2.1/types/Quickshell/Quickshell/](https://quickshell.org/docs/v0.2.1/types/Quickshell/Quickshell/) — `stateDir` dan path per-shell .
- **The Quickshell Book — Singletons**: [https://programmersd21.github.io/the_quickshell_book/part-10-architecture/singletons](https://programmersd21.github.io/the_quickshell_book/part-10-architecture/singletons) — perbedaan singleton Qt vs Quickshell, anti-pattern, dan kapan menggunakannya .
- **The Quickshell Book — Config Structure and Imports**: [https://programmersd21.github.io/the_quickshell_book/part-2-quickshell/config-structure-and-imports](https://programmersd21.github.io/the_quickshell_book/part-2-quickshell/config-structure-and-imports) — struktur komponen dan `qs.` import.
- **DeepWiki — Configuration Files and Structure (qmldir synthesis)**: [https://deepwiki.com/quickshell-mirror/quickshell](https://deepwiki.com/quickshell-mirror/quickshell) — Quickshell mensintesis `qmldir` untuk direktori .
- **Qt Documentation — Directory Imports**: [https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html](https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html) — dasar impor direktori QML.
- **Qt Documentation — `qmldir` Files**: [https://doc.qt.io/qt-6/qtqml-modules-qmldir.html](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html) — format `qmldir` dan registrasi singleton di Qt standar.

---

## 14. Tips dan Praktik Terbaik

1. **Satu tipe per file, PascalCase.** `Clock.qml`, bukan `clock.qml`. Ini memudahkan QML dan LSP membedakan tipe dari properti.
2. **Gunakan `import qs.`**, bukan `root:/`. Ini bukan preferensi gaya; `root:/` benar-benar merusak LSP dan singleton .
3. **Jangan membuat `qmldir` manual untuk runtime Quickshell.** Quickshell sudah mensintesisnya. Buat hanya jika Anda tahu itu untuk `qmllint` atau modul eksternal.
4. **Tambahkan `.qmlls.ini` ke `.gitignore`.** File ini diisi otomatis oleh Quickshell dan bersifat system-dependent .
5. **Jadikan properti singleton `readonly` kecuali benar-benar perlu mutasi.** Jika mutasi diperlukan, sediakan metode terkontrol.
6. **Jangan mewarisi `Item` untuk singleton.** Gunakan `Singleton` atau `QtObject`; singleton harus non-visual .
7. **Jangan gunakan singleton untuk data per-layar.** Gunakan `Variants` + `modelData`.
8. **Jangan jadikan singleton sebagai service locator.** Kirim dependensi lewat properti agar eksplisit dan mudah diuji.
9. **Hindari dependensi sirkular antar-singleton.** Jika A dan B saling membutuhkan, gabungkan atau perkenalkan perantara.
10. **Gunakan `Quickshell.stateDir` untuk state persisten**, bukan menyimpannya di properti singleton yang akan hilang saat reload.
11. **Untuk resource bersama di luar `Variants`**, gunakan `Scope` agar `Process`/`Timer` tidak terduplikasi per layar .
12. **Dokumentasikan singleton Anda.** Karena singleton adalah global, daftar singletons dan tanggung jawabnya harus jelas.

---

## 15. Potensi Kesalahan Umum dan Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| **Membuat `qmldir` manual** | Konflik dengan `qmldir` sintesis; impor tidak konsisten. | Hapus `qmldir` manual; biarkan Quickshell mensintesis. |
| **Menggunakan `import "root:/..."`** | LSP tidak berfungsi; singleton terduplikasi/rusak. | Ganti dengan `import qs.path.to.module`. |
| **Lupa `import qs.services`** | `Theme is not defined`. | Tambahkan impor modul yang sesuai. |
| **Meletakkan `Theme.qml` di luar shell root** | `import qs.services` tidak menemukan tipe. | Pastikan `Theme.qml` berada di `services/` di dalam shell root. |
| **Menggunakan `Item` sebagai root singleton** | Overhead rendering; error parent. | Gunakan `Singleton` atau `QtObject`. |
| **Singleton dengan properti mutable** | Nilai berubah tanpa jejak; sulit di-debug. | Gunakan `readonly`; mutasi melalui metode terkontrol. |
| **Menggunakan singleton untuk data per-layar** | Semua layar menampilkan nilai yang sama. | Gunakan `Variants` + `modelData`. |
| **Dependensi sirkular** | Deadlock inisialisasi; singleton `undefined`. | Pecahkan siklus dengan menggabungkan atau perantara. |
| **Mengira `qs` adalah `~/.config/quickshell`** | Impor gagal saat config berada di subfolder. | `qs` adalah shell root, yaitu folder `shell.qml`. |
| **Mengandalkan `qmllint` tanpa `qmldir` generated** | `qmllint` melaporkan impor `qs.*` tidak ditemukan. | Gunakan `.qmlls.ini` untuk LSP; generate `qmldir` hanya untuk linting. |
| **Menyimpan token di `stateDir`** | Kebocoran kredensial. | Jangan menyimpan data sensitif di state publik. |

---

## 16. Latihan dan Checkpoint

### Latihan

1. **Refactor bar Modul 1.2** menjadi struktur `components/Bar.qml`, `components/Clock.qml`, dan `services/Theme.qml`.
2. **Tambahkan properti `format`** pada `Clock.qml` dan gunakan `format.includes("ss")` untuk memilih `SystemClock.Seconds` atau `SystemClock.Minutes`.
3. **Jadikan `Theme.barHeight` sebagai `readonly property int`** dan gunakan di `Bar.qml`.
4. **Pastikan `shell.qml` hanya berisi entry point tipis**: `Variants` + `Bar`.
5. **Uji hot reload**: ubah `Theme.foreground` dan simpan; pastikan jam dan bar bereaksi tanpa restart.
6. **Buat kesalahan sengaja**: ganti `import qs.services` menjadi `import "root:/services"`; amati apakah LSP dan singleton masih bekerja.
7. **Periksa `.qmlls.ini`**: buat file kosong di shell root, jalankan Quickshell, lalu lihat isinya. Jangan commit file tersebut.

### Checkpoint

- Mengapa `import qs.services` lebih baik daripada `import "root:/services"`?
- Mengapa Anda **tidak** perlu membuat `qmldir` manual di Quickshell?
- Beri satu contoh nilai yang pantas menjadi singleton dan satu yang tidak.
- Apa perbedaan `Quickshell.stateDir` dan properti singleton biasa?
- Mengapa singleton tidak boleh mewarisi `Item`?
- Apa yang terjadi jika Anda menggunakan singleton untuk data yang berbeda per layar?

**Jawaban singkat:**

- `qs.` stabil, dikenali LSP, dan tidak merusak singleton; `root:/` adalah fitur lama yang bermasalah.
- Quickshell mensintesis `qmldir` saat runtime; manual hanya diperlukan untuk `qmllint` atau modul eksternal.
- Pantas: `Theme.foreground`. Tidak pantas: state “apakah popup terbuka” yang hanya relevan untuk satu instance.
- `stateDir` adalah direktori filesystem yang persisten; properti singleton hilang saat QML engine di-reload.
- `Item` adalah tipe visual dengan overhead rendering dan memerlukan parent window; singleton harus non-visual.
- Semua layar akan membaca nilai yang sama, sehingga perubahan pada satu layar akan “bocor” ke layar lain.

---

> *“Kode yang baik bukan yang paling pintar, tetapi yang paling jujur tentang batas-batasnya. Singleton yang jujur adalah singleton yang tahu kapan ia tidak dibutuhkan.”*

---

# Modul 1.4 — Debugging, Logging, LSP, dan Autostart

## 📋 Daftar Isi Internal

1. Deskripsi konkret dan peran dalam kurikulum.
2. Filosofi debugging: dari log ke linting ke debugger.
3. `quickshell log` vs `qs log` — klarifikasi audit.
4. `qmllint` dan `.qmlls.ini` untuk LSP — verifikasi audit.
5. `console.log` dan inspeksi nilai runtime.
6. Crash handler dan `gdb` — audit tambahan.
7. Autostart: `exec-once`/`exec` vs unit `systemd --user`.
8. `graphical-session.target` dan ketergantungan pada compositor.
9. Sandboxing autostart — tambahan audit.
10. Kebersihan log dan anonimitas.
11. Studi kasus: dari crash ke perbaikan.
12. Terminologi esensial.
13. Visualisasi.
14. Hubungan dengan modul lain.
15. Referensi lengkap.
16. Tips dan praktik terbaik.
17. Potensi kesalahan umum dan solusi.
18. Latihan dan checkpoint.
19. Motivasi penutup.

---

## 1. Deskripsi Konkret dan Peran dalam Kurikulum

Modul ini mengajarkan Anda **berdiri di atas kaki sendiri**: menemukan galat, membacanya, memperbaikinya, dan memastikan shell Anda **hidup kembali secara otomatis** ketika sesi dimulai atau ketika terjadi crash. Ini adalah modul yang mengubah Anda dari “penulis kode” menjadi “operator sistem”.

Jika Modul 1.1–1.3 menghasilkan shell yang *berjalan*, Modul 1.4 memastikan shell itu *tetap berjalan* dan *dapat diperbaiki* ketika sesuatu salah. Tanpa kemampuan debugging dan autostart, setiap kesalahan kecil akan terasa seperti kegagalan total; dengan modul ini, kesalahan menjadi **informasi**.

**Peran dalam kurikulum:** Modul 1.4 adalah **penutup Fase 1** dan **gerbang menuju Fase 2**. Ia memvalidasi bahwa Anda dapat bekerja secara mandiri: membaca log, menggunakan LSP, dan mengawasi proses. Semua modul berikutnya mengasumsikan Anda sudah bisa melakukan ini.

---

## 2. Filosofi Debugging: dari Log ke Linting ke Debugger

Debugging bukan satu aktivitas, melainkan **tangga eskalasi**:

1. **Log**: Apa yang dikatakan program tentang dirinya sendiri?
2. **Linting statis**: Apakah ada kesalahan yang bisa dideteksi *tanpa menjalankan* kode?
3. **Inspeksi runtime**: Nilai apa yang sebenarnya dimiliki variabel saat program berjalan?
4. **Debugger**: Di mana tepatnya program berhenti, dan mengapa?

Quickshell menganut filosofi yang sama. Ia mencetak error QML ke **stderr**; `qmllint` memeriksa validitas sintaks dan anti-pattern; `console.log`/`console.warn`/`console.error`/`console.trace` memberi Anda jendela ke runtime; dan crash handler menangkap kegagalan fatal dengan backtrace.

**Prinsip keamanan:** log adalah **kotak hitam**. Ia bisa memuat path, keluaran proses, dan data pribadi. Jangan mencetak kredensial, token, atau input sensitif. Periksa isi log sebelum membagikannya ke publik atau ke pelacak bug.

---

## 3. `quickshell log` vs `qs log` — Klarifikasi Audit

### 3.1 Perintah yang Benar

Quickshell memiliki subperintah `log`:

```bash
quickshell log
```

Jika Anda memiliki alias atau symlink `qs`, maka `qs log` juga bekerja. Namun, **`quickshell` adalah binary yang sebenarnya**; `qs` hanyalah nama pendek yang umum digunakan komunitas. Jangan mengasumsikan `qs` tersedia di semua sistem.

`quickshell log` membaca log dari instance yang sedang berjalan. Dokumentasi komunitas menyebutkan bahwa perintah ini menampilkan log **ringkas** dari layanan Quickshell, dan berguna ketika hot reload saja tidak cukup untuk memahami masalah.

### 3.2 Opsi `--follow` dan `--tail`

Subperintah `log` memiliki opsi `--follow` dan `--tail` untuk mengikuti log secara real-time:

```bash
quickshell log --follow
quickshell log --tail 50
```

**Penjelasan:**

- `--follow`: tetap membuka stream dan mencetak baris baru saat muncul, mirip `tail -f`.
- `--tail N`: menampilkan N baris terakhir sebelum mengikuti.

Ini sangat berguna saat Anda mengembangkan `Process` atau mendiagnosis crash yang jarang terjadi.

### 3.3 Alternatif: Menjalankan dari Terminal

Cara paling langsung untuk melihat **semua** output, termasuk error QML, adalah menjalankan Quickshell dari terminal dengan stderr dialihkan:

```bash
quickshell -c my-shell 2>&1 | tee /tmp/quickshell.log
```

**Penjelasan:**

- `2>&1`: menggabungkan stderr ke stdout.
- `| tee /tmp/quickshell.log`: menampilkan output di terminal **dan** menyimpannya ke file.
- Ini menangkap error yang mungkin tidak muncul di `quickshell log` karena log tersebut hanya membaca buffer log instance.

---

## 4. `qmllint` dan `.qmlls.ini` untuk LSP — Verifikasi Audit

### 4.1 `qmllint`: Pemeriksaan Statis

`qmllint` adalah alat yang dikirim bersama Qt yang **memverifikasi validitas sintaks file QML** dan memperingatkan tentang **anti-pattern**. Ia dapat mendeteksi:

- Akses properti yang tidak memenuhi syarat.
- Penggunaan signal handler tanpa sinyal yang cocok.
- Penggunaan `with` dalam QML.
- Impor yang tidak digunakan.
- Komponen dan properti yang usang.
- Masalah terkait kompilasi QML.

`qmllint` memerlukan **informasi tipe** dari modul QML di jalur impor. Direktori saat ini dan tipe bawaan Qt digunakan secara default; jalur tambahan dapat ditambahkan dengan `-I`.

```bash
/usr/lib/qt6/bin/qmllint -I . shell.qml
```

**Penjelasan:**

- `-I .`: menambahkan direktori saat ini ke jalur impor, sehingga `import qs.services` dapat diselesaikan **jika** `qmldir` tersedia.
- **Masalah:** Quickshell mensintesis `qmldir` saat runtime, tetapi `qmllint` tidak menjalankan scanner Quickshell. Akibatnya, `qmllint` mungkin melaporkan impor `qs.*` tidak ditemukan.

**Solusi audit:** Untuk keperluan linting, Anda dapat menghasilkan `qmldir` tiruan di setiap direktori yang berisi komponen. Ini **hanya untuk `qmllint`**, bukan untuk runtime. Skrip komunitas melakukan ini secara otomatis.

### 4.2 `.qmlls.ini`: Konfigurasi LSP

Untuk editor yang mendukung **Language Server Protocol** (`qmlls`), Quickshell menyediakan mekanisme konfigurasi otomatis:

1. Buat file kosong bernama `.qmlls.ini` **di samping `shell.qml`**.
2. Quickshell akan **menggantinya** dengan konfigurasi `qmlls` yang dikelola.

```bash
touch ~/.config/quickshell/my-shell/.qmlls.ini
```

**Penjelasan:**

- File ini **tidak** boleh di-commit ke Git karena berisi path yang bergantung pada sistem.
- Setelah Quickshell dijalankan, file akan berisi konfigurasi seperti `importPaths` yang memungkinkan `qmlls` menyelesaikan `import qs.*`.
- Tanpa `.qmlls.ini`, LSP tidak akan mengenali impor `qs.` dan akan melaporkan error palsu.

### 4.3 Peringatan `root:/` untuk LSP

Dokumentasi resmi memperingatkan bahwa impor `root:/` **akan merusak LSP dan singleton**. Ini adalah alasan tambahan mengapa Modul 1.3 menekankan `import qs.`而不是 `import "root:/..."`. Jika Anda masih menggunakan `root:/`, LSP tidak akan bekerja dengan benar, dan Anda akan kehilangan autocomplete serta navigasi tipe.

---

## 5. `console.log` dan Inspeksi Nilai Runtime

### 5.1 Tingkat Log

QML menyediakan empat fungsi logging:

```qml
console.log("informasi")      // stdout
console.warn("peringatan")    // stderr
console.error("kesalahan")    // stderr
console.trace("jejak")        // stderr + stack trace
```

**Penjelasan:**

- `console.log`: untuk informasi umum; muncul di stdout.
- `console.warn`: untuk kondisi yang tidak ideal tetapi tidak fatal.
- `console.error`: untuk kesalahan yang perlu perhatian.
- `console.trace`: seperti `console.error`, tetapi menyertakan **stack trace**; sangat berguna untuk mengetahui dari mana fungsi dipanggil.

### 5.2 Inspeksi Nilai

Anda dapat mencetak nilai properti atau objek:

```qml
Component.onCompleted: {
    console.log("Screens:", Quickshell.screens.length)
    console.log("Nama layar pertama:", Quickshell.screens[0]?.name)
}
```

**Penjelasan:**

- `Component.onCompleted`: handler yang dipanggil setelah komponen selesai dibuat; tempat yang baik untuk logging awal.
- `Quickshell.screens.length`: jumlah layar yang terdeteksi.
- `?.`: optional chaining JavaScript; mencegah error jika `screens[0]` tidak ada.

**Peringatan keamanan:** Jangan pernah mencetak objek yang mungkin mengandung token, kata sandi, atau data pribadi. Jika Anda perlu mencetak struktur, gunakan `JSON.stringify` dengan pemfilteran, atau cetak hanya field yang aman.

---

## 6. Crash Handler dan `gdb` — Audit Tambahan

### 6.1 Crash Handler Quickshell

Quickshell memiliki **crash handler** yang menangkap crash, menulis laporan, dan **me-restart Quickshell**. Secara historis ia menggunakan Breakpad, tetapi sejak versi terbaru telah diganti dengan **`cpptrace`**, yang lebih mudah dipaketkan.

**Lokasi laporan crash:** `~/.cache/quickshell/crashes/`. Setiap crash membuat direktori dengan `info.txt`, `log.qslog.log`, dan `minidump.dmp.log`.

**Menonaktifkan crash handler:** Jika Anda perlu men-debug dengan `gdb` atau ingin melihat crash secara langsung tanpa restart otomatis, set environment variable:

```bash
QS_DISABLE_CRASH_HANDLER=1 quickshell -c my-shell
```

**Penjelasan:**

- `QS_DISABLE_CRASH_HANDLER=1`: variabel environment yang dibaca Quickshell untuk menonaktifkan crash handler.
- Dengan ini, Quickshell akan crash dan berhenti, sehingga Anda dapat menjalankannya di bawah `gdb`.

### 6.2 `gdb` untuk Crash

```bash
gdb --args quickshell -c my-shell
```

Di dalam `gdb`:

```gdb
run
bt
```

**Penjelasan:**

- `gdb --args`: menjalankan `gdb` dengan argumen yang akan diteruskan ke program.
- `run`: memulai program.
- `bt`: **backtrace**; menampilkan stack trace saat crash.

**Catatan:** Untuk backtrace yang bermakna, Anda memerlukan **debug symbols**. Pada Arch, instal `quickshell-debug` jika tersedia, atau bangun dari source dengan `-DCMAKE_BUILD_TYPE=Debug`.

### 6.3 Kapan Menggunakan Apa

| Skenario | Alat |
|---|---|
| Error QML biasa | `console.error`, `quickshell log` |
| Kesalahan sintaks/anti-pattern | `qmllint` |
| Nilai runtime tidak sesuai | `console.log` |
| Crash berulang | Laporan crash di `~/.cache/quickshell/crashes/` |
| Crash yang perlu di-debug mendalam | `QS_DISABLE_CRASH_HANDLER=1` + `gdb` |

---

## 7. Autostart: `exec-once`/`exec` vs Unit `systemd --user`

### 7.1 Pendekatan Compositor: `exec-once`

Hyprland:

```ini
exec-once = qs -c my-shell --no-duplicate
```

Sway:

```ini
exec qs -c my-shell --no-duplicate
```

**Penjelasan:**

- `exec-once`: menjalankan perintah **sekali** saat compositor dimulai; tidak dijalankan ulang saat konfigurasi di-reload.
- `exec`: menjalankan setiap kali konfigurasi di-reload (Sway).
- `--no-duplicate`: mencegah instance ganda; flag ini sudah diperkenalkan di Modul 1.1.

**Keterbatasan:** `exec-once` **tidak memiliki pengawasan**. Jika Quickshell crash, ia tidak akan di-restart otomatis. Compositor tidak tahu bahwa proses anak gagal.

### 7.2 Pendekatan systemd: Unit `--user`

```ini
# ~/.config/systemd/user/quickshell.service
[Unit]
Description=Quickshell
PartOf=graphical-session.target
After=graphical-session.target

[Service]
ExecStart=/usr/bin/quickshell -c my-shell --no-duplicate
Restart=on-failure
NoNewPrivileges=yes

[Install]
WantedBy=graphical-session.target
```

**Penjelasan kata per kata:**

- `[Unit]`: bagian metadata dan dependensi.
- `Description`: deskripsi manusiawi.
- `PartOf=graphical-session.target`: unit ini **dihentikan** ketika `graphical-session.target` berhenti. Ini memastikan Quickshell tidak tertinggal saat sesi berakhir.
- `After=graphical-session.target`: unit dimulai **setelah** target aktif; memastikan compositor sudah siap.
- `[Service]`: bagian perilaku proses.
- `ExecStart`: perintah yang dijalankan. `--no-duplicate` mencegah instance ganda.
- `Restart=on-failure`: systemd **menjalankan ulang** unit jika proses keluar dengan kode non-zero. Ini adalah **pengawasan** yang tidak dimiliki `exec-once`.
- `NoNewPrivileges=yes`: properti keamanan; mencegah proses menaikkan privilege (misalnya via setuid).
- `[Install]`: bagian yang menentukan kapan unit diaktifkan.
- `WantedBy=graphical-session.target`: unit diaktifkan ketika target tersebut aktif.

**Mengaktifkan:**

```bash
systemctl --user daemon-reload
systemctl --user enable --now quickshell.service
```

**Melihat log:**

```bash
journalctl --user -u quickshell -f
```

### 7.3 Perbandingan

| Aspek | `exec-once` | systemd `--user` |
|---|---|---|
| Restart otomatis | ❌ Tidak | ✅ `Restart=on-failure` |
| Log terpusat | ❌ Harus diarahkan manual | ✅ `journalctl --user` |
| Ketergantungan sesi | ✅ Compositor menangani | ⚠️ Perlu `graphical-session.target` |
| Sandboxing | ❌ Tidak ada | ✅ Properti keamanan systemd |
| Portabilitas | ✅ Bekerja di semua compositor | ⚠️ Perlu systemd + target yang tepat |

---

## 8. `graphical-session.target` dan Ketergantungan pada Compositor

`graphical-session.target` **hanya aktif** jika compositor mengaktifkannya. Ini adalah detail yang sering terlewat.

- **Hyprland** dengan `uwsm`: `uwsm` mengaktifkan `graphical-session.target` secara otomatis.
- **Hyprland** tanpa `uwsm`: `graphical-session.target` mungkin **tidak aktif**, sehingga unit `WantedBy=graphical-session.target` tidak akan dijalankan. Solusinya adalah menggunakan target spesifik compositor, misalnya `hyprland-session.target`, atau mengaktifkan target secara manual.
- **Sway** dengan `sway-systemd` atau `uwsm`: target diaktifkan dengan benar.
- **Compositor lain**: periksa apakah mereka mengaktifkan `graphical-session.target`; jika tidak, gunakan `exec-once` atau target khusus.

**Peringatan audit:** Menggunakan `WantedBy=graphical-session.target` di lingkungan yang tidak mengaktifkan target tersebut akan menghasilkan **unit yang tidak pernah berjalan**. Selalu verifikasi dengan:

```bash
systemctl --user status graphical-session.target
```

Jika statusnya `inactive (dead)`, unit Anda tidak akan dijalankan.

---

## 9. Sandboxing Autostart — Tambahan Audit

`NoNewPrivileges=yes` hanyalah **langkah pertama**. Untuk isolasi yang lebih kuat, tambahkan properti systemd berikut pada unit `--user`:

```ini
[Service]
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=read-only
RestrictSUIDSGID=yes
SystemCallFilter=@system-service
```

**Penjelasan:**

- `PrivateTmp=yes`: memberikan `/tmp` privat; mengurangi serangan symlink.
- `ProtectSystem=strict`: membuat seluruh filesystem **read-only** kecuali `/dev`, `/proc`, dan `/sys`.
- `ProtectHome=read-only`: membuat direktori home **read-only**; Quickshell masih bisa membaca konfigurasi tetapi tidak menulis.
- `RestrictSUIDSGID=yes`: mencegah pembuatan file setuid/setgid.
- `SystemCallFilter=@system-service`: membatasi syscall ke subset yang aman untuk layanan sistem.

**Peringatan:** Quickshell perlu menulis ke `~/.cache` dan `~/.local/state`. Jika Anda menggunakan `ProtectHome=read-only`, Anda harus **mengecualikan** direktori tersebut dengan `ReadWritePaths=`:

```ini
ReadWritePaths=%h/.cache/quickshell %h/.local/state/quickshell
```

**Catatan:** `ProtectSystem=strict` dan beberapa properti lain memerlukan **systemd user manager** yang berjalan dengan hak yang memadai; di beberapa distro, properti ini mungkin ditolak untuk unit `--user`. Uji terlebih dahulu.

**Alternatif untuk proses anak:** Untuk `Process` di dalam Quickshell, gunakan `systemd-run --user --scope` atau `bwrap` seperti yang dibahas di Modul 1.2. Ini memberikan isolasi **per proses**, bukan hanya untuk seluruh shell.

---

## 10. Kebersihan Log dan Anonimitas

Log bisa memuat:

- Path lengkap (`/home/username/...`).
- Keluaran proses (misalnya, judul lagu, nama file).
- Pesan error yang menyertakan nilai variabel.
- Crash report dengan backtrace yang memuat nama simbol.

**Prinsip:**

1. **Jangan mencetak kredensial.** Token, kata sandi, kunci API tidak boleh masuk log.
2. **Filter sebelum membagikan.** Jika Anda melaporkan bug, periksa `~/.cache/quickshell/crashes/` dan hapus path pribadi.
3. **Gunakan placeholder.** Jika perlu mencetak path, ganti `$HOME` dengan `~`.
4. **Hati-hati dengan `console.log` objek.** `console.log(someObject)` dapat mencetak seluruh properti, termasuk yang sensitif.

---

## 11. Studi Kasus: dari Crash ke Perbaikan

### Skenario

Shell Anda crash saat menampilkan bar. Anda tidak tahu mengapa.

### Langkah 1: Jalankan dengan stderr terlihat

```bash
QS_DISABLE_CRASH_HANDLER=1 quickshell -c my-shell 2>&1 | tee /tmp/qs.log
```

Anda melihat:

```text
TypeError: Cannot read property 'name' of undefined
    at Bar.qml:12
```

### Langkah 2: Baca kode

```qml
Text { text: modelData.name }  // Bar.qml:12
```

### Langkah 3: Perbaiki

`modelData` bisa `undefined` jika `required` tidak dideklarasikan. Tambahkan:

```qml
required property var modelData
```

### Langkah 4: Verifikasi dengan `qmllint`

```bash
qmllint -I . components/Bar.qml
```

### Langkah 5: Jadikan layanan systemd

Setelah stabil, pindahkan autostart dari `exec-once` ke unit systemd dengan `Restart=on-failure` agar crash di masa depan tidak menghentikan shell secara permanen.

---

## 12. Terminologi Esensial

| Istilah | Definisi | Contoh/Konteks |
|---|---|---|
| **`quickshell log`** | Subperintah untuk membaca log instance yang berjalan. | `quickshell log --follow` |
| **`qmllint`** | Alat Qt untuk validasi sintaks dan anti-pattern QML. | `/usr/lib/qt6/bin/qmllint shell.qml` |
| **`qmlls`** | Language Server Protocol untuk QML. | Digunakan oleh editor seperti Neovim, VS Code. |
| **`.qmlls.ini`** | File konfigurasi LSP yang diisi Quickshell. | Dibuat kosong di samping `shell.qml`. |
| **`console.log`/`warn`/`error`/`trace`** | Fungsi logging QML. | `console.error("gagal")` |
| **Crash handler** | Mekanisme yang menangkap crash, menulis laporan, dan me-restart. | `~/.cache/quickshell/crashes/` |
| **`cpptrace`** | Library backtrace yang menggantikan Breakpad di crash handler. | Menghasilkan `log.qslog.log`. |
| **`QS_DISABLE_CRASH_HANDLER`** | Env var untuk menonaktifkan crash handler. | Untuk debugging dengan `gdb`. |
| **`gdb`** | GNU Debugger; alat untuk inspeksi crash. | `gdb --args quickshell ...` |
| **`exec-once`** | Direktif compositor untuk menjalankan perintah sekali saat startup. | Hyprland: `exec-once = qs -c my-shell`. |
| **Unit `systemd --user`** | Layanan yang dijalankan dan diawasi per pengguna. | `quickshell.service` |
| **`graphical-session.target`** | Target systemd yang menandai sesi grafis aktif. | Harus diaktifkan oleh compositor/`uwsm`. |
| **`Restart=on-failure`** | Properti systemd untuk menjalankan ulang unit saat gagal. | Pengawasan otomatis. |
| **`NoNewPrivileges`** | Properti keamanan; mencegah eskalasi privilege. | `NoNewPrivileges=yes` |
| **`ProtectSystem=strict`** | Membuat filesystem read-only kecuali pengecualian. | Sandboxing unit systemd. |
| **`ReadWritePaths`** | Pengecualian untuk `ProtectSystem`/`ProtectHome`. | `ReadWritePaths=%h/.cache/quickshell` |

---

## 13. Visualisasi

### 13.1 Tangga Eskalasi Debugging

```text
┌─────────────────────────────────────────────┐
│ 1. Log: quickshell log / stderr             │
│    "Apa yang dikatakan program?"            │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│ 2. Linting: qmllint                         │
│    "Apakah ada kesalahan statis?"           │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│ 3. Runtime: console.log / console.trace     │
│    "Nilai apa yang sebenarnya?"             │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│ 4. Debugger: gdb                            │
│    "Di mana tepatnya berhenti?"             │
└─────────────────────────────────────────────┘
```

### 13.2 Alur Autostart dan Pengawasan

```text
Compositor (Hyprland/Sway)
│
├── exec-once = qs -c my-shell
│   └── Tidak ada pengawasan; crash = berhenti.
│
└── systemd --user
    ├── graphical-session.target
    │   └── quickshell.service
    │       ├── Restart=on-failure  ← pengawasan
    │       ├── NoNewPrivileges=yes ← keamanan
    │       └── journalctl --user   ← log terpusat
    │
    └── Jika target tidak aktif:
        └── Unit tidak pernah berjalan.
```

### 13.3 Pohon Keputusan Autostart

```text
Apakah Anda memerlukan restart otomatis saat crash?
├── YA → Gunakan systemd --user
│         ├── Pastikan graphical-session.target aktif
│         └── Tambahkan properti keamanan
└── TIDAK → Apakah Anda ingin kesederhanaan maksimal?
    ├── YA → Gunakan exec-once di compositor
    └── TIDAK → systemd tetap lebih baik untuk logging dan sandboxing
```

---

## 14. Hubungan dengan Modul Lain

- **Modul 1.1**: `--no-duplicate` dan `qs list` yang diperkenalkan di sana digunakan di sini untuk autostart yang aman.
- **Modul 1.2**: `Process` dan penanganan `onExited`/`onRunningChanged` dari Modul 1.2 adalah dasar untuk mendiagnosis proses yang gagal. `systemd-run --scope` untuk sandboxing proses anak melanjutkan prinsip least privilege yang diperkenalkan di sana.
- **Modul 1.3**: `import qs.` yang diperkenalkan di Modul 1.3 adalah **prasyarat** agar `.qmlls.ini` dan LSP bekerja. Tanpa `qs.`, `qmlls` tidak dapat menyelesaikan impor.
- **Modul 2.x**: Services akan mengandalkan logging dan lifecycle yang sama; kemampuan membaca `journalctl` dan `quickshell log` akan terus dipakai.
- **Modul 3.1**: Dependency injection akan mempermudah pengujian, yang pada gilirannya mengurangi kebutuhan debugging.

---

## 15. Referensi Lengkap

- **Quickshell — Installation & Setup (LSP, `.qmlls.ini`)**: [https://quickshell.org/docs/v0.3.1/guide/install-setup/](https://quickshell.org/docs/v0.3.1/guide/install-setup/) — petunjuk membuat `.qmlls.ini` dan peringatan `root:/`.
- **Quickshell — Changelog (crash handler, cpptrace)**: [https://quickshell.org/changelog/](https://quickshell.org/changelog/) — penggantian Breakpad dengan `cpptrace` dan `QS_DISABLE_CRASH_HANDLER`.
- **Qt Documentation — `qmllint` Reference**: [https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) — kemampuan `qmllint`, opsi `-I`, dan file `.qmllint.ini`.
- **Qt Documentation — Directory Imports**: [https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html](https://doc.qt.io/qt-6/qtqml-syntax-directoryimports.html) — dasar impor yang memengaruhi LSP.
- **The Quickshell Book — Debugging**: [https://programmersd21.github.io/the_quickshell_book/](https://programmersd21.github.io/the_quickshell_book/) — teknik `2>&1 | tee` dan strategi `console.log`.
- **Arch Wiki — systemd/User**: [https://wiki.archlinux.org/title/Systemd/User](https://wiki.archlinux.org/title/Systemd/User) — unit `--user`, `systemctl --user`, `journalctl --user`.
- **Arch Wiki — systemd-run**: [https://wiki.archlinux.org/title/Systemd-run](https://wiki.archlinux.org/title/Systemd-run) — sandboxing dengan scope dan properti keamanan.
- **Hyprland Wiki — Systemd**: [https://wiki.hypr.land/Configuring/Systemd/](https://wiki.hypr.land/Configuring/Systemd/) — `graphical-session.target` dan `uwsm`.
- **UWSM (Universal Wayland Session Manager)**: [https://github.com/Vladimir-csp/uwsm](https://github.com/Vladimir-csp/uwsm) — cara `graphical-session.target` diaktifkan.
- **systemd.exec — Sandboxing**: [https://www.freedesktop.org/software/systemd/man/systemd.exec.html](https://www.freedesktop.org/software/systemd/man/systemd.exec.html) — referensi lengkap `NoNewPrivileges`, `ProtectSystem`, `PrivateTmp`, dll.
- **Quickshell — Process (startDetached)**: [https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/Process](https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/Process) — lifecycle proses yang relevan untuk debugging.

---

## 16. Tips dan Praktik Terbaik

1. **Selalu jalankan dari terminal saat mengembangkan.** `2>&1 | tee` adalah cara termurah untuk melihat error QML.
2. **Biasakan `quickshell log --follow`** saat menguji `Process` atau perubahan yang tidak memicu hot reload.
3. **Gunakan `qmllint` di pre-commit hook** untuk menangkap kesalahan sintaks sebelum masuk ke runtime.
4. **Jangan commit `.qmlls.ini`.** File ini bersifat system-dependent; tambahkan ke `.gitignore`.
5. **Gunakan `QS_DISABLE_CRASH_HANDLER=1` hanya saat debugging.** Crash handler adalah jaring pengaman; mematikannya secara permanen menghilangkan pengawasan.
6. **Untuk autostart produksi, gunakan systemd `--user` dengan `Restart=on-failure`.** `exec-once` tidak memiliki pengawasan.
7. **Verifikasi `graphical-session.target` sebelum mengandalkan unit `WantedBy`.** Jika target tidak aktif, unit tidak akan berjalan.
8. **Tambahkan `NoNewPrivileges=yes` minimal.** Ini adalah langkah keamanan termurah dan paling efektif.
9. **Gunakan `ProtectSystem` dan `ProtectHome` dengan `ReadWritePaths`** agar Quickshell tetap bisa menulis cache/state.
10. **Bersihkan log sebelum membagikannya.** Path pribadi dan keluaran proses bisa membocorkan informasi.
11. **Gunakan `console.trace` daripada `console.log` untuk error yang sulit dilacak.** Stack trace sering kali langsung menunjukkan sumber masalah.
12. **Simpan laporan crash** di `~/.cache/quickshell/crashes/` dan periksa `info.txt` serta `log.qslog.log` sebelum melaporkan bug.

---

## 17. Potensi Kesalahan Umum dan Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| **Mengira `qs log` selalu tersedia** | `qs: command not found`. | Gunakan `quickshell log` atau buat symlink. |
| **Tidak membuat `.qmlls.ini`** | LSP tidak mengenali `import qs.*`. | `touch .qmlls.ini` di samping `shell.qml`; jalankan Quickshell. |
| **Meng-commit `.qmlls.ini`** | Konfigurasi rusak di mesin lain. | Tambahkan ke `.gitignore`. |
| **Menggunakan `root:/`** | LSP dan singleton rusak. | Ganti dengan `import qs.`. |
| **Tidak menangani `onExited`** | Kegagalan proses senyap. | Tambahkan handler dan periksa `exitCode`. |
| **`exec-once` tanpa pengawasan** | Quickshell crash dan tidak kembali. | Gunakan systemd `--user` dengan `Restart=on-failure`. |
| **`WantedBy=graphical-session.target` tetapi target tidak aktif** | Unit tidak pernah berjalan. | Periksa `systemctl --user status graphical-session.target`; gunakan target compositor atau `uwsm`. |
| **`ProtectHome=read-only` tanpa `ReadWritePaths`** | Quickshell gagal menulis cache/state. | Tambahkan `ReadWritePaths=%h/.cache/quickshell %h/.local/state/quickshell`. |
| **Mencetak objek sensitif ke log** | Kebocoran kredensial. | Filter atau gunakan placeholder. |
| **Mengandalkan crash handler saat debugging** | Crash handler me-restart sebelum Anda bisa memeriksa. | Set `QS_DISABLE_CRASH_HANDLER=1`. |
| **Mengira `qmllint` bekerja tanpa `qmldir`** | Impor `qs.*` dilaporkan tidak ditemukan. | Generate `qmldir` tiruan untuk linting, atau gunakan `.qmlls.ini` untuk LSP. |

---

## 18. Latihan dan Checkpoint

### Latihan

1. **Buat galat sintaks** di `Clock.qml` (misalnya, hapus tanda kurung) dan temukan melalui `qmllint`.
2. **Buat galat runtime** (misalnya, akses properti `undefined`) dan temukan melalui `console.error` serta `quickshell log`.
3. **Buat `.qmlls.ini`** di shell root, jalankan Quickshell, lalu periksa isinya. Pastikan editor Anda dapat menyelesaikan `import qs.services`.
4. **Jadikan shell layanan systemd** dengan `Restart=on-failure` dan `NoNewPrivileges=yes`.
5. **Matikan proses Quickshell dengan `kill`** dan buktikan systemd menghidupkannya kembali.
6. **Tambahkan `ProtectSystem=strict`** dan `ReadWritePaths` untuk cache/state; pastikan shell tetap berfungsi.
7. **Nonaktifkan crash handler** dan jalankan di bawah `gdb`; picu crash dan lihat backtrace.

### Checkpoint

- Apa perbedaan `quickshell log` dan `quickshell -c my-shell 2>&1 | tee`?
- Mengapa `.qmlls.ini` tidak boleh di-commit?
- Mengapa `exec-once` tidak cukup untuk produksi?
- Mengapa `graphical-session.target` bisa tidak aktif meskipun Anda menggunakan Wayland?
- Apa fungsi `QS_DISABLE_CRASH_HANDLER`?
- Mengapa `ProtectHome=read-only` memerlukan `ReadWritePaths`?

**Jawaban singkat:**

- `quickshell log` membaca buffer log instance; `2>&1 | tee` menangkap **semua** output, termasuk error QML yang mungkin tidak masuk buffer.
- `.qmlls.ini` berisi path yang bergantung pada sistem; di mesin lain path tersebut bisa salah.
- `exec-once` tidak memiliki pengawasan; jika Quickshell crash, ia tidak di-restart.
- `graphical-session.target` hanya aktif jika compositor atau session manager (misalnya `uwsm`) mengaktifkannya.
- `QS_DISABLE_CRASH_HANDLER` menonaktifkan crash handler agar crash terlihat langsung dan dapat di-debug dengan `gdb`.
- `ProtectHome=read-only` membuat seluruh home read-only; Quickshell perlu menulis ke cache/state, sehingga direktori tersebut harus dikecualikan.

---

> *“Shell yang tangguh bukan shell yang tidak pernah gagal, tetapi shell yang tahu cara bangkit dan memberi tahu Anda mengapa ia jatuh.”*

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../quickshell.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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

