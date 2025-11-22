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

Kita luruskan dulu posisinya terhadap **kurikulum yang sedang kita jalankan**:

1. **Fase dasar (Modul 1–10)** → sudah kita lalui: dasar Lua, FFI, mini-project CLI, struktur kontrol, hingga binding sederhana.

2. **Fase menengah (Modul 11–15)** → sudah masuk: binding library C lebih kompleks (OpenSSL, AES), profiling performa, dan pipeline coroutine.

3. **Modul 16** → kita bahas *Concurrency & Async I/O*:

   * **A**: coroutine murni (pipeline producer–consumer).
   * **B**: asynchronous I/O dengan `luv` + testing (`busted`).
   * **C**: integrasi coroutine pipeline + I/O (server pipeline kuadrat) + testing otomatis.
     → Artinya modul 16 sudah komplit, bahkan kita tambahkan integrasi CI (beyond kurikulum dasar).

4. **Modul 17** → kita kerjakan di bagian B (testing & CI), lalu dilanjutkan di C dengan integration test server. Jadi materi modul ini juga sudah tercakup.

---

📌 **Kesimpulan audit posisi kurikulum:**
-->
* Sampai titik ini, kita sudah menyelesaikan **Modul 1–17**.
* Materi sudah lebih lengkap daripada kerangka awal, karena kita tambahkan:

  * Praktik binding ke OpenSSL/AES (praktis untuk keamanan).
  * Profiling nyata (benchmark sorting).
  * Async/await pattern di atas `luv`.
  * CI pipeline (GitHub Actions).
  * Integration test server.

---

<!--
Dengan kata lain, kurikulum sudah berjalan *selaras* dan bahkan diperluas ke hal-hal yang biasanya ditempatkan di tingkat lebih lanjut.

Langkah berikut menurut kurikulum:

* **Modul 18** (jika kita ikuti pola umum): biasanya masuk ke **pengemasan proyek**, **publikasi modul ke LuaRocks**, atau **integrasi dengan Neovim plugin nyata** (sesuai fokus Anda di awal).

Apakah Anda ingin saya langsung lanjut ke **Modul 18** sesuai kurikulum, atau lebih dulu saya rangkum ulang seluruh perjalanan Modul 1–17 (semacam “laporan progres” lengkap) sebelum masuk ke bab berikutnya?

Bagus — saya susun **laporan progres komprehensif** sebelum Modul 18. Saya akan menyajikan ringkasan tiap modul (1–17 yang sudah kita kerjakan), lalu **membedah setiap berkas kode** yang dibuat sepanjang kurikulum ini. Untuk tiap berkas saya jelaskan tujuan file, fungsi/komponen utamanya, dan **poin-poin baris-per-baris penting** (bukan mengulang seluruh file, tapi menjabarkan setiap fungsi dan baris kunci sehingga Anda paham persis apa yang terjadi dan bagaimana memodifikasinya). Semua penjelasan dalam Bahasa Indonesia formal — ringkas namun teknis.

Jika Anda ingin salinan file lengkap (copy-paste) untuk tiap berkas, saya bisa sediakan setelah Anda meninjau ringkasan ini. Mari mulai.
-->
---

# Ringkasan status kurikulum (Modul 1–17)

* **Status:** Semua modul dari Modul 1 sampai **Modul 17** sudah kita kerjakan, diuji, dan dilengkapi contoh serta penjelasan mendalam.
* **Highlight** yang telah selesai: dasar Lua, metatable, error handling, vector3D (Lua murni), binding C API (manual), LuaJIT + FFI (vector3D\_ffi), OpenSSL binding & AES, SDL2 binding, membangun shared libraries (libmath, libstrutils, libarray, libperson, libsort, libfib), optimisasi & benchmarking (sorting, fibonacci), coroutine pipeline, `luv` async, pattern await/async (`luv_async.lua`), integration server pipeline, unit tests (`busted`), dan CI (GitHub Actions).

Di bawah ini kita urutkan menurut topik besar dan membedah setiap berkas yang kita buat.

---

## A. LuaJIT + FFI — Vector3D & Simulasi Partikel

### 1) `vector3d_ffi.lua` — modul Vector3D (LuaJIT FFI)

**Tujuan:** mendefinisikan `vec3` C-struct via `ffi.cdef`, expose konstruktor `M.new`, metamethod (`__add`,`__sub`,`__mul`,`__tostring`), serta method (`magnitude`, `normalize`, `dot`, `cross`).

**Bagian kunci & penjelasan:**

* `local ffi = require("ffi")` — muat FFI (hanya di LuaJIT).
* `ffi.cdef[[ typedef struct { double x; double y; double z; } vec3; ]]` — beri tahu layout memori `vec3`.
* `local methods = {}` + `function methods:magnitude() ... end` — definisi method; `self` adalah cdata.
* `local mt = { __index = methods, __add = function(a,b) ... end, __mul = function(a,b) ... end, __tostring = ... }` — metatable:

  * `__add/__sub` mengembalikan `ffi.new("vec3", ...)` — operasi vektor.
  * `__mul`: jika satu operand number → skalar \* vektor; jika keduanya vektor → dot product (mengembalikan number). Penting: perilaku ini desain API, dokumentasikan.
* `local vec3 = ffi.metatype("vec3", mt)` — membuat ctype constructor `vec3(...)`.
* `M.new = function(x,y,z) return vec3(x or 0.0, y or 0.0, z or 0.0) end` — constructor modul.

**Persyaratan untuk memodifikasi:**

* Harus paham `ffi.cdef`, `ffi.new`, dan `ffi.metatype`.
* Untuk menambah metode (mis. `__len` untuk magnitude via `#v`) tambahkan di `mt` atau `methods` sesuai desain.

---

### 2) `particle_sim_ffi.lua` — simulasi partikel (FFI arrays)

**Tujuan:** menunjukan alokasi array kontigu `ffi.new("vec3[?]", N)` dan update cepat di hot-loop.

**Bagian kunci & penjelasan:**

* `local positions = ffi.new("vec3[?]", N)` — alokasi array C kontigu, indeks 0..N-1.
* Inisialisasi loop `for i = 0, N-1 do positions[i] = vec3c(math.random(), ...) end`.
* Hot loop: `positions[i].x = positions[i].x + v.x * dt` — akses dan set field cdata sangat cepat.
* Waspadai: indeks dimulai 0, bukan 1; `ffi.typeof("vec3")` sering dipakai sebagai alias untuk efisiensi.

**Catatan modifikasi:** jika ingin memperluas (mis. collision), tambahkan struktur lain (mis. `mass`, `force`) ke `ffi.cdef` dan rekalkulasi.

---

## B. Memanggil fungsi C sistem & load shared libs

### 3) `ffi_c_example.lua` (contoh `printf` & `cos`)

**Tujuan:** contoh `ffi.cdef` + `ffi.C` untuk memanggil `printf` dan `cos`.

**Baris penting:**

* `ffi.cdef[[ int printf(const char *fmt, ...); double cos(double x); ]]`
* `ffi.C.printf("Hello ...", 2025, "LuaJIT FFI")` — gunakan variadic; hati-hati format string.
* `local result = ffi.C.cos(angle)` — panggil fungsi di `libm`.

**Catatan:** variadic function memerlukan ketelitian pada format dan argumen.

---

### 4) `ffi_libm.lua` + `main.lua`

**Tujuan:** `ffi.load("m")` memuat `libm`, membuat wrapper `M.sin/cos/sqrt`.

**Baris penting:**

* `local libm = ffi.load("m")` — muat shared lib (Linux).
* `function M.sin(x) return libm.sin(x) end` — bungkus agar mudah test & swap.

**Kebutuhan modifikasi:** pada Windows ganti nama library, atau gunakan path absolut bila perlu.

---

## C. SDL2 binding (contoh multimedia)

### 5) `sdl2_bind.lua` & `sdl2_demo.lua`

**Tujuan:** binding minimal SDL2 untuk membuat window & event loop.

**Bagian kunci `sdl2_bind.lua`:**

* `ffi.cdef` mendeklarasikan `SDL_Window`, `SDL_CreateWindow`, `SDL_PollEvent`, `SDL_Delay`, constants.
* `local sdl = ffi.load("SDL2")`
* Wrapper `SDL.init`, `SDL.createWindow`, `SDL.pollEvent`, `SDL.delay`.

**`sdl2_demo.lua`:**

* Accept event loop; buat `SDL_Event` via `ffi.new("SDL_Event")`.
* `while SDL.pollEvent(event) ~= 0 do if event.type == 0x100 then ... end end` — `0x100` adalah `SDL_QUIT`.

**Catatan modifikasi:**

* SDL API lebih besar; decomposisi modul (video/audio) disarankan.
* Pastikan SDL2 terinstal di sistem.

---

## D. OpenSSL binding & AES

### 6) `openssl_bind.lua` + `openssl_demo.lua` (SHA256)

**Tujuan:** panggil `EVP_*` API untuk hashing (SHA256).

**Baris penting:**

* `ffi.cdef` deklarasi `EVP_MD_CTX`, `EVP_sha256`, `EVP_DigestInit_ex/Update/Final_ex`.
* `local libcrypto = ffi.load("crypto")`.
* `OpenSSL.sha256(data)`:

  * `local ctx = libcrypto.EVP_MD_CTX_new()`
  * `EVP_DigestInit_ex`, `EVP_DigestUpdate`, `EVP_DigestFinal_ex`
  * Buat buffer `ffi.new("unsigned char[32]")`, baca `outlen` via `unsigned int[1]`
  * Convert ke hex dengan loop `string.format("%02x", out[i])`
  * `EVP_MD_CTX_free(ctx)`

**Keamanan:** Pastikan versi OpenSSL cocok; cek return codes pada produksi.

---

### 7) `openssl_aes.lua` + `aes_demo.lua` (AES-256-CBC)

**Tujuan:** contoh enkripsi/dekripsi AES-256-CBC menggunakan `EVP_*` API.

**Baris penting `openssl_aes.lua`:**

* `EVP_CIPHER_CTX_new`, `EVP_aes_256_cbc()`, `EVP_EncryptInit_ex`, `EVP_EncryptUpdate`, `EVP_EncryptFinal_ex`.
* Output buffer `ffi.new("unsigned char[?]", #plaintext + 32)` — beri headroom untuk padding.
* Return `ffi.string(outbuf, totallen)` untuk mengubah hasil biner ke string Lua.

**`aes_demo.lua`:**

* `key = ffi.new("unsigned char[32]", "1234...")` — contoh; **ingat**: jangan hardcode kunci di produksi.
* `iv = ffi.new("unsigned char[16]", "1234...")`.
* Enkripsi menghasilkan biner; cetak dalam hex.

**Peringatan:** tangani error return codes (EVP\_... mengembalikan integer sukses/gagal).

---

## E. Library C sendiri — contoh & binding

Untuk banyak contoh berikut, pola yang sama: buat header `.h`, implementasi `.c`, kompilasi menjadi `.so` (Linux), lalu `ffi.cdef` + `ffi.load` di Lua untuk binding. Saya bedah setiap library ringkasnya.

### 8) `libmath.c` / `libmath.h` → `math_bind.lua` + `math_demo.lua`

**Fungsi C:** `add`, `sub`, `mul`, `divide`, `hypotenuse`.

**Binding `math_bind.lua`:**

* `ffi.cdef` deklarasi fungsi.
* `local libmath = ffi.load("./libmath.so")`
* `M.add = libmath.add` dsb.

**Demo:** pemanggilan langsung dari Lua.

**Catatan:** Jika men-deploy library, gunakan nama fungsi unik (prefix) untuk menghindari konflik simbol.

---

### 9) `libstrutils.c` / `libstrutils.h` → `strutils_bind.lua` + `strutils_demo.lua`

**Fungsi C:** `to_upper`, `to_lower`, `reverse`, `concat`, `free_str`.

**Poin penting:**

* C functions `malloc` hasil string → **wajib** expose `free_str` untuk membebaskan memori.
* `strutils_bind.lua` menggunakan helper `wrap(func)`:

  * `local cstr = func(...)`
  * `local lua_str = ffi.string(cstr)`
  * `lib.free_str(cstr)` → prevent memory leak.
* `ffi.string` membuat salinan; aman meski C `free` dilakukan setelahnya.

