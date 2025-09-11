# **[Modul 16: Concurrency & Asynchronous I/O (Coroutines, libuv/luv)][0]**

Modul ini dilengkapi dua **mini-project** lengkap — masing-masing disertai **pembahasan baris-per-baris** untuk setiap kode, sesuai permintaan Anda. Nada tetap profesional dan menyemangati.

Ringkasnya, Modul 16 mencakup:

1. **Coroutine murni (Lua)** — pola producer/consumer pipeline (sinkron cooperatif).
2. **Asynchronous I/O dengan `luv` (libuv binding untuk Lua)** — contoh TCP echo server non-blocking.

Setiap script dijelaskan seluruh barisnya: fungsi, maksud, efek pada memori/flow, dan catatan praktis. Mari mulai.

---

# Modul 16 — Bagian A: Coroutine (Cooperative Concurrency)

## Tujuan

* Memahami cara kerja coroutine di Lua (`coroutine.create`, `coroutine.resume`, `coroutine.yield`).
* Menerapkan pola producer → transformer → consumer menggunakan coroutine sebagai pipeline yang saling bergantian mengeksekusi (cooperative multitasking).
* Mengetahui kapan menggunakan coroutine (task ringan, stateful generators) dan batasannya (tidak paralel, tidak menjalankan IO blocking otomatis).

---

## Mini-Project A — Producer/Transformer/Consumer Pipeline (file: `co_pipeline.lua`)

```lua
-- co_pipeline.lua
-- Pipeline sederhana: producer -> transformer -> consumer menggunakan coroutine

-- Producer: menghasilkan angka 1..n
local function producer(n)
  return coroutine.create(function()
    for i = 1, n do
      -- kirim nilai ke luar coroutine (kepada pengendali pipeline)
      coroutine.yield(i)
    end
    -- selesai; jika resume lagi, coroutine sudah dead
  end)
end

-- Transformer: menerima nilai, mengubah (misal kuadrat), dan yield hasil
local function transformer(src_co)
  return coroutine.create(function()
    while true do
      local ok, v = coroutine.resume(src_co)   -- minta nilai dari producer
      if not ok then
        error("error resume producer: " .. tostring(v))
      end
      if v == nil then
        -- producer selesai -> hentikan transformer
        return
      end
      local out = v * v
      coroutine.yield(out) -- kirim hasil ke pengendali
    end
  end)
end

-- Consumer: mengonsumsi nilai sampai tidak ada lagi
local function consumer(src_co)
  return coroutine.create(function()
    while true do
      local ok, v = coroutine.resume(src_co)
      if not ok then
        error("error resume transformer: " .. tostring(v))
      end
      if v == nil then
        return
      end
      print("Consumer menerima:", v)
      -- di sini bisa ada IO / operasi lain (harus non-blocking agar pipeline tetap responsif)
    end
  end)
end

-- Pengendali pipeline: hubungkan semuanya
local function run_pipeline(n)
  local prod = producer(n)
  local trans = transformer(prod)
  local cons = consumer(trans)

  -- terus resume consumer sampai selesai
  while coroutine.status(cons) ~= "dead" do
    local ok, _ = coroutine.resume(cons)
    if not ok then error("pipeline error") end
  end
end

-- entry point
local argn = tonumber(arg and arg[1]) or 10
run_pipeline(argn)
```

---

## Penjelasan lengkap — baris demi baris

Saya jelaskan setiap blok / baris penting. Untuk satu-satu yang bersifat sangat mekanis (mis. keyword `local`, `end`) saya jelaskan konteks dan mengapa diletakkan demikian.

### Header / komentar

```lua
-- co_pipeline.lua
-- Pipeline sederhana: producer -> transformer -> consumer menggunakan coroutine
```

* Komentar file: memberi tahu tujuan file. Tidak dieksekusi.

### Producer

```lua
local function producer(n)
  return coroutine.create(function()
    for i = 1, n do
      coroutine.yield(i)
    end
  end)
end
```

