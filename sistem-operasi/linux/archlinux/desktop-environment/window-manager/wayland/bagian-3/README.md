<!--
Bagus — saya mulai Lapisan 3 dengan **Subbagian 3.1: Konsep inti Compositor & Window Manager (1–50)**. Setiap entri singkat, teknis, dan fokus pada peran atau konsep dalam pengelolaan jendela, tata letak (tiling/stacking), manajemen surface, scene graph, rendering, serta interaksi input pada tingkat compositor/window manager.
---
-->
# Lapisan 3 — Konsep inti Compositor & Window Manager (1–200).

1. **Compositor**
   Program yang mengambil buffer dari klien, menggabungkan (compose) mereka sesuai Z-order dan transformasi, lalu mengirim hasil akhir ke output.

2. **Window Manager**
   Komponen yang menentukan perilaku jendela (posisi, ukuran, dekorasi, fokus). Pada Wayland sering digabung dengan compositor; pada X11 sering terpisah.

3. **Tiling Window Manager**
   Jenis WM yang mengatur jendela dalam tata letak non-tumpuk (tiling) otomatis sehingga layar terbagi menjadi sel tanpa tumpang tindih.

4. **Stacking Window Manager**
   Jenis WM yang menggunakan urutan tumpukan (stack) jendela, memungkinkan tumpang tindih bentuk tradisional (floating).

5. **Reparenting**
   Prinsip X11 di mana WM “mereparent” window klien ke frame miliknya untuk menambahkan dekorasi; konsep ini tidak ada pada Wayland.

6. **Static Tiling**
   Model tiling dengan tata letak tetap yang tidak berubah kecuali perintah eksplisit pengguna (mis. dwm master/stack).

7. **Dynamic Tiling**
   Model tiling yang menyesuaikan ukuran/posisi jendela secara otomatis mengikuti aturan layout (mis. i3, Sway).

8. **Layout Algorithm**
   Algoritma yang menentukan pembagian ruang (binary-split, columns, rows, grid, monocle) pada tiling WM.

9. **Container**
   Unit struktur pada WM/compositor yang menampung satu atau beberapa view/window serta metadata layout.

10. **Workspace / Virtual Desktop**
    Ruang kerja virtual yang memuat sekumpulan jendela; berpindah antar-workspace mempermudah organisir.

11. **Surface (Compositor View)**
    Representasi klien di compositor—permukaan grafis yang dapat diposisikan, diberi transformasi, dan dirender.

12. **View**
    Entitas compositor yang menghubungkan `wl_surface` (atau window X) dengan metadata tiling/stacking, fokus, dan state.

13. **Subsurface**
    Surface anak yang menempel pada surface induk untuk tujuan layout internal (tooltip, popup, drop-down).

14. **Toplevel / Shell Surface**
    Surface utama yang diperlakukan sebagai jendela biasa (bukan popup), mendukung maximize/minimize/fullscreen.

15. **Popup / Transient**
    Surface sementara (menu, tooltip, dialog) yang berasosiasi sementara dengan surface induk.

16. **Layer / Z-layer**
    Pengelompokan surface menurut prioritas rendering (background, bottom, top, overlay).

17. **Panel / Dock**
    Surface layer khusus untuk panel atau dock yang umumnya diletakkan di tepi layar dan diberi prioritas tertentu.

18. **Status Bar**
    Komponen UI ringkas yang menampilkan informasi sistem; sering digambar oleh compositor atau program eksternal.

19. **Window Decoration**
    Elemen visual di sekitar konten jendela (frame, titlebar, tombol) — dapat dibuat oleh klien (CSD) atau server (SSD).

20. **Client-Side Decoration (CSD)**
    Dekorasi jendela yang digambar oleh aplikasi itu sendiri, bukan compositor.

21. **Server-Side Decoration (SSD)**
    Dekorasi yang ditangani oleh compositor atau WM, memberikan penampilan konsisten.

22. **Frame**
    Bingkai visual yang mengelilingi konten window; sering dipakai untuk mendeteksi area resize dan drag.

