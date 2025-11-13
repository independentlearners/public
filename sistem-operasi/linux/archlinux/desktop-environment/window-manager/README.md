# ⚙️ Kurikulum Pengguna Tingkat Lanjut

**Target OS:** Arch Linux (Wayland + Sway)
**Tujuan Akhir:** Pengguna mampu membangun dan mengelola lingkungan desktop mereka sendiri dengan struktur konfigurasi (dotfiles) yang rapi, modular, dan siap diintegrasikan ke dalam ekosistem tools otomatisasi Anda.

---

### 🗂 Struktur ringkasan logis roadmap

1. 🧱 **Persiapan & Prasyarat**
2. 🪟 **Fondasi Wayland & wlroots**
3. ⚙️ **Konfigurasi Dasar Sway (man 5 sway)**
4. 🔧 **Utilitas Resmi Sway**
5. 🧩 **Integrasi Ekosistem Wayland**
6. 🤖 **IPC & Scripting Automasi**
7. 🔍 **Debugging, Logging, dan Tracing**
8. 🛠️ **Build From Source & Kontribusi**

**Estimasi waktu:** 2 minggu


### 🧩 1. Fondasi Awal: Sistem dan Lingkungan Arch

**Estimasi waktu:** 2–3 minggu (4–8 jam/hari)

#### Materi Inti

* 📦 *Arch Linux Core & Pacman*: pemahaman sistem paket, repositori, dan manajemen dependensi.
* 🧱 *Filesystem Hierarchy*: struktur direktori Linux (bin, lib, etc, usr, var, home).
* 🧰 *User Privilege & Systemd*: konsep layanan, unit, target, dan socket.
* 🔒 *Permission & Ownership*: `chmod`, `chown`, `setuid`, `capabilities`.
* 🌐 *Network & Display Basics*: perbedaan antara X11 dan Wayland, dan konsep compositor.

#### Hasil Belajar

Pengguna mampu melakukan instalasi minimal Arch, memahami sistem inti, serta mengonfigurasi jaringan dan sesi Wayland secara manual.

---

## [🪞 2. Pengenalan Wayland & Komponen Sway][0]

**Persiapan & Prasyarat Lengkap:** Tool, skill dan familiar dengan sistem

**Tujuan:** menyiapkan lingkungan yang stabil dan toolchain untuk pengembangan / konfigurasi.

### 🔧 Perangkat keras & sistem

* Kernel modern (≥ generic kernel yang didukung distro).
* Driver GPU dengan dukungan KMS/DRM (Intel, AMD, NVIDIA). <!-- ~~(Nouveau atau NVIDIA proprietary dengan wayland support)~~). -->
* Akses ke TTY atau display manager yang mendukung Wayland.

> Catatan: detil driver NVIDIA bervariasi; cek dokumentasi distribusi untuk dukungan Wayland + proprietary driver [disini][0].

### 🧭 Cakupan skill & tool yang direkomendasikan

* Bash / shell scripting — wajib.
* Git — wajib (dotfiles version control).
* Pemahaman dasar C — wajib bila ingin build/kontribusi.
* Meson & Ninja — untuk build Sway/wlroots.
* Python (opsional, untuk i3ipc scripting), Rust/Lua (opsional).

### 🛠️ Build From Source Untuk Paket, Dependensi & Contribusi

🧩 Paket & dependensi (referensi **Arch Linux** — sesuaikan nama paket di distro lain)

**Kebutuhan untuk kontribusi / patch:**

* Bahasa: **C** (Sway & wlroots).
* Build system: **Meson + Ninja**.
* Toolchain: `meson`, `ninja`, `gcc/clang`, `pkg-config`, header library (wayland, wlroots, libinput, xkbcommon).
* Familiar dengan workflow Git (fork → branch → patch → PR).

**Deliverable fase:** langkah build reproducible, test minimal, panduan membuat patch dokumentasi atau bugfix kecil, dan checklist PR.

---

# 🚦 Persiapan & Prasyarat

### 📦 Daftar Dependensi Lengkap (ringkasan — sesuaikan distro)

**Tujuan:** menyiapkan lingkungan yang stabil dan menginstal dependensi dasar.

## Terminologi penting

* **KMS/DRM**: Kernel Mode Setting / Direct Rendering Manager — cara kernel mengendalikan GPU dan mode layar.
* **Wayland**: protocol modern untuk display server; menggantikan X11.
* **wlroots**: library C yang menyediakan building blocks untuk compositor Wayland (Sway dibangun di atas ini).

## Langkah praktis (Arch Linux & Debian/Ubuntu contoh)

1. Pastikan sistem up-to-date.

   * Arch:

     ```bash
     sudo pacman -Syu
     ```

     Penjelasan: `pacman -Syu` → sinkronisasi database paket dan upgrade seluruh paket.
   * Debian/Ubuntu:

     ```bash
     sudo apt update && sudo apt upgrade -y
     ```

     Penjelasan: `apt update` memperbarui indeks paket; `apt upgrade -y` meng-upgrade paket.

