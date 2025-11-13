# Lapisan 1 — Kernel & Subsystem Grafis (1-150)

> Catatan: untuk istilah-istilah inti saya sertakan sumber rujukan utama di akhir.

---

1. **Linux Kernel / Kernel Linux** · *Lapisan 1*
   Deskripsi: Inti sistem operasi yang menangani manajemen perangkat keras, termasuk subsistem grafis dan input.
   Identitas: Dibangun utama dengan **C** (repositori: kernel.org).
   Prasyarat modifikasi: Penguasaan C, proses build kernel, git, tooling cross-compile, debugging kernel (kgdb, printk).

2. **Direct Rendering Manager (DRM) / Manajer Rendering Langsung** · *Lapisan 1*
   Deskripsi: Subsystem kernel yang menyediakan API untuk mengelola GPU, memori grafis, dan output.
   Identitas: Implementasi di kernel (C), bagian dari tree DRM pada kernel.
   Prasyarat modifikasi: C kernel driver development, pemahaman ioctls/uapi, pengujian hardware. ([manpages.debian.org][1])

3. **Kernel Mode Setting (KMS) / Pengaturan Mode Kernel** · *Lapisan 1*
   Deskripsi: Bagian DRM yang menangani pengaturan mode tampilan (resolusi, refresh rate) dari level kernel.
   Identitas: API/implementasi di DRM (C).
   Prasyarat modifikasi: Memahami DRM internals, struktur `drm_device`, Meson/CMake untuk build kernel modules. ([kernel.org][2])

4. **Framebuffer (fbdev) / Perangkat Framebuffer** · *Lapisan 1*
   Deskripsi: Abstraksi perangkat tampilan yang menyajikan buffer memori yang dapat digambar langsung oleh userland atau kernel.
   Identitas: Driver kernel C (`/dev/fb*`).
   Prasyarat modifikasi: C, subsistem framebuffer kernel, akses device nodes.

5. **Framebuffer Console (fbcon) / Konsol Framebuffer** · *Lapisan 1*
   Deskripsi: Konsol teks yang berjalan di atas framebuffer, berguna untuk boot-time atau sistem tanpa server grafis.
   Identitas: Kernel module C.
   Prasyarat modifikasi: Pemahaman subsistem konsol kernel dan framebuffer.

6. **DRM Driver (GPU kernel driver) / Driver GPU (DRM)** · *Lapisan 1*
   Deskripsi: Driver vendor-specific (mis. `i915`, `amdgpu`, `nouveau`) yang menghubungkan perangkat keras GPU ke DRM.
   Identitas: Ditulis dalam **C** sebagai modul kernel.
   Prasyarat modifikasi: Driver model GPU vendor, dokumentasi hardware (sering proprietary), debugging DMA.

7. **Device Node (/dev/dri, /dev/fb*) / Node Perangkat** · *Lapisan 1*
   Deskripsi: File perangkat yang diekspos kernel untuk userland berinteraksi dengan DRM/fb.
   Identitas: Dihasilkan oleh kernel dan udev (C).
   Prasyarat modifikasi: Pengetahuan udev rules, permission, major/minor device.

8. **libdrm / Library libdrm** · *Lapisan 1*
   Deskripsi: Library pengguna ruang (userspace) yang membungkus pemanggilan DRM kernel (ioctl, mmap) untuk aplikasi dan driver userland.
   Identitas: Implementasi userspace dalam **C** (proyek libdrm).
   Prasyarat modifikasi: C, pemahaman DRM uapi, build system autotools/meson. ([manpages.debian.org][1])

9. **Mesa / Mesa 3D Graphics Library** · *Lapisan 1*
   Deskripsi: Implementasi open-source untuk OpenGL/OpenGL ES/Vulkan dan driver userspace (Gallium), menyediakan rendering GPU.
   Identitas: Implementasi utama berbasis **C/C++** (projek Mesa).
   Prasyarat modifikasi: C/C++, spesifikasi grafis (OpenGL/Vulkan), build (meson/ninja), pemahaman shader compiler. ([docs.mesa3d.org][3])

10. **DRM UAPI / DRM IOCTL (User API)** · *Lapisan 1*
    Deskripsi: Antarmuka pengguna-kernel (ioctl/syscalls) yang digunakan aplikasi untuk mengontrol DRM (pembuatan buffer, modeset, page-flip).
    Identitas: Didefinisikan di header kernel (C).
    Prasyarat modifikasi: Memahami struktur uapi, ABI compatibility, header kernel.

