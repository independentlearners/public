# [Modul 8 — Debug Library (`debug`)][0]

Modul ini adalah salah satu **alat paling dalam** di Lua karena membuka akses ke “mesin dalam” interpreter Lua itu sendiri. Dengan debug library, kita bisa **mengintip stack, memodifikasi variabel runtime, membuat profiler sederhana, bahkan membangun debugger**.

---

<details>
  <summary>📃 Daftar Isi</summary>

### Struktur Pembelajaran Internal (mini-TOC)

* **8.1 Pengenalan Debug Library**

  * Apa itu debug library
  * Mengapa berbahaya jika disalahgunakan
  * Filosofi: introspeksi & metaprogramming
* **8.2 Fungsi Inti Debug Library**

  * `debug.debug`
  * `debug.getinfo`
  * `debug.getlocal` / `debug.setlocal`
  * `debug.getupvalue` / `debug.setupvalue`
  * `debug.traceback`
  * `debug.sethook`
* **8.3 Studi Kasus**

  * Membuat logger fungsi
  * Melihat call stack
  * Memodifikasi variabel runtime
* **8.4 Praktik Terbaik & Potensi Kesalahan**
* **8.5 Latihan & Kuiz**
* Visualisasi

</details>

---

## 8.1 Pengenalan Debug Library

### Deskripsi & Peran

* Debug library menyediakan **API introspeksi** untuk mengamati dan memodifikasi state Lua saat program berjalan.
* Ini memungkinkan:

  * Membuat debugger.
  * Profiling fungsi (menghitung berapa kali dipanggil).
  * Membaca/mengubah variabel lokal atau upvalue.

### Filosofi

* Lua sengaja membuat debug library **kuat tapi rawan bahaya**.
* Tidak dianjurkan dipakai di kode produksi biasa, kecuali untuk **alat bantu debugging** atau **tooling internal**.

---

## 8.2 Fungsi Inti Debug Library

### 1. `debug.debug`

```lua
function test()
  print("Sebelum debug")
  debug.debug()  -- masuk REPL interaktif
  print("Setelah debug")
end

test()
```

👉 Ketika sampai ke `debug.debug()`, Lua masuk mode interaktif (mirip REPL) di tengah eksekusi program. Bisa mengetik perintah Lua langsung.

---

### 2. `debug.getinfo`

```lua
local function foo(a, b)
  return a + b
end

local info = debug.getinfo(foo)
print(info.name, info.nparams, info.what)
```

👉 `debug.getinfo(fn)` mengembalikan tabel dengan info tentang fungsi: jumlah parameter (`nparams`), asal fungsi (`what`), nama, dll.

---

### 3. `debug.getlocal` & `debug.setlocal`

```lua
local function bar(x)
  local y = 42
  local i, v = 1, debug.getlocal(1, 2)  -- ambil variabel lokal ke-2 di stack level 1
  print("getlocal:", i, v)
end
bar(10)
```

👉 Bisa **membaca** (`getlocal`) atau **mengubah** (`setlocal`) variabel lokal dari fungsi yang sedang berjalan.

---

### 4. `debug.getupvalue` & `debug.setupvalue`

```lua
local function outer()
  local secret = 99
  local function inner()
    return secret
  end
  return inner
end

local f = outer()
print(debug.getupvalue(f, 1))  -- "secret"  99
debug.setupvalue(f, 1, 123)
print(f())  -- 123
```

👉 “Upvalue” = variabel lokal yang direferensikan oleh inner function (closure). Bisa diinspeksi & diubah.

---

### 5. `debug.traceback`

```lua
local function a() b() end
local function b() c() end
local function c()
  print(debug.traceback("Error di sini"))
end

a()
```

👉 Memberi **stack trace** untuk debugging. Berguna untuk error logging.

---

### 6. `debug.sethook`

```lua
local count = 0
debug.sethook(function()
  count = count + 1
end, "", 1)  -- hook setiap 1 instruksi

for i = 1, 1000 do end
debug.sethook()  -- matikan hook
print("Instruksi dieksekusi:", count)
```

👉 Memasang “hook” yang dipanggil setiap kali event tertentu terjadi:

* `"c"` → call fungsi
* `"r"` → return fungsi
* `"l"` → eksekusi baris kode
* `""` + angka → tiap N instruksi VM

Bisa dipakai untuk **profiler**.

---

## 8.3 Studi Kasus

### A. Logger Fungsi

```lua
local function trace(event, line)
  local info = debug.getinfo(2)
  if info then
    print(string.format("[%s] %s:%d", event, info.short_src, line or 0))
  end
end

debug.sethook(trace, "crl")  -- hook semua event
local function test() print("Hello") end
test()
debug.sethook()
```

---

### B. Melihat Call Stack

