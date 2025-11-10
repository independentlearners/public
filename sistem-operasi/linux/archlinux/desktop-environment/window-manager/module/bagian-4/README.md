# **Lapisan 4: Toolkit & Rendering Engine**

Berisi **200 istilah** yang disusun rapih. Setiap entri singkat, teknis, dan langsung menunjukkan: **Nama (EN / ID)** · **Kategori (Lapisan 4)** · **Deskripsi ringkas** · **Implementasi / bahasa utama** · **Prasyarat singkat untuk memodifikasi atau mengembangkan**. Penyusunana ini agar dapat digunakan sebagai peta belajar dan daftar cek saat hendak memodifikasi, meng-embed, atau menulis rendering layer sendiri.

---

1. **GUI Toolkit / Toolkit GUI** · Lapisan 4 · Perpustakaan yang menyediakan widget, event loop, dan abstraksi UI. · Implementasi: C/C++/variasi. · Prasyarat: pemahaman bahasa target, build system toolkit, event-driven programming.
2. **GTK / GTK+ (GIMP Toolkit) / GTK** · Lapisan 4 · Toolkit UI populer untuk GNOME, menyediakan widget, CSS styling, dan GL-based rendering pada GTK4. · Implementasi: C (GObject), bindings multi-bahasa. · Prasyarat: C/GObject, Meson, pemahaman CSS-GTK dan GDK/EGL.
3. **Qt (Qt Framework)** · Lapisan 4 · Framework UI lengkap untuk aplikasi desktop dan embedded; menyediakan Qt Widgets dan Qt Quick (QML). · Implementasi: C++ (Qt libraries). · Prasyarat: C++ modern, CMake/qmake, QML jika ingin modifikasi Qt Quick.
4. **EFL (Enlightenment Foundation Libraries)** · Lapisan 4 · Toolkit ringan dengan fokus performa grafis dan efek; digunakan oleh Enlightenment. · Implementasi: C. · Prasyarat: C, build system autotools/meson, integrasi with Evas/Edje.
5. **Clutter** · Lapisan 4 · Scene graph UI toolkit (declarative animation) yang semula dipakai GNOME Shell. · Implementasi: C (GObject) + OpenGL. · Prasyarat: C, OpenGL, scene graph concepts.
6. **FLTK (Fast Light Toolkit)** · Lapisan 4 · Toolkit GUI ringan C++ untuk aplikasi cross-platform. · Implementasi: C++. · Prasyarat: C++, build cross-platform.
7. **wxWidgets** · Lapisan 4 · Toolkit C++ cross-platform yang menggunakan native widgets OS. · Implementasi: C++. · Prasyarat: C++ dan pemahaman event-driven native binding.
8. **SDL2 (Simple DirectMedia Layer)** · Lapisan 4 · Library untuk input, audio, dan rendering 2D; sering dipakai game dan UI ringan. · Implementasi: C. · Prasyarat: C, event loop, integrasi OpenGL/Vulkan.
9. **Dear ImGui** · Lapisan 4 · Immediate-mode GUI library populer untuk tools/editor/debug UI. · Implementasi: C++. · Prasyarat: C++, integrasi rendering backend (OpenGL/DirectX/Vulkan).
10. **Nuklear** · Lapisan 4 · Immediate mode GUI header-only library C. · Implementasi: C. · Prasyarat: C, integrasi dengan backend renderer.
11. **NanoGUI / NanoVG** · Lapisan 4 · Lightweight UI + vector graphics helper; dipakai pada tools grafis. · Implementasi: C++ / C. · Prasyarat: C++, OpenGL, vector design.
12. **LVGL (Light and Versatile Graphics Library)** · Lapisan 4 · Toolkit ringan untuk embedded GUI (microcontrollers). · Implementasi: C. · Prasyarat: C, hardware drivers, DMA buffers.
13. **Flutter Engine** · Lapisan 4 · Engine UI Google untuk Flutter; berbasis Skia untuk rendering, mendukung desktop via embedding. · Implementasi: C++ (Skia) + Dart VM glue. · Prasyarat: C++/Dart, build Flutter engine, knowledge of embedder APIs.
14. **Electron / Chromium Embedded** · Lapisan 4 · Aplikasi desktop berbasis Chromium (HTML/CSS/JS) sebagai UI toolkit. · Implementasi: C++ (Chromium) + Node.js. · Prasyarat: C++, Node/Electron packaging, web technologies.
15. **Qt Quick (QML) / SceneGraph** · Lapisan 4 · Declarative UI (QML) yang dirender via Qt SceneGraph (OpenGL/Vulkan). · Implementasi: C++ (Qt) + QML. · Prasyarat: C++, QML, shader basics untuk custom items.
16. **GTK4 Rendering Model (GDK/GL)** · Lapisan 4 · GTK4 menggunakan integrasi GL/GSK (GTK Scene Kit) untuk rendering via GPU. · Implementasi: C (GObject), GSK in C. · Prasyarat: C/GObject, OpenGL/EGL knowledge.
17. **GSK (GTK Scene Kit)** · Lapisan 4 · Abstraksi scene graph GTK untuk rendering grafis vektor dan efek. · Implementasi: C. · Prasyarat: scene graph concepts, shader pipeline.
18. **GDK (GIMP Drawing Kit)** · Lapisan 4 · Lapisan abstraksi terhadap windowing system (Wayland/X11) di GTK. · Implementasi: C. · Prasyarat: pemahaman backend (Wayland/X11) dan event loop.
19. **GObject Introspection** · Lapisan 4 · Metadata runtime untuk membuat binding bahasa higher-level (Python, JS) pada library C berbasis GObject. · Implementasi: C, typelib. · Prasyarat: memahami GObject, membuat gir/typelib.
20. **PyGObject / GTK Bindings** · Lapisan 4 · Binding GTK/GObject untuk Python. · Implementasi: Python + GObject Introspection. · Prasyarat: Python, GObject introspection file generation.
21. **Cairo** · Lapisan 4 · 2D vector graphics library untuk penggambaran vektor berkualitas tinggi (antialias, paths). · Implementasi: C. · Prasyarat: C, surface backends (image, X11, PDF, OpenGL via glitz).
22. **Pixman** · Lapisan 4 · Library pixel manipulation (software rasterization) yang digunakan oleh Cairo dan compositors. · Implementasi: C. · Prasyarat: C, algoritma raster/spans/soft blending.
23. **Skia** · Lapisan 4 · Cross-platform 2D graphics engine (Google) digunakan di Chrome, Flutter; dukung GPU & CPU raster. · Implementasi: C++. · Prasyarat: C++, build Skia (GN/Ninja), integrasi GPU backends (Vulkan/GL).
24. **Skia Shader / SkSL** · Lapisan 4 · Bahasa shader internal Skia (SkSL) untuk efek GPU portable. · Implementasi: C++ (compiler Skia). · Prasyarat: shader programming, Skia build.
25. **Pango** · Lapisan 4 · Library layout & rendering teks berfitur lengkap (Unicode, shaping). · Implementasi: C. · Prasyarat: C, integrasi dengan FreeType/Harfbuzz.
26. **FreeType** · Lapisan 4 · Engine rasterisasi font (TrueType/OpenType) yang menghasilkan glyph bitmap/outline. · Implementasi: C. · Prasyarat: C, memahami font format, hinting, subpixel.
27. **HarfBuzz** · Lapisan 4 · Library text shaping modern untuk ligature, kerning, dan script kompleks. · Implementasi: C/C++. · Prasyarat: pemahaman OpenType, Unicode shaping.
28. **Fontconfig** · Lapisan 4 · Sistem discovery dan konfigurasi font di Linux. · Implementasi: C. · Prasyarat: XML config, font paths, packaging fonts.
29. **Libcairo Surface (Image/Recording/GL)** · Lapisan 4 · Abstraksi target drawing berbeda (gambar, PDF, OpenGL-backed). · Implementasi: C. · Prasyarat: integrasi backend, sinkronisasi buffer.
30. **Cairo + GL backends (cogl/egl)** · Lapisan 4 · Penggunaan Cairo pada konteks GL/EGL untuk akselerasi GPU. · Implementasi: C + EGL. · Prasyarat: EGL, FBO, shader untuk compositing.
31. **Vector Graphics (SVG) / Vektor Grafis** · Lapisan 4 · Format dan pipeline untuk render grafis vektor (scalable). · Implementasi: parser di C/C++ (librsvg, NanoSVG). · Prasyarat: parsing XML/SVG, rasterisasi paths.
32. **librsvg** · Lapisan 4 · Library untuk merender SVG di GNOME (biasanya berbasis Rust/C). · Implementasi: Rust/C. · Prasyarat: parsing SVG/CSS, integrasi Cairo/Skia.
33. **Image Decoders (libpng, libjpeg, libwebp)** · Lapisan 4 · Perpustakaan untuk decode/encode format gambar umum. · Implementasi: C. · Prasyarat: API C, integrasi ke surface/texture.
34. **Color Management (LittleCMS / colord)** · Lapisan 4 · Pipeline untuk konversi warna dan profil ICC. · Implementasi: C (LittleCMS), daemon colord. · Prasyarat: ICC profiles, color spaces (sRGB, P3).
35. **ICC Profile / Color Profile** · Lapisan 4 · Data yang menjelaskan karakteristik warna perangkat. · Implementasi: file .icc/.icm, digunakan oleh colord/LittleCMS. · Prasyarat: pemahaman gamut, rendering intent.
36. **sRGB / Color Spaces** · Lapisan 4 · Standar ruang warna default sRGB; dasar konversi warna. · Implementasi: spesifikasi. · Prasyarat: konsep warna, gamma.
37. **Gamma Correction / Tone Mapping** · Lapisan 4 · Transformasi kecerahan warna untuk akurasi tampilan & HDR mapping. · Implementasi: shader/renderer. · Prasyarat: pemahaman linear vs gamma space.
38. **High-DPI (HiDPI) Scaling** · Lapisan 4 · Mekanisme skala DPI fractional untuk tampilan tajam. · Implementasi: toolkit + compositor support. · Prasyarat: layout scaling, assets resolusi ganda.
39. **Fractional Scaling** · Lapisan 4 · Dukungan skala bukan integer (1.25x, 1.5x) untuk HiDPI. · Implementasi: compositor + toolkit. · Prasyarat: support wl_output transform & wp_fractional_scale.
40. **Text Shaping Pipeline** · Lapisan 4 · Rangkaian HarfBuzz + FreeType + Pango untuk menghasilkan glyph run. · Implementasi: C/C++. · Prasyarat: Unicode, script handling.
41. **Ligatures & Kerning** · Lapisan 4 · Fitur font untuk penggabungan karakter dan penyesuaian spasi karakter. · Implementasi: OpenType tables, HarfBuzz. · Prasyarat: memahami OpenType tables.
42. **BiDi (Bidirectional Text)** · Lapisan 4 · Penanganan teks campuran LTR dan RTL (mis. Arab + Inggris). · Implementasi: ICU/HarfBuzz/Pango. · Prasyarat: Unicode BiDi algorithm.
43. **Shaping Engines (Complex Script)** · Lapisan 4 · Dukungan script kompleks (Devanagari, Arabic) melalui HarfBuzz. · Implementasi: C. · Prasyarat: OpenType features, Unicode shaping.
44. **Glyph Rasterizer** · Lapisan 4 · Komponen yang mengubah outline font ke bitmap (FreeType). · Implementasi: C. · Prasyarat: font formats, hinting.
45. **Subpixel Rendering / ClearType** · Lapisan 4 · Teknik memanfaatkan subpixel LCD untuk tajam teks. · Implementasi: FreeType config + rendering pipeline. · Prasyarat: monitor subpixel order & hinting.
46. **Font Hinting** · Lapisan 4 · Petunjuk pada font agar rasterisasi menghasilkan outline yang jelas di pixel grid. · Implementasi: dalam font or FreeType. · Prasyarat: keahlian font design / hinting tools.
47. **Bitmap Fonts / Embedded Fonts** · Lapisan 4 · Font yang menggunakan glyph bitmap; cocok untuk UI kecil/embedded. · Implementasi: format BDF/PCF. · Prasyarat: tooling untuk generate bitmap fonts.
48. **SVG Fonts / Icon Fonts** · Lapisan 4 · Ikon sebagai font (sering dipakai untuk UI scalable icons). · Implementasi: font outlines or SVG glyphs. · Prasyarat: font creation, icon design.
49. **Icon Theme (Freedesktop Icon Theme)** · Lapisan 4 · Standar pengelolaan ikon pada desktop Linux (hicolor, Adwaita). · Implementasi: folder/icon naming. · Prasyarat: packaging icons, metadata.
50. **CSS Styling (GTK CSS)** · Lapisan 4 · CSS-like stylesheet untuk menata tampilan widget GTK. · Implementasi: parser di GTK (C). · Prasyarat: CSS syntax, GTK style classes.
51. **Qt Style Sheets** · Lapisan 4 · Mekanisme styling UI di Qt mirip CSS. · Implementasi: C++ (Qt). · Prasyarat: QSS syntax, widget style understanding.
52. **Theme Engine (GTK / Qt)** · Lapisan 4 · Sistem theming untuk merubah tampilan widget dan kontrol. · Implementasi: CSS (GTK)/QStyle (Qt). · Prasyarat: desain theme, resource packaging.
53. **Adwaita Theme** · Lapisan 4 · Tema resmi GNOME (GTK) yang menjadi referensi tampilan. · Implementasi: CSS + assets. · Prasyarat: memahami GTK CSS dan icon theming.
54. **Breeze Theme** · Lapisan 4 · Tema default KDE (Qt) dengan style engine Breeze. · Implementasi: QStyle, QML, assets. · Prasyarat: Qt styling and svg icons.
55. **Widget (Control)** · Lapisan 4 · Elemen UI dasar seperti button, label, entry. · Implementasi: toolkit-specific. · Prasyarat: knowledge of widget lifecycle and signals.
56. **Layout Manager** · Lapisan 4 · Komponen yang mengatur penempatan widget (box, grid, flow). · Implementasi: dalam toolkit (GTK Box, Qt Layouts). · Prasyarat: aljabar layout, container APIs.
57. **Model–View–Controller (MVC)** · Lapisan 4 · Pattern arsitektur UI untuk memisahkan data, tampilan, dan kontrol. · Implementasi: tersedia di Qt (Model/View). · Prasyarat: desain arsitektur aplikasi, data binding.
58. **Data Binding / Property Binding** · Lapisan 4 · Mekanisme sinkronisasi data model ke tampilan (QML bindings). · Implementasi: Qt/QML, custom frameworks. · Prasyarat: reactivity concepts.
59. **Composite Widgets / Custom Widget** · Lapisan 4 · Gabungan beberapa widget atau widget yang dibuat khusus. · Implementasi: toolkit language. · Prasyarat: pembuatan widget, drawing API.
60. **Signals & Slots / Event Handlers** · Lapisan 4 · Mekanisme komunikasi event antar objek UI (Qt signal/slot, GTK signal). · Implementasi: Qt C++ / GObject. · Prasyarat: concurrency model, thread safety.
61. **Retained-Mode vs Immediate-Mode UI** · Lapisan 4 · Paradigma UI: retained (stateful widgets) vs immediate (draw each frame). · Implementasi: Dear ImGui (immediate), GTK/Qt (retained). · Prasyarat: pemahaman lifecycle & performance tradeoffs.
62. **Widget Toolkit Accessibility (ATK / AT-SPI)** · Lapisan 4 · API untuk aksesibilitas (screen readers, magnifiers). · Implementasi: ATK (GTK) dan AT-SPI daemon. · Prasyarat: implementasi accessible interfaces, assistive tech.
63. **Accessibility Tree** · Lapisan 4 · Representasi semantik UI untuk pembaca layar. · Implementasi: toolkit exposes nodes to AT-SPI. · Prasyarat: semantic labeling, roles, states.
64. **Gesture Recognition (Tap/Swipe/Pinch)** · Lapisan 4 · Lapisan abstraksi pada toolkit untuk multi-touch gestures. · Implementasi: libinput + toolkit handlers. · Prasyarat: libinput config, gesture algorithms.
65. **Touch Event Handling** · Lapisan 4 · Penanganan event multitouch pada widget dan compositor. · Implementasi: Wayland wl_touch + toolkit mapping. · Prasyarat: touch protocols and coordinate transforms.
66. **Pointer Events (Mouse)** · Lapisan 4 · Event untuk gerakan pointer, klik, wheel. · Implementasi: toolkit event loop mapping. · Prasyarat: handling button mapping and grabs.
67. **Tablet / Stylus Support (libinput, libwacom)** · Lapisan 4 · Dukungan pressure/tilt pada perangkat tablet. · Implementasi: libinput, libwacom, toolkit integration. · Prasyarat: device calibration, pressure curves.
68. **Cursor Themes & Loading** · Lapisan 4 · Sistem tema kursor yang dipakai toolkit/compositor. · Implementasi: Xcursor spec, CSS/Qt configs. · Prasyarat: packaging cursor sets, xcursor naming.
69. **Render Backend Abstraction** · Lapisan 4 · Layer yang memungkinkan toolkit menggunakan OpenGL, Vulkan, atau CPU renderer. · Implementasi: toolkit glue (GDK/Qt Platform Abstraction). · Prasyarat: driver API familiarity (EGL/Vulkan).
70. **Offscreen Rendering / Render to Texture** · Lapisan 4 · Teknik render UI ke texture untuk efek/thumbnail. · Implementasi: FBO/EGLImage. · Prasyarat: EGL/GL FBO management.
71. **Headless Rendering** · Lapisan 4 · Rendering tanpa display fisik (testing/CI). · Implementasi: Mesa llvmpipe, headless EGL. · Prasyarat: build headless backends, virtual outputs.
72. **Scene Graph** · Lapisan 4 · Struktur hirarkis untuk representasi objek grafis dan transformasinya. · Implementasi: GSK/Qt SceneGraph/Skia GPU layers. · Prasyarat: scene traversal, culling, transform math.
73. **Layered Rendering** · Lapisan 4 · Pengaturan elemen UI dalam layer untuk batching dan efek. · Implementasi: Scene graph and renderer. · Prasyarat: layer composition and blending.
74. **Batch Draw Calls** · Lapisan 4 · Pengelompokan draw calls GPU untuk mengurangi overhead. · Implementasi: renderer optimizations. · Prasyarat: minimizing state changes, vertex buffers.
75. **Geometry Buffer / Vertex Buffers** · Lapisan 4 · Struktur data GPU untuk vertex/geometry. · Implementasi: GL/Vulkan buffers. · Prasyarat: buffer management, memory mapping.
76. **Index Buffers** · Lapisan 4 · Buffer yang mengurangi duplikasi vertex dengan index. · Implementasi: GL/Vulkan. · Prasyarat: mesh optimization.
77. **Instancing** · Lapisan 4 · Teknik menggambar banyak objek serupa dengan satu draw call. · Implementasi: GL/Vulkan instanced draws. · Prasyarat: shader support, instanced data.
78. **Shader Pipelines (Vertex/Fragment)** · Lapisan 4 · Tahapan shader utama untuk rendering grafis 2D/3D. · Implementasi: GLSL/Spir-V. · Prasyarat: shader programming & compiler tools.
79. **Shader Compilation (glslang / shaderc)** · Lapisan 4 · Tools yang mengompilasi GLSL menjadi SPIR-V atau binary GPU format. · Implementasi: C/C++. · Prasyarat: GLSL knowledge, build toolchain.
80. **SPIR-V** · Lapisan 4 · Intermediate binary format shader untuk Vulkan dan modern pipeline. · Implementasi: Khronos specification, compilers. · Prasyarat: shader toolchain.
81. **Pipeline State Object (Vulkan)** · Lapisan 4 · Objek immutable yang menggambarkan state render pipeline pada Vulkan. · Implementasi: Vulkan API. · Prasyarat: Vulkan concepts & serialization.
82. **Render Pass (Vulkan)** · Lapisan 4 · Unit kerja rendering yang mengatur attachments & subpasses. · Implementasi: Vulkan API. · Prasyarat: Vulkan render pass design.
83. **Descriptor Sets / Uniform Buffers** · Lapisan 4 · Mekanisme efisien mengirim data ke shader pada Vulkan. · Implementasi: Vulkan. · Prasyarat: memory layout & synchronization.
84. **Synchronization Primitives (Fences, Semaphores)** · Lapisan 4 · Sinkronisasi GPU/CPU dan antar command queues. · Implementasi: GL sync / Vulkan semaphores/fences. · Prasyarat: understanding GPU pipelines & hazards.
85. **Command Buffers** · Lapisan 4 · Rekaman perintah rendering untuk dikirim ke GPU (Vulkan). · Implementasi: Vulkan/Metal/D3D. · Prasyarat: command buffer lifecycle & reuse.
86. **Descriptor Heaps / Resource Binding** · Lapisan 4 · Struktur resource management di GPU modern. · Implementasi: API-specific. · Prasyarat: resource lifetime management.
87. **Memory Management (GPU)** · Lapisan 4 · Alokasi memori untuk textures/buffers dengan strategi pooling. · Implementasi: Vulkan memory allocator (VMA), GL map/unmap. · Prasyarat: GPU memory concepts, fragmentation handling.
88. **Texture Formats (RGBA, BGRA, sRGB)** · Lapisan 4 · Format penyimpanan pixel yang mempengaruhi warna dan gamma. · Implementasi: GPU and image libs. · Prasyarat: pixel layout & conversion.
89. **Compressed Texture Formats (ASTC, ETC, S3TC)** · Lapisan 4 · Format kompresi GPU-friendly untuk textures. · Implementasi: GPU/hardware codecs. · Prasyarat: toolchain compress, licensing (S3TC).
90. **Mipmapping & Mip Levels** · Lapisan 4 · Precomputed scaled textures untuk filtering dan performance. · Implementasi: GPU sampler & mip generation. · Prasyarat: generation tools, sampling settings.
91. **Anisotropic Filtering** · Lapisan 4 · Filtering texture yang mempertahankan detail saat sudut tajam. · Implementasi: GPU sampler settings. · Prasyarat: hardware feature query.
92. **Framebuffer Objects (FBO)** · Lapisan 4 · Off-screen rendering targets pada OpenGL/EGL. · Implementasi: GL/EGL APIs. · Prasyarat: FBO attachments and completeness rules.
93. **EGLImage / EGLStream** · Lapisan 4 · Abstraksi berbagi image antara producer/consumer di EGL/Vulkan world. · Implementasi: EGL extensions. · Prasyarat: driver support & dma-buf integration.
94. **EGLExternalImage / GLExternalTexture** · Lapisan 4 · Mekanisme untuk mengikat buffer dari luar sebagai texture. · Implementasi: EGL/GL extensions. · Prasyarat: cross-process buffer handling.
95. **VkImage / VkImageView** · Lapisan 4 · Representasi texture di Vulkan. · Implementasi: Vulkan API. · Prasyarat: image layouts, memory binding.
96. **Render Scaling (Supersampling / Downsample)** · Lapisan 4 · Teknik men-render lebih besar lalu downsample untuk kualitas. · Implementasi: renderer shaders / resolves. · Prasyarat: performance budgeting.
97. **Post-processing Effects (Blur, Bloom)** · Lapisan 4 · Efek visual yang diterapkan setelah render utama. · Implementasi: shader passes. · Prasyarat: multiple pass rendering & ping-pong buffers.
98. **UI Transitions & Animation** · Lapisan 4 · Animasi pada perubahan UI (smoothness, easing). · Implementasi: toolkit animation frameworks (Qt Animation, GSK). · Prasyarat: timing, interpolation, performance.
99. **Timing & Frame Interpolation** · Lapisan 4 · Teknik sinkronisasi animasi dengan frame presentation. · Implementasi: presentation feedback protocols. · Prasyarat: frame timestamps & latency control.
100. **Frame Pacing / Jank Avoidance** · Lapisan 4 · Teknik untuk menghindari stutter (jank) pada UI. · Implementasi: scheduling & smoothing strategies. · Prasyarat: profiling and tuning render pipeline.
101. **Compositing Engine (Toolkit)** · Lapisan 4 · Subsystem toolkit/compositor yang melakukan compositing layers. · Implementasi: GSK/Qt SceneGraph/Skia. · Prasyarat: blend modes, render passes.
102. **Software Rasterizer (Mesa llvmpipe)** · Lapisan 4 · Renderer CPU untuk fallback jika GPU tidak tersedia. · Implementasi: Mesa (C/C++). · Prasyarat: performance tradeoffs, vectorization.
103. **Hardware Acceleration (GPU)** · Lapisan 4 · Penggunaan GPU untuk menggambar dan compositing. · Implementasi: driver + Mesa/Vulkan. · Prasyarat: driver support, GL/Vulkan knowledge.
104. **ANGLE (Almost Native Graphics Layer Engine)** · Lapisan 4 · Abstraksi OpenGL ES di atas Vulkan/DirectX untuk portability. · Implementasi: C++. · Prasyarat: build ANGLE, backend mapping.
105. **Dawn (WebGPU)** · Lapisan 4 · Implementasi WebGPU (Google); modern API mirip Vulkan untuk web/desktop. · Implementasi: C++/Rust. · Prasyarat: WebGPU spec, backend (Vulkan/Metal).
106. **Skia GPU Backend (GrContext)** · Lapisan 4 · Abstraksi context GPU Skia (GrContext) untuk rendering. · Implementasi: C++. · Prasyarat: Skia build and API usage.
107. **Canvas API (HTML5)** · Lapisan 4 · 2D drawing API pada browser yang sering di-embed di desktop (Electron). · Implementasi: JS + Blink/Skia. · Prasyarat: JS and Canvas drawing concepts.
108. **WebGL / WebGPU Integration** · Lapisan 4 · Integrasi rendering web ke dalam aplikasi desktop. · Implementasi: browser engines (Chromium/Firefox). · Prasyarat: GPU drivers, sandboxing.
109. **QtWebEngine / QWebView** · Lapisan 4 · Embedding engine Chromium dalam Qt (untuk UI berbasis web). · Implementasi: C++ (Chromium). · Prasyarat: Chromium build, memory footprint considerations.
110. **GTK WebKit (WebKitGTK)** · Lapisan 4 · Binding WebKit untuk GTK berdasarkan WebKit2. · Implementasi: C, WebKit (C++). · Prasyarat: WebKit build and embedder integration.
111. **Rasterizer (Scan Conversion)** · Lapisan 4 · Komponen yang mengubah path/vector jadi pixel. · Implementasi: Pixman/Skia/Cairo. · Prasyarat: antialias, coverage algorithms.
112. **Antialiasing (MSAA / FXAA / SMAA)** · Lapisan 4 · Teknik penghalusan tepi untuk mengurangi jaggies. · Implementasi: GPU multisample, post-process shaders. · Prasyarat: shader programming and MSAA support.
113. **Stencil Buffer** · Lapisan 4 · Buffer untuk masking region render. · Implementasi: GL/Vulkan attachments. · Prasyarat: stencil operations knowledge.
114. **Depth Buffer** · Lapisan 4 · Buffer untuk z-ordering pada 3D scenes. · Implementasi: GL/Vulkan attachments. · Prasyarat: depth testing rules.
115. **Multisample Anti-Aliasing (MSAA)** · Lapisan 4 · Teknik antialiasing hardware tingkat multisample. · Implementasi: GL/Vulkan sample counts. · Prasyarat: memory/perf considerations.
116. **Alpha Testing / Discard** · Lapisan 4 · Pengujian alpha untuk menolak fragment tertentu. · Implementasi: shader/discard semantics. · Prasyarat: blending and order issues.
117. **Premultiplied Alpha** · Lapisan 4 · Format blending di mana warna sudah dikalikan alpha. · Implementasi: image formats & compositing rules. · Prasyarat: consistent usage across pipeline.
118. **Blend Equation & Factors** · Lapisan 4 · Aturan matematis penggabungan warna antar lapisan. · Implementasi: GL blend funcs. · Prasyarat: color compositing theory.
119. **Tessellation (Vector to Mesh)** · Lapisan 4 · Ubah curves menjadi triangles untuk GPU rendering. · Implementasi: CPU tessellator or GPU tessellation. · Prasyarat: tessellation accuracy & performance.
120. **Path Filling Rules (Even-Odd, Non-Zero)** · Lapisan 4 · Aturan menentukan interior path saat fill. · Implementasi: rasterizer algorithms. · Prasyarat: computational geometry.
121. **Text Rendering Pipeline (Toolkit)** · Lapisan 4 · Integrasi Pango/HarfBuzz/FreeType --> texture glyphs --> render. · Implementasi: C/C++. · Prasyarat: glyph atlas generation, caching.
122. **Glyph Atlas / Texture Atlas** · Lapisan 4 · Pengelompokan glyph kecil dalam satu texture untuk efisiensi. · Implementasi: texture packing algos. · Prasyarat: eviction & caching strategies.
123. **Glyph Caching** · Lapisan 4 · Strategi menyimpan glyph yang sering dipakai untuk mengurangi rasterisasi. · Implementasi: runtime caches. · Prasyarat: cache invalidation, atlasing.
124. **Text Layout Engines (Line Breaking)** · Lapisan 4 · Algoritma pemenggalan baris dan wrapping teks. · Implementasi: Pango / ICU. · Prasyarat: Unicode line break rules.
125. **Bi-di Reordering** · Lapisan 4 · Penataan ulang glyph untuk teks bidirectional. · Implementasi: ICU/HarfBuzz. · Prasyarat: BiDi algorithm.
126. **Emoji Support / Color Fonts** · Lapisan 4 · Dukungan font berwarna (COLR/CPAL, CBDT, sbix). · Implementasi: FreeType extension, color glyph pipelines. · Prasyarat: loader & rasterizer support.
127. **SVG Rendering in Toolkit** · Lapisan 4 · Render ikon atau paths SVG via librsvg atau Skia. · Implementasi: C/Rust/C++. · Prasyarat: handling CSS in SVG and transforms.
128. **Vector Graphics Cache** · Lapisan 4 · Menyimpan hasil raster vector untuk reuse. · Implementasi: RAM cache with keys. · Prasyarat: invalidation on transforms.
129. **Retina / HiDPI Asset Pipeline** · Lapisan 4 · Penyediaan asset @1x/@2x atau vector untuk HiDPI. · Implementasi: resource resolver. · Prasyarat: packaging and icon design.
130. **Resource Bundling (GResource / Qt Resource)** · Lapisan 4 · Mekanisme embed assets (icons, css) ke binary. · Implementasi: GLib GResource (C), Qt resource system. · Prasyarat: build integration.
131. **Localization / i18n (gettext)** · Lapisan 4 · Dukungan terjemahan string UI. · Implementasi: gettext, .po/.mo files. · Prasyarat: translations workflow.
132. **Right-to-Left Layout** · Lapisan 4 · Menata UI untuk bahasa RTL; mirroring controls. · Implementasi: toolkit layout mirroring. · Prasyarat: layout manager that supports direction.
133. **UI Testing (Headless & Screenshot)** · Lapisan 4 · Otomasi pengujian UI via headless rendering & image comparisons. · Implementasi: headless backends + testing harness. · Prasyarat: CI integration, stable rendering.
134. **Accessibility Bridges (AT-SPI Bridge)** · Lapisan 4 · Jembatan antara toolkit ATK dan at-SPI deamon untuk screen readers. · Implementasi: C, D-Bus. · Prasyarat: implement accessible objects and properties.
135. **Input Method Framework (IMF) / IBus / Fcitx** · Lapisan 4 · Sistem untuk input teks kompleks (IME untuk CJK). · Implementasi: C/C++/DBus. · Prasyarat: IMF protocol integration, preedit.
136. **Preedit / Candidate Window** · Lapisan 4 · UI untuk IME yang menampilkan teks sementara dan kandidat. · Implementasi: toolkit UI + IME protocol. · Prasyarat: IME protocol handling (XIM/Wayland text input).
137. **Text Input (Wayland text protocol)** · Lapisan 4 · Protokol Wayland untuk integrasi input method (text input v3/v4). · Implementasi: wl_text_input / text_input_unstable. · Prasyarat: compositor side text support.
138. **Cursor Management (Toolkit)** · Lapisan 4 · API untuk load/set cursor image and hotspots. · Implementasi: Xcursor spec / Wayland cursor APIs. · Prasyarat: cursor theme naming & loading.
139. **Drag & Drop (DND)** · Lapisan 4 · Mekanisme transfer data drag & drop antar aplikasi. · Implementasi: Wayland wl_data_device / Xdnd. · Prasyarat: MIME types handling & events.
140. **Clipboard Management** · Lapisan 4 · Sistem salin-tempel antar aplikasi; sync primary/clipboard selections. · Implementasi: Wayland data device / X selection. · Prasyarat: data offers, mime negotiation.
141. **Selection Fallbacks** · Lapisan 4 · Strategi fallback ketika format data tidak tersedia (text/plain). · Implementasi: data negotiation logic. · Prasyarat: understanding mime fallbacks.
142. **UI Threading Model** · Lapisan 4 · Kebijakan thread untuk event, render, dan worker tasks. · Implementasi: single-threaded UI + worker threads (common). · Prasyarat: thread safety, mainloop integration.
143. **Thread Safety in Toolkits** · Lapisan 4 · API dan constraints toolkit terkait concurrency. · Implementasi: toolkits often require all GUI ops on main thread. · Prasyarat: worker/job patterns & message passing.
144. **Main Loop / Event Loop (GLib / Qt)** · Lapisan 4 · Engine yang mengeksekusi callbacks dan timers untuk toolkit. · Implementasi: GLib mainloop (C), QEventLoop (Qt). · Prasyarat: event-driven programming.
145. **File Chooser Dialog Integration** · Lapisan 4 · Dialog akses file yang menghormati portals (Flatpak). · Implementasi: toolkit + xdg-desktop-portal. · Prasyarat: portal APIs, sandbox awareness.
146. **Open File Dialog (native vs portal)** · Lapisan 4 · Native dialog vs portal mediated for sandbox apps. · Implementasi: toolkit + xdg portal glue. · Prasyarat: portal integration.
147. **Printing Backend (CUPS)** · Lapisan 4 · Dukungan percetakan dari toolkit lewat CUPS. · Implementasi: libcups + toolkit print APIs. · Prasyarat: cups driver, PPD, print preview.
148. **PDF Export / Vector Export** · Lapisan 4 · Kemampuan toolkit untuk mengekspor drawing ke PDF/SVG. · Implementasi: Cairo/PDF backend. · Prasyarat: output surface creation.
149. **Canvas / Drawing API (Immediate)** · Lapisan 4 · API low-level untuk menggambar bentuk secara langsung (HTML5 canvas, Cairo immediate). · Implementasi: JS/C/C++. · Prasyarat: path APIs, state handling.
150. **Scene Serialization (UI State)** · Lapisan 4 · Menyimpan state scenegraph untuk restore/layout persistence. · Implementasi: JSON/XML scene dumps. · Prasyarat: deterministic state storage.
151. **Widget Theme Engines (CSS Parser)** · Lapisan 4 · Komponen parser CSS-like untuk toolkit theming. · Implementasi: toolkit parser (C/C++). · Prasyarat: lexing/parsing, style resolution.
152. **Icon Loading & Caching** · Lapisan 4 · Subsystem untuk men-load and cache icons at various sizes. · Implementasi: toolkit resource loader. · Prasyarat: caching strategies, file IO.
153. **Resource Fallbacks (raster → vector)** · Lapisan 4 · Strategi fallback asset bila resolusi tertentu tidak tersedia. · Implementasi: resource resolver code. · Prasyarat: multiple assets & scalable fallback logic.
154. **Hot Reloading UI (Development)** · Lapisan 4 · Kemampuan reload UI code (QML/GTK) tanpa restart app for rapid dev. · Implementasi: QML live reload, GTK builder refresh. · Prasyarat: live reload mechanisms & safety.
155. **GTK Builder / UI XML** · Lapisan 4 · Format deklaratif (XML) untuk membangun UI di GTK. · Implementasi: libgtk builder (C). · Prasyarat: understanding builder ids and signals.
156. **Qt Designer / .ui Files** · Lapisan 4 · Tool visual untuk merancang UI dan menghasilkan .ui XML. · Implementasi: Qt tools (C++). · Prasyarat: ui loading and promotion patterns.
157. **UI Profiling Tools (gdk-pixbuf / valgrind / renderdoc)** · Lapisan 4 · Tools untuk profiling dan debugging rendering. · Implementasi: various tools. · Prasyarat: instrumenting render code.
158. **RenderDoc Integration** · Lapisan 4 · Capture & analyze GPU frames to debug render issues. · Implementasi: RenderDoc (C++), GL/Vulkan hooks. · Prasyarat: build with debug symbols & capture setup.
159. **Performance Counters (GPU / CPU)** · Lapisan 4 · Metrics untuk profiling rendering and UI responsiveness. · Implementasi: perf, GPU vendor tools. · Prasyarat: performance measurement and analysis.
160. **Hotkey / Accelerator Handling** · Lapisan 4 · Sistem shortcut global/local di toolkit. · Implementasi: toolkit accelerators APIs. · Prasyarat: focus & conflict resolution.
161. **Modal Dialogs / Blocking UI** · Lapisan 4 · Dialog yang memblokir interaksi hingga closed. · Implementasi: toolkit modal dialog APIs. · Prasyarat: event loop blocking patterns and alternatives.
162. **Non-blocking Dialog Patterns** · Lapisan 4 · Asynchronous dialogs using callbacks/promises. · Implementasi: async APIs in toolkit. · Prasyarat: async programming patterns.
163. **Accessibility Role Mapping** · Lapisan 4 · Mapping widget types to AT roles for assistive tech. · Implementasi: toolkit accessibility APIs. · Prasyarat: semantic labeling.
164. **Testing Accessibility (Orca, Accerciser)** · Lapisan 4 · Tools untuk mengecek interface accessibility exposure. · Implementasi: Python tools + AT-SPI. · Prasyarat: accessible object implementation.
165. **Input Focus Management (Toolkit)** · Lapisan 4 · Kebijakan toolkit tentang fokus keyboard & focus chain. · Implementasi: focus APIs. · Prasyarat: focus traversal rules.
166. **Modal vs Modeless Windows** · Lapisan 4 · Perbedaan perilaku windows memengaruhi input routing. · Implementasi: toolkit window flags. · Prasyarat: window management integration.
167. **Window Transience & Parenting** · Lapisan 4 · Hubungan popup/dialog ke parent window. · Implementasi: xdg_toplevel/xdg_popup mapping. · Prasyarat: transient_for semantics.
168. **Window Decorations Integration (CSD/SSD)** · Lapisan 4 · Bagaimana toolkit mendukung decoration client/server side. · Implementasi: CSS (CSD) / compositor SSD protocols. · Prasyarat: protocol negotiation (xdg-decoration).
169. **Client Side Decorations (CSD) Patterns** · Lapisan 4 · Implementasi CSD di toolkit (draw titlebar inside app). · Implementasi: toolkit-drawn chrome. · Prasyarat: window drag regions and hit testing.
170. **Server Side Decorations (SSD) Protocol** · Lapisan 4 · Protocol untuk meminta compositor menggambar decoration. · Implementasi: xdg-decoration, zwlr-decoration. · Prasyarat: compositor support.
171. **Window Manager Hints (EWMH/NETWM)** · Lapisan 4 · Hints agar toolkit/request window behaves expected under WM. · Implementasi: set window properties (X11/XWayland). · Prasyarat: knowledge of EWMH atoms.
172. **Wayland Shell Protocols (xdg-shell)** · Lapisan 4 · Interface yang toolkit gunakan untuk kontrol toplevel windows. · Implementasi: xdg-shell binding in toolkit. · Prasyarat: protocol binding and lifecycle handling.
173. **Wayland Decoration Protocols (xdg-decoration)** · Lapisan 4 · Negosiasi layanan decoration antara client & compositor. · Implementasi: protocol handlers. · Prasyarat: supporting both client and server side cases.
174. **X11 Compatibility Layer (XWayland support)** · Lapisan 4 · Bagaimana toolkit handles X11 windows when running under Wayland via XWayland. · Implementasi: toolkit mapping code. · Prasyarat: X11 properties mapping and event translation.
175. **Window Role / Transient For (Toolkit semantics)** · Lapisan 4 · Marking dialogs/popups with roles to guide WM behaviour. · Implementasi: toolkit window properties. · Prasyarat: mapping to shell protocols.
176. **Window Sizing Hints / Minimum & Preferred Size** · Lapisan 4 · Controls how WM/compositor resizes windows. · Implementasi: toolkit size request APIs. · Prasyarat: layout measuring and constraints.
177. **Resize Grip & Hit Testing** · Lapisan 4 · Regions to resize windows, toolkit must expose hotspots. · Implementasi: hit testing & input mapping. · Prasyarat: pointer grabs and decoration hit regions.
178. **Drag Source / Drop Target API (Toolkit)** · Lapisan 4 · Abstraction for DnD operations inside app/toolkit. · Implementasi: toolkit DnD APIs -> underlying wl_data_device. · Prasyarat: MIME negotiation & data transfer strategies.
179. **Clipboard Persistence & Session Restore** · Lapisan 4 · Making clipboard survive across sessions (clipboard managers). · Implementasi: apps + system clipboard managers. · Prasyarat: clipboard owner semantics.
180. **UI Localization (RTL + Plural Forms)** · Lapisan 4 · Support for plural rules and directionality in UI text. · Implementasi: gettext + toolkit layout. · Prasyarat: translation workflows & plural rules.
181. **Widget Accessibility Properties (name/description/state)** · Lapisan 4 · Exposing semantic properties for assistive tools. · Implementasi: toolkit accessibility APIs. · Prasyarat: semantic mapping and testing.
182. **Crash Recovery (UI state save)** · Lapisan 4 · Mechanism for saving UI state to restore after crash. · Implementasi: serialization and safe restore. · Prasyarat: deterministic UI state & persistence.
183. **Plugin Architecture (Toolkit Extendability)** · Lapisan 4 · System to extend UI functionality via plugins. · Implementasi: plugin API, sandboxing. · Prasyarat: stable ABI & plugin lifecycle.
184. **Scripting Bindings (Lua, Python)** · Lapisan 4 · Embedding scripting for UI customization. · Implementasi: interpreter embeds & bindings. · Prasyarat: safe expose of APIs & security.
185. **Widget Inspectors / DevTools** · Lapisan 4 · Tools to introspect widget tree, properties, and styles. · Implementasi: devtools (QtCreator, GTKInspector). · Prasyarat: enabled debug hooks and metadata.
186. **Accessibility Testing Automation** · Lapisan 4 · Automated checks for accessibility compliance. · Implementasi: axe-like tools, AT-SPI test harness. · Prasyarat: accessibility exposed metadata.
187. **Memory Management (Toolkit)** · Lapisan 4 · Object ownership rules (refcounting, GC) in toolkit. · Implementasi: GObject refcount / C++ RAII. · Prasyarat: resource lifecycle knowledge.
188. **Resource Leak Detection** · Lapisan 4 · Tools & patterns to detect leaks in UI applications. · Implementasi: ASAN, valgrind, sanitizer hooks. · Prasyarat: build with debug flags.
189. **Bundle & Packaging (AppImage, Flatpak, Snap)** · Lapisan 4 · How UI apps packaged for distribution including resources. · Implementasi: packaging tools. · Prasyarat: sandbox & portal integration.
190. **Sandboxing UI apps (Flatpak portals)** · Lapisan 4 · Using portals to let sandboxed apps access host services securely. · Implementasi: xdg-desktop-portal + backends. · Prasyarat: portal API usage & permission flow.
191. **Toolkit Security Practices (Input Sanitization)** · Lapisan 4 · Secure handling of input and clipboard content. · Implementasi: toolkit input APIs & validation. · Prasyarat: threat model awareness and sanitization.
192. **UI Telemetry / Usage Metrics (Privacy)** · Lapisan 4 · Mechanisms to collect UI performance/usage while preserving privacy. · Implementasi: opt-in telemetry hooks. · Prasyarat: privacy policy & anonymization.
193. **Theming Engines Extensibility (plugins/themes)** · Lapisan 4 · Extensible theming mechanisms for user customization. · Implementasi: theme plugins & resource overrides. · Prasyarat: plugin APIs and security review.
194. **Declarative UI (Markup)** · Lapisan 4 · UI described in markup (QML, Glade XML) for separation of logic. · Implementasi: Qt QML, GTK Builder. · Prasyarat: bindings & loader usage.
195. **Reactive UI Patterns** · Lapisan 4 · Data-driven reactive updates (observables, signals). · Implementasi: QML bindings, custom reactive libs. · Prasyarat: understand data flow & change propagation.
196. **Tooling for Designers (Sketch → assets pipeline)** · Lapisan 4 · Workflow to convert design assets into app resources. · Implementasi: export scripts, asset managers. · Prasyarat: tooling chain (icons, fonts, sizes).
197. **Performance Budgets & Frame Targets (60fps / 120fps)** · Lapisan 4 · Target frame rates for smooth UI; affects design choices. · Implementasi: profiling & render optimization. · Prasyarat: profiling tools & render pipeline optimization.
198. **Cross-Process UI Composition (XWayland / Wayland bridging)** · Lapisan 4 · Handling windows from other processes in a single scene. · Implementasi: compositor XWayland bridging, dmabuf. · Prasyarat: buffer sharing & event translation.
199. **Integration with Window Manager / Compositor Protocols** · Lapisan 4 · Toolkit must honor compositor protocols (xdg-shell, layer-shell). · Implementasi: toolkit shell bindings. · Prasyarat: implement shell lifecycle, decoration negotiation.
200. **Developer Checklist to Modify or Extend a Toolkit/Renderer** · Lapisan 4 · Ringkasan: pelajari bahasa implementasi (C/C++/Rust), setup build (Meson/CMake/GN), pahami backend GPU (EGL/Vulkan/GL), pelajari text/font pipeline (FreeType/HarfBuzz/Pango), testing headless & profiling tools, dan integrasi ke compositor (Wayland/XWayland, dmabuf). · Implementasi: dokumentasi proyek & example patches. · Prasyarat: proficiency in target language, build systems, GPU concepts, and contributor workflow.

---

# **Selamat!**

Penyusunana ini lengkap dengan konteks pengembangan dan prasyarat singkat. Ini memberi peta lengkap untuk memahami, mengembangkan, atau memodifikasi toolkit dan rendering engine — mulai dari widget level hingga shader dan sinkronisasi GPU.
<!---

Langkah berikut yang direkomendasikan:

* mengekstrak subset praktis (mis. semua istilah terkait *text rendering* untuk fokus pada Pango/HarfBuzz/FreeType), atau
* menyiapkan **checklist teknis langkah-demi-langkah** untuk memodifikasi satu contoh nyata (mis. menambahkan backend Vulkan ke toolkit kecil), lengkap dengan perintah build dan dependensi.


Saya akan langsung menyiapkan salah satu dari dua opsi di atas sesuai prioritas pembelajaran Anda; saya pilih **menyusun checklist langkah-demi-langkah untuk menambahkan backend Vulkan ke sebuah toolkit sederhana** agar sesuai tujuan Anda menjadi ahli IT dan pengembang compositing—saya mulai sekarang.
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
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

------------------------------------------------->

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
