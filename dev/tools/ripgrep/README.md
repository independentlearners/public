# ripgrep

**Jenis:** pencarian teks rekursif CLI  
**Implementasi utama:** Rust  
**Peran:** pencarian pola pada source code, konfigurasi, log, dan repository.

## Contoh
```bash
rg "pattern"
rg -n "TODO" src/
rg -g '*.dart' "class "
```

## Modifikasi
Siapkan Git, Rust toolchain, Cargo, serta pemahaman regex, filesystem, CLI, dan testing. Untuk perubahan source, pahami struktur crate dan pipeline build/test Cargo.

## Sumber
https://github.com/BurntSushi/ripgrep