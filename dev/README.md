# Development Tools

Direktori ini mendokumentasikan tool yang relevan untuk workflow pengembangan berbasis Linux, CLI/TUI, shell, Git, Lua, Dart, dan Flutter.

## Status direktori

Saat direktori `dev/` pertama kali diperiksa pada branch `main`, belum terdapat tool yang terdokumentasi di dalamnya. Karena itu, daftar **Tool yang Sudah Ada** saat ini kosong.

## Tool yang Sudah Ada

Belum ada.

## Tool yang Direkomendasikan

- [ripgrep](./tools/ripgrep/README.md) — pencarian teks/kode — Rust
- [fd](./tools/fd/README.md) — pencarian file — Rust
- [fzf](./tools/fzf/README.md) — fuzzy finder — Go
- [bat](./tools/bat/README.md) — file viewer/syntax highlighting — Rust
- [yazi](./tools/yazi/README.md) — file manager TUI — Rust
- [lazygit](./tools/lazygit/README.md) — Git TUI — Go
- [zoxide](./tools/zoxide/README.md) — navigasi direktori — Rust
- [jq](./tools/jq/README.md) — pemrosesan JSON — C
- [shellcheck](./tools/shellcheck/README.md) — static analysis shell — Haskell
- [shfmt](./tools/shfmt/README.md) — formatter shell — Go
- [stylua](./tools/stylua/README.md) — formatter Lua — Rust
- [btop](./tools/btop/README.md) — system monitor TUI — C++

## Prioritas

1. `ripgrep` + `fd`
2. `fzf`
3. `bat` + `jq`
4. `yazi`
5. `lazygit`
6. `zoxide`
7. `shellcheck` + `shfmt`
8. `stylua`
9. `btop`

Setiap tool memiliki README tersendiri yang menjelaskan fungsi, bahasa implementasi, kebutuhan untuk memodifikasi source, dan sumber resmi.

## Sumber

Seluruh tautan implementasi dan dokumentasi tool diarahkan ke repository/proyek upstream masing-masing.
