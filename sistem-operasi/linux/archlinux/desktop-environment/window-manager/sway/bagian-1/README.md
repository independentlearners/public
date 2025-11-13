<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#


Bagus — sekarang saya akan **memperjelas setiap fase** secara rinci dan praktis. Untuk setiap fase saya akan menyajikan:

* Tujuan singkat fase.
* Terminologi penting yang harus dipahami.
* Langkah-langkah praktis terurut (step-by-step).
* Contoh konfigurasi / skrip yang **siap dijalankan**.
* Penjelasan **baris demi baris** untuk setiap potongan kode.
* Identitas teknis tiap komponen (bahasa implementasi) dan persyaratan untuk memodifikasi/mengembangkannya.

Saya akan menampilkan seluruh fase (0 → 7). Bila suatu bagian butuh snippet panjang, saya tetap menjelaskan setiap barisnya. Mari mulai.

---

# 🧭 Fondasi Wayland & wlroots

**Tujuan:** paham arsitektur Wayland dan peran wlroots agar perubahan konfigurasi tidak bersifat tebak-tebakan.

## Terminologi penting

* **Compositor**: program yang menerima buffer dari client dan menggambar ke layar (Sway adalah compositor).
* **Client**: aplikasi yang menampilkan UI (terminal, browser).
* **Protocol**: definisi pesan (Wayland protocol).
* **Seat**: abstraksi input (keyboard/mouse) untuk user.
* **wlroots**: library untuk membuat compositor — menyediakan backend DRM, input, rendering helpers.

## Langkah praktis

1. Baca ringkasan konsep Wayland (bisa dimulai dari dokumentasi resmi).
2. Gambarkan alur: aplikasi → Wayland client lib → Wayland compositor (Sway) → wlroots → kernel DRM → hardware.
3. Eksperimen: jalankan `WAYLAND_DISPLAY=wayland-0 some-wayland-client` (contoh umum); lebih penting: lihat state dengan `swaymsg -t get_tree`.

Tidak ada konfigurasi file di fase ini; tujuan adalah konsep.

-->

# ⚙️ Fase 2 — Konfigurasi Dasar Sway (`man 5 sway`)

**Tujuan:** setiap baris di `~/.config/sway/config` dapat dijelaskan dan dimodifikasi dengan aman.

Di bawah ini contoh `~/.config/sway/config` **minimal → production**, disertai penjelasan baris demi baris.

## Struktur minimal & modular recommended

```
~/.config/sway/
 ├─ config
 └─ config.d/
     ├─ 00-vars.conf
     ├─ 10-keybinds.conf
     ├─ 20-inputs.conf
     └─ 30-outputs.conf
```

### Contoh file utama: `~/.config/sway/config` (minimal)

```conf
# ~/.config/sway/config
# ---------- Vars ----------
set $mod Mod4

# ---------- Includes ----------
include ~/.config/sway/config.d/*

# ---------- Basic keybinds ----------
bindsym $mod+Return exec alacritty
bindsym $mod+d exec wofi --show drun
bindsym $mod+Shift+e exec swaymsg exit

# ---------- Autostart ----------
exec_always --no-startup-id waybar
```

**Penjelasan baris demi baris:**

* `# ~/.config/sway/config` : komentar, hanya menunjukkan path (tidak dieksekusi).
* `set $mod Mod4`

  * `set` = perintah untuk mendefinisikan variabel.
  * `$mod` = nama variabel yang akan dipakai di seluruh config.
  * `Mod4` merujuk ke tombol Super/Windows.
  * Manfaat: ganti modifier pusat tanpa edit banyak baris.
* `include ~/.config/sway/config.d/*`

  * `include` = masukkan file-file lain.
  * Memungkinkan split config modular (keybinds, outputs, inputs).
* `bindsym $mod+Return exec alacritty`

  * `bindsym` = bind key dengan action.
  * `$mod+Return` = kombinasi tombol (Super + Enter).
  * `exec alacritty` = jalankan program `alacritty` (terminal).
* `bindsym $mod+d exec wofi --show drun`

  * `wofi --show drun` menampilkan app launcher (wayland variant).
* `bindsym $mod+Shift+e exec swaymsg exit`

  * Memanggil `swaymsg exit` untuk keluar dari session sway.
* `exec_always --no-startup-id waybar`

  * `exec_always` = jalankan program setiap reload config.
  * `--no-startup-id` = tidak merekam startup-id systemd/WM.
  * `waybar` = start status bar.

### Contoh file `config.d/10-keybinds.conf`

```conf
# keybinds.conf
# Launch terminal
bindsym $mod+Return exec alacritty

# Toggle floating for focused container
bindsym $mod+Shift+space floating toggle

# Kill focused window
bindsym $mod+Shift+q kill
```

Baris demi baris:

