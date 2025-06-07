# **[8. I/O dengan External Systems][0]**

Kemampuan sebuah bahasa skrip tidak hanya terbatas pada manipulasi file, tetapi juga pada kemampuannya untuk berinteraksi dengan program lain dan bahkan sistem di seluruh jaringan. Lua menyediakan mekanisme kuat untuk ini melalui _pipes_ dan dapat diperluas untuk I/O jaringan dengan pustaka eksternal.

### 8.1 Pipe Operations

**Deskripsi Konkret:**
Sebuah _pipe_ (pipa) adalah mekanisme komunikasi antar-proses yang disediakan oleh sistem operasi. Ia memungkinkan output standar (`stdout`) dari satu program untuk menjadi input standar (`stdin`) bagi program lain. Di Lua, fungsi `io.popen()` memungkinkan Anda untuk membuat pipe ini, menjalankan perintah eksternal, dan berkomunikasi dengannya seolah-olah itu adalah sebuah file.

**`io.popen()` untuk command execution:**

- **Konsep**: `io.popen()` (pipe open) menjalankan sebuah perintah sistem (seperti `ls`, `dir`, `sort`, `grep`) dalam sebuah proses baru. Ia kemudian mengembalikan sebuah file handle Lua yang terhubung ke `stdin` atau `stdout` dari proses tersebut. Ini memungkinkan Anda untuk membaca output dari sebuah perintah atau menulis input ke sebuah perintah langsung dari dalam skrip Lua Anda.
- **Sintaks**: `local pipe_handle, errorMessage = io.popen(command, mode)`
  - `command`: Sebuah string yang berisi perintah yang akan dieksekusi oleh shell sistem operasi.
  - `mode` (opsional, default: `"r"`): Sebuah string yang menentukan arah pipe.
    - **`"r"` (read - baca)**: Menjalankan `command` dan memungkinkan Anda untuk **membaca** output standar (`stdout`) dari perintah tersebut melalui `pipe_handle`.
    - **`"w"` (write - tulis)**: Menjalankan `command` dan memungkinkan Anda untuk **menulis** ke input standar (`stdin`) dari perintah tersebut melalui `pipe_handle`.

**Reading dari dan writing ke pipes:**
Setelah Anda mendapatkan `pipe_handle` dari `io.popen()`, Anda dapat menggunakannya persis seperti file handle biasa dari `io.open()`:

- **Membaca dari pipe (mode "r")**: Anda bisa menggunakan `pipe:read()`, `pipe:lines()`.
- **Menulis ke pipe (mode "w")**: Anda bisa menggunakan `pipe:write()`.

**Error handling dengan pipes:**
Penanganan error dengan `popen` memiliki dua tingkat:

1.  **Kegagalan Eksekusi Perintah**: Jika `io.popen()` gagal menjalankan perintah itu sendiri (misalnya, perintah tidak ada atau masalah izin), ia akan mengembalikan `nil` dan pesan error, sama seperti `io.open()`.
2.  **Status Keluar (Exit Status) Perintah**: Sebuah perintah bisa saja berjalan, tetapi berakhir dengan status error (misalnya, `grep` tidak menemukan apa pun, atau perintah `rm` gagal menghapus file). Anda dapat memeriksa status ini dengan melihat nilai kembali dari metode **`pipe:close()`**.
    - **`pipe:close()`**: Saat dipanggil pada handle dari `popen`, `close()` akan menunggu perintah eksternal selesai. Ia kemudian mengembalikan tiga nilai: `true` atau `nil` (menandakan sukses/gagalnya operasi `close` itu sendiri), string `"exit"`, dan _exit code_ dari proses tersebut. _Exit code_ 0 biasanya berarti sukses.

**Contoh Kode (`popen_demo.lua`):**