11. **GEM (Graphics Execution Manager) / GEM** · *Lapisan 1*
    Deskripsi: Manajer memori grafis di DRM untuk alokasi/buffer handling antara kernel dan userspace.
    Identitas: Implementasi di kernel (C).
    Prasyarat modifikasi: Memahami memory management GPU, mmap, sync primitives.

12. **TTM (Translation Table Manager) / TTM** · *Lapisan 1*
    Deskripsi: Alternatif manajer memori DRM yang menangani berbagai jenis GPU (historis/opsional).
    Identitas: Kernel C (bagian DRM memory managers).
    Prasyarat modifikasi: Pengetahuan manajemen memori GPU dan arsitektur driver.

13. **CRTC / Cathode Ray Tube Controller (logical scanout) / CRTC** · *Lapisan 1*
    Deskripsi: Elemen DRM yang mewakili mesin scanout (penjadwalan tampilan) — menghubungkan framebuffer ke connector melalui encoder.
    Identitas: Konsep dan struktur di kernel DRM (C).
    Prasyarat modifikasi: Paham DRM pipeline (CRTC/encoder/connector/plane).

14. **Connector / Encoder / Plane (DRM pipeline)** · *Lapisan 1*
    Deskripsi: Komponen pipeline KMS: *connector* (port fisik), *encoder* (format/encoder), *plane* (layer/overlay) untuk komposisi.
    Identitas: Struktur kernel DRM (C).
    Prasyarat modifikasi: Pemahaman hardware display controller dan KMS.

15. **Atomic Modesetting / Atomic KMS** · *Lapisan 1*
    Deskripsi: Metode modeset yang memperlakukan konfigurasi display sebagai operasi atomik lengkap untuk menghindari tearing dan inkonsistensi.
    Identitas: API/fitur di DRM kernel (C).
    Prasyarat modifikasi: Paham state management DRM dan locking/rollback.

16. **VBlank & Page-flip / Sinkronisasi VBlank & Flip Halaman** · *Lapisan 1*
    Deskripsi: Mekanisme sinkronisasi vertical-blanking untuk mengganti buffer (page-flip) tanpa tearing.
    Identitas: Di-handle oleh DRM kernel dan exposed ke userspace.
    Prasyarat modifikasi: Paham interrupt, timing, dan event handling kernel.

17. **dma-buf / DMA-BUF (shared buffer) / Berbagi buffer DMA** · *Lapisan 1*
    Deskripsi: Mekanisme untuk berbagi buffer GPU antara berbagai perangkat/subsystem tanpa copy (mis. antara GPU dan VPU).
    Identitas: Kernel API (C) dengan userspace helpers.
    Prasyarat modifikasi: Pemahaman DMA, pinning pages, sync fences.

18. **PRIME / PRIME (GPU buffer sharing & offload)** · *Lapisan 1*
    Deskripsi: Mekanisme kernel/userspace untuk mentransfer buffer atau rendering antar-GPU pada sistem multi-GPU.
    Identitas: Implementasi di kernel DRM + userspace (C).
    Prasyarat modifikasi: Multi-GPU architecture knowledge, dma-buf.

19. **GPU Memory (VRAM / GTT) / Memori GPU (VRAM, GTT)** · *Lapisan 1*
    Deskripsi: Konsep memori GPU (dedicated VRAM) dan aperture/mappings (Graphics Translation Table) untuk akses CPU/GPU.
    Identitas: Hardware concept dan kernel handling (C).
    Prasyarat modifikasi: Memahami address space GPU, mmap, and caching.

20. **IOMMU / I/O Memory Management Unit** · *Lapisan 1*
    Deskripsi: Unit manajemen memori perangkat yang memetakan DMA sehingga perangkat (GPU) dapat mengakses memori aman/virtualized.
    Identitas: Kernel subsystem (C).
    Prasyarat modifikasi: Pengetahuan tentang DMA, VFIO, dan keamanan memori.

21. **Kernel Module / Modul Kernel** · *Lapisan 1*
    Deskripsi: Komponen biner loadable (.ko) yang memperluas fungsi kernel (mis. driver GPU).
    Identitas: Ditulis dalam C; dikompilasi ke modul kernel.
    Prasyarat modifikasi: Menulis kode kernel, Makefile/Kbuild, insmod/modprobe, symbol exports.

