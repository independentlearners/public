# Ringkasan singkat SwayWM

Sway adalah **tiling Wayland compositor** yang dirancang sebagai pengganti drop-in untuk i3 (X11). Dikembangkan untuk bekerja di atas library **wlroots**, Sway menyediakan pengalaman manajemen jendela bertipe tiling dengan kompatibilitas konfigurasi i3, dukungan XWayland, IPC berbasis JSON, dan ekosistem utilitas (swaybar, swaylock, swayidle, dsb.). ([swaywm.org][1])

##  Arsitektur dan komponen utama

* **[wlroots][a]** — library modular yang mengabstraksi DRM/KMS, EGL, libinput, XWayland, rendering, dan backend lain; wlroots menjadi fondasi teknis Sway untuk akses perangkat dan rendering. ([GitLab][2])
    - > Sumber tautan untuk GitHub di komentari karena proyek telah di arsipkan.
* **Sway (kompositor)** — program utama (C) yang mengimplementasikan manajemen tata letak tiling, binding keyboard, pengaturan output dan input, serta mengeksekusi konfigurasi pengguna. Sway ditulis dalam **bahasa C**. ([GitHub][3])
* **Utilitas pendukung** — `swaybar` (status bar), `swaylock` (lock screen), `swayidle` (idle management), `swaymsg` (CLI untuk IPC), dan daemon lain yang biasa disertakan di distribusi. ([GitHub][3])
* **XWayland** — lapisan kompatibilitas untuk menjalankan aplikasi X11 di dalam sesi Wayland ketika diperlukan. wlroots/Sway mengelolanya bila dipasang. ([GitHub][2])

##  Fitur penting (apa yang membuat Sway menarik)

* Kompatibilitas konfigurasi i3: banyak konfigurasi i3 bisa langsung dipakai (salin `~/.config/i3/config` → `~/.config/sway/config`). ([wiki.archlinux.org][4])
* IPC JSON melalui Unix socket: alat eksternal dapat mengontrol Sway dengan `swaymsg` atau library yang membaca/menulis JSON. Ini membuka kemungkinan integrasi dengan skrip (bash, Python, Lua, Rust, dll.). ([GitHub][3])
* Tiling otomatis, layout fleksibel, multiple outputs, per-output config, dan binding keyboard/mouse yang kuat. ([swaywm.org][1])

## Konfigurasi — tempat dan konsep penting

* Lokasi konfigurasi umum: `~/.config/sway/config` (salin contoh dari `/etc/sway/config`). Banyak direktif mirip i3: `bindsym`, `workspace`, `output`, `input`, `exec`, dll. ([wiki.archlinux.org][4])
* Mode binding, per-output rules, floating windows, sway-specific blocks (status bar) dan per-app rules tersedia.
* Jalankan `sway` dari TTY; gunakan `sway -d` untuk debug/log; IPC socket biasanya tersedia via variabel lingkungan `SWAYSOCK` atau di path standar. ([GitHub][3])

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

##  Cara memperluas fungsionalitas tanpa memodifikasi kode C

* **Skrip eksternal & status blocks**: banyak ekstensi dibuat hanya dengan skrip shell/Python/Node/Rust yang berkomunikasi lewat `swaymsg` atau menulis ke bar (i3bar protocol / swaybar). Ini adalah jalur tercepat untuk menambah fitur tanpa compile ulang. ([GitHub][3])
* **IPC (JSON)**: gunakan socket IPC untuk membaca status, mengubah layout, memindahkan jendela, dsb. Tersedia binding pihak ketiga untuk bahasa populer. ([GitHub][3])

##  Keterbatasan dan hal yang perlu diperhatikan

* Karena berbasis Wayland, beberapa aplikasi X11 lama memerlukan XWayland—tidak semua perilaku X11 1:1 identik. ([GitHub][2])
* Pengalaman hardware-accelerated bergantung pada driver GPU, kernel, dan konfigurasi DRM/EGL; pengujian pada mesin nyata lebih representatif daripada VM kecuali VM memiliki passthrough GPU yang baik. ([GitHub][7])
* Ketergantungan ke wlroots berarti banyak keputusan arsitektural ditetapkan di layer tersebut; kontribusi fitur yang menyentuh rendering/input biasanya harus sinkron dengan desain wlroots. ([GitHub][2])

##  Praktis: beberapa perintah & tip cepat

