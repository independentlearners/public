- [Window-Manager](./window-manager/README.md)
- [Gnome](./gnome/README.md)
- [Kde-Plasma](./kde-plasma/README.md)
- [Xfce](./xfce/README.md)
<!--
Bagus — saya kumpulkan **seluruh konsep relevan** yang dibutuhkan untuk *membangun Desktop Environment (DE)* dengan fokus pada aspek **scripting / konfigurasi** (bukan pengembangan low-level terus-menerus). Hasilnya adalah daftar terstruktur dan lengkap plus **jumlah pastinya** di akhir.

Sebelum daftar: catatan singkat — definisi umum: sebuah desktop environment biasanya menggabungkan window manager, file manager, panel/taskbar, pengelola sesi, dan utilitas lain yang saling terintegrasi. ([Freedesktop][1])
Untuk hal yang khas modern (Wayland vs X11) peran display server/compositor digabung pada Wayland; protokol Wayland mendefinisikan komunikasi compositor ↔ klien. ([Wikipedia][2])

-->
# Daftar Konsep Desktop

Berikut **daftar konsep** (setiap item disertai keterangan singkat, dan bila relevan: implementasi/ bahasa umum & apa yang perlu dikuasai untuk melakukan *scripting / konfigurasi* pada konsep itu).
Desktop environment yang diambil disini adalah Window-Manager, sehingga untuk DE lainnya perlu menyesuaikan.
Penjelasan akan meliputi berikut:

1. **Identitas / bahasa implementasi utama** (apa yang biasanya teknologi itu ditulis/dibangun), dan
2. **Kemampuan & persiapan** yang harus dikuasai (terbagi menjadi: Dasar wajib, Rekomendasi lanjutan, File/alat yang biasa disentuh, dan Catatan kontribusi/eksplorasi lebih jauh).

---

## 1. **Display server / protocol (X11, Wayland)**

   * Fungsi: penanganan grafis dasar, komunikasi klien ↔ server.
   * Implementasi umum: Xorg (C), Wayland lib (C).
   * Scripting: mengerti variabel `DISPLAY`/`WAYLAND_DISPLAY`, xinit, startx. ([Wikipedia][2])
---
   * Dibangun dengan: C (Xorg), C (Wayland libraries).
   * Kemampuan yang harus dimiliki:

     * Dasar: konsep client–server grafis, variabel `DISPLAY`, dasar startx/xinit, memahami perbedaan X11 vs Wayland.
     * Rekomendasi: debugging log Xorg (`/var/log/Xorg.*`), WAYLAND_DISPLAY, penggunaan `WAYLAND_DISPLAY`/`XDG_RUNTIME_DIR`.
     * File/alat: `/etc/X11/*`, `startx`, `weston`, `wayland-protocols` docs.
     * Kontribusi: kebutuhan C dan pemahaman protokol Wayland untuk implementasi atau patch-level work.


## 2. **Compositor**

   * Fungsi: kompositing frame akhir (Wayland: compositor = display server).
   * Implementasi: wlroots (C), Weston (C), Sway (C), Hyprland (C++/C).
   * Scripting: `swaymsg`, file config compositor.
---
   * Dibangun dengan: C (wlroots-based), C/C++ (beberapa compositor).
   * Kemampuan:

     * Dasar: membaca file konfigurasi compositor (mis. `~/.config/sway/config`), `swaymsg`/CLI control.
     * Rekomendasi: memahami event loop, sw fallback, debugging segfault/trace.
     * File/alat: config sway/hyprland, sistem log (`journalctl -e`), `swaymsg`.
     * Kontribusi: kemampuan C untuk memperbaiki bug atau menambah fitur di wlroots/compositor.


## 3. **Window manager (tiling/stacking)**

   * Fungsi: aturan penempatan, fokus, ukuran jendela.
   * Implementasi: i3 (C), bspwm (C), qtile (Python).
   * Scripting: IPC (i3-msg/swaymsg) dan config file.
---
   * Dibangun dengan: C (i3), Python (qtile), C (bspwm uses bspwm daemon).
   * Kemampuan:

     * Dasar: IPC commands (i3-msg, swaymsg), aturan window class/instance, konfigurasi keybindings.
     * Rekomendasi: pembuatan skrip automasi untuk aturan window, debug layout.
     * File/alat: `~/.config/i3/config`, `~/.config/sway/config`.
     * Kontribusi: memahami bahasa implementasi untuk fitur baru.


## 4. **XWayland / X server compatibility layer**

   * Fungsi: menjalankan aplikasi X11 di Wayland.
   * Scripting: kondisi runtime, fallback handling.
---
   * Dibangun dengan: C.
   * Kemampuan:

     * Dasar: mengetahui kapan XWayland aktif, fallback behaviour untuk aplikasi X11.
     * Rekomendasi: troubleshooting aplikasi X11 di Wayland, setting `DISPLAY` vs `WAYLAND_DISPLAY`.
     * File/alat: `xwayland` binary, compositor logs.


## 5. **DRM / KMS & GPU driver (Mesa, proprietary)**

   * Fungsi: kernel modesetting, manajemen output.
   * Relevansi scripting: pemeriksaan `/sys`, `modprobe`, pengecekan driver.
---
   * Dibangun dengan: C, C++.
   * Kemampuan:

     * Dasar: memahami kernel modesetting (KMS), cara membaca `/sys/class/drm/`, `lsmod`/`modprobe`.
     * Rekomendasi: debugging driver, mengatur firmware, fallback modes.
     * File/alat: `dmesg`, `/var/log/kern.log`, `modinfo`, `lspci`, `mesa` utilities.
     * Kontribusi: C/C++ untuk driver-level bukan tugas ringan.


## 6. **Input stack (libinput, evdev) & XKB**

   * Fungsi: input devices, layout keyboard.
   * Scripting: konfigurasi `xkb`, `setxkbmap`, `sway` input blocks.
---
   * Dibangun dengan: C.
   * Kemampuan:

     * Dasar: konfigurasi input di compositor, `setxkbmap`, layout keyboard, understanding `xkb` rules.
     * Rekomendasi: custom XKB keymap, remapping scancodes.
     * File/alat: `libinput-list-devices`, `udev` rules, `localectl`, XKB source.


## 7. **Output / monitor management (xrandr, wlr-output-management)**

   * Fungsi: resolusi, orientasi, multi-monitor.
   * Scripting: `xrandr` atau protokol wlr/Compositor.
---
   * Dibangun dengan: C (tools).
   * Kemampuan:

     * Dasar: memasang resolusi, orientasi layar, mode perekaman monitor, `xrandr` command.
     * Rekomendasi: scripting multi-monitor setup, menggunakan compositor protocol untuk Wayland.
     * File/alat: `xrandr`, `swaymsg output`, `wlr-randr` (alat terkait).


## 8. **Session manager / login manager (display manager / systemd-logind)**

   * Fungsi: inisialisasi sesi pengguna, seat management.
   * Scripting: unit systemd user, pengaturan autostart.
--
   * Dibangun dengan: C (GDM), systemd (C).
   * Kemampuan:

     * Dasar: unit session di systemd, seat management, autologin config.
     * Rekomendasi: menulis user systemd units, integrasi dengan PAM.
     * File/alat: `/etc/systemd/system/`, `loginctl`, config DM (gdm/lightdm/sddm).


## 9. **Autostart (XDG Autostart spec)**

   * Fungsi: mekanisme memulai aplikasi saat login.
   * Format: `.desktop` di `~/.config/autostart`. ([Spesifikasi Freedesktop.org][3])
---
   * Dibangun dengan: plain text `.desktop` (spec oleh freedesktop).
   * Kemampuan:

     * Dasar: menulis `.desktop` di `~/.config/autostart`, memahami key `OnlyShowIn`, `X-GNOME-Autostart-enabled`.
     * Rekomendasi: debugging order startup, hooks systemd user.
     * File/alat: `~/.config/autostart/*.desktop`.

## 10. **Desktop Entry (`.desktop`) (XDG Desktop Entry spec)**

   * Fungsi: mendeskripsikan cara meluncurkan aplikasi, ikon, kategori.
   * Scripting: membuat/menulis file `.desktop`, kunci Exec, TryExec. ([Spesifikasi Freedesktop.org][4])
---
   * Dibangun dengan: file teks (format INI).
   * Kemampuan:

      * Dasar: sintaks `.desktop`, keys `Exec`, `TryExec`, `MimeType`.
      * Rekomendasi: membuat launcher dinamis via skrip.
      * File/alat: `~/.local/share/applications`, `desktop-file-validate`.


## 11. **XDG Base Directory & XDG_RUNTIME_DIR**

   * Fungsi: lokasi config, cache, runtime.
   * Scripting: menaruh file config pada path yang benar.
---
   * Dibangun dengan: spesifikasi (konsep lingkungan).
   * Kemampuan:

      * Dasar: memahami variabel `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_RUNTIME_DIR`.
      * Rekomendasi: struktur folder dotfiles yang portable.
      * File/alat: environment checks di shell / systemd.



## 12. **Environment variables (XDG_*, WAYLAND_DISPLAY, DISPLAY, PATH, LANG)**

   * Fungsi: pewarisan variabel ke proses GUI.
   * Scripting: `export` dan memahami scope.
---
   * Dibangun dengan: kernel/execve inheritance (C).
   * Kemampuan:

      * Dasar: `export`, inheritance ke child processes, menempatkan variabel di file yang tepat (`.profile`, `.xsessionrc`).
      * Rekomendasi: debugging env via `env`/`printenv`.
      * File/alat: `~/.profile`, `~/.bash_profile`, `~/.config/environment.d/`.
      * penggunaan `/etc/environment.d/` dan modul `pam_env untuk` variabel lingkungan di seluruh sesi


## 13. **IPC & Messaging (D-Bus)**

   * Fungsi: komunikasi antar proses/service (setting, power, network).
   * Tools: `gdbus`, `busctl`, `dbus-send`. ([Freedesktop][5])
---
   * Dibangun dengan: C (libdbus), GLib bindings (various languages).
   * Kemampuan:

      * Dasar: konsep bus system/session, basic `dbus-send`/`gdbus`/`busctl`.
      * Rekomendasi: menulis service sederhana, subscribe signals, introspection.
      * File/alat: `gdbus`, `busctl`, `d-feet` (GUI introspection).


## 14. **Wayland protocols & extensions (xdg-shell, xdg-decoration, linux-dmabuf, etc.)**

   * Fungsi: set protokol untuk surface, decoration, buffer sharing.
   * Scripting: memantau capability compositor, menggunakan API/CLI yang disediakan. (Referensi protokol: daftar resmi). ([Absurdly Suspicious][6])
