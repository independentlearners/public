# [🪞 2. Pengenalan Wayland & Komponen Sway][0]

## Pengenalan Wayland
Wayland adalah protokol tampilan (display server protocol) modern yang dirancang menggantikan X11 dengan arsitektur lebih sederhana dan kode basis lebih ringan. Dalam Wayland, aplikasi pengguna adalah klien yang berkomunikasi langsung dengan display server yang disebut compositor. Protokol ini juga merujuk ke arsitektur sistem tampilan: tidak ada satu server tunggal (seperti Xorg pada X11), melainkan banyak implementasi compositor yang berbeda untuk masing-masing lingkungan desktop. Pustaka inti Wayland, libwayland, mengambil definisi protokol berformat XML dan menggenerasi API C (memang hanya menerjemahkan pesan request/event tanpa logika khusus). Wayland bersifat sangat fleksibel: compositor bisa berjalan sendiri di Linux menggunakan KMS/evdev, atau dijalankan sebagai aplikasi di dalam X11 atau bahkan dijalankan bersarang dalam sesi Wayland lain

Protokol Wayland bersifat asinkron dan berbasis objek. Klien mengirim request (permintaan tindakan) ke objek di compositor, dan compositor merespons dengan event, tanpa perlu mekanisme ACK yang menyinkronkan kedua pihak. Dengan model asinkron ini, komunikasi menjadi cepat karena tidak perlu menunggu respon sinkron, sehingga mengurangi latensi round-trip. Setiap pesan Wayland dikirim melalui socket UNIX (secara default bernama wayland-0, dapat diubah lewat variabel lingkungan) dengan format word 32-bit berisi header (ID objek dan opcode) serta argumen data. Beberapa antarmuka (interfacing) inti Wayland yang penting antara lain wl_display (koneksi ke display), wl_registry, wl_compositor (objek kompositor), wl_surface (area jendela), wl_buffer (konten piksel), wl_output (layar/output), serta objek input seperti wl_pointer, wl_keyboard, wl_touch, dan wl_seat. Objek-objek ini dihasilkan dari file protokol wayland.xml yang mendefinisikan request dan event; libwayland menghasilkan stub C untuk mengakses objek-objek tersebut

## Arsitektur Wayland:
### Compositor, client, protocol, dan event loop.

```
                        ┌───────────────────────────────┐
                        │        WAYLAND SERVER         │
                        │     (Compositor / Display)    │
                        └─────────────┬─────────────────┘
                                      │
                        Wayland Protocol (IPC / UNIX socket)
                                      │
        ┌─────────────────────────────┴─────────────────────────────┐
        │                                                           │
┌──────────────────────┐                                   ┌──────────────────────┐
│      CLIENT A        │                                   │      CLIENT B        │
│ (misal: terminal)    │                                   │ (misal: browser)     │
│──────────────────────│                                   │──────────────────────│
│   wl_display.connect │                                   │   wl_display.connect │
│   wl_surface.create  │                                   │   wl_surface.create  │
│   wl_buffer.attach   │                                   │   wl_buffer.attach   │
│   wl_compositor API  │                                   │   wl_compositor API  │
│──────────────────────│                                   │──────────────────────│
│     Event Loop       │                                   │     Event Loop       │
│  (epoll / poll / io) │                                   │  (epoll / poll / io) │
└──────────────────────┘                                   └──────────────────────┘
        │                                                           │
        └─────────────────────────────┬─────────────────────────────┘
                                      │
                     Events / Requests (Serialized Messages)
                                      │
                        ┌─────────────┴────────────────┐
                        │        COMPOSITOR            │
                        │──────────────────────────────│
                        │ 1. Menerima Request Client   │
                        │ 2. Mengatur Surface & State  │
                        │ 3. Komposisi Buffer ke layar │
                        │ 4. Mengirim Event balik      │
                        └──────────────────────────────┘
                                      │
                                      ▼
                        ┌──────────────────────────────┐
                        │      KERNEL / DRM / GPU      │
                        │ (KMS, GBM, EGL, OpenGL, VK)  │
                        └──────────────────────────────┘
```

Diagram ini memperlihatkan hubungan utama dalam arsitektur **Wayland**:

* **Client** berkomunikasi dengan **Compositor** melalui **Wayland Protocol**.
* **Event Loop** di tiap sisi mengatur aliran **request** dan **event**.
* **Compositor** berinteraksi langsung dengan **kernel/gpu stack** untuk menggambar hasil akhir di layar.

## Sejarah dan Motivasi
Wayland pertama kali diinisiasi oleh Kristian Høgsberg (Red Hat) sekitar tahun 2008. Rilis awal protokol Wayland terjadi pada 30 September 2008, dan pada Juli 2025 versi stabil terbaru adalah Wayland. Tujuan utama Wayland adalah mengatasi kompleksitas dan kekurangan X11 yang sudah tua. X11 dianggap kode yang rumit dan susah dipelihara, dan banyak fungsionalitasnya telah dipindahkan ke kernel atau pustaka terpisah seperti KMS, libevdev, Mesa, dll. Oleh karena itu Wayland dibuat untuk mengurangi lapisan berlebih dan mengurangi kode yang berjalan dengan hak istimewa (root). Misalnya, dengan menghapus model client-server tradisional X, Wayland bisa “mengeluarkan X dari jalur kritis” komunikasi antara aplikasi dan hardware grafis. Desain ini juga dimaksudkan agar sistem grafis menjadi lebih sederhana, lebih aman, dan lebih efisien secara performa. Wayland dikembangkan secara open-source di bawah lisensi MIT, oleh komunitas sukarelawan (awalnya dipimpin Høgsberg) dengan tujuan menggantikan X11 menjadi sistem windowing yang lebih aman dan sederhana untuk Linux dan Unix-like


## Arsitektur dan Cara Kerja
Diagram arsitektur Wayland: klien (aplikasi) berkomunikasi langsung dengan compositor yang juga bertugas sebagai display server. Dalam Wayland, compositor bertindak sebagai display server penuh. Semua masukan (input) dari kernel (evdev) langsung ke compositor, dan semua kontrol mode tampilan (KMS) dikuasai oleh compositor. Alur kerjanya secara singkat adalah sebagai berikut:

1. Kernel -> Compositor: Kernel Linux mendeteksi masukan (misal klik mouse atau ketukan keyboard) dan mengirimkan event tersebut ke compositor (mirip X, tetapi langsung ke compositor)
2. Compositor -> Klien: Compositor melihat scenegraph-nya (apa saja jendela yang tampil) untuk menentukan jendela (klien) mana yang menerima event, menghitung transformasi koordinat yang telah diterapkan, lalu meneruskan event input ke klien yang sesuai
3. Klien merender dan “damage” ke compositor: Aplikasi-klien menerima event dan merespon dengan menggambar ulang tampilannya melalui pustaka grafis (misalnya OpenGL/EGL) langsung ke buffer grafisnya. Setelah merender, klien mengirimkan informasi damage (bagian layar yang berubah) ke compositor. Pada tahap ini, rendering oleh klien bersifat langsung (direct rendering); klien memiliki buffer shareable (misalnya dmabuf) dan mengisi buffer tersebut dengan konten baru
Rekomposit dan flip: Compositor mengumpulkan semua damage dari klien-klien terkait, kemudian melakukan komposit ulang (menggambar seluruh layar dari komposisi permukaan jendela). Karena compositor mengendalikan KMS secara langsung, ia dapat melakukan page-flip buffer baru ke layar tanpa perantara. Hasilnya adalah tampilan akhir yang terkomposit sepenuhnya oleh compositor.

### **Alur data dan kendali (data flow)** dari input sampai output tampilan (*rendering pipeline*).

```
                     ALUR KERJA WAYLAND + SWAYWM
                     ===========================

┌────────────────────────────────────────────────────┐
│                  LINUX KERNEL LAYER                │
│────────────────────────────────────────────────────│
│ evdev  → menangkap input (keyboard, mouse, touch)  │
│ DRM/KMS → mengatur mode tampilan & page-flip layar │
└───────────────┬────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────┐
│                    COMPOSITOR (SwayWM)             │
│────────────────────────────────────────────────────│
│  • Menerima event input dari kernel                │
│  • Menentukan klien penerima melalui scene-graph   │
│  • Meneruskan event ke klien sesuai fokus          │
│  • Mengelola layout window & posisi tampilan       │
│  • Mengkomposit seluruh buffer ke layar (KMS flip) │
│  • Mengontrol rendering melalui wlroots + OpenGL   │
└───────────────┬────────────────────────────────────┘
                │ Wayland Protocol (IPC socket)
                ▼
┌────────────────────────────────────────────────────┐
│                    WAYLAND CLIENT                  │
│────────────────────────────────────────────────────│
│  • Menerima event input dari compositor            │
│  • Merender tampilan dengan EGL/OpenGL/Vulkan      │
│  • Mengupdate buffer (damage region)               │
│  • Mengirim kembali buffer share (dmabuf)          │
└───────────────┬────────────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────┐
│        COMPOSITOR (Rekomposit dan Page-Flip)       │
│────────────────────────────────────────────────────│
│  • Menggabungkan semua buffer klien menjadi 1 scene│
│  • Melakukan page-flip buffer ke layar (KMS)       │
│  • Tampilan akhir muncul di monitor                │
└────────────────────────────────────────────────────┘
```
Diagram secara **konseptual**:

* **Kernel → Compositor:** event input langsung dikirim ke compositor.
* **Compositor → Client:** compositor memutuskan klien mana yang menerima event.
* **Client → Compositor:** klien merender dan mengirim “damage” buffer.
* **Compositor → Display (KMS):** compositor menggabungkan hasil render dan menampilkan lewat *page-flip*.
<!--
Dengan diagram ini, pemahaman arsitektur dan alur kerja Wayland–SwayWM sudah sepenuhnya sejajar dengan deskripsi teknis Wayland resmi.
-->
Dengan model ini, dibanding X11 tidak diperlukan penyalinan ganda atau sinkronisasi melalui X server. Compositor Wayland menggunakan buffer yang dibuat klien sebagai tekstur, sehingga gerakan dan animasi dapat lebih mulus. Rendering grafis dikerjakan klien (mirip DRI2/XDirect), dengan compositor sebagai ‘pemilik layar’ akhir.