* Menyalin konfigurasi i3 → sway: `cp /etc/sway/config ~/.config/sway/config` lalu sesuaikan. ([wiki.archlinux.org][4])
* Mengirim perintah lewat IPC: `swaymsg 'workspace 2; exec alacritty'`. ([GitHub][3])
* Debugging runtime: `sway -d 2> ~/sway.log` untuk melihat pesan kesalahan/diagnostik. ([GitHub][3])

##  ⚙️ Konfigurasi Dasar Sway (`man 5 sway`)

**Tujuan:** setiap baris di `~/.config/sway/config` dapat dijelaskan dan dimodifikasi dengan aman.

Sway tidak hanya membaca file `~/.config/sway/configs`. Sway dapat membaca file konfigurasi dari beberapa lokasi, termasuk:

- ##### `~/.config/sway/config`: Ini adalah lokasi default untuk file konfigurasi Sway.
- ##### `~/.sway/config`: Ini adalah lokasi lain yang dapat digunakan untuk file konfigurasi Sway.
- ##### `/etc/sway/config`: Ini adalah lokasi sistem-wide untuk file konfigurasi Sway.
Lokasi lain yang ditentukan oleh variabel lingkungan `SWAY_CONFIG_FILE`. Sway juga dapat membaca file konfigurasi dari direktori `~/.config/sway/configs`, tetapi hanya jika anda menyertakan file konfigurasi tersebut secara manual menggunakan perintah include di file konfigurasi utama (~/.config/sway/config).
##### Contoh:
```Bash
include ~/.config/sway/configs/bar/bar.conf
include ~/.config/sway/configs/bind/bind.conf
```
Sway tidak secara otomatis membaca semua file konfigurasi di direktori `~/.config/sway/configs`. Anda perlu menyertakan file konfigurasi tersebut secara manual menggunakan perintah include.
Jangan khawatir di bagian bawah nantinya akan dijelaskan contoh `~/.config/sway/config` **minimal → production**, disertai penjelasan baris demi baris, untuk sementara kita fokus dari sini dulu.

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
### Perbedaan antara menggunakan ekstensi .conf dan tanpa menggunakannya :
**Konvensi:** Ekstensi `.conf` adalah konvensi umum yang digunakan untuk file konfigurasi pada sistem Unix-like, termasuk Sway. Menggunakan ekstensi `.conf` membuat file konfigurasi lebih mudah dikenali dan dipahami oleh pengguna lain.

**Penggunaan wildcard:** Jika anda menggunakan ekstensi `.conf`, anda dapat menggunakan wildcard (*) untuk menyertakan semua file konfigurasi di direktori tertentu. Contoh: `include ~/.config/sway/configs/*.conf`

**Pengurutan:** Jika anda memiliki beberapa file konfigurasi dengan nama yang sama tetapi ekstensi berbeda, menggunakan ekstensi `.conf` dapat membantu Sway mengurutkan file konfigurasi dengan benar.

**Konsistensi:** Menggunakan ekstensi `.conf` pada semua file konfigurasi membuat struktur konfigurasi lebih konsisten dan mudah dipelihara.
Namun, perlu diingat bahwa Sway tidak memerlukan ekstensi `.conf` secara spesifik. Anda dapat menggunakan ekstensi lain atau tidak menggunakan ekstensi sama sekali. Tetapi, menggunakan ekstensi .conf adalah konvensi yang umum dan disarankan untuk membuat konfigurasi lebih mudah dipahami dan dipelihara. Jadi sebetulnya anda dapat membuatnya seperti ini walaupun tidak recommended:

```
~/.config/sway/
 ├─ config
 └─ config.d/
     ├─ vars
     ├─ keybinds
     ├─ inputs
     └─ outputs
```

## Penomoran pada file seperti:

```
00-vars.conf  
10-keybinds.conf  
20-inputs.conf  
30-outputs.conf
```

punya **makna teknis yang sangat penting** dalam cara **Sway** membaca dan menggabungkan konfigurasi.

---

##  1) Sway membaca file **config.d** secara **berurutan berdasarkan nama file (lexicographical order)**

Ini aturan bawaan dari directive:

```
include /etc/sway/config.d/*
# atau, jika Anda memakai:
include ~/.config/sway/config.d/*
```

Wildcard `*` akan memasukkan file **berdasarkan urutan alfabet**.

Karena komputer mengurutkan string seperti:

```
00 < 10 < 20 < 30 < 99
```

maka konfigurasi Anda akan diproses:

1. **00-vars.conf**
2. **10-keybinds.conf**
3. **20-inputs.conf**
4. **30-outputs.conf**

Urutan ini kritis karena:

* Variabel harus ada **sebelum** keybind dipakai.
* Input harus dikonfigurasi **setelah** variabel dan keybind disiapkan.
* Output (monitor/display) sering diproses terakhir karena menyangkut compositor state.

---

##  2) Maksud setiap penomoran

Mari kita jelaskan satu per satu.

#### **00-vars.conf — tahap awal (initialization layer)**

Berisi variabel global seperti:

* `$mod`
* `$term`
* `$menu`
* `$left`, `$right`, `$up`, `$down`

Mengapa diberi “00”?
Karena variabel ini **wajib tersedia** sebelum digunakan di file lain. Jika ditempatkan di 50 atau 90, maka file 10-keybinds.conf akan error ketika membaca variabel yang belum ada.

**Intinya:** LAYER DASAR — fondasi config.

---

### **10-keybinds.conf — layer navigasi & aksi (bindings layer)**

Berisi:

* bindsym
* keybind-based action
* window manipulation

Kenapa “10”?
Karena keybind sering memakai variabel dari file 00-vars.conf.

Secara logika:

```
00 → definisi variabel
10 → pakai variabel dalam keybind
```

Ini membuat config terstruktur dan bisa diprediksi.

---

### **20-inputs.conf — layer perangkat input (input device layer)**

Berisi:

* keyboard layout
* touchpad options
* natural scroll
* tapping
* repeat rate

Kenapa “20”?
Karena konfigurasi input biasanya harus diproses **setelah** environment dasar siap. Juga agar lebih mudah dipisahkan secara logis:

```
00 — variabel
10 — keybind
20 — input
```

Semuanya rapi seperti modul.

---

### **30-outputs.conf — layer monitor (display/output layer)**

Berisi:

* resolusi monitor
* posisi monitor
* wallpaper
* scale factor (HiDPI)
* mode vertical / horizontal

Kenapa “30”?
Karena output sebaiknya diproses terakhir; compositor menyusun state tampilan setelah semua input/keybind sudah siap.

---

# 3) Kenapa harus pakai penomoran?

Penomoran memberikan:

### 1. **Predictability**

Urutan file *tidak berubah-rubah*, dan tidak tergantung [timestamp atau randomness][b] nama file.

### 2. **Modularisasi**

File besar `~/.config/sway/config` jadi mudah dikelola, karena dipisah berdasarkan kategori.

### 3. **Kemudahan debugging**

Anda tahu letak error:

* error variabel → cek 00
* error keybind → cek 10
* error keyboard/touchpad → cek 20
* error monitor → cek 30

#### 4. **Override behaviour**

File bernomor **lebih besar** dapat menimpa konfigurasi sebelumnya.

Misalnya:

```
20-inputs.conf  → natural_scroll enabled
99-custom.conf  → natural_scroll disabled  (override)
```

---

##  4) Penomoran ini mirip dengan apa?

Ini konsep arsitektur yang sama seperti:

* `/etc/sysctl.d/`
* `/usr/lib/systemd/system.conf.d/`
* `/etc/pacman.d/hooks/`
* `/etc/sudoers.d/`

Di mana file di-load berdasarkan **lexical (alphabetical) order**.

Modular, predictable, and override-friendly.

---

##  5) Kesimpulan jelas dan langsung

Penomoran file seperti:

```
00-vars.conf
10-keybinds.conf
20-inputs.conf
30-outputs.conf
```

adalah cara memberikan **prioritas & urutan eksekusi** pada konfigurasi Sway:

* **00** → definisi awal (variabel)
* **10** → keybind yang pakai variabel
* **20** → konfigurasi input
* **30** → konfigurasi output/monitor

Sway membaca file-file dalam folder config.d sesuai **urutan alfabet**, jadi penomoran membuat struktur menjadi stabil, modular, dan mudah di-debug.

---
<!--
Jika Anda mau, saya bisa buatkan:

1. **Template folder config.d lengkap** untuk Sway versi Anda.
2. **Penjelasan kata-per-kata setiap directive di setiap file.**
3. **Rancangan konfigurasi modular khusus Archlinux + Wayland + Swaybg + Waybar.**

Tinggal beri perintah dan saya susun.-->
# 🔧 Konfigurasi File Utama

Pada saat anda membuka file konfigurasi yang berhasil di pindahkan ke direktori konfigurasi user, anda akan menemukannya sebagai bahasa inggris, berikut terjemahan seluruh isi file `.config` tersebut, baris demi baris sesuai urutan aslinya.

