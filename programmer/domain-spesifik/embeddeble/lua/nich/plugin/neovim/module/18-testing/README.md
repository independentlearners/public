# **[18. Pengujian Plugin (Testing)][0896]**

Bagian ini akan membahas pentingnya pengujian dalam siklus pengembangan plugin Neovim, memperkenalkan jenis-jenis pengujian utama (unit dan integrasi), serta alat dan kerangka kerja yang dapat Anda gunakan untuk mengimplementasikannya. Anda tahu bahwa menulis kode hanyalah sebagian dari pekerjaan. Memastikan kode tersebut berfungsi dengan benar, andal, dan mudah dipelihara adalah sama pentingnya. Di sinilah pengujian (testing) berperan. Mari kita lanjutkan ke Bagian 18: Pengujian Plugin.

---

### 18.1 Pentingnya Pengujian

- **Deskripsi Konsep:**
  - **Pengujian Perangkat Lunak (Software Testing):** Adalah proses evaluasi dan verifikasi bahwa sebuah produk atau aplikasi perangkat lunak melakukan apa yang seharusnya dilakukan. Tujuannya adalah untuk menemukan kesalahan, celah, atau persyaratan yang hilang dibandingkan dengan persyaratan aktual.
  - **Mengapa Pengujian Penting untuk Plugin Neovim?**
    1.  **Keandalan (Reliability):** Memastikan plugin Anda bekerja secara konsisten dan tidak menyebabkan crash atau perilaku tak terduga di Neovim. Pengguna mengandalkan editor mereka untuk stabil.
    2.  **Kualitas Kode (Code Quality):** Proses penulisan tes seringkali memaksa Anda untuk menulis kode yang lebih modular, lebih mudah diuji, dan pada akhirnya lebih berkualitas.
    3.  **Kemudahan Pemeliharaan (Maintainability):** Dengan adanya tes, Anda dapat melakukan refactoring atau menambahkan fitur baru dengan lebih percaya diri, karena tes akan membantu menangkap regresi (kesalahan yang muncul kembali pada fungsionalitas yang sebelumnya bekerja).
    4.  **Menangkap Regresi (Regression Catching):** Setiap kali Anda memperbaiki bug, Anda bisa menambahkan tes untuk bug tersebut. Jika bug itu muncul kembali di masa depan, tes akan gagal, memberitahu Anda segera.
    5.  **Dokumentasi Hidup (Living Documentation):** Tes dapat berfungsi sebagai bentuk dokumentasi yang menunjukkan bagaimana seharusnya unit kode atau fitur tertentu digunakan dan berperilaku.
    6.  **Kompatibilitas:** Membantu memastikan plugin Anda tetap berfungsi setelah pembaruan Neovim atau dependensi lainnya (meskipun ini tidak selalu dijamin 100% tanpa tes spesifik untuk versi baru).
- **Implementasi dalam Neovim:** Pengujian yang baik adalah tanda plugin yang matang dan profesional. Ini membangun kepercayaan pengguna dan membuat hidup Anda sebagai pengembang lebih mudah dalam jangka panjang.

---

### 18.2 Unit Testing (Pengujian Unit)

- **Deskripsi Konsep:**
  - **Unit Testing:** Fokus pada pengujian bagian terkecil dari kode yang dapat diisolasi, yang disebut "unit". Dalam Lua, sebuah unit seringkali adalah sebuah fungsi atau modul. Tujuan unit testing adalah untuk memverifikasi bahwa setiap unit kode bekerja dengan benar secara terpisah dari bagian lain sistem.
  - **Karakteristik Unit Test yang Baik:**
    - **Cepat:** Harus berjalan dengan cepat sehingga dapat sering dijalankan.
    - **Terisolasi:** Tidak bergantung pada unit lain atau state eksternal (misalnya, database, jaringan, atau state editor Neovim itu sendiri, yang seringkali di-_mock_ atau di-_stub_).
    - **Dapat Diulang (Repeatable):** Harus memberikan hasil yang sama setiap kali dijalankan dengan input yang sama.
    - **Self-Validating:** Tes itu sendiri yang menentukan apakah ia lulus atau gagal (melalui _assertions_).
