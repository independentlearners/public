# **[Modul 4: Database Integration][0]**

Modul ini sangat krusial karena hampir semua aplikasi web dinamis memerlukan interaksi dengan database untuk menyimpan dan mengambil data. Di dunia OpenResty, cara kita berinteraksi dengan database harus selaras dengan filosofi non-blocking untuk menjaga performa tetap maksimal.

**Tujuan Modul:** Memahami cara menghubungkan aplikasi OpenResty dengan berbagai jenis database (SQL dan NoSQL) secara efisien dan non-blocking, serta cara mengelola data yang diterima.




#### **4.1 SQL Database Integration (MySQL & PostgreSQL)**

**Deskripsi Konkret:**
Untuk berinteraksi dengan database relasional seperti MySQL atau PostgreSQL dari dalam OpenResty, Anda tidak bisa menggunakan library standar yang bersifat blocking. Anda harus menggunakan library yang dirancang khusus untuk API Cosocket OpenResty. Library yang paling populer dan sudah teruji adalah `lua-resty-mysql` dan `lua-resty-postgres`. Library ini memastikan bahwa setiap kali aplikasi Anda menunggu jawaban dari database, worker NGINX tidak akan berhenti, melainkan akan melayani request lain.

**Konsep Kunci: Connection Pooling**
Ini adalah konsep paling vital saat bekerja dengan database di lingkungan berperforma tinggi.

- **Masalah:** Membuka koneksi baru ke database untuk setiap request adalah operasi yang sangat lambat dan memakan banyak sumber daya (baik di server aplikasi maupun di server database). Jika ada 1000 request per detik, membuat 1000 koneksi baru akan menghancurkan performa.
- **Solusi:** _Connection Pooling_. Bayangkan Anda memiliki sejumlah "jalur koneksi" yang sudah terbuka dan siap pakai, disimpan dalam sebuah "pool" (kolam). Setiap kali sebuah request butuh akses database:
  1.  Ia "meminjam" satu koneksi dari pool.
  2.  Ia menggunakan koneksi tersebut untuk mengirim query dan menerima hasil.
  3.  Setelah selesai, ia **mengembalikan** koneksi tersebut ke pool, sehingga bisa digunakan oleh request lain.
- **Implementasi di OpenResty:** Library seperti `lua-resty-mysql` mengelola ini untuk Anda melalui fungsi `db:set_keepalive()`. Panggilan ini secara cerdas menempatkan koneksi yang telah digunakan kembali ke dalam pool yang terikat dengan worker NGINX saat ini.

**Terminologi Kunci:**

- **ORM (Object-Relational Mapping):** Sebuah teknik untuk mengonversi data antara sistem yang tidak kompatibel. Dalam kasus ini, dari tabel relasional (baris dan kolom) di database menjadi Lua table (yang bisa dianggap sebagai objek). Walaupun ada library ORM untuk Lua, dalam praktik OpenResty, developer sering kali melakukan pemetaan manual yang sederhana untuk menjaga performa dan kontrol.

**Contoh Sintaks (`lua-resty-mysql`):**
Berikut adalah contoh lengkap dalam sebuah `location` block yang mengambil data produk dari MySQL.

```nginx
# nginx.conf
http {
    server {
        listen 8080;

        location /products {
            default_type 'application/json; charset=utf-8';

            content_by_lua_block {
                -- 1. Load library yang dibutuhkan
                local mysql = require "resty.mysql"
                local cjson = require "cjson"

                -- 2. Buat instance objek database
                local db, err = mysql:new()
                if not db then
                    ngx.log(ngx.ERR, "Gagal membuat instance mysql: ", err)
                    ngx.exit(500)
                end

                -- 3. Atur timeout koneksi (dalam milidetik)
                db:set_timeout(1000) -- 1 detik

                -- 4. Definisikan detail koneksi
                local ok, err = db:connect{
                    host = "127.0.0.1",
                    port = 3306,
                    database = "toko_online",
                    user = "user_app",
                    password = "password_rahasia",
                    charset = "utf8"
                }

                if not ok then
                    ngx.log(ngx.ERR, "Gagal konek ke mysql: ", err)
                    ngx.exit(500)
                end

                -- 5. Jalankan query (ini adalah operasi non-blocking)
                local sql_query = "SELECT id, nama_produk, harga FROM produk WHERE id = ?"
                local res, err = db:query(sql_query, { 123 }) -- Gunakan placeholder '?' untuk keamanan (mencegah SQL Injection)

                if not res then
                    ngx.log(ngx.ERR, "Gagal menjalankan query: ", err)
                    ngx.exit(500)
                end

                -- 6. PENTING: Kembalikan koneksi ke pool agar bisa dipakai lagi
                local ok, err = db:set_keepalive(10000, 100) -- idle timeout 10s, pool size 100
                if not ok then
                    ngx.log(ngx.WARN, "Gagal mengembalikan koneksi ke pool: ", err)
                end

                -- 7. Proses hasil dan kirim sebagai JSON
                -- Hasil dari query adalah Lua table (array dari baris)
                ngx.say(cjson.encode(res))
            }
        }
    }
}
```

