# **Pemrograman Reactive**

---

## 1. Pengertian ringkas — dua lapis makna

* **Reactive Programming** (pada level library/DSL) adalah gaya pemrograman berbasis *stream* dan *event* di mana komputasi dipandang sebagai aliran nilai/ kejadian yang dapat diproses secara deklaratif melalui operator—dengan model push dari sumber ke konsumen. ([reactivex.io][1])
* **Reactive Systems** (arsitektur) adalah pendekatan membangun sistem yang *responsive, resilient, elastic, dan message-driven* — prinsip-prinsip ini dirangkum dalam *Reactive Manifesto*. Perbedaan penting: reactive programming adalah teknik; reactive systems adalah arsitektur yang menerapkan teknik-teknik itu di skala. ([reactivemanifesto.org][2])

---

## 2. Prinsip arsitektural yang sering dikaitkan

Reactive systems — titik tekan arsitektur yang relevan untuk praktik reactive:

* **Responsive** — sistem harus cepat merespons permintaan.
* **Resilient** — kegagalan diisolasi dan sistem tetap beroperasi.
* **Elastic** — dapat autoscale sesuai beban.
* **Message-driven** — komunikasi antar-komponen lewat pesan asinkron. ([reactivemanifesto.org][2])

---

## 3. Konsep teknis inti (operasional)

### 3.1 Stream & Observables / Publishers

* Sumber data/kejadian direpresentasikan sebagai *stream* (sequence over time). Implementasi umum di library modern memakai istilah `Observable` / `Publisher` / `Flux` / `Mono`. Konsumen mendaftar untuk menerima elemen secara push. ([reactivex.io][1])

### 3.2 Push model vs Pull model

* Reactive umumnya *push-based*: sumber mendorong nilai ke subscriber. Untuk interoperabilitas dengan APIs pull-based, ada pola adaptasi. Perhatian pada kontrol laju (lihat backpressure).

### 3.3 Backpressure (demand management)

* Masalah klasik: producer dapat menghasilkan lebih cepat daripada consumer bisa memproses. **Reactive Streams** adalah spesifikasi yang menstandarisasi protokol non-blocking untuk *backpressure* di JVM dan ekosistemnya. Ini memungkinkan consumer memberi sinyal permintaan (demand) agar producer tidak membanjiri. ([reactive-streams.org][3])

### 3.4 Operators / Composition

* Stream diolah dengan operator deklaratif (map, filter, flatMap, window, reduce, buffer, debounce, throttle, dsb.). Operator ini bersifat composable dan fungsional; implikasinya: pipeline yang sangat modular dan dapat dioptimisasi. ([reactivex.io][1])

### 3.5 Hot vs Cold streams

* **Cold**: setiap subscriber memulai eksekusi/produksi sendiri (mis. read file per-subscriber).
* **Hot**: sumber yang sudah menghasilkan tanpa memperdulikan subscriber—dapat memerlukan multicasting atau sharing. Perbedaan ini penting untuk semantics dan resource management. ([reactivex.io][1])

### 3.6 Concurrency, Scheduling, dan Threading

* Pustaka reactive menyediakan *schedulers/executors* untuk mengontrol pada thread mana operator dieksekusi; ini memberi fleksibilitas untuk memetakan pipeline ke I/O non-blocking, thread pool, atau event loop. Pemisahan concerns I/O vs CPU penting untuk performa. ([Home][4])

### 3.7 Error handling & termination

* Pipeline reactive punya model error propagation tersendiri (error channel yang menyetop stream, atau operator yang mengubah/mereset aliran). Desain yang tepat terhadap retry, fallback, dan timeout sangat penting.

---

## 4. Ekosistem — identitas implementasi & bahasa (singkat, teknis)

> Di bawah ini setiap item menyertakan **identitas** (apa itu), **bahasa implementasi utama**, dan **apa yang Anda perlukan untuk mengubah / memodifikasinya**.

