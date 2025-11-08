<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

Bagus — saya akan langsung menyajikan **pengembangan mendalam** untuk setiap *Materi Inti* pada daftar Anda (bagian 2 — 7). Untuk tiap bagian saya akan menampilkan: Mini-Daftar Isi (struktur internal), Estimasi waktu, Penjelasan rinci (deskripsi, filosofi, konsep kunci), Contoh implementasi/praktik, Terminologi penting, Rekomendasi visualisasi, Hubungan lintas-modul, Persyaratan teknis & langkah untuk *memodifikasi* komponen, Tips/praktik terbaik, Kesalahan umum + cara perbaikan, dan Referensi resmi. Saya sertakan kutipan sumber utama untuk pernyataan teknis penting.

Mulai sekarang — berikut pengembangan mendalam untuk setiap materi inti (urut: 2 → 7).

---
-->
# [🪞 2. Pengenalan Wayland & Komponen Sway][0]

**Estimasi waktu**: 2 minggu (intensif — pemahaman konsep + eksperimen konfigurasi)

## Mini-Daftar Isi (struktur isi)

1. Gambaran arsitektur Wayland (compositor, client, protocol, event loop)
2. Peran `wlroots` dan mengapa Sway dibangun di atasnya
3. Sway Overview: struktur config, keybinding, mode, IPC
4. Komponen Sway (bar, input, workspace, layout, wallpaper, output) — peran & contoh
5. Interaksi proses: `swaymsg`, socket IPC, JSON payload
6. Latihan praktis: inspect event, buat binding, kirim perintah IPC
7. Persyaratan untuk modifikasi (bahasa, build tools, skillset)
8. Visualisasi yang direkomendasikan

---

## 1) Deskripsi konkret & peran dalam kurikulum

Wayland adalah *display server protocol* modern — menjelaskan cara compositor (server) berinteraksi dengan aplikasi (client). Sway adalah *tiling Wayland compositor* yang bertindak sebagai pengendali layar dan pengelola jendela; ia dibuat sebagai pengganti i3 pada Wayland. Memahami keduanya wajib untuk mendesain DE modern berbasis Wayland, debugging input/output, dan menulis konfigurasi yang aman. ([wayland.freedesktop.org][1])

---

## 2) Konsep kunci & filosofi mendalam

### a. Model client–compositor

* **Client**: aplikasi (Chrome, Terminal, dll.) yang menggambar ke buffer dan meminta compositor menampilkan buffer tersebut.
* **Compositor**: menerima buffer dari client, menggabungkannya (compositing), dan mengirimkan frame ke hardware.
* **Protocol**: pesan asinkron antar-proses (method, event, argumen). Wayland menggunakan Unix domain socket untuk IPC. Filosofi: *simplicity & security* — compositor menerima pixel dari client; tidak ada API rendering pusat seperti X11. ([wayland.freedesktop.org][1])

### b. Event loop & asynchronous design

Wayland bersifat *asynchronous object-oriented protocol*: request dan event tanpa paket sinkron yang memblokir. Artinya desain compositor dan client harus non-blocking dan mempertimbangkan lifecycle buffer. ([wayland.freedesktop.org][1])

### c. `wlroots` — library modular

`wlroots` menyediakan building blocks (backends, input handling, outputs, layer shell) sehingga pembuat compositor fokus pada kebijakan (layout, hotkeys, IPC) bukan implementasi low-level Wayland. Jika ingin menulis atau memodifikasi compositor — pahami C dan API `wlroots`. ([GitHub][2])

---

## 3) Contoh implementasi inti (praktik cepat)

### Memeriksa versi Wayland & environment

```bash
# Cek apakah sesi Wayland aktif
echo $WAYLAND_DISPLAY
# biasanya :wayland-0 atau serupa
```

### Mengirim perintah Sway via IPC (contoh)

```bash
# Menampilkan daftar workspaces (swaymsg)
swaymsg -t get_workspaces
# Pindah workspace ke nomor 2
swaymsg workspace number 2
```

`Sway` menerima perintah melalui socket IPC; `swaymsg` adalah klien sederhana yang mengirim perintah text/JSON ke server. (Contoh lebih lanjut ada di dokumentasi Sway). ([man.archlinux.org][3])

---

## 4) Terminologi esensial (singkat)

