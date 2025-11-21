# Pemrograman Fungsional

---

## 1. Pengertian Inti

Pemrograman fungsional merupakan paradigma yang mendasarkan seluruh komputasi pada **fungsi** dalam pengertian **matematis** (fungsi pada kalkulus lambda), yaitu pemetaan dari input ke output **tanpa efek samping**. State dianggap **immutable**, dan flow program digambarkan sebagai *komposisi fungsi-fungsi*.

Inti fundamental:

1. **Fungsi adalah entitas utama (first-class citizens)**.
2. **Pure function**: hasil hanya ditentukan dari argumen, tanpa mengubah keadaan global.
3. **Immutable data**: tidak ada mutasi variabel; semua data bersifat tetap dan setiap transformasi menghasilkan data baru.
4. **Referential transparency**: ekspresi dapat diganti dengan nilainya tanpa mengubah makna program. Ini yang memampukan reasoning matematis terhadap kode.

Paradigma ini lahir dari teori kalkulus lambda (Alonzo Church) yang menjadi dasar ilmu komputasi secara formal.

---

## 2. Landasan Teori: Lambda Calculus

Semua ekspresi fungsional dapat direduksi menjadi bentuk matematis yang sangat kecil:

* Fungsi
* Variabel
* Aplikasi fungsi terhadap argumen

Semantik program adalah **hasil reduksi ekspresi**. Tidak ada konsep state berbasis waktu atau mutasi memori. Inilah alasan paradigma fungsional cocok untuk pembuktian kebenaran formal dan reasoning mekanistik.

---

## 3. Karakteristik Fundamental

### A. First-class dan Higher-order Functions

Fungsi dapat diperlakukan sama seperti data lain: disimpan dalam variabel, dikirim sebagai argumen, dikembalikan oleh fungsi lain.
Higher-order functions memungkinkan abstraksi alur operasi (bukan hanya sekadar data).

### B. Immutability

Tidak ada shared mutable state. Data tidak berubah setelah diciptakan; jika ingin nilai baru, dibuat salinan dengan perubahan yang diinginkan.
Konsekuensi positif:

* Aman terhadap race condition dalam concurrency.
* Mudah di-cache (memoization).

### C. Pure Function dan Referential Transparency

Konsekuensi utama:

* Tidak ada efek samping seperti I/O, mutasi, global state.
* Testing menjadi lebih mudah karena fungsi dapat diuji secara deterministik.

### D. Lazy Evaluation (opsional, implementasi khusus)

Evaluasi dilakukan hanya ketika nilai benar-benar dibutuhkan.
Manfaat: efisiensi, representasi tak hingga (lazy sequences).

---

## 4. Tipe Data Aljabar dan Rekursi

Karena tidak ada loop imperatif yang mengubah state, perulangan direpresentasikan dalam bentuk rekursi dengan tipe data terstruktur:

1. **Algebraic Data Type (ADT)**:

   * Product type (gabungan struktur data: record/tuple)
   * Sum type (pilihan: union/variant)

2. **Pattern Matching**:
   Teknik untuk melakukan dekomposisi nilai berdasarkan bentuk struktur data.

Rekursi adalah bentuk utama iterasi, yang berasosiasi kuat dengan reasoning matematis (induksi).

---

## 5. Side Effect — Pendekatan Monadic dan Effect System

Bahasa fungsional tetap perlu menangani I/O, log, network, dsb. Untuk itu digunakan **kontainer efek**:

* **Monad**: struktur komposisi untuk side effect yang aman secara tipe.
* **Functor** dan **Applicative**: generalisasi komposisi fungsi.

Teknik ini memaksa efek diekspresikan secara eksplisit, tidak tersembunyi seperti pada OOP atau imperatif. Maka, program lebih mudah dianalisis dan diverifikasi.

---

## 6. Concurrency dan Paralelisme

Tanpa shared mutable state, pemrograman fungsional sangat cocok untuk:

* Pemrosesan paralel
* Pemrosesan data besar (distributed computing)
* Arsitektur multi-core / SIMD

Compiler dapat mengoptimalkan eksekusi paralel tanpa risiko race condition yang rumit.

---

## 7. Paradigma Fungsional vs Paradigma OOP dan Imperatif