22. **Firmware Blobs / Firmware GPU** · *Lapisan 1*
    Deskripsi: Biner firmware yang dimuat driver GPU untuk inisialisasi perangkat keras; sering proprietary.
    Identitas: File binari; dimuat oleh driver kernel (C).
    Prasyarat modifikasi: Biasanya tidak bisa dimodifikasi kecuali vendor membuka sumber; paham cara packaging firmware.

23. **Kernel Logs / dmesg / Log Kernel** · *Lapisan 1*
    Deskripsi: Output diagnostik kernel yang berguna untuk debug driver GPU dan subsistem grafis.
    Identitas: Tooling userspace (`dmesg`, journalctl) membaca pesan printk kernel.
    Prasyarat modifikasi: Kemampuan membaca logs, menambahkan printk, tracing (ftrace).

24. **udev / udev (Device Manager)** · *Lapisan 1*
    Deskripsi: Daemon userspace untuk men-generate device nodes dan rule ketika perangkat terdeteksi (mengatur `/dev` dan permissions).
    Identitas: Implementasi userspace **C** (systemd-udev).
    Prasyarat modifikasi: Menulis udev rules, memahami sysfs atribut.

25. **Kernel Input Subsystem / Subsystem Input Kernel** · *Lapisan 1*
    Deskripsi: Subsystem kernel yang membaca event dari hardware input (keyboard, mouse, touch) dan mengeksposnya ke userspace.
    Identitas: Kernel C (evdev, input core).
    Prasyarat modifikasi: C kernel input driver development.

26. **evdev / evdev (Event Device Interface)** · *Lapisan 1*
    Deskripsi: Antarmuka character device `/dev/input/event*` yang menyampaikan event input dari kernel ke userspace.
    Identitas: Kernel API (C) dengan userspace bindings.
    Prasyarat modifikasi: Memahami input event format dan udev.

27. **libinput / libinput (Input Library)** · *Lapisan 1*
    Deskripsi: Library userspace untuk menstandardisasi penanganan input (detect, filter, gestures) pada compositors Wayland dan X.
    Identitas: Implementasi userspace **C** (freedesktop.org).
    Prasyarat modifikasi: C, event handling, integrasi ke compositor. ([wayland.freedesktop.org][4])

28. **HID (Human Interface Device) / Perangkat Antar-Muka Manusia** · *Lapisan 1*
    Deskripsi: Standar kelas perangkat (USB HID, Bluetooth HID) untuk keyboard, mouse, dan input lainnya; di-handle oleh kernel (usbhid).
    Identitas: Kernel drivers C + protokol USB/HID.
    Prasyarat modifikasi: Protokol USB/HID dan driver kernel.

29. **Input Device Nodes (/dev/input/event*, /dev/input/by-*) / Node Perangkat Input** · *Lapisan 1*
    Deskripsi: File perangkat yang mewakili device input; digunakan oleh libinput/evdev untuk membaca event.
    Identitas: Dihasilkan oleh kernel + udev.
    Prasyarat modifikasi: udev rules, permission, debugging evdev streams.

30. **Graphics Scanout & Composition (Scanout, Compositor handoff) / Scanout & Komposisi** · *Lapisan 1*
    Deskripsi: Konsep aliran data dari framebuffer/plane (scanout) menuju display, serta titik di mana compositor mengambil buffer untuk dirender/komposisi.
    Identitas: Konsep yang diimplementasikan melalui DRM/KMS + userspace compositor (C/C++/Rust).
    Prasyarat modifikasi: Memahami full pipeline DRM → dma-buf → compositor render → display.

---

#### Lapisan ini berfokus pada komponen tingkat rendah dari sistem grafis Linux—yaitu subsistem kernel yang menangani buffer, driver, interrupt, input, dan komunikasi antara perangkat keras dan ruang pengguna.

---

**31. PCIe (Peripheral Component Interconnect Express)**
*Bahasa C; digunakan dalam kernel Linux*
Bus berkecepatan tinggi yang menghubungkan GPU, kartu suara, dan perangkat lain ke CPU. Setiap driver grafis kernel berinteraksi melalui bus PCIe.

**32. GPU Driver**
Modul kernel yang mengatur komunikasi antara sistem operasi dan GPU. Umumnya ditulis dalam C dan dibangun di atas DRM API.

**33. Firmware Blob**
Potongan kode biner tertutup yang dimuat oleh driver GPU atau perangkat keras lain saat inisialisasi.

