# Modul 1: Core Syntax & Terminologi

## 1. Chunk & REPL

### 📚 Istilah:

- **Chunk** = satu unit eksekusi Lua. Bisa berupa file `.lua` atau satu baris perintah.
- **REPL** = “Read-Eval-Print Loop”, terminal interaktif untuk coba kode.

### 🔧 Cara coba:

1. Buka terminal, ketik `lua` → masuk ke REPL.
2. Ketik kode, lalu `Enter` untuk eksekusi segera.
3. Ketik `os.exit()` atau tekan `Ctrl+D` untuk keluar.

```bash
$ lua
Lua 5.4.6  Copyright (C) 1994-2024 Lua.org, PUC-Rio
> print("Halo dari REPL!")
Halo dari REPL!
> 2 + 3
5
> os.exit()
```

Atau buat file `hello.lua`:

```lua
-- hello.lua
print("Halo dari file chunk!")
```

Lalu di terminal:

```bash
$ lua hello.lua
Halo dari file chunk!
```

---

## 2. Komentar

### 📚 Istilah:

- **Komentar** = baris/blok kode yang diabaikan interpreter, buat catatan kamu sendiri.

### 🔧 Sintaks:

```lua
-- ini komentar satu baris

--[[
   ini komentar
   beberapa baris
]]
```

### 🔍 Contoh:

```lua
--[[
  Fungsi ini cetak pesan sambutan.
  Kita pakai komentar multi-line
]]
local function greet(name)  -- komentar inline
  print("Halo, " .. name .. "!")
end

greet("Dunia")
```

---

## 3. Variabel

### 📚 Istilah:

- **Global** = otomatis terlihat di mana-mana.
- **Local** = hanya di blok/fungsi itu, wajib pakai `local`.

### 🔧 Sintaks & Aturan:

```lua
x = 10           -- global
local y = 20     -- lokal

function contoh()
  local z = x + y
  print(z)
end
```

### 🔍 Detail:

- **Kenapa selalu pakai `local` di plugin?**
  Mencegah bentrok nama variabel antar modul, plus lebih cepat diakses oleh interpreter.

---

## 4. Tipe Data & Literals

### 📚 Istilah & Literals:

| Tipe     | Literal Contoh                      | Keterangan                                |
| -------- | ----------------------------------- | ----------------------------------------- |
| `nil`    | `nil`                               | kosong/tidak ada                          |
| boolean  | `true`, `false`                     | logika                                    |
| number   | `123`, `3.14`, `0x1A`               | integer/floating, juga hex                |
| string   | `'teks'`, `"teks"`, `[[multiline]]` | dibatasi petik tunggal/ganda atau `[[ ]]` |
| table    | `{}`, `{1,2,3}`, `{a=1,b=2}`        | array/dictionary                          |
| function | `function() end`                    | first-class citizen                       |

### 🔧 Contoh:

```lua
local null = nil
local boolean = true
local integer = 42
local floating = 3.14
local literal = "Hello"
local literalBlok = [[Oke Siap]]
local table = { x = 10, y = 20 }
local fungsi = function(n)
	return n * n
end

print(null, boolean, integer, floating, literal)
print(literalBlok)
print(table.x, table.y)
print(fungsi(5)) -- 25
```

---

## 5. Statement vs Ekspresi

### 📚 Istilah:

- **Ekspresi** = potongan kode yang **menghasilkan nilai**.
- **Statement** = perintah yang **menjalankan aksi**, tapi **tidak** jadi sebuah nilai.

### 🔍 Contoh:

```lua
-- Ekspresi:
3 + 4        -- hasil 7
"foo" .. "bar"  -- hasil "foobar"

-- Statement:
local sum = 3 + 4   -- mendeklarasi & assign
print(sum)           -- aksi cetak
```

> Kalau kamu ketik `3+4` di REPL, ia cetak `7` karena REPL otomatis print hasil ekspresi.

---

### 🎯 Tugas Praktik Modul 1

1. **Coba** semua contoh di atas di REPL (`lua`) dan di file `.lua`.
2. **Ganti** variabel dan ekspresi: misal kalkulasi sendiri, komentar kreasimu sendiri.
3. **Catat** istilah baru yang bikin kamu bingung—kita bahas segera.