2. Instal paket runtime dasar (contoh Arch):

   ```bash
   sudo pacman -S --needed sway swaybg swaylock swayidle swaymsg swaynag \
     waybar mako wofi grim slurp wl-clipboard alacritty jq git
   ```

   * `sway` : compositor Wayland (core).
   * `swaybg` : helper wallpaper.
   * `swaylock` : lock screen.
   * `swayidle` : manajemen idle.
   * `swaymsg` : CLI untuk mengirim perintah IPC ke sway.
   * `swaynag` : dialog on-screen.
   * `waybar` : status bar modern (konfig JSON/CSS).
   * `mako` : notification daemon.
   * `wofi` : launcher untuk Wayland.
   * `grim` `slurp` : screenshot + region selector.
   * `wl-clipboard` : `wl-copy`/`wl-paste` (clipboard).
   * `alacritty` : terminal contoh.
   * `jq` : JSON processor (berguna parsing output `swaymsg`).
   * `git` : version control untuk dotfiles.

   (Pada Debian/Ubuntu nama paket bisa berbeda; gunakan `apt search`/`apt install` sesuai repositori atau PPA.)


**Paket Runtime Minimal (pengguna dotfiles biasa):**

* sway, swaybg, swaylock, swayidle, swaymsg, swaynag
* waybar, mako, wofi
* grim, slurp, wl-clipboard
* terminal (alacritty / foot / wezterm)
* pipewire, pipewire-pulse, wireplumber
* network manager applet (opsional)
* jq, git, bash

```
sudo pacman -Syu --noconfirm --neeeded sway swaybg swaylock swayidle swaymsg swaynag waybar mako wofi grim slurp wl-clipboard alacritty foot or wezterm pipewire pipewire-pulse wireplumber network-manager-applet jq
```

**Paket tambahan (disarankan):**

```
sudo pacman -Syu --noconfirm --neeeded wayland wayland-protocols wlroots python-pip # untuk i3ipc-python
```

3. Instal build deps (jika akan build / kontribusi):

   * Arch:

     ```bash
     sudo pacman -S --needed meson ninja pkgconf gcc wayland wayland-protocols \
       wlroots-devel libinput libxkbcommon libseat
     ```
   * Debian/Ubuntu (contoh nama paket):

     ```bash
     sudo apt install -y meson ninja-build pkg-config build-essential \
       libwayland-dev wayland-protocols libwlroots-dev libinput-dev \
       libxkbcommon-dev libseat-dev
     ```

   Penjelasan: Meson + Ninja untuk build; development headers dibutuhkan untuk compile C.

## Identitas teknis & persyaratan modifikasi

* **Sway**: bahasa implementasi **C**. Untuk modifikasi perlu compiler C (gcc/clang), Meson+Ninja, header `wayland`, `wlroots`, `libinput`, `libxkbcommon`.
* **Waybar**: **C++**, konfigurasi JSON/CSS; modifikasi visual cukup lewat config/CSS, perubahan core butuh toolchain C++ (g++/clang++).
* **Mako, wofi, grim, slurp, wl-clipboard, PipeWire**: umumnya **C**; modifikasi membutuhkan toolchain C dan dev headers.

---


**Development / build:**

* meson, ninja, pkgconf / pkg-config
* gcc / clang, make (untuk beberapa deps)
* libwayland-dev / wayland-devel, wayland-protocols
* wlroots (library + headers), libinput-dev, libxkbcommon-dev, libseat-dev

**🔧 Dev/build deps (untuk fase build & kontribusi):**

```
sudo pacman -Syu --noconfirm --neeeded meson ninja pkgconf gcc sway-devel wlroots-devel wayland-devel libinput-devel libxkbcommon-devel libseat-devel libxcb-devel python # untuk test scripts
```

> Catatan: nama paket dan ketersediaan header dapat berbeda antar distro (Debian/Ubuntu: `libwayland-dev`, `libwlroots-dev` atau paket dari PPA). Sesuaikan sebelum build.

---

# Roadmap Terstruktur — **Sway & Ekosistem Wayland**

Tujuan dokumen: memberikan **peta belajar dan referensi dependensi** yang sangat jelas sehingga siapa pun — termasuk pemula teknis — dapat mulai membuat dotfiles Sway yang dapat dimengerti hingga setiap baris konfigurasi memiliki makna (teori, contoh, latihan, verifikasi).


---

### 📚 Fondasi Wayland & wlroots

**Inti:** pahami arsitektur Wayland (compositor ↔ client ↔ protocols) dan peran wlroots.
**Mengapa penting:** tanpa gambaran ini, perubahan pada Sway dan troubleshooting akan terasa menebak-nebak.

**Keluaran yang diharapkan:** ringkasan arsitektur (diagram), istilah penting (compositor, client, protocol, KMS/DRM, seat), serta catatan bagaimana wlroots menyediakan backend hardware abstraction.

---

### Integrasi Ekosistem Wayland

**Komponen populer (bahasa & catatan modifikasi):**

* **Waybar** — *C++ + JS/JSON config + CSS styling.*

  * Untuk memodifikasi: edit JSON config + CSS; membuat module custom biasanya berupa script (Bash/Python).
* **Mako** — *C.* Konfigurasi styling dan behavior via file; recompilasi memerlukan C.
* **Wofi** — *C.* (launcher). Styling lewat CSS, pengaturan di file config.
* **Grim** / **Slurp** — *C.* (screenshot + region selection).
* **wl-clipboard** — *C.* (`wl-copy`, `wl-paste`).
* **PipeWire / WirePlumber** — *C.* (audio/video); integrasi untuk volume/control.

