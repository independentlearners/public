# **[Modul 6: Advanced Features][0]**

Modul ini akan memperluas kemampuan aplikasi kita dari sekadar API JSON menjadi platform web yang lebih kaya fitur, mampu menyajikan halaman HTML dinamis, berkomunikasi secara _real-time_, dan menangani unggahan file dari pengguna.

**Tujuan Modul:** Mengimplementasikan fungsionalitas web tingkat lanjut di atas OpenResty, termasuk rendering sisi-server, komunikasi dua-arah dengan WebSocket, dan pemrosesan file upload.

#### **6.1 Templating dan View Rendering**

**Deskripsi Konkret:**
Sejauh ini kita fokus pada API yang mengembalikan data mentah dalam format JSON. Namun, OpenResty juga sangat mampu untuk menghasilkan halaman web HTML secara langsung di server. Proses ini disebut **Server-Side Rendering (SSR)**. Library standar untuk melakukan ini di ekosistem OpenResty adalah `lua-resty-template`.

**Konsep Kunci: Server-Side Rendering (SSR)**

- **Apa itu SSR?** Server menerima sebuah request, mengambil data yang diperlukan (dari database atau API lain), lalu "merakit" halaman HTML lengkap dengan data tersebut di dalamnya, dan mengirimkan HTML jadi ini ke browser.
- **Perbedaannya dengan Client-Side Rendering (CSR):** Dalam model CSR (umum pada framework seperti React, Vue, Angular), server hanya mengirimkan shell HTML kosong dan data JSON. Browser kemudian menggunakan JavaScript untuk merakit halaman HTML.
- **Keunggulan SSR:**
  - **SEO (Search Engine Optimization) yang lebih baik:** Mesin pencari seperti Google bisa dengan mudah membaca konten karena HTML sudah lengkap saat diterima.
  - **First Contentful Paint (FCP) lebih cepat:** Pengguna melihat konten halaman lebih cepat karena browser tidak perlu menunggu JavaScript diunduh dan dieksekusi untuk menampilkan konten awal.

**Terminologi Kunci: `lua-resty-template`**
Ini adalah _template engine_ yang memungkinkan Anda menyisipkan logika Lua di dalam file HTML. Sintaksnya sengaja dibuat mirip dengan template engine populer lainnya.

- `{{ variable }}`: Mencetak isi variabel (dengan _HTML escaping_ secara default untuk mencegah serangan XSS).
- `{* variable *}`: Mencetak isi variabel tanpa _HTML escaping_ (gunakan dengan hati-hati).
- `{% lua code %}`: Menjalankan blok kode Lua, seperti `if-else`, `for loop`, dll.

**Contoh Sintaks (Menampilkan Daftar Produk):**
Pertama, kita siapkan file template HTML-nya.

