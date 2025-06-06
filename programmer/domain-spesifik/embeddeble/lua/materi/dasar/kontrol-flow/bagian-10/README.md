
## 📚 **Bagian 10: Pola Kontrol Alur di Framework Populer (Tambahan)**

Bagian ini ditambahkan untuk menunjukkan bagaimana konsep kontrol alur abstrak (seperti _event loop_ dan _non-blocking I/O_ berbasis coroutine) diwujudkan dalam pustaka dan framework dunia nyata.

### Deskripsi Konkret

Melihat implementasi nyata akan memperkuat pemahaman Anda dan menunjukkan bagaimana teori diterapkan dalam praktik untuk membangun aplikasi berperforma tinggi.

#### **10.1 Event Loop di LÖVE 2D**

- **Deskripsi**: Framework game LÖVE 2D mengimplementasikan _game loop_ klasik, yang merupakan bentuk dari _event loop_. LÖVE menangani loop utama secara internal dan menyediakan fungsi _callback_ yang Anda implementasikan untuk menyisipkan logika Anda.
- **Pola Kontrol Alur**:
  - `love.load()`: Dipanggil sekali saat game dimulai. Digunakan untuk inisialisasi state, memuat aset. Ini adalah **titik masuk** utama.
  - `love.update(dt)`: Dipanggil berulang kali di setiap frame. `dt` (delta time) adalah waktu sejak frame terakhir. Semua pembaruan logika game (pergerakan, fisika, perubahan state) terjadi di sini. Ini adalah **loop utama** untuk logika.
  - `love.draw()`: Dipanggil setelah `update` di setiap frame. Digunakan untuk menggambar semua objek ke layar. Ini adalah **loop utama** untuk rendering.
  - `love.keypressed(key)`, `love.mousepressed(x, y, button)`: Ini adalah _callback_ penangan event. Mereka dipanggil oleh loop internal LÖVE ketika event yang sesuai terjadi. Ini adalah implementasi dari **Observer pattern**.

#### **10.2 Kontrol Alur Non-Blocking di OpenResty**

- **Deskripsi**: OpenResty adalah platform web yang dibangun di atas NGINX dan LuaJIT. Ia menggunakan "cosockets" yang mengimplementasikan I/O non-blocking secara transparan.
- **Pola Kontrol Alur**:

  - **Synchronous-Style Coding**: Pengembang menulis kode I/O (misalnya, koneksi database, panggilan API eksternal) seolah-olah itu sinkron dan memblokir.

    ```lua
    -- Kode di OpenResty
    local http = require "resty.http"
    local httpc = http.new()

    -- Panggilan ini TERLIHAT memblokir, tapi sebenarnya tidak.
    local res, err = httpc:request_uri("http://example.com/")

    if not res then
        ngx.say("gagal: ", err)
        return
    end

    ngx.say(res.body)
    ```

  - **Mekanisme di Balik Layar**: Ketika `httpc:request_uri` dipanggil, ia memulai operasi jaringan non-blocking. Kemudian, ia secara otomatis memanggil `coroutine.yield()` untuk menjeda coroutine saat ini dan mengembalikan kontrol ke scheduler NGINX. Scheduler NGINX dapat menangani ribuan koneksi lain sementara menunggu respons jaringan ini. Ketika respons tiba, scheduler secara otomatis memanggil `coroutine.resume()` pada coroutine yang dijeda dengan data respons, dan eksekusi kode Anda berlanjut dari baris berikutnya seolah-olah tidak ada jeda.
  - **Manfaat**: Ini adalah contoh sempurna dari penerapan coroutine untuk menyederhanakan pemrograman asinkron, seperti yang dibahas di Bagian 6.3.

#### **Sumber Belajar (Tambahan)**:

- [LÖVE 2D Wiki: love](https://love2d.org/wiki/love)
- [OpenResty Getting Started](https://openresty.org/en/getting-started.html)

---
