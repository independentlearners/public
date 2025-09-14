# tmux

## Panduan Komprehensif tmux — Menjadi Profesional (Ringkas, Praktis, dan Terarah)

Berikut panduan lengkap, terstruktur, dan pragmatis untuk menguasai **tmux** sampai level profesional.

> Catatan identitas teknis (wajib, sesuai preferensi Anda):
> **tmux** adalah *terminal multiplexer* yang ditulis terutama dalam **bahasa C**. Dependensi umum untuk membangun/memodifikasinya meliputi **libevent** (event loop), **ncurses** (manajemen terminal) dan utilitas pembangunan seperti **gcc/clang**, **make**, **pkg-config**, serta header-dev untuk ncurses/libevent. Untuk mengembangkan plugin atau menambah fitur operasional, biasanya diperlukan: pemahaman **C** (untuk mengubah kode sumber), **shell scripting** (plugin & integrasi), pengetahuan **terminfo/\$TERM**, dan alat *build* (autotools/Makefile).

---

# 1. Gambaran Singkat & Konsep Inti

* **Session**: kumpulan jendela (workspace terisolasi). Bisa detach/reattach.
* **Window**: seperti tab di dalam session; tiap window bisa menjalankan shell atau program.
* **Pane**: pembagian window menjadi beberapa area (split).
* **Prefix key**: tombol awal untuk memicu perintah tmux (default `Ctrl-b`).
* **Copy-mode**: mode untuk menelusuri dan menyalin teks dari pane.
* **Server**: tmux menjalankan *server* yang mengelola semua session lewat soket Unix.

Memahami relasi: **server → session → window → pane**.

---

# 2. Instalasi & Pembangunan dari Sumber

**Paket umum (Linux):**

* Debian/Ubuntu: `sudo apt install tmux`
* Arch Linux: `sudo pacman -S tmux`
* Fedora/RHEL: `sudo dnf install tmux`
* macOS (Homebrew): `brew install tmux`

**Build dari sumber (garis besar):**

1. Clone repo: `git clone https://github.com/tmux/tmux.git`
2. Siapkan dependensi: `libevent-dev`, `ncurses-dev`, `pkg-config`, `gcc/clang`, `make`
3. `sh autogen.sh` (jika diperlukan), `./configure && make && sudo make install`
4. Periksa `$PATH` dan `which tmux`.

**Mengembangkan/memodifikasi:**

* Pelajari struktur C codebase (src/), gunakan debugger/valgrind untuk memory issues.
* Jalankan test suite jika tersedia.
* Pelajari mekanisme socket dan hooks di kode untuk menambahkan fitur.

---

### Cara menggunakan `Prefix + c` untuk membuat *window* baru di tmux

Inti dari `Prefix + c` adalah kombinasi tombol untuk **membuat window baru** di dalam session tmux. Berikut penjelasan praktis, langkah demi langkah, plus variasi dan solusi bila tidak berhasil.

## 1) Apa itu *prefix* dan bagaimana menekannya

* Default *prefix* tmux adalah `Ctrl-b`.
* Untuk membuat window baru: tekan **Ctrl-b**, lepaskan, lalu tekan **c**.
  Artinya: tekan `Ctrl` dan `b` bersamaan → lepaskan → tekan `c`.

Contoh urutan: `Ctrl-b` → `c`
Hasil: muncul window baru (biasanya shell) di session yang aktif.

## 2) Jika Anda mengubah *prefix*

Banyak pengguna mengganti ke `Ctrl-a` (mirip screen). Jika Anda sudah mengubah, misal:

```conf
# di ~/.tmux.conf
set -g prefix C-a
unbind C-b
bind C-a send-prefix
```

Maka urutan menjadi: `Ctrl-a` → `c`.

## 3) Jika Anda ingin membuat window tanpa menekan prefix (opsional)

Di `~/.tmux.conf` Anda bisa membuat binding tanpa prefix:

```conf
# contoh: langsung Ctrl-Enter membuat window baru
bind -n C-Enter new-window
```

`bind -n` membuat binding *global* tanpa perlu prefix.

## 4) Cara alternatif (baris perintah / dari luar tmux)