```bash
# Konfigurasi default untuk sway
#
# Salin ini ke ~/.config/sway/config dan sunting sesuai keinginan Anda.
#
# Baca `man 5 sway` untuk referensi lengkap.

### Variables
#
# Tombol logo (modifier). Gunakan Mod1 untuk Alt.
set $mod Mod4
# Tuts arah di baris home, seperti vim
set $left h
set $down j
set $up k
set $right l
# Emulator terminal pilihan Anda
set $term foot
# Peluncur aplikasi pilihan Anda
set $menu wmenu-run

### Output configuration
#
# Wallpaper default (resolusi lain tersedia di /usr/share/backgrounds/sway/)
output * bg /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
#
# Contoh konfigurasi:
#
#   output HDMI-A-1 resolution 1920x1080 position 1920,0
#
# Anda dapat memperoleh nama output dengan menjalankan: swaymsg -t get_outputs

### Idle configuration
#
# Contoh konfigurasi:
#
# exec swayidle -w \
#          timeout 300 'swaylock -f -c 000000' \
#          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
#          before-sleep 'swaylock -f -c 000000'
#
# Ini akan mengunci layar Anda setelah 300 detik tidak aktif, lalu mematikan
# tampilan Anda setelah 300 detik lagi, dan menyalakan kembali layar saat
# dilanjutkan. Juga akan mengunci layar sebelum komputer Anda masuk tidur.

### Input configuration
#
# Contoh konfigurasi:
#
#   input type:touchpad {
#       dwt enabled
#       tap enabled
#       natural_scroll enabled
#       middle_emulation enabled
#   }
#
#   input type:keyboard {
#       xkb_layout "eu"
#   }
#
# Anda juga dapat mengonfigurasi setiap perangkat secara terpisah.
# Baca `man 5 sway-input` untuk informasi lebih lanjut tentang bagian ini.

### Key bindings
#
# Dasar-dasar:
#
    # Mulai sebuah terminal
    bindsym $mod+Return exec $term

    # Tutup jendela yang sedang fokus
    bindsym $mod+Shift+q kill

    # Jalankan peluncur Anda
    bindsym $mod+d exec $menu

    # Seret jendela mengambang dengan menahan $mod dan tombol kiri mouse.
    # Ubah ukuran dengan tombol kanan mouse + $mod.
    # Meskipun namanya, juga bekerja untuk jendela non-mengambang.
    # Ubah normal menjadi inverse untuk menggunakan tombol kiri mouse untuk mengubah ukuran dan kanan
    # tombol mouse untuk menyeret.
    floating_modifier $mod normal

    # Muat ulang file konfigurasi
    bindsym $mod+Shift+c reload

    # Keluar dari sway (akan mengeluarkan Anda dari sesi Wayland)
    bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
#
# Bergerak di sekitar:
#
    # Pindahkan fokus Anda
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # Atau gunakan $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Pindahkan jendela yang fokus dengan cara yang sama, tetapi tambahkan Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # Sama, dengan tombol panah
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
#
# Workspace:
#
    # Beralih ke workspace
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10
    # Pindahkan container yang sedang fokus ke workspace
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10
    # Catatan: workspaces dapat memiliki nama apa pun yang Anda inginkan, tidak hanya angka.
    # Kita hanya menggunakan 1-10 sebagai default.
#
# Pengaturan tata letak:
#
    # Anda dapat "membagi" objek fokus Anda dengan
    # $mod+b atau $mod+v, untuk pembagian horizontal dan vertikal
    # masing-masing.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Ubah kontainer saat ini antara gaya tata letak yang berbeda
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Jadikan fokus saat ini layar penuh
    bindsym $mod+f fullscreen

    # Alihkan fokus saat ini antara tiling dan floating mode
    bindsym $mod+Shift+space floating toggle

    # Tukar fokus antara area tiling dan area floating
    bindsym $mod+space focus mode_toggle

    # Pindahkan fokus ke kontainer induk
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway memiliki "scratchpad", yang merupakan tempat penyimpanan sementara untuk jendela.
    # Anda dapat mengirim jendela ke sana dan mengambilnya kembali nanti.

    # Pindahkan jendela yang sedang fokus ke scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Tampilkan jendela scratchpad berikutnya atau sembunyikan jendela scratchpad yang fokus.
    # Jika ada beberapa jendela scratchpad, perintah ini akan menggilirnya.
    bindsym $mod+minus scratchpad show
#
# Mengubah ukuran kontainer:
#
mode "resize" {
    # left akan mengecilkan lebar kontainer
    # right akan memperbesar lebar kontainer
    # up akan mengecilkan tinggi kontainer
    # down akan memperbesar tinggi kontainer
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    # Sama, dengan tombol panah
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px

    # Kembali ke mode default
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"
#
# Utilitas:
#
    # Tombol khusus untuk menyesuaikan volume lewat PulseAudio
    bindsym --locked XF86AudioMute exec pactl set-sink-mute \@DEFAULT_SINK@ toggle
    bindsym --locked XF86AudioLowerVolume exec pactl set-sink-volume \@DEFAULT_SINK@ -5%
    bindsym --locked XF86AudioRaiseVolume exec pactl set-sink-volume \@DEFAULT_SINK@ +5%
    bindsym --locked XF86AudioMicMute exec pactl set-source-mute \@DEFAULT_SOURCE@ toggle
    # Tombol khusus untuk menyesuaikan kecerahan lewat brightnessctl
    bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
    bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
    # Tombol khusus untuk mengambil tangkapan layar dengan grim
    bindsym Print exec grim

#
# Status Bar:
#
# Baca `man 5 sway-bar` untuk informasi lebih lanjut tentang bagian ini.
bar {
    position top

    # Ketika status_command mencetak baris baru ke stdout, swaybar diperbarui.
    # Default-nya hanya menampilkan tanggal dan waktu saat ini.
    status_command while date +'%Y-%m-%d %X'; do sleep 1; done

    colors {
        statusline #ffffff
        background #323232
        inactive_workspace #32323200 #32323200 #5c5c5c
    }
}

include /etc/sway/config.d/*
```
<!--
Saya menerjemahkan semua baris komentar (`# ...`) secara lengkap sesuai urutan file tanpa mengurangi baris lain. Jika Anda ingin versi file yang benar-benar menggantikan komentar di file asli (mis. untuk disimpan langsung sebagai file konfigurasi), saya bisa:

* Menyediakan file terjemahan sebagai teks yang dapat Anda salin-tempel, atau
* Menyimpan terjemahan ke `/mnt/data/config_id.txt` dan memberikan tautan unduhan.

Pilih salah satu jika Anda ingin saya simpan atau keluarkan sebagai file.

Bagus — saya sudah menampilkan seluruh isi `config.bak` Anda. Sekarang saya akan:

1. Menerjemahkan setiap komentar (baris yang diawali `#`) ke Bahasa Indonesia.
2. Menjelaskan maksud setiap komentar dan baris konfigurasi yang relevan (kata-per-kata pada bagian perintah / variabel penting).
3. Menambahkan catatan teknis (bahasa/pustaka yang membangun Sway, apa yang perlu dipersiapkan untuk memodifikasi, dan cara bantuan/diagnosa CLI terkait).

Semua penjelasan berikut disajikan dalam Bahasa Indonesia profesional dan fokus ke inti — langsung ke tiap komentar / baris konfigurasi yang ada di file yang Anda berikan.

---

# 1) Komentar & terjemahan (urut sesuai berkas)

> **Baris**: `# Default config for sway`
> **Terjemahan**: Konfigurasi default untuk sway
> **Penjelasan**: Ini menyatakan bahwa file ini adalah contoh konfigurasi bawaan (default) untuk *sway* — yaitu template awal yang bisa Anda salin dan modifikasi.

---

> **Baris**: `#`
> **Terjemahan**: (baris kosong / pemisah)
> **Penjelasan**: Hanya pemisah visual; tidak berpengaruh ke konfigurasi.

---

> **Baris**: `# Copy this to ~/.config/sway/config and edit it to your liking.`
> **Terjemahan**: Salin ini ke `~/.config/sway/config` dan sunting sesuai keinginan Anda.
> **Penjelasan**: Petunjuk praktis — letakkan file konfigurasi sway Anda di `~/.config/sway/config`. Sway akan mencari file konfigurasi di sana ketika memulai sesi pengguna.

---

> **Baris**: `#`
> **Terjemahan**: (pemisah)

---

> **Baris**: ``# Read `man 5 sway` for a complete reference.``
> **Terjemahan**: Baca `man 5 sway` untuk referensi lengkap.
> **Penjelasan**: Menyarankan manual page (section 5: file format) untuk dokumentasi lengkap mengenai sintaks konfigurasi sway. Perintah `man 5 sway` akan menampilkan dokumentasi format konfigurasi.

---

> **Baris**: `### Variables`
> **Terjemahan**: ### Variabel
> **Penjelasan**: Header organiasi di file; bagian berikutnya akan mendefinisikan variabel-variabel yang dipakai berulang (mis. `$mod`, arah tombol dsb).

---

> **Baris**: `#`
> **Terjemahan**: (pemisah)

---

