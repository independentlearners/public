# Ringkasan singkat SwayWM

Sway adalah **tiling Wayland compositor** yang dirancang sebagai pengganti drop-in untuk i3 (X11). Dikembangkan untuk bekerja di atas library **wlroots**, Sway menyediakan pengalaman manajemen jendela bertipe tiling dengan kompatibilitas konfigurasi i3, dukungan XWayland, IPC berbasis JSON, dan ekosistem utilitas (swaybar, swaylock, swayidle, dsb.). ([swaywm.org][1])

# Arsitektur dan komponen utama

* **[wlroots][a]** — library modular yang mengabstraksi DRM/KMS, EGL, libinput, XWayland, rendering, dan backend lain; wlroots menjadi fondasi teknis Sway untuk akses perangkat dan rendering. ([GitLab][2])
    - > Sumber tautan untuk GitHub di komentari karena proyek telah di arsipkan.
* **Sway (kompositor)** — program utama (C) yang mengimplementasikan manajemen tata letak tiling, binding keyboard, pengaturan output dan input, serta mengeksekusi konfigurasi pengguna. Sway ditulis dalam **bahasa C**. ([GitHub][3])
* **Utilitas pendukung** — `swaybar` (status bar), `swaylock` (lock screen), `swayidle` (idle management), `swaymsg` (CLI untuk IPC), dan daemon lain yang biasa disertakan di distribusi. ([GitHub][3])
* **XWayland** — lapisan kompatibilitas untuk menjalankan aplikasi X11 di dalam sesi Wayland ketika diperlukan. wlroots/Sway mengelolanya bila dipasang. ([GitHub][2])

# Fitur penting (apa yang membuat Sway menarik)

* Kompatibilitas konfigurasi i3: banyak konfigurasi i3 bisa langsung dipakai (salin `~/.config/i3/config` → `~/.config/sway/config`). ([wiki.archlinux.org][4])
* IPC JSON melalui Unix socket: alat eksternal dapat mengontrol Sway dengan `swaymsg` atau library yang membaca/menulis JSON. Ini membuka kemungkinan integrasi dengan skrip (bash, Python, Lua, Rust, dll.). ([GitHub][3])
* Tiling otomatis, layout fleksibel, multiple outputs, per-output config, dan binding keyboard/mouse yang kuat. ([swaywm.org][1])

# Konfigurasi — tempat dan konsep penting

* Lokasi konfigurasi umum: `~/.config/sway/config` (salin contoh dari `/etc/sway/config`). Banyak direktif mirip i3: `bindsym`, `workspace`, `output`, `input`, `exec`, dll. ([wiki.archlinux.org][4])
* Mode binding, per-output rules, floating windows, sway-specific blocks (status bar) dan per-app rules tersedia.
* Jalankan `sway` dari TTY; gunakan `sway -d` untuk debug/log; IPC socket biasanya tersedia via variabel lingkungan `SWAYSOCK` atau di path standar. ([GitHub][3])

# Pengembangan, modifikasi, dan prasyarat teknis

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

# Cara memperluas fungsionalitas tanpa memodifikasi kode C

* **Skrip eksternal & status blocks**: banyak ekstensi dibuat hanya dengan skrip shell/Python/Node/Rust yang berkomunikasi lewat `swaymsg` atau menulis ke bar (i3bar protocol / swaybar). Ini adalah jalur tercepat untuk menambah fitur tanpa compile ulang. ([GitHub][3])
* **IPC (JSON)**: gunakan socket IPC untuk membaca status, mengubah layout, memindahkan jendela, dsb. Tersedia binding pihak ketiga untuk bahasa populer. ([GitHub][3])

# Keterbatasan dan hal yang perlu diperhatikan

* Karena berbasis Wayland, beberapa aplikasi X11 lama memerlukan XWayland—tidak semua perilaku X11 1:1 identik. ([GitHub][2])
* Pengalaman hardware-accelerated bergantung pada driver GPU, kernel, dan konfigurasi DRM/EGL; pengujian pada mesin nyata lebih representatif daripada VM kecuali VM memiliki passthrough GPU yang baik. ([GitHub][7])
* Ketergantungan ke wlroots berarti banyak keputusan arsitektural ditetapkan di layer tersebut; kontribusi fitur yang menyentuh rendering/input biasanya harus sinkron dengan desain wlroots. ([GitHub][2])

