- [Window-Manager](./window-manager/README.md)
- [Gnome](./gnome/README.md)
- [Kde-Plasma](./kde-plasma/README.md)
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


## 32. **Systemd user units & service integration**

   * Fungsi: background services run per-user.
   * Scripting: membuat unit `~/.config/systemd/user/`.
---
   * Dibangun dengan: systemd (C), unit file syntax.
   * Kemampuan:

      * Dasar: membuat `~/.config/systemd/user/*.service`, enabling/disabling services, `systemctl --user`.
      * Rekomendasi: timer units, socket activation, transient units.
      * File/alat: `systemctl --user`, `journalctl --user`.


## 33. **Window decoration model (client-side vs server-side decorations)**

   * Fungsi: siapa yang menggambar titlebar/border.
   * Scripting: konfigurasi compositor/toolkit interaction (`xdg-decoration`).
---
   * Dibangun dengan: protokol Wayland / toolkit interactions.
   * Kemampuan:

      * Dasar: perbedaan CSD vs SSD, cara mengubah perilaku dekorasi di compositor/toolkit.
      * Rekomendasi: menyesuaikan theme atau patching client toolkit jika perlu.
      * File/alat: `xdg-decoration` protocol docs.


## 34. **Global hotkeys & shortcut handling**

   * Fungsi: binding shortcut ke aksi.
   * Scripting: file konfigurasi compositor, xbindkeys, sxhkd.
---
   * Dibangun dengan: komponen compositor (C), tools (sxhkd in C).
   * Kemampuan:

      * Dasar: konfigurasi keybind di compositor, penggunaan `swaygrab`/`swaymsg`.
      * Rekomendasi: mapping multi-key sequences, composing key-chords.
      * File/alat: compositor config, `sxhkd`, `xbindkeys`.


## 35. **Scripting utilities / CLIs (swaymsg, i3-msg, xdotool, wmctrl)**

   * Fungsi: kontrol runtime via command line.
   * Scripting: membuat wrapper functions dan hooks.
---
   * Dibangun dengan: C/C++.
   * Kemampuan:

      * Dasar: penggunaan CLI untuk mengendalikan WM/compositor, scripting wrappers.
      * Rekomendasi: membuat pustaka wrapper (bash/python) untuk operasi berulang.
      * File/alat: binaries terkait, man pages.



## 36. **Status bar protocols & JSON blocks (i3bar/protocol)**

   * Fungsi: format data untuk status bars.
   * Scripting: output JSON, modular scripts.
---

   * Dibangun dengan: spesifikasi sederhana (JSON streaming).
   * Kemampuan:

      * Dasar: keluaran JSON yang valid untuk status bar, streaming header/heartbeat.
      * Rekomendasi: membuat modul efisien yang update minimal, buffering output.
      * File/alat: contoh `i3status`, `i3bar` protocol.


## 37. **Filesystem mounts & udisks/gvfs integration**

   * Fungsi: automount, file browsing.
   * Scripting: `udisksctl`, `gio mount`.
---
   * Dibangun dengan: C, GLib bindings.
   * Kemampuan:

      * Dasar: `udisksctl` untuk automount, `gio mount`, mount options.
      * Rekomendasi: menulis udev/udisks rules untuk automount custom.
      * File/alat: `udisksctl`, `gio`, `/etc/fstab` knowledge.


## 38. **udev & device event handling**

   * Fungsi: deteksi perangkat baru (USB, audio devices).
   * Scripting: writing udev rules, `udevadm monitor`.
---
   * Dibangun dengan: C (udev).
   * Kemampuan:

      * Dasar: menulis udev rules, `udevadm monitor`, understanding device properties.
      * Rekomendasi: write rules for persistent naming, run scripts on device add/remove.
      * File/alat: `/etc/udev/rules.d/`, `udevadm`.


## 39. **Sandboxing & application portals (Flatpak, Snap, XDG Portals)**

   * Fungsi: izin aplikasi ter-sandbox, portal untuk screencast, file pickers.
   * Scripting: memahami portal behaviour.
---
   * Dibangun dengan: C, various languages (portals implemented in C).
   * Kemampuan:

      * Dasar: prinsip sandboxing, XDG portals usage for screencast/file chooser.
      * Rekomendasi: configure portal policies, integrate portal requests in UI.
      * File/alat: `xdg-desktop-portal`, flatpak/snap tooling.


## 40. **Security model (Wayland security, seccomp, namespaces)**

   * Fungsi: pembatasan akses antara aplikasi dan sistem.
   * Scripting: memeriksa capability, menggunakan portals.