```lua
-- 1. Membaca output dari sebuah perintah (mode "r")
-- Perintah 'dir' untuk Windows, 'ls -l' untuk Linux/macOS.
local command_list_files
local os_type = package.config:sub(1,1) -- Trik untuk deteksi OS (W untuk Windows)
if os_type == "W" then
    command_list_files = "dir /b" -- /b untuk bare format, hanya nama file
else
    command_list_files = "ls -a" -- -a untuk semua file
end

print("--- Membaca output dari '" .. command_list_files .. "' ---")
local pipe_read, err_read = io.popen(command_list_files, "r")
-- Penjelasan Sintaks io.popen():
-- io.popen: Fungsi untuk membuka pipe ke sebuah proses.
-- command_list_files: Perintah yang akan dijalankan.
-- "r": Mode baca, kita akan membaca output dari perintah ini.

if not pipe_read then
    io.stderr:write("Gagal menjalankan perintah: " .. (err_read or "") .. "\n")
else
    -- Membaca semua output dari perintah seolah-olah itu file
    local output = pipe_read:read("*a")
    print("Output yang diterima:")
    print(output)

    -- Menutup pipe dan memeriksa status keluar
    local ok, exit_reason, exit_code = pipe_read:close()
    -- Penjelasan Sintaks pipe:close():
    -- pipe_read:close(): Menunggu perintah selesai.
    -- ok: Status dari operasi close().
    -- exit_reason: Biasanya string "exit".
    -- exit_code: Kode keluar dari perintah. 0 = sukses.

    print("\nPipe ditutup.")
    if ok and exit_code == 0 then
        print("Perintah selesai dengan sukses (exit code: " .. exit_code .. ")")
    else
        print("Perintah mungkin gagal (exit code: " .. tostring(exit_code) .. ")")
    end
end


-- 2. Menulis input ke sebuah perintah (mode "w")
-- Kita akan menggunakan perintah 'sort' yang tersedia di banyak sistem.
print("\n--- Menulis input ke perintah 'sort' ---")
local pipe_write, err_write = io.popen("sort", "w")

if not pipe_write then
    io.stderr:write("Gagal menjalankan perintah 'sort': " .. (err_write or "") .. "\n")
else
    print("Menulis data yang tidak urut ke 'sort'...")
    -- Menulis beberapa baris, yang akan menjadi stdin untuk 'sort'
    pipe_write:write("Charlie\n")
    pipe_write:write("Alice\n")
    pipe_write:write("Eve\n")
    pipe_write:write("Bob\n")

    -- Menutup pipe SANGAT PENTING di sini.
    -- Menutup pipe mengirimkan sinyal EOF (End-of-File) ke stdin 'sort',
    -- yang memberitahunya untuk berhenti menunggu input dan mulai memproses.
    pipe_write:close()

    -- Catatan: Karena kita menulis ke stdin 'sort', output 'sort' akan
    -- muncul di stdout standar program Lua kita.
    print("\nOutput dari 'sort' (setelah pipe ditutup):")
    -- (Output yang disortir akan tampil di sini, dicetak oleh proses 'sort' itu sendiri)
end
```

**Penjelasan Kode**:

- **Membaca dari Perintah**: Skrip menjalankan `ls` atau `dir` dan membuka pipe untuk membaca outputnya. `pipe_read:read("*a")` membaca seluruh output tersebut ke dalam sebuah variabel. `pipe_read:close()` sangat penting untuk memeriksa apakah perintah tersebut selesai tanpa error (exit code 0).
- **Menulis ke Perintah**: Skrip menjalankan `sort` dan membuka pipe untuk menulis ke inputnya. Kita menulis beberapa nama yang tidak berurutan. Saat `pipe_write:close()` dipanggil, proses `sort` menerima sinyal akhir input, melakukan pengurutan, dan mencetak hasilnya ke output standarnya sendiri, yang biasanya adalah konsol tempat Anda menjalankan skrip Lua.

---

### 8.2 Network I/O Basics

**Deskripsi Konkret:**
Bagian ini membahas dasar-dasar komunikasi melalui jaringan, seperti melakukan koneksi ke server lain atau membuat permintaan web.

**PENTING: Keterbatasan Pustaka Standar Lua**
Pustaka `io` dan `os` standar Lua **TIDAK** menyediakan fungsionalitas untuk I/O jaringan (sockets, HTTP, dll.). Untuk melakukan operasi jaringan apa pun, Anda **HARUS** menggunakan pustaka eksternal. Pustaka yang paling umum dan menjadi standar de-facto untuk ini adalah **LuaSocket**.

Penjelasan berikut akan memperkenalkan konsep-konsep tersebut dan menunjukkan bagaimana cara kerjanya jika Anda menggunakan LuaSocket.

**Socket-like operations:**

- **Konsep Socket**: _Socket_ adalah titik akhir (endpoint) untuk komunikasi jaringan. Ia didefinisikan oleh alamat IP (menentukan mesin mana di jaringan) dan nomor _port_ (menentukan aplikasi mana di mesin tersebut).
- **TCP vs UDP**:
  - **TCP (Transmission Control Protocol)**: Berorientasi koneksi. Ia memastikan data tiba secara berurutan dan tanpa kesalahan (seperti panggilan telepon). Digunakan untuk HTTP, FTP, email.
  - **UDP (User Datagram Protocol)**: Tanpa koneksi. Ia mengirim paket data (datagram) tanpa jaminan pengiriman atau urutan (seperti mengirim kartu pos). Digunakan untuk game online, streaming video, DNS.
- **Dengan LuaSocket**: Pustaka ini menyediakan fungsi untuk membuat dan mengelola socket TCP dan UDP, memungkinkan Anda membangun klien dan server jaringan.

**HTTP requests sederhana:**