> **Baris**: `# Logo key. Use Mod1 for Alt.`
> **Terjemahan**: Kunci logo (tombol logo). Gunakan `Mod1` untuk Alt.
> **Penjelasan**: Menjelaskan variabel `$mod` (modifier: tombol yang dipakai untuk shortcut). `Mod4` biasanya adalah tombol Super/Windows, `Mod1` mewakili Alt. Ini memberitahukan bahwa jika Anda ingin Alt sebagai modifier, gunakan `Mod1`.

---

> **Baris**: `# Home row direction keys, like vim`
> **Terjemahan**: Tuts arah pada baris home, seperti vim
> **Penjelasan**: Bagian ini menjelaskan bahwa konfigurasi memilih tombol `h,j,k,l` (baris home pada layout QWERTY) untuk navigasi jendela—mirip standar arah pada editor vim.

---

> **Baris**: `# Your preferred terminal emulator`
> **Terjemahan**: Emulator terminal pilihan Anda
> **Penjelasan**: Menandakan variabel yang akan menyimpan nama terminal yang ingin dipanggil lewat shortcut (misalnya `alacritty`, `kitty`, `foot`, `xterm`, dsb).

---

> **Baris di blok swaybar**:
> `# When the status_command prints a new line to stdout, swaybar updates.`
> **Terjemahan**: Ketika `status_command` mencetak baris baru ke stdout, swaybar akan diperbarui.
> **Penjelasan**: `swaybar` menunggu output dari `status_command`. Setiap kali program tersebut mengeluarkan baris baru, `swaybar` mem-parse dan menampilkan informasi (mis. jam, status baterai, dsb).

---

> **Baris di blok swaybar**:
> `# The default just shows the current date and time.`
> **Terjemahan**: Default-nya hanya menampilkan tanggal dan waktu saat ini.
> **Penjelasan**: Menjelaskan implementasi default `status_command` di file ini — script kecil yang mencetak tanggal & waktu setiap detik.

---

> **Baris paling akhir**: `include /etc/sway/config.d/*`
> **(bukan komentar; tapi penting)**
> **Penjelasan**: Perintah `include` akan memuat semua file yang cocok di direktori `/etc/sway/config.d/`. Ini memungkinkan konfigurasi sistem-wide atau drop-in snippets (mis. dari paket distro) untuk ikut dimuat.

---

-->
# Penjelasan baris konfigurasi penting

---

## `set $mod Mod4`

* `set` — perintah konfigurasi di file sway untuk membuat variabel.
* `$mod` — nama variabel (konvensi: nama variabel diawali `$`). Anda bisa memakai `$mod` nanti di baris keybind, mis. `bindsym $mod+Return exec ...`.
* `Mod4` — nilai yang diberikan; *Mod4* biasanya mewakili tombol "Super" (logo Windows). Alternatif: `Mod1` = Alt, `Mod3` dsb tergantung map keymap.

**Ringkas:** `set $mod Mod4` menyetel `$mod` sebagai tombol Super/WINDOWS.

---

## `set $left h` / `set $down j` / `set $up k` / `set $right l`

* `set` — sama seperti di atas.
* `$left`/`$down`/`$up`/`$right` — variabel yang menyimpan nama tombol.
* nilai `h`, `j`, `k`, `l` — karakter keyboard (home row) meniru navigasi vim.

**Fungsi praktis:** nanti di config biasanya ada keybind seperti `bindsym $mod+$left focus left` — yang berarti `Super+h` untuk fokus jendela sebelah kiri.

---

## `status_command while date +'%Y-%m-%d %X'; do sleep 1; done`

* `status_command` — pengaturan untuk `bar`/`swaybar` yang menetapkan program atau perintah yang dijalankan untuk menghasilkan status JSON/teks.
* `while date +'%Y-%m-%d %X'; do sleep 1; done` — sebuah loop shell sederhana:

  * `while ...; do ...; done` — bentuk loop shell `while` yang terus berjalan.
  * `date +'%Y-%m-%d %X'` — memanggil utilitas `date` untuk mencetak tanggal dan waktu dengan format `YYYY-MM-DD HH:MM:SS`.
  * `sleep 1` — jeda 1 detik antara iterasi.
* Ketika loop ini mencetak baris baru, swaybar akan mengambil/memperbarui tampilannya. Dalam konfigurasi produksi biasanya `status_command` meng-output JSON khusus (i3bar protocol) atau menggunakan utilitas seperti `waybar`, `swaybar` dengan `i3status`, `polybar` (polybar but not native wayland) atau script custom.

