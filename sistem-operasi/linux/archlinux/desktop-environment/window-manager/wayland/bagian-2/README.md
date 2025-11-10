<!--
Baik, kita lanjut ke **Lapisan 2: Display Server & Protocol Layer (1–40)** — bagian yang berada di atas kernel dan subsistem grafis.
Lapisan ini adalah tempat **X11** dan **Wayland** bekerja: mereka menjadi jembatan antara perangkat keras grafis dan aplikasi grafis di ruang pengguna. Semua interaksi antara aplikasi, jendela, pointer, dan monitor terjadi di sini.

---
-->

### **Lapisan 2 – Display Server & Architecture (1 – 200)**

**1. Display Server**
Peladen tampilan yang bertanggung jawab menyalurkan keluaran grafis dari aplikasi ke perangkat layar serta mengatur masukan pengguna seperti keyboard dan tetikus.

**2. Display Client**
Aplikasi pengguna yang berkomunikasi dengan peladen tampilan melalui protokol (X11 atau Wayland) untuk menggambar jendela dan menerima peristiwa (input event).

**3. Compositor**
Komponen yang menggabungkan (compose) beberapa permukaan grafis menjadi satu tampilan akhir; sering kali menjadi bagian dari peladen tampilan di Wayland.

**4. Display Protocol**
Spesifikasi komunikasi antara peladen tampilan dan klien (contohnya X11 Protocol atau Wayland Protocol).

**5. Display Server Architecture**
Struktur kerja sistem tampilan: di X11 berpusat pada X Server, sedangkan Wayland bersifat langsung antara klien dan compositor.

**6. Display Backend**
Lapisan di peladen tampilan yang berinteraksi langsung dengan kernel melalui DRM/KMS atau framebuffer untuk menampilkan gambar.

**7. Display Frontend**
Lapisan antarmuka yang melayani klien; menerima permintaan gambar, mengatur jendela, dan menangani input.

**8. Display Output**
Objek yang mewakili monitor fisik atau perangkat keluaran lainnya.

**9. Display Input**
Perangkat masukan (fisik) seperti keyboard, tetikus, touchpad, atau stylus yang dikendalikan melalui input subsystem.

**10. Rendering Loop**
Siklus pembaruan frame antara peladen tampilan dan GPU yang memastikan sinkronisasi gambar di layar.

**11. Frame Callback**
Mekanisme Wayland agar klien diberi tahu kapan frame sebelumnya selesai ditampilkan.

**12. Surface**
Objek dasar dalam sistem tampilan Wayland yang merepresentasikan area gambar (window, popup, dll).

**13. Buffer**
Memori tempat data frame disimpan sebelum dikirim ke GPU atau compositor.

**14. Output Mode**
Konfigurasi resolusi, refresh rate, dan warna monitor.

**15. Gamma Control**
Pengaturan kurva kecerahan warna untuk mengatur tampilan output.

**16. VSync (Vertical Synchronization)**
Teknik sinkronisasi render dengan penyegaran layar guna menghindari tearing.

**17. Page Flip**
Operasi mengganti buffer yang sedang aktif ke buffer baru dalam DRM/KMS.

**18. Frame Timing**
Interval waktu antar frame; memengaruhi smoothness tampilan.

**19. Hotplug Event**
Peristiwa sistem saat monitor atau perangkat input dihubungkan/dilepaskan.

**20. Seat**
Abstraksi sekumpulan perangkat input yang digunakan bersama pada satu sesi pengguna.

**21. Pointer Focus**
Permukaan yang menerima peristiwa dari mouse.

**22. Keyboard Focus**
Permukaan yang aktif menerima peristiwa keyboard.

**23. Touch Focus**
Permukaan yang menerima peristiwa sentuh (multi-touch).

**24. Idle Inhibit**
Permintaan dari klien untuk mencegah sistem memasuki mode tidur selama aktivitas tampilan berlangsung.

