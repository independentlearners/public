
# **Lapisan 5: Desktop Shell & Core Components**

Berisi **200 istilah** lengkap, disusun per entri singkat dan teknis. Setiap entri mencakup: **Nama (EN / ID)** · **Lapisan 5** · **Deskripsi singkat** · **Identitas / Implementasi (bahasa & lokasi kode umum)** · **Prasyarat untuk memodifikasi / mengembangkan**.

---

1. **Desktop Shell / Shell Desktop** · *Lapisan 5* · Program utama yang menyediakan lingkungan pengguna (panel, menu, workspace). · Implementasi: C/C++/Rust/JS (GNOME Shell JS, KWin C++). · Prasyarat: bahasa project, API compositors, extension API.

2. **Shell Extension / Ekstensi Shell** · *Lapisan 5* · Plugin yang memperluas fungsi shell (GNOME extensions). · Implementasi: JS, Python, C. · Prasyarat: memahami API ekstensi shell, packaging.

3. **Panel / Panel** · *Lapisan 5* · Bar horizontal/vertikal yang menampilkan applet, tray, jam, indikator. · Implementasi: C/JS/QML. · Prasyarat: toolkit binding, IPC ke shell.

4. **Top Bar / Bilah Atas** · *Lapisan 5* · Panel bagian atas layar (mis. GNOME top bar). · Implementasi: JS/C. · Prasyarat: CSS styling, layout widgets.

5. **Taskbar / Bilah Tugas** · *Lapisan 5* · Menampilkan jendela terbuka dan switching. · Implementasi: C++/Qt, JS. · Prasyarat: IPC ke window manager, event handling.

6. **Dock / Dok** · *Lapisan 5* · Launcher persistent dengan pin app dan running indicators. · Implementasi: C/Qt/JS. · Prasyarat: launcher spec, drag/drop.

7. **System Tray / Tray Sistem** · *Lapisan 5* · Area ikon aplikasi background (legacy X11/StatusNotifier). · Implementasi: libappindicator, StatusNotifier spec. · Prasyarat: protokol tray/StatusNotifier.

8. **Status Notifier / AppIndicator** · *Lapisan 5* · Standard modern untuk tray (freedesktop). · Implementasi: DBus, C/C++. · Prasyarat: DBus service, spec compliance.

9. **Applet / Applet** · *Lapisan 5* · Komponen kecil di panel (jam, jaringan, baterai). · Implementasi: JS/Python/C. · Prasyarat: API applet, configuration hooks.

10. **Indicator / Indikator** · *Lapisan 5* · Penampil status (ikon + tooltip) untuk sensor sistem. · Implementasi: DBus, toolkit. · Prasyarat: sensors API, dbus interface.

11. **Launcher / Peluncur** · *Lapisan 5* · UI untuk mencari/menjalankan aplikasi (menu, dash). · Implementasi: JS/C++/Rust. · Prasyarat: desktop file parsing, freedesktop menus.

12. **Application Menu / Menu Aplikasi** · *Lapisan 5* · Hirarki menu untuk aplikasi dan kategori. · Implementasi: libmenulibre/freedesktop. · Prasyarat: parsing .desktop, menu spec.

13. **Overview / Tampilan Ringkasan** · *Lapisan 5* · Mode yang menampilkan workspace, aplikasi, search. · Implementasi: JS/C. · Prasyarat: window listing, animations.

14. **Workspace / Ruang Kerja** · *Lapisan 5* · Area virtual untuk mengelompokkan jendela. · Implementasi: compositor bindings (Wayland/X11). · Prasyarat: workspace model & IPC.

15. **Dynamic Workspaces / Workspace Dinamis** · *Lapisan 5* · Workspace dibuat/hapus sesuai kebutuhan. · Implementasi: shell logic. · Prasyarat: event hooks, user prefs.

16. **Static Workspaces / Workspace Statik** · *Lapisan 5* · Jumlah workspace tetap dan terdefinisi. · Implementasi: shell config. · Prasyarat: config parsing.

17. **Workspace Switcher / Pengalih Workspace** · *Lapisan 5* · UI untuk pindah antar workspace (overview, pager). · Implementasi: widget + keybindings. · Prasyarat: focus management.

18. **Pager / Pager** · *Lapisan 5* · Miniatur tampilan workspace untuk navigasi. · Implementasi: Cairo/Skia drawing. · Prasyarat: scaling, snapshot of surfaces.

19. **Window List / Daftar Jendela** · *Lapisan 5* · Representasi linear/layout jendela aktif. · Implementasi: DBus/window manager API. · Prasyarat: window enumeration.

20. **Window Preview / Pratinjau Jendela** · *Lapisan 5* · Thumbnail live jendela untuk alt-tab atau pager. · Implementasi: compositor screenshots/dmabuf. · Prasyarat: dmabuf/EGLImage support.

21. **Alt-Tab Switcher / Pengalih Aplikasi** · *Lapisan 5* · UI untuk switching cepat antar aplikasi. · Implementasi: shell animations, keybindings. · Prasyarat: focus stack, window thumbnails.

22. **Launcher Search / Pencarian Peluncur** · *Lapisan 5* · Fuzzy search aplikasi/file/commands. · Implementasi: Rust/Python/JS (frontend) + indexer. · Prasyarat: desktop file index, file indexer (tracker).

