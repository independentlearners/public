
# Pemrograman Berorientasi Objek (OOP)

---

## 1. Pengertian inti

OOP adalah paradigma pemrograman yang memodelkan program sebagai kumpulan *objek*—entitas yang **membundel data (state/atribut)** dan **perilaku (method/operasi)**—serta interaksi antar-objek melalui pemanggilan pesan/metode. Fokusnya adalah pada **abstraksi data**, **enkapsulasi** perilaku di dalam objek, dan **hubungan tipe** yang memungkinkan reuse dan substitusi. ([Wikipedia][1])

---

## 2. Sejarah singkat (asal-usul konseptual)

Konsep objek modern berakar pada bahasa **Simula** (1960-an; Nygaard & Dahl) yang memperkenalkan kelas dan instance sebagai alat simulasi, lalu berevolusi menjadi model murni di **Smalltalk** (Xerox PARC, Alan Kay) yang menekankan gaya pemrograman berbasis pesan. Perkembangan ini membentuk fitur OOP klasik yang banyak bahasa adopsi. ([cs.cmu.edu][2])

---

## 3. Empat pilar klasik OOP (definisi praktis)

1. **Encapsulation (Enkapsulasi / information hiding)**

   * Mengumpulkan data dan fungsi yang bekerja pada data itu dalam satu unit (objek/kelas) dan membatasi akses langsung dari luar melalui mekanisme visibilitas. Tujuan: mengurangi coupling, mengizinkan perubahan internal tanpa merusak klien. ([Wikipedia][1])

2. **Abstraction (Abstraksi)**

   * Menyajikan antarmuka yang relevan dan menyembunyikan detail implementasi; objek merepresentasikan konsep domain dengan operasinya, bukan implementasi memori.

3. **Inheritance (Pewarisan / Subtyping)**

   * Mekanisme membentuk tipe baru berdasarkan tipe yang sudah ada (kelas turunan / subclass), mewarisi struktur dan perilaku, memungkinkan reuse dan pembentukan hierarki tipe. Implementasinya berbeda (class-based vs prototype-based). ([Wikipedia][3])

4. **Polymorphism (Polimorfisme)**

   * Kemampuan untuk memperlakukan instance dari tipe yang berbeda melalui antarmuka bersama; realisasi umum: subtype polymorphism (dynamic dispatch) — mekanisme resolve pemanggilan metode pada waktu runtime. ([Wikipedia][1])

> Catatan: Daftar “pilar” berbeda antar sumber; beberapa sumber menambahkan message passing, state, atau dynamic dispatch sebagai inti.

---

## 4. Class vs Object vs Interface vs Prototype — terminologi penting

* **Class**: cetak-biru yang mendefinisikan atribut dan metode.
* **Object (instance)**: realisasi runtime dari class; memiliki state tersendiri.
* **Interface / Abstract class**: kontrak yang menjamin keberadaan metode tanpa implementasi penuh (dipakai untuk polymorphism dan decoupling).
* **Prototype**: model alternatif (prototype-based) di mana objek diturunkan langsung dari objek lain tanpa class formal.

Perbedaan ini penting untuk desain bahasa (mis. apakah bahasa memerlukan compiler/jit untuk kelas atau cukup prototipe dinamis).

---

## 5. Mekanisme pemanggilan metode dan dispatch (implikasi run-time)

* **Static (early) binding**: pemanggilan metode diselesaikan saat kompilasi/link time — lebih cepat, tanpa lookup runtime.
* **Dynamic (late) binding / dynamic dispatch**: pemanggilan metode diselesaikan pada runtime berdasarkan tipe nyata objek; sering direalisasikan dengan *vtable/vptr* (virtual table pointer) atau teknik lookup dinamis. Mekanisme ini memengaruhi layout objek di memori, overhead pemanggilan, dan kemampuan optimisasi (devirtualization, inlining). ([Medium][4])

---

## 6. Model memori dan lifecycle objek