## Protokol dan Komponen Utama
Protokol Wayland didefinisikan melalui file XML (wayland.xml) yang mencantumkan antarmuka, request, event, enum, dsb. Pustaka libwayland secara otomatis meng-generasi kode C dari file XML ini. Klien dan server Wayland kemudian berkomunikasi lewat pesan berbasis objek: setiap request (dikirim oleh klien) dan event (dikirim oleh compositor) dipanggil pada objek tertentu. Tidak ada mekanisme polling status, melainkan status komposit (contoh posisi jendela) di-broadcast pada saat koneksi, dan semua perubahan dikirim via event ketika terjadi perubahan


**Komponen-komponen utama ekosistem Wayland meliputi:**

- Wayland Compositor: Program display server yang menerapkan protokol Wayland sekaligus berfungsi sebagai window manager. Contohnya adalah Weston (referensi resmi Wayland), GNOME Shell (Mutter dengan backend Wayland), KDE KWin (sesi Plasma Wayland), Sway (tiling berbasis wlroots), dll.
- Wayland Client: Aplikasi biasa yang dirancang untuk Wayland atau toolkit (GTK/Qt/SDL) yang mendukung Wayland. Klien berkomunikasi dengan compositor via libwayland-client.
- libwayland-client dan libwayland-server: Pustaka C yang dihasilkan dari definisi XML; yang pertama digunakan oleh klien, yang kedua oleh compositor. Pustaka ini hanya menangani encoding/decoding pesan Wayland
- Protokol Inti (Core Interfaces): Beberapa objek protokol dasar yang diharapkan ada di semua compositor, misalnya wl_display, wl_registry, wl_compositor, wl_surface, wl_buffer, wl_output, wl_pointer, wl_keyboard, wl_touch, wl_seat, dll. Objek-objek ini mengizinkan pembentukan jendela, pemrosesan input, dan manajemen output.
- Protokol Ekstensi (wayland-protocols): Proyek terpisah yang menyediakan protokol tambahan (XML) di luar inti, seperti xdg-shell untuk fitur window tradisional (maks/min/fullscreen), xdg-activation, xdg-desktop-portal, dsb. Compositor dapat mengimplementasikan protokol tambahan ini sesuai kebutuhan.
- XWayland: Server X11 yang berjalan sebagai klien Wayland. Ini digunakan untuk menjalankan aplikasi X11 lama di lingkungan Wayland. Tanpa XWayland, aplikasi X11 tidak dapat berjalan di sesi Wayland. (XWayland menjadi bagian dari X.Org 1.16 ke atas.)

Secara keseluruhan, Wayland memindahkan banyak tanggung jawab (mode-setting, input, rendering dasar) ke level kernel atau pustaka, sehingga compositor dapat fokus melakukan komposisi akhir. Protokolnya yang ringkas dan berbasis objek mendukung ekstensibilitas dan kompatibilitas mundur; setiap antarmuka memiliki atribut versi agar dapat berkembang tanpa memecah kompatibilitas.

```
                                            +----------------------+
                                            |   wayland.xml (XML)  |
                                            | - definisi protokol  |
                                            +----------+-----------+
                                                       │
                                                       │ wayland-scanner / codegen
                                                       ▼
                 +----------------------+     +----------------------+     +----------------------+
                 | libwayland-server    |     | libwayland-client    |     | wayland-protocols    |
                 | (C stub dari XML)    |     | (C stub dari XML)    |     | (ekstensi XML ops.)  |
                 +----------+-----------+     +----------+-----------+     +----------+-----------+
                            │                            │                             
                            │                            │                             
                            │                            │                             
                            │                            │                             
                            │                            │                             
                            ▼                            ▼                             
        +--------------------------------+  <--- Wayland socket (UNIX domain, word32 msgs) --->  +------------------+
        |          COMPOSITOR            |  requests/events target objek (wl_surface, wl_buffer) |   CLIENTS / UI   |
        |  (contoh: Sway, Weston, KWin)  |                                                       | - Toolkit: GTK   |
        | - libwayland-server            |                                                       |   (C) / Qt (C++) |
        | - wlroots / backend DRM input  |                                                       | - SDL, apps (C)  |
        | - event loop (wl_event_loop)   |                                                       +------------------+
        | - scenegraph, focus & policy   |
        | - menerima input (evdev/libinput)                                     (XWayland)
        | - mengumpulkan damage dari klien                ▲
        | - komposit & page-flip via KMS/DRM              │
        +-------------+------------------+---------------+               +----------------------+
                      │                  │                               |      XWayland        |
                      │                  │                               |- X server as Wayland |
                      │                  │                               |  client (X.Org)      |
                      │                  ▼                               +----------------------+
                      │         Kompositor -> Kernel/GPU stack
                      │         (wlroots/libdrm/EGL/GL/Vulkan)
                      ▼
        +------------------------------------------------------+
        |                LINUX KERNEL / GPU                    |
        | - evdev -> input devices (keyboard/mouse/touch)      |
        | - DRM / KMS -> mode-setting, connectors, page-flip   |
        | - DMA-BUF -> buffer sharing (zero-copy)              |
        +------------------------------------------------------+
```

Identitas teknis singkat dan persyaratan jika ingin modifikasi (inti — poin penting):

* Wayland protocol / wayland.xml

  * Dibangun sebagai definisi XML; diubah menjadi C stubs menggunakan *wayland-scanner* / generator.
  * Persyaratan: paham format XML protokol Wayland, cara menggunakan wayland-scanner.

* libwayland-client / libwayland-server

  * Implementasi API yang dihasilkan: **C**.
  * Persyaratan: kemampuan pemrograman C, pemahaman UNIX sockets, binary message layout (word32), event-driven programming.

* Compositor (contoh: Sway, Weston, KWin)

  * Umumnya ditulis **C** atau **C/C++**; Sway menggunakan **C** + wlroots (C).
  * Persyaratan: C, pemahaman wlroots (jika memakai), meson/ninja atau buildsystem lain, pengalaman OpenGL/EGL/Vulkan bila melakukan rendering, pemahaman DRM/KMS, udev, libinput, hak akses DRM (root atau grup video).

* wlroots (jembatan hardware/abstraksi)

  * Ditulis **C**; menyediakan backend DRM, input, renderer.
  * Persyaratan: mengerti arsitektur wlroots, API C, integrasi dengan compositor.

* Toolkits / Klien (GTK, Qt, SDL)

  * GTK: **C** (GObject); Qt: **C++** (QtWayland module); SDL: **C**.
  * Persyaratan untuk modifikasi: bahasa toolkit bersangkutan, pemahaman cara toolkit berinteraksi dengan Wayland (surface, buffer, frame callbacks).

* XWayland

  * Implementasi X server berjalan sebagai klien Wayland; ditulis **C** (bagian X.Org).
  * Persyaratan: memahami X11 internals bila perlu memodifikasi.

* Buffer sharing & zero-copy (dmabuf)

  * Melibatkan kernel / driver GPU dan library (libdrm, mesa).
  * Persyaratan: pemahaman DMA-BUF, sinkronisasi buffer, serta build dan debug driver grafik bila perlu.

Catatan ringkas: untuk mulai memodifikasi atau membuat protokol/kompositor sendiri, siapkan toolchain C (gcc/clang), meson/ninja, wayland-scanner, header kernel (linux-headers), libinput, libdrm, mesa dev packages, dan akses ke perangkat DRM (untuk pengujian di hardware).
<!--
Semangat — diagram ini bisa langsung kamu gunakan sebagai peta untuk menavigasi bagian mana yang ingin dipelajari atau dimodifikasi selanjutnya.
-->

## Perbedaan Wayland vs X11
Diagram arsitektur X11 tradisional: X server (ditandai) menangani input/output untuk aplikasi, dengan window manager dan compositing manager di luar server utama. Arsitektur Wayland sangat berbeda dibanding X11. Pada X11, protokolnya lama (1984) dan komplek: X server adalah perantara utama yang menerima input dan mengendalikan mode tampilan, sementara window manager eksternal menangani penempatan jendela dan dekorasi. Banyak pekerjaan X server sekarang sudah di-handle oleh kernel (DRM, evdev) atau pustaka (cairo, fontconfig, dll), sehingga X server sering menjadi “pihak ketiga” yang tidak perlu antara aplikasi dan compositing. Wayland mengatasi hal ini dengan menghilangkan X server: aplikasi berbicara langsung dengan compositor yang menggabungkan fungsi server dan window manager sekaligus. Akibatnya, jalur rendering menjadi lebih singkat dan efisien.

## Perbandingan utama antara Wayland dan X11 meliputi:

- Arsitektur: X11 menggunakan X server sebagai perantara pusat, sedangkan Wayland memadukan fungsionalitas display server dan window manager di dalam satu compositor. Dengan desain Wayland, setiap aplikasi kirim langsung ke compositor tanpa perantara ekstra, mengurangi lapisan kompleksitas.
- Kinerja: Wayland cenderung lebih cepat dan lancar. Karena klien merender konten langsung ke buffer bersama, latensi input lebih rendah dan gerakan grafis lebih halus (minim tearing). X11, dengan jalur yang lebih panjang (aplikasi→X server→compositor), lebih rentan mengalami jitter, tearing, atau lag input jika compositing tidak optimal.
- Keamanan: Wayland mengisolasi aplikasi; satu aplikasi tidak bisa melihat apa yang digambar aplikasi lain atau mendengarkan input global. Ini mencegah kelas serangan input sniffing dan keylogger yang umum di X11. X11 kurang aman karena semua klien berbagi X server yang sama, sehingga bisa saling menyusup atau mendapatkan data desktop secara bebas.
- Dukungan Jaringan (Network Transparency): X11 sejak awal mendukung transparansi jaringan — aplikasi dapat dijalankan di satu mesin dan ditampilkan di mesin lain menggunakan X forwarding. Wayland tidak menyediakan fitur ini secara bawaan. Untuk kebutuhan sharing layar atau remote desktop, Wayland mengandalkan protokol eksternal (misalnya PipeWire + RDP/VNC) agar lebih aman dan modern.