# Praktis: beberapa perintah & tip cepat

* Menyalin konfigurasi i3 → sway: `cp /etc/sway/config ~/.config/sway/config` lalu sesuaikan. ([wiki.archlinux.org][4])
* Mengirim perintah lewat IPC: `swaymsg 'workspace 2; exec alacritty'`. ([GitHub][3])
* Debugging runtime: `sway -d 2> ~/sway.log` untuk melihat pesan kesalahan/diagnostik. ([GitHub][3])

# Sumber resmi & bacaan lanjutan (direkomendasikan)

* Situs resmi Sway: swaywm.org — gambaran umum dan link dokumentasi. ([swaywm.org][1])
* Repositori GitHub Sway: `swaywm/sway` — README, wiki, issue tracker (bagus untuk contoh bug/patch). ([GitHub][3])
* wlroots: `swaywm/wlroots` — dokumentasi teknis dan contoh API. ([GitHub][2])
* ArchWiki Sway — panduan instalasi, konfigurasi, dan tips distribusi. ([wiki.archlinux.org][4])
* Wikipedia (ringkasan & sejarah singkat) — untuk konteks rilis dan penulis utama. ([Wikipedia][5])

# Rekomendasi langkah Anda berikutnya (direktif praktis)

1. Jika Anda ingin **memodifikasi** Sway: mulailah dengan mempelajari C dan konsep Wayland, lalu clone wlroots + sway, setup Meson/Ninja, dan jalankan build lokal. Ikuti issue/PR di GitHub untuk melihat pola kontribusi. ([GitHub][2])
2. Jika Anda ingin **mengembangkan plugin/fitur cepat**: gunakan `swaymsg`/IPC dan buat skrip (bash/Python/Lua/Rust) yang berinteraksi dengan Sway — ini sesuai dengan minat Anda pada TUI/CLI dan integrasi Neovim. ([GitHub][3])
3. Bila butuh panduan langkah-demi-langkah (mis. buat environment build di Archlinux, contoh modifikasi sederhana, atau template config i3→sway yang rapi), saya siapkan panduan terperinci beserta snippet konfigurasi dan perintah build.

---
<!--
Saya sudah menyiapkan overview lengkap ini sebagai peta besar: arsitektur, dependensi teknis, cara pengembangan, dan daftar sumber resmi. Jika Anda ingin, saya akan lanjutkan dengan salah satu dari opsi praktis di poin terakhir (mis. panduan *build-from-source* untuk Archlinux atau template konfigurasi `~/.config/sway/config` yang rapi dan komentari baris demi baris). Saya akan langsung membuatnya tanpa perlu pertanyaan lain.
-->

[1]: https://swaywm.org/?utm_source=chatgpt.com "Sway"
[2]: https://gitlab.freedesktop.org/wlroots/wlroots "swaywm/wlroots: A modular Wayland compositor library"
<!-- Tautan wlroots untuk github
https://github.com/swaywm/wlroots?utm_source=chatgpt.com 
-->
[3]: https://github.com/swaywm/sway?utm_source=chatgpt.com "swaywm/sway: i3-compatible Wayland compositor"
[4]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[5]: https://en.wikipedia.org/wiki/Sway_%28window_manager%29?utm_source=chatgpt.com "Sway (window manager)"
[6]: https://bvngee.com/blogs/compile-sway-and-wlroots-together-from-source?utm_source=chatgpt.com "Compiling Sway with wlroots from Source - Bvngee"
[7]: https://github.com/swaywm/sway/issues/4802?utm_source=chatgpt.com "Sway is laggy/unresponsive on VirtualBox Arch guest #4802"

### 📁 Dasar-Dasar File Konfigurasi Sway

File konfigurasi Sway (biasanya berada di `~/.config/sway/config`) adalah file teks yang berisi perintah-perintah yang dieksekusi saat Sway启动 . Ia memiliki beberapa fitur sintaksis inti:

| Fitur Sintaks | Deskripsi & Contoh |
| :--- | :--- |
| **Perintah Sederhana** | Satu perintah per baris. Contoh: `bindsym $mod+Return exec $term` . |
| **Line Continuation**| Gunakan `\` di akhir baris untuk memperpanjang satu perintah ke beberapa baris . |
| **Block Command** | Gunakan kurung kurawal `{}` untuk mengelompokkan beberapa sub-perintah di bawah satu perintah induk . |

**Contoh Blok Konfigurasi:**
```
# Contoh konfigurasi output dalam blok 
output eDP-1 {
    background ~/wallpaper.png fill # Set wallpaper dengan mode 'fill'
    resolution 1920x1080 # Set resolusi output
}
```
Kode di atas setara dengan menulis dua baris perintah terpisah: `output eDP-1 background ...` dan `output eDP-1 resolution ...` .

### ⌨️ Mendefinisikan Variabel dan Perintah Input

**1. Mendefinisikan Variabel**
Gunakan kata kunci `set` untuk mendefinisikan variabel yang dapat digunakan di seluruh konfigurasi. Variabel ini untuk keperluan internal Sway dan **bukan** Environment Variable shell .
```
# Definisi variabel umum 
set $mod Mod4 # Tombol Super/Windows sebagai modifier key
set $left h # Tombol arah (seperti Vim)
set $term foot # Terminal emulator pilihan
```

**2. Konfigurasi Perangkat Input**
Gunakan perintah `input` untuk mengonfigurasi keyboard, touchpad, dan perangkat input lainnya. Identifikasi perangkat dengan `identifier` dari `swaymsg -t get_inputs` .

**Konfigurasi Keyboard:**
```
# Konfigurasi layout keyboard (digunakan oleh semua perangkat keyboard)
input type:keyboard {
    xkb_layout us,id # Set layout keyboard US dan Indonesia
    xkb_variant colemak # Gunakan varian Colemak
    repeat_delay 300 # Delay sebelum key repeat (milidetik)
    repeat_rate 45 # Laju key repeat (karakter per detik) 
}
```

**Konfigurasi Touchpad:**
```
# Konfigurasi touchpad (digunakan oleh semua perangkat touchpad)
input type:touchpad {
    tap enabled # Aktifkan tap-to-click
    natural_scroll enabled # Aktifkan natural scroll
    clickfinger_button_map lrm # Map: 1jari=klik kiri, 2jari=klik kanan 
}
```

### 🖥️ Mengatur Output dan Tampilan

Gunakan perintah `output` untuk mengonfigurasi monitor dan tampilan. Dapatkan nama output dengan `swaymsg -t get_outputs` .

**Konfigurasi Dasar Output:**
```
# Contoh konfigurasi untuk monitor HDMI
output "HDMI-A-1" {
    mode 1920x1080@60Hz # Set resolusi dan refresh rate 
    position 1920 0 # Posisikan monitor di koordinat (1920, 0)
    scale 1 # Faktor skala (gunakan 2 untuk layar HiDPI) 
    background ~/wallpaper.png fill # Set wallpaper, # Alternatif warna polos: background #RRGGBB solid_color 
}
```

**Mode dan Posisi Lanjutan:**
- `mode --custom 2560x1080@74.99Hz`: Memaksa mode kustom .
- `transform 90`: Memutar output 90 derajat .
- `adaptive_sync on`: Mengaktifkan Adaptive Sync/VRR jika didukung .
- `max_render_time 1`: Mengoptimalkan latensi render .

### 🔧 Konfigurasi dan Perintah Runtime Lainnya

**1. Mengelola Window dan Workspace**
- `bindsym $mod+1 workspace number 1`: Binds a key to switch to workspace 1.
- `bindsym $mod+Shift+1 move container to workspace number 1`: Binds a key to move the focused window to workspace 1.
- `floating enable`, `fullscreen enable`: Mengubah mode jendela .
- `layout tabbed`: Mengubah tata letak workspace menjadi tabbed .

**2. Mengatur Variabel Lingkungan**
Variabel lingkungan untuk aplikasi (seperti `MOZ_ENABLE_WAYLAND=1`) tidak dapat diekspor langsung dari file konfigurasi Sway. Cara yang direkomendasikan adalah dengan **menjalankan Sway menggunakan wrapper script** .

Buat sebuah script, contohnya `~/.local/bin/sway-launch`:
```bash
#!/bin/sh
# Wrapper script untuk mengekspor environment variables sebelum menjalankan Sway
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
exec sway
```
Set script sebagai executable (`chmod +x ~/.local/bin/sway-launch`) dan jalankan Sway melalui script ini, misalnya dari `~/.xinitrc` .

**3. Konfigurasi Swaynag (Notifikasi Sistem)**
Swaynag adalah sistem notifikasi untuk Sway. Anda dapat mengonfigurasi penampilannya melalui file di `~/.config/swaynag/config` .
```
# Contoh konfigurasi default Swaynag
font=Monospace 12
edge=top

