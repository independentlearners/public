# **[Modul 5: Web API Development][0]**

Ini adalah tahap di mana kita menggabungkan semua pengetahuan dari modul-modul sebelumnya (konfigurasi NGINX, scripting Lua, koneksi database, caching) untuk membangun sebuah layanan yang fungsional dan dapat dikonsumsi oleh aplikasi lain (seperti front-end web atau aplikasi mobile).

**Tujuan Modul:** Mampu merancang, mengimplementasikan, dan mengamankan RESTful API yang kuat dan berperforma tinggi menggunakan OpenResty.

#### **5.1 RESTful API Design dan Implementation**

**Deskripsi Konkret:**
Membangun sebuah RESTful API adalah tentang mendesain "antarmuka" atau "kontrak" yang logis dan dapat diprediksi bagi para client untuk berinteraksi dengan data (sumber daya) Anda. Daripada membuat URL acak seperti `/ambilDataUser` atau `/simpanProdukBaru`, kita mengikuti seperangkat konvensi yang memanfaatkan kekuatan protokol HTTP itu sendiri.

**Konsep Kunci: Prinsip-prinsip REST**

- **Resources (Sumber Daya):** Segalanya adalah sumber daya. Seorang pengguna adalah sumber daya. Sebuah produk adalah sumber daya. Setiap sumber daya diidentifikasi oleh URI (Uniform Resource Identifier) yang unik.
  - `api/v1/users` -\> merepresentasikan semua pengguna.
  - `api/v1/users/123` -\> merepresentasikan satu pengguna dengan ID 123.
- **HTTP Methods (Verbs):** Kita menggunakan kata kerja (verb) HTTP standar untuk memanipulasi sumber daya ini. Ini disebut _semantic methods_.
  - `GET`: Membaca sumber daya. (`GET /users/123` -\> ambil data user 123).
  - `POST`: Membuat sumber daya baru. (`POST /users` dengan data di body -\> buat user baru).
  - `PUT`: Memperbarui sumber daya secara keseluruhan. (`PUT /users/123` dengan data lengkap -\> ganti data user 123).
  - `PATCH`: Memperbarui sebagian dari sumber daya. (`PATCH /users/123` dengan `{ "email": "baru@mail.com" }` -\> hanya ubah email).
  - `DELETE`: Menghapus sumber daya. (`DELETE /users/123` -\> hapus user 123).
- **HTTP Status Codes:** Server harus memberikan respon dengan kode status yang sesuai untuk memberitahu client hasil dari operasinya.
  - `200 OK`: Sukses untuk `GET`.
  - `201 Created`: Sukses membuat sumber daya baru (`POST`).
  - `204 No Content`: Sukses tetapi tidak ada data untuk dikembalikan (umum untuk `DELETE` atau `PUT`).
  - `400 Bad Request`: Request dari client tidak valid (misal: JSON rusak, data kurang).
  - `401 Unauthorized`: Client belum terautentikasi.
  - `403 Forbidden`: Client terautentikasi tetapi tidak punya izin.
  - `404 Not Found`: Sumber daya yang diminta tidak ada.
  - `500 Internal Server Error`: Terjadi kesalahan di sisi server.

**Implementasi: Route Handling (Penanganan Rute)**
Di OpenResty, kita bisa membuat sebuah "router" sederhana menggunakan `location` block dengan regular expression (regex) dan sedikit logika Lua.

**Contoh Sintaks (Router Sederhana untuk API Produk):**