---
   * Dibangun dengan: kernel features (C), seccomp filters (C).
   * Kemampuan:

      * Dasar: concept of least privilege, how Wayland isolates clients.
      * Rekomendasi: apply seccomp filters, namespace isolation for apps.
      * File/alat: apparmor/selinux basics (if used), seccomp tooling.


## 41. **Logging & diagnostics (journalctl, Xorg logs, compositor logs)**

   * Fungsi: debugging isu DE.
   * Scripting: log rotation, pattern checks.
---
   * Dibangun dengan: systemd-journald (C), logging systems.
   * Kemampuan:

      * Dasar: `journalctl`, reading compositor/Xorg logs, grep/awk for pattern.
      * Rekomendasi: membuat automated diagnostics script untuk pengguna.
      * File/alat: `journalctl`, `/var/log`.


## 42. **Localization & input locales (locale, ICU)**

   * Fungsi: bahasa & format lokal.
   * Scripting: set `LANG`, `LC_*`, keyboard layout switches.
---
   * Dibangun dengan: glibc locale data, ICU libraries (C/C++).
   * Kemampuan:

      * Dasar: set `LANG`, `LC_*`, regenerate locales (`locale-gen`).
      * Rekomendasi: manage input method per-locale, transliteration rules.
      * File/alat: `/etc/locale.conf`, `localectl`.


## 43. **Font configuration & rendering (fontconfig, freetype)**

   * Fungsi: font discovery & rendering.
   * Scripting: `fc-cache`, `fc-match`.
---
   * Dibangun dengan: C (fontconfig, freetype).
   * Kemampuan:

      * Dasar: `fc-cache`, `fc-match`, mengetahui konflik font dan fallback.
      * Rekomendasi: tuning hinting/antialiasing, bundling fonts in distro image.
      * File/alat: `/etc/fonts/`, `fontconfig` config files.


## 44. **Color management & gamma (colord, xcalib)**

   * Fungsi: profil kolor untuk monitor.
   * Scripting: apply ICC profiles.
---
   * Dibangun dengan: C (colord).
   * Kemampuan:

      * Dasar: apply ICC profiles, adjust gamma via `xcalib`/compositor.
      * Rekomendasi: integrate color profiles per monitor, scripting for profile switching.
      * File/alat: `colord`, `displaycal` workflows.


## 45. **Window rules, focus behaviour, floating vs tiling rules**

   * Fungsi: aturan per aplikasi/window class.
   * Scripting: compositor/window-manager rules.
---
   * Dibangun dengan: fitur WM/compositor (C).
   * Kemampuan:

      * Dasar: aturan berdasarkan `class`, `instance`, `title`, config syntax untuk rules.
      * Rekomendasi: menulis rule sets yang deterministic, debug behavior across apps.
      * File/alat: window manager config.


## 46. **Compositor extension & protocol negotiation (xdg-output, xdg-activation, idle inhibit)**

   * Fungsi: sinkronisasi output metadata & activation.
   * Scripting: respond to protocol capabilities.
---
   * Dibangun dengan: Wayland protocol extensions (XML/C).
   * Kemampuan:

      * Dasar: mengerti capability negotiation, implement client behavior sesuai protokol.
      * Rekomendasi: memeriksa feature flags pada compositor dan fallback.
      * File/alat: `wayland-protocols` docs.


## 47. **Remote desktop, VNC, RDP, Wayland remote (wayvnc, x11vnc)**

   * Fungsi: remote control / screen sharing.
   * Scripting: start/stop services, portal integration.
---
   * Dibangun dengan: C/C++ (various).
   * Kemampuan:

      * Dasar: start/stop remote services, secure tunneling (SSH), authentication.
      * Rekomendasi: automasi start/stop via systemd user services, handle Wayland-specific limitations.
      * File/alat: `wayvnc`, `x11vnc`, `xrdp`.


## 48. **Packaging & distribution of config (dotfiles layout, portable config)**

   * Fungsi: standar menyimpan/menyebar config.
   * Scripting: install scripts, `stow`, git hooks.
---
   * Dibangun dengan: plain text scripts, git-based workflows.
   * Kemampuan:

      * Dasar: menggunakan `git` untuk dotfiles, stow/management tools, reproducible config layouts.
      * Rekomendasi: membuat installer script yang idempotent, testing across systems.
      * File/alat: `stow`, `chezmoi`, `git`, CI pipelines for dotfiles.



---

**Jumlah pasti konsep di atas: 48 konsep.**

---

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