23. **Titlebar**
    Bagian pada frame yang menampilkan judul jendela dan kontrol (close, maximize, minimize).

24. **Resize Handle / Edge**
    Area interaktif di tepi frame yang digunakan pengguna untuk mengubah ukuran jendela.

25. **Snap / Tiling Snap**
    Mekanisme “mengait” jendela ke grid atau tepi saat menggeser/resize untuk memudahkan penataan.

26. **Floating Window**
    Window yang tidak terikat pada layout tiling, bisa bergerak bebas di atas layar.

27. **Focus (Input Focus)**
    Status yang menentukan target event keyboard/pointer; strategi umum: click-to-focus, focus-follows-mouse, atau slo-mo focus.

28. **Focus Stack / Focus History**
    Jejak riwayat fokus untuk memudahkan kembali ke jendela sebelumnya (Alt-Tab, fokus recovery).

29. **Focus Stealing Prevention**
    Kebijakan yang mencegah klien mengambil fokus secara tiba-tiba saat pengguna sedang bekerja.

30. **Z-order / Stacking Order**
    Urutan vertikal tampilan jendela; menentukan apa yang terlihat di atas apa.

31. **Damage Tracking**
    Sistem yang merekam region layar yang berubah (damage) sehingga compositor hanya me-repaint area tersebut.

32. **Damage Buffer / Damage Ring**
    Buffer/data structure yang menyimpan daftar region rusak untuk efisiensi redraw.

33. **Repaint / Redraw**
    Operasi penggambaran ulang region yang mengalami damage pada frame selanjutnya.

34. **Frame Scheduling**
    Penjadwalan rendering frame yang sinkron dengan refresh output (VSync/Presentation) agar mengurangi tearing.

35. **Render Pass**
    Tahap terpisah dalam rendering (mis. ambient pass, opaque pass, translucent pass) untuk mengefisienkan blending dan batching.

36. **Render Target / Framebuffer Object (FBO)**
    Buffer tujuan rendering dimana compositor menggambar hasil komposisi sebelum swap ke layar.

37. **Texture**
    Representasi gambar di GPU yang digunakan compositor untuk menggambar surface klien.

38. **Texture Upload**
    Proses memindahkan pixels dari buffer klien ke texture GPU; vulkan/egl/gl operations terkait.

39. **Batching**
    Penggabungan beberapa draw call ke dalam satu operasi GPU untuk mengurangi overhead.

40. **Clipping**
    Pembatasan area rendering agar draw tidak melampaui boundary tertentu (mengurangi overdraw).

41. **Scissor Rect**
    Mekanisme grafis untuk memotong gambar pada rectangle sederhana sebelum menggambar.

42. **Alpha Blending / Compositing Mode**
    Proses menggabungkan pixel semi-transparan dari layer berbeda sesuai nilai alpha.

43. **Opacity**
    Properti visual surface yang mengatur transparansi relatif; dapat diubah untuk efek.

44. **Blend Mode**
    Aturan matematis yang menentukan cara gabungan warna (normal, additive, multiply, dsb.).

45. **Occlusion Culling**
    Optimalisasi untuk melewatkan rendering objek yang sepenuhnya tertutup oleh objek lain.

46. **Scene Graph**
    Struktur data hirarkis yang merepresentasikan node (view, layer, transform) untuk compositing dan hit-testing.

47. **Node Transform (Translate/Scale/Rotate)**
    Transformasi matriks yang diterapkan ke node scene graph untuk memosisikan dan memutar surface.

48. **Coordinate Space (Local / Global)**
    Sistem koordinat lokal pada surface dan koordinat global pada output/compositor.

49. **Hit-testing / Input Hit Region**
    Proses menentukan surface atau node yang berada di bawah pointer untuk dispatch event.

50. **Pointer Grab / Keyboard Grab**
    Mekanisme dimana sebuah client atau compositor “mengunci” event pointer/keyboard (mis. saat drag, menu modal) sehingga semua event dikirim ke pemegang grab.

---

### **Layout, Container, Rules, Focus, dan XWayland Integration**

