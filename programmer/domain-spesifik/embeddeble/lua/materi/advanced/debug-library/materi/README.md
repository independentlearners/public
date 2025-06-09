### **[Daftar Isi Uraian Kurikulum][0]**

- [**BAGIAN I: FONDASI FUNDAMENTAL**](#bagian-i-fondasi-fundamental)
  - [1. Konsep Dasar Debug Library](#modul-1-konsep-dasar-debug-library)
  - [2. Ekosistem Debugging Lua](#modul-2-ekosistem-debugging-lua)
- [**BAGIAN II: REFERENSI FUNGSI LENGKAP**](#bagian-ii-referensi-fungsi-lengkap)
  - [3. Introspective Functions - Bagian Utama](#modul-3-introspective-functions---bagian-utama)
  - [4. Introspective Functions - Upvalues dan Environment](#modul-4-introspective-functions---upvalues-dan-environment)
  - [5. Registry dan Metatable Access](#modul-5-registry-dan-metatable-access)
  - [6. Interactive Debugging Interface](#modul-6-interactive-debugging-interface)
- [**BAGIAN III: HOOK SYSTEM ADVANCED**](#bagian-iii-hook-system-advanced)
  - [7. Hook System Fundamentals](#modul-7-hook-system-fundamentals)
  - [8. Hook Event Types dan Use Cases](#modul-8-hook-event-types-dan-use-cases)
  - [9. Hook Performance Optimization](#modul-9-hook-performance-optimization)
- [**BAGIAN IV: DEBUGGING PATTERNS ADVANCED**](#bagian-iv-debugging-patterns-advanced)
  - [10. Custom Debugger Implementation](#modul-10-custom-debugger-implementation)
  - [11. Conditional Debugging Systems](#modul-11-conditional-debugging-systems)
  - [12. Error Handling Integration](#modul-12-error-handling-integration)
- [**BAGIAN V: PROFILING DAN PERFORMANCE ANALYSIS**](#bagian-v-profiling-dan-performance-analysis)
  - [13. Performance Profiling dengan Debug Library](#modul-13-performance-profiling-dengan-debug-library)
  - [14. Advanced Profiling Techniques](#modul-14-advanced-profiling-techniques)
- [**BAGIAN VI: REMOTE DEBUGGING**](#bagian-vi-remote-debugging)
  - [15. Remote Debugging Fundamentals](#modul-15-remote-debugging-fundamentals)
  - [16. MobDebug dan ZeroBrane Studio Integration](#modul-16-mobdebug-dan-zerobrane-studio-integration)
- [**BAGIAN VII: SPECIALIZED DEBUGGING SCENARIOS**](#bagian-vii-specialized-debugging-scenarios)
  - [18. Coroutine Debugging](#modul-18-coroutine-debugging)
- [**BAGIAN VIII: INTEGRATION DAN TOOLING**](#bagian-viii-integration-dan-tooling)
  - [21. IDE Integration](#modul-21-ide-integration)
- [**BAGIAN IX: ADVANCED TOPICS**](#bagian-ix-advanced-topics)
  - [26. Security Considerations](#modul-26-security-considerations)
- [**BAGIAN X: BEST PRACTICES DAN OPTIMIZATION**](#bagian-x-best-practices-dan-optimization)
  - [27. Performance Best Practices](#modul-27-performance-best-practices)
- [**Kesimpulan dan Langkah Selanjutnya**](#kesimpulan-dan-langkah-selanjutnya)

---

## **BAGIAN I: FONDASI FUNDAMENTAL**

Bagian ini adalah fondasi. Tujuannya adalah untuk memahami "mengapa" debug library ada dan posisinya dalam dunia Lua yang lebih luas. Tanpa pemahaman ini, menggunakan fungsi-fungsinya akan terasa seperti menghafal mantra tanpa tahu artinya.

### **Modul 1: Konsep Dasar Debug Library**

**Tujuan**: Memahami filosofi, arsitektur, dan posisi debug library dalam ekosistem Lua.

**Penjelasan Konsep**:
Debug library di Lua bukanlah sebuah _debugger_ yang siap pakai seperti yang Anda temukan di IDE besar (misalnya, debugger di Visual Studio atau Android Studio). Sebaliknya, ini adalah sebuah **API (Application Programming Interface)**, yaitu sekumpulan "balok bangunan" atau "perkakas" tingkat rendah yang memungkinkan Anda untuk **melihat ke dalam** mesin eksekusi Lua saat program sedang berjalan. Filosofinya adalah memberikan kekuatan dan fleksibilitas, bukan kenyamanan instan.

**Terminologi Kunci**:

- **Introspection (Introspeksi)**: Kemampuan sebuah program untuk memeriksa struktur dan propertinya sendiri saat runtime (saat berjalan). Contoh: "Fungsi apa yang sedang berjalan sekarang? Variabel lokal apa saja yang dimilikinya? Di baris kode mana eksekusi saat ini berada?"
- **Reflection (Refleksi)**: Lebih dari introspeksi, refleksi adalah kemampuan untuk _memodifikasi_ struktur dan perilaku program saat runtime. Contoh: "Saya melihat ada variabel lokal bernama `x`, sekarang ubah nilainya menjadi 100." Debug library Lua mendukung keduanya.
- **Debugger**: Sebuah program _terpisah_ yang menggunakan introspeksi dan refleksi untuk menyediakan antarmuka bagi programmer untuk mengontrol eksekusi (pause, step, resume), melihat variabel, dll. **Anda bisa membangun debugger Anda sendiri menggunakan debug library Lua.**
- **Profiler**: Alat yang mengukur performa program. Misalnya, seberapa sering sebuah fungsi dipanggil, atau berapa lama waktu yang dihabiskan di setiap fungsi. **Anda juga bisa membangun profiler menggunakan debug library Lua**, terutama dengan fungsi _hooks_.

**Trade-off**:
Kekuatan ini tidak gratis. Menggunakan debug library, terutama fitur seperti _hooks_ yang berjalan di setiap baris kode, dapat **memperlambat program Anda secara signifikan**. Oleh karena itu, penting untuk menggunakannya secara bijak dan seringkali menonaktifkannya di lingkungan produksi (saat aplikasi digunakan oleh pengguna akhir).

**Contoh Konseptual**:
Bayangkan mesin mobil.

- **Mengendarai mobil** adalah menjalankan program Lua biasa.
- **Debugger** adalah alat diagnostik canggih yang dihubungkan mekanik ke port OBD-II mobil Anda untuk melihat semua sensor secara real-time.
- **Lua Debug Library** adalah port OBD-II itu sendiri dan spesifikasi teknisnya. Ia tidak memberitahu Anda apa yang salah, tetapi memberi Anda akses mentah ke semua data sensor (putaran mesin, suhu oli) sehingga _Anda_ dapat membangun alat diagnostik Anda sendiri.

**Referensi**:

- Programming in Lua (PiL) - Chapter 23: The Debug Library: [https://www.lua.org/pil/23.html](https://www.lua.org/pil/23.html)
- SIMION Debug Library Documentation: [https://simion.com/info/lua_debug.html](https://simion.com/info/lua_debug.html)

#

### **Modul 2: Ekosistem Debugging Lua**

**Tujuan**: Memahami lanskap berbagai alat dan pendekatan debugging di Lua secara keseluruhan.

**Penjelasan Konsep**:
Karena Lua bersifat minimalis dan dapat disematkan (embeddable), cara orang men-debugnya sangat beragam, tergantung pada konteksnya (game, server web, aplikasi desktop).

**Pendekatan Debugging**:

1.  **Print Debugging**: Pendekatan paling sederhana dan universal. Anda menyisipkan `print()` di berbagai bagian kode Anda untuk mencetak nilai variabel atau pesan status.
    - **Kelebihan**: Sangat mudah, tidak memerlukan alat tambahan.
    - **Kekurangan**: Mengotori kode, tidak interaktif, sulit untuk melacak masalah yang kompleks.
2.  **Interactive Debugging**: Ini adalah debugging "klasik". Anda dapat menghentikan program di titik tertentu (breakpoint), mengeksekusi kode baris per baris (`step`), memeriksa nilai variabel, dan melanjutkan eksekusi. Ini biasanya dilakukan dengan alat seperti ZeroBrane Studio.
3.  **Remote Debugging**: Varian dari interactive debugging, tetapi debugger (IDE Anda) berjalan di satu mesin (misalnya, laptop Anda) dan program Lua berjalan di mesin lain (misalnya, server, perangkat seluler, atau konsol game). Keduanya berkomunikasi melalui jaringan. Ini sangat penting untuk men-debug aplikasi yang tidak berjalan secara lokal.

**Memilih Pendekatan yang Tepat**:

- Gunakan `print()` untuk masalah cepat dan sederhana.
- Gunakan **interactive debugger** saat pengembangan lokal untuk masalah yang lebih rumit.
- Gunakan **remote debugger** saat aplikasi Anda berjalan di lingkungan yang berbeda dari lingkungan pengembangan Anda.

**Referensi**:

- Lua-users Wiki: Debug Library Tutorial: [http://lua-users.org/wiki/DebugLibraryTutorial](http://lua-users.org/wiki/DebugLibraryTutorial)
- How to Debug in Lua - Comprehensive Guide: [https://how.dev/answers/how-to-debug-in-lua](https://how.dev/answers/how-to-debug-in-lua)

---

## **BAGIAN II: REFERENSI FUNGSI LENGKAP**

Bagian ini adalah inti dari library. Kita akan membedah fungsi-fungsi utamanya satu per satu.

### **Modul 3: Introspective Functions - Bagian Utama**

**Tujuan**: Menguasai fungsi-fungsi untuk "melihat ke dalam" eksekusi program.

#### **`debug.getinfo()`**

**Penjelasan Konsep**:
Ini adalah "pisau Swiss Army" dari debug library. Fungsi ini mengambil informasi tentang fungsi lain yang sedang aktif. Anda bisa merujuk ke fungsi tersebut dengan dua cara: berdasarkan **level tumpukan (stack level)** atau langsung merujuk pada **objek fungsi** itu sendiri.

**Terminologi Kunci**:

- **Call Stack (Tumpukan Panggilan)**: Daftar fungsi yang telah dipanggil tetapi belum selesai. Jika `main` memanggil `fungsiA`, dan `fungsiA` memanggil `fungsiB`, tumpukan panggilannya adalah `main -> fungsiA -> fungsiB`.
- **Stack Level**: Posisi dalam tumpukan panggilan. Level 1 adalah fungsi yang sedang berjalan saat ini. Level 2 adalah fungsi yang memanggilnya, dan seterusnya. Level 0 adalah `debug.getinfo` itu sendiri.

**Sintaks Dasar**:
`info_table = debug.getinfo(level_or_function, fields_string)`

- `level_or_function`: Angka (stack level) atau variabel yang berisi fungsi.
- `fields_string`: String yang menentukan informasi apa yang Anda inginkan.
  - `'n'`: `name` dan `namewhat` (nama fungsi).
  - `'S'`: `source`, `short_src`, `linedefined`, `lastlinedefined`, `what` (informasi sumber file).
  - `'l'`: `currentline` (baris saat ini).
  - `'u'`: `nups` (jumlah upvalues), `nparams` (jumlah parameter).
  - `'f'`: `func` (objek fungsi itu sendiri).
  - `'L'`: `activelines` (tabel berisi nomor baris yang valid untuk dieksekusi).

**Contoh Kode**:

```lua
function hitungLuas(panjang, lebar)
    local hasil = panjang * lebar
    -- Kita akan memeriksa fungsi ini dari dalam
    local info = debug.getinfo(1, "nSl") -- Level 1 adalah hitungLuas

    print("--- Info Fungsi ---")
    print("Nama: " .. (info.name or "tidak ada"))
    print("Sumber: " .. info.short_src)
    print("Baris didefinisikan: " .. info.linedefined)
    print("Baris saat ini: " .. info.currentline)
    print("--------------------")

    return hasil
end

hitungLuas(10, 5)
```

**Output yang Diharapkan**:

```
--- Info Fungsi ---
Nama: hitungLuas
Sumber: [string "..."] -- atau nama file jika dari file
Baris didefinisikan: 1
Baris saat ini: 5
--------------------
```

#### **`debug.getlocal()` dan `debug.setlocal()`**

**Penjelasan Konsep**:
Fungsi-fungsi ini memungkinkan Anda untuk **membaca dan menulis variabel lokal** dari fungsi lain yang ada di tumpukan panggilan. Ini sangat kuat untuk debugging interaktif.

**Sintaks Dasar**:
`name, value = debug.getlocal(level, variable_index)`
`debug.setlocal(level, variable_index, new_value)`

- `level`: Stack level dari fungsi target.
- `variable_index`: Indeks variabel. Angka positif untuk parameter dan variabel lokal yang terlihat. Angka negatif untuk variabel internal/temporer.

**Contoh Kode**:

```lua
function ujiLokal()
    local rahasia = "Ini rahasia"
    local angka = 42

    -- Fungsi inner ini akan memata-matai scope luar (ujiLokal)
    local function mataMata()
        -- Membaca variabel lokal dari fungsi yang memanggilnya (level 2)
        local nama, nilai = debug.getlocal(2, 1) -- index 1 adalah 'rahasia'
        print(string.format("Level 2, Var 1: '%s' = %s", nama, nilai))

        -- Memodifikasi variabel lokal 'angka' di fungsi pemanggil
        debug.setlocal(2, 2, 99) -- index 2 adalah 'angka'
    end

    mataMata()
    print("Setelah dimodifikasi, angka = " .. angka)
end

ujiLokal()
```

**Output yang Diharapkan**:

```
Level 2, Var 1: 'rahasia' = Ini rahasia
Setelah dimodifikasi, angka = 99
```

#

### **Modul 4: Introspective Functions - Upvalues dan Environment**

**Tujuan**: Memahami cara men-debug closure dan memanipulasi environment.

**Terminologi Kunci**:

- **Closure**: Sebuah fungsi yang "mengingat" environment tempat ia dibuat. Secara spesifik, ia bisa mengakses variabel lokal dari fungsi yang melingkupinya, bahkan setelah fungsi luar tersebut selesai dieksekusi.
- **Upvalue**: Variabel lokal dari scope luar yang "ditangkap" oleh sebuah closure.

**Visualisasi Closure dan Upvalue**:

```
function PabrikPenghitung()
    local counter = 0  -- <-- 'counter' adalah variabel lokal

    local fungsiPenghitung = function() -- <-- Ini adalah closure
        counter = counter + 1 -- Ia "menangkap" 'counter'
        return counter        -- 'counter' sekarang menjadi upvalue bagi fungsiPenghitung
    end

    return fungsiPenghitung
end

penghitungA = PabrikPenghitung()
print(penghitungA()) -- Output: 1
print(penghitungA()) -- Output: 2
-- 'counter' masih ada, terikat pada 'penghitungA' sebagai upvalue
```

#### **`debug.getupvalue()` dan `debug.setupvalue()`**

**Penjelasan Konsep**:
Mirip seperti `get/setlocal`, tetapi untuk upvalue dari sebuah closure.

**Sintaks Dasar**:
`name, value = debug.getupvalue(closure_function, upvalue_index)`
`name = debug.setupvalue(closure_function, upvalue_index, new_value)`

**Contoh Kode**:

```lua
function buatGreeter(sapaan)
    local nama = "Dunia"

    local greeter = function()
        print(sapaan .. ", " .. nama .. "!")
    end

    return greeter
end

greetHello = buatGreeter("Halo")

-- Memeriksa dan memodifikasi upvalues dari 'greetHello'
local up_name, up_val = debug.getupvalue(greetHello, 1) -- upvalue pertama (sapaan)
print(string.format("Upvalue 1: '%s' = %s", up_name, up_val))

up_name, up_val = debug.getupvalue(greetHello, 2) -- upvalue kedua (nama)
print(string.format("Upvalue 2: '%s' = %s", up_name, up_val))

-- Mari ubah upvalue 'nama'
debug.setupvalue(greetHello, 2, "Lua")

-- Sekarang panggil fungsi yang sudah dimodifikasi
greetHello()
```

**Output yang Diharapkan**:

```
Upvalue 1: 'sapaan' = Halo
Upvalue 2: 'nama' = Dunia
Halo, Lua!
```

---

### **Modul 5: Registry dan Metatable Access**

**Tujuan**: Memahami cara mengakses dan memanipulasi struktur internal Lua seperti registry dan metatable.

**Terminologi Kunci**:

- **Registry**: Bayangkan ini sebagai sebuah "lemari penyimpanan rahasia" yang hanya dapat diakses melalui debug library (atau dari kode C). Ini adalah sebuah tabel Lua global yang tersembunyi. Kegunaan utamanya adalah untuk kode C yang berinteraksi dengan Lua untuk menyimpan nilai-nilai Lua tanpa harus meletakkannya di lingkungan global yang bisa diakses oleh skrip Lua biasa. Ini mencegah nilai-nilai penting terhapus oleh _garbage collector_ atau diubah secara tidak sengaja.
- **Metatable**: Ini adalah jantung dari sistem objek di Lua. Metatable adalah sebuah tabel biasa yang mendefinisikan "perilaku" dari tabel atau `userdata` lain ketika operasi tertentu dilakukan padanya.
- **Metamethod**: Fungsi di dalam metatable yang menentukan perilaku tersebut. Contohnya: `__index` (dipanggil saat mengakses field yang tidak ada), `__newindex` (saat membuat field baru), `__tostring` (saat menggunakan `tostring()`), `__add` (saat menggunakan operator `+`).
- **`__metatable` protection**: Sebuah field di dalam metatable yang, jika ada, nilainya akan dikembalikan ketika seseorang mencoba mengambil metatable tersebut. Ini adalah cara untuk "melindungi" atau "menyembunyikan" metatable asli.

#### **`debug.getregistry()`**

**Penjelasan Konsep**: Fungsi ini hanya mengembalikan tabel registry. Ini memberi Anda akses penuh ke "lemari rahasia" Lua. Anda harus sangat berhati-hati saat memanipulasi tabel ini karena ini adalah inti dari state C-Lua.

**Sintaks Dasar**:
`registry_table = debug.getregistry()`

**Contoh Kode**:

```lua
-- Mendapatkan tabel registry
local reg = debug.getregistry()

-- Registry berisi beberapa kunci yang sudah dikenal
-- LUA_RIDX_MAINTHREAD berisi thread utama
-- LUA_RIDX_GLOBALS berisi tabel global _G
print("Apakah registry[_G] sama dengan _G?", reg[2] == _G)

-- Iterasi melalui registry (HATI-HATI di kode produksi)
-- for k, v in pairs(reg) do
--     print("Registry Key:", k, "Type:", type(v))
-- end
```

#### **`debug.getmetatable()` dan `debug.setmetatable()`**

**Penjelasan Konsep**:
Fungsi-fungsi ini memungkinkan Anda untuk melihat atau mengubah metatable dari _objek apapun_ di Lua (tabel, userdata, string, dll.). `debug.getmetatable()` sangat kuat karena ia akan **mengabaikan proteksi `__metatable`**, memberi Anda metatable yang sebenarnya, bukan yang disembunyikan. Ini sangat berguna untuk men-debug perilaku objek yang kompleks.

**Sintaks Dasar**:
`meta = debug.getmetatable(object)`
`debug.setmetatable(object, metatable_table)`

**Contoh Kode**:

```lua
local data = { nilai = 10 }

local mt_asli = {
    __index = function(t, k) return "Field tidak ada" end,
    __metatable = "Metatable ini dilindungi!" -- Proteksi
}

setmetatable(data, mt_asli)

-- Upaya normal untuk mendapatkan metatable akan dihalangi
print("getmetatable biasa:", getmetatable(data))

-- debug.getmetatable akan membypass proteksi
local meta_sebenarnya = debug.getmetatable(data)
print("debug.getmetatable:", meta_sebenarnya)
print("Apakah meta_sebenarnya sama dengan mt_asli?", meta_sebenarnya == mt_asli)

-- Kita bisa mengganti metatable secara paksa
local mt_baru = { __tostring = function() return "Data Baru!" end }
debug.setmetatable(data, mt_baru)

print("Data setelah metatable diubah:", tostring(data))
```

**Output yang Diharapkan**:

```
getmetatable biasa: Metatable ini dilindungi!
debug.getmetatable: table: 0x...
Apakah meta_sebenarnya sama dengan mt_asli?: true
Data setelah metatable diubah: Data Baru!
```

#

### **Modul 6: Interactive Debugging Interface**

**Tujuan**: Menguasai kapabilitas debugging interaktif bawaan Lua.

#### **`debug.debug()`**

**Penjelasan Konsep**:
Ini adalah debugger konsol yang sangat sederhana dan bawaan. Ketika fungsi ini dipanggil, eksekusi program Anda akan berhenti, dan Lua akan masuk ke mode interaktif, menunggu input dari Anda melalui `stdin` (biasanya terminal). Anda bisa mengetikkan perintah untuk memeriksa variabel atau bahkan mengeksekusi kode Lua.

**Mode Interaktif**:
Setelah `debug.debug()` dipanggil, Anda akan melihat prompt `lua_debug>`. Di sini Anda bisa:

- Mengetikkan `cont` untuk melanjutkan eksekusi program.
- Mengetikkan `step` untuk mengeksekusi satu baris kode.
- Mengetikkan `stop` untuk menghentikan eksekusi (menimbulkan error).
- Mengetikkan baris kode Lua apa pun. Kode ini akan dieksekusi dalam konteks fungsi yang sedang berhenti. Ini berarti Anda dapat mencetak nilai variabel lokal.

**Sintaks Dasar**:
`debug.debug()`

**Contoh Kode**:

```lua
function areaBermasalah(x)
    local y = x * 2
    local z = y + 5

    print("Berhenti sejenak untuk inspeksi...")
    debug.debug() -- Eksekusi akan berhenti di sini

    local hasil = z / (x - 1) -- Potensi error jika x = 1
    print("Hasilnya adalah: " .. hasil)
end

print("Memanggil fungsi...")
areaBermasalah(10)
print("Fungsi selesai.")
```

**Sesi Interaktif di Terminal**:

```
Memanggil fungsi...
Berhenti sejenak untuk inspeksi...
lua_debug> print(x)
10
lua_debug> print(y)
20
lua_debug> print(z)
25
lua_debug> y = 100 -- kita bisa ubah nilainya
lua_debug> print(y)
100
lua_debug> cont
Hasilnya adalah: 2.7777777777778
Fungsi selesai.
```

Fungsi ini adalah fondasi untuk membangun REPL (Read-Eval-Print Loop) custom.

---

## **BAGIAN III: HOOK SYSTEM ADVANCED**

Ini adalah salah satu fitur paling kuat dan kompleks dari debug library. Hook memungkinkan Anda untuk "menyadap" event-event tertentu selama eksekusi program.

### **Modul 7: Hook System Fundamentals**

**Tujuan**: Memahami debugging berbasis event dengan sistem hook.

**Penjelasan Konsep**:
Bayangkan Anda bisa memberi tahu mesin Lua: "Hei, setiap kali kamu akan mengeksekusi baris kode baru, panggil dulu fungsi X milikku." atau "Setiap kali sebuah fungsi dipanggil, beri tahu aku\!". Inilah yang dilakukan `debug.sethook()`. Anda mendaftarkan sebuah _fungsi callback_ (hook function) yang akan dieksekusi secara otomatis oleh Lua ketika event tertentu terjadi.

**Diagram Konseptual Sistem Hook**:

```
+------------------+      (1) Eksekusi normal
|                  | --------------------------->
|     Lua VM       |      (2) Event terjadi
| (Mesin Virtual)  |          (misal: 'call')
|                  | <---------------------------
+------------------+      (4) Eksekusi dilanjutkan
      |  ^
      |  | (3) VM memanggil hook Anda
      v  |
+------------------+
|                  |
|  Fungsi Hook     |
|   Anda           |
+------------------+
```

**Sintaks Dasar**:
`debug.sethook(hook_function, mask_string, count)`

- `hook_function`: Fungsi yang akan dipanggil saat event terjadi. Jika `nil`, hook akan dinonaktifkan.
- `mask_string`: String yang menentukan event mana yang akan disadap.
  - `'c'`: **call hook**. Dipanggil setiap kali Lua memanggil sebuah fungsi.
  - `'r'`: **return hook**. Dipanggil setiap kali sebuah fungsi kembali (selesai).
  - `'l'`: **line hook**. Dipanggil setiap kali Lua akan mengeksekusi baris kode baru.
- `count`: Opsi tambahan.
  - Jika `mask` berisi `'c'`, `'r'`, atau `'l'`, `count` tidak digunakan.
  - Jika `mask` tidak ada, hook dipanggil setiap `count` instruksi virtual machine. Ini disebut **count hook**.

**Contoh Kode (Line Hook Sederhana)**:

```lua
local function lineTracer(event, line)
    -- 'event' akan "line"
    local info = debug.getinfo(2, "S") -- Dapatkan info fungsi di level 2
    print(string.format("Eksekusi baris %d di file %s", line, info.short_src))
end

-- Atur hook untuk setiap baris
debug.sethook(lineTracer, "l")

-- Kode yang akan dilacak
local a = 1
local b = a + 5
print("Selesai")

-- Matikan hook setelah selesai
debug.sethook()
```

**Output yang Diharapkan**:

```
Eksekusi baris 8 di file [string "..."]
Eksekusi baris 9 di file [string "..."]
Eksekusi baris 10 di file [string "..."]
Selesai
Eksekusi baris 13 di file [string "..."]
```

Ini adalah dasar untuk membangun debugger **step-by-step** atau alat analisis cakupan kode (code coverage).

---

### **Modul 8: Hook Event Types dan Use Cases**

**Tujuan**: Memahami setiap jenis hook dan aplikasi praktisnya.

#### **Call Hooks (`'c'`)**

- **Kapan dipicu?**: Tepat sebelum Lua mengeksekusi sebuah fungsi.
- **Use Case 1: Function Call Tracing**: Mencatat setiap fungsi yang dipanggil untuk memahami alur program.

  ```lua
  local indent = 0
  debug.sethook(function(event, line)
      local info = debug.getinfo(2, "n")
      if event == "call" then
          print(string.rep("  ", indent) .. "--> Memanggil:", info.name or "fungsi anonim")
          indent = indent + 1
      elseif event == "return" then
          indent = indent - 1
          print(string.rep("  ", indent) .. "<-- Kembali dari:", info.name or "fungsi anonim")
      end
  end, "cr") -- 'c' untuk call, 'r' untuk return

  function A() B() end
  function B() print("Dalam B") end
  A()
  debug.sethook()
  ```

- **Use Case 2: Profiling Sederhana**: Menghitung berapa kali setiap fungsi dipanggil.

#### **Return Hooks (`'r'`)**

- **Kapan dipicu?**: Tepat setelah sebuah fungsi selesai dan akan mengembalikan nilai.
- **Use Case: Mengukur Waktu Eksekusi Fungsi**:
  ```lua
  local call_times = {}
  debug.sethook(function(event)
      local info = debug.getinfo(2, "f") -- 'f' untuk mendapatkan objek fungsi
      if event == "call" then
          call_times[info.func] = os.clock()
      elseif event == "return" and call_times[info.func] then
          local duration = os.clock() - call_times[info.func]
          print(string.format("Fungsi %s berjalan selama %.5f detik",
                              debug.getinfo(info.func, "n").name or "anonim",
                              duration))
          call_times[info.func] = nil
      end
  end, "cr")
  ```

#### **Line Hooks (`'l'`)**

- **Kapan dipicu?**: Setiap kali interpreter akan mengeksekusi baris kode baru.
- **Sangat powerful, tetapi juga paling lambat.**
- **Use Case 1: Step-by-Step Debugger**: Inilah cara debugger seperti ZeroBrane mengimplementasikan "Step Into". Hook memeriksa baris saat ini, dan jika ada breakpoint, ia akan berhenti dan menunggu perintah pengguna.
- **Use Case 2: Analisis Cakupan Kode (Code Coverage)**: Membuat tabel untuk mencatat setiap baris yang dieksekusi. Di akhir program, Anda bisa melihat baris mana yang tidak pernah dijalankan saat testing.

#### **Count Hooks (mask kosong, `count` > 0)**

- **Kapan dipicu?**: Setiap `count` instruksi bytecode Lua dieksekusi.
- **Lebih efisien daripada line hook** karena tidak terikat pada baris sumber, melainkan pada operasi tingkat rendah VM.
- **Use Case: Deteksi Infinite Loop**: Jika sebuah fungsi berjalan terlalu lama tanpa kembali, Anda bisa menggunakan count hook untuk memicu error timeout.

  ```lua
  local instruction_limit = 1000000 -- Batas 1 juta instruksi
  local start_time = os.clock()

  debug.sethook(function()
      error("Eksekusi melebihi batas instruksi! Mungkin infinite loop?")
  end, "", instruction_limit)

  -- Kode yang berpotensi loop tak terbatas
  -- while true do end

  debug.sethook() -- Jangan lupa matikan jika selesai
  ```

#

### **Modul 9: Hook Performance Optimization**

**Tujuan**: Mengoptimalkan penggunaan hook untuk meminimalkan overhead.

**Penjelasan Konsep**:
Setiap kali hook dipanggil, Lua harus menghentikan eksekusi normal, mengemas informasi, memanggil fungsi hook Anda (yang ditulis di Lua), dan kemudian kembali. Proses ini memiliki biaya. Jika hook Anda dipanggil jutaan kali (seperti line hook dalam loop besar), program Anda bisa menjadi 10x-100x lebih lambat.

**Strategi Optimasi**:

1.  **Gunakan Hook Paling Jarang**: Jika Anda hanya perlu tahu kapan fungsi dipanggil, gunakan `'c'` (call hook), bukan `'l'` (line hook). Jika Anda ingin mendeteksi loop, gunakan count hook, bukan line hook.
2.  **Aktifkan Hook Secara Kondisional**: Jangan mengaktifkan hook secara global. Aktifkan hanya saat memasuki bagian kode yang ingin Anda analisis, dan nonaktifkan segera setelah keluar.

    ```lua
    function fungsiYangDiinspeksi()
        -- Aktifkan hook hanya di sini
        debug.sethook(my_hook, "l")

        -- ... kode yang dianalisis ...

        -- Matikan lagi sebelum keluar
        debug.sethook()
    end
    ```

3.  **Buat Fungsi Hook Secepat Mungkin**: Hindari alokasi memori (membuat tabel/string baru), I/O (mencetak ke konsol), atau logika yang kompleks di dalam fungsi hook Anda. Lakukan pekerjaan seminimal mungkin.
4.  **Gunakan C untuk Hook Kritis**: Untuk performa maksimal, fungsi hook dapat ditulis dalam C. Ini jauh lebih cepat tetapi juga lebih kompleks untuk diimplementasikan.

---

## **BAGIAN IV: DEBUGGING PATTERNS ADVANCED**

Di bagian ini, kita beralih dari _menggunakan_ perkakas menjadi _membangun_ mesin yang canggih dengan perkakas tersebut.

### **Modul 10: Custom Debugger Implementation**

**Tujuan**: Merancang dan membangun debugger kustom dari awal.

**Arsitektur Dasar Debugger**:
Debugger buatan sendiri biasanya terdiri dari komponen-komponen berikut:

1.  **Breakpoint Manager**: Sebuah tabel yang menyimpan lokasi breakpoint, biasanya dengan format `{[nama_file] = {[nomor_baris] = true}}`.
2.  **Execution Control (Core Loop)**: Menggunakan **line hook (`'l'`)**. Fungsi hook ini akan:
    - Mendapatkan lokasi saat ini (`debug.getinfo`).
    - Memeriksa apakah lokasi saat ini ada di dalam Breakpoint Manager.
    - Jika ya, hentikan eksekusi dan masuk ke Command Loop.
3.  **Command Loop (REPL)**: Mirip dengan `debug.debug()`. Loop ini membaca input pengguna (`step`, `continue`, `print var`, `set var`, dll.).
    - `continue`: Menonaktifkan line hook sementara dan melanjutkan eksekusi normal (atau menggunakan return hook untuk mengaktifkannya kembali).
    - `step over`: Tetap menggunakan line hook tetapi mengabaikan `call` events hingga kembali ke stack level yang sama.
    - `print var`: Menggunakan `debug.getlocal`, `debug.getupvalue` untuk mengambil dan mencetak nilai variabel.
4.  **Expression Evaluation Engine**: Menggunakan `loadstring` (atau `load` di Lua 5.2+) untuk mengeksekusi string sebagai kode Lua dalam konteks saat ini, memungkinkan pengguna mengevaluasi ekspresi yang kompleks.

**Referensi Implementasi**:

- **debugger.lua**: Proyek ini [https://github.com/slembcke/debugger.lua](https://github.com/slembcke/debugger.lua) adalah contoh nyata yang sangat baik untuk dipelajari. Ini adalah debugger file tunggal yang mengimplementasikan semua konsep di atas.

Ini adalah gambaran besar dari beberapa bagian selanjutnya. Seperti yang Anda lihat, setiap modul dibangun di atas pemahaman modul sebelumnya, dari fungsi dasar hingga pola arsitektur yang kompleks.

[0]: ../README.md
