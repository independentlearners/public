# Konfigurasi Power-User tmux + Catppuccin

## Install the Catppuccin port for tmux
```shell
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.0 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
echo "run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux" >> ~/.tmux.conf
```
Isi file `~/.tmux.conf`
```shell
# =========================================================
# PREFIX
# =========================================================
# Power-user standard
# Mengganti Ctrl+b menjadi Ctrl+a
# =========================================================

unbind C-b
set -g prefix C-a
bind C-a send-prefix

# =========================================================
# DASAR TMUX
# =========================================================

set -g mouse on
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on
set -g history-limit 100000

# Reload config cepat
bind r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded"

# =========================================================
# SPLIT PANE
# =========================================================

unbind '"'
unbind %

# Split horizontal & vertical modern
bind - split-window -v -c '#{pane_current_path}'
bind \\ split-window -h -c '#{pane_current_path}'

# =========================================================
# NAVIGASI PANE (VIM STYLE)
# =========================================================

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize pane
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# =========================================================
# WINDOW NAVIGATION
# =========================================================

bind -n M-h previous-window
bind -n M-l next-window

# =========================================================
# STATUS BAR TOGGLE
# =========================================================

unbind b
bind b if -F "#{==:#{status},on}" \
  "set -g status off" \
  "set -g status on"

# Toggle tanpa prefix
bind-key -n F1 if -F "#{==:#{status},on}" \
  "set -g status off" \
  "set -g status on"

# =========================================================
# COPY MODE (VIM)
# =========================================================

setw -g mode-keys vi

bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind-key -T copy-mode-vi Escape send-keys -X cancel

# =========================================================
# PERFORMANCE & UX
# =========================================================

set -sg escape-time 0
set -g focus-events on
set -g repeat-time 300
set -g status-position bottom

# =========================================================
# CATPPUCCIN OPTIONS
# =========================================================

set -g @catppuccin_flavor 'mocha'

# Window style
set -g @catppuccin_window_status_style 'rounded'

# Pane status
set -g @catppuccin_pane_status_enabled 'yes'

# =========================================================
# LOAD CATPPUCCIN
# =========================================================

run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
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
* Pseudo terminal (PTY)
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