# Tipe kustom untuk notifikasi update
[update]
background=009900
border=006600
text=FFFFFF
button-background=00AA00
```

### 💡 Saran untuk Orkestrasi dan Automasi

Bash dan Lua yang sudah Anda pelajari merupakan fondasi yang sangat baik untuk mengotomasi Sway.

- **Bash**: Ideal untuk menulis **script automasi** yang dijalankan oleh Sway. Contohnya, script untuk mengatur monitor secara dinamis, atau menu kustom yang dijalankan dengan `bindsym ... exec /path/to/script.sh` .
- **Lua**: Meski Sway tidak mengeksekusi konfigurasi langsung dalam Lua, Anda bisa **menggunakan Lua untuk menghasilkan file konfigurasi Sway**. Ini sangat powerful untuk mengelola konfigurasi yang kompleks dan dinamis dengan memanfaatkan struktur data seperti Tabel.

**Contoh Potongan Ide dengan Lua:**
```lua
-- Contoh: Generate konfigurasi output untuk multi-monitor
local outputs = {
    { name = "HDMI-A-1", pos = "0 0", wall = "~/wall1.png" },
    { name = "eDP-1", pos = "1920 0", wall = "~/wall2.png" }
}

for _, o in ipairs(outputs) do
    print(string.format("output %s { pos %s bg %s fill }", o.name, o.pos, o.wall))
end
```
Jalankan script Lua tersebut dan simpan outputnya ke file, atau gunakan dalam script build system seperti `make` untuk menghasilkan konfigurasi final. **Saat ini, Anda tidak perlu mempelajari bahasa pemrograman baru** karena Bash dan Lua sudah cukup untuk memulai.

### 🔍 Sumber Referensi Tambahan

Untuk informasi yang lebih mendalam, Anda dapat merujuk langsung ke halaman manual (manpages) yang menjadi sumber utama dokumen ini:
- `man 5 sway` - Konfigurasi umum dan command runtime .
- `man 5 sway-input` - Konfigurasi perangkat input secara detail .
- `man 5 sway-output` - Konfigurasi output secara detail .
- `man 5 swaynag` - Konfigurasi sistem notifikasi .

Konfigurasi Sway sangat fleksibel. Mulailah dengan file konfigurasi dasar, lalu secara bertahap tambahkan dan sesuaikan baris-baris konfigurasi sesuai kebutuhan workflow Anda. Penjelasan diatas sudah **cukup solid untuk dasar-dasar konfigurasi Sway**, namun **belum sepenuhnya mewakili semua yang ada di man pages**. Berikut analisis detailnya:

## ✅ **Apa yang Sudah Tercover dengan Baik Pada Penjelasan Ddiatas:**

- **Struktur file config** dan sintaks dasar
- **Variabel dan input configuration** 
- **Output configuration** (resolusi, posisi, wallpaper)
- **Key binding** dasar dan workspace management
- **Environment variables** approach via wrapper script
- **Swaynag configuration** dasar

## ❌ **Apa yang Masih Perlu Ditambahkan dari Man Pages:**

### **1. Dari `man 5 sway` - Bagian CRITICAL yang Missing:**

**Window Rules dan Criteria:**
```
# Syntax: for_window [criteria] <command>
for_window [title="Firefox"] floating enable
for_window [app_id="foot"] border pixel 2
for_window [class="^.*"] inhibit_idle focus  # Prevent idle when focused
```

**Assignment Rules:**
```
# Auto-assign aplikasi ke workspace tertentu
assign [app_id="spotify"] → 9
assign [class="Discord"] → 5
```

**Mode Configuration:**
```
# Custom modes selain default
mode "resize" {
    bindsym Left resize shrink width 10px
    bindsym Right resize grow width 10px
    bindsym Escape mode "default"
}
```

**Color Configuration:**
```
# Syntax: <border> <background> <text> <indicator> <child_border>
client.focused          #2e9ef4 #2e9ef4 #ffffff #2e9ef4 #2e9ef4
client.unfocused        #555555 #222222 #888888 #292d2e #222222
client.focused_inactive #5f676a #5f676a #ffffff #5f676a #5f676a
```

### **2. Dari `man 5 sway-input` - Input Advanced:**

**Device-Specific Configuration:**
```
input "1234:5678:My_Keyboard" {
    xkb_layout us,id
    xkb_options grp:win_space_toggle  # Toggle layout dengan Win+Space
    repeat_delay 300
    repeat_rate 45
}