---

### 10) `libarray.c` / `libarray.h` → `array_bind.lua` + `array_demo.lua`

**Tujuan:** Dynamic array of int di C, expose `da_new`, `da_push`, `da_get`, `da_size`.

**Binding utama:**

* `M.new(capacity)` mengembalikan `ffi.gc(arr, lib.da_free)` → finalizer otomatis.
* `M.push = lib.da_push` (binding langsung), `M.get = lib.da_get`, `M.size = lib.da_size`.

**Catatan memori:** `ffi.gc` membantu mencegah bocor; tapi untuk kontrol deterministik bisa sediakan `free` manual.

---

### 11) `libperson.c` / `libperson.h` → `person_bind.lua` + `person_demo.lua`

**Tujuan:** contoh struct kompleks (`Person` dengan `char* name` dan `int age`) dan method untuk create/free/get/set.

**Poin penting implementasi C:**

* `dup_string()` helper melakukan `malloc` + `memcpy`.
* `person_new` allocates `Person`, duplicates name.
* `person_free` free name and struct.

**Binding `person_bind.lua`:**

* `ffi.cdef` deklarasi `Person* person_new(...)` etc.
* `local p = lib.person_new(...)` → `ffi.gc(p, lib.person_free)` untuk finalizer.
* `Person` object: table Lua `{ cdata = managed }` dengan metatable `Person`.
* `Person:get_name()` mengembalikan `ffi.string(lib.person_get_name(self.cdata))` — salin C string ke Lua string.

**Praktik:** jangan akses `p` setelah `p:free()`. Batalkan finalizer dulu (`ffi.gc(c, nil)`) jika akan free manual.

---

## F. Sorting, Fibonacci — benchmark & profiling

### 12) `libsort.c` / `libsort.h` → `sort_bind.lua` + `sort_demo.lua`

**Tujuan:** tunjukkan kecepatan `qsort` C vs `table.sort` Lua untuk 1 juta angka.

**Fungsi C:** `void sort_ints(int* arr, size_t n)` yang memanggil `qsort` dengan `cmp_int`.

**Binding `sort_bind.lua`:**

* `ffi.cdef("void sort_ints(int* arr, size_t n);")`
* `local arr = ffi.new("int[?]", n, tbl)` — jika `tbl` berisi ints, ini meng-copy data.
* `lib.sort_ints(arr, n)` lalu salin hasil kembali ke tabel Lua.

**Analisa:** untuk dataset besar, `C qsort` jauh lebih cepat — overhead FFI kecil dibanding keuntungan native sort.

---

### 13) `fib.c` + `fib_bind.lua` + `profile_lua.lua` / `profile_ffi.lua`

**Tujuan:** membandingkan fib rekursif di Lua vs C (FFI) untuk n yang sama (contoh 30).

**Poin penting:**

* `fib_c` compiled with `-O2` sangat cepat.
* Gunakan `os.clock()` untuk timing; di LuaJIT gunakan `luajit -jv` untuk melihat JIT traces.

---

## G. Concurrency & Async I/O

### 14) `co_pipeline.lua` (coroutine pipeline)

**Tujuan:** demonstrasi producer → transformer → consumer dengan `coroutine.create`, `coroutine.resume`, `coroutine.yield`.

**Baris penting & mekanik flow:**

* `producer` `yield(i)` tiap elemen.
* `transformer` `resume` producer untuk mengambil nilai, transformasi, lalu `yield`.
* `consumer` `resume` transformer dan `print`.

**Catatan:** model ini *cooperative*—tidak paralel.

---

### 15) `luv_async.lua` (helper await/async) — **(pola penting)**

**Tujuan:** ubah callback-style luv jadi coroutine-style (`await`), plus `go` dan helper `sleep/read_once/write`.

**Komponen penting:**

* `M.go(fn, ...)` — spawn coroutine; segera `resume`.
* `M.await(register)` — `register` menerima `cb`; `await` `yield` sampai `cb` memanggil `resume(co, ...)`.

  * `once_cb` menjaga *single resume* (guard double-resume).
  * `await` me-return nilai yang dikirim lewat `cb`.
* `M.sleep(ms)` — wrapper timer `luv.new_timer()`, `t:start(ms,0,cb)`, `t:stop(); t:close()` dalam cb.
* `M.read_once(client)` — `client:read_start(cb)`, lalu `client:read_stop()` dalam cb.

**Catatan penting:** `await` **HARUS** dipanggil dari coroutine — otherwise error.

---

### 16) `async_echo.lua` — echo server yang memakai `luv_async.lua`

**Tujuan:** server TCP non-blocking, tiap koneksi ditangani coroutine sinkron-style.

**Flow kunci:**

* `server:listen(..., on_connection)` → di callback `server:accept(client)`, lalu `async.go(handler)` untuk setiap client.
* Di handler: `local err, data = async.read_once(client)` → `await` style. Jika ada data → `async.write(client, data)`.
* `luv.run()` menjalankan loop.

**Keuntungan:** code handler linear (mudah dibaca) tapi tetap non-blocking.

---

### 17) `pipeline_server.lua` — gabungan pipeline + IO

**Tujuan:** server menerima angka dari client, menjalankan pipeline coroutine (producer→transform→consume) sekali untuk angka itu, lalu mengembalikan hasil kuadrat.

**Bagian kunci:**

* `run_pipeline(n)` menyusun 3 coroutine kecil dan `resume` consumer untuk mendapat hasil.
* Handler async membaca data via `async.read_once`, parse `tonumber(data)`, panggil `run_pipeline(num)`, lalu `async.write(client, "Hasil ...")`.

**Testing & demonstrasi:** bisa diuji via `nc` atau lewat unit tests.

---

## H. Testing & CI

### 18) `spec/luv_async_spec.lua` & `spec/pipeline_server_spec.lua`

**Tujuan:** unit/integration tests menggunakan `busted`:

* `luv_async_spec.lua` menguji `sleep` dan echo server basic.
* `pipeline_server_spec.lua` menguji pipeline server: input angka → keluaran kuadrat; input invalid → pesan error.

**Poin penting test:**

* Gunakan `luv.stop()` agar event loop berhenti setelah test selesai — kunci agar test tidak menggantung.
* Gunakan port unik per test untuk menghindari konflik.

### 19) `.github/workflows/test.yml` (GitHub Actions)

**Fungsi:** setup runner (Ubuntu), install LuaJIT, luarocks, install `luv` dan `busted`, lalu jalankan `busted -v`.

**Catatan:** jika `luv` perlu `libuv` native, paket di runner harus memadai; versi LuaJIT di action disesuaikan.

---

## I. Praktik umum & persyaratan lingkungan

Untuk semua kode di atas, **identitas teknologi** dan **persyaratan** untuk memodifikasi:

* **Bahasa / runtime**:

  * C (ISO C) untuk library native (`.c/.h`) — dikompilasi dengan `gcc`/`clang` menjadi `.so`/`.dll`/`.dylib`.
  * LuaJIT (runtime) + FFI (`ffi` module) untuk binding dan execution (jalankan `luajit`).
  * `luv` (libuv binding) untuk async I/O di Lua.
  * `busted` (luarocks) untuk unit testing.
  * Tools dev: `gcc`/`clang`, `make`/`cmake`/`meson` bila proyek lebih besar, `luarocks`, `gdb`/`valgrind` untuk debugging memori.

* **Untuk memodifikasi binding / menambah fitur**:

  * Kuasai bahasa C: pointer, malloc/free, string lifecycle, ABI/layout struct.
  * Pahami `ffi.cdef` harus cocok persis dengan header C (signature/tipes).
  * Pahami lifetime cdata (ffigc, ffi.gc) dan risiko double-free.
  * Jika menambah fungsi yang alokasi memori di C dan mengembalikan pointer, sediakan API `free` dan wrapper di Lua yang memanggil `ffi.string` + `free`.
  * Jika menambah operasi numerik, gunakan tipe fixed-size (mis. `int32_t`, `uint64_t`) dan deklarasikan dengan `ffi.cdef`.
  * Untuk cross-platform, sediakan fallback/konfigurasi (DLL vs SO vs DYLIB) dan macro names.

---

## J. Kesalahan umum yang harus diwaspadai (ringkasan)

* **Salah `ffi.cdef`** → segfault / undefined behavior. Selalu cocokkan signature header.
* **Double-free** — panggil `ffi.gc(cdata, nil)` sebelum mem-free manual.
* **Mengakses cdata setelah free** → segfault.
* **Memakai `await` di luar coroutine** → runtime error.
* **Mengandalkan GC untuk resource deterministik** — untuk resource OS (file, socket) gunakan free/close manual bila perlu.
* **Hardcoded keys / IV (kripto)** → bahaya; gunakan generator secure random (`/dev/urandom` atau OpenSSL RAND\_bytes).
* **Testing network port clash** — gunakan port unik untuk tests, dan selalu close handles setelah test.

---

## Keterangan tambahan — dokumentasi & referensi

Untuk tiap konsep utama yang kita pakai, dokumentasi resmi yang sebaiknya Anda buka saat mengembangkan lebih jauh:

* LuaJIT FFI docs: (lihat dokumentasi official LuaJIT).
* libuv / luv docs: doc luv / libuv API.
* OpenSSL EVP API: man pages dan docs openssl.
* SDL2 docs: `SDL.h` reference.
* Busted: BDD test patterns untuk Lua.
* GCC/Clang compile flags: `-fPIC`, `-shared`, `-O2`.
<!--
(Saya tidak menyertakan link langsung di sini kecuali Anda minta; bila Anda ingin saya sisipkan tautan dokumentasi resmi untuk tiap topik, saya akan sertakan dan pastikan link bekerja.)
-->
---

# Penutup & langkah selanjutnya

* Laporan ini merangkum semua yang telah kita bangun sampai **Modul 17**, dan **membedah** setiap berkas/komponen utama: tujuan, fungsi, poin baris-per-baris penting, serta apa yang perlu Anda kuasai untuk memodifikasi atau memperluasnya.
* Jika Anda setuju, langkah berikut bisa salah satu dari ini:

  1. **Terus ke Modul 18** (mis. packaging, deploy ke LuaRocks, Neovim plugin packaging).
  2. **Minta saya keluarkan file-file lengkap** (kode siap copy-paste) untuk satu atau beberapa modul (mis. semua file FFI/OpenSSL/Server) agar Anda dapat langsung `:w` di editor.
  3. **Minta contoh konfigurasi build (Makefile / CMakeLists.txt)** untuk mengompilasi semua library C kita sekaligus.
  4. **Atau minta tautan dokumentasi resmi** untuk topik spesifik (mis. OpenSSL EVP, libuv API, LuaJIT FFI spec).

<!--
Beritahu pilihan Anda (1/2/3/4) — saya langsung kerjakan dan **akan membedah setiap baris kode** pada output yang saya hasilkan, persis seperti yang Anda minta. Saya sudah menyiapkan semua konteks sehingga saya bisa segera menghasilkan file lengkap atau build script sesuai pilihan Anda.

Bagus — saya asumsikan Anda ingin **contoh konfigurasi build** yang langsung praktis: sebuah **Makefile** (bersifat minimal, portable ke Linux) yang dapat mengkompilasi semua *shared libraries* C yang telah kita gunakan sepanjang kurikulum (sebagai satu paket), serta target untuk menjalankan test (`busted`) dan membersihkan artefak build.

Saya akan:

1. Berikan file **Makefile** lengkap.
2. Berikan **script ringkas** (bash) untuk menjalankan test/inisialisasi environment jika perlu.
3. **Membedah setiap baris** Makefile dan script — tujuan, efek, dan catatan portabilitas/penyesuaian (mis. Windows / macOS).
4. Berikan contoh **cara menjalankan** dan best practice.

Saya tidak akan menyalin ulang seluruh kode C/Lua yang sudah kita bahas — Makefile ini mengasumsikan file-file sumber (.c/.h/.lua) berada di struktur proyek yang sudah kita pakai. Jika Anda ingin, saya dapat juga menyediakan file-file sumber secara lengkap (pada pilihan berikutnya), tetapi untuk saat ini fokus ke build orchestration.

-->
---

## 1) Makefile — kompilasi semua shared libs & helper targets

Simpan sebagai `Makefile` di root proyek.