1. **ReactiveX (Reactive Extensions)** — library generik untuk menyusun program asynchronous/berbasis event lewat *observable sequences*. Implementasi multi-bahasa (RxJS, RxJava, Rx.NET, RxPY, dsb.). Asal-usul: Microsoft membuat Rx untuk .NET, lalu berkembang menjadi ekosistem ReactiveX. ([reactivex.io][1])

   * *Bahasa implementasi utama*: bervariasi per implementasi — mis. **RxJS** (JavaScript/TypeScript), **RxJava** (JVM/Java).
   * *Untuk memodifikasi*: kuasai bahasa target (JS/TS atau Java), toolchain (npm/Node atau Maven/Gradle), testing, serta pemahaman lifecycle Observable & operators. ([reactivex.io][1])

2. **RxJava** — Reactive Extensions untuk JVM; pustaka populer untuk Reactive Programming di Java/Android. ([GitHub][5])

   * *Bahasa implementasi*: Java (JVM).
   * *Untuk memodifikasi/kontribusi*: Java 8+ knowledge, Gradle/Maven, JUnit/Test frameworks, pemahaman concurrency JVM, dan cara kerja backpressure di RxJava.

3. **Project Reactor** — pustaka reactive untuk JVM dari Pivotal/Spring, menyediakan `Flux` (N elemen) dan `Mono` (0|1 elemen); kompatibel dengan Reactive Streams. Umum dipakai di Spring WebFlux. ([projectreactor.io][6])

   * *Bahasa*: Java (JVM), API Java 8+ dengan integrasi fungsional.
   * *Untuk modifikasi*: Java, build (Maven/Gradle), memahami Reactive Streams TCK, dan performance testing.

4. **Reactive Streams (spec / TCK)** — spesifikasi untuk asinkron stream processing dengan non-blocking backpressure (JVM focus), menyediakan TCK (Technology Compatibility Kit) untuk verifikasi implementasi. ([reactive-streams.org][3])

   * *Bahasa implementasi referensi*: Java/Scala pada repositori resmi.
   * *Untuk kontribusi*: pemahaman protokol request(n)/cancel/error, JVM low-level concurrency, dan menjalankan TCK.

5. **RxJS** — implementasi ReactiveX untuk JavaScript/TypeScript; sering dipakai di frontend (Angular) dan Node.js. ([reactivex.io][1])

   * *Bahasa*: JavaScript / TypeScript.
   * *Untuk modifikasi*: TypeScript knowledge, bundler/tooling (webpack/rollup), npm, test tooling, dan pemahaman runtime (browser event loop / Node.js event loop).

6. **Akka Streams / Alpakka** — toolkit reactive (Scala/Java) yang mendukung backpressure, built on top of Actors (Lightbend). Cocok untuk streaming dan integrasi dengan ekosistem Akka. (sejarah dan kontributor awal tercantum pada dokumen Reactive Streams). ([Wikipedia][7])

---

## 5. Kapan reactive tepat — keunggulan praktis

* **I/O-bound, high-concurrency workloads**: server yang melayani ribuan koneksi tanpa thread-per-connection.
* **Data streaming / pipeline**: ETL streaming, event sourcing, realtime analytics.
* **Reactive UIs / frontend**: model data-driven UI yang merespon stream perubahan.
* **Sistem terdistribusi**: message-driven arsitektur, microservices event streams.
  Keunggulan utama: efisiensi sumber daya (non-blocking), kemampuan expressiveness pipeline, dan model yang lebih mudah diparalelkan. ([Home][4])

---

## 6. Risiko, tantangan, dan jebakan praktis

* **Kurva belajar**: paradigma berbeda (thinking in streams, asynchrony, lifecycle of subscriptions).
* **Debugging & observability**: stack traces dan timing bugs sulit; butuh tracing, logging, dan virtual-time testing.
* **Resource leaks**: subscriber/stream yang tidak dibatalkan bisa menyebabkan memory leak.
* **Kesalahan pemakaian backpressure**: jika tidak di-manage, dapat menyebabkan OOM atau throttling tak terduga.
* **Over-abstraction**: pipeline kompleks bisa jadi sulit dipahami jika operator disusun berlapis.