```lua
local function f1() f2() end
local function f2() f3() end
local function f3()
  local i = 1
  while true do
    local name, val = debug.getlocal(2, i)
    if not name then break end
    print("Level 2:", name, val)
    i = i + 1
  end
end

f1()
```

👉 Bisa mengintip isi variabel pada stack frame tertentu.

---

### C. Memodifikasi Variabel Runtime

```lua
local function secret_func()
  local hidden = "rahasia"
  debug.setlocal(1, 1, "terungkap!")  -- ubah variabel lokal ke-1
  print(hidden)
end

secret_func()
```

👉 Variabel `hidden` diubah saat runtime.

---

## Visualisasi Alur Debug Library

```
┌──────────────┐
│ debug.sethook│───────────┐
└──────┬───────┘           │
       ▼                   │
  Hook function ◄──────────┘
       │
       ▼
  getinfo / getlocal / traceback
```

---

## Praktik Terbaik

* Gunakan debug library hanya untuk **debugging, profiling, atau tooling**.
* Jangan biarkan `debug.debug()` aktif di production (rawan security).
* Hati-hati memodifikasi variabel dengan `setlocal` / `setupvalue` karena bisa membuat bug sulit dilacak.
* Gunakan `traceback` untuk logging error daripada menulis stack trace manual.

---

## Potensi Kesalahan Umum

* **Mengubah variabel yang salah indeksnya** → hasil program rusak.
* **Lupa mematikan hook** dengan `debug.sethook()` → performa turun drastis.
* **Mengira `debug` itu safe** → padahal bisa membuka akses rawan (misal membaca password di memori).

---

## Latihan & Kuiz

1. Gunakan `debug.getinfo` untuk mencetak semua fungsi yang dipanggil dalam program sederhana.
2. Buat hook dengan `debug.sethook` yang menghitung berapa kali fungsi tertentu dipanggil.
3. Apa hasil `debug.getupvalue` jika indeks upvalue tidak ada?
   (jawaban: `nil`).

---

## Hubungan dengan Modul Lain

* **Modul 6 (Coroutine):** debug berguna untuk introspeksi coroutine (lihat status stack).
* **Modul 7 (Require):** bisa dipakai untuk membuat hot-reload modul saat debugging.
* **Modul 14 (C API):** debug library bisa dipakai untuk bridging dengan profiler C.

---

## Referensi