* `local function producer(n)` → deklarasi fungsi pembuat coroutine; `n`: jumlah item yang akan dihasilkan.
* `coroutine.create(function() ... end)` → membuat coroutine baru yang menjalankan fungsi anonim.
* `for i = 1, n do` → loop dari 1 sampai n.
* `coroutine.yield(i)` → menghentikan eksekusi coroutine sementara dan mengembalikan nilai `i` ke pihak yang `resume` coroutine tersebut. Penting: `yield` bukan `return` — coroutine tetap bisa di-resume.
* Ketika loop selesai, fungsi anonimitas mencapai akhir ⇒ coroutine berakhir (status `"dead"`). Jika ada resume setelah dead, `coroutine.resume` akan mengembalikan `false, "cannot resume dead coroutine"`.

**Catatan praktis**: producer tidak tahu siapa yang akan memanggilnya; ia hanya menghasilkan data satu per satu.

### Transformer

```lua
local function transformer(src_co)
  return coroutine.create(function()
    while true do
      local ok, v = coroutine.resume(src_co)
      if not ok then
        error("error resume producer: " .. tostring(v))
      end
      if v == nil then
        return
      end
      local out = v * v
      coroutine.yield(out)
    end
  end)
end
```

* `transformer(src_co)` → membuat coroutine yang mengambil sumber `src_co` (seharusnya coroutine producer).
* `while true do` → loop terus-menerus; transformer menunggu nilai dari source.
* `local ok, v = coroutine.resume(src_co)` → minta nilai berikutnya dari `src_co`. `coroutine.resume` mengembalikan `ok` (boolean) dan nilai yang di-yield atau error message.
* `if not ok then error(...) end` → jika `resume` gagal (mis. karena error di producer), kita bubble error dengan penjelasan.
* `if v == nil then return end` → jika resume berhasil tetapi mendapatkan `nil` itu bisa menandakan finishing; catatan: `producer` kita selalu `yield` angka 1..n, jadi `nil` biasanya karena `resume` dilakukan pada coroutine yang dead (di beberapa pola). Ini guard untuk stop transformer.
* `local out = v * v` → transformasi: kuadratkan nilai.
* `coroutine.yield(out)` → kirim hasil ke caller (pengendali pipeline / consumer).

**Catatan**: transformer *memanggil* producer (pull model). Kita memakai pull supaya consumer bisa mengendalikan aliran.

### Consumer

```lua
local function consumer(src_co)
  return coroutine.create(function()
    while true do
      local ok, v = coroutine.resume(src_co)
      if not ok then
        error("error resume transformer: " .. tostring(v))
      end
      if v == nil then
        return
      end
      print("Consumer menerima:", v)
    end
  end)
end
```

* `consumer(src_co)` → coroutine konsumen; `src_co` adalah transformer.
* Ia `resume` transformer untuk mendapatkan item tertransformasi.
* Sama seperti transformer, cek `ok` dan `v == nil`.
* `print("Consumer menerima:", v)` → simulasi konsumsi (bisa diganti dengan IO non-blocking/append ke DB, dsb).

**Catatan**: karena kita pakai `print` (blocking IO ke stdout), ini sesuai untuk demo; pada aplikasi produksi, blocking print besar-besaran bisa merusak responsivitas.

### Pengendali pipeline

```lua
local function run_pipeline(n)
  local prod = producer(n)
  local trans = transformer(prod)
  local cons = consumer(trans)

  while coroutine.status(cons) ~= "dead" do
    local ok, _ = coroutine.resume(cons)
    if not ok then error("pipeline error") end
  end
end
```

* `run_pipeline(n)` menyiapkan tiga coroutine berantai.
* `while coroutine.status(cons) ~= "dead"` → jalankan loop sampai consumer mati (artinya producer habis dan chain berhenti).
* `local ok, _ = coroutine.resume(cons)` → resume consumer. Saat consumer ingin data, ia akan `resume` transformer → transformer `resume` producer → dan seterusnya.
* Jika `resume` pada consumer mengembalikan `not ok`, kita keluarkan error generik.

**Catatan mekanika**: ini adalah model *cooperative pull* — caller (`run_pipeline`) memulai siklus dengan `resume(cons)`; control flow merambat turun via `resume`/`yield`.

### Entry point

```lua
local argn = tonumber(arg and arg[1]) or 10
run_pipeline(argn)
```

