Kini kita beralih ke **Modul 11: Advanced Use Cases**. Setelah memahami cara membangun aplikasi dengan OpenResty, modul ini akan menunjukkan bagaimana OpenResty digunakan sebagai fondasi untuk membangun produk infrastruktur yang lebih besar dan kompleks. Karena kecepatannya yang luar biasa dan fleksibilitasnya yang tinggi, OpenResty sering menjadi mesin utama di balik API Gateway, Web Application Firewall, dan bahkan Content Delivery Network.

---

### **Modul 11: Advanced Use Cases**

**Tujuan Modul:** Memahami bagaimana OpenResty digunakan sebagai platform untuk membangun solusi infrastruktur web tingkat lanjut seperti API Gateway, WAF, dan CDN.

#### **11.1 API Gateway Implementation**

**Deskripsi Konkret:**
Bayangkan Anda memiliki puluhan atau ratusan layanan mikro (_microservices_), masing-masing dengan fungsinya sendiri (layanan user, layanan produk, layanan pembayaran, dll). **API Gateway** adalah sebuah server yang bertindak sebagai **pintu gerbang tunggal** untuk semua lalu lintas yang menuju ke layanan-layanan tersebut. Alih-alih client harus tahu alamat dari setiap layanan mikro, mereka cukup berkomunikasi dengan satu titik, yaitu API Gateway.

OpenResty adalah pilihan yang sangat populer untuk membangun API Gateway karena kemampuannya untuk menangani ribuan koneksi secara bersamaan dan memproses logika request dengan sangat cepat.

**Konsep Kunci: Tanggung Jawab API Gateway**
API Gateway menangani berbagai tugas yang bersifat _cross-cutting_ (dibutuhkan oleh banyak layanan), sehingga setiap layanan mikro tidak perlu mengimplementasikannya sendiri.

- **Routing:** Meneruskan request masuk ke layanan mikro yang tepat berdasarkan path, header, atau informasi lain. (misal: `GET /users/123` diarahkan ke `user-service`).
- **Authentication & Authorization:** Memeriksa identitas dan hak akses client di satu tempat (misal: validasi token JWT) sebelum request diizinkan masuk ke jaringan internal.
- **Rate Limiting & Throttling:** Menerapkan batas penggunaan API secara terpusat untuk melindungi semua layanan di belakangnya.
- **Logging, Metrics, & Tracing:** Mengumpulkan data observabilitas dari semua lalu lintas API di satu lokasi terpusat.
- **Request/Response Transformation:** Mengubah request sebelum diteruskan ke backend (misal: menambahkan header) atau mengubah respons sebelum dikirim ke client (misal: memfilter beberapa field).
- **Protocol Translation:** Menerjemahkan protokol, misalnya, menerima request REST/HTTP dari client dan mengubahnya menjadi gRPC untuk berkomunikasi dengan layanan backend.

**Fakta Penting:**

- **Kong**, salah satu API Gateway open-source paling populer di dunia, dibangun di atas OpenResty. Ini adalah bukti nyata betapa kuatnya OpenResty untuk kasus penggunaan ini.

**Contoh Sintaks (Dynamic Routing Sederhana):**
Alih-alih `proxy_pass` yang statis, API Gateway perlu melakukan routing secara dinamis. Contoh ini menggunakan tabel Lua sebagai "service registry" sederhana untuk menentukan ke mana request harus diarahkan.