23. **Application Indexer / Pengindeks Aplikasi** · *Lapisan 5* · Komponen yang mendaftar .desktop dan metadata aplikasi. · Implementasi: C/GLib, desktop entry parsing. · Prasyarat: freedesktop .desktop spec.

24. **Settings Daemon / Daemon Pengaturan** · *Lapisan 5* · Layanan yang mengaplikasikan pengaturan user (brightness, audio, keyboard). · Implementasi: C (GNOME settings-daemon), systemd user unit. · Prasyarat: DBus APIs, hw control libs.

25. **Configuration Backend / Backend Konfigurasi** · *Lapisan 5* · Penyimpanan konfigurasi (dconf, gsettings, ini, json). · Implementasi: GLib/GSettings, gsettings schemas. · Prasyarat: schema authoring, migration.

26. **GSettings / dconf** · *Lapisan 5* · Sistem pengaturan GNOME (key-value store). · Implementasi: GLib (C), dconf service. · Prasyarat: schema, gsettings bindings.

27. **KConfig / KDE Config** · *Lapisan 5* · Framework konfigurasi untuk KDE apps. · Implementasi: C++ (KDE Frameworks). · Prasyarat: KConfig format & kconfig compiler.

28. **Profile Manager / Manajer Profil** · *Lapisan 5* · Menyimpan koleksi pengaturan (tema, layouts) sebagai profil. · Implementasi: JSON/YAML + UI. · Prasyarat: serialization, apply hooks.

29. **Theme Engine / Mesin Tema** · *Lapisan 5* · Menerapkan style global (GTK/Qt themes). · Implementasi: CSS (GTK), QStyle (Qt). · Prasyarat: theme assets & parser.

30. **Icon Theme / Tema Ikon** · *Lapisan 5* · Set ikon aplikasi / sistem. · Implementasi: freedesktop icon spec. · Prasyarat: asset packaging.

31. **Shell Theme / Tema Shell** · *Lapisan 5* · Penataan tampilan shell (colors, panel layout). · Implementasi: CSS/JS/QML. · Prasyarat: theme API, style classes.

32. **Window Decorations / Dekorasi Jendela** · *Lapisan 5* · Frame/titlebar yang ditampilkan untuk jendela. · Implementasi: compositor SSD/CSD negotiation. · Prasyarat: xdg-decoration protocol.

33. **Client-Side Decoration (CSD)** · *Lapisan 5* · Dekorasi yang digambar oleh aplikasi sendiri. · Implementasi: toolkit support (GTK/QT). · Prasyarat: drag regions, hit testing.

34. **Server-Side Decoration (SSD)** · *Lapisan 5* · Dekorasi yang digambar oleh shell/compositor. · Implementasi: compositor protocol (xdg-decoration). · Prasyarat: compositor support.

35. **Titlebar Buttons / Tombol Judul** · *Lapisan 5* · Kontrol (minimize/maximize/close) pada frame. · Implementasi: C/CSS by shell. · Prasyarat: action hooks, accessibility.

36. **Window Rules / Aturan Jendela** · *Lapisan 5* · Kebijakan untuk menempatkan/men-decorate jendela otomatis. · Implementasi: matching engine (regex/class). · Prasyarat: match criteria, config format.

37. **Auto-tiling / Penataan Otomatis** · *Lapisan 5* · Fitur shell yang merotomatisasi tiling jendela. · Implementasi: layout engine plugin. · Prasyarat: container model & reflow algorithms.

38. **Floating Mode / Mode Mengambang** · *Lapisan 5* · Mode jendela yang bebas posisinya dari layout tiling. · Implementasi: shell state toggles. · Prasyarat: input grabs & stacking control.

39. **Pinning / Pin Aplikasi** · *Lapisan 5* · Menandai aplikasi agar selalu terlihat/pinned. · Implementasi: metadata flags. · Prasyarat: workspace policies.

40. **Auto-hide Panel / Panel Sembunyi Otomatis** · *Lapisan 5* · Panel yang tersembunyi kecuali pointer mendekat. · Implementasi: pointer zones + timers. · Prasyarat: hit-testing & animations.

41. **Hot Corner / Sudut Panas** · *Lapisan 5* · Trigger interaksi saat pointer mencapai sudut layar. · Implementasi: compositor pointer watcher. · Prasyarat: configurable actions & disable options.

42. **Gestures (Shell-level)** · *Lapisan 5* · Gestur multi-touch untuk overview, workspace switching. · Implementasi: libinput + gesture recognizer. · Prasyarat: gesture gestures mapping, thresholds.

43. **Edge Tiling / Edge Snapping** · *Lapisan 5* · Snap jendela saat diseret ke tepi untuk tiling cepat. · Implementasi: snapping logic in shell. · Prasyarat: snapping distance & visual guides.

44. **Workspace Naming / Penamaan Workspace** · *Lapisan 5* · Label/workspace id yang dapat dikustom. · Implementasi: shell config storage. · Prasyarat: UI for rename & persistence.

45. **Workspace Assignment Rules** · *Lapisan 5* · Aturan untuk menempatkan aplikasi ke workspace tertentu. · Implementasi: rule engine. · Prasyarat: matchers (app_id, class, title).

46. **Multiple Monitors Support / Multi-monitor** · *Lapisan 5* · Menangani layout dan panel per-output. · Implementasi: wl_output handling. · Prasyarat: per-output configs & scaling.