* `arg` adalah global array argumen CLI di Lua. `tonumber(arg and arg[1])` → ambil argumen pertama jika ada, konversi ke number.
* Jika tidak ada, default `10`.
* Panggil `run_pipeline(argn)`.

---

## Kapan pakai coroutine?

* Untuk **generator** (menghasilkan sequence besar tanpa menyimpan semua di memori).
* Untuk **cooperative multitasking** (sejumlah task ringan yang bergiliran melakukan kerja).
* BUKAN untuk paralel CPU-bound (tidak menjalankan di beberapa core).

---

# Modul 16 — Bagian B: Asynchronous I/O dengan `luv` (libuv binding untuk Lua)

## Tujuan

* Memperkenalkan cara membuat server I/O non-blocking menggunakan `luv` (binding libuv untuk Lua).
* Demonstrasikan TCP echo server sederhana yang melayani banyak klien secara asynchronous (tanpa thread manual) menggunakan event loop libuv.

---

## Persiapan lingkungan

* Pastikan **LuaJIT** atau Lua + `luv` terinstall. Di banyak distro gunakan `luarocks install luv` atau paket distro.

  * Contoh (Arch/Manjaro): `sudo pacman -S luarocks luajit` lalu `luarocks install luv`.
* Jalankan script dengan `luajit` atau `lua` (jika `luv` disusun untuk Lua yang Anda pakai).

---

## Mini-Project B — TCP Echo Server Asynchronous (file: `luv_echo.lua`)

```lua
-- luv_echo.lua
-- TCP echo server sederhana menggunakan luv (libuv binding)

local luv = require("luv")

local HOST = "0.0.0.0"
local PORT = tonumber(arg and arg[1]) or 7000

-- callback ketika data diterima
local function on_read(client, err, data)
  if err then
    -- error (misal client disconnect) -> tutup handle
    client:shutdown()
    client:close()
    return
  end
  if data then
    -- data diterima -> echo balik
    client:write(data)
  else
    -- EOF (client graceful close) -> tutup
    client:close()
  end
end

-- ketika koneksi baru diterima oleh server
local function on_connection(server, err)
  if err then
    print("Server accept error:", err)
    return
  end
  -- buat TCP client handle
  local client = luv.new_tcp()
  server:accept(client)

  -- mulai membaca dari client; luv akan memanggil on_read ketika ada data
  client:read_start(function(err2, chunk) on_read(client, err2, chunk) end)
end

-- buat server TCP
local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, on_connection)

print(string.format("Echo server berjalan di %s:%d", HOST, PORT))

-- jalankan event loop luv
luv.run()
```

---

## Penjelasan lengkap — tiap baris & alasannya

### Header & require

```lua
local luv = require("luv")
```

* Memuat binding `luv`. `luv` adalah wrapper libuv yang menyediakan API event loop, TCP, file I/O, timers, dsb.
* Jika require gagal, pastikan `luv` terinstal via luarocks/paket.

### Konfigurasi

```lua
local HOST = "0.0.0.0"
local PORT = tonumber(arg and arg[1]) or 7000
```

* `HOST` = `0.0.0.0` agar menerima koneksi dari semua interface.
* `PORT` diambil dari argumen CLI jika ada; default `7000`.

### Callback on\_read

```lua
local function on_read(client, err, data)
  if err then
    client:shutdown()
    client:close()
    return
  end
  if data then
    client:write(data)
  else
    client:close()
  end
end
```

* `on_read` dipanggil `luv` saat ada event baca dari `client`.
* Parameter:

  * `client` → handle TCP client (object luv).
  * `err` → error message (jika ada).
  * `data` → chunk string data yang dibaca; `nil` saat EOF (connection closed).
* Jika `err` (misal ECONNRESET) → shutdown & close klien.
* Jika `data` bukan nil → echo balik via `client:write(data)`.
* Jika `data == nil` → client menutup koneksi secara normal → kita close handle.

**Catatan penting**:

* `client:write` bersifat asinkron dan non-blocking; data akan dipush ke buffer dan libuv akan mengurus pengiriman.
* Jangan panggil blocking operation di callback (mis. sleep lama) karena memblokir seluruh loop.

### Callback on\_connection

