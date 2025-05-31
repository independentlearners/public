# **[9\. Coroutines - Dasar Konkurensi][1]**

Bagian ini akan memperkenalkan Anda pada konsep coroutine di Lua, cara membuat dan menggunakannya, serta kasus penggunaannya yang relevan dalam pengembangan plugin Neovim, terutama untuk operasi non-blocking. Coroutine adalah fitur Lua yang memungkinkan penulisan kode untuk tugas-tugas yang dapat berjalan secara bersamaan (concurrent) melalui model _cooperative multitasking_.

---

### 9.1 Apa itu Coroutines?

- **Deskripsi Konsep:**
  - **Coroutine:** Sebuah coroutine (atau ko-rutin) adalah sebuah unit eksekusi yang mirip dengan fungsi, tetapi dengan kemampuan untuk menangguhkan (suspend) eksekusinya sebelum selesai dan kemudian melanjutkannya (resume) lagi dari titik di mana ia ditangguhkan, sambil mempertahankan state lokalnya. Bayangkan sebuah fungsi yang bisa di-pause dan di-play.
  - **Cooperative Multitasking (Multitasking Kooperatif):** Berbeda dengan _preemptive multitasking_ (seperti pada thread OS di mana sistem operasi dapat menginterupsi thread kapan saja), coroutine bekerja secara kooperatif. Sebuah coroutine hanya akan melepaskan kontrol eksekusi (CPU) secara sukarela, biasanya dengan memanggil fungsi `coroutine.yield()`. Ini berarti programmer memiliki kontrol penuh kapan sebuah coroutine akan "beristirahat" dan memberi kesempatan coroutine lain atau program utama untuk berjalan.
  - **Perbedaan dengan Threads OS:**
    - **Ringan:** Coroutine jauh lebih ringan daripada thread OS. Anda bisa memiliki ribuan coroutine berjalan tanpa overhead signifikan.
    - **Satu Thread OS:** Semua coroutine dalam satu state Lua biasanya berjalan dalam satu thread OS yang sama. Ini berarti tidak ada paralelisme sejati (dua coroutine tidak pernah benar-benar berjalan pada saat yang sama di dua core CPU berbeda), tetapi mereka menyediakan _konkurensi_ (kemampuan untuk menangani banyak tugas seolah-olah berjalan bersamaan dengan beralih di antara mereka).
    - **Sinkronisasi Lebih Mudah:** Karena sifat kooperatif dan eksekusi dalam satu thread, berbagi data antar coroutine umumnya lebih aman dan tidak memerlukan mekanisme locking yang kompleks seperti pada thread OS.
- **Terminologi:**
  - **Coroutine:** Unit komputasi yang dapat ditangguhkan dan dilanjutkan.
  - **Cooperative Multitasking:** Model di mana tugas-tugas secara sukarela menyerahkan kontrol.
  - **Concurrency (Konkurensi):** Kemampuan sistem untuk menangani beberapa tugas yang tampak berjalan bersamaan, meskipun mungkin tidak secara paralel.
  - **Yield (Menyerah):** Tindakan coroutine menangguhkan eksekusinya dan mengembalikan kontrol ke pemanggil (resumer).
  - **Resume (Melanjutkan):** Tindakan memulai atau melanjutkan eksekusi coroutine yang ditangguhkan.
