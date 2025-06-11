
Kini kita sampai pada **Modul 8: Testing dan Quality Assurance**. Menulis kode yang berfungsi hanyalah separuh dari pekerjaan. Separuh lainnya, yang tak kalah penting, adalah memastikan kode tersebut bekerja dengan benar, konsisten, dan tidak mudah rusak saat ada perubahan di masa depan. Modul ini adalah tentang membangun jaring pengaman untuk kualitas kode Anda.

-----

### **[Modul 8: Testing dan Quality Assurance][0]**

**Tujuan Modul:** Menguasai teknik dan alat untuk menguji aplikasi OpenResty secara otomatis, memastikan kualitas kode, dan menjaga stabilitas proyek seiring waktu.

\<div id="modul-8-1"\>\</div\>

#### **8.1 Unit Testing dengan Test::Nginx**

**Deskripsi Konkret:**
**Unit testing** adalah proses menguji "unit" atau bagian terkecil dari kode Anda (misalnya, satu fungsi Lua) secara terisolasi untuk memastikan ia bekerja sesuai harapan. Di dunia OpenResty, alat standar emas untuk ini adalah **`Test::Nginx`**.

`Test::Nginx` adalah sebuah framework testing yang sangat kuat dan unik. Alih-alih menulis tes dalam Lua, Anda menulisnya dalam file `.t` yang bersifat **deklaratif**. Anda mendeklarasikan konfigurasi NGINX mini untuk tes tersebut, request yang ingin Anda kirim, dan respons (atau log error) yang Anda harapkan. Ini memungkinkan Anda menguji tidak hanya logika Lua, tetapi juga bagaimana logika tersebut berinteraksi dengan konfigurasi NGINX.

**Konsep Kunci: Anatomi File Tes `Test::Nginx`**
Sebuah file tes (misalnya, `my_test.t`) adalah skrip Perl, tetapi Anda tidak perlu tahu banyak tentang Perl untuk menggunakannya. Anda hanya perlu memahami "blok" data yang dipisahkan oleh `---`.

  * `--- config`: Berisi potongan `nginx.conf` yang diperlukan khusus untuk tes ini. Di sinilah Anda mendefinisikan `location` dan memanggil kode Lua Anda.
  * `--- request`: Mendefinisikan request HTTP yang akan dikirim ke server tes. (Contoh: `GET /my_location`).
  * `--- response_body`: Mendefinisikan isi body dari respons yang Anda harapkan. Tes akan berhasil jika body respons sama persis.
  * `--- status`: Mendefinisikan kode status HTTP yang diharapkan (misal: `200`, `404`, `500`).
  * `--- response_headers`: Mendefinisikan header yang Anda harapkan ada di respons.
  * `--- error_log`: Mendefinisikan pesan yang Anda harapkan muncul di log error NGINX. Ini sangat berguna untuk menguji kasus-kasus kegagalan.

**Konsep Kunci: Mocking dan Fixtures**
Dalam unit testing, Anda ingin menguji satu hal saja. Jika fungsi Anda bergantung pada database atau API eksternal, Anda tidak ingin tes Anda gagal hanya karena database sedang down. **Mocking** adalah teknik mengganti dependensi nyata dengan versi palsu yang terkontrol. Di `Test::Nginx`, cara termudah untuk melakukan ini adalah dengan membuat `location` palsu.

**Contoh Sintaks (Menguji Fungsi Penjumlahan):**
Misalkan kita punya fungsi Lua di `app/math.lua` yang menjumlahkan dua angka dari query string.

**File `app/math.lua`:**

```lua
local _M = {}

function _M.add_from_query()
    local args = ngx.req.get_uri_args()
    local a = tonumber(args.a)
    local b = tonumber(args.b)

    if not a or not b then
        ngx.status = 400
        ngx.say("Parameter 'a' dan 'b' wajib ada dan harus berupa angka.")
        return
    end

    ngx.say(a + b)
end

return _M
```

**File Tes `tests/math.t`:**

```perl
# vim:set ft=perl:

# Memuat Test::Nginx framework
use Test::Nginx::Socket 'no_plan';

# Menjalankan tes
run_tests();

# --- BLOCK 1: Tes kasus sukses ---
__DATA__

=== TEST 1: Penjumlahan dua angka positif
--- config
    location /add {
        content_by_lua_block {
            require("app.math").add_from_query()
        }
    }
--- request
    GET /add?a=10&b=5
--- response_body
15
--- status: 200

=== TEST 2: Tes kasus parameter tidak ada
--- config
    location /add {
        content_by_lua_block {
            require("app.math").add_from_query()
        }
    }
--- request
    GET /add?a=10
--- response_body
Parameter 'a' dan 'b' wajib ada dan harus berupa angka.
--- status: 400
--- error_log
[error]
```

Untuk menjalankan tes ini, Anda menggunakan `prove` command-line tool dari direktori proyek Anda.

