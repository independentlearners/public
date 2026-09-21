# fzf

**Jenis:** fuzzy finder CLI/TUI  
**Implementasi utama:** Go  
**Peran:** seleksi interaktif dan integrasi dengan shell, Git, editor, serta pipeline Unix.

## Contoh
```bash
printf '%s\\n' alpha beta gamma | fzf
fd | fzf
rg --files | fzf
```

## Modifikasi
Siapkan Git, Go toolchain, pemahaman stdin/stdout, shell integration, event terminal, dan konsep TUI.

## Sumber
https://github.com/junegunn/fzf