47. **Per-Output Panel / Panel Per-Output** · *Lapisan 5* · Panel berbeda pada tiap monitor. · Implementasi: shell output-aware widgets. · Prasyarat: output detection & layout mapping.

48. **Primary Monitor Selection** · *Lapisan 5* · Menentukan monitor utama untuk panel/menu. · Implementasi: config + runtime selection. · Prasyarat: output prioritization.

49. **Panel Widgets / Widget Panel** · *Lapisan 5* · Komponen yang ditaruh di panel (volume, battery). · Implementasi: plugin API. · Prasyarat: widget interface & lifecycle.

50. **Notification Center / Pusat Notifikasi** · *Lapisan 5* · Menampilkan dan mengelola notifikasi (history, actions). · Implementasi: C/GLib + DBus Notifications spec. · Prasyarat: notification daemon & policies.

51. **Notification Aggregation / Agregasi Notif** · *Lapisan 5* · Menggabungkan notifikasi berulang jadi satu. · Implementasi: dedupe logic. · Prasyarat: notification id matching.

52. **Do Not Disturb Mode** · *Lapisan 5* · Mode menonaktifkan notifikasi sementara. · Implementasi: settings flag + notifier filter. · Prasyarat: UI toggle & persistence.

53. **Quick Settings / Pengaturan Cepat** · *Lapisan 5* · Panel dropdown cepat (Wi-Fi, Bluetooth, volume). · Implementasi: shell UI + settings-daemon bindings. · Prasyarat: DBus control interfaces.

54. **Settings Panel / Panel Pengaturan** · *Lapisan 5* · UI untuk mengelola preferensi shell dan sistem. · Implementasi: toolkit app (GTK/Qt). · Prasyarat: settings backend (GSettings/KConfig).

55. **Power Menu / Menu Daya** · *Lapisan 5* · Aksi shutdown/restart/suspend accessible di shell. · Implementasi: call to logind D-Bus. · Prasyarat: polkit check & confirmation dialog.

56. **Session Logout / Keluar Sesi** · *Lapisan 5* · Mekanisme untuk mengakhiri sesi pengguna (save/kill processes). · Implementasi: session manager + systemd. · Prasyarat: session save hooks & confirmation.

57. **User Switch / Ganti Pengguna** · *Lapisan 5* · Fast user switching tanpa logout penuh. · Implementasi: greeter + seat management. · Prasyarat: systemd-logind multi-session.

58. **Lock Screen / Layar Kunci** · *Lapisan 5* · UI untuk mengunci layar (swaylock, gnome-screensaver). · Implementasi: standalone program + compositor integration. · Prasyarat: secure authentication agent and input inhibition.

59. **Screen Saver / Penghemat Layar** · *Lapisan 5* · Mode idle yang menampilkan animasi atau blank. · Implementasi: daemon + hooks. · Prasyarat: inhibit handling & power integration.

60. **Screensaver Inhibition / Inhibitor** · *Lapisan 5* · API untuk mencegah screensaver saat aktivitas (video). · Implementasi: logind inhibit + portal usage. · Prasyarat: proper inhibitor lifetime management.

61. **Lock Screen Notifications** · *Lapisan 5* · Kebijakan apakah notifikasi tampil saat layar terkunci. · Implementasi: notification daemon + security filters. · Prasyarat: privacy settings.

62. **Greeter / Layar Login (Greeter)** · *Lapisan 5* · UI awal untuk login (themeable greeter). · Implementasi: LightDM/Slim/GDM themes. · Prasyarat: PAM integration & session selection.

63. **Greeter Session Selection** · *Lapisan 5* · Memilih desktop/session type sebelum login. · Implementasi: list of available sessions (.desktop). · Prasyarat: session .desktop enumeration.

64. **Session .desktop Files / Session Entries** · *Lapisan 5* · File yang mendeskripsikan desktop sesi yang tersedia. · Implementasi: freedesktop session spec. · Prasyarat: authoring .desktop session files.

65. **Guest Session / Sesi Tamu** · *Lapisan 5* · Sesi yang dibatasi untuk tamu; ephemeral home dir. · Implementasi: greeter option + homedir tmpfs. · Prasyarat: security policy & cleanup.

66. **Kiosk Mode / Mode Kios** · *Lapisan 5* · Mode single-app atau locked-down UI untuk kios publik. · Implementasi: shell config + session policies. · Prasyarat: lockdown features & autostart.

67. **Accessibility Features / Fitur Aksesibilitas** · *Lapisan 5* · High-contrast, screen reader, on-screen keyboard. · Implementasi: AT-SPI integration, onboard. · Prasyarat: accessibility exposure & settings.

68. **On-screen Keyboard / Keyboard Layar** · *Lapisan 5* · Virtual keyboard untuk touchscreens. · Implementasi: GTK/Qt app + text-input protocol. · Prasyarat: text input v3 integration & compose keys.

69. **Magnifier / Pembesar Layar** · *Lapisan 5* · Fitur memperbesar area layar untuk visibilitas. · Implementasi: compositing transform & shader. · Prasyarat: input-following & viewport transforms.

70. **High Contrast / Tema Kontras Tinggi** · *Lapisan 5* · Tema khusus untuk visibilitas; shell support. · Implementasi: CSS/theme assets. · Prasyarat: toggles and preview.