**25. Presentation Time**
Timestamp presisi tinggi yang menunjukkan kapan frame ditampilkan di layar.

**26. Compositing Pipeline**
Rangkaian tahapan rendering dalam compositor mulai dari pengambilan buffer hingga display output.

**27. Window Hierarchy**
Struktur relasi antar-jendela (parent, child, popup) yang dikelola oleh peladen tampilan.

**28. Window Mapping**
Proses menampilkan jendela pada output setelah klien mendaftarkan surface-nya.

**29. Window Unmapping**
Kebalikan dari mapping; menonaktifkan atau menyembunyikan jendela dari display server.

**30. Z-Order**
Urutan lapisan jendela di layar dari depan ke belakang.

**31. Damage Region**
Area surface yang berubah dan perlu repaint pada frame berikutnya.

**32. Repaint Loop**
Proses penggambaran ulang display berdasarkan damage region yang terjadwal.

**33. Swap Buffer**
Langkah akhir sebelum frame ditampilkan, menukar back buffer dengan front buffer.

**34. Input Dispatch**
Mekanisme penyaluran event input ke klien yang tepat berdasarkan focus.

**35. Event Loop**
Inti sistem asinkron yang menangani semua event masuk/keluar pada peladen tampilan.

**36. Wayland Event Queue**
Struktur data yang menyimpan peristiwa untuk dikirim ke klien Wayland.

**37. Protocol Object**
Entitas di Wayland yang mewakili interface protokol seperti wl_surface atau wl_output.

**38. Interface Binding**
Proses di mana klien mengaitkan diri pada interface protokol tertentu di peladen tampilan.

**39. Roundtrip**
Pertukaran pesan bolak-balik antara klien dan server untuk memastikan sinkronisasi.

**40. Shm (Shared Memory)**
Metode berbagi memori antar proses untuk efisiensi buffer grafis.

**41. EGL Context**
Lingkungan OpenGL ES yang digunakan klien untuk render ke surface di bawah Wayland atau X11.

**42. GLX (Gl Extension to X)**
Lapisan yang memungkinkan OpenGL berjalan di atas X Window System.

**43. DRI (Direct Rendering Infrastructure)**
Sistem pada X untuk memungkinkan klien melakukan render langsung ke GPU tanpa melalui server.

**44. Direct Rendering**
Proses menggambar langsung ke framebuffer tanpa compositor, lazim pada fullscreen game.

**45. Indirect Rendering**
Render yang melewati display server, biasanya lebih lambat namun lebih aman.

**46. Hardware Cursor**
Penunjuk mouse yang digambar langsung oleh GPU, bukan oleh software.

**47. Software Cursor**
Penunjuk mouse yang digambar oleh compositor melalui frame grafis.

**48. Output Transform**
Rotasi atau skala yang diterapkan pada output monitor (landscape, portrait, mirroring).

**49. Scaling Factor**
Nilai pengali untuk menyesuaikan DPI layar (HiDPI support).

**50. Multi-Monitor Layout**
Susunan beberapa display output dalam satu workspace virtual (extended atau mirrored).

---

#### Lapisan 2 ini membangun jembatan komunikasi antara **aplikasi pengguna** dan **kernel grafis**, menjadi fondasi bagi seluruh compositor modern seperti **Sway (Wayland)** atau **Mutter (GNOME)**. Berikutnya **Subbagian 2.2 – X11 System & Extensions (50 istilah)** yang mencakup seluruh terminologi penting dalam ekosistem **X Window System (X11)**. Bagian ini menjelaskan struktur internal X11, arsitekturnya, serta protokol dan ekstensi yang membentuk pondasi sistem tampilan klasik Unix dan Linux.

---

**51. X Window System (X11)**
Sistem tampilan grafis yang menggunakan model client–server, di mana *X Server* menangani tampilan dan input, sedangkan *X Client* adalah aplikasi yang meminta layanan grafis.