* **Compositor** — program yang mengelola tampilan & input (Sway).
* **wl_surface, wl_buffer** — objek Wayland untuk menampung gambar/jendela.
* **Layer shell / wlr_layer_shell** — protokol untuk bar, panel, background.
* **IPC socket** — Unix domain socket untuk mengendalikan Sway (swaymsg).
* **Backend** — implementasi hardware (DRM, Wayland, X11 bridging) di wlroots. ([wayland.freedesktop.org][1])

---

## 5) Persyaratan teknis & cara memodifikasi

Jika tujuan Anda: **memodifikasi Sway atau menulis plugin/komponen**:

* **Sway**: ditulis dalam **C**. Untuk memodifikasi Sway — perlu menguasai C, meson/ninja build system (Sway menggunakan meson), pemahaman Wayland API, dan debugging dengan `gdb`/`valgrind`. Repositori: `github.com/swaywm/sway`. ([GitHub][4])
* **wlroots**: library juga ditulis dalam **C**; membangun komponen low-level => belajar `wlroots` API. ([GitHub][2])
* **Debugging runtime**: gunakan `WAYLAND_DEBUG=1` untuk melihat protokol serta `sway -d` atau log file.

---

## 6) Praktik terbaik & kesalahan umum

* **Best**: jangan mengedit konfigurasi langsung saat sesi sensitif — selalu punya ttys/backup; gunakan `swaymsg reload` setelah uji.
* **Kesalahan umum**: perintah binding ganda, konfigurasi block yang tidak tertutup `{}` → Sway gagal reload → solusi: simpan salinan config, validasi sintaks, gunakan `sway --validate` (lihat man page). ([man.archlinux.org][3])

---

## 7) Rekomendasi visualisasi

* Diagram arsitektur: *Client → Wayland socket → Compositor (wlroots) → Kernel/DRM*
* Sequence diagram: *Client render → commit wl_buffer → Compositor composite → display*

---

## Referensi utama

* Wayland architecture (freedesktop): ([wayland.freedesktop.org][1])
* Sway official site / repo: ([swaywm.org][5])
* wlroots (repo): ([GitHub][2])

---

# 🎛️ 3. Struktur dan Modularisasi Konfigurasi

**Estimasi waktu**: 3–4 minggu (membangun dotfiles modular, pengujian berulang)

## Mini-Daftar Isi

1. Prinsip modularisasi (separation of concerns)
2. Struktur folder rekomendasi (file by purpose)
3. `include` / pemecahan file & strategi environment per-host
4. Konvensi penamaan dan dokumentasi internal (header, komentar)
5. Strategi Reload & Testing (safe cycle, sandbox)
6. Otomasi deploy (dotfiles, symlink, installer)
7. Persyaratan teknis untuk modifikasi & integrasi CI
8. Visualisasi & checklist

---

## 1) Deskripsi konkret & peran

Modularisasi konfigurasi membuat konfigurasi Sway menjadi **terbaca, mudah di-maintain, dan dapat dipakai ulang** pada sistem lain. Ini esensial bila Anda ingin memublikasikan dotfiles atau menggabungkan konfigurasi dengan skrip otomatisasi. Hasil akhirnya: satu repository `.config/` yang dapat dipakai ulang, dengan dokumentasi dan installer. (Tujuan: reproducibility & collaboration.)

---

## 2) Struktur folder praktis (contoh)

```
~/.config/sway/
├── config                 # main file (includes: ...)
├── config.d/
│   ├── 00-base.conf
│   ├── 10-input.conf
│   ├── 20-wm.conf
│   ├── 30-bar.conf
│   └── 90-local.conf
├── waybar/
│   ├── config.jsonc
│   └── style.css
├── scripts/
│   ├── theme-switcher.sh
│   └── backlight.sh
└── README.md
```

**Aturan**: file numerik (00,10,20) untuk kontrol urutan; `90-local.conf` untuk override host-specific.

---

## 3) Include / import & variable strategy

* Gunakan `include` (Sway mendukung `include` di config) untuk memecah file.
* Gunakan `set $var ...` pada bagian atas untuk variabel global (terminal, mod key, theme path).
* Strategy per-host: pada awal `config` — periksa hostname dan `include` file host-specific, atau gunakan `if`/`match` pattern saat tersedia (Sway memiliki `for_window` / `assign` untuk behaviour jendela). ([man.archlinux.org][3])

---

## 4) Testing & safe reload strategy

