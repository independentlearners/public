# 🧰 Ringkasan singkat SwayWM

Sway adalah **tiling Wayland compositor** yang dirancang sebagai pengganti drop-in untuk i3 (X11). Dikembangkan untuk bekerja di atas library **wlroots**, Sway menyediakan pengalaman manajemen jendela bertipe tiling dengan kompatibilitas konfigurasi i3, dukungan XWayland, IPC berbasis JSON, dan ekosistem utilitas (swaybar, swaylock, swayidle, dsb.). ([swaywm.org][1])

## 🧩 Arsitektur dan komponen utama

* **[wlroots][a]** — library modular yang mengabstraksi DRM/KMS, EGL, libinput, XWayland, rendering, dan backend lain; wlroots menjadi fondasi teknis Sway untuk akses perangkat dan rendering. ([GitLab][2])
    - > Sumber tautan untuk GitHub di komentari karena proyek telah di arsipkan.
* **Sway (kompositor)** — program utama (C) yang mengimplementasikan manajemen tata letak tiling, binding keyboard, pengaturan output dan input, serta mengeksekusi konfigurasi pengguna. Sway ditulis dalam **bahasa C**. ([GitHub][3])
* **Utilitas pendukung** — `swaybar` (status bar), `swaylock` (lock screen), `swayidle` (idle management), `swaymsg` (CLI untuk IPC), dan daemon lain yang biasa disertakan di distribusi. ([GitHub][3])
* **XWayland** — lapisan kompatibilitas untuk menjalankan aplikasi X11 di dalam sesi Wayland ketika diperlukan. wlroots/Sway mengelolanya bila dipasang. ([GitHub][2])

## 🪄 Fitur penting (apa yang membuat Sway menarik)

* Kompatibilitas konfigurasi i3: banyak konfigurasi i3 bisa langsung dipakai (salin `~/.config/i3/config` → `~/.config/sway/config`). ([wiki.archlinux.org][4])
* IPC JSON melalui Unix socket: alat eksternal dapat mengontrol Sway dengan `swaymsg` atau library yang membaca/menulis JSON. Ini membuka kemungkinan integrasi dengan skrip (bash, Python, Lua, Rust, dll.). ([GitHub][3])
* Tiling otomatis, layout fleksibel, multiple outputs, per-output config, dan binding keyboard/mouse yang kuat. ([swaywm.org][1])

## 🔁 Keterbatasan dan hal yang perlu diperhatikan

* Karena berbasis Wayland, beberapa aplikasi X11 lama memerlukan XWayland—tidak semua perilaku X11 menjadi 1:1 identik. ([GitHub][2])
* Pengalaman hardware-accelerated bergantung pada driver GPU, kernel, dan konfigurasi DRM/EGL; pengujian pada mesin nyata lebih representatif daripada VM kecuali VM memiliki passthrough GPU yang baik. ([GitHub][7])
* Ketergantungan ke wlroots berarti banyak keputusan arsitektural ditetapkan di layer tersebut; kontribusi fitur yang menyentuh rendering/input biasanya harus sinkron dengan desain wlroots. ([GitHub][2])

##  ⚙️ Konfigurasi Dasar Sway

* Lokasi konfigurasi umum: `~/.config/sway/config` (salin contoh dari `/etc/sway/config`). Banyak direktif mirip i3: `bindsym`, `workspace`, `output`, `input`, `exec`, dll. Setiap baris di `~/.config/sway/config` dapat dijelaskan dan dimodifikasi dengan aman.([wiki.archlinux.org][4])
* Mode binding, per-output rules, floating windows, sway-specific blocks (status bar) dan per-app rules tersedia.
* Jalankan `sway` dari TTY; gunakan `sway -d` untuk debug/log; IPC socket biasanya tersedia via variabel lingkungan `SWAYSOCK` atau di path standar. ([GitHub][3])

Sway tidak hanya membaca file `~/.config/sway/configs`. Sway dapat membaca file konfigurasi dari beberapa lokasi, termasuk:

- ##### `~/.config/sway/config`: Ini adalah lokasi default untuk file konfigurasi Sway.
- ##### `~/.sway/config`: Ini adalah lokasi lain yang dapat digunakan untuk file konfigurasi Sway.
- ##### `/etc/sway/config`: Ini adalah lokasi sistem-wide untuk file konfigurasi Sway.
Lokasi lain yang ditentukan oleh variabel lingkungan `SWAY_CONFIG_FILE`. Sway juga dapat membaca file konfigurasi dari direktori modular seperti `~/.config/sway/configs`, tetapi hanya jika anda menyertakan file konfigurasi tersebut secara manual menggunakan perintah include di file konfigurasi utama (`~/.config/sway/config`).

##### Contoh:
```Bash
# Memasukkan konfigurasi bar
include ~/.config/sway/configs/bar/bar.conf
# Memasukkan konfigurasi binding
include ~/.config/sway/configs/bind/bind.conf
```
`SWAY_CONFIG_FILE` adalah variabel lingkungan yang digunakan oleh Sway untuk menentukan lokasi file konfigurasi Sway. Secara default, Sway mencari file konfigurasi di beberapa lokasi, termasuk:

```bash
/etc/sway/config
~/.config/sway/config
/usr/share/sway/config.d/*.conf
/etc/sway/config.d/*.conf
~/.config/sway/config.d/*.conf
```
Dengan mengatur variabel SWAY_CONFIG_FILE, Anda dapat menentukan lokasi file konfigurasi Sway yang berbeda dari lokasi default. Contohnya, jika Anda ingin menggunakan file konfigurasi yang berbeda dari umumnya dimana anda ingin menentukan sendiri, Anda dapat menjalankan perintah berikut:
```Bash
SWAY_CONFIG_FILE=~/konfigurasi-sway sway
```
Perintah ini akan menjalankan Sway dengan file konfigurasi yang terletak di `~/konfigurasi-sway`.

Jadi Sway tidak secara otomatis membaca semua file konfigurasi di direktori `~/.config/sway/configs`. Anda perlu menyertakan file konfigurasi tersebut secara manual menggunakan perintah include.
Jangan khawatir di bagian bawah nantinya akan dijelaskan contoh `~/.config/sway/config` **minimal → production**, disertai penjelasan baris demi baris, untuk sementara kita fokus dari sini dulu.

## 🤖 Struktur minimal & modular recommended

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

## Sway membaca file dari direktif **config.d/** secara berurutan berdasarkan nama file (lexicographical order)

Aturan bawaan dari directive:

```
# Konfigurasi bawaan sistem yang meng-overriade semua konfigurasi yang anda buat
include /etc/sway/config.d/*
# Konfigurasi milik anda
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

## Kenapa harus pakai penomoran?

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

#### Penomoran ini mirip dengan konsep arsitektur yang sama seperti:

* `/etc/sysctl.d/`
* `/usr/lib/systemd/system.conf.d/`
* `/etc/pacman.d/hooks/`
* `/etc/sudoers.d/`

Di mana file di-load berdasarkan **lexical (alphabetical) order**.

Modular, predictable, and override-friendly.

---

## Kesimpulan jelas dan langsung

Penomoran file seperti:

```
00-vars.conf
10-keybinds.conf
20-inputs.conf
30-outputs.conf
```

Adalah cara memberikan **prioritas & urutan eksekusi** pada konfigurasi Sway:

* **00** → definisi awal (variabel)
* **10** → keybind yang pakai variabel
* **20** → konfigurasi input
* **30** → konfigurasi output/monitor

Sway membaca file-file dalam folder config.d sesuai **urutan alfabet**, jadi penomoran membuat struktur menjadi stabil, modular, dan mudah di-debug.

---

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
Sebelum menjalankan sangat penting untuk dipahami bahwa komentar hanya berlaku di awal baris, jadi anda tidak diperbolehkan untuk menulis komentar setelah baris kode meskipun dalam tutorial disini kita mungkin mengabaikan itu tetapi pada kenyataannya tidak. Contoh:
```bash
# Letakan komentar disini 
set $mod Mod4 # Bukan disini
```
---

# 📁 Dasar-Dasar File Konfigurasi

#### Filosofi Variabel dalam Sway

Bayangkan variabel sebagai **"nama panggilan"** atau **"placeholder"** untuk sebuah nilai. Tujuannya adalah:

1.  **Daya Rawat (Maintainability):** Jika suatu nilai (seperti aplikasi terminal) digunakan di 10 tempat berbeda dan Anda ingin menggantinya, Anda hanya perlu mengubahnya di **satu tempat** (di definisi variabel).
2.  **Keterbacaan (Readability):** `exec $term` jauh lebih mudah dipahami daripada `exec alacritty --some-flag --another-flag`.
3.  **Konsistensi:** Memastikan nilai yang sama digunakan di seluruh konfigurasi.

---

## Anatomi Variabel dan deklarasinya

Konfigurasi Sway menggunakan bahasa *scripting* `bash`-like untuk bagian variabel dan ekspansinya. Sintaks dasarnya sangat sederhana, cukup gunakan perintah `set` dan berikan nilainya.

```
set $nama_variabel nilai
```

- `set`: Kata kunci untuk menetapkan nilai.
- `$nama_variabel`: Nama variabel, selalu diawali dengan tanda `$`.
- `nilai`: Nilai yang ingin Anda simpan. Bisa berupa satu kata atau string yang lebih panjang.

### Penjelasan mendetail

Contoh:

```text
set $mod Mod4
set $term foot
set $wallpaper /home/poweruser/Pictures/wall.png

bindsym $mod+Return exec $term
output * bg $wallpaper fill
```

1. `set`

   * Kata kunci Sway untuk **mendefinisikan variabel** konfigurasi. Saat Sway mem-parse, `set` menyimpan mapping nama→nilai.

2. `$mod` (di `set $mod Mod4`)

   * `$` menandakan **nama variabel** (konvensi). `mod` adalah nama variabel (bisa anda ganti).
   * Dalam `set $mod Mod4`: arti keseluruhan — buat variabel bernama `mod` yang nilainya `Mod4`.

3. `Mod4`

   * Nilai string — di sini menunjuk ke tombol modifier (biasanya tombol “Super/Windows”).

4. `bindsym $mod+Return exec $term`

   * `bindsym` = perintah Sway untuk mendaftarkan binding key.
   * `$mod+Return` = gabungan nilai variabel `$mod` (nilai `Mod4`) dan tombol `Return` (Enter). Saat dibaca, Sway melihat `Mod4+Return`.
   * `exec` = perintah Sway untuk menjalankan program eksternal.
   * `$term` = variabel yang kita definisikan (`foot`), jadi ini menjalankan `foot`.

5. `output * bg $wallpaper fill`

   * `output` = perintah konfigurasi untuk display. `*` berarti semua output.
   * `bg` = sub-perintah untuk background/ wallpaper.
   * `$wallpaper` = variabel yang berisi path gambar.
   * `fill` = mode pengisian (stretch/center/fill/scale/tile tergantung opsi).

> Catatan penting: nilai variabel adalah **substitusi literal** pada saat parsing. Jika anda menulis `set $wallpaper ~/wall.png`, perilaku `~` bisa membingungkan karena `~` adalah ekspansi shell — lebih aman memakai path absolut (`/home/username/...`) atau `$HOME` dalam konteks yang tepat. Banyak contoh di dokumentasi memakai `~/…` tapi bila gagal, gunakan path absolut. ([ArchWiki][2])

# Batasan & perilaku penting

1. **Variabel untuk config ≠ environment variables.**

   * `set $foo bar` hanya mengganti teks di config; program lain (waybar, aplikasi) **tidak** akan melihat `$foo` sebagai env var. Untuk env var, atur sebelum Sway dijalankan (login manager, wrapper script, systemd environment.d, PAM, dsb.). ([GitHub][3])

2. **Waktu penggantian (parse time) & order/include matters.**

   * Substitusi variabel terjadi saat parsing konfigurasi — urutan file `include` dan posisi `set` menentukan apakah variabel tersedia pada titik digunakan. Di i3 (dan kompatibel dengan Sway), ada batasan: variabel yang didefinisikan **di file yang di-include setelah** tidak bisa digunakan oleh file induk karena ekspansi terjadi sebelum include. Jadi tempatkan semua `set` di bagian atas (atau file yang di-include lebih dulu). Inilah mengapa penjelasan diatas merekomendasikan pelelatakan file khusus variabel sebagai 00-var.conf ([i3][4]).

3. **Variabel umumnya tidak dapat diubah dinamis dari dalam sesi Sway.**

   * Percobaan mengganti variabel lewat `bindsym`/mode seringkali tidak berhasil karena parsing/substitusi bukan operasi runtime. Jika anda butuh perilaku dinamis, gunakan mekanisme lain (mis. mode, skrip yang mengubah file config lalu trigger reload, atau IPC). (banyak diskusi/issue terkait topik ini). ([GitHub][5])

---

### Poin-poin Kunci yang Harus Dipahami

- **`$mod` adalah Jantung Konfigurasi:** Hampir semua keybinding Anda akan melibatkan `$mod`. Variabel ini menentukan "kunci pemimpin" untuk semua pintasan Anda.
- **Refresh Config Setelah Perubahan:** Setelah mengubah config, selalu ingat untuk melakukan:
  - `$mod+Shift+c`: Merefresh konfigurasi (membaca ulang file config).
  - `$mod+Shift+r`: Restart Sway (jika refresh tidak cukup, misalnya setelah perubahan output).
- **Variabel vs. Langsung:** Mana yang lebih baik, `exec $browser` atau `exec firefox`? Jawabannya hampir selalu `exec $browser` karena kekuatan dan kejelasannya.

---

## **Contoh-contoh Praktis:**

```bash
# Variabel Utama (Biasanya ditaruh di bagian paling atas config)
set $mod Mod4 # Mod4 biasanya adalah Super/Windows key
set $term kitty
set $browser firefox
set $file_manager thunar
set $menu bemenu-run -i -p "Run:" --fn "Hack 12"