**34. Interrupt Handler**
Fungsi kernel yang merespons sinyal perangkat keras seperti permintaan refresh frame dari GPU.

**35. VBlank (Vertical Blanking Interval)**
Jeda antara proses render satu frame dan berikutnya; digunakan compositor untuk sinkronisasi tampilan.

**36. Framebuffer Object (FBO)**
Struktur memori tempat pixel frame disimpan sebelum dikirim ke layar; menjadi dasar dari rendering pipeline.

**37. Render Node**
Antarmuka di DRM untuk akses GPU tanpa hak istimewa root—digunakan oleh compositor modern seperti Sway.

**38. GEM (Graphics Execution Manager)**
Subsystem DRM untuk mengelola buffer grafis (alokasi, referensi, dan sinkronisasi).

**39. TTM (Translation Table Maps)**
Lapisan manajemen memori GPU yang digunakan beberapa driver lama (sebelum GEM).

**40. DMA (Buffer / Direct Memory Access)**
Mekanisme pemindahan data langsung antara GPU dan RAM tanpa campur tangan CPU.

**41. KMS Atomic Mode Setting**
Fitur modern DRM yang memungkinkan pengaturan mode tampilan (resolusi, refresh rate) secara atomik — semua perubahan diterapkan sekaligus.

**42. Plane**
Lapisan tampilan dalam DRM — bisa berupa primary, overlay, atau cursor plane. Compositor memilih plane mana untuk setiap surface.

**43. CRTC (Cathode Ray Tube Controller)**
Komponen logis dalam DRM yang mengatur output ke monitor; meski istilahnya historis, masih digunakan.

**44. Connector**
Objek DRM yang mewakili port fisik seperti HDMI, DP, VGA, atau LVDS.

**45. Encoder**
Elemen DRM yang menerjemahkan sinyal CRTC ke format connector yang sesuai.

**46. fbdev (Framebuffer Device)**
Antarmuka grafis lama sebelum DRM; masih digunakan sistem lawas atau untuk boot splash.

**47. Input Subsystem**
Bagian kernel yang menangani keyboard, mouse, touchpad, tablet, dan perangkat input lain.

**48. evdev (Event Device)**
Driver generik untuk input di Linux — mendefinisikan cara aplikasi membaca event dari perangkat.

**49. libinput**
Perpustakaan pengguna (user space) berbasis C yang berinteraksi dengan evdev untuk gesture dan acceleration.

**50. udev**
Komponen user space systemd yang mendeteksi dan mengatur perangkat saat terhubung/dilepas.

**51. device node (/dev/ entries)**
File khusus di /dev yang menjadi representasi perangkat kernel; misal /dev/dri/card0 untuk GPU.

**52. sysfs (/sys filesystem)**
Filesystem virtual tempat kernel mengekspos informasi perangkat dan parameter runtime.

**53. modprobe**
Utilitas CLI untuk memuat atau menghapus modul kernel secara dinamis.

**54. initramfs**
Filesystem sementara yang dimuat saat boot dan berisi modul penting termasuk driver grafis awal.

**55. kmscon**
Console virtual berbasis KMS; alternatif VT tekstual tradisional yang sudah mendukung rendering modern.

**56. fbcon**
Driver console lama yang menampilkan teks di atas framebuffer sebelum user space compositor aktif.

**57. GPU Scheduler**
Komponen kernel yang menjadwalkan tugas rendering GPU agar efisien dan adil antara proses.

**58. Fence / Sync Primitive**
Mekanisme sinkronisasi antara CPU dan GPU agar data frame tidak ditimpa sebelum selesai dirender.

**59. BO (Buffer Object)**
Unit memori utama dalam DRM/GEM yang digunakan compositor untuk menyimpan surface dan texture.

**60. DRI (Direct Rendering Infrastructure)**
Lapisan antara X11/Wayland dan driver kernel yang memungkinkan rendering langsung tanpa X server bottleneck.

---

#### Bagian ini berfokus pada **pipeline rendering, alokasi memori GPU**, **komunikasi antara kernel dan user space**, serta **driver tingkat tinggi seperti Mesa dan Gallium3D**, dan interaksi antara driver, OpenGL/Vulkan, serta subsistem memori grafis.

---

**61. Render Pipeline (Alur Render)**
Rangkaian tahap transformasi data 3D menjadi pixel akhir pada layar — mencakup vertex shading, rasterization, fragment shading, dan output merge.