input "1234:5678:My_Touchpad" {
    dwt enabled                    # disable while typing
    middle_emulation enabled       # emulation klik tengah
    tap_button_map lrm             # left-right-middle
    scroll_method two_finger
}
```

### **3. Dari `man 5 sway-output` - Output Advanced:**

**Scale Configuration untuk HiDPI:**
```
output "eDP-1" {
    scale 2                        # Untuk display HiDPI
    scale_filter linear            # atau nearest, smart
    subpixel rgb                   # untuk text rendering yang lebih baik
}

output "DP-1" {
    mode 3840x2160@60Hz
    adaptive_sync on
    max_render_time 1
}
```

### **4. Security dan IPC Configuration:**

**Socket Configuration:**
```
# Set IPC socket location
ipc-socket ~/.config/sway/ipc.sock

# Security - disable socket jika diperlukan
# ipc-socket disable
```

## 🎯 **Rekomendasi untuk Pemula:**

**Untuk pemula, penjelasan sebelumnya SUDAH CUKUP** untuk membuat config functional. Namun **sangat disarankan** untuk melengkapi dengan:

### **Step-by-Step Learning Path:**

1. **Start dengan config dasar** yang sudah dijelaskan
2. **Pelajari criteria matching** untuk window rules:
   ```bash
   swaymsg -t get_tree | less  # Lihat properties window yang aktif
   ```
3. **Eksplor man pages secara bertahap:**
   ```bash
   man 5 sway          # Fokus pada section "CRITERIA" dan "COMMANDS"
   man 5 sway-input    # Fokus pada device-specific config
   man 5 sway-output   # Fokus pada multi-monitor setup
   ```

### **Template Config Structure yang Recommended:**

```
# ~/.config/sway/config - Minimal viable dengan semua essential sections

# Variables
set $mod Mod4

# Input configuration
input type:keyboard { ... }
input type:touchpad { ... }

# Output configuration  
output * { ... }
output specific { ... }

# Key bindings
bindsym $mod+Return exec $term
...

# Window rules & assignment
for_window [criteria] command
assign [criteria] → workspace

# Appearance (colors, borders, etc.)
client.focused ...

# Mode configuration
mode "resize" { ... }

# Status bar
bar { ... }
```

## 📚 **Sumber Referensi Lengkap:**

**Priority Reading Order:**
1. `man 5 sway` - **Section CRITERIA** dan **COMMANDS**
2. `man 5 sway-input` - **Device identification** dan **scroll methods**  
3. `man 5 sway-output` - **HiDPI** dan **adaptive sync**
4. `man sway` - **Runtime commands** dan **IPC**

**Online References:**
- [sway(5) man page online](https://man.archlinux.org/man/sway.5)
- [Sway Configuration Guide](https://github.com/swaywm/sway/wiki)

## 🎓 **Kesimpulan:**

**Untuk pemula: CUKUP** dengan penjelasan sebelumnya + tambahan window rules dan color configuration.

**Untuk advanced user: PERLU** mempelajari semua man pages secara detail, khususnya criteria matching dan device-specific configuration.

**Actionable next step:** Buat config dasar dulu, kemudian secara bertahap tambahkan fitur dari man pages sesuai kebutuhan workflow Anda.

Sekarang mari kita eksplorasi secara mendalam aspek-aspek advanced configuration Sway yang memang memerlukan pemahaman mendetail dari man pages.

## 🔍 **Advanced Criteria Matching**

### **1. Comprehensive Criteria Properties**

Dari `man 5 sway` section **CRITERIA**, terdapat banyak properti yang bisa digunakan:

```bash
# Multiple criteria combinations
for_window [app_id="firefox" title="Mozilla Firefox"] floating enable
for_window [app_id=".*" instance="^term$"] border pixel 2