---
   * Dibangun dengan: protokol Wayland (C) dan XML-protocol specs.
   * Kemampuan:

      * Dasar: membaca capability compositor, mengenali protokol yang diperlukan aplikasi (screencast, gamma, etc.).
      * Rekomendasi: menggunakan `wayland-protocols`, memahami negotiation between client & compositor.
      * File/alat: `wayland-protocols` repository/docs.

## 15. **Toolkit & Theme engines (GTK, Qt)**

   * Implementasi: GTK (C), Qt (C++).
   * Scripting/config: theme CSS (GTK), Qt styles, environment vars seperti `GTK_THEME`.
---
   * Dibangun dengan: C (GTK), C++ (Qt).
   * Kemampuan:

      * Dasar: menerapkan tema, environment variables (`GTK_THEME`), mengerti CSS GTK.
      * Rekomendasi: debugging theming mismatch, building toolkit apps.
      * File/alat: `gsettings`, `qt5ct`, `gtk-update-icon-cache`.


## 16. **Icon & cursor theme (Icon Theme spec)**

   * Fungsi: pengaturan ikon aplikasi dan pointer.
   * Scripting: memperbarui `~/.icons` atau `adwaita` dsb.
---
   * Dibangun dengan: spesifikasi (gambar, theme dirs).
   * Kemampuan:

      * Dasar: lokasi dan struktur tema (`/usr/share/icons`, `~/.icons`).
      * Rekomendasi: membuat paket tema, menjalankan `update-alternatives` atau cache update.
      * File/alat: `gtk-update-icon-cache`.


## 17. **Settings/config daemon (dconf/gsettings, kconfig)**

   * Fungsi: penyimpanan preferensi global.
   * Scripting: `gsettings`, `dconf` CLI.
---
   * Dibangun dengan: C (gsettings uses GObject), kconfig (Qt).
   * Kemampuan:

      * Dasar: `gsettings` CLI, memodifikasi `dconf` database.
      * Rekomendasi: scripting preferences, backup/restore schema.
      * File/alat: `dconf-editor`, `gsettings`.


## 18. **Panel / Taskbar / Dock / Status bar**

   * Fungsi: menampilkan jendela terbuka, quicktiles, tray.
   * Scripting: konfigurasi waybar/polybar/lemonbar, membuat modul shell.
---
   * Dibangun dengan: bermacam (C, Python, JS) bergantung implementasi.
   * Kemampuan:

      * Dasar: membuat modul status bar (output JSON untuk i3bar), integrasi tray.
      * Rekomendasi: menulis modul shell/py yang efisien, memanfaatkan IPC.
      * File/alat: `waybar`/`polybar` config, JSON output patterns.


## 19. **Notification daemon (libnotify)**

   * Fungsi: menampilkan notifikasi.
   * Scripting: `notify-send` dan handling action buttons.
---
   * Dibangun dengan: C (libnotify) dan daemon-level implementasi.
   * Kemampuan:

      * Dasar: `notify-send` penggunaan, memahami action buttons dan timeout.
      * Rekomendasi: intercept/format notifikasi, memfilter noise.
      * File/alat: `dunst`/`mako` config (daemon populer).


## 20. **Clipboard manager**

   * Fungsi: menyimpan clipboard history (xclip, wl-clipboard).
   * Scripting: integrasi dengan panel/status.
---
   * Dibangun dengan: bermacam (C, Rust) untuk tools.
   * Kemampuan:

      * Dasar: alat clipboard (xclip, wl-clipboard), cara memantau selection.
      * Rekomendasi: scripting integrasi dengan status bar dan hotkeys.
      * File/alat: `wl-clipboard`, `xclip`, `clipman` tools.



## 21. **Application launcher & menu (XDG Menu spec)**

   * Fungsi: membangun menu aplikasi dari `.desktop`.
   * Scripting: regenerate menu, indexing.
---
   * Dibangun dengan: spesifikasi `.desktop` aggregation (freedesktop).
   * Kemampuan:

      * Dasar: membangun menu dari `.desktop`, generate menu cache (`update-desktop-database`).
      * Rekomendasi: custom launcher scripting (rofi, dmenu).
      * File/alat: `rofi`, `dmenu`, `alacarte` utils.


## 22. **File manager integration & MIME types**

   * Fungsi: handling file associations (XDG MIME).
   * Scripting: `xdg-mime`, `xdg-open` behaviour.
---
   * Dibangun dengan: freedesktop MIME specs (file associations).
   * Kemampuan:

      * Dasar: `xdg-mime`, `xdg-open` behavior, `mimeapps.list`.
      * Rekomendasi: membuat custom handlers, debugging associations.
      * File/alat: `~/.config/mimeapps.list`, `/usr/share/mime`.


## 23. **Power management (UPower, systemd inhibitors)**

   * Fungsi: sleep, suspend, battery status.
   * Scripting: hooking via D-Bus atau `loginctl`, `upower` CLI.
---
   * Dibangun dengan: C (UPower), systemd (C).
   * Kemampuan:

      * Dasar: monitoring battery via UPower/`upower -i`, hooking via D-Bus for events.
      * Rekomendasi: menulis inhibitors (prevent-suspend), integrate with UI.
      * File/alat: `upower`, `systemd-inhibit`, DBus power signals.


## 24. **Network management (NetworkManager, nmcli)**

   * Fungsi: konektivitas, VPN.
   * Scripting: `nmcli`, dbus signals.
---
   * Dibangun dengan: C (NetworkManager).
   * Kemampuan:

      * Dasar: `nmcli` dasar, connection profiles, autoconnect.
      * Rekomendasi: scripting VPN connection, handling signals via DBus.
      * File/alat: `nmcli`, `nmtui`, `NetworkManager` configs.


## 25. **Audio & multimedia (PulseAudio, PipeWire, ALSA)**

   * Fungsi: routing audio, screencast support (PipeWire).
   * Scripting: `pactl`, `pw-cli`, control volume/status.
---
   * Dibangun dengan: C (PulseAudio), C (PipeWire core).
   * Kemampuan:

      * Dasar: `pactl`/`pw-cli` untuk volume/route control, understanding sinks/sources.
      * Rekomendasi: setting per-app routing, screencast via PipeWire.
      * File/alat: `pactl`, `pw-cli`, `pavucontrol`, `pipewire` configs.


## 26. **Screen locking & screensaver / DPMS**

   * Fungsi: kunci layar, blanking.
   * Scripting: `swaylock`, `xss-lock`, `xset dpms`.
---
   * Dibangun dengan: tools (C, Rust).
   * Kemampuan:

      * Dasar: `swaylock`, `xss-lock`, `xset dpms`.
      * Rekomendasi: integrating lock on suspend, pam/systemd hooks.
      * File/alat: lock config, compositor autostart.


## 27. **Screen capture & screencast (PipeWire-based)**

   * Fungsi: screenshot, recording.
   * Scripting: `grim`/`wf-recorder`/`obs` integration.
---
   * Dibangun dengan: PipeWire (C) + client tools.
   * Kemampuan:

      * Dasar: `grim`, `wf-recorder`, `obs` konfigurasi, PipeWire portals.
      * Rekomendasi: scripting record start/stop, handle Wayland portal permissions.
      * File/alat: `wf-recorder`, `grim`, `obs`, `xdg-desktop-portal`.


## 28. **Printing (CUPS)**

   * Fungsi: driver & queue.
   * Scripting: `lpstat`, `lpadmin`.
---
   * Dibangun dengan: C (CUPS).
   * Kemampuan:

      * Dasar: `lpstat`, `lpadmin`, menambahkan printer.
      * Rekomendasi: debugging drivers, PPD files, permissions.
      * File/alat: `cups` web UI, `/etc/cups/`.


## 29. **Accessibility stack (AT-SPI)**

   * Fungsi: screen readers, accessibility events.
   * Scripting: menjamin hook untuk alat assistive.
---
   * Dibangun dengan: C, GLib, various toolkit bindings.
   * Kemampuan:

      * Dasar: prinsip AT-SPI, memastikan apps expose accessibility interfaces.
      * Rekomendasi: testing screen reader integration, a11y audit.
      * File/alat: `orca` (screen reader), AT-SPI debug tools.

## 30. **Input Method Frameworks (IBus, Fcitx)**

   * Fungsi: IME untuk bahasa non-Latin.
   * Scripting: environment, pam/systemd hooks, startup.
---
   * Dibangun dengan: C/C++ (core), Python bindings.
   * Kemampuan:

      * Dasar: setup IME, autostart per-session, environment (`GTK_IM_MODULE`, `QT_IM_MODULE`).
      * Rekomendasi: custom engine config, switching rules for locales.
      * File/alat: `ibus`, `fcitx`, config files.


## 31. **Authentication/session (PAM, systemd user)**

   * Fungsi: login, session lifecycle.
   * Scripting: systemd user units, `loginctl`.
---
   * Dibangun dengan: C (PAM), systemd (C).
   * Kemampuan:

      * Dasar: memahami PAM stack, user session lifecycle, `systemd --user`.
      * Rekomendasi: menulis systemd user service untuk autostart, pam modules config.
      * File/alat: `/etc/pam.d/*`, `loginctl`.
      * penggunaan `/etc/environment.d/` dan modul `pam_env untuk` variabel lingkungan di seluruh sesi

## 32. **Polkit (PolicyKit) Authentication Agent**

   * Fungsi: Menangani otorisasi untuk tindakan yang memerlukan hak istimewa (mis. `udisksctl`, `systemd-inhibit`, manajemen daya, partisi) dari dalam sesi pengguna non-root.
   * Implementasi: Daemon Polkit (C), Agen (mis. `polkit-gnome` (C), `lxqt-policykit` (C++)).
   * Scripting: Memastikan agen Polkit berjalan via XDG Autostart, menulis aturan kustom (`.rules`) di `/etc/polkit-1/rules.d/`.
---
   * Dibangun dengan: C (Core daemon), C/C++/Varies (Agents).
   * Kemampuan yang harus dimiliki:

     * Dasar: Memahami mengapa proses gagal tanpa agen, memastikan satu agen (mis. `/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1`) dieksekusi saat login via file `.desktop` di `~/.config/autostart`.
     * Rekomendasi: Menulis aturan kustom (berbasis JavaScript) untuk memberikan izin tanpa kata sandi pada tindakan spesifik (mis. me-mount disk), debugging kegagalan izin via `journalctl`.
     * File/alat: `pkttyagent`, `pkaction`, `polkit-gnome-authentication-agent-1`, `/etc/polkit-1/rules.d/`, `journalctl -u polkit.service`.
     * Kontribusi: Pemahaman C (daemon) atau bahasa agen (C/C++) dan D-Bus (IPC).