```nginx
# nginx.conf
http {
    # Lua code cache harus 'on' di produksi untuk performa
    lua_code_cache on;

    server {
        listen 8080;

        # Regex untuk menangkap /api/v1/products dan /api/v1/products/ID
        # (?:/(\d+))? artinya: grup opsional yang diawali '/' diikuti satu atau lebih digit (\d+)
        # Angka ID akan ditangkap dan tersedia di variabel $1 (atau ngx.var[1] di Lua)
        location ~ ^/api/v1/products(?:/(\d+))?$ {
            default_type 'application/json';

            content_by_lua_block {
                -- Muat file router eksternal kita (praktik terbaik)
                local router = require "app.router.product"

                -- Ambil ID dari URL jika ada
                local product_id = ngx.var[1]

                -- Panggil fungsi handler berdasarkan metode HTTP
                if ngx.req.get_method() == "GET" then
                    if product_id then
                        router.get_by_id(product_id)
                    else
                        router.get_all()
                    end
                elseif ngx.req.get_method() == "POST" then
                    router.create()
                elseif ngx.req.get_method() == "PUT" then
                    router.update(product_id)
                elseif ngx.req.get_method() == "DELETE" then
                    router.delete(product_id)
                else
                    ngx.status = 405 -- Method Not Allowed
                    ngx.say('{"error": "Method not allowed"}')
                end
            }
        }
    }
}
```

**File `app/router/product.lua`:**

```lua
local cjson = require "cjson"

-- Modul untuk logika bisnis produk (koneksi DB, dll)
-- local product_service = require "app.service.product"

local _M = {}

function _M.get_by_id(id)
    -- panggil product_service.find(id)
    ngx.say(cjson.encode({ message = "Mengambil produk dengan ID " .. id }))
end

function _M.get_all()
    ngx.say(cjson.encode({ message = "Mengambil semua produk" }))
end

function _M.create()
    ngx.req.read_body()
    local body_data = ngx.req.get_body_data()
    -- Lakukan validasi dan panggil product_service.create(body_data)
    ngx.status = 201
    ngx.say(cjson.encode({ message = "Produk baru dibuat", data = body_data }))
end

-- ... fungsi update dan delete ...

return _M
```

**Sumber Referensi:**