71. **Focus Follows Mouse Policy (Shell level)** · *Lapisan 5* · Preferensi fokus input pada shell. · Implementasi: shell focus manager. · Prasyarat: consistent focus heuristics.

72. **Click-to-Focus Policy** · *Lapisan 5* · Kebijakan fokus yang memerlukan klik. · Implementasi: input dispatch rules. · Prasyarat: focus raising policy.

73. **Focus Stealing Prevention** · *Lapisan 5* · Pencegahan aplikasi mengambil fokus tak terduga. · Implementasi: focus heuristics & timeouts. · Prasyarat: configurable policy.

74. **Window Snapping Guides / Petunjuk Snap** · *Lapisan 5* · Visual guides saat melakukan snap/tiling. · Implementasi: overlay rendering. · Prasyarat: render passes & animations.

75. **Window Shadows / Bayangan Jendela** · *Lapisan 5* · Efek bayangan di sekitar jendela. · Implementasi: shader, blur passes. · Prasyarat: performance budget & compositing.

76. **Window Animations / Animasi Jendela** · *Lapisan 5* · Transisi saat membuka/menutup/meresize jendela. · Implementasi: animation timeline in shell. · Prasyarat: frame scheduling & easing functions.

77. **Workspace Indicators / Indikator Workspace** · *Lapisan 5* · Visual cue jumlah/aktivitas workspace. · Implementasi: panel widget. · Prasyarat: workspace state events.

78. **Hotkeys / Shortcut Global** · *Lapisan 5* · Bindings global untuk shell actions. · Implementasi: keygrab via compositor or shell. · Prasyarat: conflict resolution & accelerator map.

79. **Keyboard Accelerator / Accelerator** · *Lapisan 5* · Shortcut yang dipetakan ke action UI. · Implementasi: settings store & runtime bindings. · Prasyarat: localization of shortcuts.

80. **Custom Keybindings / Pintasan Kustom** · *Lapisan 5* · User-defined hotkeys for actions. · Implementasi: config format + reload. · Prasyarat: safe parsing & persistence.

81. **Mouse Bindings / Pintasan Mouse** · *Lapisan 5* · Gestures and button combos for window ops. · Implementasi: pointer event mapping. · Prasyarat: input grabs & configurable maps.

82. **Command Palette / Palet Perintah** · *Lapisan 5* · Quick command execution UI (fuzzy). · Implementasi: UI + command dispatcher. · Prasyarat: command registry & permissions.

83. **Shell Scriptability / Scripting API** · *Lapisan 5* · API untuk mengotomasi shell behavior (JS API, IPC). · Implementasi: extension interfaces (GNOME Shell JS). · Prasyarat: secure bindings & docs.

84. **Shell IPC / Shell D-Bus API** · *Lapisan 5* · Interface D-Bus untuk mengontrol shell programmatically. · Implementasi: org.gnome.Shell / custom DBus. · Prasyarat: exported methods & introspection.

85. **Shell State Serialization / Save State** · *Lapisan 5* · Menyimpan pengaturan UI (panels, widgets) antara sesi. · Implementasi: JSON/gsettings store. · Prasyarat: deterministic serialization.

86. **Session Restore / Pulihkan Sesi** · *Lapisan 5* · Mengembalikan aplikasi dan posisi jendela saat login kembali. · Implementasi: session manager hooks. · Prasyarat: app support for save/restore.

87. **Autostart Delay / Startup ordering** · *Lapisan 5* · Penjadwalan autostart apps untuk UX snappiness. · Implementasi: systemd user units or timers. · Prasyarat: dependency mapping.

88. **Startup Profiling / Pelacakan Startup** · *Lapisan 5* · Analisis waktu startup shell & apps untuk optimisasi. · Implementasi: telemetry/timestamps. · Prasyarat: profiling hooks & logs.

89. **Plugin API / API Plugin** · *Lapisan 5* · Interface untuk menambah kemampuan shell via plugin. · Implementasi: stable ABI & loader. · Prasyarat: sandboxing & versioning.

90. **Extension Management UI** · *Lapisan 5* · UI untuk mengaktifkan/menonaktifkan ekstensi. · Implementasi: settings app + backend. · Prasyarat: extension metadata & security review.

91. **Security Model for Extensions** · *Lapisan 5* · Pembatasan izin ekstensi agar tidak kompromi privasi. · Implementasi: permission manifest & sandbox. · Prasyarat: policy design & enforcement.

92. **Telemetry Opt-in / Telemetry Settings** · *Lapisan 5* · Pengaturan pengumpulan data performa yang menghormati privasi. · Implementasi: opt-in dialogs & uploader. · Prasyarat: anonymization & retention policy.

93. **Shell Accessibility API Exposure** · *Lapisan 5* · Eksposisi shell elements ke AT-SPI (screen reader). · Implementasi: ATK/AT-SPI bridge. · Prasyarat: semantic roles & testing.

94. **Search Provider API** · *Lapisan 5* · Interface untuk menambah sumber pencarian ke launcher. · Implementasi: D-Bus / extension API. · Prasyarat: indexing & rank scoring.

95. **File Manager Integration** · *Lapisan 5* · Interop between shell and file manager (open with, desktop icons). · Implementasi: DBus actions & .desktop. · Prasyarat: file manager spec hooks.