**62. Shader**
Program kecil yang dijalankan GPU untuk memproses vertex atau fragment. Ditulis dalam GLSL (untuk OpenGL) atau SPIR-V (untuk Vulkan).

**63. OpenGL (Open Graphics Library)**
API grafis lintas platform berbasis C yang menyediakan akses abstrak ke hardware grafis; digunakan oleh compositor seperti Mutter, KWin, dan Weston.

**64. GLES (OpenGL ES)**
Versi ringan OpenGL untuk perangkat mobile dan embedded — banyak dipakai di Wayland compositor berbasis wlroots.

**65. Vulkan API**
API grafis generasi baru dari Khronos Group; lebih rendah levelnya dibanding OpenGL dan memungkinkan kontrol langsung terhadap GPU.

**66. SPIR-V (Standard Portable Intermediate Representation)**
Format biner standar untuk shader Vulkan — menggantikan GLSL sebagai bahasa shader tingkat kompilasi.

**67. Gallium3D**
Framework dalam proyek Mesa yang menyediakan abstraksi driver GPU agar berbagai backend (Nouveau, Radeon, i965) bisa berbagi logika umum.

**68. Mesa Library**
Implementasi open-source dari OpenGL, GLES, dan Vulkan di Linux. Ditulis dalam C, menjadi jembatan antara aplikasi grafis dan kernel DRM.

**69. LLVMpipe**
Driver *software rendering* dari Mesa yang menggunakan CPU (via LLVM) sebagai pengganti GPU.

**70. llvmpipe (Software Rasterizer)**
Backend CPU dari Mesa yang digunakan bila tak ada GPU atau driver yang kompatibel.

**71. zink driver**
Backend Mesa yang menerjemahkan OpenGL ke Vulkan — memungkinkan OpenGL berjalan di atas Vulkan driver.

**72. Nouveau Driver**
Driver open-source untuk GPU NVIDIA, berbasis DRM dan Gallium3D.

**73. AMDGPU Driver**
Driver open-source utama untuk GPU AMD modern, termasuk dukungan Vulkan melalui RADV.

**74. Intel i915 / Xe Driver**
Driver DRM resmi untuk GPU Intel generasi lama (i915) dan baru (Xe).

**75. Proprietary GPU Driver**
Driver tertutup resmi seperti `nvidia.ko` atau `fglrx.ko`, biasanya berisi binary blob.

**76. DRI2 / DRI3 Protocols**
Versi lanjutan dari Direct Rendering Infrastructure yang memungkinkan sinkronisasi buffer antarproses (seperti X11 dan compositor).

**77. EGL (Embedded-System Graphics Library)**
Lapisan antara OpenGL/ES atau Vulkan dan windowing system seperti Wayland atau X11.

**78. GLX (OpenGL Extension to X)**
Ekstensi OpenGL untuk X11 agar aplikasi bisa menggunakan rendering hardware secara langsung melalui X server.

**79. GBM (Generic Buffer Management)**
Antarmuka DRM di user space untuk mengelola buffer yang dibagi antarproses; digunakan wlroots dan Weston.

**80. dmabuf (Direct Memory Access Buffer Sharing)**
Mekanisme berbagi buffer antarproses (misalnya compositor dan aplikasi) tanpa penyalinan data.

**81. VA-API (Video Acceleration API)**
API akselerasi video dari Intel untuk decoding/encoding hardware berbasis GPU.

**82. VDPAU (Video Decode and Presentation API for Unix)**
API serupa VA-API tetapi untuk GPU NVIDIA.

**83. V4L2 (Video4Linux2)**
API kernel untuk menangani perangkat video (kamera, capture card, encoder, dsb).

**84. DRM ioctl (Input/Output Control Calls)**
Fungsi panggilan sistem yang digunakan user space driver (seperti Mesa) untuk berinteraksi dengan kernel DRM.

**85. Rendernode Permissions**
Aturan akses file `/dev/dri/renderD*` yang memungkinkan proses non-root menggunakan GPU secara aman.

**86. GPU Reset Handling**
Mekanisme kernel untuk memulihkan GPU dari kondisi hang tanpa harus reboot sistem.

**87. GPU Ring Buffer**
Struktur FIFO di GPU untuk menjadwalkan tugas rendering yang dikirim dari CPU.

**88. Context Switching (GPU Context)**
Proses berpindah antara tugas rendering berbeda agar beberapa aplikasi bisa memakai GPU bersamaan.

