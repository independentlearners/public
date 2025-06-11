Kita sekarang memasuki **Modul 7: Custom Modules dan Libraries**. Setelah belajar membangun fungsionalitas, langkah selanjutnya dalam menjadi developer yang mahir adalah belajar mengorganisir kode secara efektif dan memanfaatkan ekosistem library yang ada. Modul ini adalah tentang membuat kode kita bersih, dapat digunakan kembali (_reusable_), dan berperforma tinggi dengan mengintegrasikan kode C.

---

# **[Modul 7: Custom Modules dan Libraries][0]**

**Tujuan Modul:** Mampu menstrukturkan kode ke dalam modul Lua yang dapat digunakan kembali, mengintegrasikan library C berperforma tinggi menggunakan FFI, serta mengelola dependensi proyek menggunakan manajer paket standar.

\<div id="modul-7-1"\>\</div\>

#### **7.1 Creating Custom Lua Modules**

**Deskripsi Konkret:**
Seiring aplikasi Anda tumbuh lebih kompleks, meletakkan semua logika di dalam blok `content_by_lua_block` atau dalam satu file Lua raksasa akan menjadi mimpi buruk untuk dipelihara. **Modules** adalah cara standar di Lua untuk memecah kode Anda menjadi file-file yang lebih kecil, logis, dan dapat digunakan kembali.

Anggap saja ini seperti membuat `class` atau `service` Anda sendiri di dunia OOP. Anda mengelompokkan fungsi-fungsi yang terkait ke dalam satu unit yang kohesif.

**Konsep Kunci: Pola Modul Lua**
Pola yang paling umum dan direkomendasikan untuk membuat modul di Lua adalah sebagai berikut:

1.  Buat sebuah tabel lokal di awal file, biasanya dinamai `_M`.
2.  Tambahkan semua fungsi dan variabel publik Anda ke dalam tabel `_M` tersebut.
3.  Di baris paling akhir file, kembalikan (return) tabel `_M`.

**Konsep Kunci: `require()` dan `package.path`**

- **`require("nama.modul")`**: Ini adalah fungsi global di Lua untuk memuat modul. Saat dipanggil, Lua akan mencari file yang sesuai (misalnya `nama/modul.lua`), menjalankannya _satu kali saja_, dan menyimpan hasilnya (tabel `_M` yang di-return) dalam sebuah cache. Panggilan `require` berikutnya untuk modul yang sama akan langsung mengembalikan hasil dari cache tanpa menjalankan ulang file tersebut.
- **`lua_package_path`**: Ini adalah direktif di `nginx.conf` yang memberitahu OpenResty di mana harus mencari file-file modul Lua Anda, selain di direktori standar. Anda menambahkan path ke direktori proyek Anda di sini.

**Contoh Sintaks (Membuat Modul Utilitas):**
Mari kita buat modul `utils.lua` yang berisi fungsi-fungsi pembantu.

**Struktur Direktori:**

```
/path/to/your/project/
├── app/
│   └── utils.lua
└── nginx.conf
```

**File `app/utils.lua`:**

```lua
-- 1. Buat tabel lokal untuk modul
local _M = {}

-- Variabel "private" (lokal untuk file ini)
local APP_VERSION = "1.0.2"

-- Fungsi "publik" yang ditambahkan ke tabel _M
function _M.generate_request_id()
    -- Menghasilkan ID unik sederhana untuk logging
    return ngx.now() .. "-" .. math.random(1000, 9999)
end

function _M.get_app_version()
    return APP_VERSION
end

-- Fungsi yang menerima argumen
function _M.sapa(nama)
    if not nama then
        return "Halo, dunia!"
    end
    return "Halo, " .. nama .. "!"
end

-- 3. Kembalikan tabel modul di akhir file
return _M
```

**Cara Menggunakannya di `nginx.conf`:**

```nginx
# nginx.conf
http {
    # Beritahu OpenResty di mana harus mencari modul kita.
    # ';;' artinya "cari juga di path default setelahnya".
    # '?' akan diganti dengan nama modul.
    lua_package_path "/path/to/your/project/?.lua;;";

    server {
        listen 8080;
        location /test-module {
            content_by_lua_block {
                -- Muat modul kita. Tanda '.' di 'app.utils' akan menjadi pemisah direktori '/'
                local utils = require "app.utils"
                local cjson = require "cjson"

                local response_data = {
                    request_id = utils.generate_request_id(),
                    app_version = utils.get_app_version(),
                    sapaan = utils.sapa("Budi")
                }

                ngx.header.content_type = "application/json"
                ngx.say(cjson.encode(response_data))
            }
        }
    }
}
```