#### Bagian berikut berfokus pada: *algoritma layout tiling, manajemen container, rules & matching, fokus & input policy, serta integrasi X11/XWayland di compositor Wayland modern seperti Sway, river, dan Hyprland.*

---

51. **Layout Engine**
    Mesin logika dalam WM yang menghitung posisi dan ukuran setiap jendela sesuai tata letak aktif.

52. **Binary Split Layout**
    Algoritma tiling berbasis pembagian biner (horizontal/vertikal) — dasar layout i3 dan Sway.

53. **Master–Stack Layout**
    Model tiling dengan area utama (master) dan area sekunder (stack), populer di dwm dan derivatifnya.

54. **Column Layout**
    Layout yang menempatkan jendela dalam kolom vertikal dengan tinggi menyesuaikan jumlah jendela.

55. **Row Layout**
    Layout horizontal yang membagi ruang layar menjadi baris sejajar.

56. **Grid Layout**
    Layout berbentuk kisi dua dimensi, cocok untuk banyak jendela kecil.

57. **Monocle Layout**
    Hanya satu jendela ditampilkan fullscreen; lainnya tersembunyi di baliknya.

58. **Spiral Layout (Golden Ratio)**
    Layout dengan pembagian layar mengikuti proporsi rasio emas (≈1.618) untuk estetika ruang optimal.

59. **Tabbing Layout**
    Layout yang menumpuk jendela seperti tab browser dalam satu container.

60. **Floating Layout Mode**
    Mode di mana tata letak dinonaktifkan dan jendela dapat diposisikan bebas oleh pengguna.

61. **Dynamic Layout Switching**
    Kemampuan compositor untuk berpindah layout dengan shortcut atau rule otomatis.

62. **Split Direction (Horizontal/Vertical)**
    Parameter arah pembagian ruang saat menambah jendela baru.

63. **Resize Factor / Split Ratio**
    Nilai proporsional (biasanya 0.5) yang menentukan besar pembagian ruang antar jendela.

64. **Container Tree**
    Struktur hirarki container di mana setiap node bisa berisi jendela atau sub-container (mirip pohon biner).

65. **Node Type (Split, Leaf)**
    Jenis node pada container tree; *split node* memiliki anak, sedangkan *leaf node* berisi jendela.

66. **Parent–Child Relationship**
    Hubungan antar container dalam hierarki layout yang menentukan turunan properti.

67. **Container Focus**
    Status fokus pada node container, bukan hanya pada jendela tunggal.

68. **Scratchpad**
    Fitur untuk menyembunyikan jendela sementara dan memunculkannya kembali dengan shortcut.

69. **Sticky Window**
    Jendela yang selalu muncul di semua workspace.

70. **Swallowing**
    Fitur di mana terminal sementara “menggantikan dirinya” dengan aplikasi GUI yang diluncurkan darinya (contoh: `alacritty --someapp`).

71. **Window Rules**
    Aturan yang memaksa jendela tertentu memiliki perilaku atau layout tertentu (title, class, role match).

72. **Match Criteria**
    Parameter yang digunakan untuk mencocokkan rule (misal `app_id`, `window_class`, `title`, `role`).

73. **Rule Action**
    Tindakan yang dijalankan bila rule cocok, seperti floating, tiling, fullscreen, assign ke workspace tertentu.

74. **Title Matching**
    Pencocokan berdasarkan judul window, berguna untuk aplikasi multi-instance seperti editors.

75. **App ID Matching**
    Metode pencocokan berbasis `app_id` dari Wayland client (sering digunakan di Sway/Hyprland).

76. **Window Role Matching**
    Digunakan pada aplikasi toolkit GTK/Qt untuk membedakan dialog, popup, dan main window.

77. **Focus Policy**
    Kebijakan bagaimana fokus diberikan kepada jendela (click-to-focus, sloppy focus, follow mouse).

78. **Focus Follows Mouse**
    Fokus berpindah otomatis ke jendela di bawah kursor tanpa klik.

79. **Click-to-Focus**
    Jendela hanya menerima fokus setelah diklik langsung oleh pengguna.