- Kompatibilitas Aplikasi: Banyak aplikasi grafis lama dirancang untuk X11. Di Wayland, diperlukan lapisan kompatibilitas XWayland untuk menjalankannya. Tanpa XWayland, aplikasi X tidak akan berjalan di sesi Wayland. Sebaliknya, aplikasi yang sudah memanfaatkan toolkit GTK/Qt modern dapat beralih ke backend Wayland tanpa diubah.
- Pengelolaan Jendela: Pada X11, window manager terpisah mengatur dekorasi jendela (bingkai, tombol), sedangkan di Wayland semua fungsi tersebut ditangani oleh compositor. Compositor Wayland menentukan posisi, ukuran, dan dekorasi jendela secara langsung, mengurangi komunikasi antarproses.

Singkatnya, Wayland menawarkan arsitektur yang lebih ramping dan aman dibanding X11, dengan peningkatan performa grafis. Namun demikian, ia harus menggantikan banyak fungsi lama sehingga beberapa fitur (seperti sharing layar, beberapa efek desktop khusus) harus di-implementasikan ulang lewat ekstensi protokol.

```
                   ╔══════════════════════════════════════════════════════════════╗
                   ║                 X11 (Arsitektur Tradisional)                 ║
                   ╚══════════════════════════════════════════════════════════════╝

                   ┌─────────────────────────────────────────────────────────────┐
                   │                       APLIKASI X CLIENT                     │
                   │  (GTK, Qt, SDL, dlsb — kirim request X11 ke server)         │
                   └───────────────┬─────────────────────────────────────────────┘
                                   │   X11 Protocol (TCP / UNIX socket)
                                   ▼
                   ┌─────────────────────────────────────────────────────────────┐
                   │                        X SERVER                             │
                   │─────────────────────────────────────────────────────────────│
                   │ • Menangani input/output display                            │
                   │ • Menggambar primitive grafis (font, shape, dll)            │
                   │ • Mengelola resource window, surface                        │
                   │ • Menyediakan API Xlib/XCB                                  │
                   │ • Tidak mengelola layout window                             │
                   └───────────────┬─────────────────────────────────────────────┘
                                   │
                  ┌────────────────┴────────────────┐
                  │                                 │
                  ▼                                 ▼
      ┌──────────────────────────┐       ┌────────────────────────────────┐
      │ WINDOW MANAGER (eksternal│       │ COMPOSITING MANAGER (eksternal)│
      │ misal: Metacity, i3, dll │       │ misal: Compton, Mutter, KWin)  │
      │ - Mengatur posisi jendela│       │ - Mengkomposit tampilan X      │
      └──────────┬───────────────┘       └──────────┬─────────────────────┘
                 │                                  │
                 ▼                                  ▼
           ┌────────────────────────────────────────────────────┐
           │             KERNEL / GPU STACK (DRM, evdev)        │
           └────────────────────────────────────────────────────┘

                   Jalur Rendering: 
                   Aplikasi → X Server → Compositor → Kernel → Monitor
                   (banyak perantara, latensi tinggi, keamanan rendah)


                   ╔══════════════════════════════════════════════════════════════╗
                   ║                 WAYLAND (Arsitektur Modern)                  ║
                   ╚══════════════════════════════════════════════════════════════╝

                   ┌─────────────────────────────────────────────────────────────┐
                   │                     WAYLAND CLIENT                          │
                   │ (GTK/Qt/SDL modern, rendering langsung ke buffer sendiri)   │
                   └───────────────┬─────────────────────────────────────────────┘
                                   │
                                   │ Wayland Protocol (UNIX socket)
                                   ▼
                   ┌─────────────────────────────────────────────────────────────┐
                   │                  WAYLAND COMPOSITOR                         │
                   │─────────────────────────────────────────────────────────────│
                   │ • Display server + window manager gabung jadi satu          │
                   │ • Menangani input (evdev/libinput)                          │
                   │ • Menentukan fokus jendela, dekorasi, layout                │
                   │ • Mengkomposit buffer klien langsung ke layar (KMS)         │
                   │ • Contoh: Weston, Sway, Mutter (Wayland mode), KWin         │
                   └───────────────┬─────────────────────────────────────────────┘
                                   │
                                   ▼
                     ┌────────────────────────────────────────────────────┐
                     │           KERNEL / GPU STACK (DRM, evdev)          │
                     │ - Input langsung ke compositor                     │
                     │ - Mode-setting dan rendering langsung (KMS/GL)     │
                     └────────────────────────────────────────────────────┘

                   Jalur Rendering: 
                   Aplikasi → Compositor → Kernel → Monitor
                   (pendek, efisien, aman, tanpa perantara)


                   ╔══════════════════════════════════════════════════════════════╗
                   ║                   RINGKAS PERBANDINGAN                       ║
                   ╚══════════════════════════════════════════════════════════════╝
                   X11: 
                     - X Server sebagai perantara utama
                     - Window manager dan compositor eksternal
                     - Klien dapat saling intip → keamanan lemah
                     - Jalur panjang → latensi tinggi
                     - Mendukung network transparency bawaan (X forwarding)

                   Wayland:
                     - Compositor = server + window manager sekaligus
                     - Komunikasi langsung, protokol asinkron berbasis objek
                     - Isolasi klien → keamanan tinggi
                     - Jalur pendek → performa tinggi, latensi rendah
                     - Remote display via ekstensi (PipeWire/RDP/VNC)
```

Diagram ini menggambarkan **dua paradigma utama**:

* **X11**: model berlapis dengan *X Server* sebagai perantara sentral antara aplikasi dan layar, ditambah window manager serta compositor eksternal.
* **Wayland**: model terpadu di mana *compositor* menjadi pusat tunggal — menangani input, output, dekorasi, dan komposisi layar.

Dengan diagram tersebut, perbedaan dari sisi **arsitektur, kinerja, keamanan, dan jalur komunikasi** terlihat jelas, menunjukkan mengapa Wayland disebut “arsitektur modern” dan X11 “arsitektur tradisional”.

## Komunitas dan Ekosistem Wayland
Wayland sudah diadopsi secara luas di ekosistem Linux Desktop. Misalnya, GNOME Shell (Mutter) menjadikan Wayland sebagai sesi default di banyak distro (Fedora, Ubuntu modern, dsb). KDE Plasma (KWin) juga menyediakan sesi Wayland yang semakin matang dengan terus diperbaiki bug dan fitur (misal dukungan sync eksplisit untuk driver NVIDIA telah ditambahkan pada 2024). Desktop ringan seperti Xfce dan LXQt baru mulai mengembangkan dukungan Wayland, sedangkan Enlightenment telah mendukung Wayland sejak 2015. Terdapat banyak compositor Wayland lainnya, antara lain Wayfire, Hyprland, atau river, serta driver alternatif seperti wlroots (digunakan oleh Sway, Wayfire, dsb) dan libweston sebagai basis komponennya.

Sebagai perbandingan, rata-rata pengguna saat ini melihat tampilan desktop yang sangat mirip di Wayland maupun X11, karena desktop environment dan toolkit berusaha konsisten. Namun sistem file /proc, environment, dan utilitas sedikit berbeda. Contohnya, untuk mengetahui sesi yang sedang aktif dapat dicek dengan perintah echo $WAYLAND_DISPLAY (menghasilkan wayland-0 jika Wayland; kosong jika X11), atau loginctl show-session <NOMOR> -p Type untuk melihat tipe sesi. Sebagian distro juga menyediakan opsi di layar login (display manager) untuk memilih sesi Wayland atau X11 secara manual (misal Fedora Workstation memungkinkan pilihan “GNOME on Xorg”). Ubuntu dan distro lainnya pada rilis terbaru sudah memosisikan Wayland sebagai pilihan utama (meskipun terkadang dinonaktifkan sementara untuk kartu grafis tertentu seperti beberapa GPU NVIDIA lawas). Wayland sendiri bersifat lintas platform; meski dikembangkan untuk Linux, ada juga port eksperimental ke sistem BSD dan Haiku (ditulis dalam C dan bersifat open-source).

## Cara Penggunaan dan Konfigurasi

Bagi pengguna desktop biasa, menjalankan Wayland umumnya hanya perlu memilih sesi Wayland saat login. Banyak display manager (GDM untuk GNOME, SDDM untuk KDE, LightDM, dsb) menyediakan menu untuk memilih “GNOME” (Wayland) atau “GNOME on Xorg”. Setelah masuk, aplikasi yang mendukung Wayland otomatis menggunakan protokol tersebut. Bila aplikasi belum mendukung Wayland, XWayland akan mengaktif secara transparan agar aplikasi X dapat berjalan. Untuk mendeteksi penggunaan Wayland, perintah seperti echo $WAYLAND_DISPLAY atau loginctl dapat dipakai. Fedora Workstation misalnya mengaktifkan Wayland secara default pada GNOME, tetapi pengguna bebas beralih ke X11 jika diperlukan.

Beberapa detail konfigurasi teknis untuk admin meliputi file custom.conf di /etc/gdm (untuk menonaktifkan Wayland sepenuhnya), penggunaan driver GPU yang mendukung KMS/GBM untuk kinerja optimal, dan pengaturan security sandbox (Wayland mengisolasi klien, tetapi portal XDG-desktop-portal digunakan untuk akses file/screen-sharing). Namun pengaturan rinci di luar cakupan pengenalan ini. Inti penggunaannya adalah: pastikan desktop environment dan driver GPU Anda mendukung Wayland, lalu pilih sesi Wayland di login dan nikmati desktop yang di-render melalui Wayland.

## Pengembangan dan Kontribusi

Proyek Wayland bersifat open source dengan kode di GitLab Freedesktop (misalnya repositori wayland/wayland). Selain protokol inti, ada proyek pendukung seperti wayland-protocols (sekumpulan protokol ekstensi XML) dan Weston (referensi compositor). Wayland ditulis dalam bahasa C dan dirilis di bawah lisensi MIT. Komunitas pengembangnya tersebar: terdapat mailing list Wayland-devel di Freedesktop untuk diskusi teknis, serta saluran IRC #wayland di jaringan OFTC. Kode sumber dan issue tracker publik memungkinkan siapa saja memeriksa masalah (bugs), mengajukan patch, atau mengikuti perkembangan fitur. Dokumen kontribusi dan aturan penulisan kode terdapat di repositori GitLab (tautan Contribution instructions pada situs Wayland).