**52. X Server**
Proses utama yang mengatur tampilan layar, menerima input dari perangkat, serta menggambar window sesuai permintaan klien.

**53. X Client**
Aplikasi pengguna yang berkomunikasi dengan *X Server* melalui protokol X11, misalnya terminal emulator atau file manager.

**54. X Protocol**
Spesifikasi komunikasi biner antara klien dan server dalam X11; berbasis request, event, dan reply.

**55. X Display**
Abstraksi dari satu instance server tampilan; diakses oleh klien melalui variabel lingkungan `DISPLAY`.

**56. Display Number**
Nomor unik yang membedakan instance server X11, misal `:0`, `:1`.

**57. Screen Number**
Nomor layar fisik dalam satu instance display.

**58. Xlib**
Pustaka C tingkat tinggi untuk berinteraksi dengan X Server menggunakan protokol X11.

**59. XCB (X C Binding)**
Pustaka C tingkat rendah pengganti Xlib, dirancang lebih efisien dan asinkron.

**60. X.Org Server**
Implementasi terbuka paling populer dari X Server modern dalam distribusi Linux.

**61. MIT-SHM (Shared Memory Extension)**
Ekstensi X11 yang memungkinkan berbagi memori antara klien dan server untuk mempercepat rendering.

**62. XInput Extension**
Ekstensi yang memperluas dukungan input seperti multi-touch, tablet, dan stylus.

**63. XRandR (Resize and Rotate)**
Ekstensi untuk mengatur resolusi, rotasi, dan orientasi layar secara dinamis.

**64. XRender**
Ekstensi yang memperkenalkan rendering anti-alias dan alpha blending.

**65. XComposite**
Ekstensi yang memungkinkan compositor modern menampilkan window sebagai surface terpisah.

**66. XDamage**
Ekstensi untuk melacak area window yang berubah (damage region) agar compositor tahu kapan harus menggambar ulang.

**67. XFixes**
Ekstensi tambahan untuk mengelola kursor, region, dan seleksi clipboard secara efisien.

**68. XTest**
Ekstensi untuk menghasilkan event input buatan, seperti penekanan tombol virtual.

**69. XSync**
Ekstensi untuk sinkronisasi event asinkron di antara aplikasi X11.

**70. Xinerama**
Ekstensi lama yang mendukung konfigurasi multi-monitor sebelum XRandR diperkenalkan.

**71. Xv (X Video Extension)**
Ekstensi akselerasi video yang memungkinkan overlay hardware untuk pemutaran video.

**72. GLX (OpenGL Extension to X)**
Ekstensi untuk mengintegrasikan OpenGL ke dalam sistem X11.

**73. DRI (Direct Rendering Infrastructure)**
Mekanisme yang memungkinkan klien berinteraksi langsung dengan GPU di bawah X11.

**74. DRI2 / DRI3**
Versi lanjutan DRI dengan dukungan buffer sharing lebih baik dan sinkronisasi melalui PRIME.

**75. X Composite Manager**
Aplikasi yang menggunakan ekstensi XComposite untuk menggambar jendela dalam buffer off-screen (contohnya *compton*, *picom*).

**76. X Event**
Struktur data yang mewakili peristiwa input atau sistem seperti klik, fokus, atau expose.

**77. X Request**
Pesan yang dikirim klien ke server untuk melakukan operasi (membuka jendela, menggambar, dsb).

**78. X Reply**
Balasan dari server atas request tertentu dari klien.

**79. X Resource ID**
Identitas unik untuk setiap objek di X11 seperti window, pixmap, atau cursor.

**80. X Atom**
Identifier simbolik untuk string yang digunakan dalam komunikasi antar aplikasi (misalnya properti window).

**81. X Property**
Data yang disimpan dalam window, digunakan untuk menyimpan metadata (judul, tipe window, dsb).

