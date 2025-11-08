# Roadmap Terstruktur — **Sway & Ekosistem Wayland**
<!--
*(gaya dokumentasi profesional ala GitHub; tersusun rapi, menggunakan ikon untuk navigasi cepat; Bahasa Indonesia resmi)*
-->

Tujuan dokumen: memberikan **peta belajar dan referensi dependensi** yang sangat jelas sehingga siapa pun — termasuk pemula teknis — dapat mulai membuat dotfiles Sway yang dapat dimengerti hingga setiap baris konfigurasi memiliki makna. Setelah kamu meng-audit dokumen ini, saya akan perjelas **isi tiap fase** menjadi materi lengkap (teori, contoh, latihan, verifikasi).

---

# 📚 Ikhtisar cepat

* 🔭 **Target akhir:** mengelola dotfiles Sway modular, mengintegrasikan tool Wayland (Waybar, Mako, Wofi, dsb.), menulis skrip automasi via IPC (`swaymsg`), dan memahami dasar kontributor Sway/wlroots.
* 🧭 **Pendekatan:** 7 fase bertahap — dari fondasi Wayland → konfigurasi dasar → utilitas resmi → ekosistem → scripting/IPC → debugging → build & kontribusi.
* ✅ **Outcome:** setiap konfigurasi disertai komentar sintaks & efek, dependensi lengkap, dan panduan modifikasi komponen (bahasa implementasi + toolchain).

---

# 🗂 Struktur logis roadmap (ringkasan fase)

1. 🧱 **Fase 0 — Persiapan & Prasyarat**
2. 🪟 **Fase 1 — Fondasi Wayland & wlroots**
3. ⚙️ **Fase 2 — Konfigurasi Dasar Sway (man 5 sway)**
4. 🔧 **Fase 3 — Utilitas Resmi Sway**
5. 🧩 **Fase 4 — Integrasi Ekosistem Wayland**
6. 🤖 **Fase 5 — IPC & Scripting Automasi**
7. 🔍 **Fase 6 — Debugging, Logging, dan Tracing**
8. 🛠️ **Fase 7 — Build From Source & Kontribusi**

> Setelah audit kamu, saya akan mengubah setiap fase menjadi sub-bab terperinci (tujuan, referensi man/URI, contoh `~/.config/sway/config` bertahap, laboratorium praktis, dan checklist verifikasi).

---

# 🔧 Fase 0 — Persiapan & Prasyarat (lengkap)

**Tujuan:** menyiapkan lingkungan yang stabil dan toolchain untuk pengembangan / konfigurasi.

## Perangkat keras & sistem

* Kernel modern (≥ generic kernel yang didukung distro).
* Driver GPU dengan dukungan KMS/DRM (Intel, AMD, NVIDIA ~~(Nouveau atau NVIDIA proprietary dengan wayland support)~~).
* Akses ke TTY atau display manager yang mendukung Wayland.

> Catatan: detil driver NVIDIA bervariasi; cek dokumentasi distribusi untuk dukungan Wayland + proprietary driver.

## Skill & tool yang direkomendasikan

* Bash / shell scripting — wajib.
* Git — wajib (dotfiles version control).
* Pemahaman dasar C — wajib bila ingin build/kontribusi.
* Meson & Ninja — untuk build Sway/wlroots.
* Python (opsional, untuk i3ipc scripting), Rust/Lua (opsional).

## Paket & dependensi (referensi **Arch Linux** — sesuaikan nama paket di distro lain)

**Paket runtime (minimal untuk pengguna):**

```
sway swaybg swaylock swayidle swaymsg swaynag
waybar mako wofi grim slurp wl-clipboard
alacritty foot or wezterm (terminal)
pipewire pipewire-pulse wireplumber
network-manager-applet (opsional)
jq
```

**Paket tambahan (disarankan):**

```
wayland wayland-protocols wlroots
python-pip (untuk i3ipc-python)
meson ninja pkgconf gcc (untuk build)
git
```

**Dev/build deps (untuk fase build & kontribusi):**

```
meson ninja pkgconf sway-devel wlroots-devel wayland-devel libinput-devel libxkbcommon-devel libseat-devel libxcb-devel
python (untuk test scripts)
```

> Catatan: nama paket dan ketersediaan header dapat berbeda antar distro (Debian/Ubuntu: `libwayland-dev`, `libwlroots-dev` atau paket dari PPA). Sesuaikan sebelum build.

---

# 🧭 Fase 1 — Fondasi Wayland & wlroots

**Inti:** pahami arsitektur Wayland (compositor ↔ client ↔ protocols) dan peran wlroots.
**Mengapa penting:** tanpa gambaran ini, perubahan pada Sway dan troubleshooting akan terasa menebak-nebak.