---

## 7. Jika Anda ingin **mengembangkan** pustaka / runtime reactive sendiri — checklist teknis

### Pengetahuan dan teori

* Asynchronous I/O models & event loops (epoll/kqueue/io_uring untuk native; libuv/Node model; browser event loop).
* Concurrency primitives di platform target (threads, executors, actor model).
* Protokol backpressure dan flow control (mengerti bagaimana consumer menyatakan demand). ([reactive-streams.org][3])
* Semantik stream (hot vs cold, multicast, buffering, windowing).
* Bahasa target dan toolchain (C/C++, Java/Scala, JavaScript/TypeScript, Rust, dsb.).

### Komponen implementasi

* **Core API**: type Publisher/Subscriber/Subscription (atau Observable/Observer) dan model lifecycle.
* **Operator library**: transformasi dasar dan komposisi (map/flatMap/filter/buffer/merge/zip).
* **Scheduler/Execution**: definisi lokasi eksekusi operator (event loop, IO pool, compute pool).
* **Backpressure strategy**: request(n), buffering, dropping, latest, error signaling.
* **Testing harness**: simulasi virtual time, TCK (untuk JVM: Reactive Streams TCK). ([GitHub][8])

### Tools & workflow

* Build system (Gradle/Maven untuk JVM; npm/tsc for TypeScript; cargo for Rust).
* CI, benchmarks (JMH untuk JVM), profiling tools.
* Conformance tests (TCK), interoperability tests dengan pustaka lain.

---

## 8. Rekomendasi pembelajaran & resources singkat

1. **Baca Reactive Manifesto** (arsitektur & prinsip). ([reactivemanifesto.org][2])
2. **Pelajari ReactiveX docs** untuk pola operator dan mental model Observables. ([reactivex.io][1])
3. **Pelajari Reactive Streams spec** bila menargetkan JVM dan butuh standar backpressure. ([reactive-streams.org][3])
4. **Eksplorasi implementasi**: RxJS (frontend), RxJava / Reactor (backend JVM) untuk praktik. ([GitHub][5])

---

## 9. Ringkasan praktis (1-paragraf)

Reactive = berpikir dalam *aliran kejadian* (streams) + memprosesnya secara deklaratif dengan operator, sambil menuntaskan masalah klasik *flow control* melalui backpressure; di level arsitektur, reactive systems menuntut message-driven, resilient, elastic, dan responsive design. Untuk menjadi praktisi atau pengembang pustaka reactive, Anda perlu menguasai model asinkron platform target, teori backpressure, desain operator composable, serta infrastruktur testing dan observability. ([reactivex.io][1])

---

[1]: https://reactivex.io/intro.html?utm_source=chatgpt.com "ReactiveX - Intro"
[2]: https://www.reactivemanifesto.org/?utm_source=chatgpt.com "The Reactive Manifesto"
[3]: https://www.reactive-streams.org/?utm_source=chatgpt.com "Reactive Streams"
[4]: https://docs.spring.io/projectreactor/reactor-core/docs/3.7.0-M3/reference/html/gettingStarted.html?utm_source=chatgpt.com "Getting Started :: Reactor Core Reference Guide - Spring"
[5]: https://github.com/ReactiveX/RxJava?utm_source=chatgpt.com "RxJava – Reactive Extensions for the JVM"
[6]: https://projectreactor.io/docs/core/release/api/overview-summary.html?utm_source=chatgpt.com "Overview (reactor-core 3.8.0)"
[7]: https://en.wikipedia.org/wiki/Reactive_Streams?utm_source=chatgpt.com "Reactive Streams"
[8]: https://github.com/reactive-streams/reactive-streams-jvm?utm_source=chatgpt.com "Reactive Streams Specification for the JVM"