# Berdasarkan tipe window
for_window [app_id="foot" con_mark="^urgent$"] urgent enable
for_window [shell=".*" window_type="dialog"] floating enable
for_window [window_type="menu"] floating enable, sticky enable

# Criteria berdasarkan state
for_window [con_id="123" floating] move position center
for_window [tiling] borders pixel 5
```

### **2. Regular Expression dalam Criteria**

```bash
# Regex untuk matching flexible
for_window [app_id="^firefox$" title=".*Private Browsing.*"] opacity 0.9
for_window [class="^(?i)spotify$"] inhibit_idle fullscreen
for_window [title=".*[Dd]ownload.*"] floating enable, move to workspace 9

# Negative matching
for_window [app_id="^(?!foot$).*"] focus_follows_mouse no
```

### **3. Dynamic Criteria dengan Marks**

```bash
# Set mark pada window tertentu
bindsym $mod+m mark "important"

# Gunakan mark dalam criteria
for_window [con_mark="important"] sticky enable, floating enable
for_window [con_mark="^work$"] move to workspace 2
```

## ⌨️ **Advanced Input Configuration**

### **1. Device-Specific Input Matching**

Dari `man 5 sway-input`, identifikasi perangkat secara spesifik:

```bash
# Dapatkan identifier perangkat
swaymsg -t get_inputs
# Output: "1234:5678:My_Keyboard"

# Konfigurasi berdasarkan identifier spesifik
input "1234:5678:Logitech_G_PRO" {
    xkb_layout us
    xkb_variant colemak
    repeat_delay 200
    repeat_rate 50
    scroll_method on_button_down
    scroll_button 272
}

input "1234:5679:Apple_Touchpad" {
    dwt enabled
    tap enabled
    natural_scroll disabled
    tap_button_map lrm
    calibration_matrix 1.0 0.0 0.0 0.0 1.0 0.0
}
```

### **2. Advanced Keyboard Configuration**

```bash
input type:keyboard {
    xkb_layout us,ru,de
    xkb_options grp:win_space_toggle,ctrl:nocaps
    xkb_numlock enable
    xkb_capslock disabled
    
    # Key repeat configuration
    repeat_delay 300
    repeat_rate 45
    
    # Macro keys atau special keys
    bindkeys {
        --whole-device
        XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
        XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
        XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
    }
}
```

## 🖥️ **Advanced Output Configuration**

### **1. Multi-Monitor Complex Setup**

```bash
# Dynamic workspace assignment per monitor
workspace 1 output HDMI-A-1
workspace 2 output HDMI-A-1
workspace 3 output DP-1
workspace 4 output DP-1

# Mode custom dengan timing details
output "HDMI-A-1" {
    mode 2560x1440@144.000Hz
    position 0,0
    scale 1.0
    subpixel bgr
    transform 270
    adaptive_sync on
    max_render_time 1
    background ~/wallpaper.png fill
}

# Fallback configuration
output "*" {
    background #000000 solid_color
    scale 1
}

# HiDPI dengan fractional scaling
output "eDP-1" {
    scale 1.5
    scale_filter smart
    bg ~/wallpaper-hidpi.png fill
}
```

### **2. Color Management & Gamma**

```bash
# Gamma correction dan color profile
output "DP-1" {
    gamma 1.0:0.909:0.833
    gamma 0.8:0.8:0.8
    gamma 0.454545:0.344:0.285
    
    # Color profile (jika supported)
    # color_profile /path/to/profile.icc
}
```

## ⚙️ **Advanced Runtime Commands & IPC**

### **1. Swaymsg dan IPC Control**

```bash
# Contoh script Bash untuk mengotomasi Sway via IPC
#!/bin/bash