80. **Auto-Focus Rule**
    Kebijakan compositor untuk memberi fokus otomatis pada jendela baru (bisa diatur berdasarkan kelas/role).

81. **Focus Cycling**
    Rotasi fokus antar jendela aktif dalam workspace (mis. Alt+Tab).

82. **Directional Focus**
    Perpindahan fokus berdasarkan arah relatif (atas, bawah, kiri, kanan) sesuai layout grid.

83. **Input Region**
    Area jendela yang dapat menerima event pointer/keyboard; didefinisikan oleh klien.

84. **Pointer Constraint**
    Mekanisme Wayland untuk membatasi gerakan pointer di area tertentu (dragging, game locking).

85. **Relative Pointer Motion**
    Ekstensi Wayland yang memungkinkan pelacakan gerakan relatif (mis. dalam game FPS).

86. **Keyboard Grab**
    Mode input eksklusif di mana satu klien menerima seluruh event keyboard.

87. **Pointer Grab**
    Mode input eksklusif untuk event mouse/pointer.

88. **Input Inhibition**
    Kebijakan yang memungkinkan compositor menonaktifkan input sementara (lockscreen).

89. **Focus Stack Algorithm**
    Algoritma yang mengatur urutan fokus antar jendela, mempertahankan prediktabilitas interaksi.

90. **Input Seat**
    Abstraksi Wayland yang merepresentasikan satu set perangkat input (keyboard, pointer, touch).

91. **Seat Management**
    Pengelolaan beberapa seat (mis. konfigurasi multi-user, input berbeda di layar berbeda).

92. **Keyboard Layout Switching**
    Kemampuan compositor mengganti layout keyboard aktif secara per-seat atau global.

93. **XWayland**
    Lapisan kompatibilitas yang memungkinkan aplikasi X11 berjalan di atas compositor Wayland.

94. **XWayland Bridge**
    Komponen penghubung antara X server bawaan XWayland dan compositor Wayland.

95. **XWayland Surface**
    Representasi internal dari jendela X11 di dalam compositor Wayland.

96. **XWM (X Window Manager inside XWayland)**
    Manajer jendela internal khusus XWayland untuk menangani event X11.

97. **XEmbed**
    Protokol embedding jendela (misal tray icon) yang digunakan aplikasi X11 di lingkungan modern.

98. **XDamage Extension**
    Ekstensi X11 untuk memberitahu compositor area mana dari window yang berubah.

99. **XComposite Extension**
    Ekstensi X11 yang memungkinkan window dikomposisikan secara eksternal oleh compositor.

100. **XRender / GLX / Present**
     Ekstensi X11 untuk rendering grafis dan sinkronisasi buffer yang diterjemahkan compositor Wayland saat bridging XWayland.

---

### **Rendering Pipeline & Hardware Acceleration**

#### Berikutnya adalah yang memusatkan pembahasan pada *Rendering Pipeline & Hardware Acceleration*, yaitu rantai teknis yang mengubah buffer dari aplikasi menjadi tampilan akhir di layar melalui GPU, API grafis, serta sinkronisasi frame.

---

101. **Rendering Pipeline**
     Urutan proses yang mengubah data geometris menjadi pixel akhir di layar menggunakan GPU.

102. **Hardware Acceleration**
     Pemanfaatan GPU untuk mempercepat rendering grafis dibandingkan pemrosesan CPU murni.

103. **EGL (Embedded-System Graphics Library)**
     Lapisan antar OpenGL ES/Vulkan dengan sistem windowing (X11, Wayland, DRM); mengatur konteks dan buffer.

104. **EGL Display**
     Objek yang merepresentasikan koneksi EGL ke display system (misal Wayland display atau DRM device).

105. **EGL Context**
     Konteks eksekusi OpenGL yang berisi seluruh state rendering GPU.

106. **EGL Surface**
     Buffer tempat hasil rendering GPU ditulis, biasanya terkait window atau off-screen framebuffer.

107. **EGL Config**
     Konfigurasi framebuffer EGL yang menentukan format warna, depth, stencil, dsb.