Bagi pengembang aplikasi, Wayland mendorong penggunaan toolkit yang mendukung protokol ini. Banyak toolkit GUI populer (GTK 3+, Qt 5+, SDL2, dsb.) sudah menyediakan backend Wayland, sehingga aplikasi biasanya tidak perlu diubah, cukup dikompilasi ulang dengan dukungan Wayland. Untuk pengembang compositor baru, ada pustaka seperti wlroots yang menyediakan kerangka kerja abstraksi Wayland, memudahkan pembuatan window manager tiling/dinamika. Pengembang juga dapat menulis ekstensi protokol baru (misalnya untuk fitur khusus) dengan menambah definisi XML yang sesuai. Dokumentasi pengembangan Wayland tersedia di situs resmi Wayland (Wayland Protocols, Wayland Book) dan wiki komunitas.

Secara ringkas, dokumentasi dan sumber resmi (situs Wayland, wiki, dan literatur terkait) wajib dipelajari untuk memahami rincian implementasi. Alur belajar yang umum: pelajari arsitektur protokol (libwayland, message loop), lihat kode referensi Weston, kemudian cobalah membuat atau memodifikasi protokol sederhana. Pada akhirnya, Wayland merupakan platform terbuka yang terus berkembang: setiap rilis stabil mencakup peningkatan performa (misalnya dukungan sync eksplisit atau color management), serta ekosistem yang meluas di berbagai desktop dan perangkat. Dengan memahami arsitektur dan protokolnya secara mendalam, Anda dapat mengkonfigurasi sistem desktop dengan Wayland secara optimal maupun langsung berkontribusi mengembangkannya ke depan.

> Referensi: Informasi di atas diambil dari dokumentasi dan sumber terpercaya, antara lain situs resmi Wayland dan Fedora, untuk mengunjungi semua tautan, buka kode dokumen dan pada bagian bawah, semua sumber tautan di sediakan dalam komentar.

# Wayland Dengan SwayWM

```
                           ┌────────────────────────────────────┐
                           │           WAYLAND STACK            │
                           │ (Protocol + Libraries + Runtime)   │
                           └────────────────────────────────────┘
                                           │
                                           │
                     ┌─────────────────────┴──────────────────────┐
                     │                                            │
                     │          COMPOSITOR IMPLEMENTATION         │
                     │               (Contoh: SwayWM)             │
                     └─────────────────────┬──────────────────────┘
                                           │
             ┌─────────────────────────────┼─────────────────────────────┐
             │                             │                             │
             │                             │                             │
┌──────────────────────┐      ┌──────────────────────┐      ┌──────────────────────┐
│   Wayland Clients    │      │   Wayland Clients    │      │   Wayland Clients    │
│ (misal: Alacritty)   │      │ (misal: Firefox)     │      │ (misal: Wofi, GTK)   │
│──────────────────────│      │──────────────────────│      │──────────────────────│
│  wl_display.connect()│      │  wl_surface.create() │      │  wl_buffer.attach()  │
│  wl_shell / xdg API  │      │  wl_compositor API   │      │  wl_keyboard, etc.   │
└──────────────────────┘      └──────────────────────┘      └──────────────────────┘
             │                             │                              │
             └───────────────Wayland Protocol (socket IPC)────────────────┘
                                           │
                           ┌───────────────┴────────────────┐
                           │            SWAYWM              │
                           │────────────────────────────────│
                           │  • Implementasi Compositor     │
                           │  • Window Manager (wlroots)    │
                           │  • Layout Tiling / Floating    │
                           │  • Input / Output Handling     │
                           │  • IPC untuk swaymsg / config  │
                           │ • Event Loop (libev/libwayland)│
                           └───────────────┬────────────────┘
                                           │
                           ┌───────────────┴────────────────┐
                           │         WLR / Wlroots          │
                           │────────────────────────────────│
                           │ Abstraksi hardware (DRM/KMS)   │
                           │ Rendering (OpenGL / Vulkan)    │
                           │ Input (libinput / udev)        │
                           │ Backend: Wayland, X11, DRM     │
                           └───────────────┬────────────────┘
                                           │
                           ┌───────────────┴────────────────┐
                           │       LINUX KERNEL STACK       │
                           │────────────────────────────────│
                           │ DRM  - Direct Rendering Mgr    │
                           │ KMS  - Kernel Mode Setting     │
                           │ GPU Drivers (Mesa, NVIDIA, dll)│
                           │ evdev - Input Devices          │
                           └────────────────────────────────┘
```

**Ringkasan Hierarki:**

1. **Wayland** menyediakan *protokol dasar* dan *library komunikasi* antar klien dan kompositor.
2. **SwayWM** adalah *compositor + window manager* yang **mengimplementasikan Wayland** melalui **wlroots** (framework berbasis C).
3. **wlroots** menjadi lapisan penghubung antara **SwayWM** dan **kernel Linux**, menangani grafik, input, serta rendering.
4. **Wayland clients** (aplikasi) berinteraksi dengan **SwayWM** menggunakan protokol Wayland melalui soket IPC.

Dengan demikian, *SwayWM adalah implementasi dari Wayland compositor berbasis wlroots*, sementara Wayland sendiri adalah *spesifikasi protokol dan ekosistem library* yang memungkinkan komunikasi grafis modern tanpa X11.

---

Berdasarkan dokumentasi resmi Sway, berikut adalah ringkasan, arsitektur, panduan konfigurasi yang mencakup struktur file, sintaks dasar, hingga konfigurasi untuk input, output, dan komponen lainnya.

# Ringkasan singkat SwayWM

Sway adalah **tiling Wayland compositor** yang dirancang sebagai pengganti drop-in untuk i3 (X11). Dikembangkan untuk bekerja di atas library **wlroots**, Sway menyediakan pengalaman manajemen jendela bertipe tiling dengan kompatibilitas konfigurasi i3, dukungan XWayland, IPC berbasis JSON, dan ekosistem utilitas (swaybar, swaylock, swayidle, dsb.). ([swaywm.org][1])

# Arsitektur dan komponen utama

* **wlroots** — library modular yang mengabstraksi DRM/KMS, EGL, libinput, XWayland, rendering, dan backend lain; wlroots menjadi fondasi teknis Sway untuk akses perangkat dan rendering. ([GitHub][2])
* **Sway (kompositor)** — program utama (C) yang mengimplementasikan manajemen tata letak tiling, binding keyboard, pengaturan output dan input, serta mengeksekusi konfigurasi pengguna. Sway ditulis dalam **bahasa C**. ([GitHub][3])
* **Utilitas pendukung** — `swaybar` (status bar), `swaylock` (lock screen), `swayidle` (idle management), `swaymsg` (CLI untuk IPC), dan daemon lain yang biasa disertakan di distribusi. ([GitHub][3])
* **XWayland** — lapisan kompatibilitas untuk menjalankan aplikasi X11 di dalam sesi Wayland ketika diperlukan. wlroots/Sway mengelolanya bila dipasang. ([GitHub][2])

# Fitur penting (apa yang membuat Sway menarik)

* Kompatibilitas konfigurasi i3: banyak konfigurasi i3 bisa langsung dipakai (salin `~/.config/i3/config` → `~/.config/sway/config`). ([wiki.archlinux.org][4])
* IPC JSON melalui Unix socket: alat eksternal dapat mengontrol Sway dengan `swaymsg` atau library yang membaca/menulis JSON. Ini membuka kemungkinan integrasi dengan skrip (bash, Python, Lua, Rust, dll.). ([GitHub][3])
* Tiling otomatis, layout fleksibel, multiple outputs, per-output config, dan binding keyboard/mouse yang kuat. ([swaywm.org][1])

# Konfigurasi — tempat dan konsep penting

* Lokasi konfigurasi umum: `~/.config/sway/config` (salin contoh dari `/etc/sway/config`). Banyak direktif mirip i3: `bindsym`, `workspace`, `output`, `input`, `exec`, dll. ([wiki.archlinux.org][4])
* Mode binding, per-output rules, floating windows, sway-specific blocks (status bar) dan per-app rules tersedia.
* Jalankan `sway` dari TTY; gunakan `sway -d` untuk debug/log; IPC socket biasanya tersedia via variabel lingkungan `SWAYSOCK` atau di path standar. ([GitHub][3])

# Pengembangan, modifikasi, dan prasyarat teknis

Jika tujuan Anda adalah **memodifikasi Sway** (menambah fitur di sumbernya) atau **membangun komponennya sendiri**, berikut ringkasan teknis dan langkah persiapan yang direkomendasikan.

Bahasa & teknologi inti:

* **Bahasa utama:** C (kode sumber Sway dan wlroots ditulis di C). ([Wikipedia][5])
* **Library inti:** `wlroots` (C), `libinput`, `libwayland`, `xkbcommon`, `cairo`, `pango`, `gdk-pixbuf`, `libevdev`, `mesa`/EGL/OpenGL, `xwayland` (opsional untuk kompatibilitas). ([GitHub][2])
* **Build system:** Meson + Ninja (Sway dan wlroots menggunakan Meson). Paket pengembangan (`-dev` / `-devel`) untuk tiap library diperlukan. ([GitHub][3])

Kemampuan dan pengalaman yang disarankan:

* **Wajib/kuat disarankan:** pemahaman bahasa C (pointers, memori, debugging), konsep Wayland (surfaces, compositors, protocols), dasar DRM/KMS dan EGL/OpenGL, cara kerja input (libinput), penggunaan Meson/Ninja, serta pengalaman menggunakan alat debugging (gdb, valgrind, logs). ([GitHub][2])
* **Opsional tapi membantu:** pengalaman dengan Rust atau Python bila ingin membuat alat eksternal yang terintegrasi lewat IPC; pengetahuan tentang XWayland bila butuh kompatibilitas aplikasi lama. ([GitHub][3])