**89. VRAM (Video RAM)**
Memori khusus GPU untuk menyimpan framebuffer, texture, dan buffer objek grafis lainnya.

**90. BAR (Base Address Register)**
Register di PCIe yang menentukan lokasi fisik memori GPU di ruang alamat sistem, penting dalam inisialisasi driver DRM.

---

Bagian ini menyinggung mekanisme yang menjaga **sinkronisasi, performa, efisiensi daya, serta stabilitas GPU dan display subsystem**. Semua konsep ini adalah fondasi “otot dan ritme” dari sistem grafis Linux modern.

---

### Graphics Subsystem (91–120)

**91. Vertical Sync (VSync)**
Mekanisme penyelarasan pembaruan buffer dengan interval refresh layar untuk menghindari *screen tearing*.

**92. Adaptive Sync / FreeSync / G-Sync**
Teknologi variabel refresh rate yang memungkinkan layar menyesuaikan frekuensi refresh terhadap FPS aktual GPU.

**93. Page Flip**
Proses pergantian buffer yang aktif pada CRTC; bagian penting dalam rendering atomik DRM.

**94. Triple Buffering**
Teknik penggunaan tiga buffer untuk meminimalkan tearing dan stuttering tanpa menambah latensi besar.

**95. Frame Timing**
Pengukuran waktu dari render satu frame ke frame berikutnya; digunakan compositor untuk menghitung FPS stabil.

**96. Display Clock (PIXELCLK)**
Frekuensi sinyal yang mengatur seberapa cepat pixel dikirim ke panel output.

**97. PLL (Phase-Locked Loop)**
Sirkuit dalam GPU yang menjaga kestabilan dan sinkronisasi clock antar-komponen tampilan.

**98. PowerPlay (AMD)**
Lapisan pengelolaan daya GPU AMD untuk menyesuaikan frekuensi core dan memori sesuai beban kerja.

**99. Dynamic Power Management (DPM)**
Sistem kernel yang menurunkan tegangan dan frekuensi GPU/CPU saat idle untuk efisiensi energi.

**100. Thermal Sensor**
Sensor suhu yang diakses kernel melalui *hwmon* untuk memantau suhu GPU.

**101. hwmon (Hardware Monitoring)**
Antarmuka kernel (/sys/class/hwmon) untuk pembacaan suhu, tegangan, dan kecepatan kipas perangkat.

**102. Fan Curve**
Profil kecepatan kipas yang disesuaikan terhadap suhu GPU; dapat dikonfigurasi lewat sysfs atau tool seperti `amdgpu-fan`.

**103. DVFS (Dynamic Voltage and Frequency Scaling)**
Teknik menyesuaikan daya GPU/CPU berdasarkan beban; inti dari efisiensi energi sistem modern.

**104. PCIe Link State Power Management**
Fitur penghematan daya di bus PCIe yang menurunkan konsumsi saat tidak aktif.

**105. PM QoS (Power Management Quality of Service)**
API kernel yang memungkinkan driver menjaga performa minimum meskipun mode hemat daya aktif.

**106. Runtime Power Management**
Mekanisme mematikan sebagian modul perangkat keras saat idle tanpa melepas modul kernel.

**107. Clocks & Domains**
Struktur kernel untuk mengelola berbagai sumber clock (core, shader, memory) pada GPU.

**108. GPU Perf Counters**
Penghitung hardware yang memantau FPS, beban shader, bandwidth VRAM — digunakan driver untuk tuning.

**109. Perf Events (Performance Monitoring Subsystem)**
Subsystem kernel umum untuk profil CPU/GPU; diakses melalui perintah `perf`.

**110. Interrupt Latency**
Waktu antara sinyal perangkat keras dan respons kernel; memengaruhi kelancaran tampilan.

**111. Frame Drop**
Terjadi bila compositor melewatkan refresh karena buffer belum siap; indikator kinerja grafis.

**112. Swap Interval**
Parameter API (OpenGL EGL) yang menentukan berapa kali refresh di-skip sebelum swap buffer terjadi.

**113. GPU Hang / Lockup**
Kondisi GPU tidak merespons akibat beban berat atau bug; diatasi melalui mekanisme reset kernel.

**114. Watchdog Timer**
Timer kernel yang memicu reset GPU saat terjadi hang berlarut.

**115. Fence Timeout**
Batas waktu tunggu sinkronisasi CPU-GPU sebelum dianggap gagal dan ditandai error.