**Output fase:** dotfiles yang menjalankan Waybar + Mako + Wofi, shortcut screenshot, clipboard integration, dan contoh module Waybar (script + konfigurasi).

---

### 🪄 IPC & Scripting Automasi

**Target:** membuat automasi nyata menggunakan Sway IPC.

**Pilihan bahasa & libraries:**

* **Bash**: langsung menggunakan `swaymsg` + `jq`. (Tidak perlu library eksternal).
* **Python**: `i3ipc-python` (kompatibel, instal via pip). Cocok untuk event hooks (`window::new`).
* **Rust**: `swayipc-rs` (untuk performa & binary standalone).
* **Lua**: binding tersedia (untuk integrasi Neovim / dotfiles TUI).

**Contoh use-cases yang disertakan:**

* Auto-assign aplikasi ke workspace.
* Dynamic monitor profile (laptop ↔ dock).
* Wallpaper scheduler & theme switcher.
* Event-driven notifications (mis. muncul notifikasi saat device terpasang).

**Keluaran fase:** koleksi skrip contoh lengkap + penjelasan tiap baris, termasuk cara menjalankan sebagai systemd user service bila diperlukan.

---

### 🔍 Debugging, Logging & Tracing

**Teknik & perintah utama:**

* `sway -C ~/.config/sway/config` — syntax check.
* `swaymsg -t get_tree` / `-t get_outputs` — inspect state.
* `journalctl -b -u sway` / `journalctl -xe` — log systemd.
* `WAYLAND_DEBUG=1 sway` — log protokol Wayland (besar; gunakan filter).
* `sway -d 2> sway.log` — mode debug.

**Output fase:** panduan analisis log (pattern umum error), latihan memicu error, dan template laporan bug (untuk kontribusi).


# 📚 Ikhtisar cepat

* 🔭 **Target akhir:** mengelola dotfiles Sway modular, mengintegrasikan tool Wayland (Waybar, Mako, Wofi, dsb.), menulis skrip automasi via IPC (`swaymsg`), dan memahami dasar kontributor Sway/wlroots.
* 🧭 **Pendekatan:** bertahap — dari fondasi Wayland → konfigurasi dasar → utilitas resmi → ekosistem → scripting/IPC → debugging → build & kontribusi.
* ✅ **Outcome:** setiap konfigurasi disertai komentar sintaks & efek, dependensi lengkap, dan panduan modifikasi komponen (bahasa implementasi + toolchain).

---


**Tujuan:** menyiapkan lingkungan yang stabil dan menginstal dependensi dasar.

### Terminologi penting

* **KMS/DRM**: Kernel Mode Setting / Direct Rendering Manager — cara kernel mengendalikan GPU dan mode layar.
* **Wayland**: protocol modern untuk display server; menggantikan X11.
* **wlroots**: library C yang menyediakan building blocks untuk compositor Wayland (Sway dibangun di atas ini).


### 🧰 Materi Inti

* 🧠 *Arsitektur Wayland*: compositor, client, protocol, dan event loop.
* 🪟 *Sway Overview*: struktur `config`, keybinding, dan peran wlroots.
* 🧩 *Sway Modules*: bar, input, workspace, layout, wallpaper, output.
* ⚡ *IPC Communication*: memahami swaymsg dan interaksi antarproses.

### 🧰 Hasil Belajar

Peserta mampu mengedit, memuat ulang, dan memodifikasi konfigurasi Sway tanpa crash atau kehilangan sesi.

---

## 🎛️ 3. Struktur dan Modularisasi Konfigurasi

**Estimasi waktu:** 3–4 minggu
   
### Konfigurasi Dasar Sway (man 5 sway)

**Inti:** pelajari direktif `~/.config/sway/config` paling penting sehingga setiap baris konfigurasi bisa dijelaskan.

**Daftar direktif inti yang akan dibahas per baris:**

* `set` (variabel)
* `include` (modular config)
* `bindsym` / `bindcode` / `bindswitch` (keybindings)
* `exec` / `exec_always` (autostart)
* `workspace` & `assign` (penempatan aplikasi)
* `for_window` / criteria (aturan per-jendela)
* `input` block (keyboard/mouse/libinput options)
* `output` block (monitor mode/pos/scale/transform)
* Layout commands (`splith`, `splitv`, `floating`, `focus`, `move`)

**Output akhir fase:** file `config` bertingkat (minimal → intermediate → production-ready) di mana setiap baris diberi komentar menandakan arti & efek runtime.

---

### Utilitas Resmi Sway

**Komponen & identitas (bahasa implementasi + cara memodifikasi):**

* `sway` — **C**. (core compositor). Untuk modifikasi: perlu C, Meson, ninja, membaca source `swaywm/sway`.
* `swaymsg` — **C** (CLI IPC client). Dapat digunakan tanpa modifikasi.
* `swayidle` — **C**. Digunakan untuk manajemen idle/suspend; modifikasi memerlukan C.
* `swaylock` — **C**. Lock screen; konfigurasi lewat argumen & env.
* `swaybg` — **C**. Wallpaper helper.
* `swaynag` — **C**. On-screen dialogs.

**Praktik kunci:**

* Cara menggunakan `swaymsg` (perintah `get_tree`, `get_outputs`, `command`).
* Membuat `swayidle` + `swaylock` pipeline.
* Mengotomatisasi output layout via `swaymsg output <name> ...`.