**Note:** contoh di file adalah contoh minimal; seringnya orang memakai `swaystatus`, `i3status`, `waybar` atau script berbasis `jq`.

---

## `colors { statusline #ffffff background #323232 inactive_workspace #32323200 #32323200 #5c5c5c }`

* `colors { ... }` — blok konfigurasi untuk warna pada `bar` (swaybar).
* `statusline #ffffff` — warna teks utama (putih).
* `background #323232` — warna latar (abu gelap).
* `inactive_workspace #32323200 #32323200 #5c5c5c` — beberapa argumen yang mewakili warna untuk workspace yang tidak aktif (format tergantung versi sway bar).

  * `#32323200` kemungkinan termasuk nilai alpha/hex (transparansi) tergantung implementasi.

**Catatan:** warna biasanya dalam format hex `#RRGGBB` atau `#RRGGBBAA` (jika alpha). Jika Anda memodifikasi, pastikan format sesuai versi sway Anda.

---

###  3) Cara mendapatkan bantuan dan dokumentasi (CLI & man pages)

* `man 5 sway` — dokumentasi format file konfigurasi. (Baca dengan `man 5 sway`.)

  * **Penjelasan kata-per-kata:** `man` = manual reader, `5` = section (file formats), `sway` = topik.
* `man sway` atau `man 1 sway` — manual program sway (bagian 1: executable).
* `sway --help` — opsi baris perintah singkat.
* `swaymsg` — utilitas IPC untuk mengirim perintah ke sway yang sedang berjalan; `swaymsg -t get_outputs` mis.
* `sway -c /path/to/config` — memulai sway dengan file konfigurasi yang ditentukan (berguna untuk testing konfigurasi non-default).

  * **Penting:** `sway` akan memulai session Wayland; jangan jalankan dari TTY/seat yang sedang aktif tanpa persiapan — lihat catatan uji di bagian 4.

---

###  4) Catatan: bahasa, arsitektur, dan apa yang perlu Anda siapkan untuk memodifikasi Sway atau komponennya

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

---

###  5) Cara menguji perubahan konfigurasi tanpa mengganggu sesi yang sedang dipakai (ringkasan cepat & aman)

* **Metode 1: Jalankan sway di TTY terpisah (recommended untuk pengujian)**

  * Buat user lain atau gunakan TTY kosong (Ctrl+Alt+F3) dari login text mode. Login di TTY itu dan jalankan `sway` di sana dengan `sway -c /path/to/test-config`. Tidak mengganggu sesi grafis utama.
* **Metode 2: Gunakan `sway -c` untuk start terpisah** — seperti di atas, jangan jalankan pada TTY yang sama dengan sesi grafis utama.
* **Metode 3: `swaymsg` & `swaymsg reload`** — dapat memuat ulang konfigurasi pada sesi berjalan, tetapi jika ada error syntax atau kesalahan binding fatal, Anda bisa terkunci. Selalu backup config sebelum reload.
* **Metode 4: Gunakan virtual machine/container dengan Wayland nested** — lebih aman untuk eksperimen radikal.

---

###  6) Contoh praktis penjelasan perintah kunci (kata-per-kata, sesuai permintaan Anda)

#### Contoh baris: `bindsym $mod+Return exec $terminal`

* `bindsym` — perintah untuk membuat key binding; memonitor *symbolic* key names (bukan keycodes).
* `$mod` — variabel modifier yang sebelumnya diset (`Mod4` kalau default).
* `+` — operator penggabung kombinasikan modifier dan tombol.
* `Return` — nama tombol (Enter).
* `exec` — jalankan perintah eksternal.
* `$terminal` — variabel yang menyimpan nama emulator terminal (mis. `alacritty` atau `kitty`).
  **Arti lengkap:** ketika pengguna menekan `Super+Enter`, jalankan terminal yang didefinisikan.

---

###  7) Rekomendasi & sumber belajar (ringkas)

* Baca dokumentasi resmi: `man 5 sway` dan `man sway`.
* Sumber online: repository GitHub Sway (`swaywm/sway`) dan `wlroots` untuk pemahaman lebih dalam. (Untuk link spesifik, beri tahu jika mau saya carikan dan berikan daftar link.)
* Untuk membangun dari sumber: pelajari `meson`/`ninja`, pasang dependensi development, dan baca `CONTRIBUTING.md` di repo Sway.

---

###   8) Ringkasan apa yang sudah saya lakukan untuk Anda

