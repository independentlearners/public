# Pengembangan Kurikulum Rust: Dari Pemula hingga Ahli

Berikut adalah pendalaman dan pengembangan setiap fase, modul, dan sub-bagian dari kurikulum Rust yang telah di audit, disajikan dengan detail komprehensif untuk memfasilitasi pemahaman dari pemula hingga tingkat ahli.

---

## Fase 1: Foundation (Pemula)

Fase ini berfungsi sebagai fondasi utama, memperkenalkan Anda pada dasar-dasar Rust, sintaksis inti, dan filosofi unik yang menjadi ciri khasnya. Tujuannya adalah membangun pemahaman yang kuat tentang konsep-konsep fundamental yang membedakan Rust dari bahasa pemrograman lain, memastikan Anda memiliki pijakan yang kokoh sebelum melangkah ke topik yang lebih kompleks.

### Modul 1.1: Memulai dengan Rust

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini adalah titik awal esensial dalam perjalanan Anda mempelajari Rust. Anda akan dipandu melalui proses instalasi Rust, penyiapan lingkungan pengembangan yang optimal, dan penulisan program Rust pertama Anda, yaitu "Hello, world\!". Modul ini juga memperkenalkan Cargo, alat bawaan Rust yang sangat penting untuk mengelola dependensi, kompilasi, pengujian, dan _benchmarking_ proyek Rust.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Filosofi Rust:** Modul ini akan menjelaskan mengapa Rust diciptakan – fokusnya pada performa, keamanan tipe, dan konkurensi. Anda akan memahami nilai-nilai inti seperti tidak adanya _garbage collector_, pencegahan _null pointer dereference_ (melalui `Option`), dan pencegahan _data races_ (melalui _ownership_ dan _borrowing_). Filosofi ini mendasari keputusan desain bahasa yang bertujuan untuk menghasilkan perangkat lunak yang andal dan efisien.
  - **Alat Utama:** Pengenalan `rustup` sebagai manajer _toolchain_, `rustc` sebagai kompiler Rust, dan `cargo` sebagai manajer paket dan sistem _build_ resmi. Memahami peran masing-masing alat ini sangat penting untuk alur kerja pengembangan Rust.
  - **Kompilasi:** Membahas proses bagaimana kode sumber Rust (`.rs`) diubah menjadi _executable binary_ yang dapat dijalankan secara langsung oleh sistem operasi.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  // main.rs
  fn main() {
      println!("Hello, world!");
  }
  ```

  Contoh di atas menunjukkan fungsi `main`, titik masuk setiap program Rust. Makro `println!` digunakan untuk mencetak teks ke konsol.

  ```bash
  # Kompilasi dan jalankan secara manual
  rustc main.rs
  ./main

  # Buat proyek baru dengan Cargo
  cargo new hello_cargo
  cd hello_cargo
  cargo run
  ```

  Contoh perintah konsol ini menunjukkan cara mengompilasi dan menjalankan program Rust secara manual menggunakan `rustc`, serta bagaimana membuat dan menjalankan proyek baru menggunakan `cargo`, yang merupakan cara yang direkomendasikan.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Toolchain:** Kumpulan alat pengembangan yang komprehensif yang diperlukan untuk bekerja dengan suatu bahasa, termasuk kompiler, _debugger_, dan utilitas lain.
  - **`rustup`:** Sebuah _command-line tool_ yang berfungsi sebagai manajer versi Rust, memungkinkan Anda menginstal berbagai versi kompiler Rust dan komponen terkait, serta beralih di antaranya.
  - **`rustc`:** Kompiler Rust itu sendiri. Ini adalah program yang menerjemahkan kode sumber Rust Anda menjadi kode mesin yang dapat dieksekusi.
  - **`cargo`:** Manajer paket dan sistem _build_ resmi Rust. Ini menangani banyak tugas seperti mengelola dependensi proyek, mengompilasi kode, menjalankan _test_, dan membuat _package_ untuk distribusi.
  - **Crate:** Unit kompilasi dasar di Rust. Sebuah _crate_ dapat berupa _binary_ (program yang dapat dieksekusi) atau _library_ (kumpulan kode yang dapat digunakan kembali oleh proyek lain).
  - **Package:** Kumpulan satu atau lebih _crates_ yang menyediakan serangkaian fungsionalitas. Sebuah _package_ selalu berisi file `Cargo.toml`.
  - **`Cargo.toml`:** File konfigurasi yang mendefinisikan sebuah _package_ Rust. Ini berisi metadata proyek seperti nama, versi, informasi penulis, dan daftar dependensi eksternal.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Instalasi Rust dengan `rustup`
  - Menulis Program "Hello, World\!" Pertama
  - Memahami Proses Kompilasi (`rustc`)
  - Pengantar Cargo: Manajer Paket Rust
  - Membuat Proyek Baru dengan Cargo
  - Menjalankan Proyek dengan Cargo
  - Struktur Dasar Proyek Rust

- **Rekomendasi Visualisasi:**
  Visualisasi alur kerja dari penulisan kode (`.rs`) melalui kompilasi (`rustc`) hingga eksekusi _binary_ akan sangat membantu. Diagram yang menunjukkan hubungan antara _package_, _crate_, dan file `Cargo.toml` juga akan memperjelas struktur proyek.

- **Hubungan dengan Modul Lain:**
  Modul ini adalah prasyarat mutlak untuk semua modul berikutnya. Pemahaman tentang instalasi, kompiler, dan Cargo sangat fundamental karena akan digunakan di setiap langkah pengembangan Rust Anda.

- **Sumber Referensi Lengkap:**

  - **Instalasi Rust:** [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)
  - **The Rust Programming Language - Getting Started:** [https://doc.rust-lang.org/book/ch01-01-getting-started.html](https://www.google.com/search?q=https://doc.rust-lang.org/book/ch01-01-getting-started.html)
  - **The Cargo Book:** [https://doc.rust-lang.org/cargo/](https://doc.rust-lang.org/cargo/)

- **Tips dan Praktik Terbaik:**

  - Selalu gunakan Cargo untuk proyek baru dan pengelolaan dependensi. Ini akan menyederhanakan proses _build_ dan manajemen proyek Anda.
  - Biasakan diri dengan _command line_ dasar; ini adalah antarmuka utama untuk berinteraksi dengan Cargo dan kompiler.
  - Pastikan ekstensi `rust-analyzer` terinstal dan berfungsi dengan baik di IDE Anda (misalnya, VS Code) untuk pengalaman pengembangan yang optimal dengan _auto-completion_ dan _linting_.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Lupa menambahkan direktori Cargo `bin` ke PATH sistem, sehingga perintah `cargo` tidak ditemukan.
    **Solusi:** Ikuti instruksi instalasi `rustup` dengan cermat, yang biasanya akan meminta Anda untuk menambahkan ini secara otomatis. Jika tidak, tambahkan secara manual.
  - **Kesalahan:** Mengompilasi dengan `rustc` secara manual alih-alih menggunakan `cargo run`.
    **Solusi:** Untuk proyek yang lebih dari satu file sederhana, selalu gunakan `cargo run` atau `cargo build`.

### Modul 1.2: Konsep Dasar Pemrograman Rust

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan membekali Anda dengan elemen dasar sintaksis Rust yang krusial untuk menulis program fungsional. Anda akan belajar tentang variabel, berbagai tipe data, cara mendefinisikan dan memanggil fungsi, struktur kontrol alir (`if/else`, `loop`, `while`, `for`), dan cara membuat struktur data kustom (`struct`). Pemahaman ini membentuk kerangka dasar untuk ekspresi logis dalam Rust.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Keamanan Tipe (Type Safety):** Rust sangat ketat dalam _type safety_, yang berarti kompiler akan memastikan bahwa operasi hanya dilakukan pada tipe data yang kompatibel. Ini mencegah banyak _bug_ umum yang terkait dengan tipe data yang salah.
  - **Immutability by Default:** Variabel di Rust secara _default_ tidak dapat diubah setelah dideklarasikan. Filosofi ini mendorong kode yang lebih aman, lebih mudah diprediksi, dan lebih mudah dianalisis, mengurangi efek samping yang tidak diinginkan. Mutabilitas harus dinyatakan secara eksplisit dengan kata kunci `mut`.
  - **Inference Tipe:** Rust memiliki kemampuan untuk menyimpulkan tipe data secara otomatis dalam banyak kasus. Ini mengurangi kebutuhan untuk anotasi tipe yang berlebihan (`boilerplate`), membuat kode lebih ringkas tanpa mengorbankan keamanan tipe.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  fn main() {
      // Variabel dan Mutability
      let x = 5; // Immutable
      let mut y = 10; // Mutable
      y = 15;

      // Tipe Data Skalar
      let integer: i32 = 42; // Integer signed 32-bit
      let float: f64 = 3.14; // Floating-point 64-bit
      let boolean: bool = true;
      let character: char = 'Z';

      // Tipe Data Komposit
      let tuple: (i32, f64, char) = (500, 6.4, '1');
      let array: [i32; 5] = [1, 2, 3, 4, 5];

      // Fungsi
      fn add(a: i32, b: i32) -> i32 {
          a + b // Expression, tidak ada semicolon
      }
      let sum = add(10, 20);

      // Kontrol Alir: if/else
      if sum > 0 {
          println!("Sum is positive");
      } else {
          println!("Sum is not positive");
      }

      // Kontrol Alir: loop, while, for
      let mut counter = 0;
      loop {
          counter += 1;
          if counter == 3 {
              break;
          }
      }

      let a = [10, 20, 30, 40, 50];
      for element in a.iter() {
          println!("The value is: {}", element);
      }

      // Struct
      struct User {
          username: String,
          email: String,
          active: bool,
      }

      let user1 = User {
          email: String::from("someone@example.com"),
          username: String::from("someusername123"),
          active: true,
      };
  }
  ```

  Contoh ini mencakup deklarasi variabel `let` dan `let mut`, berbagai tipe data skalar dan komposit, definisi dan pemanggilan fungsi dengan nilai kembalian eksplisit, penggunaan `if/else`, serta ketiga jenis perulangan (`loop`, `while`, `for`), dan definisi `struct` dasar. Ini adalah blok bangunan inti dari setiap program Rust.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Variabel:** Sebuah nama yang digunakan untuk menampung nilai dalam memori.
  - **Mutabilitas (`mut`):** Sifat sebuah variabel yang menunjukkan apakah nilainya dapat diubah setelah dideklarasikan. Secara _default_, variabel di Rust _immutable_ (tidak dapat diubah).
  - **Tipe Data Skalar:** Merepresentasikan satu nilai tunggal, seperti integer (bilangan bulat), _floating-point_ (bilangan desimal), _boolean_ (true/false), dan _character_ (karakter tunggal).
  - **Tipe Data Komposit:** Menggabungkan beberapa nilai menjadi satu. Contohnya adalah _tuple_ (kumpulan nilai dengan tipe yang mungkin berbeda) dan _array_ (kumpulan nilai dengan tipe yang sama dan ukuran tetap).
  - **Fungsi:** Blok kode yang terorganisir dan dapat digunakan kembali untuk melakukan tugas tertentu. Fungsi menerima input (argumen) dan dapat menghasilkan output (nilai kembalian).
  - **`fn`:** Kata kunci yang digunakan untuk mendeklarasikan fungsi di Rust.
  - **`return`:** Kata kunci opsional untuk mengembalikan nilai dari fungsi. Jika ekspresi terakhir dalam fungsi tidak diakhiri dengan titik koma, nilainya akan otomatis dikembalikan.
  - **`if`/`else`:** Pernyataan kontrol alir kondisional yang memungkinkan eksekusi kode berdasarkan evaluasi kondisi `boolean`.
  - **`loop`:** Perulangan tak terbatas yang akan terus berjalan sampai dihentikan secara eksplisit oleh pernyataan `break`.
  - **`while`:** Perulangan yang terus mengeksekusi blok kode selama suatu kondisi `boolean` tetap benar.
  - **`for`:** Perulangan yang mengiterasi melalui elemen-elemen dalam koleksi (misalnya, _array_, _vector_) atau rentang angka.
  - **`struct`:** Singkatan dari "structure," adalah tipe data kustom yang memungkinkan Anda mengelompokkan data terkait menjadi satu unit logis, mirip dengan objek sederhana tanpa perilaku (metode).
  - **String:** Di Rust, ada dua tipe utama untuk teks: `String` (tipe yang dimiliki, dapat diubah, dan dialokasikan di _heap_) dan `&str` (_string slice_, yaitu referensi ke bagian dari _string_ yang tidak dapat diubah).

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Variabel dan Mutabilitas
  - Tipe Data: Integer, Floating-Point, Boolean, Character
  - Tipe Data Komposit: Tuple, Array
  - Fungsi: Definisi, Pemanggilan, Nilai Kembali
  - Komentar dalam Rust (cara menulis komentar satu baris dan multibaris)
  - Kontrol Alir: `if`/`else`, `match` (pengantar)
  - Perulangan: `loop`, `while`, `for`
  - Pemahaman tentang `String` dan `&str` (String Slices)
  - Struktur (Structs): Mendefinisikan dan Menggunakan Data Kustom

- **Rekomendasi Visualisasi:**
  Diagram yang membandingkan alokasi memori untuk variabel _immutable_ dan _mutable_ akan sangat membantu. Visualisasi perulangan `for` yang mengiterasi elemen _array_ juga bisa memperjelas.