**File `templates/product_list.html`:**

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>{{ title }}</title>
  </head>
  <body>
    <h1>Selamat datang di {{ page_name }}</h1>

    {% if #products > 0 then %}
    <p>Berikut adalah daftar produk kami:</p>
    <ul>
      {% for i, product in ipairs(products) do %}
      <li><strong>{{ product.name }}</strong> - Rp {{ product.price }}</li>
      {% end %}
    </ul>
    {% else %}
    <p>Maaf, tidak ada produk untuk ditampilkan saat ini.</p>
    {% end %}
  </body>
</html>
```

Selanjutnya, konfigurasi NGINX dan kode Lua untuk merender template ini.

**`nginx.conf`:**

```nginx
# nginx.conf
http {
    server {
        listen 8080;

        # Tentukan root direktori agar template bisa ditemukan
        root /path/to/your/project/;

        location /products-page {
            default_type 'text/html';

            content_by_lua_block {
                local template = require "resty.template"

                -- Di dunia nyata, data ini datang dari database
                local data = {
                    title = "Halaman Produk",
                    page_name = "Toko Serba Ada",
                    products = {
                        { name = "Buku OpenResty", price = 150000 },
                        { name = "Stiker Lua", price = 10000 },
                        { name = "Kaos NGINX", price = 120000 }
                    }
                }

                -- Render template dengan data
                -- Pastikan path ke template benar relatif terhadap 'root'
                template.render("templates/product_list.html", data)
            }
        }
    }
}
```

Ketika Anda mengakses `http://localhost:8080/products-page`, OpenResty akan menjalankan kode Lua, memuat `product_list.html`, menggabungkannya dengan `data`, dan mengirimkan HTML yang sudah jadi ke browser Anda.

**Sumber Referensi:**

- Library Templating: [GitHub - lua-resty-template](https://github.com/bungle/lua-resty-template)

#### **6.2 WebSocket Support**

**Deskripsi Konkret:**
HTTP adalah protokol yang luar biasa, tetapi ia bersifat _request-response_. Client meminta, server merespons, lalu koneksi ditutup. Ini tidak efisien untuk aplikasi yang butuh komunikasi _real-time_ (misalnya: aplikasi chat, notifikasi live, dashboard monitoring, game multiplayer).

**WebSocket** adalah protokol berbeda yang dirancang untuk mengatasi masalah ini. Ia menyediakan sebuah **koneksi yang persisten dan dua-arah (full-duplex)** antara client dan server. Setelah koneksi dibuka, server bisa mengirim data ke client kapan saja tanpa harus menunggu client memintanya, dan sebaliknya.

**Konsep Kunci: The WebSocket Handshake**
Sebuah koneksi WebSocket secara cerdik dimulai sebagai request HTTP biasa.

1.  Client mengirim request `GET` ke server, tetapi dengan beberapa header khusus: `Upgrade: websocket` dan `Connection: Upgrade`.
2.  Jika server mendukung WebSocket, ia akan merespons dengan status `101 Switching Protocols`.
3.  Setelah itu, koneksi TCP yang sama yang digunakan untuk HTTP tadi "diambil alih" dan diubah menjadi koneksi WebSocket yang permanen, siap untuk pertukaran data dua arah.

**Implementasi dengan `lua-resty-websocket`:**
Library ini menyediakan semua yang kita butuhkan untuk mengelola sisi server dari koneksi WebSocket.

**Contoh Sintaks (Server Echo Sederhana):**
Server ini akan mengirim kembali pesan apa pun yang diterimanya dari client.

```nginx
# nginx.conf
http {
    server {
        listen 8080;
        location /ws/echo {
            content_by_lua_block {
                local server = require "resty.websocket.server"

                -- 1. Lakukan handshake
                local wb, err = server:new{
                    timeout = 5000, -- 5 detik timeout
                    max_payload_len = 65535
                }
                if not wb then
                    ngx.log(ngx.ERR, "Gagal melakukan handshake websocket: ", err)
                    ngx.exit(400) -- Bad Request
                end

                ngx.log(ngx.INFO, "Koneksi WebSocket berhasil dibuat.")

                -- 2. Masuk ke loop untuk menerima dan mengirim pesan
                while true do
                    -- Menerima data (frame) dari client. Ini adalah operasi non-blocking.
                    local data, typ, err = wb:recv_frame()

                    if not data then
                        ngx.log(ngx.ERR, "Gagal menerima frame: ", err)
                        -- Jika koneksi ditutup oleh client, `err` akan berisi "closed"
                        if string.find(err, "closed") then
                            break -- Keluar dari loop
                        end
                    end

                    -- Jika client mengirim 'close' frame
                    if typ == "close" then
                        -- Jawab dengan 'close' frame juga (bagian dari protokol)
                        wb:send_close()
                        break
                    end

                    -- Jika ping dari client, library akan otomatis membalas dengan pong
                    if typ == "ping" then
                        ngx.log(ngx.INFO, "Menerima ping, membalas dengan pong.")

                    -- Jika pesan teks, kirim kembali (echo)
                    elseif typ == "text" then
                        ngx.log(ngx.INFO, "Menerima pesan: ", data)
                        local bytes, err = wb:send_text("Server echoback: " .. data)
                        if not bytes then
                            ngx.log(ngx.ERR, "Gagal mengirim pesan: ", err)
                            break
                        end
                    end
                end
            }
        }
    }
}
```

Anda bisa menguji endpoint ini menggunakan tool client WebSocket sederhana atau dengan beberapa baris JavaScript di console browser.

**Sumber Referensi:**

- Library WebSocket: [GitHub - lua-resty-websocket](https://github.com/openresty/lua-resty-websocket)

#### **6.3 File Upload dan Processing**

**Deskripsi Konkret:**
Aplikasi web seringkali butuh fungsionalitas bagi pengguna untuk mengunggah file (misalnya: foto profil, dokumen, dll.). File ini biasanya dikirim dari browser menggunakan form HTML dengan encoding `multipart/form-data`. OpenResty bisa menangani ini dengan sangat efisien, terutama untuk file berukuran besar, dengan memprosesnya secara _streaming_.

**Terminologi Kunci:**

- **`multipart/form-data`:** Sebuah format request HTTP yang memungkinkan pengiriman file bersamaan dengan data form lainnya dalam satu request. Request dibagi menjadi beberapa "bagian" (parts), masing-masing dengan header dan body-nya sendiri.
- **Streaming vs. Buffering:**
  - **Buffering:** OpenResty menunggu seluruh file selesai diunggah dan menyimpannya di memori atau file temporer, baru kemudian menyerahkannya ke skrip Lua Anda. Ini mudah, tetapi boros memori dan tidak cocok untuk file besar.
  - **Streaming:** Skrip Lua Anda menerima file dalam bentuk "potongan" (chunks) saat file tersebut sedang diunggah. Ini sangat efisien dari segi memori dan merupakan cara yang direkomendasikan untuk menangani file upload.

**Implementasi dengan `lua-resty-upload`:**
Library `lua-resty-upload` tidak termasuk dalam bundel OpenResty, jadi Anda perlu menginstalnya (misalnya dengan OPM). Namun, NGINX sendiri punya modul upload bawaan, dan kita juga bisa menggunakan `ngx.req` API untuk parsing manual. Untuk kesederhanaan, kita akan lihat contoh menggunakan `lua-resty-upload` yang menyederhanakan proses streaming.

**Contoh Sintaks (Menyimpan File Upload):**

```nginx
# nginx.conf
# Pastikan Anda punya direktori /tmp/uploads dan NGINX punya izin tulis ke sana.
location /upload {
    # File bisa berukuran besar, jadi set client_max_body_size
    client_max_body_size 100M;

    content_by_lua_block {
        local upload = require "resty.upload"
        local cjson = require "cjson"

        -- Buat instance dengan chunk size 8KB
        local form, err = upload:new(8192)
        if not form then
            ngx.log(ngx.ERR, "Gagal membuat form upload: ", err)
            ngx.exit(500)
        end

        local file_path

        while true do
            -- Baca request secara streaming
            local chunk, err = form:read()
            if not chunk then
                ngx.log(ngx.ERR, "Gagal membaca form: ", err)
                ngx.exit(500)
            end

            -- Jika 'type' adalah header, kita bisa mendapatkan nama field dan nama file
            if chunk.type == "header" then
                -- chunk[1] berisi nama field, chunk[2] berisi info, termasuk filename
                if chunk[1] == "file_upload" and chunk[2].filename then
                    local filename = chunk[2].filename
                    -- Buat path file yang aman dan unik
                    file_path = "/tmp/uploads/" .. ngx.now() .. "-" .. filename

                    -- Buka file untuk ditulis (mode 'w' untuk write, 'b' untuk binary)
                    local file, err = io.open(file_path, "wb")
                    if not file then
                        ngx.log(ngx.ERR, "Gagal membuka file untuk ditulis: ", err)
                        ngx.exit(500)
                    end
                    form:set_file(file) -- Arahkan body part berikutnya untuk ditulis ke file ini
                end
            end

            -- Jika sudah tidak ada chunk lagi (end of stream)
            if chunk.type == "eof" then
                break
            end
        end

        -- Ambil data form lainnya
        local form_data = form:get_body_data()

        ngx.say("Upload selesai!\n")
        ngx.say("File disimpan di: ", file_path, "\n")
        ngx.say("Data form lainnya: ", cjson.encode(form_data))
    }
}
```

HTML form untuk menguji ini akan terlihat seperti:

```html
<form action="/upload" method="post" enctype="multipart/form-data">
  Deskripsi: <input type="text" name="description" /><br />
  File: <input type="file" name="file_upload" /><br />
  <input type="submit" value="Upload" />
</form>
```

**Sumber Referensi:**

- Library Upload: [GitHub - lua-resty-upload](https://github.com/openresty/lua-resty-upload)

---

Setelah menguasai modul ini, aplikasi OpenResty Anda tidak lagi terbatas pada API JSON. Anda bisa membangun aplikasi web interaktif yang kaya fitur, efisien, dan skalabel.

#

Selanjutnya, kita akan beralih ke **Modul 7: Custom Modules dan Libraries**, di mana kita akan belajar cara mengorganisir kode kita dengan lebih baik dan mengintegrasikan dengan library C untuk performa maksimal.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