* Dari shell di luar tmux (atau script), buat window di session aktif:

```bash
tmux new-window -t nama_session -n nama_window
```

* Buat window dan jalankan perintah:

```bash
tmux new-window -t work -n logs 'tail -f /var/log/syslog'
```

* Dari dalam tmux via command prompt: `Prefix + :` lalu ketik `new-window` atau `new-window -n editor`.

## 5) Memodifikasi perilaku pembuatan window

* Ganti nama window otomatis saat membuat:

```conf
bind c new-window -n shell
```

* Membuat window dengan layout atau ukuran tertentu dapat dilakukan via scripting (contoh pada bagian Automasi di panduan utama).

## 6) Troubleshooting cepat

* Jika `Ctrl-b` tidak merespon:

  * Pastikan Anda berada di session tmux (lihat `tmux ls`).
  * Terminal/WM mungkin menangkap kombinasi (mis. terminal emulator punya shortcut `Ctrl-b`); coba ubah prefix.
  * Pastikan `~/.tmux.conf` tidak menonaktifkan binding `c`. Periksa `tmux list-keys | grep new-window`.
* Jika `c` menghasilkan huruf di shell alih-alih membuat window: besar kemungkinan prefix tidak dipencet atau di-override.

## 7) Contoh `~/.tmux.conf` minimal (rebind prefix + dokumentasi)

```conf
# Ganti prefix ke Ctrl-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Buat window baru dengan prefix + c
bind c new-window

# Nama window saat dibuat
bind C new-window -n 'shell'

# Reload config: Prefix + r
bind r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded"
```

## 8) Identitas teknis & persiapan untuk memodifikasi tmux (sesuai preferensi Anda)

* **Identitas:** `tmux` adalah *terminal multiplexer* yang ditulis dalam **bahasa C**.
* **Dependensi pembangunan/modifikasi:** `libevent`, `ncurses` (dev headers), `pkg-config`, compiler (`gcc`/`clang`), `make`/autotools.
* **Kemampuan yang berguna:** pemahaman bahasa C (untuk modifikasi kode sumber), shell scripting (otomasi dan plugin), pengetahuan `terminfo`/`$TERM`, dan pengalaman debugging (valgrind/gdb) bila ingin kontribusi mendalam.
* **Persiapan praktis:** Anda perlu lingkungan build (toolchain), akses repo `git clone https://github.com/tmux/tmux.git`, dan terminal dengan dukungan 256 warna (`tmux-256color` terminfo).

---

# 3. Konsep Pengoperasian & Perintah Dasar

Prefix default: `Ctrl-b`. Kita tuliskan format `Prefix + X`.

**Manajemen session**

* `tmux new -s nama` — buat session baru.
* `tmux ls` / `tmux list-sessions` — daftar session.
* `tmux attach -t nama` — gabung ke session.
* `tmux detach` (dari dalam: `Prefix + d`) — detach.
* `tmux kill-session -t nama` — hapus session.

**Manajemen window**

* `Prefix + c` — create window.
* `Prefix + w` — list windows (interaktif).
* `Prefix + ,` — rename window.
* `tmux new-window -n nama` — buat window via CLI.
* `tmux swap-window -s src -t dst` — tukar window.

**Manajemen pane**

* `Prefix + %` — split vertical (left/right).
* `Prefix + "` — split horizontal (top/bottom).
* `Prefix + o` — pindah focus antar pane.
* `Prefix + ;` — kembali ke pane terakhir.
* `Prefix + {` / `Prefix + }` — swap panes.
* `Prefix + x` — tutup pane.
* `Prefix + z` — zoom pane (besar/kecil sementara).

**Layout & resizing**

* `Prefix + space` — cycle layout.
* `Prefix + Alt + ←/→/↑/↓` atau `Prefix + Ctrl + ←/...` (tergantung config) — resize pane.
* `tmux select-layout tiled|even-horizontal|even-vertical|main-horizontal|main-vertical`.

**Copy / Paste**

