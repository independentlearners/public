# Lapisan 6 — Session, Policy & System Integration (1–150)
<!--
Bagus — saya lanjutkan dengan **Lapisan 6 — Session, Policy & System Integration**.
-->
Di bawah ini Anda akan menemukan **daftar istilah terperinci (150 entri)** yang mencakup login, PAM, systemd, polkit, D-Bus, manajemen sesi, greeter, policy, inhibitions, seat/session concepts, portal, dan aspek integrasi sistem lain yang berkaitan dengan pengalaman desktop.

---

Sebelum daftar istilah: ringkasan **identitas teknis & prasyarat pengembangan** untuk lapisan ini (mengenai identitas teknologi dan apa yang perlu dipelajari bila ingin memodifikasi/kontribusi).

### Identitas teknis & prasyarat singkat (Lapisan 6)

* Implementasi umum: **C** adalah bahasa dominan untuk komponen inti (systemd, polkit, dbus-daemon, PAM modules); **C++** digunakan pada beberapa display manager (SDDM), beberapa komponen daemon/tooling bisa menggunakan **Python**, **Rust**, atau **Go**.
* Build systems & repositori: `meson`/`ninja`, `cmake`, autotools; sumber resmi (systemd on GitHub, polkit GitLab, dbus on freedesktop).
* Protokol & API: **D-Bus** (message bus), systemd D-Bus API (`org.freedesktop.login1`), Polkit APIs.
* Tooling & debugging: `journalctl`, `loginctl`, `busctl`, `dbus-monitor`, `polkit-agent-test`, `strace`, `gdb`, `systemd-analyze`, `pamtester`.
* Keahlian yang disarankan untuk memodifikasi: bahasa C, pemahaman POSIX (uids/gids, PAM hooks), D-Bus introspection, systemd unit/targets, cgroups & namespaces, udev rules, Linux session security, serta testing lingkungan (systemd --user, container/machinectl).

Daftar istilah — tiap baris: **Istilah (EN / ID)** · **Deskripsi singkat** · **(Implementasi utama — Prasyarat singkat untuk modifikasi)**.

---