- **Hubungan dengan Modul Lain:**
  Konsep-konsep dalam modul ini adalah blok bangunan dasar untuk semua kode Rust. Pemahaman yang kuat di sini sangat penting sebelum melangkah ke _ownership_ dan _borrowing_ (Modul 1.3), karena konsep-konsep tersebut dibangun di atas dasar variabel, tipe, dan fungsi.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Common Programming Concepts:** [https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html)
  - **The Rust Programming Language - Functions:** [https://doc.rust-lang.org/book/ch03-03-functions.html](https://www.google.com/search?q=https://doc.rust-lang.org/book/ch03-03-functions.html)
  - **The Rust Programming Language - Control Flow:** [https://doc.rust-lang.org/book/ch03-05-control-flow.html](https://doc.rust-lang.org/book/ch03-05-control-flow.html)
  - **The Rust Programming Language - Structs:** [https://doc.rust-lang.org/book/ch05-00-structs.html](https://doc.rust-lang.org/book/ch05-00-structs.html)

- **Tips dan Praktik Terbaik:**

  - Selalu gunakan `let` kecuali Anda yakin variabel harus _mutable_, lalu gunakan `let mut`. Ini adalah praktik terbaik di Rust untuk mendorong kode yang lebih aman.
  - Pahami perbedaan antara `String` dan `&str`. Ini akan menjadi sumber kebingungan awal bagi banyak pemula.
  - Gunakan `match` expression saat menghadapi beberapa kemungkinan kasus, ini lebih kuat dan ekspresif daripada serangkaian `if/else if`.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Mencoba memodifikasi variabel yang dideklarasikan dengan `let` tanpa `mut`.
    **Solusi:** Tambahkan kata kunci `mut` setelah `let` (misal: `let mut x = 5;`).
  - **Kesalahan:** Menggunakan `String::from("abc")` di tempat yang seharusnya `&str`.
    **Solusi:** Konversi `String` ke `&str` menggunakan `.as_str()` atau _deref coercion_ yang seringkali otomatis. Atau, gunakan _string literal_ `"abc"` jika Anda hanya membutuhkan `&str`.

### Modul 1.3: Konsep Ownership

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini adalah jantung dari Rust, memperkenalkan konsep fundamental **ownership**, **borrowing**, dan **lifetimes**. Penguasaan konsep-konsep ini sangat krusial karena mereka adalah pondasi bagaimana Rust mencapai keamanan memori tanpa memerlukan _garbage collector_. Memahami modul ini akan memungkinkan Anda menulis kode Rust yang tidak hanya benar tetapi juga efisien dan bebas dari _bug_ terkait memori.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Ownership:** Ini adalah aturan fundamental Rust untuk mengelola memori. Setiap nilai di Rust memiliki pemilik (`owner`). Pada satu waktu, hanya ada satu pemilik. Ketika pemilik keluar dari _scope_, nilai tersebut secara otomatis dibersihkan dari memori (di-_drop_). Filosofi ini secara efektif menghilangkan _memory leaks_ dan _dangling pointers_ pada waktu kompilasi.
  - **Borrowing:** Mekanisme yang memungkinkan Anda mengakses data tanpa mengambil _ownership_-nya. Ini dilakukan melalui penggunaan _referensi_ (`&`). Ada dua jenis _borrowing_:
    - **Immutable References (`&T`):** Anda dapat memiliki banyak _immutable references_ ke data yang sama secara bersamaan. Data yang direferensikan tidak dapat dimodifikasi melalui _immutable reference_.
    - **Mutable References (`&mut T`):** Anda hanya dapat memiliki satu _mutable reference_ ke data pada satu waktu. Data yang direferensikan dapat dimodifikasi melalui _mutable reference_.
  - **Rules of References:**
    1.  Pada waktu tertentu, Anda hanya dapat memiliki satu _mutable reference_ ATAU sejumlah _immutable references_ ke data tertentu.
    2.  Referensi harus selalu valid; mereka tidak boleh mengacu ke data yang sudah tidak ada (yang sudah di-_drop_).
  - **Lifetimes:** Kompiler Rust menggunakan _lifetimes_ untuk memastikan bahwa semua _borrow_ valid selama yang dibutuhkan. _Lifetimes_ adalah anotasi yang tidak memengaruhi kinerja _runtime_, tetapi membantu _borrow checker_ kompiler dalam memastikan keamanan memori, terutama saat berhadapan dengan referensi dalam _struct_ atau fungsi _generic_.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  fn main() {
      // Ownership
      let s1 = String::from("hello");
      let s2 = s1; // s1 moved to s2, s1 is no longer valid
      // println!("{}, world!", s1); // Error: value borrowed here after move

      // Cloning untuk deep copy
      let s3 = String::from("hello");
      let s4 = s3.clone(); // s3 still valid
      println!("s3 = {}, s4 = {}", s3, s4);

      // Borrowing: Immutable References
      let len = calculate_length(&s4); // &s4 is an immutable reference
      println!("The length of '{}' is {}.", s4, len);

      // Borrowing: Mutable References
      let mut s5 = String::from("hello");
      change_string(&mut s5); // &mut s5 is a mutable reference
      println!("s5 after change: {}", s5);

      // Multiple Immutable References OK
      let r1 = &s5;
      let r2 = &s5;
      println!("{} and {}", r1, r2);

      // One Mutable Reference at a time
      // let r3 = &mut s5;
      // let r4 = &mut s5; // Error: cannot borrow `s5` as mutable more than once at a time

      // Lifetimes (Implicit and Explicit)
      // Implicit lifetime (compiler infers)
      fn longest_word<'a>(x: &'a str, y: &'a str) -> &'a str {
          if x.len() > y.len() {
              x
          } else {
              y
          }
      }
      let string1 = String::from("long string is long");
      let result;
      {
          let string2 = String::from("xyz");
          result = longest_word(string1.as_str(), string2.as_str());
      }
      // println!("The longest word is {}", result); // This would cause an error without 'a due to string2 going out of scope
  }

  fn calculate_length(s: &String) -> usize { // Takes an immutable reference
      s.len()
  }

  fn change_string(some_string: &mut String) { // Takes a mutable reference
      some_string.push_str(", world!");
  }
  ```

  Contoh ini mengilustrasikan konsep _move_ (`s1` ke `s2`), penggunaan `clone()` untuk _deep copy_, bagaimana _immutable_ dan _mutable references_ bekerja, dan bagaimana _lifetimes_ (baik implisit maupun eksplisit) memastikan referensi tetap valid.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Ownership:** Aturan fundamental Rust yang mengatur bagaimana program mengelola memori. Ini memastikan keamanan memori tanpa _garbage collector_.
  - **Owner:** Variabel yang bertanggung jawab atas pelepasan memori dari suatu nilai.
  - **Move:** Proses transfer _ownership_ dari satu variabel ke variabel lain. Setelah _move_, variabel asli tidak lagi valid dan tidak dapat digunakan.
  - **Clone:** Sebuah operasi yang membuat _deep copy_ dari data yang dimiliki, menghasilkan _ownership_ baru untuk salinan data tersebut. Ini digunakan ketika Anda membutuhkan dua salinan data yang terpisah sepenuhnya.
  - **Borrowing:** Mekanisme untuk mengakses data melalui referensi tanpa mengambil _ownership_ data tersebut.
  - **Referensi (`&`):** Jenis pointer yang aman di Rust yang memungkinkan Anda merujuk ke data tanpa mengambil _ownership_.
  - **Mutable Reference (`&mut`):** Referensi yang memungkinkan Anda memodifikasi data yang ditunjuknya. Aturan Rust menjamin hanya ada satu _mutable reference_ pada satu waktu.
  - **Immutable Reference (`&`):** Referensi yang hanya memungkinkan Anda membaca data yang ditunjuknya. Anda dapat memiliki banyak _immutable references_ secara bersamaan.
  - **Dangling Pointer:** Sebuah pointer yang mengacu ke lokasi memori yang telah dibebaskan. Rust mencegah _dangling pointers_ pada waktu kompilasi.
  - **Lifetimes:** Sebuah konsep kompiler yang memastikan bahwa referensi (pinjaman) ke data tetap valid selama data tersebut hidup. Ini adalah alat untuk menghindari _dangling pointers_.
  - **Borrow Checker:** Bagian dari kompiler Rust yang menerapkan aturan _ownership_, _borrowing_, dan _lifetimes_ pada waktu kompilasi. Jika ada pelanggaran, kompiler akan menampilkan _error_.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Apa itu Ownership?
  - Aturan Ownership
  - Konsep Move vs. Copy (membedakan bagaimana tipe data berperilaku saat disalin/dipindahkan)
  - Memahami Clone
  - Apa itu Borrowing?
  - Immutable References (`&`)
  - Mutable References (`&mut`)
  - Aturan Referensi (hanya satu _mutable borrow_ atau banyak _immutable borrow_)
  - Konsep Lifetimes: Memastikan Referensi Valid
  - Lifetime Elision Rules (Aturan Penyingkatan Lifetime untuk fungsi sederhana)
  - Memecahkan Masalah Borrow Checker (strategi untuk mengatasi _error_ dari _borrow checker_)
  - Latihan Praktis Ownership, Borrowing, dan Lifetimes

- **Rekomendasi Visualisasi:**
  Visualisasi diagram _stack_ dan _heap_ akan sangat membantu untuk menjelaskan bagaimana _ownership_ bekerja dan bagaimana data dipindahkan atau di-_clone_. Diagram panah yang menunjukkan _immutable_ dan _mutable references_ serta batasan mereka akan memperjelas konsep _borrowing_.

- **Hubungan dengan Modul Lain:**
  Konsep _ownership_, _borrowing_, dan _lifetimes_ adalah inti dari keamanan dan performa Rust. Pemahaman kuat di modul ini akan menjadi prasyarat untuk semua modul lanjutan, terutama saat bekerja dengan koleksi data (Modul 2.2), konkurensi (Modul 3.1), dan _smart pointers_ (Modul 2.5).

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Understanding Ownership:** [https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
  - **The Rust Programming Language - References and Borrowing:** [https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
  - **The Rust Programming Language - Validating References with Lifetimes:** [https://doc.rust-lang.org/book/ch10-03-lifetimes.html](https://www.google.com/search?q=https://doc.rust-lang.org/book/ch10-03-lifetimes.html)

- **Tips dan Praktik Terbaik:**

  - Jangan panik saat _borrow checker_ mengeluarkan _error_. Ini adalah teman Anda yang mencegah _bug_ memori. Bacalah pesan _error_ dengan cermat.
  - Jika Anda membutuhkan dua _mutable reference_ ke data yang sama pada waktu yang sama, ini seringkali merupakan indikasi bahwa desain kode Anda perlu dipertimbangkan ulang, atau Anda mungkin memerlukan _smart pointer_ seperti `RefCell` (untuk kasus _single-threaded_) atau `Mutex` (untuk kasus _multi-threaded_).
  - Gunakan `clone()` hanya jika benar-benar diperlukan, karena dapat memengaruhi performa karena melibatkan alokasi memori baru.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** "Value borrowed here after move" atau "use of moved value."
    **Solusi:** Ini terjadi karena _ownership_ telah dipindahkan. Gunakan `clone()` jika Anda membutuhkan salinan data yang independen, atau gunakan _references_ (`&` atau `&mut`) jika Anda hanya ingin meminjam data.
  - **Kesalahan:** "Cannot borrow `x` as mutable more than once at a time" atau "cannot borrow `x` as mutable because it is also borrowed as immutable."
    **Solusi:** Ingat aturan referensi: satu _mutable reference_ ATAU banyak _immutable references_. Pastikan Anda melepaskan pinjaman sebelum mencoba meminjamnya lagi dengan cara yang tidak kompatibel. Seringkali, ini berarti mengurangi _scope_ pinjaman Anda.

---

## Fase 2: Intermediate (Menengah)

Fase ini akan membawa Anda lebih dalam ke fitur-fitur Rust yang lebih canggih, seperti penanganan _error_, koleksi data, _traits_, _generics_, dan sistem modul. Anda akan mulai menulis kode yang lebih modular, kuat, fleksibel, dan terorganisir, serta memahami bagaimana Rust menangani skenario pemrograman dunia nyata.

### Modul 2.1: Penanganan Error dan Result/Option

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini adalah panduan esensial untuk menguasai penanganan _error_ secara idiomatik di Rust, yang merupakan perbedaan signifikan dari banyak bahasa pemrograman lain. Anda akan belajar cara menggunakan tipe `Result<T, E>` untuk _recoverable errors_ (kesalahan yang dapat dipulihkan) dan `Option<T>` untuk menangani potensi tidak adanya nilai. Pendekatan eksplisit Rust terhadap _error handling_ ini sangat penting untuk membangun aplikasi yang tangguh dan dapat diandalkan.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Error Handling Filosofi Rust:** Rust tidak memiliki _exceptions_ seperti bahasa lain. Sebaliknya, ia mendorong penanganan _error_ secara eksplisit melalui nilai kembalian. Untuk kesalahan yang dapat dipulihkan (misalnya, file tidak ditemukan), fungsi mengembalikan `Result`. Untuk kesalahan yang tidak dapat dipulihkan (misalnya, indeks di luar batas yang fatal), digunakan `panic!`, yang akan menghentikan program. Filosofi ini memaksa _developer_ untuk mempertimbangkan dan menangani semua skenario kegagalan.
  - **`Option<T>`:** Ini adalah _enum_ yang digunakan untuk kasus di mana nilai mungkin ada (`Some(T)`) atau tidak ada (`None`). Penggunaan `Option` secara eksplisit mencegah _null pointer dereferences_ (kesalahan umum di bahasa lain), karena Anda harus secara eksplisit memeriksa apakah ada nilai sebelum menggunakannya.
  - **`Result<T, E>`:** Ini adalah _enum_ yang digunakan untuk operasi yang mungkin berhasil atau gagal. Jika berhasil, ia mengembalikan `Ok(T)` dengan nilai hasil. Jika gagal, ia mengembalikan `Err(E)` dengan informasi _error_. Ini memaksa _developer_ untuk menangani kedua kemungkinan hasil.
  - **Propagasi Error:** Rust menyediakan mekanisme yang elegan untuk meneruskan _error_ ke _caller_ (fungsi pemanggil) menggunakan operator `?`. Ini sangat menyederhanakan kode _error handling_ dibandingkan dengan blok `match` berulang.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  use std::fs::File;
  use std::io::{self, Read};

  fn main() {
      // Option
      let some_number = Some(5);
      let absent_number: Option<i32> = None;

      match some_number {
          Some(x) => println!("Got: {}", x),
          None => println!("Nothing here"),
      }

      // Result
      let f = File::open("hello.txt");

      let f = match f {
          Ok(file) => file,
          Err(error) => match error.kind() {
              io::ErrorKind::NotFound => match File::create("hello.txt") {
                  Ok(fc) => fc,
                  Err(e) => panic!("Problem creating the file: {:?}", e),
              },
              other_error => panic!("Problem opening the file: {:?}", other_error),
          },
      };

      // Propagasi Error dengan '?'
      let content = read_username_from_file().expect("Failed to read username");
      println!("Username: {}", content);
  }

  fn read_username_from_file() -> Result<String, io::Error> {
      let mut f = File::open("username.txt")?; // '?' operator
      let mut s = String::new();
      f.read_to_string(&mut s)?; // '?' operator
      Ok(s)
  }
  ```

  Contoh ini menunjukkan penggunaan `match` dengan `Option` dan `Result` untuk menangani kehadiran nilai dan potensi kegagalan operasi file. Fungsi `read_username_from_file` mengilustrasikan keefisienan operator `?` untuk propagasi _error_.

- **Terminologi Esensial & Penjelasan Detil:**

  - **`panic!`:** Sebuah makro yang menyebabkan program berhenti eksekusi secara mendadak dan mencetak pesan _error_. Ini digunakan untuk _unrecoverable errors_ atau _bug_ yang tidak diharapkan.
  - **`Option<T>`:** Sebuah _enum_ di pustaka standar Rust yang merepresentasikan nilai yang mungkin ada (`Some(T)`) atau tidak ada (`None`).
  - **`Result<T, E>`:** Sebuah _enum_ di pustaka standar Rust yang merepresentasikan operasi yang mungkin berhasil (`Ok(T)`) atau gagal (`Err(E)`). `T` adalah tipe nilai sukses, dan `E` adalah tipe _error_.
  - **`match` expression:** Konstruksi kontrol alir yang sangat kuat di Rust yang memungkinkan Anda mencocokkan nilai dengan berbagai pola dan mengeksekusi kode yang sesuai untuk setiap pola. Ini sangat umum digunakan dengan `Option` dan `Result`.
  - **`unwrap()`:** Sebuah metode pada `Option` atau `Result` yang akan mengembalikan nilai di dalamnya jika ada (`Some` atau `Ok`). Jika tidak ada (`None` atau `Err`), ia akan menyebabkan `panic!`. Penggunaannya harus hati-hati dan hanya ketika Anda yakin nilai akan selalu ada.
  - **`expect()`:** Mirip dengan `unwrap()`, tetapi memungkinkan Anda menentukan pesan `panic!` kustom yang lebih deskriptif ketika terjadi kegagalan. Lebih baik daripada `unwrap()` karena memberikan konteks _error_ yang lebih baik.
  - **`?` operator:** Operator singkat untuk propagasi _error_. Jika ekspresi yang mengembalikan `Result` adalah `Err`, operator `?` akan segera mengembalikan `Err` dari fungsi saat ini. Jika `Ok`, ia akan mengekstrak nilai `Ok` dan melanjutkan eksekusi.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Pendekatan Rust terhadap Penanganan Error: Panic vs Result
  - Memahami `panic!` dan Kapan Menggunakannya
  - `Option<T>`: Menangani Absennya Nilai
  - Metode pada `Option`: `is_some`, `is_none`, `unwrap`, `expect`, `map`, `and_then`
  - `Result<T, E>`: Menangani Operasi yang Mungkin Gagal
  - Metode pada `Result`: `is_ok`, `is_err`, `unwrap`, `expect`, `map`, `and_then`
  - Mengekstrak Nilai dengan `match`
  - Menggunakan Operator `?` untuk Propagasi Error
  - `Box<dyn Error>` dan Penanganan Error Dinamis (bekerja dengan _error_ yang berbeda-beda)
  - Membuat Tipe Error Kustom (membangun _error_ Anda sendiri dengan _traits_ seperti `std::error::Error`)

- **Rekomendasi Visualisasi:**
  Diagram alir yang menunjukkan bagaimana `Option` dan `Result` mengalir melalui fungsi, dengan cabang untuk `Some/None` atau `Ok/Err`, akan sangat membantu. Visualisasi bagaimana operator `?` secara singkat menghentikan eksekusi dan mengembalikan _error_ juga bisa memperjelas.

- **Hubungan dengan Modul Lain:**
  Penanganan _error_ adalah aspek integral dari setiap aplikasi yang tangguh. Konsep `Option` dan `Result` akan muncul di seluruh kode Rust, termasuk saat bekerja dengan koleksi (Modul 2.2), I/O, dan konkurensi (Modul 3.1).

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Recoverable Errors with Result:** [https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html](https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html)
  - **The Rust Programming Language - Unrecoverable Errors with panic\!:** [https://doc.rust-lang.org/book/ch09-01-unrecoverable-errors-with-panic.html](https://doc.rust-lang.org/book/ch09-01-unrecoverable-errors-with-panic.html)
  - **The Rust Programming Language - Option Enum:** [https://doc.rust-lang.org/std/option/enum.Option.html](https://doc.rust-lang.org/std/option/enum.Option.html)
  - **The Rust Programming Language - Result Enum:** [https://doc.rust-lang.org/std/result/enum.Result.html](https://doc.rust-lang.org/std/result/enum.Result.html)

- **Tips dan Praktik Terbaik:**

  - Hindari penggunaan `unwrap()` dan `expect()` di kode produksi kecuali Anda benar-benar yakin bahwa kondisi `None` atau `Err` tidak akan pernah tercapai, atau jika _panic_ adalah perilaku yang diinginkan untuk _bug_ internal.
  - Gunakan operator `?` secara ekstensif untuk menyederhanakan kode _error handling_ Anda.
  - Pikirkan tentang skenario _error_ di awal desain fungsi Anda.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Mengabaikan `Result` atau `Option` yang tidak ditangani, menyebabkan _warning_ kompiler atau potensi _runtime panic_.
    **Solusi:** Selalu tangani kedua varian (`Ok`/`Err` atau `Some`/`None`) menggunakan `match`, `if let`, `while let`, atau metode seperti `map`, `and_then`, `unwrap_or_default`, dll.
  - **Kesalahan:** Mencoba menggunakan operator `?` dalam fungsi yang tidak mengembalikan `Result` atau `Option`.
    **Solusi:** Pastikan fungsi Anda memiliki tipe kembalian yang sesuai (misalnya, `Result<T, E>` atau `Option<T>`).

### Modul 2.2: Koleksi Data

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan mengenalkan Anda pada struktur data koleksi standar yang disediakan oleh Rust: _vectors_, _strings_, dan _hash maps_. Anda akan belajar kapan dan bagaimana menggunakan masing-masing koleksi ini secara efektif untuk menyimpan, mengatur, dan mengelola data dalam berbagai skenario aplikasi. Penguasaan koleksi ini sangat penting untuk membangun aplikasi yang menyimpan dan memanipulasi banyak data.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Koleksi Dinamis:** Koleksi-koleksi ini adalah struktur data yang dapat tumbuh atau menyusut ukurannya saat program berjalan (_runtime_), tidak seperti _array_ Rust yang ukurannya tetap. Fleksibilitas ini memungkinkan penanganan data yang bervariasi.
  - **Heap Allocation:** Sebagian besar koleksi Rust dialokasikan di _heap_ (area memori yang lebih besar dan lebih fleksibel daripada _stack_), karena ukurannya tidak diketahui pada waktu kompilasi dan dapat berubah. Ini berbeda dari variabel sederhana yang sering dialokasikan di _stack_.
  - **Ownership dalam Koleksi:** Konsep _ownership_ dan _borrowing_ yang telah dipelajari di Modul 1.3 sangat relevan di sini. Anda akan memahami bagaimana _ownership_ elemen-elemen dalam koleksi dikelola, dan bagaimana meminjam referensi _mutable_ atau _immutable_ ke elemen-elemen tersebut secara aman.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  use std::collections::HashMap;

  fn main() {
      // Vec (Vector)
      let mut v: Vec<i32> = Vec::new(); // Explicit type annotation
      v.push(5);
      v.push(6);
      v.push(7);

      let v_macro = vec![1, 2, 3]; // Macro for convenience

      let third = &v[2]; // Access by index
      println!("The third element is {}", third);

      match v.get(2) { // Safer access with get()
          Some(third) => println!("The third element is {}", third),
          None => println!("There is no third element."),
      }

      // Iterating over a Vector
      for i in &mut v {
          *i += 50; // Dereference to modify the value
      }
      println!("{:?}", v);

      // String (Vec<u8> + UTF-8)
      let s = String::new();
      let s1 = String::from("hello");
      let s2 = "world".to_string();

      let mut s3 = String::from("foo");
      s3.push_str("bar");
      println!("{}", s3);

      let s4 = format!("{}-{}", s1, s2); // More flexible concatenation

      // HashMap
      let mut scores = HashMap::new();
      scores.insert(String::from("Blue"), 10);
      scores.insert(String::from("Yellow"), 50);

      let team_name = String::from("Blue");
      let score = scores.get(&team_name);

      for (key, value) in &scores {
          println!("{}: {}", key, value);
      }
  }
  ```

  Contoh ini menunjukkan pembuatan dan manipulasi `Vec`, berbagai cara membuat dan memodifikasi `String`, serta penggunaan dasar `HashMap` untuk menyimpan dan mengakses pasangan kunci-nilai. Ini mencakup cara mengakses elemen dan mengiterasi melalui koleksi.

- **Terminologi Esensial & Penjelasan Detil:**

  - **`Vec<T>` (Vector):** Sebuah koleksi yang dapat tumbuh dari elemen-elemen dengan tipe yang sama, disimpan secara berurutan dalam memori. Mirip dengan _dynamic array_ atau `ArrayList` di Java/C\#.
  - **`String`:** Implementasi _string_ yang dimiliki dan dapat diubah di Rust. Ini didukung oleh `Vec<u8>` dan dijamin valid UTF-8.
  - **`HashMap<K, V>` (Hash Map):** Sebuah struktur data yang menyimpan pasangan kunci-nilai (_key-value pairs_). Kunci (`K`) harus dapat di-_hash_ (misalnya, `String`, integer), dan nilai (`V`) dapat berupa tipe apa pun. Digunakan untuk pencarian nilai yang cepat berdasarkan kuncinya.
  - **`push`:** Metode yang digunakan untuk menambahkan elemen ke akhir sebuah _vector_ atau _string_.
  - **`insert`:** Metode yang digunakan untuk menambahkan pasangan kunci-nilai ke sebuah _hash map_.
  - **`get`:** Metode yang digunakan untuk mendapatkan referensi ke elemen berdasarkan indeks (untuk _vector_) atau kunci (untuk _hash map_). Metode ini mengembalikan `Option<T>`, yang memungkinkan penanganan yang aman jika elemen tidak ditemukan.
  - **Iterasi:** Proses melewati setiap elemen dalam koleksi secara berurutan. Rust menyediakan _iterators_ yang kuat untuk ini.
  - **Unicode:** Standar pengkodean karakter yang didukung penuh oleh `String` Rust, memungkinkan penanganan teks dari berbagai bahasa dan _script_.
  - **Hashing:** Proses mengubah data input menjadi nilai _hash_ berukuran tetap yang sering digunakan untuk mengindeks data dalam struktur seperti _hash map_.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - `Vec<T>`: Vector (Array Dinamis)
    - Membuat dan Memodifikasi Vector (menggunakan `Vec::new()`, `vec![]` makro, `push`, `pop`)
    - Mengakses Elemen Vector (dengan indeks `[]` dan metode `get()`)
    - Iterasi Melalui Vector (menggunakan `for` loop dengan referensi _immutable_ dan _mutable_)
    - Menyimpan Enum dalam Vector (menggunakan _enum_ untuk menyimpan tipe data heterogen)
  - `String`: String yang Dimiliki dan Dapat Diubah
    - Berbagai Cara Membuat String (`String::new()`, `String::from()`, `.to_string()`)
    - Menambahkan ke String (`push_str`, `push`, `+` operator)
    - Konkatenasi String (`format!`)
    - String dan Encoding UTF-8
    - Indexing String (Mengapa Sulit di Rust dan cara yang tepat)
  - `HashMap<K, V>`: Hash Map (Koleksi Key-Value)
    - Membuat Hash Map
    - Memasukkan dan Mengambil Nilai (`insert`, `get`)
    - Memperbarui Nilai dalam Hash Map (mengganti, hanya memasukkan jika tidak ada, memperbarui berdasarkan nilai lama)
    - Iterasi Melalui Hash Map
    - Kapan Menggunakan Hash Map (kasus penggunaan terbaik)

- **Rekomendasi Visualisasi:**
  Diagram yang menunjukkan bagaimana _vector_ tumbuh di _heap_ akan membantu. Untuk _hash map_, visualisasi bagaimana kunci di-_hash_ dan digunakan untuk menemukan nilai akan sangat bermanfaat. Ilustrasi bagaimana karakter UTF-8 dapat mengambil beberapa _byte_ dan mengapa _string indexing_ langsung sulit di Rust juga akan membantu.

- **Hubungan dengan Modul Lain:**
  Koleksi data digunakan di hampir setiap program Rust yang signifikan. Pemahaman _ownership_ (Modul 1.3) sangat penting saat berinteraksi dengan elemen-elemen koleksi. Konsep _error handling_ (Modul 2.1) juga relevan, karena operasi seperti `get()` pada _vector_ atau _hash map_ mengembalikan `Option`.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Storing Lists of Values with Vectors:** [https://doc.rust-lang.org/book/ch08-01-vectors.html](https://doc.rust-lang.org/book/ch08-01-vectors.html)
  - **The Rust Programming Language - Storing UTF-8 Encoded Text with Strings:** [https://doc.rust-lang.org/book/ch08-02-strings.html](https://doc.rust-lang.org/book/ch08-02-strings.html)
  - **The Rust Programming Language - Storing Keys with Associated Values in Hash Maps:** [https://doc.rust-lang.org/book/ch08-03-hash-maps.html](https://doc.rust-lang.org/book/ch08-03-hash-maps.html)

- **Tips dan Praktik Terbaik:**

  - Gunakan `vec![]` makro untuk inisialisasi _vector_ yang mudah.
  - Hindari _string concatenation_ yang sering menggunakan operator `+` karena melibatkan _ownership move_. Gunakan `format!` makro atau `push_str` untuk efisiensi.
  - Pilih koleksi yang tepat untuk masalah yang ada: `Vec` untuk daftar berurutan, `HashMap` untuk pencarian cepat berdasarkan kunci, dll.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Mengakses elemen _vector_ di luar batas dengan `v[index]`, yang akan menyebabkan _panic_ pada _runtime_.
    **Solusi:** Gunakan `v.get(index)` yang mengembalikan `Option<T>` dan tangani kasus `None` dengan aman.
  - **Kesalahan:** Mencoba meminjam elemen _vector_ sebagai _mutable_ saat _vector_ itu sendiri sudah dipinjam sebagai _immutable_.
    **Solusi:** Pastikan tidak ada pinjaman yang tidak kompatibel yang aktif pada saat yang sama. Ubah _scope_ pinjaman atau pastikan _vector_ tidak dipinjam di tempat lain.

### Modul 2.3: Traits dan Generics

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan memperkenalkan Anda pada dua konsep yang sangat kuat dan fundamental dalam desain _software_ Rust: **traits** dan **generics**. _Traits_ memungkinkan Anda mendefinisikan perilaku bersama yang dapat diimplementasikan oleh banyak tipe data, mirip dengan _interfaces_ atau _abstract classes_ di bahasa lain. Sementara itu, _generics_ memungkinkan Anda menulis kode yang dapat bekerja dengan berbagai tipe data tanpa perlu duplikasi kode, meningkatkan _reusability_ dan abstraksi.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Traits:** Kontrak perilaku. Mereka mendefinisikan kumpulan tanda tangan metode yang dapat diimplementasikan oleh tipe data. _Traits_ adalah cara Rust mencapai _polymorphism_ (kemampuan objek untuk mengambil banyak bentuk) dan perilaku yang dapat dibagi tanpa warisan kelas tradisional. Ini mempromosikan desain modular dan kode yang dapat diuji.
  - **Trait Objects (`dyn Trait`):** Memungkinkan _dynamic dispatch_ pada _traits_, yang berarti metode yang akan dipanggil ditentukan pada _runtime_. Ini berguna ketika Anda perlu bekerja dengan koleksi nilai-nilai dari berbagai tipe yang mengimplementasikan _trait_ tertentu, dan Anda tidak tahu tipe pastinya pada waktu kompilasi.
  - **Generics:** Parameter tipe atau _lifetime_ yang memungkinkan Anda menulis kode yang lebih abstrak dan dapat digunakan kembali. Dengan _generics_, Anda dapat mendefinisikan fungsi, _struct_, _enum_, atau metode yang bekerja dengan tipe apa pun yang memenuhi _trait bounds_ tertentu.
  - **Monomorphization:** Proses kompiler Rust menggantikan parameter _generic_ dengan tipe konkret pada waktu kompilasi. Ini berarti kode _generic_ dikompilasi menjadi kode spesifik untuk setiap tipe yang digunakan, tanpa biaya _runtime_ tambahan dibandingkan dengan kode yang ditulis secara manual untuk setiap tipe. Ini adalah salah satu kunci performa Rust.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  // Trait Definition
  pub trait Summary {
      fn summarize(&self) -> String {
          String::from("(Read more...)") // Default implementation
      }

      fn summarize_author(&self) -> String; // Required method
  }

  pub struct NewsArticle {
      pub headline: String,
      pub location: String,
      pub author: String,
      pub content: String,
  }

  // Trait Implementation
  impl Summary for NewsArticle {
      fn summarize(&self) -> String {
          format!("{}, by {} ({})", self.headline, self.author, self.location)
      }

      fn summarize_author(&self) -> String {
          format!("{}", self.author)
      }
  }

  pub struct Tweet {
      pub username: String,
      pub content: String,
      pub reply: bool,
      pub retweet: bool,
  }

  impl Summary for Tweet {
      fn summarize(&self) -> String {
          format!("{}: {}", self.username, self.content)
      }

      fn summarize_author(&self) -> String {
          format!("@{}", self.username)
      }
  }

  // Generic Function with Trait Bounds
  pub fn notify<T: Summary>(item: T) { // T must implement Summary
      println!("Breaking news! {}", item.summarize());
  }

  // Or using 'impl Trait' syntax
  pub fn notify_impl(item: impl Summary) {
      println!("Breaking news! {}", item.summarize());
  }

  // Generic Struct
  struct Point<T> {
      x: T,
      y: T,
  }

  // Generic Enum
  enum Either<L, R> {
      Left(L),
      Right(R),
  }

  fn main() {
      let tweet = Tweet {
          username: String::from("horse_ebooks"),
          content: String::from("of course, as you probably already know, people"),
          reply: false,
          retweet: false,
      };

      println!("1 new tweet: {}", tweet.summarize());
      println!("Author of tweet: {}", tweet.summarize_author());

      let article = NewsArticle {
          headline: String::from("Penguins win Stanley Cup!"),
          location: String::from("Pittsburgh, PA, USA"),
          author: String::from("Iceburgh"),
          content: String::from("The Pittsburgh Penguins once again won the Stanley Cup."),
      };

      notify(article); // Calls notify with NewsArticle

      let integer_point = Point { x: 5, y: 10 };
      let float_point = Point { x: 1.0, y: 4.0 };

      let e1 = Either::Left(10);
      let e2 = Either::Right("hello");
  }
  ```

  Contoh ini menunjukkan bagaimana mendefinisikan _trait_ `Summary` dengan implementasi _default_ dan metode yang diperlukan, serta bagaimana mengimplementasikannya untuk _struct_ `NewsArticle` dan `Tweet`. Kemudian, ditunjukkan fungsi _generic_ `notify` yang menerima tipe apa pun yang mengimplementasikan `Summary`, serta definisi _struct_ dan _enum_ _generic_.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Trait:** Sebuah kontrak perilaku yang dapat diimplementasikan oleh tipe data. Ini mendefinisikan kumpulan metode yang harus disediakan oleh tipe data yang mengimplementasikan _trait_ tersebut.
  - **`impl Trait for Type`:** Sintaks yang digunakan untuk mengimplementasikan sebuah _trait_ (`Trait`) untuk tipe tertentu (`Type`).
  - **Default Implementation:** Implementasi _method_ dalam _trait_ yang disediakan secara _default_. Implementasi ini dapat di-_override_ oleh tipe yang mengimplementasikan _trait_ jika diperlukan.
  - **Trait Bounds:** Kondisi yang menentukan bahwa parameter _generic_ harus mengimplementasikan _trait_ tertentu. Ini memastikan bahwa tipe _generic_ memiliki perilaku yang diharapkan.
  - **`impl Trait` syntax:** Cara yang lebih singkat dan nyaman untuk menentukan _trait bounds_ dalam tanda tangan fungsi, terutama ketika hanya ada satu _trait bound_.
  - **Generics:** Parameter tipe atau _lifetime_ yang memungkinkan Anda menulis kode yang fleksibel dan dapat digunakan kembali yang bekerja dengan berbagai tipe data, tanpa perlu menulis ulang kode untuk setiap tipe.
  - **Monomorphization:** Proses kompiler Rust pada waktu kompilasi di mana kode _generic_ diperluas menjadi versi spesifik untuk setiap tipe konkret yang digunakan. Ini menghasilkan _binary_ yang berkinerja tinggi tanpa _overhead runtime_ _generics_.
  - **Trait Object (`dyn Trait`):** Memungkinkan Anda memperlakukan nilai dari tipe yang berbeda secara seragam selama mereka mengimplementasikan _trait_ yang sama. Ini melibatkan _dynamic dispatch_, di mana metode yang akan dipanggil ditentukan pada _runtime_, dan memiliki sedikit _overhead runtime_.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Mendefinisikan Trait
  - Mengimplementasikan Trait pada Tipe
  - Default Implementation untuk Trait Methods
  - Memasukkan Trait ke dalam Scope (dengan `use` statement)
  - Trait sebagai Parameter Fungsi (Trait Bounds)
  - Sintaks `impl Trait`
  - Multiple Trait Bounds (menentukan beberapa _traits_ yang harus diimplementasikan)
  - Generic Types: Pengantar
  - Generic Functions
  - Generic Structs dan Enums
  - Generic Methods (metode pada _struct_ atau _enum_ _generic_)
  - Kombinasi Trait dan Generics (bagaimana mereka bekerja sama)
  - Trait Objects untuk Polymorphism Dinamis (`dyn Trait`)
  - Perbedaan antara Monomorphization dan Dynamic Dispatch (Trade-off kinerja dan fleksibilitas)

- **Rekomendasi Visualisasi:**
  Diagram yang membandingkan struktur _interface_ dengan _trait_ di Rust akan membantu. Visualisasi bagaimana _monomorphization_ menciptakan kode yang berbeda untuk setiap instansiasi _generic_ akan memperjelas konsepnya. Diagram yang menunjukkan bagaimana _trait object_ menyimpan pointer ke data dan pointer ke _vtable_ akan membantu memahami _dynamic dispatch_.

- **Hubungan dengan Modul Lain:**
  _Traits_ dan _generics_ adalah konsep tingkat lanjut yang membentuk dasar untuk banyak pola desain dan _library_ di Rust. Mereka sangat relevan dengan koleksi data (Modul 2.2), karena banyak metode koleksi bersifat _generic_ dan menggunakan _traits_ (_Iterator_, _Clone_, dll.).

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Traits: Defining Shared Behavior:** [https://doc.rust-lang.org/book/ch10-02-traits.html](https://doc.rust-lang.org/book/ch10-02-traits.html)
  - **The Rust Programming Language - Generic Types, Traits, and Lifetimes:** [https://doc.rust-lang.org/book/ch10-00-generics.html](https://doc.rust-lang.org/book/ch10-00-generics.html)
  - **The Rust Book - Trait Objects:** [https://doc.rust-lang.org/book/ch17-02-trait-objects.html](https://doc.rust-lang.org/book/ch17-02-trait-objects.html)

- **Tips dan Praktik Terbaik:**

  - Desainlah _traits_ yang kecil dan fokus pada satu tanggung jawab. Ini membuat mereka lebih mudah diimplementasikan dan digabungkan.
  - Gunakan _generics_ untuk kode yang dapat digunakan kembali dan berkinerja tinggi.
  - Pahami kapan harus menggunakan _trait_ sebagai _trait bound_ (_static dispatch_ / monomorphization) dan kapan harus menggunakan _trait object_ (_dynamic dispatch_). Pilihan ini memengaruhi performa dan fleksibilitas.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Menggunakan _generic_ tanpa _trait bounds_ yang cukup, sehingga kompiler tidak tahu metode apa yang dapat dipanggil.
    **Solusi:** Tambahkan _trait bounds_ yang sesuai (misal: `<T: Summary>`) ke definisi _generic_ Anda.
  - **Kesalahan:** Mencoba memodifikasi data melalui _immutable reference_ dalam fungsi _generic_.
    **Solusi:** Pastikan _trait bound_ menyertakan `DerefMut` jika Anda memerlukan mutabilitas, atau gunakan _mutable reference_ jika desain memungkinkan.

### Modul 2.4: Modules, Crates, dan Package

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan menjelaskan bagaimana kode Rust diatur dan dikelola secara hierarkis menggunakan **modules**, **crates**, dan **packages**. Memahami sistem organisasi kode ini sangat penting untuk mengelola proyek yang besar, meningkatkan _readability_, _maintainability_, dan _reusability_ kode Anda. Ini adalah tulang punggung struktur proyek Rust.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Organisasi Kode:** Rust menyediakan sistem _module_ yang kuat untuk memecah kode menjadi unit-unit logis yang lebih kecil dan terkelola. Ini membantu menghindari konflik nama dan memungkinkan _developer_ untuk fokus pada bagian-bagian kode tertentu.
  - **`crate`:** Unit kompilasi terkecil di Rust. Sebuah _crate_ dapat berupa _binary_ (aplikasi yang dapat dieksekusi, dengan `main.rs` sebagai _root_) atau _library_ (kumpulan fungsionalitas yang dapat digunakan oleh _crates_ lain, dengan `lib.rs` sebagai _root_).
  - **`package`:** Koleksi satu atau lebih _crates_ yang menyediakan serangkaian fungsionalitas. Setiap _package_ selalu memiliki file `Cargo.toml` di _root_-nya, yang mendefinisikan metadata dan dependensinya.
  - **`module`:** Unit organisasi kode di dalam sebuah _crate_. Modul dapat berisi fungsi, _struct_, _enum_, _traits_, atau modul lain, membentuk _module tree_ hierarkis.
  - **Visibility Rules:** Mekanisme Rust untuk mengontrol akses ke item (fungsi, _struct_, dll.). Secara _default_, semua item bersifat pribadi (tidak dapat diakses dari luar modul tempat mereka didefinisikan). Kata kunci `pub` digunakan untuk membuat item menjadi publik.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  // src/main.rs (binary crate root)
  mod front_of_house {
      pub mod hosting { // Public module
          pub fn add_to_waitlist() { // Public function
              println!("Added to waitlist!");
              serve_order(); // Private function in parent module
          }

          fn serve_order() { // Private function by default
              println!("Order served!");
          }
      }

      mod serving { // Private module
          fn take_order() {}
          fn serve_order() {}
          fn take_payment() {}
      }
  }

  mod back_of_house {
      pub struct Breakfast {
          pub toast: String,
          seasonal_fruit: String, // Private by default
      }

      impl Breakfast {
          pub fn summer(toast: &str) -> Breakfast {
              Breakfast {
                  toast: String::from(toast),
                  seasonal_fruit: String::from("peaches"),
              }
          }
      }

      pub enum Appetizer {
          Soup, // Public by default in enum
          Salad,
      }
  }

  // Using 'use' for easier path access
  use crate::front_of_house::hosting; // Absolute path
  // use self::front_of_house::hosting; // Relative path (less common in practice)

  fn main() {
      // Call function from module
      hosting::add_to_waitlist();

      // Create instance of public struct with private field accessed via public method
      let mut meal = back_of_house::Breakfast::summer("Rye");
      meal.toast = String::from("Wheat");
      println!("I'd like {} toast please", meal.toast);
      // meal.seasonal_fruit; // Error: seasonal_fruit is private

      // Using public enum variants
      let order1 = back_of_house::Appetizer::Soup;
      let order2 = back_of_house::Appetizer::Salad;
  }
  ```

  **Struktur Direktori:**

  ```
  └── my_project/
      ├── Cargo.toml
      └── src/
          ├── main.rs
          └── lib.rs (if it's a library crate)
          └── front_of_house/
              ├── mod.rs (for front_of_house module)
              └── hosting.rs (for hosting module within front_of_house)
  ```

  Contoh ini menunjukkan deklarasi modul (`mod`), fungsi (`fn`), _struct_ (`struct`), dan _enum_ (`enum`) dengan kata kunci `pub` untuk mengontrol visibilitas. Ini juga mengilustrasikan penggunaan `use` untuk membawa _path_ ke _scope_ dan bagaimana struktur file memetakan ke hierarki modul.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Package:** Unit terkecil dari fungsionalitas yang dapat diterbitkan di Rust. Sebuah _package_ berisi file `Cargo.toml` dan satu atau lebih _crates_.
  - **Crate:** Unit kompilasi di Rust. Setiap _package_ setidaknya memiliki satu _crate_, yang bisa berupa _library_ atau _binary_.
  - **Root Crate:** File sumber utama untuk sebuah _crate_. Untuk _binary crate_ adalah `src/main.rs`, dan untuk _library crate_ adalah `src/lib.rs`.
  - **Module:** Cara untuk mengatur dan mengelompokkan kode di dalam sebuah _crate_. Modul membantu membatasi _scope_ dan mengontrol visibilitas.
  - **`mod` keyword:** Digunakan untuk mendeklarasikan sebuah modul.
  - **`pub` keyword:** Digunakan untuk membuat item (seperti fungsi, _struct_, _enum_, atau modul) menjadi publik, yang berarti dapat diakses dari modul induk atau dari luar _crate_ (jika di-_export_).
  - **Private by Default:** Di Rust, semua item (fungsi, _struct_, dll.) di dalam sebuah modul secara _default_ bersifat pribadi dan tidak dapat diakses dari luar modul tersebut.
  - **Path:** Cara untuk merujuk ke item dalam _module tree_ Rust. Ada dua jenis: _Absolute Path_ (dimulai dari _root crate_ dengan `crate::`) dan _Relative Path_ (dimulai dari modul saat ini dengan `self::` atau `super::`).
  - **`use` keyword:** Digunakan untuk membawa sebuah _path_ ke dalam _scope_ saat ini, memungkinkan Anda untuk merujuk item dengan nama yang lebih pendek daripada _path_ lengkapnya.
  - **`super`:** Sebuah _relative path_ yang merujuk ke modul induk dari modul saat ini.
  - **`self`:** Sebuah _relative path_ yang merujuk ke modul saat ini.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Crates dan Packages: Unit Dasar Kompilasi dan Distribusi
  - Memahami Root Crate (`main.rs` dan `lib.rs`)
  - Modul: Mengatur Kode dalam Crate
  - Mendefinisikan Modul dengan `mod`
  - Hirarki Modul (Module Tree)
  - `pub` dan Aturan Visibilitas (Visibility Rules)
  - Jalur (Paths) untuk Mengakses Item dalam Modul
    - Absolute Paths
    - Relative Paths
  - Membawa Jalur ke dalam Scope dengan `use`
  - `as` keyword untuk Konflik Nama (mengganti nama item yang di-_import_)
  - `pub use` untuk Re-exporting (membuat item publik dari dependensi tersedia dari modul Anda)
  - Menggunakan File terpisah untuk Modul (organisasi fisik file)

- **Rekomendasi Visualisasi:**
  Diagram pohon yang menggambarkan hirarki _package_, _crate_, dan _module_ akan sangat membantu untuk memvisualisasikan bagaimana kode diorganisir. Ilustrasi aturan visibilitas `pub` dengan panah yang menunjukkan aksesibilitas antar modul juga akan memperjelas konsep ini.

- **Hubungan dengan Modul Lain:**
  Memahami sistem modul sangat fundamental untuk setiap proyek Rust yang lebih besar dari satu file. Ini memungkinkan _developer_ untuk mengatur kode secara logis, yang akan penting saat mengembangkan aplikasi yang lebih kompleks (Fase 3 & 4), dan saat mengintegrasikan _crates_ eksternal dari _crates.io_.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Managing Growing Projects with Packages, Crates, and Modules:** [https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html](https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html)
  - **The Rust Book - Paths for Referring to an Item in the Module Tree:** [https://doc.rust-lang.org/book/ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html](https://doc.rust-lang.org/book/ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html)

- **Tips dan Praktik Terbaik:**

  - Mulai dengan modul kecil dan tingkatkan kompleksitasnya secara bertahap.
  - Pertimbangkan untuk membagi modul menjadi file terpisah setelah mereka menjadi terlalu besar.
  - Gunakan `pub` dengan bijak, hanya mengekspos apa yang benar-benar perlu diakses dari luar.
  - Biasakan menggunakan _absolute paths_ dimulai dengan `crate::` atau _relative paths_ dengan `super::` atau `self::` untuk kejelasan.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Mencoba mengakses item pribadi dari luar modulnya.
    **Solusi:** Periksa apakah item tersebut perlu dibuat publik dengan `pub`.
  - **Kesalahan:** Konflik nama saat mengimpor dua item dengan nama yang sama menggunakan `use`.
    **Solusi:** Gunakan `as` keyword untuk memberikan alias pada salah satu item (misal: `use std::fmt::Result as FmtResult;`).

### Modul 2.5: Smart Pointers (Rc, Arc, Box, RefCell)

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan memperkenalkan Anda pada **smart pointers** di Rust, yang menyediakan fungsionalitas tambahan di luar sekadar mereferensikan data. Anda akan belajar tentang `Box`, `Rc`, `Arc`, dan `RefCell`, dan bagaimana masing-masing membantu mengelola _ownership_ dan _borrowing_ dalam skenario yang lebih kompleks, seperti struktur data yang saling mereferensi (_cyclic references_) atau konkurensi antar _thread_. Smart pointers adalah alat yang kuat untuk memperluas kemampuan _ownership_ Rust.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Smart Pointers:** Struktur data yang bertindak seperti pointer tetapi memiliki metadata dan kemampuan tambahan, seperti mengelola _ownership_, melakukan _reference counting_, atau melakukan pemeriksaan _borrow_ pada _runtime_. Mereka mengimplementasikan _traits_ `Deref` dan `Drop`.
  - **`Box<T>`:** Sebuah _smart pointer_ untuk alokasi _heap_. Digunakan ketika Anda memiliki data yang ukurannya tidak diketahui pada waktu kompilasi (misalnya, tipe rekursif seperti _linked list_ atau pohon), atau ketika Anda ingin memindahkan data ke _heap_ untuk menghindari ukuran _stack_ yang besar. `Box` memiliki _ownership_ tunggal.
  - **`Rc<T>` (Reference Counting):** Singkatan dari "Reference Counting". Ini memungkinkan _multiple ownership_ dari data yang sama dalam skenario _single-threaded_. Data akan dibebaskan dari memori hanya ketika tidak ada lagi _Rc_ yang menunjuk padanya (yaitu, _reference count_ mencapai nol).
  - **`Arc<T>` (Atomic Reference Counting):** Mirip dengan `Rc<T>`, tetapi `Arc` aman untuk digunakan di lingkungan _multi-threaded_. Ini menggunakan _atomic operations_ untuk memodifikasi _reference count_, yang memastikan operasi _thread-safe_ bahkan ketika banyak _thread_ mencoba mengakses data secara bersamaan.
  - **Interior Mutability:** Konsep di mana Anda dapat memodifikasi data di dalam referensi _immutable_. Ini biasanya tidak diizinkan oleh aturan _borrowing_ Rust, tetapi dapat dicapai dengan _smart pointer_ seperti `RefCell<T>`.
  - **`RefCell<T>`:** Sebuah _smart pointer_ yang memungkinkan _interior mutability_. Ini melakukan pemeriksaan aturan _borrowing_ pada _runtime_ daripada pada waktu kompilasi. Jika aturan _borrowing_ dilanggar pada _runtime_ (misalnya, mencoba melakukan dua _mutable borrow_ pada waktu yang sama), `RefCell` akan menyebabkan `panic!`. Ini digunakan dalam skenario _single-threaded_.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  use std::rc::Rc;
  use std::cell::RefCell;
  use std::sync::Arc;
  use std::thread;

  // Box
  enum List {
      Cons(i32, Box<List>),
      Nil,
  }

  // Rc (Reference Counting)
  #[derive(Debug)]
  enum RcList {
      RcCons(i32, Rc<RcList>),
      RcNil,
  }

  // RefCell (Interior Mutability)
  pub trait Messenger {
      fn send(&self, msg: &str);
  }

  pub struct LimitTracker<'a, T: Messenger> {
      messenger: &'a T,
      value: i32,
      max: i32,
  }

  impl<'a, T> LimitTracker<'a, T>
  where
      T: Messenger,
  {
      pub fn new(messenger: &'a T, max: i32) -> LimitTracker<'a, T> {
          LimitTracker {
              messenger,
              value: 0,
              max,
          }
      }

      pub fn set_value(&mut self, value: i32) {
          self.value = value;
          let percentage_of_max = self.value as f64 / self.max as f64;

          if percentage_of_max >= 0.75 && percentage_of_max < 0.9 {
              self.messenger
                  .send("Warning: You've used up over 75% of your quota!");
          } else if percentage_of_max >= 0.9 && percentage_of_max < 1.0 {
              self.messenger
                  .send("Urgent warning: You've used up over 90% of your quota!");
          } else if percentage_of_max >= 1.0 {
              self.messenger.send("Error: You are over your quota!");
          }
      }
  }

  struct MockMessenger {
      sent_messages: RefCell<Vec<String>>,
  }

  impl MockMessenger {
      fn new() -> MockMessenger {
          MockMessenger {
              sent_messages: RefCell::new(vec![]),
          }
      }
  }

  impl Messenger for MockMessenger {
      fn send(&self, message: &str) {
          self.sent_messages.borrow_mut().push(String::from(message));
      }
  }


  fn main() {
      // Box Usage
      use List::{Cons, Nil};
      let b = Box::new(5);
      println!("b = {}", b);

      let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));

      // Rc Usage
      use RcList::{RcCons, RcNil};
      let a = Rc::new(RcCons(5, Rc::new(RcCons(10, Rc::new(RcNil)))));
      println!("count after creating a = {}", Rc::strong_count(&a));
      let b = RcCons(3, Rc::clone(&a));
      println!("count after creating b = {}", Rc::strong_count(&a));
      {
          let c = RcCons(4, Rc::clone(&a));
          println!("count after creating c = {}", Rc::strong_count(&a));
      }
      println!("count after c goes out of scope = {}", Rc::strong_count(&a));

      // RefCell Usage
      let mock_messenger = MockMessenger::new();
      let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);
      limit_tracker.set_value(75);
      println!("Mock messages: {:?}", mock_messenger.sent_messages.borrow());

      // Arc Usage (Multithreading)
      let data = Arc::new(vec![1, 2, 3]);
      let mut handles = vec![];

      for i in 0..3 {
          let data_clone = Arc::clone(&data); // Clone the Arc for each thread
          handles.push(thread::spawn(move || {
              println!("Thread {} received: {:?}", i, data_clone);
          }));
      }

      for handle in handles {
          handle.join().unwrap();
      }
  }
  ```

  Contoh ini menunjukkan penggunaan `Box` untuk tipe data rekursif seperti _linked list_. Penggunaan `Rc` diilustrasikan dengan melacak _reference count_. `RefCell` ditunjukkan dalam skenario _interior mutability_ di mana `MockMessenger` memodifikasi pesan internalnya meskipun `LimitTracker` hanya memiliki referensi _immutable_ ke dalamnya. Akhirnya, `Arc` ditampilkan dalam konteks _multithreading_ untuk berbagi data secara aman antar _thread_.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Smart Pointer:** Sebuah _struct_ yang membungkus pointer dan menyediakan fungsionalitas tambahan, seperti manajemen memori otomatis atau validasi _borrow_.
  - **Heap Allocation:** Proses mengalokasikan memori di area memori yang dikenal sebagai _heap_. Data di _heap_ memiliki _lifetime_ yang lebih fleksibel dibandingkan data di _stack_.
  - **Deref Trait:** Sebuah _trait_ yang memungkinkan _smart pointer_ berperilaku seperti referensi (`&`) saat di-_dereference_ dengan operator `*`.
  - **Drop Trait:** Sebuah _trait_ yang memungkinkan Anda menentukan kode yang akan dijalankan ketika nilai keluar dari _scope_ dan memorinya dibebaskan. Ini mirip dengan _destructor_.
  - **`Box<T>`:** Sebuah _smart pointer_ yang mewakili _ownership_ tunggal atas data yang dialokasikan di _heap_.
  - **`Rc<T>`:** Singkatan dari _Reference Counting_. Sebuah _smart pointer_ yang memungkinkan _multiple ownership_ atas data di _heap_ dalam konteks _single-threaded_. Ini melacak berapa banyak referensi ke data yang ada, dan membebaskan data ketika jumlah referensi mencapai nol.
  - **`Arc<T>`:** Singkatan dari _Atomic Reference Counting_. Ini adalah versi _thread-safe_ dari `Rc<T>`. `Arc` menggunakan operasi _atomic_ untuk memodifikasi _reference count_, membuatnya aman untuk digunakan di lingkungan _multi-threaded_.
  - **Interior Mutability:** Sebuah pola di Rust di mana Anda dapat memodifikasi data yang ditunjuk oleh referensi _immutable_. Ini melanggar aturan _borrowing_ Rust secara konvensional tetapi diizinkan oleh jenis _smart pointer_ tertentu seperti `RefCell`.
  - **`RefCell<T>`:** Sebuah _smart pointer_ yang memungkinkan _interior mutability_ dengan memindahkan pemeriksaan aturan _borrowing_ ke _runtime_. Jika aturan _borrowing_ dilanggar pada _runtime_ (misalnya, mencoba mendapatkan dua _mutable borrow_ sekaligus), `RefCell` akan menyebabkan `panic!`. Ini hanya untuk skenario _single-threaded_.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Konsep Smart Pointers
  - `Box<T>`: Pointer ke Heap
    - Kasus Penggunaan `Box` (misalnya, tipe rekursif, data berukuran besar, _trait objects_)
  - `Deref` Trait: Memperlakukan Smart Pointer sebagai Referensi
  - `Drop` Trait: Menjalankan Kode Saat Nilai Keluar dari Scope
  - `Rc<T>`: Reference Counting Smart Pointer (Single-Threaded)
    - Menciptakan Multiple Ownership
    - Mengapa `Rc` Tidak Aman untuk Multi-threaded
  - `RefCell<T>` dan Interior Mutability (Single-Threaded)
    - Konsep Interior Mutability
    - `borrow()` dan `borrow_mut()` (metode untuk mendapatkan referensi aman)
    - Kapan Menggunakan `RefCell` (misalnya, _mock objects_, _callbacks_)
  - `Arc<T>`: Atomic Reference Counting Smart Pointer (Multi-Threaded)
    - Perbedaan `Rc` dan `Arc`
    - Menggunakan `Arc` dengan Thread
  - Perbandingan Smart Pointers: Kapan Menggunakan yang Mana (panduan keputusan)

- **Rekomendasi Visualisasi:**
  Diagram yang menunjukkan bagaimana `Box` mengalokasikan data di _heap_ akan membantu. Visualisasi _reference count_ untuk `Rc` dan `Arc` yang bertambah dan berkurang seiring dengan _clone_ dan pelepasan _scope_ akan sangat membantu. Diagram `RefCell` yang menunjukkan data yang dibungkus dan bagaimana ia mengizinkan _mutable borrow_ pada _runtime_ meskipun `RefCell` itu sendiri _immutable_ akan memperjelas konsep _interior mutability_.

- **Hubungan dengan Modul Lain:**
  Smart pointers adalah fondasi untuk penanganan kasus _ownership_ yang lebih kompleks, terutama saat berhadapan dengan struktur data rekursif atau ketika beberapa bagian kode perlu memiliki _ownership_ data yang sama. `Arc` adalah prasyarat penting untuk modul konkurensi (Modul 3.1) karena memungkinkan berbagi data secara aman antar _thread_.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Smart Pointers:** [https://doc.rust-lang.org/book/ch15-00-smart-pointers.html](https://doc.rust-lang.org/book/ch15-00-smart-pointers.html)
  - **The Rust Programming Language - Box\<T\>:** [https://doc.rust-lang.org/book/ch15-01-box.html](https://doc.rust-lang.org/book/ch15-01-box.html)
  - **The Rust Programming Language - Rc\<T\>:** [https://doc.rust-lang.org/book/ch15-04-rc.html](https://doc.rust-lang.org/book/ch15-04-rc.html)
  - **The Rust Programming Language - RefCell\<T\>:** [https://doc.rust-lang.org/book/ch15-05-interior-mutability.html](https://doc.rust-lang.org/book/ch15-05-interior-mutability.html)
  - **Rust Atomics and Locks - Arc:** [https://marabos.nl/atomics/basics.html\#arc](https://www.google.com/search?q=https://marabos.nl/atomics/basics.html%23arc)

- **Tips dan Praktik Terbaik:**

  - Gunakan `Box` ketika Anda tahu bahwa data perlu di-_heap_ dan hanya ada satu pemilik.
  - Gunakan `Rc` ketika Anda membutuhkan _multiple ownership_ dalam satu _thread_.
  - Gunakan `Arc` ketika Anda membutuhkan _multiple ownership_ dan berbagi data antar _thread_.
  - Gunakan `RefCell` (dan `Mutex` untuk _multi-threaded_) hanya ketika _borrow checker_ tidak dapat memverifikasi mutabilitas pada waktu kompilasi dan Anda membutuhkan _interior mutability_.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Menggunakan `Rc` di _multi-threaded_ `context` tanpa `Arc`, menyebabkan _compile-time error_ atau _runtime panic_.
    **Solusi:** Untuk _multi-threading_, selalu gunakan `Arc` sebagai pengganti `Rc`.
  - **Kesalahan:** Pelanggaran aturan _borrowing_ saat menggunakan `RefCell::borrow_mut()` yang menyebabkan _panic_ pada _runtime_ (misal: dua _mutable borrow_ dari `RefCell` yang sama).
    **Solusi:** Pastikan logika Anda mematuhi aturan _borrowing_ Rust, bahkan ketika pemeriksaan ditunda hingga _runtime_ oleh `RefCell`.

---

## Fase 3: Advanced (Mahir)

Fase ini akan membawa Anda ke topik-topik Rust yang lebih mendalam, termasuk konkurensi, makro, _unsafe Rust_, FFI (Foreign Function Interface), dan sistem _type_ yang lebih canggih. Anda akan mempelajari bagaimana membangun aplikasi yang lebih kompleks, berkinerja tinggi, dan berinteraksi dengan komponen non-Rust.

### Modul 3.1: Konkurensi dan Paralelisme

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan mengajarkan Anda cara menulis kode Rust yang aman dan efisien untuk **konkurensi** dan **paralelisme**. Anda akan mempelajari tentang _threads_, _message passing_ (saluran), _shared state concurrency_ (kondisi bersama yang dilindungi _mutex_), dan bagaimana sistem _ownership_ dan _borrowing_ Rust secara unik mencegah _data races_ pada waktu kompilasi. Ini adalah salah satu kekuatan terbesar Rust dalam membangun aplikasi yang responsif dan berkinerja tinggi.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Konkurensi vs. Paralelisme:** Memahami perbedaan fundamental. **Konkurensi** adalah tentang menangani banyak hal pada saat yang sama (misalnya, menjalankan beberapa tugas yang saling bergantian). **Paralelisme** adalah tentang melakukan banyak hal pada saat yang sama (misalnya, menjalankan beberapa tugas secara harfiah secara simultan pada banyak inti CPU). Rust mendukung keduanya dengan aman.
  - **Thread:** Unit eksekusi independen dalam suatu program. Setiap _thread_ memiliki _call stack_ sendiri dan dapat menjalankan kode secara semi-independen.
  - **Message Passing:** Cara aman dan idiomatik untuk komunikasi antar _thread_ di Rust. Filosofinya adalah "Jangan berkomunikasi dengan berbagi memori; bagikan memori dengan berkomunikasi." Ini dilakukan melalui _channels_ (`mpsc` - multi-producer, single-consumer), di mana data dikirim dari satu _thread_ ke _thread_ lain, dengan _ownership_ data yang ditransfer.
  - **Shared State Concurrency:** Komunikasi antar _thread_ dengan berbagi data yang sama. Untuk mencegah _data races_ (kondisi di mana dua atau lebih _thread_ mengakses data bersama secara bersamaan, dan setidaknya satu dari mereka memodifikasi data, menyebabkan hasil yang tidak terduga), Rust menggunakan mekanisme sinkronisasi seperti _Mutex_ (`Mutual Exclusion`) dan _RwLock_ (`Read-Write Lock`).
  - **`Send` dan `Sync` Traits:** Dua _marker traits_ penting di Rust yang digunakan oleh kompiler untuk menjamin keamanan _thread_.
    - **`Send`:** Sebuah tipe mengimplementasikan `Send` jika _ownership_ nilainya dapat ditransfer dengan aman antar _thread_. Hampir semua tipe di Rust adalah `Send`.
    - **`Sync`:** Sebuah tipe mengimplementasikan `Sync` jika referensi _immutable_ (`&T`) ke tipe tersebut aman untuk di-_share_ antar _thread_ (yaitu, dapat memiliki banyak _thread_ yang membaca data yang sama secara bersamaan).

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  use std::thread;
  use std::time::Duration;
  use std::sync::{mpsc, Mutex, Arc}; // mpsc for multi-producer, single-consumer

  fn main() {
      // Spawning Threads
      let handle = thread::spawn(|| {
          for i in 1..10 {
              println!("hi number {} from the spawned thread!", i);
              thread::sleep(Duration::from_millis(1));
          }
      });

      for i in 1..5 {
          println!("hi number {} from the main thread!", i);
          thread::sleep(Duration::from_millis(1));
      }

      handle.join().unwrap(); // Wait for the spawned thread to finish

      // Message Passing
      let (tx, rx) = mpsc::channel(); // Transmitter and Receiver

      thread::spawn(move || {
          let val = String::from("hi");
          tx.send(val).unwrap();
          // println!("val is {}", val); // Error: value moved
      });

      let received = rx.recv().unwrap();
      println!("Got: {}", received);

      // Shared State Concurrency with Mutex and Arc
      let counter = Arc::new(Mutex::new(0)); // Arc for multi-thread Rc, Mutex for interior mutability
      let mut handles = vec![];

      for _ in 0..10 {
          let counter_clone = Arc::clone(&counter);
          let handle = thread::spawn(move || {
              let mut num = counter_clone.lock().unwrap(); // Acquire the lock
              *num += 1;
          });
          handles.push(handle);
      }

      for handle in handles {
          handle.join().unwrap();
      }

      println!("Result: {}", *counter.lock().unwrap());
  }
  ```

  Contoh ini menunjukkan bagaimana membuat _thread_ baru dengan `thread::spawn` dan menunggu mereka selesai dengan `join()`. Kemudian, diilustrasikan komunikasi _message passing_ menggunakan _channel_ `mpsc`, di mana _ownership_ data berpindah. Terakhir, contoh menunjukkan _shared state concurrency_ yang aman menggunakan `Arc<Mutex<T>>` untuk berbagi data yang dapat diubah di antara banyak _thread_.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Thread:** Sebuah alur eksekusi independen dalam suatu program yang dapat berjalan secara bersamaan dengan alur lainnya.
  - **`thread::spawn`:** Fungsi di pustaka standar Rust untuk membuat _thread_ baru dan menjalankan sebuah _closure_ di dalamnya.
  - **`join()`:** Metode yang dipanggil pada _handle_ _thread_ yang dikembalikan oleh `thread::spawn`. Ini menyebabkan _thread_ pemanggil menunggu sampai _thread_ yang di-_spawn_ selesai eksekusi.
  - **Channel:** Mekanisme _message passing_ untuk komunikasi yang aman antar _thread_. Data dikirim dari satu ujung (_transmitter_) dan diterima di ujung lain (_receiver_).
  - **`mpsc` (Multi-Producer, Single-Consumer):** Sebuah jenis _channel_ di Rust yang memungkinkan banyak pengirim (`tx`) tetapi hanya satu penerima (`rx`).
  - **`tx` (Transmitter):** Bagian pengirim dari sebuah _channel_.
  - **`rx` (Receiver):** Bagian penerima dari sebuah _channel_.
  - **`send()`:** Metode pada _transmitter_ untuk mengirim data melalui _channel_.
  - **`recv()`:** Metode pada _receiver_ untuk menerima data dari _channel_. Ini akan memblokir jika tidak ada data yang tersedia.
  - **Mutex (Mutual Exclusion):** Sebuah mekanisme sinkronisasi yang memastikan hanya satu _thread_ yang dapat mengakses data bersama pada satu waktu. Ini mencegah _data races_.
  - **`lock()`:** Metode pada `Mutex` untuk memperoleh _lock_. Ini mengembalikan `MutexGuard` yang secara otomatis melepaskan _lock_ ketika keluar dari _scope_.
  - **`RwLock` (Read-Write Lock):** Mirip dengan `Mutex`, tetapi memungkinkan banyak _thread_ untuk membaca data secara bersamaan (dengan _read lock_), tetapi hanya satu _thread_ yang dapat menulis data pada satu waktu (dengan _write lock_).
  - **Atomic Operations:** Operasi yang dijamin selesai secara keseluruhan tanpa gangguan dari _thread_ lain. Digunakan oleh `Arc` untuk memastikan integritas _reference count_ dalam lingkungan _multi-threaded_.
  - **`Send` Trait:** _Marker trait_ yang menunjukkan bahwa _ownership_ dari tipe tersebut dapat dengan aman dipindahkan antar _thread_.
  - **`Sync` Trait:** _Marker trait_ yang menunjukkan bahwa referensi ke tipe tersebut aman untuk di-_share_ antar _thread_ (yaitu, tipe tersebut aman untuk diakses melalui referensi _immutable_ dari banyak _thread_ secara bersamaan).

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Memahami Konkurensi dan Paralelisme
  - Membuat Thread Baru dengan `thread::spawn`
  - Menunggu Thread Selesai dengan `join`
  - Menggunakan Move Closures dengan Thread (bagaimana _ownership_ ditransfer ke _closure_ _thread_)
  - Message Passing untuk Komunikasi Antar Thread
    - Channel MPSC (Multi-Producer, Single-Consumer)
    - Mengirim dan Menerima Pesan
    - Multiple Producers (menggunakan `tx.clone()`)
  - Shared-State Concurrency
    - Mutex (Mutual Exclusion): Melindungi Data Bersama
    - `MutexGuard` dan Aturan Ownership (bagaimana _lock_ dilepaskan secara otomatis)
    - Menggunakan `Arc<T>` dengan `Mutex<T>` untuk Shared Ownership Multi-Threaded
    - RwLock (Read-Write Lock)
  - Memahami `Send` dan `Sync` Traits
  - Mengimplementasikan Send dan Sync untuk Tipe Kustom (kapan ini diperlukan)
  - Pengantar ke Async/Await (future chapter - menyebutkan bahwa ini adalah topik terkait yang lebih lanjut)

- **Rekomendasi Visualisasi:**
  Diagram yang menunjukkan komunikasi melalui _channel_ antara _thread_, dengan panah yang menggambarkan pergerakan data dan _ownership_, akan sangat membantu. Visualisasi _mutex_ dan _lock_ yang melindungi data bersama, menunjukkan _thread_ yang menunggu _lock_ dilepaskan, juga akan sangat memperjelas.

- **Hubungan dengan Modul Lain:**
  Modul ini adalah kelanjutan langsung dari Modul 2.5 (Smart Pointers), khususnya penggunaan `Arc` untuk berbagi data di seluruh _thread_. Pemahaman yang kuat tentang _ownership_ dan _borrowing_ (Modul 1.3) adalah prasyarat mutlak untuk memahami mengapa mekanisme konkurensi Rust aman.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Concurrency:** [https://doc.rust-lang.org/book/ch16-00-concurrency.html](https://doc.rust-lang.org/book/ch16-00-concurrency.html)
  - **The Rust Programming Language - Message Passing:** [https://doc.rust-lang.org/book/ch16-02-message-passing.html](https://doc.rust-lang.org/book/ch16-02-message-passing.html)
  - **The Rust Programming Language - Shared-State Concurrency:** [https://doc.rust-lang.org/book/ch16-03-shared-state.html](https://doc.rust-lang.org/book/ch16-03-shared-state.html)
  - **The Rust Programming Language - Extensible Concurrency with the Sync and Send Traits:** [https://doc.rust-lang.org/book/ch16-04-extensible-concurrency-with-traits.html](https://www.google.com/search?q=https://doc.rust-lang.org/book/ch16-04-extensible-concurrency-with-traits.html)

- **Tips dan Praktik Terbaik:**

  - Untuk sebagian besar kasus, pendekatan _message passing_ (dengan _channels_) lebih disukai daripada _shared state_ karena lebih mudah untuk alasan dan cenderung lebih aman.
  - Selalu berhati-hati saat menggunakan `Arc<Mutex<T>>`. Meskipun aman, ini dapat menyebabkan _deadlock_ jika tidak digunakan dengan benar.
  - Biasakan diri dengan _asynchronous programming_ (`async/await`) setelah Anda menguasai dasar-dasar _threading_ tradisional.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** _Data race_ atau _panic_ karena mencoba mengakses data bersama tanpa perlindungan `Mutex` atau `RwLock`.
    **Solusi:** Pastikan semua akses ke data yang di-_share_ antar _thread_ dilindungi oleh _locking mechanism_ yang sesuai (`Mutex` untuk mutabilitas eksklusif, `RwLock` untuk banyak pembaca/satu penulis).
  - **Kesalahan:** _Deadlock_ saat menggunakan `Mutex` (misal: satu _thread_ mengunci `Mutex` dan kemudian mencoba mengunci `Mutex` lain yang sudah dikunci oleh _thread_ pertama, atau melupakan untuk melepaskan _lock_).
    **Solusi:** Desain _locking strategy_ Anda dengan cermat. Hindari mengunci terlalu banyak data sekaligus. Gunakan `MutexGuard` yang otomatis melepaskan _lock_ saat keluar dari _scope_.

### Modul 3.2: Advanced Type System dan Traits Lanjutan

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan membawa Anda lebih dalam ke sistem _type_ Rust yang kaya dan _traits_ yang lebih canggih. Anda akan mempelajari tentang **associated types**, **default generic type parameters**, **Deref coercions**, dan dunia **macros** (baik deklaratif maupun prosedural). Penguasaan konsep-konsep ini akan memungkinkan Anda menulis kode yang lebih ekspresif, fleksibel, dan meta-program secara efektif, membangun abstraksi yang lebih kuat.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Associated Types:** Placeholder untuk tipe yang terkait dengan _trait_. Mereka memungkinkan Anda untuk mendefinisikan tipe _output_ yang berbeda atau tipe terkait lainnya untuk implementasi _trait_ yang berbeda. Ini membuat _trait_ lebih fleksibel dan dapat digunakan kembali daripada menggunakan parameter _generic_ yang berlebihan.
  - **Default Generic Type Parameters:** Fitur yang mengizinkan Anda menentukan tipe _default_ untuk parameter _generic_ dari _struct_, _enum_, atau _trait_. Ini menyederhanakan penggunaan _trait_ atau tipe _generic_ dalam banyak kasus, tetapi memungkinkan kustomisasi jika diperlukan.
  - **Deref Coercions:** Mekanisme yang secara otomatis mengonversi referensi dari tipe yang mengimplementasikan _trait_ `Deref` menjadi referensi ke tipe target yang di-_deref_-kan. Ini menyederhanakan kode saat bekerja dengan _smart pointers_ dan menghindari kebutuhan untuk _dereferencing_ manual (`*`) dalam banyak konteks.
  - **Macros:** Kode yang menulis kode lain (_meta-programming_). Makro di Rust adalah fitur yang sangat kuat untuk mengurangi duplikasi kode, menerapkan pola berulang, dan memperluas sintaks bahasa. Ada dua jenis utama:
    - **Declarative Macros (`macro_rules!`):** Didefinisikan menggunakan sintaks deklaratif yang mirip dengan _match expression_, mencocokkan pola pada struktur token dan menggantinya dengan kode yang ditentukan.
    - **Procedural Macros:** Lebih kuat dan fleksibel, diimplementasikan sebagai fungsi Rust yang beroperasi pada _Abstract Syntax Tree_ (AST) dari kode Rust. Ini termasuk _custom derive macros_ (`#[derive]`), _attribute-like macros_ (`#[attribute]`), dan _function-like macros_ (`my_macro!()`).

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  // Associated Types
  pub trait Iterator {
      type Item; // Associated type

      fn next(&mut self) -> Option<Self::Item>;
  }

  struct Counter {
      count: u32,
  }

  impl Iterator for Counter {
      type Item = u32;

      fn next(&mut self) -> Option<Self::Item> {
          if self.count < 5 {
              self.count += 1;
              Some(self.count)
          } else {
              None
          }
      }
  }

  // Deref Coercions
  use std::ops::Deref;

  struct MyBox<T>(T);

  impl<T> MyBox<T> {
      fn new(x: T) -> MyBox<T> {
          MyBox(x)
      }
  }

  impl<T> Deref for MyBox<T> {
      type Target = T;

      fn deref(&self) -> &T {
          &self.0
      }
  }

  // Declarative Macro (macro_rules!)
  macro_rules! hello {
      () => { // Match no arguments
          println!("Hello, world!");
      };
      ($name:expr) => { // Match a single expression
          println!("Hello, {}!", $name);
      };
  }

  fn main() {
      // Associated Types Usage
      let mut counter_iter = Counter { count: 0 };
      println!("Counter next: {:?}", counter_iter.next()); // Output: Some(1)

      // Deref Coercions Usage
      let m = MyBox::new(String::from("Rust"));
      hello_string(&m); // MyBox is automatically dereferenced to &String, then to &str

      // Macro Usage
      hello!();
      hello!("Rustacean");
  }

  fn hello_string(name: &str) {
      println!("Hello, {}", name);
  }
  ```

  Contoh ini menunjukkan _trait_ `Iterator` dengan _associated type_ `Item`, yang memungkinkan implementasi _iterator_ yang berbeda untuk mengembalikan tipe elemen yang berbeda. Implementasi _trait_ `Deref` untuk `MyBox` mengilustrasikan bagaimana _deref coercions_ memungkinkan `MyBox<String>` berperilaku seperti `&str` secara otomatis. Akhirnya, contoh `macro_rules!` menunjukkan bagaimana membuat makro deklaratif yang dapat mencetak berbagai pesan berdasarkan input.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Associated Type:** Tipe yang didefinisikan sebagai bagian dari sebuah _trait_ (menggunakan `type Item;`), bukan sebagai parameter _generic_ pada _trait_ itu sendiri. Ini memungkinkan setiap implementasi _trait_ untuk menentukan tipe konkretnya sendiri untuk _associated type_ tersebut.
  - **Default Generic Type Parameters:** Parameter _generic_ pada _struct_, _enum_, atau _trait_ yang memiliki nilai _default_. Ini mengurangi verbositas saat menggunakan tipe _generic_ tetapi tetap memungkinkan kustomisasi.
  - **Fully Qualified Syntax:** Cara eksplisit untuk memanggil metode ketika ada _trait_ atau implementasi _method_ yang tumpang tindih. Ini berbentuk `<Type as Trait>::method()`.
  - **Deref Trait:** Sebuah _trait_ di `std::ops` yang memungkinkan Anda menyesuaikan perilaku operator _dereference_ (`*`).
  - **Deref Coercions:** Konversi implisit yang dilakukan oleh kompiler Rust di mana referensi (`&T`) dari tipe yang mengimplementasikan `Deref` secara otomatis diubah menjadi referensi ke tipe target (`&U`) yang di-_deref_-kan. Ini terjadi dalam argumen fungsi, penetapan, dan _method calls_.
  - **Drop Trait:** Sebuah _trait_ yang memungkinkan Anda menentukan kode yang dijalankan ketika nilai keluar dari _scope_ dan dibersihkan dari memori. Ini sering digunakan untuk membersihkan sumber daya seperti file atau koneksi jaringan.
  - **Macros:** Kode yang dapat menghasilkan kode Rust lainnya pada waktu kompilasi (_meta-programming_).
  - **Declarative Macros (`macro_rules!`):** Jenis makro yang didefinisikan dengan mencocokkan pola pada struktur token kode dan menggantinya dengan kode baru. Mereka lebih sederhana untuk ditulis tetapi kurang fleksibel daripada _procedural macros_.
  - **Procedural Macros:** Jenis makro yang lebih canggih dan fleksibel. Mereka diimplementasikan sebagai fungsi Rust yang menerima _Abstract Syntax Tree_ (AST) dari kode sebagai input dan mengembalikan AST yang dimodifikasi. Termasuk:
    - **Custom Derive Macros:** Digunakan dengan atribut `#[derive]` untuk secara otomatis menghasilkan implementasi _trait_.
    - **Attribute-like Macros:** Digunakan dengan atribut kustom pada item (misalnya, `#[route("/")]`).
    - **Function-like Macros:** Mirip dengan fungsi tetapi beroperasi pada token mentah dan menghasilkan kode.
  - **AST (Abstract Syntax Tree):** Representasi terstruktur dari kode sumber dalam bentuk pohon, digunakan oleh _procedural macros_.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Associated Types dengan Traits
  - Default Generic Type Parameters
  - Overlapping Traits (Konflik Nama Metode dan bagaimana mengatasinya)
  - Fully Qualified Syntax
  - `Deref` Trait dan Deref Coercions
  - `Drop` Trait untuk Pembersihan Kode
  - Pengantar Macro di Rust
  - Declarative Macros (`macro_rules!`)
    - Sintaks Dasar `macro_rules!`
    - Fragmen Specifiers (aturan untuk mencocokkan bagian-bagian kode)
    - Contoh Penggunaan Declarative Macros
  - Procedural Macros
    - Custom Derive Macros (`#[derive]`)
    - Attribute-like Macros (`#[attribute]`)
    - Function-like Macros (`my_macro!()`)
    - Memahami `syn`, `quote`, dan `proc_macro2` (crates yang membantu menulis _procedural macros_)

- **Rekomendasi Visualisasi:**
  Diagram yang membandingkan bagaimana _associated types_ menyederhanakan _trait_ dibandingkan dengan menggunakan banyak parameter _generic_. Visualisasi _deref coercions_ sebagai "alur" di mana tipe secara otomatis diubah menjadi referensinya akan membantu. Diagram alir yang menunjukkan proses _declarative macro_ (dari token input ke token output) dan _procedural macro_ (dari AST input ke AST output) akan sangat berguna.

- **Hubungan dengan Modul Lain:**
  Konsep _traits_ dan _generics_ adalah perluasan dari Modul 2.3. Pemahaman tentang makro adalah penting untuk _tooling_ Rust dan memahami bagaimana banyak _library_ populer (seperti Serde, Actix) dibangun.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Advanced Traits:** [https://doc.rust-lang.org/book/ch19-03-advanced-traits.html](https://doc.rust-lang.org/book/ch19-03-advanced-traits.html)
  - **The Rust Programming Language - Advanced Types:** [https://doc.rust-lang.org/book/ch19-04-advanced-types.html](https://doc.rust-lang.org/book/ch19-04-advanced-types.html)
  - **The Rust Programming Language - Macros:** [https://doc.rust-lang.org/book/ch19-06-macros.html](https://doc.rust-lang.org/book/ch19-06-macros.html)
  - **The Little Book of Rust Macros:** [https://danielkeep.github.io/tlborm/index.html](https://www.google.com/search?q=https://danielkeep.github.io/tlborm/index.html)
  - **Rust Reference - Attributes (Procedural Macros):** [https://doc.rust-lang.org/reference/procedural-macros.html](https://doc.rust-lang.org/reference/procedural-macros.html)

- **Tips dan Praktik Terbaik:**

  - Gunakan _associated types_ untuk _traits_ yang memiliki satu tipe output yang jelas terkait dengan implementasinya.
  - Gunakan makro untuk mengurangi _boilerplate_ dan membuat API yang lebih ekspresif, tetapi jangan menyalahgunakannya untuk hal-hal yang dapat dicapai dengan fungsi biasa.
  - Menulis _procedural macros_ jauh lebih kompleks dan seringkali lebih baik menggunakan _crates_ yang sudah ada seperti `syn` dan `quote`.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Kesalahan _macro expansion_ yang sulit di-_debug_.
    **Solusi:** Gunakan alat seperti `cargo expand` untuk melihat kode yang dihasilkan oleh makro, yang dapat membantu menemukan masalah.
  - **Kesalahan:** Kebingungan antara _macro_ dan fungsi biasa.
    **Solusi:** Ingat bahwa makro di-_expand_ pada waktu kompilasi, sedangkan fungsi dipanggil pada _runtime_. Makro tidak mengikuti aturan _ownership_ dan _borrowing_ yang ketat pada inputnya karena mereka beroperasi pada token.

### Modul 3.3: Unsafe Rust dan Foreign Function Interface (FFI)

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan membahas tentang **Unsafe Rust**, bagian dari Rust yang memungkinkan Anda melanggar beberapa jaminan keamanan memori Rust yang ketat. Ini adalah fitur canggih yang krusial untuk kasus penggunaan tertentu seperti berinteraksi dengan kode yang ditulis dalam bahasa lain (melalui Foreign Function Interface - FFI), membangun sistem operasi, atau mengoptimalkan performa dalam kasus-kasus khusus. Anda akan belajar kapan dan bagaimana menggunakan `unsafe` dengan aman dan bertanggung jawab, memahami bahwa `unsafe` tidak berarti "tanpa pemeriksaan" tetapi berarti "Anda bertanggung jawab untuk memastikan keamanannya."

- **Konsep Kunci & Filosofi Mendalam:**

  - **Unsafe Rust:** Subset bahasa Rust yang memungkinkan Anda melakukan operasi yang tidak dapat diverifikasi oleh _borrow checker_ Rust. Meskipun ini memungkinkan Anda untuk melewati beberapa jaminan keamanan, ini bukan berarti Rust akan membiarkan Anda melakukan apa pun yang berbahaya. Sebaliknya, ini memindahkan tanggung jawab untuk menjaga keamanan memori kepada _developer_.
  - **Five Unsafe Superpowers:** Ada lima hal yang hanya dapat Anda lakukan di dalam blok `unsafe` atau dengan fungsi/trait `unsafe`:
    1.  _Dereference a raw pointer._ (Mendapatkan nilai dari _raw pointer_).
    2.  _Call an unsafe function or method._ (Memanggil fungsi yang ditandai sebagai `unsafe`).
    3.  _Access or modify a mutable static variable._ (Mengakses atau memodifikasi variabel _static_ yang _mutable_).
    4.  _Implement an unsafe trait._ (Mengimplementasikan _trait_ yang ditandai sebagai `unsafe`).
    5.  _Access fields of unions._ (Mengakses bidang _union_).
  - **Foreign Function Interface (FFI):** Mekanisme standar yang digunakan oleh Rust untuk memanggil kode yang ditulis dalam bahasa pemrograman lain (biasanya C/C++) dari kode Rust, dan sebaliknya. Ini penting untuk berinteraksi dengan _library_ sistem operasi, driver, atau _library_ pihak ketiga yang sudah ada yang ditulis dalam C/C++.
  - **`extern "C"`:** Atribut yang digunakan untuk mendeklarasikan blok fungsi eksternal yang mengikuti _C ABI_ (Application Binary Interface). Ini memastikan bahwa fungsi-fungsi dapat dipanggil dengan benar oleh dan dari kode C.
  - **Raw Pointers (`*const T`, `*mut T`):** Pointer mentah di Rust, mirip dengan pointer di C/C++. Mereka tidak memiliki jaminan _ownership_ atau _borrowing_ yang kuat dari Rust, dan _developer_ bertanggung jawab penuh atas validitas dan keamanannya.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  use std::slice;

  fn main() {
      // Unsafe: Dereferencing a Raw Pointer
      let mut num = 5;
      let r1 = &num as *const i32; // Immutable raw pointer
      let r2 = &mut num as *mut i32; // Mutable raw pointer

      unsafe {
          println!("r1 is: {}", *r1);
          *r2 = 6;
          println!("r2 is: {}", *r2);
      }

      // Unsafe Function Call
      unsafe fn dangerous() {
          println!("This is a dangerous function!");
      }
      unsafe {
          dangerous();
      }

      // Unsafe: Splitting a slice (illustrates raw pointers)
      let mut v = vec![1, 2, 3, 4, 5, 6];
      let r = &mut v[..];
      let (a, b) = split_at_mut(r, 3);
      assert_eq!(a, &mut [1, 2, 3]);
      assert_eq!(b, &mut [4, 5, 6]);
      println!("a: {:?}, b: {:?}, v: {:?}", a, b, v); // v here still valid

      // FFI: Calling external C function
      // Assuming you have a C library compiled into `libhello.a` or `libhello.so`
      // with a function `hello_from_c()`
      extern "C" {
          fn hello_from_c(); // Declaration of C function
      }

      unsafe {
          hello_from_c(); // Call the C function
      }
  }

  fn split_at_mut(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
      let len = slice.len();
      assert!(mid <= len);
      let ptr = slice.as_mut_ptr();

      unsafe {
          (
              slice::from_raw_parts_mut(ptr, mid),
              slice::from_raw_parts_mut(ptr.add(mid), len - mid),
          )
      }
  }

  /* C code for hello_from_c.c
  #include <stdio.h>

  void hello_from_c() {
      printf("Hello from C!\n");
  }
  */
  ```

  Contoh ini mengilustrasikan bagaimana cara _dereference raw pointer_, memanggil fungsi `unsafe`, dan menggunakan FFI untuk mendeklarasikan dan memanggil fungsi C dari Rust. Fungsi `split_at_mut` adalah contoh bagaimana `unsafe` dapat digunakan untuk membangun abstraksi yang lebih aman di atas operasi _raw pointer_.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Unsafe Keyword:** Kata kunci yang digunakan untuk menandai blok kode atau fungsi yang berisi operasi yang tidak dapat diverifikasi oleh _borrow checker_ Rust pada waktu kompilasi.
  - **Raw Pointers (`*const T`, `*mut T`):** Pointer langsung ke lokasi memori yang tidak memiliki jaminan keamanan memori Rust seperti referensi (`&`). Anda bertanggung jawab penuh untuk memastikan bahwa _raw pointer_ valid dan tidak menyebabkan _memory safety issues_.
  - **`Deref` vs. Raw Pointers:** Meskipun keduanya melibatkan "penunjuk" ke data, `Deref` digunakan untuk _smart pointers_ yang menyediakan abstraksi aman di atas data yang dialokasikan (misalnya, `Box`, `Rc`), sementara _raw pointers_ adalah pointer tingkat rendah tanpa abstraksi dan jaminan keamanan.
  - **FFI (Foreign Function Interface):** Mekanisme standar untuk memungkinkan kode yang ditulis dalam satu bahasa pemrograman (misalnya, Rust) untuk berinteraksi dengan kode yang ditulis dalam bahasa lain (misalnya, C, C++).
  - **`extern "C"`:** Atribut yang digunakan untuk mendeklarasikan blok fungsi eksternal yang mengikuti _C Application Binary Interface_ (ABI). Ini memastikan fungsi dapat dipanggil dengan konvensi panggilan C.
  - **ABI (Application Binary Interface):** Sebuah standar tentang bagaimana fungsi dipanggil pada tingkat _assembly_, termasuk bagaimana argumen diteruskan dan nilai dikembalikan.
  - **`no_mangle`:** Atribut yang digunakan untuk mencegah kompiler Rust memodifikasi nama fungsi. Ini penting untuk FFI agar fungsi Rust dapat dipanggil dari C dengan nama yang diharapkan.
  - **Crate Type `cdylib`:** Tipe _crate_ yang digunakan untuk menghasilkan _dynamic C library_ (misalnya, `.so` di Linux, `.dylib` di macOS, `.dll` di Windows). Ini dapat dimuat pada _runtime_ oleh program lain.
  - **Crate Type `staticlib`:** Tipe _crate_ yang digunakan untuk menghasilkan _static C library_ (misalnya, `.a` di Linux/macOS, `.lib` di Windows). Ini di-_link_ ke _binary_ pada waktu kompilasi.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Memahami Unsafe Rust: Tujuan dan Risiko
  - Lima "Superpowers" Unsafe Rust
    - Dereferencing Raw Pointers
    - Memanggil Fungsi atau Metode Unsafe
    - Mengakses atau Memodifikasi Variabel Static Mutable
    - Mengimplementasikan Unsafe Trait
    - Mengakses Bidang Union
  - Membuat Fungsi Unsafe
  - `unsafe` vs. `safe` Abstraksi (bagaimana _safe abstraction_ dapat dibangun di atas `unsafe` kode)
  - Foreign Function Interface (FFI)
    - Memanggil Kode C dari Rust (`extern "C"`)
    - Mengekspos Kode Rust ke C (menggunakan `no_mangle` dan `extern "C"`)
    - Menggunakan `no_mangle` dan `C ABI`
    - Mengelola Tipe Data Antara Rust dan C (pemetaan tipe, konversi)
    - Pointer dan Memory Management dalam FFI (siapa yang bertanggung jawab untuk alokasi/dealokasi)
  - Studi Kasus: Membangun Bindings untuk Library C (menggunakan _crates_ seperti `bindgen`)
  - Best Practices untuk Menggunakan Unsafe Rust

- **Rekomendasi Visualisasi:**
  Diagram yang menunjukkan perbedaan antara _safe_ dan _unsafe_ _pointer_ dan bagaimana _borrow checker_ berinteraksi dengan keduanya. Ilustrasi tentang bagaimana FFI menjembatani kode Rust dan C, termasuk bagaimana data dan panggilan fungsi melewati batas bahasa.

- **Hubungan dengan Modul Lain:**
  `Unsafe Rust` adalah topik yang berdiri sendiri tetapi dapat memengaruhi performa (`Modul 4.1: Pengoptimalan Performa`) dan memungkinkan interaksi dengan sistem tingkat rendah. FFI adalah teknik penting saat mengintegrasikan Rust ke dalam ekosistem _software_ yang sudah ada.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Unsafe Rust:** [https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html](https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html)
  - **The Rust FFI Guide:** [https://docs.rust-embedded.org/book/interoperability/ffi.html](https://www.google.com/search?q=https://docs.rust-embedded.org/book/interoperability/ffi.html)
  - **Rust Reference - FFI:** [https://doc.rust-lang.org/reference/ffi.html](https://www.google.com/search?q=https://doc.rust-lang.org/reference/ffi.html)

- **Tips dan Praktik Terbaik:**

  - Gunakan `unsafe` hanya jika Anda benar-benar yakin Anda memahami implikasinya dan tidak ada cara _safe_ untuk mencapai tujuan yang sama.
  - Batasi cakupan blok `unsafe` sekecil mungkin.
  - Kapsulkan kode `unsafe` dalam _safe abstraction_ jika memungkinkan, sehingga pengguna API Anda tidak perlu menulis `unsafe` sendiri.
  - Selalu dokumentasikan mengapa Anda membutuhkan `unsafe` dan apa jaminan yang harus dipertahankan.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Menggunakan `unsafe` untuk menghindari _borrow checker_ tanpa memahami risiko keamanan memori.
    **Solusi:** Pertimbangkan kembali desain Anda terlebih dahulu untuk melihat apakah ada solusi _safe_. Jika tidak, pelajari dan pahami secara menyeluruh apa yang Anda lakukan dalam blok `unsafe`.
  - **Kesalahan:** Kebingungan dengan konvensi pemanggilan C (ABI) saat menggunakan FFI.
    **Solusi:** Pastikan Anda menggunakan tipe data yang sesuai dan konvensi panggilan yang benar (`extern "C"`).

### Modul 3.4: Desain Pola Lanjutan dan Idiom Rust

- **Deskripsi Konkret & Peran dalam Kurikulum:**
  Modul ini akan fokus pada pola desain umum dan **idiom Rust** yang membantu Anda menulis kode yang lebih _idiomatic_, _maintainable_, dan efisien. Ini mencakup penggunaan _iterators_ yang kuat, _closures_ fleksibel, _pattern matching_ lanjutan, dan praktik terbaik untuk struktur kode. Tujuannya adalah untuk mendorong penulisan kode Rust yang tidak hanya berfungsi, tetapi juga terlihat dan terasa "Rust-y", memanfaatkan kekuatan ekspresif dari bahasa ini.

- **Konsep Kunci & Filosofi Mendalam:**

  - **Idiomatic Rust:** Menulis kode dengan cara yang paling "Rust-y," yaitu memanfaatkan fitur bahasa dan filosofi desainnya secara optimal. Ini berarti menggunakan fitur-fitur seperti _ownership_, _traits_, _enums_, dan _pattern matching_ secara ekstensif.
  - **Iterators:** Mekanisme yang sangat kuat di Rust untuk memproses urutan item secara efisien dan deklaratif. Mereka mendorong gaya pemrograman fungsional, memungkinkan rantai operasi yang bersih pada koleksi data tanpa perlu perulangan manual yang seringkali rentan _bug_.
  - **Closures:** Fungsi anonim yang dapat menangkap nilai dari lingkungan di sekitarnya tempat mereka didefinisikan. Mereka sangat fleksibel dan sering digunakan dengan _iterators_, dalam _callbacks_, dan untuk _event handling_.
  - **Pattern Matching Lanjutan:** Pemanfaatan penuh `match` expression untuk dekomposisi data yang kompleks, mengekstrak nilai, dan mengeksekusi kode berdasarkan bentuk data. Ini jauh lebih kuat daripada `switch` statement di bahasa lain.
  - **Pola Desain:** Solusi umum yang dapat diterapkan untuk masalah desain berulang dalam pengembangan perangkat lunak. Modul ini akan membahas bagaimana pola-pola ini diwujudkan dalam konteks Rust yang unik.

- **Sintaks Dasar / Contoh Implementasi Inti:**

  ```rust
  fn main() {
      // Iterators and Combinators
      let v1 = vec![1, 2, 3];
      let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();
      println!("v2: {:?}", v2);

      // Closures
      let intensity = 10;
      let random_number = 7;
      let expensive_closure = |num: u32| -> u32 {
          println!("calculating slowly...");
          thread::sleep(Duration::from_secs(2));
          num
      };

      if intensity < 25 {
          println!(
              "Today, do {} pushups!",
              expensive_closure(intensity)
          );
          println!(
              "Next, do {} situps!",
              expensive_closure(random_number)
          );
      } else {
          if random_number == 3 {
              println!("Take a break today! Remember to stay hydrated!");
          } else {
              println!(
                  "Today, do {} minutes of running!",
                  expensive_closure(intensity)
              );
          }
      }

      // Pattern Matching Lanjutan (if let, while let, match guards, @ bindings)
      let favorite_color: Option<&str> = None;
      let is_tuesday = false;
      let age: Result<u8, _> = "34".parse();

      if let Some(color) = favorite_color {
          println!("Using your favorite color, {}, as the background", color);
      } else if is_tuesday {
          println!("Tuesday is green day!");
      } else if let Ok(age) = age {
          if age > 30 {
              println!("Using purple as the background color");
          } else {
              println!("Using orange as the background color");
          }
      } else {
          println!("Using blue as the background color");
      }

      enum Message {
          Quit,
          Move { x: i32, y: i32 },
          Write(String),
          ChangeColor(i32, i32, i32),
      }

      let msg = Message::ChangeColor(0, 160, 255);

      match msg {
          Message::Quit => println!("The Quit variant has no data to deconstruct."),
          Message::Move { x, y } => {
              println!("Move in the x direction {} and in the y direction {}", x, y);
          }
          Message::Write(text) => println!("Text message: {}", text),
          Message::ChangeColor(r, g, b) => {
              println!("Change the color to red {}, green {}, and blue {}", r, g, b);
          }
      }

      // Match guards
      let num = Some(4);
      match num {
          Some(x) if x < 5 => println!("less than five: {}", x),
          Some(x) => println!("{}", x),
          None => (),
      }

      // @ Bindings
      enum Hello {
          Id(usize),
          Name(String),
      }

      let id_val = Hello::Id(5);
      match id_val {
          Hello::Id(id @ 0..=10) => println!("Found an ID in range: {}", id),
          _ => println!("Other ID"),
      }
  }
  ```

  Contoh ini menunjukkan penggunaan _iterators_ dengan _combinators_ seperti `map` dan `collect`. Kemudian, diilustrasikan `closure` sederhana yang menangkap nilai dari lingkungannya. Bagian _pattern matching_ lanjutan menunjukkan `if let` dan berbagai pola `match` yang kuat, termasuk _match guards_ dan `@ bindings`.

- **Terminologi Esensial & Penjelasan Detil:**

  - **Idiom Rust:** Pola umum dan cara berpikir yang digunakan oleh _developer_ Rust berpengalaman untuk menulis kode yang bersih, efisien, dan sesuai dengan filosofi bahasa.
  - **Iterator:** Sebuah _trait_ yang mendefinisikan bagaimana melewati urutan item. `Iterator` menyediakan metode seperti `next()` untuk mendapatkan elemen berikutnya.
  - **Iterator Adaptors/Combinators:** Metode pada _iterators_ yang memungkinkan Anda mengubah atau mengolah _iterator_ lain (misalnya, `map`, `filter`, `fold`, `collect`).
  - **Closures:** Fungsi anonim yang dapat menangkap (menyimpan dan mengakses) nilai-nilai dari _scope_ di mana mereka didefinisikan. Mereka sangat fleksibel dan sering digunakan sebagai argumen untuk fungsi lain.
  - **Pattern Matching:** Mekanisme yang memungkinkan Anda membandingkan nilai terhadap pola dan menjalankan kode yang berbeda tergantung pada pola mana yang cocok.
  - **`match` expression:** Konstruksi kontrol alir utama untuk _pattern matching_. Ini mengharuskan semua kasus ditangani (menyeluruh).
  - **`if let`:** Sintaks yang lebih ringkas untuk menangani satu pola `match` dan mengabaikan semua yang lain.
  - **`while let`:** Mirip dengan `if let` tetapi digunakan dalam _loop_ untuk memproses elemen selama pola cocok.
  - **Match Guards:** Kondisi `if` tambahan yang dapat ditambahkan ke lengan `match` untuk menyaring kecocokan lebih lanjut.
  - **`@` Bindings:** Pola yang memungkinkan Anda menangkap nilai yang cocok dengan pola sekaligus menguji bagian dari nilai tersebut.

- **Struktur Pembelajaran Internal (Daftar Isi):**

  - Memahami Idiom Rust
  - Iterators: Kekuatan Pemrosesan Data Fungsional
    - Trait `Iterator` dan `IntoIterator`
    - Metode Iterator Adaptor (misalnya, `map`, `filter`, `flat_map`, `zip`)
    - Metode Konsumsi Iterator (misalnya, `sum`, `collect`, `count`, `for_each`)
  - Closures: Fungsi Anonim yang Fleksibel
    - Definisi dan Sintaks Closures
    - Lingkungan Penangkapan (Borrowing, Moving)
    - `Fn`, `FnMut`, `FnOnce` Traits (bagaimana _closures_ menangkap nilai)
  - Pattern Matching Lanjutan
    - `if let` dan `while let`
    - Pola dalam `match` Expression (literals, named variables, `_`, `..=`)
    - Struct dan Enum Destructuring
    - Match Guards
    - `@` Bindings
  - Pola Desain Umum di Rust (misalnya, _Newtype Pattern_, _Builder Pattern_, _Strategy Pattern_ dengan _Traits_)
  - Refactoring Kode ke Idiom Rust
  - Pengantar ke _Testing_ dan _Benchmarking_ (jika belum dibahas secara mendalam)

- **Rekomendasi Visualisasi:**
  Diagram alir yang menunjukkan bagaimana _iterator_ diproses melalui rantai _adaptor_ dan akhirnya dikonsumsi. Ilustrasi bagaimana _closures_ menangkap lingkungan mereka (dengan meminjam atau memindahkan _ownership_). Diagram yang menunjukkan bagaimana _pattern matching_ dapat mendekomposisi struktur data yang kompleks.

- **Hubungan dengan Modul Lain:**
  Pola desain dan idiom yang dibahas di sini akan diterapkan di seluruh basis kode Rust Anda. Pemahaman yang kuat tentang _traits_ (Modul 2.3) dan _ownership_ (Modul 1.3) sangat penting untuk memanfaatkan _iterators_ dan _closures_ secara efektif.

- **Sumber Referensi Lengkap:**

  - **The Rust Programming Language - Iterators and Closures:** [https://doc.rust-lang.org/book/ch13-00-closures-and-iterators.html](https://www.google.com/search?q=https://doc.rust-lang.org/book/ch13-00-closures-and-iterators.html)
  - **The Rust Programming Language - Pattern Matching:** [https://doc.rust-lang.org/book/ch18-00-patterns.html](https://doc.rust-lang.org/book/ch18-00-patterns.html)
  - **Rust by Example - Closures:** [https://doc.rust-lang.org/rust-by-example/fn/closures.html](https://doc.rust-lang.org/rust-by-example/fn/closures.html)
  - **Rust by Example - Iterators:** [https://doc.rust-lang.org/rust-by-example/std_misc/iter.html](https://www.google.com/search?q=https://doc.rust-lang.org/rust-by-example/std_misc/iter.html)

- **Tips dan Praktik Terbaik:**

  - Manfaatkan kekuatan _iterators_ dan _closures_ untuk menulis kode yang lebih fungsional, ringkas, dan ekspresif.
  - Gunakan _pattern matching_ secara ekstensif; ini adalah salah satu fitur paling kuat di Rust untuk mengontrol alur program dan mengekstrak data.
  - Selalu pertimbangkan _error handling_ yang idiomatik (Modul 2.1) saat mendesain pola Anda.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Kesalahan _ownership_ saat _closure_ mencoba menangkap nilai dengan cara yang tidak sesuai (misal: menangkap _mutable reference_ padahal _closure_ perlu hidup lebih lama dari referensi tersebut).
    **Solusi:** Gunakan kata kunci `move` pada _closure_ (`move || { ... }`) untuk memaksa _ownership_ dari nilai-nilai yang ditangkap pindah ke _closure_.
  - **Kesalahan:** Lupa mengonsumsi _iterator_ (misalnya, dengan `collect()`, `sum()`, `for_each()`) setelah menerapkan _adaptor_, sehingga tidak ada efek yang terlihat.
    **Solusi:** Ingat bahwa _iterators_ bersifat _lazy_; mereka tidak melakukan pekerjaan sampai dikonsumsi.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