* Lua 5.4 Reference Manual — [Debug Library](https://www.lua.org/manual/5.4/manual.html#6.10)
* *Programming in Lua* (Roberto Ierusalimschy), Bab 23: The Debug Library
* Lua-users wiki — [Debug Library](http://lua-users.org/wiki/DebugLibraryTutorial)

---

<<!--
Apakah Anda ingin saya **buat mini-project berbasis debug** (contoh: logger stack trace otomatis untuk semua error), atau kita **langsung lanjut ke Modul 9: Metatable & Metamethods**?
-->>

Kita buat **Mini-Project berbasis Debug Library**: *Error Logger dengan Stack Trace Otomatis*.
Proyek ini memperlihatkan bagaimana debug library bisa dipakai untuk **menangkap error**, **menyimpan stack trace**, dan **membuat laporan log** yang berguna untuk debugging.

---

# Mini-Project: Error Logger dengan Stack Trace Otomatis

## Tujuan

* Menggunakan `debug.traceback` untuk menangkap call stack saat error.
* Membuat fungsi `safe_call` yang mengeksekusi kode dan otomatis mencatat error.
* Menyimpan log error ke file `error.log` agar bisa ditinjau kemudian.

---

## Implementasi Kode

```lua
-- error_logger.lua
-- Mini-project: Logger error dengan stack trace otomatis

-- Fungsi untuk menyimpan pesan error ke file
local function log_error(msg)
  local file = io.open("error.log", "a")
  file:write(string.format("[%s]\n%s\n\n",
    os.date("%Y-%m-%d %H:%M:%S"), msg))
  file:close()
end

-- Fungsi pembungkus yang aman
local function safe_call(fn, ...)
  local args = {...}
  local ok, result = xpcall(
    function() return fn(table.unpack(args)) end,
    function(err)
      local trace = debug.traceback("Error: " .. tostring(err), 2)
      log_error(trace)
      return trace
    end
  )
  return ok, result
end

-- Contoh fungsi yang akan error
local function buggy_divide(a, b)
  return a / b   -- jika b = 0, error
end

-- Contoh penggunaan
print("=== Program dimulai ===")

local ok, res = safe_call(buggy_divide, 10, 0)
if not ok then
  print("Terjadi error! Cek file error.log untuk detail.")
else
  print("Hasil:", res)
end

print("=== Program selesai ===")
```

---

## Penjelasan Kode

### Fungsi `log_error`

```lua
local function log_error(msg)
  local file = io.open("error.log", "a")
  file:write(string.format("[%s]\n%s\n\n",
    os.date("%Y-%m-%d %H:%M:%S"), msg))
  file:close()
end
```

* Membuka file `error.log` dengan mode `a` (append → tambah di akhir).
* Menyimpan pesan error bersama timestamp.
* Menutup file agar data tersimpan dengan aman.

---

### Fungsi `safe_call`

```lua
local function safe_call(fn, ...)
  local args = {...}
  local ok, result = xpcall(
    function() return fn(table.unpack(args)) end,
    function(err)
      local trace = debug.traceback("Error: " .. tostring(err), 2)
      log_error(trace)
      return trace
    end
  )
  return ok, result
end
```

* `xpcall` → eksekusi fungsi dengan mekanisme penangkap error.
* `fn(table.unpack(args))` → memanggil fungsi target dengan argumen.
* Jika error:

  * `debug.traceback("Error: ...", 2)` → membuat stack trace dari error.
  * `log_error(trace)` → simpan ke file.
* `ok` → `true` jika sukses, `false` jika error.
* `result` → hasil fungsi (jika sukses) atau pesan error (jika gagal).

---

### Fungsi `buggy_divide`

```lua
local function buggy_divide(a, b)
  return a / b
end
```

👉 Contoh fungsi rawan error (pembagian dengan nol).

---

### Bagian utama

```lua
local ok, res = safe_call(buggy_divide, 10, 0)
if not ok then
  print("Terjadi error! Cek file error.log untuk detail.")
else
  print("Hasil:", res)
end
```

* Panggil `buggy_divide` lewat `safe_call`.
* Jika error, pesan ditulis ke log dan user diberi tahu.
* Jika sukses, tampilkan hasil.

---

## Output di Terminal

```
=== Program dimulai ===
Terjadi error! Cek file error.log untuk detail.
=== Program selesai ===
```

---

## Isi File `error.log`

```
[2025-09-10 15:24:01]
Error: error_logger.lua:28: attempt to divide by zero
stack traceback:
    error_logger.lua:28: in function 'buggy_divide'
    error_logger.lua:18: in function <error_logger.lua:16>
    [C]: in function 'xpcall'
    error_logger.lua:16: in function 'safe_call'
    error_logger.lua:38: in main chunk
    [C]: in ?
```

---

## Visualisasi Alur

```
┌─────────────┐
│ safe_call() │
└─────┬───────┘
      │
      ▼
┌─────────────┐
│  xpcall     │
│ (fn, errcb) │
└─────┬───────┘
      │ error
      ▼
┌────────────────┐
│ debug.traceback│
│ + log_error    │
└────────────────┘
```

---

<<!--
Apakah Anda ingin kita **lanjut ke Modul 9: Metatable & Metamethods**, atau saya **buat versi lanjutan mini-project ini** (misalnya error logger dengan **notifikasi real-time ke console + simpan ke file**)?
-->>

Mari kita **bedah secara rinci kode mini-project "Error Logger dengan Stack Trace Otomatis"** agar jelas maksud dari setiap baris dan fungsinya.

---

# 📂 File: `error_logger.lua`

```lua
-- error_logger.lua
-- Mini-project: Logger error dengan stack trace otomatis
```

👉 Komentar, menjelaskan nama file dan tujuan program: logger error otomatis dengan stack trace.

---

## 1. Fungsi untuk mencatat error

```lua
local function log_error(msg)
  local file = io.open("error.log", "a")
  file:write(string.format("[%s]\n%s\n\n",
    os.date("%Y-%m-%d %H:%M:%S"), msg))
  file:close()
end
```

* `local function log_error(msg)`
  Membuat fungsi lokal bernama `log_error` dengan parameter `msg` (isi pesan error).
* `io.open("error.log", "a")`
  Membuka file `error.log` dengan mode **append** (`a`).

  * Jika file belum ada → dibuat baru.
  * Jika sudah ada → teks baru ditulis di akhir.
* `string.format("[%s]\n%s\n\n", os.date(...), msg)`
  Menyusun format teks log:

  * `[2025-09-10 15:24:01]` → waktu saat error.
  * `msg` → isi pesan error + stack trace.
  * `\n\n` → memberi jarak antar error.
* `file:write(...)` → menulis pesan ke file.
* `file:close()` → menutup file agar isi benar-benar tersimpan.

👉 Hasilnya: setiap error disimpan ke **error.log** dengan timestamp.

---

## 2. Fungsi pembungkus eksekusi aman

```lua
local function safe_call(fn, ...)
  local args = {...}
  local ok, result = xpcall(
    function() return fn(table.unpack(args)) end,
    function(err)
      local trace = debug.traceback("Error: " .. tostring(err), 2)
      log_error(trace)
      return trace
    end
  )
  return ok, result
end
```

* `local function safe_call(fn, ...)`
  Membuat fungsi `safe_call` untuk memanggil fungsi `fn` dengan parameter apapun (`...`).

* `local args = {...}`
  Menyimpan semua argumen dalam bentuk tabel.

* `xpcall(func, err_handler)`
  Fungsi bawaan Lua untuk **menangkap error** saat menjalankan `func`.

  * Jika tidak ada error → return nilai dari `func`.
  * Jika error → jalankan `err_handler`.

* Bagian pertama:

  ```lua
  function() return fn(table.unpack(args)) end
  ```

  Memanggil `fn` dengan argumen asli.

* Bagian kedua (handler error):

  ```lua
  function(err)
    local trace = debug.traceback("Error: " .. tostring(err), 2)
    log_error(trace)
    return trace
  end
  ```

  * `err` → pesan error standar Lua (misal: `"attempt to divide by zero"`).
  * `debug.traceback(msg, 2)` → menambahkan stack trace ke pesan error.

    * `2` artinya mulai dari level stack di atas error handler (agar lebih bersih).
  * `log_error(trace)` → simpan error ke file.
  * `return trace` → mengembalikan pesan error ke pemanggil.

* `local ok, result = xpcall(...)`

  * `ok = true` jika eksekusi berhasil, `false` jika ada error.
  * `result = hasil fungsi` (jika sukses) atau `trace` (jika error).

👉 `safe_call` membuat eksekusi aman: tidak menghentikan program meskipun ada error.

---

## 3. Fungsi contoh yang error

```lua
local function buggy_divide(a, b)
  return a / b   -- jika b = 0, error
end
```

* Membuat fungsi sederhana yang membagi `a` dengan `b`.
* Jika `b = 0`, Lua akan menghasilkan error `"attempt to divide by zero"`.
* Fungsi ini dipakai sebagai target untuk diuji dengan `safe_call`.

---

## 4. Program utama

```lua
print("=== Program dimulai ===")

local ok, res = safe_call(buggy_divide, 10, 0)
if not ok then
  print("Terjadi error! Cek file error.log untuk detail.")
else
  print("Hasil:", res)
end

print("=== Program selesai ===")
```

* `print("=== Program dimulai ===")` → tanda awal eksekusi.

* `safe_call(buggy_divide, 10, 0)`

  * Memanggil `buggy_divide(10, 0)`.
  * Karena `b = 0`, terjadi error → ditangkap oleh `safe_call`.
  * `ok = false`, `res = traceback error`.

* `if not ok then ... else ... end`

  * Jika error → beri pesan agar user lihat `error.log`.
  * Jika sukses → tampilkan hasil.

* `print("=== Program selesai ===")` → tanda akhir eksekusi.

---

## 📄 Contoh Output di Terminal

```
=== Program dimulai ===
Terjadi error! Cek file error.log untuk detail.
=== Program selesai ===
```

---

## 📄 Isi File `error.log`

```
[2025-09-10 15:24:01]
Error: error_logger.lua:28: attempt to divide by zero
stack traceback:
    error_logger.lua:28: in function 'buggy_divide'
    error_logger.lua:18: in function <error_logger.lua:16>
    [C]: in function 'xpcall'
    error_logger.lua:16: in function 'safe_call'
    error_logger.lua:38: in main chunk
    [C]: in ?
```

* Baris pertama → timestamp.
* Baris kedua → pesan error utama.
* Stack traceback → jejak pemanggilan fungsi dari awal sampai error.

---

# 🔑 Inti Pemahaman

* **`log_error`** → menyimpan error ke file dengan timestamp.
* **`safe_call` + `xpcall`** → cara aman memanggil fungsi tanpa membuat program berhenti saat error.
* **`debug.traceback`** → menambahkan informasi call stack untuk mempermudah debugging.
* **`buggy_divide`** → contoh fungsi error.
* **Program utama** → menjalankan fungsi, cek apakah sukses atau error, dan memberi pesan sesuai hasil.

---

## Praktik Terbaik

* Bungkus fungsi kritis dengan `safe_call` untuk logging otomatis.
* Gunakan `debug.traceback` agar pesan error lebih informatif.
* Pisahkan log error ke file khusus agar tidak bercampur dengan output program.

---

## Latihan

1. Modifikasi `buggy_divide` agar memicu error lain (misalnya input bukan angka).
2. Tambahkan `safe_call` pada fungsi lain, lalu cek isi `error.log`.
3. Buat fungsi `safe_require(modulename)` yang memanggil `require` dengan `safe_call`.

---


<<!--
Apakah Anda ingin saya **kembangkan mini-project ini lebih jauh** (misalnya logger dengan **notifikasi ke console + simpan ke file**), atau kita **lanjut ke Modul 9: Metatable & Metamethods**?
-->>

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