Langkah teknis untuk memulai pengembangan:

1. Baca dokumentasi wlroots dan contoh-contohnya — wlroots menunjukkan pola integrasi perangkat keras dan protokol Wayland. ([GitHub][2])
2. Siapkan lingkungan build (install paket dev untuk `wayland`, `wayland-protocols`, `xkbcommon`, `libinput`, `cairo`, `pango`, `meson`, `ninja`, dll.). ArchWiki dan README proyek biasanya memuat daftar deps. ([wiki.archlinux.org][4])
3. Clone `wlroots` lalu `sway`; bangun wlroots dulu bila Anda bekerja dari master branch bersama Sway. Banyak panduan di blog/devlog yang menjelaskan langkah membangun gabungan wlroots + sway. ([bvngee.com][6])
4. Jalankan Sway dari TTY dengan debugging aktif (`sway -d 2> sway.log`) untuk melihat pesan runtime saat bereksperimen. ([GitHub][3])

# Cara memperluas fungsionalitas tanpa memodifikasi kode C

* **Skrip eksternal & status blocks**: banyak ekstensi dibuat hanya dengan skrip shell/Python/Node/Rust yang berkomunikasi lewat `swaymsg` atau menulis ke bar (i3bar protocol / swaybar). Ini adalah jalur tercepat untuk menambah fitur tanpa compile ulang. ([GitHub][3])
* **IPC (JSON)**: gunakan socket IPC untuk membaca status, mengubah layout, memindahkan jendela, dsb. Tersedia binding pihak ketiga untuk bahasa populer. ([GitHub][3])

# Keterbatasan dan hal yang perlu diperhatikan

* Karena berbasis Wayland, beberapa aplikasi X11 lama memerlukan XWayland—tidak semua perilaku X11 1:1 identik. ([GitHub][2])
* Pengalaman hardware-accelerated bergantung pada driver GPU, kernel, dan konfigurasi DRM/EGL; pengujian pada mesin nyata lebih representatif daripada VM kecuali VM memiliki passthrough GPU yang baik. ([GitHub][7])
* Ketergantungan ke wlroots berarti banyak keputusan arsitektural ditetapkan di layer tersebut; kontribusi fitur yang menyentuh rendering/input biasanya harus sinkron dengan desain wlroots. ([GitHub][2])

# Praktis: beberapa perintah & tip cepat

* Menyalin konfigurasi i3 → sway: `cp /etc/sway/config ~/.config/sway/config` lalu sesuaikan. ([wiki.archlinux.org][4])
* Mengirim perintah lewat IPC: `swaymsg 'workspace 2; exec alacritty'`. ([GitHub][3])
* Debugging runtime: `sway -d 2> ~/sway.log` untuk melihat pesan kesalahan/diagnostik. ([GitHub][3])

# Sumber resmi & bacaan lanjutan (direkomendasikan)

* Situs resmi Sway: swaywm.org — gambaran umum dan link dokumentasi. ([swaywm.org][1])
* Repositori GitHub Sway: `swaywm/sway` — README, wiki, issue tracker (bagus untuk contoh bug/patch). ([GitHub][3])
* wlroots: `swaywm/wlroots` — dokumentasi teknis dan contoh API. ([GitHub][2])
* ArchWiki Sway — panduan instalasi, konfigurasi, dan tips distribusi. ([wiki.archlinux.org][4])
* Wikipedia (ringkasan & sejarah singkat) — untuk konteks rilis dan penulis utama. ([Wikipedia][5])

# Rekomendasi langkah Anda berikutnya (direktif praktis)

1. Jika Anda ingin **memodifikasi** Sway: mulailah dengan mempelajari C dan konsep Wayland, lalu clone wlroots + sway, setup Meson/Ninja, dan jalankan build lokal. Ikuti issue/PR di GitHub untuk melihat pola kontribusi. ([GitHub][2])
2. Jika Anda ingin **mengembangkan plugin/fitur cepat**: gunakan `swaymsg`/IPC dan buat skrip (bash/Python/Lua/Rust) yang berinteraksi dengan Sway — ini sesuai dengan minat Anda pada TUI/CLI dan integrasi Neovim. ([GitHub][3])
3. Bila butuh panduan langkah-demi-langkah (mis. buat environment build di Archlinux, contoh modifikasi sederhana, atau template config i3→sway yang rapi), saya siapkan panduan terperinci beserta snippet konfigurasi dan perintah build.

---
<!--
Saya sudah menyiapkan overview lengkap ini sebagai peta besar: arsitektur, dependensi teknis, cara pengembangan, dan daftar sumber resmi. Jika Anda ingin, saya akan lanjutkan dengan salah satu dari opsi praktis di poin terakhir (mis. panduan *build-from-source* untuk Archlinux atau template konfigurasi `~/.config/sway/config` yang rapi dan komentari baris demi baris). Saya akan langsung membuatnya tanpa perlu pertanyaan lain.
-->

[1]: https://swaywm.org/?utm_source=chatgpt.com "Sway"
[2]: https://github.com/swaywm/wlroots?utm_source=chatgpt.com "swaywm/wlroots: A modular Wayland compositor library"
[3]: https://github.com/swaywm/sway?utm_source=chatgpt.com "swaywm/sway: i3-compatible Wayland compositor"
[4]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[5]: https://en.wikipedia.org/wiki/Sway_%28window_manager%29?utm_source=chatgpt.com "Sway (window manager)"
[6]: https://bvngee.com/blogs/compile-sway-and-wlroots-together-from-source?utm_source=chatgpt.com "Compiling Sway with wlroots from Source - Bvngee"
[7]: https://github.com/swaywm/sway/issues/4802?utm_source=chatgpt.com "Sway is laggy/unresponsive on VirtualBox Arch guest #4802"

### 📁 Dasar-Dasar File Konfigurasi Sway

File konfigurasi Sway (biasanya berada di `~/.config/sway/config`) adalah file teks yang berisi perintah-perintah yang dieksekusi saat Sway启动 . Ia memiliki beberapa fitur sintaksis inti:

| Fitur Sintaks | Deskripsi & Contoh |
| :--- | :--- |
| **Perintah Sederhana** | Satu perintah per baris. Contoh: `bindsym $mod+Return exec $term` . |
| **Line Continuation**| Gunakan `\` di akhir baris untuk memperpanjang satu perintah ke beberapa baris . |
| **Block Command** | Gunakan kurung kurawal `{}` untuk mengelompokkan beberapa sub-perintah di bawah satu perintah induk . |

**Contoh Blok Konfigurasi:**
```
# Contoh konfigurasi output dalam blok 
output eDP-1 {
    background ~/wallpaper.png fill # Set wallpaper dengan mode 'fill'
    resolution 1920x1080 # Set resolusi output
}
```
Kode di atas setara dengan menulis dua baris perintah terpisah: `output eDP-1 background ...` dan `output eDP-1 resolution ...` .

### ⌨️ Mendefinisikan Variabel dan Perintah Input

**1. Mendefinisikan Variabel**
Gunakan kata kunci `set` untuk mendefinisikan variabel yang dapat digunakan di seluruh konfigurasi. Variabel ini untuk keperluan internal Sway dan **bukan** Environment Variable shell .
```
# Definisi variabel umum 
set $mod Mod4 # Tombol Super/Windows sebagai modifier key
set $left h # Tombol arah (seperti Vim)
set $term foot # Terminal emulator pilihan
```

**2. Konfigurasi Perangkat Input**
Gunakan perintah `input` untuk mengonfigurasi keyboard, touchpad, dan perangkat input lainnya. Identifikasi perangkat dengan `identifier` dari `swaymsg -t get_inputs` .

**Konfigurasi Keyboard:**
```
# Konfigurasi layout keyboard (digunakan oleh semua perangkat keyboard)
input type:keyboard {
    xkb_layout us,id # Set layout keyboard US dan Indonesia
    xkb_variant colemak # Gunakan varian Colemak
    repeat_delay 300 # Delay sebelum key repeat (milidetik)
    repeat_rate 45 # Laju key repeat (karakter per detik) 
}
```

**Konfigurasi Touchpad:**
```
# Konfigurasi touchpad (digunakan oleh semua perangkat touchpad)
input type:touchpad {
    tap enabled # Aktifkan tap-to-click
    natural_scroll enabled # Aktifkan natural scroll
    clickfinger_button_map lrm # Map: 1jari=klik kiri, 2jari=klik kanan 
}
```

### 🖥️ Mengatur Output dan Tampilan

Gunakan perintah `output` untuk mengonfigurasi monitor dan tampilan. Dapatkan nama output dengan `swaymsg -t get_outputs` .

**Konfigurasi Dasar Output:**
```
# Contoh konfigurasi untuk monitor HDMI
output "HDMI-A-1" {
    mode 1920x1080@60Hz # Set resolusi dan refresh rate 
    position 1920 0 # Posisikan monitor di koordinat (1920, 0)
    scale 1 # Faktor skala (gunakan 2 untuk layar HiDPI) 
    background ~/wallpaper.png fill # Set wallpaper, # Alternatif warna polos: background #RRGGBB solid_color 
}
```

**Mode dan Posisi Lanjutan:**
- `mode --custom 2560x1080@74.99Hz`: Memaksa mode kustom .
- `transform 90`: Memutar output 90 derajat .
- `adaptive_sync on`: Mengaktifkan Adaptive Sync/VRR jika didukung .
- `max_render_time 1`: Mengoptimalkan latensi render .

### 🔧 Konfigurasi dan Perintah Runtime Lainnya

**1. Mengelola Window dan Workspace**
- `bindsym $mod+1 workspace number 1`: Binds a key to switch to workspace 1.
- `bindsym $mod+Shift+1 move container to workspace number 1`: Binds a key to move the focused window to workspace 1.
- `floating enable`, `fullscreen enable`: Mengubah mode jendela .
- `layout tabbed`: Mengubah tata letak workspace menjadi tabbed .

**2. Mengatur Variabel Lingkungan**
Variabel lingkungan untuk aplikasi (seperti `MOZ_ENABLE_WAYLAND=1`) tidak dapat diekspor langsung dari file konfigurasi Sway. Cara yang direkomendasikan adalah dengan **menjalankan Sway menggunakan wrapper script** .

Buat sebuah script, contohnya `~/.local/bin/sway-launch`:
```bash
#!/bin/sh
# Wrapper script untuk mengekspor environment variables sebelum menjalankan Sway
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
exec sway
```
Set script sebagai executable (`chmod +x ~/.local/bin/sway-launch`) dan jalankan Sway melalui script ini, misalnya dari `~/.xinitrc` .

**3. Konfigurasi Swaynag (Notifikasi Sistem)**
Swaynag adalah sistem notifikasi untuk Sway. Anda dapat mengonfigurasi penampilannya melalui file di `~/.config/swaynag/config` .
```
# Contoh konfigurasi default Swaynag
font=Monospace 12
edge=top