# Focus window dengan criteria tertentu
swaymsg '[app_id="firefox"] focus'

# Move window ke workspace tertentu
swaymsg '[title="Discord"] move container to workspace 5'

# Resize window dengan criteria
swaymsg '[app_id="foot"] resize set width 1200 height 800'

# Get tree structure untuk debugging
swaymsg -t get_tree | jq '.. | select(.type?) | select(.type=="con")'
```

### **2. Event Handling dengan swaymsg -m**

```bash
# Monitor events secara real-time
swaymsg -m -t subscribe '["window"]' | while read event; do
    echo "Window event: $event"
    # Custom logic berdasarkan event
done
```

## 🎨 **Advanced Appearance & Themes**

### **1. Comprehensive Client Colors**

```bash
# Complete color configuration dari man 5 sway
client.focused          #4c7899 #4c7899 #ffffff #2e9ef4 #4c7899
client.focused_inactive #333333 #5f676a #ffffff #484e50 #5f676a
client.unfocused        #333333 #222222 #888888 #292d2e #222222
client.urgent           #2f343a #900000 #ffffff #900000 #900000
client.placeholder      #000000 #0c0c0c #ffffff #000000 #0c0c0c

client.background       #ffffff

# Border configuration
default_border pixel 3
default_floating_border normal 2
smart_borders on
smart_gaps inverse_outer
```

### **2. Advanced Bar Configuration**

```bash
bar {
    position top
    mode dock
    hidden_state hide
    modifier Mod4
    
    # Multiple outputs
    output HDMI-A-1
    output DP-1
    tray_output primary
    
    # Status commands dengan formatting
    status_command while ~/.config/sway/status.sh; do sleep 1; done
    
    # Workspace buttons configuration
    workspace_buttons yes
    strip_workspace_numbers yes
    workspace_min_width 100
    
    # Colors dengan semua state
    colors {
        background #000000
        statusline #ffffff
        focused_workspace  #4c7899 #4c7899 #ffffff
        active_workspace   #333333 #333333 #ffffff
        inactive_workspace #333333 #333333 #888888
        urgent_workspace   #2f343a #900000 #ffffff
        binding_mode       #2f343a #900000 #ffffff
    }
    
    # Font dengan fallback
    font pango:Monospace 10, FontAwesome 10
}
```

## 🔧 **Performance & Optimization**

### **1. Render Optimization**

```bash
# Dari man 5 sway-output
output "*" {
    max_render_time 1
    adaptive_sync on
}

# Memory management
max_render_time off
```

### **2. Input Latency Optimization**

```bash
input "1234:5678:Gaming_Mouse" {
    accel_profile flat
    pointer_accel 0.0
    scroll_method on_button_down
    scroll_button 273
    drag_lock enabled
}
```

## 🛠️ **Advanced Scripting dengan Bash & Lua**

### **1. Bash Script untuk Dynamic Configuration**

```bash
#!/bin/bash
# ~/.config/sway/scripts/monitor-setup.sh

# Detect connected monitors
MONITORS=$(swaymsg -t get_outputs | jq -r '.[] | .name')

for MONITOR in $MONITORS; do
    case $MONITOR in
        "HDMI-A-1")
            swaymsg output "$MONITOR" pos 0 0 res 2560x1440@120Hz
            ;;
        "DP-1") 
            swaymsg output "$MONITOR" pos 2560 0 res 1920x1080@60Hz
            ;;
        *)
            swaymsg output "$MONITOR" disable
            ;;
    esac
done
```

### **2. Lua Script untuk Config Generation**

```lua
-- ~/.config/sway/generate-config.lua
local config = {
    outputs = {
        { name = "HDMI-A-1", pos = "0 0", res = "2560x1440", rate = 120 },
        { name = "DP-1", pos = "2560 0", res = "1920x1080", rate = 60 }
    },
    workspaces = {
        { number = 1, output = "HDMI-A-1", apps = {"firefox"} },
        { number = 2, output = "HDMI-A-1", apps = {"foot"} },
        { number = 3, output = "DP-1", apps = {"spotify"} }
    }
}

