### **Daftar Isi Materi Pembelajaran OpenResty & Lua**

- [Modul 0: Pondasi Wajib Sebelum Memulai](#modul-0-pondasi-wajib-sebelum-memulai)
  - [Apa itu Web Server dan Cara Kerjanya?](#apa-itu-web-server-dan-cara-kerjanya)
  - [Apa itu NGINX? Sang Pelayan Berkinerja Tinggi](#apa-itu-nginx-sang-pelayan-berkinerja-tinggi)
  - [Apa itu Lua? Si Bahasa Skrip yang Ringan dan Cepat](#apa-itu-lua-si-bahasa-skrip-yang-ringan-dan-cepat)
  - [Konsep Kunci: Blocking vs. Non-Blocking I/O](#konsep-kunci-blocking-vs-non-blocking-io)
- [Modul 1: Dasar-dasar dan Konsep Fundamental](#modul-1-dasar-dasar-dan-konsep-fundamental)
  - [1.1 Pengenalan OpenResty dan Ekosistemnya](#11-pengenalan-openresty-dan-ekosistemnya)
  - [1.2 Instalasi dan Setup Environment](#12-instalasi-dan-setup-environment)
  - [1.3 Dasar-dasar Lua untuk OpenResty](#13-dasar-dasar-lua-untuk-openresty)
- [Modul 2: NGINX Configuration dan Lua Integration](#modul-2-nginx-configuration-dan-lua-integration)
  - [2.1 NGINX Configuration untuk OpenResty](#21-nginx-configuration-untuk-openresty)
  - [2.2 Lua Directive dan Phases](#22-lua-directive-dan-phases)
  - [2.3 Error Handling dan Debugging](#23-error-handling-dan-debugging)
- [Modul 3: Core APIs dan Libraries](#modul-3-core-apis-dan-libraries)
  - [3.1 HTTP Client dan ngx.location.capture](#31-http-client-dan-ngxlocationcapture)
  - [3.2 Shared Dictionary dan Caching](#32-shared-dictionary-dan-caching)
  - [3.3 Cosockets dan Non-blocking I/O](#33-cosockets-dan-non-blocking-io)
- [Dan seterusnya (untuk modul-modul berikutnya)...](#mengenai-modul-modul-berikutnya)
- [Kesimpulan dan Langkah Selanjutnya](#kesimpulan-dan-langkah-selanjutnya)

---

### **[Modul 0: Pondasi Wajib Sebelum Memulai][0]**

Sebelum kita menyentuh OpenResty, mari kita pastikan kita memiliki fondasi yang sama. Ini adalah bagian yang saya tambahkan untuk memastikan bahkan seseorang tanpa latar belakang IT pun bisa mengikuti.

#### **Apa itu Web Server dan Cara Kerjanya?**

Bayangkan Anda sedang di restoran. Anda (**_client_**) memesan makanan kepada pelayan. Pelayan mencatat pesanan Anda dan memberikannya ke dapur (**_server_**). Dapur memasak makanan, lalu pelayan mengantarkannya kembali ke meja Anda.

Di dunia web, prosesnya sangat mirip:

1.  **Client**: Ini adalah browser web Anda (Chrome, Firefox) atau aplikasi mobile.
2.  **Request (Permintaan)**: Saat Anda mengetik `google.com` dan menekan Enter, browser Anda mengirimkan sebuah "pesanan" atau _request_ ke server Google. Request ini berisi informasi seperti "Saya ingin melihat halaman utama https://www.google.com/url?sa=E\&source=gmail\&q=google.com".
3.  **Server**: Ini adalah komputer super kuat di suatu tempat di dunia yang tugasnya menerima request.
4.  **Process (Proses)**: Server memproses request tersebut. Mungkin ia perlu mengambil data dari database atau menjalankan sebuah logika program.
5.  **Response (Respon)**: Setelah selesai, server mengirimkan kembali "hidangan" atau _response_ ke browser Anda. Response ini biasanya berisi kode HTML, CSS, dan JavaScript yang kemudian ditampilkan oleh browser sebagai halaman web yang Anda lihat.

**Terminologi Kunci:**

- **HTTP (HyperText Transfer Protocol)**: "Bahasa" atau aturan yang digunakan oleh client dan server untuk berkomunikasi.
- **API (Application Programming Interface)**: Bayangkan ini sebagai menu di restoran. API mendefinisikan "pesanan" apa saja yang bisa Anda minta dari server dan format "hidangan" apa yang akan Anda dapatkan kembali. Seringkali, data yang dipertukarkan dalam format JSON.

#### **Apa itu NGINX? Sang Pelayan Berkinerja Tinggi**

NGINX (dibaca "Engine-X") adalah salah satu "pelayan" atau web server paling populer di dunia. Keistimewaannya adalah ia sangat efisien dalam menangani banyak "pelanggan" (requests) secara bersamaan.

Bayangkan pelayan di restoran biasa yang hanya bisa melayani satu meja pada satu waktu. Jika ada 100 meja, ia akan kewalahan. NGINX seperti pelayan super yang bisa mencatat pesanan dari 100 meja hampir secara bersamaan tanpa harus menunggu satu per satu pesanan selesai dimasak. Ini disebut arsitektur **event-driven**.

#### **Apa itu Lua? Si Bahasa Skrip yang Ringan dan Cepat**

Jika NGINX adalah pelayan yang super efisien, **Lua** adalah buku catatan ajaib yang bisa Anda berikan kepada pelayan tersebut untuk melakukan tugas-tugas kustom yang sangat kompleks.

Lua adalah bahasa pemrograman yang:

- **Ringan**: "Jejak" memorinya sangat kecil.
- **Cepat**: Salah satu bahasa skrip tercepat di dunia.
- **Mudah Ditanamkan (Embeddable)**: Didesain untuk "ditanam" di dalam aplikasi lain (seperti NGINX) untuk menambahkan kemampuan scripting.

Ini berbeda dari Dart, yang merupakan bahasa general-purpose yang bisa Anda gunakan untuk membangun aplikasi Flutter, backend, dll. dari awal. Lua di sini berperan sebagai "lem" atau "perluasan" dari NGINX.

#### **Konsep Kunci: Blocking vs. Non-blocking I/O**

Ini adalah konsep paling krusial di dunia OpenResty.

- **Blocking I/O (Input/Output)**: Bayangkan Anda menelepon layanan pelanggan. Anda harus **menunggu** di telepon, mendengarkan musik tunggu, sampai operator tersedia. Selama menunggu, Anda tidak bisa melakukan hal lain. Ini adalah _blocking_. Dalam konteks server, ini berarti menunggu database atau layanan lain merespons, dan selama menunggu, server tidak bisa melayani request lain.
- **Non-blocking I/O**: Bayangkan Anda mengirim pesan WhatsApp ke teman Anda. Anda mengirim pesan, lalu Anda bisa melanjutkan aktivitas lain (main game, nonton video). Nanti, ketika teman Anda membalas, Anda akan mendapatkan notifikasi. Anda tidak perlu "menunggu" balasan itu. Inilah inti dari _non-blocking_.

OpenResty dan NGINX menggunakan model non-blocking ini. Mereka bisa mengirim permintaan ke database, dan sambil menunggu jawaban, mereka melayani ribuan request dari pengguna lain. Inilah sumber kekuatan performa mereka.

---

### **Modul 1: Dasar-dasar dan Konsep Fundamental**

Sekarang kita masuk ke kurikulum inti Anda, dengan penjelasan yang mendalam.

#### **1.1 Pengenalan OpenResty dan Ekosistemnya**

**Deskripsi Konkret:**
OpenResty **bukanlah** sebuah fork atau cabang dari NGINX. Anggap saja OpenResty adalah sebuah "paket distribusi" atau "platform web" yang mengambil NGINX _core_ (inti NGINX), menggabungkannya dengan **LuaJIT** (versi Lua yang sangat cepat), dan menambahkan banyak sekali modul NGINX pihak ketiga yang sudah "dioprek" agar bekerja secara harmonis dalam model non-blocking.

Secara sederhana: **OpenResty = NGINX + LuaJIT + Kumpulan Modul Super**.

**Arsitektur Visual:**

```
     Permintaan dari Pengguna (Client Request)
                   |
                   V
+---------------------------------------------+
|                NGINX Worker                 |
|                                             |
|  +---------------------------------------+  |
|  |     NGINX Core (Event Loop)           |  |
|  +---------------------------------------+  |
|                   |                         |
|  <-- Menjalankan Logika di Fase Tertentu --> |
|                   |                         |
|  +---------------------------------------+  |
|  |             Lua Virtual Machine       |  |
|  |   (Menjalankan skrip *.lua Anda)      |  |
|  |                                       |  |
|  | - ngx.say("Hello")                    |  |
|  | - Koneksi ke DB (non-blocking)        |  |
|  | - Memanggil API lain (non-blocking)   |  |
|  +---------------------------------------+  |
|                                             |
+---------------------------------------------+
                   |
                   V
     Respon untuk Pengguna (Client Response)
```

**Terminologi Kunci:**

- **LuaJIT**: Bukan Lua biasa. Ini adalah _Just-In-Time compiler_ untuk Lua. Artinya, saat kode Lua Anda dijalankan pertama kali, LuaJIT akan mengkompilasinya menjadi kode mesin yang sangat cepat, membuatnya hampir secepat kode yang ditulis dalam bahasa C.
- **Subprojects/Core Components**: Ini adalah modul-modul yang sudah dibundel bersama OpenResty, seperti `lua-nginx-module` (jembatan utama antara NGINX dan Lua), `lua-resty-core` (fungsi-fungsi inti yang dioptimalkan), `lua-resty-redis`, dll. Anda tidak perlu menginstalnya satu per satu.
- **Use Case (Kasus Penggunaan)**: Karena kemampuannya, OpenResty sangat ideal untuk membangun:
  - **API Gateway**: Gerbang untuk semua layanan mikro Anda, menangani otentikasi, rate limiting, logging.
  - **Web Application Firewall (WAF)**: Menganalisis lalu lintas HTTP untuk memblokir serangan.
  - **Dynamic Content Server**: Server yang bisa menghasilkan konten (misalnya, JSON dari database) secara langsung dan sangat cepat, tanpa perlu server aplikasi terpisah (seperti Node.js atau Spring Boot).

**Sumber Referensi:**

- Website Resmi: [OpenResty Official Website](https://openresty.org/en/)
- Komponen Inti: [OpenResty Components Overview](https://openresty.org/en/components.html)
- Modul Jembatan NGINX-Lua: [GitHub lua-nginx-module](https://github.com/openresty/lua-nginx-module)

#### **1.2 Instalasi dan Setup Environment**

**Deskripsi Konkret:**
Menginstal OpenResty pada dasarnya sama dengan menginstal web server lain. Setelah terinstal, Anda akan mendapatkan sebuah direktori yang berisi:

1.  Binary `openresty`: Ini adalah NGINX yang sudah dimodifikasi.
2.  Direktori `nginx/conf`: Tempat Anda meletakkan file konfigurasi utama, `nginx.conf`.
3.  Direktori `lualib`: Tempat library-library Lua bawaan OpenResty berada.

Proses development biasanya melibatkan:

1.  Mengubah file `nginx.conf` untuk mendefinisikan _server_ dan _location_.
2.  Menulis logika dalam file `.lua`.
3.  Memerintahkan NGINX untuk menjalankan file `.lua` tersebut pada _location_ tertentu.

**Contoh Sintaks Dasar (`nginx.conf`):**
Ini adalah "Hello World" di OpenResty. Simpan sebagai `nginx.conf` dan jalankan OpenResty.

```nginx
# Ini adalah komentar
worker_processes  1; # Jumlah proses worker yang akan dijalankan NGINX

# Blok untuk logging error
error_log logs/error.log;

events {
    worker_connections 1024; # Maks koneksi per worker
}

http {
    # Blok http berisi semua konfigurasi untuk server web
    server {
        # Server akan mendengarkan di port 8080
        listen 8080;

        # 'location' mendefinisikan bagaimana request untuk URL tertentu diproses
        location /hello {
            # 'default_type' mengatur header Content-Type pada response
            default_type 'text/plain';

            # Ini adalah 'magic' dari OpenResty.
            # Alih-alih menyajikan file statis, kita menjalankan kode Lua secara langsung.
            content_by_lua_block {
                ngx.say("Halo dari Lua di dalam OpenResty!")
            }
        }
    }
}
```

**Cara Menjalankan:**

1.  Navigasi ke direktori instalasi OpenResty.
2.  Jalankan: `bin/openresty -p $(pwd)/ -c conf/nginx.conf`
3.  Buka browser atau gunakan curl: `curl http://localhost:8080/hello`
4.  Anda akan melihat output: `Halo dari Lua di dalam OpenResty!`

**Sumber Referensi:**

- Panduan Memulai: [OpenResty Getting Started](https://openresty.org/en/getting-started.html)
- Tutorial DigitalOcean (Meskipun versi lama, konsepnya masih relevan): [DigitalOcean OpenResty Tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-the-openresty-web-framework-for-nginx-on-ubuntu-16-04)

#### **1.3 Dasar-dasar Lua untuk OpenResty**

**Deskripsi Konkret:**
Lua adalah bahasa yang minimalis. Jika Anda sudah familiar dengan Dart/JavaScript, Anda akan cepat beradaptasi.

**Sintaks dan Struktur Data Utama:**

- **Variables**: Dinamis, tidak perlu deklarasi tipe. Gunakan `local` untuk membuat variabel lokal (ini adalah praktik terbaik untuk performa).
  ```lua
  local nama = "Budi" -- String
  local umur = 25     -- Number
  local aktif = true  -- Boolean
  ```
- **Table**: Ini adalah satu-satunya struktur data di Lua. Ia bisa berperan sebagai _Array_, _Dictionary_ (Map), atau bahkan _Object_.

  ```lua
  -- Sebagai Array (indeks dimulai dari 1)
  local warna = {"merah", "kuning", "hijau"}
  print(warna[1]) -- Output: merah

  -- Sebagai Dictionary (Map)
  local pengguna = {
      nama = "Siti",
      umur = 22,
      kota = "Jakarta"
  }
  print(pengguna.nama)    -- Output: Siti
  print(pengguna["kota"]) -- Output: Jakarta
  ```

- **Functions**: Mirip dengan bahasa lain.

  ```lua
  local function sapa(nama)
      return "Halo, " .. nama .. "!" -- '..' adalah operator konkatenasi string
  end

  print(sapa("Ani")) -- Output: Halo, Ani!
  ```

- **Control Flow**: `if-then-else-end`, `for`, `while`.
  ```lua
  local skor = 85
  if skor > 80 then
      print("Lulus dengan baik")
  elseif skor > 60 then
      print("Lulus")
  else
      print("Gagal")
  end
  ```

**Catatan untuk Developer OOP:**
Di Lua, "objek" seringkali diemulasikan menggunakan _table_ dan _metatable_. Anda bisa menganggap _table_ sebagai objek itu sendiri (tempat data) dan _metatable_ sebagai "kelas"-nya (tempat method/perilaku). Namun, dalam konteks OpenResty, Anda akan lebih sering menulis kode prosedural (serangkaian instruksi) daripada membangun hierarki kelas yang rumit.

**Sumber Referensi:**

- Buku Panduan (Sangat Direkomendasikan): [Programming OpenResty GitBook](https://openresty.gitbooks.io/programming-openresty/)
- Interpreter Lua Standar: [OpenResty Standard Lua Interpreter](https://openresty.org/en/standard-lua-interpreter.html)

---

### **Modul 2: NGINX Configuration dan Lua Integration**

Modul ini adalah jantung dari OpenResty. Di sini Anda belajar cara "menyuntikkan" logika Lua ke dalam alur pemrosesan request NGINX.

#### **2.1 NGINX Configuration untuk OpenResty**

**Deskripsi Konkret:**
File `nginx.conf` adalah cetak biru dari server Anda. Ia bersifat deklaratif. Anda tidak menulis _bagaimana_ server harus bekerja, melainkan _apa_ yang harus server lakukan dalam kondisi tertentu.

**Struktur Penting dalam `nginx.conf`:**

- `http { ... }`: Konteks utama untuk semua hal yang berkaitan dengan web.
- `server { ... }`: Mendefinisikan sebuah virtual host. Anda bisa punya banyak blok `server` untuk domain yang berbeda atau port yang berbeda.
- `location /path { ... }`: Blok paling penting. Ini mencocokkan URI dari request (bagian dari URL setelah domain, misal `/api/users`). Ketika sebuah request cocok, instruksi di dalam blok `location` akan dieksekusi.
- `upstream { ... }`: Digunakan untuk mendefinisikan sekelompok server backend. Berguna untuk _load balancing_ (membagi beban lalu lintas ke beberapa server).

**Contoh Sintaks (`nginx.conf` dengan Upstream):**

```nginx
http {
    # Mendefinisikan grup server backend bernama 'my_app'
    upstream my_app {
        server 127.0.0.1:3000; # Server aplikasi Node.js/Python/Go Anda
        server 127.0.0.1:3001;
    }

    server {
        listen 80;
        server_name myapi.com;

        location / {
            # Semua request yang masuk akan diteruskan (di-proxy)
            # ke salah satu server di grup 'my_app'
            proxy_pass http://my_app;
        }
    }
}
```

#### **2.2 Lua Directive dan Phases**

**Deskripsi Konkret:**
NGINX memproses setiap request melalui serangkaian "fase" atau _phases_. Bayangkan ini seperti lini perakitan mobil. Setiap stasiun (fase) melakukan tugas spesifik. OpenResty memungkinkan Anda menyisipkan kode Lua di hampir setiap fase ini.

**Visualisasi NGINX Request Phases:**

```
Client Request --> [ post-read ] -> [ server-rewrite ] -> [ find-config ] -> [ rewrite ] -> [ post-rewrite ] -> [ preaccess ] -> [ ACCESS ] -> [ post-access ] -> [ try-files ] -> [ CONTENT ] -> [ log ] --> Client Response
                        |                  |                   |                 |                  |                   |                      |
                        |                  |                   |                 |                  |                   |                      |
                   (Fase Awal)      (Modifikasi   (Mencari    (Modifikasi   (Setelah         (Sebelum           (Cek Izin /      (Setelah Cek    (Menghasilkan       (Mencatat
                                      URL Global)    Blok       URL Lokal)      Rewrite)          Pemeriksaan        Otentikasi)     Izin)           Konten)            Aktivitas)
                                                     Location)                                      Akses)
```

**Directive Lua yang Paling Umum:**

- `*_by_lua_block { lua_code }`: Menjalankan kode Lua langsung di dalam `nginx.conf`.
- `*_by_lua_file /path/to/script.lua`: Menjalankan kode Lua dari file eksternal (lebih rapi).

**Directive Penting dan Fase Terkaitnya:**

- `set_by_lua_*`: Fase `rewrite`. Berguna untuk mendefinisikan variabel NGINX secara dinamis.
- `rewrite_by_lua_*`: Fase `rewrite`. Untuk logika rewrite URL yang kompleks.
- `access_by_lua_*`: Fase `access`. **Sangat penting**. Digunakan untuk otentikasi, otorisasi, dan pengecekan keamanan. Jika kode Lua di sini mengeluarkan `ngx.exit(403)`, request akan dihentikan dengan status "Forbidden".
- `content_by_lua_*`: Fase `content`. **Sangat penting**. Digunakan untuk menghasilkan response utama dan mengirimkannya ke client. Ini mengubah NGINX dari sekadar proxy menjadi server aplikasi penuh.

**Contoh Sintaks (`nginx.conf`):**

```nginx
location /api/data {
    # 1. Fase ACCESS: Cek API Key
    access_by_lua_block {
        local api_key = ngx.var.http_x_api_key -- Ambil header 'X-Api-Key'

        if api_key ~= "kunci_rahasia_123" then
            ngx.status = 401 -- Unauthorized
            ngx.say("API Key tidak valid")
            return ngx.exit(ngx.HTTP_UNAUTHORIZED)
        end
        -- Jika valid, request akan lanjut ke fase CONTENT
    }

    # 2. Fase CONTENT: Hasilkan response JSON
    content_by_lua_block {
        -- Di dunia nyata, data ini diambil dari database atau cache
        local data = { id = 123, product = "Buku OpenResty" }

        -- Load library JSON
        local cjson = require "cjson"

        -- Set header Content-Type
        ngx.header.content_type = "application/json; charset=utf-8"

        -- Kirim response
        ngx.say(cjson.encode(data))
    }
}
```

**Sumber Referensi:**

- Dokumentasi `lua-nginx-module`: [lua-nginx-module README](https://github.com/openresty/lua-nginx-module#readme) (Ini adalah referensi paling penting untuk direktif)

#### **2.3 Error Handling dan Debugging**

**Deskripsi Konkret:**
Debugging di OpenResty bisa sedikit tricky karena kode Anda berjalan di dalam server. Anda tidak bisa begitu saja memasang breakpoint seperti di IDE biasa.

**Metode Utama:**

1.  **Logging**: Ini adalah teman terbaik Anda. Gunakan `ngx.log()` untuk mencetak pesan ke log error NGINX.

    - `ngx.log(ngx.ERR, "Terjadi kesalahan: ", error_message)`
    - `ngx.log(ngx.WARN, "Kondisi yang mencurigakan")`
    - `ngx.log(ngx.NOTICE, "Informasi penting")`
    - `ngx.log(ngx.INFO, "Informasi umum")`
    - `ngx.log(ngx.DEBUG, "Pesan debug detail")`
      Anda bisa mengatur level log di `nginx.conf` dengan `error_log logs/error.log debug;` untuk melihat semua pesan.

2.  **`pcall` dan `xpcall`**: Ini adalah fungsi bawaan Lua untuk "menangkap" error, mirip `try-catch` di bahasa lain.

    ```lua
    local cjson = require "cjson"

    local ok, result = pcall(cjson.decode, '{"invalid json') -- 'ok' akan false
    if not ok then
        ngx.log(ngx.ERR, "Gagal decode JSON: ", result) -- 'result' berisi pesan error
        -- Lakukan sesuatu untuk menangani error
    else
        -- Lanjutkan proses dengan 'result'
    end
    ```

3.  **Profiling**: Untuk masalah performa, Anda akan menggunakan alat khusus seperti OpenResty XRay (dibahas di Modul 9) untuk menemukan _bottleneck_ (kemacetan) di kode Lua Anda tanpa mengganggu server produksi.

**Sumber Referensi:**

- Blog Resmi (sering membahas debugging dan profiling): [OpenResty Official Blog](https://blog.openresty.com/en/)

---

### **Modul 3: Core APIs dan Libraries**

Modul ini memperkenalkan "peralatan" yang disediakan OpenResty untuk melakukan tugas-tugas umum dalam pengembangan web.

#### **3.1 HTTP Client dan ngx.location.capture**

**Deskripsi Konkret:**
Seringkali, server Anda perlu "berbicara" dengan server lain, misalnya memanggil API pihak ketiga atau layanan mikro internal. `ngx.location.capture` adalah cara OpenResty untuk melakukan ini secara internal dan **non-blocking**.

Ini adalah "subrequest": request yang dibuat oleh NGINX itu sendiri, bukan oleh client eksternal.

**Konsep:**
Bayangkan Anda sedang memproses pesanan di `location /pesanan`. Untuk memvalidasi stok barang, Anda tidak langsung konek ke database stok, melainkan membuat subrequest ke `location /internal/cek_stok` yang sudah Anda definisikan. Ini membuat kode lebih modular dan terorganisir.

**Contoh Sintaks:**

```nginx
# nginx.conf
server {
    listen 8080;

    # Lokasi publik
    location /get_user_info {
        content_by_lua_block {
            -- Panggil subrequest ke lokasi internal untuk mengambil data user
            local res = ngx.location.capture("/_get_user_from_db", {
                method = ngx.HTTP_GET,
                args = { id = 123 }
            })

            -- Kirimkan kembali response dari subrequest ke client
            ngx.status = res.status
            ngx.say(res.body)
        }
    }

    # Lokasi internal, tidak bisa diakses dari luar
    location /_get_user_from_db {
        internal; # <-- Kunci penting!

        content_by_lua_block {
            -- Logika untuk mengambil data user dari database (akan dibahas nanti)
            -- Untuk sekarang, kita hardcode saja
            ngx.say('{"id": 123, "nama": "Pengguna dari DB"}')
        }
    }
}
```

Jika Anda mengakses `http://localhost:8080/get_user_info`, Anda akan melihat data user. Tapi jika mencoba mengakses `http://localhost:8080/_get_user_from_db` langsung, Anda akan mendapatkan error "Forbidden" karena direktif `internal`.

**Terminologi Kunci:**

- **Subrequest**: Request HTTP yang dibuat oleh server itu sendiri, ditujukan ke `location` lain di dalam server yang sama. Ini sangat efisien karena tidak melalui network stack sistem operasi.

#### **3.2 Shared Dictionary dan Caching**

**Deskripsi Konkret:**
NGINX menjalankan beberapa proses _worker_ secara terpisah. Variabel Lua `local` di satu worker tidak bisa diakses oleh worker lain. Bagaimana cara berbagi data (seperti data cache, session, atau counter) antar semua worker? Jawabannya adalah **Shared Memory Dictionary** atau `ngx.shared.DICT`.

Bayangkan ini seperti papan tulis di kantor yang bisa dilihat dan ditulisi oleh semua karyawan (worker).

**Cara Penggunaan:**

1.  **Deklarasikan di `nginx.conf`**: Anda harus mengalokasikan memori untuk dictionary ini di konteks `http`.
2.  **Akses dari Lua**: Gunakan API `ngx.shared.my_cache` untuk `get`, `set`, `add`, `delete` data.

**Contoh Sintaks:**

```nginx
# nginx.conf
http {
    # Alokasikan 10 megabyte memori untuk cache bernama 'my_cache'
    lua_shared_dict my_cache 10m;

    server {
        listen 8080;
        location /data {
            content_by_lua_block {
                local cache = ngx.shared.my_cache
                local cache_key = "product:123"

                -- 1. Coba ambil dari cache
                local cached_data = cache:get(cache_key)

                if cached_data then
                    ngx.say("Data dari CACHE: ", cached_data)
                    return
                end

                -- 2. Jika tidak ada di cache, ambil dari sumber asli (misal: database)
                -- (simulasi)
                local data_from_db = '{"id":123, "name":"Produk Mahal"}'
                ngx.log(ngx.INFO, "Data tidak ada di cache, mengambil dari DB")

                -- 3. Simpan ke cache untuk request berikutnya
                -- set(key, value, expiration_in_seconds)
                cache:set(cache_key, data_from_db, 60) -- Cache selama 60 detik

                ngx.say("Data dari DATABASE: ", data_from_db)
            }
        }
    }
}
```

Saat pertama kali Anda mengakses `/data`, Anda akan melihat "Data dari DATABASE". Jika Anda merefresh halaman dalam 60 detik, Anda akan melihat "Data dari CACHE".

**Terminologi Kunci:**

- **Shared Memory**: Blok memori yang bisa diakses oleh beberapa proses yang berbeda secara bersamaan.
- **Cache**: Tempat penyimpanan sementara untuk data yang sering diakses agar tidak perlu mengambilnya dari sumber yang lebih lambat (seperti database atau API eksternal) setiap saat.

#### **3.3 Cosockets dan Non-blocking I/O**

**Deskripsi Konkret:**
Ini adalah implementasi dari konsep non-blocking I/O yang kita bahas di Modul 0. **Cosocket** (Coroutine Socket) adalah API utama di OpenResty untuk melakukan komunikasi jaringan (TCP/UDP) tanpa mem-blokir worker NGINX.

**Bagaimana Cara Kerjanya?**
Di balik layar, ketika Anda memanggil fungsi cosocket seperti `sock:connect()` atau `sock:receive()`, prosesnya seperti ini:

1.  Kode Lua Anda meminta untuk melakukan operasi jaringan (misal: konek ke database Redis).
2.  OpenResty menyerahkan permintaan ini ke _event loop_ NGINX.
3.  **Penting**: OpenResty **menangguhkan (yield)** coroutine Lua Anda dan **segera** kembali ke NGINX event loop untuk melayani request lain. Worker tidak menunggu\!
4.  Ketika operasi jaringan selesai (misal: koneksi berhasil dibuat atau data diterima), NGINX event loop akan mendapatkan notifikasi.
5.  OpenResty kemudian **melanjutkan (resume)** coroutine Lua Anda yang tadi ditangguhkan, tepat dari titik ia berhenti, sekarang dengan hasil dari operasi jaringan.

Bagi Anda sebagai programmer, kodenya terlihat seperti kode sinkron/blocking biasa, yang membuatnya sangat mudah ditulis. Keajaiban non-blocking terjadi secara transparan.

**Contoh Sintaks (Menghubungkan ke Redis):**

```lua
-- Pastikan Anda punya library lua-resty-redis
local redis = require "resty.redis"
local red = redis:new()

-- Atur timeout
red:set_timeout(1000) -- 1 detik

-- 1. Koneksi (Non-blocking)
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("Gagal konek ke Redis: ", err)
    return
end

-- 2. Kirim perintah (Non-blocking)
local ok, err = red:set("dog", "an animal")
if not ok then
    ngx.say("Gagal set key: ", err)
    return
end

-- 3. Ambil data (Non-blocking)
local res, err = red:get("dog")
if not res then
    ngx.say("Gagal get key: ", err)
    return
end

if res == ngx.null then
    ngx.say("Key tidak ditemukan")
    return
end

ngx.say(res)

-- Kembalikan koneksi ke pool (penting!)
red:set_keepalive(10000, 100)
```

Setiap panggilan `red:*` (connect, set, get) di atas adalah non-blocking, berkat API Cosocket.

**Sumber Referensi:**

- Pusat Pembelajaran API7 (Pembangun APISIX, berbasis OpenResty): [API7.ai Learning Center](https://api7.ai/learning-center/openresty)

---

### **Mengenai Modul-Modul Berikutnya...**

- **Modul 4 (Database Integration):** Akan menjelaskan cara menggunakan `lua-resty-mysql` dan `lua-resty-redis`, menjelaskan konsep _connection pooling_ (menggunakan kembali koneksi database agar tidak perlu membuat yang baru setiap saat, yang sangat mahal), dan bagaimana menangani data JSON.
- **Modul 5 (Web API Development):** Akan fokus pada praktik membangun RESTful API, termasuk routing, otentikasi dengan JWT (JSON Web Tokens), dan _rate limiting_ untuk mencegah penyalahgunaan. Saya akan jelaskan apa itu JWT, strukturnya, dan mengapa ia cocok untuk arsitektur modern.
- **Modul 6 (Advanced Features):** Akan membahas cara merender HTML di sisi server (`lua-resty-template`), membangun aplikasi real-time dengan WebSockets, dan menangani upload file.
- **Modul 7 (Custom Modules):** Akan mengajarkan cara mengorganisir kode Lua Anda ke dalam modul yang dapat digunakan kembali, mirip dengan mengimpor library di Dart, dan cara menggunakan FFI (Foreign Function Interface) untuk memanggil fungsi dari library C, yang memberikan performa maksimal.
- **Modul 8 (Testing):** Akan memperkenalkan `Test::Nginx`, sebuah framework testing yang luar biasa untuk menguji konfigurasi NGINX dan logika Lua Anda secara otomatis.
- **Modul 9 (Performance Optimization):** Ini adalah modul yang sangat penting. Akan dibahas tentang _garbage collection_ di Lua, strategi caching tingkat lanjut, dan pengenalan **OpenResty XRay**, sebuah alat komersial yang sangat canggih untuk menganalisis dan memecahkan masalah performa secara real-time tanpa menghentikan aplikasi Anda.
- **Modul 10 & 14 (Deployment & DevOps):** Akan mencakup cara mem-package aplikasi OpenResty Anda dalam kontainer Docker, mendeploy-nya dengan Kubernetes, dan mengintegrasikannya ke dalam alur kerja CI/CD (Continuous Integration/Continuous Deployment) untuk otomatisasi.
- **Modul 11 & 13 (Advanced Use Cases & Security):** Akan mendalami kasus penggunaan OpenResty sebagai API Gateway (seperti Kong atau APISIX yang dibangun di atasnya) dan WAF, serta praktik keamanan tingkat lanjut seperti hardening SSL/TLS.
- **Modul 15 (Community & Ecosystem):** Akan memberikan arahan tentang bagaimana terus belajar dan berkontribusi pada komunitas OpenResty.

### **Kesimpulan dan Langkah Selanjutnya**

1.  **Praktik, Praktik, Praktik:** Jangan hanya membaca. Untuk setiap modul, ketik ulang kodenya, jalankan, dan coba ubah-ubah. Coba buat error dengan sengaja untuk melihat pesan apa yang muncul.
2.  **Fokus pada Konsep Non-Blocking:** Ini adalah perubahan paradigma terbesar dari model pengembangan aplikasi tradisional. Selalu tanyakan pada diri sendiri, "Apakah operasi ini mem-blokir worker?". Jika ya, cari cara untuk melakukannya secara non-blocking dengan API yang disediakan OpenResty.
3.  **Gunakan Referensi:** Simpan tautan ke dokumentasi `lua-nginx-module` dan buku `Programming OpenResty`. Mereka akan menjadi teman Anda sehari-hari.

**Selamat belajar\!**

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../README.md
[selanjutnya]: ../bagian-2/README.md
[sebelumnya]: ../../advanced-patterns/bagian-14/README.md

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
