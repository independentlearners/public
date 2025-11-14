# Wlroots

Repo Resmi: wlroots adalah pustaka C modular untuk membangun compositor Wayland. Dalam README resminya disebutkan bahwa wlroots menyediakan “modular, pluggable, [dan] unopinionated” modul untuk membangun compositor Wayland (serupa dengan ~60.000 baris kode yang mungkin Anda tulis sendiri). Pustaka ini mendukung berbagai backend (seperti KMS/DRM, libinput, Wayland, X11, headless) dan protokol (wl_seat, xdg_shell, Xwayland, dll). Repositori utamanya telah bermigrasi ke GitLab freedesktop (dulu di swaywm/wlroots) dengan panduan kontribusi, lisensi MIT, dan wiki Getting Started

Dokumentasi API: Dokumentasi fungsi dan tipe dari wlroots di-generate secara otomatis dan tersedia di situs Freedesktop (wlroots.pages.freedesktop.org). Namun, dokumentasi utama sebenarnya berada dalam komentar header pustaka itu sendiri. Wiki resmi menyatakan: “wlroots is largely documented through comments in the headers… Also check out tinywl”. Artinya, pengembang disarankan membaca header hl ieni untuk detail API, dan contoh sederhana seperti tinywl (diskusikan di bawah) sebagai referensi.