# Variabel untuk Path (Jalur)
set $wallpaper_path ~/Pictures/Wallpapers/mountain.jpg

# Variabel untuk Binding yang Sering Digunakan
set $left h
set $down j
set $up k
set $right l
```

#### 2. Menggunakan (Memanggil) Variabel

Setelah dideklarasikan, Anda memanggil variabel tersebut dengan menuliskan `$nama_variabel`. Sway akan secara otomatis menggantinya dengan nilai yang Anda tetapkan.

**Contoh Penggunaan dalam Konteks:**

```bash
# Deklarasi
set $mod Mod4
set $term alacritty
set $left h

# Penggunaan dalam `bindsym` (Binding Simbol)
# bindsym <key-combo> <action>
bindsym $mod+Return exec $term # Buka terminal
bindsym $mod+$left focus left   # Pindah fokus ke jendela di kiri

# Penggunaan dalam `exec` (Menjalankan Perintah)
exec_always $browser  # Jalankan browser saat Sway start

# Penggunaan di perintah yang lebih kompleks
bindsym $mod+d exec $menu
```

---

Dengan menguasai variabel, Anda sudah memegang kunci untuk membuat konfigurasi Sway yang terstruktur, mudah dirawat, dan disesuaikan dengan kebutuhan pribadi. Ini adalah langkah pertama yang fundamental.

## Sumber resmi & bacaan lanjutan (direkomendasikan)

* Situs resmi Sway: swaywm.org — gambaran umum dan link dokumentasi. ([swaywm.org][1])
* Repositori GitHub Sway: `swaywm/sway` — README, wiki, issue tracker (bagus untuk contoh bug/patch). ([GitHub][3])
* wlroots: `swaywm/wlroots` — dokumentasi teknis dan contoh API. ([GitHub][2])
* ArchWiki Sway — panduan instalasi, konfigurasi, dan tips distribusi. ([wiki.archlinux.org][4])
* Wikipedia (ringkasan & sejarah singkat) — untuk konteks rilis dan penulis utama. ([Wikipedia][5])

[0]: https://github.com/swaywm/sway/wiki
[1]: https://swaywm.org/?utm_source=chatgpt.com "Sway"
[2]: https://gitlab.freedesktop.org/wlroots/wlroots "swaywm/wlroots: A modular Wayland compositor library"
[3]: https://github.com/swaywm/sway?utm_source=chatgpt.com "swaywm/sway: i3-compatible Wayland compositor"
[4]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[5]: https://en.wikipedia.org/wiki/Sway_%28window_manager%29?utm_source=chatgpt.com "Sway (window manager)"
[6]: https://bvngee.com/blogs/compile-sway-and-wlroots-together-from-source?utm_source=chatgpt.com "Compiling Sway with wlroots from Source - Bvngee"
[7]: https://github.com/swaywm/sway/issues/4802?utm_source=chatgpt.com "Sway is laggy/unresponsive on VirtualBox Arch guest #4802"
---

# Keybindings

##  Inti singkat (ringkasan cepat)

* Binding utamanya memakai `bindsym` (mengikat ke *keysym* / nama tombol) atau `bindcode` (mengikat ke *keycode* / nomor hardware). Default dan perilaku layout keyboard memengaruhi `bindsym`. ([man.archlinux.org][1])
* Flag penting: `--to-code`, `--release`, `--no-repeat`, `--inhibited`, dan opsi untuk mengikat ke input device tertentu. ([man.archlinux.org][1])
* Untuk menemukan nama tombol di Wayland: pakai `wev` (pengganti `xev`), `libinput debug-events`, atau `evtest`. ([man.archlinux.org][2])

---

##  1. Konsep & istilah penting

* **bindsym**
  Perintah di config Sway untuk mengikat kombinasi tombol (menggunakan XKB keysyms / nama tombol seperti `Return`, `Mod4`, `XF86AudioRaiseVolume`) ke sebuah perintah Sway atau `exec`. `bindsym` membaca *keysyms* yang bergantung pada layout keyboard kecuali bila memakai `--to-code`. ([man.archlinux.org][1])

* **bindcode**
  Mirip `bindsym` tapi menerima *keycode* (nomor hardware) — tidak bergantung pada layout keyboard. Berguna ketika kamu ingin binding tetap konsisten terlepas dari layout. ([man.archlinux.org][1])

* **$mod dan variabel**
  Di config biasanya ada baris `set $mod Mod4` (atau `Mod1`), lalu gunakan `$mod` dalam binding: `bindsym $mod+Return exec …`. `set` mendefinisikan variabel string yang memudahkan pengaturan ulang satu tempat untuk mengganti perilaku global. ([man.archlinux.org][1])

* **mode**
  Mode seperti `mode "resize" { ... }` membuat kumpulan binding sementara — tekan sebuah binding untuk masuk ke mode, lalu beberapa binding khusus aktif sampai kamu keluar mode. Cocok untuk resize/move modes. ([git.bracken.jp][3])

* **--to-code**
  Menginstruksikan Sway untuk menerjemahkan keysym ke keycode menurut layout pertama yang dikonfigurasi, membantu jika kamu punya multi-layout sehingga bindings tetap bekerja di layout lain. Tidak selalu sempurna (beberapa issue/edge case di proyek). ([GitHub][4])

* **--release**
  Eksekusi perintah saat key combo **dilepas** — berguna bila sebuah program/utility tidak bekerja saat keyboard masih “digrab”. Namun implementasinya ada bug/limitasi (beberapa kombinasi tidak selalu andal). ([man.archlinux.org][1])

---

##  2. Cara menemukan nama / kode tombol (praktik)

1. `wev` — buka jendela wayland kecil, tekan kunci, lihat output: keysyms & keycodes. (setara `xev` di X11). Contoh: `wev` lalu tekan `Print` dan catat. ([man.archlinux.org][2])
2. `libinput debug-events` — output event perangkat; cocok untuk mouse/media keys, dan untuk mengetahui device id. Jalankan `sudo libinput debug-events --verbose`. ([wayland.freedesktop.org][5])
3. `evtest`/`showkey` — untuk level kernel / evdev jika perlu (akses `input` group). ([Stack Overflow][6])

Contoh cepat:

* Jalankan `wev`, tekan tombol angka `1` pada row angka → catat “keysym” (mis. `1`) dan kode yang ditampilkan. Gunakan keysym itu di `bindsym` atau gunakan keycode di `bindcode`.

---

##  3. Contoh konfigurasi keybinding — **penjelasan kata-per-kata**

Berikut contoh block tipikal, lalu saya jelaskan setiap token:

```conf
# 1. menetapkan tombol mod
set $mod Mod4
```

* `set` : perintah Sway untuk mendefinisikan variabel.
* `$mod` : nama variabel yang kamu pilih.
* `Mod4` : nilai string; XKB name untuk tombol “Super/Windows”.
  (artinya: setiap kali kamu menulis `$mod` di config, Sway ganti dengan `Mod4`)

```conf
# 2. membuka terminal dengan mod+Return
bindsym $mod+Return exec alacritty
```

* `bindsym` : perintah untuk membuat key binding berdasarkan *keysym* (XKB name).
* `$mod+Return` : kombinasi tombol; `$mod` = `Mod4`, `Return` = Enter key.
* `exec` : aksi untuk menjalankan program eksternal.
* `alacritty` : perintah yang dijalankan (program terminal).
  (hasil: tekan Super+Enter akan menjalankan `alacritty`)

```conf
# 3. pindah ke workspace 1 menggunakan angka (layout-aware)
bindsym $mod+1 workspace 1
```

* `workspace 1` : perintah internal sway untuk fokus/peralihan ke ruang kerja bernama `1`.
* Jika punya multi-layout, terkadang nomor row tidak cocok → pakai `bindsym --to-code` atau `bindcode` jika perlu. ([GitHub][4])

```conf
# 4. pindahkan container (window) fokus ke workspace 1
bindsym $mod+Shift+1 move container to workspace 1
```

* `Shift` : modifier tambahan.
* `move container to workspace 1` : operasi untuk memindahkan window yang sedang fokus ke workspace bernama `1`.

```conf
# 5. resize mode contoh (mode + escape to exit)
mode "resize" {
    bindsym h resize shrink width 10px
    bindsym l resize grow  width 10px
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"
```

* `mode "resize" { ... }` : definisi mode bernama `resize`. Semua `bindsym` di dalamnya hanya berlaku ketika sedang dalam mode ini.
* `bindsym h resize shrink width 10px` : saat tekan `h`, jalankan perintah `resize shrink width 10px`.

  * `resize shrink width 10px` : perintah internal sway untuk mengecilkan lebar container sebesar 10px.
* `bindsym Return mode "default"` : tekan Return untuk kembali ke mode `default`.
* `bindsym $mod+r mode "resize"` : kombinasi mod+r masuk ke mode `resize`.

```conf
# 6. contoh menggunakan --release (eksekusi saat dilepas)
bindsym --release $mod+q exec swaymsg exit
```

* `--release` : jalankan perintah ketika tombol dilepas, bukan saat ditekan. Berguna untuk perintah yang tidak jalan saat keyboard “digrab”. Tapi catat: ada edge cases/bug pada beberapa versi. ([GitHub][7])

```conf
# 7. contoh bindcode (keycode fixed)
bindcode 133 exec dmenu_run
```

* `bindcode` : mengikat berdasarkan nomor keycode (133 contoh) — tidak tergantung layout keyboard.
* `dmenu_run` : program peluncur (contoh).

---

##  4. Opsi & flags penting — arti teknis singkat

* `--to-code` : paksa Sway terjemahkan keysym → keycode sesuai layout pertama; membantu konsistensi saat multi-layout. (Gunakan di binding sensitif seperti workspace switching). ([GitHub][4])
* `--release` : eksekusi saat pelepasan tombol. Hati-hati, beberapa kombinasi bermasalah. ([man.archlinux.org][1])
* `--no-repeat` : mencegah perintah diulang saat tombol ditahan. (berguna untuk aksi tunggal) ([man.archlinux.org][1])
* `--inhibited` : jalankan meskipun ada shortcut inhibitor (mis. virtual machine/remote desktop ingin menangkap shortcut). ([manpages.debian.org][8])
* `input <device>` di binding: batasi binding pada input device tertentu (mis. hanya keyboard built-in). Gunakan `swaymsg -t get_inputs` untuk daftar perangkat. ([manpages.ubuntu.com][9])

---

##  5. Debug & troubleshooting (praktis)

* Reload config: tekan `$mod+Shift+c` (default) atau jalankan `swaymsg reload`. Cek log jika reload error. ([valerioviperino.me][10])
* Lihat device & outputs: `swaymsg -t get_inputs` dan `swaymsg -t get_outputs`. Gunakan untuk memastikan nama device/output saat memakai opsi berbasis device. ([manpages.ubuntu.com][9])
* Jika binding tidak bereaksi pada layout tertentu: tambahkan `--to-code` ke `bindsym` sensitif atau gunakan `bindcode`. Periksa isu upstream bila perilaku aneh (ada beberapa issue terkait `--to-code` pada versi tertentu). ([GitHub][11])
* Untuk melihat event tombol: jalankan `wev` (lihat keysyms/kode saat tekan & release). ([man.archlinux.org][2])

Contoh debugging workflow:

1. Tekan tombol yang ingin di-bind → catat output `wev`.
2. Coba `bindsym <that_keysym> exec notify-send test` → reload config → tekan.
3. Jika tidak muncul, coba `bindsym --to-code ...` atau `bindcode <keycode> ...`.
4. Check `~/.local/share/sway/log` atau `journalctl --user -b` untuk pesan error terkait parsing config.

---
<!--
##  6. Persiapan untuk *memodifikasi Sway* (kalau kamu mau bikin patch / fitur)

> Catatan: **untuk sekedar mengedit config tidak perlu programming**. Berikut ini jika kamu mau mengubah kode Sway sendiri atau mengembangkan tooling terkait:

* Bahasa & stack Sway: **dibangun terutama dalam C**, menggunakan **wlroots** (C) untuk layer Wayland. Build system: **Meson** + **Ninja**. Paket dev yang biasa perlu: `libwayland-dev`, `libxkbcommon-dev`, `libseat`, `libinput`, `pkg-config`, dll. Untuk kontribusi perlu pengalaman C, pemahaman Wayland, XKB, dan meson. ([about.gitlab.com][12])
* Tooling/dev: `meson setup build`, `meson compile -C build`, `meson test -C build`. Gunakan `sway -d` untuk debug logging saat menjalankan binary kustom.
* Jika ingin membuat util CLI untuk meng-generate binding atau viewer: bahasa yang cocok — **Rust**, **Go**, atau **Python** (Rust banyak dipakai di komunitas Wayland karena safety + performa). Tetapi buat plugin/config generator cukup dengan shell scripts / python.
* Jika intentmu adalah membuat editor/visualizer keybindings: baca struktur config Sway, dan pertimbangkan membuat parser (Sway config adalah sekumpulan perintah; formatnya ringkas). Ada proyek komunitas yang sudah membuat keybinding viewers (mis. `remontoire` untuk i3/Sway). ([varac.net][13])

---

-->
##  6. Praktik terbaik & tips organisasi

* Pisahkan bindings ke file terpisah di `~/.config/sway/config.d/` atau gunakan `include` untuk modularisasi (mis. `include configs/00-vars`), sehingga mudah maintain. Banyak distribusi (Manjaro Sway) memakai struktur ini. (jika include tak terbaca, periksa path dan urutan include). ([Manjaro Linux Forum][14])
* Tandai binding dengan komentar yang konsisten (nama, deskripsi) sehingga mudah diparse oleh tooling. Beberapa dotfiles mengandalkan komentar berstruktur agar tooling bisa menampilkan daftar shortcut. ([Mark Stosberg][15])
* Untuk workspace switching yang stabil di multi-layout: gunakan `bindsym --to-code` pada bindings workspace (atau gunakan `bindcode` jika kamu tahu keycode row angka). ([EndeavourOS][16])

---

##  7. Referensi penting (baca lebih lanjut)

* Manual Sway (sway(5)) — panduan syntax config & opsi `bindsym`/`bindcode`. ([man.archlinux.org][1])
* ArchWiki — overview Sway + tips. ([wiki.archlinux.org][17])
* wev (wayland event viewer) repo & man page — untuk menemukan keysyms pada Wayland. ([GitHub][18])
* Issue GitHub / diskusi tentang `--to-code` dan layout dependency (berguna untuk edge cases). ([GitHub][4])

---

[1]: https://man.archlinux.org/man/sway.5?utm_source=chatgpt.com "sway(5) - Arch manual pages"
[2]: https://man.archlinux.org/man/wev.1.en?utm_source=chatgpt.com "wev(1) - Arch manual pages"
[3]: https://git.bracken.jp/dotfiles/file/.config/sway/config.html?utm_source=chatgpt.com "config - dotfiles - Personal dotfiles"
[4]: https://github.com/swaywm/sway/issues/8275?utm_source=chatgpt.com "Bindings to keysyms are layout-dependent · Issue #8275"
[5]: https://wayland.freedesktop.org/libinput/doc/latest/tools.html?utm_source=chatgpt.com "Helper tools — libinput 1.29.901 documentation"
[6]: https://stackoverflow.com/questions/79646256/how-could-i-detect-key-events-in-the-terminal-using-c?utm_source=chatgpt.com "How could I detect key events in the terminal using C?"
[7]: https://github.com/swaywm/sway/issues/6456?utm_source=chatgpt.com "`keysym --release` is unreliable · Issue #6456 · swaywm/ ..."
[8]: https://manpages.debian.org/testing/sway/sway.5.en.html?utm_source=chatgpt.com "sway(5) - testing"
[9]: https://manpages.ubuntu.com/manpages/questing/man5/sway.5.html?utm_source=chatgpt.com "sway - configuration file and commands"
[10]: https://valerioviperino.me/sway-fresh-start/?utm_source=chatgpt.com "Setting up sway on a new machine"
[11]: https://github.com/swaywm/sway/issues/8022?utm_source=chatgpt.com "Unable to translate bindsym to bindcode since 1.9 #8022"
[12]: https://gitlab.com/dnkl/sway/-/tags?utm_source=chatgpt.com "Tags · Daniel Eklöf / sway"
[13]: https://www.varac.net/docs/desktop/wayland/sway/keybindings.html?utm_source=chatgpt.com "Sway keybindings - Varac's documentation"
[14]: https://forum.manjaro.org/t/default-config-sway-config/146594?utm_source=chatgpt.com "Default .config/sway/config - Support - Manjaro Linux Forum"
[15]: https://mark.stosberg.com/sway-keybindings/?utm_source=chatgpt.com "Tips for organizing Sway keybindings - Mark Stosberg"
[16]: https://forum.endeavouros.com/t/keybindings-not-matching-my-config/39321?utm_source=chatgpt.com "Keybindings not matching my config - All WMs"
[17]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[18]: https://github.com/jwrdegoede/wev?utm_source=chatgpt.com "jwrdegoede/wev"

# Ringkasan singkat untuk bantuan

1. Sumber otoritatif: **man pages** (`sway(5)`, `sway-input(5)`, `sway-output(5)`) dan **default config** di repository Sway (`config.in`) — ini berisi daftar directive/keyword yang dipakai Sway. ([Man Archlinux][1])
2. Untuk *kata kunci runtime* (nama device/outputs/inputs) gunakan `swaymsg -t get_outputs` dan `swaymsg -t get_inputs`. ([manpages.debian.org][2])
3. Untuk daftar variabel yang kamu pakai di konfigurasi — parse file konfigurasi kamu (grep/awk) karena Sway tidak menyediakan perintah bawaan untuk “list variables” runtime. (Gunakan `set` lines). ([GitHub][3])

---

##  1) Dapatkan **semua kata kunci Sway (perintah / directives)** — dua cara terbaik

### A. Dari manual lokal (man pages)

Perintah:

```bash
man 5 sway | col -b | sed -n '1,400p' > ~/tmp/sway-man.txt
```

Penjelasan kata-per-kata:

* `man 5 sway` → buka manual section 5 (file formats/config) untuk `sway`. Section 5 berisi directive/config options.
* `|` → pipe: meneruskan output ke perintah berikutnya.
* `col -b` → hapus kontrol karakter backspaces/format supaya output bersih.
* `sed -n '1,400p'` → ambil baris 1–400 (contoh; sesuaikan jika perlu).
* `> ~/tmp/sway-man.txt` → simpan hasil ke file `~/tmp/sway-man.txt`.

Setelah itu, ekstrak kata kunci (perintah yang muncul di awal baris):

```bash
grep -oP '^[a-zA-Z0-9_-]+' ~/tmp/sway-man.txt | sort -u
```

Penjelasan:

* `grep -oP '^[a-zA-Z0-9_-]+'` → cari token di awal baris (mengasumsikan directive dimulai di awal baris).
* `sort -u` → sortir dan hilangkan duplikat.

**Catatan:** man pages berbeda antar distribusi; selalu cek `man 5 sway` di sistemmu untuk versi yang terpasang. ([Man Archlinux][1])

---

### B. Dari default config / repo Sway (komprehensif & contoh)

Ambil file contoh yang disertakan di repo (online) atau dari paket sistem (`/etc/sway/config`).

Ambil online (jika punya internet):

```bash
curl -s https://raw.githubusercontent.com/swaywm/sway/master/config.in > ~/tmp/sway-config.in
grep -oP '^[[:space:]]*([a-zA-Z0-9_-]+)' ~/tmp/sway-config.in | sed 's/^[[:space:]]*//' | sort -u
```

Penjelasan:

* `curl -s URL` → ambil file dari GitHub (raw). `-s` = silent.
* `grep -oP '^[[:space:]]*([a-zA-Z0-9_-]+)'` → ambil token pertama tiap baris (directive atau example keyword).
* `sed 's/^[[:space:]]*//'` → hapus spasi di depan.
* `sort -u` → sortir unik.

`config.in` biasanya berisi contoh `output`, `bindsym`, `set`, `exec`, `for_window`, `bar`, `input`, dsb. Ini berguna karena ia menunjukkan direct usage dan contoh yang luas. ([GitHub][3])

---

##  2) Dapatkan **semua kata kunci variabel** (yang digunakan di config kamu)

Sway tidak punya perintah `list variables` — variabel konfigurasi adalah baris `set`. Cara praktis:

```bash
grep -R "^[[:space:]]*set " ~/.config/sway | sed -E "s/.*set[[:space:]]+\\$?([A-Za-z0-9_-]+).*/\\1/" | sort -u
```

Penjelasan:

* `grep -R "^[[:space:]]*set "` → cari semua baris yang mulai dengan `set` di direktori config Sway.
* `sed -E "s/.*set[[:space:]]+\\$?([A-Za-z0-9_-]+).*/\\1/"` → ekstrak nama variabel (menghapus `$` jika ada).
* `sort -u` → sortir unik.

Contoh keluaran: `mod`, `term`, `wallpaper`, `menu`, dsb — itu semua **nama variabel** yang kamu definisikan di config. ([GitHub][3])

---

##  3) Dapatkan **kata kunci input / output** (runtime + directive)

Ada dua hal: (A) nama device/identifier runtime (mis. `eDP-1`, `HDMI-A-1`, `type:keyboard`) dan (B) directive/config keywords untuk mengatur input/output (`input`, `output`, dan sub-directives).

### A. Nama device runtime (apa yang ada di mesinmu)

Perintah:

```bash
swaymsg -t get_inputs   # daftar input devices (keyboard, pointer, touchpad)
swaymsg -t get_outputs  # daftar outputs (monitors)
```

Penjelasan:

* `swaymsg` → klien IPC untuk mengirim perintah ke sway.
* `-t get_inputs` / `-t get_outputs` → tipe permintaan; sway mengembalikan JSON berisi devices/outputs.

Untuk mengekstrak nama:

```bash
swaymsg -t get_outputs | jq -r '.[].name'
swaymsg -t get_inputs  | jq -r '.[].identifier, .[].name'   # fields dapat berbeda per versi
```

Penjelasan:

* `jq -r '.[].name'` → parse JSON dan keluarkan nama perangkat per baris.

Ini memberi **nama-nama aktual** yang bisa dipakai sebagai `output NAME { ... }` atau `input NAME { ... }`. ([manpages.debian.org][2])

### B. Directive / opsi yang tersedia untuk `input` dan `output`

Baca manual khusus:

* `man 5 sway-input` — menjelaskan semua opsi yang bisa dipakai di blok `input <identifier> { ... }`. ([manpages.ubuntu.com][4])
* `man 5 sway-output` — menjelaskan opsi untuk blok `output`. ([manpages.debian.org][2])

Kamu bisa mengekstrak kata kunci dari manpages sama seperti di langkah (1A):

```bash
man 5 sway-input | col -b | grep -oP '^[a-zA-Z0-9_-]+' | sort -u
man 5 sway-output | col -b | grep -oP '^[a-zA-Z0-9_-]+' | sort -u
```

Penjelasan sama seperti sebelumnya: parse man, ambil token awal tiap baris, sortir unik.

---

##  4) Dapatkan **seluruh kata kunci konfigurasi Sway** (komprehensif)

Gabungkan sumber: man pages, config.in (repo), dan file konfigurasimu sendiri.

Contoh skrip satu-liner untuk mengumpulkan semuanya (lokal + repo online):

```bash
mkdir -p ~/tmp/sway-keys
man 5 sway | col -b > ~/tmp/sway-keys/sway-man.txt
curl -s https://raw.githubusercontent.com/swaywm/sway/master/config.in > ~/tmp/sway-keys/config.in
grep -hoP '^[[:space:]]*([A-Za-z0-9_-]+)' ~/tmp/sway-keys/*.txt ~/tmp/sway-keys/*.in | sed 's/^[[:space:]]*//' | sort -u > ~/tmp/sway-keys/all-keywords.txt
wc -l ~/tmp/sway-keys/all-keywords.txt && sed -n '1,200p' ~/tmp/sway-keys/all-keywords.txt
```

Penjelasan:

* `mkdir -p` → buat folder kerja.
* `man 5 sway | col -b` → simpan man.
* `curl -s` → ambil config.in.
* `grep -hoP '^[[:space:]]*([A-Za-z0-9_-]+)'` → ambil token pertama tiap baris dari setiap file.
* `sed 's/^[[:space:]]*//'` → bersihkan leading whitespace.
* `sort -u > all-keywords.txt` → hasil final unik.
* `wc -l` dan `sed -n` → tunjukkan jumlah dan contoh isi file.

**Catatan penting:** hasil ini adalah daftar token yang muncul sebagai "kata pertama" pada baris — ini adalah pendekatan pragmatis untuk mendapatkan directive/keywords dan contoh. Untuk definisi lengkap/penjelasan tiap keyword, rujuk man pages (penjelasan masing-masing directive). ([Man Archlinux][1])

---

##  5) Tips lanjutan & gotchas (pengalaman nyata)

* `swaymsg -t get_config` mengembalikan konfigurasi utama **tetapi** mungkin tidak memasukkan isi file yang di-`include`. Jadi pengumpulan hanya lewat `swaymsg -t get_config` **tidak** selalu lengkap; parsing file konfigurasi di `~/.config/sway` lebih andal. ([GitHub][5])
* Gunakan `jq` untuk JSON runtime; gunakan `rg` (ripgrep) untuk pencarian cepat di konfigurasi.
* Untuk definisi fungsi/keyword yang sebenarnya (argumen dan nilai yang diizinkan), **baca man pages**: itu sumber yang menjelaskan tipe argumen, contoh, dan perilaku. ([Man Archlinux][1])

---

##  6) Referensi utama (baca lanjut)

* `sway` manpage (config): `man 5 sway`. ([Man Archlinux][1])
* `sway-input` manpage (input directives): `man 5 sway-input`. ([manpages.ubuntu.com][4])
* `sway-output` manpage (output directives): `man 5 sway-output`. ([manpages.debian.org][2])
* `config.in` (default example / repo Sway) — contoh komprehensif dan default usage. ([GitHub][3])
* ArchWiki / distro wikis (tutorial & practical tips). ([ArchWiki][6])

---

[1]: https://man.archlinux.org/man/sway.5?utm_source=chatgpt.com "sway(5) - Arch manual pages"
[2]: https://manpages.debian.org/experimental/sway/sway-output.5.en.html?utm_source=chatgpt.com "sway-output(5)"
[3]: https://raw.githubusercontent.com/swaywm/sway/master/config.in?utm_source=chatgpt.com "https://raw.githubusercontent.com/swaywm/sway/mast..."
[4]: https://manpages.ubuntu.com/manpages/focal/man5/sway-input.5.html?utm_source=chatgpt.com "sway-input - input configuration file and commands"
[5]: https://github.com/swaywm/sway/issues/5559?utm_source=chatgpt.com "swaymsg get_config doesn't show config parameters that ..."
[6]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"

<!--

# Bagaimana jika anda perlu environment variables untuk aplikasi (contoh: MOZ_ENABLE_WAYLAND)

Pilihan umum:

* **Set pada saat login**: letakkan export di `~/.profile`, `~/.xprofile` (kadang tidak dipakai oleh DM), atau gunakan PAM (`~/.pam_environment`).
* **Wrapper script**: buat script `~/bin/sway-run`:

  ```sh
  #!/bin/sh
  export MOZ_ENABLE_WAYLAND=1
  export XDG_CURRENT_DESKTOP=sway
  exec sway "$@"
  ```

  lalu jalankan script ini dari greeter / .desktop session. Ini cara sederhana & reproducible.
* **systemd --user + import-environment**: jalankan `exec_always "systemctl --user import-environment"` di config atau gunakan `~/.config/environment.d/*.conf` systemd mechanism tergantung DM.
  Referensi & diskusi: ada banyak issue/forum yang menekankan — Sway sendiri **tidak** menetapkan env var arbitrary dari `set` di config. ([EndeavourOS][6])

# Perintah debugging / menemukan nama output (menjawab kebutuhan praktismu)

Untuk mengetahui nama output (mis. `eDP-1`, `HDMI-A-1`, atau nama lengkap device), jalankan:

```bash
swaymsg -t get_outputs
```

Penjelasan kata-per-kata:

* `swaymsg` = utilitas klien yang mengirim perintah ke sway melalui IPC.
* `-t` = opsi untuk tipe request.
* `get_outputs` = perintah IPC yang mengembalikan daftar output dalam format JSON (nama, mode, position, scale, dsb).

Anda bisa pipe ke `jq` agar lebih rapi:

```bash
swaymsg -t get_outputs | jq -r '.[] | .name'
```

* `|` = pipe shell, meneruskan output ke `jq`.
* `jq -r '.[] | .name'` = mengekstrak field `name` dari setiap object JSON.

Sumber & contoh resmi: dokumentasi/ArchWiki merekomendasikan perintah ini untuk menemukan nama output. ([ArchWiki][2])

# Praktik terbaik (recommendasi langsung)

1. Buat file `definitions` terpisah dan **include** itu di bagian paling atas config:

   ```text
   include $HOME/.config/sway/definitions.d/*.conf
   ```

   isi `definitions.d/00-vars.conf`:

   ```text
   set $mod Mod4
   set $term foot
   set $wallpaper /home/poweruser/Pictures/wall.png
   ```

   Pastikan include dilakukan sebelum baris yang memakai variabel. ([Random bits and pieces][7])

2. Gunakan path absolut untuk file (atau `$HOME`) agar tidak terjebak masalah ekspansi `~`.

3. Untuk nilai kompleks (command pipeline), definisikan variabel berisi command yang sesuai dan periksa perbedaan antara `exec` dan `exec_always` (behaviour parsing berbeda—banyak issue di repo terkait hal ini).

4. Untuk env vars yang harus tersedia ke *aplikasi*, jangan andalkan `set` — gunakan metode wrapper/script/systemd/DM seperti dijelaskan di atas. ([Lorenzo Bettini][8])

# Identitas teknologi & persyaratan jika anda mau *mengembangkan / memodifikasi* Sway

* **Bahasa**: Sway ditulis dalam **C**; bergantung kuat pada library **wlroots** (C) yang menyediakan building blocks Wayland compositor. ([GitHub][9])
* **Jika ingin membangun/modifikasi Sway dari sumber**: minimal yang perlu dipersiapkan:

  * Pengetahuan: C (memory management, pointers), Wayland protocol concepts, wlroots API, dan build systems (Meson).
  * Tools & dependencies: `meson`, `ninja`, `pkg-config`, `wayland` dev headers, `wayland-protocols`, `libinput`, `libxkbcommon`, `pango`, `cairo`, `json-c`, `pcre2`, dsb. (dokumentasi repo mencantumkan daftar lengkap dependensi). ([GitHub][9])
  * Workflow: clone repo `git clone https://github.com/swaywm/sway`, jalankan `meson build` → `ninja -C build` → `ninja -C build install` (run di environment development).
* **Untuk sekadar memodifikasi konfigurasi**: cukup memahami syntax config Sway (text), shell scripting dasar (untuk wrapper scripts), dan tools debugging (`swaymsg`, `jq`, `journalctl`).

# Tugas praktis singkat supaya anda kebal implementasi

1. Buat direktori `~/.config/sway/definitions.d/` dan file `00-vars.conf` isi contoh variabel di atas. Include direktori itu di top of `~/.config/sway/config`. Reload sway (`swaymsg reload` atau `sway reload`) dan cek apakah binding dan wallpaper bekerja.
2. Jalankan `swaymsg -t get_outputs | jq -r '.[] | .name'` untuk memastikan nama output. Ganti `output eDP-1` di config dengan nama yang benar jika perlu.
3. Jika aplikasi tidak membaca env var (mis. `MOZ_ENABLE_WAYLAND`), buat `~/bin/sway-run` wrapper seperti contoh lalu ubah session greeter / .desktop yang memanggil sway untuk menjalankan script itu.

# Sumber pokok yang saya gunakan (baca lanjut)

* `sway` manual & konfigurasi (man pages) — penjelasan `set`, `bindsym`, `output`. ([Man Archlinux][1])
* ArchWiki — panduan config dan perintah `swaymsg -t get_outputs`. ([ArchWiki][2])
* Issue & diskusi upstream (GitHub) tentang environment variables & perilaku config (menjelaskan bahwa `set` bukan export). ([GitHub][3])
* i3 userguide (penjelasan tentang waktu ekspansi variabel dan include order — relevan karena kompatibilitas i3). ([i3][4])
* Repo GitHub Sway (build deps & instruksi membangun). ([GitHub][9])

---

-->
[1]: https://man.archlinux.org/man/sway.5?utm_source=chatgpt.com "sway(5) - Arch manual pages"
[2]: https://wiki.archlinux.org/title/Sway?utm_source=chatgpt.com "Sway - ArchWiki"
[3]: https://github.com/swaywm/sway/issues/4403?utm_source=chatgpt.com "Environment not included in sway · Issue #4403"
[4]: https://i3wm.org/docs/userguide.html?utm_source=chatgpt.com "i3 User's Guide"
[5]: https://github.com/swaywm/sway/issues/3093?utm_source=chatgpt.com "[Question] Set Variables via bindsym in config · Issue #3093"
[6]: https://forum.endeavouros.com/t/environment-variables-in-sway/56650?utm_source=chatgpt.com "Environment variables in Sway - All WMs"
[7]: https://www.igordejanovic.net/recipes/sway-config/?utm_source=chatgpt.com "Sway config • Random bits and pieces - Igor Dejanović"
[8]: https://www.lorenzobettini.it/2024/06/environment-variables-in-sway/?utm_source=chatgpt.com "Environment Variables in Sway | Lorenzo Bettini"
[9]: https://github.com/swaywm/sway?utm_source=chatgpt.com "swaywm/sway: i3-compatible Wayland compositor"
<!--
### Eksperimen dan Latihan Mandiri

Sekarang, coba praktikkan dalam file konfigurasi Sway Anda (biasanya `~/.config/sway/config`).

1.  **Temukan dan Pahami:** Buka file config Anda dan cari blok kode yang berisi `set $...`. Apakah Anda memahami apa yang dilakukan setiap variabel itu?
2.  **Ubah dan Rasakan:** Coba ganti nilai dari variabel `$term` dari `alacritty` ke `kitty` atau sebaliknya. Setelah menyimpan config dan merefresh Sway (`$mod+Shift+c`), tekan `$mod+Return`. Apa yang terjadi?
3.  **Buat Variabel Sendiri:**
    - Anda punya editor teks favorit, misalnya `vim` atau `vscode`. Buatlah variabel `$editor` untuknya.
    - Lalu, buat keybinding untuk membukanya. Misalnya: `bindsym $mod+e exec $editor`.
4.  **Eksplorasi Lanjutan (Opsional):** Variabel bisa menyimpan perintah yang lebih kompleks. Coba ini:
    ```bash
    set $screenshot 'grim -g "$(slurp)" - | swappy -f -'
    bindsym Print exec $screenshot
    ```
    Sekarang, ketika Anda menekan `Print Screen`, Anda bisa memilih area layar untuk discreenshot dan langsung diedit di `swappy`.

**Tantangan Selanjutnya:** Coba pikirkan, jika Anda ingin mengubah perilaku "memindahkan fokus jendela" dari tombol HJKL menjadi tombol panah, di bagian mana saja Anda harus melakukan perubahan? Dengan menggunakan variabel, perubahan itu akan sangat minimal.
File konfigurasi Sway adalah file teks yang berisi perintah-perintah yang dieksekusi. Ia memiliki beberapa fitur sintaksis inti:

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

---
---
---

##  Praktis: beberapa perintah & tip cepat

* Menyalin konfigurasi sway: `cp /etc/sway/config ~/.config/sway/config` lalu sesuaikan. ([wiki.archlinux.org][4])
* Mengirim perintah lewat IPC: `swaymsg 'workspace 2; exec alacritty'`. ([GitHub][3])
* Debugging runtime: `sway -d 2> ~/sway.log` untuk melihat pesan kesalahan/diagnostik. ([GitHub][3])

##  Cara memperluas fungsionalitas tanpa memodifikasi kode C

* **Skrip eksternal & status blocks**: banyak ekstensi dibuat hanya dengan skrip shell/Python/Node/Rust yang berkomunikasi lewat `swaymsg` atau menulis ke bar (i3bar protocol / swaybar). Ini adalah jalur tercepat untuk menambah fitur tanpa compile ulang. ([GitHub][3])
* **IPC (JSON)**: gunakan socket IPC untuk membaca status, mengubah layout, memindahkan jendela, dsb. Tersedia binding pihak ketiga untuk bahasa populer. ([GitHub][3])


# Penjelasan baris konfigurasi penting

---

## Variabel

### `set $mod Mod4`

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

## Status Bar

Lewati bagian ini karena kita tidak akan membahas status bar untuk swaybar sebab nantinya yang akan kita gunakan adalah [waybar][c]. Jika anda tertarik untuk memahami statusbar bawaan sway baca lebih lanjut [disini][d].

---

### Cara mendapatkan bantuan dan dokumentasi (CLI & man pages)

* `man 5 sway` — dokumentasi format file konfigurasi. (Baca dengan `man 5 sway`.)
  * **Penjelasan:** `man` = manual reader, `5` = section (file formats), `sway` = topik.
* `man sway` atau `man 1 sway` — manual program sway (bagian 1: executable).
* `sway --help` — opsi baris perintah singkat.
* `swaymsg` — utilitas IPC untuk mengirim perintah ke sway yang sedang berjalan; `swaymsg -t get_outputs` mis.
* `sway -c /path/to/config` — memulai sway dengan file konfigurasi yang ditentukan (berguna untuk testing konfigurasi non-default).
  * **Penting:** `sway` akan memulai session Wayland; jangan jalankan dari TTY/seat yang sedang aktif tanpa persiapan — lihat catatan uji di bagian 4.

---

### Cara menguji perubahan konfigurasi tanpa mengganggu sesi yang sedang dipakai (ringkasan cepat & aman)

* **Metode 1: Jalankan sway di TTY terpisah (recommended untuk pengujian)**

  * Buat user lain atau gunakan TTY kosong (Ctrl+Alt+F3) dari login text mode. Login di TTY itu dan jalankan `sway` di sana dengan `sway -c /path/to/test-config`. Tidak mengganggu sesi grafis utama.
* **Metode 2: Gunakan `sway -c` untuk start terpisah** — seperti di atas, jangan jalankan pada TTY yang sama dengan sesi grafis utama.
* **Metode 3: `swaymsg` & `swaymsg reload`** — dapat memuat ulang konfigurasi pada sesi berjalan, tetapi jika ada error syntax atau kesalahan binding fatal, Anda bisa terkunci. Selalu backup config sebelum reload.
* **Metode 4: Gunakan virtual machine/container dengan Wayland nested** — lebih aman untuk eksperimen radikal.

---

#### Contoh baris: `bindsym $mod+Return exec $terminal`

* `bindsym` — perintah untuk membuat key binding; memonitor *symbolic* key names (bukan keycodes).
* `$mod` — variabel modifier yang sebelumnya diset (`Mod4` kalau default).
* `+` — operator penggabung kombinasikan modifier dan tombol.
* `Return` — nama tombol (Enter).
* `exec` — jalankan perintah eksternal.
* `$terminal` — variabel yang menyimpan nama emulator terminal (mis. `alacritty` atau `kitty`).
  **Arti lengkap:** ketika pengguna menekan `Super+Enter`, jalankan terminal yang didefinisikan.

---


<!--
🔧🧭🪄🧰🧩🤖🔁




Tautan wlroots untuk github
https://github.com/swaywm/wlroots?utm_source=chatgpt.com 
-->

<!---------------------->
<!--wlroots-->
[a]: ./../../module/bagian-1/README.md

<!--dir dalam sway-->
[b]: ./bagian-1/README.md
[c]: ./../waybar/README.md
[d]: ./bagian-2/README.md
