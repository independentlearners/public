
# **[Kelas Lengkap Wofi untuk Sway (dari Dasar → Lanjutan → Troubleshooting)][0]**

---

## Ringkasan singkat tentang Wofi (fakta penting)

Wofi adalah launcher/menu untuk compositor Wayland berbasis wlroots (mis. sway). Wofi menggunakan GTK/GLib dan dibangun dengan tool seperti Meson/CMake; dependensinya termasuk GTK3, GLib, GObject dan pkg-config — artinya modifikasi mendalam biasanya butuh pengetahuan C + ekosistem GTK. ([GitHub][1])

---

## Target audiens

* Pengguna Sway / wlroots yang ingin launcher kustom dan integrasi penuh.
* Pengembang/pengonfigurasi yang ingin memodifikasi tema/style atau membangun dari sumber.
* Level: dari pemula Wayland → lanjutan (build dari sumber + debugging Wayland).

---

## Prasyarat teknis sebelum kursus

Minimal:

* Pemahaman dasar Sway / Wayland (konsep compositor, workspace, input).
* Shell scripting (bash/sh).
* CLI Linux dasar (paket manager, file paths).
  Disarankan untuk pengembangan/kontribusi:
* Bahasa C dasar + GTK3/GLib dasar.
* Tooling: meson / ninja atau cmake, gcc/clang, pkg-config, libgtk-3-dev, libwayland-dev.
  (Saya akan sertakan daftar paket OS-spesifik dan cara menginstal nanti). ([GitHub][1])

---

## Struktur kursus (fase & modul) — ringkasan cepat

1. **Fase 0 — Pengenalan & Konsep Wayland/Wlroots**
2. **Fase 1 — Instalasi & Mode Operasi Wofi**
3. **Fase 2 — Integrasi Wofi ke Konfigurasi Sway (keybinds & autostart)**
4. **Fase 3 — Konfigurasi Dasar Wofi (config file & argumen CLI)**
5. **Fase 4 — Theming & Styling (CSS, icon, fonts, layout)**
6. **Fase 5 — Skema Menu: drun, run, custom lists, stdin**
7. **Fase 6 — Automasi & Scripted Menus (power menus, launcher wrappers)**
8. **Fase 7 — Build from Source & Contributing (Meson/CMake, patching)**
9. **Fase 8 — Debugging & Troubleshooting Mendalam**
10. **Fase 9 — Packaging / Distribusi / Integrasi (AUR, Nix, Debian package)**
11. **Fase 10 — Proyek Akhir & Penilaian**

Di bawah ini: uraian tiap fase + submodul, tujuan pembelajaran, latihan, dan indikator penguasaan.

---

# Detil per Fase (kurikulum lengkap)

## [Fase 0 — Pengenalan & Konsep Wayland / wlroots][a]

Tujuan: Memastikan semua peserta paham ekosistem sehingga pengaturan Wofi tidak “ngambang”.

* Materi:

  * Perbedaan X11 vs Wayland (socket, env vars).
  * Apa itu wlroots dan bagaimana sway menggunakan wlroots.
  * Bagaimana aplikasi Wayland berinteraksi dengan compositor (xdg-shell, xdg-desktop-portal secara singkat).
* Latihan:

  * Mengecek apakah sesi sedang Wayland (`echo $WAYLAND_DISPLAY`) dan memeriksa socket.
* Hasil yang diharapkan:

  * Peserta bisa menjelaskan mengapa beberapa masalah wofi muncul karena Wayland/seat/socket.

## Fase 1 — Instalasi & Mode Operasi Wofi

Tujuan: Meng-install dan menjalankan wofi; memahami mode operasi dasar.

* Submodul:

  * Instalasi paket (Arch, Debian/Ubuntu, Nix, build from source).
  * Menjalankan `wofi` dari terminal; mode umum (launcher/menu).
  * Perbedaan antara `drun` (desktop entries), `run` (command entry), dan piping stdin.
* Latihan:

  * Install via paket distro; jalankan wofi; buka aplikasi dari wofi.
* Sumber & catatan teknis: README repo wofi (dependensi: GTK3, GLib, GObject, meson/cmake). ([GitHub][1])

## Fase 2 — Integrasi Wofi ke Konfigurasi Sway (keybinds & autostart)

Tujuan: Menempatkan wofi di workflow Sway (keybinds, style, behavior).

* Submodul:

  * Menambahkan keybind di `~/.config/sway/config` (contoh: binding ke `$mod+d`), dengan penjelasan setiap argumen.
  * Launching wofi trayless vs persistent; menangani focus/keyboard grabbing di Wayland.
  * Autostart vs socket activation.