* Masuk copy-mode: `Prefix + [`
* Navigasi pakai arrow/vi keys (jika diset `mode-keys vi`).
* Pilih teks: (vi) `v` untuk mulai selection; `y` untuk yank; atau `Enter` untuk copy.
* Paste: `Prefix + ]` (paste buffer terakhir).
* Hint: integrasi clipboard sistem memerlukan plugin (tmux-yank) atau perintah `save-buffer` | xclip/pbcopy.

**Informasi & debugging**

* `Prefix + ?` — daftar keybindings.
* `tmux show-options -g` / `tmux show-window-options` / `tmux show-environment` — tampilkan konfigurasi.
* `tmux kill-server` — hentikan semua.

---

# 4. File Konfigurasi (`~/.tmux.conf`) — Contoh & Penjelasan

Minimal modern (recommended):

```
# Ganti prefix ke Ctrl-a (opsional)
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse (memudahkan resize/select)
set -g mouse on

# Gunakan keybindings vi di copy mode
set -g mode-keys vi

# History scrollback besar
set -g history-limit 10000

# Status bar sederhana
set -g status-interval 5
set -g status-left "#[fg=green]#S"          # nama session
set -g status-right "#(whoami) | %Y-%m-%d %H:%M"

# Colors & default terminal
set -g default-terminal "tmux-256color"

# Faster pane switching with vi-like keys
bind -n C-Left select-pane -L
bind -n C-Right select-pane -R
bind -n C-Up select-pane -U
bind -n C-Down select-pane -D
```

**Tips konfigurasi:**

* `set -g default-terminal "tmux-256color"` disarankan untuk memastikan output warna. Pastikan terminfo tersedia.
* Aktifkan `mouse on` untuk klik/resize/scroll (pilihan workflow).
* Simpan dan reload: `tmux source-file ~/.tmux.conf` atau `Prefix + :` lalu `source-file ~/.tmux.conf`.

---

# 5. Integrasi Clipboard & Copy-Mode (Praktis)

* Tanpa plugin: `tmux show-buffer`/`tmux save-buffer` untuk mengekspor buffer, lalu pipe ke `xclip`/`wl-copy`/`pbcopy`.
* Plugin populer: **tmux-yank** (salin ke clipboard X11/Wayland/macOS).
* Konfigurasi sample untuk integrasi xclip:

  ```
  bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -in"
  ```

  (Ganti `xclip` dengan `wl-copy` pada Wayland.)

---

# 6. Plugin & Ekosistem

* **TPM (tmux plugin manager)** — manajemen plugin. Repo: `tmux-plugins/tpm`.
* Plugin penting:

  * `tmux-plugins/tmux-yank` — copy-to-system-clipboard.
  * `tmux-plugins/tmux-resurrect` — simpan & restore session/panes/windows (state).
  * `tmux-plugins/tmux-continuum` — auto save & restore.
  * `tmux-plugins/tmux-prefix-highlight` — tampilkan status prefix aktif.
  * `tmux-plugins/tmux-sensible` — konfigurasi sane defaults.

**TPM instalasi singkat:**

1. Clone TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
2. Tambahkan di `~/.tmux.conf` plugin block:

   ```
   set -g @plugin 'tmux-plugins/tpm'
   set -g @plugin 'tmux-plugins/tmux-resurrect'
   run '~/.tmux/plugins/tpm/tpm'
   ```
3. Dalam tmux tekan `Prefix + I` untuk install.

---

# 7. Automasi, Skrip & Skenario Produksi

* **Auto-attach script** (bash):

  ```bash
  #!/usr/bin/env bash
  SESSION="work"
  tmux has-session -t "$SESSION" 2>/dev/null
  if [ $? -eq 0 ]; then
    tmux attach -t "$SESSION"
  else
    tmux new -s "$SESSION"
  fi
  ```
* **Scripting tmux**: gunakan `tmux new-session -d`, `tmux new-window -t`, `tmux split-window -h -t`, `tmux send-keys -t session:win.pane 'command' C-m`.
* **Start-up dev environment**: buat `start_dev.sh` yang membuat session, windows (editor, server, logs), dan menjalankan perintah otomatis.

---

# 8. Workflows Profesional (Contoh)