96. **Desktop Icons / Ikon Desktop** · *Lapisan 5* · Representasi files/shortcuts on desktop area. · Implementasi: nautilus/desktop or shell-managed icons. · Prasyarat: file watching & drag/drop.

97. **Desktop Background / Wallpaper** · *Lapisan 5* · Setting & engine to draw backgrounds (static/slide). · Implementasi: wallpaper service, CSS/shader. · Prasyarat: resource loading & scaling.

98. **Lockscreen Background Independent** · *Lapisan 5* · Separate background for lockscreen with privacy options. · Implementasi: shell lockscreen UI. · Prasyarat: secure compositing.

99. **Screensaver Themes** · *Lapisan 5* · Pluggable visual themes for screensaver. · Implementasi: plugin UI. · Prasyarat: performance & suspend-safe.

100. **Sound Indicator / Indikator Suara** · *Lapisan 5* · Volume control UI integrated with PulseAudio/PipeWire. · Implementasi: DBus to audio server. · Prasyarat: audio API and permission.

101. **Bluetooth Indicator** · *Lapisan 5* · UI to pair/manage bluetooth devices. · Implementasi: BlueZ DBus integration. · Prasyarat: BlueZ API & policy.

102. **Network Indicator / Indikator Jaringan** · *Lapisan 5* · Network status and quick controls (NM). · Implementasi: NetworkManager DBus. · Prasyarat: NM API & connection management.

103. **Battery Indicator / Indikator Baterai** · *Lapisan 5* · Battery status and power profiles. · Implementasi: UPower DBus integration. · Prasyarat: upower events & thresholds.

104. **Privacy Settings UI** · *Lapisan 5* · Central settings for camera/microphone permissions. · Implementasi: portal + settings daemon. · Prasyarat: xdg-portal hooks & polkit checks.

105. **Screen Recording Controls** · *Lapisan 5* · Start/stop screen recording with consent. · Implementasi: xdg-desktop-portal + PipeWire. · Prasyarat: portal permissions & storage.

106. **Screencast Indicator** · *Lapisan 5* · Visual cue when screen capture is active. · Implementasi: shell overlay & portal events. · Prasyarat: secure attention & prompt.

107. **Session Indicators (User presence)** · *Lapisan 5* · Show online/away/do-not-disturb status. · Implementasi: presence DBus or telephony integration. · Prasyarat: presence protocol.

108. **Calendar Integration** · *Lapisan 5* · Quick access to calendar events from panel. · Implementasi: online-accounts & calendar APIs. · Prasyarat: oauth tokens & privacy.

109. **Online Accounts Integration** · *Lapisan 5* · Central management of cloud accounts (GNOME Online Accounts). · Implementasi: system service + settings UI. · Prasyarat: OAuth flows & token storage.

110. **Power Profiles / Mode Daya** · *Lapisan 5* · Quick-switch power plans (performance/balanced/power-saver). · Implementasi: settings-daemon + logind/power API. · Prasyarat: profiles + governor control.

111. **Night Light / Night Mode** · *Lapisan 5* · Color temperature adjustment scheduled to reduce eye strain. · Implementasi: gamma control / color management. · Prasyarat: wp_presentation & gamma API.

112. **Color Profiles UI** · *Lapisan 5* · Assign ICC profiles per monitor. · Implementasi: colord + settings front-end. · Prasyarat: color management libs.

113. **Accessibility Shortcuts** · *Lapisan 5* · One-tap toggles for accessibility features. · Implementasi: settings toggles + shell keys. · Prasyarat: mapping & discoverability.

114. **Onboarding / First-run Experience** · *Lapisan 5* · Guided setup for new users (language, privacy, accounts). · Implementasi: wizard app + persistent flags. · Prasyarat: flow design & localization.

115. **Tour / Help UI** · *Lapisan 5* · Interactive help tour for shell features. · Implementasi: HTML/JS or toolkit app. · Prasyarat: content & tracking.

116. **Search Index Privacy** · *Lapisan 5* · Controls what data launcher indexes (local vs cloud). · Implementasi: indexer config & opt-in. · Prasyarat: privacy policy & opt-out.

117. **Shell Accessibility Notifications** · *Lapisan 5* · Inform users about accessibility changes with a11y feedback. · Implementasi: screen reader messages & UI cues. · Prasyarat: a11y policy.

118. **Shell Crash Recovery / Safe Mode** · *Lapisan 5* · Fallback UI when shell crashes frequently. · Implementasi: watchdog & safe-mode greeter. · Prasyarat: crash detection & telemetry opt-in.

119. **Extension Sandbox / Permission Model** · *Lapisan 5* · Security model for third-party extensions. · Implementasi: capability lists & prompts. · Prasyarat: manifest schema & runtime enforcement.

120. **Widget Theming API** · *Lapisan 5* · API for styling panel widgets programmatically. · Implementasi: CSS-like or style objects. · Prasyarat: stable API & versioning.

121. **Panel Autohide Zones** · *Lapisan 5* · Configurable sensitive areas that trigger hidden panels. · Implementasi: pointer edge detection. · Prasyarat: debounce and latency tuning.

122. **Panel Transparency / Blur** · *Lapisan 5* · Visual effects for panels (translucent, blur). · Implementasi: shader blur passes. · Prasyarat: GPU support & performance checks.