# Tipe kustom untuk notifikasi update
[update]
background=009900
border=006600
text=FFFFFF
button-background=00AA00
```

### 💡 Saran untuk Orkestrasi dan Automasi

Bash dan Lua yang sudah Anda pelajari merupakan fondasi yang sangat baik untuk mengotomasi Sway.

- **Bash**: Ideal untuk menulis **script automasi** yang dijalankan oleh Sway. Contohnya, script untuk mengatur monitor secara dinamis, atau menu kustom yang dijalankan dengan `bindsym ... exec /path/to/script.sh` .
- **Lua**: Meski Sway tidak mengeksekusi konfigurasi langsung dalam Lua, Anda bisa **menggunakan Lua untuk menghasilkan file konfigurasi Sway**. Ini sangat powerful untuk mengelola konfigurasi yang kompleks dan dinamis dengan memanfaatkan struktur data seperti Tabel.

**Contoh Potongan Ide dengan Lua:**
```lua
-- Contoh: Generate konfigurasi output untuk multi-monitor
local outputs = {
    { name = "HDMI-A-1", pos = "0 0", wall = "~/wall1.png" },
    { name = "eDP-1", pos = "1920 0", wall = "~/wall2.png" }
}

for _, o in ipairs(outputs) do
    print(string.format("output %s { pos %s bg %s fill }", o.name, o.pos, o.wall))
end
```
Jalankan script Lua tersebut dan simpan outputnya ke file, atau gunakan dalam script build system seperti `make` untuk menghasilkan konfigurasi final. **Saat ini, Anda tidak perlu mempelajari bahasa pemrograman baru** karena Bash dan Lua sudah cukup untuk memulai.

### 🔍 Sumber Referensi Tambahan

Untuk informasi yang lebih mendalam, Anda dapat merujuk langsung ke halaman manual (manpages) yang menjadi sumber utama dokumen ini:
- `man 5 sway` - Konfigurasi umum dan command runtime .
- `man 5 sway-input` - Konfigurasi perangkat input secara detail .
- `man 5 sway-output` - Konfigurasi output secara detail .
- `man 5 swaynag` - Konfigurasi sistem notifikasi .

Konfigurasi Sway sangat fleksibel. Mulailah dengan file konfigurasi dasar, lalu secara bertahap tambahkan dan sesuaikan baris-baris konfigurasi sesuai kebutuhan workflow Anda. Penjelasan diatas sudah **cukup solid untuk dasar-dasar konfigurasi Sway**, namun **belum sepenuhnya mewakili semua yang ada di man pages**. Berikut analisis detailnya:

## ✅ **Apa yang Sudah Tercover dengan Baik Pada Penjelasan Ddiatas:**

- **Struktur file config** dan sintaks dasar
- **Variabel dan input configuration** 
- **Output configuration** (resolusi, posisi, wallpaper)
- **Key binding** dasar dan workspace management
- **Environment variables** approach via wrapper script
- **Swaynag configuration** dasar

## ❌ **Apa yang Masih Perlu Ditambahkan dari Man Pages:**

### **1. Dari `man 5 sway` - Bagian CRITICAL yang Missing:**

**Window Rules dan Criteria:**
```
# Syntax: for_window [criteria] <command>
for_window [title="Firefox"] floating enable
for_window [app_id="foot"] border pixel 2
for_window [class="^.*"] inhibit_idle focus  # Prevent idle when focused
```

**Assignment Rules:**
```
# Auto-assign aplikasi ke workspace tertentu
assign [app_id="spotify"] → 9
assign [class="Discord"] → 5
```

**Mode Configuration:**
```
# Custom modes selain default
mode "resize" {
    bindsym Left resize shrink width 10px
    bindsym Right resize grow width 10px
    bindsym Escape mode "default"
}
```

**Color Configuration:**
```
# Syntax: <border> <background> <text> <indicator> <child_border>
client.focused          #2e9ef4 #2e9ef4 #ffffff #2e9ef4 #2e9ef4
client.unfocused        #555555 #222222 #888888 #292d2e #222222
client.focused_inactive #5f676a #5f676a #ffffff #5f676a #5f676a
```

### **2. Dari `man 5 sway-input` - Input Advanced:**

**Device-Specific Configuration:**
```
input "1234:5678:My_Keyboard" {
    xkb_layout us,id
    xkb_options grp:win_space_toggle  # Toggle layout dengan Win+Space
    repeat_delay 300
    repeat_rate 45
}

input "1234:5678:My_Touchpad" {
    dwt enabled                    # disable while typing
    middle_emulation enabled       # emulation klik tengah
    tap_button_map lrm             # left-right-middle
    scroll_method two_finger
}
```

### **3. Dari `man 5 sway-output` - Output Advanced:**

**Scale Configuration untuk HiDPI:**
```
output "eDP-1" {
    scale 2                        # Untuk display HiDPI
    scale_filter linear            # atau nearest, smart
    subpixel rgb                   # untuk text rendering yang lebih baik
}

output "DP-1" {
    mode 3840x2160@60Hz
    adaptive_sync on
    max_render_time 1
}
```

### **4. Security dan IPC Configuration:**

**Socket Configuration:**
```
# Set IPC socket location
ipc-socket ~/.config/sway/ipc.sock

# Security - disable socket jika diperlukan
# ipc-socket disable
```

## 🎯 **Rekomendasi untuk Pemula:**

**Untuk pemula, penjelasan sebelumnya SUDAH CUKUP** untuk membuat config functional. Namun **sangat disarankan** untuk melengkapi dengan:

### **Step-by-Step Learning Path:**

1. **Start dengan config dasar** yang sudah dijelaskan
2. **Pelajari criteria matching** untuk window rules:
   ```bash
   swaymsg -t get_tree | less  # Lihat properties window yang aktif
   ```
3. **Eksplor man pages secara bertahap:**
   ```bash
   man 5 sway          # Fokus pada section "CRITERIA" dan "COMMANDS"
   man 5 sway-input    # Fokus pada device-specific config
   man 5 sway-output   # Fokus pada multi-monitor setup
   ```

### **Template Config Structure yang Recommended:**

```
# ~/.config/sway/config - Minimal viable dengan semua essential sections

# Variables
set $mod Mod4

# Input configuration
input type:keyboard { ... }
input type:touchpad { ... }

# Output configuration  
output * { ... }
output specific { ... }

# Key bindings
bindsym $mod+Return exec $term
...

# Window rules & assignment
for_window [criteria] command
assign [criteria] → workspace

# Appearance (colors, borders, etc.)
client.focused ...

# Mode configuration
mode "resize" { ... }

# Status bar
bar { ... }
```

## 📚 **Sumber Referensi Lengkap:**

**Priority Reading Order:**
1. `man 5 sway` - **Section CRITERIA** dan **COMMANDS**
2. `man 5 sway-input` - **Device identification** dan **scroll methods**  
3. `man 5 sway-output` - **HiDPI** dan **adaptive sync**
4. `man sway` - **Runtime commands** dan **IPC**

**Online References:**
- [sway(5) man page online](https://man.archlinux.org/man/sway.5)
- [Sway Configuration Guide](https://github.com/swaywm/sway/wiki)

## 🎓 **Kesimpulan:**

**Untuk pemula: CUKUP** dengan penjelasan sebelumnya + tambahan window rules dan color configuration.

**Untuk advanced user: PERLU** mempelajari semua man pages secara detail, khususnya criteria matching dan device-specific configuration.

**Actionable next step:** Buat config dasar dulu, kemudian secara bertahap tambahkan fitur dari man pages sesuai kebutuhan workflow Anda.

Sekarang mari kita eksplorasi secara mendalam aspek-aspek advanced configuration Sway yang memang memerlukan pemahaman mendetail dari man pages.

## 🔍 **Advanced Criteria Matching**

### **1. Comprehensive Criteria Properties**

Dari `man 5 sway` section **CRITERIA**, terdapat banyak properti yang bisa digunakan:

```bash
# Multiple criteria combinations
for_window [app_id="firefox" title="Mozilla Firefox"] floating enable
for_window [app_id=".*" instance="^term$"] border pixel 2

# Berdasarkan tipe window
for_window [app_id="foot" con_mark="^urgent$"] urgent enable
for_window [shell=".*" window_type="dialog"] floating enable
for_window [window_type="menu"] floating enable, sticky enable

# Criteria berdasarkan state
for_window [con_id="123" floating] move position center
for_window [tiling] borders pixel 5
```

### **2. Regular Expression dalam Criteria**

```bash
# Regex untuk matching flexible
for_window [app_id="^firefox$" title=".*Private Browsing.*"] opacity 0.9
for_window [class="^(?i)spotify$"] inhibit_idle fullscreen
for_window [title=".*[Dd]ownload.*"] floating enable, move to workspace 9

# Negative matching
for_window [app_id="^(?!foot$).*"] focus_follows_mouse no
```

### **3. Dynamic Criteria dengan Marks**

```bash
# Set mark pada window tertentu
bindsym $mod+m mark "important"

# Gunakan mark dalam criteria
for_window [con_mark="important"] sticky enable, floating enable
for_window [con_mark="^work$"] move to workspace 2
```

## ⌨️ **Advanced Input Configuration**

### **1. Device-Specific Input Matching**

Dari `man 5 sway-input`, identifikasi perangkat secara spesifik:

```bash
# Dapatkan identifier perangkat
swaymsg -t get_inputs
# Output: "1234:5678:My_Keyboard"

