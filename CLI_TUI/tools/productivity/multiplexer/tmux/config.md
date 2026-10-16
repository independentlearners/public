# Konfigurasi Power-User tmux + Catppuccin

## Install the Catppuccin port for tmux
```shell
# KONFIGURASI TMUX POWER-USER
# 
# =========================================================
# PREFIX
# =========================================================
# Power-user standard
# Mengganti Ctrl+b menjadi Ctrl+a
# =========================================================
# Hapus komentar di bawah ini jika ingin menggunakan prefix default Ctrl+b
#
unbind C-b
set -g prefix C-a
bind C-a send-prefix
#
# =========================================================
# MENU WINDOW
# =========================================================
#
# Prefix + S -> Muncul pop-up untuk isi nomor window tujuan
bind S command-prompt -p "Tukar window aktif dengan nomor:" "swap-window -t '%%'"
#
# Prefix + W -> Pindahkan window antar-session dengan format:
# session_asal:nomor_window:session_tujuan
# Contoh: "saya:1:aku"
bind W command-prompt -p "Pindahkan (session:window:tujuan):" \
  "run-shell '$HOME/.config/tmux/move-window-between-sessions.sh \"%%\"'"
#
# Prefix + T -> Tampilkan hanya pintasan kustom.
bind T display-popup -E -s 'bg=terminal,fg=terminal' -S 'fg=terminal' -w 90% -h 80% \
  "$HOME/.config/tmux/list-custom-keys.sh"
#
# =========================================================
# DASAR TMUX
# =========================================================
#
set -g mouse on
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on
set -g history-limit 100000
#
# =========================================================
# SPLIT PANE
# =========================================================
# Default tmux biasanya Ctrl+b % untuk horizontal dan Ctrl+b " untuk vertical, tapi itu selalu buka di ~.
# Dengan bind ini lebih relevan untuk penggunaannya.
#
# Split pane
unbind '"'
unbind %
#
bind - split-window -v -c "#{pane_current_path}"
# Ctrl+b lalu |
# Split kanan-kiri / horizontal. Direktori sama dengan pane saat ini
#
bind | split-window -h -c "#{pane_current_path}"
# Ctrl+b lalu -
# Split atas-bawah / vertical. Direktori sama dengan pane saat ini
# Dengan -c "#{pane_current_path}" memastikan pane baru dibuka di direktori yang sama dengan pane saat ini, bukan di home directory.
# Untuk keluar dari mode split, cukup tekan prefix (prefix+x) lalu tekan 'y'.
#
# =========================================================
# NAVIGASI PANE SPLIT (VIM STYLE)
# =========================================================
# Dalam mode split, gunakan Prefix lalu h, j, k, l untuk navigasi antar pane. Ini mirip dengan navigasi di editor Vim.
#
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
#
# Resize pane
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
#
# =========================================================
# WINDOW NAVIGATION
# =========================================================
#
# Navigasi antar window
# Alt + z pindah ke window sebelumnya
bind -n M-h previous-window
# Alt + x pindah ke window berikutnya
bind -n M-l next-window
#
# Navigasi antar session
# Prefix+j pindah ke session berikutnya
bind j switch-client -n
#
# Prefix+k pindah ke session sebelumnya
bind k switch-client -p
#
# =========================================================
# PANE BORDER STATUS
# =========================================================
#
set -g pane-border-status top
set -g pane-border-format " [#{pane_index}] #{pane_current_command} #{pane_current_path} "
#
# =========================================================
# STATUS BAR TOGGLE
# =========================================================
#
unbind b
bind b if -F "#{==:#{status},on}" \
  "set -g status off" \
  "set -g status on"
#
# Toggle tanpa prefix
bind -n F2 if -F "#{==:#{status},on}" \
  "set -g status off" \
  "set -g status on"
#
# =========================================================
# COPY MODE (VIM)
# =========================================================
#
setw -g mode-keys vi
#
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind-key -T copy-mode-vi Escape send-keys -X cancel
# Nomor baris hybrid:
set -g copy-mode-line-numbers hybrid
#
# =========================================================
# SHORTCUTS ALA POWER-USER (UPDATED FOR RESURRECT)
# =========================================================
# Menggunakan send-keys agar proses berjalan di dalam shell 
# sehingga bisa dideteksi oleh tmux-resurrect
#
bind -n M-B new-window -n btop \; send-keys "btop ; exit" C-m
bind -n M-C new-window -n copilot \; send-keys "copilot ; exit" C-m
bind -n M-o new-window -n codex \; send-keys "codex ; exit" C-m
bind -n M-G new-window -n gemini \; send-keys "gemini ; exit" C-m
bind -n M-g new-window -n gdu \; send-keys "gdu ; exit" C-m
bind -n M-C-h new-window -n helix \; send-keys "hx ; exit" C-m
bind -n M-n new-window -n nvim \; send-keys "nvim ; exit" C-m
bind -n M-N new-window -n nano \; send-keys "nano ; exit" C-m
bind -n M-t new-window -n top \; send-keys "top ; exit" C-m
bind -n M-v new-window -n vim \; send-keys "vim ; exit" C-m
bind -n M-V new-window -n cava \; send-keys "cava ; exit" C-m
bind -n M-y new-window -n yazi \; send-keys "sudo -E yazi ; exit" C-m
#
# =========================================================
# PERFORMANCE & UX
# =========================================================
#
set -sg escape-time 0
set -g focus-events on
set -g repeat-time 300
set -g status-position bottom
set -g status on
set -g status-interval 1
#
# =========================================================
# PLUGINS
# =========================================================
#
# Auto-install tpm kalau belum ada
# Paksa TPM pakai path XDG biar gak nyasar ke ~/.tmux/
set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.config/tmux/plugins/'
# Suto-install: bikin folder dulu kalau belum ada, baru clone
if "test ! -d ~/.config/tmux/plugins/tpm" \
   "run 'mkdir -p ~/.config/tmux/plugins && git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm && ~/.config/tmux/plugins/tpm/bin/install_plugins'"
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'catppuccin/tmux'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-sensible'
#
# =========================================================
# CATPPUCCIN OPTIONS
# =========================================================
#
set -g @catppuccin_flavor 'mocha'
set -g @catppuccin_window_status_style 'rounded'
set -g @catppuccin_pane_status_enabled 'yes'
#
# Gunakan warna bawaan terminal agar transparansi emulator tetap terlihat.
set -g popup-style 'bg=terminal,fg=terminal'
set -g popup-border-style 'fg=terminal'
#
# =========================================================
# CONTINUUM & RESURRECT STRATEGY
# =========================================================
#
set -g @continuum-restore 'on'
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'
#
# Daftar proses yang harus di-restore (pastikan nama binary sesuai)
set -g @resurrect-processes 'yazi btop gdu hx copilot'
#
# =========================================================
# RUN CONFIG AND RELOAD
# =========================================================
#
bind r source-file "$HOME/.config/tmux/tmux.conf" \; display-message "konfigurasi Dimuat Ulang!"
#
# =========================================================
# TPM
# =========================================================
#
run-shell "~/.config/tmux/plugins/tpm/tpm"

```