* Latihan:

  * Tambah keybind, reload sway, cek behavior.
* Output:

  * Peserta bisa menulis konfigurasi sway yang konsisten dan menjelaskan apa yang dilakukan setiap baris.

## Fase 3 — Konfigurasi Dasar Wofi (file config & opsi CLI)

Tujuan: Pahami `~/.config/wofi/config` (atau lokasi config) dan flag CLI.

* Submodul:

  * Struktur file config (opsi umum: mode, show-icons, placement, width/height).
  * Menjalankan wofi dengan opsi CLI (debug flags, verbose).
  * Lokasi fallback config, prioritas argumen CLI vs config file.
* Latihan:

  * Buat config minimal; jalankan wofi dengan `--show` atau flag contoh (nanti akan jelaskan per-flag kata per-kata).
* Catatan:

  * Kita akan menyertakan daftar flag resmi dan arti tiap- tiap argumen dengan contoh.

## Fase 4 — Theming & Styling (CSS, icon, fonts, layout)

Tujuan: Menjadikan wofi tampil visual sesuai preferensi (CSS GTK).

* Submodul:

  * `style.css` untuk wofi: selector, property, ukuran, padding, border, font-family.
  * Mengatur icon theme (where .desktop icons come from: ~/.local/share/applications & /usr/share/applications). ([bbs.archlinux.org][2])
  * Menggabungkan theme dengan global GTK theme; font fallback/pango.
* Latihan:

  * Terapkan contoh theme (menggunakan koleksi tema) dan jelaskan tiap rule CSS. ([GitHub][3])

## Fase 5 — Skema Menu: drun, run, custom lists, stdin

Tujuan: Mengontrol apa yang dimunculkan wofi dan bagaimana input disediakan.

* Submodul:

  * `drun` mode: bagaimana wofi mengambil `.desktop` (desktop database). ([bbs.archlinux.org][2])
  * `run` mode: menjalankan perintah bebas.
  * Menyediakan daftar custom lewat stdin (pipe), dan integrasi dengan script (contoh: menu shutdown).
* Latihan:

  * Buat script power menu yang menulis daftar ke stdout lalu dipipe ke wofi; verifikasi behavior.

## Fase 6 — Automasi & Scripted Menus (power menus, workflows)

Tujuan: Bangun tools tambahan (power menu, window switcher, custom launcher).

* Submodul:

  * Contoh proyek: `wofi-power-menu` (arsitektur), cara memanggil wofi dari skrip, opsi konfirmasi. ([GitHub][4])
  * Integrasi dengan systemctl, swaymsg, hyprctl (jika diperlukan).
* Latihan:

  * Implementasi power menu sederhana + binding di sway.

## Fase 7 — Build from Source & Contributing

Tujuan: Peserta mampu membangun, memodifikasi, dan membuat patch.

* Submodul:

  * Environment dev: install libgtk-3-dev, meson, ninja, pkg-config, gcc/clang. ([GitHub][1])
  * Struktur kode wofi: file utama, rendering (Pango/GTK), thema CSS handling.
  * Men-debug build error; workflow patch & PR (hg / git forks).
* Latihan:

  * Clone repo resmi, build, lakukan perubahan kecil (mis. default width), commit & test.

## Fase 8 — Debugging & Troubleshooting Mendalam (kunci kursus)

Tujuan: Peserta mengerti cara mendiagnosa dan memperbaiki error umum.

* Submodul (setiap item = topik mendalam + checklist debug):

  * Wofi tidak muncul / crash ketika dipanggil dari sway (periksa env, stderr logs, wayland socket).
  * Icon tidak muncul (periksa XDG_DATA_DIRS, desktop file locations). ([bbs.archlinux.org][2])
  * CSS style tidak terpakai (cache, file path ~/.config/wofi/style.css, syntax error).
  * Build failures (missing dev headers: libgtk-3-dev, glib2.0-dev). ([GitHub][1])
  * Performa / lag / focus stealing di Wayland (investigasi seat/input grab).
* Praktik:

  * Skenario troubleshooting lab (error injection + langkah perbaikan).
* Outcome:

  * Peserta dapat menulis laporan debugging singkat (what, why, fix).

## Fase 9 — Packaging / Distribusi / Integrasi

Tujuan: Pelajari cara membungkus perubahan jadi paket untuk distro (AUR, DEB, Nix).

* Submodul:

  * Contoh PKGBUILD (AUR) dan tips penandaan versi.
  * Membuat flake / package Nix, atau .deb sederhana.