- **Konsep HTTP**: HTTP (Hypertext Transfer Protocol) adalah protokol yang mendasari World Wide Web. Ia bekerja dengan model permintaan-respons. _Klien_ (seperti browser Anda atau skrip Lua) mengirim _permintaan_ (request) ke _server_, dan server mengirim kembali _respons_ (response), yang bisa berupa halaman HTML, data JSON, gambar, dll.
- **Dengan LuaSocket**: LuaSocket menyertakan modul `http` yang sangat menyederhanakan pembuatan permintaan HTTP.

**Contoh Kode (Konseptual - Membutuhkan LuaSocket):**

```lua
-- PENTING: Jalankan 'luarocks install luasocket' terlebih dahulu
-- agar pustaka ini tersedia.

-- Kita gunakan pcall untuk memeriksa apakah LuaSocket tersedia dengan aman.
local status_socket, socket = pcall(require, "socket")
local status_http, http = pcall(require, "socket.http")

if not (status_socket and status_http) then
    io.stderr:write("Pustaka LuaSocket tidak ditemukan.\n")
    io.stderr:write("Silakan instal dengan 'luarocks install luasocket'.\n")
    io.stderr:write("Melewatkan contoh jaringan.\n")
else
    print("LuaSocket ditemukan. Melanjutkan contoh jaringan...\n")

    -- 1. Contoh TCP Socket Sederhana (Klien Echo)
    -- Menghubungkan ke server echo publik di tcpbin.com port 4242
    print("--- Menghubungkan ke server TCP Echo (tcpbin.com:4242) ---")
    local tcp_client = socket.tcp()

    -- Menghubungkan ke server
    local ok_conn, err_conn = tcp_client:connect("tcpbin.com", 4242)
    if not ok_conn then
        print("Gagal terhubung:", err_conn)
    else
        print("Berhasil terhubung ke server.")

        -- Mengirim data
        tcp_client:send("Halo dari Lua!\n")
        print("Mengirim: 'Halo dari Lua!'")

        -- Menerima respons (server echo akan mengembalikan apa yang kita kirim)
        local response, err_recv = tcp_client:receive("*l") -- Baca satu baris
        if response then
            print("Menerima: '" .. response .. "'")
        else
            print("Gagal menerima respons:", err_recv)
        end

        -- Menutup koneksi
        tcp_client:close()
        print("Koneksi ditutup.")
    end

    -- 2. Contoh HTTP Request Sederhana (GET)
    -- Mengambil data dari JSONPlaceholder
    print("\n--- Melakukan HTTP GET ke jsonplaceholder.typicode.com ---")
    local api_url = "https://jsonplaceholder.typicode.com/todos/1"

    -- http.request() mengembalikan body, status code, headers, status line
    local body, status_code = http.request(api_url)
    -- Penjelasan Sintaks http.request():
    -- http.request: Fungsi dari modul http di LuaSocket.
    -- api_url: URL yang akan diakses.

    if not body then
        print("Gagal melakukan permintaan HTTP. Status:", status_code)
    else
        if status_code == 200 then
            print("Permintaan sukses (Status: " .. status_code .. ")")
            print("Body Respons (JSON):")
            print(body)
        else
            print("Server merespons dengan error (Status: " .. status_code .. ")")
        end
    end
end
```

**Penjelasan Kode (LuaSocket)**:

- **`require` dalam `pcall`**: Ini adalah cara yang aman untuk memuat modul eksternal. Jika `require` gagal (karena modul tidak ada), program tidak akan crash.
- **TCP Client**: Kode membuat objek TCP (`socket.tcp()`), menghubungkannya ke server (`:connect`), mengirim data (`:send`), menerima data (`:receive`), dan menutup koneksi (`:close`). Perhatikan bagaimana objek koneksi ini memiliki metode yang mirip dengan file handle (send \~ write, receive \~ read).
- **HTTP Request**: Kode ini menggunakan `http.request(url)` yang lebih sederhana. Fungsi ini menangani semua detail socket TCP dan protokol HTTP di belakang layar. Anda hanya perlu memberikan URL dan ia akan mengembalikan body dari respons dan kode status HTTP (200 berarti OK).

Dengan `io.popen()`, Anda dapat mengintegrasikan skrip Lua Anda dengan ribuan utilitas baris perintah yang ada. Dan dengan pustaka seperti LuaSocket, Anda dapat membuka pintu bagi skrip Lua Anda untuk berkomunikasi dengan seluruh dunia melalui internet.

Selanjutnya kita akan membahas "Performance dan Optimization". Apakah Anda siap?

**Sumber Referensi dari Kurikulum:**

1.  [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html)
2.  [TutorialsPoint: io.popen Function in Lua Programming](https://www.tutorialspoint.com/io-popen-function-in-lua-programming)
3.  [Gammon: io.popen Documentation](https://www.gammon.com.au/scripts/doc.php?lua=io.popen)

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../advanced-I-O-techniques/README.md
[selanjutnya]: ../performance-dan-optimization/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#8-io-dengan-external-systems
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
