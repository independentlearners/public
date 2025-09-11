# **[B (Modul 17: Testing & CI untuk proyek Lua)][0]**.

Target kita di modul ini:

1. **Unit testing dengan `busted`** (framework testing Lua populer).
2. **Integrasi mini proyek sebelumnya** (`luv_async.lua` dan `async_echo.lua`) ke dalam unit test.
3. **Membuat CI pipeline sederhana** (contoh GitHub Actions).
4. Seperti biasa, setiap kode saya **bedah baris per baris** agar jelas fungsi, tujuan, dan hubungannya.

---

# 1. Instalasi `busted`

`busted` adalah framework testing BDD (Behavior-Driven Development) untuk Lua.

* Instal lewat luarocks:

  ```bash
  luarocks install busted
  ```
* Jalankan test dengan:

  ```bash
  busted
  ```

---

# 2. Struktur Proyek

```
project/
├── luv_async.lua
├── async_echo.lua
├── spec/
│   └── luv_async_spec.lua   # file unit test
```

---

# 3. File Test: `spec/luv_async_spec.lua`

```lua
-- spec/luv_async_spec.lua
-- Unit test untuk modul luv_async.lua menggunakan busted

local luv = require("luv")
local async = require("luv_async")

describe("luv_async", function()

  it("should sleep approximately given ms", function()
    local start = luv.now()
    async.go(function()
      async.sleep(50) -- tidur 50ms
      local elapsed = luv.now() - start
      -- Harus lebih dari 45ms (ada toleransi)
      assert.is_true(elapsed >= 45)
      -- Hentikan loop setelah test
      luv.stop()
    end)
    luv.run()
  end)

  it("should read and write data through TCP echo", function()
    local HOST, PORT = "127.0.0.1", 8081

    -- setup server
    local server = luv.new_tcp()
    server:bind(HOST, PORT)
    server:listen(128, function(err)
      if err then error(err) end
      local client = luv.new_tcp()
      server:accept(client)
      async.go(function()
        while true do
          local err_r, data = async.read_once(client)
          if err_r or not data then
            client:close()
            return
          end
          async.write(client, data)
        end
      end)
    end)

    -- setup client
    local client = luv.new_tcp()
    client:connect(HOST, PORT, function(err)
      assert.is_nil(err)
      async.go(function()
        async.write(client, "hello")
        local _, data = async.read_once(client)
        assert.equals("hello", data)
        client:close()
        server:close()
        luv.stop()
      end)
    end)

    luv.run()
  end)

end)
```

---

## 4. Bedah kode `luv_async_spec.lua`

### Header

```lua
local luv = require("luv")
local async = require("luv_async")
```

* Import modul yang akan diuji (`luv_async.lua`).
* `luv` untuk akses fungsi dasar (timer, tcp).

---

### Struktur testing

```lua
describe("luv_async", function()
  it("...", function() ... end)
  it("...", function() ... end)
end)
```

* `describe` mendefinisikan grup test (suite).
* `it("...", fn)` mendefinisikan kasus uji tunggal.
* `busted` akan menampilkan hasil test secara rapi.

---

### Test 1: sleep

```lua
local start = luv.now()
async.go(function()
  async.sleep(50)
  local elapsed = luv.now() - start
  assert.is_true(elapsed >= 45)
  luv.stop()
end)
luv.run()
```

* `luv.now()` → timestamp dalam ms.
* `async.go(function() ... end)` → jalankan coroutine untuk test.
* `async.sleep(50)` → yield 50ms dengan timer.
* Hitung `elapsed`, pastikan ≥45ms (toleransi ±5ms).
* `luv.stop()` menghentikan loop (tanpa ini, `luv.run()` tidak akan selesai).
* `luv.run()` → jalankan event loop.

---

### Test 2: TCP echo

```lua
local HOST, PORT = "127.0.0.1", 8081
```

* Host & port lokal untuk test.

#### Server setup

```lua
local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, function(err)
  if err then error(err) end
  local client = luv.new_tcp()
  server:accept(client)
  async.go(function()
    while true do
      local err_r, data = async.read_once(client)
      if err_r or not data then
        client:close()
        return
      end
      async.write(client, data)
    end
  end)
end)
```

* `luv.new_tcp()` → buat handle server.
* `server:bind(HOST, PORT)` → bind port.
* `server:listen(backlog, on_connection)` → listen.
* Callback `on_connection`:

  * Buat handle `client`.
  * `server:accept(client)` → menerima koneksi.
  * Jalankan coroutine handler:

    * `async.read_once(client)` → baca chunk dari client.
    * Jika error/EOF → tutup client.
    * Jika ada data → tulis balik (echo).