```nginx
# nginx.conf
http {
    # 'resolver' diperlukan agar NGINX bisa resolve nama domain saat runtime
    # 8.8.8.8 adalah DNS Google, bisa diganti dengan DNS internal
    resolver 8.8.8.8;

    # Service registry sederhana kita
    lua_shared_dict service_registry 1m;

    server {
        listen 8080;

        location / {
            access_by_lua_block {
                -- Di dunia nyata, data ini diisi dari Consul, etcd, atau API
                -- Kita isi secara manual untuk demonstrasi
                local service_registry = ngx.shared.service_registry
                service_registry:set("users", "http://user-service.internal:3000")
                service_registry:set("products", "http://product-service.internal:3001")
            }

            rewrite_by_lua_block {
                -- Ekstrak nama layanan dari path, misal: /api/users/123 -> users
                local service_name = ngx.re.match(ngx.var.uri, "^/api/([^/]+)")

                if not service_name then
                    ngx.log(ngx.ERR, "Nama layanan tidak ditemukan di URI")
                    return ngx.exit(404)
                end

                local service_registry = ngx.shared.service_registry
                local upstream_url = service_registry:get(service_name[1])

                if not upstream_url then
                    ngx.log(ngx.ERR, "Layanan '", service_name[1], "' tidak terdaftar")
                    return ngx.exit(404)
                end

                -- Set variabel NGINX yang akan digunakan oleh proxy_pass
                ngx.var.upstream = upstream_url
            }

            # proxy_pass menggunakan variabel yang sudah kita set di fase rewrite
            proxy_pass $upstream;
        }
    }
}
```

**Sumber Referensi:**