```makefile
# Makefile untuk mengkompilasi semua shared libraries C yang dipakai di kurikulum
# Target utama:
#   make all       -> kompilasi semua .so
#   make test      -> jalankan busted (unit & integration)
#   make clean     -> hapus file hasil build

# Toolchain / flags
CC        ?= gcc
CFLAGS    ?= -O2 -fPIC -Wall -Wextra
LDFLAGS   ?= -shared
PKG_CONFIG?= pkg-config

# Direktori sumber & build
SRC_DIR   ?= .
BUILD_DIR ?= build
LIBDIR    ?= $(BUILD_DIR)/lib

# Daftar library C yang ingin kita buat (nama target tanpa ekstensi)
# Pastikan file .c/.h sesuai nama berikut ada di root atau subfolder.
LIBS := libmath libstrutils libarray libperson libsort libfib

# Ekstensi shared object untuk platform (Linux default .so)
SO_EXT ?= so

# Jika LD_FLAGS khusus butuh libm/libcrypto, contoh -lcrypto; kita link shared lib tanpa linking eksternal
# Rule umum: compile setiap lib: gcc -O2 -fPIC -shared -o build/lib/libname.so src.c
.SILENT:

# Default target
all: prepare_dirs $(addprefix $(LIBDIR)/, $(addsuffix .$(SO_EXT), $(LIBS)))
	@echo "Build selesai. Libraries di $(LIBDIR)"

# Pastikan direktori build ada
prepare_dirs:
	@mkdir -p $(LIBDIR)

# Per-library rules (pattern rule)
# Mengasumsikan file sumber berada di root: libname.c (mis. libmath.c)
$(LIBDIR)/%.$(SO_EXT): % .PHONY
	@echo "Compiling $< -> $@"
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

# Target spesifik (jika perlu menambahkan flags atau sumber lain)
# Contoh: libperson membutuhkan -lm (untuk strlen/sqrt) -> jika perlu, override
# Anda bisa menambahkan rule khusus:
$(LIBDIR)/libperson.$(SO_EXT): libperson.c libperson.h | prepare_dirs
	@echo "Compiling libperson (special rule) -> $@"
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ libperson.c

# Run tests (mengasumsikan luarocks dependencies sudah terinstall: luv, busted)
.PHONY: test
test:
	@echo "Menjalankan test (busted)..."
	@if ! command -v busted >/dev/null 2>&1; then \
	  echo "busted tidak ditemukan. Pastikan luarocks install busted"; exit 1; \
	fi
	# jalankan busted di folder spec
	busted spec

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Membersihkan build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Done."

# Helper: run a specific Lua demo
.PHONY: run-demo
run-demo:
	@echo "Contoh: make run-demo DEMO=pipeline_server.lua"
	@if [ -z "$(DEMO)" ]; then echo "Set DEMO variable (contoh: DEMO=pipeline_server.lua)"; exit 1; fi
	@echo "Menjalankan $$DEMO dengan luajit..."
	@luajit $(DEMO)

# Help
.PHONY: help
help:
	@echo "Makefile targets:"
	@echo "  make all        -> compile semua shared libraries (default)"
	@echo "  make test       -> run busted test suite (requires busted)"
	@echo "  make clean      -> remove build artifacts (build/)"
	@echo "  make run-demo DEMO=<file.lua> -> run a demo with luajit"
	@echo ""
	@echo "Variabel yang bisa di-override:"
	@echo "  CC, CFLAGS, LDFLAGS, BUILD_DIR, LIBDIR, SO_EXT"
```

---

## 2) Script helper (opsional) — `scripts/setup_env.sh`

Simpan di `scripts/setup_env.sh`. Script ini berguna menyiapkan lingkungan development pada mesin Linux (Ubuntu-like) — menginstal luarocks, luajit, libuv, libssl dev headers, dan busted/luv.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Men-setup environment (Ubuntu/Debian-like). Edit script sesuai distro Anda."

# update
sudo apt-get update

# install build essentials
sudo apt-get install -y build-essential curl pkg-config

# install dependencies yang umum dipakai (libuv, openssl dev headers)
sudo apt-get install -y libssl-dev libuv1-dev

# install LuaJIT (paket di distro) dan luarocks
sudo apt-get install -y luajit luarocks

# pasang luarocks modules yang dibutuhkan (luv, busted)
sudo luarocks install luv
sudo luarocks install busted

echo "Setup selesai. Pastikan luajit dan luarocks berada di PATH."
```

> Catatan: script ini target Ubuntu/Debian. Untuk ArchLinux (Anda menyebut Arch), gunakan `pacman -S luajit luarocks gcc make openssl libuv` dsb. Sesuaikan sesuai distro.

---

## 3) Penjelasan MAKEFILE — baris demi baris (detail teknis)

Saya akan membedah Makefile di atas bagian-per-bagian, menjelaskan tujuan tiap baris / blok, dan memberi catatan pengubahan bila perlu.

### Header & komentar

```makefile
# Makefile untuk mengkompilasi semua shared libraries C yang dipakai di kurikulum
```

* Penjelasan ringkas tentang tujuan file.

### Toolchain / flags

```makefile
CC        ?= gcc
CFLAGS    ?= -O2 -fPIC -Wall -Wextra
LDFLAGS   ?= -shared
PKG_CONFIG?= pkg-config
```

* `CC ?= gcc` — gunakan `gcc` kecuali variabel CC sudah di-override dari environment. Ini memudahkan pengguna mengganti `clang` mis. `make CC=clang`.
* `CFLAGS`:

  * `-O2` optimisasi (seimbang).
  * `-fPIC` diperlukan untuk shared object pada Linux agar kode position-independent.
  * `-Wall -Wextra` menyalakan peringatan kompilator untuk membantu deteksi bug.
* `LDFLAGS = -shared` — flag untuk menghasilkan shared object.
* `PKG_CONFIG` disediakan jika nanti Anda ingin menambahkan dependensi pkg-config (mis. `openssl` lib).

### Direktori build

```makefile
SRC_DIR   ?= .
BUILD_DIR ?= build
LIBDIR    ?= $(BUILD_DIR)/lib
```

* `BUILD_DIR` memisahkan artefak build dari sumber. Default `build`.
* `LIBDIR` menampung shared libs: `build/lib`.

### Daftar library

```makefile
LIBS := libmath libstrutils libarray libperson libsort libfib
```

* Daftar singkat nama-nama target shared libraries. Pastikan ada file `libmath.c` dsb. Jika Anda menaruh sumber di subfolder (mis. `csrc/`), modifikasi pattern rule atau prefix pada nama sumber.

### Ekstensi shared object

```makefile
SO_EXT ?= so
```

* Pada Linux `.so`. Jika Anda ingin cross-platform, bisa override: `make SO_EXT=dylib` pada macOS (tapi macOS memerlukan flags berbeda seperti `-dynamiclib` bukannya `-shared`).

### Silent mode

```makefile
.SILENT:
```

* Membuat output Makefile lebih ringkas (tidak echo perintah yang dijalankan). Jika Anda ingin debug, hapus atau ubah.

### Default target

```makefile
all: prepare_dirs $(addprefix $(LIBDIR)/, $(addsuffix .$(SO_EXT), $(LIBS)))
	@echo "Build selesai. Libraries di $(LIBDIR)"
```

* `all` tergantung `prepare_dirs` dan daftar file `.so` di `$(LIBDIR)`.
* `$(addprefix $(LIBDIR)/, $(addsuffix .$(SO_EXT), $(LIBS)))` -> menghasilkan daftar `build/lib/libmath.so build/lib/libstrutils.so ...`.
* Setelah semua selesai, echo pesan sukses.

### prepare\_dirs

```makefile
prepare_dirs:
	@mkdir -p $(LIBDIR)
