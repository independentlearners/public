# Modul 2: Sintaks Dasar & Tipe Data

## 🔤 1. Token & Identifiers

### Istilah:

- **Token** = unit terkecil dalam kode: keyword, identifier, literal, operator, tanda baca.
- **Identifier** = nama untuk variabel, fungsi, modul. Aturan:

  - Mulai dengan huruf atau underscore (`_`),
  - Diikuti huruf, digit, atau underscore.
  - Peka huruf besar/kecil (case-sensitive).

### Contoh:

```lua
local _count = 10      -- `_count` dan `count` beda
local userName = "Ameer"
```

---

## 🔢 2. Keyword & Delimiter

### Istilah:

- **Keyword** = kata khusus yang sudah dipakai bahasa (tak boleh jadi identifier), misal:
  `and, break, do, else, elseif, end, false, for, function, goto, if, in, local, nil, not, or, repeat, return, then, true, until, while`.
- **Delimiter** = simbol tanda baca:
  `; , . : () {} []`.

### Contoh penggunaan keyword:

```lua
if userName ~= nil then    -- `if`, `then`, `end`
  print("Hello, " .. userName)
end
```

---

## 💥 3. Literals & Tipe Data

| Tipe       | Literal Contoh                     | Deskripsi                              |
| ---------- | ---------------------------------- | -------------------------------------- |
| `nil`      | `nil`                              | Kosong, tak didefinisikan              |
| `boolean`  | `true`, `false`                    | Logika                                 |
| `number`   | `123`, `3.14`, `0xFF`              | Integer, float, hex                    |
| `string`   | `'a'`, `"halo"`, `[[multi\nline]]` | Teks                                   |
| `table`    | `{}`, `{1,2,3}`, `{x=1,y=2}`       | Struktur data utama                    |
| `function` | `function() end`                   | First-class, bisa disimpan di variabel |

---

## ⚙️ 4. Operators

### Istilah & Kategori:

1. **Aritmatika**: `+`, `-`, `*`, `/`, `^` (pangkat), `%` (modulo)
2. **Kompasi**: `==`, `~=`, `<`, `>`, `<=`, `>=`
3. **Logika**: `and`, `or`, `not`
4. **Konkatenasi string**: `..`
5. **Length operator**: `#` (panjang string/table)

### Contoh:

```lua
local a, b = 5, 2
print(a + b, a ^ b)       -- 7, 25
print(a > b and true)     -- true
print("foo" .. "bar")     -- "foobar"
print(#"hello")           -- 5
```

---

## 📜 5. Statement & Syntax Dasar

### Istilah:

- **Statement** = baris perintah: assignment, `if`, `for`, `while`, `repeat`, `return`, `break`, `goto`.
- **Whitespace** & **newline** memisahkan token, tetapi `;` bisa digunakan untuk banyak statement di satu baris.

### Contoh assignment & block:

```lua
local x = 10  -- assignment

if x > 5 then      -- block IF
  x = x - 1
else
  x = x + 1
end
```

---

## 🏷️ 6. Table Constructors

### Istilah:

- **Array-like**: `t = {1,2,3}`
- **Dictionary-like**: `t = {key1 = "val", key2 = 2}`
- **Mixed**: `t = {10, name="lua"}`

### Contoh akses:

```lua
local t = {10, 20, name="Neovim"}
print(t[1], t[2], t.name)  -- 10, 20, "Neovim"
```

---

## 🎯 Tugas Praktik Modul 2

1. **Buat file** `modul2.lua`, dan **coba** semua contoh di atas.
2. **Eksperimen**:

   - Definisikan beberapa variabel dengan berbagai tipe.
   - Gunakan semua operator.
   - Buat `if` sederhana dan table kecil.

3. **Catat** istilah baru atau error yang muncul—kita bahas satu per satu.
