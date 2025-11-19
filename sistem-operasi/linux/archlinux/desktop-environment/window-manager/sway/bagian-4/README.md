# Kamus Resmi Konfigurasi Sway — Referensi & Contoh Konfigurasi

**Ringkasan singkat**
Dokumen ini adalah kamus dan panduan konfigurasi Sway (Wayland compositor yang kompatibel dengan i3) yang disusun sebagai referensi resmi gaya teknis: definisi perintah, contoh `config` yang dapat dijalankan, dan penjelasan kata-per-kata untuk setiap baris penting. Disiapkan agar bisa dipakai langsung di `~/.config/sway/config` dan dipecah modular melalui `include`.

---

## Identitas singkat (apa itu Sway dan teknologinya)

* **Nama:** Sway
* **Fungsi:** Wayland compositor tiling yang kompatibel dengan konfigurasi i3. Menggantikan X11/i3 pada lingkungan Wayland.
* **Bahasa kode sumber:** Ditulis **dalam bahasa C**. Banyak modul terkait (contoh: `wlroots`) juga ditulis dalam C. Beberapa tooling/perangkat tambahan (bar, launcher) ditulis dalam bahasa lain (C, Rust, JavaScript) tergantung proyek.
* **Pondasi teknis:** Menggunakan **Wayland** (protokol display modern) dan library `wlroots` sebagai lapisan dukungan hardware/driver.

### Persyaratan untuk mengembangkan / memodifikasi Sway

* Pengetahuan bahasa C (untuk kontribusi ke source). Penguasaan build system Meson/Ninja jika ingin membangun dari sumber.
* Pemahaman Wayland, konsep compositor, surface, seat, input events.
* Tools: `git`, `meson`, `ninja`, `pkg-config`, compiler C (gcc/clang), header dev packages (wayland, libwayland-dev, libxkbcommon-dev, wayland-protocols, libinput dev, libcap etc.).
* Untuk memodifikasi konfigurasi (bukan source): cukup editor teks (neovim/helix), dan pemahaman syntax konfigurasi Sway.

Referensi resmi: dokumentasi `swaywm.org` dan repo `sway`/`wlroots` di GitHub.

---

## Lokasi file konfigurasi

* Utama: `~/.config/sway/config`
* Bisa modular: `include ~/.config/sway/config.d/*` atau `include /path/to/fragment`

> Jika kamu menempatkan file ini, gunakan `~/.config/sway/config` sebagai entrypoint yang memanggil fragmen lain.

---

## Contoh konfigurasi fungsional (dapat dijalankan) — *minimal tapi lengkap*

Letakkan isi ini di `~/.config/sway/config` (atau sesuaikan path). File ini bersifat generik dan dirancang agar aman dipakai di banyak mesin; bagian `output` bersifat contoh — sesuaikan nama output (cek dengan `swaymsg -t get_outputs`).

```conf
# =========================
# Basic variables
# =========================
set $mod Mod4                # $mod -> tombol Super/Windows
set $term alacritty          # $term -> terminal default
set $editor nvim             # $editor -> editor default
set $browser firefox         # $browser -> peramban default

# =========================
# Include modular configs
# =========================
# include ~/.config/sway/config.d/*

# =========================
# Bindings: launchers
# =========================
bindsym $mod+Return exec $term
bindsym $mod+d exec wofi --show drun
bindsym $mod+Shift+q kill
bindsym $mod+Shift+c reload
bindsym $mod+Control+e exit

# =========================
# Workspace definitions
# =========================
set $ws1 "1:term"
set $ws2 "2:web"
set $ws3 "3:code"

bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3

# Assign aplikasi ke workspace
assign [app_id="firefox" ] $ws2
assign [class="Alacritty"] $ws1

# =========================
# Window rules
# =========================
for_window [title=".*Firefox.*"] floating enable
for_window [class="mpv"] floating enable

# =========================
# Outputs (contoh) — sesuaikan nama output
# =========================
output eDP-1 {
    enable yes
    resolution 1920x1080
    position 0,0
    scale 1
}

# =========================
# Input example
# =========================
input "type:keyboard" {
    xkb_layout us
}

# =========================
# Gaps & borders
# =========================
gaps inner 8
gaps outer 12
smart_gaps on
smart_borders on

# =========================
# Floating modifier
# =========================
floating_modifier $mod

# =========================
# Bar (sederhana)
# =========================
bar {
    position top
    status_command while true; do date; sleep 1; done
    font pango:DejaVu Sans Mono 10
}

# =========================
# Modes (contoh resize mode)
# =========================
mode "resize" {
    bindsym h resize shrink width 10px
    bindsym j resize grow height 10px
    bindsym k resize shrink height 10px
    bindsym l resize grow width 10px
    bindsym Return mode "default"
}

bindsym $mod+r mode "resize"

# =========================
# Startup commands
# =========================
exec_always --no-startup-id swayidle -w
exec_always --no-startup-id mako &
exec_always --no-startup-id swaybg -i ~/Pictures/wallpaper.jpg

# =========================
# Misc
# =========================
focus_follows_mouse no

```