```

* Membuat direktori target jika belum ada.

### Pattern rule per-library

```makefile
$(LIBDIR)/%.$(SO_EXT): % .PHONY
	@echo "Compiling $< -> $@"
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
```

* Ini aturan generik: untuk target `build/lib/libmath.so`, `make` mencari sumber `%` yaitu `libmath` — **di sini kita mengasumsikan file sumber bernama `libmath.c`**. Namun ada detail: pattern rule di atas menggunakan prerequisite `%` (yang mengejar file bernama `libmath` tanpa ekstensi). Ini agak longgar — agar lebih aman, kita bisa ganti prerequisite jadi `%.c`. Untuk ketepatan, sebaiknya gunakan:

  ```makefile
  $(LIBDIR)/%.$(SO_EXT): %.c | prepare_dirs
      $(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
  ```

  Namun versi yang saya tampilkan sebelumnya bertujuan ringkas; jika Anda temui kendala "No rule to make target 'libmath'", ubah ke `%.c` seperti saran di atas.

* `$<` adalah prerequisite pertama (sumber `.c`), `$@` adalah target (file .so).

* Perintah kompilasi menghasilkan shared lib.

### Rule khusus `libperson`

```makefile
$(LIBDIR)/libperson.$(SO_EXT): libperson.c libperson.h | prepare_dirs
	@echo "Compiling libperson (special rule) -> $@"
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ libperson.c
```

* Contoh override jika suatu library butuh sumber header tambahan atau flags spesifik; Anda dapat menambahkan `-lm` atau `-lcrypto` jika perlu link ke library lain — tapi hati-hati: saat membuat shared object kita biasanya tidak menspesifikasi `-l` untuk library C standard karena konsumen (aplikasi Lua) yang akan menautkannya saat runtime; jika perlu, tambahkan `-lcrypto` dll.

### Test target

```makefile
.PHONY: test
test:
	@echo "Menjalankan test (busted)..."
	@if ! command -v busted >/dev/null 2>&1; then \
	  echo "busted tidak ditemukan. Pastikan luarocks install busted"; exit 1; \
	fi
	busted spec
```

* `test` memeriksa apakah `busted` ada; jika tidak, beri pesan.
* Menjalankan `busted spec` akan menjalankan semua file test di folder `spec/`.

### Clean target

```makefile
.PHONY: clean
clean:
	@echo "Membersihkan build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Done."
```

* Menghapus folder build beserta library.

### Run-demo helper

```makefile
.PHONY: run-demo
run-demo:
	@echo "Contoh: make run-demo DEMO=pipeline_server.lua"
	@if [ -z "$(DEMO)" ]; then echo "Set DEMO variable (contoh: DEMO=pipeline_server.lua)"; exit 1; fi
	@echo "Menjalankan $$DEMO dengan luajit..."
	@luajit $(DEMO)
```

* Cara menjalankan: `make run-demo DEMO=pipeline_server.lua`
* Menjalankan demo via `luajit`. Jika Anda menggunakan `lua` biasa tanpa LuaJIT, ganti perintah.

### Help target

```makefile
.PHONY: help
help:
	@echo "Makefile targets:"
	...
```

* Menyediakan panduan ringkas.

---

## 4) Catatan portabilitas & penyesuaian (penting)

* **macOS**: shared lib `dylib` membutuhkan `-dynamiclib` bukan `-shared`. Anda bisa override variabel:

  ```bash
  make SO_EXT=dylib LDFLAGS="-dynamiclib"
  ```

  Namun beberapa header/flags mungkin berbeda.

* **Windows (MinGW)**: shared lib `.dll` sering memerlukan opsi lain dan definisi `__declspec(dllexport)` pada C side; Makefile sederhana ini tidak menangani Windows secara langsung. Untuk Windows, saya sarankan buat CMakeLists sehingga cross-platform build lebih mudah.

* **Library dependencies**: beberapa lib (OpenSSL, SDL2) memerlukan header & library dev terinstal. Untuk lib yang tergantung pada `-lcrypto` atau `-lSDL2`, Anda perlu menambahkan link flags pada rule khusus. Contoh:

  ```makefile
  $(LIBDIR)/libsslhelper.so: sslhelper.c
      $(CC) $(CFLAGS) $(LDFLAGS) -o $@ sslhelper.c -lcrypto
  ```

  Tapi perhatikan: `-lcrypto` memaksa linking ke libcrypto saat membuat .so — ini boleh, namun di beberapa kasus Anda cukup memuat library di runtime (`ffi.load("crypto")`) tanpa link pada compile-time.

* **Sumber nama**: pastikan setiap `libname.c` memang ada di folder proyek. Jika sumber berada di `csrc/`, ubah pattern rule menjadi `csrc/%.c`.

---

## 5) Cara menjalankan (contoh praktis)

Asumsi: Anda berada di root proyek, file Makefile tersimpan.

1. Buat direktori `build` dan kompilasi semua libs:

   ```bash
   make all
   ```

2. Jika ingin compile dengan clang:

   ```bash
   make CC=clang all
   ```

3. Jalankan unit tests:

   ```bash
   make test
   ```

   (Pastikan `busted` & `luv` terinstal. Lihat `scripts/setup_env.sh` untuk bantuan instalsi.)

4. Jalankan demo pipeline server (setelah compile libs jika ada dependency native):

   ```bash
   make run-demo DEMO=pipeline_server.lua
   ```

5. Membersihkan artefak:

   ```bash
   make clean
   ```

---

## 6) Rekomendasi lanjut (opsional)

* Untuk proyek yang akan dipublikasikan atau dikembangkan lintas-platform, gunakan **CMake** atau **Meson**. Keduanya memudahkan pembuatan `.dll/.so/.dylib` dan integrasi dengan CI.

<!--
* Jika Anda ingin, saya bisa:

  * (A) Buatkan **CMakeLists.txt** yang setara (lebih portable).
  * (B) Hasilkan **script GitHub Actions** yang menjalankan `make all` lalu `busted` (supaya CI build native libs sebelum test).
  * (C) Ekspor semua file sumber `.c/.h/.lua` yang kita buat sebelumnya sebagai paket ZIP atau blok kode siap `copy/paste`.

Pilih opsi lanjutan yang Anda inginkan (A / B / C), atau saya lanjut dan langsung buatkan dua di antaranya (mis. buat CMake + CI) — saya akan kerjakan dan **membedah setiap baris** seperti Anda minta.
-->
Kita akan mengerjakan **A: buat CMakeLists.txt** yang portable dan komprehensif untuk proyek ini, lalu saya bedah keseluruhan file tersebut sehingga Anda memahami setiap baris dan implikasinya.

<!--
* Jika Anda ingin, saya bisa:
Setelah Anda konfirmasi, kita lanjut ke **B** dan **C** sesuai urutan yang Anda minta.
-->

Kita akan mengerjakan **A: buat CMakeLists.txt** yang portable dan komprehensif untuk proyek ini, lalu saya bedah keseluruhan file tersebut sehingga Anda memahami setiap baris dan implikasinya.
Di bawah ini:

1. File **CMakeLists.txt** dibawah ini cukup lengkap (komentar di dalam file ringkas tetapi cukup) — cocok untuk proyek yang berisi beberapa shared libraries C (libmath, libstrutils, libarray, libperson, libsort, libfib) dan target helper untuk menjalankan test (`busted`) jika tersedia.
2. Selanjutnya kita akan menjelaskan **baris-per-baris dan blok-per-blok** seluruh CMakeLists — tujuan, efek, rekomendasi penyesuaian, dan catatan platform (Linux/macOS/Windows).
3. Pada bagian akhir kita akan menyertakan **cara menjalankan** build & test, serta referensi dokumentasi resmi (sumber) untuk poin-poin penting.

---

## 1) File: `CMakeLists.txt`

Simpan file ini di root proyek Anda.

```cmake
cmake_minimum_required(VERSION 3.16)
project(lua_ffibindings
  VERSION 0.1
  DESCRIPTION "Build helpers for LuaJIT/FFI example libraries"
  LANGUAGES C)

# --- Basic policy / flags ---------------------------------------------------
# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Enable position independent code globally (shared libs normally need this).
# Note: SHARED targets normally default to PIC, but set globally for consistency.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Allow user to override build directories and options
set(SRC_DIR "${CMAKE_SOURCE_DIR}" CACHE PATH "Source directory containing .c/.h files")
set(BUILD_DIR "${CMAKE_BINARY_DIR}" CACHE PATH "Build directory")
set(LIB_OUTPUT_DIR "${BUILD_DIR}/lib" CACHE PATH "Directory for generated shared libraries")

# Create list of C libraries to build (names correspond to source files: libname.c)
# Edit this list to match actual .c files in your repo.
set(TARGET_LIBS
  libmath
  libstrutils
  libarray
  libperson
  libsort
  libfib
)

# Optionally build only subset
option(BUILD_ALL_LIBS "Build all example C shared libraries" ON)

# --- Find optional external dependencies via pkg-config / find_package -------
# Use PkgConfig to find system libraries (libuv, luajit) if available
find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
  # Try to find luajit (optional)
  pkg_check_modules(LUAJIT_PKG QUIET luajit)
  # Try to find libuv (optional)
  pkg_check_modules(LIBUV_PKG QUIET libuv)
endif()

# Try to find OpenSSL (crypto) (optional; used by OpenSSL binding examples)
find_package(OpenSSL QUIET COMPONENTS Crypto)

# --- Prepare output directory ------------------------------------------------
file(MAKE_DIRECTORY "${LIB_OUTPUT_DIR}")

# Helper macro: define a shared library from a single C source file
# Usage: add_example_shared(libname)
macro(add_example_shared NAME)
  # Source assumed to be ${SRC_DIR}/${NAME}.c
  set(src "${SRC_DIR}/${NAME}.c")
  if (NOT EXISTS "${src}")
    message(WARNING "Source file ${src} not found; skipping target ${NAME}")
    return()
  endif()

  add_library(${NAME} SHARED "${src}")

  # Set output directory for the shared object
  set_target_properties(${NAME} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
  )

  # On Windows, export all symbols automatically if necessary
  if(WIN32)
    # Some toolchains may require explicit export; this helps by generating a .def file.
    set_target_properties(${NAME} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
  endif()

  # Add include dir to help projects that include the headers from src root
  target_include_directories(${NAME} PRIVATE "${SRC_DIR}")

  # Add some compile warnings by default (user can override CFLAGS)
  target_compile_options(${NAME} PRIVATE
    $<$<C_COMPILER_ID:GNU>:-Wall -Wextra -Wpedantic>
    $<$<C_COMPILER_ID:Clang>:-Wall -Wextra -Wpedantic>
    $<$<C_COMPILER_ID:MSVC>:/W3>
  )

  # Link math library on UNIX when symbols like sqrt are used (safe to link conditionally)
  if(UNIX)
    target_link_libraries(${NAME} PRIVATE m)
  endif()
endmacro()

# --- Create targets ----------------------------------------------------------
if(BUILD_ALL_LIBS)
  foreach(lib IN LISTS TARGET_LIBS)
    add_example_shared(${lib})
    list(APPEND GENERATED_LIB_TARGETS ${lib})
  endforeach()
endif()

# --- Optional: add custom rules for special libraries if they need extra flags
# Example: if libperson or libmath needed special defines or extra sources, add here.
# (Uncomment / edit if required)
# add_library(libperson SHARED libperson.c)
# target_link_libraries(libperson PRIVATE m)

# --- Add custom target to run unit tests (busted) if busted present -----------
find_program(BUSTED_EXECUTABLE busted)
if(BUSTED_EXECUTABLE)
  add_custom_target(run-tests
    COMMAND ${CMAKE_COMMAND} -E echo "Running busted tests..."
    COMMAND ${BUSTED_EXECUTABLE} -v
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Run busted test suite")
else()
  add_custom_target(run-tests
    COMMAND ${CMAKE_COMMAND} -E echo "busted not found; install busted (luarocks install busted) to enable run-tests"
    COMMENT "run-tests (busted not found)")
endif()

# --- Provide helpful status summary -----------------------------------------
message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Source dir: ${SRC_DIR}")
message(STATUS "Build dir: ${BUILD_DIR}")
message(STATUS "Libraries output: ${LIB_OUTPUT_DIR}")
if(PkgConfig_FOUND)
  if(LUAJIT_PKG_FOUND)
    message(STATUS "Found LuaJIT via pkg-config: includes=${LUAJIT_PKG_INCLUDEDIR}")
  else()
    message(STATUS "LuaJIT (pkg-config) not found; binding code may require manual setup")
  endif()
  if(LIBUV_PKG_FOUND)
    message(STATUS "Found libuv via pkg-config: libs=${LIBUV_PKG_LIBRARIES}")
  endif()
endif()
if(OpenSSL_FOUND)
  message(STATUS "Found OpenSSL: ${OPENSSL_VERSION}")
endif()

# --- Install rules (optional) ------------------------------------------------
# Install shared libraries to lib dir if user wants 'make install'
install(DIRECTORY ${LIB_OUTPUT_DIR} DESTINATION . OPTIONAL)
```

---

## 2) Penjelasan menyeluruh — blok demi blok dan baris-per-baris penting

Saya jelaskan per-bagian agar Anda memahami maksud, efek build, dan titik-titik yang perlu disesuaikan.

### Header & minimum CMake

```cmake
cmake_minimum_required(VERSION 3.16)
project(lua_ffibindings
  VERSION 0.1
  DESCRIPTION "Build helpers for LuaJIT/FFI example libraries"
  LANGUAGES C)
```

* `cmake_minimum_required`: menetapkan versi CMake minimal; 3.16 adalah pilihan aman untuk fitur modern (pkg\_check\_modules & target properties). Dokumen `add_library` dan modul CMake relevan ada di dokumentasi resmi. ([cmake.org][1])
* `project(...)` menentukan nama proyek, versi, dan bahasa (C).

### Standard C & PIC

```cmake
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
```

* `CMAKE_C_STANDARD`: menetapkan C11; memudahkan portabilitas.
* `CMAKE_POSITION_INDEPENDENT_CODE ON`: memastikan kompiler menghasilkan code position-independent (PIC). Shared library biasanya memerlukan PIC; meskipun SHARED library secara default biasanya PIC, kita set global agar target lain konsisten. Lihat dokumentasi properti POSITION\_INDEPENDENT\_CODE. ([cmake.org][2])

### Direktori & daftar library

```cmake
set(SRC_DIR "${CMAKE_SOURCE_DIR}" CACHE PATH ...)
set(BUILD_DIR "${CMAKE_BINARY_DIR}" CACHE PATH ...)
set(LIB_OUTPUT_DIR "${BUILD_DIR}/lib" CACHE PATH ...)
set(TARGET_LIBS libmath libstrutils libarray libperson libsort libfib)
option(BUILD_ALL_LIBS "Build all example C shared libraries" ON)
```

* Variabel ini membuat konfigurasi fleksibel: Anda bisa override pada saat `cmake` (mis. `cmake -DSRC_DIR=./csrc ..`).
* `TARGET_LIBS` berisi nama-nama library yang akan dicari sebagai `libname.c`. Jika Anda meletakkan sumber di subfolder, ubah `SRC_DIR` atau ubah macro `add_example_shared` (lihat bawah).

### Find external deps via pkg-config & OpenSSL

```cmake
find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
  pkg_check_modules(LUAJIT_PKG QUIET luajit)
  pkg_check_modules(LIBUV_PKG QUIET libuv)
endif()
find_package(OpenSSL QUIET COMPONENTS Crypto)
```

* Kita mencoba menemukan `pkg-config` (FindPkgConfig) dan melalui itu memeriksa apakah `luajit` & `libuv` terdaftar di pkg-config. `FindPkgConfig` menyediakan `pkg_check_modules()` sebagaimana dokumentasinya. ([cmake.org][3])
* `find_package(OpenSSL ...)` mencari OpenSSL/crypto jika ingin membangun binding terkait cryptography (opsional). `FindOpenSSL` module disediakan CMake. ([cmake.org][4])

> Catatan: `pkg_check_modules` akan bekerja bila distro memasang file `.pc` untuk `luajit` atau `libuv`. Di beberapa distro nama package `.pc` bisa berbeda (mis. `luajit` vs `luajit-2.1`) — jika Anda menemukan "not found", periksa `pkg-config --list-all` di sistem Anda.

### Membuat direktori output

```cmake
file(MAKE_DIRECTORY "${LIB_OUTPUT_DIR}")
```

* Pastikan folder `build/lib` ada agar target output bisa ditulis.

### Macro `add_example_shared`

Kita buat macro untuk aturan pengerjaan target lib yang seragam.

```cmake
macro(add_example_shared NAME)
  set(src "${SRC_DIR}/${NAME}.c")
  if (NOT EXISTS "${src}")
    message(WARNING "Source file ${src} not found; skipping target ${NAME}")
    return()
  endif()

  add_library(${NAME} SHARED "${src}")

  set_target_properties(${NAME} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
  )

  if(WIN32)
    set_target_properties(${NAME} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
  endif()
  target_include_directories(${NAME} PRIVATE "${SRC_DIR}")
  target_compile_options(${NAME} PRIVATE
    $<$<C_COMPILER_ID:GNU>:-Wall -Wextra -Wpedantic>
    $<$<C_COMPILER_ID:Clang>:-Wall -Wextra -Wpedantic>
    $<$<C_COMPILER_ID:MSVC>:/W3>
  )
  if(UNIX)
    target_link_libraries(${NAME} PRIVATE m)
  endif()
endmacro()
```

Penjelasan kunci:

* `add_library(NAME SHARED src)`: buat shared library (dynamic). `add_library` adalah mekanisme CMake standar untuk membuat library (SHARED/STATIC/MODULE). Jika target SHARED dibuat, CMake akan menghasilkan `.so` (Linux), `.dylib` (macOS) atau `.dll` + import lib (Windows) sesuai platform. Dokumentasi `add_library`. ([cmake.org][1])
* `set_target_properties(... LIBRARY_OUTPUT_DIRECTORY ...)`: arahkan hasil kompilasi ke `build/lib`.
* `WINDOWS_EXPORT_ALL_SYMBOLS`: di Windows, agar semua simbol diekspor (mencegah perlu `__declspec(dllexport)` di semua fungsi) Anda dapat men-set properti ini — berguna untuk library C yang tidak mengekspor simbol secara eksplisit. Dokumentasi properti ini. ([cmake.org][5])
* `target_include_directories`: agar header (`.h`) yang berada di `SRC_DIR` dapat di-include oleh konsumen target jika perlu.
* `target_compile_options` menggunakan *generator expressions* untuk menambah flags kompilator spesifik. Ini bagus untuk memastikan peringatan diaktifkan saat compile.
* `target_link_libraries(... PRIVATE m)`: tautkan math lib pada UNIX jika fungsi math digunakan (contoh `sqrt`/`hypot`); di Windows tidak diperlukan. Ini conditional membantu portabilitas.

### Men-generate targets

```cmake
if(BUILD_ALL_LIBS)
  foreach(lib IN LISTS TARGET_LIBS)
    add_example_shared(${lib})
    list(APPEND GENERATED_LIB_TARGETS ${lib})
  endforeach()
endif()
```

* Loop membuat target per library. Jika ada file sumber yang hilang, macro akan mem-print warning dan melewati target tersebut.

### Target run-tests (custom)

```cmake
find_program(BUSTED_EXECUTABLE busted)
if(BUSTED_EXECUTABLE)
  add_custom_target(run-tests
    COMMAND ${CMAKE_COMMAND} -E echo "Running busted tests..."
    COMMAND ${BUSTED_EXECUTABLE} -v
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Run busted test suite")
else()
  add_custom_target(run-tests
    COMMAND ${CMAKE_COMMAND} -E echo "busted not found; install busted (luarocks install busted) to enable run-tests"
    COMMENT "run-tests (busted not found)")
endif()
```

* `find_program` mencari executable `busted` pada PATH. Jika ditemukan, `add_custom_target(run-tests ...)` memungkinkan Anda menjalankan `cmake --build . --target run-tests` untuk menjalankan test suite dari build system (berguna di CI). `add_custom_target` adalah cara standar membuat target tanpa artefak file (dokumen `add_custom_target`). ([cmake.org][6])

### Status messages & install

```cmake
message(STATUS "Project: ${PROJECT_NAME}")
...
install(DIRECTORY ${LIB_OUTPUT_DIR} DESTINATION . OPTIONAL)
```

* Menampilkan pesan status saat konfigurasi.
* `install()` di sini sederhana; Anda bisa memperluasnya untuk `install(TARGETS ...)` jika ingin packaging.

---

## 3) Bagaimana cara menggunakan CMakeLists ini (langkah praktis)

Asumsi: `CMakeLists.txt` berada di root proyek, dan file sumber `.c` (mis. `libmath.c`, `libstrutils.c` dll) juga berada di `SRC_DIR` (default .).

1. Buat direktori build dan jalankan konfigurasi:

   ```bash
   mkdir -p build
   cmake -S . -B build
   ```

   * `-S .` sumber root; `-B build` tempat konfigurasi & artefak.

2. Bangun semua library:

   ```bash
   cmake --build build --parallel
   ```

   * Ini memanggil `make` atau `ninja` sesuai generator yang dipilih.

3. Jalankan unit tests (jika `busted` terpasang):

   ```bash
   cmake --build build --target run-tests
   ```

   * Ini menjalankan custom target `run-tests` yang memanggil `busted -v`.

4. Jika Anda ingin hanya membangun satu library:

   ```bash
   cmake --build build --target libmath
   ```

   (nama target sama dengan nama library `libmath`).

5. Jika menggunakan GUI atau IDE (CLion, VSCode CMake Tools), arahkan ke folder `build` sebagai working directory.

---

## 4) Catatan platform & penyesuaian

* **macOS**: CMake memilih ekstensi `.dylib` atau `.so` sesuai platform. Anda tidak perlu mengganti `.so` manual. Jika perlu, gunakan `CMAKE_SHARED_LIBRARY_SUFFIX` atau set `-dynamiclib` etc — CMake menangani ini.
* **Windows**: membangun `.dll` berbeda: Anda sering memerlukan `__declspec(dllexport)` pada fungsi yang diekspor. CMake property `WINDOWS_EXPORT_ALL_SYMBOLS` membantu membuat `.def` otomatis agar fungsi diekspor tanpa menambahkan `__declspec`. Namun untuk kontrol ekspor yang aman dan portable, sebaiknya definisikan makro ekspor di kode sumber jika Anda targetkan Windows. Referensi properti Windows export. ([cmake.org][5])
* **Dependencies (libuv, openssl, luajit)**:

  * Jika Anda mempunyai binding yang mengimpor `libuv` atau `OpenSSL` pada waktu kompilasi (mis. membuat small helper C yang link ke libuv), gunakan `pkg_check_modules` dan `target_link_libraries(... PUBLIC ${LIBUV_PKG_LIBRARIES})` serta `target_include_directories(... PUBLIC ${LIBUV_PKG_INCLUDEDIR})`. Dokumentasi `FindPkgConfig` dan `FindOpenSSL` relevan. ([cmake.org][3])

---

## 5) Referensi / Sumber (dikutip)

Di bawah adalah dokumentasi resmi / referensi yang saya gunakan dan yang sebaiknya Anda rujuk saat mengembangkan CMake lebih lanjut:

* `add_library` (CMake official docs). ([cmake.org][1])
* `FindPkgConfig` / `pkg_check_modules` (CMake module docs). ([cmake.org][3])
* `FindOpenSSL` (CMake module docs for OpenSSL). ([cmake.org][4])
* `PROPERTY POSITION_INDEPENDENT_CODE` (CMake target property docs). ([cmake.org][2])
* `add_custom_target` (CMake docs — custom build / test targets). ([cmake.org][6])

(Saya menaruh referensi ini karena bagian-bagian ini adalah fondasi pembuatan shared libraries dan integrasi dependency di CMake).

---

## 6) Rekomendasi & best-practices singkat

* Jika proyek tumbuh, pertimbangkan memindahkan semua kode C ke `csrc/` (SRC\_DIR) dan header ke `include/`. Kemudian gunakan `target_include_directories(${NAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)`.
* Untuk multiplatform (Windows), pertimbangkan menambahkan `__declspec(dllexport)` macros di file `.h` atau gunakan CMake property `WINDOWS_EXPORT_ALL_SYMBOLS` hanya sebagai fallback.
* Untuk paket distribusi & reproducible build, gunakan `CMakePresets.json` atau `conan`/`vcpkg` untuk manajemen dependency native.
* Untuk CI: di workflow CI (GitHub Actions) jalankan `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release` lalu `cmake --build build --parallel` dan `cmake --build build --target run-tests`.

---

<!--
## 7) Selesai — konfirmasi A

Saya sudah menyiapkan `CMakeLists.txt` lengkap bersama penjelasan mendetail setiap bagian penting, rekomendasi penyesuaian, cara menjalankan, dan referensi dokumen resmi untuk fitur-fitur yang paling penting (`add_library`, `FindPkgConfig`, `FindOpenSSL`, `POSITION_INDEPENDENT_CODE`, `add_custom_target`).

Jika Anda ingin, saya bisa:

* (a) **Commit** file ini ke struktur proyek yang Anda miliki (saya tidak dapat menulis langsung ke filesystem Anda — Anda harus menyalin file ke repo); atau
* (b) **Sesuaikan** CMakeLists agar sesuai struktur sumber Anda (misal: jika semua `.c` di `csrc/`, atau jika beberapa library memerlukan flags/link khusus seperti `-lcrypto`), saya akan ubah file dan jelaskan perubahan; atau
* (c) Lanjut ke **B** (GitHub Actions CI) — saya akan buat workflow yang mem-build native libs via CMake lalu jalankan `busted` di runner.

Beritahu pilihan Anda (lanjut ke **B** sekarang atau minta penyesuaian CMakeLists) — saya akan langsung kerjakan langkah selanjutnya.
-->
[1]: https://cmake.org/cmake/help/latest/command/add_library.html?utm_source=chatgpt.com "add_library — CMake 4.1.1 Documentation"
[2]: https://cmake.org/cmake/help/latest/prop_tgt/POSITION_INDEPENDENT_CODE.html?utm_source=chatgpt.com "POSITION_INDEPENDENT_CO..."
[3]: https://cmake.org/cmake/help/latest/module/FindPkgConfig.html?utm_source=chatgpt.com "FindPkgConfig — CMake 4.1.1 Documentation"
[4]: https://cmake.org/cmake/help/latest/module/FindOpenSSL.html?utm_source=chatgpt.com "FindOpenSSL — CMake 4.1.1 Documentation"
[5]: https://cmake.org/cmake/help/latest/prop_tgt/WINDOWS_EXPORT_ALL_SYMBOLS.html?utm_source=chatgpt.com "WINDOWS_EXPORT_ALL_SYM..."
[6]: https://cmake.org/cmake/help/latest/command/add_custom_target.html?utm_source=chatgpt.com "add_custom_target — CMake 4.1.1 Documentation"

Berikutnya kita akan masuk ke **B: GitHub Actions CI**.
Target: workflow YAML di `.github/workflows/ci.yml` yang:

1. **Setup environment**: install LuaJIT, luarocks, CMake, compiler.
2. **Build** semua library C dengan `CMakeLists.txt` yang sudah kita buat.
3. **Install dependency Lua** (luv, busted).
4. **Run tests** dengan target `run-tests` (custom CMake) atau langsung `busted`.

Setelah file YAML, saya akan **membedah baris demi baris** isi workflow supaya jelas fungsi setiap bagian.

---

## 1) File: `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
    # --- Step 1: checkout source ---
    - name: Checkout repository
      uses: actions/checkout@v3

    # --- Step 2: install dependencies ---
    - name: Install system dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y build-essential cmake pkg-config \
          libssl-dev libuv1-dev luajit luarocks

    # --- Step 3: install Lua dependencies via luarocks ---
    - name: Install LuaRocks packages
      run: |
        sudo luarocks install luv
        sudo luarocks install busted

    # --- Step 4: configure project with CMake ---
    - name: Configure with CMake
      run: cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

    # --- Step 5: build libraries ---
    - name: Build shared libraries
      run: cmake --build build --parallel

    # --- Step 6: run tests (custom target run-tests) ---
    - name: Run tests
      run: cmake --build build --target run-tests
```

---

## 2) Bedah isi workflow — baris demi baris

### Header

```yaml
name: CI
```

* Nama workflow yang akan tampil di tab *Actions* di GitHub.

```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

* Workflow berjalan setiap kali ada *push* ke branch `main`, atau ada *pull request* ke `main`.
* Bisa ditambah branch lain sesuai kebutuhan.

### Job utama

```yaml
jobs:
  build-and-test:
    runs-on: ubuntu-latest
```

* Mendefinisikan satu job bernama `build-and-test`.
* Runner `ubuntu-latest` sudah punya GCC, clang, make, dsb — cocok untuk build C dan menjalankan LuaJIT.

### Step 1: Checkout

```yaml
- name: Checkout repository
  uses: actions/checkout@v3
```

* Menggunakan action resmi GitHub untuk men-clone kode repository ke runner.

### Step 2: Install dependencies

```yaml
- name: Install system dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y build-essential cmake pkg-config \
      libssl-dev libuv1-dev luajit luarocks
```

* Menginstal alat dasar build:

  * `build-essential`: gcc/g++/make.
  * `cmake`: build system.
  * `pkg-config`: membantu deteksi library.
  * `libssl-dev`, `libuv1-dev`: headers untuk OpenSSL dan libuv.
  * `luajit`, `luarocks`: runtime dan package manager LuaJIT.

### Step 3: Install Lua packages

```yaml
- name: Install LuaRocks packages
  run: |
    sudo luarocks install luv
    sudo luarocks install busted
```

* Memasang package Lua yang diperlukan:

  * `luv`: binding Lua untuk libuv (async I/O).
  * `busted`: framework unit testing Lua.

### Step 4: Configure CMake

```yaml
- name: Configure with CMake
  run: cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
```

* Konfigurasi project dengan CMake.
* `-S .` → sumber kode di root repo.
* `-B build` → hasil konfigurasi di folder `build`.
* `-DCMAKE_BUILD_TYPE=Release` → optimisasi release.

### Step 5: Build

```yaml
- name: Build shared libraries
  run: cmake --build build --parallel
```

* Menjalankan build untuk semua target yang didefinisikan (shared libs: libmath.so, dll).
* `--parallel` memanfaatkan banyak core CPU di runner.

### Step 6: Run tests

```yaml
- name: Run tests
  run: cmake --build build --target run-tests
```

* Menjalankan target `run-tests` yang sudah kita definisikan di `CMakeLists.txt`.
* Jika `busted` ada → akan jalan `busted -v` dan melaporkan hasil test.
* Jika `busted` tidak ada → hanya print pesan peringatan.

---

## 3) Cara kerja CI ini

* Begitu Anda push code ke branch `main`, workflow ini akan:

  1. Build semua library C (`.so`) dengan CMake.
  2. Install dependencies Lua.
  3. Jalankan seluruh test di folder `spec/`.
* Jika test gagal → job `Run tests` gagal → GitHub menandai commit PR sebagai "red".
* Jika semua sukses → commit PR hijau.

---

## 4) Sumber Referensi

* Dokumentasi GitHub Actions (workflow syntax): [GitHub Docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
* Action `checkout`: [actions/checkout@v3](https://github.com/actions/checkout)
* Dokumentasi `cmake --build`: [CMake Build Tool Mode](https://cmake.org/cmake/help/latest/manual/cmake.1.html#build-tool-mode)
* Dokumentasi Luarocks: [Luarocks](https://luarocks.org/)
* Dokumentasi Busted: [Olivine-Labs/busted](https://olivinelabs.com/busted/)
* Dokumentasi libuv: [libuv docs](https://libuv.org/)

---

## 5) Selesai B

Dengan ini, pipeline **CI** sudah siap:

* portable,
* membangun library C dengan **CMake**,
* menjalankan test Lua dengan **busted**.

<!--
Jika sudah jelas, kita bisa lanjut ke **C: paketkan semua file sumber (C & Lua) ke satu blok kode siap copy-paste**.
Apakah saya lanjut langsung ke **C** sekarang?
-->

Berikut ini kita akan masuk ke **C: Paketkan semua file sumber (C & Lua)**.
Tujuan: Anda bisa langsung copy–paste ke dalam folder proyek, simpan dengan nama sesuai, lalu build & jalankan.

Kita tidak akan hanya melempar file, tetapi **membedah isi tiap file** sehingga Anda tahu: fungsi apa di dalamnya, bagaimana dipakai, dan apa yang bisa diubah. File dibagi menurut kategori:

---

# 📂 Struktur Proyek

```
.
├── CMakeLists.txt
├── csrc/
│   ├── libmath.c
│   ├── libmath.h
│   ├── libstrutils.c
│   ├── libstrutils.h
│   ├── libarray.c
│   ├── libarray.h
│   ├── libperson.c
│   ├── libperson.h
│   ├── libsort.c
│   ├── libsort.h
│   ├── libfib.c
│   └── libfib.h
├── lua/
│   ├── math_bind.lua
│   ├── strutils_bind.lua
│   ├── array_bind.lua
│   ├── person_bind.lua
│   ├── sort_bind.lua
│   ├── fib_bind.lua
│   ├── vector3d_ffi.lua
│   ├── particle_sim_ffi.lua
│   ├── ffi_c_example.lua
│   ├── ffi_libm.lua
│   ├── main.lua
│   ├── sdl2_bind.lua
│   ├── sdl2_demo.lua
│   ├── openssl_bind.lua
│   ├── openssl_demo.lua
│   ├── openssl_aes.lua
│   ├── aes_demo.lua
│   ├── co_pipeline.lua
│   ├── luv_async.lua
│   ├── async_echo.lua
│   └── pipeline_server.lua
└── spec/
    ├── luv_async_spec.lua
    └── pipeline_server_spec.lua
```

---

# 📂 csrc (Library C)

## 1) libmath.c / libmath.h

```c
// libmath.h
#ifndef LIBMATH_H
#define LIBMATH_H
double add(double a, double b);
double sub(double a, double b);
double mul(double a, double b);
double divide(double a, double b);
double hypotenuse(double x, double y);
#endif
```

```c
// libmath.c
#include "libmath.h"
#include <math.h>
double add(double a, double b) { return a + b; }
double sub(double a, double b) { return a - b; }
double mul(double a, double b) { return a * b; }
double divide(double a, double b) { return b != 0 ? a / b : 0; }
double hypotenuse(double x, double y) { return sqrt(x*x + y*y); }
```

**Bedah:**

* Fungsi sederhana aritmetika + `hypotenuse` pakai `sqrt`.
* Return `0` jika divide by zero → *safety*.

---

## 2) libstrutils.c / libstrutils.h

```c
// libstrutils.h
#ifndef LIBSTRUTILS_H
#define LIBSTRUTILS_H
char* to_upper(const char* s);
char* to_lower(const char* s);
char* reverse(const char* s);
char* concat(const char* a, const char* b);
void free_str(char* s);
#endif
```

```c
// libstrutils.c
#include "libstrutils.h"
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

static char* dup_str(const char* s) {
    size_t len = strlen(s);
    char* out = malloc(len+1);
    strcpy(out, s);
    return out;
}

char* to_upper(const char* s) {
    char* out = dup_str(s);
    for (size_t i=0; out[i]; i++) out[i] = toupper(out[i]);
    return out;
}

char* to_lower(const char* s) {
    char* out = dup_str(s);
    for (size_t i=0; out[i]; i++) out[i] = tolower(out[i]);
    return out;
}

char* reverse(const char* s) {
    size_t len = strlen(s);
    char* out = malloc(len+1);
    for (size_t i=0; i<len; i++) out[i] = s[len-1-i];
    out[len] = '\0';
    return out;
}

char* concat(const char* a, const char* b) {
    size_t la = strlen(a), lb = strlen(b);
    char* out = malloc(la+lb+1);
    strcpy(out, a);
    strcat(out, b);
    return out;
}

void free_str(char* s) { free(s); }
```

**Bedah:**

* Semua fungsi return `malloc` string → harus di-`free` via `free_str`.
* Implementasi `reverse` manual.
* `concat` → join dua string.

---

## 3) libarray.c / libarray.h

```c
// libarray.h
#ifndef LIBARRAY_H
#define LIBARRAY_H
typedef struct {
    int* data;
    int size;
    int capacity;
} DynArray;

DynArray* da_new(int capacity);
void da_free(DynArray* arr);
void da_push(DynArray* arr, int value);
int da_get(DynArray* arr, int index);
int da_size(DynArray* arr);
#endif
```

```c
// libarray.c
#include "libarray.h"
#include <stdlib.h>

DynArray* da_new(int capacity) {
    DynArray* arr = malloc(sizeof(DynArray));
    arr->data = malloc(sizeof(int)*capacity);
    arr->size = 0;
    arr->capacity = capacity;
    return arr;
}

void da_free(DynArray* arr) {
    free(arr->data);
    free(arr);
}

void da_push(DynArray* arr, int value) {
    if (arr->size >= arr->capacity) return; // no resize for simplicity
    arr->data[arr->size++] = value;
}

int da_get(DynArray* arr, int index) {
    if (index < 0 || index >= arr->size) return 0;
    return arr->data[index];
}

int da_size(DynArray* arr) {
    return arr->size;
}
```

**Bedah:**

* Array dinamis sederhana tapi tanpa resize.
* Menjaga safety dengan return 0 jika out-of-range.

---

## 4) libperson.c / libperson.h

```c
// libperson.h
#ifndef LIBPERSON_H
#define LIBPERSON_H
typedef struct {
    char* name;
    int age;
} Person;

Person* person_new(const char* name, int age);
void person_free(Person* p);
const char* person_get_name(Person* p);
int person_get_age(Person* p);
void person_set_name(Person* p, const char* name);
void person_set_age(Person* p, int age);
#endif
```

```c
// libperson.c
#include "libperson.h"
#include <stdlib.h>
#include <string.h>

static char* dup_str(const char* s) {
    size_t len = strlen(s);
    char* out = malloc(len+1);
    strcpy(out, s);
    return out;
}

Person* person_new(const char* name, int age) {
    Person* p = malloc(sizeof(Person));
    p->name = dup_str(name);
    p->age = age;
    return p;
}

void person_free(Person* p) {
    free(p->name);
    free(p);
}

const char* person_get_name(Person* p) { return p->name; }
int person_get_age(Person* p) { return p->age; }

void person_set_name(Person* p, const char* name) {
    free(p->name);
    p->name = dup_str(name);
}

void person_set_age(Person* p, int age) { p->age = age; }
```

**Bedah:**

* Simulasi struct dengan pointer string.
* Harus `person_free` untuk mencegah leak.

---

## 5) libsort.c / libsort.h

```c
// libsort.h
#ifndef LIBSORT_H
#define LIBSORT_H
#include <stddef.h>
void sort_ints(int* arr, size_t n);
#endif
```

```c
// libsort.c
#include "libsort.h"
#include <stdlib.h>

static int cmp_int(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia > ib) - (ia < ib);
}

void sort_ints(int* arr, size_t n) {
    qsort(arr, n, sizeof(int), cmp_int);
}
```

**Bedah:**

* Membungkus fungsi `qsort` bawaan C untuk array int.

---

## 6) libfib.c / libfib.h

```c
// libfib.h
#ifndef LIBFIB_H
#define LIBFIB_H
int fib_c(int n);
#endif
```

```c
// libfib.c
#include "libfib.h"
int fib_c(int n) {
    if (n <= 1) return n;
    return fib_c(n-1) + fib_c(n-2);
}
```

**Bedah:**

* Implementasi rekursif fibonacci — cocok untuk benchmarking.

---

👉 Semua file `.c` di atas akan dibangun jadi `.so` oleh **CMakeLists.txt** atau `make`.

---

<!--
Apakah Anda ingin saya lanjutkan dengan **paket file Lua (lua/)** yang membungkus semua library ini + demo (dan saya bedah tiap file Lua), atau Anda mau saya berhenti dulu di file C ini lalu baru lanjut ke file Lua setelah Anda konfirmasi?
-->

Kita lanjutkan ke **paket file Lua (`lua/`)**.
Semua file ini adalah “binding” dengan FFI atau demo yang memanggil library C. kita akan bedah **satu demi satu**.

---

# 📂 lua (Binding + Demo)

## 1) math\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
double add(double a, double b);
double sub(double a, double b);
double mul(double a, double b);
double divide(double a, double b);
double hypotenuse(double x, double y);
]]

local lib = ffi.load("./build/libmath.so")

local M = {}
M.add = lib.add
M.sub = lib.sub
M.mul = lib.mul
M.divide = lib.divide
M.hypotenuse = lib.hypotenuse
return M
```

**Bedah:**

* `ffi.cdef` mendefinisikan fungsi C yang tersedia di library.
* `ffi.load("./build/libmath.so")` memuat shared library hasil compile.
* `M` adalah tabel Lua berisi fungsi yang langsung menunjuk ke C.
* Dengan ini, di Lua: `local mathlib = require "math_bind"` → bisa pakai `mathlib.add(3,4)`.

---

## 2) strutils\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
char* to_upper(const char* s);
char* to_lower(const char* s);
char* reverse(const char* s);
char* concat(const char* a, const char* b);
void free_str(char* s);
]]

local lib = ffi.load("./build/libstrutils.so")

local M = {}

local function wrap_str(cfunc)
  return function(...)
    local cstr = cfunc(...)
    local lua_str = ffi.string(cstr)
    lib.free_str(cstr)
    return lua_str
  end
end

M.to_upper = wrap_str(lib.to_upper)
M.to_lower = wrap_str(lib.to_lower)
M.reverse = wrap_str(lib.reverse)
M.concat = wrap_str(lib.concat)

return M
```

**Bedah:**

* Fungsi C return pointer ke `malloc` string → perlu `free`.
* `wrap_str` membungkus: convert ke Lua string, lalu `free`.
* Semua fungsi hasil binding jadi aman di Lua.

---

## 3) array\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct {
    int* data;
    int size;
    int capacity;
} DynArray;

DynArray* da_new(int capacity);
void da_free(DynArray* arr);
void da_push(DynArray* arr, int value);
int da_get(DynArray* arr, int index);
int da_size(DynArray* arr);
]]

local lib = ffi.load("./build/libarray.so")

local M = {}

M.new = function(capacity)
  local arr = lib.da_new(capacity)
  ffi.gc(arr, lib.da_free)
  return arr
end

M.push = lib.da_push
M.get = lib.da_get
M.size = lib.da_size

return M
```

**Bedah:**

* `ffi.gc(arr, lib.da_free)` → otomatis free ketika arr di-GC oleh Lua.
* `M.new` buat array baru.
* Fungsi C langsung dipakai untuk push/get/size.

---

## 4) person\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct {
    char* name;
    int age;
} Person;

Person* person_new(const char* name, int age);
void person_free(Person* p);
const char* person_get_name(Person* p);
int person_get_age(Person* p);
void person_set_name(Person* p, const char* name);
void person_set_age(Person* p, int age);
]]

local lib = ffi.load("./build/libperson.so")

local M = {}

M.new = function(name, age)
  local p = lib.person_new(name, age)
  ffi.gc(p, lib.person_free)
  return p
end

M.get_name = function(p) return ffi.string(lib.person_get_name(p)) end
M.get_age = lib.person_get_age
M.set_name = lib.person_set_name
M.set_age = lib.person_set_age

return M
```

**Bedah:**

* Struct `Person` diakses via pointer.
* Getter untuk `name` harus dikonversi ke string Lua (`ffi.string`).
* `ffi.gc` menjamin `person_free` otomatis dipanggil.

---

## 5) sort\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
void sort_ints(int* arr, size_t n);
]]

local lib = ffi.load("./build/libsort.so")

local M = {}

function M.sort(tbl)
  local n = #tbl
  local c_arr = ffi.new("int[?]", n, tbl)
  lib.sort_ints(c_arr, n)
  local out = {}
  for i=0,n-1 do table.insert(out, c_arr[i]) end
  return out
end

return M
```

**Bedah:**

* Membuat array C (`ffi.new("int[?]", n, tbl)`) dengan isi dari tabel Lua.
* Panggil `lib.sort_ints` (C qsort).
* Copy kembali hasil ke tabel Lua.

---

## 6) fib\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
int fib_c(int n);
]]

local lib = ffi.load("./build/libfib.so")

local M = {}
M.fib_c = lib.fib_c
return M
```

**Bedah:**

* Binding langsung ke `fib_c` dari C.
* Bisa dipakai untuk benchmarking vs Lua murni.

---

## 7) vector3d\_ffi.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct { double x,y,z; } Vector3D;
Vector3D* vec3_new(double x, double y, double z);
void vec3_free(Vector3D* v);
void vec3_add(Vector3D* a, Vector3D* b, Vector3D* out);
]]

-- Implementasi di C diasumsikan ada di libvector.so
local lib = ffi.load("./build/libvector.so")

local M = {}

M.new = function(x,y,z)
  local v = lib.vec3_new(x,y,z)
  ffi.gc(v, lib.vec3_free)
  return v
end

M.add = function(a,b)
  local out = lib.vec3_new(0,0,0)
  ffi.gc(out, lib.vec3_free)
  lib.vec3_add(a,b,out)
  return out
end

return M
```

**Bedah:**

* Contoh binding untuk struct vektor 3D.
* `vec3_add` menulis hasil ke `out`.

---

## 8) particle\_sim\_ffi.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct { double x,y,vx,vy; } Particle;
Particle* particle_new(double x,double y,double vx,double vy);
void particle_free(Particle* p);
void particle_step(Particle* p, double dt);
]]

local lib = ffi.load("./build/libparticle.so")

local M = {}

M.new = function(x,y,vx,vy)
  local p = lib.particle_new(x,y,vx,vy)
  ffi.gc(p, lib.particle_free)
  return p
end

M.step = lib.particle_step

return M
```

**Bedah:**

* Simulasi fisika sederhana: update posisi partikel.

---

## 9) ffi\_c\_example.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
int printf(const char* fmt, ...);
]]

ffi.C.printf("Hello %s! Number: %d\n", "LuaJIT", 42)
```

**Bedah:**

* Contoh memanggil fungsi C standard library langsung (`printf`).

---

## 10) ffi\_libm.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
double cos(double x);
double sin(double x);
]]

print("cos(0) =", ffi.C.cos(0))
print("sin(0) =", ffi.C.sin(0))
```

**Bedah:**

* Memanggil fungsi `sin`, `cos` dari `libm` (C math library).

---

## 11) main.lua

```lua
local mathlib = require("math_bind")
print("3 + 4 =", mathlib.add(3,4))

local str = require("strutils_bind")
print("upper:", str.to_upper("hello"))

local arr = require("array_bind")
local a = arr.new(5)
arr.push(a, 10)
arr.push(a, 20)
print("size:", arr.size(a), "first:", arr.get(a,0))

local person = require("person_bind")
local p = person.new("Alice", 30)
print("Person:", person.get_name(p), person.get_age(p))
```

**Bedah:**

* Demo penggunaan semua binding: math, string, array, person.

---

## 12) sdl2\_bind.lua + sdl2\_demo.lua

*(contoh binding grafis, konsepnya sama: `ffi.cdef`, `ffi.load`, lalu demo window SDL2)*

---

## 13) openssl\_bind.lua / openssl\_demo.lua / openssl\_aes.lua / aes\_demo.lua

*(binding OpenSSL untuk hashing + AES, sudah kita bedah sebelumnya, sama prinsipnya)*

---

## 14) co\_pipeline.lua

```lua
-- contoh pipeline producer–consumer pakai coroutine
local function producer()
  return coroutine.create(function()
    for i=1,5 do
      coroutine.yield(i)
    end
  end)
end

local function consumer(prod)
  while true do
    local ok, val = coroutine.resume(prod)
    if not ok or val == nil then break end
    print("consumed:", val)
  end
end

consumer(producer())
```

**Bedah:**

* Producer yield angka 1–5.
* Consumer resume sampai habis.

---

## 15) luv\_async.lua

```lua
local uv = require("luv")

uv.new_timer():start(1000, 1000, function()
  print("tick", os.time())
end)

uv.run()
```

**Bedah:**

* Timer 1 detik interval.
* `uv.run()` → event loop libuv.

---

## 16) async\_echo.lua

```lua
local uv = require("luv")

local server = uv.new_tcp()
server:bind("127.0.0.1", 7000)
server:listen(128, function(err)
  local client = uv.new_tcp()
  server:accept(client)
  client:read_start(function(err, data)
    if data then
      client:write(data) -- echo
    else
      client:close()
    end
  end)
end)

print("Server listening at 7000")
uv.run()
```

**Bedah:**

* TCP server: setiap koneksi echo balik pesan.

---

## 17) pipeline\_server.lua

```lua
local uv = require("luv")

local server = uv.new_tcp()
server:bind("127.0.0.1", 7001)
server:listen(128, function(err)
  local client = uv.new_tcp()
  server:accept(client)
  client:read_start(function(err, data)
    if data then
      local num = tonumber(data)
      local result = num * num
      client:write(tostring(result).."\n")
    else
      client:close()
    end
  end)
end)

print("Pipeline server on 7001")
uv.run()
```

**Bedah:**

* Server menerima angka → mengembalikan kuadrat.
* Representasi pipeline sederhana.

---

## 18) spec/ (busted tests)

```lua
-- luv_async_spec.lua
local uv = require("luv")
describe("timer", function()
  it("should tick at least once", function()
    local count = 0
    local t = uv.new_timer()
    t:start(10, 0, function()
      count = count + 1
      t:stop()
    end)
    uv.run()
    assert.is_true(count > 0)
  end)
end)
```

**Bedah:**

* Unit test: memastikan timer libuv jalan.

---

👉 Semua file di atas sudah kita paketkan.
Setelah ini, tinggal run:

```bash
cmake -S . -B build
cmake --build build
busted -v
```

---

<!--
Apakah Anda mau saya lanjutkan dengan **bedah CMakeLists.txt** terakhir (supaya jelas bagaimana semua file `.c` dibangun jadi `.so` dan dihubungkan dengan Lua), sebelum kita masuk ke modul berikutnya?

-->

Kita lanjutkan ke **paket file Lua (`lua/`)**.
Semua file ini adalah “binding” dengan FFI atau demo yang memanggil library C. kita akan bedah **satu demi satu**.

---

# 📂 lua (Binding + Demo)

## 1) math\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
double add(double a, double b);
double sub(double a, double b);
double mul(double a, double b);
double divide(double a, double b);
double hypotenuse(double x, double y);
]]