| Aspek       | Fungsional               | OOP                         | Imperatif        |
| ----------- | ------------------------ | --------------------------- | ---------------- |
| Data        | Immutable                | Mutable (sering)            | Mutable          |
| State       | Dihindari                | Inti model                  | Inti model       |
| Kontrol     | Rekursi, komposisi       | Message passing antar objek | Loop & branching |
| Abstraksi   | Higher-order functions   | Class dan inheritance       | Prosedur         |
| Concurrency | Lebih aman               | Rumit (locks)               | Rumit            |
| Reasoning   | Matematis, deterministik | Bergantung state            | Bergantung state |

Kesimpulan: Fungsional unggul untuk **keandalan, concurrency, dan analisis formal**, namun kadang dianggap kurang intuitif bagi pemula karena pola berpikirnya tidak berbasis state.

---

## 8. Kekurangan dan Tantangan

* Kinerja dapat menurun karena pembuatan objek baru tiap transformasi (meskipun compiler modern menggunakan optimisasi memori yang agresif seperti persistent data structures).
* Kompleksitas memahami konsep abstrak seperti monad, lazy evaluation, dan type system lanjutan.
* Tidak semua masalah cocok dimodelkan tanpa mutasi (meskipun ada teknik bridging).

---

## 9. Untuk Mengembangkan Bahasa / Runtime Fungsional — Persyaratan Teknis

Jika Anda ingin membangun interpreter/VM untuk paradigma fungsional, Anda perlu:

### Kompetensi Teoretis

* Lambda calculus, teori kategori (Functor, Monad)
* Strong static typing dan inference (Hindley-Milner)
* Algebraic data types dan dependent types (opsional)

### Kompetensi Implementasi

* Compiler design: parsing, type inference, IR, optimisasi rekursi (tail-call optimization)
* Garbage collection: persistent/immutable structure optimization
* Lazy vs strict evaluation strategy
* Runtime untuk concurrency tanpa shared state (misalnya actor model)

### Tools/Framework Relevan

* LLVM untuk code generation
* Parser generators (ANTLR, dll.)
* Model runtime actor system (Erlang, Akka) bila efek concurrency diperlukan

Implementasi paling rumit adalah **type inference** dan **lazy evaluation**, karena mempengaruhi keseluruhan pipeline kompilasi dari semantic checking hingga runtime behavior.

---

## 10. Konteks Arsitektur Modern

Pemrograman fungsional kini digunakan sebagai solusi berdaya besar untuk:

* Sistem yang harus **highly reliable** (telekomunikasi, keuangan)
* Sistem **parallel dan distributed** (HPC, map-reduce, streaming)
* Sistem **data transformation** (compiler, data pipelines)
* Domain AI tertentu yang membutuhkan reasoning formal

Perpaduan paradigma menjadi umum: banyak bahasa OOP modern mengadopsi fitur fungsional demi robust dan concurrent safety.

---

## 11. Ringkasan Praktis

Inti manfaat pemrograman fungsional:

* Mengurangi bug karena state minim.
* Mempermudah concurrency dan parallelism.
* Mendukung analisis formal dan correctness tinggi.
* Mendorong desain program yang modular dan deklaratif.

Inti tantangan:

* Kurva belajar tinggi
* Model pemrosesan berbeda dari intuisi imperatif
* Pengelolaan memori harus dioptimalisasi dengan teknik lanjutan

---
<!---->
<!-- Jika Anda ingin, saya bisa lanjutkan dengan salah satu arah berikut: -->
<!---->
<!-- 1. **Peta kompetensi lengkap** untuk menjadi ahli bahasa fungsional (dasar matematika → compiler → runtime). -->
<!-- 2. **Perbandingan rinci** antara tiga paradigma besar: Imperatif, OOP, Fungsional (fokus pada implementasi memori dan dispatch). -->
<!-- 3. **Pendalaman teori**: kalkulus lambda, monad, dan dependent types dengan alur studi bertahap. -->
<!-- 4. Melanjutkan topik dengan **paradigma gabungan** (multi-paradigm programming) yang relevan dengan pengembangan bahasa modern. -->
<!---->
<!-- Silakan pilih jalur yang ingin Anda dalami selanjutnya. -->
