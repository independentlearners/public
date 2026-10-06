# **daftar belajar Zsh yang harus dipelajari sekarang**

Urutannya dibuat dari fondasi → interactive shell → konfigurasi → internal → productivity.

## Mulai dari Sini Sekarang
- [ ] Baca overview `zsh(1)` dan `zshoptions(1)`
- [ ] Pelajari perbedaan utama Bash vs Zsh
- [ ] Pelajari `setopt` / `unsetopt`
- [ ] Pelajari parameter expansion, array, dan glob khas Zsh
- [ ] Pahami lifecycle `.zshrc`, `.zshenv`, `.zprofile`
- [ ] Buat widget ZLE sederhana dengan `bindkey`
- [ ] Bangun struktur konfigurasi Zsh modular

---

## [1. Zsh Foundation — Language & Differences from Bash][1] 
- [ ] Zsh syntax & perbedaan dari Bash
- [ ] Parameter
- [ ] Parameter expansion: `${name}`, `${name:u}`, `${name:l}`, `${(q)name}`, `${(f)text}`
- [ ] Quoting
- [ ] Arrays: `files=(one two three)`, `print -r -- $files[1]`
- [ ] Associative arrays
- [ ] Functions
- [ ] Conditional expressions
- [ ] Loops
- [ ] Arithmetic
- [ ] Command substitution
- [ ] Process substitution
- [ ] Glob / filename generation: `*.txt`, `**/*.lua`, `^*.bak`
- [ ] Redirection
- [ ] Exit status
- [ ] Autoload

## [2. Zsh Options][2]
- [ ] `setopt`
- [ ] `unsetopt`
- [ ] `setopt -o`
- [ ] Konsep option
- [ ] Default option
- [ ] Interactive option
- [ ] Emulation
- [ ] `AUTO_CD`
- [ ] `EXTENDED_GLOB`
- [ ] `HIST_IGNORE_DUPS`
- [ ] `SHARE_HISTORY`
- [ ] Praktik: aktifkan `AUTO_CD`, lalu pindah direktori tanpa menulis `cd`

## [3. Interactive Zsh][3]
- [ ] History
- [ ] Completion system
- [ ] `compinit`
- [ ] ZLE
- [ ] `bindkey`
- [ ] Keymap
- [ ] Widget
- [ ] Hook
- [ ] Autoload
- [ ] Praktik: buat widget `Ctrl+G` dengan `BUFFER`, `CURSOR`, `zle -N`, dan `bindkey '^G'`

## [4. Struktur Konfigurasi Zsh][4]
- [ ] `.zshenv`
- [ ] `.zprofile`
- [ ] `.zshrc`
- [ ] `.zlogin`
- [ ] `.zlogout`
- [ ] Pahami kapan masing-masing file dibaca
- [ ] Modular configuration
- [ ] Plugin management
- [ ] Environment management
- [ ] Startup optimization
- [ ] Bangun struktur `~/.config/zsh/`
- [ ] Buat file: `aliases.zsh`, `functions.zsh`, `options.zsh`, `completion.zsh`, `keybinds.zsh`, `history.zsh`, `prompt.zsh`
- [ ] Buat folder `integrations/` berisi `git.zsh`, `fzf.zsh`, `zoxide.zsh`, `yazi.zsh`

## [5. Zsh Internals untuk Customization][5]
- [ ] Completion system: styles, tags, completers, completion functions
- [ ] ZLE internals
- [ ] Widgets
- [ ] Hooks
- [ ] Autoload functions
- [ ] `zmodload`
- [ ] Modules
- [ ] Pahami alur: `plugin → source code → Zsh mechanism → modify → custom feature`

## [6. Productivity Engineering][6]
- [ ] Custom widgets
- [ ] Custom completion
- [ ] Aliases / functions
- [ ] Hooks
- [ ] Terminal integration
- [ ] Git integration
- [ ] `fzf` / `zoxide` / `yazi` integration
- [ ] Prompt customization
- [ ] Personal Zsh framework

## [7. Referensi Resmi Wajib][7]
- [ ] `zsh(1)`
- [ ] `zshoptions(1)`
- [ ] `zshexpn(1)`
- [ ] `zshparam(1)`
- [ ] `zshbuiltins(1)`
- [ ] `zshzle(1)`
- [ ] `zshcompsys(1)`

## Target Akhir
- [ ] Tidak hanya memakai plugin Zsh
- [ ] Bisa membaca source code plugin
- [ ] Bisa memahami mekanisme Zsh yang dipakai plugin
- [ ] Bisa memodifikasi
- [ ] Bisa membuat custom feature sendiri

Posisi belajar yang disarankan: **Bash untuk scripting, automation, dan portability; Zsh untuk interactive shell, terminal productivity, dan konfigurasi modular.**

[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./bagian-4/README.md
[5]: ./bagian-5/README.md
[6]: ./bagian-6/README.md
[7]: ./bagian-7/README.md