* **Heap vs Stack**: objek biasanya dialokasikan di heap (lifetime dinamis); variabel lokal/parameter di stack. Frame aktivasi memegang referensi ke objek.
* **Activation record**: berisi data pemanggilan fungsi/metode — penting untuk memahami rekursi, closure, dan lifetime.
* **Manajemen memori**: sebagian besar runtime OOP modern menggunakan garbage collection (GC) atau reference counting; strategi GC (mark-sweep, generational, concurrent) memiliki trade-offs latensi dan throughput. Pemilihan strategi memengaruhi determinisme perilaku aplikasi dan desain API (mis. finalizer/destructor semantics).

---

## 7. Type system, subtyping, dan Liskov Substitution Principle (LSP)

* **Tipe statis vs dinamis**: bahasa OOP dapat statically-typed (Java, C#) atau dynamically-typed (Smalltalk, Ruby). Sistem tipe menentukan apa yang dapat diserahkan dan bagaimana optimisasi dilakukan.
* **Subtyping vs subclassing**: subclassing adalah mekanisme reuse; subtyping adalah relasi tipe logis. Mereka sering berasosiasi tetapi tidak selalu identik.
* **Liskov Substitution Principle**: aturan desain penting—subtype harus bisa menggantikan supertype tanpa mengubah kebenaran program; pelanggaran LSP menimbulkan bug desain yang sulit dideteksi.

---

## 8. Composition vs Inheritance (komposisi lebih disarankan ketika)

* **Inheritance** memberi reuse dan polymorphism tetapi cenderung menghasilkan coupling kuat dan hierarki yang rapuh.
* **Composition (has-a)** mendorong delegasi dan fleksibilitas; banyak praktek desain modern merekomendasikan “favor composition over inheritance.” Desain pattern seperti Strategy, Decorator, Adapter menggunakan komposisi. ([Wikipedia][5])

---

## 9. Design patterns dan praktik arsitektural

* Buku *Design Patterns* (Gamma et al., “Gang of Four”) adalah referensi klasik untuk solusi desain OOP yang teruji (Factory, Singleton, Observer, Strategy, dll.). Pola ini membantu menyusun solusi reuse dan pengurangan coupling. ([Wikipedia][5])

---

## 10. Kelebihan OOP (kapan OOP unggul)

* Memodelkan domain kompleks lewat objek yang menyatukan state dan perilaku (natural mapping ke dunia nyata).
* Reuse melalui inheritance dan polymorphism; modularitas melalui encapsulation.
* Ekosistem tooling (IDE, refactoring, UML, static analysis) matang untuk bahasa OOP populer.

---

## 11. Kelemahan & kritik — aspek yang perlu diwaspadai

* Potensi over-engineering: kecenderungan membuat hierarki tipe terlalu dalam atau menekan algoritme menjadi kelas tak perlu. Kritik dari beberapa tokoh industri: OOP dapat mengaburkan alur kontrol dan membuat reasoning terhadap state lebih sulit. ([Wikipedia][1])
* Efek samping/state mutable menyulitkan reasoning formal, testing, dan concurrency (race conditions).
* Inheritance yang salah dapat menyebabkan fragile base class problem; scaling codebase besar memerlukan disiplin desain.

---

## 12. Implikasi untuk concurrency dan paralelisme

Model OOP yang menekankan shared mutable state memerlukan mekanisme sinkronisasi (locks, atomics) atau pola tanpa shared state (immutable objects, actor model) untuk mengurangi race condition dan deadlock. Pilihan tersebut mempengaruhi API objek dan desain sistem berskala besar.

---

## 13. Jika Anda ingin *memodifikasi* atau *membangun* bahasa/implementasi OOP — persyaratan teknis dan pengetahuan

Berikut daftar kemampuan, teori, dan alat praktis yang diperlukan bila tujuan Anda adalah mengembangkan atau memperluas bahasa OOP (compiler, VM, atau runtime):

### Pengetahuan teoretis wajib

* **Teori bahasa pemrograman**: grammars (BNF), parsing (LL/LR), semantik formal, type theory (subtyping, variance).
* **Compiler design**: lexer, parser, AST, semantic analysis, type checking, IR (intermediate representation), optimisasi.
* **Runtime systems**: memory model, heap layout, object layout (field order, padding), garbage collection algorithms (generational, concurrent), finalization semantics.
* **Method dispatch & ABI**: implementasi vtable, vptr, inline cache, devirtualization; serta calling convention untuk interoperabilitas native.
* **JIT compilation** (jika ditargetkan): tracing/JIT techniques, hot-spot identification, OS/arch specifics.

### Alat & libraries yang relevan

* **Front-end/Back-end**: LLVM (codegen/optimisasi), atau target VM (JVM, CLR) untuk portability.
* **Parser tools**: ANTLR, flex/bison, atau recursive-descent manual.
* **Profiling & debugging**: gdb/lldb, perf, custom runtime profilers.
* **GC implementations**: memahami dan menggunakan referensi seperti HotSpot/G1/GC implementations research.

### Pengalaman praktis berguna

* Membangun interpreter sederhana (AST walker) dan kemudian compiler ke IR/bytecode.
* Implementasi prototype vtable dan dispatch untuk memahami overhead dan optimisasi (inline caches, polymorphic inline caches).
* Pengujian stress/benchmarking untuk memastikan stabilitas runtime dan performa.

Ringkasnya: untuk **mengembangkan** implementasi OOP Anda **perlu** menguasai compiler/runtime/GClogic, ABI/assembly, serta teknik optimisasi JIT/compiled. ([Medium][4])

---

## 14. Praktik desain & checklist engineering (ringkasan tindakan)

* Terapkan enkapsulasi ketat: batasi state publik; gunakan invariants dan kontrak (pre/post conditions).
* Gunakan interface/kontrak untuk decoupling; hindari pewarisan yang memaksakan implementasi.
* Pilih komposisi bila memungkinkan; gunakan pola desain saat diperlukan.
* Lengkapi kode OOP dengan suite tes unit dan tes integrasi yang memeriksa state dan invariants.
* Untuk performa: identifikasi titik hot-path dan periksa biaya dynamic dispatch; pertimbangkan devirtualization atau caching bila diperlukan.

---

## 15. Sumber & bacaan lanjutan (validasi konsep)

* *Object-oriented programming*, Wikipedia (ringkasan konsep dan fitur). ([Wikipedia][1])
* Sejarah objek: Simula & Smalltalk — ringkasan sejarah dan evolusi konsep. ([cs.cmu.edu][2])
* *Design Patterns: Elements of Reusable Object-Oriented Software* (Gamma, Helm, Johnson, Vlissides) — kumpulan pola desain klasik. ([Wikipedia][5])
* Artikel teknis tentang dynamic dispatch, vtable, dan implementasinya (penjelasan vptr/vtable). ([Medium][4])

---

[1]: https://en.wikipedia.org/wiki/Object-oriented_programming?utm_source=chatgpt.com "Object-oriented programming"
[2]: https://www.cs.cmu.edu/~charlie/courses/15-214/2014-fall/slides/25-history-oo.pdf?utm_source=chatgpt.com "OO History: Simula and Smalltalk"
[3]: https://en.wikipedia.org/wiki/Inheritance_%28object-oriented_programming%29?utm_source=chatgpt.com "Inheritance (object-oriented programming)"
[4]: https://medium.com/%40satyadirisala/demystifying-dynamic-dispatch-a-deep-dive-into-virtual-functions-vptr-and-vtable-9574c1ad9bed?utm_source=chatgpt.com "A Deep Dive into Virtual Functions, vptr, and vtable"
[5]: https://en.wikipedia.org/wiki/Design_Patterns?utm_source=chatgpt.com "Design Patterns"