**Keluaran yang diharapkan:** ringkasan arsitektur (diagram), istilah penting (compositor, client, protocol, KMS/DRM, seat), serta catatan bagaimana wlroots menyediakan backend hardware abstraction.

---

# 🪄 Fase 2 — Konfigurasi Dasar Sway (man 5 sway)

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

# 🧰 Fase 3 — Utilitas Resmi Sway

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

# 🧩 Fase 4 — Integrasi Ekosistem Wayland

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

# 🤖 Fase 5 — IPC & Scripting Automasi

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

# 🔍 Fase 6 — Debugging, Logging & Tracing

**Teknik & perintah utama:**

* `sway -C ~/.config/sway/config` — syntax check.
* `swaymsg -t get_tree` / `-t get_outputs` — inspect state.
* `journalctl -b -u sway` / `journalctl -xe` — log systemd.
* `WAYLAND_DEBUG=1 sway` — log protokol Wayland (besar; gunakan filter).
* `sway -d 2> sway.log` — mode debug.

**Output fase:** panduan analisis log (pattern umum error), latihan memicu error, dan template laporan bug (untuk kontribusi).

---

# 🛠️ Fase 7 — Build From Source & Contribusi

**Kebutuhan untuk kontribusi / patch:**

* Bahasa: **C** (Sway & wlroots).
* Build system: **Meson + Ninja**.
* Toolchain: `meson`, `ninja`, `gcc/clang`, `pkg-config`, header library (wayland, wlroots, libinput, xkbcommon).
* Familiar dengan workflow Git (fork → branch → patch → PR).

**Deliverable fase:** langkah build reproducible, test minimal, panduan membuat patch dokumentasi atau bugfix kecil, dan checklist PR.

---

# 📦 Daftar Dependensi Lengkap (ringkasan — sesuaikan distro)

**Runtime (pengguna dotfiles biasa):**

* sway, swaybg, swaylock, swayidle, swaymsg, swaynag
* waybar, mako, wofi
* grim, slurp, wl-clipboard
* terminal (alacritty / foot / wezterm)
* pipewire, pipewire-pulse, wireplumber
* network manager applet (opsional)
* jq, git, bash

**Development / build:**

* meson, ninja, pkgconf / pkg-config
* gcc / clang, make (untuk beberapa deps)
* libwayland-dev / wayland-devel, wayland-protocols
* wlroots (library + headers), libinput-dev, libxkbcommon-dev, libseat-dev

> Saya akan menyediakan satu tabel yang lebih terperinci per-distro (Arch / Debian / Fedora) bila kamu setuju; tabel itu akan menyertakan nama paket tepat dan perintah instalasi.

---

# 🧾 Template Struktur Dotfiles (rekomendasi best-practice)

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

# ✅ Verifikasi & Checklist Awal (agar tidak ada kebingungan)

Sebelum menandai fase “siap”, setiap modul harus memenuhi checklist berikut:

* [ ] Semua paket runtime terinstal.
* [ ] `~/.config/sway/config` valid (`sway -C`).
* [ ] Keybinds dasar berfungsi (terminal, launcher, lock, screenshot).
* [ ] Waybar & Mako berjalan setelah login.
* [ ] Skrip monitor-setup mendeteksi dan mengaplikasikan preset.
* [ ] Contoh skrip IPC berjalan dan auto-assign bekerja.
* [ ] Ada dokumentasi singkat tiap file konfigurasi (komentar baris demi baris).

---

<!--

# 🔁 Alur audit & langkah selanjutnya (sesudah kamu review)

1. Kamu audit roadmap ini dan beri catatan (komentar per bagian / permintaan tambah/kurangi).
2. Saya akan memperbarui struktur sesuai catatan.
3. Setelah final, saya uraikan **setiap fase** menjadi materi lengkap:

   * penjelasan konsep, manpages yang relevan, potongan konfigurasi bertahap, laboratorium praktis, skrip contoh lengkap, dan rubrik penilaian.
4. Kamu dapat memilih fase yang ingin dipelajari/diterapkan lebih dahulu; saya akan susun jadwal belajar praktis per-hari/per-minggu.

---

Saya sudah menyusun roadmap lengkap, rapi, dan terstruktur sesuai permintaanmu. Silakan **audit dan beri catatan** (mis. tambahkan distro khusus, fokus bahasa scripting tertentu, atau permintaan templates tambahan). Setelah menerima audit, saya akan **memperjelas tiap fase** menjadi kurikulum detil yang kamu minta.-->