---

### 🧾 Template Struktur Dotfiles (rekomendasi best-practice)
# 🧭 Fondasi Wayland & wlroots

**Tujuan:** paham arsitektur Wayland dan peran wlroots agar perubahan konfigurasi tidak bersifat tebak-tebakan.

## Terminologi penting

* **Compositor**: program yang menerima buffer dari client dan menggambar ke layar (Sway adalah compositor).
* **Client**: aplikasi yang menampilkan UI (terminal, browser).
* **Protocol**: definisi pesan (Wayland protocol).
* **Seat**: abstraksi input (keyboard/mouse) untuk user.
* **wlroots**: library untuk membuat compositor — menyediakan backend DRM, input, rendering helpers.

## Langkah praktis

1. Baca ringkasan konsep Wayland (bisa dimulai dari dokumentasi resmi).
2. Gambarkan alur: aplikasi → Wayland client lib → Wayland compositor (Sway) → wlroots → kernel DRM → hardware.
3. Eksperimen: jalankan `WAYLAND_DISPLAY=wayland-0 some-wayland-client` (contoh umum); lebih penting: lihat state dengan `swaymsg -t get_tree`.

Tidak ada konfigurasi file di fase ini; tujuan adalah konsep.

---


```
~/.dotfiles/
├── README.md
├── install.sh     # bootstrap (symlink + package checks)
├── sway/
│   ├── config
│   └── config.d/
│       ├── 00-vars.conf
│       ├── 10-keybinds.conf
│       ├── 20-inputs.conf
│       ├── 30-outputs.conf
│       └── 90-autostart.conf
├── waybar/
│   ├── config
│   └── style.css
├── mako/
│   └── config
├── scripts/
│   ├── monitor-setup.sh
│   ├── wallpaper-switcher.sh
│   └── ipc-autoassign.py
└── docs/
    └── audit-log.md
```

* Gunakan `stow` / `chezmoi` untuk deployment symlink.
* Sertakan `sway -C` syntax check di `install.sh` sebelum reload.

---

### ✅ Verifikasi & Checklist Awal (agar tidak ada kebingungan)

Sebelum menandai fase “siap”, setiap modul harus memenuhi checklist berikut:

* [ ] Semua paket runtime terinstal.
* [ ] `~/.config/sway/config` valid (`sway -C`).
* [ ] Keybinds dasar berfungsi (terminal, launcher, lock, screenshot).
* [ ] Waybar & Mako berjalan setelah login.
* [ ] Skrip monitor-setup mendeteksi dan mengaplikasikan preset.
* [ ] Contoh skrip IPC berjalan dan auto-assign bekerja.
* [ ] Ada dokumentasi singkat tiap file konfigurasi (komentar baris demi baris).

---


---

### Materi Inti

* 🗂️ *Struktur Folder Konfigurasi*: pemisahan per-file (`config`, `bar.conf`, `input.conf`, `theme.conf`, dll).
* 🧩 *Konsep Include dan Import*: strategi pengelompokan konfigurasi berdasarkan fungsi.
* 🧱 *Konvensi Penamaan dan Komentar*: dokumentasi internal untuk keterbacaan publik.
* 🔄 *Reload & Testing Strategy*: siklus perubahan konfigurasi yang aman.

### Hasil Belajar

Peserta mampu menyusun *dotfiles* yang modular dan terstruktur secara hierarkis, siap diintegrasikan dalam repositori publik.

---

## 🚦 Persiapan & Prasyarat

## 🎨 4. Tema, Estetika, dan Dinamika Tampilan

**Estimasi waktu:** 3 minggu

### Materi Inti

* 🌈 *Color Scheme & Palet Tematik*: konsep gruvbox, nord, catppuccin, dan cara integrasinya.
* 🖼️ *Wallpaper & Dynamic Color Loader*: penggunaan `swaybg` dan `wal`.
* 🪩 *Font Rendering & Icon Set*: Font Awesome, Material Symbols, JetBrains Mono, dsb.
* ✨ *Kompositor & Efek Visual Tambahan*: `swayfx`, `waybar`, dan pengaturan animasi dasar.

### Hasil Belajar

Peserta mampu mendesain tampilan desktop yang konsisten, estetis, dan profesional sesuai standar komunitas open-source modern.

---

## 🧠 5. Automasi dan Integrasi Shell

**Estimasi waktu:** 4–6 minggu

### Materi Inti

* 🐚 *Bash Scripting untuk Desktop*: variabel, kondisional, fungsi, dan pipe control.
* ⚙️ *Integrasi dengan Sway & Waybar*: event binding dan environment variable injection.
* 🧩 *Notifikasi & Prompt Dinamis*: integrasi `mako`, `dunst`, atau `swaync`.
* 🪄 *Launcher Integration*: pengaturan `wofi`, `fuzzel`, `bemenu`.
* 🧭 *Pathing & Execution Context*: bagaimana shell berinteraksi dengan sesi Wayland.

### Hasil Belajar

Peserta dapat menulis skrip automasi untuk menyalakan/mematikan service, mengganti tema dinamis, hingga mengatur workflow harian dari terminal.

---

## 🧰 6. Manajemen Paket, Komunitas, dan Ekosistem

**Estimasi waktu:** 2 minggu

### Materi Inti