```lua
local function on_connection(server, err)
  if err then
    print("Server accept error:", err)
    return
  end
  local client = luv.new_tcp()
  server:accept(client)
  client:read_start(function(err2, chunk) on_read(client, err2, chunk) end)
end
```

* `on_connection` dipanggil saat ada koneksi baru pada `server`.
* `server:accept(client)` menerima koneksi baru, mengikatnya ke `client` handle.
* `client:read_start(callback)` mulai membaca data; `callback` akan dipanggil per chunk data masuk.
* Semua operasi ini **non-blocking**: server bisa menerima banyak koneksi bersamaan karena `luv` mengatur event loop.

### Membuat dan menjalankan server

```lua
local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, on_connection)
print(string.format("Echo server berjalan di %s:%d", HOST, PORT))
luv.run()
```

* `luv.new_tcp()` → buat handle TCP.
* `server:bind(HOST, PORT)` → bind ke alamat & port.
* `server:listen(backlog, on_connection)` → mulai listen; `128` backlog standar.
* `luv.run()` → mulai event loop; fungsi ini **blok** (looping) sampai tidak ada lagi handle aktif.

**Keamanan & praktik**:

* Pastikan `on_read` menolak atau membatasi ukuran chunk jika menghindari DoS.
* Untuk produksi, tambahkan signal handler (SIGINT) untuk shutdown graceful.

---

## Cara menjalankan demo luv echo server

1. Pastikan `luv` terpasang:

   ```bash
   luarocks install luv
   ```

   Atau pasang paket distribusi jika tersedia.

2. Jalankan server:

   ```bash
   luajit luv_echo.lua 7000
   ```

   Jika tidak memakai arg port, default 7000.

3. Tes dari shell:

   ```bash
   # menggunakan netcat
   nc 127.0.0.1 7000
   Hello
   # Anda akan melihat "Hello" kembali (echo)
   ```

---

## Catatan komparatif Coroutine vs luv (libuv)

* **Coroutine**:

  * Sederhana, murni-Lua, cocok untuk generator / state machines.
  * Cooperative: satu coroutine harus secara eksplisit `yield` agar lainnya berjalan.
  * Tidak mengelola I/O asynchronous sendiri (harus digabung dengan event loop atau non-blocking primitives).
* **luv/libuv**:

  * Event-driven, non-blocking I/O, cocok untuk server network/IO heavy.
  * Mengatur event loop, callback, timers, fs watchers.
  * Bisa dipadukan dengan coroutine untuk membuat code yang terlihat sinkron tapi non-blocking (mis. gunakan wrapper untuk menjembatani callback → coroutine).

---

## Contoh: Integrasi coroutine + luv (pattern berguna)

* Anda dapat membuat helper yang `wrap` callback luv menjadi fungsi yang `yield` dari coroutine, lalu `resume` kembali di callback — membentuk *synchronous style API* di atas event loop. Itu topik lanjutan; jika Anda mau, saya bisa tunjukkan pola itu.

---

# Ringkasan & Langkah Selanjutnya

Anda sudah mendapatkan:

* Pool pengetahuan: coroutine (cooperative) dan `luv` (event-driven).
* Dua mini-project lengkap:

  * `co_pipeline.lua` — pipeline coroutine, dibedah setiap baris.
  * `luv_echo.lua` — TCP echo server asinkron, dibedah setiap baris.
* Instruksi menjalankan dan catatan praktis (instal luarocks/via paket).

Jika Anda siap, langkah berikut yang sering direkomendasikan:

* (A) Saya tunjukkan *pattern* mengubah callback luv menjadi coroutine-friendly API (contoh `await` sederhana).
* (B) Melanjutkan ke **Modul 17** (mis. testing & CI untuk proyek Lua, atau integrasi ke Neovim plugin non-blocking).
* (C) Anda ingin saya langsung **gabungkan contoh**: pipeline yang memakai luv untuk IO dan coroutine untuk processing (contoh: server yang menerima stream angka, proses coroutine pipeline, kirim hasil kembali)?

Pilih satu opsi singkat (A / B / C) — saya langsung kerjakan tanpa tanya lagi.

Bagus — kita mulai **A (callback → coroutine / await pattern)** sekarang.
Saya akan:

1. Tulis modul bantuan `luv_async.lua` yang menyediakan fungsi `go`, `await`, dan beberapa pembungkus (sleep, read\_once, write) untuk menjadikan API `luv` *coroutine-friendly* (gaya `async/await`).
2. Tulis contoh server echo `async_echo.lua` yang memakai modul tersebut: setiap koneksi ditangani oleh sebuah coroutine sehingga kode handler terlihat sinkron tetapi berjalan asinkron di dalam event loop `luv`.
3. **Bedah setiap baris kode** secara rinci (tujuan, efek, perilaku memori, dan catatan keselamatan).
4. Berikan petunjuk menjalankan, praktik terbaik, dan potensi jebakan.

Kerjakanannya lengkap dan dapat langsung Anda salin & jalankan.

---

## A. Modul helper: `luv_async.lua`

Simpan sebagai `luv_async.lua`.

```lua
-- luv_async.lua
-- Helper kecil: ubah callback-style luv menjadi awaitable coroutine-style.
-- API utama:
--   go(fn, ...)       -> jalankan fn(...) sebagai coroutine (fire-and-forget)
--   await(register)   -> jalankan register(callback) dan yield sampai callback dipanggil
--   sleep(ms)         -> awaitable timer
--   read_once(client) -> baca satu chunk dari client dan return (err, data)
--   write(client, d)  -> tulis data dan tunggu callback selesai (err)

local luv = require("luv")

local M = {}

-- go: jalankan fungsi sebagai coroutine (jika error, print trace)
function M.go(fn, ...)
  local co = coroutine.create(fn)
  local ok, err = coroutine.resume(co, ...)
  if not ok then
    -- jangan biarkan error lenyap; laporkan dengan trace
    local trace = debug.traceback(co, tostring(err))
    print("Uncaught error in coroutine:\n", trace)
  end
  return co
end

-- await: register adalah fungsi yang menerima `cb` -> register(cb) harus memulai async work
--   cb(...) akan dipanggil oleh operasi asinkron; nilai-nilai yang dilewatkan cb akan
--   dikembalikan sebagai hasil await(...)
function M.await(register)
  -- harus dijalankan di dalam coroutine
  local co = coroutine.running()
  if not co then error("await must be called from inside a coroutine") end

  local resumed = false

  -- pembungkus callback yang hanya resume coroutine sekali (guard double-resume)
  local function once_cb(...)
    if resumed then
      -- jika callback dipanggil berulang, abaikan sisa (atau bisa queue)
      return
    end
    resumed = true
    local ok, err_or_r1, r2, r3 = coroutine.resume(co, ...)
    if not ok then
      -- jika resume error, cetak trace agar tidak mati silent
      local trace = debug.traceback(co, tostring(err_or_r1))
      print("Error resuming coroutine from callback:\n", trace)
    end
  end

  -- register callback; di sini kita mengasumsikan register memulai operasi asinkron
  -- contoh register: function(cb) timer:start(ms, 0, cb) end
  register(once_cb)

  -- yield sampai callback memanggil coroutine kembali; kembalikan semua nilai callback
  return coroutine.yield()
end

-- sleep berbasis luv timer
function M.sleep(ms)
  return M.await(function(cb)
    local t = luv.new_timer()
    -- sebelum resume, hentikan & close timer agar tidak bocor
    t:start(ms, 0, function()
      t:stop()
      t:close()
      cb()
    end)
  end)
end

-- baca 1 chunk kemudian stop membaca
function M.read_once(client)
  return M.await(function(cb)
    -- start membaca; callback signature: function(err, data)
    client:read_start(function(err, data)
      -- hentikan membaca langsung agar tidak terus menerus memicu
      client:read_stop()
      cb(err, data)
    end)
  end)
end

-- tulis data, tunggu callback selesai (err)
function M.write(client, data)
  return M.await(function(cb)
    client:write(data, function(err)
      cb(err)
    end)
  end)
end

return M
```

---

### Penjelasan detail `luv_async.lua` — baris demi baris

Saya jelaskan setiap bagian dan baris yang penting — mengapa ada, bagaimana kerja memori, dan catatan keamanan/performance.

#### Header & require

```lua
local luv = require("luv")
local M = {}
```

