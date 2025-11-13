- [Window-Manager](./window-manager/README.md)
- [Gnome](./gnome/README.md)
- [Kde-Plasma](./kde-plasma/README.md)
- [Xfce](./xfce/README.md)

# 🧩 Desktop Environment Development Curriculum & Documentation

Repositori ini berfungsi sebagai **panduan lengkap dan dokumentasi teknis** bagi siapa pun yang ingin memahami, membangun, serta mengembangkan lingkungan desktop (Desktop Environment) di sistem berbasis Linux — dengan fokus utama pada **Wayland + Sway + wlroots** serta integrasi ekosistem modern seperti PipeWire, systemd dan XDG Portals.

Dokumen ini menyatukan dua pendekatan:
1. **Pembelajaran Terstruktur** – menyusun tahapan belajar dan eksperimen.
2. **Dokumentasi Teknis Mendalam** – menguraikan komponen DE, bahasa implementasi, dependensi, serta referensi resmi pengembang.

---

## 🎯 Tujuan Utama

1. Menjadi **peta jalan pembelajaran** bagi pengembang yang ingin memahami setiap lapisan DE dari kernel hingga user interface.  
2. Menjadi **referensi teknis profesional** bagi kontribusi dan modifikasi proyek DE open source.  
3. Menyediakan **contoh konfigurasi dan lab praktis** berbasis CLI dan TUI.  
4. Menjadi **basis pembuatan distribusi custom (ISO)** yang dibangun di atas Arch Linux dan Wayland stack.

---

## 🧭 Struktur Modul Pembelajaran

| Modul | Fokus Pembelajaran | Estimasi Waktu | Status |
|-------|--------------------|----------------|--------|
| 1 | **Landasan Grafis & Render** — DRM, KMS, Mesa, Wayland, wlroots, Sway | 2 minggu | 🔄 Disusun |
| 2 | **Input Stack & Device Handling** — libinput, evdev, XKB, udev | 1 minggu | 🔄 Disusun |
| 3 | **Integrasi Lingkungan & Autostart** — XDG, .desktop, Portals, Session Manager | 1 minggu | ⏳ Dalam review |
| 4 | **Layanan Sistem & Kebijakan** — systemd, logind, Polkit, DBus | 2 minggu | 🔄 Disusun |
| 5 | **Komponen UI & Interaksi** — Waybar, dunst, rofi, notifications, clipboard | 2 minggu | 🔄 Disusun |
| 6 | **Tampilan & Desain Visual** — GTK/Qt Toolkit, Fonts, Themes, Color Management | 1 minggu | 🔄 Disusun |
| 7 | **Packaging & Distribusi** — Archiso, PKGBUILD, mkinitcpio, QEMU testing | 2 minggu | 🔄 Disusun |

---

## 📂 Struktur Repositori

```

.
├── README.md                # Dokumen utama (roadmap + TOC)
├── docs/
│   └── desktop_concepts.md  # Penjabaran teknis detail (49 konsep DE)
├── examples/
│   ├── sway/config          # Contoh konfigurasi Sway
│   ├── waybar/config        # Contoh Waybar modul
│   ├── systemd/user/        # Unit systemd user
│   └── iso/PKGBUILD         # Template pembuatan ISO
└── scripts/
├── build_iso.sh         # Otomatisasi build ISO Arch
└── test_qemu.sh         # Uji ISO melalui QEMU

```

---

## 🧠 Cara Menggunakan Dokumen Ini

