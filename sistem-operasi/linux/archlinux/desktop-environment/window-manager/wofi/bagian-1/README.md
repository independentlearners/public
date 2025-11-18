<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#-->

# Modul 1 — Dasar kuat (Fase 0 + Fase 1): Wayland & Wofi — Instalasi, Pemanggilan, dan Integrasi awal ke Sway

Di bawah ini materi **lengkap** untuk Fase 0 (konsep Wayland/wlroots) dan Fase 1 (instalasi & mode operasi wofi). Semua perintah akan dijelaskan **kata-per-kata**, termasuk variabel lingkungan, lokasi file, dan langkah debugging awal. Di akhir ada checklist latihan dan tugas singkat untuk Anda praktikkan.

> Sumber utama yang digunakan: repo/README wofi, manual page wofi, paket distro (Arch/Debian), dan panduan integrasi Sway. ([GitHub][1])

---

# Bagian A — Konsep inti: Wayland, wlroots, compositor, dan peran Wofi

1. **Wayland vs X11 (singkat)**

   * Wayland adalah protokol modern untuk menampilkan grafik dan input; **compositor** (mis. sway) bertugas menjadi server grafis sekaligus window manager. X11 menggunakan server X; Wayland tidak.
   * Implikasi praktis: banyak aplikasi tradisional (X11) berperilaku berbeda under Wayland (clipboard, focus, input grabs). Jika wofi tidak muncul atau input tidak diterima, penyebab sering berkaitan dengan environment Wayland (socket/display) atau cara compositor menangani grab. ([ArchWiki][2])

2. **wlroots**

   * wlroots adalah library/kerangka kerja untuk membangun compositor Wayland (sway, hyprland, dsome). Wofi didesain untuk compositor berbasis wlroots sehingga integrasinya optimal dengan sway.

3. **Peran Wofi**

   * Wofi adalah *application launcher / menu* untuk compositor berbasis wlroots. Mode utamanya: `drun` (desktop entries), `run` (eksekusi baris perintah), dan `dmenu`/stdin (baca daftar lewat stdin). Wofi sangat dapat ditema menggunakan CSS (style.css). ([Debian Packages][3])

---

# Bagian B — Identitas teknis Wofi & apa yang perlu Anda siapkan untuk memodifikasi/bangun

* **Bahasa implementasi:** Wofi ditulis mayoritas dalam **C** dan menggunakan **GTK3** (GObject/GLib) untuk UI. Untuk membangun/modifikasi Anda perlu pengetahuan dasar C dan pemahaman GTK (widget, CSS theming di GTK). ([GitHub][1])
* **Tooling & dependensi dev (wajib/umum):**

  * `meson` + `ninja` atau `cmake` (build system) — untuk men-configure dan membangun.
  * `pkg-config` (mendeteksi library), `libgtk-3-dev` / `gtk3-devel`, `libwayland-dev`, `glib2.0-dev` (header).
  * Compiler: `gcc` atau `clang`.
  * Optional: `desktop-file-utils` (untuk validasi `.desktop`), `update-desktop-database`. ([GitHub][4])
* **Apa yang harus dikuasai untuk memodifikasi:**

  * C dasar + memory basics (malloc/free), build system (meson/cmake), cara kerja GTK CSS, struktur repo wofi, dan proses debugging (gdb/logging).
  * Untuk membuat theme atau skrip integrasi: bash/sh, pemahaman `.desktop` (XDG) dan env vars XDG.

---

# Bagian C — Instalasi: paket distro & penjelasan kata-per-kata per perintah

## 1) Instalasi di Arch (cara singkat)

Perintah contoh:

```
sudo pacman -Syu wofi
```

Penjelasan kata-per-kata:

* `sudo` — jalankan perintah sebagai superuser (root).
* `pacman` — package manager Arch.
* `-Syu` — tiga opsi digabung:

  * `-S` = sinkronisasi/pasang paket,
  * `-y` = refresh database paket dari remote,
  * `-u` = upgrade paket yang terpasang.