* 📦 *AUR & Build System*: makepkg, PKGBUILD dasar, dan validasi hash.
* 🧭 *Kontribusi Dotfiles ke GitHub/GitLab*: standar repository `.config/` publik.
* 🌍 *Berbagi Ekosistem DE Anda*: cara memublikasikan, memberi dokumentasi, dan menjaga kompatibilitas lintas sistem.

### Hasil Belajar

Peserta siap bergabung dalam ekosistem komunitas dengan *dotfiles* mereka yang dapat diuji, dikonfigurasi, dan digunakan ulang oleh orang lain.

---

## 🏁 7. Finalisasi dan Dokumentasi Publik

**Estimasi waktu:** 1–2 minggu

### Materi Inti

* 🧾 *Penyusunan Dokumentasi Dotfiles*: struktur, deskripsi, dependensi, dan instruksi instalasi.
* 🔍 *Linting & Validasi*: pengecekan konfigurasi, gaya penulisan, dan kompatibilitas versi Sway.
* 🧩 *Ekspor ke Tools Anda*: menyesuaikan struktur akhir agar sesuai pipeline sistem Anda.

### Hasil Belajar

Peserta memiliki hasil akhir berupa *dotfiles DE profesional* yang terdokumentasi dengan baik dan dapat digunakan ulang oleh pengguna lain di ekosistem Anda.

---

# 🧩 Persyaratan Teknis & Referensi Resmi / Technical Prerequisites & Official References

## 🔰 Tahap 1 — *Fondasi Awal: Sistem dan Lingkungan Arch*