1. Baca **README.md** untuk memahami urutan pembelajaran dan dependensi antar modul.  
2. Buka **docs/desktop_concepts.md** untuk penjelasan teknis mendalam (bahasa implementasi, file penting, CLI tools, referensi resmi).  
3. Jalankan contoh dari direktori **examples/** untuk setiap lab praktis.  
4. Gunakan direktori **scripts/** guna membangun, menguji, dan memverifikasi hasil di lingkungan virtual (QEMU).

---

## 📚 Referensi Utama

- [Wayland Protocol Documentation](https://wayland.freedesktop.org/docs/html/)
- [wlroots GitHub Repository](https://github.com/swaywm/wlroots)
- [Sway Wiki & Docs](https://github.com/swaywm/sway/wiki)
- [Arch Linux Wiki — Wayland, Sway, PipeWire, systemd](https://wiki.archlinux.org)
- [Freedesktop Standards](https://www.freedesktop.org/wiki/Specifications/)
- [systemd Documentation](https://www.freedesktop.org/software/systemd/man/)
- [PipeWire Documentation](https://docs.pipewire.org/)

---

> **Catatan Teknis:**  
> Setiap modul akan menjabarkan bahasa implementasi utama (C, C++, Shell, Lua, Rust, dst.), toolchain yang dibutuhkan (meson, ninja, make, pkg-config, gcc/clang), serta dependensi paket minimal yang harus dipasang di Arch Linux agar dapat membangun atau memodifikasi komponen terkait.

---

Fokus modul ini adalah memahami **fondasi grafis Linux modern** — mulai dari kernel DRM/KMS hingga compositor (Sway/wlroots) yang memanfaatkan protokol Wayland. Semua akan dijabarkan secara teknis sekaligus praktis dengan pendekatan pembelajaran dan dokumentasi developer.

Berikut versi lengkapnya:

---

# 🧱 Modul 1 — Landasan Grafis & Render

> “Segala sesuatu yang tampak di layar Linux bermula dari rantai panjang: kernel mengatur memori grafis, server mengatur permukaan, compositor menata ruang kerja.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami arsitektur grafis Linux modern: **DRM → KMS → Mesa → Wayland → wlroots → Sway**.  
2. Mengetahui bahasa implementasi, dependensi, serta toolchain dari setiap lapisan.  
3. Dapat membangun dan menguji compositor Wayland (Sway) dari sumber.  
4. Memahami cara kerja event loop Wayland dan komunikasi antar klien-kompositor.

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Peran | Toolchain / Build System |
|-----------|---------------|--------|----------------------------|
| **DRM/KMS** (Direct Rendering Manager / Kernel Mode Setting) | C | Antarmuka kernel untuk GPU dan framebuffer | Kernel headers, gcc |
| **Mesa 3D** | C | Library rendering OpenGL/Vulkan | meson, ninja |
| **Wayland** | C | Protokol komunikasi compositor ↔ client | meson, wayland-protocols |
| **wlroots** | C | Library untuk membuat compositor Wayland | meson, ninja, libdrm, libgbm |
| **Sway** | C | Tiling compositor berbasis wlroots | meson, ninja, wlroots-dev |
| **XWayland** | C | Kompatibilitas X11 di atas Wayland | meson, libx11, xorg-server-xwayland |

---

## 🧩 Prasyarat Teknis

**1. Pengetahuan yang diperlukan**
- Dasar bahasa C (struktur, pointer, build process).
- Pemahaman sistem file Linux dan hak akses perangkat (`/dev/dri`).
- Familiar dengan CLI: `gcc`, `pkg-config`, `meson`, `ninja`, `systemctl`, `journalctl`.

**2. Paket minimal yang perlu dipasang (Arch Linux):**
```bash
sudo pacman -S base-devel git meson ninja wayland wlroots sway xorg-server-xwayland mesa \
libdrm libgbm wayland-protocols seatd elogind
```

**3. Lingkungan kerja disarankan:**

* OS: Arch Linux (atau turunan minimal seperti Artix, CachyOS)
* WM: Sway (atau TTY saat build)
* Terminal: foot, alacritty, atau kitty
* Shell: bash/zsh/fish

---

## 🧪 Lab Praktis

### 🧠 Lab 1 — Membangun dan Menjalankan Sway dari Source

```bash
# 1. Clone wlroots dan sway
git clone https://github.com/swaywm/wlroots.git
git clone https://github.com/swaywm/sway.git

# 2. Build wlroots
cd wlroots
meson build
ninja -C build
sudo ninja -C build install

# 3. Build sway
cd ../sway
meson build
ninja -C build
sudo ninja -C build install

# 4. Jalankan sway (TTY atau nested mode)
sway
```

**Hasil:**
Lingkungan Wayland berjalan di atas kernel DRM/KMS menggunakan wlroots sebagai compositor library.

---

### 🧩 Lab 2 — Memeriksa Event & Debugging Wayland

```bash
# Tampilkan socket aktif (komunikasi compositor ↔ client)
echo $WAYLAND_DISPLAY

# Jalankan klien Wayland minimal
weston-info

# Debug pesan protokol
WAYLAND_DEBUG=1 alacritty

# Lihat log compositor
journalctl --user -u sway.service
```

**Tujuan:**
Memahami bagaimana klien berkomunikasi dengan compositor melalui socket Wayland dan bagaimana event diproses secara asynchronous.

---

## 📂 File & Direktori Penting

| Path                           | Deskripsi                                   |
| ------------------------------ | ------------------------------------------- |
| `/usr/share/wayland-sessions/` | File `.desktop` untuk login Wayland session |
| `/usr/share/wayland/`          | XML protokol Wayland                        |
| `/usr/include/wlr/`            | Header library wlroots                      |
| `~/.config/sway/config`        | File konfigurasi utama Sway                 |
| `/etc/udev/rules.d/`           | Aturan akses perangkat input/output         |
| `/dev/dri/card0`               | Antarmuka DRM ke GPU utama                  |

---

## 🧰 Alur Render Sederhana

```
Client → libwayland-client → Socket → libwayland-server → wlroots (renderer) 
→ DRM → KMS → Framebuffer → Tampilan fisik
```

* **Client** mengirim buffer ke **compositor** (wlroots/Sway).
* **Compositor** mengatur posisi, layering, dan efek.
* **DRM/KMS** di kernel mengirim hasil akhir ke framebuffer (display).

---

## 🧭 Diagram Sederhana (Arsitektur Wayland)

```
+-----------------------------+
|        User Applications    |
|   (Terminal, Browser, etc)  |
+-------------+---------------+
              |
              v
+-----------------------------+
|        Wayland Client       |
|    libwayland-client.so     |
+-------------+---------------+
              |
              v
+-----------------------------+
|     Wayland Compositor      |
| (Sway, wlroots, Weston, ...)|
+-------------+---------------+
              |
              v
+-----------------------------+
|        DRM / KMS Layer      |
|     (Kernel + GPU Driver)   |
+-----------------------------+
              |
              v
+-----------------------------+
|          Framebuffer        |
|          (Display)          |
+-----------------------------+
```

---

## 🔗 Referensi Resmi

* **Wayland Protocol:** [https://wayland.freedesktop.org/docs/html/](https://wayland.freedesktop.org/docs/html/)
* **wlroots Documentation:** [https://github.com/swaywm/wlroots](https://github.com/swaywm/wlroots)
* **Sway Wiki:** [https://github.com/swaywm/sway/wiki](https://github.com/swaywm/sway/wiki)
* **Arch Wiki – Sway & Wayland:** [https://wiki.archlinux.org/title/Sway](https://wiki.archlinux.org/title/Sway)
* **DRM/KMS Kernel Documentation:** [https://www.kernel.org/doc/html/latest/gpu/drm-kms.html](https://www.kernel.org/doc/html/latest/gpu/drm-kms.html)
* **Mesa 3D:** [https://docs.mesa3d.org/](https://docs.mesa3d.org/)
* **XWayland:** [https://gitlab.freedesktop.org/xorg/xserver](https://gitlab.freedesktop.org/xorg/xserver)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda akan mampu:

* Menjelaskan hubungan antara DRM, KMS, Mesa, Wayland, wlroots, dan Sway.
* Membangun compositor Wayland secara mandiri dari sumber.
* Melakukan debugging socket komunikasi Wayland.
* Mengidentifikasi peran tiap komponen pada pipeline grafis Linux modern.

---

> 💡 *Catatan Developer:*
> Pada tahap berikutnya (Modul 2), Anda akan beralih dari pipeline grafis menuju **stack input** — yaitu sistem yang menangani keyboard, mouse, dan device event melalui libinput dan udev.

---

Modul ini memperkenalkan cara sistem Linux membaca, mengenali, dan menyalurkan event perangkat ke compositor (misalnya Sway), serta bagaimana Anda dapat men-debug, mengubah, atau menambah aturan perangkat sendiri.

---

# 🎛️ Modul 2 — Input Stack & Device Handling

> “Tanpa input, desktop hanyalah gambar. Setiap ketukan tombol dan gerak tetikus melewati rantai kernel, daemon, dan pustaka hingga mencapai aplikasi.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami arsitektur **input stack** pada sistem Linux: `evdev → udev → libinput → compositor`.  
2. Mengetahui bahasa implementasi, tool, dan file konfigurasi dari masing-masing komponen.  
3. Mampu mengonfigurasi dan menguji perilaku perangkat input pada Sway/Wayland.  
4. Mampu menulis aturan udev sederhana untuk mengenali atau memodifikasi perangkat.

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Peran | Toolchain / Build System |
|-----------|---------------|--------|----------------------------|
| **evdev** (Event Device) | C | Antarmuka kernel untuk perangkat input (`/dev/input/event*`) | Kernel headers, gcc |
| **udev** (device manager) | C | Menangani deteksi perangkat dan menetapkan permission/rules | systemd, libudev |
| **libinput** | C | Abstraksi perangkat input modern untuk Wayland | meson, ninja |
| **XKB / xkeyboard-config** | C | Layout dan pemetaan tombol keyboard | autotools, libxkbcommon |
| **seatd / elogind** | C | Manajemen sesi input/output non-root | meson |
| **sway-input** | C (konfigurasi runtime) | Bagian konfigurasi input pada Sway | swaymsg IPC, wlroots input API |

---

## 🧩 Prasyarat Teknis

**Pengetahuan:**
- Struktur sistem `/dev`, permission, dan rule udev.  
- Dasar debugging kernel log (`dmesg`, `journalctl`).  
- Familiar dengan perintah CLI: `udevadm`, `libinput`, `evtest`, `swaymsg`.

**Paket minimal (Arch Linux):**
```bash
sudo pacman -S libinput libevdev libxkbcommon udev seatd elogind evtest sway
```

---

## 🧪 Lab Praktis

### 🔧 Lab 1 — Menguji Perangkat Input

```bash
# Daftar event device
ls /dev/input/

# Lihat detail satu perangkat
sudo evtest /dev/input/event3

# Lihat daftar perangkat aktif yang dikenali libinput
sudo libinput list-devices

# Jalankan monitor event real-time
sudo libinput debug-events
```

**Tujuan:**
Memahami bagaimana kernel menghasilkan event input dan bagaimana `libinput` membaca serta memetakannya.

---

### 🧠 Lab 2 — Membuat Aturan udev Kustom

1. Buat file aturan baru:
   `/etc/udev/rules.d/99-custom-input.rules`

```bash
# Contoh: ubah permission dan beri nama alias pada keyboard tertentu
ATTRS{name}=="AT Translated Set 2 keyboard", \
  MODE="0666", \
  SYMLINK+="input/keyboard_primary"
```

2. Terapkan perubahan:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

3. Verifikasi:

```bash
ls -l /dev/input/keyboard_primary
```

**Hasil:**
Keyboard Anda kini memiliki alias `keyboard_primary` dan bisa diakses oleh user non-root.

---

## 🧭 Integrasi dengan Sway

File konfigurasi `~/.config/sway/config`:

```ini
# Konfigurasi keyboard
input "type:keyboard" {
    xkb_layout us
    xkb_variant altgr-intl
    repeat_delay 300
    repeat_rate 50
}

# Konfigurasi touchpad
input "type:touchpad" {
    tap enabled
    natural_scroll enabled
    pointer_accel 0.3
}
```

Gunakan `swaymsg -t get_inputs` untuk melihat daftar perangkat aktif beserta properti yang dikenali compositor.

---

## 📂 File & Direktori Penting

| Path                     | Deskripsi                    |
| ------------------------ | ---------------------------- |
| `/dev/input/event*`      | File perangkat input kernel  |
| `/etc/udev/rules.d/`     | Aturan kustom perangkat      |
| `/usr/lib/udev/rules.d/` | Aturan default dari paket    |
| `/usr/share/X11/xkb/`    | File layout keyboard         |
| `~/.config/sway/config`  | Konfigurasi input compositor |
| `/run/seatd.sock`        | Socket manajemen sesi input  |

---

## 🧰 Alur Data Input

```
Perangkat fisik → evdev → udev → libinput → compositor (Sway) → aplikasi (client)
```

* **evdev** menangkap sinyal hardware mentah.
* **udev** mengidentifikasi dan memberi permission.
* **libinput** menstandarkan event dan gesture.
* **Compositor** mengirim event ke aplikasi.

---

## 🔍 Debugging & Monitoring

```bash
# Monitor semua event input
sudo libinput debug-events

# Cek rule udev yang berlaku untuk perangkat tertentu
udevadm info -a -n /dev/input/event3

# Tampilkan layout keyboard aktif
setxkbmap -query
```

---

## 🔗 Referensi Resmi

* [libinput Documentation](https://wayland.freedesktop.org/libinput/doc/latest/)
* [udev — systemd documentation](https://www.freedesktop.org/software/systemd/man/udev.html)
* [evdev Kernel Docs](https://www.kernel.org/doc/html/latest/input/)
* [xkbcommon Library](https://xkbcommon.org/)
* [Arch Wiki – Input Stack](https://wiki.archlinux.org/title/libinput)
* [Sway Input Configuration](https://github.com/swaywm/sway/wiki#input)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda mampu:

* Menjelaskan alur input Linux dari kernel hingga aplikasi.
* Menguji dan memodifikasi perilaku perangkat input menggunakan `libinput` dan `udev`.
* Menulis aturan perangkat sederhana dan menyesuaikan konfigurasi input pada Sway.
* Melakukan debugging event input secara real-time.

---

> 💡 *Catatan Developer:*
> Modul berikutnya akan melanjutkan integrasi ini ke tingkat lingkungan desktop: **autostart, session management, dan XDG integration** — di mana Anda mempelajari bagaimana aplikasi Wayland dijalankan, dikelola, dan diisolasi dalam sesi user.

---

Modul ini akan mengupas sistem **XDG, Autostart, .desktop, DBus, Session Manager, dan Portal**, yang merupakan fondasi interoperabilitas antar aplikasi di Wayland.

---

# 🧩 Modul 3 — Integrasi Lingkungan & Autostart

> “Begitu compositor hidup, lingkungan desktop menyalakan denyut kehidupannya — menjalankan service, memanggil aplikasi, dan mengatur izin mereka agar tidak saling mengacau.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami bagaimana *Desktop Environment* menginisialisasi sesi pengguna.  
2. Mengetahui peran **XDG Base Directory, Autostart, .desktop files, dan Session Manager**.  
3. Mampu membuat dan mengelola **autostart service** dan **XDG session environment**.  
4. Memahami cara kerja **DBus** dan **XDG Portals** sebagai penghubung antar aplikasi Wayland.

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Peran | Toolchain / Build System |
|-----------|---------------|--------|----------------------------|
| **XDG Base Directory** | — | Standar lokasi konfigurasi pengguna | Freedesktop.org |
| **XDG Autostart** | — | Menjalankan aplikasi otomatis saat sesi dimulai | freedesktop/autostart-spec |
| **.desktop files** | — | Deskriptor aplikasi (name, exec, icon, category) | text/plain |
| **DBus** | C | IPC antar aplikasi & service | meson, libdbus |
| **systemd --user** | C | Manajer layanan sesi pengguna | systemd, meson |
| **XDG Portals** | C | Abstraksi izin untuk Wayland (file picker, screen share, dll.) | meson, xdg-desktop-portal |
| **Environment Loader** | bash | Mengatur variabel lingkungan global | shell |

---

## 🧩 Prasyarat Teknis

**Pengetahuan:**
- Struktur direktori `~/.config`, `~/.local/share`, dan `/etc/xdg`.  
- Cara kerja service systemd user (`systemctl --user`).  
- Dasar komunikasi antar proses (IPC).  
- Monitoring real-time dengan watch `watch -n 1 'df -h | grep /dev/sda1'`

**Paket minimal (Arch Linux):**
```bash
sudo pacman -S xdg-utils xdg-desktop-portal dbus systemd libportal
```

---

## 🧪 Lab Praktis

### 🧠 Lab 1 — Membuat Aplikasi Autostart

1. Buat direktori autostart:

```bash
mkdir -p ~/.config/autostart
```

2. Buat file `~/.config/autostart/terminal.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Alacritty
Exec=alacritty
X-GNOME-Autostart-enabled=true
```

3. Uji dengan menjalankan sesi baru Sway:

```bash
systemctl --user restart sway-session.target
```

**Hasil:**
Terminal `alacritty` otomatis terbuka setiap kali sesi Wayland dimulai.

---

### ⚙️ Lab 2 — Mengatur Variabel Lingkungan Global (XDG)

1. Buat file `~/.config/environment.d/10-desktop.conf`:

```bash
# Environment global untuk Wayland session
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=sway
MOZ_ENABLE_WAYLAND=1
QT_QPA_PLATFORM=wayland
```

2. Terapkan dengan reload sesi:

```bash
systemctl --user import-environment
```

3. Periksa:

```bash
systemctl --user show-environment | grep XDG
```

**Hasil:**
Variabel lingkungan tersimpan dan diaktifkan secara permanen oleh systemd user manager.

---

## 🧭 Integrasi DBus dan XDG Portals

* **DBus** berfungsi sebagai *message bus* antara aplikasi dan sistem (mis. pengaturan volume, status jaringan, power management).
* **XDG Portal** adalah lapisan izin di atas DBus untuk Wayland, menggantikan konsep X11 direct access.

**Contoh arsitektur:**

```
App (client)
  ↓
XDG Portal Interface
  ↓
xdg-desktop-portal (service DBus)
  ↓
Underlying implementation (e.g. wlroots, KDE, GNOME backend)
```

### Contoh debugging portal:

```bash
dbus-monitor --session "interface='org.freedesktop.portal.Desktop'"
```

---

## 📂 File & Direktori Penting

| Path                             | Deskripsi                             |
| -------------------------------- | ------------------------------------- |
| `~/.config/autostart/`           | Tempat file `.desktop` autostart      |
| `/etc/xdg/autostart/`            | Autostart global untuk semua pengguna |
| `/usr/share/applications/`       | Instalasi `.desktop` global aplikasi  |
| `/usr/share/dbus-1/services/`    | Definisi service DBus                 |
| `/usr/share/xdg-desktop-portal/` | Backend Portal yang digunakan         |
| `~/.config/environment.d/`       | Variabel lingkungan sesi              |
| `/usr/lib/systemd/user/`         | Unit systemd untuk sesi pengguna      |

---

## 🧰 Arus Kerja Sesi Wayland (Simplifikasi)

```
Login → PAM → systemd --user → Environment Loader
      → DBus session bus → Compositor (Sway)
      → Autostart Apps (.desktop)
      → Portals handle permissions
```

---

## 🧠 Debugging & Troubleshooting

```bash
# Lihat daftar service sesi user
systemctl --user list-units --type=service

# Cek status portal
systemctl --user status xdg-desktop-portal.service

# Monitor DBus events
dbus-monitor --session

# Cek variabel lingkungan aktif
printenv | grep XDG
```

---

## 🔗 Referensi Resmi

* [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
* [XDG Autostart Specification](https://specifications.freedesktop.org/autostart-spec/latest/)
* [Desktop Entry Specification (.desktop)](https://specifications.freedesktop.org/desktop-entry-spec/latest/)
* [DBus Specification](https://dbus.freedesktop.org/doc/dbus-specification.html)
* [XDG Desktop Portal](https://flatpak.github.io/xdg-desktop-portal/)
* [Arch Wiki – XDG integration](https://wiki.archlinux.org/title/XDG_Base_Directory)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda akan mampu:

* Membuat dan mengelola aplikasi autostart secara manual sesuai standar XDG.
* Mengatur variabel lingkungan sesi dengan systemd user manager.
* Menjelaskan cara kerja komunikasi antar aplikasi melalui DBus dan portal.
* Melakukan debugging layanan sesi dan portal pada lingkungan Wayland.

---

> 💡 *Catatan Developer:*
> Modul berikutnya akan menelusuri **lapisan layanan sistem** yang lebih dalam — seperti *systemd, logind, udev, dan Polkit* — untuk memahami bagaimana keamanan, izin, dan manajemen daya dikendalikan oleh lingkungan desktop.

---

Inilah lapisan “jantung sistem” yang bekerja di bawah permukaan desktop, memastikan semua layanan berjalan dengan izin yang tepat, perangkat dikenali dengan aman, dan sistem dapat menanggapi event (seperti sleep, power, suspend, mount, dsb.).
Modul ini adalah penghubung antara **kernel-space (udev, logind)** dan **user-space (compositor, apps)**.

---

# 🛠️ Modul 4 — Layanan Sistem & Kebijakan

> “Sistem desktop yang sehat bukan hanya tampilannya yang indah — melainkan keteraturan proses, izin, dan layanan yang berjalan harmonis di balik layar.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami peran **systemd**, **logind**, **udev**, dan **Polkit** dalam sistem desktop modern.  
2. Mengetahui cara kerja *service management* pada level sistem dan pengguna.  
3. Mampu membuat, mengatur, dan men-debug unit `systemd --user`.  
4. Mampu memahami konsep *authorization* dan *policy control* melalui Polkit.

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Peran | Toolchain / Build System |
|-----------|---------------|--------|----------------------------|
| **systemd** | C | Init system dan service manager utama | meson, ninja |
| **logind** | C | Manajer sesi pengguna (login, power, device access) | bagian dari systemd |
| **udev** | C | Device manager kernel-space → user-space | bagian dari systemd |
| **Polkit** | C | Framework izin administratif | meson, glib, dbus |
| **DBus system bus** | C | Komunikasi antar komponen sistem | libdbus, systemd |
| **seatd / elogind** | C | Alternatif ringan untuk logind (sesi Wayland non-root) | meson |

---

## 🧩 Prasyarat Teknis

**Pengetahuan:**
- Pemahaman dasar proses Linux (`ps`, `systemctl`, `journalctl`).  
- Konsep privilege dan izin (root vs user).  
- Familiar dengan komunikasi DBus dan variabel lingkungan.

**Paket minimal (Arch Linux):**
```bash
sudo pacman -S systemd polkit udev dbus seatd elogind
```

---

## 🧪 Lab Praktis

### ⚙️ Lab 1 — Membuat Systemd User Service

1. Buat direktori user service:

```bash
mkdir -p ~/.config/systemd/user
```

2. Buat file `~/.config/systemd/user/hello.service`:

```ini
[Unit]
Description=Contoh layanan pengguna sederhana

[Service]
ExecStart=/usr/bin/bash -c "echo Halo dari systemd user! && sleep 60"

[Install]
WantedBy=default.target
```

3. Jalankan dan periksa:

```bash
systemctl --user daemon-reload
systemctl --user start hello.service
systemctl --user status hello.service
```

4. Aktifkan otomatis saat login:

```bash
systemctl --user enable hello.service
```

**Hasil:**
Layanan berjalan di ruang pengguna (tanpa hak root) dan dapat diawasi oleh systemd.

---

### 🔒 Lab 2 — Menguji Akses Polkit

1. Periksa rule Polkit yang aktif:

```bash
pkaction
```

2. Buat rule sederhana `/etc/polkit-1/rules.d/50-allow-reboot.rules`:

```js
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.reboot" &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
```

3. Uji:

```bash
loginctl reboot
```

Jika Anda anggota grup `wheel`, reboot akan diizinkan tanpa password.

---

## 🧭 Integrasi antar Komponen

| Komponen              | Komunikasi Melalui                  | Fungsi                                      |
| --------------------- | ----------------------------------- | ------------------------------------------- |
| **systemd-logind**    | DBus (`org.freedesktop.login1`)     | Mengelola sesi dan perangkat                |
| **Polkit**            | DBus (`org.freedesktop.PolicyKit1`) | Validasi izin administratif                 |
| **udev**              | Netlink socket                      | Mendeteksi perangkat baru                   |
| **seatd / elogind**   | Socket lokal                        | Menyediakan akses non-root untuk compositor |
| **sway / compositor** | DBus / wlroots seat                 | Mengontrol input & sesi tampilan            |

---

## 📂 File & Direktori Penting

| Path                                 | Deskripsi                   |
| ------------------------------------ | --------------------------- |
| `/etc/systemd/system/`               | Unit service sistem         |
| `~/.config/systemd/user/`            | Unit service pengguna       |
| `/etc/polkit-1/rules.d/`             | File aturan izin Polkit     |
| `/usr/share/dbus-1/system-services/` | Definisi service system bus |
| `/run/systemd/seats/`                | Informasi sesi aktif        |
| `/etc/udev/rules.d/`                 | Aturan perangkat            |
| `/var/log/journal/`                  | Log systemd (persistent)    |

---

## 🔍 Debugging & Monitoring

```bash
# Melihat semua service aktif
systemctl list-units --type=service

# Melihat service user
systemctl --user list-units --type=service

# Melihat event perangkat
udevadm monitor

# Cek status login & sesi aktif
loginctl list-sessions

# Lihat log Polkit
journalctl -u polkit.service
```

---

## 🧠 Diagram Sederhana: Interaksi Layanan Sistem

```
+-----------------------------+
|        User Applications    |
+-------------+---------------+
              |
              v
+-----------------------------+
|         Compositor (Sway)   |
|   Seat / wlroots / seatd    |
+-------------+---------------+
              |
              v
+-----------------------------+
|   logind / elogind / udev   |
|    (Session, Devices)       |
+-------------+---------------+
              |
              v
+-----------------------------+
|         systemd Core        |
|   (Services, Targets, Bus)  |
+-------------+---------------+
              |
              v
+-----------------------------+
|           Kernel            |
+-----------------------------+
```

---

## 🔗 Referensi Resmi

* [systemd Documentation](https://www.freedesktop.org/software/systemd/man/systemd.html)
* [logind API Reference](https://www.freedesktop.org/software/systemd/man/logind.html)
* [Polkit Rules Documentation](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html)
* [udev Manpage](https://www.freedesktop.org/software/systemd/man/udev.html)
* [Arch Wiki – systemd, Polkit, udev, elogind](https://wiki.archlinux.org/)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda akan mampu:

* Membuat dan mengelola service `systemd --user`.
* Mengatur dan men-debug rule Polkit untuk kontrol izin administratif.
* Menjelaskan peran logind, udev, dan Polkit dalam siklus hidup sesi desktop.
* Melacak event perangkat dan layanan dengan `journalctl` dan `udevadm`.

---

> 💡 *Catatan Developer:*
> Modul berikutnya akan melangkah ke lapisan **User Interface (UI) & Interaksi Visual**, di mana Anda akan mempelajari **Waybar, dunst, rofi, clipboard, dan notifikasi sistem** — bagian yang berinteraksi langsung dengan pengguna.

---

Modul ini membawa kita ke lapisan yang *paling kasat mata*: **status bar, notifikasi, launcher, dan clipboard manager.**
Inilah tempat interaksi pengguna terjadi — yang menghubungkan fungsi sistem (systemd, input, session) ke pengalaman nyata di layar.

---

# 🪟 Modul 5 — Komponen UI & Interaksi

> “Di sinilah abstraksi menjadi pengalaman: status bar menampilkan denyut sistem, notifikasi memberi kabar, dan launcher menjadi gerbang menuju aplikasi.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami peran komponen UI ringan (bar, launcher, notifikasi, clipboard).  
2. Mengetahui arsitektur dan bahasa implementasi dari **Waybar, dunst, rofi, clipman**.  
3. Dapat membuat dan menyesuaikan konfigurasi TUI/CLI dari komponen tersebut.  
4. Mampu mengintegrasikan komponen UI ke compositor (Sway/Wayland) menggunakan *autostart* atau systemd user unit.

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Fungsi | Konfigurasi |
|-----------|---------------|---------|--------------|
| **Waybar** | C++ | Status bar modular untuk Wayland | JSON / CSS |
| **dunst** | C | Daemon notifikasi freedesktop | INI-style config |
| **rofi / wofi** | C | Application launcher dan window switcher | Rasi / CSS |
| **clipman / wl-clipboard** | C | Clipboard manager untuk Wayland | CLI |
| **mako** (alternatif dunst) | C | Notifikasi ringan berbasis Wayland | INI config |

---

## 🧩 Prasyarat Teknis

**Pengetahuan:**
- Familiar dengan format konfigurasi JSON, INI, CSS sederhana.  
- Pemahaman dasar autostart (XDG) atau systemd user service.  

**Paket minimal (Arch Linux):**
```bash
sudo pacman -S waybar dunst rofi wl-clipboard clipman mako
````

---

## 🧪 Lab Praktis

### 🧠 Lab 1 — Konfigurasi Waybar

1. Buat direktori konfigurasi:

```bash
mkdir -p ~/.config/waybar
```

2. Buat file `~/.config/waybar/config`:

```json
{
  "layer": "top",
  "modules-left": ["sway/workspaces", "sway/mode"],
  "modules-center": ["clock"],
  "modules-right": ["cpu", "memory", "network", "battery"],
  "clock": { "format": "%a %d %b %H:%M" },
  "cpu": { "interval": 10 },
  "memory": { "interval": 30 }
}
```

3. Tambahkan gaya (opsional): `~/.config/waybar/style.css`

```css
* {
  font-family: JetBrainsMono, monospace;
  color: #e0e0e0;
}
#clock {
  color: #a6e3a1;
}
```

4. Jalankan Waybar dari terminal:

```bash
waybar &
```

5. Contoh chmod symbolic

```bash
chmod u+x,g-w,o-r file.txt
```

**Hasil:**
Bar tampil di atas layar dengan modul real-time (CPU, RAM, jaringan, jam, workspace).

---

### 💬 Lab 2 — Menampilkan Notifikasi & Launcher

#### Menjalankan daemon notifikasi:

```bash
dunst &
```

#### Mengirim notifikasi uji:

```bash
notify-send "Sway Environment" "Dunst notification works!"
```

#### Menjalankan launcher:

```bash
rofi -show drun
# atau versi Wayland-native
wofi --show drun
```

#### Menyalin dan menempel teks (Wayland):

```bash
echo "Hello Clipboard" | wl-copy
wl-paste
```

**Hasil:**
Sistem notifikasi, launcher, dan clipboard berfungsi penuh di lingkungan Wayland.

---

## 🧭 Integrasi dengan Sway

Tambahkan ke `~/.config/sway/config`:

```ini
# Jalankan Waybar dan Dunst otomatis
exec_always waybar
exec_always dunst

# Jalankan Rofi dengan keybinding
bindsym $mod+d exec rofi -show drun
```

Atau buat systemd user service:

```ini
# ~/.config/systemd/user/waybar.service
[Unit]
Description=Waybar Panel
After=graphical-session.target

[Service]
ExecStart=/usr/bin/waybar
Restart=always

[Install]
WantedBy=default.target
```

---

## 📂 File & Direktori Penting

| Path                                | Deskripsi                     |
| ----------------------------------- | ----------------------------- |
| `~/.config/waybar/config`           | Konfigurasi utama Waybar      |
| `~/.config/dunst/dunstrc`           | Konfigurasi notifikasi        |
| `~/.config/rofi/config.rasi`        | Launcher & tema               |
| `/usr/share/wayland-sessions/`      | Sesi Wayland                  |
| `/usr/share/icons/`                 | Tema ikon global              |
| `/usr/share/applications/*.desktop` | Entry aplikasi untuk launcher |

---

## 🧰 Arus Kerja Interaksi UI

```
User Input → Compositor (Sway) → IPC (wlroots)
        ↳ Waybar (status)
        ↳ Dunst / Mako (notifications)
        ↳ Rofi / Wofi (launcher)
        ↳ Clipboard (wl-clipboard)
```

---

## 🔍 Debugging & Monitoring

```bash
# Periksa status service user
systemctl --user status waybar.service

# Lihat log notifikasi
journalctl --user -u dunst.service

# Debug bar dengan verbose mode
waybar -l trace
```

---

## 🔗 Referensi Resmi

* [Waybar Documentation](https://github.com/Alexays/Waybar/wiki)
* [Dunst Documentation](https://dunst-project.org/documentation/)
* [Rofi User Guide](https://github.com/davatorium/rofi)
* [Wofi (Wayland launcher)](https://hg.sr.ht/~scoopta/wofi)
* [wl-clipboard Project](https://github.com/bugaevc/wl-clipboard)
* [Arch Wiki – Waybar, Dunst, Rofi, Clipboard](https://wiki.archlinux.org/)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda akan mampu:

* Mengonfigurasi status bar modular (Waybar).
* Menjalankan dan menyesuaikan daemon notifikasi (Dunst / Mako).
* Menggunakan launcher Wayland (Rofi / Wofi) dan clipboard.
* Mengintegrasikan semua komponen UI dengan compositor Sway secara otomatis.

---

> 💡 *Catatan Developer:*
> Modul berikutnya (Modul 6) akan membawa Anda ke **dunia desain tampilan dan tema visual** — di mana GTK, Qt, font, dan manajemen warna berperan penting dalam menciptakan pengalaman estetika yang konsisten di Wayland.

---

Modul ini adalah jembatan antara sisi teknis dan estetika: di sinilah Anda belajar bagaimana tampilan di Wayland dikendalikan oleh *toolkit*, *font system*, *tema warna*, serta *manajemen profil warna*. Semua hal yang membuat antarmuka bukan sekadar berfungsi — tetapi juga nyaman dilihat.

---

# 🎨 Modul 6 — Tampilan & Desain Visual

> “Desain visual bukan hanya soal indah, melainkan tentang keterbacaan, kenyamanan mata, dan keselarasan warna di setiap komponen.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami peran toolkit grafis (GTK & Qt) dalam tampilan aplikasi di Wayland.  
2. Mengetahui sistem font, rendering, dan konfigurasi warna di Linux.  
3. Dapat menyesuaikan tema GTK/Qt agar konsisten pada semua aplikasi.  
4. Mampu mengelola font, ikon, dan warna melalui konfigurasi global.

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Fungsi | Build System |
|-----------|---------------|---------|----------------|
| **GTK (GIMP Toolkit)** | C | Toolkit antarmuka grafis GNOME & Wayland | meson |
| **Qt Framework** | C++ | Toolkit grafis untuk KDE & cross-platform | cmake/qmake |
| **Fontconfig** | C | Library konfigurasi font | autotools |
| **Freetype** | C | Rendering font | autotools |
| **Cairo** | C | 2D vector rendering engine | meson |
| **colord** | C | Manajemen profil warna (ICC) | meson |
| **Xresources (legacy)** | Text | Variabel warna untuk X11/terminal | plain text |
| **GTK Theme / Icon Theme** | CSS / XML | Tema tampilan visual | stylesheet |

---

## 🧩 Prasyarat Teknis

**Pengetahuan:**
- Struktur direktori tema GTK/Qt.  
- Pemahaman dasar CSS untuk kustomisasi tema GTK.  
- Pengetahuan dasar rendering (dpi, font hinting, antialiasing).  

**Paket minimal (Arch Linux):**
```bash
sudo pacman -S gtk3 qt5-base qt6-base fontconfig freetype2 cairo colord \
noto-fonts ttf-dejavu papirus-icon-theme lxappearance qt5ct qt6ct
````

---

## 🧪 Lab Praktis

### 🧠 Lab 1 — Mengatur Tema GTK & Qt

1. **GTK Theme**

   * Buka pengaturan tema (CLI):

     ```bash
     lxappearance
     ```
   * Pilih tema seperti *Adwaita-dark*, *Arc*, atau *Catppuccin*.
   * Simpan hasilnya di `~/.config/gtk-3.0/settings.ini`:

     ```ini
     [Settings]
     gtk-theme-name=Catppuccin-Mocha-Blue
     gtk-icon-theme-name=Papirus-Dark
     gtk-font-name=JetBrains Mono 10
     ```

2. **Qt Theme**

   * Jalankan:

     ```bash
     qt5ct
     qt6ct
     ```
   * Pilih gaya tema dan font.
   * Simpan hasil di `~/.config/qt5ct/qt5ct.conf` dan `~/.config/qt6ct/qt6ct.conf`.

**Hasil:**
Aplikasi GTK dan Qt memiliki gaya dan font yang seragam di bawah Wayland.

---

### 🖋️ Lab 2 — Mengatur Font & Rendering

1. Buat file konfigurasi font global:
   `~/.config/fontconfig/fonts.conf`

```xml
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
  </match>
</fontconfig>
```

2. Terapkan:

```bash
fc-cache -fv
```

3. Uji rendering:

```bash
fc-match monospace
```

**Hasil:**
Teks lebih halus dengan antialiasing dan hinting optimal di semua aplikasi.

---

## 🧭 Manajemen Warna dan Tema Terminal

1. **Warna sistem (GTK):**

   * File: `~/.config/gtk-4.0/gtk.css`
   * Contoh isi:

     ```css
     window {
       background-color: #1e1e2e;
       color: #cdd6f4;
     }
     ```

2. **Warna terminal (Alacritty):**

   * File: `~/.config/alacritty/alacritty.yml`
   * Contoh:

     ```yaml
     colors:
       primary:
         background: '0x1e1e2e'
         foreground: '0xcdd6f4'
       normal:
         black:   '0x181825'
         red:     '0xf38ba8'
     ```

3. **Manajemen profil warna (colord):**

   ```bash
   colormgr get-devices
   colormgr device-get-profile <device>
   ```

---

## 📂 File & Direktori Penting

| Path                              | Deskripsi               |
| --------------------------------- | ----------------------- |
| `~/.config/gtk-3.0/settings.ini`  | Tema GTK3               |
| `~/.config/qt5ct/qt5ct.conf`      | Tema Qt5                |
| `~/.config/qt6ct/qt6ct.conf`      | Tema Qt6                |
| `~/.config/fontconfig/fonts.conf` | Konfigurasi font global |
| `/usr/share/icons/`               | Koleksi ikon global     |
| `/usr/share/themes/`              | Koleksi tema GTK global |
| `~/.icons/`                       | Tema ikon lokal         |
| `~/.themes/`                      | Tema GTK lokal          |
| `/usr/share/color/icc/`           | Profil warna ICC        |

---

## 🔍 Debugging & Monitoring

```bash
# Lihat tema GTK aktif
gsettings get org.gnome.desktop.interface gtk-theme

# Periksa font yang digunakan
fc-match sans

# Lihat environment variable Qt
echo $QT_QPA_PLATFORMTHEME
```

---

## 🔗 Referensi Resmi

* [GTK Documentation](https://docs.gtk.org/)
* [Qt Framework Docs](https://doc.qt.io/)
* [Fontconfig Reference](https://www.freedesktop.org/wiki/Software/fontconfig/)
* [Freetype Docs](https://freetype.org/documentation.html)
* [Cairo Graphics Library](https://www.cairographics.org/)
* [colord & ICC Profiles](https://www.freedesktop.org/software/colord/)
* [Arch Wiki – GTK, Qt, Fontconfig, Themes](https://wiki.archlinux.org/)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda akan mampu:

* Menyesuaikan tampilan tema GTK dan Qt agar seragam.
* Mengatur font rendering global untuk kenyamanan visual.
* Menerapkan skema warna pada terminal dan aplikasi GUI.
* Memahami bagaimana profil warna dan toolkit bekerja di bawah Wayland.

---

> 💡 *Catatan Developer:*
> Modul terakhir berikutnya (Modul 7) akan membawa Anda ke tahap **Packaging & Distribusi ISO**, tempat semua konfigurasi dan pengetahuan Anda digabungkan menjadi satu sistem yang dapat dibagikan — lengkap dengan build script, initramfs, dan uji QEMU.

---

Penutup dari seluruh kurikulum. Di sini, Anda akan mempelajari cara **menggabungkan seluruh komponen dan konfigurasi yang telah dibuat menjadi satu sistem utuh** — distribusi Linux yang dapat di-*boot*, diuji, dan dibagikan.

---

# 💽 Modul 7 — Packaging & Distribusi Sistem

> “Sebuah sistem disebut selesai bukan ketika tampilannya indah, tetapi ketika bisa dibangun, dijalankan, dan didistribusikan secara utuh.”

---

## 🎯 Tujuan Pembelajaran

1. Memahami proses pembuatan distribusi kustom (custom ISO) berbasis Arch Linux.  
2. Mengetahui struktur dan alat pembangun seperti **archiso**, **mkinitcpio**, dan **PKGBUILD**.  
3. Mampu membangun image ISO yang dapat diuji langsung dengan **QEMU**.  
4. Mampu membuat paket `.pkg.tar.zst` dari konfigurasi atau tool kustom Anda.  

---

## ⚙️ Komponen & Bahasa Implementasi

| Komponen | Bahasa Utama | Peran | Toolchain / Build System |
|-----------|---------------|--------|----------------------------|
| **archiso** | Bash | Membuat ISO Arch Linux kustom | bash, mkarchiso |
| **mkinitcpio** | Bash | Membuat initramfs (image boot) | bash |
| **PKGBUILD / makepkg** | Bash | Sistem build paket Arch | bash, fakeroot |
| **QEMU** | C | Emulator untuk uji ISO | meson, gcc |
| **pacstrap / pacman** | C | Instalasi paket dan manajemen repositori | meson |
| **GRUB / systemd-boot** | C | Bootloader | autotools |

---

## 🧩 Prasyarat Teknis

**Pengetahuan:**
- Struktur filesystem Linux (`/boot`, `/usr`, `/etc`, `/var`).  
- Konsep chroot dan initramfs.  
- Dasar pembuatan paket di Arch (`PKGBUILD`).  

**Paket minimal (Arch Linux):**
```bash
sudo pacman -S archiso qemu pacman-contrib git base-devel
````

---

## 🧪 Lab Praktis

### 🧠 Lab 1 — Membuat ISO Arch Kustom Minimal

1. Salin template `releng` Archiso:

```bash
cp -r /usr/share/archiso/configs/releng ~/archiso-custom
cd ~/archiso-custom
```

2. Sunting `packages.x86_64` untuk menambahkan:

```
sway
waybar
dunst
rofi
mako
alacritty
```

3. Tambahkan konfigurasi kustom Anda:

```
cp -r ~/.config/sway airootfs/etc/skel/.config/
cp -r ~/.config/waybar airootfs/etc/skel/.config/
```

4. Bangun ISO:

```bash
sudo mkarchiso -v .
```

5. Hasil ISO berada di:

```
out/archlinux-<tanggal>-x86_64.iso
```

---

### 💽 Lab 2 — Menguji ISO dengan QEMU

```bash
qemu-system-x86_64 \
  -cdrom out/archlinux-<tanggal>-x86_64.iso \
  -m 4096 \
  -enable-kvm \
  -boot d
```

**Hasil:**
Sistem Wayland-Sway kustom Anda dapat dijalankan langsung tanpa instalasi.

---

### 📦 Lab 3 — Membuat Paket PKGBUILD

1. Buat direktori proyek:

```bash
mkdir -p ~/pkgbuilds/my-tool
cd ~/pkgbuilds/my-tool
```

2. Buat file `PKGBUILD`:

```bash
pkgname=my-tool
pkgver=1.0
pkgrel=1
arch=('x86_64')
license=('MIT')
depends=('bash')
source=('my-tool.sh')
md5sums=('SKIP')

package() {
  install -Dm755 "$srcdir/my-tool.sh" "$pkgdir/usr/bin/my-tool"
}
```

3. Build paket:

```bash
makepkg -si
```

**Hasil:**
File `.pkg.tar.zst` dihasilkan dan dapat diinstal atau dibagikan.

---

## 🧭 Struktur Proyek ISO

```
archiso-custom/
├── airootfs/               # Root filesystem (konfigurasi pengguna)
│   ├── etc/
│   └── skel/.config/       # Dotfiles default
├── packages.x86_64         # Daftar paket yang disertakan
├── pacman.conf             # Konfigurasi repositori
├── profiledef.sh           # Parameter build (label, output, filesystem)
└── out/                    # Hasil ISO akhir
```

---

## 📂 File & Direktori Penting

| Path                          | Deskripsi                      |
| ----------------------------- | ------------------------------ |
| `/usr/share/archiso/configs/` | Template build ISO bawaan      |
| `~/archiso-custom/`           | Direktori build ISO Anda       |
| `/etc/mkinitcpio.conf`        | Modul initramfs                |
| `/var/cache/pacman/pkg/`      | Cache paket lokal              |
| `~/pkgbuilds/`                | Tempat proyek build paket Anda |
| `/usr/share/libalpm/`         | Library pacman backend         |

---

## 🔍 Debugging & Monitoring

```bash
# Cek log build ISO
cat work/log

# Validasi ISO
isoinfo -d -i out/*.iso

# Uji mount ISO
sudo mount -o loop out/*.iso /mnt

# Jalankan virtual machine QEMU dengan log
qemu-system-x86_64 -cdrom out/*.iso -m 4096 -serial stdio
```

---

## 🔗 Referensi Resmi

* [Archiso Git Repository](https://gitlab.archlinux.org/archlinux/archiso)
* [Arch Wiki – Archiso](https://wiki.archlinux.org/title/Archiso)
* [PKGBUILD Reference](https://wiki.archlinux.org/title/PKGBUILD)
* [makepkg Manpage](https://man.archlinux.org/man/makepkg.8.en)
* [QEMU Documentation](https://www.qemu.org/docs/master/)
* [mkinitcpio Reference](https://wiki.archlinux.org/title/Mkinitcpio)

---

## ✅ Outcome Pembelajaran

Setelah menyelesaikan modul ini, Anda akan mampu:

* Membangun ISO Arch Linux Wayland kustom dari nol.
* Membuat paket `.pkg.tar.zst` dari proyek pribadi.
* Menguji sistem melalui QEMU sebelum distribusi publik.
* Memahami struktur inti pembuatan sistem distribusi modern.

---

> 💡 *Catatan Penutup:*
> Dengan selesainya Modul 7, seluruh rantai pembelajaran — dari *kernel graphics stack* hingga distribusi utuh — telah lengkap.
> Anda kini memiliki pengetahuan penuh untuk membangun, mengelola, dan mendistribusikan **Desktop Environment kustom** berbasis Wayland yang mandiri dan profesional.

---

📘 Dengan demikian, seluruh materi telah selesai!

# Selamat!