**116. DMA-Fence Chain**
Rangkaian sinkronisasi kompleks antara beberapa buffer untuk operasi paralel multi-GPU.

**117. Multi-GPU Topology**
Struktur sistem dengan beberapa GPU (SLI, CrossFire, Hybrid Graphics) yang dikelola kernel.

**118. Render Offload**
Fitur GPU hybrid (mis. NVIDIA Optimus) untuk menugaskan render ke GPU discrete dan menampilkan hasil lewat iGPU.

**119. PRIME (Prime Offloading Framework)**
Mekanisme kernel untuk berbagi buffer antar GPU — memungkinkan kombinasi iGPU + dGPU tanpa penyalinan.

**120. VRR (Variable Refresh Rate) Kernel Support**
Implementasi kernel yang memungkinkan compositor Wayland mengatur refresh dinamis sesuai dukungan monitor.

---
<!--
Tahap terakhir akan membahas **debugging, tracing, logging, firmware, serta integrasi kernel-user space**—menutup seluruh fondasi grafis sistem Linux.
-->

#### Bagian ini mencakup **debugging, tracing, logging, firmware, keamanan, serta jembatan antara kernel dan ruang pengguna (user space)**—bagian yang menjadi tulang belakang dalam pengembangan dan stabilitas grafis.

---

**121. DRM Debug Logging**
Mekanisme bawaan DRM (`drm.debug`) yang mengeluarkan log internal subsistem grafis; diaktifkan lewat kernel parameter `drm.debug=0x1ff`.

**122. KMS Logging**
Log kernel khusus untuk event *mode setting* seperti koneksi monitor, resolusi, dan refresh rate.

**123. Tracepoints**
Instrumen dalam kernel yang memungkinkan pengembang melacak fungsi tertentu (misalnya `trace_drm_vblank_event`).

**124. Ftrace (Function Tracer)**
Alat bawaan kernel untuk menelusuri eksekusi fungsi-fungsi internal driver.

**125. perf (Performance Profiler)**
Utilitas untuk menganalisis performa CPU/GPU dengan memanfaatkan subsystem `perf_event`.

**126. BPF (Berkeley Packet Filter) / eBPF**
Mesin virtual kecil di kernel yang dapat digunakan untuk tracing dan monitoring DRM atau input event tanpa mengubah kode kernel.

**127. GPU DebugFS Entries**
Filesystem virtual di `/sys/kernel/debug/dri/` yang berisi statistik dan status GPU secara langsung.

**128. Sysfs Attributes**
File di `/sys/class/drm/` yang menampilkan dan memungkinkan konfigurasi runtime perangkat grafis.

**129. Kernel Log Ring Buffer (dmesg)**
Penyimpanan sementara log kernel, termasuk error GPU, VBlank event, dan inisialisasi perangkat.

**130. dmesg Filtering**
Penggunaan perintah seperti `dmesg | grep drm` untuk memeriksa status DRM atau crash GPU secara cepat.

**131. Kernel Panic**
Kegagalan fatal sistem yang menghentikan seluruh operasi kernel, kadang disebabkan oleh bug dalam driver grafis.

**132. Oops Message**
Pesan error kernel yang menunjukkan pointer atau fungsi rusak; sering muncul saat debugging DRM.

**133. Core Dump**
Salinan memori program atau driver saat crash; digunakan untuk analisis pasca-insiden (post-mortem).

**134. Kdump**
Fitur kernel yang memungkinkan reboot cepat ke kernel kedua untuk menyimpan dump memori dari kernel utama yang crash.

**135. Lockdep (Lock Debugging)**
Subsystem kernel untuk mendeteksi *deadlock* atau kebocoran kunci pada driver DRM dan KMS.

**136. Race Condition**
Kondisi di mana dua proses (CPU/GPU) mengakses data bersamaan tanpa sinkronisasi yang tepat.

**137. Spinlock / Mutex**
Mekanisme sinkronisasi dalam kernel untuk mencegah race condition pada buffer grafis.

**138. Atomic Transaction (DRM Atomic API)**
Sistem commit atomik yang menjamin semua perubahan mode setting (plane, crtc, connector) diterapkan serentak.

**139. User Space Helper (udev helper)**
Proses kecil yang dipicu oleh kernel untuk menyiapkan environment pengguna saat perangkat grafis muncul.

