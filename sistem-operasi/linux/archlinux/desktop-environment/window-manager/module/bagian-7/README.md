
# **Lapisan 7 — Utilities, Extensions & Theming (100 istilah)**

Lapisan teratas dari ekosistem Desktop Environment (DE). Lapisan ini menjadi ruang kustomisasi, ekspansi, dan keindahan — tempat pengguna berinteraksi dengan *tools*, *theme engine*, dan *plugin system* yang memperhalus pengalaman desktop.

---

## **Lapisan 7 — Utilities, Extensions & Theming (100 Istilah)**

### **7.1 Configurator & Control Utilities (20 istilah)**

1. **Configurator** – Antarmuka untuk mengubah pengaturan sistem atau DE.
2. **Control Center** – Aplikasi pusat kendali pengaturan desktop (contoh: GNOME Control Center).
3. **Settings Daemon** – Proses yang memantau dan menerapkan pengaturan sistem secara dinamis.
4. **dconf Editor** – Editor database konfigurasi GNOME berbasis dconf.
5. **gsettings** – CLI untuk mengelola pengaturan berbasis dconf.
6. **kwriteconfig5** – Alat konfigurasi KDE berbasis KConfig.
7. **lxappearance** – Pengubah tema GTK untuk lingkungan ringan seperti LXDE/LXQt.
8. **xfconf-query** – Utilitas konfigurasi XFCE melalui XFConf.
9. **mate-control-center** – Panel pengaturan utama MATE Desktop.
10. **gnome-tweaks** – Alat untuk mengubah opsi lanjutan GNOME Shell.
11. **kdeglobals** – Berkas konfigurasi global KDE.
12. **rc.xml / openboxrc** – Berkas konfigurasi untuk window manager Openbox.
13. **qt5ct** – Konfigurator tampilan aplikasi Qt5.
14. **Xresources** – Berkas konfigurasi tampilan aplikasi X11 berbasis Xlib.
15. **Xdefaults** – Versi lama dari Xresources.
16. **gconf-editor** – Editor konfigurasi GTK lama sebelum dconf.
17. **KCM (KDE Control Module)** – Modul individual dalam KDE System Settings.
18. **schema (dconf schema)** – Definisi struktur data untuk konfigurasi dconf.
19. **preferences daemon** – Komponen pengelola preferensi pengguna secara otomatis.
20. **hotkey manager** – Utilitas untuk mengatur pintasan keyboard desktop.

---

### **7.2 Plugin & Extension System (25 istilah)**

21. **Plugin System** – Mekanisme untuk memperluas fungsi DE.
22. **Extension API** – Antarmuka pemrograman bagi pengembang plugin eksternal.
23. **GNOME Shell Extension** – Ekstensi JavaScript untuk menambah fitur GNOME Shell.
24. **KDE Plasma Script Engine** – Sistem scripting KDE berbasis QML/JavaScript.
25. **Plasmoid** – Unit fungsional kecil dalam KDE Plasma (setara widget).
26. **Applet** – Komponen kecil pada panel desktop.
27. **Indicator Applet** – Sistem notifikasi mini di panel (Unity, MATE).
28. **Widget** – Komponen GUI interaktif dalam panel atau dashboard.
29. **Desklet** – Komponen dekoratif atau informatif di desktop.
30. **GNOME Extension Manager** – GUI untuk mengelola ekstensi GNOME.
31. **shell.js (GNOME)** – File utama ekstensi GNOME Shell.
32. **metadata.json (GNOME)** – Berkas identitas dan metadata ekstensi GNOME.
33. **QML Plugin** – Plugin berbasis QML untuk KDE Plasma.
34. **plugin loader** – Komponen yang memuat plugin saat runtime.
35. **API Hook** – Titik integrasi ekstensi terhadap sistem utama.
36. **Lua Plugin (awesomeWM)** – Plugin berbasis bahasa Lua pada tiling WM.
37. **E-module (Enlightenment)** – Modul ekstensi pada DE Enlightenment.
38. **Panel Plugin (XFCE)** – Ekstensi untuk panel XFCE.
39. **Compiz Plugin** – Modul efek grafis Compiz.
40. **plugin manifest** – File deskripsi plugin.
41. **plugin sandbox** – Lapisan keamanan isolasi plugin.
42. **plugin hot-reload** – Pemanggilan ulang plugin tanpa restart.
43. **plugin dependency resolver** – Sistem manajemen dependensi antar plugin.
44. **plugin registry** – Database berisi daftar plugin terdaftar.
45. **plugin inspector** – Alat untuk menganalisis status plugin.

---

### **7.3 Theme Engine (20 istilah)**

