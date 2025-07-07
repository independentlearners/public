> [flash][pro12]

# **[FASE 12: Advanced Architectural Patterns][0]**

Fase ini akan memperkenalkan Anda pada pola-pola arsitektur tingkat lanjut yang esensial untuk membangun aplikasi kelas _enterprise_ yang mudah di-_maintain_, diuji, dan diskalakan.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[19. Enterprise Architecture Patterns](#19-enterprise-architecture-patterns)**
  - [19.1 Clean Architecture](#191-clean-architecture)
    - Domain-Driven Design
    - Entity dan value objects
    - Domain services
    - Repository pattern
    - Use cases implementation
    - Dependency inversion
    - Clean Architecture Flutter
    - Domain-Driven Design
    - Layered Architecture
    - Presentation layer
    - Domain layer
    - Data layer
    - Infrastructure layer
    - Dependency injection
    - Layered Architecture
  - [19.2 Microservices Integration](#192-microservices-integration)
    - API Gateway Pattern
    - Service discovery
    - Load balancing
    - Circuit breaker pattern
    - Rate limiting
    - Authentication gateway
    - API Gateway Pattern
    - Event-Driven Architecture
    - Event sourcing
    - CQRS pattern
    - Message queues
    - Event streaming
    - Saga pattern
    - Event-Driven Architecture
  - [19.3 Dependency Injection](#193-dependency-injection)
    - Get_it Service Locator
    - Service registration
    - Singleton vs factory
    - Scoped instances
    - Lazy loading
    - Service disposal
    - Get_it Package
    - Service Locator Pattern
    - Injectable Code Generation
    - Annotation-based DI
    - Module configuration
    - Environment-specific setup
    - Testing configuration
    - Injectable Package
    - Injectable Generator

</details>

---

### **19. Enterprise Architecture Patterns**

- **Peran:** Pola arsitektur _enterprise_ adalah desain struktural dan perilaku yang telah terbukti untuk mengembangkan aplikasi berskala besar, kompleks, dan _mission-critical_. Pola-pola ini membantu mengelola kompleksitas, meningkatkan skalabilitas, kemudahan _maintenance_, dan kemampuan pengujian dalam lingkungan tim besar.

---

#### **19.1 Clean Architecture**

- **Peran:** **Clean Architecture** adalah prinsip desain perangkat lunak yang diperkenalkan oleh Robert C. Martin (Uncle Bob). Tujuannya adalah untuk membuat sistem yang independen dari _framework_, UI, _database_, atau agen eksternal mana pun. Ini dicapai dengan mengatur kode dalam lapisan-lapisan yang ketat, di mana ketergantungan hanya mengalir ke dalam (ke lapisan yang lebih inti). Ini sangat ideal untuk aplikasi kompleks yang memerlukan _maintainability_ dan kemampuan pengujian jangka panjang.

- **Prinsip Utama:**

  - **Independence of Frameworks:** Tidak ada ketergantungan pada _library_ perangkat lunak tertentu.
  - **Testability:** Logika bisnis dapat diuji tanpa UI, _database_, atau _server_ web.
  - **Independence of UI:** UI dapat diubah dengan mudah tanpa mengubah sistem lainnya.
  - **Independence of Database:** _Database_ dapat diubah dengan mudah.
  - **Independence of any external agency:** Logika bisnis tidak mengetahui dunia luar.

---

###### **Domain-Driven Design (DDD)**

- **Peran:** **Domain-Driven Design** adalah pendekatan pengembangan perangkat lunak yang berfokus pada pemodelan _core business domain_ Anda secara eksplisit dan bekerja sama erat dengan pakar _domain_ untuk membangun pemahaman bersama tentang masalah yang sedang diselesaikan. DDD seringkali menjadi dasar filosofis untuk menerapkan arsitektur seperti Clean Architecture.

- **Entity dan Value Objects:**

  - **Entity:** Objek dalam _domain_ Anda yang memiliki identitas unik dan berkelanjutan seiring waktu, terlepas dari perubahan atributnya. Contoh: `User` (memiliki ID unik), `Order` (memiliki ID pesanan unik). Meskipun atribut seperti nama pengguna atau status pesanan dapat berubah, identitas entitas tetap sama.
  - **Value Objects:** Objek yang mewakili karakteristik deskriptif dari suatu _domain_ dan tidak memiliki identitas konseptual yang unik. Mereka didefinisikan oleh nilai atributnya. Contoh: `Address` (dua alamat dianggap sama jika semua komponennya sama), `Money` (100 dolar adalah 100 dolar, tidak ada identitas unik untuk _instance_ tertentu). _Value objects_ bersifat _immutable_ (tidak dapat diubah setelah dibuat).

- **Domain Services:**

  - **Peran:** Objek yang mengimplementasikan logika _domain_ yang tidak secara alami cocok untuk menjadi bagian dari _Entity_ atau _Value Object_. Biasanya melibatkan koordinasi antara beberapa _Entity_ atau _Value Object_.
  - **Contoh:** `PaymentService` yang mengoordinasikan antara `Order` dan `CustomerAccount` untuk memproses pembayaran. `EmailService` yang mengirim email konfirmasi setelah pesanan berhasil.

- **Repository Pattern:**

  - **Peran:** Pola desain yang menyediakan abstraksi di atas lapisan penyimpanan data (misalnya, _database_, API). _Repository_ bertindak sebagai koleksi objek _domain_ di memori, menyembunyikan detail implementasi penyimpanan data dari logika _domain_ dan _use cases_.
  - **Mekanisme:** Anda mendefinisikan _interface_ `Repository` di lapisan _Domain_ (atau _Application/Use Case_), dan implementasinya berada di lapisan _Infrastructure_ (atau _Data_). Ini memungkinkan Anda mengubah mekanisme penyimpanan data tanpa memengaruhi logika bisnis Anda.
  - **Contoh:** `UserRepository` dengan metode seperti `getUserById(id)`, `saveUser(user)`, `deleteUser(id)`.

- **Use Cases Implementation (Interactors):**

  - **Peran:** Juga dikenal sebagai **Interactors** atau **Application Services**. Ini adalah kelas yang mengimplementasikan logika bisnis spesifik untuk setiap kasus penggunaan dalam aplikasi. Mereka mengoordinasikan aliran data antara _Presentation Layer_ dan _Domain Layer_, serta berinteraksi dengan _Repository_ untuk mendapatkan atau menyimpan data.
  - **Mekanisme:** Setiap _use case_ biasanya memiliki satu metode `call` atau `execute` yang mengambil input dan mengembalikan output. Mereka tidak memiliki ketergantungan pada UI atau _database_ tertentu, hanya pada _interface_ _Repository_ atau _Entity_ yang didefinisikan di _Domain Layer_.
  - **Contoh:** `LoginUserUseCase`, `CreateOrderUseCase`, `GetProductsUseCase`.

- **Dependency Inversion Principle (DIP):**

  - **Peran:** Bagian dari prinsip SOLID. Ini menyatakan bahwa modul tingkat tinggi tidak boleh bergantung pada modul tingkat rendah. Keduanya harus bergantung pada abstraksi. Abstraksi tidak boleh bergantung pada detail. Detail harus bergantung pada abstraksi.
  - **Mekanisme dalam Clean Architecture:** Lapisan luar (yang lebih konkret, seperti _Infrastructure_) bergantung pada abstraksi (interface/kontrak) yang didefinisikan di lapisan dalam (yang lebih abstrak, seperti _Domain_ atau _Use Case_). Ini memungkinkan lapisan _Domain_ tetap murni dan tidak tercemar oleh detail implementasi.

- **Sumber Daya Tambahan:**

  - [Clean Architecture Flutter](https://www.google.com/search?q=https://resocoder.com/2020/01/24/flutter-clean-architecture-tdd-resocoder/) (Sumber daya populer tentang Clean Architecture di Flutter)
  - [Domain-Driven Design](https://www.martinfowler.com/bliki/DomainDrivenDesign.html) (Gambaran umum Domain-Driven Design oleh Martin Fowler)

---

###### **Layered Architecture**

- **Peran:** Clean Architecture secara inheren adalah arsitektur berlapis, di mana setiap lapisan memiliki tanggung jawab spesifik dan aturan ketergantungan yang ketat (ketergantungan hanya boleh mengalir ke dalam). Ini membentuk "lingkaran konsentris" di mana lapisan paling inti adalah _Domain_, dan lapisan luar adalah _Infrastructure_.

- **Lapisan-Lapisan Utama (dari dalam ke luar):**

  - **1. Domain Layer (The Core):**

    - **Peran:** Berisi entitas _domain_ (aturan bisnis paling inti dan independen), _value objects_, dan _interface_ (kontrak) untuk _Repository_ dan layanan _domain_. Ini adalah inti dari aplikasi Anda yang tidak memiliki ketergantungan eksternal.
    - **Ketergantungan:** Tidak bergantung pada lapisan lain.
    - **Contoh:** Kelas `User`, `Product`, `Order`. _Interface_ `UserRepository`.

  - **2. Data Layer (Implementation of Repositories):**

    - **Peran:** Berisi implementasi konkret dari _interface Repository_ yang didefinisikan di _Domain Layer_. Lapisan ini bertanggung jawab untuk berinteraksi dengan sumber data eksternal (API REST, _database_ lokal, Firebase, dll.). Ini juga sering berisi model data (DTO - Data Transfer Objects) yang digunakan untuk komunikasi dengan _backend_ dan konverter antara model _domain_ dan model data.
    - **Ketergantungan:** Bergantung pada _Domain Layer_.
    - **Contoh:** `UserRepositoryImpl` yang mengambil data dari REST API atau SQLite. `UserApiModel` (DTO) dan fungsi `toDomain()`, `fromDomain()`.

  - **3. Presentation Layer (UI & State Management):**

    - **Peran:** Berisi UI (widget Flutter) dan logika manajemen _state_ yang terkait langsung dengan UI (misalnya, Bloc, Provider, Riverpod, BLoC Pattern). Lapisan ini bertanggung jawab untuk menampilkan data kepada pengguna dan meneruskan _event_ dari pengguna ke _Application Layer_ (Use Cases).
    - **Ketergantungan:** Bergantung pada _Application Layer_ (Use Cases) untuk logika bisnis dan _Domain Layer_ untuk model _domain_.
    - **Contoh:** `LoginPage`, `HomePage`, `UserBloc`, `ProductViewModel`.

  - **4. Infrastructure Layer (External Concerns):**

    - **Peran:** Ini kadang-kadang digabungkan dengan Data Layer atau terpisah, dan bertanggung jawab untuk menangani semua detail implementasi eksternal lainnya yang tidak langsung terkait dengan _domain_ atau data. Ini bisa termasuk _dependency injection_ (misalnya, `get_it` setup), logging, _analytics_, _crash reporting_, konfigurasi platform, dan lain-lain.
    - **Ketergantungan:** Bergantung pada semua lapisan di dalamnya.
    - **Contoh:** Konfigurasi Firebase, `main.dart` (tempat inisialisasi semua layanan dan _dependency injection_).

- **Dependency Injection:**

  - **Peran:** Teknik di mana objek menyediakan dependensi dari objek lain. Daripada objek membuat dependensinya sendiri, objek tersebut menerima dependensinya dari luar. Ini sangat penting untuk Clean Architecture karena memungkinkan ketergantungan mengalir ke dalam (prinsip DIP) dan membuat kode lebih mudah diuji dan dimodifikasi.
  - **Mekanisme:** Dalam Flutter, _Dependency Injection_ biasanya diimplementasikan menggunakan _Service Locator_ (`get_it`) atau _IoC Containers_ (`injectable`). Lapisan-lapisan luar (misalnya, `Infrastructure`) bertanggung jawab untuk "menyuntikkan" implementasi konkret dari _interface_ (yang didefinisikan di lapisan dalam) ke dalam kelas-kelas yang membutuhkannya.

- **Visualisasi Konseptual: Clean Architecture (Lingkaran Konsentris)**

  ```mermaid
  graph TD
      subgraph Aplikasi [Aplikasi Flutter]
          subgraph Lingkaran Luar
              I[Infrastructure Layer]
              P[Presentation Layer]
          end
          subgraph Lingkaran Tengah
              A[Application / Use Case Layer]
          end
          subgraph Lingkaran Dalam
              D[Domain Layer]
          end
      end

      P --> A
      I --> A
      A --> D
      I --> D

      style D fill:#AEC6CF,stroke:#333,stroke-width:2px,font-weight:bold
      style A fill:#B8D8D8,stroke:#333,stroke-width:2px
      style P fill:#FFE8D6,stroke:#333,stroke-width:2px
      style I fill:#D8E2DC,stroke:#333,stroke-width:2px

      linkStyle 0 stroke:#000,stroke-width:1px,fill:none,stroke-dasharray: 5 5;
      linkStyle 1 stroke:#000,stroke-width:1px,fill:none,stroke-dasharray: 5 5;
      linkStyle 2 stroke:#000,stroke-width:1px,fill:none,stroke-dasharray: 5 5;
      linkStyle 3 stroke:#000,stroke-width:1px,fill:none,stroke-dasharray: 5 5;
  ```

  **Penjelasan Visual:**
  Diagram ini merepresentasikan Clean Architecture sebagai lingkaran konsentris. Lapisan paling dalam (Domain) adalah yang paling independen dan berisi aturan bisnis inti. Setiap lapisan luar bergantung pada lapisan di dalamnya, tetapi lapisan dalam tidak bergantung pada lapisan luar. Ini menjamin pemisahan kekhawatiran yang ketat. Panah putus-putus menunjukkan aliran ketergantungan dari luar ke dalam.

- **Sumber Daya Tambahan:**

  - [Layered Architecture](https://www.baeldung.com/cs/layered-architecture) (Gambaran umum Arsitektur Berlapis)

---

Dengan ini, kita telah menyelesaikan **19.1 Clean Architecture**, termasuk konsep Domain-Driven Design dan struktur berlapisnya. Anda kini memiliki pemahaman dasar tentang bagaimana merancang aplikasi Flutter untuk skalabilitas dan kemudahan _maintainability_ jangka panjang.

Selanjutnya, kita akan masuk ke **19.2 Microservices Integration**, yang akan Mengeksplorasi bagaimana aplikasi Flutter Anda berinteraksi dengan _backend_ yang diorganisir sebagai _microservices_, sebuah pola arsitektur yang sangat umum di lingkungan _enterprise_ modern.

---

### **19.2 Microservices Integration**

- **Peran:** Arsitektur _microservices_ memecah aplikasi monolitik besar menjadi kumpulan layanan kecil yang independen, dapat dideploy, dan dapat diskalakan. Mengintegrasikan aplikasi _frontend_ Flutter dengan _backend microservices_ memerlukan pemahaman tentang pola-pola komunikasi dan ketahanan yang umum digunakan dalam lingkungan terdistribusi.

---

#### **API Gateway Pattern**

- **Peran:** **API Gateway** adalah satu titik masuk (_single entry point_) untuk semua klien yang mengakses layanan _backend microservices_. Daripada klien harus mengetahui dan berkomunikasi dengan setiap _microservice_ secara individual, mereka hanya berinteraksi dengan API Gateway. Gateway kemudian akan merutekan permintaan ke layanan yang sesuai, dan dapat melakukan berbagai fungsi tambahan.

- **Manfaat Utama:**

  - **Penyederhanaan Klien:** Klien tidak perlu mengetahui detail arsitektur _microservices_ internal.
  - **Agregasi Permintaan:** Menggabungkan respons dari beberapa layanan menjadi satu respons untuk klien.
  - **Keamanan:** Sentralisasi otentikasi dan otorisasi.
  - **Ketahanan:** Implementasi _circuit breaker_, _rate limiting_.
  - **Routing Fleksibel:** Kemampuan untuk merutekan permintaan berdasarkan logika bisnis.

- **Mekanisme dan Fungsi yang Sering Disediakan oleh API Gateway:**

  - **Service Discovery:**

    - **Peran:** Mekanisme untuk menemukan lokasi jaringan _microservice_ yang tersedia. Dalam lingkungan _microservices_ yang dinamis, alamat IP layanan dapat berubah.
    - **Mekanisme:** API Gateway dapat berinteraksi dengan **Service Registry** (misalnya, Eureka, Consul) yang melacak _instance_ layanan yang tersedia dan alamatnya. Ketika API Gateway menerima permintaan, ia mencari lokasi layanan target di _registry_ sebelum merutekan permintaan.

  - **Load Balancing:**

    - **Peran:** Mendistribusikan lalu lintas jaringan secara merata di antara beberapa _instance_ dari layanan yang sama untuk mengoptimalkan pemanfaatan sumber daya, memaksimalkan _throughput_, dan meminimalkan waktu respons.
    - **Mekanisme:** API Gateway seringkali memiliki _load balancer_ bawaan atau terintegrasi dengan solusi _load balancing_ eksternal yang memutuskan _instance_ layanan mana yang akan menangani permintaan masuk.

  - **Circuit Breaker Pattern:**

    - **Peran:** Pola desain ketahanan yang mencegah aplikasi terus-menerus mencoba mengakses layanan yang gagal atau tidak responsif, sehingga mencegah kelelahan sumber daya (_resource exhaustion_) dan memungkinkan layanan yang gagal untuk pulih.
    - **Mekanisme:** API Gateway (atau _library_ sisi klien) melacak tingkat keberhasilan/kegagalan panggilan ke layanan. Jika tingkat kesalahan melewati ambang batas tertentu, _circuit breaker_ "membuka", dan semua permintaan berikutnya ke layanan tersebut akan langsung gagal tanpa mencoba memanggil layanan yang sebenarnya, hingga periode _timeout_ berlalu. Setelah itu, _circuit breaker_ "setengah membuka" untuk menguji apakah layanan sudah pulih.

  - **Rate Limiting:**

    - **Peran:** Membatasi jumlah permintaan yang dapat diterima layanan dalam periode waktu tertentu. Ini melindungi _backend_ dari serangan DDoS, penyalahgunaan, dan memastikan _fair usage_.
    - **Mekanisme:** API Gateway dapat dikonfigurasi dengan aturan _rate limiting_ berdasarkan IP klien, _API key_, atau pengguna. Jika jumlah permintaan melebihi batas, gateway akan menolak permintaan dengan status HTTP `429 Too Many Requests`.

  - **Authentication Gateway:**

    - **Peran:** Memusatkan proses otentikasi (memverifikasi identitas pengguna) dan otorisasi (memverifikasi izin pengguna) di satu tempat sebelum permintaan diteruskan ke _microservices_ individual.
    - **Mekanisme:** API Gateway menerima token otentikasi (misalnya, JWT) dari klien, memvalidasinya, dan jika valid, meneruskan permintaan ke layanan _backend_ dengan menyertakan informasi otorisasi. _Microservices_ tidak perlu lagi melakukan otentikasi sendiri, hanya perlu memeriksa otorisasi.

- **Visualisasi Konseptual: API Gateway**

  ```mermaid
  graph TD
      C[Flutter Client App] -- HTTP Requests --> G(API Gateway);
      G -- Route/Transform/Authenticate --> S1[Microservice A];
      G -- Route/Transform/Authenticate --> S2[Microservice B];
      G -- Route/Transform/Authenticate --> S3[Microservice C];

      subgraph Backend Services
          S1; S2; S3;
      end

      style C fill:#FFE8D6,stroke:#333,stroke-width:2px
      style G fill:#D8E2DC,stroke:#333,stroke-width:2px
      style S1 fill:#AEC6CF,stroke:#333,stroke-width:1px
      style S2 fill:#AEC6CF,stroke:#333,stroke-width:1px
      style S3 fill:#AEC6CF,stroke:#333,stroke-width:1px
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana aplikasi Flutter hanya berkomunikasi dengan **API Gateway**. Gateway ini bertindak sebagai perantara, menerima permintaan dari klien, melakukan fungsi seperti otentikasi dan _routing_, lalu meneruskan permintaan ke _microservices_ yang relevan. Ini menyederhanakan logika di sisi klien dan memberikan kontrol terpusat di _backend_.

- **Sumber Daya Tambahan:**

  - [API Gateway Pattern](https://microservices.io/patterns/apigateway.html) (Penjelasan detail tentang API Gateway Pattern oleh Chris Richardson)

---

#### **Event-Driven Architecture (EDA)**

- **Peran:** **Event-Driven Architecture** adalah pola arsitektur di mana komponen sistem berkomunikasi satu sama lain dengan menerbitkan (publishing) dan mengonsumsi (consuming) _event_. Alih-alih panggilan langsung atau permintaan/respons sinkron, layanan merespons _event_ yang terjadi dalam sistem. Ini sangat cocok untuk sistem terdistribusi, meningkatkan decoupling, skalabilitas, dan ketahanan.

- **Konsep Kunci dalam EDA:**

  - **Event Sourcing:**

    - **Peran:** Pola di mana perubahan _state_ aplikasi disimpan sebagai urutan _event_ yang tidak dapat diubah (immutable events), bukan hanya menyimpan _state_ saat ini. _State_ aplikasi dibangun ulang dengan memutar ulang _event-event_ ini.
    - **Mekanisme:** Ketika ada perubahan, sebuah _event_ (misalnya, `OrderCreatedEvent`, `ProductQuantityUpdatedEvent`) dipublikasikan ke _event store_. _Event store_ adalah log _event_ yang hanya bisa ditambahkan (_append-only_). _State_ saat ini dari suatu entitas adalah hasil dari penerapan semua _event_ yang relevan.

  - **CQRS Pattern (Command Query Responsibility Segregation):**

    - **Peran:** Memisahkan model untuk operasi baca (_queries_) dan operasi tulis (_commands_) yang berbeda.
    - **Mekanisme:**
      - **Command:** Merupakan permintaan untuk mengubah _state_ sistem (misalnya, `CreateOrderCommand`, `UpdateProductCommand`). Command diproses oleh model tulis (write model) yang mungkin melibatkan _event sourcing_.
      - **Query:** Merupakan permintaan untuk mendapatkan data (misalnya, `GetOrderDetailsQuery`, `ListAllProductsQuery`). Query diproses oleh model baca (read model), yang seringkali merupakan _database_ atau representasi data yang dioptimalkan untuk kueri (misalnya, _materialized view_).
    - **Manfaat:** Memungkinkan optimasi terpisah untuk operasi baca dan tulis, mendukung skalabilitas, dan sangat cocok dengan _event sourcing_.

  - **Message Queues:**

    - **Peran:** Komponen yang menyimpan _message_ (atau _event_) untuk sementara waktu sampai _consumer_ mengambil dan memprosesnya. Mereka menyediakan komunikasi asinkron antara layanan.
    - **Mekanisme:** _Publisher_ mengirim _message_ ke _queue_. _Consumer_ mendengarkan _queue_ dan mengambil _message_ saat tersedia. Contoh: RabbitMQ, Apache Kafka (untuk _event streaming_).

  - **Event Streaming:**

    - **Peran:** Konsep yang lebih canggih dari _message queues_, di mana _event_ disimpan dalam log yang dapat diputar ulang dan dikonsumsi oleh banyak _consumer_ secara independen, bahkan berulang kali. Ini memungkinkan _event_ menjadi sumber kebenaran untuk sistem terdistribusi.
    - **Mekanisme:** Sistem seperti Apache Kafka adalah _platform event streaming_ populer. _Event_ dipublikasikan ke _topic_ Kafka, dan _consumer group_ dapat membaca _event_ dari _topic_ tersebut.

  - **Saga Pattern:**

    - **Peran:** Pola untuk mengelola transaksi terdistribusi yang melibatkan beberapa layanan. Dalam arsitektur _microservices_, tidak ada transaksi ACID global. Saga memastikan konsistensi data di seluruh layanan yang berbeda.
    - **Mekanisme:** Saga adalah urutan transaksi lokal yang terkoordinasi. Jika salah satu transaksi lokal gagal, saga akan mengeksekusi serangkaian "kompensasi" (transaksi _rollback_) untuk mengembalikan sistem ke _state_ yang konsisten. Ada dua jenis utama:
      - **Choreography-based Saga:** Layanan memublikasikan _event_ dan layanan lain merespons _event_ tersebut secara langsung.
      - **Orchestration-based Saga:** Ada "Orchestrator" pusat yang mengarahkan dan mengoordinasikan eksekusi transaksi lokal di berbagai layanan.

- **Sumber Daya Tambahan:**

  - [Event-Driven Architecture](https://microservices.io/patterns/data/event-driven-architecture.html) (Penjelasan tentang Event-Driven Architecture)

---

Dengan ini, kita telah menyelesaikan **19.2 Microservices Integration**. Anda sekarang memiliki pemahaman tentang bagaimana aplikasi Flutter dapat berinteraksi dengan _backend microservices_ menggunakan pola API Gateway, dan bagaimana arsitektur berbasis _event_ berfungsi. Ini adalah konsep penting untuk membangun sistem yang tangguh dan skalabel.

Selanjutnya, kita akan masuk pada membahas bagaimana mengelola dependensi dalam aplikasi Flutter yang kompleks. Ini akan fokus pada teknik fundamental yang mendukung struktur kode yang bersih dan mudah diuji: _Dependency Injection_.

---

### **19.3 Dependency Injection**

- **Peran:** _Dependency Injection_ (DI) adalah pola desain perangkat lunak di mana sebuah objek (kelas) menerima dependensinya (objek lain yang dibutuhkan untuk berfungsi) dari luar, bukan membuatnya sendiri. Ini adalah prinsip kunci dalam pengembangan perangkat lunak modern karena meningkatkan _decoupling_ (pemisahan) antar komponen, membuat kode lebih mudah diuji, di-_maintain_, dan digunakan kembali.

- **Mengapa DI Penting?**

  - **Loose Coupling:** Kelas tidak secara langsung bergantung pada implementasi spesifik dari dependensinya, tetapi pada abstraksi (interface). Ini membuat kode lebih fleksibel.
  - **Testability:** Anda dapat dengan mudah "menyuntikkan" _mock_ atau _fake dependency_ selama pengujian, tanpa perlu melibatkan implementasi nyata yang mungkin mahal atau lambat.
  - **Reusability:** Komponen dapat digunakan kembali di berbagai konteks karena mereka tidak _hardcoded_ dengan dependensi spesifik.
  - **Maintainability:** Perubahan pada satu dependensi tidak secara langsung memengaruhi banyak kelas lain.

---

#### **Get_it Service Locator**

- **Peran:** **Get_it** adalah _package_ populer di Flutter yang mengimplementasikan pola **Service Locator**. Pola ini menyediakan _registry_ global di mana Anda dapat mendaftarkan _instance_ atau _factory_ dari _service_ Anda. Kemudian, ketika _service_ dibutuhkan, Anda dapat "melokasinya" dari _registry_ tersebut.

- **Mekanisme:**

  1.  **Instalasi:** Tambahkan `get_it` ke `pubspec.yaml` Anda.

  2.  **Inisialisasi Service Locator:** Buat _instance_ global `GetIt`. Biasanya dinamakan `locator` atau `getIt`.

      ```dart
      final GetIt getIt = GetIt.instance;
      ```

  3.  **Registrasi Layanan (_Service Registration_):** Daftarkan _service_ Anda dengan `GetIt`. Ini biasanya dilakukan di awal aplikasi (misalnya, di `main()` atau dalam modul inisialisasi terpisah).

      - **Singleton vs Factory:**

        - **Singleton (`registerSingleton<T>(T instance)` atau `registerLazySingleton<T>(T Function() factoryFunc)`):** Mendaftarkan satu _instance_ dari sebuah kelas. Setiap kali Anda meminta _service_ ini, Anda akan selalu mendapatkan _instance_ yang sama.
          - `registerSingleton`: Membuat _instance_ segera saat pendaftaran.
          - `registerLazySingleton`: Membuat _instance_ hanya saat diminta pertama kali (_lazy loading_). Ini lebih disukai untuk _resource_ yang berat.
          - **Contoh:** `getIt.registerLazySingleton<ApiService>(() => ApiService());`
        - **Factory (`registerFactory<T>(T Function() factoryFunc)`):** Mendaftarkan sebuah _factory_ (fungsi) yang akan membuat _instance_ baru setiap kali _service_ diminta. Berguna untuk _stateful object_ yang mungkin berbeda di setiap penggunaannya.
          - **Contoh:** `getIt.registerFactory<ProductModel>(() => ProductModel());`

      - **Scoped Instances:**

        - **Peran:** Memungkinkan _service_ terdaftar hanya untuk _scope_ tertentu (misalnya, _scope_ per-fitur atau per-sesi pengguna) dan dibuang ketika _scope_ tersebut berakhir. Ini membantu mengelola siklus hidup _resource_ dan mencegah _memory leak_.
        - **Mekanisme:** `GetIt` mendukung _scopes_. Anda bisa membuka _scope_ baru (`getIt.pushScope()`) dan mendaftarkan layanan di dalamnya. Ketika _scope_ ditutup (`getIt.popScope()`), layanan yang terdaftar dalam _scope_ itu akan dibuang (`dispose`).
        - **Contoh:** Ideal untuk _feature-specific services_ atau _data repositories_ yang hanya relevan selama layar tertentu.

      - **Lazy Loading:**

        - **Peran:** Memuat _service_ hanya ketika pertama kali dibutuhkan, bukan saat aplikasi dimulai. Ini dapat mempercepat waktu _startup_ aplikasi.
        - **Mekanisme:** Dicapai dengan `registerLazySingleton` atau `registerFactory`, karena keduanya menggunakan fungsi _factory_ yang hanya dieksekusi saat _service_ pertama kali diminta.

      - **Service Disposal:**

        - **Peran:** Memastikan bahwa _service_ yang memiliki _resource_ yang perlu dibersihkan (misalnya, _stream subscriptions_, _controllers_, koneksi _database_) dibuang dengan benar saat tidak lagi dibutuhkan.
        - **Mekanisme:** Anda dapat menyediakan fungsi `dispose` saat mendaftarkan _singleton_ atau menggunakan `dispose` di _scoped services_.
          ```dart
          getIt.registerLazySingleton<MyDisposableService>(
              () => MyDisposableService(),
              dispose: (service) => service.dispose(),
          );
          ```

  4.  **Penggunaan Layanan (_Service Usage_):** Dapatkan _instance_ _service_ di mana pun Anda membutuhkannya.

      ```dart
      final ApiService apiService = getIt<ApiService>();
      ```

- **Sumber Daya Tambahan:**

  - [Get_it Package](https://pub.dev/packages/get_it) (Halaman _package_ Get_it di pub.dev)
  - [Service Locator Pattern](https://www.google.com/search?q=https://martinfowler.com/articles/injection.html%23ServiceLocator) (Penjelasan pola Service Locator oleh Martin Fowler)

---

#### **Injectable Code Generation**

- **Peran:** **Injectable** adalah _package_ yang mengintegrasikan `get_it` dengan _code generation_. Ini memungkinkan Anda menggunakan anotasi Dart untuk mendeklarasikan bagaimana _dependency_ harus didaftarkan, dan _injectable_ akan secara otomatis menghasilkan kode pendaftaran `get_it` untuk Anda. Ini sangat mengurangi _boilerplate_ dan menjaga konfigurasi DI tetap rapi, terutama di proyek besar.

- **Mekanisme:**

  1.  **Instalasi:** Tambahkan `injectable` dan `injectable_generator` (sebagai `dev_dependency`), dan `build_runner` (juga sebagai `dev_dependency`) ke `pubspec.yaml`.

  2.  **Anotasi Berbasis DI (_Annotation-based DI_):** Tandai kelas Anda dengan anotasi yang disediakan oleh `injectable`.

      - `@Injectable()`: Menandai kelas yang harus didaftarkan di _Service Locator_. Secara _default_, ini akan didaftarkan sebagai `LazySingleton`.
        ```dart
        @injectable
        class ApiService {
          // ...
        }
        ```
      - `@Singleton()`: Secara eksplisit mendaftarkan sebagai _singleton_.
      - `@LazySingleton()`: Secara eksplisit mendaftarkan sebagai _lazy singleton_.
      - `@Factory()`: Secara eksplisit mendaftarkan sebagai _factory_.
      - `@RegisterAs(SomeInterface, env: 'dev')`: Mendaftarkan implementasi konkret sebagai _interface_ tertentu, dan bahkan dapat spesifik untuk lingkungan (misalnya, hanya untuk `dev`).

  3.  **Modul Konfigurasi (_Module Configuration_):** Gunakan `@module` untuk mengatur kelas yang tidak dapat di-constructor secara langsung (misalnya, _instance_ `Dio`, `SharedPreferences`) atau untuk _factory_ yang lebih kompleks.

      ```dart
      @module
      abstract class RegisterModule {
        @lazySingleton
        Dio dio() => Dio(BaseOptions(baseUrl: 'https://api.example.com'));

        @preResolve // Membuat instance sebelum main() dijalankan
        Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
      }
      ```

  4.  **Setup Spesifik Lingkungan (_Environment-specific Setup_):** Anda dapat mendefinisikan _dependency_ yang berbeda untuk lingkungan yang berbeda (misalnya, `dev`, `prod`). Gunakan `environment` _flag_ saat menjalankan _build_runner_ atau pada anotasi.

      ```dart
      @Injectable(as: ApiService, env: [Environment.dev])
      class MockApiService implements ApiService {
        // ... implementasi mock untuk dev
      }

      @Injectable(as: ApiService, env: [Environment.prod])
      class RealApiService implements ApiService {
        // ... implementasi nyata untuk prod
      }
      ```

      Saat _build_runner_, Anda bisa menentukan lingkungan: `flutter pub run build_runner build --delete-conflicting-outputs --flavor prod`.

  5.  **Konfigurasi Pengujian (_Testing Configuration_):** _Injectable_ mempermudah pengujian. Anda dapat dengan mudah mengganti _dependency_ nyata dengan _mock_ atau _fake_ di _test setup_.

      ```dart
      // Test file
      @test
      void myWidgetTest() {
          // Register a mock implementation for testing
          getIt.registerSingleton<ApiService>(MockApiService());
          // ... run test ...
          getIt.reset(); // Reset GetIt setelah test
      }
      ```

  6.  **Menjalankan Code Generation:** Setelah menambahkan anotasi, jalankan _command_ ini untuk menghasilkan kode DI:

      ```bash
      flutter pub run build_runner build --delete-conflicting-outputs
      ```

      Ini akan membuat berkas `.g.dart` dan `.init.dart` yang berisi semua pendaftaran `get_it`.

  7.  **Inisialisasi Root:** Panggil fungsi inisialisasi yang dihasilkan di `main()` Anda:

      ```dart
      import 'package:app_name/di/injection.dart'; // Ganti dengan path Anda

      void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await configureDependencies(); // Fungsi yang dihasilkan oleh Injectable
        runApp(const MyApp());
      }
      ```

- **Visualisasi Konseptual: Injectable Flow**

  ```mermaid
  graph TD
      A[Annotated Classes in Your Code] --> B{Injectable Generator};
      B -- Runs with build_runner --> C[Generated get_it Code (e.g., app_name.g.dart)];
      C --> D[main.dart (calls configureDependencies())];
      D -- Accesses Services --> E[getIt.instance (Service Locator)];
      E -- Provides Dependencies --> F[Your App Running];

      style A fill:#FFE8D6,stroke:#333,stroke-width:2px
      style B fill:#B8D8D8,stroke:#333,stroke-width:2px
      style C fill:#AEC6CF,stroke:#333,stroke-width:2px
      style D fill:#D8E2DC,stroke:#333,stroke-width:2px
      style E fill:#F5F5DC,stroke:#333,stroke-width:2px
      style F fill:#F0F8FF,stroke:#333,stroke-width:2px
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur kerja _Injectable_. Anda (pengembang) hanya perlu menambahkan anotasi ke kelas Anda. _Injectable Generator_ (didukung oleh `build_runner`) membaca anotasi tersebut dan secara otomatis menghasilkan kode _boilerplate_ `get_it`. Kode yang dihasilkan ini kemudian diinisialisasi di `main.dart`, yang mengisi _Service Locator_ (`getIt.instance`), siap untuk menyediakan _dependency_ ke seluruh aplikasi Anda.

- **Sumber Daya Tambahan:**

  - [Injectable Package](https://pub.dev/packages/injectable) (Halaman _package_ Injectable di pub.dev)
  - [Injectable Generator](https://pub.dev/packages/injectable_generator) (Halaman _package_ Injectable Generator di pub.dev)

# Selamat!

Kita telah menyelesaikan seluruh **Fase 12: Advanced Architectural Patterns**!

Anda sekarang memiliki pemahaman yang solid tentang bagaimana membangun aplikasi Flutter yang _scalable_, _maintainable_, dan _testable_ dengan pola arsitektur tingkat lanjut seperti Clean Architecture dan praktik _Dependency Injection_ menggunakan `get_it` dan `injectable`. Ini adalah keterampilan esensial untuk proyek-proyek _enterprise_.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md
[pro12]: ../../pro/bagian-12/README.md

<!----------------------------------------------------->

[0]: ../../README.md
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
