# Lazy

Pertama pastikan bahwa neovim sudah terinstal, jika belum jalankan perintah beriku:
```pwsh
sudo pacman -Syu neovim
```
Instal Lazy
```lua
git clone https://github.com/folke/lazy.nvim.git\
~/.local/share/nvim/site/pack/lazy/start/lazy.nvim
```
Buat daftar file dengan susunan folder sebagai berikut

```lua
~/.config/nvim/
├── init.lua
└── lua/
    ├── settings.lua    -- semua opsi vim.o, vim.wo, termguicolors, completeopt, dsb.
    ├── keymaps.lua     -- semua keymap normal/insert/visual
    └── plugins.lua     -- daftar & konfigurasi plugin via lazy.nvim
```

Copy pastekan kode berikut di

### 
`~/.config/nvim/init.lua`

Kode berikut adalah **lazy.nvim** sebagai plugin manager, tapi kamu bisa adaptasi ke **Packer** jika mau

```lua
-- ~/.config/nvim/init.lua

-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Load konfigurasi modular
require("settings")   -- opsi-opsi vim.o, indent guide, dll.
require("keymaps")    -- pemetaan tombol
require("plugins")    -- plugin + konfigurasi mereka
```
### `~/.config/nvim/lua/settings.lua`
```lua
-- ~/.config/nvim/lua/settings.lua

-- General options
vim.o.termguicolors = true
vim.o.completeopt    = "menu,menuone,noselect"
vim.o.clipboard      = "unnamedplus"
vim.o.expandtab      = true
vim.o.shiftwidth     = 2
vim.o.tabstop        = 2
vim.wo.number        = true
vim.wo.signcolumn    = "yes"

-- Indent guides ala Flutter UI
vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_filetype_exclude = { "dashboard", "terminal", "help" }

-- Rainbow parentheses/brackets via treesitter-rainbow
```
### `~/.config/nvim/lua/keymaps.lua`
```lua
-- ~/.config/nvim/lua/keymaps.lua

local map = vim.keymap.set

-- Telescope (mirip “Go to File” & “Search” VSCode)
map("n", "<leader>ff", require("telescope.builtin").find_files)
map("n", "<leader>fg", require("telescope.builtin").live_grep)

-- (LSP & DAP keymaps di-setup otomatis on_attach di plugins.lua)
```

Berikutnya jalankan perintah `nvim` biasa maka kamu akan masuk pada dalam buffer init.lua



 - Tekan `Esc`

 - Tekan `:`

Masukan perintah

 `Lazy sync`

Ini akan memaksa lazy.nvim untuk mengecek semua plugin yang ada di `lua/plugins.lua`