* **Workflow aman**:

  1. Tulis perubahan di `config.d/20-wm.conf.new`.
  2. Jalankan `sway -t config test` (validasi) atau `sway --validate`.
  3. Jika valid, `mv` ke `config.d/20-wm.conf` dan `swaymsg reload`.
* **Sandboxing**: gunakan VM/VM image atau session tty alternatif untuk mencoba perubahan besar sebelum memuat ke desktop utama.

---

## 5) Otomasi deploy (dotfiles)

* Gunakan `stow`, Makefile, atau skrip `install.sh` untuk membuat symlink `~/.config/*`.
* Sertakan `deps.txt` (list package manager packages) agar pengguna lain tahu dependensi.
* Buat `install` target untuk meng-copy service units (systemd user) yang diperlukan.

---

## 6) Persyaratan teknis & modifikasi

Untuk membuat tooling deploy / modular:

* Bahasa: Bash (installer), Python (opsional, untuk tooling yang lebih kompleks), Makefile.
* VCS: Git. Continuous integration dapat menggunakan GitHub Actions untuk linting config / menjalankan `sway --validate` (pada runner yang menjalankan Wayland mungkin butuh container/VM).
* Jika menulis modul bar (Waybar) → butuh memahami JSONC + CSS, dan jika ingin menulis module native → C++/Meson (Waybar modules). ([GitHub][6])

---

## 7) Visualisasi yang direkomendasikan

* Tree view struktur folder (seperti contoh di atas).
* Flowchart deploy: edit → test → validate → deploy.

---

## 8) Kesalahan umum & solusi

* **Masalah urutan**: include file dieksekusi top-to-bottom → penempatan `set` di bawah akan menimbulkan variable not found. *Solusi*: standar `00-base.conf` untuk semua `set`.
* **Konfigurasi host-specific tertimpa**: gunakan `90-local.conf` dan jangan commit file tersebut ke repo publik (masukkan ke `.gitignore`).

---

## Referensi utama

* Sway man page / config guidance. ([man.archlinux.org][3])

---

# 🎨 4. Tema, Estetika, dan Dinamika Tampilan

**Estimasi waktu**: 3 minggu (pemilihan palet, integrasi wal, testing bar & fonts)

## Mini-Daftar Isi

1. Color scheme fundamentals (contrast, WCAG basics)
2. Palet tematik populer (gruvbox, nord, catppuccin) — integrasi praktis
3. Wallpaper & dynamic palette loader (swaybg, pywal)
4. Font rendering & icon sets (JetBrains Mono, Font Awesome, Material Symbols)
5. Kompositor & efek (swayfx, swayidle, animasi minimal)
6. Contoh pipeline: image → palette → waybar CSS → terminal theme
7. Persyaratan teknis (languages/tools)
8. Visualisasi: contoh skema & before/after

---

## 1) Deskripsi & filosofi

Tampilan desktop adalah kombinasi fungsional + estetika: warna, tipografi, spacing mempengaruhi keterbacaan dan kenyamanan. Filosofi praktis: **kontras tinggi untuk informasi penting, konsistensi untuk UX**. Gunakan palet yang diuji dan alat untuk menerapkannya secara konsisten ke bar, terminal, editor, dan aplikasi lain.

---

## 2) Palet tematik & integrasi

* **Gruvbox / Nord / Catppuccin**: palet berisi set warna (background, foreground, accent, success, warn).
* Cara integrasi: gunakan `pywal` (Python tool) untuk menghasilkan palet dari wallpaper; puis impor ke `waybar/style.css`, `alacritty.yml`, `gtk.css`, dsb. `pywal` adalah project Python yang membuat file warna dapat diexport ke berbagai format. ([GitHub][7])

---

## 3) Wallpaper & dynamic color loader — contoh pipeline

1. `swaybg` — program yang memasang wallpaper pada Wayland (ditulis/dirilis oleh project Sway). Gunakan `swaybg --image path/to/file`. ([GitHub][8])
2. `pywal` — generate palette dari wallpaper:

```bash
wal -i ~/Pictures/wallpaper.jpg
# atau pywal:
pywal -i ~/Pictures/wallpaper.jpg
```

3. Skrip `theme-switcher.sh` membaca output pywal (file `~/.cache/wal/colors.json`) dan menulis CSS untuk Waybar + mengupdate Alacritty/GTK.

**Contoh snippet** (bash, sangat ringkas):