-- Generate output configuration
for _, output in ipairs(config.outputs) do
    print(string.format("output %s { position %s mode %s@%dHz }", 
        output.name, output.pos, output.res, output.rate))
end

-- Generate workspace assignment
for _, ws in ipairs(config.workspaces) do
    print(string.format("workspace %d output %s", ws.number, ws.output))
    for _, app in ipairs(ws.apps) do
        print(string.format("assign [app_id=\"%s\"] %d", app, ws.number))
    end
end
```

## 📚 **Sumber Referensi Advanced**

### **Command untuk Explorasi Manual:**

```bash
# Lihat semua properties yang tersedia untuk criteria
man 5 sway | grep -A 50 "CRITERIA"

# Explore current state
swaymsg -t get_inputs
swaymsg -t get_outputs  
swaymsg -t get_tree
swaymsg -t get_seats

# Debug configuration
swaymsg -t get_config
swaymsg debuglog on
```

### **Key Man Pages untuk Advanced Users:**
- `man 5 sway` - **Section CRITERIA** (halaman 3-5)
- `man 5 sway-input` - **Device matching** dan **scroll methods**
- `man 5 sway-output` - **Color management** dan **gamma correction**
- `man sway` - **IPC commands** dan **runtime control**
- `man swaymsg` - **Event subscription** dan **JSON output**

## 🎯 **Kesimpulan Advanced**

Untuk menjadi advanced user Sway, Anda perlu memahami:

1. **Criteria matching yang komprehensif** dengan regex dan multiple conditions
2. **Device-specific configuration** dengan precise identifier matching  
3. **IPC dan scripting integration** untuk dynamic configuration
4. **Performance tuning** dengan render time dan adaptive sync
5. **Complex multi-monitor setup** dengan workspace assignment
<!--
Dengan Bash dan Lua yang sudah Anda kuasai dasar-dasarnya, Anda sudah memiliki fondasi yang kuat untuk membuat konfigurasi Sway yang sangat advanced dan terotomasi dengan baik.
-->





<!--
*(gaya dokumentasi profesional ala GitHub; tersusun rapi, menggunakan ikon untuk navigasi cepat; Bahasa Indonesia resmi)*


---

> Setelah audit kamu, saya akan mengubah setiap fase menjadi sub-bab terperinci (tujuan, referensi man/URI, contoh `~/.config/sway/config` bertahap, laboratorium praktis, dan checklist verifikasi).

---

# 🔧 Fase 0 — 

# 🧭 Fase 1 — 

# 🪄 Fase 2 — 
# 🧰 Fase 3 — 
# 🧩 Fase 4 — # 🤖 Fase 5 — 

> Saya akan menyediakan satu tabel yang lebih terperinci per-distro (Arch / Debian / Fedora) bila kamu setuju; tabel itu akan menyertakan nama paket tepat dan perintah instalasi.

# 🔁 Alur audit & langkah selanjutnya (sesudah kamu review)

1. Kamu audit roadmap ini dan beri catatan (komentar per bagian / permintaan tambah/kurangi).
2. Saya akan memperbarui struktur sesuai catatan.
3. Setelah final, saya uraikan **setiap fase** menjadi materi lengkap:

   * penjelasan konsep, manpages yang relevan, potongan konfigurasi bertahap, laboratorium praktis, skrip contoh lengkap, dan rubrik penilaian.
4. Kamu dapat memilih fase yang ingin dipelajari/diterapkan lebih dahulu; saya akan susun jadwal belajar praktis per-hari/per-minggu.

---

Saya sudah menyusun roadmap lengkap, rapi, dan terstruktur sesuai permintaanmu. Silakan **audit dan beri catatan** (mis. tambahkan distro khusus, fokus bahasa scripting tertentu, atau permintaan templates tambahan). Setelah menerima audit, saya akan **memperjelas tiap fase** menjadi kurikulum detil yang kamu minta.-->
[0]: https://github.com/swaywm/sway/wiki

<!--wlroots-->
[a]: ./../../module/bagian-1/README.md