---

## Penjelasan kata-per-kata (baris penting)

Di bawah ini aku uraikan token/token utama yang sering muncul di konfigurasi Sway, kata demi kata, dengan penjelasan singkat sintaks/argumen.

### `set $mod Mod4`

* `set` : perintah untuk mendefinisikan variabel konfigurasi.
* `$mod` : nama variabel yang dipilih; menggunakan tanda `$` saat dipakai.
* `Mod4` : nilai variabel — di XKB biasanya tombol Super/Windows.

Contoh penggunaan: `bindsym $mod+Return exec $term`

---

### `bindsym $mod+Return exec $term`

* `bindsym` : mendaftarkan sebuah binding (tombol) berdasarkan simbol kunci.
* `$mod+Return` : kombinasi tombol (dalam contoh, Super + Enter). Kata `Return` adalah simbol kunci (Enter).
* `exec` : menjalankan perintah ketika kombinasi ditekan.
* `$term` : variabel yang sebelumnya di-`set`, menunjuk executable terminal (misal `alacritty`).

Variasi dan flags:

* `bindsym --release` : trigger saat tombol dilepas.
* `bindsym --locked` : tetap berjalan meski screen terkunci.
* `bindsym --no-repeat` : mencegah pemicu berulang saat tombol ditahan.

---

### `exec` vs `exec_always`

* `exec <command>` : menjalankan `<command>` saat konfigurasi *pertama kali* diload (biasanya saat sway start).
* `exec_always <command>` : menjalankan setiap kali `reload` dipanggil.
* `--no-startup-id` : opsi yang sering dipakai untuk mencegah integrasi dengan systemd startup notification — tetap jalankan tetapi jangan daftar sebagai startup app.

Contoh: `exec_always --no-startup-id swayidle -w`

* `swayidle -w` : menunggu event idle dan menjalankan chaining actions.

---

### `workspace`, `assign`

* `workspace <name>` : berpindah atau membuat workspace dengan nama `<name>`.
* `assign <criteria> <workspace>` : setiap jendela yang memenuhi `criteria` otomatis dipindahkan ke workspace tujuan.
* `criteria` : ekspresi berbentuk `[class="Firefox"]`, `[app_id="org.mozilla.firefox"]`, `[title=".*Terminal.*"]`.

---

### `for_window [criteria] <action>`

* `for_window` : menerapkan aksi ketika jendela baru muncul dan memenuhi `criteria`.
* `criteria` : seperti di atas, memakai pola regex untuk `title`, `class`, `app_id`.
* `<action>` : `floating enable`, `move to workspace X`, `border pixel 1`, dsb.

Contoh: `for_window [class="mpv"] floating enable`

---

### `output <name> { ... }`

* `output` : blok konfigurasi terkait sebuah display/output (misal `eDP-1`, `DP-1`, `HDMI-A-1`). Nama ini dapat dilihat dengan `swaymsg -t get_outputs`.
* `enable yes/no` : menyalakan atau mematikan output.
* `resolution WxH` : set resolusi.
* `position X,Y` : posisi output relatif terhadap layar utama.
* `scale <float>` : skala (useful di HiDPI).

---

### `input "<selector>" { ... }`

* `input` : blok konfigurasi untuk perangkat input.
* `"type:keyboard"` atau `"<device name regex>"` : memilih perangkat berdasarkan tipe atau nama.
* `xkb_layout us` : set layout keyboard.

---