123. **Launcher Plugins** · *Lapisan 5* · Extensions to provide custom result types (calculations, scripts). · Implementasi: plugin API. · Prasyarat: security & sandbox.

124. **Shell Actions / Action Dispatcher** · *Lapisan 5* · Central dispatcher for shell commands (open, pin, close). · Implementasi: D-Bus + command registry. · Prasyarat: access control.

125. **User Profiles & Multiple Configs** · *Lapisan 5* · Support storing multiple user shell configurations. · Implementasi: profile manager. · Prasyarat: serialization & UI.

126. **Remote Control API / Remote Management** · *Lapisan 5* · Remote control for Kiosk or admin tasks. · Implementasi: secured DBus endpoints. · Prasyarat: auth & network restrictions.

127. **Shell Localization / i18n** · *Lapisan 5* · Translation strings for shell UI. · Implementasi: gettext. · Prasyarat: translation workflow.

128. **RTL Support / Mirroring** · *Lapisan 5* · Right-to-left layout handling for UI. · Implementasi: toolkit + shell mirroring. · Prasyarat: direction metadata.

129. **Shell Performance Metrics** · *Lapisan 5* · Internal metrics (frame time, jank) exposed to devtools. · Implementasi: telemetry counters. · Prasyarat: low-overhead instrumentation.

130. **Shell Debug Mode / Developer Tools** · *Lapisan 5* · Tools for inspecting shell UI (element inspector). · Implementasi: devtools UI (GNOME Inspector). · Prasyarat: debug hooks.

131. **Shell Plugin Marketplace Integration** · *Lapisan 5* · Discover/install extensions from central repo. · Implementasi: REST API + UI. · Prasyarat: packaging & review workflow.

132. **Shell Update Mechanism** · *Lapisan 5* · Rolling update for shell with safe rollback. · Implementasi: package manager integration & update hooks. · Prasyarat: atomic updates & versioning.

133. **Shell Telemetry Controls** · *Lapisan 5* · Allow user opt-in telemetry for crash/perf. · Implementasi: consent UI & uploader. · Prasyarat: privacy & data retention.

134. **Shell Accessibility Testing Tools** · *Lapisan 5* · Automated accessibility checks for shell elements. · Implementasi: test harness + AT-SPI checks. · Prasyarat: CI integration.

135. **Shell Crash Reporter / Bug Reporter** · *Lapisan 5* · UI to report shell crashes to developers. · Implementasi: integration with bug tracker & logs. · Prasyarat: user consent & anonymization.

136. **Multi-seat Shell Policies** · *Lapisan 5* · Rules when multiple users use same machine concurrently. · Implementasi: seat-aware UI & session switching. · Prasyarat: seat mapping & device ACLs.

137. **Screen Layout Editor / Pengatur Layout Layar** · *Lapisan 5* · Visual editor to arrange monitors and scaling. · Implementasi: UI + wl_output calls. · Prasyarat: output modes & save configs.

138. **Per-Output Wallpapers** · *Lapisan 5* · Support distinct wallpapers per monitor. · Implementasi: wallpaper manager. · Prasyarat: resource assignment.

139. **Panel Alignment Options** · *Lapisan 5* · Configure panels (top/bottom/left/right). · Implementasi: layout engine. · Prasyarat: responsive rearrange.

140. **Panel Multi-row Support** · *Lapisan 5* · Allow panels with multiple rows/columns. · Implementasi: flex layout code. · Prasyarat: reflow and performance.

141. **Window Grouping / Group Tabs** · *Lapisan 5* · Group related windows under a single task entry. · Implementasi: grouping heuristics. · Prasyarat: metadata (WM_CLASS, app_id).

142. **Tabbing UI for Windows** · *Lapisan 5* · Tabbed containers for multiple windows. · Implementasi: compositor/container features. · Prasyarat: container management & keyboard nav.

143. **Window Snap Assist / Layout Suggestions** · *Lapisan 5* · Suggest layouts when snapping windows. · Implementasi: UX heuristics & overlay. · Prasyarat: user testing & animation.

144. **Window Minimize/Restore Animations** · *Lapisan 5* · Smooth transitions for minimize/restore. · Implementasi: compositor calls & timeline. · Prasyarat: frame pacing.

145. **Workspace Isolation Policies** · *Lapisan 5* · Which resources/apps are isolated per workspace (notifications, audio). · Implementasi: rules engine. · Prasyarat: per-workspace namespaces.

146. **Window Rules Editor UI** · *Lapisan 5* · GUI to create/manage window rules. · Implementasi: toolkit app & rule serialization. · Prasyarat: matching language.

147. **App Indicators API for Apps** · *Lapisan 5* · API for apps to expose indicators (music player, updates). · Implementasi: StatusNotifier DBus. · Prasyarat: spec compliance.

148. **Session Analytics (local) / UX Metrics** · *Lapisan 5* · Aggregate local UX metrics for debugging (opt-in). · Implementasi: local store. · Prasyarat: user consent.

149. **Shell Theming Previewer** · *Lapisan 5* · Live preview when editing themes. · Implementasi: sandboxed renderer. · Prasyarat: hot reload support.

150. **Widget Layout Constraints** · *Lapisan 5* · Rules (min/max/preferred) for panel widgets. · Implementasi: layout manager. · Prasyarat: measurement & negotiation.