```bash
pywal -i "$1"
# create waybar CSS from ${HOME}/.cache/wal/colors.css
cp ~/.cache/wal/colors.css ~/.config/waybar/style.css
swaymsg reload
```

---

## 4) Font rendering & icon sets

* Rekomendasi: *JetBrains Mono* untuk terminal/editor (monospace, ligatures opsional), *Noto Sans* atau *Inter* untuk UI, *Font Awesome* atau *Material Symbols* untuk icon.
* Pastikan `fontconfig` (freetype) terpasang; jika ada fallback issue, atur `~/.config/fontconfig/fonts.conf`.

---

## 5) Kompositor & efek visual tambahan

* Tools seperti **swayfx** (project komunitas) menambahkan efek transisi; implementasinya beragam — cek repo spesifik jika ingin memodifikasi. Karena efek sering melibatkan compositing pipeline, uji performa GPU.
* Gunakan efek ringan: fade, dim, tanpa mencampur heavy blur yang menghabiskan GPU.

---

## 6) Persyaratan modifikasi & skillset

* **swaybg**: repo Sway (C) — untuk modifikasi: C, meson build. ([GitHub][8])
* **pywal**: ditulis dalam **Python** — mudah di-extend (plugin, exporter). ([GitHub][7])
* **Waybar** styling: JSONC + CSS. Untuk menulis module native → C++ + Meson (Waybar repo). ([GitHub][6])

---

## 7) Kesalahan umum & solusi

* **Palet dengan contrast rendah**: gunakan alat uji contrast (WCAG) untuk memastikan teks terbaca.
* **Update theme partial**: bila hanya satu komponen dimodifikasi, lakukan reload komponen tersebut (waybar restart) bukannya reload penuh yang berisiko.

---

## Referensi utama

* Waybar repo + dokumentasi (config JSONC, CSS). ([GitHub][6])
* swaybg repo (wallpaper tool). ([GitHub][8])
* pywal (palette generation). ([GitHub][7])

---

# 🧠 5. Automasi dan Integrasi Shell

**Estimasi waktu**: 4–6 minggu (Bash → event binding → workflow automation)

## Mini-Daftar Isi

1. Dasar-dasar Bash scripting untuk desktop (variabel, fungsi, error handling)
2. Interaksi script dengan Sway (event binding, environment injection)
3. Notifikasi & prompt dinamis (mako, dunst, swaync)
4. Launcher integration (wofi, fuzzel, bemenu)
5. Pathing & Execution context (Wayland env variables, systemd user, XDG_RUNTIME_DIR)
6. Contoh skenario automatisasi (tema dinamis, power profile, external monitor)
7. Persyaratan teknis untuk menulis plugin/extension

---

## 1) Deskripsi & peran

Automasi memungkinkan men-trigger perubahan UI/behaviour berdasarkan event sistem (plugging monitor, battery, connect VPN), sehingga meningkatkan produktivitas. Dalam praktiknya, tuliskan skrip shell yang aman, dapat diuji, dan di-trigger lewat binding Sway (`bindsym exec path/to/script`), systemd user, atau socket events.

---

## 2) Contoh teknik & praktik

### a. Struktur skrip shell yang aman (template)

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() { echo "$(date --iso-8601=seconds) - $*"; }

if [[ "$1" == "apply-theme" ]]; then
  pywal -i "$2"
  cp ~/.cache/wal/colors.css ~/.config/waybar/style.css
  pkill -USR1 waybar || true   # jika Waybar mendukung reload via signal
  swaymsg reload