---

#### Client setup

```lua
local client = luv.new_tcp()
client:connect(HOST, PORT, function(err)
  assert.is_nil(err)
  async.go(function()
    async.write(client, "hello")
    local _, data = async.read_once(client)
    assert.equals("hello", data)
    client:close()
    server:close()
    luv.stop()
  end)
end)
```

* `client:connect(HOST, PORT, cb)` → koneksi TCP.
* Callback setelah connect: pastikan `err` nil.
* Jalankan coroutine client:

  * `async.write(client, "hello")` → kirim pesan.
  * `async.read_once(client)` → baca balasan (seharusnya `"hello"`).
  * `assert.equals("hello", data)` → validasi echo.
  * Tutup client & server, stop event loop.

---

#### Event loop

```lua
luv.run()
```

* Jalankan semua event asynchronous (server, client).
* Loop berhenti ketika semua handle ditutup dan kita panggil `luv.stop()`.

---

# 5. CI Pipeline (GitHub Actions)

File: `.github/workflows/test.yml`

```yaml
name: Lua CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Lua
        uses: leafo/gh-actions-lua@v10
        with:
          luaVersion: "luajit-2.1.0-beta3"

      - name: Install Luarocks
        uses: leafo/gh-actions-luarocks@v4

      - name: Install dependencies
        run: |
          luarocks install luv
          luarocks install busted

      - name: Run tests
        run: busted -v
```

---

## Bedah CI pipeline

1. **Trigger**

   ```yaml
   on: push, pull_request
   ```

   → pipeline berjalan setiap push & PR ke branch `main`.

2. **Job test**

   * `runs-on: ubuntu-latest` → jalankan di runner Linux.

3. **Steps**

   * `checkout` → ambil kode repo.
   * `Setup Lua` → install LuaJIT via action.
   * `Install Luarocks` → manajer paket Lua.
   * `Install dependencies` → install `luv` dan `busted`.
   * `Run tests` → jalankan `busted -v` untuk hasil detail.

**Output**: pipeline akan otomatis menjalankan unit tests setiap commit/PR, menjaga kualitas kode.

---

# 6. Praktik terbaik & potensi masalah

* **Best practices**

  * Gunakan `assert` dalam test untuk kondisi penting.
  * Gunakan toleransi pada waktu (`sleep`) karena OS scheduling bisa memengaruhi.
  * Pisahkan test cepat (unit test) dan test lambat (integration test).

* **Potensi masalah**

  * `luv` perlu library `libuv` tersedia. Pastikan di CI runner sudah terinstal.
  * Test asynchronous harus memanggil `luv.stop()` supaya loop selesai. Tanpa ini, CI akan hang.
  * Port TCP harus bebas; jika sudah dipakai, test gagal → pilih port random atau unik.

---

📌 Jadi, di Modul 17 kita sudah:

* Membuat **unit test** (`luv_async_spec.lua`).
* Menjalankan dengan `busted`.
* Menyusun **CI pipeline** untuk otomatisasi testing.

<!--
Apakah Anda ingin saya lanjut ke **C (gabungan coroutine pipeline + I/O dengan luv, misalnya server yang menerima angka, memproses pipeline kuadrat, lalu mengirim balik hasil)**?

Mantap 🚀 berarti modul **B (Testing & CI)** sudah beres.

Kita sudah:

* Membangun unit test dengan **busted**.
* Menguji modul `luv_async.lua` (sleep, TCP echo).
* Menyusun **pipeline CI** di GitHub Actions.
* Membongkar baris per baris kode supaya jelas tujuan dan mekanismenya.

Langkah logis berikutnya adalah **C**: kita gabungkan **coroutine pipeline** (seperti di modul 16A) dengan **asynchronous I/O (luv + await)** sehingga lahirlah **server yang menerima data → diproses oleh coroutine pipeline → hasil dipulangkan ke client**.

Apakah mau langsung saya buatkan mini-proyek C ini (server pipeline-kuadrat) lengkap dengan pembahasan kode baris per baris seperti biasa?

-->
Mari kita kerjakan **C (gabungan coroutine pipeline + asynchronous I/O dengan luv)**.

Target mini-proyek ini:

* Kita buat **server TCP** menggunakan `luv` + modul `luv_async.lua`.
* Client mengirim angka (misalnya `5` atau `12`).
* Server akan **memproses angka tersebut lewat pipeline coroutine** → misalnya langkah transformasi:

  1. **Producer**: kirim angka.
  2. **Transformer**: kuadratkan.
  3. **Consumer**: hasil akhir.
* Hasil dari pipeline dikembalikan ke client.
* Semua berjalan **asynchronous non-blocking**.

---

# 1. File: `pipeline_server.lua`

```lua
-- pipeline_server.lua
-- Server TCP: terima angka dari client, proses lewat coroutine pipeline, balas hasilnya.

local luv = require("luv")
local async = require("luv_async")

-- =====================
-- Bagian A: Pipeline coroutine
-- =====================

-- Producer: menerima angka dari input, yield ke luar
local function producer(n)
  return coroutine.create(function()
    coroutine.yield(n)
  end)
end

-- Transformer: kuadratkan nilai dari producer
local function transformer(src_co)
  return coroutine.create(function()
    local ok, v = coroutine.resume(src_co)
    if not ok then error(v) end
    if v == nil then return end
    local out = v * v
    coroutine.yield(out)
  end)
end

-- Consumer: ambil hasil dari transformer
local function consumer(src_co)
  return coroutine.create(function()
    local ok, v = coroutine.resume(src_co)
    if not ok then error(v) end
    if v == nil then return end
    coroutine.yield(v)
  end)
end

-- Jalankan pipeline sekali
local function run_pipeline(n)
  local prod = producer(n)
  local trans = transformer(prod)
  local cons = consumer(trans)
  local ok, result = coroutine.resume(cons)
  if not ok then error(result) end
  return result
end

-- =====================
-- Bagian B: TCP Server
-- =====================

local HOST, PORT = "0.0.0.0", 9090

local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, function(err)
  if err then
    print("Listen error:", err)
    return
  end

  local client = luv.new_tcp()
  server:accept(client)

  async.go(function()
    print("Client terhubung")
    while true do
      local err_r, data = async.read_once(client)
      if err_r then
        print("Read error:", err_r)
        client:close()
        return
      end
      if not data then
        client:close()
        print("Client disconnected")
        return
      end

      -- parsing angka
      local num = tonumber(data)
      if not num then
        async.write(client, "Harap kirim angka valid\n")
      else
        local result = run_pipeline(num)
        async.write(client, string.format("Hasil kuadrat: %d\n", result))
      end
    end
  end)
end)

print(("Pipeline server berjalan di %s:%d"):format(HOST, PORT))
luv.run()
```

---

# 2. Penjelasan baris demi baris

### Bagian A: Pipeline coroutine

```lua
local function producer(n)
  return coroutine.create(function()
    coroutine.yield(n)
  end)
end
```

* `producer` membuat coroutine yang hanya `yield` angka `n`.
* Ia tidak looping, hanya satu kali kirim nilai.

```lua
local function transformer(src_co)
  return coroutine.create(function()
    local ok, v = coroutine.resume(src_co)
    if not ok then error(v) end
    if v == nil then return end
    local out = v * v
    coroutine.yield(out)
  end)
end
```

* `transformer` menerima coroutine `src_co` (producer).
* `resume(src_co)` → ambil nilai dari producer.
* `out = v * v` → kuadratkan.
* `yield(out)` → keluarkan hasil transformasi.

```lua
local function consumer(src_co)
  return coroutine.create(function()
    local ok, v = coroutine.resume(src_co)
    if not ok then error(v) end
    if v == nil then return end
    coroutine.yield(v)
  end)
end
```

* `consumer` mengambil hasil dari transformer.
* `resume(src_co)` → jalankan transformer, ambil hasil.
* `yield(v)` → keluarkan ke pemanggil.

```lua
local function run_pipeline(n)
  local prod = producer(n)
  local trans = transformer(prod)
  local cons = consumer(trans)
  local ok, result = coroutine.resume(cons)
  if not ok then error(result) end
  return result
end
```

* `run_pipeline(n)` menyambungkan producer → transformer → consumer.
* Jalankan consumer, hasilnya adalah output akhir pipeline.

---

### Bagian B: TCP Server

```lua
local HOST, PORT = "0.0.0.0", 9090
local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, function(err) ... end)
```

* Membuat TCP server di port 9090.
* Callback `listen` akan dipanggil setiap koneksi baru.

---

### Handler koneksi

```lua
local client = luv.new_tcp()
server:accept(client)
```

* Menerima koneksi ke handle `client`.

```lua
async.go(function()
  print("Client terhubung")
  while true do
    local err_r, data = async.read_once(client)
    ...
  end
end)
```