* `luv` adalah binding libuv untuk Lua. Kami memerlukannya karena modul akan membuat timer (`luv.new_timer()`), dan digunakan oleh contoh.
* `M` adalah tabel modul yang akan kita `return` di akhir.

#### `M.go(fn, ...)`

```lua
function M.go(fn, ...)
  local co = coroutine.create(fn)
  local ok, err = coroutine.resume(co, ...)
  if not ok then
    local trace = debug.traceback(co, tostring(err))
    print("Uncaught error in coroutine:\n", trace)
  end
  return co
end
```

* Tujuan: jalankan `fn(...)` di coroutine. Pola ini memudahkan spawn handler tanpa blocking.
* `coroutine.create(fn)` membuat coroutine objektif. `coroutine.resume(co, ...)` memulai coroutine.
* Jika coroutine melempar error saat `resume`, kita tangkap (`ok == false`) lalu cetak trace agar kesalahan tidak hilang tanpa jejak. Ini membantu debugging asinkron.
* Mengembalikan `co` (bila ingin memeriksa status).
* **Catatan memori**: coroutine dan state-nya akan hidup selama ada referensi (mis. `co` atau closure yang merujuk). Pastikan tidak menyimpan terlalu banyak coroutine tak terpakai.

#### `M.await(register)`

```lua
function M.await(register)
  local co = coroutine.running()
  if not co then error("await must be called from inside a coroutine") end

  local resumed = false

  local function once_cb(...)
    if resumed then return end
    resumed = true
    local ok, err_or_r1, r2, r3 = coroutine.resume(co, ...)
    if not ok then
      local trace = debug.traceback(co, tostring(err_or_r1))
      print("Error resuming coroutine from callback:\n", trace)
    end
  end

  register(once_cb)
  return coroutine.yield()
end
```

* **Peran**: menjembatani fungsi callback-style ke coroutine-style. `register` adalah fungsi yang memulai operasi asinkron dan menerima callback `cb`.
* `coroutine.running()` mengembalikan coroutine yang sedang berjalan — `await` hanya boleh dipanggil dari dalam coroutine. Jika dipanggil dari thread utama tanpa coroutine, kita turunkan error. Ini menjaga kontrak (tidak dapat `yield` di luar coroutine).
* `resumed` boolean mencegah *double-resume* (bila callback dipanggil berkali-kali, kita hanya resume sekali). Double-resume akan menimbulkan error (cannot resume running coroutine / resume dead) dan potensi crash logika.
* `once_cb(...)` adalah callback yang akan dipasok ke operasi asinkron. Ketika callback dipanggil oleh luv, ia akan `coroutine.resume(co, ...)` — ini mengirim nilai kembali ke titik `coroutine.yield()` di `await`. Jika `coroutine.resume` menghasilkan `not ok` (error di coroutine ketika di-resume), kita capture trace dan print — penting supaya error asinkron tidak hilang.
* `register(once_cb)` memicu operasi asinkron. Contract: `register` harus memanggil `once_cb(...)` saat selesai. Contoh: `register(function(cb) timer:start(ms,0,cb) end)`.
* `return coroutine.yield()` — coroutine akan berhenti di sini sampai `once_cb` dipanggil yang kemudian resume dan melewatkan argumen ke `yield`, jadi `await` mengembalikan argumen-argumen itu.

**Contoh aliran**:

1. Coroutine memanggil `local x = await(register)` → coroutine `yield`.
2. `register` memulai operasi, passing `once_cb`.
3. Ketika operasi selesai, `once_cb(result)` dipanggil → `coroutine.resume(co, result)` → `await` (`coroutine.yield()`) mengembalikan `result`.

#### `M.sleep(ms)`

```lua
function M.sleep(ms)
  return M.await(function(cb)
    local t = luv.new_timer()
    t:start(ms, 0, function()
      t:stop()
      t:close()
      cb()
    end)
  end)
end
```

* Wrapper convenience: buat timer `t`, `start(ms, 0, callback)` akan dipanggil sekali setelah `ms` milidetik.
* Di callback kita `t:stop()` dan `t:close()` untuk membebaskan handle timer — mencegah memory/resource leak.
* `cb()` dipanggil tanpa argumen; sehingga `M.sleep` akan `yield` sampai timer selesai.