* Menampilkan isi `config.bak` (sudah saya lakukan lewat eksekusi Python yang Anda lihat).
* Menerjemahkan semua komentar yang ada di file (semua baris komentar yang terlihat).
* Menjelaskan maksud tiap komentar, arti token kunci pada bagian konfigurasi, serta bagaimana cara menguji dan memodifikasi dengan aman.
* Menambahkan informasi teknis: bahasa implementasi Sway (C), pustaka utama (wlroots/C), dan requirement pengembangan.

---
<!--
Jika Anda mau, saya bisa langsung melanjutkan ke salah satu dari hal berikut **tanpa menunggu** (pilih salah satu dan saya akan kerjakan sekarang):

* A. Menyediakan **penjelasan baris-per-baris** untuk *seluruh* file (setiap baris konfigurasi non-komentar) — akan menjelaskan fungsi tiap baris konfigurasi secara terperinci.
* B. Membuat **salinan konfigurasi yang dimodifikasi** (contoh: ganti `$mod` ke `Mod1`, set terminal Anda, tambahkan binding spesifik) lalu menyimpan sebagai `~/.config/sway/config.test` dan memberikan instruksi uji aman.
* C. Menjelaskan langkah membangun Sway dari sumber (perintah `meson`/`ninja`) lengkap dengan daftar paket *devel* untuk Archlinux (karena Anda menggunakan Arch/WM Sway) — termasuk perintah instalasi paket yang dibutuhkan.
* D. Menelusuri baris `...` dalam file (apakah itu placeholder literal atau file terpotong) dan menampilkan bagian yang mungkin terpotong — jika Anda ingin saya mengurai baris selanjutnya saya bisa tampilkan juga.

Pilih A/B/C/D (atau katakan jika mau semua) — saya lakukan sekarang juga sesuai pilihan Anda.-->

##  Sumber resmi & bacaan lanjutan (direkomendasikan)

* Situs resmi Sway: swaywm.org — gambaran umum dan link dokumentasi. ([swaywm.org][1])
* Repositori GitHub Sway: `swaywm/sway` — README, wiki, issue tracker (bagus untuk contoh bug/patch). ([GitHub][3])
* wlroots: `swaywm/wlroots` — dokumentasi teknis dan contoh API. ([GitHub][2])
* ArchWiki Sway — panduan instalasi, konfigurasi, dan tips distribusi. ([wiki.archlinux.org][4])
* Wikipedia (ringkasan & sejarah singkat) — untuk konteks rilis dan penulis utama. ([Wikipedia][5])

##  Rekomendasi langkah Anda berikutnya (direktif praktis)

1. Jika Anda ingin **memodifikasi** Sway: mulailah dengan mempelajari C dan konsep Wayland, lalu clone wlroots + sway, setup Meson/Ninja, dan jalankan build lokal. Ikuti issue/PR di GitHub untuk melihat pola kontribusi. ([GitHub][2])
2. Jika Anda ingin **mengembangkan plugin/fitur cepat**: gunakan `swaymsg`/IPC dan buat skrip (bash/Python/Lua/Rust) yang berinteraksi dengan Sway — ini sesuai dengan minat Anda pada TUI/CLI dan integrasi Neovim. ([GitHub][3])
3. Bila butuh panduan langkah-demi-langkah (mis. buat environment build di Archlinux, contoh modifikasi sederhana, atau template config i3→sway yang rapi), saya siapkan panduan terperinci beserta snippet konfigurasi dan perintah build.

---

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
🔧🧭🪄🧰🧩🤖🔁




Tautan wlroots untuk github
https://github.com/swaywm/wlroots?utm_source=chatgpt.com 
-->

[0]: https://github.com/swaywm/sway/wiki
[1]: https://swaywm.org/?utm_source=chatgpt.com "Sway"
[2]: https://gitlab.freedesktop.org/wlroots/wlroots "swaywm/wlroots: A modular Wayland compositor library"
[3]: https://github.com/swaywm/sway?utm_source=chatgpt.com "swaywm/sway: i3-compatible Wayland compositor"
[4]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[5]: https://en.wikipedia.org/wiki/Sway_%28window_manager%29?utm_source=chatgpt.com "Sway (window manager)"
[6]: https://bvngee.com/blogs/compile-sway-and-wlroots-together-from-source?utm_source=chatgpt.com "Compiling Sway with wlroots from Source - Bvngee"
[7]: https://github.com/swaywm/sway/issues/4802?utm_source=chatgpt.com "Sway is laggy/unresponsive on VirtualBox Arch guest #4802"
<!---------------------->
<!--wlroots-->
[a]: ./../../module/bagian-1/README.md
[b]: ./bagian-1/README.md