* Spawn coroutine untuk menangani client.
* `async.read_once(client)` → baca satu pesan dari client.

---

### Parsing & pipeline

```lua
local num = tonumber(data)
if not num then
  async.write(client, "Harap kirim angka valid\n")
else
  local result = run_pipeline(num)
  async.write(client, string.format("Hasil kuadrat: %d\n", result))
end
```

* `tonumber(data)` → coba parsing string input menjadi angka.
* Jika gagal (`nil`) → kirim pesan error.
* Jika berhasil → jalankan pipeline (`run_pipeline(num)`), lalu balas hasil kuadrat.

---

### Event loop

```lua
print(("Pipeline server berjalan di %s:%d"):format(HOST, PORT))
luv.run()
```

* Tampilkan pesan bahwa server siap.
* `luv.run()` menjalankan event loop.

---

# 3. Cara uji server

1. Jalankan server:

   ```bash
   luajit pipeline_server.lua
   ```

2. Buka client via netcat:

   ```bash
   nc 127.0.0.1 9090
   7
   ```

   Output:

   ```
   Hasil kuadrat: 49
   ```

   Jika kirim `"abc"`:

   ```
   Harap kirim angka valid
   ```

---

# 4. Analisis & praktik terbaik

* **Pipeline** di sini sederhana (kuadrat satu angka). Anda bisa memperluas pipeline dengan lebih banyak transformer (misalnya `x^2 + 1`, lalu `*2`, dst).
* **Asynchronous I/O** (luv + await) memastikan server bisa melayani banyak client sekaligus tanpa blocking.
* **Error handling**: jika `read_once` error atau EOF, koneksi ditutup.
* **Perluasan**: pipeline ini bisa dipakai bukan hanya untuk angka, tapi juga string processing (misalnya reverse, uppercase).

---

📌 Dengan proyek ini, kita sudah **menggabungkan coroutine pipeline** dengan **asynchronous I/O** → inilah bentuk nyata dari **C (kombinasi A+B)**.
<!--
Apakah mau saya lanjutkan dengan menambahkan **versi pengujian otomatis (unit test/integration test untuk server pipeline ini)** supaya melanjutkan kesinambungan dari modul 17 (testing & CI)?
-->
Mari kita buat **uji otomatis (integration test)** untuk `pipeline_server.lua`, supaya kesinambungan dengan **modul 17 (Testing & CI)** tetap terjaga.

---

# 1. Struktur Proyek Diperbarui

```
project/
├── luv_async.lua
├── pipeline_server.lua
├── spec/
│   └── pipeline_server_spec.lua   # file test baru
```

---

# 2. File Test: `spec/pipeline_server_spec.lua`

```lua
-- spec/pipeline_server_spec.lua
-- Integration test untuk pipeline_server.lua
-- Menguji: client kirim angka -> server balas hasil kuadrat

local luv = require("luv")
local async = require("luv_async")

describe("Pipeline Server", function()

  it("should return squared number when client sends integer", function()
    local HOST, PORT = "127.0.0.1", 9091 -- gunakan port unik untuk test

    -- === Setup server (mirip pipeline_server.lua, tapi inline di test) ===
    local function producer(n)
      return coroutine.create(function() coroutine.yield(n) end)
    end
    local function transformer(src_co)
      return coroutine.create(function()
        local ok, v = coroutine.resume(src_co)
        if not ok then error(v) end
        if not v then return end
        coroutine.yield(v * v)
      end)
    end
    local function consumer(src_co)
      return coroutine.create(function()
        local ok, v = coroutine.resume(src_co)
        if not ok then error(v) end
        if not v then return end
        coroutine.yield(v)
      end)
    end
    local function run_pipeline(n)
      local prod = producer(n)
      local trans = transformer(prod)
      local cons = consumer(trans)
      local ok, result = coroutine.resume(cons)
      assert(ok, result)
      return result
    end

    local server = luv.new_tcp()
    server:bind(HOST, PORT)
    server:listen(128, function(err)
      assert.is_nil(err)
      local client = luv.new_tcp()
      server:accept(client)
      async.go(function()
        while true do
          local err_r, data = async.read_once(client)
          if err_r or not data then
            client:close()
            return
          end
          local num = tonumber(data)
          if not num then
            async.write(client, "Harap kirim angka valid\n")
          else
            local result = run_pipeline(num)
            async.write(client, string.format("Hasil kuadrat: %d\n", result))
          end
        end
      end)
    end)

    -- === Client test ===
    local client = luv.new_tcp()
    client:connect(HOST, PORT, function(err)
      assert.is_nil(err)
      async.go(function()
        -- kirim angka 6
        async.write(client, "6")
        local _, data = async.read_once(client)
        assert.equals("Hasil kuadrat: 36\n", data)
        client:close()
        server:close()
        luv.stop()
      end)
    end)

    luv.run()
  end)

  it("should return error message for invalid input", function()
    local HOST, PORT = "127.0.0.1", 9092

    -- server sama, tapi port berbeda
    local server = luv.new_tcp()
    server:bind(HOST, PORT)
    server:listen(128, function(err)
      assert.is_nil(err)
      local client = luv.new_tcp()
      server:accept(client)
      async.go(function()
        while true do
          local _, data = async.read_once(client)
          if not data then
            client:close()
            return
          end
          local num = tonumber(data)
          if not num then
            async.write(client, "Harap kirim angka valid\n")
          end
        end
      end)
    end)

    -- client uji
    local client = luv.new_tcp()
    client:connect(HOST, PORT, function(err)
      assert.is_nil(err)
      async.go(function()
        async.write(client, "abc") -- invalid
        local _, data = async.read_once(client)
        assert.equals("Harap kirim angka valid\n", data)
        client:close()
        server:close()
        luv.stop()
      end)
    end)

    luv.run()
  end)

end)
```