fi
```

Penjelasan: `set -euo pipefail` membuat skrip fail-safe; gunakan exit codes untuk integrasi dengan systemd.

### b. Integrasi event Sway

* Bind script ke key: `bindsym $mod+Shift+t exec ~/.config/sway/scripts/theme-switcher.sh apply-theme ~/Pictures/wall.jpg`
* Gunakan `swaymsg -t subscribe` untuk event streaming bila diperlukan.

### c. Notifikasi

* **Mako** / **Dunst** adalah notification daemons (mako khusus Wayland). Pilih sesuai kompatibilitas Wayland. Integrasi: kirim notifikasi via `notify-send` (mako menyediakan compat). Pastikan paket yang digunakan mendukung Wayland.

---

## 3) Launcher Integration

* **wofi**, **fuzzel**, **bemenu**: masing-masing adalah launcher Wayland-native.

  * Wofi dan Fuzzel penulisan proyeknya dicatat developer (Fuzzel dari pembuat Foot). Untuk memodifikasi launcher: pahami bahasa proyek (contoh: Fuzzel ditulis di Rust? — periksa repository). Jika menulis integrasi dengan script, gunakan stdin/stdout contract (wofi dapat menerima daftar dari skrip).
  * Contoh bind: `bindsym $mod+d exec wofi --show drun` (atau `fuzzel`) — masing-masing memiliki opsi berbeda.

(Catatan: selalu cek repo launcher untuk bahasa & build instructions sebelum melakukan perubahan.)

---

## 4) Pathing & execution context

* **XDG_RUNTIME_DIR**: Wayland sockets bergantung pada path ini; systemd user services menjalankan session berbeda. Saat mengeksekusi GUI dari cron/systemd, pastikan environment Wayland tersedia (sering lebih aman gunakan `systemd --user` unit yang dieksekusi dalam sesi).
* Untuk script yang memanggil GUI tools, forward env: `DISPLAY` tidak ada di Wayland — gunakan `WAYLAND_DISPLAY`. Pastikan script dijalankan dalam konteks user session.

---

## 5) Persyaratan teknis

* Bahasa: Bash (untuk skrip ringan), Python (untuk pipeline lebih kompleks), Rust/C++ (untuk tools performa tinggi).
* Tools: systemd user, inotify (untuk watch file), swaymsg (IPC), notify-send (dengan backend mako).

---

## 6) Kesalahan umum & solusi

* **Script berjalan tapi GUI tidak muncul**: kemungkinan environment Wayland tidak tersedia — periksa `XDG_RUNTIME_DIR`, `WAYLAND_DISPLAY`.
* **Permission denied** pada socket IPC: jalankan sebagai user yang sama dengan sesi Sway.

---

# 🧰 6. Manajemen Paket, Komunitas, dan Ekosistem

**Estimasi waktu**: 2 minggu

## Mini-Daftar Isi

1. Pengantar AUR & PKGBUILD / makepkg
2. Membuat PKGBUILD sederhana untuk tool dotfiles (contoh: waybar module)
3. Kontribusi dotfiles ke GitHub/GitLab (struktur, lisensi, README)
4. Rilis & packaging (AUR vs distro package)
5. Kompatibilitas & dokumentasi untuk pengguna lain
6. Persyaratan teknis (bash, makepkg, gpg signing)
7. Checklist publikasi

---

## 1) Deskripsi & peran

Mempelajari packaging (PKGBUILD) dan ekosistem membantu Anda mendistribusikan konfigurasi, modul custom, atau bar modules kepada komunitas. Mengemas kode menjadi paket memudahkan penginstalan dan reproduksi lingkungan. Dokumentasikan dependensi agar pengguna lain mudah mengadopsi. ([ArchWiki][9])

---

## 2) Contoh PKGBUILD minimal (sketch)

```bash
# PKGBUILD sketch untuk skrip theme-switcher
pkgname=theme-switcher
pkgver=0.1.0
pkgrel=1
pkgdesc="Theme switcher scripts for sway + waybar using pywal"
arch=('x86_64')
license=('MIT')
depends=('pywal' 'sway' 'waybar')
source=('theme-switcher.sh')
package() {
  install -Dm755 theme-switcher.sh "$pkgdir/usr/bin/theme-switcher"
}
```

Keterangan: `makepkg` akan membaca PKGBUILD dan membangun paket. Pastikan `sha256sums` diisi sebelum upload ke AUR.

---

## 3) Kontribusi dotfiles

* Buat README yang jelas: tujuan repo, cara install, dependensi per package manager (pacman/apt/dnf), sample screenshot, cara revert.
* Lisensi: pilih lisensi permissive (MIT) untuk dotfiles/tools.
* Gunakan `ISSUE_TEMPLATE` & `CONTRIBUTING.md` agar kontributor tahu standar coding/style.

---

## 4) Persyaratan teknis

* Mengemas paket di Arch: paham Bash (PKGBUILD adalah script Bash), `makepkg`, signing (GPG), dan verify checksums. ([ArchWiki][9])

---

# 🏁 7. Finalisasi dan Dokumentasi Publik

**Estimasi waktu**: 1–2 minggu

## Mini-Daftar Isi

1. Struktur dokumentasi dotfiles (README, INSTALL, USAGE, TROUBLESHOOTING)
2. Linting & Validasi: pengecekan config, format, style guide
3. Export & integrasi ke pipeline (installer, CI, release)
4. Checklist rilis & versi
5. Contoh Layout README final

---

## 1) Deskripsi & peran

Dokumentasi adalah produk akhir — memudahkan orang lain meniru setup Anda. Sertakan daftar dependensi, langkah instalasi otomatis (script), dan cara rollback. Pastikan README ringkas namun komprehensif.

---

## 2) Linting & Validasi

* Automasi: jalankan `sway --validate` (atau `sway -t config validate`) di CI (jika runner mendukung Wayland) atau set up test container.
* Linting: gunakan checker untuk shell scripts (`shellcheck`), JSON/JSONC validator untuk Waybar config, dan CSS linter untuk style. ([man.archlinux.org][3])

---

## 3) Checklist rilis

* Pastikan `deps.txt` terupdate
* Sertakan screenshot & video demo (opsional)
* Tag versi di Git (semver)
* Siapkan AUR package jika relevan (lengkapi PKGBUILD, checksums). ([ArchWiki][9])

---

## 4) Contoh ringkas README structure

```
# dotfiles-sway
Deskripsi singkat