* `bindsym $mod+Shift+space floating toggle`

  * `floating toggle` → ubah mode window jadi floating atau kembali tiling.
* `bindsym $mod+Shift+q kill`

  * `kill` → perintah tutup/jendela saat ini (seperti Ctrl+W).

### Input config contoh: `config.d/20-inputs.conf`

```conf
# inputs.conf
input "type:keyboard" {
    xkb_layout us
    xkb_variant intl
}

input "type:mouse" {
    accel_profile flat
    natural_scroll enabled
}
```

Penjelasan:

* `input "type:keyboard"` : spesifikasi device matching (pola match).
* Dalam block `{ ... }` terdapat directives `xkb_layout` untuk layout keyboard, `xkb_variant` untuk varian layout.
* `accel_profile` dan `natural_scroll` adalah opsi libinput untuk mouse.

### Output config contoh: `config.d/30-outputs.conf`

```conf
# outputs.conf
output eDP-1 {
    mode 1920x1080
    pos 0 0
    scale 1
}

output HDMI-A-1 {
    mode 1920x1080
    pos 1920 0
    scale 1
}
```

Penjelasan:

* `output eDP-1` = nama output (monitor) sesuai yang terbaca oleh sway (`swaymsg -t get_outputs`).
* `mode 1920x1080` = resolusi.
* `pos` = posisi relatif (x y) untuk layout multi-monitor.
* `scale` = skala DPI.

## Validasi konfigurasi (perintah)

* Cek sintaks:

  ```bash
  sway -C ~/.config/sway/config
  ```

  > `sway -C` akan memeriksa config, melaporkan error tanpa menjalankan compositor.
* Reload config saat sedang di sway:

  ```bash
  swaymsg reload
  ```
* Inspeksi state:

  ```bash
  swaymsg -t get_tree | jq .
  swaymsg -t get_outputs | jq .
  ```

---

# 🔧 Fase 3 — Utilitas Resmi Sway (praktik & skrip)

**Tujuan:** integrasikan `swayidle`, `swaylock`, `swaymsg` dan buat skrip yang robust.

## Terminologi penting

* **IPC**: Inter-process communication. `swaymsg` mengirim perintah ke IPC socket Sway.
* **exec vs exec_always**:

  * `exec` hanya saat login/first start, `exec_always` setiap reload.

## Contoh 1 — Skrip lock dan idle: `~/.config/sway/scripts/idle-lock.sh`

```bash
#!/usr/bin/env bash
# idle-lock.sh
# Menjalankan swayidle -> setelah 300s, layar dikunci dengan swaylock

swayidle \
  timeout 300 'swaylock -f -c 000000' \
  resume 'swaylock -f -c 000000' \
  before-sleep 'swaylock -f -c 000000'
```

Baris demi baris:

* `#!/usr/bin/env bash` : shebang, menjalankan skrip dengan bash.
* `swayidle \` : jalankan `swayidle` sebagai proses pengelola idle.
* `timeout 300 'swaylock -f -c 000000'` : jika idle selama 300 detik, jalankan `swaylock` dengan warna latar `#000000` (`-f` foreground?).
* `resume 'swaylock -f -c 000000'` : saat resume (bangun), langsung lock.
* `before-sleep 'swaylock -f -c 000000'` : sebelum suspend, lock.

Pasang di `~/.config/sway/config`:

```conf
exec_always --no-startup-id ~/.config/sway/scripts/idle-lock.sh
```

## Contoh 2 — Skrip monitor setup otomatis (bash + jq): `monitor-setup.sh`

```bash
#!/usr/bin/env bash
# monitor-setup.sh
# Auto apply layout: if external HDMI connected, set extended layout; else laptop-only

outputs_json=$(swaymsg -t get_outputs)
has_hdmi=$(echo "$outputs_json" | jq '.[] | select(.name=="HDMI-A-1")')

if [ -n "$has_hdmi" ]; then
  # Apply docked layout
  swaymsg output eDP-1 disable
  swaymsg output HDMI-A-1 enable mode 1920x1080 pos 0 0
else
  # Laptop only
  swaymsg output eDP-1 enable mode 1920x1080 pos 0 0
  swaymsg output HDMI-A-1 disable
fi
```

Penjelasan:

* `swaymsg -t get_outputs` mengeluarkan JSON daftar outputs.
* `jq` mencari apakah `HDMI-A-1` ada.
* Kondisi `if [ -n "$has_hdmi" ]` → jika ditemukan, aplikasi layout docked.
* `swaymsg output ...` perintah mengubah state output.

Pasang sebagai systemd user service atau dipanggil pada autostart.

---

# 🧩 Fase 4 — Integrasi Ekosistem Wayland

**Tujuan:** menyatukan Waybar, Mako, Wofi, Grim/Slurp, PipeWire ke dalam pengalaman desktop.

## Identitas teknis & modifikasi

