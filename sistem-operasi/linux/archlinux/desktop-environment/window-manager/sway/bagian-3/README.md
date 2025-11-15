# Khusus Memodifikasi

### Catatan: bahasa, arsitektur, dan apa yang perlu Anda siapkan untuk memodifikasi Sway atau komponennya

1. Jika Anda ingin **memodifikasi** Sway: mulailah dengan mempelajari C dan konsep Wayland, lalu clone wlroots + sway, setup Meson/Ninja, dan jalankan build lokal. Ikuti issue/PR di GitHub untuk melihat pola kontribusi. ([GitHub][2])
2. Jika Anda ingin **mengembangkan plugin/fitur cepat**: gunakan `swaymsg`/IPC dan buat skrip (bash/Python/Lua/Rust) yang berinteraksi dengan Sway dan bisa terintegrasi dengan Neovim. ([GitHub][3])
3. Bila butuh panduan langkah-demi-langkah (mis. buat environment build di Archlinux, contoh modifikasi sederhana, atau template config i3→sway yang rapi), saya siapkan panduan terperinci beserta snippet konfigurasi dan perintah build.

---

**Identitas proyek & bahasa:**

* **Sway** adalah *Wayland compositor* yang sebagian besar ditulis dalam bahasa **C**.
* Sway banyak bergantung pada library **wlroots** (juga C) sebagai foundation untuk Wayland compositor.
* Komponen terkait (swaybar, swaylock, swaybg) juga umumnya C dan menggunakan API Wayland/libseat/libinput/dll.

**Untuk memodifikasi/compile Sway (ringkasan kebutuhan):**

* Pengetahuan: C (bahasa pemrograman), pemahaman tentang Wayland, libinput, libseat, dan konsep compositor.
* Alat build: `meson`, `ninja`, `pkg-config`, `clang` / `gcc`.
* Dependensi devel: `libwayland-dev`, `wlroots` (devel), `libinput-dev`, `libxkbcommon-dev`, `libseat-dev`, `pcre2-dev`, `xcb` devel (tergantung fitur), dsb. (Nama paket bervariasi per distro.)
* Pengujian: jalankan sway di TTY yang aman (bukan display grafis yang sedang berjalan) atau gunakan nested compositor/testing environment.

**Untuk memodifikasi konfigurasi (bukan kode C):**

* Bahasa konfigurasi: plain text — tidak perlu kompilasi.
* Keahlian yang berguna: memahami layout keyboard (xkb), keycodes, aturan Wayland, dan cara kerja `swaymsg`.
* Tools: editor teks (Neovim, helix), `swaymsg` untuk menguji perubahan tanpa harus restart penuh (`swaymsg reload` juga ada). Namun `swaymsg reload` memuat ulang config pada sesi yang sedang berjalan; hati-hati jika config bermasalah.

##  Pengembangan, modifikasi, dan prasyarat teknis

Jika Anda memiliki tujuan untuk **memodifikasi Sway** (menambah fitur di sumbernya) atau **membangun komponennya sendiri**, berikut ringkasan teknis dan langkah persiapan yang direkomendasikan.

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


<!--


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