**Sumber Referensi:**

- Tutorial Pengembangan Web App dengan Lua dan OpenResty: [Spaceship Earth OpenResty Tutorial](https://ketzacoatl.github.io/posts/2017-03-02-intro-to-webapp-dev-with-lua-and-openresty.html)



#### **4.2 NoSQL Database Integration**

**Deskripsi Konkret:**
Selain database SQL, aplikasi modern seringkali bergantung pada database NoSQL untuk berbagai keperluan. Tipe yang paling umum digunakan bersama OpenResty adalah **Key-Value Store** seperti **Redis**. Redis sangat cepat karena menyimpan data di dalam memori (RAM), membuatnya ideal untuk:

- **Caching:** Menyimpan hasil query database yang mahal atau response API.
- **Session Management:** Menyimpan data sesi pengguna.
- **Rate Limiting:** Menghitung jumlah request dari seorang pengguna.
- **Real-time Analytics:** Menggunakan struktur data seperti counter dan sorted sets.

Seperti halnya SQL, interaksi dengan Redis harus menggunakan library berbasis Cosocket, yaitu `lua-resty-redis`.

**Konsep Kunci: Caching Strategies with Multiple Backends**
Ini adalah pola arsitektur yang sangat umum dan kuat.

1.  **Request Masuk:** Aplikasi butuh data (misalnya, profil pengguna).
2.  **Cek Cache (Redis) Dahulu:** Aplikasi pertama-tama mencoba mengambil data dari Redis (yang super cepat).
3.  **Cache Hit:** Jika data ditemukan di Redis (_cache hit_), data tersebut langsung dikembalikan ke pengguna. Selesai.
4.  **Cache Miss:** Jika data tidak ditemukan di Redis (_cache miss_), aplikasi akan melanjutkan untuk mengambil data dari sumber utama yang lebih lambat, yaitu database SQL (_backend_).
5.  **Populate Cache:** Setelah data didapat dari SQL, aplikasi akan menyimpannya di Redis dengan waktu kedaluwarsa (TTL - Time To Live).
6.  **Kembalikan Data:** Data dari SQL dikembalikan ke pengguna.

Pada request berikutnya untuk data yang sama, akan terjadi _cache hit_, dan aplikasi tidak perlu lagi menyentuh database SQL yang lambat.

**Contoh Sintaks (Pola Cache-Aside dengan Redis dan MySQL):**

```lua
-- Anggap kode ini ada di dalam `content_by_lua_block`
local redis = require "resty.redis"
local cjson = require "cjson"

local function get_user_from_db(user_id)
    -- Ini adalah fungsi untuk mengambil data dari MySQL (seperti contoh di 4.1)
    -- ... logika koneksi dan query ke MySQL ...
    ngx.log(ngx.INFO, "CACHE MISS. Mengambil user ", user_id, " dari database.")
    -- Mengembalikan data user sebagai Lua table
    return { id = user_id, name = "Pengguna dari DB", email = "test@example.com" }
end

-- --- Logika Utama ---

local user_id = 123
local cache_key = "user:" .. user_id

-- 1. Konek ke Redis
local red, err = redis:new()
-- ... (error handling dan koneksi seperti contoh sebelumnya) ...
red:connect("127.0.0.1", 6379)

-- 2. Coba ambil dari Redis
local cached_user_json, err = red:get(cache_key)

if not cached_user_json then
    ngx.log(ngx.WARN, "Gagal menghubungi Redis: ", err)
end

-- 3. Cek apakah ada di cache (Cache Hit)
if cached_user_json and cached_user_json ~= ngx.null then
    ngx.log(ngx.INFO, "CACHE HIT. Mengambil user ", user_id, " dari Redis.")
    ngx.say(cached_user_json)
    red:set_keepalive(10000, 100) -- Jangan lupa kembalikan koneksi
    return
end

-- 4. Jika tidak ada (Cache Miss), ambil dari DB
local user_data = get_user_from_db(user_id)
local user_data_json = cjson.encode(user_data)

-- 5. Simpan ke Redis untuk request selanjutnya (Populate Cache)
-- 'EX' artinya expiration dalam detik
red:set(cache_key, user_data_json, "EX", 300) -- Cache selama 5 menit

-- 6. Kembalikan koneksi Redis ke pool
red:set_keepalive(10000, 100)

-- 7. Kirim data ke client
ngx.say(user_data_json)
```

**Sumber Referensi:**

- Kumpulan Library untuk OpenResty (termasuk banyak driver database): [Awesome Resty - Database Libraries](https://github.com/bungle/awesome-resty#database)



#### **4.3 Data Serialization dan Validation**

**Deskripsi Konkret:**

- **Serialization (Serialisasi):** Adalah proses mengubah struktur data di memori (seperti Lua table) menjadi format string atau byte stream agar bisa dikirim melalui jaringan atau disimpan ke file/database. Format yang paling umum untuk API web adalah **JSON (JavaScript Object Notation)**.
- **Validation (Validasi):** Adalah proses memeriksa data yang masuk (misalnya, dari body request POST atau parameter URL) untuk memastikan data tersebut aman dan sesuai dengan format yang diharapkan sebelum diproses lebih lanjut. Ini adalah langkah keamanan yang fundamental untuk mencegah error dan serangan.

**Terminologi Kunci:**

- **JSON Encoding:** Mengubah Lua table menjadi string JSON.
- **JSON Decoding:** Mengubah string JSON menjadi Lua table.
- **Schema Validation:** Memvalidasi data berdasarkan "skema" atau aturan yang telah ditentukan (misalnya, field `email` harus berupa string dan berformat email, field `age` harus berupa angka).

**Contoh Sintaks (`lua-cjson` dan Validasi Manual):**
OpenResty dibundel dengan `lua-cjson`, sebuah library JSON yang sangat cepat karena ditulis dalam bahasa C.

```lua
-- Anggap kode ini ada di dalam `content_by_lua_block`
local cjson = require "cjson"

-- ### Bagian 1: SERIALIZATION (Encoding) ###
local my_data = {
    user_id = 456,
    product = "OpenResty Guide",
    tags = {"web", "performance", "lua"},
    is_active = true
}

-- Mengubah Lua table menjadi string JSON
local json_string = cjson.encode(my_data)

ngx.header.content_type = "application/json"
-- ngx.say(json_string) akan menghasilkan:
-- {"user_id":456,"product":"OpenResty Guide","tags":["web","performance","lua"],"is_active":true}


-- ### Bagian 2: VALIDATION dan DESERIALIZATION (Decoding) ###

-- Misalkan kita menerima JSON berikut dari request POST
-- ngx.req.read_body()
-- local body = ngx.req.get_body_data()
local incoming_json = '{"name": "Budi", "age": "dua puluh lima"}' -- age sengaja dibuat salah tipe datanya

-- Gunakan pcall untuk menangkap error jika JSON tidak valid
local ok, decoded_data = pcall(cjson.decode, incoming_json)

if not ok then
    ngx.status = 400 -- Bad Request
    ngx.say('{"error": "JSON tidak valid"}')
    return
end

-- Lakukan validasi skema secara manual
if not decoded_data.name or type(decoded_data.name) ~= "string" then
    ngx.status = 400
    ngx.say('{"error": "Field `name` wajib ada dan harus string"}')
    return
end

if not decoded_data.age or type(decoded_data.age) ~= "number" then
    ngx.status = 400
    -- Output: Field `age` wajib ada dan harus angka
    ngx.say('{"error": "Field `age` wajib ada dan harus angka"}')
    return
end

-- Jika semua validasi lolos, lanjutkan proses...
ngx.say('{"message": "Data valid diterima", "data": '.. cjson.encode(decoded_data) ..'}')
```

**Sumber Referensi:**

- Dokumentasi `lua-cjson`: [lua-cjson Documentation on GitHub](https://github.com/mpx/lua-cjson)

---

Modul 4 ini memberikan Anda fondasi yang kuat untuk membangun aplikasi yang digerakkan oleh data. Kunci utamanya adalah selalu berpikir **non-blocking** dan memanfaatkan **connection pooling** untuk efisiensi, serta tidak pernah melupakan **validasi** sebagai garda terdepan keamanan aplikasi Anda.

Mari kita lanjutkan ke **Modul 5: Web API Development** di mana kita akan menggunakan semua yang telah kita pelajari untuk membangun sebuah API yang sesungguhnya.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