108. **EGL Swap Buffers**
     Operasi menukar buffer depan dan belakang setelah rendering selesai (double buffering).

109. **OpenGL (Open Graphics Library)**
     API lintas platform untuk rendering 2D/3D; digunakan compositor klasik seperti Mutter dan KWin.

110. **OpenGL ES (Embedded Systems)**
     Versi OpenGL ringan yang digunakan di Wayland compositor (Sway, Weston).

111. **GLSL (OpenGL Shading Language)**
     Bahasa pemrograman shader yang dijalankan di GPU untuk operasi vertex dan fragment.

112. **Vertex Shader**
     Tahap awal pipeline GPU yang memproses posisi vertex.

113. **Fragment Shader (Pixel Shader)**
     Tahap akhir pipeline yang menghitung warna akhir tiap pixel.

114. **Shader Program**
     Gabungan vertex dan fragment shader yang dikompilasi dan di-link ke GPU pipeline.

115. **Uniform Variable**
     Nilai global yang dikirim dari CPU ke shader (misal matriks transformasi, warna).

116. **Attribute Variable**
     Data per-vertex yang dikirim ke shader untuk menggambar bentuk.

117. **VBO (Vertex Buffer Object)**
     Buffer di GPU yang menyimpan data vertex agar rendering lebih cepat.

118. **VAO (Vertex Array Object)**
     Struktur metadata yang mendeskripsikan bagaimana data vertex diambil dari VBO.

119. **FBO (Framebuffer Object)**
     Buffer off-screen yang digunakan compositor untuk menggambar sebelum menampilkan ke layar.

120. **Renderbuffer**
     Buffer tambahan pada FBO untuk depth atau stencil.

121. **Texture Mapping**
     Proses menerapkan gambar (texture) ke bentuk geometris dalam rendering.

122. **Sampler Object**
     Objek GPU yang menentukan bagaimana texture diambil (filtering, wrapping).

123. **Mipmapping**
     Teknik penyimpanan texture dalam berbagai resolusi untuk mempercepat rendering jarak jauh.

124. **Blitting**
     Pemindahan blok pixel (bit block transfer) antara buffer — sering digunakan untuk komposisi sederhana.

125. **Hardware Cursor**
     Kursor yang digambar langsung oleh GPU tanpa melalui compositor untuk menghemat waktu render.

126. **DMA (Direct Memory Access)**
     Transfer data langsung antar memori dan perangkat tanpa intervensi CPU.

127. **DMA-BUF (DMA Buffer Sharing)**
     Mekanisme berbagi buffer antar proses grafis (Wayland, GPU, compositor).

128. **GBM (Generic Buffer Management)**
     API dari Mesa untuk mengelola buffer GPU di bawah Wayland/DRM.

129. **wl_drm**
     Protokol Wayland lama untuk berbagi buffer berbasis DRM (digantikan oleh linux-dmabuf).

130. **linux-dmabuf**
     Protokol Wayland modern untuk berbagi buffer GPU secara efisien lintas aplikasi.

131. **DRI (Direct Rendering Infrastructure)**
     Lapisan kernel dan user-space untuk rendering langsung ke GPU (tanpa perantara X server).

132. **DRI2 / DRI3**
     Versi DRI dengan model sinkronisasi buffer dan efisiensi lebih baik.

133. **Mesa 3D**
     Implementasi open source OpenGL/Vulkan untuk Linux, dasar rendering pada hampir semua compositor modern.

134. **Gallium3D**
     Framework driver dalam Mesa yang memisahkan API dari backend hardware.

135. **LLVMpipe**
     Driver Mesa berbasis CPU, digunakan ketika GPU tidak tersedia (software rasterizer).

136. **Vulkan API**
     API grafis modern berbasis command buffer dengan kontrol eksplisit terhadap GPU, menggantikan OpenGL.

137. **SPIR-V**
     Format bytecode shader yang digunakan Vulkan untuk menggantikan GLSL langsung.

138. **VK_KHR_swapchain**
     Ekstensi Vulkan yang menangani pertukaran buffer (swap chain) untuk presentasi layar.