151. **Panel Hotplug Behavior** · *Lapisan 5* · How panels adapt when outputs connect/disconnect. · Implementasi: output hooks. · Prasyarat: persistent state.

152. **Shell Accessibility Keyboard Nav** · *Lapisan 5* · Full keyboard navigation of shell UI. · Implementasi: focus chain & shortcuts. · Prasyarat: ARIA-like semantics.

153. **Launch Feedback (busy indicator)** · *Lapisan 5* · Visual feedback when app launching is in progress. · Implementasi: launcher state machine. · Prasyarat: app launch monitoring.

154. **App Actions / Quick Actions** · *Lapisan 5* · Contextual menu actions for tasks from dock/taskbar. · Implementasi: desktop file actions. · Prasyarat: .desktop Actions entries.

155. **Context Menus / Menu Konteks** · *Lapisan 5* · Right-click menus for UI elements. · Implementasi: toolkit menu system. · Prasyarat: action mapping.

156. **Shell Autocomplete for Commands** · *Lapisan 5* · Shell-provided autocomplete in launchers. · Implementasi: indexer + matching engine. · Prasyarat: command metadata.

157. **App Permissions UI** · *Lapisan 5* · Manage app permissions (camera, mic) at shell level. · Implementasi: portal + settings UI. · Prasyarat: portal mapping & DBus.

158. **Session Indicators for Accessibility** · *Lapisan 5* · Visual cues for speech/screenreader activities. · Implementasi: accessibility events. · Prasyarat: AT-SPI instrumentation.

159. **Shell-wide Localization Switch** · *Lapisan 5* · Change UI language on-the-fly or on login. · Implementasi: i18n reload + session restart. · Prasyarat: gettext & resource reload.

160. **Shell Update Notifications** · *Lapisan 5* · Notify user about shell updates / restart recommendations. · Implementasi: package manager hooks. · Prasyarat: update metadata & scheduling.

161. **Shell Backup/Export Settings** · *Lapisan 5* · Export/import shell configuration bundles. · Implementasi: archive exporter. · Prasyarat: versioning & restore logic.

162. **Custom Widgets / User Widgets** · *Lapisan 5* · Allow users to add custom HTML/JS or widget modules. · Implementasi: plugin host. · Prasyarat: sandbox & API.

163. **Window Accent Color / Theming Hooks** · *Lapisan 5* · Accent color applied across shell chrome. · Implementasi: theme variables. · Prasyarat: theme re-evaluation.

164. **Shell Shortcuts Discovery UI** · *Lapisan 5* · Show available shortcuts and conflicts. · Implementasi: keybinding registry UI. · Prasyarat: full keymap introspection.

165. **Shell Keyboard Layout Indicator** · *Lapisan 5* · Indicate and switch keyboard layouts from panel. · Implementasi: setxkbmap / libxkbcommon integrations. · Prasyarat: layout lists & switching API.

166. **IME / Input Method Integration** · *Lapisan 5* · Show IME state, candidate windows from shell. · Implementasi: text-input protocol + panel UI. · Prasyarat: IMF protocol support.

167. **Session-wide Menus / Global Menus** · *Lapisan 5* · Menus that can move to panel (global menu). · Implementasi: DBus menu spec / app exporter. · Prasyarat: app support & menu exporter.

168. **Window Transparency Controls** · *Lapisan 5* · Per-window opacity slider in shell. · Implementasi: compositor opacity property. · Prasyarat: compositor support.

169. **Screenshot Tool Integration** · *Lapisan 5* · Shell-level screenshot UI (region, window, full). · Implementasi: screencap + file chooser. · Prasyarat: portal or compositor hooks.

170. **Shell Clipboard History** · *Lapisan 5* · Keep clipboard history accessible from panel. · Implementasi: clipboard manager + UI. · Prasyarat: clipboard ownership & persistence.

171. **Shell Password Prompt UI** · *Lapisan 5* · Secure prompt for password actions (polkit). · Implementasi: polkit agent integration. · Prasyarat: secure input & no logging.

172. **Shell Consent Prompts** · *Lapisan 5* · User consent flow for privileged actions (screen sharing). · Implementasi: portal confirm dialog. · Prasyarat: portal + policy.

173. **Shell Developer Mode** · *Lapisan 5* · Enable verbose logs, debug hooks for extension dev. · Implementasi: flag toggles & non-production UI. · Prasyarat: security cautions.

174. **Shell Theme Packager** · *Lapisan 5* · Tool to pack & distribute themes/extensions. · Implementasi: CLI + metadata schema. · Prasyarat: packaging spec.

175. **Shell Accessibility Onboarding** · *Lapisan 5* · Guided accessibility setup for new users. · Implementasi: onboarding UI & settings integration. · Prasyarat: accessible defaults.

176. **Shell Feedback Reporter** · *Lapisan 5* · Send feedback or logs to maintainers (opt-in). · Implementasi: uploader & log collector. · Prasyarat: user consent & sanitization.

177. **Shell Diagnostic Tools** · *Lapisan 5* · Built-in diagnostics (rendering, input latency). · Implementasi: sampling tools & traces. · Prasyarat: low-overhead telemetry.

178. **Panel Overflow Handling** · *Lapisan 5* · How panel handles too many widgets (overflow menus). · Implementasi: responsive layout & overflow UI. · Prasyarat: measurement & collapse logic.