* `wofi` — nama paket yang akan dipasang.
  Keterangan: Paket `wofi` tersedia di repositori Arch (extra). ([Arch Linux][5])

## 2) Instalasi di Debian/Ubuntu

Contoh:

```
sudo apt update
sudo apt install wofi
```

Penjelasan:

* `sudo` — jalankan perintah sebagai root.
* `apt update` — perbarui indeks paket lokal (ambil daftar versi terbaru dari repositori).
* `apt install wofi` — instal paket `wofi` dari repositori yang terkonfigurasi.
  Catatan: pada beberapa distro paket mungkin tersedia di versi terbaru (sid/bookworm). Periksa `packages.debian.org/wofi`. ([Debian Packages][3])

## 3) Build from source (ketika ingin modifikasi)

Contoh ringkas (menggunakan mercurial upstream pada sr.ht):

```
hg clone https://hg.sr.ht/~scoopta/wofi
cd wofi
meson setup build
ninja -C build
sudo ninja -C build install
```

Penjelasan:

* `hg clone URL` — `hg` (Mercurial) clone: unduh salinan kode sumber dari URL. (Upstream wofi di sr.ht menggunakan hg).
* `cd wofi` — change directory ke folder `wofi` hasil clone.
* `meson setup build` — buat direktori build bernama `build` dan konfigurasikan proyek (meson membaca `meson.build`).
* `ninja -C build` — jalankan `ninja` di direktori `build` untuk membangun binari.
* `sudo ninja -C build install` — pasang hasil build ke sistem (biasanya `/usr/local`) sebagai root.
  Catatan: beberapa fork/mirror menggunakan git; beberapa distribusi menyediakan PKGBUILD/AUR untuk mem-build. Pastikan terpasang `libgtk-3-dev`, `libwayland-dev`, `pkg-config` sebelum build. ([GitHub][4])

---

# Bagian D — Menjalankan Wofi & opsi mode (uji dari terminal)

## 1) Menjalankan dasar

Dari terminal (dalam sesi sway/Wayland), jalankan:

```
wofi
```

Jika wofi tidak muncul, jalankan untuk debugging:

```
wofi --show drun 2> /tmp/wofi.log
```

Penjelasan:

* `wofi` — jalankan aplikasi wofi.
* `--show drun` — opsi jalankan wofi dalam mode `drun` (tampilkan desktop entries).
* `2> /tmp/wofi.log` — redirect `stderr` (stream 2) ke file `/tmp/wofi.log` sehingga error/debug dapat diperiksa.
  Catatan: log dapat memuat pesan terkait protocol error atau masalah GTK/Wayland; ini langkah pertama debugging. ([Man Arch Linux][6])

## 2) Mode penting

* `drun` — tampilkan aplikasi dari `.desktop` (XDG desktop entries).
* `run` — mode untuk mengetik perintah dan menjalankannya (mencari di `$PATH`).
* `dmenu` / stdin — baca baris dari stdin sehingga skrip bisa menghasilkan daftar pilihan (bisa dipipe).
  Contoh piped menu (power menu sederhana):

```bash
printf "Suspend\nReboot\nShutdown" | wofi --dmenu
```

Penjelasan:

* `printf "..."` — cetak tiga baris ke stdout.
* `|` — pipe: kirim stdout dari `printf` ke stdin program berikutnya.
* `wofi --dmenu` — jalankan wofi dalam mode dmenu membaca stdin.

---

# Bagian E — Integrasi ke Sway: contoh keybind dan penjelasan kata-per-kata

Tambahkan ke `~/.config/sway/config` (contoh baris):

```
set $mod Mod4
bindsym $mod+d exec wofi --show drun
```

Penjelasan tiap bagian:

* `set $mod Mod4` — definisikan variabel `$mod` sama dengan key `Mod4` (biasanya tombol Super / Windows).
* `bindsym` — instruksi Sway untuk mengikat sebuah key combination.
* `$mod+d` — kombinasi tombol: tekan `$mod` dan `d`.
* `exec` — jalankan perintah berikutnya (sebagai proses background dikelola sway).
* `wofi --show drun` — perintah yang dijalankan; `--show drun` memaksa mode drun.
  Catatan tambahan: jika ingin memastikan path config tertentu, gunakan:

```
bindsym $mod+d exec /usr/bin/wofi --show drun -C ~/.config/wofi/config
```

Penjelasan: `-C` (atau `--config`) memberi path config (opsi ini ada/akan dijelaskan lengkap di modul config). Pastikan path absolute untuk menghindari masalah PATH saat sway dijalankan dari systemd atau login manager.

Sway reload config:

```
swaymsg reload
```

* `swaymsg` — util untuk mengirim pesan/command ke sway.
* `reload` — instruksi untuk reload file konfigurasi tanpa restart sesi.

Sumber: panduan Sway dan contoh konfigurasi. ([ArchWiki][2])

---

# Bagian F — Lokasi konfigurasi, style, dan prioritas opsi

* **Lokasi config wofi (default):** `$XDG_CONFIG_HOME/wofi/config` (biasanya `~/.config/wofi/config`). Jika tidak ada, wofi pakai nilai default internal. (Man page wofi menjelaskan format config snake_case dan bahwa mayoritas opsi juga tersedia sebagai argumen CLI). ([Man Arch Linux][7])
* **Style (CSS):** `~/.config/wofi/style.css` (atau file CSS yang Anda tentukan). Wofi memakai styling GTK/CSS untuk render; banyak tema tersedia di repo tema wofi. ([DEV Community][8])
* **Prioritas:** Argumen CLI > config file > default internal.

---

# Bagian G — Debugging awal (cek cepat bila tidak muncul)

1. Pastikan Anda menjalankan dalam sesi Wayland:

   ```
   echo $WAYLAND_DISPLAY
   ```

   * Jika kosong, berarti mungkin bukan sesi Wayland. Pada sway normal variabel ini ada (mis. `wayland-0`).

2. Jalankan wofi dari terminal dan simpan error:

   ```
   wofi --show drun 2> /tmp/wofi.err
   tail -n +1 /tmp/wofi.err
   ```

   * Periksa pesan `Protocol error`, `missing symbol`, atau `Gtk-WARNING`.

3. Periksa apakah GTK/Wayland dev headers terpasang (jika build dari source). Contoh paket: `libgtk-3-dev`, `libwayland-dev`, `pkg-config`.

4. Jika icon atau aplikasi `.desktop` tidak muncul:

   * Pastikan `.desktop` berada di `~/.local/share/applications` atau `/usr/share/applications`.
   * Jalankan `update-desktop-database` jika menambah manual file baru. ([Garuda Linux Forum][9])

5. Jika konfigurasi CSS tidak berefek:

   * Periksa path `~/.config/wofi/style.css`, permission file, dan syntax CSS (kurung/selector). Forum/discussion menunjukkan kadang style file tidak terbaca jika path salah atau cache. ([lists.fedoraproject.org][10])

6. Jika wofi crash pada versi tertentu (contoh kasus nyata): beberapa rilis berubah setting (`lines` broken — gunakan `height` sebagai pengganti). Periksa changelog dan bugtracker bagi rilis yang bermasalah. ([bbs.archlinux.org][11])

---

# Bagian H — Latihan praktis (tugas singkat untuk Modul 1)

1. **Instal & jalankan**

   * Di Arch: `sudo pacman -Syu wofi` lalu jalankan `wofi --show drun` dari terminal. Simpan error ke `/tmp/wofi.err` dan paste hasilnya bila ada masalah. ([Arch Linux][5])

2. **Integrasi Sway**

   * Tambahkan ke `~/.config/sway/config`:

     ```
     set $mod Mod4
     bindsym $mod+d exec wofi --show drun
     ```

     lalu `swaymsg reload`. Coba tekan `$mod+d`.