139. **VK_KHR_display**
     Ekstensi Vulkan untuk output langsung ke layar tanpa compositor.

140. **Vulkan Wayland WSI (Window System Integration)**
     Lapisan integrasi Vulkan agar dapat bekerja di atas Wayland compositor.

141. **GPU Context Loss**
     Kondisi di mana state GPU hilang (misal sleep/resume), compositor perlu merekonstruksi konteks EGL/Vulkan.

142. **Tearing**
     Artefak visual akibat ketidaksinkronan antara refresh display dan swap buffer.

143. **VSync (Vertical Synchronization)**
     Teknik sinkronisasi render dengan refresh rate monitor untuk mencegah tearing.

144. **Adaptive Sync / FreeSync / G-Sync**
     Teknologi sinkronisasi dinamis antara GPU dan layar untuk frame rate variabel.

145. **Presentation Time Protocol (wp_presentation)**
     Ekstensi Wayland untuk mengukur waktu aktual frame ditampilkan di layar.

146. **Frame Callback (wl_surface.frame)**
     Mekanisme Wayland yang memberi tahu klien kapan aman menggambar frame berikutnya.

147. **Frame Latency**
     Waktu tunda antara submit frame oleh compositor dan tampil di layar.

148. **Swap Interval**
     Parameter jumlah refresh yang dilewati antara setiap buffer swap (biasanya 1 untuk VSync aktif).

149. **Triple Buffering**
     Teknik menggunakan tiga buffer untuk mengurangi stutter akibat blocking frame.

150. **Render Time Profiling**
     Analisis performa pipeline rendering compositor, digunakan untuk debugging lag, tearing, atau overdraw.

---

### Scene Composition, Effects, Frame Scheduling, Output Management.
Kita masuk ke bagian terakhir dari *Lapisan 3: Compositor & Window Manager*. Di sini kita membahas **tahap penyusunan tampilan akhir** pada layar fisik: bagaimana setiap *surface* yang telah dikelola, diatur prioritasnya, diberi efek, dan akhirnya dikirim ke *output device* (monitor, projector, VR headset, dsb).

---