**82. ICCCM (Inter-Client Communication Conventions Manual)**
Standar yang mengatur komunikasi antar aplikasi X11, seperti clipboard dan manajemen jendela.

**83. EWMH (Extended Window Manager Hints)**
Spesifikasi modern yang memperluas ICCCM untuk mendukung DE modern seperti GNOME dan KDE.

**84. X Selection**
Mekanisme clipboard dalam X11 yang mengatur transfer data antar klien.

**85. X Clipboard**
Buffer data sementara yang diakses melalui X Selection untuk salin-tempel.

**86. X Focus Event**
Peristiwa yang memberi tahu aplikasi bahwa window-nya kini aktif untuk menerima input.

**87. X Keymap**
Pemetaan antara tombol fisik dan simbol karakter dalam X11.

**88. X Cursor Theme**
Kumpulan ikon kursor yang digunakan oleh X Server untuk menggambar pointer.

**89. X Font Server (xfs)**
Peladen font terpisah yang melayani permintaan font X11 klasik.

**90. X Resource Database (Xresources)**
Sistem konfigurasi berbasis teks untuk aplikasi X11, diatur melalui file `.Xresources`.

**91. X Authority**
File otentikasi yang berisi cookie untuk mengizinkan klien terhubung ke server X.

**92. XDMCP (X Display Manager Control Protocol)**
Protokol untuk mengelola sesi login jarak jauh pada sistem X11.

**93. XDM (X Display Manager)**
Manajer tampilan klasik untuk login X11, pendahulu dari GDM, LightDM, dan lainnya.

**94. Xephyr**
Server X nested yang menjalankan instance X11 di dalam X11 lain, berguna untuk pengujian.

**95. Xvfb (X Virtual Framebuffer)**
Server X virtual tanpa tampilan fisik, digunakan untuk pengujian headless.

**96. Xnest**
Server X dalam X lain, mirip Xephyr tetapi lebih tua dan berbasis protokol berbeda.

**97. X Screen Saver Extension**
Ekstensi yang mengatur perilaku layar saat idle.

**98. X Accessibility Extension (XAccess)**
Ekstensi untuk mendukung fitur aksesibilitas seperti pembaca layar dan magnifier.

**99. X Window Manager**
Program yang mengatur posisi, ukuran, dan dekorasi jendela di atas X Server.

**100. X Session**
Sesi pengguna X11 lengkap, termasuk window manager, panel, dan aplikasi startup.

---

Berikutnya, Wayland Ecosystem & wlroots Components yang memuat istilah teknis modern terkait arsitektur **Wayland**, **Weston**, dan **wlroots**—inti dari sistem tampilan generasi baru pada GNU/Linux, termasuk yang digunakan oleh **Sway**.

---

### **Lapisan 2.3 – Wayland Ecosystem & wlroots Components (101–170)**

**101. Wayland**
Protokol tampilan modern pengganti X11 yang mengatur komunikasi langsung antara klien dan compositor tanpa perantara server tunggal.

**102. Wayland Protocol**
Spesifikasi resmi yang mendefinisikan pesan dan objek antara *Wayland client* dan *compositor*.

**103. Wayland Compositor**
Program yang menerima permukaan (surface) dari klien, melakukan komposisi grafis, dan menampilkan hasil ke layar (contohnya Sway, Weston, Hyprland).

**104. Wayland Client**
Aplikasi pengguna yang menggambar antarmuka melalui objek `wl_surface` dan berkomunikasi dengan compositor.

**105. libwayland-client**
Pustaka C yang digunakan oleh aplikasi untuk mengimplementasikan sisi klien Wayland.

**106. libwayland-server**
Pustaka C untuk membuat compositor Wayland dengan dukungan penuh terhadap protokol inti.

**107. Wayland Object**
Representasi entitas dalam protokol, seperti `wl_surface`, `wl_output`, atau `wl_pointer`.

**108. Wayland Interface**
Kumpulan pesan (request/event) yang didefinisikan untuk setiap objek dalam protokol.