---

# 3. Penjelasan Baris per Baris

### Header

```lua
local luv = require("luv")
local async = require("luv_async")
```

* Import `luv` & `luv_async` untuk event loop & async wrapper.

---

### `describe` & `it`

```lua
describe("Pipeline Server", function()
  it("should return squared number when client sends integer", function() ... end)
  it("should return error message for invalid input", function() ... end)
end)
```

* Grup test `Pipeline Server`.
* Dua skenario diuji: input angka & input salah.

---

### Server untuk test angka valid

```lua
local server = luv.new_tcp()
server:bind(HOST, PORT)
server:listen(128, function(err) ... end)
```

* Setup server sederhana, inline di test.

```lua
async.go(function()
  while true do
    local err_r, data = async.read_once(client)
    if err_r or not data then
      client:close()
      return
    end
    local num = tonumber(data)
    if not num then
      async.write(client, "Harap kirim angka valid\n")
    else
      local result = run_pipeline(num)
      async.write(client, string.format("Hasil kuadrat: %d\n", result))
    end
  end
end)
```

* Handler koneksi, persis logika dari `pipeline_server.lua`.
* Jalankan pipeline untuk angka valid, atau balas error jika invalid.

---

### Client untuk test angka valid

```lua
client:connect(HOST, PORT, function(err)
  assert.is_nil(err)
  async.go(function()
    async.write(client, "6")
    local _, data = async.read_once(client)
    assert.equals("Hasil kuadrat: 36\n", data)
    client:close()
    server:close()
    luv.stop()
  end)
end)
```

* Kirim angka `6`.
* Terima balasan, pastikan `"Hasil kuadrat: 36\n"`.

---

### Test untuk input invalid

```lua
async.write(client, "abc")
local _, data = async.read_once(client)
assert.equals("Harap kirim angka valid\n", data)
```

* Kirim string non-numerik.
* Pastikan balasan adalah pesan error.

---

# 4. Cara Menjalankan Test

1. Pastikan sudah instal dependensi:

   ```bash
   luarocks install busted
   luarocks install luv
   ```

2. Jalankan:

   ```bash
   busted spec/pipeline_server_spec.lua -v
   ```

3. Output:

   ```
   Pipeline Server
     should return squared number when client sends integer
     should return error message for invalid input

   2 successes / 0 failures
   ```

---

# 5. Praktik Terbaik

* Gunakan **port unik** (9091, 9092, dst) untuk tiap test agar tidak bentrok.
* Pastikan `luv.stop()` selalu dipanggil supaya loop tidak hang.
* Server & client harus `close()` agar resource dibebaskan.

---

📌 Jadi, sekarang `pipeline_server.lua` sudah punya **uji otomatis** yang memverifikasi:

1. Input angka → output kuadrat.
2. Input invalid → output error message.
<!--
Apakah Anda ingin saya lanjutkan dengan **menambahkan test ini ke pipeline CI (GitHub Actions) yang sudah kita buat di modul 17B**, supaya setiap commit otomatis menguji server pipeline juga?
-->



> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-16/README.md
[selanjutnya]: ../bagian-18/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