# Konfigurasi berdasarkan identifier spesifik
input "1234:5678:Logitech_G_PRO" {
    xkb_layout us
    xkb_variant colemak
    repeat_delay 200
    repeat_rate 50
    scroll_method on_button_down
    scroll_button 272
}

input "1234:5679:Apple_Touchpad" {
    dwt enabled
    tap enabled
    natural_scroll disabled
    tap_button_map lrm
    calibration_matrix 1.0 0.0 0.0 0.0 1.0 0.0
}
```

### **2. Advanced Keyboard Configuration**

```bash
input type:keyboard {
    xkb_layout us,ru,de
    xkb_options grp:win_space_toggle,ctrl:nocaps
    xkb_numlock enable
    xkb_capslock disabled
    
    # Key repeat configuration
    repeat_delay 300
    repeat_rate 45
    
    # Macro keys atau special keys
    bindkeys {
        --whole-device
        XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
        XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
        XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
    }
}
```

## 🖥️ **Advanced Output Configuration**

### **1. Multi-Monitor Complex Setup**

```bash
# Dynamic workspace assignment per monitor
workspace 1 output HDMI-A-1
workspace 2 output HDMI-A-1
workspace 3 output DP-1
workspace 4 output DP-1

# Mode custom dengan timing details
output "HDMI-A-1" {
    mode 2560x1440@144.000Hz
    position 0,0
    scale 1.0
    subpixel bgr
    transform 270
    adaptive_sync on
    max_render_time 1
    background ~/wallpaper.png fill
}

# Fallback configuration
output "*" {
    background #000000 solid_color
    scale 1
}

# HiDPI dengan fractional scaling
output "eDP-1" {
    scale 1.5
    scale_filter smart
    bg ~/wallpaper-hidpi.png fill
}
```

### **2. Color Management & Gamma**

```bash
# Gamma correction dan color profile
output "DP-1" {
    gamma 1.0:0.909:0.833
    gamma 0.8:0.8:0.8
    gamma 0.454545:0.344:0.285
    
    # Color profile (jika supported)
    # color_profile /path/to/profile.icc
}
```

## ⚙️ **Advanced Runtime Commands & IPC**

### **1. Swaymsg dan IPC Control**

```bash
# Contoh script Bash untuk mengotomasi Sway via IPC
#!/bin/bash

# Focus window dengan criteria tertentu
swaymsg '[app_id="firefox"] focus'

# Move window ke workspace tertentu
swaymsg '[title="Discord"] move container to workspace 5'

# Resize window dengan criteria
swaymsg '[app_id="foot"] resize set width 1200 height 800'

# Get tree structure untuk debugging
swaymsg -t get_tree | jq '.. | select(.type?) | select(.type=="con")'
```

### **2. Event Handling dengan swaymsg -m**

```bash
# Monitor events secara real-time
swaymsg -m -t subscribe '["window"]' | while read event; do
    echo "Window event: $event"
    # Custom logic berdasarkan event
done
```

## 🎨 **Advanced Appearance & Themes**

### **1. Comprehensive Client Colors**

```bash
# Complete color configuration dari man 5 sway
client.focused          #4c7899 #4c7899 #ffffff #2e9ef4 #4c7899
client.focused_inactive #333333 #5f676a #ffffff #484e50 #5f676a
client.unfocused        #333333 #222222 #888888 #292d2e #222222
client.urgent           #2f343a #900000 #ffffff #900000 #900000
client.placeholder      #000000 #0c0c0c #ffffff #000000 #0c0c0c

client.background       #ffffff

# Border configuration
default_border pixel 3
default_floating_border normal 2
smart_borders on
smart_gaps inverse_outer
```

### **2. Advanced Bar Configuration**

```bash
bar {
    position top
    mode dock
    hidden_state hide
    modifier Mod4
    
    # Multiple outputs
    output HDMI-A-1
    output DP-1
    tray_output primary
    
    # Status commands dengan formatting
    status_command while ~/.config/sway/status.sh; do sleep 1; done
    
    # Workspace buttons configuration
    workspace_buttons yes
    strip_workspace_numbers yes
    workspace_min_width 100
    
    # Colors dengan semua state
    colors {
        background #000000
        statusline #ffffff
        focused_workspace  #4c7899 #4c7899 #ffffff
        active_workspace   #333333 #333333 #ffffff
        inactive_workspace #333333 #333333 #888888
        urgent_workspace   #2f343a #900000 #ffffff
        binding_mode       #2f343a #900000 #ffffff
    }
    
    # Font dengan fallback
    font pango:Monospace 10, FontAwesome 10
}
```

## 🔧 **Performance & Optimization**

### **1. Render Optimization**

```bash
# Dari man 5 sway-output
output "*" {
    max_render_time 1
    adaptive_sync on
}

# Memory management
max_render_time off
```

### **2. Input Latency Optimization**

```bash
input "1234:5678:Gaming_Mouse" {
    accel_profile flat
    pointer_accel 0.0
    scroll_method on_button_down
    scroll_button 273
    drag_lock enabled
}
```

## 🛠️ **Advanced Scripting dengan Bash & Lua**

### **1. Bash Script untuk Dynamic Configuration**

```bash
#!/bin/bash
# ~/.config/sway/scripts/monitor-setup.sh

# Detect connected monitors
MONITORS=$(swaymsg -t get_outputs | jq -r '.[] | .name')

for MONITOR in $MONITORS; do
    case $MONITOR in
        "HDMI-A-1")
            swaymsg output "$MONITOR" pos 0 0 res 2560x1440@120Hz
            ;;
        "DP-1") 
            swaymsg output "$MONITOR" pos 2560 0 res 1920x1080@60Hz
            ;;
        *)
            swaymsg output "$MONITOR" disable
            ;;
    esac
done
```

### **2. Lua Script untuk Config Generation**

```lua
-- ~/.config/sway/generate-config.lua
local config = {
    outputs = {
        { name = "HDMI-A-1", pos = "0 0", res = "2560x1440", rate = 120 },
        { name = "DP-1", pos = "2560 0", res = "1920x1080", rate = 60 }
    },
    workspaces = {
        { number = 1, output = "HDMI-A-1", apps = {"firefox"} },
        { number = 2, output = "HDMI-A-1", apps = {"foot"} },
        { number = 3, output = "DP-1", apps = {"spotify"} }
    }
}

-- Generate output configuration
for _, output in ipairs(config.outputs) do
    print(string.format("output %s { position %s mode %s@%dHz }", 
        output.name, output.pos, output.res, output.rate))
end

-- Generate workspace assignment
for _, ws in ipairs(config.workspaces) do
    print(string.format("workspace %d output %s", ws.number, ws.output))
    for _, app in ipairs(ws.apps) do
        print(string.format("assign [app_id=\"%s\"] %d", app, ws.number))
    end
end
```

## 📚 **Sumber Referensi Advanced**

### **Command untuk Explorasi Manual:**

```bash
# Lihat semua properties yang tersedia untuk criteria
man 5 sway | grep -A 50 "CRITERIA"

# Explore current state
swaymsg -t get_inputs
swaymsg -t get_outputs  
swaymsg -t get_tree
swaymsg -t get_seats