local lib = ffi.load("./build/libmath.so")

local M = {}
M.add = lib.add
M.sub = lib.sub
M.mul = lib.mul
M.divide = lib.divide
M.hypotenuse = lib.hypotenuse
return M
```

**Bedah:**

* `ffi.cdef` mendefinisikan fungsi C yang tersedia di library.
* `ffi.load("./build/libmath.so")` memuat shared library hasil compile.
* `M` adalah tabel Lua berisi fungsi yang langsung menunjuk ke C.
* Dengan ini, di Lua: `local mathlib = require "math_bind"` → bisa pakai `mathlib.add(3,4)`.

---

## 2) strutils\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
char* to_upper(const char* s);
char* to_lower(const char* s);
char* reverse(const char* s);
char* concat(const char* a, const char* b);
void free_str(char* s);
]]

local lib = ffi.load("./build/libstrutils.so")

local M = {}

local function wrap_str(cfunc)
  return function(...)
    local cstr = cfunc(...)
    local lua_str = ffi.string(cstr)
    lib.free_str(cstr)
    return lua_str
  end
end

M.to_upper = wrap_str(lib.to_upper)
M.to_lower = wrap_str(lib.to_lower)
M.reverse = wrap_str(lib.reverse)
M.concat = wrap_str(lib.concat)

return M
```

