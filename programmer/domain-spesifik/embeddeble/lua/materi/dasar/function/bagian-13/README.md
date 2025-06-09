# **Bagian 13: Sandboxing dan Secure Environments**

Bagian ini sangat penting karena membahas keamanan, terutama saat Anda perlu menjalankan kode yang mungkin tidak sepenuhnya Anda percayai.

*Sandboxing* adalah teknik untuk menjalankan kode dalam lingkungan yang terkendali dan terbatas untuk mencegahnya melakukan tindakan yang tidak diinginkan atau berbahaya. Jika aplikasi Anda perlu menjalankan skrip yang disediakan oleh pengguna (misalnya, untuk modding game atau plugin), memahami cara membuat sandbox sangatlah penting.

**Daftar Isi Bagian 13:**

  * [Kebutuhan akan Sandboxing](#131-kebutuhan-akan-sandboxing)
  * [Mengimplementasikan Sandbox](#132-mengimplementasikan-sandbox)
  * [Teknik Sandboxing Tingkat Lanjut](#133-teknik-sandboxing-tingkat-lanjut)

-----

### 13.1 Kebutuhan akan Sandboxing

#### **Menjalankan Kode yang Tidak Tepercaya (Untrusted Code)**

Kasus penggunaan utama untuk sandboxing adalah ketika Anda perlu mengeksekusi kode yang tidak Anda tulis sendiri atau tidak dapat Anda verifikasi sepenuhnya. Tanpa pembatasan, skrip sederhana dari pengguna bisa memiliki akses penuh ke sistem Anda.

#### **Melindungi Lingkungan Host**

Tujuan utama sandbox adalah untuk melindungi aplikasi "host" dan sistem operasi di bawahnya. Anda harus mencegah kode yang tidak tepercaya dari:

  * **Mengakses file system:** Membaca file sensitif, menulis atau menghapus data (`io.open`, `os.remove`).
  * **Menjalankan perintah sistem:** Mengeksekusi program lain (`os.execute`).
  * **Mengakses jaringan:** Membuat koneksi keluar.
  * **Menghentikan aplikasi:** Memanggil `os.exit()`.

#### **Membatasi Sumber Daya**

Sandboxing tidak hanya tentang keamanan, tetapi juga tentang stabilitas. Kode yang tidak tepercaya bisa saja mengandung bug seperti loop tak terbatas yang akan menghabiskan 100% CPU dan membuat aplikasi Anda tidak responsif. Sandbox dapat digunakan untuk membatasi sumber daya seperti waktu eksekusi CPU dan penggunaan memori.

-----

### 13.2 Mengimplementasikan Sandbox

Inti dari sandboxing di Lua adalah mengontrol "environment" (lingkungan) dari kode yang akan dijalankan.

#### **Membuat Lingkungan yang Aman**

Langkah pertama adalah membuat sebuah table yang akan bertindak sebagai lingkungan global baru untuk kode yang akan di-sandbox. Anda kemudian secara selektif mengisi table ini hanya dengan function-function yang Anda anggap "aman" (sebuah *whitelist*).

#### **`_ENV` dan `setfenv`**

  * **Cara Modern (`_ENV`, Lua 5.2+):**
    Di versi Lua modern, setiap function memiliki akses ke variabel lokal khusus bernama `_ENV`. Ketika Lua mencari variabel global seperti `print`, ia sebenarnya mencarinya di dalam table `_ENV` ini. Dengan menyediakan table `_ENV` kustom kita sendiri, kita bisa mengontrol apa saja yang dianggap "global" oleh kode tersebut.

  * **Cara Lama (`setfenv`, Lua 5.1):**
    Di Lua 5.1, function `setfenv(function, environment_table)` digunakan untuk mengganti environment dari sebuah function. Meskipun sudah usang, penting untuk mengetahuinya jika Anda bekerja dengan kode lama.

#### **Metatables untuk Environment**

Teknik yang sangat kuat adalah menggunakan metatable pada environment sandbox Anda.

  * **Pola:**

    1.  Buat environment sandbox (`safe_env`).
    2.  Isi `safe_env` dengan function kustom atau yang aman.
    3.  Buat metatable untuk `safe_env`.
    4.  Atur metamethod `__index` dari metatable tersebut ke environment global yang asli (`_G`).

  * **Efek:** Ketika kode di dalam sandbox mencoba mengakses variabel global (misalnya, `print`):

    1.  Lua akan mencarinya di `safe_env` terlebih dahulu.
    2.  Jika tidak ditemukan, metamethod `__index` akan dipicu, dan Lua akan mencarinya di `_G`.
        Ini secara efektif memberikan akses *read-only* ke function-function global yang aman (`tostring`, `ipairs`, `print`, dll.) tanpa perlu menyalin semuanya secara manual ke `safe_env`. Namun, upaya untuk *menulis* ke variabel global baru akan terjadi di dalam `safe_env`, bukan `_G`, sehingga tidak mencemari lingkungan global asli.

#### **Memuat Kode ke dalam Sandbox**

Cara terbaik untuk menjalankan kode dalam sandbox adalah menggunakan `load` dengan argumen environment.

  * **`load(untrusted_code, chunkname, mode, environment)`:**
    Argumen keempat (`environment`) memberitahu `load` untuk mengkompilasi `untrusted_code` dan mengikatnya ke `environment` yang diberikan sebagai `_ENV`-nya.

  * **Contoh Kode Lengkap:**

    ```lua
    local untrusted_script = [[
        -- Kode ini mencoba melakukan hal baik dan buruk
        print("Halo dari sandbox!")
        local x = 2 + 2
        print("2 + 2 =", x)
        -- Baris berbahaya di bawah ini akan gagal
        os.execute("echo 'HACKED!'")
    ]]

    -- 1. Buat environment yang aman
    local safe_env = {
        print = print,
        tostring = tostring,
        -- Tidak ada 'os', 'io', 'dofile', dll.
    }
    setmetatable(safe_env, { __index = _G }) -- Beri akses baca ke global aman

    -- 2. Load skrip dengan environment sandbox
    local sandboxed_func, err = load(untrusted_script, "script_pengguna", "t", safe_env)
    if not sandboxed_func then
        error("Gagal kompilasi: " .. err)
    end

    -- 3. Jalankan dalam protected call
    local sukses, hasil = pcall(sandboxed_func)
    if not sukses then
        print("\nEksekusi di sandbox gagal seperti yang diharapkan!")
        print("Error:", hasil)
    end
    ```

-----

### 13.3 Teknik Sandboxing Tingkat Lanjut 

#### **Instruction Counting (Penghitungan Instruksi)**

Untuk mencegah loop tak terbatas, Anda bisa menggunakan `debug.sethook` untuk membatasi jumlah instruksi yang dapat dieksekusi oleh sebuah skrip.

  * **Mekanisme:** Set sebuah *hook* yang akan dipanggil setiap beberapa ribu instruksi. Hook ini akan memeriksa apakah skrip telah berjalan terlalu lama. Jika ya, ia akan memunculkan error untuk menghentikannya.

#### **Hooking Functions**

Daripada menghapus function berbahaya sepenuhnya, Anda bisa "membungkusnya" untuk menyediakan versi yang lebih terbatas. Misalnya, Anda bisa menyediakan function `io.open` versi Anda sendiri di `safe_env` yang hanya mengizinkan pembacaan dari direktori tertentu.

#### **Capability-Based Security**

Ini adalah model keamanan alternatif yang lebih ketat. Daripada memberikan akses *read-only* ke lingkungan global, Anda memberikan lingkungan yang benar-benar kosong.

  * **Prinsip:** Kode yang di-sandbox tidak memiliki kemampuan apa pun secara default. Untuk melakukan sesuatu (seperti menulis ke file), aplikasi host harus secara eksplisit melewatkan sebuah "objek kapabilitas" (misalnya, sebuah table dengan function `tulis_ke_log()`) sebagai argumen ke function yang di-sandbox. Ini membuat izin menjadi sangat eksplisit dan terkendali.

-----

**Sumber Referensi untuk Bagian 13:**

1.  Lua-Users Wiki - Lua Sandbox: [http://lua-users.org/wiki/LuaSandbox](https://www.google.com/search?q=http://lua-users.org/wiki/LuaSandbox)
2.  Programming in Lua (1st Edition) - 14.3 Sandboxing: [https://www.lua.org/pil/14.3.html](https://www.lua.org/pil/14.3.html)
3.  lua-l Mailing List - Sand-boxing with load and loadstring: [https://lua-l.lua.narkive.com/b9i2l04E/sand-boxing-with-load-and-loadstring](https://www.google.com/search?q=https://lua-l.lua.narkive.com/b9i2l04E/sand-boxing-with-load-and-loadstring)
4.  Lua 5.4 Reference Manual - 2.2 Environments and the Global Environment: [https://www.lua.org/manual/5.4/manual.html\#2.2](https://www.google.com/search?q=https://www.lua.org/manual/5.4/manual.html%232.2)
5.  Lua-Users Wiki - Setfenv Considered Harmful: [http://lua-users.org/wiki/SetfenvConsideredHarmful](https://www.google.com/search?q=http://lua-users.org/wiki/SetfenvConsideredHarmful)
6.  Lua-Users Wiki - Lua Security: [http://lua-users.org/wiki/LuaSecurity](http://lua-users.org/wiki/LuaSecurity)

-----

### **Kesimpulan dan Penutup**

Kita telah menyelesaikan seluruh 13 bagian dari kurikulum function di Lua. Anda telah melakukan perjalanan yang luar biasa, mulai dari sintaks dasar `function ... end` hingga konsep-konsep mendalam seperti closure, coroutine, metaprogramming, dan sandboxing.

Dengan bekal materi ini, Anda tidak hanya memahami *bagaimana* menggunakan function di Lua, tetapi juga *mengapa* mereka bekerja seperti itu dan *bagaimana* memanfaatkannya dalam pola-pola yang canggih untuk tujuan apa pun yang Anda butuhkan. Anda sekarang memiliki fondasi yang sangat kuat untuk:

  * Menulis kode Lua yang bersih, modular, dan efisien.
  * Memahami dan menggunakan library dan framework Lua dengan percaya diri.
  * Merancang solusi yang kompleks dan elegan untuk berbagai masalah.
  * Menambahkan fitur kustom ke proyek apa pun, dengan pemahaman mendalam tentang alat yang Anda gunakan.

###### Langkah selanjutnya adalah terus berlatih, membangun proyek, membaca kode orang lain, dan berkontribusi pada komunitas. **Selamat\!** Anda telah mengambil langkah besar untuk menguasai salah satu aspek paling kuat dari bahasa pemrograman Lua.





#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../../string/bagian-1/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-13-function-environments-dan-sandboxing
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