- **Terminologi:**
  - **Test Case (Kasus Uji):** Sebuah skenario pengujian spesifik untuk sebuah unit, biasanya terdiri dari input tertentu dan output atau perilaku yang diharapkan.
  - **Test Suite (Rangkaian Uji):** Kumpulan dari beberapa test case, seringkali untuk menguji sebuah modul atau fungsionalitas tertentu secara menyeluruh.
  - **Assertion (Asersi):** Pernyataan dalam sebuah test case yang memeriksa apakah sebuah kondisi benar. Jika kondisi salah, asersi gagal, dan test case tersebut dianggap gagal.
  - **Mocking (Memalsukan):** Membuat objek palsu yang mensimulasikan perilaku objek nyata (dependensi). Digunakan untuk mengisolasi unit yang diuji dari dependensinya. Misalnya, jika fungsi Anda memanggil `vim.api.nvim_get_current_buf()`, dalam unit test, Anda bisa mem-mock `vim.api.nvim_get_current_buf()` agar mengembalikan nilai yang Anda kontrol tanpa benar-benar berinteraksi dengan Neovim.
  - **Stubbing (Menyisipkan):** Mirip dengan mocking, tetapi biasanya lebih fokus pada penyediaan data atau respons kalengan untuk panggilan tertentu, daripada mensimulasikan seluruh perilaku objek.
- **Framework Pengujian Unit untuk Lua:**
  - **Busted:** Salah satu framework pengujian BDD (Behavior-Driven Development) yang paling populer untuk Lua. Menyediakan sintaks yang deskriptif (`describe`, `it`), berbagai macam asersi, dukungan untuk mocking/stubbing, dan test runner.
  - **plenary.nvim (Modul `plenary.test`):** Pustaka utilitas `plenary.nvim`, yang banyak digunakan dalam ekosistem plugin Neovim, menyertakan sebuah _test harness_ (kerangka kerja pengujian). Ini seringkali dibangun di atas atau terinspirasi oleh Busted dan menyediakan cara yang nyaman untuk menulis tes yang sadar akan lingkungan Neovim (meskipun unit test sebisa mungkin menghindari ketergantungan Neovim). Sintaks asersi dalam contoh dokumen (`assert.True`, `assert.Equals`) sangat mirip dengan yang ditemukan di `plenary.test` atau Busted. Kita akan mengasumsikan konteks seperti ini.
