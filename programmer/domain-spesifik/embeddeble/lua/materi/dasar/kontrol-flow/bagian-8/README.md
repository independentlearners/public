### Daftar Isi Pembelajaran

Berikut adalah peta jalan untuk materi yang akan kita bahas. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-6**: Membahas dasar-dasar kontrol alur, perulangan, pola canggih, penanganan error, dan coroutine.
  - **Bagian 7**: Fokus pada optimasi performa melalui analisis CPU dan manajemen memori.

- **Materi Saat Ini: Pola Desain, Aplikasi, dan Framework**

  - [**Bagian 8: Design Patterns dan Best Practices**](https://www.google.com/search?q=%23-bagian-8-design-patterns-dan-best-practices)
    - [8.1 Pola Desain Kontrol Alur](https://www.google.com/search?q=%2381-pola-desain-kontrol-alur)
    - [8.2 Kualitas dan Keterpeliharaan Kode](https://www.google.com/search?q=%2382-kualitas-dan-keterpeliharaan-kode)
  - [**Bagian 9: Domain-Specific Applications**](https://www.google.com/search?q=%23-bagian-9-domain-specific-applications)
    - [9.1 Kontrol Alur Pengembangan Game](https://www.google.com/search?q=%2391-kontrol-alur-pengembangan-game)
    - [9.2 Kontrol Alur Sistem Tertanam (Embedded)\*\*](https://www.google.com/search?q=%2392-kontrol-alur-sistem-tertanam-embedded)
  - [**Bagian 10: Pola Kontrol Alur di Framework Populer (Tambahan)**](https://www.google.com/search?q=%23-bagian-10-pola-kontrol-alur-di-framework-populer-tambahan)
    - [10.1 Event Loop di LÖVE 2D](https://www.google.com/search?q=%23101-event-loop-di-lve-2d)
    - [10.2 Kontrol Alur Non-Blocking di OpenResty](https://www.google.com/search?q=%23102-kontrol-alur-non-blocking-di-openresty)

---

## 📚 **Bagian 8: Design Patterns dan Best Practices**

Setelah memahami "bagaimana" cara kerja kontrol alur, bagian ini fokus pada "kapan" dan "mengapa" Anda harus menggunakan pola tertentu. Menerapkan pola desain yang tepat dan praktik terbaik akan membuat kode Anda tidak hanya berfungsi, tetapi juga elegan, dapat dipelihara (_maintainable_), dan dapat diskalakan (_scalable_).

### 8.1 Pola Desain Kontrol Alur

**Durasi yang Disarankan:** 4-5 jam

Pola desain adalah solusi umum yang dapat digunakan kembali untuk masalah yang sering terjadi dalam desain perangkat lunak.

#### **Deskripsi Konkret**

Bagian ini secara formal membahas beberapa pola desain yang telah kita singgung sebelumnya, memberikan nama dan struktur pada solusi-solusi tersebut untuk mempermudah komunikasi dan implementasi.

#### **Topik yang Dipelajari**

- **State Pattern Implementation**:

  - **Deskripsi**: Pola ini memungkinkan sebuah objek untuk mengubah perilakunya ketika keadaan internalnya berubah. Objek tampak seolah-olah mengubah kelasnya. Ini adalah formalisasi dari konsep _state machine_ yang telah kita bahas menggunakan tabel atau metatabel. Setiap _state_ dienkapsulasi dalam objeknya sendiri yang memiliki antarmuka (interface) yang sama.
  - **Contoh Konseptual**:

    ```lua
    -- State Interface
    local State = {}
    function State:new(context)
        return setmetatable({ context = context }, { __index = self })
    end
    function State:handle() error("harus diimplementasikan oleh state konkret") end

    -- Concrete States
    local StateA = State:new()
    function StateA:handle()
        print("Menangani di State A. Transisi ke State B.")
        self.context.state = StateB:new(self.context)
    end

    local StateB = State:new()
    function StateB:handle()
        print("Menangani di State B. Transisi ke State A.")
        self.context.state = StateA:new(self.context)
    end

    -- Context (Objek yang memiliki state)
    local Context = {}
    function Context:new()
        local instance = { state = nil }
        instance.state = StateA:new(instance) -- State awal
        return setmetatable(instance, { __index = self })
    end
    function Context:request()
        self.state:handle()
    end

    local context = Context:new()
    context:request() -- Output: Menangani di State A. Transisi ke State B.
    context:request() -- Output: Menangani di State B. Transisi ke State A.
    ```

- **Command Pattern untuk control flow**:

  - **Deskripsi**: Membungkus sebuah permintaan sebagai objek, sehingga memungkinkan Anda untuk memparameterisasi klien dengan permintaan yang berbeda, mengantrekan permintaan, dan mendukung operasi yang dapat dibatalkan. Kita sudah melihat implementasi sederhananya menggunakan tabel fungsi.
  - **Kapan Digunakan**: Berguna untuk sistem _undo/redo_, antrean tugas, atau memisahkan pemanggil perintah dari eksekutornya.

- **Strategy Pattern dengan function dispatch**:

  - **Deskripsi**: Pola ini memungkinkan pemilihan algoritma saat runtime. Anda mendefinisikan keluarga algoritma, membungkus masing-masing, dan membuatnya dapat dipertukarkan. Tabel dispatch fungsi adalah implementasi langsung dari pola ini.
  - **Perbedaan dengan State Pattern**: Fokus _Strategy_ adalah pada algoritma yang dapat dipertukarkan untuk satu tugas tertentu (misalnya, berbagai cara mengurutkan), sedangkan _State_ berfokus pada perubahan perilaku objek secara keseluruhan berdasarkan keadaannya.

- **Observer Pattern untuk event handling**:

  - **Deskripsi**: Mendefinisikan ketergantungan satu-ke-banyak antara objek sehingga ketika satu objek (subjek) mengubah keadaannya, semua dependennya (pengamat/observer) diberitahu dan diperbarui secara otomatis. Ini adalah dasar dari pemrograman berbasis kejadian (_event-driven_).
  - **Contoh Konseptual**:

    ```lua
    -- Subject (yang diamati)
    local Subject = {}
    function Subject:new()
        return { observers = {} }
    end
    function Subject:addObserver(observer)
        self.observers[observer] = observer
    end
    function Subject:notify(event)
        print("Subject: Memberi tahu observer tentang event '" .. event .. "'")
        for obs in pairs(self.observers) do
            obs:onNotify(event)
        end
    end

    -- Observer (yang mengamati)
    local Observer = {}
    function Observer:new(name)
        return { name = name }
    end
    function Observer:onNotify(event)
        print("Observer '" .. self.name .. "': Menerima notifikasi event '" .. event .. "'")
    end

    local subject = Subject:new()
    local observer1 = Observer:new("A")
    local observer2 = Observer:new("B")

    subject:addObserver(observer1)
    subject:addObserver(observer2)

    subject:notify("login")
    ```

#### **Sumber Belajar (dari README.md)**:

- [Lua Design Patterns](http://lua-users.org/wiki/LuaPatterns)
- [Object-Oriented Programming in Lua](http://lua-users.org/wiki/ObjectOrientedProgramming)

---

### 8.2 Kualitas dan Keterpeliharaan Kode

**Durasi yang Disarankan:** 3-4 jam

Menulis kode yang cerdas itu bagus, tetapi menulis kode yang jelas dan mudah dipahami oleh orang lain (dan diri Anda sendiri di masa depan) jauh lebih baik.

#### **Deskripsi Konkret**

Bagian ini membahas prinsip-prinsip untuk menulis kode yang bersih, mudah dibaca, dan mudah dimodifikasi, dengan fokus pada struktur kontrol alur.

#### **Topik yang Dipelajari**

- **Readable control flow structures (Struktur kontrol alur yang mudah dibaca)**:

  - Gunakan nama variabel yang deskriptif untuk kondisi.
  - Pilih struktur yang paling jelas untuk tugas tersebut (`if/else` vs tabel vs `while`).
  - Berikan komentar pada logika yang kompleks.

- **Avoiding deeply nested conditions (Menghindari kondisi bersarang yang dalam)**:

  - Seperti yang dibahas sebelumnya, kondisi bersarang yang dalam (`if...if...if...`) sulit diikuti.
  - Gunakan _guard clauses_ (keluar lebih awal dengan `return` atau `break`) untuk mengurangi level sarang.
  - Pecah menjadi fungsi-fungsi yang lebih kecil.
  - Gunakan tabel dispatch atau pola State jika sesuai.

- **Refactoring complex control logic (Refactoring logika kontrol yang kompleks)**:

  - **Refactoring** adalah proses menstrukturkan ulang kode yang ada—tanpa mengubah perilaku eksternal—untuk meningkatkan desain, keterbacaan, dan keterpeliharaannya.
  - Identifikasi bagian kode yang rumit dan terapkan teknik di atas untuk menyederhanakannya.

- **Documentation best practices (Praktik terbaik dokumentasi)**:

  - Dokumentasikan _mengapa_ kode melakukan sesuatu, bukan hanya _apa_ yang dilakukannya. Komentar `i = i + 1` tidak berguna, tetapi komentar `-- Gunakan goto untuk keluar dari loop bersarang karena flag akan mempersulit logika` sangat membantu.
  - Gunakan alat dokumentasi seperti [LDoc](https://github.com/lunarmodules/ldoc) untuk menghasilkan dokumentasi dari komentar kode Anda.

#### **Sumber Belajar (dari README.md)**:

- [Lua Style Guide](http://lua-users.org/wiki/LuaStyleGuide)
- [Clean Code Principles](https://github.com/ryanmcdermott/clean-code-javascript) (Meskipun untuk JavaScript, prinsip-prinsipnya bersifat universal)

---