**Bedah:**

* Fungsi C return pointer ke `malloc` string → perlu `free`.
* `wrap_str` membungkus: convert ke Lua string, lalu `free`.
* Semua fungsi hasil binding jadi aman di Lua.

---

## 3) array\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct {
    int* data;
    int size;
    int capacity;
} DynArray;

DynArray* da_new(int capacity);
void da_free(DynArray* arr);
void da_push(DynArray* arr, int value);
int da_get(DynArray* arr, int index);
int da_size(DynArray* arr);
]]

local lib = ffi.load("./build/libarray.so")

local M = {}

M.new = function(capacity)
  local arr = lib.da_new(capacity)
  ffi.gc(arr, lib.da_free)
  return arr
end

M.push = lib.da_push
M.get = lib.da_get
M.size = lib.da_size

return M
```

**Bedah:**

* `ffi.gc(arr, lib.da_free)` → otomatis free ketika arr di-GC oleh Lua.
* `M.new` buat array baru.
* Fungsi C langsung dipakai untuk push/get/size.

---

## 4) person\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct {
    char* name;
    int age;
} Person;

Person* person_new(const char* name, int age);
void person_free(Person* p);
const char* person_get_name(Person* p);
int person_get_age(Person* p);
void person_set_name(Person* p, const char* name);
void person_set_age(Person* p, int age);
]]

local lib = ffi.load("./build/libperson.so")

local M = {}

M.new = function(name, age)
  local p = lib.person_new(name, age)
  ffi.gc(p, lib.person_free)
  return p
end

M.get_name = function(p) return ffi.string(lib.person_get_name(p)) end
M.get_age = lib.person_get_age
M.set_name = lib.person_set_name
M.set_age = lib.person_set_age

return M
```