**Sumber Referensi:**

- Blog OpenResty tentang Menulis Modul: [OpenResty Blog - Writing Reusable Code Modules in Lua for OpenResty](https://blog.openresty.com/en/or-lua-module/)

\<div id="modul-7-2"\>\</div\>

#### **7.2 C Module Integration (FFI)**

**Deskripsi Konkret:**
Ini adalah salah satu fitur paling kuat dari OpenResty, berkat **LuaJIT**. Terkadang, ada tugas yang sangat intensif secara komputasi (misalnya, enkripsi kompleks, pemrosesan gambar, parsing format biner) yang mungkin berjalan lambat jika ditulis dalam Lua murni. Di sisi lain, mungkin sudah ada library C yang sangat cepat dan teruji untuk melakukan tugas tersebut.

**FFI (Foreign Function Interface)** memungkinkan kode Lua Anda untuk memanggil fungsi yang ditulis dalam bahasa C secara langsung, tanpa perlu menulis kode "lem" (glue code) yang rumit. Anda cukup mendeklarasikan "prototipe" atau "tanda tangan" fungsi C tersebut di dalam Lua.

**Konsep Kunci: Proses FFI**

1.  **Tulis Kode C**: Anda memiliki kode C (`.c`) yang berisi fungsi yang ingin Anda panggil.
2.  **Kompilasi menjadi Shared Library**: Anda mengkompilasi kode C tersebut menjadi sebuah _shared library_ (file `.so` di Linux, `.dylib` di macOS, `.dll` di Windows).
3.  **Deklarasikan di Lua (`ffi.cdef`)**: Di dalam skrip Lua Anda, Anda memberitahu FFI tentang fungsi-fungsi C yang ada di dalam shared library tersebut, termasuk tipe argumen dan tipe nilai kembaliannya.
4.  **Load Library (`ffi.load`)**: Anda memuat file shared library tersebut.
5.  **Panggil Fungsi**: Anda bisa memanggil fungsi C tersebut seolah-olah itu adalah fungsi Lua biasa.

**Contoh Sintaks (Memanggil Fungsi Penjumlahan Sederhana dari C):**

**Langkah 1 & 2: Buat dan Kompilasi Kode C**

**File `my_math.c`:**

```c
// Fungsi sederhana untuk demonstrasi
int add_numbers(int a, int b) {
    return a + b;
}
```

**Kompilasi di terminal:**

```bash
# -shared: buat shared library, -fPIC: Position-Independent Code
gcc -shared -fPIC -o my_math.so my_math.c
```

Sekarang Anda punya file `my_math.so`.

**Langkah 3, 4 & 5: Panggil dari Lua**

```nginx
# nginx.conf
http {
    server {
        listen 8080;
        location /test-ffi {
            content_by_lua_block {
                -- 1. Muat library FFI
                local ffi = require "ffi"

                -- 2. Deklarasikan tanda tangan fungsi C
                ffi.cdef[[
                    int add_numbers(int a, int b);
                ]]

                -- 3. Muat shared library yang sudah dikompilasi
                -- Pastikan path ke my_math.so benar
                local my_lib = ffi.load("./my_math.so")

                -- 4. Panggil fungsi C!
                local result = my_lib.add_numbers(40, 2)

                ngx.say("Hasil dari fungsi C: ", result)
            }
        }
    }
}
```

Meskipun contoh ini trivial, bayangkan jika `add_numbers` adalah fungsi enkripsi yang kompleks. Keuntungan performanya akan sangat signifikan.

**Sumber Referensi:**

- Dokumentasi LuaJIT FFI: [LuaJIT FFI Documentation](http://luajit.org/ext_ffi.html)

\<div id="modul-7-3"\>\</div\>

#### **7.3 Third-party Library Integration**

**Deskripsi Konkret:**
Prinsip "jangan menciptakan kembali roda" sangat berlaku di sini. Ekosistem OpenResty memiliki banyak sekali library pihak ketiga yang sudah siap pakai untuk berbagai keperluan, mulai dari driver database, JWT, client HTTP, hingga XML parser. Mengetahui di mana menemukan dan bagaimana mengevaluasi library-library ini adalah skill yang penting.

**Konsep Kunci: Kriteria Evaluasi Library**
Sebelum menambahkan library eksternal ke proyek Anda, ajukan pertanyaan-pertanyaan ini:

1.  **Apakah Non-Blocking?** Ini adalah kriteria **paling penting**. Apakah library tersebut menggunakan API Cosocket (`ngx.socket.tcp`, `ngx.sleep`, dll.) untuk semua operasi I/O? Jika ia menggunakan fungsi I/O standar Lua yang blocking (seperti `io.read` atau `socket.connect`), ia akan **memblokir worker NGINX** dan menghancurkan performa server Anda.
2.  **Seberapa Aktif Dipelihara?** Lihat repositori GitHub-nya. Kapan komit terakhir? Apakah _issues_ dijawab? Library yang terbengkalai bisa memiliki bug atau celah keamanan yang tidak diperbaiki.
3.  **Kualitas Dokumentasi dan Tes:** Apakah library memiliki dokumentasi yang jelas dan _test suite_ yang baik? Ini menunjukkan kualitas dan memudahkan Anda untuk menggunakannya.
4.  **Dependensi:** Apakah library ini memiliki banyak dependensi lain? Semakin banyak dependensi, semakin kompleks manajemen proyek Anda.

**Sumber Referensi:**

- **Awesome Resty**: Ini adalah daftar terkurasi yang wajib Anda bookmark. Berisi kumpulan library, driver, dan framework terbaik untuk OpenResty.
  - [GitHub - bungle/awesome-resty](https://github.com/bungle/awesome-resty)

\<div id="modul-7-4"\>\</div\>

#### **7.4 Package Management dan Distribution**

**Deskripsi Konkret:**
Setelah Anda mulai menggunakan beberapa library pihak ketiga, mengelola file-filenya secara manual (download zip, copy-paste) menjadi tidak efisien dan sulit direproduksi. **Manajer Paket (Package Manager)** mengotomatiskan proses pengunduhan, instalasi, dan pengelolaan versi dari library-library ini.

**Terminologi Kunci: OPM dan LuaRocks**
Ada dua manajer paket utama yang relevan untuk OpenResty:

1.  **OPM (OpenResty Package Manager)**

    - Ini adalah manajer paket resmi dari OpenResty Inc.
    - Didesain khusus untuk OpenResty, artinya paket-paket yang ada di repositori OPM (`opm.openresty.org`) dijamin kompatibel dan non-blocking.
    - Sangat mudah digunakan dan merupakan pilihan utama untuk proyek OpenResty murni.
    - **Perintah dasar:** `opm get <nama-paket>` (misal: `opm get openresty/lua-resty-jwt`)

2.  **LuaRocks**

    - Ini adalah manajer paket untuk komunitas Lua secara umum, jauh lebih besar dan lebih tua dari OPM.
    - Memiliki ribuan modul, **TAPI** banyak di antaranya bersifat _blocking_ dan tidak cocok untuk OpenResty.
    - Anda harus sangat berhati-hati dan memastikan modul yang Anda instal dari LuaRocks dirancang untuk OpenResty (biasanya memiliki `lua-resty-` di namanya atau secara eksplisit menyebutkan kompatibilitas).
    - **Perintah dasar:** `luarocks install <nama-paket>` (misal: `luarocks install lua-resty-http`)

**Contoh Penggunaan:**

**Menggunakan OPM:**

```bash
# Menginstal library lua-resty-redis dari repositori resmi OpenResty
sudo opm get openresty/lua-resty-redis

# OPM akan otomatis menginstalnya ke direktori yang benar
# (misal: /usr/local/openresty/site/lualib/resty/redis.lua)
# Anda bisa langsung menggunakannya di kode dengan: require "resty.redis"
```

**Menggunakan LuaRocks (dengan hati-hati):**

```bash
# Menginstal library lua-resty-string
# Anda mungkin perlu memberitahu LuaRocks di mana instalasi OpenResty Anda berada
sudo luarocks install --tree=/usr/local/openresty/ lua-resty-string
```

**Sumber Referensi:**

- Dokumentasi OPM: [opm.openresty.org/docs](https://opm.openresty.org/docs)
- Mencari Modul OpenResty di LuaRocks: [LuaRocks - Label OpenResty](https://luarocks.org/labels/openresty)
- Artikel tentang Manajemen Paket: [How to Manage OpenResty Packages - API7.ai](https://api7.ai/learning-center/openresty/how-to-manage-openresty-packages)

---

Dengan menguasai Modul 7, Anda bertransisi dari seorang penulis skrip menjadi seorang arsitek perangkat lunak. Anda tahu cara membangun kode yang bersih dan terstruktur, bagaimana menembus batasan performa dengan C, dan bagaimana berdiri di atas pundak para raksasa dengan memanfaatkan ekosistem library yang luas secara efisien dan aman. Langkah selanjutnya adalah memastikan kode yang kita tulis berkualitas tinggi melalui **Modul 8: Testing dan Quality Assurance**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

<!----------------------------------------------------->

[0]: ../README.md#modul-7-custom-modules-dan-libraries
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