46. **Theme Engine** – Mesin yang menerapkan gaya visual ke elemen GUI.
47. **GTK Theme Engine** – Mesin tema untuk aplikasi GTK (Adwaita, Arc, dsb.).
48. **Qt Style Plugin** – Plugin gaya visual untuk aplikasi Qt.
49. **Metacity Theme** – Format tema jendela Metacity (GNOME Classic).
50. **Mutter Theme** – Tema dekorasi jendela Mutter.
51. **KWin Decoration** – Komponen tema dekorasi KDE Window Manager.
52. **CSD (Client Side Decoration)** – Pendekatan rendering bingkai jendela oleh aplikasi.
53. **SSD (Server Side Decoration)** – Rendering bingkai jendela oleh window manager.
54. **GTK CSS** – Bahasa gaya berbasis CSS untuk GTK3/4.
55. **Qt Style Sheet (QSS)** – Format CSS khusus Qt.
56. **Cairo Rendering** – Backend grafis tema berbasis vektor.
57. **SVG Theme Asset** – Komponen grafis berbasis SVG dalam tema.
58. **Adwaita** – Tema default GTK modern.
59. **Breeze** – Tema default KDE Plasma.
60. **Numix** – Tema populer berbasis flat design.
61. **Materia** – Tema GTK modern dengan gaya Material Design.
62. **Theme Selector** – Utilitas untuk memilih tema desktop.
63. **gtkrc** – Berkas konfigurasi tema GTK lama.
64. **theme inheritance** – Pewarisan atribut dari tema induk.
65. **theme reload** – Pemuat ulang tema dinamis.

---

### **7.4 Icon, Cursor & Sound Themes (20 istilah)**

66. **Icon Theme** – Kumpulan ikon aplikasi dan sistem.
67. **Cursor Theme** – Gaya visual untuk kursor mouse.
68. **Sound Theme** – Koleksi suara untuk peristiwa sistem.
69. **freedesktop.org Icon Specification** – Standar tata letak tema ikon.
70. **index.theme** – Berkas metadata tema ikon/suara.
71. **Symbolic Icon** – Ikon monokrom adaptif warna.
72. **Scalable Icon** – Ikon berbasis SVG yang dapat diperbesar tanpa kehilangan kualitas.
73. **hicolor theme** – Tema ikon fallback standar sistem.
74. **Papirus** – Tema ikon populer berbasis flat design.
75. **Yaru** – Tema ikon Ubuntu default.
76. **Breeze Icon Set** – Koleksi ikon KDE Plasma.
77. **GNOME Symbolic Icons** – Ikon resmi GNOME untuk integrasi visual.
78. **cursor hotspot** – Titik aktif pada gambar kursor.
79. **animated cursor** – Kursor dengan frame animasi.
80. **XCursor format** – Format file tema kursor X11.
81. **cursor theme index** – Daftar urutan tema kursor aktif.
82. **sound event** – Peristiwa sistem yang memicu efek suara.
83. **libcanberra** – Pustaka pemutaran suara tema standar.
84. **PulseAudio sound theme** – Integrasi tema suara dalam PulseAudio.
85. **theme directory hierarchy** – Struktur folder tema mengikuti spesifikasi freedesktop.

---

### **7.5 Utilities & User Experience Enhancers (15 istilah)**

86. **Notification Daemon** – Proses yang menampilkan notifikasi desktop.
87. **On-screen Display (OSD)** – Tampilan sementara seperti volume/brightness.
88. **OSD Renderer** – Komponen yang menggambar OSD di layar.
89. **desktop OSD shell** – Implementasi OSD berbasis compositor.
90. **theme-aware OSD** – OSD yang mengikuti gaya tema aktif.
91. **Compositor Utility** – Alat untuk menguji atau menyesuaikan efek compositor.
92. **Wallpaper Daemon** – Proses pengatur gambar latar.
93. **Theme Cache** – Penyimpanan hasil kompilasi tema agar cepat dimuat.
94. **Icon Cache** – Penyimpanan indeks ikon.
95. **Theme Previewer** – Aplikasi untuk meninjau tema sebelum diterapkan.
96. **Screenshot Utility** – Alat tangkapan layar.
97. **Color Scheme Manager** – Pengelola skema warna sistem.
98. **Transparency Controller** – Pengatur tingkat transparansi jendela.
99. **Dynamic Accent Color** – Sistem perubahan warna dinamis berdasarkan wallpaper.
100. **Customization Layer** – Lapisan integrasi untuk tema, plugin, dan konfigurasi pengguna.

---

<!--
Dengan ini seluruh **7 lapisan Desktop Environment Architecture** telah tuntas, total **1.200 istilah teknis** yang mencakup seluruh subsistem dari kernel grafis hingga sistem tema dan ekstensi pengguna.

Apakah kamu ingin saya lanjutkan dengan menyusun **diagram arsitektur keseluruhan** agar setiap lapisan terlihat jelas posisinya dalam hubungan fungsionalnya?
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
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