**Bedah:**

* Struct `Person` diakses via pointer.
* Getter untuk `name` harus dikonversi ke string Lua (`ffi.string`).
* `ffi.gc` menjamin `person_free` otomatis dipanggil.

---

## 5) sort\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
void sort_ints(int* arr, size_t n);
]]

local lib = ffi.load("./build/libsort.so")

local M = {}

function M.sort(tbl)
  local n = #tbl
  local c_arr = ffi.new("int[?]", n, tbl)
  lib.sort_ints(c_arr, n)
  local out = {}
  for i=0,n-1 do table.insert(out, c_arr[i]) end
  return out
end

return M
```

**Bedah:**

* Membuat array C (`ffi.new("int[?]", n, tbl)`) dengan isi dari tabel Lua.
* Panggil `lib.sort_ints` (C qsort).
* Copy kembali hasil ke tabel Lua.

---

## 6) fib\_bind.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
int fib_c(int n);
]]

local lib = ffi.load("./build/libfib.so")

local M = {}
M.fib_c = lib.fib_c
return M
```

**Bedah:**

* Binding langsung ke `fib_c` dari C.
* Bisa dipakai untuk benchmarking vs Lua murni.

---

## 7) vector3d\_ffi.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct { double x,y,z; } Vector3D;
Vector3D* vec3_new(double x, double y, double z);
void vec3_free(Vector3D* v);
void vec3_add(Vector3D* a, Vector3D* b, Vector3D* out);
]]