---

## 33. **Systemd user units & service integration**

   * Fungsi: background services run per-user.
   * Scripting: membuat unit `~/.config/systemd/user/`.
---
   * Dibangun dengan: systemd (C), unit file syntax.
   * Kemampuan:

      * Dasar: membuat `~/.config/systemd/user/*.service`, enabling/disabling services, `systemctl --user`.
      * Rekomendasi: timer units, socket activation, transient units.
      * File/alat: `systemctl --user`, `journalctl --user`.


## 34. **Window decoration model (client-side vs server-side decorations)**

   * Fungsi: siapa yang menggambar titlebar/border.
   * Scripting: konfigurasi compositor/toolkit interaction (`xdg-decoration`).
---
   * Dibangun dengan: protokol Wayland / toolkit interactions.
   * Kemampuan:

      * Dasar: perbedaan CSD vs SSD, cara mengubah perilaku dekorasi di compositor/toolkit.
      * Rekomendasi: menyesuaikan theme atau patching client toolkit jika perlu.
      * File/alat: `xdg-decoration` protocol docs.


## 35. **Global hotkeys & shortcut handling**

   * Fungsi: binding shortcut ke aksi.
   * Scripting: file konfigurasi compositor, xbindkeys, sxhkd.
---
   * Dibangun dengan: komponen compositor (C), tools (sxhkd in C).
   * Kemampuan:

      * Dasar: konfigurasi keybind di compositor, penggunaan `swaygrab`/`swaymsg`.
      * Rekomendasi: mapping multi-key sequences, composing key-chords.
      * File/alat: compositor config, `sxhkd`, `xbindkeys`.


## 36. **Scripting utilities / CLIs (swaymsg, i3-msg, xdotool, wmctrl)**

   * Fungsi: kontrol runtime via command line.
   * Scripting: membuat wrapper functions dan hooks.
---
   * Dibangun dengan: C/C++.
   * Kemampuan:

      * Dasar: penggunaan CLI untuk mengendalikan WM/compositor, scripting wrappers.
      * Rekomendasi: membuat pustaka wrapper (bash/python) untuk operasi berulang.
      * File/alat: binaries terkait, man pages.



## 37. **Status bar protocols & JSON blocks (i3bar/protocol)**

   * Fungsi: format data untuk status bars.
   * Scripting: output JSON, modular scripts.
---

   * Dibangun dengan: spesifikasi sederhana (JSON streaming).
   * Kemampuan:

      * Dasar: keluaran JSON yang valid untuk status bar, streaming header/heartbeat.
      * Rekomendasi: membuat modul efisien yang update minimal, buffering output.
      * File/alat: contoh `i3status`, `i3bar` protocol.


## 38. **Filesystem mounts & udisks/gvfs integration**

   * Fungsi: automount, file browsing.
   * Scripting: `udisksctl`, `gio mount`.
---
   * Dibangun dengan: C, GLib bindings.
   * Kemampuan:

      * Dasar: `udisksctl` untuk automount, `gio mount`, mount options.
      * Rekomendasi: menulis udev/udisks rules untuk automount custom.
      * File/alat: `udisksctl`, `gio`, `/etc/fstab` knowledge.


## 39. **udev & device event handling**

   * Fungsi: deteksi perangkat baru (USB, audio devices).
   * Scripting: writing udev rules, `udevadm monitor`.
---
   * Dibangun dengan: C (udev).
   * Kemampuan:

      * Dasar: menulis udev rules, `udevadm monitor`, understanding device properties.
      * Rekomendasi: write rules for persistent naming, run scripts on device add/remove.
      * File/alat: `/etc/udev/rules.d/`, `udevadm`.


## 40. **Sandboxing & application portals (Flatpak, Snap, XDG Portals)**

   * Fungsi: izin aplikasi ter-sandbox, portal untuk screencast, file pickers.
   * Scripting: memahami portal behaviour.
---
   * Dibangun dengan: C, various languages (portals implemented in C).
   * Kemampuan:

      * Dasar: prinsip sandboxing, XDG portals usage for screencast/file chooser.
      * Rekomendasi: configure portal policies, integrate portal requests in UI.
      * File/alat: `xdg-desktop-portal`, flatpak/snap tooling.
      * `xdg-desktop-portal-wlr` (untuk Sway/wlroots) atau `xdg-desktop-portal-gtk` (sebagai fallback).

## 41. **Security model (Wayland security, seccomp, namespaces)**

   * Fungsi: pembatasan akses antara aplikasi dan sistem.
   * Scripting: memeriksa capability, menggunakan portals.
---
   * Dibangun dengan: kernel features (C), seccomp filters (C).
   * Kemampuan:

      * Dasar: concept of least privilege, how Wayland isolates clients.
      * Rekomendasi: apply seccomp filters, namespace isolation for apps.
      * File/alat: apparmor/selinux basics (if used), seccomp tooling.


## 42. **Logging & diagnostics (journalctl, Xorg logs, compositor logs)**

   * Fungsi: debugging isu DE.
   * Scripting: log rotation, pattern checks.
---
   * Dibangun dengan: systemd-journald (C), logging systems.
   * Kemampuan:

      * Dasar: `journalctl`, reading compositor/Xorg logs, grep/awk for pattern.
      * Rekomendasi: membuat automated diagnostics script untuk pengguna.
      * File/alat: `journalctl`, `/var/log`.


## 43. **Localization & input locales (locale, ICU)**

   * Fungsi: bahasa & format lokal.
   * Scripting: set `LANG`, `LC_*`, keyboard layout switches.
---
   * Dibangun dengan: glibc locale data, ICU libraries (C/C++).
   * Kemampuan:

      * Dasar: set `LANG`, `LC_*`, regenerate locales (`locale-gen`).
      * Rekomendasi: manage input method per-locale, transliteration rules.
      * File/alat: `/etc/locale.conf`, `localectl`.


## 44. **Font configuration & rendering (fontconfig, freetype)**

   * Fungsi: font discovery & rendering.
   * Scripting: `fc-cache`, `fc-match`.
---
   * Dibangun dengan: C (fontconfig, freetype).
   * Kemampuan:

      * Dasar: `fc-cache`, `fc-match`, mengetahui konflik font dan fallback.
      * Rekomendasi: tuning hinting/antialiasing, bundling fonts in distro image.
      * File/alat: `/etc/fonts/`, `fontconfig` config files.


## 45. **Color management & gamma (colord, xcalib)**

   * Fungsi: profil kolor untuk monitor.
   * Scripting: apply ICC profiles.
---
   * Dibangun dengan: C (colord).
   * Kemampuan:

      * Dasar: apply ICC profiles, adjust gamma via `xcalib`/compositor.
      * Rekomendasi: integrate color profiles per monitor, scripting for profile switching.
      * File/alat: `colord`, `displaycal` workflows.


## 46. **Window rules, focus behaviour, floating vs tiling rules**

   * Fungsi: aturan per aplikasi/window class.
   * Scripting: compositor/window-manager rules.
---
   * Dibangun dengan: fitur WM/compositor (C).
   * Kemampuan:

      * Dasar: aturan berdasarkan `class`, `instance`, `title`, config syntax untuk rules.
      * Rekomendasi: menulis rule sets yang deterministic, debug behavior across apps.
      * File/alat: window manager config.


## 47. **Compositor extension & protocol negotiation (xdg-output, xdg-activation, idle inhibit)**

   * Fungsi: sinkronisasi output metadata & activation.
   * Scripting: respond to protocol capabilities.
---
   * Dibangun dengan: Wayland protocol extensions (XML/C).
   * Kemampuan:

      * Dasar: mengerti capability negotiation, implement client behavior sesuai protokol.
      * Rekomendasi: memeriksa feature flags pada compositor dan fallback.
      * File/alat: `wayland-protocols` docs.


## 48. **Remote desktop, VNC, RDP, Wayland remote (wayvnc, x11vnc)**

   * Fungsi: remote control / screen sharing.
   * Scripting: start/stop services, portal integration.
---
   * Dibangun dengan: C/C++ (various).
   * Kemampuan:

      * Dasar: start/stop remote services, secure tunneling (SSH), authentication.
      * Rekomendasi: automasi start/stop via systemd user services, handle Wayland-specific limitations.
      * File/alat: `wayvnc`, `x11vnc`, `xrdp`.


## 49. **Packaging & distribution of config (dotfiles layout, portable config)**

   * Fungsi: standar menyimpan/menyebar config.
   * Scripting: install scripts, `stow`, git hooks.
---
   * Dibangun dengan: plain text scripts, git-based workflows.
   * Kemampuan:

      * Dasar: menggunakan `git` untuk dotfiles, stow/management tools, reproducible config layouts.
      * Rekomendasi: membuat installer script yang idempotent, testing across systems.
      * File/alat: `stow`, `chezmoi`, `git`, CI pipelines for dotfiles.



---

### 🗺️ Peta Jalan Kurikulum: 49 Konsep Desktop

Berikut adalah 49 konsep yang ada di dalam file Anda, yang kini diatur ulang ke dalam 7 modul pembelajaran.

---

### [🏛️ Modul 1: Landasan Grafis & Render (9 Konsep)][a]