# Kenapa konfigurasi ini dianggap power-user?

* `Ctrl+a` adalah prefix paling populer di kalangan pengguna terminal advanced.
* Navigasi `hjkl` mengikuti muscle memory Vim/Neovim.
* Split otomatis membuka direktori kerja pane aktif.
* `Alt+h/l` mempercepat perpindahan window tanpa prefix.
* `escape-time 0` mengurangi delay input terminal.
* `history-limit 100000` cocok untuk debugging panjang.
* `mode-keys vi` membuat copy-mode terasa seperti Vim.
* Struktur konfigurasi modular dan mudah dikembangkan.

# Teknologi dan konsep yang perlu dipahami

Untuk benar-benar menguasai konfigurasi tmux level advanced:

* Shell scripting
* Terminal escape sequence ANSI
* [Pseudo terminal (PTY)][pty]
* Key table tmux
* Vim motions
* Event-driven terminal interaction
* Multiplexer architecture
* UNIX process management

# Teknologi inti tmux

* Bahasa: C
* Sistem utama: UNIX PTY subsystem
* Integrasi erat dengan:

  * terminfo
  * shell environment
  * terminal emulator
  * keyboard escape sequences

# Dokumentasi resmi

* tmux Wiki:
  [https://github.com/tmux/tmux/wiki](https://github.com/tmux/tmux/wiki)

* tmux Manual:
  [https://man.openbsd.org/tmux](https://man.openbsd.org/tmux)

* Catppuccin tmux:
  [https://github.com/catppuccin/tmux](https://github.com/catppuccin/tmux)

* Cheatsheet: 
  [https://tmuxcheatsheet.com/](https://tmuxcheatsheet.com/)

Konfigurasi sudah disusun ulang dengan struktur power-user modern:

* prefix diganti ke `Ctrl+a`
* navigasi vim-style
* split otomatis mengikuti direktori aktif
* toggle status bar cepat
* optimasi latency terminal
* integrasi Catppuccin yang benar tanpa konflik override
* copy-mode ala Vim/Neovim

Struktur juga sudah dibuat scalable untuk workflow Linux/Arch/Sway/terminal-centric.

[pty]: ./../../../../konsep/pty/README.md