**Catatan**: pastikan `t` tidak di-collect/garbage sebelum callback — variabel lokal `t` di closure menjaga lifetime sampai callback dijalankan.

#### `M.read_once(client)`

```lua
function M.read_once(client)
  return M.await(function(cb)
    client:read_start(function(err, data)
      client:read_stop()
      cb(err, data)
    end)
  end)
end
```

* Membaca satu chunk data dari `client` lalu berhenti membaca (`read_stop`) sehingga coroutine menerima satu `data` saja.
* `client:read_start(callback)` callback menerima `(err, data)` sesuai `luv` docs. Kita langsung memanggil `cb(err, data)` yang akan menjadi return value `await`.
* **Catatan**: kalau chunk besar diperlukan mungkin callback akan dipanggil berkali-kali; pola ini hanya mengambil chunk pertama. Untuk loop baca, panggil `read_once` berulang.

#### `M.write(client, data)`

```lua
function M.write(client, data)
  return M.await(function(cb)
    client:write(data, function(err)
      cb(err)
    end)
  end)
end
```

* Menulis data via `client:write(data, callback)` lalu menunggu callback penulisan selesai. `cb(err)` meneruskan kesalahan jika ada.
* Berguna agar handler coroutine bisa menulis sinkron-style:

  ```lua
  local err = await(write(client, "ok"))
  if err then ... end
  ```

#### `return M`

* Eksport modul.

---

## B. Contoh penggunaan: `async_echo.lua`

Simpan sebagai `async_echo.lua`. Ini menunjukkan pola real-world: server luv menerima koneksi; untuk tiap koneksi kita `go` coroutine handler yang memakai `await` wrappers untuk read & write — sehingga handler terlihat sinkron.

```lua
-- async_echo.lua
local luv = require("luv")
local async = require("luv_async") -- modul helper di atas

local HOST = "0.0.0.0"
local PORT = 7000

local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, function(err)
  if err then
    print("listen error:", err)
    return
  end

  -- accept client handle
  local client = luv.new_tcp()
  server:accept(client)

  -- jalankan handler sebagai coroutine agar bisa pakai await()
  async.go(function()
    print("Client terhubung")
    while true do
      -- baca satu chunk
      local err_r, data = async.read_once(client)
      if err_r then
        -- kemungkinan client disconnect atau error
        print("read error:", err_r)
        client:close()
        return
      end
      if not data then
        -- EOF: client menutup koneksi
        client:close()
        print("Client disconnected (EOF)")
        return
      end

      -- proses (contoh: echo ulang)
      local err_w = async.write(client, data)
      if err_w then
        print("write error:", err_w)
        client:close()
        return
      end
    end
  end)
end)

print(("Echo server berjalan di %s:%d"):format(HOST, PORT))
luv.run()
```

---

### Penjelasan lengkap `async_echo.lua` — baris demi baris

#### require & konfigurasi

```lua
local luv = require("luv")
local async = require("luv_async")
local HOST = "0.0.0.0"
local PORT = 7000
```

* `luv` untuk operasi I/O, `async` modul helper yang dibuat tadi.
* Konfigurasi host/port.

#### membuat server & listen

```lua
local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, function(err)
  if err then
    print("listen error:", err)
    return
  end
  -- accept client handle
  local client = luv.new_tcp()
  server:accept(client)
  ...
end)
```

* `new_tcp()`, `bind()` dan `listen(backlog, on_connection)` membuat server TCP. `listen` menerima callback `on_connection` yang dipanggil oleh libuv ketika ada koneksi.
* Di dalam callback kita buat `client = luv.new_tcp()` lalu `server:accept(client)` untuk menerima koneksi ke handle baru.

#### spawn coroutine handler

```lua
async.go(function()
  print("Client terhubung")
  while true do
    local err_r, data = async.read_once(client)
    if err_r then
      print("read error:", err_r)
      client:close()
      return
    end
    if not data then
      client:close()
      print("Client disconnected (EOF)")
      return
    end

    local err_w = async.write(client, data)
    if err_w then
      print("write error:", err_w)
      client:close()
      return
    end
  end
end)
```