**(1) Display server / protocol (X11, Wayland)**

  * **Sumber:**
      * `[Resmi - Wayland]` [Dokumentasi Protokol Wayland](https://wayland.freedesktop.org/docs/html/ch04.html) — Penjelasan teknis resmi mengenai model operasi dan protokol Wayland.
      * `[Resmi - X.Org]` [Fondasi X.Org](https://www.x.org/wiki/) — Portal utama untuk dokumentasi dan rilis X Window System.
      * `[Rekomendasi]` [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland) — Panduan komprehensif Arch Wiki, mencakup instalasi, compositor, dan pemecahan masalah.
      * `[Rekomendasi]` [Arch Wiki: Xorg](https://wiki.archlinux.org/title/Xorg) — Panduan Arch Wiki untuk server Xorg, instalasi, dan konfigurasi.

**(2) Compositor**

  * **Sumber:**
      * `[Resmi - wlroots]` [Dokumentasi wlroots](https://wlroots.pages.freedesktop.org/wlroots/) — Pustaka utama yang digunakan oleh compositor modern seperti Sway dan Hyprland (disebutkan di). Sangat teknis.
      * `[Rekomendasi]` [Arch Wiki: Wayland Compositors](https://www.google.com/search?q=https://wiki.archlinux.org/title/Wayland%23Compositors) — Daftar dan perbandingan compositor Wayland yang tersedia.

**(3) Window manager (tiling/stacking)**

  * **Sumber:**
      * `[Rekomendasi]` [Arch Wiki: Window Manager](https://wiki.archlinux.org/title/Window_manager) — Penjelasan bagus tentang konsep window manager, termasuk perbedaan Tiling vs. Stacking.
      * `[Rekomendasi]` [Arch Wiki: Tiling Window Managers](https://wiki.archlinux.org/title/Comparison_of_tiling_window_managers) — Perbandingan mendalam berbagai Tiling WM yang populer.

**(5) DRM / KMS & GPU driver (Mesa, proprietary)**

  * **Sumber:**
      * `[Resmi - Kernel]` [Dokumentasi DRM/KMS Kernel Linux](https://docs.kernel.org/gpu/drm-kms.html) — Dokumentasi resmi dari kernel Linux mengenai arsitektur Direct Rendering Manager (DRM) dan Kernel Mode Setting (KMS).
      * `[Resmi - Mesa]` [Dokumentasi Mesa 3D](https://docs.mesa3d.org/) — Dokumentasi resmi untuk Mesa, implementasi open-source dari OpenGL, Vulkan, dan API grafis lainnya. (Disebutkan di)
      * `[Rekomendasi]` [Arch Wiki: KMS](https://wiki.archlinux.org/title/Kernel_mode_setting) — Panduan cara kerja KMS dan cara mengaktifkannya.
      * `[Rekomendasi]` [Arch Wiki: Graphics Drivers](https://www.google.com/search?q=https://wiki.archlinux.org/title/Graphics_driver) — Halaman portal untuk memilih dan menginstal driver yang tepat di Arch.

**(7) Output / monitor management (xrandr, wlr-output-management)**

  * **Sumber:**
      * `[Resmi - Xrandr]` [Manual Page `xrandr(1)`](https://www.google.com/search?q=%5Bhttps://man.archlinux.org/man/xrandr.1%5D\(https://man.archlinux.org/man/xrandr.1\)) — Dokumentasi CLI resmi untuk utilitas `xrandr`.
      * `[Resmi - wlr-randr]` [Manual Page `wlr-randr(1)`](https://www.google.com/search?q=%5Bhttps://man.archlinux.org/man/extra/wlr-randr/wlr-randr.1.en%5D\(https://man.archlinux.org/man/extra/wlr-randr/wlr-randr.1.en\)) — Dokumentasi CLI resmi untuk utilitas `wlr-randr` (untuk compositor berbasis wlroots).
      * `[Rekomendasi]` [Arch Wiki: Xrandr](https://wiki.archlinux.org/title/Xrandr) — Panduan praktis dengan banyak contoh penggunaan `xrandr`.

**(4) XWayland / X server compatibility layer**

  * **Sumber:**
      * `[Resmi]` [Dokumentasi XWayland (Freedesktop)](https://www.google.com/search?q=https://wayland.freedesktop.org/xserver.html) — Halaman resmi yang menjelaskan arsitektur XWayland.
      * `[Rekomendasi]` [Arch Wiki: XWayland](https://www.google.com/search?q=https://wiki.archlinux.org/title/Wayland%23XWayland) — Bagian di Arch Wiki Wayland yang menjelaskan cara kerja dan konfigurasinya.

**(14) Wayland protocols & extensions (xdg-shell, xdg-decoration, linux-dmabuf, etc.)**

  * **Sumber:**
      * `[Resmi]` [Wayland Protocols (Freedesktop)](https://wayland.freedesktop.org/docs/html/ch04.html) — Dokumentasi inti protokol.
      * `[Resmi]` [Wayland Protocols Git Repository](https://gitlab.freedesktop.org/wayland/wayland-protocols) — Tempat protokol "stabil" dan "tidak stabil" dikembangkan.
      * `[Rekomendasi]` [Wayland Explorer](https://wayland.app/) — Alat yang sangat direkomendasikan untuk menjelajahi protokol (seperti `xdg-shell`, `xdg-decoration`, dll.) dan melihat dukungannya di berbagai compositor.

**(34) Window decoration model (client-side vs server-side decorations)**

  * **Sumber:**
      * `[Resmi - Protokol]` [Protokol `xdg-decoration`](https://www.google.com/search?q=%5Bhttps://wayland.app/protocols/xdg-decoration-unstable-v1%5D\(https://wayland.app/protocols/xdg-decoration-unstable-v1\)) — Protokol ekstensi yang dinegosiasikan oleh klien dan server untuk menentukan siapa yang menggambar dekorasi.
      * `[Rekomendasi - Penjelasan]` [Blog Nate Graham: Window Decorations Revisited](https://pointieststick.com/2021/05/15/window-decorations-revisited-or-using-the-right-tool-for-the-job/) — Artikel blog teknis yang menjelaskan perbedaan dan pro/kontra CSD vs SSD.
      * `[Rekomendasi - Tutorial]` [Tutorial `xdg-shell`](https://www.google.com/search?q=%5Bhttps://bugaevc.gitbooks.io/writing-wayland-clients/content/beyond-the-black-square/xdg-shell.html%5D\(https://bugaevc.gitbooks.io/writing-wayland-clients/content/beyond-the-black-square/xdg-shell.html\)) — Menjelaskan CSD dalam konteks `xdg-shell` saat menulis klien Wayland.

**(47) Compositor extension & protocol negotiation (xdg-output, xdg-activation, idle inhibit)**

  * **Sumber:**
      * `[Resmi - xdg-output]` [Protokol `xdg-output`](https://www.google.com/search?q=%5Bhttps://wayland.app/protocols/xdg-output-unstable-v1%5D\(https://wayland.app/protocols/xdg-output-unstable-v1\)) — Protokol untuk deskripsi output yang lebih mendetail (posisi logis, ukuran, dll.).
      * `[Resmi - xdg-activation]` [Protokol `xdg-activation`](https://www.google.com/search?q=%5Bhttps://wayland.app/protocols/xdg-activation-v1%5D\(https://wayland.app/protocols/xdg-activation-v1\)) — Protokol untuk mengelola aktivasi permukaan (misalnya, memindahkan fokus).
      * `[Resmi - idle-inhibit]` [Protokol `idle-inhibit`](https://www.google.com/search?q=%5Bhttps://wayland.app/protocols/idle-inhibit-unstable-v1%5D\(https://wayland.app/protocols/idle-inhibit-unstable-v1\)) — Protokol untuk mencegah compositor menjadi idle (misalnya, saat menonton video).
      * `[Rekomendasi]` [Wayland Explorer](https://wayland.app/) — Lagi, ini adalah alat terbaik untuk menjelajahi semua protokol ekstensi ini.

### ⌨️ Modul 2: Landasan Input Pengguna (3 Konsep)

**(6) Input stack (libinput, evdev) & XKB**

  * **Terminologi:**
      * **Input Stack:** Rangkaian lapisan perangkat lunak yang memproses sinyal fisik (penekanan tombol, gerakan mouse) menjadi peristiwa (event) yang dapat digunakan oleh aplikasi.
      * **libinput (C):** Pustaka (library) standar di Linux modern yang menyediakan input *event* yang terpadu dan menangani *device-quirks* (kekhususan perangkat) untuk Wayland Compositor atau Xorg (melalui driver `xf86-input-libinput`).
      * **evdev (Event Device):** Lapisan kernel Linux tingkat rendah yang menyediakan antarmuka perangkat keras input.
      * **XKB (X Keyboard Extension):** Ekstensi standar di X11 dan digunakan ulang di Wayland (`libxkbcommon`) untuk mendefinisikan *keyboard layout* (tata letak), *keymap*, dan *modifier* secara terperinci.
  * **Sumber:**
      * `[Resmi - libinput]` [What is libinput? - Freedesktop.org](https://wayland.freedesktop.org/libinput/doc/latest/what-is-libinput.html) — Dokumentasi resmi tentang tujuan dan arsitektur `libinput`.
      * `[Resmi - XKB]` [XKB Configuration Guide - X.Org](https://www.x.org/archive/X11R7.5/doc/input/XKB-Config.html) — Panduan konfigurasi XKB yang mendalam.
      * `[Rekomendasi]` [Arch Wiki: libinput](https://wiki.archlinux.org/title/Libinput) — Panduan untuk menginstal, mengkonfigurasi, dan memecahkan masalah `libinput` di Arch Linux.

**(30) Input Method Frameworks (IBus, Fcitx)**

  * **Terminologi:**
      * **IMF (Input Method Frameworks):** Kerangka kerja yang memungkinkan pengguna untuk memasukkan karakter yang tidak dapat diakses langsung pada keyboard (misalnya, bahasa Asia Timur, emoji).
      * **IBus (Intelligent Input Bus) (Python/C):** Kerangka kerja IMF standar di lingkungan GTK (GNOME).
      * **Fcitx (Free Chinese Input Tool for X, sekarang Fcitx5) (C++):** Kerangka kerja IMF yang fleksibel, populer di kalangan pengguna Tiling Window Manager dan KDE.
  * **Sumber:**
      * `[Rekomendasi - Komparasi]` [Arch Wiki: Input method](https://wiki.archlinux.org/title/Input_method) — Halaman komparasi penting yang menunjukkan ketersediaan IME (Input Method Editor) di berbagai framework.
      * `[Rekomendasi - Fcitx5]` [Arch Wiki: Fcitx5](https://wiki.archlinux.org/title/Fcitx5) — Panduan konfigurasi, terutama mencakup dukungan Wayland (`text-input` protocol) dan XIM.
      * `[Resmi - Fcitx]` [Fcitx Developer Handbook](http://fcitx.github.io/developer-handbook/fcitx-dev.html) — Sumber teknis tentang arsitektur Fcitx.

**(35) Global hotkeys & shortcut handling**

  * **Terminologi:**
      * **Global Hotkeys:** Kombinasi tombol yang selalu didengarkan oleh suatu daemon (program latar belakang) dan memicu perintah, terlepas dari jendela mana yang sedang fokus.
      * **xbindkeys (X11) (C):** Daemon *hotkey* sederhana untuk X11.
      * **sxhkd (X11) (C):** Daemon *hotkey* yang sangat populer karena sintaksnya yang ringkas dan didukung oleh bspwm.
      * **swhkd (Wayland) (Rust):** Kloning `sxhkd` untuk Wayland.
  * **Sumber:**
      * `[Resmi - sxhkd]` [sxhkd GitHub Repository](https://github.com/baskerville/sxhkd) — Repositori resmi oleh pengembang bspwm.
      * `[Resmi - swhkd]` [swhkd GitHub Repository (Wayland)](https://github.com/waycrate/swhkd) — Repositori *hotkey daemon* Wayland, yang sangat direkomendasikan untuk pengguna Sway.
      * `[Rekomendasi]` [Arch Wiki: Sxhkd](https://wiki.archlinux.org/title/Sxhkd) — Panduan konfigurasi dan contoh penggunaan `sxhkd`.

-----

### 📦 Modul 3: Standar Integrasi & Aplikasi (XDG) (7 Konsep)

**(9) Autostart (XDG Autostart spec)**

  * **Terminologi:**
      * **XDG (Cross-Desktop Group) Autostart Specification:** Standar Freedesktop yang mendefinisikan cara komponen desktop dan aplikasi latar belakang dimuat secara otomatis saat sesi grafis dimulai.
      * **File `.desktop`:** File konfigurasi yang digunakan oleh spesifikasi XDG (termasuk Autostart) untuk mendeskripsikan program.
  * **Sumber:**
      * `[Resmi]` [Desktop Application Autostart Specification (Freedesktop)](https://specifications.freedesktop.org/autostart-spec/latest/) — Spesifikasi resmi dari Freedesktop.
      * `[Rekomendasi]` [Arch Wiki: XDG Autostart](https://wiki.archlinux.org/title/XDG_Autostart) — Penjelasan detail mengenai direktori yang digunakan (`/etc/xdg/autostart` vs `~/.config/autostart`) dan cara menonaktifkan item.

**(10) Desktop Entry (`.desktop`) (XDG Desktop Entry spec)**

  * **Terminologi:**
      * **XDG Desktop Entry Specification:** Standar Freedesktop yang mendefinisikan cara pintasan aplikasi (*shortcut*), ikon, dan deskripsi dimodelkan di Linux.
  * **Sumber:**
      * `[Resmi]` [Desktop Entry Specification (Freedesktop)](https://specifications.freedesktop.org/desktop-entry-spec/latest/) — Spesifikasi resmi (wajib dipelajari untuk membuat *shortcut* yang valid).
      * `[Rekomendasi]` [Arch Wiki: Desktop entries](https://wiki.archlinux.org/title/Desktop_entries) — Contoh praktis dan tips implementasi.

**(11) XDG Base Directory & XDG\_RUNTIME\_DIR**

  * **Terminologi:**
      * **XDG Base Directory Specification:** Standar yang mendefinisikan lokasi direktori basis untuk file konfigurasi, data, dan *cache* non-esensial (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, dll.). Ini memastikan lingkungan yang rapi dan portabel.
      * **XDG\_RUNTIME\_DIR:** Direktori sementara yang unik untuk sesi pengguna saat ini, dikelola oleh `systemd-logind` (atau setara), yang ideal untuk file IPC (Inter-Process Communication) seperti *socket* Wayland atau PipeWire.
  * **Sumber:**
      * `[Resmi]` [Base Directory Specification (Freedesktop)](https://www.google.com/search?q=https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) — Spesifikasi resmi (pendek dan wajib dikuasai).
      * `[Rekomendasi]` [Arch Wiki: XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory) — Panduan yang sangat bagus tentang bagaimana menerapkan dan memaksakan standar ini.

**(21) Application launcher & menu (XDG Menu spec)**

  * **Terminologi:**
      * **XDG Menu Specification:** Standar yang mengatur cara aplikasi pengelola menu (seperti *rofi* atau *dmenu* yang Anda gunakan, atau menu di GNOME/KDE) menyusun dan mengelompokkan file `.desktop` menjadi menu yang hierarkis.
  * **Sumber:**
      * `[Resmi]` [Desktop Menu Specification (Freedesktop)](https://specifications.freedesktop.org/menu-spec/latest/) — Spesifikasi resmi.
      * `[Rekomendasi]` [Arch Wiki: Desktop environment\#Application\_launchers](https://www.google.com/search?q=https://wiki.archlinux.org/title/Desktop_environment%23Application_launchers) — Daftar peluncur yang kompatibel dan cara kerjanya.

**(22) File manager integration & MIME types**

  * **Terminologi:**
      * **MIME (Multipurpose Internet Mail Extensions) Type:** Standar untuk mengidentifikasi format file (misalnya, `text/plain`, `image/png`, `application/pdf`).
      * **XDG Shared Mime Info:** Standar Freedesktop yang memungkinkan aplikasi menemukan program yang sesuai untuk membuka jenis file tertentu.
  * **Sumber:**
      * `[Resmi]` [Shared MIME-info Specification (Freedesktop)](https://www.google.com/search?q=https://specifications.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-latest.html) — Spesifikasi resmi.
      * `[Rekomendasi]` [Arch Wiki: Default applications](https://wiki.archlinux.org/title/Default_applications) — Penjelasan cara mengatur aplikasi default menggunakan utilitas seperti `xdg-open` (C) dan `xdg-mime` (Shell).

**(40) Sandboxing & application portals (Flatpak, Snap, XDG Portals)**

  * **Terminologi:**
      * **Sandboxing:** Teknik isolasi aplikasi (mis. Flatpak, Snap) yang membatasi akses aplikasi ke sistem file, jaringan, atau perangkat keras.
      * **XDG Portals:** Antarmuka standar (D-Bus) yang memungkinkan aplikasi *sandboxed* meminta sumber daya sistem secara aman (misalnya, meminta akses ke File Manager untuk membuka file).
      * **flatpak (C/Shell):** Manajer paket dan sistem *sandboxing* yang populer.
  * **Sumber:**
      * `[Resmi - Portals]` [XDG Portals Documentation (Freedesktop)](https://flatpak.github.io/xdg-desktop-portal/) — Dokumentasi resmi yang menjelaskan arsitektur Portal.
      * `[Rekomendasi]` [Arch Wiki: Flatpak](https://wiki.archlinux.org/title/Flatpak) — Panduan instalasi dan penggunaan Flatpak, dan bagian tentang `xdg-desktop-portal-wlr` (seperti yang Anda tambahkan di `README.md`).

**(49) Packaging & distribution of config (dotfiles layout, portable config)**

  * **Terminologi:**
      * **Dotfiles:** File konfigurasi yang disimpan di direktori *home* (`~`) dan biasanya disembunyikan (diawali dengan titik `.` seperti `.bashrc`, `.config/`).
      * **Portable Config:** Praktik mendistribusikan konfigurasi agar mudah direplikasi (misalnya, menggunakan repositori Git dengan simbiosis *link* atau alat seperti *yadm*).
  * **Sumber:**
      * `[Rekomendasi - Praktik]` [Dotfiles: The Good Parts](https://www.google.com/search?q=https://www.anishathalye.com/2014/08/03/the-good-parts-of-dotfiles-with-ansible/) — Artikel yang sangat direkomendasikan tentang praktik terbaik dalam mengelola *dotfiles* menggunakan simbiosis *link* dan Ansible.
      * `[Rekomendasi - Alat]` [Home Manager Documentation](https://nix-community.github.io/home-manager/) — Pendekatan modern menggunakan Nix untuk mengelola konfigurasi pengguna secara deklaratif.

### ⚙️ Modul 4: Layanan Sistem & IPC (4 Konsep)

**(41) Inter-Process Communication (D-Bus)**

  * **Terminologi:**
      * **IPC (Inter-Process Communication):** Mekanisme yang memungkinkan proses (program) yang berjalan secara terpisah untuk berkomunikasi satu sama lain.
      * **D-Bus (Desktop Bus) (C/XML):** Sistem *message bus* standar di Linux untuk IPC. Ini dirancang untuk dua kasus utama: **System Bus** (komunikasi global, misalnya *NetworkManager* ke sistem) dan **Session Bus** (komunikasi sesi pengguna, misalnya *Compositor* ke aplikasi).
      * **Bus Name:** Nama unik yang digunakan proses untuk mendaftar di D-Bus (mis. `org.freedesktop.NetworkManager`).
  * **Identitas & Pengembangan:**
      * D-Bus dikembangkan di bawah proyek **Freedesktop.org** (terkait erat dengan GNOME dan KDE).
      * **Bahasa Utama:** C (untuk pustaka `libdbus` dan daemon).
      * **Persiapan Pengembangan:** Untuk membuat layanan D-Bus, Anda perlu memahami **D-Bus Specification** dan menggunakan *wrapper* bahasa tingkat tinggi (seperti `GDBus` untuk GTK, atau `dbus-rs` untuk Rust) untuk marshaling data.
  * **Sumber:**
      * `[Resmi - Spesifikasi]` [D-Bus Specification - Freedesktop.org](https://dbus.freedesktop.org/doc/dbus-specification.html) — Dokumen esensial yang menjelaskan arsitektur, tipe data, dan format *wire* biner D-Bus.
      * `[Rekomendasi - Arch]` [D-Bus - ArchWiki](https://wiki.archlinux.org/title/D-Bus) — Mengulas implementasi di Arch, termasuk pilihan antara `dbus-broker` (standar performa tinggi) dan implementasi referensi.

**(42) Service Management (systemd)**

  * **Terminologi:**
      * **systemd (C/Shell):** *System and Service Manager* yang berjalan sebagai **PID 1** (proses pertama) di sebagian besar distro Linux modern. Ini bertanggung jawab untuk *bootstrapping* sistem, mengelola *service* (layanan), *cgroup* (grup kontrol), *mount point*, dan *session* pengguna.
      * **Unit:** File konfigurasi yang mendeskripsikan *service* (`.service`), *target* (`.target`), *socket* (`.socket`), atau *mount point* (`.mount`).
      * **Socket Activation:** Fitur utama systemd yang memungkinkan layanan hanya dimulai saat koneksi ke *socket*-nya diterima, menghemat sumber daya (*low footprint*) dan mempercepat *boot*.
  * **Identitas & Pengembangan:**
      * **Bahasa Utama:** C (inti systemd), Shell (utilitas seperti `systemctl`).
      * **Persiapan Pengembangan:** Wajib menguasai sintaks *unit file* (`Type=`, `ExecStart=`, `WantedBy=`, dll.) dan konsep ketergantungan (*dependency*).
  * **Sumber:**
      * `[Resmi]` [Systemd - systemd.io](https://systemd.io/) — Situs resmi yang memuat dokumentasi, konsep (seperti *cgroup*), dan *manual pages*.
      * `[Rekomendasi - Arch]` [systemd - ArchWiki](https://wiki.archlinux.org/title/Systemd) — Detail implementasi, jenis-jenis unit (`Type=simple`, `Type=forking`, `Type=dbus`), dan perintah dasar `systemctl`.

**(43) Device Management (udev)**

  * **Terminologi:**
      * **udev (C):** Manajer perangkat (device manager) untuk kernel Linux. Ini menangani peristiwa *hot-plugging* (perangkat dicolok/dicabut), membuat *node* perangkat di direktori `/dev`, dan menjalankan aturan berdasarkan atribut perangkat.
      * **udev rules:** File konfigurasi yang menentukan tindakan yang harus diambil saat suatu perangkat ditemukan atau dilepas, biasanya terletak di `/etc/udev/rules.d/`.
  * **Identitas & Pengembangan:**
      * **Bahasa Utama:** C (inti udev), *Rules* ditulis dalam sintaks yang sangat spesifik.
      * **Persiapan Pengembangan:** Wajib memahami cara menggunakan `udevadm info -a -p` dan `udevadm monitor` untuk mengidentifikasi atribut perangkat (`KERNEL`, `SUBSYSTEM`, `ATTRS{idVendor}`, dll.) untuk menulis aturan yang tepat.
  * **Sumber:**
      * `[Resmi - Manpage]` [udev(7) - Arch manual pages](https://man.archlinux.org/man/udev.7.en) — Dokumentasi resmi tentang sintaks aturan udev, operator (`=`, `!=`, `+=`, `:=`), dan variabel yang tersedia.
      * `[Rekomendasi - Arch]` [udev - ArchWiki](https://wiki.archlinux.org/title/Udev_\(Magyar\)) — Penjelasan tentang prioritas aturan (`/etc/udev/rules.d/` mendahului `/usr/lib/udev/rules.d/`).

**(44) Authorization Framework (Polkit/PolicyKit)**

  * **Terminologi:**
      * **Polkit (PolicyKit) (C/JavaScript):** Kerangka kerja otorisasi (authorization framework) di Linux yang menyediakan mekanisme non-SUDO terpusat untuk program yang tidak memiliki hak istimewa (*unprivileged*) agar dapat menjalankan operasi dengan hak istimewa (*privileged*) melalui D-Bus.
      * **Action:** Operasi yang didefinisikan oleh suatu program yang membutuhkan hak istimewa (mis. `org.freedesktop.NetworkManager.settings.modify`).
      * **Authentication Agent:** Program (seperti `polkit-gnome-agent` atau `lxsession`) yang bertanggung jawab menampilkan dialog *password* kepada pengguna ketika otorisasi interaktif diperlukan.
  * **Identitas & Pengembangan:**
      * **Bahasa Utama:** C (inti daemon), Aturan kustom ditulis dalam **JavaScript** (di `/etc/polkit-1/rules.d/`).
      * **Persiapan Pengembangan:** Untuk kustomisasi, Anda perlu menulis aturan Polkit dalam JavaScript yang menggunakan fungsi seperti `polkit.addRule` untuk menentukan apakah suatu *subject* (pengguna/proses) diizinkan untuk melakukan suatu *action*.
  * **Sumber:**
      * `[Resmi - Referensi]` [polkit Reference Manual - Freedesktop.org](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html) — Referensi API dan penjelasan mendalam tentang arsitektur: *Mechanism* (program berhak istimewa) dan *Subject* (program tanpa hak istimewa).
      * `[Rekomendasi - Praktis]` [ArchWiki: NetworkManager (Polkit permissions)](https://www.google.com/search?q=https://wiki.archlinux.org/title/NetworkManager%23Set_up_PolicyKit_permissions) — Contoh praktis cara menulis aturan JavaScript Polkit untuk memberikan izin tanpa perlu *password* kepada grup pengguna tertentu.

### 🖥️ Modul 5: Aplikasi Antarmuka Pengguna (5 Konsep)

**(18) Panel / Taskbar / Dock / Status bar**

  * **Terminologi:** Komponen UI yang berfungsi sebagai pusat informasi (mis. status baterai, volume) dan interaksi (daftar jendela, *taskbar*). Di lingkungan CLI/tiling WM, ini sering disebut **Status Bar** (mis. **Waybar**, **Polybar**, **Lemonbar**).
  * **Sumber:**
      * `[Resmi - Waybar]` [Waybar Wiki/Dokumentasi](https://www.google.com/search?q=https://github.com/Alexays/Waybar/wiki) — Dokumentasi untuk *status bar* Wayland yang populer, menunjukkan struktur konfigurasi JSON.
      * `[Resmi - i3bar/i3status]` [i3bar Protocol - i3wm.org](https://i3wm.org/docs/i3bar-protocol.html) — Spesifikasi protokol komunikasi antara *status generator* (seperti `i3status` atau `i3blocks`) dan *bar* itu sendiri. Ini adalah protokol yang dicontoh banyak bar Wayland.
      * `[Rekomendasi]` [Arch Wiki: List of applications\#Status bars](https://www.google.com/search?q=https://wiki.archlinux.org/title/List_of_applications%23Status_bars) — Daftar perbandingan status bar CLI yang ringan.

**(19) Notification daemon (libnotify)**

  * **Terminologi:** Daemon (layanan latar belakang) yang menerima permintaan notifikasi dari aplikasi melalui D-Bus dan menampilkannya di layar. Standar ini diatur oleh Freedesktop.
  * **Sumber:**
      * `[Resmi]` [Desktop Notifications Specification - Freedesktop](https://specifications.freedesktop.org/notification-spec/latest/index.html) — Spesifikasi resmi yang menjelaskan antarmuka D-Bus dan kemampuan yang diharapkan.
      * `[Rekomendasi - Daemon]` [Arch Wiki: Desktop notifications](https://wiki.archlinux.org/title/Desktop_notifications) — Perbandingan *notification daemon* CLI ringan (mis. **Dunst**, **Mako**) yang kompatibel dengan Wayland.

**(20) Clipboard manager**

  * **Terminologi:** Aplikasi yang mencatat riwayat konten yang disalin (clipboard) dan memungkinkan pemilihan entri sebelumnya. Di Wayland, ini sangat tergantung pada protokol standar.
  * **Sumber:**
      * `[Resmi - wl-clipboard]` [wl-clipboard GitHub](https://github.com/bugaevc/wl-clipboard) — Utilitas CLI esensial untuk berinteraksi dengan *clipboard* Wayland dari skrip dan terminal Anda.
      * `[Rekomendasi - Manager]` [Clipman GitHub](https://www.google.com/search?q=https://github.com/yairm210/clipman) — Salah satu *clipboard manager* Wayland yang kompatibel dengan Sway.

**(26) Screen locking & screensaver / DPMS**

  * **Terminologi:**
      * **Screen Locking:** Tindakan mengunci sesi pengguna, biasanya memerlukan kata sandi untuk dibuka, untuk keamanan.
      * **DPMS (Display Power Management Signaling):** Standar yang memungkinkan OS/Compositor mematikan atau menempatkan monitor ke mode tidur.
  * **Sumber:**
      * `[Resmi - DPMS]` [Kernel Docs: DPMS](https://www.google.com/search?q=https://docs.kernel.org/fb/dpms.html) — Dokumentasi kernel singkat tentang sinyal DPMS.
      * `[Rekomendasi - Locker]` [Swaylock GitHub](https://github.com/swaywm/swaylock) — *Screen locker* minimalis yang dirancang untuk Sway/wlroots. Anda harus menguasai sintaks `swaylock` dan integrasinya dengan skrip pengatur daya.
      * `[Rekomendasi - Inhibit]` [swayidle GitHub](https://github.com/swaywm/swayidle) — Daemon yang menggunakan protokol `idle-inhibit` Wayland untuk menjalankan perintah (mis. `swaylock`, DPMS off) setelah durasi idle tertentu.

**(27) Screen capture & screencast (PipeWire-based)**

  * **Terminologi:** Tindakan mengambil *screenshot* atau merekam video layar (*screencast*). Di Wayland, ini diaktifkan melalui **PipeWire** dan **XDG Portals** (Modul 3) untuk alasan keamanan (aplikasi tidak dapat melihat layar tanpa izin).
  * **Sumber:**
      * `[Resmi - PipeWire]` [PipeWire Website](https://pipewire.org/) — Sumber resmi untuk PipeWire, yang mengelola audio, video, dan *screen sharing*.
      * `[Rekomendasi - Utilitas]` [grimshot GitHub](https://www.google.com/search?q=https://github.com/swaywm/sway/tree/master/contrib/grimshot) — Utilitas CLI sederhana dan cepat untuk mengambil *screenshot* di Wayland (`grim` adalah alat intinya).
      * `[Rekomendasi - Screencast]` [Arch Wiki: Screen capture](https://wiki.archlinux.org/title/Screen_capture) — Daftar alat Wayland/PipeWire seperti **wf-recorder** (wlroots) dan **OBS Studio**.

-----

### 🎨 Modul 6: Tampilan & Lingkungan (7 Konsep)

**(12) Environment variables (XDG\_\*, WAYLAND\_DISPLAY, DISPLAY, PATH, LANG)**

  * **Terminologi:** Variabel sistem yang menyimpan konfigurasi dan informasi yang dapat diakses oleh semua proses.
  * **Sumber:**
      * `[Resmi - Manpage]` [environ(7) - Linux Manual](https://www.google.com/search?q=https://man.archlinux.org/man/environ.7) — Manpage standar Linux yang menjelaskan konsep *environment*.
      * `[Rekomendasi - Arch]` [Arch Wiki: Environment variables](https://wiki.archlinux.org/title/Environment_variables) — Penjelasan cara mengatur variabel secara global (`/etc/environment`, `pam_env`) dan per sesi (`.bashrc`, *wm-config*). Ini adalah tempat *pam\_env* harus dipelajari.

**(15) Toolkit & Theme engines (GTK, Qt)**

  * **Terminologi:**
      * **Toolkit:** Pustaka perangkat lunak yang menyediakan komponen GUI (tombol, *widget*, *window*) kepada pengembang aplikasi. **GTK** (GNOME/C) dan **Qt** (KDE/C++) adalah yang dominan.
      * **Theme Engine:** Mesin yang bertanggung jawab untuk merender tampilan visual (*styling*) dari *widget* yang disediakan oleh Toolkit (mis. Tema Adwaita, Tema Breeze).
  * **Sumber:**
      * `[Resmi - GTK]` [GTK Theming Documentation](https://www.google.com/search?q=https://developer.gnome.org/gtk4/stable/theming.html) — Dokumentasi resmi tentang cara kerja *theming* di GTK4 (menggunakan CSS).
      * `[Resmi - Qt]` [Qt Styling Documentation](https://doc.qt.io/qt-6/stylesheet.html) — Dokumentasi resmi tentang *Qt Style Sheet*.

**(16) Icon & cursor theme (Icon Theme spec)**

  * **Terminologi:** Standar Freedesktop yang mendefinisikan cara tema ikon dan kursor dikemas dan ditemukan oleh aplikasi.
  * **Sumber:**
      * `[Resmi]` [Icon Theme Specification - Freedesktop](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html) — Spesifikasi resmi. Anda harus menguasai file `index.theme`.
      * `[Resmi]` [Cursor Specification - Freedesktop](https://www.google.com/search?q=https://specifications.freedesktop.org/cursor-theme-spec/cursor-theme-spec-latest.html) — Spesifikasi resmi.
      * `[Rekomendasi]` [Arch Wiki: Cursor themes](https://wiki.archlinux.org/title/Cursor_themes) — Panduan praktis untuk instalasi dan konfigurasi kursor/ikon.

**(17) Settings/config daemon (dconf/gsettings, kconfig)**

  * **Terminologi:**
      * **dconf/gsettings:** Sistem konfigurasi hierarkis, yang berfungsi sebagai *backend* untuk konfigurasi GNOME dan GTK. **dconf** adalah *backend*-nya, dan **gsettings** adalah API/CLI yang digunakan aplikasi.
      * **kconfig:** Sistem konfigurasi setara di KDE/Qt.
  * **Sumber:**
      * `[Resmi - dconf]` [dconf Manual Page](https://man.archlinux.org/man/dconf.1) — Dokumentasi CLI untuk utilitas `dconf`.
      * `[Resmi - gsettings]` [gsettings Manual Page](https://man.archlinux.org/man/gsettings.1) — Dokumentasi CLI untuk berinteraksi dengan *database* konfigurasi secara deklaratif (wajib dikuasai untuk *scripting* tema GTK/ikon).
      * `[Rekomendasi]` [Arch Wiki: GSettings](https://www.google.com/search?q=https://wiki.archlinux.org/title/GSettings) — Panduan cara membuat *dump* (ekspor) dan *load* (impor) konfigurasi menggunakan GSettings.

**(43) Localization & input locales (locale, ICU)**

  * **Terminologi:**
      * **Locale:** Sekumpulan parameter yang mendefinisikan bahasa, negara, dan set karakter yang digunakan oleh sistem.
      * **ICU (International Components for Unicode):** Pustaka standar yang digunakan banyak aplikasi untuk menangani pemformatan tanggal, mata uang, dan *collation* (pengurutan) yang benar secara linguistik.
  * **Sumber:**
      * `[Resmi - Manpage]` [locale(1) - Linux Manual](https://man.archlinux.org/man/locale.1) — Perintah CLI untuk melihat dan mengatur *locale* saat ini.
      * `[Rekomendasi - Arch]` [Arch Wiki: Locale](https://wiki.archlinux.org/title/Locale) — Panduan vital untuk konfigurasi `/etc/locale.conf` dan cara menghasilkan *locale* yang diperlukan.

**(44) Font configuration & rendering (fontconfig, freetype)**

  * **Terminologi:**
      * **Fontconfig:** Pustaka yang mengelola daftar font yang tersedia dan menyediakan API bagi aplikasi untuk mencari font yang cocok berdasarkan kriteria.
      * **Freetype:** Pustaka yang bertanggung jawab untuk merender (*rasterizing*) font vektor menjadi piksel di layar.
  * **Sumber:**
      * `[Resmi - Fontconfig]` [Fontconfig Manual Page](https://www.google.com/search?q=https://man.archlinux.org/man/fontconfig.5) — Dokumentasi tentang sintaks konfigurasi XML di `/etc/fonts/local.conf`.
      * `[Rekomendasi - Arch]` [Arch Wiki: Fonts](https://wiki.archlinux.org/title/Fonts) — Panduan yang sangat detail tentang *antialiasing*, *hinting*, dan *subpixel rendering* di Arch Linux.

**(45) Color management & gamma (colord, xcalib)**

  * **Terminologi:** Proses memastikan warna ditampilkan secara konsisten di berbagai perangkat (monitor, printer).
  * **Sumber:**
      * `[Resmi - colord]` [colord Website](https://www.freedesktop.org/software/colord/index.html) — Daemon *color management* standar Freedesktop.
      * `[Resmi - xcalib]` [xcalib GitHub](https://www.google.com/search?q=https://github.com/Unia/xcalib) — Alat CLI untuk memuat *color profile* dan mengatur *gamma* secara manual (penting untuk X11).

-----

### 🛠️ Modul 7: Kontrol Lanjutan & Skrip (3 Konsep)

**(36) Scripting utilities / CLIs (swaymsg, i3-msg, xdotool, wmctrl)**

  * **Terminologi:** Utilitas CLI yang memungkinkan skrip Shell berinteraksi dengan Compositor/Window Manager untuk mengotomatisasi tugas (*automation*).
  * **Sumber:**
      * `[Resmi - swaymsg]` [swaymsg Manual Page](https://man.archlinux.org/man/swaymsg.1) — Dokumentasi CLI untuk mengirim perintah (mis. pindah *workspace*, *resize window*) ke Sway. Wajib dikuasai untuk membuat *scripting* lanjutan di Sway.
      * `[Resmi - xdotool]` [xdotool GitHub](https://github.com/jordansissel/xdotool) — Dokumentasi untuk alat X11 yang sangat populer untuk mensimulasikan input mouse/keyboard. (Hanya bekerja di bawah XWayland).
      * `[Rekomendasi]` [Arch Wiki: Sway](https://www.google.com/search?q=https://wiki.archlinux.org/title/Sway%23Configuration) — Bagian yang menunjukkan bagaimana `swaymsg` diintegrasikan ke dalam `config` Sway.

**(37) Status bar protocols & JSON blocks (i3bar/protocol)**

  * **Terminologi:** Protokol berbasis JSON atau teks sederhana yang digunakan untuk mengirim data status dari *script* CLI ke *status bar* (mis. Waybar, Polybar).
  * **Sumber:**
      * `[Resmi]` [i3bar Protocol Specification](https://i3wm.org/docs/i3bar-protocol.html) — Protokol berbasis JSON yang diadopsi secara luas.
      * `[Rekomendasi]` [i3status-rust GitHub](https://github.com/greshake/i3status-rust) — Contoh *status line generator* yang fleksibel, dikembangkan di Rust, yang menghasilkan output JSON yang sesuai dengan protokol ini.

**(46) Window rules, focus behaviour, floating vs tiling rules**

  * **Terminologi:** Aturan yang diterapkan oleh Compositor/WM untuk menentukan bagaimana jendela tertentu harus dikelola (mis. memaksa Firefox berstatus *floating*, atau mengirim Steam ke *workspace* 5).
  * **Sumber:**
      * `[Resmi - Sway]` [Sway Configuration Documentation (for rules)](https://www.google.com/search?q=https://github.com/swaywm/sway/blob/master/sway/config.5.scdoc) — Dokumentasi rinci tentang sintaks *rule* Sway (mis. `for_window`).
      * `[Rekomendasi - Sway]` [Sway IPC Documentation (Window Properties)](https://www.google.com/search?q=https://github.com/swaywm/sway/blob/master/sway/ipc.7.scdoc) — Cara melihat properti jendela yang dapat Anda targetkan menggunakan `swaymsg -t get_tree`.

Dokumen memiliki tiga lapisan nilai:

1.  **Daftar Konsep** (49 item).
2.  **Struktur Pembelajaran** (7 Modul Tematik).
3.  **Sumber Resmi** (untuk setiap konsep).

---

[a]: ./module/bagian-1/README.md
<!--
Apakah Anda ingin saya membuat file baru, misalnya `LEARNING_PATH.md`, yang berisi struktur ini dan memigrasikan konten lengkap (termasuk detail "Dibangun dengan" dan "Kemampuan") untuk Modul 1 sebagai contoh?
Struktur ini sekarang jauh lebih logis untuk dipelajari secara berurutan. Anda membangun dari inti (grafik, input), beralih ke standar (XDG), lalu mengintegrasikan layanan (daemon), dan terakhir menyesuaikan UI (aplikasi, tema, skrip).
---

-->
## Catatan tambahan penting

* Disini kita memilih memasukkan topik dari *low-level system* sampai *user-facing utilities* yang berpengaruh langsung pada **scripting / konfigurasi** DE.
* Untuk referensi spesifik (standar/ spesifikasi) penting yang kita gunakan sebagai acuan: freedesktop.org (Desktops, Desktop Entry, Autostart), dokumentasi Wayland & protokol, dan dokumentasi D-Bus. ([Freedesktop][1])
<!--
* Jika kamu ingin, saya dapat **mengelompokkan** 48 konsep ini menjadi peta belajar bertingkat (mis. *inti, penting, lanjutan, opsional untuk scripting*) dan menyusun urutan praktis (file mana, perintah apa, contoh skrip pendek) sehingga bisa langsung dipraktekkan.
Saya susun ini ringkas namun lengkap — bila mau, saya lanjut buat **peta belajar bertingkat + contoh skrip nyata** untuk setiap konsep inti (mis. autostart, IPC/DBus, status bar JSON, hotkeys, power management, PipeWire screencast).
-->

[1]: https://www.freedesktop.org/wiki/Desktops/?utm_source=chatgpt.com "Desktops"
[2]: https://en.wikipedia.org/wiki/Wayland_%28protocol%29?utm_source=chatgpt.com "Wayland (protocol)"
[3]: https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html?utm_source=chatgpt.com "Desktop Application Autostart Specification"
[4]: https://specifications.freedesktop.org/desktop-entry-spec/latest-single?utm_source=chatgpt.com "Desktop Entry Specification"
[5]: https://www.freedesktop.org/wiki/IntroductionToDBus/?utm_source=chatgpt.com "IntroductionToDBus"
[6]: https://absurdlysuspicious.github.io/wayland-protocols-table/?utm_source=chatgpt.com "Wayland protocols support table - GitHub Pages"

---

Penutup singkat dan saran praktis:

* Fokus urutan belajar: mulai dari **(12) Environment Variables**, **(9–11) Autostart/.desktop/XDG**, **(5–8) GPU/input/output**, **(34–36) hotkeys, scripting utilities, status bar**, lalu lanjut ke integrasi layanan (D-Bus, PipeWire, NetworkManager, systemd user).
* Untuk tiap topik di atas: praktikkan dengan membuat satu contoh kecil (mis. modul waybar untuk status baterai, autostart `.desktop` untuk aplikasi, systemd user unit untuk service ringan)
<!--
Berikut daftar **48 konsep** beserta **kemampuan konkret** yang harus dimiliki untuk setiap konsep agar dapat memahami, mengonfigurasi, dan (jika perlu) memodifikasinya secara mandiri. Untuk setiap item disertakan:
-
Jawaban ini bersifat teknis dan praktis — langsung ke inti supaya dapat kamu implementasikan dalam pembelajaran dan eksperimen.
.
* Jika kamu ingin, saya dapat susun rencana latihan bertingkat (praktek file-by-file) untuk 10 konsep prioritas pertama dalam bentuk checklist yang bisa kamu jalankan di Arch-mu — lengkap dengan contoh perintah, file yang diedit, dan cara menguji.

Saya siap membuat checklist praktis tersebut sekarang — atau langsung memberi contoh skrip untuk salah satu konsep yang ingin kamu praktikkan pertama.
Pendeknya: **48 konsep** yang sudah saya rangkum sebelumnya *mewakili hampir seluruh aspek konfigurasi dan scripting DE* — namun **tidak cukup** bila tujuan akhirnya adalah menghasilkan **ISO distribusi / live image** yang dapat di-redistribusi. Membuat ISO membutuhkan *lapisan tambahan* yang berkaitan dengan proses pembuatan image, boot, paket, legalitas, dan infrastruktur distribusi. Saya sudah kumpulkan semua konsep tambahan yang diperlukan dan hitungannya tepat — baca ringkasan lengkap di bawah.

---

# Inti jawaban

* Konsep DE untuk *scripting & konfigurasi* yang sudah saya berikan = **48 konsep**.
* Konsep tambahan khusus untuk **pembuatan ISO / live image** = **26 konsep**.
* **Total konsep yang perlu kamu kuasai** untuk membuat hasil sistem Arch-mu menjadi ISO siap-pakai = **48 + 26 = 74 konsep**.

Saya beri daftar tambahan (26 item) beserta catatan teknis singkat dan apa yang perlu kamu persiapkan untuk masing-masing. Untuk rujukan teknis utama tentang membuat ISO dengan tooling resmi Arch, lihat dokumentasi `archiso` dan panduan boot/initramfs (saya sertakan tautan rujukan penting di akhir). ([ArchWiki][1])
-->
---

# 26 konsep tambahan (khusus membuat ISO / live image)

1. **Archiso — build system & template**

   * Mengerti struktur `releng/airootfs`, `profiles/`, `packages.x86_64`, skrip `build.sh`. (Archiso — implementasi: skrip shell + tooling, lihat Arch Wiki / repo). ([ArchWiki][1])

2. **Initramfs & mkinitcpio hooks**

   * Membuat initramfs yang tepat untuk boot live, termasuk hooks untuk cryptsetup/LVM. (mkinitcpio adalah tool utama). ([ArchWiki][2])

3. **Pilihan bootloader & konfigurasi (GRUB / systemd-boot / EFISTUB / Syslinux)**

   * Mengkonfigurasi entry boot untuk ISO/USB, menyiapkan grub.cfg / loader entries.

4. **UEFI vs BIOS — perbedaan dan penanganan isolinux/isohybrid/efiboot**

   * Menangani isohybrid, EFI/ESP, dan metadata boot.

5. **Kernel & module selection / custom kernel**

   * Memilih kernel (linux, linux-lts, custom), sertakan module/firmware yang dibutuhkan oleh live image.

6. **Kernel cmdline / early userspace (cryptroot, root= loopback)**

   * Menentukan parameter boot agar live root dan installer berjalan.

7. **Live filesystem layout — squashfs / overlayfs / aufs**

   * Menentukan apakah sistem live read-only + overlay untuk persisten atau writable.

8. **File system & partitioning scheme untuk installer**

   * Menyertakan skrip/opsi partisi otomatis/manual, dukungan UEFI/GPT, MBR.

9. **Chroot / bootstrap workflow (arch-chroot, pacman -r, pacstrap)**

   * Menyusun rootfs yang akan dimasukkan ke ISO.

10. **Pemilihan paket & manifest (packages.x86_64, custom packages)**

    * Menentukan paket dasar, DE, driver, firmware—dan membangun PKGBUILD bila perlu.

11. **Pacman configuration, keys & package signing**

    * Menjaga trust chain paket, mengelola keyring, menandatangani paket/ repo.

12. **Membuat dan hosting repo (repo-add, repo.db, mirror)**

    * Jika menyertakan paket custom, perlu repo yang dipakai oleh ISO.

13. **Compression, isohybrid, dan alat pembuatan ISO (xorriso, genisoimage)**

    * Membuat image yang bootable di USB/VM.

14. **Persistence support (overlay persistence untuk live)**

    * Jika ingin data tetap ada antar reboot (opsional tapi sering diinginkan).

15. **Installer integration (Calamares / custom installer scripts)**

    * Menyediakan GUI/CLI installer pada image (Calamares umum dipakai). ([Calamares][3])

16. **systemd units / first-boot hooks / first-run setup**

    * Menjalankan konfigurasi awal (user creation, locale, SSH keys).

17. **udev rules & firmware inclusion (firmware-nonfree jika perlu)**

    * Pastikan device dikenali selama boot live.

18. **Secure Boot / shim / signing (opsional tetapi kompleks)**

    * Jika ingin support Secure Boot, perlu signing kernel/shim, dan memahami chain of trust.

19. **Live user defaults: autologin, XDG defaults, dotfiles**

    * Menentukan apakah live masuk otomatis, bahasa, timezone.

20. **First-boot scripts untuk resize, locales, pacman hooks**

    * Menyiapkan environment agar pengguna yang diinstal mendapatkan konfigurasi yang benar.

21. **Testing & reproducible builds (VM, QEMU, CI pipelines)**

    * Otomasi build & pengujian untuk memastikan ISO konsisten.

22. **Redistribution & licensing compliance**

    * Periksa lisensi paket (mis. firmware non-free) sebelum mendistribusikan.

23. **Membangun paket custom (PKGBUILD, makepkg)**

    * Jika aplikasi/kustom konfigurasi perlu dipaketkan.

24. **Mirror selection & bandwidth / hosting concerns**

    * Jika mendistribusikan banyak user, perlu mirror/hosting.

25. **ISO signing & checksums (sha256sum, gpg sig)**

    * Penting untuk keamanan distribusi.

26. **Dokumentasi installer, release notes, lokalizasi**

    * Panduan pengguna dan teks installer (bahasa, keyboard, help).

---

# Apa yang harus persiapkan (praktis)

Singkatnya, untuk mulai membuat ISO dari sistem Arch-mu:

* Kuasai/instal **archiso** dan baca template resminya; jalankan build minimal — dokumentasi resmi adalah titik awal. ([ArchWiki][1])
* Siapkan toolchain: `archiso`, `pacman`, `makepkg`, `xorriso`, `squashfs-tools`, `syslinux/grub` atau `systemd-boot`.
* Pelajari **mkinitcpio** dan hooks yang diperlukan untuk initramfs yang benar. ([ArchWiki][2])
* Siapkan VM (QEMU) untuk uji booting; selalu uji UEFI dan BIOS.
* Pelajari pembuatan **PKGBUILD** bila kamu butuh paket custom.
* Tentukan kebijakan **redistribusi & lisensi** (jika kamu mendistribusikan publik).
* Siapkan proses QA: build + test + checksum + signing + dokumentasi.

---

# Implementasi / bahasa yang terlibat & kemampuan yang harus miliki

Sesuai preferensimu (IT, scripting, terminal):

* **Bash / Shell scripting** — banyak tooling build (archiso, mkinitcpio, build scripts) menggunakan shell/Bash.
* **C / C++** — core components (kernel, compositor seperti Sway/hyprland, libinput, wlroots) diimplementasikan di C/C++ — berguna untuk debugging dan kontribusi upstream.
* **Python** — beberapa alat installer (Calamares plugins) dan packaging tools dapat menggunakan Python.
* **Makefile, PKGBUILD** — memahami struktur build paket Arch.
* **Git** — versi konfigurasi dan dotfiles, serta bekerja dengan repositori ISO templates.
* **xorriso / isohybrid tools** — alat pembuatan ISO.
* **GPG** — menandatangani file/ ISO / paket.

Persyaratan pengalaman: pengalaman membuat chroot, memahami `systemd`, kernel boot flow, udev, pacman, dan dasar jaringan (mirror, hosting). Untuk Secure Boot dan distribusi publik kamu perlu pengalaman manajemen kunci/signing.

Sumber utama implementasi: `archiso` (shell scripts + templates), `mkinitcpio` (Bash + hook scripts), `Calamares` (C++/Qt), bootloaders (C/assembly untuk bagian rendah). ([GitHub][4])

---

# Rekomendasi langkah awal (praktis, urut)

1. **Baca & jalankan contoh archiso** resmi; buat ISO "blank" dan uji boot di QEMU. ([ArchWiki][1])
2. Tambahkan paket dasar dan DE/WM secara bertahap; uji setiap tahap di VM.
3. Pelajari mkinitcpio hooks bila butuh LUKS/LVM/driver spesifik. ([ArchWiki][2])
4. Integrasikan installer (Calamares) bila ingin GUI installer. ([Calamares][3])
5. Siapkan proses signing & checksum sebelum distribusi.

---

# Rekomendasi Daftar Referensi (baca dulu)

* Arch Wiki — **archiso** (cara membangun live ISO dan template). ([ArchWiki][1])
* Arch Wiki — **mkinitcpio / Arch boot process** (initramfs dan boot flow). ([ArchWiki][2])
* **Calamares** (installer universal, jika butuh GUI installer). ([Calamares][3])
* Repositori resmi **archiso** (contoh scripts & license). ([GitHub][4])

<!--

Kalau mau, saya bisa langsung:

* Buat checklist lini demi lini (74 item) dengan prioritas *inti → penting → opsional*; **atau**
* Langsung susun *minimal reproducible archiso* (profile kecil) yang menggabungkan DE pilihanmu + autostart dotfiles — lalu saya jelaskan file mana yang harus kamu edit, perintah build, dan langkah test (lengkap per file).

Pilih salah satu dan saya kerjakan sekarang juga — saya susun langkah praktis yang bisa kamu jalankan di mesin Arch-mu.
-->
[1]: https://wiki.archlinux.org/title/Archiso?utm_source=chatgpt.com "archiso - ArchWiki"
[2]: https://wiki.archlinux.org/title/Mkinitcpio?utm_source=chatgpt.com "mkinitcpio - ArchWiki - Arch Linux"
[3]: https://calamares.io/?utm_source=chatgpt.com "Calamares - Calamares"
[4]: https://github.com/archlinux/archiso?utm_source=chatgpt.com "Official archiso scripts Repository (read-only mirror)"