* **Waybar**: implementasi **C++** + JSON config + CSS stylesheet. Untuk penyesuaian visual: edit CSS & JSON. Untuk menambah module custom: buat executable script (Bash/Python) yang menghasilkan output format yang Waybar harapkan.
* **Mako**: **C**, konfig file. Ubah style lewat file config.
* **Wofi**: **C**, style via CSS.
* **Grim/Slurp**: **C**, CLI tools.

## Contoh integrasi: keybind screenshot & clipboard

Tambahkan ke `10-keybinds.conf`:

```conf
# screenshot region
bindsym $mod+Shift+Print exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +'%Y%m%d-%H%M%S').png && wl-copy < ~/Pictures/screenshot-$(date +'%Y%m%d-%H%M%S').png
```

Penjelasan:

* `grim -g "$(slurp)"` : `slurp` memilih region, `grim` menyimpan screenshot region.
* `~/Pictures/screenshot-...png` : nama file timestamped.
* `&& wl-copy < file` : menyalin file ke clipboard Wayland (wl-clipboard).

## Contoh Waybar module custom (shell script)

File `~/.config/waybar/scripts/volume.sh`:

```bash
#!/usr/bin/env bash
# volume.sh - simple volume module for waybar using pactl
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{ print $5 }' | head -n1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{ print $2 }')
if [ "$MUTED" = "yes" ]; then
  echo '{"text":"🔇 ' "$VOL"'"}'
else
  echo '{"text":"🔊 ' "$VOL"'"}'
fi
```

Waybar `config` snippet (JSON):

```json
"modules-right": ["custom/volume"],
"custom/volume": {
  "format": "{text}",
  "exec": "~/.config/waybar/scripts/volume.sh",
  "interval": 5
}
```

Penjelasan:

* Script mengeluarkan JSON sederhana `{"text":"..."}`
* Waybar memanggil script tiap 5 detik dan menampilkan `text`.

---

# 🤖 Fase 5 — IPC & Scripting Automasi

**Tujuan:** automasi aktif berbasis event Sway menggunakan IPC; contoh implementasi Bash & Python.

## Terminologi penting

* **SWAYSOCK**: socket IPC (environment var) yang dipakai oleh sway clients.
* **i3ipc / swayipc-rs**: library yang mempermudah subscribe/handle events.

### Contoh 1 — Bash: Auto-assign aplikasi saat muncul

Skrip `ipc-autoassign.sh`:

```bash
#!/usr/bin/env bash
# ipc-autoassign.sh - poll window list and assign firefox to workspace 3 (simple approach)

# list windows with swaymsg
swaymsg -t get_tree | jq -r '..|.app_id? // empty' | while read app; do
  if [ "$app" = "firefox" ]; then
    # move the focused container with class "firefox" to workspace 3
    swaymsg '[app_id="firefox"] move container to workspace 3'
  fi
done
```

Catatan: pendekatan ini polling; lebih baik gunakan langganan event.

### Contoh 2 — Python (i3ipc) — event-driven (direkomendasikan)

Install:

```bash
python -m pip install i3ipc
```

Skrip `ipc-autoassign.py`:

```python
#!/usr/bin/env python3
# ipc-autoassign.py
from i3ipc import Connection, Event

i3 = Connection()

def on_window_new(i3conn, event):
    # event.container.app_id untuk Wayland (atau .window_class)
    app_id = getattr(event.container, 'app_id', None) or getattr(event.container, 'window_class', None)
    if app_id and 'firefox' in app_id.lower():
        i3conn.command('move container to workspace 3')

i3.on(Event.WINDOW_NEW, on_window_new)
i3.main()
```

Baris demi baris:

* `from i3ipc import Connection, Event` : import library.
* `i3 = Connection()` : buka koneksi IPC.
* `def on_window_new(...)` : handler saat jendela baru muncul.
* `app_id = getattr(...` : dapatkan id aplikasi (app_id di Wayland).
* `if 'firefox' in app_id.lower(): i3conn.command(...)` : pindahkan container ke workspace 3.
* `i3.on(Event.WINDOW_NEW, on_window_new)` : subscribe event.
* `i3.main()` : loop event blocking.

**Menjalankan sebagai service**: buat systemd user service yang menjalankan skrip ini agar selalu on login.

## Identitas teknis & persyaratan

* **Python (i3ipc)**: implementasi library i3ipc-python; mudah untuk scripting. Untuk deploy perlu Python + pip.
* **Rust (swayipc-rs)**: untuk binary performa tinggi; butuh Rust toolchain (`rustc`, `cargo`).

---

# 🔍 Fase 6 — Debugging, Logging & Tracing

**Tujuan:** mengetahui cara memeriksa masalah konfigurasi, crash, dan perilaku runtime.

## Tools & perintah utama