1. **Remote persistent dev**: Jalankan tmux di server remote via SSH; detach saat koneksi turun; reattach di mana saja.
2. **Pair programming**: Share session dengan reattach user lain (`tmux attach -t session`). Atur izin socket jika perlu.
3. **Monitoring/DevOps**: Window untuk log tail, window untuk top/htop, window untuk shell manajemen; gunakan layout main-vertical untuk focus di satu pane besar.
4. **Productive coding**: satu session per project, window untuk editor (neovim), pane untuk test runner, pane untuk REPL/console.

---

# 9. Tips Kinerja, Troubleshooting & Best Practices

* **TERM & terminfo**: pastikan `default-terminal` cocok (tmux-256color). Jika warna aneh, pasang terminfo atau gunakan `screen-256color`.
* **History**: set `history-limit` besar untuk debugging.
* **Resource**: tmux relatif ringan; jika crash, `tmux -vv new` menghasilkan log verbose (`/tmp/tmux-*.log`).
* **Socket permission**: jika tidak bisa attach, periksa `~/.tmux/` socket permissions.
* **Interoperabilitas**: gunakan `reattach-to-user-namespace` di macOS lama untuk clipboard; di Wayland gunakan `wl-copy`.
* **Upgrade**: bila upgrade tmux, pastikan plugin kompatibilitas dan restart server (`tmux kill-server`).

---

# 10. Konfigurasi Lanjutan & Hooks

* Hooks: `set-hook -g session-created 'run-shell "..."'` untuk otomatisasi ketika session dibuat.
* Format status: gunakan `#(cmd)` untuk menaruh output perintah di status-right/left. Contoh: `set -g status-right "#(date +'%F %R')"`
* Key table & modes: `bind -T copy-mode-vi v send -X begin-selection` — bisa kustomisasi key tables.

---

# 11. Jalur Belajar Terstruktur (dari pemula → profesional)

1. **Minggu 1**: Pahami konsep session/window/pane. Praktik: buat 1 session per proyek.
2. **Minggu 2**: Konfigurasi `.tmux.conf`, ubah prefix, aktifkan mouse, atur history.
3. **Minggu 3**: Pelajari copy-mode & integrasi clipboard (buat script/sesuaikan untuk X11/Wayland).
4. **Bulan 2**: Automasi dengan shell scripts; buat start-up script projek.
5. **Bulan 3**: Pelajari plugin (TPM), pasang tmux-resurrect & continuity.
6. **Bulan 4–6**: Pelajari debugging (tmux server logs), modifikasi/pelajari kode sumber C (jika ingin mengontribusi).
7. **Tingkat lanjut**: Integrasi tmux + neovim + LSP + status bar custom (powerline-like), scriping lanjutan, dan kontribusi ke tmux core.

---

# 12. Cheat Sheet Ringkas (Default prefix: `Ctrl-b`)

**Session:** `new -s S`, `attach -t S`, `ls`, `kill-session -t S`
**Window:** `Prefix + c` (baru), `Prefix + ,` (rename), `Prefix + w` (list)
**Pane:** `Prefix + %` (vertical), `Prefix + "` (horizontal), `Prefix + o` (switch), `Prefix + x` (close)
**Copy:** `Prefix + [` (enter), `v` (begin sel, jika vi), `y` (yank), `Prefix + ]` (paste)
**Layouts:** `Prefix + space`, `select-layout tiled`
**Reload config:** `tmux source-file ~/.tmux.conf` atau `Prefix + : source-file ~/.tmux.conf`
**Plugins (TPM):** `Prefix + I` (install), `Prefix + U` (update), `Prefix + alt + u` (uninstall)

---

# 13. Sumber & Bacaan Direkomendasikan

* Manual resmi: `man tmux` (tmux(1)) — sumber primer untuk semua perintah.
* Repo resmi: **tmux** — `tmux/tmux` di GitHub.
* TPM (tmux-plugins/tpm) dan plugin repositori: `tmux-plugins/*`.
* Artikel & buku yang sering direkomendasikan: *tmux* chapters in modern terminal workflows and “tmux: Productive Mouse-Free Development” (referensi praktis).
* Blog & tutorial: berbagai tutorial step-by-step (search: "tmux tutorial", "tmux copy mode vi", "tmux-resurrect").