# Debug configuration
swaymsg -t get_config
swaymsg debuglog on
```

### **Key Man Pages untuk Advanced Users:**
- `man 5 sway` - **Section CRITERIA** (halaman 3-5)
- `man 5 sway-input` - **Device matching** dan **scroll methods**
- `man 5 sway-output` - **Color management** dan **gamma correction**
- `man sway` - **IPC commands** dan **runtime control**
- `man swaymsg` - **Event subscription** dan **JSON output**

## 🎯 **Kesimpulan Advanced**

Untuk menjadi advanced user Sway, Anda perlu memahami:

1. **Criteria matching yang komprehensif** dengan regex dan multiple conditions
2. **Device-specific configuration** dengan precise identifier matching  
3. **IPC dan scripting integration** untuk dynamic configuration
4. **Performance tuning** dengan render time dan adaptive sync
5. **Complex multi-monitor setup** dengan workspace assignment
<!--
Dengan Bash dan Lua yang sudah Anda kuasai dasar-dasarnya, Anda sudah memiliki fondasi yang kuat untuk membuat konfigurasi Sway yang sangat advanced dan terotomasi dengan baik.
-->

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

[a]: ./bagian-1/README.md
[b]: ./bagian-2/README.md
[c]: ./bagian-3/README.md
[d]: ./bagian-4/README.md
[e]: ./bagian-5/README.md
[f]: ./bagian-6/README.md
[g]: ./bagian-7/README.md










<!--
Kutipan

wayland.freedesktop.org
Wayland
Wayland is a replacement for the X11 window system protocol and architecture with the aim to be easier to develop, extend, and maintain.

wayland.freedesktop.org
Wayland
Wayland is the language (protocol) that applications can use to talk to a display server in order to make themselves visible and get input from the user (a person). A Wayland server is called a "compositor". Applications are Wayland clients.

wayland.freedesktop.org
Wayland
Wayland also refers to a system architecture. It is not just a server-client relationship between a compositor and applications. There is no single common Wayland server like Xorg is for X11, but every graphical environment brings with it one of many compositor implementations. Window management and the end user experience are often tied to the compositor rather than swappable components.

wayland.freedesktop.org
Wayland
A core part of Wayland architecture is libwayland: an inter-process communication library that translates a protocol definition in XML to a C language API. This library does not implement Wayland, it merely encodes and decodes Wayland messages. The actual implementations are in the various compositor and application toolkit projects.

wayland.freedesktop.org
Wayland
Wayland does not restrict where and how it is used. A Wayland compositor could be a standalone display server running on Linux kernel modesetting and evdev input devices or on many other operating systems, or a nested compositor that itself is an X11 or Wayland application (client). Wayland can even be used in application-internal communication as is done in some web browsers.

wayland.freedesktop.org
Chapter 4. Wayland Protocol and Model of Operation
Basic Principles

wayland.freedesktop.org
Chapter 4. Wayland Protocol and Model of Operation
Wire Format

wayland.freedesktop.org
Chapter 4. Wayland Protocol and Model of Operation
host's byte-order. The message header has 2 words in it:

en.wikipedia.org
Wayland (protocol) - Wikipedia
* wl_display – the core global object, a special object to encapsulate the Wayland protocol itself * wl_registry – the global registry object, in which the compositor registers all the global objects that it wants to be available to all clients * wl_compositor – an object that represents the compositor, and is in charge of combining the different surfaces into one output * wl_surface – an object representing a rectangular area on the screen, defined by a location, size and pixel content * wl_buffer – an object that, when attached to a wl_surface object, provides

wayland.freedesktop.org
Chapter 4. Wayland Protocol and Model of Operation
The interfaces, requests and events are defined in `protocol/wayland.xml`. This xml is used to generate the function prototypes that can be used by clients and compositors.

en.wikipedia.org
Wayland (protocol) - Wikipedia
The Wayland Display Server project was started by Red Hat developer Kristian Høgsberg in 2008.[ 15 ]

en.wikipedia.org
Wayland (protocol) - Wikipedia
Initial release 30 September 2008; 17 years ago (2008-09-30)[ 1 ] Stable release

tuxedocomputers.com
What's the deal with X11 and Wayland? - TUXEDO Computers
Since the code of X11 has long been a barely maintainable patchwork, a new project was started in 2008 to replace X11 one day: the Display Server Protocol Wayland. It is supposed to bring more security by abandoning the client-server model and executing far less code as root and also make image glitches like tearing, image flickering, and artifacts a thing of the past.

wayland.freedesktop.org
Wayland
As suggested above, there are a few problems with this approach. The X server doesn't have the information to decide which window should receive the event, nor can it transform the screen coordinates to window-local coordinates. And even though X has handed responsibility for the final painting of the screen to the compositing manager, X still controls the front buffer and modesetting. Most of the complexity that the X server used to handle is now available in the kernel or self contained libraries (KMS, evdev, mesa, fontconfig, freetype, cairo, Qt, etc). In general, the X server is now just a middle man that introduces an extra step between applications and the compositor and an extra step between the compositor and the hardware.

en.wikipedia.org
Wayland (protocol) - Wikipedia
> What's different now is that a lot of infrastructure has moved from the X server into the kernel (memory management, command scheduling, 130) or libraries (cairo , pixman, 132, fontconfig , 134, etc.), and there is very little left that has to happen in a central server process. ... [An X server has] a tremendous amount of functionality that you must support to claim to speak the X protocol, yet nobody will ever use this. ... This includes code tables, glyph rasterization and caching, XLFDs (seriously, XLFDs!), and the entire core rendering API that lets you draw stippled lines, polygons, wide arcs and many more state-of- the-1980s style graphics primitives. For many things we've been able to keep the

en.wikipedia.org
Wayland (protocol) - Wikipedia
as a free and 112 community-driven project with the aim of replacing the X Window System with a secure[ 10 ][ 11 ][ 12 ][ 13 ] and simpler 104 for Linux and other 114 operating systems.[ 9 ][ 14 ] The project's source code is published under the terms of the MIT License , a 115.[ 14 ][ 6 ] The Wayland project also develops an implementation of a Wayland compositor called Weston.[ 9 ]

wayland.freedesktop.org
Wayland
In wayland the compositor is the display server. We transfer the control of KMS and evdev to the compositor. The wayland protocol lets the compositor send the input events directly to the clients and lets the client send the damage event directly to the compositor:

wayland.freedesktop.org
Wayland
1. The kernel gets an event and sends it to the compositor. This is similar to the X case, which is great, since we get to reuse all the input drivers in the kernel. 2. The compositor looks through its scenegraph to determine which window should receive the event. The scenegraph corresponds to what's on screen and the compositor understands the transformations that it may have applied to the elements in the scenegraph. Thus, the compositor can pick the right window and transform the screen coordinates to window-local coordinates, by applying the inverse transformations. The types of transformation that can be applied to a

wayland.freedesktop.org
Wayland
3. As in the X case, when the client receives the event, it updates the UI in response. But in the wayland case, the rendering happens in the client, and the client just sends a request to the compositor to indicate the region that was updated. 4. The compositor collects damage requests from its clients and then recomposites the screen. The compositor can then directly issue an ioctl to schedule a pageflip with KMS.

wayland.freedesktop.org
Wayland
rendering, the client and the server share a video memory buffer. The client links to a rendering library such as OpenGL that knows how to program the hardware and renders directly into the buffer. The compositor in turn can take the buffer and use it as a texture when it composites the desktop. After the initial setup, the client only needs to tell the compositor which buffer to use and when and where it has rendered new content into it.

wayland.freedesktop.org
Wayland
4. The compositor collects damage requests from its clients and then recomposites the screen. The compositor can then directly issue an ioctl to schedule a pageflip with KMS.

wayland.freedesktop.org
Chapter 4. Wayland Protocol and Model of Operation
The server sends back events to the client, each event is emitted from an object. Events can be error conditions. The event includes the object ID and the event opcode, from which the client can determine the type of event. Events are generated both in response to requests (in which case the request and the event constitutes a round trip) or spontaneously when the server state changes.

en.wikipedia.org
Wayland (protocol) - Wikipedia
XWayland is an X Server running as a Wayland client, and thus is capable of displaying native X11 client applications in a Wayland compositor environment.[ 54 ][ 55 ] This is similar to the way XQuartz runs X applications in macOS's native windowing system. The goal of XWayland is

tuxedocomputers.com
What's the deal with X11 and Wayland? - TUXEDO Computers
Differences between X11 and Wayland

theserverhost.com
X11 vs Wayland - Which one to choose? Key Differences
X11: Think of X11 like an old office setup — everything has to go through a central manager  (the X server) who takes orders from apps, passes them to the hardware, and sends responses back. This adds extra steps, which can slow things down and create more complexity.

theserverhost.com
X11 vs Wayland - Which one to choose? Key Differences
1. Better performance: Smooth graphics with reduced latency and less screen tearing. 2. Stronger security: Apps are isolated; no input or window snooping. 3. Simpler architecture: Fewer layers, making it easier to develop and maintain. 4. Energy-efficient: Helps extend battery life on laptops by reducing overhead.

theserverhost.com
X11 vs Wayland - Which one to choose? Key Differences
1. Mature and stable: Decades of development make it reliable. 2. Broad compatibility: Works with nearly all Linux apps, drivers, and toolkits. 3. Remote display support: Enables network-transparent app forwarding (X forwarding). 4. Highly customizable: Extensive extensions, window managers, and compositors.

tuxedocomputers.com
What's the deal with X11 and Wayland? - TUXEDO Computers
Wayland does not implement all functions of the X server for security reasons. For example, Wayland does not support the network transparency familiar from X11, which enables functions such as screen recording and screencasting. Functions like that must be implemented in Wayland by protocol extensions, which drags out the implementation of the protocol in time. Currently, Wayland is

theserverhost.com
X11 vs Wayland - Which one to choose? Key Differences
2.2 X forwarding, Remote Desktop and Network Transparency

docs.fedoraproject.org
The Wayland Protocol :: Fedora Docs
Wayland is enabled by default in the GNOME Desktop. You can choose to run GNOME in X11 by choosing the Gnome on xorg option in the session chooser on the login screen. Currently KDE still uses X11 and although there is a plasma-wayland session available, it is not considered stable or bugfree at this time.

phoronix.com
Wayland's Wild 2024 With Better KDE Plasma Support, NVIDIA Maturity & More Desktops - Phoronix
KDE's KWin Merges Wayland Explicit Sync Support A day after explicit sync support was merged for XWayland, a week after explicit sync support for Mesa Vulkan drivers hit Mesa 24.1, and GNOME's Mutter enabling explicit sync at the end of March, KDE's KWin compositor has now merged its Wayland explicit sync support!

tuxedocomputers.com
What's the deal with X11 and Wayland? - TUXEDO Computers
While the development of the Wayland protocol is complete, the implementation in the desktop environments under Linux is in different stages. The integration is most advanced with GNOME, followed by KDE Plasma. Xfce and LXQt are just taking their first steps in this direction. Already since 2015, the rather unknown window manager Enlightenment has supported the Wayland protocol. However, there is no rush because X11 will be with us for a while, even if it will increasingly fade into the background. In the transition phase, in which not all applications yet support Wayland, XWayland serves as a compatibility layer.

docs.fedoraproject.org
The Wayland Protocol :: Fedora Docs
One way to determine if you’re running in Wayland, is to check the value of the variable $WAYLAND_DISPLAY. To do this type:

en.wikipedia.org
Wayland (protocol) - Wikipedia
Written inC 96Official: Linux Unofficial: 98, FreeBSD , 100, DragonFly BSD [ 4 ] Compatibility layer: 102[ 5 ] Type

en.wikipedia.org
Wayland (protocol) - Wikipedia
Repository

wayland.freedesktop.org
Wayland
Development:

wayland.freedesktop.org
Wayland
Development:

docs.fedoraproject.org
The Wayland Protocol :: Fedora Docs
Wayland is a display server protocol which was (at the time of writing) introduced as the default in GNOME. It is said that Wayland will eventually replace X11 as the default display server on Linux and many distributions have begun implementation of Wayland. Wayland is a more modern protocol and has a smaller code base currently. Wayland is still under development, and there are still applications and behaviours that don’t work as expected, you may find that some applications have not been updated to work properly in Wayland and currently the only way these applications will run is using Xorg instead of Wayland. This includes some legacy system applications and games.

en.wikipedia.org
Wayland (protocol) - Wikipedia
Wayland is a communication protocol that specifies the communication between a 105 and its clients, as well as a C library implementation of that protocol.[ 9 ] A display server using the Wayland protocol is called a 30, because it additionally performs the task of a compositing window manager.
Semua Sumber

wayland.freedesktop
5

en.wikipedia
8

phoronix
2

docs.fedoraproject

tuxedocomputers

theserverhost
-->

<!--
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[home]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md


-->
[0]: ./../sway/README.md
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