179. **Window Accessibility Hints** · *Lapisan 5* · Shell-provided hints for apps lacking a11y info. · Implementasi: fallback semantic overlays. · Prasyarat: heuristics & opt-out.

180. **App Quicklists / Contextual Shortcuts** · *Lapisan 5* · Right-click quick actions for dock icons. · Implementasi: desktop file Actions integration. · Prasyarat: actions metadata.

181. **Panel Locking / Edit Mode** · *Lapisan 5* · Mode to rearrange panels/widgets safely. · Implementasi: edit UI & commit/apply. · Prasyarat: transactional config apply.

182. **Shell Runtime Plugins (hotload)** · *Lapisan 5* · Hot-loadable plugins for development. · Implementasi: dynamic module loader. · Prasyarat: stable plugin API.

183. **Panel Accessibility Navigation** · *Lapisan 5* · Keyboard navigation inside panel elements. · Implementasi: focus chain & aria-like roles. · Prasyarat: accessibility mapping.

184. **Window Thumbnails as Live Previews** · *Lapisan 5* · Live updating thumbnails for task switchers. · Implementasi: compositor dmabuf snapshots. · Prasyarat: compositor snapshot API.

185. **Audio Output Switching UI** · *Lapisan 5* · Quick switch between sinks (speakers/headphones). · Implementasi: PulseAudio/PipeWire DBus. · Prasyarat: audio server APIs.

186. **Per-app Volume Controls** · *Lapisan 5* · Mute/adjust volume per application. · Implementasi: PipeWire or PulseAudio APIs. · Prasyarat: stream routing & mapping.

187. **Session Idle & Inactivity UI** · *Lapisan 5* · Visual warnings before suspend/lock. · Implementasi: timers & dialogs. · Prasyarat: logind inhibitors check.

188. **Shell Autosave Settings** · *Lapisan 5* · Periodically autosave user shell state. · Implementasi: background save tasks. · Prasyarat: atomic writes & recovery.

189. **Shell Integration Testing Harness** · *Lapisan 5* · Automated tests for shell UI flows. · Implementasi: headless test runner + snapshots. · Prasyarat: reproducible UI states.

190. **Shell Accessibility Logging** · *Lapisan 5* · Logs specialized for accessibility debugging. · Implementasi: augmented logs & secure collection. · Prasyarat: user consent & privacy.

191. **Panel Theming API Stability Guarantees** · *Lapisan 5* · Versioned theme API to avoid breakages. · Implementasi: semver & API docs. · Prasyarat: contract testing.

192. **Window Layer Manipulation API** · *Lapisan 5* · Programmatic control of z-order and layers. · Implementasi: shell D-Bus or extension API. · Prasyarat: compositor permissions.

193. **Workspace Isolation for Security** · *Lapisan 5* · Policies to isolate sensitive apps to specific workspace. · Implementasi: rule enforcement. · Prasyarat: per-workspace policy engine.

194. **Shell Integration with Notifications Actions** · *Lapisan 5* · Trigger actions directly from notification buttons. · Implementasi: notification spec actions. · Prasyarat: action handlers & permissions.

195. **Panel Performance Budgeting** · *Lapisan 5* · Limit per-widget CPU/GPU usage to maintain shell framerate. · Implementasi: watchdog & throttling. · Prasyarat: resource monitors.

196. **Shell Multi-profile Sync** · *Lapisan 5* · Sync shell settings across devices/accounts. · Implementasi: cloud sync service (opt-in). · Prasyarat: auth & conflict resolution.

197. **Shell Theme Inheritance** · *Lapisan 5* · Themes can inherit base theme and override parts. · Implementasi: css vars & includes. · Prasyarat: theme resolver.

198. **Panel Accessibility Contrast Checker** · *Lapisan 5* · Tool to validate color contrast in panel UI. · Implementasi: accessibility rules engine. · Prasyarat: color metrics & UI scanner.

199. **Panel Gesture Targets / Touch Targets** · *Lapisan 5* · Ensure widgets meet minimal touch size. · Implementasi: layout constraints. · Prasyarat: accessibility guidelines.

200. **Developer Checklist to Modify or Extend Shell Components** · *Lapisan 5* · Ringkasan: pelajari bahasa implementasi (JS/C++/Rust), setup build env (meson/cmake/gn), pahami compositor protocol (Wayland/X11), pelajari extension API, test headless & profiling tools, dan sertakan accessibility & security review. · Prasyarat: contributor workflow, testing infra, knowledge of D-Bus/polkit/logind.

---

<!--
Selesai — **200 istilah Lapisan 5** telah saya susun lengkap dengan identitas implementasi singkat dan prasyarat pengembangan.
Jika Anda ingin, saya dapat:

* Mengeluarkan subset yang difokuskan (mis. semua istilah panel dan applet dengan contoh implementasi plugin),
* Menyusun checklist langkah-demi-langkah untuk menambah applet atau plugin pada shell tertentu (mis. menulis applet untuk Swaybar atau extension untuk GNOME Shell), atau
* Memperluas entri spesifik menjadi panduan praktis (file sumber, lokasi repo, perintah build, patch contoh).

Mana yang Anda inginkan selanjutnya?

<details>
  <summary>📃 Daftar Isi</summary>

</details>

#

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
-->

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

----------------------------------------------->

[0]: ../README.md
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
