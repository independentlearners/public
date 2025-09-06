
# **Mengelola Bluetooth dengan bluetuith & Optimalisasi Audio di Arch Linux Sway**

---

## 1. Pendahuluan

Dokumentasi ini memusatkan pada **bluetuith** sebagai antarmuka utama untuk mengelola koneksi Bluetooth di **Arch Linux** dengan **Sway** (Wayland). Semua komponen—mulai dari sistem dasar, daemon Bluetooth, terminal popup, hingga optimasi audio—akan dikonfigurasi agar berjalan otomatis.

### Ruang Lingkup

1. Persyaratan sistem dasar
2. Instalasi & konfigurasi daemon Bluetooth
3. Tutorial `bluetoothctl` (mode CLI)
4. Instalasi & penggunaan **bluetuith** (TUI)
5. Konfigurasi terminal popup di Sway
6. Opsi manajer alternatif (opsional)
7. Optimasi audio Bluetooth A2DP dengan **PipeWire**
8. Troubleshooting

---

## 2. Persyaratan Sistem Dasar

Pastikan sistem kamu memenuhi:

* **Arch Linux** terupdate (`sudo pacman -Syu`)
* Kernel Linux terbaru (rekomendasi >=5.15)
* **Sway** window manager
* Terminal emulator (contoh: **foot**, **alacritty**, **kitty**)
* Akses AUR helper (`paru` atau `yay`)

Instalasi dasar:

```bash
# Sistem dasar & tool
sudo pacman -Syu sway foot git base-devel
# AUR helper (paru)
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si
```

---

## 3. Instalasi & Konfigurasi Daemon Bluetooth

### 3.1. Pasang BlueZ

```bash
sudo pacman -S bluez bluez-utils
```

### 3.2. Aktifkan Daemon Bluetooth

#### a) **Autostart via Sway** (Default)

Tambahkan di `~/.config/sway/config`:

```conf
exec_always /usr/lib/bluetooth/bluetoothd &
```

#### b) **Opsi Systemd (Aktif di luar Sway)**:

```bash
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
```

Dengan ini, bluetooth akan aktif meski berada di luar sesi Sway (TTY, GDM, dsb).

---

## 4. Tutorial `bluetoothctl` (CLI)

Langkah manual menggunakan `bluetoothctl`:

```bash
bluetoothctl
# Aktifkan adapter
power on
# Scan perangkat
scan on
# Setelah muncul MAC, jalankan:
pair <MAC>
trust <MAC>
connect <MAC>
# Selesai
exit
```

Gunakan opsi Systemd jika ingin daemon selalu aktif di luar sesi Sway.

---

## 5. Instalasi & Penggunaan bluetuith (TUI)

**bluetuith** memberikan antarmuka Ncurses yang intuitif.

### 5.1. Instalasi

Ada tiga varian paket bluetuith di AUR:

* **bluetuith**

  * Versi stabil yang terbit di rilis resmi.
  * Tetap menggunakan kode sumber terakhir yang sudah diuji.
  * Cocok untuk pengguna umum yang menginginkan kestabilan.

  ```bash
  paru -S bluetuith
  ```

* **bluetuith-bin**

  * Paket prebuilt (binary) dari rilis stabil.
  * Mengurangi waktu kompilasi karena sudah dalam bentuk biner.
  * Cocok bagi yang tidak ingin menunggu proses build.

  ```bash
  paru -S bluetuith-bin
  ```

* **bluetuith-git**

  * Versi pengembangan langsung dari repositori Git terbaru.
  * Selalu memuat fitur dan perbaikan paling anyar, tapi mungkin kurang stabil.
  * Cocok bagi kontributor atau yang ingin fitur cutting‑edge.

  ```bash
  paru -S bluetuith-git
  ```

### 5.2. Dependensi Dependensi

```bash
sudo pacman -S bluez-utils
```

### 5.3. Verifikasi

```bash
which bluetuith  # => /Busr/bin/bluetuith
```

### 5.4. Cara Menggunakan

* **Jalankan**: `bluetuith`
* **Navigasi**: ↑/↓ untuk pilih perangkat
* **Aksi**: `Enter` → opsi Scan, Pair, Trust, Connect, Disconnect
* **Keluar**: `q` (tidak memutus sambungan)

---

## 6. Popup bluetuith di Sway

Menjalankan bluetuith dalam floating popup:

Tambahkan ke `~/.config/sway/config`:

```conf
# Shortcut popup bluetuith
bindsym $mod+b exec foot --class bluetuith -e bluetuith

# Floating rules untuk terminal bluetuith
for_window [class="bluetuith"] {
  floating enable
  resize set 60% 60%
  move position center
  border normal
  move to scratchpad
}
# Toggle scratchpad
bindsym $mod+Shift+b scratchpad show
```

* `$mod+b`: tampilkan popup bluetuith
* `q` di dalam bluetuith: keluar tanpa disconnect
* `$mod+Shift+b`: sembunyikan/kembalikan popup

---

## 7. Opsi Manajer Bluetooth Alternatif (Opsional)

| Opsi          | Tipe | Kelebihan                   | Instalasi                  |
| ------------- | ---- | --------------------------- | -------------------------- |
| **Blueman**   | GUI  | Tray, profil audio, lengkap | `sudo pacman -S blueman`   |
| **Blueberry** | GUI  | Ringkas, ringan             | `sudo pacman -S blueberry` |
| **dmenu/fzf** | CLI  | Kustom, scriptable          | custom AUR + script + bind |

Gunakan jika bluetuith kurang nyaman.

---

## 8. Optimasi Audio Bluetooth A2DP

Supaya audio berkualitas tinggi:

### 8.1. Hapus PulseAudio Bluetooth

```bash
sudo pacman -Rns pulseaudio pulseaudio-bluetooth
```

### 8.2. Install PipeWire Full Stack

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-audio wireplumber
```

### 8.3. Autostart PipeWire via Sway

Tambahkan:

```conf
exec_always pipewire &
exec_always pipewire-pulse &
exec_always wireplumber &
```

### 8.4. Verifikasi Backend Audio

```bash
pactl info | grep "Server Name"
# Harus: PulseAudio (on PipeWire x.x.x)
```

### 8.5. Sambung & Set Profil A2DP

1. **Sambung** via bluetuith
2. **Set profil**:

   ```bash
   pactl set-card-profile bluez_card.F0_AE_66_BC_27_DB a2dp_sink
   ```
3. **Cek sink**:

   ```bash
   pactl list short sinks
   ```
4. **Tes**:

   ```bash
   paplay /usr/share/sounds/alsa/Front_Center.wav
   ```

### 8.6. GUI Routing (Opsional)

* **helvum**: `sudo pacman -S helvum` → `helvum`
* **qpwgraph**: `sudo pacman -S qpwgraph` → `qpwgraph`

---

## 9. Troubleshooting

1. **A2DP unavailable**: periksa `pactl info`, aktifkan PipeWire
2. **Profil tidak muncul**: restart Sway atau reload config
3. **Bluetoothd crash**: cek log `journalctl -xe | grep bluetooth`
4. **Headset hilang**: ulang scan/pair di bluetuith

---

## 10. Penutup

Semua komponen—sistem dasar, daemon Bluetooth, `bluetoothctl`, bluetuith, terminal popup, dan PipeWire—telah diatur agar berjalan otomatis dan terpadu di Sway. Kini kamu dapat mengelola Bluetooth dan audio berkualitas tinggi tanpa ribet di Arch Linux.

**Selamat mencoba!**

> ChatGPT

**[Beranda][1]**
[1]: ../../../../README.md