- **Implementasi dalam Neovim:** Coroutine adalah fondasi untuk operasi asinkron di Neovim. Mereka memungkinkan plugin melakukan tugas yang memakan waktu (seperti operasi I/O, panggilan jaringan, interaksi dengan proses eksternal) tanpa membekukan antarmuka pengguna Neovim. Coroutine sering digunakan bersama dengan event loop Neovim (`vim.loop`) untuk menjadwalkan kelanjutan (resume) setelah operasi asinkron selesai.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Coroutines): [https://www.lua.org/manual/5.1/manual.html\#2.11](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.11)
  - Lua 5.1 Reference Manual (Coroutine Manipulation): [https://www.lua.org/manual/5.1/manual.html\#5.2](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.2)
  - Programming in Lua, 1st ed. (Chapter 9 - Coroutines): [https://www.lua.org/pil/9.html](https://www.lua.org/pil/9.html)

---

### 9.2 Membuat dan Menggunakan Coroutines

Pustaka `coroutine` standar di Lua menyediakan fungsi-fungsi untuk bekerja dengan coroutine.

#### Fungsi-fungsi Utama Coroutine:

- **`coroutine.create(f)`**
  - **Deskripsi:** Membuat coroutine baru dengan fungsi `f` sebagai tubuhnya.
  - **Sintaks:** `local co = coroutine.create(fungsi_body_coroutine)`
    - `fungsi_body_coroutine`: Fungsi Lua yang akan dieksekusi oleh coroutine.
  - **Nilai Kembali:** Mengembalikan objek bertipe "thread" yang merepresentasikan coroutine baru. Coroutine ini dimulai dalam keadaan "suspended".
- **`coroutine.resume(co [, val1, ...])`**
  - **Deskripsi:** Memulai atau melanjutkan eksekusi coroutine `co`.
  - **Sintaks:** `local success, result1, result2, ... = coroutine.resume(objek_coroutine, arg1_untuk_co, arg2_untuk_co, ...)`
    - `objek_coroutine`: Objek coroutine yang dikembalikan oleh `coroutine.create` atau `coroutine.running`.
    - `arg1_untuk_co, ...`: Nilai-nilai ini akan diteruskan sebagai argumen ke fungsi body coroutine (jika ini adalah resume pertama) atau sebagai nilai kembali dari pemanggilan `coroutine.yield` sebelumnya di dalam coroutine.
  - **Nilai Kembali `coroutine.resume`:**
    - `success` (boolean): `true` jika coroutine berjalan/yield tanpa error, `false` jika terjadi error di dalam coroutine.
    - Jika `success` adalah `true`:
      - `result1, ...`: Nilai-nilai yang diteruskan ke `coroutine.yield()` dari dalam coroutine, ATAU nilai-nilai yang dikembalikan oleh fungsi body coroutine jika coroutine tersebut selesai secara normal.
    - Jika `success` adalah `false`:
      - `result1`: Objek kesalahan (biasanya string pesan error).
- **`coroutine.yield(...)`**
  - **Deskripsi:** Hanya dapat dipanggil dari dalam sebuah coroutine. Menangguhkan eksekusi coroutine saat ini.
  - **Sintaks:** `local resume_arg1, resume_arg2, ... = coroutine.yield(yield_val1, yield_val2, ...)`
    - `yield_val1, ...`: Nilai-nilai ini akan dikembalikan oleh pemanggilan `coroutine.resume` yang menangguhkan coroutine ini.
  - **Nilai Kembali `coroutine.yield` (ketika coroutine dilanjutkan):**
    - `resume_arg1, ...`: Nilai-nilai yang diteruskan ke `coroutine.resume` yang melanjutkan coroutine ini.
- **`coroutine.status(co)`**
  - **Deskripsi:** Mengembalikan status dari coroutine `co` sebagai string.
  - **Sintaks:** `local status_str = coroutine.status(objek_coroutine)`
  - **Kemungkinan Status:**
    - `"running"`: Coroutine sedang berjalan (status ini biasanya hanya dilihat oleh coroutine itu sendiri atau melalui C API, bukan oleh kode yang memanggil `resume`).
    - `"suspended"`: Coroutine ditangguhkan (baru dibuat, atau setelah memanggil `yield`, atau telah menyelesaikan eksekusi dan bisa di-resume untuk mendapatkan nilai return terakhir jika ada error).
    - `"normal"`: Coroutine aktif tetapi tidak sedang berjalan (misalnya, ia telah me-resume coroutine lain). Jarang terlihat dalam skrip Lua murni.
    - `"dead"`: Coroutine telah menyelesaikan eksekusinya (baik secara normal maupun karena error yang tidak tertangani di dalamnya) dan tidak dapat di-resume lagi.
- **`coroutine.wrap(f)`**
  - **Deskripsi:** Cara lain untuk membuat coroutine. Ia mengembalikan sebuah fungsi yang, setiap kali dipanggil, akan melanjutkan (resume) coroutine yang terkait dengannya.
  - **Sintaks:** `local wrapper_func = coroutine.wrap(fungsi_body_coroutine)`
  - **Penggunaan:** `local result1, ... = wrapper_func(arg1, ...)`
    - Argumen yang diteruskan ke `wrapper_func` akan diteruskan ke coroutine (sebagai argumen awal atau hasil dari `yield`).
    - Nilai yang di-yield atau dikembalikan oleh coroutine akan dikembalikan oleh `wrapper_func`.
    - Jika coroutine memunculkan error, error tersebut akan dipropagasi (dimunculkan kembali) oleh `wrapper_func` (berbeda dengan `coroutine.resume` yang mengembalikan status error).
- **`coroutine.running()`**
  - **Deskripsi:** Mengembalikan coroutine yang sedang berjalan saat ini. Jika dipanggil dari thread utama (bukan coroutine yang dibuat oleh `coroutine.create`), ia mengembalikan coroutine yang merepresentasikan thread utama dan boolean `true`. Jika dipanggil dari dalam coroutine, ia mengembalikan objek coroutine itu sendiri dan boolean `false`.
  - **Sintaks:** `local current_co, is_main = coroutine.running()`

**Contoh Kode (Dasar):**

```lua
-- Fungsi yang akan dijalankan sebagai body coroutine
local function my_coroutine_function(start_value)
    print("[CO] Coroutine dimulai dengan nilai:", start_value)
    local current_sum = start_value

    for i = 1, 3 do
        print("[CO] Iterasi ke-", i, "Sum saat ini:", current_sum)
        -- Menangguhkan coroutine dan mengirim 'current_sum' kembali ke pemanggil resume.
        -- Nilai yang diterima dari resume berikutnya akan disimpan di 'increment'.
        local increment = coroutine.yield(current_sum, "Iterasi " .. i)
        print("[CO] Coroutine dilanjutkan, menerima increment:", increment)
        if type(increment) ~= "number" then
            print("[CO] Increment bukan angka, menghentikan coroutine.")
            return "Error: increment bukan angka" -- Selesai dengan error
        end
        current_sum = current_sum + increment
    end

    print("[CO] Coroutine selesai. Sum akhir:", current_sum)
    return current_sum, "Selesai dengan sukses" -- Mengembalikan dua nilai
end

-- 1. Membuat coroutine
print("--- Membuat Coroutine ---")
local co = coroutine.create(my_coroutine_function)
print("Status setelah create:", coroutine.status(co)) -- Output: suspended

-- 2. Melanjutkan (resume) coroutine untuk pertama kali
print("\n--- Resume Pertama ---")
-- Argumen '10' akan menjadi 'start_value' di my_coroutine_function
local success, res1_from_yield, res2_from_yield = coroutine.resume(co, 10)
print("Resume berhasil:", success)                     -- Output: true
print("Nilai 1 dari yield:", res1_from_yield)          -- Output: 10 (current_sum awal)
print("Nilai 2 dari yield:", res2_from_yield)          -- Output: Iterasi 1
print("Status setelah resume pertama (yield):", coroutine.status(co)) -- Output: suspended

-- 3. Melanjutkan coroutine lagi
print("\n--- Resume Kedua ---")
-- Argumen '5' akan menjadi nilai kembali dari 'coroutine.yield' di dalam coroutine (menjadi 'increment')
success, res1_from_yield, res2_from_yield = coroutine.resume(co, 5)
print("Resume berhasil:", success)                     -- Output: true
print("Nilai 1 dari yield:", res1_from_yield)          -- Output: 15 (10+5)
print("Nilai 2 dari yield:", res2_from_yield)          -- Output: Iterasi 2
print("Status setelah resume kedua (yield):", coroutine.status(co)) -- Output: suspended

-- 4. Melanjutkan coroutine dengan argumen yang salah tipe untuk memicu error internal
print("\n--- Resume Ketiga (memicu error di coroutine) ---")
-- Mengirim string, yang akan menyebabkan error di dalam coroutine
success, err_or_res1 = coroutine.resume(co, "bukan angka")
print("Resume berhasil:", success)                     -- Output: false (karena error di coroutine)
print("Objek error:", err_or_res1)                     -- Output: Error: increment bukan angka (nilai return dari coroutine)
                                                       -- Sebenarnya, karena return eksplisit, ini dianggap selesai normal oleh resume
                                                       -- Jika menggunakan 'error()', maka success akan false.
                                                       -- Mari kita perbaiki contohnya agar lebih jelas errornya.

-- Mari perbaiki my_coroutine_function untuk error yang lebih jelas
local function my_coroutine_function_v2(start_value)
    print("[CO_V2] Coroutine dimulai dengan nilai:", start_value)
    local current_sum = start_value
    for i = 1, 3 do
        local increment = coroutine.yield(current_sum, "Iterasi " .. i)
        if type(increment) ~= "number" then
            error("[CO_V2] Error: increment harus angka, diterima " .. type(increment)) -- Menggunakan error()
        end
        current_sum = current_sum + increment
    end
    return current_sum
end

local co_v2 = coroutine.create(my_coroutine_function_v2)
print("\n--- Menguji Coroutine V2 dengan error ---")
print("Resume V2-1 (start):", coroutine.resume(co_v2, 100)) -- (true, 100, "Iterasi 1")
print("Resume V2-2 (increment):", coroutine.resume(co_v2, 20)) -- (true, 120, "Iterasi 2")
print("Status co_v2:", coroutine.status(co_v2)) -- suspended
local s, e = coroutine.resume(co_v2, "bad_value")
print("Resume V2-3 (error):", s, e) -- (false, "[string \"...\"]:...: [CO_V2] Error: increment harus angka, diterima string")
print("Status co_v2 setelah error:", coroutine.status(co_v2)) -- dead

-- 5. Melanjutkan coroutine yang sudah selesai/mati
print("\n--- Resume Coroutine yang sudah Mati (co_v2) ---")
success, err_msg = coroutine.resume(co_v2)
print("Resume berhasil:", success)                     -- Output: false
print("Pesan error:", err_msg)                        -- Output: cannot resume dead coroutine

-- Contoh dengan coroutine.wrap
print("\n--- Contoh coroutine.wrap ---")
local function range_generator_func(n)
    for i = 1, n do
        coroutine.yield(i)
    end
    return "Selesai!"
end

local gen_nums = coroutine.wrap(range_generator_func) -- gen_nums adalah fungsi wrapper

print(gen_nums(3)) -- Output: 1 (memulai/melanjutkan coroutine, yield pertama)
print(gen_nums())  -- Output: 2 (melanjutkan, yield kedua)
print(gen_nums())  -- Output: 3 (melanjutkan, yield ketiga)
print(gen_nums())  -- Output: Selesai! (melanjutkan, coroutine selesai dan mengembalikan "Selesai!")
-- print(gen_nums())  -- Akan error: cannot resume dead coroutine (dipropagasi oleh wrap)
```

**Cara Menjalankan Kode:** Simpan sebagai file `.lua` dan jalankan dengan `lua namafile.lua`. Amati urutan output dan perubahan status.

**Penjelasan Kode Keseluruhan:**

1.  **`my_coroutine_function(start_value)`:** Fungsi ini adalah inti dari coroutine. Ia menerima `start_value`, melakukan loop, dan di setiap iterasi ia `coroutine.yield(current_sum, "Iterasi " .. i)`. Ini menangguhkan coroutine dan mengirimkan dua nilai kembali ke pemanggil `coroutine.resume`. Ketika dilanjutkan, nilai yang diteruskan ke `resume` menjadi nilai kembali dari `yield` (disimpan di `increment`).
2.  `local co = coroutine.create(...)`: Membuat objek coroutine `co` dari fungsi di atas. Status awalnya adalah `"suspended"`.
3.  Panggilan `coroutine.resume(co, ...)`:
    - Resume pertama mengirim `10` sebagai `start_value`. Coroutine berjalan hingga `yield` pertama. `resume` mengembalikan `true` dan dua nilai yang di-yield. Status `co` tetap `"suspended"`.
    - Resume kedua mengirim `5` sebagai `increment`. Coroutine melanjutkan, melakukan `yield` lagi. Status `co` tetap `"suspended"`.
4.  **`my_coroutine_function_v2` dan `co_v2`:** Versi ini dimodifikasi untuk menggunakan `error()` jika `increment` bukan angka.
    - Pemanggilan `coroutine.resume(co_v2, "bad_value")` menyebabkan `error()` dipanggil di dalam coroutine.
    - Akibatnya, `coroutine.resume` mengembalikan `false` dan pesan error string. Status `co_v2` menjadi `"dead"`.
5.  Mencoba me-resume coroutine yang sudah `"dead"` akan menghasilkan error yang ditangkap oleh `coroutine.resume` (mengembalikan `false` dan pesan "cannot resume dead coroutine").
6.  **`coroutine.wrap(range_generator_func)`:**
    - `range_generator_func` adalah fungsi sederhana yang menghasilkan angka dari 1 hingga `n` menggunakan `yield`.
    - `coroutine.wrap` membuat fungsi `gen_nums`. Setiap kali `gen_nums()` dipanggil, ia me-resume coroutine `range_generator_func`. Nilai yang di-yield oleh coroutine dikembalikan oleh `gen_nums`. Ketika coroutine selesai, nilai `return` dari coroutine dikembalikan oleh `gen_nums`. Jika `gen_nums` dipanggil setelah coroutine mati, ia akan memunculkan error.

---

### 9.3 Use Cases dalam Plugin Neovim (Kasus Penggunaan dalam Plugin Neovim)

Coroutine sangat berguna dalam plugin Neovim, terutama untuk operasi yang bisa memakan waktu dan berpotensi memblokir UI.

- **Operasi Non-Blocking:**

  - **Deskripsi:** Tugas seperti membaca file besar, membuat permintaan jaringan, atau menjalankan perintah eksternal dapat memakan waktu. Jika dilakukan secara sinkron di thread utama Neovim, UI akan membeku. Coroutine memungkinkan tugas-tugas ini dimulai, kemudian coroutine `yield` (menyerahkan kontrol kembali ke Neovim). Ketika operasi eksternal selesai (misalnya, melalui callback dari `vim.loop`), coroutine dapat di-`resume` untuk memproses hasilnya.
  - **Contoh Konseptual (Simulasi Operasi Asinkron):**

    ```lua
    -- Fungsi ini mensimulasikan tugas yang mungkin melakukan yield.
    local function long_running_task(task_name, callback_resume)
        print(task_name .. ": Mulai...")
        local co_self = coroutine.running() -- Dapatkan coroutine saat ini

        for i = 1, 3 do
            print(task_name .. ": Bekerja pada langkah " .. i)

            -- Di dunia nyata, ini akan menjadi operasi asinkron non-blocking,
            -- misalnya, menggunakan vim.loop.new_timer, vim.fn.jobstart, atau vim.lsp.buf_request.
            -- Setelah operasi itu selesai, callback-nya akan memanggil callback_resume(co_self, hasil_operasi).
            -- Untuk simulasi, kita anggap yield() adalah titik di mana ia menunggu.
            if i < 3 then
                print(task_name .. ": Akan yield untuk " .. i .. "...")
                local data_from_resume = coroutine.yield(task_name .. " yielding on step " .. i)
                print(task_name .. ": Dilanjutkan setelah yield, menerima:", data_from_resume)
            end
        end
        print(task_name .. ": Selesai.")
        return task_name .. " hasil akhir"
    end

    -- "Event loop" atau scheduler sederhana untuk simulasi
    local tasks = {}
    function schedule_task(func, ...)
        local co = coroutine.create(func)
        table.insert(tasks, {co = co, args = {...} })
        return co
    end

    function run_scheduler_round()
        if #tasks == 0 then print("Scheduler: Tidak ada tugas lagi."); return false end

        local current_task_info = table.remove(tasks, 1) -- Ambil tugas pertama
        local co = current_task_info.co
        local args_for_resume = current_task_info.args

        print("\nScheduler: Melanjutkan", coroutine.status(co), "dengan args:", unpack(args_for_resume or {}))
        -- Menggunakan unpack untuk meneruskan argumen tabel sebagai argumen individual
        local success, yield_val_or_err = coroutine.resume(co, unpack(args_for_resume or {}))

        if not success then
            print("Scheduler: Coroutine error:", yield_val_or_err)
        elseif coroutine.status(co) == "suspended" then
            print("Scheduler: Coroutine", coroutine.status(co), "yielded:", yield_val_or_err, ". Menjadwalkan ulang dengan 'data dummy'.")
            -- Dalam kasus nyata, yield_val mungkin memberi tahu apa yang ditunggu
            -- dan kapan harus di-resume. Di sini kita resume segera dengan data dummy.
            table.insert(tasks, {co = co, args = {"data dummy setelah yield"} })
        elseif coroutine.status(co) == "dead" then
            print("Scheduler: Coroutine selesai. Hasil akhir (jika ada):", yield_val_or_err)
        end
        return true
    end

    -- Menjadwalkan tugas
    schedule_task(long_running_task, "Tugas A")
    schedule_task(long_running_task, "Tugas B")

    -- Menjalankan beberapa putaran scheduler
    print("\n--- Menjalankan Scheduler ---")
    while run_scheduler_round() do
        print("--- Akhir Putaran Scheduler ---")
    end
    ```

    - **Penjelasan Kode Simulasi:**
      - `long_running_task`: Fungsi yang melakukan `coroutine.yield()`.
      - `schedule_task`: Membuat coroutine dan menambahkannya ke antrian `tasks`.
      - `run_scheduler_round`: Mengambil satu tugas dari antrian, me-`resume`-nya. Jika coroutine `yield`, ia dimasukkan kembali ke antrian (disini disimulasikan untuk langsung di-resume pada putaran berikutnya dengan data dummy). Jika selesai atau error, statusnya dicetak.
      - Loop `while run_scheduler_round()` menjalankan "event loop" sederhana ini hingga semua tugas selesai. Output akan menunjukkan bagaimana "Tugas A" dan "Tugas B" berjalan secara bergantian (interleaved).
    - **Konteks Neovim Nyata:** Di Neovim, Anda tidak akan menulis event loop sendiri. Anda akan menggunakan `vim.loop` (yang merupakan libuv). Sebuah coroutine akan memulai operasi `vim.loop` (misalnya, `vim.loop.fs_read`) dan menyediakan fungsi callback. Coroutine kemudian akan `yield`. Ketika operasi I/O selesai, libuv akan memanggil callback Anda. Di dalam callback tersebut, Anda akan me-`resume` coroutine yang sesuai dengan hasil operasi. Pustaka seperti `plenary.nvim` menyederhanakan pola ini dengan menyediakan fungsi `async/await` yang dibangun di atas coroutine dan `vim.loop`.

- **Iterator Kustom:**

  - Coroutine (terutama dengan `coroutine.wrap`) sangat baik untuk membuat iterator yang menghasilkan nilai satu per satu sesuai permintaan, terutama jika logika untuk menghasilkan nilai berikutnya bersifat stateful atau kompleks.

- **State Machines (Mesin Keadaan):**

  - Coroutine dapat digunakan untuk mengimplementasikan state machine, di mana setiap keadaan dapat menjadi bagian dari fungsi coroutine, dan transisi keadaan melibatkan `yield` dan `resume`.

---

Memahami coroutine membuka pintu untuk menulis plugin Neovim yang lebih responsif dan canggih, terutama saat berhadapan dengan operasi yang memakan waktu. Mereka adalah dasar dari banyak pola pemrograman asinkron.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**

[1]: ../../README.md/#9-advanced-lua-concepts
[2]: ../../../../../README.md
[3]: ../../module/8-error-handling-dan-debugging/README.md
[4]: ../../module/10-metatables/README.md