**109. Wayland Extension**
Perluasan dari protokol inti yang menambahkan fitur baru tanpa merusak kompatibilitas (contohnya `xdg-shell`, `wp_viewporter`).

**110. Wayland Registry**
Daftar interface dan ekstensi yang didukung oleh compositor dan dapat diikat oleh klien.

**111. Wayland Globals**
Objek tingkat sistem yang tersedia bagi semua klien (seperti `wl_compositor`, `wl_shm`, `wl_seat`).

**112. wl_display**
Objek utama yang mewakili koneksi antara klien dan compositor.

**113. wl_registry**
Objek yang menyediakan daftar semua global interface yang dapat digunakan.

**114. wl_surface**
Objek dasar untuk menggambar tampilan grafis.

**115. wl_output**
Objek yang mewakili monitor atau perangkat keluaran.

**116. wl_seat**
Abstraksi untuk sekumpulan perangkat input (keyboard, pointer, touch).

**117. wl_pointer**
Objek untuk menangani peristiwa tetikus.

**118. wl_keyboard**
Objek untuk menangani peristiwa papan ketik.

**119. wl_touch**
Objek untuk menangani input sentuh.

**120. wl_buffer**
Objek memori tempat data gambar dikirim dari klien ke compositor.

**121. wl_shm (Shared Memory)**
Interface standar untuk berbagi buffer berbasis memori antara klien dan compositor.

**122. wl_compositor**
Interface inti yang membuat surface baru dan mengatur buffer rendering.

**123. wl_callback**
Objek yang digunakan untuk sinkronisasi (misal frame done event).

**124. xdg-shell**
Ekstensi standar yang menyediakan API untuk jendela desktop seperti `xdg_toplevel` dan `xdg_popup`.

**125. xdg_toplevel**
Objek yang mewakili jendela utama (window) dalam lingkungan desktop.

**126. xdg_popup**
Objek jendela sementara seperti menu atau dialog kecil.

**127. xdg_wm_base**
Objek dasar untuk negosiasi antara klien dan compositor terkait shell interface.

**128. wp_viewporter**
Ekstensi untuk cropping dan scaling konten surface.

**129. wp_presentation**
Ekstensi yang menyediakan informasi waktu tampil frame (presentation timestamp).

**130. wp_viewporter**
Ekstensi untuk manipulasi ukuran dan transformasi buffer sebelum ditampilkan.

**131. wp_fractional_scale_v1**
Ekstensi yang memungkinkan skala tampilan fractional (misalnya 1.25x, 1.5x).

**132. wp_relative_pointer_v1**
Ekstensi untuk mendapatkan pergerakan pointer relatif (berguna dalam game atau 3D apps).

**133. wp_pointer_constraints_v1**
Ekstensi yang mengizinkan penguncian atau pembatasan pointer di area tertentu.

**134. wp_primary_selection_v1**
Ekstensi clipboard primer (copy–paste berbasis seleksi teks).

**135. zwlr_layer_shell_v1**
Ekstensi untuk menampilkan elemen desktop seperti panel, dock, dan notifikasi (digunakan di wlroots).

**136. zwlr_foreign_toplevel_manager_v1**
Ekstensi untuk enumerasi dan kontrol jendela dari compositor.

**137. zwlr_output_manager_v1**
Ekstensi untuk pengelolaan konfigurasi monitor secara dinamis.

**138. zwp_idle_inhibit_manager_v1**
Ekstensi untuk mencegah sistem idle saat aplikasi aktif (misalnya pemutar video).

**139. Wayland Socket**
Saluran komunikasi berbasis Unix socket antara klien dan compositor.

**140. Wayland Event Queue**
Struktur penyimpan event yang diterima compositor sebelum diteruskan ke aplikasi.

**141. Weston**
Implementasi referensi resmi Wayland compositor dari proyek Wayland itu sendiri.