**Sumber Referensi:**

  * Bab Testing dari buku Programming OpenResty: [Programming OpenResty - Testing](https://openresty.gitbooks.io/programming-openresty/content/testing/)

\<div id="modul-8-2"\>\</div\>

#### **8.2 Integration Testing**

**Deskripsi Konkret:**
Jika unit test menguji bagian-bagian kecil secara terisolasi, **integration test** menguji bagaimana bagian-bagian tersebut bekerja sama. Tujuannya adalah untuk menemukan masalah di "jahitan" atau titik integrasi antar komponen, misalnya:

  * Apakah modul Lua Anda bisa berkomunikasi dengan benar dengan database Redis yang sesungguhnya?
  * Apakah API Gateway Anda bisa meneruskan request ke layanan backend dengan benar?
  * Apakah alur otentikasi JWT bekerja dari ujung ke ujung?

**Konsep Kunci: End-to-End (E2E) Testing**
Ini adalah bentuk integration testing di mana Anda mensimulasikan alur kerja pengguna secara lengkap. `Test::Nginx` juga bisa digunakan untuk ini, tetapi konfigurasinya akan lebih kompleks, melibatkan `upstream` block, koneksi ke database (yang mungkin berjalan di dalam Docker container), dll.

**Konsep Kunci: Load Testing & Benchmarking**
Ini adalah jenis pengujian non-fungsional yang fokus pada performa.

  * **Load Testing**: Mengukur bagaimana sistem Anda berperilaku di bawah beban kerja yang berat. Tujuannya adalah untuk menemukan batas kapasitas sistem Anda dan mengidentifikasi *bottleneck*. Alat yang populer untuk ini adalah `wrk`, `ab` (Apache Bench), atau `k6`.
  * **Benchmarking**: Proses membandingkan performa dari dua atau lebih implementasi yang berbeda untuk melihat mana yang lebih cepat, atau untuk melacak regresi performa dari waktu ke waktu.

**Contoh Sintaks (Load Testing dengan `wrk`):**
`wrk` adalah alat load testing modern yang sangat efisien. Anda tidak menuliskannya dalam file `.t`, melainkan menjalankannya dari baris perintah terhadap server OpenResty Anda yang sedang berjalan.

```bash
# Menjalankan tes ke endpoint /api/products
# -t4: menggunakan 4 thread
# -c200: mensimulasikan 200 koneksi bersamaan
# -d30s: menjalankan tes selama 30 detik

wrk -t4 -c200 -d30s http://localhost:8080/api/products
```

Hasilnya akan memberikan Anda metrik penting seperti **Requests/sec** (throughput) dan **Latency** (waktu respons).

**Sumber Referensi:**

  * Framework `Test::Nginx` di GitHub: [GitHub - openresty/test-nginx](https://github.com/openresty/test-nginx)

\<div id="modul-8-3"\>\</div\>

#### **8.3 Code Quality dan Linting**

**Deskripsi Konkret:**
Kualitas kode bukan hanya tentang apakah kode itu berjalan atau tidak. Kode yang berkualitas juga harus **mudah dibaca, konsisten, dan mudah dipelihara**. Ini sangat penting saat bekerja dalam tim atau saat Anda kembali melihat kode Anda sendiri enam bulan kemudian.

**Konsep Kunci: Code Style Guidelines**
Memiliki gaya penulisan kode yang konsisten di seluruh proyek (misalnya, cara menempatkan spasi, penamaan variabel, panjang baris) membuat kode lebih mudah dipahami secara visual. Proyek-proyek OpenResty yang matang memiliki panduan gaya mereka sendiri.

**Konsep Kunci: Static Analysis & Linting**
**Linter** adalah sebuah program yang menganalisis kode sumber Anda (tanpa menjalankannya) untuk menemukan potensi masalah, seperti:

  * Kesalahan sintaks.
  * Variabel yang tidak pernah digunakan.
  * Penggunaan variabel global yang tidak disengaja (ini adalah sumber bug yang umum).
  * Pelanggaran terhadap panduan gaya (misalnya, inkonsistensi spasi).

Alat linter paling populer untuk Lua adalah **`luacheck`**. Menjalankan linter secara teratur (atau secara otomatis sebelum setiap *commit*) adalah praktik yang sangat baik.

**Contoh Penggunaan `luacheck`:**
Misalkan Anda punya kode yang "berantakan":

**File `bad_code.lua`:**

```lua
-- Menggunakan variabel global 'data' secara tidak sengaja
data = {nama="test"}

function getUser (id) -- Nama fungsi tidak konsisten
    local user_info=data[id] -- Spasi tidak konsisten
    return user_info
end
```

Jika Anda menjalankan `luacheck bad_code.lua` di terminal, Anda mungkin akan mendapatkan output seperti:

```
bad_code.lua:2:1: setting non-standard global variable 'data'
bad_code.lua:4:1: accessing non-standard global variable 'ngx'
...
```

Perhatikan bahwa `luacheck` secara default tidak tahu tentang variabel global OpenResty seperti `ngx`. Kita perlu memberitahunya.

**File `.luacheckrc` (untuk konfigurasi `luacheck`):**
Letakkan file ini di root direktori proyek Anda.

```
-- Memberitahu luacheck tentang variabel global yang sah dari OpenResty
globals = {
  "ngx"
}
```

**Kode yang Sudah Diperbaiki (`good_code.lua`):**

```lua
local data = { nama = "test" }

local function get_user(id)
    local user_info = data[id]
    return user_info
end

return {
    get_user = get_user
}
```

Menjalankan `luacheck` pada file ini (dengan `.luacheckrc` yang benar) tidak akan menghasilkan peringatan apa pun.

**Sumber Referensi:**

  * Panduan Gaya Kontribusi untuk `lua-resty-core` (contoh style guide yang baik): [OpenResty Style Guide](https://github.com/openresty/lua-resty-core/blob/master/CONTRIBUTING.md)

-----

Dengan menerapkan praktik-praktik dalam Modul 8, Anda membangun kepercayaan diri pada kode Anda. Anda tahu bahwa kode itu tidak hanya berfungsi sekarang, tetapi juga memiliki fondasi yang kuat untuk dikembangkan lebih lanjut di masa depan.

Selanjutnya, kita akan menyelami topik yang paling dicari: **Modul 9: Performance Optimization**, di mana kita akan belajar cara membuat aplikasi kita berjalan secepat mungkin.
#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

<!----------------------------------------------------->

[0]: ../README.md#modul-8-testing-dan-quality-assurance
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