### `gaps inner|outer <number>`

* `gaps` : mengatur jarak antar-jendela (inner) dan jarak ke tepi layar (outer).
* `smart_gaps on/off` : otomatis matikan outer gaps ketika hanya satu jendela.

---

### `mode "name" { ... }`

* `mode` : mendefinisikan mode kunci (seperti `resize`) — binding di dalamnya hanya aktif dalam mode tersebut.
* `bindsym` di dalam mode mengikat fungsi sementara. `mode "default"` biasanya keluar dari mode khusus.

---

### `bar { ... }`

* `bar` : blok sederhana untuk membuat status bar internal (kadang digunakan sebagai placeholder).
* `position top|bottom` : posisi bar.
* `status_command <shell-command>` : command yang output-nya digunakan sebagai konten bar.
* `font pango:...` : font pango untuk teks bar.

*Catatan:* Banyak pengguna modern memakai `waybar` sebagai bar eksternal; untuk itu gunakan `exec_always waybar` dan jangan gunakan blok `bar {}`.

---

## Cara testing dan debugging konfigurasi

* **Cek nama outputs/input:** `swaymsg -t get_outputs` dan `swaymsg -t get_inputs`.
* **Reload config di Sway saat berjalan:** `swaymsg reload` atau tekan binding yang kamu set `reload`.
* **Jalankan Sway dengan config khusus (testing):** `sway -c ~/.config/sway/config_test` — ini memulai instance sway baru (biasanya di session Wayland baru) agar tidak mengganggu yang berjalan.
* **Debug:** jalankan `sway -d 2> ~/sway.log` untuk debug log.
* **Periksa error:** `journalctl -xe` (jika systemd) atau cek output log yang kamu redirect.

Penjelasan kata-per-kata singkat command testing:

* `swaymsg` : utilitas untuk mengirim pesan IPC ke sway.
* `-t get_outputs` : `-t` berarti type pesan, `get_outputs` adalah tipe request untuk daftar outputs.
* `sway -d` : jalankan sway di mode debug.

---

## Praktik terbaik (best practice)

1. **Modular config**: taruh pengaturan spesifik (bindings, outputs, programs) di `~/.config/sway/config.d/` dan include dari `config` utama.
2. **Gunakan `exec_always` untuk program yang perlu restart pada reload** (status tray, background, daemon kecil).
3. **Hindari `status_command` yang berat** pada blok bar internal — gunakan `waybar` untuk kustomisasi penuh.
4. **Gunakan `for_window` dan `assign`** untuk otomatisasi workspace.
5. **Backup konfigurasi** sebelum eksperimen: `cp ~/.config/sway/config ~/.config/sway/config.bak`

---

## Sumber & referensi resmi

* Dokumentasi resmi Sway: [https://swaywm.org](https://swaywm.org)
* Repo Sway (GitHub): [https://github.com/swaywm/sway](https://github.com/swaywm/sway)
* Repo wlroots: [https://github.com/swaywm/wlroots](https://github.com/swaywm/wlroots)

---

## Penutup

Dokumen ini lengkap dengan kamus istilah penting, contoh konfigurasi yang dapat dijalankan, dan penjelasan kata-per-kata untuk token/token umum — cukup untuk dijadikan dasar kelas atau referensi harian.

Jika anda berminat untuk mengunjungi disini walaupun mungkin ada banyak yang perlu diabaikan, [coba klik disini][1]
<!---->
<!-- Jika kamu ingin: -->
<!---->
<!-- * Aku bersihkan file `sway.txt` original dan ubah jadi dokumentasi resmi terstruktur; atau -->
<!-- * Aku keluarkan varian *dotfiles* untuk Arch Linux (termasuk paket yang perlu diinstall dan unit systemd) — sebutkan pilihanmu. -->
<!---->
<!-- Selesai. -->
<!---->
<!-- <details> -->
<!--   <summary>📃 Daftar Isi</summary> -->
<!---->
<!-- </details> -->
<!---->
<!---->
<!-- > - **[Selanjutnya][selanjutnya]** -->
<!-- > - **[Sebelumnya][sebelumnya]** -->
<!-- > - **[Kurikulum][kurikulum]** -->
<!-- > - **[Home][domain]** -->
<!---->
[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../bagian-4/sway.md
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