**142. Weston Backend**
Modul backend Weston yang menentukan cara output dikirim ke perangkat (misal DRM, Wayland, X11, headless).

**143. Weston Shell**
Lapisan antarmuka yang menentukan perilaku jendela dan panel dalam Weston.

**144. Weston Clients**
Aplikasi demonstrasi yang menunjukkan kemampuan Wayland (misalnya `weston-terminal`, `weston-simple-egl`).

**145. Weston Configuration**
Berkas konfigurasi `weston.ini` yang menentukan output, keymap, shell, dan ekstensi.

**146. wlroots**
Pustaka modular untuk membangun compositor Wayland, digunakan oleh Sway, River, Wayfire, dan lainnya.

**147. wlroots Backend**
Modul untuk menangani keluaran grafis: DRM, Wayland, X11, headless, RDP.

**148. wlroots Renderer**
Lapisan abstraksi untuk menggambar buffer, mendukung OpenGL dan Pixman.

**149. wlroots Output**
Representasi monitor dalam wlroots, lengkap dengan mode, transformasi, dan scaling.

**150. wlroots Input Device**
Struktur yang mewakili perangkat input seperti keyboard atau pointer dalam wlroots.

**151. wlroots Scene Graph**
Struktur data hirarkis untuk mengelola surface dan transformasi posisi dalam compositor.

**152. wlroots Session**
Abstraksi untuk akses ke DRM devices, input, dan VT (virtual terminal).

**153. wlroots Compositor**
Objek inti yang mengatur interaksi antara surface, scene, dan rendering.

**154. wlroots Data Device**
Sistem transfer data antar klien (clipboard dan drag-and-drop).

**155. wlroots Seat**
Objek agregasi input yang mengelola pointer, keyboard, dan focus.

**156. wlroots Output Layout**
Struktur untuk menyusun beberapa output dalam ruang koordinat global.

**157. wlroots XDG Shell Implementation**
Modul implementasi `xdg-shell` yang memetakan jendela ke dalam scene graph.

**158. wlroots Layer Shell Implementation**
Modul implementasi `zwlr-layer-shell-v1` untuk panel dan notifikasi.

**159. wlroots Subsurface**
Surface anak yang menempel pada surface induk untuk kontrol detail layout.

**160. wlroots Texture**
Objek GPU yang digunakan compositor untuk menggambar buffer klien.

**161. wlroots Render Pass**
Siklus rendering terpisah untuk frame tertentu.

**162. wlroots Frame Scheduling**
Penjadwalan waktu render frame untuk sinkronisasi dengan refresh rate.

**163. wlroots Output Damage Tracking**
Sistem pelacakan area tampilan yang berubah untuk efisiensi redraw.

**164. wlroots Gamma Control**
API pengaturan gamma di tingkat compositor.

**165. wlroots View**
Representasi logis jendela klien dalam scene.

**166. wlroots Cursor Manager**
Komponen untuk menggambar dan mengatur kursor sistem.

**167. wlroots XWayland Support**
Lapisan integrasi yang memungkinkan aplikasi X11 berjalan di bawah compositor Wayland.

**168. wlroots Logging**
Sistem pencatatan terpusat untuk debug compositor.

**169. wlroots Configurable Modules**
Modul opsional yang dapat diaktifkan saat membangun compositor.

**170. wlroots Renderer Backend**
Lapisan akhir yang menghubungkan renderer dengan API GPU (misalnya EGL/OpenGL).

---

#### Bagian berikut adalah **IPC, Extension Protocols & Integration Layer (Lapisan 2)** yang berisi 30 istilah kunci yang menjadi tulang punggung komunikasi dan integrasi antar proses, komponen grafis, serta lapisan sistem pengguna:

---

### **2.4 IPC, Extension Protocols & Integration Layer (30 Istilah)**