- Kong API Gateway (Dibangun di atas OpenResty): [GitHub - Kong/kong](https://github.com/Kong/kong)

#### **11.2 Web Application Firewall (WAF)**

**Deskripsi Konkret:**
**Web Application Firewall (WAF)** adalah sebuah lapisan keamanan yang secara spesifik dirancang untuk melindungi aplikasi web dari serangan-serangan umum. Ia berada di antara pengguna dan aplikasi Anda, menganalisis setiap request HTTP/HTTPS untuk mencari tanda-tanda aktivitas berbahaya.

Fase `access_by_lua_*` di OpenResty adalah tempat yang sempurna untuk mengimplementasikan logika WAF. Untuk setiap request, kita bisa menjalankan skrip Lua yang memeriksa URI, header, dan body request terhadap serangkaian aturan keamanan.

**Konsep Kunci: Cara Kerja WAF**

- **Rule-Based Engine:** Inti dari WAF adalah mesin aturan. Aturan-aturan ini mendefinisikan pola (seringkali menggunakan _regular expression_) yang cocok dengan vektor serangan yang diketahui.
- **Jenis Serangan yang Dilawan:**
  - **SQL Injection (SQLi):** Mencari pola seperti `' OR '1'='1'` di dalam parameter.
  - **Cross-Site Scripting (XSS):** Mencari tag `<script>` atau atribut `onerror` di dalam input yang akan ditampilkan kembali ke pengguna.
  - **Path Traversal:** Mencari pola seperti `../../` yang mencoba mengakses file di luar direktori web.
  - Dan banyak lagi (Command Injection, File Inclusion, dll.).
- **Tindakan:** Jika sebuah request cocok dengan salah satu aturan, WAF akan mengambil tindakan, biasanya dengan memblokir request tersebut (mengembalikan status `403 Forbidden`) dan mencatat insiden tersebut untuk dianalisis lebih lanjut.

**Implementasi dengan `lua-resty-waf`:**
Membangun WAF dari nol sangatlah rumit. Untungnya, ada proyek open-source seperti `lua-resty-waf` yang menyediakan kerangka kerja WAF yang solid untuk OpenResty, lengkap dengan seperangkat aturan default yang terinspirasi oleh OWASP Core Rule Set.

**Contoh Sintaks (Konseptual):**

```nginx
# nginx.conf
http {
    # ...
    server {
        # ...
        location / {
            access_by_lua_block {
                -- Muat dan konfigurasikan library WAF
                local waf = require "resty.waf"

                -- Memuat aturan-aturan (dari file atau dikonfigurasi di sini)
                -- ...

                -- Jalankan WAF untuk menganalisis request saat ini
                local results = waf:run()

                -- Periksa apakah ada aturan yang terpicu
                if results and results.rule and results.action == "BLOCK" then
                    ngx.log(ngx.ERR,
                        "WAF: Request diblokir oleh aturan '", results.rule,
                        "', Aksi: ", results.action,
                        ", Klien: ", ngx.var.remote_addr
                    )
                    return ngx.exit(403) -- Forbidden
                end

                -- Jika request bersih, biarkan ia melanjutkan ke fase berikutnya
            }

            # ... proxy_pass atau content_by_lua_block
        }
    }
}
```

**Sumber Referensi:**

- Library WAF untuk OpenResty: [GitHub - p0pr0ck5/lua-resty-waf](https://github.com/p0pr0ck5/lua-resty-waf)

#### **11.3 Content Delivery Network (CDN)**

**Deskripsi Konkret:**
**Content Delivery Network (CDN)** adalah jaringan server proxy yang tersebar secara geografis di seluruh dunia. Tujuannya adalah untuk mengirimkan konten (terutama aset statis seperti gambar, video, CSS, dan JavaScript) kepada pengguna dari server yang lokasinya paling dekat dengan mereka. Ini secara drastis mengurangi latensi (waktu tunda) dan mempercepat waktu muat situs web.

OpenResty adalah teknologi yang ideal untuk membangun "otak" dari sebuah **PoP (Point of Presence)**, yaitu salah satu server di dalam jaringan CDN.

**Konsep Kunci: Cara Kerja CDN**

1.  **Origin Server:** Ini adalah server utama Anda tempat semua konten asli berada.
2.  **Edge Server (PoP):** Ini adalah server-server CDN yang tersebar di seluruh dunia.
3.  **Edge Caching:** Saat seorang pengguna di London meminta `gambar.jpg`, request tersebut tidak pergi ke server asal Anda di Jakarta, melainkan ke PoP terdekat di London.
    - **Cache Miss:** Jika ini adalah pertama kalinya gambar tersebut diminta di London, PoP London akan mengambilnya dari server asal Anda di Jakarta.
    - **Cache Hit:** PoP London kemudian akan menyimpan salinan `gambar.jpg` di dalam _cache_-nya. Saat pengguna lain di London meminta gambar yang sama, PoP akan langsung menyajikannya dari cache lokalnya, yang jauh lebih cepat.
4.  **Edge Computing:** CDN modern lebih dari sekadar caching. Mereka bisa menjalankan logika di _edge_ (di PoP). OpenResty memungkinkan Anda melakukan ini: memanipulasi gambar, menjalankan A/B testing, atau bahkan menerapkan logika keamanan langsung di server yang paling dekat dengan pengguna, tanpa harus bolak-balik ke server asal.

**Implementasi dengan OpenResty:**
Fungsi inti dari sebuah PoP CDN adalah _caching proxy_, dan OpenResty sangat ahli dalam hal ini menggunakan modul `ngx_http_proxy_module`.

**Contoh Sintaks (Konfigurasi Caching Proxy Sederhana):**

```nginx
# nginx.conf
http {
    # Definisikan path, ukuran, dan parameter cache
    # "my_cache" adalah nama cache, /var/cache/nginx adalah lokasi di disk
    # keys_zone=my_cache:10m -> alokasikan 10MB di memori untuk menyimpan kunci cache
    # inactive=60m -> hapus item dari cache jika tidak diakses selama 60 menit
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m inactive=60m;

    server {
        listen 80;

        # Ini adalah server Edge (PoP) kita

        location / {
            # Gunakan cache bernama "my_cache"
            proxy_cache my_cache;

            # Kunci unik untuk setiap item di cache (berdasarkan skema, host, dan URI)
            proxy_cache_key "$scheme$host$request_uri";

            # Anggap respons dengan status 200, 301, 302 valid untuk di-cache selama 1 jam
            proxy_cache_valid 200 301 302 1h;

            # Teruskan request ke server asal jika terjadi cache miss
            proxy_pass http://my-origin-server.com;

            # Tambahkan header untuk melihat status cache (HIT, MISS, BYPASS)
            add_header X-Cache-Status $upstream_cache_status;
        }
    }
}
```

**Sumber Referensi:**

- Kasus Penggunaan CDN dengan OpenResty: [OpenResty Solutions - CDN](https://openresty.com/en/solutions/)

---

Modul ini menunjukkan bahwa OpenResty bukan hanya sebuah alat, melainkan sebuah platform serbaguna yang dapat menjadi tulang punggung bagi komponen-komponen paling kritis dalam infrastruktur internet modern.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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