* Latihan:

  * Buat paket distribusi kecil untuk hasil modifikasi tema atau patch.

## Fase 10 — Proyek Akhir & Penilaian

* Pilihan proyek (pilih 1): kustom launcher multi-menu (power + apps + scripts), kontribusi patch ke repo wofi, atau paket AUR + dokumentasi.
* Kriteria penilaian: fungsionalitas, dokumentasi, kemampuan debugging, clean build, styling lengkap.
* Rubrik: teori (25%), praktek (50%), debugging & docs (25%).

---

# Materi Tambahan & Sumber Referensi (awalan)

* Repo / README wofi (dependensi & build): ([GitHub][1])
* Tutorial & artikel pengguna: mephisto (pengantar penggunaan): ([mephisto.cc][5])
* Koleksi tema wofi (contoh style.css): ([GitHub][3])
* Perbandingan app launcher Wayland (untuk konteks dan alternatif): ([Mark Stosberg][6])
* Daftar paket Debian/Arch terkait wofi (packaging): ([packages.debian.org][7])

---

# Format pengajaran & deliverable per modul

* Teori ringkas (konsep inti).
* Contoh konfigurasi minimal (dijelaskan kata-per-kata untuk tiap baris ketika masuk isi materi).
* Latihan hands-on & file contoh (`~/.config/wofi/config`, `style.css`, contoh skrip power-menu).
* Checklist debugging untuk tiap topik.
* Kuis singkat & tugas coding.
* Diakhiri dengan PR/patch example untuk fase kontribusi.

---

# Estimasi pembagian waktu belajar (opsional)

Estimasi jam per fase supaya Anda punya gambaran; ini fleksibel dan bisa disesuaikan:

* Fase 0–2 (fundamental): 2–4 jam
* Fase 3–5 (konfig & thema): 4–8 jam
* Fase 6–8 (scripting, build, debug): 6–12 jam
* Fase 9–10 (packaging & proyek): 4–8 jam

<!--
(Bila Anda ingin saya ubah alokasi atau jadwal pembelajaran sesuai rutinitas Anda, saya sesuaikan.)
Kalau kurikulum ini sudah sesuai — **konfirmasi** saja, lalu saya mulai mengerjakan: saya akan mengembangkan **Modul 1 (Fase 0 + 1)** atau modul yang Anda pilih menjadi materi lengkap dengan contoh perintah, penjelasan kata-per-kata setiap argumen, file config contoh, dan latihan praktis.

Saya siap mulai kapan Anda bilang “lanjut” — beri tanda yang jelas (mis. “mulai modul 1”) agar saya langsung keluarkan materi lengkapnya.

-->
---

[0]: ../README.md
[1]: https://github.com/SimplyCEO/wofi?utm_source=chatgpt.com "SimplyCEO/wofi"
[2]: https://bbs.archlinux.org/viewtopic.php?id=296070&utm_source=chatgpt.com "[SOLVED] Wofi drun Where does it pull Applications from? ..."
[3]: https://github.com/joao-vitor-sr/wofi-themes-collection?utm_source=chatgpt.com "joao-vitor-sr/wofi-themes-collection"
[4]: https://github.com/szaffarano/wofi-power-menu?utm_source=chatgpt.com "szaffarano/wofi-power-menu"
[5]: https://mephisto.cc/en/tech/wofi/?utm_source=chatgpt.com "Wofi Tutorial - mephisto.cc"
[6]: https://mark.stosberg.com/rofi-alternatives-for-wayland/?utm_source=chatgpt.com "Rofi alternatives for Wayland: app launcher, window switcher ..."
[7]: https://packages.debian.org/wofi?utm_source=chatgpt.com "Debian -- Package Search Results -- wofi"

[a]: ../wofi/bagian-1/README.md
[b]: ../wofi/bagian-2/README.md
[c]: ../wofi/bagian-3/README.md
[d]: ../wofi/bagian-4/README.md
[e]: ../wofi/bagian-5/README.md
[f]: ../wofi/bagian-6/README.md
[g]: ../wofi/bagian-7/README.md
[h]: ../wofi/bagian-8/README.md
[i]: ../wofi/bagian-9/README.md
[j]: ../wofi/bagian-10/README.md
[k]: ../wofi/bagian-11//README.md
[l]: ../wofi/bagian-12/README.md
[m]: ../wofi/bagian-13/README.md
[n]: ../wofi/bagian-14/README.md
[o]: ../wofi/bagian-15/README.md
<!--
[p]: ../wofi/bagian-1/README.md
[q]: ../wofi/bagian-1/README.md
[r]: ../wofi/bagian-1/README.md-->