* `sway -C ~/.config/sway/config` — syntax check.
* `swaymsg -t get_tree` — snapshot struktur container (JSON).
* `swaymsg -t get_outputs` — daftar outputs.
* `journalctl -b /usr/bin/sway` atau `journalctl -xe` — log systemd / sway (distribusi yang menjalankan sway via systemd).
* `WAYLAND_DEBUG=1 sway` — log protokol Wayland (sangat verbose).
* `sway -d 2> ~/sway-debug.log` — jalankan sway dengan debug ke file.

## Penanganan masalah umum (contoh)

* **Masalah keybind tidak bekerja**: jalankan `sway -C` untuk cek sintaks; jika OK, periksa `xkb_layout` pada `input` block; jalankan `swaymsg -t get_inputs`.
* **Output tidak muncul / resolusi salah**: `swaymsg -t get_outputs` untuk melihat nama output; perbaiki `output <name> { mode ... }`.
* **Waybar tidak tampil**: cek `ps aux | grep waybar`; lihat stdout/stderr (jika dijalankan via autostart mungkin log ada di journal).

## Template laporan bug (untuk PR)

1. Langkah reproduksi (commands).
2. `sway -C` output.
3. `swaymsg -t get_tree` snippet (relevan).
4. Log `~/.local/share/sway.log` atau `journalctl` output.
5. Konfigurasi minimal yang memicu bug.

---

# 🛠️ Fase 7 — Build From Source & Kontribusi

**Tujuan:** mampu membangun Sway/wlroots dari source, membuat patch dan mengajukan PR.

## Terminologi & toolchain

* **Meson**: build system (ditulis di Python, `meson.build` file).
* **Ninja**: backend build yang cepat.
* **pkg-config**: menemukan lokasi header/libs.

## Langkah build ringkas (contoh)

1. Clone repo:

   ```bash
   git clone https://github.com/swaywm/sway.git
   cd sway
   ```
2. Setup build:

   ```bash
   meson setup build
   ```

   Penjelasan: buat directory `build` dan konfigurasikan opsi meson.
3. Compile:

   ```bash
   meson compile -C build
   ```
4. Jalankan test (jika tersedia):

   ```bash
   meson test -C build
   ```
5. Install (opsional):

   ```bash
   sudo meson install -C build
   ```

   Catatan: biasanya lebih baik membuat package dari hasil build untuk manajemen.

## Membuat patch & PR

1. Fork repo, buat branch feature/bugfix.
2. Lakukan perubahan, jalankan `meson compile` & test.
3. Commit dengan pesan jelas.
4. Push ke fork, buka PR di upstream dengan deskripsi, langkah reproduksi, dan output log.

## Persyaratan teknis modifikasi

* Mengerti root causes di C: memerlukan debugging (gdb, valgrind).
* Mengetahui cara meng-update `.po`/i18n jika mengubah pesan.
* Ikuti kontribusi guideline di repo Sway (coding style, CI).

---

# ✅ Rangkuman praktis & checklist akhir (per fase)

Untuk setiap fase, pastikan minimal:

* **Fase 0**: paket runtime & build terinstal. (`sway -v` menampilkan versi)
* **Fase 1**: dapat menjelaskan diagram client ↔ compositor ↔ kernel.
* **Fase 2**: `sway -C` ok, keybinds bekerja, outputs terkonfigurasi.
* **Fase 3**: `swayidle` + `swaylock` aktif, monitor-setup script dapat mengubah layout.
* **Fase 4**: Waybar & Mako berjalan; screenshot & clipboard berfungsi.
* **Fase 5**: skrip event-driven berjalan (python service).
* **Fase 6**: bisa mengumpulkan logs & mencari akar masalah.
* **Fase 7**: dapat membuild dari source dan membuat PR dokumentasi/bugfix.

<!--

Jika ini sesuai, langkah berikut yang saya lakukan (otomatis, tanpa menunggu) adalah: **memperluas setiap fase menjadi modul pelajaran lengkap** — untuk tiap modul akan saya sediakan:

* Penjelasan mendalam per topik.
* 1–3 laboratorium langkah demi langkah (input/output expected).
* Semua file konfigurasi contoh lengkap (siap copy-paste).
* Skrip contoh beserta unit-checklist verifikasi.

Saya telah menyajikan fase-per-fase dengan penjelasan baris demi baris untuk kode kunci (config minimal, skrip idle, monitor setup, waybar volume script, Python event handler). Jika kamu ingin saya *lanjutkan sekarang* dan menyusun fase tertentu (mis. Fase 2 lengkap — semua direktif `man 5 sway` dibedah baris-per-baris, plus 10 contoh use-case), katakan fase mana yang ingin diperdalam pertama.

Saya siap memperjelas fase mana pun selanjutnya — langsung kerjakan tanpa menunggu konfirmasi panjang.
-->
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