- **Implementasi dalam Neovim:** Ideal untuk menguji logika murni Lua dalam plugin Anda: fungsi utilitas, manipulasi data, algoritma, dll., yang tidak secara langsung memanggil API Neovim yang mengubah state editor.
- **Sumber Dokumentasi:**
  - **Busted:** [http://olivinelabs.com/busted/](https://www.google.com/search?q=http://olivinelabs.com/busted/)
  - **plenary.nvim (Testing):** Dokumentasi di repositori GitHub plenary.nvim. (Biasanya ada di `doc/plenary.txt` atau wiki).
  - Prinsip-prinsip umum unit testing.

#### Menulis Test Case (dengan sintaks mirip Busted/Plenary)

Struktur umum test case menggunakan gaya BDD adalah:

1.  **`describe(description_string, function() ... end)`:** Mengelompokkan serangkaian tes terkait, biasanya untuk sebuah modul atau fungsionalitas.
2.  **`it(behavior_string, function() ... end)`:** Mendefinisikan satu test case spesifik yang menjelaskan perilaku yang diharapkan.
3.  **Arrange, Act, Assert (AAA):**
    - **Arrange:** Siapkan semua prasyarat, variabel, dan mock yang dibutuhkan untuk tes.
    - **Act:** Jalankan unit kode yang sedang diuji.
    - **Assert:** Verifikasi bahwa output atau perilaku sesuai dengan yang diharapkan menggunakan fungsi asersi.

<!-- end list -->

- **Sintaks Per Baris (Asersi Umum dari Framework seperti `plenary.test` atau Busted):**
  - `assert.True(kondisi_boolean, pesan_opsional)`: Memastikan `kondisi_boolean` adalah `true`.
  - `assert.False(kondisi_boolean, pesan_opsional)`: Memastikan `kondisi_boolean` adalah `false`.
  - `assert.Nil(nilai, pesan_opsional)`: Memastikan `nilai` adalah `nil`.
  - `assert.Not_nil(nilai, pesan_opsional)`: Memastikan `nilai` bukan `nil`.
  - `assert.Equals(nilai_aktual, nilai_yang_diharapkan, pesan_opsional)`: Memastikan `nilai_aktual` sama dengan `nilai_yang_diharapkan` (biasanya perbandingan dalam, deep comparison untuk tabel).
  - `assert.Not_equals(nilai_aktual, nilai_yang_tidak_diharapkan, pesan_opsional)`: Memastikan tidak sama.
  - `assert.Same(tabel_aktual, tabel_yang_diharapkan, pesan_opsional)`: Memastikan dua tabel adalah objek yang sama persis (referensi yang sama), atau perbandingan dalam tergantung framework. Seringkali `assert.Equals` lebih umum untuk membandingkan isi tabel.
  - `assert.Error(fungsi_yang_dijalankan, pesan_error_yang_diharapkan_opsional)`: Memastikan `fungsi_yang_dijalankan` memunculkan error. Bisa juga memeriksa pesan error spesifik. (Sintaks bisa juga `assert.has_error(func, pattern)` atau `assert.catches(func, pattern)`).

**Contoh Kode (Unit Testing):**
Misalkan kita memiliki file modul `lua/myplugin/utils.lua`:

```lua
-- file: lua/myplugin/utils.lua
local M = {}

function M.add(a, b)
  if type(a) ~= "number" or type(b) ~= "number" then
    error("Input harus berupa angka")
  end
  return a + b
end

function M.is_string_empty(s)
  if s == nil then return true end -- Anggap nil sebagai string kosong untuk fungsi ini
  if type(s) ~= "string" then
    error("Input harus berupa string atau nil")
  end
  return s == ""
end

return M
```

Dan file tesnya `tests/unit/myplugin/utils_spec.lua` (struktur direktori umum untuk tes):

```lua
-- file: tests/unit/myplugin/utils_spec.lua
-- Asumsikan ini dijalankan dengan test runner yang menyediakan 'describe', 'it', dan 'assert'
-- (misalnya, Plenary test atau Busted).

-- Mengimpor modul yang akan diuji.
-- Penyesuaian path mungkin diperlukan tergantung bagaimana test runner memuat file.
-- Untuk Plenary, seringkali path relatif dari root proyek.
local utils = require('myplugin.utils') -- Sesuaikan path jika perlu

describe("Modul myplugin.utils", function()

    describe("fungsi add()", function()
        it("seharusnya menjumlahkan dua angka positif dengan benar", function()
            -- Arrange: tidak ada setup khusus di sini
            -- Act: panggil fungsi yang diuji
            local result = utils.add(2, 3)
            -- Assert: verifikasi hasilnya
            -- assert.Equals(aktual, diharapkan, pesan_opsional)
            assert.Equals(result, 5, "2 + 3 seharusnya 5")
        end)

        it("seharusnya menjumlahkan angka positif dan negatif", function()
            local result = utils.add(5, -2)
            assert.Equals(result, 3)
        end)

        it("seharusnya memunculkan error jika input bukan angka", function()
            -- assert.has_error(fungsi_untuk_dijalankan, pola_pesan_error_opsional)
            -- atau sintaks serupa seperti assert.catches() atau assert.error()
            assert.has_error(function() utils.add("halo", 2) end, "Input harus berupa angka")
            assert.has_error(function() utils.add(10, {}) end, "Input harus berupa angka")
        end)
    end)

    describe("fungsi is_string_empty()", function()
        it("seharusnya mengembalikan true untuk string kosong", function()
            assert.True(utils.is_string_empty(""), "String kosong seharusnya true")
        end)

        it("seharusnya mengembalikan true untuk nil", function()
            assert.True(utils.is_string_empty(nil), "Nil seharusnya dianggap string kosong dan true")
        end)

        it("seharusnya mengembalikan false untuk string tidak kosong", function()
            assert.False(utils.is_string_empty("halo"), "String 'halo' seharusnya false")
            assert.False(utils.is_string_empty(" "), "String spasi seharusnya false")
        end)

        it("seharusnya memunculkan error jika input bukan string atau nil", function()
            assert.has_error(function() utils.is_string_empty(123) end, "Input harus berupa string atau nil")
            assert.has_error(function() utils.is_string_empty({}) end, "Input harus berupa string atau nil")
        end)
    end)
end)
```

**Cara Menjalankan Kode (Unit Test):**

1.  **Struktur Direktori:** Biasanya, tes disimpan dalam direktori terpisah, misalnya `tests/unit/`. Nama file tes seringkali diakhiri dengan `_spec.lua` atau `_test.lua`.
2.  **Test Runner:**
    - **Busted:** Anda akan menjalankan `busted` dari baris perintah di direktori proyek Anda.
    - **Plenary:** Anda bisa menjalankan tes dari dalam Neovim, misalnya dengan perintah seperti `:PlenaryTestFile tests/unit/myplugin/utils_spec.lua` atau melalui fungsi Lua yang disediakan plenary.
3.  Runner akan mengeksekusi semua `describe` dan `it` blok, dan melaporkan apakah semua asersi lulus.

**Penjelasan Kode Keseluruhan (`utils_spec.lua`):**

- `require('myplugin.utils')`: Memuat modul `utils` yang akan diuji. Path ini mungkin perlu disesuaikan tergantung konfigurasi test runner Anda dan bagaimana ia menangani path modul.
- `describe("Modul myplugin.utils", ...)`: Membuat sebuah _test suite_ untuk modul `utils`.
- `describe("fungsi add()", ...)`: Sub-suite untuk fungsi `add`.
- `it("seharusnya menjumlahkan...", ...)`: Mendefinisikan satu _test case_. Nama `it` harus deskriptif tentang perilaku yang diuji.
- Di dalam setiap `it` blok:
  - `local result = utils.add(2, 3)`: Bagian **Act**.
  - `assert.Equals(result, 5, ...)`: Bagian **Assert**. Memeriksa apakah hasil aktual sama dengan yang diharapkan.
  - `assert.has_error(function() ... end, "pesan error")`: Menguji penanganan error. Ia menjalankan fungsi anonim dan memeriksa apakah error dimunculkan, dan apakah pesan errornya cocok (jika disediakan).

---

### 18.3 Integration Testing (Pengujian Integrasi)

- **Deskripsi Konsep:**
  - **Integration Testing:** Fokus pada pengujian interaksi antara beberapa komponen atau modul dari plugin Anda, atau antara plugin Anda dengan Neovim itu sendiri (API, state editor). Tujuannya adalah untuk memastikan bahwa bagian-bagian yang berbeda bekerja sama dengan benar.
  - **Perbedaan dengan Unit Test:** Unit test mengisolasi unit, sedangkan integration test memverifikasi bagaimana unit-unit tersebut berkolaborasi. Integration test cenderung lebih lambat dan lebih kompleks untuk ditulis dan dijalankan.
- **Terminologi:**
  - **Test Harness:** Sekumpulan perangkat lunak dan data uji yang dikonfigurasi untuk menguji suatu program dalam berbagai kondisi, termasuk memantau output dan membandingkannya dengan hasil yang diharapkan.
  - **Headless Mode:** Menjalankan aplikasi tanpa antarmuka pengguna grafis atau tekstual. Neovim dapat dijalankan dalam mode headless (`nvim --headless`), yang sangat berguna untuk pengujian otomatis karena Anda dapat mengontrolnya melalui skrip atau RPC.
- **Alat dan Teknik:**
  - **Neovim Headless (`nvim --headless`):**
    - Memungkinkan Anda menjalankan instance Neovim yang dikontrol sepenuhnya oleh skrip.
    - Anda dapat menggunakan argumen `-S <skripfile>` untuk menjalankan skrip Lua saat startup, atau `-c <perintah_ex>` untuk menjalankan perintah Ex.
    - Skrip tes dapat memanipulasi state editor (buffer, jendela, opsi), memanggil fungsi plugin, dan kemudian membuat asersi tentang state editor atau output.
  - **Test Harness (misalnya, dari `plenary.nvim`):** Pustaka seperti `plenary.nvim` sering menyediakan utilitas tingkat lebih tinggi untuk pengujian integrasi. Ini mungkin termasuk:
    - Fungsi untuk men-spawn instance Neovim headless dengan konfigurasi tertentu.
    - Cara untuk mengirim perintah atau kode Lua ke instance tersebut.
    - API untuk mengambil state dari instance Neovim (misalnya, isi buffer, opsi).
    - Integrasi dengan framework asersi.
      Dokumen menyebutkan "nvim- વધારાની", yang saya interpretasikan sebagai kesalahan ketik dan kemungkinan merujuk pada kapabilitas yang disediakan oleh `plenary.nvim` atau kerangka kerja serupa.
- **Implementasi dalam Neovim:** Sangat penting untuk menguji fungsionalitas yang sangat bergantung pada API Neovim, seperti:
  - Manipulasi buffer dan jendela.
  - Respon terhadap autocommands.
  - Perilaku keymap.
  - Interaksi dengan fitur Neovim lain seperti LSP atau Treesitter.
- **Sumber Dokumentasi Neovim:**
  - `:h --headless` (Opsi baris perintah Neovim).
  - `:h rpc` (Jika menggunakan RPC untuk mengontrol instance headless).
  - Dokumentasi untuk pustaka test harness seperti `plenary.nvim`.

**Contoh Kode (Konseptual dengan Neovim Headless):**
Ini adalah contoh skrip Lua yang bisa dijalankan dengan `nvim --headless -S nama_skrip_ini.lua`. Skrip ini akan berjalan di dalam instance Neovim yang baru.

```lua
-- file: integration_test_example.lua
-- Jalankan dengan: nvim --headless -u NONE -i NONE --noplugin -S integration_test_example.lua
-- -u NONE: jangan muat vimrc pengguna
-- -i NONE: jangan muat shada file
-- --noplugin: jangan muat plugin global

print("--- Integration Test Dimulai (Headless Neovim) ---")

-- Inisialisasi: Pastikan state bersih jika perlu
vim.api.nvim_command("enew!") -- Buat buffer baru yang kosong dan buang yang lama

-- Misalkan kita ingin menguji fungsi plugin yang memodifikasi buffer.
-- Kita perlu memuat kode plugin kita. Dalam skenario nyata, ini mungkin dilakukan
-- dengan mengatur runtimepath atau require langsung jika struktur memungkinkan.
-- Untuk demo, kita definisikan fungsi "plugin" sederhana di sini.
local MyPlugin = {}
function MyPlugin.add_prefix_to_current_line(prefix)
    local current_buf = vim.api.nvim_get_current_buf()
    local current_line_num = vim.api.nvim_win_get_cursor(0)[1] -- Baris (1-indeks)
    local line_content = vim.api.nvim_buf_get_lines(current_buf, current_line_num - 1, current_line_num, true)[1] -- Ambil baris (0-indeks)

    if line_content then
        local new_line_content = prefix .. line_content
        vim.api.nvim_buf_set_lines(current_buf, current_line_num - 1, current_line_num, true, {new_line_content})
        return true
    end
    return false
end

-- Test Case 1: Menguji MyPlugin.add_prefix_to_current_line
print("Menjalankan Test Case 1: add_prefix_to_current_line")
vim.api.nvim_buf_set_lines(0, 0, -1, true, {"baris awal"}) -- Siapkan buffer (Arrange)
vim.api.nvim_win_set_cursor(0, {1, 0}) -- Pindahkan kursor ke baris 1, kolom 0

MyPlugin.add_prefix_to_current_line("PREFIX: ") -- Jalankan fungsi (Act)

local modified_line = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
local expected_line = "PREFIX: baris awal"

-- Asersi sederhana menggunakan assert Lua standar
assert(modified_line == expected_line,
       string.format("Test Case 1 GAGAL: Diharapkan '%s', Dapat '%s'", expected_line, modified_line))
print("Test Case 1 LULUS.")

-- Test Case 2: Menguji perilaku lain
-- ... (tambahkan test case lain di sini) ...

print("--- Semua Integration Test Selesai ---")

-- Keluar dari Neovim headless setelah tes selesai
-- :cq akan keluar dengan error code jika ada error, berguna untuk CI.
-- :qall! akan keluar tanpa menyimpan.
vim.api.nvim_command("qall!")
```

**Cara Menjalankan Kode (Integration Test):**

1.  Simpan kode di atas sebagai `integration_test_example.lua`.
2.  Jalankan dari terminal Anda (bukan dari dalam instance Neovim yang sudah berjalan):
    ```bash
    nvim --headless -u NONE -i NONE --noplugin -S integration_test_example.lua
    ```
    - `-u NONE`: Tidak memuat file init pengguna (vimrc).
    - `-i NONE`: Tidak memuat file ShaDa (shared data).
    - `--noplugin`: Tidak memuat plugin global (kecuali yang ada di runtimepath standar).
    - `-S integration_test_example.lua`: Menjalankan skrip Lua ini setelah startup.
3.  Skrip akan mencetak outputnya ke terminal. Jika ada asersi yang gagal, skrip akan berhenti dengan error. Perintah `qall!` di akhir akan menutup instance Neovim headless.

**Penjelasan Kode Keseluruhan (`integration_test_example.lua`):**

- Skrip ini dirancang untuk dijalankan dalam mode headless.
- `vim.api.nvim_command("enew!")`: Memastikan kita mulai dengan buffer bersih.
- `MyPlugin.add_prefix_to_current_line`: Fungsi "plugin" contoh yang akan kita uji. Fungsi ini menggunakan API Neovim untuk memodifikasi baris saat ini.
- **Test Case 1:**
  - **Arrange:** Buffer disiapkan dengan teks "baris awal" dan kursor diposisikan.
  - **Act:** Fungsi `MyPlugin.add_prefix_to_current_line` dipanggil.
  - **Assert:** Isi baris setelah modifikasi diambil menggunakan `vim.api.nvim_buf_get_lines` dan dibandingkan dengan string yang diharapkan menggunakan `assert` standar Lua. Jika tidak sama, tes gagal dan skrip berhenti.
- `vim.api.nvim_command("qall!")`: Menutup instance Neovim headless setelah semua tes selesai. Dalam lingkungan Continuous Integration (CI), Anda mungkin menggunakan `:cq` untuk keluar dengan kode error jika ada tes yang gagal.

---

### 18.4 Debugging Tests (Debugging Tes)

- **Deskripsi Konsep:** Kadang-kadang tes Anda akan gagal, dan tidak selalu jelas mengapa. Kemampuan untuk men-debug tes sama pentingnya dengan men-debug kode plugin itu sendiri.
- **Teknik Umum:**
  1.  **Pesan Error yang Informatif:** Pastikan pesan dalam asersi Anda (`assert.Equals(actual, expected, "pesan ini")`) jelas dan memberikan konteks yang cukup.
  2.  **`print()` Debugging:** Tambahkan pernyataan `print()` (atau `vim.notify` jika menjalankan di instance Neovim interaktif) di dalam kode tes Anda atau kode yang diuji untuk mencetak nilai variabel pada berbagai tahap. Untuk tes headless, `print` akan muncul di terminal.
  3.  **Jalankan Tes Individual:** Sebagian besar test runner memungkinkan Anda menjalankan satu file tes atau bahkan satu `describe` atau `it` blok secara terpisah. Ini membantu mengisolasi masalah.
  4.  **Sederhanakan Test Case:** Jika tes yang kompleks gagal, coba buat versi yang lebih sederhana dari tes tersebut yang masih mereproduksi kegagalan. Ini dapat membantu menemukan akar masalah.
  5.  **Gunakan Debugger (jika tersedia):** Beberapa framework pengujian Lua mungkin memiliki dukungan untuk debugger Lua (seperti `mobdebug` jika test runner mendukungnya). Untuk tes integrasi di Neovim, Anda bisa mencoba menjalankan Neovim dengan opsi debugger dan melampirkan debugger eksternal jika Anda tahu cara kerjanya.
  6.  **Periksa Lingkungan Tes:** Pastikan lingkungan tempat tes dijalankan (misalnya, versi Lua, Neovim, dependensi yang dimuat) sesuai dengan yang diharapkan.
- **Implementasi dalam Neovim:** Saat men-debug tes integrasi yang berjalan headless, `print` adalah teman terbaik Anda. Anda juga bisa membuat tes menulis ke file log untuk analisis lebih lanjut.

---

Pengujian adalah investasi yang akan terbayar dalam jangka panjang dengan menghasilkan plugin yang lebih stabil, andal, dan mudah dikembangkan. Membiasakan diri dengan unit testing untuk logika murni dan integration testing untuk interaksi dengan Neovim akan sangat meningkatkan kualitas plugin Anda.

> Pada bagian berikutnya, kita akan membahas tentang bagaimana menstrukturkan plugin Anda dengan baik.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**

[4]: ../19-struktur/README.md
[3]: ../../module/17-lsp/README.md
[2]: ../../../../../README.md
[0896]: ../../README.md/#18-configuration-dan-persistence
