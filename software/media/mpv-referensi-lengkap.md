# Referensi Lengkap MPV Player: Default Behavior, Lua API, dan Roadmap Konfigurasi Kustom

> **Catatan akurasi & versi.** Dokumen ini disusun langsung dari sumber primer: `etc/input.conf`, `DOCS/man/lua.rst`, dan `DOCS/man/input.rst` di repositori resmi `mpv-player/mpv` (branch `master`), per Agustus 2026. Karena mpv adalah proyek yang bergerak cepat, beberapa detail granular (nomor versi minimum suatu flag, dsb.) bisa berbeda tipis dari versi stabil yang Anda pakai. Selalu validasi di sistem Anda sendiri dengan tiga perintah ini sebelum menganggap sesuatu final:
>
> ```bash
> mpv --input-cmdlist      # daftar semua command yang dikenali binary Anda
> mpv --input-keylist      # daftar semua nama key yang valid
> mpv --list-properties    # daftar semua property yang bisa dibaca/ditulis
> ```
>
> Ketiga perintah ini adalah "ground truth" — lebih otoritatif daripada dokumen manapun, termasuk dokumen ini, karena mencerminkan binary yang benar-benar Anda jalankan.

---

## Daftar Isi

0. [Model Mental: Arsitektur MPV](#0-model-mental-arsitektur-mpv)
1. [Pintasan & Fungsionalitas Default (Sebelum Konfigurasi)](#1-pintasan--fungsionalitas-default-sebelum-konfigurasi)
2. [Arsitektur & Referensi API Lua](#2-arsitektur--referensi-api-lua)
3. [Roadmap Tutorial: Dasar → Mahir](#3-roadmap-tutorial-dasar--mahir)
4. [Area Paling Krusial & Tersulit — Crash Course Padat](#4-area-paling-krusial--tersulit--crash-course-padat)
5. [Rekomendasi Alur Konfigurasi Logis (Dasar → Profesional)](#5-rekomendasi-alur-konfigurasi-logis-dasar--profesional)
6. [Prinsip Maintainability: Menghindari Kode yang Unreadable/Unmaintainable](#6-prinsip-maintainability-menghindari-kode-yang-unreadableunmaintainable)

---

## 0. Model Mental: Arsitektur MPV

Sebelum masuk ke daftar, satu pemahaman ini akan menghemat banyak kebingungan di jalan: **mpv hanya punya satu bahasa perintah**, bukan dua sistem terpisah untuk "keybinding" dan "scripting".

```
                     ┌───────────────────────────────────┐
                     │      MPV CORE (C, libmpv)         │
                     │  properties · commands · events   │
                     └───────────────┬───────────────────┘
                                     │  Client API (sama persis untuk semua)
        ┌─────────────┬──────────────┼──────────────┬──────────────┐
        │             │              │              │              │
   input.conf     JSON IPC      Lua scripts     JavaScript      libmpv
  (key → command) (--input-    (mp.command,      scripts      (embed di
                  ipc-server)   mp.commandv,                   aplikasi
                                mp.command_native)              lain)
```

Implikasinya: command yang Anda ikat ke tombol di `input.conf` (mis. `seek 10`) adalah **command yang sama persis** yang Anda panggil lewat `mp.commandv("seek", "10")` di Lua. Anda tidak sedang belajar dua sintaks — Anda belajar satu daftar command dan tiga cara memanggilnya (flat string di input.conf, array di `mp.commandv`, table bernama di `mp.command_native`).

Tiga lapis konfigurasi yang akan Anda sentuh, dari yang paling deklaratif ke paling prosedural:

| Lapis | File | Mengatur |
|---|---|---|
| **Opsi** | `mpv.conf` | Nilai default startup (video output, cache, hwdec, subtitle style, dst.) — setara `--opsi=nilai` di command line |
| **Binding** | `input.conf` | Pemetaan tombol/mouse → command, tanpa logika kondisional |
| **Logika** | `scripts/*.lua` | State, event, kondisi, UI kustom, integrasi eksternal — apapun yang butuh "jika-maka" |

Satu lagi konsep penting yang akan sering muncul: **script bawaan mpv juga cuma Lua/C biasa**. Fitur seperti OSC (on-screen controller/tombol play-pause visual), `stats` (statistik `i`/`I`), `console` (konsol `` ` ``), dan `select` (menu interaktif `g-...`) bukan bagian "inti" C yang tak tersentuh — itu adalah script yang di-*bundle* dan dimuat otomatis (`mp_load_builtin_scripts()`). Ini penting karena berarti Anda bisa mempelajari cara kerjanya dari kode sumbernya sendiri, dan API yang mereka pakai (`mp.*`) sama dengan yang tersedia untuk script Anda.

---

## 1. Pintasan & Fungsionalitas Default (Sebelum Konfigurasi)

Beberapa hal wajib dipahami dulu soal daftar di bawah:

- **Default binding di-hardcode ke dalam binary.** File `etc/input.conf` di source mpv sengaja penuh tanda `#` di depan setiap baris — ini bukan berarti "nonaktif". Menurut catatan developer di file itu sendiri: saat proses kompilasi, seluruh baris di-*uncomment* otomatis dan dibakar (baked-in) ke binary. Jadi apa yang tampak seperti komentar di GitHub adalah **default sesungguhnya** yang aktif di binary Anda, kecuali Anda menjalankan dengan `--no-input-default-bindings`.
- Anda bisa mengecek binding aktual di sistem Anda kapan saja dengan `mpv --input-test --force-window --idle` (menampilkan binding di OSD alih-alih menjalankannya), atau menekan `?` saat mpv berjalan (memanggil script `stats` bawaan untuk menampilkan seluruh daftar binding).
- Kolom "Command" di tabel bawah menunjukkan command persis yang dipanggil — berguna karena command ini juga yang akan Anda pakai kalau ingin memanggilnya sendiri dari Lua (`mp.commandv(...)`).

### 1.1 Kontrol Playback Inti

| Tombol | Command | Fungsi |
|---|---|---|
| `SPACE`, `p`, `PLAY`, `PAUSE`, `PLAYPAUSE` | `cycle pause` | Jeda / lanjutkan pemutaran |
| `PLAYONLY` | `set pause no` | Paksa lanjutkan (bukan toggle) |
| `PAUSEONLY` | `set pause yes` | Paksa jeda (bukan toggle) |
| `.` | `frame-step` | Maju satu frame lalu jeda |
| `,` | `frame-back-step` | Mundur satu frame lalu jeda |
| `[` | `multiply speed 1/1.1` | Turunkan kecepatan ~10% |
| `]` | `multiply speed 1.1` | Naikkan kecepatan ~10% |
| `{` | `multiply speed 0.5` | Kecepatan setengah |
| `}` | `multiply speed 2.0` | Kecepatan dua kali |
| `BS` (Backspace) | `set speed 1` | Reset kecepatan ke normal |
| `q` | `quit` | Keluar |
| `Q` | `quit-watch-later` | Keluar sambil menyimpan posisi tonton (resume) |
| `ESC` | `set fullscreen no` | Keluar dari fullscreen |
| `POWER`, `STOP`, `CLOSE_WIN`, `ctrl+w` | `quit` | Keluar (tombol media/OS) |
| `ctrl+c` | `quit 4` | Keluar dengan exit code 4 |
| `Shift+BS` | `revert-seek` | Batalkan seek terakhir |
| `Shift+Ctrl+BS` | `revert-seek mark` | Tandai posisi untuk revert-seek |

### 1.2 Seeking & Navigasi Waktu

| Tombol | Command | Fungsi |
|---|---|---|
| `RIGHT` / `LEFT` | `seek 5` / `seek -5` | Maju/mundur 5 detik (mode keyframe, cepat tapi tidak presisi) |
| `UP` / `DOWN` | `seek 60` / `seek -60` | Maju/mundur 1 menit |
| `Shift+RIGHT` / `Shift+LEFT` | `no-osd seek 1 exact` / `-1 exact` | Seek presisi ±1 detik (lambat tapi akurat) |
| `Shift+UP` / `Shift+DOWN` | `no-osd seek 5 exact` / `-5 exact` | Seek presisi ±5 detik |
| `Ctrl+LEFT` / `Ctrl+RIGHT` | `no-osd sub-seek -1` / `1` | Loncat ke subtitle sebelumnya/berikutnya |
| `Ctrl+Shift+LEFT` / `RIGHT` | `sub-step -1` / `1` | Geser waktu tampil subtitle tanpa memindah video |
| `HOME` | `seek 0 absolute` | Loncat ke awal file |
| `PGUP` / `PGDWN` | `add chapter 1` / `-1` | Chapter berikutnya/sebelumnya |
| `Shift+PGUP` / `Shift+PGDWN` | `seek 600` / `-600` | Maju/mundur 10 menit |
| `FORWARD` / `REWIND` | `seek 60` / `-60` | Tombol media maju/mundur |
| `!` / `@` *(legacy)* | `add chapter -1` / `1` | Alias lama untuk navigasi chapter |

> Catatan penting soal *scalable command*: `seek`, `add`, `cycle`, dan `script-binding` bersifat **scalable** — jika diikat ke `WHEEL_*` pada perangkat presisi tinggi (touchpad), nilainya otomatis diskalakan mengikuti kecepatan scroll. Gunakan prefiks `nonscalable` kalau Anda ingin nilai tetap diskrit.

### 1.3 Volume & Audio

| Tombol | Command | Fungsi |
|---|---|---|
| `9`, `/`, `KP_DIVIDE`, `VOLUME_DOWN` | `add volume -2` | Turunkan volume |
| `0`, `*`, `KP_MULTIPLY`, `VOLUME_UP` | `add volume 2` | Naikkan volume |
| `m`, `MUTE` | `cycle mute` | Bisu/lawan bisu |
| `ctrl++` / `ctrl+KP_ADD` | `add audio-delay 0.1` | Tunda audio 100 ms (sinkronisasi) |
| `ctrl+-` / `ctrl+KP_SUBTRACT` | `add audio-delay -0.1` | Percepat audio 100 ms |

### 1.4 Penyesuaian Gambar (Video)

| Tombol | Command | Fungsi |
|---|---|---|
| `1` / `2` | `add contrast -1` / `1` | Kontras |
| `3` / `4` | `add brightness -1` / `1` | Kecerahan |
| `5` / `6` | `add gamma -1` / `1` | Gamma |
| `7` / `8` | `add saturation -1` / `1` | Saturasi warna |
| `Alt+0` / `Alt+1` / `Alt+2` | `set window-scale 0.5` / `1` / `2` | Ukuran jendela ½× / 1× / 2× |
| `b` | `cycle deband` | Toggle filter debanding |
| `d` | `cycle deinterlace` | Toggle deinterlacing |
| `w` / `e` | `add panscan -0.1` / `+0.1` | Panscan (crop letterbox) |
| `W` | `add panscan +0.1` | Sama seperti `e` |
| `A` | `cycle-values video-aspect-override "16:9" "4:3" "2.35:1" "no"` | Paksa rasio aspek |
| `ctrl+h` | `cycle-values hwdec no auto` | Toggle hardware decoding |
| `F9` | `show-text ${track-list}` | Tampilkan daftar track video/audio/sub |

### 1.5 Zoom, Pan, Rotate, Align

Grup ini sepenuhnya bekerja dengan memodifikasi *property* (`video-zoom`, `video-pan-x/y`, `video-scale-x/y`, `video-align-x/y`, `video-rotate`) via command `add`/`set`.

| Tombol | Command | Fungsi |
|---|---|---|
| `Alt+←/→` | `add video-pan-x 0.1` / `-0.1` | Geser video kanan/kiri |
| `Alt+↑/↓` | `add video-pan-y 0.1` / `-0.1` | Geser video bawah/atas |
| `Alt++`, `ZOOMIN`, `Alt+KP_ADD` | `add video-zoom 0.1` | Perbesar |
| `Alt+-`, `ZOOMOUT`, `Alt+KP_SUBTRACT` | `add video-zoom -0.1` | Perkecil |
| `Ctrl+WHEEL_UP/DOWN` | `script-binding positioning/cursor-centric-zoom` | Zoom terpusat ke posisi kursor |
| `Alt+BS` | reset zoom, panscan, pan, align ke 0 | Reset total posisi/skala video |
| `Alt+KP1` / `Alt+KP3` | `add video-rotate -1` / `1` (repeatable) | Rotasi berlahan berlawanan/searah jarum jam |
| `Alt+KP5` | `set video-rotate 0` | Reset rotasi |
| `KP1` / `KP9` | `add video-zoom -0.01` / `0.01` | Zoom halus |
| `KP2` / `KP8` | `add video-scale-y -0.01` / `0.01` | Skala vertikal halus |
| `KP4` / `KP6` | `add video-scale-x -0.01` / `0.01` | Skala horizontal halus |
| `KP5` | reset `video-scale-x/y` ke 1, `video-zoom` ke 0 | Reset skala |
| `Ctrl+KP1`…`KP9` (numpad arah) | kombinasi `video-pan-x/y ±0.01` | Geser video mengikuti arah numpad (diagonal termasuk) |
| `Ctrl+KP_HOME/END/UP/DOWN/LEFT/RIGHT/PGUP/PGDWN` | kombinasi `video-align-x/y ±0.01` | Atur titik jangkar (alignment) video |
| `Ctrl+KP_BEGIN` | reset `video-align-x/y` ke 0 | Reset alignment |

### 1.6 Subtitle

| Tombol | Command | Fungsi |
|---|---|---|
| `z` | `add sub-delay -0.1` | Subtitle tampil 100 ms lebih awal |
| `Z`, `x` | `add sub-delay 0.1` | Subtitle tampil 100 ms lebih lambat |
| `G` | `add sub-scale 0.1` | Perbesar ukuran font subtitle |
| `F` | `add sub-scale -0.1` | Perkecil ukuran font subtitle |
| `r` | `add sub-pos -1` | Geser subtitle ke atas |
| `R`, `t` | `add sub-pos +1` | Geser subtitle ke bawah |
| `v` | `cycle sub-visibility` | Sembunyikan/tampilkan subtitle |
| `Alt+v` | `cycle secondary-sub-visibility` | Sembunyikan/tampilkan subtitle sekunder |
| `V` | `cycle sub-ass-use-video-data` | Perbaiki file ASS yang menyalahi data video |
| `u` | `cycle-values sub-ass-override "force" "scale"` | Toggle override style SSA/ASS |
| `j` | `cycle sub` | Ganti track subtitle |
| `J` | `cycle sub down` | Ganti track subtitle (arah mundur) |

### 1.7 Pemilihan Track & Edition

| Tombol | Command | Fungsi |
|---|---|---|
| `SHARP` (`#`) | `cycle audio` | Ganti track audio |
| `_` | `cycle video` | Ganti track video |
| `E` | `cycle edition` | Ganti edition (mis. cut berbeda di Matroska) |

### 1.8 Screenshot

| Tombol | Command | Fungsi |
|---|---|---|
| `s` | `screenshot` | Screenshot resolusi asli **dengan** subtitle |
| `S` | `screenshot video` | Screenshot resolusi asli **tanpa** subtitle |
| `Ctrl+s` | `screenshot window` | Screenshot seisi jendela (dengan OSD + subtitle) |
| `Alt+s` | `screenshot each-frame` | Screenshot otomatis tiap frame (tekan lagi untuk stop) |

### 1.9 Playlist

| Tombol | Command | Fungsi |
|---|---|---|
| `>`, `ENTER`, `NEXT` | `playlist-next` | File berikutnya |
| `<`, `PREV` | `playlist-prev` | File sebelumnya |
| `Shift+HOME` | `no-osd set playlist-pos 0` | Loncat ke file pertama |
| `Shift+END` | `no-osd set playlist-pos-1 ${playlist-count}` | Loncat ke file terakhir |
| `F8` | `show-text ${playlist}` | Tampilkan seluruh playlist |
| `l` | `ab-loop` | Set titik A → set titik B → hapus keduanya (siklus 3 tahap) |
| `L` | `cycle-values loop-file inf no` | Toggle loop file saat ini tanpa batas |

### 1.10 Window, OSD & Tampilan Umum

| Tombol | Command | Fungsi |
|---|---|---|
| `T` | `cycle ontop` | Selalu di atas jendela lain |
| `f` | `cycle fullscreen` | Toggle fullscreen |
| `O` | `no-osd cycle-values osd-level 3 1` | Toggle OSD selalu tampil vs hanya saat interaksi |
| `o`, `P` | `show-progress` | Tampilkan progress bar |
| `i` | `script-binding stats/display-stats` | Tampilkan panel statistik |
| `I` | `script-binding stats/display-stats-toggle` | Toggle panel statistik (tetap terbuka) |
| `?` | `script-binding stats/display-page-4-toggle` | Toggle daftar seluruh key binding aktif |
| `` ` `` | `script-binding commands/open` | Buka konsol interaktif |
| `DEL` | `script-binding osc/visibility` | Siklus visibilitas OSC: never → auto → always |
| `MENU`, `ctrl+p`, `Shift+F10` | `script-binding select/context-menu` / `select/menu` | Buka menu konteks |

### 1.11 Menu Interaktif "Select" (prefiks `g`)

Sejak beberapa versi terakhir, mpv menyertakan script bawaan `select` untuk menu pemilihan interaktif. Semua diakses lewat prefiks `g` diikuti huruf kedua (key *sequence*, bukan kombinasi tombol):

| Urutan Tombol | Fungsi |
|---|---|
| `g-p` | Pilih entri playlist |
| `g-s` / `g-S` | Pilih subtitle track / subtitle track sekunder |
| `g-a` | Pilih audio track |
| `g-v` | Pilih video track |
| `g-t` | Pilih track (generik) |
| `g-c` | Pilih chapter |
| `g-e` | Pilih edition |
| `g-l` / `g-L` | Pilih baris subtitle / subtitle sekunder (loncat berdasar isi teks) |
| `g-d` | Pilih perangkat audio output |
| `g-h` | Riwayat tontonan (watch history) |
| `g-w` | Daftar watch-later |
| `g-b` | Cari/pilih key binding aktif |
| `g-r` | Tampilkan seluruh property saat ini |
| `g-m` | Buka menu utama |

### 1.12 Mouse & Wheel

Perlu digarisbawahi: **klik kiri mouse defaultnya `ignore`** (tidak melakukan apa-apa) di level core — perilaku "klik kiri = play/pause" yang sering dikira default sebenarnya datang dari OSC (script bawaan), bukan binding inti.

| Input | Command | Fungsi |
|---|---|---|
| `MBTN_LEFT` | `ignore` | Tidak melakukan apa-apa (di level core) |
| `MBTN_LEFT_DBL` | `cycle fullscreen` | Klik ganda → toggle fullscreen |
| `MBTN_RIGHT` | `script-binding select/context-menu` | Klik kanan → menu konteks |
| `MBTN_BACK` / `MBTN_FORWARD` | `playlist-prev` / `playlist-next` | Tombol samping mouse |
| `Ctrl+MBTN_LEFT` | `script-binding positioning/drag-to-pan` | Tahan Ctrl + drag untuk pan |
| `WHEEL_UP` / `WHEEL_DOWN` | `add volume 2` / `-2` | Scroll untuk volume |
| `WHEEL_LEFT` / `WHEEL_RIGHT` | `seek -10` / `10` | Scroll horizontal untuk seek |

### 1.13 Lain-lain yang Sering Terlewat

| Tombol | Command | Fungsi |
|---|---|---|
| `Ctrl+v` | `update-clipboard`; `loadfile ${clipboard/text} append-play` | Tempel path dari clipboard langsung sebagai file |
| `Ctrl+r` | set ulang `start` lalu `playlist-play-index current` | Muat ulang file yang sedang diputar |

**Nama key spesial yang perlu dikenal** (dari `--input-keylist`): `KP*` (numpad), `MOUSE_BTN*`/`MBTN*`, `WHEEL_*` (pengganti `MOUSE_BTN3-6` yang deprecated), `*_DBL` (klik ganda), `MOUSE_MOVE`/`MOUSE_ENTER`/`MOUSE_LEAVE`, `CLOSE_WIN` (tombol close OS), `GAMEPAD_*`, `UNMAPPED` (tangkap semua key yang belum terikat), `ANY_UNICODE` (tangkap semua key penghasil teks). Modifier: `Shift`, `Ctrl`, `Alt`, `Meta` — digabung dengan `+` (mis. `ctrl+shift+a`).

Semua binding di atas bisa dinonaktifkan total dengan `--no-input-default-bindings`, atau per-tombol dengan menimpanya jadi `ignore` di `input.conf` Anda sendiri — ini akan jadi pola yang sering Anda pakai begitu masuk ke kustomisasi.

## 2. Arsitektur & Referensi API Lua

### 2.0 Siklus Hidup Script — Wajib Dipahami Sebelum Baris Kode Pertama

mpv memuat script dari folder `scripts/` di config directory (atau via `--script=path`), **satu thread per script**. Alurnya:

1. Script dijalankan "apa adanya" dari atas ke bawah — ini fase setup (daftarkan key binding, event handler, dsb).
2. Setelah kode top-level selesai, mpv otomatis memanggil `mp_event_loop` (didefinisikan di prelude internal) yang menunggu event dan memanggil handler yang sudah Anda daftarkan.
3. Saat mpv keluar, semua script menerima event `shutdown`, yang secara default menghentikan event loop.

**Konsekuensi praktis paling penting:** karena script mulai berjalan **paralel** dengan inisialisasi player, banyak *property* belum tentu terisi nilai bermakna di saat baris pertama script Anda dieksekusi. **Jangan** membaca property langsung di top-level script dan berharap nilainya sudah final — gunakan `mp.observe_property` atau baca di dalam event handler (mis. `file-loaded`).

```lua
-- SALAH: filename mungkin belum ter-set saat baris ini jalan
local f = mp.get_property("filename")

-- BENAR: tunggu event yang menjamin state sudah siap
mp.register_event("file-loaded", function()
    local f = mp.get_property("filename")
end)
```

---

### 2.1 Eksekusi Command — `mp.command*`

Empat fungsi ini adalah jembatan ke seluruh **List of Input Commands** (command yang sama dengan yang dipakai di `input.conf`).

| Fungsi | Kapan dipakai |
|---|---|
| `mp.command(string)` | Command tunggal, gaya string mentah (rawan masalah quoting jika ada spasi/karakter khusus) |
| `mp.commandv(arg1, arg2, ...)` | Command + argumen sebagai parameter terpisah — aman dari masalah quoting |
| `mp.command_native(table [, def])` | Argumen sebagai Lua table, mendukung tipe native (boolean/number) & **named argument** |
| `mp.command_native_async(table [, fn])` | Sama seperti `command_native`, tapi non-blocking; `fn(success, result, error)` dipanggil saat selesai |
| `mp.abort_async_command(t)` | Batalkan command async yang sedang berjalan (`t` = return value dari `command_native_async`) |

```lua
-- Alur minimal yang wajib dikuasai:
mp.commandv("seek", "10", "relative")                 -- array-style
mp.command_native({"show-text", "Halo dari Lua"})       -- table sebagai array

-- named argument (WAJIB untuk command dengan banyak parameter, mis. subprocess)
local result = mp.command_native({
    name = "subprocess",
    playback_only = false,
    capture_stdout = true,
    args = {"echo", "hai"},
})
if result.status == 0 then
    mp.msg.info("output: " .. result.stdout)
end
```

Property **tidak** ikut ter-expand otomatis di `commandv`/`command_native` (berbeda dengan `input.conf`, yang secara default mengekspansi `${nama-property}`). Gunakan `mp.get_property()` untuk mengambil nilainya secara eksplisit, atau prefiks `expand-properties` bila memang perlu.

---

### 2.2 Property — Baca & Tulis State Player

Property adalah cara utama mpv mengekspos *state* (posisi, volume, daftar track, dst). Hampir semua opsi command-line juga tersedia sebagai property dengan nama sama (tanpa `--`).

| Fungsi | Tipe kembalian |
|---|---|
| `mp.get_property(name [, def])` | string |
| `mp.get_property_osd(name [, def])` | string, diformat gaya tampilan OSD |
| `mp.get_property_bool(name [, def])` | boolean |
| `mp.get_property_number(name [, def])` | number |
| `mp.get_property_native(name [, def])` | tipe Lua terbaik (termasuk table untuk property kompleks, mis. `track-list`) |
| `mp.set_property(name, value)` | — (set sebagai string) |
| `mp.set_property_bool/number/native(name, value)` | — (set dengan tipe eksplisit) |
| `mp.del_property(name)` | — (hapus; sebagian besar property tak bisa dihapus) |

```lua
local is_paused = mp.get_property_bool("pause", false)
local tracks     = mp.get_property_native("track-list")   -- table of tables

mp.set_property("volume", "70")
mp.set_property_bool("mute", true)
```

**Aturan aman:** selalu sertakan argumen `def` (default) — kegagalan mengambil property (file belum dimuat, property tak tersedia di kondisi tertentu) akan mengembalikan nilai default itu alih-alih meledakkan script Anda dengan `nil`.

---

### 2.3 Key Binding — `mp.add_key_binding` & Kerabatnya

```lua
mp.add_key_binding(key, name, fn, flags)
```

- `key`: nama tombol fisik (kosong/`nil` = tidak bind ke tombol apapun, hanya bisa dipanggil user via remap manual).
- `name`: identifier unik (dipakai user untuk remap lewat `script-binding namaskrip/name` di `input.conf` mereka). **Harus unik per script** — nama yang sama menimpa binding sebelumnya.
- `flags` (table opsional): `repeatable` (aktifkan key-repeat), `scalable` (untuk mode `complex`), `complex` (fn menerima table detail event, bukan dipanggil tanpa argumen).

| Varian | Perbedaan |
|---|---|
| `mp.add_key_binding` | Menimpa **default binding** saja; kalah prioritas dari binding user di `input.conf` |
| `mp.add_forced_key_binding` | Menimpa **default DAN binding user** — pakai hati-hati, ini scalpel, bukan pisau roti |
| `mp.remove_key_binding(name)` | Hapus binding (hanya jika didaftarkan dengan `name` eksplisit) |

```lua
mp.add_key_binding("x", "toggle-fitur-saya", function()
    mp.osd_message("Fitur di-toggle")
end, { repeatable = true })

-- Mode complex: dapat detail down/repeat/up
mp.add_key_binding("y", "detail-key", function(table)
    print(table.event, table.key_name, table.is_mouse)
end, { complex = true })
```

Dengan binding di atas, user tetap bisa me-remap `x` ke tombol lain lewat `input.conf` mereka:
```
z script-binding toggle-fitur-saya
```

---

### 2.4 & 2.5 Event dan Observasi Property — Dua Cara "Bereaksi"

Ini adalah dua mekanisme reaktif yang paling sering disalahpahami sebagai hal yang sama, padahal berbeda tujuan:

| Mekanisme | Bereaksi terhadap | Contoh pemakaian |
|---|---|---|
| `mp.register_event(name, fn)` | **Kejadian diskrit** sekali terjadi (file dimuat, seek, shutdown) | Reset state kustom setiap ganti file |
| `mp.observe_property(name, type, fn)` | **Perubahan nilai** yang dilacak terus-menerus | Sinkronkan UI kustom dengan status pause/volume |

```lua
-- Event: reaksi terhadap kejadian
mp.register_event("file-loaded", function()
    mp.osd_message("File baru dimuat: " .. mp.get_property("filename"))
end)
mp.unregister_event(fn)  -- lepas handler (bandingkan fn dengan == biasa)

-- Observasi: reaksi terhadap perubahan nilai
mp.observe_property("pause", "bool", function(name, value)
    mp.osd_message(value and "⏸ Pause" or "▶ Play")
end)
mp.unobserve_property(fn)
```

Detail perilaku `observe_property` yang wajib diketahui:
- **Selalu dipanggil sekali di awal** (initial notification) — bukan hanya saat berubah, jadi jangan kaget kalau handler Anda langsung terpanggil begitu didaftarkan.
- Perubahan beruntun dalam waktu singkat **di-koalesce** — hanya nilai terakhir yang memicu callback.
- `type` sebaiknya selalu eksplisit (`"bool"`, `"string"`, `"number"`, `"native"`). Kalau diisi `"none"`/`nil`, handler bisa terpanggil sporadis **walau nilai tidak benar-benar berubah** — hindari kecuali Anda memang hanya butuh notifikasi "sesuatu terjadi".

---

### 2.6 Timer — `mp.add_timeout` & `mp.add_periodic_timer`

```lua
mp.add_timeout(seconds, fn [, disabled])          -- sekali tembak (one-shot)
mp.add_periodic_timer(seconds, fn [, disabled])   -- berulang
```

Keduanya mengembalikan *timer object* dengan method: `:stop()` (jeda, ingat progres), `:kill()` (jeda, reset progres), `:resume()` (lanjutkan), `:is_enabled()`, serta field `.timeout` (RW) dan `.oneshot` (RW, boolean).

```lua
local detik = 0
local t = mp.add_periodic_timer(1, function()
    detik = detik + 1
    if detik >= 10 then t:kill() end   -- ingat: pakai ':' bukan '.'
end)
```

Resolusi timer bisa serendah ~50 ms — jangan andalkan untuk sinkronisasi presisi tinggi (mis. audio sync); untuk itu, pakai property waktu playback (`time-pos`, `audio-pts`) sebagai sumber kebenaran.

---

### 2.7 Info & Utilitas Skrip

| Fungsi | Fungsi |
|---|---|
| `mp.get_opt(key)` | Baca satu nilai mentah dari `--script-opts` (semua script berbagi namespace ini — hati-hati koalisi nama) |
| `mp.get_script_name()` | Nama script saat ini (dari nama file, non-alfanumerik → `_`) |
| `mp.get_script_directory()` | Path direktori script **jika** dikemas sebagai folder (`main.lua`); kosong jika file tunggal |
| `mp.get_time()` | Waktu internal mpv (detik, offset arbitrer) — cocok untuk mengukur durasi relatif |

---

### 2.8 OSD (On-Screen Display) Kustom

| Fungsi | Fungsi |
|---|---|
| `mp.osd_message(text [, duration])` | Cara termudah menampilkan teks sementara di layar |
| `mp.create_osd_overlay(format)` | Wrapper tipis di atas command `osd-overlay` — untuk overlay ASS yang perlu diperbarui berulang |
| `mp.get_osd_size()` | Kembalikan `osd_width, osd_height, osd_par` |

```lua
mp.osd_message("Halo dunia!", 2)  -- tampil 2 detik

local ov = mp.create_osd_overlay("ass-events")
ov.data = "{\\an5}{\\b1}Teks tebal di tengah layar{\\b0}"
ov:update()     -- commit ke layar
-- ... nanti ...
ov:remove()     -- hapus dari layar
```

---

### 2.9 Fungsi Lanjutan (`mp.*` khusus situasi khusus)

| Fungsi | Fungsi |
|---|---|
| `mp.register_script_message(name, fn)` / `mp.unregister_script_message(name)` | Terima pesan dari `script-message`/`script-message-to` — fondasi komunikasi **antar-script** |
| `mp.dispatch_events([allow_wait])` | Kendali manual atas event loop (jarang dibutuhkan kecuali Anda mengganti `mp_event_loop` sendiri) |
| `mp.register_idle(fn)` / `mp.unregister_idle(fn)` | Handler yang jalan saat script "menganggur" setelah semua event diproses — berguna untuk menunda aksi sampai semua notifikasi perubahan property selesai masuk |
| `mp.enable_messages(level)` | Aktifkan penerimaan event `log-message` pada level tertentu |
| `mp.get_next_timeout()` | Waktu (detik) sampai timer berikutnya kedaluwarsa |
| `exit()` *(global, mpv ≥ 0.40)* | Hentikan script di akhir iterasi event loop saat ini, tanpa mematikan mpv |

```lua
mp.register_script_message("dari-script-lain", function(arg1, arg2)
    print("Diterima:", arg1, arg2)
end)
-- Dipanggil dari script/input.conf lain:
-- script-message-to nama_script_ini dari-script-lain halo 123
```

---

### 2.10 `mp.msg` — Logging Terstruktur

```lua
local msg = require("mp.msg")
msg.log(level, ...)   -- level: fatal | error | warn | info | v | debug | trace
msg.fatal(...) msg.error(...) msg.warn(...) msg.info(...)
msg.verbose(...) msg.debug(...) msg.trace(...)
```

Default, level `v`/`debug`/`trace` **disembunyikan** dari terminal kecuali user menaikkan verbosity (`-v`, `-v -v`, atau `--msg-level=namaskrip=debug`). Ini adalah alasan kenapa `msg.debug()` jauh lebih baik daripada `print()` untuk log internal — Anda bisa membiarkannya di kode produksi tanpa membanjiri output normal user.

---

### 2.11 `mp.options` — Opsi yang Bisa Dikonfigurasi User

Mekanisme resmi agar script Anda **bisa dikonfigurasi tanpa mengedit kode**.

```lua
local options = {
    opsi_a = "nilai_default",
    opsi_b = -0.5,
    opsi_c = true,   -- tipe default menentukan cara parsing nilai dari file/CLI
}
require("mp.options").read_options(options, "namascript", function(list)
    -- dipanggil saat script-opts berubah saat runtime (jika on_update diisi)
end)
print(options.opsi_a)
```

Setelah dipanggil, user bisa override lewat:
- File `script-opts/namascript.conf` di config directory (format `kunci=nilai`, boolean pakai `yes`/`no`).
- CLI: `--script-opts=namascript-opsi_a=Halo,namascript-opsi_b=10`.

**Jangan pernah** memakai `nil` sebagai nilai default di table `options` — tipe nilai default menentukan bagaimana mpv mem-parsing input user (string vs number vs boolean), jadi `nil` bikin mpv tidak tahu harus parsing sebagai apa.

---

### 2.12 `mp.utils` — Helper Generik (Bukan Khusus Playback)

```lua
local utils = require("mp.utils")
```

| Fungsi | Fungsi |
|---|---|
| `utils.getcwd()` | Direktori tempat mpv dijalankan |
| `utils.readdir(path [, filter])` | List isi direktori; `filter`: `files`\|`dirs`\|`normal`\|`all` |
| `utils.file_info(path)` | Table: `mode, size, atime, mtime, ctime, is_file, is_dir` |
| `utils.split_path(path)` | → direktori, nama file |
| `utils.join_path(p1, p2)` | Gabungkan path (aman untuk path absolut di `p2`) |
| `utils.subprocess(t)` *(legacy)* | Wrapper lama, blocking, di atas `command_native({name="subprocess",...})` |
| `utils.subprocess_detached(t)` *(legacy)* | Jalankan proses lepas dari kendali mpv |
| `utils.getpid()` | PID proses mpv saat ini |
| `utils.get_env_list()` | Environment variable sebagai list string `"NAMA=nilai"` |
| `utils.parse_json(str [, trail])` | JSON string → Lua table |
| `utils.format_json(v)` | Lua table → JSON string |
| `utils.to_string(v)` | Representasi string dari value apapun (termasuk table) — berguna untuk debug |

> **Rekomendasi resmi dari dokumentasi mpv sendiri:** hindari `utils.subprocess`/`utils.subprocess_detached` untuk kode baru — keduanya legacy wrapper yang **blocking**. Gunakan `mp.command_native` (blocking, tapi eksplisit) atau `mp.command_native_async` (non-blocking) langsung dengan `name = "subprocess"`. Detail lengkap ada di §4.1 dan §4.7.

---

### 2.13 `mp.input` — Input Teks & Menu Seleksi Interaktif

Modul yang lebih baru, memakai console bawaan untuk mengambil input dari user.

```lua
local input = require("mp.input")

input.get({
    prompt = "Cari file: ",
    default_text = "",
    submit = function(text)
        mp.osd_message("Anda mencari: " .. text)
        input.terminate()
    end,
    complete = function(before_cursor, response_fn)
        -- tawarkan autocomplete
        response_fn({"opsi1", "opsi2"}, 1)
    end,
})

input.select({
    prompt = "Pilih track:",
    items = {"Track 1", "Track 2", "Track 3"},
    submit = function(idx)
        mp.commandv("playlist-play-index", idx - 1)
    end,
})
```

Field penting lainnya: `keep_open` (jangan tutup console setelah submit — untuk alur input berulang), `opened`/`closed` (lifecycle callback), `history_path` (simpan riwayat input antar sesi), `id` (namespace riwayat/log terpisah). `input.terminate()` menutup permintaan aktif; `input.log()`/`input.set_log()` menulis ke buffer log console yang sedang tampil.

---

### 2.14 Daftar Event Lengkap

| Event | Terjadi saat |
|---|---|
| `start-file` | Tepat sebelum file baru mulai dimuat |
| `end-file` | Setelah file di-unload. Field `reason`: `eof` \| `stop` \| `quit` \| `error` \| `redirect` \| `unknown` |
| `file-loaded` | File selesai dimuat, playback mulai |
| `seek` | Terjadi seeking (termasuk seek internal, mis. ordered chapters) |
| `playback-restart` | Playback resmi dimulai lagi setelah seek/load |
| `shutdown` | mpv akan keluar — script harus bersiap terminasi |
| `log-message` | Pesan log (perlu `mp.enable_messages` dulu); field `prefix`, `level`, `text` |
| `hook` | Trigger internal untuk mekanisme hook (lihat §2.15) |
| `property-change` | Property yang di-observe berubah nilai; field `name`, `data` |
| `video-reconfig` / `audio-reconfig` | Output video/audio atau filter chain dikonfigurasi ulang |
| `client-message` | Pesan dari `mpv_client_message` (biasanya ditangani terpisah oleh Lua) |
| `command-reply` | Balasan command async pada level client API |

*(`idle` dan `tick` masih ada tapi **deprecated** — ganti dengan `observe_property` yang jauh lebih presisi.)*

---

### 2.15 Hooks — Sinkronisasi Ketat dengan Player Core

```lua
mp.add_hook(type, priority, fn)
```

Berbeda dari event (asinkron, tembak-lupakan), **hook membuat player core menunggu** script Anda selesai sebelum melanjutkan. `priority` (integer, default netral: `50`) menentukan urutan bila beberapa script memasang hook di titik yang sama.

| Hook | Terjadi saat | Kegunaan khas |
|---|---|---|
| `on_load` | File akan dibuka, sebelum apapun terjadi | Redirect URL (`stream-open-filename`), set opsi per-file |
| `on_load_fail` | File gagal dibuka | Fallback demuxer alternatif |
| `on_preloaded` | File terbuka, sebelum track/decoder dipilih | Pilih track manual sebelum default selection jalan |
| `on_loaded` | Track sudah dipilih, sebelum playback mulai | Aksi berbasis metadata track terpilih |
| `on_unload` | Sebelum file ditutup, sebelum uninitialize | Cleanup state (playback belum bisa dilanjutkan di titik ini) |
| `on_before_start_file` | Sebelum event `start-file` dikirim | Drain perubahan property sebelum file baru |
| `on_after_end_file` | Setelah event `end-file` | Drain perubahan property setelah file selesai |

`fn(hook)` menerima objek dengan dua method krusial:
- `hook:cont()` — **wajib dipanggil** akhirnya, atau mpv akan menunggu selamanya (freeze).
- `hook:defer()` — beri tahu mpv "saya belum selesai, saya akan panggil `cont()` sendiri nanti" (dipakai bila Anda perlu operasi async di dalam hook, mis. `command_native_async`).

```lua
mp.add_hook("on_load", 50, function(hook)
    local url = mp.get_property("stream-open-filename")
    if url:find("^ytdl://") then
        -- contoh: modifikasi/redirect sebelum dibuka
        mp.set_property("stream-open-filename", url)
    end
    hook:cont()   -- tanpa ini, mpv menggantung di titik loading file
end)
```

---

### 2.16 Prefiks Command (Input Command Prefixes)

Ditulis sebelum nama command (bisa digabung, dipisah spasi). Paling relevan untuk Lua:

| Prefiks | Efek |
|---|---|
| `no-osd` | Jangan tampilkan apapun ke OSD untuk command ini |
| `osd-bar` / `osd-msg` / `osd-msg-bar` | Paksa tampilkan progress bar / pesan teks / keduanya |
| `raw` | Jangan expand property di argumen string (default untuk sebagian besar API scripting) |
| `expand-properties` | Expand `${nama-property}` di argumen (default untuk `input.conf`, **bukan** default di Lua) |
| `repeatable` / `nonrepeatable` | Paksa aktif/nonaktifkan key-repeat |
| `nonscalable` | Nonaktifkan scaling otomatis untuk `WHEEL_*`/touchpad presisi tinggi |
| `async` / `sync` | Minta eksekusi non-blocking/blocking (hanya efektif untuk command yang memang mendukungnya) |

---

### 2.17 Prioritas Key Binding (Siapa Menang Kalau Bentrok)

Urutan prioritas dari yang paling mudah ditimpa ke paling "keras kepala":

```
default binding (etc/input.conf, hardcoded)
        ↓ ditimpa oleh
user input.conf
        ↓ ditimpa oleh
mp.add_key_binding()          -- masih kalah dari user input.conf!
        ↓ ditimpa oleh
mp.add_forced_key_binding()   -- menang atas SEMUANYA
```

Poin yang sering bikin bug: `mp.add_key_binding` **hanya** menimpa default C, bukan `input.conf` milik user. Kalau user sudah mem-bind tombol yang sama secara manual, binding Anda dari script **tidak akan terpicu** kecuali user secara eksplisit me-remap ke `script-binding namaskrip/nama`. Ini disengaja (menghormati preferensi user), tapi sering disalahartikan sebagai bug script.

## 3. Roadmap Tutorial: Dasar → Mahir

Filosofi roadmap ini: **setiap tingkat harus bisa dites dan berjalan sebelum lanjut ke tingkat berikutnya.** Jangan menulis 300 baris Lua dulu baru dites — itu resep debugging yang menyakitkan. Struktur tiap tingkat: apa yang dipelajari → target konkret → kode minimal → cara verifikasi.

### Tingkat 0 — Fondasi: `mpv.conf`

**Dipelajari:** mpv.conf hanyalah daftar `opsi=nilai`, satu opsi per baris, tanpa `--` di depan (berbeda dari command line). Lokasi standar: Linux/macOS/Termux → `~/.config/mpv/mpv.conf`; Windows → `%APPDATA%\mpv\mpv.conf` (fallback: `portable_config\mpv.conf` di sebelah `mpv.exe`); mpv-android (APK GUI) → kelola lewat menu dalam-app karena lokasinya bergantung versi Android & scoped storage — cek langsung di pengaturan aplikasinya.

**Target konkret:** mpv.conf minimal yang benar-benar terbaca.

```ini
# mpv.conf — baseline
hwdec=auto-safe
cache=yes
save-position-on-quit=yes

[hd-video]
profile-desc="Profil untuk video HD ke atas"
profile-cond=width >= 1280
deband=yes
```

**Verifikasi:** `mpv --show-profile=hd-video` menampilkan isi profil tanpa error. Kalau ada typo opsi, mpv akan cetak warning ke terminal saat start — **selalu jalankan dari terminal**, bukan dari file manager, selama tahap belajar.

---

### Tingkat 1 — Kustomisasi `input.conf`

**Dipelajari:** sintaks `[modifier+]KEY [{section}] command [; command2] [# komentar]`. Untuk unbind tombol default tanpa mematikan semuanya, pakai `ignore`, jangan hapus baris (hapus baris tidak mematikan default C, cuma menghilangkan override Anda).

```
# ~/.config/mpv/input.conf
ctrl+s no-osd screenshot subtitles  # override Ctrl+S bawaan
F ignore                            # matikan binding F yang tak dipakai
a-b-c show-text "Berhasil menekan a, lalu b, lalu c"   # key sequence
```

**Konsep penting:** key sequence (`a-b-c`) butuh trik `ignore` di titik potensial bentrok kalau ada binding tunggal yang tumpang tindih (lihat §4.3). Uji dengan `mpv --input-test --force-window --idle` — tekan tombol, lihat command apa yang tertangkap di OSD, sebelum menganggap binding "tidak jalan".

---

### Tingkat 2 — Script Lua Pertama

**Dipelajari:** lokasi (`scripts/nama.lua`), pola dasar fungsi + registrasi, dan cara debug paling murah: `print()`/`mp.msg.info()` ke terminal.

```lua
-- scripts/halo.lua
function on_pause_change(name, value)
    if value then
        mp.osd_message("⏸ Dijeda")
    end
end
mp.observe_property("pause", "bool", on_pause_change)
```

**Verifikasi wajib:** jangan taruh langsung di folder `scripts/` dulu. Jalankan eksplisit:
```bash
mpv --script=./halo.lua --msg-level=all=info video.mp4
```
Perhatikan terminal — error syntax Lua akan tercetak dengan nomor baris. Baru pindahkan ke `scripts/` setelah tidak ada error saat start.

---

### Tingkat 3 — Script Berbasis State (Property + Timer + Key Binding)

**Dipelajari:** menggabungkan tiga primitif dasar jadi satu fitur nyata: toggle yang punya state, memberi feedback OSD, dan bisa di-remap user.

```lua
-- Fitur: hitung mundur otomatis-pause, bisa di-toggle dengan tombol 'z'
local aktif = false
local timer = nil

local function matikan()
    mp.set_property_bool("pause", true)
    mp.osd_message("⏰ Auto-pause aktif")
end

mp.add_key_binding("z", "toggle-auto-pause", function()
    aktif = not aktif
    if aktif then
        timer = mp.add_timeout(1800, matikan)   -- 30 menit
        mp.osd_message("Auto-pause: ON (30 menit)")
    else
        if timer then timer:kill() end
        mp.osd_message("Auto-pause: OFF")
    end
end)
```

**Checkpoint sebelum lanjut:** Anda harus bisa menjelaskan sendiri kenapa `timer:kill()` dan bukan `timer:stop()` yang dipakai di sini (petunjuk: `kill()` reset progres — cocok untuk cancel total, bukan sekadar jeda).

---

### Tingkat 4 — OSD/ASS Kustom (UI Melampaui `show-text`)

**Dipelajari:** `create_osd_overlay` + tag ASS dasar untuk tampilan yang tak bisa dicapai `osd_message` biasa (posisi presisi, multi-baris terformat, warna).

```lua
local overlay = mp.create_osd_overlay("ass-events")

local function render()
    local pos = mp.get_property_number("percent-pos", 0)
    overlay.data = string.format(
        "{\\an7}{\\fs28}{\\c&H00FF00&}Progres: %.0f%%",  -- \an7 = pojok kiri-atas
        pos
    )
    overlay:update()
end

mp.observe_property("percent-pos", "number", render)
```

Tag ASS minimum yang wajib dikuasai: `{\an1-9}` (posisi jangkar, mengikuti tata letak numpad), `{\b1}`/`{\b0}` (bold on/off), `{\fs<n>}` (ukuran font), `{\c&Hbbggrr&}` (warna, urutan **BGR** bukan RGB — sumber bug klasik). Selengkapnya di §4.2.

---

### Tingkat 5 — Async & Integrasi Proses Eksternal

**Dipelajari:** memanggil program luar (`yt-dlp`, `ffmpeg`, `notify-send`) **tanpa** membekukan script.

```lua
mp.add_key_binding("n", "notif-judul", function()
    mp.command_native_async({
        name = "subprocess",
        playback_only = false,
        args = {"notify-send", "mpv", mp.get_property("media-title", "?")},
    }, function(success, result, err)
        if not success then
            mp.msg.error("Gagal kirim notifikasi: " .. tostring(err))
        end
    end)
end)
```

**Kenapa ini tingkat tersendiri, bukan sisipan di tingkat 3:** ini titik paling umum orang menulis script yang "terasa nge-lag" — panggilan `subprocess` blocking (baik lewat `mp.command_native` sync maupun `utils.subprocess` legacy) akan menahan **seluruh event loop script itu** sampai proses eksternal selesai. Detail penuh di §4.1.

---

### Tingkat 6 — Hooks & Kendali Siklus Hidup Lanjutan

**Dipelajari:** menyisipkan logika **sebelum** mpv menyelesaikan pemuatan file — sesuatu yang tidak bisa dilakukan event biasa karena event bersifat "sudah terjadi, tinggal diberitahu", sedangkan hook bersifat "belum boleh lanjut sebelum saya izinkan".

```lua
mp.add_hook("on_load", 50, function(hook)
    local path = mp.get_property("stream-open-filename", "")
    if path:match("%.corrupt$") then
        mp.set_property("file-local-options/pause", "yes")  -- contoh: paksa pause file tertentu
    end
    hook:cont()
end)
```

**Checkpoint:** pahami betul kapan harus `defer()` — yaitu kalau di dalam hook Anda memanggil sesuatu yang async (mis. query jaringan sebelum memutuskan URL final). Lupa `cont()`/`defer()`+`cont()` yang benar = mpv **menggantung** total, bukan cuma script Anda.

---

### Tingkat 7 — Arsitektur Skrip Profesional (Multi-File, Terdistribusi, Terkonfigurasi)

**Dipelajari:** pola yang dipakai script populer di ekosistem mpv (uosc, thumbfast, sponsorblock) sehingga kode Anda bisa tumbuh tanpa menjadi satu file 2000 baris yang tak terbaca.

**Struktur direktori** (script sebagai folder, bukan file tunggal):
```
scripts/
└── nama-script/
    ├── main.lua          # entry point — WAJIB nama ini
    ├── modules/
    │   ├── ui.lua
    │   └── state.lua
    └── data/
        └── default.json
```

```lua
-- main.lua
package.path = mp.get_script_directory() .. "/modules/?.lua;" .. package.path
local ui    = require("ui")
local state = require("state")
```

**Konfigurasi via `mp.options`** (bukan hardcode nilai di kode):
```lua
local opts = { warna = "FFFFFF", durasi = 3 }
require("mp.options").read_options(opts, "nama-script")
```

**Komunikasi antar-script** lewat `script-message-to` — pola ini yang dipakai `thumbfast` untuk "mendengarkan" OSC script mana pun yang aktif tanpa hard-dependency satu sama lain.

**Distribusi & update:** jadikan folder script repositori git dengan `main.lua` di root — update jadi `git pull`, bukan copy-paste manual berulang; submodule untuk berbagi library antar-script Anda sendiri.

Ini adalah tingkat di mana Anda berhenti "menulis script" dan mulai "merancang sistem kecil" — mindset insinyur perangkat lunak biasa mulai relevan di sini: pemisahan tanggung jawab modul, konfigurasi eksternal, dan kemampuan diupdate tanpa mengedit ulang logika inti.

## 4. Area Paling Krusial & Tersulit — Crash Course Padat

Tujuh area ini adalah sumber 80% pertanyaan "kenapa script saya nge-lag/nge-freeze/nggak jalan" di komunitas mpv. Format tiap crash course: **masalah inti → kenapa membingungkan → solusi → kode minimal.** Tidak ada basa-basi di bagian ini, sesuai permintaan.

### 4.1 Sync vs Async — Kenapa Player Terasa "Freeze"

**Masalah inti:** Lua script mpv berjalan di satu thread dengan satu event loop. Command yang blocking (menunggu hasil sebelum lanjut baris berikutnya) menahan thread itu — selama menunggu, script tersebut **tidak bisa** memproses key binding, timer, atau event lain miliknya sendiri. Mpv secara keseluruhan (dan script LAIN) tetap jalan normal; yang beku hanya script yang memanggil blocking call itu.

**Kenapa membingungkan:** dokumentasi mpv sendiri bilang "Lua scripting interface is asynchronous from sudut pandang player core" — tapi ini tidak berarti **panggilan Anda** otomatis non-blocking. `mp.command_native` (tanpa akhiran `_async`) itu **sync by default**.

**Solusi:**
- Command cepat (set property, seek, OSD) → sync biasa, aman.
- Command yang bisa lambat/tak terduga (subprocess, network, file I/O besar) → **selalu** varian `_async`, atau prefiks `async`.
- Jangan pernah panggil `utils.subprocess` (legacy, blocking) di dalam key binding yang harus terasa instan.

```lua
-- BURUK: menahan script sampai proses selesai (bisa detik-menit)
mp.add_key_binding("g", "cari-subtitle", function()
    local r = mp.command_native({name="subprocess", args={"curl", "..."}, capture_stdout=true})
end)

-- BAIK: tidak menahan apapun
mp.add_key_binding("g", "cari-subtitle", function()
    mp.command_native_async({name="subprocess", args={"curl", "..."}, capture_stdout=true},
        function(ok, result) mp.osd_message(ok and "Selesai" or "Gagal") end)
end)
```

---

### 4.2 OSD/ASS Overlay — Merender UI Kustom dengan Benar

**Masalah inti:** `create_osd_overlay` hanyalah wrapper tipis dari command `osd-overlay` dengan format `"ass-events"` — artinya Anda menulis **subtitle ASS mentah** sebagai string, bukan API grafis level tinggi.

**Kenapa membingungkan:** urutan warna ASS adalah **BGR**, bukan RGB (`{\c&Hbbggrr&}`) — kebalikan dari intuisi web developer manapun. Selain itu `res_x`/`res_y` (default `0`/`720`) menentukan sistem koordinat virtual (`PlayResX`/`PlayResY`), bukan resolusi layar asli — jadi posisi yang Anda hitung harus relatif terhadap ini, bukan terhadap `osd-width`/`osd-height` mentah.

**Solusi — tag ASS inti yang cukup untuk 90% kebutuhan:**

| Tag | Fungsi |
|---|---|
| `{\an1}` … `{\an9}` | Titik jangkar teks, mengikuti layout numpad (1=kiri-bawah, 5=tengah, 9=kanan-atas) |
| `{\b1}` / `{\b0}` | Bold on/off |
| `{\i1}` / `{\i0}` | Italic on/off |
| `{\fs<n>}` | Ukuran font |
| `{\c&Hbbggrr&}` | Warna teks (BGR, hex) |
| `{\pos(x,y)}` | Posisi absolut presisi (override anchor otomatis) |
| `\N` | Baris baru **di dalam** string ASS (bukan `\n`) |

Untuk teks yang mengandung karakter yang bisa disalahartikan sebagai tag ASS (mis. judul file berisi `{`), gunakan command `escape-ass` sebelum digabung ke `data`:

```lua
local aman = mp.command_native({"escape-ass", judul_file})
overlay.data = "{\\an5}" .. aman
overlay:update()
```

**Satu overlay = satu `id`.** Panggil `create_osd_overlay` sekali, simpan objeknya, lalu ubah `.data` dan panggil `:update()` berulang — **jangan** membuat overlay baru tiap frame (boros, dan mempersulit `:remove()` yang bersih).

---

### 4.3 Key Binding & Input Section — Siapa Menang Saat Bentrok

**Masalah inti:** sudah dijelaskan urutannya di §2.17, tapi bagian tersulitnya adalah **key sequence** (`a-b-c`). mpv mencocokkan sequence **terpanjang** yang match riwayat penekanan tombol. Kalau Anda punya binding tunggal `b` **dan** ingin punya sequence `a-b-c`, `b` akan selalu menang lebih dulu dan sequence tidak pernah tercapai.

**Solusi:** bind langkah antara ke `ignore` secara eksplisit:
```
a-b ignore                          # jangan trigger apapun di titik 'a lalu b'
a-b-c show-text "Sequence lengkap!" # baru di sini command jalan
b    show-text "b sendirian"        # tetap berfungsi normal jika ditekan sendiri
```
Logikanya: begitu `a-b` ditekan, mpv mencari match terpanjang. Karena `a-b` di-bind ke `ignore`, mpv **tidak** menganggapnya "selesai", riwayat tetap dilacak, sehingga `c` berikutnya bisa melengkapi `a-b-c`. Tanpa baris `ignore` ini, binding bawaan `b` akan langsung memotong di tengah jalan.

---

### 4.4 Hooks: `defer()` dan `cont()` — Kontrak yang Tidak Boleh Dilanggar

**Masalah inti:** hook membuat **player core menunggu**. Ini satu-satunya bagian API Lua mpv yang benar-benar bisa membekukan **seluruh pemutaran**, bukan cuma script Anda.

**Kontrak wajib:**
1. Jika logika di dalam `fn(hook)` selesai **secara sinkron**, cukup pastikan `hook:cont()` terpanggil sebelum fungsi return (atau di baris terakhir).
2. Jika Anda perlu menunggu sesuatu **async** (network call, subprocess) sebelum tahu apa yang harus dilakukan, panggil `hook:defer()` di awal, lalu panggil `hook:cont()` **nanti**, dari dalam callback operasi async tadi.
3. **Tidak pernah** membiarkan hook tanpa `cont()` sama sekali dalam kondisi apapun (termasuk cabang `error`/`pcall` yang gagal) — bungkus dengan `pcall` dan tetap panggil `cont()` di jalur error juga.

```lua
mp.add_hook("on_load", 50, function(hook)
    hook:defer()  -- "tunggu saya, jangan lanjut dulu"
    mp.command_native_async({name="subprocess", args={"cek-url.sh"}, capture_stdout=true},
        function(ok, result)
            -- proses hasil ...
            hook:cont()  -- WAJIB, apapun hasilnya, termasuk saat ok == false
        end)
end)
```

---

### 4.5 `profile-cond` (Auto-Profile) — Kondisional di Level Config File

**Masalah inti:** ini fitur `mpv.conf`, bukan Lua script terpisah, tapi **kondisinya dievaluasi sebagai ekspresi Lua** — hibrida yang sering membingungkan orang yang menganggap `mpv.conf` "cuma teks statis".

**Cara kerja:**
```ini
[video-hd]
profile-desc="Video resolusi HD ke atas"
profile-cond=width >= 1280
deband=yes

[youtube]
profile-cond=path:find('youtu%.?be') ~= nil
gamma=20

[mode-fullscreen]
profile-cond=fullscreen
profile-restore=copy      # otomatis kembalikan nilai lama saat kondisi jadi false
vf-add=rotate=PI/2
```

**Aturan penting:**
- Identifier yang belum didefinisikan Lua/mpv otomatis dibaca sebagai **nama property** (garis bawah `_` otomatis dikonversi ke `-`, jadi `playback_time` membaca property `playback-time`).
- Kode ini **tidak di-sandbox** — hindari menaruh logika kompleks di sini; ini untuk kondisi ringan, bukan program.
- **Hindari property yang sering berubah** (mis. `playback-time`) di dalam kondisi — mpv mengevaluasi ulang kondisi **setiap kali** property yang direferensikan berubah, jadi kondisi berbasis waktu-berjalan akan dievaluasi ulang hampir tiap frame → beban performa nyata.
- Default (tanpa `profile-restore`), saat kondisi jadi `false`, nilai opsi **tidak otomatis kembali** ke sebelumnya. Set `profile-restore=copy` kalau Anda memang mau perilaku "nyala saat kondisi true, otomatis balik saat false".
- Bandingkan dengan mekanisme lama (`[extension.mkv]`, `[protocol.http]`) yang soft-deprecated — untuk config baru, selalu pakai `profile-cond`, bukan magic-section-name lama itu.

---

### 4.6 Timing Observasi Property — Kenapa Handler Terpanggil "Lebih/Kurang" dari Dugaan

**Masalah inti:** tiga perilaku `observe_property` yang tidak intuitif kalau belum tahu:

1. **Selalu ada initial call** — begitu didaftarkan, handler langsung terpanggil sekali dengan nilai saat itu, walau belum ada perubahan apapun. Kalau logika Anda mengasumsikan "handler = ada perubahan", ini akan jadi bug di percobaan pertama.
2. **Koalesensi** — jika sebuah property berubah 10 kali dalam waktu sangat singkat (mis. `time-pos` selama seek cepat), handler **tidak** dipanggil 10 kali; biasanya hanya panggilan terakhir yang benar-benar sampai.
3. **`type = "none"`/`nil` bisa memicu callback tanpa perubahan nyata** — dokumentasi resmi secara eksplisit menyarankan **hindari** memakai tipe ini kecuali memang perlu notifikasi generik "ada sesuatu terjadi" tanpa peduli nilai barunya.

**Solusi praktis:** kalau logika Anda butuh "tunggu semua perubahan selesai baru proses" (mis. mengamati banyak property sekaligus untuk satu keputusan gabungan), gunakan `mp.register_idle(fn)` — handler ini terpanggil setelah **semua** event/perubahan property dalam satu batch selesai diproses, sebelum script tidur lagi.

---

### 4.7 `mp.utils.subprocess` vs `mp.command_native` — Pilih yang Mana

**Masalah inti:** ada dua cara memanggil proses eksternal, dan salah satunya legacy dengan efek samping yang tidak jelas kalau tidak dibaca detail.

| Aspek | `utils.subprocess(t)` | `mp.command_native({name="subprocess", ...})` |
|---|---|---|
| Status | Legacy wrapper (rename field internal: `cancellable`→`playback_only`, `max_size`→`capture_size`) | API resmi saat ini |
| Blocking? | Selalu blocking | Blocking (sync) **atau** non-blocking (`_async`) — Anda pilih |
| `capture_stdout` default | `true` otomatis | Harus eksplisit |
| Rekomendasi | Hindari untuk kode baru | Gunakan ini |

**Jebakan default yang wajib diketahui:** `playback_only` defaultnya `true` — artinya proses akan **otomatis dimatikan mpv** begitu playback berhenti. Ini masuk akal untuk proses yang memang terikat ke file yang sedang diputar, tapi kalau Anda ingin proses tetap jalan di idle mode atau lintas-file, **wajib** set `playback_only = false` secara eksplisit — kalau lupa, proses Anda akan mati mendadak tanpa pesan error yang jelas persis saat file berpindah.

```lua
mp.command_native_async({
    name = "subprocess",
    playback_only = false,   -- WAJIB eksplisit jika proses harus bertahan lintas-file/idle
    capture_stdout = true,
    args = {"yt-dlp", "--dump-json", url},
}, function(ok, result)
    if ok and result.status == 0 then
        local data = require("mp.utils").parse_json(result.stdout)
    end
end)
```

---

## 5. Rekomendasi Alur Konfigurasi Logis (Dasar → Profesional)

Urutan ini disusun agar setiap langkah **membangun fondasi teruji** untuk langkah berikutnya — bukan sekadar checklist acak.

1. **`mpv.conf` minimal, jalankan, verifikasi.** Sebelum menyentuh satu baris Lua pun, pastikan hardware decoding, cache, dan output video sudah stabil di sistem Anda. Script yang dibangun di atas playback yang belum stabil akan menyulitkan diagnosis (apakah bug di script atau di config dasar?).
2. **`input.conf` untuk kebutuhan yang murni pemetaan tombol.** Kalau kebutuhan Anda bisa diselesaikan dengan `KEY command`, jangan buru-buru menulis Lua — ini prinsip *"gunakan alat paling sederhana yang cukup"*.
3. **Satu script Lua "hello world" untuk validasi environment.** Pastikan mpv memuat script Anda dari folder `scripts/` tanpa error sebelum menambah logika apapun.
4. **Fitur pertama: kombinasi `observe_property` + `osd_message` + `add_key_binding`.** Ini melatih tiga primitif inti sekaligus dalam satu fitur yang bisa langsung dirasakan manfaatnya.
5. **Migrasi ke `create_osd_overlay`** hanya ketika `osd_message` benar-benar tidak cukup (butuh posisi presisi/multi-elemen/update frekuensi tinggi). Jangan mulai dari OSD kompleks — itu optimasi prematur untuk kebutuhan yang belum tentu ada.
6. **Tambahkan integrasi eksternal (subprocess) dengan pola async sejak awal**, bukan sync-lalu-refactor-belakangan. Kebiasaan menulis `_async` sejak baris pertama jauh lebih murah daripada membongkar ulang script yang sudah kadung terasa "lag" di tangan user.
7. **Naik ke hooks hanya saat benar-benar butuh mengubah proses loading file itu sendiri** (redirect URL, pilih track sebelum decoder jalan). Untuk 90% kasus "saya mau melakukan X saat file dimuat", `mp.register_event("file-loaded", ...)` sudah cukup dan jauh lebih aman daripada hook.
8. **Pecah jadi struktur direktori (`main.lua` + modul) begitu file melewati ~150–200 baris atau kompleksitas logikanya butuh dipisah tanggung jawabnya.** Jangan tunggu sampai 1000 baris — refactor dini jauh lebih murah.
9. **Inisialisasi git sejak script mulai punya >1 file**, bukan belakangan setelah kehilangan versi yang "kemarin masih jalan". Commit kecil dan sering.
10. **Bangun kebiasaan verifikasi di tiap tahap**: `--input-test` untuk binding, `--msg-level=namaskrip=debug` untuk trace eksekusi, `--script-opts` untuk uji override konfigurasi sebelum menganggap fitur "selesai".

---

## 6. Prinsip Maintainability: Menghindari Kode yang Unreadable/Unmaintainable

Prinsip rekayasa perangkat lunak standar berlaku penuh di sini — mpv-Lua bukan pengecualian hanya karena "cuma script player video".

**Modularisasi sejak konteks memungkinkan.** Sekali script Anda melebihi satu tanggung jawab jelas (mis. logika UI tercampur logika networking), pecah ke direktori `main.lua` + `modules/*.lua` dengan `package.path` diarahkan ke `mp.get_script_directory()`. Satu file raksasa yang mengerjakan segalanya adalah anti-pattern nomor satu di ekosistem ini.

**Penamaan unik dan konsisten.** Identifier untuk `mp.add_key_binding` (parameter `name`) dan `require("mp.options").read_options(_, identifier)` **wajib unik di seluruh instalasi user**, bukan hanya di script Anda — karena `--script-opts` dan sistem key binding berbagi namespace global antar semua script yang dimuat user. Prefiks nama script Anda sendiri (mis. `myscript-opsi_a`) adalah kebiasaan aman.

**Defensive by default.** Setiap pemanggilan `mp.get_property*` sebaiknya menyertakan argumen `def`; setiap pemanggilan `utils.parse_json` sebaiknya dicek nilai kembalian kedua (`error`) sebelum memakai hasilnya; operasi yang berpotensi melempar error tak terduga (parsing eksternal, file I/O) sebaiknya dibungkus `pcall`.

```lua
local ok, hasil = pcall(function()
    return require("mp.utils").parse_json(teks_mentah)
end)
if not ok or hasil == nil then
    mp.msg.warn("Gagal parsing JSON, pakai fallback")
    hasil = {}
end
```

**Logging yang membedakan tingkat kepentingan.** Pakai `mp.msg.debug`/`trace` untuk jejak internal yang hanya relevan saat Anda sendiri sedang debugging, dan `mp.msg.warn`/`error` untuk kondisi yang benar-benar perlu perhatian user. Jangan biarkan `print()` mentah menumpuk di kode yang sudah dianggap "selesai" — `print()` selalu tampil tanpa filter level, mencemari terminal user.

**Komentar menjelaskan "mengapa", bukan "apa".** `-- naikkan volume 2 unit` di atas `add volume 2` adalah komentar yang sia-sia (kodenya sendiri sudah menjelaskan itu). Komentar bernilai adalah yang menjelaskan keputusan tak terlihat dari kode: *"pakai `playback_only=false` di sini karena proses harus bertahan lintas-file"* — itu informasi yang tidak bisa ditebak hanya dari membaca baris kode itu sendiri.

**Konsisten dalam konvensi OSD & UX kustom.** Kalau satu fitur pakai durasi OSD 2 detik dan fitur lain 5 detik tanpa alasan fungsional, itu inkonsistensi yang terasa "amatir" di pemakaian sehari-hari. Definisikan konstanta di satu tempat (`local OSD_DURASI = 2`) alih-alih angka ajaib bertebaran di banyak fungsi.

**Uji sebelum menganggap selesai — bukan sekali di akhir, tapi di tiap tahap.** Tiga alat verifikasi yang sudah disebut berulang di dokumen ini (`--input-test`, `--msg-level=...=debug`, `--script-opts=...`) bukan alat "kalau sempat" — anggap sebagai bagian dari alur kerja normal, sama seperti Anda menjalankan linter/compiler sebelum commit di proyek software lain.

---

## Referensi Lanjutan (Sumber Primer)

- Command & property lengkap: `https://github.com/mpv-player/mpv/blob/master/DOCS/man/input.rst`
- API Lua lengkap: `https://github.com/mpv-player/mpv/blob/master/DOCS/man/lua.rst`
- Default binding mentah: `https://github.com/mpv-player/mpv/blob/master/etc/input.conf`
- Manual gabungan (HTML, mudah dibaca): `https://mpv.io/manual/master/`
- Contoh arsitektur skrip profesional dunia nyata (untuk dipelajari strukturnya): repo `tomasklaen/uosc`, `po5/thumbfast`, `po5/mpv_sponsorblock`.

Dokumen ini akan tetap relevan sebagai peta konsep meski mpv terus berkembang — struktur tiga lapis (opsi/binding/logika), model event-vs-hook, dan pola async-first tidak berubah drastis antar versi, hanya daftar property/command spesifik yang bertambah dari waktu ke waktu. Kombinasikan dokumen ini dengan `--input-cmdlist`/`--list-properties` di sistem Anda sendiri sebagai sumber kebenaran final, dan Anda akan selalu satu langkah di depan perubahan.