- Artikel tentang membuat API dengan OpenResty: [DEV Community - Creating an API with Lua using OpenResty](https://dev.to/forkbomb/creating-an-api-with-lua-using-openresty-42mc)

#### **5.2 Authentication dan Authorization**

**Deskripsi Konkret:**
Setelah API kita memiliki "pintu" (routes), kita perlu memasang "penjaga" (security).

- **Authentication (Otentikasi):** Proses memverifikasi identitas seseorang. "Siapakah Anda?". Ini seperti menunjukkan KTP saat masuk gedung.
- **Authorization (Otorisasi):** Proses memeriksa izin seseorang setelah identitasnya diverifikasi. "Apa saja yang boleh Anda lakukan?". Ini seperti KTP Anda diperiksa untuk melihat apakah Anda punya akses ke lantai eksekutif.

Untuk API modern yang bersifat _stateless_ (tidak menyimpan sesi di server), metode otentikasi yang paling umum adalah **JWT (JSON Web Token)**.

**Terminologi Kunci: JWT (JSON Web Token)**
JWT adalah sebuah standar (RFC 7519) untuk membuat token yang _self-contained_ (berisi semua informasi yang dibutuhkan).

- **Stateless:** Server tidak perlu menyimpan informasi sesi. Setiap request dari client membawa token ini, dan server bisa memverifikasinya tanpa perlu menengok ke database atau cache sesi. Ini sangat bagus untuk skalabilitas.
- **Struktur:** Sebuah JWT terdiri dari 3 bagian yang dipisahkan oleh titik (`.`):
  1.  `Header`: Metadata tentang token, seperti algoritma hashing (`alg`, misal: `HS256`) dan tipe token (`typ`: `JWT`). Di-encode dengan Base64Url.
  2.  `Payload`: Data atau _claims_ dari token, seperti ID pengguna (`sub`), kapan token dibuat (`iat`), kapan token kedaluwarsa (`exp`), dan data kustom lainnya (misal: `role: "admin"`). Di-encode dengan Base64Url. **Penting:** Payload ini tidak dienkripsi, hanya di-encode, jadi siapa pun bisa membacanya. Jangan letakkan data sensitif di sini.
  3.  `Signature (Tanda Tangan):` Ini adalah bagian keamanan. Signature dibuat dengan hashing `header` + `payload` + sebuah `secret_key` yang hanya diketahui oleh server. Jika `header` atau `payload` diubah oleh penyerang, signature tidak akan cocok lagi.

**Visualisasi Proses JWT:**

1.  Client mengirim `username` & `password` ke endpoint `/login`.
2.  Server memvalidasi kredensial.
3.  Server membuat JWT dengan payload `{ "sub": "123", "role": "user", "exp": ... }` dan menandatanganinya dengan _secret key_.
4.  Server mengirim JWT kembali ke client.
5.  Client menyimpan JWT (misal: di Local Storage).
6.  Untuk setiap request ke rute yang dilindungi (misal: `/api/me`), client menyertakan JWT di header: `Authorization: Bearer <jwt_token>`.
7.  Server menerima request, mengambil token dari header, dan memverifikasi signature-nya menggunakan _secret key_ yang sama. Jika valid dan belum kedaluwarsa, server mempercayai identitas di dalam token dan memproses request.

**Contoh Sintaks (Melindungi Rute dengan `lua-resty-jwt`):**

```nginx
# nginx.conf
http {
    # ...
    server {
        # ...
        location /api/me {
            access_by_lua_block {
                -- Fase 'access' adalah tempat yang tepat untuk security check

                -- Load library JWT
                local jwt = require "resty.jwt"
                local jwt_secret = "kunci-rahasia-yang-sangat-panjang-dan-aman"

                -- 1. Ambil token dari header 'Authorization: Bearer <token>'
                local auth_header = ngx.var.http_authorization
                if not auth_header then
                    ngx.status = 401
                    ngx.say('{"error": "Missing authorization header"}')
                    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
                end

                -- Ekstrak token dari 'Bearer ...'
                local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
                if not token then
                    ngx.status = 401
                    ngx.say('{"error": "Invalid authorization header format"}')
                    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
                end

                -- 2. Verifikasi token
                local ok, claims = pcall(jwt.verify, jwt, jwt_secret, token)

                if not ok then
                    ngx.status = 401
                    ngx.say('{"error": "Invalid token", "details": "' .. tostring(claims) .. '"}')
                    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
                end

                -- 3. (Opsional) Lakukan pengecekan otorisasi
                if claims.payload.role ~= "admin" then
                    -- ngx.status = 403
                    -- ngx.say('{"error": "Forbidden: Admin access required"}')
                    -- return ngx.exit(ngx.HTTP_FORBIDDEN)
                end

                -- 4. Jika sukses, teruskan informasi user ke fase content
                -- ngx.ctx adalah tabel yang hidup selama satu request, berguna untuk passing data antar fase
                ngx.ctx.current_user = claims.payload
            }

            content_by_lua_block {
                local cjson = require "cjson"
                -- Ambil data user yang sudah diverifikasi dari ngx.ctx
                local user_info = ngx.ctx.current_user

                ngx.say("Selamat datang, pengguna dengan ID: ", user_info.sub)
                ngx.say("Data Anda: ", cjson.encode(user_info))
            }
        }
    }
}
```

**Sumber Referensi:**

- Library JWT untuk OpenResty: [GitHub - lua-resty-jwt](https://github.com/SkyLothar/lua-resty-jwt)

#### **5.3 Rate Limiting dan Security**

**Deskripsi Konkret:**
Ini adalah lapisan pertahanan tambahan untuk API kita. Tujuannya adalah untuk memastikan ketersediaan (availability) dan melindungi dari penyalahgunaan.

- **Rate Limiting:** Mencegah satu client (berdasarkan IP, API Key, dll.) mengirim terlalu banyak request dalam waktu singkat, yang bisa membebani server atau menghabiskan kuota layanan pihak ketiga.
- **Input Validation:** Memastikan data yang dikirim client tidak berisi kode berbahaya (XSS, SQL Injection).
- **CORS (Cross-Origin Resource Sharing):** Mekanisme keamanan browser yang perlu kita tangani agar front-end yang berada di domain berbeda bisa mengakses API kita.
- **Security Headers:** Header HTTP tambahan yang bisa kita kirim untuk memberitahu browser agar mengaktifkan fitur keamanan tertentu.

**Implementasi Rate Limiting dengan `lua-resty-limit-traffic`:**
Library ini menggunakan _leaky bucket algorithm_ dan `lua_shared_dict` untuk melacak request secara efisien.

**Contoh Sintaks (Rate Limiting):**

```nginx
# nginx.conf
http {
    # Buat shared memory dictionary untuk menyimpan data rate limit
    lua_shared_dict limit_conn 10m; # Untuk koneksi
    lua_shared_dict limit_req  10m; # Untuk request

    server {
        # ...
        location /api/ {
            access_by_lua_block {
                -- Gunakan IP client sebagai kunci rate limit
                local limit_conn = require "resty.limit.conn"
                local limit_req  = require "resty.limit.req"

                -- Batasi 100 request per detik, dengan 'burst' (ledakan) tambahan 50
                local lim_req, err = limit_req.new("limit_req", 100, 50)
                if not lim_req then
                    ngx.log(ngx.ERR, "Gagal membuat object limit.req: ", err)
                    return ngx.exit(500)
                end

                -- Batasi 10 koneksi konkuren dari satu IP
                local lim_conn, err = limit_conn.new("limit_conn", 10, 0.5)
                if not lim_conn then
                    ngx.log(ngx.ERR, "Gagal membuat object limit.conn: ", err)
                    return ngx.exit(500)
                end

                -- Cek limit koneksi
                local key = ngx.var.binary_remote_addr
                local delay, err = lim_conn:incoming(key, true)
                if not delay then
                    if err == "rejected" then
                        return ngx.exit(503) -- Service Unavailable
                    end
                    ngx.log(ngx.ERR, "Gagal memproses limit.conn: ", err)
                    return ngx.exit(500)
                end

                -- Cek limit request
                local key_req = ngx.var.binary_remote_addr
                local delay_req, err_req = lim_req:incoming(key_req, true)
                if not delay_req then
                    if err_req == "rejected" then
                        return ngx.exit(503)
                    end
                    ngx.log(ngx.ERR, "Gagal memproses limit.req: ", err_req)
                    return ngx.exit(500)
                end

                -- Jika ada delay yang dibutuhkan (karena hampir mencapai limit),
                -- kita bisa menunggu sedikit sebelum memproses
                if delay > 0 then
                    ngx.sleep(delay)
                end
            }

            # ... setelah ini, blok access_by_lua_block untuk JWT bisa dijalankan ...
            # ... kemudian proxy_pass atau content_by_lua_block ...
        }
    }
}
```

**Implementasi CORS (Cross-Origin Resource Sharing):**

```nginx
# nginx.conf
location /api/ {
    # ...

    # Selalu tambahkan header ini untuk semua request ke /api/
    # '*' tidak direkomendasikan untuk produksi, ganti dengan domain frontend Anda
    # contoh: add_header 'Access-Control-Allow-Origin' 'https://my-app.com';
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;

    # Browser akan mengirim request 'preflight' dengan method OPTIONS
    # untuk memeriksa izin CORS sebelum mengirim request sebenarnya (misal: PUT atau DELETE)
    if ($request_method = 'OPTIONS') {
        # Kita cukup merespon dengan 204 No Content dan header di atas.
        return 204;
    }

    # ... lanjutkan ke logika API Anda (proxy_pass atau content_by_lua_block) ...
}
```

**Sumber Referensi:**

- Library Rate Limiting: [GitHub - lua-resty-limit-traffic](https://github.com/openresty/lua-resty-limit-traffic)

---

Dengan menguasai Modul 5, Anda kini mampu membangun backend API yang lengkap: memiliki rute yang terstruktur, sistem otentikasi yang aman dan modern, serta mekanisme pertahanan dari penyalahgunaan. Ini adalah fondasi dari hampir semua aplikasi web modern.

#

Selanjutnya, kita akan masuk ke **Modul 6: Advanced Features** untuk menambahkan kemampuan seperti rendering HTML, komunikasi real-time dengan WebSockets, dan penanganan file upload.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