151. **Scene Composition** – tahap penggabungan seluruh *surface* menjadi satu *frame buffer* akhir sebelum dikirim ke GPU.
152. **Scenegraph Renderer** – struktur pohon data yang mewakili semua elemen visual aktif di layar (seperti jendela, panel, kursor).
153. **Node Hierarchy** – tiap *window*, *view*, dan *output* direpresentasikan sebagai node dalam pohon komposisi.
154. **Transform Matrix** – matriks transformasi 2D/3D untuk rotasi, translasi, dan skala *surface*.
155. **View Projection** – menentukan bagaimana konten jendela diterjemahkan ke koordinat layar fisik.
156. **Render Pass** – satu siklus komposisi penuh dari seluruh *scenegraph*.
157. **Z-order Sorting** – pengurutan *surface* berdasarkan urutan tampil di atas atau di bawah.
158. **Damage Tracking** – hanya bagian layar yang berubah yang dirender ulang untuk efisiensi.
159. **Repaint Region** – area aktual yang diperbarui dalam satu frame.
160. **Frame Callback** – sinyal dari compositor ke klien agar mengirim frame baru.
161. **Frame Scheduling** – pengaturan kapan *frame* dirender agar sinkron dengan *refresh rate*.
162. **VBlank Synchronization** – sinkronisasi rendering dengan jeda vertikal monitor untuk mencegah *tearing*.
163. **Frame Latency** – selisih waktu antara input pengguna hingga frame tampil di layar.
164. **Frame Queue** – antrean frame yang siap dikirim ke GPU.
165. **Double Buffering** – sistem dua buffer agar rendering dan display berjalan paralel tanpa kedipan.
166. **Triple Buffering** – menambah satu buffer ekstra untuk kelancaran lebih baik (dengan sedikit latensi tambahan).
167. **GPU Command Submission** – proses mengirim perintah render ke GPU driver.
168. **Renderer Backend** – subsistem yang menangani API grafis (misal: OpenGL, Vulkan, Pixman, GLES2).
169. **Software Renderer** – alternatif berbasis CPU bila GPU tidak tersedia.
170. **Hardware Acceleration** – memanfaatkan GPU untuk mempercepat komposisi.
171. **OpenGL Renderer** – backend yang menggunakan OpenGL ES 2.0 untuk rendering Sway/wlroots.
172. **Vulkan Renderer** – backend eksperimental dengan manajemen memori dan sinkronisasi lebih modern.
173. **Pixman Renderer** – implementasi CPU rendering murni, biasanya untuk output dummy atau headless.
174. **Render Pipeline** – urutan proses dari *scenegraph traversal* hingga pengiriman *frame buffer*.
175. **Shader Program** – program GPU kecil untuk mengontrol warna, cahaya, dan efek visual.
176. **Compositor Loop** – siklus utama compositor yang menangani input-event-output terus menerus.
177. **Repaint Loop** – bagian dari compositor loop yang memicu *damage detection* dan render ulang.
178. **Idle Frame Detection** – compositor menunggu perubahan sebelum merender ulang (hemat daya).
179. **Gamma Control** – penyesuaian *color curve* untuk tingkat kecerahan monitor.
180. **Color Management** – menjaga akurasi warna antara aplikasi dan tampilan (ICC profile, HDR).
181. **High Dynamic Range (HDR)** – dukungan *color depth* tinggi dan luminansi luas untuk monitor modern.
182. **Color Space Conversion** – transformasi antar ruang warna seperti sRGB, P3, atau Rec.2020.
183. **Output Management** – mengatur tampilan fisik, resolusi, refresh rate, orientasi, posisi antar-monitor.
184. **Output Head** – representasi logis dari satu perangkat tampilan (monitor fisik).
185. **Output Mode** – kombinasi resolusi dan refresh rate tertentu yang disediakan monitor.
186. **Output Transform** – rotasi dan flipping pada output untuk perangkat vertikal atau terbalik.
187. **Output Scaling** – faktor skala untuk DPI tinggi (HiDPI / Retina).
188. **Output Layout** – tata letak seluruh monitor pada koordinat global.
189. **Output Mirror** – menampilkan frame yang sama di beberapa output.
190. **Output Enable/Disable** – mengaktifkan atau menonaktifkan monitor secara dinamis.
191. **Hotplug Detection** – pendeteksian otomatis saat monitor dicolok atau dicabut.
192. **Output Reconfiguration** – pembaruan layout atau mode secara dinamis tanpa restart compositor.
193. **Direct Scanout** – pengiriman buffer klien langsung ke layar tanpa komposisi (efisiensi maksimal).
194. **Presentation Feedback** – mekanisme pelaporan waktu frame ke klien.
195. **Output Damage Tracking** – sama seperti *surface damage*, tapi pada tingkat output global.
196. **Adaptive Sync (VRR)** – menyesuaikan refresh rate dinamis untuk mengurangi *stutter*.
197. **Tearing Prevention** – memastikan frame tidak pecah akibat *unsynchronized swap*.
198. **Screen Capture Hook** – antarmuka untuk screenshot, streaming, atau mirror.
199. **Frame Presentation Time** – waktu aktual frame ditampilkan, digunakan untuk statistik dan sinkronisasi.
200. **Output Frame Lifecycle** – seluruh siklus hidup frame dari komposisi, rendering, presentasi, hingga *acknowledgement* ke klien.

---

Dengan demikian, **Lapisan 3 (Compositor & Window Manager)** telah lengkap dari kode 101–200.
Lapisan ini adalah inti “mesin visual” Sway: ia mengatur bagaimana *window* berwujud, disusun, dan akhirnya diterjemahkan menjadi cahaya di monitor.

Langkah berikutnya adalah **Lapisan 4: Input System & Event Routing**, di mana kita akan membahas perangkat input (keyboard, pointer, touch, tablet, gesture) dan bagaimana Sway memetakan semuanya melalui libinput dan Wayland protocol seperti `wl_seat`.
<!-----------------
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
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

----------------------------------->

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