* `async.go` menjalankan handler sebagai coroutine (fire-and-forget). Handler memakai `async.read_once` & `async.write` yang internally `await` sehingga terlihat seperti operasi sinkron:

  * `async.read_once(client)` menunggu satu chunk masuk; mengembalikan `err, data`.
  * Jika `err` ada → kemungkinan error (misal reset), kita tutup `client`.
  * Jika `data == nil` → EOF, client menutup koneksi.
  * `async.write(client, data)` menulis kembali data dan menunggu pengiriman selesai.

**Keuntungan gaya ini**:

* Kode handler linear, mudah dibaca — tidak perlu menulis callback bertingkat.
* Masih sepenuhnya non-blocking karena `await` hanya `yield` coroutine; event loop `luv` tetap berjalan dan melayani koneksi lainnya.

#### start loop

```lua
print(("Echo server berjalan di %s:%d"):format(HOST, PORT))
luv.run()
```

* Mulai event loop. `luv.run()` akan berjalan terus sampai tidak ada lagi handle aktif.

---

## C. Cara menjalankan & testing

1. Pastikan `luv` terinstal:

   ```bash
   luarocks install luv
   ```

   Atau gunakan paket distro.

2. Letakkan dua file di working directory:

   * `luv_async.lua` (module)
   * `async_echo.lua` (server)

3. Jalankan server:

   ```bash
   luajit async_echo.lua 7000
   ```

4. Tes dari terminal lain:

   ```bash
   # gunakan netcat
   nc 127.0.0.1 7000
   Hello server
   # Anda harus menerima kembali "Hello server"
   ```

5. Uji concurrency: buka beberapa `nc` client sekaligus — setiap client ditangani oleh coroutine terpisah tanpa blocking.

---

## D. Praktik terbaik, jebakan & catatan

* **Jangan `await` di luar coroutine**: `await` memanggil `coroutine.yield()` — memanggilnya di luar coroutine menghasilkan error.
* **Guard double-resume**: `once_cb` mencegah callback mem-resume coroutine berkali-kali. Ini penting karena beberapa API bisa memanggil callback berkali-kali (mis. beberapa event). Anda harus menyesuaikan apakah ingin queue atau hanya ambil event pertama.
* **Tutup handle & release resource**: selalu panggil `stop`/`close` pada timer/handles; jika tidak, `luv.run()` mungkin tidak exit dan resource bocor.
* **Error handling**: `M.go` men-catch error saat pertama resume dan print trace; namun error yang terjadi setelah `yield` (mis. saat coroutine di-resume dari callback) juga ditangkap di `once_cb` — trace dicetak agar halus. Anda bisa mengganti `print` dengan logger atau mekanisme pembuangan task.
* **Performa**: pola ini bagus untuk logika per-connection yang sederhana. Namun jika Anda `await` berjuta-juta kali sangat sering, overhead coroutine+resume bisa jadi nyata — profiling diperlukan.
* **Integrasi dengan existing callback code**: `await` mengharuskan register memulai operasi. Jika API `luv` hanya memberi event via `listen(on_connection)`, Anda masih bisa membungkus `accept`+`read_start` di handler `listen` dan `go` spawn coroutine seperti contoh kita — kombinasi ini pragmatis.

---

## E. Referensi singkat

* luv (libuv binding): dokumentasi function seperti `new_tcp`, `read_start`, `write`, `new_timer`. (paket luarrocks `luv`)
* coroutine docs (Lua manual): `coroutine.create`, `coroutine.resume`, `coroutine.yield`, `coroutine.running`.

---

<!--
### Status — A selesai
Saya telah membuat modul helper `luv_async.lua`, contoh server `async_echo.lua`, dan membedah setiap bagian kode secara mendalam sesuai permintaan Anda.

Apakah saya harus **lanjut ke B** sekarang (Modul 17: *testing & CI untuk proyek Lua*, lengkap dengan contoh test unit, runner, dan pipeline CI sederhana), atau Anda mau saya periksa / jalankan hal-hal kecil di A dulu? Jika siap, saya akan langsung lanjut ke **B**.
-->

> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-15/README.md
[selanjutnya]: ../bagian-17/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