1. **Login (Proses Masuk)** · Proses autentikasi pengguna untuk membuat sesi desktop/login shell. (Implementasi: utilitas shell/getty/GDM/SSHD — Prasyarat: PAM, auth backends)
2. **PAM (Pluggable Authentication Modules) / Modul Autentikasi** · Kerangka kerja extensible untuk autentikasi dan manajemen sesi pada login. (C — menulis modul PAM)
3. **/etc/pam.d/** · Direktori konfigurasi PAM per layanan (gdm, login, sshd). (Konfigurasi teks — paham stack PAM)
4. **pam_unix** · Modul PAM standar untuk autentikasi berbasis `/etc/shadow`. (C — debugging pam_unix)
5. **pam_sss / pam_ldap / pam_krb5** · Modul PAM untuk integrasi SSSD/LDAP/Kerberos. (C — setup directory/kerberos)
6. **pam_systemd** · Modul PAM yang mengikat sesi ke systemd user scope dan membuat XDG_RUNTIME_DIR. (C/systemd — memahami systemd --user)
7. **pam_env** · Mengatur environment variables dari konfigurasi pada saat login. (C — aturan env)
8. **pam_exec** · Menjalankan program eksternal sebagai hook PAM (contoh: mount home). (C — aman mengeksekusi hook)
9. **getty / agetty** · Program yang menyediakan login prompt pada virtual terminal (tty). (C — konfig udev/getty@.service)
10. **sshd / Remote Login** · Daemon SSH yang mengautentikasi pengguna jarak jauh (membuat sesi shell atau X forwarding). (C — integrasi PAM/authorized_keys)
11. **Display Manager (DM) / Greeter** · Aplikasi yang menyajikan layar login grafis (GDM, SDDM, LightDM). (C/C++/Python — greeter theming, PAM)
12. **GDM (GNOME Display Manager)** · DM untuk GNOME; integrasi systemd-logind, Wayland/X session. (C — GNOME stack)
13. **LightDM** · DM yang ringan dan templatable (greeter modular). (C++/Python — greeter plugin)
14. **SDDM** · Simple Desktop Display Manager (Qt-based) untuk KDE/Wayland/X11. (C++/Qt — theme/QML)
15. **Xsession / xinitrc / .xsession** · Skrip startup sesi X11 yang mengeksekusi window manager / desktop environment. (Shell scripts — debugging session start)
16. **XDG Session (XDG specs)** · Standar freedesktop untuk file `.desktop` autostart, session env, dan user directories. (Spec docs)
17. **XDG_RUNTIME_DIR** · Direktori runtime per-user yang diproduksi pam_systemd; menyimpan socket Wayland, DBus session, dll. (Filesystem env)
18. **XDG_SESSION_TYPE** · Environment var yang menentukan `wayland` atau `x11` untuk sesi. (Env var)
19. **XDG_CURRENT_DESKTOP** · Menyatakan DE aktif (GNOME, KDE, etc.) untuk apps. (Env var)
20. **systemd** · Init system dan service manager modern yang juga mengelola user sessions (system & user units). (C — read systemd code & unit format)
21. **systemd-logind** · Service systemd yang mengelola seat, session, login/logout, inhibit, dan power actions via D-Bus (`org.freedesktop.login1`). (C — D-Bus API)
22. **loginctl** · CLI untuk berinteraksi dengan systemd-logind (lihat session, seats, users). (C — tooling)
23. **org.freedesktop.login1.Manager** · API D-Bus untuk mengontrol sesi, suspend, shutdown, dan seat. (D-Bus introspection)
24. **Session (Systemd Login Session)** · Entitas per-login yang direpresentasikan systemd-logind; memiliki ID, user, seat, dan cgroup. (concept + dbus object)
25. **Seat (Seat Management)** · Abstraksi kelompok perangkat input/output (seat0) — dikelola oleh logind/udev. (udev rules + logind)
26. **user.slice / session.slice** · Unit systemd yang membatasi resource (cgroups) untuk user/session. (systemd unit & cgroups)
27. **cgroups (Control Groups)** · Mekanisme kernel untuk mengelola resource accounting/isolation per session/service. (kernel + systemd integration)
28. **Lingering (systemd user linger)** · Fitur `loginctl enable-linger` untuk menjaga service `--user` berjalan walau user tidak login. (systemd user units)
29. **systemd --user** · Instance systemd yang berjalan per user untuk mengelola unit user (user services, timers). (unit files di ~/.config/systemd/user)
30. **user services (unit types: service, socket, scope, timer)** · Unit systemd yang berjalan di user instance untuk background tasks. (unit authoring)
31. **scope unit** · Unit transient yang mengelola proses yang dibuat di luar systemd (mis. sesi login). (systemd-run / loginctl)
32. **systemd-user session target** · Target yang mengelola runlevel pengguna (desktop session lifecycle). (unit targets)
33. **autostart (.desktop in ~/.config/autostart)** · Mekanisme autostart aplikasidi sesi desktop (XDG Autostart spec). (desktop file spec)
34. **XDG Autostart OnlyShowIn / NotShowIn** · Atribut `.desktop` untuk menyesuaikan autostart berdasarkan DE. (desktop file fields)
35. **DBus (D-Bus Message Bus)** · Sistem IPC pesan yang digunakan luas di desktop Linux untuk event & method call. (C libraries libdbus/libsystemd/dbus-broker)
36. **system bus vs session bus** · Dua bus D-Bus: system-wide (daemons) dan session (per-user apps). (dbus-daemon/msgr)
37. **dbus-daemon / dbus-broker / sd-bus** · Implementasi message bus: classic `dbus-daemon`, modern `dbus-broker`, dan `systemd`'s sd-bus API. (C)
38. **DBus activation** · Mekanisme memulai service on-demand ketika message diterima pada bus. (service files & unit integration)
39. **busctl / gdbus / dbus-send / dbus-monitor** · Alat debugging dan interaksi D-Bus. (tooling)
40. **Session Bus Address (DBUS_SESSION_BUS_ADDRESS)** · Environment var yang menunjuk ke socket session bus. (env + XDG_RUNTIME_DIR)
41. **Polkit (PolicyKit)** · Sistem otorisasi untuk melakukan tindakan terprivileg (e.g., mounting drive, shutdown). (C — polkitd)
42. **polkitd (PolicyKit daemon)** · Daemon central yang menangani authorization & agent negotiation. (C)
43. **polkit agent / authentication agent** · Program GUI yang meminta credential (PIN/password) saat polkit memerlukan autentikasi (mis. polkit-gnome). (C/GLib)
44. **pkaction / pkcheck / pkexec** · Utilitas untuk mengecek hak akses (pkcheck), menjalankan proses dengan privilege (pkexec). (C)
45. **PolicyKit actions (.policy files)** · Deskripsi tindakan yang butuh otorisasi beserta deskripsi & defaults. (XML files packaged with apps)
46. **PolicyKit rules (JavaScript rules)** · Skrip Rule di /etc/polkit-1/rules.d untuk menyesuaikan kebijakan otorisasi. (JS + polkit API)
47. **authorization / implicit vs explicit grant** · Perbedaan pemberian izin otomatis (trusted) vs memerlukan autentikasi. (polkit semantics)
48. **polkit Authentication Agent Desktop Integration** · Mekanisme agar greeter/DE menjalankan agent untuk prompt kredensial. (greeter + session startup)
49. **consolekit / elogind** · Older session managers (ConsoleKit) dan fork `elogind` untuk distribusi tanpa systemd. (C — alternatif)
50. **seat policies (seat0 privileges)** · Kebijakan yang mengatur siapa dapat mengambil kontrol seat (local user vs remote). (udev + logind + polkit)
51. **Inhibitor Locks (logind inhibitors)** · API untuk mencegah suspend/shutdown/sleep sementara aplikasi butuh (e.g., media player). (logind D-Bus Inhibit)
52. **Inhibit types (sleep, shutdown, handle-lid-switch)** · Jenis inhibitor yang dapat di-request oleh aplikasi. (login1.Manager Inhibit)
53. **systemd-suspend / systemd-hibernate** · Unit/target yang mengelola suspend/hibernate; dipanggil lewat logind. (systemd unit files)
54. **Handle LID Switch** · Behaviour pengelolaan penutup laptop (logind setting HandleLidSwitch). (logind.conf)
55. **Power management integration (upower, logind)** · Komponen yang mengatur battery/power events dan notifikasi. (C/DBus)
56. **upower / UPower daemon** · Daemon untuk informasi baterai dan power source di desktop. (C)
57. **Console / virtual terminal management (vt)** · Management VT switching, ownership oleh X/Wayland compositors. (kernel + logind)
58. **session termination / KillUserProcesses** · Kebijakan apakah proses user harus dibunuh saat logout (KillUserProcesses setting). (systemd)
59. **XDG Desktop Portals** · Abstraksi aman (portals) untuk sandboxed apps mengakses file, screencast, notifications. (xdg-desktop-portal C/GLib)
60. **xdg-desktop-portal / portal backends (gtk/kde/wlr)** · Daemon portal yang menerjemahkan permintaan sandbox ke aksi host. (C/GLib/DBus)
61. **File chooser portal** · Portal untuk open/save dialog terkontrol bagi aplikasi sandboxed. (xdg portal API)
62. **Screen capture / Screencast portal** · Portal untuk memberikan akses screencast/screenrecording dengan user consent. (dbus + pipewire)
63. **PipeWire integration (screencast/media)** · PipeWire sering digunakan sebagai backend untuk portals (capture/audio). (C, PipeWire API)
64. **Flatpak / Snap / AppImage integration** · Model packaging sandboxed apps yang memanfaatkan portals untuk akses host. (portals + packaging)
65. **Session Bus Activation for Services** · Menjalankan service user via D-Bus activation saat dibutuhkan. (dbus service files)
66. **Autologin (display manager/systemd)** · Konfigurasi login otomatis untuk user tertentu (GDM/Systemd). (greeter config/systemd service)
67. **Seat-aware udev rules** · udev rules yang menandai perangkat ke seat tertentu (ID_SEAT). (udev syntax)
68. **Device ACLs (logind ACLs)** · Akses perangkat (e.g., /dev/input) yang diberikan ke sesi aktif oleh logind. (udev + logind)
69. **Xauthority / .Xauthority** · File otentikasi untuk X11 clients (cookie) — relevan bila XWayland/X11 dipakai. (xauth tooling)
70. **XDG_RUNTIME_SOCKET permissions** · Hak akses socket runtime (wayland, dbus) berada di XDG_RUNTIME_DIR. (umask & pam_systemd)
71. **Seat Takeover / Remote login implications** · Kebijakan keamanan saat multiple input sources atau remote sessions. (polkit rules + seat policies)
72. **Multi-seat configuration** · Setup beberapa seat fisik pada satu mesin (multiple keyboards/monitors) dengan logind. (udev + logind configs)
73. **Graphical Session vs Non-graphical Session** · Perbedaan session X/Wayland desktop dan pure shell session (TTY/ssh). (session types)
74. **Session Type (x11, wayland, tty, remote)** · Menyatakan tipe sesi untuk aplikasi (XDG_SESSION_TYPE). (env & greeter)
75. **Session Manager (DE session)** · Komponen yang mengelola startup/shutdown aplikasi user pada sesi desktop (gnome-session, kde-session). (C/C++/GLib)
76. **gnome-session / KDE session manager** · Implementasi session managers yang restore apps and handle logout. (C/Qt)
77. **Session Save/Restore (session management protocol)** · Mekanisme menyimpan dan mengembalikan keadaan aplikasi pada logout/login. (DE-specific)
78. **Wayland/Wayland-native greeter policy** · Bagaimana greeter berjalan di Wayland dan berinteraksi dengan logind/seat. (wayland greeter design)
79. **XDG Autostart OnlyShowIn/NotShowIn** · Aturan autostart berbasis desktop type; menghindari autostart pada greeter. (desktop file)
80. **Session Environment (env vars)** · Set var penting (PATH, DISPLAY, DBUS_SESSION_BUS_ADDRESS) yang didefinisikan saat login. (pam_env/pam_systemd)
81. **Environment propagation to systemd-user services** · Cara variabel env diteruskan ke unit user. (systemd --user, EnvironmentFile)
82. **Session Lock / Screen Locker** · Komponen yang mengunci layar (swaylock, gnome-screensaver) dan integrasi inhibitor. (C/command-line)
83. **Authentication Agent / Unlock agent** · Agen yang menerima prompt autentikasi saat unlock atau policy prompts. (polkit agent/greeter component)
84. **Lockscreen inhibition / Inhibitors interplay** · Bagaimana screenlock dan inhibitors (logind/polkit) bekerja bersama. (logind Inhibit API)
85. **Seat-based Device Access (active session ownership)** · Perangkat hanya dapat diakses oleh sesi aktif yang memiliki seat. (logind + udev)
86. **Power Key / Sleep Button handling** · Mapping key events ke action suspend/shutdown via logind/polkit. (systemd/logind config)
87. **HandleLidSwitchDocked / Lid behaviour overrides** · Konfigurasi logind untuk perilaku saat lid ditutup dalam mode docking. (logind.conf)
88. **Active Session vs Background Session** · Sesi yang berinteraksi dengan user (active) versus background daemon sessions. (loginctl status)
89. **Session cgroups & resource limits** · Pembatasan resource via cgroups untuk user/session (MemoryMax, CPUQuota). (systemd unit directives)
90. **KillMode & KillUserProcesses** · Kebijakan systemd untuk menutup proses saat unit berhenti/logout. (systemd unit)
91. **Sudo vs Polkit vs Policy decisions** · Perbedaan penggunaan pkexec/pkcheck vs sudo untuk privilege escalation. (security models)
92. **Credential caching & timeout** · Mekanisme menyimpan grant sementara (polkit authentication caching). (polkit config)
93. **Agentless authentication flows** · Cara fallback jika tidak ada polkit agent tersedia (deny/console fallback). (polkit semantics)
94. **Privilege separation (UID/GID switching)** · Teknik menjalankan helper dengan UID root dari proses non-privileged (pkexec, systemd-run). (setuid, polkit)
95. **systemd-user lingering security implications** · Risks when enabling linger (background user services remain). (security considerations)
96. **XDG Session autostart ordering / `OnlyShowIn`/`NotShowIn`** · Pengurutan dan seleksi autostart apps saat sesi dimulai. (desktop spec)
97. **Desktop notifications & Notification daemon (freedesktop)** · Integrasi notif center via D-Bus (Notifications spec). (libnotify, daemon)
98. **Notification authorization / Focus stealing policies** · Kebijakan yang mencegah notifikasi mencuri fokus. (DE/WM policy)
99. **User switching (fast user switch)** · Mekanisme beralih antar sesi user tanpa logout (greeter + seat switching). (logind + DM support)
100. **Remote sessions & X forwarding (ssh -X/-Y)** · Cara aplikasi remote menampilkan GUI lokal via SSH/X11 forwarding. (sshd config + Xauth)
101. **Remote desktop & screen sharing (VNC/RDP/Wayland protocols)** · Implementasi remote access dan hubungannya dengan session ownership. (x11vnc, xrdp, waypipe, RDP backends)
102. **Display/login greeter theming & pluggable agents** · Mekanisme mengganti tampilan greeter dan agen authetication. (theme engines, QML/CSS)
103. **Login failure handling & lockouts (pam_tally2 / faillock)** · Mekanisme blocking login setelah sejumlah kegagalan. (pam modules)
104. **Password quality & cracklib (pam_cracklib/pam_pwquality)** · Aturan kekuatan password di PAM. (pam module config)
105. **Two-factor Auth / PAM OTP / Google Authenticator** · Integrasi 2FA via PAM modules. (security modules)
106. **SSO / Kerberos / pam_krb5** · Single Sign-On management di sistem enterprise. (Kerberos infra)
107. **Home directory mounting (pam_mount / systemd-homed)** · Otomatis mount home saat login; homed manajemen user. (pam modules / systemd-homed)
108. **systemd-homed** · systemd component to manage portable home directories and user records. (C, JSON user records)
109. **User records & portable home (homed)** · Konsep user accounts stored as files/images manageable by homed. (systemd-homed)
110. **Encrypted home integration (LUKS, ecryptfs)** · Pendekatan mengenkripsi home dan unlocking saat login. (cryptsetup, pam modules)
111. **Keyring integration (gnome-keyring, kwallet)** · Layanan menyimpan kredensial user yang di-unlock saat login. (C/C++)
112. **Automatic unlocking of keyrings (PAM hooks)** · Menghubungkan login process untuk unlock keyrings otomatis. (pam_gnome_keyring)
113. **Session-wide secrets handling (libsecret)** · API untuk menyimpan dan mengakses secrets per-session. (C library)
114. **Seat cockpit / display switching policy** · Konfigurasi terkait siapa dapat mengakses seat saat user aktif. (polkit + logind)
115. **DBus session activation for per-user daemons** · Menjalankan daemon user on-demand via D-Bus (ex: gnome-keyring). (dbus service files)
116. **XDG autostart vs systemd user units conflict resolution** · Bagaimana DE memilih antara autostart desktop files dan systemd user units. (session integration rules)
117. **Session cleanup hooks (Logout scripts)** · Skrip yang dijalankan pada logout untuk cleanup user state. (session manager hooks)
118. **Xauthority vs Wayland socket protection** · Perbedaan model otorisasi/akses antara X dan Wayland runtime. (cookie vs runtime dir)
119. **Seat hotplug & device assignment concurrency** · Race conditions when devices attach/detach and seat reassign. (udev & logind)
120. **Forensic/logging considerations (auditd/journalctl)** · Logging user session events for auditing (auth logs, journal). (audit & journald policies)

---

**121. systemd-run (transient units)** · Perintah untuk menjalankan proses sebagai *transient unit* systemd (scope/service) — berguna untuk menjalankan tugas terkait sesi dengan kontrol cgroup sementara. (Implementasi: systemd C — pelajari pembuatan transient unit & argumen `--user`/`--scope`.)

**122. machinectl / systemd-machined** · Alat & daemon untuk mengelola mesin kontainer/machines (container/VM lightweight) yang terkait dengan sesi; integrasi dengan user namespace. (Implementasi: systemd — pahami concept machine images dan transport.)

**123. User Namespaces & Rootless Containers** · Mekanisme isolasi identitas pengguna untuk menjalankan container tanpa root; relevan untuk sesi dan keamanan aplikasi sandboxed. (Implementasi: kernel + container runtimes — prasyarat: namespaces, subuid/subgid.)

**124. PAM Limits (pam_limits / /etc/security/limits.conf)** · Modul PAM yang menerapkan batas sumber daya (nofile, nproc) pada login/session. (Implementasi: PAM config — perlu paham limit tuning & implikasi cgroups.)

**125. pam_time** · Modul PAM untuk membatasi akses login berdasarkan waktu, hari, atau jam. (Implementasi: PAM — konfigurasi `/etc/security/time.conf`.)

**126. pam_faillock / faillock** · Modul modern untuk mengunci akun setelah kegagalan login berkali-kali (pengganti pam_tally2 di banyak distro). (Implementasi: PAM — pahami policy lockout dan pemulihan.)

**127. pam_lastlog / lastlog** · Modul untuk menampilkan informasi login terakhir dan mencatat aktivitas yang relevan pada saat login/logout. (Implementasi: PAM + lastlog DB.)

**128. pam_motd / Dynamic Message of the Day** · Menampilkan pesan/pemberitahuan saat login (mis. `/etc/motd`, pam_motd hooks). (Implementasi: PAM scripts — prasyarat: scripting dan keamanan pesan.)

**129. Auditd / audit subsystem** · Subsystem kernel & daemon pengguna untuk audit keamanan (login, sudo, polkit decisions). (Implementasi: auditd C — prasyarat: aturan audit, ausearch, ausevent parsing.)

**130. journald / Journal Policies** · systemd-journald yang merekam event sesi, autentikasi, dan daemon — termasuk rotasi dan hak akses. (Implementasi: systemd C — prasyarat: journalctl, forward-to-syslog configs.)

**131. SELinux / AppArmor Session Integration** · Pengaturan konteks keamanan LSM yang memengaruhi sesi pengguna (labeling, confinement). (Implementasi: kernel LSM + policy — prasyarat: menulis policy dan testing AVC/denials.)

**132. seat0 vs seatX semantics** · Konvensi penamaan seat (seat0 default) dan dampak kebijakan device assignment, greeter, dan multi-seat. (Implementasi: logind + udev — prasyarat: udev seat tagging.)

**133. Smartcard / PKCS#11 integration** · Dukungan smartcard/token (PKCS#11) untuk autentikasi login dan pemakaian kunci privat. (Implementasi: pcscd + libp11/pkcs11 — prasyarat: middleware & pam_pkcs11.)

**134. pam_pkcs11** · Modul PAM untuk autentikasi berbasis smartcard/PKCS#11. (Implementasi: C — prasyarat: konfigurasi PKCS#11 slots & certificates.)

**135. FIDO2 / U2F (libfido2, pam_u2f)** · Dukungan kunci keamanan FIDO2/U2F untuk autentikasi multifactor dalam login sesi. (Implementasi: libfido2 + pam_u2f — prasyarat: device registration & pam stack update.)

**136. fprintd / pam_fprintd** · Daemon dan modul PAM untuk autentikasi fingerprint biometrik. (Implementasi: C / D-Bus — prasyarat: driver HW, udev rules, fprint lib.)

**137. face-auth / biometric frameworks** · Frameworks eksperimental untuk autentikasi wajah yang berintegrasi ke PAM atau greeter. (Implementasi: perpustakaan C/C++ atau Python — prasyarat: model ML, privasi & fallback credentials.)

**138. SSH Agent & Key Forwarding (session integration)** · Menjalankan/menyambungkan ssh-agent ke session untuk forwarding kunci agar aplikasi grafis dapat menggunakan kredensial SSH. (Implementasi: eval `ssh-agent` di session startup / systemd user unit.)

**139. KRB5CCNAME / Kerberos ticket cache lifecycle** · Nama file/soket cache tiket Kerberos per sesi dan manajemen siklus hidup (kinit/kdestroy). (Implementasi: MIT/Heimdal Kerberos — prasyarat: kinit integrations di PAM/Kerberos realm.)

**140. SSSD (System Security Services Daemon)** · Layanan caching & integrasi identitas (LDAP/AD/Kerberos) untuk sesi pengguna. (Implementasi: C — pahami sssd.conf & nss/pam integration.)

**141. NSS / Name Service Switch (nsswitch.conf)** · Mekanisme lookup user/group (passwd, group) yang memengaruhi resolusi akun saat login. (Implementasi: glibc + NSS modules — prasyarat: nss module development/testing.)

**142. LDAP / Active Directory Session Integration** · Integrasi direktori pengguna sentral (LDAP/AD) untuk autentikasi dan autorisasi sesi. (Implementasi: sssd/sssd-ldap/pam_ldap — prasyarat: TLS, schema, Kerberos.)

**143. pam_ssh_agent_auth** · Modul PAM untuk mengautentikasi berdasarkan ketersediaan kunci di ssh-agent (key-based auth for local login). (Implementasi: PAM C module — prasyarat: ssh-agent socket visibility.)

**144. systemd-coredump / crash collection for session processes** · Pengumpulan core dump aplikasi pengguna yang crash dalam sesi untuk forensik. (Implementasi: systemd C — prasyarat: coredump config & storage policy.)

**145. Session Recording / audisp + audit plugins** · Mekanisme untuk merekam aktivitas sesi (audit plugins, shell recording) untuk kepatuhan. (Implementasi: auditd plugins, audisp — prasyarat: storage, privacy policy.)

**146. PolicyKit GUI agent fallback strategies** · Bagaimana greeter/DE menyediakan agent polkit saat tidak ada agent tersedia (console fallback, denial). (Implementasi: polkit agents — prasyarat: agent packaging & integration testing.)

**147. polkit implicit authorizations & granting lifetime** · Kebijakan berapa lama otorisasi yang diberikan berlaku (session-cached grants). (Implementasi: polkit rules — prasyarat: JS rules & policy tuning.)

**148. Encrypted Session Data (XDG_RUNTIME_DIR encryption attempts)** · Teknik untuk melindungi runtime sockets/data dalam XDG_RUNTIME_DIR (tmpfs perms, sticky bits). (Implementasi: pam_systemd + filesystem policy — prasyarat: umask & selinux contexts.)

**149. RTC Wake Alarms / rtcwake integration** · Mengatur alarm hardware RTC untuk wakeup (mis. schedule resume dan interaksi dengan login/power policies). (Implementasi: kernel RTC/sysfs + systemd timers — prasyarat: hw RTC & permissions.)

**150. Session Forensics & Retention Policies** · Kebijakan seberapa lama logs, audit trails, dan artifacts sesi disimpan untuk audit/forensic (retention, purge). (Implementasi: auditd/journald configs — prasyarat: compliance requirements & storage planning.)

---

<!-----
Semua istilah di atas sudah melengkapi **Lapisan 6** menjadi **150 entri** lengkap.

Saya akan melanjutkan ke **Lapisan 5: Desktop Shell & Core Components** sesuai urutan—mencakup panel, launcher, menu, workspace, applets, settings daemon, dan integrasi shell—untuk menyusun daftar istilah dan prasyarat yang sama rinci. Lanjutkan sekarang.
---


> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Home][domain]**
<!-----
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
------------------------------------------------>

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md


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