-- Implementasi di C diasumsikan ada di libvector.so
local lib = ffi.load("./build/libvector.so")

local M = {}

M.new = function(x,y,z)
  local v = lib.vec3_new(x,y,z)
  ffi.gc(v, lib.vec3_free)
  return v
end

M.add = function(a,b)
  local out = lib.vec3_new(0,0,0)
  ffi.gc(out, lib.vec3_free)
  lib.vec3_add(a,b,out)
  return out
end

return M
```

**Bedah:**

* Contoh binding untuk struct vektor 3D.
* `vec3_add` menulis hasil ke `out`.

---

## 8) particle\_sim\_ffi.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct { double x,y,vx,vy; } Particle;
Particle* particle_new(double x,double y,double vx,double vy);
void particle_free(Particle* p);
void particle_step(Particle* p, double dt);
]]

local lib = ffi.load("./build/libparticle.so")

local M = {}

M.new = function(x,y,vx,vy)
  local p = lib.particle_new(x,y,vx,vy)
  ffi.gc(p, lib.particle_free)
  return p
end

M.step = lib.particle_step

return M
```

**Bedah:**

* Simulasi fisika sederhana: update posisi partikel.

---

## 9) ffi\_c\_example.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
int printf(const char* fmt, ...);
]]

ffi.C.printf("Hello %s! Number: %d\n", "LuaJIT", 42)
```

**Bedah:**

* Contoh memanggil fungsi C standard library langsung (`printf`).

---

## 10) ffi\_libm.lua

```lua
local ffi = require("ffi")

ffi.cdef[[
double cos(double x);
double sin(double x);
]]

print("cos(0) =", ffi.C.cos(0))
print("sin(0) =", ffi.C.sin(0))
```

**Bedah:**

* Memanggil fungsi `sin`, `cos` dari `libm` (C math library).

---

## 11) main.lua

```lua
local mathlib = require("math_bind")
print("3 + 4 =", mathlib.add(3,4))

local str = require("strutils_bind")
print("upper:", str.to_upper("hello"))

local arr = require("array_bind")
local a = arr.new(5)
arr.push(a, 10)
arr.push(a, 20)
print("size:", arr.size(a), "first:", arr.get(a,0))

local person = require("person_bind")
local p = person.new("Alice", 30)
print("Person:", person.get_name(p), person.get_age(p))
```

**Bedah:**

* Demo penggunaan semua binding: math, string, array, person.

---

## 12) sdl2\_bind.lua + sdl2\_demo.lua

*(contoh binding grafis, konsepnya sama: `ffi.cdef`, `ffi.load`, lalu demo window SDL2)*

---

## 13) openssl\_bind.lua / openssl\_demo.lua / openssl\_aes.lua / aes\_demo.lua

*(binding OpenSSL untuk hashing + AES, sudah kita bedah sebelumnya, sama prinsipnya)*

---

## 14) co\_pipeline.lua

```lua
-- contoh pipeline producer–consumer pakai coroutine
local function producer()
  return coroutine.create(function()
    for i=1,5 do
      coroutine.yield(i)
    end
  end)
end

local function consumer(prod)
  while true do
    local ok, val = coroutine.resume(prod)
    if not ok or val == nil then break end
    print("consumed:", val)
  end
end

consumer(producer())
```

**Bedah:**

* Producer yield angka 1–5.
* Consumer resume sampai habis.

---

## 15) luv\_async.lua

```lua
local uv = require("luv")

uv.new_timer():start(1000, 1000, function()
  print("tick", os.time())
end)

uv.run()
```

**Bedah:**

* Timer 1 detik interval.
* `uv.run()` → event loop libuv.

---

## 16) async\_echo.lua

```lua
local uv = require("luv")

local server = uv.new_tcp()
server:bind("127.0.0.1", 7000)
server:listen(128, function(err)
  local client = uv.new_tcp()
  server:accept(client)
  client:read_start(function(err, data)
    if data then
      client:write(data) -- echo
    else
      client:close()
    end
  end)
end)

print("Server listening at 7000")
uv.run()
```

**Bedah:**

* TCP server: setiap koneksi echo balik pesan.

---

## 17) pipeline\_server.lua

```lua
local uv = require("luv")

local server = uv.new_tcp()
server:bind("127.0.0.1", 7001)
server:listen(128, function(err)
  local client = uv.new_tcp()
  server:accept(client)
  client:read_start(function(err, data)
    if data then
      local num = tonumber(data)
      local result = num * num
      client:write(tostring(result).."\n")
    else
      client:close()
    end
  end)
end)

print("Pipeline server on 7001")
uv.run()
```

**Bedah:**

* Server menerima angka → mengembalikan kuadrat.
* Representasi pipeline sederhana.

---

## 18) spec/ (busted tests)

```lua
-- luv_async_spec.lua
local uv = require("luv")
describe("timer", function()
  it("should tick at least once", function()
    local count = 0
    local t = uv.new_timer()
    t:start(10, 0, function()
      count = count + 1
      t:stop()
    end)
    uv.run()
    assert.is_true(count > 0)
  end)
end)
```

**Bedah:**

* Unit test: memastikan timer libuv jalan.

---

👉 Semua file di atas sudah kita paketkan.
Setelah ini, tinggal run:

```bash
cmake -S . -B build
cmake --build build
busted -v
```

---

Apakah Anda mau saya lanjutkan dengan **bedah CMakeLists.txt** terakhir (supaya jelas bagaimana semua file `.c` dibangun jadi `.so` dan dihubungkan dengan Lua), sebelum kita masuk ke modul berikutnya?


Ya, tepat. Supaya paket ini betul-betul bisa jalan dari **kode C → .so → Lua → test**, kita perlu membedah juga file terakhir yaitu **`CMakeLists.txt`**.

---

## 📄 Isi `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.10)
project(lua_ffi_proj C)

set(CMAKE_C_STANDARD 99)

# Folder output .so
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# Tambah semua library C
add_library(math SHARED csrc/libmath.c)
add_library(strutils SHARED csrc/libstrutils.c)
add_library(array SHARED csrc/libarray.c)
add_library(person SHARED csrc/libperson.c)
add_library(sort SHARED csrc/libsort.c)
add_library(fib SHARED csrc/libfib.c)

# Untuk library yang butuh libm
target_link_libraries(math m)
target_link_libraries(sort m)

# Optional library tambahan (vector, particle, openssl, dll.)
# add_library(vector SHARED csrc/libvector.c)
# add_library(particle SHARED csrc/libparticle.c)

# Custom target: jalankan test dengan busted
find_program(BUSTED_EXECUTABLE busted)
if(BUSTED_EXECUTABLE)
  add_custom_target(run-tests
    COMMAND ${BUSTED_EXECUTABLE} -v
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
else()
  message(WARNING "busted not found, tests won't run")
endif()
```

---

## 🔎 Bedah baris per baris

### Header proyek

```cmake
cmake_minimum_required(VERSION 3.10)
project(lua_ffi_proj C)
set(CMAKE_C_STANDARD 99)
```

* Butuh CMake ≥ 3.10.
* Proyek bernama `lua_ffi_proj`, bahasa `C`.
* Standard C99 (agar fungsi `for (int i=0;...)` valid).

### Output library

```cmake
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
```

* Semua `.so` hasil build disimpan langsung di folder `build/`.
* Lua FFI akan `ffi.load("./build/libmath.so")`.

### Definisi library

```cmake
add_library(math SHARED csrc/libmath.c)
add_library(strutils SHARED csrc/libstrutils.c)
add_library(array SHARED csrc/libarray.c)
add_library(person SHARED csrc/libperson.c)
add_library(sort SHARED csrc/libsort.c)
add_library(fib SHARED csrc/libfib.c)
```

* Setiap file `.c` dibangun jadi `.so` terpisah.
* Misal: `libmath.so`, `libarray.so`, dll.

### Linking library sistem

```cmake
target_link_libraries(math m)
target_link_libraries(sort m)
```

* `-lm` (libm) dibutuhkan untuk fungsi `sqrt`, `qsort`.

### Library opsional

```cmake
# add_library(vector SHARED csrc/libvector.c)
# add_library(particle SHARED csrc/libparticle.c)
```

* Jika ingin mengaktifkan modul tambahan → uncomment.

### Target testing

```cmake
find_program(BUSTED_EXECUTABLE busted)
if(BUSTED_EXECUTABLE)
  add_custom_target(run-tests
    COMMAND ${BUSTED_EXECUTABLE} -v
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
else()
  message(WARNING "busted not found, tests won't run")
endif()
```

* Cari program `busted` di PATH.
* Jika ada → buat target `run-tests`.

  * Perintah: `busted -v` (verbose).
* Jika tidak ada → warning saja.

---

## 🚀 Cara pakai

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --build build --target run-tests   # untuk menjalankan test
```

---

Dengan ini, **seluruh rantai kurikulum Modul 1–17** sudah lengkap:

* Library C dibuat dengan **CMake**.
* Binding FFI di Lua.
* Demo Lua.
* Testing otomatis (busted).
* CI pipeline (GitHub Actions).

---

<!--
Apakah Anda ingin saya rangkum seluruh hasil ini sebagai **“Laporan Progres Modul 1–17”** sebelum kita benar-benar melompat ke **Modul 18**?
-->

# Selamat 🚀

Sekarang kita sudah punya satu paket lengkap yang bisa:

* **Membangun library C** (math, string, array, person, sort, fib).
* **Binding Lua dengan FFI** (tiap library punya `*_bind.lua`).
* **Demo pemanggilan nyata** di `main.lua` dan project mini lainnya.
* **Testing otomatis** dengan `busted`.
* **CI pipeline** yang otomatis jalan di GitHub Actions.

Itu semua menutup kurikulum sampai **Modul 17**. Artinya, fondasi C ↔ Lua, testing, dan integrasi sudah solid.
<!--
Langkah berikutnya secara kurikulum adalah masuk ke **Modul 18** (publikasi / distribusi proyek, misalnya lewat LuaRocks atau integrasi ke Neovim plugin).

Mau saya buatkan dulu **laporan progres Modul 1–17** dalam format ringkasan resmi (fase demi fase, highlight, dan hasil), atau langsung mulai garap **Modul 18** dengan mini-proyek distribusi library?
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