1. **IPC (Inter-Process Communication)** – Mekanisme komunikasi antar proses dalam sistem operasi.
2. **D-Bus (Desktop Bus)** – Sistem pesan IPC standar untuk Linux desktop.
3. **System Bus** – Jalur komunikasi D-Bus antar layanan sistem.
4. **Session Bus** – Jalur komunikasi D-Bus untuk proses pengguna (user session).
5. **Message Bus Daemon** – Proses utama yang mengelola D-Bus.
6. **Signal** – Pesan broadcast dalam D-Bus untuk notifikasi status antar komponen.
7. **Method Call** – Jenis pesan D-Bus untuk memanggil fungsi jarak jauh antar proses.
8. **Property** – Nilai konfigurasi yang diekspos oleh layanan D-Bus.
9. **DBus Interface** – Definisi fungsi, properti, dan sinyal yang diimplementasikan layanan.
10. **DBus Service** – Layanan IPC yang terdaftar pada bus D-Bus.
11. **DBus Object Path** – Jalur unik untuk mengidentifikasi objek dalam D-Bus.
12. **DBus Name** – Identifier dari aplikasi/layanan pada bus (contoh: `org.freedesktop.NetworkManager`).
13. **DBus Introspection** – Mekanisme eksplorasi struktur layanan D-Bus secara dinamis.
14. **DBus Binding** – Implementasi API D-Bus dalam bahasa pemrograman tertentu (C, Python, Rust, Lua).
15. **XDG Portals** – Lapis keamanan yang menjembatani sandbox aplikasi (Flatpak, Snap) dengan sistem host.
16. **xdg-desktop-portal** – Daemon utama yang melayani permintaan portal (contoh: akses file, layar, dsb.).
17. **xdg-document-portal** – Portal untuk akses file lintas sandbox dengan kontrol keamanan.
18. **xdg-permission-store** – Basis data izin pengguna untuk aplikasi sandboxed.
19. **Flatpak Portal API** – Antarmuka yang memungkinkan aplikasi Flatpak berinteraksi dengan desktop.
20. **Wayland Socket** – Jalur komunikasi IPC antara client dan compositor (biasanya UNIX domain socket).
21. **X11 Socket** – Jalur komunikasi antara X client dan X server.
22. **SHM (Shared Memory)** – Segment memori bersama yang digunakan client dan server grafis.
23. **EGLStream** – Mekanisme buffer streaming antara producer (GPU) dan consumer (compositor).
24. **EGLImage** – Representasi gambar dari buffer yang bisa dibagikan antar konteks EGL.
25. **DMA-BUF (Direct Memory Access Buffer Sharing)** – Metode berbagi buffer GPU lintas proses.
26. **Wayland Protocol Extensions** – Tambahan terhadap protokol inti Wayland (misal `xdg-shell`, `wlr-layer-shell`).
27. **wlr-protocols** – Kumpulan ekstensi protokol Wayland untuk compositor berbasis wlroots.
28. **xdg-shell** – Ekstensi Wayland standar untuk manajemen jendela (window management).
29. **wlr-layer-shell** – Ekstensi untuk panel, bar, dan overlay di compositor wlroots.
30. **wlroots IPC Layer** – Lapisan internal komunikasi antara compositor dan backend wlroots.

---

<!-----------------------

Lapisan 2 kini lengkap dengan total **200 istilah**: mencakup Display Server, Protocol, Rendering Backend, dan IPC/Integration Layer.
Tahapan berikutnya akan naik ke **Lapisan 3 – Compositor Layer**, yang membahas perenderan jendela, surface management, damage tracking, buffer handling, dan integrasi input/output.

Apakah kamu ingin saya lanjutkan langsung ke Lapisan 3?

Langkah berikutnya adalah **Lapisan 3: Compositor & Window Manager (1–40)**, tempat semua logika pengelolaan jendela, layout, stacking, dan rendering diproses.
Apakah Anda ingin saya lanjut langsung ke Lapisan 3 sekarang?
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

------------------------------>

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