## Quick install
1. Install dependencies
2. Run `./install.sh`

## Structure
- ~/.config/sway/config
- ~/.config/waybar/config.jsonc

## Troubleshooting
- Jika Sway gagal reload: check `~/.config/sway/config.d/` order
```

---

## Referensi & Sumber Utama (kumpulan)

* Wayland protocol & arsitektur — freedesktop.org. ([wayland.freedesktop.org][1])
* Sway (man page & repo). ([man.archlinux.org][3])
* wlroots (repo) — dasar pembuatan compositor. ([GitHub][2])
* Waybar (repo, JSONC+CSS config). ([GitHub][6])
* PKGBUILD / makepkg / AUR (ArchWiki). ([ArchWiki][9])

---
<!--
## Langkah praktis selanjutnya (apa yang akan saya lakukan)

Saya telah menyelesaikan pengembangan mendalam untuk **Materi Inti** pada bagian 2 sampai 7 sesuai permintaan Anda: tiap topik disusun agar dapat langsung dipakai sebagai panduan belajar dan referensi teknis. Langkah berikut (opsional, saya siap lakukan jika Anda ingin langsung dilanjutkan oleh saya sekarang):

* **A.** Mengonversi tiap bagian di atas menjadi **dokumen Markdown** terpisah (mis. `02-wayland.md`, `03-modularity.md`, dst.) siap commit ke repo.
* **B.** Membuat serangkaian **latihan praktis** & rubrik penilaian untuk tiap modul.
* **C.** Menyusun skrip instalasi contoh (`install.sh` + PKGBUILD contoh) untuk repo Anda.

Jika Anda ingin saya langsung membuat A, B, atau C — sebutkan hurufnya. Kalau tidak, saya akan melanjutkan otomatis membuat **dokumen Markdown** untuk setiap modul agar bisa langsung Anda review.

---

Saya siap lanjutkan pembuatan file-file modul terperinci (Markdown + checklist latihan + contoh skrip) sekarang juga.

-->

[1]: https://wayland.freedesktop.org/architecture.html?utm_source=chatgpt.com "Wayland Architecture"
[2]: https://github.com/swaywm/wlroots?utm_source=chatgpt.com "swaywm/wlroots: A modular Wayland compositor library"
[3]: https://man.archlinux.org/man/sway.5?utm_source=chatgpt.com "sway(5) - Arch manual pages"
[4]: https://github.com/swaywm/sway?utm_source=chatgpt.com "swaywm/sway: i3-compatible Wayland compositor"
[5]: https://swaywm.org/?utm_source=chatgpt.com "Sway"
[6]: https://github.com/Alexays/Waybar?utm_source=chatgpt.com "Alexays/Waybar: Highly customizable Wayland bar for ..."
[7]: https://github.com/dylanaraps/pywal?utm_source=chatgpt.com "dylanaraps/pywal: 🎨 Generate and change color-schemes ..."
[8]: https://github.com/swaywm/swaybg?utm_source=chatgpt.com "swaywm/swaybg: Wallpaper tool for Wayland compositors"
[9]: https://wiki.archlinux.org/title/PKGBUILD?utm_source=chatgpt.com "PKGBUILD - ArchWiki"

<!--
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md


-->
[0]: ./sway/README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../