Panduan Integrasi: Wiki Getting Started wlroots (arsip di GitHub) menjelaskan cara mengintegrasikan wlroots ke proyek, misalnya menggunakan pkg-config --cflags --libs wlroots, menjalankan wayland-scanner untuk protokol XDG-shell wlroots, serta definisi -DWLR_USE_UNSTABLE untuk fitur eksperimental. Panduan ini juga merekomendasikan saluran IRC (#sway-devel) untuk dukungan.

## Tutorial Komunitas / Pengembang Compositor

Seri blog Drew DeVault (Sway): Drew DeVault (pemelihara Sway) menulis seri tutorial berjudul “Writing a Wayland Compositor” yang langkah-demi-langkah membahas pembuatan compositor berbasis wlroots. Misalnya, bagian 1 (Hello wlroots) menjelaskan pembuatan wl_display, wlr_backend_autocreate(), event loop, dan pengurutan awal framebuffer; bagian 2 (Rigging up the server) menambahkan socket Wayland dan protokol global (wl_shm, gamma_control, idle, dll); bagian 3 (Rendering a window) memperkenalkan wlr_compositor_create() dan wlr_xdg_shell_v6_create() untuk memungkinkan klien membuat surface, serta iterasi wlr_compositor->surfaces dan penggunaan wlr_renderer untuk menggambar jendela. Blog ini menyediakan potongan kode beserta penjelasan mendetail (bahasa Inggris). Blog pengembang Vivarium/River: Pengembang Vivarium (juga membahas proyek River) menulis pandangan mereka tentang membuat window manager di Wayland dengan wlroots. Ia merekomendasikan mem-fork contoh tinywl sebagai titik awal karena tinywl “implement[s] in a basic way almost every core functionality you’ll need” dan mengajarkan banyak tentang API Wayland wlroots. Ia juga menegaskan bahwa wlroots sudah cukup stabil untuk digunakan pada projeknya (mis. Vivarium/River). Artikel ini memberi konteks motivasi membuat compositor (Cara Wayland dibandingkan X11) dan menunjukkan beberapa contoh penggunaan (meskipun bukan tutorial kode terstruktur).

Tutorial lain: Misalnya situs Way Cooler memiliki bab “Introduction to wlroots” yang secara ringkas menjelaskan tujuan wlroots dan fitur utamanya. Situs tersebut menampilkan elevator pitch wlroots (modular Wayland compositor library) dan merangkum berbagai backend dan protokol yang didukung. Informasi semacam ini berguna sebagai pengantar konseptual.

## Artikel Teknis & Blog Post (Arsitektur/Internals)

Damage Tracking (Emersion): Arsitektur internal wlroots dibahas dalam beberapa blog teknis. Sebagai contoh, Emersion (kontributor wlroots) menulis “Introduction to damage tracking” untuk menjelaskan optimasi rendering. Ia menggambarkan bahwa tanpa optimasi, compositor akan menggambar frame 60Hz meski layar statis, sehingga damage tracking memperbolehkan menghentikan rendering saat tidak ada perubahan: “Level zero of damage tracking is noticing when nothing changes and stopping rendering”. Emersion kemudian menjelaskan cara wlroots menggunakan informasi damage dan usia buffer (buffer age) untuk hanya menggambar wilayah layar yang berubah. Artikel ini memberikan wawasan mendalam tentang mekanisme internal wlroots untuk efisiensi rendering.

Handling Input (Drew DeVault): Drew DeVault juga menulis artikel teknis tentang cara wlroots menangani input. Ia menekankan desain “batteries not included” wlroots untuk input, yang sangat fleksibel (mendukung banyak kursors, keyboard, tablet, on-screen keyboard, dll) namun “sangat membingungkan” bila dipakai pertama kali. Artikel tersebut merinci blok utama arsitektur input: wlr_backend sebagai abstraksi hardware (memancarkan event new_input ketika ada perangkat baru) dan wlr_input_device (pointer, keyboard, touch, dll). Ada juga pembahasan wlr_cursor, wlr_output_layout, dan alat lainnya untuk memudahkan pemetaaan input antar output. Intinya, artikel ini menguraikan API dan sinyal internal wlroots yang harus ditangani sendiri oleh pengembang compositor

Blog lain: Selain itu, ada artikel lain (sering karya Emersion atau Drew) mengenai hal-hal spesifik seperti shell protocols (xdg-shell, layer-shell), pengaturan Xwayland, atau fitur baru (misalnya integrasi scene-graph di versi wlroots terbaru). Forum dan issue tracker wlroots juga kadang memberikan insight arsitektural saat pengembang membahas rencana pengembangan (misalnya peningkatan scene-graph atau dukungan libliftoff).

## Contoh Kode / Implementasi wlroots

Contoh tinywl (C): Repositori wlroots menyertakan program demo minimal bernama tinywl (biasanya di direktori tinywl), ditulis dalam C. Contoh ini mencakup alur dasar membuat compositor: wlr_backend_autocreate(), loop acara, menangani output, wlr_compositor_create(), dan menangani shell. Meskipun kode aslinya tidak dicantumkan di sini, seorang kontributor merekomendasikan tinywl sebagai “base yang bagus” karena mengimplementasikan hampir semua fungsi inti wlroots. Anda bisa melihat kode sumber lengkap tinywl di repo wlroots (GitLab freedesktop).

Contoh tutorial “McWayface” (Drew DeVault): Contoh lain adalah repository “mcwayface” oleh Drew DeVault (GitHub: ddevault/mcwayface), yang merupakan kode yang didemonstrasikan dalam seri blog di atas. Di dalamnya terlihat pemanggilan kunci wlroots, misalnya:

```bash
server.compositor = wlr_compositor_create(server.wl_display, wlr_backend_get_renderer(server.backend));
wlr_xdg_shell_v6_create(server.wl_display);
wl_display_run(server.wl_display);
```
Bagian kode ini (dari tutorial Bagian 3) menunjukkan pembuatan wlr_compositor dan xdg_shell untuk mengijinkan klien membuat permukaan. Project ini lengkap dengan beberapa file C terpisah dan dapat dipelajari sebagai contoh penerapan nyata wlroots.

Contoh lainnya: Komunitas juga memiliki contoh-contoh kecil lain. Misalnya, rootston (kompositor sederhana bawaan wlroots), utilitas screenshot (examples/screenshot) dan sample client. Beberapa pengembang (misalnya River, Wayfire) juga membuka source code compositor berbasis wlroots, yang bisa dipelajari untuk arsitektur lebih kompleks. Intinya, repositori wlroots dan repositori terkait (seperti GitHub mcwayface atau situs blog) menyediakan banyak contoh implementasi wlroots sebagai acuan.

> Sumber: Dokumentasi dan diskusi resmi wlroots serta berbagai blog dan tutorial komunitas (lihat tautan yang di komentari) menyediakan penjelasan teknis tentang arsitektur, API, dan cara penggunaan wlroots. Referensi utama termasuk README dan wiki wlroots, dokumentasi API di Freedesktop, tutorial berjenjang Drew DeVault, serta artikel teknis Emersion dan pengembang lainnya