**140. Firmware Loader**
Bagian kernel yang memuat firmware GPU dari `/lib/firmware` saat inisialisasi driver.

**141. Binary Blob Firmware**
Kode biner tertutup yang dikirimkan ke GPU untuk mengaktifkan fungsionalitas dasar.

**142. Open Firmware / libre-firmware**
Alternatif bebas (open source) untuk firmware biner; masih terbatas pada sebagian GPU AMD dan Intel.

**143. Secure Boot**
Fitur keamanan firmware yang mencegah kernel atau driver tidak ditandatangani dijalankan.

**144. Module Signing**
Sistem tanda tangan digital untuk memastikan integritas modul kernel seperti `amdgpu.ko` atau `i915.ko`.

**145. uAPI (User-space API)**
Lapisan antarmuka kernel–user space untuk DRM; menjembatani komunikasi antara driver dan compositor.

**146. ioctl (Input/Output Control System Call)**
Panggilan sistem utama untuk berinteraksi dengan driver karakter seperti `/dev/dri/card0`.

**147. libdrm**
Perpustakaan C di ruang pengguna yang menyediakan binding untuk berkomunikasi dengan DRM melalui ioctl.

**148. GBM (Generic Buffer Management)**
Abstraksi buffer di ruang pengguna yang digunakan oleh compositor Wayland seperti Sway dan Weston.

**149. Syncobj (Synchronization Object)**
Objek DRM yang digunakan untuk menyinkronkan antrian pekerjaan GPU antara beberapa proses.

**150. DRM Lease**
Fitur DRM untuk memberikan kontrol sementara atas output (misalnya monitor) kepada proses lain tanpa kehilangan keamanan kernel.

---

## Sumber rujukan utama (untuk pendalaman)

* Dokumentasi Kernel — DRM / KMS (kernel.org). ([kernel.org][2])
* libdrm / DRM overview (debian manpages / freedesktop). ([manpages.debian.org][1])
* Mesa 3D — dokumentasi & driver userspace. ([docs.mesa3d.org][3])
* libinput (freedesktop) — dokumentasi input userspace. ([wayland.freedesktop.org][4])
* Kernel docs: Framebuffer, DRM-UAPI, DRM memory management. ([docs.kernel.org][5])

[1]: https://manpages.debian.org/unstable/libdrm-dev/drm.7.en.html?utm_source=chatgpt.com "drm(7) — libdrm-dev — Debian unstable"
[2]: https://www.kernel.org/doc/html/v4.15/gpu/drm-kms.html?utm_source=chatgpt.com "Kernel Mode Setting (KMS)"
[3]: https://docs.mesa3d.org/?utm_source=chatgpt.com "Introduction — The Mesa 3D Graphics Library latest ..."
[4]: https://wayland.freedesktop.org/libinput/doc/latest/?utm_source=chatgpt.com "libinput 1.29.901 documentation - Wayland"
[5]: https://docs.kernel.org/fb/index.html?utm_source=chatgpt.com "Frame Buffer"


Dengan ini, **Lapisan 1: Kernel & Graphics Subsystem** telah **selesai sepenuhnya** — 150 istilah teknis yang membentuk dasar seluruh *display stack* dalam sistem Linux modern.

Struktur lapisan berikutnya akan beralih dari tingkat kernel ke **Display Server & Protocol Layer (Lapisan 2)**, tempat konsep **Wayland, X11, Weston, wlroots, socket IPC, dan protokol compositor** berada.

<!--

Apakah Anda ingin saya langsung melanjutkan ke **Lapisan 2 (Display Server & Protocol Layer, istilah 1–40 dari 200)**?
Saya sudah menyelesaikan **30 istilah** untuk *Lapisan 1* secara lengkap dan siap melanjutkan ke lapisan berikutnya kapan saja—atau jika Anda ingin, saya dapat memperluas masing-masing entri di atas (contoh kode, lokasi file sumber, langkah build & patch minimal untuk driver, atau checklist persiapan pengembangan kernel di Archlinux/Sway-friendly environment).

Langkah selanjutnya yang saya rekomendasikan: pilih antara

1. **Lanjut ke Lapisan 2 (Display Server & Protokol)**, atau
2. **Perluasan entri tertentu di Lapisan 1** (mis. contoh sederhana menggunakan `libdrm` atau membangun modul kernel contoh).

Saya akan langsung mengerjakannya sesuai pilihan Anda.

<details>
  <summary>📃 Daftar Isi</summary>

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

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