3. **Buat power menu piped**

   * Jalankan:

     ```bash
     printf "Lock\nSuspend\nReboot\nShutdown" | wofi --dmenu
     ```
   * Pilih opsi, dan cek bagaimana Anda bisa menangani hasil pilihan (nanti di modul scripting kita bedah).

4. **Cek env & log**

   * `echo $WAYLAND_DISPLAY`
   * `cat /tmp/wofi.err` (jika ada)

---

# Bagian I — Checklist penguasaan Modul 1 (indikator Anda siap lanjut Modul 2)

* [ ] Menjelaskan perbedaan X11/Wayland dan mengapa wofi dibuat untuk wlroots.
* [ ] Menginstal wofi di distro (Arch/Debian) dan menjalankannya dari terminal.
* [ ] Menambahkan binding wofi di `~/.config/sway/config` dan reload sway.
* [ ] Menjalankan wofi dalam `drun`, `run`, dan `dmenu` mode (piped) dan memahami perbedaan.
* [ ] Mengumpulkan log `stderr` ketika wofi error dan mengidentifikasi apakah masalah berkaitan dengan GTK/Wayland atau .desktop entries.

---

# Referensi utama (baca lanjutan)

* Wofi — repo/README (implementasi & dependensi). ([GitHub][1])
* Manual page wofi (man) — format config & opsi. ([Man Arch Linux][7])
* Paket Arch: detail paket `wofi` (dependensi dan repo). ([Arch Linux][5])
* Panduan build (contoh meson/ninja) & dependensi dev. ([GitHub][4])
* Panduan Sway (ArchWiki) — konfigurasi bindsym, reload, environment. ([ArchWiki][2])

---
<!--
Kalau Anda setuju dengan hasil Modul 1 ini, saya akan lanjut **Modul 2**: *Konfigurasi Wofi (file config + semua opsi CLI) — lengkap dengan penjelasan kata-per-kata pada setiap opsi, contoh `style.css` dan contoh file `~/.config/wofi/config`*, termasuk latihan mengubah tampilan dan debugging CSS.

Konfirmasi “lanjut Modul 2” dan saya keluarkan modul berikutnya lengkap dengan contoh file, snippet config, dan latihan debugging yang sangat rinci (keterangan per baris).
> - **[Home][domain]**
[domain]: ../../../../README.md
-->
[1]: https://github.com/SimplyCEO/wofi?utm_source=chatgpt.com "SimplyCEO/wofi"
[2]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[3]: https://packages.debian.org/sid/wofi?utm_source=chatgpt.com "Details of package wofi in sid"
[4]: https://github.com/fuzzybritches0/wofi?utm_source=chatgpt.com "fuzzybritches0/wofi"
[5]: https://archlinux.org/packages/extra/x86_64/wofi/?utm_source=chatgpt.com "wofi 1.5.1-1 (x86_64)"
[6]: https://man.archlinux.org/man/wofi.1.en?utm_source=chatgpt.com "wofi(1) - Arch manual pages"
[7]: https://man.archlinux.org/man/wofi.5.en?utm_source=chatgpt.com "wofi(5) - Arch manual pages"
[8]: https://dev.to/juniordevforlife/how-i-set-up-wifi-in-debian-11-14ka?utm_source=chatgpt.com "How I Set Up Wifi In Debian 11"
[9]: https://forum.garudalinux.org/t/adding-an-application-to-wofi/17048?utm_source=chatgpt.com "Adding an application to Wofi - Sway"
[10]: https://lists.fedoraproject.org/archives/list/sway%40lists.fedoraproject.org/thread/T2ECWRN7WFQZG6IA5QQLF7GG55QAZQS6/?utm_source=chatgpt.com "User Friendly Wofi Documentation - Sway"
[11]: https://bbs.archlinux.org/viewtopic.php?id=307150&utm_source=chatgpt.com "wofi crashing since 1.5 update / Applications & Desktop ..."

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**

[kurikulum]: ../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

