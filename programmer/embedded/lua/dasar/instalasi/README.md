# Instalasi

**Windows**

```pwsh
choco search lua
#pilih versi terbaru
choco install lua
```

Untuk memastikan apakah instalasi berhasil atau tidak coba jalankan

```pwsh
PS C:\Users>lua -v
# instalasi berhasil jika muncul output versi atau jalankan berikut untuk untuk sekaligus melakukan ujicoba

PS C:\Users>lua

#output muncul dengan menyertakan versi
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio

> print("halo dunia") # << tulis seperti berikut

halo dunia # << output akan muncul

# untuk keluar dari mode ini bisa gunakan ctrl + C atau dengan mengetik seperti berikut untuk windows atau ctrl + D di Unix

> os.exit()
```

**Debugging**

Gunakan pwsh versi 7 untuk melakukan debugging

**Formatter**

```pwsh
choco install stylua
```

Digunakan untuk formatter mode CLI, setelah menulis kode semisal melalui neovim atau notepad gunakan perintah berikut agar kode disusun secara otomatis oleh `stylua`

```shell
stylua filelua_kamu.lua
```

atau format semua file di satu folder:

```shell
stylua .
```

**Cara Lain**

Buat Konfigurasi Kustom (stylua.toml) Di root project, buat file stylua.toml untuk atur gaya:

```lua
# Lebar indentasi spasi
indent_width = 2

# Maksimum panjang baris sebelum wrap
line_width = 100

# Prefer single quotes atau double quotes
quote_style = "AutoPreferSingle"

# Ejaan parameter lain bisa dicek di dokumentasi Stylua
```

**Integrasi di VS Code**

Pastikan sudah install extension **[Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua "marketplace.visualstudio.com")** atau **[StyLua Formatter](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua "marketplace.visualstudio.com")**. Buka settings.json (Ctrl+Shift+P → “Preferences: Open Settings (JSON)”), lalu tambahkan:

```json
{
  // Auto-format kapan pun file disimpan
  "editor.formatOnSave": true,

  "[lua]": {
    "editor.defaultFormatter": "JohnnyMorganz.stylua",
    "editor.formatOnSave": true
  }
}
```

#### Restart VS Code sekali.

> - **[Kembali Ke Atas](#)**
> - **[Daftar Kurikulum][1]**

[1]: ../../README.md