**Stage 1 — Arch Linux System Foundations**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Pengetahuan dasar sistem operasi Linux dan perintah terminal.
* Memahami konsep *partitioning*, *bootloader*, dan *user privileges*.
* Menguasai editor teks berbasis terminal seperti **Nano**, **Vim**, atau **Helix**.
* Akses ke koneksi internet stabil untuk instalasi paket.

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
* [ArchWiki: System maintenance](https://wiki.archlinux.org/title/System_maintenance)
* [Systemd documentation](https://www.freedesktop.org/wiki/Software/systemd/)

---

## 🪞 Tahap 2 — *Pengenalan Wayland & Komponen Sway*

**Stage 2 — Wayland & Sway Components**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Dasar penggunaan Arch Linux dan command line.
* Memahami cara kerja *display server* dan *window manager*.
* Familiar dengan penggunaan `pacman` dan `makepkg`.

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [Wayland Documentation](https://wayland.freedesktop.org/docs/html/)
* [SwayWM GitHub](https://github.com/swaywm/sway)
* [wlroots GitLab Docs](https://gitlab.freedesktop.org/wlroots/wlroots)
* [ArchWiki: Wayland](https://wiki.archlinux.org/title/Wayland)

---

## 🎛️ Tahap 3 — *Struktur dan Modularisasi Konfigurasi*

**Stage 3 — Configuration Structure & Modularization**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Pengetahuan terminal dan editor teks (Vim/Neovim/Helix).
* Pemahaman dasar file konfigurasi `.conf`, `.ini`, `.json`.
* Pengalaman dasar dengan Git untuk version control.

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [ArchWiki: Sway](https://wiki.archlinux.org/title/Sway)
* [wlroots Documentation](https://gitlab.freedesktop.org/wlroots/wlroots)
* [Waybar GitHub](https://github.com/Alexays/Waybar)

---

## 🎨 Tahap 4 — *Tema, Estetika, dan Dinamika Tampilan*

**Stage 4 — Aesthetics & Dynamic Visuals**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Memahami struktur konfigurasi Sway dan Waybar.
* Familiar dengan CSS dasar untuk *styling* Waybar.
* Mengetahui cara kerja compositor seperti **swayfx**.

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [SwayFX GitHub](https://github.com/WillPower3309/swayfx)
* [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
* [ArchWiki: Fonts](https://wiki.archlinux.org/title/Fonts)
* [ArchWiki: GTK and QT themes](https://wiki.archlinux.org/title/GTK)

---

## 🧠 Tahap 5 — *Automasi dan Integrasi Shell*

**Stage 5 — Automation & Shell Integration**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Menguasai Bash scripting tingkat menengah (variabel, fungsi, looping, piping).
* Pemahaman tentang event IPC di Sway dan penggunaan `swaymsg`.
* Mengenal cara kerja *launcher tools* seperti **wofi**, **bemenu**, dan **fuzzel**.

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [ArchWiki: Bash scripting](https://wiki.archlinux.org/title/Bash)
* [Mako GitHub](https://github.com/emersion/mako)
* [Dunst Wiki](https://github.com/dunst-project/dunst/wiki)
* [Sway IPC Reference](https://github.com/swaywm/sway/blob/master/sway/sway-ipc.7.scd)

---

## 🧰 Tahap 6 — *Manajemen Paket, Komunitas, dan Ekosistem*

**Stage 6 — Package Management & Community Ecosystem**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Familiar dengan **makepkg** dan sistem AUR.
* Dasar penggunaan Git, GitHub/GitLab.
* Pemahaman tentang lisensi open-source (MIT, GPL, BSD).

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [ArchWiki: AUR](https://wiki.archlinux.org/title/Arch_User_Repository)
* [makepkg documentation](https://man.archlinux.org/man/makepkg.8)
* [GNU Licenses Overview](https://www.gnu.org/licenses/licenses.html)

---

## 🏁 Tahap 7 — *Finalisasi dan Dokumentasi Publik*

**Stage 7 — Finalization & Public Documentation**

#### ⚙️ Pra-Syarat Teknis / Technical Prerequisites

* Pengalaman menulis dokumentasi Markdown.
* Pemahaman dasar YAML/JSON untuk metadata dependensi.
* Pengetahuan tentang validasi linting dan gaya penulisan kode.

#### 🔗 Referensi Resmi & Dokumentasi / Official References

* [ArchWiki: Dotfiles](https://wiki.archlinux.org/title/Dotfiles)
* [Markdown Guide](https://www.markdownguide.org/)
* [YAML Specification](https://yaml.org/spec/)
* [Sway Configuration Validation](https://github.com/swaywm/sway/issues)
<!--
Baik, berikut ini versi yang lebih elegan dan profesional — bergaya seperti **README proyek GitHub** untuk kurikulum *Advanced Desktop Environment Configuration on Arch Linux (Wayland/Sway)*.
Gaya ini akan menjaga tampilan tetap bersih, rapi, dan mudah dipahami bagi calon peserta atau kontributor komunitas Anda.

# ⚙️ Kurikulum Pengguna Tingkat Lanjut

**Target OS:** Arch Linux (Wayland + Sway)
**Tujuan Akhir:** Pengguna mampu membangun dan mengelola lingkungan desktop mereka sendiri dengan struktur konfigurasi (dotfiles) yang rapi, modular, dan siap diintegrasikan ke dalam ekosistem tools otomatisasi Anda.

---

## 🧩 1. Fondasi Awal: Sistem dan Lingkungan Arch

**Estimasi waktu:** 2–3 minggu (4–8 jam/hari)

### Materi Inti

* 📦 *Arch Linux Core & Pacman*: pemahaman sistem paket, repositori, dan manajemen dependensi.
* 🧱 *Filesystem Hierarchy*: struktur direktori Linux (bin, lib, etc, usr, var, home).
* 🧰 *User Privilege & Systemd*: konsep layanan, unit, target, dan socket.
* 🔒 *Permission & Ownership*: `chmod`, `chown`, `setuid`, `capabilities`.
* 🌐 *Network & Display Basics*: perbedaan antara X11 dan Wayland, dan konsep compositor.

### Hasil Belajar

Pengguna mampu melakukan instalasi minimal Arch, memahami sistem inti, serta mengonfigurasi jaringan dan sesi Wayland secara manual.

---

## 🪞 2. Pengenalan Wayland & Komponen Sway

**Estimasi waktu:** 2 minggu

### Materi Inti

* 🧠 *Arsitektur Wayland*: compositor, client, protocol, dan event loop.
* 🪟 *Sway Overview*: struktur `config`, keybinding, dan peran wlroots.
* 🧩 *Sway Modules*: bar, input, workspace, layout, wallpaper, output.
* ⚡ *IPC Communication*: memahami swaymsg dan interaksi antarproses.

### Hasil Belajar

Peserta mampu mengedit, memuat ulang, dan memodifikasi konfigurasi Sway tanpa crash atau kehilangan sesi.

---

## 🎛️ 3. Struktur dan Modularisasi Konfigurasi

**Estimasi waktu:** 3–4 minggu

### Materi Inti

* 🗂️ *Struktur Folder Konfigurasi*: pemisahan per-file (`config`, `bar.conf`, `input.conf`, `theme.conf`, dll).
* 🧩 *Konsep Include dan Import*: strategi pengelompokan konfigurasi berdasarkan fungsi.
* 🧱 *Konvensi Penamaan dan Komentar*: dokumentasi internal untuk keterbacaan publik.
* 🔄 *Reload & Testing Strategy*: siklus perubahan konfigurasi yang aman.

### Hasil Belajar

Peserta mampu menyusun *dotfiles* yang modular dan terstruktur secara hierarkis, siap diintegrasikan dalam repositori publik.

---

## 🎨 4. Tema, Estetika, dan Dinamika Tampilan

**Estimasi waktu:** 3 minggu

### Materi Inti

* 🌈 *Color Scheme & Palet Tematik*: konsep gruvbox, nord, catppuccin, dan cara integrasinya.
* 🖼️ *Wallpaper & Dynamic Color Loader*: penggunaan `swaybg` dan `wal`.
* 🪩 *Font Rendering & Icon Set*: Font Awesome, Material Symbols, JetBrains Mono, dsb.
* ✨ *Kompositor & Efek Visual Tambahan*: `swayfx`, `waybar`, dan pengaturan animasi dasar.

### Hasil Belajar

Peserta mampu mendesain tampilan desktop yang konsisten, estetis, dan profesional sesuai standar komunitas open-source modern.

---

## 🧠 5. Automasi dan Integrasi Shell

**Estimasi waktu:** 4–6 minggu

### Materi Inti

* 🐚 *Bash Scripting untuk Desktop*: variabel, kondisional, fungsi, dan pipe control.
* ⚙️ *Integrasi dengan Sway & Waybar*: event binding dan environment variable injection.
* 🧩 *Notifikasi & Prompt Dinamis*: integrasi `mako`, `dunst`, atau `swaync`.
* 🪄 *Launcher Integration*: pengaturan `wofi`, `fuzzel`, `bemenu`.
* 🧭 *Pathing & Execution Context*: bagaimana shell berinteraksi dengan sesi Wayland.

### Hasil Belajar

Peserta dapat menulis skrip automasi untuk menyalakan/mematikan service, mengganti tema dinamis, hingga mengatur workflow harian dari terminal.

---

## 🧰 6. Manajemen Paket, Komunitas, dan Ekosistem

**Estimasi waktu:** 2 minggu

### Materi Inti

* 📦 *AUR & Build System*: makepkg, PKGBUILD dasar, dan validasi hash.
* 🧭 *Kontribusi Dotfiles ke GitHub/GitLab*: standar repository `.config/` publik.
* 🌍 *Berbagi Ekosistem DE Anda*: cara memublikasikan, memberi dokumentasi, dan menjaga kompatibilitas lintas sistem.

### Hasil Belajar

Peserta siap bergabung dalam ekosistem komunitas dengan *dotfiles* mereka yang dapat diuji, dikonfigurasi, dan digunakan ulang oleh orang lain.

---

## 🏁 7. Finalisasi dan Dokumentasi Publik

**Estimasi waktu:** 1–2 minggu

### Materi Inti

* 🧾 *Penyusunan Dokumentasi Dotfiles*: struktur, deskripsi, dependensi, dan instruksi instalasi.
* 🔍 *Linting & Validasi*: pengecekan konfigurasi, gaya penulisan, dan kompatibilitas versi Sway.
* 🧩 *Ekspor ke Tools Anda*: menyesuaikan struktur akhir agar sesuai pipeline sistem Anda.

### Hasil Belajar

Peserta memiliki hasil akhir berupa *dotfiles DE profesional* yang terdokumentasi dengan baik dan dapat digunakan ulang oleh pengguna lain di ekosistem Anda.

---

## ⏳ Total Estimasi Waktu Belajar

Dengan asumsi **4–8 jam per hari** dan **1 hari libur tiap pekan**, maka estimasi keseluruhan waktu untuk mencapai tingkat “pengguna mahir” ini adalah:

* **Minimal:** ±16 minggu (4 bulan intensif, 4 jam/hari)
* **Ideal:** ±12 minggu (3 bulan intensif, 6–8 jam/hari)
* **Mendalam:** ±20 minggu (5 bulan termasuk eksperimen dan dokumentasi publik)

---
Apabila Anda setuju dengan struktur ini, langkah berikutnya saya akan menyusun **diagram konseptual hubungan antar tahap (visual hierarchy)** dan **peta jalur progres skill (progress roadmap)** yang menunjukkan urutan kemampuan yang dikuasai dari bawah ke atas.
Apakah Anda ingin saya lanjutkan ke bagian visual tersebut selanjutnya?

# 🧭 Roadmap Konseptual – *Advanced Wayland/Sway User Path (Arch Linux)*

Diagram ini menunjukkan bagaimana setiap tahap pembelajaran membentuk lapisan keahlian yang semakin dalam, hingga mencapai tingkat **pengguna mahir dan kontributor ekosistem dotfiles**.
Seluruh jalur disusun dari *fondasi sistem → konfigurasi modular → automasi → estetika → publikasi*.

---

### Fokus: Penguasaan penuh konfigurasi DE tanpa membangun tool eksternal

### Tujuan Akhir: Dotfiles modular, dokumentatif, dan siap diintegrasikan ke ekosistem publik

---

## 🔰 Level 1 — *Foundation Layer: Sistem dan Wayland Core*

```
[Arch Fundamentals] ─▶ [Wayland Basics] ─▶ [Sway Architecture]
```

📚 **Kompetensi yang dicapai**

* Memahami struktur sistem Linux, hierarki file, dan session layer Wayland.
* Mampu mengatur tampilan, input, dan layout di Sway dari terminal.
* Mengerti perbedaan X11 vs Wayland serta bagaimana compositor bekerja.

🔑 **Kata Kunci Pencarian**
`arch linux filesystem hierarchy`, `wayland protocol basics`, `sway wm configuration`, `wlroots`

---

## ⚙️ Level 2 — *Configuration & Modularization Layer*

```
[Config Structure] ─▶ [Modular Files] ─▶ [Includes & Reloading]
```

📚 **Kompetensi yang dicapai**

* Menyusun file konfigurasi yang terpisah dan saling terhubung.
* Mengatur konfigurasi berdasarkan fungsi (bar, input, output, theme).
* Menyusun ulang Sway tanpa crash melalui `swaymsg reload`.

🔑 **Kata Kunci Pencarian**
`sway config include`, `dotfiles structure`, `waybar configuration`, `modular sway setup`

---

## 🎨 Level 3 — *Aesthetic & Theming Layer*

```
[Color Scheme] ─▶ [Fonts & Icons] ─▶ [Wallpaper & Animations]
```

📚 **Kompetensi yang dicapai**

* Menerapkan tema dengan warna konsisten (gruvbox, nord, catppuccin).
* Mengintegrasikan font ikon seperti *Font Awesome*, *Material Symbols*, *Nerd Fonts*.
* Mengaktifkan animasi dan efek halus menggunakan `swayfx` atau compositor tambahan.

🔑 **Kata Kunci Pencarian**
`wayland themes`, `swayfx animation`, `nord theme sway`, `waybar style css`, `swaybg dynamic wallpaper`

---

## 🧠 Level 4 — *Automation & Integration Layer*

```
[Bash Scripting] ─▶ [Event Hooking] ─▶ [Dynamic Controls]
```

📚 **Kompetensi yang dicapai**

* Menulis skrip Bash yang berinteraksi dengan session Wayland.
* Menghubungkan Sway dan Waybar melalui environment variable dan event IPC.
* Membuat notifikasi dinamis, switch tema otomatis, dan pengontrol workflow.

🔑 **Kata Kunci Pencarian**
`swaymsg ipc`, `waybar modules script`, `bash wayland automation`, `mako sway notification`, `wofi launcher config`

---

## 🧩 Level 5 — *Community & Ecosystem Layer*

```
[Dotfiles Publishing] ─▶ [GitHub Integration] ─▶ [AUR & Package Awareness]
```

📚 **Kompetensi yang dicapai**

* Mengelola dan membagikan *dotfiles* di GitHub/GitLab dengan dokumentasi.
* Mengetahui struktur AUR dan cara memverifikasi dependensi.
* Memahami standar kontribusi komunitas open-source.

🔑 **Kata Kunci Pencarian**
`dotfiles github`, `arch aur makepkg`, `sway config repo`, `dotfiles structure community`

---

## 🏁 Level 6 — *Documentation & Deployment Layer*

```
[Document Structure] ─▶ [Validation & Linting] ─▶ [Export for Tool Integration]
```

📚 **Kompetensi yang dicapai**

* Menulis dokumentasi teknis dotfiles lengkap dengan deskripsi dan dependensi.
* Melakukan linting dan validasi agar kompatibel dengan versi Sway terbaru.
* Menyiapkan *dotfiles package* agar siap digunakan dalam tools Anda nantinya.

🔑 **Kata Kunci Pencarian**
`dotfiles documentation`, `sway config lint`, `wayland version compatibility`, `yaml json toml configuration`

-->

## 🌐 Alur Vertikal Kompetensi (Visual Tekstual)

```
┌─────────────────────────────┐
│  🧩 Level 6 – Documentation │
├─────────────────────────────┤
│  🧠 Level 5 – Community     │
├─────────────────────────────┤
│  ⚙️ Level 4 – Automation    │
├─────────────────────────────┤
│  🎨 Level 3 – Aesthetic     │
├─────────────────────────────┤
│  ⚙️ Level 2 – Configuration │
├─────────────────────────────┤
│  🔰 Level 1 – Foundation    │
└─────────────────────────────┘
```

> 🔺 *Setiap level bergantung pada penguasaan level di bawahnya.
> Pengguna baru disarankan menyelesaikan minimal hingga Level 3 untuk mendapatkan lingkungan desktop yang stabil dan menarik,
> sedangkan Level 4–6 ditujukan bagi mereka yang ingin berkontribusi pada ekosistem publik.*

---

## ⏱️ Estimasi Waktu Total

| Tingkat | Waktu (4–8 jam/hari) | Deskripsi                                   |
| ------- | -------------------- | ------------------------------------------- |
| Level 1 | 2–3 minggu           | Instalasi, sistem dasar, Wayland primer     |
| Level 2 | 3–4 minggu           | Struktur modular dan file konfigurasi       |
| Level 3 | 3 minggu             | Tema, ikon, wallpaper, estetika             |
| Level 4 | 4–6 minggu           | Automasi dan integrasi shell                |
| Level 5 | 2 minggu             | Publikasi dotfiles dan kontribusi komunitas |
| Level 6 | 1–2 minggu           | Dokumentasi dan validasi akhir              |

**Total Waktu Keseluruhan:**
🕒 ±16–20 minggu (4–5 bulan dengan 1 hari libur per pekan)

# 1200 Istilah Dan Terminologi

| Lapisan | Lingkup Teknis                       | Estimasi Jumlah Istilah | Cakupan Utama                                                |
| ------- | ------------------------------------ | ----------------------- | ------------------------------------------------------------ |
| **1**   | [Kernel & Graphics Subsystem][a]          | **150**                 | DRM, KMS, framebuffer, input, driver GPU, interrupt handling |
| **2**   | [Display Server & Protocol][b]            | **200**                 | X11, Wayland, wlroots, Weston, protocol extensions, IPC      |
| **3**   | [Compositor & Window Manager][c]          | **200**                 | tiling, stacking, surface management, scene graph, rendering |
| **4**   | [Toolkit & Rendering Engine][d]          | **200**                 | GTK, Qt, Cairo, Clutter, Vulkan, Skia, rendering pipeline    |
| **5**   | [Desktop Shell & Core Components][e]      | **200**                 | panel, workspace, applet, launcher, settings daemon          |
| **6**   | [Session, Policy & System Integration][f] | **150**                 | login, PAM, systemd, polkit, dbus, session management        |
| **7**   | [Utilities, Extensions & Theming][g]      | **100**                 | configurator, plugin system, theme engine, icon, sound theme |

[a]: ./module/bagian-1/README.md
[b]: ./module/bagian-2/README.md
[c]: ./module/bagian-3/README.md
[d]: ./module/bagian-4/README.md
[e]: ./module/bagian-5/README.md
[f]: ./module/bagian-6/README.md
[g]: ./module/bagian-7/README.md


---

<!--
**[Klik Disini Untuk Masuk][ ]**
-->

[0]: ./wayland/README.md
